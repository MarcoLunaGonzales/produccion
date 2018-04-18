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
public class DaoPersonal extends DaoBean{

    public DaoPersonal() {
        this.LOGGER = LogManager.getRootLogger();
    }
    
    public DaoPersonal(Logger LOGGER) {
        this.LOGGER = LOGGER;
    }
    
    public List<SelectItem> listarSelectItem(){
        List<SelectItem> personalSelectList = new ArrayList<>();
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select p.COD_PERSONAL,(p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL+' '+p.nombre2_personal) as nombrePersona")
                                                .append(" from personal p")
                                                .append(" where p.COD_ESTADO_PERSONA=1")
                                                .append(" order by 2");
            LOGGER.debug("consulta cargar personal select :"+consulta.toString());
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta.toString());
            while(res.next()){
                personalSelectList.add(new SelectItem(res.getString("COD_PERSONAL"),res.getString("nombrePersona")));
            }
          
            
        } catch (SQLException ex) {
            LOGGER.warn(ex.getMessage());
        } finally {
            this.cerrarConexion(con);
        }
        return personalSelectList;
    }
    
    
}
