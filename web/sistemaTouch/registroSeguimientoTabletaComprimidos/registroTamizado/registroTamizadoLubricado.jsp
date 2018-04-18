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
<script src="../../reponse/js/procesoTamizado.js"></script>
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
    #modalTamizado
    {
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
        opacity: 0.8;
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

    function guardarTamizado()
    {
        document.getElementById('formsuper').style.visibility='visible';
        document.getElementById('divImagen').style.visibility='visible';
        var dataTamizado=null;
        var dataMezclado=null;
        var tablaEspecificaciones=document.getElementById('dataEspecificacionesTamizado');
        var dataEspecificaciones=new Array();
        if(!admin)
        {
                dataTamizado=formatArrayGeneral(document.getElementById("dataTiemposTamizado"),1,false);
                dataMezclado=formatArrayGeneral(document.getElementById("dataTiempoMezclado"), 1, false);
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
         var peticion="ajaxGuardarSeguimientoTamizado.jsf?codLote="+codLote+"&noCache="+ Math.random()+
             "&codProgProd="+codProgramaProd+
             "&codFormula="+document.getElementById('codFormulaMaestra').value+
             "&codTipoProgramaProd="+document.getElementById("codTipoProgramaProd").value+
             "&codCompProd="+document.getElementById("codCompProd").value+
             "&codActividadTamizado="+document.getElementById("codActividadTamizado").value+
             "&codActividadMezclado="+document.getElementById("codActividadMezclado").value+
             "&dataEspecificaciones="+dataEspecificaciones+
             "&dataTamizado="+dataTamizado+
             "&dataMezclado="+dataMezclado+
             "&codPersonalUsuario="+codPersonal+
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
                            alert('Se registro la etapa de tamizado');
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
        out.println("<title>("+codLote+")Tamizado/Lubricado</title>");
        String codprogramaProd=request.getParameter("cod_prog");
        int codTipoProgramaProd=0;
        String codPersonalSupervisor="";
        String observacionLote="";
        String operarios="";
        String codSeguimientoTamizado="";
        NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
        DecimalFormat format = (DecimalFormat)nf;
        SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy");
        format.applyPattern("#,##0.0");
        int codActividadTamizado=0;
        int codActividadMezclado=0;
        SimpleDateFormat sdfDias=new SimpleDateFormat("dd/MM/yyyy");
        SimpleDateFormat sdfHoras=new SimpleDateFormat("HH:mm");
        out.println("<script>sqlConnection.verificarRegistroPendiente('"+codprogramaProd+"','"+codLote+"',2)</script>");
                try
                {
                    Connection con=null;
                    con=Util.openConnection(con);
                    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    String consulta="select pp.COD_COMPPROD,pp.COD_TIPO_PROGRAMA_PROD," +
                                    " isnull(afm.COD_ACTIVIDAD_FORMULA,0) as  codActividadTamizado," +
                                    " isnull(afm1.COD_ACTIVIDAD_FORMULA,0) as  codActividadMezclado," +
                                    " cp.COD_FORMA,p.nombre_prod,f.abreviatura_forma,cp.nombre_prod_semiterminado,cp.NOMBRE_GENERICO,f.nombre_forma,cp.REG_SANITARIO,"+
                                    " ep.nombre_envaseprim,cp.VIDA_UTIL,pp.CANT_LOTE_PRODUCCION,ppp.FECHA_FINAL," +
                                    " pp.COD_FORMULA_MAESTRA,ISNULL(stl.COD_SEGUIMIENTO_TAMIZADO_LOTE,0) as COD_SEGUIMIENTO_TAMIZADO_LOTE" +
                                    " ,ISNULL(cp.VOLUMEN_ENVASE_PRIMARIO,'') as VOLUMEN_ENVASE_PRIMARIO," +
                                    " ISNULL(stl.COD_PERSONAL_SUPERVISOR, 0) AS COD_PERSONAL_SUPERVISOR,"+
                                    " ISNULL(stl.OBSERVACION,'') as OBSERVACION,stl.FECHA_CIERRE,stl.COD_ESTADO_HOJA" +
                                    " ,ISNULL(dpff.PRECAUCIONES_TAMIZADO, '') as PRECAUCIONES_TAMIZADO,"+
                                    " isnull(dpff.CONDICIONES_GENERALES_TAMIZADO,'') as CONDICIONES_GENERALES_TAMIZADO" +
                                    ",isnull(conjunta.cantAsociado,0) as cantAsociado,isnull(conjunta.loteConjunto,'') as loteConjunto" +
                                    " ,isnull(cpp.NOMBRE_COLORPRESPRIMARIA,'') as colorPresPrim,fm.CANTIDAD_LOTE"+
                                    " from PROGRAMA_PRODUCCION pp inner join COMPONENTES_PROD cp on cp.COD_COMPPROD=pp.COD_COMPPROD"+
                                    " inner join FORMAS_FARMACEUTICAS f on f.cod_forma=cp.COD_FORMA"+
                                    " inner join productos p on p.cod_prod=cp.COD_PROD"+
                                    " inner join PRESENTACIONES_PRIMARIAS ppm on ppm.COD_COMPPROD=cp.COD_COMPPROD and ppm.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD"+
                                    " inner join ENVASES_PRIMARIOS ep on ep.cod_envaseprim=ppm.COD_ENVASEPRIM" +
                                    " inner join PROGRAMA_PRODUCCION_PERIODO ppp on pp.COD_PROGRAMA_PROD=ppp.COD_PROGRAMA_PROD" +
                                    " inner join FORMULA_MAESTRA fm on fm.COD_FORMULA_MAESTRA=pp.COD_FORMULA_MAESTRA" +
                                    " left outer join SEGUIMIENTO_TAMIZADO_LOTE stl on stl.COD_LOTE=pp.COD_LOTE_PRODUCCION"+
                                    " and stl.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD" +
                                    " left outer join COLORES_PRESPRIMARIA cpp on cpp.COD_COLORPRESPRIMARIA=cp.COD_COLORPRESPRIMARIA" +
                                    " left outer join DESCRIPCION_PROCESOS_FORMA_FARMACEUTICA dpff on dpff.COD_FORMA=cp.COD_FORMA" +
                                    " left outer join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_AREA_EMPRESA ="+
                                    " 96 and afm.COD_ACTIVIDAD = 11 and afm.COD_FORMULA_MAESTRA =pp.COD_FORMULA_MAESTRA" +
                                    " and afm.COD_PRESENTACION=0" +
                                    " left outer join ACTIVIDADES_FORMULA_MAESTRA afm1 on afm1.COD_AREA_EMPRESA ="+
                                    " 96 and afm1.COD_ACTIVIDAD = 13 and afm1.COD_FORMULA_MAESTRA =pp.COD_FORMULA_MAESTRA" +
                                    " and afm1.COD_PRESENTACION=0" +
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
                    String precaucionesTamizado="";
                    String condicionesGeneralesTamizado="";
                    String codComprodMix="";
                    Double[] prod1=new Double[4];
                    Double[] prod2=new Double[4];
                    double cantidadAsociada=0;
                    double rendimientoAsociado=0;
                    char b=13;char c=10;
                    if(res.next())
                    {
                        prod1[0]=res.getDouble("COD_COMPPROD");

                        prod1[1]=(res.getDouble("CANT_LOTE_PRODUCCION")/res.getDouble("CANTIDAD_LOTE"));
                        rendimientoAsociado=(res.getDouble("cantAsociado")/res.getDouble("CANTIDAD_LOTE"));
                        prod1[2]=res.getDouble("COD_FORMULA_MAESTRA");

                        prod1[3]=res.getDouble("COD_TIPO_PROGRAMA_PROD");
                        fechaCierre=(res.getTimestamp("FECHA_CIERRE")!=null?res.getTimestamp("FECHA_CIERRE"):new Date());
                        codEstadoHoja=res.getInt("COD_ESTADO_HOJA");
                        codPersonalSupervisor=res.getString("COD_PERSONAL_SUPERVISOR");
                        codFormulaMaestra=res.getInt("COD_FORMULA_MAESTRA");
                        codCompProd=res.getInt("COD_COMPPROD");
                        codTipoProgramaProd=res.getInt("COD_TIPO_PROGRAMA_PROD");
                        codActividadTamizado=res.getInt("codActividadTamizado");
                        codActividadMezclado=res.getInt("codActividadMezclado");
                        if(codActividadTamizado==0)out.println("<script>alert('No se encuentra asociadad la actividad de Tamizado');window.close();</script>");
                        if(codActividadMezclado==0)out.println("<script>alert('No se encuentra asociadad la actividad de Mezclado');window.close();</script>");
                        precaucionesTamizado=res.getString("PRECAUCIONES_TAMIZADO").replace(b,'\n').replace("\n", "</br>").replace("</br></br>","<br>").replace("\"v\"","\"√\"");
                        condicionesGeneralesTamizado=res.getString("CONDICIONES_GENERALES_TAMIZADO").replace(b,'\n').replace("\n", "</br>").replace("</br></br>","<br>").replace("\"v\"","\"√\"");
                        observacionLote=res.getString("OBSERVACION");
                        codSeguimientoTamizado=res.getString("COD_SEGUIMIENTO_TAMIZADO_LOTE");
                        volumen=res.getString("VOLUMEN_ENVASE_PRIMARIO");
                        nombreProducto=res.getString("nombre_prod");
                        cantidadAmpollas=res.getInt("CANT_LOTE_PRODUCCION");
                        %>

<section class="main">
                         <div class="row"  style="margin-top:5px" >
                                <div class="large-12 medium-12 small-12 large-centered medium-centered small-centered columns" >

                                            <div class="row">
                                               <div class="large-12 medium-12 small-12 columns divHeaderClass" >
                                                       <label  class="inline">TAMIZADO/LUBRICADO</label>
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
                                   <label  class="inline">TAMIZADO/LUBRICADO</label>
                            </div>
                        </div>
                        <div class="row" >

                        <div  class="divContentClass large-12 medium-12 small-12 columns" style="padding-top:12px;">
                        <span style="margin-top:10px;font-weight:bold;">
                            Precauciones:<br><br>
                        </span>
                        <span style="top:10px;"><%=(precaucionesTamizado)%></span>
                        <span style="margin-top:10px;font-weight:bold;">
                           <br><br>Condiciones Generales:<br><br>
                        </span>
                        <span style="top:10px;"><%=(condicionesGeneralesTamizado)%></span>
                        <div class="row">
                            <div class="large-8 medium-10 small-12 large-centered medium-centered small-centered columns">
                                <table style="width:100%;margin-top:2%;" id="dataEspecificacionesTamizado" cellpadding="0px" cellspacing="0px">
                                            
                              <%
                              
                              }
                      if(res.next())
                      {
                                prod2[0]=res.getDouble("COD_COMPPROD");
                                prod2[1]=(res.getDouble("CANT_LOTE_PRODUCCION")/res.getDouble("CANTIDAD_LOTE"));
                                prod2[2]=res.getDouble("COD_FORMULA_MAESTRA");
                                prod2[3]=res.getDouble("COD_TIPO_PROGRAMA_PROD");
                                if(!codComprodMix.equals(res.getString("COD_COMPPROD")))
                                {
                                    codComprodMix+=","+res.getString("COD_COMPPROD");
                                }
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
                                             " from SEGUIMIENTO_ESPECIFICACIONES_TAMIZADO_LOTE s inner join personal p on"+
                                             " p.COD_PERSONAL=s.COD_PERSONAL"+
                                             " where s.COD_SEGUIMIENTO_TAMIZADO_LOTE='"+codSeguimientoTamizado+"'"+
                                             " group by p.COD_PERSONAL,p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRES_PERSONAL"+
                                             " order by p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRES_PERSONAL";
                                    System.out.println("consulta pers esp "+consulta);
                                    res=st.executeQuery(consulta);
                                    while(res.next())
                                    {
                                        innerCabeceraPersonal+="<td colspan='2' class='tableHeaderClass' style='text-align:center;'><span class='textHeaderClass'>"+res.getString("nombrePersonal")+"</span></td>";
                                        cabeceraPersonal+=",isnull(setl"+res.getRow()+".OBSERVACION,'') as OBSERVACION"+res.getRow()+
                                                          ",setl"+res.getRow()+".CONFORME as CONFORME"+res.getRow()+",setl"+res.getRow()+".VALOR_EXACTO AS VALORreSULTADO"+res.getRow()+",isnull(setl"+res.getRow()+".COD_MAQUINA,0)as registrado"+res.getRow();
                                        detallePersonal+=" left outer join SEGUIMIENTO_ESPECIFICACIONES_TAMIZADO_LOTE setl"+res.getRow()+" on"+
                                                         " setl"+res.getRow()+".COD_ESPECIFICACION_PROCESO = ep.COD_ESPECIFICACION_PROCESO" +
                                                         " and setl"+res.getRow()+".COD_MAQUINA=m.COD_MAQUINA and"+
                                                         " setl"+res.getRow()+".COD_SEGUIMIENTO_TAMIZADO_LOTE = '"+codSeguimientoTamizado+"'" +
                                                         " and setl"+res.getRow()+".COD_PERSONAL='"+res.getInt("COD_PERSONAL")+"'";
                                        contDetalle=res.getRow();
                                    }

                                }
                                consulta="select m.CODIGO,m.COD_MAQUINA,m.NOMBRE_MAQUINA,ep.NOMBRE_ESPECIFICACIONES_PROCESO,"+
                                         " ISNULL(um.ABREVIATURA,'') AS ABREVIATURA,ep.COD_ESPECIFICACION_PROCESO,ep.RESULTADO_NUMERICO,ep.PORCIENTO_TOLERANCIA,"+
                                         " egp.VALOR_TEXTO,egp.VALOR_EXACTO,ep.RESULTADO_ESPERADO_LOTE" +
                                         (administrador?cabeceraPersonal:",isnull(stl.OBSERVACION,'') as OBSERVACION" +
                                         " ,stl.CONFORME,stl.VALOR_EXACTO AS VALORreSULTADO,isnull(stl.COD_MAQUINA,0)as registrado")+
                                         " from ESPECIFICACIONES_TAMIZADO_PROD egp inner join MAQUINARIAS m on egp.COD_MAQUINA = m.COD_MAQUINA"+
                                         " inner join ESPECIFICACIONES_PROCESOS ep on egp.COD_ESPECIFICACION_PROCESO =ep.COD_ESPECIFICACION_PROCESO"+
                                         " left outer join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA =ep.COD_UNIDAD_MEDIDA" +
                                         (administrador?detallePersonal:" left outer join SEGUIMIENTO_ESPECIFICACIONES_TAMIZADO_LOTE stl on "+
                                         " stl.COD_ESPECIFICACION_PROCESO=egp.COD_ESPECIFICACION_PROCESO"+
                                         " and stl.COD_MAQUINA=m.COD_MAQUINA and "+
                                         " stl.COD_SEGUIMIENTO_TAMIZADO_LOTE='"+codSeguimientoTamizado+"'"+
                                         " and stl.COD_PERSONAL='"+codPersonal+"'")+
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
                        <table style="width:100%;margin-top:8px" id="dataTiemposTamizado" cellpadding="0px" cellspacing="0px">
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
                                        " and sppp.COD_COMPPROD='"+codCompProd+"' and sppp.COD_ACTIVIDAD_PROGRAMA='"+codActividadTamizado+"'"+
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
                                    <button <%=(administrador?"disabled":"")%> class="small button succes radius buttonMas" onclick="nuevoRegistroGeneral('dataTiemposTamizado')">+</button>
                              </div>
                              <div class="large-1 medium-1 small-2 columns">
                                    <button <%=(administrador?"disabled":"")%> class="small button succes radius buttonMenos" onclick="eliminarRegistroTabla('dataTiemposTamizado');">-</button>
                              </div>
                              <div class="large-5 medium-5 small-4 columns" style="">&nbsp;</div>
                       </div>
                       <table style="width:100%;margin-top:8px" id="dataTamizado" cellpadding="0px" cellspacing="0px">
                           <tr>
                               <td class="tableHeaderClass primerafilaSelect"  style="text-align:center">
                                   <span class="textHeaderClass">PROCESO DE MEZCLA EN SECO</span>
                               </td>
                           </tr>
                           <tr>
                               <td style="position:relative">
                               <div style="margin-top:2%;position:absolute;width:100%;z-index:5;visibility:hidden" id="imagenDetalle1">
                               <center><img src="../../reponse/img/load3.GIF"  style="z-index:6; "/></center>
                               </div>
                               <div   id="divDetalle" style="
                                    width:100%;
                                    z-index: 2;
                                    position:absolute;
                                    visibility:hidden;
                                    overflow:auto;
                                    text-align:center;"  >
                                        <center >
                                            <div style="width:70%;">
                                            <div class="row" >
                                              <div class='divHeaderClass large-12 medium-12 small-12 columns'   ><%--onmousedown="comienzoMovimiento(event, 'divDetalle')"--%>
                                                  <label  class="inline" > Registro de Seguimiento Por Personal</label>
                                               </div>
                                            </div>
                                            <div class="row">
                                                <div class="divContentClass large-12 medium-12 small-12 columns" id="panelSeguimiento"  >
                                                    <div class="row" style="margin-top:2%">
                                                        <div class="large-5 medium-5 small-5 columns">
                                                            <span class='textHeaderClassBody' style="font-size:16px;" onclick='cambiarValor1()' >Conforme:</span>
                                                        </div>
                                                        <div class="large-7 medium-7 small-7 columns">
                                                            <input type='checkbox' id='conforme' style="width:20px;height:20px" onclick='cambiarValor1()'>
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="large-5 medium-5 small-5 columns">
                                                            <span class='textHeaderClassBody' style="font-size:16px;" onclick="cambiarValor2()" >No Conforme:</span>
                                                        </div>
                                                        <div class="large-7 medium-7 small-7 columns">
                                                            <input type='checkbox' id='noconforme' style="width:20px;height:20px" onclick='cambiarValor2()'>
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="large-5 medium-5 small-5 columns">
                                                            <span class='textHeaderClassBody' style="font-size:16px;" >Responsable :</span>
                                                        </div>
                                                        <div class="large-7 medium-7 small-7 columns">
                                                            <select id='codResponsable' >
                                                                <option value='0'>-Ninguno-</option>
                                                            </select>
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="large-5 medium-5 small-5 columns">
                                                            <span class='textHeaderClassBody' style="font-size:16px;" >Responsable 2:</span>
                                                        </div>
                                                        <div class="large-7 medium-7 small-7 columns">
                                                            <select id='codResponsable2' >
                                                                <option value='0'>-Ninguno-</option>
                                                            </select>
                                                        </div>
                                                    </div>
                                                     <div class="row">
                                                        <div class="large-5 medium-5 small-5 columns">
                                                            <span class='textHeaderClassBody' style="font-size:16px;" >Observaciones</span>
                                                        </div>
                                                        <div class="large-7 medium-7 small-7 columns">
                                                            <textarea id="observaciones" style="width:100%"></textarea>
                                                        </div>
                                                    </div>
                                                     <div class="row">
                                                            <div class="large-8 small-10 medium-12 large-centered medium-centered columns">
                                                                <div class="row">
                                                                    <div class="large-6 medium-6 small-12 columns">
                                                                        <input type="button"  class="small button succes radius" onclick="guardarSeguimiento();" value="Guardar"/>
                                                                     </div>
                                                                        <div class="large-6 medium-6 small-12  columns">
                                                                            <input type="button"  class="small button succes radius" onclick="ocultarSeguimiento();" value="Cancelar"/>

                                                                        </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                  </div>
                                            </div>
                                            </div>
                                        </center>
                              </div>
                              <div  id="modalTamizado"  >
                               </div>

                                   <div id="diagrama" class="large-12 medium-12 small-12 columns"
            style="margin-top:1%; border:1px solid #a80077;border-bottom-left-radius: 10px;border-bottom-right-radius: 10px;
            border-top-left-radius: 10px;border-top-right-radius: 10px; "></div>
                                   <script type="text/javascript">

            var uml = Joint.dia.uml;
            var fd=Joint.point;
            <%
                boolean loteMix=false;
                loteMix=codComprodMix.split(",").length>1;
                if(loteMix)
                {
                    consulta="select case when cpm.NRO_COMPPROD_DIAGRAMA_PREPARADO=1 then"+
                             " cpm.COD_COMPROD1 else cpm.COD_COMPROD2 end as codDiagrama"+
                             " from COMPONENTES_PROD_MIX cpm where cpm.COD_COMPROD_MIX='"+codCompProd+"'";
                    System.out.println("consulta codComprodMix "+consulta);
                    res=st.executeQuery(consulta);
                    if(res.next())
                    {
                        codCompProd=res.getInt("codDiagrama");
                    }
                    else
                    {
                        out.println("<script>alert('No se definio el lote mix,solicite a Dirección Técnica');</script>");
                    }
                    if(codCompProd!=prod1[0].intValue())
                    {
                        Double[] aux= new Double[4];
                       aux[0]=prod1[0];
                       aux[1]=prod1[1];
                       aux[2]=prod1[2];
                       aux[3]=prod1[3];
                       prod1[0]=prod2[0];
                       prod1[1]=prod2[1];
                       prod1[2]=prod2[2];
                       prod1[3]=prod2[3];
                       prod2[0]=aux[0];
                       prod2[1]=aux[1];
                       prod2[2]=aux[2];
                       prod2[3]=aux[3];
                    }
                }
                else
                {
                    codCompProd=prod1[0].intValue();
                }
                if(cantidadAsociada>0)prod1[1]=prod1[1]+rendimientoAsociado;
                 consulta="select pp.COD_PROCESO_PRODUCTO,pp.OPERARIO_TIEMPO_COMPLETO,pp.descripcion,pp.TIEMPO_PROCESO,pp.COD_PROCESO_PRODUCTO,pp.NRO_PASO,ap.NOMBRE_ACTIVIDAD_PREPARADO," +
                        " pp.TIEMPO_PROCESO_PERSONAL,pp.PORCIENTO_TOLERANCIA_TIEMPO_PROCESO," +
                        " isnull(sppl.COD_PERSONAL,0) as COD_PERSONAL,isnull(sppl.COD_PERSONAL2,0) as codPersonal2,"+
                        " isnull(sppl.CONFORME,0) as conforme,isnull(sppl.OBSERVACIONES,'') as OBSERVACIONES" +
                        " ,ISNULL(p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRE_PILA+' '+p.nombre2_personal,'No Registrado') as operario"+
                        " ,ISNULL(p2.AP_PATERNO_PERSONAL+' '+p2.AP_MATERNO_PERSONAL+' '+p2.NOMBRE_PILA+' '+p2.nombre2_personal,'No Registrado') as operario2"+
                        " from PROCESOS_PRODUCTO pp inner join ACTIVIDADES_PREPARADO ap on "+
                        " ap.COD_ACTIVIDAD_PREPARADO=pp.COD_ACTIVIDAD_PREPARADO "+
                        "  left outer JOIN maquinarias m on m.COD_MAQUINA=pp.COD_MAQUINA" +
                        " left outer join SEGUIMIENTO_PROCESOS_PREPARADO_LOTE sppl on sppl.COD_LOTE='"+codLote+"'"+
                        " and sppl.COD_PROCESO_PRODUCTO=pp.COD_PROCESO_PRODUCTO and sppl.COD_SUB_PROCESO_PRODUCTO='0'" +
                        " left outer join PERSONAL p on p.COD_PERSONAL=sppl.COD_PERSONAL" +
                        " left outer join PERSONAL p2 on p2.COD_PERSONAL=sppl.COD_PERSONAL2"+
                        " where pp.COD_COMPPROD="+codCompProd+" and pp.COD_PROCESO_ORDEN_MANUFACTURA=8 order by pp.NRO_PASO";
                    System.out.println("consulta procesos prod "+consulta);
                    res=st.executeQuery(consulta);
                    String codProceso="";
                    String codSubProceso="";
                    String codProcesoDestino="";
                    int posYcen=10;
                    int posYder=10;
                    int posYizq=10;
                    int posSubProceso=0;
                    Statement std=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet resd=null;
                    String codProcesoProd="";
                    String codSubProcesoProd="";
                    String especificaciones="";
                    String espEquipSubProces="";
                    String nodos="";
                    int cont2=0;
                    int contNodoP=0;
                    int contNodoSubP=0;
                    int nroPasoProceso=0;
                    int nroPasoSubProceso=0;
                    boolean subprocesoDer=true;
                    boolean primerRegistro=false;
                    Statement stdd=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet resdd=null;
                    String script="";
                    String scriptUnion="";
                    String materiales="";
                    String materialesSubProceso="";
                    double tiempoProceso=0;
                    double tiempoSubProces=0;
                    String descripcion="";
                    String descripcionSubProces="";
                    String maquinariasDetalles="";
                    String cabecera="";
                    String cabeceraSubProces="";
                    String maquinariasSubProces="";
                    int operarioTiempoCompletoProcesos=0;
                    int operarioTiempoCompletoSubProceso=0;
                    String variables="";
                    List<String[]> listaPuntos=new ArrayList();
                    String[] puntos=new String[3];
                    puntos[0]="";
                    puntos[1]="";
                    puntos[2]="";
                    String[] subPuntos=new String[3];
                    subPuntos[0]="";
                    subPuntos[1]="";
                    subPuntos[2]="";
                    String codPersonalProceso="0";
                    String codPersonal2Proceso="0";
                    String conforme="0";
                    String observacion="";
                    String operario="";
                    String operario2="";
                    String codPersonalSubProceso="0";
                    String codPersonalSubProceso2="0";
                    String conforme2="0";
                    String observacion2="";
                    String operarioSubProceso="";
                    String operarioSubProceso2="";
                    while(res.next())
                    {
                        cont2++;
                        contNodoP++;
                        operario=res.getString("operario");
                        operario2=res.getString("operario2");
                        codPersonalProceso=res.getString("COD_PERSONAL");
                        codPersonal2Proceso=res.getString("codPersonal2");
                        conforme=(res.getInt("conforme")>0?"1":"0");
                        observacion=res.getString("OBSERVACIONES");
                        codProceso=res.getString("COD_PROCESO_PRODUCTO");
                        operarioTiempoCompletoProcesos=res.getInt("OPERARIO_TIEMPO_COMPLETO");
                        nroPasoProceso=res.getInt("NRO_PASO");
                        codProcesoProd=res.getString("COD_PROCESO_PRODUCTO");
                        tiempoProceso=res.getInt("TIEMPO_PROCESO");
                        descripcion=res.getString("descripcion");
                        especificaciones="";
                        if(!codProcesoDestino.equals(""))
                        {
                            subPuntos[1]="s"+codProcesoDestino;
                            subPuntos[2]="1";
                            listaPuntos.add(subPuntos);
                        }
                        else
                        {
                            if((subPuntos[0].length()>0) && (subPuntos[0].charAt(0)=='p'))
                            {
                                subPuntos[1]="s"+codProcesoProd;
                                subPuntos[2]="2";
                                listaPuntos.add(subPuntos);
                            }
                        }
                        if(!puntos[0].equals(""))
                        {
                            System.out.println("ccccccccc "+codProcesoProd);
                            puntos[1]="s"+codProcesoProd;
                            puntos[2]="";
                            listaPuntos.add(puntos);
                        }

                        subPuntos=new String[3];
                        subPuntos[0]="s"+codProcesoProd;
                        subPuntos[1]="";
                        subPuntos[2]="";
                        puntos=new String[3];
                        puntos[0]="s"+codProcesoProd;
                        puntos[1]="";
                        puntos[2]="";
                        codProcesoDestino="";
                        posYcen=posYizq>posYcen?posYizq:posYcen;
                        posSubProceso=0;
                        consulta="select ppeq.COD_ESPECIFICACION_EQUIPO_AMBIENTE,m.NOMBRE_MAQUINA,m.codigo,isnull(eea.NOMBRE_ESPECIFICACION_EQUIPO_AMBIENTE,'') as NOMBRE_ESPECIFICACION_EQUIPO_AMBIENTE,"+
                                " ISNULL(case WHEN td.COD_TIPO_DESCRIPCION = 1 THEN (case when ppeq.DATOS_NO_CONSOLIDADOS=0 then ppeq.VALOR_DESCRIPTIVO else '_______________' end )"+
                                " WHEN td.COD_TIPO_DESCRIPCION = 2 THEN (case when ppeq.DATOS_NO_CONSOLIDADOS=0 then CAST (ppeq.RANGO_INFERIOR"+
                                " as varchar) + ' - ' + cast (ppeq.RANGO_SUPERIOR as varchar) else '____-_____' end)"+
                                " else (case when ppeq.DATOS_NO_CONSOLIDADOS=0 then CAST (ppeq.VALOR_EXACTO as varchar)else '_____' end )"+
                                " end, '') as resultado,"+
                                " (case WHEN eea.COD_UNIDAD_MEDIDA>0 THEN um.ABREVIATURA"+
                                " WHEN eea.COD_UNIDAD_TIEMPO>0 THEN ut.ABREVIATURA "+
                                " WHEN eea.COD_UNIDAD_VELOCIDAD >0 then  uv.NOMBRE_UNIDAD_VELOCIDAD" +
                                " when eea.COD_UNIDAD_MEDIDA_TEMPERATURA>0 then umt.ABREVIATURA"+
                                " else '4'  end ) as unidad,ppeq.PORCIENTO_TOLERANCIA,(eea.TOLERANCIA*ppeq.VALOR_EXACTO) AS TOLERANCIA" +
                                " ,eea.TOLERANCIA as toleranciaEspecificacion"+
                                " from PROCESOS_PRODUCTO_MAQUINARIA ppm inner join maquinarias m on "+
                                " m.COD_MAQUINA=ppm.COD_MAQUINA left outer join "+
                                " PROCESOS_PRODUCTO_ESP_EQUIP ppeq on"+
                                " ppm.COD_MAQUINA=ppeq.COD_MAQUINA and ppm.COD_PROCESO_PRODUCTO=ppeq.COD_PROCESO_PRODUCTO and ppeq.COD_FORMULA_MAESTRA='"+(Math.round(prod1[2]))+"'" +
                                " left outer join ESPECIFICACIONES_EQUIPO_AMBIENTE eea on"+
                                " eea.COD_ESPECIFICACION_EQUIPO_AMBIENTE=ppeq.COD_ESPECIFICACION_EQUIPO_AMBIENTE left outer join"+
                                " TIPOS_DESCRIPCION td on td.COD_TIPO_DESCRIPCION=eea.COD_TIPO_DESCRIPCION"+
                                " LEFT OUTER JOIN UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=eea.COD_UNIDAD_MEDIDA"+
                                " left outer join UNIDADES_TIEMPO ut on ut.COD_UNIDAD_TIEMPO=eea.COD_UNIDAD_TIEMPO"+
                                " left outer join UNIDADES_VELOCIDAD_MAQUINARIA uv on uv.COD_UNIDAD_VELOCIDAD=eea.COD_UNIDAD_VELOCIDAD" +
                                " left outer join UNIDADES_MEDIDA_TEMPERATURA umt on "+
                                " umt.COD_UNIDAD_MEDIDA_TEMPERATURA=eea.COD_UNIDAD_MEDIDA_TEMPERATURA"+
                                " where ppm.COD_PROCESO_PRODUCTO='"+codProcesoProd+"' order by m.NOMBRE_MAQUINA,m.codigo,NOMBRE_ESPECIFICACION_EQUIPO_AMBIENTE";
                        System.out.println("consulta esp "+consulta);
                        resd=std.executeQuery(consulta);
                        int cont=tiempoProceso>0?7:5;
                        cabecera="";
                        maquinariasDetalles="";
                        String nombreMaq="";
                        String resultado="";
                        while(resd.next())
                        {
                            nombreMaq=resd.getString("NOMBRE_MAQUINA")+" "+resd.getString("codigo");
                            cont++;
                           if(!cabecera.equals(nombreMaq))
                           {
                               maquinariasDetalles+= cabecera.equals("")?"":((maquinariasDetalles.equals("")?"":",")+"['"+cabecera+"',["+especificaciones+"]]");
                               cabecera=nombreMaq;
                               especificaciones="";
                           }
                            if(!resd.getString("NOMBRE_ESPECIFICACION_EQUIPO_AMBIENTE").equals(""))
                             {
                                resultado=resd.getString("resultado");
                                double cant=0d;
                                if(resd.getInt("COD_ESPECIFICACION_EQUIPO_AMBIENTE")==10)
                                {
                                    Statement stMat=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                    ResultSet resMat=stMat.executeQuery("select SUM(fd.CANTIDAD/(case when fd.COD_UNIDAD_MEDIDA = 7 then 1000 else 1 end)) as cantMat from FORMULA_MAESTRA_DETALLE_MP fd where fd.COD_FORMULA_MAESTRA ='"+(Math.round(prod1[2]))+"'");
                                    System.out.println("consulta cantida fm select SUM(fd.CANTIDAD/(case when fd.COD_UNIDAD_MEDIDA = 7 then 1000 else 1 end)) as cantMat from FORMULA_MAESTRA_DETALLE_MP fd where fd.COD_FORMULA_MAESTRA ='"+(Math.round(prod1[2]))+"'");
                                    
                                    System.out.println("c "+prod1[1]+" d "+prod2[1] );
                                    if(resMat.next())
                                    {
                                        cant=resMat.getDouble("cantMat")*prod1[1];
                                    }
                                    if(loteMix)
                                    {
                                        resMat=stMat.executeQuery("select SUM(fd.CANTIDAD/(case when fd.COD_UNIDAD_MEDIDA = 7 then 1000 else 1 end)) as cantMat from FORMULA_MAESTRA_DETALLE_MP fd where fd.COD_FORMULA_MAESTRA ='"+(Math.round(prod2[2]))+"'");
                                        System.out.println("consulta cantidad fm 2 select SUM(fd.CANTIDAD/(case when fd.COD_UNIDAD_MEDIDA = 7 then 1000 else 1 end)) as cantMat from FORMULA_MAESTRA_DETALLE_MP fd where fd.COD_FORMULA_MAESTRA ='"+(Math.round(prod2[2]))+"'");
                                        if(resMat.next())
                                        {
                                            cant+=(resMat.getDouble("cantMat")*prod2[1]);
                                        }
                                    }
                                    resMat.close();
                                    stMat.close();
                                    resultado=format.format(cant);
                                }

                            especificaciones+=((especificaciones.equals("")?"":",")+"'"+resd.getString("NOMBRE_ESPECIFICACION_EQUIPO_AMBIENTE")+"','"+
                                    resultado+" "+resd.getString("unidad")+" "+(resd.getDouble("TOLERANCIA")>0||cant>0?(" ±"+format.format((cant>0?(cant*resd.getDouble("toleranciaEspecificacion")):resd.getDouble("TOLERANCIA")))+" "+resd.getString("unidad")):"")+"'");
                            }
                        }
                        maquinariasDetalles+= cabecera.equals("")?"":((maquinariasDetalles.equals("")?"":",")+"['"+cabecera+"',["+especificaciones+"]]");
                        consulta="select m.NOMBRE_MATERIAL,ppem.CANTIDAD,um.ABREVIATURA,fmd.CANTIDAD as cantidadfm," +// as porcenta,ppem.PORCIENTO_MATERIAL,fmd.CANTIDAD
                                " ISNULL(fmd1.CANTIDAD,0) as cantidadSegundoMaterial"+
                                 " from PROCESOS_PRODUCTO_ESP_MAT ppem " +
                                 " inner join MATERIALES m on m.COD_MATERIAL=ppem.COD_MATERIAL"+
                                 " inner join FORMULA_MAESTRA_DETALLE_MP fmd on fmd.COD_MATERIAL=ppem.COD_MATERIAL "+
                                 " and fmd.COD_FORMULA_MAESTRA=ppem.COD_FORMULA_MAESTRA"+
                                 " inner join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=fmd.COD_UNIDAD_MEDIDA" +
                                 " left outer join FORMULA_MAESTRA_DETALLE_MP fmd1 on"+
                                 " fmd1.COD_MATERIAL=ppem.COD_MATERIAL and fmd1.COD_FORMULA_MAESTRA='"+(loteMix?Math.round(prod2[2]):0)+"'" +
                                 " where ppem.COD_PROCESO_PRODUCTO='"+codProcesoProd+"' and ppem.COD_FORMULA_MAESTRA='"+(loteMix?Math.round(prod2[2]):Math.round(prod1[2]))+"'";
                        consulta="SELECT m.NOMBRE_MATERIAL,um.ABREVIATURA,fmd.cantidad,sum(fmdf.cantidad) as cantidadFraccion,"+
                                 " fmd.CANTIDAD AS cantidadfm,ISNULL(fmd1.CANTIDAD, 0) AS cantidadSegundoMaterial " +
                                 " FROM PROCESOS_PRODUCTO_ESP_MAT ppem INNER JOIN MATERIALES m ON m.COD_MATERIAL = ppem.COD_MATERIAL"+
                                 " INNER JOIN FORMULA_MAESTRA_DETALLE_MP fmd ON fmd.COD_MATERIAL = ppem.COD_MATERIAL"+
                                 " AND fmd.COD_FORMULA_MAESTRA = ppem.COD_FORMULA_MAESTRA"+
                                 " inner join FORMULA_MAESTRA_DETALLE_MP_FRACCIONES fmdf on fmd.COD_FORMULA_MAESTRA=fmdf.COD_FORMULA_MAESTRA"+
                                 " and fmd.COD_MATERIAL=fmdf.COD_MATERIAL and fmdf.COD_FORMULA_MAESTRA_FRACCIONES=ppem.COD_FORMULA_MAESTRA_FRACCIONES"+
                                 " INNER JOIN UNIDADES_MEDIDA um ON um.COD_UNIDAD_MEDIDA = fmd.COD_UNIDAD_MEDIDA"+
                                 " LEFT OUTER JOIN FORMULA_MAESTRA_DETALLE_MP fmd1 ON fmd1.COD_MATERIAL = ppem.COD_MATERIAL"+
                                 " AND fmd1.COD_FORMULA_MAESTRA = '"+(loteMix?Math.round(prod2[2]):0)+"'"+
                                 " WHERE ppem.COD_PROCESO_PRODUCTO = '"+codProcesoProd+"' AND ppem.COD_FORMULA_MAESTRA = '"+(Math.round(prod1[2]))+"'"+
                                 " group by  m.NOMBRE_MATERIAL,um.ABREVIATURA,fmd.cantidad,fmd.CANTIDAD ,fmd1.CANTIDAD";
                                System.out.println("consulta materiales "+consulta);
                                resd=std.executeQuery(consulta);
                                materiales="";
                                double porciento=0d;
                                while(resd.next())
                                {
                                    cont++;
                                     porciento=(loteMix?(resd.getDouble("cantidadFraccion")/resd.getDouble("cantidadfm")):0);
                                    materiales+=((materiales.equals("")?"":",")+"'"+resd.getString("NOMBRE_MATERIAL")+"','"+
                                            nf.format(loteMix?((resd.getDouble("cantidadFraccion")*prod1[1])+(resd.getDouble("cantidadSegundoMaterial")*prod2[1]*porciento)):(resd.getDouble("cantidadFraccion")*prod1[1]))+
                                            //nf.format((resd.getDouble("CANTIDAD")*resd.getDouble("PORCIENTO_MATERIAL")*prod1[1])+(prod2[2]==null?0:((resd.getDouble("cantidadSegundoMaterial")*resd.getDouble("PORCIENTO_MATERIAL")*prod2[1]))))+
                                            " ("+resd.getString("ABREVIATURA")+")'");
                                }
                        consulta="select spp.COD_PROCESO_PRODUCTO_DESTINO,spp.COD_SUB_PROCESO_PRODUCTO,spp.descripcion,spp.TIEMPO_SUB_PROCESO,spp.COD_SUB_PROCESO_PRODUCTO,ap.NOMBRE_ACTIVIDAD_PREPARADO,spp.NRO_PASO,"+
                                 " spp.TIEMPO_SUB_PROCESO_PERSONAL,spp.PORCIENTO_TOLERANCIA_TIEMPO_SUB_PROCESO,spp.OPERARIO_TIEMPO_COMPLETO" +
                                " ,isnull(sppl.COD_PERSONAL,0) as COD_PERSONAL,isnull(sppl.COD_PERSONAL2,0) as codPersonal2,"+
                                " isnull(sppl.CONFORME,0) as conforme,isnull(sppl.OBSERVACIONES,'') as OBSERVACIONES" +
                                " ,ISNULL(p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRE_PILA+' '+p.nombre2_personal,'No Registrado') as operario"+
                                " ,ISNULL(p2.AP_PATERNO_PERSONAL+' '+p2.AP_MATERNO_PERSONAL+' '+p2.NOMBRE_PILA+' '+p2.nombre2_personal,'No Registrado') as operario2"+
                                 " from SUB_PROCESOS_PRODUCTO spp inner join ACTIVIDADES_PREPARADO ap"+
                                 " on spp.COD_ACTIVIDAD_PREPARADO=ap.COD_ACTIVIDAD_PREPARADO"+
                                 " left outer join maquinarias m on m.COD_MAQUINA=spp.COD_MAQUINA"+
                                 " left outer join SEGUIMIENTO_PROCESOS_PREPARADO_LOTE sppl on sppl.COD_PROCESO_PRODUCTO=spp.COD_PROCESO_PRODUCTO"+
                                 " and sppl.COD_SUB_PROCESO_PRODUCTO=spp.COD_SUB_PROCESO_PRODUCTO and sppl.COD_LOTE='"+codLote+"'"+
                                 " left outer join PERSONAL p on p.COD_PERSONAL=sppl.COD_PERSONAL"+
                                 " left outer join PERSONAL p2 on p2.COD_PERSONAL=sppl.COD_PERSONAL2"+
                                 " where spp.COD_PROCESO_PRODUCTO='"+codProcesoProd+"'" +
                                 " order by spp.NRO_PASO";
                        System.out.println("consulta subprocesos "+consulta);
                        resd=std.executeQuery(consulta);
                        contNodoSubP=0;
                        primerRegistro=true;
                        subprocesoDer=true;
                         script+="var s"+codProcesoProd+" = uml.State.create({rect: {x:750, y: "+posYcen+", width: 400, height:"+(cont+3+(descripcion.equals("")?0:6))*18+"},"+
                                "label: '"+nroPasoProceso+"-Actividad:"+res.getString("NOMBRE_ACTIVIDAD_PREPARADO")+( tiempoProceso>0?"-Tiempo:"+tiempoProceso+
                                " min-Tolerancia:"+nf.format((res.getDouble("PORCIENTO_TOLERANCIA_TIEMPO_PROCESO")/100)*tiempoProceso)+" min":"")+" -Operario Tiempo Completo:"+(operarioTiempoCompletoProcesos>0?"SI":"NO")+
                                "',attrs: {fill:'90-#000-"+(operarioTiempoCompletoProcesos>0?"#87CEFA":"#FFC0CB")+":1-#fff'}," +
                                (materiales.equals("")?"":"materiales:["+materiales+"],")+
                                (maquinariasDetalles.equals("")?"":("datosMaq:["+maquinariasDetalles+"],"))+
                                "actions:{actividad:null," +
                                "Maquinaria:'ninguno'"+
                                (especificaciones.equals("")?"":",inner: ["+especificaciones+"]") +
                                "},descripcion:'"+descripcion.replace(b, '-').replace(c,' ')+"'" +
                                ",detailsOffsetY:"+(tiempoProceso>0?"5":"3")+",codProcesos:'"+codProceso+"',codSubProceso:'0'" +
                                ",operario:'"+operario+"',operario2:'"+operario2+"',codPersonal:'"+codPersonalProceso+"',codPersonal2:'"+codPersonal2Proceso+"'" +
                                ",conforme:'"+conforme+"',observaciones:'"+observacion+"'});";

                        variables+=(variables.equals("")?"":",")+"s"+codProcesoProd;
                        posYcen+=((cont+3+(descripcion.equals("")?0:6))*17)+50;
                        while(resd.next())
                            {
                                cont2++;
                                operarioSubProceso=resd.getString("operario");
                                operarioSubProceso2=resd.getString("operario2");
                                codPersonalSubProceso=resd.getString("COD_PERSONAL");
                                codPersonalSubProceso2=resd.getString("codPersonal2");
                                conforme2=(resd.getInt("conforme")>0?"1":"0");
                                observacion2=resd.getString("OBSERVACIONES");
                                codProcesoDestino=(resd.getInt("COD_PROCESO_PRODUCTO_DESTINO")>0?resd.getString("COD_PROCESO_PRODUCTO_DESTINO"):"");
                                codSubProceso=resd.getString("COD_SUB_PROCESO_PRODUCTO");
                                operarioTiempoCompletoSubProceso=resd.getInt("OPERARIO_TIEMPO_COMPLETO");
                                descripcionSubProces=resd.getString("descripcion");
                                tiempoSubProces=resd.getDouble("TIEMPO_SUB_PROCESO");
                                nroPasoSubProceso=resd.getInt("NRO_PASO");
                                codSubProcesoProd=resd.getString("COD_SUB_PROCESO_PRODUCTO");
                                subPuntos[1]="p"+codProcesoProd+"s"+codSubProceso;
                                if(subPuntos[0].charAt(0)=='s')
                                {
                                    subPuntos[2]="5";
                                }
                                listaPuntos.add(subPuntos);
                                subPuntos=new String[3];
                                subPuntos[0]="p"+codProcesoProd+"s"+codSubProceso;
                                subPuntos[1]="";
                                subPuntos[2]="";
                                espEquipSubProces="";
                                if(primerRegistro)
                                {
                                    subprocesoDer=!subprocesoDer;
                                    posYcen=(subprocesoDer?(posYder>posYcen?posYder+12:posYcen):(posYizq>posYcen?posYizq+12:posYcen));
                                    posYizq=(subprocesoDer?posYizq:(posYcen>posYizq?posYcen:posYizq));
                                    posYder=(subprocesoDer?(posYcen>posYder?posYcen:posYder):posYder);

                                }
                                contNodoSubP++;
                                consulta="select sppeq.COD_ESPECIFICACION_EQUIPO_AMBIENTE,m.NOMBRE_MAQUINA,ISNULL(m.CODIGO,'') as cod1,isnull(eea.NOMBRE_ESPECIFICACION_EQUIPO_AMBIENTE,'') as NOMBRE_ESPECIFICACION_EQUIPO_AMBIENTE," +
                                        " ISNULL(case WHEN td.COD_TIPO_DESCRIPCION = 1 THEN (case when sppeq.DATOS_NO_CONSOLIDADOS=0 then sppeq.VALOR_DESCRIPTIVO else '__________' end)"+
                                        " WHEN td.COD_TIPO_DESCRIPCION = 2 THEN (case when sppeq.DATOS_NO_CONSOLIDADOS=0 then (CAST ("+
                                        " sppeq.RANGO_INFERIOR as varchar) + ' - ' + cast ( sppeq.RANGO_SUPERIOR as varchar)) ELSE '___-___' end )"+
                                        " else  (case when sppeq.DATOS_NO_CONSOLIDADOS=0 then CAST (sppeq.VALOR_EXACTO as varchar)else '___' end )"+
                                        " end, '') as resultado,"+
                                         " (case WHEN eea.COD_UNIDAD_MEDIDA > 0 THEN um.ABREVIATURA WHEN eea.COD_UNIDAD_TIEMPO > 0 THEN ut.ABREVIATURA"+
                                         " WHEN eea.COD_UNIDAD_VELOCIDAD > 0 then uv.NOMBRE_UNIDAD_VELOCIDAD " +
                                         " WHEN eea.COD_UNIDAD_MEDIDA_TEMPERATURA>0 then umt.ABREVIATURA else ' ' end) as unidad," +
                                         " (eea.TOLERANCIA*sppeq.VALOR_EXACTO) AS tolerancia"+
                                         " from SUB_PROCESOS_PRODUCTO_MAQUINARIA sppm inner join maquinarias m on"+
                                         " sppm.COD_MAQUINA=m.COD_MAQUINA left outer join SUB_PROCESOS_PRODUCTO_ESP_EQUIP sppeq " +
                                         " on sppeq.COD_MAQUINA=sppm.COD_MAQUINA and sppeq.COD_SUB_PROCESO_PRODUCTO=sppm.COD_SUB_PROCESO_PRODUCTO"+
                                         " and sppeq.COD_PROCESO_PRODUCTO=sppm.COD_PROCESO_PRODUCTO and sppeq.COD_FORMULA_MAESTRA='"+(Math.round(prod1[2]))+"'" +
                                         " left outer join ESPECIFICACIONES_EQUIPO_AMBIENTE eea"+
                                         " on eea.COD_ESPECIFICACION_EQUIPO_AMBIENTE=sppeq.COD_ESPECIFICACION_EQUIPO_AMBIENTE"+
                                         " left outer join TIPOS_DESCRIPCION td on td.COD_TIPO_DESCRIPCION =eea.COD_TIPO_DESCRIPCION"+
                                         " left outer join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=eea.COD_UNIDAD_MEDIDA" +
                                         " left outer join UNIDADES_TIEMPO ut on ut.COD_UNIDAD_TIEMPO=eea.COD_UNIDAD_TIEMPO"+
                                         " left outer join UNIDADES_VELOCIDAD_MAQUINARIA uv on uv.COD_UNIDAD_VELOCIDAD=eea.COD_UNIDAD_VELOCIDAD" +
                                         " left outer join UNIDADES_MEDIDA_TEMPERATURA umt on umt.COD_UNIDAD_MEDIDA_TEMPERATURA=eea.COD_UNIDAD_MEDIDA_TEMPERATURA"+
                                         " where sppm.COD_PROCESO_PRODUCTO='"+codProcesoProd+"'  and sppm.COD_SUB_PROCESO_PRODUCTO='"+codSubProcesoProd+"'"+
                                         " order by m.NOMBRE_MAQUINA,eea.NOMBRE_ESPECIFICACION_EQUIPO_AMBIENTE";
                                        System.out.println("consulta buscar det esp equip"+consulta);
                                         resdd=stdd.executeQuery(consulta);

                                         int contSubproces=tiempoSubProces>0?7:5;
                                         cabeceraSubProces="";
                                         maquinariasSubProces="";
                                         String maqSubProcess="";
                                         espEquipSubProces="";
                                         while(resdd.next())
                                         {
                                             maqSubProcess=resdd.getString("NOMBRE_MAQUINA")+" "+resdd.getString("cod1");
                                             if(!cabeceraSubProces.equals(maqSubProcess))
                                               {
                                                   maquinariasSubProces+=cabeceraSubProces.equals("")?"":((maquinariasSubProces.equals("")?"":",")+"['"+cabeceraSubProces+"',["+espEquipSubProces+"]]");
                                                   cabeceraSubProces=maqSubProcess;
                                                   espEquipSubProces="";
                                                   contSubproces++;
                                               }
                                             if(!resdd.getString("NOMBRE_ESPECIFICACION_EQUIPO_AMBIENTE").equals(""))
                                             {
                                                 String resultado2=resdd.getString("resultado");
                                                 if(resdd.getInt("COD_ESPECIFICACION_EQUIPO_AMBIENTE")==10)
                                                    {
                                                        Statement stMat=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                                        ResultSet resMat=stMat.executeQuery("select SUM(fd.CANTIDAD/(case when fd.COD_UNIDAD_MEDIDA = 7 then 1000 else 1 end)) as cantMat from FORMULA_MAESTRA_DETALLE_MP fd where fd.COD_FORMULA_MAESTRA ='"+(Math.round(prod1[2]))+"'");
                                                        System.out.println("consulta cantida fm select SUM(fd.CANTIDAD/(case when fd.COD_UNIDAD_MEDIDA = 7 then 1000 else 1 end)) as cantMat from FORMULA_MAESTRA_DETALLE_MP fd where fd.COD_FORMULA_MAESTRA ='"+(Math.round(prod1[2]))+"'");
                                                        double cant=0d;
                                                        System.out.println("c "+prod1[1]+" d "+prod2[1] );
                                                        if(resMat.next())
                                                        {
                                                            cant=(loteMix?(resMat.getDouble("cantMat")*prod1[1]):resMat.getDouble("cantMat"));
                                                        }
                                                        if(loteMix)
                                                        {
                                                            resMat=stMat.executeQuery("select SUM(fd.CANTIDAD/(case when fd.COD_UNIDAD_MEDIDA = 7 then 1000 else 1 end)) as cantMat from FORMULA_MAESTRA_DETALLE_MP fd where fd.COD_FORMULA_MAESTRA ='"+(Math.round(prod2[2]))+"'");
                                                            System.out.println("consulta cantidad fm 2 select SUM(fd.CANTIDAD/(case when fd.COD_UNIDAD_MEDIDA = 7 then 1000 else 1 end)) as cantMat from FORMULA_MAESTRA_DETALLE_MP fd where fd.COD_FORMULA_MAESTRA ='"+(Math.round(prod2[2]))+"'");
                                                            if(resMat.next())
                                                            {
                                                                cant+=(resMat.getDouble("cantMat")*prod2[1]);
                                                            }
                                                        }
                                                        resMat.close();
                                                        stMat.close();
                                                        resultado2=format.format(cant);
                                                    }
                                                 contSubproces++;
                                                 espEquipSubProces+=((espEquipSubProces.equals("")?"":",")+"'"+resdd.getString("NOMBRE_ESPECIFICACION_EQUIPO_AMBIENTE")+"','"+
                                                    resultado2+" "+resdd.getString("unidad")+(resdd.getDouble("tolerancia")>0?(" ±"+format.format(resdd.getDouble("tolerancia"))+" "+resdd.getString("unidad") ):"")+"'");
                                             }
                                         }
                                         maquinariasSubProces+=cabeceraSubProces.equals("")?"":((maquinariasSubProces.equals("")?"":",")+"['"+cabeceraSubProces+"',["+espEquipSubProces+"]]");
                                         cabeceraSubProces=maqSubProcess;

                                consulta="SELECT m.NOMBRE_MATERIAL,sppem.CANTIDAD ,fmd.CANTIDAD as cantidadFm,um.ABREVIATURA" +
                                        ",ISNULL(fmdsub.CANTIDAD,0) as cantidadCompprod2"+
                                         " FROM SUB_PROCESOS_PRODUCTO_ESP_MAT sppem inner join MATERIALES m"+
                                         " on m.COD_MATERIAL=sppem.COD_MATERIAL inner join FORMULA_MAESTRA_DETALLE_MP"+
                                         " fmd on fmd.COD_FORMULA_MAESTRA=sppem.COD_FORMULA_MAESTRA and"+
                                         " fmd.COD_MATERIAL=sppem.COD_MATERIAL"+
                                         " inner join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=fmd.COD_UNIDAD_MEDIDA" +
                                         " left outer join FORMULA_MAESTRA_DETALLE_MP fmdsub on fmdsub.COD_MATERIAL=sppem.COD_MATERIAL and fmdsub.COD_FORMULA_MAESTRA='"+(loteMix?Math.round(prod2[2]):0)+"'"+
                                         " where  sppem.COD_SUB_PROCESO_PRODUCTO='"+codSubProcesoProd+"'"+
                                         " and sppem.COD_PROCESO_PRODUCTO='"+codProcesoProd+"' and sppem.COD_FORMULA_MAESTRA='"+(loteMix?Math.round(prod2[2]):Math.round(prod1[2]))+"'";
                                 consulta="SELECT m.NOMBRE_MATERIAL,fmd.CANTIDAD AS cantidadFm, um.ABREVIATURA, sum(fmdf.CANTIDAD) as cantidadFracciones,"+
                                         " ISNULL(fmdsub.CANTIDAD, 0) AS cantidadCompprod2 " +
                                         " FROM SUB_PROCESOS_PRODUCTO_ESP_MAT sppem INNER JOIN MATERIALES m ON m.COD_MATERIAL = sppem.COD_MATERIAL"+
                                         " INNER JOIN FORMULA_MAESTRA_DETALLE_MP fmd ON fmd.COD_FORMULA_MAESTRA = sppem.COD_FORMULA_MAESTRA"+
                                         " AND fmd.COD_MATERIAL = sppem.COD_MATERIAL"+
                                         " inner join FORMULA_MAESTRA_DETALLE_MP_FRACCIONES fmdf on fmdf.COD_FORMULA_MAESTRA=fmd.COD_FORMULA_MAESTRA"+
                                         " and m.COD_MATERIAL=fmdf.COD_MATERIAL and fmdf.COD_FORMULA_MAESTRA_FRACCIONES=sppem.COD_FORMULA_MAESTRA_FRACCIONES"+
                                         " INNER JOIN UNIDADES_MEDIDA um ON um.COD_UNIDAD_MEDIDA = fmd.COD_UNIDAD_MEDIDA"+
                                         " LEFT OUTER JOIN FORMULA_MAESTRA_DETALLE_MP fmdsub ON fmdsub.COD_MATERIAL = sppem.COD_MATERIAL"+
                                         " AND fmdsub.COD_FORMULA_MAESTRA = '"+(loteMix?Math.round(prod2[2]):0)+"'"+
                                         " WHERE sppem.COD_SUB_PROCESO_PRODUCTO = '"+codSubProcesoProd+"' AND sppem.COD_PROCESO_PRODUCTO = '"+codProcesoProd+"'"+
                                         " AND sppem.COD_FORMULA_MAESTRA = '"+(Math.round(prod1[2]))+"' group by m.NOMBRE_MATERIAL,fmd.CANTIDAD ,um.ABREVIATURA,fmdsub.CANTIDAD";
                                System.out.println("consulta materiales sub"+consulta);
                                 resdd=stdd.executeQuery(consulta);
                                materialesSubProceso="";
                                 while(resdd.next())
                                 {
                                     contSubproces++;
                                     porciento=(loteMix?(resdd.getDouble("cantidadFracciones")/resdd.getDouble("cantidadFm")):0);
                                     materialesSubProceso+=((materialesSubProceso.equals("")?"":",")+"'"+resdd.getString("NOMBRE_MATERIAL")+"','"+
                                             nf.format(loteMix?((resdd.getDouble("cantidadFracciones")*prod1[1])+(resdd.getDouble("cantidadCompprod2")*prod2[1]*porciento)):(resdd.getDouble("cantidadFracciones")*prod1[1]))+
                                        //nf.format((resdd.getDouble("CANTIDAD")*resdd.getDouble("PORCIENTO_MATERIAL")*prod1[1])+(prod2[2]==null?0:((resdd.getDouble("cantidadCompprod2")*resdd.getDouble("PORCIENTO_MATERIAL")*prod2[1]))))+
                                        " ("+resdd.getString("ABREVIATURA")+")'");
                                 }

                                script+="var p"+codProcesoProd+"s"+codSubProceso+"= uml.State.create({rect: {x:250, y: "+(subprocesoDer?posYder:posYizq)+", width: 400, height:"+(contSubproces+3+(descripcionSubProces.equals("")?0:6))*18+"},"+
                                        "label: '"+nroPasoProceso+"."+nroPasoSubProceso+" -Actividad:"+resd.getString("NOMBRE_ACTIVIDAD_PREPARADO")+(tiempoSubProces>0?" -Tiempo :"+tiempoSubProces+" " +
                                        "min-Tolerancia:"+nf.format((resd.getDouble("PORCIENTO_TOLERANCIA_TIEMPO_SUB_PROCESO")/100)*tiempoSubProces)+" min ":"")+"-Operario Tiempo Completo:"+(operarioTiempoCompletoSubProceso>0?"SI":"NO")+
                                        "',attrs: {fill:'90-#000-"+(operarioTiempoCompletoSubProceso>0?"#90EE90":"#FFC0CB")+":1-#fff'}," +
                                        (materialesSubProceso.equals("")?"":"materiales:["+materialesSubProceso+"],")+
                                        (maquinariasSubProces.equals("")?"":("datosMaq:["+maquinariasSubProces+"],"))+
                                        //(descripcionSubProces.equals("")?"":"descripcion:'"+descripcionSubProces.replace(b, '&').replace(c,' ')+"',")+
                                        "actions:{actividad:null," +
                                        "Maquinaria:'ninguno'"+
                                        (espEquipSubProces.equals("")?"":",inner: ["+espEquipSubProces+"]") +
                                        "},descripcion:'"+descripcionSubProces.replace(b, '-').replace(c,' ')+"'" +
                                        ",detailsOffsetY:"+(tiempoSubProces>0?"5":"3")+",codProcesos:'"+codProceso+"',codSubProceso:'"+codSubProceso+"'," +
                                        "operario:'"+operarioSubProceso+"',operario2:'"+operarioSubProceso2+"',codPersonal:'"+codPersonalSubProceso+"',codPersonal2:'"+codPersonalSubProceso2+"'" +
                                        ",conforme:'"+conforme2+"',observaciones:'"+observacion2+"'});";

                                variables+=(variables.equals("")?"":",")+"p"+codProcesoProd+"s"+codSubProceso;
                                posYizq+=(subprocesoDer?0:((contSubproces+3+(descripcionSubProces.equals("")?0:6))*18)+21);
                                posYder+=(subprocesoDer?((contSubproces+3+(descripcionSubProces.equals("")?0:6))*18)+21:0);
                                primerRegistro=false;

                           }
                    }
                    String areglo="";
                    String arrow="";
                    int cont=0;
                    for(String[] var:listaPuntos)
                    {
                        areglo+=(areglo.equals("")?"":",")+var[0]+","+var[1];
                        arrow+=" var m"+cont+"="+var[0]+".joint("+var[1]+", uml.arrow).register(all);";
                        if(var[2].equals("1"))
                        {
                        arrow+="asignarPuntos(m"+cont+");";
                        }
                        if(var[2].equals("2"))
                        {
                        arrow+="crunch(m"+cont+");";
                        }
                        if(var[2].equals("5"))
                        {
                        arrow+="crunch2(m"+cont+");";
                        }
                        arrow+="verificarInterupcion(m"+cont+");";
                        cont++;
                    }
                    scriptUnion+="var all = ["+areglo+"];";

                   out.println("var nccc");
                    scriptUnion+=arrow;
                    
                   // System.out.println(script);
                    int height=posYcen;
                    height=height>posYder?height:posYder;
                    height=height>posYizq?height:posYizq;
                    System.out.println("cdcdcd "+height);
                    out.println(" var paper = Joint.paper('diagrama', 1000, "+ (height+(cont2*110))+");"+script+scriptUnion);
                    
                consulta="select p.COD_PERSONAL,(p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL+' '+p.nombre2_personal) as nombrePersonal"+
                         " from PERSONAL p where p.COD_ESTADO_PERSONA=1 and p.cod_area_empresa in (82) order by p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRE_PILA";
                System.out.println("consula personal "+consulta);
                String personalSelect="<option value='0'>No Registrado</option>";
                res=st.executeQuery(consulta);
                
                while(res.next())
                {
                    personalSelect+="<option value='"+res.getString("COD_PERSONAL")+"'>"+res.getString("nombrePersonal")+"</option>";
                }
                out.println("personalSelect=\""+personalSelect+"\";codLote='"+codLote+"';");
               /* consulta="select s.COD_PROCESO_PRODUCTO,s.COD_SUB_PROCESO_PRODUCTO,pp.COD_PERSONAL,(pp.AP_PATERNO_PERSONAL+' '+pp.AP_MATERNO_PERSONAL+' '+pp.NOMBRE_PILA)as nombre,s.CONFORME" +
                        " from SEGUIMIENTO_PROCESOS_PREPARADO_LOTE s left outer join PROCESOS_PRODUCTO p on"+
                         " p.COD_PROCESO_PRODUCTO=s.COD_PROCESO_PRODUCTO left outer join SUB_PROCESOS_PRODUCTO spp"+
                         " on spp.COD_PROCESO_PRODUCTO=s.COD_PROCESO_PRODUCTO and spp.COD_SUB_PROCESO_PRODUCTO=s.COD_SUB_PROCESO_PRODUCTO" +
                         " inner join PERSONAL pp on pp.COD_PERSONAL=s.COD_PERSONAL" +
                         " where s.COD_LOTE='"+codLote+"'"+
                         " order by p.NRO_PASO,ISNULL(spp.NRO_PASO,0)";
                System.out.println("consulta buscar "+consulta);
                res=st.executeQuery(consulta);
                String codP="";
                while(res.next())
                {
                    codP+=(codP.equals("")?"":",")+res.getString("COD_PROCESO_PRODUCTO")+","+res.getString("COD_SUB_PROCESO_PRODUCTO")+
                            ","+res.getString("COD_PERSONAL")+",'"+res.getString("nombre")+"',"+res.getString("CONFORME");
                }
                /*for(String var1:variables)
                {
                    out.println(var1+".asignarOperario(new Array("+codP+"));");
                  
                }*/
                //System.out.println("cod "+personalSelect);
               
            %>

       </script>


                               </td>
                           </tr>
                       </table>

                       <table style="width:100%;margin-top:8px" id="dataTiempoMezclado" cellpadding="0px" cellspacing="0px">
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
                                        " and sppp.COD_COMPPROD='"+codCompProd+"' and sppp.COD_ACTIVIDAD_PROGRAMA='"+codActividadMezclado+"'"+
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
                                    <button <%=(administrador?"disabled":"")%> class="small button succes radius buttonMas" onclick="nuevoRegistroGeneral('dataTiempoMezclado')">+</button>
                              </div>
                              <div class="large-1 medium-1 small-2 columns">
                                    <button <%=(administrador?"disabled":"")%> class="small button succes radius buttonMenos" onclick="eliminarRegistroTabla('dataTiempoMezclado');">-</button>
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
                                        <button class="small button succes radius buttonAction" onclick="guardarTamizado();" >Guardar</button>
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
        <input type="hidden" id="codSeguimientoRepesada" value="<%=codSeguimientoTamizado%>">
        <input type="hidden" id="codFormulaMaestra" value="<%=codFormulaMaestra%>"/>
        <input type="hidden" id="codTipoProgramaProd" value="<%=(codTipoProgramaProd)%>"/>
        <input type="hidden" id="codCompProd" value="<%=(codCompProd)%>"/>
        <input type="hidden" id="codActividadTamizado" value="<%=(codActividadTamizado)%>"/>
        <input type="hidden" id="codActividadMezclado" value="<%=(codActividadMezclado)%>"/>
        <script src="../../reponse/js/timePickerJs.js"></script>
        <script src="../../reponse/js/dataPickerJs.js"></script>
        <script>iniciarDatePicker('<%=(sdf.format(new Date()))%>');loginHoja.verificarHojaCerrada('cerrado', admin,'codProgramaProd','codLoteSeguimiento',3,<%=(codEstadoHoja)%>);</script>
    
     </section>
    </body>
</html>
