/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.migraciones;
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
public class MigracionInyectablesVersionamientos 
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
            con.setAutoCommit(false);
            Statement st =con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            StringBuilder consulta=new StringBuilder("INSERT INTO PROCESOS_PREPARADO_PRODUCTO(COD_VERSION, COD_PROCESO_ORDEN_MANUFACTURA, COD_ACTIVIDAD_PREPARADO, NRO_PASO,DESCRIPCION, TIEMPO_PROCESO, TOLERANCIA_TIEMPO, OPERARIO_TIEMPO_COMPLETO,COD_PROCESO_PREPARADO_PRODUCTO_PADRE,COD_PROCESO_PREPARADO_PRODUCTO_DESTINO)");
                                   consulta.append("values(?,?,?,?,?,?,?,?,?,?)");
            PreparedStatement pstInsertProceso=con.prepareStatement(consulta.toString(),PreparedStatement.RETURN_GENERATED_KEYS);
            ResultSet resInsert;
            consulta=new StringBuilder("select SPP.COD_ACTIVIDAD_PREPARADO,SPP.NRO_PASO,SPP.DESCRIPCION,SPP.TIEMPO_SUB_PROCESO,SPP.PORCIENTO_TOLERANCIA_TIEMPO_SUB_PROCESO,");
                        consulta.append(" spp.OPERARIO_TIEMPO_COMPLETO,SPP.COD_PROCESO_PRODUCTO_DESTINO,spp.COD_SUB_PROCESO_PRODUCTO");
                        consulta.append(" from SUB_PROCESOS_PRODUCTO spp");
                        consulta.append(" where spp.COD_PROCESO_PRODUCTO = ?");
                        consulta.append(" order by spp.NRO_PASO");
            PreparedStatement pstSubprocesos=con.prepareStatement(consulta.toString());
            ResultSet resSubProceso;
            
            consulta=new StringBuilder("INSERT INTO PROCESOS_PREPARADO_PRODUCTO_ESPECIFICACIONES_MAQUINARIA(COD_PROCESO_PREPARADO_PRODUCTO_MAQUINARIA, COD_ESPECIFICACION_PROCESO,");
                                consulta.append(" VALOR_EXACTO, VALOR_MINIMO, VALOR_MAXIMO, VALOR_TEXTO, COD_TIPO_DESCRIPCION,COD_UNIDAD_MEDIDA, PORCIENTO_TOLERANCIA, RESULTADO_ESPERADO_LOTE) ");
                        consulta.append(" select ?,a.cod_especificacion,p.VALOR_EXACTO,p.RANGO_INFERIOR,p.RANGO_SUPERIOR,p.VALOR_DESCRIPTIVO,eq.COD_TIPO_DESCRIPCION,");
                                consulta.append(" eq.COD_UNIDAD_MEDIDA,p.PORCIENTO_TOLERANCIA,p.DATOS_NO_CONSOLIDADOS");
                        consulta.append(" from PROCESOS_PRODUCTO_ESP_EQUIP p ");
                                consulta.append(" inner join auxmigracionatlas a on p.COD_ESPECIFICACION_EQUIPO_AMBIENTE=a.cod_especificacion_ambiente");
                                consulta.append(" inner join ESPECIFICACIONES_EQUIPO_AMBIENTE eq on eq.COD_ESPECIFICACION_EQUIPO_AMBIENTE=a.cod_especificacion_ambiente");
                        consulta.append(" where p.COD_PROCESO_PRODUCTO=?");
            PreparedStatement pstEspMaq=con.prepareStatement(consulta.toString());
            
            consulta=new StringBuilder("select ppm.COD_MAQUINA");
                        consulta.append(" from PROCESOS_PRODUCTO_MAQUINARIA ppm");
                        consulta.append(" where ppm.COD_PROCESO_PRODUCTO=?");
            PreparedStatement pstMaqProceso=con.prepareStatement(consulta.toString());
            ResultSet resMaqProceso;
            
            consulta=new StringBuilder("select s.COD_MAQUINA");
                    consulta.append(" from SUB_PROCESOS_PRODUCTO_MAQUINARIA s ");
                    consulta.append(" where s.COD_SUB_PROCESO_PRODUCTO=?");
                        consulta.append(" and s.COD_PROCESO_PRODUCTO = ?");
            PreparedStatement pstMaqSubProcesos=con.prepareStatement(consulta.toString());
            ResultSet resMaqSubProceso;
            
            consulta=new StringBuilder("INSERT INTO PROCESOS_PREPARADO_PRODUCTO_CONSUMO_MATERIAL(COD_PROCESO_PREPARADO_PRODUCTO, COD_MATERIAL, COD_FORMULA_MAESTRA_FRACCIONES,MATERIAL_TRANSITORIO)");
                     consulta.append("select ?,p.COD_MATERIAL,p.COD_FORMULA_MAESTRA_FRACCIONES,p.PROCESO_TRANSITORIO");
                     consulta.append(" from PROCESOS_PRODUCTO_ESP_MAT p ");
                     consulta.append(" where p.COD_PROCESO_PRODUCTO=?");
                        consulta.append(" AND p.COD_FORMULA_MAESTRA=?");
            PreparedStatement pstCopiMaterial=con.prepareStatement(consulta.toString());
            
            consulta=new StringBuilder("INSERT INTO PROCESOS_PREPARADO_PRODUCTO_CONSUMO_MATERIAL(COD_PROCESO_PREPARADO_PRODUCTO, COD_MATERIAL, COD_FORMULA_MAESTRA_FRACCIONES,MATERIAL_TRANSITORIO)");
                     consulta.append("select ?,p.COD_MATERIAL,p.COD_FORMULA_MAESTRA_FRACCIONES,p.PROCESO_TRANSITORIO");
                     consulta.append(" FROM SUB_PROCESOS_PRODUCTO_ESP_MAT p");
                     consulta.append(" where p.COD_PROCESO_PRODUCTO=?");
                     consulta.append(" and p.COD_SUB_PROCESO_PRODUCTO=?");
                     consulta.append(" and p.COD_FORMULA_MAESTRA=?");
            PreparedStatement pstSubCopiMaterial=con.prepareStatement(consulta.toString());
            
            consulta=new StringBuilder("INSERT INTO PROCESOS_PREPARADO_PRODUCTO_MAQUINARIA(COD_PROCESO_PREPARADO_PRODUCTO,COD_MAQUINA)");
                    consulta.append("values(?,?)");
            PreparedStatement pstInsertMaqProceso=con.prepareStatement(consulta.toString(),PreparedStatement.RETURN_GENERATED_KEYS);
            ResultSet resInsertMaqProceso;
            
            consulta=new StringBuilder(" select cpv.COD_VERSION,p.COD_PROCESO_ORDEN_MANUFACTURA,p.COD_ACTIVIDAD_PREPARADO,p.NRO_PASO,");
                        consulta.append(" p.DESCRIPCION,p.TIEMPO_PROCESO,p.PORCIENTO_TOLERANCIA_TIEMPO_PROCESO,p.OPERARIO_TIEMPO_COMPLETO");
                        consulta.append(" ,0,p.COD_PROCESO_PRODUCTO,fmv.COD_FORMULA_MAESTRA");
                        consulta.append(" from PROCESOS_PRODUCTO p inner join COMPONENTES_PROD_VERSION cpv on ");
                            consulta.append(" cpv.COD_COMPPROD=p.COD_COMPPROD and cpv.cod_forma in (27)");
                            consulta.append(" left outer join FORMULA_MAESTRA_VERSION fmv on fmv.COD_COMPPROD_VERSION=cpv.COD_VERSION and fmv.COD_COMPPROD=cpv.COD_COMPPROD");
                        consulta.append(" order by cpv.cod_version");
            LOGGER.debug("consulta pasos preparado antiguo"+consulta.toString());
            ResultSet res=st.executeQuery(consulta.toString());
            int codProcesosPreparado=0;
            int codSubProcesoPreparado=0;
            int codProcesosMaquina=0;
            while(res.next())
            {
                
                // <editor-fold defaultstate="collapsed" desc="registrando el paso">
                    pstInsertProceso.setInt(1,res.getInt("cod_version"));
                    pstInsertProceso.setInt(2,10);
                    pstInsertProceso.setInt(3,res.getInt("COD_ACTIVIDAD_PREPARADO"));
                    pstInsertProceso.setInt(4,res.getInt("NRO_PASO"));
                    pstInsertProceso.setString(5,res.getString("DESCRIPCION"));
                    pstInsertProceso.setDouble(6,res.getDouble("TIEMPO_PROCESO"));
                    pstInsertProceso.setDouble(7,res.getDouble("PORCIENTO_TOLERANCIA_TIEMPO_PROCESO"));
                    pstInsertProceso.setInt(8,res.getInt("OPERARIO_TIEMPO_COMPLETO"));
                    pstInsertProceso.setInt(9,0);
                    pstInsertProceso.setInt(10,0);
                    if(pstInsertProceso.executeUpdate()>0)LOGGER.info("se registro el paso");
                    resInsert=pstInsertProceso.getGeneratedKeys();
                    if(resInsert.next())codProcesosPreparado=resInsert.getInt(1);
                    
                    //copiando consumo material
                    pstCopiMaterial.setInt(1,codProcesosPreparado);
                    pstCopiMaterial.setInt(2,res.getInt("COD_PROCESO_PRODUCTO"));
                    pstCopiMaterial.setInt(3,res.getInt("COD_FORMULA_MAESTRA"));
                    if(pstCopiMaterial.executeUpdate()>0)LOGGER.info("se copiaron los materiales");
                //</editor-fold>
                // <editor-fold defaultstate="collapsed" desc="maquinarias y especificaciones de proceso">
                    pstMaqProceso.setInt(1, res.getInt("COD_PROCESO_PRODUCTO"));
                    resMaqProceso=pstMaqProceso.executeQuery();
                    while(resMaqProceso.next())
                    {
                        pstInsertMaqProceso.setInt(1, codProcesosPreparado);
                        pstInsertMaqProceso.setInt(2, resMaqProceso.getInt("COD_MAQUINA"));
                        if(pstInsertMaqProceso.executeUpdate()>0)LOGGER.info("se registro la maquinaria");
                        resInsertMaqProceso=pstInsertMaqProceso.getGeneratedKeys();
                        if(resInsertMaqProceso.next())codProcesosMaquina=resInsertMaqProceso.getInt(1);
                        pstEspMaq.setInt(1,codProcesosMaquina);
                        pstEspMaq.setInt(2,res.getInt("COD_PROCESO_PRODUCTO"));
                        if(pstEspMaq.executeUpdate()>0)LOGGER.info("se registraron las especificaciones");
                        
                    }
                //</editor-fold>
                // <editor-fold defaultstate="collapsed" desc="sub procesos">
                    pstSubprocesos.setInt(1,res.getInt("COD_PROCESO_PRODUCTO"));
                    resSubProceso=pstSubprocesos.executeQuery();
                    while(resSubProceso.next())
                    {
                        pstInsertProceso.setInt(1,res.getInt("cod_version"));
                        pstInsertProceso.setInt(2,10);
                        pstInsertProceso.setInt(3,resSubProceso.getInt("COD_ACTIVIDAD_PREPARADO"));
                        pstInsertProceso.setInt(4,resSubProceso.getInt("NRO_PASO"));
                        pstInsertProceso.setString(5,resSubProceso.getString("DESCRIPCION"));
                        pstInsertProceso.setDouble(6,resSubProceso.getDouble("TIEMPO_SUB_PROCESO"));
                        pstInsertProceso.setDouble(7,resSubProceso.getDouble("PORCIENTO_TOLERANCIA_TIEMPO_SUB_PROCESO"));
                        pstInsertProceso.setInt(8,resSubProceso.getInt("OPERARIO_TIEMPO_COMPLETO"));
                        pstInsertProceso.setInt(9,codProcesosPreparado);
                        pstInsertProceso.setInt(10,resSubProceso.getInt("COD_PROCESO_PRODUCTO_DESTINO"));
                        if(pstInsertProceso.executeUpdate()>0)LOGGER.info("se registro el sub paso");
                        if(resSubProceso.getInt("COD_SUB_PROCESO_PRODUCTO")==1 &&res.getInt("COD_PROCESO_PRODUCTO")==0)LOGGER.info("-----------------------------------------------");
                        resInsert=pstInsertProceso.getGeneratedKeys();
                        if(resInsert.next())codSubProcesoPreparado=resInsert.getInt(1);
                        
                        //copiando consumo material
                        pstSubCopiMaterial.setInt(1,codSubProcesoPreparado);
                        pstSubCopiMaterial.setInt(2,res.getInt("COD_PROCESO_PRODUCTO"));
                        pstSubCopiMaterial.setInt(3,resSubProceso.getInt("COD_SUB_PROCESO_PRODUCTO"));
                        pstSubCopiMaterial.setInt(4,res.getInt("COD_FORMULA_MAESTRA"));
                        
                        if(pstSubCopiMaterial.executeUpdate()>0)LOGGER.info("se copiaron los materiales");
                        
                        
                        // <editor-fold defaultstate="collapsed" desc="maquinarias sub procesos">
                            pstMaqSubProcesos.setInt(1,resSubProceso.getInt("COD_SUB_PROCESO_PRODUCTO"));
                            pstMaqSubProcesos.setInt(2,res.getInt("COD_PROCESO_PRODUCTO"));
                            resMaqSubProceso=pstMaqSubProcesos.executeQuery();
                            while(resMaqSubProceso.next())
                            {
                                pstInsertMaqProceso.setInt(1, codSubProcesoPreparado);
                                pstInsertMaqProceso.setInt(2, resMaqSubProceso.getInt("COD_MAQUINA"));
                                if(pstInsertMaqProceso.executeUpdate()>0)LOGGER.info("se registro la maquinaria");
                                resInsertMaqProceso=pstInsertMaqProceso.getGeneratedKeys();
                                if(resInsertMaqProceso.next())codProcesosMaquina=resInsertMaqProceso.getInt(1);
                            }
                        //</editor-fold>
                    }
                //</editor-fold>
            }
            con.commit();
        }
        catch(SQLException ex)
        {try
        {
            con.rollback();
        }
        catch(SQLException es)
        {
            es.printStackTrace();
        }
            ex.printStackTrace();
        }
        
    }

      
    
    
}
