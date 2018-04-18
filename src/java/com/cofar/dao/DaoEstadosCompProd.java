/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.dao;

import com.cofar.bean.EstadoCompProd;
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
public class DaoEstadosCompProd extends DaoBean{

    public DaoEstadosCompProd() {
        LOGGER = LogManager.getRootLogger();
    }
    public DaoEstadosCompProd(Logger LOGGER) {
        this.LOGGER = LOGGER;
    }
    
    public List<SelectItem> listarSelectItem(){
        List<SelectItem> estadosSelectList = new ArrayList<>();
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select ec.COD_ESTADO_COMPPROD,ec.NOMBRE_ESTADO_COMPPROD ")
                                                .append(" from ESTADOS_COMPPROD ec")
                                                .append(" order by ec.NOMBRE_ESTADO_COMPPROD");
            LOGGER.debug("consulta cargar estados compprod "+consulta.toString());
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta.toString());
            while(res.next()){
                estadosSelectList.add(new SelectItem(res.getInt("COD_ESTADO_COMPPROD"), res.getString("NOMBRE_ESTADO_COMPPROD")));
            }
          
        } catch (SQLException ex) {
            LOGGER.warn(ex.getMessage());
        } finally {
            this.cerrarConexion(con);
        }
        return estadosSelectList;
    }
    
    
}
