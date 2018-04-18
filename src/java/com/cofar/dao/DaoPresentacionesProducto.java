/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.dao;

import com.cofar.bean.Materiales;
import com.cofar.bean.PresentacionesProducto;
import com.cofar.bean.TiposProgramaProduccion;
import com.cofar.util.Util;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import javax.faces.model.SelectItem;
import org.apache.logging.log4j.LogManager;

/**
 *
 * @author DASISAQ
 */
public class DaoPresentacionesProducto extends DaoBean{

    public DaoPresentacionesProducto() {
        LOGGER=LogManager.getRootLogger();
    }
    
    
    public List<SelectItem> listarPresentacionesProductoSelectList()
    {
        List<SelectItem> presentacionesProductoSelectList=new ArrayList<SelectItem>();
        try{
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select pp.cod_presentacion,pp.NOMBRE_PRODUCTO_PRESENTACION");
                                        consulta.append(" from PRESENTACIONES_PRODUCTO pp");
                                                consulta.append(" inner join ESTADOS_PRESENTACIONES_PRODUCTO epp on epp.COD_ESTADO_PRESENTACION_PRODUCTO = pp.cod_estado_registro");
                                        consulta.append(" where epp.TRANSACCIONABLE_PRODUCCION=1");
                                        consulta.append(" order by pp.NOMBRE_PRODUCTO_PRESENTACION");
            LOGGER.debug(" consulta cargar tipos programa produccion "+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            while(res.next()) 
            {
                presentacionesProductoSelectList.add(new SelectItem(res.getString("cod_presentacion"),res.getString("NOMBRE_PRODUCTO_PRESENTACION")));
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
        return presentacionesProductoSelectList;
    }
    
}
