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
public class MigracionSubEspecificacionesMaquinaria 
{
    

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
            StringBuilder consulta=new StringBuilder("INSERT INTO PROCESOS_PREPARADO_PRODUCTO_ESPECIFICACIONES_MAQUINARIA(");
                                    consulta.append("  COD_PROCESO_PREPARADO_PRODUCTO_MAQUINARIA,");
                                    consulta.append("  COD_ESPECIFICACION_PROCESO,");
                                    consulta.append("  VALOR_EXACTO,");
                                    consulta.append("  VALOR_MINIMO,");
                                    consulta.append("  VALOR_MAXIMO,");
                                    consulta.append("  VALOR_TEXTO,");
                                    consulta.append("  COD_TIPO_DESCRIPCION,");
                                    consulta.append("  COD_UNIDAD_MEDIDA,");
                                    consulta.append("  PORCIENTO_TOLERANCIA,");
                                    consulta.append("  RESULTADO_ESPERADO_LOTE");
                                    consulta.append(")");
                                consulta.append(" select ?,a.cod_especificacion,sppeq.VALOR_EXACTO,sppeq.RANGO_INFERIOR,sppeq.RANGO_SUPERIOR,");
                                consulta.append(" sppeq.VALOR_DESCRIPTIVO,eqp.COD_TIPO_DESCRIPCION,eqp.COD_UNIDAD_MEDIDA,");
                                consulta.append("  sppeq.PORCIENTO_TOLERANCIA,sppeq.DATOS_NO_CONSOLIDADOS");
                                consulta.append(" from SUB_PROCESOS_PRODUCTO spp ");
                                consulta.append(" inner join PROCESOS_PRODUCTO pp on spp.COD_PROCESO_PRODUCTO=pp.COD_PROCESO_PRODUCTO");
                                consulta.append(" INNER JOIN SUB_PROCESOS_PRODUCTO_ESP_EQUIP sppeq on sppeq.COD_SUB_PROCESO_PRODUCTO=spp.COD_SUB_PROCESO_PRODUCTO");
                                consulta.append(" and pp.COD_PROCESO_PRODUCTO=sppeq.COD_PROCESO_PRODUCTO");
                                consulta.append(" inner join auxmigracionatlas a on a.cod_especificacion_ambiente=sppeq.COD_ESPECIFICACION_EQUIPO_AMBIENTE");
                                consulta.append(" inner join ESPECIFICACIONES_EQUIPO_AMBIENTE eqp on eqp.COD_ESPECIFICACION_EQUIPO_AMBIENTE=a.cod_especificacion_ambiente");
                                consulta.append(" where pp.NRO_PASO=?");
                                consulta.append(" and spp.NRO_PASO=?");
                                consulta.append(" and pp.COD_COMPPROD=?");
                                consulta.append(" and sppeq.COD_MAQUINA=?");
            PreparedStatement pstInsertMaquina=con.prepareStatement(consulta.toString(),PreparedStatement.RETURN_GENERATED_KEYS);
            
            consulta=new StringBuilder(" select cpv.COD_VERSION,cpv.nombre_prod_semiterminado,cpv.COD_COMPPROD,pp.NRO_PASO as nroSubPaso,pp1.NRO_PASO,ppm.COD_PROCESO_PREPARADO_PRODUCTO_MAQUINARIA,ppm.COD_MAQUINA");
                            consulta.append(" from PROCESOS_PREPARADO_PRODUCTO pp");
                            consulta.append(" inner join PROCESOS_PREPARADO_PRODUCTO pp1 on pp.COD_PROCESO_PREPARADO_PRODUCTO_PADRE=pp1.COD_PROCESO_PREPARADO_PRODUCTO");
                            consulta.append(" inner join COMPONENTES_PROD_VERSION cpv on cpv.COD_VERSION=pp1.COD_VERSION");
                            consulta.append(" inner join PROCESOS_PREPARADO_PRODUCTO_MAQUINARIA ppm on ppm.COD_PROCESO_PREPARADO_PRODUCTO=pp.COD_PROCESO_PREPARADO_PRODUCTO");
                            consulta.append(" order by cpv.nombre_prod_semiterminado");
            LOGGER.debug("consulta registrar datos "+consulta.toString());
            ResultSet res=st.executeQuery(consulta.toString());
            int codMaquinaInsert=0;
            while(res.next())
            {
                pstInsertMaquina.setInt(1,res.getInt("COD_PROCESO_PREPARADO_PRODUCTO_MAQUINARIA"));
                pstInsertMaquina.setInt(2,res.getInt("NRO_PASO"));
                pstInsertMaquina.setInt(3,res.getInt("nroSubPaso"));
                pstInsertMaquina.setInt(4,res.getInt("COD_COMPPROD"));
                pstInsertMaquina.setInt(5,res.getInt("COD_MAQUINA"));
                if(pstInsertMaquina.executeUpdate()>0)LOGGER.info("se registro");
                        
            }
            con.commit();
        }
        catch(SQLException ex)
        {
            try
            {
            con.rollback();
            }
            catch(SQLException e)
            {
                e.printStackTrace();
            }
            ex.printStackTrace();
        }
        finally
        {
            try {
                con.close();
            } catch (SQLException ex) {
               ex.printStackTrace();
            }
        }
        
    }

      
    
    
}
