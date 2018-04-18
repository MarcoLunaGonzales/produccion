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
       <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
       <script src="../js/general.js"></script>
       <style>
           .panelSuper{
                padding: 50px;
                /*background-image : url(../img/proceso.gif);*/
                background-color: #cccccc;
                top: 0px;
                /*z-index: 2;*/
                left: 0px;
                position: absolute;
                border :2px solid #3C8BDA;
                width :900px;
                height: 100%;
                filter: alpha(opacity=70);
                opacity: 0.8;
            }
           .tablaIndirectos
           {
               margin-top:1em;
               border-top:1px solid #cccccc;
               border-left:1px solid #cccccc;
           }
           .tablaIndirectos tr td
           {
               border-bottom:1px solid #cccccc;
               border-right:1px solid #cccccc;
               padding:0.4em;
           }
           .tablaIndirectos thead tr td
           {
               background-image:none;
                background-color:#9d5f9f;
                font-weight:bold;
                color:white;
                font-weight:bold;
           }
           a{
               cursor:hand;
           }
           .tablaCabecera
           {
                border:1px solid #cccccc;
           }
           .tablaCabecera tr td
           {
               padding:0.4em;
           }
           .tablaCabecera thead tr td
           {
                background-image:none;
                background-color:#9d5f9f;
                font-weight:bold;
                color:white;
                font-weight:bold;
           }
           .tablaCabecera tbody tr td
           {
               text-align:left;
           }
       </style>
<script type="text/javascript">
    var personalSelect="";
    var codProgramaProd;
    var codActividad;
    var codAreaEmpresa;
    var fechaSistema;
    var fechaLimite;
    var codLote;
    var codFormulaMaestra;
    var codTipoProgramaProd;
    var codCompProd;
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
    function validarRegistroEntero(inputNumero)
    {
      inputNumero.value=(inputNumero.value==''?'0':inputNumero.value);
      inputNumero.style.backgroundColor='#ffffff';
       if (isNaN(inputNumero.value)){
           inputNumero.style.backgroundColor='#F08080';
            inputNumero.focus();
            alert("No se reconoce el numero "+inputNumero.value);
            return false;
        }
        else{
            if (inputNumero.value % 1 == 0) {
                return true;
            }
            else{
                inputNumero.style.backgroundColor='#F08080';
                inputNumero.focus();
                alert("Solo se permiten numeros enteros");
                return false;
            }
        }
        alert("Numero invalido")
        inputNumero.style.backgroundColor='#F08080';
        inputNumero.focus();
        return false;
    }

    function validarRegistroNumero(inputNumero)
    {
      inputNumero.style.backgroundColor='#ffffff';
       if (isNaN(inputNumero.value)){
           inputNumero.style.backgroundColor='#F08080';
            inputNumero.focus();
            alert ("Solo se permiten numeros\nNumero no valido: "+inputNumero.value);
            return false;
        }
        else{
           return true;
        }
        alert("Numero invalido")
        inputNumero.style.backgroundColor='#F08080';
        inputNumero.focus();
        return false;
    }
    function validarHorasNoNegativas(celdaSpan)
    {
        celdaSpan.style.backgroundColor='#ffffff';
        if(parseFloat(celdaSpan.innerHTML)<=0)
        {
            alert("Las horas trabajadas no pueden ser menor o igual a cero");
            celdaSpan.style.backgroundColor='#F08080';
            celdaSpan.focus();
            return false;
        }
        return true;
    }
    function guardarTiempos()
    {
        var tablaSeguimiento = document.getElementById("seguimientoIndirectos");
        var datosSeguimiento=new Array();
        for(var i=0;i<tablaSeguimiento.rows.length;i++)
        {
            if(tablaSeguimiento.rows[i].cells[0].getElementsByTagName("input").length>0)
            {
                if(validarFechaRegistro(tablaSeguimiento.rows[i].cells[2].getElementsByTagName("input")[0])&&
                validarHoraRegistro(tablaSeguimiento.rows[i].cells[3].getElementsByTagName("input")[0])&&
                validarHoraRegistro(tablaSeguimiento.rows[i].cells[4].getElementsByTagName("input")[0])&&
                validarRegistroEntero(tablaSeguimiento.rows[i].cells[6].getElementsByTagName("input")[0])&&
                validarRegistroNumero(tablaSeguimiento.rows[i].cells[7].getElementsByTagName("input")[0])&&
                validarHorasNoNegativas(tablaSeguimiento.rows[i].cells[5].getElementsByTagName("span")[0])&&
                validarRegistroEntero(tablaSeguimiento.rows[i].cells[8].getElementsByTagName("input")[0])
                )
                {
                    datosSeguimiento[datosSeguimiento.length]=tablaSeguimiento.rows[i].cells[1].getElementsByTagName("select")[0].value;
                    datosSeguimiento[datosSeguimiento.length]=tablaSeguimiento.rows[i].cells[2].getElementsByTagName("input")[0].value;
                    datosSeguimiento[datosSeguimiento.length]=tablaSeguimiento.rows[i].cells[3].getElementsByTagName("input")[0].value;
                    datosSeguimiento[datosSeguimiento.length]=tablaSeguimiento.rows[i].cells[4].getElementsByTagName("input")[0].value;
                    datosSeguimiento[datosSeguimiento.length]=tablaSeguimiento.rows[i].cells[5].getElementsByTagName("span")[0].innerHTML;
                    datosSeguimiento[datosSeguimiento.length]=tablaSeguimiento.rows[i].cells[6].getElementsByTagName("input")[0].value;
                    datosSeguimiento[datosSeguimiento.length]=tablaSeguimiento.rows[i].cells[7].getElementsByTagName("input")[0].value;
                    datosSeguimiento[datosSeguimiento.length]=tablaSeguimiento.rows[i].cells[8].getElementsByTagName("input")[0].value;
                }
                else
                {
                    return false;
                }
            }
        }
        /*if(datosSeguimiento.length<=1)
        {
            alert('No existen registros para guardar');
            document.getElementById('panelsuper').style.visibility='hidden';
            document.getElementById("imgLoad").style.visibility='hidden';
            return false;
        }*/
        ajax=nuevoAjax();
        var b=document.getElementById('panelsuper');
        b.style.visibility='visible';
        b.style.width=window.document.body.scrollWidth;
        b.style.height=window.document.body.scrollHeight;
        document.getElementById("imgLoad").style.visibility='visible';
        ajax.open("POST","ajaxGuardarActividadesDirectas.jsp?codProgramaProd="+codProgramaProd+
             "&codActividad="+ codActividad+
             "&codLote="+ codLote+
             "&codCompProd="+ codCompProd+
             "&codFormulaMaestra="+ codFormulaMaestra+
             "&codTipoProgramaProd="+ codTipoProgramaProd+
             "&fechaLimite="+fechaLimite+
             "&noCache="+(new Date()).getTime().toString(),true);
                 ajax.onreadystatechange=function(){
                    if (ajax.readyState==4) {
                        if(ajax.responseText==null || ajax.responseText=='')
                        {
                            alert('No se puede conectar con el servidor, verfique su conexión a internet');
                            document.getElementById('panelsuper').style.visibility='hidden';
                            document.getElementById("imgLoad").style.visibility='hidden';
                            return false;
                        }
                        if(parseInt(ajax.responseText.split("\n").join(""))=='1')
                        {
                            alert('Se registraron los tiempos directos');
                            window.location.href='navegador_actividades_programa.jsf?cancel='+(new Date()).getTime().toString();
                            return true;
                        }
                        else
                        {
                            alert(ajax.responseText.split("\n").join(""));
                            document.getElementById('panelsuper').style.visibility='hidden';
                            document.getElementById("imgLoad").style.visibility='hidden';
                            return false;
                        }
                    }
                }
                ajax.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
                ajax.send("dataSeguimiento="+datosSeguimiento);
               
    }
    onerror=errorMessaje;
    function errorMessaje()
    {
        alert('error de javascript');
    }
    function validarHoraRegistro(input)
    {

        var areglo=input.value.split(":");
        input.style.backgroundColor='#ffffff';
        if(areglo.length!=2)
        {
            alert('Formato de hora incorrecto');
            input.style.backgroundColor='#F08080';
            input.focus();
            return false;
        }
        
        if(isNaN(areglo[0])||isNaN(areglo[1])||(areglo[0].length!=2)||(areglo[1].length!=2))
        {
            alert('Hora no permitida');
            input.style.backgroundColor='#F08080';
            input.focus();
            return false;
        }
        if((parseInt(areglo[0])<0)||(parseInt(areglo[0])>23))
        {
            alert('El rango de horas permitido es de 0 a 23');
            input.style.backgroundColor='#F08080';
            input.focus();
            return false;
        }
        if((parseInt(areglo[1])<0)||(parseInt(areglo[1])>59))
        {
            alert('El rango de minutos permitido es de 0 a 59');
            input.style.backgroundColor='#F08080';
            input.focus();
            return false;
        }

        return true;

    }
    function validarFechaRegistro(input)
    {
        input.style.backgroundColor='#ffffff';
        var registrar = true;
        if (input.value == ""){
            alert("Formato de Fecha Incorrecto");
            input.style.backgroundColor='#F08080';
            input.focus();
            return false;
        }
        if (input.value != ""){
        registrar = registrar && (valAno(input));
        registrar = registrar && (valMes(input));
        registrar = registrar && (valDia(input));
        registrar = registrar && (valSep(input));
        if (!registrar){
            alert("Formato de Fecha Incorrecto");
            input.style.backgroundColor='#F08080';
            input.focus();
            return false;
        }
      }
      var fechaArray=input.value.split("/");
      var fechaInsert=new Date(fechaArray[2],parseInt(fechaArray[1])-1,fechaArray[0],0, 0, 0, 0);
      fechaArray=fechaLimite.split("/");
      var fechaInicio=new Date(fechaArray[2],parseInt(fechaArray[1])-1,fechaArray[0],0, 0, 0, 0);
      //fechaInicio.setDate(fechaInicio.getDate()-20);
      fechaArray=fechaSistema.split("/");
      var fechaFin=new Date(fechaArray[2],parseInt(fechaArray[1])-1,fechaArray[0],0, 0, 0, 0);
      if(fechaInsert<fechaInicio)
      {
            alert("No se puede registrar un fecha fuera inferior al "+fechaLimite);
            input.style.backgroundColor='#F08080';
            input.focus();
            return false;
      }
      if(fechaInsert>fechaFin)
      {
            alert("No se puede realizar registros superiores al dia de hoy");
            input.style.backgroundColor='#F08080';
            input.focus();
            return false;
      }
      return true;
    }
    function getNumeroDehoras(fechaIni,fechaFin)
    {
        if(fechaIni.length==16&&fechaFin.length==16)
        {
            var fec=fechaIni.split(" ");
            var d1=fec[0].split("/");
            var h1=fec[1].split(":");
            var dat1 = new Date(d1[2], parseFloat(d1[1]), parseFloat(d1[0]),parseFloat(h1[0]),parseFloat(h1[1]),0);

             var de2 = fechaFin.split(" ");

             var d2=de2[0].split("/");
             var h2=de2[1].split(":");

             var dat2 = new Date(d2[2], parseFloat(d2[1]), parseFloat(d2[0]),parseFloat(h2[0]),parseFloat(h2[1]),0);
             var fin = dat2.getTime() - dat1.getTime();
             var dias=0;
             if(dat1!='NaN'&& dat2!='Nan')
             {
                dias =redondeo2decimales(fin / (1000 * 60 * 60));
             }
           return dias;
        }
        return 0;
    }
    function redondeo2decimales(numero)
    {
            var original=parseFloat(numero);
            var result=Math.round(original*100)/100 ;
            return result;
    }
    function calcularHorasHombre(celda)
    {
        var fila=celda.parentNode.parentNode;
        
        fila.cells[5].getElementsByTagName("span")[0].innerHTML=
        getNumeroDehoras(
        (fila.cells[2].getElementsByTagName("input")[0].value+' '+fila.cells[3].getElementsByTagName("input")[0].value),
        (fila.cells[2].getElementsByTagName("input")[0].value+' '+fila.cells[4].getElementsByTagName("input")[0].value))
    }
    function getHoraActualGeneralString()
    {
        var a=new Date();
        return ((a.getHours()>9?"":"0")+a.getHours()+":"+(a.getMinutes()>9?"":"0")+a.getMinutes());
    }

    function agregarSeguimiento()
    {
       var table = document.getElementById("seguimientoIndirectos").getElementsByTagName("tbody")[0];
       var rowCount = table.rows.length;
       var row = table.insertRow(rowCount);
       var celdaChecked = row.insertCell(0);
       var inputChecked=document.createElement("input");
       inputChecked.type='checkbox';
       celdaChecked.appendChild(inputChecked);
       var celdaSelect=row.insertCell(1);
       var selectNombre = document.createElement("select");
       selectNombre.className='inputText';
       var options=personalSelect.split('&&&');
       for(var i=0;i<options.length;i+=2)
       {
           selectNombre.options[selectNombre.options.length]=new Option(options[i+1],parseInt(options[i]));
       }
       celdaSelect.appendChild(selectNombre);
       var celdaFecha=row.insertCell(2);
       var inputFecha=document.createElement("input");
       inputFecha.type='text';
       inputFecha.size='8';
       inputFecha.className='inputText'
       inputFecha.value=fechaSistema
       celdaFecha.appendChild(inputFecha);

       var celdaHoraInicio=row.insertCell(3);
       var inputHoraInicio=document.createElement("input");
       inputHoraInicio.type='text';
       inputHoraInicio.className='inputText';
       inputHoraInicio.size='5';
       inputHoraInicio.value=getHoraActualGeneralString();
       inputHoraInicio.onkeyup=function(){calcularHorasHombre(this);};
       celdaHoraInicio.appendChild(inputHoraInicio);

       var celdaHoraFinal=row.insertCell(4);
       var inputHoraFinal=document.createElement("input");
       inputHoraFinal.type='text';
       inputHoraFinal.size='5';
       inputHoraFinal.className='inputText';
       inputHoraFinal.value=getHoraActualGeneralString();
       inputHoraFinal.onkeyup=function(){calcularHorasHombre(this);};
       celdaHoraFinal.appendChild(inputHoraFinal);
       
       var celdaHorasHombre=row.insertCell(5);
       var spanHorasHombre=document.createElement("span");
       spanHorasHombre.innerHTML='0.00';
       spanHorasHombre.className='outputText2';
       celdaHorasHombre.appendChild(spanHorasHombre);

       var celdaCantidadProducida=row.insertCell(6);
       var inputCantidadProducidad=document.createElement("input");
       inputCantidadProducidad.type='text';
       inputCantidadProducidad.className='inputText';
       inputCantidadProducidad.size='5';
       inputCantidadProducidad.value='0';
       inputCantidadProducidad.style.textAlign='center';
       celdaCantidadProducida.appendChild(inputCantidadProducidad);

       var celdaHorasExtra=row.insertCell(7);
       var inputHorasExtra=document.createElement("input");
       inputHorasExtra.type='text';
       inputHorasExtra.className='inputText';
       inputHorasExtra.size='5';
       inputHorasExtra.value='0.0';
       inputHorasExtra.style.textAlign='center';
       celdaHorasExtra.appendChild(inputHorasExtra);


       var celdaCantidadProducidaExtra=row.insertCell(8);
       var inputCantidadProducidaExtra=document.createElement("input");
       inputCantidadProducidaExtra.type='text';
       inputCantidadProducidaExtra.className='inputText';
       inputCantidadProducidaExtra.size='5';
       inputCantidadProducidaExtra.value='0';
       inputCantidadProducidaExtra.style.textAlign='center';
       celdaCantidadProducidaExtra.appendChild(inputCantidadProducidaExtra);
       celdaSelect.focus();
    }
    function eliminarRegistro()
    {
        var tabla = document.getElementById("seguimientoIndirectos");
        for(var i=(tabla.rows.length-1);i>=1;i--)
        {
            if(tabla.rows[i].cells[0].getElementsByTagName("input").length>0)
            {
                if(tabla.rows[i].cells[0].getElementsByTagName("input")[0].checked)
                {
                    tabla.deleteRow(i);
                }
            }
        }
    }
</script>


</head>
    <body  >
        <center>
  <%
  String codAreaEmpresa=request.getParameter("codAreaEmpresa");
  String codProgramaProd=request.getParameter("codProgramaProd");
  String codFormulaMaestra=request.getParameter("codFormulaMaestra");
  String codCompProd=request.getParameter("codCompProd");
  String codLote=request.getParameter("codLote");
  String codTipoProgramaProd=request.getParameter("codTipoProgramaProd");
  String codActividadFm=request.getParameter("codActividadFm");
  Connection con=null;
  try
  {
      String consulta="select pp.COD_LOTE_PRODUCCION,cp.nombre_prod_semiterminado,tpp.NOMBRE_TIPO_PROGRAMA_PROD" +
                     " ,ppp.NOMBRE_PROGRAMA_PROD,cp.COD_AREA_EMPRESA,cp.COD_FORMA"+
                     " from PROGRAMA_PRODUCCION pp inner join COMPONENTES_PROD cp on cp.COD_COMPPROD=pp.COD_COMPPROD"+
                     " inner join FORMULA_MAESTRA fm on fm.COD_FORMULA_MAESTRA=pp.COD_FORMULA_MAESTRA"+
                     " inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD" +
                     " inner join PROGRAMA_PRODUCCION_PERIODO ppp on pp.COD_PROGRAMA_PROD=ppp.COD_PROGRAMA_PROD"+
                     " where pp.COD_LOTE_PRODUCCION='"+codLote+"' and pp.COD_PROGRAMA_PROD='"+codProgramaProd+"'" +
                     " and pp.COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"'"+
                     " and pp.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"' and pp.COD_COMPPROD='"+codCompProd+"'";
      System.out.println("consulta cabecera");
      con=Util.openConnection(con);
      Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
      ResultSet res=st.executeQuery(consulta);
      out.println("<table cellpadding='0' cellspacing='0' class='tablaCabecera'><thead><tr><td align='center' colspan='3'><span>Datos Lote</span></td></tr></thead><tbody>");
      if(res.next())
      {
          out.println("<tr><td><span class='outputText2' style='font-weight:bold'>Programa Produccion</span></td>"+
                      " <td><span class='outputText2' style='font-weight:bold'>::</span></td>"+
                      "<td><span class='outputText2'>"+res.getString("NOMBRE_PROGRAMA_PROD")+"</span></td></tr>"+
                      "<tr><td><span class='outputText2' style='font-weight:bold'>Lote</span></td>"+
                      " <td><span class='outputText2' style='font-weight:bold'>::</span></td>"+
                      "<td><span class='outputText2'>"+codLote+"</span></td></tr>"+
                      "<tr><td><span class='outputText2' style='font-weight:bold'>Producto</span></td>"+
                      " <td><span class='outputText2' style='font-weight:bold'>::</span></td>"+
                      "<td><span class='outputText2'>"+res.getString("nombre_prod_semiterminado")+"</span></td></tr>"+
                      "<tr><td><span class='outputText2' style='font-weight:bold'>Tipo Programa Producción</span></td>"+
                      " <td><span class='outputText2' style='font-weight:bold'>::</span></td>"+
                      "<td><span class='outputText2'>"+res.getString("NOMBRE_TIPO_PROGRAMA_PROD")+"</span></td></tr>"
                      );
          if(codAreaEmpresa.equals("96"))codAreaEmpresa=res.getString("COD_AREA_EMPRESA");
      }
      
      consulta="select ap.NOMBRE_ACTIVIDAD from ACTIVIDADES_FORMULA_MAESTRA afm  inner join ACTIVIDADES_PRODUCCION ap"+
               " on afm.COD_ACTIVIDAD=ap.COD_ACTIVIDAD where afm.COD_ACTIVIDAD_FORMULA='"+codActividadFm+"'";
      System.out.println("consulta actividad "+consulta);
      res=st.executeQuery(consulta);
      if(res.next())
      {
          out.println("<tr><td><span class='outputText2' style='font-weight:bold'>Actividad</span></td>"+
                      " <td><span class='outputText2' style='font-weight:bold'>::</span></td>"+
                      "<td><span class='outputText2'>"+res.getString("NOMBRE_ACTIVIDAD")+"</span></td></tr>");
      }
      out.println("</tbody></table>");
  %>
   <table class="tablaIndirectos" id="seguimientoIndirectos" cellpadding="0" cellspacing="0">
       <thead>
           <tr>
              <td><span >&nbsp;</span></td>
              <td><span>Personal</span></td>
              <td><span>Fecha</span></td>
              <td><span>Hora Inicio</span></td>
              <td><span>Hora Final</span></td>
              <td><span>Horas Hombre</span></td>
              <td><span>Unidades Producidas</span></td>
              <td><span>Horas Extra</span></td>
              <td><span>Unidades Producidas Extra</span></td>
           </tr>
       </thead>
       <tbody>
  <%
 
        Date fechaActual=new Date();
        int cantidadDiasHabilitados=(fechaActual.getDay()==1?400:401);
        SimpleDateFormat sdfDias=new SimpleDateFormat("dd/MM/yyyy");
        SimpleDateFormat sdfHoras=new SimpleDateFormat("HH:mm");
        SimpleDateFormat sdfSistema=new SimpleDateFormat("yyyy/MM/dd");
        NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
        DecimalFormat formato = (DecimalFormat)nf;
        formato.applyPattern("#,##0.00");
        Calendar cal = new GregorianCalendar();
        cal.setTimeInMillis(fechaActual.getTime());
        cal.add(Calendar.DATE, -cantidadDiasHabilitados);
        Date fechaLimite=new Date(cal.getTimeInMillis());
        consulta="select isnull((p.AP_PATERNO_PERSONAL + ' ' + p.AP_MATERNO_PERSONAL + ' ' +p.NOMBRES_PERSONAL + ' ' + p.nombre2_personal), (pt.AP_PATERNO_PERSONAL +"+
                 " ' ' + pt.AP_MATERNO_PERSONAL + ' ' + pt.NOMBRES_PERSONAL + ' ' +pt.nombre2_personal)) as nombrePersonal,"+
                 " sppp.FECHA_INICIO,sppp.FECHA_FINAL,sppp.HORAS_HOMBRE,sppp.UNIDADES_PRODUCIDAS,sppp.HORAS_EXTRA,sppp.UNIDADES_PRODUCIDAS_EXTRA"+
                 " from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sppp "+
                 " left outer join personal p on sppp.COD_PERSONAL=p.COD_PERSONAL"+
                 " left outer join PERSONAL_TEMPORAL pt on pt.COD_PERSONAL=sppp.COD_PERSONAL"+
                 " where sppp.COD_LOTE_PRODUCCION='"+codLote+"' and sppp.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"'" +
                 " and sppp.COD_COMPPROD='"+codCompProd+"'"+
                 " and sppp.COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"' and sppp.COD_COMPPROD='"+codCompProd+"'"+
                 " and sppp.COD_ACTIVIDAD_PROGRAMA='"+codActividadFm+"'"+
                 " and sppp.FECHA_INICIO<'"+sdfSistema.format(fechaLimite)+" 00:00'"+
                 " order by sppp.FECHA_INICIO";
        System.out.println("consulta registros antes "+consulta);
        res=st.executeQuery(consulta);
        while(res.next())
        {
            out.println("<tr><td>&nbsp;</td>" +
                        "<td align='left'><span class='outputText2'>"+res.getString("nombrePersonal")+"</span></td>" +
                        "<td><span class='outputText2'>"+sdfDias.format(res.getTimestamp("FECHA_INICIO"))+"</span></td>" +
                        "<td><span class='outputText2'>"+sdfHoras.format(res.getTimestamp("FECHA_INICIO"))+"</span></td>" +
                        "<td><span class='outputText2'>"+sdfHoras.format(res.getTimestamp("FECHA_FINAL"))+"</span></td>" +
                        "<td><span class='outputText2'>"+formato.format(res.getDouble("HORAS_HOMBRE"))+"</span></td>" +
                        "<td><span class='outputText2'>"+res.getInt("UNIDADES_PRODUCIDAS")+"</span></td>" +
                        "<td><span class='outputText2'>"+formato.format(res.getDouble("HORAS_EXTRA"))+"</span></td>" +
                        "<td><span class='outputText2'>"+res.getInt("UNIDADES_PRODUCIDAS_EXTRA")+"</span></td>" +
                        "</tr>");
        }
        //liquidos no esteriles y semisolidos comparten personal
        /*if(codAreaEmpresa.equals("80")||codAreaEmpresa.equals("95")||codAreaEmpresa.equals("82"))
            codAreaEmpresa="80,95,82";*/
        consulta="select pap.COD_PERSONAL,isnull((p.AP_PATERNO_PERSONAL + ' ' + p.AP_MATERNO_PERSONAL + ' ' +p.NOMBRES_PERSONAL + ' ' + p.nombre2_personal), (pt.AP_PATERNO_PERSONAL +' ' + pt.AP_MATERNO_PERSONAL + ' ' + pt.NOMBRES_PERSONAL + ' ' +pt.nombre2_personal+' (temporal) ')) as nombrePersonal"+
                   " from PERSONAL_AREA_PRODUCCION pap"+
                      " left outer join personal p on p.COD_PERSONAL = pap.COD_PERSONAL"+
                      " left outer join PERSONAL_TEMPORAL pt on pt.COD_PERSONAL = pap.COD_PERSONAL"+
                   " where pap.COD_ESTADO_PERSONAL_AREA_PRODUCCION = 1"+
                   " and( pap.COD_AREA_EMPRESA in ("+codAreaEmpresa+")"+
                   " or pap.OPERARIO_GENERICO=1)"+
                   " order by 2";
        System.out.println("consulta personal "+consulta);
        res=st.executeQuery(consulta);
        String selectPersonal="";
        String selectPersonalJavascript="";
        while(res.next())
        {
            selectPersonal+="<option value='"+res.getInt(1)+"' >"+res.getString(2)+"</option>";
            selectPersonalJavascript+=(selectPersonalJavascript.equals("")?"":"&&&")+res.getInt(1)+"&&&"+res.getString(2);
        }
        out.println("<script type='text/javascript'>personalSelect=\""+selectPersonalJavascript+"\";" +
                    " codProgramaProd='"+codProgramaProd+"';"+
                    " codActividad='"+codActividadFm+"';"+
                    " fechaSistema='"+sdfDias.format(fechaActual)+"';"+
                    " fechaLimite='"+sdfDias.format(fechaLimite)+"';"+
                    " codLote='"+codLote+"';"+
                    " codFormulaMaestra='"+codFormulaMaestra+"';"+
                    " codTipoProgramaProd='"+codTipoProgramaProd+"';"+
                    " codCompProd='"+codCompProd+"';"+
                    " codAreaEmpresa='"+codAreaEmpresa+"';</script>");
        consulta="select sppp.COD_PERSONAL,isnull((p.AP_PATERNO_PERSONAL + ' ' + p.AP_MATERNO_PERSONAL + ' ' +p.NOMBRES_PERSONAL + ' ' + p.nombre2_personal), (pt.AP_PATERNO_PERSONAL +"+
                 " ' ' + pt.AP_MATERNO_PERSONAL + ' ' + pt.NOMBRES_PERSONAL + ' ' +pt.nombre2_personal)) as nombrePersonal,"+
                 " sppp.FECHA_INICIO,sppp.FECHA_FINAL,sppp.HORAS_HOMBRE,sppp.UNIDADES_PRODUCIDAS,sppp.HORAS_EXTRA,sppp.UNIDADES_PRODUCIDAS_EXTRA"+
                 " from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sppp "+
                 " left outer join personal p on sppp.COD_PERSONAL=p.COD_PERSONAL"+
                 " left outer join PERSONAL_TEMPORAL pt on pt.COD_PERSONAL=sppp.COD_PERSONAL"+
                 " where sppp.COD_LOTE_PRODUCCION='"+codLote+"' and sppp.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"'" +
                 " and sppp.COD_COMPPROD='"+codCompProd+"'"+
                 " and sppp.COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"' and sppp.COD_COMPPROD='"+codCompProd+"'"+
                 " and sppp.COD_ACTIVIDAD_PROGRAMA='"+codActividadFm+"'"+
                 " and sppp.FECHA_INICIO>='"+sdfSistema.format(fechaLimite)+" 00:00'"+
                 " order by sppp.FECHA_INICIO";
        System.out.println("consulta registros habilitados "+consulta);
        res=st.executeQuery(consulta);
        while(res.next())
        {
            out.println("<tr><td><input type='checkbox'/></td>" +
                        "<td><select class='inputText' id='codP"+res.getRow()+"'>"+selectPersonal+"</select></td>" +
                        "<td><input class='inputText' type='text' size='8' value='"+sdfDias.format(res.getTimestamp("FECHA_INICIO"))+"' /></td>" +
                        "<td><input class='inputText' type='text' size='5' onkeyup='calcularHorasHombre(this)' value='"+sdfHoras.format(res.getTimestamp("FECHA_INICIO"))+"' /></td>" +
                        "<td><input class='inputText' type='text' size='5' onkeyup='calcularHorasHombre(this)' value='"+sdfHoras.format(res.getTimestamp("FECHA_FINAL"))+"' /></td>" +
                        "<td><span class='outputText2'>"+formato.format(res.getDouble("HORAS_HOMBRE"))+"</span></td>" +
                        "<td><input class='inputText' type='text' size='5' style='text-align:center' value='"+res.getInt("UNIDADES_PRODUCIDAS")+"' /></td>" +
                        "<td><input class='inputText' type='text' size='5' style='text-align:center' value='"+formato.format(res.getDouble("HORAS_EXTRA"))+"' /></td>" +
                        "<td><input class='inputText' type='text' size='5' style='text-align:center' value='"+res.getInt("UNIDADES_PRODUCIDAS_EXTRA")+"' /></td>" +
                        "</tr>");
            out.println("<script>codP"+res.getRow()+".value='"+res.getInt("COD_PERSONAL")+"';</script>");
        }
  }
  catch(SQLException ex)
  {
      ex.printStackTrace();
  }
   %>
       </tbody>
   </table>
   <div style="margin-top:1em;">
       <a tabindex="0" onclick="agregarSeguimiento();" onkeypress="agregarSeguimiento();"><img src="../img/mas.png"/></a>
       <a onclick="eliminarRegistro();"><img src="../img/menos.png"/></a>
   </div>
   <div style="margin-top:1em;">
   <button class="btn" onclick="guardarTiempos()">Guardar</button>
   <button class="btn" onclick="window.location.href='navegador_actividades_programa.jsf?cancel='+(new Date()).getTime().toString();">Cancelar</button>
   </div>
    
        <img id="imgLoad" src="../img/load2.gif"  style="visibility:hidden;position:absolute;z-index:5;top:6em;"/>
   </center>
   
    </body>
        
    <div id="panelsuper"  class="panelSuper" style="visibility:hidden" >
    </div>
     
</html>
