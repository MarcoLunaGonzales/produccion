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
import org.apache.logging.log4j.Logger;

/**
 *
 * @author DASISAQ
 */
public class DaoTiposEspecificacionesFisicas  extends DaoBean{

    public DaoTiposEspecificacionesFisicas() {
    }
    
    public DaoTiposEspecificacionesFisicas(Logger LOGGER) {
        this.LOGGER = LOGGER;
    }
    
    
    public List<SelectItem> listarSelectItem()
    {
        List<SelectItem> selectItemList = new ArrayList<>();
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select tef.COD_TIPO_ESPECIFICACION_FISICA,tef.NOMBRE_TIPO_ESPECIFICACION_FISICA ")
                                                .append(" from TIPOS_ESPECIFICACIONES_FISICAS tef")
                                                .append(" order by tef.NOMBRE_TIPO_ESPECIFICACION_FISICA");
            LOGGER.debug("consulta cargar listar select: "+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta.toString());
            while(res.next())
            {
                selectItemList.add(new SelectItem(res.getInt("COD_TIPO_ESPECIFICACION_FISICA"),res.getString("NOMBRE_TIPO_ESPECIFICACION_FISICA")));
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
