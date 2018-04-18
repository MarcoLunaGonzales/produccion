

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
        <h3 align="center">Reporte Control de Calidad</h3>

        <form method="post" action="reporteControlCalidad.jsp" target="_blank">
            <div align="center">
                <table border="0"  border="0" class="tablaFiltroReporte" width="50%">
                    <tr class="headerClassACliente">
                        <td  colspan="3" >
                            <div class="outputText3" align="center">
                                Introduzca Datos
                            </div>
                        </td>

                    </tr>
                    <tr class="outputText3">
                        <td >Lotes</td>
                        <td >::</td>
                        <%
        try {
            con = Util.openConnection(con);
            System.out.println("con:::::::::::::" + con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            String sql = "select COD_LOTE from RESULTADO_ANALISIS";
            ResultSet rs = st.executeQuery(sql);
                        %>
                        <td >
                            <select name="codLote" class="outputText3" >
                                <option value="0">Todos</option>
                                <%
                            String codProveedor = "";
                            String nombreProveedor = "";
                            while (rs.next()) {
                                codProveedor = rs.getString("COD_LOTE");
                                nombreProveedor = rs.getString("COD_LOTE");
                                %>
                                <option value="<%=codProveedor%>"><%=nombreProveedor%></option>
                                <%
                            }
                            }
                            catch(SQLException ex)
                            {
                                ex.printStackTrace();
                            }
                            %>
                            </select>
                        </td>
                    </tr>
                  
                </table>

            </div>
            <br>
            <center>
                <input type="submit"   class="commandButton" size="35" value="Ver Reporte" name="reporte" >

            </center>
        </form>
        <script type="text/javascript" language="JavaScript"  src="../js/dlcalendar.js"></script>
    </body>
</html>