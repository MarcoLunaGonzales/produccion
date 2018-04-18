/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.dao;

import com.cofar.bean.Materiales;
import com.cofar.bean.TiposProgramaProduccion;
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
public class DaoTiposProgramaProduccion extends DaoBean{

    public DaoTiposProgramaProduccion() {
        LOGGER=LogManager.getRootLogger();
    }
    public DaoTiposProgramaProduccion(Logger LOGGER) {
        this.LOGGER = LOGGER;
    }
    
    public List<SelectItem> listarSelectItem()
    {
        List<SelectItem> selectItemList=new ArrayList<SelectItem>();
        try 
        {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select tpp.COD_TIPO_PROGRAMA_PROD,tpp.NOMBRE_TIPO_PROGRAMA_PROD");
                                        consulta.append(" from TIPOS_PROGRAMA_PRODUCCION tpp");
                                        consulta.append(" order by tpp.NOMBRE_TIPO_PROGRAMA_PROD");
            LOGGER.debug(" consulta cargar tipos programa produccion "+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            while(res.next()) 
            {
                selectItemList.add(new SelectItem(res.getInt("COD_TIPO_PROGRAMA_PROD"),res.getString("NOMBRE_TIPO_PROGRAMA_PROD")));
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
        return selectItemList;
    }
    
}
