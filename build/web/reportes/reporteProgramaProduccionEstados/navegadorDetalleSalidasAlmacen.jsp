
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
    </head>
    <body>
        <h3 align="center">Detalle de Salida Almacen</h3>
        <br>
        <form target="_blank" id="form" name="form">
            <table align="center" width="90%">

                <%
                
                NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
                DecimalFormat form = (DecimalFormat)nf;
                form.applyPattern("#,###");
                String codSalidaAlmacen=request.getParameter("codSalidaAlmacen")==null?"0":request.getParameter("codSalidaAlmacen");
                String codAlmacen=request.getParameter("codAlmacen")==null?"0":request.getParameter("codAlmacen");
                    //codOrdenCompra = "10069";                
                %>                
            </table>
            <br>
            <br>
                <%

                    //codOrdenCompra = "10069";

                    String consulta = " select s.COD_SALIDA_ALMACEN,s.NRO_SALIDA_ALMACEN,s.COD_LOTE_PRODUCCION,s.FECHA_SALIDA_ALMACEN,cp.nombre_prod_semiterminado, " +
                            " prp.NOMBRE_PRODUCTO_PRESENTACION,a.NOMBRE_AREA_EMPRESA,t.NOMBRE_TIPO_SALIDA_ALMACEN " +
                            " from SALIDAS_ALMACEN s left outer join COMPONENTES_PROD cp on cp.COD_COMPPROD = s.COD_PROD " +
                            " left outer join PRESENTACIONES_PRODUCTO3 prp on prp.cod_presentacion = s.COD_PRESENTACION " +
                            " inner join AREAS_EMPRESA a on a.COD_AREA_EMPRESA = s.COD_AREA_EMPRESA " +
                            " inner join TIPOS_SALIDAS_ALMACEN t on t.COD_TIPO_SALIDA_ALMACEN = s.COD_TIPO_SALIDA_ALMACEN " +
                            " where s.COD_SALIDA_ALMACEN = '"+codSalidaAlmacen+"'   ";

                System.out.println("consulta"+consulta);
                con = Util.openConnection(con);
                Statement st1=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet rs1=st1.executeQuery(consulta);

                if(rs1.next()){
                    out.print(" <table align='center' border='0' style='text-align:left' class='outputText1'> ");
                    out.print(" <tr><td><b> Nro Salida : </b></td> <td> "+(rs1.getString("NRO_SALIDA_ALMACEN")==null?"":rs1.getString("NRO_SALIDA_ALMACEN"))+" </td><td><b>Lote: </b></td> <td> "+(rs1.getString("COD_LOTE_PRODUCCION")==null?"":rs1.getString("COD_LOTE_PRODUCCION"))+" </td> </tr>");
                    out.print(" <tr><td><b>Fecha: </b></td><td> "+(rs1.getDate("FECHA_SALIDA_ALMACEN")==null?"":rs1.getDate("FECHA_SALIDA_ALMACEN"))+" </td> <td><b>Producto :</b></td> <td>"+(rs1.getString("nombre_prod_semiterminado")==null?"":rs1.getString("nombre_prod_semiterminado"))+"</td> </tr>");
                    out.print(" <tr><td><b>Presentacion : </b></td> <td>"+(rs1.getString("NOMBRE_PRODUCTO_PRESENTACION")==null?"":rs1.getString("NOMBRE_PRODUCTO_PRESENTACION"))+"</td> <td><b> Area Destino: </b></td> <td>"+(rs1.getString("NOMBRE_AREA_EMPRESA")==null?"":rs1.getString("NOMBRE_AREA_EMPRESA"))+"</td> </tr>");
                    out.print(" <tr><td><b>Tipo Salida: </b></td><td>"+(rs1.getString("NOMBRE_TIPO_SALIDA_ALMACEN")==null?"":rs1.getString("NOMBRE_TIPO_SALIDA_ALMACEN"))+"</td> <td><b></b></td> <td></td> </tr> ");
                    out.print(" </table> ");
                }

            %>
            <br>
            <table  align="center" width="60%" class="outputText2" style="border : solid #f2f2f2 1px;" cellpadding="0" cellspacing="0">

                <tr class="tablaFiltroReporte">                    
                    <td  align="center" class="bordeNegroTd"><b>Item</b></td>
                    <td  align="center" class="bordeNegroTd"><b>Cantidad</b></td>                    
                    <td  align="center" class="bordeNegroTd"><b>Unidades</b></td>
                </tr>

                <%
                try{                


                consulta = " select sad.COD_SALIDA_ALMACEN,m.COD_MATERIAL,m.NOMBRE_MATERIAL,u.COD_UNIDAD_MEDIDA,u.ABREVIATURA,sad.CANTIDAD_SALIDA_ALMACEN " +
                         " from SALIDAS_ALMACEN_DETALLE sad  " +
                         " inner join materiales m on sad.COD_MATERIAL = m.COD_MATERIAL " +
                         " inner join UNIDADES_MEDIDA u on u.COD_UNIDAD_MEDIDA = sad.COD_UNIDAD_MEDIDA " +
                         " where sad.COD_SALIDA_ALMACEN = '"+codSalidaAlmacen+"' " +
                         " order by m.NOMBRE_MATERIAL "; 

                System.out.println("consulta"+consulta);
                con = Util.openConnection(con);                            
                Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet rs=st.executeQuery(consulta);

                while (rs.next()){                    
                    String codMaterial = rs.getString("COD_MATERIAL");
                    String nombreMaterial = rs.getString("NOMBRE_MATERIAL");
                    String codUnidadMedida = rs.getString("COD_UNIDAD_MEDIDA");
                    String abreviatura = rs.getString("ABREVIATURA");
                    float cantidadSalidaAlmacen = rs.getFloat("CANTIDAD_SALIDA_ALMACEN");
                    
                    out.print("<tr>");                    
                    out.print("<td class='bordeNegroTd' align='right'>"+nombreMaterial+"</td>");
                    out.print("<td class='bordeNegroTd' align='right'>"+cantidadSalidaAlmacen+"</td>");
                    out.print("<td class='bordeNegroTd' align='right'>"+abreviatura +"</td>");
                    
                    out.print("</tr>");
                    
                    }
                
                }catch(Exception e){
                e.printStackTrace();
                }
                %>
               
            </table>
                            


            <table style="background:#BBFFCC"></table>
            
            
            
        </form>
    </body>
</html>