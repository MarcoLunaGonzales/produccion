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
<%@page import="org.richfaces.json.*" %>
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
    function hideModalProgreso()
    {
        document.getElementById('formsuper').style.visibility='hidden';
        document.getElementById('divImagen').style.visibility='hidden';
    }
    function guardarDosificado()
    {
        document.getElementById('formsuper').style.visibility='visible';
        document.getElementById('divImagen').style.visibility='visible';
        var codLote=document.getElementById('codLoteSeguimiento').value;
        var codProgramaProd=document.getElementById('codProgramaProd').value;
        var especificaciones=document.getElementById('dataEspecificaciones');
        var cont=0;
        var dataEspecificaciones=new Array();
        var tablePost=document.getElementById("dataPostFiltrado");
        var dataPostF=new Array();
        var tablaPre=document.getElementById("dataPreFiltrado");
        var dataPreF=new Array();
        var tablaCambioFormato=document.getElementById("registroCambioFormato");
        var dataCambioFormato=new Array();
        var cont=0;
        var tablaArmadoFiltro=document.getElementById("registroArmadoFiltro");
        var dataArmadoFiltro=new Array();
        var tablaReguladoEquipo=document.getElementById("reguladoEquipoVolumen");
        var dataReguladoEquipo=new Array();
        //var permisoCambioFormato=(parseInt(document.getElementById("permisoCambioFormato").value)>0);
        var permisoEspDespiroge=(parseInt(document.getElementById("permisoEspDespiroge").value)>0);
        var permisoPorosidad=(parseInt(document.getElementById("permisoPorosidad").value)>0);
        var permisoVerificacion=(parseInt(document.getElementById("permisoVerificacion").value)>0);
        var permisoCambioFormato=permisoVerificacion;
        if(!admin)
        {
                if(permisoEspDespiroge)
                {
                        for(var i=2;i<(especificaciones.rows.length);i++)
                        {
                            dataEspecificaciones[dataEspecificaciones.length]=especificaciones.rows[i].cells[0].getElementsByTagName('input')[0].value;
                            if(especificaciones.rows[i].cells[3].getElementsByTagName('input')[0].type=='tel')
                            {
                                dataEspecificaciones[dataEspecificaciones.length]=especificaciones.rows[i].cells[3].getElementsByTagName('input')[0].value;
                                if(!validadRegistroMayorACero(especificaciones.rows[i].cells[3].getElementsByTagName('input')[0]))
                                {
                                    hideModalProgreso();
                                         return false;
                                }
                            }
                            else
                            {
                                dataEspecificaciones[dataEspecificaciones.length]=especificaciones.rows[i].cells[3].getElementsByTagName('input')[0].checked?'1':'0';
                            }

                            dataEspecificaciones[dataEspecificaciones.length]=encodeURIComponent(especificaciones.rows[i].cells[4].getElementsByTagName('input')[0].value.split(",").join("$%"));
                        }
                }
                if(permisoPorosidad)
                {
                        cont=0;
                        for(var i=1;i<tablePost.rows.length;i++)
                            {
                                if(parseInt(tablePost.rows[i].cells[4].getElementsByTagName('select')[0].value)>0)
                                {
                                    dataPostF[cont]=tablePost.rows[i].cells[0].getElementsByTagName('input')[0].value;
                                    cont++;
                                    dataPostF[cont]=(tablePost.rows[i].cells[1].getElementsByTagName('input')[0].checked?"1":"0");
                                    cont++;
                                    dataPostF[cont]=decodeURIComponent(tablePost.rows[i].cells[2].getElementsByTagName('input')[0].value.split(',').join("$%"));
                                    cont++;
                                    dataPostF[cont]=(tablePost.rows[i].cells[4].getElementsByTagName('select')[0].value);
                                    cont++;
                                    dataPostF[cont]=encodeURIComponent(tablePost.rows[i].cells[5].getElementsByTagName('input')[0].value.split(',').join("$%"));
                                    cont++;
                                }

                            }
                    }


                    if(permisoVerificacion)
                    {
                             cont=0;
                             for(var i=3;i<tablaPre.rows.length;i++)
                                {
                                    if(validarRegistroEntero(tablaPre.rows[i].cells[7].getElementsByTagName('input')[0]))
                                     {
                                            dataPreF[cont]=tablaPre.rows[i].cells[0].getElementsByTagName('input')[0].value;
                                            cont++;
                                            dataPreF[cont]=tablaPre.rows[i].cells[4].getElementsByTagName('input')[0].checked?"1":"0";
                                            cont++;
                                            dataPreF[cont]=tablaPre.rows[i].cells[5].getElementsByTagName('input')[0].value.split(",").join("|");
                                            cont++;
                                            dataPreF[cont]=(tablaPre.rows[i].cells[7].getElementsByTagName('input')[0].value==''?"0":tablaPre.rows[i].cells[7].getElementsByTagName('input')[0].value);
                                            cont++;
                                     }
                                     else
                                     {
                                         hideModalProgreso();
                                         return false;
                                     }
                                }
                    }
                    if(permisoCambioFormato)
                    {
                                    cont=0;
                                    for(var i=2;i<tablaCambioFormato.rows.length;i++)
                                    {
                                        if(validarSeleccionRegistro(tablaCambioFormato.rows[i].cells[0].getElementsByTagName("select")[0])&&
                                            validarFechaRegistro(tablaCambioFormato.rows[i].cells[1].getElementsByTagName("input")[0])&&
                                            validarHoraRegistro(tablaCambioFormato.rows[i].cells[2].getElementsByTagName("input")[0])&&
                                            validarHoraRegistro(tablaCambioFormato.rows[i].cells[3].getElementsByTagName("input")[0])&&
                                            validarRegistrosHorasNoNegativas(tablaCambioFormato.rows[i].cells[2].getElementsByTagName("input")[0],tablaCambioFormato.rows[i].cells[3].getElementsByTagName("input")[0]))
                                            {
                                                    dataCambioFormato[cont]=tablaCambioFormato.rows[i].cells[0].getElementsByTagName("select")[0].value;
                                                    cont++;
                                                    dataCambioFormato[cont]=tablaCambioFormato.rows[i].cells[1].getElementsByTagName("input")[0].value;
                                                    cont++;
                                                    dataCambioFormato[cont]=tablaCambioFormato.rows[i].cells[2].getElementsByTagName("input")[0].value;
                                                    cont++;
                                                    dataCambioFormato[cont]=tablaCambioFormato.rows[i].cells[3].getElementsByTagName("input")[0].value;
                                                    cont++;
                                                    dataCambioFormato[cont]=parseFloat(tablaCambioFormato.rows[i].cells[4].getElementsByTagName("span")[0].innerHTML);
                                                    cont++;
                                            }
                                            else
                                            {
                                                hideModalProgreso();
                                                return false;
                                            }
                                    }

                                    cont=0;
                                    for(var i=2;i<tablaArmadoFiltro.rows.length;i++)
                                    {
                                        if(validarSeleccionRegistro(tablaArmadoFiltro.rows[i].cells[0].getElementsByTagName("select")[0])&&
                                            validarFechaRegistro(tablaArmadoFiltro.rows[i].cells[1].getElementsByTagName("input")[0])&&
                                            validarHoraRegistro(tablaArmadoFiltro.rows[i].cells[2].getElementsByTagName("input")[0])&&
                                            validarHoraRegistro(tablaArmadoFiltro.rows[i].cells[3].getElementsByTagName("input")[0])&&
                                            validarRegistrosHorasNoNegativas(tablaArmadoFiltro.rows[i].cells[2].getElementsByTagName("input")[0],tablaArmadoFiltro.rows[i].cells[3].getElementsByTagName("input")[0]))
                                        {
                                            dataArmadoFiltro[cont]=tablaArmadoFiltro.rows[i].cells[0].getElementsByTagName("select")[0].value;
                                            cont++;
                                            dataArmadoFiltro[cont]=tablaArmadoFiltro.rows[i].cells[1].getElementsByTagName("input")[0].value;
                                            cont++;
                                            dataArmadoFiltro[cont]=tablaArmadoFiltro.rows[i].cells[2].getElementsByTagName("input")[0].value;
                                            cont++;
                                            dataArmadoFiltro[cont]=tablaArmadoFiltro.rows[i].cells[3].getElementsByTagName("input")[0].value;
                                            cont++;
                                            dataArmadoFiltro[cont]=parseFloat(tablaArmadoFiltro.rows[i].cells[4].getElementsByTagName("span")[0].innerHTML);
                                            cont++;
                                        }
                                        else
                                        {
                                            hideModalProgreso();
                                            return false;
                                        }
                                    }

                                    cont=0;
                                    for(var i=2;i<tablaReguladoEquipo.rows.length;i++)
                                    {
                                        if(validarSeleccionRegistro(tablaReguladoEquipo.rows[i].cells[0].getElementsByTagName("select")[0])&&
                                            validarFechaRegistro(tablaReguladoEquipo.rows[i].cells[1].getElementsByTagName("input")[0])&&
                                            validarHoraRegistro(tablaReguladoEquipo.rows[i].cells[2].getElementsByTagName("input")[0])&&
                                            validarHoraRegistro(tablaReguladoEquipo.rows[i].cells[3].getElementsByTagName("input")[0])&&
                                            validarRegistrosHorasNoNegativas(tablaReguladoEquipo.rows[i].cells[2].getElementsByTagName("input")[0],tablaReguladoEquipo.rows[i].cells[3].getElementsByTagName("input")[0]))
                                        {
                                                dataReguladoEquipo[cont]=tablaReguladoEquipo.rows[i].cells[0].getElementsByTagName("select")[0].value;
                                                cont++;
                                                dataReguladoEquipo[cont]=tablaReguladoEquipo.rows[i].cells[1].getElementsByTagName("input")[0].value;
                                                cont++;
                                                dataReguladoEquipo[cont]=tablaReguladoEquipo.rows[i].cells[2].getElementsByTagName("input")[0].value;
                                                cont++;
                                                dataReguladoEquipo[cont]=tablaReguladoEquipo.rows[i].cells[3].getElementsByTagName("input")[0].value;
                                                cont++;
                                                dataReguladoEquipo[cont]=parseFloat(tablaReguladoEquipo.rows[i].cells[4].getElementsByTagName("span")[0].innerHTML);
                                                cont++;
                                        }
                                        else
                                        {
                                            hideModalProgreso();
                                            return false;
                                        }
                                    }
                    }
                    var permisoAcomodado=(parseInt(document.getElementById("permisoAcomodado").value)>0);;
                    var dataAcomodado;
                    if(permisoAcomodado)
                    {
                        dataAcomodado=new Array();
                        var tablaAcomodado=document.getElementById("registroAcomodadoFrascos");
                        for(var i=2;(i<tablaAcomodado.rows.length);i++)
                        {
                            if(validarSeleccionRegistro(tablaAcomodado.rows[i].cells[0].getElementsByTagName("select")[0])&&
                                validadRegistroMayorACero(tablaAcomodado.rows[i].cells[1].getElementsByTagName("input")[0])&&
                                validarFechaRegistro(tablaAcomodado.rows[i].cells[2].getElementsByTagName("input")[0])&&
                                validarHoraRegistro(tablaAcomodado.rows[i].cells[3].getElementsByTagName("input")[0])&&
                                validarHoraRegistro(tablaAcomodado.rows[i].cells[4].getElementsByTagName("input")[0])&&
                                validarRegistrosHorasNoNegativas(tablaAcomodado.rows[i].cells[3].getElementsByTagName("input")[0],tablaAcomodado.rows[i].cells[4].getElementsByTagName("input")[0]))
                                {
                                    dataAcomodado[dataAcomodado.length]=tablaAcomodado.rows[i].cells[0].getElementsByTagName("select")[0].value;
                                    dataAcomodado[dataAcomodado.length]=tablaAcomodado.rows[i].cells[1].getElementsByTagName("input")[0].value;
                                    dataAcomodado[dataAcomodado.length]=tablaAcomodado.rows[i].cells[2].getElementsByTagName("input")[0].value;
                                    dataAcomodado[dataAcomodado.length]=tablaAcomodado.rows[i].cells[3].getElementsByTagName("input")[0].value;
                                    dataAcomodado[dataAcomodado.length]=tablaAcomodado.rows[i].cells[4].getElementsByTagName("input")[0].value;
                                    dataAcomodado[dataAcomodado.length]=parseFloat(tablaAcomodado.rows[i].cells[5].getElementsByTagName("span")[0].innerHTML);
                                }
                                else
                                {
                                    hideModalProgreso();
                                    return false;
                                }

                        }

                    }
        }
            var peticion="ajaxGuardarSeguimientoDosificadoColirios.jsf?codLote="+codLote+"&noCache="+ Math.random()+
            "&codActividadCambioFormato="+document.getElementById("codActividadCambioFormato").value+
            "&codActividadArmadoFiltros="+document.getElementById("codActividadArmadoFiltros").value+
            "&codActividadReguladoEquipo="+document.getElementById("codActividadReguladoEquipo").value+
            "&codActividadAcomodado="+document.getElementById("codActividadAcomodado").value+
            "&codProgProd="+codProgramaProd+"&codFormulaMaestra="+document.getElementById("codFormulaMaestra").value+
            "&codTipoPrograma="+document.getElementById("codTipoPrograma").value+"&codCompProd="+document.getElementById("codCompProd").value+
             "&dataCambioFormato="+dataCambioFormato+"&dataArmadoFiltro="+dataArmadoFiltro+"&dataReguladoEquipo="+dataReguladoEquipo+
             (admin?"&codPersonalAprueba="+document.getElementById("codPersonalAprueba").value+"&horaAprobacion="+document.getElementById("horaAprobacion").value:"")+
             "&codSeguimiento="+document.getElementById("codSeguimientoDosificado").value+
             "&especificaciones="+dataEspecificaciones+
             "&permisoCambioFormato="+(permisoCambioFormato>0?1:0)+
             "&permisoEspDespiroge="+(permisoEspDespiroge>0?1:0)+
             "&permisoPorosidad="+(permisoPorosidad>0?1:0)+
             "&permisoVerificacion="+(permisoVerificacion>0?1:0)+
             "&permisoAcomodado="+(permisoAcomodado>0?1:0)+
             "&dataAcomodado="+(permisoAcomodado?dataAcomodado:"")+
             "&dataPre="+dataPreF+
             "&dataPost="+dataPostF+
             "&admin="+(admin?1:0)+"&codPersonalUsuario="+codPersonal+
             (admin?"&observaciones="+encodeURIComponent(document.getElementById("observaciones").value):"");
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
                                sqlConnection.insertarRegistroAuxiliar(codProgramaProd,codLote,6,("../registroDosificado/"+peticion),function(){window.close();});
                            }
                            document.getElementById('formsuper').style.visibility='hidden';
                            document.getElementById('divImagen').style.visibility='hidden';
                            return false;
                        }
                        if(parseInt(ajax.responseText.split("\n").join(""))=='1')
                        {
                            alert('Se registro el dosificado');
                            window.close();
                            document.getElementById('formsuper').style.visibility='hidden';
                            document.getElementById('divImagen').style.visibility='hidden';
                            
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
    
    var operariosRegistro="";
    var fechaSistema="";
    var contRegistroSeg=0;
    function calcularDiferenciaHorasAlternativo(obj)
    {
        var fecha1=obj.parentNode.parentNode.cells[2].getElementsByTagName('input')[0].value+' '+obj.parentNode.parentNode.cells[3].getElementsByTagName('input')[0].value;
        var fecha2=obj.parentNode.parentNode.cells[2].getElementsByTagName('input')[0].value+' '+obj.parentNode.parentNode.cells[4].getElementsByTagName('input')[0].value;
        obj.parentNode.parentNode.cells[5].getElementsByTagName('span')[0].innerHTML=getNumeroDehoras(fecha1,fecha2);
        return true;
    }
    function nuevoRegistro(nombreTabla,conCantidad)
   {
        contRegistroSeg++;
       var table = document.getElementById(nombreTabla);
       var rowCount = table.rows.length;
       var row = table.insertRow(rowCount);
       row.onclick=function(){seleccionarFila(this);}
       var cell1 = row.insertCell(0);
       cell1.className="tableCell";
       var element1 = document.createElement("select");
       element1.innerHTML=operariosRegistro;
       element1.options.remove(0);
       cell1.appendChild(element1);
       if(conCantidad)
       {
            var cellCantidad = row.insertCell(1);
           cellCantidad.className="tableCell";
           cellCantidad.align="center";
           var inputCantidad=document.createElement("input");
           inputCantidad.type="tel";
           inputCantidad.style.width="6em";
           cellCantidad.appendChild(inputCantidad);

       }
        var cell2 = row.insertCell(1+(conCantidad?1:0));
       cell2.className="tableCell";
       var element2 = document.createElement("input");
       element2.id="fechaTiempo"+nombreTabla+table.rows.length;
       element2.type = "text";
       element2.value=fechaSistema;
       element2.onclick=function(){seleccionarDatePickerJs(this);};
       cell2.appendChild(element2);
       for(var i=0;i<2;i++)
       {
           var cell3 = row.insertCell(i+2+(conCantidad?1:0));
           cell3.className="tableCell";
           var element3 = document.createElement("input");
           element3.type = "text";
           cell3.align='center';
           element3.style.width='6em';
           element3.id="contRegistroSeg"+i+"t"+contRegistroSeg;
           element3.value=getHoraActualString();
           if(conCantidad)
           {
               element3.onfocus=function(){calcularDiferenciaHorasAlternativo(this);};
               element3.onkeyup=function(){calcularDiferenciaHorasAlternativo(this);};
           }
           else
           {
               element3.onfocus=function(){calcularDiferenciaHoras(this);};
               element3.onkeyup=function(){calcularDiferenciaHoras(this);};
           }

           
           element3.onclick=function(){seleccionarHora(this);};
           cell3.appendChild(element3);
       }
        var cell4 = row.insertCell(4+(conCantidad?1:0));
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
  <%
        int codPersonalApruebaDespeje=0;
        String loteAsociado="";
        int cantLoteAsociado=0;
        String codPersonal=request.getParameter("codPersonal");
        boolean administrador=(Integer.valueOf(request.getParameter("admin"))>0);
        String nombreAdministrador="";
        out.println("<script type='text/javascript'>codPersonal="+codPersonal+";" +
                   "admin="+administrador+";</script>");
        int codEstadoHoja=0;
        int codPersonalSupervisor=0;
        Date fechaCierre=new Date();
        JSONObject nuevo=new JSONObject("{hola:'jose';jose:[{cod:1},{ref:2}]}");
        JSONArray bean=nuevo.getJSONArray("jose");
        System.out.println(bean.getJSONObject(0).get("cod").toString());
        String codCompProd=request.getParameter("codComprod");
        String codLote=request.getParameter("codLote");
        out.println("<title>("+codLote+")DOSIFICADO</title>");
        String codprogramaProd=request.getParameter("cod_prog");
        String nombreComponente="as";
        String nombreAreaEmpresa="as";
        String codForma="";
        String codAreaEmpresa=request.getParameter("codAreaEmpresa");
        Date fechaAprobacionCellado=new Date();
        String observacionLote="";
        int codSeguimientoDosificado=0;
        NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
        DecimalFormat format = (DecimalFormat)nf;
        format.applyPattern("#,##0.00");
        NumberFormat nf1= NumberFormat.getNumberInstance(Locale.ENGLISH);
        DecimalFormat formatNum = (DecimalFormat)nf1;
        formatNum.applyPattern("###0.##");
        
        SimpleDateFormat sdfDias=new SimpleDateFormat("dd/MM/yyyy");
        SimpleDateFormat sdfHoras=new SimpleDateFormat("HH:mm");
        String indicacionesAdicionalesDosificado="";
        int codFormulaMaestra=0;
        int codTipoPrograma=0;
        int codActividadCambioFormato=0;
        int codActividadArmadoFiltros=0;
        int codActividadReguladoEquipo=0;
        int codActividadDosificado=0;
        int codSeguimientoControlDosificado=0;
        int codActividadAcomodado=0;
        boolean permisoVerificacion=false;
        boolean permisoAcomodado=false;
        boolean permisoCambioFormato=false;
        boolean permisoEspDespiroge=false;
        boolean permisoPorosidad=false;
        out.println("<script>sqlConnection.verificarRegistroPendiente('"+codprogramaProd+"','"+codLote+"',6)</script>");
        String arrayPersonal="";
        arrayPersonal+="<option value='0' selected>-Seleccione una opción-</option>";
                                    
                try
                {
                    Connection con=null;
                    con=Util.openConnection(con);
                    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    String consulta="select pp.COD_TIPO_PROGRAMA_PROD,pp.COD_FORMULA_MAESTRA,pp.COD_COMPPROD,cp.COD_FORMA,p.nombre_prod,f.abreviatura_forma,cp.nombre_prod_semiterminado,cp.NOMBRE_GENERICO,f.nombre_forma,cp.REG_SANITARIO,"+
                                    " ep.nombre_envaseprim,cp.VIDA_UTIL,pp.CANT_LOTE_PRODUCCION,ppp.FECHA_FINAL," +
                                    " pp.COD_FORMULA_MAESTRA,sdl.FECHA_CIERRE,sdl.FECHA_APROBACION_SELLADO"+
                                    " ,ISNULL(cp.VOLUMEN_ENVASE_PRIMARIO,'') as VOLUMEN_ENVASE_PRIMARIO," +
                                    " ISNULL(sdl.COD_PERSONAL_RESPONSABLE,0) as COD_PERSONAL_RESPONSABLE," +
                                    " ISNULL(sdl.OBSERVACIONES,'') as OBSERVACIONES," +
                                    " ISNULL(sdl.COD_PERSONAL_SUPERVISOR,0) as COD_PERSONAL_SUPERVISOR,"+
                                    " ISNULL(sdl.COD_PERSONAL_APRUEBA_PESO,0) as COD_PERSONAL_APRUEBA_PESO,"+
                                    " ISNULL(sdl.COD_SEGUIMIENTO_DOSIFICADO_LOTE,0) as COD_SEGUIMIENTO_DOSIFICADO_LOTE," +
                                    " isnull(cpc.COD_RECETA_DOSIFICADO,0) as COD_RECETA_DOSIFICADO,ISNULL(cpc.ENVASADO_CON_GAS_NITROGENO,0) as ENVASADO_CON_GAS_NITROGENO" +
                                    " ,ISNULL(dpff.PRECAUCIONES_DOSIFICADO,'') as PRECAUCIONES_DOSIFICADO,isnull(dpff.PRE_INDICACIONES_DOSIFICADO,'') as PRE_INDICACIONES_DOSIFICADO"+
                                    " ,isnull(dpff.INDICACIONES_DOSIFICADO,'') as INDICACIONES_DOSIFICADO" +
                                    " ,isnull(cpc.INDICACION_ADICIONAL_DOSIFICADO,'') as INDICACION_ADICIONAL_DOSIFICADO" +
                                    " ,isnull(afm.COD_ACTIVIDAD_FORMULA, 0) as codActividadCambioFormato,"+
                                    " isnull(afm1.COD_ACTIVIDAD_FORMULA, 0) as codActividadArmadoFiltros" +
                                    " ,isnull(afm2.COD_ACTIVIDAD_FORMULA,0) as codActividadReguladoEquipo"+
                                    " ,isnull(afm8.COD_ACTIVIDAD_FORMULA,0) as codActividadAcomodado"+
                                    " ,isnull(conjunta.loteAsociado,'') as loteAsociado,isnull(conjunta.cantAsociado,0) as cantAsociado" +
                                    " ,isnull(sdl.COD_ESTADO_HOJA,0) as COD_ESTADO_HOJA," +
                                    " isnull(sdl.COD_PERSONAL_APRUEBA_DESPEJE,0) as COD_PERSONAL_APRUEBA_DESPEJE" +
                                    " ,isnull(cpp.NOMBRE_COLORPRESPRIMARIA,'') as colorPresPrim,isnull(afm7.COD_ACTIVIDAD_FORMULA, 0) as codActividadDosificado" +
                                    ", isnull(scdl.COD_SEGUIMIENTO_CONTROL_DOSIFICADO_LOTE, 0) as COD_SEGUIMIENTO_CONTROL_DOSIFICADO_LOTE"+
                                    " from PROGRAMA_PRODUCCION pp inner join COMPONENTES_PROD cp on cp.COD_COMPPROD=pp.COD_COMPPROD"+
                                    " inner join FORMAS_FARMACEUTICAS f on f.cod_forma=cp.COD_FORMA"+
                                    " inner join productos p on p.cod_prod=cp.COD_PROD"+
                                    " inner join PRESENTACIONES_PRIMARIAS ppm on ppm.COD_COMPPROD=cp.COD_COMPPROD and ppm.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD"+
                                    " inner join ENVASES_PRIMARIOS ep on ep.cod_envaseprim=ppm.COD_ENVASEPRIM" +
                                    " inner join PROGRAMA_PRODUCCION_PERIODO ppp on pp.COD_PROGRAMA_PROD=ppp.COD_PROGRAMA_PROD" +
                                    " left outer join COLORES_PRESPRIMARIA cpp on cpp.COD_COLORPRESPRIMARIA=cp.COD_COLORPRESPRIMARIA" +
                                    " left outer join SEGUIMIENTO_DOSIFICADO_LOTE sdl on "+
                                    " sdl.COD_LOTE=pp.COD_LOTE_PRODUCCION and sdl.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD" +
                                    " left outer join SEGUIMIENTO_CONTROL_DOSIFICADO_LOTE scdl on scdl.COD_LOTE ="+
                                    " pp.COD_LOTE_PRODUCCION and scdl.COD_PROGRAMA_PROD = pp.COD_PROGRAMA_PROD" +
                                    " left outer join COMPONENTES_PROD_RECETA cpc on cpc.COD_COMPROD=pp.COD_COMPPROD"+
                                    " left outer join DESCRIPCION_PROCESOS_FORMA_FARMACEUTICA dpff on dpff.COD_FORMA=cp.COD_FORMA" +
                                    " left outer join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_AREA_EMPRESA =96 and afm.COD_ACTIVIDAD = 87 and afm.COD_FORMULA_MAESTRA ="+
                                    " pp.COD_FORMULA_MAESTRA and afm.COD_PRESENTACION=0 left outer join ACTIVIDADES_FORMULA_MAESTRA afm1 on afm1.COD_AREA_EMPRESA ="+
                                    " 96 and afm1.COD_ACTIVIDAD = 53 and afm1.COD_FORMULA_MAESTRA =pp.COD_FORMULA_MAESTRA and afm1.COD_PRESENTACION=0" +
                                    " left outer join ACTIVIDADES_FORMULA_MAESTRA afm2 on afm2.COD_AREA_EMPRESA =96 " +
                                    " and afm2.COD_ACTIVIDAD = 271 and afm2.COD_FORMULA_MAESTRA =pp.COD_FORMULA_MAESTRA and afm2.COD_PRESENTACION=0" +
                                    " left outer join ACTIVIDADES_FORMULA_MAESTRA afm7 on afm7.COD_AREA_EMPRESA =96 " +
                                    " and afm7.COD_ACTIVIDAD = 29 and afm7.COD_FORMULA_MAESTRA =pp.COD_FORMULA_MAESTRA and afm7.COD_PRESENTACION = 0"+
                                    " left outer join ACTIVIDADES_FORMULA_MAESTRA afm8 on afm8.COD_AREA_EMPRESA =96 " +
                                    " and afm8.COD_ACTIVIDAD = 65 and afm8.COD_FORMULA_MAESTRA =pp.COD_FORMULA_MAESTRA and afm8.COD_PRESENTACION = 0"+
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
                    String codPersonalResponsable="";
                    String codRecetaDosificado="";
                    boolean envasadoConGasNitrogeno=false;
                    int codPersonalApruebaPeso=0;
                    String observaciones="";
                    String precaucionesDosificado="";
                    String preIndicacionesDosificado="";
                    String indicacionesDosificado="";
                    char b=13;char c=10;
                    if(res.next())
                    {
                        codActividadAcomodado=res.getInt("codActividadAcomodado");
                        codSeguimientoControlDosificado=res.getInt("COD_SEGUIMIENTO_CONTROL_DOSIFICADO_LOTE");
                        codPersonalApruebaDespeje=res.getInt("COD_PERSONAL_APRUEBA_DESPEJE");
                        codEstadoHoja=res.getInt("COD_ESTADO_HOJA");
                        codActividadReguladoEquipo=res.getInt("codActividadReguladoEquipo");
                        codActividadArmadoFiltros=res.getInt("codActividadArmadoFiltros");
                        codActividadCambioFormato=res.getInt("codActividadCambioFormato");
                        codActividadDosificado=res.getInt("codActividadDosificado");
                        if(codActividadReguladoEquipo==0)out.println("<script>alert('No se encuentran asociadas una o mas de las siguientes actividades:REGULADO DEL EQUIPO PARA APROBACION DE PESO');window.close();</script>");
                        if(codActividadArmadoFiltros==0)out.println("<script>alert('No se encuentran asociadas una o mas de las siguientes actividades:Armado de Filtros');window.close();</script>");
                        if(codActividadCambioFormato==0)out.println("<script>alert('No se encuentran asociadas una o mas de las siguientes actividades:CAMBIO DE FORMATO ENVASADORA');window.close();</script>");
                        if(codActividadAcomodado==0)out.println("<script>alert('No se encuentran asociada la actividad de :ACOMODADO DE FRASCOS');window.close();</script>");

                        codFormulaMaestra=res.getInt("COD_FORMULA_MAESTRA");
                        codCompProd=res.getString("COD_COMPPROD");
                        codTipoPrograma=res.getInt("COD_TIPO_PROGRAMA_PROD");
                        indicacionesAdicionalesDosificado=res.getString("INDICACION_ADICIONAL_DOSIFICADO");
                        preIndicacionesDosificado=res.getString("PRE_INDICACIONES_DOSIFICADO").replace(b,'\n').replace("\n", "</br>").replace("</br></br>","<br>");
                        indicacionesDosificado=res.getString("INDICACIONES_DOSIFICADO").replace(b,'\n').replace("\n", "</br>").replace("</br></br>","<br>");
                        precaucionesDosificado=res.getString("PRECAUCIONES_DOSIFICADO").replace(b,'\n').replace("\n", "</br>").replace("</br></br>","<br>");
                        observaciones=res.getString("OBSERVACIONES");
                        codPersonalApruebaPeso=res.getInt("COD_PERSONAL_APRUEBA_PESO");
                        codRecetaDosificado=res.getString("COD_RECETA_DOSIFICADO");
                        envasadoConGasNitrogeno=res.getInt("ENVASADO_CON_GAS_NITROGENO")>0;
                        codPersonalResponsable=res.getString("COD_PERSONAL_RESPONSABLE");
                        codPersonalSupervisor=res.getInt("COD_PERSONAL_SUPERVISOR");
                        fechaCierre=(res.getDate("FECHA_CIERRE")==null?new Date():res.getTimestamp("FECHA_CIERRE"));
                        fechaAprobacionCellado=(res.getDate("FECHA_APROBACION_SELLADO")==null?new Date():res.getTimestamp("FECHA_APROBACION_SELLADO"));
                        codSeguimientoDosificado=res.getInt("COD_SEGUIMIENTO_DOSIFICADO_LOTE");
                        volumen=res.getString("VOLUMEN_ENVASE_PRIMARIO");
                        nombreProducto=res.getString("nombre_prod");
                        codForma=res.getString("COD_FORMA");
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
                                                       <label  class="inline">DOSIFICADO</label>
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
                                                               <label  class="inline">DESPEJE DE LINEA DE DOSIFICADO</label>
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
                                <div class="large-12 medium-12 small-12 large-centered medium-centered small-centered columns" style="padding:8px;" >
                                    <span style="font-weight:bold;">PRECAUCIONES:</span><span><%=(precaucionesDosificado)%></span>
                                </div>
                            </div>
                            <%
                            }
                            arrayPersonal+=UtilidadesTablet.operariosAreaProduccionAdminSelect(st, codAreaEmpresa, codPersonal, administrador);

                            out.println("<script>operariosRegistro=\""+arrayPersonal+"\";fechaSistema=\""+sdfDias.format(new Date())+"\"</script>");
                            consulta="select t.COD_TAREA_OM from TAREAS_OM_PERSONAL_LOTE t where t.COD_LOTE='"+codLote+"' and t.COD_PROGRAMA_PROD='"+codprogramaProd+"' and t.COD_TAREA_OM in (7,8,9,10,33)" +
                                     " and COD_PERSONAL='"+codPersonal+"'";
                            System.out.println("consulta permisos "+consulta);
                            res=st.executeQuery(consulta);
                            
                            while(res.next())
                            {
                                if(res.getInt("COD_TAREA_OM")==7)permisoVerificacion=true;
                                if(res.getInt("COD_TAREA_OM")==8)permisoCambioFormato=true;
                                if(res.getInt("COD_TAREA_OM")==9)permisoEspDespiroge=true;
                                if(res.getInt("COD_TAREA_OM")==10)permisoPorosidad=true;
                                if(res.getInt("COD_TAREA_OM")==33)permisoAcomodado=true;
                            }
                            %>




<div class="row"  style="margin-top:5px" >
            <div class="large-12 medium-12 small-12 large-centered medium-centered small-centered columns" >

                        <div class="row">
                           <div class="large-12 medium-12 small-12 columns divHeaderClass" >
                                   <label  class="inline">Dosificado</label>
                            </div>
                        </div>
                        <div class="row" >
                            <div  class="divContentClass large-12 medium-12 small-12 columns" style="padding-top:12px;line-height:20px;">
                             <%
                                if(permisoAcomodado||administrador)
                                {
                             %>
                                <span style="top:10px;">Realice el acomodado de frascos y registre las cantidades</span>
                                <table style="width:100%;margin-top:8px" id="registroAcomodadoFrascos" cellpadding="0px" cellspacing="0px">
                                     <tr >
                                       <td class="tableHeaderClass"  style="text-align:center" colspan="6">
                                           <span class="textHeaderClass">Acomodado y pesaje de Frascos Vacíos</span>
                                       </td>
                                     </tr>
                                   <tr >
                                       <td class="tableHeaderClass"  style="text-align:center">
                                           <span class="textHeaderClass">Personal</span>
                                       </td>
                                       <td class="tableHeaderClass"  style="text-align:center">
                                           <span class="textHeaderClass">Cantidad</span>
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

                                    consulta="select sppp.COD_PERSONAL,sppp.FECHA_INICIO,sppp.FECHA_FINAL,"+
                                             " sppp.HORAS_HOMBRE,sppp.UNIDADES_PRODUCIDAS"+
                                             " from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sppp"+
                                             " where sppp.COD_LOTE_PRODUCCION = '"+codLote+"' and sppp.COD_PROGRAMA_PROD = '"+codprogramaProd+"' and"+
                                             " sppp.COD_FORMULA_MAESTRA = '"+codFormulaMaestra+"' and sppp.COD_COMPPROD = '"+codCompProd+"' and"+
                                             " sppp.COD_TIPO_PROGRAMA_PROD = '"+codTipoPrograma+"' and sppp.COD_ACTIVIDAD_PROGRAMA = '"+codActividadAcomodado+"'" +
                                             (administrador?"":" and sppp.cod_personal='"+codPersonal+"'")+
                                             " order by sppp.FECHA_INICIO";
                                    System.out.println("consula seguimiento acomodado "+consulta);
                                    res=st.executeQuery(consulta);
                                    while(res.next())
                                    {
                                        out.println("<tr onclick='seleccionarFila(this);' ><td class='tableCell' style='text-align:left'>"+
                                                " <select "+(administrador?"disabled":"")+" id='codPersonalAcomodado"+res.getRow()+"'>"+arrayPersonal+"</select><script>codPersonalAcomodado"+res.getRow()+".value='"+res.getString("COD_PERSONAL")+"'</script></td>"+
                                                " <td class='tableCell' style='text-align:center;width:6em;'><input "+(administrador?"disabled":"")+" type='tel'  value='"+res.getInt("UNIDADES_PRODUCIDAS")+"'></td>" +
                                                " <td class='tableCell' style='text-align:left'><input "+(administrador?"disabled":"")+" onclick='seleccionarDatePickerJs(this);' id='fechaCambio"+res.getRow()+"' type='text' value='"+sdfDias.format(res.getTimestamp("FECHA_INICIO"))+"'></td>" +
                                                " <td class='tableCell' style='text-align:left;width:6em;'><input "+(administrador?"disabled":"")+" type='text' onclick='seleccionarHora(this);' id='fechaIniCFE"+res.getRow()+"' onkeyup='calcularDiferenciaHorasAlternativo(this);' onfocus='calcularDiferenciaHorasAlternativo(this);' value='"+sdfHoras.format(res.getTimestamp("FECHA_INICIO"))+"'></td>" +
                                                " <td class='tableCell' style='text-align:left;width:6em;'><input "+(administrador?"disabled":"")+" type='text' onclick='seleccionarHora(this);' id='fechaFinCFE"+res.getRow()+"' onkeyup='calcularDiferenciaHorasAlternativo(this);' onfocus='calcularDiferenciaHorasAlternativo(this);' value='"+sdfHoras.format(res.getTimestamp("FECHA_FINAL"))+"'></td>" +
                                                " <td class='tableCell' style='text-align:center;width:6em;' aling='center'><span class='textHeaderClassBody' style='font-weight:normal'>"+res.getDouble("HORAS_HOMBRE")+"</span></td>" +
                                                "</tr>");
                                    }
                            %>
                             </table>
                             <div class="row">
                               <div class="large-5 medium-5 small-4 columns" style="">&nbsp;</div>
                              <div class="large-1 medium-1 small-2 columns">
                                    <button <%=(administrador?"disabled":"")%> class="small button succes radius buttonAction" onclick="nuevoRegistro('registroAcomodadoFrascos',true)">+</button>
                              </div>
                              <div class="large-1 medium-1 small-2 columns">
                                        <button <%=(administrador?"disabled":"")%> class="small button succes radius buttonAction" onclick="eliminarRegistroTabla('registroAcomodadoFrascos')">-</button>
                              </div>
                              <div class="large-5 medium-5 small-4 columns" style="">&nbsp;</div>
                           </div>
                           <%
                                }
                            %>
                            <span style="top:10px;"><%=((permisoVerificacion||administrador)?preIndicacionesDosificado:"")%></span>
                            
                        <div class="row">
                            <div class="large-12 medium-12 small-12 large-centered medium-centered small-centered columns">
                                <%
                                String cabeceraPersonal="";
                                       String innerCabeceraPersonal="";
                                       String detallePersonal="";
                                       int contDetalle=0;
                                if(permisoVerificacion||administrador)
                                {
                                       
                                       if(administrador)
                                        {
                                            consulta="select s.COD_PERSONAL,isnull((p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+'<br>'+p.NOMBRES_PERSONAL),(pt.AP_PATERNO_PERSONAL+' '+pt.AP_MATERNO_PERSONAL+'<br>'+pt.NOMBRES_PERSONAL))as nombrePersonal"+
                                                     " from SEGUIMIENTO_DOSIFICADO_LOTE_PREFILTRADO s"+
													 " left outer join personal p on p.COD_PERSONAL=s.COD_PERSONAL"+
													 " left outer join personal_temporal pt on pt.COD_PERSONAL=s.COD_PERSONAL"+
                                                     " where s.COD_SEGUIMIENTO_DOSIFICADO_LOTE='"+codSeguimientoDosificado+"'"+
                                                     " group by s.COD_PERSONAL,p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRES_PERSONAL,pt.AP_PATERNO_PERSONAL,pt.AP_MATERNO_PERSONAL,pt.NOMBRES_PERSONAL"+
                                                     " order by 2";
                                            System.out.println("consulta esp"+consulta);
                                            res=st.executeQuery(consulta);
                                            while(res.next())
                                            {
                                                innerCabeceraPersonal+="<td colspan='5' class='tableHeaderClass' style='text-align:center;'><span class='textHeaderClass'>"+res.getString("nombrePersonal")+"</span></td>";
                                                cabeceraPersonal+=" ,isnull(sedl"+res.getRow()+".PRUEBA_DE_INTEGRIDAD_POSITIVO, 3) as PRUEBA_DE_INTEGRIDAD_POSITIVO"+res.getRow()+", isnull(sedl"+res.getRow()+".PRESION_REGISTRADA, '') as PRESION_REGISTRADA"+res.getRow()+","+
                                                                  " ISNULL(sedl"+res.getRow()+".NUMERO_FILTROS_UTILIZADOS, 0) as NUMERO_FILTROS_UTILIZADOS"+res.getRow()+"";
                                                detallePersonal+=" left outer join SEGUIMIENTO_DOSIFICADO_LOTE_PREFILTRADO sedl"+res.getRow()+" on"+
                                                                 " sedl"+res.getRow()+".COD_ESPECIFICACION_FILTRADO=fp.COD_FILTRO_PRODUCCION and "+
                                                                 " sedl"+res.getRow()+".COD_SEGUIMIENTO_DOSIFICADO_LOTE = '"+codSeguimientoDosificado+"'" +
                                                                 " and sedl"+res.getRow()+".COD_PERSONAL='"+res.getInt("COD_PERSONAL")+"'";
                                                contDetalle=res.getRow();
                                            }

                                        }
                               out.println("<table style='width:100%;margin-top:2%' id='dataPreFiltrado' cellpadding='0px' cellspacing='0px'>" +
                                       "<tr><td class='tableHeaderClass' colspan='"+(4+(contDetalle>0?contDetalle*5:5))+"' style='text-align:center' ><span class='textHeaderClass'>DATOS PARA FILTRAR</span></td></tr>"+
                                          "<tr><td class='tableHeaderClass' colspan='4' style='text-align:center' ><span class='textHeaderClass'>ESPECIFICACIONES</span></td>"+
                                           " <td class='tableHeaderClass' colspan='"+(contDetalle>0?contDetalle*5:5)+"' style='text-align:center;'><span class='textHeaderClass'>CONDICIONES DEL PROCESO</span></td>"+
                                           "</tr>"+
                                           " <tr><td class='tableHeaderClass' "+(contDetalle>0?"rowspan='2'":"")+"  style='text-align:center' ><span class='textHeaderClass'>Poro del filtro</span></td>"+
                                           "<td class='tableHeaderClass'  "+(contDetalle>0?"rowspan='2'":"")+" style='text-align:center' ><span class='textHeaderClass'>Código de filtro</span></td>"+
                                           " <td class='tableHeaderClass' "+(contDetalle>0?"rowspan='2'":"")+" style='text-align:center;'><span class='textHeaderClass'>Presion de aprobación</span></td>"+
                                           " <td class='tableHeaderClass' "+(contDetalle>0?"rowspan='2'":"")+" style='text-align:center;'><span class='textHeaderClass'>Medio de Filtración</span></td>");
                                           if(administrador)
                                           {
                                               out.println(innerCabeceraPersonal+"</tr><tr>");
                                               for(int i=1;i<=contDetalle;i++)
                                               {
                                                   out.println("<td class='tableHeaderClass' style='text-align:center;'><span class='textHeaderClass'>Prueba de Integridad<br>Positivo</span></td>"+
                                                               " <td class='tableHeaderClass' colspan='2' style='text-align:center;'><span class='textHeaderClass'>Presión Registrada</span></td>"+
                                                               " <td class='tableHeaderClass' colspan='2' style='text-align:center;'><span class='textHeaderClass'>Numero de filtros<br> utilizados para<br> todo el proceso</span></td>");
                                               }
                                               out.println("</tr>");
                                           }
                                           else
                                           {
                                                    out.println("<td class='tableHeaderClass' style='text-align:center;'><span class='textHeaderClass'>Prueba de Integridad<br>Positivo</span></td>"+
                                                               " <td class='tableHeaderClass' colspan='2' style='text-align:center;'><span class='textHeaderClass'>Presión Registrada</span></td>"+
                                                               " <td class='tableHeaderClass' colspan='2' style='text-align:center;'><span class='textHeaderClass'>Numero de filtros<br> utilizados para<br> todo el proceso</span></td></tr>");
                                           }
                              
                                consulta="select fp.CANTIDAD_FILTRO,fp.COD_FILTRO_PRODUCCION,fp.COD_ESTADO_REGISTRO,fp.COD_MEDIO_FILTRACION,"+
                                         "mf.NOMBRE_MEDIO_FILTRACION,fp.COD_UNIDAD_MEDIDA,um.ABREVIATURA,fp.CODIGO_FILTRO_PRODUCCION,fp.PRESION_DE_APROBACION"+
                                         (contDetalle>0?cabeceraPersonal:" ,isnull(sdlp.PRUEBA_DE_INTEGRIDAD_POSITIVO, 3) as PRUEBA_DE_INTEGRIDAD_POSITIVO, isnull(sdlp.PRESION_REGISTRADA, '') as PRESION_REGISTRADA,"+
                                         " ISNULL(sdlp.NUMERO_FILTROS_UTILIZADOS, 0) as NUMERO_FILTROS_UTILIZADOS")+
                                         " ,isnull(um1.ABREVIATURA,'') as unidadPresion " +
                                         " from FILTROS_PRODUCCION fp inner join FILTROS_PRODUCCION_PRODUCTOS fpp on "+
                                         " fp.COD_FILTRO_PRODUCCION=fpp.COD_FILTRO_PRODUCCION inner join COMPONENTES_PROD cp on cp.COD_PROD=fpp.COD_PROD"+
                                         " inner join UNIDADES_MEDIDA um on fp.COD_UNIDAD_MEDIDA =um.COD_UNIDAD_MEDIDA and fp.COD_ESTADO_REGISTRO = 1"+
                                         " inner join MEDIOS_FILTRACION mf on mf.COD_MEDIO_FILTRACION =fp.COD_MEDIO_FILTRACION"+
                                         (contDetalle>0?detallePersonal:" left outer join SEGUIMIENTO_DOSIFICADO_LOTE_PREFILTRADO sdlp on"+
                                         " sdlp.COD_ESPECIFICACION_FILTRADO = fp.COD_FILTRO_PRODUCCION and"+
                                         " sdlp.COD_SEGUIMIENTO_DOSIFICADO_LOTE = '"+codSeguimientoDosificado+"'" +
                                         " and sdlp.COD_PERSONAL='"+codPersonal+"'")+
                                         " inner join UNIDADES_MEDIDA um1 on um1.COD_UNIDAD_MEDIDA =fp.COD_UNIDAD_MEDIDA_PRESION"+
                                         " WHERE cp.COD_COMPPROD='"+codCompProd+"'"+
                                         " order by fp.CODIGO_FILTRO_PRODUCCION";
                                System.out.println("consulta cargar seguimiento "+consulta);
                                res=st.executeQuery(consulta);
                                
                                while(res.next())
                                {
                                    out.println("<tr>");
                                    %>
                                     
                                                   <td class="tableCell" style="text-align:center">
                                                       <input type="hidden"  value="<%=res.getString("COD_FILTRO_PRODUCCION")%>"/>
                                                       <span class="textHeaderClassBody" style="font-weight:normal"><%=res.getString("CANTIDAD_FILTRO")+" "+res.getString("ABREVIATURA")%></span>
                                                   </td>
                                                   <td class="tableCell" style="text-align:center;">
                                                       <span class="textHeaderClassBody" style="font-weight:normal"><%=res.getString("CODIGO_FILTRO_PRODUCCION")%></span>
                                                   </td>
                                                   <td class="tableCell" style="text-align:center;">
                                                       <span class="textHeaderClassBody" style="font-weight:normal"><%=res.getString("PRESION_DE_APROBACION")+" "+res.getString("unidadPresion")%></span>
                                                   </td>
                                                   <td class="tableCell" style="text-align:center;">
                                                       <span class="textHeaderClassBody" style="font-weight:normal"><%=res.getString("NOMBRE_MEDIO_FILTRACION")%></span>
                                                   </td>
                                                   
                                       
                                       
                                    <%
                                    if(administrador)
                                    {
                                        for(int i=1;i<=contDetalle;i++)
                                        {
                                            out.println("<td class='tableCell' style='text-align:center;'><input disabled type='checkbox' style='width:20px;height:20px'   id='"+i+"positivo"+res.getRow()+"'  "+(res.getInt("PRUEBA_DE_INTEGRIDAD_POSITIVO"+i)==1?"checked":"")+"/>"+
                                                        " <label for='"+i+"positivo"+res.getRow()+"'/></td><td class='tableCell' style='text-align:center;border-right:none'>"+
                                                        " <input class='textHeaderClassBody' size='4' disabled  style='margin-top:9%' type='text' value='"+res.getString("PRESION_REGISTRADA"+i)+"'></td>"+
                                                        " <td class='tableCell' style='text-align:center;border-left:none;'><span class='textHeaderClassBody' style='margin-top:6px; margin-left:3px;font-weight:normal' ><"+res.getString("unidadPresion")+"</span></td>"+
                                                        " <td class='tableCell' style='text-align:center;'><input class='textHeaderClassBody' disabled style='margin-top:9%' type='text' value='"+res.getInt("NUMERO_FILTROS_UTILIZADOS"+i)+"' size='2'/></td>"+
                                                        " <td class='tableCell' style='text-align:center;'><span class='textHeaderClassBody' style='font-weight:normal'>unid</span></td>");
                                        }
                                    }
                                    else
                                    {
                                        out.println("<td class='tableCell' style='text-align:center;'><input type='checkbox' style='width:20px;height:20px'   id='positivo"+res.getRow()+"'  "+(res.getInt("PRUEBA_DE_INTEGRIDAD_POSITIVO")==1?"checked":"")+"/>"+
                                                    " <label for='positivo"+res.getRow()+"'/></td><td class='tableCell' style='text-align:center;border-right:none'>"+
                                                    " <input class='textHeaderClassBody' size='4'  style='margin-top:9%' type='text' value='"+res.getString("PRESION_REGISTRADA")+"'></td>"+
                                                    " <td class='tableCell' style='text-align:center;border-left:none;'><span class='textHeaderClassBody' style='margin-top:6px; margin-left:3px;font-weight:normal' ><"+res.getString("unidadPresion")+"</span></td>"+
                                                    " <td class='tableCell' style='text-align:center;'><input class='textHeaderClassBody' style='margin-top:9%' type='text' value='"+res.getInt("NUMERO_FILTROS_UTILIZADOS")+"' size='2'/></td>"+
                                                    " <td class='tableCell' style='text-align:center;'><span class='textHeaderClassBody' style='font-weight:normal'>unid</span></td>");
                                    }
                                    out.println("</tr>");
                                }
                                out.println("</table>");
                             }
                            if(permisoVerificacion||administrador)
                            {
                              %>
                              


                              <table style="width:100%;margin-top:8px" id="registroCambioFormato" cellpadding="0px" cellspacing="0px">
                                     <tr >
                                       <td class="tableHeaderClass"  style="text-align:center" colspan="5">
                                           <span class="textHeaderClass">Cambio de Formato Envasadora</span>
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
                                     
                                    consulta="select sppp.COD_PERSONAL,sppp.FECHA_INICIO,sppp.FECHA_FINAL,"+
                                             " sppp.HORAS_HOMBRE"+
                                             " from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sppp"+
                                             " where sppp.COD_LOTE_PRODUCCION = '"+codLote+"' and sppp.COD_PROGRAMA_PROD = '"+codprogramaProd+"' and"+
                                             " sppp.COD_FORMULA_MAESTRA = '"+codFormulaMaestra+"' and sppp.COD_COMPPROD = '"+codCompProd+"' and"+
                                             " sppp.COD_TIPO_PROGRAMA_PROD = '"+codTipoPrograma+"' and sppp.COD_ACTIVIDAD_PROGRAMA = '"+codActividadCambioFormato+"'" +
                                             (administrador?"":" and sppp.cod_personal='"+codPersonal+"'")+
                                             " order by sppp.FECHA_INICIO";
                                    System.out.println("consula seguimiento cambio de formato envasadora "+consulta);
                                    res=st.executeQuery(consulta);
                                    while(res.next())
                                    {
                                        out.println("<tr onclick='seleccionarFila(this);' ><td class='tableCell' style='text-align:left'>"+
                                                " <select "+(administrador?"disabled":"")+" id='codPersonalCambio"+res.getRow()+"'>"+arrayPersonal+"</select><script>codPersonalCambio"+res.getRow()+".value='"+res.getString("COD_PERSONAL")+"'</script></td>"+
                                                " <td class='tableCell' style='text-align:left'><input "+(administrador?"disabled":"")+" onclick='seleccionarDatePickerJs(this);' id='fechaCambio"+res.getRow()+"' type='text' value='"+sdfDias.format(res.getTimestamp("FECHA_INICIO"))+"'></td>" +
                                                " <td class='tableCell' style='text-align:left;width:6em;'><input "+(administrador?"disabled":"")+" type='text' onclick='seleccionarHora(this);' id='fechaIniCFE"+res.getRow()+"' onkeyup='calcularDiferenciaHoras(this);' onfocus='calcularDiferenciaHoras(this);' value='"+sdfHoras.format(res.getTimestamp("FECHA_INICIO"))+"'></td>" +
                                                " <td class='tableCell' style='text-align:left;width:6em;'><input "+(administrador?"disabled":"")+" type='text' onclick='seleccionarHora(this);' id='fechaFinCFE"+res.getRow()+"' onkeyup='calcularDiferenciaHoras(this);' onfocus='calcularDiferenciaHoras(this);' value='"+sdfHoras.format(res.getTimestamp("FECHA_FINAL"))+"'></td>" +
                                                " <td class='tableCell' style='text-align:center;width:6em;' aling='center'><span class='textHeaderClassBody' style='font-weight:normal'>"+res.getDouble("HORAS_HOMBRE")+"</span></td>" +
                                                "</tr>");
                                    }
                                    %>
                           </table>
                           <div class="row">
                               <div class="large-5 medium-5 small-4 columns" style="">&nbsp;</div>
                              <div class="large-1 medium-1 small-2 columns">
                                    <button <%=(administrador?"disabled":"")%> class="small button succes radius buttonAction" onclick="nuevoRegistro('registroCambioFormato',false)">+</button>
                              </div>
                              <div class="large-1 medium-1 small-2 columns">
                                        <button <%=(administrador?"disabled":"")%> class="small button succes radius buttonAction" onclick="eliminarRegistroTabla('registroCambioFormato')">-</button>
                              </div>
                              <div class="large-5 medium-5 small-4 columns" style="">&nbsp;</div>
                           </div>
                           <table style="width:100%;margin-top:8px" id="registroArmadoFiltro" cellpadding="0px" cellspacing="0px">
                                    <tr >
                                       <td class="tableHeaderClass"  style="text-align:center" colspan="5">
                                           <span class="textHeaderClass">Armado de Filtros,Bombas y envio de muestra de agua</span>
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
                                    consulta="select sppp.COD_PERSONAL,sppp.FECHA_INICIO,sppp.FECHA_FINAL,"+
                                             " sppp.HORAS_HOMBRE"+
                                             " from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sppp"+
                                             " where sppp.COD_LOTE_PRODUCCION = '"+codLote+"' and sppp.COD_PROGRAMA_PROD = '"+codprogramaProd+"' and"+
                                             " sppp.COD_FORMULA_MAESTRA = '"+codFormulaMaestra+"' and sppp.COD_COMPPROD = '"+codCompProd+"' and"+
                                             " sppp.COD_TIPO_PROGRAMA_PROD = '"+codTipoPrograma+"' and sppp.COD_ACTIVIDAD_PROGRAMA = '"+codActividadArmadoFiltros+"'"+
                                            (administrador?"":" and sppp.cod_personal='"+codPersonal+"'")+
                                             " order by sppp.FECHA_INICIO";
                                    System.out.println("consula seguimiento cambio de formato envasadora "+consulta);
                                    res=st.executeQuery(consulta);
                                    while(res.next())
                                    {
                                        out.println("<tr onclick='seleccionarFila(this)' ><td class='tableCell' style='text-align:left'>"+
                                                " <select "+(administrador?"disabled":"")+" id='codPersonalArmado"+res.getRow()+"'>"+arrayPersonal+"</select><script>codPersonalArmado"+res.getRow()+".value='"+res.getString("COD_PERSONAL")+"'</script></td>"+
                                                " <td class='tableCell' style='text-align:left'><input "+(administrador?"disabled":"")+" id='fechaArmado"+res.getRow()+"' type='text' onclick='seleccionarDatePickerJs(this)' value='"+sdfDias.format(res.getTimestamp("FECHA_INICIO"))+"'>" +
                                                "</td>" +
                                                " <td class='tableCell' style='text-align:left;width:6em;'><input "+(administrador?"disabled":"")+" type='text' id='fechaIniFBA"+res.getRow()+"' onclick='seleccionarHora(this);' onkeyup='calcularDiferenciaHoras(this);' onfocus='calcularDiferenciaHoras(this);' value='"+sdfHoras.format(res.getTimestamp("FECHA_INICIO"))+"'></td>" +
                                                " <td class='tableCell' style='text-align:left;width:6em;'><input "+(administrador?"disabled":"")+" type='text' id='fechaFinFBA"+res.getRow()+"' onclick='seleccionarHora(this);' onkeyup='calcularDiferenciaHoras(this);' onfocus='calcularDiferenciaHoras(this);' value='"+sdfHoras.format(res.getTimestamp("FECHA_FINAL"))+"'></td>" +
                                                " <td class='tableCell' style='text-align:center;width:6em;' aling='center'><span class='textHeaderClassBody' style='font-weight:normal'>"+res.getDouble("HORAS_HOMBRE")+"</span></td>" +
                                                "</tr>");
                                    }
                                    %>
                           </table>
                            <div class="row">
                                <div class="large-5 medium-5 small-4 columns" style="">&nbsp;</div>
                              <div class="large-1 medium-1 small-2 columns">
                                    <button <%=(administrador?"disabled":"")%> class="small button succes radius buttonAction" onclick="nuevoRegistro('registroArmadoFiltro',false)">+</button>
                              </div>
                              <div class="large-1 medium-1 small-2 columns">
                                    <button <%=(administrador?"disabled":"")%> class="small button succes radius buttonAction" onclick="eliminarRegistroTabla('registroArmadoFiltro')">-</button>
                              </div>
                              <div class="large-5 medium-5 small-4 columns" style="">&nbsp;</div>
                           </div>
                            </div>
                        </div>
                        <%
                        }
                        if(permisoEspDespiroge||administrador)
                        {
                        %>
                    <center>
                    </center>
                     <span style="top:10px;"><%=(indicacionesDosificado)%></span>
                     <%=(envasadoConGasNitrogeno?"<br><span style='font-weight:bold;'>"+(indicacionesAdicionalesDosificado.equals("")?"7. ENVASAR EL PRODUCTO CON GAS NITROGENO":indicacionesAdicionalesDosificado)+"</span>":"")%>
                     <table style="width:100%;margin-top:2%" id="dataEspecificaciones" cellpadding="0px" cellspacing="0px">
                        

                        <%
                           cabeceraPersonal="";
                           innerCabeceraPersonal="";
                           detallePersonal="";
                           contDetalle=0;
                           if(administrador)
                            {
                                consulta="select s.COD_PERSONAL,isnull((p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+'<br>'+p.NOMBRES_PERSONAL),(pt.AP_PATERNO_PERSONAL+' '+pt.AP_MATERNO_PERSONAL+'<br>'+pt.NOMBRES_PERSONAL))as nombrePersonal"+
                                         " from SEGUIMIENTO_ESPECIFICACIONES_DOSIFICADO_LOTE s"+
										 " left outer join personal p on p.COD_PERSONAL=s.COD_PERSONAL"+
										 " left outer join personal_temporal pt on pt.COD_PERSONAL=s.COD_PERSONAL"+
                                         " where s.COD_SEGUIMIENTO_DOSIFICADO_LOTE='"+codSeguimientoDosificado+"'"+
                                         " group by s.COD_PERSONAL,p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRES_PERSONAL,pt.AP_PATERNO_PERSONAL,pt.AP_MATERNO_PERSONAL,pt.NOMBRES_PERSONAL"+
                                         " order by 2";
                                System.out.println("consulta esp per "+consulta);
                                res=st.executeQuery(consulta);
                                while(res.next())
                                {
                                    innerCabeceraPersonal+="<td colspan='2' class='tableHeaderClass' style='text-align:center;'><span class='textHeaderClass'>"+res.getString("nombrePersonal")+"</span></td>";
                                    cabeceraPersonal+="  ,ISNULL(sedl"+res.getRow()+".CONFORME, 0) as CONFORME"+res.getRow()+",ISNULL(sedl"+res.getRow()+".OBSERVACION, '') as OBSERVACION"+res.getRow()+
                                                      ",ISNULL(sedl"+res.getRow()+".VALOR_EXACTO,0) as valorLote"+res.getRow();
                                    detallePersonal+=" left outer join SEGUIMIENTO_ESPECIFICACIONES_DOSIFICADO_LOTE sedl"+res.getRow()+" on"+
                                                     " sedl"+res.getRow()+".COD_ESPECIFICACION_PROCESO=ep.COD_ESPECIFICACION_PROCESO and "+
                                                     " sedl"+res.getRow()+".COD_SEGUIMIENTO_DOSIFICADO_LOTE = '"+codSeguimientoDosificado+"'" +
                                                     " and sedl"+res.getRow()+".COD_PERSONAL='"+res.getInt("COD_PERSONAL")+"'";
                                    contDetalle=res.getRow();
                                }

                            }
                        out.println("<tr><td class='tableHeaderClass' style='text-align:center' colspan='3'><span class='textHeaderClass'>ESPECIFICACIONES DE ETAPA DE DOSIFICADO</span></td>"+
                                    " <td class='tableHeaderClass' style='text-align:center;' colspan='"+(contDetalle>0?(contDetalle*2):2)+"'><span class='textHeaderClass'>CONDICCIONES DE ETAPA </span></td>"+
                                    "</tr><tr><td class='tableHeaderClass' style='text-align:center' "+(contDetalle>0?"rowspan='2'":"")+" ><span class='textHeaderClass'>&nbsp;</span></td>"+
                                    "<td class='tableHeaderClass' style='text-align:center' "+(contDetalle>0?"rowspan='2'":"")+" ><span class='textHeaderClass'>Valor</span></td>"+
                                    "<td class='tableHeaderClass' style='text-align:center' "+(contDetalle>0?"rowspan='2'":"")+" ><span class='textHeaderClass'>Unidades</span></td>");
                       if(administrador)
                       {
                           out.println(innerCabeceraPersonal+"</tr><tr>");
                            for(int i=1;i<=contDetalle;i++)
                            {
                                out.println("<td class='tableHeaderClass' style='text-align:center' ><span class='textHeaderClass'>Conforme</span></td>"+
                                           " <td class='tableHeaderClass' style='text-align:center'><span class='textHeaderClass'>Observación</span></td>");
                            }
                       }
                       else
                       {
                                out.println("<td class='tableHeaderClass' style='text-align:center' ><span class='textHeaderClass'>Conforme</span></td>"+
                                           " <td class='tableHeaderClass' style='text-align:center'><span class='textHeaderClass'>Observación</span></td>");
                       }
                       out.println("</tr>");
                       consulta="select isnull(sum(sppp.HORAS_HOMBRE),0) as horasHombre," +
                               " isnull(sum(scdlp.CANT_AMPOLLAS_ACOND),0) as cantidadAmp"+
                                " from SEGUIMIENTO_CONTROL_DOSIFICADO_LOTE_PERSONAL scdlp inner join SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL"+
                                " sppp on sppp.COD_PERSONAL=scdlp.COD_PERSONAL and scdlp.COD_REGISTRO_ORDEN_MANUFACTURA=sppp.COD_REGISTRO_ORDEN_MANUFACTURA"+
                                " where sppp.COD_LOTE_PRODUCCION='"+codLote+"' and sppp.COD_PROGRAMA_PROD='"+codprogramaProd+"'" +
                                "  and sppp.COD_ACTIVIDAD_PROGRAMA='"+codActividadDosificado+"' and scdlp.COD_SEGUIMIENTO_CONTROL_DOSIFICADO_LOTE='"+codSeguimientoControlDosificado+"'" +
                                " and sppp.cod_personal='"+codPersonal+"'";
                       System.out.println("consulta cantidad  "+consulta);
                       double cantidadAmpollasHora=0;
                       res=st.executeQuery(consulta);
                       if(res.next())
                       {
                           cantidadAmpollasHora=(res.getDouble("horasHombre")>0d?(res.getDouble("cantidadAmp")/res.getDouble("horasHombre")):0d);
                       }
                        consulta="select ep.RESULTADO_ESPERADO_LOTE,ep.COD_TIPO_ESPECIFICACION_PROCESO,ep.RESULTADO_NUMERICO,"+
                                 " ep.COD_ESPECIFICACION_PROCESO,ep.NOMBRE_ESPECIFICACIONES_PROCESO,"+
                                 " isnull(um.ABREVIATURA, 'N.A.') as ABREVIATURA"+
                                 (administrador?cabeceraPersonal:" ,ISNULL(sedl.CONFORME, 0) as CONFORME,ISNULL(sedl.OBSERVACION, '') as OBSERVACION,ISNULL(sedl.VALOR_EXACTO,0) as valorLote")+
                                 /*" ,case when ep.ESPECIFICACION_STANDAR_FORMA = 1 then ep.VALOR_EXACTO"+
                                 " else rd.VALOR_EXACTO end as valorExacto,"+
                                 " case when ep.ESPECIFICACION_STANDAR_FORMA = 1 THEN ep.VALOR_TEXTO"+
                                 " else rd.VALOR_TEXTO end as valorTexto" +*/
                                 " ,ep.PORCIENTO_TOLERANCIA"+
                                 " ,epp.VALOR_EXACTO as valorExacto,epp.VALOR_TEXTO as valorTexto"+
                                 " from ESPECIFICACIONES_PROCESOS ep"+
                                 " left outer join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA =ep.COD_UNIDAD_MEDIDA" +
                                 " left outer join ESPECIFICACIONES_PROCESOS_DOSIFICADO_PRODUCTO epp on epp.COD_ESPECIFICACION_PROCESO"+
                                 " =ep.COD_ESPECIFICACION_PROCESO and epp.COD_COMPPROD='"+codCompProd+"'"+
                                 " left outer join RECETAS_DESPIROGENIZADO rd on rd.COD_ESPECIFICACION_PROCESO"+
                                 " = ep.COD_ESPECIFICACION_PROCESO and rd.COD_RECETA = '"+codRecetaDosificado+"'"+
                                 (administrador?detallePersonal:" left outer join SEGUIMIENTO_ESPECIFICACIONES_DOSIFICADO_LOTE sedl" +
                                 " on sedl.COD_ESPECIFICACION_PROCESO=ep.COD_ESPECIFICACION_PROCESO"+
                                 " and sedl.COD_SEGUIMIENTO_DOSIFICADO_LOTE='"+codSeguimientoDosificado+"'" +
                                 " and sedl.COD_PERSONAL='"+codPersonal+"'")+
                                 " where ep.COD_FORMA = '"+codForma+"' and ep.COD_PROCESO_ORDEN_MANUFACTURA = 3"+
                                 " order by ep.ORDEN";
                                System.out.println("consulta cargar seguimiento esp "+consulta);
                                res=st.executeQuery(consulta);
                                String resultado="";
                                double porcientoTolerancia=0;
                                while(res.next())
                                {
                                    porcientoTolerancia=res.getInt("valorExacto")*res.getDouble("PORCIENTO_TOLERANCIA");
                                    resultado=(res.getDouble("RESULTADO_NUMERICO")>0?(res.getDouble("valorExacto")>0?formatNum.format(res.getDouble("valorExacto")-porcientoTolerancia)+(porcientoTolerancia>0?("-"+formatNum.format(res.getDouble("valorExacto")+porcientoTolerancia)):""):""):res.getString("valorTexto"));
                                    out.println("<tr>");
                                    %>
                                     
                                                   <td class="tableCell" style="text-align:center">
                                                       <input type="hidden"  value="<%=res.getString("COD_ESPECIFICACION_PROCESO")%>"/>
                                                       <span class="textHeaderClassBody" style="font-weight:normal"><%=res.getString("NOMBRE_ESPECIFICACIONES_PROCESO")%></span>
                                                   </td>
                                                   <td class="tableCell" style="text-align:center;">
                                                       <span class="textHeaderClassBody" style="font-weight:normal"><%=resultado==null?"":resultado%></span>
                                                   </td>
                                                   <td class="tableCell" style="text-align:center;">
                                                       <span class="textHeaderClassBody" style="font-weight:normal"><%=res.getString("ABREVIATURA")%></span>
                                                   </td>
                                                   
                                       
                                    <%
                                    if(administrador)
                                    {
                                        for(int i=1;i<=contDetalle;i++)
                                        out.println("<td class='tableCell' style='text-align:center;'>" +
                                                   (res.getInt("RESULTADO_ESPERADO_LOTE")==1?"<span class='textHeaderClassBody' style='font-weight:normal'>"+res.getString("valorLote"+i)+"</span>":
                                                    "<input type='checkbox' id='"+i+"conforme"+res.getRow()+"' disabled style='width:20px;height:20px' "+(res.getInt("conforme"+i)>0?"checked":"")+"/>")+
                                                    "<label for='"+i+"conforme"+res.getRow()+"'/></td>"+
                                                    " <td class='tableCell' style='text-align:center;'><span class='textHeaderClassBody' style='font-weight:normal'>"+res.getString("observacion"+i)+"</span></td>");
                                    }
                                    else out.println("<td class='tableCell' style='text-align:center;'><center>" +
                                                (res.getInt("RESULTADO_ESPERADO_LOTE")==1?"<input type='tel' "+(res.getInt("COD_ESPECIFICACION_PROCESO")==29?"disabled":"")+" value='"+(res.getInt("COD_ESPECIFICACION_PROCESO")==29?formatNum.format(cantidadAmpollasHora):res.getDouble("valorLote"))+"' style='width:5em !important'/>":"<input type='checkbox' id='conforme"+res.getRow()+"'  style='width:20px;height:20px' "+(res.getInt("conforme")>0?"checked":"")+"/>")+
                                                "</center></td>"+
                                                " <td class='tableCell' style='text-align:center;'><input class='textHeaderClassBody' type='text value='"+res.getString("observacion")+"'/>"+
                                                "</td>");
                                  out.println("</tr>");
                                }
                                %>
                        

                     </table>
                     <%
                     }
                     if(permisoVerificacion||administrador)
                     {
                         
                     %>
                     <table style="width:100%;margin-top:8px" id="reguladoEquipoVolumen" cellpadding="0px" cellspacing="0px">
                                    <tr >
                                       <td class="tableHeaderClass"  style="text-align:center" colspan="5">
                                           <span class="textHeaderClass">REGULADO DEL EQUIPO PARA APROBACION DE PESO</span>
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
                                   consulta="select sppp.COD_PERSONAL,sppp.FECHA_INICIO,sppp.FECHA_FINAL,"+
                                             " sppp.HORAS_HOMBRE"+
                                             " from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sppp"+
                                             " where sppp.COD_LOTE_PRODUCCION = '"+codLote+"' and sppp.COD_PROGRAMA_PROD = '"+codprogramaProd+"' and"+
                                             " sppp.COD_FORMULA_MAESTRA = '"+codFormulaMaestra+"' and sppp.COD_COMPPROD = '"+codCompProd+"' and"+
                                             " sppp.COD_TIPO_PROGRAMA_PROD = '"+codTipoPrograma+"' and sppp.COD_ACTIVIDAD_PROGRAMA = '"+codActividadReguladoEquipo+"'" +
                                             (administrador?"":" and sppp.cod_personal='"+codPersonal+"'")+
                                             " order by sppp.FECHA_INICIO";
                                    System.out.println("consula seguimiento regulado equipo "+consulta);
                                    res=st.executeQuery(consulta);
                                    while(res.next())
                                    {
                                        out.println("<tr onclick='seleccionarFila(this);' ><td class='tableCell' style='text-align:left'>"+
                                                " <select "+(administrador?"disabled":"")+" id='codPersonalRegulado"+res.getRow()+"'>"+arrayPersonal+"</select><script>codPersonalRegulado"+res.getRow()+".value='"+res.getString("COD_PERSONAL")+"'</script></td>"+
                                                " <td class='tableCell' style='text-align:left'><input "+(administrador?"disabled":"")+" id='fechaRegulado"+res.getRow()+"' type='text' onclick='seleccionarDatePickerJs(this)' value='"+sdfDias.format(res.getTimestamp("FECHA_INICIO"))+"'></td>" +
                                                " <td class='tableCell' style='text-align:left;width:6em;'><input "+(administrador?"disabled":"")+" type='text' onclick='seleccionarHora(this);' id='fechaIniReguladoVolumen"+res.getRow()+"' onfocus='calcularDiferenciaHoras(this);' onkeyup='calcularDiferenciaHoras(this);' value='"+sdfHoras.format(res.getTimestamp("FECHA_INICIO"))+"'></td>" +
                                                " <td class='tableCell' style='text-align:left;width:6em;'><input "+(administrador?"disabled":"")+" type='text' onclick='seleccionarHora(this);' id='fechaFinReguladoVolumen"+res.getRow()+"' onfocus='calcularDiferenciaHoras(this);' onkeyup='calcularDiferenciaHoras(this);' value='"+sdfHoras.format(res.getTimestamp("FECHA_FINAL"))+"'></td>" +
                                                " <td class='tableCell' style='text-align:center;width:6em;' aling='center'><span class='textHeaderClassBody' style='font-weight:normal'>"+res.getDouble("HORAS_HOMBRE")+"</span></td>" +
                                                "</tr>");
                                    }
                                   %>
                     </table>
                      <div class="row">
                          <div class="large-5 medium-5 small-4 columns" style="">&nbsp;</div>
                          <div class="large-1 medium-1 small-2  columns">
                                <button <%=(administrador?"disabled":"")%> class="small button succes radius buttonAction" onclick="nuevoRegistro('reguladoEquipoVolumen',false)">+</button>
                          </div>
                           <div class="large-1 medium-1 small-2 columns">
                                <button <%=(administrador?"disabled":"")%> class="small button succes radius buttonAction" onclick="eliminarRegistroTabla('reguladoEquipoVolumen')">-</button>
                          </div>
                          <div class="large-5 medium-5 small-4 columns" style="">&nbsp;</div>
                       </div>
                       <%
                        }
                      if(administrador)
                      {
                          consulta="select p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL+' '+p.nombre2_personal"+
                                  " from personal p where p.COD_PERSONAL='"+(codPersonalApruebaPeso>0?codPersonalApruebaPeso:codPersonal)+"'";
                          System.out.println("consulta aprueba peso "+consulta);
                         res=st.executeQuery(consulta);
                         if(res.next())nombreAdministrador=res.getString(1);
                      %>
                      <span style="top:10px;">
                                <%=(envasadoConGasNitrogeno?"8":"7")%>.Una vez termine la dosificación de ampollas, dejar pasar 5 litros de agua purificada y realizar punto burbuja
                                unicamente cuando se trate de filtros de cartucho.
                     </span>
                     <center>
                         <table cellpadding="0" cellspacing="0">
                                <tr>
                                <td class="tableCell" style="text-align:center;border-right:none;border-bottom:none" >
                                   <span class="textHeaderClassBody" style="font-weight:bold">Personal que aprueba el volumen y la altura del sellado:</span>
                               </td>
                               <td class="tableCell" style="text-align:center;border-left:none;border-bottom:none" >
                                   <span class="textHeaderClassBody" style="font-weight:normal"><%=(nombreAdministrador)%></span>
                                   <input type="hidden" id="codPersonalAprueba" value="<%=(codPersonalApruebaPeso>0?codPersonalApruebaPeso:codPersonal)%>">
                               </td>
                            </tr>
                            <tr>
                                <td class="tableCell" style="text-align:center;border-right:none;border-top:none" >
                                   <span class="textHeaderClassBody" style="font-weight:bold">Hora:</span>
                               </td>
                               <td class="tableCell" style="border-left:none;border-top:none;text-align:right" align="right" >
                                   <input type="text" id="horaAprobacion" onclick='seleccionarHora(this);' id="fechaRegistroDatosGenerales" value="<%=(sdfHoras.format(fechaAprobacionCellado))%>"/>
                               </td>
                            </tr>
                         </table>
                     </center>
                     <%
                     }
                     if(permisoPorosidad||administrador)
                     {
                     %>
                      <table style="width:100%;margin-top:2%" id="dataPostFiltrado" cellpadding="0px" cellspacing="0px">
                            
                            
                            <%
                            cabeceraPersonal="";
                           innerCabeceraPersonal="";
                           detallePersonal="";
                           contDetalle=0;
                           if(administrador)
                            {
                                consulta="select s.COD_PERSONAL_OPERARIO,isnull((p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+'<br>'+p.NOMBRES_PERSONAL),(pt.AP_PATERNO_PERSONAL+' '+pt.AP_MATERNO_PERSONAL+'<br>'+pt.NOMBRES_PERSONAL))as nombrePersonal"+
                                         " from SEGUIMIENTO_DOSIFICADO_LOTE_POSTFILTRADO s"+
										 " left outer join personal p on p.COD_PERSONAL=s.COD_PERSONAL_OPERARIO"+
										 " left outer join personal_temporal pt on pt.COD_PERSONAL=s.COD_PERSONAL_OPERARIO"+
                                         " where s.COD_SEGUIMIENTO_DOSIFICADO_LOTE='"+codSeguimientoDosificado+"'"+
                                         " group by s.COD_PERSONAL_OPERARIO,p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRES_PERSONAL,pt.AP_PATERNO_PERSONAL,pt.AP_MATERNO_PERSONAL,pt.NOMBRES_PERSONAL"+
                                         " order by 2";
                                res=st.executeQuery(consulta);
                                while(res.next())
                                {
                                    innerCabeceraPersonal+="<td colspan='5' class='tableHeaderClass' style='text-align:center;'><span class='textHeaderClass'>"+res.getString("nombrePersonal")+"</span></td>";
                                    cabeceraPersonal+=" ,isnull(sedl"+res.getRow()+".PRUEBA_DE_INTEGRIDAD_POSITIVO, 0) as PRUEBA_DE_INTEGRIDAD_POSITIVO"+res.getRow()+","+
                                                     " isnull(sedl"+res.getRow()+".PRESION_REGISTRADA, '') as PRESION_REGISTRADA"+res.getRow()+",isnull(sedl"+res.getRow()+".COD_PERSONAL_OPERARIO, 0) as COD_PERSONAL_OPERARIO"+res.getRow()+","+
                                                     " isnull(sedl"+res.getRow()+".OBSERVACIONES, '') as OBSERVACIONES"+res.getRow()+"";
                                    detallePersonal+=" left outer join SEGUIMIENTO_DOSIFICADO_LOTE_POSTFILTRADO sedl"+res.getRow()+" on"+
                                                     " sedl"+res.getRow()+".COD_ESPECIFICACION_FILTRADO = fp.COD_FILTRO_PRODUCCION and "+
                                                     " sedl"+res.getRow()+".COD_SEGUIMIENTO_DOSIFICADO_LOTE = '"+codSeguimientoDosificado+"'" +
                                                     " and sedl"+res.getRow()+".COD_PERSONAL_OPERARIO='"+res.getInt("COD_PERSONAL_OPERARIO")+"'";
                                    contDetalle=res.getRow();
                                }

                            }
                           out.println("<tr><td class='tableHeaderClass' "+(contDetalle>0?"rowspan='2'":"")+" style='text-align:center' >"+
                                       "<span class='textHeaderClass'>Porosidad de membrana</span></td>");
                           if(contDetalle>0)
                           {
                               out.println(innerCabeceraPersonal+"</tr><tr>");
                               for(int i=1;i<=contDetalle;i++)
                               {
                                   out.println("<td class='tableHeaderClass' style='text-align:center;'><span class='textHeaderClass'>Prueba de integridad Positivo</span></td>"+
                                       " <td class='tableHeaderClass' colspan='2' style='text-align:center;' ><span class='textHeaderClass'>Presión<br>Registrada</span></td>"+
                                      " <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>Operario</span></td>"+
                                      " <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>Observaciones</span></td>");
                               }
                           }
                           else out.println("<td class='tableHeaderClass' style='text-align:center;'><span class='textHeaderClass'>Prueba de integridad Positivo</span></td>"+
                                       " <td class='tableHeaderClass' colspan='2' style='text-align:center;' ><span class='textHeaderClass'>Presión<br>Registrada</span></td>"+
                                      " <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>Operario</span></td>"+
                                      " <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>Observaciones</span></td>");

                          out.println("</tr>");
                            consulta="select fp.CODIGO_FILTRO_PRODUCCION,fp.COD_FILTRO_PRODUCCION,um.ABREVIATURA"+
                                     (contDetalle>0?cabeceraPersonal:" ,isnull(sdlp.PRUEBA_DE_INTEGRIDAD_POSITIVO, 0) as PRUEBA_DE_INTEGRIDAD_POSITIVO,"+
                                     " isnull(sdlp.PRESION_REGISTRADA, '') as PRESION_REGISTRADA,isnull(sdlp.COD_PERSONAL_OPERARIO, 0) as COD_PERSONAL_OPERARIO,"+
                                     " isnull(sdlp.OBSERVACIONES, '') as OBSERVACIONES")+
                                     ",um1.ABREVIATURA as abreviaturaPresion"+
                                     " from FILTROS_PRODUCCION fp inner join FILTROS_PRODUCCION_PRODUCTOS fpp on "+
                                     " fp.COD_FILTRO_PRODUCCION=fpp.COD_FILTRO_PRODUCCION inner join COMPONENTES_PROD cp on cp.COD_PROD=fpp.COD_PROD"+
                                     " inner join UNIDADES_MEDIDA um on fp.COD_UNIDAD_MEDIDA = um.COD_UNIDAD_MEDIDA and fp.cod_estado_registro = 1"+
                                     " inner join MEDIOS_FILTRACION mf on mf.COD_MEDIO_FILTRACION =fp.COD_MEDIO_FILTRACION"+
                                     (contDetalle>0?detallePersonal:" left outer join SEGUIMIENTO_DOSIFICADO_LOTE_POSTFILTRADO sdlp on sdlp.COD_ESPECIFICACION_FILTRADO = fp.COD_FILTRO_PRODUCCION and"+
                                     " sdlp.COD_SEGUIMIENTO_DOSIFICADO_LOTE = '"+codSeguimientoDosificado+"'"+
                                     " and sdlp.COD_PERSONAL_OPERARIO='"+codPersonal+"'")+
                                     " left outer join UNIDADES_MEDIDA um1 on um1.COD_UNIDAD_MEDIDA =fp.COD_UNIDAD_MEDIDA_PRESION"+
                                     " where cp.COD_COMPPROD='"+codCompProd+"' order by fp.CODIGO_FILTRO_PRODUCCION";

                            System.out.println("consulta cargar post filtrado "+consulta);
                            res=st.executeQuery(consulta);
                            int contOperario=0;
                            while(res.next())
                            {
                                contOperario++;
                                out.println("<tr ><td class='tableCell' style='text-align:center'>"+
                                            " <input type='hidden' value='"+res.getString("COD_FILTRO_PRODUCCION")+"'/>"+
                                            " <span class='textHeaderClassBody' style='font-weight:normal'>"+res.getString("CODIGO_FILTRO_PRODUCCION")+" "+res.getString("ABREVIATURA")+"</span></td>");
                                if(contDetalle>0)
                                {
                                    for(int i=1;i<=contDetalle;i++)
                                    {
                                        out.println("<td class='tableCell' style='text-align:center;'><input disabled type='checkbox' id='preposi"+res.getRow()+"'   style='width:20px;height:20px' "+(res.getInt("PRUEBA_DE_INTEGRIDAD_POSITIVO"+i)==1?"checked":"")+" />"+
                                            "</td>"+
                                            "<td colspan='2' class='tableCell' style='text-align:center;border-right:none'>"+
                                            " <span class='textHeaderClassBody' style='font-weight:normal' > "+res.getString("PRESION_REGISTRADA"+i)+" "+res.getString("abreviaturaPresion")+"</span></td>"+
                                            " <td class='tableCell'  style='text-align:center;'><select disabled id='s"+i+"n"+(contOperario)+"'>"+arrayPersonal+"</select>"+
                                            "<script>s"+i+"n"+contOperario+".value='"+res.getString("COD_PERSONAL_OPERARIO"+i)+"';</script></td>"+
                                            " <td class='tableCell' style='text-align:center;'>"+
                                            " <span class='textHeaderClassBody' style='font-weight:normal'>"+res.getString("OBSERVACIONES"+i)+"</span>"+
                                            "</td>");
                                    }
                                }
                                else out.println("<td class='tableCell' style='text-align:center;'><input type='checkbox' id='preposi"+res.getRow()+"'   style='width:20px;height:20px' "+(res.getInt("PRUEBA_DE_INTEGRIDAD_POSITIVO")==1?"checked":"")+" />"+
                                            " <label for='preposi"+res.getRow()+"'/></td>"+
                                            "<td class='tableCell' style='text-align:center;border-right:none'>"+
                                            " <input class='textHeaderClassBody' style='margin-top:5%;' type='text' value='"+res.getString("PRESION_REGISTRADA")+"'/>"+
                                            " </td><td class='tableCell' style='text-align:center;border-left:none'>"+
                                            " <span class='textHeaderClassBody' style='font-weight:normal' >"+res.getString("abreviaturaPresion")+"</span></td>"+
                                            " <td class='tableCell' style='text-align:center;'><select id='s"+(contOperario)+"'>"+arrayPersonal+"</select>"+
                                            "<script>s"+contOperario+".value='"+res.getString("COD_PERSONAL_OPERARIO")+"';</script></td>"+
                                            " <td class='tableCell' style='text-align:center;'>"+
                                            " <input class='textHeaderClassBody' style='margin-top:5%;' type='text' value='"+res.getString("OBSERVACIONES")+"'/>"+
                                            "</td>");
                               out.println("</tr>");
                            }
                            %>
                      </table>
                      
                      <%
                      }
                      if(administrador)
                      {
                          consulta="select p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL+' '+p.nombre2_personal"+
                                  " from personal p where p.COD_PERSONAL='"+(codPersonalSupervisor>0?codPersonalSupervisor:codPersonal)+"'";
                         res=st.executeQuery(consulta);
                         if(res.next())nombreAdministrador=res.getString(1);
                      %>
                          <center>
                              
                              <table style="width:90%;margin-top:2px;border-bottom:solid #a80077 1px;" id="obser" cellpadding="0px" cellspacing="0px" >
                                  <tr >
                                       <td class="tableHeaderClass" style="text-align:center" colspan="3">
                                           <span class="textHeaderClass">APROBACION</span>
                                       </td>
                                </tr>
                                <tr>
                                  <td style="border-left:solid #a80077 1px;text-align:left">
                                       <span style="font-weight:bold;" >SUPERVISOR</span><br/>(Técnico y/o Jefe de Producción)
                                   </td>
                                    <td style="border-right:solid #a80077 1px;text-align:left">
                                        <span class="textHeaderClassBody" style="font-weight:normal"> <%=(nombreAdministrador)%> </span>
                                        
                                   </td>
                                </tr>
                                <tr>
                                  <td style="border-left:solid #a80077 1px;text-align:left">
                                       <span style="font-weight:bold;" >Fecha</span>
                                   </td>
                                    <td style="border-right:solid #a80077 1px;text-align:left">
                                        <span class="textHeaderClassBody" style="font-weight:normal"> <%=(sdfDias.format(fechaCierre))%> </span>

                                   </td>
                                </tr>
                                <tr>
                                  <td style="border-left:solid #a80077 1px;text-align:left">
                                       <span style="font-weight:bold;" >Hora</span>
                                   </td>
                                    <td style="border-right:solid #a80077 1px;text-align:left">
                                        <span class="textHeaderClassBody" style="font-weight:normal"> <%=(sdfHoras.format(fechaCierre))%> </span>

                                   </td>
                                </tr>
                                <tr>
                                    <td style="border-left:solid #a80077 1px;text-align:left">
                                       <span >Observaciones</span>
                                   </td>
                                    <td style="border-right:solid #a80077 1px;">
                                        <textarea id="observaciones"><%=observaciones%></textarea>
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
                                        <button class="small button succes radius buttonAction" onclick="guardarDosificado();" >Guardar</button>
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
    
   
    <input type="hidden" id="codLoteSeguimiento" value="<%=codLote%>">
        <input type="hidden" id="codProgramaProd" value="<%=codprogramaProd%>">
        <input type="hidden" id="codSeguimientoDosificado" value="<%=codSeguimientoDosificado%>">
        <input type="hidden" id="codFormulaMaestra" value="<%=(codFormulaMaestra)%>"/>
        <input type="hidden" id="codCompProd" value="<%=(codCompProd)%>"/>
        <input type="hidden" id="codTipoPrograma" value="<%=(codTipoPrograma)%>"/>
        <input type="hidden" id="codActividadCambioFormato" value="<%=(codActividadCambioFormato)%>"/>
        <input type="hidden" id="codActividadArmadoFiltros" value="<%=(codActividadArmadoFiltros)%>"/>
        <input type="hidden" id="codActividadReguladoEquipo" value="<%=(codActividadReguladoEquipo)%>"/>
        <input type="hidden" id="codActividadAcomodado" value="<%=(codActividadAcomodado)%>"/>
        <input type="hidden" value="<%=(codPersonalSupervisor)%>" id="cerrado">
        <input type="hidden" value="<%=(permisoCambioFormato?"1":"0")%>" id="permisoCambioFormato"/>
        <input type="hidden" value="<%=(permisoEspDespiroge?"1":"0")%>" id="permisoEspDespiroge"/>
        <input type="hidden" value="<%=(permisoPorosidad?"1":"0")%>" id="permisoPorosidad"/>
        <input type="hidden" value="<%=(permisoVerificacion?"1":"0")%>" id="permisoVerificacion"/>
        <input type="hidden" value="<%=(permisoAcomodado?"1":"0")%>" id="permisoAcomodado"/>
        </section>
    </body>
    <script src="../../reponse/js/timePickerJs.js"></script>
    <script src="../../reponse/js/dataPickerJs.js"></script>
    <script src="../../reponse/js/despejeLinea.js"></script>
    <script>
            despejeLinea.verificarDespejeLinea('<%=(codPersonalApruebaDespeje)%>', admin,'codProgramaProd','codLoteSeguimiento',6,<%=(codPersonal)%>);
            iniciarDatePicker('<%=(sdfDias.format(new Date()))%>');
            loginHoja.verificarHojaCerrada('cerrado', admin,'codProgramaProd','codLoteSeguimiento',6,<%=(codEstadoHoja)%>);
    </script>
</html>
