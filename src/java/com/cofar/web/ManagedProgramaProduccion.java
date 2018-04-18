/*
 * ManagedTipoCliente.java
 * Created on 19 de febrero de 2008, 16:50
 */

package com.cofar.web;


import com.cofar.bean.ComponentesProd;
import com.cofar.bean.FormulaMaestra;
import com.cofar.bean.FormulaMaestraDetalleMP;
import com.cofar.bean.FormulaMaestraEsVersion;
import com.cofar.bean.FormulaMaestraVersion;
import com.cofar.bean.IngresosAcond;
import com.cofar.bean.IngresosDetalleAcond;
import com.cofar.bean.IngresosAlmacenDetalleEstado;
import com.cofar.bean.IngresosdetalleCantidadPeso;
import com.cofar.bean.Materiales;
import com.cofar.bean.ProductosDivisionLotes;
import com.cofar.bean.ProgramaProduccion;
import com.cofar.bean.ProgramaProduccionDetalle;
import com.cofar.bean.ProgramaProduccionDetalleFracciones;
import com.cofar.bean.ProgramaProduccionDevolucionMaterial;
import com.cofar.bean.ProgramaProduccionDevolucionMaterialDetalle;
import com.cofar.bean.ProgramaProduccionImpresionOm;
import com.cofar.bean.ProgramaProduccionIngresoAcond;
import com.cofar.bean.ProgramaProduccionPeriodo;
import com.cofar.bean.SeguimientoProgramaProduccion;
import com.cofar.bean.SeguimientoProgramaProduccionIndirecto;
import com.cofar.bean.SeguimientoProgramaProduccionIndirectoPersonal;
import com.cofar.bean.util.CreacionGraficosOrdenManufactura;
import com.cofar.bean.util.correos.EnvioCorreoAcondicionamientoSinFechasDePesaje;
import com.cofar.bean.util.correos.EnvioCorreoDesviacionBajoRendimiento;
import com.cofar.dao.DaoAlmacenesAcond;
import com.cofar.dao.DaoIngresosAcond;
import com.cofar.dao.DaoTiposEnvase;
import com.cofar.util.Util;
import java.io.IOException;
import java.net.MalformedURLException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import javax.faces.model.SelectItem;
import java.text.NumberFormat;
import java.util.Map;
import javax.faces.context.ExternalContext;
import javax.faces.context.FacesContext;
import javax.servlet.ServletContext;
import org.apache.logging.log4j.LogManager;
import org.joda.time.DateTime;
import org.richfaces.component.html.HtmlDataTable;

/**
 *  @author Alejandro Quispe
 *  @company COFAR
 */
public class ManagedProgramaProduccion  extends ManagedBean{

    private static final int COD_ESTADO_PROGRAMA_TERMINADO = 6;
    public static final int COD_TIPO_VERSION_NORMAL = 1; 
    public static final int COD_TIPO_PRODUCCION_CONSTITUIDO = 1; 
    private static final int COD_ESTADO_IMPRESION_ANULADO_POR_EDICION = 4;
    private static final int COD_ESTADO_INGRESO_ACOND_ANULADO = 2;
    private List<FormulaMaestraEsVersion> formulaMaestraEsVersionList;
    private String mensaje="";
    private Connection con=null;
    private int codTipoProduccion = 0;
    private List<SelectItem> tiposProduccionSelectList;
    private List<ProgramaProduccionPeriodo> programaProduccionPeriodoList=new ArrayList<>();
    private HtmlDataTable programaProduccionPeriodoDataTable=new HtmlDataTable();
    
    private ProgramaProduccionPeriodo programaProduccionPeriodoAgregar=null;
    private ProgramaProduccionPeriodo programaProduccionPeriodoEditar=null;
    private ProgramaProduccionPeriodo programaProduccionPeriodoBean=null;
    private List<ProgramaProduccion> programaProduccionList=new ArrayList<>();
    private List<FormulaMaestraVersion> formulaMaestraVersionAgregarList=new ArrayList<>();
    private ProgramaProduccion programaProduccionCabecera=null;
    private List<ProgramaProduccion> programaProduccionAgregarList=null;
    private List<SelectItem> tiposProgramaProduccionSelectList=new ArrayList<>();
    private ProgramaProduccion programaProduccionCambioProducto=null;
    private List<ProductosDivisionLotes> productosDivisionLotesList=new ArrayList<>();
    private HtmlDataTable formulaMaestraVersionAgregarDataTable=new HtmlDataTable();
    private List<ProgramaProduccion> programaProduccionEditarList=null;
    private ProgramaProduccion programaProduccionCabeceraEditar=null;
    private ProgramaProduccion programaProduccionCambiarFormulaEs;
    //para buscar un lote
    private ProgramaProduccion programaProduccionFiltro=new ProgramaProduccion();
    //para asignar nuevo lote en edicion de lotes
    private String codLoteProducionEditar="";
    //para registrar ingreso acondicionamiento
    private List<IngresosAcond> ingresosDetalleAcondRegistradosList=null;
    private IngresosAcond ingresosAcond;
    private List<SelectItem> tiposEnvaseSelectList=new ArrayList<>();
    private List<SelectItem> cantidadEnvaseSelectList=new ArrayList<>();
    private ProgramaProduccion programaProduccionIngresoAcond=null;
    private boolean entregaTotal=false;
    //para etiquetas
    private List<SelectItem> clienteSelectList=new ArrayList<>();
    private IngresosDetalleAcond ingresosAcondicionamientoEtiqueta=null;
    private List<SelectItem> presentacionesSecundariasSelectList=new ArrayList<>();
    //variable apertura de lotes de produccion
    private ProgramaProduccion programaProduccionApertura;
    //para explosion de empaque secundarion
    private int codExplosionEmpaqueSecundarioAlmacen=0;
    //etiquetas de pesaje
    // <editor-fold defaultstate="collapsed" desc="variables de permiso">
        // <editor-fold defaultstate="collapsed" desc="permisos registro de tiempos">
        private boolean permisoTiemposProduccion=false;
        private boolean permisoTiemposMicrobiologia=false;
        private boolean permisoTiemposCC=false;
        private boolean permisotiemposAcond=false;
        private boolean permisoTiempoSoporteManufactura=false;
        //</editor-fold>
    
        private boolean permisoImpresionOm=false;
        private boolean permisoGeneracionDesviacion=false;
        private boolean permisoGeneracionLotes=false;
        private boolean permisoImpresionEtiquetasMP=false;
        //variable que habilita colocar fecha a las etiquetas
        private boolean permisoImpresionEtiquetasMpFecha=false;
        //VARIABLE QUE HABILITA EL ENVIO DE PRODUCTO A ACONDICIONAMIENTO
        private boolean permisoTerminarProducto=false;
        //VARIABLE APERTURA LOTE PRODUCCION
        private boolean permisoAperturaLoteProduccion=false;
        private boolean permisoCancelacionLoteProduccion=false;
        private boolean permisoEditarLoteProducccion = false;
        private boolean permisoEditarEnvioAcondicionamiento = false;
        private boolean permisoAnularEnvioAcondicionamiento = false;
    //</editor-fold>
    private Date fechaEtiquetasPesaje=null;
    // <editor-fold defaultstate="collapsed" desc="variables impresion om">
    private ProgramaProduccion programaProduccionImpresionOm;
    private List<ProgramaProduccionImpresionOm> programaProduccionImpresionOmList;
    //</editor-fold>
    
    // <editor-fold defaultstate="collapsed" desc="funciones para impresion de om">
    public String seleccionarProgramaProduccionImpresionOm()
    {
        programaProduccionImpresionOm=(ProgramaProduccion)programaProduccionDataTable.getRowData();
        this.cargarProgramaProduccionImpresionOmList();
        return null;
    }
    private void cargarProgramaProduccionImpresionOmList()
    {
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select ppim.COD_PROGRAMA_PRODUCCION_IMPRESION_OM,ppim.COD_ESTADO_PROGRAMA_PRODUCCION_IMPRESION_OM,");
                                            consulta.append(" eppim.NOMBRE_ESTADO_PROGRAMA_PRODUCCION_IMPRESION_OM,ppim.FECHA_EMISION,ppim.FECHA_ENTREGA");
                                        consulta.append(" from PROGRAMA_PRODUCCION_IMPRESION_OM ppim");
                                            consulta.append(" inner join ESTADOS_PROGRAMA_PRODUCCION_IMPRESION_OM eppim on ppim.COD_ESTADO_PROGRAMA_PRODUCCION_IMPRESION_OM=eppim.COD_ESTADO_PROGRAMA_PRODUCCION_IMPRESION_OM");
                                        consulta.append(" where ppim.COD_LOTE_PRODUCCION='").append(programaProduccionImpresionOm.getCodLoteProduccion()).append("'");
                                            consulta.append(" and ppim.COD_PROGRAMA_PROD=").append(programaProduccionImpresionOm.getCodProgramaProduccion());
                                        consulta.append(" order by ppim.FECHA_EMISION");
            LOGGER.debug("consulta cargar impresiones realizadas "+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            programaProduccionImpresionOmList=new ArrayList<>();
            while (res.next()) 
            {
                ProgramaProduccionImpresionOm nuevo=new ProgramaProduccionImpresionOm();
                nuevo.setCodProgramaProduccionImpresionOm(res.getInt("COD_PROGRAMA_PRODUCCION_IMPRESION_OM"));
                nuevo.getEstadosProgramaProduccionImpresionOm().setCodEstadoProgramaProduccionImpresionOm(res.getInt("COD_ESTADO_PROGRAMA_PRODUCCION_IMPRESION_OM"));
                nuevo.getEstadosProgramaProduccionImpresionOm().setNombreEstadoProgramaProduccionImpresionOm(res.getString("NOMBRE_ESTADO_PROGRAMA_PRODUCCION_IMPRESION_OM"));
                nuevo.setFechaEmision(res.getTimestamp("FECHA_EMISION"));
                nuevo.setFechaEntrega(res.getTimestamp("FECHA_ENTREGA"));
                programaProduccionImpresionOmList.add(nuevo);
            }
            st.close();
        } catch (SQLException ex) {
            LOGGER.warn("error", ex);
        } catch(Exception ex){
            LOGGER.warn("error", ex);
        } finally {
            this.cerrarConexion(con);
        }
    }
    public String entregarProgramaProduccionImpresionOmAction(int codProgramaProduccionImpresionOm)throws SQLException
    {
        mensaje = "";
        try {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm");
            StringBuilder consulta = new StringBuilder("UPDATE PROGRAMA_PRODUCCION_IMPRESION_OM");
                                    consulta.append(" set COD_ESTADO_PROGRAMA_PRODUCCION_IMPRESION_OM=1");
                                    consulta.append(" ,FECHA_ENTREGA='").append(sdf.format(new Date())).append("'");
                                    consulta.append(" where COD_PROGRAMA_PRODUCCION_IMPRESION_OM=").append(codProgramaProduccionImpresionOm);
            LOGGER.debug("consulta registrar entrega de om " + consulta.toString());
            PreparedStatement pst = con.prepareStatement(consulta.toString(), PreparedStatement.RETURN_GENERATED_KEYS);
            if (pst.executeUpdate() > 0) LOGGER.info("Se registro la entrega de la Orden de Manufactura");
            con.commit();
            mensaje = "1";
            pst.close();
        } 
        catch (SQLException ex) 
        {
            mensaje = "Ocurrio un error al momento de registrar la entrega de Orden de Manufactura";
            con.rollback();
            LOGGER.warn(ex.getMessage());
        } 
        catch (Exception ex) 
        {
            mensaje = "Ocurrio un error al momento de registrar la entrega de Orden de Manufactura";
            con.rollback();
            LOGGER.warn(ex.getMessage());
        }
        finally 
        {
            this.cerrarConexion(con);
        }
        if(mensaje.equals("1"))
        {
            this.cargarProgramaProduccionList();
        }
        return null;
    }
    public String generarNuevoProgramaProduccionImpresionOm()throws SQLException
    {
        mensaje = "";
        try 
        {
            con = Util.openConnection(con);
            
            SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm");
            StringBuilder consulta = new StringBuilder("select count(*) as cantidadImpresionesOmGeneradas");
                                        consulta.append(" from PROGRAMA_PRODUCCION_IMPRESION_OM p ");
                                        consulta.append(" where p.COD_LOTE_PRODUCCION='").append(programaProduccionImpresionOm.getCodLoteProduccion()).append("'");
                                                consulta.append(" and p.COD_PROGRAMA_PROD=").append(programaProduccionImpresionOm.getCodProgramaProduccion());
                                                consulta.append(" and p.COD_ESTADO_PROGRAMA_PRODUCCION_IMPRESION_OM=3");
            LOGGER.debug("consulta verificar impresiones generadas "+consulta.toString());
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta.toString());
            res.next();
            if(res.getInt("cantidadImpresionesOmGeneradas")>0)
            {
                mensaje="No se puede generar una nueva impresion porque ya existe otra en estado generado";
            }
            else
            {
                consulta=new StringBuilder("INSERT INTO PROGRAMA_PRODUCCION_IMPRESION_OM(COD_LOTE_PRODUCCION,COD_PROGRAMA_PROD, FECHA_EMISION,COD_ESTADO_PROGRAMA_PRODUCCION_IMPRESION_OM)");
                           consulta.append(" VALUES (?,?,?,3)");
                LOGGER.debug("consulta registrar nueva impresion" + consulta.toString());
                con.setAutoCommit(false);
                PreparedStatement pst = con.prepareStatement(consulta.toString(), PreparedStatement.RETURN_GENERATED_KEYS);
                pst.setString(1,programaProduccionImpresionOm.getCodLoteProduccion());
                pst.setString(2,programaProduccionImpresionOm.getCodProgramaProduccion());
                pst.setString(3,sdf.format(new Date()));
                if(pst.executeUpdate() > 0)LOGGER.info("Se registro la impresion");
                (new CreacionGraficosOrdenManufactura()).crearFlujogramaOrdenManufacturaProduccion(con, LOGGER, programaProduccionImpresionOm.getCodLoteProduccion(),Integer.valueOf(programaProduccionImpresionOm.getCodProgramaProduccion()), 10);
                con.commit();
                mensaje = "1";
                pst.close();
            }
        }
        catch (SQLException ex) 
        {
            mensaje = "Ocurrio un error al momento de guardar la transaccion";
            con.rollback();
            LOGGER.warn(ex.getMessage());
        }
        catch (NumberFormatException | IOException ex) 
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
            this.cargarProgramaProduccionImpresionOmList();
            this.cargarProgramaProduccionList();
        }
        return null;
    }
//</editor-fold>
    
    public String seleccionarProgramaProduccionDesviacion_action()
    {
        ProgramaProduccion bean=(ProgramaProduccion)programaProduccionDataTable.getRowData();
        FacesContext facesContext = FacesContext.getCurrentInstance();
        ExternalContext externalContext = facesContext.getExternalContext();
        Map map = externalContext.getSessionMap();
        map.put("programaProduccionDesviacion",bean);
        return null;
    }
    
    private void cargarTiposProduccionSelectList()
    {
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select tp.COD_TIPO_PRODUCCION,tp.NOMBRE_TIPO_PRODUCCION")
                                            .append(" from TIPOS_PRODUCCION tp ")
                                            .append(" where tp.COD_TIPO_PRODUCCION  in (1,3)")
                                            .append(" order by tp.COD_TIPO_PRODUCCION");
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta.toString());
            tiposProduccionSelectList = new ArrayList<>();
            while(res.next()){
                tiposProduccionSelectList.add(new SelectItem(res.getInt("COD_TIPO_PRODUCCION"),res.getString("NOMBRE_TIPO_PRODUCCION")));
            }
          
            mensaje = "1";
        } catch (SQLException ex) {
            LOGGER.warn(ex.getMessage());
        } catch (NumberFormatException ex) {
            LOGGER.warn(ex.getMessage());
        } finally {
            this.cerrarConexion(con);
        }
    }
    
    private void cargarPermisosPersonal_action()
    {
        try 
        {
            ManagedAccesoSistema managed=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select cpe.COD_TIPO_PERMISO_ESPECIAL_ATLAS");
                                        consulta.append(" from CONFIGURACION_PERMISOS_ESPECIALES_ATLAS cpe");
                                        consulta.append(" where cpe.COD_PERSONAL=").append(managed.getUsuarioModuloBean().getCodUsuarioGlobal());
            LOGGER.debug("consulta cargar permisos "+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            permisoImpresionOm=false;
            permisoGeneracionDesviacion=false;
            permisoGeneracionLotes=false;
            permisoImpresionEtiquetasMP=false;
            permisoImpresionEtiquetasMpFecha=false;
            permisoTiemposCC=false;
            permisoTiemposMicrobiologia=false;
            permisoTiemposProduccion=false;
            permisotiemposAcond=false;
            permisoTerminarProducto=false;
            permisoTiempoSoporteManufactura=false;
            permisoAperturaLoteProduccion=false;
            permisoCancelacionLoteProduccion=false;
            permisoEditarLoteProducccion = false;
            permisoEditarEnvioAcondicionamiento = false;
            permisoAnularEnvioAcondicionamiento = false;
            while (res.next()) 
            {
                switch(res.getInt("COD_TIPO_PERMISO_ESPECIAL_ATLAS"))
                {
                    case 1:
                    {
                        permisoImpresionOm=true;
                        break;
                    }
                    case 2:
                    {
                        permisoGeneracionDesviacion=true;
                        break;
                    }
                    case 3:
                    {
                        permisoGeneracionLotes=true;
                        break;
                    }
                    case 4:
                    {
                        permisoImpresionEtiquetasMP=true;
                        break;
                    }
                    case 5:
                    {
                        permisoImpresionEtiquetasMpFecha=true;
                        break;
                    }
                    case 6:
                    {
                        permisoTiemposProduccion=true;
                        break;
                    }
                    case 7:
                    {
                        permisoTiemposMicrobiologia=true;
                        break;
                    }
                    case 8:
                    {
                        permisoTiemposCC=true;
                        break;
                    }
                    case 9:
                    {
                        permisotiemposAcond=true;
                        break;
                    }
                    case 13:
                    {
                        permisoTerminarProducto=true;
                        break;
                    }
                    case 14:
                    {
                        permisoTiempoSoporteManufactura=true;
                        break;
                    }
                    case 16:
                    {
                        permisoAperturaLoteProduccion=true;
                        break;
                    }
                    case 17:
                    {
                        permisoCancelacionLoteProduccion=true;
                        break;
                    }
                    case 28:
                    {
                        permisoEditarLoteProducccion = true;
                        break;
                    }
                    case 29:{
                        permisoEditarEnvioAcondicionamiento = true;
                        break;
                    }
                    case 31:{
                        permisoAnularEnvioAcondicionamiento = true;
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
    
    public String seleccionarFormulaMaestraEsVersion()
    {
        programaProduccionCambiarFormulaEs.setPresentacionesProductoList(cargarPresentacionesSecundariasVersionSelectList(programaProduccionCambiarFormulaEs));
        return null;
    }
    public String seleccionarCambiarFormulaMaestraEsVersion()
    {
        formulaMaestraEsVersionList = this.listarFormulaMaestraEsVersion(programaProduccionCambiarFormulaEs.getFormulaMaestraVersion().getComponentesProd());
        return null;
    }
    
    private List<FormulaMaestraEsVersion> listarFormulaMaestraEsVersion(ComponentesProd componentesProd)
    {
        List<FormulaMaestraEsVersion> formulaMaestraEsList = new ArrayList<>();
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select cpv.NRO_VERSION as nroVersionCp,fmev.NRO_VERSION as nroVersionEs,fmev.COD_FORMULA_MAESTRA_ES_VERSION")
                                                        .append(" ,fmev.FECHA_CREACION,fmev.FECHA_APROBACION,fmev.OBSERVACION")
                                                .append(" from formula_maestra_es_version fmev	")
                                                        .append(" inner join componentes_prod_Version cpv on cpv.COD_VERSION = fmev.COD_VERSION")
                                                .append(" where cpv.COD_COMPPROD = ").append(componentesProd.getCodCompprod())
                                                        .append(" and cpv.COD_TIPO_COMPONENTES_PROD_VERSION= ").append(COD_TIPO_VERSION_NORMAL)
                                                .append(" order by cpv.NRO_VERSION,fmev.NRO_VERSION");
            LOGGER.debug("consulta cargar versiones es "+consulta.toString());
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta.toString());
            while(res.next())
            {
                FormulaMaestraEsVersion formulaEs = new FormulaMaestraEsVersion();
                formulaEs.getComponentesProdVersion().setNroVersion(res.getInt("nroVersionCp"));
                formulaEs.setNroVersion(res.getInt("nroVersionEs"));
                formulaEs.setCodFormulaMaestraEsVersion(res.getInt("COD_FORMULA_MAESTRA_ES_VERSION"));
                formulaEs.setObservacion(res.getString("OBSERVACION"));
                formulaEs.setFechaCreacion(res.getTimestamp("FECHA_CREACION"));
                formulaEs.setFechaAprobacion(res.getTimestamp("FECHA_APROBACION"));
                formulaMaestraEsList.add(formulaEs);
            }
        } catch (SQLException ex) {
            LOGGER.warn(ex.getMessage());
        } catch (NumberFormatException ex) {
            LOGGER.warn(ex.getMessage());
        } finally {
            this.cerrarConexion(con);
        }
        return formulaMaestraEsList;
    }
    
    //action buscar lote
    public String buscarLoteProgramaProduccion_action()throws SQLException
    {
        programaProduccionPeriodoBean=null;
        return null;
    }
    //para eliminar el lote
    public String cancelarProgramaProduccion_action()throws SQLException
    {
        transaccionExitosa = false;
        boolean loteHabilitadoCancelacion = false;
        
        if(verificarTransaccionLote(programaProduccionCabeceraEditar.getCodLoteProduccion()))
        {
            loteHabilitadoCancelacion = false;
            this.mostrarMensajeTransaccionFallida("No se puede cancelar el lote ya que tiene registrado salidas de almacen o tiempos de producción");
            //<editor-fold desc="verificando devolucion total" defaultstate="collapsed">
                if(!loteHabilitadoCancelacion){
                    try
                    {
                        Connection con=null;
                        con=Util.openConnection(con);
                        StringBuilder consulta=new StringBuilder("SELECT count(*)as cantidadPendientes");
                                                consulta.append(" from (");
                                                        consulta.append(" select sum(sad.CANTIDAD_SALIDA_ALMACEN) as cantidaSalida,sad.COD_MATERIAL");
                                                        consulta.append(" from SALIDAS_ALMACEN sa");
                                                                consulta.append(" inner join SALIDAS_ALMACEN_DETALLE sad on sad.COD_SALIDA_ALMACEN =sa.COD_SALIDA_ALMACEN");
                                                        consulta.append(" where sa.COD_LOTE_PRODUCCION='").append(programaProduccionCabeceraEditar.getCodLoteProduccion()).append("'");
                                                                consulta.append(" and sa.COD_ESTADO_SALIDA_ALMACEN = 1");
                                                                consulta.append(" and sa.ESTADO_SISTEMA = 1");
                                                        consulta.append(" group by sad.COD_MATERIAL");
                                                consulta.append("  ) as salidasMaterial");
                                                consulta.append("  LEFT join(");
                                                        consulta.append(" select dde.COD_MATERIAL,SUM(dde.CANTIDAD_DEVUELTA) as cantidadDevuelta");
                                                        consulta.append(" from DEVOLUCIONES d ");
                                                                consulta.append(" inner join SALIDAS_ALMACEN sa2 on sa2.COD_SALIDA_ALMACEN=d.COD_SALIDA_ALMACEN");
                                                                consulta.append(" inner join DEVOLUCIONES_DETALLE_ETIQUETAS dde on dde.COD_DEVOLUCION=d.COD_DEVOLUCION");
                                                        consulta.append(" where d.ESTADO_SISTEMA=1");
                                                                consulta.append(" and d.COD_ESTADO_DEVOLUCION=1");
                                                                consulta.append(" and sa2.COD_ESTADO_SALIDA_ALMACEN=1");
                                                                consulta.append(" and sa2.ESTADO_SISTEMA=1");
                                                                consulta.append(" and sa2.COD_LOTE_PRODUCCION='").append(programaProduccionCabeceraEditar.getCodLoteProduccion()).append("'");
                                                        consulta.append(" group by sa2.COD_LOTE_PRODUCCION,dde.COD_MATERIAL");
                                                consulta.append(" ) as devolucionMaterial on salidasMaterial.COD_MATERIAL=devolucionMaterial.COD_MATERIAL");
                                                consulta.append(" WHERE salidasMaterial.cantidaSalida - isnull(devolucionMaterial.cantidadDevuelta,0)>0.01");
                        LOGGER.debug("consulta verificar devoluciones "+consulta.toString());
                        Statement st= con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                        ResultSet res = st.executeQuery(consulta.toString());
                        res.next();
                        if(res.getInt("cantidadPendientes") > 0)
                        {
                            loteHabilitadoCancelacion = false;
                            this.mostrarMensajeTransaccionFallida("No se puede cancelar el lote porque cuenta con salidas de produccion");
                        }
                        else
                        {
                            loteHabilitadoCancelacion = true;
                        }
                        con.close();
                    }
                    catch(SQLException ex)
                    {
                        mensaje="Ocurrio un error al momento de cancelar el lote, intente de nuevo";
                        LOGGER.warn("error", ex);
                    }
                //</editor-fold>
            }
        }
        else{
            loteHabilitadoCancelacion = true;
        }
        
        
        
        if(loteHabilitadoCancelacion)
        {
            try {
                con = Util.openConnection(con);
                con.setAutoCommit(false);
                PreparedStatement pst=null;
                StringBuilder consulta=new StringBuilder("select cod_reserva");
                            consulta.append(" from reserva");
                            consulta.append(" where COD_PROGRAMA_PROD in (").append(programaProduccionCabeceraEditar.getCodProgramaProduccion()).append(")");
                                    consulta.append(" and COD_LOTE='").append(programaProduccionCabeceraEditar.getCodLoteProduccion()).append("' ");
                LOGGER.debug(" consulta verificar reserva "+consulta.toString());
                Statement st= con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                while(res.next())
                {
                    consulta=new StringBuilder(" delete from reserva ");
                            consulta.append(" where cod_reserva=").append(res.getInt("cod_reserva"));
                    LOGGER.debug(" consulta delete reserva: "+consulta.toString());
                    pst=con.prepareStatement(consulta.toString());
                    if(pst.executeUpdate()>0)LOGGER.info("se elimino reserva");
                    consulta=new StringBuilder("delete from reserva_detalle");
                            consulta.append(" where cod_reserva=").append(res.getInt("COD_RESERVA"));
                    LOGGER.debug(" consulta delete detalle reserva: "+consulta.toString());
                    pst=con.prepareStatement(consulta.toString());
                    if(pst.executeUpdate()>0)LOGGER.info("se elimino detalle reserva");
                }
                
                if(!(programaProduccionCabeceraEditar.getFormulaMaestra().getComponentesProd().getForma().getCodForma().equals("2") 
                        || programaProduccionCabeceraEditar.getFormulaMaestra().getComponentesProd().getForma().getCodForma().equals("43")))
                {
                    consulta = new StringBuilder(" UPDATE PROGRAMA_PRODUCCION SET COD_ESTADO_PROGRAMA=9");
                                                    consulta.append(" ,FECHA_EDICION=GETDATE()");
                                                    consulta.append(" ,OBSERVACION=cast (OBSERVACION as nvarchar(max))  + cast (' cancelado por ").append(usuario.getUsuarioModuloBean().getNombrePilaUsuarioGlobal()).append(" ").append(usuario.getUsuarioModuloBean().getApPaternoUsuarioGlobal()).append("' as nvarchar(max))");
                                            consulta.append(" where COD_PROGRAMA_PROD=").append(programaProduccionCabeceraEditar.getCodProgramaProduccion());
                                                    consulta.append(" and COD_LOTE_PRODUCCION='").append(programaProduccionCabeceraEditar.getCodLoteProduccion()).append("'");
                    LOGGER.debug(" consulta cancelar programa produccion "+consulta);
                    pst=con.prepareStatement(consulta.toString());
                    if(pst.executeUpdate()>0)LOGGER.info("se elimino el programa de produccion");
                }
                else
                {
                    consulta=new StringBuilder("delete PROGRAMA_PRODUCCION");
                                consulta.append(" where COD_LOTE_PRODUCCION='").append(programaProduccionCabeceraEditar.getCodLoteProduccion()).append("'");
                                consulta.append(" and COD_PROGRAMA_PROD=").append(programaProduccionCabeceraEditar.getCodProgramaProduccion());
                    LOGGER.debug("consulta delete programa produccion "+consulta.toString());
                    pst=con.prepareStatement(consulta.toString());
                    if(pst.executeUpdate()>0)LOGGER.info("se elimino el progrma de produccion");

                    consulta=new StringBuilder("delete PROGRAMA_PRODUCCION_DETALLE");
                                consulta.append(" where COD_LOTE_PRODUCCION='").append(programaProduccionCabeceraEditar.getCodLoteProduccion()).append("'");
                                consulta.append(" and COD_PROGRAMA_PROD=").append(programaProduccionCabeceraEditar.getCodProgramaProduccion());
                    LOGGER.debug("consulta delete programa produccion DETALLE"+consulta.toString());
                    pst=con.prepareStatement(consulta.toString());
                    if(pst.executeUpdate()>0)LOGGER.info("se elimino el progrma de produccion DETALLE");
                }
                // <editor-fold defaultstate="collapsed" desc="registro de log de transacciones">

                    ManagedAccesoSistema usuarioModificacion = (ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
                    consulta=new StringBuilder("exec PAA_REGISTRO_PROGRAMA_PRODUCCION_LOG ?,?,?,1,0");
                    LOGGER.debug("consulta guardar registro transacciones "+consulta.toString());
                    pst=con.prepareStatement(consulta.toString());
                    pst.setString(1, programaProduccionCabeceraEditar.getCodLoteProduccion());LOGGER.info("p1:"+programaProduccionCabeceraEditar.getCodLoteProduccion());
                    pst.setInt(2,Integer.valueOf(programaProduccionCabeceraEditar.getCodProgramaProduccion()));LOGGER.info("p2:"+programaProduccionCabeceraEditar.getCodProgramaProduccion());
                    pst.setInt(3,Integer.valueOf(usuarioModificacion.getUsuarioModuloBean().getCodUsuarioGlobal()));LOGGER.info("p3:"+usuarioModificacion.getUsuarioModuloBean().getCodUsuarioGlobal());
                    if(pst.executeUpdate()>0)LOGGER.debug("se registro el log de edicion de lote");
                //</editor-fold>
                con.commit();
                this.mostrarMensajeTransaccionExitosa("Se cancelo satisfactoriamente el numero de lote");
                con.close();
            } 
            catch (SQLException ex)
            {
                con.rollback();
                con.close();
                this.mostrarMensajeTransaccionFallida("Ocurrio un error al momento de cancelar el lote, intente de nuevo");
                LOGGER.warn("error", ex);
            }
        }
        if(!loteHabilitadoCancelacion){
            this.mostrarMensajeTransaccionFallida("No se puede cancelar el lote ya que cuenta con registro de tiempos o salidas de almacen");
        }
        if(transaccionExitosa)
        {
            this.cargarProgramaProduccionList();
        }

        return null;
    }


    //para edicion de lotes
    //guardar edicion de lote
    public String guardarEdicionProgramaProduccion_action()throws SQLException
    {
        mensaje="";
        try 
        {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            String consulta ="";
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=null;
            PreparedStatement pst=con.prepareStatement(consulta);
            
            //verificar si cambio el nro de lote
            if(!programaProduccionCabeceraEditar.getCodLoteProduccion().equals(codLoteProducionEditar))
            {
                //verificar si el lote sugerido ya existe
                consulta="select count(*) as contLotes from PROGRAMA_PRODUCCION p where p.COD_LOTE_PRODUCCION='"+codLoteProducionEditar+"'";
                System.out.println("consulta verificar lote existente "+consulta);
                res=st.executeQuery(consulta);
                res.next();
                if(res.getInt("contLotes")>0)
                {
                    System.out.println("el numero de lote ingresado ya se encuentra asignado");
                    mensaje="el numero de lote ingresado ya se encuentra asignado";
                }

            }
            
            // <editor-fold defaultstate="collapsed" desc="verificar producto con datos basicos">
            for(ProgramaProduccion bean:programaProduccionEditarList)
            {
                consulta="select cpv.PRODUCTO_SEMITERMINADO,(select  count(*) from COMPONENTES_PROD_VERSION cpv1 where cpv1.COD_COMPPROD=cpv.COD_COMPPROD"+
                         " and cpv1.COD_ESTADO_VERSION in (1,3,5)) as cantidadVersionesEnProceso"+
                         ",cpv.APLICA_ESPECIFICACIONES_FISICAS,cpv.APLICA_ESPECIFICACIONES_QUIMICAS,cpv.APLICA_ESPECIFICACIONES_MICROBIOLOGICAS"+
                         " from COMPONENTES_PROD_VERSION cpv where cpv.COD_VERSION='"+bean.getComponentesProdVersion().getCodVersion()+"'"+
                         " and cpv.COD_COMPPROD='"+bean.getFormulaMaestraVersion().getComponentesProd().getCodCompprod()+"'";
                LOGGER.debug("consulta verificar producto semiterminado "+consulta);
                res=st.executeQuery(consulta);
                res.next();
                boolean aplicaEspecificacionesFisicas=res.getInt("APLICA_ESPECIFICACIONES_FISICAS")>0;
                boolean aplicaEspecificacionesQuimicas=res.getInt("APLICA_ESPECIFICACIONES_QUIMICAS")>0;
                boolean aplicaEspecificacionesMicrobiologicas=res.getInt("APLICA_ESPECIFICACIONES_MICROBIOLOGICAS")>0;
                        //verificamos si no es un producto semiterminado para validar algunos aspectos del producto
                        if(res.getInt("PRODUCTO_SEMITERMINADO")==0)
                        {
                            //<editor-fold desc="verificamos que tenga especificacion quimicas de CC">
                                if(aplicaEspecificacionesQuimicas)
                                {
                                    consulta="select count(*) as contador from ESPECIFICACIONES_QUIMICAS_PRODUCTO e where e.COD_VERSION='"+bean.getComponentesProdVersion().getCodVersion()+"'";
                                    LOGGER.debug("consulta verificar esp quim"+consulta);
                                    res=st.executeQuery(consulta);
                                    res.next();
                                    if(res.getInt("contador")==0)mensaje="No se puede crear el lote del producto "+bean.getFormulaMaestraVersion().getComponentesProd().getNombreProdSemiterminado()+" porque no cuenta con especificaciones Quimicas";
                                }
                            //</editor-fold>
                            //verificamos que tenga registrada la concentracion
                            consulta="select count(*) as contador from COMPONENTES_PROD_CONCENTRACION e where e.COD_VERSION='"+bean.getComponentesProdVersion().getCodVersion()+"'";
                            LOGGER.debug("consulta verificar concentracion"+consulta);
                            res=st.executeQuery(consulta);
                            res.next();
                            if(res.getInt("contador")==0)mensaje="No se puede crear el lote del producto "+bean.getFormulaMaestraVersion().getComponentesProd().getNombreProdSemiterminado()+" porque no cuenta con concentración registrada";
                            //verificamos que tenga ep
                            consulta="select count(*) as contador from FORMULA_MAESTRA_DETALLE_EP_VERSION f inner join PRESENTACIONES_PRIMARIAS pp on pp.COD_PRESENTACION_PRIMARIA=f.COD_PRESENTACION_PRIMARIA" +
                                     " and pp.COD_TIPO_PROGRAMA_PROD='"+bean.getTiposProgramaProduccion().getCodTipoProgramaProd()+"' where f.COD_VERSION='"+bean.getFormulaMaestraVersion().getCodVersion()+"'";
                            LOGGER.debug("consulta verificar ep "+consulta);
                            res=st.executeQuery(consulta);
                            res.next();
                            if(res.getInt("contador")==0)mensaje="No se puede crear el lote del producto "+bean.getFormulaMaestraVersion().getComponentesProd().getNombreProdSemiterminado()+" porque no cuenta con empaque primario";
                            //verificamos que tenga es
                            consulta="select count(*) as contador from FORMULA_MAESTRA_DETALLE_ES_VERSION f where f.COD_TIPO_PROGRAMA_PROD='"+bean.getTiposProgramaProduccion().getCodTipoProgramaProd()+"'"
                                    + " and f.COD_PRESENTACION_PRODUCTO='"+bean.getPresentacionesProducto().getCodPresentacion()+"' and  f.COD_FORMULA_MAESTRA_ES_VERSION='"+bean.getFormulaMaestraEsVersion().getCodFormulaMaestraEsVersion()+"'";
                            LOGGER.debug("consulta verificar es "+consulta);
                            res=st.executeQuery(consulta);
                            res.next();
                            if(res.getInt("contador")==0)mensaje="No se puede crear el lote del producto "+bean.getFormulaMaestraVersion().getComponentesProd().getNombreProdSemiterminado()+" porque no cuenta con empaque secundario";
                        }
                        //<editor-fold desc="verificamos que tenga especificacion fisicas del producto">
                            if(aplicaEspecificacionesFisicas)
                            {
                                consulta="select count(*) as contador from ESPECIFICACIONES_FISICAS_PRODUCTO e where e.COD_VERSION='"+bean.getComponentesProdVersion().getCodVersion()+"'";
                                LOGGER.debug("consulta verificar esp fis"+consulta);
                                res=st.executeQuery(consulta);
                                res.next();
                                if(res.getInt("contador")==0)mensaje="No se puede crear el lote del producto "+bean.getFormulaMaestraVersion().getComponentesProd().getNombreProdSemiterminado()+" porque no cuenta con especificaciones fisicas";
                            }
                        //</editor-fold>
                        //<editor-fold desc="verificamos que tenga especificacion microbiologicas">
                            if(aplicaEspecificacionesMicrobiologicas)
                            {
                                consulta="select count(*) as contador from ESPECIFICACIONES_MICROBIOLOGIA_PRODUCTO e where e.COD_VERSION='"+bean.getComponentesProdVersion().getCodVersion()+"'";
                                LOGGER.debug("consulta verificar esp micro"+consulta);
                                res=st.executeQuery(consulta);
                                res.next();
                                if(res.getInt("contador")==0)mensaje="No se puede crear el lote del producto "+bean.getFormulaMaestraVersion().getComponentesProd().getNombreProdSemiterminado()+" porque no cuenta con especificaciones microbiológicas";
                            }
                        //</editor-fold>
                        //verificamos que tenga materia prima
                        consulta="select count(*) as contador from FORMULA_MAESTRA_DETALLE_MP_VERSION f where f.COD_VERSION='"+bean.getFormulaMaestraVersion().getCodVersion()+"'";
                        LOGGER.debug("consulta verificar materia prima"+consulta);
                        res=st.executeQuery(consulta);
                        res.next();
                        if(res.getInt("contador")==0)mensaje="No se puede crear el lote del producto "+bean.getFormulaMaestraVersion().getComponentesProd().getNombreProdSemiterminado()+" porque no cuenta con materia prima en su formula maestra";
                        //verificamos que tenga material reactivo
                        consulta="select count(*) as contador from FORMULA_MAESTRA_DETALLE_MR_VERSION f where f.COD_VERSION='"+bean.getFormulaMaestraVersion().getCodVersion()+"'";
                        LOGGER.debug("consulta verificar material reactivo"+consulta);
                        res=st.executeQuery(consulta);
                        res.next();
                        if(res.getInt("contador")==0)mensaje="No se puede crear el lote del producto "+bean.getFormulaMaestraVersion().getComponentesProd().getNombreProdSemiterminado()+" porque no cuenta con material reactivo en su formula maestra";
                
                
                
            }
            //</editor-fold>
            
            if(mensaje.equals(""))
            {
                
                 SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm");
                
                 consulta="delete from PROGRAMA_PRODUCCION" +
                          " where COD_LOTE_PRODUCCION='"+programaProduccionCabeceraEditar.getCodLoteProduccion()+"'" +
                          " and COD_PROGRAMA_PROD='"+programaProduccionCabeceraEditar.getCodProgramaProduccion()+"'";
                 LOGGER.debug("consulta delete programa "+consulta);
                 pst=con.prepareStatement(consulta);
                 if(pst.executeUpdate()>0)LOGGER.info("se elimino el programa produccion");
                 for(ProgramaProduccion bean:programaProduccionEditarList)
                 {
                     consulta = " insert into programa_produccion(cod_programa_prod,cod_formula_maestra,cod_lote_produccion, " +
                            " cod_estado_programa,observacion,CANT_LOTE_PRODUCCION,VERSION_LOTE,COD_COMPPROD,COD_TIPO_PROGRAMA_PROD,COD_PRESENTACION,nro_lotes" +
                            ",COD_COMPPROD_PADRE,cod_compprod_version,cod_formula_maestra_version,FECHA_REGISTRO,FECHA_EDICION,COD_FORMULA_MAESTRA_ES_VERSION)" +
                            " values('"+programaProduccionCabeceraEditar.getCodProgramaProduccion()+"','"+bean.getFormulaMaestraVersion().getCodFormulaMaestra()+"',"+
                            "'"+codLoteProducionEditar+"','"+bean.getEstadoProgramaProduccion().getCodEstadoProgramaProd()+"','','"+bean.getCantidadLote()+"',1, " +
                            " '"+bean.getFormulaMaestraVersion().getComponentesProd().getCodCompprod()+"'," +
                            "'"+bean.getTiposProgramaProduccion().getCodTipoProgramaProd()+"', " +
                            "'"+bean.getPresentacionesProducto().getCodPresentacion()+"',1,"+
                            ""+programaProduccionCabeceraEditar.getFormulaMaestraVersion().getComponentesProd().getCodCompprod()+"," +
                            "'"+bean.getComponentesProdVersion().getCodVersion()+"','"+bean.getFormulaMaestraVersion().getCodVersion()+"'" +
                            ",'"+(programaProduccionCabeceraEditar.getFechaRegistro()!=null?sdf.format(programaProduccionCabeceraEditar.getFechaRegistro()):"")+"','"+sdf.format(new Date())+"'"+
                            ","+bean.getFormulaMaestraEsVersion().getCodFormulaMaestraEsVersion()+
                            ")";
                    LOGGER.debug("consulta registrar programa Produccion " + consulta);
                    pst=con.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)LOGGER.info("se registro el programa de produccion");
                    
                 }
                 // se migraran los datos al primer producto lote por defecto
                 ProgramaProduccion programaProduccionMigrar=programaProduccionEditarList.get(0);
                 consulta="INSERT INTO SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL(COD_COMPPROD,COD_PROGRAMA_PROD, COD_LOTE_PRODUCCION, COD_FORMULA_MAESTRA,"+
                          " COD_ACTIVIDAD_PROGRAMA, COD_TIPO_PROGRAMA_PROD, COD_PERSONAL, HORAS_HOMBRE,UNIDADES_PRODUCIDAS, FECHA_REGISTRO, FECHA_INICIO, FECHA_FINAL, HORAS_EXTRA,"+
                          " UNIDADES_PRODUCIDAS_EXTRA,COD_REGISTRO_ORDEN_MANUFACTURA,REGISTRO_CERRADO, COD_FRACCION_OM)"+
                          " select '"+programaProduccionMigrar.getFormulaMaestraVersion().getComponentesProd().getCodCompprod()+"'," +
                          " s.COD_PROGRAMA_PROD,s.COD_LOTE_PRODUCCION,'"+programaProduccionMigrar.getFormulaMaestraVersion().getCodFormulaMaestra()+"',"+
                          " s.COD_ACTIVIDAD_PROGRAMA, '"+programaProduccionMigrar.getTiposProgramaProduccion().getCodTipoProgramaProd()+"'," +
                          " s.COD_PERSONAL, s.HORAS_HOMBRE,s.UNIDADES_PRODUCIDAS,s.FECHA_REGISTRO, s.FECHA_INICIO, s.FECHA_FINAL, s.HORAS_EXTRA,"+
                          " s.UNIDADES_PRODUCIDAS_EXTRA,s.COD_REGISTRO_ORDEN_MANUFACTURA,s.REGISTRO_CERRADO, s.COD_FRACCION_OM"+
                          " from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL s"+
                          " where s.COD_LOTE_PRODUCCION = '"+programaProduccionCabeceraEditar.getCodLoteProduccion()+"'" +
                          " and s.COD_PROGRAMA_PROD = '"+programaProduccionCabeceraEditar.getCodProgramaProduccion()+"'" +
                          " and cast (s.COD_TIPO_PROGRAMA_PROD as varchar) + ' ' + cast ( s.COD_COMPPROD as varchar) + ' ' + cast (s.COD_FORMULA_MAESTRA as varchar)" +
                          " not in (select cast (sp.COD_TIPO_PROGRAMA_PROD as varchar) + ' '+ cast (sp.COD_COMPPROD as varchar) + ' ' + cast (sp.COD_FORMULA_MAESTRA as varchar)"+
                          " from PROGRAMA_PRODUCCION sp where" +
                          " sp.COD_PROGRAMA_PROD = '"+programaProduccionCabeceraEditar.getCodProgramaProduccion()+"'" +
                          " and sp.COD_LOTE_PRODUCCION = '"+programaProduccionCabeceraEditar.getCodLoteProduccion()+"')";
                 LOGGER.debug("consulta copiar seguimiento personal"+consulta);
                 pst=con.prepareStatement(consulta);
                 if(pst.executeUpdate()>0)
                 {
                     LOGGER.info("se transfirieron registros");
                     consulta="DELETE from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL "+
                              " where COD_LOTE_PRODUCCION = '"+programaProduccionCabeceraEditar.getCodLoteProduccion()+"'" +
                              " and COD_PROGRAMA_PROD = '"+programaProduccionCabeceraEditar.getCodProgramaProduccion()+"'" +
                              " and cast (COD_TIPO_PROGRAMA_PROD as varchar) + ' ' + cast (COD_COMPPROD as varchar) + ' ' + cast (COD_FORMULA_MAESTRA as varchar)" +
                              " not in (select cast (sp.COD_TIPO_PROGRAMA_PROD as varchar) + ' '+ cast (sp.COD_COMPPROD as varchar) + ' ' + cast (sp.COD_FORMULA_MAESTRA as varchar)"+
                              " from PROGRAMA_PRODUCCION sp where" +
                              " sp.COD_PROGRAMA_PROD = '"+programaProduccionCabeceraEditar.getCodProgramaProduccion()+"'" +
                              " and sp.COD_LOTE_PRODUCCION = '"+programaProduccionCabeceraEditar.getCodLoteProduccion()+"')";
                     LOGGER.debug("consulta eliminar seguimiento personal"+consulta);
                     pst=con.prepareStatement(consulta);
                     if(pst.executeUpdate()>0)LOGGER.info("se eliminaron los registros registros");
                     consulta="delete SEGUIMIENTO_PROGRAMA_PRODUCCION where COD_PROGRAMA_PROD='"+programaProduccionCabeceraEditar.getCodProgramaProduccion()+"'"+
                              " and COD_LOTE_PRODUCCION='"+programaProduccionCabeceraEditar.getCodLoteProduccion()+"'";
                     LOGGER.debug("consulta delete seguimiento anterior "+consulta);
                     pst=con.prepareStatement(consulta);
                     if(pst.executeUpdate()>0)LOGGER.info("se eliminaron registros anteriores de seguimiento programa produccion");
                     consulta="INSERT INTO SEGUIMIENTO_PROGRAMA_PRODUCCION( COD_COMPPROD,  COD_PROGRAMA_PROD,COD_LOTE_PRODUCCION,COD_FORMULA_MAESTRA,"+
                              " COD_ACTIVIDAD_PROGRAMA,FECHA_INICIO,FECHA_FINAL,COD_MAQUINA,HORAS_MAQUINA,HORAS_HOMBRE,COD_TIPO_PROGRAMA_PROD)"+
                              " select spp.COD_COMPPROD,spp.COD_PROGRAMA_PROD,spp.COD_LOTE_PRODUCCION,spp.COD_FORMULA_MAESTRA,"+
                              " spp.COD_ACTIVIDAD_PROGRAMA,MIN(spp.FECHA_INICIO),MAX(spp.FECHA_FINAL),0,0,sum(spp.HORAS_HOMBRE),spp.COD_TIPO_PROGRAMA_PROD"+
                              " from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL spp where spp.COD_PROGRAMA_PROD='"+programaProduccionCabeceraEditar.getCodProgramaProduccion()+"'"+
                              " and spp.COD_LOTE_PRODUCCION='"+programaProduccionCabeceraEditar.getCodLoteProduccion()+"'"+
                              " group by spp.COD_PROGRAMA_PROD,spp.COD_FORMULA_MAESTRA,spp.COD_COMPPROD,spp.COD_TIPO_PROGRAMA_PROD,spp.COD_LOTE_PRODUCCION,spp.COD_ACTIVIDAD_PROGRAMA";
                     LOGGER.debug("consulta insert seguimiento programa ind "+consulta);
                     pst=con.prepareStatement(consulta);
                     if(pst.executeUpdate()>0)LOGGER.info("se registro el seguimiento");
                 }
                consulta="EXEC PAA_REGISTRO_PROGRAMA_PRODUCCION_DETALLE "+
                            programaProduccionCabeceraEditar.getCodProgramaProduccion()+","+
                            "'"+programaProduccionCabeceraEditar.getCodLoteProduccion()+"'";
                LOGGER.debug("consulta REGISTRAR PROGRAMA PRODUCCION DETALLE "+consulta);
                pst=con.prepareStatement(consulta);
                if(pst.executeUpdate()>0)LOGGER.info("se guardo la materia prima");
                
                // <editor-fold defaultstate="collapsed" desc="registro de log de transacciones">

                    ManagedAccesoSistema usuarioModificacion=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
                    consulta="exec PAA_REGISTRO_PROGRAMA_PRODUCCION_LOG ?,?,?,1,0";
                    pst=con.prepareStatement(consulta);
                    pst.setString(1, codLoteProducionEditar);
                    pst.setInt(2,Integer.valueOf(programaProduccionCabeceraEditar.getCodProgramaProduccion()));
                    pst.setInt(3,Integer.valueOf(usuarioModificacion.getUsuarioModuloBean().getCodUsuarioGlobal()));
                    if(pst.executeUpdate()>0)LOGGER.debug("se registro el log de edicion de lote");
                //</editor-fold>
                //<editor-fold defaultstate="collapsed" desc="deshabilitar impresiones de producto">
                
                    consulta = "select count(*) as cantidadEnvios"
                            +" from PROGRAMA_PRODUCCION_INGRESOS_ACOND ppia "
                                    +" inner join INGRESOS_ACOND ia on ia.COD_INGRESO_ACOND = ppia.COD_INGRESO_ACOND"
                            +" where ppia.COD_LOTE_PRODUCCION = '"+codLoteProducionEditar+"'"
                                    +" and ppia.COD_PROGRAMA_PROD = "+programaProduccionCabeceraEditar.getCodProgramaProduccion()
                                    +" and ia.COD_ESTADO_INGRESOACOND<>2";
                    LOGGER.debug("consulta verificar envios de producto: "+consulta);
                    res = st.executeQuery(consulta);
                    res.next();
                    if(res.getInt("cantidadEnvios") == 0){
                        consulta = "update PROGRAMA_PRODUCCION_IMPRESION_OM set COD_ESTADO_PROGRAMA_PRODUCCION_IMPRESION_OM = "+COD_ESTADO_IMPRESION_ANULADO_POR_EDICION+
                                    " where COD_LOTE_PRODUCCION ='"+codLoteProducionEditar+"'"+
                                            " and COD_PROGRAMA_PROD = "+programaProduccionCabeceraEditar.getCodProgramaProduccion();
                        LOGGER.debug("consulta inhabilitar impresion de O.M.: "+consulta);
                        pst = con.prepareStatement(consulta);
                        if(pst.executeUpdate() > 0)LOGGER.info("se actualizaron O.M. existentes");
                    }
                //</editor-fold>
            }
            if(mensaje.equals(""))mensaje="1";
            con.commit();
            if(res!=null)res.close();
            if(pst!=null)pst.close();
            con.close();
        } 
        catch (SQLException ex) 
        {
            con.rollback();
            con.close();
            mensaje="Ocurrio un error al momento de guardar la edición,intente de nuevo";
            LOGGER.warn("error", ex);
        }
        catch(Exception ex)
        {
            if(!con.getAutoCommit())con.rollback();
            if(!con.isClosed())con.close();
            mensaje="Ocurrio un error al momento de guardar la edición,intente de nuevo";
            LOGGER.warn("error", ex);
        }
        return null;
    }
    public String editarProgramaProduccion_action()
    {
        for(ProgramaProduccion bean:programaProduccionList)
        {
            if(bean.getChecked())
            {
                programaProduccionCabeceraEditar = bean;
            }
        }
        return null;
    }
    
    public String getCargarProgramaProduccionEditar()
    {
        try
        {
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            StringBuilder consulta = new StringBuilder("select case when pp.COD_COMPPROD = pp.COD_COMPPROD_PADRE then 1 else 2 end as loteInicio,pp.COD_LOTE_PRODUCCION,pp.COD_PROGRAMA_PROD,pp.COD_COMPPROD,pp.COD_TIPO_PROGRAMA_PROD,tpp.NOMBRE_TIPO_PROGRAMA_PROD,");
                                            consulta.append(" cpv.nombre_prod_semiterminado,pp.COD_FORMULA_MAESTRA_VERSION");
                                            consulta.append(" ,cpv.COD_VERSION as codVersionCp,pp.CANT_LOTE_PRODUCCION");
                                            consulta.append(" ,fmv.CANTIDAD_LOTE as cantidadLoteFm,pp.FECHA_REGISTRO");
                                            consulta.append(" ,pp.COD_PRESENTACION,pp.COD_FORMULA_MAESTRA");
                                            consulta.append(" ,(select count(*) as cantidad from SALIDAS_ALMACEN sa where sa.COD_LOTE_PRODUCCION=pp.COD_LOTE_PRODUCCION");
                                            consulta.append(" and sa.COD_PROD=pp.COD_COMPPROD) as cantidadSalidasBaco");
                                            consulta.append(" ,pp.COD_ESTADO_PROGRAMA,epp.NOMBRE_ESTADO_PROGRAMA_PROD,pp.COD_FORMULA_MAESTRA_ES_VERSION")
                                                    .append(" ,cpv1.NRO_VERSION as nroVersionCpEs,fmev.NRO_VERSION as nroVersionEs")
                                                    .append(" ,cpv.NRO_VERSION,cpv.PRODUCTO_SEMITERMINADO");
                                      consulta.append(" from PROGRAMA_PRODUCCION pp");
                                            consulta.append(" left outer join COMPONENTES_PROD_VERSION cpv on cpv.COD_COMPPROD=pp.COD_COMPPROD");
                                                    consulta.append(" and cpv.COD_VERSION=pp.COD_COMPPROD_VERSION");
                                            consulta.append(" left outer join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD");
                                            consulta.append(" inner join FORMULA_MAESTRA_VERSION fmv on fmv.COD_VERSION=pp.COD_FORMULA_MAESTRA_VERSION");
                                            consulta.append(" inner join ESTADOS_PROGRAMA_PRODUCCION epp on epp.COD_ESTADO_PROGRAMA_PROD=pp.COD_ESTADO_PROGRAMA")
                                                    .append(" left outer join formula_maestra_es_version fmev on fmev.COD_FORMULA_MAESTRA_ES_VERSION = pp.COD_FORMULA_MAESTRA_ES_VERSION")
                                                    .append(" left outer join componentes_prod_version cpv1 on cpv1.COD_VERSION = fmev.COD_VERSION");
                                      consulta.append(" where pp.COD_LOTE_PRODUCCION='").append(programaProduccionCabeceraEditar.getCodLoteProduccion()).append("'");
                                      consulta.append(" and pp.COD_PROGRAMA_PROD=").append(programaProduccionCabeceraEditar.getCodProgramaProduccion());
                                      consulta.append(" order by 1,");
                                      consulta.append(" cpv.nombre_prod_semiterminado,pp.COD_TIPO_PROGRAMA_PROD");
            LOGGER.debug("consulta cargar lotes divididos "+consulta.toString());
            ResultSet res = st.executeQuery(consulta.toString());
            programaProduccionEditarList=new ArrayList<ProgramaProduccion>();
            String productosRestringidos="";
            while (res.next())
            {
                ProgramaProduccion nuevo=new ProgramaProduccion();
                nuevo.setFechaRegistro(res.getTimestamp("FECHA_REGISTRO"));
                nuevo.setCodLoteProduccion(res.getString("COD_LOTE_PRODUCCION"));
                nuevo.setCodProgramaProduccion(res.getString("COD_PROGRAMA_PROD"));
                nuevo.setCantidadLote(res.getDouble("CANT_LOTE_PRODUCCION"));
                nuevo.getEstadoProgramaProduccion().setCodEstadoProgramaProd(res.getString("COD_ESTADO_PROGRAMA"));
                nuevo.getEstadoProgramaProduccion().setNombreEstadoProgramaProd(res.getString("NOMBRE_ESTADO_PROGRAMA_PROD"));
                nuevo.getFormulaMaestraVersion().getComponentesProd().setCodVersionActiva(res.getInt("codVersionCp"));
                nuevo.getFormulaMaestraVersion().getComponentesProd().setNombreProdSemiterminado(res.getString("nombre_prod_semiterminado"));
                nuevo.getFormulaMaestraVersion().getComponentesProd().setCodCompprod(res.getString("COD_COMPPROD"));
                nuevo.getFormulaMaestraVersion().getComponentesProd().setNroVersion(res.getInt("NRO_VERSION")); 
                nuevo.getFormulaMaestraVersion().getComponentesProd().setProductoSemiterminado(res.getInt("PRODUCTO_SEMITERMINADO") > 0);
                nuevo.getTiposProgramaProduccion().setCodTipoProgramaProd(res.getString("COD_TIPO_PROGRAMA_PROD"));
                if(res.getInt("loteInicio")>1)nuevo.getTiposProgramaProduccion().setNombreTipoProgramaProd(res.getString("NOMBRE_TIPO_PROGRAMA_PROD"));
                nuevo.getFormulaMaestraVersion().setCodFormulaMaestra(res.getString("COD_FORMULA_MAESTRA"));
                nuevo.getFormulaMaestraVersion().setCodVersion(res.getInt("COD_FORMULA_MAESTRA_VERSION"));
                nuevo.getFormulaMaestraVersion().getComponentesProd().setCodVersionActiva(res.getInt("codVersionCp"));
                nuevo.getComponentesProdVersion().setCodVersion(res.getInt("codVersionCp"));
                nuevo.getFormulaMaestraVersion().setCantidadLote(res.getDouble("cantidadLoteFm"));
                nuevo.getPresentacionesProducto().setCodPresentacion(res.getString("COD_PRESENTACION"));
                nuevo.getFormulaMaestraEsVersion().setCodFormulaMaestraEsVersion(res.getInt("COD_FORMULA_MAESTRA_ES_VERSION"));
                nuevo.getFormulaMaestraEsVersion().getComponentesProdVersion().setNroVersion(res.getInt("nroVersionCpEs"));
                nuevo.getFormulaMaestraEsVersion().setNroVersion(res.getInt("nroVersionEs"));
                if(res.getInt("cantidadSalidasBaco")>0&&(!productosRestringidos.contains("$"+res.getString("COD_COMPPROD")+"$")))
                {
                    productosRestringidos+="$"+res.getString("COD_COMPPROD")+"$";
                    nuevo.setCantidadSalidasBaco(res.getInt("cantidadSalidasBaco"));
                }
                programaProduccionEditarList.add(nuevo);
            }
            for(ProgramaProduccion bean:programaProduccionEditarList)bean.setPresentacionesProductoList(this.cargarPresentacionesSecundariasVersionSelectList(bean));
            int cantidadDesviaciones = programaProduccionCabeceraEditar.getCantidadDesviaciones();
            programaProduccionCabeceraEditar=(ProgramaProduccion)programaProduccionEditarList.get(0).clone();
            programaProduccionCabeceraEditar.setCantidadDesviaciones(cantidadDesviaciones);
            codLoteProducionEditar=programaProduccionCabeceraEditar.getCodLoteProduccion();
            res.close();
            st.close();
            con.close();
        }
        catch (SQLException ex)
        {
            LOGGER.warn("error", ex);
        }
        //verificar si el lote tiene registros:restriccion de nro de lote
        programaProduccionCabeceraEditar.setLoteConRegistros(this.verificarTransaccionLote(programaProduccionCabeceraEditar.getCodLoteProduccion()));
        if(programaProduccionCabeceraEditar.getCodLoteProduccion().contains("S-L")||programaProduccionCabeceraEditar.getCodLoteProduccion().contains(""))programaProduccionCabeceraEditar.setLoteConRegistros(false);
        return null;
    }
    public String cargarPresentacionesProductoSelect()
    {
        ProgramaProduccion bean=(ProgramaProduccion)programaProduccionAgregarDataTable.getRowData();
        bean.setPresentacionesProductoList(cargarPresentacionesSecundariasVersionSelectList(bean));
        bean.getPresentacionesProducto().setCodPresentacion("0");
        return null;
    }
    public String cargarPresentacionesProductoEditarSelect()
    {
        ProgramaProduccion bean=(ProgramaProduccion)programaProduccionEditarDataTable.getRowData();
        bean.setPresentacionesProductoList(cargarPresentacionesSecundariasVersionSelectList(bean));
        return null;
    }
    private List<SelectItem> cargarPresentacionesSecundariasVersionSelectList(ProgramaProduccion bean)
    {
        List<SelectItem> presentacionesSecundarias=new ArrayList<SelectItem>();
        try
        {
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            StringBuilder consulta = new StringBuilder("select pp.cod_presentacion,pp.NOMBRE_PRODUCTO_PRESENTACION");
                                consulta.append(" from COMPONENTES_PRESPROD_VERSION cpp");
                                        consulta.append(" inner join PRESENTACIONES_PRODUCTO pp on cpp.COD_PRESENTACION=pp.cod_presentacion");
                                consulta.append(" where cpp.COD_TIPO_PROGRAMA_PROD=").append(bean.getTiposProgramaProduccion().getCodTipoProgramaProd());
                                        consulta.append(" and cpp.COD_ESTADO_REGISTRO=1");
                                        consulta.append(" and cpp.COD_FORMULA_MAESTRA_ES_VERSION=").append(bean.getFormulaMaestraEsVersion().getCodFormulaMaestraEsVersion());
                                consulta.append(" order by pp.NOMBRE_PRODUCTO_PRESENTACION");
            LOGGER.debug("consulta presentacion secundarias "+consulta.toString());
            presentacionesSecundarias.add(new SelectItem("0","--NINGUNO--","--NINGUNO--", false));
            ResultSet res = st.executeQuery(consulta.toString());
            while (res.next()) 
            {
                presentacionesSecundarias.add(new SelectItem(res.getString("cod_presentacion"),res.getString("NOMBRE_PRODUCTO_PRESENTACION")));
            }
            res.close();
            st.close();
            con.close();
        }
        catch (SQLException ex)
        {
            LOGGER.warn("error", ex);
        }
        return presentacionesSecundarias;
    }
    
    public String seleccionarFormulaMaestraVersionAgregar()
    {
        programaProduccionCabecera.setFormulaMaestraVersion((FormulaMaestraVersion)formulaMaestraVersionAgregarDataTable.getRowData());
        programaProduccionCabecera.getTiposProgramaProduccion().setCodTipoProgramaProd("1");
        programaProduccionCabecera.getComponentesProdVersion().setCodVersion(programaProduccionCabecera.getFormulaMaestraVersion().getComponentesProd().getCodVersionActiva());
        programaProduccionCabecera.setCantidadLote(((FormulaMaestraVersion)formulaMaestraVersionAgregarDataTable.getRowData()).getCantidadLote());
        programaProduccionCabecera.setFormulaMaestraEsVersion(((FormulaMaestraVersion)formulaMaestraVersionAgregarDataTable.getRowData()).getFormulaMaestraEsVersion());
        if(programaProduccionCabecera.getFormulaMaestraVersion().getComponentesProd().getTiposProduccion().getCodTipoProduccion() != COD_TIPO_PRODUCCION_CONSTITUIDO)
            programaProduccionCabecera.setNroLotes(1);
        else
            programaProduccionCabecera.setNroLotes(0);
        ProgramaProduccion nuevo=(ProgramaProduccion)programaProduccionCabecera.clone();
        nuevo.setPresentacionesProductoList(this.cargarPresentacionesSecundariasVersionSelectList(nuevo));
        nuevo.getPresentacionesProducto().setCodPresentacion("0");
        programaProduccionAgregarList=new ArrayList<ProgramaProduccion>();
        programaProduccionAgregarList.add(nuevo);
        return null;
    }
    public String seleccionarProductoModificarProductoPrograma_action()
    {
        ExternalContext externalContext = FacesContext.getCurrentInstance().getExternalContext();
        Map<String,String> params = externalContext.getRequestParameterMap();
        System.out.println("c fm"+params.get("codVersionFm"));
        programaProduccionCambioProducto.setFormulaMaestraEsVersion(new FormulaMaestraEsVersion());
        programaProduccionCambioProducto.getFormulaMaestraEsVersion().setCodFormulaMaestraEsVersion(Integer.valueOf(params.get("codVersionFmEs")));
        programaProduccionCambioProducto.getFormulaMaestraVersion().getComponentesProd().setCodCompprod(params.get("codCompProd"));
        programaProduccionCambioProducto.getFormulaMaestraVersion().getComponentesProd().setNombreProdSemiterminado(params.get("nombreCompProd"));
        programaProduccionCambioProducto.getFormulaMaestraVersion().setCodVersion(Integer.valueOf(params.get("codVersionFm")));
        programaProduccionCambioProducto.getFormulaMaestraVersion().setCodFormulaMaestra(params.get("codFormula"));
        programaProduccionCambioProducto.getComponentesProdVersion().setCodVersion(Integer.valueOf(params.get("codVersionCp")));
        programaProduccionCambioProducto.getFormulaMaestraVersion().getComponentesProd().setCodVersionActiva(Integer.valueOf(params.get("codVersionCp")));
        programaProduccionCambioProducto.getTiposProgramaProduccion().setCodTipoProgramaProd(params.get("codTipoProgramaProd"));
        programaProduccionCambioProducto.getTiposProgramaProduccion().setNombreTipoProgramaProd(params.get("nombreTipoPrograma"));
        programaProduccionCambioProducto.setPresentacionesProductoList(this.cargarPresentacionesSecundariasVersionSelectList(programaProduccionCambioProducto));
        return null;
    }
    public String modificarProductoProgramaProduccionEditar_action()
    {
        programaProduccionCambioProducto=(ProgramaProduccion)programaProduccionEditarDataTable.getRowData();
        try
        {
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            StringBuilder consulta = new StringBuilder("select cpv.nombre_prod_semiterminado,cpv.COD_COMPPROD,fmv.CANTIDAD_LOTE,fmv.NRO_VERSION as nroVersionFm,cpv.NRO_VERSION");
                                                consulta.append(",fmv.COD_FORMULA_MAESTRA,tpp.NOMBRE_TIPO_PROGRAMA_PROD,tpp.COD_TIPO_PROGRAMA_PROD");
                                                consulta.append(" ,fmv.COD_VERSION as codVersionFm,cpv.COD_VERSION as codVersionCp");
                                                consulta.append(" ,fmev.COD_FORMULA_MAESTRA_ES_VERSION,fmev.NRO_VERSION as nroVersionFMES");
                                    consulta.append(" from FORMULA_MAESTRA_VERSION fmv");
                                                consulta.append(" inner join COMPONENTES_PROD_VERSION cpv on fmv.COD_COMPPROD=cpv.COD_COMPPROD");
                                                consulta.append(" inner join PRODUCTOS_DIVISION_LOTES pdl on pdl.COD_COMPPROD_DIVISION=cpv.COD_COMPPROD");
                                                consulta.append(" inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=pdl.COD_TIPO_PROGRAMA_PRODUCCION");
                                                consulta.append(" inner join FORMULA_MAESTRA_ES_VERSION fmev on fmev.COD_VERSION=cpv.COD_VERSION");
                                    consulta.append(" where fmv.COD_ESTADO_VERSION_FORMULA_MAESTRA=2");
                                                consulta.append(" and cpv.COD_ESTADO_VERSION=2");
                                                consulta.append(" and fmv.COD_ESTADO_REGISTRO=1");
                                                consulta.append(" and cpv.COD_ESTADO_COMPPROD=1 ");
                                                consulta.append(" and cpv.COD_TIPO_PRODUCCION in (1,3)");
                                                consulta.append(" and fmev.COD_ESTADO_VERSION=2");
                                                consulta.append(" and pdl.COD_COMPPROD=").append(programaProduccionCabeceraEditar.getFormulaMaestraVersion().getComponentesProd().getCodCompprod());
                                    consulta.append(" order by cpv.nombre_prod_semiterminado,tpp.NOMBRE_TIPO_PROGRAMA_PROD");
            LOGGER.debug("consulta cargar productos para division "+consulta.toString());
            ResultSet res = st.executeQuery(consulta.toString());
            productosDivisionLotesList.clear();
            while (res.next())
            {
                ProductosDivisionLotes nuevo=new ProductosDivisionLotes();
                nuevo.getFormulaMaestraEsVersion().setCodFormulaMaestraEsVersion(res.getInt("COD_FORMULA_MAESTRA_ES_VERSION"));
                nuevo.getFormulaMaestraEsVersion().setNroVersion(res.getInt("nroVersionFMES"));
                nuevo.getTiposProgramaProduccion().setCodTipoProgramaProd(res.getString("COD_TIPO_PROGRAMA_PROD"));
                nuevo.getTiposProgramaProduccion().setNombreTipoProgramaProd(res.getString("NOMBRE_TIPO_PROGRAMA_PROD"));
                nuevo.getComponentesProd().setCodCompprod(res.getString("COD_COMPPROD"));
                nuevo.getComponentesProd().setNombreProdSemiterminado(res.getString("nombre_prod_semiterminado"));
                FormulaMaestra formula=new FormulaMaestra();
                formula.setCodFormulaMaestra(res.getString("COD_FORMULA_MAESTRA"));
                formula.setCantidadLote(res.getDouble("CANTIDAD_LOTE"));
                formula.setNroVersionFormulaActiva(res.getInt("nroVersionFm"));
                formula.setCodVersionActiva(res.getInt("codVersionFm"));
                nuevo.getComponentesProd().setNroUltimaVersion(res.getInt("NRO_VERSION"));
                nuevo.getComponentesProd().setCodVersionActiva(res.getInt("codVersionCp"));
                nuevo.setFormulaMaestra(formula);
                productosDivisionLotesList.add(nuevo);
            }
            res.close();
            st.close();
            con.close();
        }
        catch (SQLException ex) {
            LOGGER.warn("error", ex);
        }
        return null;
    }
    public String modificarProductoProgramaProduccionAgregar_action()
    {
        programaProduccionCambioProducto=(ProgramaProduccion)programaProduccionAgregarDataTable.getRowData();
        try
        {
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            StringBuilder consulta = new StringBuilder("select cpv.nombre_prod_semiterminado,cpv.COD_COMPPROD,fmv.CANTIDAD_LOTE,fmv.NRO_VERSION as nroVersionFm,cpv.NRO_VERSION");
                                                consulta.append(" ,fmv.COD_FORMULA_MAESTRA,tpp.NOMBRE_TIPO_PROGRAMA_PROD,tpp.COD_TIPO_PROGRAMA_PROD");
                                                consulta.append(" ,fmv.COD_VERSION as codVersionFm,cpv.COD_VERSION as codVersionCp,fmev.COD_FORMULA_MAESTRA_ES_VERSION,fmev.NRO_VERSION as nroVersionFMEs");
                                        consulta.append(" from FORMULA_MAESTRA_VERSION fmv");
                                                consulta.append(" inner join COMPONENTES_PROD_VERSION cpv on fmv.COD_COMPPROD=cpv.COD_COMPPROD");
                                                consulta.append(" inner join PRODUCTOS_DIVISION_LOTES pdl on pdl.COD_COMPPROD_DIVISION=cpv.COD_COMPPROD");
                                                consulta.append(" inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=pdl.COD_TIPO_PROGRAMA_PRODUCCION");
                                                consulta.append(" inner join FORMULA_MAESTRA_ES_VERSION fmev on fmev.COD_VERSION=cpv.COD_VERSION");
                                        consulta.append(" where fmv.COD_ESTADO_VERSION_FORMULA_MAESTRA=2");
                                                consulta.append(" and cpv.COD_ESTADO_VERSION=2");
                                                consulta.append(" and fmv.COD_ESTADO_REGISTRO=1 and cpv.COD_ESTADO_COMPPROD=1 ");
                                                consulta.append(" and cpv.COD_TIPO_PRODUCCION in (1,3)");
                                                consulta.append(" and fmev.COD_ESTADO_VERSION=2");
                                                consulta.append(" and pdl.COD_COMPPROD=").append(programaProduccionCabecera.getFormulaMaestraVersion().getComponentesProd().getCodCompprod());
                                        consulta.append(" order by cpv.nombre_prod_semiterminado,tpp.NOMBRE_TIPO_PROGRAMA_PROD");
            LOGGER.debug("consulta cargar productos para division "+consulta.toString());
            ResultSet res = st.executeQuery(consulta.toString());
            productosDivisionLotesList.clear();
            while (res.next())
            {
                ProductosDivisionLotes nuevo=new ProductosDivisionLotes();
                nuevo.getFormulaMaestraEsVersion().setCodFormulaMaestraEsVersion(res.getInt("COD_FORMULA_MAESTRA_ES_VERSION"));
                nuevo.getFormulaMaestraEsVersion().setNroVersion(res.getInt("nroVersionFMEs"));
                nuevo.getTiposProgramaProduccion().setCodTipoProgramaProd(res.getString("COD_TIPO_PROGRAMA_PROD"));
                nuevo.getTiposProgramaProduccion().setNombreTipoProgramaProd(res.getString("NOMBRE_TIPO_PROGRAMA_PROD"));
                nuevo.getComponentesProd().setCodCompprod(res.getString("COD_COMPPROD"));
                nuevo.getComponentesProd().setNombreProdSemiterminado(res.getString("nombre_prod_semiterminado"));
                FormulaMaestra formula=new FormulaMaestra();
                formula.setCodFormulaMaestra(res.getString("COD_FORMULA_MAESTRA"));
                formula.setCantidadLote(res.getDouble("CANTIDAD_LOTE"));
                formula.setNroVersionFormulaActiva(res.getInt("nroVersionFm"));
                formula.setCodVersionActiva(res.getInt("codVersionFm"));
                nuevo.getComponentesProd().setNroUltimaVersion(res.getInt("NRO_VERSION"));
                nuevo.getComponentesProd().setCodVersionActiva(res.getInt("codVersionCp"));
                nuevo.setFormulaMaestra(formula);
                productosDivisionLotesList.add(nuevo);
            }
            res.close();
            st.close();
            con.close();
        }
        catch (SQLException ex) {
            LOGGER.warn("error", ex);
        }
        return null;
    }
    public String getCargarAgregarProgramaProduccion()
    {
        this.cargarTiposProduccionSelectList();
        codTipoProduccion = Integer.valueOf(tiposProduccionSelectList.get(0).getValue().toString());
        programaProduccionCabecera=new ProgramaProduccion();
        programaProduccionAgregarList=new ArrayList<ProgramaProduccion>();
        this.cargarFormulaMaestraAgregar_action();
        
        return null;
    }
    public String codTipoProduccionChange()
    {
        this.cargarFormulaMaestraAgregar_action();
        return null;
    }
    public String cargarFormulaMaestraAgregar_action()
    {
        try
        {
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            StringBuilder consulta = new StringBuilder("select cpv.nombre_prod_semiterminado,cpv.COD_COMPPROD,fmv.CANTIDAD_LOTE,fmv.NRO_VERSION as nroVersionFm,cpv.NRO_VERSION");
                                    consulta.append(" ,fmv.cod_version,cpv.COD_VERSION AS codVersionCp,fmv.COD_FORMULA_MAESTRA");
                                    consulta.append(",fmev.NRO_VERSION as nroVersionEs,fmev.COD_FORMULA_MAESTRA_ES_VERSION");
                                    consulta.append(" ,cpv.COD_TIPO_PRODUCCION,cpv.PRODUCTO_SEMITERMINADO");
                              consulta.append(" from FORMULA_MAESTRA_VERSION fmv");
                                    consulta.append(" inner join COMPONENTES_PROD_VERSION cpv on fmv.COD_COMPPROD=cpv.COD_COMPPROD")
                                                .append(" and cpv.COD_VERSION = fmv.COD_COMPPROD_VERSION");
                                    consulta.append(" inner join FORMULA_MAESTRA_ES_VERSION fmev on fmev.COD_VERSION=cpv.COD_VERSION");
                              consulta.append(" where cpv.COD_TIPO_PRODUCCION =").append(codTipoProduccion);
                                    consulta.append(" and cpv.COD_TIPO_COMPONENTES_PROD_VERSION=1");
                                if(codTipoProduccion == COD_TIPO_PRODUCCION_CONSTITUIDO){
                                    consulta.append(" and cpv.COD_ESTADO_VERSION=2")
                                            .append(" and fmv.COD_ESTADO_REGISTRO=1")
                                            .append(" and cpv.COD_ESTADO_COMPPROD=1 ")
                                            .append(" and fmev.COD_ESTADO_VERSION=2")
                                            .append(" and fmv.COD_ESTADO_VERSION_FORMULA_MAESTRA=2");
                                }
                                else{
                                    consulta.append(" and cpv.COD_VERSION not in(")
                                            .append(" select pp.COD_COMPPROD_VERSION")
                                                .append(" from PROGRAMA_PRODUCCION pp")
                                                        .append(" inner join PROGRAMA_PRODUCCION_PERIODO ppp on pp.COD_PROGRAMA_PROD= pp.COD_PROGRAMA_PROD")
                                                        .append(" inner join COMPONENTES_PROD_VERSION cpv on cpv.COD_VERSION = pp.COD_COMPPROD_VERSION")
                                                                .append(" and cpv.COD_COMPPROD = pp.COD_COMPPROD")
                                                .append(" where pp.COD_ESTADO_PROGRAMA not in (3,9)")
                                                .append(" and ppp.COD_ESTADO_PROGRAMA<>4")
                                                .append(" and ppp.COD_PROGRAMA_PROD>0")
                                                .append(" and cpv.COD_TIPO_PRODUCCION =3")
                                            .append(")");
                                }
                              consulta.append(" order by");
                              if(!programaProduccionCabecera.getFormulaMaestraVersion().getCodFormulaMaestra().equals(""))
                                  consulta.append(" case when fmv.COD_FORMULA_MAESTRA=").append(programaProduccionCabecera.getFormulaMaestraVersion().getCodFormulaMaestra()).append(" then 1 else 2 end,");
                              consulta.append(" cpv.nombre_prod_semiterminado,fmv.CANTIDAD_LOTE ");
            LOGGER.debug("consulta cargar lote Agregar "+consulta.toString());
            ResultSet res = st.executeQuery(consulta.toString());
            formulaMaestraVersionAgregarList.clear();
            while (res.next())
            {
                FormulaMaestraVersion nuevo=new FormulaMaestraVersion();
                nuevo.setFormulaMaestraEsVersion(new FormulaMaestraEsVersion());
                nuevo.getFormulaMaestraEsVersion().setCodFormulaMaestraEsVersion(res.getInt("COD_FORMULA_MAESTRA_ES_VERSION"));
                nuevo.getFormulaMaestraEsVersion().setNroVersion(res.getInt("nroVersionEs"));
                nuevo.setCodFormulaMaestra(res.getString("COD_FORMULA_MAESTRA"));
                nuevo.setChecked(programaProduccionCabecera.getFormulaMaestraVersion().getCodFormulaMaestra().equals(nuevo.getCodFormulaMaestra()));
                nuevo.getComponentesProd().setNombreProdSemiterminado(res.getString("nombre_prod_semiterminado"));
                nuevo.getComponentesProd().setCodCompprod(res.getString("COD_COMPPROD"));
                nuevo.getComponentesProd().setNroUltimaVersion(res.getInt("NRO_VERSION"));
                nuevo.getComponentesProd().setProductoSemiterminado(res.getInt("PRODUCTO_SEMITERMINADO") > 0);
                nuevo.getComponentesProd().getTiposProduccion().setCodTipoProduccion(res.getInt("COD_TIPO_PRODUCCION"));
                nuevo.setCantidadLote(res.getDouble("CANTIDAD_LOTE"));
                nuevo.setNroVersionFormulaActiva(res.getInt("nroVersionFm"));
                nuevo.getComponentesProd().setCodVersionActiva(res.getInt("codVersionCp"));
                nuevo.setCodVersion(res.getInt("cod_version"));
                formulaMaestraVersionAgregarList.add(nuevo);
            }
            res.close();
            st.close();
            con.close();
        }
        catch (SQLException ex)
        {
            LOGGER.warn("error", ex);
        }
        return null;
    }

    private void cargarTiposProgramaProduccionSelect()
    {
        try
        {
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            String consulta = "select tpp.COD_TIPO_PROGRAMA_PROD,tpp.NOMBRE_TIPO_PROGRAMA_PROD"+
                              " from TIPOS_PROGRAMA_PRODUCCION tpp where tpp.COD_ESTADO_REGISTRO=1 order by tpp.NOMBRE_TIPO_PROGRAMA_PROD";
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
    public String seleccionarProgramaProducccionPeriodo_action()
    {
        programaProduccionFiltro.setCodLoteProduccion("");
        return null;
    }
    //funcion para verificar si el lote tiene salidas y tiempos registrados
    private boolean verificarTransaccionLote(String codLote)
    {
        boolean loteConRegistros=false;
        if(codLote.equals("")||codLote.contains("S-L"))
        {
            loteConRegistros=false;
            return false;
        }
        
        try {
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            String consulta = "select count(*) as cantidadSalidas from SALIDAS_ALMACEN sa" +
                              " where sa.COD_LOTE_PRODUCCION='"+codLote+"'"+
                              " and sa.COD_ESTADO_SALIDA_ALMACEN <> 2";
            LOGGER.debug("consulta verificar salidas "+consulta);
            ResultSet res = st.executeQuery(consulta);
            if(res.next())
            {
                loteConRegistros=(res.getInt("cantidadSalidas")>0);
            }
            if(!loteConRegistros)
            {
                consulta="select count(*) as cantidadTiempos from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL s" +
                         " where s.COD_LOTE_PRODUCCION='"+codLote+"' and s.HORAS_HOMBRE>0";
                LOGGER.debug("consulta verificar tiempos registrados "+consulta);
                res=st.executeQuery(consulta);
                if(res.next())
                {
                    loteConRegistros=(res.getInt("cantidadTiempos")>0);
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
        return loteConRegistros;
    }
    public String getCargarProgramaProducion()
    {
        this.cargarPermisosPersonal_action();
        this.cargarTiposProgramaProduccionSelect();
        this.cargarProgramaProduccionList();
        return null;
    }
    private void cargarProgramaProduccionList()
    {
        try
        {
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ManagedAccesoSistema managed=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
            StringBuilder consulta =new StringBuilder("exec PAA_NAVEGADOR_PROGRAMA_PRODUCCION ");
                                            consulta.append("'").append(programaProduccionFiltro.getCodLoteProduccion()).append("',");
                                            consulta.append(programaProduccionPeriodoBean!=null?programaProduccionPeriodoBean.getCodProgramaProduccion():"0").append(",");
                                                consulta.append(managed.getUsuarioModuloBean().getCodUsuarioGlobal());
            LOGGER.debug("consulta cargar Programa produccion "+consulta.toString());
            LOGGER.info("pr "+programaProduccionFiltro.getCodLoteProduccion());
            ResultSet res=st.executeQuery(consulta.toString());
            NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
            DecimalFormat form = (DecimalFormat)nf;
            form.applyPattern("#,#00.0#");
            programaProduccionList.clear();
            while(res.next())
            {
                ProgramaProduccion nuevo=new ProgramaProduccion();
                nuevo.setCantidadDesviaciones(res.getInt("cantidadDesviaciones"));
                nuevo.getEstadosProgramaProduccionImpresionOm().setCodEstadoProgramaProduccionImpresionOm(res.getInt("COD_ESTADO_PROGRAMA_PRODUCCION_IMPRESION_OM"));
                nuevo.getProgramaProduccionPeriodo().setNombreProgramaProduccion(res.getString("NOMBRE_PROGRAMA_PROD"));
                nuevo.setCodProgramaProduccion(res.getString("cod_programa_prod"));
                nuevo.getFormulaMaestra().setCodFormulaMaestra(res.getString("COD_FORMULA_MAESTRA"));
                nuevo.setCodLoteProduccion(res.getString("COD_LOTE_PRODUCCION"));
                nuevo.setCodEstadoPrograma(res.getString("COD_ESTADO_PROGRAMA"));
                nuevo.getEstadoProgramaProduccion().setCodEstadoProgramaProd(res.getString("COD_ESTADO_PROGRAMA"));
                nuevo.setObservacion(res.getString("OBSERVACION"));
                nuevo.getFormulaMaestra().getComponentesProd().setNombreProdSemiterminado(res.getString("nombre_prod_semiterminado"));
                nuevo.getFormulaMaestra().getComponentesProd().setCodCompprod(res.getString("COD_COMPPROD"));
                nuevo.getFormulaMaestra().setCantidadLote(res.getDouble("cantidad_lote"));
                nuevo.getEstadoProgramaProduccion().setNombreEstadoProgramaProd(res.getString("NOMBRE_ESTADO_PROGRAMA_PROD") + "(" +res.getString("NOMBRE_ACTIVIDAD")+  ")");
                nuevo.getTiposProgramaProduccion().setNombreProgramaProd(res.getString("NOMBRE_TIPO_PROGRAMA_PROD"));
                nuevo.getCategoriasCompProd().setNombreCategoriaCompProd(res.getString("NOMBRE_CATEGORIACOMPPROD"));
                nuevo.setCantidadLote(res.getDouble("CANT_LOTE_PRODUCCION"));
                nuevo.getFormulaMaestra().getComponentesProd().getAreasEmpresa().setNombreAreaEmpresa(res.getString("NOMBRE_AREA_EMPRESA"));
                nuevo.getFormulaMaestra().getComponentesProd().getAreasEmpresa().setCodAreaEmpresa(res.getString("COD_AREA_EMPRESA"));
                nuevo.getTiposProgramaProduccion().setCodTipoProgramaProd(res.getString("COD_TIPO_PROGRAMA_PROD"));
                nuevo.getTiposProgramaProduccion().setNombreTipoProgramaProd(res.getString("NOMBRE_TIPO_PROGRAMA_PROD"));
                nuevo.setMaterialTransito(res.getInt("MATERIAL_TRANSITO")==0?"CON EXISTENCIA":(res.getInt("MATERIAL_TRANSITO")==1?"EN TRÁNSITO":""));
                nuevo.setStyleClass(res.getInt("MATERIAL_TRANSITO")==0?"b":(res.getInt("MATERIAL_TRANSITO")==1?"a":""));
                nuevo.getFormulaMaestra().getComponentesProd().setVidaUtil(res.getInt("VIDA_UTIL"));
                nuevo.getFormulaMaestra().getComponentesProd().getForma().setCodForma(res.getString("COD_FORMA"));
                nuevo.getComponentesProdVersion().setCodVersion(res.getInt("cod_version_cp"));
                nuevo.getComponentesProdVersion().setNroVersion(res.getInt("nro_version_cp"));
                nuevo.getFormulaMaestraVersion().setCodVersion(res.getInt("cod_version_fm"));
                nuevo.getFormulaMaestraVersion().setNroVersion(res.getInt("nro_version_fm"));
                nuevo.getFormulaMaestraEsVersion().setCodFormulaMaestraEsVersion(res.getInt("COD_FORMULA_MAESTRA_ES_VERSION"));
                nuevo.getFormulaMaestraEsVersion().setNroVersion(res.getInt("nroVersionFmEs"));
                nuevo.setFechaRegistro(res.getTimestamp("FECHA_REGISTRO"));
                //<editor-fold desc="cantidad horas" defaultstate="collapsed">
                    nuevo.setHorasAcondicionamiento(res.getDouble("horasAcond"));
                    nuevo.setHorasMicrobiologia(res.getDouble("horasMicrobiologia"));
                    nuevo.setHorasControlCalidad(res.getDouble("horasControlCalidad"));
                    nuevo.setHorasProduccion(res.getDouble("horasProduccion"));
                    nuevo.setHorasSoporteManufactura(res.getDouble("horasSoporte"));
                //</editor-fold>
                programaProduccionList.add(nuevo);
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
    public String guardarNuevoProgramaProduccionPeriodo_action()throws SQLException
    {
        transaccionExitosa=false;
        try 
        {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            String consulta = "select isnull(MAX(pp.COD_PROGRAMA_PROD),0)+1 as codProgProd"+
                              " from PROGRAMA_PRODUCCION_PERIODO pp";
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta);
            int codProgProd=0;
            SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");
            if(res.next())codProgProd=res.getInt("codProgProd");
            consulta="INSERT INTO PROGRAMA_PRODUCCION_PERIODO(COD_PROGRAMA_PROD, NOMBRE_PROGRAMA_PROD,"+
                     " OBSERVACIONES, COD_ESTADO_PROGRAMA, FECHA_INICIO, FECHA_FINAL,"+
                     " COD_TIPO_PRODUCCION,FECHA_PROGRAMA_PRODUCCION)"+
                     " VALUES ('"+codProgProd+"','"+programaProduccionPeriodoAgregar.getNombreProgramaProduccion()+"'," +
                     "'"+programaProduccionPeriodoAgregar.getObsProgramaProduccion()+"',"+
                     " 1, '"+sdf.format(programaProduccionPeriodoAgregar.getFechaInicio())+" 00:00'," +
                     "'"+sdf.format(programaProduccionPeriodoAgregar.getFechaFinal())+" 23:59',1,"+
                    " DATEADD(DAY,DATEDIFF(day,'"+sdf.format(programaProduccionPeriodoAgregar.getFechaInicio())+"','"+sdf.format(programaProduccionPeriodoAgregar.getFechaFinal())+"')/2,'"+sdf.format(programaProduccionPeriodoAgregar.getFechaInicio())+"')"+
                    " )";
            LOGGER.debug("consulta guardar nuevo programa "+consulta);
            PreparedStatement pst = con.prepareStatement(consulta);
            if (pst.executeUpdate() > 0)LOGGER.info("se registro el nuevo programa Produccion periodo");
            con.commit();
            this.mostrarMensajeTransaccionExitosa("se registro el nuevo programa producción");
            pst.close();
            con.close();
        } 
        catch (SQLException ex)
        {
            this.mostrarMensajeTransaccionFallida("Ocurrio un error al momento de guardar el nuevo programa produccion periodo,intente de nuevo");
            con.rollback();
            con.close();
            LOGGER.warn("error", ex);
        }
        return null;
    }
    public String guardarEdicionProgramaProduccionPeriodo_action()throws SQLException
    {
        mensaje="";
        try {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");
            String consulta = "update PROGRAMA_PRODUCCION_PERIODO set" +
                              " OBSERVACIONES='"+programaProduccionPeriodoEditar.getObsProgramaProduccion()+"',"+
                              " NOMBRE_PROGRAMA_PROD='"+programaProduccionPeriodoEditar.getNombreProgramaProduccion()+"'"+
                              " where COD_PROGRAMA_PROD='"+programaProduccionPeriodoEditar.getCodProgramaProduccion()+"'";
            LOGGER.debug("consulta update programa produccion periodo "+consulta);
            PreparedStatement pst = con.prepareStatement(consulta);
            if (pst.executeUpdate() > 0)LOGGER.info("se actualizo el programa de produccion periodo");
            con.commit();
            mensaje="1";
            pst.close();
            con.close();
        } catch (SQLException ex) {
            con.rollback();
            con.close();
            mensaje="Ocurrio un error al momento de guardar la edicion,intente de nuevo";
            LOGGER.warn("error", ex);
        }
        return null;
    }
    public String eliminarProgramaProduccionPeriodo_action()throws SQLException
    {
        mensaje="";
        for(ProgramaProduccionPeriodo bean:programaProduccionPeriodoList)
        {
            if(bean.getChecked())
            {
                try
                {
                    con = Util.openConnection(con);
                    con.setAutoCommit(false);
                    String consulta = "select count(*)  as contLotes"+
                                      " from PROGRAMA_PRODUCCION p where p.COD_PROGRAMA_PROD='"+bean.getCodProgramaProduccion()+"'";
                    LOGGER.debug("consulta verificar que el programa no tenga registrado lotes "+consulta);
                    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet res=st.executeQuery(consulta);
                    res.next();
                    PreparedStatement pst=null;
                    if(res.getInt("contLotes")>0)
                    {
                        mensaje="No se puede eliminar el Programa de Produccion porque tiene registrado "+res.getInt("contLotes")+" lotes";
                    }
                    else
                    {
                        consulta="delete PROGRAMA_PRODUCCION_PERIODO  where COD_PROGRAMA_PROD='"+bean.getCodProgramaProduccion()+"'";
                        LOGGER.debug("consulta delete programa produccion periodo "+consulta);
                        pst=con.prepareStatement(consulta);
                        if(pst.executeUpdate()>0)LOGGER.info("se elimino el programa de produccion periodo");
                        mensaje="1";
                    }
                    con.commit();

                    if(pst!=null)pst.close();
                    con.close();
                }
                catch (SQLException ex)
                {
                    con.rollback();
                    con.close();
                    mensaje="Ocurrio un error al momento de eliminar el programa periodo, intente de nuevo";
                    LOGGER.warn("error", ex);
                }
            }
        }
        if(mensaje.equals("1"))
        {
            this.cargarProgramaProduccionPeriodo();
        }
        return null;
    }
    public String editarProgramaProduccionPeriodo_action()
    {
        for(ProgramaProduccionPeriodo bean:programaProduccionPeriodoList)
        {
            if(bean.getChecked())
            {
                programaProduccionPeriodoEditar=bean;
            }
        }
        return null;
    }
    public String getCargarAgregarProgramaProduccionPeriodo()
    {
        programaProduccionPeriodoAgregar=new ProgramaProduccionPeriodo();
        try {
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            String consulta = "select max(p.FECHA_FINAL) as fechaInicio,DATEADD(MONTH,1,max(p.FECHA_FINAL)) as fechaFin"+
                              " from PROGRAMA_PRODUCCION_PERIODO p where p.COD_ESTADO_PROGRAMA<>4 and p.COD_TIPO_PRODUCCION=1";
            LOGGER.debug("consulta fecha inicio fin "+consulta);
            ResultSet res = st.executeQuery(consulta);
            SimpleDateFormat sdfMes=new SimpleDateFormat("MMMM yyyy",new Locale("ES"));
            while (res.next()) 
            {
                programaProduccionPeriodoAgregar.setFechaInicio(res.getDate("fechaInicio"));
                programaProduccionPeriodoAgregar.getFechaInicio().setDate(27);
                programaProduccionPeriodoAgregar.setFechaFinal(res.getDate("fechaFin"));
                programaProduccionPeriodoAgregar.getFechaFinal().setDate(26);
                programaProduccionPeriodoAgregar.setNombreProgramaProduccion(sdfMes.format(res.getDate("fechaFin")).toUpperCase());
                programaProduccionPeriodoAgregar.setObsProgramaProduccion("Programa de Producción "+programaProduccionPeriodoAgregar.getNombreProgramaProduccion().toLowerCase());
            }
            res.close();
            st.close();
            con.close();
        } catch (SQLException ex) {
            LOGGER.warn("error", ex);
        }
        return null;
    }
    public String getCargarProgramaProduccionPeriodo()throws SQLException
    {
        this.cargarPermisosPersonal_action();
        this.cargarProgramaProduccionPeriodo();
        return null;
    }
    private void cargarProgramaProduccionPeriodo()
    {
          try {
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            String consulta = "select ppp.COD_ESTADO_PROGRAMA,ppp.COD_PROGRAMA_PROD,ppp.NOMBRE_PROGRAMA_PROD,ppp.OBSERVACIONES,epp.NOMBRE_ESTADO_PROGRAMA_PROD" +
                              ",ppp.FECHA_INICIO,ppp.FECHA_FINAL"+
                              " from PROGRAMA_PRODUCCION_PERIODO ppp left outer join ESTADOS_PROGRAMA_PRODUCCION epp on "+
                              " ppp.COD_ESTADO_PROGRAMA=epp.COD_ESTADO_PROGRAMA_PROD"+
                              " where ppp.COD_ESTADO_PROGRAMA<>4 and ISNULL(ppp.COD_TIPO_PRODUCCION,1) in (1)" +
                              " order by ppp.COD_PROGRAMA_PROD desc";
            LOGGER.debug("consulta cargar programa periodo "+consulta);
            ResultSet res = st.executeQuery(consulta);
            programaProduccionPeriodoList.clear();
            while (res.next())
            {
                ProgramaProduccionPeriodo nuevo=new ProgramaProduccionPeriodo();
                nuevo.setCodProgramaProduccion(res.getString("COD_PROGRAMA_PROD"));
                nuevo.setNombreProgramaProduccion(res.getString("NOMBRE_PROGRAMA_PROD"));
                nuevo.setObsProgramaProduccion(res.getString("OBSERVACIONES"));
                nuevo.getEstadoProgramaProduccion().setNombreEstadoProgramaProd(res.getString("NOMBRE_ESTADO_PROGRAMA_PROD"));
                nuevo.getEstadoProgramaProduccion().setCodEstadoProgramaProd(res.getString("COD_ESTADO_PROGRAMA"));
                nuevo.setFechaInicio(res.getDate("FECHA_INICIO"));
                nuevo.setFechaFinal(res.getDate("FECHA_FINAL"));
                programaProduccionPeriodoList.add(nuevo);
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
    public String masProgramaProduccionAgregar_action()
    {
        System.out.println("agregar nuevo registro programa produccion");
        ProgramaProduccion nuevo=(ProgramaProduccion)programaProduccionCabecera.clone();
        nuevo.setPresentacionesProductoList(this.cargarPresentacionesSecundariasVersionSelectList(nuevo));
        int cantidaAsignar=0;
        for(ProgramaProduccion bean:programaProduccionAgregarList)
        {
            cantidaAsignar+=bean.getCantidadLote();
        }
        nuevo.setCantidadLote(programaProduccionCabecera.getCantidadLote()-cantidaAsignar);
        programaProduccionAgregarList.add(nuevo);
        return null;
    }
    public String masProgramaProduccionEditar_action()
    {
        System.out.println("agregar nuevo registro editar programa produccion");
        ProgramaProduccion nuevo=(ProgramaProduccion)programaProduccionCabeceraEditar.clone();
        nuevo.setPresentacionesProductoList(this.cargarPresentacionesSecundariasVersionSelectList(nuevo));
        nuevo.setCantidadSalidasBaco(0);
        if(!nuevo.getEstadoProgramaProduccion().getCodEstadoProgramaProd().equals("2"))
        {
            nuevo.getEstadoProgramaProduccion().setCodEstadoProgramaProd("7");
            nuevo.getEstadoProgramaProduccion().setNombreEstadoProgramaProd("EN PROCESO");
        }
        programaProduccionEditarList.add(nuevo);
        return null;
    }
    public String menosProgramaProduccionEditar_action()
    {
        List<ProgramaProduccion> nuevaLista=new ArrayList();
        for(ProgramaProduccion bean:programaProduccionEditarList)
        {
            if(!bean.getChecked())
            {
                nuevaLista.add((ProgramaProduccion)bean.clone());
            }
        }
        programaProduccionEditarList.clear();
        programaProduccionEditarList=nuevaLista;
        return null;
    }
    //<editor-fold defaultstate="collapsed" desc="edicion de envio de producto">
        public String seleccionarEdicionEnvionAcondicionamientoAction(){
            DaoIngresosAcond daoIngresosAcond = new DaoIngresosAcond(LOGGER);
            ingresosDetalleAcondRegistradosList = daoIngresosAcond.listarPorProgramaProduccion(programaProduccionIngresoAcond);
            this.cargarTiposEnvaseSelectList();
            cantidadEnvaseSelectList.clear();
            for(int i=1;i<=50;i++)cantidadEnvaseSelectList.add(new SelectItem(String.valueOf(i),String.valueOf(i)));
            return null;
        }
    //</editor-fold>

    //<editor-fold desc="apertura de lotes de producccion" defaultstate="collapsed">
    public String seleccionarAperturaLoteProgramaProduccion_action()
    {
        programaProduccionApertura.setObservacion("");
        return null;
    }
    public String guardarAperturaLoteProgramaProduccion_action()throws SQLException
    {
        transaccionExitosa = false;
        mensaje = "";
        try {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            ManagedAccesoSistema managed=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
            StringBuilder consulta=new StringBuilder("update PROGRAMA_PRODUCCION");
                        consulta.append(" set COD_ESTADO_PROGRAMA=7,");
                                consulta.append(" OBSERVACION=cast(OBSERVACION as varchar(400))+' Apertura de lote: ").append(programaProduccionApertura.getObservacion()).append(";'");
                        consulta.append(" where COD_LOTE_PRODUCCION=?");
                                consulta.append(" and COD_PROGRAMA_PROD=").append(programaProduccionApertura.getCodProgramaProduccion());
                                consulta.append(" and COD_TIPO_PROGRAMA_PROD=").append(programaProduccionApertura.getTiposProgramaProduccion().getCodTipoProgramaProd());
                                consulta.append(" and COD_COMPPROD=").append(programaProduccionApertura.getFormulaMaestra().getComponentesProd().getCodCompprod());
            LOGGER.debug("consulta aperturar lote "+consulta.toString());
            PreparedStatement pst=con.prepareStatement(consulta.toString());
            pst.setString(1,programaProduccionApertura.getCodLoteProduccion());
            if(pst.executeUpdate()>0)LOGGER.info("se registro la apertura del lote de produccion ");
            
            consulta = new StringBuilder("exec PAA_REGISTRO_PROGRAMA_PRODUCCION_LOG ");
                                    consulta.append(" ?,");//cod lote produccion
                                    consulta.append(programaProduccionApertura.getCodProgramaProduccion()).append(",");//cod lote produccion
                                    consulta.append("?,");//cod personal transaccion
                                    consulta.append("1,");//edicion
                                    consulta.append("0,");//codigos desviacion
                                    consulta.append("' Apertura de lote, ").append(programaProduccionApertura.getObservacion()).append("'");//descirpcion cambio
            LOGGER.debug("consulta registrar programa produccion log apertura" + consulta.toString());
            pst = con.prepareStatement(consulta.toString());
            pst.setString(1,programaProduccionApertura.getCodLoteProduccion());LOGGER.info("p1: "+programaProduccionApertura.getCodLoteProduccion());
            pst.setString(2, managed.getUsuarioModuloBean().getCodUsuarioGlobal());LOGGER.info("p2: "+managed.getUsuarioModuloBean().getCodUsuarioGlobal());
            if (pst.executeUpdate() > 0)LOGGER.info("se registro la apertura del lote ");
            con.commit();
            this.mostrarMensajeTransaccionExitosa("Se realizo la apertura correcto del lotes de producción");
        } catch (SQLException ex) {
            this.mostrarMensajeTransaccionFallida("Ocurrio un error al momento de guardar el registro");
            LOGGER.warn(ex.getMessage());
            con.rollback();
        } catch (Exception ex) {
            this.mostrarMensajeTransaccionFallida("Ocurrio un error al momento de guardar el registro,verifique los datos introducidos");
            LOGGER.warn(ex.getMessage());
        } finally {
            this.cerrarConexion(con);
        }
        if(transaccionExitosa){
            this.cargarProgramaProduccionList();
        }
        return null;
    }
    //</editor-fold>
    
    //para envio  a acondicionamiento
    public String modificarIngresoAcondAction(){
        transaccionExitosa = false;
        for(IngresosDetalleAcond bean : ingresosAcond.getIngresosDetalleAcondList()){
            if(Integer.valueOf(bean.getCantidadEnvase())!=
                bean.getListadoCantidadPeso().size()){
                this.mostrarMensajeTransaccionFallida("Debe registrar el detalle");
                return null;
            }
        }
        ingresosAcond.getIngresosDetalleAcondList().get(0).setCantTotalIngreso(ingresosAcond.getIngresosDetalleAcondList().get(0).getCantIngresoProduccion());
        ingresosAcond.getIngresosDetalleAcondList().get(0).setCantRestante(ingresosAcond.getIngresosDetalleAcondList().get(0).getCantIngresoProduccion());
        DaoIngresosAcond daoIngresosAcond = new DaoIngresosAcond(LOGGER);
        if(daoIngresosAcond.modificar(ingresosAcond, "edicion de envio de producto a acondicionamiento")){
            this.mostrarMensajeTransaccionExitosa("Se registro satisfactoriamente la edición del envio de producto a acondicionamiento");
            this.seleccionarEdicionEnvionAcondicionamientoAction();
        }
        else{
            this.mostrarMensajeTransaccionFallida("Ocurrio un error al momento de registrar el ingreso,intente de nuevo");
        }
        return null;
    }
    
    public String anularIngresoAcondAction(){
        transaccionExitosa = false;
        ingresosAcond.getIngresosDetalleAcondList().get(0).setCantTotalIngreso(ingresosAcond.getIngresosDetalleAcondList().get(0).getCantIngresoProduccion());
        ingresosAcond.getIngresosDetalleAcondList().get(0).setCantRestante(ingresosAcond.getIngresosDetalleAcondList().get(0).getCantIngresoProduccion());
        DaoIngresosAcond daoIngresosAcond = new DaoIngresosAcond(LOGGER);
        ingresosAcond.getEstadosIngresoAcond().setCodEstadoIngresoAcond(COD_ESTADO_INGRESO_ACOND_ANULADO);
        if(daoIngresosAcond.modificar(ingresosAcond, "anulación de envio de producto a acondicionamiento")){
            this.mostrarMensajeTransaccionExitosa("Se anulo satisfactoriamente el envio de producto a acondicionamiento");
            this.seleccionarEdicionEnvionAcondicionamientoAction();
        }
        else{
            this.mostrarMensajeTransaccionFallida("Ocurrio un error al momento de anular el envio de producto,intente de nuevo");
        }
        return null;
    }
    
    public String guardarIngresoAcond_action()throws SQLException
    {
        transaccionExitosa = false;
        mensaje="";
        int codEstadoPrograma = 0;
        try{
            for(IngresosDetalleAcond bean : ingresosAcond.getIngresosDetalleAcondList()){
                if(Integer.valueOf(bean.getCantidadEnvase())!=
                    bean.getListadoCantidadPeso().size()){
                    this.mostrarMensajeTransaccionFallida("Debe registrar el detalle");
                    return null;
                }
            }
            con = Util.openConnection(con);
            String consulta=" select p.COD_ESTADO_PROGRAMA from PROGRAMA_PRODUCCION p"+
                            " where p.COD_LOTE_PRODUCCION='"+getProgramaProduccionIngresoAcond().getCodLoteProduccion()+"'"+
                                    " and p.COD_COMPPROD="+getProgramaProduccionIngresoAcond().getFormulaMaestra().getComponentesProd().getCodCompprod()+
                                    " and p.COD_TIPO_PROGRAMA_PROD="+getProgramaProduccionIngresoAcond().getTiposProgramaProduccion().getCodTipoProgramaProd()+
                                    " and p.COD_PROGRAMA_PROD="+getProgramaProduccionIngresoAcond().getCodProgramaProduccion();
            LOGGER.debug("consulta verificar estado programa "+consulta);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta);
            res.next();
            if(res.getInt("COD_ESTADO_PROGRAMA") == COD_ESTADO_PROGRAMA_TERMINADO){
                this.mostrarMensajeTransaccionFallida("El lote ya se encuentra como terminado enviado");
                codEstadoPrograma = res.getInt("COD_ESTADO_PROGRAMA");
            }
        } 
        catch (SQLException ex){
            con.rollback();
            LOGGER.warn("error", ex);
        }
        finally{
            this.cerrarConexion(con);
        }
        if(codEstadoPrograma != COD_ESTADO_PROGRAMA_TERMINADO){
            ingresosAcond.getIngresosDetalleAcondList().get(0).setCantTotalIngreso(ingresosAcond.getIngresosDetalleAcondList().get(0).getCantIngresoProduccion());
            ingresosAcond.getIngresosDetalleAcondList().get(0).setCantRestante(ingresosAcond.getIngresosDetalleAcondList().get(0).getCantIngresoProduccion());
            DaoIngresosAcond daoIngresosAcond = new DaoIngresosAcond(LOGGER);
            if(daoIngresosAcond.guardar(ingresosAcond, "registro de ingreso desde programa de produccion"))
            {
                this.mostrarMensajeTransaccionExitosa("Termino de registrar correctamente con el numero de ingreso "+ingresosAcond.getNroIngresoAcond());
            }
            else{
                this.mostrarMensajeTransaccionFallida("Ocurrio un error al momento de registrar el ingreso,intente de nuevo");
            }
        }
        
        if(ingresosAcond.getProgramaProduccionIngresoAcond().getTiposEntregaAcond().getCodTipoEntregaAcond() == 2
                && transaccionExitosa){
            this.cargarProgramaProduccionList();
        }
        return null;
    }
    public String cargarDetalleEnvasesAcondicionamiento_action()
    {
        ingresosAcond.getIngresosDetalleAcondList().get(0).setListadoCantidadPeso(new ArrayList<>());
        int cantidadBolsasPorEnvase = ingresosAcond.getIngresosDetalleAcondList().get(0).getCantidadEnvase();
        int cantIngresoProduccion = ingresosAcond.getIngresosDetalleAcondList().get(0).getCantIngresoProduccion();
        int cantidadPorEnvase = cantIngresoProduccion/cantidadBolsasPorEnvase;
        Double pesoPorEnvase = ingresosAcond.getIngresosDetalleAcondList().get(0).getPesoProduccion()/cantidadBolsasPorEnvase;
        String nombreEnvase="";
        switch(Integer.valueOf(ingresosAcond.getIngresosDetalleAcondList().get(0).getTiposEnvase().getCodTipoEnvase()))
        {
            case 1:nombreEnvase="BOLSA";break;
            case 2:nombreEnvase="CAJA";break;
            case 3:nombreEnvase="TACHO";break;
        }
        for(int i=1;i<=cantidadBolsasPorEnvase;i++)
        {
            IngresosdetalleCantidadPeso nuevo=new IngresosdetalleCantidadPeso();
            nuevo.setCantidad(i==cantidadBolsasPorEnvase?cantIngresoProduccion:cantidadPorEnvase);
            cantIngresoProduccion-=cantidadPorEnvase;
            nuevo.setPeso(pesoPorEnvase);
            nuevo.setCodigo(i);
            nuevo.setNombreEnvase(nombreEnvase);
            nuevo.setCodEnvase(Integer.parseInt((ingresosAcond.getIngresosDetalleAcondList().get(0).getTiposEnvase().getCodTipoEnvase())));
            ingresosAcond.getIngresosDetalleAcondList().get(0).getListadoCantidadPeso().add(nuevo);
        }
        return null;
    }
    private void cargarTiposEnvaseSelectList()
    {
        DaoTiposEnvase daoEnvase = new DaoTiposEnvase(LOGGER);
        tiposEnvaseSelectList = daoEnvase.listarSelect();
    }

    public void cargarAlmacenAcondicionamientoSelectList(){
        DaoAlmacenesAcond daoAlmacenes = new DaoAlmacenesAcond(LOGGER);
        almacenAcondicionamientoList = daoAlmacenes.listarDestinoEnvioProduccionSelect();
    }
    public String terminarProductoManualmente_action()throws SQLException, MalformedURLException
    {
        LOGGER.debug("----------------------------INICIO TERMINAR PRODUCTO MANUALMENTE---------------------------");
        mensaje="";
        transaccionExitosa = false;
        int codDesviacion=0;
        try {
            con = Util.openConnection(con);
            StringBuilder consulta=new StringBuilder("select p.COD_ESTADO_PROGRAMA");
                                    consulta.append(" from PROGRAMA_PRODUCCION p ");
                                            consulta.append(" where p.COD_LOTE_PRODUCCION='").append(programaProduccionCabeceraEditar.getCodLoteProduccion()).append("'");
                                            consulta.append(" and p.COD_PROGRAMA_PROD=").append(programaProduccionCabeceraEditar.getCodProgramaProduccion());
                                            consulta.append(" and p.COD_TIPO_PROGRAMA_PROD=").append(programaProduccionCabeceraEditar.getTiposProgramaProduccion().getCodTipoProgramaProd());
                                            consulta.append(" and p.COD_COMPPROD=").append(programaProduccionCabeceraEditar.getFormulaMaestra().getComponentesProd().getCodCompprod());
            LOGGER.debug("consulta verificar estado programa produccion "+consulta.toString());
            Statement st =con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta.toString());
            res.next();
            if(res.getInt("COD_ESTADO_PROGRAMA")==7)
            {
                con.setAutoCommit(false);
                consulta=new StringBuilder("update PROGRAMA_PRODUCCION");
                            consulta.append(" set COD_ESTADO_PROGRAMA=6,");
                                    consulta.append(" OBSERVACION=cast(OBSERVACION as varchar(400))+' Cambio de estado a terminado/enviado manualmente'");
                            consulta.append(" where COD_LOTE_PRODUCCION=?");
                                    consulta.append(" and COD_PROGRAMA_PROD=").append(programaProduccionCabeceraEditar.getCodProgramaProduccion());
                                    consulta.append(" and COD_TIPO_PROGRAMA_PROD=").append(programaProduccionCabeceraEditar.getTiposProgramaProduccion().getCodTipoProgramaProd());
                                    consulta.append(" and COD_COMPPROD=").append(programaProduccionCabeceraEditar.getFormulaMaestra().getComponentesProd().getCodCompprod());
                LOGGER.debug("consulta cerrar manualmente programa produiccion "+consulta.toString());
                PreparedStatement pst=con.prepareStatement(consulta.toString());
                pst.setString(1,programaProduccionCabeceraEditar.getCodLoteProduccion());LOGGER.info("p1: "+programaProduccionCabeceraEditar.getCodLoteProduccion());
                if(pst.executeUpdate()>0)LOGGER.info("se cambio de estado el lote ");
                consulta=new StringBuilder("select top 1 p.COD_INGRESO_ACOND");
                                        consulta.append(" from PROGRAMA_PRODUCCION_INGRESOS_ACOND p");
                                        consulta.append(" where p.COD_LOTE_PRODUCCION=?");
                                                consulta.append(" and p.COD_PROGRAMA_PROD='").append(programaProduccionCabeceraEditar.getCodProgramaProduccion()).append("'");
                                                consulta.append(" and p.COD_TIPO_PROGRAMA_PROD='").append(programaProduccionCabeceraEditar.getTiposProgramaProduccion().getCodTipoProgramaProd()).append("'");
                                                consulta.append(" and p.COD_COMPPROD='").append(programaProduccionCabeceraEditar.getFormulaMaestra().getComponentesProd().getCodCompprod()).append("'");
                                        consulta.append("order by p.COD_INGRESO_ACOND desc");
                LOGGER.debug("consulta obtener ultima entrega de produccion a acondicionamiento "+consulta.toString());
                pst=con.prepareStatement(consulta.toString());
                pst.setString(1,programaProduccionCabeceraEditar.getCodLoteProduccion());
                res=pst.executeQuery();
                int codIngresoAcond=0;
                if(res.next())codIngresoAcond=res.getInt("COD_INGRESO_ACOND");
                consulta=new StringBuilder(" update PROGRAMA_PRODUCCION_INGRESOS_ACOND");
                            consulta.append(" set COD_TIPO_ENTREGA_ACOND=2");
                            consulta.append(" where COD_INGRESO_ACOND=").append(codIngresoAcond);
                LOGGER.debug("consulta actualizar tipo envio "+consulta.toString());
                pst=con.prepareStatement(consulta.toString());
                if(pst.executeUpdate()>0)LOGGER.info(" se cambio el tipo de envio ");
                consulta=new StringBuilder("update INGRESOS_ACOND ");
                            consulta.append(" set OBS_INGRESOACOND=cast(OBS_INGRESOACOND as varchar)+' , cambiado a entrega total por cambio de estado a terminado enviado en el programa de produccion'");
                            consulta.append(" where COD_INGRESO_ACOND=").append(codIngresoAcond);
                LOGGER.debug("consulta registrar observacion ingreso "+consulta.toString());
                pst=con.prepareStatement(consulta.toString());
                if(pst.executeUpdate()>0)LOGGER.info(" se actualizo la observacion  ");
                consulta=new StringBuilder(" exec PAA_GENERACION_DESVIACION_BAJO_RENDIMIENTO_LOTE ");
                            consulta.append("'").append(programaProduccionCabeceraEditar.getCodLoteProduccion()).append("'");
                            consulta.append(",?");
                LOGGER.debug("consulta registrar desviacion bajo rendimiento si procede "+consulta.toString());
                CallableStatement callDesviacionBajoRendimiento=con.prepareCall(consulta.toString());
                callDesviacionBajoRendimiento.registerOutParameter(1,java.sql.Types.INTEGER);
                callDesviacionBajoRendimiento.execute();
                codDesviacion=callDesviacionBajoRendimiento.getInt(1);
                
                // <editor-fold defaultstate="collapsed" desc="registro de log de transacciones">

                    ManagedAccesoSistema usuarioModificacion = (ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
                    consulta=new StringBuilder("exec PAA_REGISTRO_PROGRAMA_PRODUCCION_LOG ?,?,?,1,0");
                    LOGGER.debug("consulta guardar registro transacciones "+consulta.toString());
                    pst=con.prepareStatement(consulta.toString());
                    pst.setString(1, programaProduccionCabeceraEditar.getCodLoteProduccion());LOGGER.info("p1:"+programaProduccionCabeceraEditar.getCodLoteProduccion());
                    pst.setInt(2,Integer.valueOf(programaProduccionCabeceraEditar.getCodProgramaProduccion()));LOGGER.info("p2:"+programaProduccionCabeceraEditar.getCodProgramaProduccion());
                    pst.setInt(3,Integer.valueOf(usuarioModificacion.getUsuarioModuloBean().getCodUsuarioGlobal()));LOGGER.info("p3:"+usuarioModificacion.getUsuarioModuloBean().getCodUsuarioGlobal());
                    if(pst.executeUpdate()>0)LOGGER.debug("se registro el log de edicion de lote");
                //</editor-fold>
                con.commit();
                this.mostrarMensajeTransaccionExitosa("Se registro satisfactoriamente la terminación del lote selccionado");
            }
            
            else
            {
                this.mostrarMensajeTransaccionFallida("No se puede terminar el lote porque no se encuentra en estado: EN PROCESO");
            }
        } catch (SQLException ex) {
            this.mostrarMensajeTransaccionFallida("Ocurrio un error al momento de guardar el registro");
            LOGGER.warn(ex.getMessage());
            con.rollback();
        } catch (Exception ex) {
            this.mostrarMensajeTransaccionFallida("Ocurrio un error al momento de guardar el registro,verifique los datos introducidos");
            LOGGER.warn(ex.getMessage());
        } finally {
            this.cerrarConexion(con);
        }
        LOGGER.debug("----------------------------TERMINO TERMINAR PRODUCTO MANUALMENTE---------------------------");
        if(transaccionExitosa)
        {
            this.cargarProgramaProduccionList();
        }
        if(codDesviacion>0)
        {
            EnvioCorreoDesviacionBajoRendimiento correoBajoRendimiento=new EnvioCorreoDesviacionBajoRendimiento(codDesviacion,(ServletContext)FacesContext.getCurrentInstance().getExternalContext().getContext());
            correoBajoRendimiento.start();
        }
        return null;
    }
    
    public String terminarProductoAction()
    {
        mensaje="";
        transaccionExitosa = false;
        EnvioCorreoAcondicionamientoSinFechasDePesaje envioCorreo=null;
        try
        { 
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            StringBuilder consulta = new StringBuilder("select count(*) as contador")
                                                .append(" from SALIDAS_ALMACEN sa inner join SALIDAS_ALMACEN_DETALLE sad on sad.COD_SALIDA_ALMACEN=sa.COD_SALIDA_ALMACEN")
                                                        .append(" inner join materiales m on m.COD_MATERIAL=sad.COD_MATERIAL")
                                                        .append(" inner join grupos g on g.COD_GRUPO=m.COD_GRUPO" )
                                                .append(" where sa.COD_LOTE_PRODUCCION='").append(programaProduccionIngresoAcond.getCodLoteProduccion()).append("'")
                                                        .append(" and sa.COD_ESTADO_SALIDA_ALMACEN=1")
                                                        .append(" and sa.COD_ALMACEN=1")
                                                        .append(" and g.COD_CAPITULO=2");
            LOGGER.debug("consulta verificar salidas de material prima "+consulta);
            ResultSet res;
            /*= st.executeQuery(consulta.toString());
            res.next();
            //if(res.getInt("contador")==0)mensaje="El lote no tiene registros de salidas de materia prima";*/
            consulta = new StringBuilder("select count(*) as contador")
                            .append(" from SALIDAS_ALMACEN sa inner join SALIDAS_ALMACEN_DETALLE sad on sad.COD_SALIDA_ALMACEN=sa.COD_SALIDA_ALMACEN" )
                                    .append(" inner join materiales m on m.COD_MATERIAL=sad.COD_MATERIAL" )
                                    .append(" inner join grupos g on g.COD_GRUPO=m.COD_GRUPO" )
                            .append(" where sa.COD_LOTE_PRODUCCION='").append(programaProduccionIngresoAcond.getCodLoteProduccion()).append("' and sa.COD_ESTADO_SALIDA_ALMACEN=1 and sa.COD_ALMACEN=1 and g.COD_CAPITULO=3");
            LOGGER.debug("consulta verificar salidas de empaque primario "+consulta.toString());
            res=st.executeQuery(consulta.toString());
            res.next();
            //if(res.getInt("contador")==0)mensaje=(mensaje.equals("")?"El lote no tiene registros de salidas de empaque primario en el sistema de ALMACENES":mensaje+" y empaque primario");
            //verificar si ya se presento algun inconveniente
            consulta=new StringBuilder(" select p.COD_ESTADO_PROGRAMA from PROGRAMA_PRODUCCION p")
                        .append(" where p.COD_LOTE_PRODUCCION='").append(programaProduccionIngresoAcond.getCodLoteProduccion()+"'")
                                .append(" and p.COD_COMPPROD=").append(programaProduccionIngresoAcond.getFormulaMaestra().getComponentesProd().getCodCompprod())
                                .append(" and p.COD_TIPO_PROGRAMA_PROD=").append(programaProduccionIngresoAcond.getTiposProgramaProduccion().getCodTipoProgramaProd())
                                .append(" and p.COD_PROGRAMA_PROD=").append(programaProduccionIngresoAcond.getCodProgramaProduccion());
            LOGGER.debug("consulta verificar estado programa "+consulta.toString());
            res=st.executeQuery(consulta.toString());
            res.next();
            if(res.getInt("COD_ESTADO_PROGRAMA")==6){
                mensaje = "El lote ya se encuentra como terminado enviado";
                this.mostrarMensajeTransaccionFallida("El lote ya se encuentra como terminado enviado");
            }
            else{
                ingresosAcond = new IngresosAcond();
                ingresosAcond.setIngresosDetalleAcondList(new ArrayList<>());
                ingresosAcond.getIngresosDetalleAcondList().add(new IngresosDetalleAcond());
                consulta=new StringBuilder(" exec PAA_LISTAR_FECHA_VENCIMIENTO_LOTE")
                                        .append("'").append(programaProduccionIngresoAcond.getCodLoteProduccion()).append("',")
                                        .append(programaProduccionIngresoAcond.getCodProgramaProduccion()).append(",")
                                        .append(programaProduccionIngresoAcond.getFormulaMaestra().getComponentesProd().getCodCompprod()).append(",")
                                        .append(programaProduccionIngresoAcond.getFormulaMaestra().getComponentesProd().getForma().getCodForma()).append(",")
                                        .append("?,")//mensaje
                                        .append("?,")//fecha vencimiento
                                        .append("?");//fecha pesaje
                LOGGER.debug("consulta obtener vida util producto "+consulta.toString());
                CallableStatement callVersionCopia=con.prepareCall(consulta.toString());
                callVersionCopia.registerOutParameter(1,java.sql.Types.VARCHAR);
                callVersionCopia.registerOutParameter(2,java.sql.Types.TIMESTAMP);
                callVersionCopia.registerOutParameter(3,java.sql.Types.TIMESTAMP);
                callVersionCopia.execute();
                if(callVersionCopia.getString(1).length()>0)
                {
                    this.mostrarMensajeTransaccionFallida(callVersionCopia.getString(1));
                    mensaje = callVersionCopia.getString(1);
                    if(callVersionCopia.getTimestamp(3)==null)
                    {
                        envioCorreo=new EnvioCorreoAcondicionamientoSinFechasDePesaje(programaProduccionIngresoAcond);
                    }
                }
                else
                {
                    ingresosAcond.getIngresosDetalleAcondList().get(0).setFechaVencimiento(callVersionCopia.getTimestamp(2));
                    ingresosAcond.getIngresosDetalleAcondList().get(0).setFechaPesaje(callVersionCopia.getTimestamp(3));
                    DaoIngresosAcond daoIngresosAcond = new DaoIngresosAcond(LOGGER);
                    ingresosDetalleAcondRegistradosList = daoIngresosAcond.listarPorProgramaProduccion(programaProduccionIngresoAcond);
                    int cantidadIngresadaAcond = 0;
                    for(IngresosAcond nuevo :  ingresosDetalleAcondRegistradosList){
                        cantidadIngresadaAcond +=  nuevo.getIngresosDetalleAcondList().get(0).getCantTotalIngreso();
                    }
                    
                    consulta=new StringBuilder("select a.COD_ALMACENACOND")
                                    .append(" from ALMACENES_ACOND a")
                                    .append(" where a.COD_TIPO_PROGRAMA_PROD =").append(programaProduccionIngresoAcond.getTiposProgramaProduccion().getCodTipoProgramaProd());
                    LOGGER.debug("consulta buscar almacen de acondicionamiento "+consulta.toString());
                    res=st.executeQuery(consulta.toString());
                    if(res.next())ingresosAcond.getAlmacenAcond().setCodAlmacenAcond(res.getInt("COD_ALMACENACOND"));
                    consulta=new StringBuilder("SELECT TINGRESO.COD_TIPOINGRESOACOND,TINGRESO.NOMBRE_TIPOINGRESOACOND ")
                                        .append(" FROM TIPOS_INGRESOACOND TINGRESO ")
                                        .append(" WHERE TINGRESO.COD_TIPOINGRESOACOND = 1");
                    System.out.println("consulta tipo ingreso"+consulta.toString());
                    res=st.executeQuery(consulta.toString());
                    if(res.next())ingresosAcond.getTipoIngresoAcond().setNombreTipoIngresoAcond(res.getString("NOMBRE_TIPOINGRESOACOND"));

                    ingresosAcond.getIngresosDetalleAcondList().get(0).setComponentesProd((ComponentesProd)programaProduccionIngresoAcond.getFormulaMaestra().getComponentesProd().clone());
                    ingresosAcond.getIngresosDetalleAcondList().get(0).setCodLoteProduccion(programaProduccionIngresoAcond.getCodLoteProduccion());
                    if((programaProduccionIngresoAcond.getCantidadLote() - cantidadIngresadaAcond)>0)
                    {
                        ingresosAcond.getIngresosDetalleAcondList().get(0).setCantIngresoProduccion(((int)programaProduccionIngresoAcond.getCantidadLote())-cantidadIngresadaAcond);
                    }
                    ingresosAcond.getIngresosDetalleAcondList().get(0).setPesoProduccion(0d);
                    ingresosAcond.getIngresosDetalleAcondList().get(0).setCantidadAproximado(0);
                    ingresosAcond.getIngresosDetalleAcondList().get(0).setCantidadEnvase(0);
                    ingresosAcond.getIngresosDetalleAcondList().get(0).getTiposEnvase().setCodTipoEnvase("1");
                    ingresosAcond.setProgramaProduccionIngresoAcond(new ProgramaProduccionIngresoAcond());
                    ingresosAcond.getProgramaProduccionIngresoAcond().setProgramaProduccion(programaProduccionIngresoAcond);
                    ingresosAcond.getProgramaProduccionIngresoAcond().getTiposEntregaAcond().setCodTipoEntregaAcond(1);
                    if(mensaje.equals(""))mensaje="1";

                }
            }
            res.close();
            st.close();
            con.close();
        } 
        catch (SQLException ex) {
            mensaje = "Ocurrio un error al momento de cargar el envio de producto, intente de nuevo";
            this.mostrarMensajeTransaccionFallida("Ocurrio un error al momento de cargar el envio de producto, intente de nuevo");
            LOGGER.warn("error", ex);
        }
        if(!transaccionExitosa&&envioCorreo!=null)
        {
            envioCorreo.start();
        }
        System.out.println("mensaje: "+mensaje);
        this.cargarAlmacenAcondicionamientoSelectList();
        this.cargarTiposEnvaseSelectList();
        cantidadEnvaseSelectList.clear();
        for(int i=1;i<=50;i++)cantidadEnvaseSelectList.add(new SelectItem(String.valueOf(i),String.valueOf(i)));
        return null;
    }
    public ProgramaProduccionPeriodo getProgramaProduccionPeriodoBean() {
        return programaProduccionPeriodoBean;
    }

    public void setProgramaProduccionPeriodoBean(ProgramaProduccionPeriodo programaProduccionPeriodoBean) {
        this.programaProduccionPeriodoBean = programaProduccionPeriodoBean;
    }

    
    public List<ProductosDivisionLotes> getProductosDivisionLotesList() {
        return productosDivisionLotesList;
    }

    public void setProductosDivisionLotesList(List<ProductosDivisionLotes> productosDivisionLotesList) {
        this.productosDivisionLotesList = productosDivisionLotesList;
        
    }

    
    public List<ProgramaProduccionPeriodo> getProgramaProduccionPeriodoList() {
        return programaProduccionPeriodoList;
    }

    public void setProgramaProduccionPeriodoList(List<ProgramaProduccionPeriodo> programaProduccionPeriodoList) {
        this.programaProduccionPeriodoList = programaProduccionPeriodoList;
    }

    public HtmlDataTable getProgramaProduccionPeriodoDataTable() {
        return programaProduccionPeriodoDataTable;
    }

    public void setProgramaProduccionPeriodoDataTable(HtmlDataTable programaProduccionPeriodoDataTable) {
        this.programaProduccionPeriodoDataTable = programaProduccionPeriodoDataTable;
    }

    public ProgramaProduccionPeriodo getProgramaProduccionPeriodoAgregar() {
        return programaProduccionPeriodoAgregar;
    }

    public void setProgramaProduccionPeriodoAgregar(ProgramaProduccionPeriodo programaProduccionPeriodoAgregar) {
        this.programaProduccionPeriodoAgregar = programaProduccionPeriodoAgregar;
    }

    public ProgramaProduccionPeriodo getProgramaProduccionPeriodoEditar() {
        return programaProduccionPeriodoEditar;
    }

    public void setProgramaProduccionPeriodoEditar(ProgramaProduccionPeriodo programaProduccionPeriodoEditar) {
        this.programaProduccionPeriodoEditar = programaProduccionPeriodoEditar;
    }

    public List<FormulaMaestraVersion> getFormulaMaestraVersionAgregarList() {
        return formulaMaestraVersionAgregarList;
    }

    public void setFormulaMaestraVersionAgregarList(List<FormulaMaestraVersion> formulaMaestraVersionAgregarList) {
        this.formulaMaestraVersionAgregarList = formulaMaestraVersionAgregarList;
    }

    public HtmlDataTable getFormulaMaestraVersionAgregarDataTable() {
        return formulaMaestraVersionAgregarDataTable;
    }

    public void setFormulaMaestraVersionAgregarDataTable(HtmlDataTable formulaMaestraVersionAgregarDataTable) {
        this.formulaMaestraVersionAgregarDataTable = formulaMaestraVersionAgregarDataTable;
    }

    public ProgramaProduccion getProgramaProduccionCabecera() {
        return programaProduccionCabecera;
    }

    public void setProgramaProduccionCabecera(ProgramaProduccion programaProduccionCabecera) {
        this.programaProduccionCabecera = programaProduccionCabecera;
    }

    public List<SelectItem> getTiposProgramaProduccionSelectList() {
        return tiposProgramaProduccionSelectList;
    }

    public void setTiposProgramaProduccionSelectList(List<SelectItem> tiposProgramaProduccionSelectList) {
        this.tiposProgramaProduccionSelectList = tiposProgramaProduccionSelectList;
    }

    public ProgramaProduccion getProgramaProduccionCabeceraEditar() {
        return programaProduccionCabeceraEditar;
    }

    public void setProgramaProduccionCabeceraEditar(ProgramaProduccion programaProduccionCabeceraEditar) {
        this.programaProduccionCabeceraEditar = programaProduccionCabeceraEditar;
    }

    /**
     * @return the programaProduccionIngresoAcond
     */
    public ProgramaProduccion getProgramaProduccionIngresoAcond() {
        return programaProduccionIngresoAcond;
    }

    /**
     * @param programaProduccionIngresoAcond the programaProduccionIngresoAcond to set
     */
    public void setProgramaProduccionIngresoAcond(ProgramaProduccion programaProduccionIngresoAcond) {
        this.programaProduccionIngresoAcond = programaProduccionIngresoAcond;
    }

    
    
//final cambios ale
    public class ActividadesProgramaProduccionFaltantes{
        private String codActividad="";
        private String nombreActividad="";
        private List<SeguimientoProgramaProduccion> seguimientoProgramaProduccionList = new ArrayList<SeguimientoProgramaProduccion>();
        private String ordenActividad="";
        

        public String getCodActividad() {
            return codActividad;
        }

        public void setCodActividad(String codActividad) {
            this.codActividad = codActividad;
        }

        public String getNombreActividad() {
            return nombreActividad;
        }

        public void setNombreActividad(String nombreActividad) {
            this.nombreActividad = nombreActividad;
        }

        public List<SeguimientoProgramaProduccion> getSeguimientoProgramaProduccionList() {
            return seguimientoProgramaProduccionList;
        }

        public void setSeguimientoProgramaProduccionList(List<SeguimientoProgramaProduccion> seguimientoProgramaProduccionList) {
            this.seguimientoProgramaProduccionList = seguimientoProgramaProduccionList;
        }

        public String getOrdenActividad() {
            return ordenActividad;
        }

        public void setOrdenActividad(String ordenActividad) {
            this.ordenActividad = ordenActividad;
        }


    }
    public class ComponentesProdFormulaMaestra{
        ComponentesProd componentesProd = new ComponentesProd();
        FormulaMaestra formulaMaestra = new FormulaMaestra();

        public ComponentesProd getComponentesProd() {
            return componentesProd;
        }

        public void setComponentesProd(ComponentesProd componentesProd) {
            this.componentesProd = componentesProd;
        }

        public FormulaMaestra getFormulaMaestra() {
            return formulaMaestra;
        }

        public void setFormulaMaestra(FormulaMaestra formulaMaestra) {
            this.formulaMaestra = formulaMaestra;
        }        
    }
    

    /** Creates a new instance of ManagedTipoCliente */
    private ProgramaProduccion programaProduccionbean=new ProgramaProduccion();

    
    private List programaProduccionEliminarList=new ArrayList();
    private List programaProduccionNoEliminarList=new ArrayList();
    //private List programaProduccionEditarList=new ArrayList();
    
    private String codigo="";
    private boolean swEliminaSi;
    private boolean swEliminaNo;
    
    private List empaquePrimarioList=new ArrayList();
    private List empaqueSecundarioList=new ArrayList();
    private String nombreFromulaMaestra="";
    private String codFormulaMaestra="";
    private String cantidadLote="";
    private String codPresPrim="";
    private String codPresProd="";
    private String codProgramaProd="0";
    private String cod_comp_prod="";
    private String cod_lote="";
    private List tiposProgramaProdList = new ArrayList();
    private String codReserva="0";
    private List<ActividadesProgramaProduccionFaltantes>  actividadesProgramaProduccionList = new ArrayList<ActividadesProgramaProduccionFaltantes>();
    private List<ActividadesProgramaProduccionFaltantes>  seguimientoProgramaProduccionList = new ArrayList<ActividadesProgramaProduccionFaltantes>();
    private String mensajes="";
    private ProgramaProduccion programaProduccionActividadesPendientes=new ProgramaProduccion();
    private List areaProgramaProduccionList=new ArrayList();
    private String codAreaProgramaProduccion = "";
    private Date fechaLote =new Date();
    private IngresosAcond ingresosAcondicionamiento = new IngresosAcond();    
    private List almacenAcondicionamientoList=new ArrayList();
    private List<IngresosDetalleAcond> ingresosAlmacenDetalleAcondList = new ArrayList<IngresosDetalleAcond>();
    private List<IngresosdetalleCantidadPeso> cantidadesBolsasList=new ArrayList<IngresosdetalleCantidadPeso>();
    private HtmlDataTable ingresosAlmacenDetalleAcondDataTable = new HtmlDataTable();
    private List cantidadEnvaseList = new ArrayList();
    private HtmlDataTable programaProduccionDataTable = new HtmlDataTable();
    private HtmlDataTable programaProduccionSeguimientoDataTable = new HtmlDataTable();
    private ProgramaProduccion programaProduccionSeleccionado = new ProgramaProduccion();
    private List componentesProdFormulaMaestraList = new ArrayList();
    private ComponentesProd componentesProdBuscar = new ComponentesProd();
    private HtmlDataTable componentesProdFormulaMaestraDataTable = new HtmlDataTable();
    String codTipoProgramaProd = "";
    List programaProduccionLotesList = new ArrayList();
    HtmlDataTable programaProduccionLotesDataTable = new HtmlDataTable();
    List programaProduccionProductosList = new ArrayList();
    

    HtmlDataTable programaProduccionAgregarDataTable = new HtmlDataTable();
    ManagedAccesoSistema usuario = (ManagedAccesoSistema) Util.getSessionBean("ManagedAccesoSistema");
    //seguimiento programa produccion
    ProgramaProduccion programaProduccionSeguimientoBuscar = new ProgramaProduccion();
    private HtmlDataTable programaProduccionPeriodoSeguimientoDataTable=new HtmlDataTable();
    private List<ProgramaProduccion> programaProduccionSeguimientoList=new ArrayList<ProgramaProduccion>();
    
    //inicio alejandro
    private String codAreaActividadProd="";
    private List<SelectItem> listaAreasActividad= new ArrayList<SelectItem>();
    private List<SeguimientoProgramaProduccionIndirecto> listaSeguimientoIndirecto=new ArrayList<SeguimientoProgramaProduccionIndirecto>();
    private SeguimientoProgramaProduccionIndirecto seguimientoIndirecto= new SeguimientoProgramaProduccionIndirecto();
    private HtmlDataTable seguimientoIndirectoDataTable = new HtmlDataTable();
    private List<SeguimientoProgramaProduccionIndirectoPersonal> listaSeguimientoPersonal= new ArrayList<SeguimientoProgramaProduccionIndirectoPersonal>();
    private SeguimientoProgramaProduccionIndirectoPersonal seguimientoIndirectoPersonal= new SeguimientoProgramaProduccionIndirectoPersonal();
    private List<SelectItem> listaPersonal= new ArrayList<SelectItem>();
    private HtmlDataTable seguimientoIndirectoPersonalDataTable=new HtmlDataTable();
    //inicio ale devoluciones
    private List<ProgramaProduccionDevolucionMaterialDetalle> devolucionesMaterialDetalleList=new ArrayList<ProgramaProduccionDevolucionMaterialDetalle>();
        //final ale devoluciones
    private List<SelectItem> componentesProdList= new ArrayList<SelectItem>();
    private ProgramaProduccion currentProgramaProd= new ProgramaProduccion();
    private HtmlDataTable programaProduccionEditarDataTable= new HtmlDataTable();
    private String loteDivisible="0";
    private List<SelectItem> productosDivisiblesList=new ArrayList<SelectItem>();
    private ProgramaProduccion programaProduccionEditar=new ProgramaProduccion();
    private List<SelectItem> productosDivisiblesAgregarList= new ArrayList<SelectItem>();
    private String mensajeSolicitudAutomatica="";
    private ProgramaProduccionPeriodo programaProduccionPeriodoIndirectas=new ProgramaProduccionPeriodo();
    private double cantidadProductosPorCaja = 0;
    private List cpVersionesList = new ArrayList();
    private List fmVersionesList = new ArrayList();
    private String unidades = "";
    public SeguimientoProgramaProduccionIndirectoPersonal getSeguimientoIndirectoPersonal() {
        return seguimientoIndirectoPersonal;
    }

    public void setSeguimientoIndirectoPersonal(SeguimientoProgramaProduccionIndirectoPersonal seguimientoIndirectoPersonal) {
        this.seguimientoIndirectoPersonal = seguimientoIndirectoPersonal;
    }
    //final alejandro
    

    public ManagedProgramaProduccion() {
        LOGGER=LogManager.getRootLogger();
        //cargarProgramaProduccion();
        
    }
    public String getCloseConnection() throws SQLException{
        if(getCon()!=null){
            getCon().close();
        }
        return "";
    }
    
   
    private FormulaMaestra formulaMaestraSeleccionada()
   {
       FormulaMaestra nuevaFormula= new FormulaMaestra();
       try
       {
           Connection con1=null;
           con1=Util.openConnection(con1);
           String consulta="select fm.CANTIDAD_LOTE,cp.COD_COMPPROD,cp.nombre_prod_semiterminado,fm.COD_FORMULA_MAESTRA"+
                            " from FORMULA_MAESTRA fm inner join COMPONENTES_PROD cp on"+
                            " fm.COD_COMPPROD=cp.COD_COMPPROD where fm.COD_FORMULA_MAESTRA='"+programaProduccionbean.getFormulaMaestra().getCodFormulaMaestra()+"'";
            System.out.println("consulta cargar detalle  form maest "+consulta);
           Statement st=con1.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
           ResultSet res=st.executeQuery(consulta);
           if(res.next())
           {
               nuevaFormula.setCodFormulaMaestra(res.getString("COD_FORMULA_MAESTRA"));
               nuevaFormula.getComponentesProd().setNombreProdSemiterminado(res.getString("nombre_prod_semiterminado"));
               nuevaFormula.getComponentesProd().setCodCompprod(res.getString("COD_COMPPROD"));
               nuevaFormula.setCantidadLote(res.getDouble("CANTIDAD_LOTE"));
           }
           res.close();
           st.close();
           con1.close();
       }
       catch(SQLException ex)
       {
           ex.printStackTrace();
       }
       return nuevaFormula;
   }
    private ProgramaProduccion nuevoProgramaProduccion()
    {
        ProgramaProduccion nuevo= new ProgramaProduccion();
        nuevo.setFormulaMaestra(this.formulaMaestraSeleccionada());
        nuevo.setProductosList(this.cargarProductosParaDivisionEdicionList1(
                nuevo.getFormulaMaestra().getCodFormulaMaestra(),
                nuevo.getFormulaMaestra().getComponentesProd().getNombreProdSemiterminado(),"1",nuevo.getFormulaMaestra().getCantidadLote(),programaProduccionbean));
        nuevo.getTiposProgramaProduccion().setCodTipoProgramaProd("1");
        double cantidadRegistrar=0d;
        if(programaProduccionAgregarList.size()>0)
        {
            Iterator e= programaProduccionAgregarList.iterator();
            while(e.hasNext())
            {
                ProgramaProduccion current=(ProgramaProduccion)e.next();
                cantidadRegistrar+=current.getCantidadLote();
            }
            cantidadRegistrar=(nuevo.getFormulaMaestra().getCantidadLote()-cantidadRegistrar);
        }
        else
        {
            cantidadRegistrar=nuevo.getFormulaMaestra().getCantidadLote();
        }
        nuevo.setCantidadLote(cantidadRegistrar);
        nuevo.setPresentacionesProductoList(this.cargarPresentacionesProducto(nuevo));
        return nuevo;
    }
    
    public String limpiar_action(){
        programaProduccionAgregarList.clear();
        programaProduccionCabecera=new ProgramaProduccion();
        return null;
    }
    

public void cargaAreas(){
    try {
        String consulta=" SELECT AE.COD_AREA_EMPRESA,AE.NOMBRE_AREA_EMPRESA FROM AREAS_EMPRESA AE WHERE AE.COD_AREA_EMPRESA IN (SELECT CP.COD_AREA_EMPRESA FROM COMPONENTES_PROD CP) " ;
        
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(consulta);
            empaquePrimarioList.clear();
            empaquePrimarioList.add(new SelectItem("0","Seleccione Una Opción"));
            while(rs.next()){
                String codAreaEmpresa=rs.getString("COD_AREA_EMPRESA");
                String nombreAreaEmpresa=rs.getString("NOMBRE_AREA_EMPRESA");
                areaProgramaProduccionList.add(new SelectItem(codAreaEmpresa,nombreAreaEmpresa));
            }

    } catch (Exception e) {
        e.printStackTrace();
    }

}

public String cargarProgramaProduccionLotes(){
        try {
            codProgramaProd = Util.getParameter("codProgramaProd")!=null?Util.getParameter("codProgramaProd"):codProgramaProd;

            String consulta = " select distinct ppr.COD_PROGRAMA_PROD,ppr.COD_COMPPROD,cast(ppr.COD_LOTE_PRODUCCION as int) COD_LOTE_PRODUCCION,cp.nombre_prod_semiterminado,eppr.NOMBRE_ESTADO_PROGRAMA_PROD, " +
                    "   ISNULL((  SELECT C.NOMBRE_CATEGORIACOMPPROD  FROM CATEGORIAS_COMPPROD C WHERE C.COD_CATEGORIACOMPPROD = cp.COD_CATEGORIACOMPPROD ), '') NOMBRE_CATEGORIACOMPPROD," +
                    " ppr.cod_formula_maestra " +
                    " from PROGRAMA_PRODUCCION ppr  " +
                    " inner join COMPONENTES_PROD cp on cp.COD_COMPPROD = ppr.COD_COMPPROD " +
                    " inner join ESTADOS_PROGRAMA_PRODUCCION eppr on eppr.COD_ESTADO_PROGRAMA_PROD = ppr.COD_ESTADO_PROGRAMA " +
                    " where ppr.COD_PROGRAMA_PROD = '"+codProgramaProd+"'  " +
                    " order by cast(ppr.COD_LOTE_PRODUCCION as int),cp.nombre_prod_semiterminado asc  ";

            consulta = " select ppr.COD_PROGRAMA_PROD, ppr.COD_COMPPROD,COD_LOTE_PRODUCCION," +
                    "  cp.nombre_prod_semiterminado,  ppr.cod_formula_maestra," +
                    " count(ppr.COD_PROGRAMA_PROD) NRO_PRODUCTOS, sum(ppr.CANT_LOTE_PRODUCCION) TOTAL_CANTIDAD, fm.CANTIDAD_LOTE," +
                    " ISNULL(( SELECT C.NOMBRE_CATEGORIACOMPPROD FROM CATEGORIAS_COMPPROD C WHERE C.COD_CATEGORIACOMPPROD = cp.COD_CATEGORIACOMPPROD ), '') NOMBRE_CATEGORIACOMPPROD " +
                    " from PROGRAMA_PRODUCCION ppr " +
                    " inner join COMPONENTES_PROD cp on cp.COD_COMPPROD = ppr.COD_COMPPROD " +
                    " inner join ESTADOS_PROGRAMA_PRODUCCION eppr on eppr.COD_ESTADO_PROGRAMA_PROD = ppr.COD_ESTADO_PROGRAMA      " +
                    " inner join FORMULA_MAESTRA fm on fm.COD_COMPPROD = cp.COD_COMPPROD " +
                    " where ppr.COD_PROGRAMA_PROD = '"+codProgramaProd+"' " +
                    " group by ppr.COD_PROGRAMA_PROD, ppr.COD_COMPPROD, " +
                    " ppr.COD_LOTE_PRODUCCION,cp.nombre_prod_semiterminado,ppr.cod_formula_maestra," +
                    " fm.CANTIDAD_LOTE, cp.COD_CATEGORIACOMPPROD " +
                    " order by ppr.COD_LOTE_PRODUCCION,  cp.nombre_prod_semiterminado asc ";

            System.out.println("consulta " + consulta);
            setCon(Util.openConnection(getCon()));
            Statement st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(consulta);
            programaProduccionLotesList.clear();
            ProgramaProduccion programaProduccionItem = new ProgramaProduccion();
            while(rs.next()){
                programaProduccionItem = new ProgramaProduccion();
                programaProduccionItem.setCodProgramaProduccion(rs.getString("COD_PROGRAMA_PROD"));
                programaProduccionItem.getFormulaMaestra().getComponentesProd().setCodCompprod(rs.getString("COD_COMPPROD"));
                programaProduccionItem.setCodLoteProduccion(rs.getString("COD_LOTE_PRODUCCION"));
                programaProduccionItem.getFormulaMaestra().getComponentesProd().setNombreProdSemiterminado(rs.getString("nombre_prod_semiterminado"));                
                programaProduccionItem.getFormulaMaestra().getComponentesProd().getCategoriasCompProd().setNombreCategoriaCompProd(rs.getString("NOMBRE_CATEGORIACOMPPROD"));
                programaProduccionItem.getFormulaMaestra().setCodFormulaMaestra(rs.getString("cod_formula_maestra"));
                programaProduccionItem.setNroCompProd(rs.getInt("NRO_PRODUCTOS"));
                programaProduccionItem.setTotalCantidadLote(rs.getDouble("TOTAL_CANTIDAD"));
                programaProduccionItem.getFormulaMaestra().setCantidadLote(rs.getDouble("CANTIDAD_LOTE"));
                programaProduccionLotesList.add(programaProduccionItem);
            }
            programaProduccionItem = new ProgramaProduccion();
            programaProduccionItem.getFormulaMaestra().getComponentesProd().setNombreProdSemiterminado("NINGUNO");
            programaProduccionLotesList.add(programaProduccionItem);

            rs.close();
            st.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }


//public void areaProduccion_changed(ValueChangeEvent event){
//
//        try {
//            String sql="select pp.cod_programa_prod,fm.cod_formula_maestra,pp.cod_lote_produccion,";
//            sql+=" pp.fecha_inicio,pp.fecha_final,pp.cod_estado_programa,pp.observacion,";
//            sql+=" cp.nombre_prod_semiterminado,cp.cod_compprod,fm.cantidad_lote,epp.NOMBRE_ESTADO_PROGRAMA_PROD,pp.cant_lote_produccion,tp.COD_TIPO_PROGRAMA_PROD,tp.NOMBRE_TIPO_PROGRAMA_PROD";
//            sql+=" ,ISNULL((SELECT C.NOMBRE_CATEGORIACOMPPROD FROM CATEGORIAS_COMPPROD C WHERE C.COD_CATEGORIACOMPPROD=cp.COD_CATEGORIACOMPPROD),''),pp.MATERIAL_TRANSITO";
//            sql+=" from programa_produccion pp,formula_maestra fm,componentes_prod cp,ESTADOS_PROGRAMA_PRODUCCION epp,TIPOS_PROGRAMA_PRODUCCION tp";
//            sql+=" where pp.cod_formula_maestra=fm.cod_formula_maestra and cp.cod_compprod=fm.cod_compprod and epp.COD_ESTADO_PROGRAMA_PROD=pp.cod_estado_programa";
//            sql+=" and tp.COD_TIPO_PROGRAMA_PROD = pp.COD_TIPO_PROGRAMA_PROD and pp.cod_estado_programa in (2,5) " +
//                   " and cp.COD_AREA_EMPRESA =10 and pp.cod_programa_prod="+codProgramaProd;
//            sql+=" order by cp.nombre_prod_semiterminado";
//
//            System.out.println("sql navegador:"+sql);
//
//            setCon(Util.openConnection(getCon()));
//            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
//            ResultSet rs=st.executeQuery(sql);
//            rs.last();
//            int rows=rs.getRow();
//            programaProduccionList.clear();
//            rs.first();
//            String cod="";
//            for(int i=0;i<rows;i++){
//                ProgramaProduccion bean=new ProgramaProduccion();
//                bean.setCodProgramaProduccion(rs.getString(1));
//                bean.getFormulaMaestra().setCodFormulaMaestra(rs.getString(2));
//                bean.setCodLoteProduccion(rs.getString(3));
//                bean.setCodLoteProduccionAnterior(rs.getString(3));
//                String fechaInicio="";
//                /*String fechaInicioVector[]=fechaInicio.split(" ");
//                fechaInicioVector=fechaInicioVector[0].split("-");
//                fechaInicio=fechaInicioVector[2]+"/"+fechaInicioVector[1]+"/"+fechaInicioVector[0];
//                bean.setFechaInicio(fechaInicio);*/
//                String fechaFinal="";
//                /*String fechaFinalVector[]=fechaFinal.split(" ");
//                fechaFinalVector=fechaFinalVector[0].split("-");
//                fechaFinal=fechaFinalVector[2]+"/"+fechaFinalVector[1]+"/"+fechaFinalVector[0];
//                bean.setFechaFinal(fechaFinal);*/
//                bean.setCodEstadoPrograma(rs.getString(6));
//                bean.setObservacion(rs.getString(7));
//                bean.getFormulaMaestra().getComponentesProd().setNombreProdSemiterminado(rs.getString(8));
//                bean.getFormulaMaestra().getComponentesProd().setCodCompprod(rs.getString(9));
//                double cantidad=rs.getDouble(10);
//                cantidad=redondear(cantidad,3);
//                NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
//                DecimalFormat form = (DecimalFormat)nf;
//                form.applyPattern("#,#00.0#");
//                bean.getFormulaMaestra().setCantidadLote(cantidad);
//                bean.getEstadoProgramaProduccion().setNombreEstadoProgramaProd(rs.getString(11));
//                cantidad=rs.getDouble(12);
//                cantidad=redondear(cantidad,3);
//                bean.getTiposProgramaProduccion().setCodTipoProgramaProd(rs.getString(13));
//                bean.getTiposProgramaProduccion().setNombreProgramaProd(rs.getString(14));
//                bean.getCategoriasCompProd().setNombreCategoriaCompProd(rs.getString(15));
//                bean.setCantidadLote(cantidad);
//                System.out.println("bean.setCantidadLote:"+bean.getCantidadLote());
//                int materialTransito=rs.getInt(16);
//                System.out.println("materialTransito:"+materialTransito);
//                if (materialTransito == 0) {
//
//                    bean.setMaterialTransito("CON EXISTENCIA");
//                    bean.setStyleClass("b");
//                    System.out.println("ENTRO EXISTENCIA:"+bean.getMaterialTransito());
//                }
//                if (materialTransito == 1) {
//
//                    bean.setMaterialTransito("EN TRÁNSITO");
//                    bean.setStyleClass("a");
//                    System.out.println("ENTRO TRANSITO:"+bean.getMaterialTransito());
//                }
//
//                programaProduccionList.add(bean);
//                rs.next();
//            }
//
//            if(rs!=null){
//                rs.close();
//                st.close();
//            }
//
//
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        return"";
//    }

public void cargarCantidadEnvase(){
    try {
        cantidadEnvaseList.clear();
        for(int i=1;i<=50;i++){
            cantidadEnvaseList.add(new SelectItem(i,String.valueOf(i)));
        }

    } catch (Exception e) {
        e.printStackTrace();
    }
}








public void cargarGestionAcondicionamiento(){
        try {
            String sql="select cod_gestion,nombre_gestion from gestiones";
            sql+=" where gestion_estado=1";
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(sql);

            if (rs.next()){
                ingresosAcondicionamiento.getGestion().setCodGestion(rs.getString("cod_gestion"));
                ingresosAcondicionamiento.getGestion().setNombreGestion(rs.getString("nombre_gestion"));
            }
            if(rs!=null){
                rs.close();
                st.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


public Date recuperaFechaProgramaProduccion(ProgramaProduccion p){
    Date fechaProgProd = new Date();
    try {
        Connection con = null;
        con = Util.openConnection(con);
        Statement st = con.createStatement();
        String consulta = " select fecha_inicio,fecha_final from programa_produccion_periodo p where p.cod_programa_prod = '"+p.getCodProgramaProduccion()+"' ";
        System.out.println("consulta " + consulta);
        ResultSet rs = st.executeQuery(consulta);
        if(rs.next()){
            fechaProgProd = rs.getDate("fecha_final");
        }
        rs.close();
        st.close();
        con.close();


    } catch (Exception e) {
        e.printStackTrace();
    }
    return fechaProgProd;
}
public Date recuperaFechaPesaje(ProgramaProduccion programaProduccion){
    Date fechaPesaje = new Date();
    try {
        Connection con = null;
        con = Util.openConnection(con);
        String consulta = " select top 1 s.COD_SEGUIMIENTO_PROGRAMA,s.HORAS_HOMBRE,s.HORAS_MAQUINA,s.FECHA_INICIO,s.FECHA_FINAL,s.HORA_INICIO,s.HORA_FINAL, " +
                " (select isnull(M.COD_MAQUINA,'')  from MAQUINARIAS M where s.COD_MAQUINA=M.COD_MAQUINA ) COD_MAQUINA  " +
                " from SEGUIMIENTO_PROGRAMA_PRODUCCION s  where s.COD_ACTIVIDAD_PROGRAMA='3155'  " +
                " and s.COD_PROGRAMA_PROD='"+programaProduccion.getCodProgramaProduccion()+"' " +
                " and s.COD_COMPPROD='"+programaProduccion.getFormulaMaestra().getComponentesProd().getCodCompprod()+"'  " +
                " and s.COD_FORMULA_MAESTRA='"+programaProduccion.getFormulaMaestra().getCodFormulaMaestra()+"' " +
                " and s.COD_LOTE_PRODUCCION='"+programaProduccion.getCodLoteProduccion()+"'  order by COD_SEGUIMIENTO_PROGRAMA desc  ";
        
        consulta = " select s.COD_SEGUIMIENTO_PROGRAMA,s.HORAS_HOMBRE,s.HORAS_MAQUINA,s.FECHA_INICIO,s.FECHA_FINAL,s.HORA_INICIO,s.HORA_FINAL,   " +
                " (select isnull(M.COD_MAQUINA,'')  from MAQUINARIAS M where s.COD_MAQUINA=M.COD_MAQUINA ) COD_MAQUINA    " +
                " from SEGUIMIENTO_PROGRAMA_PRODUCCION s  inner join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_ACTIVIDAD_FORMULA = s.COD_ACTIVIDAD_PROGRAMA " +
                " where  s.COD_PROGRAMA_PROD='"+programaProduccion.getCodProgramaProduccion()+"'   " +
                " and s.COD_COMPPROD='"+programaProduccion.getFormulaMaestra().getComponentesProd().getCodCompprod()+"'   " +
                " and s.COD_FORMULA_MAESTRA='"+programaProduccion.getFormulaMaestra().getCodFormulaMaestra()+"'  " +
                " and s.COD_LOTE_PRODUCCION='"+programaProduccion.getCodLoteProduccion()+"'   " +
                " and afm.COD_ACTIVIDAD in(76,186) and s.horas_hombre>0 order by COD_SEGUIMIENTO_PROGRAMA asc ";
        

        System.out.println("consulta xxxxxxx " + consulta);
        Statement st =  con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
        ResultSet rs = st.executeQuery(consulta);
        if(rs.next()){
            fechaPesaje = rs.getDate("FECHA_INICIO");
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    System.out.println("la fecha recuperada: " + fechaPesaje );
    return fechaPesaje;
}





private void generarSolicitudAutomaticaEs(ProgramaProduccion registrar)
    {
        mensajeSolicitudAutomatica="";
        try
        {
            Connection con1=null;
            con1=Util.openConnection(con1);
            Statement st=con1.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                String consulta="select ISNULL(MAX(ss.COD_FORM_SALIDA),0)+1 as cod from SOLICITUDES_SALIDA ss";
                    ResultSet res=st.executeQuery(consulta);
                    int codFormSalida=0;
                    if(res.next())
                    {
                        codFormSalida=res.getInt("cod");
                    }
                    consulta="select ISNULL(cp.RENDIMIENTO_PRODUCTO,0) as RENDIMIENTO_PRODUCTO,cp.COD_AREA_EMPRESA from COMPONENTES_PROD cp where cp.COD_COMPPROD='"+registrar.getFormulaMaestra().getComponentesProd().getCodCompprod()+"'";
                    System.out.println("consulta rendimiento "+consulta);
                    res=st.executeQuery(consulta);
                    double rendimiento=0d;
                    String codAreaEmpresaProd="";
                    if(res.next())
                    {
                        rendimiento=res.getDouble("RENDIMIENTO_PRODUCTO");
                        codAreaEmpresaProd=res.getString("COD_AREA_EMPRESA");
                    }
                    if(!codAreaEmpresaProd.equals("80"))
                    {
                        consulta="select tae.PORCIENTO_TOLERANCIA from TOLERANCIA_AREAS_EMPRESA tae  where tae.COD_AREA_EMPRESA='"+codAreaEmpresaProd+"'";
                        System.out.println("consulta buscar tolerancia area "+consulta);
                        double tolerancia=0d;
                        res=st.executeQuery(consulta);
                        if(res.next())
                        {
                           tolerancia=res.getDouble("PORCIENTO_TOLERANCIA");
                        }

                        ManagedAccesoSistema usuario = (ManagedAccesoSistema) Util.getSessionBean("ManagedAccesoSistema");
                        SimpleDateFormat sdf= new SimpleDateFormat("yyyy/MM/dd HH:mm");
                         consulta="INSERT INTO SOLICITUDES_SALIDA(  COD_GESTION,  COD_FORM_SALIDA,  COD_TIPO_SALIDA_ALMACEN,  COD_ESTADO_SOLICITUD_SALIDA_ALMACEN," +
                            "  SOLICITANTE,  AREA_DESTINO_SALIDA,  FECHA_SOLICITUD,  COD_LOTE_PRODUCCION,  OBS_SOLICITUD,  ESTADO_SISTEMA," +
                            "  CONTROL_CALIDAD,  COD_INGRESO_ALMACEN,  COD_ALMACEN,  orden_trabajo,cod_compprod,cod_presentacion,SOLICITUD_AUTOMATICA_PRODUCCION) " + //COD_LUGAR_ACOND,
                            "VALUES ((select top 1 g.COD_GESTION  from GESTIONES g where g.GESTION_ESTADO=1),'"+codFormSalida+"','2','1','"+usuario.getUsuarioModuloBean().getCodUsuarioGlobal()+"','84','"+sdf.format(new Date())+"',"+
                            "'"+registrar.getCodLoteProduccion()+"','solicitud de salida automatica e.s.',1,0,0,'2','','"+registrar.getFormulaMaestra().getComponentesProd().getCodCompprod()+"','0','1')";//"+codLugarAcond+" //,'2'
                         System.out.println("consulta insert solicitud "+consulta);
                        PreparedStatement pst=con1.prepareStatement(consulta);
                        if(pst.executeUpdate()>0)System.out.println("se inserto la cabecera de la solicitud");
                        consulta="select distinct mt.COD_MATERIAL, mt.NOMBRE_MATERIAL,   um.COD_UNIDAD_MEDIDA,   um.NOMBRE_UNIDAD_MEDIDA,    fmdes.CANTIDAD CANTIDAD," +
                        "  prp.cod_presentacion,       prp.NOMBRE_PRODUCTO_PRESENTACION,       um.abreviatura" +
                        " from PROGRAMA_PRODUCCION pprd     inner join FORMULA_MAESTRA fm on fm.COD_COMPPROD = pprd.COD_COMPPROD     " +
                        " inner join FORMULA_MAESTRA_DETALLE_ES fmdes on fmdes.COD_FORMULA_MAESTRA =     fm.COD_FORMULA_MAESTRA" +
                        " inner join materiales mt on mt.COD_MATERIAL = fmdes.COD_MATERIAL     inner join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA =  fmdes.COD_UNIDAD_MEDIDA" +
                        " inner join COMPONENTES_PRESPROD cprp on cprp.COD_COMPPROD = fm.COD_COMPPROD  and cprp.COD_TIPO_PROGRAMA_PROD = pprd.COD_TIPO_PROGRAMA_PROD" +
                        " inner join PRESENTACIONES_PRODUCTO prp on prp.cod_presentacion =    fmdes.COD_PRESENTACION_PRODUCTO and prp.cod_presentacion =  cprp.COD_PRESENTACION " +
                        " where fm.COD_FORMULA_MAESTRA = '"+registrar.getFormulaMaestra().getCodFormulaMaestra()+"' " +
                                " and pprd.COD_PROGRAMA_PROD = '"+registrar.getCodProgramaProduccion()+"' " +
                                " and pprd.COD_TIPO_PROGRAMA_PROD = '"+registrar.getTiposProgramaProduccion().getCodTipoProgramaProd()+"' " +
                                " and pprd.COD_LOTE_PRODUCCION = '"+registrar.getCodLoteProduccion()+"' " +
                                " and  pprd.COD_COMPPROD = '"+registrar.getFormulaMaestra().getComponentesProd().getCodCompprod()+"'";
                        System.out.println("consulta buscar materiales ES "+consulta);
                        res=st.executeQuery(consulta);
                        double cantidad=0d;

                        while(res.next())
                        {
                            cantidad=res.getDouble("CANTIDAD");
                            cantidad=(cantidad*(registrar.getCantidadLote()/registrar.getFormulaMaestra().getCantidadLote()));
                            rendimiento=(rendimiento>0?rendimiento:1);
                            cantidad=cantidad*rendimiento;
                            if(tolerancia>0)
                            {
                                cantidad=cantidad+(cantidad*tolerancia);
                            }

                            cantidad=redondear(cantidad,0);

                            consulta="INSERT INTO SOLICITUDES_SALIDA_DETALLE(  COD_FORM_SALIDA,  COD_MATERIAL,  CANTIDAD,  CANTIDAD_ENTREGADA," +
                                "  COD_UNIDAD_MEDIDA) VALUES ('"+codFormSalida+"','"+res.getString("COD_MATERIAL")+"'," +
                                "'"+(cantidad>0?cantidad:1)+"',0,'"+res.getString("COD_UNIDAD_MEDIDA")+"')";
                            System.out.println("consulta insert solicitud detalle "+consulta);
                            pst=con1.prepareStatement(consulta);
                            if(pst.executeUpdate()>0)System.out.println("se inserto el detalle");
                        }
                        mensajeSolicitudAutomatica="se registro la solicitud de salida automatica Nro "+codFormSalida;
                        System.out.println(mensajeSolicitudAutomatica);
                    }
            res.close();
            st.close();
            con1.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();

        }
    }

public void redireccionar(String direccion) {
        try {

            FacesContext facesContext = FacesContext.getCurrentInstance();
            ExternalContext ext = facesContext.getExternalContext();
            ext.redirect(direccion);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private String codigos="";
    private String fecha_inicio="";
    private String fecha_final="";
    
    public void actionEliminar(){
        setCodigos("");
        fecha_inicio="";
        fecha_final="";
        for(ProgramaProduccion bean:programaProduccionList){
            if(bean.getChecked().booleanValue()){
                setCodigos(getCodigos() + (""+bean.getCodProgramaProduccion()+","));
                fecha_inicio=fecha_inicio+bean.getFechaInicio()+",";
                fecha_final=fecha_final+bean.getFechaFinal()+",";
            }
        }
        
        System.out.println("codigos:"+codigos);
        System.out.println("fecha_inicio:"+fecha_inicio);
        System.out.println("fecha_final:"+fecha_final);
        
    }

    public List cargarPresentacionesProducto(ProgramaProduccion p){
        List presentacionesProductoList = new ArrayList();
        try {
            String consulta = " select prp.cod_presentacion,prp.NOMBRE_PRODUCTO_PRESENTACION" +
                    " from COMPONENTES_PRESPROD c" +
                    " inner join PRESENTACIONES_PRODUCTO prp on prp.cod_presentacion = c.COD_PRESENTACION" +
                    " inner join formula_maestra fm on fm.cod_compprod = c.cod_compprod " +
                    " where fm.cod_formula_maestra = '"+p.getFormulaMaestra().getCodFormulaMaestra()+"' and c.COD_ESTADO_REGISTRO = 1" +
                    " and c.cod_tipo_programa_prod = '"+p.getTiposProgramaProduccion().getCodTipoProgramaProd()+"' ";
            System.out.println("consulta " + consulta);
            Connection con = null;
            con = Util.openConnection(con);
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery(consulta);
            while(rs.next()){
                presentacionesProductoList.add(new SelectItem(rs.getString("cod_presentacion"),rs.getString("nombre_producto_presentacion")));
            }
            if(presentacionesProductoList.size()==0){
                presentacionesProductoList.add(new SelectItem("0","-NINGUNO-"));
            }
            rs.close();
            st.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return presentacionesProductoList;
    }

    public void guardarSeguimientoPesaje(ProgramaProduccion p){
        try {
            String consulta = " select top 1 * from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL s where s.COD_COMPPROD = '"+p.getFormulaMaestra().getComponentesProd().getCodCompprod()+"' and s.COD_PROGRAMA_PROD = '"+p.getCodProgramaProduccion()+"' and s.COD_LOTE_PRODUCCION = '"+p.getCodLoteProduccion()+"'" +
                    " and s.COD_FORMULA_MAESTRA = '"+p.getFormulaMaestra().getCodFormulaMaestra()+"' and s.COD_TIPO_PROGRAMA_PROD = '"+p.getTiposProgramaProduccion().getCodTipoProgramaProd()+"' and s.COD_ACTIVIDAD_PROGRAMA in(select a.cod_actividad_formula from actividades_formula_maestra a where a.cod_formula_maestra=s.cod_formula_maestra and a.cod_actividad in(76,186)) ";
            System.out.println("consulta " + consulta);
            Connection con = null;
            con = Util.openConnection(con);
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery(consulta);
            if(!rs.next()){
                consulta = " insert into seguimiento_programa_produccion_personal select COD_COMPPROD, COD_PROGRAMA_PROD, COD_LOTE_PRODUCCION,COD_FORMULA_MAESTRA, COD_ACTIVIDAD_PROGRAMA, '"+p.getTiposProgramaProduccion().getCodTipoProgramaProd()+"'," +
                        " COD_PERSONAL, HORAS_HOMBRE, UNIDADES_PRODUCIDAS, FECHA_REGISTRO, FECHA_INICIO, FECHA_FINAL, HORAS_EXTRA, UNIDADES_PRODUCIDAS_EXTRA,COD_MAQUINA,0 from seguimiento_programa_produccion_personal where cod_compprod = '"+p.getFormulaMaestra().getComponentesProd().getCodCompprod()+"' and cod_formula_maestra = '"+p.getFormulaMaestra().getCodFormulaMaestra()+"' and cod_lote_produccion = '"+p.getCodLoteProduccion()+"' and cod_programa_prod = '"+p.getCodProgramaProduccion()+"' and cod_actividad_programa in (1625,18952)";
                System.out.println("consulta " + consulta);
                st.executeUpdate(consulta);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public String getCodigoReserva(){
        String codigo="1";
        try {
            setCon(Util.openConnection(getCon()));
            String sql="select max(cod_reserva)+1 from RESERVA";
            PreparedStatement st=getCon().prepareStatement(sql);
            ResultSet rs=st.executeQuery();
            while (rs.next())
                codigo=rs.getString(1);
            if(codigo==null)
                codigo="1";
            
            codReserva=codigo;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return  "";
    }
    
    public String guardarReserva(){
        try{
            
            Date fechaActual=new Date();
            SimpleDateFormat f= new SimpleDateFormat("yyyy/MM/dd");
            String fecha= f.format(fechaActual);
            Iterator i=programaProduccionList.iterator();
            int result=0;
            while (i.hasNext()){
                ProgramaProduccion bean=(ProgramaProduccion)i.next();
                if(bean.getChecked().booleanValue()){
                    String cod_programa_prod=bean.getCodProgramaProduccion();
                    String lote=bean.getCodLoteProduccion();
                    String cod_comp_prod=bean.getFormulaMaestra().getComponentesProd().getCodCompprod();
                    codReserva="0";
                    getCodigoReserva();
                    String sql2="insert into reserva(COD_RESERVA,COD_PROGRAMA_PROD,COD_COMPPROD,COD_LOTE,FECHA_PROGRAMAPRODUCCION,ESTADO_RESERVA)";
                    sql2+="values('"+codReserva+"','"+cod_programa_prod+"','"+cod_comp_prod+"','"+lote+"','"+fecha+"',0)";
                    System.out.println("reserva:"+sql2);
                    Statement st22=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    int rs22=st22.executeUpdate(sql2);
                    
                    
                    String sql4="select ppd.COD_MATERIAL,ppd.CANTIDAD,m.COD_UNIDAD_MEDIDA from PROGRAMA_PRODUCCION_DETALLE ppd,MATERIALES m";
                    sql4+=" where ppd.COD_PROGRAMA_PROD in ("+cod_programa_prod+") and ppd.COD_COMPPROD='"+cod_comp_prod+"' and " +
                            " ppd.COD_LOTE_PRODUCCION='"+lote+"' and m.COD_MATERIAL=ppd.COD_MATERIAL   ";
                    System.out.println("sql4*****:"+sql4);
                    Statement st4= con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet rs4 = st4.executeQuery(sql4);
                    while(rs4.next()){
                        String cod_material=rs4.getString(1);
                        String cantidad=rs4.getString(2);
                        String cod_unidad_medida=rs4.getString(3);
                        System.out.println("cod_material:"+cod_material);
                        sql2="insert into reserva_detalle(COD_RESERVA,COD_MATERIAL,CANTIDAD,COD_UNIDAD_MEDIDA,ESTADO_RESERVA_DETALLE)";
                        sql2+="values('"+codReserva+"','"+cod_material+"','"+cantidad+"','"+cod_unidad_medida+"',0)";
                        System.out.println("sql2 Detalle Reserva:"+sql2);
                        st22=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                        rs22=st22.executeUpdate(sql2);
                    }
                    sql2="update  programa_produccion set";
                    sql2+=" cod_estado_programa=5";
                    sql2+=" where cod_programa_prod="+cod_programa_prod+" and COD_COMPPROD='"+cod_comp_prod+"' and " +
                            " COD_LOTE_PRODUCCION='"+lote+"'";
                    System.out.println("reserva update:"+sql2);
                    st22=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    rs22=st22.executeUpdate(sql2);
                /* sql2="update  programa_produccion_periodo set";
                sql2+=" cod_estado_programa=2";
                sql2+=" where cod_programa_prod=5";
                System.out.println("reserva update:"+sql2);
                st22=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                rs22=st22.executeUpdate(sql2);*/
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return"navegadorProgramaProduccion";
    }
    public String eliminarReserva(){
        try{
            
            
            Date fechaActual=new Date();
            SimpleDateFormat f= new SimpleDateFormat("yyyy/MM/dd");
            String fecha= f.format(fechaActual);
            Iterator i=programaProduccionList.iterator();
            int result=0;
            while (i.hasNext()){
                ProgramaProduccion bean=(ProgramaProduccion)i.next();
                if(bean.getChecked().booleanValue()){
                    String cod_programa_prod=bean.getCodProgramaProduccion();
                    String lote=bean.getCodLoteProduccion();
                    String cod_comp_prod=bean.getFormulaMaestra().getComponentesProd().getCodCompprod();
                    String sql4="select cod_reserva from reserva  ";
                    sql4+=" where COD_PROGRAMA_PROD in ("+cod_programa_prod+") and COD_COMPPROD='"+cod_comp_prod+"' and COD_LOTE='"+lote+"' ";
                    System.out.println("sql4*****:"+sql4);
                    Statement st4= con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet rs4 = st4.executeQuery(sql4);
                    while(rs4.next()){
                        String cod_reserva=rs4.getString(1);
                        String sql2="delete from reserva " ;
                        sql2+=" where cod_reserva='"+cod_reserva+"'";
                        System.out.println(" delete reserva:"+sql2);
                        Statement st22=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                        int rs22=st22.executeUpdate(sql2);
                        
                        sql2="delete from reserva_detalle " ;
                        sql2+=" where cod_reserva='"+cod_reserva+"'";
                        System.out.println("delete Detalle Reserva:"+sql2);
                        st22=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                        rs22=st22.executeUpdate(sql2);
                        sql2="update  programa_produccion set";
                        sql2+=" cod_estado_programa=2";
                        sql2+=" where cod_programa_prod="+cod_programa_prod+" and COD_COMPPROD='"+cod_comp_prod+"' and " +
                                " COD_LOTE_PRODUCCION='"+lote+"'";
                        System.out.println("reserva update:"+sql2);
                        st22=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                        rs22=st22.executeUpdate(sql2);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return"navegadorProgramaProduccion";
    }

    public boolean tieneSalidasAlmacen(ProgramaProduccion p){
        boolean tieneSalidasAlmacen = false;
        try {
            String consulta ="select * from SALIDAS_ALMACEN s where s.COD_LOTE_PRODUCCION = '"+p.getCodLoteProduccion()+"' and s.COD_PROD = '"+p.getFormulaMaestra().getComponentesProd().getCodCompprod()+"' and s.cod_estado_salida_almacen=1";
            System.out.println("consulta " + consulta);
            Connection con = null;
            con = Util.openConnection(con);
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery(consulta);
            if(rs.next()){
                tieneSalidasAlmacen = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return tieneSalidasAlmacen;
    }
    
    
    
    
    
    
    public double redondear( double numero, int decimales ) {
        return Math.round(numero*Math.pow(10,decimales))/Math.pow(10,decimales);
    }
    
    public String reporteEtiquetas_action(){
        try {
            Iterator i = programaProduccionList.iterator();
            for(ProgramaProduccion programaProduccion:programaProduccionList){
                if(programaProduccion.getChecked()==true){
                    ExternalContext externalContext = FacesContext.getCurrentInstance().getExternalContext();
                    Map<String,Object> sessionMap = externalContext.getSessionMap();
                    sessionMap.put("programaProduccion",programaProduccion);
                    break;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public String buscarComponenteProdFormulaMaestra_action(){
        try {
            String consulta = " SELECT cp.COD_COMPPROD, cp.nombre_prod_semiterminado, cp.COD_ESTADO_COMPPROD,fm.CANTIDAD_LOTE,ae.nombre_area_empresa from COMPONENTES_PROD cp inner join FORMULA_MAESTRA fm on fm.COD_COMPPROD=cp.COD_COMPPROD  " +
                    " inner join AREAS_EMPRESA ae on ae.cod_area_empresa = cp.cod_area_empresa " +
                    "  WHERE cp.nombre_prod_semiterminado LIKE '"+componentesProdBuscar.getNombreProdSemiterminado()+"%' ";
            System.out.println("consulta" + consulta);
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(consulta);
            componentesProdFormulaMaestraList.clear();
            while(rs.next()){
                ComponentesProdFormulaMaestra componentesProdFormulaMaestra = new ComponentesProdFormulaMaestra();                
                componentesProdFormulaMaestra.getComponentesProd().setCodCompprod(rs.getString("COD_COMPPROD"));
                componentesProdFormulaMaestra.getComponentesProd().setNombreProdSemiterminado(rs.getString("nombre_prod_semiterminado"));
                componentesProdFormulaMaestra.getComponentesProd().getEstadoCompProd().setCodEstadoCompProd(rs.getInt("COD_ESTADO_COMPPROD"));
                componentesProdFormulaMaestra.getFormulaMaestra().setCantidadLote(rs.getDouble("CANTIDAD_LOTE"));
                componentesProdFormulaMaestra.getComponentesProd().getAreasEmpresa().setNombreAreaEmpresa(rs.getString("nombre_area_empresa"));
                componentesProdFormulaMaestraList.add(componentesProdFormulaMaestra);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public String seleccionarComponenteProdFormulaMaestra_action(){
        try {
            ComponentesProdFormulaMaestra componentesProdFormulaMaestraItem = (ComponentesProdFormulaMaestra) componentesProdFormulaMaestraDataTable.getRowData();
            IngresosDetalleAcond almacenDetalleAcondItem = (IngresosDetalleAcond)ingresosAlmacenDetalleAcondDataTable.getRowData();            
            
            almacenDetalleAcondItem.getComponentesProd().setCodCompprod(componentesProdFormulaMaestraItem.getComponentesProd().getCodCompprod());
            almacenDetalleAcondItem.getComponentesProd().setNombreProdSemiterminado(componentesProdFormulaMaestraItem.getComponentesProd().getNombreProdSemiterminado());
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

   public void actionExplosion() {
        setCodigos("");
        fecha_inicio = "";
        fecha_final = "";
        for (ProgramaProduccion bean : programaProduccionList) {
            if (bean.getChecked().booleanValue()) {
                setCodigos(getCodigos() + ("" + bean.getFormulaMaestra().getComponentesProd().getCodCompprod() + ","));
                fecha_inicio = fecha_inicio + bean.getFechaInicio() + ",";
                fecha_final = fecha_final + bean.getFechaFinal() + ",";
            }
        }
        System.out.println("codigos:" + codigos);
        System.out.println("fecha_inicio:" + fecha_inicio);
        System.out.println("fecha_final:" + fecha_final);
    }

   public String verActividadesProduccion_action(){
       try {
           
           ProgramaProduccion programaProduccion = (ProgramaProduccion)programaProduccionDataTable.getRowData();
           ExternalContext externalContext = FacesContext.getCurrentInstance().getExternalContext();
           Map<String, Object> sessionMap = externalContext.getSessionMap();
           Map<String,String> params = externalContext.getRequestParameterMap();
           sessionMap.put("programaProduccion",programaProduccion);
           sessionMap.put("codAreaEmpresa",params.get("codAreaEmpresa"));
           sessionMap.put("url",params.get("url"));

            int loteConEntregaTotalAcond = 1;

            Date ultimaFechaEnvioAcond = new Date();
            Connection con = null;
            con = Util.openConnection(con);
            Statement st = con.createStatement();
            String consulta = "   select p.COD_LOTE_PRODUCCION,p.COD_COMPPROD,p.COD_TIPO_PROGRAMA_PROD,ppia.COD_INGRESO_ACOND,ia.fecha_ingresoacond from programa_produccion p" +
                    " inner join PROGRAMA_PRODUCCION_INGRESOS_ACOND ppia on ppia.COD_PROGRAMA_PROD = p.COD_PROGRAMA_PROD and ppia.COD_LOTE_PRODUCCION = p.COD_LOTE_PRODUCCION" +
                    " and ppia.COD_TIPO_PROGRAMA_PROD = p.COD_TIPO_PROGRAMA_PROD and ppia.COD_FORMULA_MAESTRA = p.COD_FORMULA_MAESTRA" +
                    " and ppia.COD_COMPPROD = p.COD_COMPPROD" +
                    " inner join ingresos_acond ia on ia.cod_ingreso_acond = ppia.cod_ingreso_acond " +
                    //" and ppia.COD_TIPO_ENTREGA_ACOND = 2" +
                    " where p.COD_PROGRAMA_PROD = '"+programaProduccion.getCodProgramaProduccion()+"' and p.COD_LOTE_PRODUCCION = '"+programaProduccion.getCodLoteProduccion()+"'" +
                    " and p.COD_COMPPROD = '"+programaProduccion.getFormulaMaestra().getComponentesProd().getCodCompprod()+"' and p.COD_FORMULA_MAESTRA = '"+programaProduccion.getFormulaMaestra().getCodFormulaMaestra()+"' and p.COD_TIPO_PROGRAMA_PROD = '"+programaProduccion.getTiposProgramaProduccion().getCodTipoProgramaProd()+"'" +
                    " order by ia.fecha_ingresoacond  ";
            System.out.println("consulta  " + consulta);
            ResultSet rs = st.executeQuery(consulta);
/*
            while(rs.next()){
                ultimaFechaEnvioAcond = rs.getDate("fecha_ingresoacond");
//                if(rs.getInt("COD_TIPO_ENTREGA_ACOND")==1){//tiene entrega parcial
//                    loteConEntregaTotalAcond = 0;
//                }
            }
*/
            DateTime fecha = new DateTime(ultimaFechaEnvioAcond);
            fecha.plusDays(1);
            Date fechaActual = new Date();
            
            
//            if(loteConEntregaTotalAcond==1 && fechaActual.compareTo(fecha.toDate())<=0){
//                mensaje = " el lote ya no puede registrar tiempos, tiene 24 hrs para registro de tiempos esto posterior a la ultima entrega de lote  ";
//                System.out.println("mensaje " + mensaje);
//            }
            
           this.redireccionar("../actividades_programa_produccion/navegador_actividades_programa.jsf");
       } catch (Exception e) {
           e.printStackTrace();
       }
       return null;
   }
   public int loteConEntregaTotalAcond(ProgramaProduccion p){
       int loteConEntregaTotalAcond = 1;
       try {
            Connection con = null;
            con = Util.openConnection(con);
            Statement st = con.createStatement();
            String consulta = "   select p.COD_LOTE_PRODUCCION,p.COD_COMPPROD,p.COD_TIPO_PROGRAMA_PROD,ppia.COD_INGRESO_ACOND,ia.fecha_ingresoacond from programa_produccion p" +
                    " inner join PROGRAMA_PRODUCCION_INGRESOS_ACOND ppia on ppia.COD_PROGRAMA_PROD = p.COD_PROGRAMA_PROD and ppia.COD_LOTE_PRODUCCION = p.COD_LOTE_PRODUCCION" +
                    " and ppia.COD_TIPO_PROGRAMA_PROD = p.COD_TIPO_PROGRAMA_PROD and ppia.COD_FORMULA_MAESTRA = p.COD_FORMULA_MAESTRA" +
                    " and ppia.COD_COMPPROD = p.COD_COMPPROD" +
                    " inner join ingresos_acond ia on ia.cod_ingreso_acond = ppia.cod_ingreso_acond " +
                    //" and ppia.COD_TIPO_ENTREGA_ACOND = 2" +
                    " where p.COD_PROGRAMA_PROD = '"+p.getProgramaProduccionPeriodo().getCodProgramaProduccion()+"' and p.COD_LOTE_PRODUCCION = '"+p.getCodLoteProduccion()+"'" +
                    " and p.COD_COMPPROD = '"+p.getFormulaMaestra().getComponentesProd().getCodCompprod()+"' and p.COD_FORMULA_MAESTRA = '"+p.getFormulaMaestra().getCodFormulaMaestra()+"' and p.COD_TIPO_PROGRAMA_PROD = '"+p.getTiposProgramaProduccion().getCodTipoProgramaProd()+"'" +
                    " order by ia.fecha_ingresoacond  ";
            System.out.println("consulta  " + consulta);
            ResultSet rs = st.executeQuery(consulta);
            
            while(rs.next()){
                if(rs.getInt("COD_TIPO_ENTREGA_ACOND")==1){//tiene entrega parcial
                    loteConEntregaTotalAcond = 0;
                }
                
            }

       } catch (Exception e) {
           e.printStackTrace();
       }
       return loteConEntregaTotalAcond;
   }
   public String verActividadesProduccion_action1(){
       try {
           
           mensaje = "";
           ProgramaProduccion programaProduccion = (ProgramaProduccion)programaProduccionSeguimientoDataTable.getRowData();
           ExternalContext externalContext = FacesContext.getCurrentInstance().getExternalContext();
           Map<String, Object> sessionMap = externalContext.getSessionMap();
           Map<String,String> params = externalContext.getRequestParameterMap();
           sessionMap.put("programaProduccion",programaProduccion);
           sessionMap.put("codAreaEmpresa",params.get("codAreaEmpresa").toString().replace(":",","));
           sessionMap.put("url",params.get("url"));

           
           int loteConEntregaTotalAcond = 1;
           int conEntregasAcond = 0;

            Date ultimaFechaEnvioAcond = new Date();
            Connection con = null;
            con = Util.openConnection(con);
            Statement st = con.createStatement();
            String consulta = "   select p.COD_LOTE_PRODUCCION,p.COD_COMPPROD,p.COD_TIPO_PROGRAMA_PROD,ppia.COD_INGRESO_ACOND,ia.fecha_ingresoacond,ppia.cod_tipo_entrega_acond" +
                    " from programa_produccion p" +
                    " inner join PROGRAMA_PRODUCCION_INGRESOS_ACOND ppia on ppia.COD_PROGRAMA_PROD = p.COD_PROGRAMA_PROD and ppia.COD_LOTE_PRODUCCION = p.COD_LOTE_PRODUCCION" +
                    " and ppia.COD_TIPO_PROGRAMA_PROD = p.COD_TIPO_PROGRAMA_PROD and ppia.COD_FORMULA_MAESTRA = p.COD_FORMULA_MAESTRA" +
                    " and ppia.COD_COMPPROD = p.COD_COMPPROD" +
                    " inner join ingresos_acond ia on ia.cod_ingreso_acond = ppia.cod_ingreso_acond " +
                    " and ppia.COD_TIPO_ENTREGA_ACOND = 2" +
                    " where p.COD_PROGRAMA_PROD = '"+programaProduccion.getCodProgramaProduccion()+"' and p.COD_LOTE_PRODUCCION = '"+programaProduccion.getCodLoteProduccion()+"'" +
                    " and p.COD_COMPPROD = '"+programaProduccion.getFormulaMaestra().getComponentesProd().getCodCompprod()+"' and p.COD_FORMULA_MAESTRA = '"+programaProduccion.getFormulaMaestra().getCodFormulaMaestra()+"' and p.COD_TIPO_PROGRAMA_PROD = '"+programaProduccion.getTiposProgramaProduccion().getCodTipoProgramaProd()+"'" +
                    " order by ia.fecha_ingresoacond  ";
            System.out.println("consulta control tiempos  " + consulta);
            ResultSet rs = st.executeQuery(consulta);

            while(rs.next()){
                conEntregasAcond = 1;
                ultimaFechaEnvioAcond = rs.getDate("fecha_ingresoacond");
                if(rs.getInt("COD_TIPO_ENTREGA_ACOND")==1){//tiene entrega parcial
                    loteConEntregaTotalAcond = 0;
                }
            }

            DateTime fecha = new DateTime(ultimaFechaEnvioAcond);
            fecha.plusDays(1);
            Date fechaActual = new Date();


//            if(conEntregasAcond==1 &&  loteConEntregaTotalAcond==1 && fechaActual.compareTo(fecha.toDate())>0){//sobrepasa el tiempo
//                mensaje = " el lote ya no puede registrar tiempos, tiene 24 hrs para registro de tiempos posterior a la ultima entrega de lote  ";
//                System.out.println("mensaje " + mensaje);
//                return null;
//            }

           //this.redireccionar("../actividades_programa_produccion/navegador_actividades_programa.jsf");
       } catch (Exception e) {
           e.printStackTrace();
       }
       return null;
   }
   private void cargarClientesSelectList()
   {
       try
       {
           con = Util.openConnection(con);
           Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
           String consulta = "select cod_cliente,nombre_cliente from clientes where cod_area_empresa=1 and cod_estadocliente=1  order by 2 asc";
           ResultSet res = st.executeQuery(consulta);
           clienteSelectList.clear();
           while (res.next()) 
           {
               clienteSelectList.add(new SelectItem(res.getString("cod_cliente"),res.getString("nombre_cliente")));
           }
           res.close();
           st.close();
           con.close();
       } catch (SQLException ex) {
           ex.printStackTrace();
       }
   }
    public String verReporteEtiquetasAcond_action(){
        mensaje = "";
        try{
            programaProduccionSeleccionado = (ProgramaProduccion)programaProduccionSeguimientoDataTable.getRowData();
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=null;
            StringBuilder consulta=new StringBuilder(" exec PAA_LISTAR_FECHA_VENCIMIENTO_LOTE")
                                    .append("'").append(programaProduccionSeleccionado.getCodLoteProduccion()).append("',")
                                    .append(programaProduccionSeleccionado.getCodProgramaProduccion()).append(",")
                                    .append(programaProduccionSeleccionado.getFormulaMaestra().getComponentesProd().getCodCompprod()).append(",")
                                    .append(programaProduccionSeleccionado.getFormulaMaestra().getComponentesProd().getForma().getCodForma()).append(",")
                                    .append("?,")//mensaje
                                    .append("?,")//fecha vencimiento
                                    .append("?");//fecha pesaje
            LOGGER.debug("consulta obtener vida util producto "+consulta.toString());
            CallableStatement callVersionCopia=con.prepareCall(consulta.toString());
            callVersionCopia.registerOutParameter(1,java.sql.Types.VARCHAR);
            callVersionCopia.registerOutParameter(2,java.sql.Types.TIMESTAMP);
            callVersionCopia.registerOutParameter(3,java.sql.Types.TIMESTAMP);
            callVersionCopia.execute();
            if(callVersionCopia.getString(1).length()>0){
                mensaje=callVersionCopia.getString(1);
            }
            else{
                programaProduccionSeleccionado.setFechaVencimiento(callVersionCopia.getTimestamp(2));
            }
            if(mensaje.equals("")){
               mensaje="1";
               consulta = new StringBuilder("select pp.cod_presentacion,pp.NOMBRE_PRODUCTO_PRESENTACION")
                          .append(" from COMPONENTES_PRESPROD cpp inner join PRESENTACIONES_PRODUCTO pp on ")
                          .append(" cpp.COD_PRESENTACION=pp.cod_presentacion")
                          .append(" where cpp.COD_COMPPROD='").append(programaProduccionSeleccionado.getFormulaMaestra().getComponentesProd().getCodCompprod()).append("'" )
                          .append(" order by pp.NOMBRE_PRODUCTO_PRESENTACION");
               res=st.executeQuery(consulta.toString());
               presentacionesSecundariasSelectList.clear();
               while(res.next())
               {
                   presentacionesSecundariasSelectList.add(new SelectItem(res.getString("cod_presentacion"),res.getString("NOMBRE_PRODUCTO_PRESENTACION")));
               }
               this.cargarTiposProgramaProduccionSelect();
               this.cargarClientesSelectList();
               ingresosAcondicionamientoEtiqueta=new IngresosDetalleAcond();
               ingresosAcondicionamientoEtiqueta.setCantTotalIngreso((int)programaProduccionSeleccionado.getCantidadLote());
            }
        }
        catch (Exception e){
            LOGGER.warn("error", e);
        }
        return null;
   }
   public String verReporteEtiquetas_action()
   {
       try {
           ProgramaProduccion programaProduccion = (ProgramaProduccion)programaProduccionDataTable.getRowData();
           ExternalContext externalContext = FacesContext.getCurrentInstance().getExternalContext();
           Map<String, Object> sessionMap = externalContext.getSessionMap();
           fechaEtiquetasPesaje=null;
           sessionMap.put("programaProduccion",programaProduccion);
           
       } catch (Exception e) {
           e.printStackTrace();
       }
       return null;
   }
   public String verReporteEtiquetasCambioFecha_action()
   {
       try {
           ProgramaProduccion programaProduccion = (ProgramaProduccion)programaProduccionDataTable.getRowData();
           ExternalContext externalContext = FacesContext.getCurrentInstance().getExternalContext();
           Map<String, Object> sessionMap = externalContext.getSessionMap();
           fechaEtiquetasPesaje=new Date();
           sessionMap.put("programaProduccion",programaProduccion);
           
       } catch (Exception e) {
           e.printStackTrace();
       }
       return null;
   }
    //<editor-fold desc="cargar seguimiento Programa produccion periodo" defaultstate="collapsed">
        public String getCargarProgramaProduccionSeguimientoList()
        {
            this.cargarProgramaProduccionSeguimientoList();
            return null;
        }
        private void cargarProgramaProduccionSeguimientoList()
        {
            try
            {
                con = Util.openConnection(con);
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ManagedAccesoSistema managed=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
                StringBuilder consulta =new StringBuilder("exec PAA_NAVEGADOR_PROGRAMA_PRODUCCION ");
                                                consulta.append("'").append(programaProduccionSeguimientoBuscar.getCodLoteProduccion()).append("',");
                                                consulta.append(programaProduccionSeguimientoBuscar.getProgramaProduccionPeriodo()!=null?programaProduccionSeguimientoBuscar.getProgramaProduccionPeriodo().getCodProgramaProduccion():"0").append(",");
                                                    consulta.append(managed.getUsuarioModuloBean().getCodUsuarioGlobal());
                LOGGER.debug("consulta cargar Programa produccion seguimiento"+consulta.toString());
                LOGGER.info("pr "+programaProduccionSeguimientoBuscar.getCodLoteProduccion());
                ResultSet res=st.executeQuery(consulta.toString());
                NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
                DecimalFormat form = (DecimalFormat)nf;
                form.applyPattern("#,#00.0#");
                programaProduccionSeguimientoList=new ArrayList<ProgramaProduccion>();
                while(res.next())
                {
                    ProgramaProduccion nuevo=new ProgramaProduccion();
                    nuevo.getPresentacionesProducto().setCodPresentacion(res.getString("COD_PRESENTACION"));
                    nuevo.getPresentacionesProducto().setNombreProductoPresentacion(res.getString("NOMBRE_PRODUCTO_PRESENTACION"));
                    nuevo.setCantidadDesviaciones(res.getInt("cantidadDesviaciones"));
                    nuevo.getEstadosProgramaProduccionImpresionOm().setCodEstadoProgramaProduccionImpresionOm(res.getInt("COD_ESTADO_PROGRAMA_PRODUCCION_IMPRESION_OM"));
                    nuevo.getProgramaProduccionPeriodo().setNombreProgramaProduccion(res.getString("NOMBRE_PROGRAMA_PROD"));
                    nuevo.setCodProgramaProduccion(res.getString("cod_programa_prod"));
                    nuevo.getFormulaMaestra().setCodFormulaMaestra(res.getString("COD_FORMULA_MAESTRA"));
                    nuevo.setCodLoteProduccion(res.getString("COD_LOTE_PRODUCCION"));
                    nuevo.setCodEstadoPrograma(res.getString("COD_ESTADO_PROGRAMA"));
                    nuevo.getEstadoProgramaProduccion().setCodEstadoProgramaProd(res.getString("COD_ESTADO_PROGRAMA"));
                    nuevo.setObservacion(res.getString("OBSERVACION"));
                    nuevo.getFormulaMaestra().getComponentesProd().setNombreProdSemiterminado(res.getString("nombre_prod_semiterminado"));
                    nuevo.getFormulaMaestra().getComponentesProd().setCodCompprod(res.getString("COD_COMPPROD"));
                    nuevo.getFormulaMaestra().setCantidadLote(res.getDouble("cantidad_lote"));
                    nuevo.getEstadoProgramaProduccion().setNombreEstadoProgramaProd(res.getString("NOMBRE_ESTADO_PROGRAMA_PROD") + "(" +res.getString("NOMBRE_ACTIVIDAD")+  ")");
                    nuevo.getTiposProgramaProduccion().setNombreProgramaProd(res.getString("NOMBRE_TIPO_PROGRAMA_PROD"));
                    nuevo.getCategoriasCompProd().setNombreCategoriaCompProd(res.getString("NOMBRE_CATEGORIACOMPPROD"));
                    nuevo.setCantidadLote(res.getDouble("CANT_LOTE_PRODUCCION"));
                    nuevo.getFormulaMaestra().getComponentesProd().getAreasEmpresa().setNombreAreaEmpresa(res.getString("NOMBRE_AREA_EMPRESA"));
                    nuevo.getFormulaMaestra().getComponentesProd().getAreasEmpresa().setCodAreaEmpresa(res.getString("COD_AREA_EMPRESA"));
                    nuevo.getTiposProgramaProduccion().setCodTipoProgramaProd(res.getString("COD_TIPO_PROGRAMA_PROD"));
                    nuevo.setMaterialTransito(res.getInt("MATERIAL_TRANSITO")==0?"CON EXISTENCIA":(res.getInt("MATERIAL_TRANSITO")==1?"EN TRÁNSITO":""));
                    nuevo.setStyleClass(res.getInt("MATERIAL_TRANSITO")==0?"b":(res.getInt("MATERIAL_TRANSITO")==1?"a":""));
                    nuevo.getFormulaMaestra().getComponentesProd().setVidaUtil(res.getInt("VIDA_UTIL"));
                    nuevo.getFormulaMaestra().getComponentesProd().getForma().setCodForma(res.getString("COD_FORMA"));
                    nuevo.getComponentesProdVersion().setCodVersion(res.getInt("cod_version_cp"));
                    nuevo.getComponentesProdVersion().setNroVersion(res.getInt("nro_version_cp"));
                    nuevo.getFormulaMaestraVersion().setCodVersion(res.getInt("cod_version_fm"));
                    nuevo.getFormulaMaestraVersion().setNroVersion(res.getInt("nro_version_fm"));
                    nuevo.getFormulaMaestraEsVersion().setCodFormulaMaestraEsVersion(res.getInt("COD_FORMULA_MAESTRA_ES_VERSION"));
                    nuevo.getFormulaMaestraEsVersion().setNroVersion(res.getInt("nroVersionFmEs"));
                    nuevo.setFechaRegistro(res.getTimestamp("FECHA_REGISTRO"));
                    programaProduccionSeguimientoList.add(nuevo);
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
        public String buscarLoteSeguimientoProgramaProduccion_action()
        {
            programaProduccionSeguimientoBuscar.setProgramaProduccionPeriodo(null);
            return null;
        }
        public String seleccionarSeguimientoProgramaProduccionPeriodo_action()
        {
            programaProduccionSeguimientoBuscar.setProgramaProduccionPeriodo((ProgramaProduccionPeriodo)programaProduccionPeriodoSeguimientoDataTable.getRowData());
            programaProduccionSeguimientoBuscar.setCodLoteProduccion("");
            return null;
        }
        public String getCargarProgramaProduccionPeriodoSeguimiento()
        {
            //funcion que sirve para el programa de produccion
            this.cargarProgramaProduccionPeriodo();
            return null;
        }
    //</editor-fold>
    public String calcularhoras()
    {
        SeguimientoProgramaProduccionIndirectoPersonal seguimientoPersonal=(SeguimientoProgramaProduccionIndirectoPersonal)seguimientoIndirectoPersonalDataTable.getRowData();
        seguimientoPersonal.getFechaInicio().setHours(seguimientoPersonal.getHoraInicio().getHours());
        seguimientoPersonal.getFechaInicio().setMinutes(seguimientoPersonal.getHoraInicio().getMinutes());
        seguimientoPersonal.getFechaFinal().setHours(seguimientoPersonal.getHoraFinal().getHours());
        seguimientoPersonal.getFechaFinal().setMinutes(seguimientoPersonal.getHoraFinal().getMinutes());
        DateTime fechaInicial = new DateTime(seguimientoPersonal.getFechaInicio());
        DateTime fechaFinal = new DateTime(seguimientoPersonal.getFechaFinal());

        System.out.println("el periodo" + (fechaFinal.getMillis()-fechaInicial.getMillis()));
        seguimientoPersonal.setHorarHombre(Float.parseFloat(String.valueOf((fechaFinal.getMillis()-fechaInicial.getMillis())/3600000.0)));
        return null;
    }

   public String mas_action()
   {
       System.out.println("tamaño lista indirecto "+seguimientoIndirecto.getListaSeguimientoPersonal().size());

       SeguimientoProgramaProduccionIndirectoPersonal  insertar2= new SeguimientoProgramaProduccionIndirectoPersonal();
       seguimientoIndirecto.getListaSeguimientoPersonal().add(insertar2);
       return null;
   }
   public String menos_action()
   {
       System.out.println("menos accion");
       List<SeguimientoProgramaProduccionIndirectoPersonal> lista=new ArrayList<SeguimientoProgramaProduccionIndirectoPersonal>();
      for(SeguimientoProgramaProduccionIndirectoPersonal current:seguimientoIndirecto.getListaSeguimientoPersonal())
      {
          if(!current.getChecked())
          {
              SeguimientoProgramaProduccionIndirectoPersonal copia=new SeguimientoProgramaProduccionIndirectoPersonal();
              copia.getPersonal().setCodPersonal(current.getPersonal().getCodPersonal());
              copia.setFechaInicio((Date)current.getFechaInicio().clone());
              copia.setFechaFinal((Date)current.getFechaFinal().clone());
              copia.setHoraInicio((Date)current.getHoraInicio().clone());
              copia.setHoraFinal((Date)current.getHoraFinal().clone());
              copia.setHorarHombre(current.getHorarHombre());
              lista.add(copia);
          }
      }
      seguimientoIndirecto.setListaSeguimientoPersonal(new ArrayList<SeguimientoProgramaProduccionIndirectoPersonal>());
      seguimientoIndirecto.setListaSeguimientoPersonal(lista);
       return null;
   }
   public String fechas_change(){
        DateTime fechaInicial = new DateTime(seguimientoIndirectoPersonal.getFechaInicio());
        DateTime fechaFinal = new DateTime(seguimientoIndirectoPersonal.getFechaFinal());
//        Interval interval = new Interval(fechaInicial,fechaFinal);
//        interval.getEndMillis();
//        Duration duration = new Duration(fechaInicial,fechaFinal);
//
//        //Hours hours = Hours.h.
//        Period period = new Period(fechaInicial,fechaFinal);
        //seguimientoProgramaProduccionPersonal.setHorasHombre(Double.parseDouble(String.valueOf((period.getDays()*24)+period.getHours()+(Float.parseFloat(String.valueOf(period.getMinutes()))/60.0))));
        //System.out.println("el periodo"+period.getDays()+" "+period.getHours()+" "+(period.getMinutes()/60.0) + " "+ duration.toString());
        System.out.println("el periodo" + (fechaFinal.getMillis()-fechaInicial.getMillis()));
        seguimientoIndirectoPersonal.setHorarHombre(Float.parseFloat(String.valueOf((fechaFinal.getMillis()-fechaInicial.getMillis())/3600000.0)));
        return null;
    }
   public String verSeguimientoIndirectoPersonal_action(){
        seguimientoIndirecto = (SeguimientoProgramaProduccionIndirecto)seguimientoIndirectoDataTable.getRowData();
        Util.redireccionar("navegador_actvidades_indirectas_personal.jsf");
        return null;
    }
   public String getCargarSeguimientoActividadesIndirectas_action()
   {
       this.cargarPersonal();
       seguimientoIndirecto.getActividadesProgramaProduccionIndirecto().getAreasEmpresa().getCodAreaEmpresa();
       this.cargarDetalleSeguimientoIndirectoPersonal();
       return null;
   }
  public String registrarSeguimientoIndirectoPersonal_action(){
        seguimientoIndirectoPersonal= new SeguimientoProgramaProduccionIndirectoPersonal();
        DateTime fechaInicial = new DateTime(seguimientoIndirectoPersonal.getFechaInicio());
        fechaInicial = fechaInicial.withSecondOfMinute(0);
        DateTime fechaFinal = new DateTime(seguimientoIndirectoPersonal.getFechaFinal());
        fechaFinal = fechaFinal.withSecondOfMinute(0);
        seguimientoIndirectoPersonal.setFechaFinal(fechaFinal.toDate());
        seguimientoIndirectoPersonal.setFechaInicio(fechaInicial.toDate());
        seguimientoIndirectoPersonal.getAreasEmpresa().setCodAreaEmpresa(seguimientoIndirecto.getActividadesProgramaProduccionIndirecto().getAreasEmpresa().getCodAreaEmpresa());
        seguimientoIndirectoPersonal.getProgramaProduccionPeriodo().setCodProgramaProduccion(seguimientoIndirecto.getProgramaProduccionPeriodo().getCodProgramaProduccion());
        seguimientoIndirectoPersonal.getActividadesProduccion().setCodActividad(seguimientoIndirecto.getActividadesProgramaProduccionIndirecto().getActividadesProduccion().getCodActividad());
        //personalList = this.personalArea(personalList, seguimientoProgramaProduccion.getSeguimientoProgramaProduccionPersonalList());
        return null;
    }
  public String guardarSeguimientoPersonal() throws SQLException
  {
      mensaje="";
      SimpleDateFormat dias=new SimpleDateFormat("yyyy/MM/dd");
      SimpleDateFormat horas=new SimpleDateFormat("HH:mm:ss");
         this.registrarSeguimientoIndirectoPersonal_action();
         try
         {
             con=Util.openConnection(con);
             con.setAutoCommit(false);
             float suma1=0;
             String delete="delete from SEGUIMIENTO_PROGRAMA_PRODUCCION_INDIRECTO_PERSONAL "+
                     "where COD_AREA_EMPRESA='"+seguimientoIndirecto.getActividadesProgramaProduccionIndirecto().getAreasEmpresa().getCodAreaEmpresa()+
                     "' and COD_PROGRAMA_PROD='"+seguimientoIndirecto.getProgramaProduccionPeriodo().getCodProgramaProduccion()+
                     "' and COD_ACTVIDAD='"+seguimientoIndirecto.getActividadesProgramaProduccionIndirecto().getActividadesProduccion().getCodActividad()+"'";
             System.out.println("consulta delete"+delete);
             PreparedStatement pst=con.prepareStatement(delete);
             if(pst.executeUpdate()>0)System.out.println("se elimino seguimiento programa produccio indirecto");
             String consulta="";
             for(SeguimientoProgramaProduccionIndirectoPersonal current:seguimientoIndirecto.getListaSeguimientoPersonal() )
             {
                 
                 consulta="INSERT INTO SEGUIMIENTO_PROGRAMA_PRODUCCION_INDIRECTO_PERSONAL(COD_PROGRAMA_PROD"+
              ", COD_ACTVIDAD, COD_AREA_EMPRESA, COD_PERSONAL, FECHA_INICIO, FECHA_FINAL,"+
                "HORAS_HOMBRE) VALUES ('"+seguimientoIndirecto.getProgramaProduccionPeriodo().getCodProgramaProduccion()+"',"+
                "'"+seguimientoIndirecto.getActividadesProgramaProduccionIndirecto().getActividadesProduccion().getCodActividad()+"'," +
                "'"+seguimientoIndirecto.getActividadesProgramaProduccionIndirecto().getAreasEmpresa().getCodAreaEmpresa()+"',"+
                "'"+current.getPersonal().getCodPersonal()+"','"+dias.format(current.getFechaInicio())+" "+horas.format(current.getHoraInicio())+"'"+
                ",'"+dias.format(current.getFechaInicio())+" "+horas.format(current.getHoraFinal())+"','"+current.getHorarHombre()+"')";
                   System.out.println("consulta "+consulta);
                  pst=con.prepareStatement(consulta);
             if(pst.executeUpdate()>0)System.out.println("se inserto el seguimiento de personal");
                 suma1+=current.getHorarHombre();
             }

               consulta="UPDATE SEGUIMIENTO_PROGRAMA_PRODUCCION_INDIRECTO SET HORAS_HOMBRE="+suma1+
                        " WHERE COD_ACTIVIDAD='"+seguimientoIndirecto.getActividadesProgramaProduccionIndirecto().getActividadesProduccion().getCodActividad()+"'"+
                     " and COD_AREA_EMPRESA='"+seguimientoIndirecto.getActividadesProgramaProduccionIndirecto().getAreasEmpresa().getCodAreaEmpresa()+"'"+
                     " and COD_PROGRAMA_PROD='"+seguimientoIndirecto.getProgramaProduccionPeriodo().getCodProgramaProduccion()+"'";
                System.out.println("consulta update programa produccion"+consulta);
                pst=con.prepareStatement(consulta);
                if(pst.executeUpdate()>0)
                {
                    System.out.println("se actualizo el detalle");
                }
                else
                {
                  consulta="INSERT INTO SEGUIMIENTO_PROGRAMA_PRODUCCION_INDIRECTO(COD_PROGRAMA_PROD,"+
                              "COD_ACTIVIDAD, COD_ESTADO_REGISTRO, HORAS_HOMBRE, COD_AREA_EMPRESA)"+
                        "VALUES ('"+seguimientoIndirecto.getProgramaProduccionPeriodo().getCodProgramaProduccion()+"'"+
                        ",'"+seguimientoIndirecto.getActividadesProgramaProduccionIndirecto().getActividadesProduccion().getCodActividad()+
                                "','1','"+suma1+"','"+seguimientoIndirecto.getActividadesProgramaProduccionIndirecto().getAreasEmpresa().getCodAreaEmpresa()+"')";
                    System.out.println("consulta "+consulta);
                    pst=con.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)System.out.println("se registro la cabecera");

                }
             con.commit();
             System.out.println("se registraron lista indirecto "+seguimientoIndirecto.getListaSeguimientoPersonal().size());
             mensaje="registro realizado correctamente";
             pst.close();
             con.close();

         }
         catch(SQLException ex)
         {
             ex.printStackTrace();
             con.rollback();
             mensaje="Ocurrio un error al momento de registro el seguimiento,intente de nuevo";
         }finally{
             con.close();
         }
         //Util.redireccionar("navegador_actividades_indirectas.jsf");
         return null;
  }
  public String cancelarSeguimientoProgramaProduccionIndirecto_action()
  {
      mensaje="";
      Util.redireccionar("navegador_actividades_indirectas.jsf");
      return null;
  }
   private void cargarDetalleSeguimientoIndirectoPersonal()
   {
    String consulta="select sppip.COD_PERSONAL,sppip.HORAS_HOMBRE, sppip.FECHA_INICIO,sppip.FECHA_FINAL " +
                    " from SEGUIMIENTO_PROGRAMA_PRODUCCION_INDIRECTO_PERSONAL sppip "+
                    " where sppip.COD_ACTVIDAD='"+seguimientoIndirecto.getActividadesProgramaProduccionIndirecto().getActividadesProduccion().getCodActividad()+"' and "+
                    " sppip.COD_AREA_EMPRESA='"+seguimientoIndirecto.getActividadesProgramaProduccionIndirecto().getAreasEmpresa().getCodAreaEmpresa()+"' and sppip.COD_PROGRAMA_PROD='"+seguimientoIndirecto.getProgramaProduccionPeriodo().getCodProgramaProduccion()+"'"+
                    " order by sppip.FECHA_INICIO";
        System.out.println("consulta "+consulta);
    try{
        con=Util.openConnection(con);
        Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
        ResultSet res=st.executeQuery(consulta);
        seguimientoIndirecto.getListaSeguimientoPersonal().clear();
        while(res.next())
        {
            SeguimientoProgramaProduccionIndirectoPersonal  insertar= new SeguimientoProgramaProduccionIndirectoPersonal();
            insertar.setHorarHombre(res.getFloat("HORAS_HOMBRE"));
            insertar.setFechaInicio(res.getTimestamp("FECHA_INICIO"));
            insertar.setFechaFinal(res.getTimestamp("FECHA_FINAL"));
            insertar.setHoraInicio(res.getTimestamp("FECHA_INICIO"));
            insertar.setHoraFinal(res.getTimestamp("FECHA_FINAL"));
            insertar.getPersonal().setCodPersonal(res.getString("COD_PERSONAL"));
            seguimientoIndirecto.getListaSeguimientoPersonal().add(insertar);
        }
        st.close();
        res.close();
        con.close();

    }
    catch(SQLException ex)
    {
        ex.printStackTrace();
    }

   }
  public String agregarSeguimientoIndirectas_action(){
        try
        {
            Connection con1=null;
            con1=Util.openConnection(con1);
            Statement st=con1.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
              String consulta="select pp.NOMBRE_PROGRAMA_PROD,pp.OBSERVACIONES from PROGRAMA_PRODUCCION_PERIODO pp where pp.COD_PROGRAMA_PROD='"+codProgramaProd+"'";
              System.out.println("consulta programa Periodo");
              ResultSet res=st.executeQuery(consulta);
              if(res.next())
              {
                programaProduccionPeriodoIndirectas.setCodProgramaProduccion(programaProduccionPeriodoBean.getCodProgramaProduccion());
                programaProduccionPeriodoIndirectas.setNombreProgramaProduccion(res.getString("NOMBRE_PROGRAMA_PROD"));
                programaProduccionPeriodoIndirectas.setObsProgramaProduccion(res.getString("OBSERVACIONES"));
              }
              codProgramaProd=programaProduccionPeriodoBean.getCodProgramaProduccion();
            st.close();
            con1.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
        this.redireccionar("registroActividadesIndirectas/navegador_actividades_indirectas.jsf");
        return null;
    }

    public SeguimientoProgramaProduccionIndirecto getSeguimientoIndirecto() {
        return seguimientoIndirecto;
    }

    public void setSeguimientoIndirecto(SeguimientoProgramaProduccionIndirecto seguimientoIndirecto) {
        this.seguimientoIndirecto = seguimientoIndirecto;
    }

   public void tipoActividad_onChange()
   {
       this.cargarSeguimientoActividadeIndirectas();
   }
   public void cargar_AreasActividades()
   {
       String consulta="SELECT AE.COD_AREA_EMPRESA,AE.NOMBRE_AREA_EMPRESA FROM AREAS_EMPRESA AE WHERE AE.COD_AREA_EMPRESA IN (1001,84,76,40,75,97,96) ORDER BY AE.NOMBRE_AREA_EMPRESA";
       try{
           con=Util.openConnection(con);
           Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
           ResultSet res=st.executeQuery(consulta);
           listaAreasActividad.clear();
           while(res.next())
           {
               listaAreasActividad.add(new SelectItem(res.getString("COD_AREA_EMPRESA"),res.getString("NOMBRE_AREA_EMPRESA")));
           }
           res.close();
           st.close();
           con.close();
       }
       catch(SQLException ex)
       {
           ex.printStackTrace();
       }
   }
   private void cargarAreasEmpresaActividadSelectList()
    {
        try 
        {
            con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select a.COD_AREA_EMPRESA,a.NOMBRE_AREA_EMPRESA");
                                            consulta.append(" from areas_empresa a");
                                                    consulta.append(" inner join AREAS_ACTIVIDAD_PRODUCCION aap on aap.COD_AREA_EMPRESA=a.COD_AREA_EMPRESA");
                                            consulta.append(" order by a.NOMBRE_AREA_EMPRESA asc");
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            listaAreasActividad=new ArrayList<SelectItem>();
            while (res.next()) 
            {
                listaAreasActividad.add(new SelectItem(res.getString("COD_AREA_EMPRESA"),res.getString("NOMBRE_AREA_EMPRESA")));
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
   public String getCargarSeguimientoActividadesIndirectas()
   {
       this.cargarAreasEmpresaActividadSelectList();
       if(codAreaActividadProd.length() == 0)
           codAreaActividadProd = listaAreasActividad.get(0).getValue().toString();
       
       this.cargarSeguimientoActividadeIndirectas();
       
      return null;
   }
   private void cargarPersonal()
   {

       String consulta="select (p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+' '+p.NOMBRES_PERSONAL+' '+p.nombre2_personal) as nombre,p.COD_PERSONAL from PERSONAL p " +
               " inner join AREAS_EMPRESA a on a.COD_AREA_EMPRESA = p.COD_AREA_EMPRESA inner join DIVISION_COMPRAS d on d.COD_DIVISION = a.DIVISION" +
               " where d.COD_DIVISION = 3 and p.COD_ESTADO_PERSONA = 1 order by p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRE_PILA ";
       consulta = " select P.COD_PERSONAL,(P.AP_PATERNO_PERSONAL +' '+P.AP_MATERNO_PERSONAL +' ' +  P.NOMBRES_PERSONAL + ' ' + P.nombre2_personal)  NOMBRES_PERSONAL" +
                    " from  personal P inner join PERSONAL_AREA_PRODUCCION pa on pa.COD_PERSONAL = p.COD_PERSONAL" +
                    " inner join AREAS_EMPRESA a on a.COD_AREA_EMPRESA = p.COD_AREA_EMPRESA and a.DIVISION = 3 " +
                    " where pa.cod_area_empresa in ('"+seguimientoIndirecto.getActividadesProgramaProduccionIndirecto().getAreasEmpresa().getCodAreaEmpresa()+"')" +
                    " AND p.COD_ESTADO_PERSONA=1" +
                    " union select P.COD_PERSONAL,(P.AP_PATERNO_PERSONAL +' '+P.AP_MATERNO_PERSONAL +' ' +  P.NOMBRES_PERSONAL + ' ' + P.nombre2_personal)  NOMBRES_PERSONAL" +
                    " from  personal_temporal P inner join PERSONAL_AREA_PRODUCCION pa on pa.COD_PERSONAL = p.COD_PERSONAL " +
                    " where pa.cod_area_empresa in ('"+seguimientoIndirecto.getActividadesProgramaProduccionIndirecto().getAreasEmpresa().getCodAreaEmpresa()+"')" +
                    " AND p.COD_ESTADO_PERSONA=1 " +
                    " union  select P.COD_PERSONAL,(P.AP_PATERNO_PERSONAL +' '+P.AP_MATERNO_PERSONAL +' ' +  P.NOMBRES_PERSONAL + ' ' + P.nombre2_personal)  NOMBRES_PERSONAL" +
                    " from personal p where p.cod_area_empresa  in ('"+seguimientoIndirecto.getActividadesProgramaProduccionIndirecto().getAreasEmpresa().getCodAreaEmpresa()+"') order by NOMBRES_PERSONAL ";

       System.out.println("consulta " + consulta);
       try{
           con=Util.openConnection(con);
           Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
           ResultSet res=st.executeQuery(consulta);
           listaPersonal.clear();
           while(res.next())
           {
               listaPersonal.add(new SelectItem(res.getString("COD_PERSONAL"),res.getString("nombres_personal")));
           }
           res.close();
           st.close();
           con.close();
       }
       catch(SQLException ex)
       {
           ex.printStackTrace();
       }
   }
   public void cargarSeguimientoActividadeIndirectas()
   {
       String consulta="SELECT ap.NOMBRE_ACTIVIDAD,ap.COD_ACTIVIDAD,ISNULL(sppi.HORAS_HOMBRE,0) as horasHombre"+
                       " FROM  ACTIVIDADES_PRODUCCION ap left outer join SEGUIMIENTO_PROGRAMA_PRODUCCION_INDIRECTO sppi"+
                       " on ap.COD_ACTIVIDAD=sppi.COD_ACTIVIDAD  and sppi.COD_ESTADO_REGISTRO=1"+
                        " and sppi.COD_PROGRAMA_PROD='"+codProgramaProd+"'"+
                        " where ap.COD_ESTADO_REGISTRO=1 and ap.COD_TIPO_ACTIVIDAD=2  and ap.COD_TIPO_ACTIVIDAD_PRODUCCION='"+codAreaActividadProd+"'";
       consulta= "select appi.ORDEN,appi.COD_AREA_EMPRESA, ap.NOMBRE_ACTIVIDAD,ap.COD_ACTIVIDAD,ISNULL(sppi.HORAS_HOMBRE,0) as horasHombre"+
               " ,ae.NOMBRE_AREA_EMPRESA from ACTIVIDADES_PROGRAMA_PRODUCCION_INDIRECTO appi inner join AREAS_EMPRESA ae on ae.COD_AREA_EMPRESA=appi.COD_AREA_EMPRESA inner join ACTIVIDADES_PRODUCCION ap "+
                        " on appi.COD_ACTIVIDAD=ap.COD_ACTIVIDAD and appi.COD_ESTADO_REGISTRO=1 left outer join SEGUIMIENTO_PROGRAMA_PRODUCCION_INDIRECTO sppi on "+
                        "sppi.COD_ACTIVIDAD=appi.COD_ACTIVIDAD and appi.COD_AREA_EMPRESA=sppi.COD_AREA_EMPRESA "+
                        " and sppi.COD_PROGRAMA_PROD='"+codProgramaProd+"'"+
                        " where ap.COD_TIPO_ACTIVIDAD=2 and appi.COD_AREA_EMPRESA='"+codAreaActividadProd+"' order by appi.ORDEN asc ";
       System.out.println("consulta "+consulta);
      try{
          con=Util.openConnection(con);
          Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
          ResultSet res=st.executeQuery(consulta);
          listaSeguimientoIndirecto.clear();
          while (res.next())
          {
              SeguimientoProgramaProduccionIndirecto insertar= new SeguimientoProgramaProduccionIndirecto();
              insertar.getActividadesProgramaProduccionIndirecto().getActividadesProduccion().setCodActividad(res.getInt("COD_ACTIVIDAD"));
              insertar.getActividadesProgramaProduccionIndirecto().getActividadesProduccion().setNombreActividad(res.getString("NOMBRE_ACTIVIDAD"));
              insertar.getActividadesProgramaProduccionIndirecto().getAreasEmpresa().setCodAreaEmpresa(res.getString("COD_AREA_EMPRESA"));
              insertar.getActividadesProgramaProduccionIndirecto().getAreasEmpresa().setNombreAreaEmpresa(res.getString("NOMBRE_AREA_EMPRESA"));
              insertar.getActividadesProgramaProduccionIndirecto().setOrden(res.getInt("ORDEN"));
              insertar.setHorasHombre(res.getFloat("horasHombre"));
              insertar.getProgramaProduccionPeriodo().setCodProgramaProduccion(codProgramaProd);
              listaSeguimientoIndirecto.add(insertar);
          }
          
          res.close();
          st.close();
      }
      catch(SQLException ex)
      {
          ex.printStackTrace();
      }
      finally{
          this.cerrarConexion(con);
      }
   }
   //final alejandro
   //inicio ale devoluciones
    public String cargarRegistroDevolucionesAction()
    {
        String consulta="select m.COD_MATERIAL,m.NOMBRE_MATERIAL,fmd.CANTIDAD,um.ABREVIATURA from  MATERIALES m inner join FORMULA_MAESTRA_DETALLE_EP fmd on m.COD_MATERIAL=fmd.COD_MATERIAL INNER JOIN "+
                        " PRESENTACIONES_PRIMARIAS PP ON PP.COD_PRESENTACION_PRIMARIA=fmd.COD_PRESENTACION_PRIMARIA inner join UNIDADES_MEDIDA um "+
                        " on um.COD_UNIDAD_MEDIDA=fmd.COD_UNIDAD_MEDIDA inner join FORMULA_MAESTRA fm on fm.COD_FORMULA_MAESTRA=fmd.COD_FORMULA_MAESTRA and fm.COD_ESTADO_REGISTRO=1"+
                        " where fmd.COD_FORMULA_MAESTRA='"+programaProduccionSeleccionado.getFormulaMaestra().getCodFormulaMaestra()+"'" +
                        " and pp.COD_TIPO_PROGRAMA_PROD='"+programaProduccionSeleccionado.getTiposProgramaProduccion().getCodTipoProgramaProd()+"'" +
                        " and fm.COD_COMPPROD='"+programaProduccionSeleccionado.getFormulaMaestra().getComponentesProd().getCodCompprod()+"'";
        System.out.println("consulta "+consulta);
        try
        {
            Connection con2= null;
           con2=Util.openConnection(con2);
           Statement st=con2.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
           ResultSet res=st.executeQuery(consulta);
           devolucionesMaterialDetalleList.clear();

           while(res.next())
           {
                ProgramaProduccionDevolucionMaterialDetalle bean= new ProgramaProduccionDevolucionMaterialDetalle();
                bean.getProgramaProduccionDevolucionMaterial().getProgramaProduccion().getFormulaMaestra().getComponentesProd().setCodCompprod(programaProduccionSeleccionado.getFormulaMaestra().getComponentesProd().getCodCompprod());
                bean.getProgramaProduccionDevolucionMaterial().getProgramaProduccion().getTiposProgramaProduccion().setCodTipoProgramaProd(programaProduccionSeleccionado.getTiposProgramaProduccion().getCodTipoProgramaProd());
                bean.getProgramaProduccionDevolucionMaterial().getProgramaProduccion().getFormulaMaestra().setCodFormulaMaestra(programaProduccionSeleccionado.getFormulaMaestra().getCodFormulaMaestra());
                bean.getProgramaProduccionDevolucionMaterial().getProgramaProduccion().setCodProgramaProduccion(programaProduccionSeleccionado.getCodProgramaProduccion());
                bean.getProgramaProduccionDevolucionMaterial().getProgramaProduccion().setCodLoteProduccion(programaProduccionSeleccionado.getCodLoteProduccion());
                bean.getMateriales().setCodMaterial(res.getString("COD_MATERIAL"));
                bean.getMateriales().setNombreMaterial(res.getString("NOMBRE_MATERIAL"));
                bean.getProgramaProduccionDevolucionMaterial().getProgramaProduccion().getFormulaMaestra().setCantidadLote(res.getDouble("CANTIDAD"));
                bean.setCantidadBuenos(0);
                bean.setCantidadMalos(0);
                bean.getMateriales().getUnidadesMedida().setAbreviatura(res.getString("ABREVIATURA"));

                devolucionesMaterialDetalleList.add(bean);
           }
           res.close();
           st.close();
           con2.close();

        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
       return null;
    }
    public String registrarDevolucionesProgramaProduccion()
    {
        try
        {
            Connection con2=null;
            con2=Util.openConnection(con2);
            String consulta="SELECT ISNULL(MAX(ppdm.COD_PROGRAMA_PRODUCCION_DEVOLUCION_MATERIAL),0)+1 AS codProgProdDev FROM PROGRAMA_PRODUCCION_DEVOLUCION_MATERIAL ppdm";
            int codProgProdDev=0;
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta);
            while(res.next())
            {
                codProgProdDev=res.getInt("codProgProdDev");
            }
            res.close();
            st.close();
            ProgramaProduccionDevolucionMaterial bean=devolucionesMaterialDetalleList.get(0).getProgramaProduccionDevolucionMaterial();
            SimpleDateFormat sdt= new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
            //inicio ale cambio devol
            consulta="INSERT INTO PROGRAMA_PRODUCCION_DEVOLUCION_MATERIAL(COD_PROGRAMA_PROD,COD_COMPPROD,COD_FORMULA_MAESTRA,"+
                     " COD_LOTE_PRODUCCION,COD_TIPO_PROGRAMA_PROD,COD_ESTADO_PROGRAMA_PRODUCCION_DEVOLUCION,COD_PROGRAMA_PRODUCCION_DEVOLUCION_MATERIAL"+
                     ",FECHA_REGISTRO)VALUES ('"+bean.getProgramaProduccion().getCodProgramaProduccion()+"','"+bean.getProgramaProduccion().getFormulaMaestra().getComponentesProd().getCodCompprod()+"',"+
                     "'"+bean.getProgramaProduccion().getFormulaMaestra().getCodFormulaMaestra()+"','"+bean.getProgramaProduccion().getCodLoteProduccion()+"',"+
                     "'"+bean.getProgramaProduccion().getTiposProgramaProduccion().getCodTipoProgramaProd()+"',1,"+
                     "'"+codProgProdDev+"','"+sdt.format(new Date())+"')";
            //final ale cambio devol
            System.out.println("consulta para insertar la devolucion "+consulta);
            PreparedStatement pst=con2.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se registro la cabecera de la devolucion del material");
            pst.close();
             for(ProgramaProduccionDevolucionMaterialDetalle current:devolucionesMaterialDetalleList)
            {
                if(current.getChecked())
                {
                   consulta="INSERT INTO PROGRAMA_PRODUCCION_DEVOLUCION_MATERIAL_DETALLE(COD_PROGRAMA_PRODUCCION_DEVOLUCION_MATERIAL, COD_MATERIAL, CANTIDAD_BUENOS,"+
                            " CANTIDAD_BUENOS_ENTREGADOS, CANTIDAD_MALOS, CANTIDAD_MALOS_ENTREGADOS,OBSERVACION)"+
                            " VALUES ('"+codProgProdDev+"','"+current.getMateriales().getCodMaterial() +"','"+current.getCantidadBuenos()+"',0,'"+current.getCantidadMalos()+"',"+
                            "0,'"+current.getObservacion()+"')";
                    System.out.println("consulta para insertar el detalle de la devolucion "+consulta);
                     pst=con2.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)System.out.println("se registro el detalle de devolución");
                    pst.close();
                }
            }
             con2.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
        return null;
    }
    //inicio ale edicion
    public String onChangeProductoAgregar()
    {
            currentProgramaProd=(ProgramaProduccion)programaProduccionAgregarDataTable.getRowData();
            String consulta="select fm.COD_FORMULA_MAESTRA,cp.nombre_prod_semiterminado,cp.COD_COMPPROD,fm.CANTIDAD_LOTE "+
                            " from FORMULA_MAESTRA fm inner join COMPONENTES_PROD cp "+
                            " on fm.COD_COMPPROD=cp.COD_COMPPROD  and fm.COD_ESTADO_REGISTRO=1"+
                            " where cp.COD_COMPPROD='"+currentProgramaProd.getFormulaMaestra().getComponentesProd().getCodCompprod()+"'";
            consulta="select fm.COD_FORMULA_MAESTRA,cp.nombre_prod_semiterminado,cp.COD_COMPPROD,fm.CANTIDAD_LOTE "+
                            " from FORMULA_MAESTRA fm inner join COMPONENTES_PROD cp "+
                            " on fm.COD_COMPPROD=cp.COD_COMPPROD  and fm.COD_ESTADO_REGISTRO=1"+
                            " where fm.cod_formula_maestra='"+currentProgramaProd.getFormulaMaestra().getCodFormulaMaestra()+"'";
            System.out.println("consulta "+consulta);
            try
            {
                Connection con1=null;
                con1=Util.openConnection(con1);
                Statement st=con1.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet res=st.executeQuery(consulta);
                if(res.next())
                {
                    currentProgramaProd.getFormulaMaestra().setCantidadLote(res.getDouble("CANTIDAD_LOTE"));
                    currentProgramaProd.setCantidadLote(res.getDouble("cantidad_lote"));
                    currentProgramaProd.getFormulaMaestra().setCodFormulaMaestra(res.getString("cod_formula_maestra"));
                    currentProgramaProd.getFormulaMaestra().getComponentesProd().setCodCompprod(res.getString("cod_compprod"));
                    currentProgramaProd.getFormulaMaestra().getComponentesProd().setNombreProdSemiterminado(res.getString("nombre_prod_semiterminado"));

                }
                res.close();
                st.close();
                con1.close();
            }
            catch(SQLException ex)
            {
                ex.printStackTrace();
            }
           return null;
    }
    
    public String menosProgramaProduccionAgregar_action()
    {
        List<ProgramaProduccion> nuevaLista=new ArrayList();
        for(ProgramaProduccion bean:programaProduccionAgregarList)
        {
            if(!bean.getChecked())
            {
                nuevaLista.add((ProgramaProduccion)bean.clone());
            }
        }
        programaProduccionAgregarList.clear();
        programaProduccionAgregarList=nuevaLista;
        return null;
    }
    public String guardarAgregarProgramaProduccion_action()throws SQLException
    {
        mensaje="";
        try
        {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=null;
            PreparedStatement pst=null;
            String consulta="";
            //creacion de n cantidad de lotes de acuerdo a lo configurado
            
            // <editor-fold defaultstate="collapsed" desc="verificar producto con datos basicos">
            for(ProgramaProduccion bean:programaProduccionAgregarList)
            {
                consulta="select cpv.PRODUCTO_SEMITERMINADO,"+
                                "(select  count(*)"+
                                " from COMPONENTES_PROD_VERSION cpv1"+
                                " where cpv1.COD_COMPPROD=cpv.COD_COMPPROD"+
                                        " and cpv1.COD_ESTADO_VERSION in (1,3,5)"+
                                        " and cpv1.COD_TIPO_COMPONENTES_PROD_VERSION=1"+
                                " ) as cantidadVersionesEnProceso,"+
                                " ( select count(*) "+
                                " from COMPONENTES_PROD_VERSION cpv2 "+
                                        " inner join FORMULA_MAESTRA_ES_VERSION fmev on fmev.COD_VERSION=cpv2.COD_VERSION"+
                                        " where cpv2.COD_COMPPROD= cpv.COD_COMPPROD"+
                                                " and fmev.COD_ESTADO_VERSION in (1,3,5)"+
                                                " and cpv2.COD_TIPO_COMPONENTES_PROD_VERSION=1"+
                                ") as cantidadVersionesESProceso"+
                                ",cpv.APLICA_ESPECIFICACIONES_FISICAS,cpv.APLICA_ESPECIFICACIONES_QUIMICAS,cpv.APLICA_ESPECIFICACIONES_MICROBIOLOGICAS"+
                         " from COMPONENTES_PROD_VERSION cpv where cpv.COD_VERSION='"+bean.getComponentesProdVersion().getCodVersion()+"'"+
                         " and cpv.COD_COMPPROD='"+bean.getFormulaMaestraVersion().getComponentesProd().getCodCompprod()+"'";
                LOGGER.debug("consulta verificar producto semiterminado "+consulta);
                res=st.executeQuery(consulta);
                res.next();
                //verificamos que no existe ninguna version es proceso de desarollo
                if(res.getInt("cantidadVersionesEnProceso")==0&&res.getInt("cantidadVersionesESProceso")==0)
                {
                    boolean aplicaEspecificacionesFisicas=res.getInt("APLICA_ESPECIFICACIONES_FISICAS")>0;
                    boolean aplicaEspecificacionesQuimicas=res.getInt("APLICA_ESPECIFICACIONES_QUIMICAS")>0;
                    boolean aplicaEspecificacionesMicrobiologicas=res.getInt("APLICA_ESPECIFICACIONES_MICROBIOLOGICAS")>0;
                        //verificamos si no es un producto semiterminado para validar algunos aspectos del producto
                        if(res.getInt("PRODUCTO_SEMITERMINADO")==0)
                        {
                            //<editor-fold desc="verificamos que tenga especificacion quimicas de CC">
                                if(aplicaEspecificacionesQuimicas)
                                {
                                    consulta="select count(*) as contador from ESPECIFICACIONES_QUIMICAS_PRODUCTO e where e.COD_VERSION='"+bean.getComponentesProdVersion().getCodVersion()+"'";
                                    LOGGER.debug("consulta verificar esp quim"+consulta);
                                    res=st.executeQuery(consulta);
                                    res.next();
                                    if(res.getInt("contador")==0)mensaje="No se puede crear el lote del producto "+bean.getFormulaMaestraVersion().getComponentesProd().getNombreProdSemiterminado()+" porque no cuenta con especificaciones Quimicas";
                                }
                            //</editor-fold>    
                            //<editor-fold desc="verificamos que tenga registrada la concentracion">
                                consulta="select count(*) as contador from COMPONENTES_PROD_CONCENTRACION e where e.COD_VERSION='"+bean.getComponentesProdVersion().getCodVersion()+"'";
                                LOGGER.debug("consulta verificar concentracion"+consulta);
                                res=st.executeQuery(consulta);
                                res.next();
                                if(res.getInt("contador")==0)mensaje="No se puede crear el lote del producto "+bean.getFormulaMaestraVersion().getComponentesProd().getNombreProdSemiterminado()+" porque no cuenta con concentración registrada";
                            //</editor-fold>    
                            //<editor-fold desc="verificamos que tenga ep">
                                consulta="select count(*) as contador from FORMULA_MAESTRA_DETALLE_EP_VERSION f inner join PRESENTACIONES_PRIMARIAS pp on pp.COD_PRESENTACION_PRIMARIA=f.COD_PRESENTACION_PRIMARIA" +
                                         " and pp.COD_TIPO_PROGRAMA_PROD='"+bean.getTiposProgramaProduccion().getCodTipoProgramaProd()+"' where f.COD_VERSION='"+bean.getFormulaMaestraVersion().getCodVersion()+"'";
                                LOGGER.debug("consulta verificar ep "+consulta);
                                res=st.executeQuery(consulta);
                                res.next();
                                if(res.getInt("contador")==0)mensaje="No se puede crear el lote del producto "+bean.getFormulaMaestraVersion().getComponentesProd().getNombreProdSemiterminado()+" porque no cuenta con empaque primario";
                            //</editor-fold>
                            //<editor-fold desc="verificamos que tenga es">
                                consulta="select count(*) as contador from FORMULA_MAESTRA_DETALLE_ES_VERSION f where f.COD_TIPO_PROGRAMA_PROD='"+bean.getTiposProgramaProduccion().getCodTipoProgramaProd()+"'"
                                        + " and f.COD_PRESENTACION_PRODUCTO='"+bean.getPresentacionesProducto().getCodPresentacion()+"' and  f.COD_VERSION='"+bean.getFormulaMaestraVersion().getCodVersion()+"'";
                                LOGGER.debug("consulta verificar es "+consulta);
                                res=st.executeQuery(consulta);
                                res.next();
                                if(res.getInt("contador")==0)mensaje="No se puede crear el lote del producto "+bean.getFormulaMaestraVersion().getComponentesProd().getNombreProdSemiterminado()+" porque no cuenta con empaque secundario";
                            //</editor-fold>
                        }
                        //<editor-fold desc="verificamos que tenga especificacion fisicas del producto">
                            if(aplicaEspecificacionesFisicas)
                            {
                                consulta="select count(*) as contador from ESPECIFICACIONES_FISICAS_PRODUCTO e where e.COD_VERSION='"+bean.getComponentesProdVersion().getCodVersion()+"'";
                                LOGGER.debug("consulta verificar esp fis"+consulta);
                                res=st.executeQuery(consulta);
                                res.next();
                                if(res.getInt("contador")==0)mensaje="No se puede crear el lote del producto "+bean.getFormulaMaestraVersion().getComponentesProd().getNombreProdSemiterminado()+" porque no cuenta con especificaciones fisicas";
                            }
                        //</editor-fold>
                        //<editor-fold desc="verificamos que tenga especificacion microbiologicas">
                            if(aplicaEspecificacionesMicrobiologicas)
                            {
                                consulta="select count(*) as contador from ESPECIFICACIONES_MICROBIOLOGIA_PRODUCTO e where e.COD_VERSION='"+bean.getComponentesProdVersion().getCodVersion()+"'";
                                LOGGER.debug("consulta verificar esp micro"+consulta);
                                res=st.executeQuery(consulta);
                                res.next();
                                if(res.getInt("contador")==0)mensaje="No se puede crear el lote del producto "+bean.getFormulaMaestraVersion().getComponentesProd().getNombreProdSemiterminado()+" porque no cuenta con especificaciones microbiológicas";
                            }
                        //</editor-fold>
                        //<editor-fold desc="verificamos que tenga materia prima">
                            consulta="select count(*) as contador from FORMULA_MAESTRA_DETALLE_MP_VERSION f where f.COD_VERSION='"+bean.getFormulaMaestraVersion().getCodVersion()+"'";
                            LOGGER.debug("consulta verificar materia prima"+consulta);
                            res=st.executeQuery(consulta);
                            res.next();
                            if(res.getInt("contador")==0)mensaje="No se puede crear el lote del producto "+bean.getFormulaMaestraVersion().getComponentesProd().getNombreProdSemiterminado()+" porque no cuenta con materia prima en su formula maestra";
                        //</editor-fold>
                        //<editor-fold desc="verificamos que tenga material reactivo">
                            consulta="select count(*) as contador from FORMULA_MAESTRA_DETALLE_MR_VERSION f where f.COD_VERSION='"+bean.getFormulaMaestraVersion().getCodVersion()+"'";
                            LOGGER.debug("consulta verificar material reactivo"+consulta);
                            res=st.executeQuery(consulta);
                            res.next();
                            if(res.getInt("contador")==0)mensaje="No se puede crear el lote del producto "+bean.getFormulaMaestraVersion().getComponentesProd().getNombreProdSemiterminado()+" porque no cuenta con material reactivo en su formula maestra";
                        //</editor-fold>
                        
                }
                else
                {
                    mensaje="No se puede crear lotes del producto "+bean.getFormulaMaestraVersion().getComponentesProd().getNombreProdSemiterminado()+", porque se encuentra en proceso de versionamiento ";
                }
                
                
            }
            //</editor-fold>
            
            if(mensaje.equals(""))
            {
                for(int i=0;i<programaProduccionCabecera.getNroLotes();i++)
                {
                    String codLoteProduccion="";
                    // <editor-fold defaultstate="collapsed" desc="asignacion de nro lote">
                        ProgramaProduccion programa = programaProduccionAgregarList.get(0);
                        consulta =  "exec PAA_LISTAR_NRO_LOTE_ASIGNAR "
                                    + programaProduccionPeriodoBean.getCodProgramaProduccion() + ","
                                    + programa.getComponentesProdVersion().getCodVersion() + ","
                                    + programa.getFormulaMaestraEsVersion().getCodFormulaMaestraEsVersion() + ","
                                    + programa.getTiposProgramaProduccion().getCodTipoProgramaProd() + ","
                                    + programa.getPresentacionesProducto().getCodPresentacion() + ","
                                    + "?";
                        LOGGER.debug("consulta obtener numero de lote "+consulta);
                        CallableStatement callNumeroLote =con.prepareCall(consulta);
                        callNumeroLote.registerOutParameter(1,java.sql.Types.VARCHAR);
                        callNumeroLote.execute();
                        codLoteProduccion = callNumeroLote.getString(1);
                     //</editor-fold>
                    // <editor-fold defaultstate="collapsed" desc="verificacion de lote ya existente">
                    if(!codLoteProduccion.contains("S"))
                    {
                        consulta="select count(*) as contLotes from PROGRAMA_PRODUCCION p where p.COD_LOTE_PRODUCCION='"+codLoteProduccion+"'";
                        LOGGER.debug("consulta verificar lote existente "+consulta);
                        res=st.executeQuery(consulta);
                        res.next();
                        if(res.getInt("contLotes")>0)
                        {
                            LOGGER.info("el numero de lote ingresado ya se encuentra asignado");
                            mensaje="el/los numeros que corresponden a los lote:"+codLoteProduccion+" ya se encuentran registrados en otro programa de producción";
                            con.rollback();
                            con.close();
                            return null;
                        }
                    }

                    //</editor-fold>
                    for(ProgramaProduccion bean:programaProduccionAgregarList)
                    {
                        consulta = " insert into programa_produccion(cod_programa_prod,cod_formula_maestra,cod_lote_produccion, " +
                                " cod_estado_programa,observacion,CANT_LOTE_PRODUCCION,VERSION_LOTE,COD_COMPPROD,COD_TIPO_PROGRAMA_PROD,COD_PRESENTACION,nro_lotes" +
                                ",COD_COMPPROD_PADRE,cod_compprod_version,cod_formula_maestra_version,FECHA_REGISTRO,COD_FORMULA_MAESTRA_ES_VERSION)" +
                                " values('"+programaProduccionPeriodoBean.getCodProgramaProduccion()+"','"+bean.getFormulaMaestraVersion().getCodFormulaMaestra()+"'," +
                                "'"+codLoteProduccion+"',2,'','"+bean.getCantidadLote()+"',1, " +
                                " '"+bean.getFormulaMaestraVersion().getComponentesProd().getCodCompprod()+"'," +
                                "'"+bean.getTiposProgramaProduccion().getCodTipoProgramaProd()+"', " +
                                "'"+bean.getPresentacionesProducto().getCodPresentacion()+"',1," +
                                ""+programaProduccionCabecera.getFormulaMaestraVersion().getComponentesProd().getCodCompprod()+"," +
                                "'"+bean.getComponentesProdVersion().getCodVersion()+"','"+bean.getFormulaMaestraVersion().getCodVersion()+"'" +
                                ",GETDATE()"+
                                ","+bean.getFormulaMaestraEsVersion().getCodFormulaMaestraEsVersion()+
                                ")";
                        LOGGER.debug("consulta registrar programa Produccion " + consulta);
                        pst=con.prepareStatement(consulta);
                        if(pst.executeUpdate()>0)LOGGER.info("se registro el programa de produccion");

                    }
                    consulta="EXEC PAA_REGISTRO_PROGRAMA_PRODUCCION_DETALLE "+
                            programaProduccionPeriodoBean.getCodProgramaProduccion()+","+
                            "'"+codLoteProduccion+"'";
                    LOGGER.debug("consulta REGISTRAR PROGRAMA PRODUCCION DETALLE "+consulta);
                    pst=con.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)LOGGER.info("se guardo la materia prima");
                    
                    ManagedAccesoSistema managed = (ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
                    int codTipoTransaccionLog = 3;
                    consulta = "exec PAA_REGISTRO_PROGRAMA_PRODUCCION_LOG "
                                    +"'"+codLoteProduccion+"',"
                                    +programaProduccionPeriodoBean.getCodProgramaProduccion()+","
                                    +managed.getUsuarioModuloBean().getCodUsuarioGlobal()+","
                                    +codTipoTransaccionLog+","
                                    +"0,"//codigo desviacion
                                    +"'creacion de lote'";
                    LOGGER.debug("consulta registrar programa produccion log "+consulta);
                    pst = con.prepareStatement(consulta);
                    pst.executeUpdate();
                }
                mensaje="1";
            }
            con.commit();
            if(pst!=null)pst.close();
            if(res!=null)res.close();
            con.close();
        }
        catch (SQLException ex) {
            con.rollback();
            con.close();
            mensaje="Ocurrio un error al momento de registrar los lotes, intente de nuevo";
            LOGGER.warn("error", ex);
        }
        return null;
    }
    public void cargarProductosParaAdicionarDivision(String codFormulaMaestra) {
        try {
            setCon(Util.openConnection(getCon()));
            String sql = "select fm.COD_FORMULA_MAESTRA,c.nombre_prod_semiterminado,fm.CANTIDAD_LOTE"+
                         " from FORMULA_MAESTRA fm inner join COMPONENTES_PROD c on fm.COD_COMPPROD=c.COD_COMPPROD"+
                         " inner join PRODUCTOS_DIVISION_LOTES pdl on c.COD_COMPPROD=pdl.COD_COMPPROD_DIVISION"+
                         " where pdl.COD_COMPPROD=(select fm1.COD_COMPPROD from FORMULA_MAESTRA fm1 where fm1.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"') ";

            System.out.println("sql " + sql);

            ResultSet rs = null;
            Statement st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

                productosDivisiblesList.clear();
                rs = st.executeQuery(sql);
                productosDivisiblesList.add(new SelectItem("0", "Seleccione una Opción"));
                loteDivisible="0";
                while (rs.next()) {
                    loteDivisible="1";
                    productosDivisiblesList.add(new SelectItem(rs.getString(1), rs.getString(2) + " " + rs.getString(3)));
               }

                rs.close();
                st.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    //se manejara de acuerdo a la formula maestra
    //inicial para el cargado de acuerdo al producto
    public List<SelectItem> cargarProductosParaDivisionEdicionList(String codCompProd,String nombreProdSemiterminado,String codTipoProgramaProd,Double cantidadLote) {
        List<SelectItem>listaProductosDivisibles= new ArrayList<SelectItem>();
        try {
            Connection con1=Util.openConnection(con);

            String consulta= "select fm.cod_formula_maestra,pdl.COD_COMPPROD_DIVISION,cp.nombre_prod_semiterminado,fm.cantidad_lote "+
                             " from PRODUCTOS_DIVISION_LOTES pdl inner join COMPONENTES_PROD cp"+
                             " on cp.COD_COMPPROD=pdl.COD_COMPPROD_DIVISION inner join formula_maestra fm on fm.cod_compprod = cp.cod_compprod and fm.cod_estado_registro = 1"+
                             " where pdl.COD_COMPPROD='"+codCompProd+"' and pdl.COD_TIPO_PROGRAMA_PRODUCCION='"+codTipoProgramaProd+"'" +
                             " union all" +
                             " select fm.COD_FORMULA_MAESTRA,0,c.nombre_prod_semiterminado,fm.CANTIDAD_LOTE from COMPONENTES_PROD c inner join FORMULA_MAESTRA fm on fm.COD_COMPPROD = c.COD_COMPPROD" +
                             " where c.COD_COMPPROD = '"+codCompProd+"' and fm.COD_ESTADO_REGISTRO = 1 and c.COD_TIPO_PRODUCCION = 1 and c.COD_ESTADO_COMPPROD = 1 ";
            System.out.println("consulta productos divisibles" +consulta);
            Statement st=con1.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta);
            listaProductosDivisibles.clear();
            //System.out.println("el lote "  + cantidadLote);
            //listaProductosDivisibles.add( new SelectItem(codCompProd.trim(),nombreProdSemiterminado+" " + cantidadLote));
            while(res.next())
            {
                listaProductosDivisibles.add(new SelectItem(res.getString("cod_formula_maestra"),res.getString("nombre_prod_semiterminado")+" " + res.getDouble("cantidad_lote"))); //COD_COMPPROD_DIVISION
            }
            
            res.close();
            st.close();
            con.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return listaProductosDivisibles;
    }
    //cargar de acuerdo a la formula maestra
    public List<SelectItem> cargarProductosParaDivisionEdicionList1(String codFormulaMaestra,String nombreProdSemiterminado,String codTipoProgramaProd,Double cantidadLote,ProgramaProduccion p) {
        List<SelectItem>listaProductosDivisibles= new ArrayList<SelectItem>();
        try {
            Connection con1=Util.openConnection(con);

            String consulta= "select fm.cod_formula_maestra,pdl.COD_COMPPROD_DIVISION,cp.nombre_prod_semiterminado,fm.cantidad_lote "+
                             " from PRODUCTOS_DIVISION_LOTES pdl inner join COMPONENTES_PROD cp"+
                             " on cp.COD_COMPPROD=pdl.COD_COMPPROD_DIVISION inner join formula_maestra fm on fm.cod_compprod = cp.cod_compprod and fm.cod_estado_registro = 1"+
                             " inner join formula_maestra fm1 on fm1.cod_compprod = pdl.cod_compprod where fm1.cod_formula_maestra='"+p.getFormulaMaestra().getCodFormulaMaestra()+"' and pdl.COD_TIPO_PROGRAMA_PRODUCCION='"+codTipoProgramaProd+"'" +
                             " union all select fm.COD_FORMULA_MAESTRA,0,c.nombre_prod_semiterminado,fm.CANTIDAD_LOTE from COMPONENTES_PROD c inner join FORMULA_MAESTRA fm on fm.COD_COMPPROD = c.COD_COMPPROD" +
                             " where fm.cod_formula_maestra = '"+p.getFormulaMaestra().getCodFormulaMaestra()+"' and fm.COD_ESTADO_REGISTRO = 1 and c.COD_TIPO_PRODUCCION = 1 and c.COD_ESTADO_COMPPROD = 1 ";
            System.out.println("consulta productos divisibles" +consulta);
            Statement st=con1.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta);
            listaProductosDivisibles.clear();
            //System.out.println("el lote "  + cantidadLote);
            //listaProductosDivisibles.add( new SelectItem(codFormulaMaestra.trim(),nombreProdSemiterminado+" " + cantidadLote));
            while(res.next())
            {
                listaProductosDivisibles.add(new SelectItem(res.getString("cod_formula_maestra"),res.getString("nombre_prod_semiterminado")+" " + res.getDouble("cantidad_lote"))); //COD_COMPPROD_DIVISION
            }
            if(listaProductosDivisibles.size()==0){
                listaProductosDivisibles.add( new SelectItem(codFormulaMaestra.trim(),nombreProdSemiterminado+" " + cantidadLote));
            }


            res.close();
            st.close();
            con.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return listaProductosDivisibles;
    }
    
    public List cargarVersionesFormulaMaestra(ProgramaProduccion p) {
        List versionesList = new ArrayList();
        try {
            setCon(Util.openConnection(getCon()));
            String sql = " select cod_version,nro_version from formula_maestra_version where cod_formula_maestra = '"+p.getFormulaMaestra().getCodFormulaMaestra()+"' ";
            System.out.println(" sql:" + sql);
            ResultSet rs = null;
            Statement st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);


                versionesList.clear();
                rs = st.executeQuery(sql);
                versionesList.add(new SelectItem("0", "Seleccione una Opción"));
                while (rs.next()) {
                    versionesList.add(new SelectItem(rs.getString("cod_version"), rs.getString("nro_version")));
                }
                rs.close();
                st.close();

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return versionesList;
    }
    public List cargarTiposProgramaProd1() {
        List tiposProgramaProdList = new ArrayList();
        try {
            setCon(Util.openConnection(getCon()));
            String sql = "select a.COD_TIPO_PROGRAMA_PROD, a.NOMBRE_TIPO_PROGRAMA_PROD from TIPOS_PROGRAMA_PRODUCCION a where a.cod_estado_registro=1" +
                    "  order by a.COD_TIPO_PROGRAMA_PROD";
            System.out.println(" sql:" + sql);
            ResultSet rs = null;
            Statement st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);


                tiposProgramaProdList.clear();
                rs = st.executeQuery(sql);
                tiposProgramaProdList.add(new SelectItem("0", "Seleccione una Opción"));
                while (rs.next()) {
                    tiposProgramaProdList.add(new SelectItem(rs.getString(1), rs.getString(2)));
                }
                rs.close();
                st.close();

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tiposProgramaProdList;
    }
    
    public List cargarFormulaMaestraDetalleMPEditar(ProgramaProduccion bean){
        List formulaMaestraMPList = new ArrayList();
        try {
            String consulta = " select m.cod_material,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA, mp.CANTIDAD,um.COD_UNIDAD_MEDIDA, m.cod_grupo " +
                    " from FORMULA_MAESTRA_DETALLE_MP mp, MATERIALES m, UNIDADES_MEDIDA um " +
                    " where m.COD_MATERIAL = mp.cod_material and um.COD_UNIDAD_MEDIDA = m.COD_UNIDAD_MEDIDA " +
                    " and mp.cod_formula_maestra = '"+bean.getFormulaMaestra().getCodFormulaMaestra()+"' " +
                    " order by m.NOMBRE_MATERIAL ";
            System.out.println("consulta MP" + consulta );
            formulaMaestraMPList.clear();
            Connection con1=null;
            con1 = Util.openConnection(con1);
            Statement st = con1.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta);
            while(res.next()){
                FormulaMaestraDetalleMP formulaMaestraDetalleMP = new FormulaMaestraDetalleMP();
                formulaMaestraDetalleMP.getMateriales().setCodMaterial(res.getString("cod_material"));
                formulaMaestraDetalleMP.getMateriales().setNombreMaterial(res.getString("NOMBRE_MATERIAL"));
                formulaMaestraDetalleMP.getUnidadesMedida().setCodUnidadMedida(res.getString("COD_UNIDAD_MEDIDA"));
                formulaMaestraDetalleMP.getUnidadesMedida().setNombreUnidadMedida(res.getString("NOMBRE_UNIDAD_MEDIDA"));
                System.out.println("factor " + bean.getCantidadLote()+" "+bean.getFormulaMaestra().getCantidadLote());
                formulaMaestraDetalleMP.setCantidad(res.getDouble("CANTIDAD")*bean.getCantidadLote()/bean.getFormulaMaestra().getCantidadLote());
                formulaMaestraMPList.add(formulaMaestraDetalleMP);
            }
            st.close();
            con1.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return formulaMaestraMPList;
    }
    public List cargarFormulaMaestraDetalleVersionMPEditar(ProgramaProduccion bean){
        List formulaMaestraMPList = new ArrayList();
        try {
            String consulta = " select m.cod_material,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA, mp.CANTIDAD,um.COD_UNIDAD_MEDIDA, m.cod_grupo " +
                    " from FORMULA_MAESTRA_DETALLE_MP_VERSION mp, MATERIALES m, UNIDADES_MEDIDA um " +
                    " where m.COD_MATERIAL = mp.cod_material and um.COD_UNIDAD_MEDIDA = m.COD_UNIDAD_MEDIDA " +
                    " and mp.cod_formula_maestra = '"+bean.getFormulaMaestra().getCodFormulaMaestra()+"' and mp.cod_version = '"+bean.getFormulaMaestraVersion().getCodVersion()+"' " +
                    " order by m.NOMBRE_MATERIAL ";
            consulta = " select m.cod_material,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA, mp.CANTIDAD,um.COD_UNIDAD_MEDIDA, m.cod_grupo " +
                    " from FORMULA_MAESTRA_DETALLE_MP_VERSION mp, MATERIALES m, UNIDADES_MEDIDA um " +
                    " where m.COD_MATERIAL = mp.cod_material and um.COD_UNIDAD_MEDIDA = m.COD_UNIDAD_MEDIDA " +
                    " and mp.cod_formula_maestra = '"+bean.getFormulaMaestra().getCodFormulaMaestra()+"' and mp.cod_version = (select f.COD_VERSION from FORMULA_MAESTRA_VERSION f where f.COD_ESTADO_VERSION_FORMULA_MAESTRA = 2 and f.COD_FORMULA_MAESTRA = '"+bean.getFormulaMaestra().getCodFormulaMaestra()+"') " +
                    " order by m.NOMBRE_MATERIAL ";
            System.out.println("consulta MP" + consulta );
            formulaMaestraMPList.clear();
            Connection con1=null;
            con1 = Util.openConnection(con1);
            Statement st = con1.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta);
            while(res.next()){
                FormulaMaestraDetalleMP formulaMaestraDetalleMP = new FormulaMaestraDetalleMP();
                formulaMaestraDetalleMP.getMateriales().setCodMaterial(res.getString("cod_material"));
                formulaMaestraDetalleMP.getMateriales().setNombreMaterial(res.getString("NOMBRE_MATERIAL"));
                formulaMaestraDetalleMP.getUnidadesMedida().setCodUnidadMedida(res.getString("COD_UNIDAD_MEDIDA"));
                formulaMaestraDetalleMP.getUnidadesMedida().setNombreUnidadMedida(res.getString("NOMBRE_UNIDAD_MEDIDA"));
                System.out.println("factor " + bean.getCantidadLote()+" "+bean.getFormulaMaestra().getCantidadLote());
                formulaMaestraDetalleMP.setCantidad(res.getDouble("CANTIDAD")*bean.getCantidadLote()/bean.getFormulaMaestra().getCantidadLote());
                formulaMaestraMPList.add(formulaMaestraDetalleMP);
            }
            st.close();
            con1.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return formulaMaestraMPList;
    }


     public List cargarFormulaMaestraDetalleMREditar(ProgramaProduccion bean){
        List formulaMaestraMPList = new ArrayList();
        try {
            String consulta = " select m.cod_material,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA,mp.CANTIDAD,um.COD_UNIDAD_MEDIDA " +
                    " from FORMULA_MAESTRA_DETALLE_MR mp, MATERIALES m,UNIDADES_MEDIDA um " +
                    " where m.COD_MATERIAL = mp.cod_material " +
                    " and um.COD_UNIDAD_MEDIDA = m.COD_UNIDAD_MEDIDA " +
                    " and mp.cod_formula_maestra = '"+bean.getFormulaMaestra().getCodFormulaMaestra()+"' ";

            System.out.println("consulta MR" + consulta );
            formulaMaestraMPList.clear();
            Connection con1 =null;
            con1=Util.openConnection(con1);
            Statement st = con1.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta);
            while(res.next()){

                FormulaMaestraDetalleMP formulaMaestraDetalleMP = new FormulaMaestraDetalleMP();
                formulaMaestraDetalleMP.getMateriales().setChecked(true);
                formulaMaestraDetalleMP.getMateriales().setCodMaterial(res.getString("cod_material"));
                formulaMaestraDetalleMP.getMateriales().setNombreMaterial(res.getString("NOMBRE_MATERIAL"));
                formulaMaestraDetalleMP.getUnidadesMedida().setCodUnidadMedida(res.getString("COD_UNIDAD_MEDIDA"));
                formulaMaestraDetalleMP.getUnidadesMedida().setNombreUnidadMedida(res.getString("NOMBRE_UNIDAD_MEDIDA"));
                formulaMaestraDetalleMP.setCantidad(res.getDouble("CANTIDAD")*bean.getCantidadLote()/bean.getFormulaMaestra().getCantidadLote());
                formulaMaestraMPList.add(formulaMaestraDetalleMP);
            }
            res.close();
            st.close();
            con1.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return formulaMaestraMPList;
    }
     public List cargarFormulaMaestraDetalleVersionMREditar(ProgramaProduccion bean){
        List formulaMaestraMPList = new ArrayList();
        try {
            String consulta = " select m.cod_material,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA,mp.CANTIDAD,um.COD_UNIDAD_MEDIDA " +
                    " from FORMULA_MAESTRA_DETALLE_MR_VERSION mp, MATERIALES m,UNIDADES_MEDIDA um " +
                    " where m.COD_MATERIAL = mp.cod_material " +
                    " and um.COD_UNIDAD_MEDIDA = m.COD_UNIDAD_MEDIDA " +
                    " and mp.cod_formula_maestra = '"+bean.getFormulaMaestra().getCodFormulaMaestra()+"' and mp.cod_version = '"+bean.getFormulaMaestraVersion().getCodVersion()+"' ";
            consulta = " select m.cod_material,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA,mp.CANTIDAD,um.COD_UNIDAD_MEDIDA " +
                    " from FORMULA_MAESTRA_DETALLE_MR_VERSION mp, MATERIALES m,UNIDADES_MEDIDA um " +
                    " where m.COD_MATERIAL = mp.cod_material " +
                    " and um.COD_UNIDAD_MEDIDA = m.COD_UNIDAD_MEDIDA " +
                    " and mp.cod_formula_maestra = '"+bean.getFormulaMaestra().getCodFormulaMaestra()+"' and mp.cod_version = (select f.COD_VERSION from FORMULA_MAESTRA_VERSION f where f.COD_ESTADO_VERSION_FORMULA_MAESTRA = 2 and f.COD_FORMULA_MAESTRA =  '"+bean.getFormulaMaestra().getCodFormulaMaestra()+"') ";

            System.out.println("consulta MR" + consulta );
            formulaMaestraMPList.clear();
            Connection con1 =null;
            con1=Util.openConnection(con1);
            Statement st = con1.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta);
            while(res.next()){

                FormulaMaestraDetalleMP formulaMaestraDetalleMP = new FormulaMaestraDetalleMP();
                formulaMaestraDetalleMP.getMateriales().setChecked(true);
                formulaMaestraDetalleMP.getMateriales().setCodMaterial(res.getString("cod_material"));
                formulaMaestraDetalleMP.getMateriales().setNombreMaterial(res.getString("NOMBRE_MATERIAL"));
                formulaMaestraDetalleMP.getUnidadesMedida().setCodUnidadMedida(res.getString("COD_UNIDAD_MEDIDA"));
                formulaMaestraDetalleMP.getUnidadesMedida().setNombreUnidadMedida(res.getString("NOMBRE_UNIDAD_MEDIDA"));
                formulaMaestraDetalleMP.setCantidad(res.getDouble("CANTIDAD")*bean.getCantidadLote()/bean.getFormulaMaestra().getCantidadLote());
                formulaMaestraMPList.add(formulaMaestraDetalleMP);
            }
            res.close();
            st.close();
            con1.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return formulaMaestraMPList;
    }
     public List cargarFormulaMaestraDetalleEPEditar(ProgramaProduccion bean){
        List formulaMaestraEPList = new ArrayList();
        try {
           String consulta = " select m.cod_material, m.NOMBRE_MATERIAL, um.NOMBRE_UNIDAD_MEDIDA, mp.CANTIDAD, um.COD_UNIDAD_MEDIDA " +
                    " from FORMULA_MAESTRA_DETALLE_EP mp,  MATERIALES m, UNIDADES_MEDIDA um, PRESENTACIONES_PRIMARIAS prp " +
                    " where m.COD_MATERIAL = mp.cod_material " +
                    " and um.COD_UNIDAD_MEDIDA = m.COD_UNIDAD_MEDIDA " +
                    " and prp.COD_PRESENTACION_PRIMARIA = mp.COD_PRESENTACION_PRIMARIA " +
                    " and prp.COD_TIPO_PROGRAMA_PROD = '"+bean.getTiposProgramaProduccion().getCodTipoProgramaProd()+"' " +
                    " and mp.cod_formula_maestra = '"+bean.getFormulaMaestra().getCodFormulaMaestra()+"' " +
                    " and prp.COD_ESTADO_REGISTRO = 1" +
                    " and prp.COD_COMPPROD = (select top 1 f.cod_compprod from formula_maestra f where f.cod_formula_maestra = '"+bean.getFormulaMaestra().getCodFormulaMaestra()+"' and f.cod_estado_registro = 1) ";
            System.out.println("consulta ES " + consulta );
            formulaMaestraEPList.clear();
            Connection con1=null;
            con1= Util.openConnection(con1);
            Statement st = con1.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta);
            while(res.next()){

                FormulaMaestraDetalleMP formulaMaestraDetalleMP = new FormulaMaestraDetalleMP();
                formulaMaestraDetalleMP.getMateriales().setChecked(true);
                formulaMaestraDetalleMP.getMateriales().setCodMaterial(res.getString("cod_material"));
                formulaMaestraDetalleMP.getMateriales().setNombreMaterial(res.getString("NOMBRE_MATERIAL"));
                formulaMaestraDetalleMP.getUnidadesMedida().setCodUnidadMedida(res.getString("COD_UNIDAD_MEDIDA"));
                formulaMaestraDetalleMP.getUnidadesMedida().setNombreUnidadMedida(res.getString("NOMBRE_UNIDAD_MEDIDA"));
                formulaMaestraDetalleMP.setCantidad(res.getDouble("CANTIDAD")*bean.getCantidadLote()/bean.getFormulaMaestra().getCantidadLote());
                formulaMaestraEPList.add(formulaMaestraDetalleMP);
            }
            res.close();
            st.close();
            con1.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return formulaMaestraEPList;
    }
     public List cargarFormulaMaestraDetalleVersionEPEditar(ProgramaProduccion bean){
        List formulaMaestraEPList = new ArrayList();
        try {
           String consulta = " select m.cod_material, m.NOMBRE_MATERIAL, um.NOMBRE_UNIDAD_MEDIDA, mp.CANTIDAD, um.COD_UNIDAD_MEDIDA " +
                    " from FORMULA_MAESTRA_DETALLE_EP_VERSION mp,  MATERIALES m, UNIDADES_MEDIDA um, PRESENTACIONES_PRIMARIAS prp " +
                    " where m.COD_MATERIAL = mp.cod_material " +
                    " and um.COD_UNIDAD_MEDIDA = m.COD_UNIDAD_MEDIDA " +
                    " and prp.COD_PRESENTACION_PRIMARIA = mp.COD_PRESENTACION_PRIMARIA " +
                    " and prp.COD_TIPO_PROGRAMA_PROD = '"+bean.getTiposProgramaProduccion().getCodTipoProgramaProd()+"'" +
                    //" and prp.cod_version = '"+bean.getFormulaMaestraVersion().getCodVersion()+"' " +
                    " and mp.cod_formula_maestra = '"+bean.getFormulaMaestra().getCodFormulaMaestra()+"' " +
                    " and prp.COD_ESTADO_REGISTRO = 1" +
                    " and prp.COD_COMPPROD = (select top 1 f.cod_compprod from formula_maestra f where f.cod_formula_maestra = '"+bean.getFormulaMaestra().getCodFormulaMaestra()+"' and f.cod_estado_registro = 1)" +
                    " and mp.cod_version = (select f.COD_VERSION from FORMULA_MAESTRA_VERSION f where f.COD_ESTADO_VERSION_FORMULA_MAESTRA = 2 and f.COD_FORMULA_MAESTRA = '"+bean.getFormulaMaestra().getCodFormulaMaestra()+"') ";
            System.out.println("consulta ES " + consulta );
            formulaMaestraEPList.clear();
            Connection con1=null;
            con1= Util.openConnection(con1);
            Statement st = con1.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta);
            while(res.next()){

                FormulaMaestraDetalleMP formulaMaestraDetalleMP = new FormulaMaestraDetalleMP();
                formulaMaestraDetalleMP.getMateriales().setChecked(true);
                formulaMaestraDetalleMP.getMateriales().setCodMaterial(res.getString("cod_material"));
                formulaMaestraDetalleMP.getMateriales().setNombreMaterial(res.getString("NOMBRE_MATERIAL"));
                formulaMaestraDetalleMP.getUnidadesMedida().setCodUnidadMedida(res.getString("COD_UNIDAD_MEDIDA"));
                formulaMaestraDetalleMP.getUnidadesMedida().setNombreUnidadMedida(res.getString("NOMBRE_UNIDAD_MEDIDA"));
                formulaMaestraDetalleMP.setCantidad(res.getDouble("CANTIDAD")*bean.getCantidadLote()/bean.getFormulaMaestra().getCantidadLote());
                formulaMaestraEPList.add(formulaMaestraDetalleMP);
            }
            res.close();
            st.close();
            con1.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return formulaMaestraEPList;
    }
     

    //final ale edicion
    public String verReporteEtiquetas(){
        try {
            ExternalContext externalContext = FacesContext.getCurrentInstance().getExternalContext();
            Map<String,Object> sessionMap = externalContext.getSessionMap();
            sessionMap.put("programaProduccion", programaProduccionSeleccionado);
            sessionMap.put("ingresosAcondicionamientoEtiqueta", ingresosAcondicionamientoEtiqueta);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public List materialesVencidosList = new ArrayList();
    public String verReporteMaterialesVencidos_action(){
        try {
            String consulta = " select ia.FECHA_INGRESO_ALMACEN,ia.NRO_INGRESO_ALMACEN,iade.FECHA_VENCIMIENTO, " +
                             "m.NOMBRE_MATERIAL,sum(iade.cantidad_restante) cantidad_restante,u.ABREVIATURA,e.cod_estado_material,e.NOMBRE_ESTADO_MATERIAL, " +
                             "( select top 1 s.NOMBRE_SECCION from secciones s inner join SECCIONES_DETALLE sd on s.COD_SECCION = sd.COD_SECCION " +
                             "where sd.COD_CAPITULO = c.COD_CAPITULO or sd.COD_GRUPO  = gr.COD_GRUPO or sd.COD_MATERIAL = m.COD_MATERIAL) NOMBRE_SECCION,es.NOMBRE_EMPAQUE_SECUNDARIO_EXTERNO,iade.LOTE_MATERIAL_PROVEEDOR" +
                             " ,isnull(pro.NOMBRE_PROVEEDOR,'') as NOMBRE_PROVEEDOR,ia.cod_ingreso_almacen,iade.cod_material,iade.etiqueta " +
                             " from INGRESOS_ALMACEN ia  " +
                             " inner join INGRESOS_ALMACEN_DETALLE iad on ia.COD_INGRESO_ALMACEN = iad.COD_INGRESO_ALMACEN" +
                             " inner join INGRESOS_ALMACEN_DETALLE_ESTADO iade on iade.COD_INGRESO_ALMACEN = iad.COD_INGRESO_ALMACEN and iade.COD_MATERIAL = iad.COD_MATERIAL" +
                             " inner join MATERIALES m on m.COD_MATERIAL = iad.COD_MATERIAL" +
                             " inner join UNIDADES_MEDIDA u on u.COD_UNIDAD_MEDIDA = iad.COD_UNIDAD_MEDIDA " +
                             " inner join ESTADOS_MATERIAL e on e.COD_ESTADO_MATERIAL = iade.COD_ESTADO_MATERIAL" +
                             " inner join GRUPOS gr on gr.COD_GRUPO = m.COD_GRUPO" +
                             " inner join CAPITULOS c on c.COD_CAPITULO = gr.COD_CAPITULO" +
                             " inner join EMPAQUES_SECUNDARIO_EXTERNO es on es.COD_EMPAQUE_SECUNDARIO_EXTERNO = iade.COD_EMPAQUE_SECUNDARIO_EXTERNO" +
                             " left outer join PROVEEDORES pro on pro.COD_PROVEEDOR=ia.COD_PROVEEDOR" +
                             " where  iade.CANTIDAD_RESTANTE>0 and m.cod_material in (select distinct pprd.COD_MATERIAL" +
                             " from PROGRAMA_PRODUCCION_DETALLE pprd inner join PROGRAMA_PRODUCCION pr on pr.COD_PROGRAMA_PROD in("+codProgramaProd+"))" +
                             " and iade.fecha_vencimiento<=getdate() and iade.cod_estado_material = 2 and iade.cantidad_restante >0.01 and ia.cod_estado_ingreso_almacen = 1 and ia.cod_almacen = 1 and gr.cod_capitulo = 2 "+
                             " group by ia.FECHA_INGRESO_ALMACEN,ia.NRO_INGRESO_ALMACEN,iade.FECHA_VENCIMIENTO,e.NOMBRE_ESTADO_MATERIAL,"+
                             " m.NOMBRE_MATERIAL,u.ABREVIATURA,e.cod_estado_material,c.COD_CAPITULO ,gr.COD_GRUPO,m.COD_MATERIAL,es.NOMBRE_EMPAQUE_SECUNDARIO_EXTERNO,"+
                             " iade.LOTE_MATERIAL_PROVEEDOR,pro.NOMBRE_PROVEEDOR,ia.cod_ingreso_almacen,iade.cod_material,iade.etiqueta "+
                             " order by m.NOMBRE_MATERIAL,ia.FECHA_INGRESO_ALMACEN asc,ia.NRO_INGRESO_ALMACEN,"+
                             " iade.LOTE_MATERIAL_PROVEEDOR asc ";
            System.out.println("consulta " + consulta);
            Connection con = null;
            con = Util.openConnection(con);
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery(consulta);
            while(rs.next()){
                IngresosAlmacenDetalleEstado ingresoAlmacen = new IngresosAlmacenDetalleEstado();
                ingresoAlmacen.setCodIngresoAlmacen(rs.getString("cod_ingreso_almacen"));
                ingresoAlmacen.getMateriales().setCodMaterial(rs.getString("cod_material"));
                ingresoAlmacen.setEtiqueta(rs.getInt("etiqueta"));
                ingresoAlmacen.setFechaIngresoAlmacen(rs.getDate("fecha_ingreso_almacen"));
                ingresoAlmacen.setNroIngresoAlmacen(rs.getInt("nro_ingreso_almacen"));
                ingresoAlmacen.setFechaVencimiento(rs.getDate("fecha_vencimiento"));
                ingresoAlmacen.getMateriales().setNombreMaterial(rs.getString("nombre_material"));
                ingresoAlmacen.setCodEstadoMaterial(rs.getInt("cod_estado_material"));
                ingresoAlmacen.setNombreEstadoMaterial(rs.getString("nombre_estado_material"));
                ingresoAlmacen.setNombreEmpaque(rs.getString("nombre_empaque_secundario_externo"));
                ingresoAlmacen.setLoteMaterialProveedor(rs.getString("lote_material_proveedor"));
                ingresoAlmacen.setNombreProveedor(rs.getString("nombre_proveedor"));
                ingresoAlmacen.setCantidadRestante(rs.getFloat("cantidad_restante"));
                materialesVencidosList.add(ingresoAlmacen);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public String actualizaMaterialesReanalisis_action(){
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
            String consulta = "";
            Connection con = null;
            con = Util.openConnection(con);
            Statement st = con.createStatement();
            Iterator i = materialesVencidosList.iterator();
            while(i.hasNext()){
                IngresosAlmacenDetalleEstado iade = (IngresosAlmacenDetalleEstado) i.next();
                consulta = " update ingresos_almacen_detalle_estado set cod_estado_material = '5' where cod_ingreso_almacen = '"+iade.getCodIngresoAlmacen()+"'" +
                           " and etiqueta = '"+iade.getEtiqueta()+"' and cod_material = '"+iade.getMateriales().getCodMaterial()+"'  ";
                System.out.println("consulta " + consulta);
                st.executeUpdate(consulta);
            }
            st.close();
            con.close();


            i = materialesVencidosList.iterator();
            String envio = "";
            envio += "<table style='border:1px solid black;'>";
            envio +="<tr style='border:1px solid black;'><td style='border:1px solid black;'>FECHA INGRESO</td>" +
                        "<td style='border:1px solid black;'>NRO INGRESO</td>" +
                        "<td style='border:1px solid black;'>FECHA VENCIMIENTO</td>" +
                        "<td style='border:1px solid black;'>MATERIAL</td>" +
                        "<td style='border:1px solid black;'>CANTIDAD</td>" +
                        "<td style='border:1px solid black;'>ESTADO</td>" +
                        "<td style='border:1px solid black;'>EMPAQUE</td>" +
                        "<td style='border:1px solid black;'>LOTE PROVEEDOR</td>" +
                        "<td style='border:1px solid black;'>PROVEEDOR</td>" +
                        "</tr>";
            while(i.hasNext()){
                IngresosAlmacenDetalleEstado ia = (IngresosAlmacenDetalleEstado)i.next();
                
                envio +="<tr style='border:1px solid black;'><td style='border:1px solid black;'>"+sdf.format(ia.getFechaIngresoAlmacen())+"</td>" +
                        "<td style='border:1px solid black;'>"+ia.getNroIngresoAlmacen()+"</td>" +
                        "<td style='border:1px solid black;'>"+ia.getFechaVencimiento()+"</td>" +
                        "<td style='border:1px solid black;'>"+ia.getMateriales().getNombreMaterial()+"</td>" +
                        "<td style='border:1px solid black;'>"+ia.getCantidadRestante()+"</td>" +
                        "<td style='border:1px solid black;'>"+ia.getNombreEstadoMaterial()+"</td>" +
                        "<td style='border:1px solid black;'>"+ia.getNombreEmpaque()+"</td>" +
                        "<td style='border:1px solid black;'>"+ia.getLoteMaterialProveedor()+"</td>" +
                        "<td style='border:1px solid black;'>"+ia.getNombreProveedor()+"</td>" +
                        "</tr>";
            }
            envio +="</table>";
            Util.enviarCorreo("303,826,820,1479,483", envio, "Materiales para Reanalisis", "Sistema Atlas"); //303,826,820, //303,826,820,1479,483
            
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    /*List formulaMaestraDetalleMPMoficarList = new ArrayList();
    List formulaMaestraDetalleEPMoficarList = new ArrayList();
    List formulaMaestraDetalleESMoficarList = new ArrayList();
    public String cargarFormulaProducto(){
        try {
            formulaMaestraDetalleMPMoficarList.clear();
            String consulta = "  select m.cod_material,m.NOMBRE_MATERIAL,       um.NOMBRE_UNIDAD_MEDIDA,       ppd.CANTIDAD,       um.COD_UNIDAD_MEDIDA" +
                    " from MATERIALES m,     UNIDADES_MEDIDA um,     PROGRAMA_PRODUCCION_DETALLE ppd,     PROGRAMA_PRODUCCION pp" +
                    " where um.COD_UNIDAD_MEDIDA = m.COD_UNIDAD_MEDIDA and      m.COD_MATERIAL = ppd.COD_MATERIAL and      pp.COD_PROGRAMA_PROD = ppd.COD_PROGRAMA_PROD and" +
                    " pp.cod_formula_maestra = '"+programaProduccionSeleccionado.getFormulaMaestra().getCodFormulaMaestra()+"'" +
                    " and pp.cod_programa_prod = '"+programaProduccionSeleccionado.getProgramaProduccionPeriodo().getCodProgramaProduccion()+"'" +
                    " and ppd.cod_compprod = '"+programaProduccionSeleccionado.getFormulaMaestra().getComponentesProd().getCodCompprod()+"' and" +
                    " ppd.cod_lote_produccion = '"+programaProduccionSeleccionado.getCodLoteProduccion()+"' and      ppd.cod_lote_produccion = pp.cod_lote_produccion and      pp.cod_compprod = ppd.cod_compprod and" +
                    " m.COD_MATERIAL in ( select ep.COD_MATERIAL from FORMULA_MAESTRA_DETALLE_MP ep" +
                    " where ep.COD_FORMULA_MAESTRA = '"+programaProduccionSeleccionado.getFormulaMaestra().getCodFormulaMaestra()+"' ) and" +
                    " ppd.cod_tipo_programa_prod = pp.cod_tipo_programa_prod and      pp.cod_tipo_programa_prod = '"+programaProduccionSeleccionado.getTiposProgramaProduccion().getCodTipoProgramaProd()+"'" +
                    " order by m.NOMBRE_MATERIAL ";
           Connection con = null;
           con = Util.openConnection(con);
           Statement st = con.createStatement();
           ResultSet rs = st.executeQuery(consulta);
           while(rs.next()){
               FormulaMaestraDetalleMP f = new FormulaMaestraDetalleMP();
               f.getMateriales().setCodMaterial(rs.getString("cod_material"));
               f.getMateriales().setNombreMaterial(rs.getString("nombre_material"));
               f.getUnidadesMedida().setNombreUnidadMedida(rs.getString("nombre_unidad_medida"));
               f.setCantidad(rs.getDouble("cantidad"));
               f.getUnidadesMedida().setCodUnidadMedida(rs.getString("cod_unidad_medida"));
               formulaMaestraDetalleMPMoficarList.add(f);
           }
           formulaMaestraDetalleEPMoficarList.clear();
           consulta = " select m.cod_material,m.NOMBRE_MATERIAL, um.NOMBRE_UNIDAD_MEDIDA, ppd.CANTIDAD, um.COD_UNIDAD_MEDIDA" +
                   " from MATERIALES m,UNIDADES_MEDIDA um,PROGRAMA_PRODUCCION_DETALLE ppd, PROGRAMA_PRODUCCION pp" +
                   " where um.COD_UNIDAD_MEDIDA = m.COD_UNIDAD_MEDIDA and      m.COD_MATERIAL = ppd.COD_MATERIAL and      pp.COD_PROGRAMA_PROD = ppd.COD_PROGRAMA_PROD and" +
                   " pp.cod_formula_maestra = '"+programaProduccionSeleccionado.getFormulaMaestra().getCodFormulaMaestra()+"'" +
                   " and pp.cod_programa_prod = '"+programaProduccionSeleccionado.getProgramaProduccionPeriodo().getCodProgramaProduccion()+"'" +
                   " and ppd.cod_compprod = '"+programaProduccionSeleccionado.getFormulaMaestra().getComponentesProd().getCodCompprod()+"' and" +
                   " ppd.cod_lote_produccion = '"+programaProduccionSeleccionado.getCodLoteProduccion()+"' and ppd.cod_lote_produccion = pp.cod_lote_produccion and" +
                   " pp.cod_compprod = ppd.cod_compprod and      m.COD_MATERIAL in (" +
                   " select ep.COD_MATERIAL   from FORMULA_MAESTRA_DETALLE_EP ep" +
                   " where ep.COD_FORMULA_MAESTRA = '"+programaProduccionSeleccionado.getFormulaMaestra().getCodFormulaMaestra()+"') and" +
                   " ppd.cod_tipo_programa_prod = pp.cod_tipo_programa_prod and pp.cod_tipo_programa_prod = '"+programaProduccionSeleccionado.getTiposProgramaProduccion().getCodTipoProgramaProd()+"' order by m.NOMBRE_MATERIAL ";
           Statement st1 = con.createStatement();
           ResultSet rs1 = st1.executeQuery(consulta);
           while(rs1.next()){
               FormulaMaestraDetalleEP f = new FormulaMaestraDetalleEP();
               f.getMateriales().setCodMaterial(rs1.getString("cod_material"));
               f.getMateriales().setNombreMaterial(rs1.getString("nombre_material"));
               f.setCantidad(rs1.getString("cantidad"));
               f.getUnidadesMedida().setNombreUnidadMedida(rs1.getString("nombre_unidad_medida"));
               f.getUnidadesMedida().setCodUnidadMedida(rs1.getString("cod_unidad_medida"));
               formulaMaestraDetalleEPMoficarList.add(f);
           }
           formulaMaestraDetalleESMoficarList.clear();
           consulta = " select m.cod_material,m.NOMBRE_MATERIAL,       um.NOMBRE_UNIDAD_MEDIDA,       ppd.CANTIDAD," +
                   " um.COD_UNIDAD_MEDIDAfrom MATERIALES m,     UNIDADES_MEDIDA um,     PROGRAMA_PRODUCCION_DETALLE ppd," +
                   " PROGRAMA_PRODUCCION ppwhere um.COD_UNIDAD_MEDIDA = m.COD_UNIDAD_MEDIDA and  m.COD_MATERIAL = ppd.COD_MATERIAL and" +
                   " pp.COD_PROGRAMA_PROD = ppd.COD_PROGRAMA_PROD and pp.cod_formula_maestra = '"+programaProduccionSeleccionado.getFormulaMaestra().getCodFormulaMaestra()+"' and" +
                   " pp.cod_programa_prod = '"+programaProduccionSeleccionado.getProgramaProduccionPeriodo().getCodProgramaProduccion()+"'" +
                   " and ppd.cod_compprod = '"+programaProduccionSeleccionado.getFormulaMaestra().getComponentesProd().getCodCompprod()+"' and" +
                   " ppd.cod_lote_produccion = '"+programaProduccionSeleccionado.getCodLoteProduccion()+"'" +
                   " and ppd.cod_lote_produccion = pp.cod_lote_produccion and" +
                   " pp.cod_compprod = ppd.cod_compprod and m.COD_MATERIAL in (" +
                   " select ep.COD_MATERIAL from FORMULA_MAESTRA_DETALLE_ES ep" +
                   " where ep.COD_FORMULA_MAESTRA = '"+programaProduccionSeleccionado.getFormulaMaestra().getCodFormulaMaestra()+"') and" +
                   " ppd.cod_tipo_programa_prod = pp.cod_tipo_programa_prod and      pp.cod_tipo_programa_prod = '"+programaProduccionSeleccionado.getTiposProgramaProduccion().getCodTipoProgramaProd()+"'" +
                   "order by m.NOMBRE_MATERIAL ";
                   Statement st2 = con.createStatement();
                   ResultSet rs2 = st2.executeQuery(consulta);
           while(rs1.next()){
               FormulaMaestraDetalleEP f = new FormulaMaestraDetalleEP();
               f.getMateriales().setCodMaterial(rs2.getString("cod_material"));
               f.getMateriales().setNombreMaterial(rs2.getString("nombre_material"));
               f.setCantidad(rs2.getString("cantidad"));
               f.getUnidadesMedida().setNombreUnidadMedida(rs2.getString("nombre_unidad_medida"));
               f.getUnidadesMedida().setCodUnidadMedida(rs2.getString("cod_unidad_medida"));
               formulaMaestraDetalleESMoficarList.add(f);
           }

           rs.close();
           st.close();
           con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    List formulaMaestraDetalleMPList = new ArrayList();
    List formulaMaestraDetalleEPList = new ArrayList();
    List formulaMaestraDetalleESList = new ArrayList();*/

    List formulaMaestraDetalleMPMoficarList = new ArrayList();
    List formulaMaestraDetalleEPMoficarList = new ArrayList();
    List formulaMaestraDetalleESMoficarList = new ArrayList();
    List materiaMPList = new ArrayList();
    List materiaEPList = new ArrayList();
    List materiaESList = new ArrayList();
    List materialesList1 = new ArrayList();
    HtmlDataTable materialesDataTable = new HtmlDataTable();
    public String actualizaCantidad(){
        try{
            ProgramaProduccionDetalle  p = (ProgramaProduccionDetalle)materialesDataTable.getRowData();
            Iterator i = p.getFraccionesDetalleList().iterator();
            double total = 0.0;
            while(i.hasNext()){
                ProgramaProduccionDetalleFracciones pf = (ProgramaProduccionDetalleFracciones) i.next();
                total = total + pf.getCantidad();
            }
            p.setCantidad(total);
        }catch(Exception e){e.printStackTrace();}
        return null;
    }

    public List cargarFracciones(ProgramaProduccionDetalle p){
        List detalleList = new ArrayList();
        try {
            String sql = " select f.COD_FORMULA_MAESTRA,f.COD_MATERIAL,f.COD_FORMULA_MAESTRA_FRACCIONES,f.CANTIDAD,f.COD_TIPO_MATERIAL_PRODUCCION,fracciones.cantidad "+
                           " from FORMULA_MAESTRA_DETALLE_MP_FRACCIONES f"+
                           " inner join FORMULA_MAESTRA fm on fm.COD_FORMULA_MAESTRA = f.COD_FORMULA_MAESTRA"+
                           " outer apply("+
                           " select ppr.CANTIDAD from PROGRAMA_PRODUCCION_DETALLE_FRACCIONES ppr where ppr.COD_COMPPROD = fm.COD_COMPPROD"+
                           " and ppr.COD_FORMULA_MAESTRA = fm.COD_FORMULA_MAESTRA and ppr.COD_LOTE_PRODUCCION = ''"+
                           " and ppr.COD_MATERIAL = f.COD_MATERIAL and ppr.COD_PROGRAMA_PROD = '"+p.getProgramaProduccion().getCodProgramaProduccion()+"' and ppr.COD_TIPO_MATERIAL = f.COD_TIPO_MATERIAL_PRODUCCION"+
                           " ) fracciones"+
                           " where f.COD_FORMULA_MAESTRA = '"+p.getProgramaProduccion().getFormulaMaestra().getCodFormulaMaestra()+"' and f.COD_MATERIAL = '"+p.getMateriales().getCodMaterial()+"' and fm.COD_COMPPROD = '"+p.getProgramaProduccion().getFormulaMaestra().getComponentesProd().getCodCompprod()+"' ";

            System.out.println("consulta " + sql);
            setCon(Util.openConnection(getCon()));
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(sql);
            detalleList.clear();

            while(rs.next()) {
                ProgramaProduccionDetalleFracciones pd = new ProgramaProduccionDetalleFracciones();
                pd.setCodFormulaMaestraFracciones(rs.getInt("cod_formula_maestra_fracciones"));
                pd.getProgramaProduccionDetalle().getProgramaProduccion().getFormulaMaestra().setCodFormulaMaestra(rs.getString("cod_formula_maestra"));
                pd.getProgramaProduccionDetalle().getMateriales().setCodMaterial(rs.getString("cod_material"));
                pd.setCantidad(rs.getDouble("cantidad"));
                
                
                detalleList.add(new SelectItem(rs.getString("cod_material"),rs.getString("nombre_material")));


                Materiales m  = new Materiales();
                m.setCodMaterial(rs.getString("cod_material"));
                m.setNombreMaterial(rs.getString("nombre_material"));
                m.getUnidadesMedida().setCodUnidadMedida(rs.getString("cod_unidad_medida"));
                m.getUnidadesMedida().setNombreUnidadMedida(rs.getString("nombre_unidad_medida"));
                materialesList1.add(m);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return detalleList;
    }
    public List cargarMateriales(String codCapitulo){
        List materialesList = new ArrayList();
        try {
            String sql = "select Cod_Material,Nombre_Material,u.cod_unidad_medida,u.nombre_unidad_medida from MATERIALES m inner join Grupos g on g.cod_grupo = m.cod_grupo" +
                    " inner join unidades_medida u on u.cod_unidad_medida = m.cod_unidad_medida " +
                    " where g.cod_capitulo in ("+codCapitulo+")order by Nombre_Material";
            System.out.println("consulta " + sql);
            setCon(Util.openConnection(getCon()));
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(sql);
            materialesList.clear();

            while(rs.next()) {
                materialesList.add(new SelectItem(rs.getString("cod_material"),rs.getString("nombre_material")));
                Materiales m  = new Materiales();
                m.setCodMaterial(rs.getString("cod_material"));
                m.setNombreMaterial(rs.getString("nombre_material"));
                m.getUnidadesMedida().setCodUnidadMedida(rs.getString("cod_unidad_medida"));
                m.getUnidadesMedida().setNombreUnidadMedida(rs.getString("nombre_unidad_medida"));
                materialesList1.add(m);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return materialesList;
    }
    
    public String material_change(){
        ProgramaProduccionDetalle m = (ProgramaProduccionDetalle)materialesDataTable.getRowData();
        Iterator i = materialesList1.iterator();
        while(i.hasNext()){
            Materiales m1 = (Materiales) i.next();
            //System.out.println("unid medida 1 " +m.getMateriales().getCodMaterial() + " "+  m1.getCodMaterial());
            if(m1.getCodMaterial().equals(m.getMateriales().getCodMaterial())){
                //System.out.println("unid medida 2" +m.getUnidadesMedida().getCodUnidadMedida() + " "+  m1.getUnidadesMedida().getCodUnidadMedida());
                m.setUnidadesMedida(m1.getUnidadesMedida());
                break;
            }
        }
        return null;
    }
    public String adicionarMaterial_action(){
           ExternalContext externalContext = FacesContext.getCurrentInstance().getExternalContext();
           Map<String,String> params = externalContext.getRequestParameterMap();
           String codTipoMaterial = params.get("codTipoMaterial");
           if(codTipoMaterial.equals("1")){
               ProgramaProduccionDetalle p = new ProgramaProduccionDetalle();
               p.getFraccionesDetalleList().add(new ProgramaProduccionDetalleFracciones());
               formulaMaestraDetalleMPMoficarList.add(p);//new ProgramaProduccionDetalle()
           }
           if(codTipoMaterial.equals("2")){
               formulaMaestraDetalleEPMoficarList.add(new ProgramaProduccionDetalle());
           }
           if(codTipoMaterial.equals("3")){
               formulaMaestraDetalleESMoficarList.add(new ProgramaProduccionDetalle());
           }
        
        return null;
    }
    public String eliminarMaterial_action(){


        ExternalContext externalContext = FacesContext.getCurrentInstance().getExternalContext();
           Map<String,String> params = externalContext.getRequestParameterMap();
           String codTipoMaterial = params.get("codTipoMaterial");
           if(codTipoMaterial.equals("1")){
               Iterator i = formulaMaestraDetalleMPMoficarList.iterator();
                    List auxList = new ArrayList();
                    while(i.hasNext()){
                        ProgramaProduccionDetalle p = (ProgramaProduccionDetalle)i.next();
                        if(!p.getChecked()){
                            auxList.add(p);
                        }
                    }
                    formulaMaestraDetalleMPMoficarList = auxList;
           }
           if(codTipoMaterial.equals("2")){
               Iterator i = formulaMaestraDetalleEPMoficarList.iterator();
                    List auxList = new ArrayList();
                    while(i.hasNext()){
                        ProgramaProduccionDetalle p = (ProgramaProduccionDetalle)i.next();
                        if(!p.getChecked()){
                            auxList.add(p);
                        }
                    }
                    formulaMaestraDetalleEPMoficarList = auxList;
           }
           if(codTipoMaterial.equals("3")){
               Iterator i = formulaMaestraDetalleESMoficarList.iterator();
                    List auxList = new ArrayList();
                    while(i.hasNext()){
                        ProgramaProduccionDetalle p = (ProgramaProduccionDetalle)i.next();
                        if(!p.getChecked()){
                            auxList.add(p);
                        }
                    }
                    formulaMaestraDetalleESMoficarList = auxList;
           }
        return null;
    }
    public String cambiarMaterial_action(){
        try {
            Iterator i = formulaMaestraDetalleMPMoficarList.iterator();
            while(i.hasNext()){
                FormulaMaestraDetalleMP f = new FormulaMaestraDetalleMP();
                if(f.getChecked()){

                }

            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<ProgramaProduccionDetalleFracciones> cargarFraccionesDetalle(ProgramaProduccionDetalle ppd){
        double cantProrateo = programaProduccionSeleccionado.getCantidadLote()/programaProduccionSeleccionado.getFormulaMaestra().getCantidadLote();
        List<ProgramaProduccionDetalleFracciones> detalleList = new ArrayList<ProgramaProduccionDetalleFracciones>();
        try {
            String consulta = " select f.COD_FORMULA_MAESTRA,f.COD_MATERIAL,f.COD_FORMULA_MAESTRA_FRACCIONES,f.CANTIDAD,fracciones.cantidad frac_cant" + //,f.COD_TIPO_MATERIAL
                    " from FORMULA_MAESTRA_DETALLE_MP_FRACCIONES f" +
                    " inner join FORMULA_MAESTRA fm on fm.COD_FORMULA_MAESTRA = f.COD_FORMULA_MAESTRA" +
                    " outer apply( select ppr.CANTIDAD from PROGRAMA_PRODUCCION_DETALLE_FRACCIONES ppr where ppr.COD_COMPPROD = fm.COD_COMPPROD" +
                    " and ppr.COD_FORMULA_MAESTRA = fm.COD_FORMULA_MAESTRA and ppr.COD_LOTE_PRODUCCION = '"+ppd.getProgramaProduccion().getCodLoteProduccion()+"'" +
                    " and ppr.COD_MATERIAL = f.COD_MATERIAL and ppr.COD_PROGRAMA_PROD = '"+ppd.getProgramaProduccion().getCodProgramaProduccion()+"' " +
                    " AND ppr.cod_formula_maestra_fracciones = f.cod_formula_maestra_fracciones " + //and ppr.COD_TIPO_MATERIAL = f.COD_TIPO_MATERIAL
                    " ) fracciones" +
                    " where f.COD_FORMULA_MAESTRA = '"+ppd.getProgramaProduccion().getFormulaMaestra().getCodFormulaMaestra()+"'" +
                    " and f.COD_MATERIAL = '"+ppd.getMateriales().getCodMaterial() +"' and fm.COD_COMPPROD = '"+ppd.getProgramaProduccion().getFormulaMaestra().getComponentesProd().getCodCompprod()+"' ";
            consulta = " select f.COD_FORMULA_MAESTRA,p.COD_MATERIAL,fmd.COD_FORMULA_MAESTRA_FRACCIONES,fmd.CANTIDAD,pf.cantidad frac_cant" +
                    " from PROGRAMA_PRODUCCION_DETALLE p" +
                    " left outer join formula_maestra f on f.COD_COMPPROD = p.COD_COMPPROD and f.cod_estado_registro = 1 " +
                    " left outer join FORMULA_MAESTRA_DETALLE_MP_FRACCIONES fmd on fmd.COD_FORMULA_MAESTRA = f.COD_FORMULA_MAESTRA and fmd.COD_MATERIAL = p.COD_MATERIAL" +
                    " full outer join PROGRAMA_PRODUCCION_DETALLE_FRACCIONES pf on " +
                    " pf.COD_PROGRAMA_PROD = p.COD_PROGRAMA_PROD" +
                    "     and pf.COD_COMPPROD = p.COD_COMPPROD     and pf.COD_FORMULA_MAESTRA = f.COD_FORMULA_MAESTRA" +
                    "     and pf.COD_MATERIAL = p.COD_MATERIAL     and pf.COD_LOTE_PRODUCCION = p.COD_LOTE_PRODUCCION     and pf.COD_TIPO_PROGRAMA_PROD = p.COD_TIPO_PROGRAMA_PROD" +
                    "     and pf.COD_TIPO_MATERIAL = p.COD_TIPO_MATERIAL and pf.COD_FORMULA_MAESTRA_FRACCIONES = fmd.COD_FORMULA_MAESTRA_FRACCIONES  "+
                    " where p.COD_LOTE_PRODUCCION = '"+ppd.getProgramaProduccion().getCodLoteProduccion()+"'" +
                    " and p.COD_COMPPROD = '"+ppd.getProgramaProduccion().getFormulaMaestra().getComponentesProd().getCodCompprod()+"'" +
                    " and p.COD_MATERIAL = '"+ppd.getMateriales().getCodMaterial()+"' and p.COD_PROGRAMA_PROD = '"+ppd.getProgramaProduccion().getCodProgramaProduccion()+"'" +
                    " and p.cod_tipo_material = '"+ppd.getTiposMaterialProduccion().getCodTipoMaterialProduccion()+"'  "; //and p.COD_TIPO_MATERIAL = 1
            consulta = " select f.COD_FORMULA_MAESTRA,p.COD_MATERIAL,       fmd.COD_FORMULA_MAESTRA_FRACCIONES,       fmd.CANTIDAD,frax.COD_FORMULA_MAESTRA_FRACCIONES frax_cod,frax.cantidad frax_cant, frax1.COD_FORMULA_MAESTRA_FRACCIONES frax1_cod, frax1.cantidad frax1_cant " +
                    " from PROGRAMA_PRODUCCION_DETALLE p     left outer join formula_maestra f on f.COD_COMPPROD = p.COD_COMPPROD and     f.cod_estado_registro = 1" +
                    " left outer join FORMULA_MAESTRA_DETALLE_MP_FRACCIONES fmd on     fmd.COD_FORMULA_MAESTRA = f.COD_FORMULA_MAESTRA     and fmd.COD_MATERIAL = p.COD_MATERIAL" +
                    " outer apply(select top 1 pf.COD_FORMULA_MAESTRA_FRACCIONES,pf.CANTIDAD " +
                    " from PROGRAMA_PRODUCCION_DETALLE_FRACCIONES pf  where" +
                    " pf.COD_PROGRAMA_PROD = p.COD_PROGRAMA_PROD and pf.COD_COMPPROD = p.COD_COMPPROD" +
                    " and pf.COD_FORMULA_MAESTRA = f.COD_FORMULA_MAESTRA and     pf.COD_MATERIAL = p.COD_MATERIAL " +
                    " and pf.COD_LOTE_PRODUCCION = p.COD_LOTE_PRODUCCION" +
                    " and pf.COD_TIPO_PROGRAMA_PROD = p.COD_TIPO_PROGRAMA_PROD and pf.COD_TIPO_MATERIAL = p.COD_TIPO_MATERIAL " +
                    " and pf.COD_FORMULA_MAESTRA_FRACCIONES = fmd.COD_FORMULA_MAESTRA_FRACCIONES " +
                    " ) frax" +
                    " outer apply(" +
                    "     select top 1 pf.COD_FORMULA_MAESTRA_FRACCIONES,pf.CANTIDAD" +
                    "     from PROGRAMA_PRODUCCION_DETALLE_FRACCIONES pf  where" +
                    "     pf.COD_PROGRAMA_PROD = p.COD_PROGRAMA_PROD and pf.COD_COMPPROD =" +
                    "     p.COD_COMPPROD and pf.COD_FORMULA_MAESTRA = f.COD_FORMULA_MAESTRA and" +
                    "     pf.COD_MATERIAL = p.COD_MATERIAL and pf.COD_LOTE_PRODUCCION =" +
                    "     p.COD_LOTE_PRODUCCION and pf.COD_TIPO_PROGRAMA_PROD =" +
                    "     p.COD_TIPO_PROGRAMA_PROD and pf.COD_TIPO_MATERIAL = p.COD_TIPO_MATERIAL" +
                    "     ) frax1" +
                    " where p.COD_LOTE_PRODUCCION = '"+ppd.getProgramaProduccion().getCodLoteProduccion()+"'" +
                    " and p.COD_COMPPROD = '"+ppd.getProgramaProduccion().getFormulaMaestra().getComponentesProd().getCodCompprod()+"'" +
                    " and p.COD_MATERIAL = '"+ppd.getMateriales().getCodMaterial()+"'" +
                    " and p.COD_PROGRAMA_PROD = '"+ppd.getProgramaProduccion().getCodProgramaProduccion()+"'" +
                    " and p.cod_tipo_material = '"+ppd.getTiposMaterialProduccion().getCodTipoMaterialProduccion()+"' ";
            consulta = "  ";

            Connection con = null;
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = null;
            int conCodFraccion = 1;
            consulta =" select f.COD_FORMULA_MAESTRA, p.COD_MATERIAL, pf.COD_FORMULA_MAESTRA_FRACCIONES cod_1, pf.CANTIDAD*'"+cantProrateo+"' cant_1 ,0 cant_2,0 cod_2" +
                    " from PROGRAMA_PRODUCCION_DETALLE p" +
                    " inner join FORMULA_MAESTRA f on f.COD_COMPPROD = p.COD_COMPPROD and f.cod_estado_registro = 1 " +
                    " inner join PROGRAMA_PRODUCCION_DETALLE_FRACCIONES pf on pf.COD_PROGRAMA_PROD = p.COD_PROGRAMA_PROD and pf.COD_COMPPROD = p.COD_COMPPROD and" +
                    " pf.COD_FORMULA_MAESTRA = f.COD_FORMULA_MAESTRA and pf.COD_MATERIAL = p.COD_MATERIAL and pf.COD_LOTE_PRODUCCION = p.COD_LOTE_PRODUCCION and" +
                    " pf.COD_TIPO_PROGRAMA_PROD = p.COD_TIPO_PROGRAMA_PROD " + //and             pf.COD_TIPO_MATERIAL = p.COD_TIPO_MATERIAL
                    " where p.COD_LOTE_PRODUCCION = '"+ppd.getProgramaProduccion().getCodLoteProduccion()+"'" +
                    " and  p.COD_COMPPROD = '"+ppd.getProgramaProduccion().getFormulaMaestra().getComponentesProd().getCodCompprod()+"'" +
                    " and  p.COD_MATERIAL = '"+ppd.getMateriales().getCodMaterial()+"'" +
                    " and  p.COD_PROGRAMA_PROD = '"+ppd.getProgramaProduccion().getCodProgramaProduccion()+"'" +
                    " and p.cod_tipo_material = '"+ppd.getTiposMaterialProduccion().getCodTipoMaterialProduccion()+"'";
            
            System.out.println("consulta alter 1 " + consulta);
            rs = st.executeQuery(consulta);
            rs.last();
            if(rs.getRow()<=0){
                consulta = " select f.COD_FORMULA_MAESTRA, p.COD_MATERIAL,fmd.COD_FORMULA_MAESTRA_FRACCIONES cod_1,fmd.CANTIDAD*'"+cantProrateo+"' cant_1,pf.COD_FORMULA_MAESTRA_FRACCIONES cod_2,       pf.CANTIDAD*'"+cantProrateo+"' cant_2" +
                    " from PROGRAMA_PRODUCCION_DETALLE p" +
                    " inner join formula_maestra f on f.COD_COMPPROD = p.COD_COMPPROD and     f.cod_estado_registro = 1" +
                    " inner join  FORMULA_MAESTRA_DETALLE_MP_FRACCIONES fmd on fmd.COD_FORMULA_MAESTRA = f.COD_FORMULA_MAESTRA and fmd.COD_MATERIAL = p.COD_MATERIAL" +
                    " left outer join  PROGRAMA_PRODUCCION_DETALLE_FRACCIONES pf     on pf.COD_PROGRAMA_PROD = p.COD_PROGRAMA_PROD and             pf.COD_COMPPROD = p.COD_COMPPROD and" +
                    " pf.COD_FORMULA_MAESTRA = f.COD_FORMULA_MAESTRA and pf.COD_MATERIAL = p.COD_MATERIAL" +
                    " and pf.COD_LOTE_PRODUCCION = p.COD_LOTE_PRODUCCION and   pf.COD_TIPO_PROGRAMA_PROD = p.COD_TIPO_PROGRAMA_PROD and  pf.COD_TIPO_MATERIAL = p.COD_TIPO_MATERIAL" +
                    " and pf.COD_FORMULA_MAESTRA_FRACCIONES = fmd.COD_FORMULA_MAESTRA_FRACCIONES" +
                    " where p.COD_LOTE_PRODUCCION = '"+ppd.getProgramaProduccion().getCodLoteProduccion()+"'" +
                    " and  p.COD_COMPPROD = '"+ppd.getProgramaProduccion().getFormulaMaestra().getComponentesProd().getCodCompprod()+"'" +
                    " and  p.COD_MATERIAL = '"+ppd.getMateriales().getCodMaterial()+"' and  p.COD_PROGRAMA_PROD = '"+ppd.getProgramaProduccion().getCodProgramaProduccion()+"'" +
                    " and p.cod_tipo_material = '"+ppd.getTiposMaterialProduccion().getCodTipoMaterialProduccion()+"'";
                    System.out.println("consulta alter 2 " + consulta);
                    rs = st.executeQuery(consulta);
                    conCodFraccion = 0;
            }
            rs.beforeFirst();

            System.out.println("consulta " + consulta);
            while(rs.next()){
                ProgramaProduccionDetalleFracciones p = new ProgramaProduccionDetalleFracciones();
                
                if(rs.getDouble("cant_1")>0){
                    p.setCodFormulaMaestraFracciones(rs.getInt("cod_1"));
                    p.setCantidad(rs.getDouble("cant_1"));
                }
                if(rs.getDouble("cant_2")>0){
                    p.setCodFormulaMaestraFracciones(rs.getInt("cod_2"));
                    p.setCantidad(rs.getDouble("cant_2"));
                }
                if(p.getCantidad()<=0){
                    
                    p.setCantidad(ppd.getCantidad());
                }
                
                p.getProgramaProduccionDetalle().getProgramaProduccion().getFormulaMaestra().setCodFormulaMaestra(rs.getString("cod_formula_maestra"));
                p.getProgramaProduccionDetalle().getMateriales().setCodMaterial(rs.getString("cod_material"));
                p.setConCodFraccion(conCodFraccion);
                detalleList.add(p);
            }
            if(detalleList.size()==0){
                ProgramaProduccionDetalleFracciones p1 =  new ProgramaProduccionDetalleFracciones();
                p1.setCantidad(ppd.getCantidad());
                detalleList.add(p1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return detalleList;
    }
    

    public String correoNotificacionDesvio(ProgramaProduccion p){
        String correo = "";
        try {
            correo = " ";
            NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
            DecimalFormat format = (DecimalFormat) nf;
            format.applyPattern("#,###.00");
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
                //String codCompProd=request.getParameter("codCompProd");
                //String codVersion=request.getParameter("codVersion");
                String estiloModif = "style='background-color:rgb(240, 230, 140)'";
                String estiloElim = "style='background-color:rgb(255, 182, 193)'";
                String estiloAgr = "style='background-color:rgb(144, 238, 144)'";
                String estilo = "";
                String codLoteProduccion = p.getCodLoteProduccion();  // request.getParameter("codLoteProduccion");
                String codProgramaProd = p.getCodProgramaProduccion(); //request.getParameter("codProgramaProd");
                String codCompProd = p.getFormulaMaestra().getComponentesProd().getCodCompprod(); //request.getParameter("codCompProd");
                String codTipoProgramaProd = p.getTiposProgramaProduccion().getCodTipoProgramaProd(); //request.getParameter("codTipoProgramaProd");
                String codFormulaMaestra = p.getFormulaMaestra().getCodFormulaMaestra(); //request.getParameter("codFormulaMaestra");
                String nombreProdSemiterminado = p.getFormulaMaestra().getComponentesProd().getNombreProdSemiterminado(); //request.getParameter("nombreProdSemiterminado");
                String nombreTipoProgramaProd = p.getTiposProgramaProduccion().getNombreTipoProgramaProd(); //request.getParameter("nombreTipoProgramaProd");
String consulta = " select m1.COD_MATERIAL COD_MATERIAL_FM,m1.NOMBRE_MATERIAL NOMBRE_MATERIAL_FM,f.CANTIDAD CANTIDAD_FM,m.COD_MATERIAL COD_MATERIAL_P,m.NOMBRE_MATERIAL NOMBRE_MATERIAL_P,p.CANTIDAD CANTIDAD_P,u.abreviatura abreviaturaFM,um.abreviatura abreviaturaP" +
         " from FORMULA_MAESTRA_DETALLE_MP f " +
         " inner join FORMULA_MAESTRA fm on fm.COD_FORMULA_MAESTRA = f.COD_FORMULA_MAESTRA and f.COD_FORMULA_MAESTRA = '"+codFormulaMaestra+"' " +
         " inner join materiales m1 on m1.COD_MATERIAL = f.COD_MATERIAL  " +
         " inner join unidades_medida u on u.cod_unidad_medida = f.cod_unidad_medida " +
         " full outer join" +
         " PROGRAMA_PRODUCCION_DETALLE p on" +
         " fm.COD_COMPPROD = p.COD_COMPPROD" +
         " and f.COD_MATERIAL = p.COD_MATERIAL" +
         " inner join materiales m on m.COD_MATERIAL = p.COD_MATERIAL and m.cod_material not in(select mr.cod_material from formula_maestra_detalle_mr mr where mr.cod_formula_maestra = '"+codFormulaMaestra+"' )" +
         " inner join GRUPOS g on g.COD_GRUPO = m.COD_GRUPO and g.COD_CAPITULO = 2" +
         " inner join unidades_medida um on um.cod_unidad_medida = p.cod_unidad_medida " +
         " where p.COD_LOTE_PRODUCCION = '"+codLoteProduccion+"'" +
         " and p.COD_TIPO_PROGRAMA_PROD = "+codTipoProgramaProd+"" +
         " and p.COD_COMPPROD = "+codCompProd+"" +
         " and p.COD_PROGRAMA_PROD = "+codProgramaProd+"" +
         " and p.COD_ESTADO_REGISTRO = 1 ";

System.out.println("consulta MP"+consulta);

Connection con=null;
con=Util.openConnection(con);
Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
ResultSet rs=st.executeQuery(consulta);
String comparacionDetalle = "";

correo += "<div align='center' style = 'font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 10px;'>" +
        " <b>DESVIACION DE FORMULA MAESTRA</b><br/><br/>" +
        " <table align='center' width='60%' style='text-align:left' style = 'font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 10px;border : solid #f2f2f2 1px; ' cellpadding='0' cellspacing='0'>" +
        " <thead style='text-align:center;background-color:#9d5a9e; color:white;'><tr><td colspan='2'><b>DATOS DE PRODUCTO</b></td></tr></thead>" +
        " <tbody></tbody>" +
        " <tbody >" +
        " <tr><td>Producto:</td><td>"+nombreProdSemiterminado+"</td></tr>" +
        " <tr><td>Lote</td><td>"+codLoteProduccion+"</td></tr>" +
        //" <tr><td>Tipo de Produccion</td><td>"+nombreTipoProgramaProd+"</td></tr>" +
        " </tbody></table>" +
        " <table width='40%'><TR>" +
        " <TD><SPAN class=outputText2 style='FONT-WEIGHT: bold'>Eliminado</SPAN></TD>" +
        " <TD   "+estiloElim+" >&nbsp;&nbsp;&nbsp;&nbsp;</TD>" +
        " <TD><SPAN class=outputText2 style='FONT-WEIGHT: bold'>Modificado</SPAN></TD>" +
        " <TD  "+estiloModif+" >&nbsp;&nbsp;&nbsp;&nbsp;</TD>" +
        " <TD><SPAN class=outputText2 style='FONT-WEIGHT: bold'>Nuevo</SPAN></TD>" +
        " <TD  "+estiloAgr+">&nbsp;&nbsp;&nbsp;&nbsp;</TD></TR></table><br/><b>MATERIA PRIMA</b>" +
        " <table align='center' width='60%' style='text-align:left' style = 'font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 10px;border : solid #f2f2f2 1px; ' cellpadding='0' cellspacing='0'>" +
        " <thead align='center' style='text-align:center;border : solid #f2f2f2 1px; background-color:#9d5a9e; color:white;'><tr><td><b>MATERIAL</b></td><td>ANTES</td><td>DESPUES</td><td>UNID.</td><td>FRACCIONES <br/> ANTES</td><td>FRACCIONES <br/> DESPUES</td></tr></thead>" +
        " <tbody>";


String nombreMaterialFM  = "";
String nombreMaterialP = "";
String codMaterialFM  = "";
String codMaterialP = "";
String abreviaturaFM = "";
String abreviaturaP = "";
String nombreMaterial = "";
List fracciones = new ArrayList();
    while(rs.next()){
        estilo = "";
    nombreMaterialFM= rs.getString("NOMBRE_MATERIAL_FM")==null?"":rs.getString("NOMBRE_MATERIAL_FM");
    nombreMaterialP = rs.getString("NOMBRE_MATERIAL_P")==null?"":rs.getString("NOMBRE_MATERIAL_P");
    codMaterialFM= rs.getString("COD_MATERIAL_FM")==null?"":rs.getString("COD_MATERIAL_FM");
    codMaterialP = rs.getString("COD_MATERIAL_P")==null?"":rs.getString("COD_MATERIAL_P");
    abreviaturaFM = rs.getString("abreviaturaFM")==null?"":rs.getString("abreviaturaFM");
    abreviaturaP = rs.getString("abreviaturaP")==null?"":rs.getString("abreviaturaP");
    double cantidadFM = rs.getDouble("CANTIDAD_FM");
    double cantidadP = rs.getDouble("CANTIDAD_P");
    nombreMaterial = nombreMaterialFM;
    if(nombreMaterialFM.equals(nombreMaterialP) && cantidadFM!=cantidadP){
        estilo = estiloModif;
    }
    if(nombreMaterialFM.equals("") && cantidadFM!=cantidadP){
        estilo = estiloAgr;
        //nombreMaterialFM = nombreMaterialP;
        abreviaturaFM = abreviaturaP;
        codMaterialFM = codMaterialP;
        nombreMaterial = nombreMaterialP;
    }

        Statement st1=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
        consulta = " select f.COD_MATERIAL COD_MATERIAL_FM,f.CANTIDAD CANTIDAD_FM, p.COD_MATERIAL COD_MATERIA_P,p.CANTIDAD CANTIDAD_P" +
                " from FORMULA_MAESTRA_DETALLE_MP_FRACCIONES f" +
                " full outer join PROGRAMA_PRODUCCION_DETALLE_FRACCIONES p" +
                " on f.COD_FORMULA_MAESTRA = p.COD_FORMULA_MAESTRA and f.COD_MATERIAL = p.COD_MATERIAL and f.COD_FORMULA_MAESTRA_FRACCIONES = p.COD_FORMULA_MAESTRA_FRACCIONES and p.cod_tipo_material = 1  " +
                " where p.COD_LOTE_PRODUCCION = '"+codLoteProduccion+"'" +
                " and p.COD_COMPPROD = '"+codCompProd+"'" +
                " and p.COD_TIPO_PROGRAMA_PROD = '"+codTipoProgramaProd+"' " +
                " and p.COD_PROGRAMA_PROD =  '"+codProgramaProd+"' " +
                " and p.COD_MATERIAL = '"+codMaterialFM+"'" +
                " and p.COD_FORMULA_MAESTRA = '"+codFormulaMaestra+"'" +
                " ";
        /*consulta = "select p.COD_MATERIAL COD_MATERIAL_FM,p.CANTIDAD CANTIDAD_FM, p.COD_MATERIAL COD_MATERIA_P" +
                " from PROGRAMA_PRODUCCION_DETALLE_FRACCIONES p" +
                " where p.COD_LOTE_PRODUCCION = '"+codLoteProduccion+"'" +
                " and p.COD_COMPPROD = '"+codCompProd+"'" +
                " and p.COD_TIPO_PROGRAMA_PROD = '"+codTipoProgramaProd+"' " +
                " and p.COD_PROGRAMA_PROD =  '"+codProgramaProd+"' " +
                " and p.COD_MATERIAL = '"+codMaterialFM+"'" +
                " and p.COD_FORMULA_MAESTRA = '"+codFormulaMaestra+"' ";*/
        System.out.println("consulta " + consulta );
        ResultSet rs1 = st1.executeQuery(consulta);
        rs1.last();
        int filas = rs1.getRow()+1;
        rs1.beforeFirst();
        System.out.println("las filas :::" + filas);

        correo+=
        "<tr><td align='left' style='border : solid #f2f2f2 1px;' class='border' rowspan='"+filas+"' >"+nombreMaterial+"</td>"+
            "<td align='left' style='border : solid #f2f2f2 1px;' class='border' "+estilo+" rowspan="+filas+">"+format.format(cantidadFM)+"</td>"+
            "<td align='left' style='border : solid #f2f2f2 1px;' class='border' "+estilo+" rowspan="+filas+">"+format.format(cantidadP)+"</td>"+
            "<td align='left' style='border : solid #f2f2f2 1px;' class='border' rowspan="+filas+">"+abreviaturaFM+"</td>";

        while(rs1.next()){
            if( nombreMaterialFM.equals(nombreMaterialP) && rs1.getDouble("cantidad_fm")!=rs1.getDouble("cantidad_p")){
                estilo = estiloModif;
            }
            if( nombreMaterialFM.equals("") && rs1.getDouble("cantidad_fm")!=rs1.getDouble("cantidad_p")){
                estilo = estiloAgr;
            }

       correo += "<tr><td "+estilo+">"+format.format(rs1.getDouble("cantidad_fm"))+"</td><td "+estilo+">"+format.format(rs1.getDouble("cantidad_p"))+"</td></tr>";
         }
       correo+="</tr>";
         }
        correo +="</tbody>";
  correo+="</table>" +
          " <br/><div><b>MATERIAL DE EMPAQUE PRIMARIO</b></div><br/>" +
          " <table align='center' width='60%' style='text-align:left' style = 'font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 10px;border : solid #f2f2f2 1px; ' cellpadding='0' cellspacing='0'>" +
          " <thead style='text-align:center;background-color:#9d5a9e; color:white;'><tr><td><b>MATERIAL</b></td><td>ANTES</td><td>DESPUES</td><td>UNID.</td></tr></thead><tbody>";
        //EMPAQUE PRIMARIO
        consulta = " select m1.COD_MATERIAL COD_MATERIAL_FM," +
                "       m1.NOMBRE_MATERIAL NOMBRE_MATERIAL_FM,f.CANTIDAD CANTIDAD_FM," +
                "       m.COD_MATERIAL COD_MATERIAL_P," +
                "       m.NOMBRE_MATERIAL NOMBRE_MATERIAL_P," +
                "       p.CANTIDAD CANTIDAD_P," +
                "       u.abreviatura abreviaturaFM," +
                "       um.abreviatura abreviaturaP" +
                "     from FORMULA_MAESTRA_DETALLE_EP f" +
                "     inner join FORMULA_MAESTRA fm on fm.COD_FORMULA_MAESTRA =" +
                "     f.COD_FORMULA_MAESTRA and f.COD_FORMULA_MAESTRA = '"+codFormulaMaestra+"'" +
                "     inner join materiales m1 on m1.COD_MATERIAL = f.COD_MATERIAL" +
                "     inner join unidades_medida u on u.cod_unidad_medida = f.cod_unidad_medida" +
                "     inner join PRESENTACIONES_PRIMARIAS prp on prp.COD_PRESENTACION_PRIMARIA = f.COD_PRESENTACION_PRIMARIA and prp.COD_TIPO_PROGRAMA_PROD = '"+codTipoProgramaProd+"'" +
                "     and prp.COD_COMPPROD = fm.COD_COMPPROD" +
                "     full outer join PROGRAMA_PRODUCCION_DETALLE p on fm.COD_COMPPROD =" +
                "     p.COD_COMPPROD and f.COD_MATERIAL = p.COD_MATERIAL" +
                "     inner join materiales m on m.COD_MATERIAL = p.COD_MATERIAL" +
                "     inner join GRUPOS g on g.COD_GRUPO = m.COD_GRUPO and g.COD_CAPITULO = 3" +
                "     inner join unidades_medida um on um.cod_unidad_medida = p.cod_unidad_medida" +
                "     where p.COD_LOTE_PRODUCCION = '"+codLoteProduccion+"' and" +
                "      p.COD_TIPO_PROGRAMA_PROD = '"+codTipoProgramaProd+"' and " +
                "      p.COD_COMPPROD = '"+codCompProd+"' and" +
                "      p.COD_PROGRAMA_PROD = '"+codProgramaProd+"' and" +
                "      p.COD_ESTADO_REGISTRO = 1 ";
        System.out.println("consulta EP " + consulta);

        Statement st1 = con.createStatement();
        ResultSet rs1 = st1.executeQuery(consulta);
        nombreMaterialFM= "";
            nombreMaterialP = "";
            codMaterialFM= "";
            codMaterialP = "";
            abreviaturaFM = "";
            abreviaturaP = "";
            //double cantidadFM = 0.0;
            //double cantidadP = 0.0;
        while(rs1.next()){
            nombreMaterialFM= rs1.getString("NOMBRE_MATERIAL_FM")==null?"":rs1.getString("NOMBRE_MATERIAL_FM");
            nombreMaterialP = rs1.getString("NOMBRE_MATERIAL_P")==null?"":rs1.getString("NOMBRE_MATERIAL_P");
            codMaterialFM= rs1.getString("COD_MATERIAL_FM")==null?"":rs1.getString("COD_MATERIAL_FM");
            codMaterialP = rs1.getString("COD_MATERIAL_P")==null?"":rs1.getString("COD_MATERIAL_P");
            abreviaturaFM = rs1.getString("abreviaturaFM")==null?"":rs1.getString("abreviaturaFM");
            abreviaturaP = rs1.getString("abreviaturaP")==null?"":rs1.getString("abreviaturaP");
            double cantidadFM = rs1.getDouble("CANTIDAD_FM");
            double cantidadP = rs1.getDouble("CANTIDAD_P");
            nombreMaterial = nombreMaterialFM;
            estilo = "";

            if(nombreMaterialFM.equals(nombreMaterialP) && cantidadFM!=cantidadP){
                estilo = estiloModif;
            }
            if(nombreMaterialFM.equals("") && cantidadFM!=cantidadP){
                estilo = estiloAgr;
                //nombreMaterialFM = nombreMaterialP;
                abreviaturaFM = abreviaturaP;
                codMaterialFM = codMaterialP;
                nombreMaterial = nombreMaterialP;
            }
           correo+= "<tr><td align='left' style='border : solid #f2f2f2 1px;' class='border' >"+nombreMaterial+"</td>"+
            "<td align='left' style='border : solid #f2f2f2 1px;' class='border' "+estilo+">"+format.format(cantidadFM)+"</td>"+
            "<td align='left' style='border : solid #f2f2f2 1px;' class='border' "+estilo+">"+format.format(cantidadP)+"</td>"+
            "<td align='left' style='border : solid #f2f2f2 1px;' class='border'>"+abreviaturaFM+"</td>"+
            "</tr>";

        }
    correo +="</tbody></table><br/><div><b>MATERIAL DE EMPAQUE SECUNDARIO</b></div><br/>" +
            " <table align='center' width='60%' style='text-align:left' style = 'font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 10px;border : solid #f2f2f2 1px;' cellpadding='0' cellspacing='0'>" +
            " <thead style='text-align:center;background-color:#9d5a9e; color:white;'><tr><td><b>MATERIAL</b></td><td>ANTES</td><td>DESPUES</td><td>UNID.</td></tr></thead><tbody>";
        //EMPAQUE SECUNDARIO

        consulta =" select m1.COD_MATERIAL COD_MATERIAL_FM," +
                "       m1.NOMBRE_MATERIAL NOMBRE_MATERIAL_FM," +
                "       f.CANTIDAD CANTIDAD_FM," +
                "       m.COD_MATERIAL COD_MATERIAL_P," +
                "       m.NOMBRE_MATERIAL NOMBRE_MATERIAL_P," +
                "       p.CANTIDAD CANTIDAD_P," +
                "       u.abreviatura abreviaturaFM," +
                "       um.abreviatura abreviaturaP" +
                "     from FORMULA_MAESTRA_DETALLE_ES f" +
                "     inner join FORMULA_MAESTRA fm on fm.COD_FORMULA_MAESTRA = f.COD_FORMULA_MAESTRA and f.COD_FORMULA_MAESTRA = '"+codFormulaMaestra+"'" +
                "     inner join materiales m1 on m1.COD_MATERIAL = f.COD_MATERIAL" +
                "     inner join unidades_medida u on u.cod_unidad_medida = f.cod_unidad_medida" +
                "     inner join COMPONENTES_PRESPROD cprp on cprp.COD_PRESENTACION = f.COD_PRESENTACION_PRODUCTO and cprp.COD_TIPO_PROGRAMA_PROD = '"+codTipoProgramaProd+"'" +
                "     and cprp.COD_COMPPROD = fm.COD_COMPPROD and f.COD_TIPO_PROGRAMA_PROD = cprp.COD_TIPO_PROGRAMA_PROD" +
                "     full outer join PROGRAMA_PRODUCCION_DETALLE p on fm.COD_COMPPROD =" +
                "     p.COD_COMPPROD and f.COD_MATERIAL = p.COD_MATERIAL" +
                "     inner join materiales m on m.COD_MATERIAL = p.COD_MATERIAL" +
                "     inner join GRUPOS g on g.COD_GRUPO = m.COD_GRUPO and g.COD_CAPITULO = 4" +
                "     inner join unidades_medida um on um.cod_unidad_medida = p.cod_unidad_medida" +
                "     where p.COD_LOTE_PRODUCCION = '"+codLoteProduccion+"' and" +
                "      p.COD_TIPO_PROGRAMA_PROD = '"+codTipoProgramaProd+"' and " +
                "      p.COD_COMPPROD = '"+codCompProd+"' and" +
                "      p.COD_PROGRAMA_PROD = '"+codProgramaProd+"' and" +
                "      p.COD_ESTADO_REGISTRO = 1 ";
        System.out.println("consulta ES " + consulta);

        Statement st2 = con.createStatement();
        ResultSet rs2 = st2.executeQuery(consulta);
        nombreMaterialFM= "";
            nombreMaterialP = "";
            codMaterialFM= "";
            codMaterialP = "";
            abreviaturaFM = "";
            abreviaturaP = "";
            //double cantidadFM = 0.0;
            //double cantidadP = 0.0;
        while(rs2.next()){
            nombreMaterialFM= rs2.getString("NOMBRE_MATERIAL_FM")==null?"":rs2.getString("NOMBRE_MATERIAL_FM");
            nombreMaterialP = rs2.getString("NOMBRE_MATERIAL_P")==null?"":rs2.getString("NOMBRE_MATERIAL_P");
            codMaterialFM= rs2.getString("COD_MATERIAL_FM")==null?"":rs2.getString("COD_MATERIAL_FM");
            codMaterialP = rs2.getString("COD_MATERIAL_P")==null?"":rs2.getString("COD_MATERIAL_P");
            abreviaturaFM = rs2.getString("abreviaturaFM")==null?"":rs2.getString("abreviaturaFM");
            abreviaturaP = rs2.getString("abreviaturaP")==null?"":rs2.getString("abreviaturaP");
            double cantidadFM = rs2.getDouble("CANTIDAD_FM");
            double cantidadP = rs2.getDouble("CANTIDAD_P");
            nombreMaterial = nombreMaterialFM;
            estilo = "";

            if(nombreMaterialFM.equals(nombreMaterialP) && cantidadFM!=cantidadP){
                estilo = estiloModif;
            }
            if(nombreMaterialFM.equals("") && cantidadFM!=cantidadP){
                estilo = estiloAgr;
                //nombreMaterialFM = nombreMaterialP;
                abreviaturaFM = abreviaturaP;
                codMaterialFM = codMaterialP;
                nombreMaterial = nombreMaterialP;
            }
           correo +=" <tr><td align='left' style='border : solid #f2f2f2 1px;' class='border' >"+nombreMaterial+"</td>" +
                   " <td align='left' style='border : solid #f2f2f2 1px;' class='border' "+estilo+">"+format.format(cantidadFM)+"</td>" +
                   " <td align='left' style='border : solid #f2f2f2 1px;' class='border' "+estilo+">"+format.format(cantidadP)+"</td>" +
                   " <td align='left' style='border : solid #f2f2f2 1px;' class='border' >"+abreviaturaFM+"</td></tr>";

        }


    correo+="</tbody></table></div> ";

        } catch (Exception e) {
            e.printStackTrace();
        }
        return correo;
    }
    public void notificacionCorreoDesviacion(){
        try {
            String contenidoCorreo = "";


        String consulta = " select m1.COD_MATERIAL,m1.NOMBRE_MATERIAL,f.CANTIDAD,m.COD_MATERIAL,m.NOMBRE_MATERIAL,p.CANTIDAD" +
                " from FORMULA_MAESTRA_DETALLE_MP f" +
                " inner join FORMULA_MAESTRA fm on fm.COD_FORMULA_MAESTRA = f.COD_FORMULA_MAESTRA" +
                " and f.COD_FORMULA_MAESTRA = 86" +
                " inner join materiales m1 on m1.COD_MATERIAL = f.COD_MATERIAL" +
                " full outer join" +
                " PROGRAMA_PRODUCCION_DETALLE p on" +
                " fm.COD_COMPPROD = p.COD_COMPPROD" +
                " and f.COD_MATERIAL = p.COD_MATERIAL" +
                " inner join materiales m on m.COD_MATERIAL = p.COD_MATERIAL" +
                " inner join GRUPOS g on g.COD_GRUPO = m.COD_GRUPO and g.COD_CAPITULO = 2" +
                " where p.COD_LOTE_PRODUCCION = '2011744'" +
                " and p.COD_TIPO_PROGRAMA_PROD = 1" +
                " and p.COD_COMPPROD = 238" +
                " and p.COD_PROGRAMA_PROD = 183" +
                " and p.COD_ESTADO_REGISTRO = 1 ";
        Connection con = null;
        con = Util.openConnection(con);
        Statement st = con.createStatement();
        ResultSet rs = st.executeQuery(consulta);
        contenidoCorreo = "<style></style>";
        while(rs.next()){
            
            
        }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public String modificarMaterialesProducto_action(){
        programaProduccionSeleccionado = (ProgramaProduccion)programaProduccionSeguimientoDataTable.getRowData();
        return null;
    }


    
    public List<ProgramaProduccionDevolucionMaterialDetalle> getDevolucionesMaterialDetalleList() {
        return devolucionesMaterialDetalleList;
    }

    public void setDevolucionesMaterialDetalleList(List<ProgramaProduccionDevolucionMaterialDetalle> devolucionesMaterialDetalleList) {
        this.devolucionesMaterialDetalleList = devolucionesMaterialDetalleList;
    }
    //final ale devoluciones
    //<editor-fold desc="explosion empaque secundario almacen">
    public String explosionEmpaqueSecundarioAlmacen_action()throws SQLException
    {
        mensaje = "";
        try {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            ManagedAccesoSistema managed=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
            StringBuilder consulta = new StringBuilder("INSERT INTO EXPLOSION_EMPAQUE_SECUNDARIO_ALMACEN(COD_PROGRAMA_PROD,FECHA_REGISTRO, COD_PERSONAL_REGISTRO)");
                                consulta.append(" VALUES (");
                                        consulta.append(programaProduccionPeriodoBean.getCodProgramaProduccion()).append(",");
                                        consulta.append("getdate(),");
                                        consulta.append(managed.getUsuarioModuloBean().getCodUsuarioGlobal());
                                consulta.append(")");
            LOGGER.debug("consulta registrar explosion es " + consulta.toString());
            PreparedStatement pst = con.prepareStatement(consulta.toString(), PreparedStatement.RETURN_GENERATED_KEYS);
            if (pst.executeUpdate() > 0) LOGGER.info("se registro la explosion de es");
            ResultSet res=pst.getGeneratedKeys();
            res.next();
            codExplosionEmpaqueSecundarioAlmacen=res.getInt(1);
            consulta=new StringBuilder("INSERT INTO EXPLOSION_EMPAQUE_SECUNDARIO_ALMACEN_DETALLE(COD_EXPLOSION_EMPAQUE_SECUNDARIO_ALMACEN, COD_LOTE_PRODUCCION, COD_COMPPROD,COD_TIPO_PROGRAMA_PROD)");
                        consulta.append("VALUES (");
                                consulta.append(res.getInt(1)).append(",");
                                consulta.append("?,");//lote de produccion
                                consulta.append("?,");//cod compprod
                                consulta.append("?");//cod tipo programa prod
                        consulta.append(")");
            LOGGER.debug("consulta registrar detalle "+consulta.toString());
            pst=con.prepareStatement(consulta.toString());
            for(ProgramaProduccion bean:programaProduccionList)
            {
                if(bean.getChecked())
                {
                    pst.setString(1,bean.getCodLoteProduccion());LOGGER.info("p1:"+bean.getCodLoteProduccion());   
                    pst.setInt(2,Integer.valueOf(bean.getFormulaMaestra().getComponentesProd().getCodCompprod()));LOGGER.info("p2:"+bean.getFormulaMaestra().getComponentesProd().getCodCompprod());
                    pst.setInt(3,Integer.valueOf(bean.getTiposProgramaProduccion().getCodTipoProgramaProd()));LOGGER.info("p3:"+bean.getTiposProgramaProduccion().getCodTipoProgramaProd());
                    pst.executeUpdate();
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
    //</editor-fold>
    //<editor-fold desc="getter and setter" defaultstate="collapsed">

        public boolean isPermisoCancelacionLoteProduccion() {
            return permisoCancelacionLoteProduccion;
        }

        public void setPermisoCancelacionLoteProduccion(boolean permisoCancelacionLoteProduccion) {
            this.permisoCancelacionLoteProduccion = permisoCancelacionLoteProduccion;
        }

        public boolean isPermisoEditarLoteProducccion() {
            return permisoEditarLoteProducccion;
        }

        public void setPermisoEditarLoteProducccion(boolean permisoEditarLoteProducccion) {
            this.permisoEditarLoteProducccion = permisoEditarLoteProducccion;
        }

       
        
        public ProgramaProduccion getProgramaProduccionApertura() {
            return programaProduccionApertura;
        }

        public boolean isPermisoEditarEnvioAcondicionamiento() {
            return permisoEditarEnvioAcondicionamiento;
        }

        public void setPermisoEditarEnvioAcondicionamiento(boolean permisoEditarEnvioAcondicionamiento) {
            this.permisoEditarEnvioAcondicionamiento = permisoEditarEnvioAcondicionamiento;
        }

        public boolean isPermisoAnularEnvioAcondicionamiento() {
            return permisoAnularEnvioAcondicionamiento;
        }

        public void setPermisoAnularEnvioAcondicionamiento(boolean permisoAnularEnvioAcondicionamiento) {
            this.permisoAnularEnvioAcondicionamiento = permisoAnularEnvioAcondicionamiento;
        }


        

        public void setProgramaProduccionApertura(ProgramaProduccion programaProduccionApertura) {
            this.programaProduccionApertura = programaProduccionApertura;
        }

        public int getCodTipoProduccion() {
            return codTipoProduccion;
        }

        public void setCodTipoProduccion(int codTipoProduccion) {
            this.codTipoProduccion = codTipoProduccion;
        }

        public List<FormulaMaestraEsVersion> getFormulaMaestraEsVersionList() {
            return formulaMaestraEsVersionList;
        }

        public void setFormulaMaestraEsVersionList(List<FormulaMaestraEsVersion> formulaMaestraEsVersionList) {
            this.formulaMaestraEsVersionList = formulaMaestraEsVersionList;
        }

        public ProgramaProduccion getProgramaProduccionCambiarFormulaEs() {
            return programaProduccionCambiarFormulaEs;
        }

        public void setProgramaProduccionCambiarFormulaEs(ProgramaProduccion programaProduccionCambiarFormulaEs) {
            this.programaProduccionCambiarFormulaEs = programaProduccionCambiarFormulaEs;
        }



        

        public ProgramaProduccion getProgramaProduccionbean() {
             return programaProduccionbean;
         }

    

        public boolean isPermisoAperturaLoteProduccion() {
            return permisoAperturaLoteProduccion;
        }

        public void setPermisoAperturaLoteProduccion(boolean permisoAperturaLoteProduccion) {
            this.permisoAperturaLoteProduccion = permisoAperturaLoteProduccion;
        }

         public void setProgramaProduccionbean(ProgramaProduccion programaProduccionbean) {
             this.programaProduccionbean = programaProduccionbean;
         }

         public List getProgramaProduccionList() {
             return programaProduccionList;
         }

         public void setProgramaProduccionList(List programaProduccionList) {
             this.programaProduccionList = programaProduccionList;
         }

         public List getProgramaProduccionEliminarList() {
             return programaProduccionEliminarList;
         }

         public void setProgramaProduccionEliminarList(List programaProduccionEliminarList) {
             this.programaProduccionEliminarList = programaProduccionEliminarList;
         }

         public List getProgramaProduccionNoEliminarList() {
             return programaProduccionNoEliminarList;
         }

         public void setProgramaProduccionNoEliminarList(List programaProduccionNoEliminarList) {
             this.programaProduccionNoEliminarList = programaProduccionNoEliminarList;
         }

         public Connection getCon() {
             return con;
         }

         public void setCon(Connection con) {
             this.con = con;
         }

         public String getCodigo() {
             return codigo;
         }

         public void setCodigo(String codigo) {
             this.codigo = codigo;
         }

         public boolean isSwEliminaSi() {
             return swEliminaSi;
         }

         public void setSwEliminaSi(boolean swEliminaSi) {
             this.swEliminaSi = swEliminaSi;
         }

         public boolean isSwEliminaNo() {
             return swEliminaNo;
         }

         public void setSwEliminaNo(boolean swEliminaNo) {
             this.swEliminaNo = swEliminaNo;
         }


         public String getNombreFromulaMaestra() {
             return nombreFromulaMaestra;
         }

         public void setNombreFromulaMaestra(String nombreFromulaMaestra) {
             this.nombreFromulaMaestra = nombreFromulaMaestra;
         }

         public String getCodFormulaMaestra() {
             return codFormulaMaestra;
         }

         public void setCodFormulaMaestra(String codFormulaMaestra) {
             this.codFormulaMaestra = codFormulaMaestra;
         }

         public String getCantidadLote() {
             return cantidadLote;
         }

         public void setCantidadLote(String cantidadLote) {
             this.cantidadLote = cantidadLote;
         }

         public String getCodigos() {
             return codigos;
         }

         public void setCodigos(String codigos) {
             this.codigos = codigos;
         }

         public String getFecha_inicio() {
             return fecha_inicio;
         }

         public void setFecha_inicio(String fecha_inicio) {
             this.fecha_inicio = fecha_inicio;
         }

         public String getFecha_final() {
             return fecha_final;
         }

         public void setFecha_final(String fecha_final) {
             this.fecha_final = fecha_final;
         }

         public List getEmpaquePrimarioList() {
             return empaquePrimarioList;
         }

         public void setEmpaquePrimarioList(List empaquePrimarioList) {
             this.empaquePrimarioList = empaquePrimarioList;
         }

         public List getEmpaqueSecundarioList() {
             return empaqueSecundarioList;
         }

         public void setEmpaqueSecundarioList(List empaqueSecundarioList) {
             this.empaqueSecundarioList = empaqueSecundarioList;
         }

         public String getCodPresPrim() {
             return codPresPrim;
         }

         public void setCodPresPrim(String codPresPrim) {
             this.codPresPrim = codPresPrim;
         }

         public String getCodPresProd() {
             return codPresProd;
         }

         public void setCodPresProd(String codPresProd) {
             this.codPresProd = codPresProd;
         }

         public String getCodProgramaProd() {
             return codProgramaProd;
         }

         public void setCodProgramaProd(String codProgramaProd) {
             this.codProgramaProd = codProgramaProd;
         }

         /**
          * @return the tiposProgramaProdList
          */
         public List getTiposProgramaProdList() {
             return tiposProgramaProdList;
         }

         /**
          * @param tiposProgramaProdList the tiposProgramaProdList to set
          */
         public void setTiposProgramaProdList(List tiposProgramaProdList) {
             this.tiposProgramaProdList = tiposProgramaProdList;
         }

         public String getMensajes() {
             return mensajes;
         }

         public void setMensajes(String mensajes) {
             this.mensajes = mensajes;
         }

         public List<ActividadesProgramaProduccionFaltantes> getSeguimientoProgramaProduccionList() {
             return seguimientoProgramaProduccionList;
         }

         public void setSeguimientoProgramaProduccionList(List<ActividadesProgramaProduccionFaltantes> seguimientoProgramaProduccionList) {
             this.seguimientoProgramaProduccionList = seguimientoProgramaProduccionList;
         }

         public List<ActividadesProgramaProduccionFaltantes> getActividadesProgramaProduccionList() {
             return actividadesProgramaProduccionList;
         }

         public void setActividadesProgramaProduccionList(List<ActividadesProgramaProduccionFaltantes> actividadesProgramaProduccionList) {
             this.actividadesProgramaProduccionList = actividadesProgramaProduccionList;
         }

         public List getAreaProgramaProduccionList() {
             return areaProgramaProduccionList;
         }

         public void setAreaProgramaProduccionList(List areaProgramaProduccionList) {
             this.areaProgramaProduccionList = areaProgramaProduccionList;
         }

         public String getCodAreaProgramaProduccion() {
             return codAreaProgramaProduccion;
         }

         public void setCodAreaProgramaProduccion(String codAreaProgramaProduccion) {
             this.codAreaProgramaProduccion = codAreaProgramaProduccion;
         }

         public Date getFechaLote() {
             return fechaLote;
         }

         public void setFechaLote(Date fechaLote) {
             this.fechaLote = fechaLote;
         }

         public List getAlmacenAcondicionamientoList() {
             return almacenAcondicionamientoList;
         }

         public void setAlmacenAcondicionamientoList(List almacenAcondicionamientoList) {
             this.almacenAcondicionamientoList = almacenAcondicionamientoList;
         }

         public IngresosAcond getIngresosAcondicionamiento() {
             return ingresosAcondicionamiento;
         }

         public void setIngresosAcondicionamiento(IngresosAcond ingresosAcondicionamiento) {
             this.ingresosAcondicionamiento = ingresosAcondicionamiento;
         }

         public List<IngresosDetalleAcond> getIngresosAlmacenDetalleAcondList() {
             return ingresosAlmacenDetalleAcondList;
         }

         public void setIngresosAlmacenDetalleAcondList(List<IngresosDetalleAcond> ingresosAlmacenDetalleAcondList) {
             this.ingresosAlmacenDetalleAcondList = ingresosAlmacenDetalleAcondList;
         }

         public HtmlDataTable getIngresosAlmacenDetalleAcondDataTable() {
             return ingresosAlmacenDetalleAcondDataTable;
         }

         public void setIngresosAlmacenDetalleAcondDataTable(HtmlDataTable ingresosAlmacenDetalleAcondDataTable) {
             this.ingresosAlmacenDetalleAcondDataTable = ingresosAlmacenDetalleAcondDataTable;
         }

         public List<IngresosdetalleCantidadPeso> getCantidadesBolsasList() {
             return cantidadesBolsasList;
         }

         public void setCantidadesBolsasList(List<IngresosdetalleCantidadPeso> cantidadesBolsasList) {
             this.cantidadesBolsasList = cantidadesBolsasList;
         }

         public List getCantidadEnvaseList() {
             return cantidadEnvaseList;
         }

         public void setCantidadEnvaseList(List cantidadEnvaseList) {
             this.cantidadEnvaseList = cantidadEnvaseList;
         }

         public HtmlDataTable getProgramaProduccionDataTable() {
             return programaProduccionDataTable;
         }

         public void setProgramaProduccionDataTable(HtmlDataTable programaProduccionDataTable) {
             this.programaProduccionDataTable = programaProduccionDataTable;
         }

         public ComponentesProd getComponentesProdBuscar() {
             return componentesProdBuscar;
         }

         public void setComponentesProdBuscar(ComponentesProd componentesProdBuscar) {
             this.componentesProdBuscar = componentesProdBuscar;
         }

         public List getComponentesProdFormulaMaestraList() {
             return componentesProdFormulaMaestraList;
         }

         public void setComponentesProdFormulaMaestraList(List componentesProdFormulaMaestraList) {
             this.componentesProdFormulaMaestraList = componentesProdFormulaMaestraList;
         }

         public HtmlDataTable getComponentesProdFormulaMaestraDataTable() {
             return componentesProdFormulaMaestraDataTable;
         }

         public void setComponentesProdFormulaMaestraDataTable(HtmlDataTable componentesProdFormulaMaestraDataTable) {
             this.componentesProdFormulaMaestraDataTable = componentesProdFormulaMaestraDataTable;
         }

         public List getProgramaProduccionLotesList() {
             return programaProduccionLotesList;
         }

         public void setProgramaProduccionLotesList(List programaProduccionLotesList) {
             this.programaProduccionLotesList = programaProduccionLotesList;
         }

         public HtmlDataTable getProgramaProduccionLotesDataTable() {
             return programaProduccionLotesDataTable;
         }

         public void setProgramaProduccionLotesDataTable(HtmlDataTable programaProduccionLotesDataTable) {
             this.programaProduccionLotesDataTable = programaProduccionLotesDataTable;
         }

         public List getProgramaProduccionProductosList() {
             return programaProduccionProductosList;
         }

         public void setProgramaProduccionProductosList(List programaProduccionProductosList) {
             this.programaProduccionProductosList = programaProduccionProductosList;
         }

         public String getMensaje() {
             return mensaje;
         }

         public void setMensaje(String mensaje) {
             this.mensaje = mensaje;
         }
         
         public List getProgramaProduccionAgregarList() {
             return programaProduccionAgregarList;
         }
         
         public Double getProgramaProduccionAgregarListSumaCantidad() {
             Double cantidadTotalLote = 0d;
             for(ProgramaProduccion bean : (List<ProgramaProduccion>)programaProduccionAgregarList)
             {
                 cantidadTotalLote += bean.getCantidadLote();
             }
             return cantidadTotalLote;
         }

         public void setProgramaProduccionAgregarList(List programaProduccionAgregarList) {
             this.programaProduccionAgregarList = programaProduccionAgregarList;
         }

         public HtmlDataTable getProgramaProduccionAgregarDataTable() {
             return programaProduccionAgregarDataTable;
         }

         public void setProgramaProduccionAgregarDataTable(HtmlDataTable programaProduccionAgregarDataTable) {
             this.programaProduccionAgregarDataTable = programaProduccionAgregarDataTable;
         }

         public ManagedAccesoSistema getUsuario() {
             return usuario;
         }

         public void setUsuario(ManagedAccesoSistema usuario) {
             this.usuario = usuario;
         }

    

         
         public ProgramaProduccion getProgramaProduccionSeguimientoBuscar() {
             return programaProduccionSeguimientoBuscar;
         }

         public void setProgramaProduccionSeguimientoBuscar(ProgramaProduccion programaProduccionSeguimientoBuscar) {
             this.programaProduccionSeguimientoBuscar = programaProduccionSeguimientoBuscar;
         }




         public String getCodAreaActividadProd() {
             return codAreaActividadProd;
         }

         public void setCodAreaActividadProd(String codAreaActividadProd) {
             this.codAreaActividadProd = codAreaActividadProd;
         }

         public String getCodReserva() {
             return codReserva;
         }

         public void setCodReserva(String codReserva) {
             this.codReserva = codReserva;
         }

         public String getCod_comp_prod() {
             return cod_comp_prod;
         }

         public void setCod_comp_prod(String cod_comp_prod) {
             this.cod_comp_prod = cod_comp_prod;
         }

         public String getCod_lote() {
             return cod_lote;
         }

         public void setCod_lote(String cod_lote) {
             this.cod_lote = cod_lote;
         }

         public List<SelectItem> getListaAreasActividad() {
             return listaAreasActividad;
         }

         public void setListaAreasActividad(List<SelectItem> listaAreasActividad) {
             this.listaAreasActividad = listaAreasActividad;
         }

         public List<SelectItem> getListaPersonal() {
             return listaPersonal;
         }

         public void setListaPersonal(List<SelectItem> listaPersonal) {
             this.listaPersonal = listaPersonal;
         }

         public List<SeguimientoProgramaProduccionIndirecto> getListaSeguimientoIndirecto() {
             return listaSeguimientoIndirecto;
         }

         public void setListaSeguimientoIndirecto(List<SeguimientoProgramaProduccionIndirecto> listaSeguimientoIndirecto) {
             this.listaSeguimientoIndirecto = listaSeguimientoIndirecto;
         }

         public List<SeguimientoProgramaProduccionIndirectoPersonal> getListaSeguimientoPersonal() {
             return listaSeguimientoPersonal;
         }

         public void setListaSeguimientoPersonal(List<SeguimientoProgramaProduccionIndirectoPersonal> listaSeguimientoPersonal) {
             this.listaSeguimientoPersonal = listaSeguimientoPersonal;
         }

         public ProgramaProduccion getProgramaProduccionActividadesPendientes() {
             return programaProduccionActividadesPendientes;
         }

         public void setProgramaProduccionActividadesPendientes(ProgramaProduccion programaProduccionActividadesPendientes) {
             this.programaProduccionActividadesPendientes = programaProduccionActividadesPendientes;
         }

         public ProgramaProduccion getProgramaProduccionSeleccionado() {
             return programaProduccionSeleccionado;
         }

         public void setProgramaProduccionSeleccionado(ProgramaProduccion programaProduccionSeleccionado) {
             this.programaProduccionSeleccionado = programaProduccionSeleccionado;
         }

         public HtmlDataTable getSeguimientoIndirectoDataTable() {
             return seguimientoIndirectoDataTable;
         }

         public void setSeguimientoIndirectoDataTable(HtmlDataTable seguimientoIndirectoDataTable) {
             this.seguimientoIndirectoDataTable = seguimientoIndirectoDataTable;
         }

         public HtmlDataTable getSeguimientoIndirectoPersonalDataTable() {
             return seguimientoIndirectoPersonalDataTable;
         }

         public void setSeguimientoIndirectoPersonalDataTable(HtmlDataTable seguimientoIndirectoPersonalDataTable) {
             this.seguimientoIndirectoPersonalDataTable = seguimientoIndirectoPersonalDataTable;
         }

         public List<SelectItem> getComponentesProdList() {
             return componentesProdList;
         }

         public void setComponentesProdList(List<SelectItem> componentesProdList) {
             this.componentesProdList = componentesProdList;
         }

         public ProgramaProduccion getCurrentProgramaProd() {
             return currentProgramaProd;
         }

         public void setCurrentProgramaProd(ProgramaProduccion currentProgramaProd) {
             this.currentProgramaProd = currentProgramaProd;
         }

         public String getLoteDivisible() {
             return loteDivisible;
         }

         public void setLoteDivisible(String loteDivisible) {
             this.loteDivisible = loteDivisible;
         }

         public List<SelectItem> getProductosDivisiblesList() {
             return productosDivisiblesList;
         }

         public void setProductosDivisiblesList(List<SelectItem> productosDivisiblesList) {
             this.productosDivisiblesList = productosDivisiblesList;
         }

         public HtmlDataTable getProgramaProduccionEditarDataTable() {
             return programaProduccionEditarDataTable;
         }

         public void setProgramaProduccionEditarDataTable(HtmlDataTable programaProduccionEditarDataTable) {
             this.programaProduccionEditarDataTable = programaProduccionEditarDataTable;
         }

         public HtmlDataTable getProgramaProduccionSeguimientoDataTable() {
             return programaProduccionSeguimientoDataTable;
         }

         public void setProgramaProduccionSeguimientoDataTable(HtmlDataTable programaProduccionSeguimientoDataTable) {
             this.programaProduccionSeguimientoDataTable = programaProduccionSeguimientoDataTable;
         }

         public List<ProgramaProduccion> getProgramaProduccionSeguimientoList() {
             return programaProduccionSeguimientoList;
         }

         public void setProgramaProduccionSeguimientoList(List<ProgramaProduccion> programaProduccionSeguimientoList) {
             this.programaProduccionSeguimientoList = programaProduccionSeguimientoList;
         }

         public ProgramaProduccion getProgramaProduccionEditar() {
             return programaProduccionEditar;
         }

         public void setProgramaProduccionEditar(ProgramaProduccion programaProduccionEditar) {
             this.programaProduccionEditar = programaProduccionEditar;
         }

         public List<ProgramaProduccion> getProgramaProduccionEditarList() {
             return programaProduccionEditarList;
         }
         public Double getProgramaProduccionEditarListSumaCantidad() {
             Double cantidadTotalLote = 0d;
             for(ProgramaProduccion bean : (List<ProgramaProduccion>)programaProduccionEditarList)
             {
                 cantidadTotalLote += bean.getCantidadLote();
             }
             return cantidadTotalLote;
         }
         public void setProgramaProduccionEditarList(List<ProgramaProduccion> programaProduccionEditarList) {
             this.programaProduccionEditarList = programaProduccionEditarList;
         }

         public String getMensajeSolicitudAutomatica() {
             return mensajeSolicitudAutomatica;
         }

         public void setMensajeSolicitudAutomatica(String mensajeSolicitudAutomatica) {
             this.mensajeSolicitudAutomatica = mensajeSolicitudAutomatica;
         }

         public ProgramaProduccionPeriodo getProgramaProduccionPeriodoIndirectas() {
             return programaProduccionPeriodoIndirectas;
         }

         public void setProgramaProduccionPeriodoIndirectas(ProgramaProduccionPeriodo programaProduccionPeriodoIndirectas) {
             this.programaProduccionPeriodoIndirectas = programaProduccionPeriodoIndirectas;
         }

         public double getCantidadProductosPorCaja() {
             return cantidadProductosPorCaja;
         }

         public void setCantidadProductosPorCaja(double cantidadProductosPorCaja) {
             this.cantidadProductosPorCaja = cantidadProductosPorCaja;
         }

         public List getMaterialesVencidosList() {
             return materialesVencidosList;
         }

         public void setMaterialesVencidosList(List materialesVencidosList) {
             this.materialesVencidosList = materialesVencidosList;
         }

         public List getFormulaMaestraDetalleEPMoficarList() {
             return formulaMaestraDetalleEPMoficarList;
         }

         public void setFormulaMaestraDetalleEPMoficarList(List formulaMaestraDetalleEPMoficarList) {
             this.formulaMaestraDetalleEPMoficarList = formulaMaestraDetalleEPMoficarList;
         }

         public List getFormulaMaestraDetalleESMoficarList() {
             return formulaMaestraDetalleESMoficarList;
         }

         public void setFormulaMaestraDetalleESMoficarList(List formulaMaestraDetalleESMoficarList) {
             this.formulaMaestraDetalleESMoficarList = formulaMaestraDetalleESMoficarList;
         }

         public List getFormulaMaestraDetalleMPMoficarList() {
             return formulaMaestraDetalleMPMoficarList;
         }

         public void setFormulaMaestraDetalleMPMoficarList(List formulaMaestraDetalleMPMoficarList) {
             this.formulaMaestraDetalleMPMoficarList = formulaMaestraDetalleMPMoficarList;
         }

         public List getMateriaEPList() {
             return materiaEPList;
         }

         public void setMateriaEPList(List materiaEPList) {
             this.materiaEPList = materiaEPList;
         }

         public List getMateriaESList() {
             return materiaESList;
         }

         public void setMateriaESList(List materiaESList) {
             this.materiaESList = materiaESList;
         }

         public List getMateriaMPList() {
             return materiaMPList;
         }

         public void setMateriaMPList(List materiaMPList) {
             this.materiaMPList = materiaMPList;
         }

         public String getUnidades() {
             return unidades;
         }

         public void setUnidades(String unidades) {
             this.unidades = unidades;
         }

         public HtmlDataTable getMaterialesDataTable() {
             return materialesDataTable;
         }

         public void setMaterialesDataTable(HtmlDataTable materialesDataTable) {
             this.materialesDataTable = materialesDataTable;
         }

         public List getCpVersionesList() {
             return cpVersionesList;
         }

         public void setCpVersionesList(List cpVersionesList) {
             this.cpVersionesList = cpVersionesList;
         }

         public List getFmVersionesList() {
             return fmVersionesList;
         }

         public void setFmVersionesList(List fmVersionesList) {
             this.fmVersionesList = fmVersionesList;
         }

         public String getCodLoteProducionEditar() {
             return codLoteProducionEditar;
         }

         public void setCodLoteProducionEditar(String codLoteProducionEditar) {
             this.codLoteProducionEditar = codLoteProducionEditar;
         }

         public ProgramaProduccion getProgramaProduccionFiltro() {
             return programaProduccionFiltro;
         }

         public void setProgramaProduccionFiltro(ProgramaProduccion programaProduccionFiltro) {
             this.programaProduccionFiltro = programaProduccionFiltro;
         }

    public IngresosAcond getIngresosAcond() {
        return ingresosAcond;
    }

    public void setIngresosAcond(IngresosAcond ingresosAcond) {
        this.ingresosAcond = ingresosAcond;
    }

        
        public int getIngresosDetalleAcondRegistradosListSumaTotal(){
            int sumaCantidadTotal = 0;
            if(ingresosDetalleAcondRegistradosList != null)
            {
                for(IngresosAcond bean : ingresosDetalleAcondRegistradosList){
                    sumaCantidadTotal += bean.getIngresosDetalleAcondList().get(0).getCantTotalIngreso();
                }
            }
            return sumaCantidadTotal;
        }
         public List<IngresosAcond> getIngresosDetalleAcondRegistradosList() {
             return ingresosDetalleAcondRegistradosList;
         }

         public void setIngresosDetalleAcondRegistradosList(List<IngresosAcond> ingresosDetalleAcondRegistradosList) {
             this.ingresosDetalleAcondRegistradosList = ingresosDetalleAcondRegistradosList;
         }

         public List<SelectItem> getTiposEnvaseSelectList() {
             return tiposEnvaseSelectList;
         }

         public void setTiposEnvaseSelectList(List<SelectItem> tiposEnvaseSelectList) {
             this.tiposEnvaseSelectList = tiposEnvaseSelectList;
         }

         public List<SelectItem> getCantidadEnvaseSelectList() {
             return cantidadEnvaseSelectList;
         }

         public void setCantidadEnvaseSelectList(List<SelectItem> cantidadEnvaseSelectList) {
             this.cantidadEnvaseSelectList = cantidadEnvaseSelectList;
         }

         public boolean isEntregaTotal() {
             return entregaTotal;
         }

         public void setEntregaTotal(boolean entregaTotal) {
             this.entregaTotal = entregaTotal;
         }

         public IngresosDetalleAcond getIngresosAcondicionamientoEtiqueta() {
             return ingresosAcondicionamientoEtiqueta;
         }

         public void setIngresosAcondicionamientoEtiqueta(IngresosDetalleAcond ingresosAcondicionamientoEtiqueta) {
             this.ingresosAcondicionamientoEtiqueta = ingresosAcondicionamientoEtiqueta;
         }

         public List<SelectItem> getClienteSelectList() {
             return clienteSelectList;
         }

         public void setClienteSelectList(List<SelectItem> clienteSelectList) {
             this.clienteSelectList = clienteSelectList;
         }

         public List<SelectItem> getPresentacionesSecundariasSelectList() {
             return presentacionesSecundariasSelectList;
         }

         public void setPresentacionesSecundariasSelectList(List<SelectItem> presentacionesSecundariasSelectList) {
             this.presentacionesSecundariasSelectList = presentacionesSecundariasSelectList;
         }

         public Date getFechaEtiquetasPesaje() {
             return fechaEtiquetasPesaje;
         }

         public void setFechaEtiquetasPesaje(Date fechaEtiquetasPesaje) {
             this.fechaEtiquetasPesaje = fechaEtiquetasPesaje;
         }

         

         public ProgramaProduccion getProgramaProduccionImpresionOm() {
             return programaProduccionImpresionOm;
         }

         public void setProgramaProduccionImpresionOm(ProgramaProduccion programaProduccionImpresionOm) {
             this.programaProduccionImpresionOm = programaProduccionImpresionOm;
         }

         public List<ProgramaProduccionImpresionOm> getProgramaProduccionImpresionOmList() {
             return programaProduccionImpresionOmList;
         }

        public List<SelectItem> getTiposProduccionSelectList() {
            return tiposProduccionSelectList;
        }

        public void setTiposProduccionSelectList(List<SelectItem> tiposProduccionSelectList) {
            this.tiposProduccionSelectList = tiposProduccionSelectList;
        }


         
         

         public void setProgramaProduccionImpresionOmList(List<ProgramaProduccionImpresionOm> programaProduccionImpresionOmList) {
             this.programaProduccionImpresionOmList = programaProduccionImpresionOmList;
         }

         public boolean isPermisoImpresionOm() {
             return permisoImpresionOm;
         }

         public void setPermisoImpresionOm(boolean permisoImpresionOm) {
             this.permisoImpresionOm = permisoImpresionOm;
         }

         public boolean isPermisoGeneracionDesviacion() {
             return permisoGeneracionDesviacion;
         }

         public void setPermisoGeneracionDesviacion(boolean permisoGeneracionDesviacion) {
             this.permisoGeneracionDesviacion = permisoGeneracionDesviacion;
         }

         public boolean isPermisoGeneracionLotes() {
             return permisoGeneracionLotes;
         }

         public void setPermisoGeneracionLotes(boolean permisoGeneracionLotes) {
             this.permisoGeneracionLotes = permisoGeneracionLotes;
         }

         public boolean isPermisoImpresionEtiquetasMP() {
             return permisoImpresionEtiquetasMP;
         }

         public void setPermisoImpresionEtiquetasMP(boolean permisoImpresionEtiquetasMP) {
             this.permisoImpresionEtiquetasMP = permisoImpresionEtiquetasMP;
         }

         public boolean isPermisoImpresionEtiquetasMpFecha() {
             return permisoImpresionEtiquetasMpFecha;
         }

         public void setPermisoImpresionEtiquetasMpFecha(boolean permisoImpresionEtiquetasMpFecha) {
             this.permisoImpresionEtiquetasMpFecha = permisoImpresionEtiquetasMpFecha;
         }

         public boolean isPermisoTiemposProduccion() {
             return permisoTiemposProduccion;
         }

         public void setPermisoTiemposProduccion(boolean permisoTiemposProduccion) {
             this.permisoTiemposProduccion = permisoTiemposProduccion;
         }

         public boolean isPermisoTiemposMicrobiologia() {
             return permisoTiemposMicrobiologia;
         }

         public void setPermisoTiemposMicrobiologia(boolean permisoTiemposMicrobiologia) {
             this.permisoTiemposMicrobiologia = permisoTiemposMicrobiologia;
         }

         public boolean isPermisoTiemposCC() {
             return permisoTiemposCC;
         }

         public void setPermisoTiemposCC(boolean permisoTiemposCC) {
             this.permisoTiemposCC = permisoTiemposCC;
         }

         public boolean isPermisotiemposAcond() {
             return permisotiemposAcond;
         }

         public void setPermisotiemposAcond(boolean permisotiemposAcond) {
             this.permisotiemposAcond = permisotiemposAcond;
         }

         public int getCodExplosionEmpaqueSecundarioAlmacen() {
             return codExplosionEmpaqueSecundarioAlmacen;
         }

         public void setCodExplosionEmpaqueSecundarioAlmacen(int codExplosionEmpaqueSecundarioAlmacen) {
             this.codExplosionEmpaqueSecundarioAlmacen = codExplosionEmpaqueSecundarioAlmacen;
         }

         public boolean isPermisoTerminarProducto() {
             return permisoTerminarProducto;
         }

         public void setPermisoTerminarProducto(boolean permisoTerminarProducto) {
             this.permisoTerminarProducto = permisoTerminarProducto;
         }

         public HtmlDataTable getProgramaProduccionPeriodoSeguimientoDataTable() {
             return programaProduccionPeriodoSeguimientoDataTable;
         }

         public void setProgramaProduccionPeriodoSeguimientoDataTable(HtmlDataTable programaProduccionPeriodoSeguimientoDataTable) {
             this.programaProduccionPeriodoSeguimientoDataTable = programaProduccionPeriodoSeguimientoDataTable;
         }

         public boolean isPermisoTiempoSoporteManufactura() {
             return permisoTiempoSoporteManufactura;
         }

         public void setPermisoTiempoSoporteManufactura(boolean permisoTiempoSoporteManufactura) {
             this.permisoTiempoSoporteManufactura = permisoTiempoSoporteManufactura;
         }
    //</editor-fold>
    
    
}
