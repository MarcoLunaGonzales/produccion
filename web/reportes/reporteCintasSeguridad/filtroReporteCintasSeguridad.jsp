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
        <script src="../js/general.js"></script>
        <script>
            function cancelar(){
                // alert(codigo);
                location='../personal_jsp/navegador_personal.jsf';
            }
            function cargarAlmacen(f){
                var codigo=f.codAreaEmpresa.value;
                location.href="filtroReporteExistenciasCombinado.jsp?codArea="+codigo;
            }

            function seleccionarTodoAlmacen(f){
                for(var i=0;i<=f.codAlmacenVenta.options.length-1;i++)
                {
                    f.codAlmacenVenta.options[i].selected=f.chk_todoAlmacen.checked;
                }
            }
            function almacenVenta_change(f){
                f.chk_todoAlmacen.checked=false
            }

            function verReporteExistenciasCombinado(f){            
            var arrayCodAlmacenVenta=new Array();
            var j=0;            
            for(var i=0;i<=f.codAlmacenVenta.options.length-1;i++)
            {	if(f.codAlmacenVenta.options[i].selected){
                    arrayCodAlmacenVenta[j]=f.codAlmacenVenta.options[i].value;
                    j++;
                }
            }
            f.codAlmacenVentaArray.value=arrayCodAlmacenVenta;
            
            return true;

            }
        </script>
    </head>
    <body><br><br>
        <h3 align="center">Reporte Productos Enviados a Almacen de Acondicionamientos</h3>
        
        <form method="post" action="navegadorReporteProductosEnviadosProgramaProduccion.jsp" target="_blank" name="form1">
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
                        <td>Programa Produccion</td>
                        <td>::</td>
                        <%
                        try {
                            con = Util.openConnection(con);                            
                            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                            String sql = "SELECT PPRP.COD_PROGRAMA_PROD,PPRP.NOMBRE_PROGRAMA_PROD FROM PROGRAMA_PRODUCCION_PERIODO PPRP WHERE PPRP.COD_ESTADO_PROGRAMA IN (1,2,5) ";
                            ResultSet rs = st.executeQuery(sql);
                        %>
                        <td>
                            <select name="codProgramaProdPeriodo" class="outputText3" >                                
                                <%
                                String codProgramaProduccionPeriodo = "";
                                String nombreProgramaProduccionPeriodo = "";
                                while (rs.next()) {
                                    codProgramaProduccionPeriodo = rs.getString("COD_PROGRAMA_PROD");
                                    nombreProgramaProduccionPeriodo = rs.getString("NOMBRE_PROGRAMA_PROD");
                                %>
                                <option value="<%=codProgramaProduccionPeriodo%>"><%=nombreProgramaProduccionPeriodo%></option>
                                <%
                                }%>
                            </select>
                            <%
                            
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                            %>
                        </td>
                    </tr>
                </table>
            </div>
            <br>
            <center>
                <input type="submit" class="commandButton" size="35" value="Ver Reporte" name="reporte" >
                
            </center>
            <input type="hidden" name="codAlmacenVentaArray">
        </form>
        <script type="text/javascript" language="JavaScript"  src="../js/dlcalendar.js"></script>
    </body>
</html>