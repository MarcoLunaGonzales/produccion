/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.dao;

import com.cofar.bean.ProcesosPreparadoProducto;
import com.cofar.bean.ProcesosPreparadoProductoMaquinaria;
import com.cofar.util.Util;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/**
 *
 * @author DASISAQ
 */
public class DaoProcesosPreparadoProductoMaquinaria extends DaoBean{
    
    public DaoProcesosPreparadoProductoMaquinaria() {
        LOGGER = LogManager.getRootLogger();
    }
    public DaoProcesosPreparadoProductoMaquinaria(Logger LOGGER) {
        this.LOGGER = LOGGER;
    }
    
    public List<ProcesosPreparadoProductoMaquinaria> listarAgregar()
    {
        List<ProcesosPreparadoProductoMaquinaria> procesosPreparadoProductoMaquinariaList = new ArrayList<>();
        try{
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select m.COD_MAQUINA,m.NOMBRE_MAQUINA,m.CODIGO,tem.NOMBRE_TIPO_EQUIPO");
                                    consulta.append(" from MAQUINARIAS m ");
                                    consulta.append(" inner join TIPOS_EQUIPOS_MAQUINARIA tem on tem.COD_TIPO_EQUIPO=m.COD_TIPO_EQUIPO");
                                    consulta.append(" where m.COD_ESTADO_REGISTRO=1");
                                    consulta.append(" order by m.NOMBRE_MAQUINA");
            LOGGER.debug("consulta cargar agregar maquinarias "+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            while (res.next()){
                ProcesosPreparadoProductoMaquinaria nuevo=new ProcesosPreparadoProductoMaquinaria();
                nuevo.getMaquinaria().setCodMaquina(res.getString("COD_MAQUINA"));
                nuevo.getMaquinaria().setNombreMaquina(res.getString("NOMBRE_MAQUINA"));
                nuevo.getMaquinaria().setCodigo(res.getString("CODIGO"));
                nuevo.getMaquinaria().getTiposEquiposMaquinaria().setNombreTipoEquipo(res.getString("NOMBRE_TIPO_EQUIPO"));
                procesosPreparadoProductoMaquinariaList.add(nuevo);
            }
        }
        catch (SQLException ex) 
        {
            LOGGER.warn("error", ex);
        } 
        finally 
        {
            this.cerrarConexion(con);
        }
        return procesosPreparadoProductoMaquinariaList;
    }
    
    public List<ProcesosPreparadoProductoMaquinaria> listarEditar(ProcesosPreparadoProducto procesosPreparadoProducto)
    {
        List<ProcesosPreparadoProductoMaquinaria> procesosPreparadoProductoMaquinariaList = new ArrayList<>();
        try
        {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select m.COD_MAQUINA,m.NOMBRE_MAQUINA,m.CODIGO,tem.NOMBRE_TIPO_EQUIPO");
                                        consulta.append(" ,isnull(pppm.COD_MAQUINA,0) as registrado");
                                    consulta.append(" from MAQUINARIAS m ");
                                        consulta.append(" inner join TIPOS_EQUIPOS_MAQUINARIA tem on tem.COD_TIPO_EQUIPO=m.COD_TIPO_EQUIPO");
                                        consulta.append(" left outer join PROCESOS_PREPARADO_PRODUCTO_MAQUINARIA pppm on pppm.COD_MAQUINA=m.COD_MAQUINA");
                                            consulta.append(" and pppm.COD_PROCESO_PREPARADO_PRODUCTO=").append(procesosPreparadoProducto.getCodProcesoPreparadoProducto());
                                    consulta.append(" where  m.COD_ESTADO_REGISTRO=1");
                                    consulta.append(" order by case when pppm.COD_MAQUINA>0 then 1 else 2 end, m.NOMBRE_MAQUINA");
            LOGGER.debug("consulta cargar editar maquinarias proceso"+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            while (res.next()) 
            {
                ProcesosPreparadoProductoMaquinaria nuevo=new ProcesosPreparadoProductoMaquinaria();
                nuevo.setChecked(res.getInt("registrado")>0);
                nuevo.setActivoAntesDeEdicion(res.getInt("registrado")>0);
                nuevo.getMaquinaria().setCodMaquina(res.getString("COD_MAQUINA"));
                nuevo.getMaquinaria().setNombreMaquina(res.getString("NOMBRE_MAQUINA"));
                nuevo.getMaquinaria().setCodigo(res.getString("CODIGO"));
                nuevo.getMaquinaria().getTiposEquiposMaquinaria().setNombreTipoEquipo(res.getString("NOMBRE_TIPO_EQUIPO"));
                procesosPreparadoProductoMaquinariaList.add(nuevo);
            }
            st.close();
        }
        catch (SQLException ex) 
        {
            LOGGER.warn("error", ex);
        } 
        finally 
        {
            this.cerrarConexion(con);
        }
        return procesosPreparadoProductoMaquinariaList;
    }
    
}
