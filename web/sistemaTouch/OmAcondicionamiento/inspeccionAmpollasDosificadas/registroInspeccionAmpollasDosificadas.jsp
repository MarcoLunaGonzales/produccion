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

<link rel="STYLESHEET" type="text/css" href="../../reponse/css/foundation.css" />
<link rel="STYLESHEET" type="text/css" href="../../reponse/css/AtlasWeb.css" />
<link rel="STYLESHEET" type="text/css" href="../../reponse/css/border-radius.css" />
<link rel="STYLESHEET" type="text/css" href="../../reponse/css/timePickerCSs.css" />
<link rel="STYLESHEET" type="text/css" href="../../reponse/css/mensajejs.css" />
<script src="../../reponse/js/utiles.js"></script>
<script src="../../reponse/js/componentesJs.js"></script>
<script src="../../reponse/js/validaciones.js"></script>
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
    
    var contRegistroTablas=0;
    var innerTablaInspeccion='';

    function guardarInspeccionAmpollasDosificado(aprobacionDepeje,codTipoGuardado)
    {
        iniciarProgresoSistema();
        var codLote=document.getElementById('codLoteSeguimiento').value;
        var ampollasSeguimiento=document.getElementById("dataAmpollasInspeccionadas");
        var dataDefectosEncontrados=new Array();
        var dataSeguimiento=new Array();
        for(var i=1;i<ampollasSeguimiento.rows.length;i++)
         {
             var tablaDefectos=ampollasSeguimiento.rows[i].cells[0].getElementsByTagName("table")[0];
             if(validarRegistroEntero(tablaDefectos.rows[tablaDefectos.rows.length-1].cells[4].getElementsByTagName('input')[0])&&
                validarFechaRegistro(tablaDefectos.rows[tablaDefectos.rows.length-1].cells[1].getElementsByTagName('input')[0])&&
                //validarSeleccionRegistro(tablaDefectos.rows[tablaDefectos.rows.length-1].cells[0].getElementsByTagName('select')[0])&&
                validarHoraRegistro(tablaDefectos.rows[tablaDefectos.rows.length-1].cells[2].getElementsByTagName('input')[0])&&
                validarHoraRegistro(tablaDefectos.rows[tablaDefectos.rows.length-1].cells[3].getElementsByTagName('input')[0])&&
                validarRegistrosHorasNoNegativas(tablaDefectos.rows[tablaDefectos.rows.length-1].cells[2].getElementsByTagName('input')[0],tablaDefectos.rows[tablaDefectos.rows.length-1].cells[3].getElementsByTagName('input')[0]))
               {
                     dataSeguimiento[dataSeguimiento.length]=i;
                     dataSeguimiento[dataSeguimiento.length]=tablaDefectos.rows[tablaDefectos.rows.length-1].cells[0].getElementsByTagName('select')[0].value;
                     dataSeguimiento[dataSeguimiento.length]=tablaDefectos.rows[tablaDefectos.rows.length-1].cells[1].getElementsByTagName('input')[0].value;
                     dataSeguimiento[dataSeguimiento.length]=tablaDefectos.rows[tablaDefectos.rows.length-1].cells[2].getElementsByTagName('input')[0].value;
                     dataSeguimiento[dataSeguimiento.length]=tablaDefectos.rows[tablaDefectos.rows.length-1].cells[3].getElementsByTagName('input')[0].value;
                     dataSeguimiento[dataSeguimiento.length]=tablaDefectos.rows[tablaDefectos.rows.length-1].cells[4].getElementsByTagName('input')[0].value;
                     dataSeguimiento[dataSeguimiento.length]=getNumeroDehoras((dataSeguimiento[dataSeguimiento.length-4]+' '+dataSeguimiento[dataSeguimiento.length-3]),
                     (dataSeguimiento[dataSeguimiento.length-4]+' '+dataSeguimiento[dataSeguimiento.length-2]));
                     for(var j=1;(j<tablaDefectos.rows.length-2);j++)
                     {
                         for(var k=1;(k<tablaDefectos.rows[0].cells.length-1);k++)
                         {
                            // console.log(tablaDefectos.rows[j].cells[k].getElementsByTagName("input")[0].value);
                             if(validarRegistroEntero(tablaDefectos.rows[j].cells[k].getElementsByTagName("input")[0]))
                             {
                                 if(parseInt(tablaDefectos.rows[j].cells[k].getElementsByTagName("input")[0].value)>0)
                                 {
                                     dataDefectosEncontrados[dataDefectosEncontrados.length]=tablaDefectos.rows[tablaDefectos.rows.length-1].cells[0].getElementsByTagName('select')[0].value;
                                     dataDefectosEncontrados[dataDefectosEncontrados.length]=tablaDefectos.rows[0].cells[k].getElementsByTagName('input')[0].value;
                                     dataDefectosEncontrados[dataDefectosEncontrados.length]=i;
                                     dataDefectosEncontrados[dataDefectosEncontrados.length]=tablaDefectos.rows[j].cells[0].getElementsByTagName("input")[0].value;
                                     dataDefectosEncontrados[dataDefectosEncontrados.length]=tablaDefectos.rows[j].cells[k].getElementsByTagName("input")[0].value;
                                 }
                             }
                             else
                             {
                                terminarProgresoSistema();
                                return false;
                             }
                             
                         }
                     }
                     
                }
                else
                {
                    terminarProgresoSistema();
                    return false;
                }
         }
         ajax=nuevoAjax();
         var peticion="ajaxGuardarInspeccionAmpollasDosificadas.jsf?"+
             "codLote="+codLoteGeneral+"&noCache="+ Math.random()+"&date="+(new Date().getTime()).toString()+
             "&codprogramaProd="+codProgramaProdGeneral+
             "&codFormulaMaestra="+codFormulaMaestraGeneral+
             "&codTipoProgramaProd="+codTipoProgramaProdGeneral+
             "&codCompProd="+codComprodGeneral+
             "&codActividadInspeccion="+document.getElementById("codActividadInspeccion").value+
             "&dataSeguimiento="+dataSeguimiento+
             "&dataDefectosEncontrados="+dataDefectosEncontrados+
             "&codTipoGuardado="+codTipoGuardado+
             "&codTipoPermiso="+(codTipoPermiso)+
             "&codPersonalUsuario="+codPersonalGeneral+
             (codTipoPermiso==12?"&observacion="+document.getElementById("observacion").value:"");

        ajax.open("GET",peticion,true);
        ajax.setRequestHeader('content-type', 'application/x-www-form-urlencoded;charset=UTF-8');
                 ajax.onreadystatechange=function(){
                    if (ajax.readyState==4) {
                        if(ajax.responseText==null || ajax.responseText=='')
                        {
                            alertJs('No se puede conectar con el servidor, verfique su conexión a internet');
                            if(confirm("Desea guardar la informacion localmente?\nLa informacion del lote no se perdera pero debe de subirla despues"))
                            {
                                sqlConnection.insertarRegistroAuxiliar(document.getElementById("codprogramaProd").value, codLote,3,("../registroEtapaLavado/"+peticion),function(){window.close();});
                            }
                            terminarProgresoSistema();
                            return false;
                        }
                        if(parseInt(ajax.responseText.split("\n").join(""))=='1')
                        {
                            terminarProgresoSistema();
                            mensajeJs('Se registro la etapa de inspeccion de ampollas',
                            function(){
                                    window.close();
                            });
                            
                            return true;
                        }
                        else
                        {
                            terminarProgresoSistema();
                            alertJs(ajax.responseText.split("\n").join(""));
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
       var table = document.getElementById(nombreTabla);
       var row = table.insertRow(table.rows.length);
       row.onclick=function(){seleccionarFila(this);};
       var aux=(innerTablaInspeccion.split("Indicador").join(contRegistroTablas));
       componentesJs.crearCelda(row).innerHTML=aux;
       
  }


  function calcularDiferenciaCD(celda)
    {

        var fecha1=celda.parentNode.parentNode.cells[3].getElementsByTagName('input')[0].value+' '+celda.parentNode.parentNode.cells[4].getElementsByTagName('input')[0].value;
        var fecha2=celda.parentNode.parentNode.cells[3].getElementsByTagName('input')[0].value+' '+celda.parentNode.parentNode.cells[5].getElementsByTagName('input')[0].value;
        celda.parentNode.parentNode.cells[6].getElementsByTagName('span')[0].innerHTML=getNumeroDehoras(fecha1,fecha2);
        return true;
    }
 function calcularSuma(celda)
 {
    var fila=celda.parentNode.parentNode;
    var suma=0;
    for(var i=1;i<(fila.cells.length-1);i++)
    {
        suma+=parseInt(fila.cells[i].getElementsByTagName("input")[0].value);
    }
    fila.cells[fila.cells.length-1].getElementsByTagName("span")[0].innerHTML=suma;
    var tablaDefecto=fila.parentNode;
    var ultimo=fila.cells.length-1;
    var sumaTotal=0;
    for(var i=1;i<(tablaDefecto.rows.length-2);i++)
    {
        
        sumaTotal+=parseInt(tablaDefecto.rows[i].cells[ultimo].getElementsByTagName("span")[0].innerHTML);
    }
    ultimo=tablaDefecto.rows[tablaDefecto.rows.length-1].cells.length-1;
    console.log(tablaDefecto.rows[tablaDefecto.rows.length-1].cells[ultimo-1].innerHTML);
    tablaDefecto.rows[tablaDefecto.rows.length-1].cells[ultimo-1].getElementsByTagName("span")[0].innerHTML=sumaTotal;
    tablaDefecto.rows[tablaDefecto.rows.length-1].cells[ultimo].getElementsByTagName("span")[0].innerHTML=
    (parseInt(tablaDefecto.rows[tablaDefecto.rows.length-1].cells[ultimo-2].getElementsByTagName("input")[0].value)-sumaTotal);
    
 }
 function calcularAmpollasAprobadas(celda)
 {
     var fila=celda.parentNode.parentNode;
     fila.cells[fila.cells.length-1].getElementsByTagName("span")[0].innerHTML=
  (parseInt(celda.value)-parseInt(fila.cells[fila.cells.length-2].getElementsByTagName("span")[0].innerHTML));
 }
</script>


</head>
    <body >
        <div style="margin-top:2%;position:fixed;;width:100%;z-index:5;visibility:hidden" id="divImagen">
         <center><img src="../../reponse/img/load2.gif"  style="z-index:6; "><%--margin-top:2%;position:fixed;--%>
         </center>
         </div>
      
  <%
      
      
    int cantidadTotal=0;
    int cantidadTotalInspeccionados=0;
    //datos lote
        String codAreaEmpresaPersonal=request.getParameter("codAreaEmpresa");
        int codPersonal=Integer.valueOf(request.getParameter("codPersonal"));
        String codprogramaProd=request.getParameter("codProgramaProd");
        String codTipoProgramaProd=request.getParameter("codTipoProgramaProd");
        String codCompProd=request.getParameter("codCompProd");
        String codLote=request.getParameter("codLote");
        int codTipoPermiso=Integer.valueOf(request.getParameter("codTipoPermiso"));
        
        out.println("<script type='text/javascript'>codPersonal="+codPersonal+";" +
                   "codTipoPermiso="+codTipoPermiso+";</script>");
        int codEstadoHoja=0;
        out.println("<title>("+codLote+")REVISION DE AMPOLLAS DOSIFICADAS</title>");
        String personal="";
        int codPersonalApruebaDespeje=0;
        int codFormulaMaestra=0;
        int codPersonalCierre=0;
        String observaciones="";
        Date fechaCierre=new Date();
        char b=13;char c=10;
        //formato numero
        NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
        DecimalFormat format = (DecimalFormat)nf;
        format.applyPattern("#,##0.00");
        SimpleDateFormat sdfHora=new SimpleDateFormat("HH:mm");
        SimpleDateFormat sdfDias=new SimpleDateFormat("dd/MM/yyyy");
        String indicacionesDespejeLinea="";
        //out.println("<script>sqlConnection.verificarRegistroPendiente('"+codprogramaProd+"','"+codLote+"',3)</script>");
        //datos propios de la hoja
        int codActividadInspeccion=0;
        String indicacionesLavadoAmpollas="";
        int codSeguimientoInspeccionAcond=0;
        int codSeguimientoControlDosificado=0;
        int codSeguimientoLavadoAcond=0;
        int cantidadInspeccionadas=0;
        int cantidadDefectuosas=0;
        Connection con=null;
        try
        {
              con=Util.openConnection(con);
              Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
              StringBuilder consulta=new StringBuilder("select pp.cod_formula_maestra,cp.nombre_prod_semiterminado,ff.nombre_forma,");
                                                consulta.append(" cp.VIDA_UTIL,pp.CANT_LOTE_PRODUCCION,tpp.NOMBRE_TIPO_PROGRAMA_PROD,");
                                                consulta.append(" isnull(dpff.ACOND_INDICACIONES_LAVADO_AMPOLLAS_DOSIFICADAS, '') as ACOND_INDICACIONES_LAVADO_AMPOLLAS_DOSIFICADAS,");
                                                consulta.append(" isnull(afm.COD_ACTIVIDAD_FORMULA, 0) as codActividadInspeccion,");
                                                consulta.append(" isnull(sil.COD_SEGUIMIENTO_INSPECCION_LOTE_ACOND, 0) AS COD_SEGUIMIENTO_INSPECCION_LOTE_ACOND,");
                                                consulta.append(" ISNULL(sil.COD_PERSONAL_SUPERVISOR, 0) AS COD_PERSONAL_SUPERVISOR,ISNULL(sil.OBSERVACIONES, '') AS OBSERVACIONES,sil.FECHA_CIERRE,");
                                                consulta.append(" isnull(scdl.COD_SEGUIMIENTO_CONTROL_DOSIFICADO_LOTE, 0) AS codSeguimientoControlDosificado,");
                                                consulta.append(" isnull(sll.COD_SEGUIMIENTO_LAVADO_LOTE_ACOND, 0) AS COD_SEGUIMIENTO_LAVADO_LOTE_ACOND");
                                        consulta.append(" from PROGRAMA_PRODUCCION pp  ");
                                                consulta.append(" inner join componentes_prod cp on cp.COD_COMPPROD=pp.COD_COMPPROD ");
                                                consulta.append(" inner join FORMAS_FARMACEUTICAS ff on ff.cod_forma=cp.COD_FORMA");
                                                consulta.append(" inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD");
                                                consulta.append(" left outer join DESCRIPCION_PROCESOS_FORMA_FARMACEUTICA dpff on dpff.COD_FORMA=cp.COD_FORMA");
                                                consulta.append(" left outer join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_AREA_EMPRESA =84 and afm.COD_ACTIVIDAD = 96" );
                                                consulta.append(" and afm.COD_FORMULA_MAESTRA =pp.COD_FORMULA_MAESTRA and afm.COD_PRESENTACION = 0");
                                                consulta.append(" LEFT OUTER JOIN SEGUIMIENTO_INSPECCION_LOTE_ACOND sil on sil.cod_lote = pp.COD_LOTE_PRODUCCION" );
                                                consulta.append(" and sil.COD_PROGRAMA_PROD = pp.COD_PROGRAMA_PROD");
                                                consulta.append(" and sil.COD_COMPPROD=pp.COD_COMPPROD and sil.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD");
                                                consulta.append(" left OUTER JOIN SEGUIMIENTO_CONTROL_DOSIFICADO_LOTE scdl ON scdl.COD_LOTE =pp.COD_LOTE_PRODUCCION AND scdl.COD_PROGRAMA_PROD = pp.COD_PROGRAMA_PROD");
                                                consulta.append(" LEFT OUTER JOIN SEGUIMIENTO_LAVADO_LOTE_ACOND sll on sll.cod_lote =pp.COD_LOTE_PRODUCCION and sll.COD_PROGRAMA_PROD = pp.COD_PROGRAMA_PROD");
                                                consulta.append(" and sll.COD_COMPPROD=pp.COD_COMPPROD and sll.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD");
                                        consulta.append(" where pp.COD_LOTE_PRODUCCION='").append(codLote).append("'");
                                                consulta.append(" and pp.COD_PROGRAMA_PROD=").append(codprogramaProd);
                                                consulta.append(" and pp.COD_COMPPROD=").append(codCompProd);
                                                consulta.append(" and pp.COD_TIPO_PROGRAMA_PROD=").append(codTipoProgramaProd);
                System.out.println("consulta cargar datos del lote "+consulta.toString());
                ResultSet res=st.executeQuery(consulta.toString());
                if(res.next())
                {
                    codSeguimientoLavadoAcond=res.getInt("COD_SEGUIMIENTO_LAVADO_LOTE_ACOND");
                    codSeguimientoControlDosificado=res.getInt("codSeguimientoControlDosificado");
                    fechaCierre=(res.getTimestamp("FECHA_CIERRE")!=null?res.getTimestamp("FECHA_CIERRE"):new Date());
                    codPersonalCierre=res.getInt("COD_PERSONAL_SUPERVISOR");
                    observaciones=res.getString("OBSERVACIONES");
                    codSeguimientoInspeccionAcond=res.getInt("COD_SEGUIMIENTO_INSPECCION_LOTE_ACOND");
                    codActividadInspeccion=res.getInt("codActividadInspeccion");
                    indicacionesLavadoAmpollas=res.getString("ACOND_INDICACIONES_LAVADO_AMPOLLAS_DOSIFICADAS").replace(b,'\n').replace("\n", "</br>").replace("</br></br>","<br>");
                    codFormulaMaestra=res.getInt("cod_formula_maestra");
                    if(codActividadInspeccion==0)
                    {
                        out.println("<script type='text/javascript'>alert('No se encuentran asociada la actividad:INSPECCION DE AMPOLLAS ACD');window.close();</script>");
                    }

                    %>
<section class="main">
                         <div class="row"  style="margin-top:5px" >
                                <div class="large-12 medium-12 small-12 large-centered medium-centered small-centered columns" >

                                            <div class="row">
                                               <div class="large-12 medium-12 small-12 columns divHeaderClass" >
                                                       <label  class="inline">REVISION DE AMPOLLAS DOSIFICADAS</label>
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
                                                               <span class="textHeaderClassBody"><%=res.getString("NOMBRE_TIPO_PROGRAMA_PROD")%></span>
                                                           </td>
                                                       </tr>
                                                       </table>
                                                   
                                                    
                                             </div>
                                             </div>
                                         </div>
                            </div>

                              <%
                              }
                        out.println("<script type='text/javascript'>" +
                                        "codPersonalGeneral="+codPersonal+";" +
                                        "codProgramaProdGeneral='"+codprogramaProd+"';"+
                                        "codLoteGeneral='"+codLote+"';"+
                                        "codComprodGeneral='"+codCompProd+"';"+
                                        "codTipoProgramaProdGeneral='"+codTipoProgramaProd+"';"+
                                        "codFormulaMaestraGeneral='"+codFormulaMaestra+"';"+
                                        "codTipoPermiso="+codTipoPermiso+";</script>");
                              %>
<div class="row"  style="margin-top:5px" >
            <div class="large-12 medium-12 small-12 large-centered medium-centered small-centered columns" >

                        <div class="row">
                           <div class="large-12 medium-12 small-12 columns divHeaderClass" >
                                   <label  class="inline">REVISION DE AMPOLLAS DOSIFICADAS</label>
                            </div>
                        </div>
                        <div class="row" >

                        <div  class="divContentClass large-12 medium-12 small-12 columns" style="padding-top:1em;">
                
                        <span ><%=(indicacionesLavadoAmpollas)%></span>
                        
                         <%
                             personal=UtilidadesTablet.operariosAreaProduccionAcondicionamientoSelect(st, codTipoPermiso, codPersonal);
                             out.println("<script type='text/javascript'>operariosRegistro=\""+personal+"\";</script>");
                        
                        
                        %>
                        
                    <center>
                         <div class="row" style="margin-top:1em;">
                            <div class="large-12 medium-12 small-12 large-centered medium-centered small-centered columns">
                                
                                <table style="border:none;width:100%;padding:0.5em;" id="dataAmpollasInspeccionadas" cellpadding="0" cellspacing="0">
                                    <tr><td></td></tr>
                                        <%
                                        consulta=new StringBuilder("select sppp.COD_PERSONAL,sppp.FECHA_INICIO,sppp.FECHA_FINAL,");
                                                            consulta.append(" sppp.UNIDADES_PRODUCIDAS,sppp.COD_REGISTRO_ORDEN_MANUFACTURA");
                                                    consulta.append(" from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sppp ");
                                                    consulta.append(" where sppp.COD_PROGRAMA_PROD=").append(codprogramaProd);
                                                            consulta.append(" and sppp.COD_LOTE_PRODUCCION='").append(codLote).append("'");
                                                            consulta.append(" and sppp.COD_FORMULA_MAESTRA=").append(codFormulaMaestra);
                                                            consulta.append(" and sppp.COD_COMPPROD=").append(codCompProd);
                                                            consulta.append(" and sppp.COD_TIPO_PROGRAMA_PROD=").append(codTipoProgramaProd);
                                                            consulta.append(" and sppp.COD_ACTIVIDAD_PROGRAMA=").append(codActividadInspeccion);
                                                            if(codTipoPermiso<=10)
                                                                    consulta.append(" and sppp.COD_PERSONAL=").append(codPersonal);
                                                    consulta.append(" order by sppp.COD_REGISTRO_ORDEN_MANUFACTURA");
                                        System.out.println("consulta personal registrado "+consulta.toString());
                                        res=st.executeQuery(consulta.toString());
                                        int cantOperarios=0;
                                        String cabeceras="";
                                        Statement stDetalle=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                        ResultSet resDetalle=null;
                                        while(res.next())
                                        {
                                                consulta=new StringBuilder("select sppp.COD_PERSONAL,isnull((p.AP_PATERNO_PERSONAL+'<br/>'+p.AP_MATERNO_PERSONAL+'<br/>'+p.NOMBRES_PERSONAL),(pt.AP_PATERNO_PERSONAL+'<br/>'+pt.AP_MATERNO_PERSONAL+'<br/>'+pt.NOMBRES_PERSONAL)) as nombrePersonal");
                                                            consulta.append(" from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sppp ");
                                                                        consulta.append(" inner join ACTIVIDADES_FORMULA_MAESTRA afm on sppp.COD_ACTIVIDAD_PROGRAMA = afm.COD_ACTIVIDAD_FORMULA");
                                                                        consulta.append(" inner join ACTIVIDADES_PRODUCCION ap on ap.COD_ACTIVIDAD=afm.COD_ACTIVIDAD");
                                                                        consulta.append(" and ap.COD_ACTIVIDAD in (29,40,157)");
                                                                        consulta.append(" left outer join personal p on sppp.COD_PERSONAL=p.COD_PERSONAL");
                                                                        consulta.append(" left outer join personal_temporal pt on sppp.COD_PERSONAL=pt.COD_PERSONAL");
                                                                        consulta.append(" where sppp.COD_COMPPROD=").append(codCompProd);
                                                                        consulta.append(" and sppp.COD_LOTE_PRODUCCION='").append(codLote).append("'");
                                                                        consulta.append(" and sppp.COD_FORMULA_MAESTRA=").append(codFormulaMaestra);
                                                                        consulta.append(" and sppp.COD_PROGRAMA_PROD=").append(codprogramaProd);
                                                                        consulta.append(" and sppp.COD_TIPO_PROGRAMA_PROD=").append(codTipoProgramaProd);
                                                            consulta.append(" group by sppp.COD_PERSONAL,p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRES_PERSONAL,pt.AP_PATERNO_PERSONAL,pt.AP_MATERNO_PERSONAL,pt.NOMBRES_PERSONAL" );
                                                            consulta.append(" order by p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRES_PERSONAL");
                                                System.out.println("consulta cargar seguimiento ampollas "+consulta.toString());
                                                resDetalle=stDetalle.executeQuery(consulta.toString());
                                                out.println("<tr onclick='seleccionarFila(this);'><td><table  id='tablaDatosDefectos-"+res.getRow()+"' style='border:none;width:100%' cellpadding='0' cellspacing='0' ><tr >"+
                                                                 " <td class='tableHeaderClass' style='border-top-left-radius:10px;' ><span class='textHeaderClass'> Defectos </span></td>");
                                                StringBuilder consultaBody=new StringBuilder("");cabeceras="";
                                                while(resDetalle.next())
                                                {
                                                    out.println("<td class='tableHeaderClass'><input type='hidden' value='"+resDetalle.getString("COD_PERSONAL")+"'>"+
                                                               " <span class='textHeaderClass'>"+resDetalle.getString("nombrePersonal")+"</span></td>");
                                                    cabeceras+=",ISNULL(depp"+resDetalle.getRow()+".CANTIDAD_DEFECTOS_ENCONTRADOS,0) as CANTIDAD_DEFECTOS_ENCONTRADOS"+resDetalle.getRow();
                                                    consultaBody.append(" left outer join DEFECTOS_ENVASE_PROGRAMA_PRODUCCION depp").append(resDetalle.getRow()).append(" on");
                                                            consultaBody.append(" de.COD_DEFECTO_ENVASE=depp").append(resDetalle.getRow()).append(".COD_DEFECTO_ENVASE ");
                                                            consultaBody.append(" and depp").append(resDetalle.getRow()).append(".COD_SEGUIMIENTO_INSPECCION_LOTE_ACOND=").append(codSeguimientoInspeccionAcond);
                                                            consultaBody.append(" and depp").append(resDetalle.getRow()).append(".COD_PERSONAL='").append(res.getInt("COD_PERSONAL")).append("'");
                                                            consultaBody.append(" and depp").append(resDetalle.getRow()).append(".COD_PERSONAL_OPERARIO='").append(resDetalle.getString("COD_PERSONAL")).append("'");
                                                            consultaBody.append(" and depp").append(resDetalle.getRow()).append(".COD_REGISTRO_ORDEN_MANUFACTURA='").append(res.getInt("COD_REGISTRO_ORDEN_MANUFACTURA")).append("'");
                                                    cantOperarios=resDetalle.getRow();
                                                }
                                                out.println("<td class='tableHeaderClass' style='border-top-right-radius:10px;'><span class='textHeaderClass'>TOTAL</span></td></tr>");
                                                consulta=new StringBuilder("select de.COD_DEFECTO_ENVASE,de.NOMBRE_DEFECTO_ENVASE ").append(cabeceras);
                                                         consulta.append(" from DEFECTOS_ENVASE de ").append(consultaBody.toString()).append(" where de.cod_estado_registro=1 order by de.ORDEN");
                                                System.out.println("consulta defectos registrados "+consulta.toString());
                                                resDetalle=stDetalle.executeQuery(consulta.toString());
                                                int cantidadParcial=0;
                                                cantidadTotal=0;
                                                while(resDetalle.next())
                                                {
                                                    out.println("<tr><td class='' style='text-align:right;border-left: solid #a80077 1px ;'><input type='hidden' value='"+resDetalle.getInt("COD_DEFECTO_ENVASE")+"'>"+
                                                              "<span class='textHeaderClassBody'>"+resDetalle.getString("NOMBRE_DEFECTO_ENVASE")+"</span></td>");
                                                    cantidadParcial=0;
                                                    for(int i=1;i<=cantOperarios;i++)
                                                    {
                                                        out.println("<td ><input type='tel' value='"+resDetalle.getInt("CANTIDAD_DEFECTOS_ENCONTRADOS"+i)+"' size='4'" +
                                                                   " class='inputText' onkeyup='calcularSuma(this)'/></td>");
                                                        cantidadParcial+=resDetalle.getInt("CANTIDAD_DEFECTOS_ENCONTRADOS"+i);
                                                        cantidadTotal+=resDetalle.getInt("CANTIDAD_DEFECTOS_ENCONTRADOS"+i);
                                                    }
                                                    out.println(" <td align='center' style='border-right: solid #a80077 1px ;'><span class='textHeaderClassBody' style='display:inherit;color:#FF0000'>"+cantidadParcial+"</span></td></tr>");
                                                }
                                                cantidadDefectuosas+=cantidadTotal;
                                                cantidadInspeccionadas+=res.getInt("UNIDADES_PRODUCIDAS");
                                                out.println("<tr><td class='tableHeaderClass' ><span class='textHeaderClass'>PERSONAL</span></td>" +
                                                           "<td class='tableHeaderClass'><span class='textHeaderClass'>FECHA</span></td>"+
                                                           "<td class='tableHeaderClass'><span class='textHeaderClass'>HORA<BR>INICIO</span></td>"+
                                                           "<td class='tableHeaderClass'><span class='textHeaderClass'>HORA<BR>FINAL</span></td>"+
                                                           "<td class='tableHeaderClass'><span class='textHeaderClass'>CANT.<BR>INSP.</span></td>"+
                                                           "<td class='tableHeaderClass'><span class='textHeaderClass'>CANT.<BR>MALAS.</span></td>"+
                                                           "<td class='tableHeaderClass'><span class='textHeaderClass'>CANT.<BR>APROB.</span></td>"+
                                                           "</tr><tr>" +
                                                           "<td class='tableCell' style='border-bottom-left-radius:10px;'  align='center'><select  id='pInsR"+res.getRow()+"'>"+personal+"</select>" +
                                                           "<script>pInsR"+res.getRow()+".value='"+res.getInt("COD_PERSONAL")+"';</script></td>" +
                                                           "<td class='tableCell'  align='center'><input type='tel'  value='"+sdfDias.format(res.getTimestamp("FECHA_INICIO"))+"' size='10' onclick='seleccionarDatePickerJs(this)' id='fechaRegistroR"+res.getRow()+"' /></td>"+
                                                           "<td class='tableCell'  align='center'><input type='tel'  onclick='seleccionarHora(this);' id='fechaIniInspecR"+res.getRow()+"'" +
                                                           " value='"+sdfHora.format(res.getTimestamp("FECHA_INICIO"))+"' style='width:6em;display:inherit;'/></td>"+
                                                           " <td class='tableCell'align='center'><input type='text'  onclick='seleccionarHora(this);' id='fechaFinInspecR"+res.getRow()+"'" +
                                                           " value='"+sdfHora.format(res.getTimestamp("FECHA_FINAL"))+"' style='width:6em;display:inherit;'/></td >"+
                                                           " <td class='tableCell'align='center'><input type='text'   id='cantInpecIndicador' value='"+res.getInt("UNIDADES_PRODUCIDAS")+"' onkeyup='calcularAmpollasAprobadas(this)' style='width:6em;display:inherit;'/></td >"+
                                                           "<td align='center' class='tableCell'><span class='textHeaderClassBody' style='display:inherit;font-weight:normal;'>"+cantidadTotal+"</span></td>"+
                                                           "<td align='center' style='border-bottom-right-radius:10px;' class='tableCell'><span class='textHeaderClassBody' style='display:inherit;font-weight:normal;'>"+(res.getInt("UNIDADES_PRODUCIDAS")-cantidadTotal)+"</span></td>"+
                                                           "</tr>");
                                                out.println("</table></td></tr>");
                                                //out.println("<script type='text/javascript'>innerTablaInspeccion=\""+innerHTML+"\"</script>");
                                               // out.println(innerHTML);
                                           }
                                        consulta=new StringBuilder("select p.COD_PERSONAL,(p.AP_PATERNO_PERSONAL+'<br/>'+p.AP_MATERNO_PERSONAL+'<br/>'+p.NOMBRE_PILA) as nombrePersonal");
                                                        consulta.append(" from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sppp ");
                                                                consulta.append(" inner join ACTIVIDADES_FORMULA_MAESTRA afm on sppp.COD_ACTIVIDAD_PROGRAMA = afm.COD_ACTIVIDAD_FORMULA");
                                                                consulta.append(" inner join ACTIVIDADES_PRODUCCION ap on ap.COD_ACTIVIDAD=afm.COD_ACTIVIDAD");
                                                                consulta.append(" and ap.COD_ACTIVIDAD in (29,40,157) inner join personal p on sppp.COD_PERSONAL=p.COD_PERSONAL");
                                                        consulta.append(" where sppp.COD_COMPPROD=").append(codCompProd);
                                                                consulta.append(" and sppp.COD_LOTE_PRODUCCION='").append(codLote).append("'");
                                                                consulta.append(" and sppp.COD_FORMULA_MAESTRA=").append(codFormulaMaestra);
                                                                consulta.append(" and sppp.COD_PROGRAMA_PROD=").append(codprogramaProd);
                                                                consulta.append(" and sppp.COD_TIPO_PROGRAMA_PROD=").append(codTipoProgramaProd);
                                                        consulta.append(" group by p.COD_PERSONAL,p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRE_PILA" );
                                                        consulta.append(" order by p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRE_PILA");
                                        String innerHTML="<tr><td><table  id='tablaDatosDefectosIndicador' style='border:none;width:100%' cellpadding='0' cellspacing='0' ><tr >"+
                                                         " <td class='tableHeaderClass' style='border-top-left-radius:10px;' ><span class='textHeaderClass'> Defectos </span></td>";
                                        res=st.executeQuery(consulta.toString());
                                        cantOperarios=0;
                                        while(res.next())
                                        {
                                            innerHTML+="<td class='tableHeaderClass'><input type='hidden' value='"+res.getString("COD_PERSONAL")+"'>"+
                                                      " <span class='textHeaderClass'>"+res.getString("nombrePersonal")+"</span></td>";
                                            cantOperarios=res.getRow();
                                        }
                                        innerHTML+="<td class='tableHeaderClass' style='border-top-right-radius:10px;'><span class='textHeaderClass'>TOTAL</span></td></tr>";
                                        consulta=new StringBuilder("select de.COD_DEFECTO_ENVASE,de.NOMBRE_DEFECTO_ENVASE");
                                                 consulta.append(" from DEFECTOS_ENVASE de");
                                                        consulta.append(" where de.cod_estado_registro = 1 order by de.ORDEN");
                                        res=st.executeQuery(consulta.toString());
                                        while(res.next())
                                        {
                                            innerHTML+="<tr><td class='' style='text-align:right;border-left: solid #a80077 1px ;'><input type='hidden' value='"+res.getInt("COD_DEFECTO_ENVASE")+"'>"+
                                                      "<span class='textHeaderClassBody'>"+res.getString("NOMBRE_DEFECTO_ENVASE")+"</span></td>";
                                            for(int i=1;i<=cantOperarios;i++)
                                            {
                                                innerHTML+="<td ><input type='tel' value='0' size='4'" +
                                                           " class='inputText' onkeyup='calcularSuma(this)'/></td>";
                                            }
                                            innerHTML+=" <td align='center' style='border-right: solid #a80077 1px ;'><span class='textHeaderClassBody' style='display:inherit;color:#FF0000'>0.0</span></td></tr>";
                                        }
                                        innerHTML+="<tr><td class='tableHeaderClass' ><span class='textHeaderClass'>PERSONAL</span></td>" +
                                                   "<td class='tableHeaderClass'><span class='textHeaderClass'>FECHA</span></td>"+
                                                   "<td class='tableHeaderClass'><span class='textHeaderClass'>HORA<BR>INICIO</span></td>"+
                                                   "<td class='tableHeaderClass'><span class='textHeaderClass'>HORA<BR>FINAL</span></td>"+
                                                   "<td class='tableHeaderClass'><span class='textHeaderClass'>CANT.<BR>INSP.</span></td>"+
                                                   "<td class='tableHeaderClass'><span class='textHeaderClass'>CANT.<BR>MALAS.</span></td>"+
                                                   "<td class='tableHeaderClass'><span class='textHeaderClass'>CANT.<BR>APROB.</span></td>"+
                                                   "</tr><tr>" +
                                                   "<td class='tableCell' style='border-bottom-left-radius:10px;'  align='center'><select id='pInsIndicador'>"+personal+"</select>" +
                                                   "</td>" +
                                                   "<td class='tableCell'  align='center'><input type='tel' value='"+sdfDias.format(new Date())+"' size='10' onclick='seleccionarDatePickerJs(this)' id='fechaRegistroInspecIndicador' /></td>"+
                                                   "<td class='tableCell'  align='center'><input type='tel' onclick='seleccionarHora(this);' id='fechaIniInspecIndicador'" +
                                                   " value='"+sdfHora.format(new  Date())+"' style='width:6em;display:inherit;'/></td>"+
                                                   " <td class='tableCell'align='center'><input type='text' onclick='seleccionarHora(this);' id='fechaFinInpecIndicador'" +
                                                   " value='"+sdfHora.format(new  Date())+"' style='width:6em;display:inherit;'/></td >"+
                                                   " <td class='tableCell'align='center'><input type='text'  id='cantInpecIndicador' value='0' onkeyup='calcularAmpollasAprobadas(this);' style='width:6em;display:inherit;'/></td >"+
                                                   "<td align='center' class='tableCell'><span class='textHeaderClassBody' style='display:inherit;font-weight:normal;'>0.0</span></td>"+
                                                   "<td align='center' style='border-bottom-right-radius:10px;' class='tableCell'><span class='textHeaderClassBody' style='display:inherit;font-weight:normal;'>0.0</span></td>"+
                                                   "</tr>";
                                        innerHTML+="</table></td></tr>";
                                        out.println("<script type='text/javascript'>innerTablaInspeccion=\""+innerHTML+"\"</script>");
                                        %>
                                </table>
                                
                                    <div class="row" >
                                        <div class="large-5 medium-5 small-4 columns" style="">&nbsp;</div>
                                          <div class="large-1 medium-1 small-2 columns" >
                                                <button  class="small button succes radius buttonMas" onclick="nuevoRegistro('dataAmpollasInspeccionadas')">+</button>
                                          </div>
                                          <div class="large-1 medium-1 small-2 columns">
                                                    <button class="small button succes radius buttonMenos" onclick="eliminarRegistroTabla('dataAmpollasInspeccionadas');" >-</button>
                                          </div>
                                          <div class="large-5 medium-5 small-4 columns" style="">&nbsp;</div>
                                  </div>
                                  
                            </div>
                         </div>
                         <center>
                            

                         </center>
                    
                    <%
                    if(codTipoPermiso==12)
                    {
                        consulta=new StringBuilder("select (p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL+' '+p.nombre2_personal) as nombrePersonal");
                                 consulta.append(" from PERSONAL p where p.COD_PERSONAL=").append(codPersonalCierre>0?codPersonalCierre:codPersonal);
                        res=st.executeQuery(consulta.toString());
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
                    out.println("<div class='row' style='margin-top:0px;'>");
                        out.println("<div class='large-6 small-8 medium-10 large-centered medium-centered columns'>");
                            out.println("<div class='row'>");
                                if(codTipoPermiso==12)
                                {
                                        out.println("<div class='large-4 medium-6 small-12 columns'>");
                                            out.println("<button class='small button succes radius buttonAction' onclick='guardarInspeccionAmpollasDosificado(false,2);' >Aprobar</button>");
                                        out.println("</div>");
                                        out.println("<div class='large-4 medium-6 small-12 columns'>");
                                            out.println("<button class='small button succes radius buttonAction' onclick='guardarInspeccionAmpollasDosificado(false,1);' >Pre Aprobar</button>");
                                        out.println("</div>");
                                        out.println("<div class='large-4 medium-6 small-12  columns'>");
                                            out.println("<button class='small button succes radius buttonAction' onclick='window.close();' >Cancelar</button>");
                                        out.println("</div>");
                                }
                                else
                                {
                                        out.println("<div class='large-6 medium-6 small-12 columns'>");
                                            out.println("<button class='small button succes radius buttonAction' onclick='guardarInspeccionAmpollasDosificado(false,0)' >Guardar</button>");
                                        out.println("</div>");
                                        out.println("<div class='large-6 medium-6 small-12  columns'>");
                                            out.println("<button class='small button succes radius buttonAction' onclick='window.close();' >Cancelar</button>");
                                        out.println("</div>");
                                }
                            out.println("</div>");
                        out.println("</div>");
                    out.println("</div >");

                }
                catch(SQLException ex)
                {
                    ex.printStackTrace();
                }
                finally
                {
                    con.close();
                }
                %>
                    

            </div>
    </div>
    </div>
    </div>
    <div  id="formsuper"  class="formSuper">

          </div>
        <input type="hidden" value="<%=(codPersonalCierre)%>" id="cerrado"/>
        <input type="hidden" id="codLoteSeguimiento" value="<%=codLote%>"/>
        <input type="hidden" id="codprogramaProd" value="<%=(codprogramaProd)%>"/>
        <input type="hidden" id="codFormulaMaestra" value="<%=(codFormulaMaestra)%>"/>
        <input type="hidden" id="codTipoProgramaProd" value="<%=(codTipoProgramaProd)%>"/>
        <input type="hidden" id="codCompProd" value="<%=(codCompProd)%>"/>
        <input type="hidden" id="codActividadInspeccion" value="<%=(codActividadInspeccion)%>"/>
        <input  type="hidden" id="codSeguimientoInspeccionAcond" value="<%=(codSeguimientoInspeccionAcond)%>">
        </section>
    </body>
    <script src="../../reponse/js/timePickerJs.js"></script>
    <script src="../../reponse/js/dataPickerJs.js"></script>
    <script src="../../reponse/js/mensajejs.js"></script>
    <script>iniciarDatePicker('<%=(sdfDias.format(new Date()))%>');loginHoja.verificarHojaCerrada('cerrado',(codTipoPermiso==12),'codprogramaProd','codLoteSeguimiento',8,<%=(codEstadoHoja)%>);</script>
</html>
