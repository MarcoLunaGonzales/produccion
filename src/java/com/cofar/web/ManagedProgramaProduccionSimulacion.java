
package com.cofar.web;

import com.cofar.bean.FormulaMaestra;
import com.cofar.bean.FormulaMaestraDetalleMP;
import com.cofar.bean.ProgramaProduccion;
import com.cofar.bean.Materiales;
import com.cofar.bean.Maquinaria;
import com.cofar.bean.AbstractBean;


import com.cofar.bean.ExplosionMateriales;
import com.cofar.bean.MaquinariaActividadesFormula;
import com.cofar.bean.MaterialesConflicto;
import com.cofar.bean.ProductosDivisionLotes;
import com.cofar.bean.ProgramaProduccionPeriodo;
import com.cofar.util.Util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import javax.faces.event.ValueChangeEvent;
import javax.faces.model.SelectItem;
import java.text.NumberFormat;
import java.util.Locale;
import java.util.Map;
import javax.faces.context.ExternalContext;
import javax.faces.context.FacesContext;
import javax.servlet.http.HttpServletRequest;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.richfaces.component.html.HtmlDataTable;


/**
 *
 *  @author Wilmer Manzaneda Chavez
 *  @company COFAR
 */
public class ManagedProgramaProduccionSimulacion extends ManagedBean
{
    
    /** Creates a new instance of ManagedTipoCliente */
    private List<SelectItem> areasFabricacionProduccionList;
    private List<String> codAreasFabricacionProduccionList=new ArrayList<String>();
    private List<FormulaMaestra> formulaMaestraAgregarList=null;
    private List<ProductosDivisionLotes> productosDivisionLotesList=null;
    private ProgramaProduccion programaProduccionCabeceraAgregar=null;
    private ProgramaProduccion programaProduccionbean = new ProgramaProduccion();
    private List<ProgramaProduccion> programaProduccionList = new ArrayList<ProgramaProduccion>();
    private List programaProduccionEliminarList = new ArrayList();
    private List programaProduccionNoEliminarList = new ArrayList();
    private Connection con;
    private String codigo = "";
    private boolean swEliminaSi;
    private boolean swEliminaNo;
    private List formulaMaestraList = new ArrayList();
    private List formulaMaestraMPROMList = new ArrayList();
    private List formulaMaestraMPList = new ArrayList();
    private List formulaMaestraMPReactivosList = new ArrayList();
    private List formulaMaestraEPList = new ArrayList();
    private List formulaMaestraESList = new ArrayList();
    private List formulaMaestraMRList = new ArrayList();
    private List empaquePrimarioList = new ArrayList();
    private List empaqueSecundarioList = new ArrayList();
    private List areasEmpresaList = new ArrayList();
    
    private List tiposProgramaProdList = new ArrayList();
    
    private List<String[]> explotacionMaquinariasLista= new ArrayList<String[]>();
    private String nombreFromulaMaestra = "";
    private String codFormulaMaestra = "";
    private String codPresPrim = "";
    private String codPresProd = "";
    private String codProgramaProd = "0";
    
    private float hrs_maquina = 0;
    private float hrs_hombre = 0;
    
    private String cantidadLote = "";
    private double totalLote = 0;
    List programaProduccionProductoList = new ArrayList();
    HtmlDataTable programaProduccionDataTable = new HtmlDataTable();
    List programaProduccionLotesList = new ArrayList();
    HtmlDataTable programaProduccionLotesDataTable = new HtmlDataTable();
    String mensaje = "";
    List programaProduccionProductosList = new ArrayList();
    HtmlDataTable programaProduccionProductosDataTable = new HtmlDataTable();
    List<ProgramaProduccion> programaProduccionAgregarList = new ArrayList<ProgramaProduccion>();
    HtmlDataTable programaProduccionAgregarDataTable = new HtmlDataTable();
    ProgramaProduccion programaProduccionSeleccionado = new ProgramaProduccion();
    List<ProgramaProduccion> programaProduccionEditarList = new ArrayList();
    HtmlDataTable programaProduccionEditarDataTable = new HtmlDataTable();
    List lugaresAcondList = new ArrayList();
    List componenteProdList = new ArrayList();
    ManagedDemandaProductos managedDemandaProductos = new ManagedDemandaProductos();
    List productosProduccionList = new ArrayList();
    private ProgramaProduccion programaProduccionCambioProducto=null;
    List materialesConflictoList = new ArrayList();
    int lotesMC = 0;
    int lotesMM = 0;
    int lotesMI = 0;
    int materialConflicto = 0;
    List explosionMaquinariasList = new ArrayList();
    private ProgramaProduccion programaProduccionCabeceraEditar=null;
    private List<SelectItem> almacenesSelectList;
    private List<Integer> almacenesList;
    
    //variables programa produccion periodo
    private List<ProgramaProduccionPeriodo> programaProduccionPeriodoList;
    private HtmlDataTable programaProduccionPeriodoDataTable=new HtmlDataTable();
    private ProgramaProduccionPeriodo programaProduccionPeriodoAgregar;
    private ProgramaProduccionPeriodo programaProduccionPeriodoEditar;
    private ProgramaProduccionPeriodo programaProduccionPeriodoClonar;
    private ProgramaProduccionPeriodo programaProduccionPeriodoClonarNuevo;
    
    // <editor-fold defaultstate="collapsed" desc="cargar areas fabriacion">
    private void cargarAreasFabricacionProducto()
    {
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select   ae.COD_AREA_EMPRESA,ae.NOMBRE_AREA_EMPRESA");
                                        consulta.append(" from AREAS_FABRICACION_PRODUCTO afp");
                                                consulta.append(" inner join AREAS_EMPRESA ae on ae.COD_AREA_EMPRESA=afp.COD_AREA_EMPRESA");
                                       consulta.append(" order by ae.NOMBRE_AREA_EMPRESA");
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            areasFabricacionProduccionList=new ArrayList<SelectItem>();
            while (res.next()) 
            {
                areasFabricacionProduccionList.add(new SelectItem(res.getString("COD_AREA_EMPRESA"),res.getString("NOMBRE_AREA_EMPRESA")));
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
    //</editor-fold>
    
    
    //<editor-fold desc="programa Produccion periodo solicitud mantenimiento" defaultstate="collapsed">
    public String editarProgramaProduccionPeriodo_action()
    {
        for(ProgramaProduccionPeriodo bean:programaProduccionPeriodoList)
        {
            if(bean.getChecked())
            {
                programaProduccionPeriodoEditar=bean;
                break;
            }
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
                mensaje = "";
                try {
                    con = Util.openConnection(con);
                    con.setAutoCommit(false);
                    StringBuilder consulta = new StringBuilder("select count(*) as cantidadProd");
                                                consulta.append(" from PROGRAMA_PRODUCCION p");
                                                consulta.append(" where p.COD_PROGRAMA_PROD=").append(bean.getCodProgramaProduccion());
                    LOGGER.debug("consutla verificar programa detalle "+consulta.toString());
                    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet res=st.executeQuery(consulta.toString());
                    res.next();
                    if(res.getInt(1)>0)mensaje="No se puede eliminar porque tiene detalle registrado";
                    consulta = new StringBuilder("select count(*) as cantidadProd");
                                consulta.append(" from PROGRAMA_PRODUCCION_DETALLE p");
                                consulta.append(" where p.COD_PROGRAMA_PROD=").append(bean.getCodProgramaProduccion());
                    LOGGER.debug("consutla verificar programa detalle "+consulta.toString());
                    res=st.executeQuery(consulta.toString());
                    res.next();
                    if(res.getInt(1)>0)mensaje="No se puede eliminar porque tiene detalle registrado";
                    if(mensaje.length()==0)
                    {
                        consulta=new StringBuilder("delete PROGRAMA_PRODUCCION_PERIODO");
                                        consulta.append(" where COD_PROGRAMA_PROD=").append(bean.getCodProgramaProduccion());
                        LOGGER.debug("consulta eliminar programa periodo simulacion" + consulta.toString());
                        PreparedStatement pst = con.prepareStatement(consulta.toString());
                        if (pst.executeUpdate() > 0) LOGGER.info("se elimino el programa periodo");
                        mensaje = "1";
                    }
                    con.commit();
                    
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
            this.cargarProgramaProduccionPeriodoList();
        }
        return null;
    }
    public String guardarEditarProgramaProduccionPeriodo_action()throws SQLException
    {
        mensaje = "";
        try {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta = new StringBuilder("update PROGRAMA_PRODUCCION_PERIODO");
                                    consulta.append(" set NOMBRE_PROGRAMA_PROD=?,");
                                            consulta.append(" OBSERVACIONES=?");
                                    consulta.append(" where COD_PROGRAMA_PROD=").append(programaProduccionPeriodoEditar.getCodProgramaProduccion());
            LOGGER.debug("consulta editar progrma produccion simulacion " + consulta.toString());
            PreparedStatement pst = con.prepareStatement(consulta.toString());
            pst.setString(1,programaProduccionPeriodoEditar.getNombreProgramaProduccion());LOGGER.info("p1: "+programaProduccionPeriodoEditar.getNombreProgramaProduccion());
            pst.setString(2,programaProduccionPeriodoEditar.getObsProgramaProduccion());LOGGER.info("p2: "+programaProduccionPeriodoEditar.getObsProgramaProduccion());
            if (pst.executeUpdate() > 0) LOGGER.info("se guardo la edicion del programa periodo simulacion");
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
    public String getCargarAgregarProgramaProduccionPeriodo()
    {
        programaProduccionPeriodoAgregar=new ProgramaProduccionPeriodo();
        return null;
    }
    public String guardarAgregarProgramaProduccionPeriodo_action()throws SQLException
    {
        mensaje = "";
        try {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta = new StringBuilder("select isnull(max(COD_PROGRAMA_PROD) + 1, 1)");
                                        consulta.append(" from PROGRAMA_PRODUCCION_PERIODO");
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta.toString());
            if(res.next())programaProduccionPeriodoAgregar.setCodProgramaProduccion(res.getString(1));
            consulta=new StringBuilder("insert into PROGRAMA_PRODUCCION_PERIODO (COD_PROGRAMA_PROD,NOMBRE_PROGRAMA_PROD,OBSERVACIONES,COD_ESTADO_PROGRAMA)");
                        consulta.append(" values(");
                                consulta.append(programaProduccionPeriodoAgregar.getCodProgramaProduccion()).append(",");
                                consulta.append("?,");//nombre programa produccion
                                consulta.append("?,");//observacion programa produccion
                                consulta.append("4");//estado simulacion
                        consulta.append(")");
            LOGGER.debug("consulta registrar programa periodo simulacion " + consulta.toString());
            PreparedStatement pst = con.prepareStatement(consulta.toString());
            pst.setString(1,programaProduccionPeriodoAgregar.getNombreProgramaProduccion());
            pst.setString(2,programaProduccionPeriodoAgregar.getObsProgramaProduccion());
            if (pst.executeUpdate() > 0) LOGGER.info("se registro el programa periodo simulacion");
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
    public String guardarClonarProgramaProduccionPeriodo_action()throws SQLException
    {
        LOGGER.debug("entro");
        mensaje = "";
        try 
        {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta = new StringBuilder("select max(p.COD_PROGRAMA_PROD)+1  as codProgramaProd");
                                        consulta.append(" from PROGRAMA_PRODUCCION_PERIODO p");
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta.toString());
            int codProgramaProdRegistrado=0;
            if(res.next())codProgramaProdRegistrado=res.getInt("codProgramaProd");
            consulta=new StringBuilder("INSERT INTO PROGRAMA_PRODUCCION_PERIODO(COD_PROGRAMA_PROD, NOMBRE_PROGRAMA_PROD,OBSERVACIONES, COD_ESTADO_PROGRAMA, FECHA_INICIO, FECHA_FINAL,");
                            consulta.append(" COD_TIPO_PRODUCCION, COD_DEMANDA)");
                    consulta.append(" select (select ").append(codProgramaProdRegistrado).append(",?,");
                            consulta.append(" ?, ppp.COD_ESTADO_PROGRAMA,ppp.FECHA_INICIO,ppp.FECHA_FINAL,ppp.COD_TIPO_PRODUCCION,ppp.COD_ESTADO_PROGRAMA");
                    consulta.append(" from PROGRAMA_PRODUCCION_PERIODO ppp");
                    consulta.append(" where ppp.COD_PROGRAMA_PRO=").append(programaProduccionPeriodoClonar.getCodProgramaProduccion());
            LOGGER.debug("consulta registrar clon progarma prod " + consulta.toString());
            PreparedStatement pst = con.prepareStatement(consulta.toString());
            pst.setString(1,programaProduccionPeriodoClonarNuevo.getNombreProgramaProduccion());
            pst.setString(2,programaProduccionPeriodoClonarNuevo.getObsProgramaProduccion());
            if (pst.executeUpdate() > 0) LOGGER.info("se registro el programa periodo");
            consulta=new StringBuilder("INSERT INTO PROGRAMA_PRODUCCION(COD_PROGRAMA_PROD, COD_COMPPROD,COD_FORMULA_MAESTRA, FECHA_INICIO, FECHA_FINAL, COD_ESTADO_PROGRAMA,");
                                consulta.append(" COD_LOTE_PRODUCCION, VERSION_LOTE, CANT_LOTE_PRODUCCION, OBSERVACION,COD_TIPO_PROGRAMA_PROD, MATERIAL_TRANSITO, COD_PRESENTACION, COD_TIPO_APROBACION");
                                consulta.append(" , NRO_LOTES, COD_COMPPROD_PADRE, cod_lugar_acond, COD_COMPPROD_VERSION,COD_FORMULA_MAESTRA_VERSION, FECHA_REGISTRO, FECHA_EDICION,COD_FORMULA_MAESTRA_ES_VERSION)");
                        consulta.append(" select ").append(codProgramaProdRegistrado).append(", pp.COD_COMPPROD, pp.COD_FORMULA_MAESTRA, pp.FECHA_INICIO,pp.FECHA_FINAL, pp.COD_ESTADO_PROGRAMA, pp.COD_LOTE_PRODUCCION, pp.VERSION_LOTE,");
                                consulta.append(" pp.CANT_LOTE_PRODUCCION, pp.OBSERVACION, pp.COD_TIPO_PROGRAMA_PROD, pp.MATERIAL_TRANSITO, pp.COD_PRESENTACION, pp.COD_TIPO_APROBACION, pp.NRO_LOTES, pp.COD_COMPPROD_PADRE,");
                                consulta.append(" pp.cod_lugar_acond, pp.COD_COMPPROD_VERSION, pp.COD_FORMULA_MAESTRA_VERSION,pp.FECHA_REGISTRO, pp.FECHA_EDICION, pp.COD_FORMULA_MAESTRA_ES_VERSION");
                        consulta.append(" from PROGRAMA_PRODUCCION pp");
                        consulta.append(" where pp.COD_PROGRAMA_PROD=").append(programaProduccionPeriodoClonar.getCodProgramaProduccion());
            LOGGER.debug("consulta realizar copia de lotes "+consulta.toString());
            pst=con.prepareStatement(consulta.toString());
            if(pst.executeUpdate()>0)LOGGER.info("se registro la duplicación");
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
            this.cargarProgramaProduccionPeriodoList();
        }
        return null;
    }
    public String seleccionarProgramaProduccionPeriodoClonar_action()
    {
        programaProduccionPeriodoClonar=(ProgramaProduccionPeriodo)programaProduccionPeriodoDataTable.getRowData();
        programaProduccionPeriodoClonarNuevo=new ProgramaProduccionPeriodo();
        return null;
    }
    public String seleccionarProgramaProduccionPeriodo_action()
    {
        programaProduccionbean=new ProgramaProduccion();
        programaProduccionbean.setProgramaProduccionPeriodo((ProgramaProduccionPeriodo)programaProduccionPeriodoDataTable.getRowData());
        programaProduccionbean.setCodProgramaProduccion(programaProduccionbean.getProgramaProduccionPeriodo().getCodProgramaProduccion());
        return null;
    }
    public String getCargarProgramaProduccionPeriodoList()
    {
        this.cargarProgramaProduccionPeriodoList();
        return null;
    }
    private void cargarProgramaProduccionPeriodoList()
    {
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("SELECT PP.COD_PROGRAMA_PROD,PP.NOMBRE_PROGRAMA_PROD,PP.OBSERVACIONES,");
                                            consulta.append(" detalleSolicitud.cantidadSolicitudes,epp.NOMBRE_ESTADO_PROGRAMA_PROD");
                                    consulta.append(" FROM PROGRAMA_PRODUCCION_PERIODO PP");
                                            consulta.append(" left join ");
                                            consulta.append(" (");
                                            consulta.append(" select pppsc.COD_PROGRAMA_PROD,");
                                            consulta.append(" count(*) as cantidadSolicitudes");
                                            consulta.append(" from PROGRAMA_PRODUCCION_PERIODO_SOLICITUD_COMPRA pppsc");
                                            consulta.append(" group by pppsc.COD_PROGRAMA_PROD");
                                            consulta.append(" ) as detalleSolicitud on detalleSolicitud.COD_PROGRAMA_PROD =pp.COD_PROGRAMA_PROD");
                                            consulta.append(" inner join ESTADOS_PROGRAMA_PRODUCCION epp on epp.COD_ESTADO_PROGRAMA_PROD=pp.COD_ESTADO_PROGRAMA");
                                    consulta.append(" WHERE PP.COD_ESTADO_PROGRAMA = 4");
                                    consulta.append(" order by pp.COD_PROGRAMA_PROD desc");
            LOGGER.debug("consulta cargar programa produccion periodo" + consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            programaProduccionPeriodoList=new ArrayList<ProgramaProduccionPeriodo>();
            while (res.next()) 
            {
                ProgramaProduccionPeriodo nuevo= new ProgramaProduccionPeriodo();
                nuevo.setCodProgramaProduccion(res.getString("COD_PROGRAMA_PROD"));
                nuevo.setNombreProgramaProduccion(res.getString("NOMBRE_PROGRAMA_PROD"));
                nuevo.setObsProgramaProduccion(res.getString("OBSERVACIONES"));
                nuevo.setCantProgramaProduccionPeriodoSolicitudCompra(res.getInt("cantidadSolicitudes"));
                nuevo.getEstadoProgramaProduccion().setNombreEstadoProgramaProd(res.getString("NOMBRE_ESTADO_PROGRAMA_PROD"));
                programaProduccionPeriodoList.add(nuevo);
                
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
    
    
    //<editor-fold desc="generacion de solicitud de compra por explosion de maquinaria" defaultstate="collapsed">
    public String generarSolicitudCompraPorExplosionMaquinaria_action()throws SQLException
    {
        mensaje = "";
        try {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            ManagedAccesoSistema managed=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
            StringBuilder consulta = new StringBuilder("EXEC PAA_REGISTRO_SOLICITUD_COMPRA_MATERIAL_EXPLOSION ");
                                        consulta.append(programaProduccionbean.getCodProgramaProduccion()).append(",");
                                        consulta.append(managed.getUsuarioModuloBean().getCodUsuarioGlobal());
            LOGGER.debug("consulta registrar solicitud compra explosion "+consulta.toString());
            PreparedStatement pst = con.prepareStatement(consulta.toString());
            if (pst.executeUpdate() > 0)LOGGER.info("se la solicitud por explosion");
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
    //</editor-fold>
    private void cargarAlmacenesSelectList()
    {
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select a.COD_ALMACEN,a.NOMBRE_ALMACEN");
                                        consulta.append(" from ALMACENES a");
                                        consulta.append(" where a.cod_almacen in (1,2,9,18)");
                                        consulta.append(" order by a.NOMBRE_ALMACEN");
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            almacenesSelectList=new ArrayList<SelectItem>();
            while (res.next()) 
            {
                almacenesSelectList.add(new SelectItem(res.getInt("COD_ALMACEN"),res.getString("NOMBRE_ALMACEN")));
            }
            st.close();
        } 
        catch (SQLException ex) 
        {
            ex.printStackTrace();
        } 
        finally 
        {
            this.cerrarConexion(con);
        }
    }
    public String editarProgramaProduccionSimulacion_action()
    {
        for(ProgramaProduccion bean:programaProduccionList)
        {
            if(bean.getChecked())
            {
                programaProduccionCabeceraEditar=bean;
            }
        }
        return null;
    }
    public String modificarProductoDivisionLotes_action()
    {
        ExternalContext externalContext = FacesContext.getCurrentInstance().getExternalContext();
        Map<String,String> params = externalContext.getRequestParameterMap();
        System.out.println("c fm"+params.get("codFormula"));
        programaProduccionCambioProducto.getFormulaMaestra().getComponentesProd().setCodCompprod(params.get("codCompProd"));
        programaProduccionCambioProducto.getFormulaMaestra().getComponentesProd().setNombreProdSemiterminado(params.get("nombreCompProd"));
        programaProduccionCambioProducto.getFormulaMaestra().setCodFormulaMaestra(params.get("codFormula"));
        programaProduccionCambioProducto.getFormulaMaestra().setCantidadLote(Double.valueOf(params.get("cantidadLote")));
        programaProduccionCambioProducto.getTiposProgramaProduccion().setCodTipoProgramaProd(params.get("codTipoProgramaProd"));
        programaProduccionCambioProducto.getTiposProgramaProduccion().setNombreTipoProgramaProd(params.get("nombreTipoPrograma"));
        programaProduccionCambioProducto.setPresentacionesProductoList(this.cargarPresentacionesSecundariasSelectList(programaProduccionCambioProducto));
        return null;
    }
    public String modificarProductoProgramaProduccionEditar_action()
    {
        programaProduccionCambioProducto=(ProgramaProduccion)programaProduccionEditarDataTable.getRowData();
        try
        {
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            String consulta = "select cp.nombre_prod_semiterminado,cp.COD_COMPPROD,fm.COD_FORMULA_MAESTRA,fm.CANTIDAD_LOTE" +
                              ",tpp.COD_TIPO_PROGRAMA_PROD,tpp.NOMBRE_TIPO_PROGRAMA_PROD"+
                              " from FORMULA_MAESTRA fm inner join COMPONENTES_PROD cp on cp.COD_COMPPROD=fm.COD_COMPPROD"+
                              " inner join PRODUCTOS_DIVISION_LOTES pdl on pdl.COD_COMPPROD_DIVISION=cp.COD_COMPPROD"+
                              " inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=pdl.COD_TIPO_PROGRAMA_PRODUCCION"+
                              " where fm.COD_ESTADO_REGISTRO=1 and cp.COD_ESTADO_COMPPROD=1 and "+
                              " pdl.COD_COMPPROD='"+programaProduccionCabeceraEditar.getFormulaMaestra().getComponentesProd().getCodCompprod()+"'"+
                              " order by cp.nombre_prod_semiterminado,tpp.NOMBRE_TIPO_PROGRAMA_PROD";
            System.out.println("consulta cargar productos para division "+consulta);
            ResultSet res = st.executeQuery(consulta);
            productosDivisionLotesList=new ArrayList<ProductosDivisionLotes>();
            while (res.next())
            {
                ProductosDivisionLotes nuevo=new ProductosDivisionLotes();
                nuevo.getTiposProgramaProduccion().setCodTipoProgramaProd(res.getString("COD_TIPO_PROGRAMA_PROD"));
                nuevo.getTiposProgramaProduccion().setNombreTipoProgramaProd(res.getString("NOMBRE_TIPO_PROGRAMA_PROD"));
                nuevo.getComponentesProd().setCodCompprod(res.getString("COD_COMPPROD"));
                nuevo.getComponentesProd().setNombreProdSemiterminado(res.getString("nombre_prod_semiterminado"));
                FormulaMaestra formula=new FormulaMaestra();
                formula.setCodFormulaMaestra(res.getString("COD_FORMULA_MAESTRA"));
                formula.setCantidadLote(res.getDouble("CANTIDAD_LOTE"));
                nuevo.setFormulaMaestra(formula);
                productosDivisionLotesList.add(nuevo);
            }
            res.close();
            st.close();
            con.close();
        }
        catch (SQLException ex) {
            ex.printStackTrace();
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
            String consulta = "select cp.nombre_prod_semiterminado,cp.COD_COMPPROD,fm.COD_FORMULA_MAESTRA,fm.CANTIDAD_LOTE" +
                              ",tpp.COD_TIPO_PROGRAMA_PROD,tpp.NOMBRE_TIPO_PROGRAMA_PROD"+
                              " from FORMULA_MAESTRA fm inner join COMPONENTES_PROD cp on cp.COD_COMPPROD=fm.COD_COMPPROD"+
                              " inner join PRODUCTOS_DIVISION_LOTES pdl on pdl.COD_COMPPROD_DIVISION=cp.COD_COMPPROD"+
                              " inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=pdl.COD_TIPO_PROGRAMA_PRODUCCION"+
                              " where fm.COD_ESTADO_REGISTRO=1 and cp.COD_ESTADO_COMPPROD=1 and "+
                              " pdl.COD_COMPPROD='"+programaProduccionCabeceraAgregar.getFormulaMaestra().getComponentesProd().getCodCompprod()+"'"+
                              " order by cp.nombre_prod_semiterminado,tpp.NOMBRE_TIPO_PROGRAMA_PROD";
            System.out.println("consulta cargar productos para division "+consulta);
            ResultSet res = st.executeQuery(consulta);
            productosDivisionLotesList=new ArrayList<ProductosDivisionLotes>();
            while (res.next())
            {
                ProductosDivisionLotes nuevo=new ProductosDivisionLotes();
                nuevo.getTiposProgramaProduccion().setCodTipoProgramaProd(res.getString("COD_TIPO_PROGRAMA_PROD"));
                nuevo.getTiposProgramaProduccion().setNombreTipoProgramaProd(res.getString("NOMBRE_TIPO_PROGRAMA_PROD"));
                nuevo.getComponentesProd().setCodCompprod(res.getString("COD_COMPPROD"));
                nuevo.getComponentesProd().setNombreProdSemiterminado(res.getString("nombre_prod_semiterminado"));
                FormulaMaestra formula=new FormulaMaestra();
                formula.setCodFormulaMaestra(res.getString("COD_FORMULA_MAESTRA"));
                formula.setCantidadLote(res.getDouble("CANTIDAD_LOTE"));
                nuevo.setFormulaMaestra(formula);
                productosDivisionLotesList.add(nuevo);
            }
            res.close();
            st.close();
            con.close();
        }
        catch (SQLException ex) {
            ex.printStackTrace();
        }
        return null;
    }

    private void cargarFormulasMaestrasDisponibles()
    {
        try {
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            String consulta = "select cp.nombre_prod_semiterminado,fm.CANTIDAD_LOTE,cp.COD_COMPPROD,fm.COD_FORMULA_MAESTRA"+
                              " from COMPONENTES_PROD cp inner join FORMULA_MAESTRA fm on"+
                              " cp.COD_COMPPROD=fm.COD_COMPPROD"+
                              " where cp.COD_ESTADO_COMPPROD=1 and fm.COD_ESTADO_REGISTRO=1 and cp.COD_TIPO_PRODUCCION in (1,3)"+
                              " order by cp.nombre_prod_semiterminado";
            ResultSet res = st.executeQuery(consulta);
            formulaMaestraAgregarList=new ArrayList<FormulaMaestra>();
            while (res.next())
            {
                FormulaMaestra nuevo=new FormulaMaestra();
                nuevo.getComponentesProd().setCodCompprod(res.getString("COD_COMPPROD"));
                nuevo.getComponentesProd().setNombreProdSemiterminado(res.getString("nombre_prod_semiterminado"));
                nuevo.setCantidadLote(res.getDouble("CANTIDAD_LOTE"));
                nuevo.setCodFormulaMaestra(res.getString("COD_FORMULA_MAESTRA"));
                formulaMaestraAgregarList.add(nuevo);
            }
            res.close();
            st.close();
            con.close();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }
    public String cargarPresentacionesProductoSelect()
    {
        ProgramaProduccion bean=(ProgramaProduccion)programaProduccionAgregarDataTable.getRowData();
        bean.setPresentacionesProductoList(cargarPresentacionesSecundariasSelectList(bean));
        return null;
    }
    private List<SelectItem> cargarPresentacionesSecundariasSelectList(ProgramaProduccion bean)
    {
        List<SelectItem> presentacionesSecundarias=new ArrayList<SelectItem>();
        try
        {
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            String consulta = "select pp.cod_presentacion,pp.NOMBRE_PRODUCTO_PRESENTACION"+
                              " from COMPONENTES_PRESPROD cpp inner join PRESENTACIONES_PRODUCTO pp on "+
                              " cpp.COD_PRESENTACION=pp.cod_presentacion"+
                              " where cpp.COD_COMPPROD='"+bean.getFormulaMaestra().getComponentesProd().getCodCompprod()+"'" +
                                    " and cpp.COD_TIPO_PROGRAMA_PROD='"+bean.getTiposProgramaProduccion().getCodTipoProgramaProd()+"'"+
                                    " and cpp.COD_ESTADO_REGISTRO=1"+
                              " order by pp.NOMBRE_PRODUCTO_PRESENTACION";
            LOGGER.debug("consulta presentacion secundarias "+consulta);
            ResultSet res = st.executeQuery(consulta);
            presentacionesSecundarias.add(new SelectItem("0","--NINGUNO--"));
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
    public String seleccionarFormulaMaestraPrograma_action(){
        try {
            ExternalContext externalContext = FacesContext.getCurrentInstance().getExternalContext();
            Map<String,String> params = externalContext.getRequestParameterMap();
            System.out.println("c fm"+params.get("codFormula"));
            programaProduccionCabeceraAgregar=new ProgramaProduccion();
            programaProduccionCabeceraAgregar.getFormulaMaestra().setCodFormulaMaestra(params.get("codFormula"));
            programaProduccionCabeceraAgregar.getFormulaMaestra().setCantidadLote(Double.valueOf(params.get("cantidadLote")));
            programaProduccionCabeceraAgregar.setCantidadLote(Double.valueOf(params.get("cantidadLote")));
            programaProduccionCabeceraAgregar.getFormulaMaestra().getComponentesProd().setCodCompprod(params.get("codCompProd"));
            programaProduccionCabeceraAgregar.getFormulaMaestra().getComponentesProd().setNombreProdSemiterminado(params.get("nombreCompProd"));
            programaProduccionCabeceraAgregar.getTiposProgramaProduccion().setCodTipoProgramaProd("1");
            programaProduccionAgregarList.clear();
            ProgramaProduccion nuevo=(ProgramaProduccion)programaProduccionCabeceraAgregar.clone();
            nuevo.setPresentacionesProductoList(this.cargarPresentacionesSecundariasSelectList(nuevo));
            nuevo.getLugaresAcond().setCodLugarAcond(2);
            programaProduccionAgregarList.add(nuevo);

        } catch (Exception ex) {
            LOGGER.warn("error", ex);
        }
        return null;
    }
    public ManagedProgramaProduccionSimulacion() {
        LOGGER=LogManager.getRootLogger();
        //cargarProgramaProduccion();
    }

    public class ProductosProduccion extends AbstractBean{
        String colorMP = "";
        String colorEP= "";
        String colorES = "";
        String colorHorasMaquina = "";
        String colorHorasHombre = "";
        ProgramaProduccion programaProduccion = new ProgramaProduccion();
        double cantMC = 0.0;
        double cantMM = 0.0;
        double cantMI = 0.0;
        double totalProduccion = 0.0;
        double lotesProgramados = 0.0;
        double lotesFabricarMPEP = 0.0;
        double lotesFabricarES = 0.0;
        double unidadesFabricar = 0.0;
        double materiaMPEP = 0.0;
        double materiaES = 0.0;
        double lotesFabricarMC = 0;
        double lotesFabricarMM = 0;
        double lotesFabricarMI = 0;
        double lotesFabricarMP_MC = 0;
        double lotesFabricarMP_MM = 0;
        double lotesFabricarMP_MI = 0;
        double lotesFabricarMPEP_MC = 0;
        double lotesFabricarMPEP_MM = 0;
        double lotesFabricarMPEP_MI = 0;
        double lotesFabricarMPEPS_MC = 0;
        double lotesFabricarMPEPS_MM = 0;
        double lotesFabricarMPEPS_MI = 0;

        
        


        public double getCantMC() {
            return cantMC;
        }

        public void setCantMC(double cantMC) {
            this.cantMC = cantMC;
        }

        public double getCantMI() {
            return cantMI;
        }

        public void setCantMI(double cantMI) {
            this.cantMI = cantMI;
        }

        public double getCantMM() {
            return cantMM;
        }

        public void setCantMM(double cantMM) {
            this.cantMM = cantMM;
        }

        public double getLotesFabricarES() {
            return lotesFabricarES;
        }

        public void setLotesFabricarES(double lotesFabricarES) {
            this.lotesFabricarES = lotesFabricarES;
        }

        public double getLotesFabricarMPEP() {
            return lotesFabricarMPEP;
        }

        public void setLotesFabricarMPEP(double lotesFabricarMPEP) {
            this.lotesFabricarMPEP = lotesFabricarMPEP;
        }

        

        public double getLotesProgramados() {
            return lotesProgramados;
        }

        public void setLotesProgramados(double lotesProgramados) {
            this.lotesProgramados = lotesProgramados;
        }

        public double getMateriaES() {
            return materiaES;
        }

        public void setMateriaES(double materiaES) {
            this.materiaES = materiaES;
        }

        public double getMateriaMPEP() {
            return materiaMPEP;
        }

        public void setMateriaMPEP(double materiaMPEP) {
            this.materiaMPEP = materiaMPEP;
        }

        public ProgramaProduccion getProgramaProduccion() {
            return programaProduccion;
        }

        public void setProgramaProduccion(ProgramaProduccion programaProduccion) {
            this.programaProduccion = programaProduccion;
        }

        public double getTotalProduccion() {
            return totalProduccion;
        }

        public void setTotalProduccion(double totalProduccion) {
            this.totalProduccion = totalProduccion;
        }

        public double getUnidadesFabricar() {
            return unidadesFabricar;
        }

        public void setUnidadesFabricar(double unidadesFabricar) {
            this.unidadesFabricar = unidadesFabricar;
        }

        public String getColorEP() {
            return colorEP;
        }

        public void setColorEP(String colorEP) {
            this.colorEP = colorEP;
        }

        public String getColorES() {
            return colorES;
        }

        public void setColorES(String colorES) {
            this.colorES = colorES;
        }

        public String getColorMP() {
            return colorMP;
        }

        public void setColorMP(String colorMP) {
            this.colorMP = colorMP;
        }

        public double getLotesFabricarMC() {
            return lotesFabricarMC;
        }

        public void setLotesFabricarMC(double lotesFabricarMC) {
            this.lotesFabricarMC = lotesFabricarMC;
        }

        public double getLotesFabricarMI() {
            return lotesFabricarMI;
        }

        public void setLotesFabricarMI(double lotesFabricarMI) {
            this.lotesFabricarMI = lotesFabricarMI;
        }

        public double getLotesFabricarMM() {
            return lotesFabricarMM;
        }

        public void setLotesFabricarMM(double lotesFabricarMM) {
            this.lotesFabricarMM = lotesFabricarMM;
        }

        public double getLotesFabricarMPEPS_MC() {
            return lotesFabricarMPEPS_MC;
        }

        public void setLotesFabricarMPEPS_MC(double lotesFabricarMPEPS_MC) {
            this.lotesFabricarMPEPS_MC = lotesFabricarMPEPS_MC;
        }

        public double getLotesFabricarMPEPS_MI() {
            return lotesFabricarMPEPS_MI;
        }

        public void setLotesFabricarMPEPS_MI(double lotesFabricarMPEPS_MI) {
            this.lotesFabricarMPEPS_MI = lotesFabricarMPEPS_MI;
        }

        public double getLotesFabricarMPEPS_MM() {
            return lotesFabricarMPEPS_MM;
        }

        public void setLotesFabricarMPEPS_MM(double lotesFabricarMPEPS_MM) {
            this.lotesFabricarMPEPS_MM = lotesFabricarMPEPS_MM;
        }

        public double getLotesFabricarMPEP_MC() {
            return lotesFabricarMPEP_MC;
        }

        public void setLotesFabricarMPEP_MC(double lotesFabricarMPEP_MC) {
            this.lotesFabricarMPEP_MC = lotesFabricarMPEP_MC;
        }

        public double getLotesFabricarMPEP_MI() {
            return lotesFabricarMPEP_MI;
        }

        public void setLotesFabricarMPEP_MI(double lotesFabricarMPEP_MI) {
            this.lotesFabricarMPEP_MI = lotesFabricarMPEP_MI;
        }

        public double getLotesFabricarMPEP_MM() {
            return lotesFabricarMPEP_MM;
        }

        public void setLotesFabricarMPEP_MM(double lotesFabricarMPEP_MM) {
            this.lotesFabricarMPEP_MM = lotesFabricarMPEP_MM;
        }

        public double getLotesFabricarMP_MC() {
            return lotesFabricarMP_MC;
        }

        public void setLotesFabricarMP_MC(double lotesFabricarMP_MC) {
            this.lotesFabricarMP_MC = lotesFabricarMP_MC;
        }

        public double getLotesFabricarMP_MI() {
            return lotesFabricarMP_MI;
        }

        public void setLotesFabricarMP_MI(double lotesFabricarMP_MI) {
            this.lotesFabricarMP_MI = lotesFabricarMP_MI;
        }

        public double getLotesFabricarMP_MM() {
            return lotesFabricarMP_MM;
        }

        public void setLotesFabricarMP_MM(double lotesFabricarMP_MM) {
            this.lotesFabricarMP_MM = lotesFabricarMP_MM;
        }

        public String getColorHorasHombre() {
            return colorHorasHombre;
        }

        public void setColorHorasHombre(String colorHorasHombre) {
            this.colorHorasHombre = colorHorasHombre;
        }

        public String getColorHorasMaquina() {
            return colorHorasMaquina;
        }

        public void setColorHorasMaquina(String colorHorasMaquina) {
            this.colorHorasMaquina = colorHorasMaquina;
        }
        
        
    }

    public class ProductosConflicto extends AbstractBean{
        ProgramaProduccion programaProduccion = new ProgramaProduccion();
        double cantidad = 0;
        int tamanioLista = 0;

        public double getCantidad() {
            return cantidad;
        }

        public void setCantidad(double cantidad) {
            this.cantidad = cantidad;
        }

        public ProgramaProduccion getProgramaProduccion() {
            return programaProduccion;
        }

        public void setProgramaProduccion(ProgramaProduccion programaProduccion) {
            this.programaProduccion = programaProduccion;
        }

        public int getTamanioLista() {
            return tamanioLista;
        }

        public void setTamanioLista(int tamanioLista) {
            this.tamanioLista = tamanioLista;
        }
    }
    class ExplosionMaquinarias{
        Maquinaria maquinarias = new Maquinaria();
        double horasDisponibles = 0;

        public double getHorasDisponibles() {
            return horasDisponibles;
        }

        public void setHorasDisponibles(double horasDisponibles) {
            this.horasDisponibles = horasDisponibles;
        }

        public Maquinaria getMaquinarias() {
            return maquinarias;
        }

        public void setMaquinarias(Maquinaria maquinarias) {
            this.maquinarias = maquinarias;
        }


    }

    
    public String getObtenerCodigo() {
        
        //String cod=Util.getParameter("codigo");
        String cod = Util.getParameter("codigo");
        String codFormula = Util.getParameter("codFormula");
        String nombre = Util.getParameter("nombre");
        String cantidad = Util.getParameter("cantidad");
        programaProduccionbean.setCodCompProd(Util.getParameter("codCompProd"));
        programaProduccionbean.setCodLoteProduccion(Util.getParameter("cod_lote_prod"));
        programaProduccionbean.getTiposProgramaProduccion().setCodTipoProgramaProd(Util.getParameter("codTipoProgramaProd"));
        System.out.println("cxxxxxxxxxxxxxxxxxxxxxxxod:" + cod);
        if (cod != null) {
            setCodigo(cod);
        }
        if (nombre != null) {
            nombreFromulaMaestra = nombre;
        }
        if (codFormula != null) {
            setCodFormulaMaestra(codFormula);
        }
        if (cantidad != null) {
            cantidadLote = cantidad;
        }
        if (cantidad != null) {
            cantidadLote = cantidad;
        }
        detalleProgramProd();
        
        return "";
        
    }
    
    public void cargarFormulaMaestra(String codigo, ProgramaProduccion bean) {
        try {
            setCon(Util.openConnection(getCon()));
            String sql = "select fm.COD_FORMULA_MAESTRA,c.nombre_prod_semiterminado,fm.CANTIDAD_LOTE ";
            sql += " from FORMULA_MAESTRA fm,COMPONENTES_PROD c";
            sql += " where fm.COD_COMPPROD=c.COD_COMPPROD " +
                   (!bean.getFormulaMaestra().getCodFormulaMaestra().equals("")?" and fm.cod_formula_maestra = '"+ bean.getFormulaMaestra().getCodFormulaMaestra()+"' ":"");
            sql += " order by c.nombre_prod_semiterminado ";
            System.out.println("sql " + sql);
            
            ResultSet rs = null;
            Statement st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            if (!codigo.equals("")) {
            } else {
                formulaMaestraList.clear();
                rs = st.executeQuery(sql);
                formulaMaestraList.add(new SelectItem("0", "Seleccione una Opción"));
                while (rs.next()) {
                    formulaMaestraList.add(new SelectItem(rs.getString(1), rs.getString(2) + " " + rs.getString(3)));
                }
            }
            if (rs != null) {
                rs.close();
                st.close();
                rs = null;
                st = null;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    public void cargarAreasEmpresa(String codigo, ProgramaProduccion bean) {
        try {
            setCon(Util.openConnection(getCon()));
            String sql = "select a.cod_area_empresa, a.nombre_area_empresa from areas_empresa a where a.cod_area_empresa " +
                    " in (select cod_area_fabricacion from areas_fabricacion) order by a.nombre_area_empresa";
            System.out.println(" sql:" + sql);
            ResultSet rs = null;
            Statement st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            if (!codigo.equals("")) {
            } else {
                areasEmpresaList.clear();
                rs = st.executeQuery(sql);
                areasEmpresaList.add(new SelectItem("0", "Seleccione una Opción"));
                while (rs.next()) {
                    areasEmpresaList.add(new SelectItem(rs.getString(1), rs.getString(2)));
                }
            }
            if (rs != null) {
                rs.close();
                st.close();
                rs = null;
                st = null;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    public void cargarTiposProgramaProd(String codigo, ProgramaProduccion bean) {
        
        try {
            setCon(Util.openConnection(getCon()));
            String sql = "select a.COD_TIPO_PROGRAMA_PROD, a.NOMBRE_TIPO_PROGRAMA_PROD from TIPOS_PROGRAMA_PRODUCCION a where a.cod_estado_registro=1" +
                    "  order by a.COD_TIPO_PROGRAMA_PROD";
            System.out.println(" sql:" + sql);
            ResultSet rs = null;
            Statement st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            if (!codigo.equals("")) {
            } else {
                tiposProgramaProdList.clear();
                rs = st.executeQuery(sql);
                tiposProgramaProdList.add(new SelectItem("0", "Seleccione una Opción"));
                while (rs.next()) {
                    tiposProgramaProdList.add(new SelectItem(rs.getString(1), rs.getString(2)));
                }
            }
            if (rs != null) {
                rs.close();
                st.close();
                rs = null;
                st = null;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    public String getCodigoPrograma() {
        String codigo = "1";
        try {
            setCon(Util.openConnection(getCon()));
            String sql = "select max(cod_programa_prod)+1 from programa_produccion";
            PreparedStatement st = getCon().prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                codigo = rs.getString(1);
            }
            if (codigo == null) {
                codigo = "1";
            }
            programaProduccionbean.setCodProgramaProduccion(codigo);
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "";
    }
    
    public void cargarProgramaProduccion() {
        try {
            String sql = "select pp.cod_programa_prod,fm.cod_formula_maestra,pp.cod_lote_produccion,";
            sql += " pp.fecha_inicio,pp.fecha_final,pp.cod_estado_programa,pp.observacion,";
            sql += " cp.nombre_prod_semiterminado,cp.cod_compprod,fm.cantidad_lote,epp.NOMBRE_ESTADO_PROGRAMA_PROD";
            sql += " from programa_produccion pp,formula_maestra fm,componentes_prod cp,ESTADOS_PROGRAMA_PRODUCCION epp";
            sql += " where pp.cod_formula_maestra=fm.cod_formula_maestra and cp.cod_compprod=fm.cod_compprod and epp.COD_ESTADO_PROGRAMA_PROD=pp.cod_estado_programa";
            //sql += " and ";
            sql += " order by cp.nombre_prod_semiterminado";
            setCon(Util.openConnection(getCon()));
            Statement st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(sql);
            rs.last();
            int rows = rs.getRow();
            programaProduccionList.clear();
            rs.first();
            String cod = "";
            for (int i = 0; i < rows; i++) {
                ProgramaProduccion bean = new ProgramaProduccion();
                bean.setCodProgramaProduccion(rs.getString(1));
                bean.getFormulaMaestra().setCodFormulaMaestra(rs.getString(2));
                bean.setCodLoteProduccion(rs.getString(3));
                /*String fechaInicio = rs.getString(4);
                String fechaInicioVector[] = fechaInicio.split(" ");
                fechaInicioVector = fechaInicioVector[0].split("-");
                fechaInicio = fechaInicioVector[2] + "/" + fechaInicioVector[1] + "/" + fechaInicioVector[0];
                bean.setFechaInicio(fechaInicio);
                String fechaFinal = rs.getString(5);
                String fechaFinalVector[] = fechaFinal.split(" ");
                fechaFinalVector = fechaFinalVector[0].split("-");
                fechaFinal = fechaFinalVector[2] + "/" + fechaFinalVector[1] + "/" + fechaFinalVector[0];
                bean.setFechaFinal(fechaFinal);*/
                bean.setCodEstadoPrograma(rs.getString(6));
                bean.setObservacion(rs.getString(7));
                bean.getFormulaMaestra().getComponentesProd().setNombreProdSemiterminado(rs.getString(8));
                bean.getFormulaMaestra().getComponentesProd().setCodCompprod(rs.getString(9));
                
                double cantidad = rs.getDouble(10);
                cantidad = redondear(cantidad, 3);
                
                NumberFormat nf = NumberFormat.getNumberInstance(Locale.GERMAN);
                DecimalFormat form = (DecimalFormat) nf;
                form.applyPattern("#,#00.0#");
                bean.getFormulaMaestra().setCantidadLote(cantidad);
                bean.getEstadoProgramaProduccion().setNombreEstadoProgramaProd(rs.getString(11));
                programaProduccionList.add(bean);
                rs.next();
            }
            if (rs != null) {
                rs.close();
                st.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public String getCargarProgramaProduccion2(){
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

            consulta = " select ppr.COD_PROGRAMA_PROD, ppr.COD_COMPPROD, cast (ppr.COD_LOTE_PRODUCCION as int) COD_LOTE_PRODUCCION," +
                    "  cp.nombre_prod_semiterminado, eppr.NOMBRE_ESTADO_PROGRAMA_PROD,  ppr.cod_formula_maestra," +
                    " count(ppr.COD_PROGRAMA_PROD) NRO_PRODUCTOS, sum(ppr.CANT_LOTE_PRODUCCION) TOTAL_CANTIDAD, fm.CANTIDAD_LOTE," +
                    " ISNULL(( SELECT C.NOMBRE_CATEGORIACOMPPROD FROM CATEGORIAS_COMPPROD C WHERE C.COD_CATEGORIACOMPPROD = cp.COD_CATEGORIACOMPPROD ), '') NOMBRE_CATEGORIACOMPPROD " +
                    " from PROGRAMA_PRODUCCION ppr " +
                    " inner join COMPONENTES_PROD cp on cp.COD_COMPPROD = ppr.COD_COMPPROD " +
                    " inner join ESTADOS_PROGRAMA_PRODUCCION eppr on eppr.COD_ESTADO_PROGRAMA_PROD = ppr.COD_ESTADO_PROGRAMA      " +
                    " inner join FORMULA_MAESTRA fm on fm.COD_COMPPROD = cp.COD_COMPPROD " +
                    " where ppr.COD_PROGRAMA_PROD = '"+codProgramaProd+"' group by ppr.COD_PROGRAMA_PROD, ppr.COD_COMPPROD, " +
                    " cast (ppr.COD_LOTE_PRODUCCION as int),cp.nombre_prod_semiterminado, eppr.NOMBRE_ESTADO_PROGRAMA_PROD,ppr.cod_formula_maestra," +
                    " fm.CANTIDAD_LOTE, cp.COD_CATEGORIACOMPPROD " +
                    " order by cast (ppr.COD_LOTE_PRODUCCION as int),  cp.nombre_prod_semiterminado asc ";
            
            System.out.println("consulta " + consulta);
            setCon(Util.openConnection(getCon()));
            Statement st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(consulta);
            programaProduccionLotesList.clear();
            while(rs.next()){
                ProgramaProduccion programaProduccionItem = new ProgramaProduccion();
                programaProduccionItem.setCodProgramaProduccion(rs.getString("COD_PROGRAMA_PROD"));
                programaProduccionItem.getFormulaMaestra().getComponentesProd().setCodCompprod(rs.getString("COD_COMPPROD"));
                programaProduccionItem.setCodLoteProduccion(rs.getString("COD_LOTE_PRODUCCION"));
                programaProduccionItem.getFormulaMaestra().getComponentesProd().setNombreProdSemiterminado(rs.getString("nombre_prod_semiterminado"));
                programaProduccionItem.getEstadoProgramaProduccion().setNombreEstadoProgramaProd(rs.getString("NOMBRE_ESTADO_PROGRAMA_PROD"));
                programaProduccionItem.getFormulaMaestra().getComponentesProd().getCategoriasCompProd().setNombreCategoriaCompProd(rs.getString("NOMBRE_CATEGORIACOMPPROD"));
                programaProduccionItem.getFormulaMaestra().setCodFormulaMaestra(rs.getString("cod_formula_maestra"));
                programaProduccionItem.setNroCompProd(rs.getInt("NRO_PRODUCTOS"));
                programaProduccionItem.setTotalCantidadLote(rs.getDouble("TOTAL_CANTIDAD"));
                programaProduccionItem.getFormulaMaestra().setCantidadLote(rs.getDouble("CANTIDAD_LOTE"));
                programaProduccionLotesList.add(programaProduccionItem);
            }
            rs.close();
            st.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public String editarProgramaProduccion_action(){
        try {
            mensaje = "";
            
            Iterator i = programaProduccionLotesList.iterator();
            while(i.hasNext()){
                programaProduccionbean = (ProgramaProduccion) i.next();
                if(programaProduccionbean.getChecked().booleanValue()==true){
                    break;
                }
            }
//            if(programaProduccionbean.getNroCompProd()==1 && programaProduccionbean.getTotalCantidadLote() == Double.parseDouble(programaProduccionbean.getFormulaMaestra().getCantidadLote())){
//                mensaje = " el producto no se puede editar ";
//            }
            //this.redireccionar("navegador_programa_produccion.jsf");
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public String getCargarProgramaProduccion1()
    {
        codAreasFabricacionProduccionList=new ArrayList<String>();
        this.cargarAreasFabricacionProducto();
        this.cargarAlmacenesSelectList();
        codProgramaProd=programaProduccionbean.getCodProgramaProduccion();
        programaProduccionbean.getTiposProgramaProduccion().setCodTipoProgramaProd("0");
        cargarTiposProgramaProd("", null);
        this.cargarProgramaProduccionLotesSimulacion();
        return null;
    }
    public String buscarProgramaProduccion_action()
    {
        this.cargarProgramaProduccionLotesSimulacion();
        return null;
    }
    private void cargarProgramaProduccionLotesSimulacion() 
    {
            try {
             StringBuilder consulta =new StringBuilder("select pp.cod_programa_prod,fm.cod_formula_maestra,pp.cod_lote_produccion,");
                                                consulta.append(" pp.fecha_inicio,pp.fecha_final,pp.cod_estado_programa,pp.observacion,");
                                                consulta.append(" cp.nombre_prod_semiterminado,cp.cod_compprod,fm.cantidad_lote,epp.NOMBRE_ESTADO_PROGRAMA_PROD,pp.cant_lote_produccion,tp.COD_TIPO_PROGRAMA_PROD,tp.NOMBRE_TIPO_PROGRAMA_PROD");
                                                consulta.append(" ,ISNULL((SELECT C.NOMBRE_CATEGORIACOMPPROD FROM CATEGORIAS_COMPPROD C WHERE C.COD_CATEGORIACOMPPROD=cp.COD_CATEGORIACOMPPROD),'')");
                                                consulta.append(" ,pp.cod_presentacion,nro_lotes,epp.COD_ESTADO_PROGRAMA_PROD ,l.nombre_lugar_acond,ppp.NOMBRE_PRODUCTO_PRESENTACION");
                                                consulta.append(" ,ae.NOMBRE_AREA_EMPRESA,ff.nombre_forma");
                                        consulta.append(" from programa_produccion pp,formula_maestra fm,componentes_prod cp,ESTADOS_PROGRAMA_PRODUCCION epp,TIPOS_PROGRAMA_PRODUCCION tp,lugares_acond l,PRESENTACIONES_PRODUCTO ppp");
                                                consulta.append(" ,AREAS_EMPRESA ae ,FORMAS_FARMACEUTICAS ff");
                                        consulta.append(" where pp.cod_formula_maestra=fm.cod_formula_maestra and cp.cod_compprod=fm.cod_compprod and epp.COD_ESTADO_PROGRAMA_PROD=pp.cod_estado_programa");
                                                consulta.append(" and ae.COD_AREA_EMPRESA=cp.COD_AREA_EMPRESA and ff.cod_forma=cp.COD_FORMA");
                                                consulta.append(" and pp.COD_PRESENTACION=ppp.cod_presentacion");
                                                consulta.append(" and tp.COD_TIPO_PROGRAMA_PROD = pp.COD_TIPO_PROGRAMA_PROD and l.cod_lugar_acond = pp.cod_lugar_acond and pp.cod_programa_prod=").append(programaProduccionbean.getCodProgramaProduccion());
                                                if(codAreasFabricacionProduccionList.size()>0)
                                                {
                                                    consulta.append(" and cp.COD_AREA_EMPRESA IN ( 0");
                                                        for(String codAreaEmpresa : codAreasFabricacionProduccionList)
                                                        {
                                                             consulta.append(",").append(codAreaEmpresa);
                                                        }
                                                    consulta.append(" )");
                                                }
                                        consulta.append(" order by cp.nombre_prod_semiterminado");

            
            System.out.println("sql navegador:" + consulta.toString());
            setCon(Util.openConnection(getCon()));
            Statement st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(consulta.toString());
            rs.last();
            int rows = rs.getRow();
            programaProduccionList.clear();
            rs.first();
            String cod = "";
            for (int i = 0; i < rows; i++) {
                ProgramaProduccion bean = new ProgramaProduccion();
                bean.setCodProgramaProduccion(rs.getString(1));
                bean.getFormulaMaestra().setCodFormulaMaestra(rs.getString(2));
                bean.setCodLoteProduccion(rs.getString(3));
                bean.getPresentacionesProducto().setNombreProductoPresentacion(rs.getString("NOMBRE_PRODUCTO_PRESENTACION"));
                bean.setCodEstadoPrograma(rs.getString(6));
                bean.setObservacion(rs.getString(7));
                bean.getFormulaMaestra().getComponentesProd().getAreasEmpresa().setNombreAreaEmpresa(rs.getString("NOMBRE_AREA_EMPRESA"));
                bean.getFormulaMaestra().getComponentesProd().getForma().setNombreForma(rs.getString("nombre_forma"));
                bean.getFormulaMaestra().getComponentesProd().setNombreProdSemiterminado(rs.getString(8));
                bean.getFormulaMaestra().getComponentesProd().setCodCompprod(rs.getString(9));
                
                double cantidad = rs.getDouble(10);
                cantidad = redondear(cantidad, 3);
                
                NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
                DecimalFormat form = (DecimalFormat) nf;
                form.applyPattern("#,#00.0#");
                bean.getFormulaMaestra().setCantidadLote(cantidad);
                
                bean.getEstadoProgramaProduccion().setNombreEstadoProgramaProd(rs.getString(11));
                cantidad = rs.getDouble(12);
                
                cantidad = redondear(cantidad, 3);
                bean.setCantidadLote(cantidad);
                
                bean.getTiposProgramaProduccion().setCodTipoProgramaProd(rs.getString(13));
                bean.getTiposProgramaProduccion().setNombreProgramaProd(rs.getString(14));
                bean.getCategoriasCompProd().setNombreCategoriaCompProd(rs.getString(15));
                bean.getPresentacionesProducto().setCodPresentacion(rs.getString("cod_presentacion"));
                bean.setCantidadLote(cantidad);
                bean.setNroLotes(rs.getInt("nro_lotes"));
                bean.getEstadoProgramaProduccion().setCodEstadoProgramaProd(rs.getString("COD_ESTADO_PROGRAMA_PROD"));

                bean.setEstadoProductoSimulacion(0);

                programaProduccionList.add(bean);
                
                double Tlote = bean.getFormulaMaestra().getCantidadLote() ;// Double.parseDouble( auxiliar) *  cantidad;
                bean.setTotalLote(Tlote);
                bean.getLugaresAcond().setNombreLugarAcond(rs.getString("nombre_lugar_acond"));
                rs.next();
            }
            if (rs != null) {
                rs.close();
                st.close();
            }
            cargarAreasEmpresa("", null);
            
            
        } 
        catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public String getCargarProgramaProduccion3() { //antiguo
        String codProgramaProdF = Util.getParameter("codProgramaProd");
        //programaProduccionbean.tiposProgramaProduccion.codTipoProgramaProd
        
          programaProduccionbean.getTiposProgramaProduccion().setCodTipoProgramaProd("0");
          //codProgramaProd = programaProduccionbean.getCodProgramaProduccion();
          cargarTiposProgramaProd("", null);
          //tiposProgramaProdList.clear();
        //System.out.println("codProgramaProdF:::::::::::::::::" + codProgramaProdF);
        System.out.println("getCodProgramaProd:::::::::::::::::" + getCodProgramaProd());
        try {
            System.out.println("::::" + programaProduccionbean.getFormulaMaestra().getComponentesProd().getAreasEmpresa().getCodAreaEmpresa());

            String sql = "select pp.cod_programa_prod,fm.cod_formula_maestra,pp.cod_lote_produccion,";
            sql += " pp.fecha_inicio,pp.fecha_final,pp.cod_estado_programa,pp.observacion,";
            sql += " cp.nombre_prod_semiterminado,cp.cod_compprod,fm.cantidad_lote,epp.NOMBRE_ESTADO_PROGRAMA_PROD,pp.cant_lote_produccion,tp.COD_TIPO_PROGRAMA_PROD,tp.NOMBRE_TIPO_PROGRAMA_PROD";
            sql +=" ,ISNULL((SELECT C.NOMBRE_CATEGORIACOMPPROD FROM CATEGORIAS_COMPPROD C WHERE C.COD_CATEGORIACOMPPROD=cp.COD_CATEGORIACOMPPROD),'')";
            sql +=" ,pp.cod_presentacion,nro_lotes,epp.COD_ESTADO_PROGRAMA_PROD ";
            sql += " from programa_produccion pp,formula_maestra fm,componentes_prod cp,ESTADOS_PROGRAMA_PRODUCCION epp,TIPOS_PROGRAMA_PRODUCCION tp";
            sql += " where pp.cod_formula_maestra=fm.cod_formula_maestra and cp.cod_compprod=fm.cod_compprod and epp.COD_ESTADO_PROGRAMA_PROD=pp.cod_estado_programa";
            sql += " and tp.COD_TIPO_PROGRAMA_PROD = pp.COD_TIPO_PROGRAMA_PROD  and pp.cod_programa_prod=" + codProgramaProd;

            if (!programaProduccionbean.getFormulaMaestra().getComponentesProd().getAreasEmpresa().getCodAreaEmpresa().equals("0") && !programaProduccionbean.getFormulaMaestra().getComponentesProd().getAreasEmpresa().getCodAreaEmpresa().equals("")) {
                sql += " and  cp.cod_area_empresa=" + programaProduccionbean.getFormulaMaestra().getComponentesProd().getAreasEmpresa().getCodAreaEmpresa();
            }
            if (!programaProduccionbean.getTiposProgramaProduccion().getCodTipoProgramaProd().equals("0") && !programaProduccionbean.getTiposProgramaProduccion().getCodTipoProgramaProd().equals("") && !programaProduccionbean.getTiposProgramaProduccion().getCodTipoProgramaProd().equals(null)) {
                sql += " and  pp.COD_TIPO_PROGRAMA_PROD =" + programaProduccionbean.getTiposProgramaProduccion().getCodTipoProgramaProd();
            }
            if(!programaProduccionbean.getCodLoteProduccion().equals("")){
                sql +=" and pp.cod_lote_produccion = '"+programaProduccionbean.getCodLoteProduccion()+"' ";
            }
            //" and pp.COD_TIPO_PROGRAMA_PROD = '"+programaProduccionbean.getTiposProgramaProduccion().getCodTipoProgramaProd()+"'  " +
            if(!programaProduccionbean.getFormulaMaestra().getComponentesProd().getCodCompprod().equals("") && programaProduccionbean.getFormulaMaestra().getComponentesProd().getCodCompprod().equals("0")){
            sql += " and pp.COD_COMPPROD = '"+programaProduccionbean.getFormulaMaestra().getComponentesProd().getCodCompprod() +"' ";
            }

            sql+=  " order by cp.nombre_prod_semiterminado";


            System.out.println("sql navegador:" + sql);
            setCon(Util.openConnection(getCon()));
            Statement st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(sql);
            rs.last();
            int rows = rs.getRow();
            programaProduccionList.clear();
            rs.first();
            String cod = "";
            for (int i = 0; i < rows; i++) {
                ProgramaProduccion bean = new ProgramaProduccion();
                bean.setCodProgramaProduccion(rs.getString(1));
                bean.getFormulaMaestra().setCodFormulaMaestra(rs.getString(2));
                bean.setCodLoteProduccion(rs.getString(3));
                System.out.println("getCodLoteProduccion:"+bean.getCodLoteProduccion());

                bean.setCodEstadoPrograma(rs.getString(6));
                bean.setObservacion(rs.getString(7));
                bean.getFormulaMaestra().getComponentesProd().setNombreProdSemiterminado(rs.getString(8));
                bean.getFormulaMaestra().getComponentesProd().setCodCompprod(rs.getString(9));

                double cantidad = rs.getDouble(10);
                cantidad = redondear(cantidad, 3);

                NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
                DecimalFormat form = (DecimalFormat) nf;
                form.applyPattern("#,#00.0#");
                bean.getFormulaMaestra().setCantidadLote(cantidad);

                bean.getEstadoProgramaProduccion().setNombreEstadoProgramaProd(rs.getString(11));
                cantidad = rs.getDouble(12);

                cantidad = redondear(cantidad, 3);
                bean.setCantidadLote(cantidad);

                bean.getTiposProgramaProduccion().setCodTipoProgramaProd(rs.getString(13));
                bean.getTiposProgramaProduccion().setNombreProgramaProd(rs.getString(14));
                bean.getCategoriasCompProd().setNombreCategoriaCompProd(rs.getString(15));
                bean.getPresentacionesProducto().setCodPresentacion(rs.getString("cod_presentacion"));
                bean.setCantidadLote(cantidad);
                bean.setNroLotes(rs.getInt("nro_lotes"));
                bean.getEstadoProgramaProduccion().setCodEstadoProgramaProd(rs.getString("COD_ESTADO_PROGRAMA_PROD"));

//                //INSERTAMOS EL ESTADO DEL PRODUCTO DENTRO DEL PROGRAMA DE PRODUCCION
//                String sqlEstadoProd = "select em.COD_MATERIAL, em.CANTIDAD_A_UTILIZAR, em.CANTIDAD_DISPONIBLE, em.CANTIDAD_TRANSITO " +
//                        " from EXPLOSION_MATERIALES em where " +
//                        " em.cod_programa_produccion =" + bean.getCodProgramaProduccion() + " and em.cod_material " +
//                        " in(select p.cod_material from PROGRAMA_PRODUCCION_DETALLE p where " +
//                        " p.COD_COMPPROD=" + bean.getFormulaMaestra().getComponentesProd().getCodCompprod() + " " +
//                        " and p.COD_PROGRAMA_PROD=" + bean.getCodProgramaProduccion() + ") and em.cantidad_disponible<em.cantidad_a_utilizar ";
//
//                System.out.println("sqlEstadoProd:" + sqlEstadoProd);
//                //Statement stEstadoProd = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
//                Statement stEstadoProd = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
//
//                ResultSet rsEstadoProd = stEstadoProd.executeQuery(sqlEstadoProd);
//                bean.setEstadoProductoSimulacion(0);
//                int bandera = 0;
//                // 0 OK; 1 CON FALTANTES; 2 NO SE PUEDE
//                while (rsEstadoProd.next() && (bandera == 0 || bandera == 1)) {
//                    //bean.setEstadoProductoSimulacion(1);
//                    int codMaterial = rsEstadoProd.getInt(1);
//                    double cantidadUtilizar = rsEstadoProd.getDouble(2);
//                    double cantidadDisponible = rsEstadoProd.getDouble(3);
//                    double cantidadTransito = rsEstadoProd.getDouble(4);
//                    if ((cantidadDisponible + cantidadTransito) >= cantidadUtilizar) {
//                        bandera = 1;
//                    } else {
//                        bandera = 2;
//                    }
//                }
//                if (bandera == 0) {
//                    bean.setEstadoProductoSimulacion(0);
//                }
//                if (bandera == 1) {
//                    bean.setEstadoProductoSimulacion(1);
//                }
//                if (bandera == 2) {
//                    bean.setEstadoProductoSimulacion(2);
//                }
                programaProduccionList.add(bean);

                //String auxiliar =  bean.getFormulaMaestra().getCantidadLote().replace(",","");
                double Tlote = bean.getFormulaMaestra().getCantidadLote() ;// Double.parseDouble( auxiliar) *  cantidad;
                System.out.println("Tlote...........:"+Tlote);
                bean.setTotalLote(Tlote);
                rs.next();
            }
            if (rs != null) {
                rs.close();
                st.close();
            }
            cargarAreasEmpresa("", null);

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "";
    }


    
    /**********ESTADO REGISTRO****************/
    public void changeEvent1(ValueChangeEvent event) {
        System.out.println("event:" + event.getNewValue());
        programaProduccionbean.getFormulaMaestra().getComponentesProd().getAreasEmpresa().setCodAreaEmpresa(event.getNewValue().toString());
        getCargarProgramaProduccion1();
    }
    
    public void changeEvent2(ValueChangeEvent event) {
        System.out.println("event:" + event.getNewValue());
        programaProduccionbean.getTiposProgramaProduccion().setCodTipoProgramaProd(event.getNewValue().toString());
        getCargarProgramaProduccion1();
    }
    
    public String getCloseConnection() throws SQLException {
        if (getCon() != null) {
            getCon().close();
        }
        return "";
    }
    
    public String actionagregar() {
        codProgramaProd = Util.getParameter("codProgramaProd")!=null?Util.getParameter("codProgramaProd"):codProgramaProd;

        programaProduccionLotesList.clear();
        
        getEmpaquePrimarioList().clear();
        getEmpaqueSecundarioList().clear();
        getEmpaquePrimarioList().add(new SelectItem("0", "Seleccione Una Opción"));
        getEmpaqueSecundarioList().add(new SelectItem("0", "Seleccione Una Opción"));
        cargarFormulaMaestra("", programaProduccionbean);
        cargarTiposProgramaProd("", null);
        clearProgramaProduccion();

        this.cargarProgramaProduccionLotes();
        
        
        return "actionAgregarProgramaProduccionSim";
    }
    public String agregarProgramaProduccion_action(){
//        Iterator i = programaProduccionList.iterator();
//        while(i.hasNext()){
//            programaProduccionbean = (ProgramaProduccion)i.next();
//            if(programaProduccionbean.getChecked().booleanValue()==true){
//                break;
//            }
//        }
        getEmpaquePrimarioList().clear();
        getEmpaqueSecundarioList().clear();
        getEmpaquePrimarioList().add(new SelectItem("0", "Seleccione Una Opción"));
        getEmpaqueSecundarioList().add(new SelectItem("0", "Seleccione Una Opción"));
        cargarFormulaMaestra("", programaProduccionbean);
        cargarTiposProgramaProd("", null);
        clearProgramaProduccion();
        this.formulaMaestra_change();

        this.redireccionar("agregar_programa_produccion.jsf");
        return null;
    }
    
    /**********ESTADO REGISTRO****************/
    //public void changeEvent(ValueChangeEvent event) {
      public String formulaMaestra_change(){
        //System.out.println("event:" + event.getNewValue());
        //codFormulaMaestra = event.getNewValue().toString();

            double cantidadTotalLote = 0;
            Iterator i = programaProduccionProductosList.iterator();
            while(i.hasNext()){
                ProgramaProduccion programaProduccionItem = (ProgramaProduccion)i.next();
                cantidadTotalLote = cantidadTotalLote + programaProduccionItem.getCantidadLote();
            }
         programaProduccionbean.getFormulaMaestra().setCantidadLote(this.cantidadLoteFormulaMaestra());
            programaProduccionbean.setCantidadLote(programaProduccionbean.getFormulaMaestra().getCantidadLote()-cantidadTotalLote);
            programaProduccionbean.setCantRefLote(programaProduccionbean.getFormulaMaestra().getCantidadLote()-cantidadTotalLote);
            programaProduccionbean.setNroLotes(1);

        codFormulaMaestra = programaProduccionbean.getFormulaMaestra().getCodFormulaMaestra();
        formulaMaestraMPList.clear();
        formulaMaestraEPList.clear();
        formulaMaestraESList.clear();
        formulaMaestraMPROMList.clear();
        formulaMaestraMRList.clear();

        NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
        DecimalFormat form = (DecimalFormat) nf;
        form.applyPattern("#,###.00");
        
        programaProduccionbean.getFormulaMaestra().setCodFormulaMaestra(codFormulaMaestra);
        //programaProduccionbean.setCantidadLote(this.canti)
        //programaProduccionbean.setCantidadLote(this.cantidadLoteFormulaMaestra());
        //programaProduccionbean.getFormulaMaestra().setCantidadLote(programaProduccionbean.getCantidadLote());
        programaProduccionbean.setNroLotes(1);

        
      
        try {
            String sql = " select m.cod_material,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA,mp.CANTIDAD,um.COD_UNIDAD_MEDIDA,m.cod_grupo from FORMULA_MAESTRA_DETALLE_MP mp,MATERIALES m,UNIDADES_MEDIDA um";
            sql += " where  m.COD_MATERIAL=mp.cod_material and um.COD_UNIDAD_MEDIDA=m.COD_UNIDAD_MEDIDA and mp.cod_formula_maestra=" + codFormulaMaestra;
            sql += " order by m.NOMBRE_MATERIAL";
            System.out.println("sql MP:" + sql);
            setCon(Util.openConnection(getCon()));
            Statement st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(sql);
            while (rs.next()) {
                String codMaterial = rs.getString(1);
                String nombreMaterial = rs.getString(2);
                String unidadMedida = rs.getString(3);
                
                double cantidad = rs.getDouble(4);
                cantidad = redondear(cantidad, 3);
                
                String codUnidadMedida = rs.getString(5);
                String codGrupo = rs.getString(6);
                FormulaMaestraDetalleMP bean = new FormulaMaestraDetalleMP();
                bean.setSwNo(false);
                bean.setSwSi(false);
                bean.getMateriales().setCodMaterial(codMaterial);
                bean.getMateriales().setNombreMaterial(nombreMaterial);
                bean.getUnidadesMedida().setNombreUnidadMedida(unidadMedida);
                bean.setCantidad(cantidad);
                bean.setCantidadRef(cantidad);
                bean.getUnidadesMedida().setCodUnidadMedida(codUnidadMedida);
                bean.setChecked(true);
                if (codGrupo.equals("5")) {
                    System.out.println("reactivo");
                    bean.setSwNo(false);
                    bean.setSwSi(true);
                } else {
                    System.out.println("no reactivo");
                    bean.setSwNo(true);
                    bean.setSwSi(false);
                }
                formulaMaestraMPList.add(bean);
            }
            sql=" select m.cod_material,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA,mp.CANTIDAD,um.COD_UNIDAD_MEDIDA from FORMULA_MAESTRA_DETALLE_MR mp,MATERIALES m,UNIDADES_MEDIDA um" ;
            sql+=" where  m.COD_MATERIAL=mp.cod_material and um.COD_UNIDAD_MEDIDA=m.COD_UNIDAD_MEDIDA and mp.cod_formula_maestra="+codFormulaMaestra;
            System.out.println("sql EP*:"+sql);
            st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            rs=st.executeQuery(sql);
            while(rs.next()){
                String codMaterial=rs.getString(1);
                String nombreMaterial=rs.getString(2);
                String unidadMedida=rs.getString(3);
                
                double cantidad=rs.getDouble(4);
                cantidad=redondear(cantidad,3);
                
                String codUnidadMedida=rs.getString(5);
                FormulaMaestraDetalleMP bean=new FormulaMaestraDetalleMP();
                bean.getMateriales().setCodMaterial(codMaterial);
                bean.getMateriales().setNombreMaterial(nombreMaterial);
                bean.getUnidadesMedida().setNombreUnidadMedida(unidadMedida);
                bean.setCantidad(cantidad);
                bean.setCantidadRef(cantidad);
                bean.getUnidadesMedida().setCodUnidadMedida(codUnidadMedida);
                bean.setChecked(true);
                System.out.println("bean.getMateriales().setNombreMaterial:"+bean.getMateriales().getNombreMaterial());
                formulaMaestraMRList.add(bean);
            }
            sql = " select m.cod_material,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA,mp.CANTIDAD,um.COD_UNIDAD_MEDIDA from FORMULA_MAESTRA_DETALLE_MPROM mp,MATERIALES m,UNIDADES_MEDIDA um";
            sql += " where  m.COD_MATERIAL=mp.cod_material and um.COD_UNIDAD_MEDIDA=m.COD_UNIDAD_MEDIDA and mp.cod_formula_maestra=" + codFormulaMaestra;
            sql += " order by m.NOMBRE_MATERIAL";
            System.out.println("sql MPROM:" + sql);
            st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            rs = st.executeQuery(sql);
            while (rs.next()) {
                String codMaterial = rs.getString(1);
                String nombreMaterial = rs.getString(2);
                String unidadMedida = rs.getString(3);
                
                double cantidad = rs.getDouble(4);
                cantidad = redondear(cantidad, 3);
                
                String codUnidadMedida = rs.getString(5);
                FormulaMaestraDetalleMP bean = new FormulaMaestraDetalleMP();
                bean.getMateriales().setCodMaterial(codMaterial);
                bean.getMateriales().setNombreMaterial(nombreMaterial);
                bean.getUnidadesMedida().setNombreUnidadMedida(unidadMedida);
                bean.setCantidad(cantidad);
                bean.getUnidadesMedida().setCodUnidadMedida(codUnidadMedida);
                bean.setChecked(true);
                formulaMaestraMPROMList.add(bean);
            }
            /******* Empaque Primario List*********/
            sql = " select p.cod_presentacion_primaria,e.nombre_envaseprim,p.CANTIDAD from PRESENTACIONES_PRIMARIAS p,ENVASES_PRIMARIOS e " +
                    " where p.COD_ENVASEPRIM=e.cod_envaseprim";
            sql += " and p.COD_COMPPROD in (select fe.COD_COMPPROD from FORMULA_MAESTRA fe " +
                    " where fe.COD_FORMULA_MAESTRA='" + codFormulaMaestra + "')";
            System.out.println("sql Empaque Primario:" + sql);
            st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            rs = st.executeQuery(sql);
            empaquePrimarioList.clear();
            empaquePrimarioList.add(new SelectItem("0", "Seleccione Una Opción"));
            while (rs.next()) {
                String nombreEnvasePrim = rs.getString(1);
                String cantidad = rs.getString(2);
                empaquePrimarioList.add(new SelectItem(rs.getString(1), rs.getString(2) + " x " + rs.getString(3)));
            }
            /******* Empaque Secundario List*********/
            sql = " select pp.cod_presentacion,pp.NOMBRE_PRODUCTO_PRESENTACION,es.NOMBRE_ENVASESEC,es.COD_ENVASESEC,";
            sql += " pp.cantidad_presentacion ";
            sql += " from PRESENTACIONES_PRODUCTO pp,ENVASES_SECUNDARIOS es,PRODUCTOS p";
            sql += " where es.COD_ENVASESEC=pp.COD_ENVASESEC and pp.cod_prod in (select cp.COD_PROD from COMPONENTES_PROD cp,FORMULA_MAESTRA fm ";
            sql += " where fm.COD_COMPPROD=cp.COD_COMPPROD and fm.COD_FORMULA_MAESTRA='" + codFormulaMaestra + "' ) and p.cod_prod=pp.cod_prod";
            sql += " order by es.NOMBRE_ENVASESEC ";
            
            sql = " select pp.cod_presentacion,pp.NOMBRE_PRODUCTO_PRESENTACION, " +
                " pp.cantidad_presentacion from formula_maestra fm  " +
                " inner join COMPONENTES_PROD cp on cp.COD_COMPPROD = fm.COD_COMPPROD " +
                " inner join COMPONENTES_PRESPROD c on c.COD_COMPPROD = cp.COD_COMPPROD " +
                " inner join PRESENTACIONES_PRODUCTO pp on pp.cod_presentacion = c.COD_PRESENTACION " +
                " inner join ENVASES_SECUNDARIOS es on es.COD_ENVASESEC = pp.COD_ENVASESEC where fm.COD_FORMULA_MAESTRA = '"+codFormulaMaestra+"' ";
                
            System.out.println("sql Empaque Primario:" + sql);
            st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            rs = st.executeQuery(sql);
            empaqueSecundarioList.clear();
            empaqueSecundarioList.add(new SelectItem("0", "Seleccione Una Opción"));
            while (rs.next()) {
                String nombreEnvasePrim = rs.getString(1);
                String cantidad = rs.getString(2);
                empaqueSecundarioList.add(new SelectItem(rs.getString(1), rs.getString(2)));
            }
            
            this.cantidadLoteProduccion_change();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

  
    public void changeEventPrim(ValueChangeEvent event) {
        System.out.println("eventPrim:" + event.getNewValue());
        if (event.getNewValue() != null) {
            codPresPrim = event.getNewValue().toString();
            try {
                double cantProduccion = 0;
                double cantidad_lote_formula = 0;
                String sql_lote = "  select f.CANTIDAD_LOTE from FORMULA_MAESTRA f where f.COD_FORMULA_MAESTRA='" + programaProduccionbean.getFormulaMaestra().getCodFormulaMaestra() + "'";
                System.out.println("sql_lote:" + sql_lote);
                setCon(Util.openConnection(getCon()));
                Statement st_lote = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rs_lote = st_lote.executeQuery(sql_lote);
                cantidad_lote_formula = 0;
                while (rs_lote.next()) {
                    cantidad_lote_formula = rs_lote.getDouble(1);
                }
                if (programaProduccionbean.getCantidadLote()==0) {
                    cantProduccion = cantidad_lote_formula;
                } else {
                    cantProduccion = programaProduccionbean.getCantidadLote();
                }
                System.out.println("cantProduccion EP:" + cantProduccion);
                formulaMaestraEPList.clear();
                formulaMaestraESList.clear();
                NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
                DecimalFormat form = (DecimalFormat) nf;
                form.applyPattern("#,###.00");
                String sql = " select m.cod_material,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA,mp.CANTIDAD,um.COD_UNIDAD_MEDIDA from FORMULA_MAESTRA_DETALLE_EP mp,MATERIALES m,UNIDADES_MEDIDA um";
                sql += " where  m.COD_MATERIAL=mp.cod_material and um.COD_UNIDAD_MEDIDA=m.COD_UNIDAD_MEDIDA and mp.cod_formula_maestra='" + programaProduccionbean.getFormulaMaestra().getCodFormulaMaestra() + "' and mp.COD_PRESENTACION_PRIMARIA = '" + codPresPrim + "'";
                System.out.println("sql EP:" + sql);
                setCon(Util.openConnection(getCon()));
                Statement st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rs = st.executeQuery(sql);
                while (rs.next()) {
                    String codMaterial = rs.getString(1);
                    String nombreMaterial = rs.getString(2);
                    String unidadMedida = rs.getString(3);
                    
                    double cantidad = rs.getDouble(4);
                    cantidad = (cantProduccion * cantidad);
                    cantidad = redondear(cantidad, 3);
                    System.out.println("Cantidad:  "+ cantidad);
                    
                    String codUnidadMedida = rs.getString(5);
                    FormulaMaestraDetalleMP bean = new FormulaMaestraDetalleMP();
                    bean.getMateriales().setCodMaterial(codMaterial);
                    bean.getMateriales().setNombreMaterial(nombreMaterial);
                    bean.getUnidadesMedida().setNombreUnidadMedida(unidadMedida);
                    bean.setCantidad(Double.valueOf(programaProduccionbean.getCantidadLote())/cantProduccion *cantidad*programaProduccionbean.getNroLotes());
                    bean.setCantidadRef(rs.getDouble("CANTIDAD"));
                    bean.getUnidadesMedida().setCodUnidadMedida(codUnidadMedida);
                    bean.setChecked(true);
                    formulaMaestraEPList.add(bean);
                }
                System.out.println("formulaMaestraEPList:Agregar:"+formulaMaestraEPList.size());
                this.cantidadLoteProduccion_change();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    public void changeEventSec(ValueChangeEvent event) {
        System.out.println("eventPrim:" + event.getNewValue());
        if (event.getNewValue() != null) {
            codPresProd = event.getNewValue().toString();
            try {
                double cantProduccion = 0;
                double cantidad_lote_formula = 0;
                String sql_lote = "  select f.CANTIDAD_LOTE from FORMULA_MAESTRA f where f.COD_FORMULA_MAESTRA='" + programaProduccionbean.getFormulaMaestra().getCodFormulaMaestra() + "'";
                System.out.println("sql_lote:" + sql_lote);
                setCon(Util.openConnection(getCon()));
                Statement st_lote = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rs_lote = st_lote.executeQuery(sql_lote);
                cantidad_lote_formula = 0;
                while (rs_lote.next()) {
                    cantidad_lote_formula = rs_lote.getDouble(1);
                }
                if (programaProduccionbean.getCantidadLote()==0) {
                    cantProduccion = cantidad_lote_formula;
                } else {
                    cantProduccion = programaProduccionbean.getCantidadLote();
                }
                System.out.println("cantProduccion EP:" + cantProduccion);
                //formulaMaestraEPList.clear();
                formulaMaestraESList.clear();
                NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
                DecimalFormat form = (DecimalFormat) nf;
                form.applyPattern("#,###.00");
                
                String sql = " select m.cod_material,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA,mp.CANTIDAD,um.COD_UNIDAD_MEDIDA from FORMULA_MAESTRA_DETALLE_ES mp,MATERIALES m,UNIDADES_MEDIDA um";
                sql += " where  m.COD_MATERIAL=mp.cod_material and um.COD_UNIDAD_MEDIDA=m.COD_UNIDAD_MEDIDA and mp.cod_formula_maestra='" + programaProduccionbean.getFormulaMaestra().getCodFormulaMaestra() + "' and mp.COD_PRESENTACION_PRODUCTO='" + codPresProd + "'";
                System.out.println("sql ES:" + sql);
                
                setCon(Util.openConnection(getCon()));
                Statement st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rs = st.executeQuery(sql);
                while (rs.next()) {
                    String codMaterial = rs.getString(1);
                    String nombreMaterial = rs.getString(2);
                    String unidadMedida = rs.getString(3);
                    double cantidad = rs.getDouble(4);
                    
                    cantidad = (cantProduccion * cantidad);
                    cantidad = redondear(cantidad, 3);
                    
                    String codUnidadMedida = rs.getString(5);
                    FormulaMaestraDetalleMP bean = new FormulaMaestraDetalleMP();
                    bean.getMateriales().setCodMaterial(codMaterial);
                    bean.getMateriales().setNombreMaterial(nombreMaterial);
                    bean.getUnidadesMedida().setNombreUnidadMedida(unidadMedida);
                    bean.setCantidad(Double.valueOf(programaProduccionbean.getCantidadLote())/cantProduccion *cantidad*programaProduccionbean.getNroLotes());
                    bean.setCantidadRef(rs.getDouble("CANTIDAD"));
                    bean.getUnidadesMedida().setCodUnidadMedida(codUnidadMedida);
                    bean.setChecked(true);
                    formulaMaestraESList.add(bean);
                }
                this.cantidadLoteProduccion_change();
                
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    public String guardarEditarProgramaProduccion() {
        try {
            String sql_delete = " delete from PROGRAMA_PRODUCCION where cod_programa_prod=" + programaProduccionbean.getCodProgramaProduccion();
            sql_delete += " and cod_compprod='" + programaProduccionbean.getFormulaMaestra().getComponentesProd().getCodCompprod() + "'";
            sql_delete += " and cod_formula_maestra='" + programaProduccionbean.getFormulaMaestra().getCodFormulaMaestra() + "' " +
                          " and cod_lote_produccion = '"+programaProduccionbean.getCodLoteProduccion()+"' " +
                          " and cod_tipo_programa_prod = '"+programaProduccionbean.getTiposProgramaProduccion().getCodTipoProgramaProd() +"' ";
            System.out.println("delete  1:" + sql_delete);
            con = Util.openConnection(con);
            PreparedStatement st_delete = con.prepareStatement(sql_delete);
            int result_delete = st_delete.executeUpdate();
            sql_delete = " delete from PROGRAMA_PRODUCCION_DETALLE where cod_programa_prod=" + programaProduccionbean.getCodProgramaProduccion();
            sql_delete += " and cod_compprod='" + programaProduccionbean.getFormulaMaestra().getComponentesProd().getCodCompprod() + "'" +
                    " and cod_lote_produccion = '"+programaProduccionbean.getCodLoteProduccion() +"'" +
                    " and cod_tipo_programa_prod = '"+programaProduccionbean.getTiposProgramaProduccion().getCodTipoProgramaProd() +"' ";
            
            System.out.println("delete  1:" + sql_delete);
            st_delete = con.prepareStatement(sql_delete);
            result_delete = st_delete.executeUpdate();
            System.out.println("codigo:" + programaProduccionbean.getCodProgramaProduccion());
            guardarProgramaProduccion();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        //cargarProgramaProduccion();
        return "navegadorProgramaProduccionSim";
    }
    
    public String guardarProgramaProduccion() {
        //System.out.println("formulaMaestraEPList******************:"+formulaMaestraEPList.size());
        String codLoteProd = "-";
        String codLoteProd1 = "";
        try {
            // la iteracion para productos enteros
            for(int lotes = 1 ;lotes<= programaProduccionbean.getNroLotes();lotes++){

            String sql_0 = "select cod_compprod from FORMULA_MAESTRA where COD_FORMULA_MAESTRA=" + programaProduccionbean.getFormulaMaestra().getCodFormulaMaestra();
            Statement st_0 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs_0 = st_0.executeQuery(sql_0);
            String codCompProd = "0";
            if (rs_0.next()) {
                codCompProd = rs_0.getString(1);
            }

            if(programaProduccionbean.getCodLoteProduccion().equals("") || programaProduccionbean.getCodLoteProduccion().equals("0") ){
                
            sql_0 = " select max(cast( ppr1.COD_LOTE_PRODUCCION as int)) +1 lote_produccion from PROGRAMA_PRODUCCION ppr1 where ppr1.COD_PROGRAMA_PROD= '"+programaProduccionbean.getCodProgramaProduccion()+"' ";
                System.out.println("consulta " + sql_0);
            Statement st_01 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs_01 = st_01.executeQuery(sql_0);
            if (rs_01.next()) {
                codLoteProd = rs_01.getString("lote_produccion")==null?"1":rs_01.getString("lote_produccion");
                //programaProduccionbean.setCodLoteProduccion(rs_01.getString("lote_produccion")==null?"1":rs_01.getString("lote_produccion"));
            }
            }else{
                codLoteProd = programaProduccionbean.getCodLoteProduccion();
            }
            
            String sql = "insert into programa_produccion(cod_programa_prod,cod_formula_maestra,cod_lote_produccion," +
                    "cod_estado_programa,observacion,CANT_LOTE_PRODUCCION,VERSION_LOTE,COD_COMPPROD,COD_TIPO_PROGRAMA_PROD,COD_PRESENTACION,nro_lotes)values(";
            sql += "" + programaProduccionbean.getCodProgramaProduccion() + ",'" + programaProduccionbean.getFormulaMaestra().getCodFormulaMaestra() + "',";
            sql += "'" + codLoteProd + "',4,'" + programaProduccionbean.getObservacion() + "','" + programaProduccionbean.getCantidadLote() + "',1," + codCompProd + ",'" + programaProduccionbean.getTiposProgramaProduccion().getCodTipoProgramaProd() + "'," +
                    " '"+codPresProd+"',1)";
            System.out.println("insert 1:" + sql);
            con = Util.openConnection(con);
            PreparedStatement st = con.prepareStatement(sql);
            int result = st.executeUpdate();
            if (result > 0) {
                Iterator i = formulaMaestraMPList.iterator();
                result = 0;
                while (i.hasNext()) {
                    FormulaMaestraDetalleMP bean = (FormulaMaestraDetalleMP) i.next();
                    if (bean.getChecked().booleanValue()) {
                        double cantidad = bean.getCantidad();
                        //cantidad = cantidad.replace(",", "");
                        System.out.println("cantidad0:" + cantidad);
                        sql = " insert into programa_produccion_detalle(cod_programa_prod,COD_COMPPROD, cod_material,cod_unidad_medida,cantidad,cod_lote_produccion,cod_tipo_programa_prod,cod_estado_registro) values(";
                        sql += "" +  programaProduccionbean.getCodProgramaProduccion()  + ", " + codCompProd + ",'" + bean.getMateriales().getCodMaterial() + "', ";
                        sql += "" + bean.getUnidadesMedida().getCodUnidadMedida() + "," + cantidad + ",'" + codLoteProd + "'," +
                                " '" + programaProduccionbean.getTiposProgramaProduccion().getCodTipoProgramaProd() + "',1) ";
                        System.out.println("insert detalle MP:sql:" + sql);
                        Statement st1 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                        result = result + st1.executeUpdate(sql);
                    }
                }
                Iterator m = formulaMaestraMRList.iterator();
                result = 0;
                while (m.hasNext()) {
                    FormulaMaestraDetalleMP bean = (FormulaMaestraDetalleMP) m.next();
                    if (bean.getChecked().booleanValue()) {
                        double cantidad = bean.getCantidad();
                        //cantidad = cantidad.replace(",", "");
                        System.out.println("cantidad0:" + cantidad);
                        sql = " insert into programa_produccion_detalle(cod_programa_prod,COD_COMPPROD, cod_material,cod_unidad_medida,cantidad,cod_lote_produccion,cod_tipo_programa_prod,cod_estado_registro) values(";
                        sql += "" + programaProduccionbean.getCodProgramaProduccion() + ", " + codCompProd + ",'" + bean.getMateriales().getCodMaterial() + "', ";
                        sql += "" + bean.getUnidadesMedida().getCodUnidadMedida() + "," + cantidad + ",'" + codLoteProd + "'," +
                                " '" + programaProduccionbean.getTiposProgramaProduccion().getCodTipoProgramaProd() + "',1) ";
                        System.out.println("insert detalle MR:sql:" + sql);
                        Statement st1 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                        result = result + st1.executeUpdate(sql);
                    }
                }
                System.out.println("formulaMaestraEPList:"+formulaMaestraEPList.size());
                Iterator j = formulaMaestraEPList.iterator();
                result = 0;
                while (j.hasNext()) {
                    FormulaMaestraDetalleMP bean = (FormulaMaestraDetalleMP) j.next();
                    if (bean.getChecked().booleanValue()) {
                        double cantidad = bean.getCantidad();
                        //cantidad = cantidad.replace(",", "");
                        System.out.println("cantidad1:" + cantidad);
                        sql = " insert into programa_produccion_detalle(cod_programa_prod,cod_material,cod_unidad_medida,cantidad,COD_COMPPROD,cod_lote_produccion,cod_tipo_programa_prod,COD_PRESENTACION_PRIMARIA,cod_estado_registro) values(";
                        sql += "" + programaProduccionbean.getCodProgramaProduccion()  + ",'" + bean.getMateriales().getCodMaterial() + "',";
                        sql += "" + bean.getUnidadesMedida().getCodUnidadMedida() + "," + cantidad + "," + codCompProd + ",'" + codLoteProd + "'," +
                                " '" + programaProduccionbean.getTiposProgramaProduccion().getCodTipoProgramaProd() + "','"+codPresPrim+"',1) ";
                        System.out.println("insert detalle EP:sql:" + sql);
                        Statement st1 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                        result = result + st1.executeUpdate(sql);
                    }
                }
                Iterator k = formulaMaestraESList.iterator();
                result = 0;
                while (k.hasNext()) {
                    FormulaMaestraDetalleMP bean = (FormulaMaestraDetalleMP) k.next();
                    if (bean.getChecked().booleanValue()) {
                        double cantidad = bean.getCantidad();
                        //cantidad = cantidad.replace(",", "");
                        System.out.println("cantidad2:" + cantidad);
                        sql = " insert into programa_produccion_detalle(cod_programa_prod,cod_material,cod_unidad_medida,cantidad,COD_COMPPROD,cod_lote_produccion,cod_tipo_programa_prod,COD_PRESENTACION_PRODUCTO,cod_estado_registro) values(";
                        sql += "" + programaProduccionbean.getCodProgramaProduccion()  + ",'" + bean.getMateriales().getCodMaterial() + "',";
                        sql += "" + bean.getUnidadesMedida().getCodUnidadMedida() + "," + cantidad + "," + codCompProd + ",'" +  codLoteProd  + "', " +
                                " '" + programaProduccionbean.getTiposProgramaProduccion().getCodTipoProgramaProd() + "' ,'"+codPresProd+"',1)";
                        System.out.println("insert detalle ES:sql:" + sql);
                        Statement st1 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                        result = result + st1.executeUpdate(sql);
                    }
                }
            }
            System.out.println("result:" + result);
        }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        getCargarProgramaProduccion1();
        

        return "navegadorProgramaProduccionSim";
    }

    public String cancelarEditarProgramaProduccion_action(){
        try {
               this.redireccionar("navegador_programa_produccion.jsf");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public String redireccionar(String direccion) {
        try {

            FacesContext facesContext = FacesContext.getCurrentInstance();
            ExternalContext ext = facesContext.getExternalContext();
            ext.redirect(direccion);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public void clearProgramaProduccion() {
//        ProgramaProduccion x = new ProgramaProduccion();
//        programaProduccionbean = x;
        formulaMaestraMPList.clear();
        formulaMaestraEPList.clear();
        formulaMaestraESList.clear();
        formulaMaestraMPROMList.clear();
        formulaMaestraMRList.clear();
        programaProduccionbean.setNroLotes(1);
    }
    private String codigos = "";
    private String fecha_inicio = "";
    private String fecha_final = "";
    
    public void actionEliminar() {
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
    public String explosionMateriales_action(){
        try {
            programaProduccionbean = new ProgramaProduccion();
            redireccionar("navegador_programa_produccion_explosion.jsf");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public String  explosionMaquinaria() {
//        String codigoformula="";
//        for (ProgramaProduccion bean : programaProduccionList) {
//            if (bean.getChecked().booleanValue()) {
//                setCodigos(getCodigos() + ("" + bean.getFormulaMaestra().getComponentesProd().getCodCompprod() + ","));
//                fecha_inicio = fecha_inicio + bean.getFechaInicio() + ",";
//                fecha_final = fecha_final + bean.getFechaFinal() + ",";
//                System.out.println(bean.getCodCompProd());
//                System.out.println("codformula:"+bean.getFormulaMaestra().getCodFormulaMaestra());
//                codigoformula+=bean.getFormulaMaestra().getCodFormulaMaestra()+",";
//            }
//        }
//        String sql="";
//        try {
//            sql="delete EXPLOSION_MAQUINARIAS where COD_PROGRAMA_PRODUCCION="+programaProduccionbean.getCodProgramaProduccion();
//            System.out.println(sql);
//            //con=Util.openConnection(con);
//            setCon(Util.openConnection(getCon()));
//            Statement stEliminarPro=con.createStatement();
//            stEliminarPro.executeUpdate(sql);
//            String codigoprograma=programaProduccionbean.getCodProgramaProduccion();
//            int index=1;
//
//            System.out.println("LONGITUDDDDDDDDDDDDDD--------------->" + codigoformula.length() );
//
//            if(codigoformula.length()>0){
//               codigoformula=codigoformula.substring(0,codigoformula.length()-1  );
//               System.out.println(codigoformula);
//               String tipo="select t.COD_TIPO_PROGRAMA_PROD from TIPOS_PROGRAMA_PRODUCCION t";
//               PreparedStatement stTipos =con.prepareStatement(tipo);
//               ResultSet  rsTipos  = stTipos .executeQuery();
//               index = 1; //Inicializo el index
//               while (rsTipos.next()){
//                    String cod_tipo=rsTipos.getString(1);
//                    //Esta consulta permite repetir los nombres de medicamentos
//                    //cod_tipo : no permite hacer la repeticion de medicamentos
//                    sql=" select m.COD_MAQUINA,(select ma.NOMBRE_MAQUINA from MAQUINARIAS ma where ma.COD_MAQUINA=m.COD_MAQUINA ) as NOMBRE_MAQUINA, ";
//                    sql+="cast (m.HORAS_HOMBRE as float)   AS HORAS_HOMBRE, ";
//                    sql+="cast (m.HORAS_MAQUINA as float)  AS HORAS_MAQUINA , ";
//
//                    sql+="(select p.CANT_LOTE_PRODUCCION from PROGRAMA_PRODUCCION p where p.COD_FORMULA_MAESTRA In( ";
//                    sql+="select (select f.COD_FORMULA_MAESTRA from  FORMULA_MAESTRA f where f.COD_FORMULA_MAESTRA=a.COD_FORMULA_MAESTRA) ";
//                    sql+="from ACTIVIDADES_FORMULA_MAESTRA a where a.COD_ACTIVIDAD_FORMULA=m.COD_ACTIVIDAD_FORMULA ";
//                    sql+=")  and p.COD_PROGRAMA_PROD="+codigoprograma+" and COD_TIPO_PROGRAMA_PROD="+cod_tipo+") as CANTIDAD, ";
//                    sql+="( cast (m.HORAS_HOMBRE as float)*(select p.CANT_LOTE_PRODUCCION from PROGRAMA_PRODUCCION p where p.COD_FORMULA_MAESTRA In( ";
//                    sql+="select (select f.COD_FORMULA_MAESTRA from  FORMULA_MAESTRA f where f.COD_FORMULA_MAESTRA=a.COD_FORMULA_MAESTRA) ";
//                    sql+="from ACTIVIDADES_FORMULA_MAESTRA a where a.COD_ACTIVIDAD_FORMULA=m.COD_ACTIVIDAD_FORMULA ";
//                    sql+=")  and p.COD_PROGRAMA_PROD="+codigoprograma+" and COD_TIPO_PROGRAMA_PROD="+cod_tipo+" ) ) AS HORAS_HOMBRETOTAL,";
//
//                    sql+="(cast (m.HORAS_MAQUINA as float)*(select p.CANT_LOTE_PRODUCCION from PROGRAMA_PRODUCCION p where p.COD_FORMULA_MAESTRA In( ";
//                    sql+="select (select f.COD_FORMULA_MAESTRA from  FORMULA_MAESTRA f where f.COD_FORMULA_MAESTRA=a.COD_FORMULA_MAESTRA) ";
//                    sql+="from ACTIVIDADES_FORMULA_MAESTRA a where a.COD_ACTIVIDAD_FORMULA=m.COD_ACTIVIDAD_FORMULA ";
//                    sql+=")  and p.COD_PROGRAMA_PROD="+codigoprograma+" and COD_TIPO_PROGRAMA_PROD="+cod_tipo+") ) AS HORAS_MAQUINATOTAL ";
//                    sql+="from  MAQUINARIA_ACTIVIDADES_FORMULA m where m.COD_ACTIVIDAD_FORMULA  in(select cod_actividad_formula from  ACTIVIDADES_FORMULA_MAESTRA a where a.COD_FORMULA_MAESTRA in("+codigoformula+"))  ";
//                    sql+="order by NOMBRE_MAQUINA ";
//                    sql+="";
//
//                    System.out.println("SQL GGGGGGGGGGGGGGGGGGGGG----------->" + sql);
//                    PreparedStatement stActividadFormula =con.prepareStatement(sql);
//                    ResultSet  rsActividadFormula  = stActividadFormula.executeQuery();
//                    setHrs_maquina(0);
//                    setHrs_hombre(0);
//                    while (rsActividadFormula.next()){
//                        String codmaquina=rsActividadFormula.getString(1);
//                        String nombremaquina=rsActividadFormula.getString(2);
//                        float horas_hombre=rsActividadFormula.getFloat(3);
//                        float horas_maquina=rsActividadFormula.getFloat(4);
//                        int cantidad_produccion=rsActividadFormula.getInt(5);
//                        float horas_hombretotal=rsActividadFormula.getFloat(6);
//                        float horas_maquinatotal=rsActividadFormula.getFloat(7);
//                       // System.out.println("------------------------");
//                       // System.out.println("NOM_M : "+ nombremaquina);
//                       // System.out.println("HR_H  : " + horas_hombre);
//                       // System.out.println("HR_MAQ: " + horas_maquina);
//                       // System.out.println("------------------------");
//                        setHrs_maquina(getHrs_maquina() +horas_maquina);
//                        setHrs_hombre(getHrs_hombre() + horas_hombre);
//                        sql="insert into EXPLOSION_MAQUINARIAS(COD_PROGRAMA_PRODUCCION,COD_MAQUINARIA,HORAS_MAQUINA,HORAS_HOMBRE,COD_EXPLOSIONMAQUINARIA)values(";
//                        sql+=codigoprograma+","+codmaquina+","+horas_maquinatotal+","+horas_hombretotal+","+index+")";
//                        index++;
//                        System.out.println(sql);
//                        Statement stExplosionMaquinarias=con.createStatement();
//                        stExplosionMaquinarias.executeUpdate(sql);
//                    }
//                    setHrs_hombre(getHrs_hombre());
//                    setHrs_maquina(getHrs_maquina());
//                    rsActividadFormula.close();
//                    stActividadFormula.close();
//                }
//                rsTipos.close();
//                stTipos.close();
//            }
//            sql=" select e.COD_MAQUINARIA,(select m.NOMBRE_MAQUINA from MAQUINARIAS m where m.COD_MAQUINA=e.COD_MAQUINARIA),sum(e.HORAS_MAQUINA),sum(e.HORAS_HOMBRE) from EXPLOSION_MAQUINARIAS e ";
//            sql+="  where e.COD_PROGRAMA_PRODUCCION="+codigoprograma+" group by e.COD_MAQUINARIA ";
//            System.out.println(" XYXYXYXYXYYXYXYXYYXYYXYX------->  "+sql);
//            Statement stConsultaExplosion2=con.createStatement();
//            ResultSet rsConsultaExplosion2=stConsultaExplosion2.executeQuery(sql);
//            List<MaquinaHombre> data=new ArrayList<MaquinaHombre>();
//            while (rsConsultaExplosion2.next()){
//                String COD_MAQUINARIA=rsConsultaExplosion2.getString(1);
//                String nombre=rsConsultaExplosion2.getString(2);
//                float hora1=rsConsultaExplosion2.getFloat(3);
//                float hora2=rsConsultaExplosion2.getFloat(4);
//                MaquinaHombre m=new MaquinaHombre();
//                m.codMaquinaria=COD_MAQUINARIA;
//                m.nombreMaquinaria=nombre;
//                m.horas_hombre=hora2;
//                m.horas_maquina=hora1;
//                data.add(m);
//            }
//            explotacionMaquinariasLista.clear();
//            sql="delete EXPLOSION_MAQUINARIAS where COD_PROGRAMA_PRODUCCION="+codigoprograma;
//            System.out.println(sql);
//            stEliminarPro.executeUpdate(sql);
//            index=1;
//            for(MaquinaHombre m:data){
//                sql="insert into EXPLOSION_MAQUINARIAS(COD_PROGRAMA_PRODUCCION,COD_MAQUINARIA,HORAS_MAQUINA,HORAS_HOMBRE,COD_EXPLOSIONMAQUINARIA)values(";
//                sql+=codigoprograma+","+m.codMaquinaria+","+m.horas_maquina+","+m.horas_hombre+","+index+")";
//                index++;
//                System.out.println(sql);
//                Statement stExplosionMaquinarias=con.createStatement();
//                stExplosionMaquinarias.executeUpdate(sql);
//            }
//            sql=" select (select m.NOMBRE_MAQUINA from MAQUINARIAS m where m.COD_MAQUINA=em.COD_MAQUINARIA) as NOMBRE_MAQUINA, ";
//            sql+="  em.HORAS_MAQUINA,em.HORAS_HOMBRE ";
//            sql+="  from EXPLOSION_MAQUINARIAS em where em.COD_PROGRAMA_PRODUCCION="+programaProduccionbean.getCodProgramaProduccion();
//            sql+="  ORDER BY NOMBRE_MAQUINA";
//
//            System.out.println("Consulta UUUUUUUUUUUUUU  -----" + sql);
//            Statement stConsultaExplosion=con.createStatement();
//            ResultSet  rsConsultaExplosion=stConsultaExplosion.executeQuery(sql);
//            explotacionMaquinariasLista.clear();
//            setHrs_maquina(0);
//            setHrs_hombre(0);
//            while (rsConsultaExplosion.next()){
//                String values[]=new String[3];
//                values[0]=rsConsultaExplosion.getString(1);
//                values[1]=rsConsultaExplosion.getString(2);
//                values[2]=rsConsultaExplosion.getString(3);
//                //System.out.println("****************************************************************");
//                setHrs_maquina(getHrs_maquina() + Float.parseFloat(rsConsultaExplosion.getString(2)));
//                setHrs_hombre(getHrs_hombre() + Float.parseFloat(rsConsultaExplosion.getString(3)));
//                //System.out.println("****************************************************************");
//                explotacionMaquinariasLista.add(values);
//            }
//            setHrs_hombre(getHrs_hombre());
//            setHrs_maquina(getHrs_maquina());
//            rsConsultaExplosion.close();
//            stConsultaExplosion.close();
//
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        return "explosicionMaquinaria";
        List programaProduccionList1 = new ArrayList();
        Iterator i = programaProduccionList.iterator();
        while(i.hasNext()){
            ProgramaProduccion programaProduccion = (ProgramaProduccion)i.next();
            if(programaProduccion.getChecked().booleanValue()==true){
                programaProduccionList1.add(programaProduccion);
            }
        }
        FacesContext facesContext = FacesContext.getCurrentInstance();
        ExternalContext ec = facesContext.getExternalContext();
        Map map = ec.getSessionMap();
        map.put("programaProduccionList",programaProduccionList1);
        map.put("programaProduccion",programaProduccionbean);
        return null;
    }
    public double cantidadPermitida(ProgramaProduccion programaProduccion){
        double cantidad = 0;
        try {
            con = Util.openConnection(con);
            Statement st = con.createStatement();
            
            String consulta = " select sum(ppr.CANT_LOTE_PRODUCCION) CANT_LOTE_PRODUCCION from PROGRAMA_PRODUCCION ppr  " +
                    " where ppr.COD_LOTE_PRODUCCION = '"+programaProduccion.getCodLoteProduccion() +"'" +
                    " and ppr.COD_PROGRAMA_PROD = '"+programaProduccion.getCodProgramaProduccion()+"' " +
                    " and ppr.COD_COMPPROD = '"+programaProduccion.getFormulaMaestra().getComponentesProd().getCodCompprod()+"' " +
                    " and ppr.COD_FORMULA_MAESTRA = '"+programaProduccion.getFormulaMaestra().getCodFormulaMaestra()+"' " +
                    " and ppr.COD_TIPO_PROGRAMA_PROD <> '"+programaProduccion.getTiposProgramaProduccion().getCodTipoProgramaProd()+"' ";
            System.out.println("consulta " + consulta);
            ResultSet rs = st.executeQuery(consulta);
            if(rs.next()){
                cantidad = rs.getDouble("CANT_LOTE_PRODUCCION");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return cantidad;
    }
    public String actionEditar() {
        System.out.println("codPresPrim:"+codPresPrim);
        System.out.println("codPresProd:"+codPresProd);
        cargarFormulaMaestra("",programaProduccionbean);
        cargarTiposProgramaProd("", programaProduccionbean);
        clearProgramaProduccion();
        Iterator i = programaProduccionList.iterator();
        while (i.hasNext()) {
            ProgramaProduccion bean = (ProgramaProduccion) i.next();
            if (bean.getChecked().booleanValue()) {
                programaProduccionbean = bean;
                break;
            }
        }
        programaProduccionbean.setCantRefLote(programaProduccionbean.getFormulaMaestra().getCantidadLote() -this.cantidadPermitida(programaProduccionbean));
        

        formulaMaestraMPList.clear();
        formulaMaestraMRList.clear();
        formulaMaestraEPList.clear();
        formulaMaestraESList.clear();
        formulaMaestraMPROMList.clear();
        getEmpaquePrimarioList().add(new SelectItem("0", "Seleccione Una Opción"));
        getEmpaqueSecundarioList().add(new SelectItem("0", "Seleccione Una Opción"));
        /******* Empaque Primario List*********/
        try {
            String sql = " select p.cod_presentacion_primaria,e.nombre_envaseprim,p.CANTIDAD from PRESENTACIONES_PRIMARIAS p,ENVASES_PRIMARIOS e " +
                    " where p.COD_ENVASEPRIM=e.cod_envaseprim";
            sql += " and p.COD_COMPPROD in (select fe.COD_COMPPROD from FORMULA_MAESTRA fe " +
                    " where fe.COD_FORMULA_MAESTRA='" + programaProduccionbean.getFormulaMaestra().getCodFormulaMaestra() + "')";
            System.out.println("sql Empaque Primario:" + sql);
            setCon(Util.openConnection(getCon()));
            Statement st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(sql);
            empaquePrimarioList.clear();
            empaquePrimarioList.add(new SelectItem("0", "Seleccione Una Opción"));
            while (rs.next()) {
                String nombreEnvasePrim = rs.getString(1);
                String cantidad = rs.getString(2);
                empaquePrimarioList.add(new SelectItem(rs.getString(1), rs.getString(2) + " x " + rs.getString(3)));
            }
            /******* Empaque Secundario List*********/
            sql = " select pp.cod_presentacion,pp.NOMBRE_PRODUCTO_PRESENTACION,es.NOMBRE_ENVASESEC,es.COD_ENVASESEC,";
            sql += " pp.cantidad_presentacion ";
            sql += " from PRESENTACIONES_PRODUCTO pp,ENVASES_SECUNDARIOS es,PRODUCTOS p";
            sql += " where es.COD_ENVASESEC=pp.COD_ENVASESEC and pp.cod_prod in (select cp.COD_PROD from COMPONENTES_PROD cp,FORMULA_MAESTRA fm ";
            sql += " where fm.COD_COMPPROD=cp.COD_COMPPROD and fm.COD_FORMULA_MAESTRA='" + programaProduccionbean.getFormulaMaestra().getCodFormulaMaestra() + "' ) and p.cod_prod=pp.cod_prod";
            sql += " order by es.NOMBRE_ENVASESEC ";
            System.out.println("sql Empaque Primario:" + sql);
            st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            rs = st.executeQuery(sql);
            empaqueSecundarioList.clear();
            empaqueSecundarioList.add(new SelectItem("0", "Seleccione Una Opción"));
            while (rs.next()) {
                String nombreEnvasePrim = rs.getString(1);
                String cantidad = rs.getString(2);
                empaqueSecundarioList.add(new SelectItem(rs.getString(1), rs.getString(2)));
            }
            
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
        DecimalFormat form = (DecimalFormat) nf;
        form.applyPattern("#,###.00");
        double cantLote = programaProduccionbean.getCantidadLote();
        try {
            String sql = " select m.cod_material,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA,mp.CANTIDAD,um.COD_UNIDAD_MEDIDA " +
                    " from FORMULA_MAESTRA_DETALLE_MP mp,MATERIALES m,UNIDADES_MEDIDA um ";
            sql += " where  m.COD_MATERIAL=mp.cod_material and um.COD_UNIDAD_MEDIDA=m.COD_UNIDAD_MEDIDA and mp.cod_formula_maestra=" + programaProduccionbean.getFormulaMaestra().getCodFormulaMaestra();
            System.out.println("sql MP:" + sql);
            setCon(Util.openConnection(getCon()));
            Statement st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(sql);
            while (rs.next()) {
                String codMaterial = rs.getString(1);
                String nombreMaterial = rs.getString(2);
                String unidadMedida = rs.getString(3);
                double cantidad = rs.getDouble(4);
                cantidad = redondear(cantidad, 3);
                String codUnidadMedida = rs.getString(5);
                FormulaMaestraDetalleMP bean = new FormulaMaestraDetalleMP();
                bean.getMateriales().setCodMaterial(codMaterial);
                bean.getMateriales().setNombreMaterial(nombreMaterial);
                bean.getUnidadesMedida().setNombreUnidadMedida(unidadMedida);
                bean.setCantidad(cantidad);
                bean.setCantidadRef(cantidad);
                bean.getUnidadesMedida().setCodUnidadMedida(codUnidadMedida);
                String sql_1 = " select * from PROGRAMA_PRODUCCION_DETALLE pp where pp.cod_programa_prod='" + programaProduccionbean.getCodProgramaProduccion() + "' " +
                        " and pp.cod_lote_produccion = '"+programaProduccionbean.getCodLoteProduccion()+"' " +
                        " and  pp.COD_MATERIAL=" + codMaterial + " " +
                        " and pp.cod_tipo_programa_prod = '"+programaProduccionbean.getTiposProgramaProduccion().getCodTipoProgramaProd()+"' " ;
                System.out.println("sql _1:" + sql_1);
                Statement st1 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rs1 = st1.executeQuery(sql_1);
                int sw = 0;
                while (rs1.next()) {
                    sw = 1;
                    bean.setCantidad(rs1.getDouble("CANTIDAD"));
                }
                if (sw == 1) {
                    bean.setChecked(true);                    
                } else {
                    bean.setChecked(false);
                }
                formulaMaestraMPList.add(bean);
            }
            /************reactivos*******************/
            sql = " select distinct m.cod_material,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA,mp.CANTIDAD,um.COD_UNIDAD_MEDIDA " +
                    " from FORMULA_MAESTRA_DETALLE_MR mp,MATERIALES m,UNIDADES_MEDIDA um";
            sql += " where  m.COD_MATERIAL=mp.cod_material and um.COD_UNIDAD_MEDIDA=m.COD_UNIDAD_MEDIDA and mp.cod_formula_maestra=" + programaProduccionbean.getFormulaMaestra().getCodFormulaMaestra();
            System.out.println("sql MP:" + sql);
            setCon(Util.openConnection(getCon()));
            st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            rs = st.executeQuery(sql);
            while (rs.next()) {
                String codMaterial = rs.getString(1);
                String nombreMaterial = rs.getString(2);
                String unidadMedida = rs.getString(3);
                double cantidad = rs.getDouble(4);
                cantidad = redondear(cantidad, 3);
                String codUnidadMedida = rs.getString(5);
                FormulaMaestraDetalleMP bean = new FormulaMaestraDetalleMP();
                bean.getMateriales().setCodMaterial(codMaterial);
                bean.getMateriales().setNombreMaterial(nombreMaterial);
                bean.getUnidadesMedida().setNombreUnidadMedida(unidadMedida);
                bean.setCantidad(cantidad);
                bean.setCantidadRef(cantidad);
                bean.getUnidadesMedida().setCodUnidadMedida(codUnidadMedida);
                String sql_1 = " select * from PROGRAMA_PRODUCCION_DETALLE pp where pp.cod_programa_prod='" + programaProduccionbean.getCodProgramaProduccion() + "'" +
                        " and pp.cod_lote_produccion = '"+programaProduccionbean.getCodLoteProduccion()+"' and  pp.COD_MATERIAL=" + codMaterial + "" +
                        " and pp.cod_tipo_programa_prod = '"+programaProduccionbean.getTiposProgramaProduccion().getCodTipoProgramaProd()+"' ";
                System.out.println("sql _1:" + sql_1);
                Statement st1 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rs1 = st1.executeQuery(sql_1);
                int sw = 0;
                while (rs1.next()) {
                    sw = 1;
                    bean.setCantidad(rs1.getDouble("CANTIDAD"));
                }
                if (sw == 1) {
                    bean.setChecked(true);
                } else {
                    bean.setChecked(false);
                }
                formulaMaestraMRList.add(bean);
            }
            /*****************************************/
            
            sql = " select distinct m.cod_material,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA,mp.CANTIDAD,um.COD_UNIDAD_MEDIDA,mp.COD_PRESENTACION_PRIMARIA " +
                    " from FORMULA_MAESTRA_DETALLE_EP mp,MATERIALES m,UNIDADES_MEDIDA um, PROGRAMA_PRODUCCION_DETALLE pprd  ";
            sql += " where  m.COD_MATERIAL=mp.cod_material and um.COD_UNIDAD_MEDIDA=m.COD_UNIDAD_MEDIDA and mp.cod_formula_maestra=" + programaProduccionbean.getFormulaMaestra().getCodFormulaMaestra()+"" +
                   " and mp.cod_material = pprd.cod_material and mp.cod_presentacion_primaria = pprd.cod_presentacion_primaria " +
                   " and pprd.cod_programa_prod = '"+programaProduccionbean.getCodProgramaProduccion()+"' " +
                   " and pprd.cod_lote_produccion = '"+programaProduccionbean.getCodLoteProduccion()+"' and pprd.cod_compprod = '"+programaProduccionbean.getFormulaMaestra().getComponentesProd().getCodCompprod()+"' " +
                   " and pprd.cod_tipo_programa_prod = '"+programaProduccionbean.getTiposProgramaProduccion().getCodTipoProgramaProd()+"'  " ;
                   
            
            System.out.println("sql EP:" + sql);
            st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            rs = st.executeQuery(sql);
            while (rs.next()) {
                String codMaterial = rs.getString(1);
                String nombreMaterial = rs.getString(2);
                String unidadMedida = rs.getString(3);
                
                double cantidad = rs.getDouble(4);
                cantidad = redondear(cantidad, 3);
                
                String codUnidadMedida = rs.getString(5);
                FormulaMaestraDetalleMP bean = new FormulaMaestraDetalleMP();
                bean.getMateriales().setCodMaterial(codMaterial);
                bean.getMateriales().setNombreMaterial(nombreMaterial);
                bean.getUnidadesMedida().setNombreUnidadMedida(unidadMedida);
                bean.setCantidad(cantidad);
                bean.setCantidadRef(cantidad);
                bean.getUnidadesMedida().setCodUnidadMedida(codUnidadMedida);
                codPresPrim=rs.getString(6);
                String sql_1 = " select * from PROGRAMA_PRODUCCION_DETALLE pp where pp.cod_programa_prod='" + programaProduccionbean.getCodProgramaProduccion() + "' " +
                        " and pp.cod_lote_produccion = '"+programaProduccionbean.getCodLoteProduccion()+"' and pp.COD_MATERIAL=" + codMaterial + " " +
                        " and pp.cod_tipo_programa_prod = '"+programaProduccionbean.getTiposProgramaProduccion().getCodTipoProgramaProd()+"' ";
                System.out.println("sql _1:" + sql_1);
                Statement st1 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rs1 = st1.executeQuery(sql_1);
                int sw = 0;
                while (rs1.next()) {
                    sw = 1;
                    bean.setCantidad(rs1.getDouble("CANTIDAD"));
                }
                if (sw == 1) {
                    bean.setChecked(true);
                } else {
                    bean.setChecked(false);
                }
                formulaMaestraEPList.add(bean);
            }
            System.out.println("codpresprim:"+codPresPrim);
            
            sql = " select distinct m.cod_material,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA,mp.CANTIDAD,um.COD_UNIDAD_MEDIDA,mp.COD_PRESENTACION_PRODUCTO " +
                    " from FORMULA_MAESTRA_DETALLE_ES mp,MATERIALES m,UNIDADES_MEDIDA um, programa_produccion_detalle pprd ";
            sql += " where  m.COD_MATERIAL=mp.cod_material and um.COD_UNIDAD_MEDIDA=m.COD_UNIDAD_MEDIDA and mp.cod_formula_maestra=" + programaProduccionbean.getFormulaMaestra().getCodFormulaMaestra()+ " " +
                    " and mp.cod_presentacion_producto='"+programaProduccionbean.getPresentacionesProducto().getCodPresentacion()+"' " +
                    " and mp.cod_material = pprd.cod_material and mp.cod_presentacion_producto = pprd.cod_presentacion_producto " +
                    " and pprd.cod_programa_prod = '"+programaProduccionbean.getCodProgramaProduccion() +"' " +
                    " and pprd.cod_lote_produccion = '"+programaProduccionbean.getCodLoteProduccion() +"' " +
                    " and pprd.cod_compprod = '"+programaProduccionbean.getFormulaMaestra().getComponentesProd().getCodCompprod()+"' " +
                    " and pprd.cod_tipo_programa_prod = '"+programaProduccionbean.getTiposProgramaProduccion().getCodTipoProgramaProd()+"' ";
            System.out.println("sql ES:" + sql);
            st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            rs = st.executeQuery(sql);
            while (rs.next()) {
                String codMaterial = rs.getString(1);
                String nombreMaterial = rs.getString(2);
                String unidadMedida = rs.getString(3);
                
                double cantidad = rs.getDouble(4);
                cantidad = redondear(cantidad, 3);
                
                String codUnidadMedida = rs.getString(5);
                codPresProd=rs.getString(6);
                FormulaMaestraDetalleMP bean = new FormulaMaestraDetalleMP();
                bean.getMateriales().setCodMaterial(codMaterial);
                bean.getMateriales().setNombreMaterial(nombreMaterial);
                bean.getUnidadesMedida().setNombreUnidadMedida(unidadMedida);
                bean.setCantidad(cantidad);
                bean.setCantidadRef(cantidad);
                bean.getUnidadesMedida().setCodUnidadMedida(codUnidadMedida);
                String sql_1 = " select * from PROGRAMA_PRODUCCION_DETALLE pp where pp.cod_programa_prod='" + programaProduccionbean.getCodProgramaProduccion() + "' " +
                        " and pp.cod_lote_produccion = '"+programaProduccionbean.getCodLoteProduccion()+"' and pp.COD_MATERIAL=" + codMaterial + " " +
                        " and pp.cod_tipo_programa_prod = '"+programaProduccionbean.getTiposProgramaProduccion().getCodTipoProgramaProd()+"' ";
                System.out.println("sql _1:" + sql_1);
                Statement st1 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rs1 = st1.executeQuery(sql_1);
                int sw = 0;
                while (rs1.next()) {
                    sw = 1;
                    bean.setCantidad(rs1.getDouble("CANTIDAD"));
                }
                if (sw == 1) {
                    bean.setChecked(true);
                } else {
                    bean.setChecked(false);
                }
                formulaMaestraESList.add(bean);
            }
            sql = " select distinct m.cod_material,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA,mp.CANTIDAD,um.COD_UNIDAD_MEDIDA from FORMULA_MAESTRA_DETALLE_MPROM mp,MATERIALES m,UNIDADES_MEDIDA um";
            sql += " where  m.COD_MATERIAL=mp.cod_material and um.COD_UNIDAD_MEDIDA=m.COD_UNIDAD_MEDIDA and mp.cod_formula_maestra=" + programaProduccionbean.getFormulaMaestra().getCodFormulaMaestra();
            System.out.println("sql MPROM:" + sql);
            st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            rs = st.executeQuery(sql);
            while (rs.next()) {
                String codMaterial = rs.getString(1);
                String nombreMaterial = rs.getString(2);
                String unidadMedida = rs.getString(3);
                
                double cantidad =rs.getDouble(4);
                cantidad = redondear(cantidad, 3);
                
                String codUnidadMedida = rs.getString(5);
                FormulaMaestraDetalleMP bean = new FormulaMaestraDetalleMP();
                bean.getMateriales().setCodMaterial(codMaterial);
                bean.getMateriales().setNombreMaterial(nombreMaterial);
                bean.getUnidadesMedida().setNombreUnidadMedida(unidadMedida);
                bean.setCantidad(cantidad);
                bean.setCantidadRef(cantidad);
                bean.getUnidadesMedida().setCodUnidadMedida(codUnidadMedida);
                String sql_1 = " select * from PROGRAMA_PRODUCCION_DETALLE pp where pp.cod_programa_prod='" + programaProduccionbean.getCodProgramaProduccion() + "' " +
                        " and pp.cod_lote_produccion = '"+programaProduccionbean.getCodLoteProduccion()+"' and pp.COD_MATERIAL=" + codMaterial + "" +
                        " and pp.cod_tipo_programa_prod = '"+programaProduccionbean.getTiposProgramaProduccion().getCodTipoProgramaProd()+"' ";
                System.out.println("sql _1:" + sql_1);
                Statement st1 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rs1 = st1.executeQuery(sql_1);
                
                int sw = 0;
                while (rs1.next()) {
                    sw = 1;
                    bean.setCantidad(rs1.getDouble("CANTIDAD"));
                }
                if (sw == 1) {
                    bean.setChecked(true);
                } else {
                    bean.setChecked(false);
                }
                formulaMaestraMPROMList.add(bean);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "actionEditarProgramaProduccionSim";
    }
    
    public String detalleProgramProd() {
        formulaMaestraMPList.clear();
        formulaMaestraMPReactivosList.clear();
        formulaMaestraEPList.clear();
        formulaMaestraESList.clear();
        formulaMaestraMPROMList.clear();
        formulaMaestraMRList.clear();
        NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
        DecimalFormat form = (DecimalFormat) nf;
        form.applyPattern("#,###.00");
        try {
            String sql = " select m.cod_material,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA,ppd.CANTIDAD,um.COD_UNIDAD_MEDIDA,m.cod_grupo";
            sql += " from MATERIALES m,UNIDADES_MEDIDA um,PROGRAMA_PRODUCCION_DETALLE ppd,PROGRAMA_PRODUCCION pp";
            sql += " where    um.COD_UNIDAD_MEDIDA = m.COD_UNIDAD_MEDIDA and m.COD_MATERIAL=ppd.COD_MATERIAL ";
            sql += " and pp.COD_PROGRAMA_PROD=ppd.COD_PROGRAMA_PROD and pp.cod_formula_maestra = '" + codFormulaMaestra + "' ";
            sql += " and pp.cod_programa_prod='" + codigo + "' and ppd.COD_COMPPROD=" + programaProduccionbean.getCodCompProd() + " ";
            sql += " and ppd.cod_lote_produccion=pp.cod_lote_produccion and pp.cod_compprod=ppd.cod_compprod " +
                   " and ppd.COD_TIPO_PROGRAMA_PROD = pp.COD_TIPO_PROGRAMA_PROD " +
                   " and ppd.cod_tipo_programa_prod = '"+programaProduccionbean.getTiposProgramaProduccion().getCodTipoProgramaProd()+"' ";
            sql += " and m.COD_MATERIAL in (select ep.COD_MATERIAL from FORMULA_MAESTRA_DETALLE_MP ep where ep.COD_FORMULA_MAESTRA='" + codFormulaMaestra + "') ";
            sql += " and pp.cod_lote_produccion='"+programaProduccionbean.getCodLoteProduccion()+"'";
            sql += " order by m.NOMBRE_MATERIAL";
            System.out.println("sql MP:" + sql);
            setCon(Util.openConnection(getCon()));
            Statement st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(sql);
            while (rs.next()) {
                String codMaterial = rs.getString(1);
                String nombreMaterial = rs.getString(2);
                String unidadMedida = rs.getString(3);
                double cantidad = rs.getDouble(4);
                String codUnidadMedida = rs.getString(5);
                String codGrupo = rs.getString(6);
                FormulaMaestraDetalleMP bean = new FormulaMaestraDetalleMP();
                bean.getMateriales().setCodMaterial(codMaterial);
                bean.getMateriales().setNombreMaterial(nombreMaterial);
                bean.getUnidadesMedida().setNombreUnidadMedida(unidadMedida);
                bean.setCantidad(cantidad);
                bean.getUnidadesMedida().setCodUnidadMedida(codUnidadMedida);
                if (codGrupo.equals("5")) {
                    System.out.println("reactivo");
                    formulaMaestraMPList.add(bean);
                } else {
                    System.out.println("no reactivo");
                    formulaMaestraMPList.add(bean);
                }
                
            }
            System.out.println("formulaMaestraMPReactivosList.size():" + formulaMaestraMPReactivosList.size());
            
            sql = " select m.cod_material,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA,ppd.CANTIDAD,um.COD_UNIDAD_MEDIDA,m.cod_grupo";
            sql += " from MATERIALES m,UNIDADES_MEDIDA um,PROGRAMA_PRODUCCION_DETALLE ppd,PROGRAMA_PRODUCCION pp";
            sql += " where    um.COD_UNIDAD_MEDIDA = m.COD_UNIDAD_MEDIDA and m.COD_MATERIAL=ppd.COD_MATERIAL ";
            sql += " and pp.COD_PROGRAMA_PROD=ppd.COD_PROGRAMA_PROD and pp.cod_formula_maestra = '" + codFormulaMaestra + "' ";
            sql += " and pp.cod_programa_prod='" + codigo + "' and ppd.COD_COMPPROD=" + programaProduccionbean.getCodCompProd() + " ";
            sql += " and ppd.cod_lote_produccion=pp.cod_lote_produccion and pp.cod_compprod=ppd.cod_compprod " +
                   " and ppd.COD_TIPO_PROGRAMA_PROD = pp.COD_TIPO_PROGRAMA_PROD " +
                   " and ppd.cod_tipo_programa_prod = '"+programaProduccionbean.getTiposProgramaProduccion().getCodTipoProgramaProd()+"' ";
            sql += " and m.COD_MATERIAL in (select ep.COD_MATERIAL from FORMULA_MAESTRA_DETALLE_MR ep where ep.COD_FORMULA_MAESTRA='" + codFormulaMaestra + "') ";
            sql += " and pp.cod_lote_produccion='"+programaProduccionbean.getCodLoteProduccion()+"'";
            sql += " order by m.NOMBRE_MATERIAL";
            System.out.println("sql MR:" + sql);
            setCon(Util.openConnection(getCon()));
            st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            rs = st.executeQuery(sql);
            while (rs.next()) {
                String codMaterial = rs.getString(1);
                String nombreMaterial = rs.getString(2);
                String unidadMedida = rs.getString(3);
                double cantidad = rs.getDouble(4);
                String codUnidadMedida = rs.getString(5);
                String codGrupo = rs.getString(6);
                FormulaMaestraDetalleMP bean = new FormulaMaestraDetalleMP();
                bean.getMateriales().setCodMaterial(codMaterial);
                bean.getMateriales().setNombreMaterial(nombreMaterial);
                bean.getUnidadesMedida().setNombreUnidadMedida(unidadMedida);
                bean.setCantidad(cantidad);
                bean.getUnidadesMedida().setCodUnidadMedida(codUnidadMedida);
                formulaMaestraMRList.add(bean);
            }
            System.out.println("formulaMaestraMRList.size():" + formulaMaestraMRList.size());
            sql = " select m.cod_material,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA,ppd.CANTIDAD,um.COD_UNIDAD_MEDIDA";
            sql += " from MATERIALES m,UNIDADES_MEDIDA um,PROGRAMA_PRODUCCION_DETALLE ppd,PROGRAMA_PRODUCCION pp";
            sql += " where    um.COD_UNIDAD_MEDIDA = m.COD_UNIDAD_MEDIDA and m.COD_MATERIAL=ppd.COD_MATERIAL ";
            sql += " and pp.COD_PROGRAMA_PROD=ppd.COD_PROGRAMA_PROD and pp.cod_formula_maestra = '" + codFormulaMaestra + "' ";
            sql += " and pp.cod_programa_prod='" + codigo + "' and ppd.COD_COMPPROD=" + programaProduccionbean.getCodCompProd() + " ";
            sql += " and ppd.COD_TIPO_PROGRAMA_PROD = pp.COD_TIPO_PROGRAMA_PROD " +
                   " and ppd.cod_lote_produccion=pp.cod_lote_produccion and pp.cod_compprod=ppd.cod_compprod " +
                   " and ppd.cod_tipo_programa_prod = '"+programaProduccionbean.getTiposProgramaProduccion().getCodTipoProgramaProd()+"' ";
            sql += " and m.COD_MATERIAL in (select ep.COD_MATERIAL from FORMULA_MAESTRA_DETALLE_EP ep where ep.COD_FORMULA_MAESTRA='" + codFormulaMaestra + "') ";
            sql += " and pp.cod_lote_produccion='"+programaProduccionbean.getCodLoteProduccion()+"'";
            sql += " order by m.NOMBRE_MATERIAL";
            System.out.println("sql EP:" + sql);
            st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            rs = st.executeQuery(sql);
            while (rs.next()) {
                String codMaterial = rs.getString(1);
                String nombreMaterial = rs.getString(2);
                String unidadMedida = rs.getString(3);
                double cantidad = rs.getDouble(4);
                String codUnidadMedida = rs.getString(5);
                FormulaMaestraDetalleMP bean = new FormulaMaestraDetalleMP();
                bean.getMateriales().setCodMaterial(codMaterial);
                bean.getMateriales().setNombreMaterial(nombreMaterial);
                bean.getUnidadesMedida().setNombreUnidadMedida(unidadMedida);
                bean.setCantidad(cantidad);
                bean.getUnidadesMedida().setCodUnidadMedida(codUnidadMedida);
            
                formulaMaestraEPList.add(bean);
            }
            sql = " select m.cod_material,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA,ppd.CANTIDAD,um.COD_UNIDAD_MEDIDA";
            sql += " from MATERIALES m,UNIDADES_MEDIDA um,PROGRAMA_PRODUCCION_DETALLE ppd,PROGRAMA_PRODUCCION pp";
            sql += " where    um.COD_UNIDAD_MEDIDA = m.COD_UNIDAD_MEDIDA and m.COD_MATERIAL=ppd.COD_MATERIAL ";
            sql += " and pp.COD_PROGRAMA_PROD=ppd.COD_PROGRAMA_PROD and pp.cod_formula_maestra = '" + codFormulaMaestra + "' ";
            sql += " and pp.cod_programa_prod='" + codigo + "' and ppd.COD_COMPPROD=" + programaProduccionbean.getCodCompProd() + " ";
            sql += " and ppd.cod_lote_produccion=pp.cod_lote_produccion and pp.cod_compprod=ppd.cod_compprod " +
                   " and ppd.COD_TIPO_PROGRAMA_PROD = pp.COD_TIPO_PROGRAMA_PROD " +
                   " and ppd.cod_tipo_programa_prod = '"+programaProduccionbean.getTiposProgramaProduccion().getCodTipoProgramaProd()+"' ";
            sql += " and m.COD_MATERIAL in (select ep.COD_MATERIAL from FORMULA_MAESTRA_DETALLE_ES ep where ep.COD_FORMULA_MAESTRA='" + codFormulaMaestra + "')" +
                   " and pp.COD_LOTE_PRODUCCION = '"+programaProduccionbean.getCodLoteProduccion()+"' ";
            sql += " order by m.NOMBRE_MATERIAL";
            System.out.println("sql ES:" + sql);
            st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            rs = st.executeQuery(sql);
            while (rs.next()) {
                String codMaterial = rs.getString(1);
                String nombreMaterial = rs.getString(2);
                String unidadMedida = rs.getString(3);
                double cantidad = rs.getDouble(4);
                String codUnidadMedida = rs.getString(5);
                FormulaMaestraDetalleMP bean = new FormulaMaestraDetalleMP();
                bean.getMateriales().setCodMaterial(codMaterial);
                bean.getMateriales().setNombreMaterial(nombreMaterial);
                bean.getUnidadesMedida().setNombreUnidadMedida(unidadMedida);
                bean.setCantidad(cantidad);
                bean.getUnidadesMedida().setCodUnidadMedida(codUnidadMedida);   
                formulaMaestraESList.add(bean);
            }
            sql = " select m.cod_material,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA,ppd.CANTIDAD,um.COD_UNIDAD_MEDIDA";
            sql += " from MATERIALES m,UNIDADES_MEDIDA um,PROGRAMA_PRODUCCION_DETALLE ppd,PROGRAMA_PRODUCCION pp";
            sql += " where    um.COD_UNIDAD_MEDIDA = m.COD_UNIDAD_MEDIDA and m.COD_MATERIAL=ppd.COD_MATERIAL ";
            sql += " and pp.COD_PROGRAMA_PROD=ppd.COD_PROGRAMA_PROD and pp.cod_formula_maestra = '" + codFormulaMaestra + "' ";
            sql += " and pp.cod_programa_prod='" + codigo + "'";
            sql += " and ppd.cod_lote_produccion=pp.cod_lote_produccion and pp.cod_compprod=ppd.cod_compprod " +
                   " and ppd.COD_TIPO_PROGRAMA_PROD = pp.COD_TIPO_PROGRAMA_PROD " +
                   " and ppd.cod_tipo_programa_prod = '"+programaProduccionbean.getTiposProgramaProduccion().getCodTipoProgramaProd()+"' ";
            sql += " and m.COD_MATERIAL in (select ep.COD_MATERIAL from FORMULA_MAESTRA_DETALLE_MPROM ep where ep.COD_FORMULA_MAESTRA='" + codFormulaMaestra + "') ";
            sql += " and pp.cod_lote_produccion='"+programaProduccionbean.getCodLoteProduccion()+"'";
            sql += " order by m.NOMBRE_MATERIAL";
            System.out.println("sql MPROM:" + sql);
            st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            rs = st.executeQuery(sql);
            while (rs.next()) {
                String codMaterial = rs.getString(1);
                String nombreMaterial = rs.getString(2);
                String unidadMedida = rs.getString(3);
                double cantidad = rs.getDouble(4);
                String codUnidadMedida = rs.getString(5);
                FormulaMaestraDetalleMP bean = new FormulaMaestraDetalleMP();
                bean.getMateriales().setCodMaterial(codMaterial);
                bean.getMateriales().setNombreMaterial(nombreMaterial);
                bean.getUnidadesMedida().setNombreUnidadMedida(unidadMedida);
                bean.setCantidad(cantidad);
                bean.getUnidadesMedida().setCodUnidadMedida(codUnidadMedida);

                formulaMaestraMPROMList.add(bean);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "";
    }
    
    public String eliminarProgProd() {
        try {
            con = Util.openConnection(con);
            Iterator i = programaProduccionLotesList.iterator();
            int result = 0;
            Statement st = null;
            while (i.hasNext()) {
                ProgramaProduccion bean = (ProgramaProduccion) i.next();
                if (bean.getChecked().booleanValue()) {
                    String sql = "delete from PROGRAMA_PRODUCCION_DETALLE where COD_PROGRAMA_PROD='" + bean.getCodProgramaProduccion() + "' " +
                            " and COD_COMPPROD=" + bean.getFormulaMaestra().getComponentesProd().getCodCompprod();
                    sql +=" and cod_lote_produccion='"+bean.getCodLoteProduccion()+"'";
                    System.out.println("PROGRAMA_PRODUCCION_DETALLE:sql:" + sql);
                    st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    //result = result + st.executeUpdate(sql);
                    result = st.executeUpdate(sql);
                    
                    sql = " delete from PROGRAMA_PRODUCCION " +
                          " where COD_PROGRAMA_PROD='" + bean.getCodProgramaProduccion() + "' " +
                          " and COD_COMPPROD=" + bean.getFormulaMaestra().getComponentesProd().getCodCompprod();
                    sql+=" and cod_lote_produccion='"+bean.getCodLoteProduccion()+"'";
                    System.out.println("PROGRAMA_PRODUCCION:sql:" + sql);
                    st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    //result = result + st.executeUpdate(sql);
                    result = st.executeUpdate(sql);
                }
            }
            if (result > 0) {
                getCargarProgramaProduccion2();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        //this.redireccionar("navegador_programa_produccion");
        return null;
        //return "navegadorProgramaProduccionSim";
    }
    /* ------------------Métodos---------------------------*/
    
    public void changeEventLote(javax.faces.event.ValueChangeEvent event) {
        System.out.println("event 2:" + event.getNewValue());
        String cantidad_prod = event.getNewValue().toString();
        try {
            double cantProduccion = 0;
            double cantidad_lote_formula = 0;
            if (!cantidad_prod.equals("")) {
                
                String sql_lote = "  select f.CANTIDAD_LOTE from FORMULA_MAESTRA f where f.COD_FORMULA_MAESTRA='" + programaProduccionbean.getFormulaMaestra().getCodFormulaMaestra() + "'";
                
                System.out.println("sql_lote:" + sql_lote);
                setCon(Util.openConnection(getCon()));
                Statement st_lote = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rs_lote = st_lote.executeQuery(sql_lote);
                cantidad_lote_formula = 0;
                while (rs_lote.next()) {
                    cantidad_lote_formula = rs_lote.getDouble(1);
                }
                cantProduccion = Double.parseDouble(cantidad_prod);
            }
            
            formulaMaestraMPList.clear();
            formulaMaestraEPList.clear();
            formulaMaestraESList.clear();
            formulaMaestraMPROMList.clear();
            formulaMaestraMRList.clear();
            NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
            DecimalFormat form = (DecimalFormat) nf;
            form.applyPattern("#,###.00");
            String codFormulaMaestra = programaProduccionbean.getFormulaMaestra().getCodFormulaMaestra();
            
            
            String sql = " select m.cod_material,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA,mp.CANTIDAD,um.COD_UNIDAD_MEDIDA,m.cod_grupo  " +
                    " from FORMULA_MAESTRA_DETALLE_MP mp,MATERIALES m,UNIDADES_MEDIDA um";
            sql += " where  m.COD_MATERIAL=mp.cod_material and um.COD_UNIDAD_MEDIDA=m.COD_UNIDAD_MEDIDA and mp.cod_formula_maestra=" + codFormulaMaestra;
            sql += " order by m.NOMBRE_MATERIAL";
            System.out.println("sql MP:" + sql);
            Statement st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(sql);
            while (rs.next()) {
                String codMaterial = rs.getString(1);
                String nombreMaterial = rs.getString(2);
                String unidadMedida = rs.getString(3);
                double cantidad = rs.getDouble(4);
                System.out.println("cantidad:" + cantidad);
                System.out.println("cantProduccion:" + cantProduccion);
                cantidad = (cantProduccion * cantidad);
                cantidad = redondear(cantidad, 3);
                String codUnidadMedida = rs.getString(5);
                String codGrupo = rs.getString(6);
                FormulaMaestraDetalleMP bean = new FormulaMaestraDetalleMP();
                bean.setSwNo(false);
                bean.setSwSi(false);
                bean.getMateriales().setCodMaterial(codMaterial);
                bean.getMateriales().setNombreMaterial(nombreMaterial);
                bean.getUnidadesMedida().setNombreUnidadMedida(unidadMedida);
                bean.setCantidad(cantidad);
                bean.getUnidadesMedida().setCodUnidadMedida(codUnidadMedida);
                bean.setChecked(true);
                if (codGrupo.equals("5")) {
                    System.out.println("reactivo");
                    bean.setSwNo(false);
                    bean.setSwSi(true);
                } else {
                    System.out.println("no reactivo");
                    bean.setSwNo(true);
                    bean.setSwSi(false);
                }
                formulaMaestraMPList.add(bean);
            }
            
            sql = " select m.cod_material,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA,mp.CANTIDAD,um.COD_UNIDAD_MEDIDA,m.cod_grupo  " +
                    " from FORMULA_MAESTRA_DETALLE_MR mp,MATERIALES m,UNIDADES_MEDIDA um";
            sql += " where  m.COD_MATERIAL=mp.cod_material and um.COD_UNIDAD_MEDIDA=m.COD_UNIDAD_MEDIDA and mp.cod_formula_maestra=" + codFormulaMaestra;
            sql += " order by m.NOMBRE_MATERIAL";
            System.out.println("sql MR:" + sql);
            st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            rs = st.executeQuery(sql);
            while (rs.next()) {
                String codMaterial = rs.getString(1);
                String nombreMaterial = rs.getString(2);
                String unidadMedida = rs.getString(3);
                double cantidad = rs.getDouble(4);
                System.out.println("cantidad:" + cantidad);
                System.out.println("cantProduccion:" + cantProduccion);
                cantidad = (cantProduccion * cantidad);
                cantidad = redondear(cantidad, 3);
                String codUnidadMedida = rs.getString(5);
                String codGrupo = rs.getString(6);
                FormulaMaestraDetalleMP bean = new FormulaMaestraDetalleMP();
                bean.getMateriales().setCodMaterial(codMaterial);
                bean.getMateriales().setNombreMaterial(nombreMaterial);
                bean.getUnidadesMedida().setNombreUnidadMedida(unidadMedida);
                bean.setCantidad(cantidad);
                bean.getUnidadesMedida().setCodUnidadMedida(codUnidadMedida);
                bean.setChecked(true);
                if (codGrupo.equals("5")) {
                    System.out.println("reactivo");
                } else {
                    System.out.println("no reactivo");
                }
                formulaMaestraMRList.add(bean);
            }
            
            sql = " select m.cod_material,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA,mp.CANTIDAD,um.COD_UNIDAD_MEDIDA " +
                    " from FORMULA_MAESTRA_DETALLE_EP mp,MATERIALES m,UNIDADES_MEDIDA um";
            sql += " where  m.COD_MATERIAL=mp.cod_material and um.COD_UNIDAD_MEDIDA=m.COD_UNIDAD_MEDIDA " +
                    " and mp.cod_formula_maestra=" + codFormulaMaestra + " and mp.COD_PRESENTACION_PRIMARIA = '" + codPresPrim + "'";
            sql += " order by m.NOMBRE_MATERIAL";
            System.out.println("sql EP:" + sql);
            st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            rs = st.executeQuery(sql);
            while (rs.next()) {
                String codMaterial = rs.getString(1);
                String nombreMaterial = rs.getString(2);
                String unidadMedida = rs.getString(3);
                double cantidad = rs.getDouble(4);
                cantidad = (cantProduccion * cantidad);
                cantidad = redondear(cantidad, 3);
                String codUnidadMedida = rs.getString(5);
                FormulaMaestraDetalleMP bean = new FormulaMaestraDetalleMP();
                bean.getMateriales().setCodMaterial(codMaterial);
                bean.getMateriales().setNombreMaterial(nombreMaterial);
                bean.getUnidadesMedida().setNombreUnidadMedida(unidadMedida);
                bean.setCantidad(cantidad);
                bean.getUnidadesMedida().setCodUnidadMedida(codUnidadMedida);
                bean.setChecked(true);
                formulaMaestraEPList.add(bean);
            }
            sql = " select m.cod_material,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA,mp.CANTIDAD,um.COD_UNIDAD_MEDIDA " +
                    " from FORMULA_MAESTRA_DETALLE_ES mp,MATERIALES m,UNIDADES_MEDIDA um";
            sql += " where  m.COD_MATERIAL=mp.cod_material and um.COD_UNIDAD_MEDIDA=m.COD_UNIDAD_MEDIDA " +
                    " and mp.cod_formula_maestra=" + codFormulaMaestra + " and mp.COD_PRESENTACION_PRODUCTO='" + codPresProd + "'";
            sql += " order by m.NOMBRE_MATERIAL";
            System.out.println("sql ES:" + sql);
            st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            rs = st.executeQuery(sql);
            
            while (rs.next()) {
                String codMaterial = rs.getString(1);
                String nombreMaterial = rs.getString(2);
                String unidadMedida = rs.getString(3);
                double cantidad = rs.getDouble(4);
                cantidad = (cantProduccion * cantidad);
                cantidad = redondear(cantidad, 3);
                String codUnidadMedida = rs.getString(5);
                FormulaMaestraDetalleMP bean = new FormulaMaestraDetalleMP();
                bean.getMateriales().setCodMaterial(codMaterial);
                bean.getMateriales().setNombreMaterial(nombreMaterial);
                bean.getUnidadesMedida().setNombreUnidadMedida(unidadMedida);
                bean.setCantidad(cantidad);
                bean.getUnidadesMedida().setCodUnidadMedida(codUnidadMedida);
                bean.setChecked(true);
                formulaMaestraESList.add(bean);
            }
            sql = " select m.cod_material,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA,mp.CANTIDAD,um.COD_UNIDAD_MEDIDA from FORMULA_MAESTRA_DETALLE_MPROM mp,MATERIALES m,UNIDADES_MEDIDA um";
            sql += " where  m.COD_MATERIAL=mp.cod_material and um.COD_UNIDAD_MEDIDA=m.COD_UNIDAD_MEDIDA and mp.cod_formula_maestra=" + codFormulaMaestra;
            sql += " order by m.NOMBRE_MATERIAL";
            System.out.println("sql MPROM:" + sql);
            st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            rs = st.executeQuery(sql);
            while (rs.next()) {
                String codMaterial = rs.getString(1);
                String nombreMaterial = rs.getString(2);
                String unidadMedida = rs.getString(3);
                double cantidad = rs.getDouble(4);
                cantidad = (cantProduccion * cantidad);
                cantidad = redondear(cantidad, 3);
                String codUnidadMedida = rs.getString(5);
                FormulaMaestraDetalleMP bean = new FormulaMaestraDetalleMP();
                bean.getMateriales().setCodMaterial(codMaterial);
                bean.getMateriales().setNombreMaterial(nombreMaterial);
                bean.getUnidadesMedida().setNombreUnidadMedida(unidadMedida);
                bean.setCantidad(cantidad);
                bean.getUnidadesMedida().setCodUnidadMedida(codUnidadMedida);
                bean.setChecked(true);
                formulaMaestraMPROMList.add(bean);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public String cantidadLoteProduccion_change(){
        try {
            mensaje = "";
            if(programaProduccionbean.getCantidadLote() < programaProduccionbean.getFormulaMaestra().getCantidadLote()
                 && programaProduccionbean.getNroLotes()>1   ){
                programaProduccionbean.setNroLotes(1);
                mensaje = " el numero de lotes debe ser uno  ";
                return null;
            }
            if(programaProduccionbean.getCantidadLote() > programaProduccionbean.getCantRefLote()){
                programaProduccionbean.setCantidadLote(programaProduccionbean.getCantRefLote());
                mensaje = " no se debe sobrepasar la cantidad de lote  ";
                return null;
            }
            
            NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
            DecimalFormat form = (DecimalFormat) nf;
            form.applyPattern("#,###.00");

            double cantidadFormulaMaestra = cantidadLoteFormulaMaestra();
            Iterator i = formulaMaestraMPList.iterator();
            while(i.hasNext()){
                FormulaMaestraDetalleMP formulaMaestraDetalleMP = (FormulaMaestraDetalleMP)i.next();                
                formulaMaestraDetalleMP.setCantidad(programaProduccionbean.getCantidadLote()/cantidadFormulaMaestra*formulaMaestraDetalleMP.getCantidadRef()); //*programaProduccionbean.getNroLotes()
                //System.out.println("cantidades CantidadLote " + programaProduccionbean.getCantidadLote() + " cantidadFormulaMaestra "+ cantidadFormulaMaestra +" cantidadRef "+formulaMaestraDetalleMP.getCantidadRef());
            }
            i = formulaMaestraMRList.iterator();
            while(i.hasNext()){
                FormulaMaestraDetalleMP formulaMaestraDetalleMP = (FormulaMaestraDetalleMP)i.next();
                formulaMaestraDetalleMP.setCantidad(programaProduccionbean.getCantidadLote()/cantidadFormulaMaestra*formulaMaestraDetalleMP.getCantidadRef()); // *programaProduccionbean.getNroLotes()
            }
            i = formulaMaestraEPList.iterator();
            while(i.hasNext()){
                FormulaMaestraDetalleMP formulaMaestraDetalleMP = (FormulaMaestraDetalleMP)i.next();
                System.out.println("materia prima factores " + programaProduccionbean.getCantidadLote()+" / "+cantidadFormulaMaestra + "*" + formulaMaestraDetalleMP.getCantidadRef());
                formulaMaestraDetalleMP.setCantidad(programaProduccionbean.getCantidadLote()/cantidadFormulaMaestra*formulaMaestraDetalleMP.getCantidadRef()); // *programaProduccionbean.getNroLotes()
            }
            i = formulaMaestraESList.iterator();
            while(i.hasNext()){
                FormulaMaestraDetalleMP formulaMaestraDetalleMP = (FormulaMaestraDetalleMP)i.next();
                formulaMaestraDetalleMP.setCantidad(programaProduccionbean.getCantidadLote()/cantidadFormulaMaestra*formulaMaestraDetalleMP.getCantidadRef()); // *programaProduccionbean.getNroLotes()
            }

            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public String seleccionaSecuenciaProgramaProd_action(){
        try {
            ProgramaProduccion programaProduccionSeleccionado = (ProgramaProduccion)programaProduccionDataTable.getRowData();
            Iterator i = programaProduccionList.iterator();
            
            while(i.hasNext()){
                ProgramaProduccion programaProduccion = (ProgramaProduccion)i.next();
                if(programaProduccionSeleccionado.getCodSecuenciaProgramaProd()==programaProduccion.getCodSecuenciaProgramaProd()){
                    if(programaProduccionSeleccionado.getChecked().booleanValue()==true){
                        programaProduccion.setChecked(true);
                    }else{
                        programaProduccion.setChecked(false);
                    }
                    
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public double cantidadLoteFormulaMaestra(){
        double cantProduccion = 0;
        try {      // codFormulaMaestra

            String consulta = " select fm.CANTIDAD_LOTE from FORMULA_MAESTRA fm where fm.COD_FORMULA_MAESTRA = '"+ programaProduccionbean.getFormulaMaestra().getCodFormulaMaestra() +"' ";
            System.out.println("consulta" + consulta);
            setCon(Util.openConnection(getCon()));
            Statement st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(consulta);
            if(rs.next()){
                cantProduccion = rs.getDouble("CANTIDAD_LOTE");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return  cantProduccion;
    }
    public String eliminarProgramaProduccion_action(){
        try {
            String consulta  = "  ";
            Iterator i = programaProduccionList.iterator();
            while(i.hasNext()){
                ProgramaProduccion programaProduccion = (ProgramaProduccion)i.next();
                if(programaProduccion.getChecked().booleanValue()==true){
                    consulta = " DELETE FROM PROGRAMA_PRODUCCION WHERE COD_PROGRAMA_PROD = '"+programaProduccion.getCodProgramaProduccion()+"' " +
                               " AND COD_COMPPROD='"+programaProduccion.getFormulaMaestra().getComponentesProd().getCodCompprod()+"' " +
                               " AND COD_FORMULA_MAESTRA = '"+programaProduccion.getFormulaMaestra().getCodFormulaMaestra()+"' " +
                               " AND COD_LOTE_PRODUCCION = '"+programaProduccion.getCodLoteProduccion()+"' " +
                               " AND COD_TIPO_PROGRAMA_PROD = '"+programaProduccion.getTiposProgramaProduccion().getCodTipoProgramaProd()+"' ;";
                    
                    System.out.println("consulta" + consulta);
                    
                    setCon(Util.openConnection(getCon()));
                    Statement st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    st.executeUpdate(consulta);
                    

                    consulta = " DELETE FROM PROGRAMA_PRODUCCION_DETALLE " +
                            " WHERE COD_PROGRAMA_PROD = '"+programaProduccion.getCodProgramaProduccion()+"' " +
                            " AND COD_COMPPROD = '"+programaProduccion.getFormulaMaestra().getComponentesProd().getCodCompprod()+"' " +
                            " AND COD_LOTE_PRODUCCION = '"+programaProduccion.getCodLoteProduccion()+"' " +
                            " AND COD_TIPO_PROGRAMA_PROD = '"+programaProduccion.getTiposProgramaProduccion().getCodTipoProgramaProd()+"'";
                    System.out.println("consulta " + consulta);
                    st.executeUpdate(consulta);

                    st.close();
                    getCargarProgramaProduccion1();
                    break;
                    
                    //ResultSet rs = st.executeQuery(consulta);
                    

                }
            }
            


        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public double redondear(double numero, int decimales) {
        return Math.round(numero * Math.pow(10, decimales)) / Math.pow(10, decimales);
    }
    
    public static void main(String[] args) {
        int a1, m1, d1, a2, m2, d2;
        String fe_inicio = "05-1-2008";
        System.out.println("fe_inicio:" + fe_inicio);
        String fe_final = "05-31-2008";
        System.out.println("fe_final:" + fe_final);
   
    }

    public String cargarProgramaProduccionLotes(){
        try {
            

            String consulta = " select distinct ppr.COD_PROGRAMA_PROD,ppr.COD_COMPPROD,cast(ppr.COD_LOTE_PRODUCCION as int) COD_LOTE_PRODUCCION,cp.nombre_prod_semiterminado,eppr.NOMBRE_ESTADO_PROGRAMA_PROD, " +
                    "   ISNULL((  SELECT C.NOMBRE_CATEGORIACOMPPROD  FROM CATEGORIAS_COMPPROD C WHERE C.COD_CATEGORIACOMPPROD = cp.COD_CATEGORIACOMPPROD ), '') NOMBRE_CATEGORIACOMPPROD," +
                    " ppr.cod_formula_maestra " +
                    " from PROGRAMA_PRODUCCION ppr  " +
                    " inner join COMPONENTES_PROD cp on cp.COD_COMPPROD = ppr.COD_COMPPROD " +
                    " inner join ESTADOS_PROGRAMA_PRODUCCION eppr on eppr.COD_ESTADO_PROGRAMA_PROD = ppr.COD_ESTADO_PROGRAMA " +
                    " where ppr.COD_PROGRAMA_PROD = '"+codProgramaProd+"'  " +
                    " order by cast(ppr.COD_LOTE_PRODUCCION as int),cp.nombre_prod_semiterminado asc  ";

            consulta = " select ppr.COD_PROGRAMA_PROD, ppr.COD_COMPPROD, cast (ppr.COD_LOTE_PRODUCCION as int) COD_LOTE_PRODUCCION," +
                    "  cp.nombre_prod_semiterminado,  ppr.cod_formula_maestra," +
                    " count(ppr.COD_PROGRAMA_PROD) NRO_PRODUCTOS, sum(ppr.CANT_LOTE_PRODUCCION) TOTAL_CANTIDAD, fm.CANTIDAD_LOTE," +
                    " ISNULL(( SELECT C.NOMBRE_CATEGORIACOMPPROD FROM CATEGORIAS_COMPPROD C WHERE C.COD_CATEGORIACOMPPROD = cp.COD_CATEGORIACOMPPROD ), '') NOMBRE_CATEGORIACOMPPROD " +
                    " from PROGRAMA_PRODUCCION ppr " +
                    " inner join COMPONENTES_PROD cp on cp.COD_COMPPROD = ppr.COD_COMPPROD " +
                    " inner join ESTADOS_PROGRAMA_PRODUCCION eppr on eppr.COD_ESTADO_PROGRAMA_PROD = ppr.COD_ESTADO_PROGRAMA      " +
                    " inner join FORMULA_MAESTRA fm on fm.COD_COMPPROD = cp.COD_COMPPROD " +
                    " where ppr.COD_PROGRAMA_PROD = '"+codProgramaProd+"' " +
                    " group by ppr.COD_PROGRAMA_PROD, ppr.COD_COMPPROD, " +
                    " cast (ppr.COD_LOTE_PRODUCCION as int),cp.nombre_prod_semiterminado,ppr.cod_formula_maestra," +
                    " fm.CANTIDAD_LOTE, cp.COD_CATEGORIACOMPPROD " +
                    " order by cast (ppr.COD_LOTE_PRODUCCION as int),  cp.nombre_prod_semiterminado asc ";

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


    public String seleccionarProgramaProduccionLotes_action(){
       try {
          setCon(Util.openConnection(getCon()));
          ProgramaProduccion programaProduccionLotes = (ProgramaProduccion)programaProduccionLotesDataTable.getRowData();
          String consulta = " select cp.nombre_prod_semiterminado,ppr.COD_LOTE_PRODUCCION, " +
                  " tppr.NOMBRE_TIPO_PROGRAMA_PROD, eppr.NOMBRE_ESTADO_PROGRAMA_PROD,ae.NOMBRE_AREA_EMPRESA,PPR.CANT_LOTE_PRODUCCION " +
                  " from PROGRAMA_PRODUCCION ppr  " +
                  " inner join COMPONENTES_PROD cp on ppr.COD_COMPPROD = cp.COD_COMPPROD " +
                  " inner join TIPOS_PROGRAMA_PRODUCCION tppr on tppr.COD_TIPO_PROGRAMA_PROD = ppr.COD_TIPO_PROGRAMA_PROD " +
                  " inner join ESTADOS_PROGRAMA_PRODUCCION eppr on eppr.COD_ESTADO_PROGRAMA_PROD = ppr.COD_ESTADO_PROGRAMA " +
                  " left outer join CATEGORIAS_COMPPROD cpr on cpr.COD_CATEGORIACOMPPROD = cp.COD_CATEGORIACOMPPROD " +
                  " left outer join AREAS_EMPRESA ae on ae.COD_AREA_EMPRESA =cp.COD_AREA_EMPRESA " +
                  " where ppr.COD_PROGRAMA_PROD = '"+programaProduccionLotes.getCodProgramaProduccion()+"'  " +
                  " and ppr.COD_COMPPROD = '"+programaProduccionLotes.getFormulaMaestra().getComponentesProd().getCodCompprod()+"'  " +
                  " and ppr.COD_FORMULA_MAESTRA = '"+programaProduccionLotes.getFormulaMaestra().getCodFormulaMaestra()+"'  " +
                  " and ppr.COD_LOTE_PRODUCCION = '"+programaProduccionLotes.getCodLoteProduccion()+"'   ";

            System.out.println("consulta"  + consulta);
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(consulta);
            programaProduccionProductosList.clear();
            while(rs.next()){
                ProgramaProduccion programaProduccion = new ProgramaProduccion();
                programaProduccion.getFormulaMaestra().getComponentesProd().setNombreProdSemiterminado(rs.getString("nombre_prod_semiterminado"));
                programaProduccion.setCodLoteProduccion(rs.getString("COD_LOTE_PRODUCCION"));
                programaProduccion.getTiposProgramaProduccion().setNombreTipoProgramaProd(rs.getString("NOMBRE_TIPO_PROGRAMA_PROD"));
                programaProduccion.getEstadoProgramaProduccion().setNombreEstadoProgramaProd(rs.getString("NOMBRE_ESTADO_PROGRAMA_PROD") );
                programaProduccion.getFormulaMaestra().getComponentesProd().getAreasEmpresa().setNombreAreaEmpresa(rs.getString("NOMBRE_AREA_EMPRESA"));
                programaProduccion.setCantidadLote(rs.getDouble("CANT_LOTE_PRODUCCION"));
                programaProduccionProductosList.add(programaProduccion);
            }
            this.cargarFormulaMaestra("",programaProduccionLotes);
            programaProduccionbean.setCodLoteProduccion(programaProduccionLotes.getCodLoteProduccion());            
            formulaMaestraMPList.clear();
            formulaMaestraEPList.clear();
            formulaMaestraESList.clear();

       } catch (Exception e) {
           e.printStackTrace();
       }
       return null;
   }

    public String getCargarContenidoAgregarProgramaProduccionSimulacion(){
        try 
        {
            lugaresAcondList=this.cargarLugaresAcond();
            this.cargarTiposProgramaProduccionSelect();
            this.cargarFormulaMaestra();
            this.cargarFormulasMaestrasDisponibles();
            programaProduccionbean.setNroLotes(1);
            this.cargarLugaresAcondSelectList();
            programaProduccionAgregarList.clear();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void cargarFormulaMaestra() {
        try {
            setCon(Util.openConnection(getCon()));
            String sql = "select fm.cod_formula_maestra,c.nombre_prod_semiterminado,fm.CANTIDAD_LOTE,c.cod_compprod ";
            sql += " from FORMULA_MAESTRA fm,COMPONENTES_PROD c";
            sql += " where fm.COD_COMPPROD=c.COD_COMPPROD and fm.cod_estado_registro = 1 and c.cod_estado_compprod = 1 and c.cod_tipo_produccion='1'";
            sql += " order by c.nombre_prod_semiterminado ";
            System.out.println("sql " + sql);

            ResultSet rs = null;
            Statement st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            if (!codigo.equals("")) {
            } else {
                formulaMaestraList.clear();
                rs = st.executeQuery(sql);
                formulaMaestraList.add(new SelectItem("0", "Seleccione una Opción"));
                while (rs.next()) {
                    formulaMaestraList.add(new SelectItem(rs.getString(1)+","+rs.getString("cod_compprod"), rs.getString(2) + " " + rs.getString(3)));
                }
            }
            if (rs != null) {
                rs.close();
                st.close();
                rs = null;
                st = null;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public String componenteProdDivLotes(List componenteProdList){
        try {
            String consulta = " select fm1.cod_formula_maestra,c.COD_COMPPROD,c.nombre_prod_semiterminado from COMPONENTES_PROD c" +
                    " inner join PRODUCTOS_DIVISION_LOTES p on p.COD_COMPPROD_DIVISION =c.COD_COMPPROD" +
                    " inner join formula_maestra fm on fm.cod_compprod = p.COD_COMPPROD" +
                    " inner join FORMULA_MAESTRA fm1 on fm1.COD_COMPPROD = p.COD_COMPPROD_DIVISION" +
                    " where fm.cod_formula_maestra = '"+programaProduccionSeleccionado.getFormulaMaestra().getCodFormulaMaestra()+"'" +
                    " and p.COD_TIPO_PROGRAMA_PRODUCCION ='"+programaProduccionSeleccionado.getTiposProgramaProduccion().getCodTipoProgramaProd()+"' ";
            String[] codProducto = programaProduccionbean.getFormulaMaestra().getCodFormulaMaestra().split(",");
            String codFormMaestra = codProducto[0];
            consulta = " select fmx.cod_formula_maestra,p.cod_compprod_division, c.nombre_prod_semiterminado" +
                    " from COMPONENTES_PROD c" +
                    "     inner join PRODUCTOS_DIVISION_LOTES p on p.COD_COMPPROD_DIVISION = c.COD_COMPPROD" +
                    "     inner join formula_maestra fm on fm.cod_compprod = p.COD_COMPPROD and fm.COD_ESTADO_REGISTRO =1" +
                    " cross apply(select top 1 fm1.COD_FORMULA_MAESTRA from FORMULA_MAESTRA fm1 where fm1.COD_COMPPROD = p.COD_COMPPROD_DIVISION  and fm1.COD_ESTADO_REGISTRO=1) fmx" +
                    " where fm.cod_formula_maestra = '"+codFormMaestra+"'" + //programaProduccionbean.getFormulaMaestra().getCodFormulaMaestra()
                    " and p.COD_TIPO_PROGRAMA_PRODUCCION = '"+programaProduccionSeleccionado.getTiposProgramaProduccion().getCodTipoProgramaProd()+"' ";

            System.out.println("consulta " + consulta );
            Connection con = null;
            con = Util.openConnection(con);
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery(consulta);
            componenteProdList.clear();
            componenteProdList.add(new SelectItem("0","-NINGUNO-"));
            componenteProdList.add(new SelectItem(programaProduccionbean.getFormulaMaestra().getCodFormulaMaestra(),programaProduccionbean.getFormulaMaestra().getComponentesProd().getNombreProdSemiterminado()));
            while(rs.next()){
                componenteProdList.add(new SelectItem(rs.getString("cod_formula_maestra")+","+rs.getString("cod_compprod_division"),rs.getString("nombre_prod_semiterminado")));
            }
            programaProduccionSeleccionado.getFormulaMaestra().setCodFormulaMaestra("0");
            rs.close();
            st.close();
            con.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public List cargarLugaresAcond() {
        List lugaresAcondList = new ArrayList();
        try {
            setCon(Util.openConnection(getCon()));
            String sql = "select l.COD_LUGAR_ACOND,l.NOMBRE_LUGAR_ACOND from LUGARES_ACOND l ";
            System.out.println("sql " + sql);

            ResultSet rs = null;
            Statement st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            if (!codigo.equals("")) {
            } else {
                lugaresAcondList.clear();
                rs = st.executeQuery(sql);
                lugaresAcondList.add(new SelectItem("0", "Seleccione una Opción"));
                while (rs.next()) {
                    lugaresAcondList.add(new SelectItem(rs.getString("cod_lugar_acond"), rs.getString("nombre_lugar_acond")));
                }
            }
            if (rs != null) {
                rs.close();
                st.close();
                rs = null;
                st = null;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lugaresAcondList;
    }


    public String formulaMaestra_change1(){
        try {
            programaProduccionAgregarList.clear();
            //cargar los datos por defecto para un producto seleccionado
            ProgramaProduccion programaProduccion = new ProgramaProduccion();
            setCon(Util.openConnection(getCon()));
            String[] codProducto = programaProduccionbean.getFormulaMaestra().getCodFormulaMaestra().split(",");
            String codFormMaestra = codProducto[0];
            String consulta = "select fm.CANTIDAD_LOTE,fm.cod_compprod,cp.nombre_prod_semiterminado,fm.cod_formula_maestra from FORMULA_MAESTRA fm inner join componentes_prod cp on cp.cod_compprod = fm.cod_compprod where fm.COD_FORMULA_MAESTRA = '"+codFormMaestra+"'"; //programaProduccionbean.getFormulaMaestra().getCodFormulaMaestra()
            Statement st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(consulta);
            if(rs.next()){
                programaProduccion.setCantidadLote(rs.getDouble("CANTIDAD_LOTE"));
                programaProduccion.getFormulaMaestra().getComponentesProd().setCodCompprod(rs.getString("cod_compprod"));
                programaProduccion.getFormulaMaestra().getComponentesProd().setNombreProdSemiterminado(rs.getString("nombre_prod_semiterminado"));
                programaProduccion.getFormulaMaestra().setCodFormulaMaestra(rs.getString("cod_formula_maestra"));
            }
            programaProduccion.setTiposProgramaProduccionList(this.cargarTiposProgramaProd());
            programaProduccion.setLugaresAcondList(this.cargarLugaresAcond());
            programaProduccion.getProductosList().clear();
            programaProduccion.getProductosList().add(new SelectItem(programaProduccion.getFormulaMaestra().getCodFormulaMaestra(),programaProduccion.getFormulaMaestra().getComponentesProd().getNombreProdSemiterminado()));
            programaProduccionAgregarList.add(programaProduccion);
            programaProduccionbean.getFormulaMaestra().setCantidadLote(programaProduccion.getCantidadLote());
            programaProduccionbean.getFormulaMaestra().setComponentesProd(programaProduccion.getFormulaMaestra().getComponentesProd());
            programaProduccionbean.getFormulaMaestra().setCodFormulaMaestra(programaProduccion.getFormulaMaestra().getCodFormulaMaestra());
            
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    private void cargarTiposProgramaProduccionSelect()
    {
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select a.COD_TIPO_PROGRAMA_PROD, a.NOMBRE_TIPO_PROGRAMA_PROD");
                                        consulta.append(" from TIPOS_PROGRAMA_PRODUCCION a");
                                        consulta.append(" where a.cod_estado_registro=1");
                                        consulta.append("  order by a.COD_TIPO_PROGRAMA_PROD");
            LOGGER.debug("consulta cargar " + consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            tiposProgramaProdList=new ArrayList<SelectItem>();
            tiposProgramaProdList.add(new SelectItem("0","--TODOS--"));
            while (res.next()) 
            {
                tiposProgramaProdList.add(new SelectItem(res.getString(1), res.getString(2)));
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
    public List cargarTiposProgramaProd() {
        List tiposProgramaProdList = new ArrayList();
        try {
            setCon(Util.openConnection(getCon()));
            String sql = "select a.COD_TIPO_PROGRAMA_PROD, a.NOMBRE_TIPO_PROGRAMA_PROD from TIPOS_PROGRAMA_PRODUCCION a where a.cod_estado_registro=1" +
                    "  order by a.COD_TIPO_PROGRAMA_PROD";
            System.out.println(" sql:" + sql);
            ResultSet rs = null;
            Statement st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            if (!codigo.equals("")) {
            } else {
                tiposProgramaProdList.clear();
                rs = st.executeQuery(sql);
                tiposProgramaProdList.add(new SelectItem("0", "Seleccione una Opción"));
                while (rs.next()) {
                    tiposProgramaProdList.add(new SelectItem(rs.getString(1), rs.getString(2)));
                }
            }
            if (rs != null) {
                rs.close();
                st.close();
                rs = null;
                st = null;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tiposProgramaProdList;
    }
    public FormulaMaestra buscarFormulaMaestra(ProgramaProduccion programaProduccion){
        FormulaMaestra formulaMaestra = new FormulaMaestra();
        try {
            setCon(Util.openConnection(getCon()));
            String consulta = " SELECT COD_FORMULA_MAESTRA, COD_COMPPROD, CANTIDAD_LOTE, ESTADO_SISTEMA, COD_ESTADO_REGISTRO" +
                    " FROM FORMULA_MAESTRA = '"+programaProduccion.getFormulaMaestra().getCodFormulaMaestra()+"' ";
            Statement st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(consulta);
            if(rs.next()){
                formulaMaestra.setCodFormulaMaestra(rs.getString("COD_FORMULA_MAESTRA"));
                formulaMaestra.getComponentesProd().setCodCompprod(rs.getString("COD_COMPPROD"));
                formulaMaestra.setCantidadLote(rs.getDouble("CANTIDAD_LOTE"));
                formulaMaestra.getEstadoRegistro().setCodEstadoRegistro(rs.getString("COD_ESTADO_REGISTRO"));
            }
            st.close();
            rs.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public String masProgramaProduccionEditar_action(){
        if(programaProduccionEditarList.size()>=3){
            return null;
        }
        double sumaCantidadLote = 0;
        for(ProgramaProduccion bean:programaProduccionEditarList)
        {
            sumaCantidadLote+=bean.getCantidadLote();
        }
        ProgramaProduccion nuevo=(ProgramaProduccion)programaProduccionCabeceraEditar.clone();
        nuevo.setCantidadLote(programaProduccionCabeceraEditar.getFormulaMaestra().getCantidadLote()-sumaCantidadLote);
        nuevo.setPresentacionesProductoList(cargarPresentacionesSecundariasSelectList(nuevo));
        programaProduccionEditarList.add(nuevo);
        return null;
    }
    public String agregarProductoTipoProgramaProduccion_action(){
        //System.out.println("entro al evento de producto");
        //agregar un nuevo producto si alcanza
        if(programaProduccionAgregarList.size()>=3){
            return null;
        }

        
        double sumaCantidadLote = 0;
        for(ProgramaProduccion bean:programaProduccionAgregarList)
        {
            sumaCantidadLote+=bean.getCantidadLote();
        }
        ProgramaProduccion nuevo=(ProgramaProduccion)programaProduccionCabeceraAgregar.clone();
        nuevo.setCantidadLote(programaProduccionCabeceraAgregar.getCantidadLote()-sumaCantidadLote);
        nuevo.setPresentacionesProductoList(cargarPresentacionesSecundariasSelectList(nuevo));
        nuevo.getLugaresAcond().setCodLugarAcond(2);
        programaProduccionAgregarList.add(nuevo);
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
    public String tipoProgramaProduccion_change(){
        try {
             programaProduccionSeleccionado = (ProgramaProduccion)programaProduccionAgregarDataTable.getRowData();
             //programaProduccionSeleccionado.getFormulaMaestra().setCodFormulaMaestra(programaProduccionbean.getFormulaMaestra().getCodFormulaMaestra());
             System.out.println("el datos seleccionado ------"  + programaProduccionSeleccionado.getFormulaMaestra().getCodFormulaMaestra());
            
             this.componenteProdDivLotes(programaProduccionSeleccionado.getProductosList());
//            programaProduccionSeleccionado.setFormulaMaestra(programaProduccionbean.getFormulaMaestra());
//            programaProduccionSeleccionado.setFormulaMaestra(this.cargarFormulaMaestra(programaProduccionSeleccionado));
//            programaProduccionSeleccionado.getFormulaMaestra().setFormulaMaestraDetalleMPList(this.cargarFormulaMaestraDetalleMP(programaProduccionSeleccionado));
//            programaProduccionSeleccionado.getFormulaMaestra().setFormulaMaestraDetalleMRList(this.cargarFormulaMaestraDetalleMR(programaProduccionSeleccionado));
//            programaProduccionSeleccionado.getFormulaMaestra().setFormulaMaestraDetalleEPList(this.cargarFormulaMaestraDetalleEP(programaProduccionSeleccionado));
//            programaProduccionSeleccionado.getFormulaMaestra().setFormulaMaestraDetalleESList(this.cargarFormulaMaestraDetalleES(programaProduccionSeleccionado));
            } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public String componenteProd_change(){
            programaProduccionSeleccionado = (ProgramaProduccion)programaProduccionAgregarDataTable.getRowData();
            System.out.println(" dato seleccionado" + programaProduccionSeleccionado.getFormulaMaestra().getCodFormulaMaestra());
            //programaProduccionSeleccionado.setFormulaMaestra(programaProduccionbean.getFormulaMaestra());
            //programaProduccionSeleccionado.setFormulaMaestra(this.cargarFormulaMaestra(programaProduccionSeleccionado));
            programaProduccionSeleccionado.getFormulaMaestra().setFormulaMaestraDetalleMPList(this.cargarFormulaMaestraDetalleMP(programaProduccionSeleccionado));
            programaProduccionSeleccionado.getFormulaMaestra().setFormulaMaestraDetalleMRList(this.cargarFormulaMaestraDetalleMR(programaProduccionSeleccionado));
            programaProduccionSeleccionado.getFormulaMaestra().setFormulaMaestraDetalleEPList(this.cargarFormulaMaestraDetalleEP(programaProduccionSeleccionado));
            programaProduccionSeleccionado.getFormulaMaestra().setFormulaMaestraDetalleESList(this.cargarFormulaMaestraDetalleES(programaProduccionSeleccionado));

            return null;
    }
    public FormulaMaestra cargarFormulaMaestra(ProgramaProduccion programaProduccion){
        FormulaMaestra fm = new FormulaMaestra();
        try {
        fm= programaProduccion.getFormulaMaestra();
        if(programaProduccion.getTiposProgramaProduccion().getCodTipoProgramaProd().equals("3")){
            Connection con = null;
            con = Util.openConnection(con);
            Statement st = con.createStatement();
            String consulta = " select cp.nombre_prod_semiterminado,f.cod_formula_maestra_mc,f.cod_formula_maestra_mm from formula_maestra_relacion f,componentes_prod cp,formula_maestra fm where f.cod_formula_maestra_mm = fm.cod_formula_maestra and fm.cod_compprod = cp.cod_compprod and f.cod_formula_maestra_mc = '"+programaProduccion.getFormulaMaestra().getCodFormulaMaestra()+"'";
            System.out.println("consulta " + consulta );
            ResultSet rs = st.executeQuery(consulta);
            if(rs.next()){
                fm.setCodFormulaMaestra(rs.getString("cod_formula_maestra_mm"));
                fm.getComponentesProd().setNombreProdSemiterminado(rs.getString("nombre_prod_semiterminado"));
            }
        }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return fm;
    }
    public List cargarFormulaMaestraDetalleMP(ProgramaProduccion programaProduccionSeleccionado){
        List formulaMaestraMPList = new ArrayList();
        try {
            Connection con = null;
            String[] codProducto = programaProduccionSeleccionado.getFormulaMaestra().getCodFormulaMaestra().split(",");
            String codFormMaestra = codProducto[0];
            String consulta = " select m.cod_material,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA, mp.CANTIDAD,um.COD_UNIDAD_MEDIDA, m.cod_grupo,fm.cantidad_lote " +
                    " from formula_maestra fm,FORMULA_MAESTRA_DETALLE_MP mp, MATERIALES m, UNIDADES_MEDIDA um " +
                    " where fm.cod_formula_maestra = mp.cod_formula_maestra " +
                    " and m.COD_MATERIAL = mp.cod_material and um.COD_UNIDAD_MEDIDA = m.COD_UNIDAD_MEDIDA " +
                    " and mp.cod_formula_maestra = '"+codFormMaestra+"' " + //programaProduccionSeleccionado.getFormulaMaestra().getCodFormulaMaestra()
                    " order by m.NOMBRE_MATERIAL ";
            System.out.println("consulta " + consulta );
            formulaMaestraMPList.clear();
            con = Util.openConnection(con);
            Statement st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(consulta);
            while(rs.next()){
                FormulaMaestraDetalleMP formulaMaestraDetalleMP = new FormulaMaestraDetalleMP();
                formulaMaestraDetalleMP.getMateriales().setChecked(true);
                formulaMaestraDetalleMP.getMateriales().setCodMaterial(rs.getString("cod_material"));
                formulaMaestraDetalleMP.getMateriales().setNombreMaterial(rs.getString("NOMBRE_MATERIAL"));
                formulaMaestraDetalleMP.getUnidadesMedida().setCodUnidadMedida(rs.getString("COD_UNIDAD_MEDIDA"));
                formulaMaestraDetalleMP.getUnidadesMedida().setNombreUnidadMedida(rs.getString("NOMBRE_UNIDAD_MEDIDA"));
                formulaMaestraDetalleMP.setCantidad(rs.getDouble("CANTIDAD")*programaProduccionSeleccionado.getCantidadLote()/rs.getDouble("cantidad_lote")); //programaProduccionSeleccionado.getFormulaMaestra().getCantidadLote()
                formulaMaestraMPList.add(formulaMaestraDetalleMP);
            }



        } catch (Exception e) {
            e.printStackTrace();
        }
        return formulaMaestraMPList;
    }


     public List cargarFormulaMaestraDetalleMR(ProgramaProduccion programaProduccionSeleccionado){
        List formulaMaestraMPList = new ArrayList();
        try {
            String[] codProducto = programaProduccionSeleccionado.getFormulaMaestra().getCodFormulaMaestra().split(",");
            String codFormMaestra = codProducto[0];
            Connection con = null;
            String consulta = " select m.cod_material,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA,mp.CANTIDAD,um.COD_UNIDAD_MEDIDA,fm.cantidad_lote " +
                    " from formula_maestra fm, FORMULA_MAESTRA_DETALLE_MR mp, MATERIALES m,UNIDADES_MEDIDA um " +
                    " where fm.cod_formula_maestra = mp.cod_formula_maestra and m.COD_MATERIAL = mp.cod_material " +
                    " and um.COD_UNIDAD_MEDIDA = m.COD_UNIDAD_MEDIDA " +
                    " and mp.cod_formula_maestra = '"+codFormMaestra+"' "; //programaProduccionSeleccionado.getFormulaMaestra().getCodFormulaMaestra()

            System.out.println("consulta " + consulta );
            formulaMaestraMPList.clear();
            con = Util.openConnection(con);
            Statement st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(consulta);
            while(rs.next()){

                FormulaMaestraDetalleMP formulaMaestraDetalleMP = new FormulaMaestraDetalleMP();
                formulaMaestraDetalleMP.getMateriales().setChecked(true);
                formulaMaestraDetalleMP.getMateriales().setCodMaterial(rs.getString("cod_material"));
                formulaMaestraDetalleMP.getMateriales().setNombreMaterial(rs.getString("NOMBRE_MATERIAL"));
                formulaMaestraDetalleMP.getUnidadesMedida().setCodUnidadMedida(rs.getString("COD_UNIDAD_MEDIDA"));
                formulaMaestraDetalleMP.getUnidadesMedida().setNombreUnidadMedida(rs.getString("NOMBRE_UNIDAD_MEDIDA"));
                formulaMaestraDetalleMP.setCantidad(rs.getDouble("CANTIDAD")*programaProduccionSeleccionado.getCantidadLote()/rs.getDouble("cantidad_lote")); //programaProduccionSeleccionado.getFormulaMaestra().getCantidadLote()
                formulaMaestraMPList.add(formulaMaestraDetalleMP);
            }



        } catch (Exception e) {
            e.printStackTrace();
        }
        return formulaMaestraMPList;
    }



     public List cargarFormulaMaestraDetalleEP(ProgramaProduccion programaProduccionSeleccionado){
        List formulaMaestraEPList = new ArrayList();
        try {
            String[] codProducto = programaProduccionSeleccionado.getFormulaMaestra().getCodFormulaMaestra().split(",");
            String codFormMaestra = codProducto[0];
            Connection con = null;
            String consulta = " select m.cod_material,  m.NOMBRE_MATERIAL,   um.NOMBRE_UNIDAD_MEDIDA,   mp.CANTIDAD,    um.COD_UNIDAD_MEDIDA" +
                    " from FORMULA_MAESTRA_DETALLE_EP mp,  MATERIALES m,  UNIDADES_MEDIDA um, PROGRAMA_PRODUCCION_PRESENTACIONES pprp " +
                    " where m.COD_MATERIAL = mp.cod_material and  um.COD_UNIDAD_MEDIDA = m.COD_UNIDAD_MEDIDA " +
                    " and  pprp.COD_FORMULA_MAESTRA = mp.COD_FORMULA_MAESTRA " +
                    " and pprp.COD_TIPO_PROGRAMA_PROD = '"+programaProduccionSeleccionado.getTiposProgramaProduccion().getCodTipoProgramaProd()+"' " +
                    " and  mp.cod_formula_maestra = '"+programaProduccionbean.getFormulaMaestra().getCodFormulaMaestra()+"' " +
                    " and  mp.COD_PRESENTACION_PRIMARIA = pprp.COD_PRESENTACION_PRIMARIA  ";
            consulta = " select m.cod_material, m.NOMBRE_MATERIAL, um.NOMBRE_UNIDAD_MEDIDA, mp.CANTIDAD, um.COD_UNIDAD_MEDIDA,fm.cantidad_lote " +
                    " from formula_maestra fm, FORMULA_MAESTRA_DETALLE_EP mp,  MATERIALES m, UNIDADES_MEDIDA um, PRESENTACIONES_PRIMARIAS prp " +
                    " where fm.cod_formula_maestra = mp.cod_formula_maestra and m.COD_MATERIAL = mp.cod_material " +
                    " and um.COD_UNIDAD_MEDIDA = m.COD_UNIDAD_MEDIDA " +
                    " and prp.COD_PRESENTACION_PRIMARIA = mp.COD_PRESENTACION_PRIMARIA " +
                    " and prp.COD_TIPO_PROGRAMA_PROD = '"+programaProduccionSeleccionado.getTiposProgramaProduccion().getCodTipoProgramaProd()+"' " +
                    " and mp.cod_formula_maestra = '"+codFormMaestra+"' " + //programaProduccionSeleccionado.getFormulaMaestra().getCodFormulaMaestra()
                    " and prp.COD_ESTADO_REGISTRO = 1 ";




            System.out.println("consulta " + consulta );
            formulaMaestraEPList.clear();
            con = Util.openConnection(con);
            Statement st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(consulta);
            while(rs.next()){

                FormulaMaestraDetalleMP formulaMaestraDetalleMP = new FormulaMaestraDetalleMP();
                formulaMaestraDetalleMP.getMateriales().setChecked(true);
                formulaMaestraDetalleMP.getMateriales().setCodMaterial(rs.getString("cod_material"));
                formulaMaestraDetalleMP.getMateriales().setNombreMaterial(rs.getString("NOMBRE_MATERIAL"));
                formulaMaestraDetalleMP.getUnidadesMedida().setCodUnidadMedida(rs.getString("COD_UNIDAD_MEDIDA"));
                formulaMaestraDetalleMP.getUnidadesMedida().setNombreUnidadMedida(rs.getString("NOMBRE_UNIDAD_MEDIDA"));
                formulaMaestraDetalleMP.setCantidad(rs.getDouble("CANTIDAD")*programaProduccionSeleccionado.getCantidadLote()/rs.getDouble("cantidad_lote")); //programaProduccionbean.getFormulaMaestra().getCantidadLote()
                formulaMaestraEPList.add(formulaMaestraDetalleMP);
            }



        } catch (Exception e) {
            e.printStackTrace();
        }
        return formulaMaestraEPList;
    }
    public List cargarFormulaMaestraDetalleES(ProgramaProduccion programaProduccionSeleccionado){
        List formulaMaestraESList = new ArrayList();
        try {
            String[] codProducto = programaProduccionSeleccionado.getFormulaMaestra().getCodFormulaMaestra().split(",");
            String codFormMaestra = codProducto[0];
            Connection con = null;
            String consulta = " select m.cod_material, m.NOMBRE_MATERIAL, um.NOMBRE_UNIDAD_MEDIDA, mp.CANTIDAD, um.COD_UNIDAD_MEDIDA " +
                    "from FORMULA_MAESTRA_DETALLE_ES mp, MATERIALES m, UNIDADES_MEDIDA um,PROGRAMA_PRODUCCION_PRESENTACIONES pprpr " +
                    " where m.COD_MATERIAL = mp.cod_material and   um.COD_UNIDAD_MEDIDA = m.COD_UNIDAD_MEDIDA " +
                    " and pprpr.COD_FORMULA_MAESTRA = mp.COD_FORMULA_MAESTRA " +
                    " and  pprpr.COD_TIPO_PROGRAMA_PROD = '"+programaProduccionSeleccionado.getTiposProgramaProduccion().getCodTipoProgramaProd()+"'  " +
                    " and  mp.cod_formula_maestra = '"+programaProduccionbean.getFormulaMaestra().getCodFormulaMaestra()+"' " +
                    " and mp.COD_PRESENTACION_PRODUCTO = pprpr.COD_PRESENTACION_PRODUCTO ";
            consulta = " select m.cod_material,  m.NOMBRE_MATERIAL,   um.NOMBRE_UNIDAD_MEDIDA,  mp.CANTIDAD,  um.COD_UNIDAD_MEDIDA " +
                    " from FORMULA_MAESTRA_DETALLE_ES mp, MATERIALES m, UNIDADES_MEDIDA um,  PRESENTACIONES_PRODUCTO ppr  " +
                    " where m.COD_MATERIAL = mp.cod_material and  um.COD_UNIDAD_MEDIDA = m.COD_UNIDAD_MEDIDA " +
                    " and ppr.cod_presentacion = mp.COD_PRESENTACION_PRODUCTO " +
                    " and ppr.COD_TIPO_PROGRAMA_PROD =  '"+programaProduccionSeleccionado.getTiposProgramaProduccion().getCodTipoProgramaProd()+"' " +
                    " and mp.cod_formula_maestra = '"+programaProduccionbean.getFormulaMaestra().getCodFormulaMaestra()+"'  ";

            consulta = " select m.cod_material, m.NOMBRE_MATERIAL, u.NOMBRE_UNIDAD_MEDIDA, fmdes.CANTIDAD," +
                    " u.COD_UNIDAD_MEDIDA,fm.cantidad_lote from COMPONENTES_PRESPROD c inner join COMPONENTES_PROD cp" +
                    " on cp.COD_COMPPROD = c.COD_COMPPROD " +
                    " inner join PRESENTACIONES_PRODUCTO prp on prp.cod_presentacion = c.COD_PRESENTACION " +
                    " inner join FORMULA_MAESTRA fm on fm.COD_COMPPROD = c.COD_COMPPROD " +
                    " inner join FORMULA_MAESTRA_DETALLE_ES fmdes on fmdes.COD_FORMULA_MAESTRA = fm.COD_FORMULA_MAESTRA " +
                    " and fmdes.COD_PRESENTACION_PRODUCTO = prp.cod_presentacion " +
                    " inner join materiales m on m.COD_MATERIAL = fmdes.COD_MATERIAL " +
                    " inner join UNIDADES_MEDIDA u on u.COD_UNIDAD_MEDIDA =fmdes.COD_UNIDAD_MEDIDA " +
                    " where prp.cod_estado_registro = 1 " +
                    " and c.COD_ESTADO_REGISTRO = 1 and c.COD_TIPO_PROGRAMA_PROD = '"+programaProduccionSeleccionado.getTiposProgramaProduccion().getCodTipoProgramaProd()+"' " +
                    " and fm.COD_FORMULA_MAESTRA = '"+codFormMaestra+"'  "; //programaProduccionSeleccionado.getFormulaMaestra().getCodFormulaMaestra()
            System.out.println("consulta " + consulta );
            formulaMaestraESList.clear();
            con = Util.openConnection(con);
            Statement st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(consulta);
            while(rs.next()){


                FormulaMaestraDetalleMP formulaMaestraDetalleMP = new FormulaMaestraDetalleMP();
                formulaMaestraDetalleMP.getMateriales().setChecked(true);
                formulaMaestraDetalleMP.getMateriales().setCodMaterial(rs.getString("cod_material"));
                formulaMaestraDetalleMP.getMateriales().setNombreMaterial(rs.getString("NOMBRE_MATERIAL"));
                formulaMaestraDetalleMP.getUnidadesMedida().setCodUnidadMedida(rs.getString("COD_UNIDAD_MEDIDA"));
                formulaMaestraDetalleMP.getUnidadesMedida().setNombreUnidadMedida(rs.getString("NOMBRE_UNIDAD_MEDIDA"));
                formulaMaestraDetalleMP.setCantidad(rs.getDouble("CANTIDAD")*programaProduccionSeleccionado.getCantidadLote()/rs.getDouble("cantidad_lote")); //programaProduccionbean.getFormulaMaestra().getCantidadLote()
                formulaMaestraESList.add(formulaMaestraDetalleMP);



            }



        } catch (Exception e) {
            e.printStackTrace();
        }
        return formulaMaestraESList;
    }


     
    
    public String verFormulaMaestraDetalleMP_action(){
        try {
        programaProduccionSeleccionado = (ProgramaProduccion)programaProduccionAgregarDataTable.getRowData();
        formulaMaestraMPList = programaProduccionSeleccionado.getFormulaMaestra().getFormulaMaestraDetalleMPList();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public String verFormulaMaestraDetalleMR_action(){
        programaProduccionSeleccionado = (ProgramaProduccion)programaProduccionAgregarDataTable.getRowData();
        formulaMaestraMRList = programaProduccionSeleccionado.getFormulaMaestra().getFormulaMaestraDetalleMRList();
        return null;
    }
    public String verFormulaMaestraDetalleEP_action(){
        programaProduccionSeleccionado = (ProgramaProduccion)programaProduccionAgregarDataTable.getRowData();
        formulaMaestraEPList = programaProduccionSeleccionado.getFormulaMaestra().getFormulaMaestraDetalleEPList();
        return null;
    }
    public String verFormulaMaestraDetalleES_action(){
        programaProduccionSeleccionado = (ProgramaProduccion)programaProduccionAgregarDataTable.getRowData();
        formulaMaestraESList = programaProduccionSeleccionado.getFormulaMaestra().getFormulaMaestraDetalleESList();
        return null;
    }

       public String obtenerLoteProgramaProduccion(){
        String codLoteProgramaProduccion = "0";
        try {
            Connection con = null;
            String consulta = " select isnull(max(cast( ppr1.COD_LOTE_PRODUCCION as int)),0) +1 lote_produccion from PROGRAMA_PRODUCCION ppr1 where ppr1.COD_PROGRAMA_PROD= '"+programaProduccionbean.getCodProgramaProduccion()+"' ";
            System.out.println("consulta " + consulta );            
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(consulta);
            if(rs.next()){
                codLoteProgramaProduccion = rs.getString("lote_produccion");
            }
            rs.close();
            st.close();
            con.close();
            

        } catch (Exception e) {
            e.printStackTrace();
        }
        return codLoteProgramaProduccion;
    }

    public String guardarEdicionProgramaProduccion_action()throws SQLException
    {
        mensaje="";
        try {
            con=Util.openConnection(con);
            con.setAutoCommit(false);
            String consulta="delete from PROGRAMA_PRODUCCION  where COD_PROGRAMA_PROD='"+programaProduccionCabeceraEditar.getCodProgramaProduccion()+"'" +
                            " and COD_LOTE_PRODUCCION='"+programaProduccionCabeceraEditar.getCodLoteProduccion()+"'";
            LOGGER.debug("consulta delete programa produccion "+consulta);
            PreparedStatement pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)LOGGER.info("se elimino el programa de producion antes de guardar edicion");
            consulta="delete from PROGRAMA_PRODUCCION_DETALLE where COD_PROGRAMA_PROD='"+programaProduccionCabeceraEditar.getCodProgramaProduccion()+"'" +
                    " and COD_LOTE_PRODUCCION='"+programaProduccionCabeceraEditar.getCodLoteProduccion()+"'";
            LOGGER.debug("consulta delete detalle programa produccion "+consulta);
            pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)LOGGER.info("se eliminaron los detalles antes del la edicion");
            for(ProgramaProduccion bean:programaProduccionEditarList)
            {
                    consulta = " insert into programa_produccion(cod_programa_prod,cod_formula_maestra,cod_lote_produccion, " +
                            " cod_estado_programa,OBSERVACION,CANT_LOTE_PRODUCCION,VERSION_LOTE,COD_COMPPROD,COD_TIPO_PROGRAMA_PROD,COD_PRESENTACION,nro_lotes," +
                            "cod_lugar_acond,COD_COMPPROD_PADRE)" +
                            " values('"+programaProduccionCabeceraEditar.getCodProgramaProduccion()+"','"+bean.getFormulaMaestra().getCodFormulaMaestra() +"'," +
                            "'"+programaProduccionCabeceraEditar.getCodLoteProduccion()+"',4," +
                            "?,'"+bean.getCantidadLote()+"',1, " +
                            "'"+bean.getFormulaMaestra().getComponentesProd().getCodCompprod()+"','"+bean.getTiposProgramaProduccion().getCodTipoProgramaProd()+"', " +
                            " '"+bean.getPresentacionesProducto().getCodPresentacion()+"',1,"+bean.getLugaresAcond().getCodLugarAcond()+",'"+programaProduccionCabeceraEditar.getFormulaMaestra().getComponentesProd().getCodCompprod()+"')";
                    LOGGER.debug("consulta insertar lote simulacion "+consulta);
                    pst=con.prepareStatement(consulta);
                    pst.setString(1,bean.getObservacion());
                    if(pst.executeUpdate()>0)LOGGER.info("se registro el lote de simulacion");

                    Double prorateo=(bean.getCantidadLote()/bean.getFormulaMaestra().getCantidadLote());
                    consulta="INSERT INTO PROGRAMA_PRODUCCION_DETALLE(COD_PROGRAMA_PROD, COD_COMPPROD,"+
                             " COD_MATERIAL, COD_UNIDAD_MEDIDA, CANTIDAD, COD_LOTE_PRODUCCION,"+
                             " COD_TIPO_PROGRAMA_PROD, COD_TIPO_MATERIAL, COD_ESTADO_REGISTRO)"+
                             " select '"+programaProduccionCabeceraEditar.getCodProgramaProduccion()+"'," +
                             "'"+bean.getFormulaMaestra().getComponentesProd().getCodCompprod()+"'," +
                             "f.COD_MATERIAL,f.COD_UNIDAD_MEDIDA,(f.CANTIDAD*"+prorateo+"),"+
                             "'"+programaProduccionCabeceraEditar.getCodLoteProduccion()+"','"+bean.getTiposProgramaProduccion().getCodTipoProgramaProd()+"',1,1"+
                             " from FORMULA_MAESTRA_DETALLE_MP f where f.COD_FORMULA_MAESTRA='"+bean.getFormulaMaestra().getCodFormulaMaestra()+"'";
                    LOGGER.debug("consulta insertar copia de mp materiales "+consulta);
                    pst=con.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)LOGGER.info("se guardo la materia prima");
                    consulta="INSERT INTO PROGRAMA_PRODUCCION_DETALLE(COD_PROGRAMA_PROD, COD_COMPPROD,"+
                             " COD_MATERIAL, COD_UNIDAD_MEDIDA, CANTIDAD, COD_LOTE_PRODUCCION,"+
                             " COD_TIPO_PROGRAMA_PROD, COD_TIPO_MATERIAL, COD_ESTADO_REGISTRO)"+
                             " select '"+programaProduccionCabeceraEditar.getCodProgramaProduccion()+"'," +
                             "'"+bean.getFormulaMaestra().getComponentesProd().getCodCompprod()+"'," +
                             " f.COD_MATERIAL,f.COD_UNIDAD_MEDIDA,(f.CANTIDAD*"+prorateo+"),"+
                             " '"+programaProduccionCabeceraEditar.getCodLoteProduccion()+"','"+bean.getTiposProgramaProduccion().getCodTipoProgramaProd()+"',2,1"+
                             " from FORMULA_MAESTRA_DETALLE_EP f"+
                             " inner join FORMULA_MAESTRA ff on ff.COD_FORMULA_MAESTRA=f.COD_FORMULA_MAESTRA"+
                             " inner join PRESENTACIONES_PRIMARIAS ppv on ppv.COD_PRESENTACION_PRIMARIA=f.COD_PRESENTACION_PRIMARIA"+
                             " and ppv.COD_COMPPROD=ff.COD_COMPPROD"+
                             " where ppv.COD_ESTADO_REGISTRO=1"+
                             " and f.COD_FORMULA_MAESTRA='"+bean.getFormulaMaestra().getCodFormulaMaestra()+"'"+
                             " and ppv.COD_TIPO_PROGRAMA_PROD='"+bean.getTiposProgramaProduccion().getCodTipoProgramaProd()+"'";
                    LOGGER.debug("consulta insertar copia ep materiales "+consulta);
                    pst=con.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)LOGGER.info("se inserto el empaque primario");
                    consulta="INSERT INTO PROGRAMA_PRODUCCION_DETALLE(COD_PROGRAMA_PROD, COD_COMPPROD,"+
                             " COD_MATERIAL, COD_UNIDAD_MEDIDA, CANTIDAD, COD_LOTE_PRODUCCION,"+
                             " COD_TIPO_PROGRAMA_PROD, COD_TIPO_MATERIAL, COD_ESTADO_REGISTRO)"+
                             " select '"+programaProduccionCabeceraEditar.getCodProgramaProduccion()+"'," +
                             "'"+bean.getFormulaMaestra().getComponentesProd().getCodCompprod()+"'," +
                             " f.COD_MATERIAL,f.COD_UNIDAD_MEDIDA,(f.CANTIDAD*"+prorateo+"),"+
                             " '"+programaProduccionCabeceraEditar.getCodLoteProduccion()+"','"+bean.getTiposProgramaProduccion().getCodTipoProgramaProd()+"',4,1"+
                             " from FORMULA_MAESTRA_DETALLE_MR f"+
                             " where f.COD_FORMULA_MAESTRA='"+bean.getFormulaMaestra().getCodFormulaMaestra()+"'";
                    LOGGER.debug("consulta insert copia mr "+consulta);
                    pst=con.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)LOGGER.info("se inserto el material reactivo");
                     consulta="INSERT INTO PROGRAMA_PRODUCCION_DETALLE(COD_PROGRAMA_PROD, COD_COMPPROD,"+
                             " COD_MATERIAL, COD_UNIDAD_MEDIDA, CANTIDAD, COD_LOTE_PRODUCCION,"+
                             " COD_TIPO_PROGRAMA_PROD, COD_TIPO_MATERIAL, COD_ESTADO_REGISTRO)"+
                             " select '"+programaProduccionCabeceraEditar.getCodProgramaProduccion()+"'," +
                             "'"+bean.getFormulaMaestra().getComponentesProd().getCodCompprod()+"'," +
                             " f.COD_MATERIAL,f.COD_UNIDAD_MEDIDA,ceiling(f.CANTIDAD*"+prorateo+"),"+
                             " '"+programaProduccionCabeceraEditar.getCodLoteProduccion()+"','"+bean.getTiposProgramaProduccion().getCodTipoProgramaProd()+"',3,1" +
                             " from FORMULA_MAESTRA_DETALLE_ES f inner join COMPONENTES_PRESPROD cp on" +
                             " cp.COD_PRESENTACION=f.COD_PRESENTACION_PRODUCTO and cp.COD_TIPO_PROGRAMA_PROD=f.COD_TIPO_PROGRAMA_PROD" +
                             " where f.COD_FORMULA_MAESTRA = '"+bean.getFormulaMaestra().getCodFormulaMaestra()+"' and"+
                             " f.COD_TIPO_PROGRAMA_PROD = '"+bean.getTiposProgramaProduccion().getCodTipoProgramaProd()+"'"+
                             " and cp.COD_ESTADO_REGISTRO=1 and cp.COD_COMPPROD='"+bean.getFormulaMaestra().getComponentesProd().getCodCompprod()+"'"
                             + " AND f.COD_PRESENTACION_PRODUCTO='"+bean.getPresentacionesProducto().getCodPresentacion()+"'";
                     LOGGER.debug("consulta registra material es "+consulta);
                     pst=con.prepareStatement(consulta);
                     if(pst.executeUpdate()>0)LOGGER.info("se inserto el material secundario");
                }
            con.commit();
            mensaje="1";
            pst.close();
            con.close();
        }
        catch (SQLException ex)
        {
            con.rollback();
            con.close();
            mensaje="Ocurrio un error al momento de guardar la edicion de los lotes, intente de nuevo";
            LOGGER.warn("error", ex);
        }

        return null;
    }

    public String guardarProgramaProduccion_action()throws SQLException
    {
        mensaje="";
        String codLoteProd = "-";
        
        try {
            con=Util.openConnection(con);
            con.setAutoCommit(false);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=null;
            PreparedStatement pst=null;
            String consulta="";
            for(int i=0;i<programaProduccionCabeceraAgregar.getNroLotes();i++)
            {
                consulta=" select isnull(max(cast( ppr1.COD_LOTE_PRODUCCION as int)),0) +1 lote_produccion from PROGRAMA_PRODUCCION ppr1 where ppr1.COD_PROGRAMA_PROD= '"+programaProduccionbean.getCodProgramaProduccion()+"'";
                res=st.executeQuery(consulta);
                if(res.next())codLoteProd=res.getString("lote_produccion");
                for(ProgramaProduccion bean:programaProduccionAgregarList)
                {
                    consulta = " insert into programa_produccion(cod_programa_prod,cod_formula_maestra,cod_lote_produccion, " +
                            " cod_estado_programa,observacion,CANT_LOTE_PRODUCCION,VERSION_LOTE,COD_COMPPROD,COD_TIPO_PROGRAMA_PROD,COD_PRESENTACION,nro_lotes,cod_lugar_acond,COD_COMPPROD_PADRE)" +
                            " values('"+programaProduccionbean.getCodProgramaProduccion()+"','"+bean.getFormulaMaestra().getCodFormulaMaestra() +"'," + 
                            "'"+codLoteProd+"',4," +
                            "?,'"+bean.getCantidadLote()+"',1, " +
                            "'"+bean.getFormulaMaestra().getComponentesProd().getCodCompprod()+"','"+bean.getTiposProgramaProduccion().getCodTipoProgramaProd()+"', " +
                            " '"+bean.getPresentacionesProducto().getCodPresentacion()+"',1,"+bean.getLugaresAcond().getCodLugarAcond()+",'"+programaProduccionCabeceraAgregar.getFormulaMaestra().getComponentesProd().getCodCompprod()+"')";
                    LOGGER.debug("consulta insertar lote simulacion "+consulta);
                    pst=con.prepareStatement(consulta);
                    pst.setString(1,bean.getObservacion());
                    if(pst.executeUpdate()>0)LOGGER.info("se registro el lote de simulacion");

                    Double prorateo=(bean.getCantidadLote()/bean.getFormulaMaestra().getCantidadLote());
                    consulta="INSERT INTO PROGRAMA_PRODUCCION_DETALLE(COD_PROGRAMA_PROD, COD_COMPPROD,"+
                             " COD_MATERIAL, COD_UNIDAD_MEDIDA, CANTIDAD, COD_LOTE_PRODUCCION,"+
                             " COD_TIPO_PROGRAMA_PROD, COD_TIPO_MATERIAL, COD_ESTADO_REGISTRO)"+
                             " select '"+programaProduccionbean.getCodProgramaProduccion()+"'," +
                             "'"+bean.getFormulaMaestra().getComponentesProd().getCodCompprod()+"'," +
                             "f.COD_MATERIAL,f.COD_UNIDAD_MEDIDA,(f.CANTIDAD*"+prorateo+"),"+
                             "'"+codLoteProd+"','"+bean.getTiposProgramaProduccion().getCodTipoProgramaProd()+"',1,1"+
                             " from FORMULA_MAESTRA_DETALLE_MP f where f.COD_FORMULA_MAESTRA='"+bean.getFormulaMaestra().getCodFormulaMaestra()+"'";
                    LOGGER.debug("consulta insertar copia de mp materiales "+consulta);
                    pst=con.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)LOGGER.info("se guardo la materia prima");
                    consulta="INSERT INTO PROGRAMA_PRODUCCION_DETALLE(COD_PROGRAMA_PROD, COD_COMPPROD,"+
                             " COD_MATERIAL, COD_UNIDAD_MEDIDA, CANTIDAD, COD_LOTE_PRODUCCION,"+
                             " COD_TIPO_PROGRAMA_PROD, COD_TIPO_MATERIAL, COD_ESTADO_REGISTRO)"+
                             " select '"+programaProduccionbean.getCodProgramaProduccion()+"'," +
                             "'"+bean.getFormulaMaestra().getComponentesProd().getCodCompprod()+"'," +
                             " f.COD_MATERIAL,f.COD_UNIDAD_MEDIDA,(f.CANTIDAD*"+prorateo+"),"+
                             " '"+codLoteProd+"','"+bean.getTiposProgramaProduccion().getCodTipoProgramaProd()+"',2,1"+
                             " from FORMULA_MAESTRA_DETALLE_EP f"+
                             " inner join FORMULA_MAESTRA ff on ff.COD_FORMULA_MAESTRA=f.COD_FORMULA_MAESTRA"+
                             " inner join PRESENTACIONES_PRIMARIAS ppv on ppv.COD_PRESENTACION_PRIMARIA=f.COD_PRESENTACION_PRIMARIA"+
                             " and ff.COD_COMPPROD=ppv.COD_COMPPROD"+
                             " where ppv.COD_ESTADO_REGISTRO=1"+
                             " and f.COD_FORMULA_MAESTRA='"+bean.getFormulaMaestra().getCodFormulaMaestra()+"'"+
                             " and ppv.COD_TIPO_PROGRAMA_PROD='"+bean.getTiposProgramaProduccion().getCodTipoProgramaProd()+"'";
                    LOGGER.debug("consulta insertar copia ep materiales "+consulta);
                    pst=con.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)LOGGER.info("se inserto el empaque primario");
                    consulta="INSERT INTO PROGRAMA_PRODUCCION_DETALLE(COD_PROGRAMA_PROD, COD_COMPPROD,"+
                             " COD_MATERIAL, COD_UNIDAD_MEDIDA, CANTIDAD, COD_LOTE_PRODUCCION,"+
                             " COD_TIPO_PROGRAMA_PROD, COD_TIPO_MATERIAL, COD_ESTADO_REGISTRO)"+
                             " select '"+programaProduccionbean.getCodProgramaProduccion()+"'," +
                             "'"+bean.getFormulaMaestra().getComponentesProd().getCodCompprod()+"'," +
                             " f.COD_MATERIAL,f.COD_UNIDAD_MEDIDA,(f.CANTIDAD*"+prorateo+"),"+
                             " '"+codLoteProd+"','"+bean.getTiposProgramaProduccion().getCodTipoProgramaProd()+"',4,1"+
                             " from FORMULA_MAESTRA_DETALLE_MR f"+
                             " where f.COD_FORMULA_MAESTRA='"+bean.getFormulaMaestra().getCodFormulaMaestra()+"'";
                    LOGGER.debug("consulta insert copia mr "+consulta);
                    pst=con.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)LOGGER.info("se inserto el material reactivo");
                     consulta="INSERT INTO PROGRAMA_PRODUCCION_DETALLE(COD_PROGRAMA_PROD, COD_COMPPROD,"+
                             " COD_MATERIAL, COD_UNIDAD_MEDIDA, CANTIDAD, COD_LOTE_PRODUCCION,"+
                             " COD_TIPO_PROGRAMA_PROD, COD_TIPO_MATERIAL, COD_ESTADO_REGISTRO)"+
                             " select '"+programaProduccionbean.getCodProgramaProduccion()+"'," +
                             "'"+bean.getFormulaMaestra().getComponentesProd().getCodCompprod()+"'," +
                             " f.COD_MATERIAL,f.COD_UNIDAD_MEDIDA,CEILING(f.CANTIDAD*"+prorateo+"),"+
                             " '"+codLoteProd+"','"+bean.getTiposProgramaProduccion().getCodTipoProgramaProd()+"',3,1" +
                             " from FORMULA_MAESTRA_DETALLE_ES f inner join COMPONENTES_PRESPROD cp on" +
                             " cp.COD_PRESENTACION=f.COD_PRESENTACION_PRODUCTO and cp.COD_TIPO_PROGRAMA_PROD=f.COD_TIPO_PROGRAMA_PROD" +
                             " where f.COD_FORMULA_MAESTRA = '"+bean.getFormulaMaestra().getCodFormulaMaestra()+"' and"+
                             " f.COD_TIPO_PROGRAMA_PROD = '"+bean.getTiposProgramaProduccion().getCodTipoProgramaProd()+"'"+
                             " and cp.COD_ESTADO_REGISTRO=1 and cp.COD_COMPPROD='"+bean.getFormulaMaestra().getComponentesProd().getCodCompprod()+"'"+
                             " and f.COD_PRESENTACION_PRODUCTO='"+bean.getPresentacionesProducto().getCodPresentacion()+"'";
                     LOGGER.debug("consulta registra material es "+consulta);
                     pst=con.prepareStatement(consulta);
                     if(pst.executeUpdate()>0)LOGGER.info("se inserto el material secundario");
                }
                
            }
            con.commit();
            mensaje="1";
            if(res!=null)res.close();;
            if(pst!=null)pst.close();
            st.close();
            con.close();
        } 
        catch (SQLException ex)
        {
            con.rollback();
            con.close();
            mensaje="Ocurrio un error al momento de guardar los lotes, intente de nuevo";
            LOGGER.warn("error", ex);
        }
        
        return null;
    }
    public String eliminarProgramaProduccion_action1(){
        try {
            Connection con = null;
            con = Util.openConnection(con);
            Statement st = con.createStatement();
            Iterator i = programaProduccionList.iterator();

            while(i.hasNext()){
                ProgramaProduccion programaProduccion = (ProgramaProduccion)i.next();
            //programaProduccionbean.getEstadoProgramaProduccion().setCodEstadoProgramaProd("4"); //estado de simulacion
            //programaProduccionbean.setVersionLote("1"); //version de lote
                if(programaProduccion.getChecked().booleanValue()==true){

                    String consulta = " delete from programa_produccion where cod_programa_prod = '"+programaProduccion.getCodProgramaProduccion()+"' " +
                            " and cod_compprod ='"+programaProduccion.getFormulaMaestra().getComponentesProd().getCodCompprod()+"' " +
                            " and cod_formula_maestra = '"+programaProduccion.getFormulaMaestra().getCodFormulaMaestra() +"' " +
                            " and cod_lote_produccion = '"+programaProduccion.getCodLoteProduccion()+"' ";
                    System.out.println("consulta " + consulta );
                    st.executeUpdate(consulta);
                    consulta = " delete from programa_produccion_detalle " +
                            " where cod_programa_prod = '"+programaProduccion.getCodProgramaProduccion()+"' " +
                            " and cod_compprod ='"+programaProduccion.getFormulaMaestra().getComponentesProd().getCodCompprod()+"' " +
                            " and cod_lote_produccion = '"+programaProduccion.getCodLoteProduccion()+"' ";
                    System.out.println("consulta " + consulta);
                    st.executeUpdate(consulta);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public String limpiar_action(){
        programaProduccionAgregarList.clear();
        this.formulaMaestra_change1();
        return null;
    }
    public String editarProgramaProduccion_action1(){
        try {
            
            this.redireccionar("editar_programa_produccion1.jsf");
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public List cargarProgramaProduccionDetalle(ProgramaProduccion programaProduccion,String nombreTabla){
        List formulaMaestraDetalleList = new ArrayList();
        try {
            Connection con  = null;
            con =Util.openConnection(con);
            String consulta = " select distinct m.COD_MATERIAL,m.NOMBRE_MATERIAL,pprd.CANTIDAD,um.COD_UNIDAD_MEDIDA,um.NOMBRE_UNIDAD_MEDIDA  " +
                    " from programa_produccion_detalle pprd " +
                    " inner join FORMULA_MAESTRA_DETALLE_"+nombreTabla+" fmdmp on fmdmp.COD_MATERIAL = pprd.COD_MATERIAL " +
                    " inner join FORMULA_MAESTRA fm on fm.COD_FORMULA_MAESTRA = fmdmp.COD_FORMULA_MAESTRA " +
                    " and fm.COD_COMPPROD = pprd.COD_COMPPROD " +
                    " inner join materiales m on m.COD_MATERIAL = pprd.COD_MATERIAL " +
                    " inner join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA = pprd.COD_UNIDAD_MEDIDA " +
                    " where pprd.COD_PROGRAMA_PROD = '"+programaProduccion.getCodProgramaProduccion()+"'" +
                    " and pprd.COD_COMPPROD = '"+programaProduccion.getFormulaMaestra().getComponentesProd().getCodCompprod() +"' " +
                    " and pprd.COD_TIPO_PROGRAMA_PROD = '"+programaProduccion.getTiposProgramaProduccion().getCodTipoProgramaProd()+"' " +
                    " and pprd.COD_LOTE_PRODUCCION = '"+programaProduccion.getCodLoteProduccion()+"' ";
            System.out.println("consulta" + consulta);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(consulta);
            while(rs.next()){
                FormulaMaestraDetalleMP formulaMaestraDetalleMP = new FormulaMaestraDetalleMP();
                formulaMaestraDetalleMP.getMateriales().setCodMaterial(rs.getString("COD_MATERIAL"));
                formulaMaestraDetalleMP.getMateriales().setNombreMaterial(rs.getString("NOMBRE_MATERIAL"));
                formulaMaestraDetalleMP.setCantidad(rs.getDouble("CANTIDAD"));
                formulaMaestraDetalleMP.getUnidadesMedida().setCodUnidadMedida(rs.getString("COD_UNIDAD_MEDIDA"));
                formulaMaestraDetalleMP.getUnidadesMedida().setNombreUnidadMedida(rs.getString("NOMBRE_UNIDAD_MEDIDA"));
                formulaMaestraDetalleList.add(formulaMaestraDetalleMP);
            }
            st.close();
            rs.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return formulaMaestraDetalleList;
    }
      public String guardarEditarProgramaProduccion_action() {
        //System.out.println("formulaMaestraEPList******************:"+formulaMaestraEPList.size());
        Connection con = null;        
        try {
            con = Util.openConnection(con);
            Statement st = con.createStatement();
            //programaProduccionbean.getEstadoProgramaProduccion().setCodEstadoProgramaProd("4"); //estado de simulacion
            programaProduccionbean.setVersionLote("1"); //version de lote
            String consulta = " delete from programa_produccion where cod_programa_prod = '"+programaProduccionbean.getCodProgramaProduccion()+"' " +
                    " and cod_compprod ='"+programaProduccionbean.getFormulaMaestra().getComponentesProd().getCodCompprod()+"' " +
                    " and cod_formula_maestra = '"+programaProduccionbean.getFormulaMaestra().getCodFormulaMaestra() +"' " +
                    " and cod_lote_produccion = '"+programaProduccionbean.getCodLoteProduccion()+"' ";
            System.out.println("consulta " + consulta );
            st.executeUpdate(consulta);
            consulta = " delete from programa_produccion_detalle " +
                    " where cod_programa_prod = '"+programaProduccionbean.getCodProgramaProduccion()+"' " +
                    " and cod_compprod ='"+programaProduccionbean.getFormulaMaestra().getComponentesProd().getCodCompprod()+"' " +                    
                    " and cod_lote_produccion = '"+programaProduccionbean.getCodLoteProduccion()+"' ";
            System.out.println("consulta " + consulta);
            st.executeUpdate(consulta);

            // la iteracion para productos enteros
            for(int lotes = 1 ;lotes<= programaProduccionbean.getNroLotes();lotes++){                
            Iterator i = programaProduccionAgregarList.iterator();
            
                    //programaProduccionbean.setCodLoteProduccion(this.obtenerLoteProgramaProduccion());
                    while(i.hasNext()){
                        ProgramaProduccion programaProduccion =(ProgramaProduccion) i.next();
                        consulta = " insert into programa_produccion(cod_programa_prod,cod_formula_maestra,cod_lote_produccion, " +
                            " cod_estado_programa,observacion,CANT_LOTE_PRODUCCION,VERSION_LOTE,COD_COMPPROD,COD_TIPO_PROGRAMA_PROD,COD_PRESENTACION,nro_lotes)" +
                            " values('"+programaProduccionbean.getCodProgramaProduccion()+"','"+programaProduccionbean.getFormulaMaestra().getCodFormulaMaestra() +"'," +
                            "'"+programaProduccionbean.getCodLoteProduccion()+"','"+programaProduccionbean.getEstadoProgramaProduccion().getCodEstadoProgramaProd()+"'," +
                            "'"+programaProduccion.getObservacion()+"','"+programaProduccion.getCantidadLote()+"','"+programaProduccionbean.getVersionLote()+"', " +
                            "'"+programaProduccionbean.getFormulaMaestra().getComponentesProd().getCodCompprod()+"','"+programaProduccion.getTiposProgramaProduccion().getCodTipoProgramaProd()+"', " +
                            " '"+programaProduccion.getPresentacionesProducto().getCodPresentacion()+"',1);  ";
                        System.out.println("consulta " + consulta);
                        st.executeUpdate(consulta);
                        Iterator i1 = programaProduccion.getFormulaMaestra().getFormulaMaestraDetalleMPList().iterator();
                        while(i1.hasNext()){
                            FormulaMaestraDetalleMP formulaMaestraDetalleMP = (FormulaMaestraDetalleMP)i1.next();
                            consulta = " insert into programa_produccion_detalle(cod_programa_prod,COD_COMPPROD, cod_material,cod_unidad_medida,cantidad,cod_lote_produccion,cod_tipo_programa_prod,cod_estado_registro) " +
                                    " values('"+programaProduccionbean.getCodProgramaProduccion()+"','"+programaProduccionbean.getFormulaMaestra().getComponentesProd().getCodCompprod()+"', " +
                                    "'"+ formulaMaestraDetalleMP.getMateriales().getCodMaterial() +"','"+formulaMaestraDetalleMP.getUnidadesMedida().getCodUnidadMedida()+"','"+formulaMaestraDetalleMP.getCantidad()+"'," +
                                    "'"+programaProduccionbean.getCodLoteProduccion()+"','"+programaProduccion.getTiposProgramaProduccion().getCodTipoProgramaProd()+"',1) ";
                            System.out.println("consulta " + consulta);
                            st.executeUpdate(consulta);
                        }

                        i1 = programaProduccion.getFormulaMaestra().getFormulaMaestraDetalleMRList().iterator();
                        while(i1.hasNext()){
                            FormulaMaestraDetalleMP formulaMaestraDetalleMP = (FormulaMaestraDetalleMP)i1.next();
                            consulta = " insert into programa_produccion_detalle(cod_programa_prod,COD_COMPPROD, cod_material,cod_unidad_medida,cantidad,cod_lote_produccion,cod_tipo_programa_prod,cod_estado_registro) " +
                                    " values('"+programaProduccionbean.getCodProgramaProduccion()+"','"+programaProduccionbean.getFormulaMaestra().getComponentesProd().getCodCompprod()+"', " +
                                    "'"+ formulaMaestraDetalleMP.getMateriales().getCodMaterial() +"','"+formulaMaestraDetalleMP.getUnidadesMedida().getCodUnidadMedida()+"','"+formulaMaestraDetalleMP.getCantidad()+"'," +
                                    "'"+programaProduccionbean.getCodLoteProduccion()+"','"+programaProduccion.getTiposProgramaProduccion().getCodTipoProgramaProd()+"',1) ";
                            System.out.println("consulta " + consulta);
                            st.executeUpdate(consulta);

                        }

                         i1 = programaProduccion.getFormulaMaestra().getFormulaMaestraDetalleEPList().iterator();
                        while(i1.hasNext()){
                            FormulaMaestraDetalleMP formulaMaestraDetalleMP = (FormulaMaestraDetalleMP)i1.next();
                            consulta = " insert into programa_produccion_detalle(cod_programa_prod,COD_COMPPROD, cod_material,cod_unidad_medida,cantidad,cod_lote_produccion,cod_tipo_programa_prod,cod_estado_registro) " +
                                    " values('"+programaProduccionbean.getCodProgramaProduccion()+"','"+programaProduccionbean.getFormulaMaestra().getComponentesProd().getCodCompprod()+"', " +
                                    "'"+ formulaMaestraDetalleMP.getMateriales().getCodMaterial() +"','"+formulaMaestraDetalleMP.getUnidadesMedida().getCodUnidadMedida()+"','"+formulaMaestraDetalleMP.getCantidad()+"'," +
                                    "'"+programaProduccionbean.getCodLoteProduccion()+"','"+programaProduccion.getTiposProgramaProduccion().getCodTipoProgramaProd()+"',1) ";
                            System.out.println("consulta " + consulta);
                            st.executeUpdate(consulta);

                        }

                        i1 = programaProduccion.getFormulaMaestra().getFormulaMaestraDetalleESList().iterator();
                        while(i1.hasNext()){
                            FormulaMaestraDetalleMP formulaMaestraDetalleMP = (FormulaMaestraDetalleMP)i1.next();
                            consulta = " insert into programa_produccion_detalle(cod_programa_prod,COD_COMPPROD, cod_material,cod_unidad_medida,cantidad,cod_lote_produccion,cod_tipo_programa_prod,cod_estado_registro) " +
                                    " values('"+programaProduccionbean.getCodProgramaProduccion()+"','"+programaProduccionbean.getFormulaMaestra().getComponentesProd().getCodCompprod()+"', " +
                                    "'"+ formulaMaestraDetalleMP.getMateriales().getCodMaterial() +"','"+formulaMaestraDetalleMP.getUnidadesMedida().getCodUnidadMedida()+"','"+formulaMaestraDetalleMP.getCantidad()+"'," +
                                    "'"+programaProduccionbean.getCodLoteProduccion()+"','"+programaProduccion.getTiposProgramaProduccion().getCodTipoProgramaProd()+"',1) ";
                            System.out.println("consulta " + consulta);
                            st.executeUpdate(consulta);

                        }
                    }
            }
            st.close();
            con.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        getCargarProgramaProduccion1();


        return "navegadorProgramaProduccionSim";
    }
    private void cargarLugaresAcondSelectList()
    {
        try {
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            String consulta = "select la.cod_lugar_acond,la.nombre_lugar_acond from LUGARES_ACOND la order by la.nombre_lugar_acond";
            ResultSet res = st.executeQuery(consulta);
            lugaresAcondList.clear();
            lugaresAcondList.add(new SelectItem("0","--Ninguno--"));
            while (res.next())
            {
                lugaresAcondList.add(new SelectItem(res.getString("cod_lugar_acond"),res.getString("nombre_lugar_acond")));
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
    public String cargarPresentacionesProductoEditarSelect()
    {
        ProgramaProduccion bean=(ProgramaProduccion)programaProduccionEditarDataTable.getRowData();
        bean.setPresentacionesProductoList(cargarPresentacionesSecundariasSelectList(bean));
        return null;
    }
    public String getCargarContenidoEditarProgramaProduccionSimulacion(){
        try {
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            String consulta = "select pp.COD_PROGRAMA_PROD,pp.COD_LOTE_PRODUCCION,pp.CANT_LOTE_PRODUCCION,tpp.COD_TIPO_PROGRAMA_PROD,"+
                              "tpp.NOMBRE_TIPO_PROGRAMA_PROD,fm.CANTIDAD_LOTE,pp.cod_lugar_acond,pp.COD_PRESENTACION"+
                              ",cp.COD_COMPPROD,cp.nombre_prod_semiterminado,pp.COD_FORMULA_MAESTRA,pp.OBSERVACION," +
                              " (case when pp.COD_COMPPROD=pp.COD_COMPPROD_PADRE then 1 else 0 end) as copiaCabeza"+
                              " from PROGRAMA_PRODUCCION pp inner join TIPOS_PROGRAMA_PRODUCCION tpp on "+
                              " pp.COD_TIPO_PROGRAMA_PROD=tpp.COD_TIPO_PROGRAMA_PROD"+
                              " inner join COMPONENTES_PROD cp on cp.COD_COMPPROD=pp.COD_COMPPROD"+
                              " inner join FORMULA_MAESTRA fm on fm.COD_FORMULA_MAESTRA=pp.COD_FORMULA_MAESTRA"+
                              " where pp.COD_PROGRAMA_PROD='"+programaProduccionCabeceraEditar.getCodProgramaProduccion()+"'"+
                              " and pp.COD_LOTE_PRODUCCION='"+programaProduccionCabeceraEditar.getCodLoteProduccion()+"'"+
                              " order by case when pp.COD_COMPPROD=pp.COD_COMPPROD_PADRE then 1 else 2 end,"+
                              " cp.nombre_prod_semiterminado";
            System.out.println("consulta cargar lotes edicion "+consulta);
            ResultSet res = st.executeQuery(consulta);
            programaProduccionEditarList=new ArrayList<ProgramaProduccion>();
            programaProduccionEditarList.clear();
            while (res.next())
            {
                ProgramaProduccion nuevo=new ProgramaProduccion();
                nuevo.getPresentacionesProducto().setCodPresentacion(res.getString("COD_PRESENTACION"));
                nuevo.setObservacion(res.getString("OBSERVACION"));
                nuevo.setCodProgramaProduccion(res.getString("COD_PROGRAMA_PROD"));
                nuevo.getFormulaMaestra().getComponentesProd().setCodCompprod(res.getString("COD_COMPPROD"));
                nuevo.getFormulaMaestra().getComponentesProd().setNombreProdSemiterminado(res.getString("nombre_prod_semiterminado"));
                nuevo.getFormulaMaestra().setCodFormulaMaestra(res.getString("COD_FORMULA_MAESTRA"));
                nuevo.getFormulaMaestra().setCantidadLote(res.getDouble("CANTIDAD_LOTE"));
                nuevo.setCantidadLote(res.getDouble("CANT_LOTE_PRODUCCION"));
                nuevo.setCodLoteProduccion(res.getString("COD_LOTE_PRODUCCION"));
                nuevo.getTiposProgramaProduccion().setCodTipoProgramaProd(res.getString("COD_TIPO_PROGRAMA_PROD"));
                nuevo.getTiposProgramaProduccion().setNombreTipoProgramaProd(res.getInt("copiaCabeza")>0?"":res.getString("NOMBRE_TIPO_PROGRAMA_PROD"));
                nuevo.getLugaresAcond().setCodLugarAcond(res.getInt("cod_lugar_acond"));
                programaProduccionEditarList.add(nuevo);
            }
            programaProduccionCabeceraEditar=(ProgramaProduccion)programaProduccionEditarList.get(0).clone();
            for(ProgramaProduccion bean:programaProduccionEditarList)bean.setPresentacionesProductoList(this.cargarPresentacionesSecundariasSelectList(bean));
            this.cargarLugaresAcondSelectList();
            this.cargarFormulasMaestrasDisponibles();
            this.cargarTiposProgramaProduccionSelect();
            res.close();
            st.close();
            con.close();
        } catch (SQLException ex) {
            LOGGER.warn("error", ex);
        }
       
        return null;
    }

    List explosionMaterialesList = new ArrayList();

    public List cargarExplosionMateriales(String codProgramaProd){
        List explosionMaterialesList = new ArrayList();
        try {
            Connection con = null;
            con = Util.openConnection(con);
            Statement st = con.createStatement();
            String consulta = " select cod_programa_produccion,cod_material,cod_unidad_medida,cantidad_disponible,cantidad_transito from explosion_materiales e where e.cod_programa_produccion = '"+codProgramaProd+"'";
            ResultSet rs = st.executeQuery(consulta);
            while(rs.next()){
                ExplosionMateriales e = new ExplosionMateriales();
                e.getProgramaProduccion().setCodProgramaProduccion(rs.getString("cod_programa_produccion"));
                e.getMateriales().setCodMaterial(rs.getString("cod_material"));
                e.getUnidadesMedida().setCodUnidadMedida(rs.getString("cod_unidad_medida"));
                e.setCantidadDisponible(rs.getDouble("cantidad_disponible") + rs.getDouble("cantidad_transito"));
                //e.setCantidadTransito(rs.getDouble("cantidad_transito"));
                explosionMaterialesList.add(e);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return explosionMaterialesList;
    }
    

    public int alcanzaEP = 0;
    public int lotesFabricarMPEP(ProductosProduccion p,List explosionMaterialesList){
        int lotesFabricar = 0;
        lotesMC = 0;
        lotesMM = 0;
        lotesMI = 0;
        try {
            Connection con = null;
            con = Util.openConnection(con);
            Statement st = con.createStatement();
            String consulta = " select p.cod_programa_prod,p.cod_compprod,p.cod_formula_maestra,p.cod_tipo_programa_prod" +
                    " from programa_produccion p where p.cod_programa_prod = '"+p.getProgramaProduccion().getCodProgramaProduccion()+"'" +
                    " and p.cod_formula_maestra = '"+p.getProgramaProduccion().getFormulaMaestra().getCodFormulaMaestra()+"' ";
            System.out.println("consulta "  + consulta);
            ResultSet rs = st.executeQuery(consulta);

            alcanzaEP = 0;
            while(rs.next()){
                ProgramaProduccion prp = new ProgramaProduccion();
                prp.setCodProgramaProduccion(rs.getString("cod_programa_prod"));
                prp.getFormulaMaestra().getComponentesProd().setCodCompprod(rs.getString("cod_compprod"));
                prp.getFormulaMaestra().setCodFormulaMaestra(rs.getString("cod_formula_maestra"));
                prp.getTiposProgramaProduccion().setCodTipoProgramaProd(rs.getString("cod_tipo_programa_prod"));
                System.out.println("productos revisado " + prp.getFormulaMaestra().getCodFormulaMaestra() 
                        + "  " + prp.getFormulaMaestra().getComponentesProd().getCodCompprod() +" " + prp.getTiposProgramaProduccion().getCodTipoProgramaProd());
                if(managedDemandaProductos.alcanzaMateriales(managedDemandaProductos.formulaMaestraMP(prp), explosionMaterialesList)==1)
                        //&& managedDemandaProductos.alcanzaMateriales(managedDemandaProductos.formulaMaestraEP(prp),explosionMaterialesList)==1)
                {
                    if(managedDemandaProductos.alcanzaMateriales(managedDemandaProductos.formulaMaestraEP(prp),explosionMaterialesList)==1){
                        alcanzaEP = 1;
                        lotesFabricar++;//lotes que se pueden fabricar a nivel de MP y EP
                    if(rs.getString("cod_tipo_programa_prod").equals("1")){
                        System.out.println("entro en MC");
                        lotesMC ++;
                    }
                    if(rs.getString("cod_tipo_programa_prod").equals("3")){
                        System.out.println("entro en MM");
                        lotesMM ++;
                    }
                    if(rs.getString("cod_tipo_programa_prod").equals("2")){
                        System.out.println("entro en MI");
                        lotesMI ++;
                    }
                    }
                    
                }
                
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lotesFabricar;
    }
    public void lotesFabricarMP(ProductosProduccion p,List explosionMaterialesList){
        //int lotesFabricar = 0;
        lotesMC = 0;
        lotesMM = 0;
        lotesMI = 0;
        try {
            Connection con = null;
            con = Util.openConnection(con);
            Statement st = con.createStatement();
            String consulta = " select p.cod_programa_prod,p.cod_compprod,p.cod_formula_maestra,p.cod_tipo_programa_prod" +
                    " from programa_produccion p where p.cod_programa_prod = '"+p.getProgramaProduccion().getCodProgramaProduccion()+"'" +
                    " and p.cod_formula_maestra = '"+p.getProgramaProduccion().getFormulaMaestra().getCodFormulaMaestra()+"' ";
            System.out.println("consulta "  + consulta);
            ResultSet rs = st.executeQuery(consulta);
            int alcanzaMaterial = 0;
            while(rs.next()){
                ProgramaProduccion prp = new ProgramaProduccion();
                prp.setCodProgramaProduccion(rs.getString("cod_programa_prod"));
                prp.getFormulaMaestra().getComponentesProd().setCodCompprod(rs.getString("cod_compprod"));
                prp.getFormulaMaestra().setCodFormulaMaestra(rs.getString("cod_formula_maestra"));
                prp.getTiposProgramaProduccion().setCodTipoProgramaProd(rs.getString("cod_tipo_programa_prod"));
                System.out.println("productos revisado " + prp.getFormulaMaestra().getCodFormulaMaestra()
                        + "  " + prp.getFormulaMaestra().getComponentesProd().getCodCompprod() +" " + prp.getTiposProgramaProduccion().getCodTipoProgramaProd());
                if(managedDemandaProductos.alcanzaMateriales(managedDemandaProductos.formulaMaestraMP(prp), explosionMaterialesList)==1){
                    //lotesFabricar++;//lotes que se pueden fabricar a nivel de MP y EP
                    if(rs.getString("cod_tipo_programa_prod").equals("1")){
                        System.out.println("entro en MC");
                        lotesMC ++;
                    }
                    if(rs.getString("cod_tipo_programa_prod").equals("3")){
                        System.out.println("entro en MM");
                        lotesMM ++;
                    }
                    if(rs.getString("cod_tipo_programa_prod").equals("2")){
                        System.out.println("entro en MI");
                        lotesMI ++;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        //return lotesFabricar;
    }
    public int alcanzaES = 0;

    public int lotesFabricar(ProductosProduccion p,List explosionMaterialesList){
        int lotesFabricar = 0;
        try {
            lotesMC = 0;
            lotesMM = 0;
            lotesMI = 0;
            Connection con = null;
            con = Util.openConnection(con);
            Statement st = con.createStatement();
            String consulta = " select p.cod_programa_prod,p.cod_compprod,p.cod_formula_maestra,p.cod_tipo_programa_prod" +
                    " from programa_produccion p where p.cod_programa_prod = '"+p.getProgramaProduccion().getCodProgramaProduccion()+"'" +
                    " and p.cod_formula_maestra = '"+p.getProgramaProduccion().getFormulaMaestra().getCodFormulaMaestra()+"' ";
            ResultSet rs = st.executeQuery(consulta);
            int alcanzaMaterial = 0;
            while(rs.next()){
                ProgramaProduccion prp = new ProgramaProduccion();
                prp.setCodProgramaProduccion(rs.getString("cod_programa_prod"));
                prp.getFormulaMaestra().getComponentesProd().setCodCompprod(rs.getString("cod_compprod"));
                prp.getFormulaMaestra().setCodFormulaMaestra(rs.getString("cod_formula_maestra"));
                prp.getTiposProgramaProduccion().setCodTipoProgramaProd(rs.getString("cod_tipo_programa_prod"));
                if(managedDemandaProductos.alcanzaMateriales(managedDemandaProductos.formulaMaestraMP(prp), new ArrayList(explosionMaterialesList))==1
                        && managedDemandaProductos.alcanzaMateriales(managedDemandaProductos.formulaMaestraEP(prp), new ArrayList(explosionMaterialesList))==1){
                        if(managedDemandaProductos.alcanzaMateriales(managedDemandaProductos.formulaMaestraES(prp), new ArrayList(explosionMaterialesList))==1){
                                alcanzaES = 1;
                                lotesFabricar++;//lotes que se pueden fabricar a nivel de MP , EP ES
                                if(rs.getString("cod_tipo_programa_prod").equals("1")){
                                    System.out.println("entro en MC");
                                    lotesMC ++;
                                }
                                if(rs.getString("cod_tipo_programa_prod").equals("3")){
                                    System.out.println("entro en MM");
                                    lotesMM ++;
                                }
                                if(rs.getString("cod_tipo_programa_prod").equals("2")){
                                    System.out.println("entro en MI");
                                    lotesMI ++;
                                }
                        }

                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lotesFabricar;
    }
    public int procesoMaquinaria(ProductosProduccion p,List explosionMaquinariaList){
        int alcanzaHorasMaquina = 0;
        try {
            Connection con = null;
            con = Util.openConnection(con);
            Statement st = con.createStatement();
            String consulta = " select p.cod_programa_prod,p.cod_compprod,p.cod_formula_maestra,p.cod_tipo_programa_prod" +
                    " from programa_produccion p where p.cod_programa_prod = '"+p.getProgramaProduccion().getCodProgramaProduccion()+"'" +
                    " and p.cod_formula_maestra = '"+p.getProgramaProduccion().getFormulaMaestra().getCodFormulaMaestra()+"' ";
            System.out.println("consulta " + consulta);
            ResultSet rs = st.executeQuery(consulta);
            while(rs.next()){
                ProgramaProduccion prp = new ProgramaProduccion();
                prp.setCodProgramaProduccion(rs.getString("cod_programa_prod"));
                prp.getFormulaMaestra().getComponentesProd().setCodCompprod(rs.getString("cod_compprod"));
                prp.getFormulaMaestra().setCodFormulaMaestra(rs.getString("cod_formula_maestra"));
                prp.getTiposProgramaProduccion().setCodTipoProgramaProd(rs.getString("cod_tipo_programa_prod"));
                if(this.alcanzaHorasMaquina(this.horasMaquinaProducto(prp), explosionMaquinariaList)==1){
                  alcanzaHorasMaquina = 1;
                }
            }
            
            } catch (Exception e) {
                    e.printStackTrace();
            }
        return alcanzaHorasMaquina;
    }
    public void procesoMaquinarias(){
        try {

        } catch (Exception e) {
        }
    }
    public List horasMaquinaProducto(ProgramaProduccion p){
        List horasMaquinaProductoList = new ArrayList();
        try {
        String consulta = " select m.COD_MAQUINA,sum(m.HORAS_HOMBRE) horas_hombre,sum(m.HORAS_MAQUINA) horas_maquina" +
                " from COMPONENTES_PROD c" +
                " inner join FORMULA_MAESTRA fm on fm.COD_COMPPROD = c.COD_COMPPROD" +
                " inner join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_FORMULA_MAESTRA = fm.COD_FORMULA_MAESTRA " +
                " inner join MAQUINARIA_ACTIVIDADES_FORMULA m on m.COD_ACTIVIDAD_FORMULA = afm.COD_ACTIVIDAD_FORMULA and (m.COD_ESTADO_REGISTRO is null or m.COD_ESTADO_REGISTRO = 1)" +
                " where fm.COD_ESTADO_REGISTRO = 1 and c.COD_ESTADO_COMPPROD = 1 and c.COD_COMPPROD = '"+p.getFormulaMaestra().getComponentesProd().getCodCompprod()+"' " +
                " group by m.COD_MAQUINA ";
        System.out.println("consulta " + consulta);
        Connection con = null;
        con = Util.openConnection(con);
        Statement st = con.createStatement();
        ResultSet rs = st.executeQuery(consulta);
        while(rs.next()){
            MaquinariaActividadesFormula m = new MaquinariaActividadesFormula();
            m.getMaquinaria().setCodMaquina(rs.getString("cod_maquina"));
            m.setHorasMaquina(rs.getFloat("horas_maquina"));
            m.setHorasHombre(rs.getFloat("horas_hombre"));
            horasMaquinaProductoList.add(m);
        }
        
        } catch (Exception e) {
            e.printStackTrace();
        }
        return horasMaquinaProductoList;
    }    
    public List copiaLista(){
        Iterator i = explosionMaterialesList.iterator();
        List copiaList = new ArrayList();
        while(i.hasNext()){
            ExplosionMateriales e = new ExplosionMateriales();
            ExplosionMateriales e1 = (ExplosionMateriales) i.next();
            e.setMateriales(e1.getMateriales());
            e.setProgramaProduccion(e1.getProgramaProduccion());
            e.setCantidadDisponible(e1.getCantidadDisponible());
            e.setCantidadTransito(e1.getCantidadTransito());
            e.setCantidadUtilizar(e1.getCantidadUtilizar());
            copiaList.add(e);
        }
        return copiaList;
    }
    public List copiaListaHorasMaquina(){
        Iterator i = explosionMaquinariasList.iterator();
        List copiaList = new ArrayList();
        while(i.hasNext()){
            ExplosionMaquinarias e1 = (ExplosionMaquinarias) i.next();
            ExplosionMaquinarias e = new ExplosionMaquinarias();
            e.setHorasDisponibles(e1.getHorasDisponibles());
            e.getMaquinarias().setCodMaquina(e1.getMaquinarias().getCodMaquina());
            copiaList.add(e);
        }
        return copiaList;
    }

    
    
    public String getCargarProductosAprobacion(){
        String codProgramaProduccion = "";
        productosProducirList.clear();
        try {
            HttpServletRequest request = (HttpServletRequest) FacesContext.getCurrentInstance().getExternalContext().getRequest();
            if (request.getParameter("codProgramaPeriodo") != null) {
                codProgramaProduccion = request.getParameter("codProgramaPeriodo");
            }
            managedDemandaProductos.cargarExplosionMateriales(codProgramaProduccion);
            explosionMaterialesList = this.cargarExplosionMateriales(codProgramaProduccion);
            explosionMaquinariasList = this.cargarHorasDisponiblesMaquiarias(codProgramaProduccion);
            String consulta = " select distinct p.cod_programa_prod,p.cod_formula_maestra,p.cod_compprod,cp.nombre_prod_semiterminado,f.CANTIDAD_LOTE" +
                    ",prodMC.cant_lote_produccion cant_lote_produccion_MC,prodMC.lotes lotes_MC" +
                    ",prodMM.cant_lote_produccion cant_lote_produccion_MM,prodMM.lotes lotes_MM" +
                    ",prodMI.cant_lote_produccion cant_lote_produccion_MI,prodMI.lotes lotes_MI,prodMC.lotes+prodMM.lotes+prodMI.lotes lotes_programados" +
                    " from PROGRAMA_PRODUCCION p" +
                    " inner join COMPONENTES_PROD cp on cp.COD_COMPPROD = p.COD_COMPPROD" +
                    " inner join FORMULA_MAESTRA f on f.COD_FORMULA_MAESTRA = p.COD_FORMULA_MAESTRA" +
                    " and p.COD_PROGRAMA_PROD = '"+codProgramaProduccion+"'" +
                    " outer apply(select sum(p1.CANT_LOTE_PRODUCCION) cant_lote_produccion,count(*) lotes " +
                    " from PROGRAMA_PRODUCCION p1" +
                    " where p1.COD_PROGRAMA_PROD = p.COD_PROGRAMA_PROD and p1.COD_TIPO_PROGRAMA_PROD = 1" +
                    " and p1.COD_COMPPROD = p.COD_COMPPROD and p1.COD_FORMULA_MAESTRA = p.COD_FORMULA_MAESTRA ) prodMC" +
                    " outer apply(select sum(p1.CANT_LOTE_PRODUCCION) cant_lote_produccion,count(*) lotes" +
                    " from PROGRAMA_PRODUCCION p1" +
                    " where p1.COD_PROGRAMA_PROD = p.COD_PROGRAMA_PROD and p1.COD_TIPO_PROGRAMA_PROD = 3" +
                    " and p1.COD_COMPPROD = p.COD_COMPPROD and p1.COD_FORMULA_MAESTRA = p.COD_FORMULA_MAESTRA" +
                    " ) prodMM" +
                    " outer apply(" +
                    " select sum(p1.CANT_LOTE_PRODUCCION) cant_lote_produccion,count(*) lotes" +
                    " from PROGRAMA_PRODUCCION p1" +
                    " where p1.COD_PROGRAMA_PROD = p.COD_PROGRAMA_PROD and p1.COD_TIPO_PROGRAMA_PROD = 2" +
                    " and p1.COD_COMPPROD = p.COD_COMPPROD and p1.COD_FORMULA_MAESTRA = p.COD_FORMULA_MAESTRA) prodMI ";
            Connection con = null;
            con = Util.openConnection(con);
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery(consulta);
            List explosionMaterialesAux = this.copiaLista();
            productosProduccionList.clear();
            int cods = 0;
            while(rs.next()){
                explosionMaterialesAux = this.copiaLista();
                ProductosProduccion p = new ProductosProduccion();
                p.getProgramaProduccion().getFormulaMaestra().getComponentesProd().setCodCompprod(rs.getString("cod_compprod"));
                p.getProgramaProduccion().getFormulaMaestra().getComponentesProd().setNombreProdSemiterminado(rs.getString("nombre_prod_semiterminado"));
                p.getProgramaProduccion().getFormulaMaestra().setCantidadLote(rs.getDouble("cantidad_lote"));
                p.getProgramaProduccion().getFormulaMaestra().setCodFormulaMaestra(rs.getString("cod_formula_maestra"));
                p.getProgramaProduccion().setCodProgramaProduccion(rs.getString("cod_programa_prod"));
                p.setCantMC(rs.getDouble("cant_lote_produccion_MC"));
                p.setCantMM(rs.getDouble("cant_lote_produccion_MM"));
                p.setCantMI(rs.getDouble("cant_lote_produccion_MI"));
                p.setLotesProgramados(rs.getDouble("lotes_programados"));
                lotesMC = 0;
                lotesMM = 0;
                lotesMI = 0;
                explosionMaterialesAux = this.copiaLista();
                this.lotesFabricarMP(p, explosionMaterialesAux);
                p.setLotesFabricarMP_MC(lotesMC);
                p.setLotesFabricarMP_MM(lotesMM);
                p.setLotesFabricarMP_MI(lotesMI);
                p.setColorMP(lotesMC+lotesMM+lotesMI>0?"#00FF00":"#FF0000");
                explosionMaterialesAux = this.copiaLista();
                p.setLotesFabricarMPEP(this.lotesFabricarMPEP(p,explosionMaterialesAux));
                p.setLotesFabricarMPEP_MC(lotesMC);
                p.setLotesFabricarMPEP_MM(lotesMM);
                p.setLotesFabricarMPEP_MI(lotesMI);
                p.setColorEP(alcanzaEP>0?"#00FF00":"#FF0000");
                explosionMaterialesAux = this.copiaLista();
                p.setLotesFabricarMPEP(this.lotesFabricar(p,explosionMaterialesAux));
                p.setLotesFabricarMPEPS_MC(lotesMC);
                p.setLotesFabricarMPEPS_MM(lotesMM);
                p.setLotesFabricarMPEPS_MI(lotesMI);
                p.setColorES(alcanzaES>0?"#00FF00":"#FF0000");
                p.setLotesFabricarMC(p.getLotesFabricarMP_MC());
                p.setLotesFabricarMM(p.getLotesFabricarMP_MM());
                p.setLotesFabricarMI(p.getLotesFabricarMP_MI());
                //p.setColorHorasMaquina(this.procesoMaquinaria(p, this.copiaListaHorasMaquina())>0?"#00FF00":"#FF0000");

                
//                if(this.alcanzaMaterialesMP(p)==1){
//                    p.setColorMP("#00FF00");
//                }
//                if(this.alcanzaMaterialesEP(p)==1){
//                    p.setColorEP("#00FF00");
//                }
//                if(this.alcanzaMaterialesES(p)==1){
//                    p.setColorES("#00FF00");
//                }
                productosProduccionList.add(p);
                
                
            }
            //cargar la lista con materiales disponibles
            


        } catch (Exception e) {
        }
        return null;
    }
    public void recalculaMateriales(){
        Iterator i = productosProduccionList.iterator();
        List explosionMaterialesAux = new ArrayList();
        while(i.hasNext()){
                ProductosProduccion p = (ProductosProduccion) i.next();
                explosionMaterialesAux = this.copiaLista();
                lotesMC = 0;
                lotesMM = 0;
                lotesMI = 0;
                explosionMaterialesAux = this.copiaLista();
                this.lotesFabricarMP(p, explosionMaterialesAux);
                p.setLotesFabricarMP_MC(lotesMC);
                p.setLotesFabricarMP_MM(lotesMM);
                p.setLotesFabricarMP_MI(lotesMI);
                p.setColorMP(lotesMC+lotesMM+lotesMI>0?"#00FF00":"");
                explosionMaterialesAux = this.copiaLista();
                p.setLotesFabricarMPEP(this.lotesFabricarMPEP(p,explosionMaterialesAux));
                p.setLotesFabricarMPEP_MC(lotesMC);
                p.setLotesFabricarMPEP_MM(lotesMM);
                p.setLotesFabricarMPEP_MI(lotesMI);
                p.setColorEP(alcanzaEP>0?"#00FF00":"");
                explosionMaterialesAux = this.copiaLista();
                p.setLotesFabricarMPEP(this.lotesFabricar(p,explosionMaterialesAux));
                p.setLotesFabricarMPEPS_MC(lotesMC);
                p.setLotesFabricarMPEPS_MM(lotesMM);
                p.setLotesFabricarMPEPS_MI(lotesMI);
                p.setColorES(alcanzaES>0?"#00FF00":"");
                p.setLotesFabricarMC(p.getLotesFabricarMP_MC());
                p.setLotesFabricarMM(p.getLotesFabricarMP_MM());
                p.setLotesFabricarMI(p.getLotesFabricarMP_MI());
        }
        
    }
    public int alcanzaMaterialesMP(ProductosProduccion p){
        int alcanzaMateriales = 1;
        try {
            Connection con = null;
            con = Util.openConnection(con);
            Statement st = con.createStatement();
            String consulta = " select (isnull(e.CANTIDAD_DISPONIBLE,0)+isnull(e.CANTIDAD_TRANSITO,0))-isnull(f.CANTIDAD,0) diferencia" +
                    " from programa_produccion ppr inner join formula_maestra fm on fm.cod_compprod = ppr.cod_compprod " +
                    " inner join FORMULA_MAESTRA_DETALLE_MP f on fm.cod_formula_maestra = f.cod_formula_maestra " +
                    " inner join EXPLOSION_MATERIALES e on e.COD_MATERIAL = f.COD_MATERIAL" +
                    " and e.COD_UNIDAD_MEDIDA = f.COD_UNIDAD_MEDIDA and e.cod_programa_produccion = ppr.cod_programa_prod " +
                    " where ppr.COD_FORMULA_MAESTRA = '"+p.getProgramaProduccion().getFormulaMaestra().getCodFormulaMaestra()+"'" +
                    " and ppr.COD_PROGRAMA_PROD = '"+p.getProgramaProduccion().getCodProgramaProduccion()+"' ";
            consulta = " select (isnull(e.CANTIDAD_DISPONIBLE,0) + isnull(e.CANTIDAD_TRANSITO,0)) - isnull(tabla.CANTIDAD,0) diferencia from (" +
                    " select ppr.COD_PROGRAMA_PROD,f.COD_MATERIAL,f.COD_UNIDAD_MEDIDA,sum(f.CANTIDAD) cantidad" +
                    " from programa_produccion ppr inner join formula_maestra fm on fm.cod_compprod = ppr.cod_compprod" +
                    " inner join FORMULA_MAESTRA_DETALLE_MP f on fm.cod_formula_maestra = f.cod_formula_maestra" +
                    " where ppr.COD_FORMULA_MAESTRA = '"+p.getProgramaProduccion().getFormulaMaestra().getCodFormulaMaestra()+"' and ppr.COD_PROGRAMA_PROD = '"+p.getProgramaProduccion().getCodProgramaProduccion()+"'" +
                    " group by ppr.COD_PROGRAMA_PROD,f.COD_MATERIAL,f.COD_UNIDAD_MEDIDA) tabla" +
                    " inner join EXPLOSION_MATERIALES e on e.COD_PROGRAMA_PRODUCCION = tabla.cod_programa_prod and e.COD_MATERIAL = tabla.cod_material" +
                    " and tabla.cod_unidad_medida = e.COD_UNIDAD_MEDIDA ";
            System.out.println("consulta " + consulta);
            ResultSet rs = st.executeQuery(consulta);
            while(rs.next()){
                if(rs.getDouble("diferencia")<0)
                {
                    alcanzaMateriales = 0;
                }
            }
            rs.close();
            rs.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return alcanzaMateriales;
    }
    public int alcanzaMaterialesEP(ProductosProduccion p){
        int alcanzaMateriales = 1;
        try {
            Connection con = null;
            con = Util.openConnection(con);
            Statement st = con.createStatement();
            String consulta = " select (isnull(e.CANTIDAD_DISPONIBLE,0)+isnull(e.CANTIDAD_TRANSITO,0))-isnull(f.CANTIDAD,0) diferencia" +
                 " from programa_produccion ppr inner join formula_maestra fm on fm.cod_formula_maestra = ppr.cod_formula_maestra" +
                 " inner join formula_maestra_detalle_ep f on f.cod_formula_maestra = fm.cod_formula_maestra " +
                 " inner join presentaciones_primarias p on p.cod_presentacion_primaria = f.cod_presentacion_primaria" +
                 " inner join explosion_materiales e on e.cod_material = f.cod_material and e.cod_unidad_medida = f.cod_unidad_medida and e.cod_programa_produccion = ppr.cod_programa_prod " +
                 " where ppr.cod_formula_maestra = '"+p.getProgramaProduccion().getFormulaMaestra().getCodFormulaMaestra()+"'" +
                 " and p.cod_tipo_programa_prod = ppr.cod_tipo_programa_prod" +
                 " and ppr.cod_programa_prod = '"+p.getProgramaProduccion().getCodProgramaProduccion()+"'";
            consulta = " select (isnull(e.CANTIDAD_DISPONIBLE, 0) + isnull(e.CANTIDAD_TRANSITO, 0)) - isnull(tabla.CANTIDAD, 0) diferencia from" +
                    " (select ppr.COD_PROGRAMA_PROD,f.COD_MATERIAL,f.COD_UNIDAD_MEDIDA,sum(f.CANTIDAD) cantidad " +
                    " from programa_produccion ppr" +
                    " inner join formula_maestra fm on fm.cod_formula_maestra =  ppr.cod_formula_maestra" +
                    " inner join formula_maestra_detalle_ep f on f.cod_formula_maestra =  fm.cod_formula_maestra" +
                    " inner join presentaciones_primarias p on p.cod_presentacion_primaria =   f.cod_presentacion_primaria     " +
                    " where ppr.cod_formula_maestra = '"+p.getProgramaProduccion().getFormulaMaestra().getCodFormulaMaestra()+"' and" +
                    " p.cod_tipo_programa_prod = ppr.cod_tipo_programa_prod and" +
                    " ppr.cod_programa_prod = '"+p.getProgramaProduccion().getCodProgramaProduccion()+"' group by ppr.COD_PROGRAMA_PROD,f.COD_MATERIAL,f.COD_UNIDAD_MEDIDA) tabla" +
                    " inner join explosion_materiales e on e.cod_material = tabla.cod_material" +
                    " and e.cod_unidad_medida = tabla.cod_unidad_medida and e.cod_programa_produccion ='"+p.getProgramaProduccion().getCodProgramaProduccion()+"' ";
            System.out.println("consulta " + consulta);
            ResultSet rs = st.executeQuery(consulta);
            while(rs.next()){
                if(rs.getDouble("diferencia")<0)
                {
                    alcanzaMateriales = 0;
                }
            }
            rs.close();
            rs.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return alcanzaMateriales;
    }
    public int alcanzaMaterialesES(ProductosProduccion p){
        int alcanzaMateriales = 1;
        try {
            Connection con = null;
            con = Util.openConnection(con);
            Statement st = con.createStatement();
            String consulta =   " select (isnull(e.CANTIDAD_DISPONIBLE,0)+isnull(e.CANTIDAD_TRANSITO,0))-isnull(f.CANTIDAD,0) diferencia " +
                                " from programa_produccion ppr " +
                                " inner join formula_maestra fm on fm.cod_formula_maestra = ppr.cod_formula_maestra " +
                                " inner join componentes_presprod c on c.cod_compprod = fm.cod_compprod " +
                                " and c.cod_tipo_programa_prod = ppr.cod_tipo_programa_prod " +
                                " inner join formula_maestra_detalle_es f on f.cod_formula_maestra = fm.cod_formula_maestra and c.cod_presentacion = f.cod_presentacion_producto" +
                                " inner join explosion_materiales e on e.cod_material = f.cod_material and e.cod_unidad_medida = f.cod_unidad_medida and e.cod_programa_produccion = ppr.cod_programa_prod " +
                                " where fm.cod_formula_maestra = '"+p.getProgramaProduccion().getFormulaMaestra().getCodFormulaMaestra()+"'" +
                                " and ppr.cod_compprod = '"+p.getProgramaProduccion().getFormulaMaestra().getComponentesProd().getCodCompprod()+"'";
            consulta = " select (isnull(e.CANTIDAD_DISPONIBLE, 0) + isnull(e.CANTIDAD_TRANSITO, 0)) -isnull(tabla.CANTIDAD, 0) diferencia from (" +
                    " select ppr.COD_PROGRAMA_PROD,f.COD_MATERIAL,f.COD_UNIDAD_MEDIDA,sum(f.CANTIDAD) cantidad" +
                    " from programa_produccion ppr inner join formula_maestra fm on fm.cod_formula_maestra = ppr.cod_formula_maestra" +
                    " inner join componentes_presprod c on c.cod_compprod = fm.cod_compprod and c.cod_tipo_programa_prod = ppr.cod_tipo_programa_prod" +
                    " inner join formula_maestra_detalle_es f on f.cod_formula_maestra = fm.cod_formula_maestra and c.cod_presentacion = f.cod_presentacion_producto     " +
                    " where fm.cod_formula_maestra = '"+p.getProgramaProduccion().getFormulaMaestra().getCodFormulaMaestra()+"'" +
                    " and ppr.cod_compprod = '"+p.getProgramaProduccion().getFormulaMaestra().getComponentesProd().getCodCompprod()+"' and ppr.COD_PROGRAMA_PROD = '"+p.getProgramaProduccion().getCodProgramaProduccion()+"'" +
                    " group by ppr.COD_PROGRAMA_PROD,f.COD_MATERIAL,f.COD_UNIDAD_MEDIDA) as tabla" +
                    " inner join explosion_materiales e on e.cod_material = tabla.cod_material" +
                    " and e.cod_unidad_medida = tabla.cod_unidad_medida and e.cod_programa_produccion = '"+p.getProgramaProduccion().getCodProgramaProduccion()+"' ";
            System.out.println("consulta " + consulta);
            ResultSet rs = st.executeQuery(consulta);
            while(rs.next()){
                if(rs.getDouble("diferencia")<0)
                {
                    alcanzaMateriales = 0;
                }
            }
            rs.close();
            rs.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return alcanzaMateriales;
    }
    
    public String seleccionarProductosAprobacion_action(){
        try {
            Connection con = null;
            con = Util.openConnection(con);
            Statement st = con.createStatement();
            //restar de la explosion de materiales
            //List materialesConflictoList = new ArrayList();
            materialesConflictoList.clear();
            List explosionMaterialesList = new ArrayList();
            explosionMaterialesList = this.copiaLista();
            Iterator i = productosProduccionList.iterator();//iterar los productos y verificar el check
            materialConflicto = 0;
            System.out.println("material conflicto >>>>>>>>>>>>>>>"+materialConflicto);
            while(i.hasNext()){
                ProductosProduccion p = (ProductosProduccion) i.next();
                if(p.getChecked()){
                    String consulta = "select tabla.cod_material,m.nombre_material,g.nombre_grupo,u.nombre_unidad_medida,tabla.cantidad from (select f.COD_MATERIAL,f.CANTIDAD*'"+p.getLotesFabricarMC()+"' cantidad,f.COD_UNIDAD_MEDIDA" +
                            " from FORMULA_MAESTRA_DETALLE_MP f " +
                            " where f.COD_FORMULA_MAESTRA = '"+p.getProgramaProduccion().getFormulaMaestra().getCodFormulaMaestra()+"'" +
                            " union all" +
                            " select f.COD_MATERIAL,  f.CANTIDAD*'"+p.getLotesFabricarMC()+"' cantidad, f.COD_UNIDAD_MEDIDA" +
                            " from formula_maestra_detalle_ep f inner join presentaciones_primarias p on p.cod_presentacion_primaria = f.cod_presentacion_primaria" +
                            " where cod_formula_maestra = '"+p.getProgramaProduccion().getFormulaMaestra().getCodFormulaMaestra()+"' and p.cod_tipo_programa_prod = '1'" +
                            " union all" +
                            " select f.COD_MATERIAL,  f.CANTIDAD*'"+p.getLotesFabricarMC()+"' cantidad,f.COD_UNIDAD_MEDIDA" +
                            " from formula_maestra fm inner join componentes_presprod c on c.cod_compprod = fm.cod_compprod and c.cod_tipo_programa_prod = '1'" +
                            " inner join formula_maestra_detalle_es f on f.cod_formula_maestra = fm.cod_formula_maestra and c.cod_presentacion = f.cod_presentacion_producto" +
                            " where fm.cod_formula_maestra = '"+p.getProgramaProduccion().getFormulaMaestra().getCodFormulaMaestra()+"' "+//materiales requeridos para el producto
                            " union all  " + //--union MM
                            " select f.COD_MATERIAL,f.CANTIDAD*'"+p.getLotesFabricarMM()+"' cantidad,f.COD_UNIDAD_MEDIDA" +
                            " from FORMULA_MAESTRA_DETALLE_MP f" +
                            " where f.COD_FORMULA_MAESTRA = '"+p.getProgramaProduccion().getCodCompProd()+"'" +
                            " union all" +
                            " select f.COD_MATERIAL,  f.CANTIDAD*'"+p.getLotesFabricarMM()+"' cantidad, f.COD_UNIDAD_MEDIDA" +
                            " from formula_maestra_detalle_ep f inner join presentaciones_primarias p on p.cod_presentacion_primaria = f.cod_presentacion_primaria" +
                            " where cod_formula_maestra = '"+p.getProgramaProduccion().getFormulaMaestra().getCodFormulaMaestra()+"' and p.cod_tipo_programa_prod = '3'" +
                            " union all" +
                            " select f.COD_MATERIAL,  f.CANTIDAD*'"+p.getLotesFabricarMM()+"' cantidad,f.COD_UNIDAD_MEDIDA" +
                            " from formula_maestra fm inner join componentes_presprod c on c.cod_compprod = fm.cod_compprod and c.cod_tipo_programa_prod = '3'" +
                            " inner join formula_maestra_detalle_es f on f.cod_formula_maestra = fm.cod_formula_maestra and c.cod_presentacion = f.cod_presentacion_producto" +
                            " where fm.cod_formula_maestra = '"+p.getProgramaProduccion().getFormulaMaestra().getCodFormulaMaestra()+"'" +
                            " union all  "+ //-- union MI
                            " select f.COD_MATERIAL,f.CANTIDAD*'"+p.getLotesFabricarMI()+"' cantidad,f.COD_UNIDAD_MEDIDA" +
                            " from FORMULA_MAESTRA_DETALLE_MP f" +
                            " where f.COD_FORMULA_MAESTRA = '"+p.getProgramaProduccion().getFormulaMaestra().getCodFormulaMaestra()+"'" +
                            " union all" +
                            " select f.COD_MATERIAL,  f.CANTIDAD*'"+p.getLotesFabricarMI()+"' cantidad, f.COD_UNIDAD_MEDIDA" +
                            " from formula_maestra_detalle_ep f inner join presentaciones_primarias p on p.cod_presentacion_primaria = f.cod_presentacion_primaria" +
                            " where cod_formula_maestra = '"+p.getProgramaProduccion().getFormulaMaestra().getCodFormulaMaestra()+"' and p.cod_tipo_programa_prod = '2'" +
                            " union all" +
                            " select f.COD_MATERIAL,  f.CANTIDAD*'"+p.getLotesFabricarMI()+"' cantidad,f.COD_UNIDAD_MEDIDA" +
                            " from formula_maestra fm inner join componentes_presprod c on c.cod_compprod = fm.cod_compprod and c.cod_tipo_programa_prod = '2'" +
                            " inner join formula_maestra_detalle_es f on f.cod_formula_maestra = fm.cod_formula_maestra and c.cod_presentacion = f.cod_presentacion_producto" +
                            " where fm.cod_formula_maestra = '"+p.getProgramaProduccion().getFormulaMaestra().getCodFormulaMaestra()+"') tabla inner join materiales m on m.cod_material = tabla.cod_material" +
                            " inner join grupos g on g.cod_grupo = m.cod_grupo inner join unidades_medida u on u.cod_unidad_medida = m.cod_unidad_medida where tabla.cantidad>0";
                    System.out.println("consulta de materiales implicados " + consulta);
                    ResultSet rs = st.executeQuery(consulta);
                    ExplosionMateriales e = new ExplosionMateriales();
                    while(rs.next()){
                        //ubicar el material que afectara
                        Iterator ii = explosionMaterialesList.iterator();
                        while(ii.hasNext()){
                            e = (ExplosionMateriales) ii.next();
                            if(e.getMateriales().getCodMaterial().equals(rs.getString("cod_material"))){
                                System.out.println(" en la disponibilidad "+e.getMateriales().getCodMaterial() +" " + e.getCantidadDisponible()+ " " + rs.getDouble("cantidad"));
                                e.setCantidadDisponible(e.getCantidadDisponible()-rs.getDouble("cantidad"));
                                if(e.getCantidadDisponible()<0){
                                    System.out.println("material en conflicto "  + e.getMateriales().getCodMaterial());
                                    MaterialesConflicto m = new MaterialesConflicto();
                                    m.setMateriales(e.getMateriales());
                                    m.getMateriales().setCodMaterial(rs.getString("cod_material"));
                                    m.getMateriales().setNombreMaterial(rs.getString("nombre_material"));
                                    m.getMateriales().getGrupo().setNombreGrupo(rs.getString("nombre_grupo"));
                                    m.getMateriales().getUnidadesMedida().setNombreUnidadMedida(rs.getString("nombre_unidad_medida"));
                                    m.setCantidad(this.buscaCantidadMaterial(m.getMateriales()));
                                    m.setCantidadRestanteAux(e.getCantidadDisponible()); //para actualizar la cantidad si se aprueban los productos
                                    m.setProductosList(this.productoConflicto(m, p)); // a desplegarse en productos en conflicto
                                    materialesConflictoList.add(m);
                                    materialConflicto = 1;
                                }
                            }
                        }
//                        if(materialConflicto==1){
//                            MaterialesConflicto m = new MaterialesConflicto();
//                            m.setMateriales(e.getMateriales());
//                            m.setProductosList(this.productoConflicto(m, p)); // a desplegarse en productos en conflicto
//                            materialesConflictoList.add(m);
//                        }
                        
                    }
                    this.actualizarCantidadRestanteMaterial(explosionMaterialesList);
                    if(materialConflicto==0 && (p.getLotesFabricarMC()>0 || p.getLotesFabricarMM()>0 || p.getLotesFabricarMI()>0)){
                    System.out.println("cantidades::::::::" + p.getLotesFabricarMC()+ " " + p.getLotesFabricarMM() + " " + p.getLotesFabricarMI());
                        this.eliminarDeProductosPendientesAprobacion_1();
                    }
                }
            }
            System.out.println("material conflicto >>>>>>>>>>>>>>>"+materialConflicto);
            
            

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public void actualizarCantidadRestanteMaterial(List explosionMaterialesListCR){
        Iterator i = explosionMaterialesList.iterator();
        while(i.hasNext()){
            ExplosionMateriales e = (ExplosionMateriales) i.next();
            Iterator ii = explosionMaterialesListCR.iterator();
            while(ii.hasNext()){
                ExplosionMateriales eCR = (ExplosionMateriales) ii.next();
                if(eCR.getMateriales().getCodMaterial().equals(e.getMateriales().getCodMaterial())){
                    //System.out.println("coloca cantidad restante "+ eCR.getMateriales().getCodMaterial() +"  " +eCR.getCantidadDisponible());
                    e.setCantidadDisponible(eCR.getCantidadDisponible());
                    break;
                }
            }
        }
    }    
    
    public int alcanzaHorasMaquina(List maquinariasHorasList,List horasDispMaquinariasList){
     int alcanzaHoras = 1;
     Iterator i = maquinariasHorasList.iterator();
     double horasAux = 0.0;
     while(i.hasNext()){
         MaquinariaActividadesFormula m = (MaquinariaActividadesFormula) i.next();
         Iterator i1 = horasDispMaquinariasList.iterator();
         while(i1.hasNext()){
             ExplosionMaquinarias e = (ExplosionMaquinarias) i1.next();
             if(e.getMaquinarias().getCodMaquina().equals(m.getMaquinaria().getCodMaquina())){
                 System.out.println("se va restando la hora "+ m.getMaquinaria().getCodMaquina()+ ": " + e.getHorasDisponibles() +" -  "+ m.getHorasMaquina());
                 horasAux = e.getHorasDisponibles();
                e.setHorasDisponibles(e.getHorasDisponibles()-m.getHorasMaquina());
                if(e.getHorasDisponibles()<0){
                    alcanzaHoras=0;
                    System.out.println("comparacion que afecto "+ m.getMaquinaria().getCodMaquina()+ ": " + horasAux +" -  "+ m.getHorasMaquina());
                }
             }
         }
     }
     return alcanzaHoras;
    }
    public List cargarHorasDisponiblesMaquiarias(String codProgramaProd){
        List explosionMaquinariasList = new ArrayList();
        try {
            String consulta = " select distinct m.COD_MAQUINA,504 horas_disponibles" +
                    " from COMPONENTES_PROD c" +
                    " inner join FORMULA_MAESTRA fm on fm.COD_COMPPROD = c.COD_COMPPROD" +
                    " inner join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_FORMULA_MAESTRA = fm.COD_FORMULA_MAESTRA" +
                    " inner join MAQUINARIA_ACTIVIDADES_FORMULA m on m.COD_ACTIVIDAD_FORMULA = afm.COD_ACTIVIDAD_FORMULA and (m.COD_ESTADO_REGISTRO is null or m.COD_ESTADO_REGISTRO = 1)" +
                    " where fm.COD_ESTADO_REGISTRO = 1 and c.COD_ESTADO_COMPPROD = 1" +
                    " and c.COD_COMPPROD in (select distinct p.COD_COMPPROD from programa_produccion p where p.COD_PROGRAMA_PROD = '"+codProgramaProd+"') ";
            Connection con = null;
            con = Util.openConnection(con);
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery(consulta);
            explosionMaquinariasList.clear();
            while(rs.next()){
                ExplosionMaquinarias e = new ExplosionMaquinarias();
                e.getMaquinarias().setCodMaquina(rs.getString("cod_maquina"));
                e.setHorasDisponibles(rs.getDouble("horas_disponibles"));
                explosionMaquinariasList.add(e);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return explosionMaquinariasList;
    }
    public double buscaCantidadMaterial(Materiales m){
        double cantidad = 0.0;
        Iterator i = explosionMaterialesList.iterator();
        while(i.hasNext()){
            ExplosionMateriales e = (ExplosionMateriales) i.next();
            if(e.getMateriales().getCodMaterial().equals(m.getCodMaterial())){
                cantidad = e.getCantidadDisponible();
            }
        }
        return cantidad;
    }
    //------------
    List productosProducirList = new ArrayList();
    public String agregarProductosProduccion(){
        Iterator i = materialesConflictoList.iterator();
        while(i.hasNext()){
            MaterialesConflicto m = (MaterialesConflicto)i.next();
            Iterator ii = m.getProductosList().iterator(); //iteramos los productos
            while(ii.hasNext()){
                ProductosConflicto p = (ProductosConflicto) ii.next();
                if(p.getChecked()){
                    //productosProducirList.add(p.getProgramaProduccion());
                    //eliminar de la lista de productos en conflicto y la lista de productos pendientes de aprobacion
                    this.eliminarDeProductosPendientesAprobacion(p);
                    //actualizar la cantidad restante del material
                    this.actualizarMaterialCantidadRestante(p);
                }
            }
        }
        return null;
    }
    public String recalcularMateriales(){
        this.recalculaMateriales();
        return null;
    }
    public void eliminarDeProductosPendientesAprobacion(ProductosConflicto p){
        Iterator i = productosProduccionList.iterator();
        while(i.hasNext()){
            ProductosProduccion ppr = (ProductosProduccion) i.next();
            if(p.getChecked() &&
                    ppr.getProgramaProduccion().getFormulaMaestra().getComponentesProd().getCodCompprod().equals(p.getProgramaProduccion().getFormulaMaestra().getComponentesProd().getCodCompprod())){
                for(int ii = 1;ii<=ppr.getLotesFabricarMC();ii++){
                    ProgramaProduccion ppr1 = new ProgramaProduccion();
                    ppr1.setCodProgramaProduccion(p.getProgramaProduccion().getCodProgramaProduccion());
                    ppr1.getFormulaMaestra().setComponentesProd(p.getProgramaProduccion().getFormulaMaestra().getComponentesProd());
                    ppr1.getFormulaMaestra().setCodFormulaMaestra(ppr.getProgramaProduccion().getFormulaMaestra().getCodFormulaMaestra());
                    ppr1.setNroLotes(1);
                    ppr1.getTiposProgramaProduccion().setCodTipoProgramaProd("1");
                    ppr1.getTiposProgramaProduccion().setNombreTipoProgramaProd("MERCADERIA CORRIENTE");
                    ppr1.getEstadoProgramaProduccion().setNombreEstadoProgramaProd("SIMULACION");
                    //data.programaProduccion.formulaMaestra.cantidadLote
                    ppr1.setCantidadLote(ppr.getProgramaProduccion().getFormulaMaestra().getCantidadLote());
                    ppr1.getFormulaMaestra().setCantidadLote(ppr.getProgramaProduccion().getFormulaMaestra().getCantidadLote());
                    productosProducirList.add(ppr1);
                }
                for(int ii = 1;ii<=ppr.getLotesFabricarMM();ii++){
                    ProgramaProduccion ppr1 = new ProgramaProduccion();
                    ppr1.setCodProgramaProduccion(p.getProgramaProduccion().getCodProgramaProduccion());
                    ppr1.getFormulaMaestra().setComponentesProd(p.getProgramaProduccion().getFormulaMaestra().getComponentesProd());
                    ppr1.getFormulaMaestra().setCodFormulaMaestra(ppr.getProgramaProduccion().getFormulaMaestra().getCodFormulaMaestra());
                    ppr1.setNroLotes(1);
                    ppr1.getTiposProgramaProduccion().setCodTipoProgramaProd("3");
                    ppr1.getTiposProgramaProduccion().setNombreTipoProgramaProd("MUESTRA MEDICA");
                    ppr1.getEstadoProgramaProduccion().setNombreEstadoProgramaProd("SIMULACION");
                    ppr1.setCantidadLote(ppr.getProgramaProduccion().getFormulaMaestra().getCantidadLote());
                    ppr1.getFormulaMaestra().setCantidadLote(ppr.getProgramaProduccion().getFormulaMaestra().getCantidadLote());
                    productosProducirList.add(ppr1);
                }
                for(int ii = 1;ii<=ppr.getLotesFabricarMI();ii++){
                    ProgramaProduccion ppr1 = new ProgramaProduccion();
                    ppr1.setCodProgramaProduccion(p.getProgramaProduccion().getCodProgramaProduccion());
                    ppr1.getFormulaMaestra().setComponentesProd(p.getProgramaProduccion().getFormulaMaestra().getComponentesProd());
                    ppr1.getFormulaMaestra().setCodFormulaMaestra(ppr.getProgramaProduccion().getFormulaMaestra().getCodFormulaMaestra());
                    ppr1.setNroLotes(1);
                    ppr1.getTiposProgramaProduccion().setCodTipoProgramaProd("2");
                    ppr1.getTiposProgramaProduccion().setNombreTipoProgramaProd("LICITACION");
                    ppr1.getEstadoProgramaProduccion().setNombreEstadoProgramaProd("SIMULACION");
                    ppr1.setCantidadLote(ppr.getProgramaProduccion().getFormulaMaestra().getCantidadLote());
                    ppr1.getFormulaMaestra().setCantidadLote(ppr.getProgramaProduccion().getFormulaMaestra().getCantidadLote());
                    productosProducirList.add(ppr1);
                }
                i.remove();
            }
        }
        
    }
    public void eliminarDeProductosPendientesAprobacion_1(){
        Iterator i = productosProduccionList.iterator();
        while(i.hasNext()){
            ProductosProduccion ppr = (ProductosProduccion) i.next();
            if(ppr.getChecked()){
                for(int ii = 1;ii<=ppr.getLotesFabricarMC();ii++){
                    ProgramaProduccion ppr1 = new ProgramaProduccion();
                    ppr1.setCodProgramaProduccion(ppr.getProgramaProduccion().getCodProgramaProduccion());
                    ppr1.getFormulaMaestra().setComponentesProd(ppr.getProgramaProduccion().getFormulaMaestra().getComponentesProd());
                    ppr1.getFormulaMaestra().setCodFormulaMaestra(ppr.getProgramaProduccion().getFormulaMaestra().getCodFormulaMaestra());
                    ppr1.setNroLotes(1);
                    ppr1.getTiposProgramaProduccion().setCodTipoProgramaProd("1");
                    ppr1.getTiposProgramaProduccion().setNombreTipoProgramaProd("MERCADERIA CORRIENTE");
                    ppr1.getEstadoProgramaProduccion().setNombreEstadoProgramaProd("SIMULACION");
                    ppr1.setCantidadLote(ppr.getProgramaProduccion().getFormulaMaestra().getCantidadLote());
                    productosProducirList.add(ppr1);
                }
                for(int ii = 1;ii<=ppr.getLotesFabricarMM();ii++){
                    ProgramaProduccion ppr1 = new ProgramaProduccion();
                    ppr1.setCodProgramaProduccion(ppr.getProgramaProduccion().getCodProgramaProduccion());
                    ppr1.getFormulaMaestra().setComponentesProd(ppr.getProgramaProduccion().getFormulaMaestra().getComponentesProd());
                    ppr1.getFormulaMaestra().setCodFormulaMaestra(ppr.getProgramaProduccion().getFormulaMaestra().getCodFormulaMaestra());
                    ppr1.setNroLotes(1);
                    ppr1.getTiposProgramaProduccion().setCodTipoProgramaProd("3");
                    ppr1.getTiposProgramaProduccion().setNombreTipoProgramaProd("MUESTRA MEDICA");
                    ppr1.getEstadoProgramaProduccion().setNombreEstadoProgramaProd("SIMULACION");
                    ppr1.setCantidadLote(ppr.getProgramaProduccion().getFormulaMaestra().getCantidadLote());
                    productosProducirList.add(ppr1);
                }
                for(int ii = 1;ii<=ppr.getLotesFabricarMI();ii++){
                    ProgramaProduccion ppr1 = new ProgramaProduccion();
                    ppr1.setCodProgramaProduccion(ppr.getProgramaProduccion().getCodProgramaProduccion());
                    ppr1.getFormulaMaestra().setComponentesProd(ppr.getProgramaProduccion().getFormulaMaestra().getComponentesProd());
                    ppr1.getFormulaMaestra().setCodFormulaMaestra(ppr.getProgramaProduccion().getFormulaMaestra().getCodFormulaMaestra());
                    ppr1.setNroLotes(1);
                    ppr1.getTiposProgramaProduccion().setCodTipoProgramaProd("2");
                    ppr1.getTiposProgramaProduccion().setNombreTipoProgramaProd("LICITACION");
                    ppr1.getEstadoProgramaProduccion().setNombreEstadoProgramaProd("SIMULACION");
                    ppr1.setCantidadLote(ppr.getProgramaProduccion().getFormulaMaestra().getCantidadLote());
                    productosProducirList.add(ppr1);
                }
                i.remove();
            }
        }

    }
    public void actualizarMaterialCantidadRestante(ProductosConflicto pr){
        Iterator i = materialesConflictoList.iterator();
        while(i.hasNext()){
            MaterialesConflicto m = (MaterialesConflicto)i.next();
            Iterator ii = m.getProductosList().iterator(); //iteramos los productos
            while(ii.hasNext()){
                ProductosConflicto p = (ProductosConflicto) ii.next();
                Iterator j= explosionMaterialesList.iterator();
                while(j.hasNext()){
                    ExplosionMateriales e = (ExplosionMateriales) j.next();
                    if(pr.getProgramaProduccion().getFormulaMaestra().getComponentesProd().getCodCompprod().equals(p.getProgramaProduccion().getFormulaMaestra().getComponentesProd().getCodCompprod())
                            ){
                        e.setCantidadDisponible(e.getCantidadDisponible()-p.getCantidad());
                    }
                }

            }
        }
    }
    //------------
    public List productoConflicto(MaterialesConflicto m,ProductosProduccion p){
        List productoConflictoList = new ArrayList();
        try {
            //hallar los productos implicados
            Iterator i = productosProduccionList.iterator();
            String codFormulaMaestra = "0";
            while(i.hasNext()){
                ProductosProduccion p1 = (ProductosProduccion) i.next();
                if(p.getChecked()){
                    codFormulaMaestra = codFormulaMaestra +","+p.getProgramaProduccion().getFormulaMaestra().getCodFormulaMaestra();
                }
            }
            String consulta = " select distinct cp.cod_compprod,cp.nombre_prod_semiterminado,f.COD_MATERIAL,f.CANTIDAD*'"+p.getLotesFabricarMC()+"' cantidad,f.COD_UNIDAD_MEDIDA,1 cod_tipo_programa_prod,'MERCADERIA CORRIENTE' nombre_tipo_programa_prod" +
                    " from FORMULA_MAESTRA_DETALLE_MP f inner join programa_produccion p on p.cod_formula_maestra = f.cod_formula_maestra" +
                    " inner join componentes_prod cp on cp.cod_compprod = p.cod_compprod" +
                    " where p.cod_programa_prod = '"+p.getProgramaProduccion().getCodProgramaProduccion()+"'" +
                    " and f.COD_MATERIAL = '"+m.getMateriales().getCodMaterial()+"'" +
                    " and p.cod_formula_maestra in("+codFormulaMaestra+")" +
                    " union all" +
                    " select distinct cp.cod_compprod,cp.nombre_prod_semiterminado,f.COD_MATERIAL,  f.CANTIDAD*'"+p.getLotesFabricarMC()+"' cantidad, f.COD_UNIDAD_MEDIDA,1 cod_tipo_programa_prod,'MERCADERIA CORRIENTE' nombre_tipo_programa_prod" +
                    " from programa_produccion ppr" +
                    " inner join componentes_prod cp on cp.cod_compprod = ppr.cod_compprod" +
                    " inner join presentaciones_primarias p on p.COD_TIPO_PROGRAMA_PROD= 1 and p.COD_COMPPROD = cp.COD_COMPPROD" +
                    " inner join formula_maestra_detalle_ep f on ppr.cod_formula_maestra = f.cod_formula_maestra and f.COD_PRESENTACION_PRIMARIA = p.COD_PRESENTACION_PRIMARIA" +
                    " where ppr.cod_programa_prod = '"+p.getProgramaProduccion().getCodProgramaProduccion()+"' and f.COD_MATERIAL = '"+m.getMateriales().getCodMaterial()+"' " + //--and p.cod_tipo_programa_prod = '1'
                    " and ppr.cod_formula_maestra in("+codFormulaMaestra+")" +
                    " union all" +
                    " select distinct cp.cod_compprod,cp.nombre_prod_semiterminado,f.COD_MATERIAL,  f.CANTIDAD*'"+p.getLotesFabricarMC()+"' cantidad,f.COD_UNIDAD_MEDIDA,1 cod_tipo_programa_prod,'MERCADERIA CORRIENTE' nombre_tipo_programa_prod" +
                    " from programa_produccion ppr" +
                    " inner join componentes_prod cp on cp.cod_compprod = ppr.cod_compprod" +
                    " inner join formula_maestra fm on ppr.cod_formula_maestra = fm.cod_formula_maestra" +
                    " inner join componentes_presprod c on c.cod_compprod = fm.cod_compprod and c.COD_TIPO_PROGRAMA_PROD = 1" +
                    " inner join formula_maestra_detalle_es f on f.cod_formula_maestra = fm.cod_formula_maestra "+
                    " where ppr.cod_programa_prod = '"+p.getProgramaProduccion().getCodProgramaProduccion()+"' and f.COD_MATERIAL = '"+m.getMateriales().getCodMaterial()+"' "+
                    " and ppr.cod_formula_maestra in("+codFormulaMaestra+")"+

                    " union all" +
                    " select distinct cp.cod_compprod,cp.nombre_prod_semiterminado,f.COD_MATERIAL,f.CANTIDAD*'"+p.getLotesFabricarMM()+"' cantidad,f.COD_UNIDAD_MEDIDA,3 cod_tipo_programa_prod,'MUESTRA MEDICA' nombre_tipo_programa_prod" +
                    " from FORMULA_MAESTRA_DETALLE_MP f inner join programa_produccion p on p.cod_formula_maestra = f.cod_formula_maestra" +
                    " inner join componentes_prod cp on cp.cod_compprod = p.cod_compprod" +
                    " where p.cod_programa_prod = '"+p.getProgramaProduccion().getCodProgramaProduccion()+"'" +
                    " and f.COD_MATERIAL = '"+m.getMateriales().getCodMaterial()+"'" +
                    " and p.cod_formula_maestra in("+codFormulaMaestra+")" +
                    " union all" +
                    " select distinct cp.cod_compprod,cp.nombre_prod_semiterminado,f.COD_MATERIAL,  f.CANTIDAD*'"+p.getLotesFabricarMM()+"' cantidad, f.COD_UNIDAD_MEDIDA,3 cod_tipo_programa_prod,'MUESTRA MEDICA' nombre_tipo_programa_prod" +
                    " from programa_produccion ppr" +
                    " inner join componentes_prod cp on cp.cod_compprod = ppr.cod_compprod" +
                    " inner join presentaciones_primarias p on p.COD_TIPO_PROGRAMA_PROD= 3 and p.COD_COMPPROD = cp.COD_COMPPROD" +
                    " inner join formula_maestra_detalle_ep f on ppr.cod_formula_maestra = f.cod_formula_maestra and f.COD_PRESENTACION_PRIMARIA = p.COD_PRESENTACION_PRIMARIA" +
                    " where ppr.cod_programa_prod = '"+p.getProgramaProduccion().getCodProgramaProduccion()+"' and f.COD_MATERIAL = '"+m.getMateriales().getCodMaterial()+"' " + //--and p.cod_tipo_programa_prod = '1'
                    " and ppr.cod_formula_maestra in("+codFormulaMaestra+")" +
                    " union all" +
                    " select distinct cp.cod_compprod,cp.nombre_prod_semiterminado,f.COD_MATERIAL,  f.CANTIDAD*'"+p.getLotesFabricarMM()+"' cantidad,f.COD_UNIDAD_MEDIDA,3 cod_tipo_programa_prod,'MUESTRA MEDICA' nombre_tipo_programa_prod" +
                    " from programa_produccion ppr" +
                    " inner join componentes_prod cp on cp.cod_compprod = ppr.cod_compprod" +
                    " inner join formula_maestra fm on ppr.cod_formula_maestra = fm.cod_formula_maestra" +
                    " inner join componentes_presprod c on c.cod_compprod = fm.cod_compprod and c.COD_TIPO_PROGRAMA_PROD = 3" +
                    " inner join formula_maestra_detalle_es f on f.cod_formula_maestra = fm.cod_formula_maestra "+
                    " where ppr.cod_programa_prod = '"+p.getProgramaProduccion().getCodProgramaProduccion()+"' and f.COD_MATERIAL = '"+m.getMateriales().getCodMaterial()+"' "+
                    " and ppr.cod_formula_maestra in("+codFormulaMaestra+")"+

                    " union all" +
                    " select distinct cp.cod_compprod,cp.nombre_prod_semiterminado,f.COD_MATERIAL,f.CANTIDAD*'"+p.getLotesFabricarMI()+"' cantidad,f.COD_UNIDAD_MEDIDA,2 cod_tipo_programa_prod,'LICITACION' nombre_tipo_programa_prod" +
                    " from FORMULA_MAESTRA_DETALLE_MP f inner join programa_produccion p on p.cod_formula_maestra = f.cod_formula_maestra" +
                    " inner join componentes_prod cp on cp.cod_compprod = p.cod_compprod" +
                    " where p.cod_programa_prod = '"+p.getProgramaProduccion().getCodProgramaProduccion()+"'" +
                    " and f.COD_MATERIAL = '"+m.getMateriales().getCodMaterial()+"'" +
                    " and p.cod_formula_maestra in("+codFormulaMaestra+")" +
                    " union all" +
                    " select distinct cp.cod_compprod,cp.nombre_prod_semiterminado,f.COD_MATERIAL,  f.CANTIDAD*'"+p.getLotesFabricarMI()+"' cantidad, f.COD_UNIDAD_MEDIDA,2 cod_tipo_programa_prod,'LICITACION' nombre_tipo_programa_prod" +
                    " from programa_produccion ppr" +
                    " inner join componentes_prod cp on cp.cod_compprod = ppr.cod_compprod" +
                    " inner join presentaciones_primarias p on p.COD_TIPO_PROGRAMA_PROD= 2 and p.COD_COMPPROD = cp.COD_COMPPROD" +
                    " inner join formula_maestra_detalle_ep f on ppr.cod_formula_maestra = f.cod_formula_maestra and f.COD_PRESENTACION_PRIMARIA = p.COD_PRESENTACION_PRIMARIA" +
                    " where ppr.cod_programa_prod = '"+p.getProgramaProduccion().getCodProgramaProduccion()+"' and f.COD_MATERIAL = '"+m.getMateriales().getCodMaterial()+"' " + //--and p.cod_tipo_programa_prod = '1'
                    " and ppr.cod_formula_maestra in("+codFormulaMaestra+")" +
                    " union all" +
                    " select distinct cp.cod_compprod,cp.nombre_prod_semiterminado,f.COD_MATERIAL,  f.CANTIDAD*'"+p.getLotesFabricarMI()+"' cantidad,f.COD_UNIDAD_MEDIDA,2 cod_tipo_programa_prod,'LICITACION' nombre_tipo_programa_prod" +
                    " from programa_produccion ppr" +
                    " inner join componentes_prod cp on cp.cod_compprod = ppr.cod_compprod" +
                    " inner join formula_maestra fm on ppr.cod_formula_maestra = fm.cod_formula_maestra" +
                    " inner join componentes_presprod c on c.cod_compprod = fm.cod_compprod and c.COD_TIPO_PROGRAMA_PROD = 2" +
                    " inner join formula_maestra_detalle_es f on f.cod_formula_maestra = fm.cod_formula_maestra" +
                    " where ppr.cod_programa_prod = '"+p.getProgramaProduccion().getCodProgramaProduccion()+"' and f.COD_MATERIAL = '"+m.getMateriales().getCodMaterial()+"' "+
                    " and ppr.cod_formula_maestra in("+codFormulaMaestra+")";
            System.out.println("consulta de productos implicados con el material" + consulta);
            Connection con = null;
            con = Util.openConnection(con);
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery(consulta);
            while(rs.next()){
                if(rs.getDouble("cantidad")>0){ //solo para los materiales que estan implicados de acuerdo a los datos en MC MM MI
                ProductosConflicto p1 = new ProductosConflicto();
                p1.getProgramaProduccion().getFormulaMaestra().getComponentesProd().setCodCompprod(rs.getString("cod_compprod"));
                p1.getProgramaProduccion().getFormulaMaestra().getComponentesProd().setNombreProdSemiterminado(rs.getString("nombre_prod_semiterminado"));
                p1.getProgramaProduccion().getTiposProgramaProduccion().setCodTipoProgramaProd(rs.getString("cod_tipo_programa_prod"));
                p1.getProgramaProduccion().getTiposProgramaProduccion().setNombreTipoProgramaProd(rs.getString("nombre_tipo_programa_prod"));
                p1.setCantidad(rs.getDouble("cantidad"));
                productoConflictoList.add(p1);
                }
            }
            rs.close();
            st.close();
            con.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return  productoConflictoList;
    }

    public String  explosionMaquinaria_1() {
        List programaProduccionList1 = new ArrayList();
        Iterator i = productosProduccionList.iterator();
        
        List productosList = new ArrayList();
        while(i.hasNext()){
            ProductosProduccion p1 = (ProductosProduccion)i.next();
            if(p1.getChecked().booleanValue()==true){
                productosList.add(p1);
            }
        }
        FacesContext facesContext = FacesContext.getCurrentInstance();
        ExternalContext ec = facesContext.getExternalContext();
        Map map = ec.getSessionMap();
        map.put("programaProduccionList",this.productosProduccion(productosList));
        map.put("programaProduccion",programaProduccionbean);
        return null;
    }
    
    public List productosProduccion(List productosList){
        List productosProduccionList = new ArrayList();
        try {
            Iterator i = productosList.iterator();
            while(i.hasNext()){
                ProductosProduccion p = (ProductosProduccion) i.next();
                Connection con = null;
                con = Util.openConnection(con);
                Statement st = con.createStatement();
                String consulta = " select p.cod_programa_prod,p.cod_compprod,p.cod_formula_maestra,p.cod_tipo_programa_prod,p.cod_lote_produccion,p.cod_estado_programa" +
                        " from programa_produccion p where p.cod_programa_prod = '"+p.getProgramaProduccion().getCodProgramaProduccion()+"'" +
                        " and p.cod_formula_maestra = '"+p.getProgramaProduccion().getFormulaMaestra().getCodFormulaMaestra()+"' ";
                System.out.println("consulta " + consulta);
                ResultSet rs = st.executeQuery(consulta);
                while(rs.next()){
                    ProgramaProduccion prp = new ProgramaProduccion();
                    prp.setCodProgramaProduccion(rs.getString("cod_programa_prod"));
                    prp.getFormulaMaestra().getComponentesProd().setCodCompprod(rs.getString("cod_compprod"));
                    prp.getFormulaMaestra().setCodFormulaMaestra(rs.getString("cod_formula_maestra"));
                    prp.getTiposProgramaProduccion().setCodTipoProgramaProd(rs.getString("cod_tipo_programa_prod"));
                    prp.setCodLoteProduccion(rs.getString("cod_lote_produccion"));
                    prp.getEstadoProgramaProduccion().setCodEstadoProgramaProd(rs.getString("cod_estado_programa"));
                    productosProduccionList.add(prp);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return productosProduccionList;
    }
    public String explosionMaquinarias(){
        try {
            List programaProduccionList1 = new ArrayList();
            Iterator i = productosProducirList.iterator();
            while(i.hasNext()){
                ProgramaProduccion programaProduccion = (ProgramaProduccion)i.next();
                if(programaProduccion.getChecked().booleanValue()==true){
                    programaProduccionList1.add(programaProduccion);
                }
            }
            FacesContext facesContext = FacesContext.getCurrentInstance();
            ExternalContext ec = facesContext.getExternalContext();
            Map map = ec.getSessionMap();
            map.put("programaProduccionList",programaProduccionList1);
            map.put("programaProduccion",programaProduccionbean);
            return null;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }



    
    class MaquinaHombre{
        String codMaquinaria="";
        String nombreMaquinaria="";
        float horas_hombre;
        float horas_maquina;
    }
    
        public ProgramaProduccionPeriodo getProgramaProduccionPeriodoClonar() {
            return programaProduccionPeriodoClonar;
        }

    public void setProgramaProduccionPeriodoClonar(ProgramaProduccionPeriodo programaProduccionPeriodoClonar) {
        this.programaProduccionPeriodoClonar = programaProduccionPeriodoClonar;
    }

    public ProgramaProduccionPeriodo getProgramaProduccionPeriodoClonarNuevo() {
        return programaProduccionPeriodoClonarNuevo;
    }

    //<editor-fold desc="getter and setter" defaultstate="collapsed">
    public void setProgramaProduccionPeriodoClonarNuevo(ProgramaProduccionPeriodo programaProduccionPeriodoClonarNuevo) {
        this.programaProduccionPeriodoClonarNuevo = programaProduccionPeriodoClonarNuevo;
    }

    public ProgramaProduccion getProgramaProduccionbean() {
        return programaProduccionbean;
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

        public List getFormulaMaestraList() {
            return formulaMaestraList;
        }

        public void setFormulaMaestraList(List formulaMaestraList) {
            this.formulaMaestraList = formulaMaestraList;
        }

        public List getFormulaMaestraMPROMList() {
            return formulaMaestraMPROMList;
        }

        public void setFormulaMaestraMPROMList(List formulaMaestraMPROMList) {
            this.formulaMaestraMPROMList = formulaMaestraMPROMList;
        }

        public List getFormulaMaestraMPList() {
            return formulaMaestraMPList;
        }

        public void setFormulaMaestraMPList(List formulaMaestraMPList) {
            this.formulaMaestraMPList = formulaMaestraMPList;
        }

        public List getFormulaMaestraEPList() {
            return formulaMaestraEPList;
        }

        public void setFormulaMaestraEPList(List formulaMaestraEPList) {
            this.formulaMaestraEPList = formulaMaestraEPList;
        }

        public List getFormulaMaestraESList() {
            return formulaMaestraESList;
        }

        public void setFormulaMaestraESList(List formulaMaestraESList) {
            this.formulaMaestraESList = formulaMaestraESList;
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

        public List getAreasEmpresaList() {
            return areasEmpresaList;
        }

        public void setAreasEmpresaList(List areasEmpresaList) {
            this.areasEmpresaList = areasEmpresaList;
        }

        public String getCodProgramaProd() {
            return codProgramaProd;
        }

        public void setCodProgramaProd(String codProgramaProd) {
            this.codProgramaProd = codProgramaProd;
        }

        public List getTiposProgramaProdList() {
            return tiposProgramaProdList;
        }

        public void setTiposProgramaProdList(List tiposProgramaProdList) {
            this.tiposProgramaProdList = tiposProgramaProdList;
        }

        public List getFormulaMaestraMPReactivosList() {
            return formulaMaestraMPReactivosList;
        }

        public void setFormulaMaestraMPReactivosList(List formulaMaestraMPReactivosList) {
            this.formulaMaestraMPReactivosList = formulaMaestraMPReactivosList;
        }

        public List getFormulaMaestraMRList() {
            return formulaMaestraMRList;
        }

        public void setFormulaMaestraMRList(List formulaMaestraMRList) {
            this.formulaMaestraMRList = formulaMaestraMRList;
        }

        public List<String[]> getExplotacionMaquinariasLista() {
            return explotacionMaquinariasLista;
        }

        public void setExplotacionMaquinariasLista(List<String[]> explotacionMaquinariasLista) {
            this.explotacionMaquinariasLista = explotacionMaquinariasLista;
        }

        public float getHrs_maquina() {
            return hrs_maquina;
        }

        public void setHrs_maquina(float hrs_maquina) {
            this.hrs_maquina = hrs_maquina;
        }

        public float getHrs_hombre() {
            return hrs_hombre;
        }

        public void setHrs_hombre(float hrs_hombre) {
            this.hrs_hombre = hrs_hombre;
        }

        public double getTotalLote() {
            return totalLote;
        }

        public void setTotalLote(double totalLote) {
            this.totalLote = totalLote;
        }

        public List getProgramaProduccionProductoList() {
            return programaProduccionProductoList;
        }

        public void setProgramaProduccionProductoList(List programaProduccionProductoList) {
            this.programaProduccionProductoList = programaProduccionProductoList;
        }

        public HtmlDataTable getProgramaProduccionDataTable() {
            return programaProduccionDataTable;
        }

        public void setProgramaProduccionDataTable(HtmlDataTable programaProduccionDataTable) {
            this.programaProduccionDataTable = programaProduccionDataTable;
        }

        public List getProgramaProduccionLotesList() {
            return programaProduccionLotesList;
        }

        public void setProgramaProduccionLotesList(List programaProduccionLotesList) {
            this.programaProduccionLotesList = programaProduccionLotesList;
        }

        public String getMensaje() {
            return mensaje;
        }

        public void setMensaje(String mensaje) {
            this.mensaje = mensaje;
        }

        public List getProgramaProduccionProductosList() {
            return programaProduccionProductosList;
        }

        public void setProgramaProduccionProductosList(List programaProduccionProductosList) {
            this.programaProduccionProductosList = programaProduccionProductosList;
        }

        public HtmlDataTable getProgramaProduccionProductosDataTable() {
            return programaProduccionProductosDataTable;
        }

        public void setProgramaProduccionProductosDataTable(HtmlDataTable programaProduccionProductosDataTable) {
            this.programaProduccionProductosDataTable = programaProduccionProductosDataTable;
        }

        public HtmlDataTable getProgramaProduccionLotesDataTable() {
            return programaProduccionLotesDataTable;
        }

        public void setProgramaProduccionLotesDataTable(HtmlDataTable programaProduccionLotesDataTable) {
            this.programaProduccionLotesDataTable = programaProduccionLotesDataTable;
        }

        public List getProgramaProduccionAgregarList() {
            return programaProduccionAgregarList;
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

        public ProgramaProduccion getProgramaProduccionSeleccionado() {
            return programaProduccionSeleccionado;
        }

        public void setProgramaProduccionSeleccionado(ProgramaProduccion programaProduccionSeleccionado) {
            this.programaProduccionSeleccionado = programaProduccionSeleccionado;
        }

        public List getProgramaProduccionEditarList() {
            return programaProduccionEditarList;
        }

        public void setProgramaProduccionEditarList(List programaProduccionEditarList) {
            this.programaProduccionEditarList = programaProduccionEditarList;
        }

        public HtmlDataTable getProgramaProduccionEditarDataTable() {
            return programaProduccionEditarDataTable;
        }

        public void setProgramaProduccionEditarDataTable(HtmlDataTable programaProduccionEditarDataTable) {
            this.programaProduccionEditarDataTable = programaProduccionEditarDataTable;
        }

        public List getLugaresAcondList() {
            return lugaresAcondList;
        }

        public void setLugaresAcondList(List lugaresAcondList) {
            this.lugaresAcondList = lugaresAcondList;
        }

        public List getComponenteProdList() {
            return componenteProdList;
        }

        public void setComponenteProdList(List componenteProdList) {
            this.componenteProdList = componenteProdList;
        }

        public List getProductosProduccionList() {
            return productosProduccionList;
        }

        public void setProductosProduccionList(List productosProduccionList) {
            this.productosProduccionList = productosProduccionList;
        }

        public List getMaterialesConflictoList() {
            return materialesConflictoList;
        }

        public void setMaterialesConflictoList(List materialesConflictoList) {
            this.materialesConflictoList = materialesConflictoList;
        }

        public int getMaterialConflicto() {
            return materialConflicto;
        }

        public void setMaterialConflicto(int materialConflicto) {
            this.materialConflicto = materialConflicto;
        }

        public List getProductosProducirList() {
            return productosProducirList;
        }

        public void setProductosProducirList(List productosProducirList) {
            this.productosProducirList = productosProducirList;
        }

        public List<FormulaMaestra> getFormulaMaestraAgregarList() {
            return formulaMaestraAgregarList;
        }

        public void setFormulaMaestraAgregarList(List<FormulaMaestra> formulaMaestraAgregarList) {
            this.formulaMaestraAgregarList = formulaMaestraAgregarList;
        }

        public ProgramaProduccion getProgramaProduccionCabeceraAgregar() {
            return programaProduccionCabeceraAgregar;
        }

        public void setProgramaProduccionCabeceraAgregar(ProgramaProduccion programaProduccionCabeceraAgregar) {
            this.programaProduccionCabeceraAgregar = programaProduccionCabeceraAgregar;
        }

        public List<ProductosDivisionLotes> getProductosDivisionLotesList() {
            return productosDivisionLotesList;
        }

        public void setProductosDivisionLotesList(List<ProductosDivisionLotes> productosDivisionLotesList) {
            this.productosDivisionLotesList = productosDivisionLotesList;
        }

        public ProgramaProduccion getProgramaProduccionCabeceraEditar() {
            return programaProduccionCabeceraEditar;
        }

        public void setProgramaProduccionCabeceraEditar(ProgramaProduccion programaProduccionCabeceraEditar) {
            this.programaProduccionCabeceraEditar = programaProduccionCabeceraEditar;
        }

        public List<SelectItem> getAlmacenesSelectList() {
            return almacenesSelectList;
        }

        public void setAlmacenesSelectList(List<SelectItem> almacenesSelectList) {
            this.almacenesSelectList = almacenesSelectList;
        }

        public List<Integer> getAlmacenesList() {
            return almacenesList;
        }

        public void setAlmacenesList(List<Integer> almacenesList) {
            this.almacenesList = almacenesList;
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

        public List<SelectItem> getAreasFabricacionProduccionList() {
            return areasFabricacionProduccionList;
        }

        public void setAreasFabricacionProduccionList(List<SelectItem> areasFabricacionProduccionList) {
            this.areasFabricacionProduccionList = areasFabricacionProduccionList;
        }

        public List<String> getCodAreasFabricacionProduccionList() {
            return codAreasFabricacionProduccionList;
        }

        public void setCodAreasFabricacionProduccionList(List<String> codAreasFabricacionProduccionList) {
            this.codAreasFabricacionProduccionList = codAreasFabricacionProduccionList;
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
        
    //</editor-fold>

    

    
    
    
    
    
}
