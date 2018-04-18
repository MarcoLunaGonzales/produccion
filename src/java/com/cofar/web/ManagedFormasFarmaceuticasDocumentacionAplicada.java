/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.web;

import com.cofar.bean.Documentacion;
import com.cofar.bean.FormasFarmaceuticas;
import com.cofar.bean.FormasFarmaceuticasDocumentacionAplicada;
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
public class ManagedFormasFarmaceuticasDocumentacionAplicada extends ManagedBean
{
    private Connection con=null;
    private String mensaje="";
    private FormasFarmaceuticasDocumentacionAplicada formasFarmaceuticasDocumentacionAplicadaBean;
    private HtmlDataTable formasFarmaceuticasDataTable;
    private List<FormasFarmaceuticasDocumentacionAplicada> formasFarmaceuticasDocumentacionAplicadaList;
    
    private List<FormasFarmaceuticas> formasFarmaceuticasList;
    private List<SelectItem> tiposAsignacionDocumentoOmSelectList;
    private List<Documentacion> documentacionAgregarList;
    private FormasFarmaceuticasDocumentacionAplicada formasFarmaceuticasDocumentacionAplicadaAgregar;
    /**
     * Creates a new instance of ManagedFormasFarmaceuticasDocumentacionAplicada
     */
    public ManagedFormasFarmaceuticasDocumentacionAplicada() 
    {
        LOGGER=LogManager.getLogger("Versionamiento");
        formasFarmaceuticasDocumentacionAplicadaBean=new FormasFarmaceuticasDocumentacionAplicada();
        formasFarmaceuticasDocumentacionAplicadaBean.getFormasFarmaceuticas().setCodForma("0");
    }
    public String seleccionarFormaFarmaceutica_action()
    {
        formasFarmaceuticasDocumentacionAplicadaBean.setFormasFarmaceuticas((FormasFarmaceuticas)formasFarmaceuticasDataTable.getRowData());
        this.cargarFormasFarmaceuticasDocumentacionAplicadaList();
        return null;
    }
    public String getCargarAgregarFormasFarmaceuticasAsignacionDocumentacionList()
    {
        
        formasFarmaceuticasDocumentacionAplicadaAgregar=new FormasFarmaceuticasDocumentacionAplicada();
        formasFarmaceuticasDocumentacionAplicadaAgregar.getTiposAsignacionDocumentoOm().setCodTipoAsignacionDocumentacionOm(Integer.valueOf(tiposAsignacionDocumentoOmSelectList.get(0).getValue().toString()));
        this.cargarAgregarFormasFarmaceuticasAsignacionDocumentacionList();
        return null;
    }
    private void cargarTiposAsignacionDocumentacionOm()
    {
        try {
            con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select t.COD_TIPO_ASIGNACION_DOCUMENTO_OM,t.NOMBRE_TIPO_ASIGNACION_DOCUMENTO_OM");
                                        consulta.append(" from TIPOS_ASIGNACION_DOCUMENTO_OM t ");
                                        consulta.append(" order by t.NOMBRE_TIPO_ASIGNACION_DOCUMENTO_OM");
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            tiposAsignacionDocumentoOmSelectList=new ArrayList<SelectItem>();
            while (res.next()) 
            {
                tiposAsignacionDocumentoOmSelectList.add(new SelectItem(res.getInt("COD_TIPO_ASIGNACION_DOCUMENTO_OM"),res.getString("NOMBRE_TIPO_ASIGNACION_DOCUMENTO_OM")));
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
    private void cargarAgregarFormasFarmaceuticasAsignacionDocumentacionList()
    {
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select d.COD_DOCUMENTO,d.NOMBRE_DOCUMENTO,d.CODIGO_NUEVO,d.CODIGO_DOCUMENTO,");
                                            consulta.append(" tdb.NOMBRE_TIPO_DOCUMENTO_BIBLIOTECA,ae.NOMBRE_AREA_EMPRESA");
                                    consulta.append(" from DOCUMENTACION d");
                                            consulta.append(" inner join TIPOS_DOCUMENTO_BIBLIOTECA tdb on tdb.COD_TIPO_DOCUMENTO_BIBLIOTECA = d.COD_TIPO_DOCUMENTO_BIBLIOTECA");
                                            consulta.append(" inner join AREAS_EMPRESA ae on ae.COD_AREA_EMPRESA = d.COD_AREA_EMPRESA");
                                    consulta.append(" where d.COD_DOCUMENTO not in (");
                                            consulta.append(" select ffda.COD_DOCUMENTO");
                                            consulta.append(" from FORMAS_FARMACEUTICAS_DOCUMENTACION_APLICADA ffda ");
                                            consulta.append(" where ffda.COD_FORMA=").append(formasFarmaceuticasDocumentacionAplicadaBean.getFormasFarmaceuticas().getCodForma());
                                                    consulta.append(" and ffda.COD_TIPO_ASIGNACION_DOCUMENTO_OM=").append(formasFarmaceuticasDocumentacionAplicadaAgregar.getTiposAsignacionDocumentoOm().getCodTipoAsignacionDocumentacionOm());
                                    consulta.append(" )");
                                    consulta.append(" and ae.DIVISION = 3");
                                    consulta.append(" order by d.NOMBRE_DOCUMENTO");
            LOGGER.debug("consulta cargar agregar documentacion " + consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            documentacionAgregarList=new ArrayList<Documentacion>();
            while (res.next()) 
            {
                Documentacion nuevo=new Documentacion();
                nuevo.setCodDocumento(res.getInt("COD_DOCUMENTO"));
                nuevo.setNombreDocumento(res.getString("NOMBRE_DOCUMENTO"));
                nuevo.setCodigoDocumento(res.getString("CODIGO_DOCUMENTO"));
                nuevo.setCodigoNuevo(res.getString("CODIGO_NUEVO"));
                nuevo.getTiposDocumentoBiblioteca().setNombreTipoDocumentoBiblioteca(res.getString("NOMBRE_TIPO_DOCUMENTO_BIBLIOTECA"));
                nuevo.getAreasEmpresa().setNombreAreaEmpresa(res.getString("NOMBRE_AREA_EMPRESA"));
                documentacionAgregarList.add(nuevo);
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
    public String codTipoAsignacionDocumentacion_change()
    {
        this.cargarAgregarFormasFarmaceuticasAsignacionDocumentacionList();
        return null;
    }
    public String getCargarFormasFarmaceuticasDocumentacionAplicadaList()
    {
        this.cargarTiposAsignacionDocumentacionOm();
        this.cargarFormasFarmaceuticas();
        this.cargarFormasFarmaceuticasDocumentacionAplicadaList();
        return null;
    }
    private void cargarFormasFarmaceuticasDocumentacionAplicadaList()
    {
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select ffda.COD_FORMA,ffda.COD_DOCUMENTO,d.NOMBRE_DOCUMENTO,td.NOMBRE_TIPO_DOCUMENTO_BIBLIOTECA,");
                                                consulta.append(" d.CODIGO_DOCUMENTO,d.CODIGO_NUEVO,ffda.COD_TIPO_ASIGNACION_DOCUMENTO_OM,tad.NOMBRE_TIPO_ASIGNACION_DOCUMENTO_OM");
                                        consulta.append(" from FORMAS_FARMACEUTICAS_DOCUMENTACION_APLICADA ffda ");
                                                consulta.append(" inner join DOCUMENTACION d on d.COD_DOCUMENTO=ffda.COD_DOCUMENTO");
                                                consulta.append(" inner join TIPOS_DOCUMENTO_BIBLIOTECA td on td.COD_TIPO_DOCUMENTO_BIBLIOTECA=d.COD_TIPO_DOCUMENTO_BIBLIOTECA");
                                                consulta.append(" inner join TIPOS_ASIGNACION_DOCUMENTO_OM tad on tad.COD_TIPO_ASIGNACION_DOCUMENTO_OM=ffda.COD_TIPO_ASIGNACION_DOCUMENTO_OM");
                                        consulta.append(" where  ffda.COD_FORMA=").append(formasFarmaceuticasDocumentacionAplicadaBean.getFormasFarmaceuticas().getCodForma());
                                                if(formasFarmaceuticasDocumentacionAplicadaBean.getTiposAsignacionDocumentoOm().getCodTipoAsignacionDocumentacionOm()>0)
                                                    consulta.append(" and ffda.COD_TIPO_ASIGNACION_DOCUMENTO_OM=").append(formasFarmaceuticasDocumentacionAplicadaBean.getTiposAsignacionDocumentoOm().getCodTipoAsignacionDocumentacionOm());
                                        consulta.append(" order by tad.NOMBRE_TIPO_ASIGNACION_DOCUMENTO_OM,d.NOMBRE_DOCUMENTO");
            LOGGER.debug("consulta cargar documentos asignados a forma farmaceutica " + consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            formasFarmaceuticasDocumentacionAplicadaList=new ArrayList<FormasFarmaceuticasDocumentacionAplicada>();
            while (res.next()) 
            {
                FormasFarmaceuticasDocumentacionAplicada nuevo=new FormasFarmaceuticasDocumentacionAplicada();
                nuevo.getFormasFarmaceuticas().setCodForma(res.getString("COD_FORMA"));
                nuevo.getDocumentacion().setCodDocumento(res.getInt("COD_DOCUMENTO"));
                nuevo.getDocumentacion().setNombreDocumento(res.getString("NOMBRE_DOCUMENTO"));
                nuevo.getDocumentacion().getTiposDocumentoBiblioteca().setNombreTipoDocumentoBiblioteca(res.getString("NOMBRE_TIPO_DOCUMENTO_BIBLIOTECA"));
                nuevo.getDocumentacion().setCodigoDocumento(res.getString("CODIGO_DOCUMENTO"));
                nuevo.getDocumentacion().setCodigoNuevo(res.getString("CODIGO_NUEVO"));
                nuevo.getTiposAsignacionDocumentoOm().setCodTipoAsignacionDocumentacionOm(res.getInt("COD_TIPO_ASIGNACION_DOCUMENTO_OM"));
                nuevo.getTiposAsignacionDocumentoOm().setNombreTipoAsignacionDocumentacionOm(res.getString("NOMBRE_TIPO_ASIGNACION_DOCUMENTO_OM"));
                formasFarmaceuticasDocumentacionAplicadaList.add(nuevo);
                
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
    private void cargarFormasFarmaceuticas()
    {
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select ff.cod_forma,ff.nombre_forma,ff.abreviatura_forma");
                                        consulta.append(" from FORMAS_FARMACEUTICAS ff");
                                        consulta.append(" where ff.cod_estado_registro=1");
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
                formasFarmaceuticasList.add(nuevo);
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
    public String guardarAgregarFormasFarmaceuticasDocumentacionAplicada_action()throws SQLException
    {
        mensaje = "";
        try {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta = new StringBuilder("INSERT INTO FORMAS_FARMACEUTICAS_DOCUMENTACION_APLICADA(COD_FORMA, COD_DOCUMENTO, COD_TIPO_ASIGNACION_DOCUMENTO_OM)");
                                    consulta.append(" VALUES (");
                                            consulta.append(formasFarmaceuticasDocumentacionAplicadaBean.getFormasFarmaceuticas().getCodForma()).append(",");
                                            consulta.append("?,");
                                            consulta.append(formasFarmaceuticasDocumentacionAplicadaAgregar.getTiposAsignacionDocumentoOm().getCodTipoAsignacionDocumentacionOm());
                                    consulta.append(")");
            LOGGER.debug("consulta agregar formas farmaceutica documentacion " + consulta.toString());
            PreparedStatement pst = con.prepareStatement(consulta.toString());
            for(Documentacion bean:documentacionAgregarList)
            {
                if(bean.getChecked())
                {
                    pst.setInt(1,bean.getCodDocumento());LOGGER.info("p1: "+bean.getCodDocumento());
                    if(pst.executeUpdate()>0)LOGGER.info("se reigstro el documento");
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
    public String eliminarFormasFarmaceuticasDocumentacionAplicadaList()throws SQLException
    {
        mensaje = "";
        try {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta = new StringBuilder("DELETE FORMAS_FARMACEUTICAS_DOCUMENTACION_APLICADA");
                                        consulta.append(" WHERE COD_FORMA=").append(formasFarmaceuticasDocumentacionAplicadaBean.getFormasFarmaceuticas().getCodForma());
                                                consulta.append(" and COD_DOCUMENTO=?");
                                                consulta.append(" and COD_TIPO_ASIGNACION_DOCUMENTO_OM=?");
            LOGGER.debug("consulta eliminar formas farmaceuticas documentacion aplicada " + consulta.toString());
            PreparedStatement pst = con.prepareStatement(consulta.toString());
            for(FormasFarmaceuticasDocumentacionAplicada bean:formasFarmaceuticasDocumentacionAplicadaList)
            {
                if(bean.getChecked())
                {
                    pst.setInt(1, bean.getDocumentacion().getCodDocumento());LOGGER.info("p1: "+bean.getDocumentacion().getCodDocumento());
                    pst.setInt(2,bean.getTiposAsignacionDocumentoOm().getCodTipoAsignacionDocumentacionOm());LOGGER.info("p2:"+bean.getTiposAsignacionDocumentoOm().getCodTipoAsignacionDocumentacionOm());
                    if(pst.executeUpdate()>0)LOGGER.info("se elimino la asignacion de documentacion aplicada");
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
            this.cargarFormasFarmaceuticasDocumentacionAplicadaList();
        }
        return null;
    }
    public String codTipoAsignacionDocumentacionOmBean_change()
    {
        this.cargarFormasFarmaceuticasDocumentacionAplicadaList();
        return null;
    }
    public String duplicarDocumentacionVersionesProducto()throws SQLException
    {
        mensaje = "";
        try {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta = new StringBuilder("delete COMPONENTES_PROD_VERSION_DOCUMENTACION_APLICADA");
                                        consulta.append(" where COD_DOCUMENTO=?");
                                        consulta.append(" and COD_TIPO_ASIGNACION_DOCUMENTO_OM=?");
                                        consulta.append(" and COD_VERSION in");
                                        consulta.append(" (");
                                                consulta.append(" select c.COD_VERSION");
                                                consulta.append(" from COMPONENTES_PROD_VERSION c");
                                                consulta.append(" where c.COD_ESTADO_COMPPROD = 1 and");
                                                consulta.append(" c.COD_ESTADO_VERSION in (1, 2, 3, 5, 7) and");
                                                consulta.append(" c.COD_FORMA =").append(formasFarmaceuticasDocumentacionAplicadaBean.getFormasFarmaceuticas().getCodForma());
                                        consulta.append(" )");
            LOGGER.debug("consulta delete documentacion " + consulta.toString());
            PreparedStatement pstDel = con.prepareStatement(consulta.toString());
            consulta=new StringBuilder("INSERT INTO COMPONENTES_PROD_VERSION_DOCUMENTACION_APLICADA(COD_VERSION,COD_DOCUMENTO, COD_TIPO_ASIGNACION_DOCUMENTO_OM)");
                        consulta.append(" select cpv.COD_VERSION,?,?");
                        consulta.append(" from COMPONENTES_PROD_VERSION cpv");
                        consulta.append(" where cpv.COD_FORMA = ").append(formasFarmaceuticasDocumentacionAplicadaBean.getFormasFarmaceuticas().getCodForma());
                                consulta.append(" and cpv.COD_ESTADO_VERSION in (1, 2, 3, 5, 7) and");
                                consulta.append(" cpv.COD_ESTADO_COMPPROD = 1");
            LOGGER.debug("consulta registrar documetnacion aplicada "+consulta.toString());
            PreparedStatement pstReg=con.prepareStatement(consulta.toString());
            for(FormasFarmaceuticasDocumentacionAplicada bean:formasFarmaceuticasDocumentacionAplicadaList)
            {
                if(bean.getChecked())
                {
                    pstDel.setInt(1,bean.getDocumentacion().getCodDocumento());LOGGER.info("pstdel p1: "+bean.getDocumentacion().getCodDocumento());
                    pstDel.setInt(2,bean.getTiposAsignacionDocumentoOm().getCodTipoAsignacionDocumentacionOm());LOGGER.info("pstdel p2: "+bean.getTiposAsignacionDocumentoOm().getCodTipoAsignacionDocumentacionOm());
                    if(pstDel.executeUpdate()>0)LOGGER.info("psdel se eliminadon registros");
                    pstReg.setInt(1,bean.getDocumentacion().getCodDocumento());LOGGER.info("pstreg p1:"+bean.getDocumentacion().getCodDocumento());
                    pstReg.setInt(2,bean.getTiposAsignacionDocumentoOm().getCodTipoAsignacionDocumentacionOm());LOGGER.info("pstreg  p2: "+bean.getTiposAsignacionDocumentoOm().getCodTipoAsignacionDocumentacionOm());
                    if(pstReg.executeUpdate()>0)LOGGER.info("pstreg se realizo la duplicacion");
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
    
    //<editor-fold desc="getter and setter" defaultstate="collapsed">
    
        public List<Documentacion> getDocumentacionAgregarList() {
            return documentacionAgregarList;
        }

        public void setDocumentacionAgregarList(List<Documentacion> documentacionAgregarList) {
            this.documentacionAgregarList = documentacionAgregarList;
        }

        public FormasFarmaceuticasDocumentacionAplicada getFormasFarmaceuticasDocumentacionAplicadaAgregar() {
            return formasFarmaceuticasDocumentacionAplicadaAgregar;
        }

        public void setFormasFarmaceuticasDocumentacionAplicadaAgregar(FormasFarmaceuticasDocumentacionAplicada formasFarmaceuticasDocumentacionAplicadaAgregar) {
            this.formasFarmaceuticasDocumentacionAplicadaAgregar = formasFarmaceuticasDocumentacionAplicadaAgregar;
        }
    
    
        public String getMensaje() {
            return mensaje;
        }

        public void setMensaje(String mensaje) {
            this.mensaje = mensaje;
        }

    public FormasFarmaceuticasDocumentacionAplicada getFormasFarmaceuticasDocumentacionAplicadaBean() {
        return formasFarmaceuticasDocumentacionAplicadaBean;
    }

    public void setFormasFarmaceuticasDocumentacionAplicadaBean(FormasFarmaceuticasDocumentacionAplicada formasFarmaceuticasDocumentacionAplicadaBean) {
        this.formasFarmaceuticasDocumentacionAplicadaBean = formasFarmaceuticasDocumentacionAplicadaBean;
    }

        

        public HtmlDataTable getFormasFarmaceuticasDataTable() {
            return formasFarmaceuticasDataTable;
        }

        public void setFormasFarmaceuticasDataTable(HtmlDataTable formasFarmaceuticasDataTable) {
            this.formasFarmaceuticasDataTable = formasFarmaceuticasDataTable;
        }

        public List<FormasFarmaceuticasDocumentacionAplicada> getFormasFarmaceuticasDocumentacionAplicadaList() {
            return formasFarmaceuticasDocumentacionAplicadaList;
        }

        public void setFormasFarmaceuticasDocumentacionAplicadaList(List<FormasFarmaceuticasDocumentacionAplicada> formasFarmaceuticasDocumentacionAplicadaList) {
            this.formasFarmaceuticasDocumentacionAplicadaList = formasFarmaceuticasDocumentacionAplicadaList;
        }

        public List<FormasFarmaceuticas> getFormasFarmaceuticasList() {
            return formasFarmaceuticasList;
        }

        public void setFormasFarmaceuticasList(List<FormasFarmaceuticas> formasFarmaceuticasList) {
            this.formasFarmaceuticasList = formasFarmaceuticasList;
        }

        public List<SelectItem> getTiposAsignacionDocumentoOmSelectList() {
            return tiposAsignacionDocumentoOmSelectList;
        }

        public void setTiposAsignacionDocumentoOmSelectList(List<SelectItem> tiposAsignacionDocumentoOmSelectList) {
            this.tiposAsignacionDocumentoOmSelectList = tiposAsignacionDocumentoOmSelectList;
        }
        
    
    //</editor-fold>

    

    

    
}
