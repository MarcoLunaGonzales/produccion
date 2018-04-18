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
<%@ page import="java.lang.Math" %>
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
<link rel="STYLESHEET" type="text/css" href="../../reponse/css/foundation.css" />
<link rel="STYLESHEET" type="text/css" href="../../reponse/css/AtlasWeb.css" />

<link rel="STYLESHEET" type="text/css" href="../../reponse/css/border-radius.css" />
<link rel="STYLESHEET" type="text/css" href="../../reponse/css/jscal2.css" />
<link rel="STYLESHEET" type="text/css" href="../../reponse/css/gold.css" />
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

</style>
<script type="text/javascript">
    var operariosRegistro="";
    var fechaNuevoRegistro="";
    
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
    
    function redondeo2decimales(numero)
    {
        var original=parseFloat(numero);
        var result=Math.round(original*100)/100 ;
        return result;
    }
    
    function guardarControlDosificado()
    {
        document.getElementById('formsuper').style.visibility='visible';
        document.getElementById('divImagen').style.visibility='visible';
        var codLote=document.getElementById('codLoteSeguimiento').value;
        var codProgramaProd=document.getElementById('codProgramaProd').value;
        var tablaControlDosificado=document.getElementById("dataControlDosificado");
        var dataControlDosificado=new Array();
        var cont=0;
        if(!admin)
        {
                for(var i=1;i<tablaControlDosificado.rows.length;i++)
                {
                    if(validarSeleccionRegistro(tablaControlDosificado.rows[i].cells[1].getElementsByTagName('select')[0])&&
                        validarRegistroEntero(tablaControlDosificado.rows[i].cells[2].getElementsByTagName('input')[0])&&
                        validarRegistroEntero(tablaControlDosificado.rows[i].cells[3].getElementsByTagName('input')[0])&&
                        validarRegistroEntero(tablaControlDosificado.rows[i].cells[4].getElementsByTagName('input')[0])&&
                        validarRegistroEntero(tablaControlDosificado.rows[i].cells[5].getElementsByTagName('input')[0])&&
                        validarFechaRegistro(tablaControlDosificado.rows[i].cells[6].getElementsByTagName('input')[0])&&
                        validarHoraRegistro(tablaControlDosificado.rows[i].cells[7].getElementsByTagName('input')[0])&&
                        validarHoraRegistro(tablaControlDosificado.rows[i].cells[8].getElementsByTagName('input')[0])&&
                        validarRegistrosHorasNoNegativas(tablaControlDosificado.rows[i].cells[7].getElementsByTagName('input')[0],tablaControlDosificado.rows[i].cells[8].getElementsByTagName('input')[0])
                        )
                    {
                        dataControlDosificado[dataControlDosificado.length]=tablaControlDosificado.rows[i].cells[1].getElementsByTagName('select')[0].value;
                        dataControlDosificado[dataControlDosificado.length]=tablaControlDosificado.rows[i].cells[2].getElementsByTagName('input')[0].value;
                        dataControlDosificado[dataControlDosificado.length]=tablaControlDosificado.rows[i].cells[3].getElementsByTagName('input')[0].value;
                        dataControlDosificado[dataControlDosificado.length]=tablaControlDosificado.rows[i].cells[4].getElementsByTagName('input')[0].value;
                        dataControlDosificado[dataControlDosificado.length]=tablaControlDosificado.rows[i].cells[5].getElementsByTagName('input')[0].value;
                        dataControlDosificado[dataControlDosificado.length]=tablaControlDosificado.rows[i].cells[6].getElementsByTagName('input')[0].value;
                        dataControlDosificado[dataControlDosificado.length]=tablaControlDosificado.rows[i].cells[7].getElementsByTagName('input')[0].value;
                        dataControlDosificado[dataControlDosificado.length]=tablaControlDosificado.rows[i].cells[8].getElementsByTagName('input')[0].value;
                        dataControlDosificado[dataControlDosificado.length]=parseFloat(tablaControlDosificado.rows[i].cells[9].getElementsByTagName('span')[0].innerHTML);
                    }
                    else
                    {
                        document.getElementById('formsuper').style.visibility='hidden';
                        document.getElementById('divImagen').style.visibility='hidden';
                        return false;
                    }
                }
        }
        ajax=nuevoAjax();
        var peticion="ajaxGuardarControlDosificado.jsf?codLote="+codLote+"&noCache="+ Math.random()+
            "&codFormulaMaestra="+document.getElementById("codFormulaMaestra").value+"&codCompProd="+document.getElementById("codCompProd").value+
            "&codTipoProgramaProd="+document.getElementById("codTipoProduccion").value+"&codSeguimiento="+document.getElementById("codSeguimiento").value+
            "&codActividadEnvasado="+document.getElementById("codActivadEnvasado").value+
            "&codProgProd="+codProgramaProd+"&dataControlDosificado="+dataControlDosificado+
            "&admin="+(admin?1:0)+"&codPersonalUsuario="+codPersonal+
            (admin?"&codPersonalSupervisor="+document.getElementById("codPersonalSupervisor").value+
            "&observacion="+encodeURIComponent(document.getElementById("observacion").value):"");
        ajax.open("GET",peticion,true);
        ajax.setRequestHeader('content-type', 'application/x-www-form-urlencoded;charset=UTF-8');
                 ajax.onreadystatechange=function(){
                    if (ajax.readyState==4) {
                        if(ajax.responseText==null || ajax.responseText=='')
                        {
                            alert('No se puede conectar con el servidor, verfique su conexión a internet');
                            if(confirm("Desea guardar la informacion localmente?\nLa informacion del lote no se perdera pero debe de subirla despues"))
                            {
                                sqlConnection.insertarRegistroAuxiliar(codProgramaProd,codLote,9,("../registroControlDosificado/"+peticion),function(){window.close();});
                            }
                            document.getElementById('formsuper').style.visibility='hidden';
                            document.getElementById('divImagen').style.visibility='hidden';
                            return false;
                        }
                        if(parseInt(ajax.responseText.split("\n").join(""))=='1')
                        {
                            alert('Se registro el control de dosificado');
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
    function calcularDiferenciaCD(celda)
    {
        
        var fecha1=celda.parentNode.parentNode.cells[6].getElementsByTagName('input')[0].value+' '+celda.parentNode.parentNode.cells[7].getElementsByTagName('input')[0].value;
        var fecha2=celda.parentNode.parentNode.cells[6].getElementsByTagName('input')[0].value+' '+celda.parentNode.parentNode.cells[8].getElementsByTagName('input')[0].value;
        celda.parentNode.parentNode.cells[9].getElementsByTagName('span')[0].innerHTML=getNumeroDehoras(fecha1,fecha2);
        return true;
    }
    var contRegistroNUevoDosificado=0;
    function nuevoRegistroControlDosificado(nombreTabla)
    {
           contRegistroNUevoDosificado++;
           var table = document.getElementById(nombreTabla);
           var rowCount = table.rows.length;

           var row = table.insertRow(rowCount);
           row.onclick=function(){seleccionarFila(this);};

           var cell0 = row.insertCell(0);
           cell0.className="tableCell";
           var element0 = document.createElement("span");
           element0.className='textHeaderClassBody';
           element0.innerHTML=rowCount;
           cell0.appendChild(element0);

           var cell1 = row.insertCell(1);
           cell1.className="tableCell";
           var element1 = document.createElement("select");
           element1.innerHTML=operariosRegistro;
           cell1.appendChild(element1);

           for(var i=0;i<4;i++)
           {
               var cellAdicionar = row.insertCell(i+2);
               cellAdicionar.className="tableCell";
               var elementAdd = document.createElement("input");
               elementAdd.onkeypress=function(){valNum(this);};
               elementAdd.type = "tel";
               elementAdd.value=0;
               elementAdd.style.width='6em';
               cellAdicionar.appendChild(elementAdd);
           }

           var cell2 = row.insertCell(6);
           cell2.className="tableCell";
           var element5 = document.createElement("input");
           element5.value=fechaNuevoRegistro;
           element5.type = "tel";
           element5.size=10;
           element5.id="fechaSegui"+table.rows.length;
           element5.onclick=function(){seleccionarDatePickerJs(this);};
           cell2.appendChild(element5);
           
           var cell7 = row.insertCell(7);
           cell7.className="tableCell";
           var element7 = document.createElement("input");
           element7.onclick=function(){seleccionarHora(this);}
           element7.onfocus=function(){calcularDiferenciaCD(this);};
           element7.onkeyup=function(){calcularDiferenciaCD(this);};
           element7.id="fechaInicio"+contRegistroNUevoDosificado;
           element7.type = "text";
           element7.style.width='6em';
           element7.value=getHoraActualString();
           cell7.appendChild(element7);

           var cell8 = row.insertCell(8);
           cell8.className="tableCell";
           var element8 = document.createElement("input");
           element8.id='fechaFinal'+contRegistroNUevoDosificado;
           element8.onclick=function(){seleccionarHora(this);}
           element8.onfocus=function(){calcularDiferenciaCD(this);};
           element8.onkeyup=function(){calcularDiferenciaCD(this);};
           element8.type = "text";
           element8.style.width='6em';
           element8.value=getHoraActualString();
           cell8.appendChild(element8);


           var cell9 = row.insertCell(9);
           cell9.className="tableCell";
           cell9.align='center';
           var element9 = document.createElement("span");
           element9.className='textHeaderClassBody';
           element9.style.fontWeight='normal';
           element9.innerHTML=0;
           cell9.appendChild(element9);

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
        Date fechaCierre=new Date();
        String codLote=request.getParameter("codLote");
        out.println("<title>("+codLote+")CONTROL DOSIFICADO</title>");
        String codprogramaProd=request.getParameter("cod_prog");
        String codForma="";
        NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
        DecimalFormat format = (DecimalFormat)nf;
        SimpleDateFormat sdfDias=new SimpleDateFormat("dd/MM/yyyy");
        SimpleDateFormat sdfHora=new SimpleDateFormat("HH:mm");
        format.applyPattern("#,##0.00");
        int codActivadEnvasado=0;
        int codSeguimientoControlDosificado=0;
        int codPersonalSupervisor=0;
        String observaciones="";
        int codCompProd=0;
        int codFormulaMaestra=0;
        int codTipoProduccion=0;
        out.println("<script>sqlConnection.verificarRegistroPendiente('"+codprogramaProd+"','"+codLote+"',9)</script>");
                try
                {
                    Connection con=null;
                    con=Util.openConnection(con);
                    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    String consulta="select pp.COD_TIPO_PROGRAMA_PROD, pp.COD_COMPPROD,cp.COD_FORMA,p.nombre_prod,f.abreviatura_forma,cp.nombre_prod_semiterminado,"+
                                    " cp.NOMBRE_GENERICO,f.nombre_forma,cp.REG_SANITARIO,ep.nombre_envaseprim,cp.VIDA_UTIL,"+
                                    " pp.CANT_LOTE_PRODUCCION,ppp.FECHA_FINAL,pp.COD_FORMULA_MAESTRA,ISNULL(cp.VOLUMEN_ENVASE_PRIMARIO, '') as VOLUMEN_ENVASE_PRIMARIO"+
                                    " ,isnull(scdl.COD_SEGUIMIENTO_CONTROL_DOSIFICADO_LOTE,0) as COD_SEGUIMIENTO_CONTROL_DOSIFICADO_LOTE,"+
                                    " isnull(scdl.COD_PERSONAL_SUPERVISOR,0) as COD_PERSONAL_SUPERVISOR,isnull(scdl.OBSERVACION,'') as OBSERVACION,"+
                                    " isnull(afm.COD_ACTIVIDAD_FORMULA,0) as codActividadFormula" +
                                    " ,isnull(scdl.COD_ESTADO_HOJA,0) as COD_ESTADO_HOJA,scdl.FECHA_CIERRE"+
                                    " ,isnull(conjunta.loteAsociado,'') as loteAsociado,isnull(conjunta.cantAsociado,0) as cantAsociado" +
                                    " from PROGRAMA_PRODUCCION pp inner join COMPONENTES_PROD cp on cp.COD_COMPPROD = pp.COD_COMPPROD"+
                                    " inner join FORMAS_FARMACEUTICAS f on f.cod_forma = cp.COD_FORMA"+
                                    " inner join productos p on p.cod_prod = cp.COD_PROD"+
                                    " inner join PRESENTACIONES_PRIMARIAS ppm on ppm.COD_COMPPROD ="+
                                    " cp.COD_COMPPROD and ppm.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD"+
                                    " inner join ENVASES_PRIMARIOS ep on ep.cod_envaseprim = ppm.COD_ENVASEPRIM"+
                                    " inner join PROGRAMA_PRODUCCION_PERIODO ppp on pp.COD_PROGRAMA_PROD = ppp.COD_PROGRAMA_PROD"+
                                    " left outer join SEGUIMIENTO_CONTROL_DOSIFICADO_LOTE scdl on"+
                                    " scdl.COD_LOTE = pp.COD_LOTE_PRODUCCION and scdl.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD"+
                                    " left outer join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_AREA_EMPRESA ="+
                                    " 96 and afm.COD_ACTIVIDAD =29 and afm.COD_FORMULA_MAESTRA =pp.COD_FORMULA_MAESTRA" +
                                    " and afm.COD_PRESENTACION=0"+
                                    " outer APPLY(select top 1 ppc.COD_LOTE_PRODUCCION as loteAsociado,ppc.CANT_LOTE_PRODUCCION as cantAsociado"+
                                    " from LOTES_PRODUCCION_CONJUNTA lpc inner join PROGRAMA_PRODUCCION ppc on"+
                                    " lpc.COD_PROGRAMA_PROD=ppc.COD_PROGRAMA_PROD and lpc.COD_LOTE_PRODUCCION_ASOCIADO=ppc.COD_LOTE_PRODUCCION"+
                                    " where lpc.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD and lpc.COD_LOTE_PRODUCCION=pp.COD_LOTE_PRODUCCION) conjunta"+
                                    " where pp.COD_LOTE_PRODUCCION = '"+codLote+"' and pp.COD_PROGRAMA_PROD = '"+codprogramaProd+"'";
                    System.out.println("consulta cargar datos del lote "+consulta);
                    ResultSet res=st.executeQuery(consulta);
                    int cantidadAmpollas=0;
                    String nombreProducto="";
                    String registroSanitario="";
                    String volumen="";
                    char b=13;char c=10;
                    if(res.next())
                    {
                        fechaCierre=(res.getTimestamp("FECHA_CIERRE")!=null?res.getTimestamp("FECHA_CIERRE"):new Date());
                        codEstadoHoja=res.getInt("COD_ESTADO_HOJA");
                        codCompProd=res.getInt("COD_COMPPROD");
                        codTipoProduccion=res.getInt("COD_TIPO_PROGRAMA_PROD");
                        codSeguimientoControlDosificado=res.getInt("COD_SEGUIMIENTO_CONTROL_DOSIFICADO_LOTE");
                        observaciones=res.getString("OBSERVACION");
                        codPersonalSupervisor=res.getInt("COD_PERSONAL_SUPERVISOR");
                        codActivadEnvasado=res.getInt("codActividadFormula");
                        if(codActivadEnvasado==0)
                        {
                            out.println("<script>alert('No se encuentra asociada la actividad de envasado');window.close();</script>");
                        }
                        System.out.println("cod actividad envasado "+codActivadEnvasado);
                        codFormulaMaestra=res.getInt("COD_FORMULA_MAESTRA");
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
                                                       <label  class="inline">CONTROL DE DOSIFICADO</label>
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
                                   <label  class="inline">CONTROL DE DOSIFICADO</label>
                            </div>
                        </div>
                        <div class="row" >

                        <div  class="divContentClass large-12 medium-12 small-12 columns" style="padding-top:12px;">
                       
                              <%
                              }
                                consulta="select p.COD_PERSONAL,(p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL+' '+p.nombre2_personal) as nombrePersonal"+
                                                 " from personal p where p.COD_ESTADO_PERSONA=1  and p.cod_area_empresa in (81,41,35,38,77)"+
                                                 (administrador?"":"and p.COD_PERSONAL='"+codPersonal+"'")+
                                                 " order by p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRES_PERSONAL,p.nombre2_personal";
                                        res=st.executeQuery(consulta);
                                        int sumaCantidad=0;
                                        String  personal=UtilidadesTablet.operariosAreaProduccionAdminSelect(st, "81", codPersonal, administrador);
                                out.println("<script>operariosRegistro=\""+personal+"\";fechaNuevoRegistro='"+sdfDias.format(new Date())+"'</script>");
                               
                                      %>
                       
                        <div class="row">
                            <div class="large-12 medium-12 small-12 large-centered medium-centered small-centered columns">
                                <table style="border:none;width:100%;margin-top:4px;" id="dataControlDosificado" cellpadding="0px" cellspacing="0px">
                                <tr>
                                    <td class='tableHeaderClass' style='text-align:center;width:2.6em' ><span class='textHeaderClass' >N°</span></td>
                                    <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>Operario<br>Envasador</span></td>
                                    <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>N° Frascos<br> Envasados</span></td>
                                    <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>N° Frascos<br>para C.C.</span></td>
                                    <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>N° Frascos<br> FRV</span></td>
                                    <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>N° Frascos<br>faltantes</span></td>
                                    <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>Fecha</span></td>
                                    <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>Hora<br>Inicio</span></td>
                                    <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>Hora<br>Final</span></td>
                                    <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>Horas<br>Hombre</span></td>
                                </tr>
                                                 
                              <%
                              
                                consulta="SELECT srdlp.CANT_AMPOLLAS_ACOND,srdlp.CANT_AMPOLLAS_CARBONES,srdlp.CANT_AMPOLLAS_CC,srdlp.CANT_AMPOLLAS_ROTAS,srdlp.CANT_AMPOLLAS_FALTANTES,"+
                                          " srdlp.COD_REGISTRO_ORDEN_MANUFACTURA,isnull(srdlp.COD_PERSONAL, sppp.COD_PERSONAL) as COD_PERSONAL,"+
                                          " sppp.FECHA_INICIO,sppp.FECHA_FINAL,sppp.HORAS_HOMBRE"+
                                          " FROM SEGUIMIENTO_CONTROL_DOSIFICADO_LOTE_PERSONAL srdlp"+
                                          " full outer join SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sppp on"+
                                          " srdlp.COD_PERSONAL = sppp.COD_PERSONAL and"+
                                          " srdlp.COD_REGISTRO_ORDEN_MANUFACTURA = sppp.COD_REGISTRO_ORDEN_MANUFACTURA"+
                                          " where (sppp.COD_LOTE_PRODUCCION = '"+codLote+"' and sppp.COD_PROGRAMA_PROD = '"+codprogramaProd+"' and"+
                                          " sppp.COD_FORMULA_MAESTRA = '"+codFormulaMaestra+"' and sppp.COD_ACTIVIDAD_PROGRAMA = '"+codActivadEnvasado+"' and"+
                                          " sppp.COD_TIPO_PROGRAMA_PROD = '"+codTipoProduccion+"' and srdlp.COD_SEGUIMIENTO_CONTROL_DOSIFICADO_LOTE is null" +
                                          (administrador?"":" and sppp.COD_PERSONAL='"+codPersonal+"'")+") or"+
                                          " (srdlp.COD_SEGUIMIENTO_CONTROL_DOSIFICADO_LOTE = '"+codSeguimientoControlDosificado+"' and sppp.COD_LOTE_PRODUCCION is NULL" +
                                          (administrador?"":" and srdlp.COD_PERSONAL='"+codPersonal+"'")+") or"+
                                          " (sppp.COD_LOTE_PRODUCCION = '"+codLote+"' and sppp.COD_PROGRAMA_PROD = '"+codprogramaProd+"' and"+
                                          " sppp.COD_FORMULA_MAESTRA = '"+codFormulaMaestra+"' and sppp.COD_ACTIVIDAD_PROGRAMA = '"+codActivadEnvasado+"' and"+
                                          " sppp.COD_TIPO_PROGRAMA_PROD = '"+codTipoProduccion+"' and srdlp.COD_SEGUIMIENTO_CONTROL_DOSIFICADO_LOTE ='"+codSeguimientoControlDosificado+"'" +
                                          (administrador?"":" and sppp.COD_PERSONAL='"+codPersonal+"'")+")"+
                                          " order by srdlp.COD_REGISTRO_ORDEN_MANUFACTURA";
                                System.out.println("consulta cargar seguimiento "+consulta);
                                res=st.executeQuery(consulta);
                                while(res.next())
                                {
                                    out.println("<tr onclick='seleccionarFila(this);' ><td class='tableCell' style='text-align:center'><span class='textHeaderClassBody' >"+res.getRow()+"</span></td>"+
                                                " <td class='tableCell' style='text-align:left'>" +
                                                "<select "+(administrador?"disabled":"")+" id='codPersonal"+res.getRow()+"'>"+personal+"</select><script>codPersonal"+res.getRow()+".value='"+res.getString("COD_PERSONAL")+"'</script>" +
                                                "</td>" +
                                                " <td class='tableCell' style='text-align:left'><input "+(administrador?"disabled":"")+" type='tel' style='width:6em' value='"+res.getInt("CANT_AMPOLLAS_ACOND")+"'></td>" +
                                                " <td class='tableCell' style='text-align:left'><input "+(administrador?"disabled":"")+" type='tel' style='width:6em' value='"+res.getInt("CANT_AMPOLLAS_CC")+"'></td>" +
                                                " <td class='tableCell' style='text-align:left'><input "+(administrador?"disabled":"")+" type='tel' style='width:6em' value='"+res.getInt("CANT_AMPOLLAS_ROTAS")+"'></td>" +
                                                " <td class='tableCell' style='text-align:left'><input "+(administrador?"disabled":"")+" type='tel' style='width:6em' value='"+res.getInt("CANT_AMPOLLAS_FALTANTES")+"'></td>" +
                                                " <td class='tableCell' style='text-align:left'><input "+(administrador?"disabled":"")+" type='tel' id='fechap"+res.getRow()+"' onclick='seleccionarDatePickerJs(this)' value='"+sdfDias.format(res.getTimestamp("FECHA_INICIO"))+"'></td>" +
                                                " <td class='tableCell' style='text-align:left'><input "+(administrador?"disabled":"")+" onclick='seleccionarHora(this);' onkeyup='calcularDiferenciaCD(this);' onfocus='calcularDiferenciaCD(this);' id='fechaIni"+res.getRow()+"' type='text' style='width:6em' value='"+sdfHora.format(res.getTimestamp("FECHA_INICIO"))+"'></td>" +
                                                " <td class='tableCell' style='text-align:left'><input "+(administrador?"disabled":"")+" onclick='seleccionarHora(this);' onkeyup='calcularDiferenciaCD(this);' onfocus='calcularDiferenciaCD(this);' id='fechaFin"+res.getRow()+"' type='text' style='width:6em' value='"+sdfHora.format(res.getTimestamp("FECHA_FINAL"))+"'></td>" +
                                                " <td class='tableCell' style='text-align:center;' align='center'><span class='textHeaderClassBody' style='font-weight:normal' >"+res.getDouble("HORAS_HOMBRE")+"</span></td>"+
                                                "</tr>");
                                }
                              %>
                              </table>
                              <div class="row">
                                  <div class="large-5 medium-5 small-4 columns" style="">&nbsp;</div>
                                      <div class="large-1 medium-1 small-2 columns">
                                            <button <%=(administrador?"disabled":"")%> class="small button succes radius buttonAction" onclick="nuevoRegistroControlDosificado('dataControlDosificado')">+</button>
                                      </div>
                                      <div class="large-1 medium-1 small-2 columns">
                                            <button <%=(administrador?"disabled":"")%> class="small button succes radius buttonAction" onclick="eliminarRegistroTabla('dataControlDosificado');">-</button>
                                      </div>
                                      <div class="large-5 medium-5 small-4 columns" style="">&nbsp;</div>
                              </div>
                              
                             
                            </div>
                        </div>
                        <center>
                        <input type="hidden" value="<%=(codPersonalSupervisor)%>" id="cerrado"/>
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
                                        <button class="small button succes radius buttonAction" onclick="guardarControlDosificado();" >Guardar</button>
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
        <input type="hidden" id="codActivadEnvasado" value="<%=(codActivadEnvasado)%>">
        <input type="hidden" id="codLoteSeguimiento" value="<%=codLote%>">
        <input type="hidden" id="codProgramaProd" value="<%=codprogramaProd%>">
        <input type="hidden" id="codSeguimiento" value="<%=(codSeguimientoControlDosificado)%>">
        <input type="hidden" id="codFormulaMaestra" value="<%=(codFormulaMaestra)%>"/>
        <input type="hidden" id="codCompProd" value="<%=(codCompProd)%>"/>
        <input type="hidden" id="codTipoProduccion" value="<%=(codTipoProduccion)%>"/>

        </section>
    </body>
    <script src="../../reponse/js/timePickerJs.js"></script>
    <script src="../../reponse/js/dataPickerJs.js"></script>
    <script>iniciarDatePicker('<%=(sdfDias.format(new Date()))%>');loginHoja.verificarHojaCerrada('cerrado', admin,'codProgramaProd','codLoteSeguimiento',8,<%=(codEstadoHoja)%>);</script>
</html>
