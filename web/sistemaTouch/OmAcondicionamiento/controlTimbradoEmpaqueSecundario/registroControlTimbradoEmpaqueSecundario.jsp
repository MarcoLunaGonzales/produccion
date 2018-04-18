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
    var materialesSelect="";
    function guardarTimbradoES(aprobacionDepeje,codTipoGuardado)
    {
        iniciarProgresoSistema();
        var materialesTimbrado=document.getElementById("dataTimbradoEs");
        var dataMateriales=new Array();
        for(var k=1;k<materialesTimbrado.rows.length;k++)
         {
             if(validarRegistroEntero(materialesTimbrado.rows[k].cells[6].getElementsByTagName('input')[0])&&
                validarFechaRegistro(materialesTimbrado.rows[k].cells[1].getElementsByTagName('input')[0])&&
                validarSeleccionRegistro(materialesTimbrado.rows[k].cells[5].getElementsByTagName('select')[0])&&
                validarHoraRegistro(materialesTimbrado.rows[k].cells[2].getElementsByTagName('input')[0])&&
                validarHoraRegistro(materialesTimbrado.rows[k].cells[3].getElementsByTagName('input')[0])&&
                validarRegistrosHorasNoNegativas(materialesTimbrado.rows[k].cells[2].getElementsByTagName('input')[0],materialesTimbrado.rows[k].cells[3].getElementsByTagName('input')[0]))
               {
                     dataMateriales.push(materialesTimbrado.rows[k].cells[0].getElementsByTagName('select')[0].value);
                     dataMateriales.push(materialesTimbrado.rows[k].cells[1].getElementsByTagName('input')[0].value);
                     dataMateriales.push(materialesTimbrado.rows[k].cells[2].getElementsByTagName('input')[0].value);
                     dataMateriales.push(materialesTimbrado.rows[k].cells[3].getElementsByTagName('input')[0].value);
                     dataMateriales.push(materialesTimbrado.rows[k].cells[4].getElementsByTagName('span')[0].innerHTML);
                     dataMateriales.push(materialesTimbrado.rows[k].cells[5].getElementsByTagName('select')[0].value);
                     dataMateriales.push(materialesTimbrado.rows[k].cells[6].getElementsByTagName('input')[0].value);
                }
                else
                {
                    terminarProgresoSistema();
                    return false;
                }
         }
         var dataDoblado=crearArrayTablaFechaHora("dataDoblado",2);

         ajax=nuevoAjax();
         
         var peticion="ajaxGuardarControlTimbradoEmpaqueSecundario.jsf?"+
                        "codLote="+codLoteGeneral+"&noCache="+ Math.random()+"&date="+(new Date().getTime()).toString()+
                        "&codprogramaProd="+codProgramaProdGeneral+
                        "&codFormulaMaestra="+codFormulaMaestraGeneral+
                        "&codTipoProgramaProd="+codTipoProgramaProdGeneral+
                        "&codCompProd="+codComprodGeneral+
                        "&codTipoGuardado="+codTipoGuardado+
                        "&codActividadTimbrado="+document.getElementById("codActividadTimbrado").value+
                        "&codActividadDoblado="+document.getElementById("codActividadDoblado").value+
                        "&dataMateriales="+dataMateriales+
                        "&codTipoGuardado="+codTipoGuardado+
                        "&dataDoblado="+dataDoblado+
                        "&codTipoPermiso="+(codTipoPermiso)+
                        "&codPersonalUsuario="+codPersonalGeneral+
                        (codTipoPermiso==12?"&observacion="+encodeURIComponent(document.getElementById("observacion").value):"");

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
                            mensajeJs('Se registro la etapa de timbrado de ES',function(){
                                window.close();
                            });
                            
                            return true;
                        }
                        else
                        {
                            terminarProgresoSistema()
                            alertJs(ajax.responseText.split("\n").join(""));
                            return false;
                        }
                    }
                }

                ajax.send(null);

    }
    function guardarMaterialParaTimbrado()
    {
        iniciarProgresoSistema();
        var materialesTimbrado=document.getElementById("dataMaterialesrecepccionados");
        var dataMateriales=new Array();
        for(var k=2;k<materialesTimbrado.rows.length;k++)
         {
             if(materialesTimbrado.rows[k].cells[4].getElementsByTagName("input")[0].checked)
             {
                 dataMateriales[dataMateriales.length]=(materialesTimbrado.rows[k].cells[0].getElementsByTagName("input")[0].value);
             }
         }

         ajax=nuevoAjax();
         var peticion="ajaxHabilitarMaterial.jsf?"+
             "codLote="+codLoteGeneral+"&noCache="+ Math.random()+"&date="+(new Date().getTime()).toString()+
             "&codProgramaProd="+codProgramaProdGeneral+
             "&codFormulaMaestra="+codFormulaMaestraGeneral+
             "&codTipoProgramaProd="+codTipoProgramaProdGeneral+
             "&codCompProd="+codComprodGeneral+
             "&dataMateriales="+dataMateriales;
        ajax.open("GET",peticion,true);
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
                            terminarProgresoSistema();
                            mensajeJs('Se registraron los materiales para timbrado',
                            function(){
                                window.close();
                            }
                            );
                            
                            
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
       var fila= table.insertRow(table.rows.length);
       fila.onclick=function(){seleccionarFila(this);};
       componentesJs.crearCelda(fila).appendChild(componentesJs.crearSelect(operariosRegistroGeneral));
       componentesJs.crearCelda(fila).appendChild(componentesJs.crearInputFechaDefecto());
       componentesJs.crearCelda(fila).appendChild(componentesJs.crearInputHora1());
       componentesJs.crearCelda(fila).appendChild(componentesJs.crearInputHora2());
       componentesJs.crearCelda(fila).appendChild(componentesJs.crearSpanCantidad());
       var selectMaterial=componentesJs.crearSelect(materialesSelect);
       selectMaterial.onchange=function(){materialChange();};
       componentesJs.crearCelda(fila).appendChild(selectMaterial);
       var cantidadTim = componentesJs.crearInputCantidad(0);
       cantidadTim.onkeyup=function(){reducirCantidad(this);};
       componentesJs.crearCelda(fila).appendChild(cantidadTim);
  }

    function materialChange()
    {
        try
        {
            var tabla=document.getElementById("dataMaterialesrecepccionados");
            var detalle=document.getElementById("dataTimbradoEs");
            for(var i=2;i<tabla.rows.length;i++)
            {
                tabla.rows[i].cells[2].getElementsByTagName("span")[0].innerHTML=0;
                tabla.rows[i].cells[3].getElementsByTagName("span")[0].innerHTML=
                (parseInt(tabla.rows[i].cells[1].getElementsByTagName("span")[0].innerHTML));
            }
            for(var k=1;k<detalle.rows.length;k++)
            {
                var codMaterial=detalle.rows[k].cells[5].getElementsByTagName("select")[0].value;
                var cantMaterial=parseInt(document.getElementById("cantidadTim"+codMaterial).innerHTML);
                var cantSalida=parseInt(document.getElementById("cantSalida"+codMaterial).innerHTML);
                document.getElementById("cantidadTim"+codMaterial).innerHTML=
                    (cantMaterial+parseInt(detalle.rows[k].cells[6].getElementsByTagName("input")[0].value));
                document.getElementById("cantFinal"+codMaterial).innerHTML=(cantSalida-parseInt(document.getElementById("cantidadTim"+codMaterial).innerHTML));
            }
        }
        catch(e)
        {}
        
    }
    function reducirCantidad(celda)
    {
        try
        {
            var codMaquina=parseInt(celda.parentNode.parentNode.cells[5].getElementsByTagName("select")[0].value);
            var tabla=celda.parentNode.parentNode.parentNode;
            var suma=0;
            for(var i=1;i<tabla.rows.length;i++)
            {
                if(parseInt(tabla.rows[i].cells[5].getElementsByTagName("select")[0].value)==codMaquina)
                {
                    suma+=parseInt(tabla.rows[i].cells[6].getElementsByTagName("input")[0].value);
                }
            }
            eval("cantidadTim"+codMaquina+".innerHTML="+suma);
            var cantTotal=parseInt(document.getElementById("cantSalida"+codMaquina).innerHTML);
            document.getElementById("cantFinal"+codMaquina).innerHTML=(cantTotal-suma);
        }
        catch(e)
        {}
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
        String codAreaEmpresaPersonal=request.getParameter("codAreaEmpresa");
        int codPersonal=Integer.valueOf(request.getParameter("codPersonal"));
        int codTipoPermiso=Integer.valueOf(request.getParameter("codTipoPermiso"));
        
        //datos lote
        int codprogramaProd=Integer.valueOf(request.getParameter("codProgramaProd"));
        int codTipoProgramaProd=Integer.valueOf(request.getParameter("codTipoProgramaProd"));
        int codCompProd=Integer.valueOf(request.getParameter("codCompProd"));
        String codLote=request.getParameter("codLote");
        //otras variables
        int codFormulaMaestra=0;
        int codEstadoHoja=0;
        int codForma=0;
        out.println("<title>("+codLote+")TIMBRADO EMPAQUE SECUNDARIO</title>");
        String personal="";
        
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
        int codSeguimientoEntrega=0;
        int codActividadTimbrado=0;
        int codActividadDoblado=0;
        String indicacionesTimbradoES="";
        int codSeguimientoTimbrado=0;
        Connection con=null;
        try
        {
                
                con=Util.openConnection(con);
                Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                StringBuilder consulta=new StringBuilder("select pp.cod_formula_maestra,cp.nombre_prod_semiterminado,ff.nombre_forma,");
                                                consulta.append(" cp.VIDA_UTIL,pp.CANT_LOTE_PRODUCCION,tpp.NOMBRE_TIPO_PROGRAMA_PROD," );
                                                consulta.append(" isnull(dpff.ACOND_INDICACIONES_TIMBRADO_ES, '') as ACOND_INDICACIONES_TIMBRADO_ES," );
                                                consulta.append(" isnull(afm1.COD_ACTIVIDAD_FORMULA, 0) as codActividadDoblado,");
                                                consulta.append("  isnull(afm.COD_ACTIVIDAD_FORMULA, 0) as codActividadTimbrado,isnull(sel.COD_SEGUIMIENTO_TIMBRADO_ES_LOTE_ACOND, 0) AS COD_SEGUIMIENTO_TIMBRADO_ES_LOTE_ACOND,");
                                                consulta.append(" ISNULL(sel.COD_PERSONAL_SUPERVISOR, 0) AS COD_PERSONAL_SUPERVISOR, ISNULL(sel.OBSERVACIONES, '') AS OBSERVACIONES,");
                                                consulta.append(" sel.FECHA_CIERRE,cp.COD_FORMA,");
                                                consulta.append(" isnull(se.COD_SEGUIMIENTO_ENTREGA_ES_LOTE_ACOND, 0) AS COD_SEGUIMIENTO_ENTREGA_ES_LOTE_ACOND");
                                        consulta.append(" from PROGRAMA_PRODUCCION pp inner join componentes_prod cp on ");
                                                consulta.append(" cp.COD_COMPPROD=pp.COD_COMPPROD ");
                                                consulta.append(" inner join FORMAS_FARMACEUTICAS ff on ff.cod_forma=cp.COD_FORMA");
                                                consulta.append(" inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD");
                                                consulta.append(" left outer join DESCRIPCION_PROCESOS_FORMA_FARMACEUTICA dpff on dpff.COD_FORMA=cp.COD_FORMA");
                                                consulta.append(" left outer join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_AREA_EMPRESA =84 and afm.COD_ACTIVIDAD = 316" );
                                                consulta.append(" and afm.COD_FORMULA_MAESTRA =pp.COD_FORMULA_MAESTRA and afm.COD_PRESENTACION = 0");
                                                consulta.append(" left outer join ACTIVIDADES_FORMULA_MAESTRA afm1 on afm1.COD_AREA_EMPRESA =84 and afm1.COD_ACTIVIDAD = 97" );
                                                consulta.append(" and afm1.COD_FORMULA_MAESTRA =pp.COD_FORMULA_MAESTRA and afm1.COD_PRESENTACION = 0");
                                                consulta.append(" LEFT OUTER JOIN SEGUIMIENTO_TIMBRADO_ES_LOTE_ACOND sel on sel.cod_lote =");
                                                consulta.append(" pp.COD_LOTE_PRODUCCION and sel.COD_PROGRAMA_PROD = pp.COD_PROGRAMA_PROD");
                                                consulta.append(" and pp.COD_COMPPROD=sel.COD_COMPPROD and pp.COD_TIPO_PROGRAMA_PROD=sel.COD_TIPO_PROGRAMA_PROD");
                                                consulta.append(" LEFT OUTER JOIN SEGUIMIENTO_ENTREGA_ES_LOTE_ACOND se on se.cod_lote =");
                                                consulta.append(" pp.COD_LOTE_PRODUCCION and se.COD_PROGRAMA_PROD = pp.COD_PROGRAMA_PROD");
                                                consulta.append(" and pp.COD_COMPPROD=se.COD_COMPPROD and pp.COD_TIPO_PROGRAMA_PROD=se.COD_TIPO_PROGRAMA_PROD");
                                        consulta.append(" where pp.COD_LOTE_PRODUCCION='").append(codLote).append("'");
                                                consulta.append(" and pp.COD_PROGRAMA_PROD=").append(codprogramaProd);
                                                consulta.append(" and pp.COD_COMPPROD=").append(codCompProd);
                                                consulta.append(" and pp.COD_TIPO_PROGRAMA_PROD=").append(codTipoProgramaProd);
                System.out.println("consulta cargar datos del lote "+consulta.toString());
                ResultSet res=st.executeQuery(consulta.toString());
                if(res.next())
                {
                    codForma=res.getInt("COD_FORMA");
                    codActividadDoblado=res.getInt("codActividadDoblado");
                    codSeguimientoEntrega=res.getInt("COD_SEGUIMIENTO_ENTREGA_ES_LOTE_ACOND");
                    fechaCierre=(res.getTimestamp("FECHA_CIERRE")!=null?res.getTimestamp("FECHA_CIERRE"):new Date());
                    codPersonalCierre=res.getInt("COD_PERSONAL_SUPERVISOR");
                    observaciones=res.getString("OBSERVACIONES");
                    codSeguimientoTimbrado=res.getInt("COD_SEGUIMIENTO_TIMBRADO_ES_LOTE_ACOND");
                    codActividadTimbrado=res.getInt("codActividadTimbrado");
                    indicacionesTimbradoES=res.getString("ACOND_INDICACIONES_TIMBRADO_ES").replace(b,'\n').replace("\n", "</br>").replace("</br></br>","<br>");
                    codFormulaMaestra=res.getInt("cod_formula_maestra");
                    if(codActividadTimbrado==0)
                    {
                        out.println("<script type='text/javascript'>alert('No se encuentran asociada la actividad:CODIFICADO DE ETIQUETAS');window.close();</script>");
                    }

                    %>


<section class="main">
                         <div class="row"  style="margin-top:5px" >
                                <div class="large-12 medium-12 small-12 large-centered medium-centered small-centered columns" >

                                            <div class="row">
                                               <div class="large-12 medium-12 small-12 columns divHeaderClass" >
                                                       <label  class="inline">Control de Timbrado De Material Secundario</label>
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
                                        "codProgramaProdGeneral='"+codprogramaProd+"';" +
                                        "codAreaEmpresaGeneral='"+codAreaEmpresaPersonal+"';"+
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
                                   <label  class="inline">CONTROL DE TIMBRADO DE MATERIAL SECUNDARIO</label>
                            </div>
                        </div>
                        <div class="row" >

                        <div  class="divContentClass large-12 medium-12 small-12 columns" style="padding-top:1em;">
                        <span ><%=(indicacionesTimbradoES)%></span>
                        
                         <%
                        personal=UtilidadesTablet.operariosAreaProduccionAcondicionamientoSelect(st, codTipoPermiso, codPersonal);
                        out.println("<script type='text/javascript'>operariosRegistroGeneral=\""+personal+"\";fechaSistemaGeneral='"+sdfDias.format(new Date())+"'</script>");
                                
                                 
                        consulta=new StringBuilder("SELECT m.COD_MATERIAL,m.NOMBRE_MATERIAL");
                                    consulta.append(" FROM SALIDAS_ALMACEN sa inner join SALIDAS_ALMACEN_DETALLE sad on sa.COD_SALIDA_ALMACEN=sad.COD_SALIDA_ALMACEN");
                                            consulta.append(" inner join MATERIALES m on m.COD_MATERIAL=sad.COD_MATERIAL" );
                                            consulta.append(" inner join SEGUIMIENTO_TIMBRADO_ES_LOTE_ACOND_MAT_TIM sel on sel.COD_MATERIAL=sad.COD_MATERIAL");
                                                    consulta.append(" and sel.COD_SEGUIMIENTO_TIMBRADO_ES_LOTE_ACOND=").append(codSeguimientoTimbrado);
                                    consulta.append(" where sa.COD_LOTE_PRODUCCION='").append(codLote).append("'");
                                            consulta.append(" and sa.COD_ALMACEN=2 and sa.COD_ESTADO_SALIDA_ALMACEN<>2");
                                    consulta.append(" group by m.COD_MATERIAL,m.NOMBRE_MATERIAL");
                        System.out.println("consulta materiales select "+consulta.toString());
                        res=st.executeQuery(consulta.toString());
                        String materialesSelect="";
                        while(res.next())
                        {
                            materialesSelect+="<option value='"+res.getString("COD_MATERIAL")+"'>"+res.getString("NOMBRE_MATERIAL")+"</option>";
                        }
                        out.println("<script type='text/javascript'>materialesSelect=\""+materialesSelect+"\"</script>");
                        %>
                        
                    <center>
                         <div class="row" style="margin-top:1em;">
                            <div class="large-12 medium-12 small-12 large-centered medium-centered small-centered columns">
                                <table style="border:none;width:100%;margin-top:4px;" id="dataTimbradoEs" cellpadding="0px" cellspacing="0px">
                                        <tr>
                                            <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>PERSONAL</span></td>
                                            <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>FECHA</span></td>
                                            <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>HORA<br> INICIO</span></td>
                                            <td class='tableHeaderClass' style='text-align:center;' colspan=""><span class='textHeaderClass'>HORA<BR>FINAL</span></td>
                                            <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>HORAS<BR>HOMBRE</span></td>
                                            <td class='tableHeaderClass' style='text-align:center;' colspan=""><span class='textHeaderClass'>MATERIAL</span></td>
                                            <td class='tableHeaderClass' style='text-align:center;' colspan=""><span class='textHeaderClass'>CANTIDAD<BR>TIMBRADA</span></td>
                                            
                                        </tr>
                                        <%
                                        consulta=new StringBuilder("SELECT sppp.COD_PERSONAL,st.CANTIDAD_TIMBRADA,st.COD_MATERIAL,");
                                                            consulta.append(" sppp.FECHA_INICIO,sppp.FECHA_FINAL,sppp.HORAS_HOMBRE");
                                                   consulta.append(" FROM SEGUIMIENTO_TIMBRADO_ES_LOTE_ACOND_MATERIALES st ");
                                                            consulta.append(" inner join SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sppp on st.COD_PERSONAL=sppp.COD_PERSONAL and st.COD_REGISTRO_ORDEN_MANUFACTURA=sppp.COD_REGISTRO_ORDEN_MANUFACTURA");
                                                   consulta.append(" where sppp.COD_LOTE_PRODUCCION='").append(codLote).append("'");
                                                            consulta.append(" and sppp.COD_PROGRAMA_PROD=").append(codprogramaProd);
                                                            consulta.append(" and sppp.COD_FORMULA_MAESTRA=").append(codFormulaMaestra);
                                                            consulta.append(" and sppp.COD_COMPPROD=").append(codCompProd);
                                                            consulta.append(" and sppp.COD_TIPO_PROGRAMA_PROD=").append(codTipoProgramaProd);
                                                            consulta.append(" and sppp.COD_ACTIVIDAD_PROGRAMA=").append(codActividadTimbrado);
                                                            consulta.append(" and st.COD_SEGUIMIENTO_TIMBRADO_ES_LOTE_ACOND=").append(codSeguimientoTimbrado);
                                                            if(codTipoPermiso<=10)
                                                                    consulta.append(" and sppp.COD_PERSONAL=").append(codPersonal);
                                                   consulta.append(" order by sppp.FECHA_INICIO");
                                        System.out.println("consulta cargar seguimiento ampollas "+consulta.toString());
                                        res=st.executeQuery(consulta.toString());
                                        while(res.next())
                                        {
                                            %>
                                            <tr onclick="seleccionarFila(this);">
                                                        <td class="tableCell"  style="text-align:center">
                                                            <select id="codTimMatPer<%=(res.getRow())%>"><%out.println(personal);%></select>
                                                                <%
                                                                out.println("<script>codTimMatPer"+res.getRow()+".value='"+res.getInt("COD_PERSONAL")+"';</script>");
                                                                 %>
                                                       </td>
                                                       <td class="tableCell"  style="text-align:center;">
                                                            <input  type="text" value="<%=(res.getTimestamp("FECHA_INICIO")!=null?sdfDias.format(res.getTimestamp("FECHA_INICIO")):"")%>" size="10" id="fechap<%=(res.getRow())%>"
                                                            onclick="seleccionarDatePickerJs(this);"/>
                                                            
                                                       </td>
                                                       <td class="tableCell"  style="text-align:center;" align="center">
                                                           <input  type="text" onclick='seleccionarHora(this);' id="fechaIniAmpolla<%=(res.getRow())%>" value="<%=(res.getTimestamp("FECHA_INICIO")!=null?sdfHora.format(res.getTimestamp("FECHA_INICIO")):"")%>" style="width:6em;display:inherit;"/>
                                                       </td>
                                                       <td class="tableCell"  style="text-align:center;" align="center">
                                                           <input  type="text" onclick='seleccionarHora(this);' id="fechaFinAmpolla<%=(res.getRow())%>" value="<%=(res.getTimestamp("FECHA_INICIO")!=null?sdfHora.format(res.getTimestamp("FECHA_FINAL")):"")%>" style="width:6em;display:inherit;"/>
                                                       </td >
                                                       <td class="tableCell" style="text-align:center;" align="center">
                                                           <span class="tableHeaderClassBody"><%=(nf.format(res.getDouble("HORAS_HOMBRE")))%></span>
                                                       </td>
                                                       <td onchange="materialChange();" class="tableCell"  style="text-align:center !important;" align="center">
                                                           <select  id="codTimMat<%=(res.getRow())%>"><%out.println(materialesSelect);%></select>
                                                                <%
                                                                out.println("<script>codTimMat"+res.getRow()+".value='"+res.getInt("COD_MATERIAL")+"';</script>");
                                                                 %>
                                                       </td>
                                                       <td class="tableCell"  style="text-align:center;" align="center">
                                                           <input  type="tel" onkeyup="reducirCantidad(this)"  value="<%=(res.getInt("CANTIDAD_TIMBRADA"))%>" style="width:6em;display:inherit;"/>
                                                       </td>
                                                        </tr>
                                            <%
                                        }
                                        %>
                                </table>
                                
                                    <div class="row" >
                                        <div class="large-5 medium-5 small-4 columns" style="">&nbsp;</div>
                                          <div class="large-1 medium-1 small-2 columns" >
                                                <button  class="small button succes radius buttonMas" onclick="nuevoRegistro('dataTimbradoEs')">+</button>
                                          </div>
                                          <div class="large-1 medium-1 small-2 columns">
                                                 <button class="small button succes radius buttonMenos" onclick="eliminarRegistroTabla('dataTimbradoEs');materialChange();" >-</button>
                                          </div>
                                          <div class="large-5 medium-5 small-4 columns" style="">&nbsp;</div>
                                  </div>
                                  <%
                                    //solo para la ampollas
                                            out.println("<table style='border:none;width:100%;margin-top:4px;' id='dataDoblado' cellpadding='0px' cellspacing='0px'>" +
                                                      " <tr><td colspan='6' class='tableHeaderClass prim ult'  ><span class='textHeaderClass'>DOBLADO DE INSERTOS</span></td></tr>" +
                                                          "</tr><td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>OBREROS<br>TIMBRADO</span></td>"+
                                                          " <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>FECHA</span></td>"+
                                                          " <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>HORA<br> INICIO</span></td>"+
                                                          " <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>HORA<br> FINAL</span></td>"+
                                                          " <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>HORAS</span></td>"+
                                                          " <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>CANTIDAD<br> DOBLADA</span></td>"+
                                                          "</tr>");
                                                consulta=new StringBuilder("select sppp.COD_TIPO_PROGRAMA_PROD,sppp.COD_PERSONAL,sppp.FECHA_INICIO,sppp.FECHA_FINAL,sppp.HORAS_HOMBRE,sppp.UNIDADES_PRODUCIDAS");
                                                            consulta.append(" from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sppp");
                                                                    consulta.append(" where sppp.COD_LOTE_PRODUCCION='").append(codLote).append("'");
                                                                    consulta.append(" and sppp.COD_PROGRAMA_PROD=").append(codprogramaProd);
                                                                    consulta.append(" and sppp.COD_ACTIVIDAD_PROGRAMA=").append(codActividadDoblado);
                                                                    consulta.append(" and sppp.COD_FORMULA_MAESTRA=").append(codFormulaMaestra);
                                                                    consulta.append(" and sppp.COD_COMPPROD=").append(codCompProd);
                                                                    consulta.append(" and sppp.COD_TIPO_PROGRAMA_PROD=").append(codTipoProgramaProd);
                                                                    if(codTipoPermiso<=10)
                                                                            consulta.append(" and sppp.COD_PERSONAL=").append(codPersonal);
                                                            consulta.append(" order by sppp.FECHA_INICIO");
                                                System.out.println("consulta detalle doblado"+consulta.toString());
                                                res=st.executeQuery(consulta.toString());
                                                while(res.next())
                                                {
                                                    out.println("<tr onclick=\"seleccionarFila(this);\"><td class='tableCell'  style='text-align:center'><select  id='pdoblado"+res.getRow()+"'>"+personal+"</select>"+
                                                                "<script>pdoblado"+res.getRow()+".value='"+res.getInt("COD_PERSONAL")+"';</script>"+
                                                                "</td> <td class='tableCell'  style='text-align:center'>"+
                                                                " <input  type='tel' value='"+sdfDias.format(res.getTimestamp("FECHA_INICIO"))+"' size='10' id='fechaDoblado"+res.getRow()+"n' style='width:7em;'/>"+
                                                                " </td> <td class='tableCell' style='text-align:center;' align='center'>"+
                                                                " <input  type='tel' onclick='seleccionarHora(this);' onfocus='calcularHorasFilaInicio(this)' id='fechaIniDoblado"+res.getRow()+"n' value='"+sdfHora.format(res.getTimestamp("FECHA_INICIO"))+"' style='width:6em;display:inherit;'/>"+
                                                                " </td> <td class='tableCell'  style='text-align:center;' align='center'>" +
                                                                " <input  type='tel' onfocus='calcularHorasFilaFinal(this)' onclick='seleccionarHora(this);' id='fechaFinDoblado"+res.getRow()+"n' value='"+sdfHora.format(res.getTimestamp("FECHA_FINAL"))+"' style='width:6em;display:inherit;'/></td >" +
                                                                "</td>"+
                                                                " <td class='tableCell' style='text-align:center;' align='center'>"+
                                                                " <span class='tableHeaderClassBody'>"+nf.format(res.getDouble("HORAS_HOMBRE"))+"</span></td>" +
                                                                "<td class='tableCell'  style='text-align:center !important;' align='center'>" +
                                                                "<input  type='tel'   value='"+res.getInt("UNIDADES_PRODUCIDAS")+"' style='width:6em;display:inherit;'/></td>" +
                                                                "</tr>");

                                                }
                                                out.println("</table>"+
                                                            " <div class='row' ><div class='large-5 medium-5 small-4 columns' style=''>&nbsp;</div><div class='large-1 medium-1 small-2 columns' >"+
                                                            " <button  class='small button succes radius buttonMas' onclick='componentesJs.crearRegistroTablaFechaHora(\"dataDoblado\")'>+</button>"+
                                                            " </div><div class='large-1 medium-1 small-2 columns'>"+
                                                            " <button  class='small button succes radius buttonMenos' onclick='eliminarRegistroTabla(\"dataDoblado\");'>-</button></div>"+
                                                            " <div class='large-5 medium-5 small-4 columns' style=''>&nbsp;</div></div>");
                                  
                                  %>
                                  
                            </div>
                         </div>
                         <center>
                          <div class="row">
                            <div  class="large-10 medium-12 small-12 large-centered medium-centered small-centered columns" style="padding-top:1em;">

                                <table style='border:none;width:100%;margin-top:4px;' id='dataMaterialesrecepccionados' cellpadding='0' cellspacing='0'>
                                 <tr>
                                     <td class='tableHeaderClass prim ult' style='text-align:center;' colspan="<%=(codTipoPermiso==12?6:5)%>" ><span class='textHeaderClass' >ASIGNACION DE MATERIALES PARA TIMBRADO</span></td>
                                </tr>
                                 <tr>
                                     <td class='tableHeaderClass' style='text-align:center;'  ><span class='textHeaderClass' >MATERIAL</span></td>
                                     <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass' >CANTIDAD RECIBIDA</span></td>
                                     <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass' >CANTIDAD TIMBRADA</span></td>
                                     <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass' >CANTIDAD RESTANTE</span></td>
                                     <%=(codTipoPermiso==12?"<td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass' >PARA<BR>TIMBRAR</span></td>":"")%>
                                 </tr>
                                 <%
                                    consulta=new StringBuilder("select m.COD_MATERIAL,m.NOMBRE_MATERIAL,sum(sad.CANTIDAD_SALIDA_ALMACEN) as cantidadSalida" );
                                                        consulta.append(" ,(select sum(s.CANTIDAD_TIMBRADA) from SEGUIMIENTO_TIMBRADO_ES_LOTE_ACOND_MATERIALES s where");
                                                        consulta.append(" s.COD_MATERIAL=m.COD_MATERIAL and s.COD_SEGUIMIENTO_TIMBRADO_ES_LOTE_ACOND='").append(codSeguimientoTimbrado).append("') as CANTIDAD_TIMBRADA,");
                                                        consulta.append(" isnull(ste.COD_MATERIAL,0) as permisoTimbrado");
                                                consulta.append(" from SALIDAS_ALMACEN_DETALLE sad ");
                                                        consulta.append((codTipoPermiso==12?"LEFT OUTER":"INNER")).append(" JOIN SEGUIMIENTO_TIMBRADO_ES_LOTE_ACOND_MAT_TIM ste on  ste.COD_MATERIAL=sad.COD_MATERIAL");
                                                        consulta.append(" and ste.COD_SEGUIMIENTO_TIMBRADO_ES_LOTE_ACOND=").append(codSeguimientoTimbrado);
                                                        consulta.append(" inner join materiales m on m.COD_MATERIAL=sad.COD_MATERIAL");
                                                consulta.append(" where cast(sad.COD_SALIDA_ALMACEN as varchar)+' '+cast(sad.COD_MATERIAL as varchar) in");
                                                        consulta.append(" (");
                                                                consulta.append(" select CAST(see.COD_SALIDA_ALMACEN as varchar)+' '+cast(see.COD_MATERIAL as varchar) from SEGUIMIENTO_ENTREGA_ES_LOTE_ACOND_MATERIALES see where");
                                                                consulta.append(" see.COD_SEGUIMIENTO_ENTREGA_ES_LOTE_ACOND=").append(codSeguimientoEntrega);
                                                        consulta.append(" )");
                                                consulta.append(" group by m.COD_MATERIAL, m.NOMBRE_MATERIAL,ste.COD_MATERIAL");
                                                consulta.append(" order by m.NOMBRE_MATERIAL");
                                    System.out.println("consulta material recibido "+consulta.toString());
                                    res=st.executeQuery(consulta.toString());
                                    while(res.next())
                                    {
                                        out.println(" <tr>" +
                                                "<td class='tableCell' style='text-align:center'><span style='font-weight:normal' class='textHeaderClassBody'>"+res.getString("nombre_material")+"</span><input type='hidden' value='"+res.getInt("COD_MATERIAL")+"'/></td>" +
                                                "<td class='tableCell' style='text-align:center'><span style='font-weight:normal' id='cantSalida"+res.getInt("COD_MATERIAL")+"' class='textHeaderClassBody'>"+res.getInt("cantidadSalida")+"</span></td>" +
                                                "<td class='tableCell' style='text-align:center'><span style='font-weight:normal' id='cantidadTim"+res.getInt("COD_MATERIAL")+"' class='textHeaderClassBody'>"+res.getInt("CANTIDAD_TIMBRADA")+"</span></td>" +
                                                "<td class='tableCell' style='text-align:center'><span style='font-weight:normal' id='cantFinal"+res.getInt("COD_MATERIAL")+"' class='textHeaderClassBody'>"+(res.getInt("cantidadSalida")-res.getInt("CANTIDAD_TIMBRADA"))+"</span></td>" +
                                                (codTipoPermiso==12?"<td class='tableCell' style='text-align:center'><input type='checkbox' style='width:40px;height:40px' "+(res.getInt("permisoTimbrado")>0?"checked":"" )+"  /></td>":"")+
                                                "</tr>");
                                    }
                                 %>
                                </table>
                            </div>
                        </div>

                         </center>
                          <div class="row" style="margin-top:0px;">
                        <div class="large-6 small-8 medium-10 large-centered medium-centered columns">
                            <div class="row">
                                    <div class="large-6 medium-6 small-12 large-centered medium-centered columns">
                                        <button class="small button succes radius buttonAction" <%=(codTipoPermiso==12?"":"disabled")%> onclick="guardarMaterialParaTimbrado();" >Guardar Material<br>Para Timbrado</button>
                                    </div>
                                    
                                
                            </div>
                        </div>
                    </div >
                    <input type="hidden" value="<%=(codPersonalCierre)%>" id="cerrado"/>
                    <%
                    if(codTipoPermiso==12)
                     {
                        out.println(UtilidadesTablet.innerHTMLAprobacionJefe(st,(codPersonalCierre>0?codPersonalCierre:codPersonal),sdfDias.format(new Date()),sdfHora.format(new Date()), observaciones));
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
                                        out.println("<button class='small button succes radius buttonAction' onclick='guardarTimbradoES(false,2);;' >Aprobar</button>");
                                    out.println("</div>");
                                    out.println("<div class='large-4 medium-6 small-12 columns'>");
                                        out.println("<button class='small button succes radius buttonAction' onclick='guardarTimbradoES(false,1);;' >Pre Aprobar</button>");
                                    out.println("</div>");
                                    out.println("<div class='large-4 medium-6 small-12  columns'>");
                                        out.println("<button class='small button succes radius buttonAction' onclick='window.close();' >Cancelar</button>");
                                    out.println("</div>");
                                }
                                else
                                {
                                    out.println("<div class='large-6 medium-6 small-12 columns'>");
                                        out.println("<button class='small button succes radius buttonAction' onclick='guardarTimbradoES(false,0);' >Guardar</button>");
                                    out.println("</div>");
                                    out.println("<div class='large-6 medium-6 small-12  columns'>");
                                        out.println("<button class='small button succes radius buttonAction' onclick='window.close();' >Cancelar</button>");
                                    out.println("</div>");
                                }
                            out.println("</div>");
                        out.println("</div>");
                    out.println("</div>");
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
        <input  type="hidden" id="codActividadTimbrado" value="<%=(codActividadTimbrado)%>">
            <input  type="hidden" id="codActividadDoblado" value="<%=(codActividadDoblado)%>">
        </section>
    </body>
    <script src="../../reponse/js/timePickerJs.js"></script>
    <script src="../../reponse/js/dataPickerJs.js"></script>
    <script src="../../reponse/js/mensajejs.js"></script>
    <script>iniciarDatePicker('<%=(sdfDias.format(new Date()))%>');loginHoja.verificarHojaCerradaAcond("cerrado",(codTipoPermiso==12), 5,<%=(codEstadoHoja)%>);</script>
</html>
