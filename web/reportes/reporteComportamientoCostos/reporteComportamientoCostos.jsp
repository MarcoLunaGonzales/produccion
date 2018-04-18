<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.text.NumberFormat"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ page language="java" %>
<%@ page import="com.cofar.web.*" %>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.sql.DriverManager"%> 
<%@ page import = "java.sql.ResultSet"%> 
<%@ page import = "java.sql.Statement"%> 
<%@ page import="com.cofar.util.*" %>
<%@ page language="java" import="java.util.*" %>
<%@ page import="java.util.Date" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
        <title>JSP Page</title>
        <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
        <script src="../../js/general.js"></script>
        <style type="text/css">
            .ultimo{
                background-color: #edfae8;
            }
            .penUltimo{
                background-color: #fee9c2;
            }
            .antePenUltimo{
                background-color: #ecfbfc;
            }
            
        </style>
    </head>
    <body>
        <h3 align="center">Reporte de Comportamiento de Costos</h3>
        
        
            <%
                SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
                Date fechaInicioIngreso =  request.getParameter("fechaInicioIngreso").equals("") ? null : sdf.parse(request.getParameter("fechaInicioIngreso")+" 00:00");
                Date fechaFinalIngreso =  request.getParameter("fechaFinalIngreso").equals("") ? null : sdf.parse(request.getParameter("fechaFinalIngreso")+" 23:59");
                String codTipoCompra = request.getParameter("codTipoCompraPost");
                String nombreTipoCompraPost = request.getParameter("nombreTipoCompraPost");
                String codTipoTransporte = request.getParameter("codTipoTransportePost");
                String nombreTipoTransporte  = request.getParameter("nombreTipoTransportePost");
                String codCapitulo = request.getParameter("codCapituloPost");
                String nombreCapitulo = request.getParameter("nombreCapituloPost");
                String codGrupo = request.getParameter("codGrupoPost");
                String nombreGrupo = request.getParameter("nombreGrupoPost");
                NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
                DecimalFormat formato = (DecimalFormat)nf;
                formato.applyPattern("#,##0.00");
                
                NumberFormat nf1 = NumberFormat.getNumberInstance(Locale.ENGLISH);
                DecimalFormat formato6Decimales = (DecimalFormat)nf1;
                formato6Decimales.applyPattern("#,##0.000000");
            %>
         <table align="center" width="70%" class='outputText0'>
                <tr>
                    <td width="10%" rowspan="6">
                        <img src="../../img/cofar.png">
                    </td>
                    <td class="outputTextBold">Capitulos</td>
                    <td class="outputTextBold">::</td>
                    <td class="outputText2"><%=(nombreCapitulo)%></td>
                </tr>
                <tr>
                    <td class="outputTextBold">Grupos</td>
                    <td class="outputTextBold">::</td>
                    <td class="outputText2"><%=(nombreGrupo)%></td>
                </tr>
                <tr>
                    <td class="outputTextBold">Tipo Compra</td>
                    <td class="outputTextBold">::</td>
                    <td class="outputText2"><%=(nombreTipoCompraPost)%></td>
                </tr>
                <tr>
                    <td class="outputTextBold">Tipo Transporte</td>
                    <td class="outputTextBold">::</td>
                    <td class="outputText2"><%=(nombreTipoTransporte)%></td>
                </tr>
                <tr>
                    <td class="outputTextBold">Fecha Inicio Ingreso</td>
                    <td class="outputTextBold">::</td>
                    <td class="outputText2"><%=(fechaInicioIngreso != null?sdf.format(fechaInicioIngreso):"")%></td>
                </tr>
                <tr>
                    <td class="outputTextBold">Fecha Final Ingreso</td>
                    <td class="outputTextBold">::</td>
                    <td class="outputText2"><%=(fechaFinalIngreso != null ? sdf.format(fechaFinalIngreso) : "")%></td>
                </tr>
            </table>
        <table cellpading="0px" cellspacing="0px" class="tablaReporte outputText2">
            <thead>
                <tr>
                    <td rowspan="2">Item</td>
                    <td colspan="7" class="tdCenter">ULTIMA COMPRA</td>
                    <td colspan="7" class="tdCenter">PENULTIMA COMPRA</td>
                    
                    <td rowspan="2">FORMULA</td>
                </tr>
                <tr>
                    <td>Nro. OC</td>
                    <td>Fecha Ingreso</td>
                    <td>Cantidad de Compra</td>
                    <td>Unidad de Medida Compra</td>
                    <td>Cantidad Ingresada</td>
                    <td>Unidad Medida Ingreso</td>
                    <td>Costo Unitario</td>
                    
                    <td>Nro. OC</td>
                    <td>Fecha Ingreso</td>
                    <td>Cantidad de Compra</td>
                    <td>Unidad de Medida Compra</td>
                    <td>Cantidad Ingresada</td>
                    <td>Unidad Medida Ingreso</td>
                    <td>Costo Unitario</td>
                </tr>
            </thead>
            <tbody>
            <%
                Connection con = null;
                try{
                    con = Util.openConnection(con);
                    sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm");
                    StringBuilder consulta = new StringBuilder("select m.NOMBRE_MATERIAL,isnull(datosUltimaOc.NRO_ORDEN_COMPRA,0) as NRO_ORDEN_COMPRA,datosUltimaOc.CANTIDAD_NETA,")
                                                                    .append(" ISNULL(datosUltimaOc.ABREVIATURA,'') AS ABREVIATURA,datosUltimaOc.PRECIO_UNITARIO,datosUltimaOc.PRECIO_TOTAL,")
                                                                    .append(" isnull(datosPenultimaUltimaOc.NRO_ORDEN_COMPRA,0) as NRO_ORDEN_COMPRAPEN,datosPenultimaUltimaOc.CANTIDAD_NETA AS CANTIDAD_NETAPEN,")
                                                                    .append(" isnull(datosPenultimaUltimaOc.ABREVIATURA,'') AS ABREVIATURAPEN,datosPenultimaUltimaOc.PRECIO_UNITARIO AS PRECIO_UNITARIOPEN,datosPenultimaUltimaOc.PRECIO_TOTAL AS PRECIO_TOTALPEN,")
                                                                    .append(" datosIngresoUltimo.cantidadTotalIngreso,datosIngresoUltimo.precioIngreso,datosIngresoUltimo.fechaIngresoAlmacen,")
                                                                    .append(" datosIngresoPenUltimo.cantidadTotalIngresoPen,datosIngresoPenUltimo.precioIngresoPen,datosIngresoPenUltimo.fechaIngresoAlmacenPen")
                                                                    .append(" ,um.ABREVIATURA as unidadIngreso")
                                                        .append(" from materiales m")
                                                            .append(" inner join grupos g on g.COD_GRUPO = m.COD_GRUPO ")
                                                            .append(" inner join capitulos c on c.COD_CAPITULO = g.COD_CAPITULO")
                                                            .append(" inner join unidades_medida um on um.COD_UNIDAD_MEDIDA = m.COD_UNIDAD_MEDIDA")
                                                            .append(" outer APPLY")
                                                           .append(" (")
                                                                 .append(" select top 1 oc.NRO_ORDEN_COMPRA,oc.COD_ORDEN_COMPRA,ocd.CANTIDAD_NETA,um.ABREVIATURA,")
                                                                        .append(" ocd.PRECIO_UNITARIO,ocd.PRECIO_TOTAL")
                                                                 .append(" from ORDENES_COMPRA oc")
                                                                        .append(" inner join ORDENES_COMPRA_DETALLE ocd on oc.COD_ORDEN_COMPRA = ocd.COD_ORDEN_COMPRA")
                                                                        .append(" inner join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA = ocd.COD_UNIDAD_MEDIDA ")
                                                                        .append(" inner join INGRESOS_ALMACEN ia on ia.COD_ORDEN_COMPRA = oc.COD_ORDEN_COMPRA")
                                                                                .append(" and ia.COD_ESTADO_INGRESO_ALMACEN=1")
                                                                        .append(" inner join INGRESOS_ALMACEN_DETALLE iad on iad.COD_INGRESO_ALMACEN = ia.COD_INGRESO_ALMACEN")
                                                                                .append(" and iad.COD_MATERIAL=m.COD_MATERIAL")
                                                                 .append(" where oc.ESTADO_SISTEMA = 1 ")
                                                                        .append(" and ia.COD_ESTADO_INGRESO_ALMACEN=1 ")
                                                                       .append(" AND ocd.COD_MATERIAL = m.COD_MATERIAL");
                                                                       if(codTipoCompra.length() > 0)
                                                                           consulta.append(" and oc.COD_TIPO_COMPRA in (").append(codTipoCompra).append(")");
                                                                       if(codTipoTransporte.length() > 0)
                                                                           consulta.append(" and oc.COD_TIPO_TRANSPORTE in (").append(codTipoTransporte).append(")");
                                                                       if(fechaInicioIngreso != null)
                                                                           consulta.append(" and ia.FECHA_INGRESO_ALMACEN >= '").append(sdf.format(fechaInicioIngreso)).append("'");
                                                                       if(fechaFinalIngreso != null)
                                                                           consulta.append(" and ia.FECHA_INGRESO_ALMACEN <= '").append(sdf.format(fechaFinalIngreso)).append("'");
                                                                 consulta.append(" order by ia.FECHA_INGRESO_ALMACEN desc ")
                                                           .append(" ) as datosUltimaOc")
                                                            .append(" outer apply")
                                                            .append("(")
                                                                .append(" select sum(iad.CANT_TOTAL_INGRESO_FISICO) as cantidadTotalIngreso,max(iad.PRECIO_UNITARIO_MATERIAL) as precioIngreso,")
                                                                            .append("max(ia.FECHA_INGRESO_ALMACEN) as fechaIngresoAlmacen")
                                                                .append(" from INGRESOS_ALMACEN ia ")
                                                                        .append(" inner join INGRESOS_ALMACEN_DETALLE iad on iad.COD_INGRESO_ALMACEN= ia.COD_INGRESO_ALMACEN")
                                                                .append(" where ia.COD_ORDEN_COMPRA = datosUltimaOc.COD_ORDEN_COMPRA")
                                                                        .append(" and ia.COD_ESTADO_INGRESO_ALMACEN=1")
                                                                        .append(" and iad.COD_MATERIAL = m.COD_MATERIAL")
                                                            .append(") as datosIngresoUltimo")
                                                           .append(" outer APPLY")
                                                        .append("    (")
                                                                 .append(" select top 1 oc.NRO_ORDEN_COMPRA,oc.COD_ORDEN_COMPRA,ocd.CANTIDAD_NETA,um.ABREVIATURA,")
                                                                                .append(" ocd.PRECIO_UNITARIO,ocd.PRECIO_TOTAL")
                                                                 .append(" from ORDENES_COMPRA oc")
                                                                            .append(" inner join ORDENES_COMPRA_DETALLE ocd on oc.COD_ORDEN_COMPRA = ocd.COD_ORDEN_COMPRA")
                                                                            .append(" inner join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA = ocd.COD_UNIDAD_MEDIDA ")
                                                                            .append(" inner join INGRESOS_ALMACEN ia on ia.COD_ORDEN_COMPRA = oc.COD_ORDEN_COMPRA")
                                                                                    .append(" and ia.COD_ESTADO_INGRESO_ALMACEN=1")
                                                                            .append(" inner join INGRESOS_ALMACEN_DETALLE iad on iad.COD_INGRESO_ALMACEN = ia.COD_INGRESO_ALMACEN")
                                                                                    .append(" and iad.COD_MATERIAL=m.COD_MATERIAL")
                                                                 .append(" where oc.ESTADO_SISTEMA = 1 and")
                                                                       .append(" ocd.COD_MATERIAL = m.COD_MATERIAL and ")
                                                                        .append("ia.COD_ESTADO_INGRESO_ALMACEN=1")
                                                                       .append(" and oc.COD_ORDEN_COMPRA <> datosUltimaOc.COD_ORDEN_COMPRA");
                                                                         if(codTipoCompra.length() > 0)
                                                                           consulta.append(" and oc.COD_TIPO_COMPRA in (").append(codTipoCompra).append(")");
                                                                       if(codTipoTransporte.length() > 0)
                                                                           consulta.append(" and oc.COD_TIPO_TRANSPORTE in (").append(codTipoTransporte).append(")");
                                                                       if(fechaFinalIngreso != null)
                                                                           consulta.append(" and ia.FECHA_INGRESO_ALMACEN <= '").append(sdf.format(fechaFinalIngreso)).append("'");
                                                                 consulta.append(" order by ia.FECHA_INGRESO_ALMACEN desc ")
                                                           .append(" ) as datosPenultimaUltimaOc")
                                                            .append(" outer apply")
                                                            .append("(")
                                                                .append(" select sum(iad.CANT_TOTAL_INGRESO_FISICO) as cantidadTotalIngresoPen,max(iad.PRECIO_UNITARIO_MATERIAL) as precioIngresoPen,")
                                                                            .append("max(ia.FECHA_INGRESO_ALMACEN) as fechaIngresoAlmacenPen")
                                                                .append(" from INGRESOS_ALMACEN ia ")
                                                                        .append(" inner join INGRESOS_ALMACEN_DETALLE iad on iad.COD_INGRESO_ALMACEN= ia.COD_INGRESO_ALMACEN")
                                                                .append(" where ia.COD_ORDEN_COMPRA = datosPenultimaUltimaOc.COD_ORDEN_COMPRA")
                                                                        .append(" and iad.COD_MATERIAL = m.COD_MATERIAL")
                                                                        .append(" and ia.COD_ESTADO_INGRESO_ALMACEN=1")
                                                            .append(") as datosIngresoPenUltimo")
                                                        .append(" where m.COD_ESTADO_REGISTRO = 1");
                                                            if(codGrupo.length()>0)
                                                            {
                                                                consulta.append(" and g.COD_GRUPO in (").append(codGrupo).append(")");
                                                            }
                                                            if(codCapitulo.length()>0){
                                                                consulta.append(" and c.COD_CAPITULO IN (").append(codCapitulo).append(")");
                                                            }
                                                        consulta.append(" order by m.NOMBRE_MATERIAL");
                    System.out.println("consulta reporte: "+consulta.toString());
                    Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet res =st.executeQuery(consulta.toString());
                    sdf = new SimpleDateFormat("dd/MM/yyyy");
                    while(res.next())
                    {
                        out.println("<tr>");
                            out.println("<td>"+res.getString("NOMBRE_MATERIAL")+"</td>");
                            out.println("<td class ='ultimo'>"+res.getString("NRO_ORDEN_COMPRA")+"</td>");
                            out.println("<td class ='ultimo'>"+(res.getTimestamp("fechaIngresoAlmacen") != null ? sdf.format(res.getTimestamp("fechaIngresoAlmacen")) : "")+"</td>");
                            out.println("<td class='tdRight ultimo'>"+formato.format(res.getDouble("CANTIDAD_NETA"))+"</td>");
                            out.println("<td class='tdCenter ultimo'>"+res.getString("ABREVIATURA")+"</td>");
                            out.println("<td class='tdRight ultimo'>"+formato.format(res.getDouble("cantidadTotalIngreso"))+"</td>");
                            out.println("<td class='tdRight ultimo'>"+res.getString("unidadIngreso")+"</td>");
                            out.println("<td class='tdRight ultimo'>"+formato6Decimales.format(res.getDouble("precioIngreso"))+"</td>");
                            out.println("<td class='penUltimo'>"+res.getString("NRO_ORDEN_COMPRAPEN")+"</td>");
                            out.println("<td class ='penUltimo'>"+(res.getTimestamp("fechaIngresoAlmacenPen") != null ? sdf.format(res.getTimestamp("fechaIngresoAlmacenPen")) : "")+"</td>");
                            out.println("<td class='tdRight penUltimo'>"+formato.format(res.getDouble("CANTIDAD_NETAPEN"))+"</td>");
                            out.println("<td class='tdCenter penUltimo'>"+res.getString("ABREVIATURAPEN")+"</td>");
                            out.println("<td class='tdRight penUltimo'>"+formato.format(res.getDouble("cantidadTotalIngresoPen"))+"</td>");
                            out.println("<td class='tdRight penUltimo'>"+res.getString("unidadIngreso")+"</td>");
                            out.println("<td class='tdRight penUltimo'>"+formato6Decimales.format(res.getDouble("precioIngresoPen"))+"</td>");
                            out.println("<td class='tdRight'>"+formato6Decimales.format((1-(res.getDouble("precioIngresoPen")/res.getDouble("precioIngreso"))))+"</td>");
                        out.println("</tr>");
                    }
                }
                catch(SQLException ex){
                    ex.printStackTrace();
                }
                catch(Exception ex){
                    ex.printStackTrace();
                }
                finally{
                    con.close();
                }
                
            %>
            </tbody>
        </table>        
          

        </form>
    </body>
</html>
