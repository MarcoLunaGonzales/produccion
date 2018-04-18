/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.dao;

import com.cofar.bean.ComponentesProdVersion;
import com.cofar.util.Util;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import javax.faces.model.SelectItem;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/**
 *
 * @author DASISAQ
 */
public class DaoSeccionesOrdenManufactura extends DaoBean{

    public DaoSeccionesOrdenManufactura() {
        this.LOGGER = LogManager.getRootLogger();
    }
    
    public DaoSeccionesOrdenManufactura(Logger LOGGER) {
        this.LOGGER = LOGGER;
    }
    
    public List<SelectItem> listarSelectItemNoVersion(ComponentesProdVersion componentesProdVersion){
        List<SelectItem> seccionesSelectList = new ArrayList<>();
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select som.COD_SECCION_ORDEN_MANUFACTURA,som.NOMBRE_SECCION_ORDEN_MANUFACTURA+' ('+som.DESCRIPCION_SECCION_ORDEN_MANUFACTURA+')' as seccion");
                                        consulta.append(" from SECCIONES_ORDEN_MANUFACTURA som");
                                        consulta.append(" where som.COD_ESTADO_REGISTRO=1");
                                                consulta.append(" and som.COD_SECCION_ORDEN_MANUFACTURA not in (");
                                                        consulta.append(" select c.COD_SECCION_ORDEN_MANUFACTURA");
                                                        consulta.append(" from COMPONENTES_PROD_VERSION_LIMPIEZA_SECCION c where c.COD_AREA_EMPRESA=97");
                                                                consulta.append(" and c.COD_VERSION=").append(componentesProdVersion.getCodVersion());
                                                consulta.append(")");
                                        consulta.append(" order  by som.NOMBRE_SECCION_ORDEN_MANUFACTURA");
            LOGGER.debug("consulta cargar secciones Om select " + consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            while (res.next()) 
            {
                seccionesSelectList.add(new SelectItem(res.getInt("COD_SECCION_ORDEN_MANUFACTURA"),res.getString("seccion")));
            }
            res.close();
            st.close();
        } catch (SQLException ex) {
            LOGGER.warn(ex.getMessage());
        } catch (NumberFormatException ex) {
            LOGGER.warn(ex.getMessage());
        } finally {
            this.cerrarConexion(con);
        } 
        return seccionesSelectList;
    }
    
}
