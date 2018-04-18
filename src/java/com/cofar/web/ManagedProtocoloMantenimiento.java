/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.web;

import com.cofar.bean.ProtocoloMantenimientoVersion;
import com.cofar.bean.ProtocoloMantenimientoVersionDetalleMateriales;
import com.cofar.bean.ProtocoloMantenimientoVersionDetalleTareas;
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
 * @author DASISAQ
 */
public class ManagedProtocoloMantenimiento extends ManagedBean
{
    private Connection con=null;
    private String mensaje="";
    private List<SelectItem> tiposMantenimientoMaquinariaSelectList;
    private List<SelectItem> unidadesMedidaTiempoSelectList;
    private List<SelectItem> maquinariasSelectList;
    private List<SelectItem> partesMaquinariaSelectList;
    private List<SelectItem> tiposFrecuenciaMantenimientoSelectList;
    private List<SelectItem> documentacionSelectList;
    private List<SelectItem> diasSemanaSelectList;
    private List<ProtocoloMantenimientoVersion> protocoloMantenimientoList;
    private ProtocoloMantenimientoVersion protocoloMantenimientoVersionAgregar;
    private ProtocoloMantenimientoVersion protocoloMantenimientoVersionEditar;
    private ProtocoloMantenimientoVersion protocoloMantenimientoVersionBuscar=new ProtocoloMantenimientoVersion();
    private ProtocoloMantenimientoVersion protocoloMantenimientoBean;
    private List<ProtocoloMantenimientoVersion> protocoloMantenimientoVersionList;
    private HtmlDataTable protocoloMantenimientoDataTable=new HtmlDataTable();
    private HtmlDataTable protocoloMantenimientoVersionDataTable;
    //para agregar materiales necesarios
    private List<ProtocoloMantenimientoVersionDetalleMateriales> protocoloMantenimientoVersionDetalleMaterialList;
    private ProtocoloMantenimientoVersion protocoloMantenimientoVersionBean;
    private List<ProtocoloMantenimientoVersionDetalleMateriales> protocoloMantenimientoVersionDetalleMaterialesAgregarList;
    private ProtocoloMantenimientoVersionDetalleMateriales protocoloMantenimientoVersionDetalleMaterialAgregar;
    private ProtocoloMantenimientoVersionDetalleMateriales protocoloMantenimientoVersionDetalleMaterialEditar;

    //para agregar tareas mantenimiento
    private List<ProtocoloMantenimientoVersionDetalleTareas> protocoloMantenimientoVersionDetalleTareaList;
    private List<SelectItem> tiposTareaSelectList;
    private ProtocoloMantenimientoVersionDetalleTareas protocoloMantenimientoVersionDetalleTareaAgregar;
    private ProtocoloMantenimientoVersionDetalleTareas protocoloMantenimientoVersionDetalleTareaEditar;
    
    
    
    /**
     * Creates a new instance of ManagedProtocoloMantenimiento
     */
    public ManagedProtocoloMantenimiento() 
    {
        LOGGER=LogManager.getLogger("ProtocoloMantenimiento");
        protocoloMantenimientoVersionBuscar.getProtocoloMantenimiento().getMaquinaria().setCodMaquina("0");
        partesMaquinariaSelectList=new ArrayList<SelectItem>();
    }
    //<editor-fold desc="funciones para navegador creacion protocolos" defaultstate="collapsed">
        
        private void cargarDiasSemanaSelectList()
        {
            try {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select ds.COD_DIA_SEMANA,ds.NOMBRE_DIA_SEMANA");
                                            consulta.append(" from DIAS_SEMANA ds");
                                            consulta.append(" order by ds.COD_DIA_SEMANA");
                LOGGER.debug("consulta cargar  dias semana" + consulta.toString());
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                diasSemanaSelectList=new ArrayList<SelectItem>();
                while (res.next()) 
                {
                    diasSemanaSelectList.add(new SelectItem(res.getInt("COD_DIA_SEMANA"),res.getString("NOMBRE_DIA_SEMANA")));
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
        public String getCargareditarProtocoloMantenimientoVersion()
        {
            this.codTipoFrecuenciaMantenimientoEditar_change();
            return null;
        }
        public String codTipoFrecuenciaMantenimientoEditar_change()
        {
            this.cargarDatosFrecuenciaMaquinaria(protocoloMantenimientoVersionEditar);
            return null;
        }
        
        public String codTipoFrecuenciaMantenimientoAgregar_change()
        {
            this.cargarDatosFrecuenciaMaquinaria(protocoloMantenimientoVersionAgregar);
            return null;
        }
    
        private void cargarDatosFrecuenciaMaquinaria(ProtocoloMantenimientoVersion bean)
        {
            try {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select tfm.APLICA_ASIGNAR_NRO_SEMANA");
                                            consulta.append(" from TIPOS_FRECUENCIA_MANTENIMIENTO tfm ");
                                            consulta.append(" where tfm.COD_TIPO_FRECUENCIA_MANTENIMIENTO=").append(bean.getTiposFrecuenciaMantenimiento().getCodTipoFrecuenciaMantenimiento());
                LOGGER.debug("consulta cargar tipo Frecuan " + consulta.toString());
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                if(res.next()) 
                {
                    bean.getTiposFrecuenciaMantenimiento().setAplicaAsignarNroSemana(res.getInt("APLICA_ASIGNAR_NRO_SEMANA")>0);
                    bean.setNroSemana(res.getInt("APLICA_ASIGNAR_NRO_SEMANA"));
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
        private void cargarDocumentacionSelectList()
        {
            try {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select d.COD_DOCUMENTO,'('+d.CODIGO_DOCUMENTO+') '+d.NOMBRE_DOCUMENTO as nombreDocumento");
                                        consulta.append(" from DOCUMENTACION d");
                                        consulta.append(" where d.COD_AREA_EMPRESA=86");
                                        consulta.append(" order by d.CODIGO_DOCUMENTO");
                LOGGER.debug("consulta cargar " + consulta.toString());
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                documentacionSelectList=new ArrayList<SelectItem>();
                while (res.next()) 
                {
                    documentacionSelectList.add(new SelectItem(res.getInt("COD_DOCUMENTO"),res.getString("nombreDocumento")));
                    
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
        private void cargarUnidadesMedidadTiempoSelectList()
        {
            try {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select u.COD_UNIDAD_MEDIDA,u.NOMBRE_UNIDAD_MEDIDA");
                                            consulta.append(" from UNIDADES_MEDIDA u");
                                            consulta.append(" where u.COD_TIPO_MEDIDA=7");
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                unidadesMedidaTiempoSelectList=new ArrayList<SelectItem>();
                while (res.next()) 
                {
                    unidadesMedidaTiempoSelectList.add(new SelectItem(res.getString("COD_UNIDAD_MEDIDA"),res.getString("NOMBRE_UNIDAD_MEDIDA")));
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
        public String eliminarProtocoloMantenimiento_action()throws SQLException
        {
            ProtocoloMantenimientoVersion bean=(ProtocoloMantenimientoVersion)protocoloMantenimientoDataTable.getRowData();
            mensaje = "";
            try 
            {
                con = Util.openConnection(con);
                con.setAutoCommit(false);
                StringBuilder consulta = new StringBuilder("exec PAA_ELIMINAR_PROTOCOLO_MANTENIMIENTO");
                                        consulta.append(" ?");//cod protocolo mantenimiento
                LOGGER.debug("consulta eliminar protocolo mantenimiento " + consulta.toString());
                PreparedStatement pst = con.prepareStatement(consulta.toString());
                pst.setInt(1,bean.getProtocoloMantenimiento().getCodProtocoloMantenimiento());LOGGER.info("p1: "+bean.getProtocoloMantenimiento().getCodProtocoloMantenimiento());
                if (pst.executeUpdate() > 0) LOGGER.info("se elimino el protocolo de mantenimiento");
                con.commit();
                mensaje = "1";
            } catch (SQLException ex) {
                mensaje = "Ocurrio un error al momento de guardar el registro "+ex.getMessage();
                LOGGER.warn(ex.getMessage());
                con.rollback();
            } catch (Exception ex) {
                mensaje = "Ocurrio un error al momento de guardar el registro,verifique los datos introducidos "+ex.getMessage();
                LOGGER.warn(ex.getMessage());
            } finally {
                this.cerrarConexion(con);
            }
            if(mensaje.equals("1"))
            {
                this.cargarProtocolosMantenimientoList();
            }
            return null;
        }
        public String crearProtocoloMantenimientoVersion_action()throws SQLException
        {
            mensaje = "";
            try {
                con = Util.openConnection(con);
                con.setAutoCommit(false);
                StringBuilder consulta = new StringBuilder(" exec PAA_REGISTRO_NUEVA_VERSION_PROTOCOLO_MANTENIMIENTO ");
                                        consulta.append(protocoloMantenimientoBean.getProtocoloMantenimiento().getCodProtocoloMantenimiento());
                LOGGER.debug("consulta registrar nuevo protocolo mantenimiento version " + consulta.toString());
                PreparedStatement pst = con.prepareStatement(consulta.toString());
                if (pst.executeUpdate() > 0) LOGGER.info("se registro la nueva version ");
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
            if(mensaje.equals("1"))
            {
                this.cargarProtocoloMantenimientoVersionList();
                
            }
            return null;
        }
        public String enviarAprobacionProtocoloMantenimientoVersion_action()throws SQLException
        {
            ProtocoloMantenimientoVersion bean=(ProtocoloMantenimientoVersion) protocoloMantenimientoVersionDataTable.getRowData();
            mensaje = "";
            try {
                con = Util.openConnection(con);
                con.setAutoCommit(false);
                StringBuilder consulta = new StringBuilder("update PROTOCOLO_MANTENIMIENTO_VERSION");
                                        consulta.append(" set COD_ESTADO_PROTOCOLO_MANTENIMIENTO_VERSION=4");
                                        consulta.append(" where COD_PROTOCOLO_MANTENIMIENTO_VERSION=").append(bean.getCodProtocoloMantenimientoVersion());
                LOGGER.debug("consulta enviar aprobacion protocolo version " + consulta.toString());
                PreparedStatement pst = con.prepareStatement(consulta.toString());
                if (pst.executeUpdate() > 0) LOGGER.info("se envio a aprobacion el protocolo version ");
                con.commit();
                mensaje = "1";
            }
            catch (SQLException ex) 
            {
                mensaje = "Ocurrio un error al momento de guardar el registro"+ex.getMessage();
                LOGGER.warn(ex.getMessage());
                con.rollback();
            }
            catch (Exception ex) 
            {
                mensaje = "Ocurrio un error al momento de guardar el registro,verifique los datos introducidos"+ex.getMessage();
                LOGGER.warn(ex.getMessage());
            }
            finally 
            {
                this.cerrarConexion(con);
            }
            if(mensaje.equals("1"))
            {
                this.cargarProtocoloMantenimientoVersionList();
            }
            return null;
        }
        public String eliminarProtocoloMantenimientoVersion_action()throws SQLException
        {
            ProtocoloMantenimientoVersion bean=(ProtocoloMantenimientoVersion) protocoloMantenimientoVersionDataTable.getRowData();
            mensaje = "";
            try {
                con = Util.openConnection(con);
                con.setAutoCommit(false);
                StringBuilder consulta = new StringBuilder("EXEC PAA_ELIMINAR_PROTOCOLO_MANTENIMIENTO_VERSION");
                                            consulta.append(" ?");//cod protocolo version
                LOGGER.debug("consulta eliminar protocolo version " + consulta.toString());
                PreparedStatement pst = con.prepareStatement(consulta.toString());
                pst.setInt(1,bean.getCodProtocoloMantenimientoVersion());LOGGER.info("p1: "+bean.getCodProtocoloMantenimientoVersion());
                if (pst.executeUpdate() > 0) LOGGER.info("se elimino el protocolo version ");
                con.commit();
                mensaje = "1";
            }
            catch (SQLException ex) 
            {
                mensaje = "Ocurrio un error al momento de guardar el registro"+ex.getMessage();
                LOGGER.warn(ex.getMessage());
                con.rollback();
            }
            catch (Exception ex) 
            {
                mensaje = "Ocurrio un error al momento de guardar el registro,verifique los datos introducidos"+ex.getMessage();
                LOGGER.warn(ex.getMessage());
            }
            finally 
            {
                this.cerrarConexion(con);
            }
            if(mensaje.equals("1"))
            {
                this.cargarProtocoloMantenimientoVersionList();
            }
            return null;
        }
        private void cargarTiposFrecuenciaMantenimientoSelectList()
        {
            try 
            {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select tfm.COD_TIPO_FRECUENCIA_MANTENIMIENTO,tfm.NOMBRE_TIPO_FRECUENCIA_MANTENIMIENTO");
                                            consulta.append(" from TIPOS_FRECUENCIA_MANTENIMIENTO tfm");
                                            consulta.append(" order by tfm.NOMBRE_TIPO_FRECUENCIA_MANTENIMIENTO");
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                tiposFrecuenciaMantenimientoSelectList=new ArrayList<SelectItem>();
                while (res.next()) 
                {
                    tiposFrecuenciaMantenimientoSelectList.add(new SelectItem(res.getInt("COD_TIPO_FRECUENCIA_MANTENIMIENTO"),res.getString("NOMBRE_TIPO_FRECUENCIA_MANTENIMIENTO")));
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
        public String guardarEdicionProtocoloMantenimientoVersion_action()throws SQLException
        {
            mensaje = "";
            try {
                con = Util.openConnection(con);
                con.setAutoCommit(false);
                StringBuilder consulta = new StringBuilder("UPDATE PROTOCOLO_MANTENIMIENTO_VERSION  ");
                                            consulta.append(" SET ");
                                                    consulta.append(" COD_TIPO_MANTENIMIENTO_MAQUINARIA =").append(protocoloMantenimientoVersionEditar.getTiposMantenimientoMaquinaria().getCodTipoMantenimientoMaquinaria()).append(",");
                                                    consulta.append(" DESCRIPCION_PROTOCOLO_MANTENIMIENTO = ?,");
                                                    consulta.append(" COD_TIPO_FRECUENCIA_MANTENIMIENTO=").append(protocoloMantenimientoVersionEditar.getTiposFrecuenciaMantenimiento().getCodTipoFrecuenciaMantenimiento()).append(",");
                                                    consulta.append(" COD_ESTADO_REGISTRO =?,");
                                                    consulta.append(" COD_DIA_SEMANA=").append(protocoloMantenimientoVersionEditar.getDiaSemana().getCodDiaSemana()).append(",");
                                                    consulta.append(" CANTIDAD_TIEMPO=?,");
                                                    consulta.append(" COD_DOCUMENTO=").append(protocoloMantenimientoVersionEditar.getDocumentacion().getCodDocumento()).append(",");
                                                    consulta.append(" COD_UNIDAD_MEDIDA_TIEMPO=").append(protocoloMantenimientoVersionEditar.getUnidadMedidaTiempo().getCodUnidadMedida()).append(",");
                                                    consulta.append(" NRO_SEMANA_MANTENIMIENTO=").append(protocoloMantenimientoVersionEditar.getNroSemana()).append(",");
                                                    consulta.append(" MANTENIMIENTO_COFAR=").append(protocoloMantenimientoVersionEditar.getMantenimientoCofar()?1:0).append(",");
                                                    consulta.append(" MANTENIMIENTO_EXTERNO=").append(protocoloMantenimientoVersionEditar.getMantenimientoExterno()?1:0);
                                                    
                                            consulta.append(" WHERE COD_PROTOCOLO_MANTENIMIENTO_VERSION =").append(protocoloMantenimientoVersionEditar.getCodProtocoloMantenimientoVersion());
                LOGGER.debug("consulta editar version protocolo mantenimiento " + consulta.toString());
                PreparedStatement pst = con.prepareStatement(consulta.toString());
                pst.setString(1,protocoloMantenimientoVersionEditar.getDescripcionProtocoloMantenimientoVersion());LOGGER.info(" p1: "+protocoloMantenimientoVersionEditar.getDescripcionProtocoloMantenimientoVersion());
                pst.setString(2,protocoloMantenimientoVersionEditar.getEstadoRegistro().getCodEstadoRegistro());LOGGER.info(" p2: "+protocoloMantenimientoVersionEditar.getEstadoRegistro().getCodEstadoRegistro());
                pst.setDouble(3,protocoloMantenimientoVersionEditar.getCantidadTiempo());
                if (pst.executeUpdate() > 0) LOGGER.info("se guardo la edicion del protocolo ");
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
        public String seleccionarProtocoloMantenimientoEditar_action()
        {
            protocoloMantenimientoVersionEditar=(ProtocoloMantenimientoVersion)protocoloMantenimientoVersionDataTable.getRowData();
            return null;
        }
        public String seleccionarProtocoloMantenimiento_action()
        {
            protocoloMantenimientoVersionDataTable=new HtmlDataTable();
            protocoloMantenimientoBean=(ProtocoloMantenimientoVersion)protocoloMantenimientoDataTable.getRowData();
            return null;
        }
        public String getCargarProtocoloMantenimientoVersionList()
        {
            
            this.cargarProtocoloMantenimientoVersionList();
            return null;
        }
        private void cargarProtocoloMantenimientoVersionList()
        {
            try {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select pmv.COD_PROTOCOLO_MANTENIMIENTO_VERSION,pmv.DESCRIPCION_PROTOCOLO_MANTENIMIENTO,tmm.COD_TIPO_MANTENIMIENTO_MAQUINARIA,tmm.NOMBRE_TIPO_MANTENIMIENTO_MAQUINARIA,");
                                                    consulta.append(" epmv.COD_ESTADO_PROTOCOLO_MANTENIMIENTO_VERSION,epmv.NOMBRE_ESTADO_PROTOCOLO_MANTENIMIENTO_VERSION");
                                                    consulta.append(" ,er.COD_ESTADO_REGISTRO,er.NOMBRE_ESTADO_REGISTRO,pmv.NRO_VERSION");
                                                    consulta.append(" ,tfm.COD_TIPO_FRECUENCIA_MANTENIMIENTO,tfm.NOMBRE_TIPO_FRECUENCIA_MANTENIMIENTO");
                                                    consulta.append(" ,pmv.COD_UNIDAD_MEDIDA_TIEMPO,pmv.COD_DOCUMENTO,d.NOMBRE_DOCUMENTO,d.CODIGO_DOCUMENTO,");
                                                    consulta.append(" pmv.COD_DIA_SEMANA,ds.NOMBRE_DIA_SEMANA,pmv.NRO_SEMANA_MANTENIMIENTO,pmv.CANTIDAD_TIEMPO,um.NOMBRE_UNIDAD_MEDIDA");
                                                    consulta.append(" ,pmv.MANTENIMIENTO_COFAR,pmv.MANTENIMIENTO_EXTERNO");
                                            consulta.append(" from PROTOCOLO_MANTENIMIENTO_VERSION pmv ");
                                                    consulta.append(" inner join TIPOS_MANTENIMIENTO_MAQUINARIA tmm on tmm.COD_TIPO_MANTENIMIENTO_MAQUINARIA=pmv.COD_TIPO_MANTENIMIENTO_MAQUINARIA");
                                                    consulta.append(" inner join ESTADOS_PROTOCOLO_MANTENIMIENTO_VERSION epmv on epmv.COD_ESTADO_PROTOCOLO_MANTENIMIENTO_VERSION=pmv.COD_ESTADO_PROTOCOLO_MANTENIMIENTO_VERSION");
                                                    consulta.append(" inner join ESTADOS_REFERENCIALES er on er.COD_ESTADO_REGISTRO=pmv.COD_ESTADO_REGISTRO");
                                                    consulta.append(" inner join TIPOS_FRECUENCIA_MANTENIMIENTO tfm on tfm.COD_TIPO_FRECUENCIA_MANTENIMIENTO=pmv.COD_TIPO_FRECUENCIA_MANTENIMIENTO");
                                                    consulta.append(" left outer join DOCUMENTACION d on d.COD_DOCUMENTO = pmv.COD_DOCUMENTO");
                                                    consulta.append(" left outer join DIAS_SEMANA ds on ds.COD_DIA_SEMANA = pmv.COD_DIA_SEMANA");
                                                    consulta.append(" left outer join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA =pmv.COD_UNIDAD_MEDIDA_TIEMPO");
                                            consulta.append(" where pmv.COD_PROTOCOLO_MANTENIMIENTO=").append(protocoloMantenimientoBean.getProtocoloMantenimiento().getCodProtocoloMantenimiento());
                                                    
                                            consulta.append(" order by pmv.NRO_VERSION  DESC ");
                LOGGER.debug("consulta cargar versiones de protocolo mantenimiento " + consulta.toString());
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                protocoloMantenimientoVersionList=new ArrayList<ProtocoloMantenimientoVersion>();
                while (res.next()) 
                {
                    ProtocoloMantenimientoVersion nuevo=new ProtocoloMantenimientoVersion();
                    nuevo.getTiposFrecuenciaMantenimiento().setCodTipoFrecuenciaMantenimiento(res.getInt("COD_TIPO_FRECUENCIA_MANTENIMIENTO"));
                    nuevo.getTiposFrecuenciaMantenimiento().setNombreTipoFrecuenciaMantenimiento(res.getString("NOMBRE_TIPO_FRECUENCIA_MANTENIMIENTO"));
                    nuevo.setCodProtocoloMantenimientoVersion(res.getInt("COD_PROTOCOLO_MANTENIMIENTO_VERSION"));
                    nuevo.setDescripcionProtocoloMantenimientoVersion(res.getString("DESCRIPCION_PROTOCOLO_MANTENIMIENTO"));
                    nuevo.getTiposMantenimientoMaquinaria().setCodTipoMantenimientoMaquinaria(res.getInt("COD_TIPO_MANTENIMIENTO_MAQUINARIA"));
                    nuevo.getTiposMantenimientoMaquinaria().setNombreTipoMantenimientoMaquinaria(res.getString("NOMBRE_TIPO_MANTENIMIENTO_MAQUINARIA"));
                    nuevo.getEstadosProtocoloMantenimientoVersion().setCodEstadoProtocoloMantenimientoVersion(res.getInt("COD_ESTADO_PROTOCOLO_MANTENIMIENTO_VERSION"));
                    nuevo.getEstadosProtocoloMantenimientoVersion().setNombreEstadoProtocoloMantenimientoVersion(res.getString("NOMBRE_ESTADO_PROTOCOLO_MANTENIMIENTO_VERSION"));
                    nuevo.getEstadoRegistro().setCodEstadoRegistro(res.getString("COD_ESTADO_REGISTRO"));
                    nuevo.getEstadoRegistro().setNombreEstadoRegistro(res.getString("NOMBRE_ESTADO_REGISTRO"));
                    nuevo.setNroVersion(res.getInt("NRO_VERSION"));
                    nuevo.getDocumentacion().setCodDocumento(res.getInt("COD_DOCUMENTO"));
                    nuevo.getDocumentacion().setNombreDocumento(res.getString("NOMBRE_DOCUMENTO"));
                    nuevo.getDocumentacion().setCodigoDocumento(res.getString("CODIGO_DOCUMENTO"));
                    nuevo.getDiaSemana().setCodDiaSemana(res.getInt("COD_DIA_SEMANA"));
                    nuevo.getDiaSemana().setNombreDiaSemana(res.getString("NOMBRE_DIA_SEMANA"));
                    nuevo.setNroSemana(res.getInt("NRO_SEMANA_MANTENIMIENTO"));
                    nuevo.getUnidadMedidaTiempo().setCodUnidadMedida(res.getString("COD_UNIDAD_MEDIDA_TIEMPO"));
                    nuevo.getUnidadMedidaTiempo().setNombreUnidadMedida(res.getString("NOMBRE_UNIDAD_MEDIDA"));
                    nuevo.setCantidadTiempo(res.getDouble("CANTIDAD_TIEMPO"));
                    nuevo.setMantenimientoCofar(res.getInt("MANTENIMIENTO_COFAR")>0);
                    nuevo.setMantenimientoExterno(res.getInt("MANTENIMIENTO_EXTERNO")>0);
                    protocoloMantenimientoVersionList.add(nuevo);
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
        
    
        public String codMaquinariaProtocoloMantenimientoAgregar_change()
        {
            
            this.cargarPartesMaquinariaSelectList(protocoloMantenimientoVersionAgregar.getProtocoloMantenimiento().getMaquinaria().getCodMaquina());
            return null;
        }
        private void cargarPartesMaquinariaSelectList(String codMaquina)
        {
            try {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select pm.COD_PARTE_MAQUINA,pm.NOMBRE_PARTE_MAQUINA+' ('+pm.CODIGO+')' as NOMBRE_PARTE_MAQUINA");
                                        consulta.append(" from PARTES_MAQUINARIA pm ");
                                        consulta.append(" where pm.COD_MAQUINA=").append(codMaquina);
                                        consulta.append(" order by pm.NOMBRE_PARTE_MAQUINA");
                LOGGER.debug("consulta cargar partes maquinaria select" + consulta.toString());
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                partesMaquinariaSelectList=new ArrayList<SelectItem>();
                while (res.next()) 
                {
                    partesMaquinariaSelectList.add(new SelectItem(res.getInt("COD_PARTE_MAQUINA"),res.getString("NOMBRE_PARTE_MAQUINA")));
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
        private void cargarMaquinariasSelectList()
        {
            try {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select m.COD_MAQUINA,m.NOMBRE_MAQUINA+' ('+m.CODIGO+')' as nombreMaquinaria");
                                            consulta.append(" from MAQUINARIAS m");
                                            consulta.append(" where m.COD_ESTADO_REGISTRO=1");
                                                    consulta.append(" and m.COD_TIPO_EQUIPO in (2,6)");
                                            consulta.append(" order by m.NOMBRE_MAQUINA");
                LOGGER.debug("consulta cargar maquinarias select" + consulta.toString());
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                maquinariasSelectList=new ArrayList<SelectItem>();
                while (res.next()) 
                {
                    maquinariasSelectList.add(new SelectItem(res.getString("COD_MAQUINA"),res.getString("nombreMaquinaria")));
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
        public String guardarAgregarProtocoloMantenimiento_action()throws SQLException
        {
            mensaje = "";
            try 
            {
                con = Util.openConnection(con);
                con.setAutoCommit(false);
                StringBuilder consulta = new StringBuilder("INSERT INTO PROTOCOLO_MANTENIMIENTO(COD_MAQUINARIA,COD_PARTE_MAQUINARIA)");
                                    consulta.append(" VALUES (");
                                            consulta.append("?,");//cod maquinaria
                                            consulta.append("?");//cod parte maquinaria
                                    consulta.append(")");
                LOGGER.debug("consulta registrar protocolo mantenimiento " + consulta.toString());
                PreparedStatement pst = con.prepareStatement(consulta.toString(), PreparedStatement.RETURN_GENERATED_KEYS);
                pst.setString(1,protocoloMantenimientoVersionAgregar.getProtocoloMantenimiento().getMaquinaria().getCodMaquina());LOGGER.info(" p1: "+protocoloMantenimientoVersionAgregar.getProtocoloMantenimiento().getMaquinaria().getCodMaquina());
                pst.setInt(2,protocoloMantenimientoVersionAgregar.getProtocoloMantenimiento().getPartesMaquinaria().getCodParteMaquina());LOGGER.info(" p3: "+protocoloMantenimientoVersionAgregar.getProtocoloMantenimiento().getPartesMaquinaria().getCodParteMaquina());
                if (pst.executeUpdate() > 0) LOGGER.info("se registro el protocolo de mantenimiento ");
                ResultSet res=pst.getGeneratedKeys();
                if(res.next())protocoloMantenimientoVersionAgregar.getProtocoloMantenimiento().setCodProtocoloMantenimiento(res.getInt(1));
                consulta=new StringBuilder("INSERT INTO PROTOCOLO_MANTENIMIENTO_VERSION(COD_TIPO_MANTENIMIENTO_MAQUINARIA, DESCRIPCION_PROTOCOLO_MANTENIMIENTO,COD_PROTOCOLO_MANTENIMIENTO, NRO_VERSION,COD_ESTADO_PROTOCOLO_MANTENIMIENTO_VERSION,COD_ESTADO_REGISTRO,COD_TIPO_FRECUENCIA_MANTENIMIENTO,COD_DOCUMENTO,COD_UNIDAD_MEDIDA_TIEMPO,COD_DIA_SEMANA,CANTIDAD_TIEMPO,NRO_SEMANA_MANTENIMIENTO,MANTENIMIENTO_COFAR,MANTENIMIENTO_EXTERNO)");
                            consulta.append(" VALUES (");
                                    consulta.append("?,");//cod tipo mantenimiento
                                    consulta.append("?,");//descripcion protocolo mantenimiento
                                    consulta.append(protocoloMantenimientoVersionAgregar.getProtocoloMantenimiento().getCodProtocoloMantenimiento()).append(",");
                                    consulta.append("1,");//version nro 1
                                    consulta.append("3,");//estado nueva version protocolo
                                    consulta.append("1,");//ESTADO REGISTRO
                                    consulta.append(protocoloMantenimientoVersionAgregar.getTiposFrecuenciaMantenimiento().getCodTipoFrecuenciaMantenimiento()).append(",");
                                    consulta.append(protocoloMantenimientoVersionAgregar.getDocumentacion().getCodDocumento()).append(",");
                                    consulta.append(protocoloMantenimientoVersionAgregar.getUnidadMedidaTiempo().getCodUnidadMedida()).append(",");
                                    consulta.append(protocoloMantenimientoVersionAgregar.getDiaSemana().getCodDiaSemana()).append(",");
                                    consulta.append("?").append(",");
                                    consulta.append("?").append(",");
                                    consulta.append(protocoloMantenimientoVersionAgregar.getMantenimientoCofar()?1:0).append(",");
                                    consulta.append(protocoloMantenimientoVersionAgregar.getMantenimientoExterno()?1:0);
                            consulta.append(")");
                LOGGER.debug("consulta registrar protocolo mantenimiento agregar "+consulta.toString());
                pst=con.prepareStatement(consulta.toString());
                pst.setInt(1,protocoloMantenimientoVersionAgregar.getTiposMantenimientoMaquinaria().getCodTipoMantenimientoMaquinaria());LOGGER.info(" p1: "+protocoloMantenimientoVersionAgregar.getTiposMantenimientoMaquinaria().getCodTipoMantenimientoMaquinaria());
                pst.setString(2,protocoloMantenimientoVersionAgregar.getDescripcionProtocoloMantenimientoVersion());LOGGER.info(" p2: "+protocoloMantenimientoVersionAgregar.getDescripcionProtocoloMantenimientoVersion());
                pst.setDouble(3,protocoloMantenimientoVersionAgregar.getCantidadTiempo());LOGGER.info(" p3: "+protocoloMantenimientoVersionAgregar.getCantidadTiempo());
                pst.setInt(4,protocoloMantenimientoVersionAgregar.getNroSemana());LOGGER.info(" p4: "+protocoloMantenimientoVersionAgregar.getNroSemana());
                if(pst.executeUpdate()>0)LOGGER.info("se registro el protocolo version");
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
        public String getCargarAgregarProtocoloMantenimiento()
        {
            protocoloMantenimientoVersionAgregar=new ProtocoloMantenimientoVersion();
            protocoloMantenimientoVersionAgregar.getDiaSemana().setCodDiaSemana(1);
            return null;
        }
        private void cargarTiposMantenimientoMaquinaria()
        {
            try 
            {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select tmm.COD_TIPO_MANTENIMIENTO_MAQUINARIA,tmm.NOMBRE_TIPO_MANTENIMIENTO_MAQUINARIA");
                                            consulta.append(" from TIPOS_MANTENIMIENTO_MAQUINARIA tmm ");
                                            consulta.append(" where tmm.COD_ESTADO_REGISTRO=1");
                                            consulta.append(" order by tmm.NOMBRE_TIPO_MANTENIMIENTO_MAQUINARIA");
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                tiposMantenimientoMaquinariaSelectList=new ArrayList<SelectItem>();
                while (res.next()) 
                {
                    tiposMantenimientoMaquinariaSelectList.add(new SelectItem(res.getInt("COD_TIPO_MANTENIMIENTO_MAQUINARIA"),res.getString("NOMBRE_TIPO_MANTENIMIENTO_MAQUINARIA")));
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
        
        private void cargarProtocolosMantenimientoList()
        {
            try {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select pm.COD_PROTOCOLO_MANTENIMIENTO,pm.COD_MAQUINARIA,pm.COD_PARTE_MAQUINARIA,");
                                                    consulta.append(" m.NOMBRE_MAQUINA,m.CODIGO as codigoMaquinaria,pmm.NOMBRE_PARTE_MAQUINA,pmm.CODIGO,pmv.COD_PROTOCOLO_MANTENIMIENTO_VERSION,");
                                                    consulta.append(" tmm.NOMBRE_TIPO_MANTENIMIENTO_MAQUINARIA,tmm.COD_TIPO_MANTENIMIENTO_MAQUINARIA,er.COD_ESTADO_REGISTRO,er.NOMBRE_ESTADO_REGISTRO");
                                                    consulta.append(" ,pmv.DESCRIPCION_PROTOCOLO_MANTENIMIENTO,epmv.COD_ESTADO_PROTOCOLO_MANTENIMIENTO_VERSION,epmv.NOMBRE_ESTADO_PROTOCOLO_MANTENIMIENTO_VERSION");
                                                    consulta.append(" ,tfm.COD_TIPO_FRECUENCIA_MANTENIMIENTO,tfm.NOMBRE_TIPO_FRECUENCIA_MANTENIMIENTO,pmv.COD_UNIDAD_MEDIDA_TIEMPO");
                                                    consulta.append(" ,pmv.COD_DOCUMENTO,d.NOMBRE_DOCUMENTO,d.CODIGO_DOCUMENTO,pmv.COD_DIA_SEMANA,ds.NOMBRE_DIA_SEMANA,pmv.NRO_SEMANA_MANTENIMIENTO,pmv.CANTIDAD_TIEMPO,um.NOMBRE_UNIDAD_MEDIDA");
                                                    consulta.append(" ,pmv.MANTENIMIENTO_COFAR,pmv.MANTENIMIENTO_EXTERNO");
                                            consulta.append(" from PROTOCOLO_MANTENIMIENTO pm");
                                                    consulta.append(" inner join PROTOCOLO_MANTENIMIENTO_VERSION pmv on pmv.COD_PROTOCOLO_MANTENIMIENTO=pm.COD_PROTOCOLO_MANTENIMIENTO");
                                                    consulta.append(" inner join MAQUINARIAS m on m.COD_MAQUINA = pm.COD_MAQUINARIA");
                                                    consulta.append(" left outer join PARTES_MAQUINARIA pmm on pmm.COD_PARTE_MAQUINA =pm.COD_PARTE_MAQUINARIA");
                                                    consulta.append(" inner join TIPOS_MANTENIMIENTO_MAQUINARIA tmm on tmm.COD_TIPO_MANTENIMIENTO_MAQUINARIA =pmv.COD_TIPO_MANTENIMIENTO_MAQUINARIA");
                                                    consulta.append(" inner join ESTADOS_REFERENCIALES er on er.COD_ESTADO_REGISTRO=pmv.COD_ESTADO_REGISTRO");
                                                    consulta.append(" inner join ESTADOS_PROTOCOLO_MANTENIMIENTO_VERSION epmv on epmv.COD_ESTADO_PROTOCOLO_MANTENIMIENTO_VERSION=pmv.COD_ESTADO_PROTOCOLO_MANTENIMIENTO_VERSION");
                                                    consulta.append(" inner join TIPOS_FRECUENCIA_MANTENIMIENTO tfm on tfm.COD_TIPO_FRECUENCIA_MANTENIMIENTO=pmv.COD_TIPO_FRECUENCIA_MANTENIMIENTO");
                                                    consulta.append(" left outer join DOCUMENTACION d on d.COD_DOCUMENTO=pmv.COD_DOCUMENTO");
                                                    consulta.append(" left outer join DIAS_SEMANA ds on ds.COD_DIA_SEMANA=pmv.COD_DIA_SEMANA");
                                                    consulta.append(" left outer join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=pmv.COD_UNIDAD_MEDIDA_TIEMPO");
                                            consulta.append(" WHERE pmv.COD_ESTADO_PROTOCOLO_MANTENIMIENTO_VERSION in (2,3) ");//activos y protocolos nuevos
                                                    if(!protocoloMantenimientoVersionBuscar.getProtocoloMantenimiento().getMaquinaria().getCodMaquina().equals("0"))
                                                        consulta.append(" and pm.COD_MAQUINARIA=").append(protocoloMantenimientoVersionBuscar.getProtocoloMantenimiento().getMaquinaria().getCodMaquina());
                                                    if(protocoloMantenimientoVersionBuscar.getDescripcionProtocoloMantenimientoVersion().length()>0)
                                                        consulta.append(" and pmv.DESCRIPCION_PROTOCOLO_MANTENIMIENTO like '%").append(protocoloMantenimientoVersionBuscar.getDescripcionProtocoloMantenimientoVersion()).append("%'");
                                                    if(protocoloMantenimientoVersionBuscar.getTiposMantenimientoMaquinaria().getCodTipoMantenimientoMaquinaria()>0)
                                                        consulta.append(" and pmv.COD_TIPO_MANTENIMIENTO_MAQUINARIA=").append(protocoloMantenimientoVersionBuscar.getTiposMantenimientoMaquinaria().getCodTipoMantenimientoMaquinaria());
                                                    if(protocoloMantenimientoVersionBuscar.getTiposFrecuenciaMantenimiento().getCodTipoFrecuenciaMantenimiento()>0)
                                                        consulta.append(" and  pmv.COD_TIPO_FRECUENCIA_MANTENIMIENTO=").append(protocoloMantenimientoVersionBuscar.getTiposFrecuenciaMantenimiento().getCodTipoFrecuenciaMantenimiento());
                                            consulta.append(" order by m.NOMBRE_MAQUINA,pmm.NOMBRE_PARTE_MAQUINA");
                LOGGER.debug("consulta cargar protocolo mantenimiento " + consulta.toString());
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                protocoloMantenimientoList=new ArrayList<ProtocoloMantenimientoVersion>();
                while (res.next()) 
                {
                    ProtocoloMantenimientoVersion nuevo=new ProtocoloMantenimientoVersion();
                    nuevo.getProtocoloMantenimiento().setCodProtocoloMantenimiento(res.getInt("COD_PROTOCOLO_MANTENIMIENTO"));
                    nuevo.getProtocoloMantenimiento().getMaquinaria().setCodMaquina(res.getString("COD_MAQUINARIA"));
                    nuevo.getProtocoloMantenimiento().getMaquinaria().setCodigo(res.getString("codigoMaquinaria"));
                    nuevo.getProtocoloMantenimiento().getMaquinaria().setNombreMaquina(res.getString("NOMBRE_MAQUINA"));
                    nuevo.getProtocoloMantenimiento().getPartesMaquinaria().setCodParteMaquina(res.getInt("COD_PARTE_MAQUINARIA"));
                    nuevo.getProtocoloMantenimiento().getPartesMaquinaria().setCodigo(res.getString("CODIGO"));
                    nuevo.getProtocoloMantenimiento().getPartesMaquinaria().setNombreParteMaquina(res.getString("NOMBRE_PARTE_MAQUINA"));
                    nuevo.setDescripcionProtocoloMantenimientoVersion(res.getString("DESCRIPCION_PROTOCOLO_MANTENIMIENTO"));
                    nuevo.getTiposMantenimientoMaquinaria().setCodTipoMantenimientoMaquinaria(res.getInt("COD_TIPO_MANTENIMIENTO_MAQUINARIA"));
                    nuevo.getTiposMantenimientoMaquinaria().setNombreTipoMantenimientoMaquinaria(res.getString("NOMBRE_TIPO_MANTENIMIENTO_MAQUINARIA"));
                    nuevo.getTiposFrecuenciaMantenimiento().setCodTipoFrecuenciaMantenimiento(res.getInt("COD_TIPO_FRECUENCIA_MANTENIMIENTO"));
                    nuevo.getTiposFrecuenciaMantenimiento().setNombreTipoFrecuenciaMantenimiento(res.getString("NOMBRE_TIPO_FRECUENCIA_MANTENIMIENTO"));
                    nuevo.getEstadosProtocoloMantenimientoVersion().setCodEstadoProtocoloMantenimientoVersion(res.getInt("COD_ESTADO_PROTOCOLO_MANTENIMIENTO_VERSION"));
                    nuevo.getEstadosProtocoloMantenimientoVersion().setNombreEstadoProtocoloMantenimientoVersion(res.getString("NOMBRE_ESTADO_PROTOCOLO_MANTENIMIENTO_VERSION"));
                    nuevo.getDocumentacion().setCodDocumento(res.getInt("COD_DOCUMENTO"));
                    nuevo.getDocumentacion().setNombreDocumento(res.getString("NOMBRE_DOCUMENTO"));
                    nuevo.getDocumentacion().setCodigoDocumento(res.getString("CODIGO_DOCUMENTO"));
                    nuevo.getDiaSemana().setCodDiaSemana(res.getInt("COD_DIA_SEMANA"));
                    nuevo.getDiaSemana().setNombreDiaSemana(res.getString("NOMBRE_DIA_SEMANA"));
                    nuevo.setNroSemana(res.getInt("NRO_SEMANA_MANTENIMIENTO"));
                    nuevo.getUnidadMedidaTiempo().setCodUnidadMedida(res.getString("COD_UNIDAD_MEDIDA_TIEMPO"));
                    nuevo.getUnidadMedidaTiempo().setNombreUnidadMedida(res.getString("NOMBRE_UNIDAD_MEDIDA"));
                    nuevo.setCantidadTiempo(res.getDouble("CANTIDAD_TIEMPO"));
                    nuevo.setMantenimientoCofar(res.getInt("MANTENIMIENTO_COFAR")>0);
                    nuevo.setMantenimientoExterno(res.getInt("MANTENIMIENTO_EXTERNO")>0);
                    protocoloMantenimientoList.add(nuevo);
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
        public String buscarProtocoloMantenimientoList_action()
        {
            this.cargarProtocolosMantenimientoList();
            return null;
        }
        public String getCargarProtocolosMantenimientoList()
        {
            this.cargarDocumentacionSelectList();
            this.cargarUnidadesMedidadTiempoSelectList();
            this.cargarTiposFrecuenciaMantenimientoSelectList();
            this.cargarMaquinariasSelectList();
            this.cargarProtocolosMantenimientoList();
            this.cargarTiposMantenimientoMaquinaria();
            this.cargarDiasSemanaSelectList();
            return null;
        }
    //</editor-fold>
        
        
    //<editor-fold desc="funciones para administracion de materiales" defaultstate="collapsed">
        public String editarProtocoloMantenimientoDetalleMaterial_action()
        {
            for(ProtocoloMantenimientoVersionDetalleMateriales bean:protocoloMantenimientoVersionDetalleMaterialList)
            {
                if(bean.getChecked())
                {
                    protocoloMantenimientoVersionDetalleMaterialEditar=bean;
                    break;
                }
            }
            return null;
        }
        public String guardarEditarProtocoloMantenimientoDetalleMaterial_action()throws SQLException
        {
            mensaje = "";
            try {
                con = Util.openConnection(con);
                con.setAutoCommit(false);
                StringBuilder consulta = new StringBuilder(" update PROTOCOLO_MANTENIMIENTO_VERSION_DETALLE_MATERIALES");
                                            consulta.append(" set CANTIDAD_MATERIAL=?");
                                            consulta.append(" where COD_PROTOCOLO_MANTENIMIENTO_VERSION_DETALLE_MATERIALES=").append(protocoloMantenimientoVersionDetalleMaterialEditar.getCodProtocoloMantenimientoVersionDetalleMaterial());
                LOGGER.debug("consulta guardar edicion detalle material " + consulta.toString());
                PreparedStatement pst = con.prepareStatement(consulta.toString());
                pst.setDouble(1,protocoloMantenimientoVersionDetalleMaterialEditar.getCantidadMaterial());LOGGER.info("p1: "+protocoloMantenimientoVersionDetalleMaterialEditar.getCantidadMaterial());
                if (pst.executeUpdate() > 0)LOGGER.info("se guardo la edicion del material");
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
            if(mensaje.equals("1"))
            {
                this.cargarProtocoloMantenimientoVersionDetalleMaterialesList();
            }
            return null;
        }
        public String guardarAgregarProtocoloMantenimientoDetalleMateriales_action()throws SQLException
        {
            mensaje = "";
            try 
            {
                con = Util.openConnection(con);
                con.setAutoCommit(false);
                StringBuilder consulta = new StringBuilder(" INSERT INTO PROTOCOLO_MANTENIMIENTO_VERSION_DETALLE_MATERIALES(COD_PROTOCOLO_MANTENIMIENTO_VERSION, COD_UNIDAD_MEDIDA, COD_MATERIAL,CANTIDAD_MATERIAL)");
                                            consulta.append(" VALUES (");
                                                    consulta.append(protocoloMantenimientoVersionBean.getCodProtocoloMantenimientoVersion()).append(",");
                                                    consulta.append("?,");//cod unidad medida
                                                    consulta.append("?,");//cod material
                                                    consulta.append("?");//cantidad material
                                            consulta.append(")");
                LOGGER.debug("consulta registrar protocolo mantenimiento version " + consulta.toString());
                PreparedStatement pst = con.prepareStatement(consulta.toString());
                for(ProtocoloMantenimientoVersionDetalleMateriales bean:protocoloMantenimientoVersionDetalleMaterialesAgregarList)
                {
                    if(bean.getChecked())
                    {
                        pst.setString(1,bean.getUnidadesMedida().getCodUnidadMedida());LOGGER.info("p1: "+protocoloMantenimientoVersionDetalleMaterialAgregar.getMateriales().getUnidadesMedida().getCodUnidadMedida());
                        pst.setString(2,bean.getMateriales().getCodMaterial());LOGGER.info("p2: "+protocoloMantenimientoVersionDetalleMaterialAgregar.getMateriales().getCodMaterial());
                        pst.setDouble(3,bean.getCantidadMaterial());LOGGER.info("p3: "+protocoloMantenimientoVersionDetalleMaterialAgregar.getCantidadMaterial());
                        if(pst.executeUpdate()>0)LOGGER.info("se registro el detalle material protocolo");
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
            if(mensaje.equals("1"))
            {
                this.cargarProtocoloMantenimientoVersionDetalleMaterialesList();
            }
            return null;
        }
        public String buscarMaterialesAgregarList_action()
        {
            try {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select m.COD_MATERIAL,m.NOMBRE_MATERIAL,g.NOMBRE_GRUPO,c.NOMBRE_CAPITULO,");
                                                    consulta.append(" m.COD_UNIDAD_MEDIDA,um.NOMBRE_UNIDAD_MEDIDA");
                                            consulta.append(" from MATERIALES m");
                                                    consulta.append(" inner join GRUPOS g on g.COD_GRUPO = m.COD_GRUPO");
                                                    consulta.append(" inner join CAPITULOS c on c.COD_CAPITULO = g.COD_CAPITULO");
                                                    consulta.append(" inner join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA = m.COD_UNIDAD_MEDIDA");
                                                    consulta.append(" left outer join PROTOCOLO_MANTENIMIENTO_VERSION_DETALLE_MATERIALES pmdm on pmdm.COD_MATERIAL=m.COD_MATERIAL");
                                                            consulta.append(" and pmdm.COD_PROTOCOLO_MANTENIMIENTO_VERSION=").append(protocoloMantenimientoVersionBean.getCodProtocoloMantenimientoVersion());
                                            consulta.append(" where g.COD_CAPITULO in (22, 18)");
                                                    consulta.append(" and m.COD_ESTADO_REGISTRO = 1");
                                                    consulta.append(" and m.MOVIMIENTO_ITEM = 1");
                                                    consulta.append(" and m.NOMBRE_MATERIAL like ?");
                                                    consulta.append(" and pmdm.COD_MATERIAL is null");
                                            consulta.append(" ORDER BY m.NOMBRE_MATERIAL");
                LOGGER.debug("consulta buscar material " + consulta.toString());
                PreparedStatement pst=con.prepareStatement(consulta.toString());
                pst.setString(1,"%"+protocoloMantenimientoVersionDetalleMaterialAgregar.getMateriales().getNombreMaterial()+"%");LOGGER.info(" p1: "+protocoloMantenimientoVersionDetalleMaterialAgregar.getMateriales().getNombreMaterial());
                ResultSet res = pst.executeQuery();
                protocoloMantenimientoVersionDetalleMaterialesAgregarList =new ArrayList<ProtocoloMantenimientoVersionDetalleMateriales>();
                while (res.next()) 
                {
                    ProtocoloMantenimientoVersionDetalleMateriales nuevo=new ProtocoloMantenimientoVersionDetalleMateriales();
                    nuevo.getMateriales().setCodMaterial(res.getString("COD_MATERIAL"));
                    nuevo.getMateriales().setNombreMaterial(res.getString("NOMBRE_MATERIAL"));
                    nuevo.getMateriales().getGrupo().setNombreGrupo(res.getString("NOMBRE_GRUPO"));
                    nuevo.getMateriales().getGrupo().getCapitulo().setNombreCapitulo(res.getString("NOMBRE_CAPITULO"));
                    nuevo.getUnidadesMedida().setCodUnidadMedida(res.getString("COD_UNIDAD_MEDIDA"));
                    nuevo.getUnidadesMedida().setNombreUnidadMedida(res.getString("NOMBRE_UNIDAD_MEDIDA"));
                    protocoloMantenimientoVersionDetalleMaterialesAgregarList.add(nuevo);
                }
                res.close();
                pst.close();
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
            return null;
        }
        public String seleccionarProtocoloMantenimientoVersionBean_action()
        {
            protocoloMantenimientoVersionBean=(ProtocoloMantenimientoVersion)protocoloMantenimientoVersionDataTable.getRowData();
            return null;
        }
        public String getCargarProtocoloMantenimientoVersionDetalleManterialesList()
        {
            this.cargarProtocoloMantenimientoVersionDetalleMaterialesList();
            return null;
        }
        public String eliminarProtocoloMantenimientoDetalleMateriales_action()throws SQLException
        {
            mensaje="";
            for(ProtocoloMantenimientoVersionDetalleMateriales bean:protocoloMantenimientoVersionDetalleMaterialList)
            {
                if(bean.getChecked())
                {
                    mensaje = "";
                    try {
                        con = Util.openConnection(con);
                        con.setAutoCommit(false);
                        StringBuilder consulta = new StringBuilder("delete PROTOCOLO_MANTENIMIENTO_VERSION_DETALLE_MATERIALES");
                                                consulta.append(" where COD_PROTOCOLO_MANTENIMIENTO_VERSION_DETALLE_MATERIALES=").append(bean.getCodProtocoloMantenimientoVersionDetalleMaterial());
                        LOGGER.debug("consulta eliminar material protocolo manteniento " + consulta.toString());
                        PreparedStatement pst = con.prepareStatement(consulta.toString());
                        if (pst.executeUpdate() > 0) LOGGER.info("se elimino el protocolo mantenimiento detalle material");
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
                    break;
                }
            }
            if(mensaje.equals("1"))
            {
                this.cargarProtocoloMantenimientoVersionDetalleMaterialesList();
            }
            return null;
        }
        
        public String agregarMaterialProtocoloMantenimientoVersionDetalleMaterial_action()
        {
            protocoloMantenimientoVersionDetalleMaterialesAgregarList=new ArrayList<ProtocoloMantenimientoVersionDetalleMateriales>();
            protocoloMantenimientoVersionDetalleMaterialAgregar=new ProtocoloMantenimientoVersionDetalleMateriales();
            return null;
        }
        private void cargarProtocoloMantenimientoVersionDetalleMaterialesList()
        {
            try {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select m.COD_MATERIAL,m.NOMBRE_MATERIAL,um.COD_UNIDAD_MEDIDA,um.NOMBRE_UNIDAD_MEDIDA,g.NOMBRE_GRUPO,c.NOMBRE_CAPITULO,");
                                                    consulta.append(" pmm.CANTIDAD_MATERIAL,pmm.COD_PROTOCOLO_MANTENIMIENTO_VERSION_DETALLE_MATERIALES");
                                            consulta.append(" from PROTOCOLO_MANTENIMIENTO_VERSION_DETALLE_MATERIALES pmm");
                                                    consulta.append(" inner join MATERIALES m on m.COD_MATERIAL=pmm.COD_MATERIAL");
                                                    consulta.append(" inner join GRUPOS g on g.COD_GRUPO = m.COD_GRUPO");
                                                    consulta.append(" inner join CAPITULOS c on c.COD_CAPITULO = g.COD_CAPITULO");
                                                    consulta.append(" inner join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=pmm.COD_UNIDAD_MEDIDA");
                                            consulta.append(" where pmm.COD_PROTOCOLO_MANTENIMIENTO_VERSION=").append(protocoloMantenimientoVersionBean.getCodProtocoloMantenimientoVersion());
                                            consulta.append(" order by m.NOMBRE_MATERIAL    ");
                LOGGER.debug("consulta cargar protocolo mantenimiento version " + consulta.toString());
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                protocoloMantenimientoVersionDetalleMaterialList=new ArrayList<ProtocoloMantenimientoVersionDetalleMateriales>();
                while (res.next()) 
                {
                    ProtocoloMantenimientoVersionDetalleMateriales nuevo=new ProtocoloMantenimientoVersionDetalleMateriales();
                    nuevo.setCodProtocoloMantenimientoVersionDetalleMaterial(res.getInt("COD_PROTOCOLO_MANTENIMIENTO_VERSION_DETALLE_MATERIALES"));
                    nuevo.getMateriales().setCodMaterial(res.getString("COD_MATERIAL"));
                    nuevo.getMateriales().setNombreMaterial(res.getString("NOMBRE_MATERIAL"));
                    nuevo.getMateriales().getGrupo().setNombreGrupo(res.getString("NOMBRE_GRUPO"));
                    nuevo.getMateriales().getGrupo().getCapitulo().setNombreCapitulo(res.getString("NOMBRE_CAPITULO"));
                    nuevo.getUnidadesMedida().setCodUnidadMedida(res.getString("COD_UNIDAD_MEDIDA"));
                    nuevo.getUnidadesMedida().setNombreUnidadMedida(res.getString("NOMBRE_UNIDAD_MEDIDA"));
                    nuevo.setCantidadMaterial(res.getDouble("CANTIDAD_MATERIAL"));
                    protocoloMantenimientoVersionDetalleMaterialList.add(nuevo);
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
        
    //<editor-fold desc="funciones para administracion de tareas" defaultstate="collapsed">
        private void cargarTiposTareaSelectList()
        {
            try {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select tt.COD_TIPO_TAREA,tt.NOMBRE_TIPO_TAREA");
                                            consulta.append(" from TIPOS_TAREA tt ");
                                            consulta.append(" where tt.COD_ESTADO_REGISTRO=1");
                                            consulta.append(" order by tt.NOMBRE_TIPO_TAREA");
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                tiposTareaSelectList=new ArrayList<SelectItem>();
                while (res.next()) 
                {
                    tiposTareaSelectList.add(new SelectItem(res.getInt("COD_TIPO_TAREA"),res.getString("NOMBRE_TIPO_TAREA")));
                    
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
        public String getCargarProtocoloMantenimientoVersionDetalleTareaList()
        {
            this.cargarProtocoloMantenimientoVersionDetalleTareasList();
            this.cargarTiposTareaSelectList();
            return null;
        }
        public String editarProtocoloMantenimientoVersionDetalleTarea_action()
        {
            for(ProtocoloMantenimientoVersionDetalleTareas bean:protocoloMantenimientoVersionDetalleTareaList)
            {
                if(bean.getChecked())
                {
                    protocoloMantenimientoVersionDetalleTareaEditar=bean;
                    break;
                }
            }
            return null;
        }
        public String guardarEditarProtocoloMantenimentoVersionDetalleTarea_action()throws SQLException
        {
            mensaje = "";
            try {
                con = Util.openConnection(con);
                con.setAutoCommit(false);
                StringBuilder consulta = new StringBuilder("UPDATE PROTOCOLO_MANTENIMIENTO_VERSION_DETALLE_TAREAS");
                                        consulta.append(" SET COD_TIPO_TAREA =").append(protocoloMantenimientoVersionDetalleTareaEditar.getTiposTarea().getCodTipoTarea()).append(",");
                                        consulta.append(" DESCRIPCION_TAREA = ?,");//descripcion tarea
                                        consulta.append(" HORAS_STANDAR = ?,");
                                        consulta.append(" NRO_TAREA =").append(protocoloMantenimientoVersionDetalleTareaEditar.getNroTarea());
                                        consulta.append(" WHERE COD_PROTOCOLO_MANTENIMIENTO_VERSION_DETALLE_TAREAS =").append(protocoloMantenimientoVersionDetalleTareaEditar.getCodProtocoloMantenimientoVersionDetalleTareas());
                LOGGER.debug("consulta guardar edicion protocolo mantenimiento detalle tarea" + consulta.toString());
                PreparedStatement pst = con.prepareStatement(consulta.toString());
                pst.setString(1,protocoloMantenimientoVersionDetalleTareaEditar.getDescripcionTarea());LOGGER.info("p1: "+protocoloMantenimientoVersionDetalleTareaEditar.getDescripcionTarea());
                pst.setDouble(2,protocoloMantenimientoVersionDetalleTareaEditar.getHorasStandar());LOGGER.info("p2: "+protocoloMantenimientoVersionDetalleTareaEditar.getHorasStandar());
                if (pst.executeUpdate() > 0) LOGGER.info("se guardo la edicion del detalle de tareas");
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
            if(mensaje.equals("1"))
            {
                this.cargarProtocoloMantenimientoVersionDetalleTareasList();
            }
            return null;
        }
        public String eliminarProtocoloMantenimientoVersionDetalleTareas_action()throws SQLException
        {
            mensaje="";
            for(ProtocoloMantenimientoVersionDetalleTareas bean:protocoloMantenimientoVersionDetalleTareaList)
            {
                if(bean.getChecked())
                {
                    try {
                        con = Util.openConnection(con);
                        con.setAutoCommit(false);
                        StringBuilder consulta = new StringBuilder(" DELETE PROTOCOLO_MANTENIMIENTO_VERSION_DETALLE_TAREAS");
                                                consulta.append(" WHERE COD_PROTOCOLO_MANTENIMIENTO_VERSION_DETALLE_TAREAS =").append(bean.getCodProtocoloMantenimientoVersionDetalleTareas());
                        LOGGER.debug("consulta eliminar protocolo mantenimiento detalle tareas " + consulta.toString());
                        PreparedStatement pst = con.prepareStatement(consulta.toString());
                        if (pst.executeUpdate() > 0) LOGGER.info("se elimino el protocolo mantenimiento detalle tareas ");
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
                this.cargarProtocoloMantenimientoVersionDetalleTareasList();
            }
            return null;
        }
        public String agregarProtocoloMantenimientoVersionDetalleTarea_action()
        {
            protocoloMantenimientoVersionDetalleTareaAgregar=new ProtocoloMantenimientoVersionDetalleTareas();
            try {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select isnull(max(p.NRO_TAREA),0)+1 as nroTarea");
                                            consulta.append(" from PROTOCOLO_MANTENIMIENTO_VERSION_DETALLE_TAREAS p");
                                            consulta.append(" where p.COD_PROTOCOLO_MANTENIMIENTO_VERSION=").append(protocoloMantenimientoVersionBean.getCodProtocoloMantenimientoVersion());
                LOGGER.debug("consulta cargar " + consulta.toString());
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                if (res.next()) {
                    protocoloMantenimientoVersionDetalleTareaAgregar.setNroTarea(res.getInt("nroTarea"));
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
        
        public String guardarAgregarProtocoloMantenimientoVersionDetalleTarea_action()throws SQLException
        {
            mensaje = "";
            try {
                con = Util.openConnection(con);
                con.setAutoCommit(false);
                StringBuilder consulta = new StringBuilder("INSERT INTO PROTOCOLO_MANTENIMIENTO_VERSION_DETALLE_TAREAS(COD_PROTOCOLO_MANTENIMIENTO_VERSION, COD_TIPO_TAREA, DESCRIPCION_TAREA,HORAS_STANDAR, NRO_TAREA)");
                                        consulta.append(" VALUES (");
                                                consulta.append(protocoloMantenimientoVersionBean.getCodProtocoloMantenimientoVersion()).append(",");
                                                consulta.append(protocoloMantenimientoVersionDetalleTareaAgregar.getTiposTarea().getCodTipoTarea()).append(",");
                                                consulta.append("?,");//descripcion tarea
                                                consulta.append("?,");//horas estandar
                                                consulta.append(protocoloMantenimientoVersionDetalleTareaAgregar.getNroTarea());
                                        consulta.append(")");
                LOGGER.debug("consulta registrar protocolo mantenimieto detalle tareas " + consulta.toString());
                PreparedStatement pst = con.prepareStatement(consulta.toString());
                pst.setString(1,protocoloMantenimientoVersionDetalleTareaAgregar.getDescripcionTarea());LOGGER.info("p1: "+protocoloMantenimientoVersionDetalleTareaAgregar.getDescripcionTarea());
                pst.setDouble(2,protocoloMantenimientoVersionDetalleTareaAgregar.getHorasStandar());LOGGER.info("p2: "+protocoloMantenimientoVersionDetalleTareaAgregar.getHorasStandar());
                if (pst.executeUpdate() > 0) LOGGER.info("se registro el protocolo de mantenimiento ");
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
            if(mensaje.equals("1"))
            {
                this.cargarProtocoloMantenimientoVersionDetalleTareasList();
            }
            return null;
        }
        private void cargarProtocoloMantenimientoVersionDetalleTareasList()
        {
            try {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select pmvdt.COD_PROTOCOLO_MANTENIMIENTO_VERSION_DETALLE_TAREAS,pmvdt.NRO_TAREA,");
                                                    consulta.append(" pmvdt.COD_TIPO_TAREA,tt.NOMBRE_TIPO_TAREA,pmvdt.DESCRIPCION_TAREA,pmvdt.HORAS_STANDAR");
                                            consulta.append(" from PROTOCOLO_MANTENIMIENTO_VERSION_DETALLE_TAREAS pmvdt");
                                                    consulta.append(" inner join TIPOS_TAREA tt on tt.COD_TIPO_TAREA=pmvdt.COD_TIPO_TAREA");
                                            consulta.append(" where pmvdt.COD_PROTOCOLO_MANTENIMIENTO_VERSION=").append(protocoloMantenimientoVersionBean.getCodProtocoloMantenimientoVersion());
                                            consulta.append(" order by pmvdt.NRO_TAREA");
                LOGGER.debug("consulta cargar  tareas protocolo " + consulta.toString());
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                protocoloMantenimientoVersionDetalleTareaList=new ArrayList<ProtocoloMantenimientoVersionDetalleTareas>();
                while (res.next()) 
                {
                    ProtocoloMantenimientoVersionDetalleTareas nuevo=new ProtocoloMantenimientoVersionDetalleTareas();
                    nuevo.setCodProtocoloMantenimientoVersionDetalleTareas(res.getInt("COD_PROTOCOLO_MANTENIMIENTO_VERSION_DETALLE_TAREAS"));
                    nuevo.setNroTarea(res.getInt("NRO_TAREA"));
                    nuevo.getTiposTarea().setCodTipoTarea(res.getInt("COD_TIPO_TAREA"));
                    nuevo.getTiposTarea().setNombreTipoTarea(res.getString("NOMBRE_TIPO_TAREA"));
                    nuevo.setDescripcionTarea(res.getString("DESCRIPCION_TAREA"));
                    nuevo.setHorasStandar(res.getDouble("HORAS_STANDAR"));
                    protocoloMantenimientoVersionDetalleTareaList.add(nuevo);
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
        

    //<editor-fold desc="getter and setter" defaultstate="collapsed">

        public List<ProtocoloMantenimientoVersionDetalleTareas> getProtocoloMantenimientoVersionDetalleTareaList() {
            return protocoloMantenimientoVersionDetalleTareaList;
        }

        public void setProtocoloMantenimientoVersionDetalleTareaList(List<ProtocoloMantenimientoVersionDetalleTareas> protocoloMantenimientoVersionDetalleTareaList) {
            this.protocoloMantenimientoVersionDetalleTareaList = protocoloMantenimientoVersionDetalleTareaList;
        }

        public List<SelectItem> getTiposTareaSelectList() {
            return tiposTareaSelectList;
        }

        public List<SelectItem> getTiposFrecuenciaMantenimientoSelectList() {
            return tiposFrecuenciaMantenimientoSelectList;
        }

        public void setTiposFrecuenciaMantenimientoSelectList(List<SelectItem> tiposFrecuenciaMantenimientoSelectList) {
            this.tiposFrecuenciaMantenimientoSelectList = tiposFrecuenciaMantenimientoSelectList;
        }


        public void setTiposTareaSelectList(List<SelectItem> tiposTareaSelectList) {
            this.tiposTareaSelectList = tiposTareaSelectList;
        }

        public ProtocoloMantenimientoVersionDetalleTareas getProtocoloMantenimientoVersionDetalleTareaAgregar() {
            return protocoloMantenimientoVersionDetalleTareaAgregar;
        }

        public void setProtocoloMantenimientoVersionDetalleTareaAgregar(ProtocoloMantenimientoVersionDetalleTareas protocoloMantenimientoVersionDetalleTareaAgregar) {
            this.protocoloMantenimientoVersionDetalleTareaAgregar = protocoloMantenimientoVersionDetalleTareaAgregar;
        }

        public ProtocoloMantenimientoVersionDetalleTareas getProtocoloMantenimientoVersionDetalleTareaEditar() {
            return protocoloMantenimientoVersionDetalleTareaEditar;
        }

        public void setProtocoloMantenimientoVersionDetalleTareaEditar(ProtocoloMantenimientoVersionDetalleTareas protocoloMantenimientoVersionDetalleTareaEditar) {
            this.protocoloMantenimientoVersionDetalleTareaEditar = protocoloMantenimientoVersionDetalleTareaEditar;
        }

        public ProtocoloMantenimientoVersion getProtocoloMantenimientoVersionBuscar() {
            return protocoloMantenimientoVersionBuscar;
        }

        public void setProtocoloMantenimientoVersionBuscar(ProtocoloMantenimientoVersion protocoloMantenimientoVersionBuscar) {
            this.protocoloMantenimientoVersionBuscar = protocoloMantenimientoVersionBuscar;
        }



        public List<ProtocoloMantenimientoVersionDetalleMateriales> getProtocoloMantenimientoVersionDetalleMaterialList() {
            return protocoloMantenimientoVersionDetalleMaterialList;
        }

        public void setProtocoloMantenimientoVersionDetalleMaterialList(List<ProtocoloMantenimientoVersionDetalleMateriales> protocoloMantenimientoVersionDetalleMaterialList) {
            this.protocoloMantenimientoVersionDetalleMaterialList = protocoloMantenimientoVersionDetalleMaterialList;
        }

        public ProtocoloMantenimientoVersion getProtocoloMantenimientoVersionBean() {
            return protocoloMantenimientoVersionBean;
        }

        public void setProtocoloMantenimientoVersionBean(ProtocoloMantenimientoVersion protocoloMantenimientoVersionBean) {
            this.protocoloMantenimientoVersionBean = protocoloMantenimientoVersionBean;
        }

        public List<ProtocoloMantenimientoVersionDetalleMateriales> getProtocoloMantenimientoVersionDetalleMaterialesAgregarList() {
            return protocoloMantenimientoVersionDetalleMaterialesAgregarList;
        }

        public void setProtocoloMantenimientoVersionDetalleMaterialesAgregarList(List<ProtocoloMantenimientoVersionDetalleMateriales> protocoloMantenimientoVersionDetalleMaterialesAgregarList) {
            this.protocoloMantenimientoVersionDetalleMaterialesAgregarList = protocoloMantenimientoVersionDetalleMaterialesAgregarList;
        }



        public ProtocoloMantenimientoVersionDetalleMateriales getProtocoloMantenimientoVersionDetalleMaterialAgregar() {
            return protocoloMantenimientoVersionDetalleMaterialAgregar;
        }

        public void setProtocoloMantenimientoVersionDetalleMaterialAgregar(ProtocoloMantenimientoVersionDetalleMateriales protocoloMantenimientoVersionDetalleMaterialAgregar) {
            this.protocoloMantenimientoVersionDetalleMaterialAgregar = protocoloMantenimientoVersionDetalleMaterialAgregar;
        }
        
        
        



        public String getMensaje() {
            return mensaje;
        }

        public void setMensaje(String mensaje) {
            this.mensaje = mensaje;
        }

        public List<SelectItem> getTiposMantenimientoMaquinariaSelectList() {
            return tiposMantenimientoMaquinariaSelectList;
        }

        public void setTiposMantenimientoMaquinariaSelectList(List<SelectItem> tiposMantenimientoMaquinariaSelectList) {
            this.tiposMantenimientoMaquinariaSelectList = tiposMantenimientoMaquinariaSelectList;
        }
        
        public List<ProtocoloMantenimientoVersion> getProtocoloMantenimientoList() {
            return protocoloMantenimientoList;
        }

        public void setProtocoloMantenimientoList(List<ProtocoloMantenimientoVersion> protocoloMantenimientoList) {
            this.protocoloMantenimientoList = protocoloMantenimientoList;
        }

        public ProtocoloMantenimientoVersion getProtocoloMantenimientoVersionAgregar() {
            return protocoloMantenimientoVersionAgregar;
        }

        public void setProtocoloMantenimientoVersionAgregar(ProtocoloMantenimientoVersion protocoloMantenimientoVersionAgregar) {
            this.protocoloMantenimientoVersionAgregar = protocoloMantenimientoVersionAgregar;
        }

        public ProtocoloMantenimientoVersion getProtocoloMantenimientoBean() {
            return protocoloMantenimientoBean;
        }

        public void setProtocoloMantenimientoBean(ProtocoloMantenimientoVersion protocoloMantenimientoBean) {
            this.protocoloMantenimientoBean = protocoloMantenimientoBean;
        }

        public List<ProtocoloMantenimientoVersion> getProtocoloMantenimientoVersionList() {
            return protocoloMantenimientoVersionList;
        }

        public void setProtocoloMantenimientoVersionList(List<ProtocoloMantenimientoVersion> protocoloMantenimientoVersionList) {
            this.protocoloMantenimientoVersionList = protocoloMantenimientoVersionList;
        }

        public HtmlDataTable getProtocoloMantenimientoDataTable() {
            return protocoloMantenimientoDataTable;
        }

        public void setProtocoloMantenimientoDataTable(HtmlDataTable protocoloMantenimientoDataTable) {
            this.protocoloMantenimientoDataTable = protocoloMantenimientoDataTable;
        }

        public ProtocoloMantenimientoVersionDetalleMateriales getProtocoloMantenimientoVersionDetalleMaterialEditar() {
            return protocoloMantenimientoVersionDetalleMaterialEditar;
        }

        public void setProtocoloMantenimientoVersionDetalleMaterialEditar(ProtocoloMantenimientoVersionDetalleMateriales protocoloMantenimientoVersionDetalleMaterialEditar) {
            this.protocoloMantenimientoVersionDetalleMaterialEditar = protocoloMantenimientoVersionDetalleMaterialEditar;
        }

        public List<SelectItem> getMaquinariasSelectList() {
            return maquinariasSelectList;
        }

        public void setMaquinariasSelectList(List<SelectItem> maquinariasSelectList) {
            this.maquinariasSelectList = maquinariasSelectList;
        }

        public List<SelectItem> getPartesMaquinariaSelectList() {
            return partesMaquinariaSelectList;
        }

        public void setPartesMaquinariaSelectList(List<SelectItem> partesMaquinariaSelectList) {
            this.partesMaquinariaSelectList = partesMaquinariaSelectList;
        }
        
        public ProtocoloMantenimientoVersion getProtocoloMantenimientoVersionEditar() {
            return protocoloMantenimientoVersionEditar;
        }

        public void setProtocoloMantenimientoVersionEditar(ProtocoloMantenimientoVersion protocoloMantenimientoVersionEditar) {
            this.protocoloMantenimientoVersionEditar = protocoloMantenimientoVersionEditar;
        }

        public HtmlDataTable getProtocoloMantenimientoVersionDataTable() {
            return protocoloMantenimientoVersionDataTable;
        }

        public void setProtocoloMantenimientoVersionDataTable(HtmlDataTable protocoloMantenimientoVersionDataTable) {
            this.protocoloMantenimientoVersionDataTable = protocoloMantenimientoVersionDataTable;
        }
        
        public List<SelectItem> getUnidadesMedidaTiempoSelectList() {
            return unidadesMedidaTiempoSelectList;
        }

    public List<SelectItem> getDiasSemanaSelectList() {
        return diasSemanaSelectList;
    }

    public void setDiasSemanaSelectList(List<SelectItem> diasSemanaSelectList) {
        this.diasSemanaSelectList = diasSemanaSelectList;
    }
        

        public void setUnidadesMedidaTiempoSelectList(List<SelectItem> unidadesMedidaTiempoSelectList) {
            this.unidadesMedidaTiempoSelectList = unidadesMedidaTiempoSelectList;
        }

        public List<SelectItem> getDocumentacionSelectList() {
            return documentacionSelectList;
        }

        public void setDocumentacionSelectList(List<SelectItem> documentacionSelectList) {
            this.documentacionSelectList = documentacionSelectList;
        }
        
        
        
    //</editor-fold>    

    

}
