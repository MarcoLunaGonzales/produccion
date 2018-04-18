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
<%@ page errorPage="ExceptionHandler.jsp" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<html>
    <head>
        <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
        <script src="../js/general.js"></script>
        <script type="text/javascript">
            function verReporteRap()
            {
                var codigosProducto=new Array();
                var selectProducto=document.getElementById("codCompProd");
                for(var i=0;i<selectProducto.options.length;i++)
                {
                    if(selectProducto.options[i].selected)
                    {
                        codigosProducto.push(selectProducto.options[i].value);
                    }
                }
                window.open("reporteRap2015.jsf?codigosProducto="+encodeURIComponent(codigosProducto)+
                            "&fechaInicio="+encodeURIComponent(document.getElementById("fechaInicio").value)+
                            "&fechaFinal="+encodeURIComponent(document.getElementById("fechaFinal").value)+
                            "&data="+(new Date()).getTime().toString(),'detalle'+Math.round((Math.random()*1000)),'top=50,left=200,width=800,height=600,scrollbars=1,resizable=1');
            }
        </script>
    </head>
    <body><br><br>
        <h3 align="center">Reporte RAP 2015</h3>

        <form method="post" action="reporteProgramaProduccionEstados.jsp" target="_blank" name="form1">
            <div align="center">
                <table border="0"  border="0" cellpadding="0" cellspacing="0" class="tablaFiltroReporte" width="50%">
                    <thead>
                        <tr >
                            <td colspan="3" >
                                Introduzca Datos
                            </td>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td class="outputTextBold">Producto</td>
                            <td class="outputTextBold">::</td>
                            <td>
                                <select id="codCompProd" class="inputText" multiple style="height:10em">
                                    <%
                                        Connection con=null;
                                        con=Util.openConnection(con);
                                        StringBuilder consulta=new StringBuilder("select c.COD_COMPPROD,c.nombre_prod_semiterminado");
                                                                consulta.append(" from COMPONENTES_PROD c");
                                                                consulta.append(" where c.COD_TIPO_PRODUCCION=1");
                                                                    consulta.append(" and c.COD_ESTADO_COMPPROD=1");
                                                                consulta.append(" order by c.nombre_prod_semiterminado");
                                        Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                        ResultSet res=st.executeQuery(consulta.toString());
                                        while(res.next())
                                        {
                                            out.println("<option value='"+res.getInt("COD_COMPPROD")+"'>"+res.getString("nombre_prod_semiterminado")+"</option>");
                                        }
                                        Date fecha=new Date();
                                        fecha.setYear(fecha.getYear()-1);
                                        SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy");
                                        con.close();
                                    %>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td class="outputTextBold">Fecha Inicio</td>
                            <td class="outputTextBold">::</td>
                            <td>
                                <input id="fechaInicio" type="text"  size="12"  value="<%=(sdf.format(fecha))%>" name="fechaInicio" id="fechaInicio" class="inputText">
                                <img id="imagenFecha1" src="../../img/fecha.bmp">
                                <DLCALENDAR tool_tip="Seleccione la Fecha"
                                            daybar_style="background-color: DBE1E7;
                                            font-family: verdana; color:000000;"navbar_style="background-color: 7992B7; color:ffffff;"
                                            input_element_id="fechaInicio" click_element_id="imagenFecha1">
                                </DLCALENDAR>
                            </td>
                        </tr>
                        <%
                        fecha=new Date();
                        %>
                        <tr>
                            <td class="outputTextBold">Fecha Final</td>
                            <td class="outputTextBold">::</td>
                            <td>
                                <input id="fechaFinal" type="text"  size="12"  value="<%=(sdf.format(fecha))%>" name="fechaFinal" id="fechaFinal" class="inputText">
                                <img id="imagenFechaFinal" src="../../img/fecha.bmp">
                                <DLCALENDAR tool_tip="Seleccione la Fecha"
                                            daybar_style="background-color: DBE1E7;
                                            font-family: verdana; color:000000;"navbar_style="background-color: 7992B7; color:ffffff;"
                                            input_element_id="fechaFinal" click_element_id="imagenFechaFinal">
                                </DLCALENDAR>
                            </td>
                        </tr>
                    </tbody>
                    <tfoot>
                        <tr>
                            <td colspan="3">
                                <a class="btn" onclick="verReporteRap()">Ver Reporte</a>
                            </td>
                        </tr>
                    </tfoot>
                    

                </table>

            </div>

        </form>
        <script type="text/javascript" language="JavaScript"  src="../../js/dlcalendar.js"></script>
    </body>
</html>