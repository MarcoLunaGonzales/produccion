package com.cofar.web;

/**
 *
 * @author Guery Garcia Jaldin
 * 08/09/2010
 * @company COFAR
 */

import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.util.Iterator;
import java.util.Locale;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import javax.faces.model.SelectItem;
import com.cofar.bean.AccionesMateriales;
import com.cofar.bean.OrdenSolicitudMantenimiento;
import com.cofar.bean.SolicitudMantenimiento;
import com.cofar.util.Util;

public class ManagedSolMantenimiento {
    
    private Connection con;
    private OrdenSolicitudMantenimiento OrdenSolicitudMantenimientobean=new OrdenSolicitudMantenimiento();    
    private List<SolicitudMantenimiento> solicitudMantenimientoList=new ArrayList<SolicitudMantenimiento>();
    private List<OrdenSolicitudMantenimiento> OrdenSolicitudMantenimientoList = new ArrayList<OrdenSolicitudMantenimiento>();
    private List estadosOrdenMantenimientoList = new ArrayList();
    private List accionesMateriales=new ArrayList();
    private List estadoMateriales=new ArrayList();
    private List pedidoMaterialesList=new ArrayList();
    private List pedidoMaterialesAuxList=new ArrayList();
    private List salidaMaterialesList = new ArrayList();
    
    private AccionesMateriales accionesMaterialesbean=new AccionesMateriales();
    
    public ManagedSolMantenimiento() {
    }
   
    public String Estados1(){
        String NombreEstadoSolicitud = "";
        
        try{
            setCon(Util.openConnection(getCon())); 
            // 1 ) Si tengo orden de compra voy a estado solicitud compra 
            String sqlSOC = "SELECT esc.NOMBRE_ESTADO_SOLICITUD_COMPRA ";                   
                   sqlSOC +="FROM SOLICITUDES_COMPRA sc, ";
                   sqlSOC +="ESTADOS_SOLICITUD_COMPRA esc ";
                   sqlSOC +="WHERE (sc.COD_ESTADO_SOLICITUD_COMPRA = esc.COD_ESTADO_SOLICITUD_COMPRA )AND ";     
                   sqlSOC +="sc.COD_ESTADO_SOLICITUD_COMPRA = " + accionesMaterialesbean.getCodSolicitudCompra();
            System.out.println("SI TENGO ORDEN DE COMPRA -----------> " + sqlSOC);
            Statement stmtSOC = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rsSOC = stmtSOC.executeQuery(sqlSOC);
            
            if(rsSOC.next()){
                NombreEstadoSolicitud = rsSOC.getString(1);
            }      
            
            // 2 A)   Si tengo orden de compra verifico en cotizacion Si no tengo cotizacion me voy a estado cotizacion
            String sqlSNOC = "SELECT ec.NOMBRE_ESTADO_COTIZACION ";
                   sqlSNOC +="FROM SOLICITUDES_COMPRA sc, ";
                   sqlSNOC +="COTIZACIONES c ,";
                   sqlSNOC +="ESTADOS_COTIZACION ec ";
                   sqlSNOC +="WHERE sc.COD_SOLICITUD_COMPRA = c.COD_SOLICITUD_COMPRA AND ";        
                   sqlSNOC +="c.COD_ESTADO_COTIZACION = ec.COD_ESTADO_COTIZACION  AND ";
                   sqlSNOC +="sc.COD_SOLICITUD_COMPRA = " + accionesMaterialesbean.getCodSolicitudCompra();
            System.out.println("SI NO TENGO COTIZACION-------------> " + sqlSNOC );       
            Statement stmtSNOC = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rsSNOC = stmtSNOC.executeQuery(sqlSNOC);
            
            if(rsSNOC.next()){
                NombreEstadoSolicitud = rsSNOC.getString(1);
            }
           
            // 2 B)   Si tengo orden de compra verifico en cotizacion Si tengo cotizacion me voy a ordenes_compra si tengo ordenes_compra me voy estado_compra 
            String sqlSSOC = "SELECT a.NOMBRE_ESTADO_COMPRA ";
                   sqlSSOC += "FROM SOLICITUDES_COMPRA sc, ";
                   sqlSSOC += "COTIZACIONES c, ";
                   sqlSSOC += "ORDENES_COMPRA oc, ";
                   sqlSSOC += "ESTADOS_COMPRA a "; 
                   sqlSSOC += "WHERE sc.COD_SOLICITUD_COMPRA = c.COD_SOLICITUD_COMPRA AND ";
                   sqlSSOC += "c.COD_COTIZACION = oc.COD_ORDEN_COMPRA AND ";
                   sqlSSOC += "oc.COD_ESTADO_COMPRA = a.COD_ESTADO_COMPRA AND ";                   
                   sqlSSOC += "sc.COD_SOLICITUD_COMPRA = " + accionesMaterialesbean.getCodSolicitudCompra();
            System.out.println("SI TENGO COTIZACION-------------> " + sqlSSOC );
            Statement stmtSSOC = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rsSSOC = stmtSSOC.executeQuery(sqlSSOC);
            
            if(rsSSOC.next()){
               NombreEstadoSolicitud = rsSSOC.getString(1);
            }
         
        

        }catch(SQLException e){
            e.printStackTrace();
        }
        return NombreEstadoSolicitud;
    }
   
    public String ordenSalidaMantenimiento(){
        try{
            //hago la  insercion en las tablas
            //Solicitud_Salida   y   Solicitud_Salida_Detalles
            int codFromCompra = 0;
            SimpleDateFormat df=new SimpleDateFormat("yyyy/MM/dd");
            
            setCon(Util.openConnection(getCon()));
            Iterator index = pedidoMaterialesList.iterator();
            String sql_s= "SELECT MAX(COD_FORM_SALIDA) FROM SOLICITUDES_SALIDA";
            System.out.println("SQL_SALIDA-------->" + sql_s);
            Statement stmt_s = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs_s = stmt_s.executeQuery(sql_s);
            System.out.println("tamaño----------------------->" + pedidoMaterialesList.size());
            if  (rs_s.next()) {
                codFromCompra = rs_s.getInt(1) + 1;
            }
            while (index.hasNext()){
                AccionesMateriales bean=(AccionesMateriales)index.next();
                String sql_sm=" select m.COD_UNIDAD_MEDIDA from MATERIALES m where m.COD_MATERIAL="+bean.getMaterialesBean().getCodMaterial();
                System.out.println("SQL_SALIDA_MATERIALES----------->"+sql_sm);
                
                Statement st_sm = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet rs_sm = st_sm.executeQuery(sql_sm);
                String codUnidadeMedida="0";
                if(rs_sm.next()){
                    codUnidadeMedida=rs_sm.getString(1);
                } 
                //CANTIDAD   CANTIDA_ENTREGADA
                accionesMaterialesbean.setFechaPedidoSolicitud(bean.getFechaPedidoSolicitud());
                String sqlSSD = "INSERT INTO SOLICITUDES_SALIDA_DETALLE (COD_FORM_SALIDA,COD_MATERIAL,CANTIDAD,CANTIDAD_ENTREGADA,COD_UNIDAD_MEDIDA)VALUES";
                sqlSSD +="('"+ codFromCompra +"', '"+ bean.getMaterialesBean().getCodMaterial()  +"','"+ bean.getCantidadSolicitada() +"',";
                sqlSSD +="'0','"+ codUnidadeMedida +"')";
                System.out.println("sql1_INSERTAR_SOLICITUDES_SALIDA_DETALLE------------------> :"+sqlSSD);
                Statement stSSD = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                int resultSSD = stSSD.executeUpdate(sqlSSD);
            }
          
            //Realizo la insercion de la cabecera
            String sql_00="select COD_PERSONAL,COD_AREA_EMPRESA from SOLICITUDES_MANTENIMIENTO  where COD_SOLICITUD_MANTENIMIENTO = " + accionesMaterialesbean.getCodSolicitudCompra();
            System.out.println("sqlXXXX.........:" + sql_00);
            Statement st_00 = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs_00 = st_00.executeQuery(sql_00);
            
            String codPersonalF = "0";
            String codAreaEmpresaF = "0";
            if(rs_00.next()){
                codPersonalF=rs_00.getString(1);
                codAreaEmpresaF=rs_00.getString(2);
            }
            
            Date date=new Date();
            String sqlg="select g.COD_GESTION from GESTIONES g where g.GESTION_ESTADO=1";
            System.out.println("SQL_GESTIONES--------------->:"+sqlg);
            Statement stg = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rsg=st_00.executeQuery(sqlg);
            String codGestion = "0";
            if(rsg.next()){
                codGestion=rsg.getString(1);
            }
            String sqls= "Select max(COD_FORM_SALIDA) from Solicitudes_Salida";
            System.out.println("SQL_SOLICITUD_SALIDA---------->  "+ sqls);
            Statement sts = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rss = sts.executeQuery(sqls);
            int Codfsalida = 0;
            if (rss.next()){
                Codfsalida = rss.getInt(1) + 1;
            }            
            String sqlP="select COD_PERSONAL,COD_AREA_EMPRESA from SOLICITUDES_MANTENIMIENTO  where COD_SOLICITUD_MANTENIMIENTO = " + accionesMaterialesbean.getCodSolicitudCompra();
            System.out.println("SQL_SOLICITUDES_MANTENIMIENTO----------------->" + sqlP);
            Statement stP = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rsP = stP.executeQuery(sqlP);
            
            String codPersonalFF="0";
            String codAreaEmpresaFF="0";
            if(rsP.next()){                
                codPersonalFF=rsP.getString(1);
                codAreaEmpresaFF=rsP.getString(2);
            }
            Date date1=new Date();
            String sqlSSS ="";
            sqlSSS = "INSERT INTO SOLICITUDES_SALIDA(COD_GESTION,COD_FORM_SALIDA,COD_TIPO_SALIDA_ALMACEN,COD_ESTADO_SOLICITUD_SALIDA_ALMACEN,";
            sqlSSS += "SOLICITANTE,AREA_DESTINO_SALIDA,FECHA_SOLICITUD,ESTADO_SISTEMA,CONTROL_CALIDAD";
            sqlSSS += ",COD_ALMACEN) VALUES (";
            sqlSSS += "'"+ codGestion +"' ";
            sqlSSS += ","+ Codfsalida +", ";
            sqlSSS += "'1', '1', '"+ codPersonalFF +"', '"+ codAreaEmpresaFF +"',";
            sqlSSS += " "+ df.format(date1) +"  ,'1' , '0', '1')";
            System.out.println("INSERTAR SQL---------->:" + sqlSSS);
            Statement stSSS = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            int resultSSS = stSSS.executeUpdate(sqlSSS);
        }catch(SQLException e){
            e.printStackTrace();
        }
        return "ordenSalidaMantenimiento";
    }  
    
    public String ordenCompraMantenimiento(){
        // hago la insercion en Cronos en las tablas
        // Solicitudes_Compra  y   Solicitud_Detalle
        try{
            int CodSolCompra = 0;
            setCon(Util.openConnection(getCon()));
            Iterator index=pedidoMaterialesList.iterator();
            SimpleDateFormat df=new SimpleDateFormat("yyyy/MM/dd");
            
            //saco el ultimo codigo de la tabla SOLICITUDES_COMPRA_DETALLE y le sumo 1
            String sql22 = "Select max(COD_SOLICITUD_COMPRA) FROM SOLICITUDES_COMPRA_DETALLE ";
            System.out.println("SQL_SQL_SQL_SQL------> "+ sql22);
            Statement stmt = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs2 = stmt.executeQuery(sql22);
            if (rs2.next()){
                CodSolCompra = rs2.getInt(1) + 1;
            }
            
            while (index.hasNext()){
                AccionesMateriales bean=(AccionesMateriales)index.next();
                String sql_01=" select m.COD_UNIDAD_MEDIDA from MATERIALES m where m.COD_MATERIAL="+bean.getMaterialesBean().getCodMaterial();
                Statement st_01 = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet rs_01=st_01.executeQuery(sql_01);
                String codUnidadeMedida="0";
                if(rs_01.next()){
                    codUnidadeMedida=rs_01.getString(1);
                }
                accionesMaterialesbean.setFechaPedidoSolicitud(bean.getFechaPedidoSolicitud());
                String sql1 = "INSERT INTO SOLICITUDES_COMPRA_DETALLE (COD_MATERIAL,COD_SOLICITUD_COMPRA,CANT_SOLICITADA,COD_UNIDAD_MEDIDA)VALUES";
                sql1 +="('"+ bean.getMaterialesBean().getCodMaterial()  +"', '"+ CodSolCompra  +"','"+ bean.getCantidadSolicitada() +"',";
                sql1 +=""+codUnidadeMedida+")";
                System.out.println("sql1.........:"+sql1);
                Statement st1 = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                int result = st1.executeUpdate(sql1);
            }//fin de while
            
            //Realizo la insercion de la cabecera
            String sql_00="select COD_PERSONAL,COD_AREA_EMPRESA from SOLICITUDES_MANTENIMIENTO  where COD_SOLICITUD_MANTENIMIENTO = " + accionesMaterialesbean.getCodSolicitudCompra();
            System.out.println("sqlXXXX.........:" + sql_00);
            Statement st_00 = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs_00 = st_00.executeQuery(sql_00);
            
            String codPersonalF = "0";
            String codAreaEmpresaF = "0";
            if(rs_00.next()){
               codPersonalF=rs_00.getString(1);
               codAreaEmpresaF=rs_00.getString(2);
            }
            
            Date date=new Date();
            String sql_03="select g.COD_GESTION from GESTIONES g where g.GESTION_ESTADO=1";
            Statement st_03 = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs_03=st_00.executeQuery(sql_03);
            String codGestion = "0";
            if(rs_03.next()){
                codGestion=rs_03.getString(1);
            }
            String sql2 ="";
            sql2 = "INSERT INTO SOLICITUDES_COMPRA(COD_SOLICITUD_COMPRA,COD_GESTION,COD_TIPO_SOLICITUD_COMPRA,COD_RESPONSABLE_COMPRAS,COD_ESTADO_SOLICITUD_COMPRA,";
            sql2 += "ESTADO_SISTEMA,COD_PERSONAL,COD_AREA_EMPRESA,FECHA_SOLICITUD_COMPRA,FECHA_ENVIO) VALUES (";            
            sql2 += "'"+ CodSolCompra  +"'";
            sql2 += ","+ codGestion +",";
            sql2 += "'1', '13', '9', '1',";
            sql2 += " "+ codPersonalF +"  ," + codAreaEmpresaF +" , '"+ accionesMaterialesbean.getFechaPedidoSolicitud() +"', '"+ df.format(date) +"' )";
            System.out.println("sql_02...:"+sql2);
            Statement st2 = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            int result1 = st2.executeUpdate(sql2);

        }catch(SQLException e){
            e.printStackTrace();
        }
        return "ordenCompraMantenimiento";
    }
    
    
    public String guardarOrdenPedido(){
        try {
            String varFecha[]=accionesMaterialesbean.getFechaPedidoSolicitud().split("/");
            String varFechaAux=varFecha[2]+"/"+varFecha[1]+"/"+varFecha[0];
            //Inserto en  el detalle del formulario
            
            String sql =  "INSERT INTO MATERIALES_MANTENIMIENTO_DETALLE(Cod_material,Cod_Material_Mantenimiento,Cantida_solicitada) VALUES(";
                   sql += "'"+ OrdenSolicitudMantenimientobean.getOrdenCodMaterial() + "', ";
                   sql += "'"+ accionesMaterialesbean.getCodSolicitudCompra() + "', "; 
                   sql += "'"+ accionesMaterialesbean.getCantidadSolicitada() + "')";                    
            System.out.println("INSERTAR YYYYYYYYYYYYYYYY--------------------->   " + sql);
            setCon(Util.openConnection(getCon()));            
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            int result=st.executeUpdate(sql);
            if(result > 0){
                cargarAccionesMantenimiento();
            }  
             
            //////////////////
            
            //////////////////

            //tengo que imprimir solo una vez el registro
            //Inserto en la cabecera 
            String sqlV = "SELECT Count(DISTINCT Cod_Solicitud_Compra)";
                   sqlV += "FROM MATERIALES_MANTENIMIENTO_CABECERA ";                  
                   sqlV += "WHERE Cod_Solicitud_Compra = "+accionesMaterialesbean.getCodSolicitudCompra() ;
            System.out.println("SQL SQL XXXXXXXXXXX---------->" + sqlV);  
            Statement stmtV = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rsV = stmtV.executeQuery(sqlV) ; 
            int auxV =0;
            if (rsV.next()){
                auxV = rsV.getInt(1);
            }
            System.out.println("AUX AUX AUX AUX ----------> " + auxV);
            if (auxV == 0) {           
                String sql1 =  "INSERT INTO MATERIALES_MANTENIMIENTO_CABECERA(Cod_Materiales_Mantenimiento,Cod_Solicitud_Compra,Cod_Estado_Material_Mantenimiento,Fecha_Pedido_Solicitado) VALUES (";
                       sql1 += " '"+ accionesMaterialesbean.getCodSolicitudCompra() + "', ";
                       sql1 += " '"+ OrdenSolicitudMantenimientobean.getOrdenCodMaterial() +"', ";
                       sql1 += " '1', ";
                       sql1 += " '"+ varFechaAux +"')";
                System.out.println("INSERTAR MATERIALES_MANTENIMIENTO_CABECERA XXXXXXXXXXX-------------> " + sql1);       
                Statement st1 = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);            
                int result1 = st1.executeUpdate(sql1);
             }  
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "";
    }
    
    public double calcularStock(String item){
        double total=0;
        try {
            Date fechaActual = new Date();
            SimpleDateFormat f = new SimpleDateFormat("yyyy/MM/dd");
            String fecha_existencia = f.format(fechaActual);
            // Verifico la existencia en Stock
            //--------------------  INGRESOS  APROBADOS ----------------------
            
            String hora="23:59:00";
            String sql_exp = "";
            sql_exp = "select m.cod_material,m.stock_minimo_material,m.stock_maximo_material,m.stock_seguridad,m.cod_unidad_medida,m.nombre_material,u.nombre_unidad_medida,";
            sql_exp += " (select SUM(iade.cantidad_parcial) from ingresos_almacen_detalle_estado iade,ingresos_almacen_detalle  iad,ingresos_almacen ia";
            sql_exp += " WHERE iade.cod_material=m.cod_material and ia.cod_estado_ingreso_almacen=1 and iad.cod_ingreso_almacen=ia.cod_ingreso_almacen and ia.estado_sistema=1 and iade.cod_material=iad.cod_material and iade.cod_ingreso_almacen=iad.cod_ingreso_almacen";
            sql_exp += "  and ia.fecha_ingreso_almacen<='" +fecha_existencia+" "+hora+"' )as aprobados,";
            
            // --------------------   SALIDAS ----------------------
            
            sql_exp += " (select SUM(sadi.cantidad)";
            sql_exp += " from salidas_almacen_detalle sad,salidas_almacen_detalle_ingreso sadi,ingresos_almacen_detalle_estado iade, salidas_almacen sa";
            sql_exp += " WHERE sa.cod_salida_almacen=sad.cod_salida_almacen and sa.estado_sistema=1 and sa.cod_estado_salida_almacen=1 and";
            sql_exp += " sad.cod_salida_almacen=sadi.cod_salida_almacen and sad.cod_material=sadi.cod_material and";
            sql_exp += " sadi.cod_ingreso_almacen=iade.cod_ingreso_almacen and sadi.cod_material=iade.cod_material and sadi.ETIQUETA=iade.ETIQUETA ";
            sql_exp += " and sad.cod_material=m.cod_material  and sa.fecha_salida_almacen<='" + fecha_existencia + "')as salidas,";
            
            // --------------------   DEVOLUCIONES ----------------------
            
            sql_exp += "(select sum(iad.cant_total_ingreso_fisico) from DEVOLUCIONES d, ingresos_almacen ia,INGRESOS_ALMACEN_DETALLE iad";
            sql_exp += " where ia.cod_devolucion=d.cod_devolucion  and ia.fecha_ingreso_almacen<='" + fecha_existencia + "' and d.cod_estado_devolucion=1 and d.estado_sistema=1 and ia.cod_estado_ingreso_almacen=1";
            sql_exp += " and ia.cod_almacen=d.cod_almacen and ia.cod_ingreso_almacen=iad.cod_ingreso_almacen and iad.cod_material=m.cod_material)as devoluciones,";
            
            // --------------------   CUARENTENA ----------------------
            
            sql_exp += " (select SUM(iade.cantidad_restante)";
            sql_exp += " from ingresos_almacen_detalle_estado iade,ingresos_almacen_detalle  iad,ingresos_almacen ia";
            sql_exp += " WHERE iade.cod_material=m.cod_material and ia.cod_estado_ingreso_almacen=1 and iad.cod_ingreso_almacen=ia.cod_ingreso_almacen and ia.estado_sistema=1 and iade.cod_material=iad.cod_material and iade.cod_ingreso_almacen=iad.cod_ingreso_almacen";
            sql_exp += " and iade.cod_estado_material=1  and ia.fecha_ingreso_almacen<='" + fecha_existencia + "')as cuarentena,";
            
            //--------------------   RECHAZADO ----------------------
            
            sql_exp += " (select SUM(iade.cantidad_restante)";
            sql_exp += " from ingresos_almacen_detalle_estado iade,ingresos_almacen_detalle  iad,ingresos_almacen ia";
            sql_exp += " WHERE iade.cod_material=m.cod_material and ia.cod_estado_ingreso_almacen=1 and iad.cod_ingreso_almacen=ia.cod_ingreso_almacen and ia.estado_sistema=1 and iade.cod_material=iad.cod_material and iade.cod_ingreso_almacen=iad.cod_ingreso_almacen";
            sql_exp += " and iade.cod_estado_material=3  and ia.fecha_ingreso_almacen<='" + fecha_existencia + "')as rechazado,";
            
            //--------------------   VENCIDO ----------------------
            
            sql_exp += " (select SUM(iade.cantidad_restante)";
            sql_exp += " from ingresos_almacen_detalle_estado iade,ingresos_almacen_detalle  iad,ingresos_almacen ia";
            sql_exp += " WHERE iade.cod_material=m.cod_material and ia.cod_estado_ingreso_almacen=1 and iad.cod_ingreso_almacen=ia.cod_ingreso_almacen and ia.estado_sistema=1 and iade.cod_material=iad.cod_material and iade.cod_ingreso_almacen=iad.cod_ingreso_almacen";
            sql_exp += " and iade.cod_estado_material=4  and ia.fecha_ingreso_almacen<='" + fecha_existencia + "'  )as vencido,";
            
            //--------------------   OBSOLETO ----------------------
            
            sql_exp += " (select SUM(iade.cantidad_restante)";
            sql_exp += " from ingresos_almacen_detalle_estado iade,ingresos_almacen_detalle  iad,ingresos_almacen ia";
            sql_exp += " WHERE iade.cod_material=m.cod_material and ia.cod_estado_ingreso_almacen=1 and iad.cod_ingreso_almacen=ia.cod_ingreso_almacen and ia.estado_sistema=1 and iade.cod_material=iad.cod_material and iade.cod_ingreso_almacen=iad.cod_ingreso_almacen";
            sql_exp += " and iade.cod_estado_material=5  and ia.fecha_ingreso_almacen<='" + fecha_existencia + "')as obsoleto,";
            sql_exp += " (select sum (rd.CANTIDAD ) from RESERVA r,RESERVA_DETALLE rd ";
            sql_exp += " where r.cod_reserva=rd.cod_reserva and rd.COD_MATERIAL = m.COD_MATERIAL ) as reserva";
            sql_exp += " from materiales m,grupos g,capitulos c,UNIDADES_MEDIDA u ";
            sql_exp += " where m.cod_grupo=g.cod_grupo and g.cod_capitulo=c.cod_capitulo and  m.material_almacen=1 and u.cod_unidad_medida=m.cod_unidad_medida ";
            sql_exp += " and m.cod_material ="+item;
            sql_exp += " order by m.nombre_material";
            System.out.println("sql_exp:" + sql_exp);
            
            Statement st2 = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs2 = st2.executeQuery(sql_exp);
            
            if (rs2.next()) {
                System.out.println("***-----------------***");
                String codMaterial = rs2.getString(1);
                double stockMinimo = rs2.getDouble(2);
                stockMinimo = redondear(stockMinimo, 3);
                NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
                DecimalFormat form = (DecimalFormat) nf;
                form.applyPattern("#,###.00");
                String stock_minimo = form.format(stockMinimo);
                double stockMaximo = rs2.getDouble(3);
                stockMaximo = redondear(stockMaximo, 3);
                String stock_maximo = form.format(stockMaximo);
                double stockSeguridad = rs2.getDouble(4);
                stockSeguridad = redondear(stockSeguridad, 3);
                String stock_segu = form.format(stockSeguridad);
                String cod_unidadMedida = rs2.getString(5);
                String nombreMaterial = rs2.getString(6);
                String nombreUnidadMedida = rs2.getString(7);
                double aprobados = rs2.getDouble(8);
                
                double salidas = rs2.getDouble(9);
                salidas = redondear(salidas, 3);
                String salida = form.format(salidas);
                double devoluciones = rs2.getDouble(10);
                devoluciones = redondear(devoluciones, 3);
                String devolucion = form.format(devoluciones);
                double cuarentena = rs2.getDouble(11);
                cuarentena = redondear(cuarentena, 3);
                String cuaren = form.format(cuarentena);
                double rechazado = rs2.getDouble(12);
                rechazado = redondear(rechazado, 3);
                String recha = form.format(rechazado);
                double vencido = rs2.getDouble(13);
                vencido = redondear(vencido, 3);
                String venc = form.format(vencido);
                double obsoleto = rs2.getDouble(14);
                obsoleto = redondear(obsoleto, 3);
                String obso = form.format(obsoleto);
                //double reserva = rs2.getDouble(15);
                double reserva = 0;
                reserva = redondear(reserva, 3);
                String reser = form.format(reserva);
                total = aprobados - salidas + devoluciones - rechazado - vencido - obsoleto - reserva;
                total = redondear(total, 3);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return total;
    }
    
    public void cargarAccionesMantenimiento(){
        try {            
            accionesMaterialesbean.setEstado(Estados1());  
            String sql =  "SELECT mmd.Cod_material,m.NOMBRE_MATERIAL,mmd.Cantida_solicitada,mmc.Fecha_Pedido_Solicitado " ;
                   sql += "FROM MATERIALES_MANTENIMIENTO_DETALLE mmd, ";
                   sql += "MATERIALES_MANTENIMIENTO_CABECERA mmc , ";
                   sql += "MATERIALES m ";
                   sql += "WHERE m.COD_MATERIAL=mmd.Cod_material AND ";
                   sql += "mmd.Cod_Material_Mantenimiento = mmc.Cod_Materiales_Mantenimiento and ";
                   sql += "mmc.Cod_Materiales_Mantenimiento = "+ accionesMaterialesbean.getCodSolicitudCompra();
                   
            System.out.println("SQ55555555555555--------:" + sql);
            setCon(Util.openConnection(getCon()));
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(sql);
            pedidoMaterialesList.clear();
            pedidoMaterialesAuxList.clear();
            int cont = 1;  
            
            while(rs.next()){
                AccionesMateriales bean=new AccionesMateriales();                
                String codMaterial=rs.getString(1);
                String nombreMaterial=rs.getString(2);
                String cantidadSolicitada=rs.getString(3);
                String fechaSolicitado=rs.getString(4);
                double cantidadStock=calcularStock(codMaterial);
                double diferencia=cantidadStock - Double.parseDouble(cantidadSolicitada);
                bean.setCantidadStock(cantidadStock);
                bean.getMaterialesBean().setCodMaterial(codMaterial);
                bean.getMaterialesBean().setNombreMaterial(nombreMaterial);
                bean.setCantidadSolicitada(cantidadSolicitada);
                bean.setFechaPedidoSolicitud(fechaSolicitado);
                bean.setNroOrden(cont);
                if(diferencia < 0){
                    pedidoMaterialesAuxList.add(bean);
                }
                bean.setDiferencia(diferencia);
                cont++;
                pedidoMaterialesList.add(bean);
            }
            if(rs!=null){
                rs.close(); st.close();
                rs = null;  st = null;
            }
            System.out.println("TAMAÑO DE LA LISTA------->>"+ pedidoMaterialesList.size());
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    public void cargarEstadoMateriales(String codigo,AccionesMateriales bean){
        try {
            setCon(Util.openConnection(getCon()));
            String sql1  = " SELECT b.Cod_Solicitud_Compra,a.Cantida_solicitada,b.Fecha_Pedido_Solicitado,b.Cod_Estado_Material_Mantenimiento ";
                   sql1 += " FROM MATERIALES_MANTENIMIENTO_DETALLE a,MATERIALES_MANTENIMIENTO_CABECERA b ";       
                   sql1 += " WHERE a.Cod_Material_Mantenimiento = b.Cod_Materiales_Mantenimiento";
            System.out.println("YYYYYYYYYYYYYYYYYYYYYYYYYYY--->" +sql1);       
            ResultSet rs = null;
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            if(!codigo.equals("")){
                sql1+=" and cod_solicitud_compra = "+codigo;
                System.out.println("update:"+sql1);
                rs=st.executeQuery(sql1);
                if(rs.next()){
                    bean.getEstadoReferencialMateriales().setCodSolicitudCompra(rs.getString(1));
                    bean.getEstadoReferencialMateriales().setNombreEstadoMaterial(rs.getString(4));//2
                }
            } else{
                getEstadoMateriales().clear();
                rs=st.executeQuery(sql1);
                while (rs.next())
                    getEstadoMateriales().add(new SelectItem(rs.getString(1),rs.getString(4)));//2
            }
     
            if(rs!=null){
                rs.close();st.close();
                rs=null;st=null;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    public void clearAccionesMantenimiento(){
        getAccionesMaterialesbean().setCodSolicitudCompra("");
        getAccionesMaterialesbean().setMaterial("");
        getAccionesMaterialesbean().setCantidadSolicitada("");        
        getAccionesMaterialesbean().setEstado("");
    }
    
    public String Cancelar(){
        getAccionesMateriales().clear();
        cargarAccionesMantenimiento();
        return "navegadorAccionesMantenimiento";
    }
    
    public String CancelarM(){
        getAccionesMateriales().clear();
        ordenCompraMantenimiento();
        return "";
    }
        
    public String getObtenerCodigo(){
        String cod=Util.getParameter("codigo");
        if(cod!=null){
            accionesMaterialesbean.setCodSolicitudCompra(cod);
        }        
        System.out.println("codigoGGGG---------------> "+accionesMaterialesbean.getCodSolicitudCompra());
        cargarMateriales();
        cargarAccionesMantenimiento();
        return "";
    }
    
    public void cargarMateriales(){        
        try {
            String sql = "select Cod_Material,Nombre_Material from MATERIALES m where m.COD_GRUPO in (81,82,83,85,87)order by Nombre_Material";
            System.out.println("SELECCION------->  " + sql);
            setCon(Util.openConnection(getCon()));
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(sql);
            getEstadosOrdenMantenimientoList().clear();
            String cod="";
            while(rs.next()) {
                getEstadosOrdenMantenimientoList().add(new SelectItem(rs.getString(1),rs.getString(2)));
            }
            if(rs!=null){
                rs.close(); st.close();
                rs = null;  st = null;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    public Connection getCon() {
        return con;
    }
    
    public void setCon(Connection con) {
        this.con = con;
    }
    
    public OrdenSolicitudMantenimiento getOrdenSolicitudMantenimientobean() {
        return OrdenSolicitudMantenimientobean;
    }
    
    public void setOrdenSolicitudMantenimientobean(OrdenSolicitudMantenimiento OrdenSolicitudMantenimientobean) {
        this.OrdenSolicitudMantenimientobean = OrdenSolicitudMantenimientobean;
    }
    
    public List<SolicitudMantenimiento> getSolicitudMantenimientoList() {
        return solicitudMantenimientoList;
    }
    
    public void setSolicitudMantenimientoList(List<SolicitudMantenimiento> solicitudMantenimientoList) {
        this.solicitudMantenimientoList = solicitudMantenimientoList;
    }
    
    public List<OrdenSolicitudMantenimiento> getOrdenSolicitudMantenimientoList() {
        return OrdenSolicitudMantenimientoList;
    }
    
    public void setOrdenSolicitudMantenimientoList(List<OrdenSolicitudMantenimiento> OrdenSolicitudMantenimientoList) {
        this.OrdenSolicitudMantenimientoList = OrdenSolicitudMantenimientoList;
    }
    
    public List getAccionesMateriales() {
        return accionesMateriales;
    }
    
    public void setAccionesMateriales(List accionesMateriales) {
        this.accionesMateriales = accionesMateriales;
    }
    
    public List getEstadoMateriales() {
        return estadoMateriales;
    }
    
    public void setEstadoMateriales(List estadoMateriales) {
        this.estadoMateriales = estadoMateriales;
    }
    
    public AccionesMateriales getAccionesMaterialesbean() {
        return accionesMaterialesbean;
    }
    
    public void setAccionesMaterialesbean(AccionesMateriales accionesMaterialesbean) {
        this.accionesMaterialesbean = accionesMaterialesbean;
    }
    
    
    public double redondear(double numero, int decimales) {
        return Math.round(numero * Math.pow(10, decimales)) / Math.pow(10, decimales);
    }
    
    public List getEstadosOrdenMantenimientoList() {
        return estadosOrdenMantenimientoList;
    }
    
    public void setEstadosOrdenMantenimientoList(List estadosOrdenMantenimientoList) {
        this.estadosOrdenMantenimientoList = estadosOrdenMantenimientoList;
    }
    
    public List getPedidoMaterialesList() {
        return pedidoMaterialesList;
    }
    
    public void setPedidoMaterialesList(List pedidoMaterialesList) {
        this.pedidoMaterialesList = pedidoMaterialesList;
    }
    
    public List getPedidoMaterialesAuxList() {
        return pedidoMaterialesAuxList;
    }
    
    public void setPedidoMaterialesAuxList(List pedidoMaterialesAuxList) {
        this.pedidoMaterialesAuxList = pedidoMaterialesAuxList;
    }
    
    public List getSalidaMaterialesList() {
        return salidaMaterialesList;
    }
    
    public void setSalidaMaterialesList(List salidaMaterialesList) {
        this.salidaMaterialesList = salidaMaterialesList;
    }
}
