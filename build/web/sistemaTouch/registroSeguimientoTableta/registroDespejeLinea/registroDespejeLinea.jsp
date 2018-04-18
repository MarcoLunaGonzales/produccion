<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
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
<%@page import="java.lang.Math" %>
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
<link rel="STYLESHEET" type="text/css" href="../../reponse/css/timePickerCSs.css" />
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
    function nuevoAjax()
            {	var xmlhttp=false;
                try {
                    xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
                } catch (e) {
                    try {
                        xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
                    } catch (E) {
                        xmlhttp = false;
                    }
                }
                if (!xmlhttp && typeof XMLHttpRequest!="undefined") {
                    xmlhttp = new XMLHttpRequest();
                }

                return xmlhttp;
            }
    
    function guardarDespejeLineaLimpieza()
    {
        document.getElementById('formsuper').style.visibility='visible';
        document.getElementById('divImagen').style.visibility='visible';
        var codLote=document.getElementById('codLoteSeguimiento').value;
        var codProgramaProd=document.getElementById('codProgramaProd').value;
        var despejeLinea=document.getElementById("dataDespejeLinea");
        var dataDespeje=new Array();
        var cont=0;
        for(var i=1;i<despejeLinea.rows.length;i++)
        {
            dataDespeje[cont]=despejeLinea.rows[i].cells[0].getElementsByTagName('input')[0].value;
            cont++;
            dataDespeje[cont]=(despejeLinea.rows[i].cells[1].getElementsByTagName('input')[0].checked?"1":"0");
            cont++;
            dataDespeje[cont]=(despejeLinea.rows[i].cells[2].getElementsByTagName('input')[0].checked?"1":"0");
            cont++;
            dataDespeje[cont]=(despejeLinea.rows[i].cells[3].getElementsByTagName('input')[0].checked?"1":"0");
            cont++;
        }
        var limpiezaUtensilios=document.getElementById("dataUtensilios");
        var dataUtensilios=new Array();
        cont=0;
        for(var j=1;j<limpiezaUtensilios.rows.length;j++)
        {
            dataUtensilios[cont]=limpiezaUtensilios.rows[j].cells[0].getElementsByTagName('input')[0].value;
            cont++;
            dataUtensilios[cont]=(limpiezaUtensilios.rows[j].cells[1].getElementsByTagName('input')[0].checked?"1":"0");
            cont++;
        }
        var limpiezaEquipos=document.getElementById("dataMaquinarias");
        var dataEquipos=new Array();
        cont=0;
        for(var k=1;k<limpiezaEquipos.rows.length;k++)
        {
            dataEquipos[cont]=limpiezaEquipos.rows[k].cells[0].getElementsByTagName('input')[0].value;
            cont++;
            dataEquipos[cont]=(limpiezaEquipos.rows[k].cells[1].getElementsByTagName('input')[0].checked?"1":"0");
            cont++
            dataEquipos[cont]=(limpiezaEquipos.rows[k].cells[2].getElementsByTagName('input')[0].checked?"1":"0");
            cont++
            dataEquipos[cont]=(limpiezaEquipos.rows[k].cells[3].getElementsByTagName('input')[0].checked?"1":"0");
            cont++
        }
        var peticion="ajaxGuardarDespejeLinea.jsf?codLote="+codLote+"&noCache="+ Math.random()+
             "&codProgProd="+codProgramaProd+"&dataDespeje="+dataDespeje+"&dataUtensilios="+dataUtensilios+
             "&dataEquipos="+dataEquipos+
             "&fechaVerificacion="+document.getElementById('fecha').innerHTML+
             "&codPersonalDespeje="+document.getElementById("codPersonalRespLineaDespeje").value+
             "&codPersonalVerificacion="+document.getElementById("codPersonalResponsableVerificacion").value+
             "&codSeguimiento="+document.getElementById("codSeguimientoDespejeLineaLote").value+
             "&observacion="+document.getElementById("observacion").value;
        ajax=nuevoAjax();
        ajax.open("GET",peticion,true);
                 ajax.onreadystatechange=function(){
                    if (ajax.readyState==4) {
                        if(ajax.responseText==null || ajax.responseText=='')
                        {
                            alert('No se puede conectar con el servidor, verfique su conexión a internet');
                            if(confirm("Desea guardar la informacion localmente?\nLa informacion del lote no se perdera pero debe de subirla despues"))
                            {
                                sqlConnection.insertarRegistroAuxiliar(codProgramaProd,codLote,7,("../registroDespejeLinea/"+peticion),function(){window.close();});
                            }
                            document.getElementById('formsuper').style.visibility='hidden';
                            document.getElementById('divImagen').style.visibility='hidden';
                            return false;
                        }
                        if(parseInt(ajax.responseText.split("\n").join(""))=='1')
                        {
                            alert('Se registro la etapa de despeje de linea');
                            document.getElementById('formsuper').style.visibility='hidden';
                            document.getElementById('divImagen').style.visibility='hidden';
                            window.close();
                            return true;
                        }
                        else
                        {
                            alert(ajax.responseText.split("\n").join(""));
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
        String codFormulaMaestra="";
        String codCompProd=request.getParameter("codComprod");
        String codLote=request.getParameter("codLote");
        out.println("<title>("+codLote+")DESPEJE DE LINEA</title>");
        String codprogramaProd=request.getParameter("cod_prog");
        String nombreComponente="as";
        String nombreAreaEmpresa="as";
        String codForma="";
        String codAreaEmpresa=request.getParameter("codAreaEmpresa");
        Date fechaRegistro=new Date();
        String observacionLote="";
        String operarios="";
        String codSeguimientoDespejeLineaLote="";
        NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
        DecimalFormat format = (DecimalFormat)nf;
        SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy");
        format.applyPattern("#,##0.00");
        out.println("<script>sqlConnection.verificarRegistroPendiente('"+codprogramaProd+"','"+codLote+"',7)</script>");
                try
                {
                    Connection con=null;
                    con=Util.openConnection(con);
                    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    String consulta="select cp.COD_FORMA,p.nombre_prod,f.abreviatura_forma,cp.nombre_prod_semiterminado,cp.NOMBRE_GENERICO,f.nombre_forma,cp.REG_SANITARIO,"+
                                    " ep.nombre_envaseprim,cp.VIDA_UTIL,pp.CANT_LOTE_PRODUCCION,ppp.FECHA_FINAL," +
                                    " pp.COD_FORMULA_MAESTRA,isnull(sdll.COD_SEGUIMIENTO_DESPEJE_LINEA_LOTE,0 )as COD_SEGUIMIENTO_DESPEJE_LINEA_LOTE,"+
                                    " isnull(sdll.COD_PERSONAL_RESP_DESP_LINEA,0) as COD_PERSONAL_RESP_DESP_LINEA,"+
                                    " isnull(sdll.COD_PERSONAL_RESP_VERIFICACION,0) as COD_PERSONAL_RESP_VERIFICACION,"+
                                    " sdll.FECHA_VERIFICACION,ISNULL(sdll.OBSERVACIONES,'') as OBSERVACIONES" +
                                    " ,ISNULL(cp.VOLUMEN_ENVASE_PRIMARIO,'') as VOLUMEN_ENVASE_PRIMARIO" +
                                    " ,isnull(dpff.CONDICIONES_GENERALES_DESPEJE_LINEA,'') as CONDICIONES_GENERALES_DESPEJE_LINEA" +
                                    " ,isnull(m1.NOMBRE_MAQUINA,'') as NOMBRE_MAQUINA1,isnull(m2.NOMBRE_MAQUINA,'') as NOMBRE_MAQUINA2,isnull(m3.NOMBRE_MAQUINA,'') as NOMBRE_MAQUINA3"+
                                    " from PROGRAMA_PRODUCCION pp inner join COMPONENTES_PROD cp on cp.COD_COMPPROD=pp.COD_COMPPROD"+
                                    " inner join FORMAS_FARMACEUTICAS f on f.cod_forma=cp.COD_FORMA"+
                                    " inner join productos p on p.cod_prod=cp.COD_PROD"+
                                    " inner join PRESENTACIONES_PRIMARIAS ppm on ppm.COD_COMPPROD=cp.COD_COMPPROD and ppm.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD"+
                                    " inner join ENVASES_PRIMARIOS ep on ep.cod_envaseprim=ppm.COD_ENVASEPRIM" +
                                    " inner join PROGRAMA_PRODUCCION_PERIODO ppp on pp.COD_PROGRAMA_PROD=ppp.COD_PROGRAMA_PROD" +
                                    " left outer join SEGUIMIENTO_DESPEJE_LINEA_LOTE  sdll on sdll.COD_LOTE=pp.COD_LOTE_PRODUCCION"+
                                    " and sdll.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD" +
                                    " left outer join DESCRIPCION_PROCESOS_FORMA_FARMACEUTICA dpff on dpff.COD_FORMA=cp.COD_FORMA" +
                                    " left outer join MAQUINARIAS m1 on m1.COD_MAQUINA=dpff.COD_MAQUINA1_VERIF_LIMPIEZA_EQUIP"+
                                    " left outer join MAQUINARIAS m2 on m2.COD_MAQUINA=dpff.COD_MAQUINA2_VERIF_LIMPIEZA_EQUIP"+
                                    " left outer join MAQUINARIAS m3 on m3.COD_MAQUINA=dpff.COD_MAQUINA3_VERIF_LIMPIEZA_EQUIP"+
                                    " where pp.COD_LOTE_PRODUCCION='"+codLote+"' and pp.COD_PROGRAMA_PROD='"+codprogramaProd+"'";
                    System.out.println("consulta cargar datos del lote "+consulta);
                    ResultSet res=st.executeQuery(consulta);
                    int cantidadAmpollas=0;
                    String nombreProducto="";
                    String registroSanitario="";
                    String volumen="";
                    String codPersonalRespLineaDespeje="";
                    String codPersonalRespVerificacion="";
                    String observaciones="";
                    String condicionesGenerales="";
                    String nombreMaquina1="";
                    String nombreMaquina2="";
                    String nombreMaquina3="";
                    char b=13;char c=10;
                    if(res.next())
                    {
                        nombreMaquina1=res.getString("NOMBRE_MAQUINA1");
                        nombreMaquina2=res.getString("NOMBRE_MAQUINA2");
                        nombreMaquina3=res.getString("NOMBRE_MAQUINA3");
                        condicionesGenerales=res.getString("CONDICIONES_GENERALES_DESPEJE_LINEA").replace(b,'\n').replace("\n", "</br>").replace("</br></br>","<br>").replace("\"v\"","\"√\"");
                        codPersonalRespLineaDespeje=res.getString("COD_PERSONAL_RESP_DESP_LINEA");
                        codPersonalRespVerificacion=res.getString("COD_PERSONAL_RESP_VERIFICACION");
                        observaciones=res.getString("OBSERVACIONES");
                        fechaRegistro=(res.getDate("FECHA_VERIFICACION")==null?new Date():res.getTimestamp("FECHA_VERIFICACION"));
                        codSeguimientoDespejeLineaLote=res.getString("COD_SEGUIMIENTO_DESPEJE_LINEA_LOTE");
                        codFormulaMaestra=res.getString("COD_FORMULA_MAESTRA");
                        volumen=res.getString("VOLUMEN_ENVASE_PRIMARIO");
                        nombreProducto=res.getString("nombre_prod");
                        codForma=res.getString("COD_FORMA");
                        cantidadAmpollas=res.getInt("CANT_LOTE_PRODUCCION");
                        registroSanitario=res.getString("REG_SANITARIO");
                        %>

<section class="main">
                         <div class="row"  style="margin-top:5px" >
                                <div class="large-12 medium-12 small-12 large-centered medium-centered small-centered columns" >

                                            <div class="row">
                                               <div class="large-12 medium-12 small-12 columns divHeaderClass" >
                                                       <label  class="inline">VERIFICACION DE LIMPIEZA-DESPEJE DE LINEA</label>
                                                </div>
                                            </div>
                                            <div class="row" >
                                                
                                            <div  class="divContentClass large-12 medium-12 small-12 columns">
                                                  
                                                   <table style="width:96%;margin-top:2%" cellpadding="0px" cellspacing="0px">
                                                       <tr >
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
                                                               <span class="textHeaderClassBody"><%=cantidadAmpollas%></span>
                                                           </td>
                                                           <td class="tableCell" style="text-align:center">
                                                               <span class="textHeaderClassBody"><%=res.getString("nombre_prod_semiterminado")%></span>
                                                           </td>
                                                           <td class="tableCell" style="text-align:center">
                                                               <span class="textHeaderClassBody"><%=res.getString("nombre_forma")%></span>
                                                           </td>
                                                           <td class="tableCell" style="text-align:center">
                                                               <span class="textHeaderClassBody"><%=res.getString("nombre_envaseprim")%></span>
                                                           </td>
                                                       </tr>
                                                       </table>
                                                   
                                                    
                                             </div>
                                             </div>
                                         </div>
                            </div>




<div class="row"  style="margin-top:5px" >
            <div class="large-12 medium-12 small-12 large-centered medium-centered small-centered columns" >

                        <div class="row">
                           <div class="large-12 medium-12 small-12 columns divHeaderClass" >
                                   <label  class="inline">VERIFICACION DE LIMPIEZA-DESPEJE DE LINEA</label>
                            </div>
                        </div>
                        <div class="row" >

                        <div  class="divContentClass large-12 medium-12 small-12 columns" style="padding-top:12px;">
                        <span style="margin-top:10px;font-weight:bold;">
                            Condiciones Generales<br><br>
                        </span>
                        <span style="top:10px;"><%=(condicionesGenerales)%></span>
                        <center><span style="margin-top:10px;font-weight:bold;font-size:14px" >
                            <BR><br>VERIFICACIÓN DE LIMPIEZA- DESPEJE DE LINEA DE AMBIENTES<br>
                        </span></center>
                        <div class="row">
                            <div class="large-10 medium-12 small-12 large-centered medium-centered small-centered columns">
                                <table style="width:100%;margin-top:2%" id="dataDespejeLinea" cellpadding="0px" cellspacing="0px">
                                            <tr>
                                                   <td class="tableHeaderClass"  style="text-align:center" >
                                                       <span class="textHeaderClass">LISTA DE VERIFICACION</span>
                                                   </td>
                                                   <td class="tableHeaderClass" style="text-align:center;">
                                                       <span class="textHeaderClass">PESAJE 1</span>
                                                   </td>
                                                   <td class="tableHeaderClass" style="text-align:center;">
                                                       <span class="textHeaderClass">PESAJE 2</span>
                                                   </td>
                                                   <td class="tableHeaderClass" style="text-align:center;">
                                                       <span class="textHeaderClass">ESCLUSA</span>
                                                   </td>
                                             </tr>
                                            
                              <%
                              }
                                consulta="select vdla.COD_VERIFICACION_DESPEJE_LINEA_AMBIENTE,vdla.DESCRIPCION_VERIFICACION_DESPEJE_LINEA_AMBIENTE" +
                                        " ,isnull(sdll.PESAJE1,0) as PESAJE1,isnull(sdll.PESAJE2,0) as PESAJE2,isnull(sdll.ESCLUSA,0) as ESCLUSA"+
                                        " from VERIFICACIONES_DESPEJE_LINEA_AMBIENTES vdla left outer join SEGUIMIENTO_DESPEJE_LINEA_LOTE_VERIF_DESP sdll"+
                                        " on sdll.COD_VERIFICACION_DESPEJE_LINEA_AMBIENTE=vdla.COD_VERIFICACION_DESPEJE_LINEA_AMBIENTE"+
                                        " and sdll.COD_SEGUIMIENTO_DESPEJE_LINEA_LOTE='"+codSeguimientoDespejeLineaLote+"'"+
                                        " where vdla.COD_ESTADO_REGISTRO=1 and vdla.COD_TIPO_VERIFICACION_DESPEJE_LINEA_AMBIENTE=1"+
                                        " order by vdla.DESCRIPCION_VERIFICACION_DESPEJE_LINEA_AMBIENTE";
                                System.out.println("consulta cargar seguimiento "+consulta);
                                res=st.executeQuery(consulta);

                                while(res.next())
                                {
                                    %>
                                     <tr >
                                                   <td class="tableCell" style="text-align:left">
                                                       <input type="hidden"  value="<%=res.getString("COD_VERIFICACION_DESPEJE_LINEA_AMBIENTE")%>"/>
                                                       <span class="textHeaderClassBody" style="font-weight:normal"><%=res.getString("DESCRIPCION_VERIFICACION_DESPEJE_LINEA_AMBIENTE")%></span>
                                                   </td>
                                                   <td class="tableCell"  style="text-align:center;">
                                                       <input type="checkbox" style="width:20px;height:20px" <%=res.getInt("PESAJE1")>0?"checked":""%> >
                                                   </td>
                                                   <td class="tableCell"  style="text-align:center;">
                                                       <input type="checkbox" style="width:20px;height:20px" <%=res.getInt("PESAJE2")>0?"checked":""%> >
                                                   </td>
                                                   <td class="tableCell"  style="text-align:center;">
                                                       <input type="checkbox" style="width:20px;height:20px" <%=res.getInt("ESCLUSA")>0?"checked":""%> >
                                                   </td>
                                       </tr>
                                    <%
                                }

                              %>
                              </table>
                            </div>
                        </div>
                        <center><span style="margin-top:10px;font-weight:bold;font-size:14px" >
                            <BR><br>VERIFICACION DE LIMPIEZA DE EQUIPOS<br>
                        </span></center>
                        <div class="row">
                            <div class="large-10 medium-12 small-12 large-centered medium-centered small-centered columns">
                                <table style="width:100%;margin-top:2%" id="dataMaquinarias" cellpadding="0px" cellspacing="0px">
                                            <tr>
                                                   <td class="tableHeaderClass"  style="text-align:center" >
                                                       <span class="textHeaderClass">LISTA DE VERIFICACION</span>
                                                   </td>
                                                   <td class="tableHeaderClass" style="text-align:center;">
                                                       <span class="textHeaderClass"><%=(nombreMaquina1)%></span>
                                                   </td>
                                                   <td class="tableHeaderClass" style="text-align:center;">
                                                       <span class="textHeaderClass"><%=(nombreMaquina2)%></span>
                                                   </td>
                                                   <td class="tableHeaderClass" style="text-align:center;">
                                                       <span class="textHeaderClass"><%=(nombreMaquina3)%></span>
                                                   </td>
                                             </tr>

                              <%
                              
                                consulta="select vdla.COD_VERIFICACION_DESPEJE_LINEA_AMBIENTE,vdla.DESCRIPCION_VERIFICACION_DESPEJE_LINEA_AMBIENTE" +
                                        " ,isnull(sdlle.CONFORME_MAQUINA1,0) as CONFORME_MAQUINA1,isnull(sdlle.CONFORME_MAQUINA2,0) as CONFORME_MAQUINA2,"+
                                        " isnull(sdlle.CONFORME_MAQUINA3,0) as CONFORME_MAQUINA3"+
                                        " from VERIFICACIONES_DESPEJE_LINEA_AMBIENTES vdla left outer join SEGUIMIENTO_DESPEJE_LINEA_LOTE_EQUIPO sdlle on "+
                                        " sdlle.COD_VERIFICACION_DESPEJE_LINEA_AMBIENTE=vdla.COD_VERIFICACION_DESPEJE_LINEA_AMBIENTE" +
                                        " and sdlle.COD_SEGUIMIENTO_DESPEJE_LINEA_LOTE='"+codSeguimientoDespejeLineaLote+"'"+
                                        " where vdla.COD_ESTADO_REGISTRO=1 and vdla.COD_TIPO_VERIFICACION_DESPEJE_LINEA_AMBIENTE=2"+
                                        " order by vdla.DESCRIPCION_VERIFICACION_DESPEJE_LINEA_AMBIENTE";
                                System.out.println("consulta cargar seguimiento equipo"+consulta);
                                res=st.executeQuery(consulta);

                                while(res.next())
                                {
                                    %>
                                     <tr >
                                                   <td class="tableCell" style="text-align:left">
                                                       <input type="hidden"  value="<%=res.getString("COD_VERIFICACION_DESPEJE_LINEA_AMBIENTE")%>"/>
                                                       <span class="textHeaderClassBody" style="font-weight:normal"><%=res.getString("DESCRIPCION_VERIFICACION_DESPEJE_LINEA_AMBIENTE")%></span>
                                                   </td>
                                                   <td class="tableCell"  style="text-align:center;">
                                                       <input type="checkbox" style="width:20px;height:20px" <%=res.getInt("CONFORME_MAQUINA1")>0?"checked":""%> >
                                                   </td>
                                                   <td class="tableCell"  style="text-align:center;">
                                                       <input type="checkbox" style="width:20px;height:20px" <%=res.getInt("CONFORME_MAQUINA2")>0?"checked":""%> >
                                                   </td>
                                                   <td class="tableCell"  style="text-align:center;">
                                                       <input type="checkbox" style="width:20px;height:20px" <%=res.getInt("CONFORME_MAQUINA3")>0?"checked":""%> >
                                                   </td>
                                       </tr>
                                    <%
                                }

                              %>
                              </table>
                            </div>
                        </div>
                      <center><span style="margin-top:10px;font-weight:bold;font-size:14px" >
                            <BR><br>VERIFICACION DE LIMPIEZA DE UTENSILIOS<br>
                        </span></center>
                        <div class="row">
                            <div class="large-6 medium-8 small-10 large-centered medium-centered small-centered columns">
                                <table style="width:100%;margin-top:2%" id="dataUtensilios" cellpadding="0px" cellspacing="0px">
                                            <tr>
                                                   <td class="tableHeaderClass"  style="text-align:center" >
                                                       <span class="textHeaderClass">LISTA DE VERIFICACION</span>
                                                   </td>
                                                   <td class="tableHeaderClass" style="text-align:center;">
                                                       <span class="textHeaderClass">CUMPLE</span>
                                                   </td>
                                             </tr>

                              <%

                                consulta="select vdla.COD_VERIFICACION_DESPEJE_LINEA_AMBIENTE,vdla.DESCRIPCION_VERIFICACION_DESPEJE_LINEA_AMBIENTE "+
										" ,ISNULL(sdlu.VERIFICACION_CUMPLIDA,0) as VERIFICACION_CUMPLIDA"+
                                        " from VERIFICACIONES_DESPEJE_LINEA_AMBIENTES vdla left outer join SEGUIMIENTO_DESPEJE_LINEA_LOTE_UTENSILIO sdlu"+
                                        " on sdlu.COD_VERIFICACION_LIMPIEZA_LINEA_AMBIENTE=vdla.COD_VERIFICACION_DESPEJE_LINEA_AMBIENTE and"+
                                        " sdlu.COD_SEGUIMIENTO_DESPEJE_LINEA_LOTE='"+codSeguimientoDespejeLineaLote+"'"+
                                        " where vdla.COD_ESTADO_REGISTRO=1 and vdla.COD_TIPO_VERIFICACION_DESPEJE_LINEA_AMBIENTE=3"+
                                        " order by vdla.DESCRIPCION_VERIFICACION_DESPEJE_LINEA_AMBIENTE";
                                System.out.println("consulta cargar seguimiento utensilios"+consulta);
                                res=st.executeQuery(consulta);

                                while(res.next())
                                {
                                    %>
                                     <tr >
                                                   <td class="tableCell" style="text-align:left">
                                                       <input type="hidden"  value="<%=res.getString("COD_VERIFICACION_DESPEJE_LINEA_AMBIENTE")%>"/>
                                                       <span class="textHeaderClassBody" style="font-weight:normal"><%=res.getString("DESCRIPCION_VERIFICACION_DESPEJE_LINEA_AMBIENTE")%></span>
                                                   </td>
                                                   <td class="tableCell"  style="text-align:center;">
                                                       <input type="checkbox" style="width:20px;height:20px" <%=res.getInt("VERIFICACION_CUMPLIDA")>0?"checked":""%> >
                                                   </td>
                                                   
                                       </tr>
                                    <%
                                }

                              %>
                              </table>
                            </div>
                        </div>
                    <center>
                        <input type="hidden" value="<%=codPersonalRespVerificacion%>" id="cerrado">
                    <table style="width:80%;margin-top:2px;border-bottom:solid #a80077 1px;" id="datosAdicionales" cellpadding="0px" cellspacing="0px" >
                        <tr >
                               <td class="tableHeaderClass" style="text-align:center" colspan="3">
                                   <span class="textHeaderClass">DATOS DE LA ETAPA</span>
                               </td>
                        </tr>
                          <%
                                    String personalSelect="";
                                    consulta="select p.COD_PERSONAL,(p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL+' '+p.nombre2_personal) as nombrePer"+
                                             " from personal p where p.COD_ESTADO_PERSONA=1"+
                                             " order by p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRES_PERSONAL,p.nombre2_personal";
                                    if(codPersonalRespLineaDespeje.equals("0"));
                                    personalSelect+="<option value='0' selected>-Seleccione una opción-</option>";
                                    res=st.executeQuery(consulta);
                                    while(res.next())
                                    {
                                          personalSelect+="<option value='"+res.getString("COD_PERSONAL")+"'>"+res.getString("nombrePer")+"</option>";
                                    }
                            %>
                        <tr >
                                <td style="border-left:solid #a80077 1px;text-align:left">
                                   <span >RESP. LIMPIEZA Y DESPEJE DE LINEA</span>
                               </td>
                                <td style="border-right:solid #a80077 1px;text-align:left">
                                    <select id="codPersonalRespLineaDespeje"><%out.println(personalSelect);%></select>
                                    <script> codPersonalRespLineaDespeje.value='<%=(codPersonalRespLineaDespeje)%>';
                                    </script>
                               </td>

                        </tr>
                        <tr >
                                <td style="border-left:solid #a80077 1px;text-align:left">
                                   <span >RESPONSABLE DE VERIFICACION</span>
                               </td>
                                <td style="border-right:solid #a80077 1px;text-align:left">
                                    <select id="codPersonalResponsableVerificacion"><%out.println(personalSelect);%></select>
                                    <script> codPersonalResponsableVerificacion.value='<%=(codPersonalRespVerificacion)%>';
                                    </script>
                               </td>

                        </tr>
                        <tr>
                                <td style="border-left:solid #a80077 1px;text-align:left">
                                   <span >Fecha:</span>
                               </td>

                                <td style="border-right:solid #a80077 1px;text-align:left">
                                   <span id="fecha" ><%=sdf.format(fechaRegistro)%></span>
                               </td>
                        </tr>
                        <tr>
                                <td class="" style="border-left:solid #a80077 1px;text-align:left">
                                   <span >Observacion</span>
                               </td>

                                <td class="" style="border-right:solid #a80077 1px;text-align:left">
                                    <textarea id="observacion" ><%=observaciones%></textarea>
                               </td>
                        </tr>
                    </table>
                    </center>
                          

                <%

                }
                catch(SQLException ex)
                {
                    ex.printStackTrace();
                }
                out.println("<script>loginHoja.verificarHojaCerrada('cerrado');</script>");
                %>
                    <div class="row" style="margin-top:0px;">
                            <div class="large-6 small-8 medium-10 large-centered medium-centered columns">
                                <div class="row">
                                    <div class="large-6 medium-6 small-12 columns">
                                        <button class="small button succes radius buttonAction" onclick="guardarDespejeLineaLimpieza();" >Guardar</button>
                                    </div>
                                        <div class="large-6 medium-6 small-12  columns">
                                            <button class="small button succes radius buttonAction" onclick="window.close();" >Cancelar</button>

                                        </div>
                                </div>
                            </div>
                    </div>

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
    <input type="hidden" id="codLoteSeguimiento" value="<%=codLote%>">
        <input type="hidden" id="codProgramaProd" value="<%=codprogramaProd%>">
        <input type="hidden" id="codSeguimientoDespejeLineaLote" value="<%=codSeguimientoDespejeLineaLote%>">
        <input type="hidden" id="codFormulaMaestra" value="<%=codFormulaMaestra%>">
        </section>
    </body>
</html>
