<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.cofar.util.*" %>
<%@ page import="com.cofar.web.*" %>

<html>
    <head>
        <meta charset="utf-8" /> 
        <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
        <script type="text/javascript" src="../../js/general.js"></script>
        <script>
            function ajaxProducto()
            {	                
                ajax=creaAjax();
                ajax.open("GET","ajaxProductosEstado.jsf?codEstadoProducto="+document.getElementById("codEstadoProducto").value+
                            "&a="+(new Date()).getTime().toString(),true);
                    ajax.onreadystatechange=function()
                    {
                        if (ajax.readyState==4) 
                        {                       
                            document.getElementById("presentacion").innerHTML=ajax.responseText;
                        }
                    }                
                ajax.send(null);
            }
            function verificarDatos()
            { 
                return validarSeleccionMayorACero(document.getElementById("codPresentacion"));
                        /*&&
                        validarFecha(document.getElementById("fechaInicio"))&&
                        validarFecha(document.getElementById("fechaFinal"));*/
            }
        </script>
    </head>
    <body>
        <h3 align="center" class="outputTextTituloSistema">Consolidado Trimestral</h3>
        <form method="post" action="reporteConsolidadoTrimestral.jsf" name="form1" target="_blank">
            <div align="center">
                <table class="tablaFiltroReporte" cellpadding="0" cellspacing="0">
                    <thead>
                        <tr>
                            <td colspan="3">Introduzca los parametros del reporte</td>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td class="outputTextBold">Estado Producto</td>
                            <td class="outputTextBold">::</td>
                            <td>
                                <select class="inputText" value="0" name="codEstadoProducto" onclick="ajaxProducto();" id="codEstadoProducto">
                                    <option value="0" selected >Todos</option>
                                    <option value=1>Activos</option>
                                    <option value=2>Inactivos</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td class="outputTextBold">Presentación</td>
                            <td class="outputTextBold">::</td>
                            <td id="presentacion">
                                <%
                                    Connection con=null;
                                    try
                                    {
                                        String consulta=" select cod_presentacion,nombre_producto_presentacion"+
                                                        " from PRESENTACIONES_PRODUCTO"+
                                                        " order by nombre_producto_presentacion asc";
                                        con=Util.openConnection(con);
                                        Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                        ResultSet res=st.executeQuery(consulta);
                                        out.println("<select id='codPresentacion' multiple='true' name='codPresentacion' class='inputText'>");
                                        while(res.next())
                                        {
                                            out.println("<option value=\" "+res.getString(1)+" \">"+res.getString(2)+"</option>");
                                        }
                                        out.println("</select>");
                                    }
                                    catch(Exception ex)
                                    {
                                        ex.printStackTrace();
                                    }
                                    finally
                                    {
                                        con.close();
                                    }
                                    
                                    
                                %>
                            </td>
                        </tr>
                        <%--tr>
                            <td class="outputTextBold">Trimestre</td>
                            <td class="outputTextBold">::</td>
                            <td id="trimestre">
                                <%
                                            consulta="select trc.COD_TRIMESTRE_REPORTE_CONSOLIDADO,trc.DESCRIPCION"+
                                                     " from TRIMESTRE_REPORTE_CONSOLIDADO trc"+
                                                     " order by trc.COD_TRIMESTRE_REPORTE_CONSOLIDADO";
                                            res=st.executeQuery(consulta);
                                            out.println("<select id='codTrimestreReporteConsolidado' name='codTrimestreReporteConsolidado' class='inputText'>");
                                            while(res.next())
                                            {
                                                out.println("<option value=\" "+res.getString(1)+" \">"+res.getString(2)+"</option>");
                                            }
                                            out.println("</select>");
                                    }
                                    catch(Exception ex)
                                    {
                                        ex.printStackTrace();
                                    }
                                    finally
                                    {
                                        con.close();
                                    }
                                %>
                            </td>
                        </tr--%>
                        <tr>
                            <td class="outputTextBold">Fecha Inicio</td>
                            <td class="outputTextBold">::</td>
                            <td>
                                <input type="text" class="inputText" size="16"  value="" name="fechaInicio" id="fechaInicio" >
                                <img id="imagenFecha1" src="../../img/fecha.bmp">
                                <DLCALENDAR tool_tip="Seleccione la Fecha"
                                            daybar_style="background-color: DBE1E7; 
                                            font-family: verdana; color:000000;"navbar_style="background-color: 7992B7; color:ffffff;" 
                                            input_element_id="fechaInicio" click_element_id="imagenFecha1">
                                            </DLCALENDAR>            
                            </td>
                        </tr>  
                        <tr >
                            <td class="outputTextBold">Fecha Final</td>
                            <td class="outputTextBold">::</td>
                            <td>
                                <input type="text" class="inputText" size="16"  value="" name="fechaFinal" id="fechaFinal">
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
                                <input type="submit"   class="btn" onclick="if(!verificarDatos()){return false;}" value="Ver Reporte" name="btnVerReporte"/>
                                <input type="reset"   class="btn"  value="Limpiar" name="limpiar"/>
                            </td>
                        </tr>
                        
                    </tfoot>
                </table>
            </div>
        </form>
        <script type="text/javascript" language="JavaScript"  src="../../js/dlcalendar.js"></script>
    </body>
</html>