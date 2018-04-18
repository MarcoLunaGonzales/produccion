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



<html>
   <head>
<!DOCTYPE html PUBLIC
          "-//W3C//DTD XHTML 1.0 Transitional//EN"
          "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
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
     var sanitizantesSelect="";
     var seccionesSelect="";
     var maquinariasSelect="";
     var operariosLimpieza="";
     var contRegistro=0;
     var fechaRegistroNuevo="";
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
    function ocultarPanelProgreso()
    {
        document.getElementById('formsuper').style.visibility='hidden';
        document.getElementById('divImagen').style.visibility='hidden';
    }
    function validarSeleccionTipoLimpieza(check1,check2)
    {
        if(check1.checked||check2.checked)
        {
            check1.parentNode.style.backgroundColor='#FFFFFF';
            check2.parentNode.style.backgroundColor='#FFFFFF';
            return true
        }
        else
        {
            check1.parentNode.style.backgroundColor='#F08080';
            check2.parentNode.style.backgroundColor='#F08080';
            check1.focus();
            alert('Debe de seleccionar al menos un tipo de limpieza');
            return false;
        }
        return true;
    }
    function guardarLimpieza()
    {
        document.getElementById('formsuper').style.visibility='visible';
        document.getElementById('divImagen').style.visibility='visible';
        var tablaSecciones=document.getElementById("dataLimpiezaSecciones");
        var dataSecciones=new Array();
        var tablaEsterilizacion=document.getElementById("dataTiemEsterilizacionUtensilios");
        var dataEsterilizacion =new Array();
        if(!admin)
        {
            for(var i=0;i<tablaSecciones.rows.length;i+=2)
            {
                if(tablaSecciones.rows[i].cells[0].getElementsByTagName("input")[0].checked)
                {
                    
                    var tablaRegistros=tablaSecciones.rows[i+1].cells[0].getElementsByTagName("table")[0];
                    for(var j=3;j<tablaRegistros.rows.length;j++)
                    {
                        
                        dataSecciones[dataSecciones.length]=tablaSecciones.rows[i+1].cells[0].getElementsByTagName("input")[0].value;
                        dataSecciones[dataSecciones.length]=tablaRegistros.rows[j].cells[0].getElementsByTagName("select")[0].value;
                        dataSecciones[dataSecciones.length]=tablaRegistros.rows[j].cells[2].getElementsByTagName("select")[0].value;
                        dataSecciones[dataSecciones.length]=(tablaRegistros.rows[j].cells[3].getElementsByTagName("input")[0].checked?1:0);
                        dataSecciones[dataSecciones.length]=(tablaRegistros.rows[j].cells[4].getElementsByTagName("input")[0].checked?1:0);
                        if(codEstadoHojaGeneral==3)
                        {
                            dataSecciones[dataSecciones.length]=(tablaRegistros.rows[j].cells[5].getElementsByTagName("input")[0].value);
                            dataSecciones[dataSecciones.length]=(tablaRegistros.rows[j].cells[6].getElementsByTagName("input")[0].value);
                            dataSecciones[dataSecciones.length]=(tablaRegistros.rows[j].cells[7].getElementsByTagName("input")[0].value);
                            dataSecciones[dataSecciones.length]=getNumeroDehoras((dataSecciones[dataSecciones.length-3]+' '+dataSecciones[dataSecciones.length-2]),
                                (dataSecciones[dataSecciones.length-3]+' '+dataSecciones[dataSecciones.length-1]));
                        }
                        else
                        {
                            dataSecciones[dataSecciones.length]=(tablaRegistros.rows[j].cells[5].getElementsByTagName("span")[0].innerHTML);
                            dataSecciones[dataSecciones.length]=(tablaRegistros.rows[j].cells[6].getElementsByTagName("span")[0].innerHTML);
                            dataSecciones[dataSecciones.length]=(tablaRegistros.rows[j].cells[7].getElementsByTagName("span")[0].innerHTML);
                            dataSecciones[dataSecciones.length]=getNumeroDehoras((dataSecciones[dataSecciones.length-3]+' '+dataSecciones[dataSecciones.length-2]),
                                (dataSecciones[dataSecciones.length-3]+' '+dataSecciones[dataSecciones.length-1]));
                            dataSecciones[dataSecciones.length]=(tablaRegistros.rows[j].cells[7].getElementsByTagName("button")[0].className=='buttonFinishActive'?1:0);
                        }
                    }
                }
            }
            for(var j=4;j<tablaEsterilizacion.rows.length;j++)
            {

                dataEsterilizacion[dataEsterilizacion.length]=tablaEsterilizacion.rows[j].cells[1].getElementsByTagName("select")[0].value;
                dataEsterilizacion[dataEsterilizacion.length]=(tablaEsterilizacion.rows[j].cells[2].getElementsByTagName("input")[0].checked?1:0);
                dataEsterilizacion[dataEsterilizacion.length]=(tablaEsterilizacion.rows[j].cells[3].getElementsByTagName("input")[0].checked?1:0);
                if(codEstadoHojaGeneral==3)
                {
                    dataEsterilizacion[dataEsterilizacion.length]=(tablaEsterilizacion.rows[j].cells[4].getElementsByTagName("input")[0].value);
                    dataEsterilizacion[dataEsterilizacion.length]=(tablaEsterilizacion.rows[j].cells[5].getElementsByTagName("input")[0].value);
                    dataEsterilizacion[dataEsterilizacion.length]=(tablaEsterilizacion.rows[j].cells[6].getElementsByTagName("input")[0].value);
                    dataEsterilizacion[dataEsterilizacion.length]=getNumeroDehoras((dataEsterilizacion[dataEsterilizacion.length-3]+' '+dataEsterilizacion[dataEsterilizacion.length-2]),
                        (dataEsterilizacion[dataEsterilizacion.length-3]+' '+dataEsterilizacion[dataEsterilizacion.length-1]));
                }
                else
                {
                    dataEsterilizacion[dataEsterilizacion.length]=(tablaEsterilizacion.rows[j].cells[4].getElementsByTagName("span")[0].innerHTML);
                    dataEsterilizacion[dataEsterilizacion.length]=(tablaEsterilizacion.rows[j].cells[5].getElementsByTagName("span")[0].innerHTML);
                    dataEsterilizacion[dataEsterilizacion.length]=(tablaEsterilizacion.rows[j].cells[6].getElementsByTagName("span")[0].innerHTML);
                    dataEsterilizacion[dataEsterilizacion.length]=getNumeroDehoras((dataEsterilizacion[dataEsterilizacion.length-3]+' '+dataEsterilizacion[dataEsterilizacion.length-2]),
                        (dataEsterilizacion[dataEsterilizacion.length-3]+' '+dataEsterilizacion[dataEsterilizacion.length-1]));
                    dataEsterilizacion[dataEsterilizacion.length]=(tablaEsterilizacion.rows[j].cells[6].getElementsByTagName("button")[0].className=='buttonFinishActive'?1:0);
                }
            }
        }
       // console.log(dataEsterilizacion);
            var date=new Date();
            var peticion="ajaxGuardarRegistroLimpieza.jsf?codLote="+document.getElementById("codLoteSeguimiento").value+"&noCache="+ Math.random()+"&date="+date.getTime().toString()+
                "&codProgProd="+document.getElementById("codProgramaProd").value+"&codSeguimiento="+document.getElementById("codSeguimientoLimpiezaLote").value+
             "&codCompProd="+document.getElementById("codCompProd").value+"&codTipoProgramaProd="+document.getElementById("codTipoProgramaProd").value+
             "&codFormulaMaestra="+document.getElementById("codFormulaMaestra").value+
             (admin?"":"&codActividadBlisteado="+document.getElementById("codActividadBlisteado").value+
             "&codActividadGranulado="+document.getElementById("codActividadGranulado").value+
             "&codActividadPreparado="+document.getElementById("codActividadPreparado").value+
             "&codActividadRecubrimiento="+document.getElementById("codActividadRecubrimiento").value+
             "&codActividadSecado="+document.getElementById("codActividadSecado").value+
             "&codActividadTableteado="+document.getElementById("codActividadTableteado").value+
             "&codActividadTamizado="+document.getElementById("codActividadTamizado").value+
             "&codActividadEsterilizacion="+document.getElementById("codActividadEsterilizacion").value)+
             "&dataSecciones="+dataSecciones+
             "&dataEsterilizacion="+dataEsterilizacion+
             "&registroManual="+(codEstadoHojaGeneral==3?1:0)+
             "&admin="+(admin?1:0)+"&codPersonalUsuario="+codPersonal+
             (admin?"&observacion="+encodeURIComponent(document.getElementById("observacion").value):"")
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
                                sqlConnection.insertarRegistroAuxiliar(codProgramaProd,codLote,1,("../registroLimpiezaAmbientes/"+peticion),function(){window.close();});
                            }
                            ocultarPanelProgreso();
                            return false;
                        }
                        if(parseInt(ajax.responseText.split("\n").join(""))=='1')
                        {
                            alert('Se registro la limpieza de equipos');
                            ocultarPanelProgreso();
                            window.close();
                            return true;
                        }
                        else
                        {
                            alert(ajax.responseText.split("\n").join(""));
                            ocultarPanelProgreso();
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
   
  
  function onChangeEstado(checkbox)
  {
      checkbox.checked=true;
      var incremento=(checkbox.parentNode.parentNode.cells.length==8?0:1);
      if(checkbox.parentNode.cellIndex==(4-incremento))
      {
          checkbox.parentNode.parentNode.cells[3-incremento].getElementsByTagName("input")[0].checked=false;
      }
      else
      {
          checkbox.parentNode.parentNode.cells[4-incremento].getElementsByTagName("input")[0].checked=false;
      }
  }
</script>
<script>
    function seleccionarLimpiezaArea(input)
    {
        input.parentNode.className=(input.checked?'tableHeaderClass primerafilaSelect':'tableHeaderClass primerafila');
        
        input.parentNode.parentNode.parentNode.rows[(input.parentNode.parentNode.rowIndex+1)].cells[0].style.display=(input.checked?'inherit':'none');
        window.setTimeout(function(){input.parentNode.parentNode.parentNode.rows[(input.parentNode.parentNode.rowIndex+1)].cells[0].style.opacity=(input.checked?'1':'0');}, 10);
        //
    }
    function  masLimpiezaSecciones(codSeccion)
   {
       contRegistro++;
       var table = document.getElementById("tablaSeccion"+codSeccion);
       var rowCount = table.rows.length;
       var row = table.insertRow(rowCount);
       row.onclick=function(){seleccionarFila(this);};
       var cell1 = row.insertCell(0);
       cell1.className="tableCell";
       var element1 = document.createElement("select");
       element1.innerHTML=maquinariasSelect;
       cell1.appendChild(element1);
       var cellPer = row.insertCell(1);
       cellPer.className="tableCell";
       var personal = document.createElement("select");
       personal.innerHTML=operariosLimpieza;
       cellPer.appendChild(personal);
       var cellSanitizante = row.insertCell(2);
       cellSanitizante.className="tableCell";
       var sanitizante = document.createElement("select");
       sanitizante.innerHTML=sanitizantesSelect;
       cellSanitizante.appendChild(sanitizante);


       var cell4=row.insertCell(3);
       cell4.className="tableCell";
       cell4.style.textAlign="center" ;
       var element4=document.createElement("input");
       element4.type='checkbox';
       element4.style.height="20px";
       element4.style.width="20px";
       element4.onclick=function(){onChangeEstado(this);};
       cell4.appendChild(element4);

       var cell5=row.insertCell(4);
       cell5.className="tableCell";
       cell5.style.textAlign="center" ;
       var element5=document.createElement("input");
       element5.type='checkbox';
       element5.style.height="20px";
       element5.style.width="20px";
       element5.onclick=function(){onChangeEstado(this);};
       cell5.appendChild(element5);

       
        var celdaFecha = row.insertCell(5);
       celdaFecha.className="tableCell";
       var fechaInput = document.createElement("input");
       fechaInput.id="fechaTiempo"+contRegistro;
       fechaInput.type = "text";
       fechaInput.onclick=function(){seleccionarDatePickerJs(this);};
       fechaInput.value=fechaRegistroNuevo;
       var fechaSpan=document.createElement("span");
       fechaSpan.className='textHeaderClassBodyNormal';
       fechaSpan.innerHTML=fechaRegistroNuevo;
       
       if(codEstadoHojaGeneral==3)
       {
           celdaFecha.appendChild(fechaInput);
           for(var i=0;i<2;i++)
           {
               var cell3 = row.insertCell(i+6);
               cell3.className="tableCell";
               var element3 = document.createElement("input");
               element3.type = "text";
               cell3.align='center';
               element3.style.width='6em';
               element3.value=getHoraActualString();
               element3.id='hora'+i+'t'+contRegistro;
               element3.onclick=function(){seleccionarHora(this);};
               cell3.appendChild(element3);
           }
       }
       else
       {
               celdaFecha.appendChild(fechaSpan);
               var celdaHoraInicio = row.insertCell(6);
               celdaHoraInicio.className="tableCell";
               celdaHoraInicio.align='center';
               var horaInicioSpan = document.createElement("span");
               horaInicioSpan.className="textHeaderClassBodyNormal";
               horaInicioSpan.innerHTML=getHoraActualGeneralString();
               celdaHoraInicio.appendChild(horaInicioSpan);
               var celdaHoraFinal = row.insertCell(7);
               celdaHoraFinal.className="tableCell";
               celdaHoraFinal.align='center';
               var buttonFinish=document.createElement("button");
               buttonFinish.className='buttonFinish';
               buttonFinish.innerHTML='Terminar';
               var horaInicio=getHoraActualGeneralString();
               buttonFinish.onclick=function(){calcularHorasGeneral(this,horaInicio);};
               var horaFinSpan = document.createElement("span");
               horaFinSpan.className="textHeaderClassBodyNormal";
               horaFinSpan.innerHTML=getHoraActualString();
               celdaHoraFinal.appendChild(buttonFinish);
               celdaHoraFinal.appendChild(horaFinSpan);
       }
  }
  function  masEsterilizacionUtensilios()
   {
       contRegistro++;
       var table = document.getElementById("dataTiemEsterilizacionUtensilios");
       var rowCount = table.rows.length;
       var row = table.insertRow(rowCount);
       row.onclick=function(){seleccionarFila(this);};
       var cellPer = row.insertCell(0);
       cellPer.className="tableCell";
       var personal = document.createElement("select");
       personal.innerHTML=operariosLimpieza;
       cellPer.appendChild(personal);
       var cellSanitizante = row.insertCell(1);
       cellSanitizante.className="tableCell";
       var sanitizante = document.createElement("select");
       sanitizante.innerHTML=sanitizantesSelect;
       cellSanitizante.appendChild(sanitizante);


       var cell4=row.insertCell(2);
       cell4.className="tableCell";
       cell4.style.textAlign="center" ;
       var element4=document.createElement("input");
       element4.type='checkbox';
       element4.style.height="20px";
       element4.style.width="20px";
       element4.onclick=function(){onChangeEstado(this);};
       cell4.appendChild(element4);

       var cell5=row.insertCell(3);
       cell5.className="tableCell";
       cell5.style.textAlign="center" ;
       var element5=document.createElement("input");
       element5.type='checkbox';
       element5.style.height="20px";
       element5.style.width="20px";
       element5.onclick=function(){onChangeEstado(this);};
       cell5.appendChild(element5);


        var celdaFecha = row.insertCell(4);
       celdaFecha.className="tableCell";
       celdaFecha.align="center";
       var fechaInput = document.createElement("input");
       fechaInput.id="fechaTiempo"+contRegistro;
       fechaInput.type = "text";
       fechaInput.onclick=function(){seleccionarDatePickerJs(this);};
       fechaInput.value=fechaRegistroNuevo;
       var fechaSpan=document.createElement("span");
       fechaSpan.className='textHeaderClassBodyNormal';
       fechaSpan.innerHTML=fechaRegistroNuevo;
       

       if(codEstadoHojaGeneral==3)
       {
           celdaFecha.appendChild(fechaInput);
           for(var i=0;i<2;i++)
           {
               var cell3 = row.insertCell(i+5);
               cell3.className="tableCell";
               var element3 = document.createElement("input");
               element3.type = "text";
               cell3.align='center';
               element3.style.width='6em';
               element3.value=getHoraActualString();
               element3.id='hora'+i+'t'+contRegistro;
               element3.onclick=function(){seleccionarHora(this);};
               cell3.appendChild(element3);
           }
       }
       else
       {
               celdaFecha.appendChild(fechaSpan);
               var celdaHoraInicio = row.insertCell(5);
               celdaHoraInicio.className="tableCell";
               celdaHoraInicio.align='center';
               var horaInicioSpan = document.createElement("span");
               horaInicioSpan.className="textHeaderClassBodyNormal";
               horaInicioSpan.innerHTML=getHoraActualGeneralString();
               celdaHoraInicio.appendChild(horaInicioSpan);
               var celdaHoraFinal = row.insertCell(6);
               celdaHoraFinal.className="tableCell";
               celdaHoraFinal.align='center';
               var buttonFinish=document.createElement("button");
               buttonFinish.className='buttonFinish';
               buttonFinish.innerHTML='Terminar';
               var horaInicio=getHoraActualGeneralString();
               buttonFinish.onclick=function(){calcularHorasGeneral(this,horaInicio);};
               var horaFinSpan = document.createElement("span");
               horaFinSpan.className="textHeaderClassBodyNormal";
               horaFinSpan.innerHTML=getHoraActualString();
               celdaHoraFinal.appendChild(buttonFinish);
               celdaHoraFinal.appendChild(horaFinSpan);
       }


  }
</script>
<style>
    .textCheck
    {
        display:initial;
        padding:0px !important;
    }
    .checkBox
    {
        vertical-align:top;
        width:20px;
        height:20px;
        margin-right:0.6em !important;
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
        opacity: 0;
        top:0px;
        max-height:0px;
        border: solid #a80077 1px;
        display:none;
        -webkit-transition-duration:0.7s;
        -moz-transition-duration: 0.7s;
        transition-duration: 0.7s;
        border-bottom-left-radius: 16px ;
        border-bottom-right-radius: 16px ;
    }
    
</style>

</head>
    <body >
        <div style="margin-top:2%;position:fixed;;width:100%;z-index:5;visibility:hidden" id="divImagen">
         <center><img src="../../reponse/img/load2.gif"  style="z-index:6; "><%--margin-top:2%;position:fixed;--%>
         </center>
         </div>
      
  <%
        String loteAsociado="";
        int cantLoteAsociado=0;
        String codPersonal=request.getParameter("codPersonal");
        boolean administrador=(Integer.valueOf(request.getParameter("admin"))>0);
        out.println("<script type='text/javascript'>codPersonal="+codPersonal+";" +
                   "admin="+administrador+";</script>");
        int codEstadoHoja=0;
        Date fechaCierre=new Date();
        String codLote=request.getParameter("codLote");
        out.println("<title>("+codLote+")LIMPIEZA</title>");
        String codprogramaProd=request.getParameter("cod_prog");
        String nombreComponente="as";
        String nombreAreaEmpresa="as";
        int codForma=0;
        String codAreaEmpresa=request.getParameter("codAreaEmpresa");
        Date fechaRegistro=new Date();
        String observacionLote="";
        String codSeguimientoLimpiezaLote="";
        NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
        DecimalFormat format = (DecimalFormat)nf;
        SimpleDateFormat sdfDias=new SimpleDateFormat("dd/MM/yyyy");
        SimpleDateFormat sdfHoras=new SimpleDateFormat("HH:mm");
        format.applyPattern("#,##0.00");
        String seccionesSelect="";
        String sanitizantesSelect="";
        String maquinariasSelect="";
        int codActividadPreparado=0;
        int codActividadGranulado=0;
        int codActividadSecado=0;
        int codActividadTamizado=0;
        int codActividadTableteado=0;
        int codActividadRecubrimiento=0;
        int codActividadBlisteado=0;


        int codFormulaMaestra=0;
        int codCompProd=0;
        int codTipoProgramaProd=0;
        int codActividadEsterilizacion=0;
        String maquinariasSeccionesSelect="";
        String codPersonalVerifica="";
        out.println("<script>sqlConnection.verificarRegistroPendiente('"+codprogramaProd+"','"+codLote+"',1)</script>");
                try
                {
                    Connection con=null;
                    con=Util.openConnection(con);
                    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    String consulta="select pp.COD_TIPO_PROGRAMA_PROD, pp.COD_COMPPROD,cp.COD_FORMA,p.nombre_prod,f.abreviatura_forma,cp.nombre_prod_semiterminado,cp.NOMBRE_GENERICO,f.nombre_forma,cp.REG_SANITARIO,"+
                                    " ep.nombre_envaseprim,cp.VIDA_UTIL,pp.CANT_LOTE_PRODUCCION,ppp.FECHA_FINAL," +
                                    " pp.COD_FORMULA_MAESTRA,isnull(sll.COD_SEGUIMIENTO_LIMPIEZA_LOTE,0) as COD_SEGUIMIENTO_LIMPIEZA_LOTE" +
                                    " ,ISNULL(cp.VOLUMEN_ENVASE_PRIMARIO,'') as VOLUMEN_ENVASE_PRIMARIO," +
                                    " ISNULL(sll.COD_PERSONAL_SUPERVISOR,0) as COD_PERSONAL_VERIFICA,"+
                                    " sll.FECHA_CIERRE,isnull(sll.OBSERVACIONES,'') as OBSERVACIONES" +
                                    " ,isnull(afm.COD_ACTIVIDAD_FORMULA,0) as codActividadPreparado,"+
                                    " isnull(afm1.COD_ACTIVIDAD_FORMULA,0) as codActividadGranulado,"+
                                    " ISNULL(afm2.COD_ACTIVIDAD_FORMULA,0) as codActividadSecado,"+
                                    " isnull(afm3.COD_ACTIVIDAD_FORMULA,0) as codActividadTamizado" +
                                    " ,isnull(afm4.COD_ACTIVIDAD_FORMULA,0) as codActividadTabletado" +
                                    " ,isnull(afm5.COD_ACTIVIDAD_FORMULA,0) as codActividadRecubrimiento" +
                                    " ,isnull(afm6.COD_ACTIVIDAD_FORMULA,0) as codActividadBlisteado" +
                                    " ,isnull(afm7.COD_ACTIVIDAD_FORMULA,0) as codActividadEsterilizacion" +
                                    " ,isnull(dpff.INDICACIONES_ESTERILIZACION_UTENSILIOS,'') as INDICACIONES_ESTERILIZACION_UTENSILIOS" +
                                    ",isnull(dpff.INDICACIONES_LIMPIEZA_AMBIENTE,'') as INDICACIONES_LIMPIEZA_AMBIENTE," +
                                    "isnull(dpff.INDICACIONES_LIMPIEZA_EQUIPOS,'') as INDICACIONES_LIMPIEZA_EQUIPOS,sll.COD_ESTADO_HOJA" +
                                    " ,isnull(conjunta.loteAsociado,'') as loteAsociado,isnull(conjunta.cantAsociado,0) as cantAsociado" +
                                    " ,isnull(cpp.NOMBRE_COLORPRESPRIMARIA,'') as colorPresPrim"+
                                    " from PROGRAMA_PRODUCCION pp inner join COMPONENTES_PROD cp on cp.COD_COMPPROD=pp.COD_COMPPROD"+
                                    " inner join FORMAS_FARMACEUTICAS f on f.cod_forma=cp.COD_FORMA"+
                                    " inner join productos p on p.cod_prod=cp.COD_PROD"+
                                    " inner join PRESENTACIONES_PRIMARIAS ppm on ppm.COD_COMPPROD=cp.COD_COMPPROD and ppm.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD"+
                                    " inner join ENVASES_PRIMARIOS ep on ep.cod_envaseprim=ppm.COD_ENVASEPRIM" +
                                    " inner join PROGRAMA_PRODUCCION_PERIODO ppp on pp.COD_PROGRAMA_PROD=ppp.COD_PROGRAMA_PROD" +
                                    " left outer join COLORES_PRESPRIMARIA cpp on cpp.COD_COLORPRESPRIMARIA=cp.COD_COLORPRESPRIMARIA" +
                                    " left outer join SEGUIMIENTO_LIMPIEZA_LOTE sll on sll.COD_LOTE=pp.COD_LOTE_PRODUCCION"+
                                    " and sll.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD"+
                                    " left outer join DESCRIPCION_PROCESOS_FORMA_FARMACEUTICA dpff on dpff.COD_FORMA=cp.COD_FORMA" +
                                    " left outer join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_AREA_EMPRESA ="+
                                    " 96 and afm.COD_ACTIVIDAD = 128 and afm.COD_FORMULA_MAESTRA =pp.COD_FORMULA_MAESTRA and afm.COD_PRESENTACION=0"+
                                    " left outer join ACTIVIDADES_FORMULA_MAESTRA afm1 on afm1.COD_AREA_EMPRESA ="+
                                    " 96 and afm1.COD_ACTIVIDAD = 4 and afm1.COD_FORMULA_MAESTRA =pp.COD_FORMULA_MAESTRA and afm1.COD_PRESENTACION=0"+
                                    " left outer join ACTIVIDADES_FORMULA_MAESTRA afm2 on afm2.COD_AREA_EMPRESA ="+
                                    " 96 and afm2.COD_ACTIVIDAD =6 and afm2.COD_FORMULA_MAESTRA =pp.COD_FORMULA_MAESTRA and afm2.COD_PRESENTACION=0"+
                                    " left outer join ACTIVIDADES_FORMULA_MAESTRA afm3 on afm3.COD_AREA_EMPRESA ="+
                                    " 96 and afm3.COD_ACTIVIDAD = 10 and afm3.COD_FORMULA_MAESTRA =pp.COD_FORMULA_MAESTRA and afm3.COD_PRESENTACION=0"+
                                    " left outer join ACTIVIDADES_FORMULA_MAESTRA afm4 on afm4.COD_AREA_EMPRESA ="+
                                    " 96 and afm4.COD_ACTIVIDAD = 14 and afm4.COD_FORMULA_MAESTRA =pp.COD_FORMULA_MAESTRA and afm4.COD_PRESENTACION=0"+
                                    " left outer join ACTIVIDADES_FORMULA_MAESTRA afm5 on afm5.COD_AREA_EMPRESA ="+
                                    " 96 and afm5.COD_ACTIVIDAD = 23 and afm5.COD_FORMULA_MAESTRA =pp.COD_FORMULA_MAESTRA and afm5.COD_PRESENTACION=0" +
                                    " left outer join ACTIVIDADES_FORMULA_MAESTRA afm6 on afm6.COD_AREA_EMPRESA ="+
                                    " 96 and afm6.COD_ACTIVIDAD = 18 and afm6.COD_FORMULA_MAESTRA =pp.COD_FORMULA_MAESTRA and afm6.COD_PRESENTACION=0" +
                                    " left outer join ACTIVIDADES_FORMULA_MAESTRA afm7 on afm7.COD_AREA_EMPRESA ="+
                                    " 96 and afm7.COD_ACTIVIDAD = 261 and afm7.COD_FORMULA_MAESTRA =pp.COD_FORMULA_MAESTRA and afm7.COD_PRESENTACION=0" +
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
                    String indicacionesLimpiezaAmbientes="";
                    String indicacionesLimpiezaEquipos="";
                    String indicacionesLimpiezaUtencilios="";
                    String personal="";
                    
                    char b=13;char c=10;
                    if(res.next())
                    {
                        fechaCierre=(res.getTimestamp("FECHA_CIERRE")!=null?res.getTimestamp("FECHA_CIERRE"):new Date());
                        codEstadoHoja=res.getInt("COD_ESTADO_HOJA");
                        codForma=res.getInt("COD_FORMA");
                        codActividadBlisteado=res.getInt("codActividadBlisteado");
                        codActividadGranulado=res.getInt("codActividadGranulado");
                        codActividadPreparado=res.getInt("codActividadPreparado");
                        codActividadRecubrimiento=res.getInt("codActividadRecubrimiento");
                        codActividadSecado=res.getInt("codActividadSecado");
                        codActividadTableteado=res.getInt("codActividadTabletado");
                        codActividadTamizado=res.getInt("codActividadTamizado");
                        codTipoProgramaProd=res.getInt("COD_TIPO_PROGRAMA_PROD");
                        codActividadEsterilizacion=res.getInt("codActividadEsterilizacion");
                        String mensaje=(codActividadBlisteado>0?"":"LIMPIEZA PARA BLISTEADO");
                        mensaje+=(codActividadEsterilizacion>0?"":(mensaje.equals("")?"":",")+"ESTERILIZACION DE UTENSILIOS");
                        mensaje+=(codActividadGranulado>0?"":(mensaje.equals("")?"":",")+"LIMPIEZA PARA GRANULADO");
                        mensaje+=(codActividadPreparado>0?"":(mensaje.equals("")?"":",")+"LIMPIEZA PARA PREPARADO");
                        mensaje+=(codActividadRecubrimiento>0?"":(mensaje.equals("")?"":",")+"LIMPIEZA PARA RECUBRIMIENTO");
                        mensaje+=(codActividadSecado>0?"":(mensaje.equals("")?"":",")+"LIMPIEZA PARA SECADO");
                        mensaje+=(codActividadTableteado>0?"":(mensaje.equals("")?"":",")+"LIMPIEZA PARA TABLETEADO");
                        mensaje+=(codActividadTamizado>0?"":(mensaje.equals("")?"":",")+"LIMPIEZA PARA TAMIZADO");
                        if(!mensaje.equals(""))out.println("<script>alert('No se encuentran asociadas las actividades de :"+mensaje+"');window.close();</script>");
                        codCompProd=res.getInt("COD_COMPPROD");
                        indicacionesLimpiezaAmbientes=res.getString("INDICACIONES_LIMPIEZA_AMBIENTE").replace(b,'\n').replace("\n", "</br>").replace("</br></br>","<br>");
                        indicacionesLimpiezaEquipos=res.getString("INDICACIONES_LIMPIEZA_EQUIPOS").replace(b,'\n').replace("\n", "</br>").replace("</br></br>","<br>");
                        indicacionesLimpiezaUtencilios=res.getString("INDICACIONES_ESTERILIZACION_UTENSILIOS").replace(b,'\n').replace("\n", "</br>").replace("</br></br>","<br>");
                        codPersonalVerifica=res.getString("COD_PERSONAL_VERIFICA");
                        observaciones=res.getString("OBSERVACIONES");
                        fechaRegistro=(res.getDate("FECHA_CIERRE")==null?new Date():res.getTimestamp("FECHA_CIERRE"));
                        codSeguimientoLimpiezaLote=res.getString("COD_SEGUIMIENTO_LIMPIEZA_LOTE");
                        codFormulaMaestra=res.getInt("COD_FORMULA_MAESTRA");
                        volumen=res.getString("VOLUMEN_ENVASE_PRIMARIO");
                        nombreProducto=res.getString("nombre_prod");
                        
                        cantidadAmpollas=res.getInt("CANT_LOTE_PRODUCCION");
                        registroSanitario=res.getString("REG_SANITARIO");
                        loteAsociado=res.getString("loteAsociado");
                        cantLoteAsociado=res.getInt("cantAsociado");
                        %>

<section class="main">
                         <div class="row"  style="margin-top:5px" >
                                <div class="large-12 medium-12 small-12 large-centered medium-centered small-centered columns" >

                                            <div class="row">
                                               <div class="large-12 medium-12 small-12 columns divHeaderClass" >
                                                       <label  class="inline">REGISTRO DE LIMPIEZA DE AMBIENTES</label>
                                                </div>
                                            </div>
                                            <div class="row" >
                                                
                                            <div  class="divContentClass large-12 medium-12 small-12 columns">
                                                  
                                                   <table style="width:96%;margin-top:2%" cellpadding="0px" cellspacing="0px">
                                                       <tr >
                                                           <td class="tableHeaderClass" style="text-align:center">
                                                               <span  class="textHeaderClass">Lote</span>
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
                                                               <span class="textHeaderClassBody"><%=(codLote+(loteAsociado.equals("")?"":"<br>"+loteAsociado))%></span>
                                                           </td>
                                                           <td class="tableCell" style="text-align:center;">
                                                               <span class="textHeaderClassBody"><%=(cantidadAmpollas+(loteAsociado.equals("")?"":"<br>"+cantLoteAsociado))%></span>
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
                                   <label  class="inline">REGISTRO DE LIMPIEZA DE AMBIENTES</label>
                            </div>
                        </div>
                        <div class="row" >

                        <div  class="divContentClass large-12 medium-12 small-12 columns" style="padding-top:12px;">
                        <span style="top:10px;font-weight:normal" class="textHeaderClassBody"><%=(indicacionesLimpiezaAmbientes)%></span>
                        <div class="row">
                            <div class="large-12 medium-12 small-12 large-centered medium-centered small-centered columns">
                                <table style="width:100%;margin-top:2%" id="dataLimpiezaSecciones" cellpadding="0px" cellspacing="0px">
                                            
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
                                System.out.println("consulta para cargar personal select "+consulta);
                                res=st.executeQuery(consulta);
                                personal="";
                                while(res.next())
                                {
                                    personal+="<option value='"+res.getString(1)+"'>"+res.getString(2)+"</option>";
                                }
                               
                                consulta="select sl.COD_SANITIZANTE_LIMPIEZA,sl.NOMBRE_SANITIZANTE_LIMPIEZA"+
                                        " from SANITIZANTES_LIMPIEZA sl where sl.COD_ESTADO_REGISTRO=1 order by sl.NOMBRE_SANITIZANTE_LIMPIEZA";
                                System.out.println("consulta cargar sanitizantes "+consulta);
                                res=st.executeQuery(consulta);
                                sanitizantesSelect="";
                                while(res.next())
                                {
                                    sanitizantesSelect+="<option value='"+res.getString("COD_SANITIZANTE_LIMPIEZA")+"'>"+res.getString("NOMBRE_SANITIZANTE_LIMPIEZA")+"</option>";
                                }
                                consulta="select m.COD_MAQUINA,m.NOMBRE_MAQUINA+'('+m.CODIGO+')' as nombreMaquina"+
                                         " from COMPONENTES_PROD_MAQUINARIA_LIMPIEZA cpm inner join MAQUINARIAS m on"+
                                        " cpm.COD_MAQUINA=m.COD_MAQUINA "+
                                        " where cpm.COD_COMPPROD='"+codCompProd+"'" +
                                        " and m.COD_TIPO_EQUIPO =2"+
                                        " order  by m.NOMBRE_MAQUINA desc";
                                System.out.println("consulta maquinarias");
                                res=st.executeQuery(consulta);
                                maquinariasSelect="<option value='0'>SECCION</option>";
                                while(res.next())
                                {
                                    maquinariasSelect+="<option value='"+res.getInt("COD_MAQUINA")+"'>"+res.getString("nombreMaquina")+"</option>";
                                }

                                 consulta="SELECT som.COD_SECCION_ORDEN_MANUFACTURA,som.NOMBRE_SECCION_ORDEN_MANUFACTURA"+
                                          " FROM SECCIONES_ORDEN_MANUFACTURA som  where som.COD_SECCION_ORDEN_MANUFACTURA in (2,6,7,8,9,10,11) ORDER BY som.NOMBRE_SECCION_ORDEN_MANUFACTURA";
                                System.out.println("consulta cargar secciones "+consulta);
                                res=st.executeQuery(consulta);
                                Statement stDetalle=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                ResultSet resDetalle=null;
                                int contador=0;
                                String innerHTMLDetalle="";
                                while(res.next())
                                {
                                    innerHTMLDetalle="";
                                    contador++;
                                    int codActividad=0;
                                    switch(res.getInt("COD_SECCION_ORDEN_MANUFACTURA"))
                                    {
                                        case 2:
                                            codActividad=codActividadPreparado;
                                            break;
                                        case 6:
                                            codActividad=codActividadGranulado;
                                            break;
                                        case 7:
                                            codActividad=codActividadSecado;
                                            break;
                                        case 8:
                                            codActividad=codActividadTamizado;
                                            break;
                                        case 9:
                                            codActividad=codActividadTableteado;
                                            break;
                                        case 10:
                                            codActividad=codActividadRecubrimiento;
                                            break;
                                        case 11:
                                            codActividad=codActividadBlisteado;
                                            break;
                                        default:
                                            codActividad=0;
                                            break;
                                    }
                                     consulta="select sppp.REGISTRO_CERRADO,sll.COD_MAQUINA,sll.COD_PERSONAL,sll.COD_SANITIZANTE_LIMPIEZA,"+
                                             " sll.LIMPIEZA_ORDINARIA,sll.LIMPIEZA_RADICAL,sppp.FECHA_INICIO,sppp.FECHA_FINAL"+
                                             " from SEGUIMIENTO_LIMPIEZA_LOTE_SECCIONES_MAQUINARIAS sll inner join"+
                                             " SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sppp on sll.COD_REGISTRO_ORDEN_MANUFACTURA=sppp.COD_REGISTRO_ORDEN_MANUFACTURA"+
                                             " and sll.COD_PERSONAL=sppp.COD_PERSONAL"+
                                             " WHERE sll.COD_SEGUIMIENTO_LIMPIEZA_LOTE='"+codSeguimientoLimpiezaLote+"'"+
                                             " and sppp.COD_COMPPROD='"+codCompProd+"'"+
                                             " and sppp.COD_LOTE_PRODUCCION='"+codLote+"'"+
                                             " and sppp.COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"'"+
                                             " and sppp.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"'"+
                                             " and sppp.COD_PROGRAMA_PROD='"+codprogramaProd+"'"+
                                             " and sppp.COD_ACTIVIDAD_PROGRAMA="+codActividad+
                                             (administrador?"": " and sll.COD_PERSONAL="+codPersonal)+
                                             " order by sppp.FECHA_INICIO";
                                     System.out.println("consulta detalle "+consulta);
                                     resDetalle=stDetalle.executeQuery(consulta);
                                     while(resDetalle.next())
                                     {
                                         contador++;
                                         innerHTMLDetalle+="<tr onclick=\"seleccionarFila(this);\">" +
                                                 "<td class='tableCell'  style='text-align:center'>" +
                                                 "<select "+(administrador?"disabled":"")+" id='codSeccion"+contador+"'>"+maquinariasSelect+"</select>" +
                                                 "<script>codSeccion"+contador+".value='"+resDetalle.getInt("COD_MAQUINA")+"';</script>"+
                                                 "</td>"+
                                                " <td class='tableCell' style='text-align:center;'>" +
                                                " <select "+(administrador?"disabled":"")+" id='s"+contador+"'>"+personal+"</select>"+
                                                "<script>s"+contador+".value='"+resDetalle.getInt("COD_PERSONAL")+"';</script></td>"+
                                                " <td class='tableCell' style='text-align:center;'>" +
                                                " <select "+(administrador?"disabled":"")+" id='codSaniSeccion"+contador+"'>"+sanitizantesSelect+"</select>" +
                                                "<script>codSaniSeccion"+contador+".value='"+resDetalle.getString("COD_SANITIZANTE_LIMPIEZA")+"';</script></td>"+
                                                " <td class='tableCell'  style='text-align:center;'>" +
                                                " <input onclick='onChangeEstado(this)' "+(administrador?"disabled":"")+" type='checkbox' style='width:20px;height:20px' "+(resDetalle.getInt("LIMPIEZA_RADICAL")>0?"checked":"")+
                                                " ></td><td class='tableCell'  style='text-align:center;'><input onclick='onChangeEstado(this)' "+(administrador?"disabled":"")+" type='checkbox' style='width:20px;height:20px'"+(resDetalle.getInt("LIMPIEZA_ORDINARIA")>0?"checked":"")+
                                                " ></td><td class='tableCell'  align='center'>"+
                                                (codEstadoHoja==3?" <input "+(administrador?"disabled":"")+" type='text' value='"+(resDetalle.getDate("FECHA_INICIO")!=null?sdfDias.format(resDetalle.getDate("FECHA_INICIO")):"")+"' size='10' id='fecha"+contador+"' onclick='seleccionarDatePickerJs(this)'/>":
                                                "<span class='textHeaderClassBodyNormal'>"+sdfDias.format(resDetalle.getTimestamp("FECHA_INICIO"))+"</span>")+
                                                " </td>" +
                                                " <td class='tableCell' align='center'>" +
                                                (codEstadoHoja==3?" <input "+(administrador?"disabled":"")+" type='text' onclick='seleccionarHora(this);' id='dataSeccIni"+contador+"'  value='"+(resDetalle.getTimestamp("FECHA_INICIO")!=null?sdfHoras.format(resDetalle.getTimestamp("FECHA_INICIO")):"")+"' style='width:6em;'>":
                                                " <span class='textHeaderClassBodyNormal'>"+sdfHoras.format(resDetalle.getTimestamp("FECHA_INICIO"))+"</span>")+
                                                "</td>" +
                                                " <td class='tableCell' align='center'>" +
                                                (codEstadoHoja==3?" <input "+(administrador?"disabled":"")+" type='text'  onclick='seleccionarHora(this);' id='dataSeccFin"+contador+"' value='"+(resDetalle.getTimestamp("FECHA_FINAL")!=null?sdfHoras.format(resDetalle.getTimestamp("FECHA_FINAL")):"")+"' style='width:6em;'>":
                                                "<button "+(administrador?"disabled":"")+" class='"+(resDetalle.getInt("REGISTRO_CERRADO")>0?"buttonFinishActive":"buttonFinish")+"' onclick=\"calcularHorasGeneral(this,'"+sdfHoras.format(resDetalle.getTimestamp("FECHA_INICIO"))+"')\">Terminar</button>"+
                                                "<span class='textHeaderClassBodyNormal'>"+sdfHoras.format(resDetalle.getTimestamp("FECHA_FINAL"))+"</span>")+
                                                "</td></tr>";
                                     }
                                    out.println("<tr><td class='primerafila"+(innerHTMLDetalle.equals("")?"":"Select")+" tableHeaderClass'><input class='checkBox' onclick='seleccionarLimpiezaArea(this)' "+(innerHTMLDetalle.equals("")?"":"checked")+" type='checkbox'/><span class='textHeaderClass textCheck'>LIMPIEZA PARA "+res.getString("NOMBRE_SECCION_ORDEN_MANUFACTURA")+"</span>" +
                                                "</td></tr><tr><td class='detalleFila' "+(innerHTMLDetalle.equals("")?"":"style='display:table-cell;opacity:1'")+" align='center'><input type='hidden' value='"+res.getInt("COD_SECCION_ORDEN_MANUFACTURA")+"'/><table id='tablaSeccion"+res.getInt("COD_SECCION_ORDEN_MANUFACTURA")+"'><tr><td class='tableHeaderClass' rowspan='3' style='text-align:center' >"+
                                                " <span class='textHeaderClass'>SECCION</span></td>"+
                                                " <td class='tableHeaderClass' rowspan='3' style='text-align:center'>"+
                                                " <span class='textHeaderClass'>NOMBRE DE LA PERSONA<BR>RESPONSABLE DE LA<BR>LIMPIEZA </span></td>"+
                                                " <td class='tableHeaderClass' colspan='3'  style='text-align:center' ><span class='textHeaderClass'>TIPO DE LIMPIEZA</span></td>"+
                                                " <td class='tableHeaderClass' rowspan='3'  style='padding-left:22px;padding-right:22px; text-align:center' >"+
                                                " <span class='textHeaderClass'>FECHA</span></td>"+
                                                " <td class='tableHeaderClass' rowspan='3'  style='padding-left:22px;padding-right:22px; text-align:center' >"+
                                                " <span class='textHeaderClass'>HORA<br>INICIO</span></td>"+
                                                " <td class='tableHeaderClass' rowspan='3'  style='padding-left:22px;padding-right:22px; text-align:center' >"+
                                                " <span class='textHeaderClass'>HORA<br>FINAL</span></td></tr>"+
                                                " <tr><td class='tableHeaderClass' rowspan='2' style='text-align:center' >"+
                                                " <span class='textHeaderClass'>Sanitizante</span></td>"+
                                                " <td class='tableHeaderClass' colspan='2' style='text-align:center' >"+
                                                " <span class='textHeaderClass'>Limpieza</span></td></tr>"+
                                                " <tr><td class='tableHeaderClass'  style='text-align:center' >"+
                                                " <span class='textHeaderClass'>Radical</span></td>"+
                                                " <td class='tableHeaderClass'   style='text-align:center' ><span class='textHeaderClass'>Ordinaria</span></td></tr>"+innerHTMLDetalle+"</table>" +
                                                " <div class='row'>" +
                                                " <div class='large-5 medium-5 small-4 columns'>&nbsp;</div>"+
                                                " <div class='large-1 medium-1 small-2 columns'><button class='small button succes radius buttonMas'  onclick='masLimpiezaSecciones("+res.getInt("COD_SECCION_ORDEN_MANUFACTURA")+")'>+</button></div>"+
                                                " <div class='large-1 medium-1 small-2 columns'><button class='small button succes radius buttonMenos'  onclick=\"eliminarRegistroTabla('tablaSeccion"+res.getInt("COD_SECCION_ORDEN_MANUFACTURA")+"')\">-</button></div>"+
                                                " <div class='large-5 medium-5 small-4 columns' >&nbsp;</div></div></td></tr>");
                                }
                                out.println("<script>sanitizantesSelect=\""+sanitizantesSelect+"\";" +
                                            "seccionesSelect=\""+seccionesSelect+"\";" +
                                            "operariosLimpieza=\""+personal+"\";" +
                                            "fechaRegistroNuevo=\""+sdfDias.format(new Date())+"\";" +
                                            "codEstadoHojaGeneral="+codEstadoHoja+";"+
                                            "maquinariasSelect=\""+maquinariasSelect+"\"</script>");
                                                             %>
                              </table>
                                  
                            </div>
                        </div>
                         
                        
                     <div class="row">
                                   <div class="large-12 medium-12 small-12 columns divHeaderClass" >
                                           <label  class="inline">REGISTRO DE LIMPIEZA Y ESTERILIZACION DE UTENSILIOS</label>
                                    </div>
                        </div>
                     <div style="margin-top:12px">
                            <span style="font-weight:normal" class="textHeaderClassBody"><%=(indicacionesLimpiezaUtencilios)%></span>
                     </div>
                      <center>
                          <table style="width:80%;margin-top:12px;border-bottom:solid #a80077 1px;" id="dataLimpiezaUtensilios" cellpadding="0px" cellspacing="0px" >

                        <%
                        
                        out.println("<tr >"+
                                    " <td class='tableHeaderClass'   style='text-align:center'><span class='textHeaderClass'>UTENSILIO</span></td>"+
                                    " <td class='tableHeaderClass'  style='text-align:center'><span class='textHeaderClass'>CODIGO</span></td></tr>");
                                    
                        consulta="SELECT m.NOMBRE_MAQUINA,m.COD_MAQUINA,m.CODIGO"+
                                " FROM COMPONENTES_PROD_MAQUINARIA_LIMPIEZA cpml"+
                                " inner join MAQUINARIAS m on cpml.COD_MAQUINA = m.COD_MAQUINA" +
                                " where m.COD_TIPO_EQUIPO=8 and  cpml.COD_COMPPROD = '"+codCompProd+"' order by m.NOMBRE_MAQUINA ";
                        System.out.println("consulta cargar segui utensilios "+consulta);
                        res=st.executeQuery(consulta);
                        while(res.next())
                        {
                            %>

                                    <tr>
                                      <td class="tableCell"   style="text-align:center;">
                                          <input type="hidden"  value="<%=res.getInt("COD_MAQUINA")%>"/>
                                           <span class="textHeaderClassBody" style="font-weight:normal"><%=res.getString("NOMBRE_MAQUINA")%></span>
                                       </td>
                                       <td class="tableCell"  style="text-align:center;">
                                           <span class="textHeaderClassBody" style="font-weight:normal"><%=res.getString("CODIGO")%></span>
                                       </td>
                                    </tr>
                                        <%
                        }

                        %>
                    </table>
                          <table style="width:100%;margin-top:8px" id="dataTiemEsterilizacionUtensilios" cellpadding="0px" cellspacing="0px">
                            <tr>
                               <td class="tableHeaderClass"  style="text-align:center" colspan="7">
                                   <span class="textHeaderClass">Responsable de Esterilizacion de Utensilios</span>
                               </td>
                            </tr>
                               <tr>
                                                <td class='tableHeaderClass' rowspan='3' style='text-align:center'>
                                                 <span class='textHeaderClass'>NOMBRE DE LA PERSONA<BR>RESPONSABLE DE LA<BR>LIMPIEZA </span></td>
                                                 <td class='tableHeaderClass' colspan='3'  style='text-align:center' ><span class='textHeaderClass'>TIPO DE LIMPIEZA</span></td>
                                                 <td class='tableHeaderClass' rowspan='3'  style='padding-left:22px;padding-right:22px; text-align:center' >
                                                 <span class='textHeaderClass'>FECHA</span></td>
                                                 <td class='tableHeaderClass' rowspan='3'  style='padding-left:22px;padding-right:22px; text-align:center' >
                                                 <span class='textHeaderClass'>HORA<br>INICIO</span></td>
                                                 <td class='tableHeaderClass' rowspan='3'  style='padding-left:22px;padding-right:22px; text-align:center' >
                                                 <span class='textHeaderClass'>HORA<br>FINAL</span></td></tr>
                                                 <tr><td class='tableHeaderClass' rowspan='2' style='text-align:center' >
                                                 <span class='textHeaderClass'>Sanitizante</span></td>
                                                 <td class='tableHeaderClass' colspan='2' style='text-align:center' >
                                                 <span class='textHeaderClass'>Limpieza</span></td></tr>
                                                 <tr><td class='tableHeaderClass'  style='text-align:center' >
                                                 <span class='textHeaderClass'>Radical</span></td>
                                                <td class='tableHeaderClass'   style='text-align:center' ><span class='textHeaderClass'>Ordinaria</span></td></tr>
                               <%
                                consulta="select sll.COD_PERSONAL,sll.COD_SANITIZANTE_LIMPIEZA,sppp.REGISTRO_CERRADO,"+
                                             " sll.LIMPIEZA_ORDINARIA,sll.LIMPIEZA_RADICAL,sppp.FECHA_INICIO,sppp.FECHA_FINAL"+
                                             " from SEGUIMIENTO_LIMPIEZA_LOTE_ESTERILIZACION sll inner join"+
                                             " SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sppp on sll.COD_REGISTRO_ORDEN_MANUFACTURA=sppp.COD_REGISTRO_ORDEN_MANUFACTURA"+
                                             " and sll.COD_PERSONAL=sppp.COD_PERSONAL"+
                                             " WHERE sll.COD_SEGUIMIENTO_LIMPIEZA_LOTE='"+codSeguimientoLimpiezaLote+"'"+
                                             " and sppp.COD_COMPPROD='"+codCompProd+"'"+
                                             " and sppp.COD_LOTE_PRODUCCION='"+codLote+"'"+
                                             " and sppp.COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"'"+
                                             " and sppp.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"'"+
                                             " and sppp.COD_PROGRAMA_PROD='"+codprogramaProd+"'"+
                                             " and sppp.COD_ACTIVIDAD_PROGRAMA="+codActividadEsterilizacion+
                                             (administrador?"":" and sll.COD_PERSONAL="+codPersonal)+
                                             " order by sppp.FECHA_INICIO";
                                System.out.println("consulta detalle esterilizacion "+consulta);
                                resDetalle=st.executeQuery(consulta);
                                while(resDetalle.next())
                                {
                                    out.println("<tr onclick=\"seleccionarFila(this);\">" +
                                                 " <td class='tableCell' style='text-align:center;'>" +
                                                " <select "+(administrador?"disabled":"")+" id='s"+contador+"'>"+personal+"</select>"+
                                                "<script>s"+contador+".value='"+resDetalle.getInt("COD_PERSONAL")+"';</script></td>"+
                                                " <td class='tableCell' style='text-align:center;'>" +
                                                " <select "+(administrador?"disabled":"")+" id='codEstSeccion"+contador+"'>"+sanitizantesSelect+"</select>" +
                                                "<script>codEstSeccion"+contador+".value='"+resDetalle.getString("COD_SANITIZANTE_LIMPIEZA")+"';</script></td>"+
                                                " <td class='tableCell'  style='text-align:center;'>" +
                                                " <input onclick='onChangeEstado(this)' "+(administrador?"disabled":"")+" type='checkbox' style='width:20px;height:20px' "+(resDetalle.getInt("LIMPIEZA_RADICAL")>0?"checked":"")+
                                                " ></td><td class='tableCell'  style='text-align:center;'><input onclick='onChangeEstado(this)' "+(administrador?"disabled":"")+" type='checkbox' style='width:20px;height:20px'"+(resDetalle.getInt("LIMPIEZA_ORDINARIA")>0?"checked":"")+
                                                " ></td>" +
                                                "<td class='tableCell'  align='center'>"+
                                                (codEstadoHoja==3?" <input "+(administrador?"disabled":"")+" type='text' value='"+(resDetalle.getDate("FECHA_INICIO")!=null?sdfDias.format(resDetalle.getDate("FECHA_INICIO")):"")+"' size='10' id='fecha"+contador+"' onclick='seleccionarDatePickerJs(this)'/>":
                                                "<span class='textHeaderClassBodyNormal'>"+sdfDias.format(resDetalle.getTimestamp("FECHA_INICIO"))+"</span>")+
                                                " </td>" +
                                                " <td class='tableCell'  align='center'>" +
                                                (codEstadoHoja==3?"<input "+(administrador?"disabled":"")+" type='text' onclick='seleccionarHora(this);' id='dataSeccIni"+contador+"'  value='"+(resDetalle.getTimestamp("FECHA_INICIO")!=null?sdfHoras.format(resDetalle.getTimestamp("FECHA_INICIO")):"")+"' style='width:6em;'>":
                                                    " <span class='textHeaderClassBodyNormal'>"+sdfHoras.format(resDetalle.getTimestamp("FECHA_INICIO"))+"</span>")+
                                                "</td>" +
                                                " <td class='tableCell' align='center'>" +
                                                (codEstadoHoja==3?"<input "+(administrador?"disabled":"")+" type='text'  onclick='seleccionarHora(this);' id='dataSeccFin"+contador+"' value='"+(resDetalle.getTimestamp("FECHA_FINAL")!=null?sdfHoras.format(resDetalle.getTimestamp("FECHA_FINAL")):"")+"' style='width:6em;'>":
                                                "<button "+(administrador?"disabled":"")+" class='"+(resDetalle.getInt("REGISTRO_CERRADO")>0?"buttonFinishActive":"buttonFinish")+"' onclick=\"calcularHorasGeneral(this,'"+sdfHoras.format(resDetalle.getTimestamp("FECHA_INICIO"))+"')\">Terminar</button>"+
                                                "<span class='textHeaderClassBodyNormal'>"+sdfHoras.format(resDetalle.getTimestamp("FECHA_FINAL"))+"</span>")+
                                                "</td></tr>");
                                }
                               %>
                    </table>
                     <div class="row">
                             <div class="large-5 medium-5 small-4 columns" style="">&nbsp;</div>
                              <div class="large-1 medium-1 small-2 columns">
                                    <button class="small button succes radius buttonMas" <%=(administrador?"disabled":"")%> onclick="masEsterilizacionUtensilios();">+</button>
                              </div>
                              <div class="large-1 medium-1 small-2 columns">
                                    <button class="small button succes radius buttonMenos" <%=(administrador?"disabled":"")%> onclick="eliminarRegistroTabla('dataTiemEsterilizacionUtensilios')">-</button>
                              </div>
                              <div class="large-5 medium-5 small-4 columns" style="">&nbsp;</div>
                       </div>

                     
                     <input type="hidden" id="cerrado" value="<%=codPersonalVerifica%>">
                    <%
                    if(administrador)
                    {
                        consulta="select (p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL+' '+p.nombre2_personal)"+
                                 " from PERSONAL p where p.COD_PERSONAL='"+(Integer.valueOf(codPersonalVerifica)>0?codPersonalVerifica:codPersonal)+"'";
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
                                   <span >Nombre de la persona que verifica:</span>
                               </td>
                                <td style="border-right:solid #a80077 1px;text-align:left">
                                    <span><%=(nombreUsuario)%></span>
                                    <input type="hidden" value="<%=codPersonalVerifica%>"/>
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
                                    <input type="text" id="observacion" value="<%=(observaciones)%>"/>
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
                                        <button class="small button succes radius buttonAction" onclick="guardarLimpieza();" >Guardar</button>
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
        <input type="hidden" id="codSeguimientoLimpiezaLote" value="<%=(codSeguimientoLimpiezaLote)%>">
        <input type="hidden" id="codFormulaMaestra" value="<%=(codFormulaMaestra)%>">
        <input type="hidden" id="codCompProd" value="<%=(codCompProd)%>"/>
        <input type="hidden" id="codTipoProgramaProd" value="<%=(codTipoProgramaProd)%>"/>
        <input type="hidden" id="codActividadBlisteado" value="<%=(codActividadBlisteado)%>"/>
        <input type="hidden" id="codActividadGranulado" value="<%=(codActividadGranulado)%>"/>
        <input type="hidden" id="codActividadPreparado" value="<%=(codActividadPreparado)%>"/>
        <input type="hidden" id="codActividadRecubrimiento" value="<%=(codActividadRecubrimiento)%>"/>
        <input type="hidden" id="codActividadSecado" value="<%=(codActividadSecado)%>"/>
        <input type="hidden" id="codActividadTableteado" value="<%=(codActividadTableteado)%>"/>
        <input type="hidden" id="codActividadTamizado" value="<%=(codActividadTamizado)%>"/>
        <input type="hidden" id="codActividadEsterilizacion" value="<%=(codActividadEsterilizacion)%>"/>
        </section>
        
    </body>
    <script src="../../reponse/js/dataPickerJs.js"></script>
    <script src="../../reponse/js/timePickerJs.js"></script>
    <script>iniciarDatePicker('<%=(sdfDias.format(new Date()))%>');loginHoja.verificarHojaCerrada('cerrado', admin,'codProgramaProd','codLoteSeguimiento',1,<%=(codEstadoHoja)%>);</script>
</html>
