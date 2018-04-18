/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.web;

import com.cofar.bean.ConfiguracionEnvioCorreoAtlas;
import com.cofar.bean.ConfiguracionPermisosEspecialesAtlas;
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
/**
 *
 * @author DASISAQ
 */
public class ManagedAdministracionAccesosSistema extends ManagedBean
{
    private Connection con;
    private String mensaje="";
    private List<SelectItem> motivosEnvioCorreoAtlasSelect;
    private ConfiguracionEnvioCorreoAtlas configuracionEnvioCorreoAtlasBuscar=new ConfiguracionEnvioCorreoAtlas();
    private ConfiguracionEnvioCorreoAtlas configuracionEnvioCorreoAtlasAgregar=new ConfiguracionEnvioCorreoAtlas();
    private List<ConfiguracionEnvioCorreoAtlas> configuracionEnvioCorreoAtlasList;
    private List<ConfiguracionEnvioCorreoAtlas> configuracionEnvioCorreoAtlasAgregarList;
    //configuracion permisos especiales
    private List<SelectItem> tiposPermisosEspecialesAtlasSelect;
    private List<ConfiguracionPermisosEspecialesAtlas> configuracionPermisosEspecialesAtlasList;
    private List<ConfiguracionPermisosEspecialesAtlas> configuracionPermisosEspecialesAtlasAgregarList;
    private ConfiguracionPermisosEspecialesAtlas configuracionPermisosEspecialesAtlasBuscar=new ConfiguracionPermisosEspecialesAtlas();
    private ConfiguracionPermisosEspecialesAtlas configuracionPermisosEspecialesAtlasAgregar;
    
    /**
     * Creates a new instance of ManagedAdministracionAccesosSistema
     */
    public ManagedAdministracionAccesosSistema() {
        LOGGER=LogManager.getRootLogger();
    }
    //<editor-fold desc="configuracion correo" defaultstate="collapsed">

            public String guardarAgregarConfiguracionEnvioCorreoAtlas()throws SQLException
            {
                mensaje = "";
                try {
                    con = Util.openConnection(con);
                    con.setAutoCommit(false);
                    StringBuilder consulta = new StringBuilder("INSERT INTO CONFIGURACION_ENVIO_CORREO_ATLAS(COD_PERSONAL,COD_MOTIVO_ENVIO_CORREO_PERSONAL)");
                                                consulta.append(" VALUES (");
                                                    consulta.append("?,");
                                                    consulta.append(configuracionEnvioCorreoAtlasAgregar.getMotivoEnvioCorreoAtlas().getCodMotivoEnvioCorreoAtlas());
                                                consulta.append(")");
                    LOGGER.debug("consulta agregar configuracion envio correo " + consulta.toString());
                    PreparedStatement pst = con.prepareStatement(consulta.toString());
                    for(ConfiguracionEnvioCorreoAtlas bean:configuracionEnvioCorreoAtlasAgregarList)
                    {
                        if(bean.getChecked())
                        {
                            pst.setString(1,bean.getPersonal().getCodPersonal());LOGGER.info("p1: "+bean.getPersonal().getCodPersonal());
                            if(pst.executeUpdate()>0)LOGGER.info("se registro la configuracion envio correo ");
                        }
                    }
                    con.commit();
                    mensaje = "1";
                } catch (SQLException ex) {
                    mensaje = "Ocurrio un error al momento de guardar el registro";
                    LOGGER.warn(ex.getMessage());
                    con.rollback();
                } catch (Exception ex) {
                    mensaje = "Ocurrio un error al momento de guardar el registro,verifique los datos introducidos";
                    LOGGER.warn(ex.getMessage());
                } finally {
                    this.cerrarConexion(con);
                }
                return null;
            }
            public String getCargarAgregarConfiguracionEnvioCorreoAtlas()
            {
                try {
                    con = Util.openConnection(con);
                    StringBuilder consulta = new StringBuilder("select p.COD_PERSONAL,p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL+' '+p.nombre2_personal as nombrePersonal,cp.nombre_correopersonal");
                                                consulta.append(" from PERSONAL p");
                                                        consulta.append(" left outer join correo_personal cp on cp.COD_PERSONAL=p.COD_PERSONAL");
                                                consulta.append(" where p.COD_ESTADO_PERSONA=1");
                                                consulta.append(" order by 2");
                    LOGGER.debug("consulta cargar " + consulta.toString());
                    Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    ResultSet res = st.executeQuery(consulta.toString());
                    configuracionEnvioCorreoAtlasAgregarList=new ArrayList<ConfiguracionEnvioCorreoAtlas>();
                    while (res.next()) 
                    {
                        ConfiguracionEnvioCorreoAtlas nuevo=new ConfiguracionEnvioCorreoAtlas();
                        nuevo.getPersonal().setCodPersonal(res.getString("COD_PERSONAL"));
                        nuevo.getPersonal().setNombrePersonal(res.getString("nombrePersonal"));
                        nuevo.getPersonal().setNombreCorreoPersonal(res.getString("nombre_correopersonal"));
                        configuracionEnvioCorreoAtlasAgregarList.add(nuevo);
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
                return null;
            }
            private void cargarMotivosEnvioCorreoAtlasSelect()
            {
                try {
                    con = Util.openConnection(con);
                    StringBuilder consulta = new StringBuilder("select mec.COD_MOTIVO_ENVIO_CORREO_ATLAS,mec.NOMBRE_MOTIVO_ENVIO_CORREO_ATLAS");
                                                consulta.append(" from MOTIVO_ENVIO_CORREO_ATLAS mec");
                                                consulta.append(" order by mec.NOMBRE_MOTIVO_ENVIO_CORREO_ATLAS");
                    LOGGER.debug("consulta cargar " + consulta.toString());
                    Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    ResultSet res = st.executeQuery(consulta.toString());
                    motivosEnvioCorreoAtlasSelect=new ArrayList<SelectItem>();
                    while (res.next()) 
                    {
                        motivosEnvioCorreoAtlasSelect.add(new SelectItem(res.getInt("COD_MOTIVO_ENVIO_CORREO_ATLAS"),res.getString("NOMBRE_MOTIVO_ENVIO_CORREO_ATLAS")));
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
            }
            public String eliminarConfiguracionEnvioCorreoAtlas()throws SQLException
            {
                for(ConfiguracionEnvioCorreoAtlas bean:configuracionEnvioCorreoAtlasList)
                {
                    if(bean.getChecked())
                    {
                        mensaje = "";
                        try {
                            con = Util.openConnection(con);
                            con.setAutoCommit(false);
                            StringBuilder consulta = new StringBuilder("delete CONFIGURACION_ENVIO_CORREO_ATLAS");
                                                        consulta.append(" where COD_PERSONAL=").append(bean.getPersonal().getCodPersonal());
                                                                consulta.append(" and COD_MOTIVO_ENVIO_CORREO_PERSONAL=").append(bean.getMotivoEnvioCorreoAtlas().getCodMotivoEnvioCorreoAtlas());
                            LOGGER.debug("consulta delete configuracion envio correo" + consulta.toString());
                            PreparedStatement pst = con.prepareStatement(consulta.toString());
                            if (pst.executeUpdate() > 0)LOGGER.info("se elimino el perfil usuarios envio correo");

                            con.commit();
                            mensaje = "1";
                        } catch (SQLException ex) {
                            mensaje = "Ocurrio un error al momento de guardar el registro";
                            LOGGER.warn(ex.getMessage());
                            con.rollback();
                        } catch (Exception ex) {
                            mensaje = "Ocurrio un error al momento de guardar el registro,verifique los datos introducidos";
                            LOGGER.warn(ex.getMessage());
                        } finally {
                            this.cerrarConexion(con);
                        }
                    }
                }
                if(mensaje.equals("1"))
                {
                    this.cargarConfiguracionMotivoEnvioCorreoAtlas();
                }
                return null;
            }
            public String buscarConfiguracionEnvioCorreoAtlas_action()
            {
                this.cargarConfiguracionMotivoEnvioCorreoAtlas();
                return null;
            }

            public String getCargarConfiguracionMotivoEnvioCorreoAtlas()
            {
                this.cargarConfiguracionMotivoEnvioCorreoAtlas();
                this.cargarMotivosEnvioCorreoAtlasSelect();
                return null;
            }
            private void cargarConfiguracionMotivoEnvioCorreoAtlas()
            {
                try {
                    con = Util.openConnection(con);
                    StringBuilder consulta = new StringBuilder("select p.COD_PERSONAL,p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL+' '+p.nombre2_personal as nombrePersonal,");
                                                                consulta.append(" ceca.COD_MOTIVO_ENVIO_CORREO_PERSONAL,meca.NOMBRE_MOTIVO_ENVIO_CORREO_ATLAS,cp.nombre_correopersonal");
                                                        consulta.append(" from CONFIGURACION_ENVIO_CORREO_ATLAS ceca");
                                                                consulta.append(" inner join personal p on p.COD_PERSONAL=ceca.COD_PERSONAL");
                                                                consulta.append(" inner join MOTIVO_ENVIO_CORREO_ATLAS meca on meca.COD_MOTIVO_ENVIO_CORREO_ATLAS=ceca.COD_MOTIVO_ENVIO_CORREO_PERSONAL");
                                                                consulta.append(" left outer join correo_personal cp on cp.COD_PERSONAL=p.COD_PERSONAL");
                                                                if(configuracionEnvioCorreoAtlasBuscar.getMotivoEnvioCorreoAtlas().getCodMotivoEnvioCorreoAtlas()>0)
                                                                    consulta.append(" where meca.COD_MOTIVO_ENVIO_CORREO_ATLAS=").append(configuracionEnvioCorreoAtlasBuscar.getMotivoEnvioCorreoAtlas().getCodMotivoEnvioCorreoAtlas());
                                                        consulta.append(" order by 2    ");
                    LOGGER.debug("consulta cargar configuracion envio correo" + consulta.toString());
                    Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    ResultSet res = st.executeQuery(consulta.toString());
                    configuracionEnvioCorreoAtlasList=new ArrayList<ConfiguracionEnvioCorreoAtlas>();
                    while (res.next()) 
                    {
                        ConfiguracionEnvioCorreoAtlas nuevo=new ConfiguracionEnvioCorreoAtlas();
                        nuevo.getPersonal().setCodPersonal(res.getString("COD_PERSONAL"));
                        nuevo.getPersonal().setNombrePersonal(res.getString("nombrePersonal"));
                        nuevo.getPersonal().setNombreCorreoPersonal(res.getString("nombre_correopersonal"));
                        nuevo.getMotivoEnvioCorreoAtlas().setCodMotivoEnvioCorreoAtlas(res.getInt("COD_MOTIVO_ENVIO_CORREO_PERSONAL"));
                        nuevo.getMotivoEnvioCorreoAtlas().setNombreMotivoEnvioCorreoAtlas(res.getString("NOMBRE_MOTIVO_ENVIO_CORREO_ATLAS"));
                        configuracionEnvioCorreoAtlasList.add(nuevo);
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
            }
    //</editor-fold>
    //<editor-fold desc="configuracion permisos especiales" defaultstate="collapsed">
            private void cargarTiposPermisosEspecialesAtlasSelect()
            {
                try {
                    con = Util.openConnection(con);
                    StringBuilder consulta = new StringBuilder("select tpea.COD_TIPO_PERMISO_ESPECIAL_ATLAS,tpea.NOMBRE_TIPO_PERMISO_ESPECIAL_ATLAS");
                                                consulta.append(" from TIPOS_PERMISOS_ESPECIALES_ATLAS tpea");
                                                consulta.append(" order by tpea.NOMBRE_TIPO_PERMISO_ESPECIAL_ATLAS");
                    LOGGER.debug("consulta cargar " + consulta.toString());
                    Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    ResultSet res = st.executeQuery(consulta.toString());
                    tiposPermisosEspecialesAtlasSelect=new ArrayList<SelectItem>();
                    while (res.next()) 
                    {
                        tiposPermisosEspecialesAtlasSelect.add(new SelectItem(res.getInt("COD_TIPO_PERMISO_ESPECIAL_ATLAS"),res.getString("NOMBRE_TIPO_PERMISO_ESPECIAL_ATLAS")));
                        
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
            }
            public String getCargarConfiguracionPermisosEspecialesAtlas()
            {
                this.cargarTiposPermisosEspecialesAtlasSelect();
                this.cargarConfiguracionPermisosEspecialesAtlas();
                return null;
            }
            public String eliminarConfiguracionPermisosEspecialesAtlas()throws SQLException
            {
                for(ConfiguracionPermisosEspecialesAtlas bean:configuracionPermisosEspecialesAtlasList)
                {
                    if(bean.getChecked())
                    {
                        mensaje = "";
                        try {
                            con = Util.openConnection(con);
                            con.setAutoCommit(false);
                            StringBuilder consulta = new StringBuilder("delete CONFIGURACION_PERMISOS_ESPECIALES_ATLAS");
                                                     consulta.append(" where COD_CONFIGURACION_PERMISOS_ESPECIALES_ATLAS=").append(bean.getCodConfiguracionPermisoEspecialAtlas());
                            LOGGER.debug("consulta eliminar configuracion permiso especial atlas " + consulta.toString());
                            PreparedStatement pst = con.prepareStatement(consulta.toString());
                            if (pst.executeUpdate() > 0) LOGGER.info("se elimino la configuracion");
                            con.commit();
                            mensaje = "1";
                        } catch (SQLException ex) {
                            mensaje = "Ocurrio un error al momento de guardar el registro";
                            LOGGER.warn(ex.getMessage());
                            con.rollback();
                        } catch (Exception ex) {
                            mensaje = "Ocurrio un error al momento de guardar el registro,verifique los datos introducidos";
                            LOGGER.warn(ex.getMessage());
                        } finally {
                            this.cerrarConexion(con);
                        }
                    }
                }
                if(mensaje.equals("1"))
                {
                    this.cargarConfiguracionPermisosEspecialesAtlas();
                }
                return null;
            }
            public String guardarAgregarConfiguracionPermisosEspecialesAtlas()throws SQLException
            {
                mensaje = "";
                try {
                    con = Util.openConnection(con);
                    con.setAutoCommit(false);
                    StringBuilder consulta = new StringBuilder("INSERT INTO CONFIGURACION_PERMISOS_ESPECIALES_ATLAS(COD_PERSONAL,COD_TIPO_PERMISO_ESPECIAL_ATLAS)");
                                            consulta.append(" VALUES (");
                                                    consulta.append("?,");
                                                    consulta.append(configuracionPermisosEspecialesAtlasAgregar.getTiposPermisosEspecialesAtlas().getCodTipoPermisoEspecialAtlas());
                                            consulta.append(")");
                    LOGGER.debug("consulta agregar configuracion permiso especial atlas" + consulta.toString());
                    PreparedStatement pst = con.prepareStatement(consulta.toString());
                    for(ConfiguracionPermisosEspecialesAtlas bean:configuracionPermisosEspecialesAtlasAgregarList)
                    {
                        if(bean.getChecked())
                        {
                            pst.setString(1,bean.getPersonal().getCodPersonal());LOGGER.info("p1: "+bean.getPersonal().getCodPersonal());
                            if(pst.executeUpdate()>0)LOGGER.info("se registro el permiso especial");
                        }
                    }
                    con.commit();
                    mensaje = "1";
                } catch (SQLException ex) {
                    mensaje = "Ocurrio un error al momento de guardar el registro";
                    LOGGER.warn(ex.getMessage());
                    con.rollback();
                } catch (Exception ex) {
                    mensaje = "Ocurrio un error al momento de guardar el registro,verifique los datos introducidos";
                    LOGGER.warn(ex.getMessage());
                } finally {
                    this.cerrarConexion(con);
                }
                return null;
            }
                    
            public String getCargarAgregarConfiguracionPermisosEspecialesAtlas()
            {
                configuracionPermisosEspecialesAtlasAgregar=new ConfiguracionPermisosEspecialesAtlas();
                try {
                    con = Util.openConnection(con);
                    StringBuilder consulta = new StringBuilder("select p.COD_PERSONAL,p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL+' '+p.nombre2_personal as nombrePersonal");
                                                consulta.append(" from PERSONAL p");
                                                consulta.append(" where p.COD_ESTADO_PERSONA=1");
                                                consulta.append(" order by 2");
                    Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    ResultSet res = st.executeQuery(consulta.toString());
                    configuracionPermisosEspecialesAtlasAgregarList=new ArrayList<ConfiguracionPermisosEspecialesAtlas>();
                    while (res.next()) 
                    {
                        ConfiguracionPermisosEspecialesAtlas nuevo=new ConfiguracionPermisosEspecialesAtlas();
                        nuevo.getPersonal().setCodPersonal(res.getString("COD_PERSONAL"));
                        nuevo.getPersonal().setNombrePersonal(res.getString("nombrePersonal"));
                        configuracionPermisosEspecialesAtlasAgregarList.add(nuevo);
                        
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
                return null;
            }
            private void cargarConfiguracionPermisosEspecialesAtlas()
            {
                try {
                    con = Util.openConnection(con);
                    StringBuilder consulta = new StringBuilder("select cpea.COD_PERSONAL,p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL+' '+p.nombre2_personal as nombrePersonal,");
                                                        consulta.append(" cpea.COD_TIPO_PERMISO_ESPECIAL_ATLAS,tpea.NOMBRE_TIPO_PERMISO_ESPECIAL_ATLAS,cpea.COD_CONFIGURACION_PERMISOS_ESPECIALES_ATLAS ");
                                            consulta.append(" from CONFIGURACION_PERMISOS_ESPECIALES_ATLAS cpea");
                                                        consulta.append(" inner join personal p on p.COD_PERSONAL=cpea.COD_PERSONAL");
                                                        consulta.append(" inner join TIPOS_PERMISOS_ESPECIALES_ATLAS tpea on tpea.COD_TIPO_PERMISO_ESPECIAL_ATLAS=cpea.COD_TIPO_PERMISO_ESPECIAL_ATLAS");
                                                        if(configuracionPermisosEspecialesAtlasBuscar.getTiposPermisosEspecialesAtlas().getCodTipoPermisoEspecialAtlas()>0)
                                                            consulta.append(" where tpea.COD_TIPO_PERMISO_ESPECIAL_ATLAS=").append(configuracionPermisosEspecialesAtlasBuscar.getTiposPermisosEspecialesAtlas().getCodTipoPermisoEspecialAtlas());
                                            consulta.append(" order by 2    ,tpea.NOMBRE_TIPO_PERMISO_ESPECIAL_ATLAS");
                    LOGGER.debug("consulta cargar configuracion permisos especiales " + consulta.toString());
                    Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    ResultSet res = st.executeQuery(consulta.toString());
                    configuracionPermisosEspecialesAtlasList=new ArrayList<ConfiguracionPermisosEspecialesAtlas>();
                    while (res.next()) 
                    {
                        ConfiguracionPermisosEspecialesAtlas nuevo=new ConfiguracionPermisosEspecialesAtlas();
                        nuevo.getPersonal().setCodPersonal(res.getString("COD_PERSONAL"));
                        nuevo.getPersonal().setNombrePersonal(res.getString("nombrePersonal"));
                        nuevo.getTiposPermisosEspecialesAtlas().setCodTipoPermisoEspecialAtlas(res.getInt("COD_TIPO_PERMISO_ESPECIAL_ATLAS"));
                        nuevo.getTiposPermisosEspecialesAtlas().setNombreTipoPermisoEspecialAtlas(res.getString("NOMBRE_TIPO_PERMISO_ESPECIAL_ATLAS"));
                        nuevo.setCodConfiguracionPermisoEspecialAtlas(res.getInt("COD_CONFIGURACION_PERMISOS_ESPECIALES_ATLAS"));
                        configuracionPermisosEspecialesAtlasList.add(nuevo);
                        
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
            }
            public String buscarConfiguracionPermisosEspecialesAtlas_action()throws SQLException
            {
                this.cargarConfiguracionPermisosEspecialesAtlas();
                return null;
            }
    //</editor-fold>        
            
            
    //<editor-fold desc="getter and setter" defaultstate="collapsed">

        public List<SelectItem> getTiposPermisosEspecialesAtlasSelect() {
            return tiposPermisosEspecialesAtlasSelect;
        }

        public void setTiposPermisosEspecialesAtlasSelect(List<SelectItem> tiposPermisosEspecialesAtlasSelect) {
            this.tiposPermisosEspecialesAtlasSelect = tiposPermisosEspecialesAtlasSelect;
        }

        public List<ConfiguracionPermisosEspecialesAtlas> getConfiguracionPermisosEspecialesAtlasList() {
            return configuracionPermisosEspecialesAtlasList;
        }

        public void setConfiguracionPermisosEspecialesAtlasList(List<ConfiguracionPermisosEspecialesAtlas> configuracionPermisosEspecialesAtlasList) {
            this.configuracionPermisosEspecialesAtlasList = configuracionPermisosEspecialesAtlasList;
        }

        public List<ConfiguracionPermisosEspecialesAtlas> getConfiguracionPermisosEspecialesAtlasAgregarList() {
            return configuracionPermisosEspecialesAtlasAgregarList;
        }

        public void setConfiguracionPermisosEspecialesAtlasAgregarList(List<ConfiguracionPermisosEspecialesAtlas> configuracionPermisosEspecialesAtlasAgregarList) {
            this.configuracionPermisosEspecialesAtlasAgregarList = configuracionPermisosEspecialesAtlasAgregarList;
        }

        public ConfiguracionPermisosEspecialesAtlas getConfiguracionPermisosEspecialesAtlasBuscar() {
            return configuracionPermisosEspecialesAtlasBuscar;
        }

        public void setConfiguracionPermisosEspecialesAtlasBuscar(ConfiguracionPermisosEspecialesAtlas configuracionPermisosEspecialesAtlasBuscar) {
            this.configuracionPermisosEspecialesAtlasBuscar = configuracionPermisosEspecialesAtlasBuscar;
        }

        public ConfiguracionPermisosEspecialesAtlas getConfiguracionPermisosEspecialesAtlasAgregar() {
            return configuracionPermisosEspecialesAtlasAgregar;
        }

        public void setConfiguracionPermisosEspecialesAtlasAgregar(ConfiguracionPermisosEspecialesAtlas configuracionPermisosEspecialesAtlasAgregar) {
            this.configuracionPermisosEspecialesAtlasAgregar = configuracionPermisosEspecialesAtlasAgregar;
        }
        public String getMensaje() {
            return mensaje;
        }

        public void setMensaje(String mensaje) {
            this.mensaje = mensaje;
        }

        public List<SelectItem> getMotivosEnvioCorreoAtlasSelect() {
            return motivosEnvioCorreoAtlasSelect;
        }

        public void setMotivosEnvioCorreoAtlasSelect(List<SelectItem> motivosEnvioCorreoAtlasSelect) {
            this.motivosEnvioCorreoAtlasSelect = motivosEnvioCorreoAtlasSelect;
        }

        public ConfiguracionEnvioCorreoAtlas getConfiguracionEnvioCorreoAtlasBuscar() {
            return configuracionEnvioCorreoAtlasBuscar;
        }

        public void setConfiguracionEnvioCorreoAtlasBuscar(ConfiguracionEnvioCorreoAtlas configuracionEnvioCorreoAtlasBuscar) {
            this.configuracionEnvioCorreoAtlasBuscar = configuracionEnvioCorreoAtlasBuscar;
        }

        public ConfiguracionEnvioCorreoAtlas getConfiguracionEnvioCorreoAtlasAgregar() {
            return configuracionEnvioCorreoAtlasAgregar;
        }

        public void setConfiguracionEnvioCorreoAtlasAgregar(ConfiguracionEnvioCorreoAtlas configuracionEnvioCorreoAtlasAgregar) {
            this.configuracionEnvioCorreoAtlasAgregar = configuracionEnvioCorreoAtlasAgregar;
        }

        public List<ConfiguracionEnvioCorreoAtlas> getConfiguracionEnvioCorreoAtlasList() {
            return configuracionEnvioCorreoAtlasList;
        }

        public void setConfiguracionEnvioCorreoAtlasList(List<ConfiguracionEnvioCorreoAtlas> configuracionEnvioCorreoAtlasList) {
            this.configuracionEnvioCorreoAtlasList = configuracionEnvioCorreoAtlasList;
        }

        public List<ConfiguracionEnvioCorreoAtlas> getConfiguracionEnvioCorreoAtlasAgregarList() {
            return configuracionEnvioCorreoAtlasAgregarList;
        }

        public void setConfiguracionEnvioCorreoAtlasAgregarList(List<ConfiguracionEnvioCorreoAtlas> configuracionEnvioCorreoAtlasAgregarList) {
            this.configuracionEnvioCorreoAtlasAgregarList = configuracionEnvioCorreoAtlasAgregarList;
        }
    //</editor-fold>        

    
    
        
    
}
