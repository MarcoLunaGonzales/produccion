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
<script src="../../reponse/js/variables.js"></script>
<script src="../../reponse/js/utiles.js"></script>
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
    .division
    {
        background-color:#ebcfe8;
        font-size:0.3em !important;
    }
    .procesado
    {
        background-color:green;
    }
    .solicitud
    {
        background-color:#90EE90;
    }
</style>
<script type="text/javascript">
    function guardarDevolucionMaterial()
    {
        iniciarProgresoSistema();
        var tablaDevolucion=document.getElementById("dataSolicitudDevolucion");
        var dataCodDevolucion=new Array();
        var dataEtiquetas=new Array();
        var incrementar=0;
        for(var i=3;i<tablaDevolucion.rows.length;i++)
        {
            incrementar=0;
            if(tablaDevolucion.rows[i].cells.length>7)
                incrementar=6;
            
               if((parseInt(tablaDevolucion.rows[i].cells.length)>1)&&
                 (parseInt(tablaDevolucion.rows[i].cells[incrementar+4].getElementsByTagName("span")[0].innerHTML)>0||
                  parseInt(tablaDevolucion.rows[i].cells[incrementar+5].getElementsByTagName("span")[0].innerHTML)>0||
                  parseInt(tablaDevolucion.rows[i].cells[incrementar+6].getElementsByTagName("span")[0].innerHTML)>0))
               {
                    
                    dataEtiquetas[dataEtiquetas.length]=tablaDevolucion.rows[i].cells[0+incrementar].getElementsByTagName("input")[0].value;
                    dataEtiquetas[dataEtiquetas.length]=parseInt(tablaDevolucion.rows[i].cells[incrementar+4].getElementsByTagName("span")[0].innerHTML);
                    dataEtiquetas[dataEtiquetas.length]=parseInt(tablaDevolucion.rows[i].cells[incrementar+5].getElementsByTagName("span")[0].innerHTML);
                    dataEtiquetas[dataEtiquetas.length]=parseInt(tablaDevolucion.rows[i].cells[incrementar+6].getElementsByTagName("span")[0].innerHTML);
                    var encontrado=false;
                    var codSalida=tablaDevolucion.rows[i].cells[0+incrementar].getElementsByTagName("input")[0].value.split("-")[0];
                    for(var j=0;j<dataCodDevolucion.length;j+=2)
                   {
                       if(parseInt(dataCodDevolucion[j])==codSalida)
                       {
                           encontrado=true;
                       }
                   }
                   if(!encontrado)
                   {
                        dataCodDevolucion[dataCodDevolucion.length]=codSalida;
                   }
               }
        }
        ajax=nuevoAjax();
        var peticion="ajaxAprobarGenerarSolicitudDevolucion.jsf?"+
             "codLote="+codLoteGeneral+"&noCache="+ Math.random()+"&date="+(new Date().getTime()).toString()+
             "&codprogramaProd="+codProgramaProdGeneral+
             "&codFormulaMaestra="+codFormulaMaestraGeneral+
             "&codTipoProgramaProd="+codTipoProgramaProdGeneral+
             "&codCompProd="+codComprodGeneral+
             "&dataCodDevolucion="+dataCodDevolucion+
             "&dataEtiquetas="+dataEtiquetas+
             "&admin="+(administradorSistema?1:0)+
             "&codPersonalUsuario="+codPersonalGeneral+
             (admin?"&observacion="+encodeURIComponent(document.getElementById("observacion").value):"");

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
                            alert('Se registro la devolucion de Material');
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
        //datos personal
        int codPersonal=Integer.valueOf(request.getParameter("codPersonal"));
        int codTipoPermiso=Integer.valueOf(request.getParameter("codTipoPermiso"));
        //cargando datos del lote
        int codprogramaProd=Integer.valueOf(request.getParameter("codProgramaProd"));
        int codTipoProgramaProd=Integer.valueOf(request.getParameter("codTipoProgramaProd"));
        int codCompProd=Integer.valueOf(request.getParameter("codCompProd"));
        String codLote=request.getParameter("codLote");
        
        
        out.println("<script type='text/javascript'>codPersonal="+codPersonal+";" +
                   "codTipoPermiso="+codTipoPermiso+";</script>");
        int codEstadoHoja=0;
        out.println("<title>("+codLote+")DEVOLUCION DE MATERIAL</title>");
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
        String indicacionesDevolucionMaterial="";
        //out.println("<script>sqlConnection.verificarRegistroPendiente('"+codprogramaProd+"','"+codLote+"',3)</script>");
        //datos propios de la hoja
        int codSeguimientoDevolucionMaterial=0;
        int codSeguimientoRecepcionMaterial=0;
        try
        {
                Connection con=null;
                con=Util.openConnection(con);
                Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                StringBuilder consulta=new StringBuilder("select pp.cod_formula_maestra,cp.nombre_prod_semiterminado,ff.nombre_forma,");
                                                consulta.append(" cp.VIDA_UTIL,pp.CANT_LOTE_PRODUCCION,tpp.NOMBRE_TIPO_PROGRAMA_PROD," );
                                                consulta.append(" isnull(sdela.COD_SEGUIMIENTO_DEVOLUCION_ES_LOTE_ACOND, 0) AS COD_SEGUIMIENTO_DEVOLUCION_ES_LOTE_ACOND,");
                                                consulta.append(" ISNULL(sdela.COD_PERSONAL_SUPERVISOR, 0) AS COD_PERSONAL_SUPERVISOR,");
                                                consulta.append(" ISNULL(sdela.OBSERVACIONES, '') AS OBSERVACIONES,");
                                                consulta.append(" sdela.FECHA_CIERRE,");
                                                consulta.append(" isnull(seela.COD_SEGUIMIENTO_ENTREGA_ES_LOTE_ACOND, 0) as COD_SEGUIMIENTO_ENTREGA_ES_LOTE_ACOND" );
                                                consulta.append(" ,isnull(dpff.ACOND_INDICACIONES_DEVOLUCION_MATERIAL,'') as ACOND_INDICACIONES_DEVOLUCION_MATERIAL");
                                        consulta.append(" from PROGRAMA_PRODUCCION pp inner join componentes_prod cp on ");
                                                consulta.append(" cp.COD_COMPPROD=pp.COD_COMPPROD ");
                                                consulta.append(" inner join FORMAS_FARMACEUTICAS ff on ff.cod_forma=cp.COD_FORMA");
                                                consulta.append(" inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD" );
                                                consulta.append(" left outer join DESCRIPCION_PROCESOS_FORMA_FARMACEUTICA dpff on dpff.COD_FORMA=cp.COD_FORMA");
                                                consulta.append(" LEFT OUTER JOIN SEGUIMIENTO_ENTREGA_ES_LOTE_ACOND seela on seela.cod_lote =pp.COD_LOTE_PRODUCCION" );
                                                consulta.append(" and seela.COD_PROGRAMA_PROD = pp.COD_PROGRAMA_PROD");
                                                consulta.append(" and pp.COD_COMPPROD=seela.COD_COMPPROD and pp.COD_TIPO_PROGRAMA_PROD=seela.COD_TIPO_PROGRAMA_PROD");
                                                consulta.append(" LEFT OUTER JOIN SEGUIMIENTO_DEVOLUCION_ES_LOTE_ACOND sdela on");
                                                consulta.append(" sdela.cod_lote = pp.COD_LOTE_PRODUCCION and sdela.COD_PROGRAMA_PROD =pp.COD_PROGRAMA_PROD");
                                                consulta.append(" and sdela.COD_COMPPROD=pp.COD_COMPPROD and sdela.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD");
                                        consulta.append(" where pp.COD_LOTE_PRODUCCION='").append(codLote).append("'");
                                                consulta.append(" and pp.COD_PROGRAMA_PROD=").append(codprogramaProd);
                                                consulta.append(" and pp.COD_COMPPROD=").append(codCompProd);
                                                consulta.append(" and pp.COD_TIPO_PROGRAMA_PROD=").append(codTipoProgramaProd);
                System.out.println("consulta cargar datos del lote "+consulta.toString());
                ResultSet res=st.executeQuery(consulta.toString());
                if(res.next())
                {
                    indicacionesDevolucionMaterial=res.getString("ACOND_INDICACIONES_DEVOLUCION_MATERIAL");
                    fechaCierre=(res.getTimestamp("FECHA_CIERRE")!=null?res.getTimestamp("FECHA_CIERRE"):new Date());
                    codPersonalCierre=res.getInt("COD_PERSONAL_SUPERVISOR");
                    observaciones=res.getString("OBSERVACIONES");
                    codSeguimientoDevolucionMaterial=res.getInt("COD_SEGUIMIENTO_DEVOLUCION_ES_LOTE_ACOND");
                    codSeguimientoRecepcionMaterial=res.getInt("COD_SEGUIMIENTO_ENTREGA_ES_LOTE_ACOND");
                    codFormulaMaestra=res.getInt("cod_formula_maestra");
                    %>
                    

<section class="main">
                         <div class="row"  style="margin-top:5px" >
                                <div class="large-12 medium-12 small-12 large-centered medium-centered small-centered columns" >

                                            <div class="row">
                                               <div class="large-12 medium-12 small-12 columns divHeaderClass" >
                                                       <label  class="inline">Devolución de Material de Acondicionamiento</label>
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
                                   <label  class="inline">Devolución de Material de Acondicionamiento</label>
                            </div>
                        </div>
                        <div class="row" >

                        <div  class="divContentClass large-12 medium-12 small-12 columns" style="padding-top:1em;">
                
                        <span ><%=(indicacionesDevolucionMaterial)%></span>
                        
                        
                    <center>
                         <div class="row" style="margin-top:1em;">
                            <div class="large-12 medium-12 small-12 large-centered medium-centered small-centered columns">
                                <table  style="border:none;width:100%;margin-top:4px;" id="dataDevolucion" cellpadding="0px" cellspacing="0px">
                                        <tr>
                                            <td class='tableHeaderClass prim' style='text-align:center;' rowspan="2" ><span class='textHeaderClass'>Material</span></td>
                                            
                                        <%
                                        consulta=new StringBuilder("select distinct p.COD_PERSONAL,(p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL) as nombrePersonal");
                                                    consulta.append(" from PERSONAL p inner join SEGUIMIENTO_DEVOLUCION_ES_LOTE_ACOND_MATERIALES sde");
                                                    consulta.append(" on sde.COD_PERSONAL=p.COD_PERSONAL");
                                                    consulta.append(" where sde.COD_SEGUIMIENTO_DEVOLUCION_ES_LOTE_ACOND=").append(codSeguimientoDevolucionMaterial);
                                                    consulta.append(" order by 2");
                                        //System.out.println("consulta");
                                        res=st.executeQuery(consulta.toString());
                                        consulta=new StringBuilder("select m.NOMBRE_MATERIAL");
                                        String subconsulta="";
                                        String condiciones="";
                                        int contDetalle=0;
                                        while(res.next())
                                        {
                                            out.println("<td class='tableHeaderClass' style='text-align:center;' colspan='4' ><span class='textHeaderClass'>"+res.getString("nombrePersonal")+"</span></td>");
                                            contDetalle++;
                                            consulta.append(",sdel").append(res.getRow()).append(".CANTIDAD_DEVUELTA as CANTIDAD_DEVUELTA").append(res.getRow());
                                            consulta.append(",sdel").append(res.getRow()).append(".CANTIDAD_FRV as CANTIDAD_FRV").append(res.getRow());
                                            consulta.append(",sdel").append(res.getRow()).append(".CANTIDAD_FRV_PROVEEDOR as CANTIDAD_FRV_PROVEEDOR").append(res.getRow());
                                            consulta.append(",sdel").append(res.getRow()).append(".OBSERVACIONES as OBSERVACIONES").append(res.getRow());
                                            subconsulta+=" left outer join SEGUIMIENTO_DEVOLUCION_ES_LOTE_ACOND_MATERIALES sdel"+res.getRow()+" on"+
                                                        " sdel"+res.getRow()+".COD_MATERIAL=m.COD_MATERIAL and sdel"+res.getRow()+".COD_PERSONAL='"+res.getInt("COD_PERSONAL")+"'"+
                                                        " and sdel"+res.getRow()+".COD_SEGUIMIENTO_DEVOLUCION_ES_LOTE_ACOND='"+codSeguimientoDevolucionMaterial+"'";
                                            condiciones+=(condiciones.equals("")?"":" or ")+" sdel"+res.getRow()+".CANTIDAD_DEVUELTA>0 or sdel"+res.getRow()+".CANTIDAD_FRV>0"+
                                                        " or sdel"+res.getRow()+".CANTIDAD_FRV_PROVEEDOR > 0 or sdel"+res.getRow()+".OBSERVACIONES <> '' ";
                                        }
                                        out.println("</tr>");
                                        for(int i=0;i<contDetalle;i++)out.println("<td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>Cantidad<br>Devuelta</span></td>"+
                                                                                  "<td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>Cantidad<br>FRV</span></td>"+
                                                                                  "<td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>Cantidad<br>FRV<br>Proveedor</span></td>"+
                                                                                  "<td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>Obs.</span></td>");
                                        consulta.append(" from MATERIALES m ").append(subconsulta).append(" where m.COD_MATERIAL in (select  seel.COD_MATERIAL from SEGUIMIENTO_ENTREGA_ES_LOTE_ACOND_MATERIALES seel");
                                                  consulta.append(" where seel.COD_SEGUIMIENTO_ENTREGA_ES_LOTE_ACOND = ").append(codSeguimientoRecepcionMaterial);
                                                  consulta.append(" and (").append(condiciones).append(")) order by m.NOMBRE_MATERIAL");
                                        System.out.println("consulta materiales "+consulta.toString());
                                        res=st.executeQuery(consulta.toString());
                                        while(res.next())
                                        {
                                            out.println("<tr><td class='tableCell' style='text-align:center'>" +
                                                        "<span class='tableHeaderClassBody'>"+(res.getString("NOMBRE_MATERIAL"))+"</span></td>");
                                            for(int i=1;i<=contDetalle;i++)
                                            {
                                                out.println("<td class='tableCell' style='text-align:center'><span class='tableHeaderClassBody'>"+res.getInt("CANTIDAD_DEVUELTA"+i)+"</span></td>" +
                                                            "<td class='tableCell' style='text-align:center'><span class='tableHeaderClassBody'>"+res.getInt("CANTIDAD_FRV"+i)+"</span></td>"+
                                                            "<td class='tableCell' style='text-align:center'><span class='tableHeaderClassBody'>"+res.getInt("CANTIDAD_FRV_PROVEEDOR"+i)+"</span></td>"+
                                                            "<td class='tableCell' style='text-align:center'><span class='tableHeaderClassBody'>"+res.getString("OBSERVACIONES"+i)+"</span></td>");
                                            }
                                            out.println("</tr>");
                                        }

                                        %>
                                </table>
                                <table  style="border:none;width:100%;margin-top:4px;" id="dataSolicitudDevolucion" cellpadding="0px" cellspacing="0px">
                                        <tr>
                                            <td class='tableHeaderClass prim ult' style='text-align:center;' colspan="13"><span class='textHeaderClass'>Solicitud de Devolucion</span></td>
                                        </tr>
                                        <tr>
                                            <td class='tableHeaderClass' style='text-align:center;' rowspan="2" ><span class='textHeaderClass'>Material</span></td>
                                            <td class='tableHeaderClass' style='text-align:center;' rowspan="2" ><span class='textHeaderClass'>Cantidad<br>Item<br>Salida</span></td>
                                            <td class='tableHeaderClass' style='text-align:center;' colspan="3" ><span class='textHeaderClass'>Devolucion OM</span></td>
                                            <td class='tableHeaderClass' style='text-align:center;'rowspan="2" ><span class='textHeaderClass'>U.</span></td>
                                            <td class='tableHeaderClass' style='text-align:center;' rowspan="2" ><span class='textHeaderClass'>Nro<br>Salida</span></td>
                                            <td class='tableHeaderClass' style='text-align:center;' rowspan="2" ><span class='textHeaderClass'>Nro<br>Ingreso</span></td>
                                            <td class='tableHeaderClass' style='text-align:center;' rowspan="2"><span class='textHeaderClass'>Cant.<br>Salida</span></td>
                                            <td class='tableHeaderClass' style='text-align:center;' rowspan="2"><span class='textHeaderClass'>Cant.<br>Devuelta</span></td>
                                            <td class='tableHeaderClass' style='text-align:center;' colspan="3"><span class='textHeaderClass'>Cant.<br>Solicitud Devolucion</span></td>
                                            
                                        </tr>
                                        <tr>
                                            <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>Dev.</span></td>
                                            <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>Frv</span></td>
                                            <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>Frv<br>Prov.</span></td>
                                            <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>Buenos</span></td>
                                            <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>FRV</span></td>
                                            <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>FRV Prov</span></td>
                                            
                                        </tr>
                                        <%
                                        consulta=new StringBuilder("select m.COD_MATERIAL,m.NOMBRE_MATERIAL,salida.cantidadSalida,sum(sdel.CANTIDAD_DEVUELTA) as cantidadDevuelta");
                                                            consulta.append(" ,sum(sdel.CANTIDAD_FRV_PROVEEDOR) as cantidadFRVProveedor,sum(sdel.CANTIDAD_FRV) as cantidadFRV,salida.ABREVIATURA,salida.COD_UNIDAD_MEDIDA");
                                                 consulta.append(" from SEGUIMIENTO_DEVOLUCION_ES_LOTE_ACOND_MATERIALES sdel inner join materiales m on ");
                                                            consulta.append(" sdel.COD_MATERIAL=m.COD_MATERIAL");
                                                            consulta.append(" outer apply(select SUM(sad.CANTIDAD_SALIDA_ALMACEN) as cantidadSalida,um.COD_UNIDAD_MEDIDA,um.ABREVIATURA");
                                                            consulta.append(" from SALIDAS_ALMACEN_DETALLE sad inner join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=sad.COD_UNIDAD_MEDIDA");
                                                            consulta.append(" where sad.COD_MATERIAL=sdel.COD_MATERIAL and ");
                                                            consulta.append(" cast(sad.COD_SALIDA_ALMACEN as varchar)+' '+cast(sad.COD_MATERIAL as varchar) in (");
                                                            consulta.append(" select cast(s.COD_SALIDA_ALMACEN as varchar)+' '+cast(s.COD_MATERIAL as varchar) from SEGUIMIENTO_ENTREGA_ES_LOTE_ACOND_MATERIALES s");
                                                            consulta.append(" where s.COD_SEGUIMIENTO_ENTREGA_ES_LOTE_ACOND = ").append(codSeguimientoRecepcionMaterial).append(")" );
                                                            consulta.append(" group by um.COD_UNIDAD_MEDIDA,um.ABREVIATURA) salida");
                                                 consulta.append(" where sdel.COD_SEGUIMIENTO_DEVOLUCION_ES_LOTE_ACOND=").append(codSeguimientoDevolucionMaterial);
                                                 consulta.append(" group  by m.COD_MATERIAL,m.NOMBRE_MATERIAL,salida.cantidadSalida,salida.ABREVIATURA,salida.COD_UNIDAD_MEDIDA" );
                                                 consulta.append(" order by m.NOMBRE_MATERIAL");
                                        System.out.println("consulta cargar devoluciones "+consulta.toString());
                                        res=st.executeQuery(consulta.toString());
                                        Statement stDetalle=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                        ResultSet resDetalle=null;
                                        String innerHTMLDetalle="";
                                        while(res.next())
                                        {
                                            int cantidadDevolver=res.getInt("cantidadDevuelta");
                                            int cantidadFrvProovedor=res.getInt("cantidadFRVProveedor");
                                            int cantidadFRv=res.getInt("cantidadFRV");
                                            consulta=new StringBuilder("select sadi.COD_SALIDA_ALMACEN,sa.NRO_SALIDA_ALMACEN,ia.COD_INGRESO_ALMACEN,ia.NRO_INGRESO_ALMACEN,sadi.CANTIDAD,");
                                                     consulta.append(" devolucion.cantidadDevuelta,sadi.ETIQUETA");
                                                     consulta.append(" from SALIDAS_ALMACEN_DETALLE_INGRESO sadi inner join  INGRESOS_ALMACEN ia on sadi.COD_INGRESO_ALMACEN=ia.COD_INGRESO_ALMACEN");
                                                     consulta.append(" inner join SALIDAS_ALMACEN sa on sa.COD_SALIDA_ALMACEN=sadi.COD_SALIDA_ALMACEN");
                                                     consulta.append(" outer apply( select sum(dde.CANTIDAD_DEVUELTA + dde.CANTIDAD_FALLADOS + dde.cantidad_fallados_proveedor) as cantidadDevuelta");
                                                     consulta.append(" from DEVOLUCIONES d inner join DEVOLUCIONES_DETALLE dd on dd.COD_DEVOLUCION = d.COD_DEVOLUCION");
                                                     consulta.append(" inner join DEVOLUCIONES_DETALLE_ETIQUETAS dde on dde.COD_DEVOLUCION = dd.COD_DEVOLUCION" );
                                                     consulta.append(" and dde.COD_MATERIAL = dd.COD_MATERIAL where d.COD_ESTADO_DEVOLUCION = 1" );
                                                     consulta.append(" and d.COD_SALIDA_ALMACEN = sadi.COD_SALIDA_ALMACEN and dd.COD_MATERIAL = sadi.COD_MATERIAL" );
                                                     consulta.append(" and dde.COD_INGRESO_ALMACEN = ia.COD_INGRESO_ALMACEN and dde.ETIQUETA = sadi.ETIQUETA) devolucion");
                                                     consulta.append(" where sadi.COD_SALIDA_ALMACEN in (select s.COD_SALIDA_ALMACEN from SEGUIMIENTO_ENTREGA_ES_LOTE_ACOND_MATERIALES s");
                                                     consulta.append(" where s.COD_MATERIAL=").append(res.getInt("COD_MATERIAL"));
                                                     consulta.append(" and s.COD_SEGUIMIENTO_ENTREGA_ES_LOTE_ACOND=").append(codSeguimientoRecepcionMaterial).append(") and sadi.COD_MATERIAL=").append(res.getInt("COD_MATERIAL"));
                                                     consulta.append(" order by sa.NRO_SALIDA_ALMACEN,ia.NRO_INGRESO_ALMACEN");
                                            System.out.println("consulta detalle etiquetas "+consulta.toString());
                                            resDetalle=stDetalle.executeQuery(consulta.toString());
                                            innerHTMLDetalle="";
                                            while(resDetalle.next())
                                            {
                                                int cantidadDisponible=resDetalle.getInt("CANTIDAD")-resDetalle.getInt("cantidadDevuelta");
                                                innerHTMLDetalle+=(innerHTMLDetalle.equals("")?"":"<tr>")+
                                                                 "<td class='tableCell'  style='text-align:center'><input type='hidden' value='"+resDetalle.getInt("COD_SALIDA_ALMACEN")+"-"+resDetalle.getInt("COD_INGRESO_ALMACEN")+"-"+res.getInt("COD_MATERIAL")+"-"+resDetalle.getInt("ETIQUETA")+"-so"+resDetalle.getInt("COD_SALIDA_ALMACEN")+"'/><span class='tableHeaderClassBody'>"+resDetalle.getInt("NRO_SALIDA_ALMACEN")+"</span></td>"+
                                                                 "<td class='tableCell'  style='text-align:center'><span class='tableHeaderClassBody'>"+resDetalle.getInt("NRO_INGRESO_ALMACEN")+"</span></td>"+
                                                                 "<td class='tableCell'  style='text-align:center'><span class='tableHeaderClassBody'>"+resDetalle.getInt("CANTIDAD")+"</span></td>"+
                                                                 "<td class='tableCell'  style='text-align:center'><span class='tableHeaderClassBody'>"+resDetalle.getInt("cantidadDevuelta")+"</span></td>"+
                                                                 "<td class='tableCell solicitud'  style='text-align:center'><span class='tableHeaderClassBody'>"+(cantidadDevolver<cantidadDisponible?cantidadDevolver:cantidadDisponible)+"</span></td>";
                                               if(cantidadDevolver>cantidadDisponible)
                                               {
                                                   cantidadDevolver-=cantidadDisponible;
                                                   cantidadDisponible=0;
                                               }
                                                else
                                                {
                                                    cantidadDisponible-=cantidadDevolver;
                                                    cantidadDevolver=0;
                                                }
                                                innerHTMLDetalle+="<td class='tableCell solicitud'  style='text-align:center'><span class='tableHeaderClassBody'>"+(cantidadFRv<cantidadDisponible?cantidadFRv:cantidadDisponible)+"</span></td>";
                                                if(cantidadFRv>cantidadDisponible)
                                               {
                                                   cantidadFRv-=cantidadDisponible;
                                                   cantidadDisponible=0;
                                               }
                                                else
                                                {
                                                    cantidadDisponible-=cantidadFRv;
                                                    cantidadFRv=0;
                                                }
                                                innerHTMLDetalle+="<td class='tableCell solicitud'  style='text-align:center'><span class='tableHeaderClassBody'>"+(cantidadFrvProovedor<cantidadDisponible?cantidadFrvProovedor:cantidadDisponible)+"</span></td>";
                                                if(cantidadFrvProovedor>cantidadDisponible)
                                               {
                                                   cantidadFrvProovedor-=cantidadDisponible;
                                                   cantidadDisponible=0;
                                               }
                                                else
                                                {
                                                    cantidadDisponible-=cantidadFrvProovedor;
                                                    cantidadFrvProovedor=0;
                                                }
                                                innerHTMLDetalle+="</tr>";
                                            }
                                            resDetalle.last();
                                            out.println("<tr>" +
                                                        "<td rowspan='"+resDetalle.getRow()+"' class='tableCell'  style='text-align:center'><input type='hidden' value='"+res.getInt("COD_MATERIAL")+"'/>"+
                                                        "<span class='tableHeaderClassBody'>"+(res.getString("NOMBRE_MATERIAL"))+"</span></td>" +
                                                        "<td rowspan='"+resDetalle.getRow()+"' class='tableCell'  style='text-align:center'><span class='tableHeaderClassBody'>"+(res.getInt("cantidadSalida"))+"</span></td>" +
                                                        "<td rowspan='"+resDetalle.getRow()+"' class='tableCell'  style='text-align:center'><span class='tableHeaderClassBody'>"+(res.getInt("cantidadDevuelta"))+"</span></td>" +
                                                        "<td rowspan='"+resDetalle.getRow()+"' class='tableCell'  style='text-align:center'><span class='tableHeaderClassBody'>"+(res.getInt("cantidadFRV"))+"</span></td>" +
                                                        "<td rowspan='"+resDetalle.getRow()+"' class='tableCell'  style='text-align:center'><span class='tableHeaderClassBody'>"+(res.getInt("cantidadFRVProveedor"))+"</span></td>" +
                                                        "<td rowspan='"+resDetalle.getRow()+"' class='tableCell'  style='text-align:center'><span class='tableHeaderClassBody'>"+(res.getString("ABREVIATURA"))+"</span></td>" +
                                                        innerHTMLDetalle+
                                                        "<tr><td class='tableCell division' colspan=13>&nbsp;</td></tr>");
                                        }
                                        %>
                                </table>
                            </div>
                         </div>
                         <center>
                            

                         </center>
                    <input type="hidden" value="<%=(codPersonalCierre)%>" id="cerrado"/>
                    <%
                    if(codTipoPermiso==12)
                    {
                         out.println(UtilidadesTablet.innerHTMLAprobacionJefe(st,(codPersonalCierre>0?codPersonalCierre:codPersonal),sdfDias.format(new Date()),sdfHora.format(new Date()),observaciones));
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
                                    <button class="small button succes radius buttonAction" onclick="guardarDevolucionMaterial();" >Guardar</button>
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
    <div  id="formsuper"  class="formSuper" />
        <input  type="hidden" id="codSeguimientoDevolucionMaterial" value="<%=(codSeguimientoDevolucionMaterial)%>">
    </section>
    </body>
    <script src="../../reponse/js/timePickerJs.js"></script>
    <script src="../../reponse/js/dataPickerJs.js"></script>
    <script>iniciarDatePicker('<%=(sdfDias.format(new Date()))%>');
        loginHoja.verificarHojaCerradaAcond('cerrado', admin, 7,<%=(codEstadoHoja)%>);
    </script>
</html>
