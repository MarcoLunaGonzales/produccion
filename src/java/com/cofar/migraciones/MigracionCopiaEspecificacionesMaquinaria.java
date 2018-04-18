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
public class MigracionCopiaEspecificacionesMaquinaria 
{
    /*
    borrar datos antes de migracion
        delete ESPECIFICACIONES_PROCESOS_PRODUCTO_MAQUINARIA  where COD_COMPPROD_VERSION_MAQUINARIA_PROCESO>0
        delete COMPONENTES_PROD_VERSION_MAQUINARIA_PROCESO
        delete INDICACION_PROCESO
        delete COMPONENTES_PROD_VERSION_FILTRO_PRODUCCION
        delete COMPONENTES_PROD_VERSION_LIMPIEZA_MAQUINARIA
        delete componentes_prod_Version_limpieza_seccion
        delete componentes_prod_proceso_orden_manufactura
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
            StringBuilder consulta=new StringBuilder("INSERT INTO COMPONENTES_PROD_VERSION_MAQUINARIA_PROCESO(COD_VERSION, COD_MAQUINA, COD_PROCESO_ORDEN_MANUFACTURA)");
                                    consulta.append("values(?,?,?)");
            PreparedStatement pstInsertMaquina=con.prepareStatement(consulta.toString(),PreparedStatement.RETURN_GENERATED_KEYS);
            ResultSet resInsertMaq;
            
            consulta=new StringBuilder("INSERT INTO ESPECIFICACIONES_PROCESOS_PRODUCTO_MAQUINARIA(");
                        consulta.append(" COD_ESPECIFICACION_PROCESO, VALOR_EXACTO, VALOR_TEXTO");
                        consulta.append(", COD_COMPPROD_VERSION_MAQUINARIA_PROCESO, VALOR_MINIMO, VALOR_MAXIMO,");
                        consulta.append(" COD_TIPO_DESCRIPCION, COD_UNIDAD_MEDIDA, PORCIENTO_TOLERANCIA,");
                        consulta.append(" RESULTADO_ESPERADO_LOTE,ORDEN,COD_TIPO_ESPECIFICACIONES_PROCESOS_PRODUCTO_MAQUINARIA)");
                        consulta.append(" select ep.COD_ESPECIFICACION_PROCESO,(case when ep.ESPECIFICACION_STANDAR_FORMA = 1 then ep.VALOR_EXACTO else rd.VALOR_EXACTO end ),");
                            consulta.append(" (case when ep.ESPECIFICACION_STANDAR_FORMA = 1 THEN ep.VALOR_TEXTO else rd.VALOR_TEXTO end),");
                            consulta.append(" ?,0,0,ep.COD_TIPO_DESCRIPCION,ep.COD_UNIDAD_MEDIDA,ep.PORCIENTO_TOLERANCIA,ep.RESULTADO_ESPERADO_LOTE,ep.ORDEN");
                            consulta.append(" , (case when ep.COD_PROCESO_ORDEN_MANUFACTURA=2 then (case when ep.COD_TIPO_ESPECIFICACION_PROCESO=1 then 2 else 1 end) else 0 end)");
                        consulta.append(" from ESPECIFICACIONES_PROCESOS ep ");
                            consulta.append(" left outer join RECETAS_DESPIROGENIZADO rd on rd.COD_ESPECIFICACION_PROCESO=ep.COD_ESPECIFICACION_PROCESO");
                            consulta.append(" and rd.COD_RECETA=?");
                            consulta.append(" where ep.COD_FORMA=?");
                            consulta.append(" and ep.COD_PROCESO_ORDEN_MANUFACTURA=?");
                        consulta.append(" order by ep.ORDEN");
            PreparedStatement pstInsEsp=con.prepareStatement(consulta.toString());
            LOGGER.debug("consulta regisrtrar especificaciones "+consulta.toString());
            
            consulta=new StringBuilder("INSERT INTO COMPONENTES_PROD_PROCESO_ORDEN_MANUFACTURA(COD_VERSION,COD_FORMA_FARMACEUTICA_PROCESO_ORDEN_MANUFACTURA, ORDEN)");
                        consulta.append(" select ?,f.COD_FORMA_FARMACEUTICA_PROCESO_ORDEN_MANUFACTURA,f.ORDEN");
                        consulta.append(" from  FORMAS_FARMACEUTICAS_PROCESO_ORDEN_MANUFACTURA f where f.COD_FORMA=?");
                        consulta.append(" and f.COD_PROCESO_ORDEN_MANUFACTURA <>4");
            PreparedStatement pstProcesos=con.prepareStatement(consulta.toString());
            
            consulta=new StringBuilder("INSERT INTO COMPONENTES_PROD_VERSION_FILTRO_PRODUCCION(COD_VERSION,COD_FILTRO_PRODUCCION)");
                        consulta.append(" select  ?,fpp.COD_FILTRO_PRODUCCION");
                        consulta.append(" from FILTROS_PRODUCCION_PRODUCTOS fpp where fpp.COD_PROD = ?");
            PreparedStatement pstFiltro=con.prepareStatement(consulta.toString());
            
            consulta=new StringBuilder("INSERT INTO COMPONENTES_PROD_VERSION_LIMPIEZA_MAQUINARIA(COD_VERSION,COD_MAQUINA)");
                    consulta.append(" SELECT ?,C.COD_MAQUINA");
                    consulta.append(" FROM COMPONENTES_PROD_MAQUINARIA_LIMPIEZA C");
                    consulta.append(" WHERE C.COD_COMPPROD=?");
            PreparedStatement pstMaql=con.prepareStatement(consulta.toString());
            
            consulta=new StringBuilder("INSERT INTO COMPONENTES_PROD_VERSION_LIMPIEZA_SECCION(COD_VERSION,COD_SECCION_ORDEN_MANUFACTURA)");
                       consulta.append(" SELECT ?, m.COD_SECCION_ORDEN_MANUFACTURA");
                       consulta.append(" from COMPONENTES_PROD_MAQUINARIA_LIMPIEZA cp ");
                            consulta.append(" inner join MAQUINARIAS m on cp.COD_MAQUINA=m.COD_MAQUINA");
                       consulta.append(" where cp.COD_COMPPROD=?");
                       consulta.append(" group by m.COD_SECCION_ORDEN_MANUFACTURA");
            PreparedStatement pstSecL=con.prepareStatement(consulta.toString());
            
            consulta=new StringBuilder(" INSERT INTO INDICACION_PROCESO( INDICACION_PROCESO,COD_TIPO_INDICACION_PROCESO, COD_PROCESO_ORDEN_MANUFACTURA, COD_VERSION)");
                        consulta.append(" VALUES (?,?,?,?)");
            PreparedStatement pstInsIndicacion=con.prepareStatement(consulta.toString());
            
            consulta=new StringBuilder(" select cp.cod_prod,cp.COD_COMPPROD,cpr.COD_RECETA_DESPIROGENIZADO,cpv.COD_VERSION");
                                consulta.append(" ,dppf.CONDICIONES_GENERALES_DESPIROGENIZADO,cpr.COD_RECETA_DOSIFICADO,cp.COD_FORMA");
                                consulta.append(" ,cpr.COD_RECETA_ESTERILIZACION_CALOR,dppf.PRECAUCIONES_ESTERILIZACION_CALOR_HUMEDO");
                                consulta.append(",dppf.INDICACIONES_ETAPA_ESTERILIZACION_CALOR_HUMEDO,dppf.POST_INDICACIONES_ETAPA_ESTERILIZACION_CALOR_HUMEDO");
                                consulta.append(",'Si el indicador cambio de color coloque ?, sino avise al responsable' as indicacionesPostDespirogenizado");
                                consulta.append(",'Realizar segun POE PRO-LES-IN-017 \"DESPEJE DE LINEA DE TRABAJO\"\nRealizar el despeje de linea y solicitar al Jefe de area la aprobacion de la seccion de trabajo.' as despejelineaEsterilizacion");
                                consulta.append(",dppf.CONDICIONES_GENERALES_REPESADA ");
                                consulta.append(" ,cpr.COD_RECETA_LAVADO,dppf.NOTA_LAVADO,dppf.INDICACIONES_LAVADO,dppf.PRE_INDICACIONES_LAVADO");
                                consulta.append(" ,dppf.PRECAUCIONES_DOSIFICADO,dppf.PRE_INDICACIONES_DOSIFICADO,dppf.INDICACIONES_DOSIFICADO,dppf.POST_INDICACIONES_DOSIFICADO");
                                consulta.append(" ,dppf.PRE_INDICACIONES_CONTROL_LLENADO_VOLUMEN,dppf.INDICACIONES_CONTROL_VOLUMEN_LLENADO");
                                consulta.append(" ,dppf.INDICACIONES_ESTERILIZACION_UTENSILIOS,dppf.INDICACIONES_LIMPIEZA_AMBIENTE,dppf.INDICACIONES_LIMPIEZA_EQUIPOS");
                                consulta.append(" ,'PEGAR LAS ETIQUETAS DE MATERIA PRIMA' as etiquetasMateriaPrima");
                            consulta.append(" from COMPONENTES_PROD cp ");
                                consulta.append(" left outer join COMPONENTES_PROD_RECETA cpr on cpr.COD_COMPROD=cp.COD_COMPPROD");
                                consulta.append(" left outer join COMPONENTES_PROD_VERSION cpv on cpv.COD_COMPPROD=cp.COD_COMPPROD");
                                consulta.append(" left outer join DESCRIPCION_PROCESOS_FORMA_FARMACEUTICA dppf on cp.COD_FORMA=dppf.COD_FORMA");
                            consulta.append(" and cpv.COD_ESTADO_VERSION=2");
                            consulta.append(" where cp.COD_FORMA in (2,25,27)");
                            consulta.append(" and cp.COD_TIPO_PRODUCCION=1");
            LOGGER.debug("consulta registrar datos "+consulta.toString());
            ResultSet res=st.executeQuery(consulta.toString());
            int codMaquinaInsert=0;
            while(res.next())
            {
                
                // <editor-fold defaultstate="collapsed" desc="asociando pasos de proceso">
                pstProcesos.setInt(1,res.getInt("COD_vERSION"));
                pstProcesos.setInt(2,res.getInt("COD_FORMA"));
                if(pstProcesos.executeUpdate()>0)LOGGER.info("se registraron los pasos");
                //</editor-fold>
                /*
                // <editor-fold defaultstate="collapsed" desc="condiciones generales repesada">
                    pstInsIndicacion.setString(1,res.getString("CONDICIONES_GENERALES_REPESADA"));
                    pstInsIndicacion.setInt(2,3);//tipo indicacion
                    pstInsIndicacion.setInt(3,9);//proceso om
                    pstInsIndicacion.setInt(4,res.getInt("COD_VERSION"));
                    if(pstInsIndicacion.executeUpdate()>0)LOGGER.info("se registro la condicion generali"+res.getInt("COD_VERSION"));
                //</editor-fold>
                // <editor-fold defaultstate="collapsed" desc="indicaciones etiqueta materia prima">
                    pstInsIndicacion.setString(1,res.getString("etiquetasMateriaPrima"));
                    pstInsIndicacion.setInt(2,2);//tipo indicacion
                    pstInsIndicacion.setInt(3,16);//proceso om
                    pstInsIndicacion.setInt(4,res.getInt("COD_VERSION"));
                    if(pstInsIndicacion.executeUpdate()>0)LOGGER.info("se registro la condicion generali"+res.getInt("COD_VERSION"));
                //</editor-fold>
                //162 tunel de despirogenizado --TÚNEL DE ESTERILIZACIÓN Y DESPIROGENIZACIÓN LXT10
                //1 proceso de despirogenizado
                // <editor-fold defaultstate="collapsed" desc="Para especificaciones DESPIROGENIZADO">
                    if(res.getInt("COD_RECETA_DESPIROGENIZADO")>0)
                    {
                        // <editor-fold defaultstate="collapsed" desc="registrando condiciones generales despirogenizado">
                            pstInsIndicacion.setString(1,res.getString("CONDICIONES_GENERALES_DESPIROGENIZADO"));
                            pstInsIndicacion.setInt(2,3);
                            pstInsIndicacion.setInt(3,1);
                            pstInsIndicacion.setInt(4,res.getInt("COD_VERSION"));
                            if(pstInsIndicacion.executeUpdate()>0)LOGGER.info("se registro la condicion generali");
                        //</editor-fold>
                        
                        pstInsertMaquina.setInt(1,res.getInt("COD_VERSION"));
                        pstInsertMaquina.setInt(2,162);//maquina tunel de despirogenizado
                        pstInsertMaquina.setInt(3,1);//proceso de despirogenizado
                        if(pstInsertMaquina.executeUpdate()>0)LOGGER.info("se registro la maquinaria");
                        resInsertMaq=pstInsertMaquina.getGeneratedKeys();
                        if(resInsertMaq.next())codMaquinaInsert=resInsertMaq.getInt(1);
                        LOGGER.debug("codcompprod "+codMaquinaInsert);
                        pstInsEsp.setInt(1, codMaquinaInsert);
                        pstInsEsp.setInt(2,res.getInt("COD_RECETA_DESPIROGENIZADO"));
                        pstInsEsp.setInt(3,res.getInt("cod_forma"));
                        pstInsEsp.setInt(4,1);
                        if(pstInsEsp.executeUpdate()>0)LOGGER.info("se registro esp desc");
                    }
                //</editor-fold>
                // <editor-fold defaultstate="collapsed" desc="Para especificaciones de dosificado">
                    if(res.getInt("COD_RECETA_DOSIFICADO")>0)
                    {
                        // <editor-fold defaultstate="collapsed" desc="registrando despeje de linea">
                            pstInsIndicacion.setString(1,res.getString("despejelineaEsterilizacion"));
                            pstInsIndicacion.setInt(2,14);
                            pstInsIndicacion.setInt(3,3);
                            pstInsIndicacion.setInt(4,res.getInt("COD_VERSION"));
                            if(pstInsIndicacion.executeUpdate()>0)LOGGER.info("se registro la condicion generali");
                        //</editor-fold>
                        // <editor-fold defaultstate="collapsed" desc="registrando precauciones dosificado">
                            pstInsIndicacion.setString(1,res.getString("PRECAUCIONES_DOSIFICADO"));
                            pstInsIndicacion.setInt(2,1);
                            pstInsIndicacion.setInt(3,3);
                            pstInsIndicacion.setInt(4,res.getInt("COD_VERSION"));
                            if(pstInsIndicacion.executeUpdate()>0)LOGGER.info("se registro la condicion generali");
                        //</editor-fold>
                        // <editor-fold defaultstate="collapsed" desc="registrando condiciones generales">
                            pstInsIndicacion.setString(1,res.getString("PRE_INDICACIONES_DOSIFICADO"));
                            pstInsIndicacion.setInt(2,3);
                            pstInsIndicacion.setInt(3,3);
                            pstInsIndicacion.setInt(4,res.getInt("COD_VERSION"));
                            if(pstInsIndicacion.executeUpdate()>0)LOGGER.info("se registro la condicion generali");
                        //</editor-fold>    
                        // <editor-fold defaultstate="collapsed" desc="registrando pre especificaciones de maq">
                            pstInsIndicacion.setString(1,res.getString("INDICACIONES_DOSIFICADO"));
                            pstInsIndicacion.setInt(2,11);
                            pstInsIndicacion.setInt(3,3);
                            pstInsIndicacion.setInt(4,res.getInt("COD_VERSION"));
                            if(pstInsIndicacion.executeUpdate()>0)LOGGER.info("se registro la condicion generali");
                        //</editor-fold>    
                        // <editor-fold defaultstate="collapsed" desc="registrando post especificaciones de maq">
                            pstInsIndicacion.setString(1,res.getString("POST_INDICACIONES_DOSIFICADO"));
                            pstInsIndicacion.setInt(2,12);
                            pstInsIndicacion.setInt(3,3);
                            pstInsIndicacion.setInt(4,res.getInt("COD_VERSION"));
                            if(pstInsIndicacion.executeUpdate()>0)LOGGER.info("se registro la condicion generali");
                        //</editor-fold>    
                        
                        pstInsertMaquina.setInt(1,res.getInt("COD_VERSION"));
                        pstInsertMaquina.setInt(2,163);//maquina LLENADORA Y CERRADORA DE AMPOLLAS SD4
                        pstInsertMaquina.setInt(3,3);//proceso de dosificado
                        if(pstInsertMaquina.executeUpdate()>0)LOGGER.info("se registro la maquinaria");
                        resInsertMaq=pstInsertMaquina.getGeneratedKeys();
                        if(resInsertMaq.next())codMaquinaInsert=resInsertMaq.getInt(1);
                        LOGGER.debug("codcompprod "+codMaquinaInsert);
                        pstInsEsp.setInt(1, codMaquinaInsert);
                        pstInsEsp.setInt(2,res.getInt("COD_RECETA_DOSIFICADO"));
                        pstInsEsp.setInt(3,res.getInt("cod_forma"));
                        pstInsEsp.setInt(4,3);
                        if(pstInsEsp.executeUpdate()>0)LOGGER.info("se registro esp desc");
                    }
                //</editor-fold>
                // <editor-fold defaultstate="collapsed" desc="filtros de dosificado">
                pstFiltro.setInt(1,res.getInt("COD_VERSION"));
                pstFiltro.setInt(2,res.getInt("COD_PROD"));
                if(pstFiltro.executeUpdate()>0)LOGGER.info("se duplicaron los filtros");
                //</editor-fold>
                // <editor-fold defaultstate="collapsed" desc="Para especificaciones de esterilizacion calor humedo">
                    if(res.getInt("COD_RECETA_ESTERILIZACION_CALOR")>0)
                    {
                        // <editor-fold defaultstate="collapsed" desc="registrando precauciones esterilizacion">
                            pstInsIndicacion.setString(1,res.getString("PRECAUCIONES_ESTERILIZACION_CALOR_HUMEDO"));
                            pstInsIndicacion.setInt(2,1);//tipo indicacion
                            pstInsIndicacion.setInt(3,4);//proceso
                            pstInsIndicacion.setInt(4,res.getInt("COD_VERSION"));
                            if(pstInsIndicacion.executeUpdate()>0)LOGGER.info("se registro la condicion generali");
                        //</editor-fold>
                            
                        // <editor-fold defaultstate="collapsed" desc="pres especificaciones maquinaria">
                            pstInsIndicacion.setString(1,res.getString("INDICACIONES_ETAPA_ESTERILIZACION_CALOR_HUMEDO"));
                            pstInsIndicacion.setInt(2,11);//tipo indicacion
                            pstInsIndicacion.setInt(3,4);//proceso
                            pstInsIndicacion.setInt(4,res.getInt("COD_VERSION"));
                            if(pstInsIndicacion.executeUpdate()>0)LOGGER.info("se registro la condicion generali");
                        //</editor-fold>
                        // <editor-fold defaultstate="collapsed" desc="post especificaciones maquinaria">
                            pstInsIndicacion.setString(1,res.getString("indicacionesPostDespirogenizado"));
                            pstInsIndicacion.setInt(2,12);//tipo indicacion
                            pstInsIndicacion.setInt(3,4);//proceso
                            pstInsIndicacion.setInt(4,res.getInt("COD_VERSION"));
                            if(pstInsIndicacion.executeUpdate()>0)LOGGER.info("se registro la condicion generali");
                        //</editor-fold>
                        // <editor-fold defaultstate="collapsed" desc="post especificaciones maquinaria">
                            pstInsIndicacion.setString(1,res.getString("POST_INDICACIONES_ETAPA_ESTERILIZACION_CALOR_HUMEDO"));
                            pstInsIndicacion.setInt(2,13);//tipo indicacion
                            pstInsIndicacion.setInt(3,4);//proceso
                            pstInsIndicacion.setInt(4,res.getInt("COD_VERSION"));
                            if(pstInsIndicacion.executeUpdate()>0)LOGGER.info("se registro la condicion generali");
                        //</editor-fold>
                        // <editor-fold defaultstate="collapsed" desc="post especificaciones maquinaria">
                            pstInsIndicacion.setString(1,res.getString("despejelineaEsterilizacion"));
                            pstInsIndicacion.setInt(2,14);//tipo indicacion
                            pstInsIndicacion.setInt(3,4);//proceso
                            pstInsIndicacion.setInt(4,res.getInt("COD_VERSION"));
                            if(pstInsIndicacion.executeUpdate()>0)LOGGER.info("se registro la condicion generali");
                        //</editor-fold>
                            
                        pstInsertMaquina.setInt(1,res.getInt("COD_VERSION"));
                        pstInsertMaquina.setInt(2,44);//maquina TANQUE DE PRESURIZACION
                        pstInsertMaquina.setInt(3,4);//proceso de esterilizacion calor humedo
                        if(pstInsertMaquina.executeUpdate()>0)LOGGER.info("se registro la maquinaria");
                        resInsertMaq=pstInsertMaquina.getGeneratedKeys();
                        if(resInsertMaq.next())codMaquinaInsert=resInsertMaq.getInt(1);
                        LOGGER.debug("codcompprod receta"+codMaquinaInsert);
                        pstInsEsp.setInt(1, codMaquinaInsert);
                        pstInsEsp.setInt(2,res.getInt("COD_RECETA_ESTERILIZACION_CALOR"));
                        pstInsEsp.setInt(3,res.getInt("cod_forma"));
                        pstInsEsp.setInt(4,4);
                        if(pstInsEsp.executeUpdate()>0)LOGGER.info("se registro esp desc");
                    }
                //</editor-fold>
                    
                    
                // <editor-fold defaultstate="collapsed" desc="Para especificaciones LAVADO">
                    // <editor-fold defaultstate="collapsed" desc="registrar nota lavado">
                            pstInsIndicacion.setString(1,res.getString("NOTA_LAVADO"));
                            pstInsIndicacion.setInt(2,5);//tipo indicacion
                            pstInsIndicacion.setInt(3,2);//proceso
                            pstInsIndicacion.setInt(4,res.getInt("COD_VERSION"));
                            if(pstInsIndicacion.executeUpdate()>0)LOGGER.info("se registro la condicion generali");
                        //</editor-fold>
                        // <editor-fold defaultstate="collapsed" desc="registrar indicaciones recepcion de ampollas">
                            pstInsIndicacion.setString(1,res.getString("PRE_INDICACIONES_LAVADO"));
                            pstInsIndicacion.setInt(2,15);//tipo indicacion
                            pstInsIndicacion.setInt(3,2);//proceso
                            pstInsIndicacion.setInt(4,res.getInt("COD_VERSION"));
                            if(pstInsIndicacion.executeUpdate()>0)LOGGER.info("se registro la condicion generali");
                    //</editor-fold>
                            // <editor-fold defaultstate="collapsed" desc="registrando despeje de linea">
                        pstInsIndicacion.setString(1,res.getString("despejelineaEsterilizacion"));
                        pstInsIndicacion.setInt(2,14);
                        pstInsIndicacion.setInt(3,2);
                        pstInsIndicacion.setInt(4,res.getInt("COD_VERSION"));
                        if(pstInsIndicacion.executeUpdate()>0)LOGGER.info("se registro la condicion generali");
                    //</editor-fold>
                    if(res.getInt("COD_RECETA_LAVADO")>0)
                    {
                        
                        // <editor-fold defaultstate="collapsed" desc="pre indicaciones especificacion lavado">
                            pstInsIndicacion.setString(1,res.getString("INDICACIONES_LAVADO"));
                            pstInsIndicacion.setInt(2,11);//tipo indicacion
                            pstInsIndicacion.setInt(3,2);//proceso
                            pstInsIndicacion.setInt(4,res.getInt("COD_VERSION"));
                            if(pstInsIndicacion.executeUpdate()>0)LOGGER.info("se registro la condicion generali");
                        //</editor-fold>
                        
                        pstInsertMaquina.setInt(1,res.getInt("COD_VERSION"));
                        pstInsertMaquina.setInt(2,161);//lavadora de ampollas
                        pstInsertMaquina.setInt(3,2);//proceso de despirogenizado
                        if(pstInsertMaquina.executeUpdate()>0)LOGGER.info("se registro la maquinaria para lavado");
                        resInsertMaq=pstInsertMaquina.getGeneratedKeys();
                        if(resInsertMaq.next())codMaquinaInsert=resInsertMaq.getInt(1);
                        pstInsEsp.setInt(1, codMaquinaInsert);
                        pstInsEsp.setInt(2,res.getInt("COD_RECETA_LAVADO"));
                        pstInsEsp.setInt(3,res.getInt("cod_forma"));
                        pstInsEsp.setInt(4,2);//proceso lavado
                        if(pstInsEsp.executeUpdate()>0)LOGGER.info("se registro esp desc");
                    }
                //</editor-fold>
                // <editor-fold defaultstate="collapsed" desc="control llenado volumen">
                    // <editor-fold defaultstate="collapsed" desc="registrar nota control llenado volumen">
                            pstInsIndicacion.setString(1,res.getString("PRE_INDICACIONES_CONTROL_LLENADO_VOLUMEN"));
                            pstInsIndicacion.setInt(2,5);//tipo indicacion
                            pstInsIndicacion.setInt(3,20);//proceso
                            pstInsIndicacion.setInt(4,res.getInt("COD_VERSION"));
                            if(pstInsIndicacion.executeUpdate()>0)LOGGER.info("se registro la condicion generali");
                    //</editor-fold>
                    // <editor-fold defaultstate="collapsed" desc="registrar frecuencia de muestreo">
                            pstInsIndicacion.setString(1,res.getString("INDICACIONES_CONTROL_VOLUMEN_LLENADO"));
                            pstInsIndicacion.setInt(2,16);//tipo indicacion
                            pstInsIndicacion.setInt(3,20);//proceso
                            pstInsIndicacion.setInt(4,res.getInt("COD_VERSION"));
                            if(pstInsIndicacion.executeUpdate()>0)LOGGER.info("se registro la condicion generali");
                    //</editor-fold>
                //</editor-fold>
                // <editor-fold defaultstate="collapsed" desc="limpieza ambientes">
                    // <editor-fold defaultstate="collapsed" desc="registrar nota indicaciones limpieza utensilios">
                            pstInsIndicacion.setString(1,res.getString("INDICACIONES_ESTERILIZACION_UTENSILIOS"));
                            pstInsIndicacion.setInt(2,19);//tipo indicacion
                            pstInsIndicacion.setInt(3,11);//proceso
                            pstInsIndicacion.setInt(4,res.getInt("COD_VERSION"));
                            if(pstInsIndicacion.executeUpdate()>0)LOGGER.info("se registro la condicion generali");
                    //</editor-fold>
                    // <editor-fold defaultstate="collapsed" desc="registrar indicaicones limpieza equipos">
                            pstInsIndicacion.setString(1,res.getString("INDICACIONES_LIMPIEZA_EQUIPOS"));
                            pstInsIndicacion.setInt(2,18);//tipo indicacion
                            pstInsIndicacion.setInt(3,11);//proceso
                            pstInsIndicacion.setInt(4,res.getInt("COD_VERSION"));
                            if(pstInsIndicacion.executeUpdate()>0)LOGGER.info("se registro la condicion generali");
                    //</editor-fold>
                    // <editor-fold defaultstate="collapsed" desc="registrar indicaicones limpieza ambientes">
                            pstInsIndicacion.setString(1,res.getString("INDICACIONES_LIMPIEZA_AMBIENTE"));
                            pstInsIndicacion.setInt(2,17);//tipo indicacion
                            pstInsIndicacion.setInt(3,11);//proceso
                            pstInsIndicacion.setInt(4,res.getInt("COD_VERSION"));
                            if(pstInsIndicacion.executeUpdate()>0)LOGGER.info("se registro la condicion generali");
                    //</editor-fold>
                    pstMaql.setInt(1,res.getInt("COD_VERSION"));
                    pstMaql.setInt(2,res.getInt("COD_COMPPROD"));
                    if(pstMaql.executeUpdate()>0)LOGGER.info("se registro maquinaria limpieza");
                    pstSecL.setInt(1,res.getInt("COD_VERSION"));
                    pstSecL.setInt(2,res.getInt("COD_COMPPROD"));
                    if(pstSecL.executeUpdate()>0)LOGGER.info("se registro las secciones limpieza");
                //</editor-fold>
                        */
                    con.commit();
            }
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
