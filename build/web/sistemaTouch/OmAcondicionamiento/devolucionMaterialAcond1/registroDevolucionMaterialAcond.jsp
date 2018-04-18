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
    var contRegistroAmpollas=0;

    function guardarLavadoAmpollasDosificado()
    {
        document.getElementById('formsuper').style.visibility='visible';
        document.getElementById('divImagen').style.visibility='visible';
        var codLote=document.getElementById('codLoteSeguimiento').value;
        var ampollasSeguimiento=document.getElementById("dataSeguimientoLavado");
        var dataAmpollasSeguimineto=new Array();
        var cont=0;
        var fechaInicioActividad=null;
        var fechaFinalActividad=null;
        var horasHombreActividad=0;
        for(var k=1;k<ampollasSeguimiento.rows.length;k++)
         {
             if(validarRegistroEntero(ampollasSeguimiento.rows[k].cells[1].getElementsByTagName('input')[0])&&
                validarRegistroEntero(ampollasSeguimiento.rows[k].cells[2].getElementsByTagName('input')[0])&&
                validarFechaRegistro(ampollasSeguimiento.rows[k].cells[3].getElementsByTagName('input')[0])&&
                validarSeleccionRegistro(ampollasSeguimiento.rows[k].cells[0].getElementsByTagName('select')[0])&&
                validarHoraRegistro(ampollasSeguimiento.rows[k].cells[4].getElementsByTagName('input')[0])&&
                validarHoraRegistro(ampollasSeguimiento.rows[k].cells[5].getElementsByTagName('input')[0])&&
                validarRegistrosHorasNoNegativas(ampollasSeguimiento.rows[k].cells[4].getElementsByTagName('input')[0],ampollasSeguimiento.rows[k].cells[5].getElementsByTagName('input')[0]))
               {
                     dataAmpollasSeguimineto[cont]=ampollasSeguimiento.rows[k].cells[0].getElementsByTagName('select')[0].value;
                     cont++;
                     dataAmpollasSeguimineto[cont]=ampollasSeguimiento.rows[k].cells[1].getElementsByTagName('input')[0].value;
                     cont++;
                     dataAmpollasSeguimineto[cont]=ampollasSeguimiento.rows[k].cells[2].getElementsByTagName('input')[0].value;
                     cont++;
                     dataAmpollasSeguimineto[cont]=ampollasSeguimiento.rows[k].cells[3].getElementsByTagName('input')[0].value;
                     cont++;
                     dataAmpollasSeguimineto[cont]=ampollasSeguimiento.rows[k].cells[4].getElementsByTagName('input')[0].value;
                     cont++;
                     dataAmpollasSeguimineto[cont]=ampollasSeguimiento.rows[k].cells[5].getElementsByTagName('input')[0].value;
                     cont++;
                     var aux=dataAmpollasSeguimineto[cont-3].split("/");
                     var auxini=dataAmpollasSeguimineto[cont-2].split(":");
                     var auxend=dataAmpollasSeguimineto[cont-1].split(":");
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
                    dataAmpollasSeguimineto[cont]=ampollasSeguimiento.rows[k].cells[6].getElementsByTagName('span')[0].innerHTML;
                    
                    horasHombreActividad+=parseFloat(dataAmpollasSeguimineto[cont]);
                    cont++;
                }
                else
                {
                    document.getElementById('formsuper').style.visibility='hidden';
                    document.getElementById('divImagen').style.visibility='hidden';
                    return false;
                }
         }
         alert(dataAmpollasSeguimineto);
         ajax=nuevoAjax();
         var peticion="ajaxGuardarAmpollasLavadoDosificadoAcond.jsf?codLote="+codLote+"&noCache="+ Math.random()+"&date="+(new Date().getTime()).toString()+
             "&codprogramaProd="+document.getElementById("codprogramaProd").value+"&codSeguimientoLavado="+document.getElementById("codSeguimientoLavado").value+
             "&codFormulaMaestra="+document.getElementById("codFormulaMaestra").value+"&codTipoProgramaProd="+document.getElementById("codTipoProgramaProd").value+
             "&codCompProd="+document.getElementById("codCompProd").value+"&codActividadLavadoAmpollas="+document.getElementById("codActividadLavadoAmpollas").value+
             "&dataAmpollasAcond="+dataAmpollasSeguimineto+
             "&fechaInicio="+transformDate(fechaInicioActividad)+
             "&fechaFinal="+transformDate(fechaFinalActividad)+
             "&horasHombre="+horasHombreActividad+
             "&admin="+(admin?1:0)+
             "&codPersonalUsuario="+codPersonal+
             (admin?"&observacion="+document.getElementById("observacion").value:"");

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


    function nuevoRegistro(nombreTabla)
   {
       contRegistroAmpollas++;
       
       var table = document.getElementById(nombreTabla);
       var rowCount = table.rows.length;
       var row = table.insertRow(rowCount);
       row.onclick=function(){seleccionarFila(this);};


       var cell4 = row.insertCell(0);
       cell4.className="tableCell";
       var element4 = document.createElement("select");
       element4.innerHTML=operariosRegistro;
       cell4.appendChild(element4);
       
       
       var cellCantidad = row.insertCell(1);
       cellCantidad.className="tableCell";
       cellCantidad.align="center";
       var elementCantidad = document.createElement("input");
       elementCantidad.type = "tel";
       elementCantidad.value=0;
       elementCantidad.style.width='6em';
       cellCantidad.appendChild(elementCantidad);


       var cellrotas = row.insertCell(2);
       cellrotas.className="tableCell";
       cellrotas.className="tableCell";
       var elementrotas = document.createElement("input");
       elementrotas.type = "tel";
       elementrotas.value=0;
       elementrotas.style.width='6em';
       cellrotas.appendChild(elementrotas);
       
       var cell5 = row.insertCell(3);
       cell5.className="tableCell";
       cell5.align="center";
       var element5 = document.createElement("input");
       element5.type = "text";
       element5.size=10;
       element5.value=fechaSistemaLavado;
       element5.id="fechaSegui"+contRegistroAmpollas;
       cell5.appendChild(element5);
       Calendar.setup({trigger    : "fechaSegui"+contRegistroAmpollas,
       inputField :"fechaSegui"+contRegistroAmpollas,onSelect   : function() { this.hide() }});

       var cell6 = row.insertCell(4);
       cell6.className="tableCell";
       cell6.align="center";
       var element6 = document.createElement("input");
       element6.type = "text";
       element6.onclick=function(){seleccionarHora(this);};
       element6.onfocus=function(){calcularDiferenciaCD(this)};
       element6.onkeyup=function(){calcularDiferenciaCD(this)};
       element6.id='fechaIniNuevo'+contRegistroAmpollas;
       element6.style.width='6em';
       element6.value='';
       cell6.appendChild(element6);

       var cell7 = row.insertCell(5);
       cell7.className="tableCell";
       cell7.align="center";
       var element7 = document.createElement("input");
       element7.id='fechaFinNuevo'+contRegistroAmpollas;
       element7.onclick=function(){seleccionarHora(this);};
       element7.onfocus=function(){calcularDiferenciaCD(this)};
       element7.onkeyup=function(){calcularDiferenciaCD(this)};
       element7.type = "text";
       element7.style.width='6em';
       element7.value='';
       cell7.appendChild(element7);
        var cell9 = row.insertCell(6);
           cell9.className="tableCell";
           cell9.align='center';
           var element9 = document.createElement("span");
           element9.className='textHeaderClassBody';
           element9.style.fontWeight='normal';
           element9.innerHTML=0;
           cell9.appendChild(element9);
  }


  function calcularDiferenciaCD(celda)
    {

        var fecha1=celda.parentNode.parentNode.cells[3].getElementsByTagName('input')[0].value+' '+celda.parentNode.parentNode.cells[4].getElementsByTagName('input')[0].value;
        var fecha2=celda.parentNode.parentNode.cells[3].getElementsByTagName('input')[0].value+' '+celda.parentNode.parentNode.cells[5].getElementsByTagName('input')[0].value;
        celda.parentNode.parentNode.cells[6].getElementsByTagName('span')[0].innerHTML=getNumeroDehoras(fecha1,fecha2);
        return true;
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
        boolean administrador=(Integer.valueOf(request.getParameter("admin"))>0);
        out.println("<script type='text/javascript'>codPersonal="+codPersonal+";" +
                   "admin="+administrador+";</script>");
        int codEstadoHoja=0;
        String codLote=request.getParameter("codLote");
        out.println("<title>("+codLote+")DEVOLUCION DE MATERIAL DE ACONDICIONAMIENTO</title>");
        String codprogramaProd=request.getParameter("cod_prog");
        String codForma="";
        String personal="";
        int codFormulaMaestra=0;
        int codPersonalCierre=0;
        int codCompProd=0;
        String observaciones="";
        Date fechaCierre=new Date();
        char b=13;char c=10;
        int codTipoProgramaProd=0;
        //formato numero
        NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
        DecimalFormat format = (DecimalFormat)nf;
        format.applyPattern("#,##0.00");
        SimpleDateFormat sdfHora=new SimpleDateFormat("HH:mm");
        SimpleDateFormat sdfDias=new SimpleDateFormat("dd/MM/yyyy");
        //out.println("<script>sqlConnection.verificarRegistroPendiente('"+codprogramaProd+"','"+codLote+"',3)</script>");
        //datos propios de la hoja
        int codActividadLavadoAmpolla=0;
        String indicacionesDevolucionMaterial="";
        int codSeguimientoLavadoAcond=0;
        try
        {
              Connection con=null;
              con=Util.openConnection(con);
              Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
              String consulta="select pp.cod_tipo_programa_prod,pp.cod_formula_maestra,cp.cod_Area_empresa,cp.COD_FORMA,cp.COD_COMPPROD,"+
                                " p.nombre_prod,f.abreviatura_forma,cp.nombre_prod_semiterminado,cp.NOMBRE_GENERICO,f.nombre_forma,"+
                                " cp.REG_SANITARIO,ep.nombre_envaseprim,cp.VIDA_UTIL,pp.CANT_LOTE_PRODUCCION,ppp.FECHA_FINAL"+
                                " ,isnull(dpff.ACOND_INDICACIONES_DEVOLUCION_MATERIAL,'') as ACOND_INDICACIONES_DEVOLUCION_MATERIAL"+
                                " ,isnull(afm.COD_ACTIVIDAD_FORMULA,0) as actividadLavadoAmpollasACD" +
                                " ,isnull(sll.COD_SEGUIMIENTO_LAVADO_LOTE_ACOND,0) AS COD_SEGUIMIENTO_LAVADO_LOTE_ACOND,"+
                                " ISNULL(sll.COD_PERSONAL_SUPERVISOR,0) AS COD_PERSONAL_SUPERVISOR,ISNULL(sll.OBSERVACIONES,'') AS  OBSERVACIONES,sll.FECHA_CIERRE"+
                                " from PROGRAMA_PRODUCCION pp inner join COMPONENTES_PROD cp on cp.COD_COMPPROD = pp.COD_COMPPROD"+
                                " inner join FORMAS_FARMACEUTICAS f on f.cod_forma = cp.COD_FORMA"+
                                " inner join productos p on p.cod_prod = cp.COD_PROD"+
                                " inner join PRESENTACIONES_PRIMARIAS ppm on ppm.COD_COMPPROD =cp.COD_COMPPROD and ppm.COD_TIPO_PROGRAMA_PROD = pp.COD_TIPO_PROGRAMA_PROD"+
                                " inner join ENVASES_PRIMARIOS ep on ep.cod_envaseprim = ppm.COD_ENVASEPRIM"+
                                " inner join PROGRAMA_PRODUCCION_PERIODO ppp on pp.COD_PROGRAMA_PROD =ppp.COD_PROGRAMA_PROD"+
                                " left outer join DESCRIPCION_PROCESOS_FORMA_FARMACEUTICA dpff on dpff.COD_FORMA = cp.COD_FORMA"+
                                " left outer join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_AREA_EMPRESA =84"+
                                " and afm.COD_ACTIVIDAD = 110 and afm.COD_FORMULA_MAESTRA =pp.COD_FORMULA_MAESTRA and afm.COD_PRESENTACION = 0" +
                                " LEFT OUTER JOIN SEGUIMIENTO_LAVADO_LOTE_ACOND sll on sll.cod_lote=pp.COD_LOTE_PRODUCCION"+
                                " and sll.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD"+
                                " where pp.COD_LOTE_PRODUCCION = '"+codLote+"' and pp.cod_programa_prod = '"+codprogramaProd+"'";
                System.out.println("consulta cargar datos del lote "+consulta);
                ResultSet res=st.executeQuery(consulta);
                    
                    if(res.next())
                    {
                        fechaCierre=(res.getTimestamp("FECHA_CIERRE")!=null?res.getTimestamp("FECHA_CIERRE"):new Date());
                        codPersonalCierre=res.getInt("COD_PERSONAL_SUPERVISOR");
                        observaciones=res.getString("OBSERVACIONES");
                        codSeguimientoLavadoAcond=res.getInt("COD_SEGUIMIENTO_LAVADO_LOTE_ACOND");
                        codCompProd=res.getInt("COD_COMPPROD");
                        codTipoProgramaProd=res.getInt("cod_tipo_programa_prod");
                        codActividadLavadoAmpolla=res.getInt("actividadLavadoAmpollasACD");
                        indicacionesDevolucionMaterial=res.getString("ACOND_INDICACIONES_DEVOLUCION_MATERIAL").replace(b,'\n').replace("\n", "</br>").replace("</br></br>","<br>");
                        codFormulaMaestra=res.getInt("cod_formula_maestra");
                        if(codActividadLavadoAmpolla==0)
                        {
                         //   out.println("<script type='text/javascript'>alert('No se encuentran asociada la actividad:LAVADO DE AMPOLLAS ACD');window.close();</script>");
                        }
                        
                        %>

<section class="main">
                         <div class="row"  style="margin-top:5px" >
                                <div class="large-12 medium-12 small-12 large-centered medium-centered small-centered columns" >

                                            <div class="row">
                                               <div class="large-12 medium-12 small-12 columns divHeaderClass" >
                                                       <label  class="inline">DEVOLUCION DE MATERIAL DE ACONDICIONAMIENTO</label>
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
                                                               <span class="textHeaderClassBody"><%=codLote%></span>
                                                           </td>
                                                           <td class="tableCell" style="text-align:center;">
                                                               <span class="textHeaderClassBody"><%=(res.getInt("CANT_LOTE_PRODUCCION"))%></span>
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

                              <%
                              }
                              %>


<div class="row"  style="margin-top:5px" >
            <div class="large-12 medium-12 small-12 large-centered medium-centered small-centered columns" >

                        <div class="row">
                           <div class="large-12 medium-12 small-12 columns divHeaderClass" >
                                   <label  class="inline">DEVOLUCION DE MATERIAL DE ACONDICIONAMIENTO</label>
                            </div>
                        </div>
                        <div class="row" >

                        <div  class="divContentClass large-12 medium-12 small-12 columns" style="padding-top:1em;">
                
                        <span ><%=(indicacionesDevolucionMaterial)%></span>
                        
                         <%
                         consulta="select P.COD_PERSONAL,(P.AP_PATERNO_PERSONAL + ' ' + P.AP_MATERNO_PERSONAL + ' ' +P.NOMBRES_PERSONAL + ' ' + P.nombre2_personal) NOMBRES_PERSONAL"+
                                 " from personal P inner join PERSONAL_AREA_PRODUCCION pa on pa.COD_PERSONAL = p.COD_PERSONAL"+
                                 " where pa.cod_area_empresa in (84,102) AND p.COD_ESTADO_PERSONA = 1 " +
                                 (administrador?"":" and p.cod_personal='"+codPersonal+"'")+
                                 " union select P.COD_PERSONAL,"+
                                 " (P.AP_PATERNO_PERSONAL + ' ' + P.AP_MATERNO_PERSONAL + ' ' +P.NOMBRES_PERSONAL + ' ' + P.nombre2_personal) NOMBRES_PERSONAL"+
                                 " from personal p where p.cod_area_empresa in (84,102) and p.COD_ESTADO_PERSONA = 1"+
                                 (administrador?"":" and p.cod_personal='"+codPersonal+"'")+
                                 " GROUP BY P.COD_PERSONAL,P.AP_MATERNO_PERSONAL,P.AP_PATERNO_PERSONAL,P.NOMBRES_PERSONAL,P.nombre2_personal"+
                                 " order by NOMBRES_PERSONAL ";
                                 System.out.println("consulta personal "+consulta);
                                 res=st.executeQuery(consulta);
                                 while(res.next())
                                 {
                                        personal+="<option value='"+res.getString("COD_PERSONAL")+"'>"+res.getString("NOMBRES_PERSONAL")+"</option>";
                                 }
                                 out.println("<script type='text/javascript'>operariosRegistro=\""+personal+"\";</script>");
                        
                        
                        %>
                        
                    <center>
                         <div class="row" style="margin-top:1em;">
                            <div class="large-12 medium-12 small-12 large-centered medium-centered small-centered columns">
                                <table style="border:none;width:100%;margin-top:4px;" id="dataSeguimientoLavado" cellpadding="0px" cellspacing="0px">
                                        <tr>
                                            <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>N°</span></td>
                                            <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>DESCRIPCION</span></td>
                                            <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>CANTIDAD<br>DEVUELTA</span></td>
                                            <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>CANTIDAD<br>FRV</span></td>
                                        </tr>
                                        <%
                                        consulta="select m.NOMBRE_MATERIAL,sum(sdd.CANTIDAD_DEVUELTA)as cantidadDevuelta,"+
                                                 " sum(sdd.CANTIDAD_DEVUELTA_FALLADOS) as cantidadFRV"+
                                                 " from SOLICITUD_DEVOLUCIONES sd inner join SALIDAS_ALMACEN sa "+
                                                 " on sd.COD_SALIDA_ALMACEN=sa.COD_SALIDA_ALMACEN"+
                                                 " inner join SOLICITUD_DEVOLUCIONES_DETALLE sdd on"+
                                                 " sd.COD_SOLICITUD_DEVOLUCION=sdd.COD_SOLICITUD_DEVOLUCION"+
                                                 " inner join MATERIALES m on m.COD_MATERIAL=sdd.COD_MATERIAL"+
                                                 " where sa.COD_ALMACEN=2 and sa.COD_LOTE_PRODUCCION='"+codLote+"'"+
                                                 " and sa.COD_ESTADO_SALIDA_ALMACEN<>2" +
                                                 " group by m.NOMBRE_MATERIAL"+
                                                 " order by m.NOMBRE_MATERIAL";
                                        System.out.println("consulta cargar seguimiento ampollas "+consulta);
                                        res=st.executeQuery(consulta);
                                        while(res.next())
                                        {
                                            %>
                                            <tr >
                                                <td class="tableCell" style="text-align:center;" align="center">
                                                    <span class="tableHeaderClassBody"><%=(res.getRow())%></span>
                                                </td>
                                                <td class="tableCell" style="text-align:center;" align="center">
                                                    <span class="tableHeaderClassBody"><%=(res.getString("NOMBRE_MATERIAL"))%></span>
                                                </td>
                                                <td class="tableCell" style="text-align:center;" align="center">
                                                    <span class="tableHeaderClassBody"><%=(nf.format(res.getDouble("cantidadDevuelta")))%></span>
                                                </td>
                                                 <td class="tableCell" style="text-align:center;" align="center">
                                                    <span class="tableHeaderClassBody"><%=(nf.format(res.getDouble("cantidadFRV")))%></span>
                                                </td>
                                            </tr>
                                            <%
                                        }
                                        %>
                                </table>
                                
                            </div>
                         </div>
                         
                    <input type="hidden" value="<%=(codPersonalCierre)%>" id="cerrado"/>
                    <%
                    if(administrador)
                     {
                        consulta="select (p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL+' '+p.nombre2_personal) as nombrePersonal"+
                                 " from PERSONAL p where p.COD_PERSONAL='"+(codPersonalCierre>0?codPersonalCierre:codPersonal)+"'";
                        res=st.executeQuery(consulta);
                        String nombrePersonalAprueba="";
                        if(res.next())nombrePersonalAprueba=res.getString("nombrePersonal");
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
                                   <span class="textHeaderClassBody" style="font-weight:normal;"><%=(nombrePersonalAprueba)%></span>
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
                                    <input type="text" id="observacion" value="<%=(observaciones)%>"/>
                               </td>
                        </tr>
                    </table>
                    <%
                    }
                    %>
                    </center>
                    <%
                            consulta="select sd.FECHA_SOLICITUD,sd.OBSERVACION,"+
                                     " ( p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL) as nombrePersonal"+
                                     " from SOLICITUD_DEVOLUCIONES sd inner join SALIDAS_ALMACEN sa  "+
                                     " on sd.COD_SALIDA_ALMACEN=sa.COD_SALIDA_ALMACEN "+
                                     " inner join PERSONAL p on p.COD_PERSONAL=sd.COD_PERSONAL"+
                                     " where sa.COD_ALMACEN=2 and sa.COD_LOTE_PRODUCCION='"+codLote+"'"+
                                     " and sa.COD_ESTADO_SALIDA_ALMACEN<>2"+
                                     " order by sd.FECHA_SOLICITUD";
                            System.out.println("consulta detalle solicitud dev "+consulta);
                            res=st.executeQuery(consulta);
                            while(res.next())
                            {
                                %>
                                <span style="line-height:1.3em">Fecha Devolucion:&nbsp&nbsp&nbsp<%=(sdfDias.format(res.getTimestamp("FECHA_SOLICITUD")))%></span>
                                <br><span style="line-height:1.3em">Persona Devuelve:&nbsp&nbsp<%=(res.getString("nombrePersonal"))%></span>
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
                                <%--div class="large-6 medium-6 small-12 columns">
                                    <button class="small button succes radius buttonAction" onclick="guardarLavadoAmpollasDosificado();" >Guardar</button>
                                </div--%>
                                    <div class="large-6 medium-6 small-12 large-centered medium-centered small-centered columns">
                                        <button class="small button succes radius buttonAction" onclick="window.close();" >Aceptar</button>

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
        <input type="hidden" id="codLoteSeguimiento" value="<%=codLote%>"/>
        <input type="hidden" id="codprogramaProd" value="<%=(codprogramaProd)%>"/>
        <input type="hidden" id="codFormulaMaestra" value="<%=(codFormulaMaestra)%>"/>
        <input type="hidden" id="codTipoProgramaProd" value="<%=(codTipoProgramaProd)%>"/>
        <input type="hidden" id="codCompProd" value="<%=(codCompProd)%>"/>
        <input type="hidden" id="codActividadLavadoAmpollas" value="<%=(codActividadLavadoAmpolla)%>"/>
        <input  type="hidden" id="codSeguimientoLavado" value="<%=(codSeguimientoLavadoAcond)%>">
        </section>
    </body>
    <script src="../../reponse/js/timePickerJs.js"></script>
</html>
