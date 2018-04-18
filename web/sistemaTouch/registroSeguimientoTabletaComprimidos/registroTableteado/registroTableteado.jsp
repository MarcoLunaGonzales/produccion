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
<link rel="STYLESHEET" type="text/css" href="../../reponse/css/border-radius.css" />

<link rel="STYLESHEET" type="text/css" href="../../reponse/css/jscal2.css" />
<link rel="STYLESHEET" type="text/css" href="../../reponse/css/gold.css" />
<script src="../../reponse/js/jscal2.js"></script>
<script src="../../reponse/js/en.js"></script>
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
    function codEstadoMaquinaChange(codMaquina)
    {
        console.log(codMaquina);
        document.getElementById("maqEsp"+codMaquina).style.display=
            (document.getElementById("checkMaquina"+codMaquina).checked?"":"none");
    }
    
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

    function guardarRepesada()
    {
        document.getElementById('formsuper').style.visibility='visible';
        document.getElementById('divImagen').style.visibility='visible';
        var tabla=document.getElementById('dataCantidades');
        var codLote=document.getElementById('codLoteSeguimiento').value;
        var codProgramaProd=document.getElementById('codProgramaProd').value;
        if(!(validarFechaRegistro(document.getElementById('fechaRepesada'))&&validarHoraRegistro(document.getElementById("horaRepesadaInicio"))&&validarHoraRegistro(document.getElementById("horaRepesadafinal"))
            &&validarRegistrosHorasNoNegativas(document.getElementById("horaRepesadaInicio"),document.getElementById("horaRepesadafinal"))))
            {
                 document.getElementById('formsuper').style.visibility='hidden';
                 document.getElementById('divImagen').style.visibility='hidden';
                 return false;
            }
        var cont=0;
        var dataRepesada=new Array();
        for(var i=2;i<tabla.rows.length;i++)
            {
                dataRepesada[cont]=tabla.rows[i].cells[0].getElementsByTagName('input')[0].value;
                cont++;
                dataRepesada[cont]=tabla.rows[i].cells[0].getElementsByTagName('input')[1].value;
                cont++;
                dataRepesada[cont]=(tabla.rows[i].cells[2].getElementsByTagName('input')[0].checked?'1':'0');
               cont++;
            }
         var peticion="ajaxGuardarSeguimientoRepesada.jsf?codLote="+codLote+"&noCache="+ Math.random()+
             "&codProgProd="+codProgramaProd+"&dataRepesada="+dataRepesada+
             "&codFormula="+document.getElementById('codFormulaMaestra').value+
             "&codTipoProgramaProd="+document.getElementById("codTipoProgramaProd").value+
             "&codCompProd="+document.getElementById("codCompProd").value+
             "&codActividadVerificacionPeso="+document.getElementById("codActividadVerificacionPeso").value+
             "&fechaSeguimiento="+document.getElementById('fechaRepesada').value+
             "&horaInicio="+document.getElementById("horaRepesadaInicio").value+
             "&horaFinal="+document.getElementById("horaRepesadafinal").value+
             "&horasHombreRepesada="+parseFloat(document.getElementById("spanHorasHombre").innerHTML)+
             "&codPersonal="+document.getElementById("codPersonalRepesada").value+
             "&codPersonalUsuario="+codPersonal+
             "&codSeguimiento="+document.getElementById("codSeguimientoRepesada").value+
             "&admin="+(admin?"1":"0")+
             (admin?"&observacion="+encodeURIComponent(document.getElementById("observacion").value):"");
         ajax=nuevoAjax();
         ajax.open("GET",peticion,true);
                 ajax.onreadystatechange=function(){
                    if (ajax.readyState==4) {
                        if(ajax.responseText==null || ajax.responseText=='')
                        {
                            alert('No se puede conectar con el servidor, verfique su conexión a internet');
                            if(confirm("Desea guardar la informacion localmente?\nLa informacion del lote no se perdera pero debe de subirla despues"))
                            {
                                sqlConnection.insertarRegistroAuxiliar(codProgramaProd,codLote,2,("../registroRepesada/"+peticion),function(){window.close();});
                            }
                            document.getElementById('formsuper').style.visibility='hidden';
                            document.getElementById('divImagen').style.visibility='hidden';
                            return false;
                        }
                        if(parseInt(ajax.responseText.split("\n").join(""))=='1')
                        {
                            alert('Se registro la etapa de repesada');
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
        String codPersonal=request.getParameter("codPersonal");
        boolean administrador=(Integer.valueOf(request.getParameter("admin"))>0);
        out.println("<script type='text/javascript'>codPersonal="+codPersonal+";" +
                   "admin="+administrador+";</script>");
        int codEstadoHoja=0;
        Date fechaCierre=new Date();
        int codFormulaMaestra=0;
        int codCompProd=0;
        String codLote=request.getParameter("codLote");
        out.println("<title>("+codLote+")TABLETEADO</title>");
        String codprogramaProd=request.getParameter("cod_prog");
        int codTipoProgramaProd=0;
        String codPersonalSupervisor="";
        String observacionLote="";
        String operarios="";
        String codSeguimientoRepesada="";
        NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
        DecimalFormat format = (DecimalFormat)nf;
        SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy");
        format.applyPattern("#,##0.0");
        int codActividadVerificacionPeso=0;
        out.println("<script>sqlConnection.verificarRegistroPendiente('"+codprogramaProd+"','"+codLote+"',2)</script>");
                try
                {
                    Connection con=null;
                    con=Util.openConnection(con);
                    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    String consulta="select pp.COD_COMPPROD,pp.COD_TIPO_PROGRAMA_PROD, isnull(afm.COD_ACTIVIDAD_FORMULA,0) as  COD_ACTIVIDAD_FORMULA, cp.COD_FORMA,p.nombre_prod,f.abreviatura_forma,cp.nombre_prod_semiterminado,cp.NOMBRE_GENERICO,f.nombre_forma,cp.REG_SANITARIO,"+
                                    " ep.nombre_envaseprim,cp.VIDA_UTIL,pp.CANT_LOTE_PRODUCCION,ppp.FECHA_FINAL," +
                                    " pp.COD_FORMULA_MAESTRA,ISNULL(srl.COD_SEGUIMIENTO_REPESADA_LOTE,0) as COD_SEGUIMIENTO_REPESADA_LOTE" +
                                    " ,ISNULL(cp.VOLUMEN_ENVASE_PRIMARIO,'') as VOLUMEN_ENVASE_PRIMARIO," +
                                    " ISNULL(srl.COD_PERSONAL_SUPERVISOR, 0) AS COD_PERSONAL_SUPERVISOR,"+
                                    " ISNULL(srl.OBSERVACION,'') as OBSERVACION,srl.FECHA_CIERRE,srl.COD_ESTADO_HOJA" +
                                    " ,ISNULL(dpff.CONDICIONES_GENERALES_REPESADA,'') as CONDICIONES_GENERALES_REPESADA" +
                                    ",isnull(conjunta.cantAsociado,0) as cantAsociado,isnull(conjunta.loteConjunto,'') as loteConjunto" +
                                    " ,isnull(cpp.NOMBRE_COLORPRESPRIMARIA,'') as colorPresPrim"+
                                    " from PROGRAMA_PRODUCCION pp inner join COMPONENTES_PROD cp on cp.COD_COMPPROD=pp.COD_COMPPROD"+
                                    " inner join FORMAS_FARMACEUTICAS f on f.cod_forma=cp.COD_FORMA"+
                                    " inner join productos p on p.cod_prod=cp.COD_PROD"+
                                    " inner join PRESENTACIONES_PRIMARIAS ppm on ppm.COD_COMPPROD=cp.COD_COMPPROD and ppm.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD"+
                                    " inner join ENVASES_PRIMARIOS ep on ep.cod_envaseprim=ppm.COD_ENVASEPRIM" +
                                    " inner join PROGRAMA_PRODUCCION_PERIODO ppp on pp.COD_PROGRAMA_PROD=ppp.COD_PROGRAMA_PROD" +
                                    " left outer join SEGUIMIENTO_REPESADA_LOTE srl on srl.COD_LOTE=pp.COD_LOTE_PRODUCCION"+
                                    " and srl.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD" +
                                    " left outer join COLORES_PRESPRIMARIA cpp on cpp.COD_COLORPRESPRIMARIA=cp.COD_COLORPRESPRIMARIA" +
                                    " left outer join DESCRIPCION_PROCESOS_FORMA_FARMACEUTICA dpff on dpff.COD_FORMA=cp.COD_FORMA" +
                                    " left outer join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_AREA_EMPRESA ="+
                                    " 96 and afm.COD_ACTIVIDAD = 31 and afm.COD_FORMULA_MAESTRA =pp.COD_FORMULA_MAESTRA" +
                                    " and afm.COD_PRESENTACION=0" +
                                    " OUTER APPLY(select top 1 ppc.CANT_LOTE_PRODUCCION as cantAsociado,ppc.COD_LOTE_PRODUCCION as loteConjunto"+
                                    " from LOTES_PRODUCCION_CONJUNTA lpc inner join PROGRAMA_PRODUCCION ppc"+
                                    " on ppc.COD_PROGRAMA_PROD=lpc.COD_PROGRAMA_PROD and lpc.COD_LOTE_PRODUCCION_ASOCIADO=ppc.COD_LOTE_PRODUCCION"+
                                    " where lpc.COD_LOTE_PRODUCCION=pp.COD_LOTE_PRODUCCION"+
                                    " and lpc.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD) conjunta"+
                                    " where pp.COD_LOTE_PRODUCCION='"+codLote+"' and pp.COD_PROGRAMA_PROD='"+codprogramaProd+"'";
                    System.out.println("consulta cargar datos del lote "+consulta);
                    ResultSet res=st.executeQuery(consulta);
                    int cantidadAmpollas=0;
                    String nombreProducto="";
                    String volumen="";
                    String condicionesGenerales="";
                    char b=13;char c=10;
                    if(res.next())
                    {
                        fechaCierre=(res.getTimestamp("FECHA_CIERRE")!=null?res.getTimestamp("FECHA_CIERRE"):new Date());
                        codEstadoHoja=res.getInt("COD_ESTADO_HOJA");
                        codPersonalSupervisor=res.getString("COD_PERSONAL_SUPERVISOR");
                        codFormulaMaestra=res.getInt("COD_FORMULA_MAESTRA");
                        codCompProd=res.getInt("COD_COMPPROD");
                        codTipoProgramaProd=res.getInt("COD_TIPO_PROGRAMA_PROD");
                        codActividadVerificacionPeso=res.getInt("COD_ACTIVIDAD_FORMULA");
                        condicionesGenerales=res.getString("CONDICIONES_GENERALES_REPESADA").replace(b,'\n').replace("\n", "</br>").replace("</br></br>","<br>").replace("\"v\"","\"√\"");
                        observacionLote=res.getString("OBSERVACION");
                        codSeguimientoRepesada=res.getString("COD_SEGUIMIENTO_REPESADA_LOTE");
                        volumen=res.getString("VOLUMEN_ENVASE_PRIMARIO");
                        nombreProducto=res.getString("nombre_prod");
                        cantidadAmpollas=res.getInt("CANT_LOTE_PRODUCCION");
                        %>

<section class="main">
                         <div class="row"  style="margin-top:5px" >
                                <div class="large-12 medium-12 small-12 large-centered medium-centered small-centered columns" >

                                            <div class="row">
                                               <div class="large-12 medium-12 small-12 columns divHeaderClass" >
                                                       <label  class="inline">TABLETEADO</label>
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
                                                               <span class="textHeaderClassBody"><%=(codLote+(res.getString("loteConjunto").equals("")?"":"<br>"+res.getString("loteConjunto")))%></span>
                                                           </td>
                                                           <td class="tableCell" style="text-align:center;">
                                                               <span class="textHeaderClassBody"><%=(cantidadAmpollas+(res.getString("loteConjunto").equals("")?"":"<br>"+res.getInt("cantAsociado")))%></span>
                                                           </td>
                                                           <td class="tableCell" style="text-align:center">
                                                               <span class="textHeaderClassBody"><%=res.getString("nombre_prod_semiterminado")%></span>
                                                           </td>
                                                           <td class="tableCell" style="text-align:center">
                                                               <span class="textHeaderClassBody"><%=res.getString("nombre_forma")%></span>
                                                           </td>
                                                           <td class="tableCell" style="text-align:center">
                                                               <span class="textHeaderClassBody"><%=res.getString("nombre_envaseprim")+" "+res.getString("colorPresPrim")%></span>
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
                                   <label  class="inline">ORDEN DE REPESADA</label>
                            </div>
                        </div>
                        <div class="row" >

                        <div  class="divContentClass large-12 medium-12 small-12 columns" style="padding-top:12px;">
                        <span style="margin-top:10px;font-weight:bold;">
                            Condiciones Generales<br><br>
                        </span>
                        <span style="top:10px;"><%=(condicionesGenerales)%></span>
                        <div class="row">
                            <div class="large-8 medium-10 small-12 large-centered medium-centered small-centered columns">
                                <table style="width:100%;margin-top:2%;" id="dataCantidades" cellpadding="0px" cellspacing="0px">
                                            
                              <%
                              cantidadAmpollas+=res.getInt("cantAsociado");
                              }
                              
                    consulta="select P.COD_PERSONAL,(P.AP_PATERNO_PERSONAL + ' ' + P.AP_MATERNO_PERSONAL + ' ' +P.NOMBRES_PERSONAL + ' ' + P.nombre2_personal) NOMBRES_PERSONAL"+
                                                 " from personal P inner join PERSONAL_AREA_PRODUCCION pa on pa.COD_PERSONAL = p.COD_PERSONAL"+
                                                 " where pa.cod_area_empresa in (81) AND p.COD_ESTADO_PERSONA = 1 " +
                                                 " and p.cod_personal='"+codPersonal+"'"+
                                                 " union select P.COD_PERSONAL,"+
                                                 " (P.AP_PATERNO_PERSONAL + ' ' + P.AP_MATERNO_PERSONAL + ' ' +P.NOMBRES_PERSONAL + ' ' + P.nombre2_personal) NOMBRES_PERSONAL"+
                                                 " from personal p where p.cod_area_empresa in (82) and p.COD_ESTADO_PERSONA = 1"+
                                                 " and p.cod_personal='"+codPersonal+"'"+
                                                 " GROUP BY P.COD_PERSONAL,P.AP_MATERNO_PERSONAL,P.AP_PATERNO_PERSONAL,P.NOMBRES_PERSONAL,P.nombre2_personal"+
                                                 " order by NOMBRES_PERSONAL ";
                                    if(codPersonalSupervisor.equals("0"));
                                    res=st.executeQuery(consulta);
                                    operarios="";
                                    while(res.next())
                                    {
                                        operarios+="<option value='"+res.getString(1)+"' selected>"+res.getString(2)+"</option>";
                                    }
                                consulta="select m.CODIGO,m.COD_MAQUINA,m.NOMBRE_MAQUINA,ep.NOMBRE_ESPECIFICACIONES_PROCESO,"+
                                         " um.NOMBRE_UNIDAD_MEDIDA, ep.COD_ESPECIFICACION_PROCESO, ep.RESULTADO_NUMERICO,"+
                                         " ep.PORCIENTO_TOLERANCIA,etp.VALOR_TEXTO,etp.VALOR_EXACTO"+
                                         " from ESPECIFICACIONES_TABLETEADO_PROD etp inner join MAQUINARIAS m "+
                                         " on etp.COD_MAQUINA=m.COD_MAQUINA	"+
                                         " inner join ESPECIFICACIONES_PROCESOS ep on"+
                                         " etp.COD_ESPECIFICACION_PROCESO=ep.COD_ESPECIFICACION_PROCESO"+
                                         " left outer join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=ep.COD_UNIDAD_MEDIDA"+
                                         " where  etp.COD_COMPPROD='"+codCompProd+"'"+
                                         " order by m.NOMBRE_MAQUINA,m.COD_MAQUINA,ep.ORDEN";
                                System.out.println("consulta cargar seguimiento "+consulta);
                                res=st.executeQuery(consulta);
                                int codMaquinaCabecera=0;
                                String innerHTML="";
                                while(res.next())
                                {
                                    if(codMaquinaCabecera!=res.getInt("COD_MAQUINA"))
                                    {
                                        if(codMaquinaCabecera>0)
                                        {
                                            res.previous();
                                            out.println("<tr>"+
                                                       " <td style='text-align:center' align='center'>" +
                                                       "<div><input type='checkbox' style='vertical-align:top' id='checkMaquina"+res.getInt("COD_MAQUINA")+"' onchange='codEstadoMaquinaChange("+res.getInt("COD_MAQUINA")+");' >" +
                                                       "<label for='checkMaquina"+res.getInt("COD_MAQUINA")+"' class='textHeaderClassBody' style='display:initial;padding:0px !important'>"+res.getString("NOMBRE_MAQUINA")+"("+res.getString("CODIGO")+")</label><div>"+
                                                       "<table id='maqEsp"+res.getInt("COD_MAQUINA")+"' cellpadding='0px' cellspacing='0px'><tr>" +
                                                       "<td class='tableHeaderClass'><span class='textHeaderClass'>CONDICIONES DEL PROCESO</span></td>" +
                                                       "<td class='tableHeaderClass'><span class='textHeaderClass'>ESPECIFICACION</span></td>" +
                                                       "<td class='tableHeaderClass'><span class='textHeaderClass'>CONDICIONES DEL PROCESO</span></td>" +
                                                       "</tr>"+innerHTML+"</table>"+
                                                       "</td></tr>");
                                            res.next();
                                        }
                                        codMaquinaCabecera=res.getInt("COD_MAQUINA");
                                        innerHTML="";
                                    }
                                    innerHTML+="<tr><td class='tableCell'><span class='textHeaderClassBody'>"+res.getString("NOMBRE_ESPECIFICACIONES_PROCESO")+"</span></td></tr>";
                                }
                                if(codMaquinaCabecera>0)
                                {
                                    res.previous();
                                    out.println("<tr >"+
                                               " <td style='text-align:center' align='center'>" +
                                               "<div><input type='checkbox' style='vertical-align:top' id='checkMaquina"+res.getInt("COD_MAQUINA")+"' onchange='codEstadoMaquinaChange("+res.getInt("COD_MAQUINA")+");' >" +
                                               "<label for='checkMaquina"+res.getInt("COD_MAQUINA")+"' class='textHeaderClassBody' style='display:initial;padding:0px !important'>"+res.getString("NOMBRE_MAQUINA")+"("+res.getString("CODIGO")+")</span><div>"+
                                               "<table id='maqEsp"+res.getInt("COD_MAQUINA")+"' cellpadding='0px' cellspacing='0px'>"+innerHTML+"</table></td></tr>");
                                }

                              %>
                              </table>
                            </div>
                        </div>

                    <center>
                        <input type="hidden" value="<%=(codPersonalSupervisor)%>" id="cerrado">
                    <table style="width:80%;margin-top:2px;border-bottom:solid #a80077 1px;" id="datosAdicionales" cellpadding="0px" cellspacing="0px" >
                        <tr >
                               <td class="tableHeaderClass" style="text-align:center" colspan="3">
                                   <span class="textHeaderClass">DATOS DE LA ETAPA</span>
                               </td>
                        </tr>
                        
                        <%
                            consulta="select sppp.FECHA_INICIO,sppp.FECHA_FINAL,sppp.HORAS_HOMBRE,sppp.COD_PERSONAL "+
                                     " from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sppp"+
                                      " where sppp.COD_PROGRAMA_PROD='"+codprogramaProd+"' and sppp.COD_COMPPROD='"+codCompProd+"'"+
                                      " and sppp.COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"' and sppp.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"'"+
                                     " and sppp.COD_LOTE_PRODUCCION='"+codLote+"' and sppp.COD_ACTIVIDAD_PROGRAMA='"+codActividadVerificacionPeso+"'"+
                                     " and sppp.COD_PERSONAL='"+codPersonal+"'";
                            System.out.println("consulta cargarSeguimiento verificacion peso "+consulta);
                            res=st.executeQuery(consulta);
                            SimpleDateFormat sdfDias=new SimpleDateFormat("dd/MM/yyyy");
                            SimpleDateFormat sdfHoras=new SimpleDateFormat("HH:mm");
                            Date fechaInicio= new Date();
                            Date fechaFinal=new Date();
                            double horasHombre=0;
                            int codPersonalRepesada=0;
                            if(res.next())
                            {
                                codPersonalRepesada=res.getInt("COD_PERSONAL");
                                fechaInicio=res.getTimestamp("FECHA_INICIO");
                                fechaFinal=res.getTimestamp("FECHA_FINAL");
                                horasHombre=res.getDouble("HORAS_HOMBRE");
                            }
                         %>
                         <tr >
                                <td style="border-left:solid #a80077 1px;text-align:left">
                                   <span >RESPONSABLE DE REPESADA</span>
                               </td>
                                <td style="border-right:solid #a80077 1px;text-align:left">
                                    <select id="codPersonalRepesada">
                                        <%
                                        out.println(operarios+"<script>codPersonalRepesada.value='"+codPersonalRepesada+"'</script>");
                                        %>
                                        
                                    </select>
                               </td>

                        </tr>
                        <tr>
                             <td style="border-left:solid #a80077 1px;text-align:left">
                                   <span >FECHA REPESADA</span>
                               </td>

                                    <td style="border-right:solid #a80077 1px;text-align:left">
                                        
                                        <input id="fechaRepesada" type="tel" onclick="seleccionarDatePickerJs(this)" value="<%=(sdfDias.format(fechaInicio))%>"/>
                                    </td>
                        </tr>
                          <tr>
                             <td style="border-left:solid #a80077 1px;text-align:left">
                                   <span >Hora Inicio</span>
                               </td>

                                    <td style="border-right:solid #a80077 1px;text-align:left">
                                        <input id="horaRepesadaInicio" onclick='seleccionarHora(this);' id='horaInicioRepesada'  onfocus="calcularHorasRepesada();"  onkeyup="calcularHorasRepesada();" type="text" value="<%=(sdfHoras.format(fechaInicio))%>"/>
                                    </td>
                            </tr>
                            <tr>
                             <td style="border-left:solid #a80077 1px;text-align:left">
                                   <span >Hora Final</span>
                               </td>

                                    <td style="border-right:solid #a80077 1px;text-align:left">
                                        <input id="horaRepesadafinal" onclick='seleccionarHora(this);' id='horaFinalRepesada' onkeyup="calcularHorasRepesada();" onfocus="calcularHorasRepesada();"  type="text" value="<%=(sdfHoras.format(fechaFinal))%>"/>
                                    </td>
                            </tr>
                            <tr>
                             <td style="border-left:solid #a80077 1px;text-align:left">
                                   <span >Horas Hombre</span>
                               </td>

                                    <td style="border-right:solid #a80077 1px;text-align:left">
                                        <span id="spanHorasHombre"><%=(horasHombre)%></span>
                                    </td>
                            </tr>
                            
                    </table>
                    <%
                    if(administrador)
                    {
                                consulta="select (p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL+' '+p.nombre2_personal)"+
                                         " from PERSONAL p where p.COD_PERSONAL='"+(Integer.valueOf(codPersonalSupervisor)>0?codPersonalSupervisor:codPersonal)+"'";
                                res=st.executeQuery(consulta);
                                String nombreUsuario="";
                                if(res.next())
                                {
                                    nombreUsuario=res.getString(1);
                                }
                    %>
                        <table style="width:80%;margin-top:2px;border-bottom:solid #a80077 1px;" id="datosAdicionales" cellpadding="0px" cellspacing="0px" >
                            <tr >
                                   <td class="tableHeaderClass" style="text-align:center" colspan="3">
                                       <span class="textHeaderClass">APROBACION</span>
                                   </td>
                            </tr>
                            <tr >
                                    <td style="border-left:solid #a80077 1px;text-align:left">
                                       <span >JEFE DE AREA</span>
                                   </td>
                                    <td style="border-right:solid #a80077 1px;text-align:left">
                                        <input type="hidden" id="codPersonalSupervisor" value="<%=(codPersonalSupervisor)%>"/>
                                        <span><%=(nombreUsuario)%></span>
                                   </td>

                            </tr>
                            <tr >
                                    <td style="border-left:solid #a80077 1px;text-align:left">
                                       <span >Fecha:</span>
                                   </td>
                                    <td style="border-right:solid #a80077 1px;text-align:left">
                                        <span><%=(sdfDias.format(fechaCierre)) %></span>
                                   </td>

                            </tr>
                            <tr >
                                    <td style="border-left:solid #a80077 1px;text-align:left">
                                       <span >Hora:</span>
                                   </td>
                                    <td style="border-right:solid #a80077 1px;text-align:left">
                                        <span><%=(sdfHoras.format(fechaCierre)) %></span>
                                   </td>

                            </tr>
                            <tr>
                                    <td class="" style="border-left:solid #a80077 1px;text-align:left">
                                       <span >Observacion</span>
                                   </td>

                                    <td class="" style="border-right:solid #a80077 1px;text-align:left">
                                        <input type="text" id="observacion" value="<%=(observacionLote)%>"/>
                                   </td>
                            </tr>
                        </table>
                    <%
                        }
                    %>
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
                                        <button class="small button succes radius buttonAction" onclick="guardarRepesada();" >Guardar</button>
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
        <input type="hidden" id="codSeguimientoRepesada" value="<%=codSeguimientoRepesada%>">
        <input type="hidden" id="codFormulaMaestra" value="<%=codFormulaMaestra%>"/>
        <input type="hidden" id="codTipoProgramaProd" value="<%=(codTipoProgramaProd)%>"/>
        <input type="hidden" id="codCompProd" value="<%=(codCompProd)%>"/>
        <input type="hidden" id="codActividadVerificacionPeso" value="<%=(codActividadVerificacionPeso)%>"/>
        <script src="../../reponse/js/timePickerJs.js"></script>
        <script src="../../reponse/js/dataPickerJs.js"></script>
        <script>iniciarDatePicker('<%=(sdf.format(new Date()))%>');loginHoja.verificarHojaCerrada('cerrado', admin,'codProgramaProd','codLoteSeguimiento',2,<%=(codEstadoHoja)%>);</script>
    
     </section>
    </body>
</html>
