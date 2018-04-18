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
<%@page import="java.util.List" %>
<%@page import="java.util.ArrayList" %>
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
<link rel="STYLESHEET" type="text/css" href="../../reponse/css/border-radius.css" />

<link rel="STYLESHEET" type="text/css" href="../../reponse/css/jscal2.css" />
<link rel="STYLESHEET" type="text/css" href="../../reponse/css/gold.css" />
<link rel="STYLESHEET" type="text/css" href="../../reponse/css/timePickerCSs.css" />
<script src="../../reponse/js/jscal2.js"></script>
<script src="../../reponse/js/en.js"></script>
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
    var personal="";
    var fechaActual="";
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
        
    
    function guardarEsterilizacionCalorHumedo()
    {
         document.getElementById('formsuper').style.visibility='visible';
         document.getElementById('divImagen').style.visibility='visible';
         var codLote=document.getElementById('codLoteSeguimiento').value;
         var tablaLotesAdjuntos=document.getElementById("dataLotes");
         var dataLotesAdjuntos=new Array();
         var tablaEspecificaciones=document.getElementById("dataEspecificaciones");
         var dataEspecificaciones=new Array();
         var tablaAmpollas=document.getElementById("dataAmpollas");
         var dataAmpollas=new Array();
         var fechaInicioActividad=null;
         var fechaFinalActividad=null;
         var horasHombreActividad=0;
         var cont=0;
         if(!admin)
         {
                 for(var i=1;i<tablaLotesAdjuntos.rows.length;i++)
                 {
                     if(validarRegistroEntero(tablaLotesAdjuntos.rows[i].cells[1].getElementsByTagName('input')[0]))
                     {
                         dataLotesAdjuntos[cont]=tablaLotesAdjuntos.rows[i].cells[0].getElementsByTagName('input')[0].value;
                         cont++;
                         dataLotesAdjuntos[cont]=tablaLotesAdjuntos.rows[i].cells[1].getElementsByTagName('input')[0].value;
                         cont++;
                     }
                     else
                     {
                         document.getElementById('formsuper').style.visibility='hidden';
                         document.getElementById('divImagen').style.visibility='hidden';
                         return false;
                     }

                 }
                 cont=0;
                 for(var j=1;j<tablaEspecificaciones.rows.length;j++)
                 {
                     dataEspecificaciones[cont]=tablaEspecificaciones.rows[j].cells[0].getElementsByTagName('input')[0].value;
                     cont++;
                     if(tablaEspecificaciones.rows[j].cells.length==5)
                     {
                        dataEspecificaciones[cont]=(tablaEspecificaciones.rows[j].cells[3].getElementsByTagName('input')[0].checked?"1":"0");
                        cont++;
                        dataEspecificaciones[cont]=encodeURIComponent(tablaEspecificaciones.rows[j].cells[4].getElementsByTagName('input')[0].value.split(",").join("$%"));
                        cont++;
                     }
                     else
                     {
                        dataEspecificaciones[cont]=(tablaEspecificaciones.rows[j].cells[2].getElementsByTagName('input')[0].checked?"1":"0");
                        cont++;
                        dataEspecificaciones[cont]=encodeURIComponent(tablaEspecificaciones.rows[j].cells[3].getElementsByTagName('input')[0].value.split(",").join("$%"));
                        cont++;
                     }
                 }
                 cont=0;
                 for(var i=1;i<tablaAmpollas.rows.length;i++)
                 {
                    if(validarRegistroEntero(tablaAmpollas.rows[i].cells[0].getElementsByTagName('input')[0])&&
                      validarRegistroEntero(tablaAmpollas.rows[i].cells[1].getElementsByTagName('input')[0])&&
                      //validarRegistroEntero(tablaAmpollas.rows[i].cells[2].getElementsByTagName('input')[0])&&
                      validarSeleccionRegistro(tablaAmpollas.rows[i].cells[3].getElementsByTagName('select')[0])&&
                      validarFechaRegistro(tablaAmpollas.rows[i].cells[4].getElementsByTagName('input')[0])&&
                      validarHoraRegistro(tablaAmpollas.rows[i].cells[5].getElementsByTagName('input')[0])&&
                      validarHoraRegistro(tablaAmpollas.rows[i].cells[6].getElementsByTagName('input')[0])&&
                      validarRegistrosHorasNoNegativas(tablaAmpollas.rows[i].cells[5].getElementsByTagName('input')[0],tablaAmpollas.rows[i].cells[6].getElementsByTagName('input')[0]))
                       {
                         dataAmpollas[cont]=tablaAmpollas.rows[i].cells[0].getElementsByTagName('input')[0].value;
                         cont++;
                         dataAmpollas[cont]=tablaAmpollas.rows[i].cells[1].getElementsByTagName('input')[0].value;
                         cont++;
                         dataAmpollas[cont]=(tablaAmpollas.rows[i].cells[2].getElementsByTagName('input')[0].checked?1:0);
                         cont++;
                         dataAmpollas[cont]=tablaAmpollas.rows[i].cells[3].getElementsByTagName('select')[0].value;
                         cont++;
                         dataAmpollas[cont]=tablaAmpollas.rows[i].cells[4].getElementsByTagName('input')[0].value;
                         cont++;
                         dataAmpollas[cont]=tablaAmpollas.rows[i].cells[5].getElementsByTagName('input')[0].value;
                         cont++;
                         dataAmpollas[cont]=tablaAmpollas.rows[i].cells[6].getElementsByTagName('input')[0].value;
                         cont++;
                            var aux=dataAmpollas[cont-3].split("/");
                            var auxini=dataAmpollas[cont-2].split(":");
                            var auxend=dataAmpollas[cont-1].split(":");
                            var currentDateIni=new Date(parseInt(aux[2]),(parseInt(aux[1])-1), parseInt(aux[0]),parseInt(auxini[0]),parseInt(auxini[1]), 0, 0);
                            var currentDateFin=new Date(parseInt(aux[2]),(parseInt(aux[1])-1), parseInt(aux[0]),parseInt(auxend[0]),parseInt(auxend[1]), 0, 0);
                            if(fechaInicioActividad==null||currentDateIni<fechaInicioActividad)
                            {
                                fechaInicioActividad=currentDateIni;
                            }
                            if(fechaFinalActividad==null||currentDateFin>fechaFinalActividad)
                            {
                                fechaFinalActividad=currentDateFin;
                            }
                        dataAmpollas[cont]=redondeo2decimales(getNumeroDehoras((dataAmpollas[cont-3]+' '+dataAmpollas[cont-2]),(dataAmpollas[cont-3]+' '+dataAmpollas[cont-1])));
                        horasHombreActividad+=parseFloat(dataAmpollas[cont]);
                        cont++;
                     }
                     else
                    {
                        document.getElementById('formsuper').style.visibility='hidden';
                        document.getElementById('divImagen').style.visibility='hidden';
                        return false;
                    }
                 }
         }
         var peticion="ajaxGuardarEsterilizacionCalorHumedo.jsf?codLote="+codLote+"&noCache="+ Math.random()+
             "&codFormulaMaestra="+document.getElementById("codFormulaMaestra").value+"&codTipoProgramaProd="+document.getElementById("codTipoProgramaProd").value+
             "&codCompProd="+document.getElementById("codCompProd").value+"&codActividadCargado="+document.getElementById("codActividadCargado").value+
             "&dataLotesAdjuntos="+dataLotesAdjuntos+"&dataEspecificaciones="+dataEspecificaciones+"&dataAmpollas="+dataAmpollas+
             "&codProgramaProd="+document.getElementById("codProgramaProd").value+"&codSeguimiento="+document.getElementById("codSeguimiento").value+
             "&admin="+(admin?1:0)+"&codPersonalUsuario="+codPersonal+
             (admin?"&observacion="+encodeURIComponent(document.getElementById('observacion').value):"")+
             "&fechaInicioActividad="+transformDate((fechaInicioActividad!=null?fechaInicioActividad:new Date()))+
             "&fechaFinalActividad="+transformDate((fechaFinalActividad!=null?fechaFinalActividad:new Date()))+"&horasHombreActividad="+horasHombreActividad;
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
                                sqlConnection.insertarRegistroAuxiliar(document.getElementById("codProgramaProd").value, codLote,11,("../registroEsterilizacionCalorHumedo/"+peticion),function(){window.close();});
                            }
                            document.getElementById('formsuper').style.visibility='hidden';
                            document.getElementById('divImagen').style.visibility='hidden';
                            return false;
                        }
                        if(parseInt(ajax.responseText.split("\n").join(""))=='1')
                        {
                            alert('Se registro el proceso de esterilizacion');
                            document.getElementById('formsuper').style.visibility='hidden';
                            document.getElementById('divImagen').style.visibility='hidden';
                            window.close();
                            
                            return true;
                        }
                        else
                        {
                            alert(ajax.responseText.split("\n").join(""));
                            document.getElementById('formsuper').style.visibility='hidden';
                            document.getElementById('divImagen').style.visibility='hidden';
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
    
    function calcularTotalAmpollas(celda)
    {
        var resultado=(parseInt(celda.parentNode.parentNode.cells[1].getElementsByTagName('input')[0].value)*parseInt(celda.parentNode.parentNode.cells[2].getElementsByTagName('input')[0].value));
        celda.parentNode.parentNode.cells[3].getElementsByTagName('span')[0].innerHTML=(isNaN(resultado)?0:resultado);
        var ampollas=document.getElementById('dataAmpollas');
        
        var sumaAmpollas=0;
        for(var i=1;i<(ampollas.rows.length-1);i++)
             {
                sumaAmpollas+=parseInt(ampollas.rows[i].cells[3].getElementsByTagName('span')[0].innerHTML);
            }
            ampollas.rows[ampollas.rows.length-1].cells[1].getElementsByTagName('span')[0].innerHTML=sumaAmpollas;
            document.getElementById('sumaCantidad').innerHTML=sumaAmpollas;
            document.getElementById('rendimiento').innerHTML=redondeo2decimales((sumaAmpollas/parseInt(document.getElementById('cantidadLote').innerHTML))*100);
    }
    
    function nuevoRegistro(nombreTabla)
   {

       var table = document.getElementById(nombreTabla);
       var rowCount = table.rows.length;
       var row = table.insertRow(rowCount);
       var cell1 = row.insertCell(0);
       cell1.className="tableCell";
       var element1 = document.createElement("input");
       element1.type = "text";
       cell1.appendChild(element1);
       var cell2 = row.insertCell(0);
       cell2.className="tableCell";
       var element2 = document.createElement("input");
       element2.type = "text";
       cell2.appendChild(element2);
       
  }
  var contadorRegistrosEst=0;
  function nuevoRegistro2(nombreTabla)
   {
       contadorRegistrosEst++;
       var table = document.getElementById(nombreTabla);
       var rowCount = table.rows.length;
       var row = table.insertRow(rowCount);
       row.onclick=function(){seleccionarFila(this);};
       var cell1 = row.insertCell(0);
       cell1.className="tableCell";
       var element1 = document.createElement("input");
       element1.type = "text";
       cell1.appendChild(element1);
       var cell2 = row.insertCell(1);
       cell2.className="tableCell";
       var element2 = document.createElement("input");
       element2.type = "text";
       cell2.appendChild(element2);
       var cell3 = row.insertCell(2);
       cell3.className="tableCell";
       cell3.align="center";
       
       var element3 = document.createElement("input");
       element3.type = "checkbox";
       cell3.appendChild(element3);

       var cell4 = row.insertCell(3);
       cell4.className="tableCell";
       var element4 = document.createElement("select");
       element4.innerHTML=personal;
       cell4.appendChild(element4);

       var cell5 = row.insertCell(4);
       cell5.className="tableCell";
       var element5 = document.createElement("input");
       element5.type = "tel";
       element5.size=10;
       element5.style.width='8em';
       element5.value=fechaActual;
       element5.id="fechaSegui"+table.rows.length;
       element5.onclick=function(){seleccionarDatePickerJs(this);};
       cell5.appendChild(element5);
       var cell6 = row.insertCell(5);
       cell6.className="tableCell";
       var element6 = document.createElement("input");
       element6.onclick=function(){seleccionarHora(this);};
       element6.id="horaIniReg"+contadorRegistrosEst;
       element6.type = "text";
       element6.style.width='6em';
       element6.value=getHoraActualString();
       cell6.appendChild(element6);

       var cell7 = row.insertCell(6);
       cell7.className="tableCell";
       var element7 = document.createElement("input");
       element7.id="horaFinalREg"+contadorRegistrosEst;
       element7.onclick=function(){seleccionarHora(this);}
       element7.type = "text";
       element7.style.width='6em';
       element7.value=getHoraActualString();
       cell7.appendChild(element7);

  }
</script>


</head>
    <body >
        <div style="margin-top:2%;position:fixed;;width:100%;z-index:5;visibility:hidden" id="divImagen">
         <center><img src="../../reponse/img/load2.gif"  style="z-index:6; "><%--margin-top:2%;position:fixed;--%>
         </center>
         </div>
      
  <%
        int codPersonalApruebaDespeje=0;
        String loteAsociado="";
        int cantLoteAsociado=0;
        String codPersonal=request.getParameter("codPersonal");
        boolean administrador=(Integer.valueOf(request.getParameter("admin"))>0);
        out.println("<script type='text/javascript'>codPersonal="+codPersonal+";" +
                   "admin="+administrador+";</script>");
        int codEstadoHoja=0;
        Date fechaCierre=new Date();
        int codSeguimientoEsterilizacion=0;
        String codCompProd=request.getParameter("codComprod");
        String codLote=request.getParameter("codLote");
        out.println("<title>("+codLote+")ESTERILIZACION CALOR HUMEDO</title>");
        String codForma="";
        Date fechaRegistro=new Date();
        String observacion="";
        String codPersonalSupervisor="0";
        NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
        DecimalFormat format = (DecimalFormat)nf;
        SimpleDateFormat sdfDias=new SimpleDateFormat("dd/MM/yyyy");
        out.println("<script>var fechaActual='"+sdfDias.format(new  Date())+"'</script>");
        SimpleDateFormat sdfHoras=new SimpleDateFormat("HH:mm");
        format.applyPattern("#,##0.00");
        String codprogramaProd=request.getParameter("cod_prog");
        int codFormulaMaestra=0;
        int codTipoProgramaProd=0;
        int codActividadCargado=0;
        out.println("<script>sqlConnection.verificarRegistroPendiente('"+codprogramaProd+"','"+codLote+"',11)</script>");
                try
                {
                    Connection con=null;
                    con=Util.openConnection(con);
                    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    String consulta="select pp.COD_FORMULA_MAESTRA,pp.COD_TIPO_PROGRAMA_PROD,pp.COD_COMPPROD,cp.COD_FORMA,f.abreviatura_forma,cp.nombre_prod_semiterminado,cp.NOMBRE_GENERICO,f.nombre_forma,cp.REG_SANITARIO,"+
                                    " ep.nombre_envaseprim,cp.VIDA_UTIL,pp.CANT_LOTE_PRODUCCION,ppp.FECHA_FINAL," +
                                    " isnull(cpr.COD_RECETA_ESTERILIZACION_CALOR, 0) as COD_RECETA_ESTERILIZACION_CALOR,"+
                                    " ISNULL(dpff.PRECAUCIONES_ESTERILIZACION_CALOR_HUMEDO, '') as PRECAUCIONES_ESTERILIZACION_CALOR_HUMEDO,"+
                                    " ISNULL(dpff.INDICACIONES_ETAPA_ESTERILIZACION_CALOR_HUMEDO,'') as INDICACIONES_ETAPA_ESTERILIZACION_CALOR_HUMEDO,"+
                                    " isnull(dpff.POST_INDICACIONES_ETAPA_ESTERILIZACION_CALOR_HUMEDO,'') as POST_INDICACIONES_ETAPA_ESTERILIZACION_CALOR_HUMEDO" +
                                    " ,isnull(sechl.COD_SEGUIMIENTO_ESTERILIZACION_CALOR_HUMEDO_LOTE,0) as COD_SEGUIMIENTO_ESTERILIZACION_CALOR_HUMEDO_LOTE" +
                                    " ,ISNULL(sechl.COD_PERSONAL_SUPERVISOR,0) as COD_PERSONAL_SUPERVISOR,isnull(sechl.OBSERVACIONES,'') as OBSERVACIONES" +
                                    " ,sechl.FECHA_CIERRE,ISNULL(sechl.COD_ESTADO_HOJA,0) AS COD_ESTADO_HOJA,isnull(afm2.COD_ACTIVIDAD_FORMULA,0) as COD_ACTIVIDAD_FORMULA" +
                                    " ,isnull(sechl.COD_PERSONAL_APRUEBA_DESPEJE,0) as COD_PERSONAL_APRUEBA_DESPEJE"+
                                    " ,isnull(conjunta.loteAsociado,'') as loteAsociado,isnull(conjunta.cantAsociado,0) as cantAsociado" +
                                    " from PROGRAMA_PRODUCCION pp inner join COMPONENTES_PROD cp on cp.COD_COMPPROD=pp.COD_COMPPROD"+
                                    " inner join FORMAS_FARMACEUTICAS f on f.cod_forma=cp.COD_FORMA"+
                                    " inner join productos p on p.cod_prod=cp.COD_PROD"+
                                    " inner join PRESENTACIONES_PRIMARIAS ppm on ppm.COD_COMPPROD=cp.COD_COMPPROD and ppm.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD"+
                                    " inner join ENVASES_PRIMARIOS ep on ep.cod_envaseprim=ppm.COD_ENVASEPRIM" +
                                    " inner join PROGRAMA_PRODUCCION_PERIODO ppp on pp.COD_PROGRAMA_PROD=ppp.COD_PROGRAMA_PROD" +
                                    " left outer join COMPONENTES_PROD_RECETA cpr on cpr.COD_COMPROD=cp.COD_COMPPROD"+
                                    " left outer join DESCRIPCION_PROCESOS_FORMA_FARMACEUTICA dpff on dpff.COD_FORMA=cp.COD_FORMA"+
                                    " left outer join SEGUIMIENTO_ESTERILIZACION_CALOR_HUMEDO_LOTE sechl on sechl.COD_LOTE=pp.COD_LOTE_PRODUCCION and sechl.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD" +
                                    " left outer join ACTIVIDADES_FORMULA_MAESTRA afm2 on afm2.COD_AREA_EMPRESA = 96 and afm2.COD_ACTIVIDAD = 160 and afm2.COD_FORMULA_MAESTRA = pp.COD_FORMULA_MAESTRA" +
                                    " and afm2.COD_PRESENTACION=0"+
                                    " outer APPLY(select top 1 ppc.COD_LOTE_PRODUCCION as loteAsociado,ppc.CANT_LOTE_PRODUCCION as cantAsociado"+
                                    " from LOTES_PRODUCCION_CONJUNTA lpc inner join PROGRAMA_PRODUCCION ppc on"+
                                    " lpc.COD_PROGRAMA_PROD=ppc.COD_PROGRAMA_PROD and lpc.COD_LOTE_PRODUCCION_ASOCIADO=ppc.COD_LOTE_PRODUCCION"+
                                    " where lpc.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD and lpc.COD_LOTE_PRODUCCION=pp.COD_LOTE_PRODUCCION) conjunta"+
                                    " where pp.COD_LOTE_PRODUCCION='"+codLote+"' and pp.COD_PROGRAMA_PROD='"+codprogramaProd+"'";
                    System.out.println("consulta cargar datos del lote "+consulta);
                    ResultSet res=st.executeQuery(consulta);
                    String codReceta="";
                    double cantidadAmpollas=0d;
                    String precauciones="";
                    String preIndicacionesEsterilizacion="";
                    String indicacionesEsterilizacion="";
                     char b=13;char c=10;
                     
                     
                    if(res.next())
                    {
                        codPersonalApruebaDespeje=res.getInt("COD_PERSONAL_APRUEBA_DESPEJE");
                        fechaCierre=(res.getTimestamp("FECHA_CIERRE")!=null?res.getTimestamp("FECHA_CIERRE"):new Date());
                        codEstadoHoja=res.getInt("COD_ESTADO_HOJA");
                        codPersonalSupervisor=res.getString("COD_PERSONAL_SUPERVISOR");
                        codActividadCargado=res.getInt("COD_ACTIVIDAD_FORMULA");
                        codCompProd=res.getString("COD_COMPPROD");
                        codTipoProgramaProd=res.getInt("COD_TIPO_PROGRAMA_PROD");
                        codFormulaMaestra=res.getInt("COD_FORMULA_MAESTRA");
                        observacion=res.getString("OBSERVACIONES");
                        codSeguimientoEsterilizacion=res.getInt("COD_SEGUIMIENTO_ESTERILIZACION_CALOR_HUMEDO_LOTE");
                        preIndicacionesEsterilizacion=res.getString("INDICACIONES_ETAPA_ESTERILIZACION_CALOR_HUMEDO");
                        indicacionesEsterilizacion=res.getString("POST_INDICACIONES_ETAPA_ESTERILIZACION_CALOR_HUMEDO");
                        precauciones=res.getString("PRECAUCIONES_ESTERILIZACION_CALOR_HUMEDO").replace(b,'\n').replace("\n", "</br>").replace("</br></br>","<br>");
                        codForma=res.getString("COD_FORMA");
                        codReceta=res.getString("COD_RECETA_ESTERILIZACION_CALOR");
                        cantidadAmpollas=res.getDouble("CANT_LOTE_PRODUCCION");
                        if(codActividadCargado==0)
                        {
                            out.println("<script>alert('No se encuentra asociada la actividad de  CARGA Y DESCARGA DE AMPOLLAS DEL AUTOCLAVE MAZDEN');window.close();</script>");
                        }
                        loteAsociado=res.getString("loteAsociado");
                        cantLoteAsociado=res.getInt("cantAsociado");
                        %>

<section class="main">
                         <div class="row"  style="margin-top:5px" >
                                <div class="large-12 medium-12 small-12 large-centered medium-centered small-centered columns" >

                                            <div class="row">
                                               <div class="large-12 medium-12 small-12 columns divHeaderClass" >
                                                       <label  class="inline">ESTERILIZACION CALOR HUMEDO</label>
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
                                                               <span class="textHeaderClassBody"><%=codLote+(loteAsociado.equals("")?"":"<br>"+loteAsociado)%></span>
                                                           </td>
                                                           <td class="tableCell" style="text-align:center;">
                                                               <span class="textHeaderClassBody"><%=cantidadAmpollas+(loteAsociado.equals("")?"":"<br>"+cantLoteAsociado)%></span>
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
                                                               <label  class="inline">DESPEJE DE LINEA DE ESTERILIZACION CALOR HUMEDO</label>
                                                        </div>
                                                    </div>
                                                     <div class="row" >
                                                        <div  class="divContentClass large-12 medium-12 small-12 columns" style="padding-top:1em;">
                                                            <span >Realizar segun POE PRO-LES-IN-017 "DESPEJE DE LINEA DE TRABAJO"<br><br>Realizar el despeje de linea y solicitar al Jefe de area la aprobacion de la seccion de trabajo.</span>
                                                            <%
                                                             consulta="select p.COD_PERSONAL,(p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL+' '+p.nombre2_personal) as nombrePersonalAprueba"+
                                                                      " from personal p where p.COD_PERSONAL='"+codPersonalApruebaDespeje+"'";
                                                             res=st.executeQuery(consulta);
                                                             String nombreDespeje="Sin Aprobacion";
                                                             if(res.next())
                                                             {
                                                                nombreDespeje=res.getString("nombrePersonalAprueba");
                                                                codPersonalApruebaDespeje=res.getInt("COD_PERSONAL");
                                                             }
                                                             out.println("<br><br><span style='font-weight:bold'>Aprobado por:</span><span>&nbsp;&nbsp;&nbsp;"+nombreDespeje+"</span><br><br>");


                                                            %>

                                                        </div>
                                                     </div>


                                        </div>
                            </div>



<div class="row"  style="margin-top:5px" >
            <div class="large-12 medium-12 small-12 large-centered medium-centered small-centered columns" >

                        <div class="row">
                           <div class="large-12 medium-12 small-12 columns divHeaderClass" >
                                   <label  class="inline">ESTERILIZACION CALOR HUMEDO</label>
                            </div>
                        </div>
                        <div class="row" >

                        <div  class="divContentClass large-12 medium-12 small-12 columns">
                
                <%
                    }
                   
                        %>
                        <div class="row">
                           <div class="large-12 medium-12 small-12 columns " >
                                   <span class="textHeaderClassBody">Precauciones<br></span>
                                   <span class="textHeaderClassBody" style="font-weight:normal"><%=(precauciones)%></span>
                            </div>
                        </div>
                        <div class="row">
                           <div class="large-6 medium-8 small-12 large-centered medium-centered columns " >
                               <table style="width:100%;margin-top:2%" id="dataLotes" cellpadding="0px" cellspacing="0px">
                                    <tr>
                                        <td class="tableHeaderClass" style="text-align:center" >
                                           <span class="textHeaderClass">NUMERO DE LOTE A ESTERILIZAR</span>
                                       </td>
                                       <td class="tableHeaderClass" style="text-align:center;" >
                                           <span class="textHeaderClass">NUMERO DE BANDEJAS DE CADA LOTE</span>
                                       </td>
                                    </tr>
                                    <%
                                        consulta="select sechla.cod_lote,sechla.CANTIDAD_BANDEJAS_LOTE"+
                                                 " from SEGUIMIENTO_ESTERILIZACION_CALOR_HUMEDO_LOTES_ADJUNTOS sechla " +
                                                 " where sechla.COD_SEGUIMIENTO_ESTERILIZACION_CALOR_HUMEDO_LOTE='"+codSeguimientoEsterilizacion+"' order by sechla.COD_LOTE";
                                        System.out.println("consulta cantidad bandejas "+consulta);
                                        res=st.executeQuery(consulta);
                                        while(res.next())
                                        {%>
                                        <tr>
                                             <td class="tableCell"  style="text-align:center">
                                                    <input type="text" <%=(administrador?"disabled":"")%> value="<%=res.getString("cod_lote")%>"/>
                                               </td>
                                               <td class="tableCell"  style="text-align:center;">
                                                    <input type="text" <%=(administrador?"disabled":"")%> value="<%=res.getInt("CANTIDAD_BANDEJAS_LOTE")%>"/>
                                               </td>
                                        </tr>
                                        <%
                                        }
                                    %>
                                </table>
                             
                           </div>
                        </div>
                        <div clsass='row'><div class='large-1 medium-1 small-2 large-centered medium-centered small-centered columns'>
                        <button  <%=(administrador?"disabled":"")%>  class='small button succes radius buttonAction' onclick="nuevoRegistro('dataLotes')">+</button></div></div>
                                                
                      <div class="row">
                           <div class="large-12 medium-12 small-12 columns " >
                                   <span class="textHeaderClassBody" style="font-weight:normal"><%=(preIndicacionesEsterilizacion)%></span>
                            </div>
                        </div>
                         <table style="width:100%;margin-top:2%" id="dataEspecificaciones" cellpadding="0px" cellspacing="0px">
                         <tr >
                               <td rowspan="<%=(administrador?'2':'1')%>" class="tableHeaderClass"  style="text-align:center">
                                   <span class="textHeaderClass">MAZDEN</span>
                               </td>
                               <td rowspan="<%=(administrador?'2':'1')%>" class="tableHeaderClass"  style="text-align:center;" colspan="2">
                                   <span class="textHeaderClass">ESPECIFICACIONES DE LA <BR>ETAPA</span>
                               </td>
                               <%
                                   
                                       List<String[]> personalEspecificacion=new ArrayList<String[]>();
                                        if(administrador)
                                        {
                                            consulta="select distinct s.COD_PERSONAL,(p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.nombres_personal) as nombrePErsonal"+
                                                     " from SEGUIMIENTO_ESTERILIZACION_CALOR_HUMEDO_LOTE_ESPECIFICACIONES s inner join personal p "+
                                                     " on s.COD_PERSONAL=p.COD_PERSONAL"+
                                                     " where s.COD_SEGUIMIENTO_ESTERILIZACION_CALOR_HUMEDO_LOTE="+codSeguimientoEsterilizacion+
                                                     " order by nombrePErsonal";
                                            System.out.println("consulta personal esteilizacion "+consulta);
                                            res=st.executeQuery(consulta);
                                            while(res.next())
                                            {
                                                String[] aux={res.getString("COD_PERSONAL"),res.getString("nombrePErsonal")};
                                                personalEspecificacion.add(aux);
                                                out.println("<td  class='tableHeaderClass'  style='text-align:center;' colspan='2'><span class='textHeaderClass'>"+res.getString("nombrePErsonal")+"</span></td>");
                                            }
                                            out.println("</tr><tr>");
                                            for(int i=0;i<personalEspecificacion.size();i++)
                                            {
                                                out.println("<td  class='tableHeaderClass'  style='text-align:center;'><span class='textHeaderClass'>Conforme</span></td>");
                                                out.println("<td  class='tableHeaderClass'  style='text-align:center;'><span class='textHeaderClass'>Obs.</span></td>");
                                            }
                                        }
                                        else
                                        {
                                           out.println("<td rowspan='1' class='tableHeaderClass' style='text-align:center;'><span class='textHeaderClass'>CONFORME</span>"+
                                                      "</td><td rowspan='1' class='tableHeaderClass' style='text-align:center'><span class='textHeaderClass'>OBSERVACION</span></td>");

                                        }
                               %>
                               
                           </tr>
                        <%
                     
                    consulta=" select ep.RESULTADO_ESPERADO_LOTE,ep.NOMBRE_ESPECIFICACIONES_PROCESO,isnull(um.ABREVIATURA, 'N.A') as NOMBRE_UNIDAD_MEDIDA,"+
                             " ep.COD_ESPECIFICACION_PROCESO,case when ep.ESPECIFICACION_STANDAR_FORMA=1 then ep.VALOR_EXACTO else rd.VALOR_EXACTO end as valorExacto"+
                             " , case when ep.ESPECIFICACION_STANDAR_FORMA=1 THEN"+
                             " ep.VALOR_TEXTO else rd.VALOR_TEXTO end as valorTexto,ep.RESULTADO_NUMERICO";
                             if(administrador)
                             {
                                 for(String[] valor:personalEspecificacion)
                                 {
                                    consulta+=" ,isnull(sechle"+valor[0]+".CONFORME,0) as CONFORME"+valor[0]+",isnull(sechle"+valor[0]+".OBSERVACIONES,'') as OBSERVACIONES"+valor[0]+"";
                                 }
                             }
                             else
                             {
                                consulta+=" ,isnull(sechle.CONFORME,0) as CONFORME,isnull(sechle.OBSERVACIONES,'') as OBSERVACIONES";
                             }
                             consulta+=" from ESPECIFICACIONES_PROCESOS ep left outer join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA ="+
                             " ep.COD_UNIDAD_MEDIDA left outer join RECETAS_DESPIROGENIZADO rd on"+
                             " rd.COD_ESPECIFICACION_PROCESO = ep.COD_ESPECIFICACION_PROCESO and rd.COD_RECETA = '"+codReceta+"'";
                             if(administrador)
                             {
                                for(String[] valor:personalEspecificacion)
                                {
                                    consulta+=" left outer join SEGUIMIENTO_ESTERILIZACION_CALOR_HUMEDO_LOTE_ESPECIFICACIONES sechle"+valor[0]+" on "+
                                            " sechle"+valor[0]+".COD_ESPECIFICACION_PROCESO=ep.COD_ESPECIFICACION_PROCESO and sechle"+valor[0]+".COD_SEGUIMIENTO_ESTERILIZACION_CALOR_HUMEDO_LOTE='"+codSeguimientoEsterilizacion+"'" +
                                            " and sechle"+valor[0]+".COD_PERSONAL='"+valor[0]+"'";
                                }
                             }
                             else
                             {
                                consulta+=" left outer join SEGUIMIENTO_ESTERILIZACION_CALOR_HUMEDO_LOTE_ESPECIFICACIONES sechle on "+
                                " sechle.COD_ESPECIFICACION_PROCESO=ep.COD_ESPECIFICACION_PROCESO and sechle.COD_SEGUIMIENTO_ESTERILIZACION_CALOR_HUMEDO_LOTE='"+codSeguimientoEsterilizacion+"'" +
                                " and sechle.COD_PERSONAL='"+codPersonal+"'";
                             }
                             consulta+=" where ep.COD_FORMA = '"+codForma+"' and ep.COD_PROCESO_ORDEN_MANUFACTURA=4"+
                             " order by ep.ORDEN";
                    System.out.println("consulta esp 1 "+consulta);
                    res=st.executeQuery(consulta);
                    
                    String valor="";
                    String nombreEspecificacion="";
                    String unidadMedida="";
                    while(res.next())
                    {
                        
                        valor=(res.getInt("RESULTADO_NUMERICO")>0?(res.getInt("valorExacto")>0?String.valueOf(res.getInt("valorExacto")):""):res.getString("valorTexto"));
                        nombreEspecificacion=res.getString("NOMBRE_ESPECIFICACIONES_PROCESO");
                        unidadMedida=res.getString("NOMBRE_UNIDAD_MEDIDA");
                        %>
                        <tr >
                           <td class="tableCell" style="text-align:center">
                               <input type="hidden" value="<%=res.getString("COD_ESPECIFICACION_PROCESO")%>">
                               <span class="textHeaderClassBody" style="font-weight:normal"><%=nombreEspecificacion%></span>
                           </td>
                           <td class="tableCell" style="text-align:center;" colspan="<%=(unidadMedida.equals("N.A")?"2":"1")%>">
                               <span class="textHeaderClassBody" style="font-weight:normal"><%=valor%></span>
                           </td>
                           <%
                           if(!unidadMedida.equals("N.A"))
                               {
                           out.println("<td class='tableCell' style='text-align:center'><span class='textHeaderClassBody' style='font-weight:normal'>"+unidadMedida+"</span></td>");
                           }
                           if(administrador)
                           {
                                for(String[] valor1:personalEspecificacion)
                                {
                                    %>
                                        <td class='tableCell' style='text-align:center'><input disabled type='checkbox' style='width:20px;height:20px' <%=(res.getInt("conforme"+valor1[0])>0?"checked":"")%> >
                                        </td><td class='tableCell' style='text-align:center'><span class='textHeaderClassBody' style="font-weight:normal"><%=res.getString("observaciones"+valor1[0])%></span></td>
                                   <%
                                }
                           }
                           else
                           {
                                out.println("<td class='tableCell' style='text-align:center'>"+(res.getInt("RESULTADO_ESPERADO_LOTE")==1?"<input type='tel' value=''>":"<input type='checkbox' style='width:20px;height:20px' "+(res.getInt("conforme")>0?"checked":"")+" >")+
                                        "</td><td class='tableCell' style='text-align:center'><input class='textHeaderClassBody' type='text' value='"+res.getString("observaciones")+"'/></td>");
                           }
                                   %>

                           
                       </tr>
                        <%
                    }
                    %>
                    </table>
                  <div class="row">
                      <div class="large-12 medium-12 small-12 columns " >
                           <span class="textHeaderClassBody" style="font-weight:normal">Si el indicador cambio de color coloque √, sino avise al responsable de area.</span>
                    </div>
                  </div>
                    <div  class="row">

                           <div class="large-12 medium-12 small-12 large-centered medium-centered columns " >
                              <table style="width:100%;margin-top:2%" id="dataAmpollas" cellpadding="0px" cellspacing="0px">
                                        <tr >
                                               <td class="tableHeaderClass" style="text-align:center;"  >
                                                   <span class="textHeaderClass">Numero de ampollas x <br>recipiente</span>
                                               </td>
                                               <td class="tableHeaderClass" style="text-align:center;">
                                                   <span class="textHeaderClass">No de Recipientes</span>
                                               </td>
                                               <td class="tableHeaderClass" style="text-align:center;" >
                                                   <span class="textHeaderClass">Indicador</span>
                                               </td>
                                               <td class="tableHeaderClass" style="text-align:center;" >
                                                   <span class="textHeaderClass">Nombre del <br>Obrero</span>
                                               </td>
                                               <td class="tableHeaderClass" style="text-align:center;" >
                                                   <span class="textHeaderClass">Fecha</span>
                                               </td>
                                               <td class="tableHeaderClass" style="text-align:center;" >
                                                   <span class="textHeaderClass">Hora<br>Inicio</span>
                                               </td>
                                               <td class="tableHeaderClass" style="text-align:center;" >
                                                   <span class="textHeaderClass">Hora<br>Final</span>
                                               </td>
                                               
                                        </tr>
                                        <%
                                       consulta="select P.COD_PERSONAL,(P.AP_PATERNO_PERSONAL + ' ' + P.AP_MATERNO_PERSONAL + ' ' +P.NOMBRES_PERSONAL + ' ' + P.nombre2_personal) NOMBRES_PERSONAL"+
                                         " from personal P inner join PERSONAL_AREA_PRODUCCION pa on pa.COD_PERSONAL = p.COD_PERSONAL"+
                                         " where pa.cod_area_empresa in (81) AND p.COD_ESTADO_PERSONA = 1 " +
                                         (administrador?"":" and p.cod_personal='"+codPersonal+"'")+
                                         " union select P.COD_PERSONAL,"+
                                         " (P.AP_PATERNO_PERSONAL + ' ' + P.AP_MATERNO_PERSONAL + ' ' +P.NOMBRES_PERSONAL + ' ' + P.nombre2_personal) NOMBRES_PERSONAL"+
                                         " from personal p where p.cod_area_empresa in (81) and p.COD_ESTADO_PERSONA = 1"+
                                         (administrador?"":" and p.cod_personal='"+codPersonal+"'")+
                                         " GROUP BY P.COD_PERSONAL,P.AP_MATERNO_PERSONAL,P.AP_PATERNO_PERSONAL,P.NOMBRES_PERSONAL,P.nombre2_personal"+
                                         " order by NOMBRES_PERSONAL ";
                                         res=st.executeQuery(consulta);
                                        int sumaCantidad=0;
                                        String operarios="";
                                        while(res.next())
                                        {
                                            operarios+="<option value='"+res.getString("COD_PERSONAL")+"'>"+res.getString("NOMBRES_PERSONAL")+"</option>";
                                        }
                                        out.println("<script>personal=\""+operarios+"\";</script>");
                                        consulta="SELECT sechla.CANT_AMPOLLAS_RECIPIENTE,sechla.CANT_RECIPIENTES,sechla.INDICADOR,"+
                                                  " isnull(sechla.COD_PERSONAL_OBRERO,sppp.COD_PERSONAL) as COD_PERSONAL,sppp.FECHA_INICIO,"+
                                                  " sppp.FECHA_FINAL"+
                                                  " FROM SEGUIMIENTO_ESTERILIZACION_CALOR_HUMEDO_LOTE_AMPOLLAS sechla"+
                                                  " full outer join SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sppp on"+
                                                  " sechla.COD_PERSONAL_OBRERO = sppp.COD_PERSONAL and"+
                                                  " sechla.COD_REGISTRO_ORDEN_MANUFACTURA = sppp.COD_REGISTRO_ORDEN_MANUFACTURA"+
                                                  " where (sppp.COD_LOTE_PRODUCCION = '"+codLote+"' and sppp.COD_PROGRAMA_PROD = '"+codprogramaProd+"' and"+
                                                  " sppp.COD_FORMULA_MAESTRA = '"+codFormulaMaestra+"' and sppp.COD_ACTIVIDAD_PROGRAMA = '"+codActividadCargado+"' and"+
                                                  " sppp.COD_TIPO_PROGRAMA_PROD = '"+codTipoProgramaProd+"' "+
                                                  (administrador?"":" and sppp.COD_PERSONAL='"+codPersonal+"'")+
                                                  " and sechla.COD_SEGUIMIENTO_ESTERILIZACION_CALOR_HUMEDO_LOTE is null) or"+
                                                  " (sechla.COD_SEGUIMIENTO_ESTERILIZACION_CALOR_HUMEDO_LOTE = '"+codSeguimientoEsterilizacion+"'" +
                                                  (administrador?"":" and sechla.COD_PERSONAL_OBRERO='"+codPersonal+"'")+
                                                  " and sppp.COD_LOTE_PRODUCCION is NULL) or"+
                                                  " (sppp.COD_LOTE_PRODUCCION = '"+codLote+"' and sppp.COD_PROGRAMA_PROD = '"+codprogramaProd+"' and"+
                                                  " sppp.COD_FORMULA_MAESTRA = '"+codFormulaMaestra+"' and sppp.COD_ACTIVIDAD_PROGRAMA = '"+codActividadCargado+"' and"+
                                                  " sppp.COD_TIPO_PROGRAMA_PROD = '"+codTipoProgramaProd+"'" +
                                                  (administrador?"":" and sechla.COD_PERSONAL_OBRERO='"+codPersonal+"'")+
                                                  " and sechla.COD_SEGUIMIENTO_ESTERILIZACION_CALOR_HUMEDO_LOTE = "+codSeguimientoEsterilizacion+")"+
                                                  " order by sechla.COD_REGISTRO_ORDEN_MANUFACTURA";
                                            System.out.println("consulta cargar c. Ampollas "+consulta);
                                            res=st.executeQuery(consulta);
                                            
                                            while(res.next())
                                            {
                                                %>
                                                     <tr onclick="seleccionarFila(this);" >
                                                           <td class="tableCell" style="text-align:center;">
                                                               <input  type="text" <%=(administrador?"disabled":"")%>  value="<%=res.getInt("CANT_AMPOLLAS_RECIPIENTE")%>"/>
                                                           </td>
                                                           <td class="tableCell" style="text-align:center">
                                                               <input  type="text" <%=(administrador?"disabled":"")%>  value="<%=res.getInt("CANT_RECIPIENTES")%>"/>
                                                           </td>
                                                           <td class="tableCell" style="text-align:center;">
                                                               <input type="checkbox" <%=(administrador?"disabled":"")%> style="width:20px;height:20px"  <%=(res.getInt("INDICADOR")>0?"checked":"")%> />
                                                               
                                                           </td>
                                                           <td class="tableCell" style="text-align:center">
                                                               <select <%=(administrador?"disabled":"")%> id="s<%=res.getRow()%>">
                                                                   <%
                                                                   out.println(operarios);
                                                                           %>
                                                               </select>
                                                               <%
                                                               out.println("<script>s"+res.getRow()+".value='"+res.getInt("COD_PERSONAL")+"';</script>");
                                                               %>
                                                           </td>
                                                           <td class="tableCell"  style="text-align:center;">
                                                                <input onclick="seleccionarDatePickerJs(this);" <%=(administrador?"disabled":"")%> type="tel" value="<%=(res.getTimestamp("FECHA_INICIO")!=null?sdfDias.format(res.getTimestamp("FECHA_INICIO")):"")%>" size="10" id="fechap<%=(res.getRow())%>"/>
                                                                

                                                           </td>


                                                           <td class="tableCell"  style="text-align:center;" align="center">
                                                               <input <%=(administrador?"disabled":"")%> type="text" onclick='seleccionarHora(this);' id="fechaIniEst<%=(res.getRow())%>" value="<%=(res.getTimestamp("FECHA_INICIO")!=null?sdfHoras.format(res.getTimestamp("FECHA_INICIO")):"")%>" style="width:6em;"/>
                                                           </td>
                                                           <td class="tableCell"  style="text-align:center;" align="center">
                                                               <input <%=(administrador?"disabled":"")%> type="text" onclick='seleccionarHora(this);' id="fechaFinEst<%=(res.getRow())%>" value="<%=(res.getTimestamp("FECHA_INICIO")!=null?sdfHoras.format(res.getTimestamp("FECHA_FINAL")):"")%>" style="width:6em;"/>
                                                           </td>
                                                    </tr>
                                                <%
                                                
                                            }
                                            %>
                                            
                              </table>
                             </div>
                          </div>
                         <div clsass='row'><div class='large-5 medium-5 small-4 columns'>&nbsp;</div>
                          <div class='large-1 medium-1 small-2 columns'>
                          <button class='small button succes radius buttonAction' <%=(administrador?"disabled":"")%> onclick="nuevoRegistro2('dataAmpollas')">+</button>
                          </div><div class='large-1 medium-1 small-2 columns'>
                          <button class='small button succes radius buttonAction' <%=(administrador?"disabled":"")%> onclick="eliminarRegistroTabla('dataAmpollas');">-</button>
                          </div><div class='large-5 medium-5 small-4 columns' style=''>&nbsp;</div></div>
                         
                          
                           <div class="row">
                           <div class="large-12 medium-12 small-12 columns " >
                                   <span class="textHeaderClassBody" style="font-weight:normal"><%=(indicacionesEsterilizacion)%></span>
                            </div>
                        </div>
                   
                   
                   <%
                   if(administrador)
                   {
                                consulta="select (p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL+' '+p.nombre2_personal)"+
                                         " from PERSONAL p where p.COD_PERSONAL='"+codPersonal+"'";
                                res=st.executeQuery(consulta);
                                String nombreUsuario="";
                                if(res.next())
                                {
                                    nombreUsuario=res.getString(1);
                                }
                   %>
                   <center>
                   <table style="width:80%;margin-top:2px;border-bottom:solid #a80077 1px;" id="datosAdicionales" cellpadding="0px" cellspacing="0px" >
                            <tr >
                                   <td class="tableHeaderClass" style="text-align:center" colspan="3">
                                       <span class="textHeaderClass">APROBACION</span>
                                   </td>
                            </tr>
                            <tr >
                                        <td style="border-left:solid #a80077 1px;text-align:left">
                                           <span >JEFE DE AREA:</span>
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
                                        <input type="text" id="observacion" value="<%=(observacion)%>"/>
                                   </td>
                            </tr>
                    
                    </table>
                    </center>
                    
                    
                <%
                }
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
                                                    <button class="small button succes radius buttonAction" onclick="guardarEsterilizacionCalorHumedo();" >Guardar</button>
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
    <input type="hidden" id="codProgramaProd" value="<%=(codprogramaProd)%>">
    <input type="hidden" id="codFormulaMaestra" value="<%=(codFormulaMaestra)%>"/>
    <input type="hidden" id="codTipoProgramaProd" value="<%=(codTipoProgramaProd)%>"/>
    <input type="hidden" id="codCompProd" value="<%=(codCompProd)%>"/>
    <input type="hidden" id="codActividadCargado" value="<%=(codActividadCargado)%>"/>
    <input type="hidden" id="codSeguimiento" value="<%=(codSeguimientoEsterilizacion)%>">
    <input type="hidden" value="<%=(codPersonalSupervisor)%>" id="cerrado"/>
        </section>
    </body>
    <script src="../../reponse/js/timePickerJs.js"></script>
    <script src="../../reponse/js/dataPickerJs.js"></script>
    <script src="../../reponse/js/despejeLinea.js"></script>
    <script>
        despejeLinea.verificarDespejeLinea('<%=(codPersonalApruebaDespeje)%>', admin,'codProgramaProd','codLoteSeguimiento',10,<%=(codPersonal)%>);
        iniciarDatePicker('<%=(sdfDias.format(new Date()))%>');
        loginHoja.verificarHojaCerrada('cerrado', admin,'codProgramaProd','codLoteSeguimiento',10,<%=(codEstadoHoja)%>);
    </script>
</html>

