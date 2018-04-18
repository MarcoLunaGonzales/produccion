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
     
    function guardarRendimiento()
    {
        document.getElementById('formsuper').style.visibility='visible';
        document.getElementById('divImagen').style.visibility='visible';
        var codLote=document.getElementById('codLoteSeguimiento').value;
        var codProgramaProd=document.getElementById('codProgramaProd').value;
        var cont=0;
        var dataDocumentacion=new Array();
        var tablaDocumentacion=document.getElementById("dataTiemposDocumentacion");
        var sumaHorasDocumentacion=0;
        var fechaInicioDoc=null;
        var fechaFinalDoc=null;
        for(var i=2;i<tablaDocumentacion.rows.length;i++)
        {
            if(validarSeleccionRegistro(tablaDocumentacion.rows[i].cells[0].getElementsByTagName('select')[0])&&
                validarFechaRegistro(tablaDocumentacion.rows[i].cells[1].getElementsByTagName('input')[0])&&
                validarHoraRegistro(tablaDocumentacion.rows[i].cells[2].getElementsByTagName('input')[0])&&
                validarHoraRegistro(tablaDocumentacion.rows[i].cells[3].getElementsByTagName('input')[0])&&
            validarRegistrosHorasNoNegativas(tablaDocumentacion.rows[i].cells[2].getElementsByTagName('input')[0], tablaDocumentacion.rows[i].cells[3].getElementsByTagName('input')[0])
                )
            {
                dataDocumentacion[cont]=tablaDocumentacion.rows[i].cells[0].getElementsByTagName('select')[0].value;
                cont++;
                dataDocumentacion[cont]=tablaDocumentacion.rows[i].cells[1].getElementsByTagName('input')[0].value;
                cont++;
                dataDocumentacion[cont]=tablaDocumentacion.rows[i].cells[2].getElementsByTagName('input')[0].value;
                cont++;
                dataDocumentacion[cont]=tablaDocumentacion.rows[i].cells[3].getElementsByTagName('input')[0].value;
                cont++;

                 var aux=dataDocumentacion[cont-3].split("/");
                var auxini=dataDocumentacion[cont-2].split(":");
                var auxend=dataDocumentacion[cont-1].split(":");
                var currentDateIni=new Date(parseInt(aux[2]),(parseInt(aux[1])-1), parseInt(aux[0]),parseInt(auxini[0]),parseInt(auxini[1]), 0, 0);
                var currentDateFin=new Date(parseInt(aux[2]),(parseInt(aux[1])-1), parseInt(aux[0]),parseInt(auxend[0]),parseInt(auxend[1]), 0, 0);
                if(fechaInicioDoc==null||currentDateIni<fechaInicioDoc)
                {
                    fechaInicioDoc=currentDateIni;
                }
                if(fechaFinalDoc==null||currentDateFin>fechaFinalDoc)
                {
                    fechaFinalDoc=currentDateFin;
                }
                dataDocumentacion[cont]=parseFloat(tablaDocumentacion.rows[i].cells[4].getElementsByTagName('span')[0].innerHTML);
                cont++;
                sumaHorasDocumentacion+=parseFloat(tablaDocumentacion.rows[i].cells[4].getElementsByTagName('span')[0].innerHTML);
            }
            else
            {
                document.getElementById('formsuper').style.visibility='hidden';
                document.getElementById('divImagen').style.visibility='hidden';
                return false;
            }
        }
        var dataTransporte=new Array();
        var tablaTransporte=document.getElementById("dataTiempoTransporte");
        var horasHombreTransporte=0;
        var fechaInicioTransporte=null;
        var fechaFinalTransporte=null;
        cont=0;
        for(var j=2;j<tablaTransporte.rows.length;j++)
        {
            if(validarSeleccionRegistro(tablaTransporte.rows[j].cells[0].getElementsByTagName('select')[0])&&
               validarFechaRegistro(tablaTransporte.rows[j].cells[1].getElementsByTagName('input')[0])&&
               validarHoraRegistro(tablaTransporte.rows[j].cells[2].getElementsByTagName('input')[0])&&
               validarHoraRegistro(tablaTransporte.rows[j].cells[3].getElementsByTagName('input')[0])&&
               validarRegistrosHorasNoNegativas(tablaTransporte.rows[j].cells[2].getElementsByTagName('input')[0],tablaTransporte.rows[j].cells[3].getElementsByTagName('input')[0])
            )
            {
                dataTransporte[cont]=tablaTransporte.rows[j].cells[0].getElementsByTagName('select')[0].value;
                cont++;
                dataTransporte[cont]=tablaTransporte.rows[j].cells[1].getElementsByTagName('input')[0].value;
                cont++;
                dataTransporte[cont]=tablaTransporte.rows[j].cells[2].getElementsByTagName('input')[0].value;
                cont++;
                dataTransporte[cont]=tablaTransporte.rows[j].cells[3].getElementsByTagName('input')[0].value;
                cont++;
                 var aux=dataTransporte[cont-3].split("/");
                var auxini=dataTransporte[cont-2].split(":");
                var auxend=dataTransporte[cont-1].split(":");
                var currentDateIni=new Date(parseInt(aux[2]),(parseInt(aux[1])-1), parseInt(aux[0]),parseInt(auxini[0]),parseInt(auxini[1]), 0, 0);
                var currentDateFin=new Date(parseInt(aux[2]),(parseInt(aux[1])-1), parseInt(aux[0]),parseInt(auxend[0]),parseInt(auxend[1]), 0, 0);
                if(fechaInicioTransporte==null||currentDateIni<fechaInicioTransporte)
                {
                    fechaInicioTransporte=currentDateIni;
                }
                if(fechaFinalTransporte==null||currentDateFin>fechaFinalTransporte)
                {
                    fechaFinalTransporte=currentDateFin;
                }
                dataTransporte[cont]=parseFloat(tablaTransporte.rows[j].cells[4].getElementsByTagName('span')[0].innerHTML);
                cont++;
                horasHombreTransporte+=parseFloat(tablaTransporte.rows[j].cells[4].getElementsByTagName('span')[0].innerHTML);
            }
            else
            {
                document.getElementById('formsuper').style.visibility='hidden';
                document.getElementById('divImagen').style.visibility='hidden';
                return false;
            }
        }
         var peticion="ajaxGuardarRendimientoDosificado.jsf?codLote="+codLote+"&noCache="+ Math.random()+
             "&codFormulaMaestra="+document.getElementById("codFormulaMaestra").value+"&codTipoProgramaProd="+document.getElementById("codTipoProgramaProd").value+
             "&codCompProd="+document.getElementById("codCompProd").value+
             "&codActividadDocumentacion="+document.getElementById("codActividadDocumentacion").value+"&codActividadTransporte="+document.getElementById("codActividadTransporte").value+
             "&codProgProd="+codProgramaProd+"&dataDocumentacion="+dataDocumentacion+
             "&dataTransporte="+dataTransporte+"&sumaHorasDocumentacion="+sumaHorasDocumentacion+
             "&fechaInicioDoc="+transformDate((fechaInicioDoc!=null?fechaInicioDoc:new Date()))+"&fechaFinalDoc="+transformDate((fechaFinalDoc!=null?fechaFinalDoc:new Date()))+
             "&fechaInicioTransporte="+transformDate((fechaInicioTransporte!=null?fechaInicioTransporte:new Date()))+"&fechaFinalTransporte="+transformDate((fechaFinalTransporte!=null?fechaFinalTransporte:new Date()))+
             "&horasHombreTransporte="+horasHombreTransporte+
             "&codSeguimiento="+document.getElementById("codRendimientoLote").value+
             "&admin="+(admin?1:0)+"&codPersonalUsuario="+codPersonal+
             (admin?"&codPersonalSupervisor="+document.getElementById("codPersonalSupervisor").value+
             "&observacion="+encodeURIComponent(document.getElementById("observacion").value):"");
         
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
                                sqlConnection.insertarRegistroAuxiliar(codProgramaProd, codLote,10,("../registroRendimientoDosificado/"+peticion),function(){window.close();});
                            }
                            document.getElementById('formsuper').style.visibility='hidden';
                            document.getElementById('divImagen').style.visibility='hidden';
                            return false;
                        }
                        if(parseInt(ajax.responseText.split("\n").join(""))=='1')
                        {
                            alert('Se registro el rendimiento de dosificado');
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
    
    function calcularRendimiento()
    {
        document.getElementById("spanRendimiento").innerHTML=parseInt(document.getElementById("cantidad1").value)>0?((
        (parseInt(document.getElementById("cantidad6").value)+parseInt(document.getElementById("cantidad4").value))/parseInt(document.getElementById("cantidad1").value))*100):0;
    }
    function calcularCostoTerminadoInstitucional(select)
    {
        var tabla=document.getElementById("form1:dataSalidaVentas");
        for(var j=1;j<tabla.rows.length;j++)
        {
            var valor=parseFloat(tabla.rows[j].cells[2].getElementsByTagName('input')[0].value)*parseFloat(tabla.rows[j].cells[13].getElementsByTagName('input')[select.value].value);
            tabla.rows[j].cells[13].getElementsByTagName('span')[0].innerHTML=redondeo2decimales(
            ( valor));
              tabla.rows[j].cells[15].getElementsByTagName('span')[0].innerHTML=redondeo2decimales(
            (parseFloat((tabla.rows[j].cells[13].getElementsByTagName('span')[0].innerHTML.split('.').join('')).split(',').join('.'))-valor));

        }
    }

var operarios='';
var fechaSistema='';
var contadorRegistros=0;
function nuevoRegistro(nombreTabla,proceso)
{
       contadorRegistros++;
       var table = document.getElementById(nombreTabla);
       var rowCount = table.rows.length;
       var row = table.insertRow(rowCount);
       row.onclick=function(){seleccionarFila(this);};
       var cell1 = row.insertCell(0);
       cell1.className="tableCell";
       var element1 = document.createElement("select");
       element1.innerHTML=operarios;
       cell1.appendChild(element1);
        var cell2 = row.insertCell(1);
       cell2.className="tableCell";
       
       var element2 = document.createElement("input");
       element2.id=proceso+"fechaTiempo"+table.rows.length;
       element2.type = "tel";
       element2.value=fechaSistema;
       element2.onclick=function(){seleccionarDatePickerJs(this);};
       cell2.appendChild(element2);
       
       for(var i=0;i<2;i++)
       {
           var cell3 = row.insertCell(i+2);
           cell3.className="tableCell";
           var element3 = document.createElement("input");
           element3.id="fechaRegistro"+i+"t"+contadorRegistros;
           element3.onclick=function(){seleccionarHora(this);};
           element3.type = "tel";
           element3.value=getHoraActualString();
           cell3.align='center';
           element3.style.width='6em';
           element3.onfocus=function(){calcularDiferenciaHoras(this);};
           element3.onkeyup=function(){calcularDiferenciaHoras(this);};
           cell3.appendChild(element3);
       }
        var cell4 = row.insertCell(4);
        cell4.className="tableCell";
        var element4 = document.createElement("span");
        cell4.align='center';
        element4.innerHTML=0;
        element4.className='textHeaderClassBody';
        element4.style.fontWeight='normal';
        cell4.appendChild(element4);
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
        String loteAsociado="";
        int cantLoteAsociado=0;
        int codEstadoHoja=0;
        boolean administrador=(Integer.valueOf(request.getParameter("admin"))>0);
        out.println("<script type='text/javascript'>codPersonal="+codPersonal+";" +
                   "admin="+administrador+";</script>");
        Date fechaCierre=new Date();
        int codFormulaMaestra=0;
        int codCompProd=0;
        int codTipoProgramaProd=0;
        int codActividadDocumentacion=0;
        int codActividadTransporte=0;
        String codLote=request.getParameter("codLote");
        out.println("<title>("+codLote+")RENDIMIENTO DOSIFICADO</title>");
        String codprogramaProd=request.getParameter("cod_prog");
        String nombreComponente="as";
        String nombreAreaEmpresa="as";
        String codForma="";
        
        String observacionLote="";
        String codRendimientoLote="";
        int codSeguimientoControlDosificadoLote=0;
        NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
        DecimalFormat format = (DecimalFormat)nf;
        SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy");
        format.applyPattern("#,##0.00");
        int codSeguimientoDespirogenizado=0;
        int codSeguimientoControlLlenado=0;
        int codPersonalSupervisor=0;
        int codSeguimientoLavadoLote=0;
        int cantidadAmpollasLavadas=0;
        out.println("<script>sqlConnection.verificarRegistroPendiente('"+codprogramaProd+"','"+codLote+"',10)</script>");

                try
                {
                    Connection con=null;
                    con=Util.openConnection(con);
                    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    String consulta="select pp.COD_TIPO_PROGRAMA_PROD,pp.COD_COMPPROD,cp.COD_FORMA,p.nombre_prod,f.abreviatura_forma,cp.nombre_prod_semiterminado,cp.NOMBRE_GENERICO,f.nombre_forma,cp.REG_SANITARIO,"+
                                    " ep.nombre_envaseprim,cp.VIDA_UTIL,pp.CANT_LOTE_PRODUCCION,ppp.FECHA_FINAL," +
                                    " pp.COD_FORMULA_MAESTRA,ISNULL(cp.VOLUMEN_ENVASE_PRIMARIO,'') as VOLUMEN_ENVASE_PRIMARIO," +
                                    " isnull(srdl.COD_SEGUIMIENTO_RENDIMIENTO_LOTE,0) as COD_SEGUIMIENTO_RENDIMIENTO_LOTE,"+
                                    " isnull(srdl.OBSERVACION,'') as OBSERVACION" +
                                    " ,isnull(sdl.COD_SEGUIMIENTO_DESPIROGENIZADO_LOTE,0) as COD_SEGUIMIENTO_DESPIROGENIZADO_LOTE,"+
                                    " isnull(scll.COD_SEGUIMIENTO_CONTROL_LLENADO_LOTE,0) as COD_SEGUIMIENTO_CONTROL_LLENADO_LOTE" +
                                    " ,isnull(afm.COD_ACTIVIDAD_FORMULA,0) as codActividadDocumentacion"+
                                    " ,isnull(afm1.COD_ACTIVIDAD_FORMULA,0) as codActividadTransporte" +
                                    " ,isnull(srdl.COD_PERSONAL_SUPERVISOR,0) as COD_PERSONAL_SUPERVISOR" +
                                    " ,isnull(scdl.COD_SEGUIMIENTO_CONTROL_DOSIFICADO_LOTE,0) as codSeguimientoControlDosificado" +
                                    " ,isnull(sll.COD_SEGUIMIENTO_LAVADO_LOTE,0) as COD_SEGUIMIENTO_LAVADO_LOTE"+
                                    ",isnull(srdl.COD_ESTADO_HOJA,0) as COD_ESTADO_HOJA,srdl.FECHA_CIERRE"+
                                    " ,isnull(conjunta.loteAsociado,'') as loteAsociado,isnull(conjunta.cantAsociado,0) as cantAsociado" +
                                    " ,isnull(cpp.NOMBRE_COLORPRESPRIMARIA,'') as colorPresPrim" +
                                    " from PROGRAMA_PRODUCCION pp inner join COMPONENTES_PROD cp on cp.COD_COMPPROD=pp.COD_COMPPROD"+
                                    " inner join FORMAS_FARMACEUTICAS f on f.cod_forma=cp.COD_FORMA"+
                                    " inner join productos p on p.cod_prod=cp.COD_PROD"+
                                    " inner join PRESENTACIONES_PRIMARIAS ppm on ppm.COD_COMPPROD=cp.COD_COMPPROD" +
                                    " and ppm.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD"+
                                    " inner join ENVASES_PRIMARIOS ep on ep.cod_envaseprim=ppm.COD_ENVASEPRIM" +
                                    " inner join PROGRAMA_PRODUCCION_PERIODO ppp on pp.COD_PROGRAMA_PROD=ppp.COD_PROGRAMA_PROD" +
                                    " left outer join COLORES_PRESPRIMARIA cpp on cpp.COD_COLORPRESPRIMARIA=cp.COD_COLORPRESPRIMARIA" +
                                    "  left outer join SEGUIMIENTO_RENDIMIENTO_DOSIFICADO_LOTE srdl on "+
                                    " srdl.COD_LOTE=pp.COD_LOTE_PRODUCCION and srdl.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD" +
                                    " left outer join SEGUIMIENTO_DESPIROGENIZADO_LOTE sdl on sdl.COD_LOTE=pp.COD_LOTE_PRODUCCION"+
                                    " and sdl.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD"+
                                    " left outer join SEGUIMIENTO_CONTROL_LLENADO_LOTE scll on scll.COD_LOTE=pp.COD_LOTE_PRODUCCION"+
                                    " and scll.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD" +
                                    " left outer join SEGUIMIENTO_LAVADO_LOTE sll on sll.COD_LOTE=pp.COD_LOTE_PRODUCCION"+
                                    " and sll.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD"+
                                    " left outer join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_AREA_EMPRESA ="+
                                    " 96 and afm.COD_ACTIVIDAD = 265 and afm.COD_FORMULA_MAESTRA =pp.COD_FORMULA_MAESTRA and afm.cod_presentacion=0"+
                                    " left outer join ACTIVIDADES_FORMULA_MAESTRA afm1 on afm1.COD_AREA_EMPRESA ="+
                                    " 96 and afm1.COD_ACTIVIDAD = 264 and afm1.COD_FORMULA_MAESTRA =pp.COD_FORMULA_MAESTRA and afm1.cod_presentacion=0" +
                                    "left outer join SEGUIMIENTO_CONTROL_DOSIFICADO_LOTE scdl on scdl.COD_LOTE=pp.COD_LOTE_PRODUCCION"+
                                    " and scdl.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD" +
                                    " outer APPLY(select top 1 ppc.COD_LOTE_PRODUCCION as loteAsociado,ppc.CANT_LOTE_PRODUCCION as cantAsociado"+
                                    " from LOTES_PRODUCCION_CONJUNTA lpc inner join PROGRAMA_PRODUCCION ppc on"+
                                    " lpc.COD_PROGRAMA_PROD=ppc.COD_PROGRAMA_PROD and lpc.COD_LOTE_PRODUCCION_ASOCIADO=ppc.COD_LOTE_PRODUCCION"+
                                    " where lpc.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD and lpc.COD_LOTE_PRODUCCION=pp.COD_LOTE_PRODUCCION) conjunta"+
                                    " where pp.COD_LOTE_PRODUCCION='"+codLote+"' and pp.COD_PROGRAMA_PROD='"+codprogramaProd+"'";
                    System.out.println("consulta cargar datos del lote "+consulta);
                    ResultSet res=st.executeQuery(consulta);

                    int cantidadAmpollas=0;
                    String nombreProducto="";
                    String registroSanitario="";
                    String volumen="";
                    String observaciones="";
                    String condicionesGenerales="";

                    char b=13;char c=10;
                    if(res.next())
                    {
                        fechaCierre=(res.getTimestamp("FECHA_CIERRE")!=null?res.getTimestamp("FECHA_CIERRE"):new Date());
                        codEstadoHoja=res.getInt("COD_ESTADO_HOJA");
                        codSeguimientoLavadoLote=res.getInt("COD_SEGUIMIENTO_LAVADO_LOTE");
                        codSeguimientoControlDosificadoLote=res.getInt("codSeguimientoControlDosificado");
                        codPersonalSupervisor=res.getInt("COD_PERSONAL_SUPERVISOR");
                        codSeguimientoDespirogenizado=res.getInt("COD_SEGUIMIENTO_DESPIROGENIZADO_LOTE");
                        codSeguimientoControlLlenado=res.getInt("COD_SEGUIMIENTO_CONTROL_LLENADO_LOTE");
                        observaciones=res.getString("OBSERVACION");
                        codRendimientoLote=res.getString("COD_SEGUIMIENTO_RENDIMIENTO_LOTE");
                        codFormulaMaestra=res.getInt("COD_FORMULA_MAESTRA");
                        codCompProd=res.getInt("COD_COMPPROD");
                        codTipoProgramaProd=res.getInt("COD_TIPO_PROGRAMA_PROD");
                        codActividadDocumentacion=res.getInt("codActividadDocumentacion");
                        codActividadTransporte=res.getInt("codActividadTransporte");
                        codTipoProgramaProd=res.getInt("COD_TIPO_PROGRAMA_PROD");
                        volumen=res.getString("VOLUMEN_ENVASE_PRIMARIO");
                        nombreProducto=res.getString("nombre_prod");
                        codForma=res.getString("COD_FORMA");
                        cantidadAmpollas=res.getInt("CANT_LOTE_PRODUCCION");
                        registroSanitario=res.getString("REG_SANITARIO");
                        if(codActividadDocumentacion==0||codActividadTransporte==0)
                        {
                            out.println("<script>alert('No se encuentra asociada la actividad TRANSPORTE DE CONTENEDORES DE PRODUCTO PARA ENVIAR A ACONDICIONAMIENTO y/o REGISTRO DE DOCUMENTACION');window.close();</script>");
                        }
                        loteAsociado=res.getString("loteAsociado");
                        cantLoteAsociado=res.getInt("cantAsociado");
                        %>

<section class="main">
                         <div class="row"  style="margin-top:5px" >
                                <div class="large-12 medium-12 small-12 large-centered medium-centered small-centered columns" >

                                            <div class="row">
                                               <div class="large-12 medium-12 small-12 columns divHeaderClass" >
                                                       <label  class="inline">RENDIMIENTO DOSIFICADO</label>
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
                                   <label  class="inline">RENDIMIENTO DOSIFICADO</label>
                            </div>
                        </div>
                        <div class="row" >

                        <div  class="divContentClass large-12 medium-12 small-12 columns" style="padding-top:12px;">
                       
                        <div class="row">
                            <div class="large-10 medium-10 small-12 large-centered medium-centered small-centered columns">
                                <%
                                }if(administrador){%>
                                <table style="width:100%;margin-top:2%" id="dataCantidades" cellpadding="0px" cellspacing="0px">
                                            <tr>
                                                   <td class="tableHeaderClass"  style="text-align:left" >
                                                       <span class="textHeaderClass">CANTIDAD DE AMPOLLAS</span>
                                                   </td>
                                                   <td class="tableHeaderClass" style="text-align:center;">
                                                       <span class="textHeaderClass">CANTIDAD</span>
                                                   </td>
                                             </tr>
                                             
                              <%
                                consulta="select sum(s.CANT_AMPOLLAS_ACOND) as cantAcond,sum(s.CANT_AMPOLLAS_CC) as cantCC,"+
                                         " sum(s.CANT_AMPOLLAS_CARBONES) as cantCarbones,sum(s.CANT_AMPOLLAS_ROTAS) as cantRotas"+
                                         " from SEGUIMIENTO_CONTROL_DOSIFICADO_LOTE_PERSONAL s where s.COD_SEGUIMIENTO_CONTROL_DOSIFICADO_LOTE = '"+codSeguimientoControlDosificadoLote+"'";
                                System.out.println("consulta cargar seguimiento "+consulta);
                                res=st.executeQuery(consulta);
                                int cantidadCC=0;
                                int cantidadAcond=0;
                                int cantidadNegrasCarbones=0;
                                int cantidadRotas=0;
                                if(res.next())
                                {
                                    cantidadCC=res.getInt("cantCC");
                                    cantidadAcond=res.getInt("cantAcond");
                                    cantidadNegrasCarbones=res.getInt("cantCarbones");
                                    cantidadRotas=res.getInt("cantRotas");
                                }
                                int cantidadAmpollasDespirogenizadas=0;
                                consulta=" select sum(isnull(s.CANTIDAD_AMPOLLAS_BANDEJA*s.CANTIDAD_BANDEJAS,0)) as cantidadDespiro"+
                                        " from SEGUIMIENTO_AMPOLLAS_DESPIROGENIZADO_LOTE s where s.COD_SEGUIMIENTO_DESPIROGENIZADO_LOTE='"+codSeguimientoDespirogenizado+"'";
                                consulta="select SUM(isnull((s.CANTIDAD_AMPOLLAS_BANDEJAS*s.CANTIDAD_BANDEJAS),0))-isnull(sum(s.CANTIDAD_AMPOLLAS_ROTAS),0) as cantidadAmpollasLavadas"+
                                         " from SEGUIMIENTO_AMPOLLAS_LAVADO_LOTE s where s.COD_SEGUIMIENTO_LAVADO_LOTE='"+codSeguimientoLavadoLote+"'";
                                System.out.println("consulta cant ampollas lavado"+consulta);
                                res=st.executeQuery(consulta);
                                if(res.next())
                                {
                                    //cantidadAmpollasDespirogenizadas=res.getInt("cantidadDespiro");
                                    cantidadAmpollasLavadas=res.getInt("cantidadAmpollasLavadas");
                                }
                                int cantidadAmpollasControlVolumen=0;
                                consulta="select sum(CASE  when sclld.VOLUMEN_AMPOLLA1>0 then 1 else 0 end),"+
                                         " sum(CASE  when sclld.VOLUMEN_AMPOLLA2>0 then 1 else 0 end),"+
                                        " sum(CASE  when sclld.VOLUMEN_AMPOLLA3>0 then 1 else 0 end),"+
                                        " sum(CASE  when sclld.VOLUMEN_AMPOLLA4>0 then 1 else 0 end),"+
                                        " sum(CASE  when sclld.VOLUMEN_AMPOLLA5>0 then 1 else 0 end),"+
                                        " sum(CASE  when sclld.VOLUMEN_AMPOLLA6>0 then 1 else 0 end)"+
                                        " from SEGUIMIENTO_CONTROL_LLENADO_LOTE_DETALLE sclld"+
                                        " WHERE sclld.COD_SEGUIMIENTO_CONTROL_LLENADO_LOTE='"+codSeguimientoControlLlenado+"'";
                                System.out.println("consulta cantidad ampollas control llenado "+consulta);
                                res=st.executeQuery(consulta);
                                if(res.next())
                                {
                                    cantidadAmpollasControlVolumen+=res.getInt(1);
                                    cantidadAmpollasControlVolumen+=res.getInt(2);
                                    cantidadAmpollasControlVolumen+=res.getInt(3);
                                    cantidadAmpollasControlVolumen+=res.getInt(4);
                                    cantidadAmpollasControlVolumen+=res.getInt(5);
                                    cantidadAmpollasControlVolumen+=res.getInt(6);
                                    /*cantidadAmpollasControlVolumen+=res.getInt(7);
                                    cantidadAmpollasControlVolumen+=res.getInt(8);*/
                                }


                              %>
                              <tr >
                                           <td class="tableCell" style="text-align:left">
                                               <span class="textHeaderClassBody" style="font-weight:normal">AMPOLLAS ENVASADAS PARA ACONDICIONAMIENTO</span>
                                           </td>
                                           <td class="tableCell" style="text-align:center;">
                                               <span class="textHeaderClassBody" style="font-weight:normal"><%=(cantidadAcond)%></span>
                                           </td>
                                   </tr>
                                    <tr >
                                           <td class="tableCell" style="text-align:left">
                                               <span class="textHeaderClassBody" style="font-weight:normal">AMPOLLAS PARA CONTROL DE CALIDAD </span><%--(ANALISIS MICROBIOLOGICO,ANALISIS PROD TER)--%>
                                           </td>
                                           <td class="tableCell" style="text-align:center;">
                                               <span class="textHeaderClassBody" style="font-weight:normal"><%=(cantidadCC)%></span>
                                           </td>
                                    </tr>
                                    <tr >
                                           <td class="tableCell" style="text-align:left">
                                               <span class="textHeaderClassBody" style="font-weight:normal">AMPOLLAS PARA CONTROL DE VOLUMEN</span>
                                           </td>
                                           <td class="tableCell" style="text-align:center;">
                                               <span class="textHeaderClassBody" style="font-weight:normal"><%=(cantidadAmpollasControlVolumen)%></span>
                                           </td>
                                    </tr>
                                    <tr >
                                           <td class="tableCell" style="text-align:left">
                                               <span class="textHeaderClassBody" style="font-weight:normal">GLOBOS,NEGRAS,CARBONES</span>
                                           </td>
                                           <td class="tableCell" style="text-align:center;">
                                               <span class="textHeaderClassBody" style="font-weight:normal"><%=(cantidadNegrasCarbones)%></span>
                                           </td>
                                    </tr>
                                    <tr >
                                           <td class="tableCell" style="text-align:left">
                                               <span class="textHeaderClassBody" style="font-weight:normal">LAVADAS-DESPIROGENIZADAS</span>
                                           </td>
                                           <td class="tableCell" style="text-align:center;">
                                               <span class="textHeaderClassBody" style="font-weight:normal"><%=(cantidadAmpollasLavadas)%></span>
                                           </td>
                                    </tr>
                                    <tr >
                                           <td class="tableCell" style="text-align:left">
                                               <span class="textHeaderClassBody" style="font-weight:normal">ROTAS</span>
                                           </td>
                                           <td class="tableCell" style="text-align:center;">
                                               <span class="textHeaderClassBody" style="font-weight:normal"><%=(cantidadRotas)%></span>
                                           </td>
                                    </tr>
                              </table>
                              <table style="width:60%;margin-top:2%" id="dataCantidades" cellpadding="0px" cellspacing="0px">
                                  <tr>
                                       <tr>
                                               <td class="tableHeaderClass"  style="text-align:left" >
                                                   <span class="textHeaderClass">% RENDIMIENTO=</span>
                                               </td>
                                               <td class="tableCell" style="text-align:center;width:30%">
                                                   <span class="textHeaderClassBody" id="spanRendimiento" style="font-weight:normal">
                                                       <%=(cantidadAmpollasLavadas>0?Math.round(Double.valueOf(cantidadAcond-cantidadRotas-cantidadCC-cantidadNegrasCarbones)/Double.valueOf(cantidadAmpollasLavadas)*10000)/100d:0)%>
                                                   </span>
                                               </td>
                                               <td class="tableHeaderClass"  style="text-align:left" >
                                                   <span class="textHeaderClass">%</span>
                                               </td>
                                       </tr>
                                  </tr>
                              </table>
                              <%}%>
                            </div>
                        </div>
                      
                    <center>
                        <table style="width:100%;margin-top:8px" id="dataTiemposDocumentacion" cellpadding="0px" cellspacing="0px">
                            <tr>
                               <td class="tableHeaderClass"  style="text-align:center" colspan="5">
                                   <span class="textHeaderClass">Responsable de Documentacion para envio</br> de producto a acondicionamiento</span>
                               </td>
                            </tr>
                               <tr >
                                   <td class="tableHeaderClass"  style="text-align:center">
                                       <span class="textHeaderClass">Personal</span>
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
                                 consulta="select p.COD_PERSONAL,(p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL+' '+p.nombre2_personal) as nombrePersonal"+
                                          " from PERSONAL p where p.COD_ESTADO_PERSONA=1 " +//and p.cod_area_empresa in (81,41,35,38,77)
                                         (administrador?"":" and p.COD_PERSONAL='"+codPersonal+"'")+" order by p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRE_PILA";
                                         
                                System.out.println("consula personal "+consulta);
                                String personalSelect="";
                                res=st.executeQuery(consulta);
                                String personalAdmin="";
                                while(res.next())
                                {
                                    personalSelect+="<option value='"+res.getInt("COD_PERSONAL")+"'>"+res.getString("nombrePersonal")+"</option>";
                                    personalAdmin+=(res.getString("COD_PERSONAL").equals(codPersonal)?"<option value='"+res.getInt("COD_PERSONAL")+"'>"+res.getString("nombrePersonal")+"</option>":"");
                                }
                                personalSelect=UtilidadesTablet.operariosAreaProduccionAdminSelect(st,"81", codPersonal, administrador);
                                SimpleDateFormat sdfDias=new SimpleDateFormat("dd/MM/yyyy");
                                SimpleDateFormat sdfHoras=new SimpleDateFormat("HH:mm");
                                out.println("<script>operarios=\""+(administrador?personalAdmin:personalSelect)+"\";" +
                                        "fechaSistema=\""+sdfDias.format(new Date())+"\"</script>");
                                consulta="select sppp.COD_PERSONAL,sppp.FECHA_INICIO,sppp.FECHA_FINAL,sppp.HORAS_HOMBRE "+
                                        " from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sppp "+
                                        " where sppp.COD_PROGRAMA_PROD='"+codprogramaProd+"' and sppp.COD_LOTE_PRODUCCION='"+codLote+"'"+
                                        " and sppp.COD_COMPPROD='"+codCompProd+"' and sppp.COD_ACTIVIDAD_PROGRAMA='"+codActividadDocumentacion+"'"+
                                        " and sppp.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"' and sppp.COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"'"+
                                        (administrador?"":" and sppp.cod_personal='"+codPersonal+"'")+
                                        " order by sppp.FECHA_INICIO";
                                System.out.println("consulta cargar tiempos documentacion "+consulta);
                                res=st.executeQuery(consulta);
                                
                                while(res.next())
                                {
                                    out.println("<tr onclick='seleccionarFila(this)' ><td class='tableCell' style='text-align:left'>"+
                                                " <select  "+(administrador?(res.getString("COD_PERSONAL").equals(codPersonal)?"":"disabled"):"")+" id='codPersonalDoc"+res.getRow()+"'>"+(administrador&&res.getString("COD_PERSONAL").equals(codPersonal)?personalAdmin:personalSelect)+"</select><script>codPersonalDoc"+res.getRow()+".value='"+res.getString("COD_PERSONAL")+"'</script></td>"+
                                                " <td class='tableCell' style='text-align:left'><input "+(administrador?(res.getString("COD_PERSONAL").equals(codPersonal)?"":"disabled"):"")+" id='fechaDoc"+res.getRow()+"' type='tel' onclick='seleccionarDatePickerJs(this);' value='"+sdfDias.format(res.getTimestamp("FECHA_INICIO"))+"'>" +
                                                "</td>" +
                                                " <td class='tableCell' style='text-align:left;width:6em;'><input "+(administrador?(res.getString("COD_PERSONAL").equals(codPersonal)?"":"disabled"):"")+" type='text' onclick='seleccionarHora(this);' id='fechaIniDoc"+res.getRow()+"' onfocus='calcularDiferenciaHoras(this);' onkeyup='calcularDiferenciaHoras(this);' value='"+sdfHoras.format(res.getTimestamp("FECHA_INICIO"))+"'></td>" +
                                                " <td class='tableCell' style='text-align:left;width:6em;'><input "+(administrador?(res.getString("COD_PERSONAL").equals(codPersonal)?"":"disabled"):"")+" type='text' onclick='seleccionarHora(this);' id='fechaFinDoc"+res.getRow()+"' onfocus='calcularDiferenciaHoras(this);' onkeyup='calcularDiferenciaHoras(this);' value='"+sdfHoras.format(res.getTimestamp("FECHA_FINAL"))+"'></td>" +
                                                " <td class='tableCell' style='text-align:center;width:6em;' aling='center'><span class='textHeaderClassBody' style='font-weight:normal'>"+res.getDouble("HORAS_HOMBRE")+"</span></td>" +
                                                "</tr>");
                                }
                                %>
                           
                        </table>
                        <div class="row">
                            <div class="large-5 medium-5 small-4 columns" style="">&nbsp;</div>
                              <div class="large-1 medium-1 small-2 columns">
                                    <button class="small button succes radius buttonAction" onclick="nuevoRegistro('dataTiemposDocumentacion','doc')">+</button>
                              </div>
                              <div class="large-1 medium-1 small-2 columns">
                                    <button class="small button succes radius buttonAction" onclick="eliminarRegistroTabla('dataTiemposDocumentacion');">-</button>
                              </div>
                              <div class="large-5 medium-5 small-4 columns" style="">&nbsp;</div>
                       </div>
                        <table style="width:100%;margin-top:8px" id="dataTiempoTransporte" cellpadding="0px" cellspacing="0px">
                            <tr>
                               <td class="tableHeaderClass"  style="text-align:center" colspan="5">
                                   <span class="textHeaderClass">Responsable de transporte de contenedores</br> de producto a acondicionamiento</span>
                               </td>
                            </tr>
                               <tr >
                                   <td class="tableHeaderClass"  style="text-align:center">
                                       <span class="textHeaderClass">Personal</span>
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
                                consulta="select sppp.COD_PERSONAL,sppp.FECHA_INICIO,sppp.FECHA_FINAL,sppp.HORAS_HOMBRE "+
                                        " from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sppp "+
                                        " where sppp.COD_PROGRAMA_PROD='"+codprogramaProd+"' and sppp.COD_LOTE_PRODUCCION='"+codLote+"'"+
                                        " and sppp.COD_COMPPROD='"+codCompProd+"' and sppp.COD_ACTIVIDAD_PROGRAMA='"+codActividadTransporte+"'"+
                                        " and sppp.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"' and sppp.COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"'"+
                                        (administrador?"":" and sppp.cod_personal='"+codPersonal+"'")+
                                        " order by sppp.FECHA_INICIO";
                                System.out.println("consulta cargar tiempos documentacion "+consulta);
                                res=st.executeQuery(consulta);
                                while(res.next())
                                {
                                    out.println("<tr onclick='seleccionarFila(this)' ><td class='tableCell' style='text-align:left'>"+
                                                " <select "+(administrador?(res.getString("COD_PERSONAL").equals(codPersonal)?"":"disabled"):"")+" id='codPersonaltrans"+res.getRow()+"'>"+(administrador&&res.getString("COD_PERSONAL").equals(codPersonal)?personalAdmin:personalSelect)+"</select><script>codPersonaltrans"+res.getRow()+".value='"+res.getString("COD_PERSONAL")+"'</script></td>"+
                                                " <td class='tableCell' style='text-align:left'>" +
                                                "<input "+(administrador?(res.getString("COD_PERSONAL").equals(codPersonal)?"":"disabled"):"")+" id='fechaTrans"+res.getRow()+"' type='tel' onclick='seleccionarDatePickerJs(this);' value='"+sdfDias.format(res.getTimestamp("FECHA_INICIO"))+"'>" +
                                                "</td>" +
                                                " <td class='tableCell' style='text-align:left;width:6em;'><input "+(administrador?(res.getString("COD_PERSONAL").equals(codPersonal)?"":"disabled"):"")+" type='text' onclick='seleccionarHora(this);' id='fechaIniTrans"+res.getRow()+"' onfocus='calcularDiferenciaHoras(this);' onkeyup='calcularDiferenciaHoras(this);' value='"+sdfHoras.format(res.getTimestamp("FECHA_INICIO"))+"'></td>" +
                                                " <td class='tableCell' style='text-align:left;width:6em;'><input "+(administrador?(res.getString("COD_PERSONAL").equals(codPersonal)?"":"disabled"):"")+" type='text' onclick='seleccionarHora(this);' id='fechaFinTrans"+res.getRow()+"' onfocus='calcularDiferenciaHoras(this);' onkeyup='calcularDiferenciaHoras(this);' value='"+sdfHoras.format(res.getTimestamp("FECHA_FINAL"))+"'></td>" +
                                                " <td class='tableCell' style='text-align:center;width:6em;' aling='center'><span class='textHeaderClassBody' style='font-weight:normal'>"+res.getDouble("HORAS_HOMBRE")+"</span></td>" +
                                                "</tr>");
                                }
                                %>

                        </table>
                        <div class="row">
                            <div class="large-5 medium-5 small-4 columns" style="">&nbsp;</div>
                          <div class="large-1 medium-1 small-2 columns">
                                <button class="small button succes radius buttonAction" onclick="nuevoRegistro('dataTiempoTransporte','trans')">+</button>
                          </div>
                          <div class="large-1 medium-1 small-2 columns">
                                    <button class="small button succes radius buttonAction" onclick="eliminarRegistroTabla('dataTiempoTransporte');">-</button>
                          </div>
                          <div class="large-5 medium-5 small-4 columns" style="">&nbsp;</div>
                       </div>
                       <input type="hidden" value="<%=(codPersonalSupervisor)%>" id="cerrado"/>
                       <%if(administrador){
                         consulta="select (p.AP_PATERNO_PERSONAL + ' ' + p.AP_MATERNO_PERSONAL + ' ' +p.NOMBRES_PERSONAL + ' ' + p.nombre2_personal) as nombrePersonal"+
                                  " from PERSONAL p where p.COD_PERSONAL='"+codPersonal+"'";
                         res=st.executeQuery(consulta);
                         String nombresUsuario="";
                         if(res.next())nombresUsuario=res.getString(1);
                          %>
                    <table style="width:80%;margin-top:2px;border-bottom:solid #a80077 1px;" id="datosAdicionales" cellpadding="0px" cellspacing="0px" >
                        <tr >
                               <td class="tableHeaderClass" style="text-align:center" colspan="3">
                                   <span class="textHeaderClass">Aprobacion</span>
                               </td>
                        </tr>
                        <tr >
                                <td style="border-left:solid #a80077 1px;text-align:left">
                                   <span >JEFE DE AREA:</span>
                               </td>
                                <td style="border-right:solid #a80077 1px;text-align:left">
                                   <input type="hidden" value="<%=(codPersonalSupervisor)%>" id="codPersonalSupervisor"/>
                                   <span><%=(nombresUsuario)%></span>
                               </td>

                        </tr>
                        <tr >
                                <td style="border-left:solid #a80077 1px;text-align:left">
                                   <span >FECHA:</span>
                               </td>
                                <td style="border-right:solid #a80077 1px;text-align:left">
                                    <span><%=(sdfDias.format(fechaCierre))%></span>
                               </td>

                        </tr>
                        <tr >
                                <td style="border-left:solid #a80077 1px;text-align:left">
                                   <span >HORA:</span>
                               </td>
                                <td style="border-right:solid #a80077 1px;text-align:left">
                                    <span><%=(sdfHoras.format(fechaCierre))%></span>
                               </td>

                        </tr>
                        <tr>
                                <td class="" style="border-left:solid #a80077 1px;text-align:left;width:4%">
                                   <span >Observacion</span>
                               </td>

                                <td class="" style="border-right:solid #a80077 1px;text-align:left">
                                    <textarea id="observacion" ><%=observaciones%></textarea>
                               </td>
                        </tr>
                    </table>
                    <%}%>
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
                                        <button class="small button succes radius buttonAction" onclick="guardarRendimiento();" >Guardar</button>
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
        <input type="hidden" id="codLoteSeguimiento" value="<%=(codLote)%>">
        <input type="hidden" id="codProgramaProd" value="<%=(codprogramaProd)%>">
        <input type="hidden" id="codRendimientoLote" value="<%=(codRendimientoLote)%>">
        <input type="hidden" id="codFormulaMaestra" value="<%=(codFormulaMaestra)%>"/>
        <input type="hidden" id="codTipoProgramaProd" value="<%=(codTipoProgramaProd)%>"/>
        <input type="hidden" id="codCompProd" value="<%=(codCompProd)%>"/>
        <input type="hidden" id="codActividadDocumentacion" value="<%=(codActividadDocumentacion)%>"/>
        <input type="hidden" id="codActividadTransporte" value="<%=(codActividadTransporte)%>"/>
        </section>
    </body>
    <script src="../../reponse/js/timePickerJs.js"></script>
    <script src="../../reponse/js/dataPickerJs.js"></script>
    <script>iniciarDatePicker('<%=(sdf.format(new Date()))%>');loginHoja.verificarHojaCerrada('cerrado',admin,'codProgramaProd','codLoteSeguimiento',9,<%=(codEstadoHoja)%>);</script>
</html>
