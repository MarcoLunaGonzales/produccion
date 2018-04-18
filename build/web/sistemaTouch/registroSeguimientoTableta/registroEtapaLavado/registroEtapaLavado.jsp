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

    var fechaSistemaLavado="";
    var operariosRegistro="";
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
    
    function guardarLavado()
    {
        document.getElementById('formsuper').style.visibility='visible';
        document.getElementById('divImagen').style.visibility='visible';
        var permisoRecepcion=(parseInt(document.getElementById("permisoRecepcionAmpollas").value)>0);
        var permisoLavado=(parseInt(document.getElementById("permisoLavado").value)>0);
        var permisoRecepcion=(parseInt(document.getElementById("permisoRecepcionAmpollas").value)>0);
        var tabla=document.getElementById('dataEspecificacionesLavado');
        var codLote=document.getElementById('codLoteSeguimiento').value;
        var cont=0;
        var especificaciones=new Array();
        var tablaCambioFormato=document.getElementById("seguimientoCambioFormato");
        var dataCambioFormato=new Array();
        var especificacionesRecepcion=document.getElementById("dataRecepcion");
        var espRecepcion=new Array();
        var ampollasRecibidas=document.getElementById("dataPacksRecibidos");
        var dataAmpollasRecibidas=new Array();
        var ampollasSeguimiento=document.getElementById("dataSeguimientoLavado");
        var dataAmpollasSeguimineto=new Array();
         
        if(permisoRecepcion&&!admin)
        {
                if(!(validarHoraRegistro(document.getElementById("horaInicioRecepcion"))&&validarHoraRegistro(document.getElementById("horaFinalRecepcion"))&&
                validarRegistrosHorasNoNegativas(document.getElementById("horaInicioRecepcion"), document.getElementById("horaFinalRecepcion"))
                ))//&&validarSeleccionRegistro(document.getElementById("codMaquinaLavado"))
                {
                    document.getElementById('formsuper').style.visibility='hidden';
                    document.getElementById('divImagen').style.visibility='hidden';
                    return false;
                }
                cont=0;

                for(var j=1;j<especificacionesRecepcion.rows.length;j++)
                    {
                         espRecepcion[cont]=especificacionesRecepcion.rows[j].cells[0].getElementsByTagName('input')[0].value;
                        cont++;
                        espRecepcion[cont]=especificacionesRecepcion.rows[j].cells[2].getElementsByTagName('input')[0].checked?'1':'0';
                        cont++;
                        espRecepcion[cont]=encodeURIComponent(especificacionesRecepcion.rows[j].cells[3].getElementsByTagName('input')[0].value.split(",").join("$%"));
                        cont++;
                    }
                 cont=0;
                 for(var i=1;i<ampollasRecibidas.rows.length;i++)
                 {
                     if(validarRegistroEntero(ampollasRecibidas.rows[i].cells[0].getElementsByTagName("input")[0])&&
                         validarRegistroEntero(ampollasRecibidas.rows[i].cells[1].getElementsByTagName("input")[0]))
                     {
                         dataAmpollasRecibidas[cont]=ampollasRecibidas.rows[i].cells[0].getElementsByTagName("input")[0].value;
                         cont++
                         dataAmpollasRecibidas[cont]=ampollasRecibidas.rows[i].cells[1].getElementsByTagName("input")[0].value;
                         cont++
                     }
                     else
                     {
                        document.getElementById('formsuper').style.visibility='hidden';
                        document.getElementById('divImagen').style.visibility='hidden';
                        return false;
                     }
                 }
        }
        if(permisoLavado&&!admin)
        {
            cont=0;
            for(var i=2;i<tablaCambioFormato.rows.length;i++)
            {
                
                if(validarSeleccionRegistro(tablaCambioFormato.rows[i].cells[0].getElementsByTagName("select")[0])&&
                    validarHoraRegistro(tablaCambioFormato.rows[i].cells[2].getElementsByTagName("input")[0])
                    &&validarHoraRegistro(tablaCambioFormato.rows[i].cells[3].getElementsByTagName("input")[0])
                    &&validarRegistrosHorasNoNegativas(tablaCambioFormato.rows[i].cells[2].getElementsByTagName("input")[0],tablaCambioFormato.rows[i].cells[3].getElementsByTagName("input")[0]))
                {
                    dataCambioFormato[cont]=tablaCambioFormato.rows[i].cells[0].getElementsByTagName('select')[0].value;
                    cont++;
                    dataCambioFormato[cont]=tablaCambioFormato.rows[i].cells[1].getElementsByTagName('input')[0].value;
                    cont++;
                    dataCambioFormato[cont]=tablaCambioFormato.rows[i].cells[2].getElementsByTagName('input')[0].value;
                    cont++;
                    dataCambioFormato[cont]=tablaCambioFormato.rows[i].cells[3].getElementsByTagName('input')[0].value;
                    cont++;
                    dataCambioFormato[cont]=parseFloat(getNumeroDehoras(dataCambioFormato[cont-3]+" "+dataCambioFormato[cont-2],
                    dataCambioFormato[cont-3]+" "+dataCambioFormato[cont-1]));
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
            for(var i=1;i<tabla.rows.length;i++)
            {
                if(tabla.rows[i].cells[0].getElementsByTagName('input').length>0)
                {
                    if(tabla.rows[i].cells[3].getElementsByTagName('input')[0].type=='tel'&&
                      (!validadRegistroMayorACero(tabla.rows[i].cells[3].getElementsByTagName('input')[0])))
                    {
                        document.getElementById('formsuper').style.visibility='hidden';
                        document.getElementById('divImagen').style.visibility='hidden';
                        return false;
                    }
                    especificaciones[especificaciones.length]=tabla.rows[i].cells[0].getElementsByTagName('input')[0].value;
                    if(tabla.rows[i].cells[3].getElementsByTagName('input')[0].type=='tel')
                    {
                        especificaciones[especificaciones.length]=tabla.rows[i].cells[3].getElementsByTagName('input')[0].value;
                    }
                    else
                    {
                        especificaciones[especificaciones.length]=tabla.rows[i].cells[3].getElementsByTagName('input')[0].checked?'1':'0';
                    }
                    especificaciones[especificaciones.length]=encodeURIComponent((tabla.rows[i].cells[4].getElementsByTagName('input')[0].value.split(",").join("$%")));
                    cont++;
                }

            }
            cont=0;
            for(var k=1;k<ampollasSeguimiento.rows.length;k++)
             {
                 if(validarRegistroEntero(ampollasSeguimiento.rows[k].cells[1].getElementsByTagName('input')[0])&&
                    validarRegistroEntero(ampollasSeguimiento.rows[k].cells[2].getElementsByTagName('input')[0])&&
                    validarRegistroEntero(ampollasSeguimiento.rows[k].cells[4].getElementsByTagName('input')[0])&&
                    validarFechaRegistro(ampollasSeguimiento.rows[k].cells[6].getElementsByTagName('input')[0])&&
                    validarSeleccionRegistro(ampollasSeguimiento.rows[k].cells[5].getElementsByTagName('select')[0])&&
                    validarHoraRegistro(ampollasSeguimiento.rows[k].cells[7].getElementsByTagName('input')[0])&&
                    validarHoraRegistro(ampollasSeguimiento.rows[k].cells[8].getElementsByTagName('input')[0])&&
                    validarRegistrosHorasNoNegativas(ampollasSeguimiento.rows[k].cells[7].getElementsByTagName('input')[0],ampollasSeguimiento.rows[k].cells[8].getElementsByTagName('input')[0]))
                   {
                         dataAmpollasSeguimineto[cont]=ampollasSeguimiento.rows[k].cells[5].getElementsByTagName('select')[0].value;
                         cont++;
                         dataAmpollasSeguimineto[cont]=ampollasSeguimiento.rows[k].cells[1].getElementsByTagName('input')[0].value;
                         cont++;
                         dataAmpollasSeguimineto[cont]=ampollasSeguimiento.rows[k].cells[2].getElementsByTagName('input')[0].value;
                         cont++;
                         dataAmpollasSeguimineto[cont]=ampollasSeguimiento.rows[k].cells[4].getElementsByTagName('input')[0].value;
                         cont++;
                         dataAmpollasSeguimineto[cont]=ampollasSeguimiento.rows[k].cells[6].getElementsByTagName('input')[0].value;
                         cont++;
                         dataAmpollasSeguimineto[cont]=ampollasSeguimiento.rows[k].cells[7].getElementsByTagName('input')[0].value;
                         cont++;
                         dataAmpollasSeguimineto[cont]=ampollasSeguimiento.rows[k].cells[8].getElementsByTagName('input')[0].value;
                         cont++;
                         dataAmpollasSeguimineto[cont]=redondeo2decimales(getNumeroDehoras((dataAmpollasSeguimineto[cont-3]+' '+dataAmpollasSeguimineto[cont-2]),(dataAmpollasSeguimineto[cont-3]+' '+dataAmpollasSeguimineto[cont-1])));
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
       var ajax=nuevoAjax();
        console.log(especificaciones);
        var peticion="ajaxGuardarSeguimientoEtapaLavado.jsf?codLote="+codLote+"&noCache="+ Math.random()+
             "&codprogramaProd="+document.getElementById("codprogramaProd").value+"&codSeguimientoLavadoLote="+document.getElementById("codSeguimientoLavadoLote").value+
             "&codFormulaMaestra="+document.getElementById("codFormulaMaestra").value+"&codTipoProgramaProd="+document.getElementById("codTipoProgramaProd").value+
             "&codCompProd="+document.getElementById("codCompProd").value+"&codActividadCambioFormato="+document.getElementById("codActividadCambioFormato").value+
             "&codActividadLavado="+document.getElementById("codActividadLavado").value+"&codActividadRecepcion="+document.getElementById("codActividadRecepcion").value+
             "&especificacionesLavado="+especificaciones+"&espRecepcion="+espRecepcion+
             (permisoRecepcion?"&codPersonalRecepcion="+document.getElementById("codEncargadoRecepcion").value:"")+
             (permisoLavado?"&codMaquinaLavado="+document.getElementById("codMaquinaLavado").value:"")+
             "&dataAmpollasRecibidas="+dataAmpollasRecibidas+
             "&dataEtapaLavado="+dataAmpollasSeguimineto+
             (permisoRecepcion?"&fechaInicioRecepcion="+document.getElementById("fechaRecepcions").value+" "+document.getElementById("horaInicioRecepcion").value+
             "&fechaFinalRecepcion="+document.getElementById("fechaRecepcions").value+" "+document.getElementById("horaFinalRecepcion").value+
             "&horasHombreRecepcion="+getNumeroDehoras((document.getElementById("fechaRecepcions").value+" "+document.getElementById("horaInicioRecepcion").value),(document.getElementById("fechaRecepcions").value+" "+document.getElementById("horaFinalRecepcion").value)):"")+
             "&dataCambioFormato="+dataCambioFormato+
             "&permisoRecepcion="+(permisoRecepcion?1:0)+"&permisoLavado="+(permisoLavado?1:0)+
             "&admin="+(admin?1:0)+"&codPersonalUsuario="+codPersonal+
             (admin?"&observacion="+encodeURIComponent(document.getElementById("observacion").value):"");
        console.log(peticion);
        ajax.open("GET",peticion,true);
        ajax.setRequestHeader('content-type', 'application/x-www-form-urlencoded;charset=UTF-8');
                 ajax.onreadystatechange=function(){
                    if (ajax.readyState==4) {
                        if(ajax.responseText==null || ajax.responseText=='')
                        {
                            alert('No se puede conectar con el servidor, verfique su conexión a internet');
                            if(confirm("Desea guardar la informacion localmente?\nLa informacion del lote no se perdera pero debe de subirla despues"))
                            {
                                sqlConnection.insertarRegistroAuxiliar(document.getElementById("codprogramaProd").value, codLote,3,("../registroEtapaLavado/"+peticion),function(){window.close();});
                            }
                            document.getElementById('formsuper').style.visibility='hidden';
                            document.getElementById('divImagen').style.visibility='hidden';
                            return false;
                        }
                        if(parseInt(ajax.responseText.split("\n").join(""))=='1')
                        {
                            alert('Se registro la etapa de lavado');
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
    
    function sumaRendimiento()
    {
        var ampollas=document.getElementById('dataSeguimientoLavado');
        var sumaAmpollas=0;
        for(var i=1;i<ampollas.rows.length;i++)
        {
            if(!isNaN(ampollas.rows[i].cells[3].getElementsByTagName('span')[0].innerHTML))
                {
            sumaAmpollas+=parseInt(ampollas.rows[i].cells[3].getElementsByTagName('span')[0].innerHTML);
                }
        }
       document.getElementById('numEsp23').value=redondeo2decimales(parseFloat(document.getElementById('numEsp25').value)>0?sumaAmpollas/parseFloat(document.getElementById('numEsp25').value):0);
           // document.getElementById('rendimiento').innerHTML=redondeo2decimales(((sumaAmpollas-parseInt(document.getElementById("cantidadAmpollasRotas").innerHTML))/parseInt(document.getElementById('cantidadLote').innerHTML))*100);
    }
    function calcularRendimientoLote()
    {
        document.getElementById('rendimiento').innerHTML=redondeo2decimales(((parseInt(document.getElementById('sumaCantidad').innerHTML)-parseInt(document.getElementById("cantidadAmpollasRotas").innerHTML))/parseInt(document.getElementById('cantidadLote').innerHTML))*100);
    }
    function sumaAmpollasRotas()
    {
        var dataAmpollas=document.getElementById('dataSeguimientoLavado');
        var sumaAmpollasRotas=0;
        for(var j=1;j<dataAmpollas.rows.length;j++)
        {
            if((!isNaN(dataAmpollas.rows[j].cells[4].getElementsByTagName('input')[0].value))&&dataAmpollas.rows[j].cells[4].getElementsByTagName('input')[0].value!='')
            {
                sumaAmpollasRotas+=parseInt(dataAmpollas.rows[j].cells[4].getElementsByTagName('input')[0].value);
            }
        }
        
        //document.getElementById("cantidadAmpollasRotas").innerHTML=redondeo2decimales(sumaAmpollasRotas);
        //document.getElementById('rendimiento').innerHTML=redondeo2decimales(((parseInt(document.getElementById('sumaCantidad').innerHTML)-sumaAmpollasRotas)/parseInt(document.getElementById('cantidadLote').innerHTML))*100);
    }
    function calcularTotalAmpollas(celda)
    {
        var resultado=(parseInt(celda.parentNode.parentNode.cells[1].getElementsByTagName('input')[0].value)*parseInt(celda.parentNode.parentNode.cells[2].getElementsByTagName('input')[0].value));
        celda.parentNode.parentNode.cells[3].getElementsByTagName('span')[0].innerHTML=(isNaN(resultado)?0:resultado);
        sumaRendimiento();
    }
    
    var contRegistroAmpollas=0;
    function calcularAmpollasRecibidas(inputCant)
    {
        var row=inputCant.parentNode.parentNode;
        var resultado=parseInt(row.cells[0].getElementsByTagName("input")[0].value)*parseInt(row.cells[1].getElementsByTagName("input")[0].value);
        row.cells[2].innerHTML=isNaN(resultado)?0:resultado;
        var sumaRecibidas=0;
        var tabla=row.parentNode;
        /*for(var i=1;i<tabla.rows.length;i++)
        {
            if(!isNaN(tabla.rows[i].cells[2].innerHTML))
            {
                sumaRecibidas+=parseInt(tabla.rows[i].cells[2].innerHTML);
            }
        }
        document.getElementById("cantidadLote").innerHTML=redondeo2decimales(sumaRecibidas);
        document.getElementById('rendimiento').innerHTML=redondeo2decimales(((parseInt(document.getElementById('sumaCantidad').innerHTML)-parseInt(document.getElementById("cantidadAmpollasRotas").innerHTML))/sumaRecibidas)*100);
        */
    }
    function nuevoRegistroRecepcionAmpollas()
    {
        contRegistroAmpollas++;
        var table = document.getElementById("dataPacksRecibidos");
        var rowCount = table.rows.length;
        var row = table.insertRow(rowCount);
        row.onclick=function(){seleccionarFila(this);};

        var cell0=row.insertCell(0);
        cell0.className="tableCell";
        //cell0.align="center";
        var input0=document.createElement("input");
        input0.onkeyup=function(){calcularAmpollasRecibidas(this);};
        input0.type="tel";
        input0.value=0;
        input0.className="inputInterno";
        cell0.appendChild(input0);

        var cell1=row.insertCell(1);
        cell1.className="tableCell";
        cell1.align="center";
        var input1=document.createElement("input");
        input1.onkeyup=function(){calcularAmpollasRecibidas(this);};
        input1.type="tel";
        input1.value=0;
        input1.className="inputInterno";
        cell1.appendChild(input1);

        var cell2=row.insertCell(2);
        cell2.className="tableCell";
        cell2.align="center";
        var span=document.createElement("span");
        span.className="textHeaderClassBody"
        span.innerHTML="0";
        span.style.fontWeight='normal';
        cell2.appendChild(span);


    }
    function nuevoRegistro(nombreTabla)
   {
       contRegistroAmpollas++;
       var table = document.getElementById(nombreTabla);
       var rowCount = table.rows.length;
       var row = table.insertRow(rowCount);
       row.onclick=function(){seleccionarFila(this);};
       var cell0 = row.insertCell(0);
       cell0.className="tableCell";
       var element0 = document.createElement("span");
       element0.className='textHeaderClassBody';
       element0.innerHTML=(table.rows.length-1);
       element0.style.fontWeight='normal';
       cell0.appendChild(element0);
       
       var cell1 = row.insertCell(1);
       cell1.className="tableCell";
       var element1 = document.createElement("input");
       element1.onkeyup=function(){calcularTotalAmpollas(this);};
       element1.addEventListener ( "input" ,  function ()  {
        valNum ( this )
    },  false );
       element1.type = "tel";
       element1.value=0;
       element1.style.width='6em';
       cell1.appendChild(element1);
       var cell2 = row.insertCell(2);
       cell2.className="tableCell";
       var element2 = document.createElement("input");
       element2.onkeyup=function(){calcularTotalAmpollas(this);}
       element2.type = "tel";
       element2.value=0;
       element2.style.width='6em';
       cell2.appendChild(element2);
       
       var cell3 = row.insertCell(3);
       cell3.className="tableCell";
       cell3.style.textAlign='center';
       var celdaInput=document.createElement("input");
       celdaInput.type="hidden";
       celdaInput.value=0;
       cell3.appendChild(celdaInput);
       var element3 = document.createElement("span");
       element3.className='textHeaderClassBody';
       element3.innerHTML=0;
       element3.style.fontWeight='normal';
       cell3.appendChild(element3);


       var cellrotas = row.insertCell(4);
       cellrotas.className="tableCell";
       var elementrotas = document.createElement("input");
       elementrotas.onkeyup=function(){sumaAmpollasRotas();};
       elementrotas.type = "tel";
       elementrotas.value=0;
       elementrotas.style.width='6em';
       cellrotas.appendChild(elementrotas);

       var cell4 = row.insertCell(5);
       cell4.className="tableCell";
       var element4 = document.createElement("select");
       element4.innerHTML=operariosRegistro;
       cell4.appendChild(element4);


       var cell5 = row.insertCell(6);
       cell5.className="tableCell";
       var element5 = document.createElement("input");
       element5.type = "text";
       element5.size=10;
       element5.value=fechaSistemaLavado;
       element5.id="fechaSegui"+contRegistroAmpollas;
       element5.onclick=function(){seleccionarDatePickerJs(this);};
       cell5.appendChild(element5);

       var cell6 = row.insertCell(7);
       cell6.className="tableCell";
       var element6 = document.createElement("input");
       element6.type = "text";
       element6.onclick=function(){seleccionarHora(this);};
       element6.onfocus=function(){calcularHorasHombre(this);};
       element6.id='fechaIniNuevo'+contRegistroAmpollas;
       element6.style.width='6em';
       element6.value=getHoraActualString();
       cell6.appendChild(element6);
       var cell7 = row.insertCell(8);
       cell7.className="tableCell";
       var element7 = document.createElement("input");
       element7.id='fechaFinNuevo'+contRegistroAmpollas;
       element7.onclick=function(){seleccionarHora(this);};
       element7.onfocus=function(){calcularHorasHombre(this);};
       element7.type = "text";
       element7.style.width='6em';
       element7.value=getHoraActualString();
       cell7.appendChild(element7);
}
   function eliminarRegistro(rowEliminar)
    {
        rowEliminar.style.backgroundColor='#F08080';
        if(confirm('Esta seguro de eliminar el seguimiento')==true)
        {
            var a =rowEliminar.parentNode;
            a.deleteRow(rowEliminar.rowIndex);

        }
        else
        {
            rowEliminar.style.backgroundColor='';
        }
    }
    function cambioFormatoChange(celda)
    {
       document.getElementById('tablaCambioFormato').style.display=(celda.checked?'block':'none');
       document.getElementById('tablaCambioFormato').style.height =(celda.checked?'auto':'0px');
    }
    var contRegistro=0;
    function calcularTotalHoras()
    {
        var ampollas=document.getElementById('dataSeguimientoLavado');
        var totalHoras=0;
        for(var i=1;i<ampollas.rows.length;i++)
        {
            totalHoras+=parseFloat(ampollas.rows[i].cells[3].getElementsByTagName("input")[0].value);
        }
        document.getElementById("numEsp25").value=totalHoras;
        sumaRendimiento();
    }
    function calcularHorasHombre(obj)
    {
        var fecha1=obj.parentNode.parentNode.cells[6].getElementsByTagName('input')[0].value+' '+obj.parentNode.parentNode.cells[7].getElementsByTagName('input')[0].value;
        var fecha2=obj.parentNode.parentNode.cells[6].getElementsByTagName('input')[0].value+' '+obj.parentNode.parentNode.cells[8].getElementsByTagName('input')[0].value;
        obj.parentNode.parentNode.cells[3].getElementsByTagName('input')[0].value=getNumeroDehoras(fecha1,fecha2);
        calcularTotalHoras();
    }
    function  masCambioFormato(nombreTabla)
    {
       contRegistro++;
       var table = document.getElementById(nombreTabla);
       var rowCount = table.rows.length;
       var row = table.insertRow(rowCount);
       row.onclick=function(){seleccionarFila(this);};
       var cell1 = row.insertCell(0);
       cell1.className="tableCell";
       var element1 = document.createElement("select");
       element1.innerHTML=operariosRegistro;
       cell1.appendChild(element1);
        var cell2 = row.insertCell(1);
       cell2.className="tableCell";
       var element2 = document.createElement("input");
       element2.id="fechaTiempo"+contRegistro;
       element2.type = "text";
       element2.value=fechaSistemaLavado;
       element2.onclick=function(){seleccionarDatePickerJs(this);};
       cell2.appendChild(element2);
       for(var i=0;i<2;i++)
       {
           var cell3 = row.insertCell(i+2);
           cell3.className="tableCell";
           var element3 = document.createElement("input");
           element3.type = "text";
           cell3.align='center';
           element3.style.width='6em';
           element3.id='hora'+i+'t'+contRegistro;
           element3.value=getHoraActualString();
           element3.onclick=function(){seleccionarHora(this);};
           cell3.appendChild(element3);
       }

   }
</script>


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
        int codPersonalSupervisor=0;
        Date fechaCierre=new Date();
        String codCompProd=request.getParameter("codComprod");
        String codLote=request.getParameter("codLote");
        out.println("<title>("+codLote+")LAVADO</title>");
        String codprogramaProd=request.getParameter("cod_prog");
        int codForma=0;
        String operarios="";
        NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
        DecimalFormat format = (DecimalFormat)nf;
        format.applyPattern("#,##0.00");
        SimpleDateFormat sdfLocal=new SimpleDateFormat("MM-yyyy");
        String codPersonalEncargadoRecepcion="0";
        int codPersonalApruebaDespeje=0;
        String observaciones="";
        int codSeguimientoLavadoLote=0;
        int codActividadRecepcion=0;
        int codActividadCambioFormato=0;
        int codActividadLavado=0;
        int codFormulaMaestra=0;
        int codTipoProgramaProd=0;
        int sumaCantidadAmpollasLavadas=0;
        int sumaCantidadAmpollasRotas=0;
        int sumaCantidadRecibidas=0;
        SimpleDateFormat sdfHora=new SimpleDateFormat("HH:mm");
        SimpleDateFormat sdfDias=new SimpleDateFormat("dd/MM/yyyy");
        String maquinariasLavadoSelect="";
        int codMaquinaLavado=0;
        out.println("<script>sqlConnection.verificarRegistroPendiente('"+codprogramaProd+"','"+codLote+"',3)</script>");
        String fechaSeguimiento=sdfDias.format(new Date());
        String horaInicio=sdfHora.format(new Date());
        String horaFinal=sdfHora.format(new Date());
        boolean permisoRecepcionAmpollas=false;
        boolean permisoLavado=false;
                try
                {
                    Connection con=null;
                    con=Util.openConnection(con);
                    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    String consulta="select pp.cod_tipo_programa_prod, pp.cod_formula_maestra, cp.cod_Area_empresa,cp.COD_FORMA,p.nombre_prod,f.abreviatura_forma,cp.nombre_prod_semiterminado,cp.NOMBRE_GENERICO,f.nombre_forma,cp.REG_SANITARIO,"+
                                    " ep.nombre_envaseprim,cp.VIDA_UTIL,pp.CANT_LOTE_PRODUCCION,ppp.FECHA_FINAL,isnull(cpr.COD_RECETA_LAVADO, 0) as cod_receta_lavado," +
                                    " ISNULL(cp.VOLUMEN_ENVASE_PRIMARIO,'') as VOLUMEN_ENVASE_PRIMARIO" +
                                    " ,ISNULL(dpff.INDICACIONES_LAVADO,'') as INDICACIONES_LAVADO,isnull(dpff.PRE_INDICACIONES_LAVADO,'') as PRE_INDICACIONES_LAVADO" +
                                    " ,ISNULL(dpff.NOTA_LAVADO,'') as NOTA_LAVADO,isnull(sll.COD_SEGUIMIENTO_LAVADO_LOTE,0) as codSeguimientoLavadoLote,"+
                                    " isnull(sll.COD_PERSONAL_ENCARGADO_RECEPCION,0) as COD_PERSONAL_ENCARGADO_RECEPCION," +
                                    " isnull(sll.COD_PERSONAL_SUPERVISOR,0) as COD_PERSONAL_SUPERVISOR," +
                                    " isnull(sll.OBSERVACIONES,'') AS OBSERVACIONES" +
                                    " ,isnull(afm.COD_ACTIVIDAD_FORMULA,0) as codActividadRecepcion"+
                                    " ,isnull(afm1.COD_ACTIVIDAD_FORMULA,0) as codActividadCambioFormato" +
                                    " ,isnull(afm2.COD_ACTIVIDAD_FORMULA, 0) as codActividadLavado" +
                                    " ,isnull(sll.COD_MAQUINA_LAVADO,0) as COD_MAQUINA_LAVADO" +
                                    " ,isnull(sll.COD_PERSONAL_APRUEBA_DESPEJE,0) as COD_PERSONAL_APRUEBA_DESPEJE" +
                                    " ,isnull(sll.COD_ESTADO_HOJA,0) as COD_ESTADO_HOJA,sll.FECHA_CIERRE"+
                                    " ,isnull(conjunta.loteAsociado,'') as loteAsociado,isnull(conjunta.cantAsociado,0) as cantAsociado" +
                                    " ,isnull(cpp.NOMBRE_COLORPRESPRIMARIA,'') as colorPresPrim"+
                                    " from PROGRAMA_PRODUCCION pp inner join COMPONENTES_PROD cp on cp.COD_COMPPROD=pp.COD_COMPPROD"+
                                    " inner join FORMAS_FARMACEUTICAS f on f.cod_forma=cp.COD_FORMA"+
                                    " inner join productos p on p.cod_prod=cp.COD_PROD"+
                                    " inner join PRESENTACIONES_PRIMARIAS ppm on ppm.COD_COMPPROD=cp.COD_COMPPROD and ppm.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD"+
                                    " inner join ENVASES_PRIMARIOS ep on ep.cod_envaseprim=ppm.COD_ENVASEPRIM" +
                                    " inner join PROGRAMA_PRODUCCION_PERIODO ppp on pp.COD_PROGRAMA_PROD=ppp.COD_PROGRAMA_PROD" +
                                    " left outer join COMPONENTES_PROD_RECETA cpr on cpr.COD_COMPROD=cp.COD_COMPPROD" +
                                    " left outer join DESCRIPCION_PROCESOS_FORMA_FARMACEUTICA dpff on dpff.COD_FORMA=cp.COD_FORMA" +
                                    " left outer join SEGUIMIENTO_LAVADO_LOTE sll on sll.COD_LOTE=PP.COD_LOTE_PRODUCCION"+
                                    " and sll.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD" +
                                    " left outer join COLORES_PRESPRIMARIA cpp on cpp.COD_COLORPRESPRIMARIA=cp.COD_COLORPRESPRIMARIA" +
                                    " left outer join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_AREA_EMPRESA=96 and afm.COD_ACTIVIDAD=255"+
                                    "  and afm.COD_FORMULA_MAESTRA=pp.COD_FORMULA_MAESTRA and afm.COD_PRESENTACION=0"+
                                    "  left outer join ACTIVIDADES_FORMULA_MAESTRA afm1 on afm1.COD_AREA_EMPRESA=96 and afm1.COD_ACTIVIDAD=257"+
                                    "  and afm1.COD_FORMULA_MAESTRA=pp.COD_FORMULA_MAESTRA and afm1.COD_PRESENTACION=0" +
                                    " left outer join ACTIVIDADES_FORMULA_MAESTRA afm2 on afm2.COD_AREA_EMPRESA =96 and afm2.COD_ACTIVIDAD = 50" +
                                    " and afm2.COD_FORMULA_MAESTRA =pp.COD_FORMULA_MAESTRA and afm2.COD_PRESENTACION=0"+
                                    " outer APPLY(select top 1 ppc.COD_LOTE_PRODUCCION as loteAsociado,ppc.CANT_LOTE_PRODUCCION as cantAsociado"+
                                    " from LOTES_PRODUCCION_CONJUNTA lpc inner join PROGRAMA_PRODUCCION ppc on"+
                                    " lpc.COD_PROGRAMA_PROD=ppc.COD_PROGRAMA_PROD and lpc.COD_LOTE_PRODUCCION_ASOCIADO=ppc.COD_LOTE_PRODUCCION"+
                                    " where lpc.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD and lpc.COD_LOTE_PRODUCCION=pp.COD_LOTE_PRODUCCION) conjunta"+
                                    " where pp.COD_LOTE_PRODUCCION='"+codLote+"' and pp.cod_programa_prod='"+codprogramaProd+"'";
                    System.out.println("consulta cargar datos del lote "+consulta);
                    ResultSet res=st.executeQuery(consulta);
                    String codReceta="";
                    int cantidadAmpollas=0;
                    String nombreProducto="";
                    String registroSanitario="";
                    String volumen="";
                    String preIndicacionesLavado="";
                    String indicacionesLavado="";
                    String notaLavado="";
                    char b=13;char c=10;
                    Date fechaFinal=null;
                    if(res.next())
                    {
                        codForma=res.getInt("COD_FORMA");
                        codPersonalApruebaDespeje=res.getInt("COD_PERSONAL_APRUEBA_DESPEJE");
                        loteAsociado=res.getString("loteAsociado");
                        cantLoteAsociado=res.getInt("cantAsociado");
                        codPersonalSupervisor=res.getInt("COD_PERSONAL_SUPERVISOR");
                        fechaCierre=(res.getTimestamp("FECHA_CIERRE")!=null?res.getTimestamp("FECHA_CIERRE"):new Date());
                        codEstadoHoja=res.getInt("COD_ESTADO_HOJA");
                        codMaquinaLavado=res.getInt("COD_MAQUINA_LAVADO");
                        codActividadLavado=res.getInt("codActividadLavado");
                        codTipoProgramaProd=res.getInt("cod_tipo_programa_prod");
                        codFormulaMaestra=res.getInt("cod_formula_maestra");
                        codActividadRecepcion=res.getInt("codActividadRecepcion");
                        codActividadCambioFormato=res.getInt("codActividadCambioFormato");
                        
                        if((codActividadLavado==0||codActividadRecepcion==0||codActividadCambioFormato==0)&&codForma==2)
                        {
                            out.println("<script type='text/javascript'>alert('No se encuentran asociadas una o mas de las siguientes actividades:LAVADO DE AMPOLLAS,RECEPCION DE AMPOLLAS DE ALMACENES Y TRASLADO AL AREA,CAMBIO DE FORMATO DE LA MAQUINA PARA LAVADO DE AMPOLLAS');window.close();</script>");
                        }
                        codPersonalEncargadoRecepcion=res.getString("COD_PERSONAL_ENCARGADO_RECEPCION");
                        observaciones=res.getString("OBSERVACIONES");
                        codSeguimientoLavadoLote=res.getInt("codSeguimientoLavadoLote");
                        
                        notaLavado=res.getString("NOTA_LAVADO").replace(b,'\n').replace("\n", "</br>").replace("</br></br>","<br>");
                        preIndicacionesLavado=res.getString("PRE_INDICACIONES_LAVADO").replace(b,'\n').replace("\n", "</br>").replace("</br></br>","<br>");
                        indicacionesLavado=res.getString("INDICACIONES_LAVADO").replace(b,'\n').replace("\n", "</br>").replace("</br></br>","<br>");
                        volumen=res.getString("VOLUMEN_ENVASE_PRIMARIO");
                        nombreProducto=res.getString("nombre_prod");
                        
                        codReceta=res.getString("cod_receta_lavado");
                        cantidadAmpollas=res.getInt("CANT_LOTE_PRODUCCION");
                        registroSanitario=res.getString("REG_SANITARIO");
                        if(res.getDate("FECHA_FINAL")!=null)
                            {
                         Calendar cal = new GregorianCalendar();
                        cal.setTimeInMillis(res.getDate("FECHA_FINAL").getTime());
                        cal.add(Calendar.MONTH, res.getInt("vida_util"));


                       fechaFinal=new Date(cal.getTimeInMillis());
                        }
                        if(res.getString("cod_area_empresa").equals("81"))
                            {
                        consulta="select FECHA_VENCIMIENTO from INGRESOS_ALMACEN_DETALLE_ESTADO i inner join FORMULA_MAESTRA_DETALLE_EP fmdep on fmdep.COD_MATERIAL = i.COD_MATERIAL" +
                                " inner join FORMULA_MAESTRA fm on fm.COD_FORMULA_MAESTRA = fmdep.COD_FORMULA_MAESTRA inner join COMPONENTES_PROD cp on cp.COD_COMPPROD = fm.COD_COMPPROD " +
                                " where i.LOTE_MATERIAL_PROVEEDOR = '"+codLote+"' ";
                                Statement stdetalle=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                ResultSet resDet=stdetalle.executeQuery(consulta);
                                if(resDet.next())
                                {
                                    fechaFinal=resDet.getDate("FECHA_VENCIMIENTO");
                                }
                                resDet.close();
                                stdetalle.close();
                           }
                        %>

<section class="main">
                         <div class="row"  style="margin-top:5px" >
                                <div class="large-12 medium-12 small-12 large-centered medium-centered small-centered columns" >

                                            <div class="row">
                                               <div class="large-12 medium-12 small-12 columns divHeaderClass" >
                                                       <label  class="inline">Registro de Etapa de Lavado de Ampollas Vacias</label>
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
                                                               <span class="textHeaderClassBody"><%=(codLote+(loteAsociado.equals("")?"":"<br>"+loteAsociado) )%></span>
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
                                   <label  class="inline">DESPEJE DE LINEA DE LAVADO</label>
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

                              <%
                              }
                    operarios=UtilidadesTablet.operariosAreaProduccionAdminSelect(st,"81", codPersonal, administrador);
                              
                              %>

                                <script>
                                        fechaSistemaLavado="<%=(sdfDias.format(new Date()))%>"
                                        operariosRegistro="<%=(operarios)%>";
                                    </script>
<div class="row"  style="margin-top:5px" >
            <div class="large-12 medium-12 small-12 large-centered medium-centered small-centered columns" >

                        <div class="row">
                           <div class="large-12 medium-12 small-12 columns divHeaderClass" >
                                   <label  class="inline">LAVADO</label>
                            </div>
                        </div>
                        <div class="row" >

                                <div  class="divContentClass large-12 medium-12 small-12 columns">

                                
                                
                        <%
                        consulta="SELECT top 1 topl.COD_PERSONAL FROM TAREAS_OM_PERSONAL_LOTE topl where"+
                                 " topl.COD_PERSONAL='"+codPersonal+"' and topl.COD_LOTE='"+codLote+"' and topl.COD_PROGRAMA_PROD='"+codprogramaProd+"'"+
                                 " and topl.COD_TAREA_OM=3";
                        System.out.println("consulta verificar permiso recepcion "+consulta);
                        res=st.executeQuery(consulta);
                        if(res.next()||administrador)
                        {
                            out.println("<br><span>"+preIndicacionesLavado+"</span>");
                            permisoRecepcionAmpollas=true;
                            %>
                                
                                <div class="row">
                                    <div class="large-8 medium-10 small-12 large-centered medium-centered small-centered columns">
                                             <table style="width:100%;margin-top:2%" id="dataRecepcion" cellpadding="0px" cellspacing="0px">
                                                    <tr >
                                                           <td class="tableHeaderClass" style="text-align:center" >
                                                               <span class="textHeaderClass">&nbsp;</span><%--=nombreProducto--%>
                                                           </td>
                                                           <td class="tableHeaderClass" style="text-align:center;">
                                                               <span class="textHeaderClass">ESPECIFICACION</span>
                                                           </td>
                                                           <td class="tableHeaderClass" style="text-align:center;">
                                                               <span class="textHeaderClass">CONFORME</span>
                                                           </td>
                                                           <td class="tableHeaderClass" style="text-align:center;">
                                                               <span class="textHeaderClass">OBSERVACION</span>
                                                           </td>
                                                    </tr>
                                                    <tr >
                                                           <td class="tableCell" style="text-align:center">
                                                               <input type="hidden" value="1"/>
                                                               <span class="textHeaderClassBody" style="font-weight:normal">VOLUMEN</span>
                                                           </td>
                                                           <td class="tableCell" style="text-align:center;">
                                                               <span class="textHeaderClassBody" style="font-weight:normal"><%=volumen%></span>
                                                           </td>
                                                           <%
                                                                consulta="select isnull(s.CONFORME,0) as CONFORME,isnull(s.OBSERVACION,'') as OBSERVACION"+
                                                                         " from SEGUIMIENTO_RECEPCION_LAVADO_LOTE s where s.COD_SEGUIMIENTO_LAVADO_LOTE='"+codSeguimientoLavadoLote+"'"+
                                                                         " and s.NRO_SECUENCIA='1'";
                                                                boolean conforme=false;
                                                                String observacionRecepcion="";
                                                                res=st.executeQuery(consulta);
                                                                if(res.next())
                                                                {
                                                                    conforme=res.getInt("CONFORME")>0;
                                                                    observacionRecepcion=res.getString("OBSERVACION");
                                                                }

                                                           %>
                                                           <td class="tableCell" style="text-align:center">
                                                               <input type="checkbox" <%=(administrador?"disabled":"")%> style="width:20px;height:20px" <%=(conforme?"checked":"")%> >
                                                           </td>
                                                           <td class="tableCell" style="text-align:center">
                                                               <input class="textHeaderClassBody" <%=(administrador?"disabled":"")%>  type="text" value="<%=observacionRecepcion%>"/>
                                                           </td>
                                                       </tr>
                                                       <tr >
                                                           <td class="tableCell" style="text-align:center">
                                                               <input type="hidden" value="2"/>
                                                               <span class="textHeaderClassBody" style="font-weight:normal">TAMAÑO DEL LOTE TEORICO:</span>
                                                           </td>
                                                           <td class="tableCell" style="text-align:center;">
                                                               <span class="textHeaderClassBody" style="font-weight:normal"><%=cantidadAmpollas+(loteAsociado.equals("")?"":"<br>"+cantLoteAsociado)%></span>
                                                           </td>
                                                           <%
                                                                consulta="select isnull(s.CONFORME,0) as CONFORME,isnull(s.OBSERVACION,'') as OBSERVACION"+
                                                                         " from SEGUIMIENTO_RECEPCION_LAVADO_LOTE s where s.COD_SEGUIMIENTO_LAVADO_LOTE='"+codSeguimientoLavadoLote+"'"+
                                                                         " and s.NRO_SECUENCIA='2'";
                                                                conforme=false;
                                                                observacionRecepcion="";
                                                                res=st.executeQuery(consulta);
                                                                if(res.next())
                                                                {
                                                                    conforme=res.getInt("CONFORME")>0;
                                                                    observacionRecepcion=res.getString("OBSERVACION");
                                                                }

                                                           %>
                                                          <td class="tableCell" style="text-align:center">
                                                               <input type="checkbox" style="width:20px;height:20px" <%=(administrador?"disabled":"")%> <%=(conforme?"checked":"")%> >
                                                           </td>
                                                           <td class="tableCell" style="text-align:center">
                                                               <input class="textHeaderClassBody" type="text" <%=(administrador?"disabled":"")%> value="<%=observacionRecepcion%>"/>
                                                           </td>
                                                       </tr>
                                                        <tr >
                                                           <td class="tableCell" style="text-align:center">
                                                               <input type="hidden" value="3"/>
                                                               <span class="textHeaderClassBody" style="font-weight:normal">LOTE:</span>
                                                           </td>
                                                           <td class="tableCell" style="text-align:center;">
                                                               <span class="textHeaderClassBody" style="font-weight:normal"><%=codLote+(loteAsociado.equals("")?"":"<br>"+loteAsociado)%></span>
                                                           </td>
                                                            <%
                                                                consulta="select isnull(s.CONFORME,0) as CONFORME,isnull(s.OBSERVACION,'') as OBSERVACION"+
                                                                         " from SEGUIMIENTO_RECEPCION_LAVADO_LOTE s where s.COD_SEGUIMIENTO_LAVADO_LOTE='"+codSeguimientoLavadoLote+"'"+
                                                                         " and s.NRO_SECUENCIA='3'";
                                                                conforme=false;
                                                                observacionRecepcion="";
                                                                res=st.executeQuery(consulta);
                                                                if(res.next())
                                                                {
                                                                    conforme=res.getInt("CONFORME")>0;
                                                                    observacionRecepcion=res.getString("OBSERVACION");
                                                                }

                                                           %>
                                                          <td class="tableCell" style="text-align:center">
                                                               <input type="checkbox" style="width:20px;height:20px" <%=(administrador?"disabled":"")%> <%=(conforme?"checked":"")%> >
                                                           </td>
                                                           <td class="tableCell" style="text-align:center">
                                                               <input class="textHeaderClassBody" type="text" <%=(administrador?"disabled":"")%> value="<%=observacionRecepcion%>"/>
                                                           </td>
                                                       </tr>
                                                       <tr >
                                                           <td class="tableCell" style="text-align:center">
                                                               <input type="hidden" value="4"/>
                                                               <span class="textHeaderClassBody" style="font-weight:normal">EXPIRACION:</span>
                                                           </td>
                                                           <td class="tableCell" style="text-align:center;">
                                                               <span class="textHeaderClassBody" style="font-weight:normal"><%=(sdfLocal.format(fechaFinal))%></span>
                                                           </td>
                                                          <%
                                                                consulta="select isnull(s.CONFORME,0) as CONFORME,isnull(s.OBSERVACION,'') as OBSERVACION"+
                                                                         " from SEGUIMIENTO_RECEPCION_LAVADO_LOTE s where s.COD_SEGUIMIENTO_LAVADO_LOTE='"+codSeguimientoLavadoLote+"'"+
                                                                         " and s.NRO_SECUENCIA='4'";
                                                                conforme=false;
                                                                observacionRecepcion="";
                                                                res=st.executeQuery(consulta);
                                                                if(res.next())
                                                                {
                                                                    conforme=res.getInt("CONFORME")>0;
                                                                    observacionRecepcion=res.getString("OBSERVACION");
                                                                }

                                                           %>
                                                          <td class="tableCell" style="text-align:center">
                                                               <input type="checkbox" style="width:20px;height:20px" <%=(administrador?"disabled":"")%> <%=(conforme?"checked":"")%> >
                                                           </td>
                                                           <td class="tableCell" style="text-align:center">
                                                               <input class="textHeaderClassBody" type="text" <%=(administrador?"disabled":"")%> value="<%=observacionRecepcion%>"/>
                                                           </td>
                                                       </tr>
                                                       <tr >
                                                           <td class="tableCell" style="text-align:center">
                                                               <input type="hidden" value="5"/>
                                                               <span class="textHeaderClassBody" style="font-weight:normal">No DE REGISTRO SANITARIO:</span>
                                                           </td>
                                                           <td class="tableCell" style="text-align:center;">
                                                               <span class="textHeaderClassBody" style="font-weight:normal"><%=registroSanitario%></span>
                                                           </td>
                                                          <%
                                                                consulta="select isnull(s.CONFORME,0) as CONFORME,isnull(s.OBSERVACION,'') as OBSERVACION"+
                                                                         " from SEGUIMIENTO_RECEPCION_LAVADO_LOTE s where s.COD_SEGUIMIENTO_LAVADO_LOTE='"+codSeguimientoLavadoLote+"'"+
                                                                         " and s.NRO_SECUENCIA='5'";
                                                                conforme=false;
                                                                observacionRecepcion="";
                                                                res=st.executeQuery(consulta);
                                                                if(res.next())
                                                                {
                                                                    conforme=res.getInt("CONFORME")>0;
                                                                    observacionRecepcion=res.getString("OBSERVACION");
                                                                }

                                                           %>
                                                          <td class="tableCell" style="text-align:center">
                                                               <input type="checkbox" style="width:20px;height:20px" <%=(administrador?"disabled":"")%> <%=(conforme?"checked":"")%> >
                                                           </td>
                                                           <td class="tableCell" style="text-align:center">
                                                               <input class="textHeaderClassBody" type="text" <%=(administrador?"disabled":"")%> value="<%=observacionRecepcion%>"/>
                                                           </td>
                                                       </tr>
                                            </table>
                                </div>
                                <%
                                
                                consulta="SELECT sppp.FECHA_INICIO,sppp.FECHA_FINAL"+
                                         " FROM SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sppp "+
                                         " where sppp.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"' and sppp.COD_ACTIVIDAD_PROGRAMA='"+codActividadRecepcion+"'"+
                                         " and sppp.COD_PERSONAL='"+codPersonalEncargadoRecepcion+"' and sppp.COD_PROGRAMA_PROD='"+codprogramaProd+"' and sppp.COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"'"+
                                         " and sppp.COD_LOTE_PRODUCCION='"+codLote+"'";
                                System.out.println("consulta buscar tiempos personal recepcion "+consulta);
                                res=st.executeQuery(consulta);
                                
                                if(res.next())
                                {
                                    fechaSeguimiento=sdfDias.format(res.getTimestamp("FECHA_INICIO"));
                                    horaInicio=sdfHora.format(res.getTimestamp("FECHA_INICIO"));
                                    horaFinal=sdfHora.format(res.getTimestamp("FECHA_FINAL"));
                                }
                                %>
                                <center>
                                    
                                <table style="width:80%;margin-top:2px;border-bottom:solid #a80077 1px;" cellpadding="0px" cellspacing="0px" >
                                    <tr >
                                           <td class="tableHeaderClass" style="text-align:center" colspan="4">
                                               <span class="textHeaderClass">RECEPCION DE AMPOLLAS DE ALMACENES Y TRASLADO AL AREA</span>
                                           </td>
                                    </tr>
                                    <tr>
                                        <td style="border-left:solid #a80077 1px;text-align:left">
                                           <span >Personal</span>
                                       </td>
                                        <td style="text-align:left">
                                               <select id="codEncargadoRecepcion" <%=(administrador?"disabled":"")%> ><%out.println(operarios);%></select>
                                              <script>
                                                  codEncargadoRecepcion.value='<%=codPersonalEncargadoRecepcion%>';
                                             </script>
                                        </td>
                                        <td style="text-align:left">
                                           <span >Fecha</span>
                                        </td>
                                        <td style="text-align:left;border-right:solid #a80077 1px;">
                                            <input onclick="seleccionarDatePickerJs(this)" <%=(administrador?"disabled":"")%> type="text" value="<%=(fechaSeguimiento)%>" size="10" id="fechaRecepcions"/>
                                       </td>
                                    </tr>
                                    <tr>
                                            <td style="border-left:solid #a80077 1px;text-align:left">
                                               <span >Hora Inicio</span>
                                            </td>
                                           <td  style="text-align:center;" align="center">
                                               <input type="text" id="horaInicioRecepcion" onclick='seleccionarHora(this);' <%=(administrador?"disabled":"")%> value="<%=(horaInicio)%>" style="width:6em;"/>
                                           </td>
                                           <td style="text-align:left">
                                               <span >Hora Final</span>
                                           </td>
                                           <td style="border-right:solid #a80077 1px;text-align:center;" align="center">
                                               <input type="text" id="horaFinalRecepcion" onclick='seleccionarHora(this);' value="<%=(horaFinal)%>" <%=(administrador?"disabled":"")%> style="width:6em;"/>
                                           </td>
                                    </tr>
                                    <tr>
                                            <td align="center" style="border-right:solid #a80077 1px;border-left:solid #a80077 1px;" colspan="4">
                                                <div class="row">
                                                <div class="large-8 medium-10 small-12 large-centered medium-centered small-centered columns">
                                               <table id="dataPacksRecibidos" style="width:80%;margin-top:2px;" cellpadding="0px" cellspacing="0px" >
                                                    <tr>
                                                           <td class="tableHeaderClass" style="text-align:center;" >
                                                               <span class="textHeaderClass">N° de Packs Recibidos</span>
                                                           </td>
                                                           <td class="tableHeaderClass" style="text-align:center;" >
                                                               <span class="textHeaderClass">N° de Ampollas por Pack</span>
                                                           </td>
                                                           <td class="tableHeaderClass" style="text-align:center;" >
                                                               <span class="textHeaderClass">N° de Ampollas Recibidas</span>
                                                           </td>
                                                    </tr>
                                                    <%
                                                            consulta="SELECT spar.CANTIDAD_PACKS_AMPOLLAS,spar.CANTIDAD_AMPOLLAS_PACK"+
                                                                     " FROM SEGUIMIENTO_PACKS_AMPOLLAS_RECIBIDAS spar where spar.COD_SEGUIMIENTO_LAVADO_LOTE='"+codSeguimientoLavadoLote+"'"+
                                                                     " order by spar.CANTIDAD_PACKS_AMPOLLAS desc";
                                                            System.out.println("consulta cargar packs recibidos "+consulta);
                                                            res=st.executeQuery(consulta);
                                                            while(res.next())
                                                            {
                                                                sumaCantidadRecibidas+=(res.getInt("CANTIDAD_PACKS_AMPOLLAS")*res.getInt("CANTIDAD_AMPOLLAS_PACK"));
                                                                %>
                                                                <tr onclick="seleccionarFila(this);">
                                                                    <td class="tableCell">
                                                                        <input class="inputInterno"  type="tel" <%=(administrador?"disabled":"")%> onkeyup="calcularAmpollasRecibidas(this);" value="<%=(res.getInt("CANTIDAD_PACKS_AMPOLLAS"))%>"/>
                                                                    </td>
                                                                    <td class="tableCell">
                                                                        <input class="inputInterno" type="tel" <%=(administrador?"disabled":"")%> onkeyup="calcularAmpollasRecibidas(this);"  value="<%=(res.getInt("CANTIDAD_AMPOLLAS_PACK"))%>"/>
                                                                    </td>
                                                                     <td class="tableCell" align="center">
                                                                        <span class="textHeaderClassBody" style="font-weight:normal"><%=(res.getInt("CANTIDAD_AMPOLLAS_PACK")*res.getInt("CANTIDAD_PACKS_AMPOLLAS"))%></span>
                                                                    </td>
                                                                </tr>
                                                                <%
                                                            }
                                                    %>
                                               </table>
                                               </div></div>
                                                <div class="row" >
                                                        <div class="large-5 medium-3 small-2 columns" style="">&nbsp;</div>
                                                          <div class="large-1 medium-3 small-4 columns" >
                                                                <button <%=(administrador?"disabled":"")%>  style="font-size:1em;" class="small button succes radius buttonAction" onclick="nuevoRegistroRecepcionAmpollas()">+</button>
                                                          </div>
                                                          <div class="large-1 medium-3 small-4 columns">
                                                                    <button <%=(administrador?"disabled":"")%>  style="font-size:1em" class="small button succes radius buttonAction" onclick="eliminarRegistroTabla('dataPacksRecibidos');" >-</button>
                                                          </div>
                                                          <div class="large-4 medium-3 small-2 columns" style="">&nbsp;</div>
                                                  </div>
                                            </td>

                                    </tr>
                                </table>

                                </center>
                                </div>
                        <%
                        }
                         
                        consulta="SELECT top 1 topl.COD_PERSONAL FROM TAREAS_OM_PERSONAL_LOTE topl where"+
                                 " topl.COD_PERSONAL='"+codPersonal+"' and topl.COD_LOTE='"+codLote+"' and topl.COD_PROGRAMA_PROD='"+codprogramaProd+"'"+
                                 " and topl.COD_TAREA_OM=4";
                        System.out.println("consulta verificar permiso recepcion "+consulta);
                        res=st.executeQuery(consulta);
                        if(res.next()||administrador)
                        {
                            permisoLavado=true;
                        %>
                        
                        <center>
                        <%--span style="font-weight:bold;">Cambio de formato de la maquina?</span> <input style="margin-left:1em" type="checkbox" <%=(cambioFormato?"checked":"")%> id="cambioFormato" onclick="cambioFormatoChange(this)"/>
                       <div style="<%=(cambioFormato?"display:block;height:auto":"display:none;height:0px")%>" id="tablaCambioFormato"--%>
                       <table style="width:90%;margin-top:2%;" id="seguimientoCambioFormato"  cellpadding="0px" cellspacing="0px">
                                   <tr>
                                           <td colspan="4" class="tableHeaderClass" style="text-align:center" >
                                               <span class="textHeaderClass">Cambio de formato de la maquina:</span>
                                           </td>
                                    </tr>
                                   <tr>
                                      <td class="tableHeaderClass" style="text-align:center" >
                                           <span class="textHeaderClass">RESPONSABLE</span>
                                       </td>
                                       <td class="tableHeaderClass" style="text-align:center" >
                                           <span class="textHeaderClass">FECHA</span>
                                       </td>
                                       <td class="tableHeaderClass" style="text-align:center" >
                                           <span class="textHeaderClass">HORA INICIO</span>
                                       </td>
                                       <td class="tableHeaderClass" style="text-align:center" >
                                           <span class="textHeaderClass">HORA FINAL</span>
                                       </td>
                                   </tr>

                                    <%
                                        consulta="SELECT sppp.FECHA_INICIO,sppp.FECHA_FINAL,sppp.cod_personal"+
                                                 " FROM SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sppp "+
                                                 " where sppp.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"' and sppp.COD_ACTIVIDAD_PROGRAMA='"+codActividadCambioFormato+"'"+
                                                 "  and sppp.COD_PROGRAMA_PROD='"+codprogramaProd+"' and sppp.COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"'"+
                                                 " and sppp.COD_LOTE_PRODUCCION='"+codLote+"'"+
                                                 (administrador?"":" and sppp.COD_PERSONAL='"+codPersonal+"'" )+
                                                 " order by  sppp.FECHA_INICIO";
                                        System.out.println("consulta buscar tiempos cambio formato"+consulta);
                                        res=st.executeQuery(consulta);
                                        fechaSeguimiento=sdfDias.format(new Date());
                                        horaInicio=sdfHora.format(new Date());
                                        horaFinal=sdfHora.format(new Date());
                                        String codPersonalCambioFormato="";
                                        while(res.next())
                                        {
                                            codPersonalCambioFormato=res.getString("cod_personal");
                                            fechaSeguimiento=sdfDias.format(res.getTimestamp("FECHA_INICIO"));
                                            horaInicio=sdfHora.format(res.getTimestamp("FECHA_INICIO"));
                                            horaFinal=sdfHora.format(res.getTimestamp("FECHA_FINAL"));

                                    %>

                                    <tr onclick="seleccionarFila(this);" >
                                       <td class="tableCell">
                                        <select <%=(administrador?"disabled":"")%> id="codPersonalCambioFormato<%=(res.getRow())%>"><%out.println(operarios);%></select>
                                        <%
                                        out.println("<script>codPersonalCambioFormato"+res.getRow()+".value='"+codPersonalCambioFormato+"';</script>");
                                        %>


                                        </td>
                                        <td class="tableCell"  style="text-align:center;">
                                            <input <%=(administrador?"disabled":"")%> type="tel" onclick="seleccionarDatePickerJs(this)" value="<%=(fechaSeguimiento)%>" size="10" id="fechaCambioFormato<%=(res.getRow())%>"/>
                                        </td>
                                       <td class="tableCell"  style="text-align:center;" align="center">
                                           <center><input <%=(administrador?"disabled":"")%> type="text" id="horaInicioCambioFormato<%=(res.getRow())%>" onclick='seleccionarHora(this);' value="<%=(horaInicio)%>" style="width:6em;"/>
                                           </center>
                                       </td>
                                       <td class="tableCell"  style="text-align:center;" align="center">
                                           <center>
                                           <input <%=(administrador?"disabled":"")%> type="text" id="horaFinalCambioFormato<%=(res.getRow())%>" onclick='seleccionarHora(this);' value="<%=(horaFinal)%>" style="width:6em;"/>
                                           </center>
                                       </td>
                                    </tr>
                                    <%
                                    }
                                    %>
                                </table>
                                    <div class="row" >
                                        <div class="large-5 medium-5 small-4 columns" style="">&nbsp;</div>
                                          <div class="large-1 medium-1 small-2 columns" >
                                                <button <%=(administrador?"disabled":"")%> class="small button succes radius buttonAction" onclick="masCambioFormato('seguimientoCambioFormato')">+</button>
                                          </div>
                                          <div class="large-1 medium-1 small-2 columns">
                                                <button <%=(administrador?"disabled":"")%> class="small button succes radius buttonAction" onclick="eliminarRegistroTabla('seguimientoCambioFormato');" >-</button>
                                          </div>
                                          <div class="large-5 medium-5 small-4 columns" style="">&nbsp;</div>
                                  </div>
                            <%--/div--%>
                            <br>
                        </center>
                        <span><%=(indicacionesLavado)%></span>
                         <table style="width:100%;margin-top:2%" id="dataEspecificacionesLavado" cellpadding="0px" cellspacing="0px">
                             
                         
                        <%
                    consulta="select m.COD_MAQUINA,m.NOMBRE_MAQUINA,m.CODIGO"+
                             " from COMPONENTES_PROD_MAQUINARIA_LIMPIEZA cpml inner join MAQUINARIAS m on m.COD_MAQUINA=cpml.COD_MAQUINA"+
                             " where  m.COD_SECCION_ORDEN_MANUFACTURA=1 and cpml.COD_COMPPROD='"+codCompProd+"'";
                    System.out.println("consulta cargar maquinarias seccion "+consulta);
                    res=st.executeQuery(consulta);
                    maquinariasLavadoSelect="<option value='0'>--Seleccione una opcion--</option>";
                    while(res.next())
                    {
                        maquinariasLavadoSelect+="<option value='"+res.getInt("COD_MAQUINA")+"'>"+res.getString("NOMBRE_MAQUINA")+"("+res.getString("CODIGO")+")</option>";
                    }
                   String cabeceraPersonal="";
                   String innerCabeceraPersonal="";
                   String detallePersonal="";
                   int contDetalle=0;
                   if(administrador)
                    {
                        consulta="select s.COD_PERSONAL,(isnull(p.AP_PATERNO_PERSONAL,pt.AP_PATERNO_PERSONAL)+'<br>'+isnull(p.AP_MATERNO_PERSONAL,pt.AP_MATERNO_PERSONAL)+'<br>'+isnull(p.NOMBRES_PERSONAL,pt.NOMBRES_PERSONAL))as nombrePersonal"+
                                 " from SEGUIMIENTO_ESPECIFICACIONES_LAVADO_LOTE s left outer join personal p on"+
                                 " p.COD_PERSONAL=s.COD_PERSONAL"+
                                 " left outer join PERSONAL_TEMPORAL pt on pt.COD_PERSONAL=s.COD_PERSONAL"+
                                 " where s.COD_SEGUIMIENTO_LAVADO_LOTE='"+codSeguimientoLavadoLote+"'"+
                                 " group by s.COD_PERSONAL,p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRES_PERSONAL,pt.AP_PATERNO_PERSONAL,pt.AP_MATERNO_PERSONAL,pt.NOMBRES_PERSONAL"+
                                 " order by p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRES_PERSONAL";
                        System.out.println("consulta detalle esp "+consulta);
                        res=st.executeQuery(consulta);
                        while(res.next())
                        {
                            innerCabeceraPersonal+="<td colspan='2' class='tableHeaderClass' style='text-align:center;'><span class='textHeaderClass'>"+res.getString("nombrePersonal")+"</span></td>";
                            cabeceraPersonal+=",ISNULL(sedl"+res.getRow()+".CONFORME,0) as conforme"+res.getRow()+"," +
                                              "ISNULL(sedl"+res.getRow()+".OBSERVACION,'') as observacion"+res.getRow()+
                                              ",ISNULL(sedl"+res.getRow()+".VALOR_EXACTO, '') as VALOR_EXACTOESP"+res.getRow();
                            detallePersonal+=" left outer join SEGUIMIENTO_ESPECIFICACIONES_LAVADO_LOTE sedl"+res.getRow()+" on"+
                                             " sedl"+res.getRow()+".COD_ESPECIFICACION_PROCESO=ep.COD_ESPECIFICACION_PROCESO and "+
                                             " sedl"+res.getRow()+".COD_SEGUIMIENTO_LAVADO_LOTE = '"+codSeguimientoLavadoLote+"'" +
                                             " and sedl"+res.getRow()+".COD_PERSONAL='"+res.getInt("COD_PERSONAL")+"'";
                            contDetalle=res.getRow();
                        }

                    }
                    out.println("<tr><td class='tableHeaderClass' style='text-align:center' colspan='"+(contDetalle>0?(3+(contDetalle*2)):5)+"'><span class='textHeaderClass'>CONDICIONES DE LAVADO</span></td>"+
                               " </tr><tr><td class='tableHeaderClass' style='text-align:center' "+(contDetalle>0?"rowspan='2'":"")+"><span class='textHeaderClass'>CONDICIONES DEL PROCESO</span>"+
                                " </td><td class='tableHeaderClass' style='text-align:center;' colspan='2'  "+(contDetalle>0?"rowspan='2'":"")+" ><span class='textHeaderClass'>ESPECIFICACION</span></td>"+
                                (contDetalle>0?innerCabeceraPersonal+"</tr><tr>":" <td class='tableHeaderClass' style='text-align:center;'><span class='textHeaderClass'>Conforme</span></td>"+
                                " <td class='tableHeaderClass' style='text-align:center'><span class='textHeaderClass'>Observación</span></td>"));
                    for(int i=0;i<contDetalle;i++)out.println("<td class='tableHeaderClass' style='text-align:center;'><span class='textHeaderClass'>Conforme</span></td><td class='tableHeaderClass' style='text-align:center'><span class='textHeaderClass'>Observación</span></td>");
                    out.println("</tr>");
                    consulta="select ep.RESULTADO_ESPERADO_LOTE,ep.COD_TIPO_ESPECIFICACION_PROCESO,ep.RESULTADO_NUMERICO,ep.COD_ESPECIFICACION_PROCESO,ep.NOMBRE_ESPECIFICACIONES_PROCESO,"+
                             " isnull(um.NOMBRE_UNIDAD_MEDIDA,'N.A.') as NOMBRE_UNIDAD_MEDIDA" +
                             (administrador?cabeceraPersonal:",ISNULL(sell.CONFORME,0) as CONFORME,ISNULL(sell.OBSERVACION,'') as OBSERVACION,ISNULL(sell.VALOR_EXACTO, '') as VALOR_EXACTOESP")+
                             " ,case when ep.ESPECIFICACION_STANDAR_FORMA = 1 then ep.VALOR_EXACTO"+
                             " else rd.VALOR_EXACTO end as valorExacto, case"+
                             " when ep.ESPECIFICACION_STANDAR_FORMA = 1 THEN ep.VALOR_TEXTO"+
                             " else rd.VALOR_TEXTO end as valorTexto"+
                             " from ESPECIFICACIONES_PROCESOS ep left outer join UNIDADES_MEDIDA um"+
                             " on um.COD_UNIDAD_MEDIDA=ep.COD_UNIDAD_MEDIDA" +
                             " left outer join RECETAS_DESPIROGENIZADO rd on rd.COD_ESPECIFICACION_PROCESO=ep.COD_ESPECIFICACION_PROCESO"+
                             " and rd.COD_RECETA='"+codReceta+"'"+
                             (administrador?detallePersonal:" left outer join SEGUIMIENTO_ESPECIFICACIONES_LAVADO_LOTE sell on"+
                             " sell.COD_ESPECIFICACION_PROCESO=ep.COD_ESPECIFICACION_PROCESO"+
                             " and sell.COD_SEGUIMIENTO_LAVADO_LOTE='"+codSeguimientoLavadoLote+"'" +
                             " and sell.COD_PERSONAL='"+codPersonal+"'")+
                             " where ep.COD_FORMA='"+codForma+"' and ep.COD_PROCESO_ORDEN_MANUFACTURA=2"+
                             " order by case when ep.COD_TIPO_ESPECIFICACION_PROCESO=2 then 1 else 2 end, ep.ORDEN";
                    System.out.println("consulta esp "+consulta);
                    res=st.executeQuery(consulta);
                    
                    String valor="";
                    String nombreEspecificacion="";
                    String unidadMedida="";
                    boolean encontrado=false;
                    while(res.next())
                    {

                        valor=(res.getInt("RESULTADO_NUMERICO")>0?(res.getInt("valorExacto")>0?String.valueOf(res.getInt("valorExacto")):""):res.getString("valorTexto"));
                        nombreEspecificacion=res.getString("NOMBRE_ESPECIFICACIONES_PROCESO");
                        unidadMedida=res.getString("NOMBRE_UNIDAD_MEDIDA");
                        if(!encontrado&&res.getInt("COD_TIPO_ESPECIFICACION_PROCESO")!=2)
                        {
                            encontrado=true;
                            out.println("<tr ><td class='tableHeaderClass' style='text-align:center' colspan='3' align='center'><span class='textHeaderClass' style='line-height:1.5em'>CONDICIONES DEL EQUIPO</span>"+
                                        " <br> <select id='codMaquinaLavado' style='width:auto'>"+(maquinariasLavadoSelect)+"</select>"+
                                        " <script>codMaquinaLavado.value='"+codMaquinaLavado+"';</script></td>"+
                                        " <td class='tableHeaderClass' style='text-align:center;' colspan='"+(2+(contDetalle>0?((contDetalle-1)*2):0))+"'><span class='textHeaderClass'>CONDICIONES DE OPERACION DEL EQUIPO</span></td>"+
                                        " </tr><tr ><td class='tableHeaderClass' style='text-align:center'><span class='textHeaderClass'>&nbsp;</span></td>"+
                                        " <td class='tableHeaderClass' style='text-align:center;'><span class='textHeaderClass'>Valor</span></td>"+
                                        " <td class='tableHeaderClass' style='text-align:center'><span class='textHeaderClass'>Unidad.</span></td>");
                            if(administrador)
                            {
                                for(int i=1;i<=contDetalle;i++)
                                {
                                    out.println(" <td class='tableHeaderClass' style='text-align:center;'><span class'textHeaderClass'>Conforme</span></td>"+
                                        " <td class='tableHeaderClass' style='text-align:center'><span class='textHeaderClass'>Observación</span></td>");
                                }
                            }
                            else
                            {
                                out.println(" <td class='tableHeaderClass' style='text-align:center;'><span class'textHeaderClass'>Conforme</span></td>"+
                                        " <td class='tableHeaderClass' style='text-align:center'><span class='textHeaderClass'>Observación</span></td>");
                            }
                             out.println("</tr>");
                            %>
                             
                         <%
                        }
                        out.println("<tr>");
                        %>
                        
                           <td class="tableCell" style="text-align:center">
                               <input type="hidden" value="<%=res.getString("COD_ESPECIFICACION_PROCESO")%>">
                               <span class="textHeaderClassBody" style="font-weight:normal"><%=nombreEspecificacion%></span>
                           </td>
                           <td class="tableCell" style="text-align:center;">
                               <span class="textHeaderClassBody" style="font-weight:normal"><%=valor%></span>
                           </td>
                           <td class="tableCell" style="text-align:center">
                               <span class="textHeaderClassBody" style="font-weight:normal"><%=unidadMedida%></span>
                           </td>
                           
                       
                        <%
                        if(administrador)
                        {
                            for( int i=1;i<=contDetalle;i++)
                            {
                                out.println("<td class='tableCell' style='text-align:center'>"+(res.getInt("RESULTADO_ESPERADO_LOTE")==1?"<span class='textHeaderClassBody' style='font-weight:normal'>"+res.getDouble("VALOR_EXACTOESP"+i)+"</span>":"<input type='checkbox' style='width:20px;height:20px' disabled "+(res.getInt("conforme"+i)>0?"checked":"")+" >")+"</td>"+
                                        " <td class='tableCell' style='text-align:center'><span class='textHeaderClassBody' style='font-weight:normal'>"+(res.getString("observacion"+i))+"</span></td>");
                            }

                        }
                        else{
                            out.println("<td class='tableCell' style='text-align:center'>"+(res.getInt("RESULTADO_ESPERADO_LOTE")==1?"<input class='textHeaderClassBody' "+((res.getInt("COD_ESPECIFICACION_PROCESO")==23||res.getInt("COD_ESPECIFICACION_PROCESO")==25)?"disabled":"")+" id='numEsp"+res.getInt("COD_ESPECIFICACION_PROCESO")+"' type='tel' value='"+res.getDouble("VALOR_EXACTOESP")+"' style='text-align:right;font-weight:normal' size='4'/>":"<input type='checkbox' style='width:20px;height:20px' "+(res.getInt("conforme")>0?"checked":"")+" >")+"</td>"+
                                        " <td class='tableCell' style='text-align:center'><input class='textHeaderClassBody' type='text' value='"+(res.getString("observacion"))+"'/></td>");
                        }
                        
                        out.println("</tr>");
                    }
                    %>
                    <tr>
                          <td class="tableCell" style="min-width:25%;width:25%;text-align:center">
                               <span class="textHeaderClassBody" >NOTA:</span>
                           </td>
                           <td class="tableCell" colspan="<%=(contDetalle>0?(2+(contDetalle*2)):4)%>" style="text-align:center">
                                <span class="textHeaderClassBody" style="font-weight:normal"><%=(notaLavado)%></span>

                           </td>
                    </tr>
                    </table>
                    <center>
                         <div class="row">
                            <div class="large-12 medium-12 small-12 large-centered medium-centered small-centered columns">
                                <table style="border:none;width:100%;margin-top:4px;" id="dataSeguimientoLavado" cellpadding="0px" cellspacing="0px">
                                        <tr>
                                            <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>N°</span></td>
                                            <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>N° de Amp.<br>x Bandeja</span></td>
                                            <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>N° de <br>Bandejas</span></td>
                                            <td class='tableHeaderClass' style='text-align:center;' colspan=""><span class='textHeaderClass'>N° de Amp.<br>Totales</span></td>
                                            <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>N° de Amp.<br>Rotas</span></td>
                                            <td class='tableHeaderClass' style='text-align:center;' colspan=""><span class='textHeaderClass'>Obrero</span></td>
                                            <td class='tableHeaderClass' style='text-align:center;' colspan=""><span class='textHeaderClass'>Fecha</span></td>
                                            <td class='tableHeaderClass' style='text-align:center;' colspan=""><span class='textHeaderClass'>Hora<br> Inicio</span></td>
                                            <td class='tableHeaderClass' style='text-align:center;' colspan=""><span class='textHeaderClass'>Hora<br>Final</span></td>
                                        </tr>
                                        <%
                                        consulta=" SELECT sppp.HORAS_HOMBRE,sall.COD_REGISTRO_ORDEN_MANUFACTURA,sall.CANTIDAD_AMPOLLAS_BANDEJAS,sall.CANTIDAD_AMPOLLAS_ROTAS,"+
                                                 " isnull(sall.CANTIDAD_BANDEJAS,-1) as CANTIDAD_BANDEJAS,isnull(sall.COD_PERSONAL_OBRERO,sppp.COD_PERSONAL) as COD_PERSONAL,sppp.FECHA_INICIO,sppp.FECHA_FINAL,sppp.COD_LOTE_PRODUCCION"+
                                                 " FROM SEGUIMIENTO_AMPOLLAS_LAVADO_LOTE SALL full outer join SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sppp on"+
                                                 " sall.COD_PERSONAL_OBRERO = sppp.COD_PERSONAL and sall.COD_REGISTRO_ORDEN_MANUFACTURA = sppp.COD_REGISTRO_ORDEN_MANUFACTURA"+
                                                 " where (sppp.COD_LOTE_PRODUCCION = '"+codLote+"' and"+
                                                 "     sppp.COD_PROGRAMA_PROD = '"+codprogramaProd+"' and"+
                                                 "     sppp.COD_FORMULA_MAESTRA = '"+codFormulaMaestra+"' and"+
                                                 "     sppp.COD_ACTIVIDAD_PROGRAMA = '"+codActividadLavado+"' and"+
                                                 "     sppp.COD_TIPO_PROGRAMA_PROD = '"+codTipoProgramaProd+"'" +
                                                (administrador?"":" and sppp.cod_personal='"+codPersonal+"'")+
                                                 "     and sall.COD_SEGUIMIENTO_LAVADO_LOTE is null) or "+
                                                 "     (sall.COD_SEGUIMIENTO_LAVADO_LOTE = '"+codSeguimientoLavadoLote+"'" +
                                                 (administrador?"":" and sall.COD_PERSONAL_OBRERO='"+codPersonal+"'")+"" +
                                                 "     and sppp.COD_LOTE_PRODUCCION is NULL) or"+
                                                 "     (sppp.COD_LOTE_PRODUCCION = '"+codLote+"' and"+
                                                 "     sppp.COD_PROGRAMA_PROD = '"+codprogramaProd+"' and"+
                                                 "     sppp.COD_FORMULA_MAESTRA = '"+codFormulaMaestra+"' and"+
                                                 "     sppp.COD_ACTIVIDAD_PROGRAMA = '"+codActividadLavado+"' and"+
                                                 (administrador?"":" sppp.cod_personal='"+codPersonal+"' and ")+
                                                 "     sppp.COD_TIPO_PROGRAMA_PROD = '"+codTipoProgramaProd+"' and sall.COD_SEGUIMIENTO_LAVADO_LOTE ="+codSeguimientoLavadoLote+")"+
                                                 " order by sall.COD_REGISTRO_ORDEN_MANUFACTURA";
                                        
                                        System.out.println("consulta cargar seguimiento ampollas "+consulta);
                                        res=st.executeQuery(consulta);
                                        while(res.next())
                                        {
                                            sumaCantidadAmpollasRotas+=res.getInt("CANTIDAD_AMPOLLAS_ROTAS");
                                            sumaCantidadAmpollasLavadas+=(res.getInt("CANTIDAD_AMPOLLAS_BANDEJAS")*res.getInt("CANTIDAD_BANDEJAS"));
                                            %>
                                            <tr onclick="seleccionarFila(this);">
                                                        <td class="tableCell"  style="text-align:center">
                                                            <span class="textHeaderClassBody" style="font-weight:normal"><%=(res.getRow())%></span>
                                                       </td>
                                                       <td class="tableCell"  style="text-align:center;" align="center">
                                                               <input type="tel" <%=(administrador?"disabled":"")%>  onkeyup="calcularTotalAmpollas(this);" value="<%=(res.getInt("CANTIDAD_BANDEJAS")==-1?"":res.getInt("CANTIDAD_AMPOLLAS_BANDEJAS"))%>" style="width:6em;"/>
                                                           </td>
                                                           <td class="tableCell"  style="text-align:center;" align="center">
                                                               <input type="tel" <%=(administrador?"disabled":"")%> onkeyup="calcularTotalAmpollas(this);" value="<%=(res.getInt("CANTIDAD_BANDEJAS")==-1?"":res.getInt("CANTIDAD_BANDEJAS"))%>" style="width:6em;"/>
                                                           </td>
                                                           
                                                           <td class="tableCell"  style="text-align:center">
                                                               <input type="hidden" value="<%=(res.getDouble("HORAS_HOMBRE"))%>"/>
                                                                <span class="textHeaderClassBody" style="font-weight:normal"><%=(res.getInt("CANTIDAD_BANDEJAS")==-1?"Cantidades no registradas":(res.getInt("CANTIDAD_AMPOLLAS_BANDEJAS")*res.getInt("CANTIDAD_BANDEJAS")))%></span>
                                                           </td>
                                                           <td class="tableCell"  style="text-align:center;" align="center">
                                                               <input type="tel" <%=(administrador?"disabled":"")%>  onkeyup="sumaAmpollasRotas();" value="<%=(res.getInt("CANTIDAD_AMPOLLAS_ROTAS"))%>" style="width:6em;"/>
                                                           </td>
                                                           <td class="tableCell">
                                                                <select <%=(administrador?"disabled":"")%> id="codLavadop<%=(res.getRow())%>"><%out.println(operarios);%></select>
                                                                <%
                                                                out.println("<script>codLavadop"+res.getRow()+".value='"+res.getInt("COD_PERSONAL")+"';</script>");
                                                                 %>

                                                            </td>
                                                            <td class="tableCell"  style="text-align:center;">
                                                                <input type="text" <%=(administrador?"disabled":"")%> onclick="seleccionarDatePickerJs(this)" value="<%=(res.getTimestamp("FECHA_INICIO")!=null?sdfDias.format(res.getTimestamp("FECHA_INICIO")):"")%>" size="10" id="fechap<%=(res.getRow())%>"/>
                                                           </td>
                                                           
                                                           
                                                           <td class="tableCell"  style="text-align:center;" align="center">
                                                               <input type="text" <%=(administrador?"disabled":"")%> onclick='seleccionarHora(this);' id="fechaIniAmpolla<%=(res.getRow())%>" onfocus="calcularHorasHombre(this)" value="<%=(res.getTimestamp("FECHA_INICIO")!=null?sdfHora.format(res.getTimestamp("FECHA_INICIO")):"")%>" style="width:6em;"/>
                                                           </td>
                                                           <td class="tableCell"  style="text-align:center;" align="center">
                                                               <input type="text" <%=(administrador?"disabled":"")%> onclick='seleccionarHora(this);' id="fechaFinAmpolla<%=(res.getRow())%>" onfocus="calcularHorasHombre(this)" value="<%=(res.getTimestamp("FECHA_INICIO")!=null?sdfHora.format(res.getTimestamp("FECHA_FINAL")):"")%>" style="width:6em;"/>
                                                           </td>
                                                        </tr>
                                            <%
                                        }
                                        %>
                                </table>
                                <div class="row" >
                                    <div class="large-5 medium-5 small-4 columns" style="">&nbsp;</div>
                                      <div class="large-1 medium-1 small-2 columns" >
                                            <button <%=(administrador?"disabled":"")%> class="small button succes radius buttonAction" onclick="nuevoRegistro('dataSeguimientoLavado')">+</button>
                                      </div>
                                      <div class="large-1 medium-1 small-2 columns">
                                            <button <%=(administrador?"disabled":"")%> class="small button succes radius buttonAction" onclick="eliminarRegistroTabla('dataSeguimientoLavado');" >-</button>
                                      </div>
                                      <div class="large-5 medium-5 small-4 columns" style="">&nbsp;</div>
                              </div>
                            </div>
                         </div>
                         <%
                         }
                        if(administrador)
                        {
                         %>
                         <center>
                             <table style="width:80%;margin-top:2px;border-bottom:solid #a80077 1px;" id="rsendimiento" cellpadding="0px" cellspacing="0px" >
                                    <tr >
                                           <td class="tableHeaderClass" style="text-align:center" colspan="3">
                                               <span class="textHeaderClass">RENDIMIENTO DEL PROCESO DE LAVADO</span>
                                           </td>
                                    </tr>
                                    <tr >
                                            <td style="border-left:solid #a80077 1px;text-align:left">
                                               <span >Cantidad de ampollas teoricas recibidas</span>
                                           </td>
                                            <td style="text-align:left">
                                               <span >&nbsp;</span>
                                           </td>
                                            <td style="text-align:left;border-right:solid #a80077 1px;">
                                               <span id="cantidadLote" ><%=(sumaCantidadRecibidas)%></span>
                                           </td>
                                    </tr>
                                    <tr>
                                            <td style="border-left:solid #a80077 1px;text-align:left">
                                               <span >Cantidad de ampollas teoricas lavadas</span>
                                           </td>
                                            <td style="text-align:left;">
                                               <span >&nbsp;</span>
                                           </td>
                                            <td style="border-right:solid #a80077 1px;text-align:left">
                                               <span id="sumaCantidad" ><%=(sumaCantidadAmpollasLavadas)%></span>
                                           </td>
                                    </tr>
                                    <tr>
                                            <td style="border-left:solid #a80077 1px;text-align:left">
                                               <span >Cantidad de ampollas rotas</span>
                                           </td>
                                            <td style="text-align:left;">
                                               <span >&nbsp;</span>
                                           </td>
                                            <td style="border-right:solid #a80077 1px;text-align:left">
                                                <span id="cantidadAmpollasRotas" ><%=(sumaCantidadAmpollasRotas)%></span>
                                               <%--input type="text" id="cantidadAmpollasRotas" onkeyup="sumaRendimiento();" value="<%=(cantidadAmpollasRotas)%>"/--%>
                                           </td>
                                    </tr>
                                    <tr>
                                            <td class="" style="border-left:solid #a80077 1px;text-align:left">
                                               <span >Rendimiento Final</span>
                                           </td>
                                            <td class="" style="text-align:left">
                                               <span >&nbsp;</span>
                                           </td>
                                            <td class="" style="border-right:solid #a80077 1px;text-align:left">
                                                <span id="rendimiento" ><%=format.format(((Double.valueOf(sumaCantidadAmpollasLavadas-sumaCantidadAmpollasRotas))/Double.valueOf(sumaCantidadRecibidas))*100)%></span>
                                           </td>
                                    </tr>
                                </table>

                         </center>
                    
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
                                <%consulta="select (p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL+' '+p.nombre2_personal)"+
                                 " from PERSONAL p where p.COD_PERSONAL='"+(Integer.valueOf(codPersonalSupervisor)>0?codPersonalSupervisor:codPersonal)+"'";
                                 res=st.executeQuery(consulta);
                                 String nombreUsuario="";
                                 if(res.next())
                                 {
                                     nombreUsuario=res.getString(1);
                                 }
                                %>
                                <td style="border-right:solid #a80077 1px;text-align:left">
                                   <span><%=(nombreUsuario)%></span>
                                    <input type="hidden" value="<%=(codPersonalSupervisor)%>"/>
                               </td>

                        </tr>
                        <tr>
                                <td style="border-left:solid #a80077 1px;text-align:left">
                                   <span >Fecha:</span>
                               </td>

                                <td style="border-right:solid #a80077 1px;text-align:left">
                                   <span id="fecha" ><%=sdfDias.format(fechaCierre)%></span>
                               </td>
                        </tr>
                        <tr>
                                <td style="border-left:solid #a80077 1px;text-align:left">
                                   <span >Hora:</span>
                               </td>

                                <td style="border-right:solid #a80077 1px;text-align:left">
                                   <span id="fecha" ><%=sdfHora.format(fechaCierre)%></span>
                               </td>
                        </tr>
                        <tr>
                                <td class="" style="border-left:solid #a80077 1px;text-align:left">
                                   <span >Observacion</span>
                               </td>

                                <td class="" style="border-right:solid #a80077 1px;text-align:left">
                                    <input type="text" id="observacion" value="<%=observaciones%>"/>
                               </td>
                        </tr>
                    </table>
                    </center>
                    <%
                    }
                    %>
                          

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
                                    <button class="small button succes radius buttonAction" onclick="guardarLavado();" >Guardar</button>
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
        <input type="hidden" value="<%=(codPersonalSupervisor)%>" id="cerrado"/>
        <input type="hidden" value="<%=(permisoLavado?1:0)%>" id="permisoLavado"/>
        <input type="hidden" value="<%=(permisoRecepcionAmpollas?1:0)%>" id="permisoRecepcionAmpollas"/>
        <input type="hidden" id="codLoteSeguimiento" value="<%=codLote%>"/>
        <input type="hidden" id="codprogramaProd" value="<%=(codprogramaProd)%>"/>
        <input type="hidden" id="codFormulaMaestra" value="<%=(codFormulaMaestra)%>"/>
        <input type="hidden" id="codTipoProgramaProd" value="<%=(codTipoProgramaProd)%>"/>
        <input type="hidden" id="codCompProd" value="<%=(codCompProd)%>"/>
        <input type="hidden" id="codActividadCambioFormato" value="<%=(codActividadCambioFormato)%>"/>
        <input type="hidden" id="codActividadLavado" value="<%=(codActividadLavado)%>"/>
        <input type="hidden" id="codActividadRecepcion" value="<%=(codActividadRecepcion)%>"/>
        <input type="hidden" id="codSeguimientoLavadoLote" value="<%=(codSeguimientoLavadoLote)%>"/>
        
        </section>
    </body>
    <script src="../../reponse/js/timePickerJs.js"></script>
    <script src="../../reponse/js/dataPickerJs.js"></script>
    <script src="../../reponse/js/despejeLinea.js"></script>
    <script>despejeLinea.verificarDespejeLinea('<%=(codPersonalApruebaDespeje)%>', admin,'codprogramaProd','codLoteSeguimiento',3,<%=(codPersonal)%>);
            iniciarDatePicker('<%=(sdfDias.format(new Date()))%>');
            loginHoja.verificarHojaCerrada('cerrado', admin,'codprogramaProd','codLoteSeguimiento',3,<%=(codEstadoHoja)%>);</script>
</html>
