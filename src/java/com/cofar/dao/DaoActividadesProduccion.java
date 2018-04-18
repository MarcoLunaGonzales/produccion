/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.dao;
import com.cofar.bean.ActividadesFormulaMaestra;
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
public class DaoActividadesProduccion extends DaoBean{

    public DaoActividadesProduccion() {
        LOGGER=LogManager.getRootLogger();
    }
    
    
    public List<SelectItem> listarActividadesProduccionSinActividadFormulaMaestra(ActividadesFormulaMaestra actividadesFormulaMaestra)
    {
        List<SelectItem> actividadesProduccionList=new ArrayList<SelectItem>();
        try 
        {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select DISTINCT ap.COD_ACTIVIDAD,ap.NOMBRE_ACTIVIDAD");
                                        consulta.append(" from ACTIVIDADES_PRODUCCION ap");
                                        consulta.append(" left outer join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_ACTIVIDAD=ap.COD_ACTIVIDAD");
                                                consulta.append(" and afm.COD_FORMULA_MAESTRA=").append(actividadesFormulaMaestra.getFormulaMaestra().getCodFormulaMaestra());
                                                consulta.append(" and afm.COD_AREA_EMPRESA=").append(actividadesFormulaMaestra.getAreasEmpresa().getCodAreaEmpresa());
                                                consulta.append(" and afm.COD_TIPO_PROGRAMA_PROD=").append(actividadesFormulaMaestra.getTiposProgramaProduccion().getCodTipoProgramaProd());
                                                consulta.append(" and afm.COD_PRESENTACION=").append(actividadesFormulaMaestra.getPresentacionesProducto().getCodPresentacion());
                                        consulta.append(" where ap.COD_ESTADO_REGISTRO=1");
                                                consulta.append(" and afm.COD_ACTIVIDAD_FORMULA is null");
                                        consulta.append(" order by ap.NOMBRE_ACTIVIDAD");
            LOGGER.debug(" consulta cargar tipos programa produccion "+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            while(res.next()) 
            { 
                actividadesProduccionList.add(new SelectItem(res.getInt("COD_ACTIVIDAD"),res.getString("NOMBRE_ACTIVIDAD")));
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
        return actividadesProduccionList;
    }
    
}
