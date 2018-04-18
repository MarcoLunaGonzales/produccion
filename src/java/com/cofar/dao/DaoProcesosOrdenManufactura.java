/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.dao;

import com.cofar.bean.ComponentesProdVersion;
import com.cofar.bean.ProcesosOrdenManufactura;
import com.cofar.bean.ProcesosPreparadoConsumoMaterialFm;
import com.cofar.bean.ProcesosPreparadoProducto;
import com.cofar.bean.ProcesosPreparadoProductoConsumo;
import com.cofar.bean.ProcesosPreparadoProductoConsumoProceso;
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
public class DaoProcesosOrdenManufactura extends DaoBean{
    
    public DaoProcesosOrdenManufactura() {
        LOGGER = LogManager.getRootLogger();
    }
    
    public DaoProcesosOrdenManufactura(Logger LOGGER) {
        this.LOGGER = LOGGER;
    }
    
    public List<ProcesosOrdenManufactura> listarHabilitadosIndicaciones(ComponentesProdVersion componentesProdVersion)
    {
        List<ProcesosOrdenManufactura> procesosOrdenManufacturaList = new ArrayList<>();
        try{
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select cppom.ORDEN,pom.COD_PROCESO_ORDEN_MANUFACTURA,pom.NOMBRE_PROCESO_ORDEN_MANUFACTURA");
                                    consulta.append(" from COMPONENTES_PROD_PROCESO_ORDEN_MANUFACTURA cppom ");
                                        consulta.append(" inner join FORMAS_FARMACEUTICAS_PROCESO_ORDEN_MANUFACTURA ffpom on cppom.COD_FORMA_FARMACEUTICA_PROCESO_ORDEN_MANUFACTURA=ffpom.COD_FORMA_FARMACEUTICA_PROCESO_ORDEN_MANUFACTURA");
                                        consulta.append(" inner join PROCESOS_ORDEN_MANUFACTURA pom on pom.COD_PROCESO_ORDEN_MANUFACTURA=ffpom.COD_PROCESO_ORDEN_MANUFACTURA");
                                    consulta.append(" where cppom.COD_VERSION=").append(componentesProdVersion.getCodVersion());
                                        consulta.append(" and pom.COD_PROCESO_ORDEN_MANUFACTURA in ");
                                        consulta.append(" (");
                                            consulta.append(" select ffi.COD_PROCESO_ORDEN_MANUFACTURA");
                                            consulta.append(" from FORMAS_FARMACEUTICAS_INDICACIONES ffi where ffi.COD_FORMA=").append(componentesProdVersion.getForma().getCodForma());
                                        consulta.append(" )");
                                    consulta.append(" order by cppom.ORDEN");
            LOGGER.debug("consulta listar procesos habilitados producto "+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            while (res.next()) 
            {
                ProcesosOrdenManufactura nuevo=new ProcesosOrdenManufactura();
                nuevo.setCodProcesoOrdenManufactura(res.getInt("COD_PROCESO_ORDEN_MANUFACTURA"));
                nuevo.setNombreProcesoOrdenManufactura(res.getString("NOMBRE_PROCESO_ORDEN_MANUFACTURA"));
                procesosOrdenManufacturaList.add(nuevo);
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
        return procesosOrdenManufacturaList;
    }
    
    public List<ProcesosOrdenManufactura> listarHabilitadosPreparado(ComponentesProdVersion componentesProdVersion)
    {
        List<ProcesosOrdenManufactura> procesosOrdenManufacturaList = new ArrayList<>();
        try{
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("SELECT pom.COD_PROCESO_ORDEN_MANUFACTURA,pom.NOMBRE_PROCESO_ORDEN_MANUFACTURA");
                                        consulta.append(" FROM FORMAS_FARMACEUTICAS_PROCESO_ORDEN_MANUFACTURA ffpom");
                                            consulta.append(" inner join COMPONENTES_PROD_PROCESO_ORDEN_MANUFACTURA cppom on cppom.COD_FORMA_FARMACEUTICA_PROCESO_ORDEN_MANUFACTURA=ffpom.COD_FORMA_FARMACEUTICA_PROCESO_ORDEN_MANUFACTURA");
                                            consulta.append(" inner join PROCESOS_ORDEN_MANUFACTURA pom on pom.COD_PROCESO_ORDEN_MANUFACTURA=ffpom.COD_PROCESO_ORDEN_MANUFACTURA");
                                        consulta.append(" where cppom.COD_VERSION=").append(componentesProdVersion.getCodVersion());
                                            consulta.append(" and ffpom.APLICA_FLUJOGRAMA=1");
                                        consulta.append(" order by cppom.ORDEN");
            LOGGER.debug("consulta listar procesos habilitados producto "+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            while (res.next()) 
            {
                ProcesosOrdenManufactura nuevo=new ProcesosOrdenManufactura();
                nuevo.setCodProcesoOrdenManufactura(res.getInt("COD_PROCESO_ORDEN_MANUFACTURA"));
                nuevo.setNombreProcesoOrdenManufactura(res.getString("NOMBRE_PROCESO_ORDEN_MANUFACTURA"));
                procesosOrdenManufacturaList.add(nuevo);
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
        return procesosOrdenManufacturaList;
    }
    
    public List<SelectItem> listarSelectNoUtilizadosEspProceso(ComponentesProdVersion componentesProdVersion){
        List<SelectItem> procesosOrdenList = new ArrayList<>();
        try 
        {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select pom.COD_PROCESO_ORDEN_MANUFACTURA,pom.NOMBRE_PROCESO_ORDEN_MANUFACTURA")
                                            .append(" from FORMAS_FARMACEUTICAS_PROCESO_ORDEN_MANUFACTURA ffp")
                                                    .append(" inner join COMPONENTES_PROD_PROCESO_ORDEN_MANUFACTURA cp on cp.COD_FORMA_FARMACEUTICA_PROCESO_ORDEN_MANUFACTURA=ffp.COD_FORMA_FARMACEUTICA_PROCESO_ORDEN_MANUFACTURA")
                                                    .append(" inner join PROCESOS_ORDEN_MANUFACTURA pom on pom.COD_PROCESO_ORDEN_MANUFACTURA=ffp.COD_PROCESO_ORDEN_MANUFACTURA")
                                                    .append(" left outer join COMPONENTES_PROD_VERSION_ESPECIFICACION_PROCESO cpve on cpve.COD_PROCESO_ORDEN_MANUFACTURA=pom.COD_PROCESO_ORDEN_MANUFACTURA")
                                                                .append(" and  cpve.COD_VERSION=").append(componentesProdVersion.getCodVersion())
                                            .append(" where cp.COD_VERSION=").append(componentesProdVersion.getCodVersion())
                                                    .append(" and ffp.APLICA_ESPECIFICACIONES_PROCESO=1")
                                                    .append(" and cpve.COD_VERSION is null ")
                                            .append(" order by cp.ORDEN");
            LOGGER.debug("consulta cargar procesos habilitados "+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            while(res.next())
            {
                procesosOrdenList.add(new SelectItem(res.getInt("COD_PROCESO_ORDEN_MANUFACTURA"),res.getString("NOMBRE_PROCESO_ORDEN_MANUFACTURA")));
            }
            
        }
        catch (SQLException ex) 
        {
            LOGGER.warn(ex.getMessage());
        }
        catch (NumberFormatException ex) 
        {
            LOGGER.warn(ex.getMessage());
        }
        finally 
        {
            this.cerrarConexion(con);
        }
        return procesosOrdenList;
    }
    
    public List<ProcesosOrdenManufactura> listarHabilitadosEspecificacionesMaquinaria(ComponentesProdVersion componentesProdVersion)
    {
        List<ProcesosOrdenManufactura> procesosOrdenManufacturaList = new ArrayList<>();
        try{
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("SELECT pom.COD_PROCESO_ORDEN_MANUFACTURA,pom.NOMBRE_PROCESO_ORDEN_MANUFACTURA");
                                        consulta.append(" FROM FORMAS_FARMACEUTICAS_PROCESO_ORDEN_MANUFACTURA ffpom");
                                            consulta.append(" inner join COMPONENTES_PROD_PROCESO_ORDEN_MANUFACTURA cppom on cppom.COD_FORMA_FARMACEUTICA_PROCESO_ORDEN_MANUFACTURA=ffpom.COD_FORMA_FARMACEUTICA_PROCESO_ORDEN_MANUFACTURA");
                                            consulta.append(" inner join PROCESOS_ORDEN_MANUFACTURA pom on pom.COD_PROCESO_ORDEN_MANUFACTURA=ffpom.COD_PROCESO_ORDEN_MANUFACTURA");
                                        consulta.append(" where cppom.COD_VERSION=").append(componentesProdVersion.getCodVersion());
                                            consulta.append(" and ffpom.APLICA_ESPECIFICACIONES_MAQUINARIA=1");
                                        consulta.append(" order by cppom.ORDEN");
            LOGGER.debug("consulta listar procesos habilitados producto "+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            while (res.next()) 
            {
                ProcesosOrdenManufactura nuevo=new ProcesosOrdenManufactura();
                nuevo.setCodProcesoOrdenManufactura(res.getInt("COD_PROCESO_ORDEN_MANUFACTURA"));
                nuevo.setNombreProcesoOrdenManufactura(res.getString("NOMBRE_PROCESO_ORDEN_MANUFACTURA"));
                procesosOrdenManufacturaList.add(nuevo);
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
        return procesosOrdenManufacturaList;
    }
    
}
