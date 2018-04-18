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
public class DaoCondicionesVentaProducto extends DaoBean{

    public DaoCondicionesVentaProducto() {
        LOGGER=LogManager.getLogger("Versionamiento");
    }
    
    public DaoCondicionesVentaProducto(Logger LOGGER) {
        this.LOGGER = LOGGER;
    }
    
    public List<SelectItem> listarSelectItem()
    {
        List<SelectItem> condicionesVentaSelectList=new ArrayList<SelectItem>();
        try 
        {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select cvp.COD_CONDICION_VENTA_PRODUCTO,cvp.NOMBRE_CONDICION_VENTA_PRODUCTO")
                                                .append(" from CONDICIONES_VENTA_PRODUCTO cvp ")
                                                .append(" order by cvp.NOMBRE_CONDICION_VENTA_PRODUCTO");
            LOGGER.debug("consulta cargar condiciones ventas : "+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            while(res.next()) 
            {
                condicionesVentaSelectList.add(new SelectItem(res.getInt("COD_CONDICION_VENTA_PRODUCTO"),res.getString("NOMBRE_CONDICION_VENTA_PRODUCTO")));
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
        return condicionesVentaSelectList;
    }
            
    
}
