/*
 * funcionesReportes.java
 *
 * Created on 22 de mayo de 2012, 09:26 AM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.cofar.util;
import com.cofar.bean.LineaMKT;
import java.lang.Exception;
import java.sql.*;
import java.sql.SQLException;
import org.joda.time.*;


/**
 *
 * @author cofar
 */
public class funcionesReportes {
    
    
    /** Creates a new instance of funcionesReportes */
    public funcionesReportes(int a) {
        /*Connection con=null;
        try {
            con=Util.openConnection(con);
            Statement st=con.createStatement();
            st.executeUpdate("set dateformat ymd");
        } catch (SQLException ex) {
            ex.printStackTrace();
        }*/
    }
    
    public int existenciasPremios(Connection con, String fecha, int codigoPremio, int codAreaEmpresa, int tipoAlmacen){
        int uuDiferencia =0;
        //si tipo almacen=1 premios normal tipo=2 frv
        try {
            int codAlmacen=0;
            //con=com.cofar.util.CofarConnection.getConnectionJsp();
            Statement stFormatoFecha=con.createStatement();
            stFormatoFecha.executeUpdate("set dateformat ymd");
            String sqlAlmacen="select a.COD_ALMACEN_MATPROMOCIONAL from ALMACEN_MATPROMOCIONAL a where a.COD_AREA_EMPRESA="+codAreaEmpresa+" and a.COD_TIPOALMACEN="+tipoAlmacen+"";
            Statement stAlmacen=con.createStatement();
            ResultSet rsAlmacen=stAlmacen.executeQuery(sqlAlmacen);
            if(rsAlmacen.next()){
                codAlmacen=rsAlmacen.getInt(1);
            }
            
            String sqlIng = "select sum(idm.CANT_UNITARIA_INGRESO) as cantidadUnitaria from INGRESOS_MATPROMOCIONAL im, " +
                    " INGRESOS_DETALLEMATPROMOCIONAL idm where im.COD_INGRESO_MATPROMOCIONAL = idm.COD_INGRESO_MATPROMOCIONAL and im.COD_AREA_EMPRESA=idm.COD_AREA_EMPRESA " +
                    " and im.COD_ALMACEN_MATPROMOCIONAL in(" + codAlmacen + ") and im.COD_ESTADO_INGRESOMATPROMOCIONAL <> 2 and " +
                    " im.FECHA_INGRESO_MATPROMOCIONAL <= '" + fecha + " 23:59:59' and idm.COD_MATPROMOCIONAL = " + codigoPremio;
            System.out.println("SQLING: "+sqlIng);
            
            Statement stIng= con.createStatement();
            ResultSet rsIng = stIng.executeQuery(sqlIng);
            int uuIngresoTotal = 0;
            if (rsIng.next()) {
                uuIngresoTotal = rsIng.getInt(1);
            }
            String sqlSalida = "select sum(idm.CANTIDAD_SALIDA_MATPROMOCIONAL) as cantidadUnitaria from SALIDAS_MATPROMOCIONAL im, " +
                    " SALIDAS_DETALLEMATERIALPROMOCIONAL idm where im.COD_SALIDA_MATPROMOCIONAL = idm.COD_SALIDA_MATPROMOCIONAL and im.COD_AREA_EMPRESA=idm.COD_AREA_EMPRESA " +
                    " and im.COD_ALMACEN_MATPROMOCIONAL in(" + codAlmacen + ") and im.COD_ESTADO_SALIDAMATPROMOCIONAL not in (2,4) and " +
                    " im.FECHA_SALIDA_MATPROMOCIONAL <= '" + fecha + " 23:59:59' and idm.COD_MATPROMOCIONAL = " + codigoPremio;
            System.out.println("SQL SALIDA: "+sqlSalida);
            
            Statement stSalida = con.createStatement();
            ResultSet rsSalida= stSalida.executeQuery(sqlSalida);
            int uuSalidaTotal = 0;
            if (rsSalida.next()) {
                uuSalidaTotal = rsSalida.getInt(1);
            }
            uuDiferencia = uuIngresoTotal - uuSalidaTotal;
        }catch(Exception e){
            e.printStackTrace();
        }
        return(uuDiferencia);
    }
    
    public double existenciasProducto(Connection con, String fecha, String codProducto, int codAlmacen){
        double saldoProducto=0;
        try{
            String sqlIng="select sum(id.cantidad+(id.cantidad_unitaria/pp.cantidad_presentacion)) " +
                    " from ingresos_detalleventas id,ingresos_ventas iv,PRESENTACIONES_PRODUCTO pp " +
                    " where id.cod_ingresoventas=iv.cod_ingresoventas and iv.COD_AREA_EMPRESA=id.COD_AREA_EMPRESA "+
                    " and id.cod_presentacion="+codProducto+" " +
                    " and iv.fecha_ingresoventas<='"+fecha+ " 23:59:59'" +
                    " and pp.cod_presentacion=id.cod_presentacion and iv.cod_estado_ingresoventas<>2 " +
                    " and iv.cod_almacen_venta="+codAlmacen;
            
            System.out.println("SQL INGRESOS:    "+sqlIng);
            Statement stIng=con.createStatement();
            ResultSet rsIng=stIng.executeQuery(sqlIng);
            double cantIngresos=0;
            while (rsIng.next()){
                cantIngresos=rsIng.getDouble(1);
            }
            
            String sqlSalidas="select sum(cantidad_total+(cantidad_unitariatotal/pp.cantidad_presentacion)) " +
                    " from salidas_detalleventas sd,salidas_ventas sa,PRESENTACIONES_PRODUCTO pp  " +
                    " where sd.cod_salidaventas=sa.cod_salidaventa and sa.COD_AREA_EMPRESA=sd.COD_AREA_EMPRESA " +
                    " and sd.cod_presentacion="+codProducto+""+
                    " and sa.fecha_salidaventa<='"+fecha+ " 23:59:59' " +
                    " and pp.cod_presentacion=sd.cod_presentacion and sa.cod_estado_salidaventa<>2 " +
                    " and sa.cod_almacen_venta="+codAlmacen;
            System.out.println("SQL SALIDAS:   "+sqlSalidas);
            
            Statement stSalidas=con.createStatement();
            ResultSet rsSalidas=stSalidas.executeQuery(sqlSalidas);
            double cantSalidas=0;
            if(rsSalidas.next()){
                cantSalidas=rsSalidas.getDouble(1);
            }
            saldoProducto=cantIngresos-cantSalidas;
        }catch(Exception e){
            e.printStackTrace();
        }
        return(saldoProducto);
    }
    
    
    public double existenciasProductoUnit(Connection con, String fecha, String codProducto, int codAlmacen){
        double saldoProducto=0;
        try{
            String sqlAlm="select a.COD_AREA_EMPRESA from ALMACENES_VENTAS a where a.COD_ALMACEN_VENTA="+codAlmacen;
            Statement stAlm=con.createStatement();
            ResultSet rsAlm=stAlm.executeQuery(sqlAlm);
            String codArea="0";
            if(rsAlm.next()){
                codArea=rsAlm.getString(1);
            }
            
            
            
            String sqlIng="select sum((id.cantidad*cantidad_presentacion)+id.cantidad_unitaria) " +
                    " from ingresos_detalleventas id,ingresos_ventas iv,PRESENTACIONES_PRODUCTO pp " +
                    " where id.cod_ingresoventas=iv.cod_ingresoventas and iv.COD_AREA_EMPRESA=id.COD_AREA_EMPRESA "+
                    " and id.cod_presentacion="+codProducto+" " +
                    " and iv.fecha_ingresoventas<='"+fecha+ " 23:59:59'" +
                    " and pp.cod_presentacion=id.cod_presentacion and iv.cod_estado_ingresoventas<>2 " +
                    " and iv.cod_almacen_venta="+codAlmacen+" and iv.cod_area_empresa="+codArea+"";
            
            System.out.println("SQL INGRESOS:    "+sqlIng);
            Statement stIng=con.createStatement();
            ResultSet rsIng=stIng.executeQuery(sqlIng);
            double cantIngresos=0;
            while (rsIng.next()){
                cantIngresos=rsIng.getDouble(1);
            }
            
            String sqlSalidas="select sum((cantidad_total*pp.cantidad_presentacion)+cantidad_unitariatotal) " +
                    " from salidas_detalleventas sd,salidas_ventas sa,PRESENTACIONES_PRODUCTO pp  " +
                    " where sd.cod_salidaventas=sa.cod_salidaventa and sa.COD_AREA_EMPRESA=sd.COD_AREA_EMPRESA " +
                    " and sd.cod_presentacion="+codProducto+""+
                    " and sa.fecha_salidaventa<='"+fecha+ " 23:59:59' " +
                    " and pp.cod_presentacion=sd.cod_presentacion and sa.cod_estado_salidaventa<>2 " +
                    " and sa.cod_almacen_venta="+codAlmacen+" and sa.cod_area_empresa="+codArea+"";
            System.out.println("SQL SALIDAS:   "+sqlSalidas);
            
            Statement stSalidas=con.createStatement();
            ResultSet rsSalidas=stSalidas.executeQuery(sqlSalidas);
            double cantSalidas=0;
            if(rsSalidas.next()){
                cantSalidas=rsSalidas.getDouble(1);
            }
            saldoProducto=cantIngresos-cantSalidas;
        }catch(Exception e){
            e.printStackTrace();
        }
        return(saldoProducto);
    }
    
    public String LineasVentaMkt(Connection con, int codLineaVenta){
        String codLineaMkt="";
        try{
            String sqlAux="select cod_lineamkt from LINEAS_VENTA_MKT l where l.COD_LINEAVENTA=" + codLineaVenta;
            Statement stAux= con.createStatement();
            ResultSet rsAux = stAux.executeQuery(sqlAux);
            codLineaMkt = "0";
            while (rsAux.next()) {
                codLineaMkt = codLineaMkt + "," + rsAux.getString(1);
            }
        }catch(Exception e){
            e.printStackTrace();
        }
        return(codLineaMkt);
    }
    
    //ACT POLITICA NUEVA
    public double montoVentaCliente(Connection con, int codArea, String fechaIni, String fechaFin, int codCliente, int codLineaVenta){
        double montoVenta=0;
        //si linea venta es 0 sacamos todo
        String codLineaMkt="";
        try{
            funcionesReportes obj=new funcionesReportes(1);
            codLineaMkt=obj.LineasVentaMkt(con, codLineaVenta);
            
            String sqlConsulta = "select sum(ROUND(((sd.CANTIDAD_TOTAL*pp.cantidad_presentacion) + isnull(sd.CANTIDAD_UNITARIATOTAL,0)), 2)) as totalUnidades, " +
                    " (CASE sd.COD_OFERTA  When 0 Then isnull(sum(((isnull(sd.cantidad, 0) +(isnull(" +
                    " sd.cantidad_unitaria, 0) / pp.cantidad_presentacion)) * sd.precio_lista *((100 - sd.porcentaje_aplicadoprecio) / 100) *((100" +
                    "  - isnull(s.PORCENTAJE_DESCUENTO_PREFERENCIAL, 0)) / 100) *((100 - s.porcentaje_descuento) / 100)  * ((100-s.DESCUENTO_FIDELIDAD)/100) * " +
                    " ((100-(s.DESCUENTO_CONTADO))/100) * ((100-s.DESCUENTO_PREFERENCIAL)/100) -(isnull(PART_CHEQUE, 0) * isnull(sd.MONTO_CHEQUE, 0))    )), 0)" +
                    "   ELSE isnull(sum(((isnull(sd.cantidad, 0) +(isnull( sd.cantidad_unitaria, 0) / pp.cantidad_presentacion)) *" +
                    "  sd.precio_lista *((100 - sd.porcentaje_aplicadoprecio) / 100)  * ((100-s.DESCUENTO_FIDELIDAD)/100) * ((100-(s.DESCUENTO_CONTADO))/100) * ((100-s.DESCUENTO_PREFERENCIAL)/100) -(isnull(PART_CHEQUE, 0) " +
                    " * isnull(sd.MONTO_CHEQUE, 0))  ) ), 0)  END) as montoVenta " +
                    " from SALIDAS_VENTAS s,SALIDAS_DETALLEVENTAS sd,ALMACENES_VENTAS av,PRESENTACIONES_PRODUCTO pp,clientes cl " +
                    " where s.COD_SALIDAVENTA = sd.COD_SALIDAVENTAS and s.cod_area_empresa=sd.cod_area_empresa and s.COD_ALMACEN_VENTA = av.COD_ALMACEN_VENTA " +
                    " and pp.cod_presentacion = sd.COD_PRESENTACION and s.COD_CLIENTE = cl.cod_cliente " +
                    " and av.COD_AREA_EMPRESA in(" + codArea+ ") " +
                    " and s.FECHA_SALIDAVENTA>='" + fechaIni + " 00:00:00' and s.FECHA_SALIDAVENTA<='" + fechaFin + " 23:59:59' " +
                    " and s.cod_cliente in ("+codCliente+") ";
            if(codLineaVenta!=0){
                sqlConsulta=sqlConsulta+" and pp.COD_LINEAMKT in ("+codLineaMkt+")";
            }
            sqlConsulta=sqlConsulta+" and s.COD_ESTADO_SALIDAVENTA<>2 and s.COD_TIPOSALIDAVENTAS=3 group by sd.cod_oferta";
            //System.out.println("SQL CONSULTA: "+sqlConsulta);
            Statement stConsulta=con.createStatement();
            ResultSet rsConsulta=stConsulta.executeQuery(sqlConsulta);
            while (rsConsulta.next()) {
                montoVenta=montoVenta+rsConsulta.getDouble(2);
            }
        }catch(Exception e){
            e.printStackTrace();
        }
        return(montoVenta);
    }
    
    
    
    
    //ACT CHEQ
    public double montoVentaClienteLineaMkt(Connection con, int codArea, String fechaIni, String fechaFin, int codCliente, String codLineaMkt, String codPersonal){
        double montoVenta=0;
        //cuando personal es 0 no se toma en cuenta
        try{
            String sqlConsulta = "select sum(ROUND(((sd.CANTIDAD_TOTAL*pp.cantidad_presentacion) + isnull(sd.CANTIDAD_UNITARIATOTAL,0)), 2)) as totalUnidades, " +
                    " (CASE sd.COD_OFERTA  When 0 Then isnull(sum(((isnull(sd.cantidad, 0) +(isnull(" +
                    " sd.cantidad_unitaria, 0) / pp.cantidad_presentacion)) * sd.precio_lista *((100 - sd.porcentaje_aplicadoprecio) / 100) *((100" +
                    "  - isnull(s.PORCENTAJE_DESCUENTO_PREFERENCIAL, 0)) / 100) *((100 - s.porcentaje_descuento) / 100)  * ((100-s.DESCUENTO_FIDELIDAD)/100) * " +
                    " ((100-(s.DESCUENTO_CONTADO))/100) * ((100-s.DESCUENTO_PREFERENCIAL)/100) -(isnull(PART_CHEQUE, 0) * isnull(sd.MONTO_CHEQUE, 0))    )), 0)" +
                    "   ELSE isnull(sum(((isnull(sd.cantidad, 0) +(isnull( sd.cantidad_unitaria, 0) / pp.cantidad_presentacion)) *" +
                    "  sd.precio_lista *((100 - sd.porcentaje_aplicadoprecio) / 100)  * ((100-s.DESCUENTO_FIDELIDAD)/100) * ((100-(s.DESCUENTO_CONTADO))/100) * ((100-s.DESCUENTO_PREFERENCIAL)/100) -(isnull(PART_CHEQUE, 0) " +
                    " * isnull(sd.MONTO_CHEQUE, 0))  ) ), 0)  END) as montoVenta " +
                    " from SALIDAS_VENTAS s,SALIDAS_DETALLEVENTAS sd, PRESENTACIONES_PRODUCTO pp,clientes cl " +
                    " where s.COD_SALIDAVENTA = sd.COD_SALIDAVENTAS and s.cod_area_empresa=sd.cod_area_empresa " +
                    " and pp.cod_presentacion = sd.COD_PRESENTACION and s.COD_CLIENTE = cl.cod_cliente and s.cod_area_empresa=cl.cod_area_empresa " +
                    " and s.COD_AREA_EMPRESA in(" + codArea+ ") and cl.cod_tipocliente in (1,10,4,11) " +
                    " and s.FECHA_SALIDAVENTA>='" + fechaIni + " 00:00:00' and s.FECHA_SALIDAVENTA<='" + fechaFin + " 23:59:59' " +
                    " and s.cod_cliente in ("+codCliente+") and pp.COD_LINEAMKT in ("+codLineaMkt+") " +
                    " and s.COD_ESTADO_SALIDAVENTA<>2 and s.COD_TIPOSALIDAVENTAS=3 ";
            if(!codPersonal.equals("0")){
                sqlConsulta=sqlConsulta+"and s.cod_personal in ("+codPersonal+") ";
            }
            sqlConsulta=sqlConsulta+" group by sd.cod_oferta";
            System.out.println("SQL CONSULTA: "+sqlConsulta);
            Statement stConsulta=con.createStatement();
            ResultSet rsConsulta=stConsulta.executeQuery(sqlConsulta);
            while (rsConsulta.next()) {
                montoVenta=montoVenta+rsConsulta.getDouble(2);
            }
        }catch(Exception e){
            e.printStackTrace();
        }
        return(montoVenta);
    }
    
    
    //VENTAS DE ZONAS DE UN FUNCIONARIO
    //ACT POLITICA NUEVA
    public double montoVentaClienteFuncionario(Connection con, int codArea, String fechaIni, String fechaFin, int codFuncionario, int codLineaVenta){
        double montoVenta=0;
        String codLineaMkt="";
        try{
            funcionesReportes obj=new funcionesReportes(1);
            codLineaMkt=obj.LineasVentaMkt(con, codLineaVenta);
            
            String sqlConsulta = "select sum(ROUND(((sd.CANTIDAD_TOTAL*pp.cantidad_presentacion) + isnull(sd.CANTIDAD_UNITARIATOTAL,0)), 2)) as totalUnidades, " +
                    " (CASE sd.COD_OFERTA  When 0 Then isnull(sum(((isnull(sd.cantidad, 0) +(isnull(" +
                    " sd.cantidad_unitaria, 0) / pp.cantidad_presentacion)) * sd.precio_lista *((100 - sd.porcentaje_aplicadoprecio) / 100) *((100" +
                    "  - isnull(s.PORCENTAJE_DESCUENTO_PREFERENCIAL, 0)) / 100) *((100 - s.porcentaje_descuento) / 100)  * ((100-s.DESCUENTO_FIDELIDAD)/100) * " +
                    " ((100-(s.DESCUENTO_CONTADO))/100) * ((100-s.DESCUENTO_PREFERENCIAL)/100) -(isnull(PART_CHEQUE, 0) * isnull(sd.MONTO_CHEQUE, 0))    )), 0)" +
                    "   ELSE isnull(sum(((isnull(sd.cantidad, 0) +(isnull( sd.cantidad_unitaria, 0) / pp.cantidad_presentacion)) *" +
                    "  sd.precio_lista *((100 - sd.porcentaje_aplicadoprecio) / 100)  * ((100-s.DESCUENTO_FIDELIDAD)/100) * ((100-(s.DESCUENTO_CONTADO))/100) * ((100-s.DESCUENTO_PREFERENCIAL)/100) -(isnull(PART_CHEQUE, 0) " +
                    " * isnull(sd.MONTO_CHEQUE, 0))  ) ), 0)  END) as montoVenta " +
                    " from SALIDAS_VENTAS s,SALIDAS_DETALLEVENTAS sd, PRESENTACIONES_PRODUCTO pp,clientes cl " +
                    " where s.COD_SALIDAVENTA = sd.COD_SALIDAVENTAS and s.cod_area_empresa=sd.cod_area_empresa and s.cod_area_empresa=cl.cod_area_empresa " +
                    " and pp.cod_presentacion = sd.COD_PRESENTACION and s.COD_CLIENTE = cl.cod_cliente " +
                    " and s.COD_AREA_EMPRESA in(" + codArea+ ") and cl.cod_tipocliente in (1,10,4,11) " +
                    " and s.FECHA_SALIDAVENTA>='" + fechaIni + " 00:00:00' and s.FECHA_SALIDAVENTA<='" + fechaFin + " 23:59:59' " +
                    " and s.cod_cliente in (select c.cod_cliente from clientes c where c.cod_area_empresa="+codArea+" and c.cod_zona in " +
                    "       (select pz.cod_zona from personal_zonas pz where pz.cod_personal="+codFuncionario+")) " +
                    " and pp.COD_LINEAMKT in ("+codLineaMkt+") " +
                    " and s.COD_ESTADO_SALIDAVENTA<>2 and s.COD_TIPOSALIDAVENTAS=3 group by sd.cod_oferta";
            System.out.println("SQL CONSULTA: "+sqlConsulta);
            Statement stConsulta=con.createStatement();
            ResultSet rsConsulta=stConsulta.executeQuery(sqlConsulta);
            while (rsConsulta.next()) {
                montoVenta=montoVenta+rsConsulta.getDouble(2);
            }
        }catch(Exception e){
            e.printStackTrace();
        }
        return(montoVenta);
    }
    
    //VENTAS A LOS CLIENTES DE UN FUNCIONARIO
    //ACT CHQ
    public double montoVentaClientesAsignados(Connection con, int codArea, String fechaIni, String fechaFin, int codFuncionario){
        double montoVenta=0;
        try{
            String sqlConsulta = "select sum(ROUND(((sd.CANTIDAD_TOTAL*pp.cantidad_presentacion) + isnull(sd.CANTIDAD_UNITARIATOTAL,0)), 2)) as totalUnidades, " +
                    " (CASE sd.COD_OFERTA  When 0 Then isnull(sum(((isnull(sd.cantidad, 0) +(isnull(" +
                    " sd.cantidad_unitaria, 0) / pp.cantidad_presentacion)) * sd.precio_lista *((100 - sd.porcentaje_aplicadoprecio) / 100) *((100" +
                    "  - isnull(s.PORCENTAJE_DESCUENTO_PREFERENCIAL, 0)) / 100) *((100 - s.porcentaje_descuento) / 100)  * ((100-s.DESCUENTO_FIDELIDAD)/100) * " +
                    " ((100-(s.DESCUENTO_CONTADO))/100) * ((100-s.DESCUENTO_PREFERENCIAL)/100) -(isnull(PART_CHEQUE, 0) * isnull(sd.MONTO_CHEQUE, 0))    )), 0)" +
                    "   ELSE isnull(sum(((isnull(sd.cantidad, 0) +(isnull( sd.cantidad_unitaria, 0) / pp.cantidad_presentacion)) *" +
                    "  sd.precio_lista *((100 - sd.porcentaje_aplicadoprecio) / 100)  * ((100-s.DESCUENTO_FIDELIDAD)/100) * ((100-(s.DESCUENTO_CONTADO))/100) * ((100-s.DESCUENTO_PREFERENCIAL)/100) -(isnull(PART_CHEQUE, 0) " +
                    " * isnull(sd.MONTO_CHEQUE, 0))  ) ), 0)  END) as montoVenta " +
                    " from SALIDAS_VENTAS s,SALIDAS_DETALLEVENTAS sd, PRESENTACIONES_PRODUCTO pp,clientes cl " +
                    " where s.COD_SALIDAVENTA = sd.COD_SALIDAVENTAS and s.cod_area_empresa=sd.cod_area_empresa and s.cod_area_empresa=cl.cod_area_empresa " +
                    " and pp.cod_presentacion = sd.COD_PRESENTACION and s.COD_CLIENTE = cl.cod_cliente " +
                    " and s.COD_AREA_EMPRESA in(" + codArea+ ") and cl.cod_tipocliente in (1,10,4,11) " +
                    " and s.FECHA_SALIDAVENTA>='" + fechaIni + " 00:00:00' and s.FECHA_SALIDAVENTA<='" + fechaFin + " 23:59:59' " +
                    " and s.cod_cliente in (select c.cod_cliente from clientes c where c.cod_area_empresa="+codArea+" and c.cod_zona in " +
                    "       (select pz.cod_zona from personal_zonas pz where pz.cod_personal="+codFuncionario+")) " +
                    " and s.COD_ESTADO_SALIDAVENTA<>2 and s.COD_TIPOSALIDAVENTAS=3 and pp.cod_lineamkt not in (10) group by sd.cod_oferta";
            System.out.println("SQL CONSULTA CLIENTES ASIGNADOS: "+sqlConsulta);
            Statement stConsulta=con.createStatement();
            ResultSet rsConsulta=stConsulta.executeQuery(sqlConsulta);
            while (rsConsulta.next()) {
                montoVenta=montoVenta+rsConsulta.getDouble(2);
            }
        }catch(Exception e){
            e.printStackTrace();
        }
        return(montoVenta);
    }
    
    
    
    //VENTAS DE ZONAS DE UN FUNCIONARIO
    //ACT POLITICA NUEVA
    public double montoVentaFuncionarioClientesAsignados(Connection con, int codArea, String fechaIni, String fechaFin, int codFuncionario){
        double montoVenta=0;
        try{
            String sqlConsulta = "select sum(ROUND(((sd.CANTIDAD_TOTAL*pp.cantidad_presentacion) + isnull(sd.CANTIDAD_UNITARIATOTAL,0)), 2)) as totalUnidades, " +
                    " (CASE sd.COD_OFERTA  When 0 Then isnull(sum(((isnull(sd.cantidad, 0) +(isnull(" +
                    " sd.cantidad_unitaria, 0) / pp.cantidad_presentacion)) * sd.precio_lista *((100 - sd.porcentaje_aplicadoprecio) / 100) *((100" +
                    "  - isnull(s.PORCENTAJE_DESCUENTO_PREFERENCIAL, 0)) / 100) *((100 - s.porcentaje_descuento) / 100)  * ((100-s.DESCUENTO_FIDELIDAD)/100) * " +
                    " ((100-(s.DESCUENTO_CONTADO))/100) * ((100-s.DESCUENTO_PREFERENCIAL)/100) -(isnull(PART_CHEQUE, 0) * isnull(sd.MONTO_CHEQUE, 0))    )), 0)" +
                    "   ELSE isnull(sum(((isnull(sd.cantidad, 0) +(isnull( sd.cantidad_unitaria, 0) / pp.cantidad_presentacion)) *" +
                    "  sd.precio_lista *((100 - sd.porcentaje_aplicadoprecio) / 100)  * ((100-s.DESCUENTO_FIDELIDAD)/100) * ((100-(s.DESCUENTO_CONTADO))/100) * ((100-s.DESCUENTO_PREFERENCIAL)/100) -(isnull(PART_CHEQUE, 0) " +
                    " * isnull(sd.MONTO_CHEQUE, 0))  ) ), 0)  END) as montoVenta " +
                    " from SALIDAS_VENTAS s,SALIDAS_DETALLEVENTAS sd, PRESENTACIONES_PRODUCTO pp,clientes cl " +
                    " where s.COD_SALIDAVENTA = sd.COD_SALIDAVENTAS and s.cod_area_empresa=sd.cod_area_empresa and s.cod_area_empresa=cl.cod_area_empresa " +
                    " and pp.cod_presentacion = sd.COD_PRESENTACION and s.COD_CLIENTE = cl.cod_cliente " +
                    " and s.COD_AREA_EMPRESA in(" + codArea+ ") and cl.cod_tipocliente in (1,10,4,11) and s.cod_personal in ("+codFuncionario+")" +
                    " and s.FECHA_SALIDAVENTA>='" + fechaIni + " 00:00:00' and s.FECHA_SALIDAVENTA<='" + fechaFin + " 23:59:59' " +
                    " and s.cod_cliente in (select c.cod_cliente from clientes c where c.cod_area_empresa="+codArea+" and c.cod_zona in " +
                    "       (select pz.cod_zona from personal_zonas pz where pz.cod_personal="+codFuncionario+")) " +
                    " and s.COD_ESTADO_SALIDAVENTA<>2 and s.COD_TIPOSALIDAVENTAS=3 and pp.cod_lineamkt not in (10) group by sd.cod_oferta";
            System.out.println("SQL montoVentaFuncionarioClientesAsignados: "+sqlConsulta);
            Statement stConsulta=con.createStatement();
            ResultSet rsConsulta=stConsulta.executeQuery(sqlConsulta);
            while (rsConsulta.next()) {
                montoVenta=montoVenta+rsConsulta.getDouble(2);
            }
        }catch(Exception e){
            e.printStackTrace();
        }
        return(montoVenta);
    }
    
    //ACT POLITICA NUEVA
    public double montoVentaFuncionario(Connection con, int codArea, String fechaIni, String fechaFin, int codFuncionario, int ventaCorriente){
        double montoVenta=0;
        //si venta corriente es 1 escogemos solo lineas presupuestadas
        try{
            String sqlConsulta = "select sum(ROUND(((sd.CANTIDAD_TOTAL*pp.cantidad_presentacion) + isnull(sd.CANTIDAD_UNITARIATOTAL,0)), 2)) as totalUnidades, " +
                    " (CASE sd.COD_OFERTA  When 0 Then isnull(sum(((isnull(sd.cantidad, 0) +(isnull(" +
                    " sd.cantidad_unitaria, 0) / pp.cantidad_presentacion)) * sd.precio_lista *((100 - sd.porcentaje_aplicadoprecio) / 100) *((100" +
                    "  - isnull(s.PORCENTAJE_DESCUENTO_PREFERENCIAL, 0)) / 100) *((100 - s.porcentaje_descuento) / 100)  * ((100-s.DESCUENTO_FIDELIDAD)/100) * " +
                    " ((100-(s.DESCUENTO_CONTADO))/100) * ((100-s.DESCUENTO_PREFERENCIAL)/100) -(isnull(PART_CHEQUE, 0) * isnull(sd.MONTO_CHEQUE, 0))    )), 0)" +
                    "   ELSE isnull(sum(((isnull(sd.cantidad, 0) +(isnull( sd.cantidad_unitaria, 0) / pp.cantidad_presentacion)) *" +
                    "  sd.precio_lista *((100 - sd.porcentaje_aplicadoprecio) / 100)  * ((100-s.DESCUENTO_FIDELIDAD)/100) * ((100-(s.DESCUENTO_CONTADO))/100) * ((100-s.DESCUENTO_PREFERENCIAL)/100) -(isnull(PART_CHEQUE, 0) " +
                    " * isnull(sd.MONTO_CHEQUE, 0))  ) ), 0)  END) as montoVenta " +
                    " from SALIDAS_VENTAS s,SALIDAS_DETALLEVENTAS sd,ALMACENES_VENTAS av,PRESENTACIONES_PRODUCTO pp,clientes cl " +
                    " where s.COD_SALIDAVENTA = sd.COD_SALIDAVENTAS and s.cod_area_empresa=sd.cod_area_empresa and s.COD_ALMACEN_VENTA = av.COD_ALMACEN_VENTA " +
                    " and pp.cod_presentacion = sd.COD_PRESENTACION and s.COD_CLIENTE = cl.cod_cliente " +
                    " and av.COD_AREA_EMPRESA in(" + codArea+ ") and cl.cod_tipocliente in (1,10,4,11) " +
                    " and s.FECHA_SALIDAVENTA>='" + fechaIni + " 00:00:00' and s.FECHA_SALIDAVENTA<='" + fechaFin + " 23:59:59' " +
                    " and s.cod_cliente in (select c.cod_cliente from clientes c where c.cod_area_empresa="+codArea+") and s.cod_personal in ("+codFuncionario+") ";
            if(ventaCorriente==1){
                sqlConsulta=sqlConsulta + " and pp.cod_lineamkt not in (10) ";
            }
            sqlConsulta=sqlConsulta + " and s.COD_ESTADO_SALIDAVENTA<>2 and s.COD_TIPOSALIDAVENTAS=3 group by sd.cod_oferta";
            System.out.println("SQL CONSULTA MONTO FUNCIONARIO: "+sqlConsulta);
            Statement stConsulta=con.createStatement();
            ResultSet rsConsulta=stConsulta.executeQuery(sqlConsulta);
            while (rsConsulta.next()) {
                montoVenta=montoVenta+rsConsulta.getDouble(2);
            }
        }catch(Exception e){
            e.printStackTrace();
        }
        return(montoVenta);
    }
    
    
    //VENTAS DE UN FUNCIONARIO POR ZONAS
    //ACT POLITICA NUEVA
    public double montoVentaFuncionarioZona(Connection con, int codArea, String fechaIni, String fechaFin, String codFuncionarios, String codZonas, String tipoCliente, String lineasMkt){
        double montoVenta=0;
        try{
            String sqlConsulta = "select sum(ROUND(((sd.CANTIDAD_TOTAL*pp.cantidad_presentacion) + isnull(sd.CANTIDAD_UNITARIATOTAL,0)), 2)) as totalUnidades, " +
                    " (CASE sd.COD_OFERTA  When 0 Then isnull(sum(((isnull(sd.cantidad, 0) +(isnull(" +
                    " sd.cantidad_unitaria, 0) / pp.cantidad_presentacion)) * sd.precio_lista *((100 - sd.porcentaje_aplicadoprecio) / 100) *((100" +
                    "  - isnull(s.PORCENTAJE_DESCUENTO_PREFERENCIAL, 0)) / 100) *((100 - s.porcentaje_descuento) / 100)  * ((100-s.DESCUENTO_FIDELIDAD)/100) * " +
                    " ((100-(s.DESCUENTO_CONTADO))/100) * ((100-s.DESCUENTO_PREFERENCIAL)/100) -(isnull(PART_CHEQUE, 0) * isnull(sd.MONTO_CHEQUE, 0))    )), 0)" +
                    "   ELSE isnull(sum(((isnull(sd.cantidad, 0) +(isnull( sd.cantidad_unitaria, 0) / pp.cantidad_presentacion)) *" +
                    "  sd.precio_lista *((100 - sd.porcentaje_aplicadoprecio) / 100)  * ((100-s.DESCUENTO_FIDELIDAD)/100) * ((100-(s.DESCUENTO_CONTADO))/100) * ((100-s.DESCUENTO_PREFERENCIAL)/100) -(isnull(PART_CHEQUE, 0) " +
                    " * isnull(sd.MONTO_CHEQUE, 0))  ) ), 0)  END) as montoVenta " +
                    " from SALIDAS_VENTAS s,SALIDAS_DETALLEVENTAS sd, PRESENTACIONES_PRODUCTO pp,clientes cl " +
                    " where s.COD_SALIDAVENTA = sd.COD_SALIDAVENTAS and s.cod_area_empresa=sd.cod_area_empresa and " +
                    " pp.cod_presentacion = sd.COD_PRESENTACION and s.COD_CLIENTE = cl.cod_cliente and pp.COD_LINEAMKT in ("+lineasMkt+") " +
                    " and s.COD_AREA_EMPRESA in(" + codArea+ ") and cl.cod_tipocliente in ("+tipoCliente+") " +
                    " and s.FECHA_SALIDAVENTA>='" + fechaIni + " 00:00:00' and s.FECHA_SALIDAVENTA<='" + fechaFin + " 23:59:59' " +
                    " and s.cod_cliente in (select c.cod_cliente from clientes c where c.cod_area_empresa="+codArea+" and c.cod_zona in ("+codZonas+")) and s.cod_personal in ("+codFuncionarios+") " +
                    " and s.COD_ESTADO_SALIDAVENTA<>2 and s.COD_TIPOSALIDAVENTAS=3 group by sd.cod_oferta";
            System.out.println("SQL CONSULTA MONTO FUNCIONARIO: "+sqlConsulta);
            Statement stConsulta=con.createStatement();
            ResultSet rsConsulta=stConsulta.executeQuery(sqlConsulta);
            while (rsConsulta.next()) {
                montoVenta=montoVenta+rsConsulta.getDouble(2);
            }
        }catch(Exception e){
            e.printStackTrace();
        }
        return(montoVenta);
    }
    
    //ACT POLITICA NUEVA
    public double montoVentaFuncionarioLinea(Connection con, int codArea, String fechaIni, String fechaFin, int codFuncionario, int lineaMkt, int lineaVenta){
        double montoVenta=0;
        String lineaMktRep="";
        funcionesReportes obj=new funcionesReportes(1);
        if(lineaVenta!=0){
            lineaMktRep=obj.LineasVentaMkt(con, lineaVenta);
        }else{
            lineaMktRep=String.valueOf(lineaMkt);
        }
        
        try{
            String sqlConsulta = "select sum(ROUND(((sd.CANTIDAD_TOTAL*pp.cantidad_presentacion) + isnull(sd.CANTIDAD_UNITARIATOTAL,0)), 2)) as totalUnidades, " +
                    " (CASE sd.COD_OFERTA  When 0 Then isnull(sum(((isnull(sd.cantidad, 0) +(isnull(" +
                    " sd.cantidad_unitaria, 0) / pp.cantidad_presentacion)) * sd.precio_lista *((100 - sd.porcentaje_aplicadoprecio) / 100) *((100" +
                    "  - isnull(s.PORCENTAJE_DESCUENTO_PREFERENCIAL, 0)) / 100) *((100 - s.porcentaje_descuento) / 100)  * ((100-s.DESCUENTO_FIDELIDAD)/100) * " +
                    " ((100-(s.DESCUENTO_CONTADO))/100) * ((100-s.DESCUENTO_PREFERENCIAL)/100) -(isnull(PART_CHEQUE, 0) * isnull(sd.MONTO_CHEQUE, 0))    )), 0)" +
                    "   ELSE isnull(sum(((isnull(sd.cantidad, 0) +(isnull( sd.cantidad_unitaria, 0) / pp.cantidad_presentacion)) *" +
                    "  sd.precio_lista *((100 - sd.porcentaje_aplicadoprecio) / 100)  * ((100-s.DESCUENTO_FIDELIDAD)/100) * ((100-(s.DESCUENTO_CONTADO))/100) * ((100-s.DESCUENTO_PREFERENCIAL)/100) -(isnull(PART_CHEQUE, 0) " +
                    " * isnull(sd.MONTO_CHEQUE, 0))  ) ), 0)  END) as montoVenta " +
                    " from SALIDAS_VENTAS s,SALIDAS_DETALLEVENTAS sd,ALMACENES_VENTAS av,PRESENTACIONES_PRODUCTO pp,clientes cl " +
                    " where s.COD_SALIDAVENTA = sd.COD_SALIDAVENTAS and s.cod_area_empresa=sd.cod_area_empresa and s.COD_ALMACEN_VENTA = av.COD_ALMACEN_VENTA " +
                    " and pp.cod_presentacion = sd.COD_PRESENTACION and s.COD_CLIENTE = cl.cod_cliente " +
                    " and av.COD_AREA_EMPRESA in(" + codArea+ ") and cl.cod_tipocliente in (1,10,4,11) " +
                    " and s.FECHA_SALIDAVENTA>='" + fechaIni + " 00:00:00' and s.FECHA_SALIDAVENTA<='" + fechaFin + " 23:59:59' " +
                    " and s.cod_cliente in (select c.cod_cliente from clientes c where c.cod_area_empresa="+codArea+") and s.cod_personal in ("+codFuncionario+") ";
            sqlConsulta=sqlConsulta + " and pp.cod_lineamkt in ("+lineaMktRep+") ";
            sqlConsulta=sqlConsulta + " and s.COD_ESTADO_SALIDAVENTA<>2 and s.COD_TIPOSALIDAVENTAS=3 group by sd.cod_oferta";
            System.out.println("SQL CONSULTA MONTO FUNCIONARIO: "+sqlConsulta);
            Statement stConsulta=con.createStatement();
            ResultSet rsConsulta=stConsulta.executeQuery(sqlConsulta);
            while (rsConsulta.next()) {
                montoVenta=montoVenta+rsConsulta.getDouble(2);
            }
        }catch(Exception e){
            e.printStackTrace();
        }
        return(montoVenta);
    }
    
    
    //ACT POLITICA NUEVA
    public double montoVentaLinea(Connection con, String codArea, String fechaIni, String fechaFin, String lineaMkt, String codTipoCliente){
        double montoVenta=0;
        //si codTipoCliente es -1 tomamos cliente del rubro corriente
        if(codTipoCliente.equals("-1")){
            codTipoCliente="1,5,4,6";
        }
        if(codTipoCliente.equals("0")){
            codTipoCliente="1,5,4,6,7,8";
        }
        //si venta corriente es 1 escogemos solo lineas presupuestadas
        try{
            String sqlConsulta = "select sum(ROUND(((sd.CANTIDAD_TOTAL*pp.cantidad_presentacion) + isnull(sd.CANTIDAD_UNITARIATOTAL,0)), 2)) as totalUnidades, " +
                    " (CASE sd.COD_OFERTA  When 0 Then isnull(sum(((isnull(sd.cantidad, 0) +(isnull(" +
                    " sd.cantidad_unitaria, 0) / pp.cantidad_presentacion)) * sd.precio_lista *((100 - sd.porcentaje_aplicadoprecio) / 100) *((100" +
                    "  - isnull(s.PORCENTAJE_DESCUENTO_PREFERENCIAL, 0)) / 100) *((100 - s.porcentaje_descuento) / 100)  * ((100-s.DESCUENTO_FIDELIDAD)/100) * " +
                    " ((100-(s.DESCUENTO_CONTADO))/100) * ((100-s.DESCUENTO_PREFERENCIAL)/100) -(isnull(PART_CHEQUE, 0) * isnull(sd.MONTO_CHEQUE, 0))    )), 0)" +
                    "   ELSE isnull(sum(((isnull(sd.cantidad, 0) +(isnull( sd.cantidad_unitaria, 0) / pp.cantidad_presentacion)) *" +
                    "  sd.precio_lista *((100 - sd.porcentaje_aplicadoprecio) / 100)  * ((100-s.DESCUENTO_FIDELIDAD)/100) * ((100-(s.DESCUENTO_CONTADO))/100) * ((100-s.DESCUENTO_PREFERENCIAL)/100) -(isnull(PART_CHEQUE, 0) " +
                    " * isnull(sd.MONTO_CHEQUE, 0))  ) ), 0)  END) as montoVenta " +
                    " from SALIDAS_VENTAS s,SALIDAS_DETALLEVENTAS sd, PRESENTACIONES_PRODUCTO pp,clientes cl " +
                    " where s.COD_SALIDAVENTA = sd.COD_SALIDAVENTAS and s.cod_area_empresa=sd.cod_area_empresa " +
                    " and pp.cod_presentacion = sd.COD_PRESENTACION and s.COD_CLIENTE = cl.cod_cliente " +
                    " and s.COD_AREA_EMPRESA in (" + codArea+ ") " +
                    " and s.FECHA_SALIDAVENTA>='" + fechaIni + " 00:00:00' and s.FECHA_SALIDAVENTA<='" + fechaFin + " 23:59:59' " +
                    " and s.cod_cliente in (select c.cod_cliente from clientes c where c.cod_area_empresa in ("+codArea+")) ";
            sqlConsulta=sqlConsulta + " and pp.cod_lineamkt in ("+lineaMkt+") ";
            if(!codTipoCliente.equals("0")){
                sqlConsulta=sqlConsulta + " and cl.cod_tipocliente in ("+codTipoCliente+") ";
            }
            sqlConsulta=sqlConsulta + " and s.COD_ESTADO_SALIDAVENTA<>2 and s.COD_TIPOSALIDAVENTAS=3 group by sd.cod_oferta";
            System.out.println("SQL CONSULTA MONTO LINEA: "+sqlConsulta);
            PreparedStatement stConsulta=con.prepareStatement(sqlConsulta);
            
            
            ResultSet rsConsulta=stConsulta.executeQuery();
            while (rsConsulta.next()) {
                montoVenta=montoVenta+rsConsulta.getDouble(2);
            }
            rsConsulta.close();
            stConsulta.close();
        }catch(Exception e){
            e.printStackTrace();
        }
        return(montoVenta);
    }
    
    //ACT POLITICA NUEVA
    public double montoVentaLineaSChk(Connection con, String codArea, String fechaIni, String fechaFin, String lineaMkt, String codTipoCliente){
        double montoVenta=0;
        //si codTipoCliente es -1 tomamos cliente del rubro corriente
        if(codTipoCliente.equals("-1")){
            codTipoCliente="1,4,10,11";
        }
        if(codTipoCliente.equals("0")){
            codTipoCliente="1,4,6,7,8,9,10,11,12";
        }
        //si venta corriente es 1 escogemos solo lineas presupuestadas
        try{
            String sqlConsulta = "select sum(ROUND(((sd.CANTIDAD_TOTAL*pp.cantidad_presentacion) + isnull(sd.CANTIDAD_UNITARIATOTAL,0)), 2)) as totalUnidades, " +
                    " (CASE sd.COD_OFERTA  When 0 Then isnull(sum(((isnull(sd.cantidad, 0) +(isnull(" +
                    " sd.cantidad_unitaria, 0) / pp.cantidad_presentacion)) * sd.precio_lista *((100 - sd.porcentaje_aplicadoprecio) / 100) *((100" +
                    "  - isnull(s.PORCENTAJE_DESCUENTO_PREFERENCIAL, 0)) / 100) *((100 - s.porcentaje_descuento) / 100)  * ((100-s.DESCUENTO_FIDELIDAD)/100) * " +
                    " ((100-(s.DESCUENTO_CONTADO))/100) * ((100-s.DESCUENTO_PREFERENCIAL)/100)     )), 0)" +
                    "   ELSE isnull(sum(((isnull(sd.cantidad, 0) +(isnull( sd.cantidad_unitaria, 0) / pp.cantidad_presentacion)) *" +
                    "  sd.precio_lista *((100 - sd.porcentaje_aplicadoprecio) / 100)  * ((100-s.DESCUENTO_FIDELIDAD)/100) * ((100-(s.DESCUENTO_CONTADO))/100) * ((100-s.DESCUENTO_PREFERENCIAL)/100)  " +
                    "  ) ), 0)  END) as montoVenta " +
                    " from SALIDAS_VENTAS s,SALIDAS_DETALLEVENTAS sd, PRESENTACIONES_PRODUCTO pp,clientes cl " +
                    " where s.COD_SALIDAVENTA = sd.COD_SALIDAVENTAS and s.cod_area_empresa=sd.cod_area_empresa " +
                    " and pp.cod_presentacion = sd.COD_PRESENTACION and s.COD_CLIENTE = cl.cod_cliente " +
                    " and s.COD_AREA_EMPRESA in (" + codArea+ ") " +
                    " and s.FECHA_SALIDAVENTA>='" + fechaIni + " 00:00:00' and s.FECHA_SALIDAVENTA<='" + fechaFin + " 23:59:59' " +
                    " and s.cod_cliente in (select c.cod_cliente from clientes c where c.cod_area_empresa in ("+codArea+")) ";
            sqlConsulta=sqlConsulta + " and pp.cod_lineamkt in ("+lineaMkt+") ";
            if(!codTipoCliente.equals("0")){
                sqlConsulta=sqlConsulta + " and cl.cod_tipocliente in ("+codTipoCliente+") ";
            }
            sqlConsulta=sqlConsulta + " and s.COD_ESTADO_SALIDAVENTA<>2 and s.COD_TIPOSALIDAVENTAS=3 group by sd.cod_oferta";
            System.out.println("SQL CONSULTA MONTO LINEA: "+sqlConsulta);
            PreparedStatement stConsulta=con.prepareStatement(sqlConsulta);
            
            
            ResultSet rsConsulta=stConsulta.executeQuery();
            while (rsConsulta.next()) {
                montoVenta=montoVenta+rsConsulta.getDouble(2);
            }
            rsConsulta.close();
            stConsulta.close();
        }catch(Exception e){
            e.printStackTrace();
        }
        return(montoVenta);
    }
    
    
    //ACT NUEVA POLITICA PRECIOS
    public double montoVentaProducto(Connection con, String codArea, String fechaIni, String fechaFin, String codProducto, String codTipoCliente){
        double montoVenta=0;
        //si codTipoCliente es -1 tomamos cliente del rubro corriente
        if(codTipoCliente.equals("-1")){
            codTipoCliente="1,4,10,11";
        }
        //si venta corriente es 1 escogemos solo lineas presupuestadas
        try{
            String sqlConsulta = "select sum(ROUND(((sd.CANTIDAD_TOTAL*pp.cantidad_presentacion) + isnull(sd.CANTIDAD_UNITARIATOTAL,0)), 2)) as totalUnidades, " +
                    " (CASE sd.COD_OFERTA  When 0 Then isnull(sum(((isnull(sd.cantidad, 0) +(isnull(" +
                    " sd.cantidad_unitaria, 0) / pp.cantidad_presentacion)) * sd.precio_lista *((100 - sd.porcentaje_aplicadoprecio) / 100) *((100" +
                    "  - isnull(s.PORCENTAJE_DESCUENTO_PREFERENCIAL, 0)) / 100) *((100 - s.porcentaje_descuento) / 100)  * ((100-s.DESCUENTO_FIDELIDAD)/100) * " +
                    " ((100-(s.DESCUENTO_CONTADO))/100) * ((100-s.DESCUENTO_PREFERENCIAL)/100) -(isnull(PART_CHEQUE, 0) * isnull(sd.MONTO_CHEQUE, 0))    )), 0)" +
                    "   ELSE isnull(sum(((isnull(sd.cantidad, 0) +(isnull( sd.cantidad_unitaria, 0) / pp.cantidad_presentacion)) *" +
                    "  sd.precio_lista *((100 - sd.porcentaje_aplicadoprecio) / 100)  * ((100-s.DESCUENTO_FIDELIDAD)/100) * ((100-(s.DESCUENTO_CONTADO))/100) * ((100-s.DESCUENTO_PREFERENCIAL)/100) -(isnull(PART_CHEQUE, 0) " +
                    " * isnull(sd.MONTO_CHEQUE, 0))  ) ), 0)  END) as montoVenta " +
                    " from SALIDAS_VENTAS s,SALIDAS_DETALLEVENTAS sd, PRESENTACIONES_PRODUCTO pp,clientes cl " +
                    " where s.COD_SALIDAVENTA = sd.COD_SALIDAVENTAS and s.cod_area_empresa=sd.cod_area_empresa " +
                    " and pp.cod_presentacion = sd.COD_PRESENTACION and s.COD_CLIENTE = cl.cod_cliente " +
                    " and s.COD_AREA_EMPRESA in (" + codArea+ ") " +
                    " and s.FECHA_SALIDAVENTA>='" + fechaIni + " 00:00:00' and s.FECHA_SALIDAVENTA<='" + fechaFin + " 23:59:59' " +
                    " and s.cod_cliente in (select c.cod_cliente from clientes c where c.cod_area_empresa in ("+codArea+")) ";
            sqlConsulta=sqlConsulta + " and pp.cod_presentacion in ("+codProducto+") ";
            if(!codTipoCliente.equals("0")){
                sqlConsulta=sqlConsulta + " and cl.cod_tipocliente in ("+codTipoCliente+") ";
            }
            sqlConsulta=sqlConsulta + " and s.COD_ESTADO_SALIDAVENTA<>2 and s.COD_TIPOSALIDAVENTAS=3 group by sd.cod_oferta";
            System.out.println("SQL CONSULTA MONTO PRODUCTO: "+sqlConsulta);
            PreparedStatement stConsulta=con.prepareStatement(sqlConsulta);
            ResultSet rsConsulta=stConsulta.executeQuery();
            while (rsConsulta.next()) {
                montoVenta=montoVenta+rsConsulta.getDouble(2);
            }
            rsConsulta.close();
            stConsulta.close();
        }catch(Exception e){
            e.printStackTrace();
        }
        return(montoVenta);
    }
    
    
    public double cantidadVentaProducto(Connection con, String codArea, String fechaIni, String fechaFin, String codProducto, String codTipoCliente){
        double montoVenta=0;
        //si codTipoCliente es -1 tomamos cliente del rubro corriente
        if(codTipoCliente.equals("-1")){
            codTipoCliente="1,5,4,6";
        }
        //si venta corriente es 1 escogemos solo lineas presupuestadas
        try{
            String sqlConsulta = "select sum(ROUND(((sd.CANTIDAD_TOTAL) + isnull((sd.CANTIDAD_UNITARIATOTAL/pp.cantidad_presentacion),0)), 2)) as totalUnidades " +
                    " from SALIDAS_VENTAS s,SALIDAS_DETALLEVENTAS sd, PRESENTACIONES_PRODUCTO pp,clientes cl " +
                    " where s.COD_SALIDAVENTA = sd.COD_SALIDAVENTAS and s.cod_area_empresa=sd.cod_area_empresa " +
                    " and pp.cod_presentacion = sd.COD_PRESENTACION and s.COD_CLIENTE = cl.cod_cliente " +
                    " and s.COD_AREA_EMPRESA in (" + codArea+ ") " +
                    " and s.FECHA_SALIDAVENTA>='" + fechaIni + " 00:00:00' and s.FECHA_SALIDAVENTA<='" + fechaFin + " 23:59:59' " +
                    " and s.cod_cliente in (select c.cod_cliente from clientes c where c.cod_area_empresa in ("+codArea+")) ";
            sqlConsulta=sqlConsulta + " and pp.cod_presentacion in ("+codProducto+") ";
            if(!codTipoCliente.equals("0")){
                sqlConsulta=sqlConsulta + " and cl.cod_tipocliente in ("+codTipoCliente+") ";
            }
            sqlConsulta=sqlConsulta + " and s.COD_ESTADO_SALIDAVENTA<>2 and s.COD_TIPOSALIDAVENTAS=3 group by sd.cod_oferta";
            System.out.println("SQL CONSULTA MONTO PRODUCTO: "+sqlConsulta);
            PreparedStatement stConsulta=con.prepareStatement(sqlConsulta);
            ResultSet rsConsulta=stConsulta.executeQuery();
            while (rsConsulta.next()) {
                montoVenta=montoVenta+rsConsulta.getDouble(1);
            }
            rsConsulta.close();
            stConsulta.close();
        }catch(Exception e){
            e.printStackTrace();
        }
        return(montoVenta);
    }
    
    
    //ACT POLITICA NUEVA
    public double montoVentaProductoCliente(Connection con, String fechaIni, String fechaFin, String codProducto, String codCliente){
        double montoVenta=0;
        try{
            String sqlConsulta = "select sum(ROUND(((sd.CANTIDAD_TOTAL*pp.cantidad_presentacion) + isnull(sd.CANTIDAD_UNITARIATOTAL,0)), 2)) as totalUnidades, " +
                    " (CASE sd.COD_OFERTA  When 0 Then isnull(sum(((isnull(sd.cantidad, 0) +(isnull(" +
                    " sd.cantidad_unitaria, 0) / pp.cantidad_presentacion)) * sd.precio_lista *((100 - sd.porcentaje_aplicadoprecio) / 100) *((100" +
                    "  - isnull(s.PORCENTAJE_DESCUENTO_PREFERENCIAL, 0)) / 100) *((100 - s.porcentaje_descuento) / 100)  * ((100-s.DESCUENTO_FIDELIDAD)/100) * " +
                    " ((100-(s.DESCUENTO_CONTADO))/100) * ((100-s.DESCUENTO_PREFERENCIAL)/100) -(isnull(PART_CHEQUE, 0) * isnull(sd.MONTO_CHEQUE, 0))    )), 0)" +
                    "   ELSE isnull(sum(((isnull(sd.cantidad, 0) +(isnull( sd.cantidad_unitaria, 0) / pp.cantidad_presentacion)) *" +
                    "  sd.precio_lista *((100 - sd.porcentaje_aplicadoprecio) / 100)  * ((100-s.DESCUENTO_FIDELIDAD)/100) * ((100-(s.DESCUENTO_CONTADO))/100) * ((100-s.DESCUENTO_PREFERENCIAL)/100) -(isnull(PART_CHEQUE, 0) " +
                    " * isnull(sd.MONTO_CHEQUE, 0))  ) ), 0)  END) as montoVenta " +
                    " from SALIDAS_VENTAS s,SALIDAS_DETALLEVENTAS sd, PRESENTACIONES_PRODUCTO pp,clientes cl " +
                    " where s.COD_SALIDAVENTA = sd.COD_SALIDAVENTAS and s.cod_area_empresa=sd.cod_area_empresa " +
                    " and pp.cod_presentacion = sd.COD_PRESENTACION and s.COD_CLIENTE = cl.cod_cliente " +
                    " and s.FECHA_SALIDAVENTA>='" + fechaIni + " 00:00:00' and s.FECHA_SALIDAVENTA<='" + fechaFin + " 23:59:59' " +
                    " and s.cod_cliente in ("+codCliente+") and pp.cod_presentacion in ("+codProducto+") " +
                    " and s.COD_ESTADO_SALIDAVENTA<>2 and s.COD_TIPOSALIDAVENTAS=3 group by sd.cod_oferta";
            System.out.println("SQL CONSULTA MONTO PROD CLI.: "+sqlConsulta);
            PreparedStatement stConsulta=con.prepareStatement(sqlConsulta);
            ResultSet rsConsulta=stConsulta.executeQuery();
            while (rsConsulta.next()) {
                montoVenta=montoVenta+rsConsulta.getDouble(2);
            }
            rsConsulta.close();
            stConsulta.close();
            
        }catch(Exception e){
            e.printStackTrace();
        }
        return(montoVenta);
    }
    
    
    public double cantidadVentaProductoCliente(Connection con, String fechaIni, String fechaFin, String codProducto, String codCliente, int enCajas){
        double cantCaja=0;
        double cantUnidades=0;
        double cantidadDev=0;
        //si enCajas==1 devuelve cajas caso contrario en unidades
        try{
            String sqlConsulta = "select sum(ROUND(((sd.CANTIDAD_TOTAL) + isnull((sd.CANTIDAD_UNITARIATOTAL/pp.cantidad_presentacion),0)), 2)) as totalCajas, " +
                    " sum(ROUND(((sd.CANTIDAD_TOTAL*pp.cantidad_presentacion) + isnull((sd.CANTIDAD_UNITARIATOTAL),0)), 2)) as totalUnidades" +
                    " from SALIDAS_VENTAS s,SALIDAS_DETALLEVENTAS sd, PRESENTACIONES_PRODUCTO pp,clientes cl " +
                    " where s.COD_SALIDAVENTA = sd.COD_SALIDAVENTAS and s.cod_area_empresa=sd.cod_area_empresa " +
                    " and pp.cod_presentacion = sd.COD_PRESENTACION and s.COD_CLIENTE = cl.cod_cliente " +
                    " and s.FECHA_SALIDAVENTA>='" + fechaIni + " 00:00:00' and s.FECHA_SALIDAVENTA<='" + fechaFin + " 23:59:59' " +
                    " and s.cod_cliente in ("+codCliente+") and pp.cod_presentacion in ("+codProducto+") " +
                    " and s.COD_ESTADO_SALIDAVENTA<>2 and s.COD_TIPOSALIDAVENTAS=3 group by sd.cod_oferta";
            System.out.println("SQL CONSULTA MONTO PROD CLI.: "+sqlConsulta);
            PreparedStatement stConsulta=con.prepareStatement(sqlConsulta);
            ResultSet rsConsulta=stConsulta.executeQuery();
            while (rsConsulta.next()) {
                cantCaja=cantCaja+rsConsulta.getDouble(1);
                cantUnidades=cantUnidades+rsConsulta.getDouble(2);
            }
            rsConsulta.close();
            stConsulta.close();
            
        }catch(Exception e){
            e.printStackTrace();
        }
        if(enCajas==1){
            cantidadDev=cantCaja;
        }else{
            cantidadDev=cantUnidades;
        }
        return(cantidadDev);
    }
    
    //ACT POLITICA NUEVA
    public double montoVentaProductoZona(Connection con, String fechaIni, String fechaFin, String codProducto, String codZona, String tipoCliente){
        double montoVenta=0;
        try{
            String sqlConsulta = "select sum(ROUND(((sd.CANTIDAD_TOTAL*pp.cantidad_presentacion) + isnull(sd.CANTIDAD_UNITARIATOTAL,0)), 2)) as totalUnidades, " +
                    " (CASE sd.COD_OFERTA  When 0 Then isnull(sum(((isnull(sd.cantidad, 0) +(isnull(" +
                    " sd.cantidad_unitaria, 0) / pp.cantidad_presentacion)) * sd.precio_lista *((100 - sd.porcentaje_aplicadoprecio) / 100) *((100" +
                    "  - isnull(s.PORCENTAJE_DESCUENTO_PREFERENCIAL, 0)) / 100) *((100 - s.porcentaje_descuento) / 100)  * ((100-s.DESCUENTO_FIDELIDAD)/100) * " +
                    " ((100-(s.DESCUENTO_CONTADO))/100) * ((100-s.DESCUENTO_PREFERENCIAL)/100) -(isnull(PART_CHEQUE, 0) * isnull(sd.MONTO_CHEQUE, 0))    )), 0)" +
                    "   ELSE isnull(sum(((isnull(sd.cantidad, 0) +(isnull( sd.cantidad_unitaria, 0) / pp.cantidad_presentacion)) *" +
                    "  sd.precio_lista *((100 - sd.porcentaje_aplicadoprecio) / 100)  * ((100-s.DESCUENTO_FIDELIDAD)/100) * ((100-(s.DESCUENTO_CONTADO))/100) * ((100-s.DESCUENTO_PREFERENCIAL)/100) -(isnull(PART_CHEQUE, 0) " +
                    " * isnull(sd.MONTO_CHEQUE, 0))  ) ), 0)  END) as montoVenta " +
                    " from SALIDAS_VENTAS s,SALIDAS_DETALLEVENTAS sd, PRESENTACIONES_PRODUCTO pp,clientes cl " +
                    " where s.COD_SALIDAVENTA = sd.COD_SALIDAVENTAS and s.cod_area_empresa=sd.cod_area_empresa " +
                    " and pp.cod_presentacion = sd.COD_PRESENTACION and s.COD_CLIENTE = cl.cod_cliente and cl.cod_tipocliente in ("+tipoCliente+")" +
                    " and s.FECHA_SALIDAVENTA>='" + fechaIni + " 00:00:00' and s.FECHA_SALIDAVENTA<='" + fechaFin + " 23:59:59' " +
                    " and cl.cod_zona in ("+codZona+") and pp.cod_presentacion in ("+codProducto+") " +
                    " and s.COD_ESTADO_SALIDAVENTA<>2 and s.COD_TIPOSALIDAVENTAS=3 group by sd.cod_oferta";
            System.out.println("SQL CONSULTA MONTO PROD CLI.: "+sqlConsulta);
            PreparedStatement stConsulta=con.prepareStatement(sqlConsulta);
            ResultSet rsConsulta=stConsulta.executeQuery();
            while (rsConsulta.next()) {
                montoVenta=montoVenta+rsConsulta.getDouble(2);
            }
            rsConsulta.close();
            stConsulta.close();
            
        }catch(Exception e){
            e.printStackTrace();
        }
        return(montoVenta);
    }
    
    
    public double cantidadVentaProductoZona(Connection con, String fechaIni, String fechaFin, String codProducto, String codZona, String tipoCliente){
        double montoVenta=0;
        try{
            String sqlConsulta = "select sum(ROUND(((sd.CANTIDAD_TOTAL) + isnull((sd.CANTIDAD_UNITARIATOTAL/pp.cantidad_presentacion),0)), 2)) as totalUnidades " +
                    " from SALIDAS_VENTAS s,SALIDAS_DETALLEVENTAS sd, PRESENTACIONES_PRODUCTO pp,clientes cl " +
                    " where s.COD_SALIDAVENTA = sd.COD_SALIDAVENTAS and s.cod_area_empresa=sd.cod_area_empresa " +
                    " and pp.cod_presentacion = sd.COD_PRESENTACION and s.COD_CLIENTE = cl.cod_cliente and cl.cod_tipocliente in ("+tipoCliente+")" +
                    " and s.FECHA_SALIDAVENTA>='" + fechaIni + " 00:00:00' and s.FECHA_SALIDAVENTA<='" + fechaFin + " 23:59:59' " +
                    " and cl.cod_zona in ("+codZona+") and pp.cod_presentacion in ("+codProducto+") " +
                    " and s.COD_ESTADO_SALIDAVENTA<>2 and s.COD_TIPOSALIDAVENTAS=3 group by sd.cod_oferta";
            System.out.println("SQL CONSULTA MONTO PROD CLI.: "+sqlConsulta);
            PreparedStatement stConsulta=con.prepareStatement(sqlConsulta);
            ResultSet rsConsulta=stConsulta.executeQuery();
            while (rsConsulta.next()) {
                montoVenta=montoVenta+rsConsulta.getDouble(1);
            }
            rsConsulta.close();
            stConsulta.close();
            
        }catch(Exception e){
            e.printStackTrace();
        }
        return(montoVenta);
    }
    
    public double costoPromedio(Connection con, String fecha, String codPresentacion){
        double costoPres=0;
        try{
            String sqlConsulta="select c.COSTO_TOTAL from COSTOS_PRODUCTO c " +
                    " where c.COD_GESTION=8 and c.COD_MES=9 and c.COD_PRESENTACION="+codPresentacion+"";
            Statement stConsulta=con.createStatement();
            ResultSet rsConsulta=stConsulta.executeQuery(sqlConsulta);
            while (rsConsulta.next()) {
                costoPres=rsConsulta.getDouble(1);
            }
        }catch (Exception e){
            e.printStackTrace();
        }
        return(costoPres);
    }
    
    
    
    public double calcularProm(Connection con, int cantMes,int codPresentacion,String fecha) {
        
        String sql="";
        String[] datos= fecha.split("-");
        String Gestion="";
        String Gestion2="";
        int mes=Integer.parseInt(datos[1]);
        int mesInicio=-1;
        double resultado=0;
        if(mes >3 ) {
            Gestion=datos[0]+"/"+String.valueOf(Integer.parseInt(datos[0])+1);
            if((mes-(cantMes+3))<0 ) {
                Gestion2=String.valueOf(Integer.parseInt(datos[0])-1)+"/"+datos[0];
            }
        } else {
            Gestion=String.valueOf(Integer.parseInt(datos[0])-1)+"/"+datos[0];
            if(((mes+12)-(cantMes+3))<0 ) {
                Gestion2=String.valueOf(Integer.parseInt(datos[0])-2)+"/"+String.valueOf(Integer.parseInt(datos[0])-1);
            }
        }
        if(mes>=cantMes) {
            mesInicio=(mes+1)-cantMes;
        } else {
            mesInicio=(mes+13)-cantMes;
        }
        if(Gestion2=="") {
            sql="select a.COSTO_TOTAL,a.COD_MES,a.COD_GESTION from COSTOS_PRODUCTO a where (a.COD_GESTION=(SELECT b.COD_GESTION from GESTIONES b where b.NOMBRE_GESTION='"+Gestion+"') ";
            if(mes>=mesInicio)
                sql+= "and a.COD_MES BETWEEN '"+mesInicio+"' and '"+mes+"' )";
            else
                sql+="and ( (a.COD_MES BETWEEN '"+mesInicio+"' and '12') or (a.COD_MES BETWEEN '1' and '"+mes+"') ))";
        } else {
            sql="select a.COSTO_TOTAL,a.COD_MES,a.COD_GESTION from COSTOS_PRODUCTO a where ( (a.COD_GESTION=(SELECT b.COD_GESTION from GESTIONES b where b.NOMBRE_GESTION='"+Gestion+"') ";
            if(mes>3) {
                sql+= "and a.COD_MES BETWEEN '4' and '"+mes+"' )";
            } else {
                sql+="and ( (a.COD_MES BETWEEN '4' and '12') or (a.COD_MES BETWEEN '1' and '"+mes+"') )) ";
            }
            sql+=" or (a.COD_GESTION=(SELECT b.COD_GESTION from GESTIONES b where b.NOMBRE_GESTION='"+Gestion2+"') ";
            if(mesInicio<4) {
                sql+="and a.COD_MES BETWEEN '"+mesInicio+"' and '3'))";
            } else {
                sql+="and ( (a.COD_MES BETWEEN '"+mesInicio+"' and '12')or(a.COD_MES BETWEEN '1' and '3') ))) ";
            }
            sql+=" and a.COD_PRESENTACION='"+codPresentacion+"'";
        }
        System.out.println(sql);
        try{
            
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet  result=st.executeQuery(sql);
            System.out.println(fecha);
            System.out.println("cant meses"+cantMes);
            if(result!=null) {
                double suma=0;
                int cont=0;
                while(result.next()) {
                    double aux=result.getDouble("COSTO_TOTAL");
                    System.out.println("codMes:"+ result.getString("COD_MES")+" gestion "+result.getString("COD_GESTION"));
                    System.out.println( "valor = "+aux);
                    suma+=aux;
                    
                    cont++;
                    
                }
                if(suma>0)
                    resultado=suma/cont;
                else
                    resultado=0;
                System.out.println("suma = "+suma);
                System.out.println("contador= "+cont);
                System.out.println("resultado="+resultado);
            }
        } catch (SQLException e) {
        }
        
        return resultado;
    }
    
    
    
    
    public double costoTotalProducto(Connection con, String codArea, String fechaIni, String fechaFin, String codProducto, String codTipoCliente){
        double totalCajas=0;
        double totalProducto=0;
        double costoTotalProducto=0;
        funcionesReportes obj=new funcionesReportes(1);
        
        //si codTipoCliente es -1 tomamos cliente del rubro corriente
        if(codTipoCliente.equals("-1")){
            codTipoCliente="1,5,4,6";
        }
        //si venta corriente es 1 escogemos solo lineas presupuestadas
        try{
            String sqlConsulta = "select sum(sd.CANTIDAD_TOTAL*pp.cantidad_presentacion)+sum(sd.CANTIDAD_UNITARIATOTAL)" +
                    " from SALIDAS_VENTAS s,SALIDAS_DETALLEVENTAS sd, PRESENTACIONES_PRODUCTO pp,clientes cl " +
                    " where s.COD_SALIDAVENTA = sd.COD_SALIDAVENTAS and s.cod_area_empresa=sd.cod_area_empresa " +
                    " and pp.cod_presentacion = sd.COD_PRESENTACION and s.COD_CLIENTE = cl.cod_cliente " +
                    " and s.COD_AREA_EMPRESA in (" + codArea+ ") " +
                    " and s.FECHA_SALIDAVENTA>='" + fechaIni + " 00:00:00' and s.FECHA_SALIDAVENTA<='" + fechaFin + " 23:59:59' " +
                    " and s.cod_cliente in (select c.cod_cliente from clientes c where c.cod_area_empresa in ("+codArea+")) ";
            sqlConsulta=sqlConsulta + " and pp.cod_presentacion in ("+codProducto+") ";
            if(!codTipoCliente.equals("0")){
                sqlConsulta=sqlConsulta + " and cl.cod_tipocliente in ("+codTipoCliente+") ";
            }
            sqlConsulta=sqlConsulta + " and s.COD_ESTADO_SALIDAVENTA<>2 and s.COD_TIPOSALIDAVENTAS=3";
            System.out.println("SQL CONSULTA CANTIDADES: "+sqlConsulta);
            PreparedStatement stConsulta=con.prepareStatement(sqlConsulta);
            ResultSet rsConsulta=stConsulta.executeQuery();
            while (rsConsulta.next()) {
                totalCajas=rsConsulta.getDouble(1);
            }
            rsConsulta.close();
            stConsulta.close();
            totalProducto=totalCajas;
            double costoProducto=obj.costoPromedio(con, fechaFin, codProducto);
            costoTotalProducto=totalProducto*costoProducto;
            
        }catch(Exception e){
            e.printStackTrace();
        }
        return(costoTotalProducto);
    }
    
    public double costoTotalProductoCliente(Connection con, String fechaIni, String fechaFin, String codProducto, String codCliente){
        double totalCajas=0;
        double totalProducto=0;
        double costoTotalProducto=0;
        funcionesReportes obj=new funcionesReportes(1);
        
        try{
            String sqlConsulta = "select sum(sd.CANTIDAD_TOTAL*pp.cantidad_presentacion)+sum(sd.CANTIDAD_UNITARIATOTAL)" +
                    " from SALIDAS_VENTAS s,SALIDAS_DETALLEVENTAS sd, PRESENTACIONES_PRODUCTO pp,clientes cl " +
                    " where s.COD_SALIDAVENTA = sd.COD_SALIDAVENTAS and s.cod_area_empresa=sd.cod_area_empresa " +
                    " and pp.cod_presentacion = sd.COD_PRESENTACION and s.COD_CLIENTE = cl.cod_cliente " +
                    " and s.FECHA_SALIDAVENTA>='" + fechaIni + " 00:00:00' and s.FECHA_SALIDAVENTA<='" + fechaFin + " 23:59:59' " +
                    " and s.cod_cliente in ("+codCliente+") " +
                    " and pp.cod_presentacion in ("+codProducto+") and s.COD_ESTADO_SALIDAVENTA<>2 and s.COD_TIPOSALIDAVENTAS=3";
            System.out.println("SQL CONSULTA CANTIDADES: "+sqlConsulta);
            PreparedStatement stConsulta=con.prepareStatement(sqlConsulta);
            ResultSet rsConsulta=stConsulta.executeQuery();
            while (rsConsulta.next()) {
                totalCajas=rsConsulta.getDouble(1);
            }
            rsConsulta.close();
            stConsulta.close();
            totalProducto=totalCajas;
            double costoProducto=obj.costoPromedio(con, fechaFin, codProducto);
            costoTotalProducto=totalProducto*costoProducto;
            
        }catch(Exception e){
            e.printStackTrace();
        }
        return(costoTotalProducto);
    }
    
    public double costoPorCliente(Connection con, String codCliente, String fechaIni, String fechaFin, String lineaMkt){
        double totalCajas=0;
        double totalProducto=0;
        double costoTotalProducto=0;
        double costoTotalCliente=0;
        //si linea mkt es 0 se toman todas las lineas
        funcionesReportes obj=new funcionesReportes(1);
        try{
            String sql="select sd.COD_PRESENTACION, sum(sd.CANTIDAD_TOTAL*pp.cantidad_presentacion)+sum(sd.CANTIDAD_UNITARIATOTAL) from SALIDAS_VENTAS s, " +
                    " SALIDAS_DETALLEVENTAS sd, PRESENTACIONES_PRODUCTO pp " +
                    " where s.COD_SALIDAVENTA=sd.COD_SALIDAVENTAS and sd.COD_PRESENTACION=pp.cod_presentacion and " +
                    " s.COD_AREA_EMPRESA=sd.COD_AREA_EMPRESA and s.FECHA_SALIDAVENTA BETWEEN '"+fechaIni+" 00:00:00' and '"+fechaFin+" 23:59:59' ";
            if(!lineaMkt.equals("0")){
                sql=sql+ " and pp.cod_lineamkt in ("+lineaMkt+") ";
            }
            sql=sql+" and s.COD_ESTADO_SALIDAVENTA<>2 and s.COD_CLIENTE="+codCliente+" group by sd.COD_PRESENTACION";
            System.out.println("sql rent x cliente: "+sql);
            PreparedStatement st=con.prepareStatement(sql);
            ResultSet rs=st.executeQuery();
            while(rs.next()){
                String codProducto=rs.getString(1);
                totalCajas=rs.getDouble(2);
                double costoProducto=obj.costoPromedio(con, fechaFin, codProducto);
                costoTotalProducto=totalCajas*costoProducto;
                costoTotalCliente=costoTotalCliente+costoTotalProducto;
            }
            rs.close();
            st.close();
        }catch(Exception e){
            e.printStackTrace();
        }
        return (costoTotalCliente);
    }
    
    
    public double costoPorLinea(Connection con, String codLinea, String codArea, String tipoCliente, String fechaIni, String fechaFin){
        double totalCajas=0;
        double totalProducto=0;
        double costoTotalProducto=0;
        double costoTotalLinea=0;
        funcionesReportes obj=new funcionesReportes(1);
        try{
            String sql="select sd.COD_PRESENTACION, pp.nombre_producto_presentacion, sum(sd.CANTIDAD_TOTAL*pp.cantidad_presentacion)+sum(sd.CANTIDAD_UNITARIATOTAL) from SALIDAS_VENTAS s, " +
                    " SALIDAS_DETALLEVENTAS sd, PRESENTACIONES_PRODUCTO pp, clientes c " +
                    " where s.COD_SALIDAVENTA=sd.COD_SALIDAVENTAS and sd.COD_PRESENTACION=pp.cod_presentacion and c.cod_tipocliente in ("+tipoCliente+") and  " +
                    " s.COD_AREA_EMPRESA=sd.COD_AREA_EMPRESA and s.FECHA_SALIDAVENTA BETWEEN '"+fechaIni+" 00:00:00' and '"+fechaFin+" 23:59:59' " +
                    " and s.COD_ESTADO_SALIDAVENTA<>2 and pp.cod_lineamkt in ("+codLinea+") and s.cod_area_empresa in ("+codArea+") " +
                    " and s.COD_TIPOSALIDAVENTAS=3 and s.cod_cliente=c.cod_cliente and s.cod_area_empresa=sd.cod_area_empresa " +
                    " group by sd.COD_PRESENTACION, pp.nombre_producto_presentacion order by pp.nombre_producto_presentacion";
            
            System.out.println("sql rent x linea: "+sql);
            
            PreparedStatement st=con.prepareStatement(sql);
            ResultSet rs=st.executeQuery();
            while(rs.next()){
                String codProducto=rs.getString(1);
                String nombreProducto=rs.getString(2);
                totalCajas=rs.getDouble(3);
                
                System.out.println(nombreProducto+" "+totalCajas);
                double costoProducto=obj.costoPromedio(con, fechaFin, codProducto);
                costoTotalProducto=totalCajas*costoProducto;
                System.out.println("costo: "+costoTotalProducto);
                
                costoTotalLinea=costoTotalLinea+costoTotalProducto;
            }
            rs.close();
            st.close();
        }catch(Exception e){
            e.printStackTrace();
        }
        return (costoTotalLinea);
    }
    
    public int[] cantidadCajasLinea(Connection con, String codArea, String fechaIni, String fechaFin, String lineaMkt, String codTipoCliente){
        int totalCajas=0;
        int totalUnidades=0;
        int vector[]=new int[2];
        //si codTipoCliente es -1 tomamos cliente del rubro corriente
        if(codTipoCliente.equals("-1")){
            codTipoCliente="1,5,4,6";
        }
        //si venta corriente es 1 escogemos solo lineas presupuestadas
        try{
            String sqlConsulta = "select sum(sd.CANTIDAD_TOTAL), sum(sd.CANTIDAD_UNITARIATOTAL)" +
                    " from SALIDAS_VENTAS s,SALIDAS_DETALLEVENTAS sd, PRESENTACIONES_PRODUCTO pp,clientes cl " +
                    " where s.COD_SALIDAVENTA = sd.COD_SALIDAVENTAS and s.cod_area_empresa=sd.cod_area_empresa " +
                    " and pp.cod_presentacion = sd.COD_PRESENTACION and s.COD_CLIENTE = cl.cod_cliente " +
                    " and s.COD_AREA_EMPRESA in (" + codArea+ ") " +
                    " and s.FECHA_SALIDAVENTA>='" + fechaIni + " 00:00:00' and s.FECHA_SALIDAVENTA<='" + fechaFin + " 23:59:59' " +
                    " and s.cod_cliente in (select c.cod_cliente from clientes c where c.cod_area_empresa in ("+codArea+")) ";
            sqlConsulta=sqlConsulta + " and pp.cod_lineamkt in ("+lineaMkt+") ";
            if(!codTipoCliente.equals("0")){
                sqlConsulta=sqlConsulta + " and cl.cod_tipocliente in ("+codTipoCliente+") ";
            }
            sqlConsulta=sqlConsulta + " and s.COD_ESTADO_SALIDAVENTA<>2 and s.COD_TIPOSALIDAVENTAS=3";
            System.out.println("SQL CONSULTA CANTIDADES: "+sqlConsulta);
            Statement stConsulta=con.createStatement();
            ResultSet rsConsulta=stConsulta.executeQuery(sqlConsulta);
            while (rsConsulta.next()) {
                totalCajas=rsConsulta.getInt(1);
                totalUnidades=rsConsulta.getInt(2);
            }
        }catch(Exception e){
            e.printStackTrace();
        }
        vector[0]=totalCajas;
        vector[1]=totalUnidades;
        return(vector);
    }
    
    
    
    //ACT POLITICA NUEVA
    public double montoVentaRegional(Connection con, int codArea, String fechaIni, String fechaFin, int ventaCorriente){
        double montoVenta=0;
        //si venta corriente es 1 escogemos solo lineas presupuestadas
        try{
            String sqlConsulta = "select sum(ROUND(((sd.CANTIDAD_TOTAL*pp.cantidad_presentacion) + isnull(sd.CANTIDAD_UNITARIATOTAL,0)), 2)) as totalUnidades, " +
                    " (CASE sd.COD_OFERTA  When 0 Then isnull(sum(((isnull(sd.cantidad, 0) +(isnull(" +
                    " sd.cantidad_unitaria, 0) / pp.cantidad_presentacion)) * sd.precio_lista *((100 - sd.porcentaje_aplicadoprecio) / 100) *((100" +
                    "  - isnull(s.PORCENTAJE_DESCUENTO_PREFERENCIAL, 0)) / 100) *((100 - s.porcentaje_descuento) / 100)  * ((100-s.DESCUENTO_FIDELIDAD)/100) * " +
                    " ((100-(s.DESCUENTO_CONTADO))/100) * ((100-s.DESCUENTO_PREFERENCIAL)/100) -(isnull(PART_CHEQUE, 0) * isnull(sd.MONTO_CHEQUE, 0))    )), 0)" +
                    "   ELSE isnull(sum(((isnull(sd.cantidad, 0) +(isnull( sd.cantidad_unitaria, 0) / pp.cantidad_presentacion)) *" +
                    "  sd.precio_lista *((100 - sd.porcentaje_aplicadoprecio) / 100)  * ((100-s.DESCUENTO_FIDELIDAD)/100) * ((100-(s.DESCUENTO_CONTADO))/100) * ((100-s.DESCUENTO_PREFERENCIAL)/100) -(isnull(PART_CHEQUE, 0) " +
                    " * isnull(sd.MONTO_CHEQUE, 0))  ) ), 0)  END) as montoVenta " +
                    " from SALIDAS_VENTAS s,SALIDAS_DETALLEVENTAS sd,ALMACENES_VENTAS av,PRESENTACIONES_PRODUCTO pp,clientes cl " +
                    " where s.COD_SALIDAVENTA = sd.COD_SALIDAVENTAS and s.cod_area_empresa=sd.cod_area_empresa and s.COD_ALMACEN_VENTA = av.COD_ALMACEN_VENTA " +
                    " and pp.cod_presentacion = sd.COD_PRESENTACION and s.COD_CLIENTE = cl.cod_cliente " +
                    " and av.COD_AREA_EMPRESA in(" + codArea+ ") and cl.cod_tipocliente in (1,10,4,11) " +
                    " and s.FECHA_SALIDAVENTA>='" + fechaIni + " 00:00:00' and s.FECHA_SALIDAVENTA<='" + fechaFin + " 23:59:59' " +
                    " and s.cod_cliente in (select c.cod_cliente from clientes c where c.cod_area_empresa="+codArea+") ";
            if(ventaCorriente==1){
                sqlConsulta=sqlConsulta + " and pp.cod_lineamkt not in (10) ";
            }
            sqlConsulta=sqlConsulta + " and s.COD_ESTADO_SALIDAVENTA<>2 and s.COD_TIPOSALIDAVENTAS=3 group by sd.cod_oferta";
            System.out.println("SQL CONSULTA: "+sqlConsulta);
            Statement stConsulta=con.createStatement();
            ResultSet rsConsulta=stConsulta.executeQuery(sqlConsulta);
            while (rsConsulta.next()) {
                montoVenta=montoVenta+rsConsulta.getDouble(2);
            }
        }catch(Exception e){
            e.printStackTrace();
        }
        return(montoVenta);
    }
    
    //ACT POLITICA NUEVA
    public double montoVentaRegionalGeneral(Connection con, int codArea, String fechaIni, String fechaFin, String codLineas, String tipoCliente){
        double montoVenta=0;
        //si venta corriente es 1 escogemos solo lineas presupuestadas
        try{
            String sqlConsulta = "select sum(ROUND(((sd.CANTIDAD_TOTAL*pp.cantidad_presentacion) + isnull(sd.CANTIDAD_UNITARIATOTAL,0)), 2)) as totalUnidades, " +
                    " (CASE sd.COD_OFERTA  When 0 Then isnull(sum(((isnull(sd.cantidad, 0) +(isnull(" +
                    " sd.cantidad_unitaria, 0) / pp.cantidad_presentacion)) * sd.precio_lista *((100 - sd.porcentaje_aplicadoprecio) / 100) *((100" +
                    "  - isnull(s.PORCENTAJE_DESCUENTO_PREFERENCIAL, 0)) / 100) *((100 - s.porcentaje_descuento) / 100)  * ((100-s.DESCUENTO_FIDELIDAD)/100) * " +
                    " ((100-(s.DESCUENTO_CONTADO))/100) * ((100-s.DESCUENTO_PREFERENCIAL)/100) -(isnull(PART_CHEQUE, 0) * isnull(sd.MONTO_CHEQUE, 0))    )), 0)" +
                    "   ELSE isnull(sum(((isnull(sd.cantidad, 0) +(isnull( sd.cantidad_unitaria, 0) / pp.cantidad_presentacion)) *" +
                    "  sd.precio_lista *((100 - sd.porcentaje_aplicadoprecio) / 100)  * ((100-s.DESCUENTO_FIDELIDAD)/100) * ((100-(s.DESCUENTO_CONTADO))/100) * ((100-s.DESCUENTO_PREFERENCIAL)/100) -(isnull(PART_CHEQUE, 0) " +
                    " * isnull(sd.MONTO_CHEQUE, 0))  ) ), 0)  END) as montoVenta " +
                    " from SALIDAS_VENTAS s,SALIDAS_DETALLEVENTAS sd,ALMACENES_VENTAS av,PRESENTACIONES_PRODUCTO pp,clientes cl " +
                    " where s.COD_SALIDAVENTA = sd.COD_SALIDAVENTAS and s.cod_area_empresa=sd.cod_area_empresa and s.COD_ALMACEN_VENTA = av.COD_ALMACEN_VENTA " +
                    " and pp.cod_presentacion = sd.COD_PRESENTACION and s.COD_CLIENTE = cl.cod_cliente " +
                    " and av.COD_AREA_EMPRESA in(" + codArea+ ") and cl.cod_tipocliente in ("+tipoCliente+") " +
                    " and s.FECHA_SALIDAVENTA>='" + fechaIni + " 00:00:00' and s.FECHA_SALIDAVENTA<='" + fechaFin + " 23:59:59' " +
                    " and s.cod_cliente in (select c.cod_cliente from clientes c where c.cod_area_empresa="+codArea+") " +
                    " and pp.cod_lineamkt in ("+codLineas+") ";
            sqlConsulta=sqlConsulta + " and s.COD_ESTADO_SALIDAVENTA<>2 and s.COD_TIPOSALIDAVENTAS=3 group by sd.cod_oferta";
            System.out.println("SQL CONSULTA: "+sqlConsulta);
            Statement stConsulta=con.createStatement();
            ResultSet rsConsulta=stConsulta.executeQuery(sqlConsulta);
            while (rsConsulta.next()) {
                montoVenta=montoVenta+rsConsulta.getDouble(2);
            }
        }catch(Exception e){
            e.printStackTrace();
        }
        return(montoVenta);
    }
    
    //ACT POLITICA NUEVA SIN CHEQUE
    public double montoVentaRegionalGeneralSChk(Connection con, int codArea, String fechaIni, String fechaFin, String codLineas, String tipoCliente){
        double montoVenta=0;
        //si venta corriente es 1 escogemos solo lineas presupuestadas
        try{
            String sqlConsulta = "select sum(ROUND(((sd.CANTIDAD_TOTAL*pp.cantidad_presentacion) + isnull(sd.CANTIDAD_UNITARIATOTAL,0)), 2)) as totalUnidades, " +
                    " (CASE sd.COD_OFERTA  When 0 Then isnull(sum(((isnull(sd.cantidad, 0) +(isnull(" +
                    " sd.cantidad_unitaria, 0) / pp.cantidad_presentacion)) * sd.precio_lista *((100 - sd.porcentaje_aplicadoprecio) / 100) *((100" +
                    "  - isnull(s.PORCENTAJE_DESCUENTO_PREFERENCIAL, 0)) / 100) *((100 - s.porcentaje_descuento) / 100)  * ((100-s.DESCUENTO_FIDELIDAD)/100) * " +
                    " ((100-(s.DESCUENTO_CONTADO))/100) * ((100-s.DESCUENTO_PREFERENCIAL)/100) -(isnull(PART_CHEQUE, 0) * isnull(sd.MONTO_CHEQUE, 0))    )), 0)" +
                    "   ELSE isnull(sum(((isnull(sd.cantidad, 0) +(isnull( sd.cantidad_unitaria, 0) / pp.cantidad_presentacion)) *" +
                    "  sd.precio_lista *((100 - sd.porcentaje_aplicadoprecio) / 100)  * ((100-s.DESCUENTO_FIDELIDAD)/100) * ((100-(s.DESCUENTO_CONTADO))/100) * ((100-s.DESCUENTO_PREFERENCIAL)/100)  " +
                    "  ) ), 0)  END) as montoVenta " +
                    " from SALIDAS_VENTAS s,SALIDAS_DETALLEVENTAS sd,ALMACENES_VENTAS av,PRESENTACIONES_PRODUCTO pp,clientes cl " +
                    " where s.COD_SALIDAVENTA = sd.COD_SALIDAVENTAS and s.cod_area_empresa=sd.cod_area_empresa and s.COD_ALMACEN_VENTA = av.COD_ALMACEN_VENTA " +
                    " and pp.cod_presentacion = sd.COD_PRESENTACION and s.COD_CLIENTE = cl.cod_cliente " +
                    " and av.COD_AREA_EMPRESA in(" + codArea+ ") and cl.cod_tipocliente in ("+tipoCliente+") " +
                    " and s.FECHA_SALIDAVENTA>='" + fechaIni + " 00:00:00' and s.FECHA_SALIDAVENTA<='" + fechaFin + " 23:59:59' " +
                    " and s.cod_cliente in (select c.cod_cliente from clientes c where c.cod_area_empresa="+codArea+") " +
                    " and pp.cod_lineamkt in ("+codLineas+") ";
            sqlConsulta=sqlConsulta + " and s.COD_ESTADO_SALIDAVENTA<>2 and s.COD_TIPOSALIDAVENTAS=3 group by sd.cod_oferta";
            System.out.println("SQL CONSULTA: "+sqlConsulta);
            Statement stConsulta=con.createStatement();
            ResultSet rsConsulta=stConsulta.executeQuery(sqlConsulta);
            while (rsConsulta.next()) {
                montoVenta=montoVenta+rsConsulta.getDouble(2);
            }
        }catch(Exception e){
            e.printStackTrace();
        }
        return(montoVenta);
    }
    
    public int obtenerFeriado(Connection con, String fecha){
        int codFeriado=0;
        try {
            String sql="select * from FERIADOS f where f.FECHA_FERIADO='"+fecha+"' and f.FERIADO_NAL_SI_NO=1";
            Statement st=con.createStatement();
            ResultSet rs=st.executeQuery(sql);
            if(rs.next()){
                codFeriado=1;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return(codFeriado);
    }
    
    
    public double montoPresupuestoLinea(Connection con, int codArea, int codPeriodo, int codLinea, String codMeses){
        double montoPresupuesto=0;
        //si venta corriente es 1 escogemos solo lineas presupuestadas
        try{
            String sqlConsulta = "select sum(p.CANTIDAD_UNITARIA * p.PRECIO_MINIMO) " +
                    " from PRESUPUESTO_VENTASMENSUAL p where p.COD_PERIODO = "+codPeriodo+" and p.COD_MES in ("+codMeses+") ";
            if(codLinea!=0){
                sqlConsulta=sqlConsulta+" and p.COD_PRESENTACION in (select pp.cod_presentacion from PRESENTACIONES_PRODUCTO pp where pp.COD_LINEAMKT="+codLinea+") ";
            }
            sqlConsulta=sqlConsulta + " and p.COD_PRESUPUESTOVENTAS in (select p.COD_PRESUPUESTOVENTAS from PRESUPUESTO_VENTASGESTION p " +
                    " where p.COD_AREA_EMPRESA = "+codArea+" and p.COD_PERIODO = "+codPeriodo+")";
            
            System.out.println("SQL CONSULTA Presupuestos: "+sqlConsulta);
            Statement stConsulta=con.createStatement();
            ResultSet rsConsulta=stConsulta.executeQuery(sqlConsulta);
            while (rsConsulta.next()) {
                montoPresupuesto=montoPresupuesto+rsConsulta.getDouble(1);
            }
        }catch(Exception e){
            e.printStackTrace();
        }
        return(montoPresupuesto);
    }
    
    
    public double montoPresupuestoPeriodoLinea(Connection con, int codArea, String fechaIni, String fechaFin, String codLinea){
        double montoPresupuesto=0;
        try{
            String sqlConsulta = "select sum(pv.CANTIDAD_UNITARIA*pv.PRECIO_MINIMO) from PRESUPUESTO_VENTASMENSUAL pv, PERIODOS_DETALLEMESES pm, " +
                    " PERIODOS_VENTAS p, PRESUPUESTO_VENTASGESTION pg, PRESENTACIONES_PRODUCTO pp " +
                    " where p.COD_PERIODO=pm.COD_PERIODO and pm.COD_MESES=pv.COD_MES and pv.COD_PERIODO=p.COD_PERIODO and " +
                    " pm.FECHA_INICIO >= '"+fechaIni+" 00:00:00' and pm.FECHA_FINAL<='"+fechaFin+" 23:59:59' and pg.COD_PERIODO=p.COD_PERIODO and  " +
                    " pg.COD_AREA_EMPRESA="+codArea+" and pp.COD_LINEAMKT in ("+codLinea+") and pg.COD_PRESUPUESTOVENTAS=pv.COD_PRESUPUESTOVENTAS " +
                    " and pp.cod_presentacion=pv.COD_PRESENTACION";
            System.out.println("SQL PRESUPU LINEA: "+sqlConsulta);
            Statement stConsulta=con.createStatement();
            ResultSet rsConsulta=stConsulta.executeQuery(sqlConsulta);
            while (rsConsulta.next()) {
                montoPresupuesto=montoPresupuesto+rsConsulta.getDouble(1);
            }
        }catch(Exception e){
            e.printStackTrace();
        }
        return(montoPresupuesto);
    }
    
    
    public double montoPresupuestoPeriodoProducto(Connection con, int codArea, String fechaIni, String fechaFin, String codProducto){
        double montoPresupuesto=0;
        try{
            String sqlConsulta = "select sum(pv.CANTIDAD_UNITARIA*pv.PRECIO_MINIMO) from PRESUPUESTO_VENTASMENSUAL pv, PERIODOS_DETALLEMESES pm, " +
                    " PERIODOS_VENTAS p, PRESUPUESTO_VENTASGESTION pg, PRESENTACIONES_PRODUCTO pp " +
                    " where p.COD_PERIODO=pm.COD_PERIODO and pm.COD_MESES=pv.COD_MES and pv.COD_PERIODO=p.COD_PERIODO and " +
                    " pm.FECHA_INICIO >= '"+fechaIni+" 00:00:00' and pm.FECHA_FINAL<='"+fechaFin+" 23:59:59' and pg.COD_PERIODO=p.COD_PERIODO and  " +
                    " pg.COD_AREA_EMPRESA="+codArea+" and pp.cod_presentacion in ("+codProducto+") and pg.COD_PRESUPUESTOVENTAS=pv.COD_PRESUPUESTOVENTAS " +
                    " and pp.cod_presentacion=pv.COD_PRESENTACION";
            System.out.println("SQL PRESUPU PRODUCTO: "+sqlConsulta);
            Statement stConsulta=con.createStatement();
            ResultSet rsConsulta=stConsulta.executeQuery(sqlConsulta);
            while (rsConsulta.next()) {
                montoPresupuesto=montoPresupuesto+rsConsulta.getDouble(1);
            }
        }catch(Exception e){
            e.printStackTrace();
        }
        return(montoPresupuesto);
    }
    
    public double cantidadPresupuestoPeriodoProducto(Connection con, int codArea, String fechaIni, String fechaFin, String codProducto){
        double montoPresupuesto=0;
        try{
            String sqlConsulta = "select sum(pv.CANTIDAD_UNITARIA) from PRESUPUESTO_VENTASMENSUAL pv, PERIODOS_DETALLEMESES pm, " +
                    " PERIODOS_VENTAS p, PRESUPUESTO_VENTASGESTION pg, PRESENTACIONES_PRODUCTO pp " +
                    " where p.COD_PERIODO=pm.COD_PERIODO and pm.COD_MESES=pv.COD_MES and pv.COD_PERIODO=p.COD_PERIODO and " +
                    " pm.FECHA_INICIO >= '"+fechaIni+" 00:00:00' and pm.FECHA_FINAL<='"+fechaFin+" 23:59:59' and pg.COD_PERIODO=p.COD_PERIODO and  " +
                    " pg.COD_AREA_EMPRESA="+codArea+" and pp.cod_presentacion in ("+codProducto+") and pg.COD_PRESUPUESTOVENTAS=pv.COD_PRESUPUESTOVENTAS " +
                    " and pp.cod_presentacion=pv.COD_PRESENTACION";
            System.out.println("SQL PRESUPU PRODUCTO: "+sqlConsulta);
            Statement stConsulta=con.createStatement();
            ResultSet rsConsulta=stConsulta.executeQuery(sqlConsulta);
            while (rsConsulta.next()) {
                montoPresupuesto=montoPresupuesto+rsConsulta.getDouble(1);
            }
        }catch(Exception e){
            e.printStackTrace();
        }
        return(montoPresupuesto);
    }
    
    public String fechaCompraProd(Connection con, String codCliente, String codProducto, String fechaIni, String fechaFin){
        String fechaVenta="";
        try{
            String sqlConsulta="select top 1 convert(varchar, s.FECHA_SALIDAVENTA, 103) from SALIDAS_VENTAS s, SALIDAS_DETALLEVENTAS sd " +
                    " where s.COD_SALIDAVENTA=sd.COD_SALIDAVENTAS and s.COD_AREA_EMPRESA=sd.COD_AREA_EMPRESA and  " +
                    " s.COD_CLIENTE="+codCliente+" and s.FECHA_SALIDAVENTA BETWEEN '"+fechaIni+" 00:00:00' and '"+fechaFin+" 23:59:59' " +
                    " and s.COD_ESTADO_SALIDAVENTA<>2 and sd.COD_PRESENTACION in ("+codProducto+") and s.COD_TIPOSALIDAVENTAS=3 order by s.FECHA_SALIDAVENTA desc";
            System.out.println("SQL FECHA COMPRA: "+sqlConsulta);
            Statement stConsulta=con.createStatement();
            ResultSet rsConsulta=stConsulta.executeQuery(sqlConsulta);
            while (rsConsulta.next()) {
                fechaVenta=rsConsulta.getString(1);
            }
        }catch(Exception e){
            e.printStackTrace();
        }
        return(fechaVenta);
    }
    
    
    public double montoAgencia(Connection con, String codArea, String fechaIni, String fechaFin, String tipoVenta){
        double montoAgencia=0d;
        try {
            String sqlConsulta="select sum(s.MONTO_TOTAL) from SALIDAS_VENTAS s where s.COD_AREA_EMPRESA="+codArea+" and " +
                    " s.FECHA_SALIDAVENTA BETWEEN '"+fechaIni+" 00:00:00' and '"+fechaFin+" 23:59:59'  " +
                    " and s.COD_ESTADO_SALIDAVENTA<>2 and s.COD_TIPOVENTA in ("+tipoVenta+")";
            System.out.println("SQL MONTO AGENCIA: "+sqlConsulta);
            Statement stConsulta=con.createStatement();
            ResultSet rsConsulta=stConsulta.executeQuery(sqlConsulta);
            while (rsConsulta.next()) {
                montoAgencia=montoAgencia+rsConsulta.getDouble(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return montoAgencia;
    }
    
    public double montoCobranzaAgencia(Connection con, String codArea, String fechaIni, String fechaFin, String tipoVenta){
        double montoAgencia=0d;
        try {
            String sqlConsulta="select sum(cd.MONTO_COBRANZA) from cobranzas c, COBRANZAS_DETALLE cd, SALIDAS_VENTAS s " +
                    " where s.COD_SALIDAVENTA=cd.COD_SALIDAVENTA and s.COD_AREA_EMPRESA=cd.COD_AREA_EMPRESA and  " +
                    " c.COD_COBRANZA=cd.COD_COBRANZA and c.cod_area_empresa=cd.COD_AREA_EMPRESA " +
                    " and s.COD_TIPOVENTA in ("+tipoVenta+") and c.FECHA_COBRANZA BETWEEN '"+fechaIni+" 00:00:00' and '"+fechaFin+" 23:59:59' " +
                    " and c.COD_ESTADO_COBRANZA<>2 and c.cod_area_empresa in ("+codArea+") and cd.COD_TIPO_PAGO<>4";
            System.out.println("SQL MONTO AGENCIA: "+sqlConsulta);
            Statement stConsulta=con.createStatement();
            ResultSet rsConsulta=stConsulta.executeQuery(sqlConsulta);
            while (rsConsulta.next()) {
                montoAgencia=montoAgencia+rsConsulta.getDouble(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return montoAgencia;
    }
    
    
    public double montoVentaCampania(Connection con, String codArea, String codCampania){
        double montoVenta=0d;
        funcionesReportes obj=new funcionesReportes(1);
        try{
            String sql="select c.COD_CAMPANIA, CONVERT(varchar, c.FECHA_INICIO, 112)," +
                    " convert(varchar, c.FECHA_FINAL, 112) from campanias c where c.COD_CAMPANIA="+codCampania;
            Statement st=con.createStatement();
            ResultSet rs=st.executeQuery(sql);
            String fechaInicio="";
            String fechaFinal="";
            if(rs.next()){
                fechaInicio=rs.getString(2);
                fechaFinal=rs.getString(3);
            }
            String sqlLineasMkt="select cl.COD_LINEAMKT from CAMPANIAS_LINEAS cl where cl.COD_CAMPANIA="+codCampania;
            Statement stLineasMkt=con.createStatement();
            ResultSet rsLineasMkt=stLineasMkt.executeQuery(sqlLineasMkt);
            String codLineasMkt="0";
            while(rsLineasMkt.next()){
                codLineasMkt=codLineasMkt+","+rsLineasMkt.getString(1);
            }
            montoVenta=obj.montoVentaLinea(con, codArea, fechaInicio, fechaFinal, codLineasMkt, "0");
        }catch (Exception e){
            e.printStackTrace();
        }
        return(montoVenta);
    }
    
    
    public double montoPremiosCampania(Connection con, String codArea, String codCampania){
        double montoPremio=0d;
        funcionesReportes obj=new funcionesReportes(1);
        try{
            String sql="select c.COD_MATPROMOCIONAL, count(c.COD_MATPROMOCIONAL) from CAMPANIAS_CLIENTE c, CAMPANIAS_CLIENTEPREMIOS cp " +
                    " where c.COD_CAMPANIASCLIENTE=cp.COD_CAMPANIASCLIENTE and c.COD_AREA_EMPRESA=cp.COD_AREA_EMPRESA " +
                    " and c.COD_CAMPANIA="+codCampania+" and c.COD_AREA_EMPRESA="+codArea+" and cp.COD_ESTADOCLIENTEPREMIO=4 group by c.COD_MATPROMOCIONAL";
            Statement st=con.createStatement();
            ResultSet rs=st.executeQuery(sql);
            while(rs.next()){
                int codPremio=rs.getInt(1);
                int cantidadPremio=rs.getInt(2);
                
                String sql1="select max(id.PRECIO_BRUTO) from INGRESOS_DETALLEMATPROMOCIONAL id, INGRESOS_MATPROMOCIONAL i " +
                        " where i.COD_INGRESO_MATPROMOCIONAL=id.COD_INGRESO_MATPROMOCIONAL and i.COD_AREA_EMPRESA=id.COD_AREA_EMPRESA " +
                        " and i.COD_ALMACEN_MATPROMOCIONAL=71 and id.COD_MATPROMOCIONAL="+codPremio+" and i.COD_TIPOINGRESOMATPROM=1 " +
                        " and i.COD_ESTADO_INGRESOMATPROMOCIONAL<>2";
                Statement st1=con.createStatement();
                ResultSet rs1=st1.executeQuery(sql1);
                double precioPremio=0d;
                if(rs1.next()){
                    precioPremio=rs1.getDouble(1);
                }
                
                montoPremio=montoPremio+(cantidadPremio*precioPremio);
                
            }
            
        }catch (Exception e){
            e.printStackTrace();
        }
        return(montoPremio);
    }
    
    public double montoPremiosCampaniaCliente(Connection con, String codArea, String codCampania, String codCliente){
        double montoPremio=0d;
        funcionesReportes obj=new funcionesReportes(1);
        try{
            String sql="select c.COD_MATPROMOCIONAL, count(c.COD_MATPROMOCIONAL) from CAMPANIAS_CLIENTE c, CAMPANIAS_CLIENTEPREMIOS cp " +
                    " where c.COD_CAMPANIASCLIENTE=cp.COD_CAMPANIASCLIENTE and c.COD_AREA_EMPRESA=cp.COD_AREA_EMPRESA and cp.cod_cliente="+codCliente+"" +
                    " and c.COD_CAMPANIA="+codCampania+" and c.COD_AREA_EMPRESA="+codArea+" and cp.COD_ESTADOCLIENTEPREMIO=4 group by c.COD_MATPROMOCIONAL";
            Statement st=con.createStatement();
            ResultSet rs=st.executeQuery(sql);
            while(rs.next()){
                int codPremio=rs.getInt(1);
                int cantidadPremio=rs.getInt(2);
                
                String sql1="select max(id.PRECIO_BRUTO) from INGRESOS_DETALLEMATPROMOCIONAL id, INGRESOS_MATPROMOCIONAL i " +
                        " where i.COD_INGRESO_MATPROMOCIONAL=id.COD_INGRESO_MATPROMOCIONAL and i.COD_AREA_EMPRESA=id.COD_AREA_EMPRESA " +
                        " and i.COD_ALMACEN_MATPROMOCIONAL=71 and id.COD_MATPROMOCIONAL="+codPremio+" and i.COD_TIPOINGRESOMATPROM=1 " +
                        " and i.COD_ESTADO_INGRESOMATPROMOCIONAL<>2";
                Statement st1=con.createStatement();
                ResultSet rs1=st1.executeQuery(sql1);
                double precioPremio=0d;
                if(rs1.next()){
                    precioPremio=rs1.getDouble(1);
                }
                
                montoPremio=montoPremio+(cantidadPremio*precioPremio);
                
            }
            
        }catch (Exception e){
            e.printStackTrace();
        }
        return(montoPremio);
    }
    
    public String fechaCambioEstadoPagado(Connection con, String codArea, String codCliente, String codPremio){
        String fechaCambioPagado="";
        
        try{
            String sqlPunto="select c.CANTIDAD_PREMIO, cc.COD_MATPROMOCIONAL, cc.NOMBRE_CAMPANIA from CAMPANIAS_PREMIOS c, " +
                    " campanias cc where c.COD_MATPROMOCIONAL="+codPremio+" and cc.COD_CAMPANIA=c.COD_CAMPANIA";
            Statement stPunto=con.createStatement();
            ResultSet rsPunto=stPunto.executeQuery(sqlPunto);
            int codPunto=0;
            int cantidadPuntos=0;
            if(rsPunto.next()){
                codPunto=rsPunto.getInt(2);
                cantidadPuntos=rsPunto.getInt(1);
            }
            System.out.println("PUNTOS: "+codPunto);
            
            String sqlFac="select s.COD_SALIDAVENTA, s.FECHA_SALIDA_MATPROMOCIONAL, sum(sd.CANTIDAD_SALIDA_MATPROMOCIONAL), " +
                    " sv.MONTO_TOTAL from SALIDAS_MATPROMOCIONAL s, SALIDAS_DETALLEMATERIALPROMOCIONAL sd, SALIDAS_VENTAS sv " +
                    " where s.COD_SALIDA_MATPROMOCIONAL=sd.COD_SALIDA_MATPROMOCIONAL and  " +
                    " s.COD_AREA_EMPRESA=sd.COD_AREA_EMPRESA and s.COD_CLIENTE="+codCliente+" and  s.COD_ESTADO_SALIDAMATPROMOCIONAL<>2 and " +
                    " sd.COD_MATPROMOCIONAL="+codPunto+" and s.COD_SALIDAVENTA=sv.COD_SALIDAVENTA and s.COD_AREA_EMPRESA=sv.COD_AREA_EMPRESA " +
                    " group by s.COD_SALIDAVENTA, s.FECHA_SALIDA_MATPROMOCIONAL, sv.MONTO_TOTAL order by s.FECHA_SALIDA_MATPROMOCIONAL";
            System.out.println("SQL FAC "+sqlFac);
            Statement stFac=con.createStatement();
            ResultSet rsFac=stFac.executeQuery(sqlFac);
            
            int puntosPagados=0;
            int bandera=0;
            while(rsFac.next() && bandera==0){
                String codVenta=rsFac.getString(1);
                String fechaVenta=rsFac.getString(2);
                int cantidadPuntosAcum=rsFac.getInt(3);
                double montoVenta=rsFac.getDouble(4);
                System.out.println("fecha: "+fechaVenta+" puntos: "+cantidadPuntosAcum+" monto venta: "+montoVenta);
                
                String sqlCobro="select sum(cd.MONTO_COBRANZA), convert(varchar, c.FECHA_COBRANZA,103) from COBRANZAS_DETALLE cd, cobranzas c " +
                        " where c.COD_COBRANZA=cd.COD_COBRANZA and c.cod_area_empresa=cd.COD_AREA_EMPRESA   " +
                        " and cd.COD_SALIDAVENTA="+codVenta+" and c.cod_area_empresa="+codArea+" group by c.FECHA_COBRANZA";
                Statement stCobro=con.createStatement();
                ResultSet rsCobro=stCobro.executeQuery(sqlCobro);
                double montoCobro=0d;
                String fechaCobro="";
                if(rsCobro.next()){
                    montoCobro=rsCobro.getDouble(1);
                    fechaCobro=rsCobro.getString(2);
                }
                
                if( (montoCobro-montoVenta)<=1 || (montoCobro-montoVenta)>-1 ){
                    puntosPagados=puntosPagados+cantidadPuntosAcum;
                }
                
                if(puntosPagados>=cantidadPuntos){
                    bandera=1;
                    fechaCambioPagado=fechaCobro;
                    System.out.println("FECHA COBRO "+fechaCambioPagado);
                }
            }
        }catch (Exception e){
            e.printStackTrace();
        }
        return(fechaCambioPagado);
    }
    
    
    public double cuentasPorCobrar(Connection con, String codArea, String fecha, String tipoVenta){
        double venta=0d;
        double cobranza=0d;
        double montoCxC=0d;
        try{
            String sqlConsulta="select sv.monto_total, sv.monto_cancelado, (select ISNULL(sum(monto_cobranza), 0) as total_cobranza " +
                    " from cobranzas_detalle cd, cobranzas c where cd.cod_cobranza = c.cod_cobranza and cd.cod_area_empresa = c.cod_area_empresa and " +
                    " cd.cod_area_empresa = "+codArea+" and c.fecha_cobranza <= '"+fecha+" 23:59:59' and sv.COD_TIPODOC_VENTA in (2, 1, 3) and " +
                    " cd.cod_salidaventa = sv.cod_salidaventa and c.cod_estado_cobranza <> 2) as total_cobranza " +
                    " from salidas_ventas sv, tipo_documentos_ventas tdv, estados_salida_ventas esv, almacenes_ventas av, areas_empresa ae " +
                    " where monto_total > (select ISNULL(sum(monto_cobranza), 0) + 1 from cobranzas_detalle cd, cobranzas c " +
                    " where cd.cod_cobranza = c.cod_cobranza and cd.cod_area_empresa = c.cod_area_empresa and " +
                    " cd.cod_area_empresa = "+codArea+" and c.fecha_cobranza <= '"+fecha+" 23:59:59' and cd.cod_salidaventa = sv.cod_salidaventa and " +
                    " c.cod_estado_cobranza <> 2) and sv.cod_tipodoc_venta = tdv.cod_tipodoc_venta and " +
                    " sv.COD_TIPODOC_VENTA in (2, 1, 3) and sv.cod_estado_salidaventa = esv.cod_estado_salidaventa and " +
                    " sv.cod_estado_salidaventa <> 2 and sv.fecha_salidaventa <= '"+fecha+" 23:59:59' and sv.cod_almacen_venta = av.cod_almacen_venta and " +
                    " av.cod_area_empresa = '"+codArea+"' and av.cod_area_empresa = ae.cod_area_empresa and sv.monto_total > (select ISNULL(sum(monto_cobranza), 0) as total_cobranza " +
                    " from cobranzas_detalle cd, cobranzas c where cd.cod_cobranza = c.cod_cobranza and cd.cod_area_empresa = c.cod_area_empresa and " +
                    " cd.cod_area_empresa in ("+codArea+") and c.fecha_cobranza <= '"+fecha+" 23:59:59' and " +
                    " cd.cod_salidaventa = sv.cod_salidaventa and c.cod_estado_cobranza <> 2) and sv.cod_tipoventa in ("+tipoVenta+") and " +
                    " sv.cod_area_empresa in ("+codArea+")";
            System.out.println("SQL CXC: "+sqlConsulta);
            Statement stConsulta=con.createStatement();
            ResultSet rsConsulta=stConsulta.executeQuery(sqlConsulta);
            while (rsConsulta.next()) {
                venta=venta+rsConsulta.getDouble(1);
                cobranza=cobranza+rsConsulta.getDouble(3);
            }
            montoCxC=venta-cobranza;
        }catch (Exception e){
            e.printStackTrace();
        }
        return(montoCxC);
    }
    
    
    
    public double cuentasPorCobrarTipoCliente(Connection con, String codArea, String fecha, String tipoVenta, String tipoCliente){
        double venta=0d;
        double cobranza=0d;
        double montoCxC=0d;
        try{
            String sqlConsulta="select sv.monto_total, sv.monto_cancelado, (select ISNULL(sum(monto_cobranza), 0) as total_cobranza " +
                    " from cobranzas_detalle cd, cobranzas c where cd.cod_cobranza = c.cod_cobranza and cd.cod_area_empresa = c.cod_area_empresa and " +
                    " cd.cod_area_empresa = "+codArea+" and c.fecha_cobranza <= '"+fecha+" 23:59:59' and sv.COD_TIPODOC_VENTA in (2, 1, 3) and " +
                    " cd.cod_salidaventa = sv.cod_salidaventa and c.cod_estado_cobranza <> 2) as total_cobranza " +
                    " from salidas_ventas sv, tipo_documentos_ventas tdv, estados_salida_ventas esv, almacenes_ventas av, areas_empresa ae, clientes cli " +
                    " where monto_total > (select ISNULL(sum(monto_cobranza), 0) + 1 from cobranzas_detalle cd, cobranzas c " +
                    " where cd.cod_cobranza = c.cod_cobranza and cd.cod_area_empresa = c.cod_area_empresa and " +
                    " cd.cod_area_empresa = "+codArea+" and c.fecha_cobranza <= '"+fecha+" 23:59:59' and cd.cod_salidaventa = sv.cod_salidaventa and " +
                    " c.cod_estado_cobranza <> 2) and sv.cod_tipodoc_venta = tdv.cod_tipodoc_venta and " +
                    " sv.COD_TIPODOC_VENTA in (2, 1, 3) and sv.cod_estado_salidaventa = esv.cod_estado_salidaventa and " +
                    " sv.cod_estado_salidaventa <> 2 and sv.fecha_salidaventa <= '"+fecha+" 23:59:59' and sv.cod_almacen_venta = av.cod_almacen_venta and " +
                    " av.cod_area_empresa = '"+codArea+"' and av.cod_area_empresa = ae.cod_area_empresa and sv.monto_total > (select ISNULL(sum(monto_cobranza), 0) as total_cobranza " +
                    " from cobranzas_detalle cd, cobranzas c where cd.cod_cobranza = c.cod_cobranza and cd.cod_area_empresa = c.cod_area_empresa and " +
                    " cd.cod_area_empresa in ("+codArea+") and c.fecha_cobranza <= '"+fecha+" 23:59:59' and " +
                    " cd.cod_salidaventa = sv.cod_salidaventa and c.cod_estado_cobranza <> 2) and sv.cod_tipoventa in ("+tipoVenta+") and " +
                    " sv.cod_area_empresa in ("+codArea+") and sv.COD_CLIENTE=cli.cod_cliente and sv.COD_AREA_EMPRESA=cli.cod_area_empresa " +
                    " and cli.cod_tipocliente in ("+tipoCliente+")";
            System.out.println("SQL CXC: "+sqlConsulta);
            Statement stConsulta=con.createStatement();
            ResultSet rsConsulta=stConsulta.executeQuery(sqlConsulta);
            while (rsConsulta.next()) {
                venta=venta+rsConsulta.getDouble(1);
                cobranza=cobranza+rsConsulta.getDouble(3);
            }
            montoCxC=venta-cobranza;
        }catch (Exception e){
            e.printStackTrace();
        }
        return(montoCxC);
    }
    
    
    public Object[] cuentasPorCobrarVariosClientes(Connection con, String codArea, String fecha, String codClientes){
        double venta=0d;
        double cobranza=0d;
        double montoCxC=0d;
        String fechaVenta="";
        String codigoCliente="";
        int diasMoraMaximo=0;
        double montoMora=0;
        Object[] dataCC=new Object[3];
        
        try{
            String sqlConsulta="select convert(varchar, sv.FECHA_SALIDAVENTA, 103), sv.monto_total, sv.monto_cancelado, (select ISNULL(sum(monto_cobranza), 0) as total_cobranza " +
                    " from cobranzas_detalle cd, cobranzas c where cd.cod_cobranza = c.cod_cobranza and cd.cod_area_empresa = c.cod_area_empresa and " +
                    " cd.cod_area_empresa = "+codArea+" and c.fecha_cobranza <= '"+fecha+" 23:59:59' and sv.COD_TIPODOC_VENTA in (2, 1, 3) and " +
                    " cd.cod_salidaventa = sv.cod_salidaventa and c.cod_estado_cobranza <> 2) as total_cobranza,  sv.cod_cliente " +
                    " from salidas_ventas sv, tipo_documentos_ventas tdv, estados_salida_ventas esv, almacenes_ventas av, areas_empresa ae, clientes cli " +
                    " where monto_total > (select ISNULL(sum(monto_cobranza), 0) + 1 from cobranzas_detalle cd, cobranzas c " +
                    " where cd.cod_cobranza = c.cod_cobranza and cd.cod_area_empresa = c.cod_area_empresa and " +
                    " cd.cod_area_empresa = "+codArea+" and c.fecha_cobranza <= '"+fecha+" 23:59:59' and cd.cod_salidaventa = sv.cod_salidaventa and " +
                    " c.cod_estado_cobranza <> 2) and sv.cod_tipodoc_venta = tdv.cod_tipodoc_venta and " +
                    " sv.cod_estado_salidaventa = esv.cod_estado_salidaventa and " +
                    " sv.cod_estado_salidaventa <> 2 and sv.fecha_salidaventa <= '"+fecha+" 23:59:59' and sv.cod_almacen_venta = av.cod_almacen_venta and " +
                    " av.cod_area_empresa = '"+codArea+"' and av.cod_area_empresa = ae.cod_area_empresa and sv.monto_total > (select ISNULL(sum(monto_cobranza), 0) as total_cobranza " +
                    " from cobranzas_detalle cd, cobranzas c where cd.cod_cobranza = c.cod_cobranza and cd.cod_area_empresa = c.cod_area_empresa and " +
                    " cd.cod_area_empresa in ("+codArea+") and c.fecha_cobranza <= '"+fecha+" 23:59:59' and " +
                    " cd.cod_salidaventa = sv.cod_salidaventa and c.cod_estado_cobranza <> 2) and " +
                    " sv.cod_area_empresa in ("+codArea+") and sv.COD_CLIENTE=cli.cod_cliente and sv.COD_AREA_EMPRESA=cli.cod_area_empresa " +
                    " and cli.cod_cliente in ("+codClientes+")";
            //System.out.println("SQL CXC: "+sqlConsulta);
            Statement stConsulta=con.createStatement();
            ResultSet rsConsulta=stConsulta.executeQuery(sqlConsulta);
            while (rsConsulta.next()) {
                fechaVenta=rsConsulta.getString(1);
                venta=venta+rsConsulta.getDouble(2);
                cobranza=cobranza+rsConsulta.getDouble(4);
                codigoCliente=rsConsulta.getString(5);
                
                
                //verificamos moras
                //System.out.println("FECHAVENTA: "+fechaVenta);
                String [] vectorFechaJoda = fechaVenta.split("/");
                DateTime dt = new DateTime(Integer.parseInt(vectorFechaJoda[2]), Integer.parseInt(vectorFechaJoda[1]), Integer.parseInt(vectorFechaJoda[0]), 12, 0, 0, 0);
                
                int diasMorosos=0;
                //sacamos los dias que tienen de mora
                String sqlMora="select dias_optimo from dias_credito where cod_area_empresa="+codArea;
                Statement stMora=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rsMora=stMora.executeQuery(sqlMora);
                while(rsMora.next()){
                    diasMorosos=rsMora.getInt("dias_optimo");
                }
                
                //sacamos los dias adicionales del cliente
                int diasAdicionalesCliente=0;
                String sqlDiasCliente="select c.cantidad_diascreditoespecial from clientes c " +
                        " where c.cod_estadoespecialcreditocliente = 1 and c.cod_cliente="+codigoCliente;
                Statement stDiasCliente=con.createStatement();
                ResultSet rsDiasCliente=stDiasCliente.executeQuery(sqlDiasCliente);
                if(rsDiasCliente.next()){
                    diasAdicionalesCliente=rsDiasCliente.getInt(1);
                }
                
                
                //DateTime dtActual=new DateTime();
                //String [] vectorFechaJoda2 = vectorFecha.split("/");
                String [] vectorFecha = fecha.split("-");
                DateTime dtActual = new DateTime(Integer.parseInt(vectorFecha[0]), Integer.parseInt(vectorFecha[1]), Integer.parseInt(vectorFecha[2]), 12, 0, 0, 0);
                
                Days dias = Days.daysBetween(dt, dtActual);
                int diasMoraDocumento=dias.getDays();
                
                //DIAS MOROSOS SON LOS DIAS QUE TIENE EL CLIENTE
                diasMorosos=diasMorosos+diasAdicionalesCliente;
                DateTime dtVigencia=dt.plusDays(diasMorosos);
                //System.out.println("FECHA VIGENCIA: "+diasMorosos +" DIAS 2: "+diasMoraDocumento);
                
                int diasVigenciaDocumento=diasMorosos-diasMoraDocumento;
                
                
                if(diasVigenciaDocumento<0){
                    System.out.println("MORA***");
                    if(diasMoraMaximo>diasVigenciaDocumento){
                        diasMoraMaximo=diasVigenciaDocumento;
                    }  
                    montoMora=montoMora+(rsConsulta.getDouble(2)-rsConsulta.getDouble(4));
                } 
                //FIN VERIFICAR MORA
            }
            montoCxC=venta-cobranza;
            //System.out.println("MAXIMO DIAS MORA: "+diasMoraMaximo);
            //System.out.println("MONTO MAXIMO MORA: "+ montoMora);
            
            dataCC[0]=diasMoraMaximo;
            dataCC[1]=montoMora;
            dataCC[2]=montoCxC;
        }catch (Exception e){
            e.printStackTrace();
        }        
        
        return(dataCC);
    }
    
    
    public double montoEjecucionEvento(Connection con, String codApoyo){
        double montoEjecucion=0d;
        String codOrden="0";
        
        try{
            String sql="select oc.COD_ORDEN_COMPRA from APOYO_EVENTOS a, COTIZACIONES cot, ORDENES_COMPRA oc " +
                    " where a.COD_SOLICITUD_COMPRA=cot.COD_SOLICITUD_COMPRA and oc.COD_COTIZACION=cot.COD_COTIZACION and " +
                    " a.COD_APOYO_EVENTO="+codApoyo;
            Statement st=con.createStatement();
            ResultSet rs=st.executeQuery(sql);
            
            if(rs.next()){
                codOrden=rs.getString(1);
            }
            
            String sql1="select sum(cd.DEBE) from COMPROBANTE c, COMPROBANTE_DETALLE cd where c.COD_COMPROBANTE=cd.COD_COMPROBANTE " +
                    " and cd.COD_ORDEN_COMPRA in ("+codOrden+") and c.COD_TIPO_COMPROBANTE in (1,4) and c.COD_ESTADO_COMPROBANTE=1";
            
            System.out.println("SQL COMPROB OC: "+sql1);
            Statement st1=con.createStatement();
            ResultSet rs1=st1.executeQuery(sql1);
            if(rs1.next()){
                montoEjecucion=rs1.getDouble(1);
            }
        }catch (Exception e){
            e.printStackTrace();
        }
        
        if(codOrden.equals("0")){
            montoEjecucion=0;
        }
        return(montoEjecucion);
    }
    
    public double[] valorObjetivosCheque(Connection con, String fechaIni, String fechaFin, String codProductos, String tipoPrecio, String codCliente){
        // 1 es precio lista 2 precio corriente
        //descomponemos los productos
        System.out.println("VALOR CHEQUES!!!");
        double vectorDatos[]= new double[2];
        try {
            
            funcionesReportes obj=new funcionesReportes(1);
            String productos[]=codProductos.split(",");
            double sumaUnidades=0d;
            double sumaMontos=0d;
            for(int i=0; i<productos.length; i++){
                String codigoProducto=productos[i];
                double unidadesVendidas=obj.cantidadVentaProductoCliente(con, fechaIni, fechaFin, codigoProducto, codCliente,1);
                sumaUnidades=sumaUnidades+unidadesVendidas;
                
                //sacamos el precio
                String sqlPrecio="select (pd.PRECIO_LISTA*pp.cantidad_presentacion), (pd.PRECIO_VENTACORRIENTE*pp.cantidad_presentacion) from PRESENTACIONES_PRECIOS p, PRESENTACIONES_PRECIOSDETALLE pd, presentaciones_producto pp " +
                        " where p.COD_PRESENTACIONES_PRECIOS=pd.COD_PRESENTACIONES_PRECIOS and pp.cod_presentacion=pd.cod_presentacion and " +
                        " p.COD_ESTADO_REGISTRO=4 and pd.COD_PRESENTACION="+codigoProducto+" and p.COD_AREA_EMPRESA=46";
                Statement stPrecio=con.createStatement();
                ResultSet rsPrecio=stPrecio.executeQuery(sqlPrecio);
                double precioOficial=0d;
                if(rsPrecio.next()){
                    double precioLista=rsPrecio.getDouble(1);
                    double precioVentaCo=rsPrecio.getDouble(2);
                    if(tipoPrecio.equals("1")){
                        precioOficial=precioLista;
                    }else{
                        precioOficial=precioVentaCo;
                    }
                }
                double montoVentaProducto=unidadesVendidas*precioOficial;
                sumaMontos=sumaMontos+montoVentaProducto;
            }
            vectorDatos[0]=sumaUnidades;
            vectorDatos[1]=sumaMontos;
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return vectorDatos;
    }
}
