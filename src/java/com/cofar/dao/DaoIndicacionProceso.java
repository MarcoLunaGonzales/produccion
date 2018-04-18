/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.dao;

import com.cofar.bean.IndicacionProceso;
import com.cofar.util.Util;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/**
 *
 * @author DASISAQ
 */
public class DaoIndicacionProceso extends DaoBean{

    public DaoIndicacionProceso() {
        this.LOGGER = LogManager.getRootLogger();
    }
    
    public DaoIndicacionProceso(Logger LOGGER) {
        this.LOGGER = LOGGER;
    }
    
    public List<IndicacionProceso> listar(IndicacionProceso indicacionProceso){
        List<IndicacionProceso> indicacionProcesoList = new ArrayList<>();
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select pom.COD_PROCESO_ORDEN_MANUFACTURA,pom.NOMBRE_PROCESO_ORDEN_MANUFACTURA,ip.COD_INDICACION_PROCESO,");
                                            consulta.append(" ip.INDICACION_PROCESO,tid.COD_TIPO_INDICACION_PROCESO,tid.NOMBRE_TIPO_INDICACION_PROCESO");
                                        consulta.append(" from PROCESOS_ORDEN_MANUFACTURA pom ");
                                            consulta.append(" inner join INDICACION_PROCESO ip on ip.COD_PROCESO_ORDEN_MANUFACTURA=pom.COD_PROCESO_ORDEN_MANUFACTURA");
                                            consulta.append(" inner join TIPOS_INDICACION_PROCESO tid on tid.COD_TIPO_INDICACION_PROCESO=ip.COD_TIPO_INDICACION_PROCESO");
                                        consulta.append(" where ip.COD_VERSION=").append(indicacionProceso.getComponentesProdVersion().getCodVersion());
                                            consulta.append(" and ip.COD_PROCESO_ORDEN_MANUFACTURA=").append(indicacionProceso.getProcesosOrdenManufactura().getCodProcesoOrdenManufactura());
                                        consulta.append(" order by pom.NOMBRE_PROCESO_ORDEN_MANUFACTURA");
            LOGGER.debug("consulta cargar indicaciones proceso "+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            while (res.next()) 
            {
                IndicacionProceso nuevo=new IndicacionProceso();
                nuevo.getProcesosOrdenManufactura().setCodProcesoOrdenManufactura(res.getInt("COD_PROCESO_ORDEN_MANUFACTURA"));
                nuevo.setCodIndicacionProceso(res.getInt("COD_INDICACION_PROCESO"));
                nuevo.setIndicacionProceso(res.getString("INDICACION_PROCESO"));
                nuevo.getTiposIndicacionProceso().setCodTipoIndicacionProceso(res.getInt("COD_TIPO_INDICACION_PROCESO"));
                nuevo.getTiposIndicacionProceso().setNombreTipoIndicacionProceso(res.getString("NOMBRE_TIPO_INDICACION_PROCESO"));
                indicacionProcesoList.add(nuevo);
            }
            st.close();
        } 
        catch (SQLException ex) 
        {
            LOGGER.warn("error", ex);
        }
        finally 
        {
            this.cerrarConexion(con);
        }
        return indicacionProcesoList;
    }
    
    public boolean modificar(IndicacionProceso indicacionProceso)throws SQLException{
        LOGGER.debug("--------------------------------------INICIO MODIFICAR INDICACION PROCESO----------------------------");
        boolean modificado = false;
        try 
        {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta = new StringBuilder("UPDATE INDICACION_PROCESO");
                                        consulta.append(" SET INDICACION_PROCESO=?");
                                        consulta.append(" WHERE COD_INDICACION_PROCESO=").append(indicacionProceso.getCodIndicacionProceso());
            LOGGER.debug("consulta update indicacion proceso " + consulta.toString()+" "+indicacionProceso.getIndicacionProceso());
            PreparedStatement pst = con.prepareStatement(consulta.toString());
            pst.setString(1,indicacionProceso.getIndicacionProceso());
            if(pst.executeUpdate() > 0)LOGGER.info("Se edito la indicación");
            con.commit();
            modificado = true;
        } 
        catch (SQLException ex) 
        {
            modificado = false;
            LOGGER.warn(ex.getMessage());
            con.rollback();
        }
        catch (NumberFormatException ex) 
        {
            modificado = false;
            LOGGER.warn(ex.getMessage());
            con.rollback();
        }
        finally 
        {
            con.close();
        }
        LOGGER.debug("--------------------------------------TERMINO MODIFICAR INDICACION PROCESO----------------------------");
        return modificado;
    }
    
    public boolean guardar(IndicacionProceso indicacionProceso)throws SQLException{
        LOGGER.debug("--------------------------------------INICIO REGISTRAR INDICACION PROCESO----------------------------");
        boolean guardado = false;
        try 
        {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta = new StringBuilder("INSERT INTO INDICACION_PROCESO( INDICACION_PROCESO,COD_TIPO_INDICACION_PROCESO, COD_PROCESO_ORDEN_MANUFACTURA, COD_VERSION)");
                                        consulta.append(" VALUES (")
                                                .append("?,")//indicacion proceso
                                                .append(indicacionProceso.getTiposIndicacionProceso().getCodTipoIndicacionProceso()).append(",")
                                                .append(indicacionProceso.getProcesosOrdenManufactura().getCodProcesoOrdenManufactura()).append(",")
                                                .append(indicacionProceso.getComponentesProdVersion().getCodVersion())
                                            .append(")");
            LOGGER.debug("consulta registrar indicacion proceso " + consulta.toString());
            PreparedStatement pst = con.prepareStatement(consulta.toString());
            pst.setString(1,indicacionProceso.getIndicacionProceso());LOGGER.info("p1: "+indicacionProceso.getIndicacionProceso());
            if(pst.executeUpdate() > 0)LOGGER.info("Se registro la indicacion");
            con.commit();
            guardado = true;
        } 
        catch (SQLException ex) 
        {
            guardado = false;
            LOGGER.warn(ex);
            con.rollback();
        }
        catch (NumberFormatException ex) 
        {
            guardado = false;
            LOGGER.warn(ex);
            con.rollback();
        }
        finally 
        {
            this.cerrarConexion(con);
        }
        LOGGER.debug("--------------------------------------TERMINO REGISTRAR INDICACION PROCESO----------------------------");
        return guardado;
    }
    
    public boolean eliminar(int codIndicacionProceso)throws SQLException{
        LOGGER.debug("--------------------------------------INICIO ELIMINAR INDICACION PROCESO----------------------------");
        boolean eliminado = false;
        try 
        {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta = new StringBuilder("DELETE INDICACION_PROCESO");
                                     consulta.append(" where COD_INDICACION_PROCESO=").append(codIndicacionProceso);
            LOGGER.debug("consulta eliminar indicacion" + consulta.toString());
            PreparedStatement pst = con.prepareStatement(consulta.toString(), PreparedStatement.RETURN_GENERATED_KEYS);
            if (pst.executeUpdate() > 0) LOGGER.info("Se elimino la indicacion");
            con.commit();
            eliminado = true;
        } 
        catch (SQLException ex) 
        {
            eliminado = false;
            LOGGER.warn(ex);
            con.rollback();
        }
        catch (NumberFormatException ex) 
        {
            eliminado = false;
            LOGGER.warn(ex);
            con.rollback();
        }
        finally 
        {
            this.cerrarConexion(con);
        }
        LOGGER.debug("--------------------------------------TERMINO ELIMINAR INDICACION PROCESO----------------------------");
        return eliminado;
    }
    
}
