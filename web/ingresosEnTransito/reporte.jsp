<%@ page import ="com.cofar.util.*" %>
<%@ page import="com.cofar.web.*" %>
<%@ page import = "java.sql.*"%>
<html>
    <title>
        Ingresos en Transito Acondicionamiento - APT
    </title>
    <head>
        <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
        
    </head>
    
    <body>
        
        
        
        
        <div align="center">
            <table width="95%" align="center" >
                <tr>
                    
                    <td>
                        <table border="0" class="outputText2" width="60%">
                            <tr>
                                <td align="center" colspan="2" class="tituloCampo"><b>Ingresos en Transito Acondicionamiento - APT</b></td>
                            </tr>
                            
                            
                            <!--<tr>
                                <td align="center"  class="tituloCampo"><b>Campaña:</b></td>
                                <td align="center"  class="tituloCampo">&nbsp;</td>
                                
                                
                            </tr>-->
                        </table>
                    </td>
                </tr>
                
            </table>
        </div>
        
        
        
        <table class="tablaFiltroReporte" width="100%" align="center">
            
            
            <tr  class="tituloCampo">
                <td class="bordeNegroTdMod"><b>N</b></td>
                <td class="bordeNegroTdMod"><b>Nro.Salida Acond.</b></td>
                <td class="bordeNegroTdMod"><b>Fecha</b></td>
                <td class="bordeNegroTdMod"><b>Almacen Acond. Origen</b></td>
                <td class="bordeNegroTdMod"><b>Almacen APT</b></td>
                <td class="bordeNegroTdMod"><b>Producto</b></td>
                <td class="bordeNegroTdMod"><b>Lote</b></td>
                <td class="bordeNegroTdMod"><b>Fecha Vencimiento</b></td>
                <td class="bordeNegroTdMod"><b>Cantidad</b></td>
            </tr>
            
            <%
            try{
                
                Connection con=null;
                con=Util.openConnection(con);
                
               // String values[]=codAreaEmpresa.split(",");
                
                int fila=1;
                //for(String codArea:values){
                    
                    java.text.SimpleDateFormat format=new java.text.SimpleDateFormat ("dd/MM/yyyy");
                    
                String sql=" select sa.NRO_SALIDAACOND,sa.FECHA_SALIDAACOND,(select a.NOMBRE_ALMACENACOND from ALMACENES_ACOND a where a.COD_ALMACENACOND=sa.COD_ALMACENACOND), ";
                sql+=" (select av.NOMBRE_ALMACEN_VENTA from ALMACENES_VENTAS av where av.COD_ALMACEN_VENTA=sa.COD_ALMACEN_VENTA), ";
                sql+=" (select c.nombre_prod_semiterminado from COMPONENTES_PROD c where c.COD_COMPPROD=sd.COD_COMPPROD), ";
                sql+=" sd.COD_LOTE_PRODUCCION,	sd.FECHA_VENC,	sd.CANT_TOTAL_SALIDADETALLEACOND ";
                sql+=" from  SALIDAS_ACOND sa, SALIDAS_DETALLEACOND sd   where sa.COD_SALIDA_ACOND=sd.COD_SALIDA_ACOND ";
                sql+=" and sa.COD_ALMACEN_VENTA not in(0,29)    and sa.COD_ESTADO_SALIDAACOND=1  ";
                sql+=" order by FECHA_SALIDAACOND ";
                
                System.out.println(sql);
                
                Statement stPremios=con.createStatement();
                ResultSet rsPremios=stPremios.executeQuery(sql);
                
                while(rsPremios.next()){%>
            <tr>
                
                <td class="bordeNegroTdMod"><b><%=fila%></b></td>
                <td class="bordeNegroTdMod"><%=rsPremios.getString(1)%></td>
                <td class="bordeNegroTdMod"><%=format.format(  rsPremios.getDate(2)) %></td>
                <td class="bordeNegroTdMod"><%=rsPremios.getString(3)%></td>
                <td class="bordeNegroTdMod"><%=rsPremios.getString(4)%></td>
                <td class="bordeNegroTdMod"><%=rsPremios.getString(5)%></td>
                <td class="bordeNegroTdMod"><%=rsPremios.getString(6)%></td>
                <td class="bordeNegroTdMod"><%=format.format(  rsPremios.getDate(7) )%></td>
                <td class="bordeNegroTdMod"><%=rsPremios.getString(8)%></td>
                
                <% fila++;%>
            </tr>
            <%}
                
                //}%>
            <%
            
            con.close();
            
            }catch(SQLException ex){
            ex.printStackTrace();
            
            }%>
            
            
            
            
        </table>
        
        
    </body>
</html>
