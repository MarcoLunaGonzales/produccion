/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.web.desarrollo;

import com.cofar.bean.ComponentesPresProdVersion;
import com.cofar.bean.ComponentesProd;
import com.cofar.bean.ComponentesProdConcentracion;
import com.cofar.bean.ComponentesProdProcesoOrdenManufactura;
import com.cofar.bean.ComponentesProdVersion;
import com.cofar.bean.ComponentesProdVersionEspecificacionProceso;
import com.cofar.bean.ComponentesProdVersionLimpiezaMaquinaria;
import com.cofar.bean.ComponentesProdVersionLimpiezaSeccion;
import com.cofar.bean.ComponentesProdVersionMaquinariaProceso;
import com.cofar.bean.ComponentesProdVersionModificacion;
import com.cofar.bean.EspecificacionesFisicasProducto;
import com.cofar.bean.EspecificacionesMicrobiologiaProducto;
import com.cofar.bean.EspecificacionesProcesosProductoMaquinaria;
import com.cofar.bean.EspecificacionesQuimicasCc;
import com.cofar.bean.EspecificacionesQuimicasProducto;
import com.cofar.bean.FormulaMaestraDetalleEP;
import com.cofar.bean.FormulaMaestraDetalleES;
import com.cofar.bean.FormulaMaestraDetalleMP;
import com.cofar.bean.FormulaMaestraDetalleMPfracciones;
import com.cofar.bean.FormulaMaestraDetalleMr;
import com.cofar.bean.FormulaMaestraEsVersion;
import com.cofar.bean.FormulaMaestraVersion;
import com.cofar.bean.IndicacionProceso;
import com.cofar.bean.Materiales;
import com.cofar.bean.PresentacionesPrimarias;
import com.cofar.bean.ProcesosOrdenManufactura;
import com.cofar.bean.ProcesosPreparadoProducto;
import com.cofar.bean.ProcesosPreparadoProductoConsumo;
import com.cofar.bean.ProcesosPreparadoProductoEspecificacionesMaquinaria;
import com.cofar.bean.ProcesosPreparadoProductoMaquinaria;
import com.cofar.bean.Producto;
import com.cofar.bean.ProgramaProduccion;
import com.cofar.bean.TiposMaterialProduccion;
import com.cofar.bean.util.CreacionGraficosOrdenManufactura;
import com.cofar.dao.DaoActividadesPreparado;
import com.cofar.dao.DaoAreasEmpresa;
import com.cofar.dao.DaoColoresPresPrimaria;
import com.cofar.dao.DaoTamanioCapsulaProduccion;
import com.cofar.dao.DaoComponentesPresProdVersion;
import com.cofar.dao.DaoComponentesProd;
import com.cofar.dao.DaoComponentesProdConcentracion;
import com.cofar.dao.DaoComponentesProdProcesoOrdenManufactura;
import com.cofar.dao.DaoComponentesProdVersion;
import com.cofar.dao.DaoComponentesProdVersionEspecificacionProceso;
import com.cofar.dao.DaoComponentesProdVersionLimpiezaMaquinaria;
import com.cofar.dao.DaoComponentesProdVersionLimpiezaSeccion;
import com.cofar.dao.DaoComponentesProdVersionMaquinariaProceso;
import com.cofar.dao.DaoCondicionesVentaProducto;
import com.cofar.dao.DaoEnvasesPrimarios;
import com.cofar.dao.DaoEspecificacionesFisicasProducto;
import com.cofar.dao.DaoEspecificacionesMicrobiologiaProducto;
import com.cofar.dao.DaoEspecificacionesProcesosProductoMaquinaria;
import com.cofar.dao.DaoEspecificacionesQuimicasProducto;
import com.cofar.dao.DaoFormulaMaestraDetalleEpVersion;
import com.cofar.dao.DaoFormulaMaestraDetalleEsVersion;
import com.cofar.dao.DaoFormulaMaestraDetalleMpFraccionesVersion;
import com.cofar.dao.DaoFormulaMaestraDetalleMpVersion;
import com.cofar.dao.DaoFormulaMaestraDetalleMrVersion;
import com.cofar.dao.DaoIndicacionProceso;
import com.cofar.dao.DaoMateriales;
import com.cofar.dao.DaoPresentacionesPrimariasVersion;
import com.cofar.dao.DaoPresentacionesProducto;
import com.cofar.dao.DaoProcesosOrdenManufactura;
import com.cofar.dao.DaoProcesosPreparadoProducto;
import com.cofar.dao.DaoProcesosPreparadoProductoConsumo;
import com.cofar.dao.DaoProcesosPreparadoProductoEspecificacionesMaquinaria;
import com.cofar.dao.DaoProcesosPreparadoProductoMaquinaria;
import com.cofar.dao.DaoProductos;
import com.cofar.dao.DaoSeccionesOrdenManufactura;
import com.cofar.dao.DaoTiposDescripcion;
import com.cofar.dao.DaoTiposEspecificacionesFisicas;
import com.cofar.dao.DaoTiposIndicacionProceso;
import com.cofar.dao.DaoTiposMaterialProduccion;
import com.cofar.dao.DaoTiposMaterialReactivo;
import com.cofar.dao.DaoTiposProgramaProduccion;
import com.cofar.dao.DaoTiposReferenciaCC;
import com.cofar.dao.DaoUnidadesMedida;
import com.cofar.dao.DaoViasAdministracionProducto;
import com.cofar.util.Util;
import com.cofar.web.ManagedAccesoSistema;
import com.cofar.web.ManagedBean;
import java.sql.CallableStatement;
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
public class ManagedProductosDesarrolloVersion extends ManagedBean 
{
    private static final int COD_TIPO_PRODUCCION_ESTANDARIZACION_DESARROLLO = 3;
    private static final int COD_TIPO_PRODUCCION_ESTANDARIZACION_VALIDACIONES = 4;
    private static final int COD_ESTADO_VERSION_APROBADA = 2;
    private boolean permisoRegistrarInformacionRegenciaFarmaceutica = false;
    private boolean permisoGestionEstandarizacionValidaciones = false;
    private boolean permisoGestionEstandarizacionDesarrollo = false;
    private boolean permisoVisualizacionProductoEstandarizacion = false;
    private boolean permisoInactivarProductoEstandarizacion = false;
    private boolean defineLoteEs = false;
    private String mensaje="";
    private Connection con=null;
    private List<ComponentesProd> componentesProdList;
    private int nuevoTamanioLote = 0;
    //<editor-fold desc="formula maestra" defaultstate="collapsed">
        private FormulaMaestraVersion formulaMaestraVersionSeleccionado;
        private List<TiposMaterialProduccion> formulaMaestraDetalleMPList=null;
        private List<TiposMaterialProduccion> tiposMaterialProduccionList;
        private TiposMaterialProduccion tiposMaterialProduccionSeleccionado ;
        private List<FormulaMaestraDetalleMP> formulaMaestraDetalleMPAgregarList;
        private List<FormulaMaestraDetalleMP> formulaMaestraDetalleMPEditarList;
        private FormulaMaestraDetalleMP formulaMaestraDetalleMPBean;
    //</editor-fold>
    //<editor-fold desc="formula maestra detalle Ep" defaultstate="collapsed">
        private List<PresentacionesPrimarias> formulaMaestraEPList;
        private PresentacionesPrimarias presentacionesPrimarias;
        private List<SelectItem> envasesPrimariosSelectList;
    //</editor-fold>
    //<editor-fold desc="formula maestra detalle Es" defaultstate="collapsed">
        private FormulaMaestraEsVersion formulaMaestraEsVersionSeleccionado;
        private List<ComponentesPresProdVersion> componentesPresProdList;
        private ComponentesPresProdVersion componentesPresProdVersion;
        private List<SelectItem> presentacionesSelectList;
        
    //</editor-fold>
    //<editor-fold defaultstate="collapsed" desc="formula maestra detalle mr">
        private List<FormulaMaestraDetalleMr> formulaMaestraDetalleMRList;
        private List<FormulaMaestraDetalleMr> formulaMaestraDetalleMRAgregarList;
        private List<FormulaMaestraDetalleMr> formulaMaestraDetalleMREditarList;
        private int codTipoMaterialReactivo = 0;
    //</editor-fold>
    //<editor-fold defaultstate="collapsed" desc="especificaciones de control de calidad">
        private ComponentesProdVersion componentesProdVersionSeleccionado;
        private List<SelectItem> tiposEspecificacionesFisicasSelect;
        private List<SelectItem> tiposReferenciaCcSelect;
        private List<EspecificacionesFisicasProducto> especificacionesFisicasProductoList;
        private List<EspecificacionesMicrobiologiaProducto> especificacionesMicrobiologiaProductoList;
        private List<EspecificacionesQuimicasCc> especificacionesQuimicasProductoList=null;
    //</editor-fold>
    //<editor-fold defaultstate="collapsed" desc="concentracion">
        private Materiales materialesBuscar = new Materiales();
        private List<Materiales> materialesList;
        private Materiales materiales;
    //</editor-fold>
    //<editor-fold defaultstate="collapsed" desc="gestion de productos">
        private Producto producto = new Producto();
    //</editor-fold>
    //<editor-fold defaultstate="collapsed" desc="procesos de preparado">
        private ProcesosPreparadoProducto procesosPreparadoProductoBean = new ProcesosPreparadoProducto();
        private ProcesosPreparadoProducto procesosPreparadoProductoBeanSubProceso = new ProcesosPreparadoProducto();
        private ProcesosPreparadoProducto procesosPreparadoProducto = new ProcesosPreparadoProducto();
        private List<ProcesosPreparadoProducto> procesosPreparadoProductoList;
        private List<ProcesosPreparadoProducto> subProcesosPreparadoProductoList;
        private List<ProcesosPreparadoProductoConsumo> procesosPreparadoProductoConsumoDisponibleList = new ArrayList<>();
        private List<ProcesosOrdenManufactura> procesosOrdenManufacturaList;
        private List<SelectItem> actividadesPreparadoSelectList;
        private List<SelectItem> tiposDescripcionSelectList;
        private List<SelectItem>  procesosPreparadoDestinoSelectList;
        private ProcesosPreparadoProductoMaquinaria procesosPreparadoProductoMaquinaria = new ProcesosPreparadoProductoMaquinaria();
    //</editor-fold>
    //<editor-fold defaultstate="collapsed" desc="procesos orden manufactura">
        private List<ComponentesProdProcesoOrdenManufactura> componentesProdProcesoOrdenManufacturaList;
        private List<ComponentesProdProcesoOrdenManufactura> componentesProdProcesoOrdenManufacturaDisponibleList;
    //</editor-fold>  
    //<editor-fold defaultstate="collapsed" desc="especificaciones maquinaria">
        private ComponentesProdVersionMaquinariaProceso componentesProdVersionMaquinariaProcesoBean = new ComponentesProdVersionMaquinariaProceso();
        private ComponentesProdVersionMaquinariaProceso componentesProdVersionMaquinariaProceso;
        private List<ComponentesProdVersionMaquinariaProceso> componentesProdVersionMaquinariaProcesoList;
        private List<SelectItem> maquinariasSelectList;
        private List<SelectItem> tiposEspecificacionesProcesoProductoMaquinariaSelectList;
    //</editor-fold>
    //<editor-fold defaultstate="collapsed" desc="especificaciones proceso">
        private List<ProcesosOrdenManufactura> componentesProdVersionEspecificacionProcesoList;
        private ComponentesProdVersionEspecificacionProceso componentesProdVersionEspecificacionProceso = new ComponentesProdVersionEspecificacionProceso();
        private ComponentesProdVersionEspecificacionProceso componentesProdVersionEspecificacionProcesoBean;
        private List<SelectItem> procesosOrdenManufacturaSelectList;
    //</editor-fold>
    //<editor-fold defaultstate="collapsed" desc="indicaciones proceso">
        private IndicacionProceso indicacionProceso;
        private IndicacionProceso indicacionProcesoBean = new IndicacionProceso();
        private List<IndicacionProceso> indicacionProcesoList;
        private List<SelectItem> tiposIndicacionProcesoSelectList;
    //</editor-fold>
        
    //<editor-fold defaultstate="collapsed" desc="limpieza">
        private List<ComponentesProdVersionLimpiezaSeccion> componentesProdVersionLimpiezaSeccionList;
        private List<ComponentesProdVersionLimpiezaSeccion> componentesProdVersionLimpiezaSeccionAgregarList;
    //</editor-fold>
    //<editor-fold defaultstate="collapsed" desc="limpieza maquinaria">
        private List<ComponentesProdVersionLimpiezaMaquinaria> componentesProdVersionLimpiezaMaquinariaList;
        private List<ComponentesProdVersionLimpiezaMaquinaria> limpiezaMaquinariaAgregarList;
    //</editor-fold>
    //<editor-fold defaultstate="collapsed" desc="limpieza utensilio pesaje">
        private List<ComponentesProdVersionLimpiezaMaquinaria> componentesProdVersionLimpiezaUtensilioPesajeList;
        private List<ComponentesProdVersionLimpiezaMaquinaria> limpiezaUtensilioPesajeAgregarList;
    //</editor-fold>
    //<editor-fold defaultstate="collapsed" desc="limpieza secciones/areas pesaje">
        private List<SelectItem> seccionesOrdenManufacturaSelectList;
        private ComponentesProdVersionLimpiezaSeccion componentesProdVersionLimpiezaPesaje;
    //</editor-fold> 
    private List<SelectItem> tiposProduccionSelectList;
    private List<SelectItem> tiposMaterialReactivoSelectList;
    
    private List<ComponentesProdVersion> componentesProdDesarrolloList;
    private List<ComponentesProdVersion> componentesProdDesarrolloEnsayoList;
    private ComponentesProd componentesProdBuscar=new ComponentesProd();
    private ComponentesProd componentesProdSeleccionado;
    private ComponentesProdVersion componentesProdVersion;
    private ComponentesProdConcentracion componentesProdConcentracionBean;
    private List<SelectItem> productosSelectList;
    private List<SelectItem> formasFarmaceuticasSelectList;
    private List<SelectItem> areasFabricacionProductoSelectList;
    private List<SelectItem> saboresProductosSelectList;
    private List<SelectItem> viasAdministracionSelectList;
    private List<SelectItem> tiposProgramaProduccionSelectList;
    private List<SelectItem> condicionesVentaProductoSelectList;
    private List<SelectItem> unidadesMedidaSelectList;
    private List<SelectItem> coloresPresPrimSelectList;
    private List<SelectItem> tamaniosCapsulasSelectList;
    
    private ComponentesProdVersion componentesProdDesarrollloBean;
    private ComponentesProdVersion componentesProdVersionBean;
    private ComponentesProdVersion componentesProdVersionNuevoEnsayo;
    
    
    
    
    /**
     * Creates a new instance of ManagedProductosDesarrollo
     */
    private void cargarPermisosEspecialesPersonal(){
        ManagedAccesoSistema managed = (ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select cpea.COD_TIPO_PERMISO_ESPECIAL_ATLAS")
                                                .append(" from CONFIGURACION_PERMISOS_ESPECIALES_ATLAS cpea ")
                                                .append(" where cpea.COD_TIPO_PERMISO_ESPECIAL_ATLAS in (24,25,26,27,32)")
                                                        .append(" and cpea.COD_PERSONAL =").append(managed.getUsuarioModuloBean().getCodUsuarioGlobal());
            LOGGER.debug("consulta cargar permisos especiales : "+consulta.toString());
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta.toString());
            permisoGestionEstandarizacionDesarrollo = false;
            permisoGestionEstandarizacionValidaciones = false;
            permisoRegistrarInformacionRegenciaFarmaceutica = false;
            permisoVisualizacionProductoEstandarizacion = false;
            permisoInactivarProductoEstandarizacion = false;
            while(res.next())
            {
                switch(res.getInt("COD_TIPO_PERMISO_ESPECIAL_ATLAS")){
                    case 24:{
                        permisoGestionEstandarizacionValidaciones = true;
                        break;
                    }
                    case 25:{
                        permisoGestionEstandarizacionDesarrollo = true;
                        break;
                    }
                    case 26:{
                        permisoRegistrarInformacionRegenciaFarmaceutica = true;
                        break;
                    }
                    case 27:{
                        permisoVisualizacionProductoEstandarizacion = true;
                        break;
                    }
                    case 32:{
                        permisoInactivarProductoEstandarizacion = true;
                        break;
                    }
                }
            }
        } catch (SQLException ex) {
            LOGGER.warn(ex.getMessage());
        } catch (NumberFormatException ex) {
            LOGGER.warn(ex.getMessage());
        } finally {
            this.cerrarConexion(con);
        }
    }
    
    //<editor-fold defaultstate="collapsed" desc="limpieza de ambientes">
        public String getCargarAgregarLimpiezaSeccion()
        {
            DaoComponentesProdVersionLimpiezaSeccion daoLimpieza = new DaoComponentesProdVersionLimpiezaSeccion(LOGGER);
            componentesProdVersionLimpiezaSeccionAgregarList = daoLimpieza.listarAgregar(componentesProdVersionSeleccionado);
            return null;
        }
        public String guardarLimpiezaSeccionAction()throws SQLException
        {
            List<ComponentesProdVersionLimpiezaSeccion> listaGuardar = new ArrayList<>();
            for(ComponentesProdVersionLimpiezaSeccion bean : componentesProdVersionLimpiezaSeccionAgregarList){
                if(bean.getChecked()){
                    listaGuardar.add(bean) ;
                }
            }
            DaoComponentesProdVersionLimpiezaSeccion daoLimpieza = new DaoComponentesProdVersionLimpiezaSeccion(LOGGER);
            if(daoLimpieza.guardarLista(listaGuardar, componentesProdVersionSeleccionado)){
                this.mostrarMensajeTransaccionExitosa("Se registraron satisfactoriamente las secciones");
            }
            else{
                this.mostrarMensajeTransaccionFallida("Ocurrio un error al momento de registrar las secciones, intente de nuevo");
            }
            return null;
        }
        public String eliminarLimpiezaSeccionPesajeAction(int codComponentesProdVersionLimpiezaSeccion) throws SQLException {
            transaccionExitosa = false;
            DaoComponentesProdVersionLimpiezaSeccion daoLimpieza = new DaoComponentesProdVersionLimpiezaSeccion(LOGGER);
            if(daoLimpieza.eliminar(codComponentesProdVersionLimpiezaSeccion)){
                this.mostrarMensajeTransaccionExitosa("Se elimino la seccion configurada de manera satisfactoria");
            }
            else{
                this.mostrarMensajeTransaccionFallida("Ocurrio un error al momento de eliminar la seccion configurada");
            }
            if(transaccionExitosa)
            {
                this.cargarComponentesProdVersionLimpiezaSeccionPesajeList();
            }
            return null;
        }
        public String eliminarLimpiezaSeccionAction(int codComponentesProdVersionLimpiezaSeccion) throws SQLException {
            transaccionExitosa = false;
            DaoComponentesProdVersionLimpiezaSeccion daoLimpieza = new DaoComponentesProdVersionLimpiezaSeccion(LOGGER);
            if(daoLimpieza.eliminar(codComponentesProdVersionLimpiezaSeccion)){
                this.mostrarMensajeTransaccionExitosa("Se elimino la seccion configurada de manera satisfactoria");
            }
            else{
                this.mostrarMensajeTransaccionFallida("Ocurrio un error al momento de eliminar la seccion configurada");
            }
            if(transaccionExitosa)
            {
                this.cargarComponentesProdVersionLimpiezaSecciones();
            }
            return null;
        }
        public String getCargarLimpiezaSecciones(){
            this.cargarComponentesProdVersionLimpiezaSecciones();
            return null;
        }
        private void cargarComponentesProdVersionLimpiezaSecciones()
        {
            ComponentesProdVersionLimpiezaSeccion bean = new ComponentesProdVersionLimpiezaSeccion();
            bean.setComponentesProdVersion(componentesProdVersionSeleccionado);
            bean.getAreasEmpresa().setCodAreaEmpresa("96");
            DaoComponentesProdVersionLimpiezaSeccion daoLimpieza = new DaoComponentesProdVersionLimpiezaSeccion(LOGGER);
            componentesProdVersionLimpiezaSeccionList = daoLimpieza.listar(bean);
        }
    //</editor-fold>
    //<editor-fold defaultstate="collapsed" desc="limpieza maquinaria">
        public String guardarLimpiezaMaquinariaAction()throws SQLException
        {
            DaoComponentesProdVersionLimpiezaMaquinaria daoLimpieza = new DaoComponentesProdVersionLimpiezaMaquinaria(LOGGER);
            List<ComponentesProdVersionLimpiezaMaquinaria> guardarList = new ArrayList<>();
            for(ComponentesProdVersionLimpiezaMaquinaria bean : limpiezaMaquinariaAgregarList){
                if(bean.getChecked())
                {
                    guardarList.add(bean);
                }
            }
            if(daoLimpieza.guardarLista(guardarList, componentesProdVersionSeleccionado,96)){
                this.mostrarMensajeTransaccionExitosa("Se registro la configuracion de limpieza de maquinarias");
            }
            else{
                this.mostrarMensajeTransaccionFallida("Ocurrio un error al momento de registrar la configuración de limpieza de maquinaria");
            }
            return null;
        }
        public String getCargarAgregarLimpiezaMaquinaria()
        {
            DaoComponentesProdVersionLimpiezaMaquinaria daoLimpieza = new DaoComponentesProdVersionLimpiezaMaquinaria(LOGGER);
            limpiezaMaquinariaAgregarList = daoLimpieza.listarAgregar(componentesProdVersionSeleccionado);
            return null;
        }
        public String getCargarLimpiezaMaquinaria()
        {
            this.cargarComponentesProdVersionLimpiezaMaquinaria();
            return null;
        }
        private void cargarComponentesProdVersionLimpiezaMaquinaria()
        {
            ComponentesProdVersionLimpiezaMaquinaria bean = new ComponentesProdVersionLimpiezaMaquinaria();
            bean.setComponentesProdVersion(componentesProdVersionSeleccionado);
            bean.getAreasEmpresa().setCodAreaEmpresa("96");
            DaoComponentesProdVersionLimpiezaMaquinaria daoLimpieza = new DaoComponentesProdVersionLimpiezaMaquinaria(LOGGER);
            componentesProdVersionLimpiezaMaquinariaList = daoLimpieza.listar(bean);
        }
        public String eliminarLimpiezaMaquinariaAction(int codComponentesProdVersionLimpiezaMaquinaria)throws SQLException
        {
            transaccionExitosa= false;
            DaoComponentesProdVersionLimpiezaMaquinaria daoLimpiezaMaquinaria = new DaoComponentesProdVersionLimpiezaMaquinaria(LOGGER);
            if(daoLimpiezaMaquinaria.eliminar(codComponentesProdVersionLimpiezaMaquinaria)){
                this.mostrarMensajeTransaccionExitosa("Se elimino la configuración de limpieza de maquinaria");
            }
            else{
                this.mostrarMensajeTransaccionFallida("Ocurrio un error al momento de eliminar la limpieza de maquinaria");
            }
            if(transaccionExitosa){
                this.cargarComponentesProdVersionLimpiezaMaquinaria();
            }
            return null;
        }
    //</editor-fold>
    //<editor-fold defaultstate="collapsed" desc="limpieza utensilio pesaje">
        public String guardarLimpiezaUtensiliosPesajeAction()throws SQLException
        {
            DaoComponentesProdVersionLimpiezaMaquinaria daoLimpiezaMaquinaria = new DaoComponentesProdVersionLimpiezaMaquinaria(LOGGER);
            List<ComponentesProdVersionLimpiezaMaquinaria> guardarList = new ArrayList<>();
            for(ComponentesProdVersionLimpiezaMaquinaria bean : limpiezaUtensilioPesajeAgregarList){
                if(bean.getChecked()){
                    guardarList.add(bean);
                }
            }
            if(daoLimpiezaMaquinaria.guardarLista(guardarList, componentesProdVersionSeleccionado,97)){
                this.mostrarMensajeTransaccionExitosa("Se registro satisfactoriamente la configuración de limpieza de utensilios");
            }
            else{
                this.mostrarMensajeTransaccionFallida("Ocurrio un error al momento del registro,intente de nuevo");
            }
            return null;
        }
        public String getCargarAgregarLimpiezaUtensiliosPesaje()
        {
            DaoComponentesProdVersionLimpiezaMaquinaria daoLimpiezaMaquinaria = new DaoComponentesProdVersionLimpiezaMaquinaria(LOGGER);
            limpiezaUtensilioPesajeAgregarList = daoLimpiezaMaquinaria.listarAgregarUtensilios(componentesProdVersionSeleccionado);
            return null;
        }
        public String eliminarLimpiezaUtensilioPesajeAction(int codComponentesProdVersionLimpiezaMaquinaria)throws SQLException
        {
            transaccionExitosa = false;
            DaoComponentesProdVersionLimpiezaMaquinaria daoLimpiezaMaquinaria = new DaoComponentesProdVersionLimpiezaMaquinaria(LOGGER);
            if(daoLimpiezaMaquinaria.eliminar(codComponentesProdVersionLimpiezaMaquinaria)){
                this.mostrarMensajeTransaccionExitosa("Se elimino la configuración de limpieza de maquinaria");
            }
            else{
                this.mostrarMensajeTransaccionFallida("Ocurrio un error al momento de eliminaro la configuración de limpiza de maquinaria");
            }
            if(transaccionExitosa)
            {
                this.cargarComponentesProdVersionLimpiezaUtensiliosPesaje();
            }
            return null;
        }
        public String getCargarLimpiezaUtensiliosPesaje()
        {
            this.cargarComponentesProdVersionLimpiezaUtensiliosPesaje();
            return null;
        }
        private void cargarComponentesProdVersionLimpiezaUtensiliosPesaje()
        {
            DaoComponentesProdVersionLimpiezaMaquinaria daoLimpiezaMaquinaria = new DaoComponentesProdVersionLimpiezaMaquinaria(LOGGER);
            ComponentesProdVersionLimpiezaMaquinaria criterio = new ComponentesProdVersionLimpiezaMaquinaria();
            criterio.setComponentesProdVersion(componentesProdVersionSeleccionado);
            criterio.getAreasEmpresa().setCodAreaEmpresa("97");
            componentesProdVersionLimpiezaUtensilioPesajeList = daoLimpiezaMaquinaria.listar(criterio);
        }
    //</editor-fold>
    //<editor-fold defaultstate="collapsed" desc="limpieza area pesaje">
        
        public String guardarLimpiezaPesajeAction()throws SQLException
        {
            DaoComponentesProdVersionLimpiezaSeccion daoLimpiezaSeccion = new DaoComponentesProdVersionLimpiezaSeccion(LOGGER);
            componentesProdVersionLimpiezaPesaje.setComponentesProdVersion(componentesProdVersionSeleccionado);
            componentesProdVersionLimpiezaPesaje.getAreasEmpresa().setCodAreaEmpresa("97");
            List<ComponentesProdVersionLimpiezaMaquinaria> guardarList = new ArrayList<>();
            for(ComponentesProdVersionLimpiezaMaquinaria bean : componentesProdVersionLimpiezaPesaje.getComponentesProdVersionLimpiezaMaquinariaList()){
                if(bean.getChecked()){
                    guardarList.add(bean);
                }
            }
            componentesProdVersionLimpiezaPesaje.setComponentesProdVersionLimpiezaMaquinariaList(guardarList);
            if(daoLimpiezaSeccion.guardar(componentesProdVersionLimpiezaPesaje)){
                this.mostrarMensajeTransaccionExitosa("Se registro satisfactoriamente la configuracion de limpieza de maquinarias y secciones");
            }
            else{
                this.mostrarMensajeTransaccionFallida("Ocurrio un error al momento de registrar la configuracion de limpieza de maquinaria y secciones");
            }
            return null;
        }
        
        private void cargarSeccionesOrdenManufacturaSelectList(){
            DaoSeccionesOrdenManufactura daoSeccionesOm = new DaoSeccionesOrdenManufactura(LOGGER);
            seccionesOrdenManufacturaSelectList = daoSeccionesOm.listarSelectItemNoVersion(componentesProdVersionSeleccionado);
        }
        public String getCargarAgregarLimpiezaPesaje()
        {
            this.cargarSeccionesOrdenManufacturaSelectList();
            componentesProdVersionLimpiezaPesaje = new ComponentesProdVersionLimpiezaSeccion();
            DaoComponentesProdVersionLimpiezaMaquinaria daoLimpiezaMaquinaria = new DaoComponentesProdVersionLimpiezaMaquinaria(LOGGER);
            componentesProdVersionLimpiezaPesaje.setComponentesProdVersionLimpiezaMaquinariaList(daoLimpiezaMaquinaria.listarAgregarParaSeccion());
            return null;
        }
        public String getCargarLimpiezaPesaje()
        {
            this.cargarComponentesProdVersionLimpiezaSeccionPesajeList();
            return null;
        }
        private void cargarComponentesProdVersionLimpiezaSeccionPesajeList()
        {
            DaoComponentesProdVersionLimpiezaSeccion daoLimpiezaSeccion = new DaoComponentesProdVersionLimpiezaSeccion(LOGGER);
            ComponentesProdVersionLimpiezaSeccion buscar = new ComponentesProdVersionLimpiezaSeccion();
            buscar.setComponentesProdVersion(componentesProdVersionSeleccionado);
            buscar.getAreasEmpresa().setCodAreaEmpresa("97");
            componentesProdVersionLimpiezaSeccionList = daoLimpiezaSeccion.listar(buscar);
        }
    //</editor-fold>
    //<editor-fold desc="proceso" defaultstate="collapsed">
        //<editor-fold defaultstate="collapsed" desc="concentracion">
            public String buscarMaterialAction()
            {
                DaoMateriales daoMateriales = new DaoMateriales();
                materialesBuscar.getGrupo().getCapitulo().setCodCapitulo(2);
                materialesBuscar.getEstadoRegistro().setCodEstadoRegistro("1");
                materialesList = daoMateriales.listar(materialesBuscar);
                return null;
            }
            public String seleccionarAgregarMaterialConcentracionAction()
            {
                ComponentesProdConcentracion bean = new ComponentesProdConcentracion();
                bean.setMateriales(materiales);
                componentesProdVersion.getComponentesProdConcentracionList().add(bean);
                return null;
            }
        //</editor-fold>
        //<editor-fold defaultstate="collapsed" desc="productos">
            private void cargarColoresPresPrimSelectList()
            {
                DaoColoresPresPrimaria daoColores = new DaoColoresPresPrimaria(LOGGER);
                coloresPresPrimSelectList = daoColores.listarSelectItem();
            }
            private void cargarTamaniosCapsulasProduccion()
            {
                DaoTamanioCapsulaProduccion daoTamanioCapsula = new DaoTamanioCapsulaProduccion(LOGGER);
                tamaniosCapsulasSelectList = daoTamanioCapsula.listarSelectItem();
            }
            public String editarComponentesProdVersionAction()throws SQLException
            {
                mensaje = "";
                transaccionExitosa = false;
                DaoComponentesProdVersion daoComponentesProdVersion = new DaoComponentesProdVersion(LOGGER);
                for(ComponentesProdConcentracion bean : componentesProdVersion.getComponentesProdConcentracionList())
                    bean.setUnidadProducto(componentesProdConcentracionBean.getUnidadProducto());
                if(daoComponentesProdVersion.editar(componentesProdVersion))
                {
                    mensaje = "1";
                    this.mostrarMensajeTransaccionExitosa("Se modifico satisfactoriamente la información del producto");
                    if(componentesProdVersion.getEstadosVersionComponentesProd().getCodEstadoVersionComponenteProd() == 2)
                    {
                        this.aprobarVersionProductoDesarrollo(componentesProdVersion);
                    }
                }
                else
                {
                    this.mostrarMensajeTransaccionExitosa("Ocurrio un error al momento de modificar la información del producto");
                }

                return null;
            }
            private void cargarUnidadesMedidaSelectList()
            {
                try {
                    con = Util.openConnection(con);
                    Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    String consulta = "select um.COD_UNIDAD_MEDIDA,um.ABREVIATURA from UNIDADES_MEDIDA um " +
                                      " where um.COD_TIPO_MEDIDA in (1,2) order by um.ABREVIATURA";
                    ResultSet res = st.executeQuery(consulta);
                    unidadesMedidaSelectList = new ArrayList<SelectItem>();
                    while (res.next()) 
                    {
                        unidadesMedidaSelectList.add(new SelectItem(res.getString("COD_UNIDAD_MEDIDA"),res.getString("ABREVIATURA")));
                    }
                    res.close();
                    st.close();
                    con.close();
                }
                catch (SQLException ex)
                {
                    LOGGER.warn("error", ex);
                }
            }
            public String agregarNuevoProductoAction()
            {
                producto = new Producto();
                producto.getEstadoProducto().setCodEstadoProducto("1");
                return null;
            }
            public String guardarProductoAction()throws SQLException
            {
                mensaje = "";
                DaoProductos daoProductos = new DaoProductos();
                if(daoProductos.guardar(producto))
                {
                    mensaje = "1";
                    this.cargarProductosSelectList();
                    componentesProdVersion.getProducto().setCodProducto(producto.getCodProducto());
                }
                else
                {
                    mensaje = "Ocurrio un error al momento de guardar el producto, intente de nuevo y verifique que el nombre no se encuentre registrado";
                }
                return null;
            }
        //</editor-fold>
        //<editor-fold desc="crear nuevo ensayo" defaultstate="collapsed">
            public String seleccionarUltimaVersionProductoAction()
            {
                componentesProdVersionNuevoEnsayo = componentesProdDesarrolloEnsayoList.get(0);
                nuevoTamanioLote = componentesProdVersionNuevoEnsayo.getTamanioLoteProduccion();
                return null;
            }
            public String crearNuevaVersionProductoDesarrolloAction() throws SQLException{
                this.transaccionExitosa = false;
                try {
                    con = Util.openConnection(con);
                    con.setAutoCommit(false);
                    StringBuilder consulta = new StringBuilder(" select fmes.COD_FORMULA_MAESTRA_ES_VERSION")
                                                        .append(" from FORMULA_MAESTRA_ES_VERSION fmes")
                                                        .append(" where fmes.COD_VERSION =").append(componentesProdVersionNuevoEnsayo.getCodVersion());
                    LOGGER.debug("consulta obtener version de es "+consulta.toString());
                    Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet res = st.executeQuery(consulta.toString());
                    int codFormulaMaestraEs = 0;
                    if(res.next()) codFormulaMaestraEs = res.getInt("COD_FORMULA_MAESTRA_ES_VERSION");
                    consulta = new StringBuilder(" exec PAA_GENERACION_NUEVA_VERSION_PRODUCTO ");
                                                consulta.append(componentesProdSeleccionado.getCodCompprod()).append(",");
                                                consulta.append("1,");//version de producto
                                                consulta.append("0,")//codigo producto destino 
                                                        .append("0,")//codigo formula maestra destino
                                                        .append("?,")//codigo de version generado
                                                        .append(componentesProdVersionNuevoEnsayo.getCodVersion()).append(",")
                                                        .append(codFormulaMaestraEs);
                    LOGGER.debug("consulta crear version producto "+consulta.toString());
                    CallableStatement callDesviacionBajoRendimiento=con.prepareCall(consulta.toString());
                    callDesviacionBajoRendimiento.registerOutParameter(1,java.sql.Types.INTEGER);
                    callDesviacionBajoRendimiento.execute();
                    int codVersion=callDesviacionBajoRendimiento.getInt(1);
                    PreparedStatement pst=null;
                    SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm");
                    ManagedAccesoSistema managed=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
                    consulta=new StringBuilder("INSERT INTO COMPONENTES_PROD_VERSION_MODIFICACION(COD_PERSONAL, COD_VERSION,COD_ESTADO_VERSION_COMPONENTES_PROD,FECHA_INCLUSION_VERSION)");
                                consulta.append(" VALUES (");
                                    consulta.append("'").append(managed.getUsuarioModuloBean().getCodUsuarioGlobal()).append("',");
                                    consulta.append("'").append(codVersion).append("',");
                                    consulta.append("1,");
                                    consulta.append("'").append(sdf.format(new Date())).append("'");
                                consulta.append(")");
                    LOGGER.debug("consulta insertar usuario modificacion "+consulta);
                    pst=con.prepareStatement(consulta.toString());
                    if(pst.executeUpdate()>0)LOGGER.info("se registro la colaboracion ");
                    // <editor-fold defaultstate="collapsed" desc="cambiando cantidad de tamanio de lote y recalculando cantidades">
                        consulta=new StringBuilder(" UPDATE COMPONENTES_PROD_VERSION");
                                    consulta.append(" SET TAMANIO_LOTE_PRODUCCION=").append(nuevoTamanioLote);
                                            consulta.append(" ,COD_TIPO_MODIFICACION_PRODUCTO=3");
                                    consulta.append(" WHERE COD_VERSION=").append(codVersion);
                        LOGGER.debug("consulta actualizar cantidades "+consulta.toString());
                        pst=con.prepareStatement(consulta.toString());
                        if(pst.executeUpdate()>0)LOGGER.info("se actualizo la cantidad");
                        consulta=new StringBuilder(" exec PAA_ACTUALIZACION_CANTIDADES_FORMULA_MAESTRA_VERSION ");
                                    consulta.append(codVersion);
                        LOGGER.debug("consulta actualizar cantidad formula "+consulta.toString());
                        pst=con.prepareStatement(consulta.toString());
                        if(pst.executeUpdate()>0)LOGGER.info("se actualizo la cantidad de formula maestra");
                        consulta=new StringBuilder("update FORMULA_MAESTRA_DETALLE_ES_VERSION set CANTIDAD=CANTIDAD*").append(Double.valueOf(nuevoTamanioLote)/Double.valueOf(componentesProdVersionNuevoEnsayo.getTamanioLoteProduccion()));
                                    consulta.append(" FROM FORMULA_MAESTRA_DETALLE_ES_VERSION fmdes");
                                            consulta.append(" inner join FORMULA_MAESTRA_ES_VERSION fmes on fmes.COD_FORMULA_MAESTRA_ES_VERSION=fmdes.COD_FORMULA_MAESTRA_ES_VERSION");
                                    consulta.append(" where fmes.COD_VERSION=").append(codVersion);
                        LOGGER.debug("consulta actualizar cantidad fmes "+consulta.toString());
                        pst=con.prepareStatement(consulta.toString());
                        if(pst.executeUpdate()>0)LOGGER.info("se actualizaron las cantidades de fmes");
                    //</editor-fold>
                    consulta = new StringBuilder("exec PAA_APROBACION_COMPONENTES_PROD_VERSION ")
                                    .append(codVersion);
                    LOGGER.debug("consulta aprobar ultima version "+consulta.toString());
                    pst=con.prepareStatement(consulta.toString());
                    if(pst.executeUpdate() > 0)LOGGER.info("se aprobo la ultima version ");
                    StringBuilder consultaES=new StringBuilder("select f.COD_FORMULA_MAESTRA_ES_VERSION,fmv.COD_FORMULA_MAESTRA,fmv.COD_COMPPROD");
                                            consultaES.append(" from FORMULA_MAESTRA_ES_VERSION f ")
                                                            .append(" inner join formula_maestra_version fmv on fmv.COD_COMPPROD_VERSION = f.COD_VERSION")
                                                    .append(" where f.COD_VERSION=").append(codVersion);
                    LOGGER.debug("consulta buscar version es "+consultaES.toString());
                    res=st.executeQuery(consultaES.toString());
                    if(res.next())
                    {
                        consultaES=new StringBuilder("exec PAA_APROBACION_FORMULA_MAESTRA_ES_VERSION ");
                                consultaES.append(res.getInt("COD_FORMULA_MAESTRA_ES_VERSION")).append(",");
                                consultaES.append(codVersion).append(",");
                                consultaES.append(res.getInt("COD_COMPPROD")).append(",");
                                consultaES.append(res.getInt("COD_FORMULA_MAESTRA"));
                        LOGGER.debug("consulta  aprobar es "+consultaES.toString());
                        pst=con.prepareStatement(consultaES.toString());
                        if(pst.executeUpdate()>0)LOGGER.info("se aprobo la version es ");
                    }
                    con.commit();
                    this.mostrarMensajeTransaccionExitosa("Se registro satisfactoriamente la nueva versión de producto");
                }
                catch (SQLException ex){
                    con.rollback();
                    con.close();
                    this.mostrarMensajeTransaccionFallida("Ocurrio un error al momemto de registrar la nueva versión, intente de nuevo");
                    LOGGER.warn(ex);
                }
                finally{
                    this.cerrarConexion(con);
                }
                if(transaccionExitosa){
                    this.cargarComponentesProdDesarrolloEnsayoList();
                }
                
                return null;
            }
            
        //</editor-fold>
        //<editor-fold defaultstate="collapsed" desc="editar ensayo">\
            public String getCargarEdicionComponentesProdVersion()
            {
                this.cargarTiposRefenciasCcSelect();
                this.cargarTamaniosCapsulasProduccion();
                this.cargarColoresPresPrimSelectList();
                this.cargarUnidadesMedidaSelectList();
                this.cargarViasAdministracionSelectList();
                this.cargarCondicionesVentaProductoSelectList();
                this.cargarAreaEmpresaFabricacionProductoSelectList();
                this.cargarFormasFarmaceuticasSelectList();
                this.cargarProductosSelectList();
                componentesProdConcentracionBean = new ComponentesProdConcentracion();
                DaoComponentesProdConcentracion daoConcentracion = new DaoComponentesProdConcentracion(LOGGER);
                componentesProdVersion.setComponentesProdConcentracionList(daoConcentracion.listar(componentesProdVersion));
                if(componentesProdVersion.getComponentesProdConcentracionList().size()>0)
                {
                    componentesProdConcentracionBean = componentesProdVersion.getComponentesProdConcentracionList().get(0);
                }
                if(componentesProdVersion.getNombreProdSemiterminado()==null||componentesProdVersion.getNombreProdSemiterminado().equals(""))
                {
                    componentesProdVersion.setNombreProdSemiterminado(componentesProdVersion.getProducto().getNombreProducto()+" "+componentesProdVersion.getForma().getNombreForma()+" "+componentesProdVersion.getSaboresProductos().getNombreSabor());
                }
                return null;
            }
            public String guardarComponentesProdVersionAction()throws SQLException
            {
                mensaje = "";
                DaoComponentesProdVersion daoComponentesProdVersion = new DaoComponentesProdVersion(LOGGER);
                componentesProdVersion.getTiposProduccion().setCodTipoProduccion(COD_TIPO_PRODUCCION_ESTANDARIZACION_DESARROLLO);//producto en estandarizacion
                for(ComponentesProdConcentracion bean : componentesProdVersion.getComponentesProdConcentracionList())
                    bean.setUnidadProducto(componentesProdConcentracionBean.getUnidadProducto());
                if(daoComponentesProdVersion.guardar(componentesProdVersion)){
                    mensaje = "1";
                }
                else{
                    mensaje = "Ocurrio un error al momento de registrar el producto, intente de nuevo";
                }
                return null;
            }
        //</editor-fold>
        //<editor-fold defaultstate="collapsed" desc="agregar producto desarrollo">
            public String eliminarComponentesProdConcetracionAction(int index){
                componentesProdVersion.getComponentesProdConcentracionList().remove(index);
                return null;
            }
            public String getCargarAgregarComponentesProdVersion()
            {
                this.cargarTamaniosCapsulasProduccion();
                this.cargarColoresPresPrimSelectList();
                this.cargarUnidadesMedidaSelectList();
                this.cargarViasAdministracionSelectList();
                this.cargarCondicionesVentaProductoSelectList();
                this.cargarAreaEmpresaFabricacionProductoSelectList();
                this.cargarProductosSelectList();
                this.cargarTiposRefenciasCcSelect();
                componentesProdVersion = new ComponentesProdVersion();
                componentesProdVersion.setNroVersion(1);
                componentesProdVersion.getAreasEmpresa().setCodAreaEmpresa("81");
                componentesProdConcentracionBean = new ComponentesProdConcentracion();
                componentesProdVersion.setComponentesProdConcentracionList(new ArrayList<>());
                return null;
            }
        //</editor-fold>
        
        public String getCargarComponentesProdDesarrolloEnsayoList()
        {
            this.cargarPermisosEspecialesPersonal();
            this.cargarComponentesProdDesarrolloEnsayoList();
            return null;
        }
        private void cargarComponentesProdDesarrolloEnsayoList()
        {
            ManagedAccesoSistema managed = (ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
            componentesProdDesarrollloBean = new ComponentesProdVersion();
            componentesProdDesarrollloBean.setCodCompprod(componentesProdSeleccionado.getCodCompprod());
            componentesProdDesarrollloBean.setComponentesProdVersionModificacionPersonal(new ComponentesProdVersionModificacion());
            componentesProdDesarrollloBean.getComponentesProdVersionModificacionPersonal().getPersonal().setCodPersonal(managed.getUsuarioModuloBean().getCodUsuarioGlobal());
            DaoComponentesProdVersion daoComponentesProdVersion = new DaoComponentesProdVersion(LOGGER);
            componentesProdDesarrolloEnsayoList = daoComponentesProdVersion.listar(componentesProdDesarrollloBean);
            try {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select p.COD_LOTE_PRODUCCION,epp.NOMBRE_ESTADO_PROGRAMA_PROD,p.COD_PROGRAMA_PROD")
                                                .append(" from programa_produccion p")
                                                        .append(" inner join PROGRAMA_PRODUCCION_PERIODO ppp on p.COD_PROGRAMA_PROD = ppp.COD_PROGRAMA_PROD")
                                                        .append(" inner join ESTADOS_PROGRAMA_PRODUCCION epp on epp.COD_ESTADO_PROGRAMA_PROD = p.COD_ESTADO_PROGRAMA")
                                                .append(" where p.COD_COMPPROD_VERSION =?")
                                                        .append(" and ppp.COD_ESTADO_PROGRAMA<>4")
                                                        .append(" and  p.COD_PROGRAMA_PROD >0");
                LOGGER.debug("consulta cargar lotes asociados version "+consulta.toString());
                PreparedStatement pst = con.prepareStatement(consulta.toString());
                ResultSet res;
                for(ComponentesProdVersion bean : componentesProdDesarrolloEnsayoList){
                    pst.setInt(1,bean.getCodVersion());
                    res = pst.executeQuery();
                    bean.setProgramaProduccionList(new ArrayList<ProgramaProduccion>());
                    while(res.next()){
                        ProgramaProduccion  programa = new ProgramaProduccion();
                        programa.getProgramaProduccionPeriodo().setCodProgramaProduccion(res.getString("COD_PROGRAMA_PROD"));
                        programa.setCodLoteProduccion(res.getString("COD_LOTE_PRODUCCION"));
                        programa.getEstadoProgramaProduccion().setNombreEstadoProgramaProd(res.getString("NOMBRE_ESTADO_PROGRAMA_PROD"));
                        bean.getProgramaProduccionList().add(programa);
                    }
                }
            } catch (SQLException ex) {
                LOGGER.warn("error", ex);
            } catch (NumberFormatException ex) {
                LOGGER.warn("error", ex);
            } finally {
                this.cerrarConexion(con);
            }
        }
        public String anteriorPagina_action()
        {
            begin=begin-numrows;
            end=end-numrows;
            this.cargarComponentesProdList();
            return null;
        }
        public String siguientePagina_action(){
            begin=begin+numrows;
            end=end+numrows;
            this.cargarComponentesProdList();
            return null;
        }
        
        public ManagedProductosDesarrolloVersion() 
        {
            begin = 1;
            end = 20;
            numrows = 20;
            LOGGER=LogManager.getLogger("ProductosDesarrollo");
            formulaMaestraVersionSeleccionado = new FormulaMaestraVersion();
            formulaMaestraEsVersionSeleccionado = new FormulaMaestraEsVersion();
            componentesProdBuscar = new ComponentesProd();
            componentesProdBuscar.getEstadoCompProd().setCodEstadoCompProd(1);
            componentesProdBuscar.getTiposProduccion().setCodTipoProduccion(3);
            componentesProdBuscar.getForma().setCodForma("0");
            componentesProdBuscar.getProducto().setCodProducto("0");
            componentesProdBuscar.getAreasEmpresa().setCodAreaEmpresa("0");
            componentesProdBuscar.getColoresPresentacion().setCodColor("0");
        }
        private void cargarViasAdministracionSelectList()
        {
            DaoViasAdministracionProducto daoViasAdministracion = new DaoViasAdministracionProducto(LOGGER);
            viasAdministracionSelectList = daoViasAdministracion.listarSelectItem();
        }
        private void cargarSaboresProductoSelectList()
        {
            try {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select sp.COD_SABOR,sp.NOMBRE_SABOR");
                                        consulta.append(" from SABORES_PRODUCTO sp");
                                        consulta.append(" where sp.COD_ESTADO_REGISTRO=1");
                                        consulta.append(" order by sp.NOMBRE_SABOR");
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                saboresProductosSelectList=new ArrayList<SelectItem>();
                while (res.next()) 
                {
                    saboresProductosSelectList.add(new SelectItem(res.getString("COD_SABOR"),res.getString("NOMBRE_SABOR")));
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
        private void cargarCondicionesVentaProductoSelectList()
        {
            DaoCondicionesVentaProducto daoCondiciones = new DaoCondicionesVentaProducto(LOGGER);
            condicionesVentaProductoSelectList = daoCondiciones.listarSelectItem();
        }
        private void cargarAreaEmpresaFabricacionProductoSelectList()
        {
            DaoAreasEmpresa daoAreasEmpresa = new DaoAreasEmpresa(LOGGER);
            areasFabricacionProductoSelectList = daoAreasEmpresa.listarAreasFabricacionSelectItem();
        }
        private void cargarFormasFarmaceuticasSelectList()
        {
            try {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select f.cod_forma,f.nombre_forma");
                                            consulta.append(" from FORMAS_FARMACEUTICAS f");
                                            consulta.append(" where f.cod_estado_registro=1");
                                            consulta.append(" order by f.nombre_forma");
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                formasFarmaceuticasSelectList=new ArrayList<SelectItem>();
                while (res.next()) 
                {
                    formasFarmaceuticasSelectList.add(new SelectItem(res.getString("cod_forma"),res.getString("nombre_forma")));
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
        private void cargarProductosSelectList()
        {
           DaoProductos daoProductos = new DaoProductos(LOGGER);
           productosSelectList = daoProductos.listarSelectItem();
        }
        public String agregarProductoDesarrollo_action()
        {
            componentesProdVersion = new ComponentesProdVersion();
            return null;
        }
        public String cambiarEstadoProductoAction(int codEstadoProducto){
            DaoComponentesProdVersion daoComponentesProdVersion = new DaoComponentesProdVersion(LOGGER);
            if(daoComponentesProdVersion.cambiarEstadoProducto(Integer.valueOf(componentesProdSeleccionado.getCodCompprod()), codEstadoProducto)){
                this.mostrarMensajeTransaccionExitosa("Se registro satisfactoriamente la "+(codEstadoProducto == 1?"activación":"inactivación")+" del producto");
                this.cargarComponentesProdList();
            }
            else{
                this.mostrarMensajeTransaccionFallida("Ocurrio un error al momento de realizar la transaccion, intente de nuevo");
            }
            return null;
        }
        public String getCargarComponentesProdList()
        {
            this.cargarPermisosEspecialesPersonal();
            this.cargarTiposProduccionSelectList();
            if(tiposProduccionSelectList.size() > 0)
                componentesProdBuscar.getTiposProduccion().setCodTipoProduccion(Integer.valueOf(tiposProduccionSelectList.get(0).getValue().toString()));
            else
                componentesProdBuscar.getTiposProduccion().setCodTipoProduccion(-1);
            this.cargarViasAdministracionSelectList();
            this.cargarSaboresProductoSelectList();
            this.cargarAreaEmpresaFabricacionProductoSelectList();
            this.cargarProductosSelectList();
            this.cargarFormasFarmaceuticasSelectList();
            this.cargarComponentesProdList();
            this.cargarColoresPresPrimSelectList();
            return null;
        }
        public String buscarComponentesProdDesarrolloList()
        {
            this.cargarComponentesProdList();
            return null;
        }
        private void cargarComponentesProdList()
        {
            DaoComponentesProd daoComponentesProd = new DaoComponentesProd(LOGGER);
            this.componentesProdList = daoComponentesProd.listar(componentesProdBuscar, begin, end);
        }
        private void cargarTiposProduccionSelectList()
        {
            try {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder(" select tp.COD_TIPO_PRODUCCION,tp.NOMBRE_TIPO_PRODUCCION");
                                            consulta.append(" from TIPOS_PRODUCCION tp");
                                            consulta.append(" where tp.COD_TIPO_PRODUCCION IN (0");
                                                    if(permisoVisualizacionProductoEstandarizacion || permisoRegistrarInformacionRegenciaFarmaceutica){
                                                        consulta.append(",").append(COD_TIPO_PRODUCCION_ESTANDARIZACION_DESARROLLO).append(",").append(COD_TIPO_PRODUCCION_ESTANDARIZACION_VALIDACIONES);
                                                    }
                                                    if(permisoGestionEstandarizacionDesarrollo){
                                                        consulta.append(",").append(COD_TIPO_PRODUCCION_ESTANDARIZACION_DESARROLLO);
                                                    }
                                                    if(permisoGestionEstandarizacionValidaciones){
                                                        consulta.append(",").append(COD_TIPO_PRODUCCION_ESTANDARIZACION_VALIDACIONES);
                                                    }
                                                    consulta.append(")");
                                            consulta.append(" order by tp.NOMBRE_TIPO_PRODUCCION");
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                tiposProduccionSelectList=new ArrayList<SelectItem>();
                while (res.next()) 
                {
                    tiposProduccionSelectList.add(new SelectItem(res.getInt("COD_TIPO_PRODUCCION"),res.getString("NOMBRE_TIPO_PRODUCCION")));
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
    //<editor-fold desc="formula maestra mp" defaultstate="collapsed">
        
        public String seleccionarFormulaMaestraVersionAction()
        {
            try {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("SELECT fmv.COD_VERSION,fmv.COD_FORMULA_MAESTRA")
                                                .append(" from FORMULA_MAESTRA_VERSION fmv")
                                                .append(" where fmv.COD_COMPPROD_VERSION = ").append(formulaMaestraVersionSeleccionado.getComponentesProd().getCodVersion());
                LOGGER.debug("consulta obtener codigo de version  "+consulta.toString());
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                while (res.next()) {
                    formulaMaestraVersionSeleccionado.setCodVersion(res.getInt("COD_VERSION"));
                    formulaMaestraVersionSeleccionado.setCodFormulaMaestra(res.getString("COD_FORMULA_MAESTRA"));
                }
                
                mensaje = "1";
            } catch (SQLException ex) {
                LOGGER.warn(ex.getMessage());
            } catch (NumberFormatException ex) {
                LOGGER.warn(ex.getMessage());
            } finally {
                this.cerrarConexion(con);
            }
            return null;
        }
        private void cargarFormulaMaestraDetalleMPVersion()
        {
            DaoFormulaMaestraDetalleMpVersion daoFmMp=new DaoFormulaMaestraDetalleMpVersion(LOGGER);
            formulaMaestraDetalleMPList=daoFmMp.getFormulaMaestraDetalleMpGroupByTiposMaterialProduccionList(formulaMaestraVersionSeleccionado);
            DaoTiposMaterialProduccion daoTiposMatProd = new DaoTiposMaterialProduccion(LOGGER);
            tiposMaterialProduccionList = daoTiposMatProd.listar();
        }
        public String getCargarFormulaMaestraDelleMpVersion()
        {
            this.cargarFormulaMaestraDetalleMPVersion();
            return null;
        }
        public String getCargarAgregarFormulaMaestraDetalleMP()
        {
            tiposMaterialProduccionSeleccionado = new TiposMaterialProduccion();
            formulaMaestraDetalleMPAgregarList = new ArrayList<FormulaMaestraDetalleMP>();
            return null;
        }
        
        public String cargarAgregarFormulaMaestraDetalleMPAction() {
            DaoFormulaMaestraDetalleMpVersion daoFormulaMp = new DaoFormulaMaestraDetalleMpVersion(LOGGER);
            formulaMaestraDetalleMPAgregarList = daoFormulaMp.listaAgregar(formulaMaestraVersionSeleccionado.getCodVersion(),tiposMaterialProduccionSeleccionado.getCodTipoMaterialProduccion());
            return null;
        }
        public String seleccionarEditarFormulaMaestraDetalleMpAction()
        {
            formulaMaestraDetalleMPEditarList = new ArrayList<FormulaMaestraDetalleMP>();
            for(TiposMaterialProduccion tipo : formulaMaestraDetalleMPList)
            {
                for(FormulaMaestraDetalleMP bean:tipo.getFormulaMaestraDetalleMPList())
                {
                    if(bean.getChecked())
                    {
                        formulaMaestraDetalleMPEditarList.add(bean);
                    }
                }
            }
            return null;
        }
        public String editarFormulaMaestraDetalleMpAction()throws SQLException
        {
            mensaje="";
            DaoFormulaMaestraDetalleMpVersion daoFormulaMaestraDetalleMpVersion = new DaoFormulaMaestraDetalleMpVersion(LOGGER);
            if(daoFormulaMaestraDetalleMpVersion.editarLista(formulaMaestraDetalleMPEditarList, formulaMaestraVersionSeleccionado))
            {
                mensaje = "1";
                actualizarFormulaMaestraVersionSeleccionado();
            }
            else
            {
                mensaje = "Ocurrio un error al momento de editar los registros, intente de nuevo";
            }
            return null;
        }
        public String guardarFormulaMaestraDetalleMpAction()throws SQLException
        {
            mensaje = "";
            List<FormulaMaestraDetalleMP> agregarList = new ArrayList<FormulaMaestraDetalleMP>();
            for(FormulaMaestraDetalleMP bean : formulaMaestraDetalleMPAgregarList)
            {
                if(bean.getChecked())
                {
                    bean.setTiposMaterialProduccion(tiposMaterialProduccionSeleccionado);
                    agregarList.add(bean);
                }
            }
            
            DaoFormulaMaestraDetalleMpVersion daoFmMp = new DaoFormulaMaestraDetalleMpVersion(LOGGER);
            if(daoFmMp.guardarLista(agregarList, formulaMaestraVersionSeleccionado))
            {
                mensaje = "1";
                this.actualizarFormulaMaestraVersionSeleccionado();
            }
            else
            {
                mensaje = "Ocurrio un error al momento de registrar los materiales, intente de nuevo";
            }
            return null;
        }
        public String agregarFraccionDesviacionFormulaMaestraDetalleMpAction()
        {
            FormulaMaestraDetalleMPfracciones nuevo=new FormulaMaestraDetalleMPfracciones();
            formulaMaestraDetalleMPBean.getFormulaMaestraDetalleMPfraccionesList().add(nuevo);
            return null;
        }
        public String eliminarFraccionDesviacionFormulaMaestraDetalleMpAction(int index)
        {
            formulaMaestraDetalleMPBean.getFormulaMaestraDetalleMPfraccionesList().remove(index);
            return null;
        }
        public String guardarFormulaMaestraFraccionesMpAction()throws SQLException
        {
            mensaje = "";
            DaoFormulaMaestraDetalleMpFraccionesVersion  daoFmFraccion=new DaoFormulaMaestraDetalleMpFraccionesVersion();
            if(daoFmFraccion.registrarFormulaMaestraDetalleMpFraccionesVersion(formulaMaestraDetalleMPBean))
            {
                mensaje="1";
                this.cargarFormulaMaestraDetalleMPVersion();
                this.actualizarFormulaMaestraVersionSeleccionado();
            }
            else
            {
                mensaje="Ocurrio un error el momento de registrar las fracciones, intente de nuevo";
            }
            return null;
        }
        
        public String eliminarFormulaMaestraDetalleMPAction()throws SQLException
        {
            mensaje="";
            List<FormulaMaestraDetalleMP> formulaMpEliminarList = new ArrayList<FormulaMaestraDetalleMP>();
            for(TiposMaterialProduccion tipo:formulaMaestraDetalleMPList)
            {
                for(FormulaMaestraDetalleMP bean:tipo.getFormulaMaestraDetalleMPList())
                {
                    if(bean.getChecked())
                    {
                        formulaMpEliminarList.add(bean);
                    }
                }
            }
            DaoFormulaMaestraDetalleMpVersion daoMpVersion = new DaoFormulaMaestraDetalleMpVersion(LOGGER);
            if(daoMpVersion.eliminarLista(formulaMpEliminarList))
            {
                mensaje = "1";
                this.cargarFormulaMaestraDetalleMPVersion();
                this.actualizarFormulaMaestraVersionSeleccionado();
            }
            return null;
        }
    //</editor-fold>
    //<editor-fold defaultstate="collapsed" desc="formula maestra detalle mr">
        private void cargarFormulaMaestraDetalleMrList()
        {
            DaoFormulaMaestraDetalleMrVersion daoFormulaMr = new DaoFormulaMaestraDetalleMrVersion();
            formulaMaestraDetalleMRList = daoFormulaMr.listar(formulaMaestraVersionSeleccionado, codTipoMaterialReactivo);
        }
        public String getCargarFormulaMaestraDetalleMrList()
        {
            this.cargarTiposMaterialReactivo();
            if(tiposMaterialReactivoSelectList.size() > 0){
                codTipoMaterialReactivo = Integer.valueOf(tiposMaterialReactivoSelectList.get(0).getValue().toString());
            }
            this.cargarFormulaMaestraDetalleMrList();
            return null;
        }
        public String codTipoMaterialReactivoChange()
        {
            this.cargarFormulaMaestraDetalleMrList();
            return null;
        }
        public String getCargarAgregarFormulaMaestraDetalleMr()
        {
            DaoFormulaMaestraDetalleMrVersion daoFormulaMr = new DaoFormulaMaestraDetalleMrVersion(LOGGER);
            formulaMaestraDetalleMRAgregarList = daoFormulaMr.listarAgregar(formulaMaestraVersionSeleccionado);
            return null;
        }
        private void cargarTiposMaterialReactivo()
        {
            DaoTiposMaterialReactivo daoTiposMr = new DaoTiposMaterialReactivo(LOGGER);
            tiposMaterialReactivoSelectList = daoTiposMr.listarSelectItem();

        }
        public String guardarFormulaMaestraDetalleMRVersionAction()throws SQLException
        {
            mensaje="";
            List<FormulaMaestraDetalleMr> listaAgregar = new ArrayList<>();
            for(FormulaMaestraDetalleMr bean : formulaMaestraDetalleMRAgregarList)
            {
                if(bean.getChecked()){
                    bean.getTiposMaterialReactivo().setCodTipoMaterialReactivo(codTipoMaterialReactivo);
                    listaAgregar.add(bean);
                }
            }
            DaoFormulaMaestraDetalleMrVersion daoFormulaMr = new DaoFormulaMaestraDetalleMrVersion(LOGGER);
            if(daoFormulaMr.guardarLista(listaAgregar, formulaMaestraVersionSeleccionado)){
                mensaje = "1";
                this.actualizarFormulaMaestraVersionSeleccionado();
            }
            else{
                mensaje = "Ocurrio un error al momento de registrar el material reactivo, intente de nuevo";
            }
            return null;
        }
        public String seleccionarEditarFormulaMaestraDetalleMrAction()
        {
            formulaMaestraDetalleMREditarList = new ArrayList<>();
            for(FormulaMaestraDetalleMr bean : formulaMaestraDetalleMRList){
                if(bean.getChecked())
                {
                    formulaMaestraDetalleMREditarList.add(bean);
                }
            }
            return null;
        }
        public String editarFormulaMaestraDetalleMrVersionAction()throws SQLException
        {
            mensaje="";
            DaoFormulaMaestraDetalleMrVersion daoFormulaMr = new DaoFormulaMaestraDetalleMrVersion(LOGGER);
            if(daoFormulaMr.editarLista(formulaMaestraDetalleMREditarList)){
                mensaje  = "1";
                this.actualizarFormulaMaestraVersionSeleccionado();
            }
            else{
                mensaje = "Ocurrio un error al momento de editar los materiales, intente de nuevo";
            }
            return null;
        }
        public String eliminarFormulaMaestraDetalleMRVersionAction() throws SQLException
        {
            mensaje  = "";
            DaoFormulaMaestraDetalleMrVersion daoFormulaMr = new DaoFormulaMaestraDetalleMrVersion(LOGGER);
            List<FormulaMaestraDetalleMr> eliminarList = new ArrayList<>();
            for(FormulaMaestraDetalleMr bean : formulaMaestraDetalleMRList){
                if(bean.getChecked())
                {
                    eliminarList.add(bean);
                }
            }
            if(daoFormulaMr.eliminarLista(eliminarList))
            {
                mensaje = "1";
                this.cargarFormulaMaestraDetalleMrList();
                this.actualizarFormulaMaestraVersionSeleccionado();
            }
            else
            {
                mensaje = "Ocurrio un error al momento de eliminar el/los item(s) seleccionado(s)";
            }
            return null;
        }
    //</editor-fold>    
    //<editor-fold defaultstate="collapsed" desc="formula maestra">
        
        
        private void aprobarVersionProductoDesarrollo(ComponentesProdVersion componentesProdVersion)
        {
            try 
            {
                con = Util.openConnection(con);
                con.setAutoCommit(false);
                StringBuilder consulta=new StringBuilder("exec PAA_APROBACION_COMPONENTES_PROD_VERSION ")
                                                        .append(componentesProdVersion.getCodVersion());
                LOGGER.debug("consulta actualizar version "+consulta.toString());
                PreparedStatement pst = con.prepareStatement(consulta.toString());
                if(pst.executeUpdate()>0)LOGGER.info("se aprobo la version");
                for(ProgramaProduccion programaProduccion : componentesProdVersion.getProgramaProduccionList()){
                    consulta = new StringBuilder(" exec PAA_REGISTRO_PROGRAMA_PRODUCCION_DETALLE ")
                                .append(programaProduccion.getProgramaProduccionPeriodo().getCodProgramaProduccion()).append(",")
                                .append("'").append(programaProduccion.getCodLoteProduccion()).append("'");
                    LOGGER.debug("consulta actualizar cantidades lote "+consulta.toString());
                    pst = con.prepareStatement(consulta.toString());
                    if(pst.executeUpdate() > 0)LOGGER.info("se actualzo la cantidad del lote ");
                }
                con.commit();
                pst.close();
            } 
            catch (SQLException ex) 
            {
                this.mostrarMensajeTransaccionFallida("Ocurrio un error de datos al momento de guardar la desviacion, verifique la información e intente de nuevo");
                LOGGER.warn(ex.getMessage());
                this.rollbackConexion(con);
            }
            catch (NumberFormatException ex) 
            {
                this.mostrarMensajeTransaccionFallida("Ocurrio un error de datos al momento de guardar la desviacion, verifique la información e intente de nuevo");
                LOGGER.warn(ex.getMessage());
                this.rollbackConexion(con);
            }
            finally 
            {
                this.cerrarConexion(con);
            }
        }
        private void actualizarFormulaMaestraVersionSeleccionado()
        {
            if(((ComponentesProdVersion)formulaMaestraVersionSeleccionado.getComponentesProd()).getEstadosVersionComponentesProd().getCodEstadoVersionComponenteProd() == COD_ESTADO_VERSION_APROBADA)
            {
                this.aprobarVersionProductoDesarrollo(((ComponentesProdVersion)formulaMaestraVersionSeleccionado.getComponentesProd()));
            }
        }
    //</editor-fold>
        
    //<editor-fold defaultstate="collapsed" desc="procesos orden manufactura">
        public String agregarProcesoOrdenManufacturaAction(ComponentesProdProcesoOrdenManufactura componentesProdProceso){
            componentesProdProcesoOrdenManufacturaDisponibleList.remove(componentesProdProceso);
            componentesProdProcesoOrdenManufacturaList.add(componentesProdProceso);
            return null;
        }
        public String eliminarProcesoOrdenManufacturaAction(ComponentesProdProcesoOrdenManufactura componentesProdProceso){
            componentesProdProcesoOrdenManufacturaDisponibleList.add(componentesProdProceso);
            componentesProdProcesoOrdenManufacturaList.remove(componentesProdProceso);
            return null;
        }
        public String adicionarOrdenProcesoOrdenManufacturaAction(int index,int paso)
        {
            ComponentesProdProcesoOrdenManufactura procesoSelecciondo = componentesProdProcesoOrdenManufacturaList.get(index);
            ComponentesProdProcesoOrdenManufactura procesoCambio = componentesProdProcesoOrdenManufacturaList.get(index+(paso));
            componentesProdProcesoOrdenManufacturaList.set(index, procesoCambio);
            componentesProdProcesoOrdenManufacturaList.set(index+(paso),procesoSelecciondo);
            return null;
        }
        public String mostrarProcesosOrdenManufacturaAction()
        {
            DaoComponentesProdProcesoOrdenManufactura daoProcesos = new DaoComponentesProdProcesoOrdenManufactura(LOGGER);
            componentesProdProcesoOrdenManufacturaList = daoProcesos.listar(componentesProdVersionSeleccionado);
            componentesProdProcesoOrdenManufacturaDisponibleList  = daoProcesos.listarNoUtilizado(componentesProdVersionSeleccionado);
            return null;
        }
        public String guardarComponentesProdProceosOrdenManufacturaAction()throws SQLException
        {
            transaccionExitosa = false;
            DaoComponentesProdProcesoOrdenManufactura daoProceso = new DaoComponentesProdProcesoOrdenManufactura(LOGGER);
            if(daoProceso.guardarLista(componentesProdProcesoOrdenManufacturaList, componentesProdVersionSeleccionado.getCodVersion())){
                this.mostrarMensajeTransaccionExitosa("Se registro satisfactoriamente los procesos configurados");
            }
            else{
                this.mostrarMensajeTransaccionFallida("Ocurrio un error al momento de registrar los pasos configurados, intente de nuevo");
            }
            return null;
        }
    //</editor-fold>
    //<editor-fold defaultstate="collapsed" desc="proceso preparado producto">
        public String editarSubProcesosPreparadoProductoAction()throws SQLException
        {
            DaoProcesosPreparadoProducto daoProcesos = new DaoProcesosPreparadoProducto(LOGGER);
            procesosPreparadoProducto.setProcesoSecuencial(procesosPreparadoProducto.getProcesosPreparadoProductoDestino().getCodProcesoPreparadoProducto() == 0);
            List<ProcesosPreparadoProductoMaquinaria> procesoMaquinariaList = new ArrayList<>();
            for(ProcesosPreparadoProductoMaquinaria bean : procesosPreparadoProducto.getProcesosPreparadoProductoMaquinariaList()){
                if(bean.getChecked()){
                    procesoMaquinariaList.add(bean);
                }
            }
            procesosPreparadoProducto.setProcesosPreparadoProductoMaquinariaList(procesoMaquinariaList);
            if(daoProcesos.editar(procesosPreparadoProducto)){
                this.mostrarMensajeTransaccionExitosa("Se registro satisfactoriamente la edicion del paso de preparado");
            }
            else{
                this.mostrarMensajeTransaccionFallida("Ocurrio un error al momento de registrar la edicion del paso de preparado, intente de nuevo");
            }
            return null;
        }
        public String getCargarEdicionSubProcesosPreparadoProducto()
        {
            this.cargarProcesosPreparadoDestinoSelectList();
            this.cargarActividadesPreparadoSelectList();
            DaoProcesosPreparadoProductoMaquinaria daoMaquinaria = new DaoProcesosPreparadoProductoMaquinaria(LOGGER);
            procesosPreparadoProducto.setProcesosPreparadoProductoMaquinariaList(daoMaquinaria.listarEditar(procesosPreparadoProducto));
            if(procesosPreparadoProducto.getProcesosPreparadoProductoDestino() == null)
                procesosPreparadoProducto.setProcesosPreparadoProductoDestino(new ProcesosPreparadoProducto());
            return null;
        }
        private void cargarProcesosPreparadoDestinoSelectList()
        {
            try {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select ppp.COD_PROCESO_PREPARADO_PRODUCTO,cast(ppp.NRO_PASO as varchar)+' - '+ap.NOMBRE_ACTIVIDAD_PREPARADO as actividad");
                                            consulta.append(" from PROCESOS_PREPARADO_PRODUCTO ppp ");
                                            consulta.append(" inner join ACTIVIDADES_PREPARADO ap on ap.COD_ACTIVIDAD_PREPARADO=ppp.COD_ACTIVIDAD_PREPARADO");
                                            consulta.append(" where ppp.COD_PROCESO_PREPARADO_PRODUCTO_PADRE=0");
                                            consulta.append(" and ppp.COD_VERSION=").append(componentesProdVersionSeleccionado.getCodVersion());
                                            consulta.append(" and ppp.COD_PROCESO_ORDEN_MANUFACTURA=").append(procesosPreparadoProductoBean.getProcesosOrdenManufactura().getCodProcesoOrdenManufactura());
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
        public String getCargarAgregarSubProcesosPreparadoProducto()
        {
            this.cargarProcesosPreparadoDestinoSelectList();
            procesosPreparadoProducto = new ProcesosPreparadoProducto();
            procesosPreparadoProducto.setProcesosPreparadoProductoDestino(new ProcesosPreparadoProducto());
            procesosPreparadoProducto.setComponentesProdVersion(componentesProdVersionSeleccionado);
            procesosPreparadoProducto.setProcesosOrdenManufactura(procesosPreparadoProductoBean.getProcesosOrdenManufactura());
            procesosPreparadoProducto.setProcesosPreparadoProductoPadre(procesosPreparadoProductoBeanSubProceso);
            this.cargarActividadesPreparadoSelectList();
            DaoProcesosPreparadoProductoMaquinaria daoMaquinaria = new DaoProcesosPreparadoProductoMaquinaria(LOGGER);
            procesosPreparadoProducto.setProcesosPreparadoProductoMaquinariaList(daoMaquinaria.listarAgregar());
            return null;
        }
        private void cargarSubProcesosPreparadoProducto()
        {
            DaoProcesosPreparadoProducto daoProcesosPreparadoProducto = new DaoProcesosPreparadoProducto(LOGGER);
            ProcesosPreparadoProducto procesoBean = new ProcesosPreparadoProducto();
            procesoBean.setProcesosPreparadoProductoPadre(procesosPreparadoProductoBeanSubProceso);
            procesoBean.setProcesosOrdenManufactura(procesosPreparadoProductoBean.getProcesosOrdenManufactura());
            procesoBean.setComponentesProdVersion(componentesProdVersionSeleccionado);
            this.subProcesosPreparadoProductoList = daoProcesosPreparadoProducto.listar(procesoBean);
        }
        public String getCargarSubProcesosPreparadoProducto()
        {
            this.cargarSubProcesosPreparadoProducto();
            return null;
        }
        public String guardarSubProcesosPreparadoProductoAction()throws SQLException
        {
            if(procesosPreparadoProducto.getProcesosPreparadoProductoDestino().getCodProcesoPreparadoProducto()==0)
                procesosPreparadoProducto.setSustanciaResultante("");
            procesosPreparadoProducto.setProcesoSecuencial(procesosPreparadoProducto.getProcesosPreparadoProductoDestino().getCodProcesoPreparadoProducto() == 0);
            List<ProcesosPreparadoProductoMaquinaria> procesoMaquinariaList = new ArrayList<>();
            for(ProcesosPreparadoProductoMaquinaria bean : procesosPreparadoProducto.getProcesosPreparadoProductoMaquinariaList()){
                if(bean.getChecked()){
                    procesoMaquinariaList.add(bean);
                }
            }
            procesosPreparadoProducto.setProcesosPreparadoProductoMaquinariaList(procesoMaquinariaList);
            DaoProcesosPreparadoProducto daoProcesosPreparado = new DaoProcesosPreparadoProducto(LOGGER);
            if(daoProcesosPreparado.guardar(procesosPreparadoProducto)){
                this.mostrarMensajeTransaccionExitosa("Se registro satisfactoriamente el sub proceso");
            }
            else{
                this.mostrarMensajeTransaccionFallida("Ocurrio un error el momento de registrar el sub proceso");
            }
            return null;
        }
        
        private void cargarProcesosOrdenManufacturaEspMaquinariaList()
        {
            DaoProcesosOrdenManufactura daoProcesosOm = new DaoProcesosOrdenManufactura(LOGGER);
            procesosOrdenManufacturaList = daoProcesosOm.listarHabilitadosEspecificacionesMaquinaria(componentesProdVersionSeleccionado);
        }
        
        private void cargarProcesosOrdenManufacturaList()
        {
            DaoProcesosOrdenManufactura daoProcesosOm = new DaoProcesosOrdenManufactura(LOGGER);
            procesosOrdenManufacturaList = daoProcesosOm.listarHabilitadosPreparado(componentesProdVersionSeleccionado);
        }
        public String seleccionarProcesoOrdenManufactura()
        {
            this.cargarProcesosPreparadoProducto();
            return null;
        }
        public String getCargarProcesosPreparaProductoList(){
            this.cargarProcesosOrdenManufacturaList();
            this.cargarProcesosPreparadoProducto();
            this.cargarTiposDescripcionSelectList();
            this.cargarUnidadesMedidaGeneralSelectList();
            return null;
        }
        private void cargarProcesosPreparadoProducto(){
            ProcesosOrdenManufactura procesoOm = procesosPreparadoProductoBean.getProcesosOrdenManufactura();
            procesosPreparadoProductoBean = new ProcesosPreparadoProducto();
            procesosPreparadoProductoBean.setProcesosOrdenManufactura(procesoOm);
            procesosPreparadoProductoBean.setComponentesProdVersion(componentesProdVersionSeleccionado);
            DaoProcesosPreparadoProducto daoProceso = new DaoProcesosPreparadoProducto(LOGGER);
            procesosPreparadoProductoList = daoProceso.listar(procesosPreparadoProductoBean);
        }
        public String eliminarSubProcesosPreparadoProductoAction(int codProcesoPreparado)throws SQLException
        {
            transaccionExitosa = false;
            DaoProcesosPreparadoProducto daoProcesosPreparadoProducto = new DaoProcesosPreparadoProducto(LOGGER);
            if(daoProcesosPreparadoProducto.eliminar(codProcesoPreparado)){
                this.mostrarMensajeTransaccionExitosa("El proceso se elimino satisfactoriamente");
            }else{
                this.mostrarMensajeTransaccionFallida("Ocurrio un error al momento de eliminar el proceso");
            }
            if(transaccionExitosa){
                this.cargarSubProcesosPreparadoProducto();
            }
            return null;
        }
        public String eliminarProcesosPreparadoProductoAction(int codProcesoPreparado)throws SQLException
        {
            transaccionExitosa = false;
            DaoProcesosPreparadoProducto daoProcesosPreparadoProducto = new DaoProcesosPreparadoProducto(LOGGER);
            if(daoProcesosPreparadoProducto.eliminar(codProcesoPreparado)){
                this.mostrarMensajeTransaccionExitosa("El proceso se elimino satisfactoriamente");
            }else{
                this.mostrarMensajeTransaccionFallida("Ocurrio un error al momento de eliminar el proceso");
            }
            if(transaccionExitosa){
                this.cargarProcesosPreparadoProducto();
            }
            return null;
        }
        public String seleccionarProcesoPreparadoConsumoAction(){
            
            DaoProcesosPreparadoProductoConsumo daoConsumo = new DaoProcesosPreparadoProductoConsumo(LOGGER);
            procesosPreparadoProducto.setComponentesProdVersion(componentesProdVersionSeleccionado);
            procesosPreparadoProducto.setProcesosPreparadoProductoConsumoList(daoConsumo.listar(procesosPreparadoProducto));
            procesosPreparadoProductoConsumoDisponibleList = daoConsumo.listarNoUtilizado(procesosPreparadoProducto);
            return null;
        }
        public Boolean getSustanciaResultanteHabilitada()
        {
            boolean sustanciaResultanteHabilitada=true;
            if(this.procesosPreparadoProducto.getProcesosPreparadoProductoConsumoList() != null && this.procesosPreparadoProducto.getProcesosPreparadoProductoConsumoList().size()>0)
            {
                for(ProcesosPreparadoProductoConsumo bean : procesosPreparadoProducto.getProcesosPreparadoProductoConsumoList())
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
        public String agregarProcesoPreparadoProductoConsumoMaterialSeleccionado(ProcesosPreparadoProductoConsumo bean,boolean materialTransitorio)
        {
            bean.setMaterialTransitorio(materialTransitorio);
            procesosPreparadoProductoConsumoDisponibleList.remove(bean);
            procesosPreparadoProducto.getProcesosPreparadoProductoConsumoList().add(bean);
            return null;
        }
        public String adicionarOrdenConsumoMaterialSeleccionado(int index,int paso)
        {
            ProcesosPreparadoProductoConsumo procesoSeleccionado = procesosPreparadoProducto.getProcesosPreparadoProductoConsumoList().get(index);
            ProcesosPreparadoProductoConsumo procesoCambio = procesosPreparadoProducto.getProcesosPreparadoProductoConsumoList().get(index+(paso));
            procesosPreparadoProducto.getProcesosPreparadoProductoConsumoList().set(index, procesoCambio);
            procesosPreparadoProducto.getProcesosPreparadoProductoConsumoList().set(index+(paso), procesoSeleccionado);
            return null;
        }
        public String eliminarProcesoPreparadoProductoConsumoMaterialSeleccionado(ProcesosPreparadoProductoConsumo bean)
        {
            procesosPreparadoProductoConsumoDisponibleList.add(bean);
            procesosPreparadoProducto.getProcesosPreparadoProductoConsumoList().remove(bean);
            return null;
        }
        private void cargarActividadesPreparadoSelectList()
        {
            DaoActividadesPreparado daoActividadesPreparado = new DaoActividadesPreparado(LOGGER);
            actividadesPreparadoSelectList = daoActividadesPreparado.listarSelectItem();
        }
        public String guardarProcesoPreparadoProductoConsumoAction()throws SQLException
        {
            mensaje = "";
            if(!this.getSustanciaResultanteHabilitada())procesosPreparadoProducto.setSustanciaResultante("");
            procesosPreparadoProducto.setProcesosPreparadoProductoMaquinariaList(null);
            DaoProcesosPreparadoProducto daoProcesosPreparadoProducto = new DaoProcesosPreparadoProducto(LOGGER);
            if(daoProcesosPreparadoProducto.editar(procesosPreparadoProducto)){
                this.mostrarMensajeTransaccionExitosa("Se registraron satisfactoriamente los materiales");
            }
            else{
                this.mostrarMensajeTransaccionFallida("Ocurrio un error al momento de registrar los materiales");
            }
            return null;
        }
        public String getCargarAgregarProcesosPreparadoProducto(){
            
            this.cargarActividadesPreparadoSelectList();
            procesosPreparadoProducto = new ProcesosPreparadoProducto();
            procesosPreparadoProducto.setComponentesProdVersion(componentesProdVersionSeleccionado);
            procesosPreparadoProducto.setProcesosOrdenManufactura(procesosPreparadoProductoBean.getProcesosOrdenManufactura());
            procesosPreparadoProducto.setProcesoSecuencial(true);
           
            // <editor-fold defaultstate="collapsed" desc="inicializando lista de maquinarias">
                DaoProcesosPreparadoProductoMaquinaria daoMaquinaria = new DaoProcesosPreparadoProductoMaquinaria(LOGGER);
                procesosPreparadoProducto.setProcesosPreparadoProductoMaquinariaList(daoMaquinaria.listarAgregar());
            //</editor-fold>
            return null;
        }
        public String guardarProcesosPreparadoProductoAction()throws SQLException{
            
            transaccionExitosa = false;
            DaoProcesosPreparadoProducto daoProcesoPreparado = new DaoProcesosPreparadoProducto(LOGGER);
            List<ProcesosPreparadoProductoMaquinaria> maquinariasAgregarList = new ArrayList<>();
            for(ProcesosPreparadoProductoMaquinaria bean : procesosPreparadoProducto.getProcesosPreparadoProductoMaquinariaList()){
                if(bean.getChecked()){
                    maquinariasAgregarList.add(bean);
                }
            }
            procesosPreparadoProducto.setProcesosPreparadoProductoMaquinariaList(maquinariasAgregarList);
            if(daoProcesoPreparado.guardar(procesosPreparadoProducto)){
                this.mostrarMensajeTransaccionExitosa("Se registro satisfactoriamente el paso de preparado");
            }
            else{
                this.mostrarMensajeTransaccionFallida("Ocurrio un error al momento de registrar el paso de preparado, intente de nuevo");
            }
            return null;
        }
        public String getCargarEdicionProcesosPreparadoProducto()
        {
            this.cargarActividadesPreparadoSelectList();
            DaoProcesosPreparadoProductoMaquinaria daoMaquinaria = new DaoProcesosPreparadoProductoMaquinaria(LOGGER);
            procesosPreparadoProducto.setProcesosPreparadoProductoMaquinariaList(daoMaquinaria.listarEditar(procesosPreparadoProducto));
            return null;
        }
        public String editarProcesosPreparadoProductoAction()throws SQLException
        {
            transaccionExitosa = false;
            DaoProcesosPreparadoProducto daoProcesosPreparado = new DaoProcesosPreparadoProducto(LOGGER);
            List<ProcesosPreparadoProductoMaquinaria> procesoMaquinariaList = new ArrayList<>();
            for(ProcesosPreparadoProductoMaquinaria bean : procesosPreparadoProducto.getProcesosPreparadoProductoMaquinariaList()){
                if(bean.getChecked()){
                    procesoMaquinariaList.add(bean);
                }
            }
            procesosPreparadoProducto.setProcesosPreparadoProductoMaquinariaList(procesoMaquinariaList);
            if(daoProcesosPreparado.editar(procesosPreparadoProducto)){
                this.mostrarMensajeTransaccionExitosa("Se registro satisfactoriamente la edición del proceso de preparado");
            }else{
                this.mostrarMensajeTransaccionFallida("Ocurrio un error al momento de editar el proceso de preparado, intente de nuevo");
            }
            return null;
        }
        
        public String  mostrarProcesosPreparadoProductoEspecificacionesMaquinariaAction()
        {
            procesosPreparadoProductoMaquinaria.setProcesosPreparadoProducto(procesosPreparadoProducto);
            DaoProcesosPreparadoProductoEspecificacionesMaquinaria daoEspMaquinaria = new DaoProcesosPreparadoProductoEspecificacionesMaquinaria(LOGGER);
            procesosPreparadoProductoMaquinaria.setProcesosPreparadoProductoEspecificacionesMaquinariaList(daoEspMaquinaria.listarEditar(procesosPreparadoProductoMaquinaria));
            return null;

        }
        private void cargarTiposDescripcionSelectList()
        {
            DaoTiposDescripcion daoTiposDescripcion = new DaoTiposDescripcion(LOGGER);
            tiposDescripcionSelectList  = daoTiposDescripcion.listarSelectItem();
        }
        public String guardarProcesosPreparadoProductoEspecificacionesMaquinariaAction()throws SQLException
        {
            DaoProcesosPreparadoProductoEspecificacionesMaquinaria daoEspMaquinaria = new DaoProcesosPreparadoProductoEspecificacionesMaquinaria(LOGGER);
            List<ProcesosPreparadoProductoEspecificacionesMaquinaria> espMaquinariaList = new ArrayList<>();
            for(ProcesosPreparadoProductoEspecificacionesMaquinaria bean : procesosPreparadoProductoMaquinaria.getProcesosPreparadoProductoEspecificacionesMaquinariaList()){
                if(bean.getChecked()){
                    espMaquinariaList.add(bean);
                }
            }
            procesosPreparadoProductoMaquinaria.setProcesosPreparadoProductoEspecificacionesMaquinariaList(espMaquinariaList);
            if(daoEspMaquinaria.guardarDetalle(procesosPreparadoProductoMaquinaria)){
                this.mostrarMensajeTransaccionExitosa("Se registraron satisfactoriamente las especificaciones de maquinaria");
            }
            else{
                this.mostrarMensajeTransaccionFallida("Ocurrio un error al momento de registrar las especficaciones de maquinaria");
            }
            return null;
        }
        private void cargarUnidadesMedidaGeneralSelectList()
        {
            DaoUnidadesMedida daoUnidadMedida = new DaoUnidadesMedida(LOGGER);
            unidadesMedidaSelectList = daoUnidadMedida.listarSelectItem();
        }
    //</editor-fold>
        
    //<editor-fold defaultstate="collapsed" desc="especificaciones maquinaria">
        
        public String editarComponentesProdVersionMaquinariaProcesoAction()throws SQLException
        {
            transaccionExitosa = false;
            DaoComponentesProdVersionMaquinariaProceso daoMaquinariaProceso = new DaoComponentesProdVersionMaquinariaProceso(LOGGER);
            List<EspecificacionesProcesosProductoMaquinaria> especificacionesList = new ArrayList<>();
            for(EspecificacionesProcesosProductoMaquinaria bean :  componentesProdVersionMaquinariaProceso.getEspecificacionesProcesosProductoMaquinariaList()){
                if(bean.getChecked()){
                    especificacionesList.add(bean);
                }
            }
            componentesProdVersionMaquinariaProceso.setEspecificacionesProcesosProductoMaquinariaList(especificacionesList);
            if(daoMaquinariaProceso.editar(componentesProdVersionMaquinariaProceso)){
                this.mostrarMensajeTransaccionExitosa("Se editaron satisfactoriamante las especificaciones");
            }
            else{
                this.mostrarMensajeTransaccionFallida("Ocurrio un error al momento de editar las especificaciones,intente de nuevo");
            }
            return null;
        }
        
        public String getCargarEditarEspecificacionesMaquinariaProcesoProducto()
        {
            this.cargarUnidadesMedidaGeneralSelectList();
            this.cargarTiposDescripcionSelectList();
            DaoEspecificacionesProcesosProductoMaquinaria daoEspMaquinaria = new DaoEspecificacionesProcesosProductoMaquinaria(LOGGER);
            componentesProdVersionMaquinariaProceso.setEspecificacionesProcesosProductoMaquinariaList(daoEspMaquinaria.listarEditar(componentesProdVersionMaquinariaProceso));
            return null;
        }
        public String seleccionarProcesosOrdenManufacturaEspMaquinariaAction(){
            this.cargarComponentesProdVersionMaquinariaProceso();
            return null;
        }
        private void cargarMaquinariasAgregarEspecificaciones()
        {
            DaoComponentesProdVersionMaquinariaProceso daoMaquinaria = new DaoComponentesProdVersionMaquinariaProceso(LOGGER);
            maquinariasSelectList = daoMaquinaria.listarSelectMaquinariaNoUtilizada(componentesProdVersionMaquinariaProcesoBean);
        }
        public String getCargarAgregarEspecificacionesMaquinariaProcesoProducto()
        {
            componentesProdVersionMaquinariaProceso = new ComponentesProdVersionMaquinariaProceso();
            componentesProdVersionMaquinariaProceso.setComponentesProdVersion(componentesProdVersionMaquinariaProcesoBean.getComponentesProdVersion());
            componentesProdVersionMaquinariaProceso.setProcesosOrdenManufactura(componentesProdVersionMaquinariaProcesoBean.getProcesosOrdenManufactura());
            this.cargarUnidadesMedidaGeneralSelectList();
            this.cargarMaquinariasAgregarEspecificaciones();
            componentesProdVersionMaquinariaProceso.getMaquinaria().setCodMaquina(maquinariasSelectList.get(0).getValue().toString());
            this.cargarAgregarEspecificacionesMaquinariaProcesoProducto();
            this.cargarTiposDescripcionSelectList();
            return null;
        }
        public String codCompProdVersionMaquinariaProceso_action()
        {
            this.cargarAgregarEspecificacionesMaquinariaProcesoProducto();
            return null;
        }
        private void cargarAgregarEspecificacionesMaquinariaProcesoProducto()
        {
            DaoEspecificacionesProcesosProductoMaquinaria daoEspMaquinaria = new DaoEspecificacionesProcesosProductoMaquinaria(LOGGER);
            componentesProdVersionMaquinariaProcesoBean.setEspecificacionesProcesosProductoMaquinariaList(daoEspMaquinaria.listarAgregarPorRecetaMaquinaria(componentesProdVersionMaquinariaProceso));
        }
        public String guardarComponentesProdVersionMaquinariaProcesoAction()throws SQLException
        {
            transaccionExitosa = false;
            DaoComponentesProdVersionMaquinariaProceso daoMaquinariaProceso = new DaoComponentesProdVersionMaquinariaProceso(LOGGER);
            List<EspecificacionesProcesosProductoMaquinaria> especificacionesRegistrarList = new ArrayList<>();
            for(EspecificacionesProcesosProductoMaquinaria bean :  componentesProdVersionMaquinariaProcesoBean.getEspecificacionesProcesosProductoMaquinariaList()){
                if(bean.getChecked()){
                    especificacionesRegistrarList.add(bean);
                }
            }
            componentesProdVersionMaquinariaProcesoBean.setEspecificacionesProcesosProductoMaquinariaList(especificacionesRegistrarList);
            if(daoMaquinariaProceso.guardar(componentesProdVersionMaquinariaProcesoBean)){
                this.mostrarMensajeTransaccionExitosa("Se registraron satisfactoriamante las especificaciones");
            }
            else{
                this.mostrarMensajeTransaccionFallida("Ocurrio un error al momento de registrar las especificaciones,intente de nuevo");
            }

            return null;
        }
        public String eliminarComponentesProdVersionMaquinariaProcesoAction(int codCompprodVesionMaquinariaProceso)throws SQLException
        {
            transaccionExitosa = true;
            DaoComponentesProdVersionMaquinariaProceso daoMaquinariaProceso = new DaoComponentesProdVersionMaquinariaProceso(LOGGER);
            if(daoMaquinariaProceso.eliminar(codCompprodVesionMaquinariaProceso)){
                this.mostrarMensajeTransaccionExitosa("Se eliminaron satisfactoriamente las especificaciones de la maquinaria");
            }else{
                this.mostrarMensajeTransaccionFallida("Ocurrio un error al momento de eliminar las especificaciones de la maquinaria, intente de nuevo");
            }
            if(transaccionExitosa)
                this.cargarComponentesProdVersionMaquinariaProceso();
            return null;
        }
        
        public String getCargarComponentesProdVersionMaquinariaProceso(){
            this.cargarComponentesProdVersionMaquinariaProceso();
            this.cargarUnidadesMedidaGeneralSelectList();
            this.cargarProcesosOrdenManufacturaEspMaquinariaList();
            return null;
        }
    
        private void cargarComponentesProdVersionMaquinariaProceso() 
        {
            componentesProdVersionMaquinariaProcesoBean.setComponentesProdVersion(componentesProdVersionSeleccionado);
            DaoEspecificacionesProcesosProductoMaquinaria daoMaquinaria = new DaoEspecificacionesProcesosProductoMaquinaria(LOGGER);
            componentesProdVersionMaquinariaProcesoList = daoMaquinaria.listarPorMaquinaria(componentesProdVersionMaquinariaProcesoBean);
        }
    //</editor-fold>
        
    //<editor-fold defaultstate="collapsed" desc="especificaciones de proceso">
        public String agregarComponentesProdVersionEspecificacionesProcesoAction()
        {
            componentesProdVersionEspecificacionProceso = new ComponentesProdVersionEspecificacionProceso();
            return null;
        }
        public String eliminarComponentesProdVersionEspecificacionProcesoAction(int codProcesoOrdenManufactura)throws SQLException
        {
            transaccionExitosa=false;
            DaoComponentesProdVersionEspecificacionProceso daoEspProceso = new DaoComponentesProdVersionEspecificacionProceso(LOGGER);
            if(daoEspProceso.eliminar(componentesProdVersionSeleccionado.getCodVersion(), codProcesoOrdenManufactura)){
                this.mostrarMensajeTransaccionExitosa("Se eliminaron las especificaciones del proceso");
            } 
            else{
                this.mostrarMensajeTransaccionExitosa("Ocurrio un error al momento de eliminaron las especificaciones del proceso");
            } 
            if(transaccionExitosa)
            {
                this.cargarComponentesProdVersionEspecificacionesProcesos();
            }
            return null;
        }
        public String getCargarComponentesProdVersionEspecificacionesProceso(){
            this.cargarComponentesProdVersionEspecificacionesProcesos();
            return null;
        }
        private void cargarComponentesProdVersionEspecificacionesProcesos()
        {
            DaoComponentesProdVersionEspecificacionProceso daoEspProceso = new DaoComponentesProdVersionEspecificacionProceso(LOGGER);
            componentesProdVersionEspecificacionProcesoList = daoEspProceso.listarPorProcesosOm(componentesProdVersionSeleccionado);
        }
        private void cargarProcesosOrdenManufacturaEspecificionesSelect()
        {
            DaoProcesosOrdenManufactura daoProcesos = new DaoProcesosOrdenManufactura(LOGGER);
            procesosOrdenManufacturaSelectList = daoProcesos.listarSelectNoUtilizadosEspProceso(componentesProdVersionSeleccionado);
        }
        private void cargarAgregarEditarEspecificacionesProcesos()
        {
            DaoComponentesProdVersionEspecificacionProceso daoEspecificacion = new DaoComponentesProdVersionEspecificacionProceso(LOGGER);
            componentesProdVersionEspecificacionProceso.getProcesosOrdenManufactura().setComponentesProdVersionEspecificacionProcesoList(daoEspecificacion.listarEditar(componentesProdVersionSeleccionado.getCodVersion(), componentesProdVersionEspecificacionProceso.getProcesosOrdenManufactura().getCodProcesoOrdenManufactura()));
        }
        public String getCargarAgregarModificarProcesoOmEspecificacion(){
            this.cargarProcesosOrdenManufacturaEspecificionesSelect();
            this.cargarTiposDescripcionSelectList();
            this.cargarUnidadesMedidaGeneralSelectList();
            this.cargarAgregarEditarEspecificacionesProcesos();
            return null;
        }
        public String guardarModificarEspecificacionesProcesosAction()throws SQLException{
            
            transaccionExitosa=false;
            DaoComponentesProdVersionEspecificacionProceso daoEspProceso = new DaoComponentesProdVersionEspecificacionProceso(LOGGER);
            List<ComponentesProdVersionEspecificacionProceso> especificacionesList = new ArrayList<>();
            for(ComponentesProdVersionEspecificacionProceso bean : componentesProdVersionEspecificacionProceso.getProcesosOrdenManufactura().getComponentesProdVersionEspecificacionProcesoList()){
                if(bean.getChecked()){
                  especificacionesList.add(bean);
                }
            }
            if(daoEspProceso.eliminarGuardarLista(especificacionesList,componentesProdVersionSeleccionado.getCodVersion(),componentesProdVersionEspecificacionProceso.getProcesosOrdenManufactura().getCodProcesoOrdenManufactura())){
                this.mostrarMensajeTransaccionExitosa("Se registraron satisfactoriamente las especificaciones");
            }
            else{
                this.mostrarMensajeTransaccionFallida(" Ocurrio un error al momento de guardar las especificaciones");
            }
            return null;
        }
    //</editor-fold>
        
    //<editor-fold desc="formula maestra detalle ep">
        public String getCargarFormulaMaestraDetalleEp(){
            DaoFormulaMaestraDetalleEpVersion daoFmEp = new DaoFormulaMaestraDetalleEpVersion(LOGGER);
            formulaMaestraEPList = daoFmEp.listarPorPresentacionPrimaria(formulaMaestraVersionSeleccionado);
            return null;
        }
        private void cargarEnvasesPrimariosSelectList()
        {
            DaoEnvasesPrimarios daoEnvases = new DaoEnvasesPrimarios(LOGGER);
            envasesPrimariosSelectList = daoEnvases.listarSelectItem();
        }
        private void cargarTiposProgramaProduccionSelectList()
        {
            DaoTiposProgramaProduccion daoTipo = new DaoTiposProgramaProduccion();
            tiposProgramaProduccionSelectList = daoTipo.listarSelectItem();
        }
        public String getCargarAgregarFormulaMaestraDetallaEp()
        {
            this.cargarEnvasesPrimariosSelectList();
            this.cargarTiposProgramaProduccionSelectList();
            presentacionesPrimarias = new PresentacionesPrimarias();
            DaoFormulaMaestraDetalleEpVersion daoFmEp = new DaoFormulaMaestraDetalleEpVersion(LOGGER);
            presentacionesPrimarias.setFormulaMaestraDetalleEPList(daoFmEp.listarAgregar());
            return null;
        }
        public String guardarPresentacionPrimariaAction()throws SQLException
        {
            mensaje = "";
            DaoPresentacionesPrimariasVersion daoPresentacionPrimaria  = new DaoPresentacionesPrimariasVersion(LOGGER);
            presentacionesPrimarias.setComponentesProd(formulaMaestraVersionSeleccionado.getComponentesProd());
            if(daoPresentacionPrimaria.guardarConDetalleEp(presentacionesPrimarias, formulaMaestraVersionSeleccionado))
            {
                this.actualizarFormulaMaestraVersionSeleccionado();
                mensaje = "1";
            }
            else
            {
                mensaje = "Ocurrio un error al momento de guardar el registro";
            }
            return null;
        }
       
        public String getCargarEditarPresentacionPrimaria()
        {
            this.cargarEnvasesPrimariosSelectList();
            this.cargarTiposProgramaProduccionSelectList();
            DaoFormulaMaestraDetalleEpVersion daoFmEp = new DaoFormulaMaestraDetalleEpVersion();
            presentacionesPrimarias.setFormulaMaestraDetalleEPList(daoFmEp.listarEditar(presentacionesPrimarias, formulaMaestraVersionSeleccionado));
            return null;
        }
        public String editarFormulaMaestraDetalleEpAction()throws SQLException
        {
            DaoPresentacionesPrimariasVersion daoPresentacionPrimaria = new DaoPresentacionesPrimariasVersion(LOGGER);
            List<FormulaMaestraDetalleEP> detalleEpList= new ArrayList<>();
            for(FormulaMaestraDetalleEP bean : presentacionesPrimarias.getFormulaMaestraDetalleEPList())
            {
                if(bean.getChecked())detalleEpList.add(bean);
            }
            presentacionesPrimarias.setFormulaMaestraDetalleEPList(detalleEpList);
            if(daoPresentacionPrimaria.editarConDetalleEp(presentacionesPrimarias, formulaMaestraVersionSeleccionado))
            {
                mensaje = "1";
                this.actualizarFormulaMaestraVersionSeleccionado();
            }
            else
            {
                mensaje = "Ocurrio un error al momento de guardar el registro,verifique los datos introducidos";
            }
            return null;
        }
        public String eliminarPresentacionPrimariaAction()throws SQLException
        {
            mensaje="";
            DaoPresentacionesPrimariasVersion daoFmEp = new DaoPresentacionesPrimariasVersion(LOGGER);
            presentacionesPrimarias.setComponentesProd(formulaMaestraVersionSeleccionado.getComponentesProd());
            if(daoFmEp.eliminarConDetalleEp(presentacionesPrimarias, formulaMaestraVersionSeleccionado))
            {
                mensaje = "1";
                this.getCargarFormulaMaestraDetalleEp();
                this.actualizarFormulaMaestraVersionSeleccionado();
            }
            else
            {
                mensaje = "Ocurrio un error al momento de eliminar la presentación primaria, intente de nuevo";
            }
            return null;
        }
    //</editor-fold>
    //<editor-fold desc="formula maestra detalle es">
        public String seleccionarFormulaMaestraEsVersionAction()
        {
            try {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select fmev.COD_FORMULA_MAESTRA_ES_VERSION")
                                                    .append(" from FORMULA_MAESTRA_ES_VERSION fmev")
                                                    .append(" where fmev.COD_VERSION = ").append(formulaMaestraEsVersionSeleccionado.getComponentesProdVersion().getCodVersion());
                LOGGER.debug("consulta obtener codigo de version  "+consulta.toString());
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                while (res.next()) {
                    formulaMaestraEsVersionSeleccionado.setCodFormulaMaestraEsVersion(res.getInt("COD_FORMULA_MAESTRA_ES_VERSION"));
                }
                consulta = new StringBuilder("select f.COD_FORMA,f.DEFINE_LOTE_ES ")
                                    .append(" from FORMAS_FARMACEUTICAS_LOTE f")
                                    .append(" where f.COD_FORMA =").append(formulaMaestraEsVersionSeleccionado.getComponentesProdVersion().getForma().getCodForma());
                LOGGER.debug("consulta verificar lote es definre "+consulta.toString());
                res = st.executeQuery(consulta.toString());
                defineLoteEs = false;
                if(res.next())
                {
                    defineLoteEs = res.getInt("DEFINE_LOTE_ES") > 0;
                }
            } catch (SQLException ex) {
                LOGGER.warn(ex.getMessage());
            } catch (NumberFormatException ex) {
                LOGGER.warn(ex.getMessage());
            } finally {
                this.cerrarConexion(con);
            }
            return null;
        }
       
        private void aprobarVersionEsDesarrollo()
        {
            if(formulaMaestraEsVersionSeleccionado.getComponentesProdVersion().getEstadosVersionComponentesProd().getCodEstadoVersionComponenteProd() == COD_ESTADO_VERSION_APROBADA){
                try 
                {
                    con = Util.openConnection(con);
                    con.setAutoCommit(false);
                    StringBuilder consulta=new StringBuilder("exec PAA_APROBACION_FORMULA_MAESTRA_ES_VERSION ")
                                                        .append(formulaMaestraEsVersionSeleccionado.getCodFormulaMaestraEsVersion()).append(",")
                                                        .append(formulaMaestraEsVersionSeleccionado.getComponentesProdVersion().getCodVersion()).append(",")
                                                        .append(formulaMaestraEsVersionSeleccionado.getComponentesProdVersion().getCodCompprod()).append(",")
                                                        .append(formulaMaestraEsVersionSeleccionado.getComponentesProdVersion().getCodFormulaMaestra());
                    LOGGER.debug("consulta actualizar version es "+consulta.toString());
                    PreparedStatement pst=con.prepareStatement(consulta.toString());
                    if(pst.executeUpdate()>0)LOGGER.info("se actualizo la desviacion");
                    con.commit();
                    mensaje="1";
                    pst.close();
                } 
                catch (SQLException ex) 
                {
                    this.mostrarMensajeTransaccionFallida("Ocurrio un error de datos al momento de guardar la desviacion, verifique la información e intente de nuevo");
                    LOGGER.warn(ex.getMessage());
                    this.rollbackConexion(con);
                }
                catch (NumberFormatException ex) 
                {
                    this.mostrarMensajeTransaccionFallida("Ocurrio un error de datos al momento de guardar la desviacion, verifique la información e intente de nuevo");
                    LOGGER.warn(ex.getMessage());
                    this.rollbackConexion(con);
                }
                finally 
                {
                    this.cerrarConexion(con);
                }
            }
        }
        public String getCargarComponentesPresProdFormulaMaestraDetaleEs()
        {
            
            this.cargarComponentesPresProdFormulaMaestraDetaleEsList();
            return null;
        }
        private void cargarComponentesPresProdFormulaMaestraDetaleEsList()
        {
            DaoFormulaMaestraDetalleEsVersion daoFmEs = new DaoFormulaMaestraDetalleEsVersion(LOGGER);
            componentesPresProdList = daoFmEs.listarPorComponentesPresProd(formulaMaestraEsVersionSeleccionado);
        }
        private void cargarPresentacionesSelectList()
        {
            DaoPresentacionesProducto  daoPresentaciones = new DaoPresentacionesProducto();
            presentacionesSelectList = daoPresentaciones.listarPresentacionesProductoSelectList();
        }
        
        public String getCargarAgregarFormulaMaestraDetalleEs()
        {
            DaoFormulaMaestraDetalleEsVersion daoFmEs = new DaoFormulaMaestraDetalleEsVersion();
            componentesPresProdVersion = new ComponentesPresProdVersion();
            componentesPresProdVersion.setFormulaMaestraDetalleESList(daoFmEs.listarAgregar());
            this.cargarPresentacionesSelectList();
            this.cargarTiposProgramaProduccionSelectList();
            
            return null;
        }
                    
        public String guardarComponentesPresProdVersionAction()throws SQLException
        {
            DaoComponentesPresProdVersion daoComponentesPresProd  = new DaoComponentesPresProdVersion();
            List<FormulaMaestraDetalleES> listaRegistrarEs = new ArrayList<>();
            for(FormulaMaestraDetalleES bean : componentesPresProdVersion.getFormulaMaestraDetalleESList()){
                if(bean.getChecked()){
                    listaRegistrarEs.add(bean);
                }
            }
            componentesPresProdVersion.setFormulaMaestraDetalleESList(listaRegistrarEs);
            if(daoComponentesPresProd.guardarConDetalleEs(componentesPresProdVersion, formulaMaestraEsVersionSeleccionado))
            {
                mensaje = "1";
                this.aprobarVersionEsDesarrollo();
            }
            else
            {
                mensaje = "Ocurrio un error al momento de guardar el registro, intente de nuevo";
            }
            return null;
        }
        public String codPresentacionAgregar_change()
        {
            try 
            {
                con = Util.openConnection(con);
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                String consulta = "select p.cantidad_presentacion from PRESENTACIONES_PRODUCTO p" +
                                  " where p.cod_presentacion='"+componentesPresProdVersion.getPresentacionesProducto().getCodPresentacion()+"'";
                ResultSet res = st.executeQuery(consulta);
                while (res.next()) 
                {
                    componentesPresProdVersion.setCantCompProd(res.getFloat("cantidad_presentacion"));
                }
                res.close();
                st.close();
                con.close();
            } catch (SQLException ex) {
                LOGGER.warn("error", ex);
            }
            return null;
        }
        public String getCargarEditarComponentesPresProdVersionAction()
        {
            DaoFormulaMaestraDetalleEsVersion daoFmEs = new DaoFormulaMaestraDetalleEsVersion();
            componentesPresProdVersion.setFormulaMaestraDetalleESList(daoFmEs.listarEditar(componentesPresProdVersion, formulaMaestraEsVersionSeleccionado));
            return null;
        }
        public String editarComponentesPresProdVersionAction()throws SQLException
        {
            DaoComponentesPresProdVersion daoComponentesPres = new DaoComponentesPresProdVersion();
            if(daoComponentesPres.editarConDetalleEs(componentesPresProdVersion, formulaMaestraEsVersionSeleccionado))
            {
                this.aprobarVersionEsDesarrollo();
                mensaje = "1";
            }
            else
            {
                mensaje = "Ocurrio un error al momento de editar el registro, intente de nuevo";
            }
            return null;
        }
        public String eliminarComponentesPresProdVersionAction()throws SQLException
        {
            mensaje = "";
            DaoComponentesPresProdVersion daoComponentesPresProdVersion = new DaoComponentesPresProdVersion(LOGGER);
            componentesPresProdVersion.setFormulaMaestraEsVersion(formulaMaestraEsVersionSeleccionado);
            if(daoComponentesPresProdVersion.eliminar(componentesPresProdVersion)){
                this.aprobarVersionEsDesarrollo();
                mensaje = "1";
            }
            else{
                mensaje = "Ocurrio un error al momento de eliminar el registro, intente de nuevo";
            }
            
            if(mensaje.equals("1"))
            {
                this.cargarComponentesPresProdFormulaMaestraDetaleEsList();
            }
            return null;
        }
    //</editor-fold>
    //<editor-fold defaultstate="collapsed" desc="especificaciones de control de calidad">
        
        private void cargarTiposEspecificacionesFisicasSelect()
        {
            DaoTiposEspecificacionesFisicas  daoTiposEspFisicas = new DaoTiposEspecificacionesFisicas(LOGGER);
            tiposEspecificacionesFisicasSelect = new ArrayList<>();
            tiposEspecificacionesFisicasSelect.add(new SelectItem(0,"-NINGUNO-"));
            tiposEspecificacionesFisicasSelect.addAll(daoTiposEspFisicas.listarSelectItem());
        }
        private void cargarTiposRefenciasCcSelect()
        {   
            DaoTiposReferenciaCC daoTiposReferenciaCC = new DaoTiposReferenciaCC(LOGGER);
            tiposReferenciaCcSelect = daoTiposReferenciaCC.listarSelectItem();
        }
        public String getCargarEspecificacionesFisicasProducto()
        {
            this.cargarTiposEspecificacionesFisicasSelect();
            this.cargarTiposRefenciasCcSelect();
            DaoEspecificacionesFisicasProducto daoEspecificacionesFisicasProducto = new DaoEspecificacionesFisicasProducto(LOGGER);
            especificacionesFisicasProductoList = daoEspecificacionesFisicasProducto.listarAgregarEditar(componentesProdVersionSeleccionado);
            return null;
        }
        public String guardarEspecificacionesFisicasProductoAction()throws SQLException
        {
            mensaje = "";
            List<EspecificacionesFisicasProducto> especificacionesList = new ArrayList<>();
            for(EspecificacionesFisicasProducto bean : especificacionesFisicasProductoList)
            {
                if(bean.getChecked())
                {
                    especificacionesList.add(bean);
                }
            }
            LOGGER.debug("tamanio "+especificacionesList.size());
            DaoEspecificacionesFisicasProducto daoEspecificacionesFisicasProducto = new DaoEspecificacionesFisicasProducto(LOGGER);
            if(daoEspecificacionesFisicasProducto.guardarLista(especificacionesList))
            {
                mensaje  = "1";
            }
            else
            {
                mensaje = "Ocurrio un error al momento de guardar las especificaciones fisicas,intente de nuevo";
            }
            return null;
        }
        public String getCargarEspecificacionesMicrobiologicasProducto()
        {
            DaoEspecificacionesMicrobiologiaProducto daoEspMicro = new DaoEspecificacionesMicrobiologiaProducto(LOGGER);
            especificacionesMicrobiologiaProductoList = daoEspMicro.listarAgregarEditar(componentesProdVersionSeleccionado);
            this.cargarTiposRefenciasCcSelect();
            return null;
        }
        public String guardarEspecificacionesMicrobiologicasProductoAction()throws SQLException
        {
            mensaje="";
            List<EspecificacionesMicrobiologiaProducto> especificacionesList = new ArrayList<>();
            for(EspecificacionesMicrobiologiaProducto bean : especificacionesMicrobiologiaProductoList){
                if(bean.getChecked()){
                    especificacionesList.add(bean);
                }
            }
            DaoEspecificacionesMicrobiologiaProducto daoEspMicrobiologica = new DaoEspecificacionesMicrobiologiaProducto(LOGGER);
            if(daoEspMicrobiologica.guardarLista(especificacionesList)){
                mensaje = "1";
            }
            else{
                mensaje = "Ocurrio un error al momento de guardar las especificaciones, intente de nuevo";
            }
            return null;
        }
        
        public String getCargarEspecificacionesQuimicasProducto()
        {
            DaoEspecificacionesQuimicasProducto daoEspQuimicas = new DaoEspecificacionesQuimicasProducto(LOGGER);
            especificacionesQuimicasProductoList = daoEspQuimicas.listarPorEspecificacionQuimicaCC(componentesProdVersionSeleccionado);
            this.cargarTiposRefenciasCcSelect();
            return null;
        }
        public String guardarEspecificacionesQuimicasAction() throws SQLException
        {
            mensaje="";
            List<EspecificacionesQuimicasProducto> especificacionesQuimicasList = new ArrayList<>();
            for(EspecificacionesQuimicasCc bean:especificacionesQuimicasProductoList)
            {
                for(EspecificacionesQuimicasProducto bean1:bean.getListaEspecificacionesQuimicasProducto())
                {
                    if(bean1.getChecked())
                    {
                        especificacionesQuimicasList.add(bean1);
                    }
                }
            }
            DaoEspecificacionesQuimicasProducto daoEspQuimicas = new DaoEspecificacionesQuimicasProducto(LOGGER);
            if(daoEspQuimicas.guardarLista(especificacionesQuimicasList))
            {
                mensaje = "1";
            }
            else
            {
                mensaje = "Ocurrio un error el momento de guardar el registro, intente de nuevo";
            }
            return null;
        }
    //</editor-fold>
    //<editor-fold defaultstate="collapsed" desc="indicaciones proceso">
        private void cargarIndicacionesProceso(){
            DaoIndicacionProceso daoIndicacion = new DaoIndicacionProceso(LOGGER);
            indicacionProcesoList = daoIndicacion.listar(indicacionProcesoBean);
        }
        private void cargarTiposIndicacionProcesoSelect()
        {
            DaoTiposIndicacionProceso daoTiposIndicacion = new DaoTiposIndicacionProceso(LOGGER);
            tiposIndicacionProcesoSelectList = daoTiposIndicacion.listarSelectItem();
        }
        private void cargarProcesoOrdenManufacturaHabilitadosIndicaciones()
        {
            DaoProcesosOrdenManufactura daoProcesosOrdenManufactura = new DaoProcesosOrdenManufactura(LOGGER);
            procesosOrdenManufacturaList = daoProcesosOrdenManufactura.listarHabilitadosIndicaciones(componentesProdVersionSeleccionado);
        }
        public String getCargarIndicacionProceso()
        {
            indicacionProcesoBean.setComponentesProdVersion(componentesProdVersionSeleccionado);
            this.cargarIndicacionesProceso();
            this.cargarTiposIndicacionProcesoSelect();
            this.cargarProcesoOrdenManufacturaHabilitadosIndicaciones();
            return null;
        }
        public String eliminarIndicacionProcesoAction(int codIndicacionProceso)throws SQLException
        {
            transaccionExitosa = false;
            DaoIndicacionProceso daoIndicacionProceso = new DaoIndicacionProceso(LOGGER);
            if(daoIndicacionProceso.eliminar(codIndicacionProceso)){
                this.mostrarMensajeTransaccionExitosa("Se elimino la indicacion");
            }
            else{
                this.mostrarMensajeTransaccionFallida("Ocurrio un error, intente  de nuevo");
            }

            if(transaccionExitosa)
            {
                this.cargarIndicacionesProceso();
            }
            return null;
        }
        public String seleccionarProcesoOrdenManufacturaIndicacionAction()
        {
            this.cargarIndicacionesProceso();
            return null;
        }
        public String agregarIndicacionProcesoAction()
        {
            indicacionProceso = new IndicacionProceso();
            DaoTiposIndicacionProceso daoTipos = new DaoTiposIndicacionProceso(LOGGER);
            tiposIndicacionProcesoSelectList = daoTipos.listarNoUtilizadoSelectItem(indicacionProcesoBean);
            return null;
        }
        public String asignarTextoPorDefectoIndicacionAction()
        {
            try {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select ffi.INDICACION_FORMA from FORMAS_FARMACEUTICAS_INDICACIONES ffi ");
                                            consulta.append(" where ffi.COD_PROCESO_ORDEN_MANUFACTURA=").append(indicacionProcesoBean.getProcesosOrdenManufactura().getCodProcesoOrdenManufactura());
                                            consulta.append(" and ffi.COD_TIPO_INDICACION_PROCESO=").append(indicacionProceso.getTiposIndicacionProceso().getCodTipoIndicacionProceso());
                                            consulta.append(" and ffi.COD_FORMA=").append(componentesProdVersionSeleccionado.getForma().getCodForma());
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                if(res.next()) 
                {
                    indicacionProceso.setIndicacionProceso(res.getString("INDICACION_FORMA"));
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
        public String guardarIndicacionProcesoAction()throws SQLException
        {
            transaccionExitosa = false;
            DaoIndicacionProceso daoIndicacionProceso = new DaoIndicacionProceso(LOGGER);
            indicacionProceso.setComponentesProdVersion(indicacionProcesoBean.getComponentesProdVersion());
            indicacionProceso.setProcesosOrdenManufactura(indicacionProcesoBean.getProcesosOrdenManufactura());
            if(daoIndicacionProceso.guardar(indicacionProceso)){
                this.mostrarMensajeTransaccionExitosa("Se registro satisfactoriamente la indicacion");
            }
            else{
                this.mostrarMensajeTransaccionFallida("Ocurrio un error al momento de registrar la indicacion");
            }
            if(transaccionExitosa){
                this.cargarIndicacionesProceso();
            }
            return null;
        }
        public String modificarIndicacionProcesoAction()throws SQLException
        {
            transaccionExitosa = false;
            DaoIndicacionProceso daoIndicacionProceso = new DaoIndicacionProceso(LOGGER);
            if(daoIndicacionProceso.modificar(indicacionProceso)){
                this.mostrarMensajeTransaccionExitosa("Se modifico satisfactoriamente la indicacion");
            }
            else{
                this.mostrarMensajeTransaccionFallida("Ocurrio un error al momento de modificacion la indicacion");
            }

            if(transaccionExitosa){
                this.cargarIndicacionesProceso();
            }
            return null;
        }
    //</editor-fold>
        
    //<editor-fold defaultstate="collapsed" desc="impresion de O.M.">
        public String mostrarOrdenManufacturaAction()
        {
            transaccionExitosa = false;
            try 
            {
                con = Util.openConnection(con);
                con.setAutoCommit(false);
                SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm");
                StringBuilder consulta = new StringBuilder(" delete programa_produccion where cod_lote_produccion='").append("H").append(componentesProdVersionSeleccionado.getCodVersion()).append("';");
                                        consulta.append(" insert into programa_produccion(cod_programa_prod,cod_formula_maestra,cod_lote_produccion,cod_estado_programa,observacion,CANT_LOTE_PRODUCCION,VERSION_LOTE,COD_COMPPROD,COD_TIPO_PROGRAMA_PROD,COD_PRESENTACION,nro_lotes,COD_COMPPROD_PADRE,cod_compprod_version,cod_formula_maestra_version,FECHA_REGISTRO)");
                                        consulta.append(" values(");
                                                consulta.append("0,");
                                                consulta.append(componentesProdVersionSeleccionado.getCodFormulaMaestra()).append(",");
                                                consulta.append("'H").append(componentesProdVersionSeleccionado.getCodVersion()).append("',");
                                                consulta.append("2,'creado para impresion de OM',");
                                                consulta.append(componentesProdVersionSeleccionado.getTamanioLoteProduccion());
                                                consulta.append(",1,");
                                                consulta.append(componentesProdVersionSeleccionado.getCodCompprod()).append(",");//oodigp producto
                                                consulta.append("isnull((select top 1 ppv.COD_TIPO_PROGRAMA_PROD from PRESENTACIONES_PRIMARIAS_VERSION ppv where ppv.COD_VERSION=").append(componentesProdVersionSeleccionado.getCodVersion()).append("  order by ppv.COD_TIPO_PROGRAMA_PROD),1),");//tipo de produccion
                                                consulta.append("0,");//codigo presentacion
                                                consulta.append("1,");//numero lotes
                                                consulta.append(componentesProdVersionSeleccionado.getCodCompprod()).append(",");                                            
                                                consulta.append(componentesProdVersionSeleccionado.getCodVersion()).append(",");
                                                consulta.append(componentesProdVersionSeleccionado.getCodFormulaMaestraVersion()).append(",");
                                                consulta.append("'").append(sdf.format(new Date())).append("'");
                                        consulta.append(")");
                LOGGER.debug("consulta " + consulta.toString());
                PreparedStatement pst = con.prepareStatement(consulta.toString());
                if (pst.executeUpdate() > 0)LOGGER.info("Se registro la transacción");
                (new CreacionGraficosOrdenManufactura()).crearFlujogramaOrdenManufacturaProduccion(con, LOGGER,"H"+componentesProdVersionSeleccionado.getCodVersion(),0,10);
                consulta=new StringBuilder("EXEC PAA_REGISTRO_PROGRAMA_PRODUCCION_DETALLE 0,");
                               consulta.append("'H").append(componentesProdVersionSeleccionado.getCodVersion()).append("'");
                LOGGER.debug("consulta REGISTRAR PROGRAMA PRODUCCION DETALLE "+consulta.toString());
                pst=con.prepareStatement(consulta.toString());
                if(pst.executeUpdate()>0)LOGGER.info("se guardo la materia prima");
                con.commit();
                mensaje = "1";
                pst.close();
            }
            catch (SQLException ex) 
            {
                LOGGER.warn(ex.getMessage());
                this.mostrarMensajeTransaccionFallida("Ocurrio un error al momento de guardar la transaccion");
                
            }
            catch (Exception ex) 
            {
                LOGGER.warn(ex.getMessage());
                this.mostrarMensajeTransaccionFallida("Ocurrio un error al momento de guardar la transaccion,verifique los datos introducidos");

            }
            finally 
            {
                this.cerrarConexion(con);
            }
            return null;
        }
    //</editor-fold>
        
    //<editor-fold desc="getter an setter" defaultstate="collapsed">

        public List<SelectItem> getTiposProgramaProduccionSelectList() {
            return tiposProgramaProduccionSelectList;
        }

        public void setTiposProgramaProduccionSelectList(List<SelectItem> tiposProgramaProduccionSelectList) {
            this.tiposProgramaProduccionSelectList = tiposProgramaProduccionSelectList;
        }

        public List<ProcesosOrdenManufactura> getComponentesProdVersionEspecificacionProcesoList() {
            return componentesProdVersionEspecificacionProcesoList;
        }
        

        public void setComponentesProdVersionEspecificacionProcesoList(List<ProcesosOrdenManufactura> componentesProdVersionEspecificacionProcesoList) {
            this.componentesProdVersionEspecificacionProcesoList = componentesProdVersionEspecificacionProcesoList;
        }

        public boolean isDefineLoteEs() {
            return defineLoteEs;
        }

        public void setDefineLoteEs(boolean defineLoteEs) {
            this.defineLoteEs = defineLoteEs;
        }

        public List<SelectItem> getTiposIndicacionProcesoSelectList() {
            return tiposIndicacionProcesoSelectList;
        }

        public void setTiposIndicacionProcesoSelectList(List<SelectItem> tiposIndicacionProcesoSelectList) {
            this.tiposIndicacionProcesoSelectList = tiposIndicacionProcesoSelectList;
        }
        
        

        public boolean isPermisoRegistrarInformacionRegenciaFarmaceutica() {
            return permisoRegistrarInformacionRegenciaFarmaceutica;
        }

        public void setPermisoRegistrarInformacionRegenciaFarmaceutica(boolean permisoRegistrarInformacionRegenciaFarmaceutica) {
            this.permisoRegistrarInformacionRegenciaFarmaceutica = permisoRegistrarInformacionRegenciaFarmaceutica;
        }

        public boolean isPermisoInactivarProductoEstandarizacion() {
            return permisoInactivarProductoEstandarizacion;
        }

        public void setPermisoInactivarProductoEstandarizacion(boolean permisoInactivarProductoEstandarizacion) {
            this.permisoInactivarProductoEstandarizacion = permisoInactivarProductoEstandarizacion;
        }

        public boolean isPermisoGestionEstandarizacionValidaciones() {
            return permisoGestionEstandarizacionValidaciones;
        }

        public void setPermisoGestionEstandarizacionValidaciones(boolean permisoGestionEstandarizacionValidaciones) {
            this.permisoGestionEstandarizacionValidaciones = permisoGestionEstandarizacionValidaciones;
        }

        public boolean isPermisoGestionEstandarizacionDesarrollo() {
            return permisoGestionEstandarizacionDesarrollo;
        }

        public void setPermisoGestionEstandarizacionDesarrollo(boolean permisoGestionEstandarizacionDesarrollo) {
            this.permisoGestionEstandarizacionDesarrollo = permisoGestionEstandarizacionDesarrollo;
        }

        public boolean isPermisoVisualizacionProductoEstandarizacion() {
            return permisoVisualizacionProductoEstandarizacion;
        }

        public void setPermisoVisualizacionProductoEstandarizacion(boolean permisoVisualizacionProductoEstandarizacion) {
            this.permisoVisualizacionProductoEstandarizacion = permisoVisualizacionProductoEstandarizacion;
        }
        
        
        



        public ComponentesProdVersionEspecificacionProceso getComponentesProdVersionEspecificacionProceso() {
            return componentesProdVersionEspecificacionProceso;
        }

        public List<ComponentesProdVersionLimpiezaSeccion> getComponentesProdVersionLimpiezaSeccionList() {
            return componentesProdVersionLimpiezaSeccionList;
        }

        public void setComponentesProdVersionLimpiezaSeccionList(List<ComponentesProdVersionLimpiezaSeccion> componentesProdVersionLimpiezaSeccionList) {
            this.componentesProdVersionLimpiezaSeccionList = componentesProdVersionLimpiezaSeccionList;
        }

        public void setComponentesProdVersionEspecificacionProceso(ComponentesProdVersionEspecificacionProceso componentesProdVersionEspecificacionProceso) {
            this.componentesProdVersionEspecificacionProceso = componentesProdVersionEspecificacionProceso;
        }

        
        public ComponentesProdVersionEspecificacionProceso getComponentesProdVersionEspecificacionProcesoBean() {
            return componentesProdVersionEspecificacionProcesoBean;
        }

        public void setComponentesProdVersionEspecificacionProcesoBean(ComponentesProdVersionEspecificacionProceso componentesProdVersionEspecificacionProcesoBean) {
            this.componentesProdVersionEspecificacionProcesoBean = componentesProdVersionEspecificacionProcesoBean;
        }

    public IndicacionProceso getIndicacionProceso() {
        return indicacionProceso;
    }

    public void setIndicacionProceso(IndicacionProceso indicacionProceso) {
        this.indicacionProceso = indicacionProceso;
    }

    public IndicacionProceso getIndicacionProcesoBean() {
        return indicacionProcesoBean;
    }

    public void setIndicacionProcesoBean(IndicacionProceso indicacionProcesoBean) {
        this.indicacionProcesoBean = indicacionProcesoBean;
    }

    public List<IndicacionProceso> getIndicacionProcesoList() {
        return indicacionProcesoList;
    }

    public void setIndicacionProcesoList(List<IndicacionProceso> indicacionProcesoList) {
        this.indicacionProcesoList = indicacionProcesoList;
    }

        public List<SelectItem> getProcesosOrdenManufacturaSelectList() {
            return procesosOrdenManufacturaSelectList;
        }

        public void setProcesosOrdenManufacturaSelectList(List<SelectItem> procesosOrdenManufacturaSelectList) {
            this.procesosOrdenManufacturaSelectList = procesosOrdenManufacturaSelectList;
        }


        public ProcesosPreparadoProducto getProcesosPreparadoProductoBean() {
            return procesosPreparadoProductoBean;
        }

        public void setProcesosPreparadoProductoBean(ProcesosPreparadoProducto procesosPreparadoProductoBean) {
            this.procesosPreparadoProductoBean = procesosPreparadoProductoBean;
        }
        

        public List<ProcesosPreparadoProducto> getProcesosPreparadoProductoList() {
            return procesosPreparadoProductoList;
        }

    public List<SelectItem> getMaquinariasSelectList() {
        return maquinariasSelectList;
    }

    public void setMaquinariasSelectList(List<SelectItem> maquinariasSelectList) {
        this.maquinariasSelectList = maquinariasSelectList;
    }

        public void setProcesosPreparadoProductoList(List<ProcesosPreparadoProducto> procesosPreparadoProductoList) {
            this.procesosPreparadoProductoList = procesosPreparadoProductoList;
        }

        public ProcesosPreparadoProducto getProcesosPreparadoProductoBeanSubProceso() {
            return procesosPreparadoProductoBeanSubProceso;
        }

        public void setProcesosPreparadoProductoBeanSubProceso(ProcesosPreparadoProducto procesosPreparadoProductoBeanSubProceso) {
            this.procesosPreparadoProductoBeanSubProceso = procesosPreparadoProductoBeanSubProceso;
        }

        public ComponentesProdVersionMaquinariaProceso getComponentesProdVersionMaquinariaProcesoBean() {
            return componentesProdVersionMaquinariaProcesoBean;
        }

        public void setComponentesProdVersionMaquinariaProcesoBean(ComponentesProdVersionMaquinariaProceso componentesProdVersionMaquinariaProcesoBean) {
            this.componentesProdVersionMaquinariaProcesoBean = componentesProdVersionMaquinariaProcesoBean;
        }

        public ComponentesProdVersionMaquinariaProceso getComponentesProdVersionMaquinariaProceso() {
            return componentesProdVersionMaquinariaProceso;
        }

        public void setComponentesProdVersionMaquinariaProceso(ComponentesProdVersionMaquinariaProceso componentesProdVersionMaquinariaProceso) {
            this.componentesProdVersionMaquinariaProceso = componentesProdVersionMaquinariaProceso;
        }

        public List<ComponentesProdVersionMaquinariaProceso> getComponentesProdVersionMaquinariaProcesoList() {
            return componentesProdVersionMaquinariaProcesoList;
        }

        public void setComponentesProdVersionMaquinariaProcesoList(List<ComponentesProdVersionMaquinariaProceso> componentesProdVersionMaquinariaProcesoList) {
            this.componentesProdVersionMaquinariaProcesoList = componentesProdVersionMaquinariaProcesoList;
        }


        public List<ComponentesProdProcesoOrdenManufactura> getComponentesProdProcesoOrdenManufacturaList() {
            return componentesProdProcesoOrdenManufacturaList;
        }

        public void setComponentesProdProcesoOrdenManufacturaList(List<ComponentesProdProcesoOrdenManufactura> componentesProdProcesoOrdenManufacturaList) {
            this.componentesProdProcesoOrdenManufacturaList = componentesProdProcesoOrdenManufacturaList;
        }

        public List<ComponentesProdProcesoOrdenManufactura> getComponentesProdProcesoOrdenManufacturaDisponibleList() {
            return componentesProdProcesoOrdenManufacturaDisponibleList;
        }

        public void setComponentesProdProcesoOrdenManufacturaDisponibleList(List<ComponentesProdProcesoOrdenManufactura> componentesProdProcesoOrdenManufacturaDisponibleList) {
            this.componentesProdProcesoOrdenManufacturaDisponibleList = componentesProdProcesoOrdenManufacturaDisponibleList;
        }




        
        public List<ProcesosPreparadoProductoConsumo> getProcesosPreparadoProductoConsumoDisponibleList() {
            return procesosPreparadoProductoConsumoDisponibleList;
        }

        public List<SelectItem> getProcesosPreparadoDestinoSelectList() {
            return procesosPreparadoDestinoSelectList;
        }

        public void setProcesosPreparadoDestinoSelectList(List<SelectItem> procesosPreparadoDestinoSelectList) {
            this.procesosPreparadoDestinoSelectList = procesosPreparadoDestinoSelectList;
        }

        public void setProcesosPreparadoProductoConsumoDisponibleList(List<ProcesosPreparadoProductoConsumo> procesosPreparadoProductoConsumoDisponibleList) {
            this.procesosPreparadoProductoConsumoDisponibleList = procesosPreparadoProductoConsumoDisponibleList;
        }


        

        public ComponentesProdVersion getComponentesProdVersionNuevoEnsayo() {
            return componentesProdVersionNuevoEnsayo;
        }

        public void setComponentesProdVersionNuevoEnsayo(ComponentesProdVersion componentesProdVersionNuevoEnsayo) {
            this.componentesProdVersionNuevoEnsayo = componentesProdVersionNuevoEnsayo;
        }

        public ComponentesProdVersion getComponentesProdVersion() {
            return componentesProdVersion;
        }

        public void setComponentesProdVersion(ComponentesProdVersion componentesProdVersion) {
            this.componentesProdVersion = componentesProdVersion;
        }

        public List<EspecificacionesFisicasProducto> getEspecificacionesFisicasProductoList() {
            return especificacionesFisicasProductoList;
        }

        public void setEspecificacionesFisicasProductoList(List<EspecificacionesFisicasProducto> especificacionesFisicasProductoList) {
            this.especificacionesFisicasProductoList = especificacionesFisicasProductoList;
        }

        public ProcesosPreparadoProductoMaquinaria getProcesosPreparadoProductoMaquinaria() {
            return procesosPreparadoProductoMaquinaria;
        }

        public void setProcesosPreparadoProductoMaquinaria(ProcesosPreparadoProductoMaquinaria procesosPreparadoProductoMaquinaria) {
            this.procesosPreparadoProductoMaquinaria = procesosPreparadoProductoMaquinaria;
        }

        public List<PresentacionesPrimarias> getFormulaMaestraEPList() {
            return formulaMaestraEPList;
        }

        public List<FormulaMaestraDetalleMr> getFormulaMaestraDetalleMRList() {
            return formulaMaestraDetalleMRList;
        }

        public void setFormulaMaestraDetalleMRList(List<FormulaMaestraDetalleMr> formulaMaestraDetalleMRList) {
            this.formulaMaestraDetalleMRList = formulaMaestraDetalleMRList;
        }

        public int getCodTipoMaterialReactivo() {
            return codTipoMaterialReactivo;
        }

        public void setCodTipoMaterialReactivo(int codTipoMaterialReactivo) {
            this.codTipoMaterialReactivo = codTipoMaterialReactivo;
        }

        

        public ComponentesPresProdVersion getComponentesPresProdVersion() {
            return componentesPresProdVersion;
        }

        public List<SelectItem> getTiposEspecificacionesFisicasSelect() {
            return tiposEspecificacionesFisicasSelect;
        }

        public void setTiposEspecificacionesFisicasSelect(List<SelectItem> tiposEspecificacionesFisicasSelect) {
            this.tiposEspecificacionesFisicasSelect = tiposEspecificacionesFisicasSelect;
        }

        public List<SelectItem> getTiposReferenciaCcSelect() {
            return tiposReferenciaCcSelect;
        }

        public void setTiposReferenciaCcSelect(List<SelectItem> tiposReferenciaCcSelect) {
            this.tiposReferenciaCcSelect = tiposReferenciaCcSelect;
        }

        public ComponentesProdVersion getComponentesProdVersionSeleccionado() {
            return componentesProdVersionSeleccionado;
        }

        public void setComponentesProdVersionSeleccionado(ComponentesProdVersion componentesProdVersionSeleccionado) {
            this.componentesProdVersionSeleccionado = componentesProdVersionSeleccionado;
        }

        public void setComponentesPresProdVersion(ComponentesPresProdVersion componentesPresProdVersion) {
            this.componentesPresProdVersion = componentesPresProdVersion;
        }

        public List<SelectItem> getPresentacionesSelectList() {
            return presentacionesSelectList;
        }

        public void setPresentacionesSelectList(List<SelectItem> presentacionesSelectList) {
            this.presentacionesSelectList = presentacionesSelectList;
        }

        public void setFormulaMaestraEPList(List<PresentacionesPrimarias> formulaMaestraEPList) {
            this.formulaMaestraEPList = formulaMaestraEPList;
        }

        public FormulaMaestraEsVersion getFormulaMaestraEsVersionSeleccionado() {
            return formulaMaestraEsVersionSeleccionado;
        }

        public void setFormulaMaestraEsVersionSeleccionado(FormulaMaestraEsVersion formulaMaestraEsVersionSeleccionado) {
            this.formulaMaestraEsVersionSeleccionado = formulaMaestraEsVersionSeleccionado;
        }

        public List<ComponentesPresProdVersion> getComponentesPresProdList() {
            return componentesPresProdList;
        }

        public void setComponentesPresProdList(List<ComponentesPresProdVersion> componentesPresProdList) {
            this.componentesPresProdList = componentesPresProdList;
        }

        public FormulaMaestraDetalleMP getFormulaMaestraDetalleMPBean() {
            return formulaMaestraDetalleMPBean;
        }

        public void setFormulaMaestraDetalleMPBean(FormulaMaestraDetalleMP formulaMaestraDetalleMPBean) {
            this.formulaMaestraDetalleMPBean = formulaMaestraDetalleMPBean;
        }

        

        public FormulaMaestraVersion getFormulaMaestraVersionSeleccionado() {
            return formulaMaestraVersionSeleccionado;
        }

        public void setFormulaMaestraVersionSeleccionado(FormulaMaestraVersion formulaMaestraVersionSeleccionado) {
            this.formulaMaestraVersionSeleccionado = formulaMaestraVersionSeleccionado;
        }

        public List<TiposMaterialProduccion> getTiposMaterialProduccionList() {
            return tiposMaterialProduccionList;
        }

        public void setTiposMaterialProduccionList(List<TiposMaterialProduccion> tiposMaterialProduccionList) {
            this.tiposMaterialProduccionList = tiposMaterialProduccionList;
        }

        public TiposMaterialProduccion getTiposMaterialProduccionSeleccionado() {
            return tiposMaterialProduccionSeleccionado;
        }

        public void setTiposMaterialProduccionSeleccionado(TiposMaterialProduccion tiposMaterialProduccionSeleccionado) {
            this.tiposMaterialProduccionSeleccionado = tiposMaterialProduccionSeleccionado;
        }



        public List<SelectItem> getEnvasesPrimariosSelectList() {
            return envasesPrimariosSelectList;
        }

        public void setEnvasesPrimariosSelectList(List<SelectItem> envasesPrimariosSelectList) {
            this.envasesPrimariosSelectList = envasesPrimariosSelectList;
        }


        public List<FormulaMaestraDetalleMP> getFormulaMaestraDetalleMPEditarList() {
            return formulaMaestraDetalleMPEditarList;
        }

        public void setFormulaMaestraDetalleMPEditarList(List<FormulaMaestraDetalleMP> formulaMaestraDetalleMPEditarList) {
            this.formulaMaestraDetalleMPEditarList = formulaMaestraDetalleMPEditarList;
        }


        public ComponentesProdVersion getComponentesProdVersionBean() {
            return componentesProdVersionBean;
        }

        public void setComponentesProdVersionBean(ComponentesProdVersion componentesProdVersionBean) {
            this.componentesProdVersionBean = componentesProdVersionBean;
        }

        public List<FormulaMaestraDetalleMP> getFormulaMaestraDetalleMPAgregarList() {
            return formulaMaestraDetalleMPAgregarList;
        }

        public void setFormulaMaestraDetalleMPAgregarList(List<FormulaMaestraDetalleMP> formulaMaestraDetalleMPAgregarList) {
            this.formulaMaestraDetalleMPAgregarList = formulaMaestraDetalleMPAgregarList;
        }


        

        public List<ComponentesProdVersion> getComponentesProdDesarrolloEnsayoList() {
            return componentesProdDesarrolloEnsayoList;
        }

        public void setComponentesProdDesarrolloEnsayoList(List<ComponentesProdVersion> componentesProdDesarrolloEnsayoList) {
            this.componentesProdDesarrolloEnsayoList = componentesProdDesarrolloEnsayoList;
        }


    

        
        


        public String getMensaje() {
            return mensaje;
        }

        public void setMensaje(String mensaje) {
            this.mensaje = mensaje;
        }
        public int getComponentesProdListSize() {
            return (componentesProdList != null? componentesProdList.size() : 0);
        }
        public List<ComponentesProd> getComponentesProdList() {
            return componentesProdList;
        }

        public void setComponentesProdList(List<ComponentesProd> componentesProdList) {
            this.componentesProdList = componentesProdList;
        }

        public ComponentesProd getComponentesProdBuscar() {
            return componentesProdBuscar;
        }

        public void setComponentesProdBuscar(ComponentesProd componentesProdBuscar) {
            this.componentesProdBuscar = componentesProdBuscar;
        }

    public Materiales getMaterialesBuscar() {
        return materialesBuscar;
    }

    public void setMaterialesBuscar(Materiales materialesBuscar) {
        this.materialesBuscar = materialesBuscar;
    }

    public List<Materiales> getMaterialesList() {
        return materialesList;
    }

    public void setMaterialesList(List<Materiales> materialesList) {
        this.materialesList = materialesList;
    }

    public Materiales getMateriales() {
        return materiales;
    }

    public void setMateriales(Materiales materiales) {
        this.materiales = materiales;
    }

    public Producto getProducto() {
        return producto;
    }

    public void setProducto(Producto producto) {
        this.producto = producto;
    }

    public ComponentesProdConcentracion getComponentesProdConcentracionBean() {
        return componentesProdConcentracionBean;
    }

    public void setComponentesProdConcentracionBean(ComponentesProdConcentracion componentesProdConcentracionBean) {
        this.componentesProdConcentracionBean = componentesProdConcentracionBean;
    }
        
        
        public List<SelectItem> getProductosSelectList() {
            return productosSelectList;
        }

        public void setProductosSelectList(List<SelectItem> productosSelectList) {
            this.productosSelectList = productosSelectList;
        }

        public List<SelectItem> getFormasFarmaceuticasSelectList() {
            return formasFarmaceuticasSelectList;
        }

        public void setFormasFarmaceuticasSelectList(List<SelectItem> formasFarmaceuticasSelectList) {
            this.formasFarmaceuticasSelectList = formasFarmaceuticasSelectList;
        }

        public List<SelectItem> getAreasFabricacionProductoSelectList() {
            return areasFabricacionProductoSelectList;
        }

        public void setAreasFabricacionProductoSelectList(List<SelectItem> areasFabricacionProductoSelectList) {
            this.areasFabricacionProductoSelectList = areasFabricacionProductoSelectList;
        }

        public List<SelectItem> getViasAdministracionSelectList() {
            return viasAdministracionSelectList;
        }

        public void setViasAdministracionSelectList(List<SelectItem> viasAdministracionSelectList) {
            this.viasAdministracionSelectList = viasAdministracionSelectList;
        }

        public int getNuevoTamanioLote() {
            return nuevoTamanioLote;
        }

        public void setNuevoTamanioLote(int nuevoTamanioLote) {
            this.nuevoTamanioLote = nuevoTamanioLote;
        }

        public List<EspecificacionesQuimicasCc> getEspecificacionesQuimicasProductoList() {
            return especificacionesQuimicasProductoList;
        }

        public void setEspecificacionesQuimicasProductoList(List<EspecificacionesQuimicasCc> especificacionesQuimicasProductoList) {
            this.especificacionesQuimicasProductoList = especificacionesQuimicasProductoList;
        }

        public List<SelectItem> getTiposProduccionSelectList() {
            return tiposProduccionSelectList;
        }

        public void setTiposProduccionSelectList(List<SelectItem> tiposProduccionSelectList) {
            this.tiposProduccionSelectList = tiposProduccionSelectList;
        }

        public List<ComponentesProdVersion> getComponentesProdDesarrolloList() {
            return componentesProdDesarrolloList;
        }

        public void setComponentesProdDesarrolloList(List<ComponentesProdVersion> componentesProdDesarrolloList) {
            this.componentesProdDesarrolloList = componentesProdDesarrolloList;
        }
        
        

        
         public List<SelectItem> getSaboresProductosSelectList() {
            return saboresProductosSelectList;
        }

        public List<EspecificacionesMicrobiologiaProducto> getEspecificacionesMicrobiologiaProductoList() {
            return especificacionesMicrobiologiaProductoList;
        }

        public void setEspecificacionesMicrobiologiaProductoList(List<EspecificacionesMicrobiologiaProducto> especificacionesMicrobiologiaProductoList) {
            this.especificacionesMicrobiologiaProductoList = especificacionesMicrobiologiaProductoList;
        }

        public FormulaMaestraVersion getFormulaMaestraVersionSelecionado() {
            return formulaMaestraVersionSeleccionado;
        }

        public void setFormulaMaestraVersionSelecionado(FormulaMaestraVersion formulaMaestraVersionSeleccionado) {
            this.formulaMaestraVersionSeleccionado = formulaMaestraVersionSeleccionado;
        }

        public List<TiposMaterialProduccion> getFormulaMaestraDetalleMPList() {
            return formulaMaestraDetalleMPList;
        }

        public void setFormulaMaestraDetalleMPList(List<TiposMaterialProduccion> formulaMaestraDetalleMPList) {
            this.formulaMaestraDetalleMPList = formulaMaestraDetalleMPList;
        }

        public void setSaboresProductosSelectList(List<SelectItem> saboresProductosSelectList) {
            this.saboresProductosSelectList = saboresProductosSelectList;
        }

        public PresentacionesPrimarias getPresentacionesPrimarias() {
            return presentacionesPrimarias;
        }

        public void setPresentacionesPrimarias(PresentacionesPrimarias presentacionesPrimarias) {
            this.presentacionesPrimarias = presentacionesPrimarias;
        }

        public List<SelectItem> getTiposEspecificacionesProcesoProductoMaquinariaSelectList() {
            return tiposEspecificacionesProcesoProductoMaquinariaSelectList;
        }

        public void setTiposEspecificacionesProcesoProductoMaquinariaSelectList(List<SelectItem> tiposEspecificacionesProcesoProductoMaquinariaSelectList) {
            this.tiposEspecificacionesProcesoProductoMaquinariaSelectList = tiposEspecificacionesProcesoProductoMaquinariaSelectList;
        }

        public ComponentesProdVersion getComponentesProdDesarrollloBean() {
            return componentesProdDesarrollloBean;
        }
        

        public List<SelectItem> getCondicionesVentaProductoSelectList() {
            return condicionesVentaProductoSelectList;
        }

        public void setCondicionesVentaProductoSelectList(List<SelectItem> condicionesVentaProductoSelectList) {
            this.condicionesVentaProductoSelectList = condicionesVentaProductoSelectList;
        }

        public void setComponentesProdDesarrollloBean(ComponentesProdVersion componentesProdDesarrollloBean) {
            this.componentesProdDesarrollloBean = componentesProdDesarrollloBean;
        }

        public List<FormulaMaestraDetalleMr> getFormulaMaestraDetalleMRAgregarList() {
            return formulaMaestraDetalleMRAgregarList;
        }

        public void setFormulaMaestraDetalleMRAgregarList(List<FormulaMaestraDetalleMr> formulaMaestraDetalleMRAgregarList) {
            this.formulaMaestraDetalleMRAgregarList = formulaMaestraDetalleMRAgregarList;
        }


        public List<SelectItem> getTiposMaterialReactivoSelectList() {
            return tiposMaterialReactivoSelectList;
        }

        public void setTiposMaterialReactivoSelectList(List<SelectItem> tiposMaterialReactivoSelectList) {
            this.tiposMaterialReactivoSelectList = tiposMaterialReactivoSelectList;
        }

        public List<SelectItem> getUnidadesMedidaSelectList() {
            return unidadesMedidaSelectList;
        }

        public List<SelectItem> getColoresPresPrimSelectList() {
            return coloresPresPrimSelectList;
        }

        public void setColoresPresPrimSelectList(List<SelectItem> coloresPresPrimSelectList) {
            this.coloresPresPrimSelectList = coloresPresPrimSelectList;
        }

        public void setUnidadesMedidaSelectList(List<SelectItem> unidadesMedidaSelectList) {
            this.unidadesMedidaSelectList = unidadesMedidaSelectList;
        }

        public List<FormulaMaestraDetalleMr> getFormulaMaestraDetalleMREditarList() {
            return formulaMaestraDetalleMREditarList;
        }

        public void setFormulaMaestraDetalleMREditarList(List<FormulaMaestraDetalleMr> formulaMaestraDetalleMREditarList) {
            this.formulaMaestraDetalleMREditarList = formulaMaestraDetalleMREditarList;
        }

        public ProcesosPreparadoProducto getProcesosPreparadoProducto() {
            return procesosPreparadoProducto;
        }

        public void setProcesosPreparadoProducto(ProcesosPreparadoProducto procesosPreparadoProducto) {
            this.procesosPreparadoProducto = procesosPreparadoProducto;
        }

        public List<ProcesosOrdenManufactura> getProcesosOrdenManufacturaList() {
            return procesosOrdenManufacturaList;
        }

        public void setProcesosOrdenManufacturaList(List<ProcesosOrdenManufactura> procesosOrdenManufacturaList) {
            this.procesosOrdenManufacturaList = procesosOrdenManufacturaList;
        }

        public List<SelectItem> getActividadesPreparadoSelectList() {
            return actividadesPreparadoSelectList;
        }

        public void setActividadesPreparadoSelectList(List<SelectItem> actividadesPreparadoSelectList) {
            this.actividadesPreparadoSelectList = actividadesPreparadoSelectList;
        }

    public List<ProcesosPreparadoProducto> getSubProcesosPreparadoProductoList() {
        return subProcesosPreparadoProductoList;
    }

    public void setSubProcesosPreparadoProductoList(List<ProcesosPreparadoProducto> subProcesosPreparadoProductoList) {
        this.subProcesosPreparadoProductoList = subProcesosPreparadoProductoList;
    }

    public List<ComponentesProdVersionLimpiezaMaquinaria> getComponentesProdVersionLimpiezaMaquinariaList() {
        return componentesProdVersionLimpiezaMaquinariaList;
    }

    public void setComponentesProdVersionLimpiezaMaquinariaList(List<ComponentesProdVersionLimpiezaMaquinaria> componentesProdVersionLimpiezaMaquinariaList) {
        this.componentesProdVersionLimpiezaMaquinariaList = componentesProdVersionLimpiezaMaquinariaList;
    }

    public List<ComponentesProdVersionLimpiezaMaquinaria> getLimpiezaMaquinariaAgregarList() {
        return limpiezaMaquinariaAgregarList;
    }

    public void setLimpiezaMaquinariaAgregarList(List<ComponentesProdVersionLimpiezaMaquinaria> limpiezaMaquinariaAgregarList) {
        this.limpiezaMaquinariaAgregarList = limpiezaMaquinariaAgregarList;
    }
        
        
    



    
        
        public ComponentesProd getComponentesProdSeleccionado() {
            return componentesProdSeleccionado;
        }

        public List<ComponentesProdVersionLimpiezaMaquinaria> getComponentesProdVersionLimpiezaUtensilioPesajeList() {
            return componentesProdVersionLimpiezaUtensilioPesajeList;
        }

        public void setComponentesProdVersionLimpiezaUtensilioPesajeList(List<ComponentesProdVersionLimpiezaMaquinaria> componentesProdVersionLimpiezaUtensilioPesajeList) {
            this.componentesProdVersionLimpiezaUtensilioPesajeList = componentesProdVersionLimpiezaUtensilioPesajeList;
        }

        public List<ComponentesProdVersionLimpiezaMaquinaria> getLimpiezaUtensilioPesajeAgregarList() {
            return limpiezaUtensilioPesajeAgregarList;
        }
        

        public void setLimpiezaUtensilioPesajeAgregarList(List<ComponentesProdVersionLimpiezaMaquinaria> limpiezaUtensilioPesajeAgregarList) {
            this.limpiezaUtensilioPesajeAgregarList = limpiezaUtensilioPesajeAgregarList;
        }

        public List<SelectItem> getSeccionesOrdenManufacturaSelectList() {
            return seccionesOrdenManufacturaSelectList;
        }

        public void setSeccionesOrdenManufacturaSelectList(List<SelectItem> seccionesOrdenManufacturaSelectList) {
            this.seccionesOrdenManufacturaSelectList = seccionesOrdenManufacturaSelectList;
        }

        public ComponentesProdVersionLimpiezaSeccion getComponentesProdVersionLimpiezaPesaje() {
            return componentesProdVersionLimpiezaPesaje;
        }

        public void setComponentesProdVersionLimpiezaPesaje(ComponentesProdVersionLimpiezaSeccion componentesProdVersionLimpiezaPesaje) {
            this.componentesProdVersionLimpiezaPesaje = componentesProdVersionLimpiezaPesaje;
        }

        public List<SelectItem> getTiposDescripcionSelectList() {
            return tiposDescripcionSelectList;
        }

        public void setTiposDescripcionSelectList(List<SelectItem> tiposDescripcionSelectList) {
            this.tiposDescripcionSelectList = tiposDescripcionSelectList;
        }

        public void setComponentesProdSeleccionado(ComponentesProd componentesProdSeleccionado) {
            this.componentesProdSeleccionado = componentesProdSeleccionado;
        }
        
        
        public List<SelectItem> getTamaniosCapsulasSelectList() {
            return tamaniosCapsulasSelectList;
        }

        public void setTamaniosCapsulasSelectList(List<SelectItem> tamaniosCapsulasSelectList) {
            this.tamaniosCapsulasSelectList = tamaniosCapsulasSelectList;
        }
        
        public List<ComponentesProdVersionLimpiezaSeccion> getComponentesProdVersionLimpiezaSeccionAgregarList() {
            return componentesProdVersionLimpiezaSeccionAgregarList;
        }

        public void setComponentesProdVersionLimpiezaSeccionAgregarList(List<ComponentesProdVersionLimpiezaSeccion> componentesProdVersionLimpiezaSeccionAgregarList) {
            this.componentesProdVersionLimpiezaSeccionAgregarList = componentesProdVersionLimpiezaSeccionAgregarList;
        }
        
        
        
        
        
        
        
    //</editor-fold>

   


    

    
   
   
    
    
}
