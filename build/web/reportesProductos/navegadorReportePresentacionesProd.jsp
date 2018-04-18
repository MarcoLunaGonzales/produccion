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
<%! 
public String nombreLinea(String codLinea) {
    
    String nombreLinea = "";
//ManagedAccesoSistema bean1=(ManagedAccesoSistema)com.cofar.util.Util.getSessionBean("ManagedAccesoSistema");
    try {
        con = Util.openConnection(con);
        String sql_aux = "select l.NOMBRE_LINEAMKT from LINEAS_MKT l " ;
        if(!codLinea.equals("0")){
            sql_aux+=" where l.COD_LINEAMKT = '" + codLinea + "'";
        }
        sql_aux+=" order by l.NOMBRE_LINEAMKT";
        System.out.println("Lineasmkt:sql:" + sql_aux);
        Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        ResultSet rs = st.executeQuery(sql_aux);
        while (rs.next()) {
            nombreLinea = nombreLinea+","+ rs.getString(1);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return nombreLinea;
}
%>
<%! 
public String nombreEstado(String codEstado) {

    String nombreEstado = "";
//ManagedAccesoSistema bean1=(ManagedAccesoSistema)com.cofar.util.Util.getSessionBean("ManagedAccesoSistema");
    try {
        con = Util.openConnection(con);
        String sql_aux = "select  er.NOMBRE_ESTADO_REGISTRO from ESTADOS_REFERENCIALES er where er.cod_estado_registro<>3" ;
        if(!codEstado.equals("0")){
            sql_aux+=" and er.COD_ESTADO_REGISTRO='" + codEstado + "'";
        }
        sql_aux+=" order by er.NOMBRE_ESTADO_REGISTRO";
        System.out.println("Estado:sql:" + sql_aux);
        Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        ResultSet rs = st.executeQuery(sql_aux);
        while (rs.next()) {
            nombreEstado = nombreEstado+","+rs.getString(1);;
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return nombreEstado;
}
public String detalleProductos(String codPresentacion) {

    String nombreEstado = "";
//ManagedAccesoSistema bean1=(ManagedAccesoSistema)com.cofar.util.Util.getSessionBean("ManagedAccesoSistema");7
    String detalleProd = "";
    try {
        con = Util.openConnection(con);
        String consulta =" select cp.nombre_prod_semiterminado,e.nombre_estado_registro,ec.nombre_estado_compprod" +
                " from COMPONENTES_PRESPROD c inner join COMPONENTES_PROD cp on cp.COD_COMPPROD = c.COD_COMPPROD" +
                " inner join ESTADOS_REFERENCIALES e on e.COD_ESTADO_REGISTRO = c.cod_estado_registro" +
                " inner join estados_compprod ec on ec.cod_estado_compprod = cp.cod_estado_compprod " +
                " where c.COD_PRESENTACION  = '"+codPresentacion+"' ";
        System.out.println("consulta "+consulta);
        Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        ResultSet rs = st.executeQuery(consulta);
        detalleProd = " <table style='border : solid #E3CEF6 1px;width:250px' cellpadding='0' cellspacing='0'> ";
        while (rs.next()) {
            detalleProd+= " <tr><td style='width:200px; border : solid #E3CEF6 1px;'>"+rs.getString("nombre_prod_semiterminado")+"</td><td style='width:50px;border : solid #E3CEF6 1px;'>"+rs.getString("nombre_estado_registro")+"</td><td style='width:50px;border : solid #E3CEF6 1px;'>"+rs.getString("nombre_estado_compprod")+"</td><tr> ";
            
        }
        detalleProd = detalleProd + " </table> ";
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return detalleProd;
}
%>
<%! 
public String nombreTipoMercaderia(String codTipoMercaderia) {
    
    String nombreTipoMercaderia= "";
//ManagedAccesoSistema bean1=(ManagedAccesoSistema)com.cofar.util.Util.getSessionBean("ManagedAccesoSistema");
    try {
        con = Util.openConnection(con);
        String sql_aux = "select t.nombre_tipomercaderia from TIPOS_MERCADERIA t " ;
        if(!codTipoMercaderia.equals("0")){
            sql_aux+=" where t.cod_tipomercaderia='" + codTipoMercaderia + "'";
        }
        sql_aux+=" order by t.nombre_tipomercaderia";
        System.out.println("tiposmercaderiat:sql:" + sql_aux);
        Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        ResultSet rs = st.executeQuery(sql_aux);
        while (rs.next()) {
            nombreTipoMercaderia = nombreTipoMercaderia+","+rs.getString(1);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return nombreTipoMercaderia;
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
            <h3 align="center">Reporte Presentaciones Producto</h3>
            <table align="center" width="90%">
                <td>
                    <img src="../img/cofar.png">
                </td>
                <td>
                    <%
                    try {
                        String fechaInicio = "";
                        
                        con = Util.openConnection(con);
                        String codEstadoRegistro= request.getParameter("codEstado");
                        String codTipoMercaderia= request.getParameter("codTipo");
                        String codlineaMKT= request.getParameter("codLinea");
                        String nombreLineaMkt = nombreLinea(codlineaMKT);
                        String nombreTipoMercaderia =nombreTipoMercaderia(codTipoMercaderia);
                        String nombreEstadoRegistro = nombreEstado(codEstadoRegistro);
                        Date fecha=new Date();
                        SimpleDateFormat f=new SimpleDateFormat("dd/MM/yyyy");
                        fechaInicio=f.format(fecha);
                        
                        if (fechaInicio != null) {
                            System.out.println("entro");
                            fechaInicio = fechaInicio;
                        }
                        System.out.println("fechaInicio:" + fechaInicio);
                    
                    %>
                    
                </td>
                <td align="center" > <br>
                    Linea MKT : <b><%=nombreLineaMkt%></b>
                    <br><br>
                    Tipo Mercadería : <b><%=nombreTipoMercaderia%> </b>
                </td>
                
                <td align="center" > <br>
                    Estado : <b><%=nombreEstadoRegistro%></b>
                    <br><br>
                    Fecha : <b><%=fechaInicio%> </b>
                </td>
            </table>
            <div class="outputText0" align="center">
                
                
            </div>
            <br>
            <table width="90%" align="center" class="outputText0" style="border : solid #E3CEF6 1px;" cellpadding="0" cellspacing="0" >
                
                
                <tr class="">
                    <th  bgcolor="#E3CEF6"  class="outputText2">Código</th>
                    <th align="center" class="outputText2"  bgcolor="#E3CEF6">Presentación</th>
                    <th align="center" class="outputText2"  bgcolor="#E3CEF6">Nombre Comercial</th>
                    <th  bgcolor="#E3CEF6"  class="outputText2">Tipo Mercadería</th>
                    <th align="center" class="outputText2"  bgcolor="#E3CEF6">Cant. Envase Secundario</th>
                    <th align="center" class="outputText2"  bgcolor="#E3CEF6">Línea</th>
                    <th  bgcolor="#E3CEF6"  class="outputText2">Código Alfanumérico</th>
                    <th  bgcolor="#E3CEF6"  class="outputText2">Estado</th>
                    <th  bgcolor="#E3CEF6"  class="outputText2">Productos</th>


                </tr>
                
                <%
                
                
                String sql="select cod_prod,isnull((select nombre_prod from PRODUCTOS p where p.cod_prod=pp.cod_prod),'') as nombre_prod,";
                sql+=" isnull(cant_envase_secundario,''),isnull(cantidad_presentacion,''),OBS_PRESENTACION,isnull(cod_anterior,''), ";
                sql+=" (select nombre_lineamkt from lineas_mkt mkt where  mkt.cod_estado_registro=1 and mkt.COD_LINEAMKT=pp.COD_LINEAMKT) AS nombre_lineamkt ";
                sql+=" ,(select nombre_tipomercaderia from tipos_mercaderia tm where tm.cod_estado_registro=1 and tm.cod_tipomercaderia=pp.cod_tipomercaderia) AS nombre_tipomercaderia ";
                sql+=" ,(select nombre_carton from cartones_corrugados ct where ct.cod_estado_registro=1 and ct.COD_CARTON=pp.COD_CARTON) AS nombre_carton ";
                sql+=" ,(select nombre_estado_registro from estados_referenciales er  where er.cod_estado_registro<>3 and er.COD_ESTADO_REGISTRO=pp.cod_estado_registro) AS nombre_estado_registro ";
                sql+=" ,nombre_producto_presentacion,cod_presentacion" +
                     ",(select count(*) from COMPONENTES_PRESPROD cpp where cpp.COD_PRESENTACION=pp.cod_presentacion"+
                     " and cpp.COD_ESTADO_REGISTRO=1) as cantidadPresentacionesActivas";
                sql+=" from PRESENTACIONES_PRODUCTO pp ";
                sql+=" where pp.cod_estado_registro <>3";
                if(!codlineaMKT.equals("0")){
                    sql+=" and pp.COD_LINEAMKT="+codlineaMKT;
                }
                if(!codTipoMercaderia.equals("0")){
                    sql+=" and pp.cod_tipomercaderia="+codTipoMercaderia;
                }
                if(!codEstadoRegistro.equals("0")){
                    sql+=" and pp.COD_ESTADO_REGISTRO="+codEstadoRegistro;
                }
                sql+=" order by pp.nombre_producto_presentacion ";
                System.out.println("sql:" + sql);
                con=Util.openConnection(con);
                Statement st_4 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rs_4 = st_4.executeQuery(sql);
                
                while (rs_4.next()) {
                    
                    String codProd = rs_4.getString(1);
                    String nombreProd = rs_4.getString(2);
                    String cantEnvaseSecundario=rs_4.getString(3);
                    String cantidadPresentacion=rs_4.getString(4);
                    String obsPresentacion = rs_4.getString(5);
                    String codigoAnterior = rs_4.getString(6);
                    String nombreLinea=rs_4.getString(7);
                    String nombreTipoMerc=rs_4.getString(8);
                    String nombreCarton=rs_4.getString(9);
                    String nombreEstadoReg=rs_4.getString(10);
                    String nombreProductoPresentacion=rs_4.getString(11);
                    String codProductoPresentacion=rs_4.getString(12);
                
                %>
                <tr  class="outputText2" style="<%=(rs_4.getInt("cantidadPresentacionesActivas")>0?"":"background-color:#FFB6C1")%>">
                    <td style="border : solid #E3CEF6 1px;"  align="left" ><%=codProductoPresentacion%></td>
                    <td style="border : solid #E3CEF6 1px;"  align="left"><%=nombreProductoPresentacion%></td>
                    <td style="border : solid #E3CEF6 1px;"  align="left"><%=nombreProd%></td>
                    
                    <td style="border : solid #E3CEF6 1px;"  align="left" ><%=nombreTipoMerc%></td>
                    <td style="border : solid #E3CEF6 1px;"  align="left"><%=cantEnvaseSecundario%></td>
                    <td style="border : solid #E3CEF6 1px;"  align="left"><%=nombreLinea%></td>
                    
                    <td style="border : solid #E3CEF6 1px;"  align="left" ><%=codigoAnterior%></td>
                    <td style="border : solid #E3CEF6 1px;"  align="left"><%=nombreEstadoReg%></td>
                    <td style="border : solid #E3CEF6 1px;"  align="left"><%=this.detalleProductos(rs_4.getString("cod_presentacion"))%></td>
                    
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
