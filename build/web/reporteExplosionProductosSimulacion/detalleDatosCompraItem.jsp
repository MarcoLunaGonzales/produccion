<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@ page language="java" %>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.sql.DriverManager"%> 
<%@ page import = "java.sql.ResultSet"%> 
<%@ page import = "java.sql.Statement"%> 
<%@ page import = "org.joda.time.DateTime"%>
<%@ page import="com.cofar.util.*" %>

<f:view>
    <%
    Connection con=null;
    con =Util.openConnection(con);   
    %>
    <%!    public double redondear(double numero, int decimales) {
        return Math.round(numero * Math.pow(10, decimales)) / Math.pow(10, decimales);
    }
    %>
    <html>
        <head>
            <title></title>
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" /> 
        </head>
        <body >
            <%
            String codItem=request.getParameter("codigo");
            String sqlNombreItem="select nombre_material from materiales where cod_material="+codItem;
            Statement stNombreItem=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rsNombreItem=stNombreItem.executeQuery(sqlNombreItem);
            rsNombreItem.first();
            String nombreItem=rsNombreItem.getString(1);
            String estiloFila = "background-color:#99FFFF";
            %>
            <h3 align="center">
                Ultimos datos de Compra <br> Item: <%=nombreItem%>
            </h3>
            <table width="95%" align="center" class="outputText2" style="border : solid #f2f2f2 1px;" cellpadding="1" cellspacing="1">
            <tr class="headerClassACliente">  
                <th  align="center" style="border : solid #f2f2f2 1px;">Proveedor</th>
                <th  align="center" style="border : solid #f2f2f2 1px;">Fecha de Compra</th>
                <th  align="center" style="border : solid #f2f2f2 1px;">Cantidad</th>
                <th  align="center" style="border : solid #f2f2f2 1px;">Unidad de Compra</th>
                <th  align="center" style="border : solid #f2f2f2 1px;">Precio Unitario</th>
                <th  align="center" style="border : solid #f2f2f2 1px;">Precio Total</th>
                <th  align="center" style="border : solid #f2f2f2 1px;">Costo Unitario</th>
            </tr>
            <%
            try{
                
                String sqlCompra=" select p.nombre_proveedor,od.COD_MATERIAL,u.ABREVIATURA,od.CANTIDAD_NETA,od.PRECIO_UNITARIO,";
                sqlCompra+=" od.PRECIO_TOTAL,convert (varchar, o.FECHA_EMISION, 103),m.abreviatura_moneda,ISNULL((";
                sqlCompra+=" select sum(isnull(id.COSTO_UNITARIO_ACTUALIZADO,0)*isnull(id.CANT_TOTAL_INGRESO_FISICO,0))/sum(isnull(id.CANT_TOTAL_INGRESO_FISICO,0))";
                sqlCompra+=" from INGRESOS_ALMACEN i,INGRESOS_ALMACEN_DETALLE id where id.COD_INGRESO_ALMACEN = i.COD_INGRESO_ALMACEN and";
                sqlCompra+=" id.COD_MATERIAL = "+codItem+" and i.COD_ORDEN_COMPRA = o.COD_ORDEN_COMPRA ),0),o.cod_estado_compra";
                sqlCompra+=" from ORDENES_COMPRA o,ORDENES_COMPRA_DETALLE od,proveedores p,UNIDADES_MEDIDA u,MONEDAS m";
                sqlCompra+=" where o.COD_ORDEN_COMPRA = od.COD_ORDEN_COMPRA and o.COD_PROVEEDOR = p.cod_proveedor and";
                sqlCompra+=" od.COD_UNIDAD_MEDIDA = u.cod_unidad_medida and o.cod_moneda = m.cod_moneda and od.COD_MATERIAL = "+codItem+" and";
                sqlCompra+=" o.COD_ESTADO_COMPRA in (2, 5, 6, 7, 13, 14, 15, 17, 18) order by o.FECHA_EMISION desc";
                System.out.println("sql compra: "+sqlCompra);
                Statement stCompra=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rsCompra=stCompra.executeQuery(sqlCompra);
                while(rsCompra.next()){
                    String nombreProveedor=rsCompra.getString(1);
                    String abrev=rsCompra.getString(3);
                    float cantidadNeta=rsCompra.getFloat(4);
                    float precioUnitario=rsCompra.getFloat(5);
                    float precioTotal=rsCompra.getFloat(6);
                    String fechaCompra=rsCompra.getString(7);
                    String nombreMoneda=rsCompra.getString(8);
                    double costoUnitario=rsCompra.getDouble(9);
                    costoUnitario=redondear(costoUnitario,3);
                    int codEstadoCompra = rsCompra.getInt("cod_estado_compra");
                    System.out.println("sql costoUnitario: "+costoUnitario);
            %>
            <tr style="<%=codEstadoCompra==13?estiloFila:""%>">
                <td style="border : solid #f2f2f2 1px;"><%=nombreProveedor%></td>
                <td align="center" style="border : solid #f2f2f2 1px;"><%=fechaCompra%></td>
                <td align="right" style="border : solid #f2f2f2 1px;"><%=cantidadNeta%></td>
                <td align="center" style="border : solid #f2f2f2 1px;"><%=abrev%></td>
                <td align="right" style="border : solid #f2f2f2 1px;"><%=precioUnitario%> (<%=nombreMoneda%>)</td>
                <td align="right" style="border : solid #f2f2f2 1px;"><%=precioTotal%> (<%=nombreMoneda%>)</td>
                <td align="right" style="border : solid #f2f2f2 1px;"><%=costoUnitario%></td>
            </tr>
            <%
                }
                
                
            }catch(Exception e){
                e.printStackTrace();
            }
            %>
            
        </body>
        
        
    </html>
    
</f:view>

