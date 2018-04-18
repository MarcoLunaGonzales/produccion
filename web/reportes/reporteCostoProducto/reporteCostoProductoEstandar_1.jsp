<html>
<%@page import="java.util.Locale"%>
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
    <title>Costo Estandar</title>
    <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
    <link rel="STYLESHEET" type="text/css" href="responsive-tables.css" />
    <script type="text/javascript" src='jquery-1.10.2.min.js' ></script>
    <script type="text/javascript" src='responsive-tables.js' ></script>
    
    <style type="text/css">
        .celdaHorasHombre
        {
            background-color: #e6f8e9 !important;
        }
        .celdaHorasUnitarias
        {
            background-color: #feeac0 !important;
        }
        .celdaCostoUnitario
        {
            background-color: #b0e8f7 !important;
        }
        .celdaCostoMaterial
        {
            background-color: #fefee4 !important;
        }
        
        .celdaPrecioTotal
        {
            font-size: 12px;
            background-color: #7f7f7f !important;
            color:white;
            font-weight: bold;
        }
    </style>
</head>
<body>
    
    <center>
        <table >
            <tr >
                <td colspan="2" align="center" >
                    <h4>Costo Estandar (MARZO 2017)</h4>
                </td>
            </tr>
        </table>
    </center>
    
    
        <table width="90%" align="center" switched class="tablaReporte"  cellpadding="0" cellspacing="0" >
            <thead>
                <tr>
                    <td rowspan='3' class='responsiveVisible'>Lote</td>
                    <td rowspan='3' class='responsiveVisible'>Codigo Presentación</td>
                    <td rowspan='3' class='responsiveVisible'>Presentación</td>
                    <td rowspan='3' class='responsiveVisible'>Programa de Producción</td>
                    <td rowspan='3' class='responsiveVisible'>Tamaño Lote Programado</td>
                    <td rowspan='3' class='responsiveVisible'>Cantidad Ingreso Ventas</td>
                    <td rowspan='3'>Hrs. Pesaje Total</td>
                    <td rowspan='3'>Hrs. Almacen Total</td>
                    <td rowspan='3'>Hrs. Producción Total</td>
                    <td rowspan='3'>Hrs. Acondicionamiento Total</td>
                    <td rowspan='3'>Hrs. Microbiologia Total</td>
                    <td rowspan='3'>Hrs. Control De Calidad Total</td>
                    <td rowspan='3'>Hrs. Unitario Pesaje</td>
                    <td rowspan='3'>Hrs. Unitario Almacen</td>
                    <td rowspan='3'>Hrs. Unitario Producción</td>
                    <td rowspan='3'>Hrs. Unitario Acondicionamiento</td>
                    <td rowspan='3'>Hrs. Unitario Microbiologia</td>
                    <td rowspan='3'>Hrs. Unitario Control De Calidad</td>
                    <td rowspan='3'>Hrs. Unitario Total</td>
                    <td colspan="14" class='tdCenter'>Mano de Obra Directa</td>
                    <td colspan="10" class='tdCenter'>Materiales</td>
                    
                    <td rowspan="3" class='tdCenter'>Costo Total Unitario(Bs)</td>
                    <td rowspan="3" class='tdCenter'>Costo Total Lote (Bs)</td>
                </tr>
                <tr>
                    <td class="tdCenter" rowspan='2'>Costo<br/>Unitario<br/>Pesaje<br/>(Bs)</td>
                    <td class="tdCenter" rowspan='2'>Costo</br>Total<br/>Pesaje<br/>(Bs)</td>
                    <td class="tdCenter" rowspan='2'>Costo<br/>Unitario<br/>Almacen<br/>(Bs)</td>
                    <td class="tdCenter" rowspan='2'>Costo</br>Total<br/>Almacen<br/>(Bs)</td>
                    <td class="tdCenter" rowspan='2'>Costo<br/>Unitario<br/>Producción<br/>(Bs)</td>
                    <td class="tdCenter" rowspan='2'>Costo</br>Total<br/>Producción<br/>(Bs)</td>
                    <td class="tdCenter" rowspan='2'>Costo<br/>Unitario<br/>Acondicionamiento<br/>(Bs)</td>
                    <td class="tdCenter" rowspan='2'>Costo</br>Total<br/>Acondicionamiento<br/>(Bs)</td>
                    <td class="tdCenter" rowspan='2'>Costo<br/>Unitario<br/>Microbiologia<br/>(Bs)</td>
                    <td class="tdCenter" rowspan='2'>Costo</br>Total<br/>Microbiologia<br/>(Bs)</td>
                    <td class="tdCenter" rowspan='2'>Costo<br/>Unitario<br/>Control de Calidad<br/>(Bs)</td>
                    <td class="tdCenter" rowspan='2'>Costo</br>Total<br/>Control de Calidad<br/>(Bs)</td>
                    <td class="tdCenter" rowspan='2'>Costo<br/>Unitario<br/>Mano de Obra<br/>(Bs)</td>
                    <td class="tdCenter" rowspan='2'>Costo</br>Total<br/>Mano de Obra<br/>(Bs)</td>
                    <td colspan="2" class='tdCenter'>MP</td>
                    <td colspan="2" class='tdCenter'>MR</td>
                    <td colspan="2" class='tdCenter'>EP</td>
                    <td colspan="2" class='tdCenter'>ES</td>
                    <td colspan="2" class='tdCenter'>Total</td>
                </tr>
                <tr>
                    <td class="tdCenter">Costo x Cantidad Unitaria (Bs)</td>
                    <td class="tdCenter">Costo Total (Bs)</td>
                    <td class="tdCenter">Costo x Cantidad Unitaria (Bs)</td>
                    <td class="tdCenter">Costo Total (Bs)</td>
                    <td class="tdCenter">Costo x Cantidad Unitaria (Bs)</td>
                    <td class="tdCenter">Costo Total (Bs)</td>
                    <td class="tdCenter">Costo x Cantidad Unitaria (Bs)</td>
                    <td class="tdCenter">Costo Total (Bs)</td>
                    <td class="tdCenter">Costo x Cantidad Unitaria (Bs)</td>
                    <td class="tdCenter">Costo Total (Bs)</td>
                </tr>
            </thead>
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
                try
                { 
                    con=Util.openConnection(con);
                    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    StringBuilder consulta=new StringBuilder("exec PAA_LISTAR_COSTO_ESTANDAR_LOTE ")
                                                    .append(request.getParameter("anio")).append(",")
                                                    .append(request.getParameter("nroMes"));
                    System.out.println("consulta datos "+consulta.toString());
                    ResultSet res=st.executeQuery(consulta.toString());
                    while(res.next())
                    {
                        Double tiempoTotalUnitario=res.getDouble("tiempoUnitarioPesaje")+res.getDouble("tiempoUnitarioAlmacen")+res.getDouble("tiempoUnitarioProduccion")+res.getDouble("tiempoUnitarioAcondicionamiento")+res.getDouble("tiempoUnitarioMicrobiologia")+res.getDouble("tiempoUnitarioControlCalidad");
                        Double costoMODTotalUnitario=res.getDouble("costoUnitarioPesaje")+res.getDouble("costoUnitarioAlmacen")+res.getDouble("costoUnitarioProduccion")+res.getDouble("costoUnitarioAcondicionamiento")+res.getDouble("costoUnitarioMicrobiologia")+res.getDouble("costoUnitarioControlCalidad");
                        Double costoUnitarioMaterial=res.getDouble("costoMp")+res.getDouble("costoMr")+res.getDouble("costoEp")+res.getDouble("costoEs");
                        out.println("<tr>");
                            out.println("<td class='responsiveVisible'>"+res.getString("COD_LOTE_PRODUCCION")+"</td>");
                            out.println("<td class='responsiveVisible'>"+res.getInt("COD_PRESENTACION")+"</td>");
                            out.println("<td class='responsiveVisible'>"+res.getString("NOMBRE_PRODUCTO_PRESENTACION")+"</td>");
                            out.println("<td class='responsiveVisible'>"+res.getString("NOMBRE_PROGRAMA_PROD")+"</td>");
                            out.println("<td class='tdRight'>"+formatoMil.format(res.getInt("cantidadLote"))+"</td>");
                            out.println("<td class='tdRight'>"+formatoMil.format(res.getInt("CANTIDAD_INGRESO_VENTAS"))+"</td>");
                            out.println("<td class='tdRight celdaHorasHombre'>"+formato.format(res.getDouble("sumaPesaje"))+"</td>");
                            out.println("<td class='tdRight celdaHorasHombre'>"+formato.format(res.getDouble("sumaAlmacen"))+"</td>");
                            out.println("<td class='tdRight celdaHorasHombre'>"+formato.format(res.getDouble("sumaProduccion"))+"</td>");
                            out.println("<td class='tdRight celdaHorasHombre'>"+formato.format(res.getDouble("sumaAcondicionamiento"))+"</td>");
                            out.println("<td class='tdRight celdaHorasHombre'>"+formato.format(res.getDouble("sumaMicrobiologia"))+"</td>");
                            out.println("<td class='tdRight celdaHorasHombre'>"+formato.format(res.getDouble("sumaControlCalidad"))+"</td>");
                            out.println("<td class='tdRight celdaHorasUnitarias'>"+formato6Decimales.format(res.getDouble("tiempoUnitarioPesaje"))+"</td>");
                            out.println("<td class='tdRight celdaHorasUnitarias'>"+formato6Decimales.format(res.getDouble("tiempoUnitarioAlmacen"))+"</td>");
                            out.println("<td class='tdRight celdaHorasUnitarias'>"+formato6Decimales.format(res.getDouble("tiempoUnitarioProduccion"))+"</td>");
                            out.println("<td class='tdRight celdaHorasUnitarias'>"+formato6Decimales.format(res.getDouble("tiempoUnitarioAcondicionamiento"))+"</td>");
                            out.println("<td class='tdRight celdaHorasUnitarias'>"+formato6Decimales.format(res.getDouble("tiempoUnitarioMicrobiologia"))+"</td>");
                            out.println("<td class='tdRight celdaHorasUnitarias'>"+formato6Decimales.format(res.getDouble("tiempoUnitarioControlCalidad"))+"</td>");
                            out.println("<td class='tdRight celdaHorasUnitarias'>"+formato6Decimales.format(tiempoTotalUnitario)+"</td>");
                            out.println("<td class='tdRight celdaCostoUnitario'>"+formato6Decimales.format(res.getDouble("costoUnitarioPesaje"))+"</td>");
                            out.println("<td class='tdRight celdaCostoUnitario'>"+formato6Decimales.format(res.getDouble("costoUnitarioPesaje")*res.getDouble("CANTIDAD_INGRESO_VENTAS"))+"</td>");
                            out.println("<td class='tdRight celdaCostoUnitario'>"+formato6Decimales.format(res.getDouble("costoUnitarioAlmacen"))+"</td>");
                            out.println("<td class='tdRight celdaCostoUnitario'>"+formato6Decimales.format(res.getDouble("costoUnitarioAlmacen")*res.getDouble("CANTIDAD_INGRESO_VENTAS"))+"</td>");
                            out.println("<td class='tdRight celdaCostoUnitario'>"+formato6Decimales.format(res.getDouble("costoUnitarioProduccion"))+"</td>");
                            out.println("<td class='tdRight celdaCostoUnitario'>"+formato6Decimales.format(res.getDouble("costoUnitarioProduccion")*res.getDouble("CANTIDAD_INGRESO_VENTAS"))+"</td>");
                            out.println("<td class='tdRight celdaCostoUnitario'>"+formato6Decimales.format(res.getDouble("costoUnitarioAcondicionamiento"))+"</td>");
                            out.println("<td class='tdRight celdaCostoUnitario'>"+formato6Decimales.format(res.getDouble("costoUnitarioAcondicionamiento")*res.getDouble("CANTIDAD_INGRESO_VENTAS"))+"</td>");
                            out.println("<td class='tdRight celdaCostoUnitario'>"+formato6Decimales.format(res.getDouble("costoUnitarioMicrobiologia"))+"</td>");
                            out.println("<td class='tdRight celdaCostoUnitario'>"+formato6Decimales.format(res.getDouble("costoUnitarioMicrobiologia")*res.getDouble("CANTIDAD_INGRESO_VENTAS"))+"</td>");
                            out.println("<td class='tdRight celdaCostoUnitario'>"+formato6Decimales.format(res.getDouble("costoUnitarioControlCalidad"))+"</td>");
                            out.println("<td class='tdRight celdaCostoUnitario'>"+formato6Decimales.format(res.getDouble("costoUnitarioControlCalidad")*res.getDouble("CANTIDAD_INGRESO_VENTAS"))+"</td>");
                            out.println("<td class='tdRight celdaCostoUnitario'>"+formato6Decimales.format(costoMODTotalUnitario)+"</td>");
                            out.println("<td class='tdRight celdaCostoUnitario'>"+formato6Decimales.format(costoMODTotalUnitario*res.getDouble("CANTIDAD_INGRESO_VENTAS"))+"</td>");
                            out.println("<td class='tdRight celdaCostoMaterial'>"+formato6Decimales.format(res.getDouble("costoMp"))+"</td>");
                            out.println("<td class='tdRight celdaCostoMaterial'>"+formato6Decimales.format(res.getDouble("costoMp")*res.getDouble("CANTIDAD_INGRESO_VENTAS"))+"</td>");
                            out.println("<td class='tdRight celdaCostoMaterial'>"+formato6Decimales.format(res.getDouble("costoMr"))+"</td>");
                            out.println("<td class='tdRight celdaCostoMaterial'>"+formato6Decimales.format(res.getDouble("costoMr")*res.getDouble("CANTIDAD_INGRESO_VENTAS"))+"</td>");
                            out.println("<td class='tdRight celdaCostoMaterial'>"+formato6Decimales.format(res.getDouble("costoEp"))+"</td>");
                            out.println("<td class='tdRight celdaCostoMaterial'>"+formato6Decimales.format(res.getDouble("costoEp")*res.getDouble("CANTIDAD_INGRESO_VENTAS"))+"</td>");
                            out.println("<td class='tdRight celdaCostoMaterial'>"+formato6Decimales.format(res.getDouble("costoEs"))+"</td>");
                            out.println("<td class='tdRight celdaCostoMaterial'>"+formato6Decimales.format(res.getDouble("costoEs")*res.getDouble("CANTIDAD_INGRESO_VENTAS"))+"</td>");
                            out.println("<td class='tdRight celdaCostoMaterial'>"+formato6Decimales.format(costoUnitarioMaterial)+"</td>");
                            out.println("<td class='tdRight celdaCostoMaterial'>"+formato6Decimales.format(costoUnitarioMaterial*res.getDouble("CANTIDAD_INGRESO_VENTAS"))+"</td>");
                            out.println("<td class='tdRight '>"+formato6Decimales.format(costoMODTotalUnitario+costoUnitarioMaterial)+"</td>");
                            out.println("<td class='tdRight celdaPrecioTotal'>"+formato.format((costoMODTotalUnitario+costoUnitarioMaterial)*res.getDouble("CANTIDAD_INGRESO_VENTAS"))+"</td>");
                            
                        out.println("</tr>");
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