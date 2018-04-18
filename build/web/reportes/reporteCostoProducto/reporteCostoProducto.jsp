<%@page import="java.util.Locale"%>
<html>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="com.cofar.util.Util"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.text.NumberFormat"%>

<%@ page language="java"%>
<%@ page contentType="text/html"%>
<%@ page pageEncoding="UTF-8"%>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <title>Costo Real</title>
    <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
    
</head>
<body>
    
    <center>
        <table >
            <tr >
                <td colspan="2" align="center" >
                    <%
                        NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
                        DecimalFormat formato = (DecimalFormat)nf;
                        formato.applyPattern("#,##0.00");

                        NumberFormat nfMil = NumberFormat.getNumberInstance(Locale.ENGLISH);
                        DecimalFormat formatoMil = (DecimalFormat)nfMil;
                        formatoMil.applyPattern("#,##0");

                        NumberFormat nf2 = NumberFormat.getNumberInstance(Locale.ENGLISH);
                        DecimalFormat formato6Decimales = (DecimalFormat)nf2;
                        formato6Decimales.applyPattern("#,##0.00######");
                        Connection con=null;
                        String mesAnioReporte = "";
                        try
                        { 
                            con=Util.openConnection(con);
                            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                            StringBuilder consulta = new StringBuilder("select m.NOMBRE_MES from meses m where m.COD_MES=").append(request.getParameter("nroMes"));
                            System.out.println("consulta datos "+consulta.toString());
                            ResultSet res=st.executeQuery(consulta.toString());
                            if(res.next()){
                                mesAnioReporte = res.getString("NOMBRE_MES")+" "+request.getParameter("anio");
                            }
                    %>
                    <h4>Costo Real (<%=(mesAnioReporte)%>)</h4>
                </td>
            </tr>
        </table>
    </center>
    
    
        <table width="90%" align="center" class="tablaReporte"  cellpadding="0" cellspacing="0" >
            <thead>
                <tr>
                    <td rowspan='2'>Lote</td>
                    <td rowspan='2'>Codigo Presentación</td>
                    <td rowspan='2'>Presentación</td>
                    <td rowspan='2'>Programa de Producción</td>
                    <td rowspan='2'>Tamaño Lote Programado</td>
                    <td rowspan='2'>Cantidad Ingreso Ventas</td>
                    <td rowspan='2'>Hrs. Pesaje</td>
                    <td rowspan='2'>Hrs. Pesaje Total</td>
                    <td rowspan='2'>Hrs. Almacen</td>
                    <td rowspan='2'>Hrs. Almacen Total</td>
                    <td rowspan='2'>Hrs. Producción</td>
                    <td rowspan='2'>Hrs. Producción Total</td>
                    <td rowspan='2'>Hrs. Acondicionamiento</td>
                    <td rowspan='2'>Hrs. Acondicionamiento Total</td>
                    <td rowspan='2'>Hrs. Microbiologia</td>
                    <td rowspan='2'>Hrs. Microbiologia Total</td>
                    <td rowspan='2'>Hrs. Control De Calidad</td>
                    <td rowspan='2'>Hrs. Control De Calidad Total</td>
                    <td rowspan='2'>Hrs. Total</td>
                    <td colspan = "14" class='tdCenter'>Mano de Obra Directa</td>
                    <td rowspan = "2">% Rendimiento Estandar</td>
                    <td colspan = "2" class='tdCenter'>MP</td>
                    <td colspan = "2" class='tdCenter'>MR</td>
                    <td colspan = "2" class='tdCenter'>EP</td>
                    <td colspan = "2" class='tdCenter'>ES</td>
                </tr>
                <tr>
                    <td >Pesaje</td>
                    <td>&nbsp;</td>
                    <td >Almacen</td>
                    <td>&nbsp;</td>
                    <td >Producción</td>
                    <td>&nbsp;</td>
                    <td >Acondicionamiento</td>
                    <td>&nbsp;</td>
                    <td >Microbiologia</td>
                    <td>&nbsp;</td>
                    <td >Control De Calidad</td>
                    <td>&nbsp;</td>
                    <td >Total</td>
                    <td>&nbsp;</td>
                    
                    <td>Costo x Cant U</td>
                    <td>Costo x Cant T</td>
                    <td>Costo x Cant U</td>
                    <td>Costo x Cant T</td>
                    <td>Costo x Cant U</td>
                    <td>Costo x Cant T</td>
                    <td>Costo x Cant U</td>
                    <td>Costo x Cant T</td>
                </tr>
            </thead>
            <%
                    consulta=new StringBuilder("exec PAA_LISTAR_COSTO_LOTE ")
                                        .append(request.getParameter("anio")).append(",")
                                        .append(request.getParameter("nroMes"));
                    System.out.println("consulta datos "+consulta.toString());
                    res=st.executeQuery(consulta.toString());
                    while(res.next())
                    {
                        Double tiempoTotalUnitario=res.getDouble("tiempoUnitarioPesaje")+res.getDouble("tiempoUnitarioAlmacen")+res.getDouble("tiempoUnitarioProduccion")+res.getDouble("tiempoUnitarioAcondicionamiento")+res.getDouble("tiempoUnitarioMicrobiologia")+res.getDouble("tiempoUnitarioControlCalidad");
                        Double costoMODTotalUnitario=res.getDouble("costoUnitarioPesaje")+res.getDouble("costoUnitarioAlmacen")+res.getDouble("costoUnitarioProduccion")+res.getDouble("costoUnitarioAcondicionamiento")+res.getDouble("costoUnitarioMicrobiologia")+res.getDouble("costoUnitarioControlCalidad");
                        out.println("<tr>");
                            out.println("<td>"+res.getString("COD_LOTE_PRODUCCION")+"</td>");
                            out.println("<td>"+res.getInt("COD_PRESENTACION")+"</td>");
                            out.println("<td>"+res.getString("NOMBRE_PRODUCTO_PRESENTACION")+"</td>");
                            out.println("<td>"+res.getString("NOMBRE_PROGRAMA_PROD")+"</td>");
                            out.println("<td class='tdRight'>"+formatoMil.format(res.getInt("cantidadLote"))+"</td>");
                            out.println("<td class='tdRight'>"+formatoMil.format(res.getInt("CANTIDAD_INGRESO_VENTAS"))+"</td>");
                            out.println("<td class='tdRight'>"+formato6Decimales.format(res.getDouble("tiempoUnitarioPesaje"))+"</td>");
                            out.println("<td class='tdRight'>"+formato6Decimales.format(res.getDouble("tiempoPesaje"))+"</td>");
                            out.println("<td class='tdRight'>"+formato6Decimales.format(res.getDouble("tiempoUnitarioAlmacen"))+"</td>");
                            out.println("<td class='tdRight'>"+formato6Decimales.format(res.getDouble("tiempoAlmacen"))+"</td>");
                            out.println("<td class='tdRight'>"+formato6Decimales.format(res.getDouble("tiempoUnitarioProduccion"))+"</td>");
                            out.println("<td class='tdRight'>"+formato6Decimales.format(res.getDouble("tiempoProduccion"))+"</td>");
                            out.println("<td class='tdRight'>"+formato6Decimales.format(res.getDouble("tiempoUnitarioAcondicionamiento"))+"</td>");
                            out.println("<td class='tdRight'>"+formato6Decimales.format(res.getDouble("tiempoAcondicionamiento"))+"</td>");
                            out.println("<td class='tdRight'>"+formato6Decimales.format(res.getDouble("tiempoUnitarioMicrobiologia"))+"</td>");
                            out.println("<td class='tdRight'>"+formato6Decimales.format(res.getDouble("tiempoMicrobiologia"))+"</td>");
                            out.println("<td class='tdRight'>"+formato6Decimales.format(res.getDouble("tiempoUnitarioControlCalidad"))+"</td>");
                            out.println("<td class='tdRight'>"+formato6Decimales.format(res.getDouble("tiempoControlCalidad"))+"</td>");
                            out.println("<td class='tdRight'>"+formato6Decimales.format(tiempoTotalUnitario)+"</td>");
                            out.println("<td class='tdRight'>"+formato6Decimales.format(res.getDouble("costoUnitarioPesaje"))+"</td>");
                            out.println("<td class='tdRight'>"+formato6Decimales.format(res.getDouble("costoUnitarioPesaje")*res.getDouble("CANTIDAD_INGRESO_VENTAS"))+"</td>");
                            out.println("<td class='tdRight'>"+formato6Decimales.format(res.getDouble("costoUnitarioAlmacen"))+"</td>");
                            out.println("<td class='tdRight'>"+formato6Decimales.format(res.getDouble("costoUnitarioAlmacen")*res.getDouble("CANTIDAD_INGRESO_VENTAS"))+"</td>");
                            out.println("<td class='tdRight'>"+formato6Decimales.format(res.getDouble("costoUnitarioProduccion"))+"</td>");
                            out.println("<td class='tdRight'>"+formato6Decimales.format(res.getDouble("costoUnitarioProduccion")*res.getDouble("CANTIDAD_INGRESO_VENTAS"))+"</td>");
                            out.println("<td class='tdRight'>"+formato6Decimales.format(res.getDouble("costoUnitarioAcondicionamiento"))+"</td>");
                            out.println("<td class='tdRight'>"+formato6Decimales.format(res.getDouble("costoUnitarioAcondicionamiento")*res.getDouble("CANTIDAD_INGRESO_VENTAS"))+"</td>");
                            out.println("<td class='tdRight'>"+formato6Decimales.format(res.getDouble("costoUnitarioMicrobiologia"))+"</td>");
                            out.println("<td class='tdRight'>"+formato6Decimales.format(res.getDouble("costoUnitarioMicrobiologia")*res.getDouble("CANTIDAD_INGRESO_VENTAS"))+"</td>");
                            out.println("<td class='tdRight'>"+formato6Decimales.format(res.getDouble("costoUnitarioControlCalidad"))+"</td>");
                            out.println("<td class='tdRight'>"+formato6Decimales.format(res.getDouble("costoUnitarioControlCalidad")*res.getDouble("CANTIDAD_INGRESO_VENTAS"))+"</td>");
                            out.println("<td class='tdRight'>"+formato6Decimales.format(costoMODTotalUnitario)+"</td>");
                            out.println("<td class='tdRight'>"+formato6Decimales.format(costoMODTotalUnitario*res.getDouble("CANTIDAD_INGRESO_VENTAS"))+"</td>");
                            //rendimiento lote
                            out.println("<td class='tdRight'>"+res.getDouble("PORCIENTO_RENDIMIENTO_MINIMO")+"</td>");
                            //COSTOS MATERIAL
                            out.println("<td class='tdRight'>"+formato6Decimales.format(res.getDouble("costoMp"))+"</td>");
                            out.println("<td class='tdRight'>"+formato6Decimales.format(res.getDouble("costoMp")*res.getDouble("CANTIDAD_INGRESO_VENTAS"))+"</td>");
                            out.println("<td class='tdRight'>"+formato6Decimales.format(res.getDouble("costoMr"))+"</td>");
                            out.println("<td class='tdRight'>"+formato6Decimales.format(res.getDouble("costoMr")*res.getDouble("CANTIDAD_INGRESO_VENTAS"))+"</td>");
                            out.println("<td class='tdRight'>"+formato6Decimales.format(res.getDouble("costoEp"))+"</td>");
                            out.println("<td class='tdRight'>"+formato6Decimales.format(res.getDouble("costoEp")*res.getDouble("CANTIDAD_INGRESO_VENTAS"))+"</td>");
                            out.println("<td class='tdRight'>"+formato6Decimales.format(res.getDouble("costoEs"))+"</td>");
                            out.println("<td class='tdRight'>"+formato6Decimales.format(res.getDouble("costoEs")*res.getDouble("CANTIDAD_INGRESO_VENTAS"))+"</td>");
                            
                            
                        out.println("</tr>");
                    }
                }
                catch(SQLException ex){
                    ex.printStackTrace();;
                }
                catch(Exception e){
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