

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
        <h3 align="center">Reporte Programa Producción</h3>
        
        <form method="post" action="navegadorReporteProductos.jsp" target="_blank">
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
                        <td class="">Estado Producto</td>
                        <td class="">::</td>
                        <%
                        try {
                            con = Util.openConnection(con);
                            System.out.println("con:::::::::::::" + con);
                            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                            String sql="select cod_estado_prod,nombre_estado_prod from estados_producto where cod_estado_registro=1";
                            System.out.println("sql filtro:" + sql);
                            ResultSet rs = st.executeQuery(sql);
                        %>
                        <td class="">
                            <select name="codEstado" class="outputText3" >
                                <option value="0">Seleccione una opción</option>
                                <%
                                String codEstado = "";
                                String nombreEstado= "";
                                while (rs.next()) {
                                    codEstado = rs.getString("cod_estado_prod");
                                    nombreEstado = rs.getString("nombre_estado_prod");
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