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
<link rel="STYLESHEET" type="text/css" href="../../reponse/css/timePickerCSs.css" />
<link rel="STYLESHEET" type="text/css" href="../../reponse/css/mensajejs.css" />
<script src="../../reponse/js/variables.js"></script>
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
    function guardarRendimiento()
    {
        iniciarProgresoSistema()
        ajax=nuevoAjax();
        var peticion="ajaxGuardarRendimientoFinal.jsf?"+
             "codLote="+codLoteGeneral+"&noCache="+ Math.random()+"&date="+(new Date().getTime()).toString()+
             "&codprogramaProd="+codProgramaProdGeneral+
             "&codFormulaMaestra="+codFormulaMaestraGeneral+
             "&codTipoProgramaProd="+codTipoProgramaProdGeneral+
             "&codCompProd="+codComprodGeneral+
             "&codTipoPermiso="+(codTipoPermiso)+
             
             "&codPersonalUsuario="+codPersonalGeneral+
             (administradorSistema?"&observacion="+document.getElementById("observacion").value:"");

        ajax.open("GET",peticion,true);
        ajax.setRequestHeader('content-type', 'application/x-www-form-urlencoded;charset=UTF-8');
                 ajax.onreadystatechange=function(){
                    if (ajax.readyState==4) {
                        if(ajax.responseText==null || ajax.responseText=='')
                        {
                            terminarProgresoSistema();
                            alertJs('No se puede conectar con el servidor, verfique su conexión a internet');
                            if(confirm("Desea guardar la informacion localmente?\nLa informacion del lote no se perdera pero debe de subirla despues"))
                            {
                                sqlConnection.insertarRegistroAuxiliar(document.getElementById("codprogramaProd").value, codLote,3,("../registroEtapaLavado/"+peticion),function(){window.close();});
                            }
                            return false;
                        }
                        if(parseInt(ajax.responseText.split("\n").join(""))=='1')
                        {
                            terminarProgresoSistema();
                            mensajeJs('Se registro la aprobacion del rendimiento',function()
                            {window.close();});
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
        String codAreaEmpresaPersonal=request.getParameter("codAreaEmpresa");
        
        String codprogramaProd=request.getParameter("codProgramaProd");
        String codTipoProgramaProd=request.getParameter("codTipoProgramaProd");
        String codCompProd=request.getParameter("codCompProd");
        String codLote=request.getParameter("codLote");
        out.println("<script type='text/javascript'>codPersonal="+codPersonal+";" +
                   "codTipoPermiso="+codTipoPermiso+";</script>");
        int codEstadoHoja=0;
        out.println("<title>("+codLote+")RENDIMIENTO FINAL</title>");
        String personal="";
        int cantidadLote=0;
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
        //out.println("<script>sqlConnection.verificarRegistroPendiente('"+codprogramaProd+"','"+codLote+"',3)</script>");
        //datos propios de la hoja
        int codActividadLavadoAmpolla=0;
        String indicacionesLavadoAmpollas="";
        int codSeguimientoRendimiento=0;
        int codSeguimientoControlDosificado=0;
        int cantidadCC=0;
        try
        {
              Connection con=null;
              con=Util.openConnection(con);
              Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
              String consulta="select pp.cod_formula_maestra,cp.nombre_prod_semiterminado,ff.nombre_forma,"+
                              " cp.VIDA_UTIL,pp.CANT_LOTE_PRODUCCION,tpp.NOMBRE_TIPO_PROGRAMA_PROD," +
                              " isnull(afm.COD_ACTIVIDAD_FORMULA, 0) as actividadLavadoAmpollasACD,"+
                              " isnull(srl.COD_SEGUIMIENTO_RENDIMIENTO_LOTE_ACOND, 0) AS COD_SEGUIMIENTO_RENDIMIENTO_LOTE_ACOND,"+
                              " ISNULL(srl.COD_PERSONAL_SUPERVISOR, 0) AS COD_PERSONAL_SUPERVISOR,"+
                              " ISNULL(srl.OBSERVACIONES, '') AS OBSERVACIONES,ISNULL(srl.CANTIDAD_CC, 0) AS CANTIDAD_CC,"+
                              " srl.FECHA_CIERRE,isnull(scdl.COD_SEGUIMIENTO_CONTROL_DOSIFICADO_LOTE, 0) AS codSeguimientoControlDosificado"+
                              " from PROGRAMA_PRODUCCION pp inner join componentes_prod cp on "+
                              " cp.COD_COMPPROD=pp.COD_COMPPROD "+
                              " inner join FORMAS_FARMACEUTICAS ff on ff.cod_forma=cp.COD_FORMA"+
                              " inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD"+
                              " left outer join DESCRIPCION_PROCESOS_FORMA_FARMACEUTICA dpff on dpff.COD_FORMA=cp.COD_FORMA"+
                              " left outer join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_AREA_EMPRESA ="+
                              " 84 and afm.COD_ACTIVIDAD = 110 and afm.COD_FORMULA_MAESTRA = pp.COD_FORMULA_MAESTRA and afm.COD_PRESENTACION = 0"+
                              " LEFT OUTER JOIN SEGUIMIENTO_RENDIMIENTO_LOTE_ACOND srl on srl.cod_lote ="+
                              " pp.COD_LOTE_PRODUCCION and srl.COD_PROGRAMA_PROD = pp.COD_PROGRAMA_PROD"+
                              " and srl.COD_COMPPROD=pp.COD_COMPPROD and srl.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD"+
                              " left OUTER JOIN SEGUIMIENTO_CONTROL_DOSIFICADO_LOTE scdl ON scdl.COD_LOTE ="+
                              " pp.COD_LOTE_PRODUCCION AND scdl.COD_PROGRAMA_PROD = pp.COD_PROGRAMA_PROD"+
                              " where pp.COD_LOTE_PRODUCCION='"+codLote+"' and pp.COD_PROGRAMA_PROD='"+codprogramaProd+"'" +
                              " and pp.COD_COMPPROD='"+codCompProd+"'"+
                              " and pp.COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"'";
                System.out.println("consulta cargar datos del lote "+consulta);
                ResultSet res=st.executeQuery(consulta);
                    
                    if(res.next())
                    {
                        cantidadLote=res.getInt("CANT_LOTE_PRODUCCION");
                        fechaCierre=(res.getTimestamp("FECHA_CIERRE")!=null?res.getTimestamp("FECHA_CIERRE"):new Date());
                        codPersonalCierre=res.getInt("COD_PERSONAL_SUPERVISOR");
                        observaciones=res.getString("OBSERVACIONES");
                        codSeguimientoRendimiento=res.getInt("COD_SEGUIMIENTO_RENDIMIENTO_LOTE_ACOND");
                        codSeguimientoControlDosificado=res.getInt("codSeguimientoControlDosificado");
                        cantidadCC=res.getInt("CANTIDAD_CC");
                        codActividadLavadoAmpolla=res.getInt("actividadLavadoAmpollasACD");
                        codFormulaMaestra=res.getInt("cod_formula_maestra");
                        if(codActividadLavadoAmpolla==0)
                        {
                           // out.println("<script type='text/javascript'>alert('No se encuentran asociada la actividad:LAVADO DE AMPOLLAS ACD');window.close();</script>");
                        }
                        
                        %>

<section class="main">
                         <div class="row"  style="margin-top:5px" >
                                <div class="large-12 medium-12 small-12 large-centered medium-centered small-centered columns" >

                                            <div class="row">
                                               <div class="large-12 medium-12 small-12 columns divHeaderClass" >
                                                       <label  class="inline">RENDIMIENTO FINAL</label>
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
                                   <label  class="inline">RENDIMIENTO FINAL</label>
                            </div>
                        </div>
                        <div class="row" >

                        <div  class="divContentClass large-12 medium-12 small-12 columns" style="padding-top:1em;">
                
                        
                        
                         <%
                         consulta="select P.COD_PERSONAL,(P.AP_PATERNO_PERSONAL + ' ' + P.AP_MATERNO_PERSONAL + ' ' +P.NOMBRES_PERSONAL + ' ' + P.nombre2_personal) NOMBRES_PERSONAL"+
                                 " from personal P inner join PERSONAL_AREA_PRODUCCION pa on pa.COD_PERSONAL = p.COD_PERSONAL"+
                                 " where pa.cod_area_empresa in (84,102) AND p.COD_ESTADO_PERSONA = 1 " +
                                 (codTipoPermiso==12?"":" and p.cod_personal='"+codPersonal+"'")+
                                 " union select P.COD_PERSONAL,"+
                                 " (P.AP_PATERNO_PERSONAL + ' ' + P.AP_MATERNO_PERSONAL + ' ' +P.NOMBRES_PERSONAL + ' ' + P.nombre2_personal) NOMBRES_PERSONAL"+
                                 " from personal p where p.cod_area_empresa in (84,102) and p.COD_ESTADO_PERSONA = 1"+
                                 (codTipoPermiso==12?"":" and p.cod_personal='"+codPersonal+"'")+
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
                                            <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>DESCRIPCION</span></td>
                                            <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>CANTIDAD</span></td>
                                            
                                            
                                        </tr>
                                        <tr >
                                            <td class="tableCell" style="text-align:center;" align="center">
                                               <span class="tableHeaderClassBody">UNIDADES ENTREGADAS A ALMACEN DE PRODUCTO TERMINADO</span>
                                           </td>
                                            <%
                                                consulta="SELECT SUM(sppp.UNIDADES_PRODUCIDAS) as unidadesProducidas"+
                                                         " FROM SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sppp inner join "+
                                                         " ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_ACTIVIDAD_FORMULA=sppp.COD_ACTIVIDAD_PROGRAMA"+
                                                         " and afm.COD_AREA_EMPRESA=84 and afm.COD_ACTIVIDAD='317'"+
                                                        " where sppp.COD_LOTE_PRODUCCION='"+codLote+"' and sppp.COD_PROGRAMA_PROD='"+codprogramaProd+"'"+
                                                        " and sppp.COD_TIPO_PROGRAMA_PROD=1";
                                                System.out.println("consulta mc"+consulta);
                                                int cantidadAPT=0;
                                                res=st.executeQuery(consulta);
                                                if(res.next())cantidadAPT=res.getInt("unidadesProducidas");
                                                consulta="select isnull(sum(sd.CANT_TOTAL_SALIDADETALLEACOND),0) as cantidadCC from SALIDAS_DETALLEACOND sd "+
                                                         " inner join SALIDAS_ACOND sa on sd.COD_SALIDA_ACOND=sa.COD_SALIDA_ACOND"+
                                                         " where sa.COD_ALMACEN_VENTA=29 and sd.COD_LOTE_PRODUCCION='"+codLote+"'";
                                                System.out.println("consulta cantidad enviada cc "+consulta);
                                                res=st.executeQuery(consulta);
                                                if(res.next())cantidadCC=res.getInt("cantidadCC");
                                            %>
                                            <td class="tableCell" style="text-align:center;" align="center">
                                               <span class="tableHeaderClassBody"><%=(cantidadAPT)%></span>
                                           </td>
                                        </tr>
                                        <tr>
                                            <td class="tableCell" style="text-align:center;" align="center">
                                               <span class="tableHeaderClassBody">UNIDADES ENTREGADAS PARA CONTROL DE CALIDAD</span>
                                           </td>
                                           <td class="tableCell" style="text-align:center;" align="center">
                                               <span class="tableHeaderClassBody"><%=(cantidadCC)%></span>
                                               
                                           </td>
                                        </tr>
                                        <tr >
                                            <td class="tableCell" style="text-align:center;" align="center">
                                               <span class="tableHeaderClassBody">UNIDADES ENTREGADAS COMO MUESTRA MEDICA</span>
                                           </td>
                                            <%
                                                consulta="SELECT SUM(sppp.UNIDADES_PRODUCIDAS) as unidadesProducidas"+
                                                         " FROM SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sppp inner join "+
                                                         " ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_ACTIVIDAD_FORMULA=sppp.COD_ACTIVIDAD_PROGRAMA"+
                                                         " and afm.COD_AREA_EMPRESA=84 and afm.COD_ACTIVIDAD='317'"+
                                                        " where sppp.COD_LOTE_PRODUCCION='"+codLote+"' and sppp.COD_PROGRAMA_PROD='"+codprogramaProd+"'"+
                                                        " and sppp.COD_TIPO_PROGRAMA_PROD=3";
                                                System.out.println("consulta mc"+consulta);
                                                int cantidadMM=0;
                                                res=st.executeQuery(consulta);
                                                if(res.next())cantidadMM=res.getInt("unidadesProducidas");
                                            %>
                                            <td class="tableCell" style="text-align:center;" align="center">
                                               <span class="tableHeaderClassBody"><%=(cantidadMM)%></span>
                                           </td>
                                        </tr>
                                        <tr >
                                            <td class="tableCell" style="text-align:center;" align="center">
                                               <span class="tableHeaderClassBody">UNIDADES ENTREGADAS DESDE PRODUCCION</span>
                                           </td>
                                            <%
                                                consulta="select sum(s.CANT_AMPOLLAS_ACOND) as cantAcond,sum(s.CANT_AMPOLLAS_CC) as cantCC," +
                                                        " sum(s.CANT_AMPOLLAS_CARBONES) as cantCarbones,sum(s.CANT_AMPOLLAS_ROTAS) as cantRotas " +
                                                        " from SEGUIMIENTO_CONTROL_DOSIFICADO_LOTE_PERSONAL s " +
                                                        " where s.COD_SEGUIMIENTO_CONTROL_DOSIFICADO_LOTE = '"+codSeguimientoControlDosificado+"'";
                                                System.out.println("consulta ep"+consulta);
                                                int cantidadEnviadaProduccion=0;
                                                res=st.executeQuery(consulta);
                                                if(res.next())cantidadEnviadaProduccion=(res.getInt("cantAcond")-res.getInt("cantCC")-res.getInt("cantCarbones")-res.getInt("cantRotas"));
                                            %>
                                            <td class="tableCell" style="text-align:center;" align="center">
                                               <span class="tableHeaderClassBody"><%=(cantidadEnviadaProduccion)%></span>
                                           </td>
                                        </tr>
                                </table>
                                <table style="width:60%;margin-top:2%" id="dataCantidades" cellpadding="0px" cellspacing="0px">
                                  <tr>
                                       <tr>
                                               <td class="tableHeaderClass"  rowspan="2"  style="border-right:none;text-align:right" >
                                                   <span class="textHeaderClass">RENDIMIENTO TOTAL</span>
                                               </td>
                                               <td class="tableHeaderClass" rowspan="2"  style="border-left:none;border-right:none;text-align:left" >
                                                   <span class="textHeaderClass">=</span>
                                               </td>
                                               <td class="tableHeaderClass"  style="border-right:none;border-left:none;border-bottom:1px solid white; text-align:center">
                                                   <span class="textHeaderClass">CANTIDAD ENVIADA APT</span>
                                               </td>
                                                <td class="tableHeaderClass" rowspan="2"  style="border-left:none;border-right:none;text-align:left" >
                                                   <span class="textHeaderClass">=</span>
                                               </td>
                                               <td class="tableCell" style="text-align:center;width:30%" rowspan="2">
                                                   <span class="textHeaderClassBody" id="spanRendimiento" style="font-weight:normal">
                                                       <%=(cantidadLote>0?Math.round(Double.valueOf(cantidadAPT+cantidadMM)/Double.valueOf(cantidadLote)*10000)/100d:0)%>
                                                   </span>
                                               </td>
                                               <td class="tableHeaderClass"  style="text-align:left" rowspan="2">
                                                   <span class="textHeaderClass">%</span>
                                               </td>
                                       </tr>
                                       <tr>
                                           <td class="tableHeaderClass" style="border-right:none;border-left:none;border-top:1px solid white;"><span class="textHeaderClass">CANTIDAD NOMINAL DEL LOTE</span></td>
                                       </tr>
                                  </tr>
                              </table>
                            </div>
                         </div>
                         <center>
                            

                         </center>
                    <input type="hidden" value="<%=(codPersonalCierre)%>" id="cerrado"/>
                    <%
                    if(codTipoPermiso==12)
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
                                    <button class="small button succes radius buttonAction" onclick="guardarRendimiento();" >Guardar</button>
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

        </section>
    </body>
    <script src="../../reponse/js/mensajejs.js"></script>
    <script>loginHoja.verificarHojaCerradaAcond("cerrado", administradorSistema, 7,<%=(codEstadoHoja)%>);</script>
</html>
