/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.web;

import com.cofar.bean.EspecificacionesProcesos;
import com.cofar.bean.FormasFarmaceuticas;
import com.cofar.bean.FormasFarmaceuticasActividadesPreparado;
import com.cofar.bean.Maquinaria;
import com.cofar.bean.ProcesosOrdenManufactura;
import com.cofar.util.Util;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import javax.faces.model.SelectItem;
import org.apache.logging.log4j.LogManager;
import org.richfaces.component.html.HtmlDataTable;

/**
 *
 * @author DASISAQ-
 */
public class ManagedFormasFarmaceuticasActividadesPreparado  extends ManagedBean
{

    private Connection con;
    private String mensaje="";
    private List<FormasFarmaceuticas> formasFarmaceuticasList;
    private HtmlDataTable formasFarmaceuticasDataTable=new HtmlDataTable();
    private FormasFarmaceuticas formasFarmaceuticaBean;
    private List<ProcesosOrdenManufactura>  procesosOrdenManufacturaList;
    private HtmlDataTable procesosOrdenManufacturaDataTable=new HtmlDataTable();
    private ProcesosOrdenManufactura procesosOrdenManufacturaBean;
    private List<FormasFarmaceuticasActividadesPreparado> formasFarmaceuticasActividadesPreparadoList;
    private HtmlDataTable formasFarmaceuticasActividadesDataTable=new HtmlDataTable();
    private FormasFarmaceuticasActividadesPreparado formasFarmaceuticasActividadesPreparadoBean;
    private FormasFarmaceuticasActividadesPreparado formasFarmaceuticasActividadesPreparadoAgregar;
    private FormasFarmaceuticasActividadesPreparado formasFarmaceuticasActividadesPreparadoEditar;
    private List<SelectItem> actividadesPreparadoSelectList;
    
    //para subprocesos
    private List<FormasFarmaceuticasActividadesPreparado> subProcesoformasFarmaceuticasActividadesPreparadoList;
    private FormasFarmaceuticasActividadesPreparado subProcesoFormasFarmaceuticasActividadesPreparadoAgregar;
    private FormasFarmaceuticasActividadesPreparado subProcesoFormasFarmaceuticasActividadesPreparadoEditar;
    
    
    /**
     * Creates a new instance of ManagedFormasFarmaceuticasActividadesPreparado
     */
    // <editor-fold defaultstate="collapsed" desc=" sub procesos">
    public String getCargarEditarSubProcesoFormaFarActividad()
    {
        subProcesoFormasFarmaceuticasActividadesPreparadoEditar.setMaquinariasList(this.cargarFormasFarmaceuticasMaquinariaPreparado(subProcesoFormasFarmaceuticasActividadesPreparadoEditar.getCodFormaFarmaceuticaActividadPreparado()));
        subProcesoFormasFarmaceuticasActividadesPreparadoEditar.setEspecificacionesProcesosList(this.cargarFormasFarmaceuticasEspecificacionesProceso(subProcesoFormasFarmaceuticasActividadesPreparadoEditar.getCodFormaFarmaceuticaActividadPreparado()));
        return null;
    }
    public String getCargarSubProcesosFormaFarmaceuticaActividad()
    {
        subProcesoformasFarmaceuticasActividadesPreparadoList=this.cargarFormasFarmaceuticasActividadesPreparado(formasFarmaceuticasActividadesPreparadoBean.getCodFormaFarmaceuticaActividadPreparado());
        return null;
    }
    public String getCargarAgregarSubProcesoFormaFarActividad()
    {
        subProcesoFormasFarmaceuticasActividadesPreparadoAgregar=new FormasFarmaceuticasActividadesPreparado();
        subProcesoFormasFarmaceuticasActividadesPreparadoAgregar.setMaquinariasList(this.cargarFormasFarmaceuticasMaquinariaPreparado(0));
        subProcesoFormasFarmaceuticasActividadesPreparadoAgregar.setEspecificacionesProcesosList(this.cargarFormasFarmaceuticasEspecificacionesProceso(0));
        return null;
    }
    public String editarSubProcesoFormaFarActividad_action()
    {
        for(FormasFarmaceuticasActividadesPreparado bean:subProcesoformasFarmaceuticasActividadesPreparadoList)
        {
            if(bean.getChecked())
            {
                subProcesoFormasFarmaceuticasActividadesPreparadoEditar=bean;
                break;
            }
        }
        return null;
    }
    public String guardarAgregarSubProcesoFormaFarActividad_action()throws SQLException
    {
        mensaje = "";
        try {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta = new StringBuilder("INSERT INTO FORMAS_FARMACEUTICAS_ACTIVIDADES_PREPARADO( COD_ACTIVIDAD_PREPARADO, NRO_PASO,DESCRIPCION, COD_FORMA, NECESITA_MATERIALES, COD_PROCESO_ORDEN_MANUFACTURA,COD_FORMA_FARMACEUTICA_ACTIVIDAD_PREPARADO_PADRE)");
                                    consulta.append("VALUES (");
                                            consulta.append(subProcesoFormasFarmaceuticasActividadesPreparadoAgregar.getActividadesPreparado().getCodActividadPreparado()).append(",");
                                            consulta.append("(");
                                                consulta.append(" select isnull(max(a.NRO_PASO),0)+1");
                                                consulta.append(" from FORMAS_FARMACEUTICAS_ACTIVIDADES_PREPARADO a");
                                                consulta.append(" where a.COD_FORMA=").append(formasFarmaceuticaBean.getCodForma());
                                                consulta.append(" and a.COD_FORMA_FARMACEUTICA_ACTIVIDAD_PREPARADO_PADRE=").append(formasFarmaceuticasActividadesPreparadoBean.getCodFormaFarmaceuticaActividadPreparado());
                                            consulta.append("),");
                                            consulta.append("?,");
                                            consulta.append(formasFarmaceuticaBean.getCodForma()).append(",");
                                            consulta.append(subProcesoFormasFarmaceuticasActividadesPreparadoAgregar.isNecesitaMateriales()?1:0).append(",");
                                            consulta.append(procesosOrdenManufacturaBean.getCodProcesoOrdenManufactura()).append(",");
                                            consulta.append(formasFarmaceuticasActividadesPreparadoBean.getCodFormaFarmaceuticaActividadPreparado());
                                        consulta.append(")");
            LOGGER.debug("consulta guardar agregar actividad forma" + consulta.toString());
            PreparedStatement pst = con.prepareStatement(consulta.toString(), PreparedStatement.RETURN_GENERATED_KEYS);
            pst.setString(1,subProcesoFormasFarmaceuticasActividadesPreparadoAgregar.getDescripcion());
            if (pst.executeUpdate() > 0) LOGGER.info("Se registro la actividad");
            ResultSet res=pst.getGeneratedKeys();
            if(res.next())subProcesoFormasFarmaceuticasActividadesPreparadoAgregar.setCodFormaFarmaceuticaActividadPreparado(res.getInt(1));
            consulta=new StringBuilder("INSERT INTO FORMAS_FARMACEUTICAS_MAQUINARIA_PREPARADO(COD_FORMA_FARMACEUTICA_ACTIVIDAD_PREPARADO, COD_MAQUINA)");
                      consulta.append(" VALUES (").append(subProcesoFormasFarmaceuticasActividadesPreparadoAgregar.getCodFormaFarmaceuticaActividadPreparado()).append(",?)");
            LOGGER.debug("consulta prepare insert maquina forma far "+consulta.toString());
            pst=con.prepareStatement(consulta.toString());
            for(Maquinaria bean:subProcesoFormasFarmaceuticasActividadesPreparadoAgregar.getMaquinariasList())
            {
                if(bean.getChecked())
                {
                    pst.setString(1, bean.getCodMaquina());
                    if(pst.executeUpdate()>0)LOGGER.info("se registro la maquina "+bean.getCodMaquina());
                }
            }
            consulta=new StringBuilder("INSERT INTO FORMAS_FARMACEUTICAS_ESPECIFICACIONES_PROCESOS(COD_FORMA_FARMACEUTICA_ACTIVIDAD_PREPARADO, COD_ESPECIFICACION_PROCESO)");
                        consulta.append("VALUES (").append(subProcesoFormasFarmaceuticasActividadesPreparadoAgregar.getCodFormaFarmaceuticaActividadPreparado()).append(",?)");
            LOGGER.debug("consulta guardar especificacion form far "+consulta.toString());
            pst=con.prepareStatement(consulta.toString());
            for(EspecificacionesProcesos bean:subProcesoFormasFarmaceuticasActividadesPreparadoAgregar.getEspecificacionesProcesosList())
            {
                if(bean.getChecked())
                {
                    pst.setInt(1,bean.getCodEspecificacionProceso());
                    if(pst.executeUpdate()>0)LOGGER.info("se registro la especificaciones "+bean.getCodEspecificacionProceso());
                }
            }
            con.commit();
            mensaje = "1";
            pst.close();
        }
        catch (SQLException ex) 
        {
            mensaje = "Ocurrio un error al momento de guardar la información,intente de nuevo ";
            con.rollback();
            LOGGER.warn(ex.getMessage());
        }
        catch (Exception ex) 
        {
            mensaje = "Ocurrio un error al momento de guardar la información,verifique los datos introducidos";
            LOGGER.warn(ex.getMessage());
        }
        finally 
        {
            this.cerrarConexion(con);
        }
        return null;
    }
    
    
     public String guardarEditarSubProcesoFormaFarActividad_action()throws SQLException
    {
        mensaje = "";
        try {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta = new StringBuilder("UPDATE FORMAS_FARMACEUTICAS_ACTIVIDADES_PREPARADO");
                                    consulta.append(" SET ");
                                        consulta.append(" COD_ACTIVIDAD_PREPARADO =").append(subProcesoFormasFarmaceuticasActividadesPreparadoEditar.getActividadesPreparado().getCodActividadPreparado()).append(",");
                                        consulta.append(" NRO_PASO =").append(subProcesoFormasFarmaceuticasActividadesPreparadoEditar.getNroPaso()).append(",");
                                        consulta.append(" DESCRIPCION = ?,");
                                        consulta.append(" NECESITA_MATERIALES =").append(subProcesoFormasFarmaceuticasActividadesPreparadoEditar.isNecesitaMateriales()?1:0).append("");
                                    consulta.append(" WHERE COD_FORMA_FARMACEUTICA_ACTIVIDAD_PREPARADO = ").append(subProcesoFormasFarmaceuticasActividadesPreparadoEditar.getCodFormaFarmaceuticaActividadPreparado());
            LOGGER.debug("consulta editar actividad forma" + consulta.toString());
            PreparedStatement pst = con.prepareStatement(consulta.toString());
            pst.setString(1,subProcesoFormasFarmaceuticasActividadesPreparadoEditar.getDescripcion());
            if (pst.executeUpdate() > 0) LOGGER.info("Se guardo la edicion");
            
            //maquinarias
            consulta=new StringBuilder(" DELETE FORMAS_FARMACEUTICAS_MAQUINARIA_PREPARADO");
                        consulta.append(" where COD_FORMA_FARMACEUTICA_ACTIVIDAD_PREPARADO=").append(subProcesoFormasFarmaceuticasActividadesPreparadoEditar.getCodFormaFarmaceuticaActividadPreparado());
            LOGGER.debug("consulta deleta maquinarias paso "+consulta.toString());
            pst=con.prepareStatement(consulta.toString());
            if(pst.executeUpdate()>0)LOGGER.info("se eliminaron maquinarias registradas");
            consulta=new StringBuilder("INSERT INTO FORMAS_FARMACEUTICAS_MAQUINARIA_PREPARADO(COD_FORMA_FARMACEUTICA_ACTIVIDAD_PREPARADO, COD_MAQUINA)");
                      consulta.append(" VALUES (").append(subProcesoFormasFarmaceuticasActividadesPreparadoEditar.getCodFormaFarmaceuticaActividadPreparado()).append(",?)");
            LOGGER.debug("consulta prepare insert maquina forma far "+consulta.toString());
            pst=con.prepareStatement(consulta.toString());
            for(Maquinaria bean:subProcesoFormasFarmaceuticasActividadesPreparadoEditar.getMaquinariasList())
            {
                if(bean.getChecked())
                {
                    pst.setString(1, bean.getCodMaquina());
                    if(pst.executeUpdate()>0)LOGGER.info("se registro la maquina "+bean.getCodMaquina());
                }
            }
            
            //especificaciones procesos
            consulta=new StringBuilder("DELETE  FORMAS_FARMACEUTICAS_ESPECIFICACIONES_PROCESOS");
                        consulta.append(" where COD_FORMA_FARMACEUTICA_ACTIVIDAD_PREPARADO=").append(subProcesoFormasFarmaceuticasActividadesPreparadoEditar.getCodFormaFarmaceuticaActividadPreparado());
            LOGGER.debug("consulta delete especificaciones "+consulta.toString());
            pst=con.prepareStatement(consulta.toString());
            if(pst.executeUpdate()>0)LOGGER.info("se eliminaron anteriores especificaciones");
            
            consulta=new StringBuilder("INSERT INTO FORMAS_FARMACEUTICAS_ESPECIFICACIONES_PROCESOS(COD_FORMA_FARMACEUTICA_ACTIVIDAD_PREPARADO, COD_ESPECIFICACION_PROCESO)");
                        consulta.append("VALUES (").append(subProcesoFormasFarmaceuticasActividadesPreparadoEditar.getCodFormaFarmaceuticaActividadPreparado()).append(",?)");
            LOGGER.debug("consulta guardar especificacion form far "+consulta.toString());
            pst=con.prepareStatement(consulta.toString());
            for(EspecificacionesProcesos bean:subProcesoFormasFarmaceuticasActividadesPreparadoEditar.getEspecificacionesProcesosList())
            {
                if(bean.getChecked())
                {
                    pst.setInt(1,bean.getCodEspecificacionProceso());
                    if(pst.executeUpdate()>0)LOGGER.info("se registro la especificaciones "+bean.getCodEspecificacionProceso());
                }
            }
            con.commit();
            mensaje = "1";
            pst.close();
        }
        catch (SQLException ex) 
        {
            mensaje = "Ocurrio un error al momento de guardar la edición,intente de nuevo ";
            con.rollback();
            LOGGER.warn(ex.getMessage());
        }
        catch (Exception ex) 
        {
            mensaje = "Ocurrio un error al momento de guardar la edición,verifique los datos introducidos";
            LOGGER.warn(ex.getMessage());
        }
        finally 
        {
            this.cerrarConexion(con);
        }
        return null;
    }
     
    public String eliminarSubProcesoFormaFar_action()throws SQLException
    {
        for(FormasFarmaceuticasActividadesPreparado bean:subProcesoformasFarmaceuticasActividadesPreparadoList)
        {
            if(bean.getChecked())
            {
                mensaje = "";
                try {
                    con = Util.openConnection(con);
                    con.setAutoCommit(false);
                    StringBuilder consulta = new StringBuilder("DELETE FORMAS_FARMACEUTICAS_MAQUINARIA_PREPARADO");
                                                consulta.append(" where COD_FORMA_FARMACEUTICA_ACTIVIDAD_PREPARADO =").append(bean.getCodFormaFarmaceuticaActividadPreparado());
                    LOGGER.debug("consulta delete maquinarias " + consulta.toString());
                    PreparedStatement pst = con.prepareStatement(consulta.toString());
                    if (pst.executeUpdate() > 0) LOGGER.info("Se eliminaron las maquinarias");
                    consulta=new StringBuilder("DELETE FORMAS_FARMACEUTICAS_ESPECIFICACIONES_PROCESOS");
                                consulta.append(" where COD_FORMA_FARMACEUTICA_ACTIVIDAD_PREPARADO =").append(bean.getCodFormaFarmaceuticaActividadPreparado());
                    LOGGER.debug("consulta delete especificaicones "+consulta.toString());
                    pst=con.prepareStatement(consulta.toString());
                    if(pst.executeUpdate()>0)LOGGER.info("se elimino la especificacion");
                    consulta=new StringBuilder("DELETE FORMAS_FARMACEUTICAS_ACTIVIDADES_PREPARADO");
                                consulta.append(" where COD_FORMA_FARMACEUTICA_ACTIVIDAD_PREPARADO =").append(bean.getCodFormaFarmaceuticaActividadPreparado());
                    LOGGER.debug("consulta delete actividad "+consulta.toString());
                    pst=con.prepareStatement(consulta.toString());
                    if(pst.executeUpdate()>0)LOGGER.info("se elimino la especificacion");
                    
                    con.commit();
                    mensaje = "1";
                    pst.close();
                } catch (SQLException ex) {
                    mensaje = "Ocurrio un error al momento de eliminar la actividad";
                    con.rollback();
                    LOGGER.warn(ex.getMessage());
                } catch (Exception ex) {
                    mensaje = "Ocurrio un error al momento de eliminar la actividad,verifique los datos introducidos";
                    LOGGER.warn(ex.getMessage());
                } finally {
                    this.cerrarConexion(con);
                }
                break;
            }
        }
        if(mensaje.equals("1"))
        {
            subProcesoformasFarmaceuticasActividadesPreparadoList =this.cargarFormasFarmaceuticasActividadesPreparado(formasFarmaceuticasActividadesPreparadoBean.getCodFormaFarmaceuticaActividadPreparado());
        }
        return null;
    }
    
    //</editor-fold>
    
    
    public String guardarAgregarFormaFarmaceuticaActividadPreparado_action()throws SQLException
    {
        mensaje = "";
        try {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta = new StringBuilder("INSERT INTO FORMAS_FARMACEUTICAS_ACTIVIDADES_PREPARADO( COD_ACTIVIDAD_PREPARADO, NRO_PASO,DESCRIPCION, COD_FORMA, NECESITA_MATERIALES, COD_PROCESO_ORDEN_MANUFACTURA,COD_FORMA_FARMACEUTICA_ACTIVIDAD_PREPARADO_PADRE)");
                                    consulta.append("VALUES (");
                                            consulta.append(formasFarmaceuticasActividadesPreparadoAgregar.getActividadesPreparado().getCodActividadPreparado()).append(",");
                                                consulta.append("(select isnull(max(a.NRO_PASO),0)+1");
                                                consulta.append(" from FORMAS_FARMACEUTICAS_ACTIVIDADES_PREPARADO a");
                                                consulta.append(" where a.COD_FORMA=").append(formasFarmaceuticaBean.getCodForma());
                                                consulta.append(" and a.COD_PROCESO_ORDEN_MANUFACTURA=").append(procesosOrdenManufacturaBean.getCodProcesoOrdenManufactura());
                                                consulta.append(" and a.COD_FORMA_FARMACEUTICA_ACTIVIDAD_PREPARADO_PADRE=0),");
                                            consulta.append("?,");
                                            consulta.append(formasFarmaceuticaBean.getCodForma()).append(",");
                                            consulta.append(formasFarmaceuticasActividadesPreparadoAgregar.isNecesitaMateriales()?1:0).append(",");
                                            consulta.append(procesosOrdenManufacturaBean.getCodProcesoOrdenManufactura()).append(",");
                                            consulta.append("0");
                                        consulta.append(")");
            LOGGER.debug("consulta guardar agregar actividad forma" + consulta.toString());
            PreparedStatement pst = con.prepareStatement(consulta.toString(), PreparedStatement.RETURN_GENERATED_KEYS);
            pst.setString(1,formasFarmaceuticasActividadesPreparadoAgregar.getDescripcion());
            if (pst.executeUpdate() > 0) LOGGER.info("Se registro la actividad");
            ResultSet res=pst.getGeneratedKeys();
            if(res.next())formasFarmaceuticasActividadesPreparadoAgregar.setCodFormaFarmaceuticaActividadPreparado(res.getInt(1));
            consulta=new StringBuilder("INSERT INTO FORMAS_FARMACEUTICAS_MAQUINARIA_PREPARADO(COD_FORMA_FARMACEUTICA_ACTIVIDAD_PREPARADO, COD_MAQUINA)");
                      consulta.append(" VALUES (").append(formasFarmaceuticasActividadesPreparadoAgregar.getCodFormaFarmaceuticaActividadPreparado()).append(",?)");
            LOGGER.debug("consulta prepare insert maquina forma far "+consulta.toString());
            pst=con.prepareStatement(consulta.toString());
            for(Maquinaria bean:formasFarmaceuticasActividadesPreparadoAgregar.getMaquinariasList())
            {
                if(bean.getChecked())
                {
                    pst.setString(1, bean.getCodMaquina());
                    if(pst.executeUpdate()>0)LOGGER.info("se registro la maquina "+bean.getCodMaquina());
                }
            }
            consulta=new StringBuilder("INSERT INTO FORMAS_FARMACEUTICAS_ESPECIFICACIONES_PROCESOS(COD_FORMA_FARMACEUTICA_ACTIVIDAD_PREPARADO, COD_ESPECIFICACION_PROCESO)");
                        consulta.append("VALUES (").append(formasFarmaceuticasActividadesPreparadoAgregar.getCodFormaFarmaceuticaActividadPreparado()).append(",?)");
            LOGGER.debug("consulta guardar especificacion form far "+consulta.toString());
            pst=con.prepareStatement(consulta.toString());
            for(EspecificacionesProcesos bean:formasFarmaceuticasActividadesPreparadoAgregar.getEspecificacionesProcesosList())
            {
                if(bean.getChecked())
                {
                    pst.setInt(1,bean.getCodEspecificacionProceso());
                    if(pst.executeUpdate()>0)LOGGER.info("se registro la especificaciones "+bean.getCodEspecificacionProceso());
                }
            }
            con.commit();
            mensaje = "1";
            pst.close();
        }
        catch (SQLException ex) 
        {
            mensaje = "Ocurrio un error al momento de guardar la información,intente de nuevo ";
            con.rollback();
            LOGGER.warn(ex.getMessage());
        }
        catch (Exception ex) 
        {
            mensaje = "Ocurrio un error al momento de guardar la información,verifique los datos introducidos";
            LOGGER.warn(ex.getMessage());
        }
        finally 
        {
            this.cerrarConexion(con);
        }
        return null;
    }
    
    
    public String guardarEditarFormaFarmaceuticaActividadPreparado_action()throws SQLException
    {
        mensaje = "";
        try {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta = new StringBuilder("UPDATE FORMAS_FARMACEUTICAS_ACTIVIDADES_PREPARADO");
                                    consulta.append(" SET ");
                                        consulta.append(" COD_ACTIVIDAD_PREPARADO =").append(formasFarmaceuticasActividadesPreparadoEditar.getActividadesPreparado().getCodActividadPreparado()).append(",");
                                        consulta.append(" NRO_PASO =").append(formasFarmaceuticasActividadesPreparadoEditar.getNroPaso()).append(",");
                                        consulta.append(" DESCRIPCION = ?,");
                                        consulta.append(" NECESITA_MATERIALES =").append(formasFarmaceuticasActividadesPreparadoEditar.isNecesitaMateriales()?1:0).append("");
                                    consulta.append(" WHERE COD_FORMA_FARMACEUTICA_ACTIVIDAD_PREPARADO = ").append(formasFarmaceuticasActividadesPreparadoEditar.getCodFormaFarmaceuticaActividadPreparado());
            LOGGER.debug("consulta editar actividad forma" + consulta.toString());
            PreparedStatement pst = con.prepareStatement(consulta.toString());
            pst.setString(1,formasFarmaceuticasActividadesPreparadoEditar.getDescripcion());
            if (pst.executeUpdate() > 0) LOGGER.info("Se guardo la edicion");
            
            //maquinarias
            consulta=new StringBuilder(" DELETE FORMAS_FARMACEUTICAS_MAQUINARIA_PREPARADO");
                        consulta.append(" where COD_FORMA_FARMACEUTICA_ACTIVIDAD_PREPARADO=").append(formasFarmaceuticasActividadesPreparadoEditar.getCodFormaFarmaceuticaActividadPreparado());
            LOGGER.debug("consulta deleta maquinarias paso "+consulta.toString());
            if(pst.executeUpdate()>0)LOGGER.info("se eliminaron maquinarias registradas");
            consulta=new StringBuilder("INSERT INTO FORMAS_FARMACEUTICAS_MAQUINARIA_PREPARADO(COD_FORMA_FARMACEUTICA_ACTIVIDAD_PREPARADO, COD_MAQUINA)");
                      consulta.append(" VALUES (").append(formasFarmaceuticasActividadesPreparadoEditar.getCodFormaFarmaceuticaActividadPreparado()).append(",?)");
            LOGGER.debug("consulta prepare insert maquina forma far "+consulta.toString());
            pst=con.prepareStatement(consulta.toString());
            for(Maquinaria bean:formasFarmaceuticasActividadesPreparadoEditar.getMaquinariasList())
            {
                if(bean.getChecked())
                {
                    pst.setString(1, bean.getCodMaquina());
                    if(pst.executeUpdate()>0)LOGGER.info("se registro la maquina "+bean.getCodMaquina());
                }
            }
            
            //especificaciones procesos
            consulta=new StringBuilder("DELETE  FORMAS_FARMACEUTICAS_ESPECIFICACIONES_PROCESOS");
                        consulta.append(" where COD_FORMA_FARMACEUTICA_ACTIVIDAD_PREPARADO=").append(formasFarmaceuticasActividadesPreparadoEditar.getCodFormaFarmaceuticaActividadPreparado());
            LOGGER.debug("consulta delete especificaciones "+consulta.toString());
            pst=con.prepareStatement(consulta.toString());
            if(pst.executeUpdate()>0)LOGGER.info("se eliminaron anteriores especificaciones");
            
            consulta=new StringBuilder("INSERT INTO FORMAS_FARMACEUTICAS_ESPECIFICACIONES_PROCESOS(COD_FORMA_FARMACEUTICA_ACTIVIDAD_PREPARADO, COD_ESPECIFICACION_PROCESO)");
                        consulta.append("VALUES (").append(formasFarmaceuticasActividadesPreparadoEditar.getCodFormaFarmaceuticaActividadPreparado()).append(",?)");
            LOGGER.debug("consulta guardar especificacion form far "+consulta.toString());
            pst=con.prepareStatement(consulta.toString());
            for(EspecificacionesProcesos bean:formasFarmaceuticasActividadesPreparadoEditar.getEspecificacionesProcesosList())
            {
                if(bean.getChecked())
                {
                    pst.setInt(1,bean.getCodEspecificacionProceso());
                    if(pst.executeUpdate()>0)LOGGER.info("se registro la especificaciones "+bean.getCodEspecificacionProceso());
                }
            }
            con.commit();
            mensaje = "1";
            pst.close();
        }
        catch (SQLException ex) 
        {
            mensaje = "Ocurrio un error al momento de guardar la edición,intente de nuevo ";
            con.rollback();
            LOGGER.warn(ex.getMessage());
        }
        catch (Exception ex) 
        {
            mensaje = "Ocurrio un error al momento de guardar la edición,verifique los datos introducidos";
            LOGGER.warn(ex.getMessage());
        }
        finally 
        {
            this.cerrarConexion(con);
        }
        return null;
    }
    
    public String eliminarFormaFarmaceuticaActividadPreparado_action()throws SQLException
    {
        for(FormasFarmaceuticasActividadesPreparado bean:formasFarmaceuticasActividadesPreparadoList)
        {
            if(bean.getChecked())
            {
                mensaje = "";
                try {
                    con = Util.openConnection(con);
                    con.setAutoCommit(false);
                    StringBuilder consulta =new StringBuilder("select count(*)as cantidadProcesos");
                                              consulta.append(" from PROCESOS_PREPARADO_PRODUCTO p");
                                              consulta.append(" where p.COD_FORMA_FARMACEUTICA_ACTIVIDAD_PREPARADO=").append(bean.getCodFormaFarmaceuticaActividadPreparado());
                    LOGGER.debug("cosnulta verificar cantidad de procesos dependientes "+consulta.toString());
                    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet res=st.executeQuery(consulta.toString());
                    res.next();
                    if(res.getInt("cantidadProcesos")==0)
                    {
                        consulta=new StringBuilder("DELETE FORMAS_FARMACEUTICAS_MAQUINARIA_PREPARADO");
                                    consulta.append(" where COD_FORMA_FARMACEUTICA_ACTIVIDAD_PREPARADO =").append(bean.getCodFormaFarmaceuticaActividadPreparado());
                        LOGGER.debug("consulta delete maquinarias " + consulta.toString());
                        PreparedStatement pst = con.prepareStatement(consulta.toString());
                        if (pst.executeUpdate() > 0) LOGGER.info("Se eliminaron las maquinarias");
                        consulta=new StringBuilder("DELETE FORMAS_FARMACEUTICAS_ESPECIFICACIONES_PROCESOS");
                                    consulta.append(" where COD_FORMA_FARMACEUTICA_ACTIVIDAD_PREPARADO =").append(bean.getCodFormaFarmaceuticaActividadPreparado());
                        LOGGER.debug("consulta delete especificaicones "+consulta.toString());
                        pst=con.prepareStatement(consulta.toString());
                        if(pst.executeUpdate()>0)LOGGER.info("se elimino la especificacion");
                        consulta=new StringBuilder("DELETE FORMAS_FARMACEUTICAS_ACTIVIDADES_PREPARADO");
                                    consulta.append(" where COD_FORMA_FARMACEUTICA_ACTIVIDAD_PREPARADO =").append(bean.getCodFormaFarmaceuticaActividadPreparado());
                        LOGGER.debug("consulta delete actividad "+consulta.toString());
                        pst=con.prepareStatement(consulta.toString());
                        if(pst.executeUpdate()>0)LOGGER.info("se elimino la especificacion");
                        mensaje = "1";
                    }
                    else
                    {
                        mensaje="No se puede eliminar el proceso ya que est relacionado con"+res.getInt("cantidadProcesos")+" proceso(s) de producto(s)";
                    }
                    con.commit();
                    
                } catch (SQLException ex) {
                    mensaje = "Ocurrio un error al momento de eliminar la actividad";
                    con.rollback();
                    LOGGER.warn(ex.getMessage());
                } catch (Exception ex) {
                    mensaje = "Ocurrio un error al momento de eliminar la actividad,verifique los datos introducidos";
                    LOGGER.warn(ex.getMessage());
                } finally {
                    this.cerrarConexion(con);
                }
                break;
            }
        }
        if(mensaje.equals("1"))
        {
            formasFarmaceuticasActividadesPreparadoList=this.cargarFormasFarmaceuticasActividadesPreparado(0);
        }
        return null;
    }
    public String editarFormaFarmaceuticaActividadPreparado_action()
    {
        for(FormasFarmaceuticasActividadesPreparado bean:formasFarmaceuticasActividadesPreparadoList)
        {
            if(bean.getChecked())
            {
                formasFarmaceuticasActividadesPreparadoEditar=bean;
                break;
            }
        }
        return null;
    }
    public String getCargarEditarFormaFarmaceuticaActividadPreparado()
    {
        formasFarmaceuticasActividadesPreparadoEditar.setMaquinariasList(this.cargarFormasFarmaceuticasMaquinariaPreparado(formasFarmaceuticasActividadesPreparadoEditar.getCodFormaFarmaceuticaActividadPreparado()));
        formasFarmaceuticasActividadesPreparadoEditar.setEspecificacionesProcesosList(this.cargarFormasFarmaceuticasEspecificacionesProceso(formasFarmaceuticasActividadesPreparadoEditar.getCodFormaFarmaceuticaActividadPreparado()));
        return null;
    }
    private void cargarActividadesPreparadoSelectList()
    {
        try 
        {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select ap.COD_ACTIVIDAD_PREPARADO,ap.NOMBRE_ACTIVIDAD_PREPARADO");
                                        consulta.append(" from ACTIVIDADES_PREPARADO ap");
                                        consulta.append(" where ap.cod_forma=0");
                                        consulta.append(" order by ap.NOMBRE_ACTIVIDAD_PREPARADO");
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            actividadesPreparadoSelectList=new ArrayList<SelectItem>();
            while (res.next()) 
            {
                actividadesPreparadoSelectList.add(new SelectItem(res.getInt("COD_ACTIVIDAD_PREPARADO"),res.getString("NOMBRE_ACTIVIDAD_PREPARADO")));
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
    }
    private List<EspecificacionesProcesos> cargarFormasFarmaceuticasEspecificacionesProceso(int codFormaFarmaceuticaActividadPreparado)
    {
        List<EspecificacionesProcesos> especificacionesProcesosList=new ArrayList<EspecificacionesProcesos>();
        try 
        {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select ep.COD_ESPECIFICACION_PROCESO,ep.NOMBRE_ESPECIFICACIONES_PROCESO,isnull(ffep.COD_ESPECIFICACION_PROCESO,0) as registrado");
                                            consulta.append(" ,td.NOMBRE_TIPO_DESCRIPCION,um.NOMBRE_UNIDAD_MEDIDA");
                                        consulta.append(" from ESPECIFICACIONES_PROCESOS ep");
                                            consulta.append(" left outer join TIPOS_DESCRIPCION td on td.COD_TIPO_DESCRIPCION=ep.COD_TIPO_DESCRIPCION");
                                            consulta.append(" left outer join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=ep.COD_UNIDAD_MEDIDA");
                                            consulta.append(" left outer join FORMAS_FARMACEUTICAS_ESPECIFICACIONES_PROCESOS ffep on ");
                                            consulta.append(" ep.COD_ESPECIFICACION_PROCESO=ffep.COD_ESPECIFICACION_PROCESO and ffep.COD_FORMA_FARMACEUTICA_ACTIVIDAD_PREPARADO=").append(codFormaFarmaceuticaActividadPreparado);
                                        consulta.append(" where ep.COD_TIPO_ESPECIFICACION_PROCESO=1");
                                            consulta.append(" and ep.COD_FORMA=0");
                                        consulta.append(" order by case when ffep.COD_ESPECIFICACION_PROCESO>0 then 1 else 2 end, ep.NOMBRE_ESPECIFICACIONES_PROCESO desc");
            LOGGER.debug("consulta cargar especificaciones paso prepado "+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            while (res.next()) 
            {
                EspecificacionesProcesos nuevo=new EspecificacionesProcesos();
                nuevo.setCodEspecificacionProceso(res.getInt("COD_ESPECIFICACION_PROCESO"));
                nuevo.setNombreEspecificacionProceso(res.getString("NOMBRE_ESPECIFICACIONES_PROCESO"));
                nuevo.getTiposDescripcion().setNombreTipoDescripcion(res.getString("NOMBRE_TIPO_DESCRIPCION"));
                nuevo.getUnidadMedida().setNombreUnidadMedida(res.getString("NOMBRE_UNIDAD_MEDIDA"));
                nuevo.setChecked(res.getInt("registrado")>0);
                especificacionesProcesosList.add(nuevo);
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
        return especificacionesProcesosList;
    }
    private List<Maquinaria> cargarFormasFarmaceuticasMaquinariaPreparado(int codFormaFarmaceuticaActividadPreparado)
    {
        List<Maquinaria> maquinariaList=new ArrayList<Maquinaria>();
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select m.COD_MAQUINA,m.NOMBRE_MAQUINA,m.CODIGO,isnull(ffm.COD_MAQUINA,0) as registrado");
                                    consulta.append(" from maquinarias m");
                                    consulta.append(" left outer join FORMAS_FARMACEUTICAS_MAQUINARIA_PREPARADO ffm on ffm.COD_MAQUINA=m.COD_MAQUINA");
                                    consulta.append(" and ffm.COD_FORMA_FARMACEUTICA_ACTIVIDAD_PREPARADO=").append(codFormaFarmaceuticaActividadPreparado);
                                    consulta.append(" where m.COD_AREA_EMPRESA in ");
                                    consulta.append(" (");
                                    consulta.append(" select  DISTINCT c.COD_AREA_EMPRESA from COMPONENTES_PROD c where c.COD_FORMA=").append(formasFarmaceuticaBean.getCodForma());
                                    consulta.append(" )");
                                    consulta.append(" order by case when ffm.COD_MAQUINA>0 then 1 else 2 end,m.NOMBRE_MAQUINA");
            LOGGER.debug("consulta cargar maquinaria proceso "+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            while (res.next()) 
            {
                Maquinaria maquinaria=new Maquinaria();
                maquinaria.setCodMaquina(res.getString("COD_MAQUINA"));
                maquinaria.setNombreMaquina(res.getString("NOMBRE_MAQUINA"));
                maquinaria.setCodigo(res.getString("CODIGO"));
                maquinaria.setChecked(res.getInt("registrado")>0);
                maquinariaList.add(maquinaria);
                
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
        return maquinariaList;
    }
    public ManagedFormasFarmaceuticasActividadesPreparado() {
        LOGGER=LogManager.getLogger("Versionamiento");
    }
    // <editor-fold defaultstate="collapsed" desc="funciones de listado de formas farmaceuticas">
    public String seleccionFormasFarmaceutica_action()
    {
        formasFarmaceuticaBean=(FormasFarmaceuticas)formasFarmaceuticasDataTable.getRowData();
        this.cargarProcesosFormasFarmaceutica();
        return null;
    }
    public String getCargarFormasFarmaceuticas()
    {
        this.cargarFormasFarmaceuticas();
        return null;
    }
    private void cargarFormasFarmaceuticas()
    {
        try 
        {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select ff.cod_forma,ff.nombre_forma,ff.abreviatura_forma,um.NOMBRE_UNIDAD_MEDIDA,ff.obs_forma");
                                        consulta.append(" from FORMAS_FARMACEUTICAS ff");
                                            consulta.append(" inner join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=ff.cod_unidad_medida");
                                        consulta.append(" order by ff.nombre_forma");
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            formasFarmaceuticasList=new ArrayList<FormasFarmaceuticas>();
            while (res.next()) 
            {
                FormasFarmaceuticas nuevo=new FormasFarmaceuticas();
                nuevo.setCodForma(res.getString("cod_forma"));
                nuevo.setNombreForma(res.getString("nombre_forma"));
                nuevo.setAbreviaturaForma(res.getString("abreviatura_forma"));
                nuevo.setObsForma(res.getString("obs_forma"));
                nuevo.getUnidadMedida().setNombreUnidadMedida(res.getString("NOMBRE_UNIDAD_MEDIDA"));
                formasFarmaceuticasList.add(nuevo);
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
    }
    private void cargarProcesosFormasFarmaceutica()
    {
        try 
        {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select ffpom.COD_PROCESO_ORDEN_MANUFACTURA,pom.NOMBRE_PROCESO_ORDEN_MANUFACTURA");
                                     consulta.append(" from FORMAS_FARMACEUTICAS_PROCESO_ORDEN_MANUFACTURA ffpom ");
                                     consulta.append(" inner join PROCESOS_ORDEN_MANUFACTURA pom on pom.COD_PROCESO_ORDEN_MANUFACTURA=ffpom.COD_PROCESO_ORDEN_MANUFACTURA");
                                     consulta.append(" where ffpom.COD_FORMA=").append(formasFarmaceuticaBean.getCodForma());
                                     consulta.append(" and ffpom.APLICA_FLUJOGRAMA=1");
                                     consulta.append(" order by ffpom.ORDEN");
            LOGGER.debug("conulca cargar procesos habilitados para forma farmaceutica "+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            procesosOrdenManufacturaList=new ArrayList<ProcesosOrdenManufactura>();
            while (res.next()) 
            {
                ProcesosOrdenManufactura nuevo=new ProcesosOrdenManufactura();
                nuevo.setCodProcesoOrdenManufactura(res.getInt("COD_PROCESO_ORDEN_MANUFACTURA"));
                nuevo.setNombreProcesoOrdenManufactura(res.getString("NOMBRE_PROCESO_ORDEN_MANUFACTURA"));
                procesosOrdenManufacturaList.add(nuevo);
            }
            st.close();
        } catch (SQLException ex) {
            LOGGER.warn("error", ex);
        } finally {
            this.cerrarConexion(con);
        }
    }
    public String seleccionarProcesoOrdenManufactura_action()
    {
        procesosOrdenManufacturaBean=(ProcesosOrdenManufactura)procesosOrdenManufacturaDataTable.getRowData();
        return null;
    }
    //</editor-fold>
    
    public String getCargarFormasFarmaceuticasActividadesPreparado()
    {
        //cargar todos los procesos sin proceso padre
        this.cargarActividadesPreparadoSelectList();
        this.cargarFormasFarmaceuticasActividadesPreparado();
        return null;
    }
    
    public String seleccionarFormaFarmaceuticaActividadPreparado_action()
    {
        formasFarmaceuticasActividadesPreparadoBean=(FormasFarmaceuticasActividadesPreparado)formasFarmaceuticasActividadesDataTable.getRowData();
        return null;
    }
    private void cargarFormasFarmaceuticasActividadesPreparado()
    {
        
        try 
        {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select ffap.NRO_PASO,ap.COD_ACTIVIDAD_PREPARADO,ap.NOMBRE_ACTIVIDAD_PREPARADO");
                                            consulta.append(",ffap.COD_FORMA_FARMACEUTICA_ACTIVIDAD_PREPARADO,ffap.NECESITA_MATERIALES,ffap.DESCRIPCION");
                                            consulta.append(" ,m.CODIGO,m.NOMBRE_MAQUINA");
                                        consulta.append(" from FORMAS_FARMACEUTICAS_ACTIVIDADES_PREPARADO ffap");
                                            consulta.append(" inner join ACTIVIDADES_PREPARADO ap on ffap.COD_ACTIVIDAD_PREPARADO=ap.COD_ACTIVIDAD_PREPARADO");
                                            consulta.append(" left outer join FORMAS_FARMACEUTICAS_MAQUINARIA_PREPARADO ffmp on  ffmp.COD_FORMA_FARMACEUTICA_ACTIVIDAD_PREPARADO=ffap.COD_FORMA_FARMACEUTICA_ACTIVIDAD_PREPARADO");
                                            consulta.append(" left outer join MAQUINARIAS m on m.COD_MAQUINA=ffmp.COD_MAQUINA");
                                        consulta.append(" where ffap.COD_FORMA=").append(formasFarmaceuticaBean.getCodForma());
                                            consulta.append(" and ffap.COD_PROCESO_ORDEN_MANUFACTURA=").append(procesosOrdenManufacturaBean.getCodProcesoOrdenManufactura());
                                            consulta.append(" and ffap.COD_FORMA_FARMACEUTICA_ACTIVIDAD_PREPARADO_PADRE=?");
                                        consulta.append(" order by ffap.NRO_PASO");
                                        LOGGER.debug("consulta cargar pasos "+consulta.toString());
            PreparedStatement pst=con.prepareStatement(consulta.toString());
            ResultSet resDetalle;
            consulta = new StringBuilder("select ffap.NRO_PASO,ap.COD_ACTIVIDAD_PREPARADO,ap.NOMBRE_ACTIVIDAD_PREPARADO");
                            consulta.append(",ffap.COD_FORMA_FARMACEUTICA_ACTIVIDAD_PREPARADO,ffap.NECESITA_MATERIALES,ffap.DESCRIPCION");
                            consulta.append(" ,m.CODIGO,m.NOMBRE_MAQUINA");
                        consulta.append(" from FORMAS_FARMACEUTICAS_ACTIVIDADES_PREPARADO ffap");
                            consulta.append(" inner join ACTIVIDADES_PREPARADO ap on ffap.COD_ACTIVIDAD_PREPARADO=ap.COD_ACTIVIDAD_PREPARADO");
                            consulta.append(" left outer join FORMAS_FARMACEUTICAS_MAQUINARIA_PREPARADO ffmp on  ffmp.COD_FORMA_FARMACEUTICA_ACTIVIDAD_PREPARADO=ffap.COD_FORMA_FARMACEUTICA_ACTIVIDAD_PREPARADO");
                            consulta.append(" left outer join MAQUINARIAS m on m.COD_MAQUINA=ffmp.COD_MAQUINA");
                        consulta.append(" where ffap.COD_FORMA=").append(formasFarmaceuticaBean.getCodForma());
                            consulta.append(" and ffap.COD_PROCESO_ORDEN_MANUFACTURA=").append(procesosOrdenManufacturaBean.getCodProcesoOrdenManufactura());
                            consulta.append(" and ffap.COD_FORMA_FARMACEUTICA_ACTIVIDAD_PREPARADO_PADRE=0");
                        consulta.append(" order by ffap.NRO_PASO");
            LOGGER.debug("consulta cargar actividades preparado "+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            formasFarmaceuticasActividadesPreparadoList=new ArrayList<FormasFarmaceuticasActividadesPreparado>();
            FormasFarmaceuticasActividadesPreparado nuevo=new FormasFarmaceuticasActividadesPreparado();
            while (res.next()) 
            {
                if(nuevo.getCodFormaFarmaceuticaActividadPreparado()!=res.getInt("COD_FORMA_FARMACEUTICA_ACTIVIDAD_PREPARADO"))
                {
                    if(nuevo.getCodFormaFarmaceuticaActividadPreparado()>0)
                    {
                        formasFarmaceuticasActividadesPreparadoList.add(nuevo);
                    }
                    nuevo=new FormasFarmaceuticasActividadesPreparado();
                    nuevo.setNroPaso(res.getInt("NRO_PASO"));
                    nuevo.setCodFormaFarmaceuticaActividadPreparado(res.getInt("COD_FORMA_FARMACEUTICA_ACTIVIDAD_PREPARADO"));
                    nuevo.setNecesitaMateriales(res.getInt("NECESITA_MATERIALES")>0);
                    nuevo.setDescripcion(res.getString("DESCRIPCION"));
                    nuevo.getActividadesPreparado().setCodActividadPreparado(res.getInt("COD_ACTIVIDAD_PREPARADO"));
                    nuevo.getActividadesPreparado().setNombreActividadPreparado(res.getString("NOMBRE_ACTIVIDAD_PREPARADO"));
                    nuevo.setMaquinariasList(new ArrayList<Maquinaria>());
                    nuevo.setSubFormasFarmaceuticasActividadesPreparadoList(new ArrayList<FormasFarmaceuticasActividadesPreparado>());
                    // <editor-fold defaultstate="collapsed" desc="cargar sub procesos">
                pst.setInt(1,nuevo.getCodFormaFarmaceuticaActividadPreparado());
                resDetalle=pst.executeQuery();
                FormasFarmaceuticasActividadesPreparado subActividad=new FormasFarmaceuticasActividadesPreparado();
                while(resDetalle.next())
                {
                    if(subActividad.getCodFormaFarmaceuticaActividadPreparado()!=resDetalle.getInt("COD_FORMA_FARMACEUTICA_ACTIVIDAD_PREPARADO"))
                    {
                            if(subActividad.getCodFormaFarmaceuticaActividadPreparado()>0)
                            {
                                nuevo.getSubFormasFarmaceuticasActividadesPreparadoList().add(subActividad);
                            }
                            subActividad=new FormasFarmaceuticasActividadesPreparado();
                            subActividad.setNroPaso(resDetalle.getInt("NRO_PASO"));
                            subActividad.setCodFormaFarmaceuticaActividadPreparado(resDetalle.getInt("COD_FORMA_FARMACEUTICA_ACTIVIDAD_PREPARADO"));
                            subActividad.setNecesitaMateriales(resDetalle.getInt("NECESITA_MATERIALES")>0);
                            subActividad.setDescripcion(resDetalle.getString("DESCRIPCION"));
                            subActividad.getActividadesPreparado().setCodActividadPreparado(resDetalle.getInt("COD_ACTIVIDAD_PREPARADO"));
                            subActividad.getActividadesPreparado().setNombreActividadPreparado(resDetalle.getString("NOMBRE_ACTIVIDAD_PREPARADO"));
                            subActividad.setMaquinariasList(new ArrayList<Maquinaria>());
                    }
                        Maquinaria subMaquina=new Maquinaria();
                        subMaquina.setNombreMaquina(resDetalle.getString("NOMBRE_MAQUINA"));
                        subMaquina.setCodigo(resDetalle.getString("CODIGO"));
                        subActividad.getMaquinariasList().add(subMaquina);
                }
                if(subActividad.getCodFormaFarmaceuticaActividadPreparado()>0)
                {
                    nuevo.getSubFormasFarmaceuticasActividadesPreparadoList().add(subActividad);
                }
                //</editor-fold>
                }
                Maquinaria maquinaria=new Maquinaria();
                maquinaria.setNombreMaquina(res.getString("NOMBRE_MAQUINA"));
                maquinaria.setCodigo(res.getString("CODIGO"));
                nuevo.getMaquinariasList().add(maquinaria);
                
                
            }
            if(nuevo.getCodFormaFarmaceuticaActividadPreparado()>0)
            {
                formasFarmaceuticasActividadesPreparadoList.add(nuevo);
            }
            st.close();
        } catch (SQLException ex) {
            LOGGER.warn("error", ex);
        } finally {
            this.cerrarConexion(con);
        }
    }
    //funcion para cargar todos los pasos utilizado para procesos principales y subprocesos
    private List<FormasFarmaceuticasActividadesPreparado> cargarFormasFarmaceuticasActividadesPreparado(int codFormaFarmaceuticaActividadPreparado)
    {
        List<FormasFarmaceuticasActividadesPreparado> actividadesList=new ArrayList<FormasFarmaceuticasActividadesPreparado>();
        try 
        {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select ffap.NRO_PASO,ap.COD_ACTIVIDAD_PREPARADO,ap.NOMBRE_ACTIVIDAD_PREPARADO");
                                            consulta.append(",ffap.COD_FORMA_FARMACEUTICA_ACTIVIDAD_PREPARADO,ffap.NECESITA_MATERIALES,ffap.DESCRIPCION");
                                            consulta.append(" ,m.CODIGO,m.NOMBRE_MAQUINA");
                                        consulta.append(" from FORMAS_FARMACEUTICAS_ACTIVIDADES_PREPARADO ffap");
                                            consulta.append(" inner join ACTIVIDADES_PREPARADO ap on ffap.COD_ACTIVIDAD_PREPARADO=ap.COD_ACTIVIDAD_PREPARADO");
                                            consulta.append(" left outer join FORMAS_FARMACEUTICAS_MAQUINARIA_PREPARADO ffmp on  ffmp.COD_FORMA_FARMACEUTICA_ACTIVIDAD_PREPARADO=ffap.COD_FORMA_FARMACEUTICA_ACTIVIDAD_PREPARADO");
                                            consulta.append(" left outer join MAQUINARIAS m on m.COD_MAQUINA=ffmp.COD_MAQUINA");
                                        consulta.append(" where ffap.COD_FORMA=").append(formasFarmaceuticaBean.getCodForma());
                                            consulta.append(" and ffap.COD_PROCESO_ORDEN_MANUFACTURA=").append(procesosOrdenManufacturaBean.getCodProcesoOrdenManufactura());
                                            consulta.append(" and ffap.COD_FORMA_FARMACEUTICA_ACTIVIDAD_PREPARADO_PADRE=").append(codFormaFarmaceuticaActividadPreparado);
                                        consulta.append(" order by ffap.NRO_PASO");
            LOGGER.debug("consulta cargar actividades preparado "+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            FormasFarmaceuticasActividadesPreparado nuevo=new FormasFarmaceuticasActividadesPreparado();
            while (res.next()) 
            {
                if(nuevo.getCodFormaFarmaceuticaActividadPreparado()!=res.getInt("COD_FORMA_FARMACEUTICA_ACTIVIDAD_PREPARADO"))
                {
                    if(nuevo.getCodFormaFarmaceuticaActividadPreparado()>0)
                    {
                        actividadesList.add(nuevo);
                    }
                    nuevo=new FormasFarmaceuticasActividadesPreparado();
                    nuevo.setNroPaso(res.getInt("NRO_PASO"));
                    nuevo.setCodFormaFarmaceuticaActividadPreparado(res.getInt("COD_FORMA_FARMACEUTICA_ACTIVIDAD_PREPARADO"));
                    nuevo.setNecesitaMateriales(res.getInt("NECESITA_MATERIALES")>0);
                    nuevo.setDescripcion(res.getString("DESCRIPCION"));
                    nuevo.getActividadesPreparado().setCodActividadPreparado(res.getInt("COD_ACTIVIDAD_PREPARADO"));
                    nuevo.getActividadesPreparado().setNombreActividadPreparado(res.getString("NOMBRE_ACTIVIDAD_PREPARADO"));
                    nuevo.setMaquinariasList(new ArrayList<Maquinaria>());
                }
                Maquinaria maquinaria=new Maquinaria();
                maquinaria.setCodigo(res.getString("CODIGO"));
                maquinaria.setNombreAreaMaquina(res.getString("NOMBRE_MAQUINA"));
                nuevo.getMaquinariasList().add(maquinaria);
            }
            if(nuevo.getCodFormaFarmaceuticaActividadPreparado()>0)
            {
                actividadesList.add(nuevo);
            }
            st.close();
        } catch (SQLException ex) {
            LOGGER.warn("error", ex);
        } finally {
            this.cerrarConexion(con);
        }
        return actividadesList;
    }

    public String getCargarAgregarFormaFarmaceuticaActividad()
    {
        
        formasFarmaceuticasActividadesPreparadoAgregar=new FormasFarmaceuticasActividadesPreparado();
        formasFarmaceuticasActividadesPreparadoAgregar.setMaquinariasList(this.cargarFormasFarmaceuticasMaquinariaPreparado(0));
        formasFarmaceuticasActividadesPreparadoAgregar.setEspecificacionesProcesosList(this.cargarFormasFarmaceuticasEspecificacionesProceso(0));
        return null;
    }
    public String getMensaje() {
        return mensaje;
    }

    public void setMensaje(String mensaje) {
        this.mensaje = mensaje;
    }

    public List<FormasFarmaceuticas> getFormasFarmaceuticasList() {
        return formasFarmaceuticasList;
    }

    public void setFormasFarmaceuticasList(List<FormasFarmaceuticas> formasFarmaceuticasList) {
        this.formasFarmaceuticasList = formasFarmaceuticasList;
    }

    public HtmlDataTable getFormasFarmaceuticasDataTable() {
        return formasFarmaceuticasDataTable;
    }

    public void setFormasFarmaceuticasDataTable(HtmlDataTable formasFarmaceuticasDataTable) {
        this.formasFarmaceuticasDataTable = formasFarmaceuticasDataTable;
    }

    public FormasFarmaceuticas getFormasFarmaceuticaBean() {
        return formasFarmaceuticaBean;
    }

    public void setFormasFarmaceuticaBean(FormasFarmaceuticas formasFarmaceuticaBean) {
        this.formasFarmaceuticaBean = formasFarmaceuticaBean;
    }

    public List<ProcesosOrdenManufactura> getProcesosOrdenManufacturaList() {
        return procesosOrdenManufacturaList;
    }

    public void setProcesosOrdenManufacturaList(List<ProcesosOrdenManufactura> procesosOrdenManufacturaList) {
        this.procesosOrdenManufacturaList = procesosOrdenManufacturaList;
    }

    public HtmlDataTable getProcesosOrdenManufacturaDataTable() {
        return procesosOrdenManufacturaDataTable;
    }

    public void setProcesosOrdenManufacturaDataTable(HtmlDataTable procesosOrdenManufacturaDataTable) {
        this.procesosOrdenManufacturaDataTable = procesosOrdenManufacturaDataTable;
    }

    public ProcesosOrdenManufactura getProcesosOrdenManufacturaBean() {
        return procesosOrdenManufacturaBean;
    }

    public void setProcesosOrdenManufacturaBean(ProcesosOrdenManufactura procesosOrdenManufacturaBean) {
        this.procesosOrdenManufacturaBean = procesosOrdenManufacturaBean;
    }

    public List<FormasFarmaceuticasActividadesPreparado> getFormasFarmaceuticasActividadesPreparadoList() {
        return formasFarmaceuticasActividadesPreparadoList;
    }

    public void setFormasFarmaceuticasActividadesPreparadoList(List<FormasFarmaceuticasActividadesPreparado> formasFarmaceuticasActividadesPreparadoList) {
        this.formasFarmaceuticasActividadesPreparadoList = formasFarmaceuticasActividadesPreparadoList;
    }

    public HtmlDataTable getFormasFarmaceuticasActividadesDataTable() {
        return formasFarmaceuticasActividadesDataTable;
    }

    public void setFormasFarmaceuticasActividadesDataTable(HtmlDataTable formasFarmaceuticasActividadesDataTable) {
        this.formasFarmaceuticasActividadesDataTable = formasFarmaceuticasActividadesDataTable;
    }

    public FormasFarmaceuticasActividadesPreparado getFormasFarmaceuticasActividadesPreparadoBean() {
        return formasFarmaceuticasActividadesPreparadoBean;
    }

    public void setFormasFarmaceuticasActividadesPreparadoBean(FormasFarmaceuticasActividadesPreparado formasFarmaceuticasActividadesPreparadoBean) {
        this.formasFarmaceuticasActividadesPreparadoBean = formasFarmaceuticasActividadesPreparadoBean;
    }

    public FormasFarmaceuticasActividadesPreparado getFormasFarmaceuticasActividadesPreparadoAgregar() {
        return formasFarmaceuticasActividadesPreparadoAgregar;
    }

    public void setFormasFarmaceuticasActividadesPreparadoAgregar(FormasFarmaceuticasActividadesPreparado formasFarmaceuticasActividadesPreparadoAgregar) {
        this.formasFarmaceuticasActividadesPreparadoAgregar = formasFarmaceuticasActividadesPreparadoAgregar;
    }

    public List<SelectItem> getActividadesPreparadoSelectList() {
        return actividadesPreparadoSelectList;
    }

    public void setActividadesPreparadoSelectList(List<SelectItem> actividadesPreparadoSelectList) {
        this.actividadesPreparadoSelectList = actividadesPreparadoSelectList;
    }

    public FormasFarmaceuticasActividadesPreparado getFormasFarmaceuticasActividadesPreparadoEditar() {
        return formasFarmaceuticasActividadesPreparadoEditar;
    }

    public void setFormasFarmaceuticasActividadesPreparadoEditar(FormasFarmaceuticasActividadesPreparado formasFarmaceuticasActividadesPreparadoEditar) {
        this.formasFarmaceuticasActividadesPreparadoEditar = formasFarmaceuticasActividadesPreparadoEditar;
    }

    public List<FormasFarmaceuticasActividadesPreparado> getSubProcesoformasFarmaceuticasActividadesPreparadoList() {
        return subProcesoformasFarmaceuticasActividadesPreparadoList;
    }

    public void setSubProcesoformasFarmaceuticasActividadesPreparadoList(List<FormasFarmaceuticasActividadesPreparado> subProcesoformasFarmaceuticasActividadesPreparadoList) {
        this.subProcesoformasFarmaceuticasActividadesPreparadoList = subProcesoformasFarmaceuticasActividadesPreparadoList;
    }

    public FormasFarmaceuticasActividadesPreparado getSubProcesoFormasFarmaceuticasActividadesPreparadoAgregar() {
        return subProcesoFormasFarmaceuticasActividadesPreparadoAgregar;
    }

    public void setSubProcesoFormasFarmaceuticasActividadesPreparadoAgregar(FormasFarmaceuticasActividadesPreparado subProcesoFormasFarmaceuticasActividadesPreparadoAgregar) {
        this.subProcesoFormasFarmaceuticasActividadesPreparadoAgregar = subProcesoFormasFarmaceuticasActividadesPreparadoAgregar;
    }

    public FormasFarmaceuticasActividadesPreparado getSubProcesoFormasFarmaceuticasActividadesPreparadoEditar() {
        return subProcesoFormasFarmaceuticasActividadesPreparadoEditar;
    }

    public void setSubProcesoFormasFarmaceuticasActividadesPreparadoEditar(FormasFarmaceuticasActividadesPreparado subProcesoFormasFarmaceuticasActividadesPreparadoEditar) {
        this.subProcesoFormasFarmaceuticasActividadesPreparadoEditar = subProcesoFormasFarmaceuticasActividadesPreparadoEditar;
    }

    
            
}
