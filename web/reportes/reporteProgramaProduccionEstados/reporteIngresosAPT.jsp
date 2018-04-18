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
<%@ page import = "com.cofar.bean.*" %>


<%@ page language="java" import="java.util.*,com.cofar.util.CofarConnection" %>
<%@ page errorPage="ExceptionHandler.jsp" %>
<%! Connection con=null;


%>
<%! public String nombrePresentacion1(String codPresentacion){
    

 
String  nombreproducto="";

try{
con=Util.openConnection(con);
String sql_aux="select cod_presentacion, nombre_producto_presentacion from presentaciones_producto where cod_presentacion='"+codPresentacion+"'";
System.out.println("PresentacionesProducto:sql:"+sql_aux);
Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
ResultSet rs=st.executeQuery(sql_aux);
while (rs.next()){
String codigo=rs.getString(1);
nombreproducto=rs.getString(2);
}
} catch (SQLException e) {
e.printStackTrace();
    }
    return "";
}

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        
        <%--meta http-equiv="Content-Type" content="text/html; charset=UTF-8"--%>
        <title>JSP Page</title>
        <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
        <script src="../../js/general.js"></script>
        
        <script type="text/javascript" >
                function openPopup(f,url){
                    //window.open(url,'DETALLE','top=50,left=200,width=800,height=600,scrollbars=1,resizable=1');
                    f.action=url;
                    f.submit();
                }
                function openPopup1(url){
                    //window.open(url,'DETALLE','top=50,left=200,width=800,height=500,scrollbars=1,resizable=1');
                    //window.open(url,'DETALLE','top=50,left=200,width=800,height=500,scrollbars=1,resizable=1');
                    showModalDialog(url, "dialogwidth: 800", "dialogwidth: 800px");
                    //window.openDialog(url, "dlg", "", "dlg", 6.98);
                    //(url,'DETALLE','top=50,left=200,width=800,height=500,scrollbars=1,resizable=1');

                }
        </script>
        <style>
            .b{
                background-color:#90EE90;
                color:#90EE90;
                }
        </style>

    </head>
    <body>
        <h3 align="center">INGRESOS ALMACEN DE PRODUCTO TERMINADO</h3>
        <br>
        <form target="_blank" id="form" name="form">
            <table align="center" width="90%">

                <%
                
                NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
                DecimalFormat form = (DecimalFormat)nf;
                form.applyPattern("#,###");
                String codLoteProduccion=request.getParameter("codLoteProduccion")==null?"0":request.getParameter("codLoteProduccion");
                String codIngresoVentas=request.getParameter("codIngresoAPT")==null?"0":request.getParameter("codIngresoAPT");
                String codAlmacen=request.getParameter("codAlmacen")==null?"0":request.getParameter("codAlmacen");
                String codDevolucion=request.getParameter("codDevolucion")==null?"0":request.getParameter("codDevolucion");
                    //codOrdenCompra = "10069";
                    //IngresosAlmacen ingresosAlmacen = (IngresosAlmacen)request.getSession().getAttribute("ingresosAlmacen");
                    ManagedAccesoSistema managedAccesoSistema = (ManagedAccesoSistema)request.getSession().getAttribute("managedAccesoSistema");
                    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
                %>
            </table>
            <br>
            <br>
                <%

                    //codOrdenCompra = "10069";

                  String consulta = "  select a.NOMBRE_ALMACEN_VENTA, i.FECHA_INGRESOVENTAS, i.NRO_INGRESOVENTAS, p.NOMBRE_PRODUCTO_PRESENTACION," +
                          " id.CANTIDAD, id.CANTIDAD_UNITARIA,i.COD_INGRESOVENTAS" +
                          " from INGRESOS_VENTAS i, INGRESOS_DETALLEVENTAS id, ALMACENES_VENTAS a, PRESENTACIONES_PRODUCTO p" +
                          " where i.COD_INGRESOVENTAS= id.COD_INGRESOVENTAS and i.COD_AREA_EMPRESA=id.COD_AREA_EMPRESA and" +
                          " i.COD_AREA_EMPRESA=1 and i.COD_ALMACEN_VENTA in (54,56,57) and id.COD_LOTE_PRODUCCION='"+codLoteProduccion+"' and" +
                          " p.cod_presentacion=id.COD_PRESENTACION and a.COD_ALMACEN_VENTA=i.COD_ALMACEN_VENTA and i.COD_INGRESOVENTAS = '"+codIngresoVentas+"'";
                          
                  //and i.COD_ALMACEN = '"+managedAccesoSistema.getAlmacenesGlobal().getCodAlmacen()+"'

                System.out.println("consulta"+consulta);
                con = Util.openConnection(con);
                Statement st1=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet rs1=st1.executeQuery(consulta);
                out.print(" <table align='center' width='70%' border='0' style='text-align:left' class='outputText1'> ");
                //<td rowspan='4'><img src='../../img/cofar.png' />
                if(rs1.next()){
                    out.print(" <tr></td><td><b> almacen : </b></td> <td> "+(rs1.getString("NOMBRE_ALMACEN_VENTA")==null?"":rs1.getString("NOMBRE_ALMACEN_VENTA"))+" </td></tr>");
                    out.print(" <tr></td><td><b> Fecha Ingreso : </b></td> <td> "+(rs1.getDate("FECHA_INGRESOVENTAS")==null?"":sdf.format(rs1.getDate("FECHA_INGRESOVENTAS")))+" </td></tr>");
                    out.print(" <tr></td><td><b> Nro Ingreso : </b></td> <td> "+(rs1.getInt("NRO_INGRESOVENTAS"))+" </td></tr>");
                    out.print(" <tr></td><td><b> Presentacion : </b></td> <td> "+(rs1.getString("NOMBRE_PRODUCTO_PRESENTACION")==null?"":rs1.getString("NOMBRE_PRODUCTO_PRESENTACION"))+" </td></tr>");
                    out.print(" <tr></td><td><b> Cantidad : </b></td> <td> "+(rs1.getDouble("CANTIDAD"))+" </td></tr>");
                    out.print(" <tr></td><td><b> Cantidad Unitaria: </b></td> <td> "+(rs1.getDouble("CANTIDAD_UNITARIA"))+" </td></tr>");
                    

                    
                    //salidasAlmacen.setObsSalidaAlmacen(rs1.getString("OBS_SALIDA_ALMACEN"));
                }
                out.print(" </table> ");

            %>
            <br>
            
        </form>
    </body>
</html>