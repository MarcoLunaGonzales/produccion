
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
        <head>
                <style>
                    .tablaReporte
                    {
                        border-top:1px solid #aaaaaa;
                        border-left:1px solid #aaaaaa;
                    }
                    .tablaReporte tr td
                    {
                        padding:4px;
                        border-bottom:1px solid #aaaaaa;
                        border-right:1px solid #aaaaaa;
                    }
                </style>
        </head>
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
            
            out.print("<table class='outputText0 tablaReporte' cellpadding='0' cellspacing='0' >");
            out.print("<tr><td ><b>ALMACEN</b></td><td ><b>SALDO ANTERIOR CAJAS</b></td><td ><b>SALDO ANTERIOR UNIDADES</b></td><td ><b>INGRESO CAJAS</b></td><td ><b>INGRESO UNIDADES</b></td><td ><b>SALIDAS CAJAS</b></td><td ><b>SALIDAS UNIDADES</b></td><td ><b>SALDO ACTUAL CAJAS</b></td><TD ><b>SALDO ACTUAL UNIDADES</b></TD></tr>");
            String[] codPresentacions = codPresentacion1.split(",");
            String[] nombrePresentacions = nombrePresentacion1.split(",");
            int saldoAnteriorCajasTotal=0;
            int saldoAnteriorUnitarioTotal=0;
            int cantidadIngresoCajasTotal=0;
            int cantidadIngresoUnitarioTotal=0;
            int cantidadSalidaCajasTotal=0;
            int cantidadSalidaUnitarioTotal=0;
            int saldoActualCajasTotal=0;
            int saldoActualUnitarioTotal=0;
            for(int i=0;i<codPresentacions.length;i++){
                codPresentacion = codPresentacions[i];
                if(!codPresentacion.trim().equals("")){
                    String consulta = " select COD_ALMACEN_VENTA ,COD_TIPOALMACENVENTA,	NOMBRE_ALMACEN_VENTA,	COD_AREA_EMPRESA,	COD_ESTADO_REGISTRO,	OBS_ALMACEN_VENTA," +
                            "ingresos_total_anterior	,ingresos_total_anterior_unitario,	salidas_total_anterior,	salidas_total_anterior_unitario," +
                            "ingresos_total,	ingresos_total_unitario,	salidas_total,	salidas_total_unitario,pres.cantidad_presentacion" +
                            " ,pres.NOMBRE_PRODUCTO_PRESENTACION" +
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
                            " outer apply(select prp.cantidad_presentacion,prp.NOMBRE_PRODUCTO_PRESENTACION from PRESENTACIONES_PRODUCTO prp where prp.cod_presentacion = '"+codPresentacion+"') pres " +
                            " where a.COD_ALMACEN_VENTA in ("+codAlmacen+") ";
                    System.out.println("consulta cantidad" + consulta);
                    Connection con = null;
                    con = Util.openConnection(con);
                    Statement st = con.createStatement();
                    ResultSet rs = st.executeQuery(consulta);

                    while(rs.next()){
                        out.print("<tr>");
                        int cantidadPresentacion=rs.getInt("cantidad_presentacion");
                        //calculando cantidad unitaria anterior
                        int cantidadTotalUnitariaAnterior=((rs.getInt("ingresos_total_anterior") -rs.getInt("salidas_total_anterior"))*cantidadPresentacion)+
                                                            (rs.getInt("ingresos_total_anterior_unitario")-rs.getInt("salidas_total_anterior_unitario"));
                        int cantidadTotalUnitariaActual=((rs.getInt("ingresos_total")-rs.getInt("salidas_total"))*cantidadPresentacion)+
                                                        (rs.getInt("ingresos_total_unitario")-rs.getInt("salidas_total_unitario"));
                        cantidadTotalUnitariaActual+=cantidadTotalUnitariaAnterior;
                        int cantidadCajasAnterior=(cantidadTotalUnitariaAnterior/cantidadPresentacion);
                        int cantidadUnitariaCajasAnterior=(cantidadTotalUnitariaAnterior%cantidadPresentacion);
                        int cantidadCajasActual=(cantidadTotalUnitariaActual/cantidadPresentacion);
                        int cantidadUnitariaCajasActual=(cantidadTotalUnitariaActual%cantidadPresentacion);
                        out.print("<td >"+rs.getString("NOMBRE_ALMACEN_VENTA")+"<br/>"+rs.getString("NOMBRE_PRODUCTO_PRESENTACION")+"</td>" +
                                  "<td >"+cantidadCajasAnterior+".0</td>" +
                                  "<td >"+cantidadUnitariaCajasAnterior+".0</td>");
                        out.print("<td >"+rs.getInt("ingresos_total")+".0</td>" +
                                  "<td >"+rs.getInt("ingresos_total_unitario")+".0</td>" +
                                  "<td >"+rs.getInt("salidas_total")+".0</td>" +
                                  "<td >"+rs.getInt("salidas_total_unitario")+".0</td>");
                        out.print("<td >"+cantidadCajasActual+".0</td><td >"+cantidadUnitariaCajasActual+".0</td>");

                        saldoAnteriorCajasTotal += cantidadCajasAnterior;
                        saldoAnteriorUnitarioTotal+=cantidadUnitariaCajasAnterior;
                        cantidadIngresoCajasTotal+=rs.getInt("ingresos_total");
                        cantidadIngresoUnitarioTotal+=rs.getInt("ingresos_total_unitario");
                        cantidadSalidaCajasTotal+=rs.getInt("salidas_total");
                        cantidadSalidaUnitarioTotal+=rs.getInt("salidas_total_unitario");
                        saldoActualCajasTotal+=cantidadCajasActual;
                        saldoActualUnitarioTotal+=cantidadUnitariaCajasActual;
                        out.print("</tr>");
                    }
                }
            }
            
            out.print("<tr><td>&nbsp;</td><td ><b>"+saldoAnteriorCajasTotal+".0</b></td>" +
                    "<td ><b>"+saldoAnteriorUnitarioTotal+".0</b></td>" +
                    "<td ><b>"+cantidadIngresoCajasTotal+".0</b></td>" +
                    "<td ><b>"+cantidadIngresoUnitarioTotal+".0</b></td>" +
                    "<td ><b>"+cantidadSalidaCajasTotal+".0</b></td>" +
                    "<td ><b>"+cantidadSalidaUnitarioTotal+".0</b></td>" +
                    "<td ><b>"+saldoActualCajasTotal+".0</b></td>" +
                    "<TD ><b>"+saldoActualUnitarioTotal+".0</b></TD></tr>");
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