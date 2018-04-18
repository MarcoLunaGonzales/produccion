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
    var fechaActualSistema="";
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
      
    function guardarDespirogenizado()
    {
        document.getElementById('formsuper').style.visibility='visible';
        document.getElementById('divImagen').style.visibility='visible';
        var tabla=document.getElementById('dataEspecificaciones');
        var ampollas=document.getElementById('dataAmpollas');
        var especificaciones =new Array();
        var cont=0;
        var dataAmpollasSeguimineto=new Array();
        if(!admin)
        {
            for(var i=2;i<tabla.rows.length;i++)
                {
                    especificaciones[especificaciones.length]=tabla.rows[i].cells[0].getElementsByTagName('input')[0].value;
                    if(tabla.rows[i].cells[3].getElementsByTagName('input')[0].type=="tel")
                    {
                        especificaciones[especificaciones.length]=tabla.rows[i].cells[3].getElementsByTagName('input')[0].value;
                        if(!validadRegistroMayorACero(tabla.rows[i].cells[3].getElementsByTagName('input')[0]))
                        {
                                document.getElementById('formsuper').style.visibility='hidden';
                                document.getElementById('divImagen').style.visibility='hidden';
                                return false;
                        }
                        
                    }
                    else
                    {
                            especificaciones[especificaciones.length]=tabla.rows[i].cells[3].getElementsByTagName('input')[0].checked?'1':'0';
                    }
                    especificaciones[especificaciones.length]=encodeURIComponent(tabla.rows[i].cells[4].getElementsByTagName('input')[0].value.split(",").join("$%"));
                }
                cont=0;
                 for(var k=1;k<ampollas.rows.length;k++)
                     {

                         if(validarRegistroEntero(ampollas.rows[k].cells[1].getElementsByTagName('input')[0])&&
                            validarRegistroEntero(ampollas.rows[k].cells[2].getElementsByTagName('input')[0])&&
                            validarRegistroEntero(ampollas.rows[k].cells[4].getElementsByTagName('input')[0])&&
                            validarSeleccionRegistro(ampollas.rows[k].cells[5].getElementsByTagName('select')[0])&&
                            validarFechaRegistro(ampollas.rows[k].cells[6].getElementsByTagName('input')[0])&&
                            validarHoraRegistro(ampollas.rows[k].cells[7].getElementsByTagName('input')[0])&&
                            validarHoraRegistro(ampollas.rows[k].cells[8].getElementsByTagName('input')[0])&&
                            validarRegistrosHorasNoNegativas(ampollas.rows[k].cells[7].getElementsByTagName('input')[0],ampollas.rows[k].cells[8].getElementsByTagName('input')[0]))
                               {
                                         dataAmpollasSeguimineto[cont]=ampollas.rows[k].cells[5].getElementsByTagName('select')[0].value;
                                         cont++;
                                         dataAmpollasSeguimineto[cont]=ampollas.rows[k].cells[1].getElementsByTagName('input')[0].value;
                                         cont++;
                                         dataAmpollasSeguimineto[cont]=ampollas.rows[k].cells[2].getElementsByTagName('input')[0].value;
                                         cont++;
                                         dataAmpollasSeguimineto[cont]=ampollas.rows[k].cells[4].getElementsByTagName('input')[0].value;
                                         cont++;
                                         dataAmpollasSeguimineto[cont]=ampollas.rows[k].cells[6].getElementsByTagName('input')[0].value;
                                         cont++;
                                         dataAmpollasSeguimineto[cont]=ampollas.rows[k].cells[7].getElementsByTagName('input')[0].value;
                                         cont++;
                                         dataAmpollasSeguimineto[cont]=ampollas.rows[k].cells[8].getElementsByTagName('input')[0].value;
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
        console.log(especificaciones);
         var peticion="ajaxGuardarDespirogenizado.jsf?codLote="+document.getElementById("codLote").value+"&noCache="+ Math.random()+
             "&codProgramaProd="+document.getElementById("codprogramaProd").value+"&codTipoProgramaProd="+document.getElementById("codTipoProgramaProd").value+
             "&codCompProd="+document.getElementById("codCompProdRegistro").value+"&codFormulaMaestra="+document.getElementById("codFormulaMaestra").value+
             "&codActividadDespirogenizado="+document.getElementById("codActividadDespirogenizado").value+"&codSeguimientoDespiro="+document.getElementById("codSeguimientoDespirogenizado").value+
             "&especificaciones="+especificaciones+"&dataAmpollasSeguimiento="+dataAmpollasSeguimineto+
             "&codPersonalUsuario="+codPersonal+
             "&admin="+(admin?"1":"0")+
             (admin?"&observacion="+encodeURIComponent(document.getElementById('observacion').value):"");
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
                                sqlConnection.insertarRegistroAuxiliar(document.getElementById("codprogramaProd").value, document.getElementById("codLote").value,4,("../registroDespirogenizado/"+peticion),function(){window.close();});
                            }
                            document.getElementById('formsuper').style.visibility='hidden';
                            document.getElementById('divImagen').style.visibility='hidden';
                            return false;
                        }
                        if(parseInt(ajax.responseText.split("\n").join(""))=='1')
                        {
                            alert('Se registro el proceso de despirogenizado');
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
        if(admin)
        {
            
            var ampollas=document.getElementById('dataAmpollas');

            var sumaAmpollas=0;
            for(var i=1;i<ampollas.rows.length;i++)
                 {
                     sumaAmpollas+=parseInt(isNaN(ampollas.rows[i].cells[3].getElementsByTagName('span')[0].innerHTML)?0:ampollas.rows[i].cells[3].getElementsByTagName('span')[0].innerHTML);
                }
            document.getElementById('sumaCantidad').innerHTML=sumaAmpollas;
            document.getElementById('rendimiento').innerHTML=redondeo2decimales(((sumaAmpollas-parseInt(isNaN(document.getElementById("cantidadAmpollasRotas").innerHTML)||document.getElementById("cantidadAmpollasRotas").innerHTML==''?0:document.getElementById("cantidadAmpollasRotas").innerHTML))/parseInt(document.getElementById('cantidadLote').innerHTML))*100);
        }
        
    }
    function calcularAmpollasRotas()
    {
        if(admin)
        {
            var tablaAmpollas=document.getElementById("dataAmpollas");
            var sumaAmpollasRotas=0;
            for(var i=1;i<tablaAmpollas.rows.length;i++)
            {
                if(!isNaN(tablaAmpollas.rows[i].cells[4].getElementsByTagName("input")[0].value))
                {
                    sumaAmpollasRotas+=parseInt(tablaAmpollas.rows[i].cells[4].getElementsByTagName("input")[0].value ==''?0:tablaAmpollas.rows[i].cells[4].getElementsByTagName("input")[0].value);
                }
            }
            document.getElementById("cantidadAmpollasRotas").innerHTML=sumaAmpollasRotas;
            document.getElementById('rendimiento').innerHTML=redondeo2decimales(((parseInt(document.getElementById('sumaCantidad').innerHTML)-sumaAmpollasRotas)/parseInt(document.getElementById('cantidadLote').innerHTML))*100);
        }
    }
    function calcularTotalAmpollas(celda)
    {
        var resultado=(parseInt(celda.parentNode.parentNode.cells[1].getElementsByTagName('input')[0].value)*parseInt(celda.parentNode.parentNode.cells[2].getElementsByTagName('input')[0].value));
        celda.parentNode.parentNode.cells[3].getElementsByTagName('span')[0].innerHTML=(isNaN(resultado)?0:resultado);
        sumaRendimiento();
    }
    function valEnteros()
    {
        
      if ((event.keyCode < 48 || event.keyCode > 57) )
         {
            alert('Solo puede registrar numeros enteros');
            event.returnValue = false;
         }
    }
    var contadorRegistrosAmpollasDespiro=0;
    function nuevoRegistro(nombreTabla)
   {
       contadorRegistrosAmpollasDespiro++;
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
       element1.onkeypress=function(){valNum(this);};
       element1.type = "tel";
       element1.value=0;
       element1.style.width='6em';
       cell1.appendChild(element1);

       var cell2 = row.insertCell(2);
       cell2.className="tableCell";
       var element2 = document.createElement("input");
       element2.onkeyup=function(){calcularTotalAmpollas(this);}
       element2.onkeypress=function(){valNum(this);};
       element2.type = "tel";
       element2.value=0;
       element2.style.width='6em';
       cell2.appendChild(element2);

       var cell3 = row.insertCell(3);
       cell3.className="tableCell";
       cell3.style.textAlign='center';
       var element3 = document.createElement("span");
       element3.className='textHeaderClassBody';
       element3.innerHTML=0;
       element3.style.fontWeight='normal';
       cell3.appendChild(element3);


       var cellRotas = row.insertCell(4);
       cellRotas.className="tableCell";
       var elementRotas = document.createElement("input");
       elementRotas.onkeyup=function(){calcularAmpollasRotas()};
       elementRotas.type = "tel";
       elementRotas.value=0;
       elementRotas.style.width='6em';
       cellRotas.appendChild(elementRotas);


       var cell4 = row.insertCell(5);
       cell4.className="tableCell";
       var element4 = document.createElement("select");
       element4.innerHTML=operariosRegistro;
       cell4.appendChild(element4);


       var cell5 = row.insertCell(6);
       cell5.className="tableCell";
       var element5 = document.createElement("input");
       element5.type = "tel";
       element5.size=10;
       element5.value=fechaActualSistema;
       element5.id="fechaSegui"+table.rows.length;
       element5.onclick=function(){seleccionarDatePickerJs(this)};
       cell5.appendChild(element5);
       
       var cell6 = row.insertCell(7);
       cell6.className="tableCell";
       var element6 = document.createElement("input");
       element6.type = "text";
       element6.style.width='6em';
       element6.value=getHoraActualString();
       element6.id='fechaIniDes'+contadorRegistrosAmpollasDespiro;
       element6.onclick=function(){seleccionarHora(this);};
       cell6.appendChild(element6);

       var cell7 = row.insertCell(8);
       cell7.className="tableCell";
       var element7 = document.createElement("input");
       element7.type = "text";
       element7.style.width='6em';
       element7.value=getHoraActualString();
       element7.id="fechaFinDes"+contadorRegistrosAmpollasDespiro;
       element7.onclick=function(){seleccionarHora(this);};
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
        String loteAsociado="";
        int cantLoteAsociado=0;
        String codPersonal=request.getParameter("codPersonal");
        boolean administrador=(Integer.valueOf(request.getParameter("admin"))>0);
        out.println("<script type='text/javascript'>codPersonal="+codPersonal+";" +
                   "admin="+administrador+";</script>");
        int codEstadoHoja=0;
        Date fechaCierre=new Date();
        String codLote=request.getParameter("codLote");
        out.println("<title>("+codLote+")DESPIROGENIZADO</title>");
        String codprogramaProd=request.getParameter("cod_prog");
        String codForma="";
        String codAreaEmpresa=request.getParameter("codAreaEmpresa");
        String observacion="";
        String operarios="";
        String codSupervisor="0";
        NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
        DecimalFormat format = (DecimalFormat)nf;
        SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy");
        format.applyPattern("#,##0.00");
        int codSeguimientoDespirogenizado=0;
        int codActividadDespirogenizado=0;
        int codFormulaMaestra=0;
        int codTipoProgramaProd=0;
        int codCompProdRegistro=0;
        SimpleDateFormat sdfDias=new SimpleDateFormat("dd/MM/yyyy");
        SimpleDateFormat sdfHoras=new SimpleDateFormat("HH:mm");
        int sumaCantidadAmpollasRotas=0;
        out.println("<script>sqlConnection.verificarRegistroPendiente('"+codprogramaProd+"','"+codLote+"',4)</script>");
                try
                {
                    Connection con=null;
                    con=Util.openConnection(con);
                    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    String consulta="select  pp.COD_FORMULA_MAESTRA,pp.COD_TIPO_PROGRAMA_PROD,pp.COD_COMPPROD,cp.COD_FORMA,f.abreviatura_forma,cp.nombre_prod_semiterminado,cp.NOMBRE_GENERICO,f.nombre_forma,cp.REG_SANITARIO,"+
                                    " ep.nombre_envaseprim,cp.VIDA_UTIL,pp.CANT_LOTE_PRODUCCION,ppp.FECHA_FINAL,isnull(cpr.COD_RECETA_DESPIROGENIZADO,0) as COD_RECETA_DESPIROGENIZADO" +
                                    " ,ISNULL(dpff.CONDICIONES_GENERALES_DESPIROGENIZADO,'') as CONDICIONES_GENERALES_DESPIROGENIZADO" +
                                    " ,isnull(sdl.COD_SEGUIMIENTO_DESPIROGENIZADO_LOTE,0) as COD_SEGUIMIENTO_DESPIROGENIZADO_LOTE,"+
                                    " isnull(sdl.COD_PERSONAL_SUPERVISOR,0)  as COD_PERSONAL_SUPERVISOR,"+
                                    " isnull(sdl.OBSERVACION,'') as OBSERVACION,"+
                                    " sdl.FECHA_CIERRE,isnull(sdl.COD_ESTADO_HOJA,0) as COD_ESTADO_HOJA,isnull(afm.COD_ACTIVIDAD_FORMULA, 0) as codActividadDespirogenizado" +
                                    " ,isnull(conjunta.loteAsociado, '') as loteAsociado,isnull(conjunta.cantAsociado, 0) as cantAsociado" +
                                    " ,isnull(cpp.NOMBRE_COLORPRESPRIMARIA,'') as colorPresPrim"+
                                    " from PROGRAMA_PRODUCCION pp inner join COMPONENTES_PROD cp on cp.COD_COMPPROD=pp.COD_COMPPROD"+
                                    " inner join FORMAS_FARMACEUTICAS f on f.cod_forma=cp.COD_FORMA"+
                                    " inner join productos p on p.cod_prod=cp.COD_PROD"+
                                    " inner join PRESENTACIONES_PRIMARIAS ppm on ppm.COD_COMPPROD=cp.COD_COMPPROD and ppm.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD"+
                                    " inner join ENVASES_PRIMARIOS ep on ep.cod_envaseprim=ppm.COD_ENVASEPRIM" +
                                    " inner join PROGRAMA_PRODUCCION_PERIODO ppp on pp.COD_PROGRAMA_PROD=ppp.COD_PROGRAMA_PROD" +
                                    " left outer join COMPONENTES_PROD_RECETA cpr on cpr.COD_COMPROD=cp.COD_COMPPROD"+
                                    " left outer join DESCRIPCION_PROCESOS_FORMA_FARMACEUTICA dpff on dpff.COD_FORMA=cp.COD_FORMA" +
                                    " left outer join SEGUIMIENTO_DESPIROGENIZADO_LOTE sdl on sdl.cod_lote=pp.COD_LOTE_PRODUCCION"+
                                    " and sdl.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD" +
                                    " left outer join COLORES_PRESPRIMARIA cpp on cpp.COD_COLORPRESPRIMARIA=cp.COD_COLORPRESPRIMARIA" +
                                    " left outer join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_AREA_EMPRESA =96 "+
                                    " and afm.COD_ACTIVIDAD = 152 and afm.COD_FORMULA_MAESTRA =pp.COD_FORMULA_MAESTRA" +
                                    " and afm.COD_PRESENTACION=0" +
                                    " outer APPLY ( select top 1 ppc.COD_LOTE_PRODUCCION as loteAsociado,ppc.CANT_LOTE_PRODUCCION as cantAsociado"+
                                    " from LOTES_PRODUCCION_CONJUNTA lpc inner join PROGRAMA_PRODUCCION ppc on lpc.COD_PROGRAMA_PROD =ppc.COD_PROGRAMA_PROD" +
                                    " and lpc.COD_LOTE_PRODUCCION_ASOCIADO =ppc.COD_LOTE_PRODUCCION"+
                                    " where lpc.COD_PROGRAMA_PROD = pp.COD_PROGRAMA_PROD and lpc.COD_LOTE_PRODUCCION = pp.COD_LOTE_PRODUCCION) conjunta"+
                                    " where pp.COD_LOTE_PRODUCCION='"+codLote+"' and pp.COD_PROGRAMA_PROD='"+codprogramaProd+"'";
                    System.out.println("consulta cargar datos del lote "+consulta);
                    ResultSet res=st.executeQuery(consulta);
                    String codReceta="";
                    double cantidadAmpollas=0d;
                    String condicionesGenerales="";
                     char b=13;char c=10;
                    if(res.next())
                    {
                        codSupervisor=res.getString("COD_PERSONAL_SUPERVISOR");
                        fechaCierre=(res.getTimestamp("FECHA_CIERRE")!=null?res.getTimestamp("FECHA_CIERRE"):new Date());
                        codEstadoHoja=res.getInt("COD_ESTADO_HOJA");
                        observacion=res.getString("OBSERVACION");
                        codFormulaMaestra=res.getInt("COD_FORMULA_MAESTRA");
                        codCompProdRegistro=res.getInt("COD_COMPPROD");
                        codTipoProgramaProd=res.getInt("COD_TIPO_PROGRAMA_PROD");
                        codActividadDespirogenizado=res.getInt("codActividadDespirogenizado");
                        if(codActividadDespirogenizado==0)
                        {
                            out.println("<script>alert('No se encuentra asociada la actividad de despirogenizado');window.close();</script>");
                        }
                        condicionesGenerales=res.getString("CONDICIONES_GENERALES_DESPIROGENIZADO").replace(b,'\n').replace("\n", "</br>").replace("</br></br>","<br>");
                        codForma=res.getString("COD_FORMA");
                        codReceta=res.getString("COD_RECETA_DESPIROGENIZADO");
                        cantidadAmpollas=res.getDouble("CANT_LOTE_PRODUCCION");
                        codSeguimientoDespirogenizado=res.getInt("COD_SEGUIMIENTO_DESPIROGENIZADO_LOTE");
                        loteAsociado=res.getString("loteAsociado");
                        cantLoteAsociado=res.getInt("cantAsociado");
                        %>

    <section class="main">
                         <div class="row"  style="margin-top:5px" >
                                <div class="large-12 medium-12 small-12 large-centered medium-centered small-centered columns" >

                                            <div class="row">
                                               <div class="large-12 medium-12 small-12 columns divHeaderClass" >
                                                       <label  class="inline">Registro de Despirogenizado</label>
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
                                   <label  class="inline">Despirogenizado</label>
                            </div>
                        </div>
                        <div class="row" >

                        <div  class="divContentClass large-12 medium-12 small-12 columns">
                
                <%
                    }
                   
                        %>
                        <div class="row">
                           <div class="large-12 medium-12 small-12 columns " >
                                   <span class="textHeaderClassBody">Condiciones Generales<br></span>
                                   <span class="textHeaderClassBody" style="font-weight:normal"><%=(condicionesGenerales)%></span>
                            </div>
                        </div>
                         <table style="width:100%;margin-top:2%" id="dataEspecificaciones" cellpadding="0px" cellspacing="0px">
                        

                               <%
                                      out.println("<tr ><td class='tableHeaderClass' style='text-align:center' colspan='3'>"+
                                                  " <span class='textHeaderClass'>ESPECIFICACIONES DE ETAPA DE DESPIROGENIZADO</span></td>");
                                       String cabeceraPersonal="";
                                       String innerCabeceraPersonal="";
                                       String detallePersonal="";
                                       int contDetalle=0;
                                       if(administrador)
                                        {
                                            consulta="select s.COD_PERSONAL,isnull((p.AP_PATERNO_PERSONAL+'<br>'+p.AP_MATERNO_PERSONAL+'<br>'+p.NOMBRES_PERSONAL),(pt.AP_PATERNO_PERSONAL+'<br>'+pt.AP_MATERNO_PERSONAL+'<br>'+pt.NOMBRES_PERSONAL))as nombrePersonal"+
                                                     " from SEGUIMIENTO_ESPECIFICACIONES_DESPIROGENIZADO_LOTE s"+
                                                     " left outer join personal p on p.COD_PERSONAL=s.COD_PERSONAL"+
                                                     " left outer join personal_temporal pt on pt.COD_PERSONAL=s.COD_PERSONAL"+
                                                     " where s.COD_SEGUIMIENTO_DESPIROGENIZADO_LOTE='"+codSeguimientoDespirogenizado+"'"+
                                                     " group by s.COD_PERSONAL,p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRES_PERSONAL"+
                                                     " ,pt.AP_PATERNO_PERSONAL,pt.AP_MATERNO_PERSONAL,pt.NOMBRES_PERSONAL"+
                                                     " order by 2";
                                            System.out.println("consulta pers esp "+consulta);
                                            res=st.executeQuery(consulta);
                                            while(res.next())
                                            {
                                                innerCabeceraPersonal+="<td colspan='2' class='tableHeaderClass' style='text-align:center;'><span class='textHeaderClass'>"+res.getString("nombrePersonal")+"</span></td>";
                                                cabeceraPersonal+=",ISNULL(sedl"+res.getRow()+".CONFORME,0) as conforme"+res.getRow()+"," +
                                                                  "ISNULL(sedl"+res.getRow()+".OBSERVACION,'') as observacion"+res.getRow()+
                                                                  ",ISNULL(sedl"+res.getRow()+".VALOR_EXACTO,0) AS valorExactoLote"+res.getRow();
                                                detallePersonal+=" left outer join SEGUIMIENTO_ESPECIFICACIONES_DESPIROGENIZADO_LOTE sedl"+res.getRow()+" on"+
                                                                 " sedl"+res.getRow()+".COD_ESPECIFICACION_PROCESO = ep.COD_ESPECIFICACION_PROCESO and"+
                                                                 " sedl"+res.getRow()+".COD_SEGUIMIENTO_DESPIROGENIZADO_LOTE = '"+codSeguimientoDespirogenizado+"'" +
                                                                 " and sedl"+res.getRow()+".COD_PERSONAL='"+res.getInt("COD_PERSONAL")+"'";
                                                contDetalle=res.getRow();
                                            }
                                            
                                        }
                                      
                                       out.println(" <td class='tableHeaderClass' style='text-align:center' colspan='"+(administrador?contDetalle*2:2)+"'><span class='textHeaderClass'>CONDICCIONES DE ETAPA </span></td></tr>");
                                       out.println("<tr ><td "+(administrador?"rowspan='2'":"")+" class='tableHeaderClass' style='text-align:center'>"+
                                                  " <span class='textHeaderClass'>&nbsp;</span></td>"+
                                                  " <td "+(administrador?"rowspan='2'":"")+" class='tableHeaderClass' style='text-align:center;'>"+
                                                  " <span class='textHeaderClass'>Valor</span></td>"+
                                                  " <td "+(administrador?"rowspan='2'":"")+" class='tableHeaderClass' style='text-align:center'>"+
                                                  " <span class='textHeaderClass'>Unidad.</span></td>");
                                       if(administrador)
                                       {
                                           out.println(innerCabeceraPersonal+"</tr><tr>");
                                           for(int i=1;i<=contDetalle;i++)
                                           {
                                               out.println("<td class='tableHeaderClass' style='text-align:center;'><span class='textHeaderClass'>Conforme</span></td>"+
                                                           " <td class='tableHeaderClass' style='text-align:center'><span class='textHeaderClass'>Observación</span></td>");
                                           }
                                           out.println("</tr>");
                                       }
                                       else
                                       {
                                           out.println("<td class='tableHeaderClass' style='text-align:center;'><span class='textHeaderClass'>Conforme</span></td>"+
                                                       " <td class='tableHeaderClass' style='text-align:center'><span class='textHeaderClass'>Observación</span></td></tr>");
                                       }
                              
                    consulta=" select ep.RESULTADO_ESPERADO_LOTE,ep.NOMBRE_ESPECIFICACIONES_PROCESO,isnull(um.ABREVIATURA, 'N.A') as NOMBRE_UNIDAD_MEDIDA,"+
                             " ep.COD_ESPECIFICACION_PROCESO,case when ep.ESPECIFICACION_STANDAR_FORMA=1 then ep.VALOR_EXACTO else rd.VALOR_EXACTO end as valorExacto"+
                             " , case when ep.ESPECIFICACION_STANDAR_FORMA=1 THEN"+
                             " ep.VALOR_TEXTO else rd.VALOR_TEXTO end as valorTexto,ep.RESULTADO_NUMERICO" +
                             (administrador?cabeceraPersonal:",ISNULL(sedl.CONFORME,0) as conforme,ISNULL(sedl.OBSERVACION,'') as observacion,sedl.VALOR_EXACTO as valorNumero")+
                             " from ESPECIFICACIONES_PROCESOS ep left outer join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA ="+
                             " ep.COD_UNIDAD_MEDIDA left outer join RECETAS_DESPIROGENIZADO rd on"+
                             " rd.COD_ESPECIFICACION_PROCESO = ep.COD_ESPECIFICACION_PROCESO and rd.COD_RECETA = '"+codReceta+"'" +
                             (administrador?detallePersonal:" left outer join SEGUIMIENTO_ESPECIFICACIONES_DESPIROGENIZADO_LOTE sedl"+
                             " on sedl.COD_ESPECIFICACION_PROCESO=ep.COD_ESPECIFICACION_PROCESO"+
                             " and sedl.COD_SEGUIMIENTO_DESPIROGENIZADO_LOTE='"+codSeguimientoDespirogenizado+"'")+
                             (administrador?"":" and sedl.COD_PERSONAL='"+codPersonal+"'")+
                             " where ep.COD_FORMA = '"+codForma+"' and ep.COD_PROCESO_ORDEN_MANUFACTURA=1"+
                             " order by ep.ORDEN";
                    System.out.println("consulta esp "+consulta);
                    res=st.executeQuery(consulta);
                    
                    String valor="";
                    String nombreEspecificacion="";
                    String unidadMedida="";
                    while(res.next())
                    {
                        valor=(res.getDouble("RESULTADO_NUMERICO")>0?(res.getDouble("valorExacto")>0?String.valueOf(res.getDouble("valorExacto")):""):res.getString("valorTexto"));
                        nombreEspecificacion=res.getString("NOMBRE_ESPECIFICACIONES_PROCESO");
                        unidadMedida=res.getString("NOMBRE_UNIDAD_MEDIDA");
                        %>
                        <tr >
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
                            for(int i=1;i<=contDetalle;i++)
                            {
                                  out.println("<td class='tableCell' style='text-align:center'>"+(res.getInt("RESULTADO_ESPERADO_LOTE")==1?"<span class='textHeaderClassBody' style='font-weight:normal'>"+res.getDouble("valorExactoLote"+i)+"</span>":"" +
                                          "<input type='checkbox' style='width:20px;height:20px' disabled "+(res.getInt("conforme"+i)>0?"checked":"")+"/>")+
                                        " </td><td class='tableCell' style='text-align:center'><span class='textHeaderClassBody' style='font-weight:normal'>"+res.getString("observacion"+i)+"</span></td>");
                            }
                        }
                        else
                        {
                            out.println("<td class='tableCell'><center>"+(res.getInt("RESULTADO_ESPERADO_LOTE")==1?"<input style='width:6em' type='tel' value='"+res.getDouble("valorNumero")+"'/>":"<input type='checkbox' style='width:20px;height:20px' "+(res.getInt("conforme")>0?"checked":"")+"/>")+
                                        "</center></td><td class='tableCell' style='text-align:center'><input class='textHeaderClassBody' type='text' value='"+res.getString("observacion")+"'/></td>");
                        }
                    }
                    %>
                    </tr>
                    </table>
                  
                    <div class="row">
                           <div class="large-12 medium-12 small-12 large-centered medium-centered columns " >
                              <table style="width:100%;margin-top:2%" id="dataAmpollas" cellpadding="0px" cellspacing="0px">
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
                                        operarios=UtilidadesTablet.operariosAreaProduccionAdminSelect(st, codAreaEmpresa, codPersonal, administrador);
                                        int sumaCantidad=0;
                                        
                                        consulta="select sadl.COD_REGISTRO_ORDEN_MANUFACTURA,sadl.CANTIDAD_AMPOLLAS_BANDEJA,sadl.CANTIDAD_AMPOLLAS_ROTAS,sadl.CANTIDAD_AMPOLLAS_ROTAS,"+
                                                 " isnull(sadl.CANTIDAD_BANDEJAS, - 1) as CANTIDAD_BANDEJAS,isnull(sadl.COD_PERSONAL, sppp.COD_PERSONAL) as COD_PERSONAL,"+
                                                 " sppp.FECHA_INICIO,sppp.FECHA_FINAL,sppp.COD_LOTE_PRODUCCION"+
                                                 " from SEGUIMIENTO_AMPOLLAS_DESPIROGENIZADO_LOTE sadl"+
                                                 " full outer join SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sppp on"+
                                                 "    sppp.COD_PERSONAL = sadl.COD_PERSONAL and"+
                                                 "    sadl.COD_REGISTRO_ORDEN_MANUFACTURA = sppp.COD_REGISTRO_ORDEN_MANUFACTURA"+
                                                 " where (sppp.COD_LOTE_PRODUCCION = '"+codLote+"' and"+
                                                 "     sppp.COD_PROGRAMA_PROD = '"+codprogramaProd+"' and"+
                                                 "     sppp.COD_FORMULA_MAESTRA = '"+codFormulaMaestra+"' and"+
                                                 "     sppp.COD_ACTIVIDAD_PROGRAMA = '"+codActividadDespirogenizado+"' "+
                                                 (administrador?"":" and sppp.COD_PERSONAL='"+codPersonal+"'")+
                                                 "    and  sppp.COD_TIPO_PROGRAMA_PROD = '"+codTipoProgramaProd+"' and sadl.COD_SEGUIMIENTO_DESPIROGENIZADO_LOTE is null) or "+
                                                 "     (sadl.COD_SEGUIMIENTO_DESPIROGENIZADO_LOTE = '"+codSeguimientoDespirogenizado+"'" +
                                                 (administrador?"":" and sadl.COD_PERSONAL='"+codPersonal+"'")+
                                                 "  and sppp.COD_LOTE_PRODUCCION is NULL) or"+
                                                 "     (sppp.COD_LOTE_PRODUCCION = '"+codLote+"' and"+
                                                 "     sppp.COD_PROGRAMA_PROD = '"+codprogramaProd+"' and"+
                                                 "     sppp.COD_FORMULA_MAESTRA = '"+codFormulaMaestra+"' and"+
                                                 "     sppp.COD_ACTIVIDAD_PROGRAMA = '"+codActividadDespirogenizado+"' "+
                                                 (administrador?"":" and sppp.COD_PERSONAL='"+codPersonal+"'")+
                                                 " and sppp.COD_TIPO_PROGRAMA_PROD = '"+codTipoProgramaProd+"' and sadl.COD_SEGUIMIENTO_DESPIROGENIZADO_LOTE ="+codSeguimientoDespirogenizado+")"+
                                                 " order by sadl.COD_REGISTRO_ORDEN_MANUFACTURA";
                                        System.out.println("consulta cargar  Ampollas "+consulta);
                                            res=st.executeQuery(consulta);
                                            
                                            while(res.next())
                                            {
                                                sumaCantidadAmpollasRotas+=res.getInt("CANTIDAD_AMPOLLAS_ROTAS");
                                                %>
                                                    <tr onclick="seleccionarFila(this);">
                                                        <td class="tableCell"  style="text-align:center">
                                                            <span class="textHeaderClassBody" style="font-weight:normal"><%=(res.getRow())%></span>
                                                       </td>
                                                       <td class="tableCell"  style="text-align:center;" align="center">
                                                               <input type="tel" <%=(administrador?"disabled":"")%> onkeypress="valNum(this)" onkeyup="calcularTotalAmpollas(this);" value="<%=(res.getInt("CANTIDAD_BANDEJAS")==-1?"":res.getInt("CANTIDAD_AMPOLLAS_BANDEJA"))%>" style="width:6em;"/>
                                                       </td>
                                                       <td class="tableCell"  style="text-align:center;" align="center">
                                                           <input type="tel" <%=(administrador?"disabled":"")%> onkeypress="valNum(this)" onkeyup="calcularTotalAmpollas(this);" value="<%=(res.getInt("CANTIDAD_BANDEJAS")==-1?"":res.getInt("CANTIDAD_BANDEJAS"))%>" style="width:6em;"/>
                                                       </td>
                                                       <td class="tableCell"  style="text-align:center">
                                                            <span class="textHeaderClassBody" style="font-weight:normal"><%=(res.getInt("CANTIDAD_BANDEJAS")==-1?"Cantidades no registradas":(res.getInt("CANTIDAD_AMPOLLAS_BANDEJA")*res.getInt("CANTIDAD_BANDEJAS")))%></span>
                                                       </td>
                                                       <td class="tableCell"  style="text-align:center;" align="center">
                                                           <input type="tel" <%=(administrador?"disabled":"")%> onkeypress="valNum(this)" onkeyup="calcularAmpollasRotas();" value="<%=res.getInt("CANTIDAD_AMPOLLAS_ROTAS")%>" style="width:6em;"/>
                                                       </td>
                                                       <td class="tableCell">
                                                                <select <%=(administrador?"disabled":"")%>  id="codLavadop<%=(res.getRow())%>"><%out.println(operarios);%></select>
                                                                <%
                                                                out.println("<script>codLavadop"+res.getRow()+".value='"+res.getInt("COD_PERSONAL")+"';</script>");
                                                                 %>

                                                            </td>
                                                            <td class="tableCell"  style="text-align:center;">
                                                                
                                                                <input <%=(administrador?"disabled":"")%> type="tel" onclick="seleccionarDatePickerJs(this);" value="<%=(res.getTimestamp("FECHA_INICIO")!=null?sdfDias.format(res.getTimestamp("FECHA_INICIO")):"")%>" size="10" id="fechap<%=(res.getRow())%>"/>
                                                               

                                                           </td>


                                                           <td class="tableCell"  style="text-align:center;" align="center">
                                                               <input type="text" <%=(administrador?"disabled":"")%> onclick='seleccionarHora(this);' id="fechaIniAmpDespiro<%=(res.getRow())%>" value="<%=(res.getTimestamp("FECHA_INICIO")!=null?sdfHoras.format(res.getTimestamp("FECHA_INICIO")):"")%>" style="width:6em;"/>
                                                           </td>
                                                           <td class="tableCell"  style="text-align:center;" align="center">
                                                               <input type="text" <%=(administrador?"disabled":"")%> onclick='seleccionarHora(this);' id="fechaFinAmpDespiro<%=(res.getRow())%>" value="<%=(res.getTimestamp("FECHA_INICIO")!=null?sdfHoras.format(res.getTimestamp("FECHA_FINAL")):"")%>" style="width:6em;"/>
                                                           </td>
                                                        </tr>
                                                <%
                                                sumaCantidad+=(res.getInt("CANTIDAD_AMPOLLAS_BANDEJA")*res.getInt("CANTIDAD_BANDEJAS"));
                                            }
                                            
                                              
                                              out.println("<script> operariosRegistro=\""+operarios+"\";fechaActualSistema=\""+sdfDias.format(new Date())+"\"</script>");
                                              
                                              
                                            %>
                                       
                              </table>
                             </div>
                          </div>
                          <%
                          if(!administrador)out.println("<div class='row'><div class='large-5 medium-5 small-4 columns' style=''>&nbsp;</div>"+
                                                        " <div class='large-1 medium-1 small-2 columns' ><button  class='small button succes radius buttonAction' onclick='nuevoRegistro(\"dataAmpollas\")'>+</button>"+
                                                        " </div><div class='large-1 medium-1 small-2 columns'><button class='small button succes radius buttonAction' onclick='eliminarRegistroTabla(\"dataAmpollas\");sumaRendimiento();'>-</button></div>"+
                                                        " <div class='large-5 medium-5 small-4 columns' style=''>&nbsp;</div></div>");
                          %>
                           
                          <center>
                    
                    <input type="hidden" value="<%=codSupervisor%>" id="cerrado"/>
                    <%
                            if(administrador)
                            {
                                consulta="select  isnull(sum(sall.CANTIDAD_AMPOLLAS_BANDEJAS*sall.CANTIDAD_BANDEJAS),0) as cantidadAmpollas," +
                                                    "isnull(SUM (sall.CANTIDAD_AMPOLLAS_ROTAS),0) as CANTIDAD_AMPOLLAS_ROTAS "+
                                                     " from SEGUIMIENTO_LAVADO_LOTE sll inner join SEGUIMIENTO_AMPOLLAS_LAVADO_LOTE sall"+
                                                     " on sll.COD_SEGUIMIENTO_LAVADO_LOTE=sall.COD_SEGUIMIENTO_LAVADO_LOTE"+
                                                     " where sll.COD_PROGRAMA_PROD='"+codprogramaProd+"' and sll.COD_LOTE='"+codLote+"'";
                                  System.out.println("consulta ampollas lavadas "+consulta);
                                  res=st.executeQuery(consulta);
                                  Double cantidadAmpollasLavadas=0d;
                                  if(res.next())
                                  {

                                      cantidadAmpollasLavadas=(res.getDouble("cantidadAmpollas")-res.getDouble("CANTIDAD_AMPOLLAS_ROTAS"));

                                  }

                                consulta="select (p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL+' '+p.nombre2_personal)"+
                                         " from PERSONAL p where p.COD_PERSONAL='"+codPersonal+"'";
                                res=st.executeQuery(consulta);
                                String nombreUsuario="";
                                if(res.next())
                                {
                                    nombreUsuario=res.getString(1);
                                }
                    %>
                    <table style="width:80%;margin-top:2px;border-bottom:solid #a80077 1px;" id="rsendimiento" cellpadding="0px" cellspacing="0px" >
                        <tr >
                               <td class="tableHeaderClass" style="text-align:center" colspan="3">
                                   <span class="textHeaderClass">RENDIMIENTO DEL PROCESO DE LAVADO</span>
                               </td>
                        </tr>
                        <tr >
                                <td style="border-left:solid #a80077 1px;text-align:left">
                                   <span >Cantidad de ampollas teoricas lavadas</span>
                               </td>
                                <td style="text-align:left">
                                   <span >&nbsp;</span>
                               </td>
                                <td style="text-align:left;border-right:solid #a80077 1px;">
                                   <span id="cantidadLote" ><%=(cantidadAmpollasLavadas)%></span>
                               </td>
                        </tr>
                        <tr>
                                <td style="border-left:solid #a80077 1px;text-align:left">
                                   <span >Cantidad de ampollas despirogenizadas</span>
                               </td>
                                <td style="text-align:left;">
                                   <span >&nbsp;</span>
                               </td>
                                <td style="border-right:solid #a80077 1px;text-align:left">
                                   <span id="sumaCantidad" ><%=sumaCantidad%></span>
                               </td>
                        </tr>
                         <tr >
                                <td style="border-left:solid #a80077 1px;text-align:left">
                                   <span >Cantidad de ampollas rotas</span>
                               </td>
                                <td style="text-align:left">
                                   <span >&nbsp;</span>
                               </td>
                                <td style="text-align:left;border-right:solid #a80077 1px;">
                                    <span id="cantidadAmpollasRotas" ><%=(sumaCantidadAmpollasRotas)%></span>

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
                                    <span id="rendimiento" ><%=Math.rint(((sumaCantidad-sumaCantidadAmpollasRotas)/cantidadAmpollasLavadas)*10000)/100d%></span>
                               </td>
                        </tr>
                    </table>
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
                                    <input type="hidden" id="codPersonalSupervisor" value="<%=(codSupervisor)%>"/>
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
                catch(Exception ex)
                {
                    ex.printStackTrace();
                }
                %>
                    <div class="row" style="margin-top:0px;">
                                        <div class="large-6 small-8 medium-10 large-centered medium-centered columns">
                                            <div class="row">
                                                <div class="large-6 medium-6 small-12 columns">
                                                    <button class="small button succes radius buttonAction" onclick="guardarDespirogenizado();" >Guardar</button>
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
            <input type="hidden" id="codLote" value="<%=codLote%>"/>
            <input type="hidden" id="codprogramaProd" value="<%=(codprogramaProd)%>"/>
            <input type="hidden" id="codTipoProgramaProd" value="<%=(codTipoProgramaProd)%>"/>
            <input type="hidden" id="codCompProdRegistro" value="<%=(codCompProdRegistro)%>"/>
            <input type="hidden" id="codFormulaMaestra" value="<%=(codFormulaMaestra)%>"/>
            <input type="hidden" id="codActividadDespirogenizado" value="<%=(codActividadDespirogenizado)%>"/>
            <input type="hidden" id="codSeguimientoDespirogenizado" value="<%=(codSeguimientoDespirogenizado)%>"/>
        </section>
    </body>
    <script src="../../reponse/js/timePickerJs.js"></script>
    <script src="../../reponse/js/dataPickerJs.js"></script>
    <script>iniciarDatePicker('<%=(sdf.format(new Date()))%>');loginHoja.verificarHojaCerrada('cerrado', admin,'codprogramaProd','codLote',4,<%=(codEstadoHoja)%>);</script>
</html>
