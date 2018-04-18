

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
        <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
        <script src="../js/general.js"></script>
    </head>
    <body onload="cargar(1,<%=request.getParameter("codPersonal")%>)">
        <form>
            <h4 align="center">Reporte Nombres Comerciales</h4>
            <table align="center" width="65%">
                <td>
                    <img src="../img/cofar.png">
                </td>
                <td>
                    <%
                    try {
                        String fechaInicio = "";
                        String lote = "";
                        String almacen = "";
                        String pilar = "";
                        String aux = "";
                        String codAreaEmpresa = "";
                        con = Util.openConnection(con);
                        aux = request.getParameter("codAreaEmpresa");
                        String codEstadoPrograma= request.getParameter("codEstado");
                        codAreaEmpresa = aux;
                        Date fecha=new Date();
                        SimpleDateFormat f=new SimpleDateFormat("dd/MM/yyyy");
                        fechaInicio=f.format(fecha);
                        String nombreEstadoProducto = "Todos";
                        if (codEstadoPrograma != null && !codEstadoPrograma.equals("0")) {
                            try {
                                String sql_aux = "select nombre_estado_prod from estados_producto " +
                                        "where cod_estado_registro=1 and cod_estado_prod='" + codEstadoPrograma + "'";
                                System.out.println("almacen:" + sql_aux);
                                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                                ResultSet rs = st.executeQuery(sql_aux);
                                while (rs.next()) {
                                    nombreEstadoProducto = "";
                                    nombreEstadoProducto = rs.getString(1);
                                    System.out.println("nombreEstadoProducto" + nombreEstadoProducto);
                                }
                            } catch (SQLException e) {
                                e.printStackTrace();
                            }
                            
                        }
                        //aux = request.getParameter("fecha_inicio");
                        //aux = "09/02/2009";
                        
                        if (fechaInicio != null) {
                            System.out.println("entro");
                            fechaInicio = fechaInicio;
                        }
                        System.out.println("fechaInicio:" + fechaInicio);
                        
                        
                    /* if (aux != null) {
                    try {
 
                    String sql_aux = "select nombre_lineamkt from lineas_mkt " +
                    " where cod_lineamkt='" + aux + "'";
                    System.out.println("pilar:" + sql_aux);
                    Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    ResultSet rs = st.executeQuery(sql_aux);
                    while (rs.next()) {
                    linea_mkt = "";
                    linea_mkt = rs.getString(1);
                    System.out.println("linea_mkt:" + linea_mkt);
                    }
                    } catch (SQLException e) {
                    e.printStackTrace();
                    }
                    pilar = aux;
                    }*/
                    
                    
                    %>
                    
                </td>
                <td align="center" > <br>
                    Estado : <b><%=nombreEstadoProducto%></b>
                    <br><br>
                Fecha : <b><%=fechaInicio%> </b> </td>
            </table>
            <div class="outputText0" align="center">
                
                
            </div>
            <br>
            <table width="65%" align="center" class="outputText0" style="border : solid #E3CEF6 1px;" cellpadding="0" cellspacing="0" >
                
                
                <tr class="">
                    <th  bgcolor="#E3CEF6"  class="outputTextBlanco">Nombre Comercial</th>
                    <th align="center" class="outputTextBlanco"  bgcolor="#E3CEF6">Observaciones</th>
                    <th align="center" class="outputTextBlanco"  bgcolor="#E3CEF6">Estado</th>
                </tr>
                
                <%
                
                
                String sql="select p.cod_prod,p.nombre_prod,p.cod_estado_prod, ISNULL(p.obs_prod,''),isnull(ep.nombre_estado_prod,'')";
                sql+=" from productos p, estados_producto ep where ep.cod_estado_prod=p.cod_estado_prod";
                if(!codEstadoPrograma.equals("0") ){
                    sql+=" and ep.cod_estado_prod="+codEstadoPrograma;
                }
                sql+=" order by p.nombre_prod";
                System.out.println("sql:" + sql);
                con=Util.openConnection(con);
                Statement st_4 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rs_4 = st_4.executeQuery(sql);
                
                while (rs_4.next()) {
                    
                    String codProducto = rs_4.getString(1);
                    String nombreProducto = rs_4.getString(2);
                    String obsProducto=rs_4.getString(3);
                    String nombreEstadoProd=rs_4.getString(4);
                    
                %>
                <tr>
                    <td style="border : solid #E3CEF6 1px;"  align="left" ><%=nombreProducto%></td>
                    <td style="border : solid #E3CEF6 1px;"  align="right"><%=obsProducto%></td>
                    <td style="border : solid #E3CEF6 1px;"  align="center"><%=nombreEstadoProd%></td>
                    
                   
                </tr>
                <%
                }
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                
                %>
            </table>
            <br>
            
            <br>
            <div align="center">
                <%--<INPUT type="button" class="commandButton" name="btn_registrar" value="<-- Atrás" onClick="cancelar();"  >--%>

            </div>
        </form>
    </body>
</html>
