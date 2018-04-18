

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
<%--@ page contentType="application/pdf" --%>

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
    <body>
        <form>
            <h4 align="center">Reporte Nombres Comerciales</h4>
            <table align="center" width="90%">
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
                <td>
                    Leyenda: Producto Compuesto <table> <td bgcolor="#123456" align="center" width="180px" >&nbsp;</td></table>
                </td>
                
                <td align="center" > <br>
                    Estado : <b><%=nombreEstadoProducto%></b>
                    <br><br>
                Fecha : <b><%=fechaInicio%> </b> </td>
            </table>
            <div class="outputText0" align="center">
                
                
            </div>
            <br>
            <table width="90%" align="center" class="outputText0" style="border : solid #E3CEF6 1px;" cellpadding="0" cellspacing="0" >
                
                
                <tr class="">
                    <th  bgcolor="#E3CEF6"  class="outputText2">Nombre Producto Semiterminado</th>
                    <th align="center" class="outputText2"  bgcolor="#E3CEF6">Forma Farmaceútica</th>
                    <%--th align="center" class="outputText2"  bgcolor="#E3CEF6">Envase Primario</th--%>
                    <th  bgcolor="#E3CEF6"  class="outputText2">Volúmen/Concentración</th>
                    <th align="center" class="outputText2"  bgcolor="#E3CEF6">Color Presentación Primaria</th>
                    <th align="center" class="outputText2"  bgcolor="#E3CEF6">Sabor</th>
                    <th  bgcolor="#E3CEF6"  class="outputText2">Area Fabricación</th>
                    <th align="center" class="outputText2"  bgcolor="#E3CEF6">Nombre Genérico</th>
                    <th align="center" class="outputText2"  bgcolor="#E3CEF6">Estado</th>
                    <th align="center" class="outputText2"  bgcolor="#E3CEF6">Reg Sanitario</th>
                    <th align="center" class="outputText2"  bgcolor="#E3CEF6">Fecha Vencimiento R.S.</th>
                    <th align="center" class="outputText2"  bgcolor="#E3CEF6">Vida Útil</th>
                    <th align="center" class="outputText2"  bgcolor="#E3CEF6">Presentaciones Primarias</th>
                </tr>
                
                <%
                
                
                String sql="select c.volumenpeso_envaseprim,c.cantidad_compprod,p.nombre_prod,";
                sql+=" isnull(c.nombre_prod_semiterminado,''),isnull(c.nombre_generico,''),isnull( c.reg_sanitario,''),";
                sql+=" isnull(c.vida_util,''),ae.NOMBRE_AREA_EMPRESA,isnull((select s.NOMBRE_SABOR from SABORES_PRODUCTO s where s.COD_SABOR=c.COD_SABOR),''),";
                sql+=" ISNULL((select f.nombre_forma from FORMAS_FARMACEUTICAS f where f.cod_forma=c.COD_FORMA),''),";
                sql+=" ISNULL((select ep.nombre_envaseprim from ENVASES_PRIMARIOS ep where ep.cod_envaseprim=c.COD_ENVASEPRIM),''),c.COD_COMPUESTOPROD,";
                sql+=" isnull((select co.NOMBRE_COLORPRESPRIMARIA from COLORES_PRESPRIMARIA co where co.COD_COLORPRESPRIMARIA=c.COD_COLORPRESPRIMARIA),''),c.FECHA_VENCIMIENTO_RS,c.cod_compprod,e.nombre_estado_compprod";
                sql+=" from componentes_prod c,productos p,AREAS_EMPRESA ae,ESTADOS_COMPPROD e";
                sql+=" where p.cod_prod = c.cod_prod and ae.COD_AREA_EMPRESA=c.COD_AREA_EMPRESA and p.cod_estado_prod=1 and e.cod_estado_compprod = c.cod_estado_compprod";
                if(!codAreaEmpresa.equals("0")){
                    sql+=" and c.cod_area_empresa="+codAreaEmpresa;
                }
                
                sql+=" order by c.nombre_prod_semiterminado ";
                System.out.println("sql:" + sql);
                con=Util.openConnection(con);
                Statement st_4 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rs_4 = st_4.executeQuery(sql);
                
                while (rs_4.next()) {
                    
                    String volumenPeso = rs_4.getString(1);
                    String cantidadCompProd = rs_4.getString(2);
                    String nombreProd=rs_4.getString(3);
                    String nombreCompProd=rs_4.getString(4);
                    String nombreGenerico = rs_4.getString(5);
                    String regSanitario = rs_4.getString(6);
                    String vidaUtil=rs_4.getString(7);
                    String nombreAreaEmpresa=rs_4.getString(8);
                    String nombreSabor=rs_4.getString(9);
                    String nombreForma=rs_4.getString(10);
                    String nombreEnvasePrim=rs_4.getString(11);
                    String codCompuestoProd=rs_4.getString(12);
                    String nombreColor=rs_4.getString(13);
                    String fechaVencimientoRS=rs_4.getString(14);
                    String codCompProd=rs_4.getString(15);
                    if(fechaVencimientoRS!=null){
                        System.out.println("fechaVencimientoRS:" + fechaVencimientoRS);
                        String fechaVencimientoRSString[]=fechaVencimientoRS.split(" ");
                        fechaVencimientoRSString=fechaVencimientoRSString[0].split("-");
                        fechaVencimientoRS=fechaVencimientoRSString[2]+"/"+fechaVencimientoRSString[1]+"/"+fechaVencimientoRSString[0];
                    }else{
                        fechaVencimientoRS="";
                    }
                    String codEnvasePrim="";
                    
                    String cantidadEnvasePrim="";
                    if(codCompuestoProd.equals("2")){
                
                
                %>
                <tr bgcolor="#123456" class="outputTextBlanco">
                    <td style="border : solid #E3CEF6 1px;"  align="left" ><%=nombreCompProd%></td>
                    <td style="border : solid #E3CEF6 1px;"  align="right"><%=nombreForma%></td>
                    <%--td style="border : solid #E3CEF6 1px;"  align="center"><%=nombreEnvasePrim%></td--%>
                    
                    <td style="border : solid #E3CEF6 1px;"  align="left" ><%=volumenPeso%></td>
                    <td style="border : solid #E3CEF6 1px;"  align="left"><%=nombreColor%></td>
                    <td style="border : solid #E3CEF6 1px;"  align="center"><%=nombreSabor%></td>
                    
                    <td style="border : solid #E3CEF6 1px;"  align="left" ><%=nombreAreaEmpresa%></td>
                    <td style="border : solid #E3CEF6 1px;"  align="left"><%=nombreGenerico%></td>
                    <td style="border : solid #E3CEF6 1px;"  align="left"><%=rs_4.getString("nombre_estado_compprod")==null?"":rs_4.getString("nombre_estado_compprod")%></td>
                    <td style="border : solid #E3CEF6 1px;"  align="center"><%=regSanitario%></td>
                    <td style="border : solid #E3CEF6 1px;"  align="center"><%=fechaVencimientoRS%></td>
                    <td style="border : solid #E3CEF6 1px;"  align="center"><%=vidaUtil%></td>
                    <td style="border : solid #E3CEF6 1px;"  align="center">
                        <table width="100%" class="outputTextBlanco">
                            <tr bgcolor="#E3CEF6">
                                <th >Presentaciones Prim</th>
                                <th >Cant. Presentación</th>
                            </tr>
                            <%
                            sql="select p.COD_ENVASEPRIM,(select ep.nombre_envaseprim from ENVASES_PRIMARIOS ep where ep.cod_envaseprim = p.COD_ENVASEPRIM) as nombreEvasePrimaria";
                            sql+=",p.CANTIDAD from PRESENTACIONES_PRIMARIAS p where p.COD_COMPPROD = "+codCompProd;
                            sql+=" order by nombreEvasePrimaria asc";
                            System.out.println("cargarSQLLLLLLLLLLLLLL:"+sql);
                            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                            ResultSet rs=st.executeQuery(sql);
                            while(rs.next()){
                                codEnvasePrim=rs.getString(1);
                                nombreEnvasePrim=rs.getString(2);
                                cantidadEnvasePrim=rs.getString(3);
                                System.out.println("cantidadEnvasePrim:"+cantidadEnvasePrim);
                            %>
                            <tr>
                                <td><%=nombreEnvasePrim%></td>
                                <td><%=cantidadEnvasePrim%></td>
                            </tr>
                            <%
                            }
                            %>
                            
                            
                        </table>
                    </td>
                    
                </tr>
                <%
                    }else{
                %>
                <tr>
                    <td style="border : solid #E3CEF6 1px;"  align="left" ><%=nombreCompProd%></td>
                    <td style="border : solid #E3CEF6 1px;"  align="left"><%=nombreForma%></td>
                    <%--td style="border : solid #E3CEF6 1px;"  align="center"><%=nombreEnvasePrim%></td--%>
                    
                    <td style="border : solid #E3CEF6 1px;"  align="left" ><%=volumenPeso%></td>
                    <td style="border : solid #E3CEF6 1px;"  align="left"><%=nombreColor%></td>
                    <td style="border : solid #E3CEF6 1px;"  align="center"><%=nombreSabor%></td>
                    
                    <td style="border : solid #E3CEF6 1px;"  align="left" ><%=nombreAreaEmpresa%></td>
                    <td style="border : solid #E3CEF6 1px;"  align="left"><%=nombreGenerico%></td>
                    <td style="border : solid #E3CEF6 1px;"  align="left"><%=rs_4.getString("nombre_estado_compprod")==null?"":rs_4.getString("nombre_estado_compprod")%></td>
                    <td style="border : solid #E3CEF6 1px;"  align="center"><%=regSanitario%></td>
                    <td style="border : solid #E3CEF6 1px;"  align="center"><%=fechaVencimientoRS%></td>
                    <td style="border : solid #E3CEF6 1px;"  align="center"><%=vidaUtil%></td>
                    <td style="border : solid #E3CEF6 1px;"  align="center">
                        <table width="100%" class="outputText0" cellpadding="0" cellspacing="0">
                            <tr bgcolor="#E3CEF6">
                                <th >Presentaciones Prim</th>
                                <th >Cant. Presentación</th>
                            </tr>
                            <%
                            sql="select p.COD_ENVASEPRIM,(select ep.nombre_envaseprim from ENVASES_PRIMARIOS ep where ep.cod_envaseprim = p.COD_ENVASEPRIM) as nombreEvasePrimaria";
                            sql+=",p.CANTIDAD from PRESENTACIONES_PRIMARIAS p where p.COD_COMPPROD = "+codCompProd;
                            sql+=" order by nombreEvasePrimaria asc";
                            System.out.println("cargarSQLLLLLLLLLLLLLL:"+sql);
                            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                            ResultSet rs=st.executeQuery(sql);
                            while(rs.next()){
                                codEnvasePrim=rs.getString(1);
                                nombreEnvasePrim=rs.getString(2);
                                cantidadEnvasePrim=rs.getString(3);
                                System.out.println("cantidadEnvasePrim:"+cantidadEnvasePrim);
                            %>
                            <tr>
                                <td style="border : solid #E3CEF6 1px;"><%=nombreEnvasePrim%></td>
                                <td style="border : solid #E3CEF6 1px;"><%=cantidadEnvasePrim%></td>
                            </tr>
                            <%
                            }
                            %>

                        </table>
                    </td>
                </tr>
                <%
                    }
                    
                    
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
