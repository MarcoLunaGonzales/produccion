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

Connection con=null; %>
<link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
<html>
    <body>
        <form method="post" action="">        
            <%
            String fechaInicio = request.getParameter("fecha_inicio");
            String fechaFinal = request.getParameter("fecha_final");
            String fechaFinalF=fechaFinal;
            String codPresentacion = request.getParameter("codproducto");
            String codAlmacenVenta = request.getParameter("codAlmacen");
	   
  	    String codAreaEmpresa = request.getParameter("codAreaEmpresa");

            String[] vectorFechaInicio = fechaInicio.split("/");
            String[] vectorFechaFinal = fechaFinal.split("/");
            String fechaInicio1=vectorFechaInicio[1]+"/"+vectorFechaInicio[0]+"/"+vectorFechaInicio[2];
            String fechaFinal1=vectorFechaFinal[1]+"/"+vectorFechaFinal[0]+"/"+vectorFechaFinal[2];
            String codigoPersonal="";
            String sqlPresentaciones="";
            String sql="";
            String sql2="";
            int codReporte=1;
            int codReporte2=1;
            String saldo="0";
            String saldoCajas="0";
            String fechaAnterior="";
            float totalEntrada=0;
            float totalSalida=0;
            float totalEntradaCajas=0;
            float totalSalidaCajas=0;
            float totalAct=0;
            float totalEntradaDinero=0;
            float totalSalidaDinero=0;
            float ufvPromedio;
            String valorUfvActual;
            String fechaIngresoAlmacen;
            String fechaSalidaAlmacen;
            //String debe;
            //String haber;
            String fecha_1;
            String fecha_2;
            String fecha11;
            String fecha22;
            String fechaAnteriorSaldo;
            String ingresosTotalAnterior;
            String ingresosTotalAnteriorCajas="0";
            String salidasTotalAnterior;
            String salidasTotalAnteriorCajas="0";
            String ingresosTotalAnteriorDinero;
            String salidasTotalAnteriorDinero="0";
            String cantidadRestanteAnteriorDineroActualizado;
            String cantidadRestanteAnterior;
            String cantidadRestanteAnteriorCajas;
            String cantidadRestanteAnteriorKardexmovimientoGlobal;
            String cantidadRestanteAnteriorKardexmovimientoCajasGlobal;
            String cantidadRestanteAnteriorKardexmovimientoGlobalDinero;
            String cantidadRestanteAnteriorDinero;
            String saldoDinero;
            String diferenciaAjuste;
            String costoUnitario="";
            String costoUnitario_kardex="";
            String costoIngreso="";
            String tipo;
            String valorUfvAnterior,valorUfv,fechaAnterior1,valorUfv11,valorUfv1="";
            float cantidadIngreso=0;
            float cantidadSalida=0;
            float cantidadIngresoCajas=0;
            float cantidadSalidaCajas=0;
            
            float debe=0;
            float haber=0;
            float ufv=0;
            
            
            Statement st;
            Statement st1;
            Statement st2;
            Statement st3;
            ResultSet rs;
            ResultSet rs1;
            ResultSet rs2;
            ResultSet rs3;
            DateTime fecha1;
            java.util.Date fechaInicioDate;
            java.util.Date fechaFinalDate;
            java.util.TimeZone horaInicioDate;
            int rsConsulta;
            int contador;
            //*********
            String fechaIngresoventas;
            String horaIngresoventas;
            String codIngresoventas;
            float cantidad;
            float cantidadUnitaria;
            double costoAlmacen=0.0d;
            String costoActualizado;
            String costoActualizadoFinal;
            String nroIngresoventas;
            String codTipoingresoventas;
            String nombreTipoingresoventas;
            String obsIngresoventas;
            String codLoteProduccionIngreso="";
            SimpleDateFormat f2=new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
            
            NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
            DecimalFormat form1 = (DecimalFormat)nf;
            form1.applyPattern("#,###.00");
            
            NumberFormat nf2 = NumberFormat.getNumberInstance(Locale.ENGLISH);
            DecimalFormat form2 = (DecimalFormat)nf2;
            form2.applyPattern("#,###.00000");
            
            //**********
            
            
            
            //ManagedAccesoSistema bean=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
            
            codigoPersonal="481";
            
            SimpleDateFormat f=new SimpleDateFormat("MM/dd/yyyy");
            con=Util.openConnection(con);
            //System.out.println("fecha slado1111111 ..................."+fechaAnterior);
            fechaAnterior=vectorFechaInicio[1]+"/"+vectorFechaInicio[0]+"/"+vectorFechaInicio[2];
            //fechaAnterior="07/31/2008";
            fecha_1=fechaAnterior;
            fechaAnterior=fechaAnterior+" 00:00:00";
            //System.out.println("fecha slado12222222222 ..................."+fechaAnterior);
            fechaAnteriorSaldo=fechaAnterior;
            
            
            codReporte=1;
            saldo="0";
            //con=Util.openConnection(con);
            sql="";
            sql=" delete from kardex_item_movimiento";
            sql+="  where cod_persona="+codigoPersonal;
            //System.out.println("sql:..................."+sql);
            st1 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            rsConsulta = st1.executeUpdate(sql);
            //*saca el valor de UFV
            sql="";
            sql+=" SELECT top 1 cambio,ISNULL(fecha,'01-01-1900') as fecha FROM tipocambios_moneda";
            sql+=" where cod_moneda=4 and fecha<'"+fechaAnterior+"' order by fecha desc";
            //System.out.println("sql:..................."+sql);
            st1 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            rs1 = st1.executeQuery(sql);
            valorUfv="0";
            while (rs1.next()){
                valorUfv=rs1.getString("cambio");
            }
            sql="";
            sql+=" SELECT top 1 ISNULL(fecha_actualizacion,'01-01-1900') as fecha_actualizacion,costo_actualizado_final from SALIDAS_DETALLEVENTAS";
            sql+=" where cod_presentacion="+codPresentacion+" and fecha_actualizacion<'"+fechaAnterior+"' order by fecha_actualizacion desc";
            //System.out.println("sql:..................."+sql);
            st1 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            rs1 = st1.executeQuery(sql);
            rs1.last();
            
            sql2="";
            sql2+=" SELECT top 1 ISNULL(fecha_actualizacion,'01-01-1900') as fecha_actualizacion,costo_actualizado_final from INGRESOS_DETALLEVENTAS";
            sql2+=" where cod_presentacion="+codPresentacion+" and fecha_actualizacion<'"+fechaAnterior+"' order by fecha_actualizacion desc";
            //System.out.println("sql:..................."+sql2);
            st2 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            rs2 = st2.executeQuery(sql2);
            rs2.last();
            
            //fechaAnteriorSaldo="";
            String  date1;
            String  date2;
            
            if(rs2.getRow()>0 && rs1.getRow()>0 ){
                rs2.first();
                rs1.first();
                //System.out.println("costoUnitario1111 slado ..................."+rs2.getString("fecha_actualizacion"));
                //System.out.println("costoUnitario2222..................."+rs1.getString("fecha_actualizacion"));
                date1=rs1.getString("fecha_actualizacion");
                date2=rs2.getString("fecha_actualizacion");
                String[] fechaInicioAux = date1.split(" ");
                String[] fechaFinalAux = date2.split(" ");
                date1=fechaInicioAux[0];
                date2=fechaFinalAux[0];
                java.sql.Date aux1=java.sql.Date.valueOf(date1);
                java.sql.Date aux2=java.sql.Date.valueOf(date2);
                if(aux1.compareTo(aux2)<0){
                    
                    fechaAnteriorSaldo=f.format(aux2);
                    costoUnitario=rs2.getString("costo_actualizado_final");
                    
                    
                }else{
                    fechaAnteriorSaldo=f.format(aux1);
                    costoUnitario=rs1.getString("costo_actualizado_final");
                    //System.out.println("costoUnitario2222..................."+rs1.getString("costo_actualizado_final"));
                }
            }else{
                if (rs2.getRow()>1){
                    date2=rs2.getString("fecha_actualizacion");
                    String[] fechaFinalAux = date2.split(" ");
                    date2=fechaFinalAux[0];
                    costoUnitario=rs2.getString("costo_actualizado_final");
                    java.sql.Date aux2=java.sql.Date.valueOf(date2);
                    fechaAnteriorSaldo=f.format(aux2);
                }else{
                    if (rs1.getRow()>1){
                        date1=rs1.getString("fecha_actualizacion");
                        String[] fechaFinalAux = date1.split(" ");
                        date1=fechaFinalAux[0];
                        costoUnitario=rs1.getString("costo_actualizado_final");
                        java.sql.Date aux1=java.sql.Date.valueOf(date1);
                        fechaAnteriorSaldo=f.format(aux1);
                    }
                }
                
            }
            System.out.println("costoUnitario..................."+costoUnitario);
            sql2="";
            sql2+=" SELECT top 1 cambio,fecha FROM tipocambios_moneda ";
            sql2+=" where cod_moneda=4 and fecha<='"+fechaAnteriorSaldo+"' order by fecha desc";
            System.out.println("fechaAnteriorSaldo..................."+fechaAnteriorSaldo);
            //System.out.println("sql:..................."+sql2);
            st2 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            rs2 = st2.executeQuery(sql2);
            valorUfvAnterior="0";
            while (rs2.next()){
                valorUfvAnterior=rs2.getString("cambio");
            }
            sql2="";
            sql2+=" SELECT ISNULL(sum(iad.cantidad),0)as ingresos_total_anterior,ISNULL(sum(iad.cantidad_unitaria),0)as ingresos_total_anterior_unitario";
            sql2+=" FROM ingresos_detalleventas iad,ingresos_ventas ia";
            sql2+=" where iad.cod_ingresoventas=ia.cod_ingresoventas and ia.COD_AREA_EMPRESA=iad.COD_AREA_EMPRESA ";
            sql2+=" and ia.cod_estado_ingresoventas<>2 and ia.COD_AREA_EMPRESA="+codAreaEmpresa;
            sql2+=" and iad.cod_presentacion="+codPresentacion;
            sql2+=" and ia.cod_almacen_venta="+codAlmacenVenta;
            sql2+=" and ia.fecha_ingresoventas<'"+fechaAnterior+"'";
            System.out.println("sql:..................."+sql2);
            st2 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            rs2 = st2.executeQuery(sql2);
            ingresosTotalAnterior="0";
            float cantidad_presentacion=0;
            while (rs2.next()){
                //cantidadUnitaria=rs2.getFloat("ingresos_total_anterior");
                ingresosTotalAnteriorCajas=rs2.getString("ingresos_total_anterior");
                ingresosTotalAnteriorCajas=(ingresosTotalAnteriorCajas==null)?"0":ingresosTotalAnteriorCajas;
                ingresosTotalAnterior=rs2.getString("ingresos_total_anterior_unitario");
                ingresosTotalAnterior=(ingresosTotalAnterior==null)?"0":ingresosTotalAnterior;
                
                sql="";
                sql+=" SELECT cantidad_presentacion";
                sql+=" FROM presentaciones_producto";
                sql+=" where cod_presentacion="+codPresentacion;
                //System.out.println("sql:..................."+sql);
                st1 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                rs1 = st1.executeQuery(sql);
                while (rs1.next()){
                    cantidad_presentacion=rs1.getFloat("cantidad_presentacion");
                    //            cantidadUnitaria=cantidadUnitaria*cantidad_presentacion;
                    //            ingresosTotalAnterior=String.valueOf(Float.parseFloat(ingresosTotalAnterior)+cantidadUnitaria);
                }
                
            }
            
            sql2="";
            sql2+=" SELECT ISNULL(sum(sad.cantidad_total),0)as salidas_total_anterior,ISNULL(sum(sad.cantidad_unitariatotal),0)as salidas_total_anterior_unitario";
            sql2+=" FROM salidas_detalleventas sad,salidas_ventas sa";
            sql2+=" where sad.cod_salidaventas=sa.cod_salidaventa and sa.COD_AREA_EMPRESA=sad.COD_AREA_EMPRESA and sa.COD_AREA_EMPRESA="+codAreaEmpresa;
            sql2+=" and sa.cod_estado_salidaventa<>2";
            sql2+=" and sad.cod_presentacion="+codPresentacion;
            sql2+=" and sa.cod_almacen_venta="+codAlmacenVenta;
            sql2+=" and sa.fecha_salidaventa<'"+fechaAnterior+"'";
            System.out.println("sql:..................."+sql2);
            st2 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            rs2 = st2.executeQuery(sql2);
            salidasTotalAnterior="0";
            while (rs2.next()){
                //cantidadUnitaria=rs2.getFloat("salidas_total_anterior");
                salidasTotalAnteriorCajas=rs2.getString("salidas_total_anterior");
                salidasTotalAnteriorCajas=(salidasTotalAnteriorCajas==null)?"0":salidasTotalAnteriorCajas;
                salidasTotalAnterior=rs2.getString("salidas_total_anterior_unitario");
                salidasTotalAnterior=(salidasTotalAnterior==null)?"0":salidasTotalAnterior;
                sql="";
                sql+=" SELECT cantidad_presentacion";
                sql+=" FROM presentaciones_producto";
                sql+=" where cod_presentacion="+codPresentacion;
                //System.out.println("sql:..................."+sql);
                st1 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                rs1 = st1.executeQuery(sql);
                while (rs1.next()){
                    cantidad_presentacion=rs1.getFloat("cantidad_presentacion");
                    //            cantidadUnitaria=cantidadUnitaria*cantidad_presentacion;
                    
                    //            salidasTotalAnterior=String.valueOf(Float.parseFloat(salidasTotalAnterior)+cantidadUnitaria);
                }
                
            }
            cantidadRestanteAnterior=String.valueOf(Float.parseFloat(ingresosTotalAnterior) -Float.parseFloat(salidasTotalAnterior));
            cantidadRestanteAnteriorCajas=String.valueOf(Float.parseFloat(ingresosTotalAnteriorCajas) -Float.parseFloat(salidasTotalAnteriorCajas));
            while(Float.parseFloat(cantidadRestanteAnterior)<0){
                cantidadRestanteAnterior=String.valueOf(Float.parseFloat(cantidadRestanteAnterior)+cantidad_presentacion);
                cantidadRestanteAnteriorCajas=String.valueOf(Float.parseFloat(cantidadRestanteAnteriorCajas)-1);
            }
            cantidadRestanteAnteriorKardexmovimientoGlobal=cantidadRestanteAnterior;
            cantidadRestanteAnteriorKardexmovimientoCajasGlobal=cantidadRestanteAnteriorCajas;
            System.out.println("cantidadRestanteAnteriorKardexmovimientoGlobal:..................."+cantidadRestanteAnteriorKardexmovimientoGlobal);
            System.out.println("cantidadRestanteAnteriorKardexmovimientoGlobalCajas:..................."+cantidadRestanteAnteriorKardexmovimientoCajasGlobal);
            //saldo dinero
            float costo_aux=0;
            if(costoUnitario ==""){costo_aux=0;} else{costo_aux=Float.parseFloat(costoUnitario);}
            cantidadRestanteAnteriorDineroActualizado=String.valueOf((Float.parseFloat(cantidadRestanteAnterior)*costo_aux)+Float.parseFloat(cantidadRestanteAnteriorCajas)*costo_aux*cantidad_presentacion);
            cantidadRestanteAnteriorKardexmovimientoGlobalDinero=cantidadRestanteAnteriorDineroActualizado;
            System.out.println("cantidadRestanteAnteriorKardexmovimientoGlobalDinero..................."+cantidadRestanteAnteriorKardexmovimientoGlobalDinero);
            fechaInicio=vectorFechaInicio[1]+"/"+vectorFechaInicio[0]+"/"+vectorFechaInicio[2];
            fechaFinal=vectorFechaFinal[1]+"/"+vectorFechaFinal[0]+"/"+vectorFechaFinal[2]+" 23:59:59";
            
            //proceso para calcular el ufv actual
            sql2="";
            sql2+=" SELECT top 1 cambio,fecha FROM tipocambios_moneda ";
            sql2+=" where cod_moneda=4 and fecha<='"+fechaFinal+"' order by fecha desc";
            //System.out.println("sql:..................."+sql2);
            st2 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            rs2 = st2.executeQuery(sql2);
            valorUfvActual="0";
            while (rs2.next()){
                valorUfvActual=rs2.getString("cambio");
            }
            //**********
            
            tipo="Ingreso";
            ///Proceso para introducir los ingresos
            sql2="";
            //    sql2+=" SELECT  ia.fecha_ingresoventas,iad.cod_ingresoventas,iad.cod_presentacion,(iad.cantidad*"+cantidad_presentacion+")as cantidad,";
            sql2+=" SELECT  ia.fecha_ingresoventas,iad.cod_ingresoventas,iad.cod_presentacion,(iad.cantidad)as cantidad,";
            sql2+=" iad.cantidad_unitaria,iad.costo_almacen,iad.costo_actualizado,";
            sql2+=" iad.costo_actualizado_final,ia.nro_ingresoventas,";
            sql2+=" ia.cod_almacen_venta,ia.cod_tipoingresoventas,tiv.nombre_tipoingresoventas";
            sql2+=" ,iad.COD_LOTE_PRODUCCION,ia.obs_ingresoventas";
            sql2+=" FROM ingresos_detalleventas iad,";
            sql2+=" ingresos_ventas ia,tipos_ingresoventas tiv";
            sql2+=" where iad.cod_ingresoventas=ia.cod_ingresoventas and iad.COD_AREA_EMPRESA=ia.COD_AREA_EMPRESA and ia.COD_AREA_EMPRESA="+codAreaEmpresa;
            sql2+=" and ia.cod_estado_ingresoventas<>2";
            sql2+=" and ia.cod_tipoingresoventas=tiv.cod_tipoingresoventas";
            sql2+=" and iad.cod_presentacion="+codPresentacion;
            sql2+=" and ia.cod_almacen_venta="+codAlmacenVenta;
            sql2+=" and ia.fecha_ingresoventas>='"+fechaInicio+"'";
            sql2+=" and ia.fecha_ingresoventas<='"+fechaFinal+"'";
            System.out.println("sql:...................WILMER:"+sql2);
            st2 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            rs2 = st2.executeQuery(sql2);
            while (rs2.next()){
                fechaInicioDate=rs2.getDate("fecha_ingresoventas");
                horaIngresoventas=rs2.getTime("fecha_ingresoventas").toString();
                System.out.println("fecha de ingreso a almacen:..................."+fechaInicioDate+ "hora"+horaIngresoventas);
                
                fechaIngresoAlmacen=f.format(fechaInicioDate);
                fechaIngresoAlmacen=fechaIngresoAlmacen+" "+horaIngresoventas;
                fechaIngresoventas=fechaIngresoAlmacen;
                codIngresoventas=rs2.getString("cod_ingresoventas");
                codPresentacion=rs2.getString("cod_presentacion");
                cantidad=rs2.getFloat("cantidad");
                cantidadUnitaria=rs2.getFloat("cantidad_unitaria");
                costoAlmacen=rs2.getDouble("costo_almacen");
                costoActualizado=rs2.getString("costo_actualizado");
                costoActualizadoFinal=rs2.getString("costo_actualizado_final");
                nroIngresoventas=rs2.getString("nro_ingresoventas");
                codAlmacenVenta=rs2.getString("cod_almacen_venta");
                codTipoingresoventas=rs2.getString("cod_tipoingresoventas");
                nombreTipoingresoventas=rs2.getString("nombre_tipoingresoventas");
                codLoteProduccionIngreso=rs2.getString("COD_LOTE_PRODUCCION");
                obsIngresoventas=(rs2.getString("obs_ingresoventas")==null)?"":rs2.getString("obs_ingresoventas");
                obsIngresoventas=" º "+codLoteProduccionIngreso+" º "+obsIngresoventas;
                //cantidad=cantidad+cantidadUnitaria;
                //proceso para calcular el ufv actual
                sql="";
                sql+="SELECT top 1 cambio,fecha FROM tipocambios_moneda ";
                sql+="where cod_moneda=4 and fecha<='"+fechaIngresoAlmacen+"' order by fecha desc";
                st1 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                rs1 = st1.executeQuery(sql);
                valorUfv1="0";
                while (rs1.next()){
                    valorUfv1=rs1.getString("cambio");
                }
                //**********
                sql="";
                sql+=" insert into kardex_item_movimiento(cod_reporte,cod_persona,cod_almacen,";
                sql+=" tipo,codigo,numero,fecha,cod_material,";
                sql+=" cantidad_ingreso,cantidad_ingreso_cajas,cantidad_salida,cantidad_salida_cajas,tipo_ingreso_salida,";
                sql+=" obs_ingreso_salida,saldo,saldo_cajas,costo_unitario,debe,haber,saldo_dinero,tipo_cambio,costo_promedio,valor_ufv)";
                sql+=" values("+codReporte+","+codigoPersonal;
                sql+=","+codAlmacenVenta;
                sql+=",'"+tipo+"',"+codIngresoventas;
                sql+=","+nroIngresoventas;
                sql+=",'"+fechaIngresoventas+"'";
                sql+=","+codPresentacion;
                sql+=","+cantidadUnitaria;
                sql+=","+cantidad;
                sql+=",0,0,'"+nombreTipoingresoventas+"'";
                sql+=",'"+obsIngresoventas+"'";
                sql+=","+saldo+",0,0";
                sql+=",0";
                sql+=",0,0,0,0,0)";
                //System.out.println("sql:..................."+sql);
                st1 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                rsConsulta = st1.executeUpdate(sql);
                codReporte=codReporte+1;
            }
            //**********
            ///Fin de Proceso para introducir los ingresos
            //proceso para introducir las salidas
            tipo="Salida";
            sql2="";
            sql2+=" SELECT  sa.fecha_salidaventa,sad.cod_salidaventas,sad.cod_presentacion, sad.cantidad_total, ";
            sql2+=" sad.cantidad_unitariatotal,sad.costo_almacen,sad.costo_actualizado,";
            sql2+=" sad.costo_actualizado_final,sa.nro_salidaventa,";
            sql2+=" sa.cod_almacen_venta,sa.cod_tiposalidaventas,tsv.nombre_tiposalidaventas,";
            sql2+=" sa.obs_salidaventa,cod_almacen_ventadestino,(select nombre_almacen_venta from almacenes_ventas al where al.cod_almacen_venta=sa.cod_almacen_ventadestino ) as nombrealmacen, ";
            sql2+=" (select nombre_cliente from clientes c where c.cod_cliente=sa.cod_cliente and c.cod_area_empresa="+codAreaEmpresa+") as nombre_cliente ";
            sql2+=" ,(select tdv.ABREV_TIPODOC_VENTA from tipo_documentos_ventas tdv where tdv.cod_tipodoc_venta=sa.COD_TIPODOC_VENTA) as ABREV_TIPODOC_VENTA,sa.nro_factura,sad.COD_LOTE_PRODUCCION";
            sql2+=" FROM salidas_detalleventas sad,";
            sql2+=" salidas_ventas sa,tipos_salidaventas tsv";
            sql2+=" where sad.cod_salidaventas=sa.cod_salidaventa and sa.COD_AREA_EMPRESA=sad.COD_AREA_EMPRESA and sa.COD_AREA_EMPRESA="+codAreaEmpresa;
            sql2+=" and sa.cod_estado_salidaventa<>2";
            sql2+=" and sa.cod_tiposalidaventas=tsv.cod_tiposalidaventas";
            sql2+=" and sad.cod_presentacion="+codPresentacion;
            sql2+=" and sa.cod_almacen_venta="+codAlmacenVenta;
            sql2+=" and sa.fecha_salidaventa>='"+fechaInicio+"'";
            sql2+=" and sa.fecha_salidaventa<='"+fechaFinal+"' order by sa.cod_salidaventa";
            System.out.println("sql:..................."+sql2);
            st2 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            rs2 = st2.executeQuery(sql2);
            String cod_almacen_ventadestino="";
            String nombrealmacen="";
            String nombreCliente="";
            String ABREV_TIPODOC_VENTA="";
            String nro_factura="";
            String COD_LOTE_PRODUCCION="";
            while (rs2.next()){
                fechaInicioDate=rs2.getDate("fecha_salidaventa");
                horaIngresoventas=rs2.getTime("fecha_salidaventa").toString();
                System.out.println("fecha de salidas de almacen:..................."+fechaInicioDate+ "hora"+horaIngresoventas);
                fechaIngresoAlmacen=f.format(fechaInicioDate);
                fechaIngresoAlmacen=fechaIngresoAlmacen+" "+horaIngresoventas;
                fechaIngresoventas=fechaIngresoAlmacen;
                codIngresoventas=rs2.getString("cod_salidaventas");
                codPresentacion=rs2.getString("cod_presentacion");
                cantidad=rs2.getFloat("cantidad_total");
                cantidadUnitaria=rs2.getFloat("cantidad_unitariatotal");
                costoAlmacen=rs2.getDouble("costo_almacen");
                costoActualizado=rs2.getString("costo_actualizado");
                costoActualizadoFinal=rs2.getString("costo_actualizado_final");
                nroIngresoventas=rs2.getString("nro_salidaventa");
                codAlmacenVenta=rs2.getString("cod_almacen_venta");
                codTipoingresoventas=rs2.getString("cod_tiposalidaventas");
                nombreTipoingresoventas=rs2.getString("nombre_tiposalidaventas");
                obsIngresoventas=rs2.getString("obs_salidaventa");
                cod_almacen_ventadestino=rs2.getString("cod_almacen_ventadestino");
                nombrealmacen=rs2.getString("nombrealmacen");
                nombreCliente=(rs2.getString("nombre_cliente")==null)?"":rs2.getString("nombre_cliente");
                ABREV_TIPODOC_VENTA=(rs2.getString("ABREV_TIPODOC_VENTA")==null)?"":rs2.getString("ABREV_TIPODOC_VENTA");
                nro_factura=(rs2.getString("nro_factura")==null)?"":rs2.getString("nro_factura");
                COD_LOTE_PRODUCCION=(rs2.getString("COD_LOTE_PRODUCCION")==null)?"":rs2.getString("COD_LOTE_PRODUCCION");
                
                
                
                Statement stAl= con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet rsAl=stAl.executeQuery("select nombre_almacen_venta from  almacenes_ventas where cod_almacen_venta="+cod_almacen_ventadestino);
                String alma="";
                if(rsAl.next()){
                    alma=rsAl.getString(1);
                }
                nombreCliente=nombreCliente.equals("")?alma:nombreCliente;
                nombreCliente=ABREV_TIPODOC_VENTA+" - "+nro_factura+" º "+COD_LOTE_PRODUCCION+" º "+nombreCliente;
                //cantidad=cantidad+cantidadUnitaria;
                //proceso para calcular el ufv actual
                sql="";
                sql+="SELECT top 1 cambio,fecha FROM tipocambios_moneda ";
                sql+="where cod_moneda=4 and fecha<='"+fechaIngresoAlmacen+"' order by fecha desc";
                st1 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                rs1 = st1.executeQuery(sql);
                valorUfv1="0";
                while (rs1.next()){
                    valorUfv1=rs1.getString("cambio");
                }
                //**********
                sql="";
                sql+=" insert into kardex_item_movimiento(cod_reporte,cod_persona,cod_almacen,";
                sql+=" tipo,codigo,numero,fecha,cod_material,";
                sql+=" cantidad_ingreso,cantidad_ingreso_cajas,cantidad_salida,cantidad_salida_cajas,tipo_ingreso_salida,";
                sql+=" obs_ingreso_salida,saldo,saldo_cajas,costo_unitario,debe,haber,saldo_dinero,tipo_cambio,costo_promedio,valor_ufv,DESTINO_INGRESO_SALIDA)";
                sql+=" values("+codReporte+","+codigoPersonal;
                sql+=","+codAlmacenVenta;
                sql+=",'"+tipo+"',"+codIngresoventas;
                sql+=","+nroIngresoventas;
                sql+=",'"+fechaIngresoventas+"'";
                sql+=","+codPresentacion;
                sql+=",0,0,"+cantidadUnitaria;
                sql+=","+cantidad;
                sql+=",'"+nombreTipoingresoventas+"'";
                sql+=",'"+nombreCliente+"'";
                sql+=","+saldo+",0,0";
                sql+=",0,0";
                sql+=",0,0,0,0,'"+nombrealmacen+"')";
                //System.out.println("sql:..................."+sql);
                st1 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                rsConsulta = st1.executeUpdate(sql);
                codReporte=codReporte+1;
            }
            //**********
            sql2="";
            sql2+=" select fecha,valor_ufv,costo_unitario,cod_almacen,cod_material,";
            sql2+=" cantidad_ingreso,cantidad_ingreso_cajas,cantidad_salida,cantidad_salida_cajas,debe,haber,cod_reporte,cod_persona, tipo,codigo,numero,unidad_medida,";
            sql2+=" tipo_ingreso_salida,";
            sql2+=" obs_ingreso_salida, destino_ingreso_salida,saldo";
            sql2+=" from  kardex_item_movimiento";
            sql2+=" where cod_persona="+codigoPersonal;
            sql2+=" order by fecha,tipo ";
            System.out.println("sql  kardex_item_movimiento:..................."+sql2);
            st2 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            rs2 = st2.executeQuery(sql2);
            saldo=cantidadRestanteAnterior;
            saldoCajas=cantidadRestanteAnteriorCajas;
            System.out.println("salodo inicial:..................."+saldo);
            saldoDinero=cantidadRestanteAnteriorDineroActualizado;
            costoUnitario="0";
            while (rs2.next()){
                fechaInicioDate=rs2.getDate("fecha");
                ufv=rs2.getFloat("valor_ufv");
                //costoUnitario="0";
                //costoUnitario=rs2.getString("costo_unitario");
                costoUnitario_kardex=rs2.getString("costo_unitario");;
                codAlmacenVenta=rs2.getString("cod_almacen");
                codPresentacion=rs2.getString("cod_material");
                cantidadIngreso=rs2.getFloat("cantidad_ingreso");
                cantidadIngresoCajas=rs2.getFloat("cantidad_ingreso_cajas");
                cantidadSalida=rs2.getFloat("cantidad_salida");
                cantidadSalidaCajas=rs2.getFloat("cantidad_salida_cajas");
                debe=rs2.getFloat("debe");
                haber=rs2.getFloat("haber");
                codReporte2=rs2.getInt("cod_reporte");
                codTipoingresoventas=rs2.getString("tipo_ingreso_salida");
                fecha_2=f.format(fechaInicioDate);
                cantidadRestanteAnteriorDineroActualizado=saldoDinero;
                diferenciaAjuste="0";
                if(!fecha_1.equals(fecha_2)){
                    System.out.println("fechaa111 <>     "+fecha_1+"fecha 22    "+fecha_2);
                    codReporte=codReporte+1;
                    //*saca el valor de UFV
                    sql="";
                    sql+=" SELECT top 1 cambio,fecha FROM tipocambios_moneda ";
                    sql+=" where cod_moneda=4 and fecha<='"+fecha_1+"' order by fecha desc";
                    //System.out.println("sql:..................."+sql);
                    st1 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    rs1 = st1.executeQuery(sql);
                    valorUfv1="0";
                    while (rs1.next()){
                        valorUfv1=rs1.getString("cambio");
                    }
                    System.out.println("valorUfv1:"+valorUfv1); 
                    if(valorUfv1.equals("0") ){valorUfv1="0.0";}
                    if(valorUfv1.equals("0.0") ){ufvPromedio=0;} else {ufvPromedio=ufv /Float.parseFloat(valorUfv1);
                   
                
                    saldoDinero=String.valueOf(Float.parseFloat(saldoDinero)*ufvPromedio);
                    diferenciaAjuste=String.valueOf(Float.parseFloat(cantidadRestanteAnteriorDineroActualizado)*(ufvPromedio-1));
                    totalAct=totalAct+Float.parseFloat(diferenciaAjuste);
                    if(Float.parseFloat(saldo)>0){
                        costoUnitario=String.valueOf(Float.parseFloat(saldoDinero)/(Float.parseFloat(saldo)+Float.parseFloat(saldoCajas)*cantidad_presentacion));}
                    }
                    //********
                    
                    
                    
                    fecha_1=fecha_2;
                    tipo="Act.";
                    sql="";
                    sql+=" insert into kardex_item_movimiento(cod_reporte,cod_persona,cod_almacen,";
                    sql+=" tipo,codigo,fecha,cod_material,";
                    sql+=" cantidad_ingreso,cantidad_salida,cantidad_ingreso_cajas,cantidad_salida_cajas,";
                    sql+=" saldo,saldo_cajas,costo_unitario,debe,haber,saldo_dinero,valor_ufv,diferencia_actualizado)";
                    sql+=" values("+codReporte+","+codigoPersonal;
                    sql+=","+codAlmacenVenta;
                    sql+=",'"+tipo+"',0";
                    sql+=",'"+fecha_2+"'";
                    sql+=","+codPresentacion;
                    sql+=",0,0,0,0";
                    sql+=","+saldo;
                    sql+=","+saldoCajas;
                    sql+=",0,0,0";
                    sql+=",0";
                    sql+=",0";
                    sql+=",0)";
                    System.out.println("sql..................."+sql);
                    st1 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    rsConsulta = st1.executeUpdate(sql);
                    //*******************************////////////////////
                }
                diferenciaAjuste="0";
                if ((cantidadIngreso==0)&&(cantidadIngresoCajas==0)){
                    saldo=String.valueOf(Float.parseFloat(saldo)-cantidadSalida);
                    saldoCajas=String.valueOf(Float.parseFloat(saldoCajas)-cantidadSalidaCajas);
                    while(Float.parseFloat(saldo)<0){
                        saldo=String.valueOf(Float.parseFloat(saldo)+cantidad_presentacion);
                        saldoCajas=String.valueOf(Float.parseFloat(saldoCajas)-1);
                    }
                    totalSalida=totalSalida+cantidadSalida;
                    totalSalidaCajas=totalSalidaCajas+cantidadSalidaCajas;
                    System.out.println("salodo inicial salida:..................."+saldo+"   "+cantidadSalida);
                } else{

                    saldo=String.valueOf(Float.parseFloat(saldo)+cantidadIngreso);
                    saldoCajas=String.valueOf(Float.parseFloat(saldoCajas)+cantidadIngresoCajas);
                    totalEntrada=totalEntrada+cantidadIngreso;
                    totalEntradaCajas=totalEntradaCajas+cantidadIngresoCajas;
                    System.out.println("salodo inicial ingreso:..................."+saldo+"   "+cantidadIngreso);
                }
                if (debe==0){
                    costoIngreso="0";
                    haber=Float.parseFloat(costoUnitario)*(cantidadSalidaCajas*cantidad_presentacion+cantidadSalida);
                    debe=0;
                    saldoDinero=String.valueOf(Float.parseFloat(saldoDinero)-haber);
                    totalSalidaDinero=totalSalidaDinero+haber;
                }else{
                    if(codTipoingresoventas=="3"){debe=Float.parseFloat(costoUnitario)*(cantidadIngresoCajas*cantidad_presentacion+cantidadIngreso);} else{
                        costoIngreso=costoUnitario_kardex;
                        debe=Float.parseFloat(costoUnitario_kardex)*(cantidadIngresoCajas*cantidad_presentacion+cantidadIngreso);
                    }
                    haber=0;
                    saldoDinero=String.valueOf(Float.parseFloat(saldoDinero)+debe);
                    totalEntradaDinero=totalEntradaDinero+debe;
                }
                sql="";
                sql+=" update  kardex_item_movimiento  set";
                sql+=" saldo="+saldo;
                sql+=" ,saldo_cajas="+saldoCajas;
                sql+=" , haber=0";
                if(costoIngreso!="0"){
                    sql+=" , costo_ingreso=0";}
                sql+=" , costo_unitario=0";
                sql+=" , debe=0";
                sql+=" , diferencia_actualizado=0";
                sql+="  ,saldo_dinero=0";
                sql+=" where cod_persona="+codigoPersonal;
                sql+=" and cod_reporte="+codReporte2;
                System.out.println("sqleeee:..................."+sql);
                st1 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
				                rsConsulta = st1.executeUpdate(sql);
                System.out.println("ejecutar:..................."+rsConsulta);
                
            }
            //****realiza la ultinma actualizacion
            fecha_2=vectorFechaFinal[1]+"/"+vectorFechaFinal[0]+"/"+vectorFechaFinal[2];
            cantidadRestanteAnteriorDineroActualizado=saldoDinero;
            diferenciaAjuste="0";
            
            if(!fecha_1.equals(fecha_2)){
                System.out.println("ultima actualizacion fechaa111 <>     "+fecha_1+"fecha 22    "+fecha_2);
                sql="";
                sql+=" SELECT top 1 cambio,fecha FROM tipocambios_moneda ";
                sql+=" where cod_moneda=4 and fecha<='"+fecha_2+"' order by fecha desc";
                //System.out.println("sql:..................."+sql);
                st1 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                rs1 = st1.executeQuery(sql);
                valorUfv1="0";
                while (rs1.next()){
                    valorUfv1=rs1.getString("cambio");
                }
                if(codReporte==1){
                    fecha_1=vectorFechaInicio[1]+"/"+vectorFechaInicio[0]+"/"+vectorFechaInicio[2];
                    fecha_1=fecha_1+" 00:00:00";
                    
                    sql="";
                    sql+=" SELECT top 1 cambio,fecha FROM tipocambios_moneda ";
                    sql+=" where cod_moneda=4 and fecha<'"+fecha_1+"' order by fecha desc";
                    //System.out.println("sql:..................."+sql);
                    st1 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    rs1 = st1.executeQuery(sql);
                    valorUfv11="0";
                    while (rs1.next()){
                        valorUfv11=rs1.getString("cambio");
                    }
                    if(Float.parseFloat(valorUfv11)>0){
                        ufvPromedio= Float.parseFloat(valorUfv1)/Float.parseFloat(valorUfv11);
                    }else {ufvPromedio=0;}
                    saldoDinero=cantidadRestanteAnteriorKardexmovimientoGlobalDinero;
                }else{
                    if(ufv>0){
                        ufvPromedio= Float.parseFloat(valorUfv1)/ufv;
                    }else{ufvPromedio=0;}
                    
                }
                
                codReporte=codReporte+1;
                saldoDinero=String.valueOf(Float.parseFloat(saldoDinero)*ufvPromedio);
                diferenciaAjuste=String.valueOf(Float.parseFloat(cantidadRestanteAnteriorDineroActualizado)*(ufvPromedio-1));
                totalAct=totalAct+Float.parseFloat(diferenciaAjuste);
                if(Float.parseFloat(saldo)>0){
                    //costoUnitario=String.valueOf(Float.parseFloat(saldoDinero)/Float.parseFloat(saldo));
                    costoUnitario=String.valueOf(Float.parseFloat(saldoDinero)/(Float.parseFloat(saldo)+Float.parseFloat(saldoCajas)*cantidad_presentacion));
                } else{
                    costoUnitario="0";
                    if(costoUnitario_kardex!=""){costoUnitario=costoUnitario_kardex;}
                }
                System.out.println("saldoDinero..................."+saldoDinero);
                System.out.println("saldo..................."+saldo);
                System.out.println("costoUnitario..................."+costoUnitario);
                //********
                fecha_2=fecha_2+" 23:59:59";
                tipo="Act.";
                sql="";
                sql+=" insert into kardex_item_movimiento(cod_reporte,cod_persona,cod_almacen,";
                sql+=" tipo,codigo,fecha,cod_material,";
                sql+=" cantidad_ingreso,cantidad_salida,cantidad_ingreso_cajas,cantidad_salida_cajas,";
                sql+=" saldo,saldo_cajas,costo_unitario,debe,haber,saldo_dinero,valor_ufv,diferencia_actualizado)";
                sql+=" values("+codReporte+","+codigoPersonal;
                sql+=","+codAlmacenVenta;
                sql+=",'"+tipo+"',0";
                sql+=",'"+fecha_2+"'";
                sql+=","+codPresentacion;
                sql+=",0,0,0,0";
                sql+=","+saldo;
                sql+=","+saldoCajas;
                sql+=",0,0,0";
                sql+=",0";
                sql+=",0";
                sql+=",0)";
                System.out.println("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX:..................."+sql);
                st1 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
	                rsConsulta = st1.executeUpdate(sql);
                
                // fiin realiza la ultima actualizacion
            }
            fecha11=vectorFechaInicio[1]+"/"+vectorFechaInicio[0]+"/"+vectorFechaInicio[2];
            fecha11=fecha11+" 00:00:00";
            
            fecha22=vectorFechaFinal[1]+"/"+vectorFechaFinal[0]+"/"+vectorFechaFinal[2];
            fecha22=fecha22+" 23:59:59";
            
            
            con.close();
            %>                     
            
            <div align="center">
                
                <table width="100%">
                    <tr>
                        <td colspan="3" align="center" >
                            <h4>Kardex de Movimiento General</h4>
                        </td>
                    </tr>
                    
                    <tr>
                        <td align="left" width="20%"><img src="../../img/logo_cofar.png"></td>
                        <td align="left" class="outputText2" width="50%" >
                            <%
                            con=Util.openConnection(con);
                            codPresentacion=(codPresentacion==null)?"0":codPresentacion;
                             if(!codPresentacion.equals("0")){
                                String nombrePresentacion="";
                                try{
                                    
                                    String sql_aux2=" select nombre_producto_presentacion from presentaciones_producto where cod_presentacion='"+codPresentacion+"'";
                                    Statement st_aux2 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                    ResultSet rs_aux2 = st_aux2.executeQuery(sql_aux2);
                                    while (rs_aux2.next()){
                                        nombrePresentacion=rs_aux2.getString("nombre_producto_presentacion");
                                    }
                                } catch(Exception e) {
                                    e.printStackTrace();
                                } 
                            %>                            
                            <b>Presentación&nbsp;::&nbsp;</b><%=nombrePresentacion%><br>
                            <% } %>                            
                            <b>Existencias en Cajas&nbsp;::&nbsp;</b><%=cantidadRestanteAnteriorKardexmovimientoCajasGlobal%><br>
                            <b>Existencias en Unidades&nbsp;::&nbsp;</b><%=cantidadRestanteAnteriorKardexmovimientoGlobal%>
                        </td>
                        <td width="30%">                
                            <table border="0" class="outputText2" width="100%" >
                                <tr>
                                    <td colspan="2" align="right"><b>Fecha Inicio&nbsp;::&nbsp;</b><%=fechaInicio%><br><b>Fecha &nbsp;Final&nbsp;::&nbsp;</b><%=fechaFinalF%></td>
                                </tr>
                                <tr>
                                    <%if(!codAlmacenVenta.equals("0")){
                                    String nombreAlmacenVenta="";
                                    try{                                    
                                    
                                    String sql_aux1=" select nombre_almacen_venta from almacenes_ventas where cod_almacen_venta='"+codAlmacenVenta+"'";
                                    Statement st_aux1 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                    ResultSet rs_aux1 = st_aux1.executeQuery(sql_aux1);
                                    while (rs_aux1.next()){ 
                                    nombreAlmacenVenta=rs_aux1.getString("nombre_almacen_venta");
                                    }            
                                    } catch(Exception e) {
                                    e.printStackTrace();
                                    } 
                                    %>                                        
                                    <td colspan="2" align="right"><h5><%=nombreAlmacenVenta%></h5></td>
                                    <% } %>                                     
                                </tr>
                            </table>    
                        </td>                        
                    </tr>
                    <tr>
                        <td colspan="3">
                            <table class="tablaFiltroReporte"  width="100%">
                                <tr  class="tituloCampo"> 
                                    <td class="bordeNegroTdMod"><b>Fecha</b></td>
                                    <td class="bordeNegroTdMod"><b>Tipo</b></td>
                                    <td class="bordeNegroTdMod"><b>Nº Ing./Sal.</b></td>
                                    <td class="bordeNegroTdMod"><b>Nº Documento</b></td>
                                    <td class="bordeNegroTdMod"><b>Motivo</b></td>
                                    <td class="bordeNegroTdMod"><b>Observaciones</b></td>
                                    <td class="bordeNegroTdMod"><b>Entrada Cajas</b></td> 
                                    <td class="bordeNegroTdMod"><b>Entrada Unidades</b></td> 
                                    <td class="bordeNegroTdMod"><b>Salida Cajas</b></td>    
                                    <td class="bordeNegroTdMod"><b>Salida Unidades</b></td>    
                                    <td class="bordeNegroTdMod"><b>Saldo Cajas</b></td> 
                                    <td class="bordeNegroTdMod"><b>Saldo Unidades</b></td> 
                                    
                                </tr> 
                                <%  
                                
                                try{
                                    sql=" select fecha, tipo, numero, ";
                                    sql+=" tipo_ingreso_salida,cantidad_ingreso,cantidad_ingreso_cajas,cantidad_salida,cantidad_salida_cajas,";
                                    sql+=" saldo,saldo_cajas,costo_ingreso,costo_unitario,debe,haber, ";
                                    sql+=" saldo_dinero,diferencia_actualizado,valor_ufv,DESTINO_INGRESO_SALIDA, obs_ingreso_salida";
                                    sql+=" from kardex_item_movimiento ";
                                    sql+=" where cod_persona="+codigoPersonal;
                                    sql+=" order by  fecha, tipo, numero";
                                    System.out.println("xxxxxxxxxxxxxxxxxxxxxx:con:::::::::::::"+sql);
                                    st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                    rs = st.executeQuery(sql);
                                    int sw=0;
                                    String DESTINO_INGRESO_SALIDA="";
                                    String obsIngresoSalida="";
                                    while (rs.next()){
                                        
                                        fechaIngresoventas=rs.getString("fecha");
                                        String[] vectorFechaAux = fechaIngresoventas.split(" ");
                                        vectorFechaAux=vectorFechaAux[0].split("-");
                                        fechaIngresoventas=vectorFechaAux[2]+"/"+vectorFechaAux[1]+"/"+vectorFechaAux[0];
                                        
                                        tipo=rs.getString("tipo");
                                        nroIngresoventas =rs.getString("numero");
                                        nombreTipoingresoventas=rs.getString("tipo_ingreso_salida");
                                        cantidadIngreso=rs.getFloat("cantidad_ingreso");
                                        cantidadIngresoCajas=rs.getFloat("cantidad_ingreso_cajas");
                                        //cantidadIngreso=(cantidadIngreso==null)?"0":cantidadIngreso;
                                        cantidadSalida=rs.getFloat("cantidad_salida");
                                        cantidadSalidaCajas=rs.getFloat("cantidad_salida_cajas");
                                        //cantidadSalida=(cantidadSalida==null)?"0"cantidadSalida;
                                        saldo=rs.getString("saldo");
                                        saldoCajas=rs.getString("saldo_cajas");
                                        saldo=(saldo==null)?"0":saldo;
                                        saldoCajas=(saldoCajas==null)?"0":saldoCajas;
                                        System.out.println("xxxxxxxxxxxxxxxxxxxxxx:con:::::::::::::"+costoIngreso);
                                        costoIngreso=rs.getString("costo_ingreso");
                                        System.out.println("xxxxxxxxxxxxxxxxxxxxxx:con:::::::::::::"+costoIngreso);
                                        costoAlmacen=rs.getDouble("costo_unitario");
                                        //costoAlmacen=(costoAlmacen==null)?"0"costoAlmacen;
                                        debe=rs.getFloat("debe");
                                        //debe=(debe==null)?"0"debe;
                                        haber=rs.getFloat("haber");
                                        //haber=(haber==null)?"0"haber;
                                        saldoDinero=rs.getString("saldo_dinero");
                                        saldoDinero=(saldoDinero==null)?"0":saldoDinero;
                                        diferenciaAjuste=rs.getString("diferencia_actualizado");
                                        //diferenciaAjuste=(diferenciaAjuste==null)?"0"diferenciaAjuste;
                                        valorUfv1=rs.getString("valor_ufv");
                                        DESTINO_INGRESO_SALIDA=rs.getString("DESTINO_INGRESO_SALIDA");
                                        DESTINO_INGRESO_SALIDA=(DESTINO_INGRESO_SALIDA==null)?"":DESTINO_INGRESO_SALIDA;
                                        DESTINO_INGRESO_SALIDA=(DESTINO_INGRESO_SALIDA.equals("null")?"":DESTINO_INGRESO_SALIDA );
                                        obsIngresoSalida=(rs.getString("obs_ingreso_salida")==null)?"":rs.getString("obs_ingreso_salida");
                                        String[] obsIngresoSalidaAux=obsIngresoSalida.split("º");
                                        
                                
                                %>                           
                                
                                
                                <% if(!tipo.equals("Act.")){%>    
                                <tr>
                                    <td class="bordeNegroTdMod">&nbsp;<%=fechaIngresoventas%></td>
                                    <td class="bordeNegroTdMod">&nbsp;<%=tipo%></td>
                                    <% if(nroIngresoventas==null){%>
                                    <td class="bordeNegroTdMod">&nbsp;</td>                    
                                    <%}else{%>
                                    <td class="bordeNegroTdMod">&nbsp;<%=nroIngresoventas%></td>                    
                                    <%}%>
                                    <%--td class="bordeNegroTdMod">&nbsp;<%=obsIngresoSalidaAux[0]%></td--%>
                                    <td class="bordeNegroTdMod">&nbsp;<%=obsIngresoSalidaAux[0]%></td>
                                    <% if(nombreTipoingresoventas==null){%>
                                    <td class="bordeNegroTdMod">&nbsp;</td>                    
                                    <%}else{%>
                                    <td class="bordeNegroTdMod">&nbsp;<%=nombreTipoingresoventas%></td>                    
                                    <%}%>                                                                        
                                    <td class="bordeNegroTdMod">&nbsp;<%=obsIngresoSalidaAux[2]%></td>
                                    <% if(cantidadIngresoCajas==0){%>
                                    <td class="bordeNegroTdMod" align="right">0.00</td>                    
                                    <%}else{%>
                                    <td class="bordeNegroTdMod" align="right">&nbsp;<%=form1.format((double)cantidadIngresoCajas)%></td>                    
                                    <%}%>
                                    <% if(cantidadIngreso==0){%>
                                    <td class="bordeNegroTdMod" align="right">0.00</td>                    
                                    <%}else{%>
                                    <td class="bordeNegroTdMod" align="right">&nbsp;<%=form1.format((double)cantidadIngreso)%></td>                    
                                    <%}%>        
                                    <% if(cantidadSalidaCajas==0){%>
                                    <td class="bordeNegroTdMod" align="right">0.00</td>                    
                                    <%}else{%>
                                    <td class="bordeNegroTdMod" align="right">&nbsp;<%=form1.format((double)cantidadSalidaCajas)%></td>                    
                                    <%}%>
                                    <% if(cantidadSalida==0){%>
                                    <td class="bordeNegroTdMod" align="right">0.00</td>                    
                                    <%}else{%>
                                    <td class="bordeNegroTdMod" align="right">&nbsp;<%=form1.format((double)cantidadSalida)%></td>                    
                                    <%}%>
                                    <% if(saldoCajas=="0"){%>
                                    <td class="bordeNegroTdMod" align="right">0.00</td>                    
                                    <%}else{%>
                                    <td class="bordeNegroTdMod" align="right">&nbsp;<%=form1.format(Double.parseDouble(saldoCajas))%></td>                    
                                    <%}%>
                                    <% if(saldo=="0"){%>
                                    <td class="bordeNegroTdMod" align="right">0.00</td>                    
                                    <%}else{%>
                                    <td class="bordeNegroTdMod" align="right">&nbsp;<%=form1.format(Double.parseDouble(saldo))%></td>                    
                                    <%}%>
                                </tr>        
                                <%                          
                                }  
                                %> 
                                <%                          
                                    }  
                                %>   
                                
                                <%                //con.close();
                                } catch(Exception e) {
                                    e.printStackTrace();
                                } 
                                %>
                                <tr class="tituloCampo">
                                    <td class="bordeNegroTdMod">&nbsp;</td>
                                    <td class="bordeNegroTdMod">&nbsp;</td>
                                    <td class="bordeNegroTdMod">&nbsp;</td>      
                                    <td class="bordeNegroTdMod">&nbsp;</td>      
                                    <td class="bordeNegroTdMod">&nbsp;</td>      
                                    <td class="bordeNegroTdMod" align="right"><b>TOTALES&nbsp;&nbsp;</b></td>
                                    <% if(totalEntradaCajas==0){%>
                                    <td class="bordeNegroTdMod" align="right"><b>0.00</b></td>                    
                                    <%}else{%>
                                    <td class="bordeNegroTdMod" align="right">&nbsp;<b><%=form1.format((double)totalEntradaCajas)%></b></td>                    
                                    <%}%>
                                    <% if(totalEntrada==0){%>
                                    <td class="bordeNegroTdMod" align="right"><b>0.00</b></td>                    
                                    <%}else{%>
                                    <td class="bordeNegroTdMod" align="right">&nbsp;<b><%=form1.format((double)totalEntrada)%></b></td>                    
                                    <%}%>
                                    <% if(totalSalidaCajas==0){%>
                                    <td class="bordeNegroTdMod" align="right"><b>0.00</b></td>                    
                                    <%}else{%>
                                    <td class="bordeNegroTdMod" align="right">&nbsp;<b><%=form1.format((double)totalSalidaCajas)%></b></td>                    
                                    <%}%>
                                    <% if(totalSalida==0){%>
                                    <td class="bordeNegroTdMod" align="right"><b>0.00</b></td>                    
                                    <%}else{%>
                                    <td class="bordeNegroTdMod" align="right">&nbsp;<b><%=form1.format((double)totalSalida)%></b></td>                    
                                    <%}%>
                                    <% if(saldoCajas=="0"){%>
                                    <td class="bordeNegroTdMod" align="right"><b>0.00</b></td>                    
                                    <%}else{%>
                                    <td class="bordeNegroTdMod" align="right">&nbsp;<b><%=form1.format(Double.parseDouble(saldoCajas))%></b></td>                    
                                    <%}%>
                                    <% if(saldo=="0"){%>
                                    <td class="bordeNegroTdMod" align="right"><b>0.00</b></td>                    
                                    <%}else{%>
                                    <td class="bordeNegroTdMod" align="right">&nbsp;<b><%=form1.format(Double.parseDouble(saldo))%></b></td>                    
                                    <%}%>      
                                </tr>
                                
                            </table>
                        </td>
                    </tr>
                </table>
            </div>
            
            
        </form>
        <script type="text/javascript" language="JavaScript"  src="../../css/dlcalendar.js"></script>
    </body>
</html>