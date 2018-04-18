/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.web;

import com.cofar.bean.ComponentesPresProd;
import com.cofar.bean.ComponentesProd;
import com.cofar.bean.ComponentesProdConcentracion;
import com.cofar.bean.ComponentesProdProcesoOrdenManufactura;
import com.cofar.bean.ComponentesProdVersion;
import com.cofar.bean.ComponentesProdVersionDocumentacionAplicada;
import com.cofar.bean.ComponentesProdVersionEspecificacionProceso;
import com.cofar.bean.ComponentesProdVersionFiltroProduccion;
import com.cofar.bean.ComponentesProdVersionLimpiezaMaquinaria;
import com.cofar.bean.ComponentesProdVersionLimpiezaSeccion;
import com.cofar.bean.ComponentesProdVersionMaquinariaProceso;
import com.cofar.bean.ComponentesProdVersionModificacion;
import com.cofar.bean.IndicacionProceso;
import com.cofar.bean.EspecificacionesFisicasProducto;
import com.cofar.bean.EspecificacionesMicrobiologiaProducto;
import com.cofar.bean.EspecificacionesProcesosProductoMaquinaria;
import com.cofar.bean.EspecificacionesQuimicasCc;
import com.cofar.bean.EspecificacionesQuimicasProducto;
import com.cofar.bean.FiltrosProduccion;
import com.cofar.bean.FormulaMaestraDetalleMP;
import com.cofar.bean.FormulaMaestraDetalleMPfracciones;
import com.cofar.bean.FormulaMaestraVersion;
import com.cofar.bean.Materiales;
import com.cofar.bean.PresentacionesPrimarias;
import com.cofar.bean.ProcesosOrdenManufactura;
import com.cofar.bean.Producto;
import com.cofar.bean.TiposAsignacionDocumentoOm;
import com.cofar.bean.TiposMaterialProduccion;
import com.cofar.bean.util.CreacionGraficosOrdenManufactura;
import com.cofar.bean.util.correos.EnviarCorreoAprobacionVersionProducto;
import com.cofar.bean.util.correos.EnviarCorreoAprobacionVersion;
import com.cofar.dao.DaoAreasEmpresa;
import com.cofar.dao.DaoColoresPresPrimaria;
import com.cofar.dao.DaoTamanioCapsulaProduccion;
import com.cofar.dao.DaoComponentesProd;
import com.cofar.dao.DaoComponentesProdConcentracion;
import com.cofar.dao.DaoComponentesProdProcesoOrdenManufactura;
import com.cofar.dao.DaoComponentesProdVersion;
import com.cofar.dao.DaoComponentesProdVersionEspecificacionProceso;
import com.cofar.dao.DaoComponentesProdVersionLimpiezaMaquinaria;
import com.cofar.dao.DaoComponentesProdVersionLimpiezaSeccion;
import com.cofar.dao.DaoComponentesProdVersionMaquinariaProceso;
import com.cofar.dao.DaoComponentesProdVersionModificacion;
import com.cofar.dao.DaoEspecificacionesFisicasProducto;
import com.cofar.dao.DaoEspecificacionesMicrobiologiaProducto;
import com.cofar.dao.DaoEspecificacionesProcesosProductoMaquinaria;
import com.cofar.dao.DaoEspecificacionesQuimicasProducto;
import com.cofar.dao.DaoEstadosCompProd;
import com.cofar.dao.DaoFormulaMaestraDetalleMpFraccionesVersion;
import com.cofar.dao.DaoFormulaMaestraDetalleMpVersion;
import com.cofar.dao.DaoIndicacionProceso;
import com.cofar.dao.DaoMateriales;
import com.cofar.dao.DaoProcesosOrdenManufactura;
import com.cofar.dao.DaoProductos;
import com.cofar.dao.DaoSeccionesOrdenManufactura;
import com.cofar.dao.DaoTiposEspecificacionesFisicas;
import com.cofar.dao.DaoTiposIndicacionProceso;
import com.cofar.dao.DaoTiposReferenciaCC;
import com.cofar.dao.DaoUnidadesMedida;
import com.cofar.util.Util;
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
import java.util.Map;
import javax.faces.context.ExternalContext;
import javax.faces.context.FacesContext;
import javax.faces.model.SelectItem;
import javax.servlet.http.HttpServletRequest;
import org.apache.logging.log4j.LogManager;
import org.richfaces.component.html.HtmlDataTable;
/**
 *
 * @author DASISAQ-
 */

public class ManagedComponentesProdVersion extends ManagedBean{

    private static final int COD_ESTADO_MODIFICACION_ASIGNADO = 9;
    private static final int COD_ESTADO_MODIFICACION_REGISTRADO = 1;
    private static final String COD_AREA_EMPRESA_PRODUCCION = "96";
    private static final int COD_TIPO_PERMISO_GESTION_INFO_REGENCIA= 33;
    private static final int COD_TIPO_PERMISO_GESTION_DESARROLLO=38;
    private static final int COD_TIPO_PERMISO_GESTION_DIRECCION_TECNICA=34;
    private Connection con=null;
    private String mensaje="";
    private Producto producto;
    private Materiales materialesBuscar = new Materiales();
    private Materiales materiales;
    private List<Materiales> materialesList;
    private List<ComponentesProd> componentesProdList=new ArrayList<ComponentesProd>();
    
    private List<SelectItem> productosSelectList=new ArrayList<SelectItem>();
    private List<SelectItem> estadosCompProdSelectList = new ArrayList<SelectItem>();
    private List<SelectItem> formasFarmaceuticasSelectList=new ArrayList<SelectItem>();
    private List<SelectItem> saboresProductoSelectList=new ArrayList<SelectItem>();
    private List<SelectItem> unidadesMedidaSelectList=new ArrayList<SelectItem>();
    private List<SelectItem> viasAdministracionSelectList=new ArrayList<SelectItem>();
    private List<SelectItem> coloresPresPrimSelectList=new ArrayList<SelectItem>();
    private List<SelectItem> areasEmpresaSelectList=new ArrayList<SelectItem>();
    private List<SelectItem> tamaniosCapsulasSelectList=new ArrayList<SelectItem>();
    private List<SelectItem> envasesPrimariosSelectList=new ArrayList<SelectItem>();
    private List<SelectItem> tiposProgramaProduccionSelectList=new ArrayList<SelectItem>();
    private ComponentesProd componentesProdBuscar=new ComponentesProd();
    private HtmlDataTable componentesProdDataTable=new HtmlDataTable();
    private ComponentesProd componentesProdBean=null;
    private List<ComponentesProdVersion> componentesProdVersionList=new ArrayList<ComponentesProdVersion>();
    private List<ComponentesProdConcentracion> componentesProdConcentracionList=new ArrayList<ComponentesProdConcentracion>();
    private ComponentesProdVersion componentesProdVersionEditar=null;
    private ComponentesProdConcentracion componentesProdConcentracionBean=new ComponentesProdConcentracion();
    private ComponentesProdVersion componentesProdVersionBean=null;
    private String unidadesProducto="";
    private HtmlDataTable componentesProdVersionDataTable=new HtmlDataTable();
    private ComponentesProdProcesoOrdenManufactura componentesProdProcesoOrdenManufacturaBean = new ComponentesProdProcesoOrdenManufactura();
    private int tamanioLoteEditar=0;
    //para presentaciones primarias
    private List<PresentacionesPrimarias> presentacionesPrimariasList=new ArrayList<PresentacionesPrimarias>();
    private PresentacionesPrimarias presentacionesPrimariaRegistrar=null;
    private PresentacionesPrimarias presentacionesPrimariasEditar=null;
    //para aprobacion de version
    private List<ComponentesProdVersion> componentesProdVersionAprobarList=new ArrayList<ComponentesProdVersion>();
    private ComponentesProdVersion componentesProdVersionRevisar=null;
    //para nuevos productos
    private List<SelectItem> tiposModificacionProductoSelectList;
    //para nuevas versiones
    private List<ComponentesProdVersion> componentesProdVersionNuevoList=new ArrayList<ComponentesProdVersion>();
    private List<ComponentesProdConcentracion> componentesProdConcentracionAgregarList=new ArrayList<ComponentesProdConcentracion>();
    private HtmlDataTable componentesProdVersionNuevoDataTable=new HtmlDataTable();
    private ComponentesProdVersion componentesProdVersionNuevo=null;
    //control permisos
    private boolean controlRegistroSanitario=false;
    private boolean controlPresentacionPrimaria=false;
    private boolean controlEmpaqueSecundario=false;
    private boolean controlControlCalidad=false;
    private boolean controlPresentacionNuevaGenerico=false;
    private boolean controlNuevoProducto=false;
    private boolean controlActivacionInactivacionproducto=false;
    private boolean permisoEnviarProductoEstandarizacion = false;
    private boolean permisoCreacionVersion = false;
    //para presentaciones Secundarias componentesPresprod
    private List<ComponentesPresProd> componentesPresProdList=new ArrayList<ComponentesPresProd>();
    private ComponentesPresProd componentesPresProdEditar=null;
    private ComponentesPresProd componentesPresProdAgregar=null;
    private List<SelectItem> presentacionesProductoSelectList=new ArrayList<SelectItem>();
    //para especificaciones de control de calidad
    private List<SelectItem> tiposEspecificacionesFisicasSelect=null;
    private List<SelectItem> tiposReferenciaCcSelect=null;
    private List<SelectItem> condicionesVentasSelectList=null;
    private List<EspecificacionesFisicasProducto> especificacionesFisicasProductoList=null;
    private List<EspecificacionesQuimicasCc> especificacionesQuimicasProductoList=null;
    private List<Materiales> listaMaterialesPrincipioActivo=new ArrayList<Materiales>();
    private List<EspecificacionesMicrobiologiaProducto> especificacionesMicrobiologiaProductoList=null;
    String codMaterialCompuestoCC="";
    // configuracion de maquinarias por proceso
    private List<ComponentesProdVersionMaquinariaProceso> componentesProdVersionMaquinariaProcesoList;
    private ComponentesProdVersionMaquinariaProceso componentesProdVersionMaquinariaProcesoBean;
    private ComponentesProdVersionMaquinariaProceso componentesProdVersionMaquinariaProcesoEditar;
    private List<SelectItem> maquinariasSelectList;
    private List<SelectItem> tiposDescripcionSelectList;
    //configuracion especificaciones por proceso y version
    private List<ProcesosOrdenManufactura> procesosOrdenManufacturaList;
    private ProcesosOrdenManufactura procesoEspecificacionBean;
    private List<SelectItem> procesosOrdenManufaturaSelectList;
    private List<SelectItem> unidadesMedidaGeneralSelectList;
    private List<SelectItem> tiposEspecificacionesProcesoProductoMaquinariaSelectList;
    private List<ComponentesProdProcesoOrdenManufactura> componentesProdProcesoOrdenManufacturaSeleccionList;
    private HtmlDataTable componentesProdProcesoDataTable;
    //variables para descripciones de proceso
    private List<SelectItem> tiposIndicacionProcesoSelectList;
    private List<IndicacionProceso> indicacionesProcesoList;
    private IndicacionProceso indicacionProcesoBean;
    //variables para registrar procesos de orden de manufactura habilitado
    private List<ComponentesProdProcesoOrdenManufactura> componentesProdProcesoOrdenManufacturaList;
    private List<ComponentesProdProcesoOrdenManufactura> componentesProdProcesoOrdenManufacturaDisponibleList;
    //variables para registro de observacion en version
    private ComponentesProdVersionModificacion componentesProdVersionModificacionObservar;
    //nuevos tamanios de lote
    private List<ComponentesProdVersion> componentesProdVersionNuevosTamaniosLoteProduccion;
    private HtmlDataTable componentesProdVersionNuevosTamaniosDataTable=new HtmlDataTable();
    private int nuevoTamanioLoteProduccion;
    //filtros de produccion asociados
    private List<ComponentesProdVersionFiltroProduccion> componentesProdVersionFiltroProduccionList;
    private List<FiltrosProduccion> filtrosProduccionAgregarList;
    //limpieza maquinarias
    private List<ComponentesProdVersionLimpiezaMaquinaria> componentesProdVersionLimpiezaMaquinariaList;
    private List<ComponentesProdVersionLimpiezaMaquinaria> maquinariasLimpiezaAgregarList;
    //limpieza secciones
    private List<ComponentesProdVersionLimpiezaSeccion> componentesProdVersionLimpiezaSeccionList;
    private List<ComponentesProdVersionLimpiezaSeccion> seccionesOrdenManufacturaAgregarList;
    //limpieza pesaje
    private List<ComponentesProdVersionLimpiezaSeccion> componentesProdVersionLimpiezaSeccionPesajeList;
    private ComponentesProdVersionLimpiezaSeccion componentesProdVersionLimpiezaPesaje;
    private List<SelectItem> seccionesOrdenManufacturaSelectList;
    private List<ComponentesProdVersionLimpiezaMaquinaria> componentesProdVersionLimpiezaUtensilioPesajeList;
    private List<ComponentesProdVersionLimpiezaMaquinaria> utensilioPesajeLimpiezaAgregarList;
    //documentacion aplicada
    private List<ComponentesProdVersionDocumentacionAplicada> componentesProdVersionDocumentacionAplicadaList;
    private TiposAsignacionDocumentoOm tiposAsignacionDocumentoOmBean=new TiposAsignacionDocumentoOm();
    private List<TiposAsignacionDocumentoOm> tiposAsignacionDocumentoOmList;
    private HtmlDataTable tiposAsignacionDocumentoOmDataTable;
    private List<ComponentesProdVersionDocumentacionAplicada> componentesProdVersionDocumentacionAplicadaAgregarList;
    //variables para enviar a aprobacion,observaciones,añadirse a version 
    private ComponentesProdVersion componentesProdVersionTransaccion;
    // <editor-fold defaultstate="collapsed" desc="discontinuar producto">
        private ComponentesProd componentesProdActivarInactivar;
    //</editor-fold>
    //<editor-fold defaultstate="collapsed" desc="enviar producto a estandarizacion">
        private List<SelectItem> personalSelectList=new ArrayList<SelectItem>();
        private int codPersonalAsignadoEstandarizacion = 0;
    //</editor-fold>
    // <editor-fold defaultstate="collapsed" desc="duplicar datos de version">
        private ComponentesProdVersion componentesProdVersionFuenteInformacion;
        private boolean duplicarProcesosHabilitados=false;
        private boolean duplicarDatosLimpieza=false;
        private boolean duplicarIndicacionesProceso=false;
        private boolean duplicarDocumentacionProceso=false;
        private boolean duplicarEspecificacionesMaquinaria=false;
        private boolean duplicarFlujoPreparado=false;
        private List<SelectItem> componentesProdVersionFuenteList;
        private ComponentesProdVersion componentesProdVersionDestinoInformacion;
    //</editor-fold>
    // <editor-fold defaultstate="collapsed" desc="modificar fracciones formula maestra">
        private ComponentesProdVersion componentesProdVersionModificarFracciones;
        private List<TiposMaterialProduccion> formulaMaestraDetalleMPList;
        private FormulaMaestraDetalleMP formulaMaestraDetalleMPModificarFracciones;
        
    //</editor-fold>
    //variable para asignacion de personal version
        private List<ComponentesProdVersionModificacion> componentesProdVersionModificacionList;
        private List<ComponentesProdVersionModificacion> componentesProdVersionModificacionAgregarList;
        
        
    //<editor-fold defaultstate="collapsed" desc="asignacion de personal">
        public String seleccionarCargarPersonalModificacionVersionAction(){
            DaoComponentesProdVersionModificacion daoModificacion = new DaoComponentesProdVersionModificacion(LOGGER);
            ComponentesProdVersionModificacion bean = new ComponentesProdVersionModificacion();
            bean.setComponentesProdVersion(componentesProdVersionEditar);
            componentesProdVersionModificacionList = daoModificacion.listar(bean);
            componentesProdVersionModificacionAgregarList = daoModificacion.listarAgregar(componentesProdVersionEditar);
            return null;
        }
        public String agregarAsignacionPersonalAction(ComponentesProdVersionModificacion bean){
            componentesProdVersionModificacionList.add(bean);
            componentesProdVersionModificacionAgregarList.remove(bean);
            return null;
        }
        public String eliminarAsignacionPersonalAction(ComponentesProdVersionModificacion bean){
            componentesProdVersionModificacionList.remove(bean);
            componentesProdVersionModificacionAgregarList.add(bean);
            return null;
        }
        public String devolverVersionPersonalAction(ComponentesProdVersionModificacion bean){
            bean.getEstadosVersionComponentesProd().setCodEstadoVersionComponenteProd(1);
            bean.setFechaDevolucionVersion(new Date());
            return null;
        }
        public String guardarAsignacionPersonalModificacionAction(){
            DaoComponentesProdVersionModificacion daoModificacion = new DaoComponentesProdVersionModificacion(LOGGER);
            if(daoModificacion.eliminarGuardarLista(componentesProdVersionModificacionList)){
                this.mostrarMensajeTransaccionExitosa("Se registraron satisfactorimente los permisos");
                if(componentesProdVersionEditar.getTiposModificacionProducto().getCodTipoModificacionProducto() == 2){
                    this.cargarComponentesProdVersionNuevosTamaniosLoteProduccion();
                }
                else{
                    this.getCargarComponentesProdVersion();
                }
            }
            else{
                this.mostrarMensajeTransaccionFallida("Ocurrio un error al momento de registrar los permisos");
            }
            return null;
        }
    //</editor-fold>
    public ManagedComponentesProdVersion() 
    {
        LOGGER=LogManager.getLogger("Versionamiento");
        componentesProdBuscar.getEstadoCompProd().setCodEstadoCompProd(1);
        componentesProdBuscar.getTiposProduccion().setCodTipoProduccion(1);
        componentesProdBuscar.getForma().setCodForma("0");
        componentesProdBuscar.getProducto().setCodProducto("0");
        componentesProdBuscar.getAreasEmpresa().setCodAreaEmpresa("0");
        componentesProdBuscar.getColoresPresentacion().setCodColor("0");
        begin=0;
        end=20;
        numrows=20;
    }
    
    // <editor-fold defaultstate="collapsed" desc="modificar fracciones">
        public String guardarModificarFormulaMaestraDetalleMpFraccion_action()throws SQLException
        {
            DaoFormulaMaestraDetalleMpFraccionesVersion daoFmFraccion=new DaoFormulaMaestraDetalleMpFraccionesVersion();
            if(daoFmFraccion.registrarFormulaMaestraDetalleMpFraccionesVersion(formulaMaestraDetalleMPModificarFracciones))
            {
                this.mostrarMensajeTransaccionExitosa("Se registraron satisfactoriamente las fracciones");
                this.getCargarModificarFormulaMaestraDetalleMpList();
            }
            else
            {
                this.mostrarMensajeTransaccionFallida("Ocurrio un error el momento de registrar las fracciones,intente de nuevo");
            }
            return null;
        }
        public String eliminarFormulaMaestraDetalleMpFraccion_action(FormulaMaestraDetalleMPfracciones formulaMaestraDetalleMPfraccionesEliminar)
        {
            formulaMaestraDetalleMPModificarFracciones.getFormulaMaestraDetalleMPfraccionesList().remove(formulaMaestraDetalleMPfraccionesEliminar);
            return null;
        }
        public String agregarFormulaMaestraDetalleMpFraccion_action()
        {
            FormulaMaestraDetalleMPfracciones nuevaFraccion=new FormulaMaestraDetalleMPfracciones();
            nuevaFraccion.setCantidad(formulaMaestraDetalleMPModificarFracciones.getCantidadTotalGramos());
            for(FormulaMaestraDetalleMPfracciones bean : formulaMaestraDetalleMPModificarFracciones.getFormulaMaestraDetalleMPfraccionesList())
            {
                nuevaFraccion.setCantidad(nuevaFraccion.getCantidad()-bean.getCantidad());
            }
            formulaMaestraDetalleMPModificarFracciones.getFormulaMaestraDetalleMPfraccionesList().add(nuevaFraccion);
            return null;
        }
        public String getCargarModificarFormulaMaestraDetalleMpList()
        {
            FormulaMaestraVersion formulaMaestraBuscar=new FormulaMaestraVersion();
            formulaMaestraBuscar.setComponentesProd(componentesProdVersionModificarFracciones);
            try {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select fmv.COD_VERSION,fmv.COD_FORMULA_MAESTRA");
                                            consulta.append(" from FORMULA_MAESTRA_VERSION fmv ");
                                            consulta.append(" where fmv.COD_COMPPROD_VERSION=").append(componentesProdVersionModificarFracciones.getCodVersion());
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                if(res.next()) {
                    formulaMaestraBuscar.setCodFormulaMaestra(res.getString("COD_FORMULA_MAESTRA"));
                    formulaMaestraBuscar.setCodVersion(res.getInt("COD_VERSION"));
                }
                mensaje = "1";
            } catch (SQLException ex) {
                LOGGER.warn(ex.getMessage());
            } catch (NumberFormatException ex) {
                LOGGER.warn(ex.getMessage());
            } finally {
                this.cerrarConexion(con);
            }
            DaoFormulaMaestraDetalleMpVersion daoFmMp=new DaoFormulaMaestraDetalleMpVersion();
            formulaMaestraDetalleMPList=daoFmMp.getFormulaMaestraDetalleMpGroupByTiposMaterialProduccionList(formulaMaestraBuscar);
            return null;
        }
    //</editor-fold>
    
    //<editor-fold defaultstate="collapsed" desc="enviar producto a estandarizacion">
        public String seleccionarEnviarProductoEstandarizacionAction(){
            int COD_TIPO_PERMISO_GESTION_ESTANDARIACION =24;
            try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("SELECT p.COD_PERSONAL , p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL+' '+p.nombre2_personal as nombrePersonal")
                                                .append(" FROM CONFIGURACION_PERMISOS_ESPECIALES_ATLAS cpe")
                                                        .append(" INNER JOIN PERSONAL p on p.COD_PERSONAL = cpe.COD_PERSONAL")
                                                .append(" where cpe.COD_TIPO_PERMISO_ESPECIAL_ATLAS = ").append(COD_TIPO_PERMISO_GESTION_ESTANDARIACION)
                                                .append(" order by 2");
            LOGGER.debug("consulta cargar PERSONAL ESTANDARIZACION :"+consulta.toString());
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta.toString());
            personalSelectList = new ArrayList<>();
            while(res.next()){
                personalSelectList.add(new SelectItem(res.getString("COD_PERSONAL"),res.getString("nombrePersonal")));
            }
          
        } catch (SQLException ex) {
            LOGGER.warn(ex.getMessage());
        } finally {
            this.cerrarConexion(con);
        }
            return null;
        }
        public String enviarProductoEstandarizacionAction()throws SQLException{
            LOGGER.debug("-------------------------------------------INICIO ENVIO PRODUCTO ESTANDARIZACION--------------------------------");
            int COD_ESTADO_PRODUCTO_ESTANDARIZACION= 3;
            int COD_TIPO_PRODUCCION_ESTANDARIZACION_VALIDACIONES = 4;
            try {
                con = Util.openConnection(con);
                con.setAutoCommit(false);
                //<editor-fold defaultstate="collapsed" desc="creando version de producto en estado estandarizacion">
                    StringBuilder consulta = new StringBuilder(" exec PAA_GENERACION_NUEVA_VERSION_PRODUCTO ");
                                                consulta.append(componentesProdActivarInactivar.getCodCompprod()).append(",");
                                                consulta.append("1,");//version de producto
                                                consulta.append("0,");
                                                consulta.append("0,?");
                    LOGGER.debug("consulta regitrar copia version producto discontinuar "+consulta.toString());
                    CallableStatement callVersionCopia=con.prepareCall(consulta.toString());
                    callVersionCopia.registerOutParameter(1,java.sql.Types.INTEGER);
                    callVersionCopia.execute();
                    int codVersionNueva=callVersionCopia.getInt(1);
                    consulta=new StringBuilder("update COMPONENTES_PROD_VERSION ");
                            consulta.append(" set COD_ESTADO_COMPPROD=").append(COD_ESTADO_PRODUCTO_ESTANDARIZACION);
                            consulta.append(" where COD_VERSION=").append(codVersionNueva);
                    LOGGER.debug("consulta inactivar producto "+consulta.toString());
                    PreparedStatement pst = con.prepareStatement(consulta.toString());
                    if (pst.executeUpdate() > 0)LOGGER.info("se inactivo el producto en la version");
                    consulta=new StringBuilder("update FORMULA_MAESTRA_VERSION set COD_ESTADO_REGISTRO=").append(COD_ESTADO_PRODUCTO_ESTANDARIZACION);
                                consulta.append(" from COMPONENTES_PROD_VERSION cpv ");
                                        consulta.append(" inner join FORMULA_MAESTRA_VERSION fmv on fmv.COD_COMPPROD=cpv.COD_COMPPROD");
                                                consulta.append(" and cpv.COD_VERSION=fmv.COD_COMPPROD_VERSION");
                                consulta.append(" where cpv.COD_VERSION=").append(codVersionNueva);
                    LOGGER.debug("consulta inactivar version formula "+consulta.toString());
                    pst=con.prepareStatement(consulta.toString());
                    if (pst.executeUpdate() > 0)LOGGER.info("se inactivo el producto en version de formula maestra");

                    // <editor-fold defaultstate="collapsed" desc="COMPONENTES PROD VERSION MODIFICACION">
                        ManagedAccesoSistema managed=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
                        consulta=new StringBuilder("INSERT INTO COMPONENTES_PROD_VERSION_MODIFICACION(COD_PERSONAL, COD_VERSION,COD_ESTADO_VERSION_COMPONENTES_PROD,FECHA_INCLUSION_VERSION,FECHA_ENVIO_APROBACION)");
                                 consulta.append(" VALUES (").append(managed.getUsuarioModuloBean().getCodUsuarioGlobal()).append(",").append(codVersionNueva).append(",3,GETDATE(),GETDATE())");
                        LOGGER.debug("consulta insertar usuario modificacion "+consulta);
                        pst=con.prepareStatement(consulta.toString());
                        if(pst.executeUpdate()>0)LOGGER.info("se registro el personal para la modificacion");
                    //</editor-fold>
                    // <editor-fold defaultstate="collapsed" desc="registrar datos de version de es">
                        consulta=new StringBuilder("UPDATE FORMULA_MAESTRA_ES_VERSION");
                                    consulta.append(" SET COD_PERSONAL=").append(managed.getUsuarioModuloBean().getCodUsuarioGlobal());
                                            consulta.append(" ,COD_ESTADO_VERSION=3");
                                            consulta.append(" ,FECHA_ENVIO_APROBACION=GETDATE()");
                                    consulta.append(" WHERE COD_VERSION=").append(codVersionNueva);
                        LOGGER.debug("consulta registrar datos es "+consulta.toString());
                        pst=con.prepareStatement(consulta.toString());
                        if(pst.executeUpdate()>0)LOGGER.info("se registraron datos de es");
                    //</editor-fold>
                        consulta=new StringBuilder("update COMPONENTES_PROD_VERSION ");
                                    consulta.append(" set COD_ESTADO_VERSION=3");
                                    consulta.append(" where COD_VERSION=").append(codVersionNueva);
                        LOGGER.debug("consulta enviar aprobacion version producto "+consulta.toString());
                        pst=con.prepareStatement(consulta.toString());
                        if(pst.executeUpdate()>0)LOGGER.info("se registro el envio a aprobacion");
                    // <editor-fold defaultstate="collapsed" desc="aprobando version de es">

                        consulta=new StringBuilder("exec PAA_APROBACION_COMPONENTES_PROD_VERSION ");
                                    consulta.append(codVersionNueva);
                        LOGGER.debug("consulta aprobar version producto "+consulta.toString());
                        pst=con.prepareStatement(consulta.toString());
                        if(pst.executeUpdate()>0)LOGGER.info("se aprobo la version");
                        consulta=new StringBuilder("select fmes.COD_FORMULA_MAESTRA_ES_VERSION,cpv.COD_COMPPROD,fmv.COD_FORMULA_MAESTRA");
                                    consulta.append(" from FORMULA_MAESTRA_ES_VERSION fmes");
                                            consulta.append(" inner join COMPONENTES_PROD_VERSION cpv on cpv.COD_VERSION=fmes.COD_VERSION");
                                            consulta.append(" inner join FORMULA_MAESTRA_VERSION fmv on fmv.COD_COMPPROD_VERSION=cpv.COD_VERSION");
                                                    consulta.append(" and fmv.COD_COMPPROD=cpv.COD_COMPPROD");
                                    consulta.append(" where cpv.COD_VERSION=").append(codVersionNueva);
                        LOGGER.debug("consulta buscar version es "+consulta.toString());
                        Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                        ResultSet res=st.executeQuery(consulta.toString());
                        if(res.next())
                        {
                            consulta=new StringBuilder("exec PAA_APROBACION_FORMULA_MAESTRA_ES_VERSION ");
                                    consulta.append(res.getInt("COD_FORMULA_MAESTRA_ES_VERSION")).append(",");
                                    consulta.append(codVersionNueva).append(",");
                                    consulta.append(res.getInt("COD_COMPPROD")).append(",");
                                    consulta.append(res.getInt("COD_FORMULA_MAESTRA"));
                            LOGGER.debug("consulta  aprobar es "+consulta.toString());
                            pst=con.prepareStatement(consulta.toString());
                            if(pst.executeUpdate()>0)LOGGER.info("se aprobo la version es ");
                        }
                    //</editor-fold>
                //</editor-fold>
                
                //<editor-fold defaultstate="collapsed" desc="creando version de producto para desarrollo">
                    int codCompProdDestino = 0;
                    int codFormulaMaestraDestino = 0;
                    
                    consulta = new StringBuilder("select isnull(min(cp.COD_COMPPROD),0)-1 as codComprod");
                                consulta.append(" from COMPONENTES_PROD_VERSION cp");
                    res = st.executeQuery(consulta.toString());
                    if(res.next())codCompProdDestino = res.getInt("codComprod");
                    
                    consulta=new StringBuilder(" select isnull(min(f.COD_FORMULA_MAESTRA),0)-1 as codFormulaMaestra");
                                consulta.append(" from FORMULA_MAESTRA_version f");
                    res=st.executeQuery(consulta.toString());
                    if(res.next())codFormulaMaestraDestino = res.getInt("codFormulaMaestra");
                    
                    consulta = new StringBuilder(" exec PAA_GENERACION_NUEVA_VERSION_PRODUCTO ");
                                                consulta.append(componentesProdActivarInactivar.getCodCompprod()).append(",");
                                                consulta.append("1,");//version de producto
                                                consulta.append(codCompProdDestino).append(",");
                                                consulta.append(codFormulaMaestraDestino).append(",?");
                    LOGGER.debug("consulta crear version producto "+consulta.toString());
                    callVersionCopia=con.prepareCall(consulta.toString());
                    callVersionCopia.registerOutParameter(1,java.sql.Types.INTEGER);
                    callVersionCopia.execute();
                    codVersionNueva = callVersionCopia.getInt(1);
                    
                    consulta=new StringBuilder("update COMPONENTES_PROD_VERSION ");
                            consulta.append(" set COD_ESTADO_COMPPROD = 1");
                                    consulta.append(" ,COD_ESTADO_VERSION = ").append(COD_ESTADO_PRODUCTO_ESTANDARIZACION);
                                    consulta.append(" ,COD_TIPO_PRODUCCION = ").append(COD_TIPO_PRODUCCION_ESTANDARIZACION_VALIDACIONES);
                                    consulta.append(" ,COD_TIPO_MODIFICACION_PRODUCTO=5");
                                    consulta.append(" ,NRO_VERSION=1");
                            consulta.append(" where COD_VERSION=").append(codVersionNueva);
                    LOGGER.debug("consulta inactivar producto "+consulta.toString());
                    pst = con.prepareStatement(consulta.toString());
                    if (pst.executeUpdate() > 0)LOGGER.info("se inactivo el producto en la version");
                    
                    consulta=new StringBuilder("update FORMULA_MAESTRA_VERSION set COD_ESTADO_REGISTRO=1");
                                consulta.append(" from COMPONENTES_PROD_VERSION cpv ");
                                        consulta.append(" inner join FORMULA_MAESTRA_VERSION fmv on fmv.COD_COMPPROD=cpv.COD_COMPPROD");
                                                consulta.append(" and cpv.COD_VERSION=fmv.COD_COMPPROD_VERSION");
                                consulta.append(" where cpv.COD_VERSION=").append(codVersionNueva);
                    LOGGER.debug("consulta inactivar version formula "+consulta.toString());
                    pst=con.prepareStatement(consulta.toString());
                    if (pst.executeUpdate() > 0)LOGGER.info("se inactivo el producto en version de formula maestra");
                    
                    // <editor-fold defaultstate="collapsed" desc="COMPONENTES PROD VERSION MODIFICACION">
                        consulta=new StringBuilder("INSERT INTO COMPONENTES_PROD_VERSION_MODIFICACION(COD_PERSONAL, COD_VERSION,COD_ESTADO_VERSION_COMPONENTES_PROD,FECHA_INCLUSION_VERSION,FECHA_ENVIO_APROBACION)");
                                 consulta.append(" VALUES (").append(codPersonalAsignadoEstandarizacion).append(",").append(codVersionNueva).append(",3,GETDATE(),GETDATE())");
                        LOGGER.debug("consulta insertar usuario modificacion "+consulta);
                        pst=con.prepareStatement(consulta.toString());
                        if(pst.executeUpdate()>0)LOGGER.info("se registro el personal para la modificacion");
                    //</editor-fold>
                    // <editor-fold defaultstate="collapsed" desc="registrar datos de version de es">
                        consulta=new StringBuilder("UPDATE FORMULA_MAESTRA_ES_VERSION");
                                    consulta.append(" SET COD_PERSONAL=").append(codPersonalAsignadoEstandarizacion);
                                            consulta.append(" ,COD_ESTADO_VERSION=3");
                                            consulta.append(" ,FECHA_ENVIO_APROBACION=GETDATE()");
                                    consulta.append(" WHERE COD_VERSION=").append(codVersionNueva);
                        LOGGER.debug("consulta registrar datos es "+consulta.toString());
                        pst=con.prepareStatement(consulta.toString());
                        if(pst.executeUpdate()>0)LOGGER.info("se registraron datos de es");
                    //</editor-fold>
                    // <editor-fold defaultstate="collapsed" desc="aprobando version de es">

                        consulta=new StringBuilder("exec PAA_APROBACION_COMPONENTES_PROD_VERSION ");
                                    consulta.append(codVersionNueva);
                        LOGGER.debug("consulta aprobar version producto "+consulta.toString());
                        pst=con.prepareStatement(consulta.toString());
                        if(pst.executeUpdate()>0)LOGGER.info("se aprobo la version");
                        consulta=new StringBuilder("select fmes.COD_FORMULA_MAESTRA_ES_VERSION,cpv.COD_COMPPROD,fmv.COD_FORMULA_MAESTRA");
                                    consulta.append(" from FORMULA_MAESTRA_ES_VERSION fmes");
                                            consulta.append(" inner join COMPONENTES_PROD_VERSION cpv on cpv.COD_VERSION=fmes.COD_VERSION");
                                            consulta.append(" inner join FORMULA_MAESTRA_VERSION fmv on fmv.COD_COMPPROD_VERSION=cpv.COD_VERSION");
                                                    consulta.append(" and fmv.COD_COMPPROD=cpv.COD_COMPPROD");
                                    consulta.append(" where cpv.COD_VERSION=").append(codVersionNueva);
                        LOGGER.debug("consulta buscar version es "+consulta.toString());
                        res=st.executeQuery(consulta.toString());
                        if(res.next())
                        {
                            consulta=new StringBuilder("exec PAA_APROBACION_FORMULA_MAESTRA_ES_VERSION ");
                                    consulta.append(res.getInt("COD_FORMULA_MAESTRA_ES_VERSION")).append(",");
                                    consulta.append(codVersionNueva).append(",");
                                    consulta.append(res.getInt("COD_COMPPROD")).append(",");
                                    consulta.append(res.getInt("COD_FORMULA_MAESTRA"));
                            LOGGER.debug("consulta  aprobar es "+consulta.toString());
                            pst=con.prepareStatement(consulta.toString());
                            if(pst.executeUpdate()>0)LOGGER.info("se aprobo la version es ");
                        }
                    //</editor-fold>
                //</editor-fold>
                con.commit();
                mostrarMensajeTransaccionExitosa("Se registro satisfactoriamente el envio del producto a estandarizacion");
                pst.close();
            } catch (SQLException ex) {
                con.rollback();
                LOGGER.warn(ex.getMessage());
                this.mostrarMensajeTransaccionFallida("Ocurrio un error:"+ex.getMessage());
            } catch (NumberFormatException ex) {
                con.rollback();
                LOGGER.warn(ex.getMessage());
                this.mostrarMensajeTransaccionFallida("Ocurrio un error al momento de realizar la transaccion,intente de nuevo");
            } finally {
                this.cerrarConexion(con);
            }
            if(transaccionExitosa)
            {
                this.cargarComponentesProdList();
            }
            LOGGER.debug("-------------------------------------------TERMINO ENVIO PRODUCTO ESTANDARIZACION--------------------------------");
            return null;
        }
    //</editor-fold>
        
    // <editor-fold defaultstate="collapsed" desc="inactivar producto">
        public String cambiarEstadoComponentesProdVersion_action(int codEstadoProducto)
        {
            DaoComponentesProdVersion daoComponentesProdVersion = new DaoComponentesProdVersion(LOGGER);
            if(daoComponentesProdVersion.cambiarEstadoProducto(Integer.valueOf(componentesProdActivarInactivar.getCodCompprod()), codEstadoProducto)){
                this.mostrarMensajeTransaccionExitosa("Se registro satisfactoriamente la "+(codEstadoProducto==1?"activación":"inactivación")+" del producto");
                this.cargarComponentesProdList();
            }
            else{
                this.mostrarMensajeTransaccionFallida("Ocurrio un error al momento de realizar la transaccion,intente de nuevo");
            }
            return null;
        }
    //</editor-fold>
    // <editor-fold defaultstate="collapsed" desc="duplicar datos producto">
        public String cargarDuplicarInformacionProducto_action()
        {
            duplicarProcesosHabilitados=false;
            duplicarDatosLimpieza=false;
            duplicarIndicacionesProceso=false;
            duplicarDocumentacionProceso=false;
            duplicarEspecificacionesMaquinaria=false;
            duplicarFlujoPreparado=false;
            componentesProdVersionFuenteInformacion=new ComponentesProdVersion();
            try 
            {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select cpv.COD_VERSION,cpv.nombre_prod_semiterminado,cpv.NRO_VERSION");
                                            consulta.append(" from COMPONENTES_PROD_VERSION cpv ");
                                            consulta.append(" where cpv.COD_ESTADO_COMPPROD=1");
                                                    consulta.append(" and cpv.COD_ESTADO_VERSION=2");
                                                    consulta.append(" and cpv.COD_TIPO_PRODUCCION=1");
                                                    consulta.append(" and cpv.COD_FORMA not in (2,25)");
                                                    consulta.append(" and cpv.COD_VERSION<>").append(componentesProdVersionDestinoInformacion.getCodVersion());
                                                    if(componentesProdVersionDestinoInformacion.getForma().getCodForma().equals("1") || 
                                                            componentesProdVersionDestinoInformacion.getForma().getCodForma().equals("35") || 
                                                            componentesProdVersionDestinoInformacion.getForma().getCodForma().equals("36") || 
                                                            componentesProdVersionDestinoInformacion.getForma().getCodForma().equals("37") || 
                                                            componentesProdVersionDestinoInformacion.getForma().getCodForma().equals("38") || 
                                                            componentesProdVersionDestinoInformacion.getForma().getCodForma().equals("39") || 
                                                            componentesProdVersionDestinoInformacion.getForma().getCodForma().equals("40") || 
                                                            componentesProdVersionDestinoInformacion.getForma().getCodForma().equals("41") || 
                                                            componentesProdVersionDestinoInformacion.getForma().getCodForma().equals("42"))
                                                        consulta.append(" and cpv.COD_FORMA in (1,35,36,37,38,39,40,41,42)");
                                                    else
                                                        consulta.append(" and cpv.COD_FORMA = ").append(componentesProdVersionDestinoInformacion.getForma().getCodForma());
                                            consulta.append(" order by cpv.nombre_prod_semiterminado");
                LOGGER.debug("consulta cargar productos destino "+consulta.toString());
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                componentesProdVersionFuenteList=new ArrayList<SelectItem>();
                while (res.next()) {
                    componentesProdVersionFuenteList.add(new SelectItem(res.getInt("COD_VERSION"),res.getString("nombre_prod_semiterminado")+" | V:"+res.getInt("NRO_VERSION")));
                }
                
                mensaje = "1";
            } catch (SQLException ex) {
                LOGGER.warn(ex.getMessage());
            } catch (NumberFormatException ex) {
                LOGGER.warn(ex.getMessage());
            } finally {
                this.cerrarConexion(con);
            }
            return  null;
        }
        public String guardarDuplicarInformacionProducto_action()throws SQLException
        {
            try {
                con = Util.openConnection(con);
                con.setAutoCommit(false);
                StringBuilder consulta = new StringBuilder("exec PAA_REGISTRO_DUPLICACION_INFORMACION_PRODUCTO ");
                                        consulta.append(componentesProdVersionFuenteInformacion.getCodVersion()).append(",");
                                        consulta.append(componentesProdVersionDestinoInformacion.getCodVersion()).append(",");
                                        consulta.append(duplicarProcesosHabilitados).append(",");
                                        consulta.append(duplicarDatosLimpieza).append(",");
                                        consulta.append(duplicarIndicacionesProceso).append(",");
                                        consulta.append(duplicarDocumentacionProceso).append(",");
                                        consulta.append(duplicarEspecificacionesMaquinaria).append(",");
                                        consulta.append(duplicarFlujoPreparado);
                LOGGER.debug("consulta duplicar informacion "+consulta.toString());
                PreparedStatement pst = con.prepareStatement(consulta.toString());
                if (pst.executeUpdate() > 0) LOGGER.info("se registro la duplicacion");
                
                con.commit();
                mostrarMensajeTransaccionExitosa("La informacion fue duplicada satisfactoriamente");
                pst.close();
            } catch (SQLException ex) {
                con.rollback();
                mostrarMensajeTransaccionFallida("Ocurrio un error: "+ex.getMessage());
                LOGGER.warn(ex.getMessage());
            } catch (NumberFormatException ex) {
                con.rollback();
                mostrarMensajeTransaccionFallida("Ocurrio un error de datos al momento de guardar la desviacion, verifique la información e intente de nuevo");
                LOGGER.warn(ex.getMessage());
            } finally {
                con.close();
            }
            return null;
        }
    //</editor-fold>
    
    //<editor-fold desc="documentacion aplicada producto" defaultstate="collapsed">
        public String eliminarComponentesProdVersionDocumentacionAplicada()throws SQLException
        {
            mensaje="";
            for(ComponentesProdVersionDocumentacionAplicada bean:componentesProdVersionDocumentacionAplicadaList)
            {
                if(bean.getChecked())
                {
                    try 
                    {
                        con = Util.openConnection(con);
                        con.setAutoCommit(false);
                        StringBuilder consulta = new StringBuilder("delete COMPONENTES_PROD_VERSION_DOCUMENTACION_APLICADA");
                                                    consulta.append(" where COD_COMPONENTES_PROD_VERSION_DOCUMENTACION_APLICADA=").append(bean.getCodComponentesProdVersionDocumentacionAplicada());
                        LOGGER.debug("consulta eliminar documentacion aplicada " + consulta.toString());
                        PreparedStatement pst = con.prepareStatement(consulta.toString());
                        if (pst.executeUpdate() > 0) LOGGER.info("se elimino la documentacion aplicada");
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
                }
            }
            if(mensaje.equals("1"))
            {
                this.cargarComponentesProdVersionDocumentacionAplicada();
            }
            return null;
        }
        public String guardarAgregarComponentesProdVersionDocumentacionAplicada()throws SQLException
        {
            mensaje = "";
            try {
                con = Util.openConnection(con);
                con.setAutoCommit(false);
                StringBuilder consulta = new StringBuilder("INSERT INTO COMPONENTES_PROD_VERSION_DOCUMENTACION_APLICADA(COD_VERSION,COD_DOCUMENTO, COD_TIPO_ASIGNACION_DOCUMENTO_OM)");
                                            consulta.append(" VALUES (");
                                                    consulta.append(componentesProdVersionBean.getCodVersion()).append(",");
                                                    consulta.append("?,");
                                                    consulta.append(tiposAsignacionDocumentoOmBean.getCodTipoAsignacionDocumentacionOm());
                                            consulta.append(")");
                LOGGER.debug("consulta registrar documentacion aplicada" + consulta.toString());
                PreparedStatement pst = con.prepareStatement(consulta.toString());
                for(ComponentesProdVersionDocumentacionAplicada bean:componentesProdVersionDocumentacionAplicadaAgregarList)
                {
                    if(bean.getChecked())
                    {
                        pst.setInt(1,bean.getDocumentacion().getCodDocumento());LOGGER.info("p1: "+bean.getDocumentacion().getCodDocumento());
                        if(pst.executeUpdate()>0)LOGGER.info("se registro la asignacion de documentos");
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
        public String getCargarAgregarComponentesProdVersionDocumentacionAplicada()
        {
            try {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select d.COD_DOCUMENTO,d.NOMBRE_DOCUMENTO,d.CODIGO_NUEVO,d.CODIGO_DOCUMENTO,tdb.NOMBRE_TIPO_DOCUMENTO_BIBLIOTECA,ae.NOMBRE_AREA_EMPRESA");
                                            consulta.append(" from DOCUMENTACION d");
                                                    consulta.append(" inner join TIPOS_DOCUMENTO_BIBLIOTECA tdb on tdb.COD_TIPO_DOCUMENTO_BIBLIOTECA=d.COD_TIPO_DOCUMENTO_BIBLIOTECA");
                                                    consulta.append(" inner join AREAS_EMPRESA ae on ae.COD_AREA_EMPRESA=d.COD_AREA_EMPRESA");
                                            consulta.append(" where d.COD_DOCUMENTO not in ");
                                                    consulta.append(" (");
                                                            consulta.append(" select cpvdl.COD_DOCUMENTO from COMPONENTES_PROD_VERSION_DOCUMENTACION_APLICADA cpvdl");
                                                            consulta.append(" where cpvdl.COD_VERSION=").append(componentesProdVersionBean.getCodVersion());
                                                            consulta.append(" and cpvdl.COD_TIPO_ASIGNACION_DOCUMENTO_OM=").append(tiposAsignacionDocumentoOmBean.getCodTipoAsignacionDocumentacionOm());
                                                    consulta.append(" )");
                                            consulta.append(" and ae.DIVISION=3");
                                            consulta.append(" order by d.NOMBRE_DOCUMENTO");
                LOGGER.debug("consulta cargar agregar documentos " + consulta.toString());
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                componentesProdVersionDocumentacionAplicadaAgregarList=new ArrayList<ComponentesProdVersionDocumentacionAplicada>();
                while (res.next()) 
                {
                    ComponentesProdVersionDocumentacionAplicada nuevo=new ComponentesProdVersionDocumentacionAplicada();
                    nuevo.getDocumentacion().setCodDocumento(res.getInt("COD_DOCUMENTO"));
                    nuevo.getDocumentacion().setNombreDocumento(res.getString("NOMBRE_DOCUMENTO"));
                    nuevo.getDocumentacion().setCodigoDocumento(res.getString("CODIGO_DOCUMENTO"));
                    nuevo.getDocumentacion().setCodigoNuevo(res.getString("CODIGO_NUEVO"));
                    nuevo.getDocumentacion().getTiposDocumentoBiblioteca().setNombreTipoDocumentoBiblioteca(res.getString("NOMBRE_TIPO_DOCUMENTO_BIBLIOTECA"));
                    nuevo.getDocumentacion().getAreasEmpresa().setNombreAreaEmpresa(res.getString("NOMBRE_AREA_EMPRESA"));
                    componentesProdVersionDocumentacionAplicadaAgregarList.add(nuevo);
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
            return null;
        }
        public String seleccionarTipoAsignacionDocumentoOm()
        {
            tiposAsignacionDocumentoOmBean=(TiposAsignacionDocumentoOm)tiposAsignacionDocumentoOmDataTable.getRowData();
            this.cargarComponentesProdVersionDocumentacionAplicada();
            return null;
        }
        public String getCargarComponentesProdVersionDocumentacionAplicada()
        {
            this.cargarTiposAsignacionDocumentoOm();
            this.cargarComponentesProdVersionDocumentacionAplicada();
            tiposAsignacionDocumentoOmDataTable=new HtmlDataTable();
            return null;
        }
        private void cargarTiposAsignacionDocumentoOm()
        {
            try 
            {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select tad.COD_TIPO_ASIGNACION_DOCUMENTO_OM,tad.NOMBRE_TIPO_ASIGNACION_DOCUMENTO_OM");
                                            consulta.append(" from TIPOS_ASIGNACION_DOCUMENTO_OM tad ");
                                            consulta.append(" order by tad.NOMBRE_TIPO_ASIGNACION_DOCUMENTO_OM");
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                tiposAsignacionDocumentoOmList=new ArrayList<TiposAsignacionDocumentoOm>();
                while (res.next()) 
                {
                    TiposAsignacionDocumentoOm nuevo=new TiposAsignacionDocumentoOm();
                    nuevo.setCodTipoAsignacionDocumentacionOm(res.getInt("COD_TIPO_ASIGNACION_DOCUMENTO_OM"));
                    nuevo.setNombreTipoAsignacionDocumentacionOm(res.getString("NOMBRE_TIPO_ASIGNACION_DOCUMENTO_OM"));
                    tiposAsignacionDocumentoOmList.add(nuevo);
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
        private void cargarComponentesProdVersionDocumentacionAplicada()
        {
            try 
            {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select cpvda.COD_DOCUMENTO,d.NOMBRE_DOCUMENTO,d.CODIGO_DOCUMENTO,d.CODIGO_NUEVO,");
                                                    consulta.append(" tdb.NOMBRE_TIPO_DOCUMENTO_BIBLIOTECA,cpvda.COD_COMPONENTES_PROD_VERSION_DOCUMENTACION_APLICADA");
                                            consulta.append(" from COMPONENTES_PROD_VERSION_DOCUMENTACION_APLICADA cpvda");
                                                    consulta.append(" inner join DOCUMENTACION d on d.COD_DOCUMENTO=cpvda.COD_DOCUMENTO");
                                                    consulta.append(" inner join TIPOS_DOCUMENTO_BIBLIOTECA tdb on tdb.COD_TIPO_DOCUMENTO_BIBLIOTECA=d.COD_TIPO_DOCUMENTO_BIBLIOTECA");
                                            consulta.append(" where cpvda.COD_VERSION=").append(componentesProdVersionBean.getCodVersion());
                                            consulta.append(" and cpvda.COD_TIPO_ASIGNACION_DOCUMENTO_OM=").append(tiposAsignacionDocumentoOmBean.getCodTipoAsignacionDocumentacionOm());
                                            consulta.append(" order by d.NOMBRE_DOCUMENTO");
                LOGGER.debug(" consulta cargar documentacion aplicada " + consulta.toString());
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                componentesProdVersionDocumentacionAplicadaList=new ArrayList<ComponentesProdVersionDocumentacionAplicada>();
                while (res.next()) 
                {
                    ComponentesProdVersionDocumentacionAplicada nuevo=new ComponentesProdVersionDocumentacionAplicada();
                    nuevo.setCodComponentesProdVersionDocumentacionAplicada(res.getInt("COD_COMPONENTES_PROD_VERSION_DOCUMENTACION_APLICADA"));
                    nuevo.getDocumentacion().setCodDocumento(res.getInt("COD_DOCUMENTO"));
                    nuevo.getDocumentacion().setNombreDocumento(res.getString("NOMBRE_DOCUMENTO"));
                    nuevo.getDocumentacion().setCodigoDocumento(res.getString("CODIGO_DOCUMENTO"));
                    nuevo.getDocumentacion().setCodigoNuevo(res.getString("CODIGO_NUEVO"));
                    nuevo.getDocumentacion().getTiposDocumentoBiblioteca().setNombreTipoDocumentoBiblioteca(res.getString("NOMBRE_TIPO_DOCUMENTO_BIBLIOTECA"));
                    componentesProdVersionDocumentacionAplicadaList.add(nuevo);
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
    //</editor-fold>
    
    
    //<editor-fold desc="limpieza utensilios pesaje" defaultstate="collapsed">
    public String eliminarComponentesProdVersionLimpiezaUtensilioLimpiezaAction(int codComponentesProdVersionLimpiezaMaquinaria)throws SQLException
    {
        transaccionExitosa = false;
        DaoComponentesProdVersionLimpiezaMaquinaria daoLimpiezaMaquinaria = new DaoComponentesProdVersionLimpiezaMaquinaria(LOGGER);
        if(daoLimpiezaMaquinaria.eliminar(codComponentesProdVersionLimpiezaMaquinaria)){
            this.mostrarMensajeTransaccionExitosa("Se elimino la configuración de limpiza de maquinaria");
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
    public String getCargarAgregarComponentesProdVersionLimpiezaUtensiliosPesaje()
    {
        DaoComponentesProdVersionLimpiezaMaquinaria daoLimpiezaMaquinaria = new DaoComponentesProdVersionLimpiezaMaquinaria(LOGGER);
        utensilioPesajeLimpiezaAgregarList = daoLimpiezaMaquinaria.listarAgregarUtensilios(componentesProdVersionBean);
        return null;
    }
    
    public String guardarAgregarComponentesProdVersionLimpiezaUtensiliosPesaje_action()throws SQLException
    {
        
        DaoComponentesProdVersionLimpiezaMaquinaria daoLimpiezaMaquinaria = new DaoComponentesProdVersionLimpiezaMaquinaria(LOGGER);
        List<ComponentesProdVersionLimpiezaMaquinaria> guardarList = new ArrayList<>();
        for(ComponentesProdVersionLimpiezaMaquinaria bean :utensilioPesajeLimpiezaAgregarList){
            if(bean.getChecked()){
                guardarList.add(bean);
            }
        }
        if(daoLimpiezaMaquinaria.guardarLista(guardarList, componentesProdVersionBean,97)){
            this.mostrarMensajeTransaccionExitosa("Se registro satisfactoriamente la configuración de limpieza de utensilios");
        }
        else{
            this.mostrarMensajeTransaccionFallida("Ocurrio un error al momento del registro,intente de nuevo");
        }
        return null;
    }
    
    public String getCargarComponentesProdVersionLimpiezaUtensiliosPesaje()
    {
        this.cargarComponentesProdVersionLimpiezaUtensiliosPesaje();
        return null;
    }
    private void cargarComponentesProdVersionLimpiezaUtensiliosPesaje()
    {
        DaoComponentesProdVersionLimpiezaMaquinaria daoLimpiezaMaquinaria = new DaoComponentesProdVersionLimpiezaMaquinaria(LOGGER);
        ComponentesProdVersionLimpiezaMaquinaria criterio = new ComponentesProdVersionLimpiezaMaquinaria();
        criterio.setComponentesProdVersion(componentesProdVersionBean);
        criterio.getAreasEmpresa().setCodAreaEmpresa("97");
        componentesProdVersionLimpiezaUtensilioPesajeList = daoLimpiezaMaquinaria.listar(criterio);
    }
    //</editor-fold>
    //<editor-fold desc="limpieza pesaje">
    public String eliminarComponentesProdVersionLimpiezaSeccionPesajeAction(int codComponentesProdVersionLimpiezaSeccion)throws SQLException
    {
        transaccionExitosa = false;
        DaoComponentesProdVersionLimpiezaSeccion daoLimpiezaSeccion = new DaoComponentesProdVersionLimpiezaSeccion(LOGGER);
        if(daoLimpiezaSeccion.eliminar(codComponentesProdVersionLimpiezaSeccion)){
            this.mostrarMensajeTransaccionExitosa("Se elimino satisfactoriamente la seccion");
        }
        else{
            this.mostrarMensajeTransaccionFallida("Ocurrio un error al momento de eliminar la seccion,intente de nuevo");
        }
        if(transaccionExitosa){
            this.cargarComponentesProdVersionLimpiezaSeccionPesajeList();
        }
        return null;
    }
    private void cargarSeccionesOrdenManufacturaSelectList(){
        DaoSeccionesOrdenManufactura daoSeccionesOm = new DaoSeccionesOrdenManufactura(LOGGER);
        seccionesOrdenManufacturaSelectList = daoSeccionesOm.listarSelectItemNoVersion(componentesProdVersionBean);
    }
    
    public String guardarComponentesProdVersionLimpiezaPesajeAction()throws SQLException
    {
        DaoComponentesProdVersionLimpiezaSeccion daoLimpiezaSeccion = new DaoComponentesProdVersionLimpiezaSeccion(LOGGER);
        componentesProdVersionLimpiezaPesaje.setComponentesProdVersion(componentesProdVersionBean);
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
    public String getCargarAgregarComponentesProdVersionLimpiezaPesaje()
    {
        this.cargarSeccionesOrdenManufacturaSelectList();
        componentesProdVersionLimpiezaPesaje = new ComponentesProdVersionLimpiezaSeccion();
        DaoComponentesProdVersionLimpiezaMaquinaria daoLimpiezaMaquinaria = new DaoComponentesProdVersionLimpiezaMaquinaria(LOGGER);
        componentesProdVersionLimpiezaPesaje.setComponentesProdVersionLimpiezaMaquinariaList(daoLimpiezaMaquinaria.listarAgregarParaSeccion());
        return null;
    }
    public String getCargarComponentesProdVersionLimpiezaPesajeList()
    {
        this.cargarComponentesProdVersionLimpiezaSeccionPesajeList();
        return null;
    }
    private void cargarComponentesProdVersionLimpiezaSeccionPesajeList()
    {
        DaoComponentesProdVersionLimpiezaSeccion daoLimpiezaSeccion = new DaoComponentesProdVersionLimpiezaSeccion(LOGGER);
        ComponentesProdVersionLimpiezaSeccion buscar = new ComponentesProdVersionLimpiezaSeccion();
        buscar.setComponentesProdVersion(componentesProdVersionBean);
        buscar.getAreasEmpresa().setCodAreaEmpresa("97");
        componentesProdVersionLimpiezaSeccionPesajeList = daoLimpiezaSeccion.listar(buscar);
    }
    //</editor-fold>
    
    // <editor-fold defaultstate="collapsed" desc="limpieza secciones">
    public String eliminarComponentesProdVersionLimpiezaSeccionesAction(int codComponentesProdVersionLimpiezaSeccion)throws SQLException
    {
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
    public String getCargarAgregarComponentesProdVersionLimpiezaSecciones()
    {
        DaoComponentesProdVersionLimpiezaSeccion daoLimpieza = new DaoComponentesProdVersionLimpiezaSeccion(LOGGER);
        seccionesOrdenManufacturaAgregarList = daoLimpieza.listarAgregar(componentesProdVersionBean);
        return null;
    }
    public String guardarAgregarComponentesProdVersionLimpiezaSecciones_action()throws SQLException
    {
        List<ComponentesProdVersionLimpiezaSeccion> listaGuardar = new ArrayList<>();
        for(ComponentesProdVersionLimpiezaSeccion bean:seccionesOrdenManufacturaAgregarList){
            if(bean.getChecked()){
                listaGuardar.add(bean) ;
            }
        }
        DaoComponentesProdVersionLimpiezaSeccion daoLimpieza = new DaoComponentesProdVersionLimpiezaSeccion(LOGGER);
        if(daoLimpieza.guardarLista(listaGuardar, componentesProdVersionBean)){
            this.mostrarMensajeTransaccionExitosa("Se registraron satisfactoriamente las secciones");
        }
        else{
            this.mostrarMensajeTransaccionFallida("Ocurrio un error al momento de registrar las secciones, intente de nuevo");
        }
        return null;
    }
    public String getCargarComponentesProdVersionLimpiezaSecciones()
    {
        this.cargarComponentesProdVersionLimpiezaSecciones();
        return null;
    }
    private void cargarComponentesProdVersionLimpiezaSecciones()
    {
        ComponentesProdVersionLimpiezaSeccion bean = new ComponentesProdVersionLimpiezaSeccion();
        bean.setComponentesProdVersion(componentesProdVersionBean);
        bean.getAreasEmpresa().setCodAreaEmpresa("96");
        DaoComponentesProdVersionLimpiezaSeccion daoLimpieza = new DaoComponentesProdVersionLimpiezaSeccion(LOGGER);
        componentesProdVersionLimpiezaSeccionList = daoLimpieza.listar(bean);
    }
    //</editor-fold>
    
    // <editor-fold defaultstate="collapsed" desc="limpieza de maquinarias">
    public String eliminarComponentesProdVersionLimpiezaMaquinariaAction(int codComponentesProdVersionLimpiezaMaquinaria)throws SQLException
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
    public String guardarAgregarComponentesProdVersionLimpiezaMaquinaria_action()throws SQLException
    {
        DaoComponentesProdVersionLimpiezaMaquinaria daoLimpieza = new DaoComponentesProdVersionLimpiezaMaquinaria(LOGGER);
        List<ComponentesProdVersionLimpiezaMaquinaria> guardarList = new ArrayList<>();
        for(ComponentesProdVersionLimpiezaMaquinaria bean:maquinariasLimpiezaAgregarList){
            if(bean.getChecked())
            {
                guardarList.add(bean);
            }
        }
        if(daoLimpieza.guardarLista(guardarList, componentesProdVersionBean,96)){
            this.mostrarMensajeTransaccionExitosa("Se registro la configuracion de limpieza de maquinarias");
        }
        else{
            this.mostrarMensajeTransaccionFallida("Ocurrio un error al momento de registrar la configuración de limpieza de maquinaria");
        }
        
        return null;
    }
    public String getCargarAgregarComponentesProdVersionLimpiezaMaquinaria()
    {
        DaoComponentesProdVersionLimpiezaMaquinaria daoLimpieza = new DaoComponentesProdVersionLimpiezaMaquinaria(LOGGER);
        maquinariasLimpiezaAgregarList = daoLimpieza.listarAgregar(componentesProdVersionBean);
        return null;
    }
    public String getCargarComponentesProdVersionLimpiezaMaquinaria()
    {
        this.cargarComponentesProdVersionLimpiezaMaquinaria();
        return null;
    }
    private void cargarComponentesProdVersionLimpiezaMaquinaria()
    {
        ComponentesProdVersionLimpiezaMaquinaria bean = new ComponentesProdVersionLimpiezaMaquinaria();
        bean.setComponentesProdVersion(componentesProdVersionBean);
        bean.getAreasEmpresa().setCodAreaEmpresa(COD_AREA_EMPRESA_PRODUCCION);
        DaoComponentesProdVersionLimpiezaMaquinaria daoLimpieza = new DaoComponentesProdVersionLimpiezaMaquinaria(LOGGER);
        componentesProdVersionLimpiezaMaquinariaList = daoLimpieza.listar(bean);
    }
    //</editor-fold>
    
    // <editor-fold defaultstate="collapsed" desc="filtros de produccion">
    public String getCargarComponentesProdVersionFiltroProduccion()
    {
        this.cargarComponentesProdVersionFiltroProduccion();
        return null;
    }
    public String eliminarComponentesProdVersionFiltroProduccion_action()throws SQLException
    {
        mensaje="";
        for(ComponentesProdVersionFiltroProduccion bean:componentesProdVersionFiltroProduccionList)
        {
            if(bean.getChecked())
            {
                try 
                {
                    con = Util.openConnection(con);
                    con.setAutoCommit(false);
                    StringBuilder consulta = new StringBuilder("delete COMPONENTES_PROD_VERSION_FILTRO_PRODUCCION ");
                                                consulta.append(" where COD_COMPONENTES_PROD_VERSION_FILTRO_PRODUCCION=").append(bean.getCodComponentesProdVersionFiltroProduccion());
                    LOGGER.debug("consulta eliminar filtro componentes prod version " + consulta.toString());
                    PreparedStatement pst = con.prepareStatement(consulta.toString());
                    if (pst.executeUpdate() > 0) LOGGER.info("Se elimino el filtro de produccion de componentes prod version");
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
                break;
            }
        }
        if(mensaje.equals("1"))
        {
            this.cargarComponentesProdVersionFiltroProduccion();
        }
        return null;
    }
    public String guardarAgregarComponentesProdVersionFiltroProduccion_action()throws SQLException
    {
        mensaje = "";
        try 
        {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta = new StringBuilder("INSERT INTO COMPONENTES_PROD_VERSION_FILTRO_PRODUCCION(COD_VERSION,COD_FILTRO_PRODUCCION)");
                                     consulta.append("VALUES (").append(componentesProdVersionBean.getCodVersion()).append(",?)");
            LOGGER.debug("consulta registrar filtro de produccion" + consulta.toString());
            PreparedStatement pst = con.prepareStatement(consulta.toString());
            for(FiltrosProduccion bean:filtrosProduccionAgregarList)
            {
                if(bean.getChecked())
                {
                    pst.setInt(1,bean.getCodFiltroProduccion());
                    if(pst.executeUpdate()>0)LOGGER.info("se refistro del filtro de produccion "+bean.getCodFiltroProduccion());
                }
            }
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
        return null;
    }
    public String getCargarAgregarComponentesProdVersionFiltroProduccion()
    {
        try 
        {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select fp.COD_FILTRO_PRODUCCION,fp.CANTIDAD_FILTRO,um.NOMBRE_UNIDAD_MEDIDA,");
                                                consulta.append(" fp.CODIGO_FILTRO_PRODUCCION,fp.PRESION_DE_APROBACION,um1.NOMBRE_UNIDAD_MEDIDA as unidadMEdidaPresion,mf.NOMBRE_MEDIO_FILTRACION");
                                        consulta.append(" from FILTROS_PRODUCCION fp ");
                                                consulta.append(" inner join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=fp.COD_UNIDAD_MEDIDA");
                                                consulta.append(" inner join UNIDADES_MEDIDA um1 on um1.COD_UNIDAD_MEDIDA=fp.COD_UNIDAD_MEDIDA_PRESION");
                                                consulta.append(" inner join MEDIOS_FILTRACION mf on mf.COD_MEDIO_FILTRACION=fp.COD_MEDIO_FILTRACION");
                                        consulta.append(" where fp.COD_ESTADO_REGISTRO=1");
                                                consulta.append(" and fp.COD_FILTRO_PRODUCCION not in ");
                                                consulta.append(" (");
                                                    consulta.append(" select cpf.COD_FILTRO_PRODUCCION from COMPONENTES_PROD_VERSION_FILTRO_PRODUCCION cpf ");
                                                    consulta.append(" where cpf.COD_VERSION=").append(componentesProdVersionBean.getCodVersion());
                                                consulta.append(" )");
                                        consulta.append(" order by fp.CODIGO_FILTRO_PRODUCCION");
            LOGGER.debug("consulta cargar agregar filtro produccion "+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            filtrosProduccionAgregarList=new ArrayList<FiltrosProduccion>();
            while (res.next()) 
            {
                FiltrosProduccion nuevo=new FiltrosProduccion();
                nuevo.setCodFiltroProduccion(res.getInt("COD_FILTRO_PRODUCCION"));
                nuevo.setCantidadFiltro(res.getString("CANTIDAD_FILTRO"));
                nuevo.getUnidadesMedida().setNombreUnidadMedida(res.getString("NOMBRE_UNIDAD_MEDIDA"));
                nuevo.setCodigoFiltroProduccion(res.getInt("CODIGO_FILTRO_PRODUCCION"));
                nuevo.setPresionAprobación(res.getString("PRESION_DE_APROBACION"));
                nuevo.getUnidadesMedidaPresion().setNombreUnidadMedida(res.getString("unidadMEdidaPresion"));
                nuevo.getMediosFiltracion().setNombreMedioFiltracion(res.getString("NOMBRE_MEDIO_FILTRACION"));
                filtrosProduccionAgregarList.add(nuevo);
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
    private void cargarComponentesProdVersionFiltroProduccion()
    {
        try 
        {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select fp.COD_FILTRO_PRODUCCION,fp.CANTIDAD_FILTRO,um.NOMBRE_UNIDAD_MEDIDA,cpvf.COD_COMPONENTES_PROD_VERSION_FILTRO_PRODUCCION,");
                                                consulta.append(" fp.CODIGO_FILTRO_PRODUCCION,fp.PRESION_DE_APROBACION,um1.NOMBRE_UNIDAD_MEDIDA as unidadMEdidaPresion,mf.NOMBRE_MEDIO_FILTRACION");
                                        consulta.append(" from COMPONENTES_PROD_VERSION_FILTRO_PRODUCCION cpvf ");
                                                consulta.append(" inner join FILTROS_PRODUCCION fp on fp.COD_FILTRO_PRODUCCION=cpvf.COD_FILTRO_PRODUCCION");
                                                consulta.append(" inner join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=fp.COD_UNIDAD_MEDIDA");
                                                consulta.append(" inner join UNIDADES_MEDIDA um1 on um1.COD_UNIDAD_MEDIDA=fp.COD_UNIDAD_MEDIDA_PRESION");
                                                consulta.append(" inner join MEDIOS_FILTRACION mf on mf.COD_MEDIO_FILTRACION=fp.COD_MEDIO_FILTRACION");
                                        consulta.append(" where cpvf.COD_VERSION=").append(componentesProdVersionBean.getCodVersion());
                                        consulta.append(" order by fp.CODIGO_FILTRO_PRODUCCION");
            LOGGER.debug("consutla cargar filtros utilizados "+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            componentesProdVersionFiltroProduccionList=new ArrayList<ComponentesProdVersionFiltroProduccion>();
            while (res.next()) 
            {
                ComponentesProdVersionFiltroProduccion nuevo=new ComponentesProdVersionFiltroProduccion();
                nuevo.setCodComponentesProdVersionFiltroProduccion(res.getInt("COD_COMPONENTES_PROD_VERSION_FILTRO_PRODUCCION"));
                nuevo.getFiltrosProduccion().setCodFiltroProduccion(res.getInt("COD_FILTRO_PRODUCCION"));
                nuevo.getFiltrosProduccion().setCantidadFiltro(res.getString("CANTIDAD_FILTRO"));
                nuevo.getFiltrosProduccion().getUnidadesMedida().setNombreUnidadMedida(res.getString("NOMBRE_UNIDAD_MEDIDA"));
                nuevo.getFiltrosProduccion().setCodigoFiltroProduccion(res.getInt("CODIGO_FILTRO_PRODUCCION"));
                nuevo.getFiltrosProduccion().setPresionAprobación(res.getString("PRESION_DE_APROBACION"));
                nuevo.getFiltrosProduccion().getUnidadesMedidaPresion().setNombreUnidadMedida(res.getString("unidadMEdidaPresion"));
                nuevo.getFiltrosProduccion().getMediosFiltracion().setNombreMedioFiltracion(res.getString("NOMBRE_MEDIO_FILTRACION"));
                componentesProdVersionFiltroProduccionList.add(nuevo);
                
            }
            st.close();
        }
        catch (SQLException ex) 
        {
            LOGGER.warn("error", ex);
        }
        catch(Exception e)
        {
            LOGGER.warn("error", e);
        }
        finally 
        {
            this.cerrarConexion(con);
        }
    }
    //</editor-fold>
    
    private void cargarTiposIndicacionProcesoSelect()
    {
        DaoTiposIndicacionProceso daoTiposIndicacion = new DaoTiposIndicacionProceso(LOGGER);
        tiposIndicacionProcesoSelectList = daoTiposIndicacion.listarSelectItem();
    }
    private void cargarTiposDescripcionSelect()
    {
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select td.COD_TIPO_DESCRIPCION,td.NOMBRE_TIPO_DESCRIPCION");
                                    consulta.append(" from TIPOS_DESCRIPCION td");
                                    consulta.append(" order  by td.NOMBRE_TIPO_DESCRIPCION");
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
    private void cargarTiposEspecificacionesProcesoSelectList()
    {
        try 
        {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select tempp.COD_TIPO_ESPECIFICACIONES_PROCESOS_PRODUCTO_MAQUINARIA,tempp.NOMBRE_TIPO_ESPECIFICACIONES_PROCESOS_PRODUCTO_MAQUINARIA");
                                        consulta.append(" from TIPOS_ESPECIFICACIONES_PROCESOS_PRODUCTO_MAQUINARIA tempp");
                                        consulta.append(" order by tempp.NOMBRE_TIPO_ESPECIFICACIONES_PROCESOS_PRODUCTO_MAQUINARIA");
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            tiposEspecificacionesProcesoProductoMaquinariaSelectList=new ArrayList<SelectItem>();
            while (res.next()) 
            {
                tiposEspecificacionesProcesoProductoMaquinariaSelectList.add(new SelectItem(res.getInt("COD_TIPO_ESPECIFICACIONES_PROCESOS_PRODUCTO_MAQUINARIA"),res.getString("NOMBRE_TIPO_ESPECIFICACIONES_PROCESOS_PRODUCTO_MAQUINARIA")));
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
   
    private void cargarUnidadesMedidaGeneralSelectList()
    {
        DaoUnidadesMedida daoUnidadesMedida = new DaoUnidadesMedida(LOGGER);
        unidadesMedidaGeneralSelectList = daoUnidadesMedida.listarSelectItem();
        
    }
    
    // <editor-fold defaultstate="collapsed" desc="indicaciones de proceso">
    public String agregarIndicacionProceso_action()
    {
        indicacionProcesoBean=new IndicacionProceso();
        IndicacionProceso indicacion = new IndicacionProceso();
        indicacion.setComponentesProdVersion(componentesProdVersionBean);
        indicacion.setProcesosOrdenManufactura(componentesProdProcesoOrdenManufacturaBean.getFormasFarmaceuticasProcesoOrdenManufactura().getProcesosOrdenManufactura());
        DaoTiposIndicacionProceso daoTipos = new DaoTiposIndicacionProceso(LOGGER);
        tiposIndicacionProcesoSelectList = daoTipos.listarNoUtilizadoSelectItem(indicacion);
        return null;
    }
    public String editarIndicacionProceso_action()
    {
        for(IndicacionProceso bean1:indicacionesProcesoList)
        {
            if(bean1.getChecked())
            {
                indicacionProcesoBean=bean1;
            }
        }
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
    public String asignarTextoPorDefectoIndicacion_action()
    {
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select ffi.INDICACION_FORMA from FORMAS_FARMACEUTICAS_INDICACIONES ffi ");
                                        consulta.append(" where ffi.COD_PROCESO_ORDEN_MANUFACTURA=").append(componentesProdProcesoOrdenManufacturaBean.getFormasFarmaceuticasProcesoOrdenManufactura().getProcesosOrdenManufactura().getCodProcesoOrdenManufactura());
                                        consulta.append(" and ffi.COD_TIPO_INDICACION_PROCESO=").append(indicacionProcesoBean.getTiposIndicacionProceso().getCodTipoIndicacionProceso());
                                        consulta.append(" and ffi.COD_FORMA=").append(componentesProdVersionBean.getForma().getCodForma());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            if(res.next()) 
            {
                indicacionProcesoBean.setIndicacionProceso(res.getString("INDICACION_FORMA"));
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
    public String guardarIndicacionProceso_action()throws SQLException
    {
        transaccionExitosa = false;
        DaoIndicacionProceso daoIndicacionProceso = new DaoIndicacionProceso(LOGGER);
        if(indicacionProcesoBean.getCodIndicacionProceso()>0)
        {
            if(daoIndicacionProceso.modificar(indicacionProcesoBean)){
                this.mostrarMensajeTransaccionExitosa("Se modifico satisfactoriamente la indicacion");
            }
            else{
                this.mostrarMensajeTransaccionFallida("Ocurrio un error al momento de modificacion la indicacion");
            }

        }
        else
        {
            indicacionProcesoBean.setComponentesProdVersion(componentesProdVersionBean);
            indicacionProcesoBean.setProcesosOrdenManufactura(componentesProdProcesoOrdenManufacturaBean.getFormasFarmaceuticasProcesoOrdenManufactura().getProcesosOrdenManufactura());
            if(daoIndicacionProceso.guardar(indicacionProcesoBean)){
                this.mostrarMensajeTransaccionExitosa("Se modifico satisfactoriamente la indicacion");
            }
            else{
                this.mostrarMensajeTransaccionFallida("Ocurrio un error al momento de modificacion la indicacion");
            }
        }
        if(transaccionExitosa){
            this.cargarIndicacionesProceso();
        }
        return null;
    }
    private void cargarProcesoOrdenManufacturaHabilitadosIndicaciones()
    {
        DaoProcesosOrdenManufactura daoProcesosOrdenManufactura = new DaoProcesosOrdenManufactura(LOGGER);
        procesosOrdenManufacturaList = daoProcesosOrdenManufactura.listarHabilitadosIndicaciones(componentesProdVersionBean);
    }
    public String getCargarIndicacionProceso()
    {
        componentesProdProcesoDataTable=new HtmlDataTable();
        this.cargarIndicacionesProceso();
        this.cargarTiposIndicacionProcesoSelect();
        this.cargarProcesoOrdenManufacturaHabilitadosIndicaciones();
        //this.cargarProcesosOrdenManufacturaSelect();
        return null;
    }
    public String seleccionarComponentesProdProcesoOrdenManufacturaIndicacion_action()
    {
        this.cargarIndicacionesProceso();
        return null;
    }
    private void cargarIndicacionesProceso(){
        DaoIndicacionProceso daoIndicacion = new DaoIndicacionProceso(LOGGER);
        IndicacionProceso indicacionProcesoBean = new IndicacionProceso();
        indicacionProcesoBean.setComponentesProdVersion(componentesProdVersionBean);
        indicacionProcesoBean.setProcesosOrdenManufactura(componentesProdProcesoOrdenManufacturaBean.getFormasFarmaceuticasProcesoOrdenManufactura().getProcesosOrdenManufactura());
        indicacionesProcesoList = daoIndicacion.listar(indicacionProcesoBean);
        
    }
   //</editor-fold>
    
    
    // <editor-fold defaultstate="collapsed" desc="Especificaciones Procesos Por producto">
    public String getCargarComponentesProdVersionEspecificacionProceso()
    {
        this.cargarComponentesProdVersionEspecificacionesProcesos();
        return null;
    }
    public String eliminarComponentesProdVersionEspecificacionProceso_action(int codProcesoOrdenManufactura)throws SQLException
    {
        transaccionExitosa=false;
        DaoComponentesProdVersionEspecificacionProceso daoEspProceso = new DaoComponentesProdVersionEspecificacionProceso(LOGGER);
        if(daoEspProceso.eliminar(componentesProdVersionBean.getCodVersion(), codProcesoOrdenManufactura)){
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
    public String agregarComponentesProdVersionEspecificacionesProceso()
    {
        procesoEspecificacionBean=new ProcesosOrdenManufactura();
        return null;
    }
    public String getCargarAgregarEditarEspecificacionesProcesos()
    {
        this.cargarProcesosOrdenManufacturaEspecificionesSelect();
        this.cargarTiposDescripcionSelect();
        this.cargarUnidadesMedidaGeneralSelectList();
        this.cargarAgregarEditarEspecificacionesProcesos();
        return null;
    }
    public String codProcesoOrdenManufacturaEspecificacion_change()
    {
        this.cargarAgregarEditarEspecificacionesProcesos();
        return null;
    }
    public String guardarAgregarEditarEspecificacionesProcesos_action()throws SQLException{
        transaccionExitosa=false;
        DaoComponentesProdVersionEspecificacionProceso daoEspProceso = new DaoComponentesProdVersionEspecificacionProceso(LOGGER);
        List<ComponentesProdVersionEspecificacionProceso> especificacionesList = new ArrayList<>();
        for(ComponentesProdVersionEspecificacionProceso bean:procesoEspecificacionBean.getComponentesProdVersionEspecificacionProcesoList()){
            if(bean.getChecked()){
              especificacionesList.add(bean);
            }
        }
        if(daoEspProceso.eliminarGuardarLista(especificacionesList,componentesProdVersionBean.getCodVersion(), procesoEspecificacionBean.getCodProcesoOrdenManufactura())){
            this.mostrarMensajeTransaccionExitosa("Se registraron satisfactoriamente las especificaciones");
        }
        else{
            this.mostrarMensajeTransaccionFallida(" Ocurrio un error al momento de guardar las especificaciones");
        }
        return null;
    }
    
    private void cargarProcesosOrdenManufacturaEspecificionesSelect()
    {
        DaoProcesosOrdenManufactura daoProcesos = new DaoProcesosOrdenManufactura(LOGGER);
        procesosOrdenManufaturaSelectList = daoProcesos.listarSelectNoUtilizadosEspProceso(componentesProdVersionBean);
    }
    
    private void cargarAgregarEditarEspecificacionesProcesos()
    {
        DaoComponentesProdVersionEspecificacionProceso daoEspecificacion = new DaoComponentesProdVersionEspecificacionProceso(LOGGER);
        procesoEspecificacionBean.setComponentesProdVersionEspecificacionProcesoList(daoEspecificacion.listarEditar(componentesProdVersionBean.getCodVersion(), procesoEspecificacionBean.getCodProcesoOrdenManufactura()));
    }
    private void cargarComponentesProdVersionEspecificacionesProcesos()
    {
        try{
            DaoComponentesProdVersionEspecificacionProceso daoEspProceso = new DaoComponentesProdVersionEspecificacionProceso(LOGGER);
            procesosOrdenManufacturaList = daoEspProceso.listarPorProcesosOm(componentesProdVersionBean);
        }catch(Exception ex){
            LOGGER.warn("error", ex);
        }
    }
    //</editor-fold>
    
    
    
    //<editor-fold defaultstate="collapsed" desc="maquinarias por producto y proceso">
    public String seleccionarComponentesProdProcesoOrdenManufactura()
    {
        componentesProdProcesoOrdenManufacturaBean=(ComponentesProdProcesoOrdenManufactura)componentesProdProcesoDataTable.getRowData();
        this.cargarComponentesProdVersionMaquinariaProceso();
        return null;
    }
    private void cargarMaquinariasSelectList()
    {
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select m.COD_MAQUINA,m.NOMBRE_MAQUINA+'('+m.CODIGO+')' as nombreMaquina");
                                       consulta.append(" from MAQUINARIAS m where m.COD_ESTADO_REGISTRO=1 order by 2");
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            maquinariasSelectList=new ArrayList<SelectItem>();
            while (res.next()) 
            {
                maquinariasSelectList.add(new SelectItem(res.getString("COD_MAQUINA"),res.getString("nombreMaquina")));
            }
            st.close();
        } catch (SQLException ex) {
            LOGGER.warn("error", ex);
        } finally {
            this.cerrarConexion(con);
        }
    }
    public String editarComponentesProdMaquinariaProceso_action()
    {
        for(ComponentesProdVersionMaquinariaProceso bean : componentesProdVersionMaquinariaProcesoList)
        {
            if(bean.getChecked())
            {
                componentesProdVersionMaquinariaProcesoEditar=bean;
                break;
            }
        }
        return null;
    }
    
    public String guardarEditarComponentesProdVersionMaquinariaProceso_action()throws SQLException
    {
        transaccionExitosa = false;
        DaoComponentesProdVersionMaquinariaProceso daoMaquinariaProceso = new DaoComponentesProdVersionMaquinariaProceso(LOGGER);
        List<EspecificacionesProcesosProductoMaquinaria> especificacionesList = new ArrayList<>();
        for(EspecificacionesProcesosProductoMaquinaria bean :  componentesProdVersionMaquinariaProcesoEditar.getEspecificacionesProcesosProductoMaquinariaList()){
            if(bean.getChecked()){
                especificacionesList.add(bean);
            }
        }
        componentesProdVersionMaquinariaProcesoEditar.setEspecificacionesProcesosProductoMaquinariaList(especificacionesList);
        if(daoMaquinariaProceso.editar(componentesProdVersionMaquinariaProcesoEditar)){
            this.mostrarMensajeTransaccionExitosa("Se editaron satisfactoriamante las especificaciones");
        }
        else{
            this.mostrarMensajeTransaccionFallida("Ocurrio un error al momento de editar las especificaciones,intente de nuevo");
        }
        return null;
    }
    
    
    
    public String guardarAgregarComponentesProdVersionMaquinariaProceso_action()throws SQLException
    {
        transaccionExitosa = false;
        DaoComponentesProdVersionMaquinariaProceso daoMaquinariaProceso = new DaoComponentesProdVersionMaquinariaProceso(LOGGER);
        componentesProdVersionMaquinariaProcesoBean.setProcesosOrdenManufactura(componentesProdProcesoOrdenManufacturaBean.getFormasFarmaceuticasProcesoOrdenManufactura().getProcesosOrdenManufactura());
        componentesProdVersionMaquinariaProcesoBean.setComponentesProdVersion(componentesProdVersionBean);
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
    public String getCargarEditarEspecificacionesMaquinariaProcesoProducto()
    {
        this.cargarUnidadesMedidaGeneralSelectList();
        DaoEspecificacionesProcesosProductoMaquinaria daoEspMaquinaria = new DaoEspecificacionesProcesosProductoMaquinaria(LOGGER);
        componentesProdVersionMaquinariaProcesoEditar.setEspecificacionesProcesosProductoMaquinariaList(daoEspMaquinaria.listarEditar(componentesProdVersionMaquinariaProcesoEditar));
        return null;
    }
    public String getCargarAgregarEspecificacionesMaquinariaProcesoProducto()
    {
        componentesProdVersionMaquinariaProcesoBean=new ComponentesProdVersionMaquinariaProceso();
        componentesProdVersionMaquinariaProcesoBean.setComponentesProdVersion(componentesProdVersionBean);
        componentesProdVersionMaquinariaProcesoBean.setProcesosOrdenManufactura(componentesProdProcesoOrdenManufacturaBean.getFormasFarmaceuticasProcesoOrdenManufactura().getProcesosOrdenManufactura());
        this.cargarUnidadesMedidaGeneralSelectList();
        this.cargarMaquinariasAgregarEspecificaciones();
        componentesProdVersionMaquinariaProcesoBean.getMaquinaria().setCodMaquina(maquinariasSelectList.get(0).getValue().toString());
        this.cargarAgregarEspecificacionesMaquinariaProcesoProducto();
        return null;
    }
    public String codCompProdVersionMaquinariaProceso_action()
    {
        this.cargarAgregarEspecificacionesMaquinariaProcesoProducto();
        return null;
    }
    private void cargarAgregarEspecificacionesMaquinariaProcesoProducto()
    {
        DaoEspecificacionesProcesosProductoMaquinaria daoEspecificaciones = new DaoEspecificacionesProcesosProductoMaquinaria(LOGGER);
        componentesProdVersionMaquinariaProcesoBean.setEspecificacionesProcesosProductoMaquinariaList(daoEspecificaciones.listarAgregarPorRecetaMaquinaria(componentesProdVersionMaquinariaProcesoBean));
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
    
    private void cargarProcesosOrdenManufacturaMaquinariaHabilitado()
    {
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select cppom.ORDEN,pom.NOMBRE_PROCESO_ORDEN_MANUFACTURA,pom.COD_PROCESO_ORDEN_MANUFACTURA,ffpom.APLICA_TIPO_ESPECIFICACION_PROCESO");
                                    consulta.append(" from COMPONENTES_PROD_PROCESO_ORDEN_MANUFACTURA cppom ");
                                        consulta.append(" inner join FORMAS_FARMACEUTICAS_PROCESO_ORDEN_MANUFACTURA ffpom on cppom.COD_FORMA_FARMACEUTICA_PROCESO_ORDEN_MANUFACTURA=ffpom.COD_FORMA_FARMACEUTICA_PROCESO_ORDEN_MANUFACTURA");
                                        consulta.append(" inner join PROCESOS_ORDEN_MANUFACTURA pom on pom.COD_PROCESO_ORDEN_MANUFACTURA=ffpom.COD_PROCESO_ORDEN_MANUFACTURA");
                                    consulta.append(" where cppom.COD_VERSION=").append(componentesProdVersionBean.getCodVersion());
                                        consulta.append(" and ffpom.APLICA_ESPECIFICACIONES_MAQUINARIA=1");
                                    consulta.append(" order by cppom.ORDEN");
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            componentesProdProcesoOrdenManufacturaSeleccionList=new ArrayList<ComponentesProdProcesoOrdenManufactura>();
            while (res.next()) 
            {
                ComponentesProdProcesoOrdenManufactura nuevo=new ComponentesProdProcesoOrdenManufactura();
                nuevo.getFormasFarmaceuticasProcesoOrdenManufactura().getProcesosOrdenManufactura().setCodProcesoOrdenManufactura(res.getInt("COD_PROCESO_ORDEN_MANUFACTURA"));
                nuevo.getFormasFarmaceuticasProcesoOrdenManufactura().getProcesosOrdenManufactura().setNombreProcesoOrdenManufactura(res.getString("NOMBRE_PROCESO_ORDEN_MANUFACTURA"));
                nuevo.getFormasFarmaceuticasProcesoOrdenManufactura().setAplicaTipoEspecificacionProceso(res.getInt("APLICA_TIPO_ESPECIFICACION_PROCESO")>0);
                nuevo.setOrden(res.getInt("ORDEN"));
                componentesProdProcesoOrdenManufacturaSeleccionList.add(nuevo);
            }
            st.close();
        } catch (SQLException ex) {
            LOGGER.warn("error", ex);
        } finally {
            this.cerrarConexion(con);
        }
    }
    private void cargarMaquinariasAgregarEspecificaciones()
    {
        DaoComponentesProdVersionMaquinariaProceso daoMaquinaria = new DaoComponentesProdVersionMaquinariaProceso(LOGGER);
        ComponentesProdVersionMaquinariaProceso maquinaria = new ComponentesProdVersionMaquinariaProceso();
        maquinaria.setComponentesProdVersion(componentesProdVersionBean);
        maquinaria.setProcesosOrdenManufactura(componentesProdProcesoOrdenManufacturaBean.getFormasFarmaceuticasProcesoOrdenManufactura().getProcesosOrdenManufactura());
        maquinariasSelectList = daoMaquinaria.listarSelectMaquinariaNoUtilizada(maquinaria);
    }
    
    public String getCargarComponentesProdVersionMaquinariaProceso() 
    {
        componentesProdProcesoDataTable = new HtmlDataTable();
        this.cargarTiposEspecificacionesProcesoSelectList();
        this.cargarComponentesProdVersionMaquinariaProceso();
        this.cargarProcesosOrdenManufacturaMaquinariaHabilitado();
        this.cargarTiposDescripcionSelect();
        //this.cargarMaquinariasSelectList();
        return null;
    }
    private void cargarComponentesProdVersionMaquinariaProceso() 
    {
        ComponentesProdVersionMaquinariaProceso maquinaria = new ComponentesProdVersionMaquinariaProceso();
        maquinaria.setComponentesProdVersion(componentesProdVersionBean);
        maquinaria.setProcesosOrdenManufactura(componentesProdProcesoOrdenManufacturaBean.getFormasFarmaceuticasProcesoOrdenManufactura().getProcesosOrdenManufactura());
        DaoEspecificacionesProcesosProductoMaquinaria daoMaquinaria = new DaoEspecificacionesProcesosProductoMaquinaria(LOGGER);
        componentesProdVersionMaquinariaProcesoList = daoMaquinaria.listarPorMaquinaria(maquinaria);
        
    }
    //</editor-fold>
    //<editor-fold defaultstate="collapsed" desc="formula maestra">
    public String seleccionarComponentesProdNuevoTamanioLoteVersionEs_action(){
        try {
                ComponentesProdVersion bean=(ComponentesProdVersion)componentesProdVersionNuevosTamaniosDataTable.getRowData();
                FacesContext facesContext = FacesContext.getCurrentInstance();
                ExternalContext externalContext = facesContext.getExternalContext();
                Map map = externalContext.getSessionMap();
                map.put("ComponentesProdVersionEs",bean);
        }
        catch (Exception e) 
        {
            LOGGER.warn("error", e);
        }
        return null;
    }
    public String seleccionarFormulaMaestraNuevoTamanioLote_action(){
        try {
                ComponentesProdVersion bean=(ComponentesProdVersion)componentesProdVersionNuevosTamaniosDataTable.getRowData();
                FormulaMaestraVersion formulaMaestraVersion=new FormulaMaestraVersion();
                formulaMaestraVersion.setCodVersion(bean.getCodFormulaMaestraVersion());
                formulaMaestraVersion.setCodFormulaMaestra(String.valueOf(bean.getCodFormulaMaestra()));
                formulaMaestraVersion.setComponentesProd((ComponentesProd)bean.clone());
                formulaMaestraVersion.setCantidadLote(bean.getTamanioLoteProduccion());
                formulaMaestraVersion.getComponentesProd().setNroVersion(bean.getNroVersion());
                formulaMaestraVersion.getComponentesProd().setCodVersion(bean.getCodVersion());
                FacesContext facesContext = FacesContext.getCurrentInstance();
                ExternalContext externalContext = facesContext.getExternalContext();
                Map map = externalContext.getSessionMap();
                map.put("formulaMaestraVersion",formulaMaestraVersion);

        }
        catch (Exception e) {
        }
        return null;
    }
    public String seleccionarComponentesProdNuevoVersionEs_action(){
        try {
                ComponentesProdVersion bean=(ComponentesProdVersion)componentesProdVersionTransaccion;
                FacesContext facesContext = FacesContext.getCurrentInstance();
                ExternalContext externalContext = facesContext.getExternalContext();
                Map map = externalContext.getSessionMap();
                map.put("ComponentesProdVersionEs",bean);
        }
        catch (Exception e) 
        {
            LOGGER.warn("error", e);
        }
        return null;
    }
    public String seleccionarFormulaMaestraNuevoVersion_action(){
        try {
                FormulaMaestraVersion formulaMaestraVersion=new FormulaMaestraVersion();
                formulaMaestraVersion.setCodVersion(componentesProdVersionTransaccion.getCodFormulaMaestraVersion());
                formulaMaestraVersion.setCodFormulaMaestra(String.valueOf(componentesProdVersionTransaccion.getCodFormulaMaestra()));
                formulaMaestraVersion.setComponentesProd((ComponentesProd)componentesProdVersionTransaccion.clone());
                formulaMaestraVersion.setCantidadLote(componentesProdVersionTransaccion.getTamanioLoteProduccion());
                formulaMaestraVersion.getComponentesProd().setNroVersion(componentesProdVersionTransaccion.getNroVersion());
                formulaMaestraVersion.getComponentesProd().setCodVersion(componentesProdVersionTransaccion.getCodVersion());
                FacesContext facesContext = FacesContext.getCurrentInstance();
                ExternalContext externalContext = facesContext.getExternalContext();
                Map map = externalContext.getSessionMap();
                map.put("formulaMaestraVersion",formulaMaestraVersion);

        }
        catch (Exception e) {
        }
        return null;
    }
    public String seleccionarFormulaMaestraVersionProperty_action(){
        try {
                ComponentesProdVersion bean = componentesProdVersionBean;
                FormulaMaestraVersion formulaMaestraVersion=new FormulaMaestraVersion();
                formulaMaestraVersion.setCantidadLote(bean.getTamanioLoteProduccion());
                formulaMaestraVersion.setCodVersion(bean.getCodFormulaMaestraVersion());
                formulaMaestraVersion.setCodFormulaMaestra(String.valueOf(bean.getCodFormulaMaestra()));
                formulaMaestraVersion.setComponentesProd((ComponentesProd)bean.clone());
                formulaMaestraVersion.getComponentesProd().setNroVersion(bean.getNroVersion());
                formulaMaestraVersion.getComponentesProd().setCodVersion(bean.getCodVersion());
                FacesContext facesContext = FacesContext.getCurrentInstance();
                ExternalContext externalContext = facesContext.getExternalContext();
                Map map = externalContext.getSessionMap();
                map.put("formulaMaestraVersion",formulaMaestraVersion);
                
        }
        catch (Exception e) {
        }
        return null;
    }
    public String seleccionarFormulaMaestraVersion_action(){
        try {
                ComponentesProdVersion bean=(ComponentesProdVersion)componentesProdVersionDataTable.getRowData();
                FormulaMaestraVersion formulaMaestraVersion=new FormulaMaestraVersion();
                formulaMaestraVersion.setCantidadLote(bean.getTamanioLoteProduccion());
                formulaMaestraVersion.setCodVersion(bean.getCodFormulaMaestraVersion());
                formulaMaestraVersion.setCodFormulaMaestra(String.valueOf(bean.getCodFormulaMaestra()));
                formulaMaestraVersion.setComponentesProd((ComponentesProd)bean.clone());
                formulaMaestraVersion.getComponentesProd().setNroVersion(bean.getNroVersion());
                formulaMaestraVersion.getComponentesProd().setCodVersion(bean.getCodVersion());
                FacesContext facesContext = FacesContext.getCurrentInstance();
                ExternalContext externalContext = facesContext.getExternalContext();
                Map map = externalContext.getSessionMap();
                map.put("formulaMaestraVersion",formulaMaestraVersion);
                
        }
        catch (Exception e) {
        }
        return null;
    }
    //</editor-fold>
    
    //<editor-fold defaultstate="collapsed" desc="especificaciones fisicas">
    private void cargarTiposRefenciasCcSelect()
    {
        DaoTiposReferenciaCC daoTiposReferenciaCC = new DaoTiposReferenciaCC(LOGGER);
        tiposReferenciaCcSelect = daoTiposReferenciaCC.listarSelectItem();
     }
    private void cargarTiposEspecificacionesFisicasSelect()
    {
        DaoTiposEspecificacionesFisicas  daoTiposEspFisicas = new DaoTiposEspecificacionesFisicas(LOGGER);
        tiposEspecificacionesFisicasSelect = new ArrayList<>();
        tiposEspecificacionesFisicasSelect.add(new SelectItem(0,"-NINGUNO-"));
        tiposEspecificacionesFisicasSelect.addAll(daoTiposEspFisicas.listarSelectItem());
    }
    public String getCargarEspecificacionesFisicasProducto()
    {
        this.cargarTiposEspecificacionesFisicasSelect();
        this.cargarTiposRefenciasCcSelect();
        DaoEspecificacionesFisicasProducto daoEspecificacionesFisicasProducto = new DaoEspecificacionesFisicasProducto(LOGGER);
        especificacionesFisicasProductoList = daoEspecificacionesFisicasProducto.listarAgregarEditar(componentesProdVersionBean);
        return null;
    }

    public String guardarEspecificacionesFisicasProducto_action()throws SQLException
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
        DaoEspecificacionesFisicasProducto daoEspecificacionesFisicasProducto = new DaoEspecificacionesFisicasProducto(LOGGER);
        if(daoEspecificacionesFisicasProducto.guardarLista(especificacionesList)){
            mensaje  = "1";
        }
        else{
            mensaje = "Ocurrio un error al momento de guardar las especificaciones fisicas,intente de nuevo";
        }
        return null;
    }
    //</editor-fold>
    //<editor-fold defaultstate="collapsed" desc="especificaciones quimicas">
    private void cargarMaterialesPrincipioActivoVersion()
     {
         try
         {
             con=Util.openConnection(con);
             Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
             String consulta=" select isnull(m.NOMBRE_CCC,'Nombre genérico no registrado, comunicar a sistemas') as NOMBRE_CCC,m.COD_MATERIAL,ISNULL(eqp.ESTADO, 1) as estado"+
                             " from MATERIALES m inner join ESPECIFICACIONES_QUIMICAS_PRODUCTO eqp on eqp.COD_MATERIAL=m.COD_MATERIAL"+
                             " where eqp.COD_VERSION = '"+componentesProdVersionBean.getCodVersion()+"'" +
                             " and eqp.COD_PRODUCTO='"+componentesProdVersionBean.getCodCompprod()+"'"+
                             " group by m.NOMBRE_CCC,m.COD_MATERIAL,eqp.ESTADO order by m.NOMBRE_CCC";
             LOGGER.debug("consulta materiales principio activo "+consulta);
             ResultSet res=st.executeQuery(consulta);
             listaMaterialesPrincipioActivo.clear();
             String codMaterialesPrincipioActivo="";
             while(res.next())
             {
                Materiales bean= new Materiales();
                bean.setCodMaterial(res.getString("COD_MATERIAL"));
                codMaterialesPrincipioActivo+=(codMaterialesPrincipioActivo.equals("")?"":",")+res.getString("COD_MATERIAL");
                bean.setNombreMaterial(res.getString("NOMBRE_CCC"));
                bean.getEstadoRegistro().setCodEstadoRegistro(res.getString("estado"));
                if(listaMaterialesPrincipioActivo.size()>0)
                {
                    if(listaMaterialesPrincipioActivo.get(listaMaterialesPrincipioActivo.size()-1).getCodMaterial().equals(bean.getCodMaterial()))
                    {
                        listaMaterialesPrincipioActivo.get(listaMaterialesPrincipioActivo.size()-1).getEstadoRegistro().setCodEstadoRegistro("3");
                    }

                    else
                    {
                        listaMaterialesPrincipioActivo.add(bean);
                    }
                }
                else
                {
                listaMaterialesPrincipioActivo.add(bean);
                }
             }
             codMaterialCompuestoCC="";
             if(!codMaterialesPrincipioActivo.equals(""))
             {
                 consulta="select DISTINCT m.COD_MATERIAL_COMPUESTO_CC from MATERIALES_COMPUESTOS_CC m"+
                          " where m.COD_MATERIAL_1 in ("+codMaterialesPrincipioActivo+") and m.COD_MATERIAL_2 in (" +
                          codMaterialesPrincipioActivo+") and m.COD_MATERIAL_1 <> m.COD_MATERIAL_2";
                 LOGGER.debug("consulta buscar materiales compuestos "+consulta);
                 res=st.executeQuery(consulta);
                 while(res.next())
                 {
                     codMaterialCompuestoCC+=(codMaterialCompuestoCC.equals("")?"":",")+res.getString("COD_MATERIAL_COMPUESTO_CC");
                 }
             }

             res.close();
             st.close();
             con.close();
         }
         catch(SQLException ex)
         {
             LOGGER.warn("error", ex);
         }
     }
    public String getCargarEspecificacionesQuimicasProducto()
    {
        DaoEspecificacionesQuimicasProducto daoEspQuimicas = new DaoEspecificacionesQuimicasProducto(LOGGER);
        especificacionesQuimicasProductoList = daoEspQuimicas.listarPorEspecificacionQuimicaCC(componentesProdVersionBean);
        this.cargarTiposRefenciasCcSelect();
        return null;
     }
     public String guardarEspecificacionesQuimicas_action() throws SQLException
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

    //<editor-fold defaultstate="collapsed" desc="especificaciones microbiologicas">
    public String getCargarEspecificacionesMicrobiologicasProducto()
    {
        DaoEspecificacionesMicrobiologiaProducto daoEspMicro = new DaoEspecificacionesMicrobiologiaProducto(LOGGER);
        especificacionesMicrobiologiaProductoList = daoEspMicro.listarAgregarEditar(componentesProdVersionBean);
        this.cargarTiposRefenciasCcSelect();
        return null;
    }

    public String guardarEspecificacionesMicrobiologicasProducto_action()throws SQLException
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
    //</editor-fold>
    //para componentesPresProd
    public List<Producto> productosAutoCompletar_action(Object str)
    {
        List<Producto> listaProductos=new ArrayList<Producto>();
        try {
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            String consulta = "select p.cod_prod,p.nombre_prod from PRODUCTOS p where p.nombre_prod like '%"+str.toString().trim()+"%'";
            ResultSet res = st.executeQuery(consulta);
            while (res.next())
            {
                Producto nuevo=new Producto();
                nuevo.setCodProducto(res.getString("cod_prod"));
                nuevo.setNombreProducto(res.getString("nombre_prod"));
                listaProductos.add(nuevo);
            }
            res.close();
            st.close();
            con.close();
        }
        catch (SQLException ex)
        {
            LOGGER.warn("error", ex);
        }
        return listaProductos;
    }
    private void cargarCondicionesVentasSelect()
    {
        try {
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            String consulta = "select cvp.COD_CONDICION_VENTA_PRODUCTO,cvp.NOMBRE_CONDICION_VENTA_PRODUCTO"+
                              " from CONDICIONES_VENTA_PRODUCTO cvp"+
                              " order by cvp.NOMBRE_CONDICION_VENTA_PRODUCTO";
            ResultSet res = st.executeQuery(consulta);
            condicionesVentasSelectList=new ArrayList<SelectItem>();
            while (res.next())
            {
                condicionesVentasSelectList.add(new SelectItem(res.getInt("COD_CONDICION_VENTA_PRODUCTO"),res.getString("NOMBRE_CONDICION_VENTA_PRODUCTO")));
            }
            res.close();
            st.close();
            con.close();
        } catch (SQLException ex) {
            LOGGER.warn("error", ex);
        }
    }
    public String eliminarComponentesPresProd_action()throws SQLException
    {
        mensaje="";
        for(ComponentesPresProd bean:componentesPresProdList)
        {
            if(bean.getChecked())
            {
                try {
                    con = Util.openConnection(con);
                    con.setAutoCommit(false);
                    String consulta = "delete COMPONENTES_PRESPROD_VERSION where COD_VERSION='"+componentesProdVersionBean.getCodVersion()+"'" +
                                      " and  COD_COMPPROD='"+componentesProdVersionBean.getCodCompprod()+"'" +
                                      " and COD_PRESENTACION='"+bean.getPresentacionesProducto().getCodPresentacion()+"'" +
                                      " and COD_TIPO_PROGRAMA_PROD='"+bean.getTiposProgramaProduccion().getCodTipoProgramaProd()+"'";
                    LOGGER.debug("consulta eliminar componentes pres prod "+consulta);
                    PreparedStatement pst = con.prepareStatement(consulta);
                    if (pst.executeUpdate() > 0)LOGGER.info("se elimino la presentacion");
                    con.commit();
                    mensaje="1";
                    pst.close();
                    con.close();
                } 
                catch (SQLException ex)
                {
                    con.rollback();
                    con.close();
                    mensaje="Ocurrio un error al momento de eliminar la presentación, intente de nuevo";
                    LOGGER.warn("error", ex);
                }
            }
        }
        if(mensaje.equals("1"))
        {
            this.cargarComponentesPresProdVersionList();
        }
        return null;
    }

    public String editarComponentesPresProd_action()
    {
        for(ComponentesPresProd bean:componentesPresProdList)
        {
            if(bean.getChecked())
            {
                componentesPresProdEditar=bean;
            }
        }
        return null;
    }
    public String guardarEdicionComponentesPresProd_action()throws SQLException
    {
        mensaje="";
        try
        {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            String consulta =" update COMPONENTES_PRESPROD_VERSION set CANT_COMPPROD='"+((int)componentesPresProdEditar.getCantCompProd())+"'," +
                             " COD_ESTADO_REGISTRO='"+componentesPresProdEditar.getEstadoReferencial().getCodEstadoRegistro()+"'"+
                             " where COD_VERSION='"+componentesProdVersionBean.getCodVersion()+"'" +
                             " and COD_COMPPROD='"+componentesProdVersionBean.getCodCompprod()+"'" +
                             " and COD_PRESENTACION='"+componentesPresProdEditar.getPresentacionesProducto().getCodPresentacion()+"'" +
                             " and COD_TIPO_PROGRAMA_PROD='"+componentesPresProdEditar.getTiposProgramaProduccion().getCodTipoProgramaProd()+"'";
            LOGGER.debug("consulta guardar edicion "+consulta);
            PreparedStatement pst = con.prepareStatement(consulta);
            if (pst.executeUpdate() > 0)LOGGER.info("se guardo la edicion");
            con.commit();
            mensaje="1";
            pst.close();
            con.close();
        } 
        catch (SQLException ex)
        {
            con.rollback();
            con.close();
            mensaje="Ocurrio un error al momento de guardar la edicion,intente de nuevo";
            LOGGER.warn("error", ex);
        }
        return null;
    }
    public String guardarNuevoComponentesPresProd_action()throws SQLException
    {
        mensaje="";
        try
        {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            String consulta = "INSERT INTO COMPONENTES_PRESPROD_VERSION(COD_VERSION, COD_COMPPROD,"+
                              "COD_PRESENTACION, CANT_COMPPROD, COD_TIPO_PROGRAMA_PROD, COD_ESTADO_REGISTRO)"+
                              " VALUES ('"+componentesProdVersionBean.getCodVersion()+"','"+componentesProdVersionBean.getCodCompprod()+"'," +
                              "'"+componentesPresProdAgregar.getPresentacionesProducto().getCodPresentacion()+"'," +
                              "'"+((int)componentesPresProdAgregar.getCantCompProd())+"',"+
                              "'"+componentesPresProdAgregar.getTiposProgramaProduccion().getCodTipoProgramaProd()+"',1);";
            LOGGER.debug("consulta insertar componentespresProd "+consulta);
            PreparedStatement pst = con.prepareStatement(consulta);
            if (pst.executeUpdate() > 0)LOGGER.info("se registro componentes pres prod");
            con.commit();
            mensaje="1";
            pst.close();
            con.close();
        } catch (SQLException ex) {
            con.rollback();
            con.close();
            mensaje="Ocurrio un error al momento de guardar el registro, intente de nuevo";
            LOGGER.warn("error", ex);
        }
        return null;
    }
    public String getCargarComponentesPresProdAgregar()
    {
        componentesPresProdAgregar=new ComponentesPresProd();
        return null;
    }

    
    
    private void cargarPresentacionesProductoSelect()
    {
        try
        {
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            String consulta = "select p.cod_presentacion,p.NOMBRE_PRODUCTO_PRESENTACION"+
                              " from PRESENTACIONES_PRODUCTO p where p.cod_estado_registro=1" +
                              //" and p.cod_prod='"+componentesProdVersionBean.getProducto().getCodProducto()+"'"+
                              " order by p.NOMBRE_PRODUCTO_PRESENTACION";
            ResultSet res = st.executeQuery(consulta);
            presentacionesProductoSelectList.clear();
            while (res.next())
            {
                presentacionesProductoSelectList.add(new SelectItem(res.getString("cod_presentacion"),res.getString("NOMBRE_PRODUCTO_PRESENTACION")));
            }
            res.close();
            st.close();
            con.close();
        }
        catch (SQLException ex) {
            LOGGER.warn("error", ex);
        }
    }
    public String agregarComponentesPresProdVersion_action()
    {
        componentesPresProdAgregar=new ComponentesPresProd();
        return null;
    }
    public String getCargarComponentesPresProdVersionList()
    {
        this.cargarComponentesPresProdVersionList();
        this.cargarTiposProgramaProduccionSelectList();
        this.cargarPresentacionesProductoSelect();
        return null;
    }
    private void cargarComponentesPresProdVersionList()
    {
        try
        {
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            String consulta = "select cpv.CANT_COMPPROD,pp.cod_presentacion,pp.NOMBRE_PRODUCTO_PRESENTACION,"+
                              " tpp.COD_TIPO_PROGRAMA_PROD,tpp.NOMBRE_TIPO_PROGRAMA_PROD" +
                              " ,er.COD_ESTADO_REGISTRO,er.NOMBRE_ESTADO_REGISTRO"+
                              " from COMPONENTES_PRESPROD_VERSION cpv inner join PRESENTACIONES_PRODUCTO pp on "+
                              " cpv.COD_PRESENTACION=pp.cod_presentacion "+
                              " inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=cpv.COD_TIPO_PROGRAMA_PROD" +
                              " inner join ESTADOS_REFERENCIALES er on er.COD_ESTADO_REGISTRO=cpv.COD_ESTADO_REGISTRO"+
                              " where cpv.COD_VERSION='"+componentesProdVersionBean.getCodVersion()+"'" +
                              " and cpv.COD_COMPPROD='"+componentesProdVersionBean.getCodCompprod()+"'"+
                              " order by tpp.NOMBRE_TIPO_PROGRAMA_PROD";
            LOGGER.debug("consulta cargar componentes presprod "+consulta);
            ResultSet res = st.executeQuery(consulta);
            componentesPresProdList.clear();
            while (res.next())
            {
                ComponentesPresProd nuevo=new ComponentesPresProd();
                nuevo.setCantCompProd(res.getFloat("CANT_COMPPROD"));
                nuevo.getPresentacionesProducto().setCodPresentacion(res.getString("cod_presentacion"));
                nuevo.getPresentacionesProducto().setNombreProductoPresentacion(res.getString("NOMBRE_PRODUCTO_PRESENTACION"));
                nuevo.getTiposProgramaProduccion().setCodTipoProgramaProd(res.getString("COD_TIPO_PROGRAMA_PROD"));
                nuevo.getTiposProgramaProduccion().setNombreTipoProgramaProd(res.getString("NOMBRE_TIPO_PROGRAMA_PROD"));
                nuevo.getEstadoReferencial().setCodEstadoRegistro(res.getString("COD_ESTADO_REGISTRO"));
                nuevo.getEstadoReferencial().setNombreEstadoRegistro(res.getString("NOMBRE_ESTADO_REGISTRO"));
                componentesPresProdList.add(nuevo);
            }
            res.close();
            st.close();
            con.close();
        } catch (SQLException ex) {
            LOGGER.warn("error", ex);
        }
    }
    //para versiones nuevas
    public String agregarPersonalNuevoProducto_action()throws SQLException
    {
        mensaje="";
        this.agregarPersonalVersion(componentesProdVersionTransaccion);
        if(mensaje.equals("1"))
        {
            this.cargarComponentesProdVersionNuevo_action();
        }
        return null;
    }
    public String sinNecesidadCambiosNuevoProducto_action()throws SQLException
    {
        mensaje="";
        for(ComponentesProdVersion bean:componentesProdVersionNuevoList)
        {
            if(bean.getChecked())
            {
                this.sinNecesidadDeCambios(bean);
                break;
            }

        }
        if(mensaje.equals("1"))
        {
            this.cargarComponentesProdVersionNuevo_action();
        }
        return null;
    }
    public String enviarAAprobacionNuevoProducto_action()throws SQLException
    {
        mensaje="";
        
        this.enviarAprobacionVersionProducto(componentesProdVersionTransaccion);
         if(mensaje.equals("1"))
        {
            this.cargarComponentesProdVersionNuevo_action();
        }
        return null;
    }
    public String seleccionarNuevoComponenteProdVersion_action()
    {
        componentesProdVersionBean=(ComponentesProdVersion)componentesProdVersionNuevoDataTable.getRowData();
        return null;
    }
    public String editarNuevoComponenteProdVersion_action()
    {
        for(ComponentesProdVersion bean:componentesProdVersionNuevoList)
        {
            if(bean.getChecked())
            {
                componentesProdVersionEditar=bean;
                break;
            }
        }
        return null;
    }
    public String guardarNuevoComponenteProdVersion_action()throws SQLException
    {
        LOGGER.debug("--------------------------------------INICIO REGISTRAR NUEVO PRODUCTO---------------------------------------");
        mensaje="";
        try {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta=new StringBuilder("select isnull(min(cp.COD_COMPPROD),0)-1 as codComprod from COMPONENTES_PROD_VERSION cp");
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta.toString());
            int codCompProd=-1;
            if(res.next())codCompProd=res.getInt("codComprod");
            if(codCompProd>=0)codCompProd=-1;
            int codVersion=0;
            PreparedStatement pst=null;
            SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
            consulta = new StringBuilder("INSERT INTO COMPONENTES_PROD_VERSION(COD_COMPPROD,COD_PROD,COD_FORMA,COD_SABOR,NOMBRE_GENERICO,");
                      consulta.append(" REG_SANITARIO,FECHA_VENCIMIENTO_RS,VIDA_UTIL,PRODUCTO_SEMITERMINADO,CONCENTRACION_ENVASE_PRIMARIO");
                      consulta.append(",NRO_VERSION,FECHA_MODIFICACION,COD_ESTADO_VERSION,COD_ESTADO_COMPPROD,NOMBRE_COMERCIAL,COD_CONDICION_VENTA_PRODUCTO,");
                      consulta.append("PRESENTACIONES_REGISTRADAS_RS,COD_TIPO_PRODUCCION,COD_TIPO_MODIFICACION_PRODUCTO,APLICA_ESPECIFICACIONES_FISICAS,")
                              .append(" APLICA_ESPECIFICACIONES_QUIMICAS,APLICA_ESPECIFICACIONES_MICROBIOLOGICAS,COD_TIPO_COMPONENTES_PROD_VERSION)");
                      consulta.append(" VALUES (");
                                consulta.append("'").append(codCompProd).append("',");
                                consulta.append("'").append(componentesProdVersionNuevo.getProducto().getCodProducto()).append("',");
                                consulta.append("'").append(componentesProdVersionNuevo.getForma().getCodForma()).append("',");
                                consulta.append("'").append(componentesProdVersionNuevo.getSaboresProductos().getCodSabor()).append("',");
                                consulta.append("'").append(componentesProdVersionNuevo.getNombreGenerico()).append("'");
                                consulta.append(",'").append(componentesProdVersionNuevo.getRegSanitario()).append("',");
                                consulta.append(componentesProdVersionNuevo.getFechaVencimientoRS()!=null?("'"+sdf.format(componentesProdVersionNuevo.getFechaVencimientoRS())+"'"):"null");
                                consulta.append(",'").append(componentesProdVersionNuevo.getVidaUtil()).append("',");
                                consulta.append("'").append(componentesProdVersionNuevo.isProductoSemiterminado()?1:0).append("'");
                                consulta.append(",'").append(componentesProdVersionNuevo.getConcentracionEnvasePrimario()).append("'");
                                consulta.append(",1,");
                                consulta.append("'").append(sdf.format(new Date())).append("',1,1,");
                                consulta.append("'").append(componentesProdVersionNuevo.getNombreComercial()).append("',");
                                consulta.append("'").append(componentesProdVersionNuevo.getCondicionesVentasProducto().getCodCondicionVentaProducto()).append("',?,1,");
                                consulta.append(componentesProdVersionNuevo.getTiposModificacionProducto().getCodTipoModificacionProducto()).append(",");
                                consulta.append("1,1,1");//aplica especificaciones fisicas, quimicas, microbiologicas
                                consulta.append(",1");
                      consulta.append(")");
                      
            LOGGER.debug("consulta insertar nuevo productos semiterminado "+consulta.toString());
            pst= con.prepareStatement(consulta.toString(),PreparedStatement.RETURN_GENERATED_KEYS);
            pst.setString(1,componentesProdVersionNuevo.getPresentacionesRegistradasRs());
            if (pst.executeUpdate() > 0)LOGGER.info("se registro el nuevo producto");
            res=pst.getGeneratedKeys();
            if(res.next())codVersion=res.getInt(1);
            consulta=new StringBuilder("INSERT INTO COMPONENTES_PROD_CONCENTRACION(COD_COMPPROD, COD_MATERIAL,");
            consulta.append(" CANTIDAD, COD_UNIDAD_MEDIDA, UNIDAD_PRODUCTO, COD_ESTADO_REGISTRO");
            consulta.append(",CANTIDAD_EQUIVALENCIA,NOMBRE_MATERIAL_EQUIVALENCIA,COD_UNIDAD_MEDIDA_EQUIVALENCIA,COD_VERSION,EXCIPIENTE)");
            consulta.append(" VALUES (?,?,?,?,?,?,?,?,?,?,?)");
            LOGGER.debug("consulta insertar material concentracion "+consulta.toString());
            PreparedStatement pstMaterial=con.prepareStatement(consulta.toString());
            for(ComponentesProdConcentracion bean : componentesProdVersionNuevo.getComponentesProdConcentracionList())
            {
                pstMaterial.setInt(1,codCompProd);
                pstMaterial.setString(2,bean.getMateriales().getCodMaterial());
                pstMaterial.setDouble(3,bean.getCantidad());
                pstMaterial.setString(4,bean.getUnidadesMedida().getCodUnidadMedida());
                pstMaterial.setString(5,componentesProdConcentracionBean.getUnidadProducto());
                pstMaterial.setString(6,"1");
                pstMaterial.setDouble(7,bean.getCantidadEquivalencia());
                pstMaterial.setString(8,bean.getNombreMaterialEquivalencia());
                pstMaterial.setString(9,bean.getUnidadMedidaEquivalencia().getCodUnidadMedida());
                pstMaterial.setInt(10, codVersion);
                pstMaterial.setInt(11,(bean.isExcipiente()?1:0));
                if(pstMaterial.executeUpdate()>0)LOGGER.info("se registro material concentracion");
            }
            consulta = new StringBuilder(" exec PAA_ACTUALIZACION_CONCENTRACION_PRODUCTO ").append(codVersion);
            LOGGER.debug("consulta actualizar la concentracion "+consulta.toString());
            pst = con.prepareStatement(consulta.toString());
            if(pst.executeUpdate() > 0)LOGGER.info("Se actualizo la concentracion");
            pstMaterial.close();
            pstMaterial=null;
            ManagedAccesoSistema managed=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
             consulta=new StringBuilder("INSERT INTO COMPONENTES_PROD_VERSION_MODIFICACION(COD_PERSONAL, COD_VERSION,");
             consulta.append(" COD_ESTADO_VERSION_COMPONENTES_PROD,FECHA_INCLUSION_VERSION,FECHA_ASIGNACION,COD_TIPO_PERMISO_ESPECIAL_ATLAS)"); 
             consulta.append(" VALUES (")
                    .append("'").append(managed.getUsuarioModuloBean().getCodUsuarioGlobal()).append("',");
                        consulta.append("'").append(codVersion).append("',")
                                .append(COD_ESTADO_MODIFICACION_REGISTRADO).append(",")
                                .append("GETDATE(),")
                                .append("GETDATE(),")
                                .append(COD_TIPO_PERMISO_GESTION_INFO_REGENCIA)
                            .append(")");
            LOGGER.debug("consulta insertar usuario modificacion "+consulta.toString());
            pst=con.prepareStatement(consulta.toString());
            if(pst.executeUpdate()>0)LOGGER.info("se registro el personal para la modificacion");
             consulta=new StringBuilder("INSERT INTO COMPONENTES_PROD_VERSION_MODIFICACION(COD_PERSONAL, COD_VERSION,")
                                        .append(" COD_ESTADO_VERSION_COMPONENTES_PROD,FECHA_INCLUSION_VERSION,")
                                        .append(" FECHA_ASIGNACION,COD_TIPO_PERMISO_ESPECIAL_ATLAS)")
                                .append("SELECT c.COD_PERSONAL,").append(codVersion).append(",")
                                            .append(COD_ESTADO_MODIFICACION_ASIGNADO).append(",GETDATE(),")
                                            .append("GETDATE(),c.COD_TIPO_PERMISO_ESPECIAL_ATLAS")
                                .append(" FROM CONFIGURACION_PERMISOS_ESPECIALES_ATLAS c")
                                .append(" where c.COD_TIPO_PERMISO_ESPECIAL_ATLAS = ").append(componentesProdVersionNuevo.getTiposModificacionProducto().getCodTipoModificacionProducto() == 1 ?COD_TIPO_PERMISO_GESTION_DESARROLLO : COD_TIPO_PERMISO_GESTION_DIRECCION_TECNICA);
             LOGGER.debug("consulta asignar version personal: "+consulta.toString());
             pst = con.prepareStatement(consulta.toString());
             if(pst.executeUpdate() > 0)LOGGER.info("se registraron personas");
                                
            int codVersionFm=0;
            int codFormulaMaestra=0;
            consulta=new StringBuilder("select isnull(min(f.COD_FORMULA_MAESTRA),0)-1 as codFormulaMaestra from FORMULA_MAESTRA_VERSION f");
            res=st.executeQuery(consulta.toString());
            if(res.next())codFormulaMaestra=res.getInt("codFormulaMaestra");
            if(codFormulaMaestra>0)codFormulaMaestra=-1;
            consulta=new StringBuilder("INSERT INTO FORMULA_MAESTRA_VERSION(COD_FORMULA_MAESTRA,COD_COMPPROD, CANTIDAD_LOTE, ESTADO_SISTEMA,");
                     consulta.append(" COD_ESTADO_REGISTRO, NRO_VERSION,FECHA_MODIFICACION, COD_ESTADO_VERSION_FORMULA_MAESTRA, FECHA_INICIO_VIGENCIA,");
                     consulta.append(" COD_PERSONAL_CREACION, COD_TIPO_MODIFICACION_FORMULA, COD_COMPPROD_VERSION,MODIFICACION_NF, MODIFICACION_MP_EP, MODIFICACION_ES, MODIFICACION_R)");
                     consulta.append(" VALUES ('").append(codFormulaMaestra).append("','").append(codCompProd).append("',0,1,1,'1','").append(sdf.format(new Date())).append("',");
                     consulta.append("1, null,'").append(managed.getUsuarioModuloBean().getCodUsuarioGlobal()).append("',1,'").append(codVersion).append("',1,1, 1, 1)");
            LOGGER.debug("consulta registrar formula maestra version "+consulta.toString());
            pst=con.prepareStatement(consulta.toString());
            if(pst.executeUpdate()>0)LOGGER.info("se registro la version de fm");
            consulta=new StringBuilder("INSERT INTO FORMULA_MAESTRA_ES_VERSION(OBSERVACION, COD_PERSONAL, FECHA_CREACION,COD_VERSION,COD_ESTADO_VERSION, NRO_VERSION)");
                consulta.append(" VALUES (");
                    consulta.append("'Nuevo Producto',");//nuevo producto
                    consulta.append("0,");//cod personal registra 0
                    consulta.append("GETDATE(),");//fecha registro
                    consulta.append(codVersion).append(",");
                    consulta.append("1,");//estado registrado
                    consulta.append("0");//version iniciar 0
                consulta.append(")");
            LOGGER.debug("consulta registro version es"+consulta.toString());
            pst=con.prepareStatement(consulta.toString());
            if(pst.executeUpdate()>0)LOGGER.info("se registro la verison  de es");
            con.commit();
            mensaje="1";
            pst.close();
            con.close();
        } 
        catch (SQLException ex)
        {
            con.rollback();
            con.close();
            mensaje="Ocurrio un error al momento de guardar el nuevoa producto, intente de nuevo";
            LOGGER.warn("error", ex);
        }
        LOGGER.debug("--------------------------------------TERMINO REGISTRAR NUEVO PRODUCTO---------------------------------------");
        return null;
    }
    public String getCargarAgregarComponentesProdVersionNuevo()
    {
        componentesProdVersionNuevo=new ComponentesProdVersion();
        componentesProdVersionNuevo.getTiposModificacionProducto().setCodTipoModificacionProducto(1);
        componentesProdVersionNuevo.setAplicaEspecificacionesFisicas(true);
        componentesProdVersionNuevo.setAplicaEspecificacionesMicrobiologicas(true);
        componentesProdVersionNuevo.setAplicaEspecificacionesQuimicas(true);
        componentesProdVersionNuevo.setComponentesProdConcentracionList(new ArrayList<>());
        componentesProdConcentracionBean = new ComponentesProdConcentracion();
        unidadesProducto = componentesProdConcentracionBean.getUnidadProducto();
        this.cargarProductosSelectList();
        return null;
    }
    // <editor-fold defaultstate="collapsed" desc="funciones generales">
    //funcion para eliminar la version de un producto
    private void eliminarComponentesProdVersion(ComponentesProdVersion bean)throws SQLException
    {
        mensaje="";
        try 
        {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta=new StringBuilder("exec PAA_ELIMINAR_COMPONENTES_PROD_VERSION ");
                                    consulta.append(bean.getCodVersion()).append(",");
                                    consulta.append(bean.getCodCompprod());
            LOGGER.debug("consulta eliminar version de producto "+consulta.toString());
            PreparedStatement pst=con.prepareStatement(consulta.toString());
            if(pst.executeUpdate()>0)LOGGER.info("se elimino la version de producto");
            con.commit();
            mensaje="1";
        }
        catch (SQLException ex) 
        {
            mensaje="Ocurrio un error al momento de eliminar la version. "+ex.getMessage();
            con.rollback();
            LOGGER.warn(ex.getMessage());
        } catch (Exception ex) 
        {
            mensaje="Ocurrio un error al momento de eliminar el producto";
            LOGGER.warn(ex.getMessage());
        } 
        finally 
        {
            this.cerrarConexion(con);
        }   
    }
    //funcion para registrar sin necesidad de cambios para un personal de version
    private void sinNecesidadDeCambios(ComponentesProdVersion bean)throws SQLException
    {
        mensaje="";
        try 
        {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            
            ManagedAccesoSistema managed=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
            StringBuilder consulta = new StringBuilder("EXEC PAA_REGISTRO_ENVIO_REVISION_VERSION_COMPONENTES_PROD_VERSION ");
                                        consulta.append(bean.getCodVersion()).append(",");
                                        consulta.append(managed.getUsuarioModuloBean().getCodUsuarioGlobal()).append(",");
                                        consulta.append(7);//sin necesidad de cambios
            LOGGER.debug("consulta registrar sin necesidad de cambios "+consulta.toString());
            PreparedStatement pst=con.prepareStatement(consulta.toString());
            pst.executeUpdate();
            con.commit();
            mensaje="1";
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
        
    }
    //funcion para añadirse a version
    private void agregarPersonalVersion(ComponentesProdVersion bean)throws SQLException
    {
        mensaje="";
        try 
        {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            ManagedAccesoSistema managed=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
            SimpleDateFormat sdf= new SimpleDateFormat("yyyy/MM/dd HH:mm");
            StringBuilder consulta=new StringBuilder("select count(*) as cont");
                                   consulta.append(" from COMPONENTES_PROD_VERSION_MODIFICACION c");
                                   consulta.append(" where c.COD_PERSONAL = ").append(managed.getUsuarioModuloBean().getCodUsuarioGlobal());
                                       consulta.append(" and c.COD_VERSION = ").append(bean.getCodVersion())
                                               .append(" and c.COD_ESTADO_VERSION_COMPONENTES_PROD = 1 ");
            LOGGER.debug("consulta verificar no registrado : "+consulta);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta.toString());
            res.next();
            if(res.getInt("cont")==0){
                consulta=new StringBuilder("exec PAA_REGISTRO_AGREGAR_COMPONENTES_PROD_VERSION_MODIFICACION ");
                            consulta.append(bean.getCodVersion()).append(",");//codVersion
                            consulta.append(managed.getUsuarioModuloBean().getCodUsuarioGlobal());//codPersonal
                LOGGER.debug("consulta agregar componentes prod version modificacion "+consulta.toString());
                PreparedStatement pst=con.prepareStatement(consulta.toString());
                if(pst.executeUpdate()>0)LOGGER.info("se registro la adicion a componentes prod version modificacion");
                mensaje="1";
            }
            else
            {
                mensaje="Ya se encuentra registrado como colaborador(a) de la version";
            }
            con.commit();
            
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
    }
    //funcion para enviar a aprobacion versiones de producto nuevos productos,tamanios de lote y reformulados
    private void enviarAprobacionVersionProducto(ComponentesProdVersion bean)throws SQLException
    {
        mensaje = "";
        try 
        {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            ManagedAccesoSistema managed=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
            StringBuilder consulta = new StringBuilder("EXEC PAA_REGISTRO_ENVIO_REVISION_VERSION_COMPONENTES_PROD_VERSION ");
                                        consulta.append(bean.getCodVersion()).append(",");
                                        consulta.append(managed.getUsuarioModuloBean().getCodUsuarioGlobal()).append(",");
                                        consulta.append(3);//enviado a aprobacion
            LOGGER.debug(" consulta enviar a aprobacion "+consulta.toString());
            PreparedStatement pst=con.prepareStatement(consulta.toString());
            pst.executeUpdate();
            
            con.commit();
            mensaje="1";
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
        
    }
    //</editor-fold>
    // <editor-fold defaultstate="collapsed" desc="Nuevos tamanios de Lotes de produccion">
    public String crearNuevoTamanioLoteProduccion()throws SQLException
    {
        transaccionExitosa = false;
        try 
        {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            ManagedAccesoSistema managed=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
            int codVersion=0;
            int codCompProd=0;
            int codFormulaMaestra=0;
            SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm");
            StringBuilder consulta=new StringBuilder("select isnull(min(cp.COD_COMPPROD),0)-1 as codComprod");
                                       consulta.append(" from COMPONENTES_PROD_VERSION cp");
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta.toString());
            if(res.next())codCompProd=res.getInt("codComprod");
            consulta=new StringBuilder(" select isnull(min(f.COD_FORMULA_MAESTRA),0)-1 as codFormulaMaestra");
                        consulta.append(" from FORMULA_MAESTRA_version f");
            res=st.executeQuery(consulta.toString());
            if(res.next())codFormulaMaestra=res.getInt("codFormulaMaestra");
            consulta = new StringBuilder(" exec PAA_GENERACION_NUEVA_VERSION_PRODUCTO ");
                                        consulta.append(componentesProdBean.getCodCompprod()).append(",");
                                        consulta.append("1,");//version de producto
                                        consulta.append(codCompProd).append(",");
                                        consulta.append(codFormulaMaestra).append(",?");
                                        
            LOGGER.debug("consulta crear version producto "+consulta.toString());
            CallableStatement callVersionCopia=con.prepareCall(consulta.toString());
            callVersionCopia.registerOutParameter(1,java.sql.Types.INTEGER);
            callVersionCopia.execute();
            codVersion = callVersionCopia.getInt(1);
            // <editor-fold defaultstate="collapsed" desc="duplicando actividades de formula maestra">
                consulta = new StringBuilder("INSERT INTO dbo.ACTIVIDADES_FORMULA_MAESTRA(COD_FORMULA_MAESTRA, COD_ACTIVIDAD, ORDEN_ACTIVIDAD, COD_AREA_EMPRESA,")
                                            .append(" COD_ESTADO_REGISTRO, COD_PRESENTACION, COD_TIPO_PROGRAMA_PROD)")
                                    .append(" Select ").append(codFormulaMaestra).append(",")
                                            .append(" afm.COD_ACTIVIDAD,max(afm.ORDEN_ACTIVIDAD),afm.COD_AREA_EMPRESA,")
                                            .append(" afm.COD_ESTADO_REGISTRO,afm.COD_PRESENTACION,afm.COD_TIPO_PROGRAMA_PROD")
                                    .append(" from ACTIVIDADES_FORMULA_MAESTRA afm")
                                            .append(" INNER JOIN FORMULA_MAESTRA fm on afm.COD_FORMULA_MAESTRA=fm.COD_FORMULA_MAESTRA")
                                                    .append(" and FM.COD_ESTADO_REGISTRO=1")
                                    .append(" where fm.COD_COMPPROD = ").append(componentesProdBean.getCodCompprod())
                                            .append(" and afm.COD_ESTADO_REGISTRO = 1")
                                    .append(" group by afm.COD_ACTIVIDAD,afm.COD_AREA_EMPRESA,")
                                            .append(" afm.COD_ESTADO_REGISTRO,afm.COD_PRESENTACION,afm.COD_TIPO_PROGRAMA_PROD");
                                            
                LOGGER.debug("consulta registrar actividades "+consulta.toString());
                PreparedStatement pst=con.prepareStatement(consulta.toString());
                if(pst.executeUpdate()>0)LOGGER.info("se registraron las actividades");
            //</editor-fold>
            // <editor-fold defaultstate="collapsed" desc="asociando personal">
                consulta=new StringBuilder("INSERT INTO COMPONENTES_PROD_VERSION_MODIFICACION(COD_PERSONAL, COD_VERSION,COD_ESTADO_VERSION_COMPONENTES_PROD,")
                                        .append(" FECHA_INCLUSION_VERSION,COD_TIPO_PERMISO_ESPECIAL_ATLAS,FECHA_ASIGNACION)")
                                .append(" VALUES (")
                                        .append("?,")
                                        .append(codVersion).append(",")
                                        .append("?,")//COD ESTADO VERSION ASIGNACION
                                        .append("?,")//fecha inclusion
                                        .append("?,")
                                        .append("getdate()")
                                .append(")");
            LOGGER.debug("consulta insertar usuario modificacion "+consulta);
            pst=con.prepareStatement(consulta.toString());
            for(ComponentesProdVersionModificacion bean :  componentesProdVersionModificacionList){
                pst.setString(1, bean.getPersonal().getCodPersonal());LOGGER.info("p1: "+bean.getPersonal().getCodPersonal());
                int codEstadoModificacion = bean.getPersonal().getCodPersonal().equals(managed.getUsuarioModuloBean().getCodUsuarioGlobal())?COD_ESTADO_MODIFICACION_REGISTRADO :  COD_ESTADO_MODIFICACION_ASIGNADO;
                pst.setInt(2, codEstadoModificacion);LOGGER.info("p2: "+codEstadoModificacion);
                Date fechaInclusionVersion =  (bean.getPersonal().getCodPersonal().equals(managed.getUsuarioModuloBean().getCodUsuarioGlobal()) ? new Date() : null);
                pst.setTimestamp(3,Util.fechaParametro(fechaInclusionVersion));LOGGER.info("p3: "+fechaInclusionVersion);
                pst.setInt(4,bean.getTiposPermisosEspecialesAtlas().getCodTipoPermisoEspecialAtlas());LOGGER.info("p4: "+bean.getTiposPermisosEspecialesAtlas().getCodTipoPermisoEspecialAtlas());
                if(pst.executeUpdate()>0)LOGGER.info("se registro la colaboracion ");
            }
            //</editor-fold>
            // <editor-fold defaultstate="collapsed" desc="cambiando cantida de tamanio de lote y recalculando cantidades">
                consulta=new StringBuilder(" UPDATE COMPONENTES_PROD_VERSION");
                            consulta.append(" SET TAMANIO_LOTE_PRODUCCION=").append(nuevoTamanioLoteProduccion);
                                    consulta.append(" ,COD_TIPO_MODIFICACION_PRODUCTO=2");
                                    consulta.append(" ,NRO_VERSION=1");
                            consulta.append(" WHERE COD_VERSION=").append(codVersion);
                LOGGER.debug("consulta actualizar cantidades "+consulta.toString());
                pst=con.prepareStatement(consulta.toString());
                if(pst.executeUpdate()>0)LOGGER.info("se actualizo la cantidad");
                consulta=new StringBuilder(" exec PAA_ACTUALIZACION_CANTIDADES_FORMULA_MAESTRA_VERSION ");
                            consulta.append(codVersion);
                LOGGER.debug("consulta actualizar cantidad formula "+consulta.toString());
                pst=con.prepareStatement(consulta.toString());
                if(pst.executeUpdate()>0)LOGGER.info("se actualizo la cantidad de formula maestra");
                consulta=new StringBuilder("update FORMULA_MAESTRA_DETALLE_ES_VERSION set CANTIDAD=CANTIDAD*").append(Double.valueOf(nuevoTamanioLoteProduccion)/Double.valueOf(componentesProdBean.getTamanioLoteProduccion()));
                            consulta.append(" FROM FORMULA_MAESTRA_DETALLE_ES_VERSION fmdes");
                                    consulta.append(" inner join FORMULA_MAESTRA_ES_VERSION fmes on fmes.COD_FORMULA_MAESTRA_ES_VERSION=fmdes.COD_FORMULA_MAESTRA_ES_VERSION");
                            consulta.append(" where fmes.COD_VERSION=").append(codVersion);
                LOGGER.debug("consulta actualizar cantidad fmes "+consulta.toString());
                pst=con.prepareStatement(consulta.toString());
                if(pst.executeUpdate()>0)LOGGER.info("se actualizaron las cantidades de fmes");
            //</editor-fold>
            
            con.commit();
            this.mostrarMensajeTransaccionExitosa("Se registro satisfactoriamente el nuevo tamaño de lote");
            pst.close();
        }
        catch (SQLException ex){
            this.mostrarMensajeTransaccionFallida(ex.getMessage());
            con.rollback();
            LOGGER.warn(ex.getMessage());
        }
        catch (Exception ex){
            this.mostrarMensajeTransaccionFallida(ex.getMessage());
            LOGGER.warn(ex.getMessage());
        }
        finally{
            this.cerrarConexion(con);
        }
        if(transaccionExitosa){
            this.cargarComponentesProdVersionList();
        }
        return null;
    }
    public String sinNecesidadDeCambiosComponentesProdVersionTamanioLoteProduccion()throws SQLException
    {
        mensaje="";
        this.sinNecesidadDeCambios(componentesProdVersionBean);
        if(mensaje.equals("1"))
        {
            this.cargarComponentesProdVersionNuevosTamaniosLoteProduccion();
        }
        return null;
    }
    public String enviarAprobacionNuevoTamanioLoteProduccionAction()throws SQLException
    {
        mensaje = "";
        this.enviarAprobacionVersionProducto(componentesProdVersionBean);
        if(mensaje.equals("1")){
            this.cargarComponentesProdVersionNuevosTamaniosLoteProduccion();
        }
        return null;
    }
    public String editarComponenteProdVersionNuevoTamanioLoteProduccion_action()
    {
        for(ComponentesProdVersion bean:componentesProdVersionNuevosTamaniosLoteProduccion)
        {
            if(bean.getChecked())
            {
                componentesProdVersionEditar=bean;
                break;
            }
        }
        return null;
    }
    public String seleccionarComponentesProdVersionNuevoTamanioLote_action()
    {
        componentesProdVersionBean=(ComponentesProdVersion)componentesProdVersionNuevosTamaniosDataTable.getRowData();
        return null;
    }
    public String eliminarComponentesProdVersionTamaniosLoteProduccion()throws SQLException
    {
        this.eliminarComponentesProdVersion(componentesProdVersionBean);
        
        if(mensaje.equals("1"))
        {
            this.cargarComponentesProdVersionNuevosTamaniosLoteProduccion();
        }
        return null;
    }
    public String agregarPersonalComponentesProdVersionTamaniosLoteProduccion()throws SQLException
    {
        mensaje="";
        this.agregarPersonalVersion(componentesProdVersionBean);
        if(mensaje.equals("1"))
        {
            this.cargarComponentesProdVersionNuevosTamaniosLoteProduccion();
        }
        return null;
    }
    public String getCargarComponentesProdVersionNuevosTamaniosLoteProduccion()
    {
        this.cargarProductosSelectList();
        this.cargarAreasEmpresaSelectList();
        this.cargarFormasFarmaceuticasSelectList();
        this.cargarSaboresProductoSelectList();
        this.cargarUnidadesMedidaSelectList();
        this.cargarViasAdministracionSelectList();
        this.cargarTamaniosCapsulasProduccion();
        this.cargarColoresPresPrimSelectList();
        this.cargarComponentesProdVersionNuevo_action();
        this.cargarCondicionesVentasSelect();
        this.cargarPermisosVersionCp();
        this.cargarConfiguracionPermisoPersonal();
        this.cargarComponentesProdVersionNuevosTamaniosLoteProduccion();
        return null;
    }
    private void cargarComponentesProdVersionNuevosTamaniosLoteProduccion()
    {
        try {
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ManagedAccesoSistema managed = (ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
            StringBuilder consulta =new StringBuilder("select cpv.COD_VERSION,cpv.COD_COMPPROD,cpv.nombre_prod_semiterminado,cpv.COD_PROD,isnull(p.NOMBRE_PROD,'') as NOMBRE_PROD,");
                                        consulta.append(" cpv.COD_FORMA,ff.NOMBRE_FORMA,cpv.COD_COLORPRESPRIMARIA,cpp.NOMBRE_COLORPRESPRIMARIA");
                                            consulta.append(" ,cpv.COD_VIA_ADMINISTRACION_PRODUCTO,vap.NOMBRE_VIA_ADMINISTRACION_PRODUCTO");
                                            consulta.append(" ,cpv.COD_SABOR,sp.NOMBRE_SABOR,cpv.REG_SANITARIO,cpv.VIDA_UTIL,cpv.NOMBRE_GENERICO,cpv.PRODUCTO_SEMITERMINADO");
                                            consulta.append(" ,cpv.CONCENTRACION_ENVASE_PRIMARIO,isnull(cpv.COD_AREA_EMPRESA,'81') as COD_AREA_EMPRESA,ae.NOMBRE_AREA_EMPRESA");
                                            consulta.append(" ,cpv.CANTIDAD_VOLUMEN,isnull(cpv.COD_UNIDAD_MEDIDA_VOLUMEN,0) as COD_UNIDAD_MEDIDA_VOLUMEN,isnull(um.ABREVIATURA,'') as ABREVIATURA");
                                            consulta.append(" ,cpv.PESO_ENVASE_PRIMARIO,cpv.COD_TAMANIO_CAPSULA_PRODUCCION,");
                                            consulta.append(" isnull(tc.NOMBRE_TAMANIO_CAPSULA_PRODUCCION,'') as NOMBRE_TAMANIO_CAPSULA_PRODUCCION,");
                                            consulta.append(" cpv.COD_ESTADO_COMPPROD,ec.NOMBRE_ESTADO_COMPPROD,cpv.TOLERANCIA_VOLUMEN_FABRICAR");
                                            consulta.append(" ,cpv.FECHA_MODIFICACION,cpv.FECHA_INICIO_VIGENCIA,cpv.NRO_VERSION,cpv.FECHA_VENCIMIENTO_RS");
                                            consulta.append(" ,cpv.COD_ESTADO_VERSION,evc.NOMBRE_ESTADO_VERSION_COMPONENTES_PROD");
                                            consulta.append(" ,vcpm.NOMBRE_ESTADO_VERSION_COMPONENTES_PROD as estadosVersionPersonal,vcpm.COD_PERSONAL");
                                            consulta.append(" ,vcpm.AP_PATERNO_PERSONAL,vcpm.AP_MATERNO_PERSONAL,vcpm.NOMBRES_PERSONAL");
                                            consulta.append(" ,vcpm.FECHA_INCLUSION_VERSION,vcpm.FECHA_ENVIO_APROBACION,vcpm.FECHA_DEVOLUCION_VERSION");
                                            consulta.append(" ,cpv.PRESENTACIONES_REGISTRADAS_RS,cpv.COD_CONDICION_VENTA_PRODUCTO,cpv.NOMBRE_COMERCIAL");
                                            consulta.append(" ,cpv.TAMANIO_LOTE_PRODUCCION,isnull(cpv.DIRECCION_ARCHIVO_REGISTRO_SANITARIO,'') as DIRECCION_ARCHIVO_REGISTRO_SANITARIO");
                                            consulta.append(" ,versionfm.COD_FORMULA_MAESTRA,versionfm.COD_VERSION AS COD_VERSION_FM");
                                            consulta.append(" ,cpv.CANTIDAD_VOLUMEN_DE_DOSIFICADO");
                                            consulta.append(",vcpm.COD_ESTADO_VERSION_COMPONENTES_PROD");
                                            consulta.append(",cpv.APLICA_ESPECIFICACIONES_FISICAS,cpv.APLICA_ESPECIFICACIONES_QUIMICAS,cpv.APLICA_ESPECIFICACIONES_MICROBIOLOGICAS")
                                                    .append(",cpv.COD_UNIDAD_MEDIDA_PESO_TEORICO,cpv.PESO_TEORICO ")
                                                    .append(" , vcpm.FECHA_ASIGNACION,vcpm.COD_ESTADO_VERSION_COMPONENTES_PROD AS codEstadoVersionPersonal")
                                                    .append(" ,vcpm1.COD_TIPO_PERMISO_ESPECIAL_ATLAS as codTipoPermisoPersonalVersion")
                                                    .append(" ,vcpm.COD_TIPO_PERMISO_ESPECIAL_ATLAS,vcpm1.COD_ESTADO_VERSION_COMPONENTES_PROD as codEstadoPersonalVersion");
                                    consulta.append(" from COMPONENTES_PROD_VERSION cpv");
                                            consulta.append(" left outer join PRODUCTOS p on cpv.COD_PROD=p.COD_PROD");
                                            consulta.append(" left outer join FORMAS_FARMACEUTICAS ff on ff.cod_forma=cpv.COD_FORMA");
                                            consulta.append(" left outer join COLORES_PRESPRIMARIA cpp on cpp.COD_COLORPRESPRIMARIA=cpv.COD_COLORPRESPRIMARIA");
                                            consulta.append(" left outer join VIAS_ADMINISTRACION_PRODUCTO vap on vap.COD_VIA_ADMINISTRACION_PRODUCTO=cpv.COD_VIA_ADMINISTRACION_PRODUCTO");
                                            consulta.append(" left outer join SABORES_PRODUCTO sp on sp.COD_SABOR=cpv.COD_SABOR");
                                            consulta.append(" left outer join AREAS_EMPRESA ae on ae.COD_AREA_EMPRESA=cpv.COD_AREA_EMPRESA");
                                            consulta.append(" left outer join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=cpv.COD_UNIDAD_MEDIDA_VOLUMEN");
                                            consulta.append(" left outer join TAMANIOS_CAPSULAS_PRODUCCION tc on tc.COD_TAMANIO_CAPSULA_PRODUCCION=cpv.COD_TAMANIO_CAPSULA_PRODUCCION");
                                            consulta.append(" left outer JOIN ESTADOS_COMPPROD ec on ec.COD_ESTADO_COMPPROD=cpv.COD_ESTADO_COMPPROD");
                                            consulta.append(" left outer join ESTADOS_VERSION_COMPONENTES_PROD evc on evc.COD_ESTADO_VERSION_COMPONENTES_PROD=cpv.COD_ESTADO_VERSION");
                                            consulta.append(" inner join VISTA_COMPONENTES_PROD_VERSION_MODIFICACION vcpm on vcpm.COD_VERSION = cpv.COD_VERSION");
                                            consulta.append(" left outer join VISTA_COMPONENTES_PROD_VERSION_MODIFICACION vcpm1 on vcpm1.COD_VERSION = cpv.COD_VERSION")
                                                            .append(" and  vcpm1.COD_PERSONAL =").append(managed.getUsuarioModuloBean().getCodUsuarioGlobal());
                                            consulta.append(" outer apply(");
                                                consulta.append(" select fmv.COD_FORMULA_MAESTRA,fmv.COD_VERSION");
                                                consulta.append(" from FORMULA_MAESTRA_VERSION fmv");
                                                consulta.append(" where fmv.COD_COMPPROD = cpv.COD_COMPPROD AND fmv.COD_COMPPROD_VERSION = cpv.COD_VERSION");
                                            consulta.append(") as versionfm" );
                                    consulta.append(" where cpv.COD_COMPPROD<0" );
                                            consulta.append(" and cpv.COD_TIPO_MODIFICACION_PRODUCTO=2");
                                    consulta.append(" order by cpv.COD_VERSION");
            LOGGER.debug("consulta cargar nuevos tamanios de produccion " + consulta.toString());
            ResultSet res = st.executeQuery(consulta.toString());
            componentesProdVersionNuevosTamaniosLoteProduccion=new ArrayList<ComponentesProdVersion>();
            List<ComponentesProdVersionModificacion> componentesProdVersionModificacionList=new ArrayList<ComponentesProdVersionModificacion>();
            ComponentesProdVersion nuevo = new ComponentesProdVersion();
            while (res.next()) 
            {
                if(nuevo.getCodVersion()!=res.getInt("COD_VERSION"))
                {
                    if(nuevo.getCodVersion()>0)
                    {
                        nuevo.setComponentesProdVersionModificacionList(componentesProdVersionModificacionList);
                        componentesProdVersionNuevosTamaniosLoteProduccion.add(nuevo);
                        nuevo=new ComponentesProdVersion();
                        componentesProdVersionModificacionList=new ArrayList<ComponentesProdVersionModificacion>();
                    }
                    nuevo.getUnidadMedidaPesoTeorico().setCodUnidadMedida(res.getString("COD_UNIDAD_MEDIDA_PESO_TEORICO"));
                    nuevo.setPesoTeorico(res.getDouble("PESO_TEORICO"));
                    nuevo.setCantidadVolumenDeDosificado(res.getDouble("CANTIDAD_VOLUMEN_DE_DOSIFICADO"));
                    nuevo.setCodFormulaMaestra(res.getInt("COD_FORMULA_MAESTRA"));
                    nuevo.setCodFormulaMaestraVersion(res.getInt("COD_VERSION_FM"));
                    nuevo.setDireccionArchivoSanitario(res.getString("DIRECCION_ARCHIVO_REGISTRO_SANITARIO"));
                    nuevo.setTamanioLoteProduccion(res.getInt("TAMANIO_LOTE_PRODUCCION"));
                    nuevo.setPresentacionesRegistradasRs(res.getString("PRESENTACIONES_REGISTRADAS_RS"));
                    nuevo.getCondicionesVentasProducto().setCodCondicionVentaProducto(res.getInt("COD_CONDICION_VENTA_PRODUCTO"));
                    nuevo.setNombreComercial(res.getString("NOMBRE_COMERCIAL"));
                    nuevo.setFechaModificacion(res.getTimestamp("FECHA_MODIFICACION"));
                    nuevo.setFechaInicioVigencia(res.getTimestamp("FECHA_INICIO_VIGENCIA"));
                    nuevo.setNroVersion(res.getInt("NRO_VERSION"));
                    nuevo.setFechaVencimientoRS(res.getTimestamp("FECHA_VENCIMIENTO_RS"));
                    nuevo.setToleranciaVolumenfabricar(res.getDouble("TOLERANCIA_VOLUMEN_FABRICAR"));
                    nuevo.getAreasEmpresa().setCodAreaEmpresa(res.getString("COD_AREA_EMPRESA"));
                    nuevo.getAreasEmpresa().setNombreAreaEmpresa(res.getString("NOMBRE_AREA_EMPRESA"));
                    nuevo.setCantidadVolumen(res.getDouble("CANTIDAD_VOLUMEN"));
                    nuevo.getUnidadMedidaVolumen().setCodUnidadMedida(res.getString("COD_UNIDAD_MEDIDA_VOLUMEN"));
                    nuevo.getUnidadMedidaVolumen().setAbreviatura(res.getString("ABREVIATURA"));
                    nuevo.getTamaniosCapsulasProduccion().setCodTamanioCapsulaProduccion(res.getInt("COD_TAMANIO_CAPSULA_PRODUCCION"));
                    nuevo.getTamaniosCapsulasProduccion().setNombreTamanioCapsulaProduccion(res.getString("NOMBRE_TAMANIO_CAPSULA_PRODUCCION"));
                    nuevo.getEstadoCompProd().setCodEstadoCompProd(res.getInt("COD_ESTADO_COMPPROD"));
                    nuevo.getEstadoCompProd().setNombreEstadoCompProd(res.getString("NOMBRE_ESTADO_COMPPROD"));
                    nuevo.setPesoEnvasePrimario(res.getString("PESO_ENVASE_PRIMARIO"));
                    nuevo.setRegSanitario(res.getString("REG_SANITARIO"));
                    nuevo.setConcentracionEnvasePrimario(res.getString("CONCENTRACION_ENVASE_PRIMARIO"));
                    nuevo.setVidaUtil(res.getInt("VIDA_UTIL"));
                    nuevo.setCodVersion(res.getInt("COD_VERSION"));
                    nuevo.setNombreGenerico(res.getString("NOMBRE_GENERICO"));
                    nuevo.setProductoSemiterminado(res.getInt("PRODUCTO_SEMITERMINADO") > 0);
                    nuevo.setCodCompprod(res.getString("COD_COMPPROD"));
                    nuevo.setNombreProdSemiterminado(res.getString("nombre_prod_semiterminado"));
                    nuevo.getProducto().setCodProducto(res.getString("COD_PROD"));
                    nuevo.getProducto().setNombreProducto(res.getString("NOMBRE_PROD"));
                    nuevo.getForma().setCodForma(res.getString("COD_FORMA"));
                    nuevo.getForma().setNombreForma(res.getString("NOMBRE_FORMA"));
                    nuevo.getColoresPresentacion().setCodColor(res.getString("COD_COLORPRESPRIMARIA"));
                    nuevo.getColoresPresentacion().setNombreColor(res.getString("NOMBRE_COLORPRESPRIMARIA"));
                    nuevo.getViasAdministracionProducto().setCodViaAdministracionProducto(res.getInt("COD_VIA_ADMINISTRACION_PRODUCTO"));
                    nuevo.getViasAdministracionProducto().setNombreViaAdministracionProducto(res.getString("NOMBRE_VIA_ADMINISTRACION_PRODUCTO"));
                    nuevo.getSaboresProductos().setCodSabor(res.getString("COD_SABOR"));
                    nuevo.getSaboresProductos().setNombreSabor(res.getString("NOMBRE_SABOR"));
                    nuevo.getEstadosVersionComponentesProd().setCodEstadoVersionComponenteProd(res.getInt("COD_ESTADO_VERSION"));
                    nuevo.getEstadosVersionComponentesProd().setNombreEstadoVersionComponentesProd(res.getString("NOMBRE_ESTADO_VERSION_COMPONENTES_PROD"));
                    nuevo.getTiposModificacionProducto().setCodTipoModificacionProducto(2);//nuevo tamanio de lote de produccion
                    nuevo.setAplicaEspecificacionesFisicas(res.getInt("APLICA_ESPECIFICACIONES_FISICAS")>0);
                    nuevo.setAplicaEspecificacionesQuimicas(res.getInt("APLICA_ESPECIFICACIONES_QUIMICAS")>0);
                    nuevo.setAplicaEspecificacionesMicrobiologicas(res.getInt("APLICA_ESPECIFICACIONES_MICROBIOLOGICAS")>0);
                    nuevo.setComponentesProdVersionModificacionPersonal(new ComponentesProdVersionModificacion());
                    nuevo.getComponentesProdVersionModificacionPersonal().getEstadosVersionComponentesProd().setCodEstadoVersionComponenteProd(res.getInt("codEstadoPersonalVersion"));
                    nuevo.getComponentesProdVersionModificacionPersonal().getTiposPermisosEspecialesAtlas().setCodTipoPermisoEspecialAtlas(res.getInt("codTipoPermisoPersonalVersion"));
                }
                ComponentesProdVersionModificacion nuevoComp=new ComponentesProdVersionModificacion();
                nuevoComp.setFechaAsignacion(res.getTimestamp("FECHA_ASIGNACION"));
                nuevoComp.setFechaInclusionVersion(res.getTimestamp("FECHA_INCLUSION_VERSION"));
                nuevoComp.setFechaEnvioAprobacion(res.getTimestamp("FECHA_ENVIO_APROBACION"));
                nuevoComp.setFechaDevolucionVersion(res.getTimestamp("FECHA_DEVOLUCION_VERSION"));
                nuevoComp.getPersonal().setApPaternoPersonal(res.getString("AP_PATERNO_PERSONAL"));
                nuevoComp.getPersonal().setApMaternoPersonal(res.getString("AP_MATERNO_PERSONAL"));
                nuevoComp.getPersonal().setNombrePersonal(res.getString("NOMBRES_PERSONAL"));
                nuevoComp.getPersonal().setCodPersonal(res.getString("COD_PERSONAL"));
                nuevoComp.getTiposPermisosEspecialesAtlas().setCodTipoPermisoEspecialAtlas(res.getInt("COD_TIPO_PERMISO_ESPECIAL_ATLAS"));
                nuevoComp.getEstadosVersionComponentesProd().setNombreEstadoVersionComponentesProd(res.getString("estadosVersionPersonal"));
                nuevoComp.getEstadosVersionComponentesProd().setCodEstadoVersionComponenteProd(res.getInt("codEstadoVersionPersonal"));
                componentesProdVersionModificacionList.add(nuevoComp);
                
            }
            if(nuevo.getCodVersion()>0)
            {
                nuevo.setComponentesProdVersionModificacionList(componentesProdVersionModificacionList);
                componentesProdVersionNuevosTamaniosLoteProduccion.add(nuevo);
                nuevo=new ComponentesProdVersion();
                componentesProdVersionModificacionList=new ArrayList<ComponentesProdVersionModificacion>();
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
    //</editor-fold>
    private void cargarComponentesProdVersionNuevo_action()
    {
        try {
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ManagedAccesoSistema managed = (ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
            StringBuilder consulta = new StringBuilder("select cpv.COD_VERSION,cpv.COD_COMPPROD,cpv.nombre_prod_semiterminado,cpv.COD_PROD,isnull(p.NOMBRE_PROD,'') as NOMBRE_PROD,");
                                                consulta.append(" cpv.COD_FORMA,ff.NOMBRE_FORMA,cpv.COD_COLORPRESPRIMARIA,cpp.NOMBRE_COLORPRESPRIMARIA");
                                                consulta.append(" ,cpv.COD_VIA_ADMINISTRACION_PRODUCTO,vap.NOMBRE_VIA_ADMINISTRACION_PRODUCTO");
                                                consulta.append(" ,cpv.COD_SABOR,sp.NOMBRE_SABOR,cpv.REG_SANITARIO,cpv.VIDA_UTIL,cpv.NOMBRE_GENERICO,cpv.PRODUCTO_SEMITERMINADO");
                                                consulta.append(" ,cpv.CONCENTRACION_ENVASE_PRIMARIO,isnull(cpv.COD_AREA_EMPRESA,'81') as COD_AREA_EMPRESA,ae.NOMBRE_AREA_EMPRESA");
                                                consulta.append(" ,cpv.CANTIDAD_VOLUMEN,isnull(cpv.COD_UNIDAD_MEDIDA_VOLUMEN,0) as COD_UNIDAD_MEDIDA_VOLUMEN,isnull(um.ABREVIATURA,'') as ABREVIATURA");
                                                consulta.append(" ,cpv.PESO_ENVASE_PRIMARIO,cpv.COD_TAMANIO_CAPSULA_PRODUCCION,");
                                                consulta.append(" isnull(tc.NOMBRE_TAMANIO_CAPSULA_PRODUCCION,'') as NOMBRE_TAMANIO_CAPSULA_PRODUCCION,");
                                                consulta.append(" cpv.COD_ESTADO_COMPPROD,ec.NOMBRE_ESTADO_COMPPROD,cpv.TOLERANCIA_VOLUMEN_FABRICAR");
                                                consulta.append(" ,cpv.FECHA_MODIFICACION,cpv.FECHA_INICIO_VIGENCIA,cpv.NRO_VERSION,cpv.FECHA_VENCIMIENTO_RS");
                                                consulta.append(" ,cpv.COD_ESTADO_VERSION,evc.NOMBRE_ESTADO_VERSION_COMPONENTES_PROD");
                                                consulta.append(" ,evcp.NOMBRE_ESTADO_VERSION_COMPONENTES_PROD as estadosVersionPersonal,per.COD_PERSONAL");
                                                consulta.append(" ,(per.AP_PATERNO_PERSONAL+' '+per.AP_MATERNO_PERSONAL+' '+per.NOMBRES_PERSONAL) as nombrePersonal");
                                                consulta.append(" ,cpvm.FECHA_INCLUSION_VERSION,cpvm.FECHA_ENVIO_APROBACION,cpvm.FECHA_DEVOLUCION_VERSION,cpvm.FECHA_ASIGNACION");
                                                consulta.append(" ,cpv.PRESENTACIONES_REGISTRADAS_RS,cpv.COD_CONDICION_VENTA_PRODUCTO,cpv.NOMBRE_COMERCIAL");
                                                consulta.append(" ,cpv.TAMANIO_LOTE_PRODUCCION,isnull(cpv.DIRECCION_ARCHIVO_REGISTRO_SANITARIO,'') as DIRECCION_ARCHIVO_REGISTRO_SANITARIO");
                                                consulta.append(" ,versionfm.COD_FORMULA_MAESTRA,versionfm.COD_VERSION AS COD_VERSION_FM");
                                                consulta.append(" ,cpv.CANTIDAD_VOLUMEN_DE_DOSIFICADO");
                                                consulta.append(",cpvm.COD_ESTADO_VERSION_COMPONENTES_PROD");
                                                consulta.append(",cpvm.OBSERVACION_PERSONAL_VERSION");
                                                consulta.append(" ,cpv.APLICA_ESPECIFICACIONES_FISICAS,cpv.APLICA_ESPECIFICACIONES_QUIMICAS,cpv.APLICA_ESPECIFICACIONES_MICROBIOLOGICAS");
                                                consulta.append(" ,tmp.COD_TIPO_MODIFICACION_PRODUCTO,tmp.NOMBRE_TIPO_MODIFICACION_PRODUCTO")
                                                        .append(" ,cpv.COD_UNIDAD_MEDIDA_PESO_TEORICO,cpv.PESO_TEORICO")
                                                        .append(",cpvm1.COD_ESTADO_VERSION_COMPONENTES_PROD as codEstadoPersonal")
                                                        .append(",cpvm1.COD_TIPO_PERMISO_ESPECIAL_ATLAS as codTipoPermisoVersionPersonal");
                                        consulta.append(" from COMPONENTES_PROD_VERSION cpv left outer join PRODUCTOS p on cpv.COD_PROD=p.COD_PROD");
                                                consulta.append(" left outer join FORMAS_FARMACEUTICAS ff on ff.cod_forma=cpv.COD_FORMA");
                                                consulta.append(" left outer join COLORES_PRESPRIMARIA cpp on cpp.COD_COLORPRESPRIMARIA=cpv.COD_COLORPRESPRIMARIA");
                                                consulta.append(" left outer join VIAS_ADMINISTRACION_PRODUCTO vap on vap.COD_VIA_ADMINISTRACION_PRODUCTO=cpv.COD_VIA_ADMINISTRACION_PRODUCTO");
                                                consulta.append(" left outer join SABORES_PRODUCTO sp on sp.COD_SABOR=cpv.COD_SABOR");
                                                consulta.append(" left outer join AREAS_EMPRESA ae on ae.COD_AREA_EMPRESA=cpv.COD_AREA_EMPRESA");
                                                consulta.append(" left outer join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=cpv.COD_UNIDAD_MEDIDA_VOLUMEN");
                                                consulta.append(" left outer join TAMANIOS_CAPSULAS_PRODUCCION tc on tc.COD_TAMANIO_CAPSULA_PRODUCCION=cpv.COD_TAMANIO_CAPSULA_PRODUCCION");
                                                consulta.append(" left outer JOIN ESTADOS_COMPPROD ec on ec.COD_ESTADO_COMPPROD=cpv.COD_ESTADO_COMPPROD");
                                                consulta.append(" left outer join ESTADOS_VERSION_COMPONENTES_PROD evc on evc.COD_ESTADO_VERSION_COMPONENTES_PROD=cpv.COD_ESTADO_VERSION");
                                                consulta.append(" inner join COMPONENTES_PROD_VERSION_MODIFICACION cpvm on cpvm.COD_VERSION=cpv.COD_VERSION");
                                                consulta.append(" inner join PERSONAL per on per.COD_PERSONAL=cpvm.COD_PERSONAL");
                                                consulta.append(" inner join TIPOS_MODIFICACION_PRODUCTO tmp on tmp.COD_TIPO_MODIFICACION_PRODUCTO=cpv.COD_TIPO_MODIFICACION_PRODUCTO");
                                                consulta.append(" inner join ESTADOS_VERSION_COMPONENTES_PROD evcp on evcp.COD_ESTADO_VERSION_COMPONENTES_PROD=cpvm.COD_ESTADO_VERSION_COMPONENTES_PROD")
                                                        .append(" left outer join COMPONENTES_PROD_VERSION_MODIFICACION cpvm1 on cpvm1.COD_VERSION= cpv.COD_VERSION")
                                                        .append(" and cpvm1.cod_personal = ").append(managed.getUsuarioModuloBean().getCodUsuarioGlobal());
                                                consulta.append(" outer apply( select fmv.COD_FORMULA_MAESTRA,fmv.COD_VERSION from FORMULA_MAESTRA_VERSION fmv where fmv.COD_COMPPROD = cpv.COD_COMPPROD");
                                                consulta.append(" AND fmv.COD_COMPPROD_VERSION = cpv.COD_VERSION) as versionfm");
                                        consulta.append(" where cpv.COD_COMPPROD<0");
                                                consulta.append(" and cpv.COD_TIPO_MODIFICACION_PRODUCTO in (1,4)");
                                        consulta.append(" order by cpv.COD_VERSION");
            LOGGER.debug("consulta cargar versiones producto " + consulta.toString());
            ResultSet res = st.executeQuery(consulta.toString());
            componentesProdVersionNuevoList.clear();
            List<ComponentesProdVersionModificacion> componentesProdVersionModificacionList=new ArrayList<ComponentesProdVersionModificacion>();
            ComponentesProdVersion nuevo = new ComponentesProdVersion();
            while (res.next()) {

                if(nuevo.getCodVersion()!=res.getInt("COD_VERSION"))
                {
                    if(nuevo.getCodVersion()>0)
                    {
                        nuevo.setComponentesProdVersionModificacionList(componentesProdVersionModificacionList);
                        componentesProdVersionNuevoList.add(nuevo);
                        nuevo=new ComponentesProdVersion();
                        componentesProdVersionModificacionList=new ArrayList<ComponentesProdVersionModificacion>();
                    }
                    nuevo.setComponentesProdVersionModificacionPersonal( new ComponentesProdVersionModificacion());
                    nuevo.getComponentesProdVersionModificacionPersonal().getEstadosVersionComponentesProd().setCodEstadoVersionComponenteProd(res.getInt("codEstadoPersonal"));
                    nuevo.getComponentesProdVersionModificacionPersonal().getTiposPermisosEspecialesAtlas().setCodTipoPermisoEspecialAtlas(res.getInt("codTipoPermisoVersionPersonal"));
                    nuevo.getUnidadMedidaPesoTeorico().setCodUnidadMedida(res.getString("COD_UNIDAD_MEDIDA_PESO_TEORICO"));
                    nuevo.setPesoTeorico(res.getDouble("PESO_TEORICO"));
                    nuevo.getTiposModificacionProducto().setCodTipoModificacionProducto(res.getInt("COD_TIPO_MODIFICACION_PRODUCTO"));
                    nuevo.getTiposModificacionProducto().setNombreTipoModificacionProducto(res.getString("NOMBRE_TIPO_MODIFICACION_PRODUCTO"));
                    nuevo.setCantidadVolumenDeDosificado(res.getDouble("CANTIDAD_VOLUMEN_DE_DOSIFICADO"));
                    nuevo.setCodFormulaMaestra(res.getInt("COD_FORMULA_MAESTRA"));
                    nuevo.setCodFormulaMaestraVersion(res.getInt("COD_VERSION_FM"));
                    nuevo.setDireccionArchivoSanitario(res.getString("DIRECCION_ARCHIVO_REGISTRO_SANITARIO"));
                    nuevo.setTamanioLoteProduccion(res.getInt("TAMANIO_LOTE_PRODUCCION"));
                    nuevo.setPresentacionesRegistradasRs(res.getString("PRESENTACIONES_REGISTRADAS_RS"));
                    nuevo.getCondicionesVentasProducto().setCodCondicionVentaProducto(res.getInt("COD_CONDICION_VENTA_PRODUCTO"));
                    nuevo.setNombreComercial(res.getString("NOMBRE_COMERCIAL"));
                    nuevo.setFechaModificacion(res.getTimestamp("FECHA_MODIFICACION"));
                    nuevo.setFechaInicioVigencia(res.getTimestamp("FECHA_INICIO_VIGENCIA"));
                    nuevo.setNroVersion(res.getInt("NRO_VERSION"));
                    nuevo.setFechaVencimientoRS(res.getTimestamp("FECHA_VENCIMIENTO_RS"));
                    nuevo.setToleranciaVolumenfabricar(res.getDouble("TOLERANCIA_VOLUMEN_FABRICAR"));
                    nuevo.getAreasEmpresa().setCodAreaEmpresa(res.getString("COD_AREA_EMPRESA"));
                    nuevo.getAreasEmpresa().setNombreAreaEmpresa(res.getString("NOMBRE_AREA_EMPRESA"));
                    nuevo.setCantidadVolumen(res.getDouble("CANTIDAD_VOLUMEN"));
                    nuevo.getUnidadMedidaVolumen().setCodUnidadMedida(res.getString("COD_UNIDAD_MEDIDA_VOLUMEN"));
                    nuevo.getUnidadMedidaVolumen().setAbreviatura(res.getString("ABREVIATURA"));
                    nuevo.getTamaniosCapsulasProduccion().setCodTamanioCapsulaProduccion(res.getInt("COD_TAMANIO_CAPSULA_PRODUCCION"));
                    nuevo.getTamaniosCapsulasProduccion().setNombreTamanioCapsulaProduccion(res.getString("NOMBRE_TAMANIO_CAPSULA_PRODUCCION"));
                    nuevo.getEstadoCompProd().setCodEstadoCompProd(res.getInt("COD_ESTADO_COMPPROD"));
                    nuevo.getEstadoCompProd().setNombreEstadoCompProd(res.getString("NOMBRE_ESTADO_COMPPROD"));
                    nuevo.setPesoEnvasePrimario(res.getString("PESO_ENVASE_PRIMARIO"));
                    nuevo.setRegSanitario(res.getString("REG_SANITARIO"));
                    nuevo.setConcentracionEnvasePrimario(res.getString("CONCENTRACION_ENVASE_PRIMARIO"));
                    nuevo.setVidaUtil(res.getInt("VIDA_UTIL"));
                    nuevo.setCodVersion(res.getInt("COD_VERSION"));
                    nuevo.setNombreGenerico(res.getString("NOMBRE_GENERICO"));
                    nuevo.setProductoSemiterminado(res.getInt("PRODUCTO_SEMITERMINADO") > 0);
                    nuevo.setCodCompprod(res.getString("COD_COMPPROD"));
                    nuevo.setNombreProdSemiterminado(res.getString("nombre_prod_semiterminado"));
                    nuevo.getProducto().setCodProducto(res.getString("COD_PROD"));
                    nuevo.getProducto().setNombreProducto(res.getString("NOMBRE_PROD"));
                    nuevo.getForma().setCodForma(res.getString("COD_FORMA"));
                    nuevo.getForma().setNombreForma(res.getString("NOMBRE_FORMA"));
                    nuevo.getColoresPresentacion().setCodColor(res.getString("COD_COLORPRESPRIMARIA"));
                    nuevo.getColoresPresentacion().setNombreColor(res.getString("NOMBRE_COLORPRESPRIMARIA"));
                    nuevo.getViasAdministracionProducto().setCodViaAdministracionProducto(res.getInt("COD_VIA_ADMINISTRACION_PRODUCTO"));
                    nuevo.getViasAdministracionProducto().setNombreViaAdministracionProducto(res.getString("NOMBRE_VIA_ADMINISTRACION_PRODUCTO"));
                    nuevo.getSaboresProductos().setCodSabor(res.getString("COD_SABOR"));
                    nuevo.getSaboresProductos().setNombreSabor(res.getString("NOMBRE_SABOR"));
                    nuevo.getEstadosVersionComponentesProd().setCodEstadoVersionComponenteProd(res.getInt("COD_ESTADO_VERSION"));
                    nuevo.setAplicaEspecificacionesFisicas(res.getInt("APLICA_ESPECIFICACIONES_FISICAS")>0);
                    nuevo.setAplicaEspecificacionesQuimicas(res.getInt("APLICA_ESPECIFICACIONES_QUIMICAS")>0);
                    nuevo.setAplicaEspecificacionesMicrobiologicas(res.getInt("APLICA_ESPECIFICACIONES_MICROBIOLOGICAS")>0);
                    nuevo.getEstadosVersionComponentesProd().setNombreEstadoVersionComponentesProd(res.getString("NOMBRE_ESTADO_VERSION_COMPONENTES_PROD"));
                }
                ComponentesProdVersionModificacion nuevoComp=new ComponentesProdVersionModificacion();
                nuevoComp.setFechaInclusionVersion(res.getTimestamp("FECHA_INCLUSION_VERSION"));
                nuevoComp.setFechaEnvioAprobacion(res.getTimestamp("FECHA_ENVIO_APROBACION"));
                nuevoComp.setFechaDevolucionVersion(res.getTimestamp("FECHA_DEVOLUCION_VERSION"));
                nuevoComp.setFechaAsignacion(res.getTimestamp("FECHA_ASIGNACION"));
                nuevoComp.getPersonal().setNombrePersonal(res.getString("nombrePersonal"));
                nuevoComp.getPersonal().setCodPersonal(res.getString("COD_PERSONAL"));
                nuevoComp.setObservacionPersonalVersion(res.getString("OBSERVACION_PERSONAL_VERSION"));
                nuevoComp.getEstadosVersionComponentesProd().setNombreEstadoVersionComponentesProd(res.getString("estadosVersionPersonal"));
                nuevoComp.getEstadosVersionComponentesProd().setCodEstadoVersionComponenteProd(res.getInt("COD_ESTADO_VERSION_COMPONENTES_PROD"));
                componentesProdVersionModificacionList.add(nuevoComp);
                
            }
            if(nuevo.getCodVersion()>0)
            {
                nuevo.setComponentesProdVersionModificacionList(componentesProdVersionModificacionList);
                componentesProdVersionNuevoList.add(nuevo);
                nuevo=new ComponentesProdVersion();
                componentesProdVersionModificacionList=new ArrayList<ComponentesProdVersionModificacion>();
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
    public String getCargarComponentesProdVersionNuevo()
    {
        this.cargarTiposModificacionProductoSelectAgregar();
        this.cargarProductosSelectList();
        this.cargarAreasEmpresaSelectList();
        this.cargarFormasFarmaceuticasSelectList();
        this.cargarSaboresProductoSelectList();
        this.cargarUnidadesMedidaSelectList();
        this.cargarViasAdministracionSelectList();
        this.cargarTamaniosCapsulasProduccion();
        this.cargarColoresPresPrimSelectList();
        this.cargarComponentesProdVersionNuevo_action();
        this.cargarPermisosVersionCp();
        this.cargarConfiguracionPermisoPersonal();
        this.cargarCondicionesVentasSelect();
        return null;
    }

    //cargar versiones pendientes de aprobacion
    public String devolverVersionPersonal_action()throws SQLException
    {
        DaoComponentesProdVersionModificacion daoModificacion = new DaoComponentesProdVersionModificacion(this.LOGGER);
        for(ComponentesProdVersionModificacion bean : componentesProdVersionRevisar.getComponentesProdVersionModificacionList()){
            if(bean.getChecked()){
                bean.getEstadosVersionComponentesProd().setCodEstadoVersionComponenteProd(COD_ESTADO_MODIFICACION_REGISTRADO);
                bean.setFechaDevolucionVersion(new Date());
            }
        }
        if(daoModificacion.eliminarGuardarLista(componentesProdVersionRevisar.getComponentesProdVersionModificacionList())){
            this.mostrarMensajeTransaccionExitosa("Se registro satisfactoriamente la devolución de la tarea");
            this.cargarComponentesProdVersionAprobacionList();
        }
        else{
            this.mostrarMensajeTransaccionFallida("Ocurrio un error al momento de registrar la devolución, intente de nuevo");
        }
        return null;
    }
   
    public String guardarAprobacionVersionComponentesProd_action()throws SQLException
    {
        this.transaccionExitosa = false;
        HttpServletRequest  request=(HttpServletRequest)FacesContext.getCurrentInstance().getExternalContext().getRequest();
        EnviarCorreoAprobacionVersion envio=new EnviarCorreoAprobacionVersion(componentesProdVersionRevisar.getCodVersion(),componentesProdVersionRevisar.getCodCompprod(),request.getSession().getServletContext());
        try {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            PreparedStatement pst=null;
            StringBuilder consulta=new StringBuilder("exec PAA_APROBACION_COMPONENTES_PROD_VERSION ");
                                    consulta.append(componentesProdVersionRevisar.getCodVersion());
            LOGGER.debug("consulta aprobar version producto "+consulta.toString());
            pst=con.prepareStatement(consulta.toString());
            if(pst.executeUpdate()>0)LOGGER.info("se aprobo la version");
            //<editor-fold desc="empaque secundario version">
                StringBuilder consultaES=new StringBuilder("select f.COD_FORMULA_MAESTRA_ES_VERSION");
                                            consultaES.append(" from FORMULA_MAESTRA_ES_VERSION f ");
                                            consultaES.append(" where f.COD_VERSION=").append(componentesProdVersionRevisar.getCodVersion());
                LOGGER.debug("consulta buscar version es "+consultaES.toString());
                
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res=st.executeQuery(consultaES.toString());
                if(res.next())
                {
                    consultaES=new StringBuilder("exec PAA_APROBACION_FORMULA_MAESTRA_ES_VERSION ");
                            consultaES.append(res.getInt("COD_FORMULA_MAESTRA_ES_VERSION")).append(",");
                            consultaES.append(componentesProdVersionRevisar.getCodVersion()).append(",");
                            consultaES.append(componentesProdVersionRevisar.getCodCompprod()).append(",");
                            consultaES.append(componentesProdVersionRevisar.getCodFormulaMaestra());
                    LOGGER.debug("consulta  aprobar es "+consultaES.toString());
                    pst=con.prepareStatement(consultaES.toString());
                    if(pst.executeUpdate()>0)LOGGER.info("se aprobo la version es ");
                }
            //</editor-fold>
            con.commit();
            this.mostrarMensajeTransaccionExitosa("Se confirmó la revision correcta de la versión");
            pst.close();
            con.close();
        }
        catch (SQLException ex)
        {
            con.rollback();
            con.close();
            this.mostrarMensajeTransaccionFallida("Ocurrio un error al momento de realizar la aprobación, intente de nuevo");
            LOGGER.warn("error", ex);
        }
        if(this.transaccionExitosa)
        {
            LOGGER.debug("aprobacion de version correcta");
            envio.start();
        }
        return null;
    }
    public String seleccionarDevolverVersionAction(){
        DaoComponentesProdVersionModificacion daoModificacion = new DaoComponentesProdVersionModificacion(LOGGER);
        ComponentesProdVersionModificacion modificacion = new ComponentesProdVersionModificacion();
        modificacion.setComponentesProdVersion(componentesProdVersionRevisar);
        componentesProdVersionRevisar.setComponentesProdVersionModificacionList(daoModificacion.listar(modificacion));
        return null;
    }
    public String seleccionarComponentesProdRevisar_action()
    {
        for(ComponentesProdVersion bean:componentesProdVersionAprobarList)
        {
            if(bean.getChecked())
            {
                componentesProdVersionRevisar=bean;
                break;
            }
        }
        return null;
    }
    public String getCargarComponentesProdVersionAprobacion()
    {
        this.cargarComponentesProdVersionAprobacionList();
        return null;
    }
    private void cargarComponentesProdVersionAprobacionList()
    {
        try {
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            String consulta = "select cpv.COD_VERSION,cpv.COD_COMPPROD,cpv.nombre_prod_semiterminado,cpv.COD_PROD,p.NOMBRE_PROD," +
                    " cpv.COD_FORMA,ff.NOMBRE_FORMA,cpv.COD_COLORPRESPRIMARIA,cpp.NOMBRE_COLORPRESPRIMARIA" +
                    " ,cpv.COD_VIA_ADMINISTRACION_PRODUCTO,vap.NOMBRE_VIA_ADMINISTRACION_PRODUCTO" +
                    " ,cpv.COD_SABOR,sp.NOMBRE_SABOR,cpv.REG_SANITARIO,cpv.VIDA_UTIL,cpv.NOMBRE_GENERICO,cpv.PRODUCTO_SEMITERMINADO" +
                    " ,cpv.CONCENTRACION_ENVASE_PRIMARIO,cpv.COD_AREA_EMPRESA,ae.NOMBRE_AREA_EMPRESA" +
                    " ,cpv.CANTIDAD_VOLUMEN,cpv.COD_UNIDAD_MEDIDA_VOLUMEN,isnull(um.ABREVIATURA,'') as ABREVIATURA" +
                    " ,cpv.PESO_ENVASE_PRIMARIO,cpv.COD_TAMANIO_CAPSULA_PRODUCCION," +
                    " isnull(tc.NOMBRE_TAMANIO_CAPSULA_PRODUCCION,'') as NOMBRE_TAMANIO_CAPSULA_PRODUCCION," +
                    " cpv.COD_ESTADO_COMPPROD,ec.NOMBRE_ESTADO_COMPPROD,cpv.TOLERANCIA_VOLUMEN_FABRICAR" +
                    " ,cpv.FECHA_MODIFICACION,cpv.FECHA_INICIO_VIGENCIA,cpv.NRO_VERSION,cpv.FECHA_VENCIMIENTO_RS" +
                    " ,cpv.COD_ESTADO_VERSION,evc.NOMBRE_ESTADO_VERSION_COMPONENTES_PROD" +
                    " ,evcp.NOMBRE_ESTADO_VERSION_COMPONENTES_PROD as estadosVersionPersonal,per.COD_PERSONAL"+
                    " ,(per.AP_PATERNO_PERSONAL+' '+per.AP_MATERNO_PERSONAL+' '+per.NOMBRES_PERSONAL) as nombrePersonal" +
                    " ,detalleFormula.COD_FORMULA_MAESTRA,detalleFormula.COD_VERSION as codVersionFM" +
                    " from COMPONENTES_PROD_VERSION cpv left outer join PRODUCTOS p on cpv.COD_PROD=p.COD_PROD" +
                    " left outer join FORMAS_FARMACEUTICAS ff on ff.cod_forma=cpv.COD_FORMA" +
                    " left outer join COLORES_PRESPRIMARIA cpp on cpp.COD_COLORPRESPRIMARIA=cpv.COD_COLORPRESPRIMARIA" +
                    " left outer join VIAS_ADMINISTRACION_PRODUCTO vap on vap.COD_VIA_ADMINISTRACION_PRODUCTO=cpv.COD_VIA_ADMINISTRACION_PRODUCTO" +
                    " left outer join SABORES_PRODUCTO sp on sp.COD_SABOR=cpv.COD_SABOR" +
                    " left outer join AREAS_EMPRESA ae on ae.COD_AREA_EMPRESA=cpv.COD_AREA_EMPRESA" +
                    " left outer join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=cpv.COD_UNIDAD_MEDIDA_VOLUMEN" +
                    " left outer join TAMANIOS_CAPSULAS_PRODUCCION tc on tc.COD_TAMANIO_CAPSULA_PRODUCCION=cpv.COD_TAMANIO_CAPSULA_PRODUCCION" +
                    " left outer JOIN ESTADOS_COMPPROD ec on ec.COD_ESTADO_COMPPROD=cpv.COD_ESTADO_COMPPROD" +
                    " left outer join ESTADOS_VERSION_COMPONENTES_PROD evc on evc.COD_ESTADO_VERSION_COMPONENTES_PROD=cpv.COD_ESTADO_VERSION" +
                    " inner join COMPONENTES_PROD_VERSION_MODIFICACION cpvm on cpvm.COD_VERSION=cpv.COD_VERSION"+
                    " inner join PERSONAL per on per.COD_PERSONAL=cpvm.COD_PERSONAL"+
                    " inner join ESTADOS_VERSION_COMPONENTES_PROD evcp on evcp.COD_ESTADO_VERSION_COMPONENTES_PROD=cpvm.COD_ESTADO_VERSION_COMPONENTES_PROD" +
                    " outer apply(select top 1 fmv.COD_FORMULA_MAESTRA,fmv.COD_VERSION" +
                    " from FORMULA_MAESTRA_VERSION fmv where fmv.COD_COMPPROD_VERSION=cpv.COD_VERSION"+
                    " and fmv.COD_COMPPROD=cpv.COD_COMPPROD) as detalleFormula" +
                    " where cpv.COD_ESTADO_VERSION='3'" +
                    " order by cpv.nombre_prod_semiterminado,cpv.COD_VERSION";
            LOGGER.debug("consulta cargar versiones producto " + consulta);
            ResultSet res = st.executeQuery(consulta);
            componentesProdVersionAprobarList.clear();
            List<ComponentesProdVersionModificacion> componentesProdVersionModificacionList=new ArrayList<ComponentesProdVersionModificacion>();
            ComponentesProdVersion nuevo = new ComponentesProdVersion();
            while (res.next()) {

                if(nuevo.getCodVersion()!=res.getInt("COD_VERSION"))
                {
                    if(nuevo.getCodVersion()>0)
                    {
                        nuevo.setComponentesProdVersionModificacionList(componentesProdVersionModificacionList);
                        componentesProdVersionAprobarList.add(nuevo);
                        nuevo=new ComponentesProdVersion();
                        componentesProdVersionModificacionList=new ArrayList<ComponentesProdVersionModificacion>();
                    }
                    nuevo.setCodFormulaMaestra(res.getInt("COD_FORMULA_MAESTRA"));
                    nuevo.setCodFormulaMaestraVersion(res.getInt("codVersionFM"));
                    nuevo.setFechaModificacion(res.getTimestamp("FECHA_MODIFICACION"));
                    nuevo.setFechaInicioVigencia(res.getTimestamp("FECHA_INICIO_VIGENCIA"));
                    nuevo.setNroVersion(res.getInt("NRO_VERSION"));
                    nuevo.setFechaVencimientoRS(res.getTimestamp("FECHA_VENCIMIENTO_RS"));
                    nuevo.setToleranciaVolumenfabricar(res.getDouble("TOLERANCIA_VOLUMEN_FABRICAR"));
                    nuevo.getAreasEmpresa().setCodAreaEmpresa(res.getString("COD_AREA_EMPRESA"));
                    nuevo.getAreasEmpresa().setNombreAreaEmpresa(res.getString("NOMBRE_AREA_EMPRESA"));
                    nuevo.setCantidadVolumen(res.getDouble("CANTIDAD_VOLUMEN"));
                    nuevo.getUnidadMedidaVolumen().setCodUnidadMedida(res.getString("COD_UNIDAD_MEDIDA_VOLUMEN"));
                    nuevo.getUnidadMedidaVolumen().setAbreviatura(res.getString("ABREVIATURA"));
                    nuevo.getTamaniosCapsulasProduccion().setCodTamanioCapsulaProduccion(res.getInt("COD_TAMANIO_CAPSULA_PRODUCCION"));
                    nuevo.getTamaniosCapsulasProduccion().setNombreTamanioCapsulaProduccion(res.getString("NOMBRE_TAMANIO_CAPSULA_PRODUCCION"));
                    nuevo.getEstadoCompProd().setCodEstadoCompProd(res.getInt("COD_ESTADO_COMPPROD"));
                    nuevo.getEstadoCompProd().setNombreEstadoCompProd(res.getString("NOMBRE_ESTADO_COMPPROD"));
                    nuevo.setPesoEnvasePrimario(res.getString("PESO_ENVASE_PRIMARIO"));
                    nuevo.setRegSanitario(res.getString("REG_SANITARIO"));
                    nuevo.setConcentracionEnvasePrimario(res.getString("CONCENTRACION_ENVASE_PRIMARIO"));
                    nuevo.setVidaUtil(res.getInt("VIDA_UTIL"));
                    nuevo.setCodVersion(res.getInt("COD_VERSION"));
                    nuevo.setNombreGenerico(res.getString("NOMBRE_GENERICO"));
                    nuevo.setProductoSemiterminado(res.getInt("PRODUCTO_SEMITERMINADO") > 0);
                    nuevo.setCodCompprod(res.getString("COD_COMPPROD"));
                    nuevo.setNombreProdSemiterminado(res.getString("nombre_prod_semiterminado"));
                    nuevo.getProducto().setCodProducto(res.getString("COD_PROD"));
                    nuevo.getProducto().setNombreProducto(res.getString("NOMBRE_PROD"));
                    nuevo.getForma().setCodForma(res.getString("COD_FORMA"));
                    nuevo.getForma().setNombreForma(res.getString("NOMBRE_FORMA"));
                    nuevo.getColoresPresentacion().setCodColor(res.getString("COD_COLORPRESPRIMARIA"));
                    nuevo.getColoresPresentacion().setNombreColor(res.getString("NOMBRE_COLORPRESPRIMARIA"));
                    nuevo.getViasAdministracionProducto().setCodViaAdministracionProducto(res.getInt("COD_VIA_ADMINISTRACION_PRODUCTO"));
                    nuevo.getViasAdministracionProducto().setNombreViaAdministracionProducto(res.getString("NOMBRE_VIA_ADMINISTRACION_PRODUCTO"));
                    nuevo.getSaboresProductos().setCodSabor(res.getString("COD_SABOR"));
                    nuevo.getSaboresProductos().setNombreSabor(res.getString("NOMBRE_SABOR"));
                    nuevo.getEstadosVersionComponentesProd().setCodEstadoVersionComponenteProd(res.getInt("COD_ESTADO_VERSION"));
                    nuevo.getEstadosVersionComponentesProd().setNombreEstadoVersionComponentesProd(res.getString("NOMBRE_ESTADO_VERSION_COMPONENTES_PROD"));
                }
                ComponentesProdVersionModificacion nuevoComp=new ComponentesProdVersionModificacion();
                nuevoComp.getPersonal().setNombrePersonal(res.getString("nombrePersonal"));
                nuevoComp.getPersonal().setCodPersonal(res.getString("COD_PERSONAL"));
                nuevoComp.getEstadosVersionComponentesProd().setNombreEstadoVersionComponentesProd(res.getString("estadosVersionPersonal"));
                componentesProdVersionModificacionList.add(nuevoComp);

            }
            if(nuevo.getCodVersion()>0)
            {
                nuevo.setComponentesProdVersionModificacionList(componentesProdVersionModificacionList);
                componentesProdVersionAprobarList.add(nuevo);
                nuevo=new ComponentesProdVersion();
                componentesProdVersionModificacionList=new ArrayList<ComponentesProdVersionModificacion>();
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
    //funcion para presentaciones primarias y secundarias
    public String eliminarPresentacionPrimaria_action()throws SQLException
    {
        mensaje="";
        for(PresentacionesPrimarias bean:presentacionesPrimariasList)
        {
            if(bean.getChecked())
            {
                try {
                    con = Util.openConnection(con);
                    con.setAutoCommit(false);
                    String consulta = " delete from PRESENTACIONES_PRIMARIAS_VERSION" +
                                      " where COD_PRESENTACION_PRIMARIA='"+bean.getCodPresentacionPrimaria()+"'" +
                                      " and COD_VERSION='"+componentesProdVersionBean.getCodVersion()+"'" +
                                      " and COD_COMPPROD='"+componentesProdVersionBean.getCodCompprod()+"'";
                    LOGGER.debug("consulta delete presentacion primaria "+consulta);
                    PreparedStatement pst = con.prepareStatement(consulta);
                    if (pst.executeUpdate() > 0) LOGGER.info("se elimino la presentacion primaria ");
                    con.commit();
                    pst.close();
                    mensaje="1";
                    con.close();
                } 
                catch (SQLException ex)
                {
                    con.rollback();
                    con.close();
                    mensaje="Ocurrio un error al momento de eliminar la presentacion primaria, intente de nuevo";
                    LOGGER.warn("error", ex);
                }
            }
        }
        if(mensaje.equals("1"))
        {
            this.cargarPresentacionesPrimariasVersionList();
        }
        return null;
    }
    public String editarPresentacionPrimaria_action()
    {
        for(PresentacionesPrimarias bean:presentacionesPrimariasList)
        {
            if(bean.getChecked())
            {
                presentacionesPrimariasEditar=bean;
                break;
            }
        }
        return null;
    }
    public String guardarEdicionPresentacionPrimaria_action()throws SQLException
    {
        mensaje="";
        try {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            String consulta = "update PRESENTACIONES_PRIMARIAS_VERSION set " +
                              " COD_TIPO_PROGRAMA_PROD='"+presentacionesPrimariasEditar.getTiposProgramaProduccion().getCodTipoProgramaProd()+"'," +
                              " COD_ENVASEPRIM='"+presentacionesPrimariasEditar.getEnvasesPrimarios().getCodEnvasePrim()+"',"+
                              " COD_ESTADO_REGISTRO='"+presentacionesPrimariasEditar.getEstadoReferencial().getCodEstadoRegistro()+"'," +
                              " CANTIDAD='"+presentacionesPrimariasEditar.getCantidad()+"'"+
                              " WHERE COD_VERSION='"+componentesProdVersionBean.getCodVersion()+"'" +
                              " AND COD_PRESENTACION_PRIMARIA='"+presentacionesPrimariasEditar.getCodPresentacionPrimaria()+"'";
            LOGGER.debug("consulta update presentacion primaria "+consulta);
            PreparedStatement pst = con.prepareStatement(consulta);
            if (pst.executeUpdate() > 0)LOGGER.info("se guardo la edicion");
            con.commit();
            mensaje="1";
            pst.close();
            con.close();
        } 
        catch (SQLException ex)
        {
            con.rollback();
            con.close();
            mensaje="Ocurrio un error al momento de guardar la edicion,intente de nuevo";
            LOGGER.warn("error", ex);
        }
        return null;
    }
    public String guardarNuevaPresentacionPrimaria_action()throws SQLException
    {
        mensaje="";
        try {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
            String consulta="select isnull(min(c.COD_PRESENTACION_PRIMARIA),0)-1 as codPresentacion from PRESENTACIONES_PRIMARIAS_VERSION c ";
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta);
            int codPresentacionPrimaria=0;
            if(res.next())codPresentacionPrimaria=res.getInt("codPresentacion");
            //validacion para crear posteriormente la version oficial de la presentacion nueva
            if(codPresentacionPrimaria>=0)codPresentacionPrimaria=-1;
            consulta= "INSERT INTO PRESENTACIONES_PRIMARIAS_VERSION(COD_VERSION,COD_PRESENTACION_PRIMARIA," +
                      " COD_COMPPROD, COD_ENVASEPRIM, CANTIDAD,COD_TIPO_PROGRAMA_PROD, COD_ESTADO_REGISTRO, FECHA_MODIFICACION)"+
                      " VALUES ('"+componentesProdVersionBean.getCodVersion()+"'," +
                      " '"+codPresentacionPrimaria+"', '"+componentesProdVersionBean.getCodCompprod()+"'," +
                      "'"+presentacionesPrimariaRegistrar.getEnvasesPrimarios().getCodEnvasePrim()+"'," +
                      "'"+presentacionesPrimariaRegistrar.getCantidad()+"'," +
                      "'"+presentacionesPrimariaRegistrar.getTiposProgramaProduccion().getCodTipoProgramaProd()+"'," +
                      "1,'"+sdf.format(new Date())+"')";
            LOGGER.debug("consulta registrar version presentacion primaria nueva "+consulta);
            PreparedStatement pst = con.prepareStatement(consulta);
            if (pst.executeUpdate() > 0)LOGGER.info("Se registro la nueva presentacion primaria");
            con.commit();
            pst.close();
            mensaje="1";
            con.close();
        } 
        catch (SQLException ex)
        {
            con.rollback();
            con.close();
            mensaje="Ocurrio un error al momento del registro, intente de nuevo";
            LOGGER.warn("error", ex);
        }
        return null;
    }
    private void cargarTiposProgramaProduccionSelectList()
    {
        try {
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            String consulta = "select tpp.COD_TIPO_PROGRAMA_PROD,tpp.NOMBRE_TIPO_PROGRAMA_PROD"+
                              " from TIPOS_PROGRAMA_PRODUCCION tpp order by tpp.NOMBRE_TIPO_PROGRAMA_PROD";
            ResultSet res = st.executeQuery(consulta);
            tiposProgramaProduccionSelectList.clear();
            while (res.next())
            {
                tiposProgramaProduccionSelectList.add(new SelectItem(res.getString("COD_TIPO_PROGRAMA_PROD"),res.getString("NOMBRE_TIPO_PROGRAMA_PROD")));
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
    public String agregarPresentacionPrimaria_action()
    {
        presentacionesPrimariaRegistrar=new PresentacionesPrimarias();
        return null;
    }
    private void cargarEnvasesPrimariosSelectList()
    {
        try {
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            String consulta = "select ep.cod_envaseprim,ep.nombre_envaseprim from ENVASES_PRIMARIOS ep where ep.cod_estado_registro=1"+
                              " order by ep.nombre_envaseprim   ";
            ResultSet res = st.executeQuery(consulta);
            envasesPrimariosSelectList.clear();
            while (res.next())
            {
                envasesPrimariosSelectList.add(new SelectItem(res.getString("cod_envaseprim"),res.getString("nombre_envaseprim")));
            }
            res.close();
            st.close();
            con.close();
        } catch (SQLException ex) {
            LOGGER.warn("error", ex);
        }
    }
    public String mostrarOrdenManufacturaVersionProducto_action()
    {
        ComponentesProdVersion version=(ComponentesProdVersion)componentesProdVersionDataTable.getRowData();
        mensaje = "";
        try 
        {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm");
            StringBuilder consulta = new StringBuilder(" delete programa_produccion where cod_lote_produccion='").append("H").append(version.getCodVersion()).append("';");
                                    consulta.append(" insert into programa_produccion(cod_programa_prod,cod_formula_maestra,cod_lote_produccion,cod_estado_programa,observacion,CANT_LOTE_PRODUCCION,VERSION_LOTE,COD_COMPPROD,COD_TIPO_PROGRAMA_PROD,COD_PRESENTACION,nro_lotes,COD_COMPPROD_PADRE,cod_compprod_version,cod_formula_maestra_version,FECHA_REGISTRO)");
                                    consulta.append(" values(");
                                            consulta.append("0,");
                                            consulta.append(version.getCodFormulaMaestra()).append(",");
                                            consulta.append("'H").append(version.getCodVersion()).append("',");
                                            consulta.append("2,'creado para impresion de OM',");
                                            consulta.append(version.getTamanioLoteProduccion());
                                            consulta.append(",1,");
                                            consulta.append(version.getCodCompprod()).append(",");//oodigp producto
                                            consulta.append("isnull((select top 1 ppv.COD_TIPO_PROGRAMA_PROD from PRESENTACIONES_PRIMARIAS_VERSION ppv where ppv.COD_VERSION=").append(version.getCodVersion()).append("  order by ppv.COD_TIPO_PROGRAMA_PROD),1),");//tipo de produccion
                                            consulta.append("0,");//codigo presentacion
                                            consulta.append("1,");//numero lotes
                                            consulta.append(version.getCodCompprod()).append(",");                                            
                                            consulta.append(version.getCodVersion()).append(",");
                                            consulta.append(version.getCodFormulaMaestraVersion()).append(",");
                                            consulta.append("'").append(sdf.format(new Date())).append("'");
                                    consulta.append(")");
            LOGGER.debug("consulta " + consulta.toString());
            PreparedStatement pst = con.prepareStatement(consulta.toString());
            if (pst.executeUpdate() > 0)LOGGER.info("Se registro la transacción");
            (new CreacionGraficosOrdenManufactura()).crearFlujogramaOrdenManufacturaProduccion(con, LOGGER,"H"+version.getCodVersion(),0,10);
            consulta=new StringBuilder("EXEC PAA_REGISTRO_PROGRAMA_PRODUCCION_DETALLE 0,");
                           consulta.append("'H").append(version.getCodVersion()).append("'");
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
            mensaje = "Ocurrio un error al momento de guardar la transaccion";
            try
            {
                con.rollback();
            }
            catch(SQLException em)
            {
                LOGGER.warn("error", em);
            }
            
        }
        catch (Exception ex) 
        {
            LOGGER.warn(ex.getMessage());
            mensaje = "Ocurrio un error al momento de guardar la transaccion,verifique los datos introducidos";
            
        }
        finally 
        {
            this.cerrarConexion(con);
        }
        return null;
    }
    public String seleccionarComponentesProdVersionEs_action(){
        try {
                ComponentesProdVersion bean=(ComponentesProdVersion)componentesProdVersionDataTable.getRowData();
                FacesContext facesContext = FacesContext.getCurrentInstance();
                ExternalContext externalContext = facesContext.getExternalContext();
                Map map = externalContext.getSessionMap();
                map.put("ComponentesProdVersionEs",bean);
        }
        catch (Exception e) 
        {
            LOGGER.warn("error", e);
        }
        return null;
    }
    public String seleccionarComponenteProdVersion_action()
    {
        componentesProdProcesoOrdenManufacturaBean=new ComponentesProdProcesoOrdenManufactura();
        return null;
    }
    // <editor-fold defaultstate="collapsed" desc="funciones para definir procesos habilitados al producto">
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
        public String seleccionarMostrarProcesosOrdenManufactura()
        {
            componentesProdVersionBean = (ComponentesProdVersion)componentesProdVersionDataTable.getRowData();
            DaoComponentesProdProcesoOrdenManufactura daoProcesos = new DaoComponentesProdProcesoOrdenManufactura(LOGGER);
            componentesProdProcesoOrdenManufacturaList = daoProcesos.listar(componentesProdVersionBean);
            componentesProdProcesoOrdenManufacturaDisponibleList  = daoProcesos.listarNoUtilizado(componentesProdVersionBean);
            return null;
        }
        public String guardarComponentesProdProceosOrdenManufacturaAction()throws SQLException
        {
            transaccionExitosa = false;
            DaoComponentesProdProcesoOrdenManufactura daoProceso = new DaoComponentesProdProcesoOrdenManufactura(LOGGER);
            if(daoProceso.guardarLista(componentesProdProcesoOrdenManufacturaList, componentesProdVersionBean.getCodVersion())){
                this.mostrarMensajeTransaccionExitosa("Se registro satisfactoriamente los procesos configurados");
            }
            else{
                this.mostrarMensajeTransaccionFallida("Ocurrio un error al momento de registrar los pasos configurados, intente de nuevo");
            }
            return null;
        }
    //</editor-fold>
    public String seleccionarComponenteProdVersionProcesosPreparado_action()
    {
        componentesProdVersionBean=(ComponentesProdVersion)componentesProdVersionDataTable.getRowData();
        if(Util.getSessionBean("ManagedProcesosPreparadoProducto")!=null)
            ((ManagedProcesosPreparadoProducto)Util.getSessionBean("ManagedProcesosPreparadoProducto")).setProcesosOrdenManufacturaBean(new ProcesosOrdenManufactura());
        return null;
    }
    public String getCargarPresentacionesPrimariasVersion()
    {
        this.cargarTiposProgramaProduccionSelectList();
        this.cargarEnvasesPrimariosSelectList();
        this.cargarPresentacionesPrimariasVersionList();
        return null;
    }
    private void cargarPresentacionesPrimariasVersionList()
    {
        try
        {
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            String consulta = "select  ep.cod_envaseprim,ep.nombre_envaseprim,pp.CANTIDAD,pp.COD_PRESENTACION_PRIMARIA"+
                              ",tpp.NOMBRE_TIPO_PROGRAMA_PROD,pp.COD_TIPO_PROGRAMA_PROD,er.NOMBRE_ESTADO_REGISTRO,er.COD_ESTADO_REGISTRO"+
                              " from PRESENTACIONES_PRIMARIAS_VERSION pp left outer join ENVASES_PRIMARIOS ep on"+
                              " pp.COD_ENVASEPRIM=ep.cod_envaseprim"+
                              " left outer join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD"+
                              " left outer join ESTADOS_REFERENCIALES er on er.COD_ESTADO_REGISTRO=pp.COD_ESTADO_REGISTRO"+
                              " where pp.COD_VERSION='"+componentesProdVersionBean.getCodVersion()+"' order by ep.nombre_envaseprim";
            LOGGER.debug("consulta cargar presentaciones primarias "+consulta);
            ResultSet res = st.executeQuery(consulta);
            presentacionesPrimariasList.clear();
            while (res.next())
            {
                PresentacionesPrimarias nuevo=new PresentacionesPrimarias();
                nuevo.setCodPresentacionPrimaria(res.getString("COD_PRESENTACION_PRIMARIA"));
                nuevo.getEnvasesPrimarios().setCodEnvasePrim(res.getString("cod_envaseprim"));
                nuevo.getEnvasesPrimarios().setNombreEnvasePrim(res.getString("nombre_envaseprim"));
                nuevo.setCantidad(res.getInt("CANTIDAD"));
                nuevo.getTiposProgramaProduccion().setCodTipoProgramaProd(res.getString("COD_TIPO_PROGRAMA_PROD"));
                nuevo.getTiposProgramaProduccion().setNombreTipoProgramaProd(res.getString("NOMBRE_TIPO_PROGRAMA_PROD"));
                nuevo.getEstadoReferencial().setCodEstadoRegistro(res.getString("COD_ESTADO_REGISTRO"));
                nuevo.getEstadoReferencial().setNombreEstadoRegistro(res.getString("NOMBRE_ESTADO_REGISTRO"));
                presentacionesPrimariasList.add(nuevo);
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
    //function para enviar a aprobacion
    public String sinNecesidadCambios_action()throws SQLException
    {
        mensaje="";
        sinNecesidadDeCambios(componentesProdVersionBean);
                
        if(mensaje.equals("1"))
        {
            this.cargarComponentesProdVersionList();
        }
        return null;
    }
    
    public String enviarAAprobacion_action()throws SQLException
    {
        mensaje="";
        this.enviarAprobacionVersionProducto(componentesProdVersionBean);
        
        if(mensaje.equals("1"))
        {
            this.cargarComponentesProdVersionList();
        }
        return null;
    }
    //funcion cargar datos para pagina navegador
    private void cargarConfiguracionPermisoPersonal()
    {
        
        try 
        {
            ManagedAccesoSistema managed=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select cpe.COD_TIPO_PERMISO_ESPECIAL_ATLAS");
                                        consulta.append(" from CONFIGURACION_PERMISOS_ESPECIALES_ATLAS cpe")
                                                .append(" where cpe.COD_PERSONAL=").append(managed.getUsuarioModuloBean().getCodUsuarioGlobal());
            LOGGER.debug("consulta cargar permisos "+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            controlActivacionInactivacionproducto = false;
            permisoEnviarProductoEstandarizacion  = false;
            controlEmpaqueSecundario=false;
            controlPresentacionPrimaria=false;
            controlRegistroSanitario=false;
            controlControlCalidad=false;
            permisoCreacionVersion = false;
            while (res.next()){
                switch(res.getInt("COD_TIPO_PERMISO_ESPECIAL_ATLAS"))
                {
                    case 18:{
                        controlActivacionInactivacionproducto=true;
                        break;
                    }
                    case 23:{
                        permisoEnviarProductoEstandarizacion =  true;
                        break;
                    }
                    case 33:{
                        controlRegistroSanitario = true;
                        break;
                    }
                    case 34:{
                        controlPresentacionPrimaria = true;
                        break;
                    }
                    case 35:{
                        controlControlCalidad = true;
                        break;
                    }
                    case 36:{
                        controlEmpaqueSecundario = true;
                        break;
                    }
                    case 37:{
                        permisoCreacionVersion = true;
                        break;
                    }
                }
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
    
    private void cargarPermisosVersionCp()
    {
        try
        {
            ManagedAccesoSistema managed=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            String consulta = "select pvc.COD_TIPO_MODIFICACION"+
                                " from PERMISOS_VERSION_CP pvc"+
                                " where pvc.COD_PERSONAL='"+managed.getUsuarioModuloBean().getCodUsuarioGlobal()+"'";
            LOGGER.debug("consulta verificar persmisos "+consulta);
            ResultSet res = st.executeQuery(consulta);
            controlNuevoProducto=false;
            controlPresentacionNuevaGenerico=false;
            
            while (res.next())
            {
                switch(res.getInt("COD_TIPO_MODIFICACION"))
                {
                    case 5: controlNuevoProducto=true;break;
                    case 6: controlPresentacionNuevaGenerico=true;break;
                }
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
    public String siguientePagina_action(){
        begin=begin+numrows;
        end=end+numrows;
        this.cargarComponentesProdList();
        return null;
    }
    
    public String anteriorPagina_action()
    {
        begin=begin-numrows;
        end=end-numrows;
        this.cargarComponentesProdList();
        return null;
    }
    private void cargarEstadosCompProdSelect(){
        DaoEstadosCompProd daoEstados = new DaoEstadosCompProd(LOGGER);
        estadosCompProdSelectList = daoEstados.listarSelectItem();
        
    }
    public String getCargarComponentesProd(){
        this.cargarEstadosCompProdSelect();
        this.cargarCondicionesVentasSelect();
        this.cargarProductosSelectList();
        this.cargarAreasEmpresaSelectList();
        this.cargarFormasFarmaceuticasSelectList();
        this.cargarSaboresProductoSelectList();
        this.cargarUnidadesMedidaSelectList();
        this.cargarViasAdministracionSelectList();
        this.cargarTamaniosCapsulasProduccion();
        this.cargarComponentesProdList();
        this.cargarColoresPresPrimSelectList();
        this.cargarPermisosVersionCp();
        this.cargarConfiguracionPermisoPersonal();
        return null;
    }
    //function cargar nombre comerciales para buscador y registro de producto
    private void cargarProductosSelectList()
    {
        DaoProductos daoProductos = new DaoProductos(LOGGER);
        productosSelectList = daoProductos.listarSelectItem();
    }
    private void cargarTamaniosCapsulasProduccion()
    {
        DaoTamanioCapsulaProduccion daoTamanioCapsula = new DaoTamanioCapsulaProduccion(LOGGER);
        tamaniosCapsulasSelectList = daoTamanioCapsula.listarSelectItem();
    }
    private void cargarAreasEmpresaSelectList()
    {
        DaoAreasEmpresa daoAreasEmpresa = new DaoAreasEmpresa(LOGGER);
        areasEmpresaSelectList = daoAreasEmpresa.listarAreasFabricacionSelectItem();
    }
    private void cargarColoresPresPrimSelectList()
    {
        DaoColoresPresPrimaria daoColores = new DaoColoresPresPrimaria(LOGGER);
        coloresPresPrimSelectList = daoColores.listarSelectItem();
    }

    private void cargarViasAdministracionSelectList()
    {
        try
        {
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            String consulta = "select vap.COD_VIA_ADMINISTRACION_PRODUCTO,vap.NOMBRE_VIA_ADMINISTRACION_PRODUCTO"+
                              " from VIAS_ADMINISTRACION_PRODUCTO vap order by vap.NOMBRE_VIA_ADMINISTRACION_PRODUCTO";
            ResultSet res = st.executeQuery(consulta);
            viasAdministracionSelectList.clear();
            while (res.next())
            {
                viasAdministracionSelectList.add(new SelectItem(res.getInt("COD_VIA_ADMINISTRACION_PRODUCTO"),res.getString("NOMBRE_VIA_ADMINISTRACION_PRODUCTO")));
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
    private void cargarUnidadesMedidaSelectList()
    {
        try {
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            String consulta = "select um.COD_UNIDAD_MEDIDA,um.ABREVIATURA from UNIDADES_MEDIDA um " +
                              " where um.COD_TIPO_MEDIDA in (1,2) order by um.ABREVIATURA";
            ResultSet res = st.executeQuery(consulta);
            unidadesMedidaSelectList.clear();
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
    private void cargarFormasFarmaceuticasSelectList()
    {
        try {
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            String consulta = "select f.cod_forma,f.nombre_forma from FORMAS_FARMACEUTICAS f order by  f.nombre_forma";
            ResultSet res = st.executeQuery(consulta);
            formasFarmaceuticasSelectList.clear();
            while (res.next())
            {
                formasFarmaceuticasSelectList.add(new SelectItem(res.getString("COD_FORMA"),res.getString("NOMBRE_FORMA")));
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
    private void cargarSaboresProductoSelectList()
    {
        try {
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            String consulta = "select sp.COD_SABOR,sp.NOMBRE_SABOR from SABORES_PRODUCTO sp order by sp.NOMBRE_SABOR";
            ResultSet res = st.executeQuery(consulta);
            saboresProductoSelectList.clear();
            while (res.next()) 
            {
                saboresProductoSelectList.add(new SelectItem(res.getString("COD_SABOR"),res.getString("NOMBRE_SABOR")));
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
    //funcion para buscar componentes prod de acuerdo al filtro
    public String buscarComponentesProd_action()
    {
        begin=0;
        end=20;
        this.cargarComponentesProdList();
        return null;
    }
    private void cargarComponentesProdList()
    {
        DaoComponentesProd daoComponentesProd = new DaoComponentesProd(LOGGER);
        componentesProdList = daoComponentesProd.listar(componentesProdBuscar,begin,end);
        cantidadfilas=componentesProdList.size();
    }
    public String seleccionarComponenteProd_action()
    {
        componentesProdBean=(ComponentesProd)componentesProdDataTable.getRowData();
        return null;
    }
    public String buscarComponentesProdVersion_action()
    {
        this.cargarComponentesProdVersionList();
        return null;
    }
    private void cargarTiposModificacionProductoSelectAgregar()
    {
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("SELECT tmp.COD_TIPO_MODIFICACION_PRODUCTO,tmp.NOMBRE_TIPO_MODIFICACION_PRODUCTO");
                                        consulta.append(" FROM TIPOS_MODIFICACION_PRODUCTO tmp");
                                        consulta.append(" where tmp.COD_TIPO_MODIFICACION_PRODUCTO in (1,4)");
                                        consulta.append(" order by tmp.NOMBRE_TIPO_MODIFICACION_PRODUCTO");
            LOGGER.debug("consulta cargar agregar tipo modiicacion producto nuevo "+consulta.toString()); 
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            tiposModificacionProductoSelectList=new ArrayList<SelectItem>();
            while (res.next()) 
            {
                tiposModificacionProductoSelectList.add(new SelectItem(res.getInt("COD_TIPO_MODIFICACION_PRODUCTO"),res.getString("NOMBRE_TIPO_MODIFICACION_PRODUCTO")));
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
    public String buscarNuevosComponentesProdVersion_action()
    {
        this.cargarPermisosVersionCp();
        this.cargarComponentesProdVersionNuevo_action();
        return null;
    }
    public String getCargarComponentesProdVersion()
    {
        this.cargarPermisosVersionCp();
        this.cargarComponentesProdVersionList();
        return null;
    }
    public String editarComponentesProdVersion_action()throws SQLException
    {
        for(ComponentesProdVersion bean:componentesProdVersionList)
        {
            if(bean.getChecked())
            {
                componentesProdVersionEditar=bean;
                break;
            }
        }
        return null;
    }
    // <editor-fold defaultstate="collapsed" desc="para registrar observaciones de version">
    public String seleccionarObservarNuevoProductoVersion_action()
    {
        ManagedAccesoSistema usuario=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
        for(ComponentesProdVersionModificacion bean1:componentesProdVersionTransaccion.getComponentesProdVersionModificacionList())
        {
            if(bean1.getPersonal().getCodPersonal().equals(usuario.getUsuarioModuloBean().getCodUsuarioGlobal()))
            {
                componentesProdVersionModificacionObservar=bean1;
                componentesProdVersionBean=componentesProdVersionTransaccion;
            } 
        }
        return null;
    }
    public String seleccionarObservarVersion_action()
    {
        ManagedAccesoSistema usuario=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
        for(ComponentesProdVersionModificacion bean1:componentesProdVersionBean.getComponentesProdVersionModificacionList())
        {
            if(bean1.getPersonal().getCodPersonal().equals(usuario.getUsuarioModuloBean().getCodUsuarioGlobal()))
            {
                componentesProdVersionModificacionObservar=bean1;
            } 
        }
        return null;
    }
    
    public String guardarObservacionPersonalVersion()throws SQLException
    {
        mensaje = "";
        try 
        {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta = new StringBuilder("update COMPONENTES_PROD_VERSION_MODIFICACION");
                                       consulta.append(" set OBSERVACION_PERSONAL_VERSION=?");
                                       consulta.append(" where COD_VERSION=").append(componentesProdVersionBean.getCodVersion());
                                       consulta.append(" and COD_PERSONAL=").append(componentesProdVersionModificacionObservar.getPersonal().getCodPersonal());
            LOGGER.debug("consulta observar version " + consulta.toString()+" observacion "+componentesProdVersionModificacionObservar.getObservacionPersonalVersion());
            PreparedStatement pst = con.prepareStatement(consulta.toString());
            pst.setString(1,componentesProdVersionModificacionObservar.getObservacionPersonalVersion());
            if (pst.executeUpdate() > 0) LOGGER.info("Se registro la observación");
            con.commit();
            mensaje = "1";
            pst.close();
        } 
        catch (SQLException ex) 
        {
            mensaje = "Ocurrio un error al momento de guardar la observación, intente de nuevo";
            con.rollback();
            LOGGER.warn(ex.getMessage());
        } 
        catch (Exception ex) 
        {
            mensaje = "Ocurrio un error al momento de guardar la observación,verifique los datos introducidos";
            LOGGER.warn(ex.getMessage());
        } 
        finally 
        {
            this.cerrarConexion(con);
        }
        if(mensaje.equals("1"))
        {
            this.cargarComponentesPresProdVersionList();
        }
        return null;
    }
    //</editor-fold>
    public String eliminarComponentesProdVersion_action(int codVersion)throws SQLException
    {
        mensaje="";
        ComponentesProdVersion bean = new ComponentesProdVersion();
        bean.setCodCompprod(componentesProdBean.getCodCompprod());
        bean.setCodVersion(codVersion);
        this.eliminarComponentesProdVersion(bean);
        
        if(mensaje.equals("1"))
        {
            this.cargarComponentesProdVersionList();
        }
        return null;
    }
    public String seleccionarCrearNuevoTamanioLote(){
        DaoComponentesProdVersionModificacion daoModificacion = new DaoComponentesProdVersionModificacion(LOGGER);
        componentesProdVersionModificacionAgregarList = daoModificacion.listarAgregar(new ComponentesProdVersion());
        componentesProdVersionModificacionList = new ArrayList<>();
        ManagedAccesoSistema managed = (ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
        for(ComponentesProdVersionModificacion bean :  componentesProdVersionModificacionAgregarList){
            if(bean.getPersonal().getCodPersonal().equals(managed.getUsuarioModuloBean().getCodUsuarioGlobal())){
                componentesProdVersionModificacionList.add(bean);
                componentesProdVersionModificacionAgregarList.remove(bean);
                break;
            }
        }
        return null;
    }
    public String agregarNuevaVersionAction(){
        DaoComponentesProdVersionModificacion daoModificacion = new DaoComponentesProdVersionModificacion(LOGGER);
        componentesProdVersionModificacionAgregarList = daoModificacion.listarAgregar(new ComponentesProdVersion());
        componentesProdVersionModificacionList = new ArrayList<>();
        ManagedAccesoSistema managed = (ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
        for(ComponentesProdVersionModificacion bean :  componentesProdVersionModificacionAgregarList){
            if(bean.getPersonal().getCodPersonal().equals(managed.getUsuarioModuloBean().getCodUsuarioGlobal())){
                componentesProdVersionModificacionList.add(bean);
                componentesProdVersionModificacionAgregarList.remove(bean);
                break;
            }
        }
        return null;
    }
    public String guardarAgregarNuevaVersionAction()throws SQLException
    {
        this.transaccionExitosa = false;
        EnviarCorreoAprobacionVersionProducto correo=null;
        try {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta = new StringBuilder(" exec PAA_GENERACION_NUEVA_VERSION_PRODUCTO ");
                                        consulta.append(componentesProdBean.getCodCompprod()).append(",");
                                        consulta.append("1,");//version de producto
                                        consulta.append("0,");
                                        consulta.append("0,?");
            LOGGER.debug("consulta crear version producto "+consulta.toString());
            CallableStatement callDesviacionBajoRendimiento=con.prepareCall(consulta.toString());
            callDesviacionBajoRendimiento.registerOutParameter(1,java.sql.Types.INTEGER);
            callDesviacionBajoRendimiento.execute();
            int codVersion=callDesviacionBajoRendimiento.getInt(1);
            PreparedStatement pst=null;
            SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm");
            ManagedAccesoSistema managed=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
            consulta=new StringBuilder("INSERT INTO COMPONENTES_PROD_VERSION_MODIFICACION(COD_PERSONAL, COD_VERSION,COD_ESTADO_VERSION_COMPONENTES_PROD,")
                                        .append(" FECHA_INCLUSION_VERSION,COD_TIPO_PERMISO_ESPECIAL_ATLAS,FECHA_ASIGNACION)")
                                .append(" VALUES (")
                                        .append("?,")
                                        .append(codVersion).append(",")
                                        .append("?,")//COD ESTADO VERSION ASIGNACION
                                        .append("?,")//fecha inclusion
                                        .append("?,")
                                        .append("getdate()")
                                .append(")");
            LOGGER.debug("consulta insertar usuario modificacion "+consulta);
            pst=con.prepareStatement(consulta.toString());
            for(ComponentesProdVersionModificacion bean :  componentesProdVersionModificacionList){
                pst.setString(1, bean.getPersonal().getCodPersonal());LOGGER.info("p1: "+bean.getPersonal().getCodPersonal());
                int codEstadoModificacion = bean.getPersonal().getCodPersonal().equals(managed.getUsuarioModuloBean().getCodUsuarioGlobal())?COD_ESTADO_MODIFICACION_REGISTRADO :  COD_ESTADO_MODIFICACION_ASIGNADO;
                pst.setInt(2, codEstadoModificacion);LOGGER.info("p2: "+codEstadoModificacion);
                Date fechaInclusionVersion =  (bean.getPersonal().getCodPersonal().equals(managed.getUsuarioModuloBean().getCodUsuarioGlobal()) ? new Date() : null);
                pst.setTimestamp(3,Util.fechaParametro(fechaInclusionVersion));LOGGER.info("p3: "+fechaInclusionVersion);
                pst.setInt(4,bean.getTiposPermisosEspecialesAtlas().getCodTipoPermisoEspecialAtlas());LOGGER.info("p4: "+bean.getTiposPermisosEspecialesAtlas().getCodTipoPermisoEspecialAtlas());
                if(pst.executeUpdate()>0)LOGGER.info("se registro la colaboracion ");
            }
            HttpServletRequest  request=(HttpServletRequest)FacesContext.getCurrentInstance().getExternalContext().getRequest();
            correo=new EnviarCorreoAprobacionVersionProducto(Integer.valueOf(componentesProdBean.getCodCompprod()), codVersion, false, request.getSession().getServletContext());
            con.commit();
            this.mostrarMensajeTransaccionExitosa("Se registro satisfactoriamente la nueva versión");
            
        }
        catch (SQLException ex)
        {
            LOGGER.warn("error", ex);
            con.rollback();
            con.close();
            this.mostrarMensajeTransaccionFallida("Ocurrio un error al momento de registrar la nueva version "+ex.getMessage());
        }
        finally
        {
            this.cerrarConexion(con);
        }
        if(this.transaccionExitosa)
        {
            this.cargarComponentesProdVersionList();
            if(correo!=null)
            {
                correo.start();
            }
        }
        return null;
    }
    public String guardarEdicionComponentesProdVersion_action()throws SQLException
    {
        this.transaccionExitosa = false;
        DaoComponentesProdVersion daoComponentesProdVersion = new DaoComponentesProdVersion(LOGGER);
        for(ComponentesProdConcentracion bean : componentesProdVersionEditar.getComponentesProdConcentracionList())
            bean.setUnidadProducto(componentesProdConcentracionBean.getUnidadProducto());
        if(daoComponentesProdVersion.editar(componentesProdVersionEditar)){
            this.mostrarMensajeTransaccionExitosa("Se guardo la edición de la versión");
        }
        else{
            this.mostrarMensajeTransaccionFallida("Ocurrio un error al momento de editar el producto, intente de nuevo");
        }
        
        return null;
    }
    public String getCargarEdicionComponentesProdVersion_action()
    {
        this.cargarAreasEmpresaSelectList();
        this.cargarProductosSelectList();
        tamanioLoteEditar = componentesProdVersionEditar.getTamanioLoteProduccion();
        DaoComponentesProdConcentracion daoConcentracion = new DaoComponentesProdConcentracion(LOGGER);
        componentesProdVersionEditar.setComponentesProdConcentracionList(daoConcentracion.listar(componentesProdVersionEditar));
        if(componentesProdVersionEditar.getComponentesProdConcentracionList().size()>0)
        {
            componentesProdConcentracionBean = componentesProdVersionEditar.getComponentesProdConcentracionList().get(0);
            unidadesProducto = componentesProdConcentracionBean.getUnidadProducto();
        }
        if(componentesProdVersionEditar.getNombreProdSemiterminado()==null||componentesProdVersionEditar.getNombreProdSemiterminado().equals(""))
        {
            componentesProdVersionEditar.setNombreProdSemiterminado(componentesProdVersionEditar.getProducto().getNombreProducto()+" "+componentesProdVersionEditar.getForma().getNombreForma()+" "+componentesProdVersionEditar.getSaboresProductos().getNombreSabor());
        }
        return null;
    }
    public String agregarPersonalVersion_action()throws SQLException
    {
        this.agregarPersonalVersion(componentesProdVersionBean);
        
        if(mensaje.equals("1"))
        {
            this.cargarComponentesProdVersionList();
        }
        return null;
    }
    private void cargarComponentesProdVersionList()
    {
        ComponentesProdVersion bean = new ComponentesProdVersion();
        bean.setCodCompprod(componentesProdBean.getCodCompprod());
        bean.setComponentesProdVersionModificacionPersonal(new ComponentesProdVersionModificacion());
        ManagedAccesoSistema managed = (ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
        bean.getComponentesProdVersionModificacionPersonal().getPersonal().setCodPersonal(managed.getUsuarioModuloBean().getCodUsuarioGlobal());
        DaoComponentesProdVersion daoComponentesProdVersion  = new DaoComponentesProdVersion(LOGGER);
        componentesProdVersionList = daoComponentesProdVersion.listar(bean);
        
    }
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
            componentesProdVersionEditar.getComponentesProdConcentracionList().add(bean);
            return null;
        }
        public String seleccionarAgregarNuevoMaterialConcentracionAction()
        {
            ComponentesProdConcentracion bean = new ComponentesProdConcentracion();
            bean.setMateriales(materiales);
            componentesProdVersionNuevo.getComponentesProdConcentracionList().add(bean);
            return null;
        }
    //</editor-fold>
    //<editor-fold defaultstate="collapsed" desc="crear nuevo registro de producto">
        public String agregarNuevoProductoAction()
        {
            producto = new Producto();
            producto.getEstadoProducto().setCodEstadoProducto("1");
            return null;
        }
        public String guardarProductoNuevoComponentesProd()throws SQLException
        {
            mensaje = "";
            DaoProductos daoProductos = new DaoProductos();
            if(daoProductos.guardar(producto))
            {
                mensaje = "1";
                this.cargarProductosSelectList();
                componentesProdVersionNuevo.getProducto().setCodProducto(producto.getCodProducto());
            }
            else
            {
                mensaje = "Ocurrio un error al momento de guardar el producto, intente de nuevo y verifique que el nombre no se encuentre registrado";
            }
            return null;
        }
        public String guardarProducto()throws SQLException
        {
            mensaje = "";
            DaoProductos daoProductos = new DaoProductos();
            if(daoProductos.guardar(producto))
            {
                mensaje = "1";
                this.cargarProductosSelectList();
                componentesProdVersionEditar.getProducto().setCodProducto(producto.getCodProducto());
            }
            else
            {
                mensaje = "Ocurrio un error al momento de guardar el producto, intente de nuevo y verifique que el nombre no se encuentre registrado";
            }
            return null;
        }
    //</editor-fold>    

    //<editor-fold desc="getter and setter" defaultstate="collapsed">

        public List<SelectItem> getEstadosCompProdSelectList() {
            return estadosCompProdSelectList;
        }

        public void setEstadosCompProdSelectList(List<SelectItem> estadosCompProdSelectList) {
            this.estadosCompProdSelectList = estadosCompProdSelectList;
        }


        public List<ComponentesProdProcesoOrdenManufactura> getComponentesProdProcesoOrdenManufacturaDisponibleList() {
            return componentesProdProcesoOrdenManufacturaDisponibleList;
        }

        public void setComponentesProdProcesoOrdenManufacturaDisponibleList(List<ComponentesProdProcesoOrdenManufactura> componentesProdProcesoOrdenManufacturaDisponibleList) {
            this.componentesProdProcesoOrdenManufacturaDisponibleList = componentesProdProcesoOrdenManufacturaDisponibleList;
        }

        
        
        
        public ComponentesProdVersion getComponentesProdVersionTransaccion() {
            return componentesProdVersionTransaccion;
        }

        public void setComponentesProdVersionTransaccion(ComponentesProdVersion componentesProdVersionTransaccion) {
            this.componentesProdVersionTransaccion = componentesProdVersionTransaccion;
        }
        

        public Producto getProducto() {
            return producto;
        }

        public void setProducto(Producto producto) {
            this.producto = producto;
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
        

        public boolean isControlPresentacionNuevaGenerico() {
            return controlPresentacionNuevaGenerico;
        }

        public void setControlPresentacionNuevaGenerico(boolean controlPresentacionNuevaGenerico) {
            this.controlPresentacionNuevaGenerico = controlPresentacionNuevaGenerico;
        }
        public List<SelectItem> getTiposModificacionProductoSelectList() {
            return tiposModificacionProductoSelectList;
        }

        public void setTiposModificacionProductoSelectList(List<SelectItem> tiposModificacionProductoSelectList) {
            this.tiposModificacionProductoSelectList = tiposModificacionProductoSelectList;
        }
        public ComponentesProd getComponentesProdBuscar() {
            return componentesProdBuscar;
        }

        public void setComponentesProdBuscar(ComponentesProd componentesProdBuscar) {
            this.componentesProdBuscar = componentesProdBuscar;
        }

        public List<ComponentesProd> getComponentesProdList() {
            return componentesProdList;
        }

        public void setComponentesProdList(List<ComponentesProd> componentesProdList) {
            this.componentesProdList = componentesProdList;
        }

        public List<SelectItem> getProductosSelectList() {
            return productosSelectList;
        }

        public void setProductosSelectList(List<SelectItem> productosSelectList) {
            this.productosSelectList = productosSelectList;
        }

        public HtmlDataTable getComponentesProdDataTable() {
            return componentesProdDataTable;
        }

        public void setComponentesProdDataTable(HtmlDataTable componentesProdDataTable) {
            this.componentesProdDataTable = componentesProdDataTable;
        }

        public ComponentesProd getComponentesProdBean() {
            return componentesProdBean;
        }

        public void setComponentesProdBean(ComponentesProd componentesProdBean) {
            this.componentesProdBean = componentesProdBean;
        }

        public ComponentesProdVersion getComponentesProdVersionEditar() {
            return componentesProdVersionEditar;
        }
        

        public void setComponentesProdVersionEditar(ComponentesProdVersion componentesProdVersionEditar) {
            this.componentesProdVersionEditar = componentesProdVersionEditar;
        }

        public boolean isControlActivacionInactivacionproducto() {
            return controlActivacionInactivacionproducto;
        }

        public void setControlActivacionInactivacionproducto(boolean controlActivacionInactivacionproducto) {
            this.controlActivacionInactivacionproducto = controlActivacionInactivacionproducto;
        }

        public List<ComponentesProdVersion> getComponentesProdVersionList() {
            return componentesProdVersionList;
        }
        

        public void setComponentesProdVersionList(List<ComponentesProdVersion> componentesProdVersionList) {
            this.componentesProdVersionList = componentesProdVersionList;
        }

        public List<TiposMaterialProduccion> getFormulaMaestraDetalleMPList() {
            return formulaMaestraDetalleMPList;
        }

        public void setFormulaMaestraDetalleMPList(List<TiposMaterialProduccion> formulaMaestraDetalleMPList) {
            this.formulaMaestraDetalleMPList = formulaMaestraDetalleMPList;
        }

        
        public String getMensaje() {
            return mensaje;
        }

        public void setMensaje(String mensaje) {
            this.mensaje = mensaje;
        }

        public List<SelectItem> getFormasFarmaceuticasSelectList() {
            return formasFarmaceuticasSelectList;
        }

        public void setFormasFarmaceuticasSelectList(List<SelectItem> formasFarmaceuticasSelectList) {
            this.formasFarmaceuticasSelectList = formasFarmaceuticasSelectList;
        }

        public List<SelectItem> getSaboresProductoSelectList() {
            return saboresProductoSelectList;
        }

        public void setSaboresProductoSelectList(List<SelectItem> saboresProductoSelectList) {
            this.saboresProductoSelectList = saboresProductoSelectList;
        }

        public List<ComponentesProdConcentracion> getComponentesProdConcentracionList() {
            return componentesProdConcentracionList;
        }

        public void setComponentesProdConcentracionList(List<ComponentesProdConcentracion> componentesProdConcentracionList) {
            this.componentesProdConcentracionList = componentesProdConcentracionList;
        }

        public String getUnidadesProducto() {
            return unidadesProducto;
        }

        public void setUnidadesProducto(String unidadesProducto) {
            this.unidadesProducto = unidadesProducto;
        }

        public List<SelectItem> getUnidadesMedidaSelectList() {
            return unidadesMedidaSelectList;
        }

        public void setUnidadesMedidaSelectList(List<SelectItem> unidadesMedidaSelectList) {
            this.unidadesMedidaSelectList = unidadesMedidaSelectList;
        }

        public ComponentesProdConcentracion getComponentesProdConcentracionBean() {
            return componentesProdConcentracionBean;
        }

        public void setComponentesProdConcentracionBean(ComponentesProdConcentracion componentesProdConcentracionBean) {
            this.componentesProdConcentracionBean = componentesProdConcentracionBean;
        }

        public List<SelectItem> getViasAdministracionSelectList() {
            return viasAdministracionSelectList;
        }

        public void setViasAdministracionSelectList(List<SelectItem> viasAdministracionSelectList) {
            this.viasAdministracionSelectList = viasAdministracionSelectList;
        }

        public List<SelectItem> getColoresPresPrimSelectList() {
            return coloresPresPrimSelectList;
        }

        public void setColoresPresPrimSelectList(List<SelectItem> coloresPresPrimSelectList) {
            this.coloresPresPrimSelectList = coloresPresPrimSelectList;
        }

        public List<SelectItem> getAreasEmpresaSelectList() {
            return areasEmpresaSelectList;
        }

        public void setAreasEmpresaSelectList(List<SelectItem> areasEmpresaSelectList) {
            this.areasEmpresaSelectList = areasEmpresaSelectList;
        }

        public List<SelectItem> getTamaniosCapsulasSelectList() {
            return tamaniosCapsulasSelectList;
        }

        public void setTamaniosCapsulasSelectList(List<SelectItem> tamaniosCapsulasSelectList) {
            this.tamaniosCapsulasSelectList = tamaniosCapsulasSelectList;
        }

        public ComponentesProdVersion getComponentesProdVersionBean() {
            return componentesProdVersionBean;
        }

        public void setComponentesProdVersionBean(ComponentesProdVersion componentesProdVersionBean) {
            this.componentesProdVersionBean = componentesProdVersionBean;
        }

        public HtmlDataTable getComponentesProdVersionDataTable() {
            return componentesProdVersionDataTable;
        }

        public void setComponentesProdVersionDataTable(HtmlDataTable componentesProdVersionDataTable) {
            this.componentesProdVersionDataTable = componentesProdVersionDataTable;
        }

        public List<PresentacionesPrimarias> getPresentacionesPrimariasList() {
            return presentacionesPrimariasList;
        }

        public void setPresentacionesPrimariasList(List<PresentacionesPrimarias> presentacionesPrimariasList) {
            this.presentacionesPrimariasList = presentacionesPrimariasList;
        }

        public List<SelectItem> getEnvasesPrimariosSelectList() {
            return envasesPrimariosSelectList;
        }

        public void setEnvasesPrimariosSelectList(List<SelectItem> envasesPrimariosSelectList) {
            this.envasesPrimariosSelectList = envasesPrimariosSelectList;
        }

        public PresentacionesPrimarias getPresentacionesPrimariaRegistrar() {
            return presentacionesPrimariaRegistrar;
        }

        public void setPresentacionesPrimariaRegistrar(PresentacionesPrimarias presentacionesPrimariaRegistrar) {
            this.presentacionesPrimariaRegistrar = presentacionesPrimariaRegistrar;
        }

        public List<SelectItem> getTiposProgramaProduccionSelectList() {
            return tiposProgramaProduccionSelectList;
        }

        public void setTiposProgramaProduccionSelectList(List<SelectItem> tiposProgramaProduccionSelectList) {
            this.tiposProgramaProduccionSelectList = tiposProgramaProduccionSelectList;
        }

        public PresentacionesPrimarias getPresentacionesPrimariasEditar() {
            return presentacionesPrimariasEditar;
        }

        public void setPresentacionesPrimariasEditar(PresentacionesPrimarias presentacionesPrimariasEditar) {
            this.presentacionesPrimariasEditar = presentacionesPrimariasEditar;
        }

        public List<ComponentesProdVersion> getComponentesProdVersionAprobarList() {
            return componentesProdVersionAprobarList;
        }

        public void setComponentesProdVersionAprobarList(List<ComponentesProdVersion> componentesProdVersionAprobarList) {
            this.componentesProdVersionAprobarList = componentesProdVersionAprobarList;
        }

        public ComponentesProdVersion getComponentesProdVersionRevisar() {
            return componentesProdVersionRevisar;
        }

        public void setComponentesProdVersionRevisar(ComponentesProdVersion componentesProdVersionRevisar) {
            this.componentesProdVersionRevisar = componentesProdVersionRevisar;
        }

        public List<ComponentesProdVersion> getComponentesProdVersionNuevoList() {
            return componentesProdVersionNuevoList;
        }

        public void setComponentesProdVersionNuevoList(List<ComponentesProdVersion> componentesProdVersionNuevoList) {
            this.componentesProdVersionNuevoList = componentesProdVersionNuevoList;
        }

        public HtmlDataTable getComponentesProdVersionNuevoDataTable() {
            return componentesProdVersionNuevoDataTable;
        }

        public void setComponentesProdVersionNuevoDataTable(HtmlDataTable componentesProdVersionNuevoDataTable) {
            this.componentesProdVersionNuevoDataTable = componentesProdVersionNuevoDataTable;
        }

        public ComponentesProdVersion getComponentesProdVersionNuevo() {
            return componentesProdVersionNuevo;
        }

        public void setComponentesProdVersionNuevo(ComponentesProdVersion componentesProdVersionNuevo) {
            this.componentesProdVersionNuevo = componentesProdVersionNuevo;
        }

        public List<ComponentesProdConcentracion> getComponentesProdConcentracionAgregarList() {
            return componentesProdConcentracionAgregarList;
        }

        public void setComponentesProdConcentracionAgregarList(List<ComponentesProdConcentracion> componentesProdConcentracionAgregarList) {
            this.componentesProdConcentracionAgregarList = componentesProdConcentracionAgregarList;
        }

        public boolean isControlEmpaqueSecundario() {
            return controlEmpaqueSecundario;
        }

        public void setControlEmpaqueSecundario(boolean controlEmpaqueSecundario) {
            this.controlEmpaqueSecundario = controlEmpaqueSecundario;
        }

        public boolean isControlPresentacionPrimaria() {
            return controlPresentacionPrimaria;
        }

        public void setControlPresentacionPrimaria(boolean controlPresentacionPrimaria) {
            this.controlPresentacionPrimaria = controlPresentacionPrimaria;
        }

        public boolean isControlRegistroSanitario() {
            return controlRegistroSanitario;
        }

        public void setControlRegistroSanitario(boolean controlRegistroSanitario) {
            this.controlRegistroSanitario = controlRegistroSanitario;
        }

        public ComponentesPresProd getComponentesPresProdAgregar() {
            return componentesPresProdAgregar;
        }

        public void setComponentesPresProdAgregar(ComponentesPresProd componentesPresProdAgregar) {
            this.componentesPresProdAgregar = componentesPresProdAgregar;
        }

        public ComponentesPresProd getComponentesPresProdEditar() {
            return componentesPresProdEditar;
        }

        public void setComponentesPresProdEditar(ComponentesPresProd componentesPresProdEditar) {
            this.componentesPresProdEditar = componentesPresProdEditar;
        }

        public List<ComponentesPresProd> getComponentesPresProdList() {
            return componentesPresProdList;
        }

        public void setComponentesPresProdList(List<ComponentesPresProd> componentesPresProdList) {
            this.componentesPresProdList = componentesPresProdList;
        }

        public List<SelectItem> getPresentacionesProductoSelectList() {
            return presentacionesProductoSelectList;
        }

        public void setPresentacionesProductoSelectList(List<SelectItem> presentacionesProductoSelectList) {
            this.presentacionesProductoSelectList = presentacionesProductoSelectList;
        }

        public List<EspecificacionesFisicasProducto> getEspecificacionesFisicasProductoList() {
            return especificacionesFisicasProductoList;
        }

        public void setEspecificacionesFisicasProductoList(List<EspecificacionesFisicasProducto> especificacionesFisicasProductoList) {
            this.especificacionesFisicasProductoList = especificacionesFisicasProductoList;
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

        public List<EspecificacionesQuimicasCc> getEspecificacionesQuimicasProductoList() {
            return especificacionesQuimicasProductoList;
        }

        public void setEspecificacionesQuimicasProductoList(List<EspecificacionesQuimicasCc> especificacionesQuimicasProductoList) {
            this.especificacionesQuimicasProductoList = especificacionesQuimicasProductoList;
        }

        public List<Materiales> getListaMaterialesPrincipioActivo() {
            return listaMaterialesPrincipioActivo;
        }

        public void setListaMaterialesPrincipioActivo(List<Materiales> listaMaterialesPrincipioActivo) {
            this.listaMaterialesPrincipioActivo = listaMaterialesPrincipioActivo;
        }

        public List<EspecificacionesMicrobiologiaProducto> getEspecificacionesMicrobiologiaProductoList() {
            return especificacionesMicrobiologiaProductoList;
        }

        public void setEspecificacionesMicrobiologiaProductoList(List<EspecificacionesMicrobiologiaProducto> especificacionesMicrobiologiaProductoList) {
            this.especificacionesMicrobiologiaProductoList = especificacionesMicrobiologiaProductoList;
        }

        public List<SelectItem> getCondicionesVentasSelectList() {
            return condicionesVentasSelectList;
        }

        public void setCondicionesVentasSelectList(List<SelectItem> condicionesVentasSelectList) {
            this.condicionesVentasSelectList = condicionesVentasSelectList;
        }

        public boolean isControlControlCalidad() {
            return controlControlCalidad;
        }

        public void setControlControlCalidad(boolean controlControlCalidad) {
            this.controlControlCalidad = controlControlCalidad;
        }





        public List<SelectItem> getMaquinariasSelectList() {
            return maquinariasSelectList;
        }

        public void setMaquinariasSelectList(List<SelectItem> maquinariasSelectList) {
            this.maquinariasSelectList = maquinariasSelectList;
        }

        public List<ComponentesProdVersionMaquinariaProceso> getComponentesProdVersionMaquinariaProcesoList() {
            return componentesProdVersionMaquinariaProcesoList;
        }

        public void setComponentesProdVersionMaquinariaProcesoList(List<ComponentesProdVersionMaquinariaProceso> componentesProdVersionMaquinariaProcesoList) {
            this.componentesProdVersionMaquinariaProcesoList = componentesProdVersionMaquinariaProcesoList;
        }



        public ComponentesProdVersionMaquinariaProceso getComponentesProdVersionMaquinariaProcesoBean() {
            return componentesProdVersionMaquinariaProcesoBean;
        }

        public void setComponentesProdVersionMaquinariaProcesoBean(ComponentesProdVersionMaquinariaProceso componentesProdVersionMaquinariaProcesoBean) {
            this.componentesProdVersionMaquinariaProcesoBean = componentesProdVersionMaquinariaProcesoBean;
        }

        public List<SelectItem> getTiposDescripcionSelectList() {
            return tiposDescripcionSelectList;
        }

        public void setTiposDescripcionSelectList(List<SelectItem> tiposDescripcionSelectList) {
            this.tiposDescripcionSelectList = tiposDescripcionSelectList;
        }

        public List<ProcesosOrdenManufactura> getProcesosOrdenManufacturaList() {
            return procesosOrdenManufacturaList;
        }

        public void setProcesosOrdenManufacturaList(List<ProcesosOrdenManufactura> procesosOrdenManufacturaList) {
            this.procesosOrdenManufacturaList = procesosOrdenManufacturaList;
        }

        public ProcesosOrdenManufactura getProcesoEspecificacionBean() {
            return procesoEspecificacionBean;
        }

        public void setProcesoEspecificacionBean(ProcesosOrdenManufactura procesoEspecificacionBean) {
            this.procesoEspecificacionBean = procesoEspecificacionBean;
        }


        public List<SelectItem> getUnidadesMedidaGeneralSelectList() {
            return unidadesMedidaGeneralSelectList;
        }

        public void setUnidadesMedidaGeneralSelectList(List<SelectItem> unidadesMedidaGeneralSelectList) {
            this.unidadesMedidaGeneralSelectList = unidadesMedidaGeneralSelectList;
        }

        public List<IndicacionProceso> getIndicacionesProcesoList() {
            return indicacionesProcesoList;
        }

        public void setIndicacionesProcesoList(List<IndicacionProceso> indicacionesProcesoList) {
            this.indicacionesProcesoList = indicacionesProcesoList;
        }

        public ComponentesProdVersion getComponentesProdVersionModificarFracciones() {
            return componentesProdVersionModificarFracciones;
        }

        public void setComponentesProdVersionModificarFracciones(ComponentesProdVersion componentesProdVersionModificarFracciones) {
            this.componentesProdVersionModificarFracciones = componentesProdVersionModificarFracciones;
        }


        public IndicacionProceso getIndicacionProcesoBean() {
            return indicacionProcesoBean;
        }

        public void setIndicacionProcesoBean(IndicacionProceso indicacionProcesoBean) {
            this.indicacionProcesoBean = indicacionProcesoBean;
        }

        public List<SelectItem> getTiposIndicacionProcesoSelectList() {
            return tiposIndicacionProcesoSelectList;
        }

        public void setTiposIndicacionProcesoSelectList(List<SelectItem> tiposIndicacionProcesoSelectList) {
            this.tiposIndicacionProcesoSelectList = tiposIndicacionProcesoSelectList;
        }

        public ComponentesProdVersionModificacion getComponentesProdVersionModificacionObservar() {
            return componentesProdVersionModificacionObservar;
        }

        public void setComponentesProdVersionModificacionObservar(ComponentesProdVersionModificacion componentesProdVersionModificacionObservar) {
            this.componentesProdVersionModificacionObservar = componentesProdVersionModificacionObservar;
        }

        public List<ComponentesProdProcesoOrdenManufactura> getComponentesProdProcesoOrdenManufacturaList() {
            return componentesProdProcesoOrdenManufacturaList;
        }

        public void setComponentesProdProcesoOrdenManufacturaList(List<ComponentesProdProcesoOrdenManufactura> componentesProdProcesoOrdenManufacturaList) {
            this.componentesProdProcesoOrdenManufacturaList = componentesProdProcesoOrdenManufacturaList;
        }

        public ComponentesProdProcesoOrdenManufactura getComponentesProdProcesoOrdenManufacturaBean() {
            return componentesProdProcesoOrdenManufacturaBean;
        }

        public void setComponentesProdProcesoOrdenManufacturaBean(ComponentesProdProcesoOrdenManufactura componentesProdProcesoOrdenManufacturaBean) {
            this.componentesProdProcesoOrdenManufacturaBean = componentesProdProcesoOrdenManufacturaBean;
        }

        public List<ComponentesProdProcesoOrdenManufactura> getComponentesProdProcesoOrdenManufacturaSeleccionList() {
            return componentesProdProcesoOrdenManufacturaSeleccionList;
        }

        public void setComponentesProdProcesoOrdenManufacturaSeleccionList(List<ComponentesProdProcesoOrdenManufactura> componentesProdProcesoOrdenManufacturaSeleccionList) {
            this.componentesProdProcesoOrdenManufacturaSeleccionList = componentesProdProcesoOrdenManufacturaSeleccionList;
        }

        public HtmlDataTable getComponentesProdProcesoDataTable() {
            return componentesProdProcesoDataTable;
        }

        public void setComponentesProdProcesoDataTable(HtmlDataTable componentesProdProcesoDataTable) {
            this.componentesProdProcesoDataTable = componentesProdProcesoDataTable;
        }

        public List<ComponentesProdVersion> getComponentesProdVersionNuevosTamaniosLoteProduccion() {
            return componentesProdVersionNuevosTamaniosLoteProduccion;
        }

        public void setComponentesProdVersionNuevosTamaniosLoteProduccion(List<ComponentesProdVersion> componentesProdVersionNuevosTamaniosLoteProduccion) {
            this.componentesProdVersionNuevosTamaniosLoteProduccion = componentesProdVersionNuevosTamaniosLoteProduccion;
        }

        public HtmlDataTable getComponentesProdVersionNuevosTamaniosDataTable() {
            return componentesProdVersionNuevosTamaniosDataTable;
        }

        public void setComponentesProdVersionNuevosTamaniosDataTable(HtmlDataTable componentesProdVersionNuevosTamaniosDataTable) {
            this.componentesProdVersionNuevosTamaniosDataTable = componentesProdVersionNuevosTamaniosDataTable;
        }

        public int getNuevoTamanioLoteProduccion() {
            return nuevoTamanioLoteProduccion;
        }

        public void setNuevoTamanioLoteProduccion(int nuevoTamanioLoteProduccion) {
            this.nuevoTamanioLoteProduccion = nuevoTamanioLoteProduccion;
        }

        public boolean isControlNuevoProducto() {
            return controlNuevoProducto;
        }

        public void setControlNuevoProducto(boolean controlNuevoProducto) {
            this.controlNuevoProducto = controlNuevoProducto;
        }

        public List<ComponentesProdVersionFiltroProduccion> getComponentesProdVersionFiltroProduccionList() {
            return componentesProdVersionFiltroProduccionList;
        }

        public void setComponentesProdVersionFiltroProduccionList(List<ComponentesProdVersionFiltroProduccion> componentesProdVersionFiltroProduccionList) {
            this.componentesProdVersionFiltroProduccionList = componentesProdVersionFiltroProduccionList;
        }



        public List<FiltrosProduccion> getFiltrosProduccionAgregarList() {
            return filtrosProduccionAgregarList;
        }

        public void setFiltrosProduccionAgregarList(List<FiltrosProduccion> filtrosProduccionAgregarList) {
            this.filtrosProduccionAgregarList = filtrosProduccionAgregarList;
        }

        public List<ComponentesProdVersionLimpiezaMaquinaria> getComponentesProdVersionLimpiezaMaquinariaList() {
            return componentesProdVersionLimpiezaMaquinariaList;
        }

        public void setComponentesProdVersionLimpiezaMaquinariaList(List<ComponentesProdVersionLimpiezaMaquinaria> componentesProdVersionLimpiezaMaquinariaList) {
            this.componentesProdVersionLimpiezaMaquinariaList = componentesProdVersionLimpiezaMaquinariaList;
        }

        public List<ComponentesProdVersionLimpiezaMaquinaria> getMaquinariasLimpiezaAgregarList() {
            return maquinariasLimpiezaAgregarList;
        }

        public void setMaquinariasLimpiezaAgregarList(List<ComponentesProdVersionLimpiezaMaquinaria> maquinariasLimpiezaAgregarList) {
            this.maquinariasLimpiezaAgregarList = maquinariasLimpiezaAgregarList;
        }



        public List<ComponentesProdVersionLimpiezaSeccion> getComponentesProdVersionLimpiezaSeccionList() {
            return componentesProdVersionLimpiezaSeccionList;
        }

        public void setComponentesProdVersionLimpiezaSeccionList(List<ComponentesProdVersionLimpiezaSeccion> componentesProdVersionLimpiezaSeccionList) {
            this.componentesProdVersionLimpiezaSeccionList = componentesProdVersionLimpiezaSeccionList;
        }

        public List<ComponentesProdVersionLimpiezaSeccion> getSeccionesOrdenManufacturaAgregarList() {
            return seccionesOrdenManufacturaAgregarList;
        }

        public void setSeccionesOrdenManufacturaAgregarList(List<ComponentesProdVersionLimpiezaSeccion> seccionesOrdenManufacturaAgregarList) {
            this.seccionesOrdenManufacturaAgregarList = seccionesOrdenManufacturaAgregarList;
        }



        public List<SelectItem> getTiposEspecificacionesProcesoProductoMaquinariaSelectList() {
            return tiposEspecificacionesProcesoProductoMaquinariaSelectList;
        }

        public void setTiposEspecificacionesProcesoProductoMaquinariaSelectList(List<SelectItem> tiposEspecificacionesProcesoProductoMaquinariaSelectList) {
            this.tiposEspecificacionesProcesoProductoMaquinariaSelectList = tiposEspecificacionesProcesoProductoMaquinariaSelectList;
        }

        public List<ComponentesProdVersionLimpiezaSeccion> getComponentesProdVersionLimpiezaSeccionPesajeList() {
            return componentesProdVersionLimpiezaSeccionPesajeList;
        }

        public void setComponentesProdVersionLimpiezaSeccionPesajeList(List<ComponentesProdVersionLimpiezaSeccion> componentesProdVersionLimpiezaSeccionPesajeList) {
            this.componentesProdVersionLimpiezaSeccionPesajeList = componentesProdVersionLimpiezaSeccionPesajeList;
        }

        public ComponentesProdVersionLimpiezaSeccion getComponentesProdVersionLimpiezaPesaje() {
            return componentesProdVersionLimpiezaPesaje;
        }

        public void setComponentesProdVersionLimpiezaPesaje(ComponentesProdVersionLimpiezaSeccion componentesProdVersionLimpiezaPesaje) {
            this.componentesProdVersionLimpiezaPesaje = componentesProdVersionLimpiezaPesaje;
        }

        public List<SelectItem> getSeccionesOrdenManufacturaSelectList() {
            return seccionesOrdenManufacturaSelectList;
        }

        public void setSeccionesOrdenManufacturaSelectList(List<SelectItem> seccionesOrdenManufacturaSelectList) {
            this.seccionesOrdenManufacturaSelectList = seccionesOrdenManufacturaSelectList;
        }

        public List<ComponentesProdVersionLimpiezaMaquinaria> getComponentesProdVersionLimpiezaUtensilioPesajeList() {
            return componentesProdVersionLimpiezaUtensilioPesajeList;
        }

        public void setComponentesProdVersionLimpiezaUtensilioPesajeList(List<ComponentesProdVersionLimpiezaMaquinaria> componentesProdVersionLimpiezaUtensilioPesajeList) {
            this.componentesProdVersionLimpiezaUtensilioPesajeList = componentesProdVersionLimpiezaUtensilioPesajeList;
        }

        public List<ComponentesProdVersionLimpiezaMaquinaria> getUtensilioPesajeLimpiezaAgregarList() {
            return utensilioPesajeLimpiezaAgregarList;
        }

        public void setUtensilioPesajeLimpiezaAgregarList(List<ComponentesProdVersionLimpiezaMaquinaria> utensilioPesajeLimpiezaAgregarList) {
            this.utensilioPesajeLimpiezaAgregarList = utensilioPesajeLimpiezaAgregarList;
        }


        

        public List<ComponentesProdVersionDocumentacionAplicada> getComponentesProdVersionDocumentacionAplicadaList() {
            return componentesProdVersionDocumentacionAplicadaList;
        }

        

        public void setComponentesProdVersionDocumentacionAplicadaList(List<ComponentesProdVersionDocumentacionAplicada> componentesProdVersionDocumentacionAplicadaList) {
            this.componentesProdVersionDocumentacionAplicadaList = componentesProdVersionDocumentacionAplicadaList;
        }

        public boolean isDuplicarProcesosHabilitados() {
            return duplicarProcesosHabilitados;
        }

        public void setDuplicarProcesosHabilitados(boolean duplicarProcesosHabilitados) {
            this.duplicarProcesosHabilitados = duplicarProcesosHabilitados;
        }

        public boolean isDuplicarDatosLimpieza() {
            return duplicarDatosLimpieza;
        }

        public void setDuplicarDatosLimpieza(boolean duplicarDatosLimpieza) {
            this.duplicarDatosLimpieza = duplicarDatosLimpieza;
        }

        public boolean isDuplicarIndicacionesProceso() {
            return duplicarIndicacionesProceso;
        }

        public void setDuplicarIndicacionesProceso(boolean duplicarIndicacionesProceso) {
            this.duplicarIndicacionesProceso = duplicarIndicacionesProceso;
        }

        public boolean isDuplicarDocumentacionProceso() {
            return duplicarDocumentacionProceso;
        }

        public void setDuplicarDocumentacionProceso(boolean duplicarDocumentacionProceso) {
            this.duplicarDocumentacionProceso = duplicarDocumentacionProceso;
        }

        public boolean isDuplicarEspecificacionesMaquinaria() {
            return duplicarEspecificacionesMaquinaria;
        }

        public void setDuplicarEspecificacionesMaquinaria(boolean duplicarEspecificacionesMaquinaria) {
            this.duplicarEspecificacionesMaquinaria = duplicarEspecificacionesMaquinaria;
        }

        public boolean isDuplicarFlujoPreparado() {
            return duplicarFlujoPreparado;
        }
        

        public void setDuplicarFlujoPreparado(boolean duplicarFlujoPreparado) {
            this.duplicarFlujoPreparado = duplicarFlujoPreparado;
        }

        public TiposAsignacionDocumentoOm getTiposAsignacionDocumentoOmBean() {
            return tiposAsignacionDocumentoOmBean;
        }
        
        
        

        public ComponentesProdVersion getComponentesProdVersionFuenteInformacion() {
            return componentesProdVersionFuenteInformacion;
        }
        

        public void setComponentesProdVersionFuenteInformacion(ComponentesProdVersion componentesProdVersionFuenteInformacion) {
            this.componentesProdVersionFuenteInformacion = componentesProdVersionFuenteInformacion;
        }


        public FormulaMaestraDetalleMP getFormulaMaestraDetalleMPModificarFracciones() {
            return formulaMaestraDetalleMPModificarFracciones;
        }

        public void setFormulaMaestraDetalleMPModificarFracciones(FormulaMaestraDetalleMP formulaMaestraDetalleMPModificarFracciones) {
            this.formulaMaestraDetalleMPModificarFracciones = formulaMaestraDetalleMPModificarFracciones;
        }

        

        public ComponentesProdVersion getComponentesProdVersionDestinoInformacion() {
            return componentesProdVersionDestinoInformacion;
        }

        public List<SelectItem> getComponentesProdVersionFuenteList() {
            return componentesProdVersionFuenteList;
        }

        public void setComponentesProdVersionFuenteList(List<SelectItem> componentesProdVersionFuenteList) {
            this.componentesProdVersionFuenteList = componentesProdVersionFuenteList;
        }

        public void setComponentesProdVersionDestinoInformacion(ComponentesProdVersion componentesProdVersionDestinoInformacion) {
            this.componentesProdVersionDestinoInformacion = componentesProdVersionDestinoInformacion;
        }

        public ComponentesProd getComponentesProdActivarInactivar() {
            return componentesProdActivarInactivar;
        }

        public void setComponentesProdActivarInactivar(ComponentesProd componentesProdActivarInactivar) {
            this.componentesProdActivarInactivar = componentesProdActivarInactivar;
        }


        public List<SelectItem> getProcesosOrdenManufaturaSelectList() {
            return procesosOrdenManufaturaSelectList;
        }

        public void setProcesosOrdenManufaturaSelectList(List<SelectItem> procesosOrdenManufaturaSelectList) {
            this.procesosOrdenManufaturaSelectList = procesosOrdenManufaturaSelectList;
        }

        public void setTiposAsignacionDocumentoOmBean(TiposAsignacionDocumentoOm tiposAsignacionDocumentoOmBean) {
            this.tiposAsignacionDocumentoOmBean = tiposAsignacionDocumentoOmBean;
        }

        public List<TiposAsignacionDocumentoOm> getTiposAsignacionDocumentoOmList() {
            return tiposAsignacionDocumentoOmList;
        }

        public void setTiposAsignacionDocumentoOmList(List<TiposAsignacionDocumentoOm> tiposAsignacionDocumentoOmList) {
            this.tiposAsignacionDocumentoOmList = tiposAsignacionDocumentoOmList;
        }

        public HtmlDataTable getTiposAsignacionDocumentoOmDataTable() {
            return tiposAsignacionDocumentoOmDataTable;
        }

        public void setTiposAsignacionDocumentoOmDataTable(HtmlDataTable tiposAsignacionDocumentoOmDataTable) {
            this.tiposAsignacionDocumentoOmDataTable = tiposAsignacionDocumentoOmDataTable;
        }

        public List<SelectItem> getPersonalSelectList() {
            return personalSelectList;
        }

        public void setPersonalSelectList(List<SelectItem> personalSelectList) {
            this.personalSelectList = personalSelectList;
        }


        public boolean isPermisoEnviarProductoEstandarizacion() {
            return permisoEnviarProductoEstandarizacion;
        }

        public void setPermisoEnviarProductoEstandarizacion(boolean permisoEnviarProductoEstandarizacion) {
            this.permisoEnviarProductoEstandarizacion = permisoEnviarProductoEstandarizacion;
        }


        public int getTamanioLoteEditar() {
            return tamanioLoteEditar;
        }

        public void setTamanioLoteEditar(int tamanioLoteEditar) {
            this.tamanioLoteEditar = tamanioLoteEditar;
        }

        
        

        public Materiales getMateriales() {
            return materiales;
        }

        public boolean isPermisoCreacionVersion() {
            return permisoCreacionVersion;
        }

        public void setPermisoCreacionVersion(boolean permisoCreacionVersion) {
            this.permisoCreacionVersion = permisoCreacionVersion;
        }



        public int getCodPersonalAsignadoEstandarizacion() {
            return codPersonalAsignadoEstandarizacion;
        }

        public List<ComponentesProdVersionModificacion> getComponentesProdVersionModificacionList() {
            return componentesProdVersionModificacionList;
        }

        public void setComponentesProdVersionModificacionList(List<ComponentesProdVersionModificacion> componentesProdVersionModificacionList) {
            this.componentesProdVersionModificacionList = componentesProdVersionModificacionList;
        }

        public List<ComponentesProdVersionModificacion> getComponentesProdVersionModificacionAgregarList() {
            return componentesProdVersionModificacionAgregarList;
        }

        public void setComponentesProdVersionModificacionAgregarList(List<ComponentesProdVersionModificacion> componentesProdVersionModificacionAgregarList) {
            this.componentesProdVersionModificacionAgregarList = componentesProdVersionModificacionAgregarList;
        }

        public void setCodPersonalAsignadoEstandarizacion(int codPersonalAsignadoEstandarizacion) {
            this.codPersonalAsignadoEstandarizacion = codPersonalAsignadoEstandarizacion;
        }

        public void setMateriales(Materiales materiales) {
            this.materiales = materiales;
        }
        
        


        public List<ComponentesProdVersionDocumentacionAplicada> getComponentesProdVersionDocumentacionAplicadaAgregarList() {
            return componentesProdVersionDocumentacionAplicadaAgregarList;
        }

        public void setComponentesProdVersionDocumentacionAplicadaAgregarList(List<ComponentesProdVersionDocumentacionAplicada> componentesProdVersionDocumentacionAplicadaAgregarList) {
            this.componentesProdVersionDocumentacionAplicadaAgregarList = componentesProdVersionDocumentacionAplicadaAgregarList;
        }

        public ComponentesProdVersionMaquinariaProceso getComponentesProdVersionMaquinariaProcesoEditar() {
            return componentesProdVersionMaquinariaProcesoEditar;
        }

        public void setComponentesProdVersionMaquinariaProcesoEditar(ComponentesProdVersionMaquinariaProceso componentesProdVersionMaquinariaProcesoEditar) {
            this.componentesProdVersionMaquinariaProcesoEditar = componentesProdVersionMaquinariaProcesoEditar;
        }

    
    
    //</editor-fold>

    

    
    
    
}
