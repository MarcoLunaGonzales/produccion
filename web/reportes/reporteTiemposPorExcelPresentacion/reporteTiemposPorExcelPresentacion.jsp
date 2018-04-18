<html>
<%@ page language="java"%>
<%@ page contentType="text/html"%>
<%@ page pageEncoding="UTF-8"%>
<%@ page import = "java.util.Properties" %>
<%@ page import="com.cofar.web.*" %>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.text.DecimalFormat"%> 
<%@ page import = "java.text.NumberFormat"%> 
<%@ page import = "java.util.Locale"%> 
<%@ page import = "java.util.*"%> 
<%@ page import = "java.text.*"%> 
<%@ page import = "java.lang.Math"%> 
<%@ page import = "java.text.SimpleDateFormat"%> 
<%@ page import="com.cofar.util.*" %>
<%@ page import="com.cofar.bean.*" %>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.sql.DriverManager"%> 
<%@ page import = "java.sql.ResultSet"%> 
<%@ page import = "java.sql.Statement"%> 
<%@ page import = "java.text.SimpleDateFormat"%> 
<%@ page import = "java.util.ArrayList"%> 
<%@ page import = "java.util.Date"%> 
<%@ page import = "java.io.*"%> 
<%@ page import = "javax.faces.context.FacesContext"%>
<%@ page import = "javax.servlet.http.HttpServletRequest"%>
<%@ page import = "org.joda.time.DateTime"%>

<%@ page import="javazoom.upload.*" %>
<%@ page import= "com.cofar.CostosCompras" %>
<%@ page import= "java.util.Iterator" %>
<%@page import="jxl.Cell" %>
<%@page import="jxl.Range" %>
<%@page import="jxl.Sheet" %>
<%@page import="jxl.Workbook" %>
<%@page import="jxl.read.biff.BiffException;" %>

            
<jsp:useBean id="upBean" scope="request" class="javazoom.upload.UploadBean" >
    <jsp:setProperty name="upBean" property="folderstore" />
</jsp:useBean>

<%

String name="";
InputStream stream=null;
if (MultipartFormDataRequest.isMultipartFormData(request)) {
    MultipartFormDataRequest mrequest = new MultipartFormDataRequest(request);
    String todo = null;
    if (mrequest != null) todo = mrequest.getParameter("todo");
    if ( (todo != null) && (todo.equalsIgnoreCase("upload")) ) {
        Hashtable files = mrequest.getFiles();
        if ( (files != null) && (!files.isEmpty()) ) {
            UploadFile file = (UploadFile) files.get("uploadfile");
            System.out.println("entro prodcd");
            if (file != null){
                name=file.getFileName();
                stream=file.getInpuStream();
                System.out.println("genero archivo 12");
            }
        }
    }
}
%>



<head>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <title>REPORTE  DE  VERIFICACION  BACO  -  ATLAS (Fórmulas Maestras)</title>
    <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
    
</head>
<body>
    
    <center>
        <table >
            <tr >
                <td colspan="2" align="center" >
                    <h4>Reporte de Tiempos por excel</h4>
                </td>
            </tr>
            <tr>
                <td class="outputTextBold">Presentaciones no registradas en el programa de producción</td>
                <td class="celdaColorAmarillo" style="width:4rem">&nbsp;</td>
            </tr>
        </table>
    </center>
    
    
    <table width="90%" align="center" class="tablaReporte"  cellpadding="0" cellspacing="0" >
        <thead>
            <tr>
                <td>Lote</td>
                <td>Codigo Presentación</td>
                <td>Presentación</td>
                <td>Programa de Producción</td>
                <td>Tamaño Lote Programado</td>
                <td>Cantidad Ingresada A.P.T.</td>
                <td>Horas Hombre Pesaje</td>
                <td>Horas Hombre Almacen</td>
                <td>Horas Hombre Producción</td>
                <td>Horas Hombre Microbiologia</td>
                <td>Horas Hombre Acondicionamiento</td>
                <td>Horas Hombre Control De Calidad</td>
                <td>Horas Soporte a la Manufactura</td>
                <td>Hrs. Pesaje</td>
                <td>Hrs. Almacen</td>
                <td>Hrs. Producción</td>
                <td>Hrs. Microbiologia</td>
                <td>Hrs. Acondicionamiento</td>
                <td>Hrs. Control De Calidad</td>
                <td>Hrs. Soporte a la Manufactura</td>
            </tr>
        </thead>
        <%
            NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
            DecimalFormat formato = (DecimalFormat)nf;
            formato.applyPattern("#,##0.00");
            NumberFormat nf2 = NumberFormat.getNumberInstance(Locale.ENGLISH);
            DecimalFormat formato6Decimales = (DecimalFormat)nf2;
            formato6Decimales.applyPattern("#,##0.00######");
            Connection con=null;
            try
            { 
                Workbook w=Workbook.getWorkbook(stream);
                Sheet hoja=w.getSheet(0);
                System.out.println("saco hoja");
                int cont=0;
                StringBuilder consulta=new StringBuilder(" SET NOCOUNT ON DECLARE @codigosLote TdatosVarcharRef");
                                         consulta.append(" INSERT INTO @codigosLote VALUES ('frrv')");
                StringBuilder codigosLotes=new StringBuilder("");
                while (cont < hoja.getRows()) {
                        Cell  c[] =hoja.getRow(cont);
                        consulta.append(" ,('").append(c[0].getContents()).append("')");
                        if(codigosLotes.length()>0)codigosLotes.append(",");
                        codigosLotes.append("'"+c[0].getContents()+"'");
                        cont=cont+1;
                }

                w.close();
            
                con=Util.openConnection(con);
                consulta.append("select datosPres.COD_PRESENTACION,isnull(ppp.NOMBRE_PRODUCTO_PRESENTACION,'') as NOMBRE_PRODUCTO_PRESENTACION,datosLote.NOMBRE_PROGRAMA_PROD,datosLote.cantidadLote,datosLote.COD_LOTE_PRODUCCION,");
                                                            consulta.append(" datosPres.cantidadIngresoVentas,datosTiempo.sumaPesaje,datosTiempo.sumaAlmacen,datosTiempo.sumaProduccion,datosTiempo.sumaMicrobiologia");
                                                            consulta.append(" ,datosPres.sumaAcondicionamiento,datosTiempo.sumaControlCalidad,datosTiempo.sumaSoporte");
                                                            consulta.append(" ,datosPres.registradoEnPrograma");
                                        consulta.append(" from");
                                        consulta.append(" (");
                                                consulta.append(" select pp.COD_LOTE_PRODUCCION,pp.COD_PROGRAMA_PROD,sum(pp.CANT_LOTE_PRODUCCION) as cantidadLote,ppp.NOMBRE_PROGRAMA_PROD");
                                                    
                                                consulta.append(" from @codigosLote cl ");
                                                        consulta.append(" inner join PROGRAMA_PRODUCCION pp on cl.CODIGO=pp.COD_LOTE_PRODUCCION");
                                                        consulta.append(" inner join PROGRAMA_PRODUCCION_PERIODO ppp on ppp.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD");
                                                consulta.append(" group by pp.COD_LOTE_PRODUCCION,pp.COD_PROGRAMA_PROD,ppp.NOMBRE_PROGRAMA_PROD");
                                        consulta.append(" ) as datosLote");
                                        consulta.append(" left join(");
                                                 consulta.append(" select spp.COD_LOTE_PRODUCCION,spp.COD_PROGRAMA_PROD,");
                                                          consulta.append(" sum(case when afm.COD_AREA_EMPRESA=97 then spp.HORAS_HOMBRE else 0 end) as sumaPesaje,");
                                                          consulta.append(" sum(case when afm.COD_AREA_EMPRESA=96 then spp.HORAS_HOMBRE else 0 end) as sumaProduccion,");
                                                          consulta.append(" sum(case when afm.COD_AREA_EMPRESA=40 then spp.HORAS_HOMBRE else 0 end) as sumaControlCalidad,");
                                                          consulta.append(" sum(case when afm.COD_AREA_EMPRESA=76 then spp.HORAS_HOMBRE else 0 end) as sumaAlmacen,");
                                                          consulta.append(" sum(case when afm.COD_AREA_EMPRESA=1010 then spp.HORAS_HOMBRE else 0 end) as sumaSoporte,");
                                                          consulta.append(" sum(case when afm.COD_AREA_EMPRESA=75 then spp.HORAS_HOMBRE else 0 end) as sumaMicrobiologia,");
                                                          consulta.append(" sum(case when afm.COD_AREA_EMPRESA in(84,102) then spp.HORAS_HOMBRE else 0 end) as sumaAcondicionamiento");
                                                 consulta.append(" from @codigosLote cl ");
                                                 	  consulta.append(" inner join SEGUIMIENTO_PROGRAMA_PRODUCCION spp on cl.codigo=spp.COD_LOTE_PRODUCCION");
                                                      consulta.append(" inner join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_FORMULA_MAESTRA = spp.COD_FORMULA_MAESTRA ");
                                                          consulta.append(" and afm.COD_ACTIVIDAD_FORMULA=spp.COD_ACTIVIDAD_PROGRAMA");
                                                          consulta.append(" and afm.COD_AREA_EMPRESA in (97,96,40,76,1010,75,84,102)");
                                                 consulta.append(" group by spp.COD_LOTE_PRODUCCION,spp.COD_PROGRAMA_PROD");
                                           consulta.append(" ) datosTiempo on datosTiempo.COD_PROGRAMA_PROD =datosLote.COD_PROGRAMA_PROD");
                                                      consulta.append(" and datosTiempo.COD_LOTE_PRODUCCION=datosLote.COD_LOTE_PRODUCCION");
                                        consulta.append(" left outer join(");
                                                consulta.append(" select ISNULL(datosPresentacion.COD_LOTE_PRODUCCION,datosIngreso.COD_LOTE_PRODUCCION) as COD_LOTE_PRODUCCION,");
                                                        consulta.append(" isnull(datosIngreso.COD_PRESENTACION,datosPresentacion.COD_PRESENTACION) as COD_PRESENTACION,");
                                                        consulta.append(" datosPresentacion.sumaAcondicionamiento,datosIngreso.cantidadIngresoVentas");
                                                        consulta.append(" ,case when datosPresentacion.COD_LOTE_PRODUCCION IS null then 	0 else 1 end as registradoEnPrograma");
                                                consulta.append(" FROM");
                                                consulta.append(" (");
                                                        consulta.append(" select sum(case when afm.COD_AREA_EMPRESA in(84,102) then spp.HORAS_HOMBRE else 0 end) as sumaAcondicionamiento,");
                                                            consulta.append(" pp.COD_PRESENTACION,pp.COD_LOTE_PRODUCCION");
                                                        consulta.append(" from @codigosLote cl");
                                                            consulta.append(" INNER JOIN PROGRAMA_PRODUCCION pp on pp.COD_LOTE_PRODUCCION=cl.CODIGO");
                                                            consulta.append(" left outer join SEGUIMIENTO_PROGRAMA_PRODUCCION spp on pp.COD_PROGRAMA_PROD=spp.COD_PROGRAMA_PROD");
                                                                consulta.append(" and spp.COD_LOTE_PRODUCCION=pp.COD_LOTE_PRODUCCION");
                                                                consulta.append(" and spp.COD_COMPPROD=pp.COD_COMPPROD");
                                                                consulta.append(" and spp.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD");
                                                            consulta.append(" left outer join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_FORMULA_MAESTRA = spp.COD_FORMULA_MAESTRA ");
                                                                                consulta.append(" and afm.COD_ACTIVIDAD_FORMULA=spp.COD_ACTIVIDAD_PROGRAMA");
                                                                                consulta.append(" and afm.COD_AREA_EMPRESA in (84,102)");
                                                        consulta.append(" group by pp.COD_PRESENTACION,pp.COD_LOTE_PRODUCCION");
                                                consulta.append(" ) as datosPresentacion");
                                                consulta.append(" full outer join(");
                                                        consulta.append(" select  sum((pp.cantidad_presentacion * idv.CANTIDAD) +idv.CANTIDAD_UNITARIA) as cantidadIngresoVentas");
                                                                consulta.append(" ,idv.COD_LOTE_PRODUCCION,idv.COD_PRESENTACION");
                                                        consulta.append(" from INGRESOS_VENTAS iv");
                                                                consulta.append(" inner join INGRESOS_DETALLEVENTAS idv on iv.COD_INGRESOVENTAS =idv.COD_INGRESOVENTAS ");
                                                                        consulta.append(" and idv.COD_AREA_EMPRESA = iv.COD_AREA_EMPRESA");
                                                                consulta.append(" inner join PRESENTACIONES_PRODUCTO pp on pp.cod_presentacion =idv.COD_PRESENTACION");
                                                                consulta.append(" inner join @codigosLote cl on cl.CODIGO=idv.COD_LOTE_PRODUCCION collate traditional_spanish_ci_ai");
                                                        consulta.append(" where iv.COD_AREA_EMPRESA = 1 ");
                                                                consulta.append(" and  iv.COD_TIPOINGRESOVENTAS in (2)");
                                                                consulta.append(" and iv.COD_ALMACEN_VENTA in (54, 56 , 57)");
                                                                consulta.append(" and iv.COD_ESTADO_INGRESOVENTAS not in (2)");
                                                                consulta.append(" and len(idv.COD_LOTE_PRODUCCION)>4");
                                                        consulta.append(" group by idv.COD_LOTE_PRODUCCION,idv.COD_PRESENTACION");
                                            consulta.append(" ) as datosIngreso on datosIngreso.COD_LOTE_PRODUCCION collate traditional_spanish_ci_ai=datosPresentacion.COD_LOTE_PRODUCCION");
                                                    consulta.append(" AND datosIngreso.COD_PRESENTACION=datosPresentacion.COD_PRESENTACION");
                                        consulta.append(" ) as datosPres on datosPres.COD_LOTE_PRODUCCION=datosLote.COD_LOTE_PRODUCCION");
                                        consulta.append(" left outer join PRESENTACIONES_PRODUCTO ppp on ppp.COD_PRESENTACION=datosPres.COD_PRESENTACION or ");
                                                        consulta.append(" ppp.COD_PRESENTACION=datosPres.COD_PRESENTACION");
                                        consulta.append(" ORDER BY datosLote.COD_LOTE_PRODUCCION,datosPres.registradoEnPrograma desc,ppp.NOMBRE_PRODUCTO_PRESENTACION asc");
                                        consulta.append(" SET NOCOUNT Off");
                System.out.println("consulta reporte excel "+consulta.toString());
                Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet res=st.executeQuery(consulta.toString());
                StringBuilder detalle=new StringBuilder();
                String codLoteCabecera="";
                String detalleLote="";
                Double cantidadIngresoVentasAnterior=0d;
                Double cantidadTiempoAcondicionamientoAnterior=0d;
                int contador=0;
                while(res.next())
                {
                    if(!codLoteCabecera.equals(res.getString("COD_LOTE_PRODUCCION")))
                    {
                        if(codLoteCabecera.length()>0)
                        {
                            res.previous();
                                out.println("<tr>");
                                    out.println(detalleLote);
                                    out.println("<td rowspan='"+contador+"'>"+res.getString("NOMBRE_PROGRAMA_PROD")+"</td>");
                                    out.println("<td rowspan='"+contador+"'>"+formato.format(res.getDouble("cantidadLote"))+"</td>");
                                    out.println("<td>"+formato.format(cantidadIngresoVentasAnterior)+"</td>");
                                    out.println("<td rowspan='"+contador+"'>"+formato.format(res.getDouble("sumaPesaje"))+"</td>");
                                    out.println("<td rowspan='"+contador+"'>"+formato.format(res.getDouble("sumaAlmacen"))+"</td>");
                                    out.println("<td rowspan='"+contador+"'>"+formato.format(res.getDouble("sumaProduccion"))+"</td>");
                                    out.println("<td rowspan='"+contador+"'>"+formato.format(res.getDouble("sumaMicrobiologia"))+"</td>");
                                    out.println("<td>"+formato.format(cantidadTiempoAcondicionamientoAnterior)+"</td>");
                                    out.println("<td rowspan='"+contador+"'>"+formato.format(res.getDouble("sumaControlCalidad"))+"</td>");
                                    out.println("<td rowspan='"+contador+"'>"+formato.format(res.getDouble("sumaSoporte"))+"</td>");
                                    out.println("<td rowspan='"+contador+"'>"+formato6Decimales.format(res.getDouble("sumaPesaje")/res.getDouble("cantidadLote"))+"</td>");
                                    out.println("<td rowspan='"+contador+"'>"+formato6Decimales.format(res.getDouble("sumaAlmacen")/res.getDouble("cantidadLote"))+"</td>");
                                    out.println("<td rowspan='"+contador+"'>"+formato6Decimales.format(res.getDouble("sumaProduccion")/res.getDouble("cantidadLote"))+"</td>");
                                    out.println("<td rowspan='"+contador+"'>"+formato6Decimales.format(res.getDouble("sumaMicrobiologia")/res.getDouble("cantidadLote"))+"</td>");
                                    out.println("<td >"+formato6Decimales.format(cantidadTiempoAcondicionamientoAnterior/cantidadIngresoVentasAnterior)+"</td>");
                                    out.println("<td rowspan='"+contador+"'>"+formato6Decimales.format(res.getDouble("sumaControlCalidad")/res.getDouble("cantidadLote"))+"</td>");
                                    out.println("<td rowspan='"+contador+"'>"+formato6Decimales.format(res.getDouble("sumaSoporte")/res.getDouble("cantidadLote"))+"</td>");
                                out.println("</tr>");
                                out.println(detalle.toString());
                            res.next();
                        }
                        codLoteCabecera=res.getString("COD_LOTE_PRODUCCION");
                        detalle=new StringBuilder("");
                        contador=0;
                        detalleLote="<td>"+res.getString("COD_LOTE_PRODUCCION")+"</td>"+
                                    "<td>"+res.getString("COD_PRESENTACION")+"</td>"+
                                    "<td>"+res.getString("NOMBRE_PRODUCTO_PRESENTACION")+"</td>";
                        cantidadIngresoVentasAnterior=res.getDouble("cantidadIngresoVentas");
                        cantidadTiempoAcondicionamientoAnterior=res.getDouble("sumaAcondicionamiento");
                    }
                    else
                    {
                        detalle.append("<tr class='"+(res.getInt("registradoEnPrograma")>0?"":"celdaColorAmarillo")+"'>");
                            detalle.append("<td>"+res.getString("COD_LOTE_PRODUCCION")+"</td>");
                            detalle.append("<td>"+res.getString("COD_PRESENTACION")+"</td>");
                            detalle.append("<td>"+res.getString("NOMBRE_PRODUCTO_PRESENTACION")+"</td>");
                            detalle.append("<td>"+formato.format(res.getDouble("cantidadIngresoVentas"))+"</td>");
                            detalle.append("<td>"+formato.format(res.getDouble("sumaAcondicionamiento"))+"</td>");
                            detalle.append("<td >"+formato6Decimales.format(res.getDouble("sumaAcondicionamiento")/res.getDouble("cantidadIngresoVentas"))+"</td>");
                        detalle.append("</tr>");
                    }
                    contador++;
                }
                if(codLoteCabecera.length()>0)
                {
                    res.previous();
                        out.println("<tr>");
                            out.println(detalleLote);
                            out.println("<td rowspan='"+contador+"'>"+res.getString("NOMBRE_PROGRAMA_PROD")+"</td>");
                            out.println("<td rowspan='"+contador+"'>"+formato.format(res.getDouble("cantidadLote"))+"</td>");
                            out.println("<td>"+formato.format(cantidadIngresoVentasAnterior)+"</td>");
                            out.println("<td rowspan='"+contador+"'>"+formato.format(res.getDouble("sumaPesaje"))+"</td>");
                            out.println("<td rowspan='"+contador+"'>"+formato.format(res.getDouble("sumaAlmacen"))+"</td>");
                            out.println("<td rowspan='"+contador+"'>"+formato.format(res.getDouble("sumaProduccion"))+"</td>");
                            out.println("<td rowspan='"+contador+"'>"+formato.format(res.getDouble("sumaMicrobiologia"))+"</td>");
                            out.println("<td>"+formato.format(cantidadTiempoAcondicionamientoAnterior)+"</td>");
                            out.println("<td rowspan='"+contador+"'>"+formato.format(res.getDouble("sumaControlCalidad"))+"</td>");
                            out.println("<td rowspan='"+contador+"'>"+formato.format(res.getDouble("sumaSoporte"))+"</td>");
                            out.println("<td rowspan='"+contador+"'>"+formato6Decimales.format(res.getDouble("sumaPesaje")/res.getDouble("cantidadLote"))+"</td>");
                            out.println("<td rowspan='"+contador+"'>"+formato6Decimales.format(res.getDouble("sumaAlmacen")/res.getDouble("cantidadLote"))+"</td>");
                            out.println("<td rowspan='"+contador+"'>"+formato6Decimales.format(res.getDouble("sumaProduccion")/res.getDouble("cantidadLote"))+"</td>");
                            out.println("<td rowspan='"+contador+"'>"+formato6Decimales.format(res.getDouble("sumaMicrobiologia")/res.getDouble("cantidadLote"))+"</td>");
                            out.println("<td >"+formato6Decimales.format(cantidadTiempoAcondicionamientoAnterior/cantidadIngresoVentasAnterior)+"</td>");
                            out.println("<td rowspan='"+contador+"'>"+formato6Decimales.format(res.getDouble("sumaControlCalidad")/res.getDouble("cantidadLote"))+"</td>");
                            out.println("<td rowspan='"+contador+"'>"+formato6Decimales.format(res.getDouble("sumaSoporte")/res.getDouble("cantidadLote"))+"</td>");
                        out.println("</tr>");
                        out.println(detalle.toString());
                    res.next();
                }
            }
            catch(SQLException ex)
            {
                ex.printStackTrace();;
            }
            catch(Exception e)
            {
                e.printStackTrace();
            }
            finally
            {
                con.close();
            }
        %>
     </table>
     </div>
   
    
</body>
</html>