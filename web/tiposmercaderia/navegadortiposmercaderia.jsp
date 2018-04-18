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
<%! Connection con=null; %>
<link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
<html>
    <body>
        <form method="post" action="">
            <%
            String fechaInicio = request.getParameter("fecha_inicio");
            String fechaFinal = request.getParameter("fecha_final");
            fechaInicio+=" 00:00:00";
            fechaFinal+=" 23:59:59";
            String codAreaEmpresa = request.getParameter("codAreaEmpresa");
            String codAlmacenVenta = request.getParameter("campo_almacen");
            String[] codAlmacenes = codAlmacenVenta.split(",");
            String tiposSalidas= request.getParameter("campo_oculto");
            String tiposMercaderia = request.getParameter("tiposMercaderias");
            String[] vectorFechaInicio = fechaInicio.split("/");
            String[] vectorFechaFinal = fechaFinal.split("/");
            String fechaInicio1=vectorFechaInicio[1]+"/"+vectorFechaInicio[0]+"/"+vectorFechaInicio[2];
            String fechaFinal1=vectorFechaFinal[1]+"/"+vectorFechaFinal[0]+"/"+vectorFechaFinal[2];
            String sqlPresentaciones="";
            float ufvPromedio;
            double total_mc_tot=0;
            double total_mc_baj=0;
            double total_mc_rea=0;
            double total_mc_ven_t1=0;
            double total_mc_ven_t2=0;
            double total_mc_ven_t3=0;
            double total_mc_tra=0;
            double total_mc_tra_cu=0;
            double total_mc_aju=0;
            double total_mc_rep=0;
            double total_mc_pro_mc=0;
            double total_mc_pro_mm=0;
            double total_mc_pro_mm_cu=0;
            String fechaSalidaAlmacen;
            Statement st;

            double costoTotalGeneral=0;

            double total_saldo=0;
            double total_saldo2=0;
            double total_saldo_final=0;
            double ajuste_linea=0;
            double total_ajuste_linea=0;

            NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
            DecimalFormat form1 = (DecimalFormat)nf;
            form1.applyPattern("#,###.00");
            //**********
            con=Util.openConnection(con);
            fechaInicio=vectorFechaInicio[0]+"/"+vectorFechaInicio[1]+"/"+vectorFechaInicio[2];
            fechaFinal=vectorFechaFinal[0]+"/"+vectorFechaFinal[1]+"/"+vectorFechaFinal[2];

            %>

            <div align="center">

                <table>
                    <tr>
                        <td><img src="../../img/logo_cofar.png"></td>
                        <td>
                            <table border="0" class="outputText2">
                                <tr>
                                    <td align="center" class="tituloCampo"><b>Reporte de Salidas por Linea Resumido</b></td>
                                </tr>
                                <tr>
                                    <td align="center"><b>Fecha Inicio::</b><%=fechaInicio1%>&nbsp;<b>Fecha Final::</b><%=fechaFinal1%></td>
                                </tr>
                                <%if(!codAlmacenVenta.equals("0")){
                                String nombreAlmacenVenta="";
                                try{
                                con=Util.openConnection(con);

                                String sql_aux1=" select nombre_almacen_venta from almacenes_ventas where cod_almacen_venta in("+codAlmacenVenta+")";
                                Statement st_aux1 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                ResultSet rs_aux1 = st_aux1.executeQuery(sql_aux1);
                                while (rs_aux1.next()){
                                nombreAlmacenVenta=nombreAlmacenVenta+rs_aux1.getString("nombre_almacen_venta")+", ";
                                }
                                } catch(Exception e) {
                                }
                                System.out.println("nombreAlmacenVenta..................."+nombreAlmacenVenta);
                                %>
                                <tr>
                                    <td align="center"><b>Nombre Almacen::</b><%=nombreAlmacenVenta%></td>
                                </tr>
                                <% } %>

                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <table class="tablaFiltroReporte" >
                                <tr  class="tituloCampo">
                                    <td class="bordeNegroTd" colspan="2" align="center"><b>&nbsp;</b></td>
                                    <td class="bordeNegroTd" colspan="3" align="center"><b>VENTAS</b></td>
                                    <td class="bordeNegroTd" align="center"><b>PROMOCION</b></td>
                                    <td class="bordeNegroTd" align="center"><b>REPOSICION</b></td>
                                    <td class="bordeNegroTd" colspan="4" align="center"><b>TRASPASOS</b></td>
                                    <td class="bordeNegroTd" align="center"><b>REACONDI</b></td>
                                    <td class="bordeNegroTd" align="center"><b>BAJAS</b></td>
                                    <td class="bordeNegroTd" align="center"><b>AJUSTES</b></td>
                                    <td class="bordeNegroTd" align="center"><b>TOTAL</b></td>
                                    <td class="bordeNegroTd" align="center"><b>MONTO</b></td>
                                    <td class="bordeNegroTd" align="center"><b>&nbsp;</b></td>
                                </tr>
                                <tr  class="tituloCampo">
                                    <td class="bordeNegroTd" align="center"><b>Linea</b></td>
                                    <td class="bordeNegroTd" align="center"><b>Descripcin</b></td>
                                    <td class="bordeNegroTd" align="center"><b>FA</b></td>
                                    <td class="bordeNegroTd" align="center"><b>NE</b></td>
                                    <td class="bordeNegroTd" align="center"><b>NR</b></td>
                                    <td class="bordeNegroTd" align="center"><b>MC</b></td>
                                    <td class="bordeNegroTd" align="center"><b>&nbsp;</b></td>
                                    <td class="bordeNegroTd" align="center"><b>REG.</b></td>
                                    <td class="bordeNegroTd" align="center"><b>MM</b></td>
                                    <td class="bordeNegroTd" align="center"><b>CC</b></td>
                                    <td class="bordeNegroTd" align="center"><b>CUARENTENA</b></td>
                                    <td class="bordeNegroTd" align="center"><b>CIONAMIENTO</b></td>
                                    <td class="bordeNegroTd" align="center"><b>&nbsp;</b></td>
                                    <td class="bordeNegroTd" align="center"><b>&nbsp;</b></td>
                                    <td class="bordeNegroTd" align="center"><b>SALIDAS</b></td>
                                    <td class="bordeNegroTd" align="center"><b>ACTUALIZACION</b></td>
                                    <td class="bordeNegroTd" align="center"><b>Saldos Finales</b></td>
                                </tr>
                                <%

                                try{
                                    con=Util.openConnection(con);
                                    String sqlLinea="";
                                    sqlLinea+=" select cod_lineamkt, nombre_lineamkt,abreviatura from lineas_mkt where cod_estado_registro=1 order by abreviatura";
                                    System.out.println("sqlLinea..................."+sqlLinea);
                                    Statement stLinea = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                    ResultSet rsLinea = stLinea.executeQuery(sqlLinea);
                                    while (rsLinea.next()){
                                        String lineaMKT=rsLinea.getString(1);
                                        String nombreMKT=rsLinea.getString(2);
                                        String abreviatura=rsLinea.getString(3);
                                        total_saldo=0;
                                        ajuste_linea=0;

//************************************************************* SALDOS FINALES
                                        for (int i=0 ;i<codAlmacenes.length ;i++ ) {
                                            String sqlp="";
                                            sqlp+=" SELECT p.cod_presentacion,p.cantidad_presentacion,P.NOMBRE_PRODUCTO_PRESENTACION";
                                            sqlp+=" FROM presentaciones_producto p";
                                            sqlp+=" where p.cod_tipomercaderia in("+tiposMercaderia+")";
                                            sqlp+=" and p.cod_lineamkt ="+lineaMKT;

                                /* sql+=" AND (cod_presentacion in (select cod_presentacion from INGRESOS_DETALLEVENTAS";
                                sql+=" ivd, INGRESOS_VENTAS iv where iv.cod_estado_ingresoventas <> 2 and";
                                sql+=" iv.cod_ingresoventas = ivd.cod_ingresoventas ";
                                sql+=" and iv.fecha_ingresoventas >= '"+fechaInicio1+"' and";
                                sql+=" iv.fecha_ingresoventas <= '"+fechaFinal1+"' and iv.cod_almacen_venta in ("+codAlmacenVenta+"))OR cod_presentacion IN(";
                                sql+=" select cod_presentacion from salidas_detalleventas sad, salidas_ventas sv  where";
                                sql+=" sv.cod_estado_salidaventa<>2 and sv.cod_salidaventa=sad.cod_salidaventas";
                                sql+=" and (sv.FECHA_SALIDAVENTA BETWEEN '"+fechaInicio1+"' and '"+fechaFinal1+"')";
                                sql+=" and sv.COD_ALMACEN_VENTA in("+codAlmacenVenta+")))";
                                 */
                                            System.out.println("sql:..................."+sqlp);
                                            Statement stp = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                            ResultSet rsp = stp.executeQuery(sqlp);
                                            while (rsp.next()){
                                                String codPresentacion=rsp.getString("cod_presentacion");
                                                String cantidadPresentacion=rsp.getString("cantidad_presentacion");
                                                String nombre=rsp.getString("NOMBRE_PRODUCTO_PRESENTACION");

                                                String sql2="";
                                                float costoUnitario=0;
                                                sql2+=" select top 1 FECHA,COSTO_MATERIAL,ajuste from COSTOS_PRESENTACION_POR_MES where fecha<='"+fechaFinal1+"' and cod_presentacion="+codPresentacion +" and cod_almacen="+codAlmacenes[i];
                                                sql2+=" order by fecha desc";
                                                //System.out.println("sql:..................."+sql2);
                                                Statement st2 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                                ResultSet rs2 = st2.executeQuery(sql2);
                                                while (rs2.next()){
                                                    //fechaAnteriorSaldo=f.format(rs1.getDate("FECHA"));
                                                    costoUnitario=rs2.getFloat("COSTO_MATERIAL");
                                                    ajuste_linea=ajuste_linea+rs2.getFloat("ajuste");
                                                }
                                                sql2="";
                                                sql2+=" SELECT ISNULL(sum(iad.cantidad*p.cantidad_presentacion+iad.cantidad_unitaria),0)as ingresos_total_anterior";
                                                sql2+=" FROM ingresos_detalleventas iad,ingresos_ventas ia, presentaciones_producto p ";
                                                sql2+=" where iad.cod_ingresoventas=ia.cod_ingresoventas and iad.cod_presentacion=p.cod_presentacion";
                                                sql2+=" and ia.cod_estado_ingresoventas<>2";
                                                sql2+=" and iad.cod_presentacion="+codPresentacion;
                                                sql2+=" and ia.cod_almacen_venta="+codAlmacenes[i];
                                                sql2+=" and ia.fecha_ingresoventas<='"+fechaFinal1+"'";
                                               // sql2+=" and ia.COD_INGRESOVENTAS <>ALL(select COD_INGRESOVENTAS from INGRESOS_VENTAS  where cod_almacen_ventaorigen=54 ";
                                               // sql2+=" and fecha_ingresoventas<='"+fechaFinal1+"')";
                                                System.out.println("cantidad_presentacion:..................."+sql2);
                                                st2 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                                rs2 = st2.executeQuery(sql2);
                                                String ingresosTotalAnterior="0";
                                                while (rs2.next()){
                                                    //cantidadUnitaria=rs2.getFloat("ingresos_total_anterior");
                                                    ingresosTotalAnterior=rs2.getString("ingresos_total_anterior");
                                                }

                                                sql2="";
                                                sql2+=" SELECT ISNULL(sum(sad.cantidad_total*"+cantidadPresentacion+"+sad.cantidad_unitariatotal),0)as salidas_total_anterior";
                                                sql2+=" FROM salidas_detalleventas sad,salidas_ventas sa";
                                                sql2+=" where sad.cod_salidaventas=sa.cod_salidaventa";
                                                sql2+=" and sa.cod_estado_salidaventa<>2";
                                                sql2+=" and sad.cod_presentacion="+codPresentacion;
                                                sql2+=" and sa.cod_almacen_venta="+codAlmacenes[i];
                                                sql2+=" and sa.fecha_salidaventa<='"+fechaFinal1+"'";
                                                System.out.println("sql salidas:..................."+sql2);
                                                st2 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                                rs2 = st2.executeQuery(sql2);
                                                String salidasTotalAnterior="0";
                                                while (rs2.next()){
                                                    salidasTotalAnterior=rs2.getString("salidas_total_anterior");
                                                }
                                                String cantidadRestanteAnterior=String.valueOf(Float.parseFloat(ingresosTotalAnterior) -Float.parseFloat(salidasTotalAnterior));
                                                float costo_aux=0;
                                                if(costoUnitario ==0){costo_aux=0;} else{costo_aux=costoUnitario;}
                                                total_saldo2=0;
                                                total_saldo2=Float.parseFloat(cantidadRestanteAnterior)*costo_aux;
                                                total_saldo=total_saldo+(Float.parseFloat(cantidadRestanteAnterior)*costo_aux);

                                                //System.out.println("cantidadRestanteAnterior..................."+saldoInicialActualizado);
// aqui va el codigo para verificar las lineas


                                            }

                                        }

                                        total_saldo_final=total_saldo_final+total_saldo;
//***********************************************SALDOS FINALES


                                        String sql="";
                                        sql+=" select isnull(sum(((isnull(sad.cantidad_total,0)*p.cantidad_presentacion)+isnull(sad.cantidad_unitariatotal,0))*sad.costo_actualizado),0)";
                                        //sql+=" ((100-sad.porcentaje_aplicadoprecio)/100)*((100-sv.porcentaje_descuento)/100)),0)";
                                        sql+=" from salidas_detalleventas sad, presentaciones_producto p,salidas_ventas sv,ALMACENES_VENTAS av";
                                        sql+=" where sv.cod_estado_salidaventa<>2 and sv.cod_salidaventa=sad.cod_salidaventas and";
                                        sql+=" sad.cod_presentacion=p.cod_presentacion and";
                                        sql+=" sv.cod_almacen_venta = av.cod_almacen_venta";
                                        sql+=" and av.cod_area_empresa="+codAreaEmpresa;
                                        sql+=" and p.cod_tipomercaderia in("+tiposMercaderia+")";
                                        sql+=" and sv.cod_tiposalidaventas in("+tiposSalidas+")";
                                        sql+=" and sv.cod_almacen_venta in("+codAlmacenVenta+")";
                                        sql+=" and sv.fecha_salidaventa >='"+fechaInicio1+"'";
                                        sql+=" and sv.fecha_salidaventa <='"+fechaFinal1+"'";
                                        sql+=" and p.cod_lineamkt="+lineaMKT;
                                        System.out.println("sql:..................."+sql);
                                        Statement st1 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                        ResultSet rs1 = st1.executeQuery(sql);
                                        double mc_tot=0;
                                        while (rs1.next()){
                                                mc_tot=rs1.getDouble(1);
                                        }
                                        total_mc_tot=total_mc_tot+mc_tot;
                                        String sql2="";
                                        sql2+=" select isnull(sum(((isnull(sad.cantidad_total,0)*p.cantidad_presentacion)+isnull(sad.cantidad_unitariatotal,0))*sad.costo_actualizado),0)";
                                        //sql2+=" ((100-sad.porcentaje_aplicadoprecio)/100)*((100-sv.porcentaje_descuento)/100)),0)";
                                        sql2+=" from salidas_detalleventas sad, presentaciones_producto p,salidas_ventas sv,ALMACENES_VENTAS av";
                                        sql2+=" where sv.cod_estado_salidaventa<>2 and sv.cod_salidaventa=sad.cod_salidaventas and";
                                        sql2+=" sad.cod_presentacion=p.cod_presentacion and";
                                        sql2+=" sv.cod_almacen_venta = av.cod_almacen_venta";
                                        sql2+=" and av.cod_area_empresa="+codAreaEmpresa;
                                        sql2+=" and p.cod_tipomercaderia in("+tiposMercaderia+")";
                                        sql2+=" and sv.cod_tiposalidaventas in("+tiposSalidas+")";
                                        sql2+=" and sv.cod_almacen_venta in("+codAlmacenVenta+")";
                                        sql2+=" and sv.fecha_salidaventa >='"+fechaInicio1+"'";
                                        sql2+=" and sv.fecha_salidaventa <='"+fechaFinal1+"'";
                                        sql2+=" and p.cod_lineamkt="+lineaMKT;
                                        sql2+=" and sv.cod_tiposalidaventas=1";
                                        System.out.println("sql2:..................."+sql2);
                                        Statement st2 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                        ResultSet rs2 = st2.executeQuery(sql2);
                                        double mc_baj=0;
                                        while (rs2.next()){
                                                mc_baj=rs2.getDouble(1);
                                        }
                                        total_mc_baj=total_mc_baj+mc_baj;
                                        String sql3="";
                                        sql3+=" select isnull(sum(((isnull(sad.cantidad_total,0)*p.cantidad_presentacion)+isnull(sad.cantidad_unitariatotal,0))*sad.costo_actualizado),0)";
                                        //sql3+=" ((100-sad.porcentaje_aplicadoprecio)/100)*((100-sv.porcentaje_descuento)/100)),0)";
                                        sql3+=" from salidas_detalleventas sad, presentaciones_producto p,salidas_ventas sv,ALMACENES_VENTAS av";
                                        sql3+=" where sv.cod_estado_salidaventa<>2 and sv.cod_salidaventa=sad.cod_salidaventas and";
                                        sql3+=" sad.cod_presentacion=p.cod_presentacion and";
                                        sql3+=" sv.cod_almacen_venta = av.cod_almacen_venta";
                                        sql3+=" and av.cod_area_empresa="+codAreaEmpresa;
                                        sql3+=" and p.cod_tipomercaderia in("+tiposMercaderia+")";
                                        sql3+=" and sv.cod_tiposalidaventas in("+tiposSalidas+")";
                                        sql3+=" and sv.cod_almacen_venta in("+codAlmacenVenta+")";
                                        sql3+=" and sv.fecha_salidaventa >='"+fechaInicio1+"'";
                                        sql3+=" and sv.fecha_salidaventa <='"+fechaFinal1+"'";
                                        sql3+=" and p.cod_lineamkt="+lineaMKT;
                                        sql3+=" and sv.cod_tiposalidaventas=2";
                                        System.out.println("sql3:..................."+sql3);
                                        Statement st3 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                        ResultSet rs3 = st3.executeQuery(sql3);
                                        double mc_rea=0;
                                        while (rs3.next()){
                                                mc_rea=rs3.getDouble(1);
                                        }
                                        total_mc_rea=total_mc_rea+mc_rea;
                                        String sql41="";
                                        sql41+=" select isnull(sum(((isnull(sad.cantidad_total,0)*p.cantidad_presentacion)+isnull(sad.cantidad_unitariatotal,0))*sad.costo_actualizado),0)";
                                        //sql41+=" ((100-sad.porcentaje_aplicadoprecio)/100)*((100-sv.porcentaje_descuento)/100)),0)";
                                        sql41+=" from salidas_detalleventas sad, presentaciones_producto p,salidas_ventas sv,ALMACENES_VENTAS av";
                                        sql41+=" where sv.cod_estado_salidaventa<>2 and sv.cod_salidaventa=sad.cod_salidaventas and";
                                        sql41+=" sad.cod_presentacion=p.cod_presentacion and";
                                        sql41+=" sv.cod_almacen_venta = av.cod_almacen_venta";
                                        sql41+=" and av.cod_area_empresa="+codAreaEmpresa;
                                        sql41+=" and p.cod_tipomercaderia in("+tiposMercaderia+")";
                                        sql41+=" and sv.cod_tiposalidaventas in("+tiposSalidas+")";
                                        sql41+=" and sv.cod_almacen_venta in("+codAlmacenVenta+")";
                                        sql41+=" and sv.fecha_salidaventa >='"+fechaInicio1+"'";
                                        sql41+=" and sv.fecha_salidaventa <='"+fechaFinal1+"'";
                                        sql41+=" and p.cod_lineamkt="+lineaMKT;
                                        sql41+=" and sv.cod_tiposalidaventas=3 and sv.COD_TIPODOC_VENTA=1";
                                        System.out.println("sql41:..................."+sql41);
                                        Statement st41 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                        ResultSet rs41 = st41.executeQuery(sql41);
                                        double mc_ven_t1=0;
                                        while (rs41.next()){
                                                mc_ven_t1=rs41.getDouble(1);
                                        }
                                        total_mc_ven_t1=total_mc_ven_t1+mc_ven_t1;
                                        String sql42="";
                                        sql42+=" select isnull(sum(((isnull(sad.cantidad_total,0)*p.cantidad_presentacion)+isnull(sad.cantidad_unitariatotal,0))*sad.costo_actualizado),0)";
                                        //sql42+=" ((100-sad.porcentaje_aplicadoprecio)/100)*((100-sv.porcentaje_descuento)/100)),0)";
                                        sql42+=" from salidas_detalleventas sad, presentaciones_producto p,salidas_ventas sv,ALMACENES_VENTAS av";
                                        sql42+=" where sv.cod_estado_salidaventa<>2 and sv.cod_salidaventa=sad.cod_salidaventas and";
                                        sql42+=" sad.cod_presentacion=p.cod_presentacion and";
                                        sql42+=" sv.cod_almacen_venta = av.cod_almacen_venta";
                                        sql42+=" and av.cod_area_empresa="+codAreaEmpresa;
                                        sql42+=" and p.cod_tipomercaderia in("+tiposMercaderia+")";
                                        sql42+=" and sv.cod_tiposalidaventas in("+tiposSalidas+")";
                                        sql42+=" and sv.cod_almacen_venta in("+codAlmacenVenta+")";
                                        sql42+=" and sv.fecha_salidaventa >='"+fechaInicio1+"'";
                                        sql42+=" and sv.fecha_salidaventa <='"+fechaFinal1+"'";
                                        sql42+=" and p.cod_lineamkt="+lineaMKT;
                                        sql42+=" and sv.cod_tiposalidaventas=3 and sv.COD_TIPODOC_VENTA=2";
                                        System.out.println("sql42:..................."+sql42);
                                        Statement st42 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                        ResultSet rs42 = st42.executeQuery(sql42);
                                        double mc_ven_t2=0;
                                        while (rs42.next()){
                                                mc_ven_t2=rs42.getDouble(1);
                                        }
                                        total_mc_ven_t2=total_mc_ven_t2+mc_ven_t2;
                                        String sql43="";
                                        sql43+=" select isnull(sum(((isnull(sad.cantidad_total,0)*p.cantidad_presentacion)+isnull(sad.cantidad_unitariatotal,0))*sad.costo_actualizado),0)";
                                        //sql43+=" ((100-sad.porcentaje_aplicadoprecio)/100)*((100-sv.porcentaje_descuento)/100)),0)";
                                        sql43+=" from salidas_detalleventas sad, presentaciones_producto p,salidas_ventas sv,ALMACENES_VENTAS av";
                                        sql43+=" where sv.cod_estado_salidaventa<>2 and sv.cod_salidaventa=sad.cod_salidaventas and";
                                        sql43+=" sad.cod_presentacion=p.cod_presentacion and";
                                        sql43+=" sv.cod_almacen_venta = av.cod_almacen_venta";
                                        sql43+=" and av.cod_area_empresa="+codAreaEmpresa;
                                        sql43+=" and p.cod_tipomercaderia in("+tiposMercaderia+")";
                                        sql43+=" and sv.cod_tiposalidaventas in("+tiposSalidas+")";
                                        sql43+=" and sv.cod_almacen_venta in("+codAlmacenVenta+")";
                                        sql43+=" and sv.fecha_salidaventa >='"+fechaInicio1+"'";
                                        sql43+=" and sv.fecha_salidaventa <='"+fechaFinal1+"'";
                                        sql43+=" and p.cod_lineamkt="+lineaMKT;
                                        sql43+=" and sv.cod_tiposalidaventas=3 and sv.COD_TIPODOC_VENTA=3";
                                        System.out.println("sql43:..................."+sql43);
                                        Statement st43 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                        ResultSet rs43 = st43.executeQuery(sql43);
                                        double mc_ven_t3=0;
                                        while (rs43.next()){
                                                mc_ven_t3=rs43.getDouble(1);
                                        }
                                        total_mc_ven_t3=total_mc_ven_t3+mc_ven_t3;

                                        String sql5="";
                                        sql5+=" select isnull(sum(((isnull(sad.cantidad_total,0)*p.cantidad_presentacion)+isnull(sad.cantidad_unitariatotal,0))*sad.costo_actualizado),0)";
                                        //sql5+=" ((100-sad.porcentaje_aplicadoprecio)/100)*((100-sv.porcentaje_descuento)/100)),0)";
                                        sql5+=" from salidas_detalleventas sad, presentaciones_producto p,salidas_ventas sv,ALMACENES_VENTAS av";
                                        sql5+=" where sv.cod_estado_salidaventa<>2 and sv.cod_salidaventa=sad.cod_salidaventas and";
                                        sql5+=" sad.cod_presentacion=p.cod_presentacion and";
                                        sql5+=" sv.cod_almacen_venta = av.cod_almacen_venta";
                                        sql5+=" and av.cod_area_empresa="+codAreaEmpresa;
                                        sql5+=" and p.cod_tipomercaderia in("+tiposMercaderia+")";
                                        sql5+=" and sv.cod_tiposalidaventas in("+tiposSalidas+")";
                                        sql5+=" and sv.cod_almacen_venta in("+codAlmacenVenta+")";
                                        sql5+=" and sv.fecha_salidaventa >='"+fechaInicio1+"'";
                                        sql5+=" and sv.fecha_salidaventa <='"+fechaFinal1+"'";
                                        sql5+=" and p.cod_lineamkt="+lineaMKT;
                                        sql5+=" and sv.cod_tiposalidaventas=4 and p.cod_tipomercaderia=1 and sv.cod_almacen_venta<>54 and sv.COD_ALMACEN_VENTADESTINO in";
                                        sql5+=" (select s.cod_almacen_venta from ALMACENES_VENTAS s where s.cod_area_empresa in(49,47,46,63,48,51,52,53,54,56,55))";
                                        System.out.println("sql5:..................."+sql5);
                                        Statement st5 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                        ResultSet rs5 = st5.executeQuery(sql5);
                                        double mc_tra=0;
                                        while (rs5.next()){
                                                mc_tra=rs5.getDouble(1);
                                        }
                                        total_mc_tra=total_mc_tra+mc_tra;
//***************************************************
                                        String sql55="";
                                        sql55+=" select isnull(sum(((isnull(sad.cantidad_total,0)*p.cantidad_presentacion)+isnull(sad.cantidad_unitariatotal,0))*sad.costo_actualizado),0)";
                                        //sql55+=" ((100-sad.porcentaje_aplicadoprecio)/100)*((100-sv.porcentaje_descuento)/100)),0)";
                                        sql55+=" from salidas_detalleventas sad, presentaciones_producto p,salidas_ventas sv,ALMACENES_VENTAS av";
                                        sql55+=" where sv.cod_estado_salidaventa<>2 and sv.cod_salidaventa=sad.cod_salidaventas and";
                                        sql55+=" sad.cod_presentacion=p.cod_presentacion and";
                                        sql55+=" sv.cod_almacen_venta = av.cod_almacen_venta";
                                        sql55+=" and av.cod_area_empresa="+codAreaEmpresa;
                                        sql55+=" and p.cod_tipomercaderia in("+tiposMercaderia+")";
                                        sql55+=" and sv.cod_tiposalidaventas in("+tiposSalidas+")";
                                        sql55+=" and sv.cod_almacen_venta in("+codAlmacenVenta+")";
                                        sql55+=" and sv.fecha_salidaventa >='"+fechaInicio1+"'";
                                        sql55+=" and sv.fecha_salidaventa <='"+fechaFinal1+"'";
                                        sql55+=" and p.cod_lineamkt="+lineaMKT;
                                        sql55+=" and sv.cod_tiposalidaventas=4 and p.cod_tipomercaderia=1 and sv.cod_almacen_venta=54 and sv.cod_almacen_venta<>sv.COD_ALMACEN_VENTADESTINO";
                                        System.out.println("sql55:..................."+sql55);
                                        Statement st55 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                        ResultSet rs55 = st5.executeQuery(sql55);
                                        double mc_tra_cu=0;
                                        while (rs55.next()){
                                                mc_tra_cu=rs55.getDouble(1);
                                        }
                                        total_mc_tra_cu=total_mc_tra_cu+mc_tra_cu;
//**************************************************

                                        String sql6="";
                                        sql6+=" select isnull(sum(((isnull(sad.cantidad_total,0)*p.cantidad_presentacion)+isnull(sad.cantidad_unitariatotal,0))*sad.costo_actualizado),0)";
                                        //sql6+=" ((100-sad.porcentaje_aplicadoprecio)/100)*((100-sv.porcentaje_descuento)/100)),0)";
                                        sql6+=" from salidas_detalleventas sad, presentaciones_producto p,salidas_ventas sv,ALMACENES_VENTAS av";
                                        sql6+=" where sv.cod_estado_salidaventa<>2 and sv.cod_salidaventa=sad.cod_salidaventas and";
                                        sql6+=" sad.cod_presentacion=p.cod_presentacion and";
                                        sql6+=" sv.cod_almacen_venta = av.cod_almacen_venta";
                                        sql6+=" and av.cod_area_empresa="+codAreaEmpresa;
                                        sql6+=" and p.cod_tipomercaderia in("+tiposMercaderia+")";
                                        sql6+=" and sv.cod_tiposalidaventas in("+tiposSalidas+")";
                                        sql6+=" and sv.cod_almacen_venta in("+codAlmacenVenta+")";
                                        sql6+=" and sv.fecha_salidaventa >='"+fechaInicio1+"'";
                                        sql6+=" and sv.fecha_salidaventa <='"+fechaFinal1+"'";
                                        sql6+=" and p.cod_lineamkt="+lineaMKT;
                                        sql6+=" and sv.cod_tiposalidaventas=5";
                                        System.out.println("sql6:..................."+sql6);
                                        Statement st6 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                        ResultSet rs6 = st6.executeQuery(sql6);
                                        double mc_aju=0;
                                        while (rs6.next()){
                                                mc_aju=rs6.getDouble(1);
                                        }
                                        total_mc_aju=total_mc_aju+mc_aju;
                                        String sql7="";
                                        sql7+=" select isnull(sum(((isnull(sad.cantidad_total,0)*p.cantidad_presentacion)+isnull(sad.cantidad_unitariatotal,0))*sad.costo_actualizado),0)";
                                        //sql7+=" ((100-sad.porcentaje_aplicadoprecio)/100)*((100-sv.porcentaje_descuento)/100)),0)";
                                        sql7+=" from salidas_detalleventas sad, presentaciones_producto p,salidas_ventas sv,ALMACENES_VENTAS av";
                                        sql7+=" where sv.cod_estado_salidaventa<>2 and sv.cod_salidaventa=sad.cod_salidaventas and";
                                        sql7+=" sad.cod_presentacion=p.cod_presentacion and";
                                        sql7+=" sv.cod_almacen_venta = av.cod_almacen_venta";
                                        sql7+=" and av.cod_area_empresa="+codAreaEmpresa;
                                        sql7+=" and p.cod_tipomercaderia in("+tiposMercaderia+")";
                                        sql7+=" and sv.cod_tiposalidaventas in("+tiposSalidas+")";
                                        sql7+=" and sv.cod_almacen_venta in("+codAlmacenVenta+")";
                                        sql7+=" and sv.fecha_salidaventa >='"+fechaInicio1+"'";
                                        sql7+=" and sv.fecha_salidaventa <='"+fechaFinal1+"'";
                                        sql7+=" and p.cod_lineamkt="+lineaMKT;
                                        sql7+=" and sv.cod_tiposalidaventas=7";
                                        System.out.println("sql7:..................."+sql7);
                                        Statement st7 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                        ResultSet rs7 = st7.executeQuery(sql7);
                                        double mc_rep=0;
                                        while (rs7.next()){
                                                mc_rep=rs7.getDouble(1);
                                        }
                                        total_mc_rep=total_mc_rep+mc_rep;
                                        String sql81="";
                                        sql81+=" select isnull(sum(((isnull(sad.cantidad_total,0)*p.cantidad_presentacion)+isnull(sad.cantidad_unitariatotal,0))*sad.costo_actualizado),0)";
                                        //sql81+=" ((100-sad.porcentaje_aplicadoprecio)/100)*((100-sv.porcentaje_descuento)/100)),0)";
                                        sql81+=" from salidas_detalleventas sad, presentaciones_producto p,salidas_ventas sv,ALMACENES_VENTAS av";
                                        sql81+=" where sv.cod_estado_salidaventa<>2 and sv.cod_salidaventa=sad.cod_salidaventas and";
                                        sql81+=" sad.cod_presentacion=p.cod_presentacion and";
                                        sql81+=" sv.cod_almacen_venta = av.cod_almacen_venta";
                                        sql81+=" and av.cod_area_empresa="+codAreaEmpresa;
                                        sql81+=" and p.cod_tipomercaderia in("+tiposMercaderia+")";
                                        sql81+=" and sv.cod_tiposalidaventas in("+tiposSalidas+")";
                                        sql81+=" and sv.cod_almacen_venta in("+codAlmacenVenta+")";
                                        sql81+=" and sv.fecha_salidaventa >='"+fechaInicio1+"'";
                                        sql81+=" and sv.fecha_salidaventa <='"+fechaFinal1+"'";
                                        sql81+=" and p.cod_lineamkt="+lineaMKT;
                                        sql81+=" and sv.cod_tiposalidaventas=4 and p.cod_tipomercaderia=5 and sv.cod_almacen_venta<>sv.COD_ALMACEN_VENTADESTINO";
                                        System.out.println("sql81:..................."+sql81);
                                        Statement st81 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                        ResultSet rs81 = st81.executeQuery(sql81);
                                        double mc_pro_mm=0;
                                        while (rs81.next()){
                                                mc_pro_mm=rs81.getDouble(1);
                                        }
                                        total_mc_pro_mm=total_mc_pro_mm+mc_pro_mm;

//**************
                                        String sql810="";
                                        sql810+=" select isnull(sum(((isnull(sad.cantidad_total,0)*p.cantidad_presentacion)+isnull(sad.cantidad_unitariatotal,0))*sad.costo_actualizado),0)";
                                        //sql810+=" ((100-sad.porcentaje_aplicadoprecio)/100)*((100-sv.porcentaje_descuento)/100)),0)";
                                        sql810+=" from salidas_detalleventas sad, presentaciones_producto p,salidas_ventas sv,ALMACENES_VENTAS av";
                                        sql810+=" where sv.cod_estado_salidaventa<>2 and sv.cod_salidaventa=sad.cod_salidaventas and";
                                        sql810+=" sad.cod_presentacion=p.cod_presentacion and";
                                        sql810+=" sv.cod_almacen_venta = av.cod_almacen_venta";
                                        sql810+=" and av.cod_area_empresa="+codAreaEmpresa;
                                        sql810+=" and p.cod_tipomercaderia in("+tiposMercaderia+")";
                                        sql810+=" and sv.cod_tiposalidaventas in("+tiposSalidas+")";
                                        sql810+=" and sv.cod_almacen_venta in("+codAlmacenVenta+")";
                                        sql810+=" and sv.fecha_salidaventa >='"+fechaInicio1+"'";
                                        sql810+=" and sv.fecha_salidaventa <='"+fechaFinal1+"'";
                                        sql810+=" and p.cod_lineamkt="+lineaMKT;
                                        sql810+=" and sv.cod_tiposalidaventas=4 and p.cod_tipomercaderia=1 and sv.cod_almacen_venta<>54 and sv.COD_ALMACEN_VENTADESTINO <>ALL";
                                        sql810+=" (select s.cod_almacen_venta from ALMACENES_VENTAS s where s.cod_area_empresa in(49,47,46,63,48,51,52,53,54,56,55))";

                                        System.out.println("sql810:..................."+sql810);
                                        Statement st810 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                        ResultSet rs810 = st810.executeQuery(sql810);
                                        double mc_pro_mm_cu=0;
                                        while (rs810.next()){
                                                mc_pro_mm_cu=rs810.getDouble(1);
                                        }
                                        total_mc_pro_mm_cu=total_mc_pro_mm_cu+mc_pro_mm_cu;

//****************
                                        String sql82="";
                                        sql82+=" select isnull(sum(((isnull(sad.cantidad_total,0)*p.cantidad_presentacion)+isnull(sad.cantidad_unitariatotal,0))*sad.costo_actualizado),0)";
                                        //sql82+=" ((100-sad.porcentaje_aplicadoprecio)/100)*((100-sv.porcentaje_descuento)/100)),0)";
                                        sql82+=" from salidas_detalleventas sad, presentaciones_producto p,salidas_ventas sv,ALMACENES_VENTAS av";
                                        sql82+=" where sv.cod_estado_salidaventa<>2 and sv.cod_salidaventa=sad.cod_salidaventas and";
                                        sql82+=" sad.cod_presentacion=p.cod_presentacion and";
                                        sql82+=" sv.cod_almacen_venta = av.cod_almacen_venta";
                                        sql82+=" and av.cod_area_empresa="+codAreaEmpresa;
                                        sql82+=" and p.cod_tipomercaderia in("+tiposMercaderia+")";
                                        sql82+=" and sv.cod_tiposalidaventas in("+tiposSalidas+")";
                                        sql82+=" and sv.cod_almacen_venta in("+codAlmacenVenta+")";
                                        sql82+=" and sv.fecha_salidaventa >='"+fechaInicio1+"'";
                                        sql82+=" and sv.fecha_salidaventa <='"+fechaFinal1+"'";
                                        sql82+=" and p.cod_lineamkt="+lineaMKT;
                                        sql82+=" and sv.cod_tiposalidaventas=6 and p.cod_tipomercaderia=1";
                                        System.out.println("sql82:..................."+sql82);
                                        Statement st82 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                        ResultSet rs82 = st82.executeQuery(sql82);
                                        double mc_pro_mc=0;
                                        while (rs82.next()){
                                                mc_pro_mc=rs82.getDouble(1);
                                        }
                                        total_mc_pro_mc=total_mc_pro_mc+mc_pro_mc;
                                %>
                                <tr>
                                    <td class="bordeNegroTd">&nbsp;<%=abreviatura%></td>
                                    <td class="bordeNegroTd">&nbsp;<%=nombreMKT%></td>

                                    <% if(mc_ven_t2==0){%>
                                    <td class="bordeNegroTd" align="right">0.00</td>
                                    <%}else{%>
                                    <td class="bordeNegroTd" align="right"><%=form1.format(mc_ven_t2)%></td>
                                    <%}%>

                                    <% if(mc_ven_t3==0){%>
                                    <td class="bordeNegroTd" align="right">0.00</td>
                                    <%}else{%>
                                    <td class="bordeNegroTd" align="right"><%=form1.format(mc_ven_t3)%></td>
                                    <%}%>

                                    <% if(mc_ven_t1==0){%>
                                    <td class="bordeNegroTd" align="right">0.00</td>
                                    <%}else{%>
                                    <td class="bordeNegroTd" align="right"><%=form1.format(mc_ven_t1)%></td>
                                    <%}%>

                                    <% if(mc_pro_mc==0){%>
                                    <td class="bordeNegroTd" align="right">0.00</td>
                                    <%}else{%>
                                    <td class="bordeNegroTd" align="right"><%=form1.format(mc_pro_mc)%></td>
                                    <%}%>

                                    <% if(mc_rep==0){%>
                                    <td class="bordeNegroTd" align="right">0.00</td>
                                    <%}else{%>
                                    <td class="bordeNegroTd" align="right"><%=form1.format(mc_rep)%></td>
                                    <%}%>

                                    <% if(mc_tra==0){%>
                                    <td class="bordeNegroTd" align="right">0.00</td>
                                    <%}else{%>
                                    <td class="bordeNegroTd" align="right"><%=form1.format(mc_tra)%></td>
                                    <%}%>

                                    <% if(mc_pro_mm==0){%>
                                    <td class="bordeNegroTd" align="right">0.00</td>
                                    <%}else{%>
                                    <td class="bordeNegroTd" align="right"><%=form1.format(mc_pro_mm)%></td>
                                    <%}%>

                                    <% if(mc_pro_mm_cu==0){%>
                                    <td class="bordeNegroTd" align="right">0.00</td>
                                    <%}else{%>
                                    <td class="bordeNegroTd" align="right"><%=form1.format(mc_pro_mm_cu)%></td>
                                    <%}%>

                                    <% if(mc_tra_cu==0){%>
                                    <td class="bordeNegroTd" align="right">0.00</td>
                                    <%}else{%>
                                    <td class="bordeNegroTd" align="right"><%=form1.format(mc_tra_cu)%></td>
                                    <%}%>

                                    <% if(mc_rea==0){%>
                                    <td class="bordeNegroTd" align="right">0.00</td>
                                    <%}else{%>
                                    <td class="bordeNegroTd" align="right"><%=form1.format(mc_rea)%></td>
                                    <%}%>

                                    <% if(mc_baj==0){%>
                                    <td class="bordeNegroTd" align="right">0.00</td>
                                    <%}else{%>
                                    <td class="bordeNegroTd" align="right"><%=form1.format(mc_baj)%></td>
                                    <%}%>

                                    <% if(mc_aju==0){%>
                                    <td class="bordeNegroTd" align="right">0.00</td>
                                    <%}else{%>
                                    <td class="bordeNegroTd" align="right"><%=form1.format(mc_aju)%></td>
                                    <%}%>

                                    <% if(mc_tot==0){%>
                                    <td class="bordeNegroTd" align="right">0.00</td>
                                    <%}else{%>
                                    <td class="bordeNegroTd" align="right"><%=form1.format(mc_tot)%></td>
                                    <%}%>

                                    <% if(ajuste_linea==0){%>
                                    <td class="bordeNegroTd" align="right">0.00</td>
                                    <%}else{%>
                                    <td class="bordeNegroTd" align="right"><%=form1.format(ajuste_linea)%></td>
                                    <%}%>

                                    <% if(total_saldo==0){%>
                                    <td class="bordeNegroTd" align="right">0.00</td>
                                    <%}else{%>
                                    <td class="bordeNegroTd" align="right"><%=form1.format(total_saldo)%></td>
                                    <%}%>
                                </tr>
                                <%
                                total_ajuste_linea=total_ajuste_linea+ajuste_linea;
                                }
                                con.close();
                                } catch(Exception e) {
                                }
                                %>
                                <tr class="tituloCampo">
                                    <td colspan="2" class="bordeNegroTd"><B>TOTAL INFORME</B></td>

                                    <% if(total_mc_ven_t2==0){%>
                                    <td class="bordeNegroTd" align="right"><B>0.00</B></td>
                                    <%}else{%>
                                    <td class="bordeNegroTd" align="right"><B><%=form1.format(total_mc_ven_t2)%></B></td>
                                    <%}%>

                                    <% if(total_mc_ven_t3==0){%>
                                    <td class="bordeNegroTd" align="right"><B>0.00</B></td>
                                    <%}else{%>
                                    <td class="bordeNegroTd" align="right"><B><%=form1.format(total_mc_ven_t3)%></B></td>
                                    <%}%>

                                    <% if(total_mc_ven_t1==0){%>
                                    <td class="bordeNegroTd" align="right"><B>0.00</B></td>
                                    <%}else{%>
                                    <td class="bordeNegroTd" align="right"><B><%=form1.format(total_mc_ven_t1)%></B></td>
                                    <%}%>

                                    <% if(total_mc_pro_mc==0){%>
                                    <td class="bordeNegroTd" align="right"><B>0.00</B></td>
                                    <%}else{%>
                                    <td class="bordeNegroTd" align="right"><B><%=form1.format(total_mc_pro_mc)%></B></td>
                                    <%}%>

                                    <% if(total_mc_rep==0){%>
                                    <td class="bordeNegroTd" align="right"><B>0.00</B></td>
                                    <%}else{%>
                                    <td class="bordeNegroTd" align="right"><B><%=form1.format(total_mc_rep)%></B></td>
                                    <%}%>

                                    <% if(total_mc_tra==0){%>
                                    <td class="bordeNegroTd" align="right"><B>0.00</B></td>
                                    <%}else{%>
                                    <td class="bordeNegroTd" align="right"><B><%=form1.format(total_mc_tra)%></B></td>
                                    <%}%>

                                    <% if(total_mc_pro_mm==0){%>
                                    <td class="bordeNegroTd" align="right"><B>0.00</B></td>
                                    <%}else{%>
                                    <td class="bordeNegroTd" align="right"><B><%=form1.format(total_mc_pro_mm)%></B></td>
                                    <%}%>

                                    <% if(total_mc_pro_mm_cu==0){%>
                                    <td class="bordeNegroTd" align="right"><B>0.00</B></td>
                                    <%}else{%>
                                    <td class="bordeNegroTd" align="right"><B><%=form1.format(total_mc_pro_mm_cu)%></B></td>
                                    <%}%>

                                    <% if(total_mc_tra_cu==0){%>
                                    <td class="bordeNegroTd" align="right"><B>0.00</B></td>
                                    <%}else{%>
                                    <td class="bordeNegroTd" align="right"><B><%=form1.format(total_mc_tra_cu)%></B></td>
                                    <%}%>

                                    <% if(total_mc_rea==0){%>
                                    <td class="bordeNegroTd" align="right"><B>0.00</B></td>
                                    <%}else{%>
                                    <td class="bordeNegroTd" align="right"><B><%=form1.format(total_mc_rea)%></B></td>
                                    <%}%>

                                    <% if(total_mc_baj==0){%>
                                    <td class="bordeNegroTd" align="right"><B>0.00</B></td>
                                    <%}else{%>
                                    <td class="bordeNegroTd" align="right"><B><%=form1.format(total_mc_baj)%></B></td>
                                    <%}%>

                                    <% if(total_mc_aju==0){%>
                                    <td class="bordeNegroTd" align="right"><B>0.00</B></td>
                                    <%}else{%>
                                    <td class="bordeNegroTd" align="right"><B><%=form1.format(total_mc_aju)%></B></td>
                                    <%}%>

                                    <% if(total_mc_tot==0){%>
                                    <td class="bordeNegroTd" align="right"><B>0.00</B></td>
                                    <%}else{%>
                                    <td class="bordeNegroTd" align="right"><B><%=form1.format(total_mc_tot)%></B></td>
                                    <%}%>

                                    <% if(total_ajuste_linea==0){%>
                                    <td class="bordeNegroTd" align="right"><b>0.00</b></td>
                                    <%}else{%>
                                    <td class="bordeNegroTd" align="right"><b><%=form1.format(total_ajuste_linea)%></b></td>
                                    <%}%>

                                    <% if(total_saldo_final==0){%>
                                    <td class="bordeNegroTd" align="right"><b>0.00</b></td>
                                    <%}else{%>
                                    <td class="bordeNegroTd" align="right"><b><%=form1.format(total_saldo_final)%></b></td>
                                    <%}%>
                                </tr>

                            </table>
                        </td>
                    </tr>
                </table>
            </div>


        </form>
        <script type="text/javascript" language="JavaScript"  src="../../js/dlcalendarCostos.js"></script>
    </body>
</html>