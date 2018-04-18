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

<link rel="STYLESHEET" type="text/css" href="../../reponse/css/jscal2.css" />
<link rel="STYLESHEET" type="text/css" href="../../reponse/css/gold.css" />
<link rel="STYLESHEET" type="text/css" href="../../reponse/css/timePickerCSs.css" />
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
    function guardarInspeccionAmpollasDosificado(aprobacionDepeje)
    {
        iniciarProgresoSistema();
        ajax=nuevoAjax();
        var peticion="ajaxGuardarInspeccionAmpollasDosificadas.jsf?"+
            "codLote="+codLoteGeneral+"&noCache="+ Math.random()+"&date="+(new Date().getTime()).toString()+
             "&codprogramaProd="+codProgramaProdGeneral+
             "&codFormulaMaestra="+codFormulaMaestraGeneral+
             "&codTipoProgramaProd="+codTipoProgramaProdGeneral+
             "&dataSeguimiento="+(new Array())+"&dataDefectosEncontrados="+(new Array())+
             "&codCompProd="+codComprodGeneral+
             "&admin="+(administradorSistema?1:0)+
             "&codPersonalUsuario="+codPersonalGeneral+
             "&codActividadInspeccion="+document.getElementById("codActividadInspeccion").value+
             (administradorSistema?"&observacion="+document.getElementById("observacion").value:"");

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
                            terminarProgresoSistema();
                            return false;
                        }
                        if(parseInt(ajax.responseText.split("\n").join(""))=='1')
                        {
                            alert((aprobacionDepeje?'Se aprobo el despeje de linea':'Se registro la etapa de inspeccion de ampollas'));
                            terminarProgresoSistema();
                            window.close();
                            return true;
                        }
                        else
                        {
                            alert(ajax.responseText.split("\n").join(""));
                            terminarProgresoSistema();
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
</script>


</head>
    <body >
        <div style="margin-top:2%;position:fixed;;width:100%;z-index:5;visibility:hidden" id="divImagen">
         <center><img src="../../reponse/img/load2.gif"  style="z-index:6; "><%--margin-top:2%;position:fixed;--%>
         </center>
         </div>
      
  <%
        String codAreaEmpresaPersonal=request.getParameter("codAreaEmpresa");
        int codPersonal=Integer.valueOf(request.getParameter("codPersonal"));
        String codprogramaProd=request.getParameter("codProgramaProd");
        String codTipoProgramaProd=request.getParameter("codTipoProgramaProd");
        String codCompProd=request.getParameter("codCompProd");
        String codLote=request.getParameter("codLote");
        boolean administrador=(Integer.valueOf(request.getParameter("admin"))>0);
        out.println("<script type='text/javascript'>codPersonal="+codPersonal+";" +
                   "admin="+administrador+";</script>");
        int codEstadoHoja=0;
        out.println("<title>("+codLote+")REVISION DE AMPOLLAS DOSIFICADAS</title>");
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
        try
        {
              Connection con=null;
              con=Util.openConnection(con);
              Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
              String consulta="select pp.cod_formula_maestra,cp.nombre_prod_semiterminado,ff.nombre_forma,"+
                              " cp.VIDA_UTIL,pp.CANT_LOTE_PRODUCCION,tpp.NOMBRE_TIPO_PROGRAMA_PROD," +
                              " isnull(dpff.ACOND_INDICACIONES_LAVADO_AMPOLLAS_DOSIFICADAS, '') as ACOND_INDICACIONES_LAVADO_AMPOLLAS_DOSIFICADAS,"+
                              " isnull(afm.COD_ACTIVIDAD_FORMULA, 0) as codActividadInspeccion,"+
                              " isnull(sil.COD_SEGUIMIENTO_INSPECCION_LOTE_ACOND, 0) AS COD_SEGUIMIENTO_INSPECCION_LOTE_ACOND,"+
                              " ISNULL(sil.COD_PERSONAL_SUPERVISOR, 0) AS COD_PERSONAL_SUPERVISOR,ISNULL(sil.OBSERVACIONES, '') AS OBSERVACIONES,sil.FECHA_CIERRE,"+
                              " isnull(scdl.COD_SEGUIMIENTO_CONTROL_DOSIFICADO_LOTE, 0) AS codSeguimientoControlDosificado,"+
                              " isnull(sll.COD_SEGUIMIENTO_LAVADO_LOTE_ACOND, 0) AS COD_SEGUIMIENTO_LAVADO_LOTE_ACOND"+
                              " from PROGRAMA_PRODUCCION pp inner join componentes_prod cp on "+
                              " cp.COD_COMPPROD=pp.COD_COMPPROD "+
                              " inner join FORMAS_FARMACEUTICAS ff on ff.cod_forma=cp.COD_FORMA"+
                              " inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD"+
                              " left outer join DESCRIPCION_PROCESOS_FORMA_FARMACEUTICA dpff on dpff.COD_FORMA=cp.COD_FORMA"+
                              " left outer join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_AREA_EMPRESA =84 and afm.COD_ACTIVIDAD = 96" +
                              " and afm.COD_FORMULA_MAESTRA =pp.COD_FORMULA_MAESTRA and afm.COD_PRESENTACION = 0"+
                              " LEFT OUTER JOIN SEGUIMIENTO_INSPECCION_LOTE_ACOND sil on sil.cod_lote = pp.COD_LOTE_PRODUCCION" +
                              " and sil.COD_PROGRAMA_PROD = pp.COD_PROGRAMA_PROD"+
                              " and sil.COD_COMPPROD=pp.COD_COMPPROD and sil.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD"+
                              " left OUTER JOIN SEGUIMIENTO_CONTROL_DOSIFICADO_LOTE scdl ON scdl.COD_LOTE =pp.COD_LOTE_PRODUCCION AND scdl.COD_PROGRAMA_PROD = pp.COD_PROGRAMA_PROD"+
                              " LEFT OUTER JOIN SEGUIMIENTO_LAVADO_LOTE_ACOND sll on sll.cod_lote =pp.COD_LOTE_PRODUCCION and sll.COD_PROGRAMA_PROD = pp.COD_PROGRAMA_PROD"+
                              " and sll.COD_COMPPROD=pp.COD_COMPPROD and sll.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD"+
                              " where pp.COD_LOTE_PRODUCCION='"+codLote+"' and pp.COD_PROGRAMA_PROD='"+codprogramaProd+"'" +
                              " and pp.COD_COMPPROD='"+codCompProd+"'"+
                              " and pp.COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"'";
                System.out.println("consulta cargar datos del lote "+consulta);
                ResultSet res=st.executeQuery(consulta);
                    
                    if(res.next())
                    {
                        codSeguimientoControlDosificado=res.getInt("codSeguimientoControlDosificado");
                        fechaCierre=(res.getTimestamp("FECHA_CIERRE")!=null?res.getTimestamp("FECHA_CIERRE"):new Date());
                        codPersonalCierre=res.getInt("COD_PERSONAL_SUPERVISOR");
                        System.out.println("cod pers cierre "+codPersonalCierre);
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
                                                               <span class="textHeaderClass">Tipo Produccion</span>
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
                                        "administradorSistema="+administrador+";</script>");
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
                        
                    <center>
                         <div class="row" style="margin-top:1em;">
                            <div class="large-12 medium-12 small-12 large-centered medium-centered small-centered columns">
                                        <%
                                        consulta="select distinct sppp.COD_PERSONAL,isnull((p.AP_PATERNO_PERSONAL + '<br/>' + p.AP_MATERNO_PERSONAL + '<br/>' +p.NOMBRES_PERSONAL),"+
                                                 " (pt.AP_PATERNO_PERSONAL + '<br/>' + pt.AP_MATERNO_PERSONAL + '<br/>' +pt.NOMBRES_PERSONAL)) as nombrePersonal," +
                                                 " isnull(sum(sppp.UNIDADES_PRODUCIDAS),0) as unidadesproducidas" +
                                                 " from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sppp" +
                                                 " left outer join personal p on p.cod_personal=sppp.cod_personal" +
                                                 " left outer join PERSONAL_TEMPORAL pt on pt.COD_PERSONAL=sppp.COD_PERSONAL"+
                                                 " where sppp.COD_PROGRAMA_PROD='"+codprogramaProd+"'"+
                                                 " and sppp.COD_LOTE_PRODUCCION='"+codLote+"'"+
                                                 " and sppp.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"'"+
                                                 " and sppp.COD_COMPPROD='"+codCompProd+"'"+
                                                 " and sppp.COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"'"+
                                                 " and sppp.COD_ACTIVIDAD_PROGRAMA='"+codActividadInspeccion+"'" +
                                                 " group by sppp.COD_PERSONAL,p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRES_PERSONAL,"+
                                                 " pt.AP_PATERNO_PERSONAL,pt.AP_MATERNO_PERSONAL,pt.NOMBRES_PERSONAL"+
                                                 " order by 2";
                                        System.out.println("consulta personal registrado "+consulta);
                                        res=st.executeQuery(consulta);
                                        int cantOperarios=0;
                                        String cabeceras="";
                                        out.println("<table  id='tablaDatosDefectos-"+res.getRow()+"' style='border:none;width:100%' cellpadding='0' cellspacing='0' ><tr >"+
                                                                 " <td class='tableHeaderClass' style='border-top-left-radius:10px;' ><span class='textHeaderClass'> Defectos </span></td>");
                                                consulta="";
                                                cabeceras="";
                                                List<Integer> cantidades=new ArrayList<Integer>();
                                                int cantidadTotalInspeccionados=0;
                                                while(res.next())
                                                {
                                                    out.println("<td class='tableHeaderClass'><span class='textHeaderClass'>"+res.getString("nombrePersonal")+"</span></td>");
                                                    cabeceras+=",isnull((select sum(depp"+res.getRow()+".CANTIDAD_DEFECTOS_ENCONTRADOS) from DEFECTOS_ENVASE_PROGRAMA_PRODUCCION depp"+res.getRow()+"" +
                                                                " where depp"+res.getRow()+".COD_DEFECTO_ENVASE=de.COD_DEFECTO_ENVASE " +
                                                                " and depp"+res.getRow()+".COD_SEGUIMIENTO_INSPECCION_LOTE_ACOND='"+codSeguimientoInspeccionAcond+"'" +
                                                                " and depp"+res.getRow()+".COD_PERSONAL="+res.getInt("COD_PERSONAL")+"),0) AS CANTIDAD_DEFECTOS_ENCONTRADOS"+res.getRow();
                                                    cantOperarios=res.getRow();
                                                    cantidades.add(res.getInt("unidadesproducidas"));
                                                    cantidadTotalInspeccionados+=res.getInt("unidadesproducidas");
                                                }
                                                out.println("<td class='tableHeaderClass' style='border-top-right-radius:10px;'><span class='textHeaderClass'>TOTAL</span></td></tr>");
                                                consulta="select de.COD_DEFECTO_ENVASE,de.NOMBRE_DEFECTO_ENVASE "+cabeceras+
                                                         " from DEFECTOS_ENVASE de  where de.cod_estado_registro=1" +
                                                         " group by de.COD_DEFECTO_ENVASE,de.NOMBRE_DEFECTO_ENVASE,de.ORDEN order by de.ORDEN";
                                                System.out.println("consulta defectos registrados "+consulta);
                                                res=st.executeQuery(consulta);
                                                int cantidadParcial=0;
                                                int cantidadTotal=0;
                                                
                                                int[] subTotales=new int[cantOperarios];
                                                while(res.next())
                                                {
                                                    out.println("<tr><td class='' style='text-align:right;border-left: solid #a80077 1px ;'><input type='hidden' value='"+res.getInt("COD_DEFECTO_ENVASE")+"'>"+
                                                              "<span class='textHeaderClassBody'>"+res.getString("NOMBRE_DEFECTO_ENVASE")+"</span></td>");
                                                    cantidadParcial=0;
                                                    for(int i=1;i<=cantOperarios;i++)
                                                    {
                                                        out.println("<td align='center'><span class='textHeaderClassBody' style='font-weight:normal'>"+res.getInt("CANTIDAD_DEFECTOS_ENCONTRADOS"+i)+"</span></td>");
                                                        cantidadParcial+=res.getInt("CANTIDAD_DEFECTOS_ENCONTRADOS"+i);
                                                        subTotales[i-1]+=res.getInt("CANTIDAD_DEFECTOS_ENCONTRADOS"+i);
                                                        cantidadTotal+=res.getInt("CANTIDAD_DEFECTOS_ENCONTRADOS"+i);
                                                        
                                                    }
                                                    
                                                    out.println(" <td align='center' style='border-right: solid #a80077 1px ;'><span class='textHeaderClassBody' style='display:inherit;color:#FF0000'>"+cantidadParcial+"</span></td></tr>");
                                                }
                                                out.println("<tr><td style='border-left: solid #a80077 1px;' class='' align='right' ><span class='textHeaderClass' style='color:#FF0000'>TOTAL DEFECTOS:</span></td>");
                                                for(int i=0;i<cantOperarios;i++)out.println("<td align='center' style=''><span class='textHeaderClassBody' style='display:inherit;color:#FF0000'>"+subTotales[i]+"</span></td>");
                                                out.println("<td align='center' style='border-right: solid #a80077 1px;'><span class='textHeaderClassBody' style='display:inherit;color:#FF0000'>"+cantidadTotal+"</span></td></tr>");
                                                out.println("<tr><td style='border-left: solid #a80077 1px;' class='' align='right' ><span class='textHeaderClassBody'>TOTAL INSPECCIONADOS:</span></td>");
                                                for(int cantidad:cantidades)out.println("<td align='center' style=''><span class='textHeaderClassBody' style='display:inherit;'>"+cantidad+"</span></td>");
                                                out.println("<td align='center' style='border-right: solid #a80077 1px;'><span class='textHeaderClassBody' style='display:inherit;'>"+cantidadTotalInspeccionados+"</span></td></tr>");
                                                out.println("<tr><td style='border-left: solid #a80077 1px;border-bottom: solid #a80077 1px;border-bottom-left-radius:10px;' class='' align='right' ><span class='textHeaderClassBody' >TOTAL BUENOS:</span></td>");
                                                for(int i=0;i<cantOperarios;i++)out.println("<td align='center' style='border-bottom: solid #a80077 1px ;'><span class='textHeaderClassBody' style='display:inherit'>"+(cantidades.get(i)-subTotales[i])+"</span></td>");
                                                out.println("<td align='center' style='border-right: solid #a80077 1px;border-bottom: solid #a80077 1px;border-bottom-right-radius:10px;'><span class='textHeaderClassBody' style='display:inherit;'>"+(cantidadTotalInspeccionados-cantidadTotal)+"</span></td>"+
                                                           "</tr></table>");
                                  %>
                            </div>
                         </div>
                         <center>
                            <table  style='border:none;width:100%' cellpadding='0' cellspacing='0' >
                                <tr >
                                    <td colspan="5" class='tableHeaderClass' style='border-top-left-radius:10px;border-top-right-radius:10px' ><span class='textHeaderClass'>Tiempos de inspeccion</span></td>
                                </tr>
                                <tr >
                                    <td class='tableHeaderClass'  ><span class='textHeaderClass'>Operario</span></td>
                                    <td class='tableHeaderClass'  ><span class='textHeaderClass'>Fecha</span></td>
                                    <td class='tableHeaderClass'  ><span class='textHeaderClass'>Hora Inicio</span></td>
                                    <td class='tableHeaderClass'  ><span class='textHeaderClass'>Hora Final</span></td>
                                    <td class='tableHeaderClass'  ><span class='textHeaderClass'>Horas Hombre</span></td>
                                </tr>
                                <%
                                    consulta="select distinct sppp.COD_PERSONAL,isnull((p.AP_PATERNO_PERSONAL + ' ' + p.AP_MATERNO_PERSONAL + ' ' +p.NOMBRES_PERSONAL+' '+p.nombre2_personal),"+
                                             " (pt.AP_PATERNO_PERSONAL + ' ' + pt.AP_MATERNO_PERSONAL + ' ' +pt.NOMBRES_PERSONAL+' '+pt.nombre2_personal+'(temporal)')) AS nombrePersonal" +
                                                 ",sppp.FECHA_INICIO,sppp.FECHA_FINAL,sppp.HORAS_HOMBRE" +
                                                 " from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sppp" +
                                                 " left outer join personal p on p.cod_personal = sppp.cod_personal"+
                                                 " left outer join PERSONAL_TEMPORAL pt on pt.COD_PERSONAL=sppp.COD_PERSONAL"+
                                                 " where sppp.COD_PROGRAMA_PROD='"+codprogramaProd+"'"+
                                                 " and sppp.COD_LOTE_PRODUCCION='"+codLote+"'"+
                                                 " and sppp.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"'"+
                                                 " and sppp.COD_COMPPROD='"+codCompProd+"'"+
                                                 " and sppp.COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"'"+
                                                 " and sppp.COD_ACTIVIDAD_PROGRAMA='"+codActividadInspeccion+"'" +
                                                 " order by sppp.FECHA_INICIO";
                                    System.out.println("consulta cargar tiempos "+consulta);
                                    res=st.executeQuery(consulta);
                                    while(res.next())
                                    {
                                        out.println("<tr><td class='tableCell'><span style='font-weight:normal' class='textHeaderClassBody'>"+res.getString("nombrePersonal")+"</span></td>" +
                                                    "<td class='tableCell' align='center'><span style='font-weight:normal' class='textHeaderClassBody'>"+sdfDias.format(res.getTimestamp("FECHA_INICIO"))+"</span></td>" +
                                                    "<td class='tableCell' align='center'><span style='font-weight:normal' class='textHeaderClassBody'>"+sdfHora.format(res.getTimestamp("FECHA_INICIO"))+"</span></td>" +
                                                    "<td class='tableCell' align='center'><span style='font-weight:normal' class='textHeaderClassBody'>"+sdfHora.format(res.getTimestamp("FECHA_FINAL"))+"</span></td>" +
                                                    "<td class='tableCell' align='center'><span style='font-weight:normal' class='textHeaderClassBody'>"+format.format(res.getDouble("HORAS_HOMBRE"))+"</span></td></tr>");
                                    }

                                %>
                            </table>

                         </center>
                    
                    <%
                        consulta="select (p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL+' '+p.nombre2_personal) as nombrePersonal"+
                                 " from PERSONAL p where p.COD_PERSONAL='"+(codPersonalCierre>0?codPersonalCierre:codPersonal)+"'";
                        res=st.executeQuery(consulta);
                        String nombrePersonalAprueba="";
                        if(res.next())nombrePersonalAprueba=res.getString("nombrePersonal");
                        consulta="select sum(s.CANT_AMPOLLAS_ACOND) as cantAcond,sum(s.CANT_AMPOLLAS_CC) as cantCC," +
                                " sum(s.CANT_AMPOLLAS_CARBONES) as cantCarbones,sum(s.CANT_AMPOLLAS_ROTAS) as cantRotas " +
                                " from SEGUIMIENTO_CONTROL_DOSIFICADO_LOTE_PERSONAL s " +
                                " where s.COD_SEGUIMIENTO_CONTROL_DOSIFICADO_LOTE = '"+codSeguimientoControlDosificado+"'";
                        System.out.println("consulta ep"+consulta);
                        int cantidadEnviadaProduccion=0;
                        res=st.executeQuery(consulta);
                        if(res.next())cantidadEnviadaProduccion=(res.getInt("cantAcond")-res.getInt("cantCC")-res.getInt("cantCarbones")-res.getInt("cantRotas"));
                        consulta="select sum(s.CANTIDAD_AMPOLLAS_ROTAS) as sumaCantidad"+
                                          " from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL s where s.COD_SEGUIMIENTO_LAVADO_LOTE_ACOND='"+codSeguimientoLavadoAcond+"'";
                        /*res=st.executeQuery(consulta);
                        int cantidadAmpollasRotas=0;
                        if(res.next())cantidadAmpollasRotas=res.getInt("sumaCantidad");*/
                            

                    %>
                    <table style="width:80%;margin-top:2px;border-bottom:solid #a80077 1px;" id="dataDetalle" cellpadding="0px" cellspacing="0px" >
                        <tr >
                               <td class="tableHeaderClass" style="text-align:center" >
                                   <span class="textHeaderClass">Descripcion</span>
                               </td>
                               <td class="tableHeaderClass" style="text-align:center" >
                                   <span class="textHeaderClass">Cantidad</span>
                               </td>
                        </tr>
                        <tr>
                            <td class='tableCell'><span class='textHeaderClassBody' style="font-weight:normal">CANTIDAD DE AMPOLLAS RECIBIDAS</span></td>
                            <td class='tableCell'><span class='textHeaderClassBody' style="font-weight:normal"><%=(cantidadEnviadaProduccion)%></span></td>
                        </tr>
                        <tr>
                            <td class='tableCell'><span class='textHeaderClassBody' style="font-weight:normal">AMPOLLAS SUCIAS</span></td>
                            <td class='tableCell'><span class='textHeaderClassBody' style="font-weight:normal"><%=(cantidadTotal)%></span></td>
                        </tr>
                        
                        <tr>
                            <td class='tableCell'><span class='textHeaderClassBody' style="font-weight:normal">AMPOLLAS APROBADAS EN INSPECCION</span></td>
                            <td class='tableCell'><span class='textHeaderClassBody' style="font-weight:normal"><%=(cantidadTotalInspeccionados-cantidadTotal)%></span></td>
                        </tr>
                    </table>
                    <table style="width:60%;margin-top:2%" id="dataRendimiento" cellpadding="0px" cellspacing="0px">
                          <tr>
                               <tr>
                                       <td class="tableHeaderClass"  style="text-align:left" >
                                           <span class="textHeaderClass">% RENDIMIENTO=</span>
                                       </td>
                                       <td class="tableCell" style="text-align:center;width:30%">
                                           <span class="textHeaderClassBody" id="spanRendimiento" style="font-weight:normal">
                                               <%=(cantidadEnviadaProduccion>0?Math.round(Double.valueOf(cantidadTotalInspeccionados-cantidadTotal)/Double.valueOf(cantidadEnviadaProduccion)*10000)/100d:0)%>
                                           </span>
                                       </td>
                                       <td class="tableHeaderClass"  style="text-align:left" >
                                           <span class="textHeaderClass">%</span>
                                       </td>
                               </tr>
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
                                    <button class="small button succes radius buttonAction" onclick="guardarInspeccionAmpollasDosificado(false);" >Guardar</button>
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
    <script>iniciarDatePicker('<%=(sdfDias.format(new Date()))%>');loginHoja.verificarHojaCerrada('cerrado', admin,'codprogramaProd','codLoteSeguimiento',8,<%=(codEstadoHoja)%>);</script>
</html>
