/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.web;

import com.cofar.bean.EspecificacionesProcesos;
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
 * @author DASISAQ-
 */
public class ManagedEspecificacionesProcesos extends ManagedBean{

    private Connection con=null;
    private String mensaje="";
    private List<EspecificacionesProcesos> especificacionesProcesosList;
    private EspecificacionesProcesos especificacionesProcesoBuscar=new EspecificacionesProcesos();
    private EspecificacionesProcesos especificacionesProcesoAgregar;
    private EspecificacionesProcesos especificacionesProcesoEditar;
    private List<SelectItem> procesosOrdenManufacturaSelectList;
    private List<SelectItem> unidadesMedidaSelectList;
    private List<SelectItem> tiposDescripcionSelectList;
    private List<SelectItem> tiposEspecificacionesProcesosSelectList;
    public ManagedEspecificacionesProcesos() 
    {
        LOGGER=LogManager.getLogger("Versionamiento");
        especificacionesProcesoBuscar.getTiposEspecificacionesProcesos().setCodTipoEspecificaciónProceso(1);
    }
    public String getCargarEspecificacionesProcesos()
    {
        
        this.cargarTiposDescripcionSelect();
        this.cargarTiposEspecificacionesProcesosSelect();
        this.cargarUnidadesMedidaSelect();
        //this.cargarProcesoOrdenManufactura();
        this.cargarEspecificacionesProcesos();
        return null;
    }
    private void cargarTiposEspecificacionesProcesosSelect()
    {
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select tep.COD_TIPO_ESPECIFICACION_PROCESO,tep.NOMBRE_TIPO_ESPECIFICACION_PROCESO");
                                        consulta.append(" from TIPOS_ESPECIFICACIONES_PROCESOS tep ");
                                        consulta.append(" order by tep.NOMBRE_TIPO_ESPECIFICACION_PROCESO");
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            tiposEspecificacionesProcesosSelectList=new ArrayList<SelectItem>();
            while (res.next()) 
            {
                tiposEspecificacionesProcesosSelectList.add(new SelectItem(res.getString("COD_TIPO_ESPECIFICACION_PROCESO"),res.getString("NOMBRE_TIPO_ESPECIFICACION_PROCESO")));
            }
            st.close();
        } 
        catch (SQLException ex) 
        {
            LOGGER.warn("error", ex);
        } finally {
            this.cerrarConexion(con);
        }
    }
    private void cargarTiposDescripcionSelect()
    {
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select td.COD_TIPO_DESCRIPCION,td.NOMBRE_TIPO_DESCRIPCION");
                                     consulta.append(" from TIPOS_DESCRIPCION td ");
                                     consulta.append(" order by td.NOMBRE_TIPO_DESCRIPCION");      
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            tiposDescripcionSelectList=new ArrayList<SelectItem>();
            while (res.next()) 
            {
                tiposDescripcionSelectList.add(new SelectItem(res.getInt("COD_TIPO_DESCRIPCION"),res.getString("NOMBRE_TIPO_DESCRIPCION")));
            }
            st.close();
        } catch (SQLException ex) {
            LOGGER.warn("error", ex);
        } finally {
            this.cerrarConexion(con);
        }
    }
    private void cargarUnidadesMedidaSelect()
    {
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select um.COD_UNIDAD_MEDIDA,um.NOMBRE_UNIDAD_MEDIDA+'('+um.ABREVIATURA+')' as unidadMedida");
                                        consulta.append(" from UNIDADES_MEDIDA um order by um.NOMBRE_UNIDAD_MEDIDA");
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            unidadesMedidaSelectList=new ArrayList<SelectItem>();
            while (res.next()) 
            {
                unidadesMedidaSelectList.add(new SelectItem(res.getString("COD_UNIDAD_MEDIDA"),res.getString("unidadMedida")));
            }
            st.close();
        } catch (SQLException ex) {
            LOGGER.warn("error", ex);
        } finally {
            this.cerrarConexion(con);
        }
    }
    public String filtroCabecera_change()
    {
        this.cargarEspecificacionesProcesos();
        return null;
    }
    
    public String agregarEspecificacionesProcesos_action()
    {
        this.especificacionesProcesoAgregar=new EspecificacionesProcesos();
        //seteando tipo de descricpion a texto
        especificacionesProcesoAgregar.getTiposDescripcion().setCodTipoDescripcion(1);
        return null;
    }
    private int cantidadVersionesUtilizadas(EspecificacionesProcesos especificacion)
    {
        int cantidadVersiones=0;
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select count(*) as cantidadVersiones");
                                        consulta.append(" from COMPONENTES_PROD_VERSION cpv ");
                                            consulta.append(" left outer join COMPONENTES_PROD_VERSION_ESPECIFICACION_PROCESO cpvp on cpv.COD_VERSION=cpvp.COD_VERSION");
                                            consulta.append(" left outer join COMPONENTES_PROD_VERSION_MAQUINARIA_PROCESO cpvmp on cpvmp.COD_VERSION=cpv.COD_VERSION");
                                            consulta.append(" left outer join ESPECIFICACIONES_PROCESOS_PRODUCTO_MAQUINARIA eppm on eppm.COD_COMPPROD_VERSION_MAQUINARIA_PROCESO=cpvmp.COD_COMPPROD_VERSION_MAQUINARIA_PROCESO");
                                        consulta.append(" where cpv.COD_ESTADO_VERSION not in (1,5)");
                                            consulta.append(" and  (");
                                                consulta.append(" cpvp.COD_ESPECIFICACION_PROCESO=").append(especificacion.getCodEspecificacionProceso());
                                                consulta.append(" or eppm.COD_ESPECIFICACION_PROCESO=").append(especificacion.getCodEspecificacionProceso());
                                            consulta.append(")");
            LOGGER.debug("consulta cantidad de versiones relaciones con la especificacion "+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            if(res.next())cantidadVersiones=res.getInt("cantidadVersiones");
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
        return cantidadVersiones;
    }
    public String editarEspecificacionesProcesos_action()
    {
        for(EspecificacionesProcesos bean:especificacionesProcesosList)
        {
            if(bean.getChecked())
            {
                especificacionesProcesoEditar=bean;
                //verificando la cantidad de versiones en que se encuentra registrada la especificacion
                especificacionesProcesoEditar.setCantidadVersiones(this.cantidadVersionesUtilizadas(bean));
                break;
            }
        }
        return null;
    }
   
    private void cargarProcesoOrdenManufactura()
    {
        try 
        {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select pom.COD_PROCESO_ORDEN_MANUFACTURA,pom.NOMBRE_PROCESO_ORDEN_MANUFACTURA");
                                        consulta.append(" from PROCESOS_ORDEN_MANUFACTURA pom");
                                        consulta.append(" order by pom.NOMBRE_PROCESO_ORDEN_MANUFACTURA");
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            procesosOrdenManufacturaSelectList=new ArrayList<SelectItem>();
            while (res.next()) 
            {
                procesosOrdenManufacturaSelectList.add(new SelectItem(res.getInt("COD_PROCESO_ORDEN_MANUFACTURA"),res.getString("NOMBRE_PROCESO_ORDEN_MANUFACTURA")));
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
    
    private void cargarEspecificacionesProcesos()
    {
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select ep.ORDEN,ep.PORCIENTO_TOLERANCIA,ep.COD_ESPECIFICACION_PROCESO,");
                                            consulta.append(" ep.NOMBRE_ESPECIFICACIONES_PROCESO,ep.COD_UNIDAD_MEDIDA,isnull(um.NOMBRE_UNIDAD_MEDIDA, '--NINGUNO--') as NOMBRE_UNIDAD_MEDIDA,");
                                            consulta.append(" ep.ESPECIFICACION_STANDAR_FORMA,ep.RESULTADO_NUMERICO,ep.VALOR_EXACTO,ep.VALOR_TEXTO,");
                                            consulta.append(" isnull(tep.COD_TIPO_ESPECIFICACION_PROCESO, 0) as COD_TIPO_ESPECIFICACION_PROCESO,");
                                            consulta.append(" isnull(tep.NOMBRE_TIPO_ESPECIFICACION_PROCESO, '') as NOMBRE_TIPO_ESPECIFICACION_PROCESO,ep.RESULTADO_ESPERADO_LOTE");
                                            consulta.append(" ,td.COD_TIPO_DESCRIPCION,td.NOMBRE_TIPO_DESCRIPCION,td.ESPECIFICACION");
                                            consulta.append(" ,ep.VALOR_MINIMO,ep.VALOR_MAXIMO");
                                        consulta.append(" from ESPECIFICACIONES_PROCESOS ep");
                                            consulta.append(" left outer join UNIDADES_MEDIDA um on ep.COD_UNIDAD_MEDIDA =um.COD_UNIDAD_MEDIDA");
                                            consulta.append(" left outer join TIPOS_ESPECIFICACIONES_PROCESOS tep on tep.COD_TIPO_ESPECIFICACION_PROCESO = ep.COD_TIPO_ESPECIFICACION_PROCESO");
                                            consulta.append(" left outer join TIPOS_DESCRIPCION td on td.COD_TIPO_DESCRIPCION=ep.COD_TIPO_DESCRIPCION");
                                        consulta.append(" where ep.COD_TIPO_ESPECIFICACION_PROCESO=").append(especificacionesProcesoBuscar.getTiposEspecificacionesProcesos().getCodTipoEspecificaciónProceso());
                                            consulta.append(" and ep.COD_FORMA=0");
                                        consulta.append(" order by ep.ORDEN");
            LOGGER.debug("consulta mostrar especificaciones procesos "+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            especificacionesProcesosList=new ArrayList<EspecificacionesProcesos>();
            while (res.next()) 
            {
                EspecificacionesProcesos especificacionesProcesos=new EspecificacionesProcesos();
                especificacionesProcesos.setCodEspecificacionProceso(res.getInt("COD_ESPECIFICACION_PROCESO"));
                especificacionesProcesos.setNombreEspecificacionProceso(res.getString("NOMBRE_ESPECIFICACIONES_PROCESO"));
                especificacionesProcesos.setOrden(res.getInt("ORDEN"));
                especificacionesProcesos.setPorcientoTolerancia(res.getDouble("PORCIENTO_TOLERANCIA"));
                especificacionesProcesos.getUnidadMedida().setCodUnidadMedida(res.getString("COD_UNIDAD_MEDIDA"));
                especificacionesProcesos.getUnidadMedida().setNombreUnidadMedida(res.getString("NOMBRE_UNIDAD_MEDIDA"));
                especificacionesProcesos.setEspecificacionStandarForma(res.getInt("ESPECIFICACION_STANDAR_FORMA")>0);
                especificacionesProcesos.setResultadoNumerico(res.getInt("RESULTADO_NUMERICO")>0);
                especificacionesProcesos.setValorTexto(res.getString("VALOR_TEXTO"));
                especificacionesProcesos.setValorExacto(res.getDouble("VALOR_EXACTO"));
                especificacionesProcesos.getTiposEspecificacionesProcesos().setCodTipoEspecificaciónProceso(res.getInt("COD_TIPO_ESPECIFICACION_PROCESO"));
                especificacionesProcesos.getTiposEspecificacionesProcesos().setNombreTipoEspecificacionProceso(res.getString("NOMBRE_TIPO_ESPECIFICACION_PROCESO"));
                especificacionesProcesos.setResultadoEsperadoLote(res.getInt("RESULTADO_ESPERADO_LOTE")>0);
                especificacionesProcesos.getTiposDescripcion().setCodTipoDescripcion(res.getInt("COD_TIPO_DESCRIPCION"));
                especificacionesProcesos.getTiposDescripcion().setNombreTipoDescripcion(res.getString("NOMBRE_TIPO_DESCRIPCION"));
                especificacionesProcesos.getTiposDescripcion().setEspecificacion(res.getString("ESPECIFICACION"));
                especificacionesProcesos.setValorMinimo(res.getDouble("VALOR_MINIMO"));
                especificacionesProcesos.setValorMaximo(res.getDouble("VALOR_MAXIMO"));
                       
                especificacionesProcesosList.add(especificacionesProcesos);
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
    
    public String eliminarEspecificacionProceso_action()throws SQLException
    {
        mensaje="";
        for(EspecificacionesProcesos bean:especificacionesProcesosList)
        {
            if(bean.getChecked())
            {
                if(this.cantidadVersionesUtilizadas(bean)==0)
                {
                    try 
                    {
                        con = Util.openConnection(con);
                        con.setAutoCommit(false);
                        StringBuilder consulta = new StringBuilder("delete ESPECIFICACIONES_PROCESOS");
                                                consulta.append(" where COD_ESPECIFICACION_PROCESO=").append(bean.getCodEspecificacionProceso());
                        LOGGER.debug("consulta eliminar especificacion proceso" + consulta.toString());
                        PreparedStatement pst = con.prepareStatement(consulta.toString());
                        if (pst.executeUpdate() > 0) LOGGER.info("Se elimino la especificacion proceso");
                        con.commit();
                        mensaje="1";
                        pst.close();
                    } 
                    catch (SQLException ex) 
                    {
                        con.rollback();
                        mensaje="Ocurrio un error al momento de eliminar la especificación";
                        LOGGER.warn(ex.getMessage());
                    } 
                    catch (Exception ex) 
                    {
                        mensaje="Ocurrio un error al momento de eliminar la especificación";
                        LOGGER.warn(ex.getMessage());
                    } finally {
                        this.cerrarConexion(con);
                    }
                }
                else
                {
                    mensaje="No se puede eliminar la especificación porque esta siendo utilizada en el versionamiento de productos";
                }
                break;
            }
        }
        if(mensaje.equals("1"))
        {
            this.cargarEspecificacionesProcesos();
        }
        return null;
    }

    public String guardarEdicionEspecificacionProceso_action()throws SQLException
    {
        mensaje="";
        try 
        {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta = new StringBuilder("update ESPECIFICACIONES_PROCESOS ");
                                        consulta.append("set COD_UNIDAD_MEDIDA=").append(especificacionesProcesoEditar.getUnidadMedida().getCodUnidadMedida()).append(",");
                                            consulta.append(" VALOR_EXACTO=").append(especificacionesProcesoEditar.getValorExacto()).append(",");
                                            consulta.append(" VALOR_TEXTO=?,");
                                            consulta.append(" VALOR_MINIMO=").append(especificacionesProcesoEditar.getValorMinimo()).append(",");
                                            consulta.append(" VALOR_MAXIMO=").append(especificacionesProcesoEditar.getValorMaximo()).append(",");
                                            consulta.append(" PORCIENTO_TOLERANCIA=").append(especificacionesProcesoEditar.getPorcientoTolerancia()).append(",");
                                            consulta.append(" COD_TIPO_DESCRIPCION=").append(especificacionesProcesoEditar.getTiposDescripcion().getCodTipoDescripcion()).append(",");
                                            consulta.append(" RESULTADO_ESPERADO_LOTE=").append(especificacionesProcesoEditar.isResultadoEsperadoLote()?1:0).append(",");
                                            consulta.append(" NOMBRE_ESPECIFICACIONES_PROCESO='").append(especificacionesProcesoEditar.getNombreEspecificacionProceso()).append("'");
                                        consulta.append(" where COD_ESPECIFICACION_PROCESO=").append(especificacionesProcesoEditar.getCodEspecificacionProceso());
            LOGGER.debug("consulta " + consulta.toString());
            PreparedStatement pst = con.prepareStatement(consulta.toString());
            pst.setString(1,especificacionesProcesoEditar.getValorTexto());
            if (pst.executeUpdate() > 0) {
                LOGGER.info("Se registro la transacción");
            }
            con.commit();
            mensaje="1";
            pst.close();
        } 
        catch (SQLException ex) 
        {
            mensaje="Ocurrio un error al momento de guardar la edición";
            con.rollback();
            LOGGER.warn(ex.getMessage());
        } 
        catch (Exception ex) 
        {
            mensaje="Ocurrio un error al momento de guardar la edición, por favor revise los datos introducidos";
            LOGGER.warn(ex.getMessage());
        } 
        finally 
        {
            this.cerrarConexion(con);
        }
        if(mensaje.equals("1"))
        {
            this.cargarEspecificacionesProcesos();
        }
        return null;
        
    }
    public String guardarAgregarEspecificacionProceso_action()throws SQLException
    {
        mensaje="";
        try 
        {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta = new StringBuilder("select isnull(max(ep.ORDEN),0)+1 as orden");
                                     consulta.append(" from ESPECIFICACIONES_PROCESOS ep");
                                     consulta.append(" where ep.COD_TIPO_ESPECIFICACION_PROCESO=").append(especificacionesProcesoBuscar.getTiposEspecificacionesProcesos().getCodTipoEspecificaciónProceso());
            LOGGER.debug("consulta correlativo");
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta.toString());
            if(res.next())especificacionesProcesoAgregar.setOrden(res.getInt("orden"));
            consulta=new StringBuilder("INSERT INTO ESPECIFICACIONES_PROCESOS(NOMBRE_ESPECIFICACIONES_PROCESO, COD_UNIDAD_MEDIDA,");
                        consulta.append(" VALOR_EXACTO, VALOR_TEXTO, RESULTADO_NUMERICO, ESPECIFICACION_STANDAR_FORMA,PORCIENTO_TOLERANCIA,ORDEN,");
                        consulta.append(" COD_TIPO_ESPECIFICACION_PROCESO,RESULTADO_ESPERADO_LOTE,");
                        consulta.append(" COD_TIPO_DESCRIPCION, VALOR_MINIMO,VALOR_MAXIMO)");
                        consulta.append(" VALUES (");
                            consulta.append("'").append(especificacionesProcesoAgregar.getNombreEspecificacionProceso()).append("',");
                            consulta.append(especificacionesProcesoAgregar.getUnidadMedida().getCodUnidadMedida()).append(",");
                            consulta.append(especificacionesProcesoAgregar.getValorExacto()).append(",");
                            consulta.append("?,");
                            consulta.append(especificacionesProcesoAgregar.isResultadoNumerico()?"1":"0").append(",");
                            consulta.append(especificacionesProcesoAgregar.isEspecificacionStandarForma()?"1":"0").append(",");
                            consulta.append(especificacionesProcesoAgregar.getPorcientoTolerancia()).append(",");
                            consulta.append(especificacionesProcesoAgregar.getOrden()).append(",");
                            consulta.append(especificacionesProcesoBuscar.getTiposEspecificacionesProcesos().getCodTipoEspecificaciónProceso()).append(",");
                            consulta.append(especificacionesProcesoAgregar.isResultadoEsperadoLote()?1:0).append(",");
                            consulta.append(especificacionesProcesoAgregar.getTiposDescripcion().getCodTipoDescripcion()).append(",");
                            consulta.append(especificacionesProcesoAgregar.getValorMinimo()).append(",");
                            consulta.append(especificacionesProcesoAgregar.getValorMaximo());
                        consulta.append(")");
            LOGGER.debug("consulta " + consulta.toString());
            PreparedStatement pst = con.prepareStatement(consulta.toString(), PreparedStatement.RETURN_GENERATED_KEYS);
            pst.setString(1, especificacionesProcesoAgregar.getValorTexto());
            if (pst.executeUpdate() > 0) LOGGER.info("Se registro la transacción");
            con.commit();
            mensaje="1";
            pst.close();
        }
        catch (SQLException ex) 
        {
            mensaje="OCurrio un error al momento de guardar la especificacion de proceso";
            con.rollback();
            LOGGER.warn(ex.getMessage());
        } 
        catch (Exception ex) 
        {
            mensaje="OCurrio un error al momento de guardar la especificacion de proceso";
            LOGGER.warn(ex.getMessage());
        } 
        finally 
        {
            this.cerrarConexion(con);
        }
        if(mensaje.equals("1"))
        {
            this.cargarEspecificacionesProcesos();
        }
        return null;
    }
    public String getMensaje() {
        return mensaje;
    }

    public void setMensaje(String mensaje) {
        this.mensaje = mensaje;
    }

    public List<EspecificacionesProcesos> getEspecificacionesProcesosList() {
        return especificacionesProcesosList;
    }

    public void setEspecificacionesProcesosList(List<EspecificacionesProcesos> especificacionesProcesosList) {
        this.especificacionesProcesosList = especificacionesProcesosList;
    }

    public EspecificacionesProcesos getEspecificacionesProcesoBuscar() {
        return especificacionesProcesoBuscar;
    }

    public void setEspecificacionesProcesoBuscar(EspecificacionesProcesos especificacionesProcesoBuscar) {
        this.especificacionesProcesoBuscar = especificacionesProcesoBuscar;
    }

    public List<SelectItem> getProcesosOrdenManufacturaSelectList() {
        return procesosOrdenManufacturaSelectList;
    }

    public void setProcesosOrdenManufacturaSelectList(List<SelectItem> procesosOrdenManufacturaSelectList) {
        this.procesosOrdenManufacturaSelectList = procesosOrdenManufacturaSelectList;
    }


    public List<SelectItem> getUnidadesMedidaSelectList() {
        return unidadesMedidaSelectList;
    }

    public void setUnidadesMedidaSelectList(List<SelectItem> unidadesMedidaSelectList) {
        this.unidadesMedidaSelectList = unidadesMedidaSelectList;
    }

    public List<SelectItem> getTiposEspecificacionesProcesosSelectList() {
        return tiposEspecificacionesProcesosSelectList;
    }

    public void setTiposEspecificacionesProcesosSelectList(List<SelectItem> tiposEspecificacionesProcesosSelectList) {
        this.tiposEspecificacionesProcesosSelectList = tiposEspecificacionesProcesosSelectList;
    }

    public List<SelectItem> getTiposDescripcionSelectList() {
        return tiposDescripcionSelectList;
    }

    public void setTiposDescripcionSelectList(List<SelectItem> tiposDescripcionSelectList) {
        this.tiposDescripcionSelectList = tiposDescripcionSelectList;
    }
    
    
    public EspecificacionesProcesos getEspecificacionesProcesoAgregar() {
        return especificacionesProcesoAgregar;
    }

    public void setEspecificacionesProcesoAgregar(EspecificacionesProcesos especificacionesProcesoAgregar) {
        this.especificacionesProcesoAgregar = especificacionesProcesoAgregar;
    }

    public EspecificacionesProcesos getEspecificacionesProcesoEditar() {
        return especificacionesProcesoEditar;
    }

    public void setEspecificacionesProcesoEditar(EspecificacionesProcesos especificacionesProcesoEditar) {
        this.especificacionesProcesoEditar = especificacionesProcesoEditar;
    }
    
}
