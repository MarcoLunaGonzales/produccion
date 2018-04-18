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

<script src="../../reponse/js/scripts.js"></script>
<link rel="STYLESHEET" type="text/css" href="../../reponse/css/foundation.css" />
<link rel="STYLESHEET" type="text/css" href="../../reponse/css/AtlasWeb.css" />
<link rel="STYLESHEET" type="text/css" href="../../reponse/css/border-radius.css" />
<link rel="STYLESHEET" type="text/css" href="../../reponse/css/timePickerCSs.css" />
<link rel="STYLESHEET" type="text/css" href="../../reponse/css/mensajejs.css" />
<script src="../../reponse/js/variables.js"></script>
<script src="../../reponse/js/utiles.js"></script>
<script src="../../reponse/js/validaciones.js"></script>
<script src="../../reponse/js/websql.js"></script>

<style>
    .bold
    {
        font-weight:bold;
        font-family: 'Arial';
        font-size:12px;
        font-style:normal;

    }
    .normal
    {
        font-weight:400;
        font-family: 'Arial';
        font-size:12px;
        font-style:normal;

    }

</style>
<script type="text/javascript">
    function guardarDevolucionMaterial()
    {
        iniciarProgresoSistema();
        var codLote=document.getElementById('codLoteSeguimiento').value;
        var tablaDevolucion=document.getElementById("dataDevolucion");
        var dataDevolucion=new Array();
        for(var k=1;k<tablaDevolucion.rows.length;k++)
         {
             if((parseInt(tablaDevolucion.rows[k].cells[1].getElementsByTagName('input')[0].value)>0)||(parseInt(tablaDevolucion.rows[k].cells[2].getElementsByTagName('input')[0].value)>0)||
                (parseInt(tablaDevolucion.rows[k].cells[3].getElementsByTagName('input')[0].value)>0)||(tablaDevolucion.rows[k].cells[2].getElementsByTagName('input')[0].value!=''))
             {
                 if(validarRegistroEntero(tablaDevolucion.rows[k].cells[1].getElementsByTagName('input')[0])&&
                    validarRegistroEntero(tablaDevolucion.rows[k].cells[2].getElementsByTagName('input')[0])&&
                    validarRegistroEntero(tablaDevolucion.rows[k].cells[3].getElementsByTagName('input')[0])
                    )
                 {
                     dataDevolucion[dataDevolucion.length]=parseInt(tablaDevolucion.rows[k].cells[1].getElementsByTagName('input')[0].value);
                     dataDevolucion[dataDevolucion.length]=parseInt(tablaDevolucion.rows[k].cells[2].getElementsByTagName('input')[0].value);
                     dataDevolucion[dataDevolucion.length]=parseInt(tablaDevolucion.rows[k].cells[3].getElementsByTagName('input')[0].value);
                     dataDevolucion[dataDevolucion.length]=encodeURIComponent(tablaDevolucion.rows[k].cells[4].getElementsByTagName('input')[0].value);
                     dataDevolucion[dataDevolucion.length]=tablaDevolucion.rows[k].cells[0].getElementsByTagName('input')[0].value;
                 }
                 else
                 {
                    terminarProgresoSistema();
                    return false;
                 }
             }
             
               
                
         }
         ajax=nuevoAjax();
         var peticion="ajaxGuardarDevolucionMaterialAcond.jsf?codLote="+codLote+"&noCache="+ Math.random()+"&date="+(new Date().getTime()).toString()+
             "&codprogramaProd="+document.getElementById("codprogramaProd").value+
             "&codFormulaMaestra="+document.getElementById("codFormulaMaestra").value+"&codTipoProgramaProd="+document.getElementById("codTipoProgramaProd").value+
             "&codCompProd="+document.getElementById("codCompProd").value+
             "&dataDevolucion="+dataDevolucion+
             "&admin="+(administradorSistema?1:0)+
             "&codPersonalUsuario="+codPersonalGeneral+
             (administradorSistema?"&observacion="+encodeURIComponent(document.getElementById("observacion").value):"");

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
                            mensajeJs('Se registro la devolucion de Material',function()
                            {
                                window.close();
                            });
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
        int codTipoPermiso=Integer.valueOf(request.getParameter("codTipoPermiso"));
        int codPersonal=Integer.valueOf(request.getParameter("codPersonal"));
        
        //cargando datos del lote
        int codprogramaProd=Integer.valueOf(request.getParameter("codProgramaProd"));
        int codTipoProgramaProd=Integer.valueOf(request.getParameter("codTipoProgramaProd"));
        int codCompProd=Integer.valueOf(request.getParameter("codCompProd"));
        String codLote=request.getParameter("codLote");
        
        out.println("<script type='text/javascript'>codPersonalGeneral="+codPersonal+";" +
                   "codTipoPermiso="+codTipoPermiso+";</script>");
        int codEstadoHoja=0;
        out.println("<title>("+codLote+")LAVADO DE AMPOLLAS DOSIFICADAS</title>");
        String personal="";
        int codFormulaMaestra=0;
        int codPersonalCierre=0;
        String observaciones="";
        Date fechaCierre=new Date();
        char b=13;char c=10;
        
        //formato numero
        NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
        DecimalFormat format = (DecimalFormat)nf;
        format.applyPattern("#,##0.00");
        SimpleDateFormat sdfHora=new SimpleDateFormat("HH:mm");
        SimpleDateFormat sdfDias=new SimpleDateFormat("dd/MM/yyyy");
        String indicacionesDevolucionMaterial="";
        //out.println("<script>sqlConnection.verificarRegistroPendiente('"+codprogramaProd+"','"+codLote+"',3)</script>");
        //datos propios de la hoja
        int codSeguimientoDevolucionMaterial=0;
        int codSeguimientoRecepcionMaterial=0;
        try
        {
              Connection con=null;
              con=Util.openConnection(con);
              Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
              StringBuilder consulta=new StringBuilder("select pp.cod_formula_maestra,cp.nombre_prod_semiterminado,ff.nombre_forma,");
                                                consulta.append(" cp.VIDA_UTIL,pp.CANT_LOTE_PRODUCCION,tpp.NOMBRE_TIPO_PROGRAMA_PROD,");
                                                consulta.append(" isnull(sdela.COD_SEGUIMIENTO_DEVOLUCION_ES_LOTE_ACOND, 0) AS COD_SEGUIMIENTO_DEVOLUCION_ES_LOTE_ACOND,");
                                                consulta.append(" ISNULL(sdela.COD_PERSONAL_SUPERVISOR, 0) AS COD_PERSONAL_SUPERVISOR,");
                                                consulta.append(" ISNULL(sdela.OBSERVACIONES, '') AS OBSERVACIONES,");
                                                consulta.append(" sdela.FECHA_CIERRE,");
                                                consulta.append(" isnull(seela.COD_SEGUIMIENTO_ENTREGA_ES_LOTE_ACOND, 0) as COD_SEGUIMIENTO_ENTREGA_ES_LOTE_ACOND" );
                                                consulta.append(" ,isnull(dpff.ACOND_INDICACIONES_DEVOLUCION_MATERIAL,'') as ACOND_INDICACIONES_DEVOLUCION_MATERIAL");
                                        consulta.append(" from PROGRAMA_PRODUCCION pp ");
                                                consulta.append(" inner join componentes_prod cp on cp.COD_COMPPROD=pp.COD_COMPPROD ");
                                                consulta.append(" inner join FORMAS_FARMACEUTICAS ff on ff.cod_forma=cp.COD_FORMA");
                                                consulta.append(" inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD" );
                                                consulta.append(" left outer join DESCRIPCION_PROCESOS_FORMA_FARMACEUTICA dpff on dpff.COD_FORMA=cp.COD_FORMA");
                                                consulta.append(" LEFT OUTER JOIN SEGUIMIENTO_ENTREGA_ES_LOTE_ACOND seela on seela.cod_lote =pp.COD_LOTE_PRODUCCION");
                                                consulta.append(" and seela.COD_PROGRAMA_PROD = pp.COD_PROGRAMA_PROD");
                                                consulta.append(" and pp.COD_COMPPROD=seela.COD_COMPPROD and pp.COD_TIPO_PROGRAMA_PROD=seela.COD_TIPO_PROGRAMA_PROD");
                                                consulta.append(" LEFT OUTER JOIN SEGUIMIENTO_DEVOLUCION_ES_LOTE_ACOND sdela on");
                                                consulta.append(" sdela.cod_lote = pp.COD_LOTE_PRODUCCION and sdela.COD_PROGRAMA_PROD =pp.COD_PROGRAMA_PROD");
                                                consulta.append(" and sdela.COD_COMPPROD=pp.COD_COMPPROD and sdela.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD");
                                        consulta.append(" where pp.COD_LOTE_PRODUCCION='").append(codLote).append("'");
                                                consulta.append(" and pp.COD_PROGRAMA_PROD=").append(codprogramaProd);
                                                consulta.append(" and pp.COD_COMPPROD=").append(codCompProd);
                                                consulta.append(" and pp.COD_TIPO_PROGRAMA_PROD=").append(codTipoProgramaProd);
                System.out.println("consulta cargar datos del lote "+consulta.toString());
                ResultSet res=st.executeQuery(consulta.toString());
                    
                if(res.next())
                {
                    indicacionesDevolucionMaterial=res.getString("ACOND_INDICACIONES_DEVOLUCION_MATERIAL");
                    fechaCierre=(res.getTimestamp("FECHA_CIERRE")!=null?res.getTimestamp("FECHA_CIERRE"):new Date());
                    codPersonalCierre=res.getInt("COD_PERSONAL_SUPERVISOR");
                    observaciones=res.getString("OBSERVACIONES");
                    codSeguimientoDevolucionMaterial=res.getInt("COD_SEGUIMIENTO_DEVOLUCION_ES_LOTE_ACOND");
                    codSeguimientoRecepcionMaterial=res.getInt("COD_SEGUIMIENTO_ENTREGA_ES_LOTE_ACOND");
                    codFormulaMaestra=res.getInt("cod_formula_maestra");
                    %>

<section class="main">
                         <div class="row"  style="margin-top:5px" >
                                <div class="large-12 medium-12 small-12 large-centered medium-centered small-centered columns" >

                                            <div class="row">
                                               <div class="large-12 medium-12 small-12 columns divHeaderClass" >
                                                       <label  class="inline">Devolución de Material de Acondicionamiento</label>
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
                              %>

<div class="row"  style="margin-top:5px" >
            <div class="large-12 medium-12 small-12 large-centered medium-centered small-centered columns" >

                        <div class="row">
                           <div class="large-12 medium-12 small-12 columns divHeaderClass" >
                                   <label  class="inline">Devolución de Material de Acondicionamiento</label>
                            </div>
                        </div>
                        <div class="row" >

                        <div  class="divContentClass large-12 medium-12 small-12 columns" style="padding-top:1em;">
                
                        <span ><%=(indicacionesDevolucionMaterial)%></span>
                        
                         <%
                         personal=UtilidadesTablet.operariosAreaProduccionAcondicionamientoSelect(st, codTipoPermiso, codPersonal);
                         out.println("<script type='text/javascript'>operariosRegistro=\""+personal+"\";</script>");
                        
                        
                        %>
                        
                    <center>
                         <div class="row" style="margin-top:1em;">
                            <div class="large-12 medium-12 small-12 large-centered medium-centered small-centered columns">
                                <table  style="border:none;width:100%;margin-top:4px;" id="dataOtrasDevoluciones" cellpadding="0px" cellspacing="0px">
                                        <tr>
                                            <td class='tableHeaderClass prim ult' style='text-align:center;' rowspan="2" ><span class='textHeaderClass'>Materiales Devueltos<br>(Otros usuarios)</span></td>

                                        <%
                                        consulta=new StringBuilder("select distinct p.COD_PERSONAL,(p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL) as nombrePersonal");
                                                            consulta.append(" from PERSONAL p inner join SEGUIMIENTO_DEVOLUCION_ES_LOTE_ACOND_MATERIALES sde");
                                                            consulta.append(" on sde.COD_PERSONAL=p.COD_PERSONAL");
                                                    consulta.append(" where sde.COD_SEGUIMIENTO_DEVOLUCION_ES_LOTE_ACOND=").append(codSeguimientoDevolucionMaterial);
                                                            consulta.append(" and sde.COD_PERSONAL<>").append(codPersonal);
                                                    consulta.append(" order by 2");
                                        System.out.println("consulta buscar otras devoluciones "+consulta.toString());
                                        res=st.executeQuery(consulta.toString());
                                        consulta=new StringBuilder("select m.NOMBRE_MATERIAL");
                                        String subconsulta="";
                                        String condiciones="";
                                        int contDetalle=0;
                                        while(res.next())
                                        {
                                            out.println("<td class='tableHeaderClass' style='text-align:center;' colspan='4' ><span class='textHeaderClass'>"+res.getString("nombrePersonal")+"</span></td>");
                                            contDetalle++;
                                            consulta.append(",sdel").append(res.getRow()).append(".CANTIDAD_DEVUELTA as CANTIDAD_DEVUELTA").append(res.getRow());
                                            consulta.append(",sdel").append(res.getRow()).append(".CANTIDAD_FRV as CANTIDAD_FRV").append(res.getRow());
                                            consulta.append(",sdel").append(res.getRow()).append(".CANTIDAD_FRV_PROVEEDOR as CANTIDAD_FRV_PROVEEDOR").append(res.getRow());
                                            consulta.append(",sdel").append(res.getRow()).append(".OBSERVACIONES as OBSERVACIONES").append(res.getRow());
                                            subconsulta+=" left outer join SEGUIMIENTO_DEVOLUCION_ES_LOTE_ACOND_MATERIALES sdel"+res.getRow()+" on"+
                                                        " sdel"+res.getRow()+".COD_MATERIAL=m.COD_MATERIAL and sdel"+res.getRow()+".COD_PERSONAL='"+res.getInt("COD_PERSONAL")+"'"+
                                                        " and sdel"+res.getRow()+".COD_SEGUIMIENTO_DEVOLUCION_ES_LOTE_ACOND='"+codSeguimientoDevolucionMaterial+"'";
                                            condiciones+=(condiciones.equals("")?"":" or ")+" sdel"+res.getRow()+".CANTIDAD_DEVUELTA>0 or sdel"+res.getRow()+".CANTIDAD_FRV>0" +
                                                        " or sdel"+res.getRow()+".CANTIDAD_FRV_PROVEEDOR > 0 or sdel"+res.getRow()+".OBSERVACIONES <> '' ";
                                        }
                                        out.println("</tr>");
                                        if(!subconsulta.equals(""))
                                        {
                                                for(int i=0;i<contDetalle;i++)out.println("<td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>Cantidad<br>Devuelta</span></td>"+
                                                                                          "<td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>Cantidad<br>FRV</span></td>"+
                                                                                          "<td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>Cantidad<br>FRV<br>Proveedor</span></td>"+
                                                                                          "<td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>Obs.</span></td>");
                                                consulta.append(" from MATERIALES m ").append(subconsulta).append(" where m.COD_MATERIAL in (select  seel.COD_MATERIAL from SEGUIMIENTO_ENTREGA_ES_LOTE_ACOND_MATERIALES seel");
                                                consulta.append(" where seel.COD_SEGUIMIENTO_ENTREGA_ES_LOTE_ACOND = ").append(codSeguimientoRecepcionMaterial).append(")");
                                                consulta.append(" and (").append(condiciones).append(") order by m.NOMBRE_MATERIAL");
                                                System.out.println("consulta materiales "+consulta.toString());
                                                res=st.executeQuery(consulta.toString());
                                                while(res.next())
                                                {
                                                    out.println("<tr><td class='tableCell' style='text-align:center'>" +
                                                                "<span class='tableHeaderClassBody'>"+(res.getString("NOMBRE_MATERIAL"))+"</span></td>");
                                                    for(int i=1;i<=contDetalle;i++)
                                                    {
                                                        out.println("<td class='tableCell' style='text-align:center'><span class='tableHeaderClassBody'>"+res.getInt("CANTIDAD_DEVUELTA"+i)+"</span></td>" +
                                                                    "<td class='tableCell' style='text-align:center'><span class='tableHeaderClassBody'>"+res.getInt("CANTIDAD_FRV"+i)+"</span></td>"+
                                                                    "<td class='tableCell' style='text-align:center'><span class='tableHeaderClassBody'>"+res.getInt("CANTIDAD_FRV_PROVEEDOR"+i)+"</span></td>"+
                                                                    "<td class='tableCell' style='text-align:center'><span class='tableHeaderClassBody'>"+res.getString("OBSERVACIONES"+i)+"</span></td>");
                                                    }
                                                    out.println("</tr>");
                                                }
                                         }

                                        %>
                                </table>
                                <table  style="border:none;width:100%;margin-top:4px;" id="dataDevolucion" cellpadding="0px" cellspacing="0px">
                                        <tr>
                                            <td class='tableHeaderClass prim' style='text-align:center;' ><span class='textHeaderClass'>Material</span></td>
                                            <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>Cantidad<br>Devuelta</span></td>
                                            <td class='tableHeaderClass' style='text-align:center;' colspan=""><span class='textHeaderClass'>Cantidad<br>Enviada<br>a FRV</span></td>
                                            <td class='tableHeaderClass' style='text-align:center;' colspan=""><span class='textHeaderClass'>Cantidad<br>Enviada<br>a FRV<br>Proveedor</span></td>
                                            <td class='tableHeaderClass ult' style='text-align:center;' ><span class='textHeaderClass'>Observaciones</span></td>
                                            
                                            
                                        </tr>
                                        <%
                                        consulta=new StringBuilder("select  m.COD_MATERIAL,m.NOMBRE_MATERIAL,sdem.CANTIDAD_FRV_PROVEEDOR");
                                                            consulta.append(",sdem.CANTIDAD_DEVUELTA,sdem.CANTIDAD_FRV,isnull(sdem.OBSERVACIONES,'') as OBSERVACIONES");
                                                consulta.append(" from SEGUIMIENTO_ENTREGA_ES_LOTE_ACOND_MATERIALES seelam");
                                                            consulta.append(" inner join materiales m on m.COD_MATERIAL=seelam.COD_MATERIAL" );
                                                            consulta.append(" left outer join SEGUIMIENTO_DEVOLUCION_ES_LOTE_ACOND_MATERIALES sdem");
                                                            consulta.append(" on sdem.COD_MATERIAL=seelam.COD_MATERIAL");
                                                            consulta.append(" and sdem.COD_PERSONAL=").append(codPersonal);
                                                            consulta.append(" and sdem.COD_SEGUIMIENTO_DEVOLUCION_ES_LOTE_ACOND=").append(codSeguimientoDevolucionMaterial);
                                                consulta.append(" where seelam.COD_SEGUIMIENTO_ENTREGA_ES_LOTE_ACOND=").append(codSeguimientoRecepcionMaterial);
                                                consulta.append(" group by m.COD_MATERIAL,m.NOMBRE_MATERIAL,sdem.CANTIDAD_FRV_PROVEEDOR,sdem.CANTIDAD_DEVUELTA,sdem.CANTIDAD_FRV,sdem.OBSERVACIONES" );
                                                consulta.append(" order by m.NOMBRE_MATERIAL");

                                        System.out.println("consulta cargar seguimiento devolucion "+consulta.toString());
                                        res=st.executeQuery(consulta.toString());
                                        while(res.next())
                                        {
                                            %>
                                            <tr>
                                                    <td class="tableCell"  style="text-align:center">
                                                        <input type="hidden" value="<%=(res.getInt("COD_MATERIAL"))%>"/>
                                                        <span class="tableHeaderClassBody"><%=(res.getString("NOMBRE_MATERIAL"))%></span>
                                                   </td>
                                                   <td class="tableCell"  style="text-align:center">
                                                       <input type="tel" value="<%=(res.getInt("CANTIDAD_DEVUELTA"))%>"/>
                                                   </td>
                                                   <td class="tableCell"  style="text-align:center">
                                                       <input type="tel" value="<%=(res.getInt("CANTIDAD_FRV"))%>"/>
                                                   </td>
                                                   <td class="tableCell"  style="text-align:center">
                                                       <input type="tel" value="<%=(res.getInt("CANTIDAD_FRV_PROVEEDOR"))%>"/>
                                                   </td>
                                                   <td class="tableCell"  style="text-align:center">
                                                       <input type="text" value="<%=(res.getString("OBSERVACIONES"))%>"/>
                                                   </td>
                                           </tr>
                                            <%
                                        }
                                        %>
                                </table>
                              
                            </div>
                         </div>
                         <center>
                            

                         </center>
                    <input type="hidden" value="<%=(codPersonalCierre)%>" id="cerrado"/>
                   
                    </center>
                          

                <%

                }
                catch(SQLException ex)
                {
                    ex.printStackTrace();
                }
                %>
                    <div class="row" style="margin-top:0px;">
                        <div class="large-6 small-8 medium-10 large-centered medium-centered columns">
                            <div class="row">
                                <div class="large-6 medium-6 small-12 columns">
                                    <button class="small button succes radius buttonAction" onclick="guardarDevolucionMaterial();" >Guardar</button>
                                </div>
                                    <div class="large-6 medium-6 small-12  columns">
                                        <button class="small button succes radius buttonAction" onclick="window.close();" >Cancelar</button>

                                    </div>
                            </div>
                        </div>
                    </div >

            </div>
    </div>
    </div>
    </div>
    <div  id="formsuper" class="formSuper"/>

        <input type="hidden" id="codLoteSeguimiento" value="<%=codLote%>"/>
        <input type="hidden" id="codprogramaProd" value="<%=(codprogramaProd)%>"/>
        <input type="hidden" id="codFormulaMaestra" value="<%=(codFormulaMaestra)%>"/>
        <input type="hidden" id="codTipoProgramaProd" value="<%=(codTipoProgramaProd)%>"/>
        <input type="hidden" id="codCompProd" value="<%=(codCompProd)%>"/>
        <input  type="hidden" id="codSeguimientoDevolucionMaterial" value="<%=(codSeguimientoDevolucionMaterial)%>">
        </section>
    </body>
    <script src="../../reponse/js/timePickerJs.js"></script>
    <script src="../../reponse/js/dataPickerJs.js"></script>
    <script src="../../reponse/js/mensajejs.js"></script>
    <script>iniciarDatePicker('<%=(sdfDias.format(new Date()))%>');
        loginHoja.verificarHojaCerradaAcond('cerrado', admin,11,<%=(codEstadoHoja)%>);
    </script>
</html>
