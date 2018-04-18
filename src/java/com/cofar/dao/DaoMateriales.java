/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.dao;

import com.cofar.bean.ComponentesProdVersion;
import com.cofar.bean.Materiales;
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
public class DaoMateriales extends DaoBean{

    public DaoMateriales() {
        LOGGER=LogManager.getLogger("Versionamiento");
    }
    
    public List<Materiales> listar(Materiales materiales)
    {
        List<Materiales> materialesList = new ArrayList<>();
        try 
        {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select m.COD_MATERIAL,m.NOMBRE_MATERIAL,m.NOMBRE_CCC,um.ABREVIATURA,")
                                                    .append("um.NOMBRE_UNIDAD_MEDIDA");
                                        consulta.append(" from materiales m ");
                                                consulta.append(" inner join grupos g on g.COD_GRUPO=m.COD_GRUPO");
                                                consulta.append(" inner join capitulos c on c.COD_CAPITULO=g.COD_CAPITULO");
                                                consulta.append("  inner join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=m.COD_UNIDAD_MEDIDA");
                                        consulta.append(" where 1=1 ");
                                            if(materiales.getGrupo().getCapitulo().getCodCapitulo()>0){
                                                consulta.append(" and g.COD_CAPITULO=").append(materiales.getGrupo().getCapitulo().getCodCapitulo());
                                            }
                                            if(materiales.getNombreMaterial().trim().length()>0)
                                            {
                                                consulta.append(" and m.NOMBRE_MATERIAL like '%").append(materiales.getNombreMaterial().trim()).append("%'");
                                            }
                                            if(materiales.getNombreCCC().trim().length()>0)
                                            {
                                                consulta.append(" and m.NOMBRE_CCC like '%").append(materiales.getNombreCCC().trim()).append("%'");
                                            }
                                            if( (!materiales.getEstadoRegistro().getCodEstadoRegistro().equals("")) &&
                                                    (!materiales.getEstadoRegistro().getCodEstadoRegistro().equals("0")))
                                            {
                                                consulta.append(" and m.COD_ESTADO_REGISTRO=").append(materiales.getEstadoRegistro().getCodEstadoRegistro());
                                            }
                                        consulta.append(" order by m.NOMBRE_MATERIAL");
            LOGGER.debug("consulta cargar materiales "+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            while(res.next()) 
            {
                Materiales material = new Materiales();
                material.setCodMaterial(res.getString("COD_MATERIAL"));
                material.setNombreMaterial(res.getString("NOMBRE_MATERIAL"));
                material.setNombreCCC(res.getString("NOMBRE_CCC"));
                material.getUnidadesMedida().setNombreUnidadMedida(res.getString("NOMBRE_UNIDAD_MEDIDA"));
                materialesList.add(material);
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
        return materialesList;
    }
    
    public List<SelectItem> getMaterialesSelectList(Materiales materialesBuscar)
    {
        List<SelectItem> materialesSelectList=new ArrayList<SelectItem>();
        try 
        {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select m.COD_MATERIAL,m.NOMBRE_MATERIAL,um.ABREVIATURA");
                                        consulta.append(" from materiales m ");
                                                consulta.append(" inner join grupos g on g.COD_GRUPO=m.COD_GRUPO");
                                                consulta.append(" inner join capitulos c on c.COD_CAPITULO=g.COD_CAPITULO");
                                                consulta.append("  inner join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=m.COD_UNIDAD_MEDIDA");
                                        consulta.append(" where 1=1 ");
                                            if(materialesBuscar.getGrupo().getCapitulo().getCodCapitulo()>0){
                                                consulta.append(" and g.COD_CAPITULO=").append(materialesBuscar.getGrupo().getCapitulo().getCodCapitulo());
                                            }
                                        consulta.append(" order by m.NOMBRE_MATERIAL");
            LOGGER.debug("consulta cargar materiales "+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            materialesSelectList=new ArrayList<SelectItem>();
            while(res.next()) 
            {
                materialesSelectList.add(new SelectItem(res.getString("COD_MATERIAL"),res.getString("NOMBRE_MATERIAL")+"("+res.getString("ABREVIATURA")+")"));
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
        return materialesSelectList;
    }
            
    
}
