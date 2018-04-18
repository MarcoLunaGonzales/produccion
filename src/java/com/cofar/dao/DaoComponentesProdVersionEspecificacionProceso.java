/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.dao;

import com.cofar.bean.ComponentesProdVersion;
import com.cofar.bean.ComponentesProdVersionEspecificacionProceso;
import com.cofar.bean.ProcesosOrdenManufactura;
import com.cofar.util.Util;
import java.sql.PreparedStatement;
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
public class DaoComponentesProdVersionEspecificacionProceso extends DaoBean{

    public DaoComponentesProdVersionEspecificacionProceso() {
        this.LOGGER = LogManager.getRootLogger();
    }
    public DaoComponentesProdVersionEspecificacionProceso(Logger LOGGER){
        this.LOGGER = LOGGER;
    }
    public boolean eliminar(int codVersionProducto, int codProcesoOm)throws SQLException {
        LOGGER.debug("---------------------------------INICIO ELIMINAR ESPECIFICACIONES PROCESO-------------------------------------");
        boolean eliminado = false;
        try 
        {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta = new StringBuilder("delete COMPONENTES_PROD_VERSION_ESPECIFICACION_PROCESO");
                                        consulta.append(" where COD_VERSION=").append(codVersionProducto);
                                            consulta.append(" and COD_PROCESO_ORDEN_MANUFACTURA=").append(codProcesoOm);
            LOGGER.debug("consulta eliminar especificaciones procesos" + consulta.toString());
            PreparedStatement pst = con.prepareStatement(consulta.toString());
            if (pst.executeUpdate() > 0) LOGGER.info("Se eliminaron las especificaciones");
            con.commit();
            eliminado = true;
        } 
        catch (SQLException ex) 
        {
            eliminado = false;
            con.rollback();
            LOGGER.warn(ex.getMessage());
        } 
        catch (Exception ex) 
        {
            eliminado = false;
            LOGGER.warn(ex.getMessage());
        } 
        finally 
        {
            this.cerrarConexion(con);
        }
        LOGGER.debug("---------------------------------TERMINO ELIMINAR ESPECIFICACIONES PROCESO-------------------------------------");
        return eliminado;
    }
    public boolean eliminarGuardarLista(List<ComponentesProdVersionEspecificacionProceso> especificacionesList, int codVersionProducto,int codProcesoOm)throws SQLException{
        LOGGER.debug("---------------------------------INICIO ELIMINAR GUARDAR ESPECIFICACIONES PROCESO-------------------------------------");
        boolean guardado = false;
        try {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta =new StringBuilder("delete COMPONENTES_PROD_VERSION_ESPECIFICACION_PROCESO");
                                      consulta.append(" where COD_VERSION=").append(codVersionProducto);
                                      consulta.append(" and COD_PROCESO_ORDEN_MANUFACTURA=").append(codProcesoOm);
            LOGGER.debug("consulta delete anteriores especificaciones " + consulta.toString());
            PreparedStatement pst = con.prepareStatement(consulta.toString());
            if (pst.executeUpdate() > 0)LOGGER.info("Se eliminaron anteriores especificaciones");
            consulta=new StringBuilder("INSERT INTO COMPONENTES_PROD_VERSION_ESPECIFICACION_PROCESO(COD_VERSION,COD_ESPECIFICACION_PROCESO, VALOR_EXACTO, VALOR_MINIMO, VALOR_MAXIMO, VALOR_TEXTO,COD_TIPO_DESCRIPCION,COD_PROCESO_ORDEN_MANUFACTURA,COD_UNIDAD_MEDIDA,PORCIENTO_TOLERANCIA)");
                        consulta.append("VALUES (");
                            consulta.append(codVersionProducto).append(",");
                            consulta.append("?,?,?,?,?,?,");
                            consulta.append(codProcesoOm).append(",");
                            consulta.append("?,?");
                        consulta.append(")");
            LOGGER.debug("consulta guardar especificaicones "+consulta.toString());
            pst=con.prepareStatement(consulta.toString());
            for(ComponentesProdVersionEspecificacionProceso bean : especificacionesList)
            {
                pst.setInt(1,bean.getEspecificacionesProcesos().getCodEspecificacionProceso());LOGGER.info("p1: "+bean.getEspecificacionesProcesos().getCodEspecificacionProceso());
                pst.setDouble(2,bean.getValorExacto());LOGGER.info("p2: "+bean.getValorExacto());
                pst.setDouble(3,bean.getValorMinimo());LOGGER.info("p3: "+bean.getValorMinimo());
                pst.setDouble(4,bean.getValorMaximo());LOGGER.info("p4: "+bean.getValorMaximo());
                pst.setString(5,bean.getValorTexto());LOGGER.info("p5: "+bean.getValorTexto());
                pst.setInt(6,bean.getTiposDescripcion().getCodTipoDescripcion());LOGGER.info("p6: "+bean.getTiposDescripcion().getCodTipoDescripcion());
                pst.setString(7,bean.getUnidadesMedida().getCodUnidadMedida());LOGGER.info("p7: "+bean.getUnidadesMedida().getCodUnidadMedida());
                pst.setDouble(8,bean.getPorcientoTolerancia());LOGGER.info("p8: "+bean.getPorcientoTolerancia());
                if(pst.executeUpdate()>0)LOGGER.info("se registro la especificacion "+bean.getEspecificacionesProcesos().getCodEspecificacionProceso());
            }
            con.commit();
            guardado = true;
        } 
        catch (SQLException ex) 
        {
            LOGGER.warn(ex.getMessage());
            con.rollback();
            guardado = false;
        }
        catch (Exception ex) 
        {
            LOGGER.warn(ex.getMessage());
            guardado = false;
        }
        finally 
        {
            this.cerrarConexion(con);
        }
        LOGGER.debug("---------------------------------TERMINO ELIMINAR GUARDAR ESPECIFICACIONES PROCESO-------------------------------------");
        return guardado;
    }
    
    public List<ComponentesProdVersionEspecificacionProceso> listarEditar(int codVersionProducto, int codProcesoOm){
        List<ComponentesProdVersionEspecificacionProceso> especificacionesList = new ArrayList<>();
        try 
        {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select ep.COD_ESPECIFICACION_PROCESO,ep.NOMBRE_ESPECIFICACIONES_PROCESO,td.COD_TIPO_DESCRIPCION,td.NOMBRE_TIPO_DESCRIPCION,");
                                            consulta.append(" isnull(cpvep.VALOR_EXACTO,ep.VALOR_EXACTO) as VALOR_EXACTO,isnull(cpvep.VALOR_TEXTO,ep.VALOR_TEXTO) as VALOR_TEXTO,");
                                            consulta.append(" isnull(cpvep.VALOR_MINIMO,ep.VALOR_MINIMO) as VALOR_MINIMO,isnull(cpvep.VALOR_MAXIMO,ep.VALOR_MAXIMO) as VALOR_MAXIMO");
                                            consulta.append(" ,cpvep.COD_COMPPROD_VERSION_ESPECIFICACION_PROCESO");
                                            consulta.append(" ,isnull(cpvep.COD_UNIDAD_MEDIDA,ep.COD_UNIDAD_MEDIDA) as COD_UNIDAD_MEDIDA");
                                            consulta.append(" ,isnull(cpvep.PORCIENTO_TOLERANCIA,ep.PORCIENTO_TOLERANCIA) as PORCIENTO_TOLERANCIA");
                                        consulta.append(" from ESPECIFICACIONES_PROCESOS ep ");
                                            consulta.append(" left outer join COMPONENTES_PROD_VERSION_ESPECIFICACION_PROCESO cpvep on cpvep.COD_ESPECIFICACION_PROCESO=ep.COD_ESPECIFICACION_PROCESO");
                                                consulta.append(" and cpvep.COD_VERSION=").append(codVersionProducto);
                                                consulta.append(" and cpvep.COD_PROCESO_ORDEN_MANUFACTURA=").append(codProcesoOm);
                                            consulta.append(" left outer join TIPOS_DESCRIPCION td on td.COD_TIPO_DESCRIPCION=isnull(cpvep.COD_TIPO_DESCRIPCION,ep.COD_TIPO_DESCRIPCION)");
                                        consulta.append(" where ep.COD_TIPO_ESPECIFICACION_PROCESO=2");
                                        consulta.append(" order by ep.ORDEN");
            LOGGER.debug("consulta especificaciones proceso producto "+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            while (res.next()) {
                ComponentesProdVersionEspecificacionProceso nuevo=new ComponentesProdVersionEspecificacionProceso();
                nuevo.getEspecificacionesProcesos().setCodEspecificacionProceso(res.getInt("COD_ESPECIFICACION_PROCESO"));
                nuevo.getEspecificacionesProcesos().setNombreEspecificacionProceso(res.getString("NOMBRE_ESPECIFICACIONES_PROCESO"));
                nuevo.getTiposDescripcion().setCodTipoDescripcion(res.getInt("COD_TIPO_DESCRIPCION"));
                nuevo.getTiposDescripcion().setNombreTipoDescripcion(res.getString("NOMBRE_TIPO_DESCRIPCION"));
                nuevo.getUnidadesMedida().setCodUnidadMedida(res.getString("COD_UNIDAD_MEDIDA"));
                nuevo.setPorcientoTolerancia(res.getDouble("PORCIENTO_TOLERANCIA"));
                nuevo.setValorExacto(res.getDouble("VALOR_EXACTO"));
                nuevo.setValorMaximo(res.getDouble("VALOR_MAXIMO"));
                nuevo.setValorMinimo(res.getDouble("VALOR_MINIMO"));
                nuevo.setValorTexto(res.getString("VALOR_TEXTO"));
                nuevo.setChecked(res.getInt("COD_COMPPROD_VERSION_ESPECIFICACION_PROCESO")>0);
                especificacionesList.add(nuevo);
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
        return especificacionesList;
    }
    
    public List<ProcesosOrdenManufactura> listarPorProcesosOm(ComponentesProdVersion componentesProdVersion){
        List<ProcesosOrdenManufactura> procesosOrdenManufacturaList = new ArrayList<>();
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select * ")
                                            .append(" from VISTA_ESPECIFICACIONES_PROCESOS vep ")
                                            .append(" WHERE vep.COD_VERSION=").append(componentesProdVersion.getCodVersion())
                                            .append(" order by vep.NOMBRE_PROCESO_ORDEN_MANUFACTURA");
            LOGGER.debug("consulta cargar especificaciones procesos "+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            ProcesosOrdenManufactura nuevo=new ProcesosOrdenManufactura();
            while (res.next()) 
            {
                if(nuevo.getCodProcesoOrdenManufactura()!=res.getInt("COD_PROCESO_ORDEN_MANUFACTURA"))
                {
                    if(nuevo.getCodProcesoOrdenManufactura()>0)
                    {
                        procesosOrdenManufacturaList.add(nuevo);
                    }
                    nuevo=new ProcesosOrdenManufactura();
                    nuevo.setCodProcesoOrdenManufactura(res.getInt("COD_PROCESO_ORDEN_MANUFACTURA"));
                    nuevo.setNombreProcesoOrdenManufactura(res.getString("NOMBRE_PROCESO_ORDEN_MANUFACTURA"));
                    nuevo.setComponentesProdVersionEspecificacionProcesoList(new ArrayList<ComponentesProdVersionEspecificacionProceso>());
                }
                ComponentesProdVersionEspecificacionProceso bean=new ComponentesProdVersionEspecificacionProceso();
                bean.setCodCompProdVersionEspecificacionProceso(res.getInt("COD_COMPPROD_VERSION_ESPECIFICACION_PROCESO"));
                bean.setValorExacto(res.getDouble("VALOR_EXACTO"));
                bean.setValorMaximo(res.getDouble("VALOR_MAXIMO"));
                bean.setValorMinimo(res.getDouble("VALOR_MINIMO"));
                bean.setValorTexto(res.getString("VALOR_TEXTO"));
                bean.getUnidadesMedida().setCodUnidadMedida(res.getString("COD_UNIDAD_MEDIDA"));
                bean.getUnidadesMedida().setNombreUnidadMedida(res.getString("NOMBRE_UNIDAD_MEDIDA"));
                bean.getEspecificacionesProcesos().setCodEspecificacionProceso(res.getInt("COD_ESPECIFICACION_PROCESO"));
                bean.getEspecificacionesProcesos().setNombreEspecificacionProceso(res.getString("NOMBRE_ESPECIFICACIONES_PROCESO"));
                bean.getTiposDescripcion().setCodTipoDescripcion(res.getInt("COD_TIPO_DESCRIPCION"));
                bean.getTiposDescripcion().setNombreTipoDescripcion(res.getString("NOMBRE_TIPO_DESCRIPCION"));
                nuevo.getComponentesProdVersionEspecificacionProcesoList().add(bean);
            }
            if(nuevo.getCodProcesoOrdenManufactura()>0)
            {
                procesosOrdenManufacturaList.add(nuevo);
            }
            st.close();
        } catch (SQLException ex) {
            LOGGER.warn("error", ex);
        } finally {
            this.cerrarConexion(con);
        }
        return procesosOrdenManufacturaList;
    }
    
    
}
