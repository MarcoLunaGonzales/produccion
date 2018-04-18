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
        var limpiezaSecciones=document.getElementById('dataLimpiezaSecciones');
        var codLote=document.getElementById('codLoteSeguimiento').value;
        var codProgramaProd=document.getElementById('codProgramaProd').value;
        var cont=0;
        var dataLimpiezaSecciones=new Array();
        var limpiezaEquipos=document.getElementById("dataLimpiezaMaquinarias");
        var dataLimpiezaEquipos=new Array();
        var limpiezaUtensilios=document.getElementById("dataLimpiezaUtensilios");
        var dataUtensilios=new Array();
        var limpiezaFiltros=document.getElementById("dataLimpiezaFiltros");
        var dataFiltros=new Array();
        var dataSegEstUtensilios=new Array();
        var tablaSegEstUtensilios=document.getElementById("dataTiemEsterilizacionUtensilios");
        var dataSegFiltros=new Array();
        var tablaSegEstFiltros=document.getElementById("dataTiemEsterilizacionFiltros");
        if(!admin)
        {
                for(var i=3;i<limpiezaSecciones.rows.length;i++)
                {
                   if(parseInt(limpiezaSecciones.rows[i].cells[1].getElementsByTagName('select')[0].value)!=0)
                   {
                           if(validarSeleccionRegistro(limpiezaSecciones.rows[i].cells[1].getElementsByTagName('select')[0])&&
                            validarSeleccionRegistro(limpiezaSecciones.rows[i].cells[2].getElementsByTagName('select')[0])&&
                           validarFechaRegistro(limpiezaSecciones.rows[i].cells[5].getElementsByTagName('input')[0])&&
                           validarHoraRegistro(limpiezaSecciones.rows[i].cells[6].getElementsByTagName('input')[0])&&
                           validarHoraRegistro(limpiezaSecciones.rows[i].cells[7].getElementsByTagName('input')[0])&&
                           validarRegistrosHorasNoNegativas(limpiezaSecciones.rows[i].cells[6].getElementsByTagName('input')[0],limpiezaSecciones.rows[i].cells[7].getElementsByTagName('input')[0])&&
                           validarSeleccionTipoLimpieza(limpiezaSecciones.rows[i].cells[3].getElementsByTagName('input')[0],limpiezaSecciones.rows[i].cells[4].getElementsByTagName('input')[0]))
                           {
                                var input=limpiezaSecciones.rows[i].cells[0].getElementsByTagName('input');
                                if(input.length>0)
                                {
                                    dataLimpiezaSecciones[cont]=input[0].value;
                                }
                                else
                                {
                                    dataLimpiezaSecciones[cont]=limpiezaSecciones.rows[i].cells[0].getElementsByTagName('select')[0].value;
                                    console.log('entro select');
                                }
                                cont++;
                                dataLimpiezaSecciones[cont]=limpiezaSecciones.rows[i].cells[1].getElementsByTagName('select')[0].value;
                                cont++;
                                dataLimpiezaSecciones[cont]=limpiezaSecciones.rows[i].cells[2].getElementsByTagName('select')[0].value;
                                cont++;
                                dataLimpiezaSecciones[cont]=(limpiezaSecciones.rows[i].cells[3].getElementsByTagName('input')[0].checked?'1':'0');
                                cont++;
                                dataLimpiezaSecciones[cont]=(limpiezaSecciones.rows[i].cells[4].getElementsByTagName('input')[0].checked?'1':'0');
                                cont++;
                                dataLimpiezaSecciones[cont]=limpiezaSecciones.rows[i].cells[5].getElementsByTagName('input')[0].value;
                                cont++;
                                dataLimpiezaSecciones[cont]=limpiezaSecciones.rows[i].cells[6].getElementsByTagName('input')[0].value;
                                cont++;
                                dataLimpiezaSecciones[cont]=limpiezaSecciones.rows[i].cells[7].getElementsByTagName('input')[0].value;
                                cont++;
                                dataLimpiezaSecciones[cont]=getNumeroDehoras((dataLimpiezaSecciones[cont-3]+' '+dataLimpiezaSecciones[cont-2]),(dataLimpiezaSecciones[cont-3]+' '+dataLimpiezaSecciones[cont-1]));
                                cont++;
                                dataLimpiezaSecciones[cont]=(input.length>0?'1':'2');
                                cont++;

                           }
                           else
                           {
                               ocultarPanelProgreso();
                               return false;
                           }
                   }
                }
                cont=0;
                for(var i=3;i<limpiezaEquipos.rows.length;i++)
                {
                    if(parseInt(limpiezaEquipos.rows[i].cells[1].getElementsByTagName('select')[0].value)!=0)
                    {
                        if(validarSeleccionRegistro(limpiezaEquipos.rows[i].cells[1].getElementsByTagName('select')[0])&&
                           validarSeleccionRegistro(limpiezaEquipos.rows[i].cells[2].getElementsByTagName('select')[0])&&
                           validarFechaRegistro(limpiezaEquipos.rows[i].cells[5].getElementsByTagName('input')[0])&&
                           validarHoraRegistro(limpiezaEquipos.rows[i].cells[6].getElementsByTagName('input')[0])&&
                           validarHoraRegistro(limpiezaEquipos.rows[i].cells[7].getElementsByTagName('input')[0])&&
                           validarRegistrosHorasNoNegativas(limpiezaEquipos.rows[i].cells[6].getElementsByTagName('input')[0],limpiezaEquipos.rows[i].cells[7].getElementsByTagName('input')[0])&&
                           validarSeleccionTipoLimpieza(limpiezaEquipos.rows[i].cells[3].getElementsByTagName('input')[0], limpiezaEquipos.rows[i].cells[4].getElementsByTagName('input')[0]))
                           {
                               var inputsCelda=limpiezaEquipos.rows[i].cells[0].getElementsByTagName('input');
                               if(inputsCelda.length>1)
                               {
                                    dataLimpiezaEquipos[cont]=inputsCelda[0].value;
                                    cont++;
                                    dataLimpiezaEquipos[cont]=inputsCelda[1].value;
                                    cont++;
                               }
                               else
                               {
                                    dataLimpiezaEquipos[cont]=limpiezaEquipos.rows[i].cells[0].getElementsByTagName('select')[0].value.split("-")[0];
                                    cont++;
                                    dataLimpiezaEquipos[cont]=limpiezaEquipos.rows[i].cells[0].getElementsByTagName('select')[0].value.split("-")[1];
                                    cont++;
                               }
                                dataLimpiezaEquipos[cont]=limpiezaEquipos.rows[i].cells[1].getElementsByTagName('select')[0].value;
                                cont++;
                                dataLimpiezaEquipos[cont]=limpiezaEquipos.rows[i].cells[2].getElementsByTagName('select')[0].value;
                                cont++;
                                dataLimpiezaEquipos[cont]=(limpiezaEquipos.rows[i].cells[3].getElementsByTagName('input')[0].checked?"1":"0");
                                cont++;
                                dataLimpiezaEquipos[cont]=(limpiezaEquipos.rows[i].cells[4].getElementsByTagName('input')[0].checked?"1":"0");
                                cont++;
                                dataLimpiezaEquipos[cont]=limpiezaEquipos.rows[i].cells[5].getElementsByTagName('input')[0].value;
                                cont++;
                                dataLimpiezaEquipos[cont]=limpiezaEquipos.rows[i].cells[6].getElementsByTagName('input')[0].value;
                                cont++;
                                dataLimpiezaEquipos[cont]=limpiezaEquipos.rows[i].cells[7].getElementsByTagName('input')[0].value;
                                cont++;
                                dataLimpiezaEquipos[cont]=getNumeroDehoras((dataLimpiezaEquipos[cont-3]+' '+dataLimpiezaEquipos[cont-2]),(dataLimpiezaEquipos[cont-3]+' '+dataLimpiezaEquipos[cont-1]));
                                cont++;
                                dataLimpiezaEquipos[cont]=(inputsCelda.length>1?"1":"2");
                                cont++
                        }
                        else
                        {
                            ocultarPanelProgreso();
                            return false;
                        }
                    }
                }
                cont=0;
                for(var n=1;n<limpiezaUtensilios.rows.length;n++)
                {
                    if(limpiezaUtensilios.rows[n].cells[0].getElementsByTagName('input')[0].checked)
                    {
                        dataUtensilios[dataUtensilios.length]=limpiezaUtensilios.rows[n].cells[1].getElementsByTagName('input')[0].value;
                    }
                }
                cont=0;
                for(var i=1;i<limpiezaFiltros.rows.length;i++)
                {
                    if(limpiezaFiltros.rows[i].cells[0].getElementsByTagName('input')[0].checked)
                    {
                        dataFiltros[dataFiltros.length]=limpiezaFiltros.rows[i].cells[1].getElementsByTagName('input')[0].value;
                    }
                }
                cont=0;
                for(var j=2;j<tablaSegEstUtensilios.rows.length;j++)
                {
                    if(validarSeleccionRegistro(tablaSegEstUtensilios.rows[j].cells[0].getElementsByTagName('select')[0])&&
                       validarFechaRegistro(tablaSegEstUtensilios.rows[j].cells[1].getElementsByTagName('input')[0])&&
                       validarHoraRegistro(tablaSegEstUtensilios.rows[j].cells[2].getElementsByTagName('input')[0])&&
                       validarHoraRegistro(tablaSegEstUtensilios.rows[j].cells[3].getElementsByTagName('input')[0])&&
                       validarRegistrosHorasNoNegativas(tablaSegEstUtensilios.rows[j].cells[2].getElementsByTagName('input')[0],tablaSegEstUtensilios.rows[j].cells[3].getElementsByTagName('input')[0]) )
                       {
                            dataSegEstUtensilios[dataSegEstUtensilios.length]=tablaSegEstUtensilios.rows[j].cells[0].getElementsByTagName('select')[0].value;
                            dataSegEstUtensilios[dataSegEstUtensilios.length]=tablaSegEstUtensilios.rows[j].cells[1].getElementsByTagName('input')[0].value;
                            dataSegEstUtensilios[dataSegEstUtensilios.length]=tablaSegEstUtensilios.rows[j].cells[2].getElementsByTagName('input')[0].value;
                            dataSegEstUtensilios[dataSegEstUtensilios.length]=tablaSegEstUtensilios.rows[j].cells[3].getElementsByTagName('input')[0].value;
                            dataSegEstUtensilios[dataSegEstUtensilios.length]=parseFloat(tablaSegEstUtensilios.rows[j].cells[4].getElementsByTagName('span')[0].innerHTML);
                            
                       }
                       else
                       {
                           ocultarPanelProgreso();
                            return false;
                       }
                }
                cont=0;
                for(var j=2;j<tablaSegEstFiltros.rows.length;j++)
                {
                    if(validarSeleccionRegistro(tablaSegEstFiltros.rows[j].cells[0].getElementsByTagName('select')[0])&&
                       validarFechaRegistro(tablaSegEstFiltros.rows[j].cells[1].getElementsByTagName('input')[0])&&
                       validarHoraRegistro(tablaSegEstFiltros.rows[j].cells[2].getElementsByTagName('input')[0])&&
                       validarHoraRegistro(tablaSegEstFiltros.rows[j].cells[3].getElementsByTagName('input')[0])&&
                       validarRegistrosHorasNoNegativas(tablaSegEstFiltros.rows[j].cells[2].getElementsByTagName('input')[0],tablaSegEstFiltros.rows[j].cells[3].getElementsByTagName('input')[0]))
                       {
                            dataSegFiltros[dataSegFiltros.length]=tablaSegEstFiltros.rows[j].cells[0].getElementsByTagName('select')[0].value;
                            dataSegFiltros[dataSegFiltros.length]=tablaSegEstFiltros.rows[j].cells[1].getElementsByTagName('input')[0].value;
                            dataSegFiltros[dataSegFiltros.length]=tablaSegEstFiltros.rows[j].cells[2].getElementsByTagName('input')[0].value;
                            dataSegFiltros[dataSegFiltros.length]=tablaSegEstFiltros.rows[j].cells[3].getElementsByTagName('input')[0].value;
                            dataSegFiltros[dataSegFiltros.length]=parseFloat(tablaSegEstFiltros.rows[j].cells[4].getElementsByTagName('span')[0].innerHTML);
                       }
                       else
                       {
                           ocultarPanelProgreso();
                           return false;
                       }
                }
        }
            var date=new Date();
            var peticion="ajaxGuardarRegistroLimpieza.jsf?fecha="+date.getYear()+"/"+date.getMonth()+"/"+date.getDay()+"&codLote="+codLote+"&noCache="+ Math.random()+
             "&codProgProd="+codProgramaProd+"&codSeguimiento="+document.getElementById("codSeguimientoLimpiezaLote").value+
             "&codCompProd="+document.getElementById("codCompProd").value+"&codTipoProgramaProd="+document.getElementById("codTipoProgramaProd").value+
             "&codFormulaMaestra="+document.getElementById("codFormulaMaestra").value+
             "&codActividadAutoclave="+document.getElementById("codActividadAutoclave").value+"&codActividadDosificado="+document.getElementById("codActividadDosificado").value+
             "&codActividadLavadoAmp="+document.getElementById("codActividadLavadoAmp").value+"&codActividadPreparado="+document.getElementById("codActividadPreparado").value+
             "&codActividadEstFiltro="+document.getElementById("codActividadEsterilizacionFiltro").value+
             "&codActividadEstUtensilios="+document.getElementById("codActividadEsterilizacionUtensilios").value+
             "&dataSecciones="+dataLimpiezaSecciones+"&dataLimpiezaEquipos="+dataLimpiezaEquipos+"&dataUtensilios="+dataUtensilios+
             "&dataFiltros="+dataFiltros+"&dataSegUtensilios="+dataSegEstUtensilios+"&dataSegFiltros="+dataSegFiltros+
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
    function nuevoRegistro(nombreTabla,esSeccion)
   {
       contRegistro++;
       var table = document.getElementById(nombreTabla);
       var rowCount = table.rows.length;
       var row = table.insertRow(rowCount);
       row.onclick=function(){seleccionarFila(this);};
       var cell1 = row.insertCell(0);
       cell1.className="tableCell";
       var element1 = document.createElement("select");
       element1.innerHTML=(esSeccion?seccionesSelect:maquinariasSelect);
       cell1.appendChild(element1);

       var cell2 = row.insertCell(1);
       cell2.className="tableCell";
       var element2 = document.createElement("select");
       element2.innerHTML=operariosLimpieza;
       cell2.appendChild(element2);


       var cell3= row.insertCell(2);
       cell3.className="tableCell";
       

       var element3 = document.createElement("select");
       element3.innerHTML=sanitizantesSelect;
       cell3.appendChild(element3);

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

       var cell6 = row.insertCell(5);
       cell6.className="tableCell";
       var element6 = document.createElement("input");
       element6.id="fechaRegistroCreado"+contRegistro;
       element6.type = "text";
       element6.onclick=function(){seleccionarDatePickerJs(this);};
       element6.value=fechaRegistroNuevo;
       cell6.appendChild(element6);
       

       var cell7=row.insertCell(6);
       cell7.className='tableCell';
       var element7=document.createElement("input");
       element7.type="text";
       element7.value=getHoraActualString();
       element7.onclick=function(){seleccionarHora(this);};
       element7.id='fechaIniAdd'+contRegistro;
       element7.style.width='6em';
       cell7.appendChild(element7);

       var cell8=row.insertCell(7);
       cell8.className='tableCell';
       var element8=document.createElement("input");
       element8.type="text";
       element8.value=getHoraActualString();
       element8.style.width='6em';
       element8.onclick=function(){seleccionarHora(this);};
       element8.id='fechaFinAdd'+contRegistro;
       cell8.appendChild(element8);
       
  }
  
  function  masSeguimiento(nombreTabla)
   {
       contRegistro++;
       var table = document.getElementById(nombreTabla);
       var rowCount = table.rows.length;
       var row = table.insertRow(rowCount);
       row.onclick=function(){seleccionarFila(this);};
       var cell1 = row.insertCell(0);
       cell1.className="tableCell";
       var element1 = document.createElement("select");
       element1.innerHTML=operariosLimpieza;
       cell1.appendChild(element1);
        var cell2 = row.insertCell(1);
       cell2.className="tableCell";
       var element2 = document.createElement("input");
       element2.id="fechaTiempo"+contRegistro;
       element2.type = "text";
       element2.onclick=function(){seleccionarDatePickerJs(this);};
       element2.value=fechaRegistroNuevo;
       cell2.appendChild(element2);
       
   
       for(var i=0;i<2;i++)
       {
           var cell3 = row.insertCell(i+2);
           cell3.className="tableCell";
           var element3 = document.createElement("input");
           element3.type = "text";
           cell3.align='center';
           element3.style.width='6em';
           element3.value=getHoraActualString();
           element3.id='hora'+i+'t'+contRegistro;
           element3.onkeyup=function(){calcularDiferenciaHoras(this);};
           element3.onfocus=function(){calcularDiferenciaHoras(this);};
           element3.onclick=function(){seleccionarHora(this);};
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
  function onChangeEstado(checkbox)
  {
      checkbox.checked=true;
      if(checkbox.parentNode.cellIndex==4)
      {
          checkbox.parentNode.parentNode.cells[3].getElementsByTagName("input")[0].checked=false;
      }
      else
      {
          checkbox.parentNode.parentNode.cells[4].getElementsByTagName("input")[0].checked=false;
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
        int codActividadEsterilizacionFiltro=0;
        int codActividadEsterilizacionUtensilios=0;
        int codActividadAutoclave=0;
        int codActividadDosificado=0;
        int codActividadLavadoAmp=0;
        int codActividadPreparado=0;
        int codFormulaMaestra=0;
        int codCompProd=0;
        int codTipoProgramaProd=0;
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
                                    " ,isnull(afm.COD_ACTIVIDAD_FORMULA,0) as codActividadAutoclave,"+
                                    " isnull(afm1.COD_ACTIVIDAD_FORMULA,0) as codActividadDosificado,"+
                                    " ISNULL(afm2.COD_ACTIVIDAD_FORMULA,0) as codActividadLavadoAmpollas,"+
                                    " isnull(afm3.COD_ACTIVIDAD_FORMULA,0) as codActividaPreparado" +
                                    " ,isnull(afm4.COD_ACTIVIDAD_FORMULA,0) as codActividaEsterilizacionUtensilios" +
                                    " ,isnull(afm5.COD_ACTIVIDAD_FORMULA,0) as codActividaEsterilizacionFiltros" +
                                    " ,isnull(afm6.COD_ACTIVIDAD_FORMULA,0) as codActividadaLavadoFrascos" +
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
                                    " 96 and afm.COD_ACTIVIDAD = 95 and afm.COD_FORMULA_MAESTRA =pp.COD_FORMULA_MAESTRA and afm.COD_PRESENTACION=0"+
                                    " left outer join ACTIVIDADES_FORMULA_MAESTRA afm1 on afm1.COD_AREA_EMPRESA ="+
                                    " 96 and afm1.COD_ACTIVIDAD = 88 and afm1.COD_FORMULA_MAESTRA =pp.COD_FORMULA_MAESTRA and afm1.COD_PRESENTACION=0"+
                                    " left outer join ACTIVIDADES_FORMULA_MAESTRA afm2 on afm2.COD_AREA_EMPRESA ="+
                                    " 96 and afm2.COD_ACTIVIDAD in(94) and afm2.COD_FORMULA_MAESTRA =pp.COD_FORMULA_MAESTRA and afm2.COD_PRESENTACION=0"+
                                    " left outer join ACTIVIDADES_FORMULA_MAESTRA afm3 on afm3.COD_AREA_EMPRESA ="+
                                    " 96 and afm3.COD_ACTIVIDAD = 2 and afm3.COD_FORMULA_MAESTRA =pp.COD_FORMULA_MAESTRA and afm3.COD_PRESENTACION=0"+
                                    " left outer join ACTIVIDADES_FORMULA_MAESTRA afm4 on afm4.COD_AREA_EMPRESA ="+
                                    " 96 and afm4.COD_ACTIVIDAD = 261 and afm4.COD_FORMULA_MAESTRA =pp.COD_FORMULA_MAESTRA and afm4.COD_PRESENTACION=0"+
                                    " left outer join ACTIVIDADES_FORMULA_MAESTRA afm5 on afm5.COD_AREA_EMPRESA ="+
                                    " 96 and afm5.COD_ACTIVIDAD = 260 and afm5.COD_FORMULA_MAESTRA =pp.COD_FORMULA_MAESTRA and afm5.COD_PRESENTACION=0" +
                                    " left outer join ACTIVIDADES_FORMULA_MAESTRA afm6 on afm6.COD_AREA_EMPRESA ="+
                                    " 96 and afm6.COD_ACTIVIDAD = 60 and afm6.COD_FORMULA_MAESTRA =pp.COD_FORMULA_MAESTRA and afm6.COD_PRESENTACION=0" +
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
                        codActividadEsterilizacionUtensilios=res.getInt("codActividaEsterilizacionUtensilios");
                        codActividadEsterilizacionFiltro=res.getInt("codActividaEsterilizacionFiltros");
                        if(codActividadEsterilizacionUtensilios==0||codActividadEsterilizacionFiltro==0)
                        {
                            if(!(codForma==1||(codForma>=35&&codForma<=41)))
                            {
                                out.println("<script>alert('No se encuentran asociadas las actidades de ESTERILIZACION DE FILTROS y/o ESTERILIZACION DE UTENSILIOS');window.close();</script>");
                            }
                        }
                        codTipoProgramaProd=res.getInt("COD_TIPO_PROGRAMA_PROD");
                        codCompProd=res.getInt("COD_COMPPROD");
                        codActividadAutoclave=res.getInt("codActividadAutoclave");
                        codActividadDosificado=res.getInt("codActividadDosificado");
                        codActividadLavadoAmp=(codForma==2?res.getInt("codActividadLavadoAmpollas"):res.getInt("codActividadaLavadoFrascos"));
                        codActividadPreparado=res.getInt("codActividaPreparado");
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
                                            <tr>
                                                   <td class="tableHeaderClass" rowspan="3" style="text-align:center" >
                                                       <span class="textHeaderClass">SECCION</span>
                                                   </td>
                                                   <td class="tableHeaderClass" rowspan="3" style="text-align:center;">
                                                       <span class="textHeaderClass">NOMBRE DE LA PERSONA<BR>RESPONSABLE DE LA<BR>LIMPIEZA </span>
                                                   </td>
                                                   <td class="tableHeaderClass" colspan="3"  style="text-align:center" >
                                                       <span class="textHeaderClass">TIPO DE LIMPIEZA</span>
                                                   </td>
                                                   <td class="tableHeaderClass" rowspan="3"  style="padding-left:22px;padding-right:22px; text-align:center" >
                                                       <span class="textHeaderClass">FECHA</span>
                                                   </td>
                                                   <td class="tableHeaderClass" rowspan="3"  style="padding-left:22px;padding-right:22px; text-align:center" >
                                                       <span class="textHeaderClass">HORA<br>INICIO</span>
                                                   </td>
                                                   <td class="tableHeaderClass" rowspan="3"  style="padding-left:22px;padding-right:22px; text-align:center" >
                                                       <span class="textHeaderClass">HORA<br>FINAL</span>
                                                   </td>
                                                   
                                             </tr>
                                             <tr>
                                                   <td class="tableHeaderClass" rowspan="2" style="text-align:center" >
                                                       <span class="textHeaderClass">Sanitizante</span>
                                                   </td>
                                                   <td class="tableHeaderClass" colspan="2"  style="text-align:center" >
                                                       <span class="textHeaderClass">Limpieza</span>
                                                   </td>
                                                   
                                             </tr>
                                             <tr>
                                                   <td class="tableHeaderClass"  style="text-align:center" >
                                                       <span class="textHeaderClass">Radical</span>
                                                   </td>
                                                   <td class="tableHeaderClass"   style="text-align:center" >
                                                       <span class="textHeaderClass">Ordinaria</span>
                                                   </td>

                                             </tr>
                              <%
                              }
                                
                                personal=UtilidadesTablet.operariosAreaProduccionAdminSelect(st, codAreaEmpresa, codPersonal, administrador);
                                consulta="select som.COD_SECCION_ORDEN_MANUFACTURA,som.NOMBRE_SECCION_ORDEN_MANUFACTURA"+
                                        " from SECCIONES_ORDEN_MANUFACTURA som where som.COD_SECCION_ORDEN_MANUFACTURA in"+
                                        " (select  m.COD_SECCION_ORDEN_MANUFACTURA from COMPONENTES_PROD_MAQUINARIA_LIMPIEZA cpml inner join maquinarias m on"+
                                        " m.COD_MAQUINA=cpml.COD_MAQUINA and cpml.COD_COMPPROD='"+codCompProd+"') order by som.NOMBRE_SECCION_ORDEN_MANUFACTURA";
                                System.out.println("consulta cargar secciones "+consulta);
                                res=st.executeQuery(consulta);
                                while(res.next())
                                {
                                    seccionesSelect+="<option value='"+res.getString("COD_SECCION_ORDEN_MANUFACTURA")+"'>"+res.getString("NOMBRE_SECCION_ORDEN_MANUFACTURA")+"</option>";
                                }
                                consulta="select sl.COD_SANITIZANTE_LIMPIEZA,sl.NOMBRE_SANITIZANTE_LIMPIEZA"+
                                        " from SANITIZANTES_LIMPIEZA sl where sl.COD_ESTADO_REGISTRO=1 order by sl.NOMBRE_SANITIZANTE_LIMPIEZA";
                                System.out.println("consulta cargar sanitizantes "+consulta);
                                res=st.executeQuery(consulta);
                                sanitizantesSelect="<option value='0'>--Seleccione una opcion--</option>";
                                while(res.next())
                                {
                                    sanitizantesSelect+="<option value='"+res.getString("COD_SANITIZANTE_LIMPIEZA")+"'>"+res.getString("NOMBRE_SANITIZANTE_LIMPIEZA")+"</option>";
                                }
                                
                                out.println("<script>sanitizantesSelect=\""+sanitizantesSelect+"\";" +
                                            "seccionesSelect=\""+seccionesSelect+"\";" +
                                            "operariosLimpieza=\""+personal+"\";" +
                                            "fechaRegistroNuevo=\""+sdfDias.format(new Date())+"\";</script>");
                                consulta="select som.COD_SECCION_ORDEN_MANUFACTURA,som.NOMBRE_SECCION_ORDEN_MANUFACTURA,"+
                                         " isnull(slls.COD_PERSONAL_LIMPIEZA,0) as COD_PERSONAL_LIMPIEZA,"+
                                         " ISNULL(slls.LIMPIEZA_RADICAL,0) as LIMPIEZA_RADICAL,isnull(slls.LIMPIEZA_ORDINARIA,0) as LIMPIEZA_ORDINARIA,"+
                                         " sppp.FECHA_INICIO,sppp.FECHA_FINAL,isnull(slls.COD_SANITIZANTE_LIMPIEZA,0) as COD_SANITIZANTE_LIMPIEZA,slls.REGISTRO_PRINCIPAL" +
                                         " ,ISNULL(sppp.COD_ACTIVIDAD_PROGRAMA,(case"+
                                        " when som.COD_SECCION_ORDEN_MANUFACTURA=1 then "+codActividadLavadoAmp+
                                        " when som.COD_SECCION_ORDEN_MANUFACTURA=2 then "+codActividadPreparado+
                                        " when som.COD_SECCION_ORDEN_MANUFACTURA=3 then "+codActividadDosificado+
                                        " when som.COD_SECCION_ORDEN_MANUFACTURA=4 then "+codActividadAutoclave+
                                        " else 0 end)) as codActividadPrograma"+
                                        " from SECCIONES_ORDEN_MANUFACTURA som left outer join"+
                                        " SEGUIMIENTO_LIMPIEZA_LOTE_SECCIONES slls on som.COD_SECCION_ORDEN_MANUFACTURA"+
                                        " =slls.COD_SECCION_ORDEN_MANUFACTURA and slls.COD_SEGUIMIENTO_LIMPIEZA_LOTE='"+codSeguimientoLimpiezaLote+"'" +
                                        (administrador?"":"  and slls.COD_PERSONAL_LIMPIEZA='"+codPersonal+"'")+
                                        "  left outer join SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sppp on"+
                                        " sppp.COD_REGISTRO_ORDEN_MANUFACTURA=slls.COD_REGISTRO_ORDEN_MANUFACTURA"+
                                        " and sppp.COD_PERSONAL=slls.COD_PERSONAL_LIMPIEZA"+
                                        " and sppp.COD_LOTE_PRODUCCION='"+codLote+"'"+
                                        " and sppp.COD_PROGRAMA_PROD='"+codprogramaProd+"'"+
                                        " and sppp.COD_COMPPROD='"+codCompProd+"'"+
                                        " and sppp.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"'"+
                                        " and sppp.COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"'" +
                                        " and sppp.COD_ACTIVIDAD_PROGRAMA=(case"+
                                        " when slls.COD_SECCION_ORDEN_MANUFACTURA=1 then "+codActividadLavadoAmp+
                                        " when slls.COD_SECCION_ORDEN_MANUFACTURA=2 then "+codActividadPreparado+
                                        " when slls.COD_SECCION_ORDEN_MANUFACTURA=3 then "+codActividadDosificado+
                                        " when slls.COD_SECCION_ORDEN_MANUFACTURA=4 then "+codActividadAutoclave+
                                        " else 0 end)" +
                                        " where som.COD_ESTADO_REGISTRO=1"+
                                        " and som.COD_SECCION_ORDEN_MANUFACTURA in ( select m.COD_SECCION_ORDEN_MANUFACTURA from COMPONENTES_PROD_MAQUINARIA_LIMPIEZA c inner join MAQUINARIAS m"+
                                        " on m.COD_MAQUINA=c.COD_MAQUINA where c.COD_COMPPROD='"+codCompProd+"')"+
                                        " order by case when slls.REGISTRO_PRINCIPAL=1 then 1 else 2 end,som.NOMBRE_SECCION_ORDEN_MANUFACTURA";
                                System.out.println("consulta cargar seguimiento limpieza secciones "+consulta);
                                res=st.executeQuery(consulta);
                                int contador=0;
                                while(res.next())
                                {
                                    if(res.getInt("codActividadPrograma")==0)
                                    {
                                        
                                        out.println("<script type='text/javascript'>alert('No se encuentra vinculada la actividad de limpieza de "+res.getString("NOMBRE_SECCION_ORDEN_MANUFACTURA")+" para el producto.La ventana se cerrara');window.close();</script>");
                                    }
                                    contador++;
                                    out.println("<tr "+(res.getInt("REGISTRO_PRINCIPAL")>1?"onclick=\"seleccionarFila(this);\"":"")+"><td class='tableCell'  style='text-align:center'>"+(res.getInt("REGISTRO_PRINCIPAL")>1?"<select value='' "+(administrador?"disabled":"")+" id='codSeccion"+res.getRow()+"'>"+seccionesSelect+"</select><script>codSeccion"+res.getRow()+".value='"+res.getInt("COD_SECCION_ORDEN_MANUFACTURA")+"';</script>":"<input type='hidden' value='"+res.getInt("COD_SECCION_ORDEN_MANUFACTURA")+"' /><span class='textHeaderClassBody'>"+res.getString("NOMBRE_SECCION_ORDEN_MANUFACTURA")+"</span>")+"</td>"+
                                                " <td class='tableCell' style='text-align:center;'><select "+(administrador?"disabled":"")+" id='s"+contador+"'><option value='0'>--Seleccione una opción--</option>"+personal+"</select>"+
                                                "<script>s"+contador+".value='"+res.getInt("COD_PERSONAL_LIMPIEZA")+"';</script></td>"+
                                                " <td class='tableCell' style='text-align:center;'><select "+(administrador?"disabled":"")+" id='codSaniSeccion"+contador+"'>"+sanitizantesSelect+"</select>" +
                                                "<script>codSaniSeccion"+contador+".value='"+res.getString("COD_SANITIZANTE_LIMPIEZA")+"';</script></td>"+
                                                " <td class='tableCell'  style='text-align:center;'><input onclick='onChangeEstado(this)' "+(administrador?"disabled":"")+" type='checkbox' style='width:20px;height:20px' "+(res.getInt("LIMPIEZA_RADICAL")>0?"checked":"")+
                                                " ></td><td class='tableCell'  style='text-align:center;'><input onclick='onChangeEstado(this)' "+(administrador?"disabled":"")+" type='checkbox' style='width:20px;height:20px'"+(res.getInt("LIMPIEZA_ORDINARIA")>0?"checked":"")+
                                                " ></td><td class='tableCell'  style='text-align:center;'>"+
                                                " <input "+(administrador?"disabled":"")+" type='text' value='"+(res.getDate("FECHA_INICIO")!=null?sdfDias.format(res.getDate("FECHA_INICIO")):"")+"' size='10' id='fecha"+contador+"' onclick='seleccionarDatePickerJs(this)'/>"+
                                                " </td><td class='tableCell'  style='text-align:center;' align='center'><input "+(administrador?"disabled":"")+" type='text' onclick='seleccionarHora(this);' id='dataSeccIni"+res.getRow()+"'  value='"+(res.getTimestamp("FECHA_INICIO")!=null?sdfHoras.format(res.getTimestamp("FECHA_INICIO")):"")+"' style='width:6em;'></td>" +
                                                " <td class='tableCell'  style='text-align:center;' align='center'><input "+(administrador?"disabled":"")+" type='text'  onclick='seleccionarHora(this);' id='dataSeccFin"+res.getRow()+"' value='"+(res.getTimestamp("FECHA_FINAL")!=null?sdfHoras.format(res.getTimestamp("FECHA_FINAL")):"")+"' style='width:6em;'></td></tr>");
                                }

                              %>
                              </table>
                                  
                            </div>
                        </div>
                         <div class="row">
                             <div class="large-5 medium-5 small-4 columns" style="">&nbsp;</div>
                              <div class="large-1 medium-1 small-2 columns">
                                    <button class="small button succes radius buttonAction" <%=(administrador?"disabled":"")%> onclick="nuevoRegistro('dataLimpiezaSecciones',true)">+</button>
                              </div>
                              <div class="large-1 medium-1 small-2 columns">
                                        <button class="small button succes radius buttonAction" <%=(administrador?"disabled":"")%> onclick="eliminarRegistroTabla('dataLimpiezaSecciones')">-</button>
                              </div>
                              <div class="large-5 medium-5 small-4 columns" style="">&nbsp;</div>
                           </div>
                        <div class="row">
                                   <div class="large-12 medium-12 small-12 columns divHeaderClass" >
                                           <label  class="inline">REGISTRO DE LIMPIEZA DE EQUIPOS(Control de Limpieza)</label>
                                    </div>
                        </div>
                        <div style="margin-top:12px">
                            <span style="font-weight:normal" class="textHeaderClassBody"><%=(indicacionesLimpiezaEquipos)%></span>
                      </div>
                    <center>
                    <table style="width:100%;margin-top:12px;border-bottom:solid #a80077 1px;" id="dataLimpiezaMaquinarias" cellpadding="0px" cellspacing="0px" >
                        <tr >
                               <td class="tableHeaderClass" rowspan="3" style="text-align:center">
                                   <span class="textHeaderClass">EQUIPO(CODIGO)</span>
                               </td>
                               
                               <td class="tableHeaderClass" rowspan="3" style="text-align:center">
                                   <span class="textHeaderClass">NOMBRE DE LA PERSONA<BR>RESPONSABLE DE LA<BR>LIMPIEZA</span>
                               </td>
                               <td class="tableHeaderClass" colspan="3" style="text-align:center">
                                   <span class="textHeaderClass">TIPO DE LIMPIEZA</span>
                               </td>
                                <td class="tableHeaderClass" rowspan="3" style="text-align:center">
                                   <span class="textHeaderClass">FECHA<BR>&nbsp;&nbsp;&nbsp;LIMPIEZA&nbsp;&nbsp;</span>
                               </td>
                               <td class="tableHeaderClass" rowspan="3" style="text-align:center">
                                   <span class="textHeaderClass">HORA<BR>INICIO</span>
                               </td>
                               <td class="tableHeaderClass" rowspan="3" style="text-align:center">
                                   <span class="textHeaderClass">HORA<BR>FINAL</span>
                               </td>
                        </tr>
                        <tr >
                               <td class="tableHeaderClass" rowspan="2" style="text-align:center">
                                   <span class="textHeaderClass">SANITIZANTE/<BR>DETERGENTE</span>
                               </td>
                               <td class="tableHeaderClass" colspan="2" style="text-align:center">
                                   <span class="textHeaderClass">LIMPIEZA</span>
                               </td>
                               
                        </tr>
                        <tr >
                               <td class="tableHeaderClass"  style="text-align:center">
                                   <span class="textHeaderClass">RADICAL</span>
                               </td>
                               <td class="tableHeaderClass"  style="text-align:center">
                                   <span class="textHeaderClass">ORDINARIA</span>
                               </td>

                        </tr>
                        <% 
                                    consulta="select ( cast(m.COD_MAQUINA as varchar)+'-'+cast(m.COD_SECCION_ORDEN_MANUFACTURA as varchar)) as codMaqSec,(m.NOMBRE_MAQUINA+' ('+m.CODIGO+')') as NOMBRE_MAQUINA " +
                                            " , m.COD_SECCION_ORDEN_MANUFACTURA" +
                                            " from COMPONENTES_PROD_MAQUINARIA_LIMPIEZA cpml inner join MAQUINARIAS m on " +
                                            " m.COD_MAQUINA=cpml.COD_MAQUINA where cpml.COD_COMPPROD='"+codCompProd+"' and m.cod_tipo_equipo=2";
                                    System.out.println("consulta cargar maquinarias select  "+consulta);
                                    res=st.executeQuery(consulta);
                                    String maquinariasSinSeccion="";
                                    while(res.next())
                                    {
                                        maquinariasSeccionesSelect+="<option value='"+res.getString("codMaqSec")+"'>"+res.getString("NOMBRE_MAQUINA")+"</option>";
                                        if(res.getInt("COD_SECCION_ORDEN_MANUFACTURA")<=0||res.getInt("COD_SECCION_ORDEN_MANUFACTURA")>5)
                                        {
                                            maquinariasSinSeccion+=(maquinariasSinSeccion.equals("")?"":",")+res.getString("NOMBRE_MAQUINA");
                                        }
                                    }
                                    if(!maquinariasSinSeccion.equals(""))
                                    {
                                        System.out.println("cdcdcd");
                                        out.println("<script>alert('No se puede registrar porque existen maquinas sin seccion "+maquinariasSinSeccion+"');window.close();</script>");
                                    }
                                   //System.out.println("m  "+maquinariasSeccionesSelect);
                                    out.println("<script>maquinariasSelect=\""+maquinariasSeccionesSelect+"\";</script>");
                                    
                                    consulta="SELECT m.COD_SECCION_ORDEN_MANUFACTURA,m.NOMBRE_MAQUINA,m.COD_MAQUINA,m.CODIGO,"+
                                             " isnull(slle.COD_PERSONAL_RESPONSABLE_LIMPIEZA,0) as COD_PERSONAL_RESPONSABLE_LIMPIEZA"+
                                             " ,isnull(slle.LIMPIEZA_ORDINARIA,0) as LIMPIEZA_ORDINARIA,"+
                                             " isnull(slle.LIMPIEZA_RADICAL,0) as LIMPIEZA_RADICAL" +
                                             " ,isnull(slle.COD_SANITIZANTE_LIMPIEZA,0) as COD_SANITIZANTE_LIMPIEZA" +
                                             " ,sppp.FECHA_INICIO,sppp.FECHA_FINAL,slle.REGISTRO_PRINCIPAL"+
                                             " FROM COMPONENTES_PROD_MAQUINARIA_LIMPIEZA cpml inner join MAQUINARIAS m"+
                                             "  on cpml.COD_MAQUINA=m.COD_MAQUINA"+
                                             " left outer join SEGUIMIENTO_LIMPIEZA_LOTE_EQUIPOS slle on "+
                                             " slle.COD_MAQUINA=m.COD_MAQUINA and slle.COD_SEGUIMIENTO_LIMPIEZA_LOTE='"+codSeguimientoLimpiezaLote+"'" +
                                             (administrador?"":" and slle.COD_PERSONAL_RESPONSABLE_LIMPIEZA='"+codPersonal+"'")+
                                             " left outer join SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sppp on "+
                                             " sppp.COD_REGISTRO_ORDEN_MANUFACTURA=slle.COD_REGISTRO_ORDEN_MANUFACTURA"+
                                             " and sppp.COD_PERSONAL=slle.COD_PERSONAL_RESPONSABLE_LIMPIEZA"+
                                             " and sppp.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"'"+
                                             " and sppp.COD_PROGRAMA_PROD='"+codprogramaProd+"'"+
                                             " and sppp.COD_LOTE_PRODUCCION='"+codLote+"'"+
                                             " and sppp.COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"'"+
                                             " and sppp.COD_COMPPROD='"+codCompProd+"'"+
                                             " and sppp.COD_ACTIVIDAD_PROGRAMA=(case"+
                                             " when m.COD_SECCION_ORDEN_MANUFACTURA=1 then "+codActividadLavadoAmp+
                                             " when m.COD_SECCION_ORDEN_MANUFACTURA=2 then "+codActividadPreparado+
                                             " when m.COD_SECCION_ORDEN_MANUFACTURA=3 then "+codActividadDosificado+
                                             " when m.COD_SECCION_ORDEN_MANUFACTURA=4 then "+codActividadAutoclave+
                                             " when m.COD_SECCION_ORDEN_MANUFACTURA=5 then "+codActividadDosificado+
                                             " else 0 end )"+
                                             " where m.COD_TIPO_EQUIPO=2 and cpml.COD_COMPPROD='"+codCompProd+"' "+
                                             " order by case when slle.REGISTRO_PRINCIPAL=1 then 1 else 2 end, m.NOMBRE_MAQUINA";
                                    System.out.println("consulta cargar maquinarias limpieza "+consulta);
                                    res=st.executeQuery(consulta);
                                    while(res.next())
                                    {
                                        contador++;
                                        out.println("<tr "+(res.getInt("REGISTRO_PRINCIPAL")>1?"onclick=\"seleccionarFila(this);\"":"")+"><td class='tableCell'  style='text-align:center;'>"+(res.getInt("REGISTRO_PRINCIPAL")>1?"<select "+(administrador?"disabled":"")+" id='codLimpiezaEquipo"+res.getRow()+"'>"+maquinariasSeccionesSelect+"</select>" +
                                                    "<script>codLimpiezaEquipo"+res.getRow()+".value='"+res.getInt("COD_MAQUINA")+"-"+res.getInt("COD_SECCION_ORDEN_MANUFACTURA")+"'</script>":
                                                    "<input type='hidden' value='"+res.getInt("COD_MAQUINA")+"'/>" +
                                                    "<input type='hidden' value='"+res.getInt("COD_SECCION_ORDEN_MANUFACTURA")+"' />"+
                                                    "<span class='textHeaderClassBody' style='font-weight:normal'>"+res.getString("NOMBRE_MAQUINA")+"("+res.getString("CODIGO")+")</span>")+" </td>"+
                                                    //" <td class='tableCell'  style='text-align:center;'><span class='textHeaderClassBody' style='font-weight:normal'>"+res.getString("CODIGO")+"</span></td>"+
                                                    " <td class='tableCell' style='text-align:center;'><select "+(administrador?"disabled":"")+" id='sMaquina"+contador+"'><option value='0'>--Seleccione una opción--</option>"+personal+"</select>"+
                                                    "<script>sMaquina"+contador+".value='"+res.getInt("COD_PERSONAL_RESPONSABLE_LIMPIEZA")+"';</script></td>"+
                                                    "<td class='tableCell'  style='text-align:center;'><select "+(administrador?"disabled":"")+" id='codSaniMaqui"+contador+"'>"+sanitizantesSelect+"</select>" +
                                                    "<script>codSaniMaqui"+contador+".value='"+res.getString("COD_SANITIZANTE_LIMPIEZA")+"'</script></td>"+
                                                    " <td class='tableCell'  style='text-align:center;'><input onclick='onChangeEstado(this)' "+(administrador?"disabled":"")+" type='checkbox' style='width:20px;height:20px' "+(res.getInt("LIMPIEZA_RADICAL")>0?"checked":"")+" /></td>"+
                                                    "<td class='tableCell'  style='text-align:center;'><input onclick='onChangeEstado(this)' "+(administrador?"disabled":"")+" type='checkbox' style='width:20px;height:20px' "+(res.getInt("LIMPIEZA_ORDINARIA")>0?"checked":"")+"></td>"+
                                                    "<td class='tableCell'  style='text-align:center;'>"+
                                                    " <input "+(administrador?"disabled":"")+" onclick='seleccionarDatePickerJs(this)' type='text' value='"+(res.getDate("FECHA_INICIO")!=null?sdfDias.format(res.getDate("FECHA_INICIO")):"")+"' size='10' id='fechaMaq"+contador+"'/>"+
                                                    " </td><td class='tableCell'  style='text-align:center;' align='center'><input "+(administrador?"disabled":"")+" type='text'  onclick='seleccionarHora(this);' id='dataMaqIni"+res.getRow()+"' value='"+(res.getTimestamp("FECHA_INICIO")!=null?sdfHoras.format(res.getTimestamp("FECHA_INICIO")):"")+"' style='width:6em;'></td>" +
                                                    " <td class='tableCell'  style='text-align:center;' align='center'><input "+(administrador?"disabled":"")+" type='text' onclick='seleccionarHora(this);' id='dataMaqFin"+res.getRow()+"'  value='"+(res.getTimestamp("FECHA_FINAL")!=null?sdfHoras.format(res.getTimestamp("FECHA_FINAL")):"")+"' style='width:6em;'></td></tr>");
                                        }
                                    %>
                                    
                        
                    </table>
                    <div class="row">
                         <div class="large-5 medium-5 small-4 columns" style="">&nbsp;</div>
                          <div class="large-1 medium-1 small-2 columns">
                                <button class="small button succes radius buttonAction" <%=(administrador?"disabled":"")%>  onclick="nuevoRegistro('dataLimpiezaMaquinarias',false)">+</button>
                          </div>
                          <div class="large-1 medium-1 small-2 columns">
                                    <button class="small button succes radius buttonAction" <%=(administrador?"disabled":"")%> onclick="eliminarRegistroTabla('dataLimpiezaMaquinarias')">-</button>
                          </div>
                          <div class="large-5 medium-5 small-4 columns" style="">&nbsp;</div>
                   </div>
                    </center>
                     <div class="row">
                                   <div class="large-12 medium-12 small-12 columns divHeaderClass" >
                                           <label  class="inline">REGISTRO DE LIMPIEZA Y ESTERILIZACION DE UTENSILIOS</label>
                                    </div>
                        </div>
                     <div style="margin-top:12px">
                            <span style="font-weight:normal" class="textHeaderClassBody"><%=(indicacionesLimpiezaUtencilios)%></span>
                     </div>
                      <center>

                          <table style="width:100%;margin-top:8px" id="dataTiemEsterilizacionUtensilios" cellpadding="0px" cellspacing="0px">
                            <tr>
                               <td class="tableHeaderClass"  style="text-align:center" colspan="5">
                                   <span class="textHeaderClass">Responsable de Esterilizacion de Utensilios</span>
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
                                        " and sppp.COD_COMPPROD='"+codCompProd+"' and sppp.COD_ACTIVIDAD_PROGRAMA='"+codActividadEsterilizacionUtensilios+"'"+
                                        " and sppp.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"' and sppp.COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"'" +
                                        (administrador?"":" and sppp.cod_personal='"+codPersonal+"'")+
                                        " order by sppp.FECHA_INICIO";
                                System.out.println("consulta cargar tiempos esterilizacion utensilios"+consulta);
                                res=st.executeQuery(consulta);

                                while(res.next())
                                {
                                    out.println("<tr onclick=\"seleccionarFila(this);\" ><td class='tableCell' style='text-align:left'>"+
                                                " <select "+(administrador?"disabled":"")+" id='codPersonalUtensilio"+res.getRow()+"'>"+personal+"</select><script>codPersonalUtensilio"+res.getRow()+".value='"+res.getString("COD_PERSONAL")+"'</script></td>"+
                                                " <td class='tableCell' style='text-align:left'><input "+(administrador?"disabled":"")+" id='fechaUtensilios"+res.getRow()+"' type='text' value='"+sdfDias.format(res.getTimestamp("FECHA_INICIO"))+"' onclick='seleccionarDatePickerJs(this);'>" +
                                                " <td class='tableCell' style='text-align:left;width:6em;'><input "+(administrador?"disabled":"")+" type='text' onclick='seleccionarHora(this);' id='dataSeg1Ini"+res.getRow()+"' onfocus='calcularDiferenciaHoras(this);' onkeyup='calcularDiferenciaHoras(this);' value='"+sdfHoras.format(res.getTimestamp("FECHA_INICIO"))+"'></td>" +
                                                " <td class='tableCell' style='text-align:left;width:6em;'><input "+(administrador?"disabled":"")+" type='text' onclick='seleccionarHora(this);' id='dataSeg1Fin"+res.getRow()+"' onfocus='calcularDiferenciaHoras(this);' onkeyup='calcularDiferenciaHoras(this);' value='"+sdfHoras.format(res.getTimestamp("FECHA_FINAL"))+"'></td>" +
                                                " <td class='tableCell' style='text-align:center;width:6em;' aling='center'><span class='textHeaderClassBody' style='font-weight:normal'>"+res.getDouble("HORAS_HOMBRE")+"</span></td>" +
                                                "</tr>");
                                }
                               %>
                    </table>
                     <div class="row">
                             <div class="large-5 medium-5 small-4 columns" style="">&nbsp;</div>
                              <div class="large-1 medium-1 small-2 columns">
                                    <button class="small button succes radius buttonAction" <%=(administrador?"disabled":"")%> onclick="masSeguimiento('dataTiemEsterilizacionUtensilios')">+</button>
                              </div>
                              <div class="large-1 medium-1 small-2 columns">
                                    <button class="small button succes radius buttonAction" <%=(administrador?"disabled":"")%> onclick="eliminarRegistroTabla('dataTiemEsterilizacionUtensilios')">-</button>
                              </div>
                              <div class="large-5 medium-5 small-4 columns" style="">&nbsp;</div>
                       </div>

                    <table style="width:80%;margin-top:12px;border-bottom:solid #a80077 1px;" id="dataLimpiezaUtensilios" cellpadding="0px" cellspacing="0px" >
                        
                        <%
                        String cabeceraPersonal="";
                       String innerCabeceraPersonal="";
                       String detallePersonal="";
                       int contDetalle=0;
                       if(administrador)
                        {
                            consulta="select s.COD_PERSONAL,(isnull(p.AP_PATERNO_PERSONAL,pt.AP_PATERNO_PERSONAL)+'<br>'+isnull(p.AP_MATERNO_PERSONAL,pt.AP_MATERNO_PERSONAL)+'<br>'+isnull(p.NOMBRES_PERSONAL,pt.NOMBRES_PERSONAL)) as nombrePersonal"+
                                     " from SEGUIMIENTO_LIMPIEZA_LOTE_UTENSILIOS s"+
				     "  left outer join personal p on s.COD_PERSONAL=p.COD_PERSONAL"+
				     "  left outer join personal_temporal pt on s.COD_PERSONAL=pt.COD_PERSONAL"+
                                     " where s.COD_SEGUIMIENTO_LIMPIEZA_LOTE='"+codSeguimientoLimpiezaLote+"'"+
                                     " group by s.COD_PERSONAL,p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRES_PERSONAL,pt.AP_PATERNO_PERSONAL,pt.AP_MATERNO_PERSONAL,pt.NOMBRES_PERSONAL"+
                                     " order by 2";
                            System.out.println("consulta personal Registrado "+consulta);
                            res=st.executeQuery(consulta);
                            while(res.next())
                            {
                                innerCabeceraPersonal+="<td class='tableHeaderClass' style='text-align:center;'><span class='textHeaderClass'>"+res.getString("nombrePersonal")+"</span></td>";
                                cabeceraPersonal+=",ISNULL(sedl"+res.getRow()+".COD_MAQUINA,0) as registrado"+res.getRow();
                                detallePersonal+=" left outer join SEGUIMIENTO_LIMPIEZA_LOTE_UTENSILIOS sedl"+res.getRow()+" on"+
                                                 " sedl"+res.getRow()+".COD_MAQUINA = m.COD_MAQUINA and"+
                                                 " sedl"+res.getRow()+".COD_SEGUIMIENTO_LIMPIEZA_LOTE = '"+codSeguimientoLimpiezaLote+"'" +
                                                 " and sedl"+res.getRow()+".COD_PERSONAL='"+res.getInt("COD_PERSONAL")+"'";
                                contDetalle=res.getRow();
                            }

                        }
                        out.println("<tr ><td class='tableHeaderClass'  style='text-align:center' colspan='"+contDetalle+"'><span class='textHeaderClass'>UTENSILIO<br>LIMPIADO</span></td>"+
                                    " <td class='tableHeaderClass' "+((administrador&&contDetalle>0)?"rowspan='2'":"")+"  style='text-align:center'><span class='textHeaderClass'>UTENSILIO</span></td>"+
                                    " <td class='tableHeaderClass' "+((administrador&&contDetalle>0)?"rowspan='2'":"")+" style='text-align:center'><span class='textHeaderClass'>CODIGO</span></td></tr>"+
                                    ((administrador&&contDetalle>0)?"<tr>"+innerCabeceraPersonal+"</tr>":""));
                        consulta="SELECT m.NOMBRE_MAQUINA,m.COD_MAQUINA,m.CODIGO"+(administrador?cabeceraPersonal:",ISNULL(sllu.COD_MAQUINA,0) as registrado")+
                                " FROM COMPONENTES_PROD_MAQUINARIA_LIMPIEZA cpml"+
                                " inner join MAQUINARIAS m on cpml.COD_MAQUINA = m.COD_MAQUINA" +
                                (administrador?detallePersonal:" left outer join SEGUIMIENTO_LIMPIEZA_LOTE_UTENSILIOS sllu on m.COD_MAQUINA"+
                                " = sllu.COD_MAQUINA and sllu.COD_SEGUIMIENTO_LIMPIEZA_LOTE = '"+codSeguimientoLimpiezaLote+"'" +
                                " and sllu.COD_PERSONAL='"+codPersonal+"'")+
                                " where m.COD_TIPO_EQUIPO=8 and  cpml.COD_COMPPROD = '"+codCompProd+"' order by m.NOMBRE_MAQUINA ";
                        System.out.println("consulta cargar segui utensilios "+consulta);
                        res=st.executeQuery(consulta);
                        while(res.next())
                        {
                            contador++;
                            out.println("<tr>");
                            if(administrador)
                            {
                                for(int i=1;i<=contDetalle;i++)
                                {
                                    out.println("<td  class='tableCell' style='text-align:center;'><input  disabled style='width:20px;height:20px;' type='checkbox' "+(res.getInt("registrado"+i)>0?"checked":"")+"/></td>");
                                }
                            }
                            else
                            {
                                out.println("<td class='tableCell'  style='text-align:center;'><input  style='width:20px;height:20px;' type='checkbox' "+(res.getInt("registrado")>0?"checked":"")+"/></td>");
                            }
                            %>
                                        
                                            
                                      <td class="tableCell"   style="text-align:center;">
                                          <input type="hidden"  value="<%=res.getInt("COD_MAQUINA")%>"/>
                                           <span class="textHeaderClassBody" style="font-weight:normal"><%=res.getString("NOMBRE_MAQUINA")%></span>
                                       </td>
                                       <td class="tableCell"  style="text-align:center;">
                                           <span class="textHeaderClassBody" style="font-weight:normal"><%=res.getString("CODIGO")%></span>
                                       </td>
                                       
                                        <%
                                        out.println("</tr>");
                        }
                        
                        %>
                    </table>
                    <%
                    if(!(codForma==1||(codForma>=35&&codForma<=41)))
                        {
                    %>
                     <table style="width:100%;margin-top:8px" id="dataTiemEsterilizacionFiltros" cellpadding="0px" cellspacing="0px">
                            <tr>
                               <td class="tableHeaderClass"  style="text-align:center" colspan="5">
                                   <span class="textHeaderClass">Responsable de Esterilizacion de Filtros</span>
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
                                        " and sppp.COD_COMPPROD='"+codCompProd+"' and sppp.COD_ACTIVIDAD_PROGRAMA='"+codActividadEsterilizacionFiltro+"'"+
                                        " and sppp.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"' and sppp.COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"'"+
                                        (administrador?"":" and sppp.COD_PERSONAL='"+codPersonal+"'")+
                                        " order by sppp.FECHA_INICIO";
                                System.out.println("consulta cargar tiempos esterilizacion filtros "+consulta);
                                res=st.executeQuery(consulta);

                                while(res.next())
                                {
                                    out.println("<tr onclick=\"seleccionarFila(this);\" ><td class='tableCell' style='text-align:left'>"+
                                                " <select "+(administrador?"disabled":"")+" id='codPersonalFiltro"+res.getRow()+"'>"+personal+"</select><script>codPersonalFiltro"+res.getRow()+".value='"+res.getString("COD_PERSONAL")+"'</script></td>"+
                                                " <td class='tableCell' style='text-align:left'><input "+(administrador?"disabled":"")+" onclick='seleccionarDatePickerJs(this)' id='fechaFiltro"+res.getRow()+"' type='text' value='"+sdfDias.format(res.getTimestamp("FECHA_INICIO"))+"'>" +
                                                " <td class='tableCell' style='text-align:left;width:6em;'><input "+(administrador?"disabled":"")+" type='text' onclick='seleccionarHora(this);' id='dataSeg2Ini"+res.getRow()+"'  onfocus='calcularDiferenciaHoras(this);' onkeyup='calcularDiferenciaHoras(this);' value='"+sdfHoras.format(res.getTimestamp("FECHA_INICIO"))+"'></td>" +
                                                " <td class='tableCell' style='text-align:left;width:6em;'><input "+(administrador?"disabled":"")+" type='text' onclick='seleccionarHora(this);' id='dataSeg2Fin"+res.getRow()+"'  onfocus='calcularDiferenciaHoras(this);' onkeyup='calcularDiferenciaHoras(this);' value='"+sdfHoras.format(res.getTimestamp("FECHA_FINAL"))+"'></td>" +
                                                " <td class='tableCell' style='text-align:center;width:6em;' aling='center'><span class='textHeaderClassBody' style='font-weight:normal'>"+res.getDouble("HORAS_HOMBRE")+"</span></td>" +
                                                "</tr>");
                                }
                               %>
                    </table>
                     <%
                     }
                     %>
                    <div class="row">
                        <div class="large-5 medium-5 small-4 columns" style="">&nbsp;</div>
                          <div class="large-1 medium-1 small-2 columns">
                                <button class="small button succes radius buttonAction" <%=(administrador?"disabled":"")%> onclick="masSeguimiento('dataTiemEsterilizacionFiltros')">+</button>
                          </div>
                           <div class="large-1 medium-1 small-2 columns">
                                    <button class="small button succes radius buttonAction"  <%=(administrador?"disabled":"")%> onclick="eliminarRegistroTabla('dataTiemEsterilizacionFiltros')">-</button>
                          </div>
                          <div class="large-5 medium-5 small-4 columns" style="">&nbsp;</div>
                   </div>
                     <table style="width:80%;margin-top:12px;border-bottom:solid #a80077 1px;" id="dataLimpiezaFiltros" cellpadding="0px" cellspacing="0px" >
                        
                        <%
                           cabeceraPersonal="";
                           innerCabeceraPersonal="";
                           detallePersonal="";
                           contDetalle=0;
                        if(administrador)
                        {
                            consulta="select sllf.COD_PERSONAL,isnull((p.AP_PATERNO_PERSONAL+'<br>'+p.AP_MATERNO_PERSONAL+'<br>'+p.NOMBRES_PERSONAL),(pt.AP_PATERNO_PERSONAL+'<br>'+pt.AP_MATERNO_PERSONAL+'<br>'+pt.NOMBRES_PERSONAL))as nombrePersonal"+
                                     " from SEGUIMIENTO_LIMPIEZA_LOTE_FILTROS sllf"+
				     " left outer join personal p on sllf.COD_PERSONAL=p.COD_PERSONAL"+
				     " left outer join personal_temporal pt on sllf.COD_PERSONAL=pt.COD_PERSONAL"+
	                             " where sllf.COD_SEGUIMIENTO_LIMPIEZA_LOTE='"+codSeguimientoLimpiezaLote+"'"+
                                     " group by sllf.COD_PERSONAL,p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRES_PERSONAL,pt.AP_PATERNO_PERSONAL,pt.AP_MATERNO_PERSONAL,pt.NOMBRES_PERSONAL"+
                                     " order by 2";
                            System.out.println("consulta personal Registrado "+consulta);
                            res=st.executeQuery(consulta);
                            while(res.next())
                            {
                                innerCabeceraPersonal+="<td class='tableHeaderClass' style='text-align:center;'><span class='textHeaderClass'>"+res.getString("nombrePersonal")+"</span></td>";
                                cabeceraPersonal+=",ISNULL(sedl"+res.getRow()+".COD_FILTRO_PRODUCCION,0) as registrado"+res.getRow();
                                detallePersonal+=" left outer join SEGUIMIENTO_LIMPIEZA_LOTE_FILTROS sedl"+res.getRow()+" on"+
                                                 " sedl"+res.getRow()+".COD_FILTRO_PRODUCCION = fp.COD_FILTRO_PRODUCCION and"+
                                                 " sedl"+res.getRow()+".COD_SEGUIMIENTO_LIMPIEZA_LOTE = '"+codSeguimientoLimpiezaLote+"'" +
                                                 " and sedl"+res.getRow()+".COD_PERSONAL='"+res.getInt("COD_PERSONAL")+"'";
                                contDetalle=res.getRow();
                            }

                        }

                        out.println("<tr ><td class='tableHeaderClass'  style='text-align:center' "+(contDetalle>0?"colspan='"+contDetalle+"'":"")+" ><span class='textHeaderClass'>FILTRO<br>LIMPIADO</span></td>"+
                                    "<td class='tableHeaderClass'  style='text-align:center' "+(contDetalle>0?"rowspan='2'":"")+" ><span class='textHeaderClass'>CODIGO FILTRO</span></td>"+
                                    " <td class='tableHeaderClass'  style='text-align:center' "+(contDetalle>0?"rowspan='2'":"")+"><span class='textHeaderClass'>CANTIDAD<BR>FILTRO</span></td>"+
                                    " <td class='tableHeaderClass'  style='text-align:center' "+(contDetalle>0?"rowspan='2'":"")+" ><span class='textHeaderClass'>MEDIO DE <BR>FILTRACION</span></td>"+
                                    " <td class='tableHeaderClass'  style='text-align:center' "+(contDetalle>0?"rowspan='2'":"")+" ><span class='textHeaderClass'>PRESION DE <BR>APROBACION</span></td>"+
                                    " <td class='tableHeaderClass' style='text-align:center' "+(contDetalle>0?"rowspan='2'":"")+" ><span class='textHeaderClass'>UNIDAD MEDIDA<BR>FILTRO</span></td></tr>"+
                                    (contDetalle>0?"<tr>"+innerCabeceraPersonal+"</tr>":""));

                        consulta="select fp.COD_FILTRO_PRODUCCION,fp.CODIGO_FILTRO_PRODUCCION,fp.PRESION_DE_APROBACION,"+
                                 " mf.NOMBRE_MEDIO_FILTRACION,um.NOMBRE_UNIDAD_MEDIDA,um1.NOMBRE_UNIDAD_MEDIDA as unidadPresion,"+
                                 " fp.CANTIDAD_FILTRO"+(contDetalle>0?cabeceraPersonal:",isnull(sllf.COD_FILTRO_PRODUCCION, 0) as registrado")+
                                 " from FILTROS_PRODUCCION fp inner join FILTROS_PRODUCCION_PRODUCTOS fpp on "+
                                 " fp.COD_FILTRO_PRODUCCION=fpp.COD_FILTRO_PRODUCCION"+
                                 " inner join COMPONENTES_PROD cp on cp.COD_PROD=fpp.COD_PROD"+
                                 " inner join MEDIOS_FILTRACION mf on mf.COD_MEDIO_FILTRACION=fp.COD_MEDIO_FILTRACION"+
                                 " inner join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=fp.COD_UNIDAD_MEDIDA"+
                                 " inner join UNIDADES_MEDIDA um1 on um1.COD_UNIDAD_MEDIDA=fp.COD_UNIDAD_MEDIDA_PRESION"+
                                 (contDetalle>0?detallePersonal:" left outer join SEGUIMIENTO_LIMPIEZA_LOTE_FILTROS sllf on "+
                                 " fp.COD_FILTRO_PRODUCCION=sllf.COD_FILTRO_PRODUCCION and "+
                                 " sllf.COD_SEGUIMIENTO_LIMPIEZA_LOTE='"+codSeguimientoLimpiezaLote+"'"+
                                 " and sllf.cod_personal='"+codPersonal+"'")+
                                 " where cp.COD_COMPPROD='"+codCompProd+"'"+
                                 " order by fp.CODIGO_FILTRO_PRODUCCION";
                        System.out.println(consulta);
                        res=st.executeQuery(consulta);
                        while(res.next())
                        {
                            out.println("<tr>");
                            if(contDetalle>0)
                            {
                                for(int i=1;i<=contDetalle;i++)
                                {
                                    out.println("<td class='tableCell'  style='text-align:center;'><input disabled style='width:20px;height:20px;' type='checkbox' "+(res.getInt("registrado"+i)>0?"checked":"")+"/></td>");
                                }
                            }
                            else
                            {
                                out.println("<td class='tableCell'  style='text-align:center;'><input style='width:20px;height:20px;' type='checkbox' "+(res.getInt("registrado")>0?"checked":"")+"/></td>");
                            }
                            %>
                                        
                                      <td class="tableCell"  style="text-align:center;">
                                          <input type="hidden" value="<%=res.getInt("COD_FILTRO_PRODUCCION")%>"/>
                                           <span class="textHeaderClassBody" style="font-weight:normal"><%=res.getString("CODIGO_FILTRO_PRODUCCION")%></span>
                                       </td>
                                       
                                       <td class="tableCell"  style="text-align:center;">
                                           <span class="textHeaderClassBody" style="font-weight:normal"><%=res.getString("CANTIDAD_FILTRO")%></span>
                                       </td>
                                       <td class="tableCell"  style="text-align:center;">
                                           <span class="textHeaderClassBody" style="font-weight:normal"><%=res.getString("NOMBRE_MEDIO_FILTRACION")%></span>
                                       </td>
                                       <td class="tableCell"  style="text-align:center;">
                                           <span class="textHeaderClassBody" style="font-weight:normal"><%=res.getString("PRESION_DE_APROBACION")%></span>
                                       </td>
                                       <td class="tableCell"  style="text-align:center;">
                                           <span class="textHeaderClassBody" style="font-weight:normal"><%=res.getString("NOMBRE_UNIDAD_MEDIDA")%></span>
                                       </td>
                               
                            <%
                            out.println("</tr>");
                        }

                        %>
                        
                     </table>
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
        <input type="hidden" id="codActividadAutoclave" value="<%=(codActividadAutoclave)%>"/>
        <input type="hidden" id="codActividadDosificado" value="<%=(codActividadDosificado)%>"/>
        <input type="hidden" id="codActividadLavadoAmp" value="<%=(codActividadLavadoAmp)%>"/>
        <input type="hidden" id="codActividadPreparado" value="<%=(codActividadPreparado)%>"/>
        <input type="hidden" id="codActividadEsterilizacionFiltro" value="<%=(codActividadEsterilizacionFiltro)%>"/>
        <input type="hidden" id="codActividadEsterilizacionUtensilios" value="<%=(codActividadEsterilizacionUtensilios)%>"/>
        </section>
        
    </body>
    <script src="../../reponse/js/dataPickerJs.js"></script>
    <script src="../../reponse/js/timePickerJs.js"></script>
    <script>iniciarDatePicker('<%=(sdfDias.format(new Date()))%>');loginHoja.verificarHojaCerrada('cerrado', admin,'codProgramaProd','codLoteSeguimiento',1,<%=(codEstadoHoja)%>);</script>
</html>
