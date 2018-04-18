
<%@ page import="com.cofar.util.*" %>
<%@ page import="com.cofar.web.*" %>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.text.DecimalFormat"%> 
<%@ page import = "java.text.NumberFormat"%> 
<%@ page import = "java.util.Locale"%> 
<%@ page import = "org.joda.time.DateTime"%> 
<%@ page import = "java.util.*"%> 
<%@ page import = "java.text.*"%> 
<%@ page import = "java.text.DecimalFormat"%> 
<%@ page import = "java.text.NumberFormat"%> 
<%@ page import = "java.util.Locale"%> 
<%!

Connection con=null;
public Double cantidadPresentacion(String codPresentacion){
    Double cantidadPresentacion = 0.0;
    try{
                String consulta =" SELECT cantidad_presentacion " +
                        "FROM presentaciones_producto" +
                        " where cod_presentacion="+codPresentacion;
                System.out.println("consulta " +consulta);
                Connection con = null;
                con = Util.openConnection(con);
                Statement st = con.createStatement();
                ResultSet rs1 = st.executeQuery(consulta);
                while (rs1.next()){
                    cantidadPresentacion=rs1.getDouble("cantidad_presentacion");
                }
                }catch(Exception e){ e.printStackTrace();}
    return cantidadPresentacion;
}
%>
<link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
<html>
    <body>
        <%String fechaInicio = request.getParameter("fecha_inicio");
            String fechaFinal = request.getParameter("fecha_final");
            String fechaFinalF=fechaFinal;
            //String codPresentacion = request.getParameter("codproducto");
            String codAlmacenVenta = request.getParameter("codAlmacenP");
            String nombreAlmacenVenta = request.getParameter("nombreAlmacenP");
            String codAlmacen = request.getParameter("codAlmacenP");
            String nombreAlmacen = request.getParameter("nombreAlmacenP");
            String codPresentacion1 = request.getParameter("codPresentacionP");
            String nombrePresentacion1 = request.getParameter("nombrePresentacionP");
            String codAreaEmpresa = request.getParameter("codAreaEmpresa");
            //System.out.println("nombrepresentacion....... "+ nombrePresentacion1);
            //System.out.println("codpresentacion....... "+ codPresentacion1);
            Double saldoAnteriorCajasTotal = 0.0;
            Double saldoAnteriorUnidsTotal = 0.0;
            Double ingresoCajasTotal = 0.0;
            Double ingresoUnidsTotal = 0.0;
            Double salidasCajasTotal = 0.0;
            Double salidasUnidsTotal = 0.0;
            Double saldoActualCajasTotal = 0.0;
            Double saldoActualUnidsTotal = 0.0;

            



            %>
        <div align="center"><b>Reporte de Consolidacion Trimestral</b>
        <table class="outputText0" width="50%">
            <tr><td><b>PRODUCTO:</b></td><td><%=nombrePresentacion1%></td></tr>
            <tr><td><b>ALMACENES:</b></td><td><%=nombreAlmacen%></td></tr>
            <tr><td><b>FECHAS:</b></td><td><%=fechaInicio%></td></tr>
            <tr><td><b>FECHAS:</b></td><td><%=fechaFinal%></td></tr>
        </table>
        </div>
        <form method="post" action="">
            <div align="center">
            <%
            

            //codPresentacion = codPresentacion.trim();
            String codPresentacion = "";

            

            String[] vectorFechaInicio = fechaInicio.split("/");
            String[] vectorFechaFinal = fechaFinal.split("/");
            String fechaInicio1=vectorFechaInicio[2]+"/"+vectorFechaInicio[1]+"/"+vectorFechaInicio[0];
            String fechaFinal1=vectorFechaFinal[2]+"/"+vectorFechaFinal[1]+"/"+vectorFechaFinal[0];
            System.out.println("entro");
            
            out.print("<table class='outputText0' cellpadding='0' cellspacing='0' style='border:1px solid black'>");
            out.print("<tr><td style='border:1px solid black'><b>ALMACEN</b></td><td style='border:1px solid black'><b>SALDO ANTERIOR CAJAS</b></td><td style='border:1px solid black'><b>SALDO ANTERIOR UNIDADES</b></td><td style='border:1px solid black'><b>INGRESO CAJAS</b></td><td style='border:1px solid black'><b>INGRESO UNIDADES</b></td><td style='border:1px solid black'><b>SALIDAS CAJAS</b></td><td style='border:1px solid black'><b>SALIDAS UNIDADES</b></td><td style='border:1px solid black'><b>SALDO ACTUAL CAJAS</b></td><TD style='border:1px solid black'><b>SALDO ACTUAL UNIDADES</b></TD></tr>");
            String[] codPresentacions = codPresentacion1.split(",");
            String[] nombrePresentacions = nombrePresentacion1.split(",");
            
            
            for(int i=0;i<codPresentacions.length;i++){
                codPresentacion = codPresentacions[i];
                if(!codPresentacion.trim().equals("")){
                    String consulta = " select COD_ALMACEN_VENTA ,COD_TIPOALMACENVENTA,	NOMBRE_ALMACEN_VENTA,	COD_AREA_EMPRESA,	COD_ESTADO_REGISTRO,	OBS_ALMACEN_VENTA," +
                            "ingresos_total_anterior	,ingresos_total_anterior_unitario,	salidas_total_anterior,	salidas_total_anterior_unitario," +
                            "ingresos_total,	ingresos_total_unitario,	salidas_total,	salidas_total_unitario" +
                            " from ALMACENES_VENTAS a" +
                            " outer apply (SELECT ISNULL(sum(iad.cantidad), 0) as ingresos_total_anterior,ISNULL(sum(iad.cantidad_unitaria), 0) as ingresos_total_anterior_unitario" +
                            " FROM ingresos_detalleventas iad,ingresos_ventas ia where iad.cod_ingresoventas = ia.cod_ingresoventas and ia.COD_AREA_EMPRESA = iad.COD_AREA_EMPRESA and" +
                            " ia.cod_estado_ingresoventas <> 2 and ia.COD_AREA_EMPRESA = '"+codAreaEmpresa+"' and iad.cod_presentacion = '"+codPresentacion+"' and ia.cod_almacen_venta = a.COD_ALMACEN_VENTA " +
                            " and ia.fecha_ingresoventas < '"+fechaInicio1+" 00:00:00') ingr" +
                            " outer apply (SELECT ISNULL(sum(sad.cantidad_total), 0) as salidas_total_anterior, ISNULL(sum(sad.cantidad_unitariatotal), 0) as salidas_total_anterior_unitario" +
                            " FROM salidas_detalleventas sad, salidas_ventas sa where sad.cod_salidaventas = sa.cod_salidaventa and sa.COD_AREA_EMPRESA = sad.COD_AREA_EMPRESA and" +
                            " sa.COD_AREA_EMPRESA = '"+codAreaEmpresa+"' and sa.cod_estado_salidaventa <> 2 and sad.cod_presentacion = '"+codPresentacion+"' and sa.cod_almacen_venta = a.COD_ALMACEN_VENTA and" +
                            " sa.fecha_salidaventa < '"+fechaInicio1+" 00:00:00') salid" +
                            " outer apply (SELECT ISNULL(sum(iad.cantidad), 0) as ingresos_total,ISNULL(sum(iad.cantidad_unitaria), 0) as ingresos_total_unitario" +
                            " FROM ingresos_detalleventas iad, ingresos_ventas ia where iad.cod_ingresoventas = ia.cod_ingresoventas and ia.COD_AREA_EMPRESA = iad.COD_AREA_EMPRESA and" +
                            " ia.cod_estado_ingresoventas <> 2 and ia.COD_AREA_EMPRESA = '"+codAreaEmpresa+"' and iad.cod_presentacion = '"+codPresentacion+"' and ia.cod_almacen_venta = a.COD_ALMACEN_VENTA " +
                            " and ia.fecha_ingresoventas between '"+fechaInicio1+" 00:00:00' and '"+fechaFinal1+" 23:59:59') ingr1" +
                            " outer apply (SELECT ISNULL(sum(sad.cantidad_total), 0) as salidas_total, ISNULL(sum(sad.cantidad_unitariatotal), 0) as salidas_total_unitario" +
                            " FROM salidas_detalleventas sad,salidas_ventas sa where sad.cod_salidaventas = sa.cod_salidaventa and sa.COD_AREA_EMPRESA = sad.COD_AREA_EMPRESA and" +
                            " sa.COD_AREA_EMPRESA = '"+codAreaEmpresa+"' and sa.cod_estado_salidaventa <> 2 and sad.cod_presentacion = '"+codPresentacion+"' and sa.cod_almacen_venta = a.COD_ALMACEN_VENTA and" +
                            " sa.fecha_salidaventa between '"+fechaInicio1+" 00:00:00' and '"+fechaFinal1+" 23:59:59') salid1" +
                            " where a.COD_ALMACEN_VENTA in ("+codAlmacen+") ";
                    System.out.println("consulta " + consulta);
                    Connection con = null;
                    con = Util.openConnection(con);
                    Statement st = con.createStatement();
                    ResultSet rs = st.executeQuery(consulta);
                    Double cantidadPresentacion = this.cantidadPresentacion(codPresentacion);
                    while(rs.next()){
                        out.print("<tr>");
                        String nombreAlmacenI = rs.getString("NOMBRE_ALMACEN_VENTA");
                        Double ingresoTotalAnterior = rs.getDouble("ingresos_total_anterior");
                        Double ingresoTotalAnteriorUnitario = rs.getDouble("ingresos_total_anterior_unitario");
                        Double salidasTotalAnterior = rs.getDouble("salidas_total_anterior");
                        Double salidasTotalAnteriorUnitario = rs.getDouble("salidas_total_anterior_unitario");

                        Double ingresoTotal = rs.getDouble("ingresos_total");
                        Double ingresoTotalUnitario = rs.getDouble("ingresos_total_unitario");
                        Double salidasTotal = rs.getDouble("salidas_total");
                        Double salidasTotalUnitario = rs.getDouble("salidas_total_unitario");

                        Double cantidadRestanteAnterior=ingresoTotalAnteriorUnitario -salidasTotalAnteriorUnitario;
                        Double cantidadRestanteAnteriorCajas=ingresoTotalAnterior -salidasTotalAnterior;
                        while(cantidadRestanteAnterior<0){
                            cantidadRestanteAnterior=cantidadRestanteAnterior+cantidadPresentacion;
                            cantidadRestanteAnteriorCajas=cantidadRestanteAnteriorCajas-1;
                        }
                        Double saldoCajas = cantidadRestanteAnteriorCajas+ ingresoTotal - salidasTotal;
                        Double saldoUnitario = cantidadRestanteAnterior + ingresoTotalUnitario - salidasTotalUnitario;
                        //System.out.println("-"+cantidadRestanteAnterior + " + " + ingresoTotalAnteriorUnitario+ " - "  +salidasTotalUnitario);

                        while(saldoUnitario<0){
                            saldoUnitario=saldoUnitario+cantidadPresentacion;
                            saldoCajas=saldoCajas-1;
                        }
                        
                        out.print("<td style='border:1px solid black'>"+nombreAlmacenI+"<br/>"+nombrePresentacions[i]+"</td>" +
                                  "<td style='border:1px solid black'>"+cantidadRestanteAnteriorCajas+"</td>" +
                                  "<td style='border:1px solid black'>"+cantidadRestanteAnterior+"</td>");
                        out.print("<td style='border:1px solid black'>"+ingresoTotal+"</td>" +
                                  "<td style='border:1px solid black'>"+ingresoTotalUnitario+"</td>" +
                                  "<td style='border:1px solid black'>"+salidasTotal+"</td>" +
                                  "<td style='border:1px solid black'>"+salidasTotalUnitario+"</td>");
                        out.print("<td style='border:1px solid black'>"+saldoCajas+"</td><td style='border:1px solid black'>"+saldoUnitario+"</td>");

                        saldoAnteriorCajasTotal = saldoAnteriorCajasTotal + cantidadRestanteAnteriorCajas;
                        saldoAnteriorUnidsTotal = saldoAnteriorUnidsTotal + cantidadRestanteAnterior;
                        System.out.println("valores " + ingresoTotal);
                        ingresoCajasTotal = ingresoCajasTotal + ingresoTotal;
                        ingresoUnidsTotal = ingresoUnidsTotal + ingresoTotalUnitario;
                        salidasCajasTotal = salidasCajasTotal + salidasTotal;
                        salidasUnidsTotal = salidasUnidsTotal + salidasTotalUnitario;
                        saldoActualCajasTotal = saldoActualCajasTotal + saldoCajas;
                        saldoActualUnidsTotal = saldoActualUnidsTotal + saldoUnitario;
                        out.print("</tr>");
                    }
                }
            }
            
            out.print("<tr><td style='border:1px solid black'></td><td style='border:1px solid black'><b>"+saldoAnteriorCajasTotal+"</b></td><td style='border:1px solid black'><b>"+saldoAnteriorUnidsTotal+"</b></td><td style='border:1px solid black'><b>"+ingresoCajasTotal+"</b></td><td style='border:1px solid black'><b>"+ingresoUnidsTotal+"</b></td><td style='border:1px solid black'><b>"+salidasCajasTotal+"</b></td><td style='border:1px solid black'><b>"+salidasUnidsTotal+"</b></td><td style='border:1px solid black'><b>"+saldoActualCajasTotal+"</b></td><TD style='border:1px solid black'><b>"+saldoActualUnidsTotal+"</b></TD></tr>");
            out.print("</table>");



            

            


            

            %>
                       
            
            
            </div>
        </form>
        <table style="border-width:thin" cellpadding="0" cellspacing="0">
            <tr style="border-width:1px;border-color:black"></tr>

        </table>
        <script type="text/javascript" language="JavaScript"  src="../../css/dlcalendar.js"></script>
    </body>
</html>