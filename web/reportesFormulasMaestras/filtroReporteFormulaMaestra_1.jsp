

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
        <h3 align="center">Reporte Formulas Maestras</h3>

        <form method="post" action="navegadorReporteFormulaMaestra.jsp" target="_blank">
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
                        <td class="border">Area de Fabricación</td>
                        <td class="border">::</td>
                        <%
        try {
            con = Util.openConnection(con);
            System.out.println("con:::::::::::::" + con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            String sql = "select av.COD_AREA_FABRICACION,ae.nombre_area_empresa ";
            sql += " from areas_fabricacion av,areas_empresa ae ";
            sql += " where av.COD_AREA_FABRICACION=ae.cod_area_empresa ";
            System.out.println("sql filtro:" + sql);
            ResultSet rs = st.executeQuery(sql);
                        %>
                        <td class="border">
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

        
                            %>
                        </td>
                        <%
                        sql = " select t.cod_tipo_produccion,t.nombre_tipo_produccion from tipos_produccion t";
                        con = Util.openConnection(con);
                        %>
                        <td class="border">
                            <select name="codAreaEmpresa" class="outputText3" >
                                <option value="0">Seleccione una opción</option>
                                <%
                            String codTipoProduccion = "";
                            String nombreTipoProduccion = "";
                            while (rs.next()) {
                                codTipoProduccion = rs.getString("cod_tipo_produccion");
                                nombreTipoProduccion = rs.getString("nombre_tipo_produccion");
                                %>
                                <option value="<%=codTipoProduccion%>"><%=nombreTipoProduccion%></option>
                                <%
                            }%>
                            </select>
                            <%
                             } catch (Exception e) {
                             }
                        %>

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