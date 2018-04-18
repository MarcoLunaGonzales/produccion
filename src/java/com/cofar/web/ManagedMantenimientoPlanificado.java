/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.web;

import com.cofar.bean.MantenimientoPlanificado;
import com.cofar.bean.Maquinaria;
import com.cofar.bean.ProtocoloMantenimientoVersion;
import com.cofar.util.Util;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import javax.faces.model.SelectItem;
import org.apache.logging.log4j.LogManager;

/**
 *
 * @author DASISAQ
 */
public class ManagedMantenimientoPlanificado extends ManagedBean
{
    private String mensaje="";
    private Connection con=null;
    private List<MantenimientoPlanificado> mantenimientoPlanificadoList;
    private List<SelectItem> protocoloMantenimientoVersionSelectList;
    private List<Maquinaria> maquinariaMantenimientoPlanificadoList;
    private MantenimientoPlanificado mantenimientoPlanificadoAgregar;
    private Date fechaRegistroMantenimientoPlanificado=new Date();
    private Date fechaFiltro=new Date();
    
    private Date fechaInicioGeneracionOrdenesTrabajo=new Date();
    private Date fechaFinalGeneracionOrdenesTrabajo=new Date();
    
    //variables para aprobacionde version de protocolo
    private List<ProtocoloMantenimientoVersion> protocoloMantenimientoVersionAprobarList;
    
    /**
     * Creates a new instance of ManagedMantenimientoPlanificado
     */
    public ManagedMantenimientoPlanificado() 
    {
        LOGGER=LogManager.getLogger("MantenimientoPlanificado");
    }
    //<editor-fold desc="aprobacion de version de protocolo" defaultstate="collapsed">
        public String aprobarProtocoloMantenimientoVersion_action()throws SQLException
        {
            mensaje = "";
            for(ProtocoloMantenimientoVersion bean:protocoloMantenimientoVersionAprobarList)
            {
                if(bean.getChecked())
                {
                    try {
                        con = Util.openConnection(con);
                        con.setAutoCommit(false);
                        StringBuilder consulta=new StringBuilder(" update PROTOCOLO_MANTENIMIENTO_VERSION");
                                                consulta.append(" set COD_ESTADO_PROTOCOLO_MANTENIMIENTO_VERSION=5");
                                                consulta.append(" where COD_ESTADO_PROTOCOLO_MANTENIMIENTO_VERSION=2");
                                                    consulta.append(" and COD_PROTOCOLO_MANTENIMIENTO=").append(bean.getProtocoloMantenimiento().getCodProtocoloMantenimiento());
                        LOGGER.debug("consulta  cambiar a obsoleto version activa " + consulta.toString());
                        PreparedStatement pst = con.prepareStatement(consulta.toString());
                        if (pst.executeUpdate() > 0) LOGGER.info("se cambio el estado de la version activa");
                        consulta = new StringBuilder("update PROTOCOLO_MANTENIMIENTO_VERSION");
                                        consulta.append(" set COD_ESTADO_PROTOCOLO_MANTENIMIENTO_VERSION=2");
                                        consulta.append(" where COD_PROTOCOLO_MANTENIMIENTO_VERSION=").append(bean.getCodProtocoloMantenimientoVersion());
                        LOGGER.debug("consulta  aprobar protoclo mantenimiento version" + consulta.toString());
                        pst = con.prepareStatement(consulta.toString(), PreparedStatement.RETURN_GENERATED_KEYS);
                        if (pst.executeUpdate() > 0) LOGGER.info("se aprobo la version");
                        SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM");
                        consulta = new StringBuilder("exec PAA_REGISTRO_MANTENIMIENTO_PLANIFICADO_PREVENTIVO");
                                        consulta.append(" ?,");//fecha primer mantenimiento
                                        consulta.append(bean.getCodProtocoloMantenimientoVersion());
                        LOGGER.debug("consutla ejecutar planificacion "+consulta.toString());
                        pst=con.prepareStatement(consulta.toString());
                        pst.setString(1,sdf.format(new Date())+"/01 12:00");LOGGER.info("p1: "+sdf.format(new Date())+"/01 12:00");
                        if(pst.executeUpdate()>0)LOGGER.info("se registro la transaccion");
                                        
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
                this.cargarProtocoloMantenimientoVersionAprobacionList();
            }
            return null;
        }
              
        public String getCargarProtocoloMantenimientoVersionAprobacionList()
        {
            this.cargarProtocoloMantenimientoVersionAprobacionList();
            return null;
        }
        private void cargarProtocoloMantenimientoVersionAprobacionList()
        {
            try {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select pmv.COD_PROTOCOLO_MANTENIMIENTO_VERSION,m.NOMBRE_MAQUINA,m.CODIGO,pmm.NOMBRE_PARTE_MAQUINA,pmm.CODIGO as codigoParte,pmv.DESCRIPCION_PROTOCOLO_MANTENIMIENTO,");
                                                consulta.append(" tmm.NOMBRE_TIPO_MANTENIMIENTO_MAQUINARIA,tfm.NOMBRE_TIPO_FRECUENCIA_MANTENIMIENTO,pmv.NRO_SEMANA_MANTENIMIENTO,pmv.NRO_VERSION,");
                                                consulta.append(" ds.NOMBRE_DIA_SEMANA,d.CODIGO_DOCUMENTO,d.NOMBRE_DOCUMENTO,pmv.CANTIDAD_TIEMPO,um.NOMBRE_UNIDAD_MEDIDA");
                                                consulta.append(" ,pmv.COD_PROTOCOLO_MANTENIMIENTO");
                                        consulta.append(" from PROTOCOLO_MANTENIMIENTO_VERSION pmv ");
                                                consulta.append(" inner join PROTOCOLO_MANTENIMIENTO pm on pm.COD_PROTOCOLO_MANTENIMIENTO=pmv.COD_PROTOCOLO_MANTENIMIENTO");
                                                consulta.append(" inner join MAQUINARIAS m on m.COD_MAQUINA=pm.COD_MAQUINARIA");
                                                consulta.append(" left outer join PARTES_MAQUINARIA pmm on pmm.COD_PARTE_MAQUINA=pm.COD_PARTE_MAQUINARIA");
                                                consulta.append(" inner join TIPOS_MANTENIMIENTO_MAQUINARIA tmm on tmm.COD_TIPO_MANTENIMIENTO_MAQUINARIA=pmv.COD_TIPO_MANTENIMIENTO_MAQUINARIA");
                                                consulta.append(" inner join TIPOS_FRECUENCIA_MANTENIMIENTO tfm on tfm.COD_TIPO_FRECUENCIA_MANTENIMIENTO=pmv.COD_TIPO_FRECUENCIA_MANTENIMIENTO");
                                                consulta.append(" inner join DIAS_SEMANA ds on ds.COD_DIA_SEMANA=pmv.COD_DIA_SEMANA");
                                                consulta.append(" left outer join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=pmv.COD_UNIDAD_MEDIDA_TIEMPO");
                                                consulta.append(" left outer join DOCUMENTACION d on d.COD_DOCUMENTO=pmv.COD_DOCUMENTO");
                                        consulta.append(" where pmv.COD_ESTADO_PROTOCOLO_MANTENIMIENTO_VERSION=4");
                                        consulta.append(" order by m.NOMBRE_MAQUINA,pmm.NOMBRE_PARTE_MAQUINA");
                LOGGER.debug("consulta cargar aprobar " + consulta.toString());
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                protocoloMantenimientoVersionAprobarList=new ArrayList<ProtocoloMantenimientoVersion>();
                while (res.next()) 
                {
                    ProtocoloMantenimientoVersion nuevo=new ProtocoloMantenimientoVersion();
                    nuevo.setCodProtocoloMantenimientoVersion(res.getInt("COD_PROTOCOLO_MANTENIMIENTO_VERSION"));
                    nuevo.getProtocoloMantenimiento().setCodProtocoloMantenimiento(res.getInt("COD_PROTOCOLO_MANTENIMIENTO"));
                    nuevo.getProtocoloMantenimiento().getMaquinaria().setNombreMaquina(res.getString("NOMBRE_MAQUINA"));
                    nuevo.getProtocoloMantenimiento().getMaquinaria().setCodigo(res.getString("CODIGO"));
                    nuevo.getProtocoloMantenimiento().getPartesMaquinaria().setNombreParteMaquina(res.getString("NOMBRE_PARTE_MAQUINA"));
                    nuevo.getProtocoloMantenimiento().getPartesMaquinaria().setCodigo(res.getString("codigoParte"));
                    nuevo.setDescripcionProtocoloMantenimientoVersion(res.getString("DESCRIPCION_PROTOCOLO_MANTENIMIENTO"));
                    nuevo.getTiposMantenimientoMaquinaria().setNombreTipoMantenimientoMaquinaria(res.getString("NOMBRE_TIPO_MANTENIMIENTO_MAQUINARIA"));
                    nuevo.getTiposFrecuenciaMantenimiento().setNombreTipoFrecuenciaMantenimiento(res.getString("NOMBRE_TIPO_FRECUENCIA_MANTENIMIENTO"));
                    nuevo.setNroSemana(res.getInt("NRO_SEMANA_MANTENIMIENTO"));
                    nuevo.setNroVersion(res.getInt("NRO_VERSION"));
                    nuevo.getDiaSemana().setNombreDiaSemana(res.getString("NOMBRE_DIA_SEMANA"));
                    nuevo.getDocumentacion().setCodigoDocumento(res.getString("CODIGO_DOCUMENTO"));
                    nuevo.getDocumentacion().setNombreDocumento(res.getString("NOMBRE_DOCUMENTO"));
                    nuevo.setCantidadTiempo(res.getDouble("CANTIDAD_TIEMPO"));
                    nuevo.getUnidadMedidaTiempo().setNombreUnidadMedida(res.getString("NOMBRE_UNIDAD_MEDIDA"));
                    protocoloMantenimientoVersionAprobarList.add(nuevo);
                    
                    
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
    //<editor-fold desc="mantenimiento planificado" defaultstate="collapsed">
        public String registrarOrdenesTrabajoMantenimientoPreventivo_action()throws SQLException
        {
            try 
            {
                con = Util.openConnection(con);
                con.setAutoCommit(false);
                SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm");
                ManagedAccesoSistema managed=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
                StringBuilder consulta = new StringBuilder("exec PAA_REGISTRO_ORDENES_TRABAJO_MANTENIMIENTO_PREVENTIVO ");
                                            consulta.append("'").append(sdf.format(fechaInicioGeneracionOrdenesTrabajo)).append("',");
                                            consulta.append("'").append(sdf.format(fechaFinalGeneracionOrdenesTrabajo)).append("',");
                                            consulta.append(managed.getUsuarioModuloBean().getCodUsuarioGlobal());
                LOGGER.debug("consulta registrar mantemimeinto prensetaicon "+consulta.toString());
                PreparedStatement pst = con.prepareStatement(consulta.toString());
                pst.executeUpdate();
                LOGGER.info("se registraron las ordenes de trabajo");
                con.commit();
                mensaje = "1";
                pst.close();
            } catch (SQLException ex) {
                con.rollback();
                mensaje = "Ocurrio un error al momento de guardar la desviacion,intente de nuevo";
                LOGGER.warn(ex.getMessage());
            } catch (NumberFormatException ex) {
                con.rollback();
                mensaje = "Ocurrio un error de datos al momento de guardar la desviacion, verifique la información e intente de nuevo";
                LOGGER.warn(ex.getMessage());
            } finally {
                con.close();
            }
            return null;
        }
        public String codProtocoloMantenimientoVersionAgregar_change()
        {
            try {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select m.NOMBRE_MAQUINA,isnull(pmm.NOMBRE_PARTE_MAQUINA,'') as NOMBRE_PARTE_MAQUINA,");
                                                    consulta.append(" tmm.NOMBRE_TIPO_MANTENIMIENTO_MAQUINARIA,tfm.NOMBRE_TIPO_FRECUENCIA_MANTENIMIENTO");
                                            consulta.append(" from PROTOCOLO_MANTENIMIENTO pm");
                                                    consulta.append(" inner join PROTOCOLO_MANTENIMIENTO_VERSION pmv on pm.COD_PROTOCOLO_MANTENIMIENTO=pmv.COD_PROTOCOLO_MANTENIMIENTO");
                                                    consulta.append(" inner join MAQUINARIAS m on m.COD_MAQUINA=pm.COD_MAQUINARIA");
                                                    consulta.append(" left outer join PARTES_MAQUINARIA pmm on pmm.COD_PARTE_MAQUINA=pm.COD_PARTE_MAQUINARIA");
                                                    consulta.append(" inner join TIPOS_MANTENIMIENTO_MAQUINARIA tmm on tmm.COD_TIPO_MANTENIMIENTO_MAQUINARIA=pmv.COD_TIPO_MANTENIMIENTO_MAQUINARIA");
                                                    consulta.append(" inner join TIPOS_FRECUENCIA_MANTENIMIENTO tfm on tfm.COD_TIPO_FRECUENCIA_MANTENIMIENTO=pmv.COD_TIPO_FRECUENCIA_MANTENIMIENTO");
                                            consulta.append(" where pmv.COD_PROTOCOLO_MANTENIMIENTO_VERSION=").append(mantenimientoPlanificadoAgregar.getProtocoloMantenimientoVersion().getCodProtocoloMantenimientoVersion());
                LOGGER.debug("consulta cargar  datos protocolo mantenimiento " + consulta.toString());
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                while (res.next()) 
                {
                    mantenimientoPlanificadoAgregar.getProtocoloMantenimientoVersion().getProtocoloMantenimiento().getMaquinaria().setNombreMaquina(res.getString("NOMBRE_MAQUINA"));
                    mantenimientoPlanificadoAgregar.getProtocoloMantenimientoVersion().getProtocoloMantenimiento().getPartesMaquinaria().setNombreParteMaquina(res.getString("NOMBRE_PARTE_MAQUINA"));
                    mantenimientoPlanificadoAgregar.getProtocoloMantenimientoVersion().getTiposMantenimientoMaquinaria().setNombreTipoMantenimientoMaquinaria(res.getString("NOMBRE_TIPO_MANTENIMIENTO_MAQUINARIA"));
                    mantenimientoPlanificadoAgregar.getProtocoloMantenimientoVersion().getTiposFrecuenciaMantenimiento().setNombreTipoFrecuenciaMantenimiento(res.getString("NOMBRE_TIPO_FRECUENCIA_MANTENIMIENTO"));
                    
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
        private void cargarProtocoloMantenimientoVersionSelectList()
        {
            try 
            {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select pmv.COD_PROTOCOLO_MANTENIMIENTO_VERSION,pmv.DESCRIPCION_PROTOCOLO_MANTENIMIENTO");
                                            consulta.append(" from PROTOCOLO_MANTENIMIENTO_VERSION pmv");
                                            consulta.append(" where pmv.COD_ESTADO_PROTOCOLO_MANTENIMIENTO_VERSION=2");
                                                    consulta.append(" and pmv.COD_ESTADO_REGISTRO=1");
                                            consulta.append(" order by pmv.DESCRIPCION_PROTOCOLO_MANTENIMIENTO");
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                protocoloMantenimientoVersionSelectList=new ArrayList<SelectItem>();
                while (res.next()) 
                {
                    protocoloMantenimientoVersionSelectList.add(new SelectItem(res.getInt("COD_PROTOCOLO_MANTENIMIENTO_VERSION"),res.getString("DESCRIPCION_PROTOCOLO_MANTENIMIENTO")));
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
        public String getCargarMantenimientoPlanificadoList()
        {
            this.cargarProtocoloMantenimientoVersionSelectList();
            this.cargarMantenimientoPlanificadoList();
            return null;
        }
        public String mesMantenimientoPlanificado_change()
        {
            this.cargarMantenimientoPlanificadoList();
            return null;
        }

        private void cargarMantenimientoPlanificadoList()
        {
            try 
            {
                con = Util.openConnection(con);
                SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM");
                StringBuilder consulta = new StringBuilder("select mp.COD_MANTENIMIENTO_PLANIFICADO,mp.FECHA_MANTENIMIENTO,pmv.COD_PROTOCOLO_MANTENIMIENTO_VERSION,m.NOMBRE_MAQUINA+' ('+m.CODIGO+')' AS NOMBRE_MAQUINA,");
                                                consulta.append(" pmm.NOMBRE_PARTE_MAQUINA,tfm.NOMBRE_TIPO_FRECUENCIA_MANTENIMIENTO,tmm.NOMBRE_TIPO_MANTENIMIENTO_MAQUINARIA");
                                                consulta.append(" ,pm.COD_MAQUINARIA,tfm.ABREVIATURA,isnull(d.CODIGO_DOCUMENTO,'--No Aplica--') as CODIGO_DOCUMENTO,mm.NOMBRE_MARCA_MAQUINARIA");
                                                consulta.append(" ,pmv.CANTIDAD_TIEMPO, um.NOMBRE_UNIDAD_MEDIDA,pmv.MANTENIMIENTO_COFAR,pmv.MANTENIMIENTO_EXTERNO,pmv.DESCRIPCION_PROTOCOLO_MANTENIMIENTO");
                                        consulta.append(" from MANTENIMIENTO_PLANIFICADO  mp ");
                                                consulta.append(" inner join PROTOCOLO_MANTENIMIENTO_VERSION pmv on pmv.COD_PROTOCOLO_MANTENIMIENTO_VERSION=mp.COD_PROTOCOLO_MANTENIMIENTO_VERSION");
                                                consulta.append(" inner join PROTOCOLO_MANTENIMIENTO pm on pm .COD_PROTOCOLO_MANTENIMIENTO=pmv.COD_PROTOCOLO_MANTENIMIENTO");
                                                consulta.append(" left outer join MAQUINARIAS m on m.COD_MAQUINA=pm.COD_MAQUINARIA");
                                                consulta.append(" left outer join MARCA_MAQUINARIA mm on mm.COD_MARCA_MAQUINARIA=m.COD_MARCA_MAQUINARIA");
                                                consulta.append(" left outer join PARTES_MAQUINARIA pmm on pmm.COD_PARTE_MAQUINA=pm.COD_PARTE_MAQUINARIA");
                                                consulta.append(" inner join TIPOS_FRECUENCIA_MANTENIMIENTO tfm on tfm.COD_TIPO_FRECUENCIA_MANTENIMIENTO=pmv.COD_TIPO_FRECUENCIA_MANTENIMIENTO");
                                                consulta.append(" inner join TIPOS_MANTENIMIENTO_MAQUINARIA tmm on tmm.COD_TIPO_MANTENIMIENTO_MAQUINARIA=pmv.COD_TIPO_MANTENIMIENTO_MAQUINARIA");
                                                consulta.append(" inner join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=pmv.COD_UNIDAD_MEDIDA_TIEMPO");
                                                consulta.append(" left outer join DOCUMENTACION d on d.COD_DOCUMENTO=pmv.COD_DOCUMENTO");
                                        consulta.append(" where mp.FECHA_MANTENIMIENTO BETWEEN '").append(sdf.format(fechaFiltro)).append("/01 00:01' AND DATEADD(DAY,-1,DATEADD(MONTH,1,'").append(sdf.format(fechaFiltro)).append("/01 00:01'))");
                                        consulta.append(" order by m.NOMBRE_MAQUINA,pmm.NOMBRE_PARTE_MAQUINA,tfm.ORDEN,pm.COD_PROTOCOLO_MANTENIMIENTO,pmv.COD_TIPO_FRECUENCIA_MANTENIMIENTO,mp.FECHA_MANTENIMIENTO");
                LOGGER.debug("consulta cargar mantenimiento planificado " + consulta.toString());
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                mantenimientoPlanificadoList=new ArrayList<MantenimientoPlanificado>();
                maquinariaMantenimientoPlanificadoList=new ArrayList<Maquinaria>();
                Maquinaria maquinariaNueva=new Maquinaria();
                ProtocoloMantenimientoVersion protocoloMantenimientoVersionNuevo=new ProtocoloMantenimientoVersion();
                while (res.next()) 
                {
                    MantenimientoPlanificado nuevo=new MantenimientoPlanificado();
                    nuevo.getProtocoloMantenimientoVersion().setMantenimientoCofar(res.getInt("MANTENIMIENTO_COFAR")>0);
                    nuevo.getProtocoloMantenimientoVersion().setMantenimientoExterno(res.getInt("MANTENIMIENTO_EXTERNO")>0);
                    nuevo.setCodMantenimientoPlanificado(res.getInt("COD_MANTENIMIENTO_PLANIFICADO"));
                    nuevo.setFechaMantenimiento(res.getTimestamp("FECHA_MANTENIMIENTO"));
                    nuevo.getProtocoloMantenimientoVersion().setCodProtocoloMantenimientoVersion(res.getInt("COD_PROTOCOLO_MANTENIMIENTO_VERSION"));
                    nuevo.getProtocoloMantenimientoVersion().getProtocoloMantenimiento().getMaquinaria().setNombreMaquina(res.getString("NOMBRE_MAQUINA"));
                    nuevo.getProtocoloMantenimientoVersion().getProtocoloMantenimiento().getPartesMaquinaria().setNombreParteMaquina(res.getString("NOMBRE_PARTE_MAQUINA"));
                    nuevo.getProtocoloMantenimientoVersion().getTiposFrecuenciaMantenimiento().setNombreTipoFrecuenciaMantenimiento(res.getString("NOMBRE_TIPO_FRECUENCIA_MANTENIMIENTO"));
                    nuevo.getProtocoloMantenimientoVersion().getTiposFrecuenciaMantenimiento().setAbreviatura(res.getString("ABREVIATURA"));
                    nuevo.getProtocoloMantenimientoVersion().getTiposMantenimientoMaquinaria().setNombreTipoMantenimientoMaquinaria(res.getString("NOMBRE_TIPO_MANTENIMIENTO_MAQUINARIA"));
                    mantenimientoPlanificadoList.add(nuevo);
                    //<editor-fold desc="llenando datos por maquinaria" defaultstate="collapsed">
                        if(!maquinariaNueva.getCodMaquina().equals(res.getString("COD_MAQUINARIA")))
                        {
                            if(maquinariaNueva.getCodMaquina().length()>0)
                            {
                                maquinariaNueva.getProtocoloMantenimientoVersionList().add(protocoloMantenimientoVersionNuevo);
                                maquinariaMantenimientoPlanificadoList.add(maquinariaNueva);
                            }
                            maquinariaNueva=new Maquinaria();
                            maquinariaNueva.setCodMaquina(res.getString("COD_MAQUINARIA"));
                            maquinariaNueva.setNombreMaquina(res.getString("NOMBRE_MAQUINA"));
                            maquinariaNueva.getMarcaMaquinaria().setNombreMarcaMaquinaria(res.getString("NOMBRE_MARCA_MAQUINARIA"));
                            maquinariaNueva.setProtocoloMantenimientoVersionList(new ArrayList<ProtocoloMantenimientoVersion>());
                            protocoloMantenimientoVersionNuevo=new ProtocoloMantenimientoVersion();
                        }
                        if(protocoloMantenimientoVersionNuevo.getCodProtocoloMantenimientoVersion()!=res.getInt("COD_PROTOCOLO_MANTENIMIENTO_VERSION"))
                        {
                            if(protocoloMantenimientoVersionNuevo.getCodProtocoloMantenimientoVersion()>0)
                            {
                                maquinariaNueva.getProtocoloMantenimientoVersionList().add(protocoloMantenimientoVersionNuevo);
                            }
                            protocoloMantenimientoVersionNuevo=new ProtocoloMantenimientoVersion();
                            protocoloMantenimientoVersionNuevo.setMantenimientoCofar(res.getInt("MANTENIMIENTO_COFAR")>0);
                            protocoloMantenimientoVersionNuevo.setMantenimientoExterno(res.getInt("MANTENIMIENTO_EXTERNO")>0);
                            protocoloMantenimientoVersionNuevo.setDescripcionProtocoloMantenimientoVersion(res.getString("DESCRIPCION_PROTOCOLO_MANTENIMIENTO"));
                            protocoloMantenimientoVersionNuevo.setCodProtocoloMantenimientoVersion(res.getInt("COD_PROTOCOLO_MANTENIMIENTO_VERSION"));
                            protocoloMantenimientoVersionNuevo.getDocumentacion().setCodigoDocumento(res.getString("CODIGO_DOCUMENTO"));
                            protocoloMantenimientoVersionNuevo.getTiposFrecuenciaMantenimiento().setAbreviatura(res.getString("ABREVIATURA"));
                            protocoloMantenimientoVersionNuevo.setCantidadTiempo(res.getDouble("CANTIDAD_TIEMPO"));
                            protocoloMantenimientoVersionNuevo.getUnidadMedidaTiempo().setNombreUnidadMedida(res.getString("NOMBRE_UNIDAD_MEDIDA"));
                            protocoloMantenimientoVersionNuevo.setMantenimientoPlanificadoList(new ArrayList<MantenimientoPlanificado>());
                        }
                        
                        MantenimientoPlanificado nuevoM=new MantenimientoPlanificado();
                        nuevoM.setFechaMantenimiento(res.getTimestamp("FECHA_MANTENIMIENTO"));
                        protocoloMantenimientoVersionNuevo.getMantenimientoPlanificadoList().add(nuevoM);
                    //</editor-fold>
                }
                if(maquinariaNueva.getCodMaquina().length()>0)
                {
                    maquinariaNueva.getProtocoloMantenimientoVersionList().add(protocoloMantenimientoVersionNuevo);
                    maquinariaMantenimientoPlanificadoList.add(maquinariaNueva);
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
        public String agregarMantenimientoPlanificado_action()
        {
            mantenimientoPlanificadoAgregar=new MantenimientoPlanificado();
            return null;
        }
        public String guardarAgregarMantenimientoPlanificado_action()throws SQLException
        {
            mensaje = "";
            try 
            {
                con = Util.openConnection(con);
                con.setAutoCommit(false);
                StringBuilder consulta = new StringBuilder("exec PAA_REGISTRO_MANTENIMIENTO_PLANIFICADO_PREVENTIVO");
                                        consulta.append(" ?,");//fecha primer mantenimiento
                                        consulta.append("?");
                LOGGER.debug("consulta registrar mantenimiento planificado " + consulta.toString());
                PreparedStatement pst = con.prepareStatement(consulta.toString());
                SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");
                pst.setString(1,sdf.format(fechaRegistroMantenimientoPlanificado)+" 12:00");LOGGER.info("p1: "+sdf.format(fechaRegistroMantenimientoPlanificado));
                pst.setInt(2,mantenimientoPlanificadoAgregar.getProtocoloMantenimientoVersion().getCodProtocoloMantenimientoVersion());LOGGER.info("p1: "+mantenimientoPlanificadoAgregar.getProtocoloMantenimientoVersion().getCodProtocoloMantenimientoVersion());
                if (pst.executeUpdate() > 0) LOGGER.info("se registro el mantenimiento planificado ");
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
                this.cargarMantenimientoPlanificadoList();
            }
            return null;
        }
    //</editor-fold>
    //<editor-fold desc="getter and setter" defaultstate="collapsed">

        public List<SelectItem> getProtocoloMantenimientoVersionSelectList() {
            return protocoloMantenimientoVersionSelectList;
        }

        public void setProtocoloMantenimientoVersionSelectList(List<SelectItem> protocoloMantenimientoVersionSelectList) {
            this.protocoloMantenimientoVersionSelectList = protocoloMantenimientoVersionSelectList;
        }

        public List<Maquinaria> getMaquinariaMantenimientoPlanificadoList() {
            return maquinariaMantenimientoPlanificadoList;
        }

        public void setMaquinariaMantenimientoPlanificadoList(List<Maquinaria> maquinariaMantenimientoPlanificadoList) {
            this.maquinariaMantenimientoPlanificadoList = maquinariaMantenimientoPlanificadoList;
        }



        public Date getFechaFiltro() {
            return fechaFiltro;
        }

        public void setFechaFiltro(Date fechaFiltro) {
            this.fechaFiltro = fechaFiltro;
        }

        public List<ProtocoloMantenimientoVersion> getProtocoloMantenimientoVersionAprobarList() {
            return protocoloMantenimientoVersionAprobarList;
        }

        public void setProtocoloMantenimientoVersionAprobarList(List<ProtocoloMantenimientoVersion> protocoloMantenimientoVersionAprobarList) {
            this.protocoloMantenimientoVersionAprobarList = protocoloMantenimientoVersionAprobarList;
        }

        public MantenimientoPlanificado getMantenimientoPlanificadoAgregar() {
            return mantenimientoPlanificadoAgregar;
        }

        public void setMantenimientoPlanificadoAgregar(MantenimientoPlanificado mantenimientoPlanificadoAgregar) {
            this.mantenimientoPlanificadoAgregar = mantenimientoPlanificadoAgregar;
        }

        public Date getFechaRegistroMantenimientoPlanificado() {
            return fechaRegistroMantenimientoPlanificado;
        }

        public void setFechaRegistroMantenimientoPlanificado(Date fechaRegistroMantenimientoPlanificado) {
            this.fechaRegistroMantenimientoPlanificado = fechaRegistroMantenimientoPlanificado;
        }

        public Date getFechaInicioGeneracionOrdenesTrabajo() {
            return fechaInicioGeneracionOrdenesTrabajo;
        }

        public void setFechaInicioGeneracionOrdenesTrabajo(Date fechaInicioGeneracionOrdenesTrabajo) {
            this.fechaInicioGeneracionOrdenesTrabajo = fechaInicioGeneracionOrdenesTrabajo;
        }

        public Date getFechaFinalGeneracionOrdenesTrabajo() {
            return fechaFinalGeneracionOrdenesTrabajo;
        }

        public void setFechaFinalGeneracionOrdenesTrabajo(Date fechaFinalGeneracionOrdenesTrabajo) {
            this.fechaFinalGeneracionOrdenesTrabajo = fechaFinalGeneracionOrdenesTrabajo;
        }

        
        public String getMensaje() {
            return mensaje;
        }

        public void setMensaje(String mensaje) {
            this.mensaje = mensaje;
        }

        public List<MantenimientoPlanificado> getMantenimientoPlanificadoList() {
            return mantenimientoPlanificadoList;
        }

        public void setMantenimientoPlanificadoList(List<MantenimientoPlanificado> mantenimientoPlanificadoList) {
            this.mantenimientoPlanificadoList = mantenimientoPlanificadoList;
        }
    
    //</editor-fold>

    
}
