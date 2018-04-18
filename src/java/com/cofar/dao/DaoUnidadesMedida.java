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
public class DaoUnidadesMedida extends DaoBean{
    public DaoUnidadesMedida() {
        LOGGER = LogManager.getRootLogger();
    }
    
    public DaoUnidadesMedida(Logger LOGGER) {
        this.LOGGER = LOGGER;
    }
    public List<SelectItem> listarSelectItem()
    {
        List<SelectItem> unidadesMedidaSelectList = new ArrayList<>();
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select um.COD_UNIDAD_MEDIDA,um.NOMBRE_UNIDAD_MEDIDA+' ('+um.ABREVIATURA+')' AS unidadMedida");
                                       consulta.append(" from UNIDADES_MEDIDA um");
                                       consulta.append(" where um.COD_ESTADO_REGISTRO=1");
                                    consulta.append(" order by um.NOMBRE_UNIDAD_MEDIDA");
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            while (res.next()) 
            {
                unidadesMedidaSelectList.add(new SelectItem(res.getString("COD_UNIDAD_MEDIDA"),res.getString("unidadMedida")));
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
        return unidadesMedidaSelectList;
    }
    
}
