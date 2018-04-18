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
public class DaoAlmacenesAcond extends DaoBean{

    public DaoAlmacenesAcond() {
        this.LOGGER = LogManager.getRootLogger();
    }
    public DaoAlmacenesAcond(Logger logger) {
        this.LOGGER  = logger;
    }
    
    public List<SelectItem> listarDestinoEnvioProduccionSelect(){
        List<SelectItem> almacenesList= new ArrayList<>();
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select COD_ALMACENACOND ,NOMBRE_ALMACENACOND")
                                                .append(" FROM ALMACENES_ACOND")
                                                .append(" where DESTINO_ENVIO_PRODUCCION = 1 ")
                                                .append(" order by NOMBRE_ALMACENACOND");
            LOGGER.debug("consulta cargar almacenes acond: "+consulta.toString());
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta.toString());
            while(res.next()){
                almacenesList.add(new SelectItem(res.getInt("COD_ALMACENACOND"),res.getString("NOMBRE_ALMACENACOND")));
            }
        } catch (SQLException ex) {
            LOGGER.warn(ex.getMessage());
        } catch (Exception ex) {
            LOGGER.warn(ex.getMessage());
        } finally {
            this.cerrarConexion(con);
        }
        return almacenesList;
    }
    
    
}
