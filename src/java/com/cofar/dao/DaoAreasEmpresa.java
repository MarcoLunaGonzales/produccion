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
public class DaoAreasEmpresa extends DaoBean{

    public DaoAreasEmpresa() {
        LOGGER=LogManager.getLogger("Versionamiento");
    }
    
    public DaoAreasEmpresa(Logger LOGGER) {
        this.LOGGER = LOGGER;
    }
    
    public List<SelectItem> listarAreasFabricacionSelectItem()
    {
        List<SelectItem> areaEmpresaSelectList=new ArrayList<SelectItem>();
        try 
        {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select ae.COD_AREA_EMPRESA,ae.NOMBRE_AREA_EMPRESA")
                                            .append(" from AREAS_FABRICACION_PRODUCTO afp ")
                                                        .append(" inner join AREAS_EMPRESA ae on ae.COD_AREA_EMPRESA = afp.COD_AREA_EMPRESA")
                                            .append(" where afp.COD_ESTADO_REGISTRO=1")
                                            .append(" order by ae.NOMBRE_AREA_EMPRESA");
            LOGGER.debug("consulta cargar materiales "+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            while(res.next()) 
            {
                areaEmpresaSelectList.add(new SelectItem(res.getString("COD_AREA_EMPRESA"),res.getString("NOMBRE_AREA_EMPRESA")));
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
        return areaEmpresaSelectList;
    }
            
    
}
