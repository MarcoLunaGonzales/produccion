/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.dao;

import com.cofar.bean.ComponentesProdVersion;
import com.cofar.bean.ComponentesProdVersionModificacion;
import com.cofar.util.Util;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import java.util.Date;

/**
 *
 * @author DASISAQ
 */
public class DaoComponentesProdVersionModificacion extends DaoBean{
    private static final int COD_ESTADO_VERSION_ASIGNADO = 9;
    public DaoComponentesProdVersionModificacion() {
        this.LOGGER = LogManager.getRootLogger();
    }
    
    public DaoComponentesProdVersionModificacion(Logger LOGGER) {
        this.LOGGER = LOGGER;
    }
    
    public List<ComponentesProdVersionModificacion> listarAgregar(ComponentesProdVersion componentesProdVersion){
        int codEstadoPersonaActivo = 1;
        List<ComponentesProdVersionModificacion> versionModificacionList = new ArrayList<>();
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select p.COD_PERSONAL,p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRES_PERSONAL,p.nombre2_personal,")
                                                        .append(" cpea.COD_TIPO_PERMISO_ESPECIAL_ATLAS,tpe.NOMBRE_TIPO_PERMISO_ESPECIAL_ATLAS")
                                                .append(" from personal p ")
                                                        .append(" inner join CONFIGURACION_PERMISOS_ESPECIALES_ATLAS cpea on cpea.COD_PERSONAL = p.COD_PERSONAL")
                                                                .append(" and cpea.COD_TIPO_PERMISO_ESPECIAL_ATLAS in (33,34,35,36)")
                                                        .append(" inner join TIPOS_PERMISOS_ESPECIALES_ATLAS tpe on tpe.COD_TIPO_PERMISO_ESPECIAL_ATLAS = cpea.COD_TIPO_PERMISO_ESPECIAL_ATLAS")
                                                        .append(" left outer join COMPONENTES_PROD_VERSION_MODIFICACION cpvm on cpvm.COD_PERSONAL = p.COD_PERSONAL")
                                                                .append(" and cpea.COD_TIPO_PERMISO_ESPECIAL_ATLAS = cpea.COD_TIPO_PERMISO_ESPECIAL_ATLAS")
                                                                .append(" and cpvm.COD_VERSION = ").append(componentesProdVersion.getCodVersion())
                                                .append(" where cpvm.COD_PERSONAL is null")
                                                        .append(" and p.COD_ESTADO_PERSONA = ").append(codEstadoPersonaActivo)
                                                .append(" order by 2,3,4");
            LOGGER.debug("consulta cargar personal agregar version: "+consulta.toString());
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta.toString());
            while(res.next()){
                ComponentesProdVersionModificacion bean = new ComponentesProdVersionModificacion();
                bean.getPersonal().setCodPersonal(res.getString("COD_PERSONAL"));
                bean.getPersonal().setApPaternoPersonal(res.getString("AP_PATERNO_PERSONAL"));
                bean.getPersonal().setApMaternoPersonal(res.getString("AP_MATERNO_PERSONAL"));
                bean.getPersonal().setNombrePersonal(res.getString("NOMBRES_PERSONAL"));
                bean.getPersonal().setNombre2Personal(res.getString("nombre2_personal"));
                bean.getTiposPermisosEspecialesAtlas().setCodTipoPermisoEspecialAtlas(res.getInt("COD_TIPO_PERMISO_ESPECIAL_ATLAS"));
                bean.getTiposPermisosEspecialesAtlas().setNombreTipoPermisoEspecialAtlas(res.getString("NOMBRE_TIPO_PERMISO_ESPECIAL_ATLAS"));
                bean.getEstadosVersionComponentesProd().setCodEstadoVersionComponenteProd(COD_ESTADO_VERSION_ASIGNADO);
                bean.getComponentesProdVersion().setCodVersion(componentesProdVersion.getCodVersion());
                bean.setFechaAsignacion(new Date());
                versionModificacionList.add(bean);
            }
        } catch (SQLException ex) {
            LOGGER.warn(ex);
        } catch (Exception ex) {
            LOGGER.warn(ex);
        } finally {
            this.cerrarConexion(con);
        }
        return versionModificacionList;
    }
    public List<ComponentesProdVersionModificacion> listar(ComponentesProdVersionModificacion versionModificacionCriterio){
        List<ComponentesProdVersionModificacion> versionModificacionList = new ArrayList<>();
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select *")
                                                .append(" from VISTA_COMPONENTES_PROD_VERSION_MODIFICACION vcm")
                                                .append(" where 1=1");
                                                if (versionModificacionCriterio.getComponentesProdVersion().getCodVersion() > 0)
                                                    consulta.append(" and vcm.COD_VERSION = ").append(versionModificacionCriterio.getComponentesProdVersion().getCodVersion());
            LOGGER.debug("consulta cargar personal modificacion version: "+consulta.toString());
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta.toString());
            while(res.next()){
                ComponentesProdVersionModificacion versionModificacion = new ComponentesProdVersionModificacion();
                versionModificacion.getComponentesProdVersion().setCodVersion(res.getInt("COD_VERSION"));
                versionModificacion.getPersonal().setCodPersonal(res.getString("COD_PERSONAL"));
                versionModificacion.getPersonal().setApPaternoPersonal(res.getString("AP_PATERNO_PERSONAL"));
                versionModificacion.getPersonal().setApMaternoPersonal(res.getString("AP_MATERNO_PERSONAL"));
                versionModificacion.getPersonal().setNombrePersonal(res.getString("NOMBRES_PERSONAL"));
                versionModificacion.getPersonal().setNombre2Personal(res.getString("nombre2_personal"));
                versionModificacion.getEstadosVersionComponentesProd().setCodEstadoVersionComponenteProd(res.getInt("COD_ESTADO_VERSION_COMPONENTES_PROD"));
                versionModificacion.getEstadosVersionComponentesProd().setNombreEstadoVersionComponentesProd(res.getString("NOMBRE_ESTADO_VERSION_COMPONENTES_PROD"));
                versionModificacion.setFechaAsignacion(res.getTimestamp("FECHA_ASIGNACION"));
                versionModificacion.setFechaDevolucionVersion(res.getTimestamp("FECHA_DEVOLUCION_VERSION"));
                versionModificacion.setFechaEnvioAprobacion(res.getTimestamp("FECHA_ENVIO_APROBACION"));
                versionModificacion.setFechaInclusionVersion(res.getTimestamp("FECHA_INCLUSION_VERSION"));
                versionModificacion.setObservacionPersonalVersion(res.getString("OBSERVACION_PERSONAL_VERSION"));
                versionModificacion.getTiposPermisosEspecialesAtlas().setCodTipoPermisoEspecialAtlas(res.getInt("COD_TIPO_PERMISO_ESPECIAL_ATLAS"));
                versionModificacion.getTiposPermisosEspecialesAtlas().setNombreTipoPermisoEspecialAtlas(res.getString("NOMBRE_TIPO_PERMISO_ESPECIAL_ATLAS"));
                versionModificacionList.add(versionModificacion);
            }
        } catch (SQLException ex) {
            LOGGER.warn(ex);
        } catch (Exception ex) {
            LOGGER.warn(ex);
        } finally {
            this.cerrarConexion(con);
        }
        return versionModificacionList;
    }
    public boolean editar(ComponentesProdVersionModificacion componentesProdVersionModificacion){
        LOGGER.debug("--------------------------------------INICIO MODIFICAR VERSION ASIGNACION--------------------------------------");
        boolean modificado = false;
        try {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta = new StringBuilder(" UPDATE COMPONENTES_PROD_VERSION_MODIFICACION ")
                                                .append(" SET COD_ESTADO_VERSION_COMPONENTES_PROD = " ).append(componentesProdVersionModificacion.getEstadosVersionComponentesProd().getCodEstadoVersionComponenteProd())
                                                        .append(" ,FECHA_INCLUSION_VERSION = ? ")
                                                        .append(" ,FECHA_ENVIO_APROBACION = ?")
                                                        .append(" ,FECHA_DEVOLUCION_VERSION = ?")
                                                        .append(" ,OBSERVACION_PERSONAL_VERSION = ?")
                                                        .append(" ,FECHA_ASIGNACION = ?")
                                                .append(" WHERE COD_PERSONAL = ").append(componentesProdVersionModificacion.getPersonal().getCodPersonal())
                                                        .append(" AND COD_VERSION = ").append(componentesProdVersionModificacion.getComponentesProdVersion().getCodVersion());
            LOGGER.debug("consulta registrar version modificion: "+consulta.toString());
            PreparedStatement pst=con.prepareStatement(consulta.toString());
            if(pst.executeUpdate() > 0 )LOGGER.info("se modifico satisfactoriamente");
            con.commit();
            modificado = true;
        } 
        catch (SQLException ex){
            modificado = false;
            LOGGER.warn(ex);
            this.rollbackConexion(con);
        }
        catch (Exception ex){
            modificado = false;
            LOGGER.warn(ex);
            this.rollbackConexion(con);
        }
        finally{
            this.cerrarConexion(con);
        }
        LOGGER.debug("--------------------------------------FINAL MODIFICAR VERSION ASIGNACION--------------------------------------");
        return modificado;
    }
    
    public boolean eliminarGuardarLista(List<ComponentesProdVersionModificacion> componentesProdVersionModificacionList){
        LOGGER.debug("--------------------------------------INICIO GUARDAR ELIMINAR VERSION ASIGNACION--------------------------------------");
        boolean guardado = false;
        try {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta = new StringBuilder(" delete COMPONENTES_PROD_VERSION_MODIFICACION")
                                                .append(" where COD_VERSION = ").append(componentesProdVersionModificacionList.get(0).getComponentesProdVersion().getCodVersion());
            LOGGER.debug("consulta eliminar asignacion anterior: "+consulta.toString());
            PreparedStatement pst=con.prepareStatement(consulta.toString());
            if(pst.executeUpdate() > 0)LOGGER.info("se elimino satisfactoriamente la configuracion");
            
            consulta = new StringBuilder("INSERT INTO COMPONENTES_PROD_VERSION_MODIFICACION(COD_PERSONAL, COD_VERSION,")
                                        .append(" COD_ESTADO_VERSION_COMPONENTES_PROD, FECHA_INCLUSION_VERSION,")
                                        .append(" FECHA_ENVIO_APROBACION, FECHA_DEVOLUCION_VERSION,")
                                        .append(" OBSERVACION_PERSONAL_VERSION,FECHA_ASIGNACION,COD_TIPO_PERMISO_ESPECIAL_ATLAS)")
                                .append(" VALUES (")
                                        .append("?,")//codPersonal
                                        .append("?,")//codVersion
                                        .append("?,")//codestadoVersion
                                        .append("?,")//fechaIclusion
                                        .append("?,")//fecha envio aprobacion
                                        .append("?,")//fecha devolucion
                                        .append("?,")//observacion
                                        .append("?,")// fecha asignacion
                                        .append("?")// fecha asignacion
                                .append(" )");
            LOGGER.debug("consulta registrar version modificion: "+consulta.toString());
            pst = con.prepareStatement(consulta.toString());
            for(ComponentesProdVersionModificacion bean : componentesProdVersionModificacionList){
                pst.setString(1,bean.getPersonal().getCodPersonal());LOGGER.info("p1: "+bean.getPersonal().getCodPersonal());
                pst.setInt(2,bean.getComponentesProdVersion().getCodVersion());LOGGER.info("p2: "+bean.getComponentesProdVersion().getCodVersion());
                pst.setInt(3, bean.getEstadosVersionComponentesProd().getCodEstadoVersionComponenteProd());LOGGER.info("p3: "+bean.getEstadosVersionComponentesProd().getCodEstadoVersionComponenteProd());
                pst.setTimestamp(4,Util.fechaParametro(bean.getFechaInclusionVersion()));LOGGER.info("p4: "+bean.getFechaInclusionVersion());
                pst.setTimestamp(5,Util.fechaParametro(bean.getFechaEnvioAprobacion()));LOGGER.info("p5: "+bean.getFechaEnvioAprobacion());
                pst.setTimestamp(6,Util.fechaParametro(bean.getFechaDevolucionVersion()));LOGGER.info("p6: "+bean.getFechaDevolucionVersion());
                pst.setString(7,bean.getObservacionPersonalVersion());LOGGER.info("p7:"+bean.getObservacionPersonalVersion());
                pst.setTimestamp(8,Util.fechaParametro(bean.getFechaAsignacion()));LOGGER.info("p8: "+bean.getFechaAsignacion());
                pst.setInt(9,bean.getTiposPermisosEspecialesAtlas().getCodTipoPermisoEspecialAtlas());LOGGER.info("p9: "+bean.getTiposPermisosEspecialesAtlas().getCodTipoPermisoEspecialAtlas());
                if(pst.executeUpdate() > 0)LOGGER.info("se registro el personal modificacion");
            }
            
            consulta = new StringBuilder("exec PAA_ACTUALIZAR_ESTADO_COMPONENTES_PROD_VERSION_MODIFICACION ")
                                .append(componentesProdVersionModificacionList.get(0).getComponentesProdVersion().getCodVersion());
            LOGGER.debug("consulta actualizar estado version modificacion: "+consulta.toString());
            pst = con.prepareStatement(consulta.toString());
            if(pst.executeUpdate() > 0)LOGGER.info("actualizar estado de version de modificacion");
            
            con.commit();
            guardado = true;
        } 
        catch (SQLException ex){
            guardado = false;
            LOGGER.warn(ex);
            this.rollbackConexion(con);
        }
        catch (Exception ex){
            guardado = false;
            LOGGER.warn(ex);
            this.rollbackConexion(con);
        }
        finally{
            this.cerrarConexion(con);
        }
        LOGGER.debug("--------------------------------------TERMINO GUARDAR ELIMINAR VERSION ASIGNACION--------------------------------------");
        return guardado;
        
    }
    
    
}
