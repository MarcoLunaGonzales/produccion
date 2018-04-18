/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.web;

import com.cofar.bean.ComponentesProdVersion;
import com.cofar.bean.ProcesosOrdenManufactura;
import com.cofar.bean.ProcesosPreparadoConsumoMaterialFm;
import com.cofar.bean.ProcesosPreparadoProducto;
import com.cofar.bean.ProcesosPreparadoProductoConsumo;
import com.cofar.bean.ProcesosPreparadoProductoConsumoMaterial;
import com.cofar.bean.ProcesosPreparadoProductoConsumoProceso;
import com.cofar.bean.ProcesosPreparadoProductoEspecificacionesMaquinaria;
import com.cofar.bean.ProcesosPreparadoProductoMaquinaria;
import com.cofar.dao.DaoActividadesPreparado;
import com.cofar.dao.DaoProcesosOrdenManufactura;
import com.cofar.dao.DaoProcesosPreparadoProducto;
import com.cofar.dao.DaoProcesosPreparadoProductoConsumo;
import com.cofar.dao.DaoProcesosPreparadoProductoEspecificacionesMaquinaria;
import com.cofar.dao.DaoProcesosPreparadoProductoMaquinaria;
import com.cofar.dao.DaoTiposDescripcion;
import com.cofar.dao.DaoUnidadesMedida;
import com.cofar.util.Util;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import javax.faces.context.FacesContext;
import javax.faces.model.SelectItem;
import org.apache.logging.log4j.LogManager;
import org.richfaces.component.html.HtmlDataTable;

/**
 *
 * @author DASISAQ-
 */
public class ManagedProcesosPreparadoProducto extends  ManagedBean
{
    private Connection con;
    private String mensaje;
    private List<ProcesosPreparadoProducto> procesosPreparadoProductoList;
    private ProcesosPreparadoProducto procesosPreparadoProductoBean;
    private ProcesosPreparadoProducto procesosPreparadoProductoListado;
    private ComponentesProdVersion componentesProdVersionBean;
    private ProcesosOrdenManufactura procesosOrdenManufacturaBean=new ProcesosOrdenManufactura();
    private List<ProcesosOrdenManufactura> procesosOrdenManufacturaList;
    private HtmlDataTable procesosPreparadoDataTable=new HtmlDataTable();
    private HtmlDataTable procesosOrdenManufacturaDataTable=new HtmlDataTable();
    private ProcesosPreparadoProductoMaquinaria procesosPreparadoProductoMaquinariaBean = new ProcesosPreparadoProductoMaquinaria();
    private List<SelectItem> tiposDescripcionSelectList;
    private ProcesosPreparadoProducto procesosPreparadoProductoMaterial;
    private List<ProcesosPreparadoProductoConsumo> procesosPreparadoProductoConsumoList;
    private List<ProcesosPreparadoProductoConsumo> procesosPreparadoProductoConsumoSeleccionadoList;
    private List<ProcesosPreparadoProducto> subProcesosPreparadoProductoList;
    private HtmlDataTable subProcesosPreparadoProductoDataTable=new HtmlDataTable();
    private List<SelectItem> unidadesMedidaSelectList;
    //para agregar proceso
    private ProcesosPreparadoProducto procesosPreparadoProductoAgregar;
    private ProcesosPreparadoProducto subProcesosPreparadoProductoAgregar;
    private ProcesosPreparadoProducto procesosPreparadoProductoEditar;
    private ProcesosPreparadoProducto subProcesosPreparadoProductoEditar;
    private List<SelectItem> actividadesPreparadoSelectList;
    private List<SelectItem> procesosPreparadoDestinoSelectList;
    /*
     * Creates a new instance of ManagedProcesosPreparadoProducto
     */
    
    // <editor-fold defaultstate="collapsed" desc="funciones sub Proceso">
    private void cargarProcesosPreparadoDestinoSelectList()
    {
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select ppp.COD_PROCESO_PREPARADO_PRODUCTO,cast(ppp.NRO_PASO as varchar)+' - '+ap.NOMBRE_ACTIVIDAD_PREPARADO as actividad");
                                        consulta.append(" from PROCESOS_PREPARADO_PRODUCTO ppp ");
                                        consulta.append(" inner join ACTIVIDADES_PREPARADO ap on ap.COD_ACTIVIDAD_PREPARADO=ppp.COD_ACTIVIDAD_PREPARADO");
                                        consulta.append(" where ppp.COD_PROCESO_PREPARADO_PRODUCTO_PADRE=0");
                                        consulta.append(" and ppp.COD_VERSION=").append(componentesProdVersionBean.getCodVersion());
                                        consulta.append(" and ppp.COD_PROCESO_ORDEN_MANUFACTURA=").append(procesosOrdenManufacturaBean.getCodProcesoOrdenManufactura());
                                        consulta.append(" order by ppp.NRO_PASO");
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            procesosPreparadoDestinoSelectList=new ArrayList<SelectItem>();
            while (res.next()) 
            {
                procesosPreparadoDestinoSelectList.add(new SelectItem(res.getInt("COD_PROCESO_PREPARADO_PRODUCTO"),res.getString("actividad")));
            }
            st.close();
        } catch (SQLException ex) {
            LOGGER.warn("error", ex);
        } finally {
            this.cerrarConexion(con);
        }
    }
    //</editor-fold>
    public String getCargarAgregarSubProcesosPreparadoProducto()
    {
        this.cargarProcesosPreparadoDestinoSelectList();
        subProcesosPreparadoProductoAgregar=new ProcesosPreparadoProducto();
        subProcesosPreparadoProductoAgregar.setProcesosPreparadoProductoDestino(new ProcesosPreparadoProducto());
        subProcesosPreparadoProductoAgregar.setComponentesProdVersion(componentesProdVersionBean);
        subProcesosPreparadoProductoAgregar.setProcesosOrdenManufactura(procesosOrdenManufacturaBean);
        subProcesosPreparadoProductoAgregar.setProcesosPreparadoProductoPadre(procesosPreparadoProductoBean);
        this.cargarActividadesPreparadoSelectList();
        DaoProcesosPreparadoProductoMaquinaria daoMaquinaria = new DaoProcesosPreparadoProductoMaquinaria(LOGGER);
        subProcesosPreparadoProductoAgregar.setProcesosPreparadoProductoMaquinariaList(daoMaquinaria.listarAgregar());
        return null;
    }
    public String getCargarAgregarProcesosPreparadoProducto()
    {
        procesosPreparadoProductoAgregar=new ProcesosPreparadoProducto();
        procesosPreparadoProductoAgregar.setProcesoSecuencial(true);
        this.cargarActividadesPreparadoSelectList();
        // <editor-fold defaultstate="collapsed" desc="inicializando lista de maquinarias">
        try 
        {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select m.COD_MAQUINA,m.NOMBRE_MAQUINA,m.CODIGO,tem.NOMBRE_TIPO_EQUIPO");
                                    consulta.append(" from MAQUINARIAS m ");
                                    consulta.append(" inner join TIPOS_EQUIPOS_MAQUINARIA tem on tem.COD_TIPO_EQUIPO=m.COD_TIPO_EQUIPO");
                                    consulta.append(" where m.COD_ESTADO_REGISTRO=1");
                                    consulta.append(" order by m.NOMBRE_MAQUINA");
            LOGGER.debug("consulta cargar agregar maquinarias "+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            procesosPreparadoProductoAgregar.setProcesosPreparadoProductoMaquinariaList(new ArrayList<ProcesosPreparadoProductoMaquinaria>());
            while (res.next()) 
            {
                ProcesosPreparadoProductoMaquinaria nuevo=new ProcesosPreparadoProductoMaquinaria();
                nuevo.getMaquinaria().setCodMaquina(res.getString("COD_MAQUINA"));
                nuevo.getMaquinaria().setNombreMaquina(res.getString("NOMBRE_MAQUINA"));
                nuevo.getMaquinaria().setCodigo(res.getString("CODIGO"));
                nuevo.getMaquinaria().getTiposEquiposMaquinaria().setNombreTipoEquipo(res.getString("NOMBRE_TIPO_EQUIPO"));
                procesosPreparadoProductoAgregar.getProcesosPreparadoProductoMaquinariaList().add(nuevo);
                
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
        //</editor-fold>
        return null;
    }
    
    public String guardarEdicionSubProcesosPreparadoProducto_action()throws SQLException
    {
        DaoProcesosPreparadoProducto daoProcesos = new DaoProcesosPreparadoProducto(LOGGER);
        subProcesosPreparadoProductoEditar.setProcesoSecuencial(subProcesosPreparadoProductoEditar.getProcesosPreparadoProductoDestino().getCodProcesoPreparadoProducto() == 0);
        List<ProcesosPreparadoProductoMaquinaria> procesoMaquinariaList = new ArrayList<>();
        for(ProcesosPreparadoProductoMaquinaria bean : subProcesosPreparadoProductoEditar.getProcesosPreparadoProductoMaquinariaList()){
            if(bean.getChecked()){
                procesoMaquinariaList.add(bean);
            }
        }
        subProcesosPreparadoProductoEditar.setProcesosPreparadoProductoMaquinariaList(procesoMaquinariaList);
        if(daoProcesos.editar(subProcesosPreparadoProductoEditar)){
            this.mostrarMensajeTransaccionExitosa("Se registro satisfactoriamente la edicion del paso de preparado");
        }
        else{
            this.mostrarMensajeTransaccionFallida("Ocurrio un error al momento de registrar la edicion del paso de preparado, intente de nuevo");
        }
        return null;
    }
    
    public String guardarEdicionProcesosPreparadoProducto_action()throws SQLException
    {
        mensaje = "";
        DaoProcesosPreparadoProducto daoProcesosPreparado = new DaoProcesosPreparadoProducto(LOGGER);
        List<ProcesosPreparadoProductoMaquinaria> procesoMaquinariaList = new ArrayList<>();
        for(ProcesosPreparadoProductoMaquinaria bean : procesosPreparadoProductoEditar.getProcesosPreparadoProductoMaquinariaList()){
            if(bean.getChecked()){
                procesoMaquinariaList.add(bean);
            }
        }
        procesosPreparadoProductoEditar.setProcesosPreparadoProductoMaquinariaList(procesoMaquinariaList);
        if(daoProcesosPreparado.editar(procesosPreparadoProductoEditar)){
            mensaje = "1";
        }else{
            mensaje = "Ocurrio un error al momento de editar el proceso de preparado, intente de nuevo";
        }
        return null;
    }
    public String getCargarEdicionProcesosPreparadoProducto()
    {
        this.cargarActividadesPreparadoSelectList();
        DaoProcesosPreparadoProductoMaquinaria daoMaquinaria = new DaoProcesosPreparadoProductoMaquinaria(LOGGER);
        procesosPreparadoProductoEditar.setProcesosPreparadoProductoMaquinariaList(daoMaquinaria.listarEditar(procesosPreparadoProductoEditar));
        return null;
    }
    public String getCargarEdicionSubProcesosPreparadoProducto()
    {
        this.cargarProcesosPreparadoDestinoSelectList();
        this.cargarActividadesPreparadoSelectList();
        DaoProcesosPreparadoProductoMaquinaria daoMaquinaria = new DaoProcesosPreparadoProductoMaquinaria(LOGGER);
        subProcesosPreparadoProductoEditar.setProcesosPreparadoProductoMaquinariaList(daoMaquinaria.listarEditar(subProcesosPreparadoProductoEditar));
        if(subProcesosPreparadoProductoEditar.getProcesosPreparadoProductoDestino() == null)
            subProcesosPreparadoProductoEditar.setProcesosPreparadoProductoDestino(new ProcesosPreparadoProducto());
        return null;
    }
    private void cargarActividadesPreparadoSelectList()
    {
        DaoActividadesPreparado daoActividadesPreparado = new DaoActividadesPreparado(LOGGER);
        actividadesPreparadoSelectList = daoActividadesPreparado.listarSelectItem();
    }

    public ManagedProcesosPreparadoProducto() 
    {
        LOGGER=LogManager.getLogger("Versionamiento");
    }
    private void cargarSubProcesosPreparadoProducto()
    {
        DaoProcesosPreparadoProducto daoProcesosPreparadoProducto = new DaoProcesosPreparadoProducto(LOGGER);
        ProcesosPreparadoProducto procesoBean = new ProcesosPreparadoProducto();
        procesoBean.setProcesosPreparadoProductoPadre(procesosPreparadoProductoBean);
        procesoBean.setProcesosOrdenManufactura(procesosOrdenManufacturaBean);
        procesoBean.setComponentesProdVersion(componentesProdVersionBean);
        this.subProcesosPreparadoProductoList = daoProcesosPreparadoProducto.listar(procesoBean);
    }
    public String getCargarSubProcesosPreparadoProducto()
    {
        this.cargarSubProcesosPreparadoProducto();
        return null;
    }
    public String seleccionarProcesoPreparadoBean()
    {
        procesosPreparadoProductoBean=(ProcesosPreparadoProducto)procesosPreparadoDataTable.getRowData();
        return null;
    }
    public String eliminarProcesosPreparadoProducto_action(int codProcesoPreparado)throws SQLException
    {
        transaccionExitosa = false;
        DaoProcesosPreparadoProducto daoProcesosPreparadoProducto = new DaoProcesosPreparadoProducto(LOGGER);
        if(daoProcesosPreparadoProducto.eliminar(codProcesoPreparado)){
            this.mostrarMensajeTransaccionExitosa("El proceso se elimino satisfactoriamente");
        }else{
            this.mostrarMensajeTransaccionFallida("Ocurrio un error al momento de eliminar el proceso");
        }
        if(transaccionExitosa)
        {
            this.cargarProcesosPreparadoProducto();
        }
        return null;
    }
    
    
    public String eliminarSubProcesosPreparadoProducto_action(int codProcesosPreparadoProducto)throws SQLException
    {
        transaccionExitosa=false;
        DaoProcesosPreparadoProducto daoProcesoPreparado = new DaoProcesosPreparadoProducto(LOGGER);
        if(daoProcesoPreparado.eliminar(codProcesosPreparadoProducto)){
            this.mostrarMensajeTransaccionExitosa("Se elimino satisfactoriamente el proceso de preparado");
        }
        else{
            this.mostrarMensajeTransaccionFallida("Ocurrio un error al momento de eliminar el proceso de preparado");
        }
        if(transaccionExitosa)
        {
            this.cargarSubProcesosPreparadoProducto();
        }
        return null;
    }
    
    public String agregarProcesoPreparadoProductoConsumoMaterialSeleccionado(ProcesosPreparadoProductoConsumo bean,boolean materialTransitorio)
    {
        bean.setMaterialTransitorio(materialTransitorio);
        procesosPreparadoProductoConsumoList.remove(bean);
        procesosPreparadoProductoConsumoSeleccionadoList.add(bean);
        return null;
    }
    public String adicionarOrdenConsumoMaterialSeleccionado(int index,int paso)
    {
        ProcesosPreparadoProductoConsumo procesoSeleccionado=procesosPreparadoProductoConsumoSeleccionadoList.get(index);
        ProcesosPreparadoProductoConsumo procesoCambio=procesosPreparadoProductoConsumoSeleccionadoList.get(index+(paso));
        procesosPreparadoProductoConsumoSeleccionadoList.set(index, procesoCambio);
        procesosPreparadoProductoConsumoSeleccionadoList.set(index+(paso), procesoSeleccionado);
        return null;
    }
    public String eliminarProcesoPreparadoProductoConsumoMaterialSeleccionado(ProcesosPreparadoProductoConsumo bean)
    {
        procesosPreparadoProductoConsumoList.add(bean);
        procesosPreparadoProductoConsumoSeleccionadoList.remove(bean);
        return null;
    }
    public String guardarProcesoPreparadoProductoConsumoMaterial_action()throws SQLException
    {
        mensaje = "";
        if(!this.getSustanciaResultanteHabilitada())procesosPreparadoProductoMaterial.setSustanciaResultante("");
        procesosPreparadoProductoMaterial.setProcesosPreparadoProductoConsumoList(procesosPreparadoProductoConsumoSeleccionadoList);
        procesosPreparadoProductoMaterial.setProcesosPreparadoProductoMaquinariaList(null);
        DaoProcesosPreparadoProducto daoProcesosPreparadoProducto = new DaoProcesosPreparadoProducto(LOGGER);
        if(daoProcesosPreparadoProducto.editar(procesosPreparadoProductoMaterial)){
            this.mostrarMensajeTransaccionExitosa("Se registraron satisfactoriamente los materiales");
        }
        else{
            this.mostrarMensajeTransaccionFallida("Ocurrio un error al momento de registrar los materiales");
        }
        return null;
    }
    
    public String mostrarConsumoMaterialProcesoPreparadoProducto_action()
    {
        DaoProcesosPreparadoProductoConsumo daoConsumo = new DaoProcesosPreparadoProductoConsumo(LOGGER);
        procesosPreparadoProductoMaterial.setComponentesProdVersion(componentesProdVersionBean);
        procesosPreparadoProductoConsumoSeleccionadoList = daoConsumo.listar(procesosPreparadoProductoMaterial);
        procesosPreparadoProductoConsumoList = daoConsumo.listarNoUtilizado(procesosPreparadoProductoMaterial);
        return null;
    }
    
    private void cargarTiposDescripcionSelectList()
    {
        DaoTiposDescripcion daoTiposDescripcion = new DaoTiposDescripcion(LOGGER);
        tiposDescripcionSelectList  = daoTiposDescripcion.listarSelectItem();
    }
    public String seleccionarProcesoOrdenManufactura()
    {
        procesosOrdenManufacturaBean=(ProcesosOrdenManufactura)procesosOrdenManufacturaDataTable.getRowData();
        this.cargarProcesosPreparadoProducto();
        return null;
    }
    private void cargarProcesosOrdenManufacturaList()
    {
        DaoProcesosOrdenManufactura daoProcesosOm = new DaoProcesosOrdenManufactura(LOGGER);
        procesosOrdenManufacturaList = daoProcesosOm.listarHabilitadosPreparado(componentesProdVersionBean);
    }
    public String guardarAgregarSubProcesosPreparadoProducto_action()throws SQLException
    {
        if(subProcesosPreparadoProductoAgregar.getProcesosPreparadoProductoDestino().getCodProcesoPreparadoProducto()==0)
            subProcesosPreparadoProductoAgregar.setSustanciaResultante("");
        subProcesosPreparadoProductoAgregar.setProcesoSecuencial(subProcesosPreparadoProductoAgregar.getProcesosPreparadoProductoDestino().getCodProcesoPreparadoProducto() == 0);
        List<ProcesosPreparadoProductoMaquinaria> procesoMaquinariaList = new ArrayList<>();
        for(ProcesosPreparadoProductoMaquinaria bean : subProcesosPreparadoProductoAgregar.getProcesosPreparadoProductoMaquinariaList()){
            if(bean.getChecked()){
                procesoMaquinariaList.add(bean);
            }
        }
        subProcesosPreparadoProductoAgregar.setProcesosPreparadoProductoMaquinariaList(procesoMaquinariaList);
        DaoProcesosPreparadoProducto daoProcesosPreparado = new DaoProcesosPreparadoProducto(LOGGER);
        if(daoProcesosPreparado.guardar(subProcesosPreparadoProductoAgregar)){
            this.mostrarMensajeTransaccionExitosa("Se registro satisfactoriamente el sub proceso");
        }
        else{
            this.mostrarMensajeTransaccionFallida("Ocurrio un error el momento de registrar el sub proceso");
        }
        return null;
    }
    
    public String guardarAgregarProcesoProducto_action()throws SQLException
    {
        mensaje = "";
        DaoProcesosPreparadoProducto daoProceso = new DaoProcesosPreparadoProducto(LOGGER);
        procesosPreparadoProductoAgregar.setComponentesProdVersion(componentesProdVersionBean);
        procesosPreparadoProductoAgregar.setProcesosOrdenManufactura(procesosOrdenManufacturaBean);
        List<ProcesosPreparadoProductoMaquinaria> procesoMaquinariaList = new ArrayList<>();
        for(ProcesosPreparadoProductoMaquinaria bean : procesosPreparadoProductoAgregar.getProcesosPreparadoProductoMaquinariaList()){
            if(bean.getChecked()){
                procesoMaquinariaList.add(bean);
            }
        }
        procesosPreparadoProductoAgregar.setProcesosPreparadoProductoMaquinariaList(procesoMaquinariaList);
        if(daoProceso.guardar(procesosPreparadoProductoAgregar)){
            mensaje = "1";
        }else{
            mensaje = "Ocurrio un error al momento de guardar el proceso, intente de nuevo";
        }
        return null;
    }
    
    public String getCargarProcesosPreparadoProducto()
    {
        ManagedComponentesProdVersion managedProducto=(ManagedComponentesProdVersion)Util.getSessionBean("ManagedComponentesProdVersion");
        componentesProdVersionBean=managedProducto.getComponentesProdVersionBean();
        this.cargarProcesosPreparadoProducto();
        this.cargarUnidadesMedidaGeneralSelectList();
        this.cargarProcesosOrdenManufacturaList();
        this.cargarTiposDescripcionSelectList();
        return null;
    }
    private void cargarProcesosPreparadoProducto()
    {
        procesosPreparadoProductoListado = new ProcesosPreparadoProducto();
        procesosPreparadoProductoListado.setProcesosOrdenManufactura(procesosOrdenManufacturaBean);
        procesosPreparadoProductoListado.setComponentesProdVersion(componentesProdVersionBean);
        DaoProcesosPreparadoProducto daoProceso = new DaoProcesosPreparadoProducto(LOGGER);
        procesosPreparadoProductoList = daoProceso.listar(procesosPreparadoProductoListado);
    }
    private List<ProcesosPreparadoProducto> cargarProcesosPreparadoProducto(int codProcesoPreparadoProducto)
    {
        List<ProcesosPreparadoProducto> procesosList=new ArrayList<ProcesosPreparadoProducto>();
        try 
        {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select ppp.COD_PROCESO_PREPARADO_PRODUCTO,ppp.NRO_PASO,ppp.COD_ACTIVIDAD_PREPARADO,ap.NOMBRE_ACTIVIDAD_PREPARADO,");
                                            consulta.append(" ppp.DESCRIPCION,ppp.OPERARIO_TIEMPO_COMPLETO,ppp.TIEMPO_PROCESO,ppp.TOLERANCIA_TIEMPO");
                                            consulta.append(" ,pppm.COD_MAQUINA,m.NOMBRE_MAQUINA,m.CODIGO,pppm.COD_PROCESO_PREPARADO_PRODUCTO_MAQUINARIA,ppp.COD_PROCESO_PREPARADO_PRODUCTO_DESTINO")
                                                    .append(" ,ppp.SUSTANCIA_RESULTANTE");
                                            
                                        consulta.append(" from PROCESOS_PREPARADO_PRODUCTO ppp");
                                            consulta.append(" inner join ACTIVIDADES_PREPARADO ap on ap.COD_ACTIVIDAD_PREPARADO=ppp.COD_ACTIVIDAD_PREPARADO");
                                            consulta.append(" left outer join PROCESOS_PREPARADO_PRODUCTO_MAQUINARIA pppm on pppm.COD_PROCESO_PREPARADO_PRODUCTO=ppp.COD_PROCESO_PREPARADO_PRODUCTO");
                                            consulta.append(" left outer join MAQUINARIAS m on m.COD_MAQUINA=pppm.COD_MAQUINA");
                                        consulta.append(" where ppp.COD_VERSION= ").append(componentesProdVersionBean.getCodVersion());
                                            consulta.append(" and ppp.COD_PROCESO_ORDEN_MANUFACTURA=").append(procesosOrdenManufacturaBean.getCodProcesoOrdenManufactura());
                                            consulta.append(" and ppp.COD_PROCESO_PREPARADO_PRODUCTO_PADRE=").append(codProcesoPreparadoProducto);
                                        consulta.append(" order by ppp.NRO_PASO,ppp.COD_PROCESO_PREPARADO_PRODUCTO");
            LOGGER.debug("consulta cargar pasos"+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            ProcesosPreparadoProducto nuevo=new ProcesosPreparadoProducto();
            while (res.next())
            {
                if(nuevo.getCodProcesoPreparadoProducto()!=res.getInt("COD_PROCESO_PREPARADO_PRODUCTO"))
                {
                    if(nuevo.getCodProcesoPreparadoProducto()>0)
                    {
                        procesosList.add(nuevo);
                    }
                    nuevo=new ProcesosPreparadoProducto();
                    nuevo.setCodProcesoPreparadoProducto(res.getInt("COD_PROCESO_PREPARADO_PRODUCTO"));
                    nuevo.setNroPaso(res.getInt("NRO_PASO"));
                    nuevo.getActividadesPreparado().setCodActividadPreparado(res.getInt("COD_ACTIVIDAD_PREPARADO"));
                    nuevo.getActividadesPreparado().setNombreActividadPreparado(res.getString("NOMBRE_ACTIVIDAD_PREPARADO"));
                    nuevo.setDescripcion(res.getString("DESCRIPCION"));
                    nuevo.setOperarioTiempoCompleto(res.getInt("OPERARIO_TIEMPO_COMPLETO")>0);
                    nuevo.setTiempoProceso(res.getDouble("TIEMPO_PROCESO"));
                    nuevo.setToleranciaTiempo(res.getDouble("TOLERANCIA_TIEMPO"));
                    nuevo.setSustanciaResultante(res.getString("SUSTANCIA_RESULTANTE"));
                    if(codProcesoPreparadoProducto>0)
                    {
                        nuevo.setProcesosPreparadoProductoDestino(new ProcesosPreparadoProducto());
                        nuevo.getProcesosPreparadoProductoDestino().setCodProcesoPreparadoProducto(res.getInt("COD_PROCESO_PREPARADO_PRODUCTO_DESTINO"));
                    }
                    nuevo.setProcesosPreparadoProductoMaquinariaList(new ArrayList<ProcesosPreparadoProductoMaquinaria>());
                }
                ProcesosPreparadoProductoMaquinaria bean=new ProcesosPreparadoProductoMaquinaria();
                bean.setCodProcesoPreparadProductoMaquinaria(res.getInt("COD_PROCESO_PREPARADO_PRODUCTO_MAQUINARIA"));
                bean.getMaquinaria().setCodMaquina(res.getString("COD_MAQUINA"));
                bean.getMaquinaria().setCodigo(res.getString("NOMBRE_MAQUINA"));
                bean.getMaquinaria().setNombreMaquina(res.getString("CODIGO"));
                nuevo.getProcesosPreparadoProductoMaquinariaList().add(bean);
            }
            if(nuevo.getCodProcesoPreparadoProducto()>0)
            {
                procesosList.add(nuevo);
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
        return procesosList;
    }
    private void cargarUnidadesMedidaGeneralSelectList()
    {
        DaoUnidadesMedida daoUnidadMedida = new DaoUnidadesMedida(LOGGER);
        unidadesMedidaSelectList = daoUnidadMedida.listarSelectItem();
    }
    public String guardarProcesosPreparadoProductoEspecificacionesMaquinaria_action()throws SQLException
    {
        DaoProcesosPreparadoProductoEspecificacionesMaquinaria daoEspMaquinaria = new DaoProcesosPreparadoProductoEspecificacionesMaquinaria(LOGGER);
        List<ProcesosPreparadoProductoEspecificacionesMaquinaria> espMaquinariaList = new ArrayList<>();
        for(ProcesosPreparadoProductoEspecificacionesMaquinaria bean : procesosPreparadoProductoMaquinariaBean.getProcesosPreparadoProductoEspecificacionesMaquinariaList()){
            if(bean.getChecked()){
                espMaquinariaList.add(bean);
            }
        }
        procesosPreparadoProductoMaquinariaBean.setProcesosPreparadoProductoEspecificacionesMaquinariaList(espMaquinariaList);
        if(daoEspMaquinaria.guardarDetalle(procesosPreparadoProductoMaquinariaBean)){
            this.mostrarMensajeTransaccionExitosa("Se registraron satisfactoriamente las especificaciones de maquinaria");
        }
        else{
            this.mostrarMensajeTransaccionFallida("Ocurrio un error al momento de registrar las especficaciones de maquinaria");
        }
        return null;
    }
    // <editor-fold defaultstate="collapsed" desc="especificaciones de maquinaria para el paso">
    public String  mostrarProcesosPreparadoProductoEspecificacionesMaquinaria_action()
    {
        procesosPreparadoProductoMaquinariaBean.setProcesosPreparadoProducto(procesosPreparadoProductoBean);
        DaoProcesosPreparadoProductoEspecificacionesMaquinaria daoEspMaquinaria = new DaoProcesosPreparadoProductoEspecificacionesMaquinaria(LOGGER);
        procesosPreparadoProductoMaquinariaBean.setProcesosPreparadoProductoEspecificacionesMaquinariaList(daoEspMaquinaria.listarEditar(procesosPreparadoProductoMaquinariaBean));
        return null;
        
    }
    //</editor-fold>

    public String getMensaje() {
        return mensaje;
    }

    public void setMensaje(String mensaje) {
        this.mensaje = mensaje;
    }

    public List<ProcesosPreparadoProducto> getProcesosPreparadoProductoList() {
        return procesosPreparadoProductoList;
    }

    public void setProcesosPreparadoProductoList(List<ProcesosPreparadoProducto> procesosPreparadoProductoList) {
        this.procesosPreparadoProductoList = procesosPreparadoProductoList;
    }

    public ProcesosPreparadoProducto getProcesosPreparadoProductoBean() {
        return procesosPreparadoProductoBean;
    }

    public void setProcesosPreparadoProductoBean(ProcesosPreparadoProducto procesosPreparadoProductoBean) {
        this.procesosPreparadoProductoBean = procesosPreparadoProductoBean;
    }

    public ComponentesProdVersion getComponentesProdVersionBean() {
        return componentesProdVersionBean;
    }

    public void setComponentesProdVersionBean(ComponentesProdVersion componentesProdVersionBean) {
        this.componentesProdVersionBean = componentesProdVersionBean;
    }
    public HtmlDataTable getProcesosPreparadoDataTable() {
        return procesosPreparadoDataTable;
    }

    public void setProcesosPreparadoDataTable(HtmlDataTable procesosPreparadoDataTable) {
        this.procesosPreparadoDataTable = procesosPreparadoDataTable;
    }

    public ProcesosOrdenManufactura getProcesosOrdenManufacturaBean() {
        return procesosOrdenManufacturaBean;
    }

    public void setProcesosOrdenManufacturaBean(ProcesosOrdenManufactura procesosOrdenManufacturaBean) {
        this.procesosOrdenManufacturaBean = procesosOrdenManufacturaBean;
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

    public void setProcesosPreparadoProductoMaquinariaBean(ProcesosPreparadoProductoMaquinaria procesosPreparadoProductoMaquinariaBean) {
        this.procesosPreparadoProductoMaquinariaBean = procesosPreparadoProductoMaquinariaBean;
    }

    public void setTiposDescripcionSelectList(List<SelectItem> tiposDescripcionSelectList) {
        this.tiposDescripcionSelectList = tiposDescripcionSelectList;
    }

    public ProcesosPreparadoProductoMaquinaria getProcesosPreparadoProductoMaquinariaBean() {
        return procesosPreparadoProductoMaquinariaBean;
    }

    public List<SelectItem> getTiposDescripcionSelectList() {
        return tiposDescripcionSelectList;
    }

    public ProcesosPreparadoProducto getProcesosPreparadoProductoMaterial() {
        return procesosPreparadoProductoMaterial;
    }

    public void setProcesosPreparadoProductoMaterial(ProcesosPreparadoProducto procesosPreparadoProductoMaterial) {
        this.procesosPreparadoProductoMaterial = procesosPreparadoProductoMaterial;
    }

    

    public List<ProcesosPreparadoProducto> getSubProcesosPreparadoProductoList() {
        return subProcesosPreparadoProductoList;
    }

    public void setSubProcesosPreparadoProductoList(List<ProcesosPreparadoProducto> subProcesosPreparadoProductoList) {
        this.subProcesosPreparadoProductoList = subProcesosPreparadoProductoList;
    }

    public HtmlDataTable getSubProcesosPreparadoProductoDataTable() {
        return subProcesosPreparadoProductoDataTable;
    }

    public void setSubProcesosPreparadoProductoDataTable(HtmlDataTable subProcesosPreparadoProductoDataTable) {
        this.subProcesosPreparadoProductoDataTable = subProcesosPreparadoProductoDataTable;
    }

    
    public List<SelectItem> getUnidadesMedidaSelectList() {
        return unidadesMedidaSelectList;
    }

    public void setUnidadesMedidaSelectList(List<SelectItem> unidadesMedidaSelectList) {
        this.unidadesMedidaSelectList = unidadesMedidaSelectList;
    }

    public ProcesosPreparadoProducto getProcesosPreparadoProductoAgregar() {
        return procesosPreparadoProductoAgregar;
    }

    public void setProcesosPreparadoProductoAgregar(ProcesosPreparadoProducto procesosPreparadoProductoAgregar) {
        this.procesosPreparadoProductoAgregar = procesosPreparadoProductoAgregar;
    }

    public List<SelectItem> getActividadesPreparadoSelectList() {
        return actividadesPreparadoSelectList;
    }

    public void setActividadesPreparadoSelectList(List<SelectItem> actividadesPreparadoSelectList) {
        this.actividadesPreparadoSelectList = actividadesPreparadoSelectList;
    }

    public ProcesosPreparadoProducto getSubProcesosPreparadoProductoAgregar() {
        return subProcesosPreparadoProductoAgregar;
    }

    public void setSubProcesosPreparadoProductoAgregar(ProcesosPreparadoProducto subProcesosPreparadoProductoAgregar) {
        this.subProcesosPreparadoProductoAgregar = subProcesosPreparadoProductoAgregar;
    }

    public ProcesosPreparadoProducto getProcesosPreparadoProductoEditar() {
        return procesosPreparadoProductoEditar;
    }

    public void setProcesosPreparadoProductoEditar(ProcesosPreparadoProducto procesosPreparadoProductoEditar) {
        this.procesosPreparadoProductoEditar = procesosPreparadoProductoEditar;
    }

    public ProcesosPreparadoProducto getSubProcesosPreparadoProductoEditar() {
        return subProcesosPreparadoProductoEditar;
    }

    public void setSubProcesosPreparadoProductoEditar(ProcesosPreparadoProducto subProcesosPreparadoProductoEditar) {
        this.subProcesosPreparadoProductoEditar = subProcesosPreparadoProductoEditar;
    }

    public List<SelectItem> getProcesosPreparadoDestinoSelectList() {
        return procesosPreparadoDestinoSelectList;
    }

    public void setProcesosPreparadoDestinoSelectList(List<SelectItem> procesosPreparadoDestinoSelectList) {
        this.procesosPreparadoDestinoSelectList = procesosPreparadoDestinoSelectList;
    }

    
    
    public Boolean getSustanciaResultanteHabilitada()
    {
        boolean sustanciaResultanteHabilitada=true;
        if(this.procesosPreparadoProductoConsumoSeleccionadoList!=null && this.procesosPreparadoProductoConsumoSeleccionadoList.size()>0)
        {
            for(ProcesosPreparadoProductoConsumo bean: procesosPreparadoProductoConsumoSeleccionadoList)
            {
                sustanciaResultanteHabilitada=(sustanciaResultanteHabilitada && (!bean.getMaterialTransitorio()));
            }
        }
        else
        {
            sustanciaResultanteHabilitada=false;
        }
        return sustanciaResultanteHabilitada;
    }

    public List<ProcesosPreparadoProductoConsumo> getProcesosPreparadoProductoConsumoList() {
        return procesosPreparadoProductoConsumoList;
    }

    public void setProcesosPreparadoProductoConsumoList(List<ProcesosPreparadoProductoConsumo> procesosPreparadoProductoConsumoList) {
        this.procesosPreparadoProductoConsumoList = procesosPreparadoProductoConsumoList;
    }

    public List<ProcesosPreparadoProductoConsumo> getProcesosPreparadoProductoConsumoSeleccionadoList() {
        return procesosPreparadoProductoConsumoSeleccionadoList;
    }

    public void setProcesosPreparadoProductoConsumoSeleccionadoList(List<ProcesosPreparadoProductoConsumo> procesosPreparadoProductoConsumoSeleccionadoList) {
        this.procesosPreparadoProductoConsumoSeleccionadoList = procesosPreparadoProductoConsumoSeleccionadoList;
    }
    
    
}
