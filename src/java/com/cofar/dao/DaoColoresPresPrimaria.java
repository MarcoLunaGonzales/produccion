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
public class DaoColoresPresPrimaria extends DaoBean{

    public DaoColoresPresPrimaria() {
        LOGGER=LogManager.getLogger("Versionamiento");
    }
    
    public DaoColoresPresPrimaria(Logger LOGGER) {
        this.LOGGER = LOGGER;
    }
    
    public List<SelectItem> listarSelectItem()
    {
        List<SelectItem> coloresPresPrimSelectList = new ArrayList<SelectItem>();
        try 
        {
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            String consulta = "select cp.COD_COLORPRESPRIMARIA,cp.NOMBRE_COLORPRESPRIMARIA from COLORES_PRESPRIMARIA cp order by cp.NOMBRE_COLORPRESPRIMARIA";
            ResultSet res = st.executeQuery(consulta);
            coloresPresPrimSelectList.clear();
            while (res.next()) 
            {
                coloresPresPrimSelectList.add(new SelectItem(res.getString("COD_COLORPRESPRIMARIA"),res.getString("NOMBRE_COLORPRESPRIMARIA")));
            }
        }
        catch (SQLException ex) 
        {
            LOGGER.warn(ex.getMessage());
        }
        finally 
        {
            this.cerrarConexion(con);
        }
        return coloresPresPrimSelectList;
    }
            
    
}
