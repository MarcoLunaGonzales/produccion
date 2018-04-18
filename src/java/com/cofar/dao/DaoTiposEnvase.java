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
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import javax.faces.model.SelectItem;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/**
 *
 * @author DASISAQ
 */
public class DaoTiposEnvase extends DaoBean{

    public DaoTiposEnvase() {
        LOGGER = LogManager.getRootLogger();
    }
    
    public DaoTiposEnvase(Logger logger) {
        this.LOGGER = logger;
    }
    
    public List<SelectItem> listarSelect(){
        List<SelectItem> tiposEnvaseSelectList = new ArrayList<>();
        try {
            
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select te.COD_ENVASE,te.NOMBRE_ENVASE")
                                                .append(" from TIPOS_ENVASE te")
                                                .append(" where te.COD_ESTADO_REGISTRO=1")
                                                .append(" order by te.NOMBRE_ENVASE");
            LOGGER.debug("consulta cargar tipos envase: "+consulta.toString());
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta.toString());
            while(res.next()){
                tiposEnvaseSelectList.add(new SelectItem(res.getInt("COD_ENVASE"),res.getString("NOMBRE_ENVASE")));
            }
        } catch (SQLException ex) {
            LOGGER.warn(ex.getMessage());
        } finally {
            this.cerrarConexion(con);
        }
        return tiposEnvaseSelectList;
    }
    
    
}
