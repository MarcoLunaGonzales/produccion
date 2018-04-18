

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
        <h3 align="center">Reporte Presentaciones Producto</h3>
        
        <form method="post" action="navegadorReportePresentacionesProd.jsp" target="_blank">
            <div align="center">
                <table border="0"  border="0" class="border" width="50%">
                    <tr class="headerClassACliente">
                        <td  colspan="3" >
                            <div class="outputText3" align="center">
                                Introduzca Datos
                            </div>
                        </td>
                        
                    </tr>
                    <tr class="outputText3" >
                        <td class="">Lineas MKT</td>
                        <td class="">::</td>
                        <%
                        try {
                            con = Util.openConnection(con);
                            System.out.println("con:::::::::::::" + con);
                            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                            String sql = "select l.COD_LINEAMKT,l.NOMBRE_LINEAMKT from LINEAS_MKT l where l.COD_ESTADO_REGISTRO=1 order by l.NOMBRE_LINEAMKT";
                            System.out.println("sql lineas:" + sql);
                            ResultSet rs = st.executeQuery(sql);
                        %>
                        <td class="">
                            <select name="codLinea" class="outputText3" >
                                <option value="0">Seleccione una opción</option>
                                <%
                                String codLinea = "";
                                String nombreLinea = "";
                                while (rs.next()) {
                                    codLinea = rs.getString("COD_LINEAMKT");
                                    nombreLinea = rs.getString("NOMBRE_LINEAMKT");
                                %>
                                <option value="<%=codLinea%>"><%=nombreLinea%></option>
                                <%
                                }%>
                            </select>
                            <%
                            
                            } catch (Exception e) {
                            }
                            %>
                        </td>
                    </tr>
                    
                    <tr class="outputText3" >
                        <td class="">Tipo de Mercadería</td>
                        <td class="">::</td>
                        <%
                        try {
                            con = Util.openConnection(con);
                            System.out.println("con:::::::::::::" + con);
                            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                            String sql = "select t.cod_tipomercaderia,t.nombre_tipomercaderia from TIPOS_MERCADERIA t where t.cod_estado_registro=1 order by t.nombre_tipomercaderia";
                            System.out.println("sql lineas:" + sql);
                            ResultSet rs = st.executeQuery(sql);
                        %>
                        <td class="">
                            <select name="codTipo" class="outputText3" >
                                <option value="0">Seleccione una opción</option>
                                <%
                                String codTipo = "";
                                String nombreTipo= "";
                                while (rs.next()) {
                                    codTipo = rs.getString("cod_tipomercaderia");
                                    nombreTipo = rs.getString("nombre_tipomercaderia");
                                %>
                                <option value="<%=codTipo%>"><%=nombreTipo%></option>
                                <%
                                }%>
                            </select>
                            <%
                            
                            } catch (Exception e) {
                            }
                            %>
                        </td>
                    </tr>
                    <tr class="outputText3" >
                        <td class="">Estado </td>
                        <td class="">::</td>
                        <%
                        try {
                            con = Util.openConnection(con);
                            System.out.println("con:::::::::::::" + con);
                            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                            String sql = "select er.COD_ESTADO_REGISTRO, er.NOMBRE_ESTADO_REGISTRO from ESTADOS_REFERENCIALES er " +
                            " where er.cod_estado_registro <>3 order by er.NOMBRE_ESTADO_REGISTRO";
                            System.out.println("sql lineas:" + sql);
                            ResultSet rs = st.executeQuery(sql);
                        %>
                        <td class="">
                            <select name="codEstado" class="outputText3" >
                                <option value="0">Seleccione una opción</option>
                                <%
                                String codEstado = "";
                                String nombreEstado = "";
                                while (rs.next()) {
                                    codEstado = rs.getString("COD_ESTADO_REGISTRO");
                                    nombreEstado = rs.getString("NOMBRE_ESTADO_REGISTRO");
                                %>
                                <option value="<%=codEstado%>"><%=nombreEstado%></option>
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