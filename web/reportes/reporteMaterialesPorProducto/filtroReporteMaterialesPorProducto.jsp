

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


<html>
    <head>
        <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
        <script src="../../js/general.js"></script>
        <script>
            function enviarDatos()
            {
                var areaEmpresaSelect=document.getElementById("areaEmpresa").options;
                var codAreaEmpresa=new Array();
                var nombreAreaEmpresa=new Array();
                for(var i=0;i<areaEmpresaSelect.length;i++)
                {
                    if(areaEmpresaSelect[i].selected)
                    {
                        codAreaEmpresa.push(areaEmpresaSelect[i].value);
                        nombreAreaEmpresa.push(areaEmpresaSelect[i].innerHTML);
                    }
                }
                var tipoProduccion=document.getElementById("tipoProduccion").options;
                var codTipoProduccion=new Array();
                var nombreTipoProduccion=new Array();
                for(var i=0;i<tipoProduccion.length;i++)
                {
                    if(tipoProduccion[i].selected)
                    {
                        codTipoProduccion.push(tipoProduccion[i].value);
                        nombreTipoProduccion.push(tipoProduccion[i].innerHTML);
                    }
                }
                
                
                document.getElementById("codAreaEmpresa").value=codAreaEmpresa;
                document.getElementById("nombreAreaEmpresa").value=nombreAreaEmpresa;
                document.getElementById("codTipoProduccion").value=codTipoProduccion;
                document.getElementById("nombreTipoProduccion").value=nombreTipoProduccion;
                if(parseInt(document.getElementById("codTipoReporte").value)==1)
                {
                    document.getElementById("formRMP").action='reporteMaterialesPorProducto.jsf';
                }
                else
                {
                    document.getElementById("formRMP").action='reporteProductosPorMaterial.jsf';
                }
                if(codAreaEmpresa.length==0)
                {
                    alert('No selecciono el area empresa');
                    return false;
                }
                if(codTipoProduccion.length==0)
                {
                    alert('No selecciono el tipo de Producto');
                    return false;
                }
                
                document.getElementById("formRMP").submit();
                    
                
            }

        </script>
    </head>
    <body><br><br>
        <span class="outputTextTituloSistema">Reporte Materiales Por Producto</span>

        <form method="post" action="reporteMaterialesPorProducto.jsf" id="formRMP" target="_blank">
            <div align="center">
                <table border="0"  border="0" cellpading="0" cellspacing="0" class="tablaFiltroReporte" width="50%">
                    <thead>
                        <tr>
                            <td colspan="3">
                                Datos del filtro
                            </td>
                        </tr>
                    </thead>
                    <tbody>
                            <%
                                    out.println("<tr>");
                                        out.println("<td class='outputTextBold'>Area Fabricación</td>");
                                        out.println("<td class='outputTextBold'>::</td>");
                                Connection con=null;
                                try 
                                {
                                        con = Util.openConnection(con);
                                        Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                                        StringBuilder consulta=new StringBuilder("SELECT ae.COD_AREA_EMPRESA,ae.NOMBRE_AREA_EMPRESA");
                                                                    consulta.append(" FROM AREAS_EMPRESA ae");
                                                                    consulta.append(" where ae.COD_AREA_EMPRESA in (80,81,82,95)");
                                                                    consulta.append(" order by ae.NOMBRE_AREA_EMPRESA");
                                        ResultSet res = st.executeQuery(consulta.toString());
                                        out.println("<td>");
                                            out.println("<select multiple id='areaEmpresa' class='inputText'>");
                                            while(res.next())
                                            {
                                                out.println("<option value='"+res.getInt("COD_AREA_EMPRESA")+"'>"+res.getString("NOMBRE_AREA_EMPRESA")+"</option>");
                                            }
                                            out.println("</select>");
                                        out.println("</td>");
                                    out.println("</tr>");    
                                    out.println("<tr>");
                                        out.println("<td class='outputTextBold'>Tipo de Producto</td>");
                                        out.println("<td class='outputTextBold'>::</td>");
                                        out.println("<td>");
                                            out.println("<select multiple id='tipoProduccion' class='inputText' size='3'>");
                                                out.println("<option value='1'>PRODUCCION</option>");
                                                out.println("<option value='2'>DESARROLLO</option>");
                                                out.println("<option value='3'>ESTANDARIZACION</option>");
                                            out.println("</select>");
                                        out.println("</td>");
                                    out.println("</tr>");
                                }
                                catch(SQLException ex)
                                {
                                    ex.printStackTrace();
                                }
                                catch(Exception e)
                                {
                                    e.printStackTrace();
                                }
                                finally
                                {
                                    con.close();
                                }
                            %>
                        <tr>
                            <td class="outputTextBold">Tipo Reporte</td>
                            <td class="outputTextBold">::</td>
                            <td>
                                <select id="codTipoReporte" class="inputText">
                                    <option value="1">Detallado</option>
                                    <option value="2">Detallado PDF</option>
                                </select>
                            </td>
                        </tr>    
                        <tr>
                            <td colspan="3" style="text-align: center">
                                <a onclick="enviarDatos()"   class="btn"  >Ver Reporte</a>
                            </td>
                        </tr>
                    </tbody>
                </table>
            <input type="hidden" id="codAreaEmpresa" name="codAreaEmpresa"/>
            <input type="hidden" id="nombreAreaEmpresa" name="nombreAreaEmpresa"/>
            <input type="hidden" id="codTipoProduccion" name="codTipoProduccion"/>
            <input type="hidden" id="nombreTipoProduccion" name="nombreTipoProduccion"/>
            <input type="hidden" id="codEstadoCompProd" name="codEstadoCompProd"/>
            <input type="hidden" id="nombreEstadoCompProd" name="nombreEstadoCompProd"/>
        </form>
    </body>
</html>