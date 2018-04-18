<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ page language="java" %>
<%@ page import="com.cofar.util.*" %>
<%@ page import="com.cofar.web.*" %>
<%@ page import = "java.sql.Connection"%>
<%@ page import = "java.sql.DriverManager"%>
<%@ page import = "java.sql.ResultSet"%>
<%@ page import = "java.sql.Statement"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.text.SimpleDateFormat"%>
<%@ page import = "java.util.ArrayList"%>
<%@ page import = "java.util.Date"%>
<%@ page import = "javax.servlet.http.HttpServletRequest"%>
<%@ page import = "java.text.DecimalFormat"%>
<%@ page import = "java.text.NumberFormat"%>
<%@ page import = "java.util.Locale"%>
<%@ page language="java" import="java.util.*,com.cofar.util.CofarConnection" %>


<%! Connection con = null;
String codPresentacion = "";
String nombrePresentacion = "";
String linea_mkt = "";
String agenciaVenta = "";
%>
<%! public String nombrePresentacion1() {



    String nombreproducto = "";
//ManagedAccesoSistema bean1=(ManagedAccesoSistema)com.cofar.util.Util.getSessionBean("ManagedAccesoSistema");
    try {
        con = Util.openConnection(con);
        String sql_aux = "select cod_presentacion, nombre_producto_presentacion from presentaciones_producto where cod_presentacion='" + codPresentacion + "'";
        System.out.println("PresentacionesProducto:sql:" + sql_aux);
        Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        ResultSet rs = st.executeQuery(sql_aux);
        while (rs.next()) {
            String codigo = rs.getString(1);
            nombreproducto = rs.getString(2);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return nombreproducto;
}
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
        <script src="../../js/general.js"></script>
    </head>
    <body>
        <form>
            <h4 align="center">Reporte Frecuencias Mantenimiento</h4>

                    <%
                    try {

                /*
                         <input type="hidden" name="codProgramaProduccionPeriodo">
                        <input type="hidden" name="codCompProd">
                        <input type="hidden" name="nombreCompProd">
                        */

                        NumberFormat numeroformato = NumberFormat.getNumberInstance(Locale.ENGLISH);
                        DecimalFormat formato = (DecimalFormat) numeroformato;
                        formato.applyPattern("#,###.##;(#,###.##)");

                        SimpleDateFormat format=new SimpleDateFormat("dd/MM/yyyy");

                        con = Util.openConnection(con);

                        String codProgramaProdPeriodo=request.getParameter("codProgramaProduccionPeriodo")==null?"''":request.getParameter("codProgramaProduccionPeriodo");
                        String arrayCodCompProd = request.getParameter("codCompProdArray")==null?"''":request.getParameter("codCompProdArray");
                        String nombreProgramaProduccionPeriodo = request.getParameter("nombreProgramaProduccionPeriodo")==null?"''":request.getParameter("nombreProgramaProduccionPeriodo");
                        arrayCodCompProd = arrayCodCompProd + (arrayCodCompProd.length()==0?"' '":"");


                        System.out.println("los datos de peticion para el reporte : "+request.getParameter("codAreaEmpresaP"));
                        System.out.println(request.getParameter("nombreAreaEmpresaP"));

                        System.out.println(request.getParameter("desdeFechaP"));
                        System.out.println(request.getParameter("hastaFechaP"));

                        String arrayCodAreaEmpresa= request.getParameter("codAreaEmpresaP");
                        String arrayNombreAreaEmpresa= request.getParameter("nombreAreaEmpresaP");

                        String desdeFecha=request.getParameter("desdeFechaP");
                        String hastaFecha=request.getParameter("hastaFechaP");


                        String codEstadoProgramaProduccion=request.getParameter("codEstadoPrograma");
                        /* String arraydesde[]=desdeFecha.split("/");
                         desdeFecha=arraydesde[2] +"/"+ arraydesde[1]+"/"+arraydesde[0];

                         String arrayhasta[]=hastaFecha.split("/");
                         hastaFecha=arrayhasta[2]+"/"+arrayhasta[1]+"/"+arrayhasta[0];*/

                         //Double totalHoraInicio=0.0d;
                         //Double totalHoraFinal=0.0d;

                         Double totalHorasHombre=0.0d;
                         Double totalHorasMaquina=0.0d;

                         Double totalHorasHombreFormulaMaestra=0.0d;
                         Double totalHorasMaquinaFormulaMaestra=0.0d;

                         //1:todos , 2:con seguimiento, 3:sin seguimiento


                         String codTipoReporteSeguimientoProgramaProduccion=request.getParameter("codTipoReporteSeguimientoProgramaProduccion");

                         String codAreaEmpresaActividad=request.getParameter("codAreaEmpresaActividad")==null?"0":request.getParameter("codAreaEmpresaActividad");
                         String codTipoReporteDetallado = request.getParameter("codTipoReporteDetallado")==null?"0":request.getParameter("codTipoReporteDetallado");
                         //System.out.println("el parametro de detalle "+codTipoReporteDetallado);

                         //System.out.println("las fechas en el reporte" + desdeFecha + " " +hastaFecha );


                    %>

                    <%--
            <div class="outputText0" align="center">
                PROGRAMA PRODUCCION: <%= nombreProgramaProduccionPeriodo %> <br>
                AREA(S) : <%= arrayNombreAreaEmpresa %><br>
                DE <%= arraydesde[0] +"/"+ arraydesde[1]+"/"+arraydesde[2] %> <br>
                HASTA <%= arrayhasta[0] +"/"+ arrayhasta[1]+"/"+arrayhasta[2] %>
                <%--PRODUCTO<%=nombreComponenteProd%>--%>
                <%--
            </div--%>

            <br>
            <table width="70%" align="center" class="outputText0" style="border : solid #000000 1px;" cellpadding="0" cellspacing="0" >


                <tr class="">
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='20%' align="center" ><b>Codigo Areas</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='5%' align="center" ><b>Maquinaria</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='5%' align="center"><b>Fecha de Compra</b></td>
                    <td align="center" style="border : solid #D8D8D8 1px" class="border"  bgcolor="#f2f2f2" width='5%' align="center"><b>Tipo de Maquinaria</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='5%' align="center"><b>GMP</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='5%' align="center"><b>Descripcion</b></td>
                    <td align="center" style="border : solid #D8D8D8 1px" class="border"  bgcolor="#f2f2f2" width='5%' align="center"><b>Area Maquina</b></td>
                    <td align="center" style="border : solid #D8D8D8 1px" class="border"  bgcolor="#f2f2f2" width='5%' align="center"><b>Estado de Registro</b></td>
                    <td align="center" style="border : solid #D8D8D8 1px" class="border"  bgcolor="#f2f2f2" width='5%' align="center"><b>Tipo de Frecuencia - Horas</b></td>
                    <%--td align="center" style="border : solid #D8D8D8 1px" class="border"  bgcolor="#f2f2f2" width='5%' align="center"><b>Horas Maquina (Standard)</b></td--%>
                    
                    
                </tr>

                <%

                String consulta = " select m.COD_MAQUINA,m.CODIGO,m.NOMBRE_MAQUINA,m.FECHA_COMPRA,t.NOMBRE_TIPO_EQUIPO,m.GMP," +
                        " m.OBS_MAQUINA,a.NOMBRE_AREA_EMPRESA,e.NOMBRE_ESTADO_REGISTRO from maquinarias m inner join TIPOS_EQUIPOS_MAQUINARIA t on t.COD_TIPO_EQUIPO = m.COD_TIPO_EQUIPO " +
                         "inner join AREAS_EMPRESA a on a.COD_AREA_EMPRESA = m.COD_AREA_EMPRESA inner join ESTADOS_REFERENCIALES e on e.COD_ESTADO_REGISTRO = m.COD_ESTADO_REGISTRO " +
                         "where m.COD_ESTADO_REGISTRO = 1 "+(arrayCodAreaEmpresa.equals("-1")?"":"and m.COD_AREA_EMPRESA in("+arrayCodAreaEmpresa+") ");

                System.out.println("consulta 1 "+ consulta);
                con=Util.openConnection(con);
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rs = st.executeQuery(consulta);
                while (rs.next()) {
                    //System.out.println("consulta 1 "+ consulta);
                    String codMaquina= rs.getString("cod_maquina");
                    String codigo = rs.getString("codigo");
                    String nombreMaquina = rs.getString("nombre_maquina");
                    Date fechaCompra = rs.getDate("fecha_compra");
                    String nombreTipoEquipo = rs.getString("nombre_tipo_equipo");
                    String gmp = rs.getString("gmp");
                    String obsMaquina = rs.getString("obs_maquina");
                    String nombreAreaEmpresa = rs.getString("nombre_area_empresa");
                    String nombreEstadoRegistro = rs.getString("nombre_estado_registro");
                    out.print("<tr>");
                                out.print("<td align='right'  style='border : solid #f2f2f2 1px'  width='5%' ><b>"+codigo+"</b></td>");
                                out.print("<td align='left'  style='border : solid #f2f2f2 1px' ><b>"+nombreMaquina+"</b></td>");
                                out.print("<td align='left'  style='border : solid #f2f2f2 1px' >&nbsp;"+fechaCompra+"</td>");
                                out.print("<td align='left'  style='border : solid #f2f2f2 1px' >&nbsp;"+nombreTipoEquipo+"</td>");
                                out.print("<td align='left'  style='border : solid #f2f2f2 1px' >&nbsp;"+gmp+"</td>");
                                out.print("<td align='left'  style='border : solid #f2f2f2 1px' >&nbsp;"+(obsMaquina!=null?obsMaquina:"") +"</td>");
                                out.print("<td align='left'  style='border : solid #f2f2f2 1px' >&nbsp;"+(nombreAreaEmpresa!=null?nombreAreaEmpresa:"") +"</td>");
                                out.print("<td align='left'  style='border : solid #f2f2f2 1px' >&nbsp;"+nombreEstadoRegistro+"</td>");
                                out.print("<td align='left'  style='border : solid #f2f2f2 1px' >&nbsp;");
                                consulta = " select t.NOMBRE_TIPO_PERIODO,f.HORAS_FRECUENCIA from FRECUENCIAS_MANTENIMIENTO_MAQUINA f inner join TIPOS_PERIODO t on t.COD_TIPO_PERIODO = f.COD_TIPO_PERIODO " +
                                         "where f.COD_MAQUINA = '"+codMaquina+"' ";
                                Statement st1 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                                ResultSet rs1 = st1.executeQuery(consulta);
                                out.print("<table>");
                                while(rs1.next()){
                                    out.print("<tr><td align='left'  style='border : solid #f2f2f2 1px' >"+rs1.getString("nombre_tipo_periodo")+"</td>");
                                    out.print("<td align='left'  style='border : solid #f2f2f2 1px' >&nbsp;"+rs1.getFloat("horas_frecuencia")+"</td></tr>");
                                }
                                out.print("</table>");
                                out.print("</td>");
                                out.print("</tr>");
                    }
                %>
                




               
               </table>

                <%



                    } catch (Exception e) {
                        e.printStackTrace();
                    }

                %>
            <br>

            <br>
            <div align="center">
                <%--<INPUT type="button" class="commandButton" name="btn_registrar" value="<-- Atrás" onClick="cancelar();"  >--%>

            </div>
        </form>
    </body>
</html>