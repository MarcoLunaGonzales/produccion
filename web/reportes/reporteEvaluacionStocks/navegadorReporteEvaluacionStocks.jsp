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
<%! Connection con = null;


%>
<%! public String nombrePresentacion1(String codPresentacion) {



        String nombreproducto = "";

        try {
            con = Util.openConnection(con);
            String sql_aux = "select cod_presentacion, nombre_producto_presentacion from presentaciones_producto where cod_presentacion='" + codPresentacion + "'";
            System.out.println("PresentacionesProducto:sql:" + sql_aux);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(sql_aux);
            while (rs.next()) {
                String codigo = rs.getString(1);
                nombreproducto = rs.getString(2);
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
    </head>
    <body>
        <h3 align="center">Reporte de Evaluacion de Stocks</h3>
        <br>
        <form>
            <table align="center" width="90%">

                <%

        NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
        DecimalFormat format = (DecimalFormat) nf;
        format.applyPattern("#,###.00");
        //String codPresentacion="";
        //String nombrePresentacion="";
        String linea_mkt = "";
        String agenciaVenta = "";
        float cantidadTotal = 0f;
        float cantidadTotalUnitaria = 0f;
        double procesoMC = 0;
        double cantLote = 0;
        double cantidadProduccion = 0.0d;
        con = Util.openConnection(con);


        String fechaInicial = request.getParameter("fechaFinalP");
        String fechaFinal = request.getParameter("fechaFinalP");
        String codTipoCliente = request.getParameter("codTipoClienteP");
        String nombreTipoCliente = request.getParameter("nombreTipoClienteP");
        String codAlmacenVentas = request.getParameter("codAlmacenVentaP");
        String nombreAlmacenVentas = request.getParameter("nombreAlmacenVentaP");
        String codGrupo = request.getParameter("codGrupo");


        float saldoCantidad = 0;
        float saldoCantidadUnitaria = 0;
        float saldoCantidadCuar = 0;
        float saldoCantidadUnitariaCuare = 0;

        float saldoCantUnitariaPresentacion = 0;
        float saldoCantUnitariaCuarentena = 0;
        float saldoCantUnitariaAcondicionamiento = 0;
        float saldoCantUnitariaProduccion = 0;
        float cantUnitariaReposicion = 0;
        float cantLotePresentacion = 0;

        //tratamiento de fechas

        String[] arrayFechaInicial = fechaInicial.split("/");
        String[] arrayFechaFinal = fechaFinal.split("/");

        //
        String fechaInicialConsulta = String.valueOf(Integer.valueOf(arrayFechaInicial[2]) - 1) + "/" + arrayFechaInicial[1] + "/" + arrayFechaInicial[0];
        String fechaFinalConsulta = arrayFechaFinal[2] + "/" + arrayFechaFinal[1] + "/" + arrayFechaFinal[0];


        //aux=request.getParameter("fecha_inicio");
        //aux="2011/02/15";
        //System.out.println("aux:"+aux);
        //if(aux!=null){
        //    System.out.println("entro");
        //    fechaInicio=aux;
        //}

                %>
                <tr>
                    <td align="left" class="outputText2" width="10%" ></td>
                    <td  align="left" class="outputText2">
                        <b>Tipo de Cliente :</b> <%=nombreTipoCliente%>
                    </td>
                    <td align="left" class="outputText2" width="25%" ></td>
                </tr>
                <tr>
                    <td align="left" class="outputText2" width="10%" ></td>
                    <td  align="left" class="outputText2">
                        <b>Almacen de Productos Terminados :</b> <%=nombreAlmacenVentas%>
                    </td>
                    <td align="left" class="outputText2" width="25%" ></td>
                </tr>
                <tr>
                    <td align="left" width="25%"><img src="../../img/cofar.png"></td>
                    <td align="left" class="outputText2" width="50%" >

                    </td>
                    <td width="25%">
                        <table border="0" class="outputText2" width="100%" >
                            <tr>
                                <td align="right"><b>A Fecha&nbsp;::&nbsp;</b><%=fechaFinal%>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
            <br>
            <br>
            <br>
            <table  align="center" width="90%" class="outputText2" style="border : solid #f2f2f2 1px;" cellpadding="0" cellspacing="0">
                <tr class="tablaFiltroReporte">
                    <td align="center" class="bordeNegroTd" width="10%"><b>S/Baco</b></td>
                    <td align="center" class="bordeNegroTd" width="10%"><b>Stock Baco</b></td>
                    <td align="center" class="bordeNegroTd" width="10%"><b>S/Ventas &nbsp;</b></td>
                    <td align="center" class="bordeNegroTd" width="10%"><b>Dif. 1 (g) &nbsp;</b></td>
                    <td align="center" class="bordeNegroTd" width="10%"><b>Almacen PT (g) &nbsp;</b></td>
                    <td align="center" class="bordeNegroTd" width="10%"><b>Dif. 2 (g) &nbsp;</b></td>
                    <td align="center" class="bordeNegroTd" width="10%"><b>Almacen PT Regionales (g) &nbsp;</b></td>
                    <td align="center" class="bordeNegroTd" width="10%"><b>Dif. 3 (g) &nbsp;</b></td>
                    <td align="center" class="bordeNegroTd" width="10%"><b>Acondicionamiento &nbsp;</b></td>
                    <td align="center" class="bordeNegroTd" width="10%"><b>Dif. 4 (g) &nbsp;</b></td>
                    <td align="center" class="bordeNegroTd" width="10%"><b>APT+ALM REG+ACOND / VENTAS</b></td>
                </tr>

                <%
        try {
            String consulta = " SELECT M.COD_MATERIAL, M.NOMBRE_MATERIAL FROM MATERIALES M  WHERE M.COD_ESTADO_REGISTRO =1 AND " +
                    "M.COD_GRUPO = " + codGrupo; //AND M.COD_MATERIAL IN (38,117,130,134,137,151,168,169,172,177,200,204,5014)
            System.out.println("consulta" + consulta);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(consulta);

            while (rs.next()) {
                String codMaterial = rs.getString("COD_MATERIAL");
                String nombreMaterial = rs.getString("NOMBRE_MATERIAL");
                out.print("<tr><td class='bordeNegroTd' colspan='9'><b>" + nombreMaterial + "</b></td></tr>");

                //calculo de salidas de almacen
                String consultaSalidasAlmacen = "select SUM(sadi.cantidad) totalSalidasAlmacen  " +
                        " from salidas_almacen_detalle sad,  " +
                        " salidas_almacen_detalle_ingreso sadi,  ingresos_almacen_detalle_estado iade,  " +
                        " salidas_almacen sa  WHERE sa.cod_salida_almacen = sad.cod_salida_almacen and  " +
                        " sa.estado_sistema = 1 and  sa.cod_estado_salida_almacen = 1 and  " +
                        " sad.cod_salida_almacen = sadi.cod_salida_almacen and " +
                        " sad.cod_material = sadi.cod_material and  " +
                        " sadi.cod_ingreso_almacen = iade.cod_ingreso_almacen and  " +
                        " sadi.cod_material = iade.cod_material and  " +
                        " sadi.ETIQUETA = iade.ETIQUETA and  " +
                        " sa.fecha_salida_almacen BETWEEN '" + fechaInicialConsulta + " 00:00:00' and '" + fechaFinalConsulta + " 23:59:59' " +
                        " AND sad.COD_MATERIAL =" + codMaterial + " and sa.COD_ESTADO_SALIDA_ALMACEN<>2 ";

                System.out.println("consultaSalidasAlmacen" + consultaSalidasAlmacen);
                Statement stSalidasAlmacen = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rsSalidasAlmacen = stSalidasAlmacen.executeQuery(consultaSalidasAlmacen);
                float totalSalidasAlmacen = 0;
                if (rsSalidasAlmacen.next()) {
                    totalSalidasAlmacen = rsSalidasAlmacen.getFloat("totalSalidasAlmacen");
                }
                out.print("<tr>");
                out.print("<td class='bordeNegroTd'>" + format.format(totalSalidasAlmacen) + "</td>");


                /*SACAMOS LOS STOCKS DEL MATERIAL*/

                String hora = "23:59:00";
                String sql_exp = "";
                sql_exp = "select m.cod_material,m.stock_minimo_material,m.stock_maximo_material,m.stock_seguridad,m.cod_unidad_medida,m.nombre_material,u.nombre_unidad_medida,";
                sql_exp += " (select SUM(iade.cantidad_parcial) from ingresos_almacen_detalle_estado iade,ingresos_almacen_detalle  iad,ingresos_almacen ia";
                sql_exp += " WHERE iade.cod_material=m.cod_material and ia.cod_estado_ingreso_almacen=1 " +
                        " and iad.cod_ingreso_almacen=ia.cod_ingreso_almacen and ia.estado_sistema=1 " +
                        " and iade.cod_material=iad.cod_material " +
                        " and iade.cod_ingreso_almacen=iad.cod_ingreso_almacen";
                //if(lcb_almacen.KeyValue<>null)then sql_exp+=" and ia.cod_almacen='"+lcb_almacen.KeyValue+"'";
                sql_exp += "  and ia.fecha_ingreso_almacen<='" + fechaFinalConsulta + " " + hora + "' )as aprobados,";

                /* --------------------   SALIDAS ----------------------*/
                sql_exp += " (select SUM(sadi.cantidad)";
                sql_exp += " from salidas_almacen_detalle sad,salidas_almacen_detalle_ingreso sadi,ingresos_almacen_detalle_estado iade, salidas_almacen sa";
                sql_exp += " WHERE sa.cod_salida_almacen=sad.cod_salida_almacen and sa.estado_sistema=1 and sa.cod_estado_salida_almacen=1 and";
                sql_exp += " sad.cod_salida_almacen=sadi.cod_salida_almacen and sad.cod_material=sadi.cod_material and";
                sql_exp += " sadi.cod_ingreso_almacen=iade.cod_ingreso_almacen and sadi.cod_material=iade.cod_material and sadi.ETIQUETA=iade.ETIQUETA ";

                //if(lcb_almacen.KeyValue<>null)then sql_exp+=" and sa.cod_almacen='+inttostr(lcb_almacen.KeyValue)+'";
                //else sql_exp+="and (sa.cod_almacen=1 or sa.cod_almacen=2)";
                sql_exp += " and sad.cod_material=m.cod_material  and sa.fecha_salida_almacen<='" + fechaFinalConsulta + "')as salidas,";
                /* --------------------   DEVOLUCIONES ----------------------*/
                sql_exp += "(select sum(iad.cant_total_ingreso_fisico) from DEVOLUCIONES d, ingresos_almacen ia,INGRESOS_ALMACEN_DETALLE iad";
                sql_exp += " where ia.cod_devolucion=d.cod_devolucion  and ia.fecha_ingreso_almacen<='" + fechaFinalConsulta + "' and d.cod_estado_devolucion=1 and d.estado_sistema=1 and ia.cod_estado_ingreso_almacen=1";
                //if(lcb_almacen.KeyValue<>null)then sql_exp+="and ia.cod_almacen='+inttostr(lcb_almacen.KeyValue)+' and d.cod_almacen='+inttostr(lcb_almacen.KeyValue)+'";
                sql_exp += " and ia.cod_almacen=d.cod_almacen and ia.cod_ingreso_almacen=iad.cod_ingreso_almacen and iad.cod_material=m.cod_material)as devoluciones,";
                /* --------------------   CUARENTENA ----------------------*/
                sql_exp += " (select SUM(iade.cantidad_restante)";
                sql_exp += " from ingresos_almacen_detalle_estado iade,ingresos_almacen_detalle  iad,ingresos_almacen ia";
                sql_exp += " WHERE iade.cod_material=m.cod_material and ia.cod_estado_ingreso_almacen=1 and iad.cod_ingreso_almacen=ia.cod_ingreso_almacen and ia.estado_sistema=1 and iade.cod_material=iad.cod_material and iade.cod_ingreso_almacen=iad.cod_ingreso_almacen";
                //if(lcb_almacen.KeyValue<>null)then sql_exp+=" and ia.cod_almacen='+inttostr(lcb_almacen.KeyValue)+'";
                //else sql_exp+="and (ia.cod_almacen=1 or ia.cod_almacen=2)";
                sql_exp += " and iade.cod_estado_material=1  and ia.fecha_ingreso_almacen<='" + fechaFinalConsulta + "')as cuarentena,";
                /* --------------------   RECHAZADO ----------------------*/
                sql_exp += " (select SUM(iade.cantidad_restante)";
                sql_exp += " from ingresos_almacen_detalle_estado iade,ingresos_almacen_detalle  iad,ingresos_almacen ia";
                sql_exp += " WHERE iade.cod_material=m.cod_material and ia.cod_estado_ingreso_almacen=1 and iad.cod_ingreso_almacen=ia.cod_ingreso_almacen and ia.estado_sistema=1 and iade.cod_material=iad.cod_material and iade.cod_ingreso_almacen=iad.cod_ingreso_almacen";
                //if(lcb_almacen.KeyValue<>null)then sql_exp+=" and ia.cod_almacen='+inttostr(lcb_almacen.KeyValue)+'";
                //else sql_exp+="and (ia.cod_almacen=1 or ia.cod_almacen=2)";
                sql_exp += " and iade.cod_estado_material=3  and ia.fecha_ingreso_almacen<='" + fechaFinalConsulta + "')as rechazado,";
                /* --------------------   VENCIDO ----------------------*/
                sql_exp += " (select SUM(iade.cantidad_restante)";
                sql_exp += " from ingresos_almacen_detalle_estado iade,ingresos_almacen_detalle  iad,ingresos_almacen ia";
                sql_exp += " WHERE iade.cod_material=m.cod_material and ia.cod_estado_ingreso_almacen=1 and iad.cod_ingreso_almacen=ia.cod_ingreso_almacen and ia.estado_sistema=1 and iade.cod_material=iad.cod_material and iade.cod_ingreso_almacen=iad.cod_ingreso_almacen";
                //if(lcb_almacen.KeyValue<>null)then sql_exp+=" and ia.cod_almacen='+inttostr(lcb_almacen.KeyValue)+'";
                //else sql_exp+="and (ia.cod_almacen=1 or ia.cod_almacen=2)";
                sql_exp += " and iade.cod_estado_material=4  and ia.fecha_ingreso_almacen<='" + fechaFinalConsulta + "'  )as vencido,";
                /* --------------------   OBSOLETO ----------------------*/
                sql_exp += " (select SUM(iade.cantidad_restante)";
                sql_exp += " from ingresos_almacen_detalle_estado iade,ingresos_almacen_detalle  iad,ingresos_almacen ia";
                sql_exp += " WHERE iade.cod_material=m.cod_material and ia.cod_estado_ingreso_almacen=1 and iad.cod_ingreso_almacen=ia.cod_ingreso_almacen and ia.estado_sistema=1 and iade.cod_material=iad.cod_material and iade.cod_ingreso_almacen=iad.cod_ingreso_almacen";
                //if(lcb_almacen.KeyValue<>null)then sql_exp+=" and ia.cod_almacen='+inttostr(lcb_almacen.KeyValue)+'";
                //else sql_exp+="and (ia.cod_almacen=1 or ia.cod_almacen=2)";
                sql_exp += " and iade.cod_estado_material=5  and ia.fecha_ingreso_almacen<='" + fechaFinalConsulta + "')as obsoleto,";
                sql_exp += " (select sum (rd.CANTIDAD ) from RESERVA r,RESERVA_DETALLE rd ";
                sql_exp += " where r.cod_reserva=rd.cod_reserva and rd.COD_MATERIAL = m.COD_MATERIAL ) as reserva, c.NOMBRE_CAPITULO";

                sql_exp += " from materiales m,grupos g,capitulos c,UNIDADES_MEDIDA u ";
                sql_exp += " where m.cod_grupo=g.cod_grupo and g.cod_capitulo=c.cod_capitulo and  m.material_almacen=1 and u.cod_unidad_medida=m.cod_unidad_medida ";
                sql_exp += " AND M.COD_MATERIAL="+codMaterial ;
                sql_exp += " order by m.nombre_material";
                System.out.println("SQL EXISTENCIAS BACO:" + sql_exp);
                Statement stStocksBaco=con.createStatement();
                ResultSet rsStocksBaco=stStocksBaco.executeQuery(sql_exp);
                double cantAprobada=0;
                double cantSalidas=0;
                double cantDevoluciones=0;
                double cantCuarentena=0;
                double cantRechazada=0;
                double cantVencido=0;
                double cantObsoleto=0;
                double cantReserva=0;

                if(rsStocksBaco.next()){
                    cantAprobada=rsStocksBaco.getDouble(8);
                    cantSalidas=rsStocksBaco.getDouble(9);
                    cantDevoluciones=rsStocksBaco.getDouble(10);
                    cantCuarentena=rsStocksBaco.getDouble(11);
                    cantRechazada=rsStocksBaco.getDouble(12);
                    cantVencido=rsStocksBaco.getDouble(13);
                    cantObsoleto=rsStocksBaco.getDouble(14);
                    cantReserva=rsStocksBaco.getDouble(15);
                }
                double cantTotalBaco=cantAprobada-cantSalidas+cantDevoluciones+cantCuarentena-cantRechazada-cantVencido-cantObsoleto-cantReserva;

                out.print("<td class='bordeNegroTd'>" + format.format(cantTotalBaco) + "</td>");

                //FIN SACAR STOCK MATERIAL

                //calculo de salidas de Ventas

                //obtencion de las presentaciones en donde esta el material
                String consultaPresentaciones = "select pp.cod_presentacion, pp.NOMBRE_PRODUCTO_PRESENTACION, fmdmp.CANTIDAD,fm.CANTIDAD_LOTE ,pp.cantidad_presentacion" +
                        " from PRESENTACIONES_PRODUCTO pp,COMPONENTES_PROD cp, COMPONENTES_PRESPROD cprp, " +
                        " FORMULA_MAESTRA fm, formula_maestra_detalle_mp fmdmp  " +
                        " where pp.cod_presentacion=cprp.COD_PRESENTACION " +
                        " and cp.COD_COMPPROD = cprp.COD_COMPPROD  " +
                        " and fm.COD_COMPPROD = cprp.COD_COMPPROD  " +
                        " and fmdmp.COD_FORMULA_MAESTRA = fm.COD_FORMULA_MAESTRA " +
                        " and fmdmp.COD_MATERIAL = " + codMaterial + " ";

                System.out.println("consultaPresentaciones" + consultaPresentaciones);
                Statement stPresentaciones = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rsPresentaciones = stPresentaciones.executeQuery(consultaPresentaciones);
                //se itera por cada presentacion y se multiplica por
                String codPresentacion = "";
                String nombreProductoPresentacion = "";
                float cantidad = 0;
                float totalVentas = 0;
                float cantidadLote = 0;
                float cantidadPresentacion = 0;

                while (rsPresentaciones.next()) {

                    codPresentacion = rsPresentaciones.getString("cod_presentacion");
                    nombreProductoPresentacion = rsPresentaciones.getString("NOMBRE_PRODUCTO_PRESENTACION");
                    cantidad = rsPresentaciones.getFloat("CANTIDAD");
                    cantidadLote = rsPresentaciones.getFloat("CANTIDAD_LOTE");
                    cantidadPresentacion = rsPresentaciones.getFloat("cantidad_presentacion");

                    String consultaSalidasVentas = " select sum(ROUND(((sd.CANTIDAD_UNITARIATOTAL/pp.cantidad_presentacion) + isnull(sd.CANTIDAD_TOTAL,0)), 2)) as totalUnidades " +
                            " ,sum((sd.CANTIDAD +(sd.CANTIDAD_UNITARIA / pp.cantidad_presentacion)) * sd.PRECIO_LISTA *((100 - s.porcentaje_descuento) / 100) *((100 -sd.PORCENTAJE_APLICADOPRECIO) / 100)) as montoVenta " +
                            " from SALIDAS_VENTAS s,SALIDAS_DETALLEVENTAS sd,ALMACENES_VENTAS av,PRESENTACIONES_PRODUCTO pp,clientes cl " +
                            " where s.COD_SALIDAVENTA = sd.COD_SALIDAVENTAS and s.COD_ALMACEN_VENTA = av.COD_ALMACEN_VENTA " +
                            " and pp.cod_presentacion = sd.COD_PRESENTACION and s.COD_CLIENTE = cl.cod_cliente " +
                            " and av.COD_AREA_EMPRESA in(1,46,47,48,49,51,52,53,54,55,56,63) and cl.cod_tipocliente in (" + codTipoCliente + ") " +
                            " and s.FECHA_SALIDAVENTA between '" + fechaInicialConsulta + " 00:00:00' and '" + fechaFinalConsulta + " 23:59:59' " +
                            " and s.COD_TIPOSALIDAVENTAS=3 and pp.cod_presentacion=" + codPresentacion + " and s.COD_ESTADO_SALIDAVENTA <>2";

                    System.out.println("consultaSalidasVentas" + consultaSalidasVentas);

                    Statement stSalidasVentas = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    ResultSet rsSalidasVentas = stSalidasVentas.executeQuery(consultaSalidasVentas);
                    float totalUnidadesVentas = 0;
                    if (rsSalidasVentas.next()) {
                        totalUnidadesVentas = rsSalidasVentas.getFloat("totalUnidades");
                        System.out.println("Ventas --> " + nombreProductoPresentacion + ": " + "((" + totalUnidadesVentas + "*" + cantidadPresentacion + ")*" + cantidad + ")/" + cantidadLote);
                        System.out.println("Ventas --> " + nombreProductoPresentacion + ": " + ";" + totalUnidadesVentas + ";" + cantidadPresentacion + ";" + cantidad + ";" + cantidadLote);
                        totalVentas = totalVentas + ((totalUnidadesVentas * cantidadPresentacion) * cantidad) / cantidadLote;
                    }
                }

                out.print("<td class='bordeNegroTd'>" + format.format(totalVentas) + "</td>");

                //calculo de datos

                out.print("<td class='bordeNegroTd'>" + format.format(totalSalidasAlmacen - totalVentas) + "</td>");
                //calculo de existencias en almacen de productos terminados APT



                float saldoCantidadPresentacion = 0;
                float saldoCantidadUnitariasPresentacion = 0;
                float saldoCantPresentacion = 0;




                String consultaIngresosPresentacion = "select sum(id.cantidad) cantidad,sum(id.cantidad_unitaria) cantidadUnitaria ,pp.cod_presentacion,pp.NOMBRE_PRODUCTO_PRESENTACION ,pp.cantidad_presentacion,fm.COD_COMPPROD,fmdmp.CANTIDAD cantidadMaterial,fm.CANTIDAD_LOTE " +
                        " from ingresos_detalleventas id,ingresos_ventas iv,PRESENTACIONES_PRODUCTO pp,COMPONENTES_PROD cp, COMPONENTES_PRESPROD cprp,  " +
                        " FORMULA_MAESTRA fm, formula_maestra_detalle_mp fmdmp " +
                        " where id.cod_ingresoventas=iv.cod_ingresoventas " +
                        " and id.cod_presentacion  = pp.cod_presentacion " +
                        " and pp.cod_presentacion = cprp.COD_PRESENTACION " +
                        " and cp.COD_COMPPROD = cprp.COD_COMPPROD    " +
                        " and fm.COD_COMPPROD = cprp.COD_COMPPROD  " +
                        " and fmdmp.COD_FORMULA_MAESTRA = fm.COD_FORMULA_MAESTRA " +
                        " and fmdmp.COD_MATERIAL = " + codMaterial + "  " +
                        " and iv.fecha_ingresoventas<='" + fechaFinalConsulta + " 23:59:59' " +
                        " and pp.cod_presentacion=id.cod_presentacion and iv.cod_estado_ingresoventas<>2 " +
                        " and iv.cod_almacen_venta in (SELECT A.COD_ALMACEN_VENTA FROM ALMACENES_VENTAS A WHERE A.COD_AREA_EMPRESA in (1,46,47,48,49,51,52,53,54,55,56,63))  " +
                        " group by pp.cod_presentacion,pp.NOMBRE_PRODUCTO_PRESENTACION ,pp.cantidad_presentacion,fm.COD_COMPPROD,fmdmp.CANTIDAD,fm.CANTIDAD_LOTE  ";


                rsPresentaciones.first();
                float cantidadIngresos = 0;
                float cantidadUnitariaIngresos = 0;
                float ingresosMaterial = 0;
                while (rsPresentaciones.next()) {
                    codPresentacion = rsPresentaciones.getString("cod_presentacion");
                    nombreProductoPresentacion = rsPresentaciones.getString("NOMBRE_PRODUCTO_PRESENTACION");
                    cantidad = rsPresentaciones.getFloat("CANTIDAD");
                    cantidadLote = rsPresentaciones.getFloat("CANTIDAD_LOTE");
                    cantidadPresentacion = rsPresentaciones.getFloat("cantidad_presentacion");

                    consultaIngresosPresentacion = " select sum(id.cantidad) cantidad,sum(id.cantidad_unitaria) cantidadUnitaria  " +
                            " from ingresos_detalleventas id,ingresos_ventas iv,PRESENTACIONES_PRODUCTO pp " +
                            " where id.cod_ingresoventas=iv.cod_ingresoventas " +
                            " and iv.fecha_ingresoventas<='" + fechaFinalConsulta + " 23:59:59' " +
                            " and pp.cod_presentacion=id.cod_presentacion " +
                            " and iv.cod_estado_ingresoventas<>2 " +
                            " and iv.cod_almacen_venta in (SELECT A.COD_ALMACEN_VENTA FROM ALMACENES_VENTAS A WHERE A.COD_AREA_EMPRESA in (1))  " +
                            " and id.COD_PRESENTACION = " + codPresentacion + "";

                    System.out.println("SQL INGRESOS:    " + consultaIngresosPresentacion);
                    Statement stIngresosPresentacion = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    ResultSet rsIngresosPresentacion = stIngresosPresentacion.executeQuery(consultaIngresosPresentacion);



                    while (rsIngresosPresentacion.next()) {
                        cantidadIngresos = rsIngresosPresentacion.getFloat("cantidad");
                        cantidadUnitariaIngresos = rsIngresosPresentacion.getFloat("cantidadUnitaria");
                        ingresosMaterial += (((cantidadIngresos * cantidadPresentacion) + cantidadUnitariaIngresos) * cantidad) / cantidadLote;

                        System.out.println("ingresos-->" + "(((" + cantidadIngresos + "*" + cantidadPresentacion + ")+ " + cantidadUnitariaIngresos + ")*" + cantidad + ")/" + cantidadLote);
                    }
                    System.out.println("ingresos--->" + ingresosMaterial);

                }


                rsPresentaciones.first();
                float cantidadSalidas = 0;
                float cantidadUnitariaSalidas = 0;
                float salidasMaterial = 0;

                String consultaSalidasPresentacion = "";
                while (rsPresentaciones.next()) {
                    codPresentacion = rsPresentaciones.getString("cod_presentacion");
                    nombreProductoPresentacion = rsPresentaciones.getString("NOMBRE_PRODUCTO_PRESENTACION");
                    cantidad = rsPresentaciones.getFloat("CANTIDAD");
                    cantidadLote = rsPresentaciones.getFloat("CANTIDAD_LOTE");
                    cantidadPresentacion = rsPresentaciones.getFloat("cantidad_presentacion");

                    consultaSalidasPresentacion = " select sum(cantidad_total) salidas,sum(cantidad_unitariatotal) salidasUnitarias " +
                            " from salidas_detalleventas sd,salidas_ventas sa,PRESENTACIONES_PRODUCTO pp    " +
                            " where sd.cod_salidaventas=sa.cod_salidaventa " +
                            " and sa.fecha_salidaventa<='" + fechaFinalConsulta + " 23:59:59'  " +
                            " and pp.cod_presentacion=sd.cod_presentacion  " +
                            " and sa.cod_estado_salidaventa<>2   " +
                            " and sa.cod_almacen_venta in (SELECT A.COD_ALMACEN_VENTA FROM ALMACENES_VENTAS A WHERE A.COD_AREA_EMPRESA in (1))  " +
                            " and sd.COD_PRESENTACION =" + codPresentacion + "";

                    System.out.println("SQL SALIDAS:    " + consultaSalidasPresentacion);
                    Statement stSalidasPresentacion = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    ResultSet rsSalidasPresentacion = stSalidasPresentacion.executeQuery(consultaSalidasPresentacion);


                    while (rsSalidasPresentacion.next()) {
                        cantidadSalidas = rsSalidasPresentacion.getFloat("salidas");
                        cantidadUnitariaSalidas = rsSalidasPresentacion.getFloat("salidasUnitarias");
                        salidasMaterial += (((cantidadSalidas * cantidadPresentacion) + cantidadUnitariaSalidas) * cantidad) / cantidadLote;

                        System.out.println("salidas-->" + "(((" + cantidadSalidas + "*" + cantidadPresentacion + ")+ " + cantidadUnitariaSalidas + ")*" + cantidad + ")/" + cantidadLote);
                    }
                    System.out.println("salidas--->" + salidasMaterial);

                }
                float saldoMaterialVentas = ingresosMaterial - salidasMaterial;

                out.print("<td class='bordeNegroTd'>" + format.format(saldoMaterialVentas) + "</td>");
                out.print("<td class='bordeNegroTd'>" + format.format(totalSalidasAlmacen - totalVentas - saldoMaterialVentas) + "</td>");



                //hallar las existencias en apt regionales

                rsPresentaciones.first();
                cantidadIngresos = 0;
                cantidadUnitariaIngresos = 0;
                ingresosMaterial = 0;
                while (rsPresentaciones.next()) {
                    codPresentacion = rsPresentaciones.getString("cod_presentacion");
                    nombreProductoPresentacion = rsPresentaciones.getString("NOMBRE_PRODUCTO_PRESENTACION");
                    cantidad = rsPresentaciones.getFloat("CANTIDAD");
                    cantidadLote = rsPresentaciones.getFloat("CANTIDAD_LOTE");
                    cantidadPresentacion = rsPresentaciones.getFloat("cantidad_presentacion");

                    consultaIngresosPresentacion = " select sum(id.cantidad) cantidad,sum(id.cantidad_unitaria) cantidadUnitaria  " +
                            " from ingresos_detalleventas id,ingresos_ventas iv,PRESENTACIONES_PRODUCTO pp " +
                            " where id.cod_ingresoventas=iv.cod_ingresoventas " +
                            " and iv.fecha_ingresoventas<='" + fechaFinalConsulta + " 23:59:59' " +
                            " and pp.cod_presentacion=id.cod_presentacion " +
                            " and iv.cod_estado_ingresoventas<>2 " +
                            " and iv.cod_almacen_venta in (SELECT A.COD_ALMACEN_VENTA FROM ALMACENES_VENTAS A WHERE A.COD_AREA_EMPRESA in (46,47,48,49,51,52,53,54,55,56,63))  " +
                            " and id.COD_PRESENTACION = " + codPresentacion + "";

                    System.out.println("SQL INGRESOS:    " + consultaIngresosPresentacion);
                    Statement stIngresosPresentacion = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    ResultSet rsIngresosPresentacion = stIngresosPresentacion.executeQuery(consultaIngresosPresentacion);



                    while (rsIngresosPresentacion.next()) {
                        cantidadIngresos = rsIngresosPresentacion.getFloat("cantidad");
                        cantidadUnitariaIngresos = rsIngresosPresentacion.getFloat("cantidadUnitaria");
                        ingresosMaterial += (((cantidadIngresos * cantidadPresentacion) + cantidadUnitariaIngresos) * cantidad) / cantidadLote;

                        System.out.println("ingresos-->" + "(((" + cantidadIngresos + "*" + cantidadPresentacion + ")+ " + cantidadUnitariaIngresos + ")*" + cantidad + ")/" + cantidadLote);
                    }
                    System.out.println("ingresos--->" + ingresosMaterial);

                }


                rsPresentaciones.first();
                cantidadSalidas = 0;
                cantidadUnitariaSalidas = 0;
                salidasMaterial = 0;

                consultaSalidasPresentacion = "";
                while (rsPresentaciones.next()) {
                    codPresentacion = rsPresentaciones.getString("cod_presentacion");
                    nombreProductoPresentacion = rsPresentaciones.getString("NOMBRE_PRODUCTO_PRESENTACION");
                    cantidad = rsPresentaciones.getFloat("CANTIDAD");
                    cantidadLote = rsPresentaciones.getFloat("CANTIDAD_LOTE");
                    cantidadPresentacion = rsPresentaciones.getFloat("cantidad_presentacion");

                    consultaSalidasPresentacion = " select sum(cantidad_total) salidas,sum(cantidad_unitariatotal) salidasUnitarias " +
                            " from salidas_detalleventas sd,salidas_ventas sa,PRESENTACIONES_PRODUCTO pp    " +
                            " where sd.cod_salidaventas=sa.cod_salidaventa " +
                            " and sa.fecha_salidaventa<='" + fechaFinalConsulta + " 23:59:59'  " +
                            " and pp.cod_presentacion=sd.cod_presentacion  " +
                            " and sa.cod_estado_salidaventa<>2   " +
                            " and sa.cod_almacen_venta in (SELECT A.COD_ALMACEN_VENTA FROM ALMACENES_VENTAS A WHERE A.COD_AREA_EMPRESA in (46,47,48,49,51,52,53,54,55,56,63))  " +
                            " and sd.COD_PRESENTACION =" + codPresentacion + "";

                    System.out.println("SQL SALIDAS:    " + consultaSalidasPresentacion);
                    Statement stSalidasPresentacion = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    ResultSet rsSalidasPresentacion = stSalidasPresentacion.executeQuery(consultaSalidasPresentacion);


                    while (rsSalidasPresentacion.next()) {
                        cantidadSalidas = rsSalidasPresentacion.getFloat("salidas");
                        cantidadUnitariaSalidas = rsSalidasPresentacion.getFloat("salidasUnitarias");
                        salidasMaterial += (((cantidadSalidas * cantidadPresentacion) + cantidadUnitariaSalidas) * cantidad) / cantidadLote;

                        System.out.println("salidas-->" + "(((" + cantidadSalidas + "*" + cantidadPresentacion + ")+ " + cantidadUnitariaSalidas + ")*" + cantidad + ")/" + cantidadLote);
                    }
                    System.out.println("salidas--->" + salidasMaterial);

                }
                float saldoMaterialVentasRegionales = ingresosMaterial - salidasMaterial;

                out.print("<td class='bordeNegroTd'>" + format.format(saldoMaterialVentasRegionales) + "</td>");
                out.print("<td class='bordeNegroTd'>" + format.format(totalSalidasAlmacen - totalVentas - saldoMaterialVentas - saldoMaterialVentasRegionales) + "</td>");


                //hallar las existencias en acondicionamiento

                rsPresentaciones.first();
                String lotesProduccionCerrados = "";
                while (rsPresentaciones.next()) {
                    codPresentacion = rsPresentaciones.getString("cod_presentacion");
                    nombreProductoPresentacion = rsPresentaciones.getString("NOMBRE_PRODUCTO_PRESENTACION");
                    cantidad = rsPresentaciones.getFloat("CANTIDAD");
                    cantidadLote = rsPresentaciones.getFloat("CANTIDAD_LOTE");
                    cantidadPresentacion = rsPresentaciones.getFloat("cantidad_presentacion");

                    String consultaLotesCerrados = "select DISTINCT(sd.COD_LOTE_PRODUCCION) from SALIDAS_ACOND s, SALIDAS_DETALLEACOND sd,COMPONENTES_PRESPROD cp " +
                            "where s.COD_SALIDA_ACOND=sd.COD_SALIDA_ACOND and cp.cod_presentacion = " + codPresentacion + " and s.COD_ESTADO_SALIDAACOND<>2 and sd.COD_ESTADOENTREGA=1 " +
                            "and s.COD_ALMACENACOND in (1,3) and cp.COD_COMPPROD = sd.COD_COMPPROD";
                    Statement stLotes = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    ResultSet rsLotes = stLotes.executeQuery(consultaLotesCerrados);

                    while (rsLotes.next()) {
                        lotesProduccionCerrados = lotesProduccionCerrados + "'" + rsLotes.getString(1) + "',";
                    }
                    lotesProduccionCerrados = lotesProduccionCerrados + "'0'";
                }

                rsPresentaciones.first();
                float cantidadTotalSalidas = 0;
                while (rsPresentaciones.next()) {
                    codPresentacion = rsPresentaciones.getString("cod_presentacion");
                    nombreProductoPresentacion = rsPresentaciones.getString("NOMBRE_PRODUCTO_PRESENTACION");
                    cantidad = rsPresentaciones.getFloat("CANTIDAD");
                    cantidadLote = rsPresentaciones.getFloat("CANTIDAD_LOTE");
                    cantidadPresentacion = rsPresentaciones.getFloat("cantidad_presentacion");

                    String consultaSalidasAcondicionamiento = "select sda.CANT_TOTAL_SALIDADETALLEACOND,COD_ESTADOENTREGA,COD_LOTE_PRODUCCION from SALIDAS_ACOND sa,SALIDAS_DETALLEACOND sda,COMPONENTES_PRESPROD cp";
                    consultaSalidasAcondicionamiento += " where sa.COD_SALIDA_ACOND = sda.COD_SALIDA_ACOND and cp.COD_COMPPROD = sda.COD_COMPPROD";
                    consultaSalidasAcondicionamiento += " and cp.cod_presentacion = " + codPresentacion + " and sa.FECHA_SALIDAACOND <= '" + fechaFinalConsulta + " 23:59:59'";
                    consultaSalidasAcondicionamiento += " and sa.COD_ESTADO_SALIDAACOND <> 2 ";
                    consultaSalidasAcondicionamiento += "and sda.COD_LOTE_PRODUCCION not in (" + lotesProduccionCerrados + ") ";
                    consultaSalidasAcondicionamiento += "and sa.COD_ALMACENACOND in (1,3)";
                    // sql_0+=" and sda.COD_ESTADOENTREGA<>2";
                    System.out.println("consultaSalidasAcondicionamiento:" + consultaSalidasAcondicionamiento);

                    Statement stSalidasAcondicionamiento = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    ResultSet rsSalidasAcondicionamiento = stSalidasAcondicionamiento.executeQuery(consultaSalidasAcondicionamiento);



                    while (rsSalidasAcondicionamiento.next()) {
                        int cantidadTotalSalidasUnitario = rsSalidasAcondicionamiento.getInt("CANT_TOTAL_SALIDADETALLEACOND");
                        int codEstado = rsSalidasAcondicionamiento.getInt("COD_ESTADOENTREGA");
                        String loteEntrega = rsSalidasAcondicionamiento.getString("COD_LOTE_PRODUCCION");
                        if (codEstado == 0) {
                            cantidadTotalSalidas = cantidadTotalSalidas + (cantidadTotalSalidasUnitario * cantidad) / cantidadLote;
                        }
                    }
                    System.out.println("total salida Acondicionamiento:" + cantidadTotalSalidas);
                }


                rsPresentaciones.first();
                float cantidadTotalIngresos = 0;
                while (rsPresentaciones.next()) {
                    codPresentacion = rsPresentaciones.getString("cod_presentacion");
                    nombreProductoPresentacion = rsPresentaciones.getString("NOMBRE_PRODUCTO_PRESENTACION");
                    cantidad = rsPresentaciones.getFloat("CANTIDAD");
                    cantidadLote = rsPresentaciones.getFloat("CANTIDAD_LOTE");
                    cantidadPresentacion = rsPresentaciones.getFloat("cantidad_presentacion");



                    String consultaIngresosAcondicionamiento = " select ISNULL(sum(ida.CANT_TOTAL_INGRESO),0) CANT_TOTAL_INGRESOS from INGRESOS_ACOND ia,INGRESOS_DETALLEACOND ida,COMPONENTES_PRESPROD cp";
                    consultaIngresosAcondicionamiento += " where ia.COD_INGRESO_ACOND = ida.COD_INGRESO_ACOND and ida.COD_COMPPROD = cp.COD_COMPPROD";
                    consultaIngresosAcondicionamiento += " and cp.cod_presentacion = " + codPresentacion + " and ia.fecha_ingresoacond<='" + fechaFinalConsulta + " 23:59:59'";
                    consultaIngresosAcondicionamiento += " and ia.COD_ESTADO_INGRESOACOND<>2 and ia.COD_ALMACENACOND in(1,3)";
                    consultaIngresosAcondicionamiento += " AND COD_LOTE_PRODUCCION not in (" + lotesProduccionCerrados + ")";

                    System.out.println("consulta Ingresos Acondicionamiento:" + consultaIngresosAcondicionamiento);

                    Statement stIngresosAcondicionamiento = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    ResultSet rsIngresosAcondicionamiento = stIngresosAcondicionamiento.executeQuery(consultaIngresosAcondicionamiento);

                    if (rsIngresosAcondicionamiento.next()) {
                        float ingresosUnitarios = rsIngresosAcondicionamiento.getInt("CANT_TOTAL_INGRESOS");
                        cantidadTotalIngresos = cantidadTotalIngresos + (ingresosUnitarios * cantidad) / cantidadLote;
                    }
                }


                float saldoCantidadUnitariaAcond = cantidadTotalIngresos - cantidadTotalSalidas;

                saldoCantidadUnitariaAcond = saldoCantidadUnitariaAcond < 0 ? 0 : saldoCantidadUnitariaAcond;

                out.print("<td class='bordeNegroTd' align='right'>" + format.format(saldoCantidadUnitariaAcond) + "</td>");

                out.print("<td class='bordeNegroTd' align='right'>" + format.format(totalSalidasAlmacen - totalVentas - saldoMaterialVentas - saldoMaterialVentasRegionales - saldoCantidadUnitariaAcond) + "</td>");

                double porcentajeVentas=((saldoMaterialVentas+saldoMaterialVentasRegionales+saldoCantidadUnitariaAcond)/totalVentas)*100;

                out.print("<td class='bordeNegroTd' align='right'>" + format.format(porcentajeVentas) + "</td>");


                out.print("</tr>");


            }

        } catch (Exception e) {
            e.printStackTrace();
        }
                %>

            </table>



        </form>
    </body>
</html>