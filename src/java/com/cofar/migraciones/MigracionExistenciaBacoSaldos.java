/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.migraciones;
import groovy.sql.Sql;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import org.apache.commons.dbcp.BasicDataSource;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/**
 *
 * @author DASISAQ-
 */
public class MigracionExistenciaBacoSaldos 
{
    /*
        delete PROCESOS_PREPARADO_PRODUCTO
        delete PROCESOS_PREPARADO_PRODUCTO_CONSUMO_MATERIAL
        delete PROCESOS_PREPARADO_PRODUCTO_ESPECIFICACIONES_MAQUINARIA
        delete PROCESOS_PREPARADO_PRODUCTO_MAQUINARIA
    */
    private static Logger LOGGER=LogManager.getRootLogger();
    
    public static void main(String[] args) {
     
        BasicDataSource basicDataSource=new BasicDataSource();
        basicDataSource.setUrl("jdbc:sqlserver://172.16.10.21;databaseName=SARTORIUS");
        basicDataSource.setDriverClassName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        basicDataSource.setUsername("sa");
        basicDataSource.setPassword("m0t1t4s@2009");
        basicDataSource.setInitialSize(6);
        basicDataSource.setMaxActive(2000);
        basicDataSource.setMaxWait(60000);
        Connection con=null;
        try
        {
            con=basicDataSource.getConnection();
            Statement st =con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            con.setAutoCommit(false);
            StringBuilder consulta=new StringBuilder("select isnull(max(s.COD_SALIDA_ALMACEN),0)+1 COD_SALIDA_ALMACEN from SALIDAS_ALMACEN s");
            ResultSet res=st.executeQuery(consulta.toString());
            int codSalidaALmacen=0;
            if(res.next())codSalidaALmacen=res.getInt(1);
            consulta=new StringBuilder("select isnull(MAX(nro_salida_almacen),0)+1 nro_salida_almacen from salidas_almacen  where cod_gestion='11'  and cod_almacen='1' and estado_sistema=1");
            res=st.executeQuery(consulta.toString());
            res.next();
                    consulta=new StringBuilder("INSERT INTO SALIDAS_ALMACEN ( COD_GESTION, COD_SALIDA_ALMACEN, COD_ORDEN_PESADA,  COD_FORM_SALIDA, COD_PROD,    COD_TIPO_SALIDA_ALMACEN,  COD_AREA_EMPRESA,   NRO_SALIDA_ALMACEN,   FECHA_SALIDA_ALMACEN,   OBS_SALIDA_ALMACEN,   ESTADO_SISTEMA,   COD_ALMACEN,   COD_ORDEN_COMPRA,   COD_PERSONAL,    COD_ESTADO_SALIDA_ALMACEN,   COD_LOTE_PRODUCCION,    COD_ESTADO_SALIDA_COSTO,   cod_prod_ant,   orden_trabajo,   COD_PRESENTACION,cod_prod1,cod_maquina)");
                    consulta.append("VALUES (   '11',").append(codSalidaALmacen).append(", '0',  '0','0', '14',    '101',").append(res.getInt(1)).append(",GETDATE(),  'Salida inicial para sanear etiquetas generada por sistemas',  '1','1',  '0', '820',  '1',  '','0',  '0', '', '0','','')");
            LOGGER.debug("consulta registrar salidas "+consulta.toString());
            PreparedStatement pst=con.prepareStatement(consulta.toString());
            if(pst.executeUpdate()>0)LOGGER.info("se registro la cabecera "+consulta.toString());
            consulta=new StringBuilder("select isnull(iade.LOTE_MATERIAL_PROVEEDOR,'') as loteProveedor,");
                            consulta.append("  iade.COD_MATERIAL,m.NOMBRE_MATERIAL ,count(*),sum(iade.CANTIDAD_RESTANTE)");
                            consulta.append("  from INGRESOS_ALMACEN ia");
                            consulta.append(" inner join INGRESOS_ALMACEN_DETALLE_ESTADO iade on ia.COD_INGRESO_ALMACEN=iade.COD_INGRESO_ALMACEN");
                            consulta.append(" inner join materiales m on m.COD_MATERIAL=iade.COD_MATERIAL");
                            consulta.append(" inner join grupos g on g.COD_GRUPO=m.COD_GRUPO");
                            consulta.append(" where ia.COD_ALMACEN=1");
                            consulta.append(" and ia.COD_ESTADO_INGRESO_ALMACEN=1");
                            consulta.append(" and ia.ESTADO_SISTEMA=1");
                            consulta.append(" and g.COD_CAPITULO=2");
                            consulta.append(" and iade.CANTIDAD_RESTANTE>0.01");
                            consulta.append(" group by iade.LOTE_MATERIAL_PROVEEDOR,iade.COD_MATERIAL,m.NOMBRE_MATERIAL");
                            consulta.append(" HAVING COUNT(*)>1");
                            consulta.append(" order by m.NOMBRE_MATERIAL");
            res=st.executeQuery(consulta.toString());
            consulta=new StringBuilder("select top 1 ia.COD_INGRESO_ALMACEN");
                                    consulta.append(" from INGRESOS_ALMACEN ia");
                                    consulta.append(" inner join INGRESOS_ALMACEN_DETALLE_ESTADO iade on ia.COD_INGRESO_ALMACEN=iade.COD_INGRESO_ALMACEN");
                                    consulta.append(" where ia.COD_ALMACEN=1");
                                    consulta.append(" and ia.COD_ESTADO_INGRESO_ALMACEN=1");
                                    consulta.append(" and ia.ESTADO_SISTEMA=1");
                                    consulta.append(" and iade.CANTIDAD_RESTANTE>0.01");
                                    consulta.append(" and iade.COD_MATERIAL=?");
                                    consulta.append(" and iade.LOTE_MATERIAL_PROVEEDOR=?");
                                    consulta.append(" order by iade.CANTIDAD_RESTANTE desc");
            pst=con.prepareStatement(consulta.toString());
            consulta=new StringBuilder("INSERT INTO SALIDAS_ALMACEN_DETALLE_INGRESO(COD_SALIDA_ALMACEN, COD_MATERIAL,");
                                    consulta.append(" COD_INGRESO_ALMACEN, ETIQUETA, COSTO_SALIDA, FECHA_VENCIMIENTO, CANTIDAD,");
                                    consulta.append(" COSTO_SALIDA_ACTUALIZADO, FECHA_ACTUALIZACION, COSTO_SALIDA_ACTUALIZADO_FINAL)");
                                    consulta.append(" select ?,iade.COD_MATERIAL,iade.COD_INGRESO_ALMACEN,iade.ETIQUETA,0,iade.FECHA_VENCIMIENTO,iade.CANTIDAD_RESTANTE");
                                    consulta.append(" ,0,GETDATE(),0");
                                    consulta.append(" from INGRESOS_ALMACEN ia");
                                    consulta.append(" inner join INGRESOS_ALMACEN_DETALLE_ESTADO iade on ia.COD_INGRESO_ALMACEN=iade.COD_INGRESO_ALMACEN");
                                    consulta.append(" inner join materiales m on m.COD_MATERIAL=iade.COD_MATERIAL");
                                    consulta.append(" inner join grupos g on g.COD_GRUPO=m.COD_GRUPO");
                                    consulta.append(" where ia.COD_ALMACEN=1");
                                    consulta.append(" and ia.COD_ESTADO_INGRESO_ALMACEN=1");
                                    consulta.append(" and ia.ESTADO_SISTEMA=1");
                                    consulta.append(" and iade.CANTIDAD_RESTANTE>0");
                                    consulta.append(" and iade.LOTE_MATERIAL_PROVEEDOR=?");
                                    consulta.append(" and iade.COD_MATERIAL=?");
                                    consulta.append(" and iade.COD_INGRESO_ALMACEN<>?");
            PreparedStatement pstRegDetalleIng=con.prepareStatement(consulta.toString());
            
            consulta=new StringBuilder("select iade.COD_INGRESO_ALMACEN,iade.ETIQUETA,iade.CANTIDAD_PARCIAL,iade.CANTIDAD_RESTANTE,iade.COD_MATERIAL");
                        consulta.append(" from INGRESOS_ALMACEN_DETALLE_ESTADO iade");
                        consulta.append(" where iade.COD_MATERIAL=?");
                        consulta.append(" and iade.LOTE_MATERIAL_PROVEEDOR=?");
                        consulta.append(" and iade.COD_INGRESO_ALMACEN=?");
                        consulta.append(" and iade.CANTIDAD_PARCIAL<>iade.CANTIDAD_RESTANTE");
                        consulta.append(" order by iade.CANTIDAD_RESTANTE desc");
            PreparedStatement pstIngresoDet=con.prepareStatement(consulta.toString());
            ResultSet resIng;
            
            
            consulta=new StringBuilder("select sum(iade.CANTIDAD_RESTANTE) as cantidadTransferir");
                                    consulta.append(" from INGRESOS_ALMACEN ia");
                                    consulta.append(" inner join INGRESOS_ALMACEN_DETALLE_ESTADO iade on ia.COD_INGRESO_ALMACEN=iade.COD_INGRESO_ALMACEN");
                                    consulta.append(" inner join materiales m on m.COD_MATERIAL=iade.COD_MATERIAL");
                                    consulta.append(" inner join grupos g on g.COD_GRUPO=m.COD_GRUPO");
                                    consulta.append(" where ia.COD_ALMACEN=1");
                                    consulta.append(" and ia.COD_ESTADO_INGRESO_ALMACEN=1");
                                    consulta.append(" and ia.ESTADO_SISTEMA=1");
                                    consulta.append(" and iade.CANTIDAD_RESTANTE>0");
                                    consulta.append(" and iade.LOTE_MATERIAL_PROVEEDOR=?");
                                    consulta.append(" and iade.COD_MATERIAL=?");
                                    consulta.append(" and iade.COD_INGRESO_ALMACEN<>?");
            PreparedStatement pstCantidad=con.prepareStatement(consulta.toString());
            
            consulta=new StringBuilder("update INGRESOS_ALMACEN_DETALLE_ESTADO  set CANTIDAD_RESTANTE=0");
                                    consulta.append(" from INGRESOS_ALMACEN ia");
                                    consulta.append(" inner join INGRESOS_ALMACEN_DETALLE_ESTADO iade on ia.COD_INGRESO_ALMACEN=iade.COD_INGRESO_ALMACEN");
                                    consulta.append(" inner join materiales m on m.COD_MATERIAL=iade.COD_MATERIAL");
                                    consulta.append(" inner join grupos g on g.COD_GRUPO=m.COD_GRUPO");
                                    consulta.append(" where ia.COD_ALMACEN=1");
                                    consulta.append(" and ia.COD_ESTADO_INGRESO_ALMACEN=1");
                                    consulta.append(" and ia.ESTADO_SISTEMA=1");
                                    consulta.append(" and iade.CANTIDAD_RESTANTE>0");
                                    consulta.append(" and iade.LOTE_MATERIAL_PROVEEDOR=?");
                                    consulta.append(" and iade.COD_MATERIAL=?");
                                    consulta.append(" and iade.COD_INGRESO_ALMACEN<>?");
            PreparedStatement pstSetCero=con.prepareStatement(consulta.toString());
            
            
            consulta=new StringBuilder("UPDATE INGRESOS_ALMACEN_DETALLE_ESTADO");
                        consulta.append(" SET CANTIDAD_RESTANTE = CANTIDAD_PARCIAL");
                        consulta.append(" WHERE COD_INGRESO_ALMACEN = ? and");
                        consulta.append(" COD_MATERIAL = ? and");
                        consulta.append(" ETIQUETA = ?");
            PreparedStatement pstIgualIngreso=con.prepareStatement(consulta.toString());
            
            consulta=new StringBuilder("UPDATE INGRESOS_ALMACEN_DETALLE_ESTADO");
                            consulta.append(" SET CANTIDAD_RESTANTE =CANTIDAD_RESTANTE + ?");
                            consulta.append(" WHERE COD_INGRESO_ALMACEN = ? and");
                            consulta.append("      COD_MATERIAL = ? and");
                            consulta.append("       ETIQUETA = ?");
            PreparedStatement pstAumentarIngreso=con.prepareStatement(consulta.toString());
            LOGGER.debug("consulta restar cantidad "+consulta.toString());
            
            
            
            while(res.next())
            {
                pst.setInt(1,res.getInt("COD_MATERIAL"));
                pst.setString(2,res.getString("loteProveedor"));
                ResultSet resd=pst.executeQuery();
                if(resd.next())
                {
                    LOGGER.debug("iniciando salida "+res.getString("loteProveedor")+" cm "+res.getInt("COD_MATERIAL"));  
                    pstRegDetalleIng.setInt(1,codSalidaALmacen);
                    pstRegDetalleIng.setString(2,res.getString("loteProveedor"));
                    pstRegDetalleIng.setInt(3,res.getInt("COD_MATERIAL"));
                    pstRegDetalleIng.setInt(4,resd.getInt("COD_INGRESO_ALMACEN"));
                    if(pstRegDetalleIng.executeUpdate()>0)LOGGER.info(" se registro la salida detalle ingreso ");
                    pstCantidad.setString(1,res.getString("loteProveedor"));
                    pstCantidad.setInt(2,res.getInt("COD_MATERIAL"));
                    pstCantidad.setInt(3,resd.getInt("COD_INGRESO_ALMACEN"));
                    resIng=pstCantidad.executeQuery();
                    resIng.next();
                    Double cantidadSalida=resIng.getDouble(1);
                    LOGGER.debug("cantidad total sacar "+cantidadSalida);
                    
                    pstIngresoDet.setInt(1,res.getInt("COD_MATERIAL"));
                    pstIngresoDet.setString(2,res.getString("loteProveedor"));
                    pstIngresoDet.setInt(3,resd.getInt("COD_INGRESO_ALMACEN"));
                    resIng=pstIngresoDet.executeQuery();
                    while(resIng.next())
                    {
                        if(cantidadSalida>0)
                        {
                            if(resIng.getDouble("CANTIDAD_PARCIAL")>resIng.getDouble("CANTIDAD_RESTANTE"))
                            {
                                Double cantidadSalidaRestante=resIng.getDouble("CANTIDAD_PARCIAL")-resIng.getDouble("CANTIDAD_RESTANTE");
                                if(cantidadSalida>cantidadSalidaRestante)
                                {
                                    LOGGER.debug("igualando la cantidad");
                                    pstIgualIngreso.setInt(1,resIng.getInt("COD_INGRESO_ALMACEN"));
                                    pstIgualIngreso.setInt(2,resIng.getInt("COD_MATERIAL"));
                                    pstIgualIngreso.setInt(3,resIng.getInt("ETIQUETA"));
                                    if(pstIgualIngreso.executeUpdate()>0)LOGGER.info("se igualo la cantidad");
                                    cantidadSalida-=cantidadSalidaRestante;
                                }
                                else
                                {
                                    LOGGER.debug("asignando 1"+cantidadSalida);
                                    pstAumentarIngreso.setDouble(1,cantidadSalida);
                                    pstAumentarIngreso.setInt(2,resIng.getInt("COD_INGRESO_ALMACEN"));
                                    pstAumentarIngreso.setInt(3,resIng.getInt("COD_MATERIAL"));
                                    pstAumentarIngreso.setInt(4,resIng.getInt("ETIQUETA"));
                                    if(pstAumentarIngreso.executeUpdate()>0)LOGGER.info("se actualizo la cantidad");
                                    cantidadSalida=0d;

                                }
                            }
                        }
                    }
                    LOGGER.debug("cantidad sobrante "+cantidadSalida);
                    pstAumentarIngreso.setDouble(1,cantidadSalida);
                    pstAumentarIngreso.setInt(2,resd.getInt("COD_INGRESO_ALMACEN"));
                    pstAumentarIngreso.setInt(3,res.getInt("COD_MATERIAL"));
                    pstAumentarIngreso.setInt(4,1);
                    if(pstAumentarIngreso.executeUpdate()>0)LOGGER.info("se actualizo la cantidad");
                    cantidadSalida=0d;
                    pstSetCero.setString(1,res.getString("loteProveedor"));
                    pstSetCero.setInt(2,res.getInt("COD_MATERIAL"));
                    pstSetCero.setInt(3,resd.getInt("COD_INGRESO_ALMACEN"));
                    if(pstSetCero.executeUpdate()>0)LOGGER.info("se seteo todo a cero");
                    
                }
                
            }
            consulta=new StringBuilder("INSERT INTO SALIDAS_ALMACEN_DETALLE(COD_SALIDA_ALMACEN, COD_MATERIAL,");
                        consulta.append(" CANTIDAD_SALIDA_ALMACEN, COD_UNIDAD_MEDIDA, COD_ESTADO_MATERIAL)");
                        consulta.append(" select sadi.COD_SALIDA_ALMACEN,sadi.COD_MATERIAL,sum(sadi.CANTIDAD),m.COD_UNIDAD_MEDIDA,2");
                        consulta.append(" from SALIDAS_ALMACEN_DETALLE_INGRESO sadi inner join MATERIALES m on m.COD_MATERIAL=sadi.COD_MATERIAL");
                        consulta.append(" where sadi.COD_SALIDA_ALMACEN=?");
                        consulta.append(" group by sadi.COD_SALIDA_ALMACEN,sadi.COD_MATERIAL,m.COD_UNIDAD_MEDIDA");
            PreparedStatement pstDetalleSalida=con.prepareStatement(consulta.toString());
            pstDetalleSalida.setInt(1, codSalidaALmacen);
            LOGGER.debug("consulta registrar detalle salida "+consulta.toString());
            if(pstDetalleSalida.executeUpdate()>0)LOGGER.info("se registro la salidas ");
            consulta=new StringBuilder("select (isnull(max(cod_ingreso_almacen),0)+1) cod_ingreso_almacen   from ingresos_almacen");
            int codIngresoAlmacen=0;
            res=st.executeQuery(consulta.toString());
            if(res.next())codIngresoAlmacen=res.getInt(1);
            consulta=new StringBuilder("select max(i.NRO_INGRESO_ALMACEN)+1 as nroIngreso from INGRESOS_ALMACEN i where i.COD_ALMACEN=1 and i.COD_GESTION=11");
            res=st.executeQuery(consulta.toString());
            res.next();
            consulta=new StringBuilder("insert into ingresos_almacen (cod_ingreso_almacen,nro_ingreso_almacen,cod_tipo_ingreso_almacen,  cod_orden_compra,cod_gestion,cod_estado_ingreso_almacen,  credito_fiscal_si_no,cod_proveedor,  cod_tipo_compra,estado_sistema,cod_almacen,cod_devolucion,fecha_ingreso_almacen,  cod_tipo_documento,cod_personal,cod_estado_ingreso_liquidacion,obs_ingreso_almacen,NRO_DOCUMENTO)");
                        consulta.append(" values  (").append(codIngresoAlmacen).append(" ,").append(res.getInt(1)).append(",  11, '0', '11','1', '0',  '160',  '1', '1',  '1',0 ,GETDATE(), '2', '820',  '2','Ingreso para sanear etiquetas generada por sistemas','')");
            pst=con.prepareStatement(consulta.toString());
            if(pst.executeUpdate()>0)LOGGER.info("se registro el ingreso");
            
            
            consulta=new StringBuilder("insert into ingresos_almacen_detalle(cod_ingreso_almacen, cod_material,");
                                consulta.append("  nro_unidades_empaque, cod_seccion, cant_total_ingreso, cant_total_ingreso_fisico");
                                consulta.append(" , cod_unidad_medida, costo_promedio, costo_unitario, precio_neto,");
                                consulta.append(" precio_unitario_material) ");
                                consulta.append(" select ?,sad.COD_MATERIAL,1,1,sad.CANTIDAD_SALIDA_ALMACEN,sad.CANTIDAD_SALIDA_ALMACEN,sad.COD_UNIDAD_MEDIDA,0,0,0,0");
                                consulta.append("  from SALIDAS_ALMACEN_DETALLE sad ");
                                consulta.append(" where sad.COD_SALIDA_ALMACEN=?");
            pst=con.prepareStatement(consulta.toString());
            pst.setInt(1, codIngresoAlmacen);
            pst.setInt(2,codSalidaALmacen);
            if(pst.executeUpdate()>0)LOGGER.info("se registro el ingreso detalle");
            
            
            con.commit();
        }
        catch(SQLException ex)
        {
            try{
           con.rollback();
            }
            catch(Exception m)
            {
            m.printStackTrace();}
            ex.printStackTrace();
        }
        
    }

      
    
    
}
