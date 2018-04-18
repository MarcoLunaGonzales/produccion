/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.dao;

import com.cofar.bean.AreasEmpresa;
import com.cofar.bean.Materiales;
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
public class DaoTamanioCapsulaProduccion extends DaoBean{

    public DaoTamanioCapsulaProduccion() {
        LOGGER=LogManager.getLogger("Versionamiento");
    }
    
    public DaoTamanioCapsulaProduccion(Logger LOGGER) {
        this.LOGGER = LOGGER;
    }
    
    public List<SelectItem> listarSelectItem()
    {
        List<SelectItem> tamaniosCapsulasSelectList = new ArrayList<SelectItem>();
        try 
        {
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            String consulta = "select tc.COD_TAMANIO_CAPSULA_PRODUCCION,tc.NOMBRE_TAMANIO_CAPSULA_PRODUCCION"+
                              " from TAMANIOS_CAPSULAS_PRODUCCION tc order by tc.NOMBRE_TAMANIO_CAPSULA_PRODUCCION";
            ResultSet res = st.executeQuery(consulta);
            tamaniosCapsulasSelectList.clear();
            while (res.next())
            {
                tamaniosCapsulasSelectList.add(new SelectItem(res.getInt("COD_TAMANIO_CAPSULA_PRODUCCION"),res.getString("NOMBRE_TAMANIO_CAPSULA_PRODUCCION")));
            }
            res.close();
            st.close();
            con.close();
        }
        catch (SQLException ex) 
        {
            LOGGER.warn(ex.getMessage());
        }
        finally 
        {
            this.cerrarConexion(con);
        }
        return tamaniosCapsulasSelectList;
    }
            
    
}
