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
    .radioButton {
        margin:0.15em !important;
        margin-left:0.9em !important;
        height:1.3em !important;
        width:1.3em !important;
        display:inline-block;
        cursor:pointer !important;
    }
    .radioButton + label{
        display: inline-block;
        
    }
    .radioButton:checked
    {
        height:1.4em !important;
        width:1.4em !important;
    }
    .radioButton:checked + label{
        background-color: #32CD32 !important;
        font-size:1.2em !important;
    }
</style>
<script type="text/javascript">
    function guardarTimbradoAmpollas(codTipoGuardado)
    {
        iniciarProgresoSistema();
        var contenedor=document.getElementById("dataTimbradoGeneral");
        var dataAmpollasTimbradas=new Array();
        for(var i=1;(i<contenedor.rows.length&&contenedor.rows.length>1);i++)
         {
             if(validarRegistroEntero(contenedor.rows[i].cells[5].getElementsByTagName('input')[0])&&
                   validarFechaRegistro(contenedor.rows[i].cells[1].getElementsByTagName('input')[0])&&
                   validarHoraRegistro(contenedor.rows[i].cells[2].getElementsByTagName('input')[0])&&
                   validarHoraRegistro(contenedor.rows[i].cells[3].getElementsByTagName('input')[0])&&
                   validarRegistrosHorasNoNegativas(contenedor.rows[i].cells[2].getElementsByTagName('input')[0],contenedor.rows[i].cells[3].getElementsByTagName('input')[0]))
            {
                 dataAmpollasTimbradas[dataAmpollasTimbradas.length]=contenedor.rows[i].cells[0].getElementsByTagName('select')[0].value;
                 dataAmpollasTimbradas[dataAmpollasTimbradas.length]=contenedor.rows[i].cells[1].getElementsByTagName('input')[0].value;
                 dataAmpollasTimbradas[dataAmpollasTimbradas.length]=contenedor.rows[i].cells[2].getElementsByTagName('input')[0].value;
                 dataAmpollasTimbradas[dataAmpollasTimbradas.length]=contenedor.rows[i].cells[3].getElementsByTagName('input')[0].value;
                 dataAmpollasTimbradas[dataAmpollasTimbradas.length]=contenedor.rows[i].cells[4].getElementsByTagName('span')[0].innerHTML;
                 dataAmpollasTimbradas[dataAmpollasTimbradas.length]=contenedor.rows[i].cells[5].getElementsByTagName('input')[0].value;
            }
            else
            {
                terminarProgresoSistema();
                return false;
            }
             
         }
         var dataRevisado=null;
        dataRevisado=crearArrayTablaFechaHora("dataRevisadoTimbrado",2);
        
        if(dataRevisado==null)
        {
            terminarProgresoSistema();
            return null;
        }
        var dataPesado=null;
        if(document.getElementById("dataPesadoFrascos")!=null)
        {
            dataPesado=crearArrayTablaFechaHora("dataPesadoFrascos",2);
        }
        ajax=nuevoAjax();
         
         var peticion="ajaxGuardarControlTimbradoEnvasePrimario.jsf?"+
             "codLote="+codLoteGeneral+"&noCache="+ Math.random()+"&date="+(new Date().getTime()).toString()+
             "&codprogramaProd="+codProgramaProdGeneral+
             "&codFormulaMaestra="+codFormulaMaestraGeneral+
             "&codCompProd="+codComprodGeneral+
             "&codTipoProgramaProd="+codTipoProgramaProdGeneral+
             "&codActividadCodificionAmpolla="+document.getElementById("codActividadCodificionAmpolla").value+
             "&codActividadRevisado="+document.getElementById("codActividadRevisado").value+
             "&codActividadPesadoFrascos="+document.getElementById("codActividadPesadoFrascos").value+
             
             
             "&codTipoPermiso="+(codTipoPermiso)+
             "&codTipoGuardado="+codTipoGuardado+
             "&codPersonalUsuario="+codPersonalGeneral+
             (codTipoPermiso==12?"&observacion="+document.getElementById("observacion").value:"");

        ajax.open("POST",peticion,true);
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
                            mensajeJs('Se registro la etapa de timbrado de empaque primario'
                            ,function(){
                                window.close();
                            })
                            return true;
                        }
                        else
                        {
                            alertJs(ajax.responseText.split("\n").join(""),function(){terminarProgresoSistema();});
                            
                            return false;
                        }
                    }
                }
                ajax.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
                ajax.send("dataRevisado="+dataRevisado+"&dataPesado="+dataPesado+"&dataAmpollasTimbradas="+dataAmpollasTimbradas);

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
        int codPersonal=Integer.valueOf(request.getParameter("codPersonal"));
        String codprogramaProd=request.getParameter("codProgramaProd");
        String codTipoProgramaProd=request.getParameter("codTipoProgramaProd");
        String codCompProd=request.getParameter("codCompProd");
        String codLote=request.getParameter("codLote");
        int codTipoPermiso=Integer.valueOf(request.getParameter("codTipoPermiso"));
        int codEstadoHoja=0;
        out.println("<title>("+codLote+")TIMBRADO EMPAQUE PRIMARIO</title>");
        String personal="";
        int codFormulaMaestra=0;
        int codPersonalCierre=0;
        String observaciones="";
        Date fechaCierre=new Date();
        char b=13;char c=10;
        int codPersonalApruebaDespeje=0;
        NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
        DecimalFormat format = (DecimalFormat)nf;
        format.applyPattern("#,##0.00");
        SimpleDateFormat sdfHora=new SimpleDateFormat("HH:mm");
        SimpleDateFormat sdfDias=new SimpleDateFormat("dd/MM/yyyy");
        String indicacionesDespejeLinea="";
        int codActividadCodificionAmpolla=0;
        int codActividadRevisado=0;
        int codActividadPesadoFrascos=0;
        String indicacionesTimbradoEP="";
        int codSeguimientoTimbrado=0;
        Connection con=null;
        try
        {
              
              con=Util.openConnection(con);
              Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
              StringBuilder consulta=new StringBuilder("select pp.cod_formula_maestra,cp.nombre_prod_semiterminado,ff.nombre_forma,cp.COD_FORMA,");
                                                consulta.append(" cp.VIDA_UTIL,pp.CANT_LOTE_PRODUCCION,tpp.NOMBRE_TIPO_PROGRAMA_PROD," );
                                                consulta.append(" isnull(dpff.ACOND_INDICACIONES_TIMBRADO_EP, '') as ACOND_INDICACIONES_TIMBRADO_EP,");
                                                consulta.append(" isnull(afm.COD_ACTIVIDAD_FORMULA, 0) as actividadCodificacionAmpollas,");
                                                consulta.append(" isnull(afm1.COD_ACTIVIDAD_FORMULA, 0) as actividadRevisado,");
                                                consulta.append(" isnull(afm2.COD_ACTIVIDAD_FORMULA, 0) as codActividadPesajeFrascos,");
                                                consulta.append(" isnull(stl.COD_SEGUIMIENTO_TIMBRADO_EP_LOTE_ACOND, 0) AS COD_SEGUIMIENTO_TIMBRADO_EP_LOTE_ACOND,");
                                                consulta.append(" ISNULL(stl.COD_PERSONAL_SUPERVISOR, 0) AS COD_PERSONAL_SUPERVISOR,");
                                                consulta.append(" ISNULL(stl.OBSERVACIONES, '') AS OBSERVACIONES,stl.FECHA_CIERRE,");
                                                consulta.append(" stl.COD_ESTADO_HOJA");
                                        consulta.append(" from PROGRAMA_PRODUCCION pp");
                                                consulta.append(" inner join componentes_prod cp on cp.COD_COMPPROD=pp.COD_COMPPROD ");
                                                consulta.append(" inner join FORMAS_FARMACEUTICAS ff on ff.cod_forma=cp.COD_FORMA");
                                                consulta.append(" inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD");
                                                consulta.append(" left outer join DESCRIPCION_PROCESOS_FORMA_FARMACEUTICA dpff on dpff.COD_FORMA=cp.COD_FORMA");
                                                consulta.append(" left outer join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_AREA_EMPRESA =84 and afm.COD_ACTIVIDAD = 314" );
                                                        consulta.append(" and afm.COD_FORMULA_MAESTRA = pp.COD_FORMULA_MAESTRA and afm.COD_PRESENTACION = 0");
                                                consulta.append(" left outer join ACTIVIDADES_FORMULA_MAESTRA afm1 on afm1.COD_AREA_EMPRESA =84 and afm1.COD_ACTIVIDAD = 315 " );
                                                        consulta.append(" and afm1.COD_FORMULA_MAESTRA =pp.COD_FORMULA_MAESTRA and afm1.COD_PRESENTACION = 0");
                                                consulta.append(" left outer join ACTIVIDADES_FORMULA_MAESTRA afm2 on afm2.COD_AREA_EMPRESA =84 and afm2.COD_ACTIVIDAD = 183 " );//pesaje de frascos
                                                        consulta.append(" and afm2.COD_FORMULA_MAESTRA =pp.COD_FORMULA_MAESTRA and afm2.COD_PRESENTACION = 0");
                                                consulta.append(" LEFT OUTER JOIN SEGUIMIENTO_TIMBRADO_EP_LOTE_ACOND stl on stl.cod_lote =pp.COD_LOTE_PRODUCCION" );
                                                consulta.append(" and stl.COD_PROGRAMA_PROD = pp.COD_PROGRAMA_PROD" );
                                                consulta.append(" and pp.COD_COMPPROD=stl.COD_COMPPROD and pp.COD_TIPO_PROGRAMA_PROD=stl.COD_TIPO_PROGRAMA_PROD");
                                        consulta.append(" where pp.COD_LOTE_PRODUCCION='").append(codLote).append("'");
                                                consulta.append(" and pp.COD_PROGRAMA_PROD=").append(codprogramaProd);
                                                consulta.append(" and pp.COD_COMPPROD=").append(codCompProd);
                                                consulta.append(" and pp.COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"'");
                System.out.println("consulta cargar datos del lote "+consulta.toString());
                ResultSet res=st.executeQuery(consulta.toString());
                int codForma=0;
                if(res.next())
                {
                    codActividadPesadoFrascos=res.getInt("codActividadPesajeFrascos");
                    codForma=res.getInt("COD_FORMA");
                    codActividadRevisado=res.getInt("actividadRevisado");
                    codEstadoHoja=res.getInt("COD_ESTADO_HOJA");
                    fechaCierre=(res.getTimestamp("FECHA_CIERRE")!=null?res.getTimestamp("FECHA_CIERRE"):new Date());
                    codPersonalCierre=res.getInt("COD_PERSONAL_SUPERVISOR");
                    observaciones=res.getString("OBSERVACIONES");
                    codSeguimientoTimbrado=res.getInt("COD_SEGUIMIENTO_TIMBRADO_EP_LOTE_ACOND");
                    codActividadCodificionAmpolla=res.getInt("actividadCodificacionAmpollas");
                    indicacionesTimbradoEP=res.getString("ACOND_INDICACIONES_TIMBRADO_EP").replace(b,'\n').replace("\n", "</br>").replace("</br></br>","<br>");
                    codFormulaMaestra=res.getInt("cod_formula_maestra");
                    if(codActividadCodificionAmpolla==0)
                        codActividadCodificionAmpolla=UtilidadesTablet.crearActividadFormulaMaestraAcondicionamiento(codFormulaMaestra,314);
                    if(codActividadCodificionAmpolla==0)
                    {
                        out.println("<script type='text/javascript'>alert('No se encuentran asociada la actividad:CODIFICADO DE EMPAQUE PRIMARIO');window.close();</script>");
                    }
                    if(codActividadRevisado==0)
                        codActividadRevisado=UtilidadesTablet.crearActividadFormulaMaestraAcondicionamiento(codFormulaMaestra,315);
                    if(codActividadRevisado==0)
                    {
                        out.println("<script type='text/javascript'>alert('No se encuentran asociada la actividad:REVISADO DE EMPAQUE PRIMARIO');window.close();</script>");
                    }
                %>

<section class="main">
    
                         <div class="row"  style="margin-top:5px" >
                                <div class="large-12 medium-12 small-12 large-centered medium-centered small-centered columns" >

                                            <div class="row">
                                               <div class="large-12 medium-12 small-12 columns divHeaderClass" >
                                                       <label  class="inline">Control de Timbrado de Producto en Envase Primario</label>
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
                              %>

<div class="row"  style="margin-top:5px" >
            <div class="large-12 medium-12 small-12 large-centered medium-centered small-centered columns" >

                        <div class="row">
                           <div class="large-12 medium-12 small-12 columns divHeaderClass" >
                                   <label  class="inline">Control de Timbrado de Producto en Envase Primario</label>
                            </div>
                        </div>
                        <div class="row" >

                        <div  class="divContentClass large-12 medium-12 small-12 columns" style="padding-top:1em;">
                
                        <span ><%=(indicacionesTimbradoEP)%></span>
                        
                         <%
                         personal=UtilidadesTablet.operariosAreaProduccionAcondicionamientoSelect(st, codTipoPermiso, codPersonal);
                         out.println("<script type='text/javascript'>operariosRegistroGeneral=\""+personal+"\";fechaSistemaGeneral='"+sdfDias.format(new Date())+"'</script>");
                        
                        
                        %>
                        
                    <center>
                         <div class="row" style="margin-top:1em;">
                            <div class="large-12 medium-12 small-12 large-centered medium-centered small-centered columns">
                                <table style="border:none;width:100%;margin-top:4px;" id="dataTimbradoGeneral" cellpadding="0px" cellspacing="0px">
                                        
                                        <%
                                           out.println(" <tr><td class='tableHeaderClass prim' style='text-align:center;' ><span class='textHeaderClass'>OPERARIO<br>TIMBRADO</span></td>"+
                                                    " <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>FECHA</span></td>"+
                                                    " <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>HORA<br> INICIO</span></td>"+
                                                    " <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>HORA<br> FINAL</span></td>"+
                                                    " <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>HORAS</span></td>"+
                                                    " <td class='tableHeaderClass ult' style='text-align:center;' ><span class='textHeaderClass'>CANTIDAD<br>TIMBRADA</span></td>"+
                                                    "</tr>");
                                            consulta=new StringBuilder("select sppp.COD_TIPO_PROGRAMA_PROD,sppp.COD_PERSONAL,sppp.FECHA_INICIO,sppp.FECHA_FINAL,sppp.HORAS_HOMBRE,sppp.UNIDADES_PRODUCIDAS");
                                                        consulta.append(" from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sppp");
                                                                consulta.append(" where sppp.COD_LOTE_PRODUCCION='").append(codLote).append("'");
                                                                consulta.append(" and sppp.COD_PROGRAMA_PROD=").append(codprogramaProd);
                                                                consulta.append(" and sppp.COD_ACTIVIDAD_PROGRAMA=").append(codActividadCodificionAmpolla);
                                                                consulta.append(" and sppp.COD_FORMULA_MAESTRA=").append(codFormulaMaestra);
                                                                consulta.append(" and sppp.COD_COMPPROD=").append(codCompProd);
                                                                consulta.append(" and sppp.COD_TIPO_PROGRAMA_PROD=").append(codTipoProgramaProd);
                                                                if(codTipoPermiso<=10)
                                                                        consulta.append(" and sppp.COD_PERSONAL=").append(codPersonal);
                                                                consulta.append(" order by sppp.FECHA_INICIO");
                                                                
                                            System.out.println("consulta detalle "+consulta.toString());
                                            res=st.executeQuery(consulta.toString());
                                            while(res.next())
                                            {
                                                out.println("<tr onclick=\"seleccionarFila(this);\"><td class='tableCell'  style='text-align:center'><select  id='pTimn"+res.getRow()+"'>"+personal+"</select>"+
                                                            "<script>pTimn"+res.getRow()+".value='"+res.getInt("COD_PERSONAL")+"';</script>"+
                                                            "</td> <td class='tableCell'  style='text-align:center'>"+
                                                            " <input  type='tel' value='"+sdfDias.format(res.getTimestamp("FECHA_INICIO"))+"' size='10' id='fecha"+res.getRow()+"n' style='width:7em;'/>"+
                                                            " </td> <td class='tableCell' style='text-align:center;' align='center'>"+
                                                            " <input  type='tel' onclick='seleccionarHora(this);' onfocus='calcularHorasFilaInicio(this)'  id='fechaIniAmpolla"+res.getRow()+"n' value='"+sdfHora.format(res.getTimestamp("FECHA_INICIO"))+"' style='width:6em;display:inherit;'/>"+
                                                            " </td> <td class='tableCell'  style='text-align:center;' align='center'>" +
                                                            " <input  type='tel' onfocus='calcularHorasFilaFinal(this)'  onclick='seleccionarHora(this);' id='fechaFinAmpolla"+res.getRow()+"n' value='"+sdfHora.format(res.getTimestamp("FECHA_FINAL"))+"' style='width:6em;display:inherit;'/></td >" +
                                                            "</td>"+
                                                            " <td class='tableCell' style='text-align:center;' align='center'>"+
                                                            " <span class='tableHeaderClassBody'>"+nf.format(res.getDouble("HORAS_HOMBRE"))+"</span></td>" +
                                                            "<td class='tableCell'  style='text-align:center !important;' align='center'>" +
                                                            "<input type='tel'   value='"+res.getInt("UNIDADES_PRODUCIDAS")+"' style='width:6em;display:inherit;'/></td>" +
                                                            "</tr>");
                                                
                                            }
                                            %>
                                            </table>
                                            
                                                        <div class='row' ><div class='large-5 medium-5 small-4 columns' style=''>&nbsp;</div><div class='large-1 medium-1 small-2 columns' >
                                                                <button  class='small button succes radius buttonMas' onclick="componentesJs.crearRegistroTablaFechaHora('dataTimbradoGeneral')">+</button>
                                                        </div><div class='large-1 medium-1 small-2 columns'>
                                                        <button  class='small button succes radius buttonMenos' onclick="eliminarRegistroTabla('dataTimbradoGeneral');">-</button></div>
                                                        <div class='large-5 medium-5 small-4 columns' style=''>&nbsp;</div></div>
                                            
                                            
                                                <%
                                                //revisado de ampollas solo para acondicionamientoCentral
                                                out.println("<table style='border:none;width:100%;margin-top:4px;' id='dataRevisadoTimbrado' cellpadding='0px' cellspacing='0px'>" +
                                                                " <tr><td colspan='6' class='tableHeaderClass prim ult'  ><span class='textHeaderClass'>REVISADO EMPAQUE PRIMARIO</span></td></tr>" +
                                                                    "</tr><td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>OPERARIO</span></td>"+
                                                                    " <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>FECHA</span></td>"+
                                                                    " <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>HORA<br> INICIO</span></td>"+
                                                                    " <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>HORA<br> FINAL</span></td>"+
                                                                    " <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>HORAS</span></td>"+
                                                                    " <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>CANTIDAD</span></td>"+
                                                                    "</tr>");
                                                    consulta=new StringBuilder("select sppp.COD_TIPO_PROGRAMA_PROD,sppp.COD_PERSONAL,sppp.FECHA_INICIO,sppp.FECHA_FINAL,sppp.HORAS_HOMBRE,sppp.UNIDADES_PRODUCIDAS");
                                                            consulta.append(" from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sppp");
                                                                    consulta.append(" where sppp.COD_LOTE_PRODUCCION='").append(codLote).append("'");
                                                                    consulta.append(" and sppp.COD_PROGRAMA_PROD=").append(codprogramaProd);
                                                                    consulta.append(" and sppp.COD_ACTIVIDAD_PROGRAMA=").append(codActividadRevisado);
                                                                    consulta.append(" and sppp.COD_FORMULA_MAESTRA=").append(codFormulaMaestra);
                                                                    consulta.append(" and sppp.COD_COMPPROD=").append(codCompProd);
                                                                    consulta.append(" and sppp.COD_TIPO_PROGRAMA_PROD=").append(codTipoProgramaProd);
                                                                    if(codTipoPermiso<=10)
                                                                        consulta.append(" and sppp.COD_PERSONAL=").append(codPersonal);
                                                                    consulta.append(" order by sppp.FECHA_INICIO");
                                                    System.out.println("consulta detalle "+consulta.toString());
                                                    res=st.executeQuery(consulta.toString());
                                                    while(res.next())
                                                    {
                                                        out.println("<tr onclick=\"seleccionarFila(this);\"><td class='tableCell'  style='text-align:center'><select  id='pControl"+res.getRow()+"'>"+personal+"</select>"+
                                                                    "<script>pControl"+res.getRow()+".value='"+res.getInt("COD_PERSONAL")+"';</script>"+
                                                                    "</td> <td class='tableCell'  style='text-align:center'>"+
                                                                    " <input  type='tel' value='"+sdfDias.format(res.getTimestamp("FECHA_INICIO"))+"' size='10' id='fechaControl"+res.getRow()+"n' style='width:7em;'/>"+
                                                                    " </td> <td class='tableCell' style='text-align:center;' align='center'>"+
                                                                    " <input  type='tel' onclick='seleccionarHora(this);' onfocus='calcularHorasFilaInicio(this)' id='fechaIniControl"+res.getRow()+"n' value='"+sdfHora.format(res.getTimestamp("FECHA_INICIO"))+"' style='width:6em;display:inherit;'/>"+
                                                                    " </td> <td class='tableCell'  style='text-align:center;' align='center'>" +
                                                                    " <input  type='tel' onfocus='calcularHorasFilaFinal(this)' onclick='seleccionarHora(this);' id='fechaFinControl"+res.getRow()+"n' value='"+sdfHora.format(res.getTimestamp("FECHA_FINAL"))+"' style='width:6em;display:inherit;'/></td >" +
                                                                    "</td>"+
                                                                    " <td class='tableCell' style='text-align:center;' align='center'>"+
                                                                    " <span class='tableHeaderClassBody'>"+nf.format(res.getDouble("HORAS_HOMBRE"))+"</span></td>" +
                                                                    "<td class='tableCell'  style='text-align:center !important;' align='center'>" +
                                                                    "<input  type='tel'   value='"+res.getInt("UNIDADES_PRODUCIDAS")+"' style='width:6em;display:inherit;'/></td>" +
                                                                    "</tr>");

                                                    }
                                                    out.println("</table>"+
                                                                " <div class='row' ><div class='large-5 medium-5 small-4 columns' style=''>&nbsp;</div><div class='large-1 medium-1 small-2 columns' >"+
                                                                " <button  class='small button succes radius buttonMas' onclick='componentesJs.crearRegistroTablaFechaHora(\"dataRevisadoTimbrado\")'>+</button>"+
                                                                " </div><div class='large-1 medium-1 small-2 columns'>"+
                                                                " <button class='small button succes radius buttonMenos' onclick='eliminarRegistroTabla(\"dataRevisadoTimbrado\");'>-</button></div>"+
                                                                " <div class='large-5 medium-5 small-4 columns' style=''>&nbsp;</div></div>");
                                                    //pesado de frascos SOLO PARA SOLUCION OFTALMICA Y SOLUCION OTICA
                                                    if(codForma==25 ||codForma==27)
                                                    {
                                                        if(codActividadPesadoFrascos==0)
                                                            codActividadPesadoFrascos=UtilidadesTablet.crearActividadFormulaMaestraAcondicionamiento(codFormulaMaestra, 183);//pesaje de frascos
                                                        if(codActividadPesadoFrascos==0)
                                                            out.println("<script type='text/javascript'>alert('No se encuentran asociada la actividad:PESAJE DE FRASCOS');window.close();</script>");
                                                        out.println("<table style='border:none;width:100%;margin-top:4px;' id='dataPesadoFrascos' cellpadding='0px' cellspacing='0px'>" +
                                                                " <tr><td colspan='6' class='tableHeaderClass prim ult'  ><span class='textHeaderClass'>PESADO DE FRASCOS</span></td></tr>" +
                                                                    "</tr><td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>OPERARIO</span></td>"+
                                                                    " <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>FECHA</span></td>"+
                                                                    " <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>HORA<br> INICIO</span></td>"+
                                                                    " <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>HORA<br> FINAL</span></td>"+
                                                                    " <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>HORAS</span></td>"+
                                                                    " <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>CANTIDAD</span></td>"+
                                                                    "</tr>");
                                                        consulta=new StringBuilder("select sppp.COD_TIPO_PROGRAMA_PROD,sppp.COD_PERSONAL,sppp.FECHA_INICIO,sppp.FECHA_FINAL,sppp.HORAS_HOMBRE,sppp.UNIDADES_PRODUCIDAS");
                                                            consulta.append(" from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sppp");
                                                                    consulta.append(" where sppp.COD_LOTE_PRODUCCION='").append(codLote).append("'");
                                                                    consulta.append(" and sppp.COD_PROGRAMA_PROD=").append(codprogramaProd);
                                                                    consulta.append(" and sppp.COD_ACTIVIDAD_PROGRAMA=").append(codActividadPesadoFrascos);
                                                                    consulta.append(" and sppp.COD_FORMULA_MAESTRA=").append(codFormulaMaestra);
                                                                    consulta.append(" and sppp.COD_COMPPROD=").append(codCompProd);
                                                                    consulta.append(" and sppp.COD_TIPO_PROGRAMA_PROD=").append(codTipoProgramaProd);
                                                                    if(codTipoPermiso<=10)
                                                                        consulta.append(" and sppp.COD_PERSONAL=").append(codPersonal);
                                                                    consulta.append(" order by sppp.FECHA_INICIO");
                                                        System.out.println("consulta detalle "+consulta.toString());
                                                        res=st.executeQuery(consulta.toString());
                                                        while(res.next())
                                                        {
                                                            out.println("<tr onclick=\"seleccionarFila(this);\"><td class='tableCell'  style='text-align:center'><select  id='pPesaje"+res.getRow()+"'>"+personal+"</select>"+
                                                                        "<script>pPesaje"+res.getRow()+".value='"+res.getInt("COD_PERSONAL")+"';</script>"+
                                                                        "</td> <td class='tableCell'  style='text-align:center'>"+
                                                                        " <input  type='tel' value='"+sdfDias.format(res.getTimestamp("FECHA_INICIO"))+"' size='10' id='fechaPesaje"+res.getRow()+"n' style='width:7em;'/>"+
                                                                        " </td> <td class='tableCell' style='text-align:center;' align='center'>"+
                                                                        " <input  type='tel' onclick='seleccionarHora(this);' onfocus='calcularHorasFilaInicio(this)' id='fechaIniPesaje"+res.getRow()+"n' value='"+sdfHora.format(res.getTimestamp("FECHA_INICIO"))+"' style='width:6em;display:inherit;'/>"+
                                                                        " </td> <td class='tableCell'  style='text-align:center;' align='center'>" +
                                                                        " <input  type='tel' onfocus='calcularHorasFilaFinal(this)' onclick='seleccionarHora(this);' id='fechaFinPesaje"+res.getRow()+"n' value='"+sdfHora.format(res.getTimestamp("FECHA_FINAL"))+"' style='width:6em;display:inherit;'/></td >" +
                                                                        "</td>"+
                                                                        " <td class='tableCell' style='text-align:center;' align='center'>"+
                                                                        " <span class='tableHeaderClassBody'>"+nf.format(res.getDouble("HORAS_HOMBRE"))+"</span></td>" +
                                                                        "<td class='tableCell'  style='text-align:center !important;' align='center'>" +
                                                                        "<input  type='tel'   value='"+res.getInt("UNIDADES_PRODUCIDAS")+"' style='width:6em;display:inherit;'/></td>" +
                                                                        "</tr>");

                                                        }
                                                        out.println("</table>"); 
                                                        out.println("</table>"+
                                                                " <div class='row' ><div class='large-5 medium-5 small-4 columns' style=''>&nbsp;</div><div class='large-1 medium-1 small-2 columns' >"+
                                                                " <button  class='small button succes radius buttonMas' onclick='componentesJs.crearRegistroTablaFechaHora(\"dataPesadoFrascos\")'>+</button>"+
                                                                " </div><div class='large-1 medium-1 small-2 columns'>"+
                                                                " <button class='small button succes radius buttonMenos' onclick='eliminarRegistroTabla(\"dataPesadoFrascos\");'>-</button></div>"+
                                                                " <div class='large-5 medium-5 small-4 columns' style=''>&nbsp;</div></div>");
                                                    }
                                                %>
                                            
                                
                            </div>
                         </div>
                         <center>
                            

                         </center>
                    <input type="hidden" value="<%=(codPersonalCierre)%>" id="cerrado"/>
                    <%
                        if(codTipoPermiso==12)
                         {
                           out.println(UtilidadesTablet.innerHTMLAprobacionJefe(st, (codPersonalCierre>0?codPersonalCierre:codPersonal),sdfDias.format(new Date()),sdfHora.format(new Date()),observaciones));
                         }
                    %>
                    </center>
                          

                <%
                    out.println("<div class='row' style='margin-top:0px;'>");
                        out.println("<div class='large-6 small-10 medium-8 large-centered medium-centered small-centered columns'>");
                            out.println("<div class='row'>");
                                if(codTipoPermiso==12)
                                {
                                    out.println("<div class='large-4 medium-6 small-12 columns'>");
                                        out.println("<button class='small button succes radius buttonAction' onclick='guardarTimbradoAmpollas(2);' >Aprobar</button>");
                                    out.println("</div>");
                                    out.println("<div class='large-4 medium-6 small-12 columns'>");
                                        out.println("<button class='small button succes radius buttonAction' onclick='guardarTimbradoAmpollas(1);' >Pre Aprobar</button>");
                                    out.println("</div>");
                                    out.println("<div class='large-4 medium-6 small-12  columns'>");
                                        out.println("<button class='small button succes radius buttonAction' onclick='window.close();' >Cancelar</button>");
                                    out.println("</div>");
                                }
                                else
                                {
                                    out.println("<div class='large-6 medium-6 small-12 columns'>");
                                        out.println("<button class='small button succes radius buttonAction' onclick='guardarTimbradoAmpollas(0);' >Guardar</button>");
                                    out.println("</div>");
                                    out.println("<div class='large-6 medium-6 small-12  columns'>");
                                            out.println("<button class='small button succes radius buttonAction' onclick='window.close();' >Cancelar</button>");
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
    <div  id="formsuper"  style="
                padding: 50px;
                background-color: #cccccc;
                position:absolute;
                z-index: 1;
                left:0px;
                top: 0px;
                border :2px solid #3C8BDA;
                width:100%;
                height:100%;
                filter: alpha(opacity=70);
                visibility:hidden;
                opacity: 0.8;" >

          </div>
        <input type="hidden" id="codActividadCodificionAmpolla" value="<%=(codActividadCodificionAmpolla)%>"/>
        <input type="hidden" id="codActividadRevisado" value="<%=(codActividadRevisado)%>"/>
        <input type="hidden" id="codActividadPesadoFrascos" value="<%=(codActividadPesadoFrascos)%>"/>
        
        </section>
    </body>
    <script src="../../reponse/js/timePickerJs.js"></script>
    <script src="../../reponse/js/dataPickerJs.js"></script>
    <script src="../../reponse/js/mensajejs.js"></script>
    <script>iniciarDatePicker('<%=(sdfDias.format(new Date()))%>');loginHoja.verificarHojaCerradaAcond('cerrado', administradorSistema,3,<%=(codEstadoHoja)%>);</script>
</html>
