<%@ page import="com.cofar.util.*" %>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.text.*"%> 
<%@ page import = "java.util.*"%> 


<%
String fecha1=request.getParameter("fecha1");
String fecha2=request.getParameter("fecha2");


String values1[]=fecha1.split("/");
String values2[]=fecha2.split("/");

String fechaSQL1=values1[2]+"-"+values1[1]+"-"+values1[0];
String fechaSQL2=values2[2]+"-"+values2[1]+"-"+values2[0];



%>
<html>
    <title>
        Reporte De Rendimiento
    </title>
    <head>
        <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
        
    </head>
    
    <body>
        
        
        
        
        <div align="center">
            <table width="100%">
                <tr>
                    <td colspan="3" align="center" >
                        <h4>Reporte De Rendimiento</h4>
                    </td>
                </tr>                    
                <tr>
                    <td align="left" width="20%"><img src="../../img/logo_cofar.png"></td>
                    <td align="left" class="outputText2" width="50%" >
                    
                    <td width="30%">                
                        <table border="0" class="outputText2" width="100%" >
                            <tr>
                                <td colspan="2" align="right"><b>Fecha Inicio&nbsp;::&nbsp;</b><%=fecha1%><br><b>Fecha &nbsp;Final&nbsp;::&nbsp;</b><%=fecha2%></td>
                            </tr>
                            
                        </table>    
                    </td>        
                    
                </tr>
                
            </table>
        </div>
       <table class="tablaFiltroReporte" width="90%" align="center">
            
            
            <tr  class="tituloCampo">
                
                <td class="bordeNegroTdMod"><b>N</b></td>
                <td class="bordeNegroTdMod"><b>Nro.Ingreso</b></td>
                <td class="bordeNegroTdMod"><b>Fecha</b></td>
                
                
                <td class="bordeNegroTdMod"><b>Presentacion</b></td>
                <td class="bordeNegroTdMod"><b>Lote</b></td>
                <td class="bordeNegroTdMod"><b>Ingreso APT.</b></td>
                
                <td class="bordeNegroTdMod"><b>&nbsp;</b></td>
                
                
                
                
                
                
                
            </tr>
            
            <%
            Connection con=null;
            
            try{
                
                NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
                DecimalFormat form = (DecimalFormat)nf;
                form.applyPattern("#,###.00");
                
                
                
                con=Util.openConnection(con);
                
                
                int fila=1;
                
                
                java.text.SimpleDateFormat format=new java.text.SimpleDateFormat("dd/MM/yyyy");
                
                
                
                
                String sql="  select i.NRO_INGRESOVENTAS,i.FECHA_INGRESOVENTAS,p.NOMBRE_PRODUCTO_PRESENTACION,id.COD_LOTE_PRODUCCION,id.CANTIDAD,";
                sql+="  id.CANTIDAD_UNITARIA,id.COD_PRESENTACION,p.cantidad_presentacion ,i.COD_ALMACEN_VENTA,i.COD_SALIDA_ACOND, ";
                sql+="  ( select count(cc.COD_COMPPROD)    from COMPONENTES_PRESPROD cc        where cc.COD_PRESENTACION = p.cod_presentacion)	,i.COD_SALIDA_ACOND ";
                sql+="  from ingresos_ventas i, INGRESOS_DETALLEVENTAS id,PRESENTACIONES_PRODUCTO p ";
                sql+="  where i.COD_AREA_EMPRESA = id.COD_AREA_EMPRESA and        i.COD_INGRESOVENTAS = id.COD_INGRESOVENTAS and ";
                sql+=" i.COD_TIPOINGRESOVENTAS in (1, 2) and        i.FECHA_INGRESOVENTAS between '"+fechaSQL1+" 00:00:00' and ";
                sql+=" '"+fechaSQL2+" 23:59:59'       and        i.COD_ALMACEN_VENTA in (54, 56)        and p.cod_presentacion=id.COD_PRESENTACION ";
                sql+=" and 	( select count(cc.COD_COMPPROD)  from COMPONENTES_PRESPROD cc where cc.COD_PRESENTACION = p.cod_presentacion)>1 ";
                
                
                System.out.println(sql);
                
                Statement stPremios=con.createStatement();
                ResultSet rsPremios=stPremios.executeQuery(sql);
                
                
                
                while(rsPremios.next()){
                    
                    String lote=rsPremios.getString(4);
                     int cod_salidaacond=rsPremios.getInt(10);
                    
                    
                    String cod_presentacion=rsPremios.getString(7);
                    
                    int cantidad_presentacion=rsPremios.getInt(8);
                    
                    
                    int cantidad=rsPremios.getInt(5);
                    int cantidadUnitaria=rsPremios.getInt(6);
                    
                    int cantidadUnitariaTotal=(cantidad*cantidad_presentacion)+cantidadUnitaria;
            
            
            %>
            <tr>
                
                <td class="bordeNegroTdMod"><b><%=fila%></b></td>
                <td class="bordeNegroTdMod"><%=rsPremios.getInt(1)%></td>
                <td class="bordeNegroTdMod"><%=format.format(rsPremios.getDate(2))%></td>
                
                <td class="bordeNegroTdMod"><%=rsPremios.getString(3)%></td>
                
                
                
                <td class="bordeNegroTdMod"><%=lote%></td>
                <td class="bordeNegroTdMod"><%=cantidadUnitariaTotal%></td>
                
                <%
                 System.out.println(rsPremios.getString(1));
                 
                         
                        
                sql=" select sad.COD_COMPPROD,(select cc.nombre_prod_semiterminado     from COMPONENTES_PROD cc      where cc.COD_COMPPROD = sad.COD_COMPPROD   ), ";
                sql+=" sad.CANT_TOTAL_SALIDADETALLEACOND ";
                sql+=" from SALIDAS_ACOND sa,    SALIDAS_DETALLEACOND sad  ";
                sql+=" where sad.COD_SALIDA_ACOND = sa.COD_SALIDA_ACOND and ";
                sql+=" sa.COD_SALIDA_ACOND in ("+cod_salidaacond+")       and sad.COD_PRESENTACION="+cod_presentacion;
                
                        
                        
                System.out.println(sql);
                
                
                Statement st1=con.createStatement();
                ResultSet rs1=st1.executeQuery(sql);
                
                %>
                <td >
                    <table class="tablaFiltroReporte" width="100%" align="center">
                        <tr>
                            <td class="bordeNegroTdMod"><b>Producto<br/>Semiterminado</b></td>
                            <td class="bordeNegroTdMod"><b>Salida Acond.</b></td>
                        </tr>
                        
                        
                        <%  while(rs1.next()){%>
                        <tr>
                            
                            
                            
                            <td ><%=rs1.getString(2)%></td>
                            <td ><%=rs1.getString(3)%></td>
                            
                        </tr>
                        
                        <%}
                        rs1.close();
                        st1.close();
                        %>
                    </table>
                </td>
                
                
                
                
                <% fila++;%>
            </tr>
            <%}
            
            //}%>
            <%
            
            
            
            }catch(SQLException ex){
                ex.printStackTrace();
                
            } finally {
                con.close();
                
            }
            
            %>
            
            
            
            
        </table>
        
        
    </body>
</html>


