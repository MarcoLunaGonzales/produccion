



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
        <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
        <script src="../js/general.js"></script>
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
        <h3 align="center">Reporte Proveedores por Material</h3>

        <form method="post" action="navegadorReporteProveedores.jsp" target="_blank">
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
                        <td class="border">Proveedores</td>
                        <td class="border">::</td>
                        <%
        try {
            con = Util.openConnection(con);
            System.out.println("con:::::::::::::" + con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            String sql = "select p.COD_PROVEEDOR,p.NOMBRE_PROVEEDOR from PROVEEDORES p";
            sql += " where p.COD_ESTADO_REGISTRO=1 order by p.NOMBRE_PROVEEDOR";
            sql += "";
            System.out.println("sql Proveedores:" + sql);
            ResultSet rs = st.executeQuery(sql);
                        %>
                        <td class="border">
                            <select name="codProveedor" class="outputText3" >
                                <option value="0">Todos</option>
                                <%
                            String codProveedor = "";
                            String nombreProveedor = "";
                            while (rs.next()) {
                                codProveedor = rs.getString("COD_PROVEEDOR");
                                nombreProveedor = rs.getString("NOMBRE_PROVEEDOR");
                                %>
                                <option value="<%=codProveedor%>"><%=nombreProveedor%></option>
                                <%
                            }%>
                            </select>
                        </td>
                    </tr>
                    <tr class="outputText3">
                        <td class="border">Capítulo</td>
                        <td class="border">::</td>
                        <%
                            st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                            sql = " select c.COD_CAPITULO,c.NOMBRE_CAPITULO from  CAPITULOS c where c.COD_CAPITULO in (2,3,4)";
                            sql += " and c.COD_ESTADO_REGISTRO=1  order by c.NOMBRE_CAPITULO";

                            System.out.println("sql Capitulos:" + sql);
                            rs = st.executeQuery(sql);
                        %>
                        <td class="border">
                            <select name="codCapitulo" class="outputText3" >
                                <option value="0">               Todos                </option>
                                <%
                            String codGrupo = "";
                            String nombreGrupo = "";
                            while (rs.next()) {
                                codGrupo = rs.getString("COD_CAPITULO");
                                nombreGrupo = rs.getString("NOMBRE_CAPITULO");
                                %>
                                <option value="<%=codGrupo%>"><%=nombreGrupo%></option>
                                <%
                            }%>
                            </select>
                            <%

        } catch (Exception e) {
        }
                            %>
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