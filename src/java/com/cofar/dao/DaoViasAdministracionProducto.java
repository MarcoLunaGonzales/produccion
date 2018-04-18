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
public class DaoViasAdministracionProducto extends DaoBean{

    public DaoViasAdministracionProducto() {
        LOGGER=LogManager.getRootLogger();
    }
    
    public DaoViasAdministracionProducto(Logger LOGGER) {
        this.LOGGER = LOGGER;
    }
    
    public List<SelectItem> listarSelectItem()
    {
        List<SelectItem> viasAdministracionSelectList = new ArrayList<SelectItem>();
        try 
        {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select vip.COD_VIA_ADMINISTRACION_PRODUCTO,vip.NOMBRE_VIA_ADMINISTRACION_PRODUCTO");
                                        consulta.append(" from VIAS_ADMINISTRACION_PRODUCTO vip");
                                        consulta.append(" where vip.COD_ESTADO_REGISTRO=1");
                                        consulta.append(" order by vip.NOMBRE_VIA_ADMINISTRACION_PRODUCTO");
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            viasAdministracionSelectList=new ArrayList<SelectItem>();
            while (res.next()) 
            {
                viasAdministracionSelectList.add(new SelectItem(res.getInt("COD_VIA_ADMINISTRACION_PRODUCTO"),res.getString("NOMBRE_VIA_ADMINISTRACION_PRODUCTO")));
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
        return viasAdministracionSelectList;
    }
            
    
}
