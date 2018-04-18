
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


<%! Connection con = null;
%>
<%
//con=CofarConnection.getConnectionJsp();
con = Util.openConnection(con);

%>


<html>
    <head>
        <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
        <script src="../../js/general.js"></script>
        <script>
            function cancelar(){
                // alert(codigo);
                location='../personal_jsp/navegador_personal.jsf';
            }
            function cargarAlmacen(f){
                var codigo=f.codAreaEmpresa.value;
                location.href="filtroReporteExistencias.jsp?codArea="+codigo;
            }

        </script>
    </head>
    <body><br><br>
        <h3 align="center">Reporte Programa Producción</h3>
        
        <form method="post" action="navegadorReportePrograma.jsp" target="_blank">
            <div align="center">
                <table border="0"  border="0" class="tablaFiltroReporte" width="40%" style="border : solid #f3f3f3 1px;">
                    <tr class="headerClassACliente">
                        <td  colspan="3" >
                            <div class="outputText2" align="center">
                                Introduzca Datos
                            </div>
                        </td>
                        
                    </tr>
                    <tr class="outputText2">
                        <td >Area de Fabricación</td>
                        <td>::</td>
                        <%
                        try {
                            con = Util.openConnection(con);
                            System.out.println("con:::::::::::::" + con);
                            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                            String sql = "select av.COD_AREA_FABRICACION,ae.nombre_area_empresa ";
                            sql += " from areas_fabricacion av,areas_empresa ae  ";
                            sql += " where av.COD_AREA_FABRICACION = ae.cod_area_empresa  ";
                            System.out.println("Areas Fabricacion:" + sql);
                            ResultSet rs = st.executeQuery(sql);
                        %>
                        <td>
                            <select name="codAreaEmpresa" class="outputText3" >
                                <option value="0">Seleccione una opción</option>
                                <%
                                String codAreaEmpresa = "";
                                String nombreAreaEmpresa = "";
                                while (rs.next()) {
                                    codAreaEmpresa = rs.getString("COD_AREA_FABRICACION");
                                    nombreAreaEmpresa = rs.getString("nombre_area_empresa");
                                %>
                                <option value="<%=codAreaEmpresa%>"><%=nombreAreaEmpresa%></option>
                                <%
                                }%>
                            </select>
                            <%
                            
                            } catch (Exception e) {
                            }
                            %>
                        </td>
                    </tr>
                    <tr class="outputText2">
                        <td >Tipo de Mercadería</td>
                        <td>::</td>
                        <td>
                            <select name="tipo_mercaderia" class="outputText3" >
                                <option value="0">MERCADERÍA CORRIENTE</option>
                                <option value="1">MUESTRA MÉDICA</option>
                            </select>
                        </td>
                    </tr>
                    <tr class="outputText2">
                        <td >Trimestral</td>
                        <td>::</td>
                        <td>
                            <select name="trimestral" class="outputText3" >
                                <option value="0">NORMAL</option>
                                <option value="1">TRIMESTRAL</option>
                            </select>
                        </td>
                    </tr>
                 
                    <tr class="outputText2">
                        <td >A fecha
                        </td>
                        <td >::</td>
                        <td >
                            <input type="text"  size="12"  value="" name="fecha_inicio" id="fecha_inicio" class="inputText">
                            <img id="imagenFecha1" src="../../img/fecha.bmp">
                            <DLCALENDAR tool_tip="Seleccione la Fecha"
                                        daybar_style="background-color: DBE1E7;
                                        font-family: verdana; color:000000;"navbar_style="background-color: 7992B7; color:ffffff;"
                                        input_element_id="fecha_inicio"; click_element_id="imagenFecha1">
                             </DLCALENDAR>
                        </td>
                    </tr>
                    <tfoot>
                        <tr>
                            <td colspan="3">
                                <input type="submit"   class="btn" size="35" value="Ver Reporte" name="reporte" >
                            </td>
                        </tr>
                    </tfoot>
                </table>
            </div>
            <br>
            <center>
                
                
            </center>
        </form>
        <script type="text/javascript" language="JavaScript"  src="../../js/dlcalendar.js"></script>
    </body>
</html>