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
<link rel="STYLESHEET" type="text/css" href="../../reponse/css/foundation.css" />
<link rel="STYLESHEET" type="text/css" href="../../reponse/css/AtlasWeb.css" />
<link rel="STYLESHEET" type="text/css" href="../../reponse/css/timePickerCSs.css" />
<script src="../../reponse/js/variables.js"></script>
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
    .inputEsp
    {
        width:5em !important;
    }
     .primerafila
    {
         border-radius: 16px ;

    }
    .primerafilaSelect
    {
         border-top-left-radius: 16px ;
         border-top-right-radius: 16px ;

    }
    .detalleFila
    {
        opacity:0;
        top:0px;
        max-height:0px;
        border: solid #a80077 1px;
        border-bottom-left-radius: 16px ;
        border-bottom-right-radius: 16px ;
        display:none;
        -webkit-transition-duration:0.7s;
        -moz-transition-duration: 0.7s;
        transition-duration: 0.7s;
        border-bottom-left-radius: 16px ;
        border-bottom-right-radius: 16px ;
    }
</style>
<script type="text/javascript">
    function codEstadoMaquinaChange(input)
    {
        input.parentNode.className=(input.checked?'tableHeaderClass primerafilaSelect':'tableHeaderClass primerafila');
        input.parentNode.parentNode.parentNode.rows[(input.parentNode.parentNode.rowIndex+1)].cells[0].style.display=(input.checked?'table-cell':'none');
        window.setTimeout(function(){input.parentNode.parentNode.parentNode.rows[(input.parentNode.parentNode.rowIndex+1)].cells[0].style.opacity=(input.checked?'1':'0');}, 10);
        
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

    function guardarGranulado()
    {
        document.getElementById('formsuper').style.visibility='visible';
        document.getElementById('divImagen').style.visibility='visible';
        var tablaGranulado=document.getElementById("dataTiemposGranulado");
        var dataGranulado=new Array();
        var tablaEspecificaciones=document.getElementById('dataEspecificacionesGranulado');
        var dataEspecificaciones=new Array();
        if(!admin)
        {
                for(var j=1;j<tablaGranulado.rows.length;j++)
                {
                    if((codEstadoHojaGeneral!=3)||(validarSeleccionRegistro(tablaGranulado.rows[j].cells[0].getElementsByTagName('select')[0])&&
                       validarFechaRegistro(tablaGranulado.rows[j].cells[1].getElementsByTagName('input')[0])&&
                       validarHoraRegistro(tablaGranulado.rows[j].cells[2].getElementsByTagName('input')[0])&&
                       validarHoraRegistro(tablaGranulado.rows[j].cells[3].getElementsByTagName('input')[0])&&
                       validarRegistrosHorasNoNegativas(tablaGranulado.rows[j].cells[2].getElementsByTagName('input')[0],tablaGranulado.rows[j].cells[3].getElementsByTagName('input')[0])))
                    {
                        dataGranulado[dataGranulado.length]=tablaGranulado.rows[j].cells[0].getElementsByTagName('select')[0].value;
                        if(codEstadoHojaGeneral==3)
                        {
                            dataGranulado[dataGranulado.length]=tablaGranulado.rows[j].cells[1].getElementsByTagName('input')[0].value;
                            dataGranulado[dataGranulado.length]=tablaGranulado.rows[j].cells[2].getElementsByTagName('input')[0].value;
                            dataGranulado[dataGranulado.length]=tablaGranulado.rows[j].cells[3].getElementsByTagName('input')[0].value;
                            dataGranulado[dataGranulado.length]=parseFloat(tablaGranulado.rows[j].cells[4].getElementsByTagName('span')[0].innerHTML);
                        }
                        else
                        {
                            dataGranulado[dataGranulado.length]=tablaGranulado.rows[j].cells[1].getElementsByTagName('span')[0].innerHTML;
                            dataGranulado[dataGranulado.length]=tablaGranulado.rows[j].cells[2].getElementsByTagName('span')[0].innerHTML;
                            dataGranulado[dataGranulado.length]=tablaGranulado.rows[j].cells[3].getElementsByTagName('span')[0].innerHTML;
                            dataGranulado[dataGranulado.length]=parseFloat(tablaGranulado.rows[j].cells[4].getElementsByTagName('span')[0].innerHTML);
                            dataGranulado[dataGranulado.length]=(tablaGranulado.rows[j].cells[3].getElementsByTagName('button')[0].className=='buttonFinishActive'?1:0);

                        }
                    }
                    else
                    {
                        document.getElementById('formsuper').style.visibility='hidden';
                        document.getElementById('divImagen').style.visibility='hidden';
                        return false;
                    }
                }
                for(var i=0;i<tablaEspecificaciones.rows.length;i+=2)
                    {
                        if(tablaEspecificaciones.rows[i].cells[0].getElementsByTagName("input")[0].checked)
                        {
                           // console.log(tablaEspecificaciones.rows[i+1].cells[0].getElementsByTagName("table")[0].innerHTML);
                            var tablaEsp=tablaEspecificaciones.rows[i+1].cells[0].getElementsByTagName("table")[0];

                            for(var j=1;j<tablaEsp.rows.length;j++)
                            {

                                dataEspecificaciones[dataEspecificaciones.length]=tablaEspecificaciones.rows[i+1].cells[0].getElementsByTagName("input")[0].value;
                                dataEspecificaciones[dataEspecificaciones.length]=((tablaEsp.rows[j].cells[3].getElementsByTagName("input")[0].type=='tel')?
                                tablaEsp.rows[j].cells[3].getElementsByTagName("input")[0].value:
                                (tablaEsp.rows[j].cells[3].getElementsByTagName("input")[0].checked?1:0));
                                dataEspecificaciones[dataEspecificaciones.length]=encodeURIComponent(tablaEsp.rows[j].cells[4].getElementsByTagName("input")[0].value);
                                dataEspecificaciones[dataEspecificaciones.length]=tablaEsp.rows[j].cells[0].getElementsByTagName("input")[0].value;

                            }
                        }
                    }
        }
           // console.log(dataEspecificaciones);
         var codLote=document.getElementById('codLoteSeguimiento').value;
         var codProgramaProd=document.getElementById('codProgramaProd').value;
         var peticion="ajaxGuardarSeguimientoGranulado.jsf?codLote="+codLote+"&noCache="+ Math.random()+
             "&codProgProd="+codProgramaProd+
             "&codFormula="+document.getElementById('codFormulaMaestra').value+
             "&codTipoProgramaProd="+document.getElementById("codTipoProgramaProd").value+
             "&codCompProd="+document.getElementById("codCompProd").value+
             "&codActividadGranulado="+document.getElementById("codActividadGranulado").value+
             "&dataEspecificaciones="+dataEspecificaciones+
             "&dataGranulado="+dataGranulado+
             "&codPersonalUsuario="+codPersonal+
             "&registroManual="+(codEstadoHojaGeneral==3?1:0)+
             "&admin="+(admin?"1":"0")+
             (admin?"&observacion="+encodeURIComponent(document.getElementById("observacion").value):"");
         ajax=nuevoAjax();
         ajax.open("GET",peticion,true);
         ajax.setRequestHeader('content-type', 'application/x-www-form-urlencoded;charset=UTF-8');
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
                            alert('Se registro la etapa de granulado');
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
        //datos lote
        int codFormulaMaestra=0;
        int codCompProd=0;
        String codLote=request.getParameter("codLote");
        int codTipoProgramaProd=0;
        String codprogramaProd=request.getParameter("cod_prog");
        //datos personal
        String codPersonal=request.getParameter("codPersonal");
        boolean administrador=(Integer.valueOf(request.getParameter("admin"))>0);
        //datos hoja
        int codEstadoHoja=0;
        Date fechaCierre=new Date();
        String codPersonalSupervisor="";
        String observacionLote="";
        String codSeguimientoGranulado="";
        int codActividadGranulado=0;
        out.println("<script type='text/javascript'>codPersonal="+codPersonal+";" +
                   "admin="+administrador+";</script>");
        
        
        out.println("<title>("+codLote+")GRANULADO</title>");
        String operarios="";
        //formato fecha y numero
        NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
        DecimalFormat format = (DecimalFormat)nf;
        SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy");
        format.applyPattern("#,##0.0");
        SimpleDateFormat sdfDias=new SimpleDateFormat("dd/MM/yyyy");
        SimpleDateFormat sdfHoras=new SimpleDateFormat("HH:mm");
        out.println("<script>sqlConnection.verificarRegistroPendiente('"+codprogramaProd+"','"+codLote+"',2)</script>");
                try
                {
                    Connection con=null;
                    con=Util.openConnection(con);
                    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    String consulta="select pp.COD_COMPPROD,pp.COD_TIPO_PROGRAMA_PROD, isnull(afm.COD_ACTIVIDAD_FORMULA,0) as  codActividadGranulado, cp.COD_FORMA,p.nombre_prod,f.abreviatura_forma,cp.nombre_prod_semiterminado,cp.NOMBRE_GENERICO,f.nombre_forma,cp.REG_SANITARIO,"+
                                    " ep.nombre_envaseprim,cp.VIDA_UTIL,pp.CANT_LOTE_PRODUCCION,ppp.FECHA_FINAL," +
                                    " pp.COD_FORMULA_MAESTRA,ISNULL(sgl.COD_SEGUIMIENTO_GRANULADO_LOTE,0) as COD_SEGUIMIENTO_GRANULADO_LOTE" +
                                    " ,ISNULL(cp.VOLUMEN_ENVASE_PRIMARIO,'') as VOLUMEN_ENVASE_PRIMARIO," +
                                    " ISNULL(sgl.COD_PERSONAL_SUPERVISOR, 0) AS COD_PERSONAL_SUPERVISOR,"+
                                    " ISNULL(sgl.OBSERVACION,'') as OBSERVACION,sgl.FECHA_CIERRE,sgl.COD_ESTADO_HOJA" +
                                    " ,ISNULL(dpff.PRECAUCIONES_GRANULADO, '') as PRECAUCIONES_GRANULADO" +
                                    ",isnull(conjunta.cantAsociado,0) as cantAsociado,isnull(conjunta.loteConjunto,'') as loteConjunto" +
                                    " ,isnull(cpp.NOMBRE_COLORPRESPRIMARIA,'') as colorPresPrim"+
                                    " from PROGRAMA_PRODUCCION pp inner join COMPONENTES_PROD cp on cp.COD_COMPPROD=pp.COD_COMPPROD"+
                                    " inner join FORMAS_FARMACEUTICAS f on f.cod_forma=cp.COD_FORMA"+
                                    " inner join productos p on p.cod_prod=cp.COD_PROD"+
                                    " inner join PRESENTACIONES_PRIMARIAS ppm on ppm.COD_COMPPROD=cp.COD_COMPPROD and ppm.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD"+
                                    " inner join ENVASES_PRIMARIOS ep on ep.cod_envaseprim=ppm.COD_ENVASEPRIM" +
                                    " inner join PROGRAMA_PRODUCCION_PERIODO ppp on pp.COD_PROGRAMA_PROD=ppp.COD_PROGRAMA_PROD" +
                                    " left outer join SEGUIMIENTO_GRANULADO_LOTE sgl on sgl.COD_LOTE=pp.COD_LOTE_PRODUCCION"+
                                    " and sgl.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD" +
                                    " left outer join COLORES_PRESPRIMARIA cpp on cpp.COD_COLORPRESPRIMARIA=cp.COD_COLORPRESPRIMARIA" +
                                    " left outer join DESCRIPCION_PROCESOS_FORMA_FARMACEUTICA dpff on dpff.COD_FORMA=cp.COD_FORMA" +
                                    " left outer join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_AREA_EMPRESA ="+
                                    " 96 and afm.COD_ACTIVIDAD = 5 and afm.COD_FORMULA_MAESTRA =pp.COD_FORMULA_MAESTRA" +
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
                    
                    String precaucionesGranulado="";
                    char b=13;char c=10;
                    if(res.next())
                    {
                        fechaCierre=(res.getTimestamp("FECHA_CIERRE")!=null?res.getTimestamp("FECHA_CIERRE"):new Date());
                        codEstadoHoja=res.getInt("COD_ESTADO_HOJA");
                        codPersonalSupervisor=res.getString("COD_PERSONAL_SUPERVISOR");
                        codFormulaMaestra=res.getInt("COD_FORMULA_MAESTRA");
                        codCompProd=res.getInt("COD_COMPPROD");
                        codTipoProgramaProd=res.getInt("COD_TIPO_PROGRAMA_PROD");
                        codActividadGranulado=res.getInt("codActividadGranulado");
                        precaucionesGranulado=res.getString("PRECAUCIONES_GRANULADO").replace(b,'\n').replace("\n", "</br>").replace("</br></br>","<br>").replace("\"v\"","\"√\"");
                        observacionLote=res.getString("OBSERVACION");
                        codSeguimientoGranulado=res.getString("COD_SEGUIMIENTO_GRANULADO_LOTE");
                        cantidadAmpollas=res.getInt("CANT_LOTE_PRODUCCION");
                        %>

<section class="main">
                         <div class="row"  style="margin-top:5px" >
                                <div class="large-12 medium-12 small-12 large-centered medium-centered small-centered columns" >

                                            <div class="row">
                                               <div class="large-12 medium-12 small-12 columns divHeaderClass" >
                                                       <label  class="inline">GRANULADO</label>
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
                                   <label  class="inline">GRANULADO</label>
                            </div>
                        </div>
                        <div class="row" >

                        <div  class="divContentClass large-12 medium-12 small-12 columns" style="padding-top:12px;">
                        <span style="margin-top:10px;font-weight:bold;">
                            Precauciones:<br><br>
                        </span>
                        <span style="top:10px;"><%=(precaucionesGranulado)%></span>
                        <div class="row">
                            <div class="large-8 medium-10 small-12 large-centered medium-centered small-centered columns">
                                <table style="width:100%;margin-top:2%;" id="dataEspecificacionesGranulado" cellpadding="0px" cellspacing="0px">
                                            
                              <%
                              
                              }
                              
                    consulta="select P.COD_PERSONAL,(P.AP_PATERNO_PERSONAL + ' ' + P.AP_MATERNO_PERSONAL + ' ' +P.NOMBRES_PERSONAL + ' ' + P.nombre2_personal) NOMBRES_PERSONAL"+
                                                 " from personal P inner join PERSONAL_AREA_PRODUCCION pa on pa.COD_PERSONAL = p.COD_PERSONAL"+
                                                 " where pa.cod_area_empresa in (82) AND p.COD_ESTADO_PERSONA = 1 " +
                                                 (administrador?"":" and p.cod_personal='"+codPersonal+"'")+
                                                 " union select P.COD_PERSONAL,"+
                                                 " (P.AP_PATERNO_PERSONAL + ' ' + P.AP_MATERNO_PERSONAL + ' ' +P.NOMBRES_PERSONAL + ' ' + P.nombre2_personal) NOMBRES_PERSONAL"+
                                                 " from personal p where p.cod_area_empresa in (82) and p.COD_ESTADO_PERSONA = 1"+
                                                 (administrador?"":" and p.cod_personal='"+codPersonal+"'")+
                                                 " GROUP BY P.COD_PERSONAL,P.AP_MATERNO_PERSONAL,P.AP_PATERNO_PERSONAL,P.NOMBRES_PERSONAL,P.nombre2_personal"+
                                                 " order by NOMBRES_PERSONAL ";
                                    if(codPersonalSupervisor.equals("0"));
                                    res=st.executeQuery(consulta);
                                    operarios="";
                                    while(res.next())
                                    {
                                        operarios+="<option value='"+res.getString(1)+"' selected>"+res.getString(2)+"</option>";
                                    }
                                    out.println("<script>operariosRegistroGeneral=\""+operarios+"\";" +
                                            "fechaSistemaGeneral='"+sdfDias.format(new Date())+"';" +
                                            "codEstadoHoraRegistro='"+codEstadoHoja+"';</script>");
                               String cabeceraPersonal="";
                               String innerCabeceraPersonal="";
                               String detallePersonal="";
                               int contDetalle=0;
                               if(administrador)
                                {
                                    consulta="select p.COD_PERSONAL,(p.AP_PATERNO_PERSONAL+'<br>'+p.AP_MATERNO_PERSONAL+'<br>'+p.NOMBRES_PERSONAL)as nombrePersonal"+
                                             " from SEGUIMIENTO_ESPECIFICACIONES_GRANULADO_LOTE s inner join personal p on"+
                                             " p.COD_PERSONAL=s.COD_PERSONAL"+
                                             " where s.COD_SEGUIMIENTO_GRANULADO_LOTE='"+codSeguimientoGranulado+"'"+
                                             " group by p.COD_PERSONAL,p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRES_PERSONAL"+
                                             " order by p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRES_PERSONAL";
                                    System.out.println("consulta pers esp "+consulta);
                                    res=st.executeQuery(consulta);
                                    while(res.next())
                                    {
                                        innerCabeceraPersonal+="<td colspan='2' class='tableHeaderClass' style='text-align:center;'><span class='textHeaderClass'>"+res.getString("nombrePersonal")+"</span></td>";
                                        cabeceraPersonal+=",isnull(segl"+res.getRow()+".OBSERVACION,'') as OBSERVACION"+res.getRow()+
                                                          ",segl"+res.getRow()+".CONFORME as CONFORME"+res.getRow()+",segl"+res.getRow()+".VALOR_EXACTO AS VALORreSULTADO"+res.getRow()+",isnull(segl"+res.getRow()+".COD_MAQUINA,0)as registrado"+res.getRow();
                                        detallePersonal+=" left outer join SEGUIMIENTO_ESPECIFICACIONES_GRANULADO_LOTE segl"+res.getRow()+" on"+
                                                         " segl"+res.getRow()+".COD_ESPECIFICACION_PROCESO = ep.COD_ESPECIFICACION_PROCESO" +
                                                         " and segl"+res.getRow()+".COD_MAQUINA=m.COD_MAQUINA and"+
                                                         " segl"+res.getRow()+".COD_SEGUIMIENTO_GRANULADO_LOTE = '"+codSeguimientoGranulado+"'" +
                                                         " and segl"+res.getRow()+".COD_PERSONAL='"+res.getInt("COD_PERSONAL")+"'";
                                        contDetalle=res.getRow();
                                    }

                                }
                                consulta="select m.CODIGO,m.COD_MAQUINA,m.NOMBRE_MAQUINA,ep.NOMBRE_ESPECIFICACIONES_PROCESO,"+
                                         " ISNULL(um.ABREVIATURA,'') AS ABREVIATURA,ep.COD_ESPECIFICACION_PROCESO,ep.RESULTADO_NUMERICO,ep.PORCIENTO_TOLERANCIA,"+
                                         " egp.VALOR_TEXTO,egp.VALOR_EXACTO,ep.RESULTADO_ESPERADO_LOTE" +
                                         (administrador?cabeceraPersonal:",isnull(sgl.OBSERVACION,'') as OBSERVACION" +
                                         " ,sgl.CONFORME,sgl.VALOR_EXACTO AS VALORreSULTADO,isnull(sgl.COD_MAQUINA,0)as registrado")+
                                         " from ESPECIFICACIONES_GRANULADO_PROD egp inner join MAQUINARIAS m on egp.COD_MAQUINA = m.COD_MAQUINA"+
                                         " inner join ESPECIFICACIONES_PROCESOS ep on egp.COD_ESPECIFICACION_PROCESO =ep.COD_ESPECIFICACION_PROCESO"+
                                         " left outer join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA =ep.COD_UNIDAD_MEDIDA" +
                                         (administrador?detallePersonal:" left outer join SEGUIMIENTO_ESPECIFICACIONES_GRANULADO_LOTE sgl on "+
                                         " sgl.COD_ESPECIFICACION_PROCESO=egp.COD_ESPECIFICACION_PROCESO"+
                                         " and sgl.COD_MAQUINA=m.COD_MAQUINA and "+
                                         " sgl.COD_SEGUIMIENTO_GRANULADO_LOTE='"+codSeguimientoGranulado+"'"+
                                         " and sgl.COD_PERSONAL='"+codPersonal+"'")+
                                         " where egp.COD_COMPPROD = '"+codCompProd+"' order by m.NOMBRE_MAQUINA,m.COD_MAQUINA,ep.ORDEN";
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
                                                       " <td style='text-align:center' class='tableHeaderClass primerafila"+(administrador?"Select":(res.getInt("registrado")>0?"Select":""))+"' align='center'>" +
                                                       " <input type='checkbox' style='vertical-align:top' id='checkMaquina"+res.getInt("COD_MAQUINA")+"' "+(administrador?"checked":(res.getInt("registrado")>0?"checked":""))+" onchange='codEstadoMaquinaChange(this);' >" +
                                                       "<label for='checkMaquina"+res.getInt("COD_MAQUINA")+"' class='textHeaderClass' style='color:white;display:initial;padding:0px !important'>"+res.getString("NOMBRE_MAQUINA")+"("+res.getString("CODIGO")+")</label></td></tr>" +
                                                       "<tr><td class='detalleFila' "+(administrador?"style='display:table-cell;opacity:1'":(res.getInt("registrado")>0?"style='display:table-cell;opacity:1'":""))+"><input type='hidden' value='"+res.getInt("COD_MAQUINA")+"'/>"+
                                                       "<table id='maqEsp"+res.getInt("COD_MAQUINA")+"' cellpadding='0px' cellspacing='0px'><tr>" +
                                                       "<td class='tableHeaderClass' "+(administrador&&contDetalle>0?"rowspan='2'":"")+" ><span class='textHeaderClass'>CONDICIONES DEL PROCESO</span></td>" +
                                                       "<td class='tableHeaderClass' "+(administrador&&contDetalle>0?"rowspan='2'":"")+"><span class='textHeaderClass'>ESPECIFICACION</span></td>" +
                                                       "<td class='tableHeaderClass' "+(administrador&&contDetalle>0?"rowspan='2'":"")+"><span class='textHeaderClass'>UNIDAD</span></td>" +
                                                       (administrador?innerCabeceraPersonal:
                                                       "<td class='tableHeaderClass'><span class='textHeaderClass'>CONFORME</span></td>" +
                                                       "<td class='tableHeaderClass'><span class='textHeaderClass'>OBSERVACIONES</span></td>"));
                                                        if(administrador&&contDetalle>0)
                                                        {
                                                            out.println("</tr><tr>");
                                                            for(int i=0;i<contDetalle;i++)out.println("<td class='tableHeaderClass'><span class='textHeaderClass'>CONFORME</span></td>" +
                                                                                            "<td class='tableHeaderClass'><span class='textHeaderClass'>OBSERVACIONES</span></td>");
                                                        }
                                                      out.println("</tr>"+innerHTML+"</table>"+
                                                       "</td></tr>");
                                            res.next();
                                        }
                                        codMaquinaCabecera=res.getInt("COD_MAQUINA");
                                        innerHTML="";
                                    }
                                    innerHTML+="<tr><td class='tableCell'><input type='hidden' value='"+res.getInt("COD_ESPECIFICACION_PROCESO")+"'/><span class='textHeaderClassBody'>"+res.getString("NOMBRE_ESPECIFICACIONES_PROCESO")+"</span></td>" +
                                               "<td class='tableCell'><span class='textHeaderClassBody'>"+(res.getInt("RESULTADO_NUMERICO")>0?res.getDouble("VALOR_EXACTO"):res.getString("VALOR_TEXTO"))+"</span></td>" +
                                               "<td class='tableCell'><span class='textHeaderClassBody'>"+res.getString("ABREVIATURA")+"</span></td>";
                                    if(administrador)
                                    {
                                        for(int i=1;i<=contDetalle;i++)
                                        {
                                            innerHTML+="<td class='tableCell'>"+(res.getInt("RESULTADO_ESPERADO_LOTE")>0?"<input type='tel' class='inputEsp' value='"+res.getDouble("VALORreSULTADO"+i)+"'/>":"<input type='checkbox' "+(res.getInt("CONFORME"+i)>0?"checked":"")+" style='vertical-align:top'>")+"</td>" +
                                                    "<td class='tableCell'><input type='text'  value='"+res.getString("OBSERVACION"+i)+"'/></td>";
                                        }
                                    }
                                    else
                                    {
                                            innerHTML+="<td class='tableCell'>"+(res.getInt("RESULTADO_ESPERADO_LOTE")>0?"<input type='tel' class='inputEsp' value='"+res.getDouble("VALORreSULTADO")+"'/>":"<input type='checkbox' "+(res.getInt("CONFORME")>0?"checked":"")+" style='vertical-align:top'>")+"</td>" +
                                                    "<td class='tableCell'><input type='text'  value='"+res.getString("OBSERVACION")+"'/></td>";
                                    }
                                               
                                   innerHTML+="</tr>";
                                }
                                if(codMaquinaCabecera>0)
                                {
                                    res.previous();
                                    out.println("<tr >"+
                                               " <td style='text-align:center' class='tableHeaderClass primerafila"+(administrador?"Select":(res.getInt("registrado")>0?"Select":""))+"' align='center'>" +
                                               "<input type='checkbox' "+(administrador?"checked":(res.getInt("registrado")>0?"checked":""))+" style='vertical-align:top' id='checkMaquina"+res.getInt("COD_MAQUINA")+"' onchange='codEstadoMaquinaChange(this);' >" +
                                               "<label for='checkMaquina"+res.getInt("COD_MAQUINA")+"' class='textHeaderClass'  style='color:white;display:initial;padding:0px !important'>"+res.getString("NOMBRE_MAQUINA")+"("+res.getString("CODIGO")+")</label></td></tr>" +
                                               "<tr><td class='detalleFila' "+(administrador?"style='display:table-cell;opacity:1'":(res.getInt("registrado")>0?"style='display:table-cell;opacity:1'":""))+"><input type='hidden' value='"+res.getInt("COD_MAQUINA")+"'/>"+
                                               "<table id='maqEsp"+res.getInt("COD_MAQUINA")+"' cellpadding='0px' cellspacing='0px'>" +
                                               "<tr>"+
                                               "<td class='tableHeaderClass' "+(administrador&&contDetalle>0?"rowspan='2'":"")+"><span class='textHeaderClass'>CONDICIONES DEL PROCESO</span></td>" +
                                               "<td class='tableHeaderClass' "+(administrador&&contDetalle>0?"rowspan='2'":"")+"><span class='textHeaderClass'>ESPECIFICACION</span></td>" +
                                               "<td class='tableHeaderClass' "+(administrador&&contDetalle>0?"rowspan='2'":"")+"><span class='textHeaderClass'>UNIDAD</span></td>" +
                                               (administrador?innerCabeceraPersonal:"<td class='tableHeaderClass'><span class='textHeaderClass'>CONFORME</span></td>" +
                                               "<td class='tableHeaderClass'><span class='textHeaderClass'>OBSERVACIONES</span></td>"));
                                                if(administrador&&contDetalle>0)
                                                {
                                                    out.println("</tr><tr>");
                                                    for(int i=0;i<contDetalle;i++)out.println("<td class='tableHeaderClass'><span class='textHeaderClass'>CONFORME</span></td>" +
                                                                                    "<td class='tableHeaderClass'><span class='textHeaderClass'>OBSERVACIONES</span></td>");
                                                }
                                               out.println("</tr>"+
                                               innerHTML+"</table></td></tr>");
                                }

                              %>
                              </table>
                            </div>
                        </div>
                        <table style="width:100%;margin-top:8px" id="dataTiemposGranulado" cellpadding="0px" cellspacing="0px">
                              <tr>
                                   <td class="tableHeaderClass"  style="text-align:center">
                                       <span class="textHeaderClass">Responsable<br>del<br>Proceso</span>
                                   </td>
                                   <td class="tableHeaderClass"  style="text-align:center;">
                                       <span class="textHeaderClass">Fecha</span>
                                   </td>
                                   <td class="tableHeaderClass" style="text-align:center">
                                       <span class="textHeaderClass">Hora Inicio</span>
                                   </td>
                                   <td class="tableHeaderClass" style="text-align:center">
                                       <span class="textHeaderClass">Hora Final</span>
                                   </td>
                                    <td class="tableHeaderClass" style="text-align:center">
                                       <span class="textHeaderClass">Horas Hombre</span>
                                   </td>
                               </tr>
                              <%
                              
                                
                              consulta="select sppp.COD_PERSONAL,sppp.FECHA_INICIO,sppp.FECHA_FINAL,sppp.HORAS_HOMBRE,sppp.REGISTRO_CERRADO"+
                                        " from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sppp "+
                                        " where sppp.COD_PROGRAMA_PROD='"+codprogramaProd+"' and sppp.COD_LOTE_PRODUCCION='"+codLote+"'"+
                                        " and sppp.COD_COMPPROD='"+codCompProd+"' and sppp.COD_ACTIVIDAD_PROGRAMA='"+codActividadGranulado+"'"+
                                        " and sppp.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"' and sppp.COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"'"+
                                        (administrador?"":" and sppp.cod_personal='"+codPersonal+"'")+
                                        " order by sppp.FECHA_INICIO";
                                System.out.println("consulta cargar tiempos documentacion "+consulta);
                                res=st.executeQuery(consulta);

                                while(res.next())
                                {
                                    out.println("<tr onclick='seleccionarFila(this)' ><td class='tableCell' style='text-align:left'>"+
                                                " <select  "+(administrador?(res.getString("COD_PERSONAL").equals(codPersonal)?"":"disabled"):"")+" id='codPersonalDoc"+res.getRow()+"'>"+(operarios)+"</select><script>codPersonalDoc"+res.getRow()+".value='"+res.getString("COD_PERSONAL")+"'</script></td>"+
                                                " <td class='tableCell' align='center'>" +
                                                (codEstadoHoja==3?"<input "+(administrador?(res.getString("COD_PERSONAL").equals(codPersonal)?"":"disabled"):"")+" id='fechaDoc"+res.getRow()+"' type='tel' onclick='seleccionarDatePickerJs(this);' value='"+sdfDias.format(res.getTimestamp("FECHA_INICIO"))+"'/>":
                                                "<span class='textHeaderClassBodyNormal'>"+sdfDias.format(res.getTimestamp("FECHA_INICIO"))+"</span>")+
                                                "</td>" +
                                                " <td class='tableCell' style='width:6em;' align='center'>" +
                                                (codEstadoHoja==3?"<input "+(administrador?(res.getString("COD_PERSONAL").equals(codPersonal)?"":"disabled"):"")+" type='text' onclick='seleccionarHora(this);' id='fechaIniDoc"+res.getRow()+"' onfocus='calcularDiferenciaHoras(this);' onkeyup='calcularDiferenciaHoras(this);' value='"+sdfHoras.format(res.getTimestamp("FECHA_INICIO"))+"'>":
                                                " <span class='textHeaderClassBodyNormal'>"+sdfHoras.format(res.getTimestamp("FECHA_INICIO"))+"</span>")+
                                                " </td>" +
                                                " <td class='tableCell' align='center' style='width:6em;'>" +
                                                (codEstadoHoja==3?" <input "+(administrador?(res.getString("COD_PERSONAL").equals(codPersonal)?"":"disabled"):"")+" type='text' onclick='seleccionarHora(this);' id='fechaFinDoc"+res.getRow()+"' onfocus='calcularDiferenciaHoras(this);' onkeyup='calcularDiferenciaHoras(this);' value='"+sdfHoras.format(res.getTimestamp("FECHA_FINAL"))+"'>":
                                                "<button "+(administrador?"disabled":"")+" class='"+(res.getInt("REGISTRO_CERRADO")>0?"buttonFinishActive":"buttonFinish")+"' onclick=\"calcularHorasGeneral(this,'"+sdfHoras.format(res.getTimestamp("FECHA_INICIO"))+"')\">Terminar</button>"+
                                                "<span class='textHeaderClassBodyNormal'>"+sdfHoras.format(res.getTimestamp("FECHA_FINAL"))+"</span>")+
                                                "</td>" +
                                                " <td class='tableCell' style='text-align:center;width:6em;' aling='center'><span class='textHeaderClassBody' style='font-weight:normal'>"+res.getDouble("HORAS_HOMBRE")+"</span></td>" +
                                                "</tr>");
                                }
                              %>
                        </table>
                        <div class="row">
                            <div class="large-5 medium-5 small-4 columns" style="">&nbsp;</div>
                              <div class="large-1 medium-1 small-2 columns">
                                    <button <%=(administrador?"disabled":"")%> class="small button succes radius buttonAction" onclick="nuevoRegistroGeneral('dataTiemposGranulado')">+</button>
                              </div>
                              <div class="large-1 medium-1 small-2 columns">
                                    <button <%=(administrador?"disabled":"")%> class="small button succes radius buttonAction" onclick="eliminarRegistroTabla('dataTiemposGranulado');">-</button>
                              </div>
                              <div class="large-5 medium-5 small-4 columns" style="">&nbsp;</div>
                       </div>
                    <center>
                        <input type="hidden" value="<%=(codPersonalSupervisor)%>" id="cerrado">
                    
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
                                        <button class="small button succes radius buttonAction" onclick="guardarGranulado();" >Guardar</button>
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
        <input type="hidden" id="codSeguimientoRepesada" value="<%=codSeguimientoGranulado%>">
        <input type="hidden" id="codFormulaMaestra" value="<%=codFormulaMaestra%>"/>
        <input type="hidden" id="codTipoProgramaProd" value="<%=(codTipoProgramaProd)%>"/>
        <input type="hidden" id="codCompProd" value="<%=(codCompProd)%>"/>
        <input type="hidden" id="codActividadGranulado" value="<%=(codActividadGranulado)%>"/>
        <script src="../../reponse/js/timePickerJs.js"></script>
        <script src="../../reponse/js/dataPickerJs.js"></script>
        <script>iniciarDatePicker('<%=(sdf.format(new Date()))%>');loginHoja.verificarHojaCerrada('cerrado', admin,'codProgramaProd','codLoteSeguimiento',3,<%=(codEstadoHoja)%>);</script>
    
     </section>
    </body>
</html>
