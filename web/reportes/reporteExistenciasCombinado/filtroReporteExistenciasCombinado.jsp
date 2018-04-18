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
        <h3 align="center">Reporte Existencias Combinado</h3>
        
        <form method="post" action="navegadorReporteExistenciasCombinado.jsp" target="_blank" name="form1">
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
                                <option value="1">MERCADERÍA CORRIENTE</option>
                                <option value="5">MUESTRA MÉDICA</option>
                            </select>
                        </td>
                    </tr>



                    <tr class="outputText3" >
                        <td class="">Almacen de Productos Terminados</td>
                        <td class="">::</td>
                        <%
        try {
            con = Util.openConnection(con);
            System.out.println("con:::::::::::::" + con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            String sql = " SELECT A.COD_ALMACEN_VENTA,A.NOMBRE_ALMACEN_VENTA,A.COD_AREA_EMPRESA FROM ALMACENES_VENTAS A WHERE A.COD_AREA_EMPRESA=1; ";

            System.out.println("sql filtro:" + sql);
            ResultSet rs = st.executeQuery(sql);
                        %>

                        <td class="">                            
                            <select name="codAlmacenVenta" size="10" class="inputText" multiple onchange="almacenVenta_change(form1)">
                                <%
                            String codAlmacenVenta = "";
                            String nombreAlmacenVenta= "";
                            while (rs.next()) {
                                codAlmacenVenta = "'"+rs.getString("COD_ALMACEN_VENTA")+"'";
                                nombreAlmacenVenta = rs.getString("NOMBRE_ALMACEN_VENTA");
                                %>
                                <option value="<%=codAlmacenVenta%>"><%=nombreAlmacenVenta%></option>
                                <%
                            }%>
                            </select>
                            <input type="checkbox"  onclick="seleccionarTodoAlmacen(form1)" name="chk_todoAlmacen" >Todo
                            <%

        } catch (Exception e) {
        }
                            %>
                        </td>
                    </tr>
                 
                    <tr class="outputText2">
                        <td >A fecha
                        </td>
                        <td >::</td>
                        <td >
                            <input type="text"  size="12"  value="" name="fechaInicio" id="fechaInicio" class="inputText">
                            <img id="imagenFecha1" src="../../img/fecha.bmp">
                            <DLCALENDAR tool_tip="Seleccione la Fecha"
                                        daybar_style="background-color: DBE1E7;
                                        font-family: verdana; color:000000;"navbar_style="background-color: 7992B7; color:ffffff;"
                                        input_element_id="fechaInicio" click_element_id="imagenFecha1">
                             </DLCALENDAR>
                        </td>
                    </tr>
                </table>
            </div>
            <br>
            <center>
                <input type="submit"  onclick="verReporteExistenciasCombinado(form1)" class="commandButton" size="35" value="Ver Reporte" name="reporte" >
                
            </center>
            <input type="hidden" name="codAlmacenVentaArray">
        </form>
        <script type="text/javascript" language="JavaScript"  src="../../js/dlcalendar.js"></script>
    </body>
</html>