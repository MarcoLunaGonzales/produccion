/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.web;

import com.cofar.bean.FormasFarmaceuticas;
import com.cofar.bean.FormasFarmaceuticasIndicaciones;
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
public class ManagedFormasFarmaceuticasIndicaciones extends ManagedBean
{
    private Connection con;
    private List<FormasFarmaceuticas> formasFarmaceuticasList;
    private List<FormasFarmaceuticasIndicaciones> formasFarmaceuticasIndicacionesList;
    private List<SelectItem> procesosOrdenManufacturaSelectList;
    private FormasFarmaceuticas formasFarmaceuticaBean;
    private HtmlDataTable formasFarmaceuticasDataTable=new HtmlDataTable();
    private FormasFarmaceuticasIndicaciones formasFarmaceuticasIndicacionEditar;
    private int codProcesoOrdenManufactura=0;
    private String mensaje="";

    /**
     * Creates a new instance of ManagedFormasFarmaceuticasIndicaciones
     */
    public ManagedFormasFarmaceuticasIndicaciones() 
    {
        LOGGER=LogManager.getLogger("Versionamiento");
        formasFarmaceuticaBean=new FormasFarmaceuticas();
    }
    private void cargarProcesosOrdenManufacturaHabilitadosSelectList()
    {
        try 
        {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select POM.COD_PROCESO_ORDEN_MANUFACTURA,pom.NOMBRE_PROCESO_ORDEN_MANUFACTURA");
                                        consulta.append(" from PROCESOS_ORDEN_MANUFACTURA pom ");
                                        consulta.append(" where pom.COD_PROCESO_ORDEN_MANUFACTURA in ");
                                        consulta.append(" (");
                                                consulta.append("select ffi.COD_PROCESO_ORDEN_MANUFACTURA from FORMAS_FARMACEUTICAS_INDICACIONES ffi where ffi.COD_FORMA=").append(formasFarmaceuticaBean.getCodForma());
                                        consulta.append(" )");
                                        consulta.append(" order by pom.NOMBRE_PROCESO_ORDEN_MANUFACTURA");
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            procesosOrdenManufacturaSelectList=new ArrayList<SelectItem>();
            while (res.next()) 
            {
                procesosOrdenManufacturaSelectList.add(new SelectItem(res.getInt("COD_PROCESO_ORDEN_MANUFACTURA"),res.getString("NOMBRE_PROCESO_ORDEN_MANUFACTURA")));
            }
            res.close();
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
    public String duplicarIndicacionEnProductosActivosProceso_action()throws SQLException
    {
        mensaje = "";
        try 
        {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
                for(FormasFarmaceuticasIndicaciones bean:formasFarmaceuticasIndicacionesList)
                {
                    if(bean.getChecked())
                    {

                            StringBuilder consulta = new StringBuilder("delete INDICACION_PROCESO");
                                                    consulta.append(" where COD_PROCESO_ORDEN_MANUFACTURA=").append(bean.getProcesosOrdenManufactura().getCodProcesoOrdenManufactura());
                                                            consulta.append(" and COD_TIPO_INDICACION_PROCESO=").append(bean.getTiposIndicacionProceso().getCodTipoIndicacionProceso());
                                                            consulta.append(" and COD_VERSION IN");
                                                            consulta.append(" (");
                                                                    consulta.append(" select c.COD_VERSION");
                                                                    consulta.append(" from COMPONENTES_PROD_VERSION c ");
                                                                    consulta.append(" where c.COD_ESTADO_COMPPROD=1");
                                                                    consulta.append(" and c.COD_ESTADO_VERSION in (1,2,3,5,7)");
                                                                    consulta.append(" and c.COD_FORMA=").append(formasFarmaceuticaBean.getCodForma());
                                                            consulta.append(")");
                            LOGGER.debug("consulta delete indicaciones procesos" + consulta.toString());
                            PreparedStatement pst = con.prepareStatement(consulta.toString());
                            if (pst.executeUpdate() > 0) LOGGER.info("se eliminaron las indicaciones");
                            consulta=new StringBuilder("INSERT INTO INDICACION_PROCESO(INDICACION_PROCESO, COD_TIPO_INDICACION_PROCESO,COD_PROCESO_ORDEN_MANUFACTURA, COD_VERSION)");
                                    consulta.append(" select ffi.INDICACION_FORMA,ffi.COD_TIPO_INDICACION_PROCESO,ffi.COD_PROCESO_ORDEN_MANUFACTURA,cpv.COD_VERSION");
                                    consulta.append(" from COMPONENTES_PROD_VERSION cpv");
                                            consulta.append(" inner join FORMAS_FARMACEUTICAS_INDICACIONES ffi on ffi.COD_FORMA =cpv.COD_FORMA");
                                    consulta.append(" where cpv.COD_FORMA =").append(formasFarmaceuticaBean.getCodForma());
                                            consulta.append(" and ffi.COD_PROCESO_ORDEN_MANUFACTURA=").append(bean.getProcesosOrdenManufactura().getCodProcesoOrdenManufactura());
                                            consulta.append(" and ffi.COD_TIPO_INDICACION_PROCESO=").append(bean.getTiposIndicacionProceso().getCodTipoIndicacionProceso());
                                            consulta.append(" and cpv.COD_ESTADO_VERSION in (1,2,3,5,7)");
                                            consulta.append(" and cpv.COD_ESTADO_COMPPROD=1");
                            LOGGER.debug("consulta registrar indicacion proceso "+consulta.toString());
                            pst=con.prepareStatement(consulta.toString());
                            if(pst.executeUpdate()>0)LOGGER.info("se duplico la actividad");
                        
                    }
                }
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
    public String editarFormaFarmaceuticaIndicacion_action()
    {
        for(FormasFarmaceuticasIndicaciones bean:formasFarmaceuticasIndicacionesList)
        {
            if(bean.getChecked())
            {
                formasFarmaceuticasIndicacionEditar=bean;
                break;
            }
        }
        return null;
    }
    private void cargarFormasFarmaceuticasIndicaciones()
    {
        try 
        {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select tid.NOMBRE_TIPO_INDICACION_PROCESO,tid.COD_TIPO_INDICACION_PROCESO,ffi.INDICACION_FORMA");
                                        consulta.append(" ,ffi.COD_PROCESO_ORDEN_MANUFACTURA,pom.NOMBRE_PROCESO_ORDEN_MANUFACTURA");
                                        consulta.append(" from FORMAS_FARMACEUTICAS_INDICACIONES ffi ");
                                            consulta.append(" inner join TIPOS_INDICACION_PROCESO tid on tid.COD_TIPO_INDICACION_PROCESO=ffi.COD_TIPO_INDICACION_PROCESO");
                                            consulta.append(" inner join PROCESOS_ORDEN_MANUFACTURA pom on pom.COD_PROCESO_ORDEN_MANUFACTURA=ffi.COD_PROCESO_ORDEN_MANUFACTURA");
                                        consulta.append(" where ffi.COD_FORMA='").append(formasFarmaceuticaBean.getCodForma()).append("'");
                                            if(codProcesoOrdenManufactura>0)
                                                consulta.append(" and ffi.COD_PROCESO_ORDEN_MANUFACTURA=").append(codProcesoOrdenManufactura);
                                        consulta.append(" order by pom.NOMBRE_PROCESO_ORDEN_MANUFACTURA,tid.NOMBRE_TIPO_INDICACION_PROCESO");
            LOGGER.debug("consulta cargar indicaciones "+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            formasFarmaceuticasIndicacionesList=new ArrayList<FormasFarmaceuticasIndicaciones>();
            while (res.next()) 
            {
                FormasFarmaceuticasIndicaciones nuevo=new FormasFarmaceuticasIndicaciones();
                nuevo.getProcesosOrdenManufactura().setCodProcesoOrdenManufactura(res.getInt("COD_PROCESO_ORDEN_MANUFACTURA"));
                nuevo.getProcesosOrdenManufactura().setNombreProcesoOrdenManufactura(res.getString("NOMBRE_PROCESO_ORDEN_MANUFACTURA"));
                nuevo.getTiposIndicacionProceso().setCodTipoIndicacionProceso(res.getInt("COD_TIPO_INDICACION_PROCESO"));
                nuevo.getTiposIndicacionProceso().setNombreTipoIndicacionProceso(res.getString("NOMBRE_TIPO_INDICACION_PROCESO"));
                nuevo.setIndicacionesForma(res.getString("INDICACION_FORMA"));
                formasFarmaceuticasIndicacionesList.add(nuevo);
                
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
    public String getCargarFormasFarmaceuticasIndicaciones()
    {
        procesosOrdenManufacturaSelectList=new ArrayList<SelectItem>();
        this.cargarFormasFarmaceuticasIndicaciones();
        this.cargarFormasFarmaceuticas();
        return null;
    }
    public String seleccionarFormaFarmaceutica_action()
    {
        formasFarmaceuticaBean=(FormasFarmaceuticas)formasFarmaceuticasDataTable.getRowData();
        codProcesoOrdenManufactura=0;
        this.cargarFormasFarmaceuticasIndicaciones();
        this.cargarProcesosOrdenManufacturaHabilitadosSelectList();
        return null;
    }
    public String codProcesoOrdenManufactura_change()
    {
        this.cargarFormasFarmaceuticasIndicaciones();
        return null;
    }
    private void cargarFormasFarmaceuticas()
    {
        try 
        {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select ff.cod_forma,ff.nombre_forma,ff.abreviatura_forma");
                                        consulta.append(" from FORMAS_FARMACEUTICAS ff ");
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
    public String guardarEditarFormaFarmaceuticaIndicacion_action()throws SQLException
    {
        mensaje = "";
        try 
        {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta = new StringBuilder("UPDATE FORMAS_FARMACEUTICAS_INDICACIONES");
                                    consulta.append(" set INDICACION_FORMA=?");
                                    consulta.append(" where COD_FORMA=").append(formasFarmaceuticaBean.getCodForma());
                                        consulta.append(" and COD_TIPO_INDICACION_PROCESO=").append(formasFarmaceuticasIndicacionEditar.getTiposIndicacionProceso().getCodTipoIndicacionProceso());
                                        consulta.append(" and COD_PROCESO_ORDEN_MANUFACTURA=").append(formasFarmaceuticasIndicacionEditar.getProcesosOrdenManufactura().getCodProcesoOrdenManufactura());
            LOGGER.debug("consulta " + consulta.toString());
            PreparedStatement pst = con.prepareStatement(consulta.toString());
            pst.setString(1,formasFarmaceuticasIndicacionEditar.getIndicacionesForma());
            if (pst.executeUpdate() > 0)LOGGER.info("Se actualizo la transacción");
            con.commit();
            mensaje = "1";
            pst.close();
        } 
        catch (SQLException ex) 
        {
            mensaje = "Ocurrio un error al momento de guardar la transaccion";
            con.rollback();
            LOGGER.warn(ex.getMessage());
        } 
        catch (Exception ex) 
        {
            mensaje = "Ocurrio un error al momento de guardar la transaccion,verifique los datos introducidos";
            LOGGER.warn(ex.getMessage());
        } 
        finally 
        {
            this.cerrarConexion(con);
        }
        if(mensaje.equals("1"))
        {
            this.cargarFormasFarmaceuticasIndicaciones();
        }
        return null;
    }

    public List<FormasFarmaceuticas> getFormasFarmaceuticasList() {
        return formasFarmaceuticasList;
    }

    public void setFormasFarmaceuticasList(List<FormasFarmaceuticas> formasFarmaceuticasList) {
        this.formasFarmaceuticasList = formasFarmaceuticasList;
    }

    public List<FormasFarmaceuticasIndicaciones> getFormasFarmaceuticasIndicacionesList() {
        return formasFarmaceuticasIndicacionesList;
    }

    public void setFormasFarmaceuticasIndicacionesList(List<FormasFarmaceuticasIndicaciones> formasFarmaceuticasIndicacionesList) {
        this.formasFarmaceuticasIndicacionesList = formasFarmaceuticasIndicacionesList;
    }

    public FormasFarmaceuticas getFormasFarmaceuticaBean() {
        return formasFarmaceuticaBean;
    }

    public void setFormasFarmaceuticaBean(FormasFarmaceuticas formasFarmaceuticaBean) {
        this.formasFarmaceuticaBean = formasFarmaceuticaBean;
    }

    public HtmlDataTable getFormasFarmaceuticasDataTable() {
        return formasFarmaceuticasDataTable;
    }

    public void setFormasFarmaceuticasDataTable(HtmlDataTable formasFarmaceuticasDataTable) {
        this.formasFarmaceuticasDataTable = formasFarmaceuticasDataTable;
    }

    public FormasFarmaceuticasIndicaciones getFormasFarmaceuticasIndicacionEditar() {
        return formasFarmaceuticasIndicacionEditar;
    }

    public void setFormasFarmaceuticasIndicacionEditar(FormasFarmaceuticasIndicaciones formasFarmaceuticasIndicacionEditar) {
        this.formasFarmaceuticasIndicacionEditar = formasFarmaceuticasIndicacionEditar;
    }

    public String getMensaje() {
        return mensaje;
    }

    public void setMensaje(String mensaje) {
        this.mensaje = mensaje;
    }

    public List<SelectItem> getProcesosOrdenManufacturaSelectList() {
        return procesosOrdenManufacturaSelectList;
    }

    public void setProcesosOrdenManufacturaSelectList(List<SelectItem> procesosOrdenManufacturaSelectList) {
        this.procesosOrdenManufacturaSelectList = procesosOrdenManufacturaSelectList;
    }

    public int getCodProcesoOrdenManufactura() {
        return codProcesoOrdenManufactura;
    }

    public void setCodProcesoOrdenManufactura(int codProcesoOrdenManufactura) {
        this.codProcesoOrdenManufactura = codProcesoOrdenManufactura;
    }
    
    
    
}
