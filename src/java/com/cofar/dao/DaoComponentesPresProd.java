/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.dao;
import com.cofar.bean.ActividadesFormulaMaestra;
import com.cofar.bean.ComponentesProd;
import com.cofar.bean.FormulaMaestra;
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
public class DaoComponentesPresProd extends DaoBean{

    public DaoComponentesPresProd() {
        LOGGER=LogManager.getRootLogger();
    }
    
    
    public List<SelectItem> listarComponentesPresProdPorComponentesProd(ComponentesProd componentesProdBuscar)
    {
        List<SelectItem> componentesPresProdSelectList=new ArrayList<SelectItem>();
        try 
        {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select distinct pp.cod_presentacion,pp.NOMBRE_PRODUCTO_PRESENTACION");
                                        consulta.append(" from COMPONENTES_PRESPROD cpp");
                                                consulta.append(" inner join PRESENTACIONES_PRODUCTO pp on cpp.COD_PRESENTACION=pp.cod_presentacion");
                                        consulta.append(" where cpp.COD_ESTADO_REGISTRO=1");
                                                consulta.append(" and cpp.COD_COMPPROD=").append(componentesProdBuscar.getCodCompprod());
                                        consulta.append(" order by pp.NOMBRE_PRODUCTO_PRESENTACION");
            LOGGER.debug(" consulta cargar tipos programa produccion "+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            while(res.next()) 
            { 
                componentesPresProdSelectList.add(new SelectItem(res.getString("cod_presentacion"),res.getString("NOMBRE_PRODUCTO_PRESENTACION")));
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
        return componentesPresProdSelectList;
    }
    
}
