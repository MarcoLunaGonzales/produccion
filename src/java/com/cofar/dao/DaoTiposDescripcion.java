/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.dao;

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
public class DaoTiposDescripcion extends DaoBean{
    
    public DaoTiposDescripcion() {
        LOGGER = LogManager.getRootLogger();
    }
    
    public DaoTiposDescripcion(Logger LOGGER) {
        this.LOGGER = LOGGER;
    }
    public List<SelectItem> listarSelectItem()
    {
        List<SelectItem> tiposDescripcionList = new ArrayList<>();
        try 
        {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select td.COD_TIPO_DESCRIPCION,td.NOMBRE_TIPO_DESCRIPCION");
                                    consulta.append(" from TIPOS_DESCRIPCION td");
                                    consulta.append(" order by td.NOMBRE_TIPO_DESCRIPCION");
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            while (res.next()) 
            {
                tiposDescripcionList.add(new SelectItem(res.getInt("COD_TIPO_DESCRIPCION"),res.getString("NOMBRE_TIPO_DESCRIPCION")));
            }
            st.close();
        } catch (SQLException ex) {
            LOGGER.warn("error", ex);
        } finally {
            this.cerrarConexion(con);
        }
        return tiposDescripcionList;
    }
    
}
