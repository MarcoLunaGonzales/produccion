<%@page import="java.text.SimpleDateFormat"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.cofar.util.*" %>
<%@page  import="java.util.Date" %>
<%@ page import="com.cofar.web.*" %>
<html>
    <head>
        <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
    </head>
    <body>
        <h3 align="center" class="outputTextTituloSistema">Reporte de Liberacion de Productos</h3>
        <form method="post" action="reporteProductosLiberados.jsf" name="form1" target="_blank">
            <div align="center">
                <table cellpadding="0"   class="tablaFiltroReporte" cellspacing="0">    
                    <thead>
                        <tr>
                            <td colspan="3">Introduzca los Parametros de Busqueda</td>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td class="outputTextBold">Almacen</td>
                            <td class="outputTextBold">::</td>
                            <td>
                                <select name="codAlmacen" class="inputText">
                                <%
                                    Connection con=null;
                                    try 
                                    {
                                        con=Util.openConnection(con);
                                        StringBuilder consulta=new StringBuilder("select  av.COD_ALMACEN_VENTA,av.NOMBRE_ALMACEN_VENTA");
                                                                    consulta.append(" from ALMACENES_VENTAS_LIBERACION_LOTE avl ");
                                                                            consulta.append(" inner join ALMACENES_VENTAS av on av.COD_ALMACEN_VENTA=avl.COD_ALMACEN_VENTA_ORIGEN");
                                                                    consulta.append(" order by av.NOMBRE_ALMACEN_VENTA");
                                        Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                        ResultSet res=st.executeQuery(consulta.toString());
                                        while(res.next())
                                        {
                                            out.println("<option value='"+res.getInt("COD_ALMACEN_VENTA")+"'>"+res.getString("NOMBRE_ALMACEN_VENTA")+"</option>");
                                        }
                                    }
                                    catch(SQLException ex)
                                    {
                                        ex.printStackTrace();
                                    }
                                    finally
                                    {
                                        con.close();
                                    }
                                    SimpleDateFormat sdf=new SimpleDateFormat("/MM/yyyy");
                                %> 
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td class="outputTextBold">Fecha Inicio</td>
                            <td class="outputTextBold">::</td>
                            <td>
                                <input type="text" class="outputText3" size="16"  value="01<%=(sdf.format(new Date()))%>" id="fechaInicio" name="fechaInicio" >
                                <img id="imagenFecha1" src="../../img/fecha.bmp">
                                <DLCALENDAR tool_tip="Seleccione la Fecha"
                                            daybar_style="background-color: DBE1E7; 
                                            font-family: verdana; color:000000;"navbar_style="background-color: 7992B7; color:ffffff;" 
                                            input_element_id="fechaInicio" click_element_id="imagenFecha1">
                                            </DLCALENDAR>
                            </td>
                        </tr>
                        <%
                            sdf=new SimpleDateFormat("dd/MM/yyyy");
                        %>
                        <tr>
                            <td class="outputTextBold">Fecha Final</td>
                            <td class="outputTextBold">::</td>
                            <td>
                                <input type="text" class="outputText3" size="16"  value="<%=(sdf.format(new Date()))%>" name="fechaFinal" id="fechaFinal" >
                            <img id="imagenFecha2" src="../../img/fecha.bmp">
                            <DLCALENDAR tool_tip="Seleccione la Fecha"
                                        daybar_style="background-color: DBE1E7; 
                                        font-family: verdana; color:000000;"navbar_style="background-color: 7992B7; color:ffffff;" 
                                        input_element_id="fechaFinal" click_element_id="imagenFecha2">
                                        </DLCALENDAR>   
                            </td>
                        </tr>
                    </tbody>
                    <tfoot>
                        <tr>
                            <td colspan="3" class="tdCenter">
                                <input type="submit"   class="btn" value="Ver Reporte" name="btnVerReporte">
                                <input type="reset"   class="btn"  value="Limpiar" name="limpiar">
                            </td>
                        </tr>
                    </tfoot>
                </table>
            </div>
        </form>
        <script type="text/javascript"  src="../../js/dlcalendar.js"></script>
    </body>
</html>