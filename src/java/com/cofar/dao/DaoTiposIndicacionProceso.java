/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.dao;

import com.cofar.bean.IndicacionProceso;
import com.cofar.util.Util;
import java.util.List;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import javax.faces.model.SelectItem;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/**
 *
 * @author DASISAQ
 */
public class DaoTiposIndicacionProceso extends DaoBean{

    public DaoTiposIndicacionProceso() {
        this.LOGGER = LogManager.getRootLogger();
    }
    public DaoTiposIndicacionProceso(Logger LOGGER) {
        this.LOGGER = LOGGER;
    }
    
    public List<SelectItem> listarSelectItem(){
        List<SelectItem> tiposIndicacionSelectList = new ArrayList<>();
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("SELECT tip.COD_TIPO_INDICACION_PROCESO,tip.NOMBRE_TIPO_INDICACION_PROCESO");
                                        consulta.append(" FROM TIPOS_INDICACION_PROCESO tip ");
                                        consulta.append(" order by tip.NOMBRE_TIPO_INDICACION_PROCESO");
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            while (res.next()) 
            {
                tiposIndicacionSelectList.add(new SelectItem(res.getInt("COD_TIPO_INDICACION_PROCESO"),res.getString("NOMBRE_TIPO_INDICACION_PROCESO")));
            }
            st.close();
        } catch (SQLException ex) {
            LOGGER.warn("error", ex);
        } finally {
            this.cerrarConexion(con);
        }
        return tiposIndicacionSelectList;
    }
    public List<SelectItem> listarNoUtilizadoSelectItem(IndicacionProceso indicacionProcesos){
        List<SelectItem> tiposIndicacionSelectList = new ArrayList<>();
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select tip.COD_TIPO_INDICACION_PROCESO,tip.NOMBRE_TIPO_INDICACION_PROCESO");
                                        consulta.append(" from TIPOS_INDICACION_PROCESO tip");
                                        consulta.append(" where tip.COD_TIPO_INDICACION_PROCESO in ");
                                            consulta.append(" (");
                                                consulta.append(" select ffi.COD_TIPO_INDICACION_PROCESO from FORMAS_FARMACEUTICAS_INDICACIONES ffi where ffi.COD_FORMA=").append(indicacionProcesos.getComponentesProdVersion().getForma().getCodForma());
                                                    consulta.append("  and ffi.COD_PROCESO_ORDEN_MANUFACTURA=").append(indicacionProcesos.getProcesosOrdenManufactura().getCodProcesoOrdenManufactura());
                                            consulta.append(" )");
                                            consulta.append(" and tip.COD_TIPO_INDICACION_PROCESO not in ");
                                            consulta.append(" (");
                                                consulta.append(" select i.COD_TIPO_INDICACION_PROCESO from INDICACION_PROCESO i where i.COD_VERSION=").append(indicacionProcesos.getComponentesProdVersion().getCodVersion());
                                                    consulta.append(" and i.COD_PROCESO_ORDEN_MANUFACTURA=").append(indicacionProcesos.getProcesosOrdenManufactura().getCodProcesoOrdenManufactura());
                                            consulta.append(" )");
                                        consulta.append(" order by tip.NOMBRE_TIPO_INDICACION_PROCESO");
            LOGGER.debug("consulta cargar procesos pendientes "+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            while (res.next()) 
            {
                tiposIndicacionSelectList.add(new SelectItem(res.getInt("COD_TIPO_INDICACION_PROCESO"),res.getString("NOMBRE_TIPO_INDICACION_PROCESO")));
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
        return tiposIndicacionSelectList;
    }
    
}
