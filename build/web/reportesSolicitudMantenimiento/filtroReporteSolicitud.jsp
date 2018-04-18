

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
        <h3 align="center">Reporte Solicitud de Mantenimiento </h3>
        
        <form method="post" action="navegadorReporteSolicitud.jsp" target="_blank">
            <div align="center">
                <table border="0"  border="0" class="tablaFiltroReporte" width="55%" style="border : solid #f3f3f3 1px;">
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
                            sql += " where av.COD_AREA_FABRICACION = ae.cod_area_empresa" +
                                   " union all select a.cod_area_empresa,a.nombre_area_empresa from areas_empresa a where a.cod_area_empresa in(86,59) ";
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
                        <td >Maquinaria</td>
                        <td>::</td>
                        <%
                        try {
                            con = Util.openConnection(con);
                            System.out.println("con:::::::::::::" + con);
                            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                            String sql = " select m.COD_MAQUINA,m.NOMBRE_MAQUINA,m.CODIGO from MAQUINARIAS m order by m.NOMBRE_MAQUINA ";

                            System.out.println("Maquinaria:" + sql);
                            ResultSet rs = st.executeQuery(sql);
                        %>
                        <td>
                            <select name="codMaquinaria" class="outputText3" >
                                <option value="0">Seleccione una opción</option>
                                <%
                                String codMaquinaria = "";
                                String nombremaquinaria = "";
                                while (rs.next()) {
                                    codMaquinaria = rs.getString("COD_MAQUINA");
                                    nombremaquinaria = rs.getString("NOMBRE_MAQUINA")+" "+rs.getString("CODIGO");
                                %>
                                <option value="<%=codMaquinaria%>"><%=nombremaquinaria%></option>
                                <%
                                }%>
                            </select>
                            <%
                            
                            } catch (Exception e) {
                            }
                            %>
                        </td>
                    </tr>
                   <tr class="outputText2" >
                        <td >Estado Solicitud</td>
                        <td>::</td>
                        <%
                        try {
                            con = Util.openConnection(con);
                            System.out.println("con:::::::::::::" + con);
                            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                            String sql = " select e.COD_ESTADO_SOLICITUD,e.NOMBRE_ESTADO_SOLICITUD from ESTADOS_SOLICITUD_MANTENIMIENTO e order by e.NOMBRE_ESTADO_SOLICITUD ";

                            System.out.println("Maquinaria:" + sql);
                            ResultSet rs = st.executeQuery(sql);
                        %>
                        <td>
                            <select name="codEstado" class="outputText3" >
                                <option value="0">Seleccione una opción</option>
                                <%
                                String codEstado = "";
                                String nombreEstado = "";
                                while (rs.next()) {
                                    codEstado = rs.getString("COD_ESTADO_SOLICITUD");
                                    nombreEstado = rs.getString("NOMBRE_ESTADO_SOLICITUD");
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
                   <tr class="outputText2" >
                        <td >Tipo Solicitud Mantenimiento</td>
                        <td>::</td>
                        <%
                        try {
                            con = Util.openConnection(con);
                            System.out.println("con:::::::::::::" + con);
                            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                            String sql = " select cod_tipo_solicitud,nombre_tipo_solicitud from tipos_solicitud_mantenimiento ";

                            System.out.println("Maquinaria:" + sql);
                            ResultSet rs = st.executeQuery(sql);
                        %>
                        <td>
                            <select name="codTipoSolicitud" class="outputText3" >
                                <option value="0">Seleccione una opción</option>
                                <%
                                String codTipoSolicitudMantenimiento = "";
                                String nombreTipoSolicitudMantenimiento = "";
                                while (rs.next()) {
                                    codTipoSolicitudMantenimiento = rs.getString("COD_TIPO_SOLICITUD");
                                    nombreTipoSolicitudMantenimiento = rs.getString("NOMBRE_TIPO_SOLICITUD");
                                %>
                                <option value="<%=codTipoSolicitudMantenimiento%>"><%=nombreTipoSolicitudMantenimiento%></option>
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
                    <tr class="outputText3">
                        <td>Desde</td>
                        <td>::</td>
                        <td>
                            <input type="text" class="outputText3" size="16"  value="" name="fechaInicio" id="fechaInicio">
                            <img id="imagenFechaInicio" src="../img/fecha.bmp">
                            <DLCALENDAR tool_tip="Seleccione la Fecha"
                                        daybar_style="background-color: DBE1E7;
                                        font-family: verdana; color:000000;"navbar_style="background-color: 7992B7; color:ffffff;"
                                        input_element_id="fechaInicio" click_element_id="imagenFechaInicio">
                            </DLCALENDAR>

                        </td>
                    </tr>
                    <tr class="outputText3">
                        <td>Hasta</td>
                        <td>::</td>
                        <td>
                            <input type="text" class="outputText3" size="16"  value="" name="fechaFinal" id="fechaFinal" >
                            <img id="imagenFechaFinal" src="../img/fecha.bmp">
                            <DLCALENDAR tool_tip="Seleccione la Fecha"
                                        daybar_style="background-color: DBE1E7;
                                        font-family: verdana; color:000000;"navbar_style="background-color: 7992B7; color:ffffff;"
                                        input_element_id="fechaFinal" click_element_id="imagenFechaFinal">
                            </DLCALENDAR>

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