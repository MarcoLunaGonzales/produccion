/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.web;

import com.cofar.bean.DesviacionProduccion;
import com.cofar.bean.ProgramaProduccion;
import com.cofar.util.Util;
import java.sql.Connection;
import java.util.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import javax.faces.model.SelectItem;
import org.apache.logging.log4j.LogManager;
import org.richfaces.component.html.HtmlDataTable;

/**
 *
 * @author DASISAQ
 */
public class ManagedDesviacionProduccion extends ManagedBean
{
    private Connection con=null;
    private String mensaje="";
    private List<DesviacionProduccion> desviacionProduccionList;
    private DesviacionProduccion desviacionProduccionAgregar;
    private List<SelectItem> areasEmpresaSelectList;
    private List<SelectItem> tiposDesviacionSelectList;
    private List<SelectItem> fuentesDesviacionSelectList;
    private List<ProgramaProduccion> programaProduccionList;
    private HtmlDataTable programaProduccionDataTable;
    private String codLoteProduccionBuscar;

    /**
     * Creates a new instance of ManagedDesviacionProduccion
     */
    public ManagedDesviacionProduccion() {
        LOGGER=LogManager.getLogger("Versionamiento");
    }
    //<editor-fold desc="desviaciones personal" defaultstate="collapsed">
        private void buscarLoteProduccion_action()
        {
            try 
            {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select ppp.COD_PROGRAMA_PROD,ppp.NOMBRE_PROGRAMA_PROD,pp.COD_LOTE_PRODUCCION,pp.COD_COMPPROD_VERSION,");
                                                    consulta.append(" ff.nombre_forma,tpp.COD_TIPO_PROGRAMA_PROD,tpp.NOMBRE_TIPO_PROGRAMA_PROD");
                                            consulta.append("from PROGRAMA_PRODUCCION pp ");
                                                    consulta.append(" inner join PROGRAMA_PRODUCCION_PERIODO ppp on pp.COD_PROGRAMA_PROD=ppp.COD_PROGRAMA_PROD");
                                                    consulta.append(" inner join COMPONENTES_PROD_VERSION cpv on cpv.COD_COMPPROD=pp.COD_COMPPROD");
                                                            consulta.append(" and pp.COD_COMPPROD_VERSION=cpv.COD_VERSION");
                                                    consulta.append(" inner join FORMAS_FARMACEUTICAS ff on ff.cod_forma=cpv.COD_FORMA");
                                                    consulta.append(" inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD");
                                            consulta.append(" where pp.COD_LOTE_PRODUCCION='").append(codLoteProduccionBuscar).append("'");
                                            consulta.append(" order by pp.COD_LOTE_PRODUCCION");
                LOGGER.debug("consulta buscar lote " + consulta.toString());
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                programaProduccionList=new ArrayList<ProgramaProduccion>();
                while (res.next()) 
                {
                    ProgramaProduccion nuevo=new ProgramaProduccion();
                    nuevo.getProgramaProduccionPeriodo().setCodProgramaProduccion(res.getString("COD_PROGRAMA_PROD"));
                    nuevo.getProgramaProduccionPeriodo().setNombreProgramaProduccion(res.getString("NOMBRE_PROGRAMA_PROD"));
                    nuevo.setCodLoteProduccion(res.getString("COD_LOTE_PRODUCCION"));
                    nuevo.getComponentesProdVersion().setCodVersion(res.getInt("COD_COMPPROD_VERSION"));
                    nuevo.getComponentesProdVersion().getForma().setNombreForma(res.getString("nombre_forma"));
                    nuevo.getTiposProgramaProduccion().setCodTipoProgramaProd(res.getString("COD_TIPO_PROGRAMA_PROD"));
                    nuevo.getTiposProgramaProduccion().setNombreTipoProgramaProd(res.getString("NOMBRE_TIPO_PROGRAMA_PROD"));
                    programaProduccionList.add(nuevo);
                    
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
        private void cargarFuentesDesviacionSelectList()
        {
            try {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select fdp.COD_FUENTE_DESVIACION_PRODUCCION,fdp.NOMBRE_FUENTE_DESVIACION_PRODUCCION");
                                            consulta.append(" from FUENTES_DESVIACION_PRODUCCION fdp");
                                            consulta.append(" order by fdp.NOMBRE_FUENTE_DESVIACION_PRODUCCION");
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                fuentesDesviacionSelectList=new ArrayList<SelectItem>();
                while (res.next()) 
                {
                    fuentesDesviacionSelectList.add(new SelectItem(res.getInt("COD_FUENTE_DESVIACION_PRODUCCION"),res.getString("NOMBRE_FUENTE_DESVIACION_PRODUCCION")));
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
        private void cargarTiposDesviacionSelectList()
        {
            try {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select tdp.COD_TIPO_DESVIACION_PRODUCCION,tdp.NOMBRE_TIPO_DESVIACION_PRODUCCION");
                                            consulta.append(" from TIPOS_DESVIACION_PRODUCCCION tdp ");
                                            consulta.append(" order by tdp.NOMBRE_TIPO_DESVIACION_PRODUCCION");
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                tiposDesviacionSelectList=new ArrayList<SelectItem>();
                while (res.next()) 
                {
                    tiposDesviacionSelectList.add(new SelectItem(res.getInt("COD_TIPO_DESVIACION_PRODUCCION"),res.getString("NOMBRE_TIPO_DESVIACION_PRODUCCION")));

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
        private void cargarAreasEmpresaSelectList()
        {
            try 
            {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select ae.COD_AREA_EMPRESA,ae.NOMBRE_AREA_EMPRESA");
                                            consulta.append(" from AREAS_EMPRESA ae ");
                                            consulta.append(" where ae.COD_ESTADO_REGISTRO=1");
                                            consulta.append(" order by ae.NOMBRE_AREA_EMPRESA");
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                areasEmpresaSelectList=new ArrayList<SelectItem>();
                while (res.next()) 
                {
                    areasEmpresaSelectList.add(new SelectItem(res.getString("COD_AREA_EMPRESA"),res.getString("NOMBRE_AREA_EMPRESA")));
                    
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
        public String getCargarDesviacionProduccionList()
        {
            this.cargarAreasEmpresaSelectList();
            this.cargarDesviacionProduccionList();
            this.cargarFuentesDesviacionSelectList();
            this.cargarTiposDesviacionSelectList();
            return null;
        }
        private void cargarDesviacionProduccionList()
        {
            ManagedAccesoSistema managed=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
            try 
            {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select dp.NRO_CORRELATIVO,dp.FECHA_DETECCION,dp.FECHA_INFORME,ae.COD_AREA_EMPRESA,ae.NOMBRE_AREA_EMPRESA");
                                                        consulta.append(" ,dp.COD_DESVIACION_PRODUCCION,tdp.COD_TIPO_DESVIACION_PRODUCCION,tdp.NOMBRE_TIPO_DESVIACION_PRODUCCION");
                                                        consulta.append(" ,fdp.COD_FUENTE_DESVIACION_PRODUCCION,fdp.NOMBRE_FUENTE_DESVIACION_PRODUCCION");
                                                consulta.append(" from DESVIACION_PRODUCCION dp ");
                                                        consulta.append(" inner join TIPOS_DESVIACION_PRODUCCCION tdp on tdp.COD_TIPO_DESVIACION_PRODUCCION=dp.COD_TIPO_DESVIACION_PRODUCCION");
                                                        consulta.append(" inner join FUENTES_DESVIACION_PRODUCCION fdp on fdp.COD_FUENTE_DESVIACION_PRODUCCION=dp.COD_FUENTE_DESVIACION_PRODUCCION");
                                                        consulta.append(" inner join AREAS_EMPRESA ae on ae.COD_AREA_EMPRESA=dp.COD_AREA_EMPRESA");
                                                consulta.append(" where dp.COD_PERSONAL=").append(managed.getUsuarioModuloBean().getCodUsuarioGlobal());
                                                consulta.append(" order by dp.FECHA_INFORME desc");
                LOGGER.debug("consulta cargar cargar desviaciones personal " + consulta.toString());
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                desviacionProduccionList=new ArrayList<DesviacionProduccion>();
                while (res.next()) 
                {
                    DesviacionProduccion nuevo=new DesviacionProduccion();
                    nuevo.setCodDesviacionProduccion(res.getInt("COD_DESVIACION_PRODUCCION"));
                    nuevo.setNroCorrelativo(res.getString("NRO_CORRELATIVO"));
                    nuevo.setFechaDeteccion(res.getTimestamp("FECHA_DETECCION"));
                    nuevo.setFechaInforme(res.getTimestamp("FECHA_INFORME"));
                    nuevo.getAreasEmpresa().setCodAreaEmpresa(res.getString("COD_AREA_EMPRESA"));
                    nuevo.getAreasEmpresa().setNombreAreaEmpresa(res.getString("NOMBRE_AREA_EMPRESA"));
                    nuevo.getTiposDesviacionProduccion().setCodTipoDesviacionProduccion(res.getInt("COD_TIPO_DESVIACION_PRODUCCION"));
                    nuevo.getTiposDesviacionProduccion().setNombreTipoDesviacionProduccion(res.getString("NOMBRE_TIPO_DESVIACION_PRODUCCION"));
                    nuevo.getFuentesDesviacionProduccion().setCodFuenteDesviacionProduccion(res.getInt("COD_FUENTE_DESVIACION_PRODUCCION"));
                    nuevo.getFuentesDesviacionProduccion().setNombreFuenteDesviacionProduccion(res.getString("NOMBRE_FUENTE_DESVIACION_PRODUCCION"));
                    desviacionProduccionList.add(nuevo);
                    
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
        
        public String guardarAgregarDesviacionProduccion_action()throws SQLException
        {
            mensaje = "";
            try {
                con = Util.openConnection(con);
                con.setAutoCommit(false);
                ManagedAccesoSistema managed=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
                SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
                StringBuilder consulta = new StringBuilder("INSERT INTO DESVIACION_PRODUCCION(COD_FORMATO_DOCUMENTACION_ASEGURAMIENTO, COD_PERSONAL, COD_AREA_EMPRESA,");
                                                    consulta.append(" COD_TIPO_DESVIACION_PRODUCCION, COD_FUENTE_DESVIACION_PRODUCCION,COD_LOTE_PRODUCCION, COD_PROGRAMA_PROD, FECHA_DETECCION, FECHA_INFORME,NRO_CORRELATIVO)");
                                            consulta.append(" VALUES (");
                                                    consulta.append(desviacionProduccionAgregar.getFormatoDocumentacionAseguramiento().getCodFormatoDocumentacionAseguramiento()).append(",");
                                                    consulta.append(managed.getUsuarioModuloBean().getCodUsuarioGlobal()).append(",");
                                                    consulta.append(desviacionProduccionAgregar.getAreasEmpresa().getCodAreaEmpresa()).append(",");
                                                    consulta.append(desviacionProduccionAgregar.getTiposDesviacionProduccion().getCodTipoDesviacionProduccion()).append(",");
                                                    consulta.append(desviacionProduccionAgregar.getFuentesDesviacionProduccion().getCodFuenteDesviacionProduccion()).append(",");
                                                    consulta.append("?,");//cod lote produccion 
                                                    consulta.append("'").append(desviacionProduccionAgregar.getProgramaProduccion().getProgramaProduccionPeriodo().getCodProgramaProduccion()).append("',");
                                                    consulta.append("?,");//fecha deteccion
                                                    consulta.append("?,");//fecha informe
                                                    consulta.append("''");
                                            consulta.append(")");
                LOGGER.debug("consulta registrar desviacion produccion" + consulta.toString());
                PreparedStatement pst = con.prepareStatement(consulta.toString(), PreparedStatement.RETURN_GENERATED_KEYS);
                pst.setString(1,desviacionProduccionAgregar.getProgramaProduccion().getCodLoteProduccion());LOGGER.info(" p1: "+desviacionProduccionAgregar.getProgramaProduccion().getCodLoteProduccion());
                pst.setString(2,sdf.format(desviacionProduccionAgregar.getFechaDeteccion()));LOGGER.info(" p2: "+sdf.format(desviacionProduccionAgregar.getFechaDeteccion()));
                pst.setString(3,sdf.format(desviacionProduccionAgregar.getFechaInforme()));LOGGER.info(" p3: "+sdf.format(desviacionProduccionAgregar.getFechaInforme()));
                if (pst.executeUpdate() > 0) LOGGER.info("se registro la desviacion produccion ");
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
        
        public String getCargarAgregarDesviacionProduccion()throws SQLException
        {
            desviacionProduccionAgregar=new DesviacionProduccion();
            programaProduccionDataTable=new HtmlDataTable();
            try 
            {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select fda.COD_FORMATO_DOCUMENTACION_ASEGURAMIENTO,fda.NRO_REVISION,fda.TITULO_DOCUMENTO");
                                            consulta.append(" from FORMATO_DOCUMENTACION_ASEGURAMIENTO fda");
                                            consulta.append(" where fda.COD_ESTADO_FORMATO_DOCUMENTACION_ASEGURAMIENTO=2");
                                                    consulta.append(" and fda.COD_TIPO_FORMATO_ASEGURAMIENTO=1");
                LOGGER.debug("consulta cargar agregar desviacion " + consulta.toString());
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                if(res.next()) {
                    
                    desviacionProduccionAgregar.getFormatoDocumentacionAseguramiento().setCodFormatoDocumentacionAseguramiento(res.getInt("COD_FORMATO_DOCUMENTACION_ASEGURAMIENTO"));
                    desviacionProduccionAgregar.getFormatoDocumentacionAseguramiento().setNroRevision(res.getInt("NRO_REVISION"));
                    desviacionProduccionAgregar.getFormatoDocumentacionAseguramiento().setTituloDocumento(res.getString("TITULO_DOCUMENTO"));
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
        public String cargarSeleccionarProgramaProduccion_action()
        {
            codLoteProduccionBuscar="";
            programaProduccionList=new ArrayList<ProgramaProduccion>();
            return null;
        }
    //</editor-fold>
        
    //<editor-fold desc="getter and setter" defaultstate="collapsed">

        public List<SelectItem> getAreasEmpresaSelectList() {
            return areasEmpresaSelectList;
        }

        public void setAreasEmpresaSelectList(List<SelectItem> areasEmpresaSelectList) {
            this.areasEmpresaSelectList = areasEmpresaSelectList;
        }


        
        public String getMensaje() {
            return mensaje;
        }

        public void setMensaje(String mensaje) {
            this.mensaje = mensaje;
        }

        public List<DesviacionProduccion> getDesviacionProduccionList() {
            return desviacionProduccionList;
        }

        public void setDesviacionProduccionList(List<DesviacionProduccion> desviacionProduccionList) {
            this.desviacionProduccionList = desviacionProduccionList;
        }

        public DesviacionProduccion getDesviacionProduccionAgregar() {
            return desviacionProduccionAgregar;
        }

        public void setDesviacionProduccionAgregar(DesviacionProduccion desviacionProduccionAgregar) {
            this.desviacionProduccionAgregar = desviacionProduccionAgregar;
        }
        
        public List<SelectItem> getTiposDesviacionSelectList() {
            return tiposDesviacionSelectList;
        }

        public void setTiposDesviacionSelectList(List<SelectItem> tiposDesviacionSelectList) {
            this.tiposDesviacionSelectList = tiposDesviacionSelectList;
        }

        public List<SelectItem> getFuentesDesviacionSelectList() {
            return fuentesDesviacionSelectList;
        }

        public void setFuentesDesviacionSelectList(List<SelectItem> fuentesDesviacionSelectList) {
            this.fuentesDesviacionSelectList = fuentesDesviacionSelectList;
        }
        
        public List<ProgramaProduccion> getProgramaProduccionList() {
            return programaProduccionList;
        }

        public void setProgramaProduccionList(List<ProgramaProduccion> programaProduccionList) {
            this.programaProduccionList = programaProduccionList;
        }

        public HtmlDataTable getProgramaProduccionDataTable() {
            return programaProduccionDataTable;
        }

        public void setProgramaProduccionDataTable(HtmlDataTable programaProduccionDataTable) {
            this.programaProduccionDataTable = programaProduccionDataTable;
        }

        public String getCodLoteProduccionBuscar() {
            return codLoteProduccionBuscar;
        }

        public void setCodLoteProduccionBuscar(String codLoteProduccionBuscar) {
            this.codLoteProduccionBuscar = codLoteProduccionBuscar;
        }
        
        
    //</editor-fold>    

    

    

    
}
