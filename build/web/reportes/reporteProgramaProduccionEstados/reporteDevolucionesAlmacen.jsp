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
        <h3 align="center">DEVOLUCIONES DE ALMACEN</h3>
        <br>
        <form target="_blank" id="form" name="form">
            <table align="center" width="90%">

                <%
                
                NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
                DecimalFormat form = (DecimalFormat)nf;
                form.applyPattern("#,###");
                String codSalidaAlmacen=request.getParameter("codSalidaAlmacen")==null?"0":request.getParameter("codSalidaAlmacen");
                String codAlmacen=request.getParameter("codAlmacen")==null?"0":request.getParameter("codAlmacen");
                String codDevolucion=request.getParameter("codDevolucion")==null?"0":request.getParameter("codDevolucion");
                    //codOrdenCompra = "10069";
                    //IngresosAlmacen ingresosAlmacen = (IngresosAlmacen)request.getSession().getAttribute("ingresosAlmacen");
                    ManagedAccesoSistema managedAccesoSistema = (ManagedAccesoSistema)request.getSession().getAttribute("managedAccesoSistema");
                    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
                %>
            </table>
            <br>
            <br>
                <%

                    //codOrdenCompra = "10069";

                  String consulta = "  select d.COD_ALMACEN,d.COD_DEVOLUCION,d.NRO_DEVOLUCION,i.nro_ingreso_almacen,i.FECHA_INGRESO_ALMACEN,cp.COD_COMPPROD,cp.nombre_prod_semiterminado,s.COD_SALIDA_ALMACEN,s.NRO_SALIDA_ALMACEN,s.COD_LOTE_PRODUCCION, " +
                          " a.COD_AREA_EMPRESA,a.NOMBRE_AREA_EMPRESA " +
                          " from devoluciones d left outer join INGRESOS_ALMACEN i on i.COD_DEVOLUCION = d.COD_DEVOLUCION" +
                          " left outer join SALIDAS_ALMACEN s on s.COD_SALIDA_ALMACEN = d.COD_SALIDA_ALMACEN" +
                          " left outer join COMPONENTES_PROD cp on cp.COD_COMPPROD = s.COD_PROD" +
                          " left outer join AREAS_EMPRESA a on a.COD_AREA_EMPRESA = s.COD_AREA_EMPRESA" +
                          " where d.COD_DEVOLUCION = '"+ codDevolucion+"'";
                  //and i.COD_ALMACEN = '"+managedAccesoSistema.getAlmacenesGlobal().getCodAlmacen()+"'

                System.out.println("consulta"+consulta);
                con = Util.openConnection(con);
                Statement st1=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet rs1=st1.executeQuery(consulta);
                
                if(rs1.next()){
                    
                    out.print(" <table align='center' width='70%' border='0' style='text-align:left' class='outputText1'> ");
                    out.print(" <tr><td rowspan='4'><img src='../../img/cofar.png' />" +
                            "   </td><td><b> Nro Devolucion : </b></td> <td> "+(rs1.getString("NRO_DEVOLUCION")==null?"":rs1.getString("NRO_DEVOLUCION"))+" </td><td><b>Nro Ingreso: </b></td> <td> "+(rs1.getString("NRO_INGRESO_ALMACEN")==null?"":rs1.getString("NRO_INGRESO_ALMACEN"))+" </td> </tr>");
                    out.print(" <tr><td><b>Fecha: </b></td><td> "+(rs1.getDate("FECHA_INGRESO_ALMACEN")==null?"":sdf.format(rs1.getDate("FECHA_INGRESO_ALMACEN")))+" </td> <td><b>Producto :</b></td> <td>"+(rs1.getString("nombre_prod_semiterminado")==null?"":rs1.getString("nombre_prod_semiterminado"))+"</td> </tr>");
                    out.print(" <tr><td><b>Nro Salida : </b></td> <td>"+(rs1.getString("NRO_SALIDA_ALMACEN")==null?"":rs1.getString("NRO_SALIDA_ALMACEN"))+"</td> <td><b> Lote: </b></td> <td>"+(rs1.getString("COD_LOTE_PRODUCCION")==null?"":rs1.getString("COD_LOTE_PRODUCCION"))+"</td> </tr>");
                    out.print(" <tr><td><b>Area Dpto Destino: </b></td><td>"+(rs1.getString("NOMBRE_AREA_EMPRESA")==null?"":rs1.getString("NOMBRE_AREA_EMPRESA"))+"</td> <td><b></b></td> <td></td> </tr> ");
                    out.print(" </table> ");
                    //salidasAlmacen.setObsSalidaAlmacen(rs1.getString("OBS_SALIDA_ALMACEN"));
                }

            %>
            <br>

            <table  align="center" width="90%" class="outputText2" style="border : solid #f2f2f2 1px;" cellpadding="0" cellspacing="0">


                <tr class="tablaFiltroReporte">
                    <td  align="center" class="bordeNegroTd"><b>Código</b></td>
                    <td  align="center" class="bordeNegroTd"><b>Item</b></td>
                    <td  align="center" class="bordeNegroTd"><b>Cantidad Buenos</b></td>
                    <td  align="center" class="bordeNegroTd"><b>Cantidad Fallados</b></td>
                    <td  align="center" class="bordeNegroTd"><b>Cantidad Fallados Provedor</b></td>
                    
                    <td  align="center" class="bordeNegroTd"><b>Unidades</b></td>
                </tr>

                <%
                try{
                    consulta =" select i.COD_ALMACEN from  INGRESOS_ALMACEN i where i.COD_DEVOLUCION = '"+codDevolucion+"' ";
                    System.out.println("consulta " + consulta);
                    Statement st2=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet rs2=st2.executeQuery(consulta);
                    String codAlmacen2 = "0";
                    if(rs2.next()){
                        codAlmacen2=rs2.getString("cod_almacen");
                    }
               // con = Util.openConnection(con);
                Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet rs;
                boolean frv=false;
                if(!codAlmacen2.equals("12"))
                {
                consulta="select af.COD_ALMACEN_FRV from ALMACENES_FRV af where af.COD_ALMACEN_FRV='"+codAlmacen2+"'";
                rs=st.executeQuery(consulta);
                if(rs.next())
                {
                    frv=true;
                }
                }
                
                consulta = "  select  ISNULL(SUM(dde.CANTIDAD_DEVUELTA),0) as cantBuenas,ISNULL(SUM(dde.CANTIDAD_FALLADOS),0) as cantFallados,ISNULL(SUM(dde.CANTIDAD_FALLADOS_PROVEEDOR),0) as cantFallProv "+
                    ",m.CODIGO_ANTIGUO,m.cod_material,m.NOMBRE_MATERIAL,dd.CANTIDAD_DEVUELTA,u.cod_unidad_medida,u.ABREVIATURA "+
                    "from DEVOLUCIONES_DETALLE dd inner join DEVOLUCIONES_DETALLE_ETIQUETAS dde on dd.COD_DEVOLUCION=dde.COD_DEVOLUCION and dd.COD_MATERIAL=dde.COD_MATERIAL "+
                    "inner join materiales m on m.COD_MATERIAL = dd.COD_MATERIAL inner join UNIDADES_MEDIDA u on u.COD_UNIDAD_MEDIDA = dd.COD_UNIDAD_MEDIDA where dd.COD_DEVOLUCION = '"+codDevolucion+"' "+
                    "group by m.COD_MATERIAL,m.CODIGO_ANTIGUO,m.NOMBRE_MATERIAL,dd.CANTIDAD_DEVUELTA,u.COD_UNIDAD_MEDIDA,u.ABREVIATURA order by m.NOMBRE_MATERIAL ";
                System.out.println("consulta"+consulta);
                 rs=st.executeQuery(consulta);

                while (rs.next()){                    
                    String codMaterial = rs.getString("COD_MATERIAL");
                    String nombreMaterial = rs.getString("NOMBRE_MATERIAL");
                    String codUnidadMedida = rs.getString("COD_UNIDAD_MEDIDA");
                    String abreviatura = rs.getString("ABREVIATURA");
                    float cantidadDevuelta = rs.getFloat("CANTIDAD_DEVUELTA");
                    float cantidadFallados=rs.getFloat("cantFallados");
                    float cantFallProv=rs.getFloat("cantFallProv");
                    String codigoAntiguo = rs.getString("CODIGO_ANTIGUO");
                   // background-color
                    out.print("<tr>");
                    out.print("<td class='bordeNegroTd' align='right'>"+(codigoAntiguo==null?"":codigoAntiguo)+"</td>");
                    out.print("<td class='bordeNegroTd' align='right'>"+nombreMaterial+"</td>");
                    if(!frv&&!codAlmacen2.equals("12"))
                    {
                    out.print("<td class='bordeNegroTd' align='right' bgcolor='#90EE90'>"+cantidadDevuelta+"</td>");
                    }
                    else
                    {
                    out.print("<td class='bordeNegroTd' align='right' >"+cantidadDevuelta+"</td>");
                    }
                    if(frv)
                        {
                    out.print("<td class='bordeNegroTd' align='right' bgcolor='#90EE90'>"+cantidadFallados+"</td>");
                    }
                    else
                    {
                        out.print("<td class='bordeNegroTd' align='right' >"+cantidadFallados+"</td>");
                    }
                    if(codAlmacen2.equals("12"))
                        {
                     out.print("<td class='bordeNegroTd' align='right' bgcolor='#90EE90'>"+cantFallProv+"</td>");
                     }
                    else
                    {
                        out.print("<td class='bordeNegroTd' align='right'>"+cantFallProv+"</td>");
                    }

                    out.print("<td class='bordeNegroTd' align='right'>"+abreviatura +"</td>");
                    out.print("</tr>");
                    }
                }catch(Exception e){
                e.printStackTrace();
                }
                %>
               
            </table>
            <table width="90%" align="center">
            <tr><td>
            Glosa:
            <%--out.print(salidasAlmacen.getObsSalidaAlmacen());--%>
            </td>
            </tr>
            </table>
            <br/><br/><br/><br/><br/>

            <table style="text-align:center" align="center" width="70%">
                <tr><td style="border-bottom-color:black;border-bottom-style:solid;border-bottom-width:thin;border-right-width:20px;border-right-color:white;border-right-style:solid" width="33%"></td>
                <td style="border-bottom-color:black;border-bottom-style:solid;border-bottom-width:thin;border-right-width:20px;border-right-color:white;border-right-style:solid" width="33%"> </td>
                <td style="border-bottom-color:black;border-bottom-style:solid;border-bottom-width:thin" width="33%"> </td></tr>
                <tr class="outputText1"><td><b>Aprobado</b></td><td>Entregado <br/> Nombre y Firma</td><td>Recibido<br/> Nombre y Firma</td></tr>
            </table>

            <%--
            out.print("<td class='bordeNegroTd' align='right'>" +
                            " <a href='#'  onclick=\"openPopup1('navegadorDetalleItemSalidasAlmacen.jsf?codSalidaAlmacen="+codSalidaAlmacen+"&" +
                            "codAlmacen="+codAlmacen+"&codMaterial="+codMaterial+"')\"><img src='../img/areasdependientes.png' /></a></td> ");
                            --%>
                            


            <table style="background:#BBFFCC"></table>
            
            
            
        </form>
    </body>
</html>