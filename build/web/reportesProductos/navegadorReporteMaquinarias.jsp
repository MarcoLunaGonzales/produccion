

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
%>
<%! 
public String nombreTipoMaquinaria(String codTipoMaquinaria) {
    
    String nombreTipoMaquinaria= "";
//ManagedAccesoSistema bean1=(ManagedAccesoSistema)com.cofar.util.Util.getSessionBean("ManagedAccesoSistema");
    try {
        con = Util.openConnection(con);
        String sql_aux = "select t.NOMBRE_TIPO_EQUIPO from TIPOS_EQUIPOS_MAQUINARIA t " ;
        if(!codTipoMaquinaria.equals("0")){
            sql_aux+=" where t.COD_TIPO_EQUIPO='" + codTipoMaquinaria + "'";
        }
        sql_aux+=" order by t.NOMBRE_TIPO_EQUIPO";
        System.out.println("tiposmercaderiat:sql:" + sql_aux);
        Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        ResultSet rs = st.executeQuery(sql_aux);
        while (rs.next()) {
            nombreTipoMaquinaria = nombreTipoMaquinaria+","+rs.getString(1);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return nombreTipoMaquinaria;
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
                        String codTipoMaquinaria= request.getParameter("codTipoMaquinaria");
                        String nombreTipoMaquinaria =nombreTipoMaquinaria(codTipoMaquinaria);
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
                    
                    Tipo de Maquinaría : <b><%=nombreTipoMaquinaria%> </b>
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
            <table width="90%" align="center" class="outputText2" style="border : solid #E3CEF6 1px;" cellpadding="0" cellspacing="0" >
                
                
                <tr class="">
                    <th  bgcolor="#E3CEF6"  class="outputText2">Código - Area</th>
                    <th align="center" class="outputText2"  bgcolor="#E3CEF6">Maquina</th>
                    <th align="center" class="outputText2"  bgcolor="#E3CEF6">Fecha de Compra</th>
                    <th  bgcolor="#E3CEF6"  class="outputText2">Tipo de Maquinaria</th>
                    <th align="center" class="outputText2"  bgcolor="#E3CEF6">GMP</th>
                    <th align="center" class="outputText2"  bgcolor="#E3CEF6">Observación</th>
                    <th  bgcolor="#E3CEF6"  class="outputText2">Estado de Registro</th>
                    <th  bgcolor="#E3CEF6"  class="outputText2">Detalle</th>
                    
                </tr>
                
                <%
                
                
                String sql="select m.COD_MAQUINA,m.NOMBRE_MAQUINA,isnull(m.OBS_MAQUINA,''),m.fecha_compra," ;
                sql+="e.NOMBRE_ESTADO_REGISTRO,m.codigo,m.COD_TIPO_EQUIPO,m.GMP,te.NOMBRE_TIPO_EQUIPO";
                sql+=" from MAQUINARIAS m, ESTADOS_REFERENCIALES e,TIPOS_EQUIPOS_MAQUINARIA te";
                sql+=" where m.COD_ESTADO_REGISTRO<>0 and e.COD_ESTADO_REGISTRO=m.COD_ESTADO_REGISTRO" ;
                sql+=" and m.COD_TIPO_EQUIPO=te.COD_TIPO_EQUIPO";
                if(!codEstadoRegistro.equals("0")){
                    sql+=" and m.COD_ESTADO_REGISTRO="+codEstadoRegistro;
                }
                if(!codTipoMaquinaria.equals("0")){
                    sql+=" and m.COD_TIPO_EQUIPO="+codTipoMaquinaria;
                }
                sql+=" order by m.NOMBRE_MAQUINA";
                System.out.println("sql:" + sql);
                con=Util.openConnection(con);
                Statement st_4 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rs_4 = st_4.executeQuery(sql);
                
                while (rs_4.next()) {
                    
                    String codMaquina = rs_4.getString(1);
                    String nombreMaquina = rs_4.getString(2);
                    String obsMaquina=rs_4.getString(3);
                    String fechaCompra=rs_4.getString(4);
                    if(fechaCompra==null ){
                        fechaCompra="";
                    }else{
                        String fechaCompraString[]=fechaCompra.split(" ");
                        fechaCompraString=fechaCompraString[0].split("-");
                        fechaCompra=fechaCompraString[2]+"/"+fechaCompraString[1]+"/"+fechaCompraString[0];
                        if(fechaCompra.equals("01/01/1900")){
                            fechaCompra="";
                        }
                    }
                    String nombreEstadoReg = rs_4.getString(5);
                    String codigo = rs_4.getString(6);
                    String codTipoEquipo=rs_4.getString(7);
                    String gmp=rs_4.getString(8);
                    String nombreTipoEquipo=rs_4.getString(9);
                
                %>
                <tr  class="outputText2">
                    <td style="border : solid #E3CEF6 1px;"  align="left" ><%=codigo%></td>
                    <td style="border : solid #E3CEF6 1px;"  align="left"><%=nombreMaquina%></td>
                    <td style="border : solid #E3CEF6 1px;"  align="left"><%=fechaCompra%></td>
                    <td style="border : solid #E3CEF6 1px;"  align="left" ><%=nombreTipoEquipo%></td>
                    <td style="border : solid #E3CEF6 1px;"  align="left"><%=gmp%></td>
                    <td style="border : solid #E3CEF6 1px;"  align="left"><%=obsMaquina%></td>
                    <td style="border : solid #E3CEF6 1px;"  align="left" ><%=nombreEstadoReg%></td>
                    <td style="border : solid #E3CEF6 1px;"  align="left" >
                        <table width="100%" align="center" class="outputText2"  cellpadding="0" cellspacing="0" >
                            <tr class="">
                                <th  bgcolor="#E3CEF6"  class="outputText2">Código - Area</th>
                                <th align="center" class="outputText2"  bgcolor="#E3CEF6">Parte</th>
                                <th align="center" class="outputText2"  bgcolor="#E3CEF6">Tipo de Parte</th>
                                <th align="center" class="outputText2"  bgcolor="#E3CEF6">Observaciones</th>
                            </tr>
                            <%
                            sql="select pm.cod_parte_maquina,pm.cod_maquina,pm.codigo,pm.cod_tipo_equipo,pm.nombre_parte_maquina,pm.obs_parte_maquina,te.NOMBRE_TIPO_EQUIPO";
                            sql+=" from partes_maquinaria pm,TIPOS_EQUIPOS_MAQUINARIA te";
                            sql+=" where cod_maquina="+codMaquina+" and te.COD_TIPO_EQUIPO=pm.cod_tipo_equipo";
                            sql+=" order by pm.nombre_parte_maquina";
                            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                            ResultSet rs=st.executeQuery(sql);
                            while(rs.next()){
                                String codigoParte=rs.getString(3);
                                String nombreParteMaquina=rs.getString(5);
                                String obsParteMaquina=rs.getString(6);
                                String nombreTipoEq=rs.getString(7);
                            %>
                            <tr  class="outputText2">
                                <td style="border : solid #E3CEF6 1px;"  align="left" ><%=codigoParte%></td>
                                <td style="border : solid #E3CEF6 1px;"  align="left" ><%=nombreParteMaquina%></td>
                                <td style="border : solid #E3CEF6 1px;"  align="left" ><%=nombreTipoEq%></td>
                                <td style="border : solid #E3CEF6 1px;"  align="left" ><%=obsParteMaquina%></td>
                            </tr>
                            <%
                            }
                            %>
                        </table>
                    </td>
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
