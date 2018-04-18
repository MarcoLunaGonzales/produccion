<%@ page contentType="text/html"%>
<%@ page pageEncoding="UTF-8"%>
<%@ page language="java" %>
<%@ page import="com.cofar.util.*" %>
<%@ page import="com.cofar.web.*" %>
<%@ page import = "java.sql.Connection"%>
<%@ page import = "java.sql.DriverManager"%>
<%@ page import = "java.sql.ResultSet"%>
<%@ page import = "java.sql.Statement"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.text.SimpleDateFormat"%>
<%@ page import = "java.util.ArrayList"%>
<%@ page import = "java.util.Date"%>
<%@ page import = "javax.servlet.http.HttpServletRequest"%>
<%@ page import = "java.text.DecimalFormat"%>
<%@ page import = "java.text.NumberFormat"%>
<%@ page import = "java.util.Locale"%>
<%@ page import="java.lang.Math" %>
<%@ page import="java.util.Calendar"%>
<%@ page import="java.util.GregorianCalendar"%>
<%@ page language="java" import = "org.joda.time.*"%>
<%@ page language="java" import="java.util.*,com.cofar.util.CofarConnection" %>



<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<html>
   <head>
    <link rel="STYLESHEET" type="text/css" href="../../reponse/css/foundation.css" />
    <link rel="STYLESHEET" type="text/css" href="../../reponse/css/AtlasWeb.css" />
    <link rel="STYLESHEET" type="text/css" href="../../reponse/css/border-radius.css" />
    <link rel="STYLESHEET" type="text/css" href="../../reponse/css/timePickerCSs.css" />
    <link rel="STYLESHEET" type="text/css" href="../../reponse/css/mensajejs.css" />
   <script src="../../reponse/js/variables.js"></script>
    <script src="../../reponse/js/utiles.js"></script>
    <script src="../../reponse/js/componentesJs.js"></script>
    <script src="../../reponse/js/validaciones.js"></script>
    <script src="../../reponse/js/websql.js"></script>


<script type="text/javascript">
    function guardarLimpiezaCapsulas(codTipoGuardado)
    {
        iniciarProgresoSistema();
        
         var dataLimpiezaCapsulas=crearArrayTablaFechaHora("dataLimpiezaCapsulas",2);
         if(dataLimpiezaCapsulas==null)
         {
             terminarProgresoSistema();
             return null;
         }
         ajax=nuevoAjax();
         var peticion="ajaxGuardarLimpiezaCapsulas.jsf?codLote="+codLoteGeneral+
                        "&noCache="+ Math.random()+
                        "&date="+(new Date().getTime()).toString()+
                        "&codprogramaProd="+codProgramaProdGeneral+
                        "&codFormulaMaestra="+codFormulaMaestraGeneral+
                        "&codTipoProgramaProd="+codTipoProgramaProdGeneral+
                        "&codCompProd="+codComprodGeneral+
                        "&codActividadLimpiezaCapsulas="+document.getElementById("codActividadLimpiezaCapsulas").value+
                        "&dataLimpiezaCapsulas="+dataLimpiezaCapsulas+
                        "&codTipoGuardado="+codTipoGuardado+
                        "&codTipoPermiso="+(codTipoPermiso)+
                        "&codPersonalUsuario="+codPersonalGeneral+
                        (codTipoPermiso==12?"&observacion="+document.getElementById("observacion").value:"");

        ajax.open("GET",peticion,true);
        ajax.setRequestHeader('content-type', 'application/x-www-form-urlencoded;charset=UTF-8');
                 ajax.onreadystatechange=function(){
                    if (ajax.readyState==4) {
                        if(ajax.responseText==null || ajax.responseText=='')
                        {
                            alertJs('No se puede conectar con el servidor, verfique su conexión a internet');
                            if(confirm("Desea guardar la informacion localmente?\nLa informacion del lote no se perdera pero debe de subirla despues"))
                            {
                                sqlConnection.insertarRegistroAuxiliar(document.getElementById("codprogramaProd").value, codLote,3,("../registroEtapaLavado/"+peticion),function(){window.close();});
                            }
                            terminarProgresoSistema();
                            return false;
                        }
                        if(parseInt(ajax.responseText.split("\n").join(""))=='1')
                        {
                            terminarProgresoSistema();
                            mensajeJs('Se registro limpieza de capsulas',
                            function(){window.close();});
                            return true;
                        }
                        else
                        {
                            terminarProgresoSistema();
                            alertJs(ajax.responseText.split("\n").join(""));
                            return false;
                        }
                    }
                }

                ajax.send(null);

    }
    onerror=errorMessaje;
    function errorMessaje()
    {
        alert('error de javascript');
    }

</script>


</head>
    <body >
        <div style="margin-top:2%;position:fixed;;width:100%;z-index:5;visibility:hidden" id="divImagen">
         <center><img src="../../reponse/img/load2.gif"  style="z-index:6; "><%--margin-top:2%;position:fixed;--%>
         </center>
         </div>

  <%
        //datos personal
        int codPersonal=Integer.valueOf(request.getParameter("codPersonal"));
        int codTipoPermiso=Integer.valueOf(request.getParameter("codTipoPermiso"));
        
        //datos lote produccion
        int codprogramaProd=Integer.valueOf(request.getParameter("codProgramaProd"));
        int codTipoProgramaProd=Integer.valueOf(request.getParameter("codTipoProgramaProd"));
        int codCompProd=Integer.valueOf(request.getParameter("codCompProd"));
        String codLote=request.getParameter("codLote");
        
        
        int codEstadoHoja=0;
        
        out.println("<title>("+codLote+")LIMPIEZA DE CAPSULAS</title>");
        
        String personal="";
        int codFormulaMaestra=0;
        int codPersonalCierre=0;
        String observaciones="";
        Date fechaCierre=new Date();
        char b=13;char c=10;
        NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
        DecimalFormat format = (DecimalFormat)nf;
        format.applyPattern("#,##0.00");

        SimpleDateFormat sdfHora=new SimpleDateFormat("HH:mm");
        SimpleDateFormat sdfDias=new SimpleDateFormat("dd/MM/yyyy");
        int codActividadLimpiezaCapsulas=0;
        int codSeguimientoLimpieza=0;
        Connection con=null;
        try
        {
              
              con=Util.openConnection(con);
              Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
              StringBuilder consulta=new StringBuilder("select pp.cod_formula_maestra,cp.nombre_prod_semiterminado,ff.nombre_forma,cp.VIDA_UTIL,");
                                                consulta.append(" pp.CANT_LOTE_PRODUCCION,tpp.NOMBRE_TIPO_PROGRAMA_PROD,");
                                                consulta.append(" ISNULL(afm.COD_ACTIVIDAD_FORMULA, 0) as codActividaLimpiezaCapsula,");
                                                consulta.append(" isnull(slca.COD_SEGUIMIENTO_LIMPIEZA_CAPSULAS_ACOND, 0) AS COD_SEGUIMIENTO_LIMPIEZA_CAPSULAS_ACOND,");
                                                consulta.append(" ISNULL(slca.COD_PERSONAL_SUPERVISOR, 0) AS COD_PERSONAL_SUPERVISOR,");
                                                consulta.append(" ISNULL(slca.OBSERVACIONES, '') AS OBSERVACIONES,slca.FECHA_CIERRE");
                                        consulta.append(" from PROGRAMA_PRODUCCION pp");
                                                consulta.append(" inner join componentes_prod cp on cp.COD_COMPPROD = pp.COD_COMPPROD");
                                                consulta.append(" inner join FORMAS_FARMACEUTICAS ff on ff.cod_forma = cp.COD_FORMA");
                                                consulta.append(" inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD = pp.COD_TIPO_PROGRAMA_PROD");
                                                consulta.append(" left outer join DESCRIPCION_PROCESOS_FORMA_FARMACEUTICA dpff on dpff.COD_FORMA = cp.COD_FORMA");
                                                consulta.append(" left outer join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_FORMULA_MAESTRA= pp.COD_FORMULA_MAESTRA");
                                                consulta.append(" and afm.COD_AREA_EMPRESA = 84 ");
                                                consulta.append(" and afm.COD_ACTIVIDAD = 27");
                                                consulta.append(" and afm.COD_PRESENTACION = 0");
                                                consulta.append(" left outer join SEGUIMIENTO_LIMPIEZA_CAPSULAS_ACOND slca on slca.COD_PROGRAMA_PROD = pp.COD_PROGRAMA_PROD");
                                                consulta.append(" and slca.COD_LOTE = pp.COD_LOTE_PRODUCCION");
                                                consulta.append(" and slca.COD_COMPPROD = pp.COD_COMPPROD");
                                                consulta.append(" and slca.COD_TIPO_PROGRAMA_PROD = pp.COD_TIPO_PROGRAMA_PROD");
                                        consulta.append(" where pp.COD_LOTE_PRODUCCION='").append(codLote).append("'");
                                                consulta.append(" and pp.COD_PROGRAMA_PROD=").append(codprogramaProd);
                                                consulta.append(" and pp.COD_COMPPROD=").append(codCompProd);
                                                consulta.append(" and pp.COD_TIPO_PROGRAMA_PROD=").append(codTipoProgramaProd);
                System.out.println("consulta cargar datos de limpieza de capsulas "+consulta.toString());
                ResultSet res=st.executeQuery(consulta.toString());
                if(res.next())
                {
                    fechaCierre=(res.getTimestamp("FECHA_CIERRE")!=null?res.getTimestamp("FECHA_CIERRE"):new Date());
                    codPersonalCierre=res.getInt("COD_PERSONAL_SUPERVISOR");
                    observaciones=res.getString("OBSERVACIONES");
                    codActividadLimpiezaCapsulas=res.getInt("codActividaLimpiezaCapsula");
                    codSeguimientoLimpieza=res.getInt("COD_SEGUIMIENTO_LIMPIEZA_CAPSULAS_ACOND");
                    codFormulaMaestra=res.getInt("cod_formula_maestra");
                    if(codActividadLimpiezaCapsulas==0)
                    {
                        out.println("<script type='text/javascript'>alert('No se encuentran asociadas la actividades:Limpieza de Cápsulas');window.close();</script>");
                    }

            %>

<section class="main">
                         <div class="row"  style="margin-top:5px" >
                                <div class="large-12 medium-12 small-12 large-centered medium-centered small-centered columns" >

                                            <div class="row">
                                               <div class="large-12 medium-12 small-12 columns divHeaderClass" >
                                                       <label  class="inline">Registro de Limpieza de Capsulas</label>
                                                </div>
                                            </div>
                                            <div class="row" >
                                                
                                            <div  class="divContentClass large-12 medium-12 small-12 columns">
                                                  
                                                   <table style="width:96%;margin-top:2%" cellpadding="0px" cellspacing="0px">
                                                       <tr>
                                                           <td class="tableHeaderClass" style="text-align:center">
                                                               <span class="textHeaderClass">Lote</span>
                                                           </td>
                                                           <td class="tableHeaderClass" style="text-align:center;">
                                                               <span class="textHeaderClass">Tam. Lote</span>
                                                           </td>
                                                           <td class="tableHeaderClass" style="text-align:center">
                                                               <span class="textHeaderClass">Producto</span>
                                                           </td>
                                                           <td class="tableHeaderClass" style="text-align:center">
                                                               <span class="textHeaderClass">Forma Farmaceútica</span>
                                                           </td>
                                                           <td class="tableHeaderClass" style="text-align:center">
                                                               <span class="textHeaderClass">Tipo Produccion</span>
                                                           </td>
                                                       </tr>
                                                       
                                                       <tr >
                                                           <td class="tableCell" style="text-align:center">
                                                               <span class="textHeaderClassBody"><%=codLote%></span>
                                                           </td>
                                                           <td class="tableCell" style="text-align:center;">
                                                               <span class="textHeaderClassBody"><%=(res.getInt("CANT_LOTE_PRODUCCION"))%></span>
                                                           </td>
                                                           <td class="tableCell" style="text-align:center">
                                                               <span class="textHeaderClassBody"><%=res.getString("nombre_prod_semiterminado")%></span>
                                                           </td>
                                                           <td class="tableCell" style="text-align:center">
                                                               <span class="textHeaderClassBody"><%=res.getString("nombre_forma")%></span>
                                                           </td>
                                                           <td class="tableCell" style="text-align:center">
                                                               <span class="textHeaderClassBody"><%=res.getString("NOMBRE_TIPO_PROGRAMA_PROD")%></span>
                                                           </td>
                                                       </tr>
                                                       </table>
                                                   
                                                    
                                             </div>
                                             </div>
                                         </div>
                            </div>

                              <%
                              }
                              out.println("<script type='text/javascript'>" +
                                "codPersonalGeneral="+codPersonal+";" +
                                "codProgramaProdGeneral='"+codprogramaProd+"';"+
                                "codLoteGeneral='"+codLote+"';"+
                                "codComprodGeneral='"+codCompProd+"';"+
                                "codTipoProgramaProdGeneral='"+codTipoProgramaProd+"';"+
                                "codFormulaMaestraGeneral='"+codFormulaMaestra+"';"+
                                "codTipoPermiso="+codTipoPermiso+";</script>");
                              %>

<div class="row"  style="margin-top:5px" >
            <div class="large-12 medium-12 small-12 large-centered medium-centered small-centered columns" >

                        <div class="row">
                           <div class="large-12 medium-12 small-12 columns divHeaderClass" >
                                   <label  class="inline">LIMPIEZA DE CÁPSULAS</label>
                            </div>
                        </div>
                        <div class="row" >

                        <div  class="divContentClass large-12 medium-12 small-12 columns" style="padding-top:1em;">
                
                         <%
                                  personal=UtilidadesTablet.operariosAreaProduccionAcondicionamientoSelect(st, codTipoPermiso, codPersonal);
                                 
                                 out.println("<script type='text/javascript'>operariosRegistroGeneral=\""+personal+"\";" +
                                             "fechaSistemaGeneral='"+sdfDias.format(new Date())+"'</script>");
                        
                        
                        %>
                        
                    <center>
                         <div class="row" style="margin-top:1em;">
                            <div class="large-12 medium-12 small-12 large-centered medium-centered small-centered columns">
                                <table  style="border:none;width:100%;margin-top:4px;" id="dataLimpiezaCapsulas" cellpadding="0px" cellspacing="0px">
                                        <tr><td colspan="6" class='tableHeaderClass prim ult' style='text-align:center;' ><span class='textHeaderClass'>LIMPIEZA DE CAPSULAS</span></td></tr>
                                        <tr>
                                            <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>OBREROS DE LAVADO</span></td>
                                            <td class='tableHeaderClass' style='text-align:center;' colspan=""><span class='textHeaderClass'>FECHA</span></td>
                                            <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>HORA<br> INICIO</span></td>
                                            <td class='tableHeaderClass' style='text-align:center;' colspan=""><span class='textHeaderClass'>HORA<br> FINAL</span></td>
                                            <td class='tableHeaderClass' style='text-align:center;' colspan=""><span class='textHeaderClass'>HORAS</span></td>
                                            <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>CAPSULAS<BR>LIMPIADAS</span></td>
                                            
                                        </tr>
                                        <%
                                        consulta=new StringBuilder("SELECT sppp.COD_PERSONAL,sppp.COD_REGISTRO_ORDEN_MANUFACTURA,sppp.UNIDADES_PRODUCIDAS,");
                                                            consulta.append(" ISNULL(sppp.UNIDADES_FRV, 0) as CANTIDAD_AMPOLLAS_ROTAS,sppp.FECHA_INICIO,");
                                                            consulta.append(" sppp.FECHA_FINAL, sppp.HORAS_HOMBRE, sppp.COD_LOTE_PRODUCCION");
                                                            consulta.append(" FROM  SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sppp ");
                                                    consulta.append(" where sppp.COD_LOTE_PRODUCCION = '").append(codLote).append("'");
                                                            consulta.append(" and sppp.COD_PROGRAMA_PROD = ").append(codprogramaProd);
                                                            consulta.append(" and sppp.COD_FORMULA_MAESTRA = ").append(codFormulaMaestra);
                                                            consulta.append(" and sppp.COD_ACTIVIDAD_PROGRAMA = ").append(codActividadLimpiezaCapsulas);
                                                            consulta.append(" and sppp.COD_TIPO_PROGRAMA_PROD = ").append(codTipoProgramaProd);
                                                            consulta.append(" and sppp.COD_COMPPROD=").append(codCompProd);
                                                            if(codTipoPermiso<=10)
                                                                    consulta.append(" and sppp.COD_PERSONAL=").append(codPersonal);
                                                    consulta.append(" order by sppp.FECHA_INICIO");
                                        System.out.println("consulta cargar seguimiento ampollas "+consulta.toString());
                                        res=st.executeQuery(consulta.toString());
                                        while(res.next())
                                        {
                                            %>
                                            <tr onclick="seleccionarFila(this);">
                                                        <td class="tableCell"  style="text-align:center">
                                                            <select  id="codLavadop<%=(res.getRow())%>"><%out.println(personal);%></select>
                                                                <%
                                                                out.println("<script>codLavadop"+res.getRow()+".value='"+res.getInt("COD_PERSONAL")+"';</script>");
                                                                 %>
                                                           </td>
                                                           <td class="tableCell"  style="text-align:center;">
                                                                <input  type="tel" value="<%=(res.getTimestamp("FECHA_INICIO")!=null?sdfDias.format(res.getTimestamp("FECHA_INICIO")):"")%>" style="width:7em" id="fechap<%=(res.getRow())%>" onclick="seleccionarDatePickerJs(this)"/>
                                                           </td>
                                                           <td class="tableCell"  style="text-align:center;" align="center">
                                                               <input  type="tel" onclick='seleccionarHora(this);' id="fechaIniAmpolla<%=(res.getRow())%>" value="<%=(res.getTimestamp("FECHA_INICIO")!=null?sdfHora.format(res.getTimestamp("FECHA_INICIO")):"")%>" style="width:6em;"/>
                                                           </td>
                                                           <td class="tableCell"  style="text-align:center;" align="center">
                                                               <input  type="tel" onclick='seleccionarHora(this);' id="fechaFinAmpolla<%=(res.getRow())%>" value="<%=(res.getTimestamp("FECHA_INICIO")!=null?sdfHora.format(res.getTimestamp("FECHA_FINAL")):"")%>" style="width:6em;"/>
                                                           </td >
                                                           <td class="tableCell" style="text-align:center;" align="center">
                                                               <span class="tableHeaderClassBody"><%=(nf.format(res.getDouble("HORAS_HOMBRE")))%></span>
                                                           </td>
                                                           <td class="tableCell"  style="text-align:center;" align="center">
                                                               <input   type="tel"   value="<%=(res.getInt("UNIDADES_PRODUCIDAS"))%>" style="width:6em;display:inherit;"/>
                                                           </td>
                                                        </tr>
                                            <%
                                        }
                                        %>
                                </table>
                               
                                <div class="row" >
                                    <div class="large-5 medium-5 small-4 columns" style="">&nbsp;</div>
                                      <div class="large-1 medium-1 small-2 columns" >
                                            <button  class="small button succes radius buttonMas" onclick="componentesJs.crearRegistroTablaFechaHora('dataLimpiezaCapsulas')">+</button>
                                      </div>
                                      <div class="large-1 medium-1 small-2 columns">
                                            <button   class="small button succes radius buttonMenos" onclick="eliminarRegistroTabla('dataLimpiezaCapsulas');" >-</button>
                                      </div>
                                      <div class="large-5 medium-5 small-4 columns" style="">&nbsp;</div>
                                </div>


                                
                               
                            </div>
                         </div>
                         <center>
                            

                         </center>
                    <input type="hidden" value="<%=(codPersonalCierre)%>" id="cerrado"/>
                    <%
                    if(codTipoPermiso==12)
                    {
                        out.println(UtilidadesTablet.innerHTMLAprobacionJefe(st, (codPersonalCierre>0?codPersonalCierre:codPersonal), sdfDias.format(fechaCierre),sdfHora.format(fechaCierre),observaciones));
                    }
                    %>
                    </center>
                          

                <%
                    
                    out.println("<div class='row' style='margin-top:0px;'>");
                        out.println("<div class='large-6 small-8 medium-10 large-centered medium-centered columns'>");
                            out.println("<div class='row'>");
                                if(codTipoPermiso==12)
                                {
                                    out.println("<div class='large-4 medium-6 small-12 columns'>");
                                        out.println("<button class='small button succes radius buttonAction' onclick='guardarLimpiezaCapsulas(2);' >Aprobar</button>");
                                    out.println("</div>");
                                    out.println("<div class='large-4 medium-6 small-12 columns'>");
                                        out.println("<button class='small button succes radius buttonAction' onclick='guardarLimpiezaCapsulas(1);' >Pre Aprobar</button>");
                                    out.println("</div>");
                                    out.println("<div class='large-4 medium-6 small-12  columns'>");
                                        out.println("<button class='small button succes radius buttonAction' onclick='window.close();' >Cancelar</button>");
                                    out.println("</div>");
                                }
                                else
                                {
                                    out.println("<div class='large-6 medium-6 small-12 columns'>");
                                        out.println("<button class='small button succes radius buttonAction' onclick='guardarLimpiezaCapsulas(0);' >Guardar</button>");
                                    out.println("</div>");
                                    out.println("<div class='large-6 medium-6 small-12  columns'>");
                                        out.println("<button class='small button succes radius buttonAction' onclick='window.close();'>Cancelar</button>");
                                    out.println("</div>");
                                }
                            out.println("</div>");
                        out.println("</div>");
                    out.println("</div >");

                }
                catch(SQLException ex)
                {
                    ex.printStackTrace();
                }
                finally
                {
                    con.close();
                }
                %>
                    

            </div>
    </div>
    </div>
    </div>
    <div  id="formsuper"  class="formSuper" >

          </div>
        <input type="hidden" id="codActividadLimpiezaCapsulas" value="<%=(codActividadLimpiezaCapsulas)%>"/>
        </section>
    </body>
    <script src="../../reponse/js/timePickerJs.js"></script>
    <script src="../../reponse/js/dataPickerJs.js"></script>
    <script src="../../reponse/js/mensajejs.js"></script>
    <script>iniciarDatePicker('<%=(sdfDias.format(new Date()))%>');loginHoja.verificarHojaCerradaAcond('cerrado', administradorSistema,1,<%=(codEstadoHoja)%>);</script>
</html>
