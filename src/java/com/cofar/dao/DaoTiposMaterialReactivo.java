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
public class DaoTiposMaterialReactivo extends DaoBean 
{
    public DaoTiposMaterialReactivo() {
        LOGGER=LogManager.getRootLogger();
    }
    public DaoTiposMaterialReactivo(Logger LOGGER) {
        this.LOGGER = LOGGER;
    }
    public List<SelectItem> listarSelectItem()
    {
        List<SelectItem> selectItemList = new ArrayList<>();
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select tmr.COD_TIPO_MATERIAL_REACTIVO,tmr.NOMBRE_TIPO_MATERIAL_REACTIVO")
                                                .append(" from TIPOS_MATERIAL_REACTIVO tmr")
                                                .append(" where tmr.COD_ESTADO_REGISTRO=1")
                                                .append(" order by tmr.NOMBRE_TIPO_MATERIAL_REACTIVO");
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            while (res.next()) 
            {
                selectItemList.add(new SelectItem(res.getString("COD_TIPO_MATERIAL_REACTIVO"),res.getString("NOMBRE_TIPO_MATERIAL_REACTIVO")));
            }
            res.close();
            st.close();
        } catch (SQLException ex) {
            LOGGER.warn("error", ex);
        } catch (Exception ex) {
            LOGGER.warn("error", ex);
        } finally {
            this.cerrarConexion(con);
        }
        return selectItemList;
    }
    
}
