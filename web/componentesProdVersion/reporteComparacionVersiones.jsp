
<%@ page language="java" %>
<%@ page import="com.cofar.util.*" %>
<%@ page import="com.cofar.web.*" %>
<%@ page import = "java.sql.Connection"%>
<%@ page import = "java.sql.DriverManager"%>
<%@ page import = "java.sql.ResultSet"%>
<%@ page import = "java.sql.Statement"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.text.SimpleDateFormat"%>
<%@ page import = "java.text.DecimalFormat"%>
<%@ page import = "java.text.NumberFormat"%>
<%@ page import="java.util.Locale" %>
<%@page import="java.math.RoundingMode" %>%>
<%@page import="java.text.DecimalFormatSymbols" %>
<%@ page import = "java.text.NumberFormat"%>

    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
            <script type="text/javascript" src="../js/general.js"></script>
            
                <style>
                .eliminado
                {
                    background-color:#FFB6C1;
                }
                .modificado
                {
                    background-color:#F0E68C;
                }
                .especificacion
                {
                    font-weight:bold;
                    background-color:white;
                }
                .nuevo
                {
                    background-color:#b6f5b6;
                }
                .celdaQuimica
                {
                    background-color:white;
                    font-weight:bold;
                }
                .tablaComparacion
                {
                    font-family:Verdana, Arial, Helvetica, sans-serif;
                    font-size:11px;
                    margin-top:1em;
                    border-top:1px solid #aaaaaa;
                    border-left:1px solid #aaaaaa;
                }
                .tablaComparacion tr td
                {
                    padding:0.4em;
                    border-bottom:1px solid #aaaaaa;
                    border-right:1px solid #aaaaaa;
                }
                .tablaComparacion thead tr td
                {
                    font-weight:bold;
                    background-color:#ebeaeb;
                    color:black;
                    text-align:center;
                }
            
            </style>
        </head>
        <body>
            <form>
                <center>
                    <table style="margin-top:1em">
                        <tr>
                        <td><span class="outputText2" style="font-weight:bold">Modificado</span></td><td style="width:3em" class="modificado"></td>
                        <td><span class="outputText2" style="font-weight:bold">Nuevo</span></td><td style="width:3em" class="nuevo"></td>
                        <td><span class="outputText2" style="font-weight:bold">Eliminado</span></td><td style="width:3em" class="eliminado"></td>
                    </tr></table>
                    <table class="tablaComparacion" cellpadding="0" cellspacing="0">
                        <thead>
                        <tr><td colspan="3">Diferencia de Versiones</td></tr>
                        <tr><td>Especificación</td><td>Version Activa</td><td>Version Propuesta</td></tr>
                        </thead>
                    <%
                    NumberFormat redondeoSuperior = NumberFormat.getNumberInstance(Locale.ENGLISH);
                    DecimalFormat formatoSuperior = (DecimalFormat) redondeoSuperior;
                    formatoSuperior.setRoundingMode(RoundingMode.HALF_UP);
                    formatoSuperior.applyPattern("#,##0.00");
                    Connection con=null;
                    String codVersion=request.getParameter("codVersion");
                    String codCompProd=request.getParameter("codCompProd");
                    NumberFormat numeroformato = NumberFormat.getNumberInstance(Locale.ENGLISH);
                    DecimalFormat formato = (DecimalFormat) numeroformato;
                    formato.applyPattern("#,##0.00");
                    NumberFormat numeroformato6 = NumberFormat.getNumberInstance(Locale.ENGLISH);
                    DecimalFormat formato6 = (DecimalFormat) numeroformato6;
                    formato6.applyPattern("#,##0.00####");
                    try
                    {
                        con=Util.openConnection(con);
                        String consulta=" select isnull(MAX(c.COD_VERSION),0) as codVersionAnterior"+
                                        " from COMPONENTES_PROD_VERSION c where c.COD_COMPPROD='"+codCompProd+"'" +
                                        " and c.COD_VERSION<'"+codVersion+"' and c.COD_ESTADO_VERSION in(2,4,6)";
                        System.out.println("consulta buscar version activa anterior "+consulta);
                        Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                        ResultSet res=st.executeQuery(consulta);
                        int codVersionAnterior=0;
                        if(res.next())codVersionAnterior=res.getInt("codVersionAnterior");
                        consulta="select isnull(cp.COD_COMPPROD,0) as codComprodOfi,isnull(cp.nombre_prod_semiterminado,'') as nombre_prod_semiterminado,cpv.nombre_prod_semiterminado as nombre_prod_semiterminadoVersion" +
                                ",isnull(ae.NOMBRE_AREA_EMPRESA,'') as NOMBRE_AREA_EMPRESA,isnull(ae1.NOMBRE_AREA_EMPRESA,'') as NOMBRE_AREA_EMPRESAVersion" +
                                ",ISNULL(p.nombre_prod,'')as nombre_prod,isnull(p1.nombre_prod,'') as nombre_prodVersion" +
                                " ,isnull(cp.NOMBRE_GENERICO,'') as NOMBRE_GENERICO,isnull(cpv.NOMBRE_GENERICO,'') as NOMBRE_GENERICOVersion" +
                                " ,isnull(ff.nombre_forma,'') as nombre_forma,isnull(ff1.nombre_forma,'') as nombre_formaVersion" +
                                " ,isnull(cpp.NOMBRE_COLORPRESPRIMARIA,'') as NOMBRE_COLORPRESPRIMARIA,isnull(cpp1.NOMBRE_COLORPRESPRIMARIA,'') as NOMBRE_COLORPRESPRIMARIAVersion" +
                                " ,isnull(vap.NOMBRE_VIA_ADMINISTRACION_PRODUCTO,'') as NOMBRE_VIA_ADMINISTRACION_PRODUCTO,ISNULL(vap1.NOMBRE_VIA_ADMINISTRACION_PRODUCTO,'') as NOMBRE_VIA_ADMINISTRACION_PRODUCTOVersion" +
                                " ,isnull(cp.PESO_ENVASE_PRIMARIO,'') as PESO_ENVASE_PRIMARIO,cpv.PESO_ENVASE_PRIMARIO as PESO_ENVASE_PRIMARIOVersion" +
                                " ,isnull(cp.TOLERANCIA_VOLUMEN_FABRICAR,'') as TOLERANCIA_VOLUMEN_FABRICAR,isnull(cpv.TOLERANCIA_VOLUMEN_FABRICAR,'') as TOLERANCIA_VOLUMEN_FABRICARVersion" +
                                " ,isnull(sp.NOMBRE_SABOR,'') as NOMBRE_SABOR,isnull(sp1.NOMBRE_SABOR,'') as NOMBRE_SABORVersion" +
                                " ,isnull(tap.NOMBRE_TAMANIO_CAPSULA_PRODUCCION,'') as NOMBRE_TAMANIO_CAPSULA_PRODUCCION,ISNULL(tap1.NOMBRE_TAMANIO_CAPSULA_PRODUCCION,'') as NOMBRE_TAMANIO_CAPSULA_PRODUCCIONVersion" +
                                " ,isnull(ec.NOMBRE_ESTADO_COMPPROD,'') as NOMBRE_ESTADO_COMPPROD,isnull(ec1.NOMBRE_ESTADO_COMPPROD,'') as NOMBRE_ESTADO_COMPPRODVersion" +
                                " ,isnull(cp.REG_SANITARIO,'') as REG_SANITARIO,cpv.REG_SANITARIO as REG_SANITARIOVersion"+
                                " ,isnull(cp.VIDA_UTIL,0) as VIDA_UTIL,cpv.VIDA_UTIL as VIDA_UTILVersion"+
                                " ,cp.FECHA_VENCIMIENTO_RS,cpv.FECHA_VENCIMIENTO_RS as FECHA_VENCIMIENTO_RSVersion" +
                                " ,isnull(cast(cp.CANTIDAD_VOLUMEN as varchar)+' '+um.ABREVIATURA,'') as volumen"+
                                " ,isnull(cast(cpv.CANTIDAD_VOLUMEN as varchar)+' '+um1.ABREVIATURA,'') as volumenVersion" +
                                " ,isnull(cvp.NOMBRE_CONDICION_VENTA_PRODUCTO,'') as NOMBRE_CONDICION_VENTA_PRODUCTO"+
                                " ,isnull(cvp1.NOMBRE_CONDICION_VENTA_PRODUCTO,'') as NOMBRE_CONDICION_VENTA_PRODUCTOVersion" +
                                " ,isnull(cp.PRESENTACIONES_REGISTRADAS_RS,'') as PRESENTACIONES_REGISTRADAS_RS"+
                                " ,isnull(cpv.PRESENTACIONES_REGISTRADAS_RS,'') as PRESENTACIONES_REGISTRADAS_RSVersion" +
                                " ,cp.TAMANIO_LOTE_PRODUCCION,cpv.TAMANIO_LOTE_PRODUCCION as TAMANIO_LOTE_PRODUCCIONVersion"+
                                " ,cp.CANTIDAD_VOLUMEN_DE_DOSIFICADO ,cpv.CANTIDAD_VOLUMEN_DE_DOSIFICADO as  CANTIDAD_VOLUMEN_DE_DOSIFICADOVersion"+
                                " ,cp.APLICA_ESPECIFICACIONES_FISICAS,cpv.APLICA_ESPECIFICACIONES_FISICAS as APLICA_ESPECIFICACIONES_FISICASVersion,"+
                                " cp.APLICA_ESPECIFICACIONES_QUIMICAS,cpv.APLICA_ESPECIFICACIONES_QUIMICAS as APLICA_ESPECIFICACIONES_QUIMICASVersion,"+
                                " cp.APLICA_ESPECIFICACIONES_MICROBIOLOGICAS,cpv.APLICA_ESPECIFICACIONES_MICROBIOLOGICAS as APLICA_ESPECIFICACIONES_MICROBIOLOGICASVersion"+
                                " from COMPONENTES_PROD_VERSION cpv left outer join COMPONENTES_PROD_VERSION cp on cp.COD_COMPPROD=cpv.COD_COMPPROD" +
                                        " and cp.COD_VERSION='"+codVersionAnterior+"' and cpv.COD_VERSION='"+codVersion+"'" +
                                        " left outer join AREAS_EMPRESA ae on ae.COD_AREA_EMPRESA=cp.COD_AREA_EMPRESA"+
                                        " left outer join AREAS_EMPRESA ae1 on ae1.COD_AREA_EMPRESA=cpv.COD_AREA_EMPRESA" +
                                        " left outer join PRODUCTOS p on p.cod_prod=cp.COD_PROD"+
                                        " left outer join PRODUCTOS p1 on p1.cod_prod=cpv.COD_PROD" +
                                        " left outer join FORMAS_FARMACEUTICAS ff on ff.cod_forma=cp.COD_FORMA"+
                                        " left outer join FORMAS_FARMACEUTICAS ff1 on ff1.cod_forma=cpv.COD_FORMA" +
                                        " left outer join COLORES_PRESPRIMARIA cpp on cp.COD_COLORPRESPRIMARIA=cpp.COD_COLORPRESPRIMARIA"+
                                        " left outer join COLORES_PRESPRIMARIA cpp1 on cpv.COD_COLORPRESPRIMARIA=cpp1.COD_COLORPRESPRIMARIA" +
                                        " left outer join VIAS_ADMINISTRACION_PRODUCTO vap on vap.COD_VIA_ADMINISTRACION_PRODUCTO=cp.COD_VIA_ADMINISTRACION_PRODUCTO"+
                                        " left outer join VIAS_ADMINISTRACION_PRODUCTO vap1 on vap1.COD_VIA_ADMINISTRACION_PRODUCTO=cpv.COD_VIA_ADMINISTRACION_PRODUCTO" +
                                        " left outer join SABORES_PRODUCTO sp on sp.COD_SABOR=cp.COD_SABOR"+
                                        " left outer join SABORES_PRODUCTO sp1 on sp1.COD_SABOR=cpv.COD_SABOR" +
                                        " left outer join TAMANIOS_CAPSULAS_PRODUCCION tap on tap.COD_TAMANIO_CAPSULA_PRODUCCION=cp.COD_TAMANIO_CAPSULA_PRODUCCION"+
                                        " left outer join TAMANIOS_CAPSULAS_PRODUCCION tap1 on tap1.COD_TAMANIO_CAPSULA_PRODUCCION=cpv.COD_TAMANIO_CAPSULA_PRODUCCION" +
                                        " left outer join ESTADOS_COMPPROD ec on ec.COD_ESTADO_COMPPROD=cp.COD_ESTADO_COMPPROD"+
                                        " left outer join ESTADOS_COMPPROD ec1 on ec1.COD_ESTADO_COMPPROD=cpv.COD_ESTADO_COMPPROD" +
                                        " left outer join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=cp.COD_UNIDAD_MEDIDA_VOLUMEN"+
                                        " left outer join UNIDADES_MEDIDA um1 on um1.COD_UNIDAD_MEDIDA=cpv.COD_UNIDAD_MEDIDA_VOLUMEN" +
                                        " left outer join CONDICIONES_VENTA_PRODUCTO cvp on cvp.COD_CONDICION_VENTA_PRODUCTO=cp.COD_CONDICION_VENTA_PRODUCTO"+
                                        " left outer join CONDICIONES_VENTA_PRODUCTO cvp1 on cvp1.COD_CONDICION_VENTA_PRODUCTO=cpv.COD_CONDICION_VENTA_PRODUCTO"+
                                " where (cpv.COD_VERSION = '"+codVersion+"' and cp.cod_version is null) or"+
                                        " (cp.COD_VERSION = '"+codVersionAnterior+"' and cpv.cod_version is null)"+
                                        " or (cp.cod_version='"+codVersionAnterior+"' and cpv.cod_version='"+codVersion+"')";

                        System.out.println("consulta verificar cambios "+consulta);
                        res=st.executeQuery(consulta);
                        boolean nuevo=false;
                        SimpleDateFormat sdfDias=new SimpleDateFormat("dd/MM/yyyy");
                        if(res.next())
                        {
                            nuevo=res.getInt("codComprodOfi")==0;
                            out.println("<tr class='"+(nuevo?"nuevo":(res.getString("nombre_prod_semiterminado").equals(res.getString("nombre_prod_semiterminadoVersion"))?"":"modificado"))+"'><td class='especificacion'>Nombre Producto Semiterminado</td><td>"+res.getString("nombre_prod_semiterminado")+"</td><td>"+res.getString("nombre_prod_semiterminadoVersion")+"&nbsp;</td></tr>"+
                                        "<tr class='"+(nuevo?"nuevo":(res.getString("NOMBRE_AREA_EMPRESA").equals(res.getString("NOMBRE_AREA_EMPRESAVersion"))?"":"modificado"))+"'><td class='especificacion'>Area Empresa</td><td>"+res.getString("NOMBRE_AREA_EMPRESA")+"</td><td>"+res.getString("NOMBRE_AREA_EMPRESAVersion")+"&nbsp;</td></tr>"+
                                        "<tr class='"+(nuevo?"nuevo":(res.getString("nombre_prod").equals(res.getString("nombre_prodVersion"))?"":"modificado"))+"'><td class='especificacion'>Nombre Comercial</td><td>"+res.getString("nombre_prod")+"</td><td>"+res.getString("nombre_prodVersion")+"&nbsp;</td></tr>"+
                                        "<tr class='"+(nuevo?"nuevo":(res.getInt("TAMANIO_LOTE_PRODUCCION")==res.getInt("TAMANIO_LOTE_PRODUCCIONVersion")?"":"modificado"))+"'><td class='especificacion'>Tamaño Lote Producción</td><td>"+res.getInt("TAMANIO_LOTE_PRODUCCION")+"</td><td>"+res.getInt("TAMANIO_LOTE_PRODUCCIONVersion")+"&nbsp;</td></tr>"+
                                        "<tr class='"+(nuevo?"nuevo":(res.getString("REG_SANITARIO").equals(res.getString("REG_SANITARIOVersion"))?"":"modificado"))+"'><td class='especificacion'>Registro Sanitario</td><td>"+res.getString("REG_SANITARIO")+"</td><td>"+res.getString("REG_SANITARIOVersion")+"&nbsp;</td></tr>"+
                                        "<tr class='"+(nuevo?"nuevo":(res.getInt("VIDA_UTIL")==res.getInt("VIDA_UTILVersion")?"":"modificado"))+"'><td class='especificacion'>Vida Util</td><td>"+res.getInt("VIDA_UTIL")+"</td><td>"+res.getInt("VIDA_UTILVersion")+"&nbsp;</td></tr>"+
                                        "<tr class='"+(nuevo?"nuevo":((res.getTimestamp("FECHA_VENCIMIENTO_RS")!=null?sdfDias.format(res.getTimestamp("FECHA_VENCIMIENTO_RS")):"").equals(res.getTimestamp("FECHA_VENCIMIENTO_RSVersion")!=null?sdfDias.format(res.getTimestamp("FECHA_VENCIMIENTO_RSVersion")):"")?"":"modificado"))+"'>" +
                                        "<td class='especificacion'>Fecha Vencimiento R.S.</td><td>"+(res.getTimestamp("FECHA_VENCIMIENTO_RS")!=null?sdfDias.format(res.getTimestamp("FECHA_VENCIMIENTO_RS")):"&nbsp;")+"&nbsp;</td><td>"+(res.getTimestamp("FECHA_VENCIMIENTO_RSVersion")!=null?sdfDias.format(res.getTimestamp("FECHA_VENCIMIENTO_RSVersion")):"&nbsp;")+"&nbsp;</td></tr>"+
                                        "<tr class='"+(nuevo?"nuevo":(res.getString("NOMBRE_SABOR").equals(res.getString("NOMBRE_SABORVersion"))?"":"modificado"))+"'><td class='especificacion'>Sabor</td><td>"+res.getString("NOMBRE_SABOR")+"&nbsp;</td><td>"+res.getString("NOMBRE_SABORVersion")+"&nbsp;</td></tr>"+
                                        "<tr class='"+(nuevo?"nuevo":(res.getString("NOMBRE_CONDICION_VENTA_PRODUCTO").equals(res.getString("NOMBRE_CONDICION_VENTA_PRODUCTOVersion"))?"":"modificado"))+"'><td class='especificacion'>Condición de Venta</td><td>"+res.getString("NOMBRE_CONDICION_VENTA_PRODUCTO")+"&nbsp;</td><td>"+res.getString("NOMBRE_CONDICION_VENTA_PRODUCTOVersion")+"&nbsp;</td></tr>"+
                                        "<tr class='"+(nuevo?"nuevo":(res.getString("PRESENTACIONES_REGISTRADAS_RS").equals(res.getString("PRESENTACIONES_REGISTRADAS_RSVersion"))?"":"modificado"))+"'><td class='especificacion'>Presentaciones Registradas</td><td>"+res.getString("PRESENTACIONES_REGISTRADAS_RS")+"&nbsp;</td><td>"+res.getString("PRESENTACIONES_REGISTRADAS_RSVersion")+"&nbsp;</td></tr>"+
                                        /*"<tr class='"+(nuevo?"nuevo":(res.getString("NOMBRE_GENERICO").equals(res.getString("NOMBRE_GENERICOVersion"))?"":"modificado"))+"'><td class='especificacion'>Nombre Generico</td><td>"+res.getString("NOMBRE_GENERICO")+"</td><td>"+res.getString("NOMBRE_GENERICOVersion")+"&nbsp;</td></tr>"+*/
                                        "<tr class='"+(nuevo?"nuevo":(res.getString("nombre_forma").equals(res.getString("nombre_formaVersion"))?"":"modificado"))+"'><td class='especificacion'>Forma Farmaceútica</td><td>"+res.getString("nombre_forma")+"</td><td>"+res.getString("nombre_formaVersion")+"&nbsp;</td></tr>"+
                                        "<tr class='"+(nuevo?"nuevo":(res.getString("NOMBRE_COLORPRESPRIMARIA").equals(res.getString("NOMBRE_COLORPRESPRIMARIAVersion"))?"":"modificado"))+"'><td class='especificacion'>Color Presentación Primaria</td><td>"+res.getString("NOMBRE_COLORPRESPRIMARIA")+"&nbsp;</td><td>"+res.getString("NOMBRE_COLORPRESPRIMARIAVersion")+"</td></tr>"+
                                        "<tr class='"+(nuevo?"nuevo":(res.getString("NOMBRE_VIA_ADMINISTRACION_PRODUCTO").equals(res.getString("NOMBRE_VIA_ADMINISTRACION_PRODUCTOVersion"))?"":"modificado"))+"'><td class='especificacion'>Via Administración</td><td>"+res.getString("NOMBRE_VIA_ADMINISTRACION_PRODUCTO")+"&nbsp;</td><td>"+res.getString("NOMBRE_VIA_ADMINISTRACION_PRODUCTOVersion")+"</td></tr>"+
                                        "<tr class='"+(nuevo?"nuevo":(res.getString("PESO_ENVASE_PRIMARIO").equals(res.getString("PESO_ENVASE_PRIMARIOVersion"))?"":"modificado"))+"'><td class='especificacion'>Peso teorico</td><td>"+res.getString("PESO_ENVASE_PRIMARIO")+"&nbsp;</td><td>"+res.getString("PESO_ENVASE_PRIMARIOVersion")+"&nbsp;</td></tr>"+
                                        "<tr class='"+(nuevo?"nuevo":(res.getString("TOLERANCIA_VOLUMEN_FABRICAR").equals(res.getString("TOLERANCIA_VOLUMEN_FABRICARVersion"))?"":"modificado"))+"'><td class='especificacion'>Tolerancia Volumen a Fabricar</td><td>"+res.getString("TOLERANCIA_VOLUMEN_FABRICAR")+"&nbsp;</td><td>"+res.getString("TOLERANCIA_VOLUMEN_FABRICARVersion")+"</td></tr>"+
                                        
                                        "<tr class='"+(nuevo?"nuevo":(res.getString("NOMBRE_TAMANIO_CAPSULA_PRODUCCION").equals(res.getString("NOMBRE_TAMANIO_CAPSULA_PRODUCCIONVersion"))?"":"modificado"))+"'><td class='especificacion'>Tamaño Capsula</td><td>"+res.getString("NOMBRE_TAMANIO_CAPSULA_PRODUCCION")+"&nbsp;</td><td>"+res.getString("NOMBRE_TAMANIO_CAPSULA_PRODUCCIONVersion")+"&nbsp;</td></tr>"+
                                        "<tr class='"+(nuevo?"nuevo":(res.getString("volumen").equals(res.getString("volumenVersion"))?"":"modificado"))+"'><td class='especificacion'>Volumen Envase Primario</td><td>"+res.getString("volumen")+"</td><td>"+res.getString("volumenVersion")+"&nbsp;</td></tr>"+
                                        "<tr class='"+(nuevo?"nuevo":(res.getString("CANTIDAD_VOLUMEN_DE_DOSIFICADO").equals(res.getString("CANTIDAD_VOLUMEN_DE_DOSIFICADOVersion"))?"":"modificado"))+"'><td class='especificacion'>Volumen de Dosificado</td><td>&nbsp;"+res.getString("CANTIDAD_VOLUMEN_DE_DOSIFICADO")+"</td><td>&nbsp;"+res.getString("CANTIDAD_VOLUMEN_DE_DOSIFICADOVersion")+"</td></tr>"+
                                        "<tr class='"+(nuevo?"nuevo":(res.getString("NOMBRE_ESTADO_COMPPROD").equals(res.getString("NOMBRE_ESTADO_COMPPRODVersion"))?"":"modificado"))+"'><td class='especificacion'>Estado</td><td>"+res.getString("NOMBRE_ESTADO_COMPPROD")+"</td><td>"+res.getString("NOMBRE_ESTADO_COMPPRODVersion")+"&nbsp;</td></tr>"+
                                        "<tr class='"+(nuevo?"nuevo":(res.getInt("APLICA_ESPECIFICACIONES_FISICAS")==res.getInt("APLICA_ESPECIFICACIONES_FISICASVersion")?"":"modificado"))+"'><td class='especificacion'>Aplica Especificaciones Fisicas</td><td>"+(res.getInt("APLICA_ESPECIFICACIONES_FISICAS")>0?"SI":"NO")+"</td><td>"+(res.getInt("APLICA_ESPECIFICACIONES_FISICASVersion")>0?"SI":"NO")+"&nbsp;</td></tr>"+
                                        "<tr class='"+(nuevo?"nuevo":(res.getInt("APLICA_ESPECIFICACIONES_QUIMICAS")==res.getInt("APLICA_ESPECIFICACIONES_QUIMICASVersion")?"":"modificado"))+"'><td class='especificacion'>Aplica Especificaciones Quimicas</td><td>"+(res.getInt("APLICA_ESPECIFICACIONES_QUIMICAS")>0?"SI":"NO")+"</td><td>"+(res.getInt("APLICA_ESPECIFICACIONES_QUIMICASVersion")>0?"SI":"NO")+"&nbsp;</td></tr>"+
                                        "<tr class='"+(nuevo?"nuevo":(res.getInt("APLICA_ESPECIFICACIONES_MICROBIOLOGICAS")==res.getInt("APLICA_ESPECIFICACIONES_MICROBIOLOGICASVersion")?"":"modificado"))+"'><td class='especificacion'>Aplica Especificaciones Microbiologicas</td><td>"+(res.getInt("APLICA_ESPECIFICACIONES_MICROBIOLOGICAS")>0?"SI":"NO")+"</td><td>"+(res.getInt("APLICA_ESPECIFICACIONES_MICROBIOLOGICASVersion")>0?"SI":"NO")+"&nbsp;</td></tr>");
                        }
                        out.println("</table><table class='tablaComparacion' cellpadding='0' cellspacing='0'>" +
                                    "<thead><tr><td colspan='14'>Concentracion</td></tr>" +
                                    "<tr><td rowspan=2>Nombre Genérico</td><td rowspan=2>Material</td><td colspan='2'>Cantidad</td><td colspan=2>Unidad Medida</td><td colspan=2>Material Equivalencia</td>" +
                                    "<td colspan=2>Cantidad Equivalencia</td><td colspan=2>Unidad Medidad<br>Equivalencia</td><td colspan=2>Excipiente</td></tr>" +
                                    "<tr><td>Antes</td><td>Despues</td><td>Antes</td><td>Despues</td><td>Antes</td><td>Despues</td><td>Antes</td><td>Despues</td><td>Antes</td><td>Despues</td><td>Antes</td><td>Despues</td></tr></thead>");
                        //diferencias de concentración
                        consulta="select m.NOMBRE_MATERIAL,NOMBRE_CCC,"+
                                 " cpc.COD_VERSION,cpc.CANTIDAD,isnull(um.ABREVIATURA,'') as ABREVIATURA,isnull(cpc.NOMBRE_MATERIAL_EQUIVALENCIA,'') as NOMBRE_MATERIAL_EQUIVALENCIA,cpc.CANTIDAD_EQUIVALENCIA,isnull(ume.ABREVIATURA,'') as ABREVIATURAE,"+
                                 " cpc1.COD_VERSION as COD_VERSIONVersion,cpc1.CANTIDAD as CANTIDADVersion,isnull(um1.ABREVIATURA,'') as ABREVIATURAVersion,isnull(cpc1.NOMBRE_MATERIAL_EQUIVALENCIA,'') as NOMBRE_MATERIAL_EQUIVALENCIAVersion,cpc1.CANTIDAD_EQUIVALENCIA  as CANTIDAD_EQUIVALENCIAVersion,isnull(ume1.ABREVIATURA,'') as ABREVIATURAEVersion"+
                                 ",cpc.EXCIPIENTE,cpc1.EXCIPIENTE as EXCIPIENTEVersion"+
                                 " from COMPONENTES_PROD_CONCENTRACION cpc full outer join COMPONENTES_PROD_CONCENTRACION cpc1"+
                                 " on cpc.COD_MATERIAL=cpc1.COD_MATERIAL"+
                                 " and cpc.COD_VERSION='"+codVersionAnterior+"' and cpc1.COD_VERSION='"+codVersion+"'"+
                                 " left outer join materiales m on m.COD_MATERIAL=isnull(cpc.COD_MATERIAL,cpc1.COD_MATERIAL)"+
                                 " left outer join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=cpc.COD_UNIDAD_MEDIDA"+
                                 " left outer join UNIDADES_MEDIDA um1 on um1.COD_UNIDAD_MEDIDA=cpc1.COD_UNIDAD_MEDIDA"+
                                 " left outer join UNIDADES_MEDIDA ume on ume.COD_UNIDAD_MEDIDA=cpc.COD_UNIDAD_MEDIDA_EQUIVALENCIA"+
                                 " left outer join UNIDADES_MEDIDA ume1 on ume1.COD_UNIDAD_MEDIDA=cpc1.COD_UNIDAD_MEDIDA_EQUIVALENCIA"+
                                 " where (cpc.COD_VERSION='"+codVersionAnterior+"'" +
                                 " or cpc1.COD_VERSION='"+codVersion+"')"+
                                 " order by m.NOMBRE_MATERIAL";
                        System.out.println("consulta diferencias concentracion "+consulta);
                        res=st.executeQuery(consulta);
                        while(res.next())
                        {
                            out.println("<tr class='"+(res.getInt("COD_VERSION")==0?"nuevo":(res.getInt("COD_VERSIONVersion")==0?"eliminado":""))+"'>" +
                                        "<td>"+(res.getInt("EXCIPIENTEVersion")==0?res.getString("NOMBRE_CCC"):"N.A.")+"</td>"+
                                        "<td>"+res.getString("NOMBRE_MATERIAL")+"</td>"+
                                        "<td class='"+((res.getInt("COD_VERSION")!=0&&res.getInt("COD_VERSIONVersion")!=0)?(res.getDouble("CANTIDAD")==res.getDouble("CANTIDADVersion")?"":"modificado"):"")+"' >&nbsp;"+res.getDouble("CANTIDAD")+"</td>" +
                                        "<td class='"+((res.getInt("COD_VERSION")!=0&&res.getInt("COD_VERSIONVersion")!=0)?(res.getDouble("CANTIDAD")==res.getDouble("CANTIDADVersion")?"":"modificado"):"")+"' >&nbsp;"+res.getDouble("CANTIDADVersion")+"</td>" +
                                        "<td class='"+((res.getInt("COD_VERSION")!=0&&res.getInt("COD_VERSIONVersion")!=0)?(res.getString("ABREVIATURA").equals(res.getString("ABREVIATURAVersion"))?"":"modificado"):"")+"' >&nbsp;"+res.getString("ABREVIATURA")+"</td>" +
                                        "<td class='"+((res.getInt("COD_VERSION")!=0&&res.getInt("COD_VERSIONVersion")!=0)?(res.getString("ABREVIATURA").equals(res.getString("ABREVIATURAVersion"))?"":"modificado"):"")+"' >&nbsp;"+res.getString("ABREVIATURAVersion")+"</td>" +
                                        "<td class='"+((res.getInt("COD_VERSION")!=0&&res.getInt("COD_VERSIONVersion")!=0)?(res.getString("NOMBRE_MATERIAL_EQUIVALENCIA").equals(res.getString("NOMBRE_MATERIAL_EQUIVALENCIAVersion"))?"":"modificado"):"")+"' >&nbsp;"+res.getString("NOMBRE_MATERIAL_EQUIVALENCIA")+"</td>" +
                                        "<td class='"+((res.getInt("COD_VERSION")!=0&&res.getInt("COD_VERSIONVersion")!=0)?(res.getString("NOMBRE_MATERIAL_EQUIVALENCIA").equals(res.getString("NOMBRE_MATERIAL_EQUIVALENCIAVersion"))?"":"modificado"):"")+"' >&nbsp;"+res.getString("NOMBRE_MATERIAL_EQUIVALENCIAVersion")+"</td>" +
                                        "<td class='"+((res.getInt("COD_VERSION")!=0&&res.getInt("COD_VERSIONVersion")!=0)?(res.getDouble("CANTIDAD")==res.getDouble("CANTIDADVersion")?"":"modificado"):"")+"' >&nbsp;"+res.getDouble("CANTIDAD_EQUIVALENCIA")+"</td>" +
                                        "<td class='"+((res.getInt("COD_VERSION")!=0&&res.getInt("COD_VERSIONVersion")!=0)?(res.getDouble("CANTIDAD")==res.getDouble("CANTIDADVersion")?"":"modificado"):"")+"' >&nbsp;"+res.getDouble("CANTIDAD_EQUIVALENCIAVersion")+"</td>" +
                                        "<td class='"+((res.getInt("COD_VERSION")!=0&&res.getInt("COD_VERSIONVersion")!=0)?(res.getString("ABREVIATURAE").equals(res.getString("ABREVIATURAEVersion"))?"":"modificado"):"")+"' >&nbsp;"+res.getString("ABREVIATURAE")+"</td>" +
                                        "<td class='"+((res.getInt("COD_VERSION")!=0&&res.getInt("COD_VERSIONVersion")!=0)?(res.getString("ABREVIATURAE").equals(res.getString("ABREVIATURAEVersion"))?"":"modificado"):"")+"' >&nbsp;"+res.getString("ABREVIATURAEVersion")+"</td>" +
                                        "<td class='"+((res.getInt("COD_VERSION")!=0&&res.getInt("COD_VERSIONVersion")!=0)?(res.getInt("EXCIPIENTE")!=res.getInt("EXCIPIENTEVersion")?"modificado":""):"")+"' >&nbsp;"+(res.getInt("EXCIPIENTE")>0?"SI":"NO")+"</td>" +
                                        "<td class='"+((res.getInt("COD_VERSION")!=0&&res.getInt("COD_VERSIONVersion")!=0)?(res.getInt("EXCIPIENTE")!=res.getInt("EXCIPIENTEVersion")?"modificado":""):"")+"' >&nbsp;"+(res.getInt("EXCIPIENTEVersion")>0?"SI":"NO")+"</td>" +
                                        "</tr>");
                        }
                        consulta="select isnull(ep.nombre_envaseprim,'') as nombre_envaseprim,isnull(ep1.nombre_envaseprim,'') as nombre_envaseprimVersion,"+
                                 " isnull(tpp.NOMBRE_TIPO_PROGRAMA_PROD,'') as NOMBRE_TIPO_PROGRAMA_PROD,isnull(tpp1.NOMBRE_TIPO_PROGRAMA_PROD,'') as NOMBRE_TIPO_PROGRAMA_PRODVersion" +
                                 " ,isnull(pp.CANTIDAD,0) as CANTIDAD,isnull(ppv.CANTIDAD,0) as CANTIDADVersion"+
                                 " ,isnull(tpp.NOMBRE_TIPO_PROGRAMA_PROD,'') as NOMBRE_TIPO_PROGRAMA_PROD"+
                                 " ,isnull(tpp1.NOMBRE_TIPO_PROGRAMA_PROD,'') as NOMBRE_TIPO_PROGRAMA_PRODVersion" +
                                 " ,isnull(er.NOMBRE_ESTADO_REGISTRO,'') as NOMBRE_ESTADO_REGISTRO"+
                                 " ,isnull(er1.NOMBRE_ESTADO_REGISTRO,'') as NOMBRE_ESTADO_REGISTROVersion" +
                                 " ,isnull(pp.COD_PRESENTACION_PRIMARIA,0) as codPresentacionPrimOfi" +
                                 " ,isnull(ppv.COD_PRESENTACION_PRIMARIA,0) as codPresentacionPrimVer"+
                                 " from PRESENTACIONES_PRIMARIAS_VERSION pp full outer join PRESENTACIONES_PRIMARIAS_VERSION ppv"+
                                 " on pp.COD_PRESENTACION_PRIMARIA=ppv.COD_PRESENTACION_PRIMARIA" +
                                 " and pp.COD_VERSION='"+codVersionAnterior+"'" +
                                 " and ppv.COD_VERSION='"+codVersion+"'"+
                                 " left outer join ENVASES_PRIMARIOS ep on ep.cod_envaseprim=pp.COD_ENVASEPRIM"+
                                 " left outer join ENVASES_PRIMARIOS ep1 on ep1.cod_envaseprim=ppv.COD_ENVASEPRIM"+
                                 " left outer join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD"+
                                 " left outer join TIPOS_PROGRAMA_PRODUCCION tpp1 on tpp1.COD_TIPO_PROGRAMA_PROD=ppv.COD_TIPO_PROGRAMA_PROD" +
                                 " left outer join ESTADOS_REFERENCIALES er on er.COD_ESTADO_REGISTRO=pp.COD_ESTADO_REGISTRO"+
                                 " left outer join ESTADOS_REFERENCIALES er1 on er1.COD_ESTADO_REGISTRO=ppv.COD_ESTADO_REGISTRO"+
                                 " where ( pp.COD_VERSION='"+codVersionAnterior+"' OR" +
                                 "  ppv.COD_VERSION = '"+codVersion+"')";
                        System.out.println("consulta diferencias pres prim "+consulta);
                        res=st.executeQuery(consulta);
                        out.println("</table><table class='tablaComparacion' cellpadding='0' cellspacing='0'>" +
                                    "<thead><tr><td colspan='8'>Diferencia de versiones<br>Presentacion Primaria</td></tr>" +
                                    "<tr><td colspan=2>Envase Primario</td><td colspan=2>Cantidad</td><td colspan=2>Tipo Programa Producción</td><td colspan=2>Estado</td></tr>" +
                                    "<tr><td>Antes</td><td>Despues</td><td>Antes</td><td>Despues</td><td>Antes</td><td>Despues</td><td>Antes</td><td>Despues</td></tr></thead>");
                        while(res.next())
                        {
                            out.println("<tr class='"+(res.getInt("codPresentacionPrimOfi")==0?"nuevo":(res.getInt("codPresentacionPrimVer")==0?"eliminado":""))+"'>" +
                                        "<td class='"+((res.getInt("codPresentacionPrimOfi")!=0&&res.getInt("codPresentacionPrimVer")!=0)?(res.getString("nombre_envaseprim").equals(res.getString("nombre_envaseprimVersion"))?"":"modificado"):"")+"' >&nbsp;"+res.getString("nombre_envaseprim")+"</td>" +
                                        "<td class='"+((res.getInt("codPresentacionPrimOfi")!=0&&res.getInt("codPresentacionPrimVer")!=0)?(res.getString("nombre_envaseprim").equals(res.getString("nombre_envaseprimVersion"))?"":"modificado"):"")+"' >&nbsp;"+res.getString("nombre_envaseprimVersion")+"</td>" +
                                        "<td class='"+((res.getInt("codPresentacionPrimOfi")!=0&&res.getInt("codPresentacionPrimVer")!=0)?(res.getInt("CANTIDAD")!=res.getInt("CANTIDADVersion")?"modificado":""):"")+"'>&nbsp;"+(res.getInt("CANTIDAD")>0?res.getInt("CANTIDAD"):"")+"</td>" +
                                        "<td class='"+((res.getInt("codPresentacionPrimOfi")!=0&&res.getInt("codPresentacionPrimVer")!=0)?(res.getInt("CANTIDAD")!=res.getInt("CANTIDADVersion")?"modificado":""):"")+"'>&nbsp;"+(res.getInt("CANTIDADVersion")>0?res.getInt("CANTIDADVersion"):"")+"</td>" +
                                        "<td class='"+((res.getInt("codPresentacionPrimOfi")!=0&&res.getInt("codPresentacionPrimVer")!=0)?(res.getString("NOMBRE_TIPO_PROGRAMA_PROD").equals(res.getString("NOMBRE_TIPO_PROGRAMA_PRODVersion"))?"":"modificado"):"")+"' >&nbsp;"+res.getString("NOMBRE_TIPO_PROGRAMA_PROD")+"</td>" +
                                        "<td class='"+((res.getInt("codPresentacionPrimOfi")!=0&&res.getInt("codPresentacionPrimVer")!=0)?(res.getString("NOMBRE_TIPO_PROGRAMA_PROD").equals(res.getString("NOMBRE_TIPO_PROGRAMA_PRODVersion"))?"":"modificado"):"")+"' >&nbsp;"+res.getString("NOMBRE_TIPO_PROGRAMA_PRODVersion")+"</td>" +
                                        "<td class='"+((res.getInt("codPresentacionPrimOfi")!=0&&res.getInt("codPresentacionPrimVer")!=0)?(res.getString("NOMBRE_ESTADO_REGISTRO").equals(res.getString("NOMBRE_ESTADO_REGISTROVersion"))?"":"modificado"):"")+"' >&nbsp;"+res.getString("NOMBRE_ESTADO_REGISTRO")+"</td>" +
                                        "<td class='"+((res.getInt("codPresentacionPrimOfi")!=0&&res.getInt("codPresentacionPrimVer")!=0)?(res.getString("NOMBRE_ESTADO_REGISTRO").equals(res.getString("NOMBRE_ESTADO_REGISTROVersion"))?"":"modificado"):"")+"'>&nbsp;"+res.getString("NOMBRE_ESTADO_REGISTROVersion")+"</td>" +
                                        "</tr>");
                        }
                        out.println("</table>");
                        out.println("<table class='tablaComparacion' cellpadding='0' cellspacing='0'>" +
                                    "<thead><tr><td colspan='6'>Especificaciones Fisicas de Control de Calidad</td></tr>" +
                                    "<tr><td rowspan=2>Analisis Físico</td><td colspan=2>Especificación</td>" +
                                    "<td colspan=2>Tipo de Referencia</td><td rowspan='2'>Unidad</td></tr>" +
                                    "<tr><td>Antes</td><td>Despues</td><td>Antes</td><td>Despues</td></tr></thead>");
                        consulta="select efc.NOMBRE_ESPECIFICACION,efc.COEFICIENTE,ISNULL(efc.UNIDAD,'') AS UNIDAD,tra.NOMBRE_TIPO_RESULTADO_ANALISIS,tra.COD_TIPO_RESULTADO_ANALISIS,tra.SIMBOLO"+
                                 " ,efp.COD_ESPECIFICACION,efp.LIMITE_INFERIOR,efp.LIMITE_SUPERIOR,efp.VALOR_EXACTO,isnull(efp.DESCRIPCION,'') as DESCRIPCION,efp.COD_REFERENCIA_CC,isnull(tr.NOMBRE_REFERENCIACC,'') as NOMBRE_REFERENCIACC"+
                                 " ,efp1.COD_ESPECIFICACION as COD_ESPECIFICACIONVersion,efp1.LIMITE_INFERIOR as LIMITE_INFERIORVersion,efp1.LIMITE_SUPERIOR as LIMITE_SUPERIORVersion,efp1.VALOR_EXACTO AS VALOR_EXACTOVersion,isnull(efp1.DESCRIPCION,'') as DESCRIPCIONVersion,efp1.COD_REFERENCIA_CC,isnull(tr1.NOMBRE_REFERENCIACC,'') as NOMBRE_REFERENCIACCVersion"+
                                 " from ESPECIFICACIONES_FISICAS_PRODUCTO efp "+
                                 " full outer join ESPECIFICACIONES_FISICAS_PRODUCTO efp1 on"+
                                 " efp.COD_ESPECIFICACION=efp1.COD_ESPECIFICACION"+
                                 " and efp.COD_VERSION='"+codVersionAnterior+"' and efp1.COD_VERSION='"+codVersion+"'"+
                                 " left outer join ESPECIFICACIONES_FISICAS_CC efc on ("+
                                 " efc.COD_ESPECIFICACION=efp.COD_ESPECIFICACION or efp1.COD_ESPECIFICACION=efc.COD_ESPECIFICACION)"+
                                 " left outer join TIPOS_REFERENCIACC tr on tr.COD_REFERENCIACC=efp.COD_REFERENCIA_CC"+
                                 " left outer join TIPOS_REFERENCIACC tr1 on tr1.COD_REFERENCIACC=efp1.COD_REFERENCIA_CC"+
                                 " left outer join TIPOS_RESULTADOS_ANALISIS tra on tra.COD_TIPO_RESULTADO_ANALISIS=efc.COD_TIPO_RESULTADO_ANALISIS"+
                                 " where (efp.COD_VERSION='"+codVersionAnterior+"' or efp1.COD_VERSION='"+codVersion+"')"+
                                 " order by efc.NOMBRE_ESPECIFICACION";
                        System.out.println("consulta diferencias especificaciones fisicas "+consulta);
                        res=st.executeQuery(consulta);
                        String especificacion="";
                        String especificacionVersion="";
                        while(res.next())
                        {
                            switch(res.getInt("COD_TIPO_RESULTADO_ANALISIS"))
                            {
                                case 1:
                                {
                                    especificacion=res.getString("DESCRIPCION");
                                    especificacionVersion=res.getString("DESCRIPCIONVersion");
                                    break;
                                }
                                case 2:
                                {
                                    especificacion=res.getDouble("LIMITE_INFERIOR")+" "+res.getString("UNIDAD")+"-"+res.getDouble("LIMITE_SUPERIOR")+" "+res.getString("UNIDAD");
                                    especificacionVersion=res.getDouble("LIMITE_INFERIORVersion")+" "+res.getString("UNIDAD")+"-"+res.getDouble("LIMITE_SUPERIORVersion")+" "+res.getString("UNIDAD");
                                    break;
                                }
                                default:
                                {
                                    especificacion=res.getString("COEFICIENTE")+res.getString("SIMBOLO")+" "+res.getDouble("VALOR_EXACTO")+" "+res.getString("UNIDAD");
                                    especificacionVersion=res.getString("COEFICIENTE")+res.getString("SIMBOLO")+" "+res.getDouble("VALOR_EXACTOVersion")+" "+res.getString("UNIDAD");

                                }
                            }
                            out.println("<tr class='"+(res.getInt("COD_ESPECIFICACION")==0?"nuevo":(res.getInt("COD_ESPECIFICACIONVersion")==0?"eliminado":""))+"'>" +
                                        "<td>&nbsp;"+res.getString("NOMBRE_ESPECIFICACION")+"</td>" +

                                        "<td class='"+(res.getInt("COD_ESPECIFICACION")!=0&&res.getInt("COD_ESPECIFICACIONVersion")!=0?(especificacion.equals(especificacionVersion)?"":"modificado"):"")+"' >&nbsp;"+especificacion+"</td>" +
                                        "<td class='"+(res.getInt("COD_ESPECIFICACION")!=0&&res.getInt("COD_ESPECIFICACIONVersion")!=0?(especificacion.equals(especificacionVersion)?"":"modificado"):"")+"' >&nbsp;"+especificacionVersion+"</td>" +
                                        "<td class='"+(res.getInt("COD_ESPECIFICACION")!=0&&res.getInt("COD_ESPECIFICACIONVersion")!=0?(res.getString("NOMBRE_REFERENCIACC").equals(res.getString("NOMBRE_REFERENCIACCVersion"))?"":"modificado"):"")+"' >&nbsp;"+res.getString("NOMBRE_REFERENCIACC")+"</td>" +
                                        "<td class='"+(res.getInt("COD_ESPECIFICACION")!=0&&res.getInt("COD_ESPECIFICACIONVersion")!=0?(res.getString("NOMBRE_REFERENCIACC").equals(res.getString("NOMBRE_REFERENCIACCVersion"))?"":"modificado"):"")+"' >&nbsp;"+res.getString("NOMBRE_REFERENCIACCVersion")+"</td>" +
                                        "<td>&nbsp;"+res.getString("UNIDAD")+"</td>" +
                                        "</tr>");
                        }
                        out.println("</table><table class='tablaComparacion' cellpadding='0' cellspacing='0'>" +
                                    "<thead><tr><td colspan='6'>Especificaciones Quimicas de Control de Calidad</td></tr>" +
                                    "<tr><td rowspan=2>Analisis Quimico</td><td colspan=2>Especificación</td>" +
                                    "<td colspan=2>Tipo de Referencia</td><td rowspan='2'>Unidad</td></tr>" +
                                    "<tr><td>Antes</td><td>Despues</td><td>Antes</td><td>Despues</td></tr></thead>");
                        consulta="select eqc.COD_ESPECIFICACION,eqc.NOMBRE_ESPECIFICACION,eqc.COD_TIPO_RESULTADO_ANALISIS,ISNULL(eqc.COEFICIENTE, '') as COEFICIENTE,"+
                                 " ISNULL(tra.SIMBOLO, '') as SIMBOLO,ISNULL(eqc.UNIDAD, '') AS unidad"+
                                 " from ESPECIFICACIONES_QUIMICAS_CC eqc left outer join TIPOS_RESULTADOS_ANALISIS tra"+
                                 " on eqc.COD_TIPO_RESULTADO_ANALISIS=tra.COD_TIPO_RESULTADO_ANALISIS"+
                                 " where (eqc.COD_ESPECIFICACION in (select eqp.COD_ESPECIFICACION from ESPECIFICACIONES_QUIMICAS_PRODUCTO eqp where eqp.COD_VERSION='"+codVersionAnterior+"')"+
                                 " or eqc.COD_ESPECIFICACION in (select eqp1.COD_ESPECIFICACION from ESPECIFICACIONES_QUIMICAS_PRODUCTO eqp1 where eqp1.COD_VERSION='"+codVersion+"'))"+
                                 " order by eqc.NOMBRE_ESPECIFICACION";
                        System.out.println("consulta especificaciones quimicas "+consulta);
                        res=st.executeQuery(consulta);
                        Statement stDetalle=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                        ResultSet resDetalle=null;
                        while(res.next())
                        {
                            out.println("<tr><td class='celdaQuimica' colspan='6'>"+res.getString("NOMBRE_ESPECIFICACION")+"</td></tr>");
                            consulta="select isnull(m.NOMBRE_CCC,'ESPECIFICACION GENERAL') as NOMBRE_MATERIAL"+
                                     " ,eqp.COD_ESPECIFICACION,eqp.VALOR_EXACTO,eqp.LIMITE_INFERIOR,eqp.LIMITE_SUPERIOR,isnull(eqp.DESCRIPCION,'') as DESCRIPCION,isnull(tr.NOMBRE_REFERENCIACC,'') as NOMBRE_REFERENCIACC,"+
                                     " eqp1.COD_ESPECIFICACION as COD_ESPECIFICACIONVersion,eqp1.VALOR_EXACTO as VALOR_EXACTOVersion,eqp1.LIMITE_INFERIOR as LIMITE_INFERIORVersion" +
                                     ",eqp1.LIMITE_SUPERIOR as LIMITE_SUPERIORVersion,isnull(eqp1.DESCRIPCION,'') as  DESCRIPCIONVersion,isnull(tr1.NOMBRE_REFERENCIACC,'') as NOMBRE_REFERENCIACCVersion"+
                                     " from ESPECIFICACIONES_QUIMICAS_PRODUCTO eqp "+
                                     " full outer join ESPECIFICACIONES_QUIMICAS_PRODUCTO eqp1 on"+
                                     " eqp.COD_ESPECIFICACION=eqp1.COD_ESPECIFICACION"+
                                     " and eqp.COD_VERSION='"+codVersionAnterior+"' and eqp1.COD_VERSION='"+codVersion+"'"+
                                     " and eqp.COD_MATERIAL=eqp1.COD_MATERIAL"+
                                     " left outer join TIPOS_REFERENCIACC tr on tr.COD_REFERENCIACC=eqp.COD_REFERENCIA_CC"+
                                     " left outer join TIPOS_REFERENCIACC tr1 on tr1.COD_REFERENCIACC=eqp1.COD_REFERENCIA_CC"+
                                     " left outer join MATERIALES m on (m.COD_MATERIAL=eqp.COD_MATERIAL or m.COD_MATERIAL=eqp1.COD_MATERIAL)"+
                                     " where ((eqp.COD_VERSION='"+codVersionAnterior+"' and eqp.COD_ESPECIFICACION='"+res.getInt("COD_ESPECIFICACION")+"')" +
                                     " or (eqp1.COD_VERSION='"+codVersion+"' and eqp1.COD_ESPECIFICACION='"+res.getInt("COD_ESPECIFICACION")+"'))"+
                                     " order by m.NOMBRE_MATERIAL";
                            System.out.println("consulta detalle especificaciones "+consulta);

                            resDetalle=stDetalle.executeQuery(consulta);
                            while(resDetalle.next())
                            {
                                switch(res.getInt("COD_TIPO_RESULTADO_ANALISIS"))
                                {
                                    case 1:
                                    {
                                        especificacion=resDetalle.getString("DESCRIPCION");
                                        especificacionVersion=resDetalle.getString("DESCRIPCIONVersion");
                                        break;
                                    }
                                    case 2:
                                    {
                                        especificacion=resDetalle.getDouble("LIMITE_INFERIOR")+" "+res.getString("UNIDAD")+"-"+resDetalle.getDouble("LIMITE_SUPERIOR")+" "+res.getString("UNIDAD");
                                        especificacionVersion=resDetalle.getDouble("LIMITE_INFERIORVersion")+" "+res.getString("UNIDAD")+"-"+resDetalle.getDouble("LIMITE_SUPERIORVersion")+" "+res.getString("UNIDAD");
                                        break;
                                    }
                                    default:
                                    {
                                        especificacion=res.getString("COEFICIENTE")+res.getString("SIMBOLO")+" "+resDetalle.getDouble("VALOR_EXACTO")+" "+res.getString("UNIDAD");
                                        especificacionVersion=res.getString("COEFICIENTE")+res.getString("SIMBOLO")+" "+resDetalle.getDouble("VALOR_EXACTOVersion")+" "+res.getString("UNIDAD");

                                    }
                                }
                                out.println("<tr class='"+(resDetalle.getInt("COD_ESPECIFICACION")==0?"nuevo":(resDetalle.getInt("COD_ESPECIFICACIONVersion")==0?"eliminado":""))+"'>" +
                                        "<td>&nbsp;"+resDetalle.getString("NOMBRE_MATERIAL")+"</td>"+
                                        "<td class='"+(resDetalle.getInt("COD_ESPECIFICACION")!=0&&resDetalle.getInt("COD_ESPECIFICACIONVersion")!=0?(especificacion.equals(especificacionVersion)?"":"modificado"):"")+"' >&nbsp;"+especificacion+"</td>" +
                                        "<td class='"+(resDetalle.getInt("COD_ESPECIFICACION")!=0&&resDetalle.getInt("COD_ESPECIFICACIONVersion")!=0?(especificacion.equals(especificacionVersion)?"":"modificado"):"")+"' >&nbsp;"+especificacionVersion+"</td>"+
                                        "<td class='"+(resDetalle.getInt("COD_ESPECIFICACION")!=0&&resDetalle.getInt("COD_ESPECIFICACIONVersion")!=0?(resDetalle.getString("NOMBRE_REFERENCIACC").equals(resDetalle.getString("NOMBRE_REFERENCIACCVersion"))?"":"modificado"):"")+"' >&nbsp;"+resDetalle.getString("NOMBRE_REFERENCIACC")+"</td>" +
                                        "<td class='"+(resDetalle.getInt("COD_ESPECIFICACION")!=0&&resDetalle.getInt("COD_ESPECIFICACIONVersion")!=0?(resDetalle.getString("NOMBRE_REFERENCIACC").equals(resDetalle.getString("NOMBRE_REFERENCIACCVersion"))?"":"modificado"):"")+"' >&nbsp;"+resDetalle.getString("NOMBRE_REFERENCIACCVersion")+"</td>" +
                                        "<td>&nbsp;"+res.getString("UNIDAD")+"</td>" +
                                        "</tr>");
                            }
                        }
                        out.println("</table><table class='tablaComparacion' cellpadding='0' cellspacing='0'>" +
                                    "<thead><tr><td colspan='6'>Especificaciones Microbiologicas de Control de Calidad</td></tr>" +
                                    "<tr><td rowspan=2>Analisis Microbiológico</td><td colspan=2>Especificación</td>" +
                                    "<td colspan=2>Tipo de Referencia</td><td rowspan='2'>Unidad</td></tr>" +
                                    "<tr><td>Antes</td><td>Despues</td><td>Antes</td><td>Despues</td></tr></thead>");
                        consulta="select em.NOMBRE_ESPECIFICACION,em.COEFICIENTE,ISNULL(em.UNIDAD,'') as UNIDAD,tra.COD_TIPO_RESULTADO_ANALISIS,tra.SIMBOLO,"+
                                 " emp.COD_ESPECIFICACION,emp.VALOR_EXACTO,emp.LIMITE_INFERIOR,emp.LIMITE_SUPERIOR,isnull(emp.DESCRIPCION,'') as DESCRIPCION,isnull(tr.NOMBRE_REFERENCIACC,'') as NOMBRE_REFERENCIACC,"+
                                 " emp1.COD_ESPECIFICACION as COD_ESPECIFICACIONVersion,emp1.VALOR_EXACTO as VALOR_EXACTOVersion,emp1.LIMITE_INFERIOR as LIMITE_INFERIORVersion,emp1.LIMITE_SUPERIOR as LIMITE_SUPERIORVersion,ISNULL(emp1.DESCRIPCION,'') as DESCRIPCIONVersion,isnull(tr1.NOMBRE_REFERENCIACC,'') as NOMBRE_REFERENCIACCVersion"+
                                 " from ESPECIFICACIONES_MICROBIOLOGIA_PRODUCTO emp full outer join"+
                                 " ESPECIFICACIONES_MICROBIOLOGIA_PRODUCTO emp1 on emp.COD_ESPECIFICACION=emp1.COD_ESPECIFICACION"+
                                 " and emp.COD_VERSION='"+codVersionAnterior+"' and emp1.COD_VERSION='"+codVersion+"'"+
                                 " left outer join ESPECIFICACIONES_MICROBIOLOGIA em on"+
                                 " (em.COD_ESPECIFICACION=emp.COD_ESPECIFICACION or em.COD_ESPECIFICACION=emp1.COD_ESPECIFICACION)"+
                                 " left outer join TIPOS_RESULTADOS_ANALISIS tra on tra.COD_TIPO_RESULTADO_ANALISIS=em.COD_TIPO_RESULTADO_ANALISIS"+
                                 " left outer join TIPOS_REFERENCIACC tr on tr.COD_REFERENCIACC=emp.COD_REFERENCIA_CC"+
                                 " left outer join TIPOS_REFERENCIACC tr1 on tr1.COD_REFERENCIACC=emp1.COD_REFERENCIA_CC"+
                                 " where (emp.COD_VERSION='"+codVersionAnterior+"' or emp1.COD_VERSION='"+codVersion+"')"+
                                 " order by em.NOMBRE_ESPECIFICACION";
                        System.out.println("consulta cargar especificaciones micro "+consulta);
                        res=st.executeQuery(consulta);
                        while(res.next())
                        {
                            switch(res.getInt("COD_TIPO_RESULTADO_ANALISIS"))
                            {
                                case 1:
                                {
                                    especificacion=res.getString("DESCRIPCION");
                                    especificacionVersion=res.getString("DESCRIPCIONVersion");
                                    break;
                                }
                                case 2:
                                {
                                    especificacion=res.getDouble("LIMITE_INFERIOR")+" "+res.getString("UNIDAD")+"-"+res.getDouble("LIMITE_SUPERIOR")+" "+res.getString("UNIDAD");
                                    especificacion=res.getDouble("LIMITE_INFERIORVersion")+" "+res.getString("UNIDAD")+"-"+res.getDouble("LIMITE_SUPERIORVersion")+" "+res.getString("UNIDAD");
                                    break;
                                }
                                default:
                                {
                                    especificacion=res.getString("COEFICIENTE")+res.getString("SIMBOLO")+" "+res.getDouble("VALOR_EXACTO")+" "+res.getString("UNIDAD");
                                    especificacionVersion=res.getString("COEFICIENTE")+res.getString("SIMBOLO")+" "+res.getDouble("VALOR_EXACTOVersion")+" "+res.getString("UNIDAD");

                                }
                            }
                            out.println("<tr class='"+(res.getInt("COD_ESPECIFICACION")==0?"nuevo":(res.getInt("COD_ESPECIFICACIONVersion")==0?"eliminado":""))+"'>" +
                                        "<td>&nbsp;"+res.getString("NOMBRE_ESPECIFICACION")+"</td>" +

                                        "<td class='"+(res.getInt("COD_ESPECIFICACION")!=0&&res.getInt("COD_ESPECIFICACIONVersion")!=0?(especificacion.equals(especificacionVersion)?"":"modificado"):"")+"' >&nbsp;"+especificacion+"</td>" +
                                        "<td class='"+(res.getInt("COD_ESPECIFICACION")!=0&&res.getInt("COD_ESPECIFICACIONVersion")!=0?(especificacion.equals(especificacionVersion)?"":"modificado"):"")+"' >&nbsp;"+especificacionVersion+"</td>" +
                                        "<td class='"+(res.getInt("COD_ESPECIFICACION")!=0&&res.getInt("COD_ESPECIFICACIONVersion")!=0?(res.getString("NOMBRE_REFERENCIACC").equals(res.getString("NOMBRE_REFERENCIACCVersion"))?"":"modificado"):"")+"' >&nbsp;"+res.getString("NOMBRE_REFERENCIACC")+"</td>" +
                                        "<td class='"+(res.getInt("COD_ESPECIFICACION")!=0&&res.getInt("COD_ESPECIFICACIONVersion")!=0?(res.getString("NOMBRE_REFERENCIACC").equals(res.getString("NOMBRE_REFERENCIACCVersion"))?"":"modificado"):"")+"' >&nbsp;"+res.getString("NOMBRE_REFERENCIACCVersion")+"</td>" +
                                        "<td>&nbsp;"+res.getString("UNIDAD")+"</td>" +
                                        "</tr>");
                        }
                       out.println("</table>");
                       out.println("<table class='tablaComparacion'  cellpadding='0' cellspacing='0' id='tablaMP' style='margin-top:1em;'> "+
                                    " <thead><tr  align='center'><td  colspan='12'><span class='outputText2'>Diferencias MP</span></td>"+
                                    " </tr><tr  align='center'><td rowspan='2' ><span class='outputText2' >Material</span></td>"+
                                    "<td colspan='2' ><span class='outputText2'>Cantidad Unitaria</span></td>" +
                                    "<td colspan='2' ><span class='outputText2'>Cantidad Lote</span></td>" +
                                    "<td rowspan='2' ><span class='outputText2'>Unidad Medida</span></td>"+
                                    "<td colspan='2'><span class='outputText2'>Nro Fracciones</span></td>"+
                                    "<td colspan='2' ><span class='outputText2'>Fracciones</span></td>" +
                                    "<td colspan='2' ><span class='outputText2'>Tipo Material</span></td></tr><tr>" +
                                    "<td><span class='outputText2'>Antes</span></td><td><span class='outputText2'>Despues</span></td>" +
                                    "<td><span class='outputText2'>Antes</span></td><td><span class='outputText2'>Despues</span></td>" +
                                    "<td><span class='outputText2'>Antes</span></td><td><span class='outputText2'>Despues</span></td>" +
                                    "<td><span class='outputText2'>Antes</span></td><td><span class='outputText2'>Despues</span></td>" +
                                    "<td><span class='outputText2'>Antes</span></td><td><span class='outputText2'>Despues</span></td> </tr></thead><tbody>");
                         consulta="select f.COD_FORMULA_MAESTRA,f.COD_VERSION"+
                                  " from FORMULA_MAESTRA_VERSION f where f.COD_COMPPROD='"+codCompProd+"' and f.COD_COMPPROD_VERSION='"+codVersion+"'";
                         System.out.println("consulta version formula "+consulta);
                         res=st.executeQuery(consulta);
                         int codFormulaMaestra=0;
                         int codVersionFM=0;
                         int codVersionFmAnterior=0;
                         if(res.next())
                         {
                             codFormulaMaestra=res.getInt("COD_FORMULA_MAESTRA");
                             codVersionFM=res.getInt("COD_VERSION");
                         }
                         consulta="select f.COD_FORMULA_MAESTRA,f.COD_VERSION"+
                                  " from FORMULA_MAESTRA_VERSION f where f.COD_COMPPROD='"+codCompProd+"' and f.COD_COMPPROD_VERSION='"+codVersionAnterior+"'";
                         System.out.println("cdons "+consulta);
                         res=st.executeQuery(consulta);
                         if(res.next())codVersionFmAnterior=res.getInt("COD_VERSION");
                        consulta="select m.NOMBRE_MATERIAL,m.COD_MATERIAL,cantidadMpAnterior.CANTIDAD,cantidadMpNuevo.CANTIDAD as cantidad2,"+
                                            " um.NOMBRE_UNIDAD_MEDIDA,cantidadMpAnterior.cantidadIni,cantidadMpNuevo.cantidadFin,"+
                                            " cantidadMpAnterior.CANTIDAD_UNITARIA_GRAMOS AS CANTIDAD_UNITARIA,cantidadMpNuevo.CANTIDAD_UNITARIA_GRAMOS as CANTIDAD_UNITARIAVersion,"+
                                            " tp.COD_TIPO_MATERIAL_PRODUCCION,tp.NOMBRE_TIPO_MATERIAL_PRODUCCION"+
                                     " from"+
                                     " ("+
                                           "select fmdv.COD_TIPO_MATERIAL_PRODUCCION,fmdv.COD_MATERIAL,fmvdfv.COD_FORMULA_MAESTRA_FRACCIONES,fmdv.CANTIDAD_UNITARIA_GRAMOS,fmdv.CANTIDAD_TOTAL_GRAMOS,"+
                                                     " fmdv.DENSIDAD_MATERIAL,fmdv.COD_UNIDAD_MEDIDA,fmdv.CANTIDAD,fmvdfv.CANTIDAD as cantidadIni"+
                                            " from FORMULA_MAESTRA_DETALLE_MP_VERSION fmdv "+
                                               " inner join FORMULA_MAESTRA_DETALLE_MP_FRACCIONES_VERSION fmvdfv"+
                                                   " on fmdv.COD_VERSION=fmvdfv.COD_VERSION"+
                                                   " and fmdv.COD_MATERIAL=fmvdfv.COD_MATERIAL"+
                                                   " where fmdv.COD_VERSION="+codVersionFmAnterior+
                                     "  ) as cantidadMpAnterior"+
                                     " full outer join "+
                                     " ("+
                                           " select fmdv.COD_TIPO_MATERIAL_PRODUCCION,fmdv.COD_MATERIAL,fmvdfv.COD_FORMULA_MAESTRA_FRACCIONES,fmdv.CANTIDAD_UNITARIA_GRAMOS,fmdv.CANTIDAD_TOTAL_GRAMOS,"+
                                                     "fmdv.DENSIDAD_MATERIAL,fmdv.COD_UNIDAD_MEDIDA,fmdv.CANTIDAD,fmvdfv.CANTIDAD as cantidadFin"+
                                           " from FORMULA_MAESTRA_DETALLE_MP_VERSION fmdv "+
                                               " inner join FORMULA_MAESTRA_DETALLE_MP_FRACCIONES_VERSION fmvdfv"+
                                                   " on fmdv.COD_VERSION=fmvdfv.COD_VERSION"+
                                                   " and fmdv.COD_MATERIAL=fmvdfv.COD_MATERIAL"+
                                                   " where fmdv.COD_VERSION="+codVersionFM+
                                     " ) as cantidadMpNuevo"+
                                     " on cantidadMpAnterior.COD_MATERIAL=cantidadMpNuevo.COD_MATERIAL"+
                                             " AND cantidadMpAnterior.COD_FORMULA_MAESTRA_FRACCIONES=cantidadMpNuevo.COD_FORMULA_MAESTRA_FRACCIONES"+
                                         " and cantidadMpAnterior.COD_TIPO_MATERIAL_PRODUCCION=cantidadMpNuevo.COD_TIPO_MATERIAL_PRODUCCION"+
                                     " left outer join TIPOS_MATERIAL_PRODUCCION tp on (tp.COD_TIPO_MATERIAL_PRODUCCION=cantidadMpAnterior.COD_TIPO_MATERIAL_PRODUCCION or "+
                                                                     " tp.COD_TIPO_MATERIAL_PRODUCCION=cantidadMpNuevo.COD_TIPO_MATERIAL_PRODUCCION)"+
                                     " left outer join MATERIALES m on (m.COD_MATERIAL=cantidadMpAnterior.COD_MATERIAL or m.COD_MATERIAL=cantidadMpNuevo.COD_MATERIAL)"+
                                     " left outer join UNIDADES_MEDIDA um on (um.COD_UNIDAD_MEDIDA=cantidadMpAnterior.COD_UNIDAD_MEDIDA or um.COD_UNIDAD_MEDIDA=cantidadMpNuevo.COD_UNIDAD_MEDIDA)"+
                                     " order by tp.COD_TIPO_MATERIAL_PRODUCCION,m.NOMBRE_MATERIAL";
                                System.out.println("consulta version propuesta mp "+consulta);
                                res=st.executeQuery(consulta);
                                int codMaterialCabecera=0;
                                String fracciones="";
                                int contFracciones=0;
                                while(res.next())
                                {
                                    if(codMaterialCabecera!=res.getInt("COD_MATERIAL"))
                                    {
                                        if(codMaterialCabecera>0)
                                        {
                                            res.previous();
                                            out.println("<tr>" +
                                                    "<td class='"+(res.getString("cantidad")==null?"nuevo":(res.getString("cantidad2")==null?"eliminado":""))+"' rowspan='"+contFracciones+"' ><span class='outputText2'>"+res.getString("NOMBRE_MATERIAL")+"</span></td>" +
                                                    "<td class='"+(res.getString("cantidad")==null?"nuevo":(res.getString("cantidad2")==null?"eliminado":(res.getDouble("CANTIDAD_UNITARIA")!=res.getDouble("CANTIDAD_UNITARIAVersion")?"modificado":"")))+"' rowspan='"+contFracciones+"' ><span class='outputText2'>"+formato6.format(res.getDouble("CANTIDAD_UNITARIA"))+"</span></td>" +
                                                    "<td class='"+(res.getString("cantidad")==null?"nuevo":(res.getString("cantidad2")==null?"eliminado":(res.getDouble("CANTIDAD_UNITARIA")!=res.getDouble("CANTIDAD_UNITARIAVersion")?"modificado":"")))+"' rowspan='"+contFracciones+"' ><span class='outputText2'>"+formato6.format(res.getDouble("CANTIDAD_UNITARIAVersion"))+"</span></td>" +
                                                    "<td class='"+(res.getString("cantidad")==null?"nuevo":(res.getString("cantidad2")==null?"eliminado":(res.getDouble("cantidad2")!=res.getInt("CANTIDAD")?"modificado":"")))+"' rowspan='"+contFracciones+"' ><span class='outputText2'>"+redondeoSuperior.format(res.getDouble("CANTIDAD"))+"</span></td>" +
                                                    "<td class='"+(res.getString("cantidad")==null?"nuevo":(res.getString("cantidad2")==null?"eliminado":(res.getDouble("cantidad2")!=res.getInt("CANTIDAD")?"modificado":"")))+"' rowspan='"+contFracciones+"' ><span class='outputText2'>"+redondeoSuperior.format(res.getDouble("CANTIDAD2"))+"</span></td>" +
                                                    "<td class='"+(res.getString("cantidad")==null?"nuevo":(res.getString("cantidad2")==null?"eliminado":""))+"' rowspan='"+contFracciones+"' ><span class='outputText2'>"+res.getString("NOMBRE_UNIDAD_MEDIDA")+"</span></td>" +
                                                    fracciones);
                                            res.next();

                                        }
                                        codMaterialCabecera=res.getInt("COD_MATERIAL");
                                        contFracciones=0;
                                        fracciones="";
                                    }
                                    contFracciones++;
                                    fracciones+=(contFracciones==1?"":"<tr>")+
                                                    "<td class="+(res.getString("cantidadIni")==null?"nuevo":(res.getString("cantidadFin")==null?"eliminado":(res.getDouble("cantidadIni")!=res.getDouble("cantidadFin")?"modificado":"")))+" ><span class='outputText2'>"+redondeoSuperior.format(res.getDouble("cantidadIni"))+"</span></td>" +
                                                    "<td class="+(res.getString("cantidadIni")==null?"nuevo":(res.getString("cantidadFin")==null?"eliminado":(res.getDouble("cantidadIni")!=res.getDouble("cantidadFin")?"modificado":"")))+" ><span class='outputText2'>"+redondeoSuperior.format(res.getDouble("cantidadFin"))+"</span></td>"+
                                                "</tr>";
                                 }
                                 if(codMaterialCabecera>0)
                                 {
                                     res.last();
                                     out.println("<tr>" +
                                                    "<td class='"+(res.getString("cantidad")==null?"nuevo":(res.getString("cantidad2")==null?"eliminado":""))+"' rowspan='"+contFracciones+"' ><span class='outputText2'>"+res.getString("NOMBRE_MATERIAL")+"</span></td>" +
                                                    "<td class='"+(res.getString("cantidad")==null?"nuevo":(res.getString("cantidad2")==null?"eliminado":(res.getDouble("CANTIDAD_UNITARIA")!=res.getDouble("CANTIDAD_UNITARIAVersion")?"modificado":"")))+"' rowspan='"+contFracciones+"' ><span class='outputText2'>"+formato6.format(res.getDouble("CANTIDAD_UNITARIA"))+"</span></td>" +
                                                    "<td class='"+(res.getString("cantidad")==null?"nuevo":(res.getString("cantidad2")==null?"eliminado":(res.getDouble("CANTIDAD_UNITARIA")!=res.getDouble("CANTIDAD_UNITARIAVersion")?"modificado":"")))+"' rowspan='"+contFracciones+"' ><span class='outputText2'>"+formato6.format(res.getDouble("CANTIDAD_UNITARIAVersion"))+"</span></td>" +
                                                    "<td class='"+(res.getString("cantidad")==null?"nuevo":(res.getString("cantidad2")==null?"eliminado":(res.getDouble("cantidad2")!=res.getInt("CANTIDAD")?"modificado":"")))+"' rowspan='"+contFracciones+"' ><span class='outputText2'>"+redondeoSuperior.format(res.getDouble("CANTIDAD"))+"</span></td>" +
                                                    "<td class='"+(res.getString("cantidad")==null?"nuevo":(res.getString("cantidad2")==null?"eliminado":(res.getDouble("cantidad2")!=res.getInt("CANTIDAD")?"modificado":"")))+"' rowspan='"+contFracciones+"' ><span class='outputText2'>"+redondeoSuperior.format(res.getDouble("CANTIDAD2"))+"</span></td>" +
                                                    "<td class='"+(res.getString("cantidad")==null?"nuevo":(res.getString("cantidad2")==null?"eliminado":""))+"' rowspan='"+contFracciones+"' ><span class='outputText2'>"+res.getString("NOMBRE_UNIDAD_MEDIDA")+"</span></td>" +
                                                    fracciones);
                                 }
                                 out.println("</tbody></table>");
                                 out.println("<table class='tablaComparacion'  cellpadding='0' cellspacing='0' style='margin-top:1em;' id='tablaEP'>"+
                                        " <thead><tr  align='center'><td  colspan='8'><span class='outputText2'>Diferencias EP</span></td>"+
                                        " </tr></thead><tbody>");
                                 consulta="select ep.nombre_envaseprim,ep.cod_envaseprim,p.CANTIDAD,"+
                                          " p.cod_presentacion_primaria,tpp.COD_TIPO_PROGRAMA_PROD,tpp.NOMBRE_TIPO_PROGRAMA_PROD,"+
                                          " er.COD_ESTADO_REGISTRO,er.NOMBRE_ESTADO_REGISTRO"+
                                          " from PRESENTACIONES_PRIMARIAS_VERSION p inner join ENVASES_PRIMARIOS ep on"+
                                          " p.COD_ENVASEPRIM=ep.cod_envaseprim"+
                                          " inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=p.COD_TIPO_PROGRAMA_PROD"+
                                          " inner join ESTADOS_REFERENCIALES er on er.COD_ESTADO_REGISTRO=p.COD_ESTADO_REGISTRO"+
                                          " where p.COD_VERSION='"+codVersion+"'" +
                                          " and p.COD_COMPPROD='"+codCompProd+"'" +
                                          " order by tpp.NOMBRE_TIPO_PROGRAMA_PROD";
                                 System.out.println("consulta presentaciones primarias"+consulta);
                                 res=st.executeQuery(consulta);
                                 while(res.next())
                                 {
                                     out.println("<tr><td class='cabecera' colspan='8' align='center'><span class='outputText2'>" +
                                             "Tipo Prog:"+res.getString("NOMBRE_TIPO_PROGRAMA_PROD")+"<br/>Envase:"+res.getString("nombre_envaseprim")+"<br/>" +
                                             "Estado:"+res.getString("NOMBRE_ESTADO_REGISTRO")+"<br/>Cantidad:"+res.getInt("CANTIDAD")+"</span></td></tr>" +
                                             "<tr  class='cabecera' align='center'><td rowspan='2' ><span class='outputText2' >Material</span></td>"+
                                            "<td colspan='2' ><span class='outputText2'>Cantidad</span></td>" +
                                            "<td rowspan='2' ><span class='outputText2'>Unidad Medida</span></td><tr class='cabecera'>" +
                                            "<td><span class='outputText2'>Antes</span></td><td><span class='outputText2'>Despues</span></td></tr>");
                                     consulta="select m.NOMBRE_MATERIAL,fmde.CANTIDAD,fmdev.CANTIDAD as cantidad2,um.NOMBRE_UNIDAD_MEDIDA"+
                                             " from FORMULA_MAESTRA_DETALLE_EP_VERSION fmde full outer join FORMULA_MAESTRA_DETALLE_EP_VERSION fmdev"+
                                             "  on fmde.COD_FORMULA_MAESTRA=fmdev.COD_FORMULA_MAESTRA and fmde.COD_MATERIAL=fmdev.COD_MATERIAL" +
                                             " and fmde.COD_VERSION='"+codVersionFmAnterior+"' and fmdev.COD_VERSION="+codVersionFM+
                                             " and fmde.COD_PRESENTACION_PRIMARIA=fmdev.COD_PRESENTACION_PRIMARIA"+
                                             " inner join materiales m on (m.COD_MATERIAL=fmde.COD_MATERIAL or m.COD_MATERIAL=fmdev.COD_MATERIAL)"+
                                             " inner join UNIDADES_MEDIDA um on (um.COD_UNIDAD_MEDIDA=fmde.COD_UNIDAD_MEDIDA or um.COD_UNIDAD_MEDIDA=fmdev.COD_UNIDAD_MEDIDA)"+
                                             " where ((fmde.cod_version='"+codVersionFmAnterior+"' and fmde.COD_PRESENTACION_PRIMARIA='"+res.getInt("cod_presentacion_primaria")+"') or " +
                                             " (fmdev.cod_version='"+codVersionFM+"' and fmdev.COD_PRESENTACION_PRIMARIA='"+res.getInt("cod_presentacion_primaria")+"'))" +
                                             " order by m.NOMBRE_MATERIAL";
                                     System.out.println("consulta detalle ep "+consulta);
                                     resDetalle=stDetalle.executeQuery(consulta);
                                     while(resDetalle.next())
                                     {
                                          out.println("<tr>" +
                                                "<td class='"+(resDetalle.getString("cantidad")==null?"nuevo":(resDetalle.getString("cantidad2")==null?"eliminado":""))+"'><span class='outputText2'>"+resDetalle.getString("NOMBRE_MATERIAL")+"</span></td>" +
                                                "<td class='"+(resDetalle.getString("cantidad")==null?"nuevo":(resDetalle.getString("cantidad2")==null?"eliminado":(resDetalle.getDouble("cantidad")!=resDetalle.getDouble("cantidad2")?"modificado":"")))+"'><span class='outputText2'>"+formato.format(resDetalle.getDouble("cantidad"))+"</span></td>" +
                                                "<td class='"+(resDetalle.getString("cantidad")==null?"nuevo":(resDetalle.getString("cantidad2")==null?"eliminado":(resDetalle.getDouble("cantidad")!=resDetalle.getDouble("cantidad2")?"modificado":"")))+"'><span class='outputText2'>"+formato.format(resDetalle.getDouble("cantidad2"))+"</span></td>" +
                                                "<td class='"+(resDetalle.getString("cantidad")==null?"nuevo":(resDetalle.getString("cantidad2")==null?"eliminado":""))+"'><span class='outputText2'>"+resDetalle.getString("NOMBRE_UNIDAD_MEDIDA")+"</span></td>" +
                                                "</tr>");
                                     }

                                 }
                             out.println("</tbody></table>");
                                 out.println("<table class='tablaComparacion'  cellpadding='0' cellspacing='0' style='margin-top:1em;' id='tablaMR'>"+
                                        " <thead><tr  align='center'><td  colspan='8'><span class='outputText2'>Diferencias MR</span></td>"+
                                        " </tr></thead><tbody>");
                                 consulta="select tmr.COD_TIPO_MATERIAL_REACTIVO,tmr.NOMBRE_TIPO_MATERIAL_REACTIVO from TIPOS_MATERIAL_REACTIVO tmr where tmr.COD_ESTADO_REGISTRO=1 order by tmr.NOMBRE_TIPO_MATERIAL_REACTIVO";
                                 res=st.executeQuery(consulta);
                                 while(res.next())
                                 {
                                     out.println("<tr><td class='cabecera' colspan='8' align='center'><span class='outputText2'>" +
                                             "Tipo Material:"+res.getString("NOMBRE_TIPO_MATERIAL_REACTIVO")+"</span></td></tr>" +
                                             "<tr  class='cabecera' align='center'><td rowspan='2' ><span class='outputText2' >Material</span></td>"+
                                            "<td colspan='2' ><span class='outputText2'>Cantidad</span></td>" +
                                            "<td rowspan='2' ><span class='outputText2'>Estado Material</span></td>" +
                                            "<td colspan='2' ><span class='outputText2'>Estado Analisis</span></td>"+
                                            "<td rowspan='2' ><span class='outputText2'>Analisis</span></td>"+
                                            "</tr><tr class='cabecera'>" +
                                            "<td><span class='outputText2'>Antes</span></td><td><span class='outputText2'>Despues</span></td>" +
                                            "<td><span class='outputText2'>Antes</span></td><td><span class='outputText2'>Despues</span></td></tr>");
                                      consulta="select m.NOMBRE_MATERIAL,m.COD_MATERIAL,fmd.CANTIDAD,fmdv.CANTIDAD as cantidad2,er.NOMBRE_ESTADO_REGISTRO,"+
                                               " tamr.nombre_tipo_analisis_material_reactivo,detalle.registrado,detalle.registrado2"+
                                               " from FORMULA_MAESTRA_DETALLE_MR fmd full outer join FORMULA_MAESTRA_DETALLE_MR_VERSION fmdv on "+
                                               " fmd.COD_FORMULA_MAESTRA=fmdv.COD_FORMULA_MAESTRA and fmd.COD_MATERIAL=fmdv.COD_MATERIAL"+
                                               " and fmd.COD_TIPO_MATERIAL=fmdv.COD_TIPO_MATERIAL"+
                                               " and fmdv.COD_VERSION='"+codVersionFM+"'"+
                                               " inner join MATERIALES m on (m.COD_MATERIAL=fmd.COD_MATERIAL or fmdv.COD_MATERIAL=m.COD_MATERIAL)"+
                                               " inner join ESTADOS_REFERENCIALES er on er.COD_ESTADO_REGISTRO=m.COD_ESTADO_REGISTRO"+
                                               " outer APPLY TIPOS_ANALISIS_MATERIAL_REACTIVO tamr"+
                                               " OUTER APPLY (select case when fmc.COD_MATERIAL>0 then 1 else 0 end as registrado, case when fmcv.COD_MATERIAL >0 then 1 else 0 end as registrado2"+
                                               " from FORMULA_MAESTRA_MR_CLASIFICACION fmc full outer join FORMULA_MAESTRA_MR_CLASIFICACION_VERSION fmcv"+
                                               " on fmc.COD_FORMULA_MAESTRA=fmcv.COD_FORMULA_MAESTRA and fmc.COD_MATERIAL=fmcv.COD_MATERIAL"+
                                               " and fmc.COD_TIPO_ANALISIS_MATERIAL_REACTIVO=fmcv.COD_TIPO_ANALISIS_MATERIAL_REACTIVO"+
                                               " and fmcv.COD_VERSION=fmdv.COD_VERSION"+
                                               " where ((fmc.COD_FORMULA_MAESTRA=fmd.COD_FORMULA_MAESTRA and fmc.COD_MATERIAL=fmd.COD_MATERIAL ) or"+
                                               " (fmcv.COD_FORMULA_MAESTRA=fmdv.COD_FORMULA_MAESTRA and  fmcv.COD_MATERIAL=fmdv.COD_MATERIAL and "+
                                               " fmcv.COD_VERSION=fmdv.COD_VERSION )) and (fmc.COD_TIPO_ANALISIS_MATERIAL_REACTIVO=tamr.COD_TIPO_ANALISIS_MATERIAL_REACTIVO"+
                                               " or fmcv.COD_TIPO_ANALISIS_MATERIAL_REACTIVO=tamr.COD_TIPO_ANALISIS_MATERIAL_REACTIVO)) as detalle"+
                                               " where ((fmd.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"'" +
                                               " and fmd.COD_TIPO_MATERIAL='"+res.getInt("COD_TIPO_MATERIAL_REACTIVO")+"')"+
                                               " or(fmdv.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"'" +
                                               " and fmdv.COD_VERSION='"+codVersionFM+"'" +
                                               " and fmdv.COD_TIPO_MATERIAL='"+res.getInt("COD_TIPO_MATERIAL_REACTIVO")+"' )) order by m.NOMBRE_MATERIAL,tamr.nombre_tipo_analisis_material_reactivo";
                                           System.out.println("consulta detalle mr "+consulta);
                                           resDetalle=stDetalle.executeQuery(consulta);
                                           codMaterialCabecera=0;
                                           fracciones="";
                                           while(resDetalle.next())
                                           {

                                               if((resDetalle.getRow()%2)==0)
                                               {
                                                    out.println("<tr>" +
                                                                "<td rowspan='2' class='"+(resDetalle.getString("cantidad")==null?"nuevo":(resDetalle.getString("cantidad2")==null?"eliminado":""))+"'><span class='outputText2'>"+resDetalle.getString("NOMBRE_MATERIAL")+"</span></td>" +
                                                                "<td rowspan='2' class='"+(resDetalle.getString("cantidad")==null?"nuevo":(resDetalle.getString("cantidad2")==null?"eliminado":(resDetalle.getDouble("cantidad")!=resDetalle.getDouble("cantidad2")?"modificado":"")))+"'><span class='outputText2'>"+formato.format(resDetalle.getDouble("cantidad"))+"</span></td>" +
                                                                "<td rowspan='2' class='"+(resDetalle.getString("cantidad")==null?"nuevo":(resDetalle.getString("cantidad2")==null?"eliminado":(resDetalle.getDouble("cantidad")!=resDetalle.getDouble("cantidad2")?"modificado":"")))+"'><span class='outputText2'>"+formato.format(resDetalle.getDouble("cantidad2"))+"</span></td>" +
                                                                "<td rowspan='2' class='"+(resDetalle.getString("cantidad")==null?"nuevo":(resDetalle.getString("cantidad2")==null?"eliminado":""))+"'><span class='outputText2'>"+resDetalle.getString("NOMBRE_ESTADO_REGISTRO")+"</span></td>" +
                                                                fracciones+
                                                                "</tr><tr>"+
                                                                "<td class='"+(resDetalle.getString("cantidad")==null?"nuevo":(resDetalle.getString("cantidad2")==null?"eliminado":(resDetalle.getInt("registrado")!=resDetalle.getInt("registrado2")?"modificado":"")))+"'><input disabled='true' type='checkbox' "+(resDetalle.getInt("registrado")>0?"checked":"")+"/></td>"+
                                                               "<td class='"+(resDetalle.getString("cantidad")==null?"nuevo":(resDetalle.getString("cantidad2")==null?"eliminado":(resDetalle.getInt("registrado")!=resDetalle.getInt("registrado2")?"modificado":"")))+"'><input disabled='true' type='checkbox' "+(resDetalle.getInt("registrado2")>0?"checked":"")+"/></td>"+
                                                               "<td class='"+(resDetalle.getString("cantidad")==null?"nuevo":(resDetalle.getString("cantidad2")==null?"eliminado":""))+"'><span class='outputText2'>"+resDetalle.getString("nombre_tipo_analisis_material_reactivo")+"</span></td></tr>");

                                               }
                                               else
                                               {
                                                   fracciones="<td class='"+(resDetalle.getString("cantidad")==null?"nuevo":(resDetalle.getString("cantidad2")==null?"eliminado":(resDetalle.getInt("registrado")!=resDetalle.getInt("registrado2")?"modificado":"")))+"'><input disabled='true' type='checkbox' "+(resDetalle.getInt("registrado")>0?"checked":"")+"/></td>"+
                                                               "<td class='"+(resDetalle.getString("cantidad")==null?"nuevo":(resDetalle.getString("cantidad2")==null?"eliminado":(resDetalle.getInt("registrado")!=resDetalle.getInt("registrado2")?"modificado":"")))+"'><input disabled='true' type='checkbox' "+(resDetalle.getInt("registrado2")>0?"checked":"")+"/></td>"+
                                                               "<td class='"+(resDetalle.getString("cantidad")==null?"nuevo":(resDetalle.getString("cantidad2")==null?"eliminado":""))+"'><span class='outputText2'>"+resDetalle.getString("nombre_tipo_analisis_material_reactivo")+"</span></td>";
                                               }
                                           }
                                 }
                                 out.println("</tbody></table>");
                                 con.close();
                    }
                    catch(SQLException ex)
                    {
                        ex.printStackTrace();
                    }
                    %>
                    
                 </center>
            </form>
        </body>
    </html>
    
