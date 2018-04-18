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
                            
                    <h4>Costo Estandar (<%=(mesAnioReporte)%>)</h4>
                </td>
            </tr>
        </table>
    </center>
    
    
        <table width="90%" align="center" switched class="tablaReporte"  cellpadding="0" cellspacing="0" >
            <thead>
                <tr style='height: '>
                    <td style='height:24px !important'   class='responsiveVisible'>Lote</td>
    
                    <td style='height:24px !important'   class='responsiveVisible'>Presentación</td>
                    <td style='height:24px !important'   class='responsiveVisible'>Tamaño</td>
                    <td style='height:24px !important'   class='responsiveVisible'>Cant. Ingreso<br/>Almacen</td>
                    <td style='height:24px !important' class="tdCenter">Programa<br/> de Producción</td>
                    <td style='height:24px !important'  class="tdCenter">Hrs. Pesaje<br/> Total</td>
                    <td style='height:24px !important'  class="tdCenter">Hrs. Almacen<br/> Total</td>
                    <td style='height:24px !important'  class="tdCenter">Hrs. Producción<br/> Total</td>
                    <td style='height:24px !important'  class="tdCenter">Hrs. Acondicionamiento<br/> Total</td>
                    <td style='height:24px !important'  class="tdCenter">Hrs. Microbiologia<br/> Total</td>
                    <td style='height:24px !important'  class="tdCenter">Hrs. Control De Calidad<br/> Total</td>
                    <td style='height:24px !important'  class="tdCenter">Hrs. Soporte A la Manufactura<br/> Total</td>
                    <td style='height:24px !important'  class="tdCenter">Hrs. Unitario<br/> Pesaje</td>
                    <td style='height:24px !important'  class="tdCenter">Hrs. Unitario<br/> Almacen</td>
                    <td style='height:24px !important'  class="tdCenter">Hrs. Unitario<br/> Producción</td>
                    <td style='height:24px !important'  class="tdCenter">Hrs. Unitario<br/> Acondicionamiento</td>
                    <td style='height:24px !important'  class="tdCenter">Hrs. Unitario<br/> Microbiologia</td>
                    <td style='height:24px !important'  class="tdCenter">Hrs. Unitario<br/> Control De Calidad</td>
                    <td style='height:24px !important'  class="tdCenter">Hrs. Unitario<br/> Soporte a la Manufactura</td>
                    <td style='height:24px !important'  class="tdCenter">Hrs. Unitario<br/> Total</td>
                    <td style='height:24px !important'  class="tdCenter" >Costo Unitario<br/> Pesaje (Bs)</td>
                    <td style='height:24px !important'  class="tdCenter" >Costo Total<br/> Pesaje (Bs)</td>
                    <td style='height:24px !important'  class="tdCenter" >Costo Unitario<br/> Almacen (Bs)</td>
                    <td style='height:24px !important'  class="tdCenter" >Costo Total<br/> Almacen (Bs)</td>
                    <td style='height:24px !important'  class="tdCenter" >Costo Unitario<br/> Producción (Bs)</td>
                    <td style='height:24px !important'  class="tdCenter" >Costo Total<br/> Producción (Bs)</td>
                    <td style='height:24px !important'  class="tdCenter" >Costo Unitario<br/> Acondicionamiento (Bs)</td>
                    <td style='height:24px !important'  class="tdCenter" >Costo Total<br/> Acondicionamiento (Bs)</td>
                    <td style='height:24px !important'  class="tdCenter" >Costo Unitario<br/> Microbiologia (Bs)</td>
                    <td style='height:24px !important'  class="tdCenter" >Costo Total<br/> Microbiologia (Bs)</td>
                    <td style='height:24px !important'  class="tdCenter" >Costo Unitario<br/> Control de Calidad (Bs)</td>
                    <td style='height:24px !important'  class="tdCenter" >Costo Total<br/> Control de Calidad (Bs)</td>
                    <td style='height:24px !important'  class="tdCenter" >Costo Unitario<br/> Soporte a la Manufactura (Bs)</td>
                    <td style='height:24px !important'  class="tdCenter" >Costo Total<br/> Soporte a la Manufactura (Bs)</td>
                    <td style='height:24px !important'  class="tdCenter" >Costo Unitario<br/> Mano de Obra (Bs)</td>
                    <td style='height:24px !important'  class="tdCenter" >Costo Total<br/> Mano de Obra (Bs)</td>
                    <td style='height:24px !important'  class="tdCenter" >Costo Unitario<br/> Mano de Obra (Bs)</td>
                    <td style='height:24px !important'  class="tdCenter" >Costo Total<br/> Mano de Obra (Bs)</td>
                    <td style='height:24px !important'  class="tdCenter">Costo x Cantidad MP<br/> Unitaria (Bs) </td>
                    <td style='height:24px !important'  class="tdCenter">Costo Total MP<br/>(Bs) </td>
                    <td style='height:24px !important'  class="tdCenter">Costo x Cantidad MR<br/> Unitaria (Bs) </td>
                    <td style='height:24px !important'  class="tdCenter">Costo Total MR<br/> (Bs) </td>
                    <td style='height:24px !important'  class="tdCenter">Costo x Cantidad EP<br/>Unitaria (Bs) </td>
                    <td style='height:24px !important'  class="tdCenter">Costo Total EP<br/>(Bs)</td>
                    <td style='height:24px !important'  class="tdCenter">Costo x Cantidad ES<br/>Unitaria (Bs) </td>
                    <td style='height:24px !important'  class="tdCenter">Costo Total ES<br/>(Bs)</td>
                    <td style='height:24px !important'  class='tdCenter'>Costo Total <br/> Unitario(Bs)</td>
                    <td style='height:24px !important'   class='tdCenter'>Costo Total <br/> Lote (Bs)</td>
                
                    
                    
                </tr>
               
            </thead>
            <%
                
                    consulta=new StringBuilder("exec PAA_LISTAR_COSTO_ESTANDAR_LOTE ")
                                            .append(request.getParameter("anio")).append(",")
                                            .append(request.getParameter("nroMes"));
                    System.out.println("consulta datos "+consulta.toString());
                    res=st.executeQuery(consulta.toString());
                    while(res.next())
                    {
                        Double tiempoTotalUnitario=res.getDouble("tiempoUnitarioPesaje")+res.getDouble("tiempoUnitarioAlmacen")+res.getDouble("tiempoUnitarioProduccion")+res.getDouble("tiempoUnitarioAcondicionamiento")+res.getDouble("tiempoUnitarioMicrobiologia")+res.getDouble("tiempoUnitarioControlCalidad")+res.getDouble("tiempoUnitarioSoporte");
                        Double costoMODTotalUnitario=res.getDouble("costoUnitarioPesaje")+res.getDouble("costoUnitarioAlmacen")+res.getDouble("costoUnitarioProduccion")+res.getDouble("costoUnitarioAcondicionamiento")+res.getDouble("costoUnitarioMicrobiologia")+res.getDouble("costoUnitarioControlCalidad")+res.getDouble("costoUnitarioSoporte");
                        Double costoUnitarioMaterial=res.getDouble("costoMp")+res.getDouble("costoMr")+res.getDouble("costoEp")+res.getDouble("costoEs");
                        out.println("<tr>");
                            out.println("<td class='responsiveVisible'>"+res.getString("COD_LOTE_PRODUCCION")+"</td>");
                            out.println("<td class='responsiveVisible'>"+res.getString("NOMBRE_PRODUCTO_PRESENTACION")+"</td>");
                            
                            out.println("<td class='tdRight responsiveVisible'>"+formatoMil.format(res.getInt("cantidadLote"))+"</td>");
                            out.println("<td class='tdRight responsiveVisible'>"+formatoMil.format(res.getInt("CANTIDAD_INGRESO_VENTAS"))+"</td>");
                            out.println("<td >"+res.getString("NOMBRE_PROGRAMA_PROD")+"</td>");
                            out.println("<td class='tdRight celdaHorasHombre'>"+formato.format(res.getDouble("sumaPesaje"))+"</td>");
                            out.println("<td class='tdRight celdaHorasHombre'>"+formato.format(res.getDouble("sumaAlmacen"))+"</td>");
                            out.println("<td class='tdRight celdaHorasHombre'>"+formato.format(res.getDouble("sumaProduccion"))+"</td>");
                            out.println("<td class='tdRight celdaHorasHombre'>"+formato.format(res.getDouble("sumaAcondicionamiento"))+"</td>");
                            out.println("<td class='tdRight celdaHorasHombre'>"+formato.format(res.getDouble("sumaMicrobiologia"))+"</td>");
                            out.println("<td class='tdRight celdaHorasHombre'>"+formato.format(res.getDouble("sumaControlCalidad"))+"</td>");
                            out.println("<td class='tdRight celdaHorasHombre'>"+formato.format(res.getDouble("sumaSoporte"))+"</td>");
                            out.println("<td class='tdRight celdaHorasUnitarias'>"+formato6Decimales.format(res.getDouble("tiempoUnitarioPesaje"))+"</td>");
                            out.println("<td class='tdRight celdaHorasUnitarias'>"+formato6Decimales.format(res.getDouble("tiempoUnitarioAlmacen"))+"</td>");
                            out.println("<td class='tdRight celdaHorasUnitarias'>"+formato6Decimales.format(res.getDouble("tiempoUnitarioProduccion"))+"</td>");
                            out.println("<td class='tdRight celdaHorasUnitarias'>"+formato6Decimales.format(res.getDouble("tiempoUnitarioAcondicionamiento"))+"</td>");
                            out.println("<td class='tdRight celdaHorasUnitarias'>"+formato6Decimales.format(res.getDouble("tiempoUnitarioMicrobiologia"))+"</td>");
                            out.println("<td class='tdRight celdaHorasUnitarias'>"+formato6Decimales.format(res.getDouble("tiempoUnitarioControlCalidad"))+"</td>");
                            out.println("<td class='tdRight celdaHorasUnitarias'>"+formato6Decimales.format(res.getDouble("tiempoUnitarioSoporte"))+"</td>");
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
                            out.println("<td class='tdRight celdaCostoUnitario'>"+formato6Decimales.format(res.getDouble("costoUnitarioSoporte"))+"</td>");
                            out.println("<td class='tdRight celdaCostoUnitario'>"+formato6Decimales.format(res.getDouble("costoUnitarioSoporte")*res.getDouble("CANTIDAD_INGRESO_VENTAS"))+"</td>");
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