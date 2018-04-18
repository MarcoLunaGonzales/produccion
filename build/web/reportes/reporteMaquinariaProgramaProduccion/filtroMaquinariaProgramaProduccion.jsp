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

            function verReporteMaquinariaProgramaProduccion(f){
            var arrayCodMaquinarias=new Array();
            var j=0;            
            for(var i=0;i<=f.codMaquinaria.options.length-1;i++)
            {	if(f.codMaquinaria.options[i].selected){
                    arrayCodMaquinarias[j]=f.codMaquinaria.options[i].value;                    
                    j++;
                }
            }
            f.arrayCodMaquinaria.value=arrayCodMaquinarias;
            return true;
            }
            function seleccionarTodoMaquinaria(f){
                for(var i=0;i<=f.codMaquinaria.options.length-1;i++)
                {
                    f.codMaquinaria.options[i].selected=f.chk_todoMaquinaria.checked;
                }
            }
        </script>
    </head>
    <body><br><br>
        <h3 align="center">Reporte Tiempos Standard por Maquinarias</h3>
        
        <form method="post" action="reporteMaquinariaProgramaProduccion.jsp" target="_blank" name="form1">
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
                        <td>Maquinarias</td>
                        <td>::</td>
                        <%
                        try {
                            con = Util.openConnection(con);                            
                            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                            String sql = " select maq.COD_MAQUINA,maq.NOMBRE_MAQUINA from MAQUINARIAS maq where  maq.COD_MAQUINA in(  " +
                                         " select maf.COD_MAQUINA from MAQUINARIA_ACTIVIDADES_FORMULA maf where maf.COD_ACTIVIDAD_FORMULA in( " +
                                         " select afm.COD_ACTIVIDAD_FORMULA from ACTIVIDADES_FORMULA_MAESTRA afm )) order by maq.NOMBRE_MAQUINA asc";
                            ResultSet rs = st.executeQuery(sql);
                        %>
                        <td>
                            <select name="codMaquinaria" size="15" class="inputText" multiple onchange="form1.chk_todoMaquinaria.checked=false;">
                                <%
                                String codMaquina = "";
                                String nombreMaquina = "";
                                while (rs.next()) {
                                    codMaquina = rs.getString("COD_MAQUINA");
                                    nombreMaquina = rs.getString("NOMBRE_MAQUINA");
                                %>
                                <option value="<%=codMaquina%>"><%=nombreMaquina%></option>
                                <%
                                }%>
                            </select>
                            <%
                            
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                            %>

                            <input type="checkbox"  onclick="seleccionarTodoMaquinaria(form1)" name="chk_todoMaquinaria" >Todo
                         </td>

                    </tr>
                </table>
            </div>
            <br>
            <center>

                <input type="submit" class="commandButton" size="35" value="Ver Reporte" name="reporte" onclick="verReporteMaquinariaProgramaProduccion(form1);" >
                
            </center>
            <input type="hidden" name="arrayCodMaquinaria">
        </form>
        <script type="text/javascript" language="JavaScript"  src="../js/dlcalendar.js"></script>
    </body>
</html>