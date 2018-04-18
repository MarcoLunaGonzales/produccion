/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.dao;

import com.cofar.bean.FormulaMaestraDetalleEP;
import com.cofar.bean.FormulaMaestraVersion;
import com.cofar.bean.PresentacionesPrimarias;
import com.cofar.util.Util;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import javax.faces.model.SelectItem;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/**
 *
 * @author DASISAQ
 */
public class DaoEnvasesPrimarios extends DaoBean 
{
    public DaoEnvasesPrimarios() {
        LOGGER=LogManager.getLogger("Versionamiento");
    }
    public DaoEnvasesPrimarios(Logger LOGGER) {
        this.LOGGER = LOGGER;
    }
    public List<SelectItem> listarSelectItem()
    {
        List<SelectItem> selectItemList = new ArrayList<>();
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select ep.cod_envaseprim,ep.nombre_envaseprim");
                                    consulta.append(" from ENVASES_PRIMARIOS ep");
                                    consulta.append(" where ep.cod_estado_registro=1");
                                    consulta.append(" order by ep.nombre_envaseprim");
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            while (res.next()) 
            {
                selectItemList.add(new SelectItem(res.getString("cod_envaseprim"),res.getString("nombre_envaseprim")));
            }
            res.close();
            st.close();
        } catch (SQLException ex) {
            LOGGER.warn("error", ex);
        } catch (Exception ex) {
            LOGGER.warn("error", ex);
        } finally {
            this.cerrarConexion(con);
        }
        return selectItemList;
    }
    
}
