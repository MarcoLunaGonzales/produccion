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
public class DaoActividadesPreparado extends DaoBean{
    
    public DaoActividadesPreparado() {
        LOGGER = LogManager.getRootLogger();
    }
    public DaoActividadesPreparado(Logger LOGGER) {
        this.LOGGER = LOGGER;
    }
    
    public List<SelectItem> listarSelectItem()
    {
        List<SelectItem> actividadesSelectList = new ArrayList<>();
        try 
        {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select ap.COD_ACTIVIDAD_PREPARADO,ap.NOMBRE_ACTIVIDAD_PREPARADO");
                                       consulta.append(" from ACTIVIDADES_PREPARADO ap");
                                       consulta.append(" where ap.COD_FORMA=0");
                                       consulta.append(" order by ap.NOMBRE_ACTIVIDAD_PREPARADO");
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            while (res.next()) 
            {
                actividadesSelectList.add(new SelectItem(res.getInt("COD_ACTIVIDAD_PREPARADO"),res.getString("NOMBRE_ACTIVIDAD_PREPARADO")));
                
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
        return actividadesSelectList;
    }
    
}
