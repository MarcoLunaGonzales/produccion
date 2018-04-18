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
    function guardarRecepcionES()
    {
        iniciarProgresoSistema();
        var recepcionEs=document.getElementById("dataRecepcciones");
        var dataRecepcion=new Array();
        for(var k=3;(k<recepcionEs.rows.length&&codTipoPermiso<=11);k+=3)
         {
             var codSalida=recepcionEs.rows[k].cells[0].getElementsByTagName("input")[0].value;
             var dataSalida=recepcionEs.rows[k].cells[0].getElementsByTagName("table")[0];
             for(var i=2;i<dataSalida.rows.length;i++)
             {
                if(dataSalida.rows[i].cells[3].getElementsByTagName("input")[0].checked||
                    dataSalida.rows[i].cells[4].getElementsByTagName("input")[0].value!='')
                {
                    dataRecepcion[dataRecepcion.length]=codSalida;
                    dataRecepcion[dataRecepcion.length]=(dataSalida.rows[i].cells[3].getElementsByTagName("input")[0].checked?"1":"0");
                    dataRecepcion[dataRecepcion.length]=dataSalida.rows[i].cells[4].getElementsByTagName("input")[0].value;
                    dataRecepcion[dataRecepcion.length]=dataSalida.rows[i].cells[0].getElementsByTagName("input")[0].value;
                }

             }
         }
         
         ajax=nuevoAjax();
         
         var peticion="ajaxGuardarEntregaMaterialEmpaqueSecundario.jsf?"+
             "codLote="+codLoteGeneral+"&noCache="+ Math.random()+"&date="+(new Date().getTime()).toString()+
             "&codprogramaProd="+codProgramaProdGeneral+
             "&codFormulaMaestra="+codFormulaMaestraGeneral+
             "&codTipoProgramaProd="+codTipoProgramaProdGeneral+
             "&codCompProd="+codComprodGeneral+
             "&dataRecepcion="+dataRecepcion+
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
                            mensajeJs((administradorSistema?'Se registro la aprobacion de la hoja':'Se registro la etapa de entrega de material de Empaque Secundario'),
                            function(){window.close();});
                            
                            
                            return true;
                        }
                        else
                        {
                            alertJs(ajax.responseText.split("\n").join(""));
                            terminarProgresoSistema();
                            return false;
                        }
                    }
                }

                ajax.send(null);

    }
    onerror=errorMessaje;
    function errorMessaje()
    {
        alertJs('error de javascript');
    }



</script>


</head>
    <body >
        <div style="margin-top:2%;position:fixed;;width:100%;z-index:5;visibility:hidden" id="divImagen">
         <center><img src="../../reponse/img/load2.gif"  style="z-index:6; "><%--margin-top:2%;position:fixed;--%>
         </center>
         </div>
      
  <%
        //datos Personal
        int codPersonal=Integer.valueOf(request.getParameter("codPersonal"));
        int codTipoPermiso=Integer.valueOf(request.getParameter("codTipoPermiso"));
        //datos lote
        String codprogramaProd=request.getParameter("codProgramaProd");
        String codTipoProgramaProd=request.getParameter("codTipoProgramaProd");
        String codCompProd=request.getParameter("codCompProd");
        String codLote=request.getParameter("codLote");
        
        out.println("<script type='text/javascript'>codPersonal="+codPersonal+";" +
                   "codTipoPermiso="+codTipoPermiso+";</script>");
        int codEstadoHoja=0;
        out.println("<title>("+codLote+")ENTREGA MATERIAL SECUNDARIO A ACONDICIONAMIENTO</title>");
        String personal="";
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
        int codFormulaMaestra=0;
        //out.println("<script>sqlConnection.verificarRegistroPendiente('"+codprogramaProd+"','"+codLote+"',3)</script>");
        //datos propios de la hoja
        int codSeguimientoEntregaEs=0;
        Connection con=null;
        try
        {
              
                con=Util.openConnection(con);
                Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                StringBuilder consulta=new StringBuilder("select pp.cod_formula_maestra,cp.nombre_prod_semiterminado,ff.nombre_forma,");
                                                    consulta.append(" cp.VIDA_UTIL,pp.CANT_LOTE_PRODUCCION,tpp.NOMBRE_TIPO_PROGRAMA_PROD," );
                                                    consulta.append(" isnull(se.COD_SEGUIMIENTO_ENTREGA_ES_LOTE_ACOND, 0) AS COD_SEGUIMIENTO_ENTREGA_ES_LOTE_ACOND,");
                                                    consulta.append(" ISNULL(se.COD_PERSONAL_SUPERVISOR, 0) AS COD_PERSONAL_SUPERVISOR,");
                                                    consulta.append(" ISNULL(se.OBSERVACIONES, '') AS OBSERVACIONES,");
                                                    consulta.append(" se.FECHA_CIERRE");
                                        consulta.append(" from PROGRAMA_PRODUCCION pp");
                                                consulta.append(" inner join componentes_prod cp on cp.COD_COMPPROD=pp.COD_COMPPROD ");
                                                consulta.append(" inner join FORMAS_FARMACEUTICAS ff on ff.cod_forma=cp.COD_FORMA");
                                                consulta.append(" inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD");
                                                consulta.append(" left outer join DESCRIPCION_PROCESOS_FORMA_FARMACEUTICA dpff on dpff.COD_FORMA=cp.COD_FORMA");
                                                consulta.append(" LEFT OUTER JOIN SEGUIMIENTO_ENTREGA_ES_LOTE_ACOND se on se.cod_lote =");
                                                consulta.append(" pp.COD_LOTE_PRODUCCION and se.COD_PROGRAMA_PROD = pp.COD_PROGRAMA_PROD");
                                                consulta.append(" and pp.COD_COMPPROD=se.COD_COMPPROD and pp.COD_TIPO_PROGRAMA_PROD=se.COD_TIPO_PROGRAMA_PROD");
                                        consulta.append(" where pp.COD_LOTE_PRODUCCION='").append(codLote).append("'");
                                                consulta.append(" and pp.COD_PROGRAMA_PROD=").append(codprogramaProd);
                                                consulta.append(" and pp.COD_COMPPROD=").append(codCompProd);
                                                consulta.append(" and pp.COD_TIPO_PROGRAMA_PROD=").append(codTipoProgramaProd);
                System.out.println("consulta cargar datos del lote "+consulta.toString());
                ResultSet res=st.executeQuery(consulta.toString());
                if(res.next())
                {
                    codFormulaMaestra=res.getInt("COD_FORMULA_MAESTRA");
                    fechaCierre=(res.getTimestamp("FECHA_CIERRE")!=null?res.getTimestamp("FECHA_CIERRE"):new Date());
                    codPersonalCierre=res.getInt("COD_PERSONAL_SUPERVISOR");
                    observaciones=res.getString("OBSERVACIONES");
                    codSeguimientoEntregaEs=res.getInt("COD_SEGUIMIENTO_ENTREGA_ES_LOTE_ACOND");
                    %>

<section class="main">
                         <div class="row"  style="margin-top:5px" >
                                <div class="large-12 medium-12 small-12 large-centered medium-centered small-centered columns" >

                                            <div class="row">
                                               <div class="large-12 medium-12 small-12 columns divHeaderClass" >
                                                       <label  class="inline">Registro de Entrega de Material Secundario</label>
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
                                                               <span class="textHeaderClass">Presentación</span>
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
                        consulta=new StringBuilder("select (p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL+' '+p.nombre2_personal) as nombrePersonal");
                                    consulta.append(" from PERSONAL p");
                                    consulta.append(" where p.COD_PERSONAL='").append(codPersonalCierre>0?codPersonalCierre:codPersonal).append("'");
                        res=st.executeQuery(consulta.toString());
                        String nombrePersonalAprueba="";
                        if(res.next())nombrePersonalAprueba=res.getString("nombrePersonal");
                    %>


<div class="row"  style="margin-top:5px" >
            <div class="large-12 medium-12 small-12 large-centered medium-centered small-centered columns" >

                        <div class="row">
                           <div class="large-12 medium-12 small-12 columns divHeaderClass" >
                                   <label  class="inline">Registro de Entrega de Material Secundario</label>
                            </div>
                        </div>
                        <div class="row" >

                        <div  class="divContentClass large-12 medium-12 small-12 columns" style="padding-top:1em;">
                            <span >Marque la casilla conforme si la cantidad recibida es correcta de lo contrario coloque en observaciones.<br><br></span>
                        
                        
                         <%
                         
                        if(codTipoPermiso<=11)out.println("<span class='textHeaderClassBody' >Personal que verifica entrega:</span><span style='font-weight:normal' class='textHeaderClassBody' >"+(nombrePersonalAprueba)+"</span>");
                        %>
                        
                    <center>
                         <div class="row" style="margin-top:1em;">
                            <div class="large-12 medium-12 small-12 large-centered medium-centered small-centered columns">
                                <table style="border:none;width:100%;margin-top:4px;" id="dataRecepcciones" cellpadding="0px" cellspacing="0px">
                                        <tr>
                                            <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>ENTREGAS DE MATERIAL</span></td>
                                            
                                        </tr>
                                        <%
                                        consulta=new StringBuilder("select sa.COD_SALIDA_ALMACEN,sa.NRO_SALIDA_ALMACEN,sa.FECHA_SALIDA_ALMACEN");
                                                    consulta.append(" from SALIDAS_ALMACEN sa");
                                                    consulta.append(" where sa.COD_ALMACEN in (2,17) and sa.COD_ESTADO_SALIDA_ALMACEN<>2 ");
                                                            consulta.append(" and sa.COD_LOTE_PRODUCCION='").append(codLote).append("'");
                                                    consulta.append("order by sa.NRO_SALIDA_ALMACEN");
                                        System.out.println("consulta cargar salidas Lote "+consulta.toString());
                                        res=st.executeQuery(consulta.toString());
                                        Statement stDetalle=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                        ResultSet resDetalle=null;
                                        while(res.next())
                                        {
                                                out.println("<tr><td>&nbsp;</td></tr><tr><td class='tableHeaderClass' style='border-top-left-radius:1em;border-top-right-radius:1em;text-align:center;' ><span class='textHeaderClass'>Nro Salida:&nbsp;&nbsp;"+res.getString("NRO_SALIDA_ALMACEN")+"<br>Fecha Salida:&nbsp;&nbsp;"+sdfDias.format(res.getTimestamp("FECHA_SALIDA_ALMACEN"))+"</span></td></tr>" +
                                                      "<tr><td class='tableCell' style='border-bottom-left-radius:1em;border-bottom-right-radius:1em;text-align:center;'>" +
                                                      "<input type='hidden' value='"+res.getInt("COD_SALIDA_ALMACEN")+"' />" +
                                                      "<table style='border:none;width:100%;margin-top:4px;' id='dataRecepcion"+res.getRow()+"' cellpadding='0' cellspacing='0'>"+
                                                      " <tr><td class='tableHeaderClass' style='text-align:center;' rowspan='2' ><span class='textHeaderClass'>N°</span></td>"+
                                                      " <td class='tableHeaderClass' style='text-align:center;' rowspan='2' ><span class='textHeaderClass'>MATERIAL</span></td>"+
                                                      " <td class='tableHeaderClass' style='text-align:center;' rowspan='2' ><span class='textHeaderClass'>CANTIDAD<br> SOLICITADA</span></td>"+
                                                      (codTipoPermiso==12?"":" <td class='tableHeaderClass' colspan='2' style='text-align:center;' ><span class='textHeaderClass'>USUARIO<Br>ACTUAL</span></td>"));
                                                String cabecerasPersonal="";
                                                String detallePersonal="";
                                                int contPersonalRegistro=0;
                                              
                                                consulta=new StringBuilder("select p.COD_PERSONAL,(p.AP_PATERNO_PERSONAL+'<br>'+p.ap_materno_personal+'<br>'+p.NOMBRES_PERSONAL) as nombrePersonal");
                                                        consulta.append(" from  SEGUIMIENTO_ENTREGA_ES_LOTE_ACOND_MATERIALES s ");
                                                        consulta.append(" inner join personal p on s.COD_PERSONAL=p.COD_PERSONAL");
                                                        consulta.append(" where s.COD_SEGUIMIENTO_ENTREGA_ES_LOTE_ACOND=").append(codSeguimientoEntregaEs);
                                                        consulta.append(" and s.COD_SALIDA_ALMACEN=").append(res.getInt("COD_SALIDA_ALMACEN"));
                                                        if(codTipoPermiso<=11)
                                                                    consulta.append(" and s.COD_PERSONAL<>").append(codPersonal);
                                                        consulta.append(" group by p.COD_PERSONAL,p.AP_PATERNO_PERSONAL,p.ap_materno_personal,p.NOMBRES_PERSONAL");
                                                        consulta.append(" order by p.AP_PATERNO_PERSONAL,p.ap_materno_personal,p.NOMBRES_PERSONAL");
                                                System.out.println("consulta detalle personal "+consulta.toString());
                                                resDetalle=stDetalle.executeQuery(consulta.toString());
                                                while(resDetalle.next())
                                                {
                                                        cabecerasPersonal+=",sel"+resDetalle.getRow()+".CONFORME as CONFORME"+resDetalle.getRow()+"," +
                                                                           "isnull(sel"+resDetalle.getRow()+".observaciones,'')as observaciones"+resDetalle.getRow();
                                                        detallePersonal+=" left outer join SEGUIMIENTO_ENTREGA_ES_LOTE_ACOND_MATERIALES sel"+resDetalle.getRow()+
                                                                        " on sel"+resDetalle.getRow()+".COD_SALIDA_ALMACEN=sad.COD_SALIDA_ALMACEN and sel"+resDetalle.getRow()+".COD_MATERIAL"+
                                                                        " =sad.COD_MATERIAL and sel"+resDetalle.getRow()+".COD_PERSONAL='"+resDetalle.getInt("COD_PERSONAL")+"'"+
                                                                        " and sel"+resDetalle.getRow()+".COD_SEGUIMIENTO_ENTREGA_ES_LOTE_ACOND='"+codSeguimientoEntregaEs+"'";
                                                        out.println("<td colspan='2' class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>"+resDetalle.getString("nombrePersonal")+"</span></td>");
                                                        contPersonalRegistro=resDetalle.getRow();
                                                }
                                                out.println("</tr><tr>");
                                                for(int i=1;i<=contPersonalRegistro+(codTipoPermiso==12?0:1);i++)
                                                {
                                                    out.println(" <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>CONF.</span></td>"+
                                                                " <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>OBS.</span></td>");
                                                }
                                                out.println("</tr>");
                                              
                                                consulta=new StringBuilder("SELECT sad.COD_MATERIAL,m.NOMBRE_MATERIAL,sad.CANTIDAD_SALIDA_ALMACEN");
                                                            if(codTipoPermiso<=11)
                                                                    consulta.append(",isnull(sel.CONFORME,0) as CONFORME,isnull(sel.OBSERVACIONES,'') as OBSERVACIONES");
                                                            consulta.append(cabecerasPersonal);
                                                            consulta.append("  FROM SALIDAS_ALMACEN_DETALLE sad ");
                                                                    consulta.append(" inner join materiales m on sad.COD_MATERIAL=m.COD_MATERIAL ");
                                                                    if(codTipoPermiso<=11)
                                                                    {
                                                                            consulta.append("left outer join SEGUIMIENTO_ENTREGA_ES_LOTE_ACOND_MATERIALES sel");
                                                                            consulta.append(" on sel.COD_SALIDA_ALMACEN=sad.COD_SALIDA_ALMACEN and sel.COD_MATERIAL");
                                                                            consulta.append(" =sad.COD_MATERIAL and sel.COD_PERSONAL=").append(codPersonal);
                                                                            consulta.append(" and sel.COD_SEGUIMIENTO_ENTREGA_ES_LOTE_ACOND=").append(codSeguimientoEntregaEs);
                                                                    }
                                                                    consulta.append(detallePersonal);
                                                         consulta.append(" where sad.COD_SALIDA_ALMACEN=").append(res.getInt("COD_SALIDA_ALMACEN"));
                                                         consulta.append(" order by m.NOMBRE_MATERIAL");
                                                System.out.println("consulta detalle "+consulta.toString());
                                                resDetalle=stDetalle.executeQuery(consulta.toString());
                                                while(resDetalle.next())
                                                {

                                                          out.println("<tr>"+
                                                                    "<td class='tableCell' style='text-align:center;' align='center'><span style='font-weight:normal' class='textHeaderClassBody'>"+resDetalle.getRow()+"</span>" +
                                                                    "<input type='hidden' value='"+resDetalle.getInt("COD_MATERIAL")+"'/></td>"+
                                                                    "<td class='tableCell' style='text-align:center;' align='center'><span style='font-weight:normal' class='textHeaderClassBody'>"+resDetalle.getString("NOMBRE_MATERIAL")+"</span></td>"+
                                                                    "<td class='tableCell' style='text-align:center;' align='center'><span style='font-weight:normal' class='textHeaderClassBody'>"+nf.format(resDetalle.getDouble("CANTIDAD_SALIDA_ALMACEN"))+"</span></td>");
                                                          if(codTipoPermiso<=11)
                                                          {
                                                              out.println("<td class='tableCell' style='text-align:center;' align='center'><input type='checkbox' style='width:40px;height:40px' "+(resDetalle.getInt("CONFORME")>0?"checked":"")+" /></td>"+
                                                                          "<td class='tableCell' style='text-align:center;' align='center'><input type='text'  value='"+resDetalle.getString("OBSERVACIONES")+"' /></td>");
                                                          }
                                                          for(int i=1;i<=contPersonalRegistro;i++)
                                                          {
                                                              out.println("<td class='tableCell' style='text-align:center;' align='center'><input type='checkbox' disabled style='width:40px;height:40px' "+(resDetalle.getInt("CONFORME"+i)>0?"checked":"")+" /></td>"+
                                                                          "<td class='tableCell' style='text-align:center;' align='center'><span style='font-weight:normal' class='textHeaderClassBody'>"+resDetalle.getString("OBSERVACIONES"+i)+"</span></td>");
                                                          }
                                                           out.println("</tr>");


                                                }
                                                out.println("</table></td></tr>");
                                        }
                                        %>
                                </table>
                               
                            </div>
                         </div>
                         <center>
                            

                         </center>
                    <input type="hidden" value="<%=(codPersonalCierre)%>" id="cerrado"/>
                    <%
                    if(codTipoPermiso==12)
                    {
                        out.println(UtilidadesTablet.innerHTMLAprobacionJefe(st,(codPersonalCierre>0?codPersonalCierre:codPersonal),sdfDias.format(fechaCierre),sdfHora.format(fechaCierre), observaciones));
                    }
                    %>
                    </center>
                          

                <%

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
                    <div class="row" style="margin-top:0px;">
                        <div class="large-6 small-8 medium-10 large-centered medium-centered columns">
                            <div class="row">
                                <div class="large-6 medium-6 small-12 columns">
                                    <button class="small button succes radius buttonAction" onclick="guardarRecepcionES();" >Guardar</button>
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
    <div  id="formsuper"  class="formSuper" />

        </section>
    </body>
    <script src="../../reponse/js/mensajejs.js"></script>
    <script>loginHoja.verificarHojaCerradaAcond('cerrado',administradorSistema,4,<%=(codEstadoHoja)%>);</script>
</html>
