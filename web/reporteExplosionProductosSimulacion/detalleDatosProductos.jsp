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
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>
<%@ page import = "java.text.DecimalFormat"%> 
<%@ page import = "java.text.NumberFormat"%> 
<%@ page import = "java.util.Locale"%> 

<f:view>
    <%
    Connection con=null;
    con =Util.openConnection(con);   
    %>
    <%!
    public double redondear( double numero, int decimales ) {
        return Math.round(numero*Math.pow(10,decimales))/Math.pow(10,decimales);
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
            String codProgramaProd=request.getParameter("cod_programa");
            String sqlNombreItem="select nombre_material from materiales where cod_material="+codItem;
            Statement stNombreItem=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rsNombreItem=stNombreItem.executeQuery(sqlNombreItem);
            rsNombreItem.first();
            String nombreItem=rsNombreItem.getString(1);
            %>
            <h3 align="center">
                Productos que Utilizan el  <br> Item: <%=nombreItem%>
            </h3>
            <table width="95%" align="center" class="outputText2" style="border : solid #f2f2f2 1px;" cellpadding="1" cellspacing="1">
            <tr class="headerClassACliente">  
                <th  align="center" style="border : solid #f2f2f2 1px;">Producto</th>
                <th  align="center" style="border : solid #f2f2f2 1px;">Nro Lotes</th>
                <th  align="center" style="border : solid #f2f2f2 1px;">Cantidad </th>
                
            </tr>  
            <%
            try{
                
                NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
                DecimalFormat form = (DecimalFormat)nf;
                form.applyPattern("#,###.00");
                
                String sqlCompra="SELECT p.CANT_LOTE_PRODUCCION,cp.nombre_prod_semiterminado,ppd.CANTIDAD";
                sqlCompra+=" FROM PROGRAMA_PRODUCCION p,COMPONENTES_PROD cp,PROGRAMA_PRODUCCION_DETALLE ppd ";
                sqlCompra+=" where p.COD_PROGRAMA_PROD='"+codProgramaProd+"' and p.COD_ESTADO_PROGRAMA=4 ";
                sqlCompra+=" and cp.COD_COMPPROD=p.COD_COMPPROD and cp.COD_COMPPROD=ppd.COD_COMPPROD";
                sqlCompra+=" and ppd.COD_COMPPROD=p.COD_COMPPROD and ppd.COD_MATERIAL='"+codItem+"' ";
                sqlCompra+=" and p.COD_PROGRAMA_PROD=ppd.COD_PROGRAMA_PROD";
                System.out.println("sql compra: "+sqlCompra);
                Statement stCompra=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rsCompra=stCompra.executeQuery(sqlCompra);
                double totalCantidad=0;
                while(rsCompra.next()){
                    double cantLote=rsCompra.getDouble(1);
                    String nombreProduto=rsCompra.getString(2);
                    double cantidad=rsCompra.getFloat(3);
                    cantidad=redondear(cantidad,3);
                    String cantidadString=form.format(cantidad);
                    totalCantidad=totalCantidad+cantidad;
                    totalCantidad=redondear(totalCantidad,3);
            %>
            <tr>
                <td style="border : solid #f2f2f2 1px;"><%=nombreProduto%></td>
                <td align="center" style="border : solid #f2f2f2 1px;"><%=cantLote%></td>
                <td align="right" style="border : solid #f2f2f2 1px;"><%=cantidadString%></td>
                
            </tr>
            <%         
                }
            %>
            <tr>
                <td align="right" style="border : solid #f2f2f2 1px;" colspan="2" >TOTAL</td>
                <td align="right" style="border : solid #f2f2f2 1px;"><%=form.format(totalCantidad)%></td>
            </tr>
            <%
            
            }catch(Exception e){
                e.printStackTrace();
            }
            %>
            
        </body>
        
        
    </html>
    
</f:view>

