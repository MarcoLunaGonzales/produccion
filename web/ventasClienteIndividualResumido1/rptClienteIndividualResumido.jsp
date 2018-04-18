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
<%@ page import="java.text.*" %>
<%! Connection con=null;
/***************************************************************/
/* METODO PARA CARGAR NOMBRE PRESENTACION =====> !=INDICA QUE ES UN METOSO*/
/***************************************************************/
public String nombrePresentacion(String codPresentacion){
    String  nombreproducto="";
    try{
        con=Util.openConnection(con);
        String sql_aux="select cod_presentacion, nombre_producto_presentacion from presentaciones_producto where cod_presentacion="+codPresentacion;
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
    return nombreproducto;
}
/***************************************************************/
/* CANTIDAD DE PRESENTACION */
/***************************************************************/
public float cantidadPresentacion(String codPresentacion){
    float cantidadPresentacion=0;
    try{
        con=Util.openConnection(con);
        String sql_aux="select cod_presentacion,cantidad_presentacion  from presentaciones_producto where cod_presentacion="+codPresentacion;
        System.out.println("CANTIDAD PRESENTACION:sql:"+sql_aux);
        Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
        ResultSet rs=st.executeQuery(sql_aux);
        while (rs.next()){
            String codigo=rs.getString(1);
            cantidadPresentacion=rs.getInt(2);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return cantidadPresentacion;
}
/***************************************************************/
/* METODO PARA CARGAR PRECIO POR PRESENTACION Y AREA */
/***************************************************************/
public float precioPresentacion(String codPresentacion,String codArea){
    float precioPresentacion=0;
    try{
        con=Util.openConnection(con);
        String sql_aux="select cod_presentacion,precio_ventacorriente from presentaciones_producto_datoscomerciales";
        sql_aux+=" where cod_presentacion="+codPresentacion+" and cod_area_empresa="+codArea;
        System.out.println("precioPresentacion:"+sql_aux);
        Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
        ResultSet rs=st.executeQuery(sql_aux);
        while (rs.next()){
            String codigo=rs.getString(1);
            precioPresentacion=rs.getFloat(2);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return precioPresentacion;
}
/***************************************************************/
/* METODO PARA CARGAR NOMBRE CLIENTE */
/***************************************************************/
public String nombreCliente(String codCliente){
    String nombreCliente="";
    try{
        con=Util.openConnection(con);
        String sql_aux="select cod_cliente,nombre_cliente from clientes";
        sql_aux+=" where cod_cliente="+codCliente;
        System.out.println("clienteSql:"+sql_aux);
        Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
        ResultSet rs=st.executeQuery(sql_aux);
        while (rs.next()){
            String codigo=rs.getString(1);
            nombreCliente=rs.getString(2);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return nombreCliente;
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
            <table align="center" width="90%">
                <tr >
                    <td colspan="3" align="center" >
                        <h4>Ventas por Cliente Individual Resumido</h4>
                    </td>
                </tr>
                <%            
                
                String codArea=request.getParameter("codArea");
                String codCliente=request.getParameter("codCliente");
                String nombreClienteF=request.getParameter("nombreCliente");
                String codCadena=request.getParameter("codCadena");
                String codRed=request.getParameter("codRed");
                String fechaInicio=request.getParameter("fecha1");
                String fechaFinal=request.getParameter("fecha2");
                String codLineaMkt=request.getParameter("codLinea");
                String nombreLinea=request.getParameter("nombreLinea");
                String codTipoClienteF=request.getParameter("codTipoClienteF");
                String nombreTipoClienteF=request.getParameter("nombreTipoClienteF");
                String todoTipoClienteF=request.getParameter("todoTipoClienteF");
                String todoClienteF=request.getParameter("todoClienteF");
                String todoLineaF=request.getParameter("todoLineaF");
                
                System.out.println("codArea:"+codArea);
                System.out.println("codCliente:"+codCliente);
                System.out.println("codCadena:"+codCadena);
                System.out.println("codRed:"+codRed);
                System.out.println("fechaInicio:"+fechaInicio);
                System.out.println("fechaFinal:"+fechaFinal);
                System.out.println("codLineaMkt:"+codLineaMkt);
                System.out.println("nombreLinea:"+nombreLinea);
                System.out.println("codTipoClienteF:"+codTipoClienteF);
                System.out.println("nombreTipoClienteF:"+nombreTipoClienteF);
                System.out.println("nombreClienteF:"+nombreClienteF);
                
                System.out.println("todoTipoClienteF:"+todoTipoClienteF);
                System.out.println("todoClienteF:"+todoClienteF);
                System.out.println("todoLineaF:"+todoLineaF);
                if(todoClienteF.equals("1")){
                    nombreClienteF="Todos";
                }
                if(todoTipoClienteF.equals("1")){
                    nombreTipoClienteF="Todos";
                }
                if(todoLineaF.equals("1")){
                    nombreLinea="Todos";
                }
                String fechaInicioArray[]=fechaInicio.split("/");
                String fechaFinalArray[]=fechaFinal.split("/");
                String fechaInicioFormato=fechaInicioArray[2]+"-"+fechaInicioArray[1]+"-"+fechaInicioArray[0];
                String fechaFinalFormato=fechaFinalArray[2]+"-"+fechaFinalArray[1]+"-"+fechaFinalArray[0];
                int codAlmacen=0;
                double sumTotalMonto=0;
                try{
                    con=Util.openConnection(con);
                    /***************************************************************/
                    /* QUERY =========> NOMBRE DE LA AGENCIA*/
                    /***************************************************************/
                    String sql_10="select nombre_area_empresa from areas_empresa where cod_area_empresa="+codArea;
                    System.out.println("sql_11111111111111:"+sql_10);
                    Statement st_10=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet rs_10=st_10.executeQuery(sql_10);
                    String mombreAreaEmpresa="";
                    if(rs_10.next()){
                        mombreAreaEmpresa=rs_10.getString("nombre_area_empresa");
                    }
                    st_10.close();
                    rs_10.close();
                    String sql_A="select cod_almacen_venta from ALMACENES_VENTAS where cod_area_empresa="+codArea;
                    System.out.println("sql_11111111111111:"+sql_A);
                    Statement st_A=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet rs_A=st_A.executeQuery(sql_A);
                    if(rs_A.next()){
                        codAlmacen=rs_A.getInt("cod_almacen_venta");
                    }
                    st_A.close();
                    rs_A.close();
                    String sqlC="select nombre_cliente from clientes where cod_cliente in ("+codCliente+")";
                    System.out.println("sql_CLIENTE:"+sqlC);
                    Statement stC=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet rsC=stC.executeQuery(sqlC);
                    String nombreCliente="";
                    if(rsC.next()){
                        nombreCliente=rsC.getString("nombre_cliente");
                    }
                    stC.close();
                    rsC.close();
                    String sqlCC="select cc.NOMBRE_CADENACLIENTE from clientes c,CADENAS_CLIENTE cc where c.cod_cadenacliente=cc.COD_CADENACLIENTE and cC.COD_CADENACLIENTE="+codCadena;
                    System.out.println("sql_CADENACLIENTE:"+sqlCC);
                    Statement stCC=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet rsCC=stCC.executeQuery(sqlCC);
                    String nombreCadenaCliente="";
                    if(rsCC.next()){
                        nombreCadenaCliente=rsCC.getString(1);
                    }
                    stCC.close();
                    rsCC.close();
                    String sqlR="select cc.NOMBRE_REDCLIENTE from clientes c,REDES_CLIENTE cc where c.cod_redcliente=cc.COD_REDCLIENTE and c.COD_REDCLIENTE="+codRed;
                    System.out.println("sql_REDCLIENTE:"+sqlR);
                    Statement stR=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet rsR=stR.executeQuery(sqlR);
                    String nombreRedCliente="";
                    if(rsR.next()){
                        nombreRedCliente=rsR.getString(1);
                    }
                    stR.close();
                    rsR.close();
                %>                        
                <tr>
                    <td align="left" width="15%"><img src="../../img/logo_cofar.png"></td>
                    <td align="left" class="outputText2" width="60%" >
                        <%
                        if(!codCadena.equals("0")){%>                        
                        <b>Cadena Cliente&nbsp;::&nbsp;</b><%=nombreCadenaCliente%><br>
                        <%}
                        if(!codRed.equals("0")){%>
                        <b>Red Cliente&nbsp;::&nbsp;</b><%=nombreRedCliente%><br>
                        <%}%>
                        <b>Linea&nbsp;::&nbsp;</b><%=nombreLinea%><br>
                        <b>Tipo de Cliente&nbsp;::&nbsp;</b><%=nombreTipoClienteF%><br>
                        <b>Nobre Cliente&nbsp;::&nbsp;</b><%=nombreClienteF%>
                    </td>
                    <td width="25%">                
                        <table border="0" class="outputText2" width="100%" >
                            <tr>
                                <td colspan="2" align="right"><b>Fecha Inicio&nbsp;::&nbsp;</b><%=fechaInicio%><br><b>Fecha &nbsp;Final&nbsp;::&nbsp;</b><%=fechaFinal%></td>
                            </tr>
                            <tr>
                                <td colspan="2" align="right"><h5><%=mombreAreaEmpresa%></h5></td>
                            </tr>
                        </table>    
                    </td>                        
                </tr>
                <%
                } catch (SQLException e) {
                    e.printStackTrace();
                }
                %>
            </table>                         
            <table  align="center" class="tablaFiltroReporte" width="90%">
                <tr class="tituloCampo">                    
                    <td align="center" class="bordeNegroTdMod" colspan="8"><b>Código</b></td>
                    <td align="center" class="bordeNegroTdMod" colspan="8"><b>Código Anterior</b></td>
                    <td align="center" class="bordeNegroTdMod" colspan="8"><b>Producto</b></td>
                    <td align="center" class="bordeNegroTdMod" colspan="8"><b>Cantidad</b></td>
                    <td align="center" class="bordeNegroTdMod" colspan="8"><b>Cantidad Unitaria</b></td>
                    <td align="center" class="bordeNegroTdMod" colspan="8"><b>Precio Promedio</b></td>
                    <td align="center" class="bordeNegroTdMod" colspan="8"><b>Monto</b></td>                    
                </tr> 
                <%
                NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
                DecimalFormat form = (DecimalFormat)nf;
                form.applyPattern("#,###.00");
                con.close();
                try{
                    con=Util.openConnection(con);
                    String sql_1="select DISTINCT (sv.cod_presentacion),pp.NOMBRE_PRODUCTO_PRESENTACION,pp.cantidad_presentacion,pp.cod_anterior";
                    sql_1+=" from SALIDAS_VENTAS s,SALIDAS_DETALLEVENTAS sv,PRESENTACIONES_PRODUCTO pp";
                    sql_1+=" where s.cod_salidaventa = sv.cod_salidaventas and sv.cod_presentacion = pp.cod_presentacion and";
                    sql_1+=" s.cod_almacen_venta = "+codAlmacen+" and s.fecha_salidaventa BETWEEN '"+fechaInicioFormato+" 00:00:00' and '"+fechaFinalFormato+" 23:59:59' ";
                    sql_1+=" AND pp.COD_LINEAMKT in("+codLineaMkt+")";
                    sql_1+=" and s.cod_cliente<>0 and s.COD_ESTADO_SALIDAVENTA=1 and s.COD_TIPOSALIDAVENTAS=3";
                    //sql_1+=" and pp.cod_estado_registro=1";
                    if(!codRed.equals("0")){
                        sql_1+=" and s.cod_cliente in (select c.cod_redcliente from clientes c,REDES_CLIENTE cc where c.cod_redcliente=cc.COD_REDCLIENTE and cc.COD_REDCLIENTE="+codRed+")";
                    }
                    sql_1+=" and s.cod_cliente in ("+codCliente+")";
                    if(!codCadena.equals("0")){
                        sql_1+=" and s.cod_cliente in (select c.cod_cliente from clientes c,CADENAS_CLIENTE cc where c.cod_cadenacliente=cc.COD_CADENACLIENTE and cc.COD_CADENACLIENTE="+codCadena+")";
                    }
                    sql_1+=" order by pp.NOMBRE_PRODUCTO_PRESENTACION";
                    System.out.println("sql_111111111111111111111"+sql_1);
                    Statement st_1=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet rs_1=st_1.executeQuery(sql_1);
                    int sumTotalCantidad=0;int sumTotalCantidadUnitaria=0;
                    double sumTotalPrecioPromedio=0;double sumTotalPrecioReal=0;
                    while(rs_1.next()){
                        String codPresentacion=rs_1.getString(1);
                        String nombrePresentacion=rs_1.getString(2);
                        float cantidadPresentacion=rs_1.getFloat(3);
                        String codAnterior=rs_1.getString(4);
                        String sql_2="select sdv.cantidad,sdv.cantidad_unitaria,sdv.precio_lista,";
                        sql_2+=" sdv.porcentaje_aplicadoprecio,sv.porcentaje_descuento";
                        sql_2+=" from SALIDAS_VENTAS sv,SALIDAS_DETALLEVENTAS sdv";
                        sql_2+=" where sv.cod_salidaventa = sdv.cod_salidaventas and sv.COD_ESTADO_SALIDAVENTA=1 and sv.COD_TIPOSALIDAVENTAS=3";
                        sql_2+=" and sv.fecha_salidaventa BETWEEN '"+fechaInicioFormato+" 00:00:00' and '"+fechaFinalFormato+" 23:59:59'  and";
                        sql_2+=" sdv.cod_presentacion = "+codPresentacion;
                        if(!codRed.equals("0")){
                            sql_2+=" and sv.cod_cliente in (select c.cod_redcliente from clientes c,REDES_CLIENTE cc where c.cod_redcliente=cc.COD_REDCLIENTE and cc.COD_REDCLIENTE="+codRed+")";
                        }
                        sql_2+=" and sv.cod_cliente in("+codCliente+")";
                        if(!codCadena.equals("0")){
                            sql_2+=" and sv.cod_cliente in (select c.cod_cliente from clientes c,CADENAS_CLIENTE cc where c.cod_cadenacliente=cc.COD_CADENACLIENTE and cc.COD_CADENACLIENTE="+codCadena+")";
                        }
                        System.out.println("sql_22222222222222222222"+sql_2);
                        Statement st_2=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                        ResultSet rs_2=st_2.executeQuery(sql_2);
                        int sumCantidad=0;int sumCantidadUnitaria=0;
                        double precioPromedio=0;int cont=0;
                        double sumPrecioVenta=0;double sumPrecioPromedio=0;
                        double sumMonto=0;
                        while(rs_2.next()){
                            int cantidad=rs_2.getInt(1);
                            int cantidadUnitaria=rs_2.getInt(2);
                            double precioLista=rs_2.getDouble(3);
                            int porcentajeAplicadoPrecio=rs_2.getInt(4);
                            int porcentaDescuentoTotal=rs_2.getInt(5);
                            double cantidadAux=0;
                            if(cantidadPresentacion!=0.0){
                                cantidadAux=(float)cantidadUnitaria/cantidadPresentacion;
                            }
                            cantidadAux=cantidadAux+cantidad;
                            double monto=cantidadAux*precioLista;
                            double  monto1=0;double  monto2=0;
                            monto1=monto-(monto*porcentajeAplicadoPrecio/100);
                            monto2=monto1-(monto1*porcentaDescuentoTotal/100);
                            sumPrecioVenta=sumPrecioVenta+precioLista;
                            sumCantidad=sumCantidad+cantidad;
                            sumCantidadUnitaria=sumCantidadUnitaria+cantidadUnitaria;
                            sumMonto=sumMonto+monto2;
                            cont++;
                            /**************************/
                            sumTotalCantidad=sumTotalCantidad+cantidad;
                            sumTotalCantidadUnitaria=sumTotalCantidadUnitaria+cantidadUnitaria;
                        }
                        st_2.close();
                        rs_2.close();
                        sumPrecioPromedio=sumPrecioVenta/cont;
                        sumTotalPrecioPromedio=sumTotalPrecioPromedio+sumPrecioPromedio;
                        sumTotalPrecioReal=sumTotalPrecioReal+sumMonto;
                        String sumMontoAux=form.format(sumMonto);
                        String sumPrecioPromedioAux=form.format(sumPrecioPromedio);
                %>
                <tr>
                    <td  class="bordeNegroTdMod" colspan="8" >&nbsp;&nbsp;<%=codPresentacion%></td>
                    <td  class="bordeNegroTdMod" colspan="8" >&nbsp;&nbsp;<%=codAnterior%></td>
                    <td  class="bordeNegroTdMod" colspan="8" >&nbsp;&nbsp;<%=nombrePresentacion%></td>
                    <td  class="bordeNegroTdMod" colspan="8" align="right">&nbsp;&nbsp;<%=sumCantidad%></td>
                    <td  class="bordeNegroTdMod" colspan="8" align="right">&nbsp;&nbsp;<%=sumCantidadUnitaria%></td>
                    <td  class="bordeNegroTdMod" colspan="8" align="right">&nbsp;&nbsp;<%=sumPrecioPromedioAux%></td>
                    <td  class="bordeNegroTdMod" colspan="8" align="right">&nbsp;&nbsp;<%=sumMontoAux%></td>
                </tr>
                <%
                    }
                    st_1.close();
                    rs_1.close();
                    String sumTotalPrecioPromedioAux=form.format(sumTotalPrecioPromedio);
                    String sumTotalPrecioRealAux=form.format(sumTotalPrecioReal);
                %>
                <tr>
                    <td  class="bordeNegroTdMod" align="right" colspan="24" ><b>TOTAL</b>&nbsp;&nbsp;</td>
                    <td  class="bordeNegroTdMod" colspan="8" align="right"><b>&nbsp;&nbsp;<%=sumTotalCantidad%></b></td>
                    <td  class="bordeNegroTdMod" colspan="8" align="right"><b>&nbsp;&nbsp;<%=sumTotalCantidadUnitaria%></b></td>
                    <td  class="bordeNegroTdMod" colspan="8" align="right"><b>&nbsp;&nbsp;<%=sumTotalPrecioPromedioAux%></b></td>
                    <td  class="bordeNegroTdMod" colspan="8" align="right"><b>&nbsp;&nbsp;<%=sumTotalPrecioRealAux%></b></td>
                </tr>
                <%
                } catch (SQLException e) {
                    e.printStackTrace();
                }
                %>
            </table>                          
        </form>        
    </body>    
</html>
