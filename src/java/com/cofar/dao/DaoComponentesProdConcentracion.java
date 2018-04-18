/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.dao;

import com.cofar.bean.ComponentesProdConcentracion;
import com.cofar.bean.ComponentesProdVersion;
import com.cofar.bean.ComponentesProdVersionModificacion;
import com.cofar.util.Util;
import java.sql.PreparedStatement;
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
public class DaoComponentesProdConcentracion extends DaoBean{

    public DaoComponentesProdConcentracion() {
        LOGGER=LogManager.getLogger("Versionamiento");
    }
    
    public DaoComponentesProdConcentracion(Logger LOGGER) {
        this.LOGGER = LOGGER;
    }
    public List<ComponentesProdConcentracion> listar(ComponentesProdVersion ComponentesProdVersion)
    {
        List<ComponentesProdConcentracion> componentesProdConcentracionList = new ArrayList<>();
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select m.NOMBRE_MATERIAL,m.NOMBRE_CCC,m.COD_MATERIAL,")
                                                    .append(" ISNULL(cpc.CANTIDAD, 0) as cantidad,ISNULL(cpc.UNIDAD_PRODUCTO, '') as unidadProducto,")
                                                    .append(" ISNULL(cpc.COD_UNIDAD_MEDIDA, m.COD_UNIDAD_MEDIDA) as unidadMedida,isnull(cpc.CANTIDAD_EQUIVALENCIA, 0) as CANTIDAD_EQUIVALENCIA,")
                                                    .append(" isnull(cpc.NOMBRE_MATERIAL_EQUIVALENCIA, '') as NOMBRE_MATERIAL_EQUIVALENCIA, isnull(cpc.COD_UNIDAD_MEDIDA_EQUIVALENCIA, 0) as COD_UNIDAD_MEDIDA_EQUIVALENCIA")
                                                    .append(" ,cpc.EXCIPIENTE,cpc.PESO_MOLECULAR,cpc.COD_REFERENCIACC")
                                            .append(" from COMPONENTES_PROD_CONCENTRACION cpc")
                                                    .append(" inner join materiales m on m.COD_MATERIAL = cpc.COD_MATERIAL ")
                                                    .append(" inner join grupos g on g.COD_GRUPO=m.COD_GRUPO")
                                            .append(" where cpc.COD_VERSION = ").append(ComponentesProdVersion.getCodVersion())
                                            .append(" order by m.NOMBRE_MATERIAL");
            LOGGER.debug("consulta cargar componentes prod COncentracion "+consulta.toString());
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta.toString());
            while(res.next())
            {
                ComponentesProdConcentracion nuevo=new ComponentesProdConcentracion();
                nuevo.getMateriales().setCodMaterial(res.getString("COD_MATERIAL"));
                nuevo.getMateriales().setNombreMaterial(res.getString("NOMBRE_MATERIAL"));
                nuevo.getMateriales().setNombreCCC(res.getString("NOMBRE_CCC"));
                nuevo.getUnidadesMedida().setCodUnidadMedida(res.getString("unidadMedida"));
                nuevo.setUnidadProducto(res.getString("unidadProducto"));
                nuevo.setCantidad(res.getDouble("cantidad"));
                nuevo.setNombreMaterialEquivalencia(res.getString("NOMBRE_MATERIAL_EQUIVALENCIA"));
                nuevo.setCantidadEquivalencia(res.getDouble("CANTIDAD_EQUIVALENCIA"));
                nuevo.getUnidadMedidaEquivalencia().setCodUnidadMedida(res.getString("COD_UNIDAD_MEDIDA_EQUIVALENCIA"));
                nuevo.setExcipiente(res.getInt("EXCIPIENTE")>0);
                nuevo.setPesoMolecular(res.getDouble("PESO_MOLECULAR"));
                nuevo.getTiposReferenciaCc().setCodReferenciaCc(res.getInt("COD_REFERENCIACC"));
                componentesProdConcentracionList.add(nuevo);
            }
        } catch (SQLException ex) {
            LOGGER.warn(ex.getMessage());
        } catch (NumberFormatException ex) {
            LOGGER.warn(ex.getMessage());
        } finally {
            this.cerrarConexion(con);
        }
        return componentesProdConcentracionList;
    }
            
    
}
