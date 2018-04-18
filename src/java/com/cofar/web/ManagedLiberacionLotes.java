/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.web;

import com.cofar.bean.util.correos.EnvioCorreoDesviacionLiberacionBajoRiesgo;
import com.cofar.bean.util.correos.EnvioCorreoLiberacionLotes;
import com.cofar.bean.ventas.IngresosDetalleVentas;
import com.cofar.bean.ventas.IngresosVentas;
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
import javax.faces.context.FacesContext;
import javax.faces.model.SelectItem;
import javax.servlet.ServletContext;
import org.apache.logging.log4j.LogManager;
import org.richfaces.component.html.HtmlDataTable;

/**
 *
 * @author DASISAQ
 */
public class ManagedLiberacionLotes extends ManagedBean 
{
    private static int COD_TIPO_REPORTE_DESVIACION_BAJO_RIESGO = 7;
    private static int COD_ESTADO_DESVIACION_ESTIMADA = 3;
    private String mensaje="";
    private Connection con =null;
    private List<IngresosVentas> liberacionLotesList;
    private HtmlDataTable liberacionLotesDataTable=new HtmlDataTable();
    private IngresosVentas liberacionLoteBean;
    private List<SelectItem> tiposLiberacionSelectList;
    private List<SelectItem> almacenesVentasCuarentenaSelectList;
    private List<SelectItem> tiposIngresosVentasSelectList;
    private List<SelectItem> presentacionesProductoSelectList;
    private int codPresentacionBuscar=0;
    private Date fechaIngresoInicio=null;
    private Date fechaIngresoFinal=null;
    private IngresosVentas ingresosVentasBuscar=new IngresosVentas();

    /**
     * Creates a new instance of ManagedLiberacionLotes
     */
    public ManagedLiberacionLotes() {
        LOGGER=LogManager.getLogger("LiberacionLotes");
        begin=0;
        end=20;
        numrows=20;
        
    }
    public String buscarLiberacionLote_action()
    {
        begin=0;
        end=20;
        this.cargarLiberacionLotesList();
        return null;
    }
    private void cargarPresentacionesProductoSelectList()
    {
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select pp.cod_presentacion,pp.NOMBRE_PRODUCTO_PRESENTACION");
                                        consulta.append(" from PRESENTACIONES_PRODUCTO pp");
                                        consulta.append(" where pp.cod_estado_registro=1");
                                        consulta.append(" order by pp.NOMBRE_PRODUCTO_PRESENTACION");
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            presentacionesProductoSelectList=new ArrayList<SelectItem>();
            while (res.next()) 
            {
                presentacionesProductoSelectList.add(new SelectItem(res.getInt("cod_presentacion"),res.getString("NOMBRE_PRODUCTO_PRESENTACION")));
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
    private void cargarTiposIngresosSelectList()
    {
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select ti.cod_tipoingresoventas,ti.nombre_tipoingresoventas ");
                                        consulta.append(" from TIPOS_INGRESOVENTAS ti where ti.cod_tipoingresoventas < 7");
                                        consulta.append(" order by ti.nombre_tipoingresoventas");
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            tiposIngresosVentasSelectList=new ArrayList<SelectItem>();
            while (res.next()) 
            {
                tiposIngresosVentasSelectList.add(new SelectItem(res.getInt("cod_tipoingresoventas"),res.getString("nombre_tipoingresoventas")));
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
    private void cargarAlmacenesCuarentenaSelectList()
    {
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select av.COD_ALMACEN_VENTA,av.NOMBRE_ALMACEN_VENTA");
                                        consulta.append(" from ALMACENES_VENTAS_LIBERACION_LOTE avl");
                                                consulta.append(" inner join ALMACENES_VENTAS av on av.COD_ALMACEN_VENTA=avl.COD_ALMACEN_VENTA_ORIGEN");
                                        consulta.append(" where avl.COD_ESTADO_REGISTRO=1");
                                        consulta.append(" order by av.NOMBRE_ALMACEN_VENTA");
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            almacenesVentasCuarentenaSelectList=new ArrayList<SelectItem>();
            while (res.next()) 
            {
                almacenesVentasCuarentenaSelectList.add(new SelectItem(res.getInt("COD_ALMACEN_VENTA"),res.getString("NOMBRE_ALMACEN_VENTA")));
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
    public String getCargarLiberacionLotesList()
    {
        this.cargarPresentacionesProductoSelectList();
        this.cargarAlmacenesCuarentenaSelectList();
        this.cargarTiposLiberacionLoteSelectList();
        this.cargarTiposIngresosSelectList();
        this.cargarLiberacionLotesList();
        return null;
    }
    private void cargarTiposLiberacionLoteSelectList()
    {
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select tll.COD_TIPO_LIBERACION_LOTE,tll.NOMBRE_TIPO_LIBERACION_LOTE");
                                        consulta.append(" from TIPOS_LIBERACION_LOTE tll");
                                        consulta.append(" order by tll.NOMBRE_TIPO_LIBERACION_LOTE");
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            tiposLiberacionSelectList=new ArrayList<SelectItem>();
            while (res.next()) 
            {
                tiposLiberacionSelectList.add(new SelectItem(res.getInt("COD_TIPO_LIBERACION_LOTE"),res.getString("NOMBRE_TIPO_LIBERACION_LOTE")));
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
    public String siguienteLiberacionLotesList_action() 
    {
        super.next();
        this.cargarLiberacionLotesList();
        return null;
    }

    public String atrasLiberacionLotesList_action() 
    {
        super.back();
        this.cargarLiberacionLotesList();
        return null;
    }
    public String seleccionarLiberacionLote_action()
    {
        liberacionLoteBean=(IngresosVentas)liberacionLotesDataTable.getRowData();
        return null;
    }
    public String guardarLiberarLote_action()throws SQLException
    {
        LOGGER.debug("--------------------------------INICIO LIBERAR LOTE-------------------------------");
        mensaje = "";
        EnvioCorreoLiberacionLotes correo=null;
        try {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            ManagedAccesoSistema managed=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
            StringBuilder consulta = new StringBuilder("exec PAA_REGISTRO_LIBERACION_LOTE ");
                                    consulta.append(liberacionLoteBean.getCodIngresoVentas()).append(",");
                                    consulta.append(managed.getUsuarioModuloBean().getCodUsuarioGlobal()).append(",");
                                    consulta.append(liberacionLoteBean.getLiberacionLotes().getTiposLiberacionLote().getCodTipoLiberacionLote()).append(",");
                                    consulta.append("?");
            LOGGER.debug(" consulta registrar liberacion lote " + consulta.toString());
            CallableStatement  callLiberacion = con.prepareCall(consulta.toString());
            callLiberacion.registerOutParameter(1,java.sql.Types.INTEGER);
            if (callLiberacion.execute()) LOGGER.info("se registro la liberacion ");
            if(liberacionLoteBean.getLiberacionLotes().getTiposLiberacionLote().getCodTipoLiberacionLote()  == 2)
            {
                consulta = new StringBuilder("select count(*) as cantidadDesviaciones")
                                    .append(" from DESVIACION d")
                                            .append(" inner join DESVIACION_PROGRAMA_PRODUCCION dpp on dpp.COD_DESVIACION = d.COD_DESVIACION")
                                    .append(" where dpp.COD_LOTE_PRODUCCION = '").append(liberacionLoteBean.getIngresosDetalleVentasList().get(0).getCodLoteProduccion()).append("'")
                                            .append(" and d.COD_TIPO_REPORTE_DESVIACION = ").append(COD_TIPO_REPORTE_DESVIACION_BAJO_RIESGO)
                                            .append(" and d.COD_ESTADO_DESVIACION <> ").append(COD_ESTADO_DESVIACION_ESTIMADA);
                LOGGER.debug("consulta verificar desviaciones por liberacion bajo riesgo: "+consulta.toString());
                Statement st = con.createStatement();
                ResultSet res = st.executeQuery(consulta.toString());
                res.next();
                if(res.getInt("cantidadDesviaciones") == 0){
                    LOGGER.debug("---------------INICIO GENERAR DESVIACION POR LIBERACION BAJO RIESGO-------------");
                    int codLiberacionLote = callLiberacion.getInt(1);
                    consulta  = new StringBuilder("exec PAA_GENERACION_DESVIACION_LIBERACION_BAJO_RIESGO ")
                                    .append(codLiberacionLote).append(",")
                                    .append("?");
                    LOGGER.debug("consulta generar desviacion liberacion bajo riesgo "+consulta.toString());
                    CallableStatement  callDesviacion = con.prepareCall(consulta.toString());
                    callDesviacion.registerOutParameter(1,java.sql.Types.INTEGER);
                    callDesviacion.execute();
                    int codDesviacion=callDesviacion.getInt(1);
                    EnvioCorreoDesviacionLiberacionBajoRiesgo correoDesviacion = new EnvioCorreoDesviacionLiberacionBajoRiesgo(codDesviacion,(ServletContext)FacesContext.getCurrentInstance().getExternalContext().getContext());
                    correoDesviacion.start();
                    LOGGER.debug("---------------TERMINO GENERAR DESVIACION POR LIBERACION BAJO RIESGO-------------");
                }
                else{
                    LOGGER.debug("El lote ya contaba con una desviacion");
                }
            }
            con.commit();
            mensaje = "1";
            correo=new EnvioCorreoLiberacionLotes(liberacionLoteBean.getCodIngresoVentas());
        } catch (SQLException ex) {
            LOGGER.warn("error", ex);
            mensaje = "Ocurrio un error al momento de guardar el registro; "+ex.getMessage();
            con.rollback();
        } catch (Exception ex) {
            mensaje = "Ocurrio un error al momento de guardar el registro,verifique los datos introducidos;"+ex.getMessage();
            LOGGER.warn(ex.getMessage());
        } finally {
            this.cerrarConexion(con);
        }
        LOGGER.debug("--------------------------------TERMINO LIBERAR LOTE-------------------------------");
        if(correo!=null)
        {
            correo.start();
        }
        return null;
    }
    private void cargarLiberacionLotesList()
    {
        this.cargarTiposLiberacionLoteSelectList();
        try {
            con = Util.openConnection(con);
            SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");
            StringBuilder consulta = new StringBuilder(" select * from (");
                                            consulta.append(" select ROW_NUMBER() OVER (ORDER BY iv.FECHA_INGRESOVENTAS desc) as 'FILAS',");
                                                    consulta.append(" iv.COD_GESTION,iv.COD_INGRESOVENTAS,iv.COD_ALMACEN_VENTA,av.NOMBRE_ALMACEN_VENTA,iv.NRO_INGRESOVENTAS,iv.FECHA_INGRESOVENTAS,");
                                                    consulta.append(" iv.COD_ESTADO_INGRESOVENTAS,eiv.NOMBRE_ESTADO_INGRESOVENTAS,eiv.NOMBRE_ESTADO_INGRESO_CUARENTENA,iv.COD_TIPOINGRESOVENTAS,ti.nombre_tipoingresoventas,iv.cod_cliente,c.nombre_cliente");
                                                    consulta.append(" ,iv.OBS_INGRESOVENTAS,pp.NOMBRE_PRODUCTO_PRESENTACION,idv.COD_LOTE_PRODUCCION,idv.FECHA_VENC,idv.CANTIDAD,idv.CANTIDAD_UNITARIA");
                                                    consulta.append(" ,isnull(tll.NOMBRE_TIPO_LIBERACION_LOTE,'') as NOMBRE_TIPO_LIBERACION_LOTE")
                                                            .append(" ,datosCC.fechaEmision");
                                            consulta.append(" from INGRESOS_VENTAS iv ");
                                                    consulta.append(" inner join ALMACENES_VENTAS av on av.COD_ALMACEN_VENTA=iv.COD_ALMACEN_VENTA");
                                                    consulta.append(" left outer join CLIENTES c on c.cod_cliente=iv.COD_CLIENTE");
                                                    consulta.append(" left outer join TIPOS_INGRESOVENTAS ti on ti.cod_tipoingresoventas=iv.COD_TIPOINGRESOVENTAS");
                                                    consulta.append(" left outer join ESTADOS_INGRESOVENTAS eiv on eiv.COD_ESTADO_INGRESOVENTAS=iv.COD_ESTADO_INGRESOVENTAS");
                                                    consulta.append(" inner join INGRESOS_DETALLEVENTAS idv on idv.COD_INGRESOVENTAS=iv.COD_INGRESOVENTAS");
                                                    consulta.append(" inner join PRESENTACIONES_PRODUCTO pp on pp.cod_presentacion=idv.COD_PRESENTACION");
                                                    consulta.append(" left outer join LIBERACION_LOTES ll on ll.COD_INGRESOVENTAS=iv.COD_INGRESOVENTAS");
                                                    consulta.append(" left outer join TIPOS_LIBERACION_LOTE tll on tll.COD_TIPO_LIBERACION_LOTE=ll.COD_TIPO_LIBERACION_LOTE")
                                                            .append(" outer apply(")
                                                                    .append(" SELECT top 1 ra.FECHA_EMISION as fechaEmision")
                                                                    .append(" from RESULTADO_ANALISIS ra")
                                                                    .append(" inner join PROGRAMA_PRODUCCION pp on pp.COD_LOTE_PRODUCCION = ra.COD_LOTE ")
                                                                    .append(" and ra.COD_COMPROD = pp.COD_COMPPROD")
                                                                    .append(" where ra.COD_LOTE = idv.COD_LOTE_PRODUCCION collate traditional_spanish_ci_ai")
                                                                    .append(" and ra.COD_ESTADO_RESULTADO_ANALISIS=1")
                                                            .append(" ) as datosCC");
                                            consulta.append(" where iv.COD_ALMACEN_VENTA in (54,56,57) ");
                                                    if(ingresosVentasBuscar.getAlmacenesVentas().getCodAlmacenVenta()>0)
                                                        consulta.append(" and iv.COD_ALMACEN_VENTA=").append(ingresosVentasBuscar.getAlmacenesVentas().getCodAlmacenVenta());
                                                    if(ingresosVentasBuscar.getEstadosIngresoVentas().getCodEstadoIngresoVentas()>0)
                                                        consulta.append(" and iv.COD_ESTADO_INGRESOVENTAS=").append(ingresosVentasBuscar.getEstadosIngresoVentas().getCodEstadoIngresoVentas());
                                                    if(fechaIngresoInicio!=null&&fechaIngresoFinal!=null)
                                                        consulta.append(" and iv.FECHA_INGRESOVENTAS between '").append(sdf.format(fechaIngresoInicio)).append(" 00:00' and '").append(sdf.format(fechaIngresoFinal)).append(" 23:59'");
                                                    if(ingresosVentasBuscar.getTiposIngresoVentas().getCodTipoIngresoVentas()>0)
                                                        consulta.append(" and iv.COD_TIPOINGRESOVENTAS=").append(ingresosVentasBuscar.getTiposIngresoVentas().getCodTipoIngresoVentas());
                                                    if(ingresosVentasBuscar.getNroIngresoVentas()>0)
                                                        consulta.append(" and iv.NRO_INGRESOVENTAS=").append(ingresosVentasBuscar.getNroIngresoVentas());
                                                    if(codPresentacionBuscar>0)
                                                        consulta.append(" and idv.COD_PRESENTACION=").append(codPresentacionBuscar);
                                                    if(ingresosVentasBuscar.getLiberacionLotes().getCodLoteProduccion().length()>0)
                                                        consulta.append(" and idv.COD_LOTE_PRODUCCION='").append(ingresosVentasBuscar.getLiberacionLotes().getCodLoteProduccion()).append("'");
                                        consulta.append(" ) as INGRESOS");
                                        consulta.append(" WHERE FILAS BETWEEN ").append(begin).append(" AND ").append(end);
            LOGGER.debug(" consulta cargar ingresos para liberacion de lotes " + consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            liberacionLotesList=new ArrayList<IngresosVentas>();
            IngresosVentas nuevo=new IngresosVentas();
            cantidadfilas=0;
            while (res.next()) 
            {
                if(nuevo.getCodIngresoVentas()!=res.getInt("COD_INGRESOVENTAS"))
                {
                    if(nuevo.getCodIngresoVentas()>0)
                    {
                        liberacionLotesList.add(nuevo);
                    }
                    nuevo=new IngresosVentas();
                    nuevo.setChecked(res.getTimestamp("fechaEmision")!=null);
                    nuevo.setCodIngresoVentas(res.getInt("COD_INGRESOVENTAS"));
                    nuevo.getAlmacenesVentas().setCodAlmacenVenta(res.getInt("COD_ALMACEN_VENTA"));
                    nuevo.getAlmacenesVentas().setNombreAlmacenVenta(res.getString("NOMBRE_ALMACEN_VENTA"));
                    nuevo.setNroIngresoVentas(res.getInt("NRO_INGRESOVENTAS"));
                    nuevo.setFechaIngresoVentas(res.getTimestamp("FECHA_INGRESOVENTAS"));
                    nuevo.getEstadosIngresoVentas().setCodEstadoIngresoVentas(res.getInt("COD_ESTADO_INGRESOVENTAS"));
                    nuevo.getEstadosIngresoVentas().setNombreEstadosIngresoVentas(res.getString("NOMBRE_ESTADO_INGRESOVENTAS"));
                    nuevo.getEstadosIngresoVentas().setNombreEstadoIngresoVentasCuarentena(res.getString("NOMBRE_ESTADO_INGRESO_CUARENTENA")+(res.getString("NOMBRE_TIPO_LIBERACION_LOTE").length()>0?"("+res.getString("NOMBRE_TIPO_LIBERACION_LOTE")+")":""));
                    nuevo.getTiposIngresoVentas().setCodTipoIngresoVentas(res.getInt("COD_TIPOINGRESOVENTAS"));
                    nuevo.getTiposIngresoVentas().setNombreTipoIngresoVentas(res.getString("nombre_tipoingresoventas"));
                    nuevo.getClientes().setCodCliente(res.getInt("cod_cliente"));
                    nuevo.getClientes().setNombreCliente(res.getString("nombre_cliente"));
                    nuevo.setObsIngresoVentas(res.getString("OBS_INGRESOVENTAS"));
                    nuevo.setIngresosDetalleVentasList(new ArrayList<IngresosDetalleVentas>());
                }
                IngresosDetalleVentas bean=new IngresosDetalleVentas();
                bean.getPresentacionesProducto().setNombreProductoPresentacion(res.getString("NOMBRE_PRODUCTO_PRESENTACION"));
                bean.setCodLoteProduccion(res.getString("COD_LOTE_PRODUCCION"));
                bean.setFechaVencimiento(res.getTimestamp("FECHA_VENC"));
                bean.setCantidad(res.getDouble("CANTIDAD"));
                bean.setCantidadUnitaria(res.getDouble("CANTIDAD_UNITARIA"));
                nuevo.getIngresosDetalleVentasList().add(bean);
                cantidadfilas++;
            }
            if(nuevo.getCodIngresoVentas()>0)
            {
                liberacionLotesList.add(nuevo);
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
    //<editor-fold desc="getter and setter" defaultstate="collapsed">

        public List<SelectItem> getTiposLiberacionSelectList() {
            return tiposLiberacionSelectList;
        }

        public void setTiposLiberacionSelectList(List<SelectItem> tiposLiberacionSelectList) {
            this.tiposLiberacionSelectList = tiposLiberacionSelectList;
        }

        public List<SelectItem> getAlmacenesVentasCuarentenaSelectList() {
            return almacenesVentasCuarentenaSelectList;
        }

        public void setAlmacenesVentasCuarentenaSelectList(List<SelectItem> almacenesVentasCuarentenaSelectList) {
            this.almacenesVentasCuarentenaSelectList = almacenesVentasCuarentenaSelectList;
        }

        public IngresosVentas getIngresosVentasBuscar() {
            return ingresosVentasBuscar;
        }

        public void setIngresosVentasBuscar(IngresosVentas ingresosVentasBuscar) {
            this.ingresosVentasBuscar = ingresosVentasBuscar;
        }

        public List<SelectItem> getTiposIngresosVentasSelectList() {
            return tiposIngresosVentasSelectList;
        }

        public void setTiposIngresosVentasSelectList(List<SelectItem> tiposIngresosVentasSelectList) {
            this.tiposIngresosVentasSelectList = tiposIngresosVentasSelectList;
        }

        public Date getFechaIngresoInicio() {
            return fechaIngresoInicio;
        }

        public void setFechaIngresoInicio(Date fechaIngresoInicio) {
            this.fechaIngresoInicio = fechaIngresoInicio;
        }

        public Date getFechaIngresoFinal() {
            return fechaIngresoFinal;
        }

        public void setFechaIngresoFinal(Date fechaIngresoFinal) {
            this.fechaIngresoFinal = fechaIngresoFinal;
        }


        public List<SelectItem> getPresentacionesProductoSelectList() {
            return presentacionesProductoSelectList;
        }

        public void setPresentacionesProductoSelectList(List<SelectItem> presentacionesProductoSelectList) {
            this.presentacionesProductoSelectList = presentacionesProductoSelectList;
        }

        public int getCodPresentacionBuscar() {
            return codPresentacionBuscar;
        }

        public void setCodPresentacionBuscar(int codPresentacionBuscar) {
            this.codPresentacionBuscar = codPresentacionBuscar;
        }

        public IngresosVentas getLiberacionLoteBean() {
            return liberacionLoteBean;
        }

        public void setLiberacionLoteBean(IngresosVentas liberacionLoteBean) {
            this.liberacionLoteBean = liberacionLoteBean;
        }
        
        public HtmlDataTable getLiberacionLotesDataTable() {
            return liberacionLotesDataTable;
        }

        public void setLiberacionLotesDataTable(HtmlDataTable liberacionLotesDataTable) {
            this.liberacionLotesDataTable = liberacionLotesDataTable;
        }


        public String getMensaje() {
            return mensaje;
        }

        public void setMensaje(String mensaje) {
            this.mensaje = mensaje;
        }

        public List<IngresosVentas> getLiberacionLotesList() {
            return liberacionLotesList;
        }

        public void setLiberacionLotesList(List<IngresosVentas> liberacionLotesList) {
            this.liberacionLotesList = liberacionLotesList;
        }
    //</editor-fold>
}
