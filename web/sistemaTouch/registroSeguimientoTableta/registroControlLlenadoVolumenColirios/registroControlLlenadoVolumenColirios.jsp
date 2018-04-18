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
       
      <style>
          .d{
              cursor:crosshair
          }
      </style>

<script src="../../reponse/js/scripts.js"></script>
<script src="../../reponse/js/zbin.js"></script>

<link rel="STYLESHEET" type="text/css" href="../../reponse/css/foundation.css" />
<link rel="STYLESHEET" type="text/css" href="../../reponse/css/AtlasWeb.css" />
<link rel="STYLESHEET" type="text/css" href="../../reponse/css/timePickerCSs.css" />
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
    var personalSelectAmpollas="";
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
    function hideModalProgresss()
    {
        document.getElementById('formsuper').style.visibility='hidden';
        document.getElementById('divImagen').style.visibility='hidden';
    }
    function panelProgresoVisible()
    {
        document.getElementById('formsuper').style.visibility='visible';
        document.getElementById('divImagen').style.visibility='visible';
        
    }
    function guardarMaquinariasLlenadoVolumen()
    {
        panelProgresoVisible();
        var codLote=document.getElementById('codLoteSeguimiento').value;
        var codProgramaProd=document.getElementById('codProgramaProd').value;
        var tablaMaquinarias=document.getElementById("dataMaquinariasLlenado");
        var dataMaquinarias=new Array();
        
        var cont=0;
        for(var i=1;i<tablaMaquinarias.rows.length;i++)
        {
            //alert(tablaMaquinarias.rows[i].cells[0].getElementsByTagName("input")[0].checked);
            if(tablaMaquinarias.rows[i].cells[0].getElementsByTagName("input")[0].checked)
            {
                dataMaquinarias[cont]=tablaMaquinarias.rows[i].cells[1].getElementsByTagName("input")[0].value;
                cont++;
            }
        }
        
        ajax=nuevoAjax();
        ajax.open("GET","ajaxGuardarControlLlenadoVolumen.jsf?codLote="+codLote+"&noCache="+ Math.random()+
             "&codProgProd="+codProgramaProd+"&dataMaquinarias="+dataMaquinarias+
             "&codSeguimiento="+document.getElementById("conControlLlenadoLote").value+
             "&codPersonalUsuario="+codPersonal
             ,true);
                 ajax.onreadystatechange=function(){
                    if (ajax.readyState==4) {
                        if(ajax.responseText==null || ajax.responseText=='')
                        {
                            alert('No se puede conectar con el servidor, verfique su conexión a internet');
                            hideModalProgresss();
                            return false;
                        }
                        if(parseInt(ajax.responseText.split("\n").join(""))>0)
                        {
                            alert('Se registraron las maquinarias');
                            document.getElementById("conControlLlenadoLote").value=parseInt(ajax.responseText.split("\n").join(""));
                            hideModalProgresss();
                            return true;
                        }
                        else
                        {
                            alert(ajax.responseText.split("\n").join(""));
                            hideModalProgresss();
                            return false;
                        }
                    }
                }
                ajax.send(null);   

    }
    function guardarCierreControlLlenadoLote()
    {
        panelProgresoVisible();
        var codLote=document.getElementById('codLoteSeguimiento').value;
        var codProgramaProd=document.getElementById('codProgramaProd').value;
        ajax=nuevoAjax();
        var peticion="ajaxGuardarCierreControlLlenado.jsf?codLote="+codLote+"&noCache="+ Math.random()+
            "&codProgProd="+codProgramaProd+"&codPersonalSupervisor="+codPersonal+
            "&codSeguimiento="+document.getElementById("conControlLlenadoLote").value+
            "&observaciones="+encodeURIComponent(document.getElementById("observacion").value);

        ajax.open("GET",peticion,true);
        ajax.setRequestHeader('content-type', 'application/x-www-form-urlencoded;charset=UTF-8');
                 ajax.onreadystatechange=function(){
                    if (ajax.readyState==4) {
                        if(ajax.responseText==null || ajax.responseText=='')
                        {
                            alert('No se puede conectar con el servidor, verfique su conexión a internet');
                            hideModalProgresss();
                            return false;
                        }
                        if(parseInt(ajax.responseText.split("\n").join(""))>0)
                        {
                            alert('Se registro la aprobacion');
                            window.close();
                            return true;
                        }
                        else
                        {
                            alert(ajax.responseText.split("\n").join(""));
                            hideModalProgresss();
                            return false;
                        }
                    }
                }
                ajax.send(null);

    }
    function guardarAmpollasTurno(turno)
    {
        panelProgresoVisible();
        var codLote=document.getElementById('codLoteSeguimiento').value;
        var codProgramaProd=document.getElementById('codProgramaProd').value;
        var tablaAmpollas=document.getElementById((turno==1?"dataPrimerTurno":(turno==2?"dataSegundoTurno":"dataTercerTurno")));
        var dataAmpollas=new Array();
        var cont=0;
        for(var i=2;i<tablaAmpollas.rows.length;i++)
        {
            if(validarHoraRegistro(tablaAmpollas.rows[i].cells[0].getElementsByTagName('input')[0])
                &&validarSeleccionRegistro(tablaAmpollas.rows[i].cells[5].getElementsByTagName('select')[0]))
            {

                    dataAmpollas[dataAmpollas.length]=tablaAmpollas.rows[i].cells[0].getElementsByTagName('input')[0].value;
                    for(var j=1;j<=4;j++)
                    {
                          if(validarRegistroNumero(tablaAmpollas.rows[i].cells[j].getElementsByTagName('input')[0]))
                          {
                              dataAmpollas[dataAmpollas.length]=tablaAmpollas.rows[i].cells[j].getElementsByTagName('input')[0].value;
                          }
                          else
                          {
                              hideModalProgresss();
                              return false;
                          }
                    }
                    dataAmpollas[dataAmpollas.length]=tablaAmpollas.rows[i].cells[5].getElementsByTagName('select')[0].value;
            }
            else
            {
                hideModalProgresss();
                return false;
            }
        }
        var dataMaquinarias=new Array();
        var tablaMaquinarias=document.getElementById("dataMaquinariasLlenado");
        for(var i=1;i<tablaMaquinarias.rows.length;i++)
        {
            if(tablaMaquinarias.rows[i].cells[0].getElementsByTagName("input")[0].checked)
            {
                dataMaquinarias[dataMaquinarias.length]=tablaMaquinarias.rows[i].cells[1].getElementsByTagName("input")[0].value;
                cont++;
            }
        }

        ajax=nuevoAjax();

        ajax.open("GET","ajaxGuardarAmpollasTurnoColirios.jsf?codLote="+codLote+"&noCache="+ Math.random()+
             "&codProgProd="+codProgramaProd+"&dataAmpollas="+dataAmpollas+"&turno="+turno+
             "&dataMaquinarias="+dataMaquinarias+
             "&codSeguimiento="+document.getElementById("conControlLlenadoLote").value+
             "&admin="+(admin?1:0)+"&codPersonalUsuario="+codPersonal,true);
                 ajax.onreadystatechange=function(){
                    if (ajax.readyState==4) {
                        if(ajax.responseText==null || ajax.responseText=='')
                        {
                            alert('No se puede conectar con el servidor, verfique su conexión a internet');
                            hideModalProgresss();
                            return false;
                        }
                        if(parseInt(ajax.responseText.split("\n").join(""))>0)
                        {
                            alert('Se registraron las ampollas del '+(turno==1?'primer':(turno==2?'segundo':'tercer'))+' turno');
                            document.getElementById("conControlLlenadoLote").value=parseInt(ajax.responseText.split("\n").join(""));
                            hideModalProgresss();
                            return true;
                        }
                        else
                        {
                            alert(ajax.responseText.split("\n").join(""));
                            hideModalProgresss();
                            return false;
                        }
                    }
                }
                ajax.send(null);   

    }
    function guardarControlLLenadoVolumen()
    {
        
        
        var cont=0;
        
        ajax=nuevoAjax();
        
        ajax.open("GET","ajaxGuardarControlLlenadoVolumen.jsf?codLote="+codLote+"&noCache="+ Math.random()+
             "&codProgProd="+codProgramaProd+"&dataVolumenPrimer="+dataPrimerTurno+"&dataVolumenSegundo="+dataSegundoTurno+"&dataVolumenTercer="+dataTercerTurno+
             "&codSeguimiento="+document.getElementById("conControlLlenadoLote").value+
             "&codMaquinaDosif="+document.getElementById("codMaquinaDosificadora").value,true);
                 ajax.onreadystatechange=function(){
                    if (ajax.readyState==4) {
                        if(ajax.responseText==null || ajax.responseText=='')
                        {
                            alert('No se puede conectar con el servidor, verfique su conexión a internet');
                            document.getElementById('formsuper').style.visibility='hidden';
                            document.getElementById('divImagen').style.visibility='hidden';
                            return false;
                        }
                        if(parseInt(ajax.responseText.split("\n").join(""))=='1')
                        {
                            alert('Se registro el control de llenado de volumen');
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
    var contadorRegistros=0;
   function fechaIncrementadaRegistro(celda)
   {
      var incr=new Date();
      incr.setHours(parseInt(celda.split(":")[0]));
      incr.setMinutes(parseInt(celda.split(":")[1])+30);
      return ((incr.getHours()>9?"":"0")+incr.getHours()+":"+(incr.getMinutes()>9?"":"0")+incr.getMinutes());
   }
   function nuevoRegistro(nombreTabla)
   {
       contadorRegistros++;
       var table = document.getElementById(nombreTabla);
       var rowCount = table.rows.length;
       var row = table.insertRow(rowCount);
       row.onclick=function(){seleccionarFila(this);};
       var cell1 = row.insertCell(0);
       cell1.className="tableCell";
       var element1 = document.createElement("input");
       element1.type = "tel";
       element1.style.width='4em';
       element1.value=(rowCount==2?getHoraActualString():fechaIncrementadaRegistro(table.rows[(rowCount-1)].cells[0].getElementsByTagName("input")[0].value));
       element1.id='adicionado'+contadorRegistros;
       element1.onclick=function(){seleccionarHora(this);}
       cell1.appendChild(element1);
       for(var i=0;i<4;i++)
       {
           var cell2 = row.insertCell(1+i);
           cell2.className="tableCell";
           var element2 = document.createElement("input");
           element2.type = "tel";
          // element2.onkeypress= function(event) {valNum(event);};
           cell2.appendChild(element2);
       }
       var cell2 = row.insertCell(5);
       cell2.className="tableCell";
       var element2 = document.createElement("select");
       element2.innerHTML=personalSelectAmpollas;
       cell2.appendChild(element2);
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
        boolean administrador=(Integer.valueOf(request.getParameter("admin"))>0);
        out.println("<script type='text/javascript'>codPersonal="+codPersonal+";" +
                   "admin="+administrador+";</script>");
        int codEstadoHoja=0;
        boolean permiso1ErTurno=false;
        boolean permiso2doTurno=false;
        boolean permiso3erTurno=false;
        SimpleDateFormat sdfDias=new SimpleDateFormat("dd/MM/yyyy");
        SimpleDateFormat sdfHora=new SimpleDateFormat("HH:mm");
        Date fechaCierre=new Date();
        String codFormulaMaestra="";
        String codCompProd=request.getParameter("codComprod");
        String codLote=request.getParameter("codLote");
        out.println("<title>("+codLote+")CONTROL LLENADO PESO</title>");
        String codprogramaProd=request.getParameter("cod_prog");
        String nombreComponente="as";
        String nombreAreaEmpresa="as";
        String codForma="";
        String codAreaEmpresa=request.getParameter("codAreaEmpresa");
        Date fechaRegistro=new Date();
        String operarios="";
        String conControlLlenadoLote="";
        NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
        DecimalFormat format = (DecimalFormat)nf;
        SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy");
        format.applyPattern("#,##0.00");
        String script="";
        int codPersonalSupervisor=0;
        String observaciones="";
                try
                {
                    Connection con=null;
                    con=Util.openConnection(con);
                    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    String consulta="select cp.COD_FORMA,p.nombre_prod,f.abreviatura_forma,cp.nombre_prod_semiterminado,cp.NOMBRE_GENERICO,f.nombre_forma,cp.REG_SANITARIO,"+
                                    " ep.nombre_envaseprim,cp.VIDA_UTIL,pp.CANT_LOTE_PRODUCCION,ppp.FECHA_FINAL," +
                                    " pp.COD_FORMULA_MAESTRA,isnull(scll.COD_SEGUIMIENTO_CONTROL_LLENADO_LOTE,0) as COD_SEGUIMIENTO_CONTROL_LLENADO_LOTE" +
                                    " ,ISNULL(cp.VOLUMEN_ENVASE_PRIMARIO,'') as VOLUMEN_ENVASE_PRIMARIO" +
                                    " ,ISNULL(dpff.PRE_INDICACIONES_CONTROL_LLENADO_VOLUMEN,'') as PRE_INDICACIONES_CONTROL_LLENADO_VOLUMEN,"+
                                    " isnull(dpff.INDICACIONES_CONTROL_VOLUMEN_LLENADO, '') as INDICACIONES_CONTROL_VOLUMEN_LLENADO" +
                                    " ,isnull(cpr.COD_RECETA_DOSIFICADO,0) as COD_RECETA_DOSIFICADO" +
                                    " ,ISNULL(dpff.CANTIDAD_COLUMNAS_CONTROL_LLENADO_VOLUMEN,5) as CANTIDAD_COLUMNAS_CONTROL_LLENADO_VOLUMEN" +
                                    " ,isnull(scll.COD_PERSONAL_SUPERVISOR,0) as codPersonalSupervisor,ISNULL(scll.OBSERVACION,'') as OBSERVACION" +
                                    " ,scll.FECHA_CIERRE,isnull(scll.COD_ESTADO_HOJA,0) as COD_ESTADO_HOJA" +
                                    " ,isnull(conjunta.loteAsociado,'') as loteAsociado,isnull(conjunta.cantAsociado,0) as cantAsociado" +
                                    " from PROGRAMA_PRODUCCION pp inner join COMPONENTES_PROD cp on cp.COD_COMPPROD=pp.COD_COMPPROD"+
                                    " inner join FORMAS_FARMACEUTICAS f on f.cod_forma=cp.COD_FORMA"+
                                    " inner join productos p on p.cod_prod=cp.COD_PROD"+
                                    " inner join PRESENTACIONES_PRIMARIAS ppm on ppm.COD_COMPPROD=cp.COD_COMPPROD and ppm.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD"+
                                    " inner join ENVASES_PRIMARIOS ep on ep.cod_envaseprim=ppm.COD_ENVASEPRIM" +
                                    " inner join PROGRAMA_PRODUCCION_PERIODO ppp on pp.COD_PROGRAMA_PROD=ppp.COD_PROGRAMA_PROD" +
                                    " left outer join SEGUIMIENTO_CONTROL_LLENADO_LOTE scll on scll.COD_LOTE=pp.COD_LOTE_PRODUCCION"+
                                    " and scll.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD" +
                                    " left outer join DESCRIPCION_PROCESOS_FORMA_FARMACEUTICA dpff on dpff.COD_FORMA=cp.COD_FORMA" +
                                    " left outer join COMPONENTES_PROD_RECETA cpr on cpr.COD_COMPROD=pp.COD_COMPPROD"+
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
                    String preIndicacionesControlLLenadoVolumen="";
                    String indicacionesControlLLenadoVolumen="";
                    int codRecetaDosificado=0;
                    int cantidadColumnasRegistroLLenado=0;
                    char b=13;char c=10;
                    int codMaquinaDosificadora=0;
                    if(res.next())
                    {
                        fechaCierre=(res.getTimestamp("FECHA_CIERRE")!=null?res.getTimestamp("FECHA_CIERRE"):new Date());
                        codEstadoHoja=res.getInt("COD_ESTADO_HOJA");
                        codPersonalSupervisor=res.getInt("codPersonalSupervisor");
                        observaciones=res.getString("OBSERVACION");
                        //codMaquinaDosificadora=res.getInt("COD_MAQUINA_DOSIFICADORA");
                        cantidadColumnasRegistroLLenado=4;//res.getInt("CANTIDAD_COLUMNAS_CONTROL_LLENADO_VOLUMEN");
                        codRecetaDosificado=res.getInt("COD_RECETA_DOSIFICADO");
                        preIndicacionesControlLLenadoVolumen=res.getString("PRE_INDICACIONES_CONTROL_LLENADO_VOLUMEN").replace(b,'\n').replace("\n", "</br>").replace("</br></br>","<br>").replace("\"v\"","\"√\"");
                        indicacionesControlLLenadoVolumen=res.getString("INDICACIONES_CONTROL_VOLUMEN_LLENADO").replace(b,'\n').replace("\n", "</br>").replace("</br></br>","<br>").replace("\"v\"","\"√\"");
                        
                        conControlLlenadoLote=res.getString("COD_SEGUIMIENTO_CONTROL_LLENADO_LOTE");
                        codFormulaMaestra=res.getString("COD_FORMULA_MAESTRA");
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
                                                       <label  class="inline">CONTROL DE LLENADO DE PESO</label>
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
                                   <label  class="inline">CONTROL DE LLENADO DE PESO</label>
                            </div>
                        </div>
                        <div class="row" >

                        <div  class="divContentClass large-12 medium-12 small-12 columns" style="padding-top:12px;">
                        <%--span style="top:10px;"><span style="font-weight:bold;">NOTA:</span><%=(preIndicacionesControlLLenadoVolumen)%></span--%>
                        <div class="row">
                            <div class="large-12 medium-12 small-12 large-centered medium-centered small-centered columns" align="center">
                                <table style="width:90%;margin-top:2%;border:none" id="dataDespejeLinea" cellpadding="0px" cellspacing="0px">
                                          
                              <%
                              }
                                
                               
                                consulta="select pp.COD_TIPO_PROGRAMA_PROD,tpp.NOMBRE_TIPO_PROGRAMA_PROD,"+
                                         " isnull(sclle.LIMITE_TEORICO,0) as limiteTeorico,"+
                                         " isnull(sclle.LIMITE_INFERIOR,0) as limiteInferior,"+
                                         " isnull(sclle.LIMITE_SUPERIOR,0) as limiteSuperior"+
                                         " from PROGRAMA_PRODUCCION pp inner join TIPOS_PROGRAMA_PRODUCCION tpp on "+
                                         " tpp.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD"+
                                         " left outer join SEGUIMIENTO_CONTROL_LLENADO_LOTE_ESP sclle on "+
                                         " pp.COD_TIPO_PROGRAMA_PROD=sclle.COD_TIPO_PROGRAMA_PROD"+
                                         " and sclle.COD_SEGUIMIENTO_CONTROL_LLENADO_LOTE='"+conControlLlenadoLote+"'"+
                                         " where pp.COD_LOTE_PRODUCCION ='"+codLote+"' and pp.COD_PROGRAMA_PROD="+codprogramaProd;
                                System.out.println("consulta buscar valor receta "+consulta);
                                res=st.executeQuery(consulta);
                                if(res.next())
                                    {
                                    script+="registroPesoMCMM.agregarRegistroEspecificacion(new registroEspecificacion("+res.getInt("COD_TIPO_PROGRAMA_PROD")+",'"+res.getString("NOMBRE_TIPO_PROGRAMA_PROD")+"',"+format.format(res.getDouble("limiteTeorico"))+","+format.format(res.getDouble("limiteInferior"))+","+format.format(res.getDouble("limiteSuperior"))+"));";
                                      %>
                                      <tr>
                                          
                                          <td class="tableHeaderClass" style="text-align:center;" colspan="6">
                                              <span class="textHeaderClass"><%=(res.getString("NOMBRE_TIPO_PROGRAMA_PROD"))%></span>
                                           </td>
                                      </tr>
                                      <tr>
                                           <td class="tableCell" >
                                               <span class="textHeaderClassBody" style="font-weight:normal">Limites de aceptación teórico en gramos</span>
                                           </td>
                                           <td class="tableCell" >
                                               <span class="textHeaderClassBody" style="font-weight:normal"><%=(format.format(res.getDouble("limiteTeorico")))%>(g)</span>
                                           </td>
                                           <td class="tableCell" style="text-align:left;">
                                               <span class="textHeaderClassBody" style="font-weight:normal">Limites de aceptación maximo en gramos </span>
                                           </td>
                                           <td class="tableCell" style="text-align:left;">
                                               <span class="textHeaderClassBody" style="font-weight:normal"><%=(format.format(res.getDouble("limiteSuperior")))%>(g)</span>
                                           </td>
                                           <td class="tableCell" style="text-align:left;">
                                               <span class="textHeaderClassBody" style="font-weight:normal">Limites de aceptación minimo en gramos </span>
                                           </td>
                                           <td class="tableCell" style="text-align:left;">
                                               <span class="textHeaderClassBody" style="font-weight:normal"><%=(format.format(res.getDouble("limiteInferior")))%>(g)</span>
                                           </td>
                                      </tr>
                                  <%
                                  }
                                  %>

                              </table>
                            </div>
                        </div>
                        <center>
                        <table style="border:none;margin-top:4px;border-bottom:1px solid #a80077" id="dataMaquinariasLlenado" cellpadding="0px" cellspacing="0px">
                            
                                    
                                        <%
                                        String cabeceraPersonal="";
                                       String innerCabeceraPersonal="";
                                       String detallePersonal="";
                                       int contDetalle=0;
                                       if(administrador)
                                        {
                                            consulta="select p.COD_PERSONAL,(p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+'<br>'+p.NOMBRES_PERSONAL)as nombrePersonal"+
                                                     " from SEGUIMIENTO_MAQUINARIAS_CONTROL_LLENADO_VOLUMEN s inner join personal p on"+
                                                     " p.COD_PERSONAL=s.COD_PERSONAL"+
                                                     " where s.COD_SEGUIMIENTO_CONTROL_LLENADO_LOTE='"+conControlLlenadoLote+"'"+
                                                     " group by p.COD_PERSONAL,p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRES_PERSONAL"+
                                                     " order by p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRES_PERSONAL";
                                            System.out.println("consulta personal seguimiento control llenaod "+consulta);
                                            res=st.executeQuery(consulta);
                                            while(res.next())
                                            {
                                                innerCabeceraPersonal+="<td class='tableHeaderClass' style='text-align:center;'><span class='textHeaderClass'>"+res.getString("nombrePersonal")+"</span></td>";
                                                cabeceraPersonal+=" ,ISNULL(smaclv"+res.getRow()+".COD_MAQUINA,0) as registrado"+res.getRow();
                                                detallePersonal+=" LEFT OUTER JOIN SEGUIMIENTO_MAQUINARIAS_CONTROL_LLENADO_VOLUMEN smaclv"+res.getRow()+" on "+
                                                                 " smaclv"+res.getRow()+".COD_MAQUINA=m.COD_MAQUINA and "+
                                                                 " smaclv"+res.getRow()+".COD_SEGUIMIENTO_CONTROL_LLENADO_LOTE = '"+conControlLlenadoLote+"'" +
                                                                 " and smaclv"+res.getRow()+".COD_PERSONAL='"+res.getInt("COD_PERSONAL")+"'";
                                                contDetalle=res.getRow();
                                            }

                                        }
                                       out.println("<tr>"+(contDetalle>0?innerCabeceraPersonal:"")+"<td class='tableHeaderClass' colspan='"+(contDetalle>0?"1":"2")+"'><span class='textHeaderClass' >Maquina Dosificadora</span></td></tr>");
                                        consulta="SELECT cpml.COD_MAQUINA,m.NOMBRE_MAQUINA,m.CODIGO" +
                                                 (contDetalle>0?cabeceraPersonal:",ISNULL(smaclv.COD_MAQUINA,0) as registrado")+
                                                 " from COMPONENTES_PROD_MAQUINARIA_LIMPIEZA cpml inner join MAQUINARIAS m "+
                                                 " on m.COD_MAQUINA=cpml.COD_MAQUINA" +
                                                 (contDetalle>0?detallePersonal:" LEFT OUTER JOIN SEGUIMIENTO_MAQUINARIAS_CONTROL_LLENADO_VOLUMEN smaclv"+
                                                 " on smaclv.COD_MAQUINA=m.COD_MAQUINA and smaclv.COD_SEGUIMIENTO_CONTROL_LLENADO_LOTE='"+conControlLlenadoLote+"'" +
                                                 " and smaclv.cod_personal='"+codPersonal+"'")+
                                                 " where cpml.COD_COMPPROD='"+codCompProd+"' and m.COD_SECCION_ORDEN_MANUFACTURA in (3)" +
                                                 " order by m.NOMBRE_MAQUINA";
                                        System.out.println("consulta cargar maquinarias limpieza envasado 1 "+consulta);
                                        res=st.executeQuery(consulta);
                                        while(res.next())
                                        {
                                            out.println("<tr>");
                                            if(contDetalle>0)for(int i=1;i<=contDetalle;i++)out.println("<td style='border-right:1px solid #a80077;border-left:1px solid #a80077' ><input style='width:1.4em;height:1.4em;margin-bottom:0.3em !important' type='checkbox' "+(res.getInt("registrado"+i)>0?"checked":"")+"/></td>");
                                            else out.println("<td style='border-left:1px solid #a80077'><input style='width:1.4em;height:1.4em;margin-bottom:0.3em !important' type='checkbox' "+(res.getInt("registrado")>0?"checked":"")+"/></td>");
                                            %>
                                            
                                                
                                                <td style="border-right:1px solid #a80077">
                                                    <input type="hidden" value="<%=(res.getInt("COD_MAQUINA"))%>">
                                                    <span class="tableHeaderClassBody"><%=(res.getString("NOMBRE_MAQUINA"))%></span>
                                                </td>
                                            <%
                                            out.println("</tr>");
                                        }
                                        %>
                                  
                        </table>
                        </center>
                         
                          
                        <span style="top:10px;"><span style="font-weight:bold;">Frecuencia de muestreo:</span><%=(indicacionesControlLLenadoVolumen)%></span>
                        <div class="row">
                            <div class="large-12 medium-12 small-12 large-centered medium-centered small-centered columns">
                                
                                                 
                              <%
                              String cabeceraRegistros="<tr><td class='tableHeaderClass'><span class='textHeaderClass'>HORA</span></td>";
                              for(int i=1;i<=cantidadColumnasRegistroLLenado;i++)
                              {
                                  cabeceraRegistros+="<td class='tableHeaderClass' style='text-align:center;'><span class='textHeaderClass'>Frasco "+i+"</span></td>";
                              }
                              cabeceraRegistros+="<td class='tableHeaderClass'><span class='textHeaderClass'>OPERARIO</span></td></tr>";
                              res=st.executeQuery(consulta);
                              String personal=UtilidadesTablet.operariosAreaProduccionAdminSelect(st,"81", codPersonal, administrador);
                              
                              int cont=0;
                              out.println("<script>personalSelectAmpollas=\""+personal+"\";</script>");
                              if(!administrador)
                              {
                                  consulta="select top 1 toml7.COD_PERSONAL from TAREAS_OM_PERSONAL_LOTE toml7 where toml7.COD_LOTE = '"+codLote+"' and"+
                                           " toml7.COD_PROGRAMA_PROD = '"+codprogramaProd+"' and toml7.COD_TAREA_OM =11 and toml7.COD_PERSONAL = '"+codPersonal+"'";
                                  System.out.println("consulta verificar permiso 1er turno "+consulta);
                                  res=st.executeQuery(consulta);
                                  permiso1ErTurno=res.next();
                              }
                              if(administrador||true)
                              {
                                    out.println("<table style='border:none;width:100%;margin-top:4px;' id='dataPrimerTurno' class='0' cellpadding='0px' cellspacing='0px'><td></td>"+
                                                "<td class='tableHeaderClass' style='text-align:center;' colspan='4'><span class='textHeaderClass'>Peso de Frascos(1er Turno)</span></td></tr>"+cabeceraRegistros);
                                    consulta="SELECT sclld.HORA_MUESTRA,ISNULL(sclld.VOLUMEN_AMPOLLA1,0) as VOLUMEN_AMPOLLA1,"+
                                             " ISNULL(sclld.VOLUMEN_AMPOLLA2,0) as VOLUMEN_AMPOLLA2,ISNULL(sclld.VOLUMEN_AMPOLLA3,0) as VOLUMEN_AMPOLLA3,"+
                                             " ISNULL(sclld.VOLUMEN_AMPOLLA4,0) as VOLUMEN_AMPOLLA4,ISNULL(sclld.VOLUMEN_AMPOLLA5,0) as VOLUMEN_AMPOLLA5,"+
                                             " ISNULL(sclld.VOLUMEN_AMPOLLA6,0) as VOLUMEN_AMPOLLA6" +
                                             ",isnull(sclld.COD_PERSONAL,0) as COD_PERSONAL"+
                                             " FROM SEGUIMIENTO_CONTROL_LLENADO_LOTE_DETALLE sclld"+
                                             " where sclld.COD_SEGUIMIENTO_CONTROL_LLENADO_LOTE='"+conControlLlenadoLote+"'"+
                                             " and sclld.TURNO=1"+
                                             (administrador?"":" and sclld.COD_PERSONAL='"+codPersonal+"'")+
                                             " order by sclld.HORA_MUESTRA";
                                    System.out.println("consulta cargar seguimiento "+consulta);
                                    res=st.executeQuery(consulta);
                                    
                                    while(res.next())
                                    {
                                        out.println("<tr onclick=\"seleccionarFila(this);\"><td class='tableCell' style='text-align:left'>"+
                                                    " <input style='width:4em;' "+(administrador?"disabled":"")+" type='text' onclick='seleccionarHora(this);' id='primerTurno"+res.getRow()+"' value='"+sdfHora.format(res.getTimestamp("HORA_MUESTRA"))+"'/></td>"+
                                                    " <td class='tableCell' style='text-align:left'><input "+(administrador?"disabled":"")+" type='tel' value='"+res.getDouble("VOLUMEN_AMPOLLA1")+"'></td>" +
                                                    " <td class='tableCell' style='text-align:left'><input "+(administrador?"disabled":"")+" type='tel' value='"+res.getDouble("VOLUMEN_AMPOLLA2")+"'></td>" +
                                                    " <td class='tableCell' style='text-align:left'><input "+(administrador?"disabled":"")+" type='tel' value='"+res.getDouble("VOLUMEN_AMPOLLA3")+"'></td>" +
                                                    " <td class='tableCell' style='text-align:left'><input "+(administrador?"disabled":"")+" type='tel' value='"+res.getDouble("VOLUMEN_AMPOLLA4")+"'></td>" +
                                                    /*" <td class='tableCell' style='text-align:left'><input "+(administrador?"disabled":"")+" type='tel' value='"+res.getDouble("VOLUMEN_AMPOLLA5")+"'></td>" +
                                                    " <td class='tableCell' style='text-align:left'><input "+(administrador?"disabled":"")+" type='tel' value='"+res.getDouble("VOLUMEN_AMPOLLA6")+"'></td>" +
                                                    " <td class='tableCell' style='text-align:left'><input type='text' value='"+res.getDouble("VOLUMEN_AMPOLLA7")+"'></td>" +
                                                    " <td class='tableCell' style='text-align:left'><input type='text' value='"+res.getDouble("VOLUMEN_AMPOLLA8")+"'></td>" +*/
                                                    " <td class='tableCell' style='text-align:left'><select "+(administrador?"disabled":"")+" id='codPersonal"+cont+"'>"+personal+"</select><script>codPersonal"+cont+".value='"+res.getString("COD_PERSONAL")+"'</script></td>" +
                                                    "</tr>");
                                        cont++;
                                    }
                                    out.println("</table><div class='row'><div class='large-5 medium-5 small-4 columns' style=''>&nbsp;</div>"+
                                                " <div class='large-1 medium-1 small-2 columns'><button  "+(administrador?"disabled":"")+" class='small button succes radius buttonAction' onclick=\"nuevoRegistro('dataPrimerTurno')\">+</button></div>"+
                                                " <div class=\"large-1 medium-1 small-2 columns\"><button  "+(administrador?"disabled":"")+" class=\"small button succes radius buttonAction\" onclick=\"eliminarRegistroTabla('dataPrimerTurno')\">-</button></div>"+
                                                " <div class=\"large-5 medium-5 small-4 columns\" style=''>&nbsp;</div></div>"+
                                                " <div class=\"row\"><div class=\"large-2 medium-6 small-12 small-centered medium-centered columns\"><button "+(administrador?"disabled":"")+" class=\"small button succes radius buttonAction\" onclick=\"guardarAmpollasTurno(1)\">Guardar Ampollas 1er Turno</button></div></div>");
                                    
                              }
                              if(!administrador)
                              {
                                  consulta="select top 1 toml7.COD_PERSONAL from TAREAS_OM_PERSONAL_LOTE toml7 where toml7.COD_LOTE = '"+codLote+"' and"+
                                           " toml7.COD_PROGRAMA_PROD = '"+codprogramaProd+"' and toml7.COD_TAREA_OM =12 and toml7.COD_PERSONAL = '"+codPersonal+"'";
                                  System.out.println("consulta verificar permiso 2do turno "+consulta);
                                  res=st.executeQuery(consulta);
                                  permiso2doTurno=res.next();
                              }
                              if(administrador||permiso2doTurno)
                              {
                                        out.println("<table style=\"border:none;width:100%;margin-top:4px;\" id=\"dataSegundoTurno\" cellpadding=\"0px\" cellspacing=\"0px\"><tr><td></td>"+
                                                    " <td class='tableHeaderClass' style='text-align:center;' colspan=\"4\"><span class='textHeaderClass'>Peso de Frascos(2do Turno)</span></td>"+
                                                    "</tr>"+cabeceraRegistros);
                                        consulta="SELECT sclld.HORA_MUESTRA,ISNULL(sclld.VOLUMEN_AMPOLLA1,0) as VOLUMEN_AMPOLLA1,"+
                                                 " ISNULL(sclld.VOLUMEN_AMPOLLA2,0) as VOLUMEN_AMPOLLA2,ISNULL(sclld.VOLUMEN_AMPOLLA3,0) as VOLUMEN_AMPOLLA3,"+
                                                 " ISNULL(sclld.VOLUMEN_AMPOLLA4,0) as VOLUMEN_AMPOLLA4,ISNULL(sclld.VOLUMEN_AMPOLLA5,0) as VOLUMEN_AMPOLLA5,"+
                                                 " ISNULL(sclld.VOLUMEN_AMPOLLA6,0) as VOLUMEN_AMPOLLA6" +
                                                 ",isnull(sclld.COD_PERSONAL,0) as COD_PERSONAL"+
                                                 " FROM SEGUIMIENTO_CONTROL_LLENADO_LOTE_DETALLE sclld"+
                                                 " where sclld.COD_SEGUIMIENTO_CONTROL_LLENADO_LOTE='"+conControlLlenadoLote+"'"+
                                                 " and sclld.TURNO=2"+
                                                 (administrador?"":" and sclld.COD_PERSONAL='"+codPersonal+"'")+
                                                 " order by sclld.HORA_MUESTRA";
                                        System.out.println("consulta cargar seguimiento "+consulta);
                                        res=st.executeQuery(consulta);
                                        while(res.next())
                                        {
                                            out.println("<tr onclick=\"seleccionarFila(this);\" ><td class='tableCell' style='text-align:left'>"+
                                                        " <input "+(administrador?"disabled":"")+" onclick='seleccionarHora(this);' id='segundoTurno"+res.getRow()+"' style='width:4em;' type='text' value='"+sdfHora.format(res.getTimestamp("HORA_MUESTRA"))+"'/></td>"+
                                                        " <td class='tableCell' style='text-align:left'><input "+(administrador?"disabled":"")+" type='tel' value='"+res.getDouble("VOLUMEN_AMPOLLA1")+"'></td>" +
                                                        " <td class='tableCell' style='text-align:left'><input "+(administrador?"disabled":"")+" type='tel' value='"+res.getDouble("VOLUMEN_AMPOLLA2")+"'></td>" +
                                                        " <td class='tableCell' style='text-align:left'><input "+(administrador?"disabled":"")+" type='tel' value='"+res.getDouble("VOLUMEN_AMPOLLA3")+"'></td>" +
                                                        " <td class='tableCell' style='text-align:left'><input "+(administrador?"disabled":"")+" type='tel' value='"+res.getDouble("VOLUMEN_AMPOLLA4")+"'></td>" +
                                                        /*" <td class='tableCell' style='text-align:left'><input "+(administrador?"disabled":"")+" type='tel' value='"+res.getDouble("VOLUMEN_AMPOLLA5")+"'></td>" +
                                                        " <td class='tableCell' style='text-align:left'><input "+(administrador?"disabled":"")+" type='tel' value='"+res.getDouble("VOLUMEN_AMPOLLA6")+"'></td>" +
                                                        " <td class='tableCell' style='text-align:left'><input type='text' value='"+res.getDouble("VOLUMEN_AMPOLLA7")+"'></td>" +
                                                        " <td class='tableCell' style='text-align:left'><input type='text' value='"+res.getDouble("VOLUMEN_AMPOLLA8")+"'></td>" +*/
                                                        " <td class='tableCell' style='text-align:left'><select "+(administrador?"disabled":"")+" id='codPersonal"+cont+"'>"+personal+"</select><script>codPersonal"+cont+".value='"+res.getString("COD_PERSONAL")+"'</script></td>" +
                                                        "</tr>");
                                            cont++;
                                        }
                                        out.println("</table><div class=\"row\" ><div class=\"large-5 medium-5 small-4 columns\" style=''>&nbsp;</div><div class=\"large-1 medium-1 small-2 columns\" >"+
                                                    "<button "+(administrador?"disabled":"")+"  class=\"small button succes radius buttonAction\" onclick=\"nuevoRegistro('dataSegundoTurno')\">+</button></div>"+
                                                    " <div class=\"large-1 medium-1 small-2 columns\"><button "+(administrador?"disabled":"")+" class=\"small button succes radius buttonAction\" onclick=\"eliminarRegistroTabla('dataSegundoTurno')\">-</button></div>"+
                                                    " <div class=\"large-5 medium-5 small-4 columns\" style=''>&nbsp;</div></div>"+
                                                    " <div class=\"row\"> <div class=\"large-2 medium-6 small-12 small-centered medium-centered columns\">"+
                                                    " <button "+(administrador?"disabled":"")+" class=\"small button succes radius buttonAction\" onclick=\"guardarAmpollasTurno(2)\">Guardar Ampollas 2do Turno</button></div></div>");
                                }
                              if(!administrador)
                              {
                                  consulta="select top 1 toml7.COD_PERSONAL from TAREAS_OM_PERSONAL_LOTE toml7 where toml7.COD_LOTE = '"+codLote+"' and"+
                                           " toml7.COD_PROGRAMA_PROD = '"+codprogramaProd+"' and toml7.COD_TAREA_OM =13 and toml7.COD_PERSONAL = '"+codPersonal+"'";
                                  System.out.println("consulta verificar permiso 3er turno "+consulta);
                                  res=st.executeQuery(consulta);
                                  permiso3erTurno=res.next();
                              }
                              if(administrador||permiso3erTurno)
                              {
                                        out.println("<table style=\"border:none;width:100%;margin-top:4px\" id=\"dataTercerTurno\" cellpadding=\"0px\" cellspacing=\"0px\"><tr>"+
                                                    " <td></td><td class='tableHeaderClass' style='text-align:center;' colspan=\"4\"><span class='textHeaderClass'>Peso de Frascos(3er Turno)</span></td></tr>"+cabeceraRegistros);
                                        consulta="SELECT sclld.HORA_MUESTRA,ISNULL(sclld.VOLUMEN_AMPOLLA1,0) as VOLUMEN_AMPOLLA1,"+
                                                 " ISNULL(sclld.VOLUMEN_AMPOLLA2,0) as VOLUMEN_AMPOLLA2,ISNULL(sclld.VOLUMEN_AMPOLLA3,0) as VOLUMEN_AMPOLLA3,"+
                                                 " ISNULL(sclld.VOLUMEN_AMPOLLA4,0) as VOLUMEN_AMPOLLA4,ISNULL(sclld.VOLUMEN_AMPOLLA5,0) as VOLUMEN_AMPOLLA5,"+
                                                 " ISNULL(sclld.VOLUMEN_AMPOLLA6,0) as VOLUMEN_AMPOLLA6" +
                                                 ",isnull(sclld.COD_PERSONAL,0) as COD_PERSONAL"+
                                                 " FROM SEGUIMIENTO_CONTROL_LLENADO_LOTE_DETALLE sclld"+
                                                 " where sclld.COD_SEGUIMIENTO_CONTROL_LLENADO_LOTE='"+conControlLlenadoLote+"'"+
                                                 (administrador?"":" and sclld.COD_PERSONAL='"+codPersonal+"'")+
                                                 " and sclld.TURNO=3"+
                                                 " order by sclld.HORA_MUESTRA";
                                        System.out.println("consulta cargar seguimiento "+consulta);
                                        res=st.executeQuery(consulta);
                                        while(res.next())
                                        {
                                            out.println(" <tr onclick=\"seleccionarFila(this);\"><td class='tableCell' style='text-align:left'>"+
                                                        " <input "+(administrador?"disabled":"")+" onclick='seleccionarHora(this);' id='tercerTurno"+res.getRow()+"' style='width:4em;' type='text' value='"+sdfHora.format(res.getTimestamp("HORA_MUESTRA"))+"'/></td>"+
                                                        " <td class='tableCell' style='text-align:left'><input "+(administrador?"disabled":"")+" type='tel' value='"+res.getDouble("VOLUMEN_AMPOLLA1")+"'></td>" +
                                                        " <td class='tableCell' style='text-align:left'><input "+(administrador?"disabled":"")+" type='tel' value='"+res.getDouble("VOLUMEN_AMPOLLA2")+"'></td>" +
                                                        " <td class='tableCell' style='text-align:left'><input "+(administrador?"disabled":"")+" type='tel' value='"+res.getDouble("VOLUMEN_AMPOLLA3")+"'></td>" +
                                                        " <td class='tableCell' style='text-align:left'><input "+(administrador?"disabled":"")+" type='tel' value='"+res.getDouble("VOLUMEN_AMPOLLA4")+"'></td>" +
                                                        /*" <td class='tableCell' style='text-align:left'><input "+(administrador?"disabled":"")+" type='tel' value='"+res.getDouble("VOLUMEN_AMPOLLA5")+"'></td>" +
                                                        " <td class='tableCell' style='text-align:left'><input "+(administrador?"disabled":"")+" type='tel' value='"+res.getDouble("VOLUMEN_AMPOLLA6")+"'></td>" +
                                                        " <td class='tableCell' style='text-align:left'><input type='text' value='"+res.getDouble("VOLUMEN_AMPOLLA7")+"'></td>" +
                                                        " <td class='tableCell' style='text-align:left'><input type='text' value='"+res.getDouble("VOLUMEN_AMPOLLA8")+"'></td>" +*/
                                                        " <td class='tableCell' style='text-align:left'><select "+(administrador?"disabled":"")+" id='codPersonal"+cont+"'>"+personal+"</select><script>codPersonal"+cont+".value='"+res.getString("COD_PERSONAL")+"'</script></td>" +
                                                        "</tr>");
                                            cont++;
                                        }
                                        out.println("</table><div class=\"row\"><div class=\"large-5 medium-5 small-4 columns\" style=''>&nbsp;</div>"+
                                                    " <div class=\"large-1 medium-1 small-2  columns\"><button "+(administrador?"disabled":"")+" class=\"small button succes radius buttonAction\" onclick=\"nuevoRegistro('dataTercerTurno')\">+</button></div>"+
                                                    " <div class=\"large-1 medium-1 small-2 columns\"><button "+(administrador?"disabled":"")+" class=\"small button succes radius buttonAction\" onclick=\"eliminarRegistroTabla('dataTercerTurno')\">-</button></div>"+
                                                    " <div class=\"large-5 medium-5 small-4 columns\" style=''>&nbsp;</div></div><div class=\"row\">"+
                                                    " <div class=\"large-2 medium-6 small-12 small-centered medium-centered columns\"><button "+(administrador?"disabled":"")+" class=\"small button succes radius buttonAction\" onclick=\"guardarAmpollasTurno(3)\">Guardar Ampollas Tercer Turno</button></div></div>");
                                   }
                              %>
                              
                            </div>
                        </div>
                      <input type="hidden" value="<%=(codPersonalSupervisor)%>" id="cerrado">
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
                                            <span><%=(sdfHora.format(fechaCierre)) %></span>
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
                            <div class="row">
                                  <div class="large-2 medium-6 small-12 small-centered medium-centered columns">
                                      <button class="small button succes radius buttonAction" onclick="guardarCierreControlLlenadoLote()">Guardar</button>
                                  </div>
                             </div>
                        <%
                            }
                        %>
                    
                <%
                
                }
                catch(SQLException ex)
                {
                    ex.printStackTrace();
                }
               // out.println("<script>loginHoja.verificarHojaCerrada('cerrado');</script>");
                %>
                    <%--div class="row" style="margin-top:0px;">
                            <div class="large-6 small-8 medium-10 large-centered medium-centered columns">
                                <div class="row">
                                    <div class="large-6 medium-6 small-12 columns">
                                        <button class="small button succes radius buttonAction" onclick="guardarControlLLenadoVolumen();" >Guardar</button>
                                    </div>
                                        <div class="large-6 medium-6 small-12  columns">
                                            <button class="small button succes radius buttonAction" onclick="window.close();" >Cancelar</button>

                                        </div>
                                </div>
                            </div>
                    </div--%>

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
        <input type="hidden" id="conControlLlenadoLote" value="<%=conControlLlenadoLote%>">
        <input type="hidden" id="codFormulaMaestra" value="<%=codFormulaMaestra%>">
        </section>
    </body>
    <script src="../../reponse/js/registroPesoColirios.js" charset="UTF-8" ></script>
    <script src="../../reponse/js/timePickerJs.js"></script>
    <script>loginHoja.verificarHojaCerrada('cerrado', admin,'codProgramaProd','codLoteSeguimiento',7,<%=(codEstadoHoja)%>);<%=(script)%>registroPesoMCMM.verificarRegistroLlenadoVolumen(admin,'codProgramaProd','codLoteSeguimiento');</script>
</html>
