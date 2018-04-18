
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

<%@ page language="java" import="java.util.*,com.cofar.util.CofarConnection" %>
<%@ page errorPage="ExceptionHandler.jsp" %>
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
            String sql_aux = "select m1.COD_MATERIAL,m1.NOMBRE_MATERIAL,um.ABREVIATURA,um.cod_unidad_medida,g.cod_grupo ";
            sql_aux += " from MATERIALES m1,grupos g,UNIDADES_MEDIDA um where g.COD_GRUPO=m1.COD_GRUPO and g.COD_CAPITULO=2 and m1.movimiento_item=1";
            sql_aux += " order by m1.NOMBRE_MATERIAL";
            System.out.println("MATERIALES :" + sql_aux);
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
        <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
        <script src="../js/general.js"></script>
    </head>
    <body>
        <form>
            <h4 align="center">Reporte de Proveedores por Material</h4>
            <table align="center" width="90%">

                <td>
                    <%

        String fechaInicio = "";
        String lote = "";
        String almacen = "";
        String pilar = "";
        String aux = "";
        String codProveedor = "";
        String codCapitulo = "";
        String nombreProveedor = "Todos";
        String nombreCapitulo = "Todos";
        con = Util.openConnection(con);
        aux = request.getParameter("codProveedor");
        codProveedor = aux;
        aux = request.getParameter("codCapitulo");
        codCapitulo = aux;
        System.out.println("aux:" + codCapitulo + " ," + codProveedor);

        if (nombreCapitulo != null && !nombreCapitulo.equals("0")) {
            try {
                //con=CofarConnection.getConnectionJsp();
                String sql_aux = "select cod_capitulo,nombre_capitulo from capitulos " +
                        " where cod_estado_registro=1 and cod_capitulo='" + codCapitulo + "'";
                System.out.println("nombreCapitulo SQL:" + sql_aux);
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rs = st.executeQuery(sql_aux);
                while (rs.next()) {
                    nombreCapitulo = "";
                    nombreCapitulo = rs.getString(2);
                    System.out.println("nombreCapitulo:" + nombreCapitulo);
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }

        }

        if (nombreProveedor != null && !nombreProveedor.equals("0")) {
            try {
                //con=CofarConnection.getConnectionJsp();
                String sql_aux = "select cod_proveedor,nombre_proveedor from proveedores" +
                        " where cod_estado_registro=1 and cod_proveedor='" + codProveedor + "'";
                System.out.println("almacen:" + sql_aux);
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rs = st.executeQuery(sql_aux);
                while (rs.next()) {
                    nombreProveedor = "";
                    nombreProveedor = rs.getString(2);
                    System.out.println("nombreProveedor:" + nombreProveedor);
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }

        }


                    %>

                </td>
            </table>
            <div class="outputText2" align="center">


                Proveedor : <b><%=nombreProveedor%></b>
                <br><br>
                Capítulo : <b><%=nombreCapitulo%></b>
            </div>
            <br> <br>
            <table  align="center" width="70%" class="outputText2" style="border : solid #f2f2f2 1px;" cellpadding="0" cellspacing="0">

                <tr class="headerFiltroReporte">
                    <td align="center" class="border"  bgcolor="#f2f2f2"><b>Material</b></td>
                    <%
        if (codProveedor.equals("0")) {
                    %>
                    <td align="center" class="border"  bgcolor="#f2f2f2"><b>Proveedor</b></td>
                    <%        }
                    %>
                </tr>

                <%

        String sql_4 = "select DISTINCT( m1.COD_MATERIAL),m1.NOMBRE_MATERIAL,um.ABREVIATURA,um.cod_unidad_medida,g.cod_grupo,p.NOMBRE_PROVEEDOR ";
        sql_4 += " from MATERIALES m1,grupos g,UNIDADES_MEDIDA um,ORDENES_COMPRA o,ORDENES_COMPRA_DETALLE od,PROVEEDORES p";
        sql_4 += " where g.COD_GRUPO=m1.COD_GRUPO and p.COD_PROVEEDOR=o.COD_PROVEEDOR";
        sql_4 += " and m1.movimiento_item=1 and um.COD_UNIDAD_MEDIDA=m1.COD_UNIDAD_MEDIDA and g.COD_CAPITULO in (2,3,4)";
        sql_4 += " and o.COD_ORDEN_COMPRA=od.COD_ORDEN_COMPRA and od.COD_MATERIAL=m1.COD_MATERIAL";
        if (!codProveedor.equals("0")) {
            sql_4 += " and p.cod_proveedor='" + codProveedor + "'";
        }
        if (!codCapitulo.equals("0")) {
            sql_4 += " and g.COD_CAPITULO='" + codCapitulo + "'";
        }
        sql_4 += " order by p.NOMBRE_PROVEEDOR,m1.NOMBRE_MATERIAL";

        System.out.println("MATERIALES :" + sql_4);
        System.out.println("SQL_4:" + sql_4);
        Statement st_4 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        ResultSet rs_4 = st_4.executeQuery(sql_4);

        while (rs_4.next()) {

            String codMaterial = rs_4.getString(1);
            String nomMaterial = rs_4.getString(2);
            String nomProveedor=rs_4.getString(6);
                %>
                <tr>
                    <td class="border"><%=nomMaterial%></td>
                    <%
                            if (codProveedor.equals("0")) {
                    %>
                    <td  class="border" ><%=nomProveedor%></td>
                    <%                            }
                    %>

                </tr>
                <%
        }


                %>
            </table>
            <br>


            <div align="center">
                <%--<INPUT type="button" class="commandButton" name="btn_registrar" value="<-- Atrás" onClick="cancelar();"  >--%>

            </div>
        </form>
    </body>
</html>
