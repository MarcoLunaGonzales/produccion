/*
 * ManagedTipoCliente.java
 * Created on 19 de febrero de 2008, 16:50
 */
package com.cofar.web;

import com.cofar.bean.AprobacionSolicitudMantenimiento;
import com.cofar.bean.SolicitudMantenimiento;
import com.cofar.bean.TiposTareaSolicitudMantenimiento;
import com.cofar.util.Util;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import javax.faces.context.ExternalContext;
import javax.faces.context.FacesContext;
import javax.faces.event.ValueChangeEvent;
import javax.faces.model.SelectItem;
import javax.servlet.http.HttpSession;
import org.apache.logging.log4j.LogManager;
import org.joda.time.DateTime;
import org.richfaces.component.html.HtmlDataTable;


/**
 *
 *  @author aquispe
 *  @company COFAR
 */
public class ManagedSolicitudMantenimiento extends ManagedBean 
{
    //<editor-fold desc="variables managed solicitud mantenimiento">
    
    private Connection con=null;
    private List<SolicitudMantenimiento> solicitudMantenimientoList;
    private List<SelectItem> areasEmpresaSelectList;
    private List<SelectItem> maquinariaSelectList;
    private List<SelectItem> areasInstalacionSelectList;
    private List<SelectItem> tiposSolicitudMantenimientoSelectList;
    private List<SelectItem> tiposNivelSolicitudMantenimientoSelectList;
    private List<SelectItem> estadosSolicitudMantenimientoSelectList;
    private SolicitudMantenimiento solicitudMantenimientoAgregar;
    private SolicitudMantenimiento solicitudMantenimientoEditar;
    private SolicitudMantenimiento solicitudMantenimientoBuscar;
    private boolean permisoRegistroFechaSolicitud=false;
    
    //</editor-fold>
    public ManagedSolicitudMantenimiento() {
        LOGGER=LogManager.getLogger("Mantenimiento");
        LOGGER.info(LOGGER.getName());
        solicitudMantenimientoBuscar=new SolicitudMantenimiento();
        solicitudMantenimientoBuscar.getAreasEmpresa().setCodAreaEmpresa("0");
    }
    //<editor-fold desc="funciones">
    public String guardarEdicionSolicitudMantenimiento_action()throws SQLException
    {
        mensaje = "";
        try 
        {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");
            SimpleDateFormat sdfHora=new SimpleDateFormat("HH:mm");
            StringBuilder consulta = new StringBuilder(" update SOLICITUDES_MANTENIMIENTO set");
                                                consulta.append(" COD_AREA_EMPRESA=").append(solicitudMantenimientoEditar.getAreasEmpresa().getCodAreaEmpresa());
                                                consulta.append(" ,COD_MAQUINARIA=").append(solicitudMantenimientoEditar.isSolicitudMantenimientoMaquinaria()?solicitudMantenimientoEditar.getMaquinaria().getCodMaquina():"0");
                                                consulta.append(" ,COD_TIPO_SOLICITUD_MANTENIMIENTO=").append(solicitudMantenimientoEditar.getTiposSolicitudMantenimiento().getCodTipoSolicitud());
                                                consulta.append(" ,OBS_SOLICITUD_MANTENIMIENTO=?");
                                                consulta.append(" ,AFECTARA_PRODUCCION=").append(solicitudMantenimientoEditar.getAfectaraProduccion());
                                                consulta.append(" ,COD_AREA_INSTALACION=").append(solicitudMantenimientoEditar.isSolicitudMantenimientoMaquinaria()?0:solicitudMantenimientoEditar.getAreasInstalaciones().getCodAreaInstalacion());
                                                consulta.append(" ,COD_TIPO_NIVEL_SOLICITUD_MANTENIMIENTO=").append(solicitudMantenimientoEditar.getTiposNivelSolicitudMantenimiento().getCodTipoNivelSolicitudMantenimiento());
                                                if(permisoRegistroFechaSolicitud)
                                                    consulta.append(",FECHA_SOLICITUD_MANTENIMIENTO='").append(sdf.format(solicitudMantenimientoEditar.getFechaSolicitudMantenimiento())).append(" ").append(sdfHora.format(new Date())).append("'");
                                        consulta.append(" where COD_SOLICITUD_MANTENIMIENTO =").append(solicitudMantenimientoEditar.getCodSolicitudMantenimiento());
            LOGGER.debug("consulta editar solicitud mantenimiento " + consulta.toString());
            PreparedStatement pst = con.prepareStatement(consulta.toString());
            pst.setString(1,solicitudMantenimientoEditar.getObsSolicitudMantenimiento());
            if (pst.executeUpdate() > 0) LOGGER.info("se registro la edicion de la solicitud");
            consulta=new StringBuilder("update APROBACION_SOLICITUDES_MANTENIMIENTO set");
                        consulta.append(" OBS_SOLICITUD_MANTENIMIENTO=?");
                        consulta.append(" where COD_SOLICITUD_MANTENIMIENTO=").append(solicitudMantenimientoEditar.getCodSolicitudMantenimiento());
            LOGGER.debug("consulta update solucitidon aprobacion "+consulta.toString());
            pst=con.prepareStatement(consulta.toString());
            pst.setString(1, solicitudMantenimientoEditar.getObsSolicitudMantenimiento());
            if(pst.executeUpdate()>0)LOGGER.info("se actualizo la solicitud de aprobacion ");
            con.commit();
            mensaje = "1";
        }
        catch (SQLException ex) 
        {
            mensaje = "Ocurrio un error al momento de guardar el registro";
            LOGGER.warn(ex.getMessage());
            con.rollback();
        }
        catch (Exception ex) 
        {
            mensaje = "Ocurrio un error al momento de guardar el registro,verifique los datos introducidos";
            LOGGER.warn(ex.getMessage());
        }
        finally 
        {
            this.cerrarConexion(con);
        }
        return null;
    }
    public String siguienteSolicitudesMantenimientoList_action() 
    {
        super.next();
        this.cargarSolicitudesMantenimientoList();
        return null;
    }

    public String atrasSolicitudesMantenimientoList_action() 
    {
        super.back();
        this.cargarSolicitudesMantenimientoList();
        return null;
    }
    private void cargarEstadosSolicitudMantenimientoSelectList()
    {
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select esm.COD_ESTADO_SOLICITUD,esm.NOMBRE_ESTADO_SOLICITUD");
                                        consulta.append(" from ESTADOS_SOLICITUD_MANTENIMIENTO esm ");
                                        consulta.append(" order by esm.NOMBRE_ESTADO_SOLICITUD");
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            estadosSolicitudMantenimientoSelectList=new ArrayList<SelectItem>();
            while (res.next()) 
            {
                estadosSolicitudMantenimientoSelectList.add(new SelectItem(res.getInt("COD_ESTADO_SOLICITUD"),res.getString("NOMBRE_ESTADO_SOLICITUD")));
            }
            res.close();
            st.close();
        }
        catch (SQLException ex) 
        {
            LOGGER.warn("error", ex);
        }
        catch (Exception ex) 
        {
            LOGGER.warn("error", ex);
        }
        finally 
        {
            this.cerrarConexion(con);
        }
    }
    public String buscarSolicitudMantenimiento_action()
    {
        begin=0;
        end=numrows;
        this.cargarSolicitudesMantenimientoList();
        return null;
    }
    public String cancelarSolicitudMantenimiento_action()throws SQLException
    {
        mensaje="";
        for(SolicitudMantenimiento bean:solicitudMantenimientoList)
        {
            if(bean.getChecked())
            {
                mensaje = "";
                try 
                {
                    con = Util.openConnection(con);
                    con.setAutoCommit(false);
                    StringBuilder consulta = new StringBuilder("UPDATE SOLICITUDES_MANTENIMIENTO");
                                                consulta.append(" SET COD_ESTADO_SOLICITUD_MANTENIMIENTO=10");
                                                consulta.append(" WHERE COD_SOLICITUD_MANTENIMIENTO=").append(bean.getCodSolicitudMantenimiento());
                    LOGGER.debug("consulta cancelas solicitud mantenimiento " + consulta.toString());
                    PreparedStatement pst = con.prepareStatement(consulta.toString());
                    if (pst.executeUpdate() > 0) LOGGER.info("se registro el cambio de estado de la solicitud");
                    con.commit();
                    mensaje = "1";
                }
                catch (SQLException ex) 
                {
                    mensaje = "Ocurrio un error al momento de guardar el registro";
                    LOGGER.warn(ex.getMessage());
                    con.rollback();
                }
                catch (Exception ex) 
                {
                    mensaje = "Ocurrio un error al momento de guardar el registro,verifique los datos introducidos";
                    LOGGER.warn(ex.getMessage());
                } 
                finally 
                {
                    this.cerrarConexion(con);
                }
                break;
            }
        }
        if(mensaje.equals("1"))
        {
            this.cargarSolicitudesMantenimientoList();
        }
        return null;
    }
    
    public String editarSolicitudMantenimiento_action()
    {
        for(SolicitudMantenimiento bean:solicitudMantenimientoList)
        {
            if(bean.getChecked())
            {
                solicitudMantenimientoEditar=bean;
                codAreaEmpresaSolicitudMantenimientoEditar_change();
                break;
            }
        }
        return null;
    }
    
    public String guardarAgregarSolicitudMantenimiento_action()throws SQLException
    {
        mensaje = "";
        try 
        {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");
            SimpleDateFormat sdfHora=new SimpleDateFormat("HH:mm");
            ManagedAccesoSistema managed=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
            StringBuilder consulta=new StringBuilder("INSERT INTO SOLICITUDES_MANTENIMIENTO(COD_AREA_EMPRESA,COD_GESTION,COD_PERSONAL,COD_MAQUINARIA,COD_TIPO_SOLICITUD_MANTENIMIENTO,");
                                            consulta.append("COD_ESTADO_SOLICITUD_MANTENIMIENTO,FECHA_SOLICITUD_MANTENIMIENTO,OBS_SOLICITUD_MANTENIMIENTO,AFECTARA_PRODUCCION,COD_AREA_INSTALACION,COD_TIPO_NIVEL_SOLICITUD_MANTENIMIENTO)");
                                    consulta.append(" values(");
                                            consulta.append(solicitudMantenimientoAgregar.getAreasEmpresa().getCodAreaEmpresa()).append(",");
                                            consulta.append("(select g.COD_GESTION from GESTIONES g where g.GESTION_ESTADO=1),");
                                            consulta.append(managed.getUsuarioModuloBean().getCodUsuarioGlobal()).append(",");
                                            consulta.append(solicitudMantenimientoAgregar.isSolicitudMantenimientoMaquinaria()?solicitudMantenimientoAgregar.getMaquinaria().getCodMaquina():"0").append(",");
                                            consulta.append(solicitudMantenimientoAgregar.getTiposSolicitudMantenimiento().getCodTipoSolicitud()).append(",");
                                            consulta.append("1,");//emitido
                                            if(permisoRegistroFechaSolicitud)
                                                consulta.append("'").append(sdf.format(solicitudMantenimientoAgregar.getFechaSolicitudMantenimiento())).append(" ").append(sdfHora.format(new Date())).append("',");
                                            else   
                                                consulta.append("GETDATE(),");
                                            consulta.append("?,");//observacion
                                            consulta.append(solicitudMantenimientoAgregar.getAfectaraProduccion()).append(",");//afecta produccion
                                            consulta.append(solicitudMantenimientoAgregar.isSolicitudMantenimientoMaquinaria()?0:solicitudMantenimientoAgregar.getAreasInstalaciones().getCodAreaInstalacion()).append(",");
                                            consulta.append(solicitudMantenimientoAgregar.getTiposNivelSolicitudMantenimiento().getCodTipoNivelSolicitudMantenimiento());
                                    consulta.append(")");
            LOGGER.debug("consulta registrar solicitud mantenimiento " + consulta.toString());
            PreparedStatement pst = con.prepareStatement(consulta.toString(), PreparedStatement.RETURN_GENERATED_KEYS);
            pst.setString(1,solicitudMantenimientoAgregar.getObsSolicitudMantenimiento());
            if (pst.executeUpdate() > 0)LOGGER.info("se registro la solicitud de mantenimiento ");
            ResultSet res=pst.getGeneratedKeys();
            if(res.next())solicitudMantenimientoAgregar.setCodSolicitudMantenimiento(res.getInt(1));
            
            consulta=new StringBuilder(" INSERT INTO APROBACION_SOLICITUDES_MANTENIMIENTO(COD_SOLICITUD_MANTENIMIENTO,COD_ESTADO_SOLICITUD_MANTENIMIENTO,");
                                consulta.append(" COD_PERSONAL_RESPONSABLE,FECHA_CAMBIO_ESTADOSOLICITUD,OBS_SOLICITUD_MANTENIMIENTO)");
                        consulta.append(" values(");
                                consulta.append(solicitudMantenimientoAgregar.getCodSolicitudMantenimiento()).append(",");
                                consulta.append("1,");//estado
                                consulta.append("0,");//personal responsable
                                if(permisoRegistroFechaSolicitud)
                                    consulta.append("'").append(sdf.format(solicitudMantenimientoAgregar.getFechaSolicitudMantenimiento())).append(" ").append(sdfHora.format(new Date())).append("',");
                                else   
                                    consulta.append("GETDATE(),");
                                consulta.append("?");
                        consulta.append(")");
            LOGGER.debug("consulta registrar solicitud aprobacion "+consulta.toString());
            pst=con.prepareStatement(consulta.toString());
            pst.setString(1,solicitudMantenimientoAgregar.getObsSolicitudMantenimiento());
            if(pst.executeUpdate()>0)LOGGER.info("se registro la solicitud de aprobación");
            con.commit();
            mensaje = "1";
        }
        catch (SQLException ex) 
        {
            mensaje = "Ocurrio un error al momento de guardar el registro";
            LOGGER.warn(ex.getMessage());
            con.rollback();
        }
        catch (Exception ex) 
        {
            mensaje = "Ocurrio un error al momento de guardar el registro,verifique los datos introducidos";
            LOGGER.warn(ex.getMessage());
        }
        finally 
        {
            this.cerrarConexion(con);
        }
        return null;
    }
    private void cargarTiposNivelSolicitudMantenimientoSelectList()
    {
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select tnsm.COD_NIVEL_SOLICITUD_MANTENIMIENTO,tnsm.NOMBRE_NIVEL_SOLICITUD_MANTENIMIENTO");
                                        consulta.append(" from TIPOS_NIVEL_SOLICITUD_MANTENIMIENTO tnsm");
                                        consulta.append(" order by tnsm.NOMBRE_NIVEL_SOLICITUD_MANTENIMIENTO");
            LOGGER.debug("consulta cargar tipos nivel mantenimiento " + consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            tiposNivelSolicitudMantenimientoSelectList=new ArrayList<SelectItem>();
            while (res.next()) 
            {
                tiposNivelSolicitudMantenimientoSelectList.add(new SelectItem(res.getInt("COD_NIVEL_SOLICITUD_MANTENIMIENTO"),res.getString("NOMBRE_NIVEL_SOLICITUD_MANTENIMIENTO")));
            }
            res.close();
            st.close();
        }
        catch (SQLException ex) 
        {
            LOGGER.warn("error", ex);
        } 
        catch (Exception ex) 
        {
            LOGGER.warn("error", ex);
        }
        finally 
        {
            this.cerrarConexion(con);
        }
    }
    private void cargarTiposSolicitudMantenimientoSelectList()
    {
        try 
        {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select tsm.COD_TIPO_SOLICITUD,tsm.NOMBRE_TIPO_SOLICITUD");
                                        consulta.append(" from TIPOS_SOLICITUD_MANTENIMIENTO tsm ");
                                        consulta.append(" order by tsm.NOMBRE_TIPO_SOLICITUD");
            LOGGER.debug("consulta cargar " + consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            tiposSolicitudMantenimientoSelectList=new ArrayList<SelectItem>();
            while (res.next()) 
            {
                tiposSolicitudMantenimientoSelectList.add(new SelectItem(res.getInt("COD_TIPO_SOLICITUD"),res.getString("NOMBRE_TIPO_SOLICITUD")));
            }
            res.close();
            st.close();
        }
        catch (SQLException ex) 
        {
            LOGGER.warn("error", ex);
        }
        catch (Exception ex) 
        {
            LOGGER.warn("error", ex);
        }
        finally 
        {
            this.cerrarConexion(con);
        }
    }
    public String getCargarAgregarSolicitudMantenimiento()
    {
        solicitudMantenimientoAgregar=new SolicitudMantenimiento();
        if(areasEmpresaSelectList.size()>0)
        {
            solicitudMantenimientoAgregar.getAreasEmpresa().setCodAreaEmpresa(areasEmpresaSelectList.get(0).getValue().toString());
            this.codAreaEmpresaSolicitudMantenimientoAgregar_change();
        }
        return null;
    }
    private void cargarAreasEmpresaSelectList()
    {
        try {
            ManagedAccesoSistema managed=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select DISTINCT ae.COD_AREA_EMPRESA,ae.NOMBRE_AREA_EMPRESA");
                                        consulta.append(" from USUARIOS_AREA_PRODUCCION uap");
                                                consulta.append(" inner join AREAS_EMPRESA ae on ae.COD_AREA_EMPRESA=uap.COD_AREA_EMPRESA");
                                        consulta.append(" where uap.COD_PERSONAL=").append(managed.getUsuarioModuloBean().getCodUsuarioGlobal());
                                        consulta.append(" order by ae.NOMBRE_AREA_EMPRESA");
            LOGGER.debug("consulta cargar areas Empresa select" + consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            areasEmpresaSelectList=new ArrayList<SelectItem>();
            while (res.next()) 
            {
                areasEmpresaSelectList.add(new SelectItem(res.getString("COD_AREA_EMPRESA"),res.getString("NOMBRE_AREA_EMPRESA")));
            }
            res.close();
            st.close();
        } 
        catch (SQLException ex) 
        {
            LOGGER.warn("error", ex);
        }
        catch (Exception ex) 
        {
            LOGGER.warn("error", ex);
        }
        finally 
        {
            this.cerrarConexion(con);
        }
    }
    public String codAreaEmpresaSolicitudMantenimientoEditar_change()
    {
        this.cargarMaquinariasAreaSelectList(this.solicitudMantenimientoEditar.getAreasEmpresa().getCodAreaEmpresa());
        this.cargarAreasInstalacionSelectList(this.solicitudMantenimientoEditar.getAreasEmpresa().getCodAreaEmpresa());
        return null;
    }
    public String codAreaEmpresaSolicitudMantenimientoAgregar_change()
    {
        this.cargarMaquinariasAreaSelectList(this.solicitudMantenimientoAgregar.getAreasEmpresa().getCodAreaEmpresa());
        this.cargarAreasInstalacionSelectList(this.solicitudMantenimientoAgregar.getAreasEmpresa().getCodAreaEmpresa());
        return null;
    }
    private void cargarAreasInstalacionSelectList(String codAreaEmpresa)
    {
        try 
        {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select ai.COD_AREA_INSTALACION,ai.NOMBRE_AREA_INSTALACION + '(' + ae.nombre_area_empresa + ')' as NOMBRE_AREA_INSTALACION");
                                        consulta.append(" from AREAS_EMPRESA ae");
                                                consulta.append(" inner join AREAS_INSTALACIONES ai on ae.COD_AREA_EMPRESA =ai.COD_AREA_EMPRESA");
                                        consulta.append(" where ae.COD_AREA_EMPRESA =").append(codAreaEmpresa);
                                        consulta.append(" order by 2 asc");
            LOGGER.debug("consulta cargar areas industrial " + consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            areasInstalacionSelectList=new ArrayList<SelectItem>();
            while (res.next()) 
            {
                areasInstalacionSelectList.add(new SelectItem(res.getInt("COD_AREA_INSTALACION"),res.getString("NOMBRE_AREA_INSTALACION")));
            }
            res.close();
            st.close();
        }
        catch (SQLException ex) 
        {
            LOGGER.warn("error", ex);
        }
        catch (Exception ex) 
        {
            LOGGER.warn("error", ex);
        }
        finally 
        {
            this.cerrarConexion(con);
        }
    }
    private void cargarMaquinariasAreaSelectList(String codAreaEmpresa)
    {
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select m.COD_MAQUINA,m.NOMBRE_MAQUINA,m.CODIGO");
                                        consulta.append(" from MAQUINARIAS m");
                                        consulta.append(" where m.cod_area_empresa =").append(codAreaEmpresa);
                                        consulta.append(" order by m.NOMBRE_MAQUINA");
            LOGGER.debug("consulta cargar select maquinaria " + consulta);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            maquinariaSelectList=new ArrayList<SelectItem>();
            while (res.next()) 
            {
                maquinariaSelectList.add(new SelectItem(res.getString("COD_MAQUINA"),res.getString("NOMBRE_MAQUINA")));
            }
            res.close();
            st.close();
        }
        catch (SQLException ex) 
        {
            LOGGER.warn("error", ex);
        }
        catch (Exception ex) 
        {
            LOGGER.warn("error", ex);
        }
        finally 
        {
            this.cerrarConexion(con);
        }
    }
    private void cargarPermisosEspecialesMantenimiento()
    {
        permisoRegistroFechaSolicitud=false;
        try 
        {
            con = Util.openConnection(con);
            ManagedAccesoSistema managed=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
            StringBuilder consulta = new StringBuilder("select c.COD_CONFIGURACION_PERMISOS_ESPECIALES_ATLAS");
                                    consulta.append(" from CONFIGURACION_PERMISOS_ESPECIALES_ATLAS c ");
                                    consulta.append(" where c.COD_PERSONAL=").append(managed.getUsuarioModuloBean().getCodUsuarioGlobal());
                                            consulta.append(" and c.COD_TIPO_PERMISO_ESPECIAL_ATLAS=10");
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            if(res.next())permisoRegistroFechaSolicitud=(res.getInt("COD_CONFIGURACION_PERMISOS_ESPECIALES_ATLAS")>0);
            res.close();
            st.close();
        }
        catch (SQLException ex) 
        {
            LOGGER.warn("error", ex);
        }
        catch (Exception ex) 
        {
            LOGGER.warn("error", ex);
        }
        finally 
        {
            this.cerrarConexion(con);
        }
    }
    public String getCargarSolicitudesMantenimiento()
    {
        this.cargarPermisosEspecialesMantenimiento();
        this.cargarEstadosSolicitudMantenimientoSelectList();
        this.cargarTiposNivelSolicitudMantenimientoSelectList();
        this.cargarTiposSolicitudMantenimientoSelectList();
        this.cargarSolicitudesMantenimientoList();
        this.cargarAreasEmpresaSelectList();
        return null;
    }
    private void cargarSolicitudesMantenimientoList()
    {
        try 
        {
            con = Util.openConnection(con);
            ManagedAccesoSistema managed=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
            StringBuilder consulta = new StringBuilder("select *");
                                        consulta.append(" from (");
                                                consulta.append(" select ROW_NUMBER() OVER (ORDER BY sm.COD_SOLICITUD_MANTENIMIENTO desc) as 'FILAS',");
                                                        consulta.append(" sm.NRO_ORDEN_TRABAJO,sm.COD_SOLICITUD_MANTENIMIENTO,SM.FECHA_SOLICITUD_MANTENIMIENTO,ae.COD_AREA_EMPRESA,ae.NOMBRE_AREA_EMPRESA,tsm.COD_TIPO_SOLICITUD,");
                                                        consulta.append(" tsm.NOMBRE_TIPO_SOLICITUD,esm.NOMBRE_ESTADO_SOLICITUD,esm.COD_ESTADO_SOLICITUD");
                                                        consulta.append(" ,sm.COD_MAQUINARIA,isnull(m.NOMBRE_MAQUINA,'') as NOMBRE_MAQUINA");
                                                        consulta.append(" ,sm.COD_AREA_INSTALACION,ai.NOMBRE_AREA_INSTALACION");
                                                        consulta.append(",sm.COD_MODULO_INSTALACION,mi.NOMBRE_MODULO_INSTALACION");
                                                        consulta.append(" ,sm.AFECTARA_PRODUCCION,sm.OBS_SOLICITUD_MANTENIMIENTO");
                                                consulta.append(" from SOLICITUDES_MANTENIMIENTO sm ");
                                                        consulta.append(" inner join AREAS_EMPRESA ae on ae.COD_AREA_EMPRESA=sm.COD_AREA_EMPRESA");
                                                        consulta.append(" inner join TIPOS_SOLICITUD_MANTENIMIENTO tsm on tsm.COD_TIPO_SOLICITUD=sm.COD_TIPO_SOLICITUD_MANTENIMIENTO");
                                                        consulta.append(" inner join ESTADOS_SOLICITUD_MANTENIMIENTO esm on esm.COD_ESTADO_SOLICITUD=sm.COD_ESTADO_SOLICITUD_MANTENIMIENTO");
                                                        consulta.append(" left outer join MAQUINARIAS m on m.COD_MAQUINA=sm.COD_MAQUINARIA");
                                                        consulta.append(" left outer join AREAS_INSTALACIONES ai on ai.COD_AREA_INSTALACION =sm.COD_AREA_INSTALACION");
                                                                consulta.append(" and ai.COD_AREA_EMPRESA = sm.COD_AREA_EMPRESA");
                                                        consulta.append(" left outer join MODULOS_INSTALACIONES mi on mi.COD_MODULO_INSTALACION = sm.COD_MODULO_INSTALACION");
                                                consulta.append(" WHERE sm.COD_PERSONAL=").append(managed.getUsuarioModuloBean().getCodUsuarioGlobal());
                                                        if(!solicitudMantenimientoBuscar.getAreasEmpresa().getCodAreaEmpresa().equals("0"))
                                                            consulta.append(" and sm.COD_AREA_EMPRESA=").append(solicitudMantenimientoBuscar.getAreasEmpresa().getCodAreaEmpresa());
                                                        if(solicitudMantenimientoBuscar.getCodSolicitudMantenimiento()>0)
                                                            consulta.append(" and sm.COD_SOLICITUD_MANTENIMIENTO=").append(solicitudMantenimientoBuscar.getCodSolicitudMantenimiento());
                                                        if(solicitudMantenimientoBuscar.getNroOrdenTrabajo()>0)
                                                            consulta.append(" and sm.NRO_ORDEN_TRABAJO=").append(solicitudMantenimientoBuscar.getNroOrdenTrabajo());
                                                        if(solicitudMantenimientoBuscar.getTiposNivelSolicitudMantenimiento().getCodTipoNivelSolicitudMantenimiento()>0)
                                                            consulta.append(" and sm.COD_TIPO_NIVEL_SOLICITUD_MANTENIMIENTO=").append(solicitudMantenimientoBuscar.getTiposNivelSolicitudMantenimiento().getCodTipoNivelSolicitudMantenimiento());
                                                        if(solicitudMantenimientoBuscar.getTiposSolicitudMantenimiento().getCodTipoSolicitud()>0)
                                                            consulta.append(" and sm.COD_TIPO_SOLICITUD_MANTENIMIENTO=").append(solicitudMantenimientoBuscar.getTiposSolicitudMantenimiento().getCodTipoSolicitud());
                                                        if(solicitudMantenimientoBuscar.getEstadoSolicitudMantenimiento().getCodEstadoSolicitudMantenimiento()>0)
                                                            consulta.append(" and sm.COD_ESTADO_SOLICITUD_MANTENIMIENTO=").append(solicitudMantenimientoBuscar.getEstadoSolicitudMantenimiento().getCodEstadoSolicitudMantenimiento());
                                        consulta.append(" ) as listadoMantenimiento");
                                        consulta.append(" where FILAS BETWEEN ").append(begin).append(" AND ").append(end);
            LOGGER.debug("consulta cargar " + consulta);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            solicitudMantenimientoList=new ArrayList<SolicitudMantenimiento>();
            while (res.next()) 
            {
                SolicitudMantenimiento nuevo=new SolicitudMantenimiento();
                nuevo.setNroOrdenTrabajo(res.getInt("NRO_ORDEN_TRABAJO"));
                nuevo.setAfectaraProduccion(res.getInt("AFECTARA_PRODUCCION"));
                nuevo.setObsSolicitudMantenimiento(res.getString("OBS_SOLICITUD_MANTENIMIENTO"));
                nuevo.setCodSolicitudMantenimiento(res.getInt("COD_SOLICITUD_MANTENIMIENTO"));
                nuevo.setFechaSolicitudMantenimiento(res.getTimestamp("FECHA_SOLICITUD_MANTENIMIENTO"));
                nuevo.getAreasEmpresa().setCodAreaEmpresa(res.getString("COD_AREA_EMPRESA"));
                nuevo.getAreasEmpresa().setNombreAreaEmpresa(res.getString("NOMBRE_AREA_EMPRESA"));
                nuevo.getTiposSolicitudMantenimiento().setCodTipoSolicitud(res.getInt("COD_TIPO_SOLICITUD"));
                nuevo.getTiposSolicitudMantenimiento().setNombreTipoSolicitud(res.getString("NOMBRE_TIPO_SOLICITUD"));
                nuevo.getEstadoSolicitudMantenimiento().setCodEstadoSolicitudMantenimiento(res.getInt("COD_ESTADO_SOLICITUD"));
                nuevo.getEstadoSolicitudMantenimiento().setNombreEstadoSolicitudMantenimiento(res.getString("NOMBRE_ESTADO_SOLICITUD"));
                nuevo.getMaquinaria().setCodMaquina(res.getString("COD_MAQUINARIA"));
                nuevo.getMaquinaria().setNombreMaquina(res.getString("NOMBRE_MAQUINA"));
                nuevo.getAreasInstalaciones().setCodAreaInstalacion(res.getInt("COD_AREA_INSTALACION"));
                nuevo.getAreasInstalaciones().setNombreAreaInstalacion(res.getString("NOMBRE_AREA_INSTALACION"));
                nuevo.getModulosInstalaciones().setCodModuloInstalacion(res.getInt("COD_MODULO_INSTALACION"));
                nuevo.getModulosInstalaciones().setNombreModuloInstalacion(res.getString("NOMBRE_MODULO_INSTALACION"));
                solicitudMantenimientoList.add(nuevo);
            }
            
            cantidadfilas = solicitudMantenimientoList.size();
            LOGGER.info("  c "+cantidadfilas);
            res.close();
            st.close();
        }
        catch (SQLException ex) 
        {
            LOGGER.warn("error", ex);
        }
        catch (Exception ex) 
        {
            LOGGER.warn("error", ex);
        }
        finally 
        {
            this.cerrarConexion(con);
        }
    }
    //</editor-fold>
    //<editor-fold desc="getter and setter">
        public List<SelectItem> getAreasEmpresaSelectList() {
            return areasEmpresaSelectList;
        }

        public void setAreasEmpresaSelectList(List<SelectItem> areasEmpresaSelectList) {
            this.areasEmpresaSelectList = areasEmpresaSelectList;
        }

        public SolicitudMantenimiento getSolicitudMantenimientoAgregar() {
            return solicitudMantenimientoAgregar;
        }

        public void setSolicitudMantenimientoAgregar(SolicitudMantenimiento solicitudMantenimientoAgregar) {
            this.solicitudMantenimientoAgregar = solicitudMantenimientoAgregar;
        }

        public List<SelectItem> getMaquinariaSelectList() {
            return maquinariaSelectList;
        }

        public void setMaquinariaSelectList(List<SelectItem> maquinariaSelectList) {
            this.maquinariaSelectList = maquinariaSelectList;
        }

        public List<SelectItem> getAreasInstalacionSelectList() {
            return areasInstalacionSelectList;
        }

        public void setAreasInstalacionSelectList(List<SelectItem> areasInstalacionSelectList) {
            this.areasInstalacionSelectList = areasInstalacionSelectList;
        }

        public List<SelectItem> getTiposSolicitudMantenimientoSelectList() {
            return tiposSolicitudMantenimientoSelectList;
        }

        public void setTiposSolicitudMantenimientoSelectList(List<SelectItem> tiposSolicitudMantenimientoSelectList) {
            this.tiposSolicitudMantenimientoSelectList = tiposSolicitudMantenimientoSelectList;
        }

        public List<SelectItem> getTiposNivelSolicitudMantenimientoSelectList() {
            return tiposNivelSolicitudMantenimientoSelectList;
        }

        public void setTiposNivelSolicitudMantenimientoSelectList(List<SelectItem> tiposNivelSolicitudMantenimientoSelectList) {
            this.tiposNivelSolicitudMantenimientoSelectList = tiposNivelSolicitudMantenimientoSelectList;
        }

        public SolicitudMantenimiento getSolicitudMantenimientoEditar() {
            return solicitudMantenimientoEditar;
        }

        public void setSolicitudMantenimientoEditar(SolicitudMantenimiento solicitudMantenimientoEditar) {
            this.solicitudMantenimientoEditar = solicitudMantenimientoEditar;
        }

        public List<SelectItem> getEstadosSolicitudMantenimientoSelectList() {
            return estadosSolicitudMantenimientoSelectList;
        }

        public void setEstadosSolicitudMantenimientoSelectList(List<SelectItem> estadosSolicitudMantenimientoSelectList) {
            this.estadosSolicitudMantenimientoSelectList = estadosSolicitudMantenimientoSelectList;
        }
        
        
        
        

        
        
        
    
    
    
    //</editor-fold>
    

    private SolicitudMantenimiento solicitudMantenimientobean = new SolicitudMantenimiento();
    private List solicitudMantenimientoEliminarList = new ArrayList();
    private List solicitudMantenimientoNoEliminarList = new ArrayList();
    private List solicitudMantenimientoEditarList = new ArrayList();
    private String codigo = "";
    private boolean swEliminaSi;
    private boolean swEliminaNo;
    private List tiposSolicitudMantenimientoList = new ArrayList();
    private List estadosSolicitudMantenimientoList = new ArrayList();
    private List gestionesList = new ArrayList();
    private List areasEmpresaList = new ArrayList();
    private List personalUsuarioList = new ArrayList();
    private List personalEjecutanteList = new ArrayList();
    private List maquinariasList = new ArrayList();
    private AprobacionSolicitudMantenimiento aprobacionSolicitudMantenimientobean = new AprobacionSolicitudMantenimiento();
    private List aprobacionSolicitudMantList = new ArrayList();
    private List seguimientoSolicitudMantList = new ArrayList();
    private HtmlDataTable ordenesDeTrabajoDataTable;
    private SolicitudMantenimiento solicitudMantenimientoItem = new SolicitudMantenimiento();
    private HtmlDataTable solicitudMantenimientoDataTable = new HtmlDataTable();
    private HtmlDataTable solicitudMantenimientoDataTable1 = new HtmlDataTable();
    private List solicitudMantenimientoDetalleTareasList = new ArrayList();
    private List tiposTareaSolicitudMantenimientoList = new ArrayList();
    List areasInstalacionesList = new ArrayList();
    String valorAsignado = "";
    List tiposNivelSolicitudMantenimientoList = new ArrayList();
    Date fechaInicio = new Date();
    Date fechaFinal = new Date();
    List solicitanteList = new ArrayList();
    List instalacionesList = new ArrayList();
    List estadoSolicitudMantenimientoList = new ArrayList();

    private List<SelectItem> personalSolicitanteList=new ArrayList<SelectItem>();
    private String mensaje="";
    private List<SelectItem> areasEmpresaBuscadorList=new ArrayList<SelectItem>();
    private List<SelectItem> areasInstalacionesDetalleSelectList=new ArrayList<SelectItem>();
    
    

    public String areaEdicion_change(){
        try {
        //ManagedAccesoSistema bean1 = (ManagedAccesoSistema) Util.getSessionBean("ManagedAccesoSistema");
            setCon(Util.openConnection(getCon()));
            String sql = " select m.COD_MAQUINA,m.NOMBRE_MAQUINA,m.CODIGO from MAQUINARIAS m " +
                    " where m.cod_area_empresa = '"+solicitudMantenimientoEditar.getAreasEmpresa().getCodAreaEmpresa()+"'"+
                    "order by m.NOMBRE_MAQUINA";
            System.out.println(" sql:" + sql);
            ResultSet rs = null;
            Statement st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            if (!codigo.equals("")) {
            } else {
                getMaquinariasList().clear();
                rs = st.executeQuery(sql);
                //getMaquinariasList().add(new SelectItem("0", "Seleccione una opción"));
                while (rs.next()) {
                    getMaquinariasList().add(new SelectItem(rs.getString(1), rs.getString(2) + " " + rs.getString(3)));
                }
            }
            if (rs != null) {
                rs.close();
                st.close();
                rs = null;
                st = null;
            }
            //ManagedAccesoSistema bean1 = (ManagedAccesoSistema) Util.getSessionBean("ManagedAccesoSistema");

            setCon(Util.openConnection(getCon()));
            sql = " select ai.COD_AREA_INSTALACION,ai.NOMBRE_AREA_INSTALACION+'('+ae.nombre_area_empresa+')' NOMBRE_AREA_INSTALACION " +
                    " from AREAS_EMPRESA ae  " +
                    " inner join AREAS_INSTALACIONES ai on ae.COD_AREA_EMPRESA = ai.COD_AREA_EMPRESA " +
                    "  where ae.COD_AREA_EMPRESA = '"+solicitudMantenimientoEditar.getAreasEmpresa().getCodAreaEmpresa()+"'";


            System.out.println(" sql:" + sql);
            ResultSet rs1 = null;
            Statement st1 = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            rs1 = st1.executeQuery(sql);
            areasInstalacionesList.clear();
            areasInstalacionesList.add(new SelectItem("0","-NINGUN0-"));
            while(rs1.next()){
                areasInstalacionesList.add(new SelectItem(rs1.getString("COD_AREA_INSTALACION"),rs1.getString("NOMBRE_AREA_INSTALACION")));
            }

            if (rs1 != null) {
                rs1.close();
                st1.close();
                rs1 = null;
                st1 = null;
            }
            } catch (Exception e) {
        }
            return null;
    }
    private void cargarPersonalSolicitante_action()
    {
        try
        {
            Connection con1=null;
            con1=Util.openConnection(con1);
            Statement st=con1.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select p.COD_PERSONAL,(p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRE_PILA) as nombre"+
                            " from PERSONAL p where p.COD_PERSONAL in (select DISTINCT u.COD_PERSONAL from  USUARIOS_MODULOS u)"+
                            " order by p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRE_PILA";
            ResultSet res=st.executeQuery(consulta);
            personalSolicitanteList.clear();
            while(res.next())
            {
                personalSolicitanteList.add(new SelectItem(res.getString("COD_PERSONAL"),res.getString("nombre")));
            }
            res.close();
            st.close();
            con1.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
    }
    public void cargarGestiones(String codigo, SolicitudMantenimiento bean) {
        try {
            setCon(Util.openConnection(getCon()));
            String sql = "select g.COD_GESTION,g.NOMBRE_GESTION from GESTIONES g order by g.NOMBRE_GESTION ";
            System.out.println(" sql:" + sql);
            ResultSet rs = null;
            Statement st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            if (!codigo.equals("")) {
            } else {
                getGestionesList().clear();
                rs = st.executeQuery(sql);
                getGestionesList().add(new SelectItem("0", "Seleccione una opción"));
                while (rs.next()) {
                    getGestionesList().add(new SelectItem(rs.getString(1), rs.getString(2)));
                }
            }
            if (rs != null) {
                rs.close();
                st.close();
                rs = null;
                st = null;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void cargarAreasEmpresa(String codigo, SolicitudMantenimiento bean) {
        try {
            ManagedAccesoSistema bean1 = (ManagedAccesoSistema) Util.getSessionBean("ManagedAccesoSistema");            
            
            setCon(Util.openConnection(getCon()));
            String sql = "select ae.COD_AREA_EMPRESA,ae.NOMBRE_AREA_EMPRESA from AREAS_EMPRESA ae,AREAS_FABRICACION af" +
                    " where ae.cod_area_empresa=af.cod_area_fabricacion " +
                    " and  ae.cod_area_empresa = '"+bean1.getCodAreaEmpresaGlobal()+"' order by ae.NOMBRE_AREA_EMPRESA";
            sql = " select a.cod_area_empresa, a.nombre_area_empresa from areas_empresa a inner join  USUARIOS_AREA_PRODUCCION u on a.cod_area_empresa = u.cod_area_empresa where u.cod_personal = '"+bean1.getUsuarioModuloBean().getCodUsuarioGlobal()+"' and u.cod_tipo_permiso = 1" ;
                    
            System.out.println(" sql:" + sql);
            ResultSet rs = null;
            Statement st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

            if (!codigo.equals("")) {
            } else {
                getAreasEmpresaList().clear();
                areasEmpresaList.add(new SelectItem("0","-NINGUNO-"));
                rs = st.executeQuery(sql);
                //getAreasEmpresaList().add(new SelectItem("0", "Seleccione una opción"));
                while (rs.next()) {
                    getAreasEmpresaList().add(new SelectItem(rs.getString(1), rs.getString(2)));
                }
            }
            if (rs != null) {
                rs.close();
                st.close();
                rs = null;
                st = null;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void cargarAreasInstalaciones(ManagedAccesoSistema bean1) {
        try {
            //ManagedAccesoSistema bean1 = (ManagedAccesoSistema) Util.getSessionBean("ManagedAccesoSistema");

            setCon(Util.openConnection(getCon()));
            String sql = " select ai.COD_AREA_INSTALACION,ai.NOMBRE_AREA_INSTALACION+'('+ae.nombre_area_empresa+')' NOMBRE_AREA_INSTALACION " +
                    " from AREAS_EMPRESA ae  " +
                    " inner join AREAS_INSTALACIONES ai on ae.COD_AREA_EMPRESA = ai.COD_AREA_EMPRESA " +
                    " "+(!bean1.getCodAreaEmpresaGlobal().equals("")?" where ae.COD_AREA_EMPRESA = '"+bean1.getCodAreaEmpresaGlobal()+"'  ":"")+"";
            System.out.println(" sql:" + sql);
            ResultSet rs = null;
            Statement st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            rs = st.executeQuery(sql);
            areasInstalacionesList.clear();
            areasInstalacionesList.add(new SelectItem("0","-NINGUNO-"));
            while(rs.next()){
                areasInstalacionesList.add(new SelectItem(rs.getString("COD_AREA_INSTALACION"),rs.getString("NOMBRE_AREA_INSTALACION")));
            }
            if (rs != null) {
                rs.close();
                st.close();
                rs = null;
                st = null;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


    public void cargarPersonalEjecutante(String codigo, SolicitudMantenimiento bean) {
        try {
            setCon(Util.openConnection(getCon()));
            String sql = " select p.COD_PERSONAL,p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRES_PERSONAL from personal p where p.COD_ESTADO_PERSONA=1";
            sql += " order by p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRES_PERSONAL";
            System.out.println(" sql_personal:" + sql);
            ResultSet rs = null;
            Statement st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            if (!codigo.equals("")) {
            } else {
                personalEjecutanteList.clear();
                rs = st.executeQuery(sql);
                personalEjecutanteList.add(new SelectItem("0", "Seleccione una opción"));
                while (rs.next()) {
                    personalEjecutanteList.add(new SelectItem(rs.getString(1), rs.getString(2) + " " + rs.getString(3) + " " + rs.getString(4)));
                }
            }
            if (rs != null) {
                rs.close();
                st.close();
                rs = null;
                st = null;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void cargarTiposSolicitud(String codigo, SolicitudMantenimiento bean) {
        try {
            setCon(Util.openConnection(getCon()));
            String sql = " select t.COD_TIPO_SOLICITUD,t.NOMBRE_TIPO_SOLICITUD  from TIPOS_SOLICITUD_MANTENIMIENTO t order by t.NOMBRE_TIPO_SOLICITUD";
            System.out.println(" sql:" + sql);
            ResultSet rs = null;
            Statement st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            if (!codigo.equals("")) {
            } else {
                getTiposSolicitudMantenimientoList().clear();
                rs = st.executeQuery(sql);
                getTiposSolicitudMantenimientoList().add(new SelectItem("0", "Seleccione una opción"));
                while (rs.next()) {
                    getTiposSolicitudMantenimientoList().add(new SelectItem(rs.getString(1), rs.getString(2)));
                }
            }
            if (rs != null) {
                rs.close();
                st.close();
                rs = null;
                st = null;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void cargarEstadosSolicitud(String codigo, SolicitudMantenimiento bean) {

        try {
            setCon(Util.openConnection(getCon()));
            String sql = " select e.COD_ESTADO_SOLICITUD,e.NOMBRE_ESTADO_SOLICITUD from ESTADOS_SOLICITUD_MANTENIMIENTO e order by e.NOMBRE_ESTADO_SOLICITUD";
            System.out.println(" sql:" + sql);
            ResultSet rs = null;
            Statement st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            if (!codigo.equals("")) {
            } else {
                getEstadosSolicitudMantenimientoList().clear();
                rs = st.executeQuery(sql);
                getEstadosSolicitudMantenimientoList().add(new SelectItem("0", "Seleccione una opción"));
                while (rs.next()) {
                    getEstadosSolicitudMantenimientoList().add(new SelectItem(rs.getString(1), rs.getString(2)));
                }
            }
            if (rs != null) {
                rs.close();
                st.close();
                rs = null;
                st = null;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void cargarEstadosSolicitudAprobar(String cod, SolicitudMantenimiento bean) {
        try {
            setCon(Util.openConnection(getCon()));
            String sql = " select e.COD_ESTADO_SOLICITUD,e.NOMBRE_ESTADO_SOLICITUD from ESTADOS_SOLICITUD_MANTENIMIENTO e " +
                    " where e.COD_ESTADO_SOLICITUD <> all (select a.COD_ESTADO_SOLICITUD_MANTENIMIENTO from APROBACION_SOLICITUDES_MANTENIMIENTO a where a.COD_SOLICITUD_MANTENIMIENTO='" + codigo + "' )" +
                    " order by e.NOMBRE_ESTADO_SOLICITUD";
            System.out.println(" sql:" + sql);
            ResultSet rs = null;

            Statement st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            if (!cod.equals("")) {
            } else {
                getEstadosSolicitudMantenimientoList().clear();
                rs = st.executeQuery(sql);
                //getEstadosSolicitudMantenimientoList().add(new SelectItem("0", "Seleccione una opción"));
                while (rs.next()) {
                    getEstadosSolicitudMantenimientoList().add(new SelectItem(rs.getString(1), rs.getString(2)));
                }
            }
            if (rs != null) {
                rs.close();
                st.close();
                rs = null;
                st = null;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void cargarEstadosAprobSolicitud(String codigo, SolicitudMantenimiento bean) {
        try {
            setCon(Util.openConnection(getCon()));
            String sql = " select e.COD_ESTADO_SOLICITUD,e.NOMBRE_ESTADO_SOLICITUD from ESTADOS_SOLICITUD_MANTENIMIENTO e order by e.NOMBRE_ESTADO_SOLICITUD";
            System.out.println(" sql:" + sql);
            ResultSet rs = null;
            Statement st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            if (!codigo.equals("")) {
            } else {
                getEstadosSolicitudMantenimientoList().clear();
                rs = st.executeQuery(sql);
                getEstadosSolicitudMantenimientoList().add(new SelectItem("0", "Seleccione una opción"));
                while (rs.next()) {
                    getEstadosSolicitudMantenimientoList().add(new SelectItem(rs.getString(1), rs.getString(2)));
                }
            }
            if (rs != null) {
                rs.close();
                st.close();
                rs = null;
                st = null;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public String codAreaEmpresa_onChange()
    {
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select m.COD_MAQUINA,m.NOMBRE_MAQUINA,m.CODIGO");
                                        consulta.append(" from MAQUINARIAS m");
                                        if(solicitudMantenimientoBuscar.getAreasEmpresa().getCodAreaEmpresa().length()>0&&(Integer.valueOf(solicitudMantenimientoBuscar.getAreasEmpresa().getCodAreaEmpresa())>0))
                                            consulta.append(" where m.cod_area_empresa =").append(solicitudMantenimientoBuscar.getAreasEmpresa().getCodAreaEmpresa());
                                        consulta.append(" order by m.NOMBRE_MAQUINA");
            LOGGER.debug("consulta cargar maquinarias "+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            maquinariasList=new ArrayList();
            maquinariasList.add(new SelectItem("0","--TODOS--"));
            while (res.next()) 
            {
                maquinariasList.add(new SelectItem(res.getString("COD_MAQUINA"),res.getString("NOMBRE_MAQUINA")+" "+res.getString("CODIGO")));
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
        return null;
    }

    public void cargarMaquinarias(String codigo, SolicitudMantenimiento bean,ManagedAccesoSistema bean1) {
        try {
            //ManagedAccesoSistema bean1 = (ManagedAccesoSistema) Util.getSessionBean("ManagedAccesoSistema");
            setCon(Util.openConnection(getCon()));
            String sql = " select m.COD_MAQUINA,m.NOMBRE_MAQUINA,m.CODIGO from MAQUINARIAS m " +
                    " " +(!bean1.getCodAreaEmpresaGlobal().equals("")?" where m.cod_area_empresa = '"+ bean1.getCodAreaEmpresaGlobal()+"'":"") +
                    "order by m.NOMBRE_MAQUINA";
            System.out.println(" sql:" + sql);
            ResultSet rs = null;
            Statement st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            if (!codigo.equals("")) {
            } else {
                
                getMaquinariasList().clear();
                rs = st.executeQuery(sql);
                maquinariasList.add(new SelectItem("0","-NINGUNO-"));
                //getMaquinariasList().add(new SelectItem("0", "Seleccione una opción"));
                while (rs.next()) {
                    if(getMaquinariasList().size()==0){getMaquinariasList().add(new SelectItem("0","-TODOS-"));}
                    getMaquinariasList().add(new SelectItem(rs.getString(1), rs.getString(2) + " " + rs.getString(3)));
                }
            }
            if (rs != null) {
                rs.close();
                st.close();
                rs = null;
                st = null;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public String getObtenerCodigoSolicitud() {

        //String cod=Util.getParameter("codigo");
        String cod = Util.getParameter("codigo");

        System.out.println("cxxxxxxxxxxxxxxxxxxxxxxxod:" + cod);
        if (cod != null) {
            setCodigo(cod);
        }

        cargarNavegadorAprobarSolicitud();

        return "";

    }

    public String cargarNavegadorAprobarSolicitud() {
        try {

            String sql = "  select a.COD_PERSONAL_RESPONSABLE,a.COD_ESTADO_SOLICITUD_MANTENIMIENTO,a.FECHA_CAMBIO_ESTADOSOLICITUD,a.OBS_SOLICITUD_MANTENIMIENTO,";
            sql += " ISNULL((select p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL from PERSONAL p where p.COD_PERSONAL=a.COD_PERSONAL_RESPONSABLE),'') ,";
            sql += " e.NOMBRE_ESTADO_SOLICITUD ";
            sql += " from APROBACION_SOLICITUDES_MANTENIMIENTO a,ESTADOS_SOLICITUD_MANTENIMIENTO e";
            sql += " where a.COD_SOLICITUD_MANTENIMIENTO='" + codigo + "' and e.COD_ESTADO_SOLICITUD=a.COD_ESTADO_SOLICITUD_MANTENIMIENTO";
            sql += " order by a.FECHA_CAMBIO_ESTADOSOLICITUD desc,e.NIVEL desc";

/*
            sql=" select a.COD_ESTADO_SOLICITUD_MANTENIMIENTO,a.FECHA_CAMBIO_ESTADOSOLICITUD,a.OBS_SOLICITUD_MANTENIMIENTO,e.NOMBRE_ESTADO_SOLICITUD "+
                " from SOLICITUDES_MANTENIMIENTO a,ESTADOS_SOLICITUD_MANTENIMIENTO e " +
                " where a.COD_SOLICITUD_MANTENIMIENTO='"+codigo+"' and e.COD_ESTADO_SOLICITUD=a.COD_ESTADO_SOLICITUD_MANTENIMIENTO "   ;
*/
            System.out.println("navegador:" + sql);
            setCon(Util.openConnection(getCon()));
            Statement st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(sql);
            aprobacionSolicitudMantList.clear();
            while (rs.next()) {
                AprobacionSolicitudMantenimiento bean = new AprobacionSolicitudMantenimiento();
                bean.getPersonal_ejecutante().setCodPersonal(rs.getString(1));

                bean.getEstadoSolicitudMantenimiento().setCodEstadoSolicitudMantenimiento(rs.getInt(2));
                if (bean.getEstadoSolicitudMantenimiento().getCodEstadoSolicitudMantenimiento()==4) {
                    bean.setSwSi(1);
                    bean.setSwNo(0);
                } else {
                    bean.setSwSi(0);
                    bean.setSwNo(1);
                }
                String fechaCambio = rs.getString(3);
                String fechaVector[] = fechaCambio.split(" ");
                fechaVector = fechaVector[0].split("-");
                fechaCambio = fechaVector[2] + "/" + fechaVector[1] + "/" + fechaVector[0];
                bean.setFechaCambioEstado(fechaCambio);
                bean.setObsAprobSolicitudMantenimiento(rs.getString(4));
                bean.getPersonal_ejecutante().setNombrePersonal(rs.getString(5));
                bean.getEstadoSolicitudMantenimiento().setNombreEstadoSolicitudMantenimiento(rs.getString(6));
                aprobacionSolicitudMantList.add(bean);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "";
    }

    public String getCargarSeguimientoSolicitudMantenimiento() {
        try {


            String codigoMantenimiento = Util.getParameter("codigo");
            
            String consulta=" select a.COD_ESTADO_SOLICITUD_MANTENIMIENTO,a.FECHA_CAMBIO_ESTADOSOLICITUD,a.OBS_SOLICITUD_MANTENIMIENTO,e.NOMBRE_ESTADO_SOLICITUD "+
                " from SOLICITUDES_MANTENIMIENTO a,ESTADOS_SOLICITUD_MANTENIMIENTO e " +
                " where a.COD_SOLICITUD_MANTENIMIENTO='"+codigoMantenimiento+"' and e.COD_ESTADO_SOLICITUD=a.COD_ESTADO_SOLICITUD_MANTENIMIENTO "   ;



            System.out.println("navegador:" + consulta);
            setCon(Util.openConnection(getCon()));
            Statement st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(consulta);
            seguimientoSolicitudMantList.clear();
            while (rs.next()) {
                SolicitudMantenimiento solicMant = new SolicitudMantenimiento();                
                solicMant.getEstadoSolicitudMantenimiento().setCodEstadoSolicitudMantenimiento(rs.getInt("COD_ESTADO_SOLICITUD_MANTENIMIENTO"));                
                solicMant.setFechaCambioEstadoSolicitud(rs.getDate("FECHA_CAMBIO_ESTADOSOLICITUD"));
                solicMant.setObsSolicitudMantenimiento(rs.getString("OBS_SOLICITUD_MANTENIMIENTO"));
                solicMant.getEstadoSolicitudMantenimiento().setNombreEstadoSolicitudMantenimiento(rs.getString("NOMBRE_ESTADO_SOLICITUD"));
                seguimientoSolicitudMantList.add(solicMant);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "";
    }

    public String actionSaveAprobarSolicitud() {
        AprobacionSolicitudMantenimiento a = new AprobacionSolicitudMantenimiento();
        aprobacionSolicitudMantenimientobean = a;
        cargarEstadosSolicitudAprobar("", null);
        cargarPersonalEjecutante("", null);
        try {
            String sql = " SELECT TOP 1 A.COD_SOLICITUD_MANTENIMIENTO,A.COD_PERSONAL_RESPONSABLE,A.COD_ESTADO_SOLICITUD_MANTENIMIENTO,";
            sql += " A.FECHA_CAMBIO_ESTADOSOLICITUD,A.OBS_SOLICITUD_MANTENIMIENTO";
            sql += " FROM APROBACION_SOLICITUDES_MANTENIMIENTO A ";
            sql += " WHERE A.COD_SOLICITUD_MANTENIMIENTO='" + codigo + "'";
            sql += " ORDER BY A.FECHA_CAMBIO_ESTADOSOLICITUD desc";
            System.out.println("navegador:" + sql);
            setCon(Util.openConnection(getCon()));
            Statement st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(sql);
            while (rs.next()) {
                getAprobacionSolicitudMantenimientobean().getPersonal_ejecutante().setCodPersonal(rs.getString(2));
                getAprobacionSolicitudMantenimientobean().getEstadoSolicitudMantenimiento().setCodEstadoSolicitudMantenimiento(rs.getInt(3));
                String fecha = rs.getString(4);
                String fechaVector[] = fecha.split(" ");
                fechaVector = fechaVector[0].split("-");
                fecha = fechaVector[2] + "/" + fechaVector[1] + "/" + fechaVector[0];
                getAprobacionSolicitudMantenimientobean().setFechaCambioEstado(fecha);
                getAprobacionSolicitudMantenimientobean().setObsAprobSolicitudMantenimiento(rs.getString(5));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "actionSaveAprobSolicitudMantenimiento";
    }

    public String getCodigoSolicitud() {
        String codigo = "1";
        try {
            setCon(Util.openConnection(getCon()));
            String sql = "select max(COD_SOLICITUD_MANTENIMIENTO)+1 from SOLICITUDES_MANTENIMIENTO";
            System.out.println("sql_max:" + sql);
            PreparedStatement st = getCon().prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                codigo = rs.getString(1);
            }
            if (codigo == null) {
                codigo = "1";
            }

            getSolicitudMantenimientobean().setCodSolicitudMantenimiento(Integer.valueOf(codigo));

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "";
    }

    
   public void recuperaUsuario(){
       try {
        ManagedAccesoSistema bean1 = (ManagedAccesoSistema) Util.getSessionBean("ManagedAccesoSistema");
        String codUsuario = bean1.getUsuarioModuloBean().getCodUsuarioGlobal();
        String consulta = " select p.COD_PERSONAL,p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRE_PILA from PERSONAL p " +
                          " where p.COD_PERSONAL = '"+codUsuario+"' ";
        PreparedStatement st = getCon().prepareStatement(consulta);
        ResultSet rs = st.executeQuery();
        if(rs.next()){
            solicitudMantenimientobean.getPersonal_usuario().setNombrePersonal(rs.getString("NOMBRE_PILA"));
            solicitudMantenimientobean.getPersonal_usuario().setApPaternoPersonal(rs.getString("AP_PATERNO_PERSONAL"));
            solicitudMantenimientobean.getPersonal_usuario().setApMaternoPersonal(rs.getString("AP_MATERNO_PERSONAL"));
        }
        solicitudMantenimientobean.getPersonal_usuario().setCodPersonal(bean1.getUsuarioModuloBean().getCodUsuarioGlobal());
       } catch (Exception e) {
           e.printStackTrace();
       }
   }
   public void redireccionar(String direccion) {
        try {

            FacesContext facesContext = FacesContext.getCurrentInstance();
            ExternalContext ext = facesContext.getExternalContext();
            ext.redirect(direccion);

        } catch (Exception e) {
            e.printStackTrace();
        }        
    }

    public String tipoDeOrdenTrabajo_action() {
        try {

            solicitudMantenimientoItem = (SolicitudMantenimiento) ordenesDeTrabajoDataTable.getRowData();
            FacesContext facesContext = FacesContext.getCurrentInstance();
            ExternalContext ext = facesContext.getExternalContext();
            HttpSession session = (HttpSession) ext.getSession(false);
            session.removeAttribute("ManagedSolicitudMantenimiento");
            ext.redirect("registrar_tipo_solicitud_mantenimiento.jsf?nroSolicitud=" + solicitudMantenimientoItem.getCodSolicitudMantenimiento());

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public String trabajoRealizar_action() {
        try {
            solicitudMantenimientoItem = (SolicitudMantenimiento) ordenesDeTrabajoDataTable.getRowData();
            FacesContext facesContext = FacesContext.getCurrentInstance();
            ExternalContext ext = facesContext.getExternalContext();
            HttpSession session = (HttpSession) ext.getSession(false);
            session.removeAttribute("ManagedRegistroSolicitudTrabajos");
            ext.redirect("listado_trabajos_solicitud_mantenimiento.jsf?nroSolicitud=" + solicitudMantenimientoItem.getCodSolicitudMantenimiento());

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public String asignarTiempoReal_action() {
        try {
            solicitudMantenimientoItem = (SolicitudMantenimiento) ordenesDeTrabajoDataTable.getRowData();
            FacesContext facesContext = FacesContext.getCurrentInstance();
            ExternalContext ext = facesContext.getExternalContext();
            HttpSession session = (HttpSession) ext.getSession(false);
            session.removeAttribute("ManagedRegistroSolicitudTrabajos");
            ext.redirect("listado_tiempo_real_trabajos_solicitud_mantenimiento.jsf?nroSolicitud=" + solicitudMantenimientoItem.getCodSolicitudMantenimiento());

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public String materialesUtilizar_action() {
        try {
            //primero revisar el estado de la solicitud de almacen para mostrar o bien la pantalla de solicitud
            // o bien la pantalla de estados de solicitud de compra o solicitud de almacen

            solicitudMantenimientoItem = (SolicitudMantenimiento) ordenesDeTrabajoDataTable.getRowData();
            FacesContext facesContext = FacesContext.getCurrentInstance();
            ExternalContext ext = facesContext.getExternalContext();
            HttpSession session = (HttpSession) ext.getSession(false);
            session.removeAttribute("ManagedRegistroSolicitudMateriales");
            String url = "";
            System.out.println("el estado de la solicitud de mantenimiento " + solicitudMantenimientoItem.getEstadoSolicitudMantenimiento().getCodEstadoSolicitudMantenimiento() +
                    " de la solicitud " + solicitudMantenimientoItem.getCodSolicitudMantenimiento());

            url = "listado_materiales_solicitud_mantenimiento.jsf?nroSolicitud=" + solicitudMantenimientoItem.getCodSolicitudMantenimiento();

            if (solicitudMantenimientoItem.getEstadoSolicitudMantenimiento().getCodEstadoSolicitudMantenimiento()==3) {
                url = "listado_materiales_espera_solicitud_mantenimiento.jsf?nroSolicitud=" + solicitudMantenimientoItem.getCodSolicitudMantenimiento();
            }
            if (solicitudMantenimientoItem.getEstadoSolicitudMantenimiento().getCodEstadoSolicitudMantenimiento()==4) {
                url = "listado_orden_compra_solicitud_mantenimiento.jsf?nroSolicitud=" + solicitudMantenimientoItem.getCodSolicitudMantenimiento();
            }



            ext.redirect(url);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
///------ para aprobar solicitudes de mantenimiento
    
    public String getCargarSolicitudMantenimiento() {
        setFechaInicio(null);
        setFechaFinal(null);
        begin=1;
        end=10;
        solicitudMantenimientoBuscar.getMaquinaria().setCodMaquina("0");
        solicitudMantenimientoBuscar.getPersonal_usuario().setCodPersonal("0");
        solicitudMantenimientoBuscar.getModulosInstalaciones().setCodModuloInstalacion(0);
        solicitudMantenimientoBuscar.setAfectaraProduccion(3);
        solicitudMantenimientoBuscar.getEstadoSolicitudMantenimiento().setCodEstadoSolicitudMantenimiento(0);
        solicitudMantenimientoBuscar.getTiposSolicitudMantenimiento().setCodTipoSolicitud(0);
        ManagedAccesoSistema bean1 = (ManagedAccesoSistema) Util.getSessionBean("ManagedAccesoSistema");
        solicitudMantenimientoBuscar.getAreasEmpresa().setCodAreaEmpresa("0");
        clearSolicitudMantenimiento();
        solicitanteList = this.cargarPersonalSolicitante();
        instalacionesList = this.cargarAreasInstalaciones();
        estadoSolicitudMantenimientoList = this.cargarEstadoSolicitud();
        cargarAreasEmpresa("", null);
        if(areasEmpresaList.size()==0){areasEmpresaList.add(new SelectItem("0","-TODOS-"));}
        cargarTiposSolicitud("", null);
        cargarGestiones("", null);
        cargarMaquinarias("", null,bean1);
        this.codAreaEmpresa_onChange();
        if(maquinariasList.size()==0){cargarMaquinarias("", null,new ManagedAccesoSistema());}
        Date fechaActual = new Date();
        SimpleDateFormat f = new SimpleDateFormat("dd/MM/yyyy");
        //cargarTiposTareasSolicitudMantenimiento();
        cargarEstadosSolicitud("", null);
        cargarTiposSolicitudMantenimiento();
        this.cargarAreasInstalaciones(bean1);
        if(areasInstalacionesList.size()==0){cargarAreasInstalaciones(new ManagedAccesoSistema());}
        System.out.println("getCargarSolicitudMantenimiento:");
        solicitudMantenimientobean.getEstadoSolicitudMantenimiento().setCodEstadoSolicitudMantenimiento(0);
        solicitudMantenimientoList = this.cargarAprobarSolicitudMantenimiento();
        tiposNivelSolicitudMantenimientoList = this.cargarTiposNivelSolicitudMantenimiento();
        
        cargarAreasEmpresaBuscador();

        return "";
    }
    public List cargarAreasInstalaciones() {
        List instalacionesList = new ArrayList();
        try {
            //ManagedAccesoSistema bean1 = (ManagedAccesoSistema) Util.getSessionBean("ManagedAccesoSistema");

            setCon(Util.openConnection(getCon()));
            String sql = " select ai.COD_AREA_INSTALACION,ai.NOMBRE_AREA_INSTALACION+'('+ae.nombre_area_empresa+')' NOMBRE_AREA_INSTALACION " +
                    " from AREAS_EMPRESA ae  " +
                    " inner join AREAS_INSTALACIONES ai on ae.COD_AREA_EMPRESA = ai.COD_AREA_EMPRESA ";
            System.out.println(" sql:" + sql);
            ResultSet rs = null;
            Statement st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            rs = st.executeQuery(sql);
            instalacionesList.clear();
            instalacionesList.add(new SelectItem("0","-TODOS-"));
            while(rs.next()){
                instalacionesList.add(new SelectItem(rs.getString("COD_AREA_INSTALACION"),rs.getString("NOMBRE_AREA_INSTALACION")));
            }
            if (rs != null) {
                rs.close();
                st.close();
                rs = null;
                st = null;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return instalacionesList;
    }
    public List cargarEstadoSolicitud() {
        List estadosSolicitudList = new ArrayList();
        try {
            //ManagedAccesoSistema bean1 = (ManagedAccesoSistema) Util.getSessionBean("ManagedAccesoSistema");

            setCon(Util.openConnection(getCon()));
            String sql = " select e.COD_ESTADO_SOLICITUD,e.NOMBRE_ESTADO_SOLICITUD from ESTADOS_SOLICITUD_MANTENIMIENTO e where e.COD_ESTADO_REGISTRO = 1 ";
            System.out.println(" sql:" + sql);
            ResultSet rs = null;
            Statement st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            rs = st.executeQuery(sql);
            estadosSolicitudList.clear();
            estadosSolicitudList.add(new SelectItem("0","-TODOS-"));
            while(rs.next()){
                estadosSolicitudList.add(new SelectItem(rs.getString("COD_ESTADO_SOLICITUD"),rs.getString("NOMBRE_ESTADO_SOLICITUD")));
            }
            if (rs != null) {
                rs.close();
                st.close();
                rs = null;
                st = null;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return estadosSolicitudList;
    }
    public List cargarPersonalSolicitante() {
    List personaSolicitanteList = new ArrayList();
        try {
            setCon(Util.openConnection(getCon()));
            String sql = " select distinct p.COD_PERSONAL,p.AP_PATERNO_PERSONAL + ' ' + p.AP_MATERNO_PERSONAL + ' ' + p.NOMBRES_PERSONAL nombre_personal from personal p inner join SOLICITUDES_MANTENIMIENTO s on s.COD_PERSONAL = p.COD_PERSONAL " +
                         " where p.COD_ESTADO_PERSONA = 1 " ;
            System.out.println(" consulta " + sql);
            ResultSet rs = null;
            Statement st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            rs = st.executeQuery(sql);
            personaSolicitanteList.add(new SelectItem(0,"-TODOS-"));
            while(rs.next()){
                personaSolicitanteList.add(new SelectItem(rs.getInt("cod_personal"),rs.getString("nombre_personal")));
            }
            
            if (rs != null) {
                rs.close();
                st.close();
                rs = null;
                st = null;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    return personaSolicitanteList;
    }

    public String area_change(){
        try {
        //ManagedAccesoSistema bean1 = (ManagedAccesoSistema) Util.getSessionBean("ManagedAccesoSistema");
            setCon(Util.openConnection(getCon()));
            String sql = " select m.COD_MAQUINA,m.NOMBRE_MAQUINA,m.CODIGO from MAQUINARIAS m " +
                    " where m.cod_area_empresa = '"+solicitudMantenimientobean.getAreasEmpresa().getCodAreaEmpresa()+"'"+
                    "order by m.NOMBRE_MAQUINA";
            System.out.println(" sql:" + sql);
            ResultSet rs = null;
            Statement st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            if (!codigo.equals("")) {
            } else {
                getMaquinariasList().clear();
                maquinariasList.add(new SelectItem("0","-NINGUNO-"));
                rs = st.executeQuery(sql);
                //getMaquinariasList().add(new SelectItem("0", "Seleccione una opción"));
                while (rs.next()) {
                    getMaquinariasList().add(new SelectItem(rs.getString(1), rs.getString(2) + " " + rs.getString(3)));
                }
            }
            if (rs != null) {
                rs.close();
                st.close();
                rs = null;
                st = null;
            }
            //ManagedAccesoSistema bean1 = (ManagedAccesoSistema) Util.getSessionBean("ManagedAccesoSistema");

            setCon(Util.openConnection(getCon()));
            sql = " select ai.COD_AREA_INSTALACION,ai.NOMBRE_AREA_INSTALACION+'('+ae.nombre_area_empresa+')' NOMBRE_AREA_INSTALACION " +
                    " from AREAS_EMPRESA ae  " +
                    " inner join AREAS_INSTALACIONES ai on ae.COD_AREA_EMPRESA = ai.COD_AREA_EMPRESA " +
                    "  where ae.COD_AREA_EMPRESA = '"+solicitudMantenimientobean.getAreasEmpresa().getCodAreaEmpresa()+"'";


            System.out.println(" sql:" + sql);
            ResultSet rs1 = null;
            Statement st1 = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            rs1 = st1.executeQuery(sql);
            areasInstalacionesList.clear();
            areasInstalacionesList.add(new SelectItem("0","-NINGUNO-"));
            while(rs1.next()){
                areasInstalacionesList.add(new SelectItem(rs1.getString("COD_AREA_INSTALACION"),rs1.getString("NOMBRE_AREA_INSTALACION")));
            }

            if (rs1 != null) {
                rs1.close();
                st1.close();
                rs1 = null;
                st1 = null;
            }
            } catch (Exception e) {
        }
        areasInstalacionesDetalleSelectList.clear();
        areasInstalacionesDetalleSelectList.add(new SelectItem(0,"-NINGUNO-"));
            return null;
    }
    public List cargarAprobarSolicitudMantenimiento(){
        List solicitudMantenimientoList = new ArrayList();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
        try {
            String sql = "select * from (select ROW_NUMBER() OVER (ORDER BY S.COD_SOLICITUD_MANTENIMIENTO desc) as 'FILAS', S.COD_SOLICITUD_MANTENIMIENTO,S.COD_AREA_EMPRESA,S.COD_GESTION,S.COD_PERSONAL,S.COD_RESPONSABLE,";
            sql += " S.COD_MAQUINARIA,S.COD_TIPO_SOLICITUD_MANTENIMIENTO,S.COD_ESTADO_SOLICITUD_MANTENIMIENTO,S.FECHA_SOLICITUD_MANTENIMIENTO,";
            sql += " S.FECHA_CAMBIO_ESTADOSOLICITUD,(select AE.NOMBRE_AREA_EMPRESA from AREAS_EMPRESA AE WHERE AE.COD_AREA_EMPRESA=S.COD_AREA_EMPRESA) NOMBRE_AREA_EMPRESA,";
            sql += " (select TS.NOMBRE_TIPO_SOLICITUD from TIPOS_SOLICITUD_MANTENIMIENTO TS where TS.COD_TIPO_SOLICITUD=S.COD_TIPO_SOLICITUD_MANTENIMIENTO) NOMBRE_TIPO_SOLICITUD,";
            sql += " (select e.NOMBRE_ESTADO_SOLICITUD from ESTADOS_SOLICITUD_MANTENIMIENTO e where e.COD_ESTADO_SOLICITUD = S.COD_ESTADO_SOLICITUD_MANTENIMIENTO and e.COD_ESTADO_REGISTRO = 1) NOMBRE_ESTADO_SOLICITUD,";
            sql += " (select M.NOMBRE_MAQUINA from MAQUINARIAS M where M.COD_MAQUINA=S.COD_MAQUINARIA) NOMBRE_MAQUINA,S.OBS_SOLICITUD_MANTENIMIENTO,G.NOMBRE_GESTION,";
            sql += " ISNULL((select P.AP_PATERNO_PERSONAL+' '+P.AP_MATERNO_PERSONAL+' '+P.NOMBRES_PERSONAL from PERSONAL P where P.COD_PERSONAL=S.COD_PERSONAL),'') NOMBRE_PERSONAL,";
            sql += " ISNULL((select TOP 1 PE.AP_PATERNO_PERSONAL+' '+PE.AP_MATERNO_PERSONAL+' '+PE.NOMBRES_PERSONAL from PERSONAL PE,APROBACION_SOLICITUDES_MANTENIMIENTO A,ESTADOS_SOLICITUD_MANTENIMIENTO ES where ES.COD_ESTADO_SOLICITUD=A.COD_ESTADO_SOLICITUD_MANTENIMIENTO AND PE.COD_PERSONAL=A.COD_PERSONAL_RESPONSABLE AND A.COD_PERSONAL_RESPONSABLE=PE.COD_PERSONAL AND A.COD_SOLICITUD_MANTENIMIENTO=S.COD_SOLICITUD_MANTENIMIENTO ORDER BY A.FECHA_CAMBIO_ESTADOSOLICITUD DESC,ES.NIVEL DESC),'') NOMBRE_PERSONAL1,  ";            
            sql += " (select TOP 1 ES.COD_ESTADO_SOLICITUD from ESTADOS_SOLICITUD_MANTENIMIENTO ES,APROBACION_SOLICITUDES_MANTENIMIENTO A where A.COD_SOLICITUD_MANTENIMIENTO = S.COD_SOLICITUD_MANTENIMIENTO AND A.COD_ESTADO_SOLICITUD_MANTENIMIENTO = ES.COD_ESTADO_SOLICITUD ORDER BY A.FECHA_CAMBIO_ESTADOSOLICITUD DESC,ES.NIVEL DESC ) COD_ESTADO_SOLICITUD," +
                    " S.COD_FORM_SALIDA, " +
                    " S.COD_AREA_INSTALACION,(SELECT AI.NOMBRE_AREA_INSTALACION FROM AREAS_INSTALACIONES AI WHERE AI.COD_AREA_INSTALACION = S.COD_AREA_INSTALACION)  NOMBRE_AREA_INSTALACION," +
                    " S.AFECTARA_PRODUCCION,t.COD_NIVEL_SOLICITUD_MANTENIMIENTO, t.NOMBRE_NIVEL_SOLICITUD_MANTENIMIENTO ";
            sql += " FROM SOLICITUDES_MANTENIMIENTO S,GESTIONES G,TIPOS_NIVEL_SOLICITUD_MANTENIMIENTO t ";
            sql += " WHERE  G.COD_GESTION=S.COD_GESTION and t.COD_NIVEL_SOLICITUD_MANTENIMIENTO = s.COD_TIPO_NIVEL_SOLICITUD_MANTENIMIENTO ";
            //sql+=" AND S.COD_PERSONAL='"+codUsuario+"'";
            sql += " ) AS listado_solicitud_mantenimiento where FILAS BETWEEN " + begin + " AND " + end + " ";
            
            sql = " select * from ( select ROW_NUMBER() OVER (" +
                    "  ORDER BY S.COD_SOLICITUD_MANTENIMIENTO desc) as 'FILAS', s.COD_SOLICITUD_MANTENIMIENTO,a.COD_AREA_EMPRESA,a.NOMBRE_AREA_EMPRESA,gest.COD_GESTION,gest.NOMBRE_GESTION," +
                    " p.COD_PERSONAL,p.NOMBRE_PILA,p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p1.COD_PERSONAL COD_PERSONAL_R,p1.NOMBRE_PILA NOMBRE_PILA_R,p1.AP_PATERNO_PERSONAL AP_PATERNO_PERSONAL_R," +
                    " p1.AP_MATERNO_PERSONAL AP_MATERNO_PERSONAL_R,isnull(m.COD_MAQUINA,0) as COD_MAQUINA,m.NOMBRE_MAQUINA, " +
                    " t.COD_TIPO_SOLICITUD,t.NOMBRE_TIPO_SOLICITUD,e.COD_ESTADO_SOLICITUD,isnull(e.NOMBRE_ESTADO_SOLICITUD,'')+'('+isnull(s.descripcion_estado,'')+')' nombre_estado_solicitud,tm.COD_NIVEL_SOLICITUD_MANTENIMIENTO,tm.NOMBRE_NIVEL_SOLICITUD_MANTENIMIENTO, " +
                    " isnull(ai.COD_AREA_INSTALACION,0) as COD_AREA_INSTALACION,ai.NOMBRE_AREA_INSTALACION,mi.COD_MODULO_INSTALACION,mi.NOMBRE_MODULO_INSTALACION,s.FECHA_SOLICITUD_MANTENIMIENTO,s.FECHA_CAMBIO_ESTADOSOLICITUD" +
                    " ,pm.COD_PARTE_MAQUINA,pm.NOMBRE_PARTE_MAQUINA, s.OBS_SOLICITUD_MANTENIMIENTO, s.descripcion_estado,s.afectara_produccion,isnull(s.NRO_ORDEN_TRABAJO,0) as NroOrden,s.cod_solicitud_compra,s.cod_form_salida" +
                    "  ,s.COD_AREA_INSTALACION_DETALLE,ISNULL(aid.NOMBRE_AREA_INSTALACION_DETALLE+'('+ae1.NOMBRE_AREA_EMPRESA+')('+aid.CODIGO+')' ,'') as nombreAreaInstalacionDetalle,s.solicitud_proyecto,s.solicitud_produccion "+
                    " from SOLICITUDES_MANTENIMIENTO s inner join AREAS_EMPRESA a on a.COD_AREA_EMPRESA = s.COD_AREA_EMPRESA "+
                    (solicitudMantenimientobean.getEstadoSolicitudMantenimiento().getCodEstadoSolicitudMantenimiento()!=0?" and s.cod_estado_solicitud_mantenimiento='"+solicitudMantenimientobean.getEstadoSolicitudMantenimiento().getCodEstadoSolicitudMantenimiento()+"' ":"")+" " +
                    " inner join GESTIONES gest on gest.COD_GESTION = s.COD_GESTION " +
                    " inner join PERSONAL p on p.COD_PERSONAL = s.COD_PERSONAL  " +
                    " inner join TIPOS_SOLICITUD_MANTENIMIENTO t on t.COD_TIPO_SOLICITUD = s.COD_TIPO_SOLICITUD_MANTENIMIENTO " +
                    " inner join ESTADOS_SOLICITUD_MANTENIMIENTO e on e.COD_ESTADO_SOLICITUD = s.COD_ESTADO_SOLICITUD_MANTENIMIENTO " +
                    " inner join TIPOS_NIVEL_SOLICITUD_MANTENIMIENTO tm on tm.COD_NIVEL_SOLICITUD_MANTENIMIENTO = s.COD_TIPO_NIVEL_SOLICITUD_MANTENIMIENTO " +
                    " left outer join personal p1 on p1.COD_PERSONAL = s.COD_RESPONSABLE " +
                    " left outer join MAQUINARIAS m on m.COD_MAQUINA = s.COD_MAQUINARIA " +
                    " left outer join PARTES_MAQUINARIA pm on pm.COD_MAQUINA = m.COD_MAQUINA and pm.COD_PARTE_MAQUINA = s.COD_PARTE_MAQUINA " +
                    " left outer join AREAS_INSTALACIONES ai on ai.COD_AREA_INSTALACION = s.COD_AREA_INSTALACION and ai.COD_AREA_EMPRESA = a.COD_AREA_EMPRESA " +
                    " left outer join AREAS_INSTALACIONES_MODULOS aim on aim.COD_AREA_INSTALACION = ai.COD_AREA_INSTALACION and aim.COD_MODULO_INSTALACION = s.COD_MODULO_INSTALACION " +
                    " left outer join MODULOS_INSTALACIONES mi on mi.COD_MODULO_INSTALACION = s.COD_MODULO_INSTALACION" +
                    " left outer join solicitudes_compra sc on sc.cod_solicitud_compra = s.cod_solicitud_compra" +
                    " left outer join solicitudes_salida s1 on s1.cod_form_salida = s.cod_form_salida " +
                    " left outer join AREAS_INSTALACIONES_DETALLE aid on aid.COD_AREA_INSTALACION=s.COD_AREA_INSTALACION and "+
                    " aid.COD_AREA_INSTALACION_DETALLE=s.COD_AREA_INSTALACION_DETALLE left outer join AREAS_EMPRESA ae1 on "+
                    " ae1.COD_AREA_EMPRESA=aid.COD_AREA_EMPRESA" +
                    " where gest.cod_gestion = s.cod_gestion"+
                    (solicitudMantenimientoBuscar.getNroOrdenTrabajo()>0?" and s.NRO_ORDEN_TRABAJO='"+solicitudMantenimientoBuscar.getNroOrdenTrabajo()+"'":"")+
                    (!solicitudMantenimientoBuscar.getAreasEmpresa().getCodAreaEmpresa().equals("0")?" and s.COD_AREA_EMPRESA='"+solicitudMantenimientoBuscar.getAreasEmpresa().getCodAreaEmpresa()+"'":"")+
                    (solicitudMantenimientoBuscar.getCodSolicitudMantenimiento()!=0?" and s.COD_SOLICITUD_MANTENIMIENTO ='"+solicitudMantenimientoBuscar.getCodSolicitudMantenimiento()+"'":"");
                    if(!solicitudMantenimientoBuscar.getPersonal_usuario().getCodPersonal().equals("0")){sql = sql+" and s.cod_personal = '"+solicitudMantenimientoBuscar.getPersonal_usuario().getCodPersonal()+"' ";}
                    if(fechaInicio !=null && fechaFinal != null){sql = sql+" and s.fecha_solicitud_mantenimiento between '"+ sdf.format(fechaInicio)+" 00:00:00' and '"+ sdf.format(fechaFinal)+" 23:59:59' ";}
                    if(!solicitudMantenimientoBuscar.getMaquinaria().getCodMaquina().equals("0")&&solicitudMantenimientoBuscar.getMaquinaria().getCodMaquina()!=null){sql = sql+" and s.cod_maquinaria = '"+solicitudMantenimientoBuscar.getMaquinaria().getCodMaquina()+"' ";}
                    if(solicitudMantenimientoBuscar.getModulosInstalaciones().getCodModuloInstalacion()!=0){sql = sql+" and s.cod_modulo_instalacion = '"+solicitudMantenimientoBuscar.getModulosInstalaciones().getCodModuloInstalacion()+"' ";}
                    if(solicitudMantenimientoBuscar.getAfectaraProduccion()<2){sql = sql+" and s.afectara_produccion = '"+solicitudMantenimientoBuscar.getAfectaraProduccion()+"' ";}
                    if(solicitudMantenimientoBuscar.getEstadoSolicitudMantenimiento().getCodEstadoSolicitudMantenimiento()!=0){sql = sql+" and s.cod_estado_solicitud_mantenimiento = '"+solicitudMantenimientoBuscar.getEstadoSolicitudMantenimiento().getCodEstadoSolicitudMantenimiento()+"' ";}
                    if(solicitudMantenimientoBuscar.getTiposSolicitudMantenimiento().getCodTipoSolicitud()!=0){sql = sql+" and s.cod_tipo_solicitud_mantenimiento = '"+solicitudMantenimientoBuscar.getTiposSolicitudMantenimiento().getCodTipoSolicitud()+"' ";}
                    sql = sql+") AS listado_solicitud_mantenimiento where FILAS BETWEEN "+begin+" AND "+end+" ";

            //sql += " (select TOP 1 A.FECHA_CAMBIO_ESTADOSOLICITUD from ESTADOS_SOLICITUD_MANTENIMIENTO ES,APROBACION_SOLICITUDES_MANTENIMIENTO A where A.COD_SOLICITUD_MANTENIMIENTO = S.COD_SOLICITUD_MANTENIMIENTO AND A.COD_ESTADO_SOLICITUD_MANTENIMIENTO = ES.COD_ESTADO_SOLICITUD ORDER BY A.FECHA_CAMBIO_ESTADOSOLICITUD DESC,ES.NIVEL DESC) FECHA_CAMBIO_ESTADOSOLICITUD,";
            System.out.println("navegador:" + sql);
            setCon(Util.openConnection(getCon()));
            Statement st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(sql);
            rs.last();
            int rows = rs.getRow();
            solicitudMantenimientoList.clear();
            rs.first();
            String cod = "";
            cantidadfilas = 0;
            
            for (int i = 0; i < rows; i++) {
                SolicitudMantenimiento bean = new SolicitudMantenimiento();
                bean.setCodSolicitudMantenimiento(rs.getInt("COD_SOLICITUD_MANTENIMIENTO"));
                bean.getAreasEmpresa().setCodAreaEmpresa(rs.getString("COD_AREA_EMPRESA"));
                bean.getAreasEmpresa().setNombreAreaEmpresa(rs.getString("NOMBRE_AREA_EMPRESA"));
                bean.getGestiones().setCodGestion(rs.getString("COD_GESTION"));
                bean.getGestiones().setNombreGestion(rs.getString("NOMBRE_GESTION"));
                bean.getPersonal_usuario().setCodPersonal(rs.getString("COD_PERSONAL"));
                bean.getPersonal_usuario().setNombrePersonal(rs.getString("NOMBRE_PILA"));
                bean.getPersonal_usuario().setApPaternoPersonal(rs.getString("AP_PATERNO_PERSONAL"));
                bean.getPersonal_usuario().setApMaternoPersonal(rs.getString("AP_MATERNO_PERSONAL"));
                bean.getPersonal_ejecutante().setCodPersonal(rs.getString("COD_PERSONAL_R"));
                bean.getPersonal_ejecutante().setNombrePersonal(rs.getString("NOMBRE_PILA_R"));
                bean.getPersonal_ejecutante().setApPaternoPersonal(rs.getString("AP_PATERNO_PERSONAL_R"));
                bean.getPersonal_ejecutante().setApMaternoPersonal(rs.getString("AP_MATERNO_PERSONAL_R"));
                bean.getMaquinaria().setCodMaquina(rs.getString("COD_MAQUINA"));
                bean.getMaquinaria().setNombreMaquina(rs.getString("NOMBRE_MAQUINA"));
                bean.getTiposSolicitudMantenimiento().setCodTipoSolicitud(rs.getInt("COD_TIPO_SOLICITUD"));
                bean.getTiposSolicitudMantenimiento().setNombreTipoSolicitud(rs.getString("NOMBRE_TIPO_SOLICITUD"));
                bean.getEstadoSolicitudMantenimiento().setCodEstadoSolicitudMantenimiento(rs.getInt("COD_ESTADO_SOLICITUD"));
                bean.getEstadoSolicitudMantenimiento().setNombreEstadoSolicitudMantenimiento(rs.getString("NOMBRE_ESTADO_SOLICITUD"));
                bean.getTiposNivelSolicitudMantenimiento().setCodTipoNivelSolicitudMantenimiento(rs.getInt("COD_NIVEL_SOLICITUD_MANTENIMIENTO"));
                bean.getTiposNivelSolicitudMantenimiento().setNombreNivelSolicitudMantenimiento(rs.getString("NOMBRE_NIVEL_SOLICITUD_MANTENIMIENTO"));
            //    bean.getModulosInstalaciones().getAreasInstalacionesModulos().getAreasInstalaciones().setCodAreaInstalacion(rs.getInt("COD_AREA_INSTALACION"));
            //    bean.getModulosInstalaciones().getAreasInstalacionesModulos().getAreasInstalaciones().setNombreAreaInstalacion(rs.getString("NOMBRE_AREA_INSTALACION"));
                bean.getModulosInstalaciones().setCodModuloInstalacion(rs.getInt("COD_MODULO_INSTALACION"));
                bean.getModulosInstalaciones().setNombreModuloInstalacion(rs.getString("NOMBRE_MODULO_INSTALACION"));
                bean.setFechaSolicitudMantenimiento(rs.getTimestamp("FECHA_SOLICITUD_MANTENIMIENTO"));
                bean.getFechaSolicitudMantenimiento().setTime(rs.getTimestamp("FECHA_SOLICITUD_MANTENIMIENTO").getTime());
                bean.setFechaCambioEstadoSolicitud(rs.getTimestamp("FECHA_CAMBIO_ESTADOSOLICITUD"));
                bean.getPartesMaquinaria().setCodParteMaquina(rs.getInt("COD_PARTE_MAQUINA"));
                bean.getPartesMaquinaria().setNombreParteMaquina(rs.getString("NOMBRE_PARTE_MAQUINA"));
                bean.setObsSolicitudMantenimiento(rs.getString("OBS_SOLICITUD_MANTENIMIENTO"));
                bean.setDescripcionEstado(rs.getString("DESCRIPCION_ESTADO"));
                bean.setAfectaraProduccion(rs.getInt("afectara_produccion"));
                bean.setNroOrdenTrabajo(rs.getInt("NroOrden"));
                bean.getSolicitudesCompra().setCodSolicitudCompra(rs.getInt("cod_solicitud_compra"));
                bean.getSolicitudesSalida().setCodFormSalida(rs.getInt("cod_form_salida"));
                bean.getAreasInstalacionesDetalle().setCodAreaInstalacionDetalle(rs.getInt("COD_AREA_INSTALACION_DETALLE"));
                bean.getAreasInstalacionesDetalle().setNombreAreaInstalacionDetalle(rs.getString("nombreAreaInstalacionDetalle"));
                bean.setSolicitudProyecto(rs.getInt("solicitud_proyecto"));
                bean.setSolicitudProduccion(rs.getInt("solicitud_produccion"));
//                bean.getTiposSolicitudMantenimiento().setCodTipoSolicitud("");
//                bean.getGestiones().setCodGestion(rs.getString("COD_GESTION"));
//                bean.getPersonal_usuario().setCodPersonal(rs.getString("COD_PERSONAL"));
//                bean.getPersonal_ejecutante().setCodPersonal(rs.getString("COD_RESPONSABLE"));
//                bean.getMaquinaria().setCodMaquina(rs.getString("COD_MAQUINARIA"));
//                bean.getTiposSolicitudMantenimiento().setCodTipoSolicitud(rs.getString("COD_TIPO_SOLICITUD_MANTENIMIENTO"));
//                bean.getEstadoSolicitudMantenimiento().setCodEstadoSolicitudMantenimiento(rs.getString("COD_ESTADO_SOLICITUD_MANTENIMIENTO"));
//                bean.setFechaSolicitudMantenimiento(rs.getDate("FECHA_SOLICITUD_MANTENIMIENTO"));
//                //System.out.println("dato fecha" + rs.getTimestamp("FECHA_SOLICITUD_MANTENIMIENTO") + "  " +rs.getTimestamp("FECHA_SOLICITUD_MANTENIMIENTO").getTime());
//                bean.getFechaSolicitudMantenimiento().setTime(rs.getTimestamp("FECHA_SOLICITUD_MANTENIMIENTO").getTime());
//                //bean.setFechaCambioEstadoSolicitud(rs.getDate("FECHA_CAMBIO_ESTADOSOLICITUD"));
//                bean.getAreasEmpresa().setNombreAreaEmpresa(rs.getString("NOMBRE_AREA_EMPRESA"));
//                bean.getTiposSolicitudMantenimiento().setNombreTipoSolMantenimiento(rs.getString("NOMBRE_TIPO_SOLICITUD"));
//                bean.getEstadoSolicitudMantenimiento().setNombreEstadoSolicitudMantenimiento(rs.getString("NOMBRE_ESTADO_SOLICITUD"));
//                bean.getMaquinaria().setNombreMaquina(rs.getString("NOMBRE_MAQUINA"));
//                bean.setObsSolicitudMantenimiento(rs.getString("OBS_SOLICITUD_MANTENIMIENTO"));
//                bean.getGestiones().setNombreGestion(rs.getString("NOMBRE_GESTION"));
//                bean.getPersonal_usuario().setNombrePersonal(rs.getString("NOMBRE_PERSONAL"));
//                bean.getPersonal_ejecutante().setNombrePersonal(rs.getString("NOMBRE_PERSONAL1"));
//                bean.getSolicitudesSalida().setCodFormSalida(rs.getInt("COD_FORM_SALIDA"));
//                bean.getAreasInstalaciones().setCodAreaInstalacion(rs.getString("COD_AREA_INSTALACION"));
//                bean.getAreasInstalaciones().setNombreAreaInstalacion(rs.getString("NOMBRE_AREA_INSTALACION"));
//                bean.setAfectaraProduccion(rs.getInt("AFECTARA_PRODUCCION"));
//                bean.getTiposNivelSolicitudMantenimiento().setCodTipoNivelSolicitudMantenimiento(rs.getInt("COD_NIVEL_SOLICITUD_MANTENIMIENTO"));
//                bean.getTiposNivelSolicitudMantenimiento().setNombreNivelSolicitudMantenimiento(rs.getString("NOMBRE_NIVEL_SOLICITUD_MANTENIMIENTO"));
//                //bean.setFechaCambioEstadoSolicitud( rs.getDate(19));
//                //bean.getEstadoSolicitudMantenimiento().setCodEstadoSolicitudMantenimiento(rs.getString(20));
                if (bean.getEstadoSolicitudMantenimiento().getCodEstadoSolicitudMantenimiento()==4) {
                    bean.setFechaCambioEstadoSolicitud(null);
                } else {
                }
                //link de tipo de orden de trabajo
                bean.setLinkTipoOrdenDeTrabajo(this.linkTipoDeOrdenDeTrabajo(rs.getInt("COD_ESTADO_SOLICITUD")));
                //link de materiales a utilizar
                bean.setLinkMaterialesUtilizar(this.linkMaterialesUtilizar(rs.getInt("COD_ESTADO_SOLICITUD")));
                //link de trabajos a realizar
                bean.setLinkTrabajosRealizar(this.linkTrabajosRealizar(rs.getInt("COD_ESTADO_SOLICITUD")));
                //estilo de fila
                bean.setEstilo(this.estiloFila1(bean));

                solicitudMantenimientoList.add(bean);
                rs.next();
            }
            cantidadfilas = solicitudMantenimientoList.size();

            if (rs != null) {
                rs.close();
                st.close();
            }


        } catch (SQLException e) {
            e.printStackTrace();
        }
        return solicitudMantenimientoList;
    }
    public String verSolicitudMantenimientoDetalleMateriales_action(){
        try {
            
            solicitudMantenimientoItem = (SolicitudMantenimiento)solicitudMantenimientoDataTable1.getRowData();
            ExternalContext externalContext = FacesContext.getCurrentInstance().getExternalContext();
            Map<String, Object> sessionMap = externalContext.getSessionMap();
            sessionMap.put("solicitudMantenimiento", solicitudMantenimientoItem);

            this.redireccionar("navegador_seguimiento_solicitud_mantenimiento_materiales.jsf?direccion=navegador_solicitud_mantenimiento.jsf");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public String estadoSolicitudMantenimiento_change(){
        begin = 1;
        end = 10;
        solicitudMantenimientoList = this.cargarAprobarSolicitudMantenimiento();
        return null;
    }

    public String siguiente_action() {
        super.next();
        solicitudMantenimientoList = this.cargarAprobarSolicitudMantenimiento();
        return "";
    }

    public String atras_action() {
        super.back();
        solicitudMantenimientoList = this.cargarAprobarSolicitudMantenimiento();
        return "";
    }


    public String getCargarSolicitudMantenimientoUsuario() {
        cargarEstadosSolicitud("", null);
        System.out.println("getCargarSolicitudMantenimiento:");
        ManagedAccesoSistema bean1 = (ManagedAccesoSistema) Util.getSessionBean("ManagedAccesoSistema");
        String codUsuario = bean1.getUsuarioModuloBean().getCodUsuarioGlobal();
        System.out.println("codUsuario=" + codUsuario);
        try {

            String sql = "SELECT S.COD_SOLICITUD_MANTENIMIENTO,S.COD_AREA_EMPRESA,S.COD_GESTION,S.COD_PERSONAL,S.COD_RESPONSABLE,";
            sql += " S.COD_MAQUINARIA,S.COD_TIPO_SOLICITUD_MANTENIMIENTO,S.COD_ESTADO_SOLICITUD_MANTENIMIENTO,S.FECHA_SOLICITUD_MANTENIMIENTO,";
            sql += " S.FECHA_CAMBIO_ESTADOSOLICITUD,(select AE.NOMBRE_AREA_EMPRESA from AREAS_EMPRESA AE WHERE AE.COD_AREA_EMPRESA=S.COD_AREA_EMPRESA),";
            sql += " (select TS.NOMBRE_TIPO_SOLICITUD from TIPOS_SOLICITUD_MANTENIMIENTO TS where TS.COD_TIPO_SOLICITUD=S.COD_TIPO_SOLICITUD_MANTENIMIENTO),";
            sql += " (SELECT TOP 1 ESM.NOMBRE_ESTADO_SOLICITUD FROM ESTADOS_SOLICITUD_MANTENIMIENTO ESM WHERE ESM.COD_ESTADO_SOLICITUD= S.COD_ESTADO_SOLICITUD_MANTENIMIENTO) ,";
            sql += " (select M.NOMBRE_MAQUINA from MAQUINARIAS M where M.COD_MAQUINA=S.COD_MAQUINARIA),S.OBS_SOLICITUD_MANTENIMIENTO,G.NOMBRE_GESTION,";
            sql += " ISNULL((select P.AP_PATERNO_PERSONAL+' '+P.AP_MATERNO_PERSONAL+' '+P.NOMBRES_PERSONAL from PERSONAL P where P.COD_PERSONAL=S.COD_PERSONAL),''),";
            sql += " ISNULL((select TOP 1 PE.AP_PATERNO_PERSONAL+' '+PE.AP_MATERNO_PERSONAL+' '+PE.NOMBRES_PERSONAL from PERSONAL PE,APROBACION_SOLICITUDES_MANTENIMIENTO A,ESTADOS_SOLICITUD_MANTENIMIENTO ES where ES.COD_ESTADO_SOLICITUD=A.COD_ESTADO_SOLICITUD_MANTENIMIENTO AND PE.COD_PERSONAL=A.COD_PERSONAL_RESPONSABLE AND A.COD_PERSONAL_RESPONSABLE=PE.COD_PERSONAL AND A.COD_SOLICITUD_MANTENIMIENTO=S.COD_SOLICITUD_MANTENIMIENTO ORDER BY A.FECHA_CAMBIO_ESTADOSOLICITUD DESC,ES.NIVEL DESC),''),  ";
            sql += " (select TOP 1 A.FECHA_CAMBIO_ESTADOSOLICITUD from ESTADOS_SOLICITUD_MANTENIMIENTO ES,APROBACION_SOLICITUDES_MANTENIMIENTO A where A.COD_SOLICITUD_MANTENIMIENTO = S.COD_SOLICITUD_MANTENIMIENTO AND A.COD_ESTADO_SOLICITUD_MANTENIMIENTO = ES.COD_ESTADO_SOLICITUD ORDER BY A.FECHA_CAMBIO_ESTADOSOLICITUD DESC,ES.NIVEL DESC),";
            sql += " (select TOP 1 ES.COD_ESTADO_SOLICITUD from ESTADOS_SOLICITUD_MANTENIMIENTO ES,APROBACION_SOLICITUDES_MANTENIMIENTO A where A.COD_SOLICITUD_MANTENIMIENTO = S.COD_SOLICITUD_MANTENIMIENTO AND A.COD_ESTADO_SOLICITUD_MANTENIMIENTO = ES.COD_ESTADO_SOLICITUD ORDER BY A.FECHA_CAMBIO_ESTADOSOLICITUD DESC,ES.NIVEL DESC )";
            sql += " FROM SOLICITUDES_MANTENIMIENTO S,GESTIONES G";
            sql += " WHERE  G.COD_GESTION=S.COD_GESTION ";
            sql += " AND S.COD_PERSONAL='" + codUsuario + "'";
            sql += " order by S.COD_SOLICITUD_MANTENIMIENTO DESC";
            System.out.println("navegador: la primera vez" + sql);
            setCon(Util.openConnection(getCon()));
            Statement st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(sql);
            rs.last();
            int rows = rs.getRow();
            getSolicitudMantenimientoList().clear();
            rs.first();
            String cod = "";
            for (int i = 0; i < rows; i++) {
                SolicitudMantenimiento bean = new SolicitudMantenimiento();
                bean.setCodSolicitudMantenimiento(rs.getInt(1));
                bean.getAreasEmpresa().setCodAreaEmpresa(rs.getString(2));
                bean.getGestiones().setCodGestion(rs.getString(3));
                bean.getPersonal_usuario().setCodPersonal(rs.getString(4));
                bean.getPersonal_ejecutante().setCodPersonal(rs.getString(5));
                bean.getMaquinaria().setCodMaquina(rs.getString(6));
                bean.getTiposSolicitudMantenimiento().setCodTipoSolicitud(rs.getInt(7));
                bean.getEstadoSolicitudMantenimiento().setCodEstadoSolicitudMantenimiento(rs.getInt(8));                
                bean.setFechaSolicitudMantenimiento(rs.getDate(9));
                bean.getFechaSolicitudMantenimiento().setTime(rs.getTimestamp("FECHA_SOLICITUD_MANTENIMIENTO").getTime());
                bean.setFechaCambioEstadoSolicitud(rs.getDate("FECHA_CAMBIO_ESTADOSOLICITUD"));
                bean.getAreasEmpresa().setNombreAreaEmpresa(rs.getString(11));
                bean.getTiposSolicitudMantenimiento().setNombreTipoSolicitud(rs.getString(12));
                bean.getEstadoSolicitudMantenimiento().setNombreEstadoSolicitudMantenimiento(rs.getString(13));
                bean.getMaquinaria().setNombreMaquina(rs.getString(14));
                bean.setObsSolicitudMantenimiento(rs.getString(15));
                bean.getGestiones().setNombreGestion(rs.getString(16));
                bean.getPersonal_usuario().setNombrePersonal(rs.getString(17));
                bean.getPersonal_ejecutante().setNombrePersonal(rs.getString(18));
                
                //bean.setFechaCambioEstadoSolicitud(rs.getDate(19));
                //bean.getEstadoSolicitudMantenimiento().setCodEstadoSolicitudMantenimiento(rs.getString(20));
                /*
                if (bean.getEstadoSolicitudMantenimiento().getCodEstadoSolicitudMantenimiento().equals("4")) {
                    bean.setFechaCambioEstadoSolicitud("");
                    bean.setSwSi(0);
                    bean.setSwNo(1);
                } else {
                    bean.setSwSi(1);
                    bean.setSwNo(0);

                }
                 */
              
                //link de tipo de orden de trabajo
                bean.setLinkTipoOrdenDeTrabajo(this.linkTipoDeOrdenDeTrabajo(rs.getInt("COD_ESTADO_SOLICITUD_MANTENIMIENTO")));
                //link de materiales a utilizar
                bean.setLinkMaterialesUtilizar(this.linkMaterialesUtilizar(rs.getInt("COD_ESTADO_SOLICITUD_MANTENIMIENTO")));
                //link de trabajos a realizar
                bean.setLinkTrabajosRealizar(this.linkTrabajosRealizar(rs.getInt("COD_ESTADO_SOLICITUD_MANTENIMIENTO")));
                //link de trabajos a realizar
                bean.setLinkTiempoRealTrabajo(this.linkTrabajosTiemposReales(rs.getInt("COD_ESTADO_SOLICITUD_MANTENIMIENTO")));
                //estilo de fila
                bean.setEstilo(this.estiloFila(rs.getInt("COD_ESTADO_SOLICITUD_MANTENIMIENTO")));

                System.out.println("listado al inicio:" + bean.getCodSolicitudMantenimiento() + " cod_estado_solicitud:" + bean.getEstadoSolicitudMantenimiento().getCodEstadoSolicitudMantenimiento());
                getSolicitudMantenimientoList().add(bean);
                rs.next();
            }

            if (rs != null) {
                rs.close();
                st.close();
            }


        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "";
    }

    public String linkTipoDeOrdenDeTrabajo(int codEstado) {
        //1: ESTADO EMITIDO
        //para el estado 1
        String linkTipoDeTrabajo = "";
        if (codEstado == 1) {
            linkTipoDeTrabajo = " Tipo de Orden de Trabajo ";
        } else {
            linkTipoDeTrabajo = "";
        }
        return linkTipoDeTrabajo;
    }

    public String linkMaterialesUtilizar(int codEstado) {
        //2: ESTADO REVISADO
        //3: EN ESPERA DE MATERIALES
        //para el estado 2 o 3

        String linkMateriales = "";

        switch (codEstado) {
            case (2):
                linkMateriales = "Materiales a Utilizar";
                break;
            case (3):
                linkMateriales = "En Espera de Materiales de Almacen";
                break;
            case (4):
                linkMateriales = "En Espera de Materiales de Orden de Compra";
                break;
        }

        return linkMateriales;
    }

    public String linkTrabajosRealizar(int codEstado) {
        //5 con materiales
        //6 En ejecucion y para colocar las horas y fechas reales donde se trabajo


        String linkTrabajosRealizar = "";
        if (codEstado == 5) {
            linkTrabajosRealizar = " Trabajos a Realizar ";
        } else {
            linkTrabajosRealizar = "";
        }
        return linkTrabajosRealizar;
    }

    public String linkTrabajosTiemposReales(int codEstado) {
        //6 para colocar fechas y rangos de hora reales de trabajo

        String linkTrabajosTiemposReales = "";
        if (codEstado == 6) {
            linkTrabajosTiemposReales = " Tiempos Reales de Trabajo ";
        } else {
            linkTrabajosTiemposReales = "";
        }
        return linkTrabajosTiemposReales;
    }

    public String estiloFila(int codEstado) {


        String estilo = "background-color: #F7BE81;";
        switch (codEstado) {
            case (1):
                estilo = "background-color: #F6E3CE;"; //emitido:naranja
                break;
            case (2):
                estilo = "background-color: #CEF6CE;"; //revisado :verde
                break;
            case (3):
                estilo = "background-color: #E0F8F7;"; //espera materiales :azul
                break;
            case (4):
                estilo = "background-color: #E0F8F7;"; //en espera : azul
                break;
            case (5):
                estilo = "background-color: #E0E0F8;"; // en ejecucion : guindo
                break;
            case (6):
                estilo = "background-color: #F8E0EC;"; // cerrado : rojo
                break;
        }

        return estilo;
    }
    public String estiloFila1(SolicitudMantenimiento solicitudMantenimiento) {
        String estilo = "background-color: #F7BE81;";
        switch (solicitudMantenimiento.getTiposNivelSolicitudMantenimiento().getCodTipoNivelSolicitudMantenimiento()) {
            case (1):
                estilo = "background-color: #F8E0EC;"; // prioridad alta : rojo
                break;
            case (2):
                estilo = "background-color: #F6E3CE;"; // prioridad media : naranja
                break;
            case (3):
                estilo = "background-color: #CEF6CE;"; // prioridad baja: verde
                break;
        }
        return estilo;
    }

    public String cancelar() {
        getCargarSolicitudMantenimiento();
        //return "navegadorSolicitudMantenimiento";
        this.redireccionar("navegador_solicitud_mantenimiento.jsf");
        return null;
    }

    public String cancelarAprob() {
        getCargarSolicitudMantenimiento();
        return "navegadorAprobSolicitudMantenimiento";
    }

    public void changeEventUsuario(ValueChangeEvent event) {
        System.out.println("event:" + event.getNewValue());
        setCodigo(event.getNewValue().toString());
        ManagedAccesoSistema bean1 = (ManagedAccesoSistema) Util.getSessionBean("ManagedAccesoSistema");
        String codUsuario = bean1.getUsuarioModuloBean().getCodUsuarioGlobal();
        System.out.println("codUsuario=" + codUsuario);
        try {
            String sql = "SELECT S.COD_SOLICITUD_MANTENIMIENTO,S.COD_AREA_EMPRESA,S.COD_GESTION,S.COD_PERSONAL,S.COD_RESPONSABLE,";
            sql += " S.COD_MAQUINARIA,S.COD_TIPO_SOLICITUD_MANTENIMIENTO,S.COD_ESTADO_SOLICITUD_MANTENIMIENTO,S.FECHA_SOLICITUD_MANTENIMIENTO,";
            sql += " S.FECHA_CAMBIO_ESTADOSOLICITUD,(select AE.NOMBRE_AREA_EMPRESA from AREAS_EMPRESA AE WHERE AE.COD_AREA_EMPRESA=S.COD_AREA_EMPRESA),";
            sql += " (select TS.NOMBRE_TIPO_SOLICITUD from TIPOS_SOLICITUD_MANTENIMIENTO TS where TS.COD_TIPO_SOLICITUD=S.COD_TIPO_SOLICITUD_MANTENIMIENTO),";
            sql += " (select TOP 1 ES.NOMBRE_ESTADO_SOLICITUD from ESTADOS_SOLICITUD_MANTENIMIENTO ES,APROBACION_SOLICITUDES_MANTENIMIENTO A where A.COD_SOLICITUD_MANTENIMIENTO=S.COD_SOLICITUD_MANTENIMIENTO AND A.COD_ESTADO_SOLICITUD_MANTENIMIENTO=ES.COD_ESTADO_SOLICITUD ORDER BY A.FECHA_CAMBIO_ESTADOSOLICITUD DESC,ES.NIVEL DESC),";
            sql += " (select M.NOMBRE_MAQUINA from MAQUINARIAS M where M.COD_MAQUINA=S.COD_MAQUINARIA),S.OBS_SOLICITUD_MANTENIMIENTO,G.NOMBRE_GESTION,";
            sql += " ISNULL((select P.AP_PATERNO_PERSONAL+' '+P.AP_MATERNO_PERSONAL+' '+P.NOMBRES_PERSONAL from PERSONAL P where P.COD_PERSONAL=S.COD_PERSONAL),''),";
            sql += " ISNULL((select TOP 1 PE.AP_PATERNO_PERSONAL+' '+PE.AP_MATERNO_PERSONAL+' '+PE.NOMBRES_PERSONAL from PERSONAL PE,APROBACION_SOLICITUDES_MANTENIMIENTO A,ESTADOS_SOLICITUD_MANTENIMIENTO ES where ES.COD_ESTADO_SOLICITUD=A.COD_ESTADO_SOLICITUD_MANTENIMIENTO AND PE.COD_PERSONAL=A.COD_PERSONAL_RESPONSABLE AND A.COD_PERSONAL_RESPONSABLE=PE.COD_PERSONAL AND A.COD_SOLICITUD_MANTENIMIENTO=S.COD_SOLICITUD_MANTENIMIENTO ORDER BY A.FECHA_CAMBIO_ESTADOSOLICITUD DESC,ES.NIVEL DESC),''),  ";
            sql += " (select TOP 1 A.FECHA_CAMBIO_ESTADOSOLICITUD from ESTADOS_SOLICITUD_MANTENIMIENTO ES,APROBACION_SOLICITUDES_MANTENIMIENTO A where A.COD_SOLICITUD_MANTENIMIENTO = S.COD_SOLICITUD_MANTENIMIENTO AND A.COD_ESTADO_SOLICITUD_MANTENIMIENTO = ES.COD_ESTADO_SOLICITUD ORDER BY A.FECHA_CAMBIO_ESTADOSOLICITUD DESC,ES.NIVEL DESC),";
            sql += " (select TOP 1 ES.COD_ESTADO_SOLICITUD from ESTADOS_SOLICITUD_MANTENIMIENTO ES,APROBACION_SOLICITUDES_MANTENIMIENTO A where A.COD_SOLICITUD_MANTENIMIENTO = S.COD_SOLICITUD_MANTENIMIENTO AND A.COD_ESTADO_SOLICITUD_MANTENIMIENTO = ES.COD_ESTADO_SOLICITUD ORDER BY A.FECHA_CAMBIO_ESTADOSOLICITUD DESC,ES.NIVEL DESC )";
            sql += " FROM SOLICITUDES_MANTENIMIENTO S,GESTIONES G";
            sql += " WHERE  G.COD_GESTION=S.COD_GESTION ";
            sql += " AND S.COD_PERSONAL='" + codUsuario + "'";
            sql += " order by S.COD_SOLICITUD_MANTENIMIENTO DESC";

            System.out.println("navegador:" + sql);
            setCon(Util.openConnection(getCon()));
            Statement st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(sql);
            rs.last();
            int rows = rs.getRow();
            solicitudMantenimientoList.clear();
            rs.first();
            String cod = "";
            for (int i = 0; i < rows; i++) {
                SolicitudMantenimiento bean = new SolicitudMantenimiento();
                bean.setCodSolicitudMantenimiento(rs.getInt(1));
                bean.getAreasEmpresa().setCodAreaEmpresa(rs.getString(2));
                bean.getGestiones().setCodGestion(rs.getString(3));
                bean.getPersonal_usuario().setCodPersonal(rs.getString(4));
                bean.getPersonal_ejecutante().setCodPersonal(rs.getString(5));
                bean.getMaquinaria().setCodMaquina(rs.getString(6));
                bean.getTiposSolicitudMantenimiento().setCodTipoSolicitud(rs.getInt(7));
                bean.getEstadoSolicitudMantenimiento().setCodEstadoSolicitudMantenimiento(rs.getInt(8));

                
                bean.setFechaSolicitudMantenimiento(rs.getDate(9));
                bean.getFechaSolicitudMantenimiento().setTime(rs.getTimestamp("FECHA_SOLICITUD_MANTENIMIENTO").getTime());
                
                bean.setFechaCambioEstadoSolicitud(rs.getDate(10));
                bean.getAreasEmpresa().setNombreAreaEmpresa(rs.getString(11));
                bean.getTiposSolicitudMantenimiento().setNombreTipoSolicitud(rs.getString(12));
                bean.getEstadoSolicitudMantenimiento().setNombreEstadoSolicitudMantenimiento(rs.getString(13));
                bean.getMaquinaria().setNombreMaquina(rs.getString(14));
                bean.setObsSolicitudMantenimiento(rs.getString(15));
                bean.getGestiones().setNombreGestion(rs.getString(16));
                bean.getPersonal_usuario().setNombrePersonal(rs.getString(17));
                bean.getPersonal_ejecutante().setNombrePersonal(rs.getString(18));
                
                bean.setFechaCambioEstadoSolicitud(rs.getDate(19));
                //bean.getEstadoSolicitudMantenimiento().setCodEstadoSolicitudMantenimiento(rs.getString(20));
                //link de tipo de orden de trabajo
                bean.setLinkTipoOrdenDeTrabajo(this.linkTipoDeOrdenDeTrabajo(rs.getInt("COD_ESTADO_SOLICITUD_MANTENIMIENTO")));
                //link de materiales a utilizar
                bean.setLinkMaterialesUtilizar(this.linkMaterialesUtilizar(rs.getInt("COD_ESTADO_SOLICITUD_MANTENIMIENTO")));
                //link de trabajos a realizar
                bean.setLinkTrabajosRealizar(this.linkTrabajosRealizar(rs.getInt("COD_ESTADO_SOLICITUD_MANTENIMIENTO")));
                //link de trabajos a realizar
                bean.setLinkTrabajosRealizar(this.linkTrabajosRealizar(rs.getInt("COD_ESTADO_SOLICITUD_MANTENIMIENTO")));
                //link de puesta de horas y fechas reales de trabajo
                bean.setLinkTrabajosRealizar(this.linkTrabajosRealizar(rs.getInt("COD_ESTADO_SOLICITUD_MANTENIMIENTO")));

                //estilo de fila
                bean.setEstilo(this.estiloFila(rs.getInt("COD_ESTADO_SOLICITUD_MANTENIMIENTO")));


                if (bean.getEstadoSolicitudMantenimiento().getCodEstadoSolicitudMantenimiento()==4) {
                    
                } else {
                    
                }
                if (codigo.equals("0")) {
                    getSolicitudMantenimientoList().add(bean);
                } else {
                    if (codigo.equals(bean.getEstadoSolicitudMantenimiento().getCodEstadoSolicitudMantenimiento())) {
                        getSolicitudMantenimientoList().add(bean);
                    }
                }
                //getSolicitudMantenimientoList().add(bean);
                rs.next();
            }
            if (rs != null) {
                rs.close();
                st.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public List cargarSolicitudesMantenimiento(){
        List solicitudMantenimientoList = new ArrayList();
        try {
        ManagedAccesoSistema bean1 = (ManagedAccesoSistema) Util.getSessionBean("ManagedAccesoSistema");
        String codUsuario = bean1.getUsuarioModuloBean().getCodUsuarioGlobal();
        System.out.println("codUsuario=" + codUsuario);
            String sql = " select * from (select ROW_NUMBER() OVER (ORDER BY S.COD_SOLICITUD_MANTENIMIENTO desc) as 'FILAS', S.COD_SOLICITUD_MANTENIMIENTO,S.COD_AREA_EMPRESA,S.COD_GESTION,S.COD_PERSONAL,S.COD_RESPONSABLE,";
            sql += " S.COD_MAQUINARIA,S.COD_TIPO_SOLICITUD_MANTENIMIENTO,S.COD_ESTADO_SOLICITUD_MANTENIMIENTO,S.FECHA_SOLICITUD_MANTENIMIENTO,";
            sql += " S.FECHA_CAMBIO_ESTADOSOLICITUD,(select AE.NOMBRE_AREA_EMPRESA from AREAS_EMPRESA AE WHERE AE.COD_AREA_EMPRESA=S.COD_AREA_EMPRESA) NOMBRE_AREA_EMPRESA,";
            sql += " (select TS.NOMBRE_TIPO_SOLICITUD from TIPOS_SOLICITUD_MANTENIMIENTO TS where TS.COD_TIPO_SOLICITUD=S.COD_TIPO_SOLICITUD_MANTENIMIENTO) NOMBRE_TIPO_SOLICITUD,";
            sql += " (select TOP 1 ES.NOMBRE_ESTADO_SOLICITUD from ESTADOS_SOLICITUD_MANTENIMIENTO ES,APROBACION_SOLICITUDES_MANTENIMIENTO A where A.COD_SOLICITUD_MANTENIMIENTO=S.COD_SOLICITUD_MANTENIMIENTO AND A.COD_ESTADO_SOLICITUD_MANTENIMIENTO=ES.COD_ESTADO_SOLICITUD ORDER BY A.FECHA_CAMBIO_ESTADOSOLICITUD DESC,ES.NIVEL DESC) NOMBRE_ESTADO_SOLICITUD1,";
            sql += " (select M.NOMBRE_MAQUINA from MAQUINARIAS M where M.COD_MAQUINA=S.COD_MAQUINARIA) NOMBRE_MAQUINA,S.OBS_SOLICITUD_MANTENIMIENTO,G.NOMBRE_GESTION ,";
            sql += " ISNULL((select P.AP_PATERNO_PERSONAL+' '+P.AP_MATERNO_PERSONAL+' '+P.NOMBRES_PERSONAL from PERSONAL P where P.COD_PERSONAL=S.COD_PERSONAL),'') NOMBRE_PERSONAL,";
            sql += " ISNULL((select TOP 1 PE.AP_PATERNO_PERSONAL+' '+PE.AP_MATERNO_PERSONAL+' '+PE.NOMBRES_PERSONAL from PERSONAL PE,APROBACION_SOLICITUDES_MANTENIMIENTO A,ESTADOS_SOLICITUD_MANTENIMIENTO ES where ES.COD_ESTADO_SOLICITUD=A.COD_ESTADO_SOLICITUD_MANTENIMIENTO AND PE.COD_PERSONAL=A.COD_PERSONAL_RESPONSABLE AND A.COD_PERSONAL_RESPONSABLE=PE.COD_PERSONAL AND A.COD_SOLICITUD_MANTENIMIENTO=S.COD_SOLICITUD_MANTENIMIENTO ORDER BY A.FECHA_CAMBIO_ESTADOSOLICITUD DESC,ES.NIVEL DESC),'') NOMBRE_PERSONAL1,  ";
            sql += " (select TOP 1 A.FECHA_CAMBIO_ESTADOSOLICITUD from ESTADOS_SOLICITUD_MANTENIMIENTO ES,APROBACION_SOLICITUDES_MANTENIMIENTO A where A.COD_SOLICITUD_MANTENIMIENTO = S.COD_SOLICITUD_MANTENIMIENTO AND A.COD_ESTADO_SOLICITUD_MANTENIMIENTO = ES.COD_ESTADO_SOLICITUD ORDER BY A.FECHA_CAMBIO_ESTADOSOLICITUD DESC,ES.NIVEL DESC) FECHA_CAMBIO_ESTADOSOLICITUD1";
            sql += " ,E.COD_ESTADO_SOLICITUD,E.NOMBRE_ESTADO_SOLICITUD ";//,(select TOP 1 ES.COD_ESTADO_SOLICITUD from ESTADOS_SOLICITUD_MANTENIMIENTO ES,APROBACION_SOLICITUDES_MANTENIMIENTO A where A.COD_SOLICITUD_MANTENIMIENTO = S.COD_SOLICITUD_MANTENIMIENTO AND A.COD_ESTADO_SOLICITUD_MANTENIMIENTO = ES.COD_ESTADO_SOLICITUD ORDER BY A.FECHA_CAMBIO_ESTADOSOLICITUD DESC,ES.NIVEL DESC )
            sql += " FROM SOLICITUDES_MANTENIMIENTO S,GESTIONES G,ESTADOS_SOLICITUD_MANTENIMIENTO E";
            sql += " WHERE  G.COD_GESTION=S.COD_GESTION AND E.COD_ESTADO_SOLICITUD = S.COD_ESTADO_SOLICITUD_MANTENIMIENTO" ;
            if(solicitudMantenimientobean.getEstadoSolicitudMantenimiento().getCodEstadoSolicitudMantenimiento()!=0){
                sql+=" and s.cod_estado_solicitud_mantenimiento = '"+solicitudMantenimientobean.getEstadoSolicitudMantenimiento().getCodEstadoSolicitudMantenimiento()+"' ";
            }
            //sql+=" AND S.COD_PERSONAL='"+codUsuario+"'";
            sql += " ) AS listado_solicitud_mantenimiento where FILAS BETWEEN " + begin + " AND " + end + " ";
            System.out.println("navegador:" + sql);
            setCon(Util.openConnection(getCon()));
            Statement st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(sql);
            rs.last();
            int rows = rs.getRow();
            solicitudMantenimientoList.clear();
            rs.first();
            String cod = "";
            cantidadfilas = 0;
            for (int i = 0; i < rows; i++) {
                SolicitudMantenimiento bean = new SolicitudMantenimiento();
                bean.setCodSolicitudMantenimiento(rs.getInt("COD_SOLICITUD_MANTENIMIENTO"));
                bean.getAreasEmpresa().setCodAreaEmpresa(rs.getString("COD_AREA_EMPRESA"));
                bean.getGestiones().setCodGestion(rs.getString("COD_GESTION"));
                bean.getPersonal_usuario().setCodPersonal(rs.getString("COD_PERSONAL"));
                bean.getPersonal_ejecutante().setCodPersonal(rs.getString("COD_RESPONSABLE"));
                bean.getMaquinaria().setCodMaquina(rs.getString("COD_MAQUINARIA"));
                bean.getTiposSolicitudMantenimiento().setCodTipoSolicitud(rs.getInt("COD_TIPO_SOLICITUD_MANTENIMIENTO"));
                bean.getEstadoSolicitudMantenimiento().setCodEstadoSolicitudMantenimiento(rs.getInt("COD_ESTADO_SOLICITUD"));
                bean.getEstadoSolicitudMantenimiento().setNombreEstadoSolicitudMantenimiento(rs.getString("NOMBRE_ESTADO_SOLICITUD"));
                bean.setFechaSolicitudMantenimiento(rs.getDate("FECHA_SOLICITUD_MANTENIMIENTO"));
                bean.getFechaSolicitudMantenimiento().setTime(rs.getTimestamp("FECHA_SOLICITUD_MANTENIMIENTO").getTime());
                bean.setFechaCambioEstadoSolicitud(rs.getDate("FECHA_CAMBIO_ESTADOSOLICITUD"));
                bean.getAreasEmpresa().setNombreAreaEmpresa(rs.getString("NOMBRE_AREA_EMPRESA"));
                bean.getTiposSolicitudMantenimiento().setNombreTipoSolicitud(rs.getString("NOMBRE_TIPO_SOLICITUD"));
                bean.getMaquinaria().setNombreMaquina(rs.getString("NOMBRE_MAQUINA"));
                bean.setObsSolicitudMantenimiento(rs.getString("OBS_SOLICITUD_MANTENIMIENTO"));
                bean.getGestiones().setNombreGestion(rs.getString("NOMBRE_GESTION"));
                bean.getPersonal_usuario().setNombrePersonal(rs.getString("NOMBRE_PERSONAL"));
                bean.getPersonal_ejecutante().setNombrePersonal(rs.getString("NOMBRE_PERSONAL1"));
                //bean.setFechaCambioEstadoSolicitud(rs.getDate(19));
                // bean.getEstadoSolicitudMantenimiento().setCodEstadoSolicitudMantenimiento(rs.getString(20));
                if (bean.getEstadoSolicitudMantenimiento().getCodEstadoSolicitudMantenimiento()==4) {
                } else {
                }
//                if (codigo.equals("0")) {
//                    getSolicitudMantenimientoList().add(bean);
//                } else {
//                    if (codigo.equals(bean.getEstadoSolicitudMantenimiento().getCodEstadoSolicitudMantenimiento())) {
//                        getSolicitudMantenimientoList().add(bean);
//                    }
//                }
                solicitudMantenimientoList.add(bean);
                rs.next();
            }
            cantidadfilas = solicitudMantenimientoList.size();

            if (rs != null) {
                rs.close();
                st.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return solicitudMantenimientoList;
    }
    public String siguiente_action1() {
        super.next();
        solicitudMantenimientoList = this.cargarAprobarSolicitudMantenimiento();
        return "";
    }

    public String atras_action1() {
        super.back();
        solicitudMantenimientoList = this.cargarAprobarSolicitudMantenimiento();
        return "";
    }
    public String changeEvent1(){
        super.setBegin(1);
        super.setEnd(10);
        solicitudMantenimientoList = this.cargarAprobarSolicitudMantenimiento();
        return "";
    }
    public String changeEvent() { //public void changeEvent(ValueChangeEvent event) {
        //System.out.println("event:" + event.getNewValue());
        //setCodigo(event.getNewValue().toString());
        ManagedAccesoSistema bean1 = (ManagedAccesoSistema) Util.getSessionBean("ManagedAccesoSistema");
        String codUsuario = bean1.getUsuarioModuloBean().getCodUsuarioGlobal();
        System.out.println("codUsuario=" + codUsuario);
        try {

            String sql = "SELECT S.COD_SOLICITUD_MANTENIMIENTO,S.COD_AREA_EMPRESA,S.COD_GESTION,S.COD_PERSONAL,S.COD_RESPONSABLE,";
            sql += " S.COD_MAQUINARIA,S.COD_TIPO_SOLICITUD_MANTENIMIENTO,S.COD_ESTADO_SOLICITUD_MANTENIMIENTO,S.FECHA_SOLICITUD_MANTENIMIENTO,";
            sql += " S.FECHA_CAMBIO_ESTADOSOLICITUD,(select AE.NOMBRE_AREA_EMPRESA from AREAS_EMPRESA AE WHERE AE.COD_AREA_EMPRESA=S.COD_AREA_EMPRESA),";
            sql += " (select TS.NOMBRE_TIPO_SOLICITUD from TIPOS_SOLICITUD_MANTENIMIENTO TS where TS.COD_TIPO_SOLICITUD=S.COD_TIPO_SOLICITUD_MANTENIMIENTO),";
            sql += " (select TOP 1 ES.NOMBRE_ESTADO_SOLICITUD from ESTADOS_SOLICITUD_MANTENIMIENTO ES,APROBACION_SOLICITUDES_MANTENIMIENTO A where A.COD_SOLICITUD_MANTENIMIENTO=S.COD_SOLICITUD_MANTENIMIENTO AND A.COD_ESTADO_SOLICITUD_MANTENIMIENTO=ES.COD_ESTADO_SOLICITUD ORDER BY A.FECHA_CAMBIO_ESTADOSOLICITUD DESC,ES.NIVEL DESC),";
            sql += " (select M.NOMBRE_MAQUINA from MAQUINARIAS M where M.COD_MAQUINA=S.COD_MAQUINARIA),S.OBS_SOLICITUD_MANTENIMIENTO,G.NOMBRE_GESTION,";
            sql += " ISNULL((select P.AP_PATERNO_PERSONAL+' '+P.AP_MATERNO_PERSONAL+' '+P.NOMBRES_PERSONAL from PERSONAL P where P.COD_PERSONAL=S.COD_PERSONAL),''),";
            sql += " ISNULL((select TOP 1 PE.AP_PATERNO_PERSONAL+' '+PE.AP_MATERNO_PERSONAL+' '+PE.NOMBRES_PERSONAL from PERSONAL PE,APROBACION_SOLICITUDES_MANTENIMIENTO A,ESTADOS_SOLICITUD_MANTENIMIENTO ES where ES.COD_ESTADO_SOLICITUD=A.COD_ESTADO_SOLICITUD_MANTENIMIENTO AND PE.COD_PERSONAL=A.COD_PERSONAL_RESPONSABLE AND A.COD_PERSONAL_RESPONSABLE=PE.COD_PERSONAL AND A.COD_SOLICITUD_MANTENIMIENTO=S.COD_SOLICITUD_MANTENIMIENTO ORDER BY A.FECHA_CAMBIO_ESTADOSOLICITUD DESC,ES.NIVEL DESC),''),  ";
            sql += " (select TOP 1 A.FECHA_CAMBIO_ESTADOSOLICITUD from ESTADOS_SOLICITUD_MANTENIMIENTO ES,APROBACION_SOLICITUDES_MANTENIMIENTO A where A.COD_SOLICITUD_MANTENIMIENTO = S.COD_SOLICITUD_MANTENIMIENTO AND A.COD_ESTADO_SOLICITUD_MANTENIMIENTO = ES.COD_ESTADO_SOLICITUD ORDER BY A.FECHA_CAMBIO_ESTADOSOLICITUD DESC,ES.NIVEL DESC) ";
            sql += " ,E.COD_ESTADO_SOLICITUD,E.NOMBRE_ESTADO_SOLICITUD ";//,(select TOP 1 ES.COD_ESTADO_SOLICITUD from ESTADOS_SOLICITUD_MANTENIMIENTO ES,APROBACION_SOLICITUDES_MANTENIMIENTO A where A.COD_SOLICITUD_MANTENIMIENTO = S.COD_SOLICITUD_MANTENIMIENTO AND A.COD_ESTADO_SOLICITUD_MANTENIMIENTO = ES.COD_ESTADO_SOLICITUD ORDER BY A.FECHA_CAMBIO_ESTADOSOLICITUD DESC,ES.NIVEL DESC )
            sql += " FROM SOLICITUDES_MANTENIMIENTO S,GESTIONES G,ESTADOS_SOLICITUD_MANTENIMIENTO E";
            sql += " WHERE  G.COD_GESTION=S.COD_GESTION AND E.COD_ESTADO_SOLICITUD = S.COD_ESTADO_SOLICITUD_MANTENIMIENTO" ;
            if(solicitudMantenimientobean.getEstadoSolicitudMantenimiento().getCodEstadoSolicitudMantenimiento()!=0){
                sql+=" and s.cod_estado_solicitud_mantenimiento = '"+solicitudMantenimientobean.getEstadoSolicitudMantenimiento().getCodEstadoSolicitudMantenimiento()+"' ";
            }

            //sql+=" AND S.COD_PERSONAL='"+codUsuario+"'";
            sql += " order by S.COD_SOLICITUD_MANTENIMIENTO DESC";
            System.out.println("navegador:" + sql);
            setCon(Util.openConnection(getCon()));
            Statement st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(sql);
            rs.last();
            int rows = rs.getRow();
            solicitudMantenimientoList.clear();
            rs.first();
            String cod = "";
            for (int i = 0; i < rows; i++) {
                SolicitudMantenimiento bean = new SolicitudMantenimiento();
                bean.setCodSolicitudMantenimiento(rs.getInt(1));
                bean.getAreasEmpresa().setCodAreaEmpresa(rs.getString(2));
                bean.getGestiones().setCodGestion(rs.getString(3));
                bean.getPersonal_usuario().setCodPersonal(rs.getString(4));
                bean.getPersonal_ejecutante().setCodPersonal(rs.getString(5));
                bean.getMaquinaria().setCodMaquina(rs.getString(6));
                bean.getTiposSolicitudMantenimiento().setCodTipoSolicitud(rs.getInt(7));
                bean.getEstadoSolicitudMantenimiento().setCodEstadoSolicitudMantenimiento(rs.getInt("COD_ESTADO_SOLICITUD"));
                bean.getEstadoSolicitudMantenimiento().setNombreEstadoSolicitudMantenimiento(rs.getString("NOMBRE_ESTADO_SOLICITUD"));
                bean.setFechaSolicitudMantenimiento(rs.getDate(9));
                bean.getFechaSolicitudMantenimiento().setTime(rs.getTimestamp("FECHA_SOLICITUD_MANTENIMIENTO").getTime());                
                bean.setFechaCambioEstadoSolicitud(rs.getDate(10));
                bean.getAreasEmpresa().setNombreAreaEmpresa(rs.getString(11));
                bean.getTiposSolicitudMantenimiento().setNombreTipoSolicitud(rs.getString(12));                
                bean.getMaquinaria().setNombreMaquina(rs.getString(14));
                bean.setObsSolicitudMantenimiento(rs.getString(15));
                bean.getGestiones().setNombreGestion(rs.getString(16));
                bean.getPersonal_usuario().setNombrePersonal(rs.getString(17));
                bean.getPersonal_ejecutante().setNombrePersonal(rs.getString(18));                
                bean.setFechaCambioEstadoSolicitud(rs.getDate(19));
                // bean.getEstadoSolicitudMantenimiento().setCodEstadoSolicitudMantenimiento(rs.getString(20));
                if (bean.getEstadoSolicitudMantenimiento().getCodEstadoSolicitudMantenimiento()==4) {
                } else {
                }
//                if (codigo.equals("0")) {
//                    getSolicitudMantenimientoList().add(bean);
//                } else {
//                    if (codigo.equals(bean.getEstadoSolicitudMantenimiento().getCodEstadoSolicitudMantenimiento())) {
//                        getSolicitudMantenimientoList().add(bean);
//                    }
//                }
                getSolicitudMantenimientoList().add(bean);
                rs.next();
            }

            if (rs != null) {
                rs.close();
                st.close();
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Metodo que cierra la conexion
     */
    public String getCloseConnection() throws SQLException {
        if (getCon() != null) {
            getCon().close();
        }
        return "";
    }

    /**********ESTADO REGISTRO****************/
public String guardarSolicitudMantenimiento() {
        System.out.println("aqui entro-------------------");
        getCodigoSolicitud();
        System.out.println("codigo:" + solicitudMantenimientobean.getCodSolicitudMantenimiento());
        
        ManagedAccesoSistema bean = (ManagedAccesoSistema) Util.getSessionBean("ManagedAccesoSistema");
        String codUsuario = bean.getUsuarioModuloBean().getCodUsuarioGlobal();
        System.out.println("codUsuario=" + codUsuario);

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
        SimpleDateFormat fh = new SimpleDateFormat("HH:mm:ss");

        /*String fechaFinal=programaProduccionbean.getFechaFinal();
        String fechaFinalVector[]=fechaFinal.split("/");
        fechaFinal=fechaFinalVector[2]+"/"+fechaFinalVector[1]+"/"+fechaFinalVector[0];*/
        try {

            String consulta = "select G.COD_GESTION, G.NOMBRE_GESTION from GESTIONES G where GETDATE() BETWEEN G.FECHA_INI AND G.FECHA_FIN";
            PreparedStatement st = getCon().prepareStatement(consulta);
            ResultSet rs = st.executeQuery();
            String gestion = "";
            if (rs.next()) {
                gestion = rs.getString("COD_GESTION");
            }
            System.out.println("la gestion " + gestion);

            
            String sql = "insert into SOLICITUDES_MANTENIMIENTO(COD_SOLICITUD_MANTENIMIENTO,COD_AREA_EMPRESA,COD_GESTION,COD_PERSONAL,COD_MAQUINARIA,COD_TIPO_SOLICITUD_MANTENIMIENTO,";
            sql += " COD_ESTADO_SOLICITUD_MANTENIMIENTO,FECHA_SOLICITUD_MANTENIMIENTO,OBS_SOLICITUD_MANTENIMIENTO,AFECTARA_PRODUCCION,COD_AREA_INSTALACION,COD_TIPO_NIVEL_SOLICITUD_MANTENIMIENTO,COD_AREA_INSTALACION_DETALLE,SOLICITUD_PROYECTO,SOLICITUD_PRODUCCION)values(";
            sql += " '" + solicitudMantenimientobean.getCodSolicitudMantenimiento() + "','" + solicitudMantenimientobean.getAreasEmpresa().getCodAreaEmpresa() + "',";
            //sql+=" '"+solicitudMantenimientobean.getGestiones().getCodGestion()+"','"+codUsuario+"',";
            sql += " '" + gestion + "','" + solicitudMantenimientobean.getPersonal_usuario().getCodPersonal() + "',";
            sql += " '" + (valorAsignado.equals("maquinaria")?solicitudMantenimientobean.getMaquinaria().getCodMaquina():"0") + "','" + solicitudMantenimientobean.getTiposSolicitudMantenimiento().getCodTipoSolicitud()+ "',";
            sql += " 1,'" + sdf.format(solicitudMantenimientobean.getFechaSolicitudMantenimiento())+" "+fh.format(solicitudMantenimientobean.getFechaSolicitudMantenimiento()) + "','" + solicitudMantenimientobean.getObsSolicitudMantenimiento() + "', " +
                   " '"+solicitudMantenimientobean.getAfectaraProduccion()+"','"+(valorAsignado.equals("instalacion")?solicitudMantenimientobean.getAreasInstalaciones().getCodAreaInstalacion():"0")+"','"+solicitudMantenimientobean.getTiposNivelSolicitudMantenimiento().getCodTipoNivelSolicitudMantenimiento()+"'"+
                   ",'"+(valorAsignado.equals("instalacion")?solicitudMantenimientobean.getAreasInstalacionesDetalle().getCodAreaInstalacionDetalle():"0")+"','"+solicitudMantenimientobean.getSolicitudProyecto()+"','"+solicitudMantenimientobean.getSolicitudProduccion()+"')";
            System.out.println("insert SOLICITUDES_MANTENIMIENTO:" + sql);
            

            
            setCon(Util.openConnection(getCon()));
            st = getCon().prepareStatement(sql);
            int result = st.executeUpdate();

            sql = "insert into APROBACION_SOLICITUDES_MANTENIMIENTO(COD_SOLICITUD_MANTENIMIENTO,COD_ESTADO_SOLICITUD_MANTENIMIENTO,";
            sql += " COD_PERSONAL_RESPONSABLE,FECHA_CAMBIO_ESTADOSOLICITUD,OBS_SOLICITUD_MANTENIMIENTO)values(";
            sql += " '" + solicitudMantenimientobean.getCodSolicitudMantenimiento() + "',1,0,";
            sql += " '" + sdf.format(solicitudMantenimientobean.getFechaSolicitudMantenimiento()) + " "+fh.format(solicitudMantenimientobean.getFechaSolicitudMantenimiento()) + "','" + solicitudMantenimientobean.getObsSolicitudMantenimiento() + "')";
            System.out.println("insert APROBACION_SOLICITUDES_MANTENIMIENTO:" + sql);
            setCon(Util.openConnection(getCon()));
            st = getCon().prepareStatement(sql);
            result = st.executeUpdate();


            System.out.println("result:" + result);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        //getCargarProgramaProduccion1();
        getCargarSolicitudMantenimiento();
        //return "navegadorSolicitudMantenimiento";
        //this.redireccionar("navegador_solicitud_mantenimiento.jsf");
        return null;
    }
     public String instalaciones_change()
    {
        try
        {
            Connection con1=null;
            con1=Util.openConnection(con1);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select aid.COD_AREA_INSTALACION_DETALLE,(aid.NOMBRE_AREA_INSTALACION_DETALLE+'('+ae.NOMBRE_AREA_EMPRESA+')('+aid.CODIGO+')') as nombre"+
                            " from AREAS_INSTALACIONES_DETALLE aid inner join AREAS_EMPRESA ae on "+
                            " ae.COD_AREA_EMPRESA=aid.COD_AREA_EMPRESA"+
                            " where aid.COD_AREA_INSTALACION='"+solicitudMantenimientobean.getAreasInstalaciones().getCodAreaInstalacion()+"'"+
                            " order by aid.NOMBRE_AREA_INSTALACION_DETALLE,ae.NOMBRE_AREA_EMPRESA";
            System.out.println("consulta cargar detalle "+consulta);
            ResultSet res=st.executeQuery(consulta);
            areasInstalacionesDetalleSelectList.clear();
            areasInstalacionesDetalleSelectList.add(new SelectItem(0,"-NINGUNO-"));
            while(res.next())
            {
                areasInstalacionesDetalleSelectList.add(new SelectItem(res.getInt("COD_AREA_INSTALACION_DETALLE"),res.getString("nombre")));
            }
            res.close();
            st.close();
            con1.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
        return null;
    }
    public String instalacionEditar_change()
    {
        try
        {
            Connection con1=null;
            con1=Util.openConnection(con1);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select aid.COD_AREA_INSTALACION_DETALLE,(aid.NOMBRE_AREA_INSTALACION_DETALLE+'('+ae.NOMBRE_AREA_EMPRESA+')('+aid.CODIGO+')') as nombre"+
                            " from AREAS_INSTALACIONES_DETALLE aid inner join AREAS_EMPRESA ae on "+
                            " ae.COD_AREA_EMPRESA=aid.COD_AREA_EMPRESA"+
                        //    " where aid.COD_AREA_INSTALACION='"+solicitudMantenimientoEditar.getModulosInstalaciones().getAreasInstalacionesModulos().getAreasInstalaciones().getCodAreaInstalacion()+"'"+
                            " order by aid.NOMBRE_AREA_INSTALACION_DETALLE,ae.NOMBRE_AREA_EMPRESA";
            System.out.println("consulta cargar detalle "+consulta);
            ResultSet res=st.executeQuery(consulta);
            areasInstalacionesDetalleSelectList.clear();
            areasInstalacionesDetalleSelectList.add(new SelectItem(0,"-NINGUNO-"));
            while(res.next())
            {
                areasInstalacionesDetalleSelectList.add(new SelectItem(res.getInt("COD_AREA_INSTALACION_DETALLE"),res.getString("nombre")));
            }
            res.close();
            st.close();
            con1.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
        return null;
    }

    public String guardarAprobSolicitudMantenimiento() {
        System.out.println("aqui entro---------Aprob----------");
        //getCodigoSolicitud();
        System.out.println("codigo:" + solicitudMantenimientobean.getCodSolicitudMantenimiento());
        String fechaEmision = aprobacionSolicitudMantenimientobean.getFechaCambioEstado();
        String fechaInicioVector[] = fechaEmision.split("/");
        fechaEmision = fechaInicioVector[2] + "/" + fechaInicioVector[1] + "/" + fechaInicioVector[0];
        ManagedAccesoSistema bean = (ManagedAccesoSistema) Util.getSessionBean("ManagedAccesoSistema");
        String codUsuario = bean.getUsuarioModuloBean().getCodUsuarioGlobal();
        System.out.println("codUsuario=" + codUsuario);
        /*String fechaFinal=programaProduccionbean.getFechaFinal();
        String fechaFinalVector[]=fechaFinal.split("/");
        fechaFinal=fechaFinalVector[2]+"/"+fechaFinalVector[1]+"/"+fechaFinalVector[0];*/
        try {
            String sql = "insert into APROBACION_SOLICITUDES_MANTENIMIENTO(COD_SOLICITUD_MANTENIMIENTO,COD_PERSONAL_RESPONSABLE,COD_ESTADO_SOLICITUD_MANTENIMIENTO,";
            sql += " FECHA_CAMBIO_ESTADOSOLICITUD,OBS_SOLICITUD_MANTENIMIENTO)values(";
            sql += " '" + codigo + "','" + aprobacionSolicitudMantenimientobean.getPersonal_ejecutante().getCodPersonal() + "',";
            sql += " '" + aprobacionSolicitudMantenimientobean.getEstadoSolicitudMantenimiento().getCodEstadoSolicitudMantenimiento() + "',";
            sql += " '" + fechaEmision + "','" + aprobacionSolicitudMantenimientobean.getObsAprobSolicitudMantenimiento() + "')";
            System.out.println("insert APROBACION_SOLICITUDES_MANTENIMIENTO:" + sql);
            setCon(Util.openConnection(getCon()));
            PreparedStatement st = getCon().prepareStatement(sql);
            int result = st.executeUpdate();

            /*sql=" update SOLICITUDES_MANTENIMIENTO set ";
            sql+=" COD_ESTADO_SOLICITUD_MANTENIMIENTO='"+aprobacionSolicitudMantenimientobean.getEstadoSolicitudMantenimiento().getCodEstadoSolicitudMantenimiento()+"',";
            sql+=" OBS_SOLICITUD_MANTENIMIENTO='"+aprobacionSolicitudMantenimientobean.getObsAprobSolicitudMantenimiento()+"',";
            sql+=" COD_RESPONSABLE='"+aprobacionSolicitudMantenimientobean.getPersonal_ejecutante().getCodPersonal()+"'";
            sql+=" where COD_SOLICITUD_MANTENIMIENTO='"+codigo+"'";
            System.out.println("insert update SOLICITUDES_MANTENIMIENTO:"+sql);
            st=getCon().prepareStatement(sql);
            result=st.executeUpdate();*/


            System.out.println("result:" + result);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        //getCargarProgramaProduccion1();

        getCargarSolicitudMantenimiento();
        return "navegadorAprobSolicitudMantenimiento";
    }

    public String actionEditar() {
        ManagedAccesoSistema bean1 = (ManagedAccesoSistema) Util.getSessionBean("ManagedAccesoSistema");
        clearSolicitudMantenimiento();
        cargarAreasEmpresa("", null);
        cargarTiposSolicitud("", null);
        cargarGestiones("", null);
        cargarMaquinarias("", null,bean1);
        Iterator i = solicitudMantenimientoList.iterator();
        while (i.hasNext()) {

            SolicitudMantenimiento bean = (SolicitudMantenimiento) i.next();
            System.out.println("objeto iterato" + bean.getCodSolicitudMantenimiento()
                    + bean.getChecked().booleanValue());
            if (bean.getChecked().booleanValue()) {
                System.out.println("se encontro el objeto de solicitud mantenimiento");
                solicitudMantenimientobean = bean;
            }
        }        
        

        return "actionEditSolicitudMantenimiento";
    }

    public String eliminarAprobsolicitud() {
        try {
            Iterator i = aprobacionSolicitudMantList.iterator();
            while (i.hasNext()) {
                AprobacionSolicitudMantenimiento bean = (AprobacionSolicitudMantenimiento) i.next();
                if (bean.getChecked().booleanValue()) {
                    String sql_del = " delete from APROBACION_SOLICITUDES_MANTENIMIENTO where COD_SOLICITUD_MANTENIMIENTO='" + codigo + "'";
                    sql_del += " and COD_PERSONAL_RESPONSABLE='" + bean.getPersonal_ejecutante().getCodPersonal() + "'";
                    sql_del += " and COD_ESTADO_SOLICITUD_MANTENIMIENTO='" + bean.getEstadoSolicitudMantenimiento().getCodEstadoSolicitudMantenimiento() + "'";
                    System.out.println("delete SOLICITUDES_MANTENIMIENTO:" + sql_del);
                    setCon(Util.openConnection(getCon()));
                    PreparedStatement st = getCon().prepareStatement(sql_del);
                    int result = st.executeUpdate();
                    System.out.println("result delte:" + result);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        cargarNavegadorAprobarSolicitud();
        return "";
    }

    public String eliminarSolicitudMantenimiento() {
        try {
            Iterator i = solicitudMantenimientoList.iterator();
            while (i.hasNext()) {
                SolicitudMantenimiento bean = (SolicitudMantenimiento) i.next();
                if (bean.getChecked().booleanValue()) {                    
                    String sql_del = " delete from SOLICITUDES_MANTENIMIENTO_MATERIALES where COD_SOLICITUD_MANTENIMIENTO='" + bean.getCodSolicitudMantenimiento() + "'";
                    setCon(Util.openConnection(getCon()));
                    PreparedStatement st = getCon().prepareStatement(sql_del);
                    int result = st.executeUpdate();
                    sql_del = " delete from SOLICITUDES_MANTENIMIENTO_TRABAJOS where COD_SOLICITUD_MANTENIMIENTO='" + bean.getCodSolicitudMantenimiento() + "'";
                    
                    st = getCon().prepareStatement(sql_del);
                    result = st.executeUpdate();
                    sql_del = " delete from SOLICITUDES_MANTENIMIENTO where COD_SOLICITUD_MANTENIMIENTO='" + bean.getCodSolicitudMantenimiento() + "'";
                    System.out.println("delete SOLICITUDES_MANTENIMIENTO:" + sql_del);
                    
                    st = getCon().prepareStatement(sql_del);
                    result = st.executeUpdate();
                    
                    System.out.println("result delte:" + result);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        cargarNavegadorAprobarSolicitud();
        return "";
    }

    public String guardarEditarSolicitudMantenimiento() {
        System.out.println("aqui entro-------------------");
        System.out.println("aqui entro-------------------");
        //getCodigoSolicitud();
        System.out.println("codigo:" + solicitudMantenimientobean.getCodSolicitudMantenimiento());

        
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
        

        /*String fechaFinal=programaProduccionbean.getFechaFinal();
        String fechaFinalVector[]=fechaFinal.split("/");
        fechaFinal=fechaFinalVector[2]+"/"+fechaFinalVector[1]+"/"+fechaFinalVector[0];*/
        try {

//            String sql_del = " delete from SOLICITUDES_MANTENIMIENTO where COD_SOLICITUD_MANTENIMIENTO='" + solicitudMantenimientobean.getCodSolicitudMantenimiento() + "'";
//            System.out.println("delete SOLICITUDES_MANTENIMIENTO:" + sql_del);
//            setCon(Util.openConnection(getCon()));
//            PreparedStatement st = getCon().prepareStatement(sql_del);
//            int result = st.executeUpdate();

            String sql = "insert into SOLICITUDES_MANTENIMIENTO(COD_SOLICITUD_MANTENIMIENTO,COD_AREA_EMPRESA,COD_GESTION,COD_PERSONAL,COD_MAQUINARIA,COD_TIPO_SOLICITUD_MANTENIMIENTO,";
            sql += " COD_ESTADO_SOLICITUD_MANTENIMIENTO,FECHA_SOLICITUD_MANTENIMIENTO,OBS_SOLICITUD_MANTENIMIENTO)values(";
            sql += " '" + solicitudMantenimientobean.getCodSolicitudMantenimiento() + "','" + solicitudMantenimientobean.getAreasEmpresa().getCodAreaEmpresa() + "',";
            sql += " '" + solicitudMantenimientobean.getGestiones().getCodGestion() + "','" + solicitudMantenimientobean.getPersonal_usuario().getCodPersonal() + "',";
            sql += " '" + solicitudMantenimientobean.getMaquinaria().getCodMaquina() + "','" + solicitudMantenimientobean.getTiposSolicitudMantenimiento().getCodTipoSolicitud()+ "',";
            sql += " 4,'" + sdf.format(solicitudMantenimientobean.getFechaSolicitudMantenimiento()) + "','" + solicitudMantenimientobean.getObsSolicitudMantenimiento() + "')";

            sql=" UPDATE SOLICITUDES_MANTENIMIENTO " +
                    " SET  COD_GESTION = '" + solicitudMantenimientobean.getGestiones().getCodGestion() + "',   COD_TIPO_SOLICITUD_MANTENIMIENTO = '" + solicitudMantenimientobean.getTiposSolicitudMantenimiento().getCodTipoSolicitud()+ "', " +
                    " COD_AREA_EMPRESA = '" + solicitudMantenimientobean.getAreasEmpresa().getCodAreaEmpresa() + "', " +
                    " FECHA_SOLICITUD_MANTENIMIENTO = '"+sdf.format(solicitudMantenimientobean.getFechaSolicitudMantenimiento())+"',   OBS_SOLICITUD_MANTENIMIENTO = '" + solicitudMantenimientobean.getObsSolicitudMantenimiento() + "',  " +
                    " COD_MAQUINARIA = '"+solicitudMantenimientobean.getMaquinaria().getCodMaquina()+"'  " +
                    " WHERE COD_SOLICITUD_MANTENIMIENTO = '"+solicitudMantenimientobean.getCodSolicitudMantenimiento()+"' ";
            
            System.out.println("insert SOLICITUDES_MANTENIMIENTO:" + sql);
            //setCon(Util.openConnection(getCon()));
            PreparedStatement st = getCon().prepareStatement(sql);
            st = getCon().prepareStatement(sql);
            int result = st.executeUpdate();


            System.out.println("result delte:" + result);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        //getCargarProgramaProduccion1();
        getCargarSolicitudMantenimiento();
        return "navegadorSolicitudMantenimiento";
    }

    public void clearSolicitudMantenimiento() {
        SolicitudMantenimiento x = new SolicitudMantenimiento();
        solicitudMantenimientobean = x;
        gestionesList.clear();
        areasEmpresaList.clear();
        maquinariasList.clear();
        tiposSolicitudMantenimientoList.clear();
        estadosSolicitudMantenimientoList.clear();
    }

    public String verTrabajosSolicitudMantenimiento_action(){
        try {
            solicitudMantenimientoItem = (SolicitudMantenimiento)solicitudMantenimientoDataTable.getRowData();

             ExternalContext externalContext = FacesContext.getCurrentInstance().getExternalContext();
            Map<String, Object> sessionMap = externalContext.getSessionMap();
            sessionMap.put("solicitudMantenimiento", solicitudMantenimientoItem);



            this.redireccionar("navegador_solicitud_mantenimiento_detalle_tareas.jsf");

            //this.cargarTareasMantenimiento();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

     public String verTipoMantenimiento_action(){
        try {
            solicitudMantenimientoItem = (SolicitudMantenimiento)solicitudMantenimientoDataTable.getRowData();

            ExternalContext externalContext = FacesContext.getCurrentInstance().getExternalContext();
            Map<String, Object> sessionMap = externalContext.getSessionMap();
            sessionMap.put("solicitudMantenimiento", solicitudMantenimientoItem);



            this.redireccionar("navegador_solicitud_mantenimiento_detalle_tareas.jsf");

            //this.cargarTareasMantenimiento();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

//    public String cargarTareasMantenimiento(){
//        try {
//            String consulta = " SELECT S.COD_SOLICITUD_MANTENIMIENTO,S.COD_TAREA_SOLICITUD_MANTENIMIENTO,S.OBSERVACION,t.NOMBRE_TAREA_SOLICITUD_MANTENIMIENTO,S.OBSERVACION " +
//                    " FROM SOLICITUDES_MANTENIMIENTO_DETALLE_TAREAS S inner join TIPOS_TAREA_SOLICITUD_MANTENIMIENTO t " +
//                    " on s.COD_TAREA_SOLICITUD_MANTENIMIENTO   = t.COD_TAREA_SOLICITUD_MANTENIMIENTO " +
//                    " WHERE S.COD_SOLICITUD_MANTENIMIENTO='"+itemSolicitudMantenimiento.getCodSolicitudMantenimiento()+"' ";
//                    System.out.println("consulta" + consulta);
//            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
//            ResultSet rs = st.executeQuery(consulta);
//            solicitudMantenimientoDetalleTareasList.clear();
//            while(rs.next()){
//                SolicitudMantenimientoDetalleTareas solicitudMantenimientoDetalleTareas = new SolicitudMantenimientoDetalleTareas();
//                solicitudMantenimientoDetalleTareas.getSolicitudMantenimiento().setCodSolicitudMantenimiento(rs.getString("COD_SOLICITUD_MANTENIMIENTO"));
//                solicitudMantenimientoDetalleTareas.getTiposTareaSolicitudMantenimiento().setCodTareaSolicitudMantenimiento(rs.getInt("COD_TAREA_SOLICITUD_MANTENIMIENTO"));
//                solicitudMantenimientoDetalleTareas.getTiposTareaSolicitudMantenimiento().setNombreTareaSolicitudMantenimiento(rs.getString("NOMBRE_TAREA_SOLICITUD_MANTENIMIENTO"));
//                solicitudMantenimientoDetalleTareas.setObservacion(rs.getString("OBSERVACION"));
//                solicitudMantenimientoDetalleTareasList.add(solicitudMantenimientoDetalleTareas);
//            }
//
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return null;
//    }
//    public String agregarTareasSolicitudMantenimiento_action(){
//        try {
//            solicitudesMantenimientoDetalleTareas = new SolicitudMantenimientoDetalleTareas();
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return null;
//    }

    public void cargarTiposTareasSolicitudMantenimiento(){
        try {
            String consulta = " select t.COD_TAREA_SOLICITUD_MANTENIMIENTO,t.NOMBRE_TAREA_SOLICITUD_MANTENIMIENTO from TIPOS_TAREA_SOLICITUD_MANTENIMIENTO t where t.COD_ESTADO_REGISTRO = 1 ";
            System.out.println("consulta" + consulta);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(consulta);
            tiposTareaSolicitudMantenimientoList.clear();
            while(rs.next()){
                TiposTareaSolicitudMantenimiento tiposTareaSolicitudMantenimientoItem = new TiposTareaSolicitudMantenimiento();
                tiposTareaSolicitudMantenimientoItem.setCodTareaSolicitudMantenimiento(rs.getInt("COD_TAREA_SOLICITUD_MANTENIMIENTO"));
                tiposTareaSolicitudMantenimientoItem.setNombreTareaSolicitudMantenimiento(rs.getString("NOMBRE_TAREA_SOLICITUD_MANTENIMIENTO"));
                
                tiposTareaSolicitudMantenimientoList.add(new SelectItem(rs.getInt("COD_TAREA_SOLICITUD_MANTENIMIENTO"),rs.getString("NOMBRE_TAREA_SOLICITUD_MANTENIMIENTO")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public void cargarTiposSolicitudMantenimiento() {
        try {
            setCon(Util.openConnection(getCon()));
            String sql = " select t.COD_TIPO_SOLICITUD,t.NOMBRE_TIPO_SOLICITUD  from TIPOS_SOLICITUD_MANTENIMIENTO t order by t.NOMBRE_TIPO_SOLICITUD ";
            
            System.out.println(" sql:" + sql);
            ResultSet rs = null;
            Statement st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            
                tiposSolicitudMantenimientoList.clear();
                rs = st.executeQuery(sql);                
                while (rs.next()) {
                    tiposSolicitudMantenimientoList.add(new SelectItem(rs.getString("COD_TIPO_SOLICITUD"), rs.getString("NOMBRE_TIPO_SOLICITUD")));
                }
            
            if (rs != null) {
                rs.close();
                st.close();
                rs = null;
                st = null;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public List cargarTiposNivelSolicitudMantenimiento() {
        List tiposNivelSolicitudMantenimientoList = new ArrayList();
        try {
            setCon(Util.openConnection(getCon()));
            String sql = " select t.COD_NIVEL_SOLICITUD_MANTENIMIENTO,t.NOMBRE_NIVEL_SOLICITUD_MANTENIMIENTO " +
                    " from TIPOS_NIVEL_SOLICITUD_MANTENIMIENTO t ";
            System.out.println(" sql:" + sql);
            ResultSet rs = null;
            Statement st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

                tiposNivelSolicitudMantenimientoList.clear();
                rs = st.executeQuery(sql);
                while (rs.next()) {
                    tiposNivelSolicitudMantenimientoList.add(new SelectItem(rs.getString("COD_NIVEL_SOLICITUD_MANTENIMIENTO"), rs.getString("NOMBRE_NIVEL_SOLICITUD_MANTENIMIENTO")));
                }

            if (rs != null) {
                rs.close();
                st.close();
                rs = null;
                st = null;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tiposNivelSolicitudMantenimientoList;
    }

    public String guardarEdicionTipoSolicitudMantenimiento_action(){
        try {
            con=Util.openConnection(con);


            String consulta = " UPDATE SOLICITUDES_MANTENIMIENTO " +
                    " SET COD_TIPO_SOLICITUD_MANTENIMIENTO = '"+solicitudMantenimientoItem.getTiposSolicitudMantenimiento().getCodTipoSolicitud()+"' " +
                    " WHERE COD_SOLICITUD_MANTENIMIENTO = '"+solicitudMantenimientoItem.getCodSolicitudMantenimiento()+"'  ";
             System.out.println("consulta" + consulta);
             Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
             st.executeUpdate(consulta);
             this.getCargarSolicitudMantenimiento();             

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public String editarTipoSolicitudMantenimiento_action(){
        try {
             solicitudMantenimientoItem = (SolicitudMantenimiento)solicitudMantenimientoDataTable.getRowData();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
    
    public String cerrarSolicitudMantenimiento_action(){
        try {
            Iterator i = solicitudMantenimientoList.iterator();
            SolicitudMantenimiento solicitudMantenimiento = new SolicitudMantenimiento();
            while(i.hasNext()){
                 solicitudMantenimiento= (SolicitudMantenimiento)i.next();
                if(solicitudMantenimiento.getChecked().booleanValue()==true){
                    break;
                }
            }
            Connection con = null;
            con = Util.openConnection(con);
            Statement st = con.createStatement();
            String consulta = "update solicitudes_mantenimiento set cod_estado_solicitud_mantenimiento = 9 where cod_solicitud_mantenimiento= '"+solicitudMantenimiento.getCodSolicitudMantenimiento()+"'";
            System.out.println("consulta " + consulta);
            st.executeUpdate(consulta);
            st.close();
            con.close();
            solicitudMantenimientoList = this.cargarAprobarSolicitudMantenimiento();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public void notificarCorreo(SolicitudMantenimiento solicitudMantenimiento){
        try {
            String contenido = " <table  align='center' width='60%' style='text-align:left' style = 'font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 10px;border : solid #f2f2f2 1px;' cellpadding='0' cellspacing='0'>" +
                    " <tr class='tablaFiltroReporte'>" +
                    " <td  align='center' class='bordeNegroTd' width='20%'><b>Nro OT</b></td>" +
                    " <td  align='center' class='bordeNegroTd' >"+solicitudMantenimiento.getNroOrdenTrabajo()+"</td>" +
                    " <td  align='center' class='bordeNegroTd' width='20%'><b>Tipo de Orden</b></td>" +
                    " <td  align='center' class='bordeNegroTd' >"+solicitudMantenimiento.getTiposSolicitudMantenimiento().getNombreTipoSolicitud()+"</td>" +
                    " </tr>" +
                    " <tr class='tablaFiltroReporte'>" +
                    " <td  align='center' class='bordeNegroTd' ><b>Planta:</b></td>" +
                    " <td  align='center' class='bordeNegroTd' ></td>" +
                    " <td  align='center' class='bordeNegroTd' ><b>Afecta Produccion</b></td>" +
                    " <td  align='center' class='bordeNegroTd' >"+(solicitudMantenimiento.getAfectaraProduccion()==1?"SI":"NO")+"</td>" +
                    " </tr>" +
                    " <tr class='tablaFiltroReporte'>" +
                    " <td  align='center' class='bordeNegroTd' ><b>Area:</b></td>" +
                    " <td  align='center' class='bordeNegroTd' >"+solicitudMantenimiento.getAreasEmpresa().getNombreAreaEmpresa()+"</td>" +
                    " <td  align='center' class='bordeNegroTd' ><b>Usuario:</b></td>" +
                    " <td  align='center' class='bordeNegroTd' >"+solicitudMantenimiento.getPersonal_usuario().getNombrePersonal() +"</td>" +
                    " </tr> " +
                    " <tr class='tablaFiltroReporte'>" +
                    " <td  align='center' class='bordeNegroTd' ><b>Emision:</b></td>" +
                    " <td  align='center' class='bordeNegroTd' >"+solicitudMantenimiento.getFechaSolicitudMantenimiento()+"</td>" +
                    " <td  align='center' class='bordeNegroTd' ><b>Aprobacion:</b></td>" +
                    " <td  align='center' class='bordeNegroTd' >"+solicitudMantenimiento.getFechaCambioEstadoSolicitud()+"</td>" +
                    " </tr> <tr class='tablaFiltroReporte'>" +
                    " <td  align='center' class='bordeNegroTd' ><b>Area Instalacion:</b></td>" +
                    " <td  align='center' class='bordeNegroTd' >"+solicitudMantenimiento.getAreasInstalaciones().getNombreAreaInstalacion()+"</td>" +
                    " <td  align='center' class='bordeNegroTd' ><b>Modulo Instalacion:</b></td>" +
                    " <td  align='center' class='bordeNegroTd' >"+solicitudMantenimiento.getAreasInstalacionesModulos().getCodigo()+"</td>" +
                    " </tr>" +
                    " <tr class='tablaFiltroReporte'>" +
                    " <td  align='center' class='bordeNegroTd' ><b>Maquinaria:</b></td>" +
                    " <td  align='center' class='bordeNegroTd' >"+solicitudMantenimiento.getMaquinaria().getNombreMaquina()+"</td>" +
                    " <td  align='center' class='bordeNegroTd' ><b>Parte Maquina:</b></td>" +
                    " <td  align='center' class='bordeNegroTd' >"+solicitudMantenimiento.getPartesMaquinaria().getNombreParteMaquina()+"</td>" +
                    "</tr>" +
                    " <tr class='tablaFiltroReporte'>" +
                    " <td  align='center' class='bordeNegroTd' ><b>Codigo:</b></td>" +
                    " <td  align='center' class='bordeNegroTd' >"+solicitudMantenimiento.getMaquinaria().getCodigo()+"</td>" +
                    " <td  align='center' class='bordeNegroTd' ><b>Nivel de Ejecucion:</b></td>" +
                    " <td  align='center' class='bordeNegroTd' >"+solicitudMantenimiento.getEstadoSolicitudMantenimiento().getNombreEstadoSolicitudMantenimiento()+"</td>" +
                    " </tr> </table> ";
            System.out.println(contenido);
            Util.enviarCorreo("1479", contenido, "La orden de Trabajo Nro:"+solicitudMantenimiento.getNroOrdenTrabajo()+" se cerro", "Notificacion");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public String enviarCorreoPrueba_action(){
        try {
            DecimalFormat formato=null;
            NumberFormat numeroformato = NumberFormat.getNumberInstance(Locale.ENGLISH);
            formato = (DecimalFormat) numeroformato;
            formato.applyPattern("###0.00;(###0.00)");
            DateTime fechaInicio1= new DateTime();
            DateTime fechaFinal1 = new DateTime();
            fechaInicio1= fechaInicio1.minusDays(2);
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
            SimpleDateFormat sdf1 = new SimpleDateFormat("dd/MM/yyyy");
            String consulta = " select p.COD_LOTE_PRODUCCION,segui.horas_hombre,segui.unidades_producidas,segui.unidades_producidas_extra,segui.horas_maquina,cp1.nombre_prod_semiterminado,envAPT.cantidadEnviada" +
                    " from programa_produccion p inner join componentes_prod cp1 on cp1.cod_compprod = p.cod_compprod " +
                    " cross apply (select sum(datediff(second, s.FECHA_INICIO, s.FECHA_FINAL) / 60.0 / 60.0) horas_hombre,sum(s.UNIDADES_PRODUCIDAS) unidades_producidas,sum(s.UNIDADES_PRODUCIDAS_EXTRA) unidades_producidas_extra,sum(sppr.horas_maquina) horas_maquina" +
                    " from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL s" +
                    " inner join SEGUIMIENTO_PROGRAMA_PRODUCCION sppr on" +
                    " sppr.COD_COMPPROD = s.COD_COMPPROD " +
                    " and sppr.COD_FORMULA_MAESTRA = s.COD_FORMULA_MAESTRA" +
                    " and sppr.COD_LOTE_PRODUCCION = s.COD_LOTE_PRODUCCION" +
                    " and sppr.COD_TIPO_PROGRAMA_PROD = s.COD_TIPO_PROGRAMA_PROD" +
                    "              and sppr.COD_PROGRAMA_PROD =  s.COD_PROGRAMA_PROD" +
                    "              and sppr.COD_ACTIVIDAD_PROGRAMA = s.COD_ACTIVIDAD_PROGRAMA" +
                    "              inner join ACTIVIDADES_FORMULA_MAESTRA afm on" +
                    "              afm.COD_ACTIVIDAD_FORMULA = s.COD_ACTIVIDAD_PROGRAMA and" +
                    "              afm.COD_FORMULA_MAESTRA = s.COD_FORMULA_MAESTRA and" +
                    "              afm.COD_ESTADO_REGISTRO = 1" +
                    "              inner join ACTIVIDADES_PRODUCCION ap on ap.COD_ACTIVIDAD = afm.COD_ACTIVIDAD and ap.COD_ESTADO_REGISTRO = 1" +
                    "              inner join personal p1 on p1.COD_PERSONAL = s.COD_PERSONAL and p1.COD_ESTADO_PERSONA = 1" +
                    "              where s.FECHA_INICIO between '"+sdf.format(fechaInicio1.toDate())+" 00:00:00' and  '"+sdf.format(fechaFinal1.toDate())+" 23:59:59'" +
                    "		       and s.FECHA_FINAL between '"+sdf.format(fechaInicio1.toDate())+" 00:00:00' and '"+sdf.format(fechaFinal1.toDate())+" 23:59:59'" +
                    "              and s.COD_LOTE_PRODUCCION = p.COD_LOTE_PRODUCCION and" +
                    "              s.COD_TIPO_PROGRAMA_PROD = p.COD_TIPO_PROGRAMA_PROD and" +
                    "              s.COD_COMPPROD = p.COD_COMPPROD and" +
                    "               s.COD_PROGRAMA_PROD = p.COD_PROGRAMA_PROD and" +
                    "               s.COD_FORMULA_MAESTRA = p.COD_FORMULA_MAESTRA) segui" +
                    " cross apply (select SUM(sd.CANT_TOTAL_SALIDADETALLEACOND) as cantidadEnviada"+
                    " from SALIDAS_ACOND sa inner join SALIDAS_DETALLEACOND sd on"+
                    " sa.COD_SALIDA_ACOND=sd.COD_SALIDA_ACOND"+
                    " where sa.COD_ALMACEN_VENTA in (select av.COD_ALMACEN_VENTA from ALMACENES_VENTAS av where av.COD_AREA_EMPRESA=1)"+
                    " and sd.COD_LOTE_PRODUCCION=p.cod_lote_produccion and sd.COD_COMPPROD=p.cod_compprod and "+
                    " sa.COD_ESTADO_SALIDAACOND not in (2)) envAPT" +
                    " where p.COD_TIPO_PROGRAMA_PROD = 1 and p.COD_LOTE_PRODUCCION " +
                    " in (select distinct sp.COD_LOTE_PRODUCCION " +
                    " from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sp where sp.FECHA_INICIO" +
                    " between '"+sdf.format(fechaInicio1.toDate())+" 00:00:00' and '"+sdf.format(fechaFinal1.toDate())+" 23:59:59'" +
                    " and sp.FECHA_FINAL between '"+sdf.format(fechaInicio1.toDate())+" 00:00:00' and '"+sdf.format(fechaFinal1.toDate())+" 23:59:59') and segui.horas_hombre >0 order by p.cod_lote_produccion";
            System.out.println("consulta " + consulta);
            Connection con = null;
            con = Util.openConnection(con);
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery(consulta);
            String mensajeCorreo =
                    " Ingeniero:<br/> Se registro la siguiente informacion de seguimiento a programa de produccion con fechas desde "+sdf1.format(fechaInicio1.toDate())+" hasta  "+sdf1.format(fechaFinal1.toDate())+":<br/> "  +
                    "<table  align='center' width='60%' style='text-align:left' style = 'font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 10px;border : solid #f2f2f2 1px;' cellpadding='0' cellspacing='0'>";
            mensajeCorreo += " <tr class='tablaFiltroReporte'>" +
                            " <th  align='center' style='border : solid #f2f2f2 1px;' >PRODUCTO</th>" +
                            " <th  align='center' style='border : solid #f2f2f2 1px;' >LOTE PRODUCCION</th>" +
                            " <th  align='center' style='border : solid #f2f2f2 1px;' >HORAS HOMBRE</th>" +
                            " <th  align='center' style='border : solid #f2f2f2 1px;' >HORAS MAQUINA</th>" +
                            " <th  align='center' style='border : solid #f2f2f2 1px;' >UNIDADES PRODUCIDAS</th>" +
                            " <th  align='center' style='border : solid #f2f2f2 1px;' >UNIDADES PRODUCIDAS EXTRA</th>" +
                            " </tr>";
            while(rs.next()){
                mensajeCorreo += 
                    " <tr class='tablaFiltroReporte'>" +
                    " <td  align='left' style='border : solid #f2f2f2 1px;' >"+rs.getString("nombre_prod_semiterminado")+"</td>" +
                    " <td  align='center' style='border : solid #f2f2f2 1px;' >"+rs.getString("cod_lote_produccion")+"</td>" +
                    " <td  align='center' style='border : solid #f2f2f2 1px;' >"+formato.format(rs.getDouble("horas_hombre"))+"</td>" +
                    " <td  align='center' style='border : solid #f2f2f2 1px;' >"+formato.format(rs.getDouble("horas_maquina"))+"</td>" +
                    " <td  align='center' style='border : solid #f2f2f2 1px;' >"+formato.format(rs.getDouble("cantidadEnviada"))+"</td>" +
                    " <td  align='center' style='border : solid #f2f2f2 1px;' >"+formato.format(rs.getDouble("unidades_producidas_extra"))+"</td>" +
                    "</tr>";
            }
            mensajeCorreo +="</table><br/><br/>Sistema Atlas";
            Util.enviarCorreo("1479", mensajeCorreo, "Notificacion de seguimiento Programa Produccion", "Notificacion");

            
            

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public String registrarObservacionEstado_action(){
        try {
            Iterator i = solicitudMantenimientoList.iterator();
           while(i.hasNext()){
               solicitudMantenimientoItem = (SolicitudMantenimiento) i.next();
           }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public String anularSolicitudMantenimiento_action(){
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
            Iterator i = solicitudMantenimientoList.iterator();
            while(i.hasNext()){
                SolicitudMantenimiento solicitudesMantenimientoItem = (SolicitudMantenimiento)i.next();
                if(solicitudesMantenimientoItem.getChecked().booleanValue()==true){
                     String consulta = " UPDATE SOLICITUDES_MANTENIMIENTO " +
                    " SET COD_ESTADO_SOLICITUD_MANTENIMIENTO = '3' ,descripcion_estado = '"+solicitudMantenimientoItem.getDescripcionEstado()+"'" +
                    " WHERE COD_SOLICITUD_MANTENIMIENTO = '"+solicitudesMantenimientoItem.getCodSolicitudMantenimiento()+"' " ;

                    System.out.println("consulta" + consulta);
                    con=Util.openConnection(con);
                    Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    st.executeUpdate(consulta);
                    this.getCargarSolicitudMantenimiento();
                    break;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }


     public String maquinaria_change(){
        try {
            //System.out.println("ente" + valorAsignado);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
     private void cargarAreasEmpresaBuscador()
    {
        try
        {
            ManagedAccesoSistema user=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
            String consulta=(user.getCodAreaEmpresaGlobal().equals("86")?
                " select ae.COD_AREA_EMPRESA,ae.NOMBRE_AREA_EMPRESA from AREAS_EMPRESA ae order by ae.NOMBRE_AREA_EMPRESA":
                " select ae.cod_area_empresa,ae.nombre_area_empresa from areas_empresa ae inner join USUARIOS_AREA_PRODUCCION u on ae.cod_area_empresa ="+
                " u.cod_area_empresa where u.cod_personal = '"+user.getUsuarioModuloBean().getCodUsuarioGlobal()+"' order by ae.NOMBRE_AREA_EMPRESA");
            Connection con1=null;
            con1=Util.openConnection(con1);
            Statement st=con1.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta);
            areasEmpresaBuscadorList.clear();
            areasEmpresaBuscadorList.add(new SelectItem("0","-TODOS-"));
            while(res.next())
            {
                areasEmpresaBuscadorList.add(new SelectItem(res.getString("COD_AREA_EMPRESA"),res.getString("NOMBRE_AREA_EMPRESA")));
            }
            res.close();
            st.close();
            con1.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }

    }
//   public String registrarTareasSolicitudMantenimiento_action(){
//        try {
//            con=Util.openConnection(con);
//               String consulta = " INSERT INTO SOLICITUDES_MANTENIMIENTO_DETALLE_TAREAS( COD_SOLICITUD_MANTENIMIENTO, COD_TAREA_SOLICITUD_MANTENIMIENTO, OBSERVACION) " +
//                       "VALUES ( "+itemSolicitudMantenimiento.getCodSolicitudMantenimiento()+", "+ solicitudesMantenimientoDetalleTareas.getTiposTareaSolicitudMantenimiento().getCodTareaSolicitudMantenimiento() +", '"+solicitudesMantenimientoDetalleTareas.getObservacion()+"' ); ";
//
//
//               System.out.println("consulta" + consulta);
//
//               Statement st = con.createStatement();
//               st.executeUpdate(consulta);
//               this.cargarTareasMantenimiento();
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return null;
//    }


//   public String editarTareasSolicitudMantenimiento_action(){
//        try {
//            Iterator i = solicitudMantenimientoDetalleTareasList.iterator();
//            while(i.hasNext()){
//                SolicitudMantenimientoDetalleTareas solicitudesMantenimientoDetalleTareasItem = (SolicitudMantenimientoDetalleTareas)i.next();
//                if(solicitudesMantenimientoDetalleTareasItem.getChecked()==true){
//                    solicitudesMantenimientoDetalleTareas=solicitudesMantenimientoDetalleTareasItem;
//                    solicitudesMantenimientoDetalleTareasEditar.setSolicitudMantenimiento(solicitudesMantenimientoDetalleTareasItem.getSolicitudMantenimiento()) ;
//                    solicitudesMantenimientoDetalleTareasEditar.setTiposTareaSolicitudMantenimiento(solicitudesMantenimientoDetalleTareasItem.getTiposTareaSolicitudMantenimiento());
//                }
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return null;
//    }

//   public String guardarEdicionTareasSolicitudMantenimiento_action(){
//        try {
//            String consulta = " UPDATE SOLICITUDES_MANTENIMIENTO_DETALLE_TAREAS  " +
//                    " SET  COD_TAREA_SOLICITUD_MANTENIMIENTO = '"+solicitudesMantenimientoDetalleTareas.getTiposTareaSolicitudMantenimiento().getCodTareaSolicitudMantenimiento()+"'," +
//                    "  OBSERVACION = '"+solicitudesMantenimientoDetalleTareas.getObservacion()+"' " +
//                    " WHERE COD_SOLICITUD_MANTENIMIENTO = '"+solicitudesMantenimientoDetalleTareasEditar.getSolicitudMantenimiento().getCodSolicitudMantenimiento()+"' " +
//                    " AND  COD_TAREA_SOLICITUD_MANTENIMIENTO = '"+ solicitudesMantenimientoDetalleTareasEditar.getTiposTareaSolicitudMantenimiento().getCodTareaSolicitudMantenimiento() +"'" ;
//             System.out.println("consulta" + consulta);
//
//             Statement st = con.createStatement();
//             st.executeUpdate(consulta);
//
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return null;
//    }




    /*
    private String codigos="";
    private String fecha_inicio="";
    private String fecha_final="";
    
    public void actionEliminar(){
    setCodigos("");
    setFecha_inicio("");
    setFecha_final("");
    for(ProgramaProduccion bean:programaProduccionList){
    if(bean.getChecked().booleanValue()){
    setCodigos(getCodigos() + (""+bean.getCodProgramaProduccion()+","));
    setFecha_inicio(getFecha_inicio() + bean.getFechaInicio() + ",");
    setFecha_final(getFecha_final() + bean.getFechaFinal() + ",");
    }
    }
    
    System.out.println("codigos:"+getCodigos());
    System.out.println("fecha_inicio:"+getFecha_inicio());
    System.out.println("fecha_final:"+getFecha_final());
    
    }
    
    public String actionEditar(){
    try{
    programaProduccionEditarList.clear();
    Iterator i=programaProduccionList.iterator();
    while (i.hasNext()){
    ProgramaProduccion bean=(ProgramaProduccion)i.next();
    if(bean.getChecked().booleanValue()){
    String sqlFormaFar="select cod_forma from componentes_prod where cod_compprod="+bean.getFormulaMaestra().getComponentesProd().getCodCompprod();
    System.out.println("sqlFormaFar:"+sqlFormaFar);
    Statement stFormaFar=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
    ResultSet rsFormaFar=stFormaFar.executeQuery(sqlFormaFar);
    String formaFarmaceutica="";
    if(rsFormaFar.next()){
    formaFarmaceutica=rsFormaFar.getString(1);
    if(formaFarmaceutica.equals("2")){
    programaProduccionEditarList.add(bean);
    }
    }
    }
    }
    } catch (SQLException e) {
    e.printStackTrace();
    }
    return "actionEditarLotesProgramaProduccion";
    }
    
    public String guardarLotes(){
    try {
    setCon(Util.openConnection(getCon()));
    Iterator i=programaProduccionEditarList.iterator();
    int result=0;
    while (i.hasNext()){
    ProgramaProduccion bean=(ProgramaProduccion)i.next();
    String sql="update  PROGRAMA_PRODUCCION_DETALLE set " ;
    sql+=" cod_lote_produccion='"+bean.getCodLoteProduccion()+"'" ;
    sql+=" where COD_PROGRAMA_PROD='"+bean.getCodProgramaProduccion()+"' " ;
    sql+=" and COD_COMPPROD="+bean.getFormulaMaestra().getComponentesProd().getCodCompprod();
    sql+=" and cod_lote_produccion='"+bean.getCodLoteProduccionAnterior()+"'";
    System.out.println("PROGRAMA_PRODUCCION_DETALLE:sql:"+sql);
    Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
    result=result+st.executeUpdate(sql);
    
    sql="update PROGRAMA_PRODUCCION  set " ;
    sql+=" cod_lote_produccion='"+bean.getCodLoteProduccion()+"'" ;
    sql+=" where COD_PROGRAMA_PROD='"+bean.getCodProgramaProduccion()+"' " ;
    sql+=" and COD_COMPPROD="+bean.getFormulaMaestra().getComponentesProd().getCodCompprod();
    sql+=" and cod_lote_produccion='"+bean.getCodLoteProduccionAnterior()+"'";
    System.out.println("PROGRAMA_PRODUCCION:sql:"+sql);
    st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
    result=result+st.executeUpdate(sql);
    
    
    }
    if(result>0){
    getCargarProgramaProduccion1();
    }
    
    } catch (SQLException e) {
    e.printStackTrace();
    }
    return "navegadorProgramaProduccion";
    }
    
    
    /* public String actionEditar(){
    cargarFormulaMaestra("",null);
    clearProgramaProduccion();
    Iterator i=programaProduccionList.iterator();
    while (i.hasNext()){
    ProgramaProduccion bean=(ProgramaProduccion)i.next();
    if(bean.getChecked().booleanValue()){
    programaProduccionbean=bean;
    String fechaInicio=programaProduccionbean.getFechaInicio();
    System.out.println("fechaInicio:"+fechaInicio);
    String fechaInicioVector[]=fechaInicio.split("/");
    //fechaInicioVector=fechaInicioVector[0].split("-");
    fechaInicio=fechaInicioVector[0]+"/"+fechaInicioVector[1]+"/"+fechaInicioVector[2];
    programaProduccionbean.setFechaInicio(fechaInicio);
    String fechaFinal=programaProduccionbean.getFechaFinal();
    System.out.println("fechaFinal:"+fechaFinal);
    String fechaFinalVector[]=fechaFinal.split("/");
    //fechaFinalVector=fechaFinalVector[0].split("-");
    fechaFinal=fechaFinalVector[0]+"/"+fechaFinalVector[1]+"/"+fechaFinalVector[2];
    programaProduccionbean.setFechaFinal(fechaFinal);
    break;
    }
    
    }
    formulaMaestraMPList.clear();
    formulaMaestraEPList.clear();
    formulaMaestraESList.clear();
    formulaMaestraMPROMList.clear();
    try {
    String sql=" select m.cod_material,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA,mp.CANTIDAD,um.COD_UNIDAD_MEDIDA from FORMULA_MAESTRA_DETALLE_MP mp,MATERIALES m,UNIDADES_MEDIDA um" ;
    sql+=" where  m.COD_MATERIAL=mp.cod_material and um.COD_UNIDAD_MEDIDA=m.COD_UNIDAD_MEDIDA and mp.cod_formula_maestra="+programaProduccionbean.getFormulaMaestra().getCodFormulaMaestra();
    System.out.println("sql MP:"+sql);
    setCon(Util.openConnection(getCon()));
    Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
    ResultSet rs=st.executeQuery(sql);
    while(rs.next()){
    String codMaterial=rs.getString(1);
    String nombreMaterial=rs.getString(2);
    String unidadMedida=rs.getString(3);
    String cantidad=rs.getString(4);
    String codUnidadMedida=rs.getString(5);
    FormulaMaestraDetalleMP bean=new FormulaMaestraDetalleMP();
    bean.getMateriales().setCodMaterial(codMaterial);
    bean.getMateriales().setNombreMaterial(nombreMaterial);
    bean.getUnidadesMedida().setNombreUnidadMedida(unidadMedida);
    bean.setCantidad(cantidad);
    bean.getUnidadesMedida().setCodUnidadMedida(codUnidadMedida);
    String sql_1=" select * from PROGRAMA_PRODUCCION_DETALLE pp where pp.cod_programa_prod='"+programaProduccionbean.getCodProgramaProduccion()+"' and  pp.COD_MATERIAL="+codMaterial ;
    System.out.println("sql _1:"+sql_1);
    Statement st1=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
    ResultSet rs1=st1.executeQuery(sql_1);
    int sw=0;
    while(rs1.next()){
    sw=1;
    }
    if(sw==1){
    bean.setChecked(true);
    }else{
    bean.setChecked(false);
    }
    formulaMaestraMPList.add(bean);
    }
    sql=" select m.cod_material,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA,mp.CANTIDAD,um.COD_UNIDAD_MEDIDA from FORMULA_MAESTRA_DETALLE_EP mp,MATERIALES m,UNIDADES_MEDIDA um" ;
    sql+=" where  m.COD_MATERIAL=mp.cod_material and um.COD_UNIDAD_MEDIDA=m.COD_UNIDAD_MEDIDA and mp.cod_formula_maestra="+programaProduccionbean.getFormulaMaestra().getCodFormulaMaestra();
    System.out.println("sql EP:"+sql);
    st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
    rs=st.executeQuery(sql);
    while(rs.next()){
    String codMaterial=rs.getString(1);
    String nombreMaterial=rs.getString(2);
    String unidadMedida=rs.getString(3);
    String cantidad=rs.getString(4);
    String codUnidadMedida=rs.getString(5);
    FormulaMaestraDetalleMP bean=new FormulaMaestraDetalleMP();
    bean.getMateriales().setCodMaterial(codMaterial);
    bean.getMateriales().setNombreMaterial(nombreMaterial);
    bean.getUnidadesMedida().setNombreUnidadMedida(unidadMedida);
    bean.setCantidad(cantidad);
    bean.getUnidadesMedida().setCodUnidadMedida(codUnidadMedida);
    String sql_1=" select * from PROGRAMA_PRODUCCION_DETALLE pp where pp.cod_programa_prod='"+programaProduccionbean.getCodProgramaProduccion()+"' and pp.COD_MATERIAL="+codMaterial ;
    System.out.println("sql _1:"+sql_1);
    Statement st1=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
    ResultSet rs1=st1.executeQuery(sql_1);
    int sw=0;
    while(rs1.next()){
    sw=1;
    }
    if(sw==1){
    bean.setChecked(true);
    }else{
    bean.setChecked(false);
    }
    formulaMaestraEPList.add(bean);
    }
    sql=" select m.cod_material,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA,mp.CANTIDAD,um.COD_UNIDAD_MEDIDA from FORMULA_MAESTRA_DETALLE_ES mp,MATERIALES m,UNIDADES_MEDIDA um" ;
    sql+=" where  m.COD_MATERIAL=mp.cod_material and um.COD_UNIDAD_MEDIDA=m.COD_UNIDAD_MEDIDA and mp.cod_formula_maestra="+programaProduccionbean.getFormulaMaestra().getCodFormulaMaestra();
    System.out.println("sql ES:"+sql);
    st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
    rs=st.executeQuery(sql);
    while(rs.next()){
    String codMaterial=rs.getString(1);
    String nombreMaterial=rs.getString(2);
    String unidadMedida=rs.getString(3);
    String cantidad=rs.getString(4);
    String codUnidadMedida=rs.getString(5);
    FormulaMaestraDetalleMP bean=new FormulaMaestraDetalleMP();
    bean.getMateriales().setCodMaterial(codMaterial);
    bean.getMateriales().setNombreMaterial(nombreMaterial);
    bean.getUnidadesMedida().setNombreUnidadMedida(unidadMedida);
    bean.setCantidad(cantidad);
    bean.getUnidadesMedida().setCodUnidadMedida(codUnidadMedida);
    String sql_1=" select * from PROGRAMA_PRODUCCION_DETALLE pp where pp.cod_programa_prod='"+programaProduccionbean.getCodProgramaProduccion()+"' and pp.COD_MATERIAL="+codMaterial ;
    System.out.println("sql _1:"+sql_1);
    Statement st1=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
    ResultSet rs1=st1.executeQuery(sql_1);
    int sw=0;
    while(rs1.next()){
    sw=1;
    }
    if(sw==1){
    bean.setChecked(true);
    }else{
    bean.setChecked(false);
    }
    formulaMaestraESList.add(bean);
    }
    sql=" select m.cod_material,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA,mp.CANTIDAD,um.COD_UNIDAD_MEDIDA from FORMULA_MAESTRA_DETALLE_MPROM mp,MATERIALES m,UNIDADES_MEDIDA um" ;
    sql+=" where  m.COD_MATERIAL=mp.cod_material and um.COD_UNIDAD_MEDIDA=m.COD_UNIDAD_MEDIDA and mp.cod_formula_maestra="+programaProduccionbean.getFormulaMaestra().getCodFormulaMaestra();
    System.out.println("sql MPROM:"+sql);
    st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
    rs=st.executeQuery(sql);
    while(rs.next()){
    String codMaterial=rs.getString(1);
    String nombreMaterial=rs.getString(2);
    String unidadMedida=rs.getString(3);
    String cantidad=rs.getString(4);
    String codUnidadMedida=rs.getString(5);
    FormulaMaestraDetalleMP bean=new FormulaMaestraDetalleMP();
    bean.getMateriales().setCodMaterial(codMaterial);
    bean.getMateriales().setNombreMaterial(nombreMaterial);
    bean.getUnidadesMedida().setNombreUnidadMedida(unidadMedida);
    bean.setCantidad(cantidad);
    bean.getUnidadesMedida().setCodUnidadMedida(codUnidadMedida);
    String sql_1=" select * from PROGRAMA_PRODUCCION_DETALLE pp where pp.cod_programa_prod='"+programaProduccionbean.getCodProgramaProduccion()+"' and pp.COD_MATERIAL="+codMaterial ;
    System.out.println("sql _1:"+sql_1);
    Statement st1=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
    ResultSet rs1=st1.executeQuery(sql_1);
    int sw=0;
    while(rs1.next()){
    sw=1;
    }
    if(sw==1){
    bean.setChecked(true);
    }else{
    bean.setChecked(false);
    }
    formulaMaestraMPROMList.add(bean);
    }
    } catch (SQLException e) {
    e.printStackTrace();
    }
    return "actionEditarProgramaProduccion";
    }*/

    /*  public String guardarReserva(){
    try{

    Date fechaActual=new Date();
    SimpleDateFormat f= new SimpleDateFormat("yyyy/MM/dd");
    String fecha= f.format(fechaActual);
    Iterator i=programaProduccionList.iterator();
    int result=0;
    while (i.hasNext()){
    ProgramaProduccion bean=(ProgramaProduccion)i.next();
    if(bean.getChecked().booleanValue()){
    String cod_programa_prod=bean.getCodProgramaProduccion();
    String lote=bean.getCodLoteProduccion();
    String cod_comp_prod=bean.getFormulaMaestra().getComponentesProd().getCodCompprod();
    codReserva="0";
    getCodigoReserva();
    String sql2="insert into reserva(COD_RESERVA,COD_PROGRAMA_PROD,COD_COMPPROD,COD_LOTE,FECHA_PROGRAMAPRODUCCION,ESTADO_RESERVA)";
    sql2+="values('"+codReserva+"','"+cod_programa_prod+"','"+cod_comp_prod+"','"+lote+"','"+fecha+"',0)";
    System.out.println("reserva:"+sql2);
    Statement st22=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
    int rs22=st22.executeUpdate(sql2);


    String sql4="select ppd.COD_MATERIAL,ppd.CANTIDAD,m.COD_UNIDAD_MEDIDA from PROGRAMA_PRODUCCION_DETALLE ppd,MATERIALES m";
    sql4+=" where ppd.COD_PROGRAMA_PROD in ("+cod_programa_prod+") and ppd.COD_COMPPROD='"+cod_comp_prod+"' and " +
    " ppd.COD_LOTE_PRODUCCION='"+lote+"' and m.COD_MATERIAL=ppd.COD_MATERIAL   ";
    System.out.println("sql4*****:"+sql4);
    Statement st4= getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
    ResultSet rs4 = st4.executeQuery(sql4);
    while(rs4.next()){
    String cod_material=rs4.getString(1);
    String cantidad=rs4.getString(2);
    String cod_unidad_medida=rs4.getString(3);
    System.out.println("cod_material:"+cod_material);
    sql2="insert into reserva_detalle(COD_RESERVA,COD_MATERIAL,CANTIDAD,COD_UNIDAD_MEDIDA,ESTADO_RESERVA_DETALLE)";
    sql2+="values('"+codReserva+"','"+cod_material+"','"+cantidad+"','"+cod_unidad_medida+"',0)";
    System.out.println("sql2 Detalle Reserva:"+sql2);
    st22=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
    rs22=st22.executeUpdate(sql2);
    }
    sql2="update  programa_produccion set";
    sql2+=" cod_estado_programa=5";
    sql2+=" where cod_programa_prod="+cod_programa_prod+" and COD_COMPPROD='"+cod_comp_prod+"' and " +
    " COD_LOTE_PRODUCCION='"+lote+"'";
    System.out.println("reserva update:"+sql2);
    st22=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
    rs22=st22.executeUpdate(sql2);

    }
    }
    } catch (SQLException e) {
    e.printStackTrace();
    }
    return"navegadorProgramaProduccion";
    }
    public String eliminarReserva(){
    try{


    Date fechaActual=new Date();
    SimpleDateFormat f= new SimpleDateFormat("yyyy/MM/dd");
    String fecha= f.format(fechaActual);
    Iterator i=programaProduccionList.iterator();
    int result=0;
    while (i.hasNext()){
    ProgramaProduccion bean=(ProgramaProduccion)i.next();
    if(bean.getChecked().booleanValue()){
    String cod_programa_prod=bean.getCodProgramaProduccion();
    String lote=bean.getCodLoteProduccion();
    String cod_comp_prod=bean.getFormulaMaestra().getComponentesProd().getCodCompprod();
    String sql4="select cod_reserva from reserva  ";
    sql4+=" where COD_PROGRAMA_PROD in ("+cod_programa_prod+") and COD_COMPPROD='"+cod_comp_prod+"' and COD_LOTE='"+lote+"' ";
    System.out.println("sql4*****:"+sql4);
    Statement st4= getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
    ResultSet rs4 = st4.executeQuery(sql4);
    while(rs4.next()){
    String cod_reserva=rs4.getString(1);
    String sql2="delete from reserva " ;
    sql2+=" where cod_reserva='"+cod_reserva+"'";
    System.out.println(" delete reserva:"+sql2);
    Statement st22=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
    int rs22=st22.executeUpdate(sql2);

    sql2="delete from reserva_detalle " ;
    sql2+=" where cod_reserva='"+cod_reserva+"'";
    System.out.println("delete Detalle Reserva:"+sql2);
    st22=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
    rs22=st22.executeUpdate(sql2);
    sql2="update  programa_produccion set";
    sql2+=" cod_estado_programa=2";
    sql2+=" where cod_programa_prod="+cod_programa_prod+" and COD_COMPPROD='"+cod_comp_prod+"' and " +
    " COD_LOTE_PRODUCCION='"+lote+"'";
    System.out.println("reserva update:"+sql2);
    st22=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
    rs22=st22.executeUpdate(sql2);
    }
    }
    }
    } catch (SQLException e) {
    e.printStackTrace();
    }
    return"navegadorProgramaProduccion";
    }


    public String eliminarProgProd(){
    try {
    setCon(Util.openConnection(getCon()));
    Iterator i=programaProduccionList.iterator();
    int result=0;
    while (i.hasNext()){

    //
    ProgramaProduccion bean=(ProgramaProduccion)i.next();
    if(bean.getChecked().booleanValue()){
    String sql="delete from PROGRAMA_PRODUCCION_DETALLE where COD_PROGRAMA_PROD='"+bean.getCodProgramaProduccion()+"' and COD_COMPPROD="+bean.getFormulaMaestra().getComponentesProd().getCodCompprod();
    sql+=" and cod_lote_produccion='"+bean.getCodLoteProduccion()+"'";
    System.out.println("PROGRAMA_PRODUCCION_DETALLE:sql:"+sql);
    Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
    result=result+st.executeUpdate(sql);
    sql="delete from PROGRAMA_PRODUCCION where COD_PROGRAMA_PROD='"+bean.getCodProgramaProduccion()+"' and COD_COMPPROD="+bean.getFormulaMaestra().getComponentesProd().getCodCompprod();
    sql+=" and cod_lote_produccion='"+bean.getCodLoteProduccion()+"'";
    System.out.println("PROGRAMA_PRODUCCION:sql:"+sql);
    st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
    result=result+st.executeUpdate(sql);

    String sql4="select cod_reserva from reserva  ";
    sql4+=" where COD_PROGRAMA_PROD in ("+bean.getCodProgramaProduccion()+") and COD_COMPPROD='"+bean.getFormulaMaestra().getComponentesProd().getCodCompprod()+"' and COD_LOTE='"+bean.getCodLoteProduccion()+"' ";
    System.out.println("sql4*****:"+sql4);
    Statement st4= getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
    ResultSet rs4 = st4.executeQuery(sql4);
    while(rs4.next()){
    String cod_reserva=rs4.getString(1);
    String sql2="delete from reserva " ;
    sql2+=" where cod_reserva='"+cod_reserva+"'";
    System.out.println(" delete reserva:"+sql2);
    Statement st22=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
    int rs22=st22.executeUpdate(sql2);

    sql2="delete from reserva_detalle " ;
    sql2+=" where cod_reserva='"+cod_reserva+"'";
    System.out.println("delete Detalle Reserva:"+sql2);
    st22=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
    rs22=st22.executeUpdate(sql2);

    }

    String sql_area=" select c.COD_AREA_EMPRESA from COMPONENTES_PROD c where c.COD_COMPPROD='"+bean.getFormulaMaestra().getComponentesProd().getCodCompprod()+"' ";
    System.out.println("sql_area*****:"+sql_area);
    Statement st_area= getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
    ResultSet rs_area = st_area.executeQuery(sql_area);
    String formas_farmaceuticas="";
    String area="";
    while(rs_area.next()){
    area=rs_area.getString(1);
    if(area.equals("80")){
    formas_farmaceuticas="7,10,16,17,26,29";
    }
    if(area.equals("81")){
    formas_farmaceuticas="2,25,27";
    }
    if(area.equals("82")){
    formas_farmaceuticas="1,6,8,9,15,20,30,32";
    }
    if(area.equals("95")){
    formas_farmaceuticas="11,12,31";
    }
    }
    System.out.println("area:"+area);
    String sql_reasignar="select pp.COD_COMPPROD,pp.COD_LOTE_PRODUCCION from PROGRAMA_PRODUCCION pp,COMPONENTES_PROD cp where";
    sql_reasignar+=" cp.COD_COMPPROD=pp.COD_COMPPROD and cp.COD_FORMA in ("+formas_farmaceuticas+")";
    sql_reasignar+=" and pp.COD_PROGRAMA_PROD='"+bean.getCodProgramaProduccion()+"' and pp.COD_ESTADO_PROGRAMA=2 ";
    System.out.println("sql_reasignar*****:"+sql_reasignar);
    Statement st_reasignar= getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
    ResultSet rs_reasignar = st_reasignar.executeQuery(sql_reasignar);
    int contador=0;
    while(rs_reasignar.next()){
    String codCompProd=rs_reasignar.getString(1);
    String codLoteProduccionAnterior=rs_reasignar.getString(2);
    String codLoteProduccion=codLoteProduccionAnterior;
    if(codLoteProduccion.length()==6){
    contador++;
    System.out.println("codLoteProduccion.charAt(3):"+codLoteProduccion.charAt(3));
    System.out.println("codLoteProduccion.charAt(4):"+codLoteProduccion.charAt(4));

    String concat=codLoteProduccion.charAt(3)+""+codLoteProduccion.charAt(4);


    System.out.println("concat:"+concat);
    if (Integer.parseInt(concat)!=contador){
    String contString=Integer.toString(contador);
    System.out.println("contString:"+contString+"/"+contString.charAt(0));
    if(contador>=10){
    codLoteProduccion=codLoteProduccion.charAt(0)+""+codLoteProduccion.charAt(1)+""+codLoteProduccion.charAt(2)+""+contString.charAt(0)+""+contString.charAt(1)+""+codLoteProduccion.charAt(5);
    }else{
    codLoteProduccion=codLoteProduccion.charAt(0)+""+codLoteProduccion.charAt(1)+""+codLoteProduccion.charAt(2)+"0"+contString.charAt(0)+""+codLoteProduccion.charAt(5);
    }
    System.out.println("codLoteProduccion"+codLoteProduccion);
    String sql_update=" update programa_produccion set cod_lote_produccion='"+codLoteProduccion+"' where cod_lote_produccion='"+codLoteProduccionAnterior+"'" ;
    sql_update+=" and COD_PROGRAMA_PROD='"+bean.getCodProgramaProduccion()+"' and COD_COMPPROD='"+codCompProd+"'  ";
    System.out.println("sql_update:"+sql_update);
    Statement st_update=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
    int rs_update=st_update.executeUpdate(sql_update);
    sql_update=" update programa_produccion_detalle set cod_lote_produccion='"+codLoteProduccion+"' where cod_lote_produccion='"+codLoteProduccionAnterior+"'" ;
    sql_update+=" and COD_PROGRAMA_PROD='"+bean.getCodProgramaProduccion()+"' and COD_COMPPROD='"+codCompProd+"'  ";
    System.out.println("sql_update:"+sql_update);
    st_update=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
    rs_update=st_update.executeUpdate(sql_update);
    }

    }
    }
    }
    }


    if(result>0){
    getCargarProgramaProduccion1();
    }

    } catch (SQLException e) {
    e.printStackTrace();
    }
    return "navegadorProgramaProduccion";
    }
    /* ------------------Métodos---------------------------*/
    /*  public void changeEventLote(javax.faces.event.ValueChangeEvent event){
    System.out.println("event 2:"+event.getNewValue());
    String cantidad_prod=event.getNewValue().toString();
    try {
    double cantProduccion=0;
    double cantidad_lote_formula=0;
    if(!cantidad_prod.equals("")){

    String sql_lote="  select f.CANTIDAD_LOTE from FORMULA_MAESTRA f where f.COD_FORMULA_MAESTRA='"+programaProduccionbean.getFormulaMaestra().getCodFormulaMaestra()+"'" ;

    System.out.println("sql_lote:"+sql_lote);
    setCon(Util.openConnection(getCon()));
    Statement st_lote=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
    ResultSet rs_lote=st_lote.executeQuery(sql_lote);
    cantidad_lote_formula=0;
    while(rs_lote.next()){
    cantidad_lote_formula=rs_lote.getDouble(1);
    }
    cantProduccion=Double.parseDouble(cantidad_prod);
    }

    formulaMaestraMPList.clear();
    formulaMaestraEPList.clear();
    formulaMaestraESList.clear();
    formulaMaestraMPROMList.clear();
    NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
    DecimalFormat form = (DecimalFormat)nf;
    form.applyPattern("#,###.00");
    String codFormulaMaestra=programaProduccionbean.getFormulaMaestra().getCodFormulaMaestra();


    String sql=" select m.cod_material,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA,mp.CANTIDAD,um.COD_UNIDAD_MEDIDA " +
    " from FORMULA_MAESTRA_DETALLE_MP mp,MATERIALES m,UNIDADES_MEDIDA um" ;
    sql+=" where  m.COD_MATERIAL=mp.cod_material and um.COD_UNIDAD_MEDIDA=m.COD_UNIDAD_MEDIDA and mp.cod_formula_maestra="+codFormulaMaestra;
    System.out.println("sql MP:"+sql);
    Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
    ResultSet rs=st.executeQuery(sql);
    while(rs.next()){
    String codMaterial=rs.getString(1);
    String nombreMaterial=rs.getString(2);
    String unidadMedida=rs.getString(3);
    double cantidad=rs.getDouble(4);
    //cantidad= (cantProduccion*cantidad)/cantidad_lote_formula;
    cantidad= (cantProduccion*cantidad);
    cantidad=redondear(cantidad,3);
    String codUnidadMedida=rs.getString(5);
    FormulaMaestraDetalleMP bean=new FormulaMaestraDetalleMP();
    bean.getMateriales().setCodMaterial(codMaterial);
    bean.getMateriales().setNombreMaterial(nombreMaterial);
    bean.getUnidadesMedida().setNombreUnidadMedida(unidadMedida);
    bean.setCantidad(form.format(cantidad));
    bean.getUnidadesMedida().setCodUnidadMedida(codUnidadMedida);
    bean.setChecked(true);
    formulaMaestraMPList.add(bean);
    }
    sql=" select m.cod_material,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA,mp.CANTIDAD,um.COD_UNIDAD_MEDIDA " +
    " from FORMULA_MAESTRA_DETALLE_EP mp,MATERIALES m,UNIDADES_MEDIDA um" ;
    sql+=" where  m.COD_MATERIAL=mp.cod_material and um.COD_UNIDAD_MEDIDA=m.COD_UNIDAD_MEDIDA " +
    " and mp.cod_formula_maestra="+codFormulaMaestra+" and mp.COD_PRESENTACION_PRIMARIA = '"+codPresPrim+"'";
    System.out.println("sql EP:"+sql);
    st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
    rs=st.executeQuery(sql);
    while(rs.next()){
    String codMaterial=rs.getString(1);
    String nombreMaterial=rs.getString(2);
    String unidadMedida=rs.getString(3);
    double cantidad=rs.getDouble(4);
    //cantidad= (cantProduccion*cantidad)/cantidad_lote_formula;
    cantidad= (cantProduccion*cantidad);
    cantidad=redondear(cantidad,3);
    String codUnidadMedida=rs.getString(5);
    FormulaMaestraDetalleMP bean=new FormulaMaestraDetalleMP();
    bean.getMateriales().setCodMaterial(codMaterial);
    bean.getMateriales().setNombreMaterial(nombreMaterial);
    bean.getUnidadesMedida().setNombreUnidadMedida(unidadMedida);
    bean.setCantidad(form.format(cantidad));
    bean.getUnidadesMedida().setCodUnidadMedida(codUnidadMedida);
    bean.setChecked(true);
    formulaMaestraEPList.add(bean);
    }
    sql=" select m.cod_material,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA,mp.CANTIDAD,um.COD_UNIDAD_MEDIDA " +
    " from FORMULA_MAESTRA_DETALLE_ES mp,MATERIALES m,UNIDADES_MEDIDA um" ;
    sql+=" where  m.COD_MATERIAL=mp.cod_material and um.COD_UNIDAD_MEDIDA=m.COD_UNIDAD_MEDIDA " +
    " and mp.cod_formula_maestra="+codFormulaMaestra+" and mp.COD_PRESENTACION_PRODUCTO='"+codPresProd+"'";
    System.out.println("sql ES:"+sql);
    st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
    rs=st.executeQuery(sql);
    while(rs.next()){
    String codMaterial=rs.getString(1);
    String nombreMaterial=rs.getString(2);
    String unidadMedida=rs.getString(3);
    double cantidad=rs.getDouble(4);
    //cantidad= (cantProduccion*cantidad)/cantidad_lote_formula;
    cantidad= (cantProduccion*cantidad);
    cantidad=redondear(cantidad,3);
    String codUnidadMedida=rs.getString(5);
    FormulaMaestraDetalleMP bean=new FormulaMaestraDetalleMP();
    bean.getMateriales().setCodMaterial(codMaterial);
    bean.getMateriales().setNombreMaterial(nombreMaterial);
    bean.getUnidadesMedida().setNombreUnidadMedida(unidadMedida);
    bean.setCantidad(form.format(cantidad));
    bean.getUnidadesMedida().setCodUnidadMedida(codUnidadMedida);
    bean.setChecked(true);
    formulaMaestraESList.add(bean);
    }
    sql=" select m.cod_material,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA,mp.CANTIDAD,um.COD_UNIDAD_MEDIDA from FORMULA_MAESTRA_DETALLE_MPROM mp,MATERIALES m,UNIDADES_MEDIDA um" ;
    sql+=" where  m.COD_MATERIAL=mp.cod_material and um.COD_UNIDAD_MEDIDA=m.COD_UNIDAD_MEDIDA and mp.cod_formula_maestra="+codFormulaMaestra;
    System.out.println("sql MPROM:"+sql);
    st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
    rs=st.executeQuery(sql);
    while(rs.next()){
    String codMaterial=rs.getString(1);
    String nombreMaterial=rs.getString(2);
    String unidadMedida=rs.getString(3);
    double cantidad=rs.getDouble(4);
    //cantidad= (cantProduccion*cantidad)/cantidad_lote_formula;
    cantidad= (cantProduccion*cantidad);
    cantidad=redondear(cantidad,3);
    String codUnidadMedida=rs.getString(5);
    FormulaMaestraDetalleMP bean=new FormulaMaestraDetalleMP();
    bean.getMateriales().setCodMaterial(codMaterial);
    bean.getMateriales().setNombreMaterial(nombreMaterial);
    bean.getUnidadesMedida().setNombreUnidadMedida(unidadMedida);
    bean.setCantidad(form.format(cantidad));
    bean.getUnidadesMedida().setCodUnidadMedida(codUnidadMedida);
    bean.setChecked(true);
    formulaMaestraMPROMList.add(bean);
    }
    } catch (SQLException e) {
    e.printStackTrace();
    }

    }

     */
    public double redondear(double numero, int decimales) {
        return Math.round(numero * Math.pow(10, decimales)) / Math.pow(10, decimales);
    }

    public static void main(String[] args) {
        int a1, m1, d1, a2, m2, d2;
        String fe_inicio = "05-1-2008";
        System.out.println("fe_inicio:" + fe_inicio);
        String fe_final = "05-31-2008";
        System.out.println("fe_final:" + fe_final);
    /*String []Inicio=fe_inicio.split("-");
    String []Final=fe_final.split("-");

    d1=Integer.parseInt(Final[1]);
    m1=Integer.parseInt(Final[0]);
    a1=Integer.parseInt(Final[2]);
    d2=Integer.parseInt(Inicio[1]);
    m2=Integer.parseInt(Inicio[0]);
    a2=Integer.parseInt(Inicio[2]);

    DateTime start = new DateTime(a2, m2, d2, 0, 0, 0, 0);
    System.out.println("start:"+start);
    DateTime end = new DateTime(a1, m1, d1, 0, 0, 0, 0);
    System.out.println("end:"+end);
    int count=0;
    while (start.compareTo(end)<=0){
    if(start.getDayOfWeek()==7){
    count=count+1;

    }
    }
    System.out.println("count :"+count);
     */
    }

    public HtmlDataTable getOrdenesDeTrabajoDataTable() {
        return ordenesDeTrabajoDataTable;
    }

    public void setOrdenesDeTrabajoDataTable(HtmlDataTable ordenesDeTrabajoDataTable) {
        this.ordenesDeTrabajoDataTable = ordenesDeTrabajoDataTable;
    }

    public SolicitudMantenimiento getSolicitudMantenimientobean() {
        return solicitudMantenimientobean;
    }

    public void setSolicitudMantenimientobean(SolicitudMantenimiento solicitudMantenimientobean) {
        this.solicitudMantenimientobean = solicitudMantenimientobean;
    }

    public List<SolicitudMantenimiento> getSolicitudMantenimientoList() {
        return solicitudMantenimientoList;
    }

    public void setSolicitudMantenimientoList(List<SolicitudMantenimiento> solicitudMantenimientoList) {
        this.solicitudMantenimientoList = solicitudMantenimientoList;
    }

    public List getSolicitudMantenimientoEliminarList() {
        return solicitudMantenimientoEliminarList;
    }

    public void setSolicitudMantenimientoEliminarList(List solicitudMantenimientoEliminarList) {
        this.solicitudMantenimientoEliminarList = solicitudMantenimientoEliminarList;
    }

    public List getSolicitudMantenimientoNoEliminarList() {
        return solicitudMantenimientoNoEliminarList;
    }

    public void setSolicitudMantenimientoNoEliminarList(List solicitudMantenimientoNoEliminarList) {
        this.solicitudMantenimientoNoEliminarList = solicitudMantenimientoNoEliminarList;
    }

    public List getSolicitudMantenimientoEditarList() {
        return solicitudMantenimientoEditarList;
    }

    public void setSolicitudMantenimientoEditarList(List solicitudMantenimientoEditarList) {
        this.solicitudMantenimientoEditarList = solicitudMantenimientoEditarList;
    }

    public Connection getCon() {
        return con;
    }

    public void setCon(Connection con) {
        this.con = con;
    }

    public String getCodigo() {
        return codigo;
    }

    public void setCodigo(String codigo) {
        this.codigo = codigo;
    }

    public boolean isSwEliminaSi() {
        return swEliminaSi;
    }

    public void setSwEliminaSi(boolean swEliminaSi) {
        this.swEliminaSi = swEliminaSi;
    }

    public boolean isSwEliminaNo() {
        return swEliminaNo;
    }

    public void setSwEliminaNo(boolean swEliminaNo) {
        this.swEliminaNo = swEliminaNo;
    }

    public List getTiposSolicitudMantenimientoList() {
        return tiposSolicitudMantenimientoList;
    }

    public void setTiposSolicitudMantenimientoList(List tiposSolicitudMantenimientoList) {
        this.tiposSolicitudMantenimientoList = tiposSolicitudMantenimientoList;
    }

  

    public List getEstadosSolicitudMantenimientoList() {
        return estadosSolicitudMantenimientoList;
    }

    public void setEstadosSolicitudMantenimientoList(List estadosSolicitudMantenimientoList) {
        this.estadosSolicitudMantenimientoList = estadosSolicitudMantenimientoList;
    }

    public List getGestionesList() {
        return gestionesList;
    }

    public void setGestionesList(List gestionesList) {
        this.gestionesList = gestionesList;
    }

    public List getAreasEmpresaList() {
        return areasEmpresaList;
    }

    public void setAreasEmpresaList(List areasEmpresaList) {
        this.areasEmpresaList = areasEmpresaList;
    }

    public List getPersonalUsuarioList() {
        return personalUsuarioList;
    }

    public void setPersonalUsuarioList(List personalUsuarioList) {
        this.personalUsuarioList = personalUsuarioList;
    }

    public List getPersonalEjecutanteList() {
        return personalEjecutanteList;
    }

    public void setPersonalEjecutanteList(List personalEjecutanteList) {
        this.personalEjecutanteList = personalEjecutanteList;
    }

    public List getMaquinariasList() {
        return maquinariasList;
    }

    public void setMaquinariasList(List maquinariasList) {
        this.maquinariasList = maquinariasList;
    }

    public AprobacionSolicitudMantenimiento getAprobacionSolicitudMantenimientobean() {
        return aprobacionSolicitudMantenimientobean;
    }

    public void setAprobacionSolicitudMantenimientobean(AprobacionSolicitudMantenimiento aprobacionSolicitudMantenimientobean) {
        this.aprobacionSolicitudMantenimientobean = aprobacionSolicitudMantenimientobean;
    }

    public List getAprobacionSolicitudMantList() {
        return aprobacionSolicitudMantList;
    }

    public void setAprobacionSolicitudMantList(List aprobacionSolicitudMantList) {
        this.aprobacionSolicitudMantList = aprobacionSolicitudMantList;
    }

    public List getSeguimientoSolicitudMantList() {
        return seguimientoSolicitudMantList;
    }

    public void setSeguimientoSolicitudMantList(List seguimientoSolicitudMantList) {
        this.seguimientoSolicitudMantList = seguimientoSolicitudMantList;
    }

   

    public List getSolicitudMantenimientoDetalleTareasList() {
        return solicitudMantenimientoDetalleTareasList;
    }

    public void setSolicitudMantenimientoDetalleTareasList(List solicitudMantenimientoDetalleTareasList) {
        this.solicitudMantenimientoDetalleTareasList = solicitudMantenimientoDetalleTareasList;
    }

 

    public List getTiposTareaSolicitudMantenimientoList() {
        return tiposTareaSolicitudMantenimientoList;
    }

    public void setTiposTareaSolicitudMantenimientoList(List tiposTareaSolicitudMantenimientoList) {
        this.tiposTareaSolicitudMantenimientoList = tiposTareaSolicitudMantenimientoList;
    }

    public HtmlDataTable getSolicitudMantenimientoDataTable() {
        return solicitudMantenimientoDataTable;
    }

    public void setSolicitudMantenimientoDataTable(HtmlDataTable solicitudMantenimientoDataTable) {
        this.solicitudMantenimientoDataTable = solicitudMantenimientoDataTable;
    }

    public List getTiposMantenimientoList() {
        return tiposSolicitudMantenimientoList;
    }

    public void setTiposMantenimientoList(List tiposMantenimientoList) {
        this.tiposSolicitudMantenimientoList = tiposMantenimientoList;
    }

    public SolicitudMantenimiento getSolicitudMantenimientoItem() {
        return solicitudMantenimientoItem;
    }

    public void setSolicitudMantenimientoItem(SolicitudMantenimiento solicitudMantenimientoItem) {
        this.solicitudMantenimientoItem = solicitudMantenimientoItem;
    }

    public List getAreasInstalacionesList() {
        return areasInstalacionesList;
    }

    public void setAreasInstalacionesList(List areasInstalacionesList) {
        this.areasInstalacionesList = areasInstalacionesList;
    }

    public String getValorAsignado() {
        return valorAsignado;
    }

    public void setValorAsignado(String valorAsignado) {
        this.valorAsignado = valorAsignado;
    }

    public List getTiposNivelSolicitudMantenimientoList() {
        return tiposNivelSolicitudMantenimientoList;
    }

    public void setTiposNivelSolicitudMantenimientoList(List tiposNivelSolicitudMantenimientoList) {
        this.tiposNivelSolicitudMantenimientoList = tiposNivelSolicitudMantenimientoList;
    }

    public SolicitudMantenimiento getSolicitudMantenimientoBuscar() {
        return solicitudMantenimientoBuscar;
    }

    public void setSolicitudMantenimientoBuscar(SolicitudMantenimiento solicitudMantenimientoBuscar) {
        this.solicitudMantenimientoBuscar = solicitudMantenimientoBuscar;
    }

    public List getSolicitanteList() {
        return solicitanteList;
    }

    public void setSolicitanteList(List solicitanteList) {
        this.solicitanteList = solicitanteList;
    }

    public Date getFechaFinal() {
        return fechaFinal;
    }

    public void setFechaFinal(Date fechaFinal) {
        this.fechaFinal = fechaFinal;
    }

    public Date getFechaInicio() {
        return fechaInicio;
    }

    public void setFechaInicio(Date fechaInicio) {
        this.fechaInicio = fechaInicio;
    }

    public List getInstalacionesList() {
        return instalacionesList;
    }

    public void setInstalacionesList(List instalacionesList) {
        this.instalacionesList = instalacionesList;
    }

    public List getEstadoSolicitudMantenimientoList() {
        return estadoSolicitudMantenimientoList;
    }

    public void setEstadoSolicitudMantenimientoList(List estadoSolicitudMantenimientoList) {
        this.estadoSolicitudMantenimientoList = estadoSolicitudMantenimientoList;
    }

    public List<SelectItem> getPersonalSolicitanteList() {
        return personalSolicitanteList;
    }

    public void setPersonalSolicitanteList(List<SelectItem> personalSolicitanteList) {
        this.personalSolicitanteList = personalSolicitanteList;
    }

    public List<SelectItem> getAreasEmpresaBuscadorList() {
        return areasEmpresaBuscadorList;
    }

    public void setAreasEmpresaBuscadorList(List<SelectItem> areasEmpresaBuscadorList) {
        this.areasEmpresaBuscadorList = areasEmpresaBuscadorList;
    }

    public String getMensaje() {
        return mensaje;
    }

    public void setMensaje(String mensaje) {
        this.mensaje = mensaje;
    }

     public List<SelectItem> getAreasInstalacionesDetalleSelectList() {
        return areasInstalacionesDetalleSelectList;
    }

    public void setAreasInstalacionesDetalleSelectList(List<SelectItem> areasInstalacionesDetalleSelectList) {
        this.areasInstalacionesDetalleSelectList = areasInstalacionesDetalleSelectList;
    }

    public HtmlDataTable getSolicitudMantenimientoDataTable1() {
        return solicitudMantenimientoDataTable1;
    }

    public void setSolicitudMantenimientoDataTable1(HtmlDataTable solicitudMantenimientoDataTable1) {
        this.solicitudMantenimientoDataTable1 = solicitudMantenimientoDataTable1;
    }

    public boolean isPermisoRegistroFechaSolicitud() {
        return permisoRegistroFechaSolicitud;
    }

    public void setPermisoRegistroFechaSolicitud(boolean permisoRegistroFechaSolicitud) {
        this.permisoRegistroFechaSolicitud = permisoRegistroFechaSolicitud;
    }
    

}
