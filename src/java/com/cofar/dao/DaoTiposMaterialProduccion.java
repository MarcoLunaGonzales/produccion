/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.dao;

import com.cofar.bean.ComponentesProd;
import com.cofar.bean.TiposMaterialProduccion;
import com.cofar.util.Util;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import org.apache.logging.log4j.Logger;

/**
 *
 * @author DASISAQ
 */
public class DaoTiposMaterialProduccion extends DaoBean 
{

    public DaoTiposMaterialProduccion(Logger logger) {
        this.LOGGER = logger;
    }
    
    public List<TiposMaterialProduccion> listar()
    {
        List<TiposMaterialProduccion> tiposMaterialProduccionList = new ArrayList<TiposMaterialProduccion>();
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select tmp.COD_TIPO_MATERIAL_PRODUCCION,tmp.NOMBRE_TIPO_MATERIAL_PRODUCCION")
                                            .append(" from TIPOS_MATERIAL_PRODUCCION tmp")
                                            .append(" order by tmp.NOMBRE_TIPO_MATERIAL_PRODUCCION");
            LOGGER.debug("consulta cargar tipos material produccion "+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            while (res.next())
            {
                TiposMaterialProduccion bean = new TiposMaterialProduccion();
                bean.setCodTipoMaterialProduccion(res.getInt("COD_TIPO_MATERIAL_PRODUCCION"));
                bean.setNombreTipoMaterialProduccion(res.getString("NOMBRE_TIPO_MATERIAL_PRODUCCION"));
                tiposMaterialProduccionList.add(bean);
            }
            
        } catch (SQLException ex) {
            LOGGER.warn(ex.getMessage());
        } catch (NumberFormatException ex) {
            LOGGER.warn(ex.getMessage());
        } finally {
            this.cerrarConexion(con);
        }
        return tiposMaterialProduccionList;
    }
    
}
