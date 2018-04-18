/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.web;

import com.cofar.bean.Personal;
import com.cofar.bean.SolicitudMantenimiento;
import com.cofar.bean.SolicitudMantenimientoDetalleMateriales;
import com.cofar.bean.SolicitudMantenimientoDetalleTareas;
import com.cofar.bean.SolicitudMantenimientoSolicitudSalidaAlmacen;
import com.cofar.util.Util;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import javax.faces.context.ExternalContext;
import javax.faces.context.FacesContext;
import javax.faces.model.SelectItem;
import org.apache.logging.log4j.LogManager;
import org.richfaces.component.html.HtmlDataTable;

/**
 *
 * @author hvaldivia
 */

public class ManagedAprobacionSolicitudMantenimiento extends ManagedBean
{
    //<editor-fold desc="variables">
        private Connection con;
        private String mensaje="";
        private List<SolicitudMantenimiento> solicitudMantenimientoAprobacionList;
        private SolicitudMantenimiento solicitudMantenimientoBuscar=new SolicitudMantenimiento();
        private SolicitudMantenimiento solicitudMantenimientoAnular;
        private SolicitudMantenimiento solicitudMantenimientoTarea;
        private SolicitudMantenimiento solicitudMantenimientoSolicitudSalidaAlmacen;
        private HtmlDataTable solicitudMantenimientoAprobacionDataTable=new HtmlDataTable();
        private List<SolicitudMantenimientoDetalleTareas> solicitudMantenimientoDetalleTareasList;
        private List<SelectItem> personalSelectList;
        private List<SelectItem> almacenesSelectList;
        private List<SelectItem> tiposTareaSelectList;
        private List<SelectItem> proveedoresSelectList;
        private List<SelectItem> maquinariaSelectList;
        private SolicitudMantenimientoDetalleTareas solicitudMantenimientoDetalleTareaAgregar;
        private SolicitudMantenimientoDetalleTareas solicitudMantenimientoDetalleTareaEditar;
        private String[] codPersonalAgregarAsignar;
        private SolicitudMantenimiento solicitudMantenimientoDescribirEstado;
        private SolicitudMantenimiento solicitudMantenimientoAprobar;
        //select  listas
        private List<SelectItem> areasEmpresaSelectList;
        private List<SelectItem> tiposSolicitudMantenimientoSelectList;
        private List<SelectItem> tiposNivelSolicitudMantenimientoSelectList;
        private List<SelectItem> estadosSolicitudMantenimientoSelectList;
        private List<SelectItem> personalSolicitudMantenimientoSelectList;
        //solicitud de materiales
        private List<SolicitudMantenimientoSolicitudSalidaAlmacen> solicitudMantenimientoSolicitudSalidaAlmacenList;
        private SolicitudMantenimientoDetalleMateriales solicitudMantenimientoDetalleMaterialBuscar;
        private List<SolicitudMantenimientoDetalleMateriales> solicitudMantenimientoDetalleMaterialesList;
        private HtmlDataTable solicitudMantenimientoDetalleMaterialesDataTable=new HtmlDataTable();
        private SolicitudMantenimientoSolicitudSalidaAlmacen solicitudMantenimientoSolicitudSalidaAlmacenAgregar;
        private SolicitudMantenimientoSolicitudSalidaAlmacen solicitudMantenimientoSolicitudSalidaAlmacenGenerarSalida;
    //</editor-fold>
    //<editor-fold desc="constructor">

        public ManagedAprobacionSolicitudMantenimiento() 
        {
            LOGGER=LogManager.getLogger("Mantenimiento");
            solicitudMantenimientoBuscar.getAreasEmpresa().setCodAreaEmpresa("0");
            solicitudMantenimientoBuscar.getMaquinaria().setCodMaquina("0");
            solicitudMantenimientoBuscar.getPersonal_usuario().setCodPersonal("0");
            numrows=10;
        }
    
    //</editor-fold>
    //<editor-fold desc="funciones">
        //<editor-fold desc="solicitud mantenimiento materiales" defaultstate="collapsed">
        
            private void cargarAlmacenesSelectList()
            {
                try {
                    con = Util.openConnection(con);
                    StringBuilder consulta = new StringBuilder("select a.COD_ALMACEN,a.NOMBRE_ALMACEN")
                                                    .append(" from ALMACENES a ")
                                                    .append(" where a.COD_ESTADO_REGISTRO=1")
                                                            .append(" and a.COD_ALMACEN not in (4,14)")
                                                    .append(" order by a.NOMBRE_ALMACEN");
                    LOGGER.debug("consulta cargar ");
                    Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    ResultSet res = st.executeQuery(consulta.toString());
                    almacenesSelectList=new ArrayList<SelectItem>();
                    while (res.next()) 
                    {
                        almacenesSelectList.add(new SelectItem(res.getInt("COD_ALMACEN"),res.getString("NOMBRE_ALMACEN")));
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
            
            public String generarSolicitudSalidaAlmacen_action()throws SQLException
            {
                mensaje = "";
                try 
                {
                    con = Util.openConnection(con);
                    con.setAutoCommit(false);
                    ManagedAccesoSistema managedAccesoSistema=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
                    StringBuilder consulta = new StringBuilder("exec PAA_REALIZAR_SOLICITUD_MANTENIMIENTO_OT ");
                                            consulta.append(solicitudMantenimientoSolicitudSalidaAlmacenGenerarSalida.getCodSolicitudMantenimientoSolicitudSalidaAlmacen()).append(",");
                                            consulta.append(managedAccesoSistema.getUsuarioModuloBean().getCodUsuarioGlobal()).append(",");
                                            consulta.append(solicitudMantenimientoSolicitudSalidaAlmacenGenerarSalida.getSolicitudesSalida().getAlmacenes().getCodAlmacen()).append(",");
                                            consulta.append("?");//observacion de solicitud
                    LOGGER.debug("consulta generar solicitud salida almacen " + consulta.toString());
                    PreparedStatement pst = con.prepareStatement(consulta.toString());
                    pst.setString(1,solicitudMantenimientoSolicitudSalidaAlmacenGenerarSalida.getSolicitudesSalida().getObsSolicitud());
                    if (pst.executeUpdate() > 0)LOGGER.info("se registro la solicitud de salida almacen");
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
                if(mensaje.equals("1"))
                {
                    this.cargarSolicitudMantenimientoSolicitudSalidaAlmacenList();
                }
                return null;
            }
            public String codAlmacenDestinoSolicitud_change()
            {
                try 
                {
                    con = Util.openConnection(con);
                    StringBuilder consulta = new StringBuilder("select m.COD_MATERIAL,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA,aprobadoMantenimiento.cantidadAprobados");
                                                    consulta.append(",smdm.cantidad");
                                            consulta.append(" from SOLICITUDES_MANTENIMIENTO_DETALLE_MATERIALES smdm");
                                                    consulta.append(" inner join materiales m on m.COD_MATERIAL=smdm.COD_MATERIAL");
                                                    consulta.append(" inner join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=smdm.COD_UNIDAD_MEDIDA");
                                                    consulta.append(" left join");
                                                    consulta.append("(");
                                                            consulta.append(" select SUM(iade.cantidad_restante) as cantidadAprobados,iade.COD_MATERIAL");
                                                            consulta.append(" from INGRESOS_ALMACEN ia ");
                                                                    consulta.append(" inner join INGRESOS_ALMACEN_DETALLE iad on ia.COD_INGRESO_ALMACEN=iad.COD_INGRESO_ALMACEN");
                                                                    consulta.append(" inner join INGRESOS_ALMACEN_DETALLE_ESTADO iade on iad.COD_MATERIAL=iade.COD_MATERIAL and iad.COD_INGRESO_ALMACEN=iade.COD_INGRESO_ALMACEN");
                                                            consulta.append(" WHERE ia.cod_estado_ingreso_almacen = 1 and");
                                                                    consulta.append(" ia.estado_sistema = 1 and");
                                                                    consulta.append(" ia.fecha_ingreso_almacen <= GETDATE() and");
                                                                    consulta.append(" iade.cod_estado_material in (")
                                                                                    .append(" select cse.COD_ESTADO_MATERIAL")
                                                                                    .append(" from CONFIGURACION_SALIDA_ESTADO_MATERIAL  cse")
                                                                                    .append(" where cse.COD_ALMACEN =").append(solicitudMantenimientoSolicitudSalidaAlmacenGenerarSalida.getSolicitudesSalida().getAlmacenes().getCodAlmacen());
                                                                    consulta.append(")");
                                                                    consulta.append(" and iade.cantidad_restante > 0");
                                                                    consulta.append(" and ia.cod_almacen in (").append(solicitudMantenimientoSolicitudSalidaAlmacenGenerarSalida.getSolicitudesSalida().getAlmacenes().getCodAlmacen()).append(")");
                                                            consulta.append(" group by iade.COD_MATERIAL ");
                                                    consulta.append(" ) aprobadoMantenimiento on aprobadoMantenimiento.COD_MATERIAL=m.COD_MATERIAL ");
                                            consulta.append(" where smdm.COD_SOLICITUD_MANTENIMIENTO_SOLICITUD_SALIDA_ALMACEN=").append(solicitudMantenimientoSolicitudSalidaAlmacenGenerarSalida.getCodSolicitudMantenimientoSolicitudSalidaAlmacen());
                                            consulta.append(" order by m.NOMBRE_MATERIAL");
                    LOGGER.debug("consulta cargar " + consulta.toString());
                    Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    ResultSet res = st.executeQuery(consulta.toString());
                    solicitudMantenimientoSolicitudSalidaAlmacenGenerarSalida.setSolicitudMantenimientoDetalleMaterialesList(new ArrayList<SolicitudMantenimientoDetalleMateriales>());
                    while (res.next()) 
                    {
                        SolicitudMantenimientoDetalleMateriales bean=new SolicitudMantenimientoDetalleMateriales();
                        bean.getMateriales().setCodMaterial(res.getString("COD_MATERIAL"));
                        bean.getMateriales().setNombreMaterial(res.getString("NOMBRE_MATERIAL"));
                        bean.setCantidad(res.getDouble("CANTIDAD"));
                        bean.setCantidadDisponibleAlmacen(res.getDouble("cantidadAprobados"));
                        bean.getUnidadesMedida().setNombreUnidadMedida(res.getString("NOMBRE_UNIDAD_MEDIDA"));
                        solicitudMantenimientoSolicitudSalidaAlmacenGenerarSalida.getSolicitudMantenimientoDetalleMaterialesList().add(bean);
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
            public String seleccionarSolicitudMantenimientoSolicitudSalidaGenerar_action()
            {
                for(SolicitudMantenimientoSolicitudSalidaAlmacen bean:solicitudMantenimientoSolicitudSalidaAlmacenList)
                {
                    if(bean.getChecked())
                    {
                        solicitudMantenimientoSolicitudSalidaAlmacenGenerarSalida=bean;
                        solicitudMantenimientoSolicitudSalidaAlmacenGenerarSalida.getSolicitudesSalida().getAlmacenes().setCodAlmacen(4);
                        solicitudMantenimientoSolicitudSalidaAlmacenGenerarSalida.getSolicitudesSalida().setObsSolicitud(solicitudMantenimientoSolicitudSalidaAlmacenGenerarSalida.getDescripcion());
                        this.codAlmacenDestinoSolicitud_change();
                        break;
                    }
                }
                return null;
            }
            public String eliminarSolicitudMantenimientoSolicitudSalidaAlmacen_action()throws SQLException
            {
                mensaje="1";
                for(SolicitudMantenimientoSolicitudSalidaAlmacen bean:solicitudMantenimientoSolicitudSalidaAlmacenList)
                {
                    if(bean.getChecked())
                    {
                        try 
                        {
                            con = Util.openConnection(con);
                            con.setAutoCommit(false);
                            StringBuilder consulta = new StringBuilder("delete SOLICITUDES_MANTENIMIENTO_DETALLE_MATERIALES");
                                                        consulta.append(" where COD_SOLICITUD_MANTENIMIENTO_SOLICITUD_SALIDA_ALMACEN=").append(bean.getCodSolicitudMantenimientoSolicitudSalidaAlmacen());
                            LOGGER.debug("consulta eliminar detalle materiales" + consulta.toString());
                            PreparedStatement pst = con.prepareStatement(consulta.toString());
                            if (pst.executeUpdate() > 0) LOGGER.info("se elimino el detalle de materiales");
                            consulta=new StringBuilder("delete SOLICITUDES_MANTENIMIENTO_SOLICITUD_SALIDA_ALMACEN");
                                        consulta.append(" where COD_SOLICITUD_MANTENIMIENTO_SOLICITUD_SALIDA_ALMACEN=").append(bean.getCodSolicitudMantenimientoSolicitudSalidaAlmacen());
                            LOGGER.debug("consulta delete solicitud salida almacen");
                            pst=con.prepareStatement(consulta.toString());
                            if(pst.executeUpdate()>0)LOGGER.info("se elimino la solicitud");
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
                        break;
                    }
                }
                if(mensaje.equals("1"))
                {
                    this.cargarSolicitudMantenimientoSolicitudSalidaAlmacenList();
                }
                return null;
            }
            public String agregarMaterialSolicitudSalidaAlmacen_action()
            {
                solicitudMantenimientoDetalleMaterialesList=new ArrayList<SolicitudMantenimientoDetalleMateriales>();
                solicitudMantenimientoDetalleMaterialBuscar=new SolicitudMantenimientoDetalleMateriales();
                return null;
            }
            public String eliminarMaterialSolicitudSalidaAlmacen_action()
            {
                for(SolicitudMantenimientoDetalleMateriales bean:solicitudMantenimientoSolicitudSalidaAlmacenAgregar.getSolicitudMantenimientoDetalleMaterialesList())
                {
                    if(bean.getChecked())
                    {
                        solicitudMantenimientoSolicitudSalidaAlmacenAgregar.getSolicitudMantenimientoDetalleMaterialesList().remove(bean);
                        break;
                    }
                }
                return null;
            }
            public String buscarMaterialAgregarSolicitudSalidaAlmacen_action()
            {
                try 
                {
                    con = Util.openConnection(con);
                    StringBuilder consulta = new StringBuilder("select m.COD_MATERIAL,m.NOMBRE_MATERIAL,g.NOMBRE_GRUPO,c.NOMBRE_CAPITULO,aprobadoMantenimiento.cantidadAprobados as existencia,aprobadoMantenimiento2.cantidadAprobados as existenciaM")
                                                            .append(" ,m.COD_UNIDAD_MEDIDA,um.NOMBRE_UNIDAD_MEDIDA")
                                                            .append(" ,existenciaOtros.existenciaOtros");
                                                consulta.append(" from MATERIALES m ");
                                                    consulta.append(" inner join GRUPOS g on g.COD_GRUPO=m.COD_GRUPO");
                                                    consulta.append(" inner join CAPITULOS c on c.COD_CAPITULO=g.COD_CAPITULO");
                                                    consulta.append(" inner join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=m.COD_UNIDAD_MEDIDA");
                                                    consulta.append(" left join");
                                                    consulta.append("(");
                                                            consulta.append(" select SUM(iade.cantidad_restante) as cantidadAprobados,iade.COD_MATERIAL");
                                                            consulta.append(" from INGRESOS_ALMACEN ia ");
                                                                    consulta.append(" inner join INGRESOS_ALMACEN_DETALLE iad on ia.COD_INGRESO_ALMACEN=iad.COD_INGRESO_ALMACEN");
                                                                    consulta.append(" inner join INGRESOS_ALMACEN_DETALLE_ESTADO iade on iad.COD_MATERIAL=iade.COD_MATERIAL and iad.COD_INGRESO_ALMACEN=iade.COD_INGRESO_ALMACEN");
                                                            consulta.append(" WHERE ia.cod_estado_ingreso_almacen = 1 and");
                                                                    consulta.append(" ia.estado_sistema = 1 and");
                                                                    consulta.append(" ia.fecha_ingreso_almacen <= GETDATE() and");
                                                                    consulta.append(" iade.cod_estado_material in (")
                                                                                    .append(" select cse.COD_ESTADO_MATERIAL")
                                                                                    .append(" from CONFIGURACION_SALIDA_ESTADO_MATERIAL  cse")
                                                                                    .append(" where cse.COD_ALMACEN =4")
                                                                            .append(") ");
                                                                    consulta.append(" and iade.cantidad_restante > 0");
                                                                    consulta.append(" and ia.cod_almacen in (4)");
                                                            consulta.append(" group by iade.COD_MATERIAL ");
                                                    consulta.append(" ) aprobadoMantenimiento on aprobadoMantenimiento.COD_MATERIAL=m.COD_MATERIAL ");
                                                    consulta.append(" left join");
                                                    consulta.append("(");
                                                            consulta.append(" select SUM(iade.cantidad_restante) as cantidadAprobados,iade.COD_MATERIAL");
                                                            consulta.append(" from INGRESOS_ALMACEN ia ");
                                                                    consulta.append(" inner join INGRESOS_ALMACEN_DETALLE iad on ia.COD_INGRESO_ALMACEN=iad.COD_INGRESO_ALMACEN");
                                                                    consulta.append(" inner join INGRESOS_ALMACEN_DETALLE_ESTADO iade on iad.COD_MATERIAL=iade.COD_MATERIAL and iad.COD_INGRESO_ALMACEN=iade.COD_INGRESO_ALMACEN");
                                                            consulta.append(" WHERE ia.cod_estado_ingreso_almacen = 1 and");
                                                                    consulta.append(" ia.estado_sistema = 1 and");
                                                                    consulta.append(" ia.fecha_ingreso_almacen <= GETDATE() and");
                                                                    consulta.append(" iade.cod_estado_material in (")
                                                                                    .append(" select cse.COD_ESTADO_MATERIAL")
                                                                                    .append(" from CONFIGURACION_SALIDA_ESTADO_MATERIAL  cse")
                                                                                    .append(" where cse.COD_ALMACEN =14")
                                                                            .append(") ");
                                                                    consulta.append(" and iade.cantidad_restante > 0");
                                                                    consulta.append(" and ia.cod_almacen in (14)");
                                                            consulta.append(" group by iade.COD_MATERIAL ");
                                                    consulta.append(" ) aprobadoMantenimiento2 on aprobadoMantenimiento2.COD_MATERIAL=m.COD_MATERIAL ");
                                                    consulta.append(" left join (")
                                                                    .append(" select m1.COD_MATERIAL,(")
                                                                          .append(" select a.NOMBRE_ALMACEN+':  '+cast(SUM(iade.cantidad_restante)as varchar)+';\n'")
                                                                      .append(" from INGRESOS_ALMACEN ia")
                                                                                 .append(" inner join ALMACENES a on a.COD_ALMACEN=ia.COD_ALMACEN")
                                                                           .append(" inner join INGRESOS_ALMACEN_DETALLE iad on ia.COD_INGRESO_ALMACEN =iad.COD_INGRESO_ALMACEN")
                                                                           .append(" inner join INGRESOS_ALMACEN_DETALLE_ESTADO iade on iad.COD_MATERIAL= iade.COD_MATERIAL")
                                                                           .append(" and iad.COD_INGRESO_ALMACEN =iade.COD_INGRESO_ALMACEN")
                                                                      .append(" WHERE iad.COD_MATERIAL=m1.COD_MATERIAL ")
                                                                                 .append(" and ia.cod_estado_ingreso_almacen = 1")
                                                                            .append(" and ia.estado_sistema = 1 ")
                                                                            .append(" and ia.fecha_ingreso_almacen <= GETDATE()")
                                                                            .append(" and iade.cod_estado_material in (")
                                                                                        .append(" select cse.COD_ESTADO_MATERIAL")
                                                                                        .append(" from CONFIGURACION_SALIDA_ESTADO_MATERIAL  cse")
                                                                                        .append(" where cse.COD_ALMACEN  in (14,4)")
                                                                                .append(") ")
                                                                            .append(" and iade.cantidad_restante > 0")
                                                                            .append(" and ia.cod_almacen not in (14,4)")
                                                                      .append(" group by a.NOMBRE_ALMACEN,a.COD_ALMACEN")
                                                                      .append(" HAVING SUM(iade.cantidad_restante)>0.1")
                                                                      .append(" FOR XML PATH ('')")
                                                                    .append(" ) as existenciaOtros")
                                                                    .append(" from materiales m1 ")
                                                                       .append(" inner join grupos g1 on g1.COD_GRUPO=m1.COD_GRUPO")
                                                                    .append(" where m1.MOVIMIENTO_ITEM=1 ")
                                                                        .append(" and m1.COD_ESTADO_REGISTRO=1 ")
                                                                        .append(" and m1.NOMBRE_MATERIAL like '%").append(solicitudMantenimientoDetalleMaterialBuscar.getMateriales().getNombreMaterial()).append("%'")
                                                              .append(" ) as existenciaOtros on existenciaOtros.COD_MATERIAL=m.COD_MATERIAL");
                                                consulta.append(" where m.COD_ESTADO_REGISTRO=1");
                                                        consulta.append(" and m.MOVIMIENTO_ITEM=1");
                                                        consulta.append(" and m.NOMBRE_MATERIAL like '%").append(solicitudMantenimientoDetalleMaterialBuscar.getMateriales().getNombreMaterial()).append("%'");
                                                consulta.append(" ORDER BY m.NOMBRE_MATERIAL");
                    LOGGER.debug("consulta cargar " + consulta.toString());
                    Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    ResultSet res = st.executeQuery(consulta.toString());
                    solicitudMantenimientoDetalleMaterialesList=new ArrayList<SolicitudMantenimientoDetalleMateriales>();
                    while (res.next()) 
                    {
                        SolicitudMantenimientoDetalleMateriales nuevo=new SolicitudMantenimientoDetalleMateriales();
                        nuevo.getMateriales().setCodMaterial(res.getString("COD_MATERIAL"));
                        nuevo.getMateriales().setNombreMaterial(res.getString("NOMBRE_MATERIAL"));
                        nuevo.getMateriales().getGrupo().setNombreGrupo(res.getString("NOMBRE_GRUPO"));
                        nuevo.getMateriales().getGrupo().getCapitulo().setNombreCapitulo(res.getString("NOMBRE_CAPITULO"));
                        nuevo.setCantidadDisponibleAlmacen(res.getDouble("existencia"));
                        nuevo.setCantidadDisponibleAlmacenMantenimiento2(res.getDouble("existenciaM"));
                        nuevo.setCantidadDisponibleOtrosAlmacenes(res.getString("existenciaOtros"));
                        nuevo.getUnidadesMedida().setCodUnidadMedida(res.getString("COD_UNIDAD_MEDIDA"));
                        nuevo.getUnidadesMedida().setNombreUnidadMedida(res.getString("NOMBRE_UNIDAD_MEDIDA"));
                        solicitudMantenimientoDetalleMaterialesList.add(nuevo);
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
            
            public String getCargarAgregarSolicitudMantenimientoSolicitudSalidaAlmacen()
            {
                solicitudMantenimientoSolicitudSalidaAlmacenAgregar=new SolicitudMantenimientoSolicitudSalidaAlmacen();
                solicitudMantenimientoSolicitudSalidaAlmacenAgregar.setSolicitudMantenimientoDetalleMaterialesList(new ArrayList<SolicitudMantenimientoDetalleMateriales>());
                solicitudMantenimientoDetalleMaterialBuscar=new SolicitudMantenimientoDetalleMateriales();
                return null;
            }
            public String getCargarSolicitudMantenimientoSolicitudSalidaAlmacen()
            {
                this.cargarAlmacenesSelectList();
                this.cargarSolicitudMantenimientoSolicitudSalidaAlmacenList();
                return null;
            }
            public String seleccionarAgregarSolicitudMantenimientoSalida_action()
            {
                solicitudMantenimientoSolicitudSalidaAlmacenAgregar.getSolicitudMantenimientoDetalleMaterialesList().add((SolicitudMantenimientoDetalleMateriales)solicitudMantenimientoDetalleMaterialesDataTable.getRowData());
                return null;
            }
            private void cargarSolicitudMantenimientoSolicitudSalidaAlmacenList()
            {
                try 
                {
                    con = Util.openConnection(con);
                    StringBuilder consulta = new StringBuilder("select s.FECHA_REGISTRO,s.DESCRIPCION,s.COD_FORM_SALIDA,s.COD_SOLICITUD_MANTENIMIENTO_SOLICITUD_SALIDA_ALMACEN");
                                                        consulta.append(" ,smdt.COD_MATERIAL,m.NOMBRE_MATERIAL,um.COD_UNIDAD_MEDIDA,um.NOMBRE_UNIDAD_MEDIDA,smdt.CANTIDAD,smdt.DESCRIPCION");
                                                        consulta.append(" ,s.COD_FORM_SALIDA,A.NOMBRE_ALMACEN,ss.COD_ALMACEN");
                                                        consulta.append(" ,(")
                                                                    .append(" select a.NOMBRE_ALMACEN+'  :   '+cast(SUM(iade.cantidad_restante)as varchar)+'  ;  '")
                                                                .append(" from INGRESOS_ALMACEN ia")
                                                                           .append(" inner join ALMACENES a on a.COD_ALMACEN=ia.COD_ALMACEN")
                                                                     .append(" inner join INGRESOS_ALMACEN_DETALLE iad on ia.COD_INGRESO_ALMACEN =iad.COD_INGRESO_ALMACEN")
                                                                     .append(" inner join INGRESOS_ALMACEN_DETALLE_ESTADO iade on iad.COD_MATERIAL= iade.COD_MATERIAL")
                                                                     .append(" and iad.COD_INGRESO_ALMACEN =iade.COD_INGRESO_ALMACEN")
                                                                .append(" WHERE iad.COD_MATERIAL=m.COD_MATERIAL ")
                                                                           .append(" and ia.cod_estado_ingreso_almacen = 1")
                                                                      .append(" and ia.estado_sistema = 1 ")
                                                                      .append(" and ia.fecha_ingreso_almacen <= GETDATE()")
                                                                      .append(" and iade.cod_estado_material in (")
                                                                            .append(" select cse.COD_ESTADO_MATERIAL")
                                                                                    .append(" from CONFIGURACION_SALIDA_ESTADO_MATERIAL  cse")
                                                                                    .append(" where cse.COD_ALMACEN = ia.COD_ALMACEN")
                                                                            .append(") ")
                                                                      .append(" and iade.cantidad_restante > 0")
                                                                .append(" group by a.NOMBRE_ALMACEN,a.COD_ALMACEN")
                                                                .append(" HAVING SUM(iade.cantidad_restante)>0.1")
                                                                .append(" FOR XML PATH ('')")
                                                              .append(" ) as existenciaOtros");
                                                consulta.append(" from SOLICITUDES_MANTENIMIENTO_SOLICITUD_SALIDA_ALMACEN s");
                                                        consulta.append(" left outer join SOLICITUDES_MANTENIMIENTO_DETALLE_MATERIALES smdt on s.COD_SOLICITUD_MANTENIMIENTO_SOLICITUD_SALIDA_ALMACEN=smdt.COD_SOLICITUD_MANTENIMIENTO_SOLICITUD_SALIDA_ALMACEN");
                                                        consulta.append(" left outer join MATERIALES m on m.COD_MATERIAL=smdt.COD_MATERIAL");
                                                        consulta.append(" left outer join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=smdt.COD_UNIDAD_MEDIDA");
                                                        consulta.append(" left outer join SOLICITUDES_SALIDA ss on ss.COD_FORM_SALIDA=s.COD_FORM_SALIDA");
                                                        consulta.append(" left outer join ALMACENES a on a.COD_ALMACEN=ss.COD_ALMACEN");
                                                consulta.append(" where s.COD_SOLICITUD_MANTENIMIENTO=").append(solicitudMantenimientoSolicitudSalidaAlmacen.getCodSolicitudMantenimiento());
                                                consulta.append(" order by s.FECHA_REGISTRO");
                    LOGGER.debug("consulta cargar solicitud mantenimiento sol salida "+consulta.toString());
                    Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    ResultSet res = st.executeQuery(consulta.toString());
                    solicitudMantenimientoSolicitudSalidaAlmacenList=new ArrayList<SolicitudMantenimientoSolicitudSalidaAlmacen>();
                    SolicitudMantenimientoSolicitudSalidaAlmacen nuevo=new SolicitudMantenimientoSolicitudSalidaAlmacen();
                    while (res.next()) 
                    {
                        if(nuevo.getCodSolicitudMantenimientoSolicitudSalidaAlmacen()!=res.getInt("COD_SOLICITUD_MANTENIMIENTO_SOLICITUD_SALIDA_ALMACEN"))
                        {
                            if(nuevo.getCodSolicitudMantenimientoSolicitudSalidaAlmacen()>0)
                            {
                                solicitudMantenimientoSolicitudSalidaAlmacenList.add(nuevo);
                            }
                            nuevo=new SolicitudMantenimientoSolicitudSalidaAlmacen();
                            nuevo.getSolicitudesSalida().setCodFormSalida(res.getInt("COD_FORM_SALIDA"));
                            nuevo.getSolicitudesSalida().getAlmacenes().setCodAlmacen(res.getInt("COD_ALMACEN"));
                            nuevo.getSolicitudesSalida().getAlmacenes().setNombreAlmacen(res.getString("NOMBRE_ALMACEN"));
                            nuevo.setFechaRegistro(res.getTimestamp("FECHA_REGISTRO"));
                            nuevo.setDescripcion(res.getString("DESCRIPCION"));
                            nuevo.getSolicitudesSalida().setCodFormSalida(res.getInt("COD_FORM_SALIDA"));
                            nuevo.setCodSolicitudMantenimientoSolicitudSalidaAlmacen(res.getInt("COD_SOLICITUD_MANTENIMIENTO_SOLICITUD_SALIDA_ALMACEN"));
                            nuevo.setSolicitudMantenimientoDetalleMaterialesList(new ArrayList<SolicitudMantenimientoDetalleMateriales>());
                            
                        }
                        SolicitudMantenimientoDetalleMateriales bean=new SolicitudMantenimientoDetalleMateriales();
                        bean.getMateriales().setCodMaterial(res.getString("COD_MATERIAL"));
                        bean.getMateriales().setNombreMaterial(res.getString("NOMBRE_MATERIAL"));
                        bean.setCantidad(res.getDouble("CANTIDAD"));
                        bean.getUnidadesMedida().setCodUnidadMedida(res.getString("COD_UNIDAD_MEDIDA"));
                        bean.getUnidadesMedida().setNombreUnidadMedida(res.getString("NOMBRE_UNIDAD_MEDIDA"));
                        bean.setDescripcion(res.getString("DESCRIPCION"));
                        bean.setCantidadDisponibleOtrosAlmacenes(res.getString("existenciaOtros"));
                        nuevo.getSolicitudMantenimientoDetalleMaterialesList().add(bean);
                    }
                    if(nuevo.getCodSolicitudMantenimientoSolicitudSalidaAlmacen()>0)
                    {
                        solicitudMantenimientoSolicitudSalidaAlmacenList.add(nuevo);
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
            public String guardarAgregarSolicitudMantenimientoSolicitudSalidaAlmacen()throws SQLException
            {
                mensaje = "";
                try 
                {
                    con = Util.openConnection(con);
                    con.setAutoCommit(false);
                    
                    SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm");
                    StringBuilder consulta = new StringBuilder("INSERT INTO SOLICITUDES_MANTENIMIENTO_SOLICITUD_SALIDA_ALMACEN(");
                                                    consulta.append(" COD_SOLICITUD_MANTENIMIENTO, COD_FORM_SALIDA, DESCRIPCION, FECHA_REGISTRO)");
                                                consulta.append(" VALUES (");
                                                    consulta.append(solicitudMantenimientoSolicitudSalidaAlmacen.getCodSolicitudMantenimiento()).append(",");
                                                    consulta.append("0,");//porque aun no se realizo la solicitud
                                                    consulta.append("?,");//descricion de solicitud
                                                    consulta.append("'").append(sdf.format(new Date())).append("'");
                                                consulta.append(")");
                    LOGGER.debug("consulta registra cabecera solicitud" + consulta.toString());
                    PreparedStatement pst = con.prepareStatement(consulta.toString(), PreparedStatement.RETURN_GENERATED_KEYS);
                    pst.setString(1,solicitudMantenimientoSolicitudSalidaAlmacenAgregar.getDescripcion());
                    if (pst.executeUpdate() > 0) LOGGER.info("se registro la ssolicidut salida almacen");
                    ResultSet res=pst.getGeneratedKeys();
                    res.next();
                    consulta=new StringBuilder("INSERT INTO SOLICITUDES_MANTENIMIENTO_DETALLE_MATERIALES(COD_SOLICITUD_MANTENIMIENTO, COD_MATERIAL, DESCRIPCION, CANTIDAD,COD_UNIDAD_MEDIDA, COD_SOLICITUD_MANTENIMIENTO_SOLICITUD_SALIDA_ALMACEN)");
                               consulta.append(" VALUES (");
                                    consulta.append(solicitudMantenimientoSolicitudSalidaAlmacen.getCodSolicitudMantenimiento()).append(",");
                                    consulta.append("?,");//codmaterial
                                    consulta.append("?,");//descripcion
                                    consulta.append("?,");//cantidad
                                    consulta.append("?,");//cod unidad medida
                                    consulta.append(res.getInt(1));//cod solicitud salida mantenimiento
                                consulta.append(")");
                    LOGGER.debug("consulta registro detalle tarea "+consulta.toString());
                    pst=con.prepareStatement(consulta.toString());
                    for(SolicitudMantenimientoDetalleMateriales bean:solicitudMantenimientoSolicitudSalidaAlmacenAgregar.getSolicitudMantenimientoDetalleMaterialesList())
                    {
                            pst.setString(1,bean.getMateriales().getCodMaterial());
                            pst.setString(2,bean.getDescripcion());
                            pst.setDouble(3,bean.getCantidad());
                            pst.setString(4,bean.getUnidadesMedida().getCodUnidadMedida());
                            if(pst.executeUpdate()>0)LOGGER.info("se registro el material "+bean.getMateriales().getCodMaterial());      
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
            public String seleccionarSolicitudMantenimientoSolicitudSalidaAlmacen_action()
            {
                solicitudMantenimientoSolicitudSalidaAlmacen=(SolicitudMantenimiento)solicitudMantenimientoAprobacionDataTable.getRowData();
                return null;
            }
        //</editor-fold>
        
        //<editor-fold desc="solicitud mantenimiento tareas"  defaultstate="collapsed">
            public String eliminarSolicitudMantenimientoDetalleTarea_action()throws SQLException
            {
                mensaje="";
                for(SolicitudMantenimientoDetalleTareas bean:solicitudMantenimientoDetalleTareasList)
                {
                    if(bean.getChecked())
                    {
                        mensaje = "";
                        try 
                        {
                            con = Util.openConnection(con);
                            con.setAutoCommit(false);
                            StringBuilder consulta = new StringBuilder(" delete SOLICITUDES_MANTENIMIENTO_DETALLE_TAREAS ");
                                                        consulta.append(" where COD_PERSONAL=").append(bean.getPersonal().getCodPersonal());
                                                                consulta.append(" and COD_TIPO_TAREA=").append(bean.getTiposTarea().getCodTipoTarea());
                                                                consulta.append(" and COD_PROVEEDOR=").append(bean.getProveedores().getCodProveedor());
                                                                consulta.append(" and COD_SOLICITUD_MANTENIMIENTO=").append(solicitudMantenimientoTarea.getCodSolicitudMantenimiento());
                            LOGGER.debug("consulta eliminar solicitud mantenimiento tarea " + consulta.toString());
                            PreparedStatement pst = con.prepareStatement(consulta.toString(), PreparedStatement.RETURN_GENERATED_KEYS);
                            if (pst.executeUpdate() > 0) {
                                LOGGER.info("se elimino la solicitud de mantenimiento");
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
                        break;
                    }
                }
                if(mensaje.equals("1"))
                {
                    this.cargarSolicitudMantenimientoDetalleTareasList();
                }
                return null;
            }
            public String agregarSolicitudMantenimientoDetalleTarea_action()
            {
                solicitudMantenimientoDetalleTareaAgregar=new SolicitudMantenimientoDetalleTareas();
                return null;
            }
            public String guardarAgregarSolicitudMantenimientoDetalleTarea_action()throws SQLException
            {
                mensaje = "";
                try {
                    con = Util.openConnection(con);
                    con.setAutoCommit(false);
                    SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm");
                    StringBuilder consulta = new StringBuilder(" INSERT INTO SOLICITUDES_MANTENIMIENTO_DETALLE_TAREAS (COD_SOLICITUD_MANTENIMIENTO,COD_TIPO_TAREA,DESCRIPCION,COD_PERSONAL,");
                                                consulta.append("  FECHA_INICIAL,   FECHA_FINAL,   COD_PROVEEDOR,  HORAS_HOMBRE,FECHA_ASIGNACION)");
                                                consulta.append(" VALUES ( ");
                                                        consulta.append(solicitudMantenimientoTarea.getCodSolicitudMantenimiento());
                                                        consulta.append(",").append(solicitudMantenimientoDetalleTareaAgregar.getTiposTarea().getCodTipoTarea());
                                                        consulta.append(",''");//descripcion vacia
                                                        consulta.append(",?");//codigo de personal
                                                        consulta.append(",'").append(sdf.format(solicitudMantenimientoTarea.getFechaAprobacion())).append("'");
                                                        consulta.append(",'").append(sdf.format(solicitudMantenimientoTarea.getFechaAprobacion())).append("'");
                                                        consulta.append(",?");//codigo proveedor
                                                        consulta.append(",").append(solicitudMantenimientoDetalleTareaAgregar.getHorasHombre());
                                                        consulta.append(",'").append(sdf.format(solicitudMantenimientoTarea.getFechaAprobacion())).append("'");
                                                consulta.append(")");
                    LOGGER.debug("consulta registrar detalle tareas " + consulta.toString());
                    PreparedStatement pst = con.prepareStatement(consulta.toString());
                    if(solicitudMantenimientoDetalleTareaAgregar.isTareaPersonalExterno())
                    {
                        pst.setInt(1,0);
                        pst.setInt(2,solicitudMantenimientoDetalleTareaAgregar.getProveedores().getCodProveedor());
                        if(pst.executeUpdate()>0)LOGGER.info("se registro la asignacion de tarea a proveedor");
                    }
                    else
                    {
                        pst.setString(2,"0");
                        for(String codPersonalAsigna:codPersonalAgregarAsignar)
                        {
                            pst.setString(1,codPersonalAsigna);
                            if(pst.executeUpdate()>0)LOGGER.info("se registro la asignacion de tarea personal");
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
                    this.cargarSolicitudMantenimientoDetalleTareasList();
                }
                return null;
            }
            private void cargarTiposTareaSelectList()
            {
                try 
                {
                    con = Util.openConnection(con);
                    StringBuilder consulta = new StringBuilder("select tt.COD_TIPO_TAREA,tt.NOMBRE_TIPO_TAREA");
                                            consulta.append(" from TIPOS_TAREA tt ");
                                            consulta.append(" where tt.COD_ESTADO_REGISTRO=1");
                                            consulta.append(" order by tt.NOMBRE_TIPO_TAREA");
                    Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    ResultSet res = st.executeQuery(consulta.toString());
                    tiposTareaSelectList=new ArrayList<SelectItem>();
                    while (res.next()) 
                    {
                        tiposTareaSelectList.add(new SelectItem(res.getInt("COD_TIPO_TAREA"),res.getString("NOMBRE_TIPO_TAREA")));
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
            private void cargarProveedoresSelectList()
            {
                try 
                {
                    con = Util.openConnection(con);
                    StringBuilder consulta = new StringBuilder("select p.COD_PROVEEDOR,p.NOMBRE_PROVEEDOR");
                                                consulta.append(" from PROVEEDORES p ");
                                                consulta.append(" where p.COD_ESTADO_PROVEEDOR=1 ");
                                                        consulta.append(" and p.COD_ESTADO_REGISTRO=1");
                                                consulta.append(" order by p.NOMBRE_PROVEEDOR");
                    Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    ResultSet res = st.executeQuery(consulta.toString());
                    proveedoresSelectList=new ArrayList<SelectItem>();
                    while (res.next()) 
                    {
                        proveedoresSelectList.add(new SelectItem(res.getInt("COD_PROVEEDOR"),res.getString("NOMBRE_PROVEEDOR")));
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
            private void cargarPersonalAreaMantenimientoList()
            {
                try {
                    con = Util.openConnection(con);
                    StringBuilder consulta = new StringBuilder("SELECT pap.COD_PERSONAL,isnull(p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL+' '+p.nombre2_personal,");
                                                        consulta.append(" pt.AP_PATERNO_PERSONAL+' '+pt.AP_MATERNO_PERSONAL+' '+pt.NOMBRES_PERSONAL+' '+pt.nombre2_personal) as nombrePersonal");
                                                consulta.append(" FROM PERSONAL_AREA_PRODUCCION pap");
                                                        consulta.append(" left outer join PERSONAL p on p.COD_PERSONAL=pap.COD_PERSONAL");
                                                        consulta.append(" left outer join PERSONAL_TEMPORAL pt on pt.COD_PERSONAL=pap.COD_PERSONAL");
                                                consulta.append(" where pap.COD_AREA_EMPRESA in (86,103)");
                                                        consulta.append(" and pap.COD_ESTADO_PERSONAL_AREA_PRODUCCION=1");
                                                consulta.append(" order by 2");
                    LOGGER.debug("consulta cargar personal mantenimiento " + consulta.toString());
                    Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    ResultSet res = st.executeQuery(consulta.toString());
                    personalSelectList=new ArrayList<SelectItem>();
                    while (res.next()) 
                    {
                        personalSelectList.add(new SelectItem(res.getString("COD_PERSONAL"),res.getString("nombrePersonal")));
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
            private void cargarPersonalSelectList()
            {
                try {
                    con = Util.openConnection(con);
                    StringBuilder consulta = new StringBuilder("select *");
                                                consulta.append(" from ");
                                                consulta.append( "(");
                                                        consulta.append(" select p.COD_PERSONAL,(p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL) as nombrePersonal");
                                                        consulta.append(" from PERSONAL p");
                                                        consulta.append(" where p.COD_ESTADO_PERSONA=1 and p.COD_AREA_EMPRESA in (86,103)");
                                                        /*consulta.append(" union");
                                                        consulta.append(" select pt.COD_PERSONAL,(pt.AP_PATERNO_PERSONAL+' '+pt.AP_MATERNO_PERSONAL+' '+pt.NOMBRES_PERSONAL+'(temporal)') as nombrePersonal");
                                                        consulta.append(" from PERSONAL_TEMPORAL pt");
                                                        consulta.append(" where pt.COD_ESTADO_PERSONA=1 and pt.COD_AREA_EMPRESA in (86,103)");*/
                                                consulta.append(" ) as personalP");
                                                consulta.append(" order by 2");
                    LOGGER.debug("consulta cargar personal " + consulta.toString());
                    Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    ResultSet res = st.executeQuery(consulta.toString());
                    personalSelectList=new ArrayList<SelectItem>();
                    while (res.next()) 
                    {
                        personalSelectList.add(new SelectItem(res.getString(1),res.getString(2)));
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
            public String getCargarSolicitudMantemientoDetalleTareas()
            {
                //this.cargarPersonalSelectList();
                this.cargarPersonalAreaMantenimientoList();
                this.cargarProveedoresSelectList();
                this.cargarTiposTareaSelectList();
                this.cargarSolicitudMantenimientoDetalleTareasList();
                return null;
            }
            private void cargarSolicitudMantenimientoDetalleTareasList()
            {
                try 
                {
                    con = Util.openConnection(con);
                    StringBuilder consulta = new StringBuilder("select smdt.cod_solicitud_mantenimiento,tt.cod_tipo_tarea,");
                                                        consulta.append(" tt.nombre_tipo_tarea,smdt.cod_personal,isnull(p.NOMBRES_PERSONAL,pt.NOMBRES_PERSONAL) as NOMBRES_PERSONAL,");
                                                        consulta.append(" isnull(p.AP_PATERNO_PERSONAL,pt.AP_PATERNO_PERSONAL) as AP_PATERNO_PERSONAL,isnull(p.AP_MATERNO_PERSONAL,pt.AP_MATERNO_PERSONAL) as AP_MATERNO_PERSONAL,");
                                                        consulta.append(" isnull(p.nombre2_personal,pt.nombre2_personal) as nombre2_personal,");
                                                        consulta.append(" smdt.descripcion,smdt.fecha_inicial,smdt.fecha_final,smdt.cod_proveedor,isnull(pr.NOMBRE_PROVEEDOR,'') as  nombre_proveedor");
                                                consulta.append(" from SOLICITUDES_MANTENIMIENTO_DETALLE_TAREAS smdt");
                                                        consulta.append(" inner join TIPOS_TAREA tt on tt.COD_TIPO_TAREA=smdt.COD_TIPO_TAREA");
                                                        consulta.append(" left outer join personal p on p.COD_PERSONAL=smdt.COD_PERSONAL");
                                                        consulta.append(" left outer join PERSONAL_TEMPORAL pt on pt.COD_PERSONAL=smdt.COD_PERSONAL");
                                                        consulta.append(" left outer join PROVEEDORES pr on pr.COD_PROVEEDOR=smdt.COD_PROVEEDOR");
                                                consulta.append(" where smdt.COD_SOLICITUD_MANTENIMIENTO=").append(solicitudMantenimientoTarea.getCodSolicitudMantenimiento());
                                                consulta.append(" order by smdt.FECHA_ASIGNACION ");
                    LOGGER.debug("consulta cargar solicitud detalle tareas "+consulta.toString());
                    solicitudMantenimientoDetalleTareasList=new ArrayList<SolicitudMantenimientoDetalleTareas>();
                    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet res=st.executeQuery(consulta.toString());
                    while(res.next())
                    {
                        SolicitudMantenimientoDetalleTareas nuevo= new SolicitudMantenimientoDetalleTareas();
                        nuevo.getSolicitudMantenimiento().setCodSolicitudMantenimiento(res.getInt("COD_SOLICITUD_MANTENIMIENTO"));
                        nuevo.getTiposTarea().setCodTipoTarea(res.getInt("COD_TIPO_TAREA"));
                        nuevo.getTiposTarea().setNombreTipoTarea(res.getString("NOMBRE_TIPO_TAREA"));
                        nuevo.getPersonal().setCodPersonal(res.getString("COD_PERSONAL"));
                        nuevo.getPersonal().setNombrePersonal(res.getString("NOMBRES_PERSONAL")+" "+res.getString("nombre2_personal"));
                        
                        nuevo.getPersonal().setApPaternoPersonal(res.getString("AP_PATERNO_PERSONAL"));
                        nuevo.getPersonal().setApMaternoPersonal(res.getString("AP_MATERNO_PERSONAL"));
                        nuevo.getProveedores().setCodProveedor(res.getInt("COD_PROVEEDOR"));
                        nuevo.getProveedores().setNombreProveedor(res.getString("NOMBRE_PROVEEDOR"));
                        nuevo.setDescripcion(res.getString("DESCRIPCION"));
                        nuevo.setFechaInicial(res.getDate("FECHA_INICIAL"));
                        nuevo.getFechaInicial().setTime(res.getTimestamp("FECHA_INICIAL").getTime());
                        nuevo.setFechaFinal(res.getDate("FECHA_FINAL"));
                        solicitudMantenimientoDetalleTareasList.add(nuevo);
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
            public String seleccionarSolicitudMantenimientoTarea_action()
            {
                solicitudMantenimientoTarea=(SolicitudMantenimiento)solicitudMantenimientoAprobacionDataTable.getRowData();
                return null;
            }
        //</editor-fold>
            
        public String codAreaEmpresaBuscar_change()
        {
            this.cargarMaquinariasSelectList();
            return null;
        }
        private void cargarMaquinariasSelectList()
        {
            try {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select m.COD_MAQUINA,m.NOMBRE_MAQUINA+' ('+m.CODIGO+')' as nombreMaquinaria ");
                                            consulta.append(" from MAQUINARIAS m ");
                                            if(!solicitudMantenimientoBuscar.getAreasEmpresa().getCodAreaEmpresa().equals("0"))
                                                consulta.append(" where m.COD_AREA_EMPRESA=").append(solicitudMantenimientoBuscar.getAreasEmpresa().getCodAreaEmpresa());
                                            consulta.append(" order by 2");
                LOGGER.debug("consulta cargar " + consulta.toString());
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                maquinariaSelectList=new ArrayList<SelectItem>();
                while (res.next()) 
                {
                    maquinariaSelectList.add(new SelectItem(res.getString("COD_MAQUINA"),res.getString("nombreMaquinaria")));
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
        public String seleccionarSolicitudMantenimientoDescribirEstado_action()
        {
            solicitudMantenimientoDescribirEstado=(SolicitudMantenimiento)solicitudMantenimientoAprobacionDataTable.getRowData();
            return null;
        }
        public String guardarSolicitudMantenimientoDescribirEstado_action()throws SQLException
        {
            mensaje = "";
            try 
            {
                con = Util.openConnection(con);
                con.setAutoCommit(false);
                StringBuilder consulta = new StringBuilder("update SOLICITUDES_MANTENIMIENTO");
                                            consulta.append(" set DESCRIPCION_ESTADO=?");
                                            consulta.append(" where COD_SOLICITUD_MANTENIMIENTO=").append(solicitudMantenimientoDescribirEstado.getCodSolicitudMantenimiento());
                LOGGER.debug("consulta registrar descripcion del estado de la solicitud " + consulta.toString());
                PreparedStatement pst = con.prepareStatement(consulta.toString(), PreparedStatement.RETURN_GENERATED_KEYS);
                pst.setString(1,solicitudMantenimientoDescribirEstado.getDescripcionEstado());
                if (pst.executeUpdate() > 0) LOGGER.info("se registro las descripcion del estado de la solicitud");
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
            if(mensaje.equals("1"))
            {
                this.cargarSolicitudMantenimientoAprobacionList();
            }
            return null;
        }
        public String anularSolicitudMantenimiento_action()
        {
           for(SolicitudMantenimiento bean:solicitudMantenimientoAprobacionList)
           {
               if(bean.getChecked())
               {
                   solicitudMantenimientoAnular=bean;
                   break;
               }
           }
           return null;
        }
        public String guardarAnularSolicitudMantenimientao_action()throws SQLException
        {
            mensaje = "";
            try {
                con = Util.openConnection(con);
                con.setAutoCommit(false);
                StringBuilder consulta = new StringBuilder(" UPDATE SOLICITUDES_MANTENIMIENTO SET");
                                                    consulta.append(" COD_ESTADO_SOLICITUD_MANTENIMIENTO = 3");
                                                    consulta.append(" ,descripcion_estado = ?");
                                        consulta.append(" WHERE COD_SOLICITUD_MANTENIMIENTO = ").append(solicitudMantenimientoAnular.getCodSolicitudMantenimiento());
                LOGGER.debug("consulta anular solicitud mantenimiento " + consulta.toString());
                PreparedStatement pst = con.prepareStatement(consulta.toString());
                pst.setString(1,solicitudMantenimientoAnular.getDescripcionEstado());
                if (pst.executeUpdate() > 0) LOGGER.info("se registro la anulacion");
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
            if(mensaje.equals("1"))
            {
                this.cargarSolicitudMantenimientoAprobacionList();
            }
            return null;
        }
        public String cerrarSolicitudMantenimiento_action()throws SQLException
        {
            SolicitudMantenimiento solicitudCerrar=(SolicitudMantenimiento)solicitudMantenimientoAprobacionDataTable.getRowData();
            mensaje = "";
            try {
                con = Util.openConnection(con);
                con.setAutoCommit(false);
                StringBuilder consulta = new StringBuilder("update SOLICITUDES_MANTENIMIENTO ");
                                            consulta.append(" set FECHA_CAMBIO_ESTADOSOLICITUD=getdate()");
                                            consulta.append(" ,COD_ESTADO_SOLICITUD_MANTENIMIENTO=4");
                                            consulta.append(" where COD_SOLICITUD_MANTENIMIENTO=").append(solicitudCerrar.getCodSolicitudMantenimiento());
                LOGGER.debug("consulta cerrar ot" + consulta.toString());
                PreparedStatement pst = con.prepareStatement(consulta.toString());
                if (pst.executeUpdate() > 0) LOGGER.info("se cerro la ot");
                con.commit();
                mensaje = "1";
            }
            catch (SQLException ex) 
            {
                mensaje = "Ocurrio un error al momento de cerrar la orden de trabajo";
                LOGGER.warn(ex.getMessage());
                con.rollback();
            }
            catch (Exception ex) 
            {
                mensaje = "Ocurrio un error al momento de cerrar la orden de trabajo";
                LOGGER.warn(ex.getMessage());
            }
            finally 
            {
                this.cerrarConexion(con);
            }
            if(mensaje.equals("1"))
            {
                this.cargarSolicitudMantenimientoAprobacionList();
            }
            return null;
        }
        public String seleccionarAprobarSolicitudMantenimiento_action()
        {
            for(SolicitudMantenimiento bean:solicitudMantenimientoAprobacionList)
            {
                if(bean.getChecked())
                {
                    solicitudMantenimientoAprobar=bean;
                    solicitudMantenimientoAprobar.setFechaAprobacion((Date)bean.getFechaSolicitudMantenimiento().clone());
                    break;
                }
            }
            return null;
        }
        public String aprobarSolicitudMantenimiento_action()throws SQLException
        {
            solicitudMantenimientoAprobar.getFechaSolicitudMantenimiento().setHours(0);
            solicitudMantenimientoAprobar.getFechaSolicitudMantenimiento().setMinutes(0);
            solicitudMantenimientoAprobar.getFechaSolicitudMantenimiento().setSeconds(0);
            if(solicitudMantenimientoAprobar.getFechaAprobacion().before(solicitudMantenimientoAprobar.getFechaSolicitudMantenimiento()))
            {
                mensaje="No se puede registrar la aprobación con una fecha anterior a la del registro de la solicitud";
                return null;
            }
            mensaje="";
            try 
            {
                con = Util.openConnection(con);
                con.setAutoCommit(false);
                SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");
                SimpleDateFormat sdfHora=new SimpleDateFormat("HH:mm");
                StringBuilder consulta = new StringBuilder("UPDATE SOLICITUDES_MANTENIMIENTO set");
                                           consulta.append(" COD_ESTADO_SOLICITUD_MANTENIMIENTO = 2");
                                           consulta.append(" ,FECHA_APROBACION='").append(sdf.format(solicitudMantenimientoAprobar.getFechaAprobacion())).append(" ").append(sdfHora.format(new Date())).append("'");
                                           consulta.append(" ,FECHA_CAMBIO_ESTADOSOLICITUD ='").append(sdf.format(solicitudMantenimientoAprobar.getFechaAprobacion())).append(" ").append(sdfHora.format(new Date())).append("'");
                                           consulta.append(" ,NRO_ORDEN_TRABAJO=(select isnull(max(sm.NRO_ORDEN_TRABAJO),0)+1 from SOLICITUDES_MANTENIMIENTO sm)");
                                           consulta.append("WHERE COD_SOLICITUD_MANTENIMIENTO=").append(solicitudMantenimientoAprobar.getCodSolicitudMantenimiento());
                LOGGER.debug("consulta aprobar solicitud Mantenimiento " + consulta.toString());
                PreparedStatement pst = con.prepareStatement(consulta.toString(), PreparedStatement.RETURN_GENERATED_KEYS);
                if (pst.executeUpdate() > 0) LOGGER.info("se Aprobo la solicitud de mantenimiento");
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
            
            if(mensaje.equals("1"))
            {
                this.cargarSolicitudMantenimientoAprobacionList();
            }
            return null;
        }
        public String siguienteSolicitudesMantenimientoList_action() 
        {
            super.next();
            this.cargarSolicitudMantenimientoAprobacionList();
            return null;
        }

        public String atrasSolicitudesMantenimientoList_action() 
        {
            super.back();
            this.cargarSolicitudMantenimientoAprobacionList();
            return null;
        }
        private void cargarEstadosSolicitudMantenimientoSelectList()
        {
            try {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select esm.COD_ESTADO_SOLICITUD,esm.NOMBRE_ESTADO_SOLICITUD");
                                            consulta.append(" from ESTADOS_SOLICITUD_MANTENIMIENTO esm ");
                                            consulta.append(" order by esm.NOMBRE_ESTADO_SOLICITUD");
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                estadosSolicitudMantenimientoSelectList=new ArrayList<SelectItem>();
                while (res.next()) 
                {
                    estadosSolicitudMantenimientoSelectList.add(new SelectItem(res.getInt("COD_ESTADO_SOLICITUD"),res.getString("NOMBRE_ESTADO_SOLICITUD")));
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
        private void cargarPersonalSolicitudMantenimientoSelectList()
        {
            try {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select distinct p.COD_PERSONAL,p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL+' '+p.nombre2_personal as nombrePersonal");
                                            consulta.append(" from SOLICITUDES_MANTENIMIENTO sm ");
                                                    consulta.append(" inner join PERSONAL p on p.COD_PERSONAL=sm.COD_PERSONAL");
                                            consulta.append(" order by 2 ");
                LOGGER.debug("consulta cargar " + consulta.toString());
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                personalSolicitudMantenimientoSelectList=new ArrayList<SelectItem>();
                while (res.next()) 
                {
                    personalSolicitudMantenimientoSelectList.add(new SelectItem(res.getString("COD_PERSONAL"),res.getString("nombrePersonal")));
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
        private void cargarTiposNivelSolicitudMantenimientoSelectList()
        {
            try {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select tnsm.COD_NIVEL_SOLICITUD_MANTENIMIENTO,tnsm.NOMBRE_NIVEL_SOLICITUD_MANTENIMIENTO");
                                            consulta.append(" from TIPOS_NIVEL_SOLICITUD_MANTENIMIENTO tnsm");
                                            consulta.append(" order by tnsm.NOMBRE_NIVEL_SOLICITUD_MANTENIMIENTO");
                LOGGER.debug("consulta cargar tipos nivel mantenimiento " + consulta.toString());
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                tiposNivelSolicitudMantenimientoSelectList=new ArrayList<SelectItem>();
                while (res.next()) 
                {
                    tiposNivelSolicitudMantenimientoSelectList.add(new SelectItem(res.getInt("COD_NIVEL_SOLICITUD_MANTENIMIENTO"),res.getString("NOMBRE_NIVEL_SOLICITUD_MANTENIMIENTO")));
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
        private void cargarTiposSolicitudMantenimientoSelectList()
        {
            try 
            {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select tsm.COD_TIPO_SOLICITUD,tsm.NOMBRE_TIPO_SOLICITUD");
                                            consulta.append(" from TIPOS_SOLICITUD_MANTENIMIENTO tsm ");
                                            consulta.append(" order by tsm.NOMBRE_TIPO_SOLICITUD");
                LOGGER.debug("consulta cargar " + consulta.toString());
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                tiposSolicitudMantenimientoSelectList=new ArrayList<SelectItem>();
                while (res.next()) 
                {
                    tiposSolicitudMantenimientoSelectList.add(new SelectItem(res.getInt("COD_TIPO_SOLICITUD"),res.getString("NOMBRE_TIPO_SOLICITUD")));
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
        private void cargarAreasEmpresaSelectList()
        {
            try {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select DISTINCT ae.COD_AREA_EMPRESA,ae.NOMBRE_AREA_EMPRESA");
                                            consulta.append(" from AREAS_EMPRESA ae ");
                                            consulta.append(" where ae.COD_ESTADO_REGISTRO=1");
                                            consulta.append(" order by ae.NOMBRE_AREA_EMPRESA");
                LOGGER.debug("consulta cargar areas Empresa select" + consulta.toString());
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                areasEmpresaSelectList=new ArrayList<SelectItem>();
                while (res.next()) 
                {
                    areasEmpresaSelectList.add(new SelectItem(res.getString("COD_AREA_EMPRESA"),res.getString("NOMBRE_AREA_EMPRESA")));
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
        public String getCargarSolicitudMantenimientoAprobacionList()
        {
            this.cargarMaquinariasSelectList();
            this.cargarEstadosSolicitudMantenimientoSelectList();
            this.cargarTiposNivelSolicitudMantenimientoSelectList();
            this.cargarTiposSolicitudMantenimientoSelectList();
            this.cargarAreasEmpresaSelectList();
            this.cargarSolicitudMantenimientoAprobacionList();
            this.cargarPersonalSolicitudMantenimientoSelectList();
            return null;
        }
        public String buscarSolicitudMantenimientoAprobacion_action()
        {
            begin=0;
            end=10;
            this.cargarSolicitudMantenimientoAprobacionList();
            return null;
        }
        private void cargarSolicitudMantenimientoAprobacionList()
        {
            try {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select *");
                                            consulta.append(" from (");
                                                    consulta.append(" select ROW_NUMBER() OVER (ORDER BY sm.COD_SOLICITUD_MANTENIMIENTO desc) as 'FILAS',");
                                                            consulta.append(" sm.NRO_ORDEN_TRABAJO,sm.COD_SOLICITUD_MANTENIMIENTO,SM.FECHA_SOLICITUD_MANTENIMIENTO,ae.COD_AREA_EMPRESA,ae.NOMBRE_AREA_EMPRESA,tsm.COD_TIPO_SOLICITUD,");
                                                            consulta.append(" tsm.NOMBRE_TIPO_SOLICITUD,esm.NOMBRE_ESTADO_SOLICITUD,esm.COD_ESTADO_SOLICITUD");
                                                            consulta.append(" ,sm.COD_MAQUINARIA,isnull(m.NOMBRE_MAQUINA,'') as NOMBRE_MAQUINA");
                                                            consulta.append(" ,sm.COD_AREA_INSTALACION,ai.NOMBRE_AREA_INSTALACION");
                                                            consulta.append(",sm.COD_MODULO_INSTALACION,mi.NOMBRE_MODULO_INSTALACION");
                                                            consulta.append(" ,sm.AFECTARA_PRODUCCION,sm.OBS_SOLICITUD_MANTENIMIENTO");
                                                            consulta.append(" ,sm.COD_PERSONAL,isnull(p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL,'') as nombresPersonal");
                                                            consulta.append(" ,sm.DESCRIPCION_ESTADO,sm.FECHA_APROBACION");
                                                    consulta.append(" from SOLICITUDES_MANTENIMIENTO sm ");
                                                            consulta.append(" inner join AREAS_EMPRESA ae on ae.COD_AREA_EMPRESA=sm.COD_AREA_EMPRESA");
                                                            consulta.append(" inner join TIPOS_SOLICITUD_MANTENIMIENTO tsm on tsm.COD_TIPO_SOLICITUD=sm.COD_TIPO_SOLICITUD_MANTENIMIENTO");
                                                            consulta.append(" inner join ESTADOS_SOLICITUD_MANTENIMIENTO esm on esm.COD_ESTADO_SOLICITUD=sm.COD_ESTADO_SOLICITUD_MANTENIMIENTO");
                                                            consulta.append(" left outer join MAQUINARIAS m on m.COD_MAQUINA=sm.COD_MAQUINARIA");
                                                            consulta.append(" left outer join AREAS_INSTALACIONES ai on ai.COD_AREA_INSTALACION =sm.COD_AREA_INSTALACION");
                                                                    consulta.append(" and ai.COD_AREA_EMPRESA = sm.COD_AREA_EMPRESA");
                                                            consulta.append(" left outer join MODULOS_INSTALACIONES mi on mi.COD_MODULO_INSTALACION = sm.COD_MODULO_INSTALACION");
                                                            consulta.append(" inner join PERSONAL p on p.COD_PERSONAL=sm.COD_PERSONAL");
                                                    consulta.append(" WHERE 1=1");
                                                            if(!solicitudMantenimientoBuscar.getMaquinaria().getCodMaquina().equals("0"))
                                                                consulta.append(" and sm.COD_MAQUINARIA=").append(solicitudMantenimientoBuscar.getMaquinaria().getCodMaquina());
                                                            if(!solicitudMantenimientoBuscar.getPersonal_usuario().getCodPersonal().equals("0"))
                                                                consulta.append(" and sm.COD_PERSONAL=").append(solicitudMantenimientoBuscar.getPersonal_usuario().getCodPersonal());
                                                            if(!solicitudMantenimientoBuscar.getAreasEmpresa().getCodAreaEmpresa().equals("0"))
                                                                consulta.append(" and sm.COD_AREA_EMPRESA=").append(solicitudMantenimientoBuscar.getAreasEmpresa().getCodAreaEmpresa());
                                                            if(solicitudMantenimientoBuscar.getCodSolicitudMantenimiento()>0)
                                                                consulta.append(" and sm.COD_SOLICITUD_MANTENIMIENTO=").append(solicitudMantenimientoBuscar.getCodSolicitudMantenimiento());
                                                            if(solicitudMantenimientoBuscar.getNroOrdenTrabajo()>0)
                                                                consulta.append(" and sm.NRO_ORDEN_TRABAJO=").append(solicitudMantenimientoBuscar.getNroOrdenTrabajo());
                                                            if(solicitudMantenimientoBuscar.getTiposNivelSolicitudMantenimiento().getCodTipoNivelSolicitudMantenimiento()>0)
                                                                consulta.append(" and sm.COD_TIPO_NIVEL_SOLICITUD_MANTENIMIENTO=").append(solicitudMantenimientoBuscar.getTiposNivelSolicitudMantenimiento().getCodTipoNivelSolicitudMantenimiento());
                                                            if(solicitudMantenimientoBuscar.getTiposSolicitudMantenimiento().getCodTipoSolicitud()>0)
                                                                consulta.append(" and sm.COD_TIPO_SOLICITUD_MANTENIMIENTO=").append(solicitudMantenimientoBuscar.getTiposSolicitudMantenimiento().getCodTipoSolicitud());
                                                            if(solicitudMantenimientoBuscar.getEstadoSolicitudMantenimiento().getCodEstadoSolicitudMantenimiento()>0)
                                                                consulta.append(" and sm.COD_ESTADO_SOLICITUD_MANTENIMIENTO=").append(solicitudMantenimientoBuscar.getEstadoSolicitudMantenimiento().getCodEstadoSolicitudMantenimiento());
                                            consulta.append(" ) as listadoMantenimiento");
                                            consulta.append(" where FILAS BETWEEN ").append(begin).append(" AND ").append(end);
                LOGGER.debug("consulta cargar " + consulta.toString());
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                solicitudMantenimientoAprobacionList=new ArrayList<SolicitudMantenimiento>();
                while (res.next()) 
                {
                    SolicitudMantenimiento nuevo=new SolicitudMantenimiento();
                    nuevo.setFechaAprobacion(res.getTimestamp("FECHA_APROBACION"));
                    nuevo.getPersonal_usuario().setCodPersonal(res.getString("COD_PERSONAL"));
                    nuevo.getPersonal_usuario().setNombrePersonal(res.getString("nombresPersonal"));
                    nuevo.setNroOrdenTrabajo(res.getInt("NRO_ORDEN_TRABAJO"));
                    nuevo.setAfectaraProduccion(res.getInt("AFECTARA_PRODUCCION"));
                    nuevo.setObsSolicitudMantenimiento(res.getString("OBS_SOLICITUD_MANTENIMIENTO"));
                    nuevo.setCodSolicitudMantenimiento(res.getInt("COD_SOLICITUD_MANTENIMIENTO"));
                    nuevo.setFechaSolicitudMantenimiento(res.getTimestamp("FECHA_SOLICITUD_MANTENIMIENTO"));
                    nuevo.getAreasEmpresa().setCodAreaEmpresa(res.getString("COD_AREA_EMPRESA"));
                    nuevo.getAreasEmpresa().setNombreAreaEmpresa(res.getString("NOMBRE_AREA_EMPRESA"));
                    nuevo.getTiposSolicitudMantenimiento().setCodTipoSolicitud(res.getInt("COD_TIPO_SOLICITUD"));
                    nuevo.getTiposSolicitudMantenimiento().setNombreTipoSolicitud(res.getString("NOMBRE_TIPO_SOLICITUD"));
                    nuevo.getEstadoSolicitudMantenimiento().setCodEstadoSolicitudMantenimiento(res.getInt("COD_ESTADO_SOLICITUD"));
                    nuevo.getEstadoSolicitudMantenimiento().setNombreEstadoSolicitudMantenimiento(res.getString("NOMBRE_ESTADO_SOLICITUD"));
                    nuevo.getMaquinaria().setCodMaquina(res.getString("COD_MAQUINARIA"));
                    nuevo.getMaquinaria().setNombreMaquina(res.getString("NOMBRE_MAQUINA"));
                    nuevo.getAreasInstalaciones().setCodAreaInstalacion(res.getInt("COD_AREA_INSTALACION"));
                    nuevo.getAreasInstalaciones().setNombreAreaInstalacion(res.getString("NOMBRE_AREA_INSTALACION"));
                    nuevo.getModulosInstalaciones().setCodModuloInstalacion(res.getInt("COD_MODULO_INSTALACION"));
                    nuevo.getModulosInstalaciones().setNombreModuloInstalacion(res.getString("NOMBRE_MODULO_INSTALACION"));
                    nuevo.setDescripcionEstado(res.getString("DESCRIPCION_ESTADO"));
                    solicitudMantenimientoAprobacionList.add(nuevo);
                }
                cantidadfilas=solicitudMantenimientoAprobacionList.size();
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
    //<editor-fold desc="getter and setter">

        public String getMensaje() {
            return mensaje;
        }

        public void setMensaje(String mensaje) {
            this.mensaje = mensaje;
        }

        public List<SolicitudMantenimiento> getSolicitudMantenimientoAprobacionList() {
            return solicitudMantenimientoAprobacionList;
        }

        public void setSolicitudMantenimientoAprobacionList(List<SolicitudMantenimiento> solicitudMantenimientoAprobacionList) {
            this.solicitudMantenimientoAprobacionList = solicitudMantenimientoAprobacionList;
        }

        public SolicitudMantenimiento getSolicitudMantenimientoBuscar() {
            return solicitudMantenimientoBuscar;
        }

        public void setSolicitudMantenimientoBuscar(SolicitudMantenimiento solicitudMantenimientoBuscar) {
            this.solicitudMantenimientoBuscar = solicitudMantenimientoBuscar;
        }

        public SolicitudMantenimiento getSolicitudMantenimientoAnular() {
            return solicitudMantenimientoAnular;
        }

        public void setSolicitudMantenimientoAnular(SolicitudMantenimiento solicitudMantenimientoAnular) {
            this.solicitudMantenimientoAnular = solicitudMantenimientoAnular;
        }

        public SolicitudMantenimiento getSolicitudMantenimientoTarea() {
            return solicitudMantenimientoTarea;
        }

        public void setSolicitudMantenimientoTarea(SolicitudMantenimiento solicitudMantenimientoTarea) {
            this.solicitudMantenimientoTarea = solicitudMantenimientoTarea;
        }

        public HtmlDataTable getSolicitudMantenimientoAprobacionDataTable() {
            return solicitudMantenimientoAprobacionDataTable;
        }

        public void setSolicitudMantenimientoAprobacionDataTable(HtmlDataTable solicitudMantenimientoAprobacionDataTable) {
            this.solicitudMantenimientoAprobacionDataTable = solicitudMantenimientoAprobacionDataTable;
        }

        public List<SolicitudMantenimientoDetalleTareas> getSolicitudMantenimientoDetalleTareasList() {
            return solicitudMantenimientoDetalleTareasList;
        }

        public void setSolicitudMantenimientoDetalleTareasList(List<SolicitudMantenimientoDetalleTareas> solicitudMantenimientoDetalleTareasList) {
            this.solicitudMantenimientoDetalleTareasList = solicitudMantenimientoDetalleTareasList;
        }

        public List<SelectItem> getPersonalSelectList() {
            return personalSelectList;
        }

        public void setPersonalSelectList(List<SelectItem> personalSelectList) {
            this.personalSelectList = personalSelectList;
        }

        public List<SelectItem> getTiposTareaSelectList() {
            return tiposTareaSelectList;
        }

        public void setTiposTareaSelectList(List<SelectItem> tiposTareaSelectList) {
            this.tiposTareaSelectList = tiposTareaSelectList;
        }

        public List<SelectItem> getProveedoresSelectList() {
            return proveedoresSelectList;
        }

        public void setProveedoresSelectList(List<SelectItem> proveedoresSelectList) {
            this.proveedoresSelectList = proveedoresSelectList;
        }

        public SolicitudMantenimientoDetalleTareas getSolicitudMantenimientoDetalleTareaAgregar() {
            return solicitudMantenimientoDetalleTareaAgregar;
        }

        public void setSolicitudMantenimientoDetalleTareaAgregar(SolicitudMantenimientoDetalleTareas solicitudMantenimientoDetalleTareaAgregar) {
            this.solicitudMantenimientoDetalleTareaAgregar = solicitudMantenimientoDetalleTareaAgregar;
        }

        public SolicitudMantenimientoDetalleTareas getSolicitudMantenimientoDetalleTareaEditar() {
            return solicitudMantenimientoDetalleTareaEditar;
        }

        public void setSolicitudMantenimientoDetalleTareaEditar(SolicitudMantenimientoDetalleTareas solicitudMantenimientoDetalleTareaEditar) {
            this.solicitudMantenimientoDetalleTareaEditar = solicitudMantenimientoDetalleTareaEditar;
        }

        public String[] getCodPersonalAgregarAsignar() {
            return codPersonalAgregarAsignar;
        }

        public void setCodPersonalAgregarAsignar(String[] codPersonalAgregarAsignar) {
            this.codPersonalAgregarAsignar = codPersonalAgregarAsignar;
        }

        public List<SolicitudMantenimientoSolicitudSalidaAlmacen> getSolicitudMantenimientoSolicitudSalidaAlmacenList() {
            return solicitudMantenimientoSolicitudSalidaAlmacenList;
        }

        public void setSolicitudMantenimientoSolicitudSalidaAlmacenList(List<SolicitudMantenimientoSolicitudSalidaAlmacen> solicitudMantenimientoSolicitudSalidaAlmacenList) {
            this.solicitudMantenimientoSolicitudSalidaAlmacenList = solicitudMantenimientoSolicitudSalidaAlmacenList;
        }

        public SolicitudMantenimiento getSolicitudMantenimientoSolicitudSalidaAlmacen() {
            return solicitudMantenimientoSolicitudSalidaAlmacen;
        }

        public void setSolicitudMantenimientoSolicitudSalidaAlmacen(SolicitudMantenimiento solicitudMantenimientoSolicitudSalidaAlmacen) {
            this.solicitudMantenimientoSolicitudSalidaAlmacen = solicitudMantenimientoSolicitudSalidaAlmacen;
        }

        public SolicitudMantenimientoSolicitudSalidaAlmacen getSolicitudMantenimientoSolicitudSalidaAlmacenAgregar() {
            return solicitudMantenimientoSolicitudSalidaAlmacenAgregar;
        }

        public void setSolicitudMantenimientoSolicitudSalidaAlmacenAgregar(SolicitudMantenimientoSolicitudSalidaAlmacen solicitudMantenimientoSolicitudSalidaAlmacenAgregar) {
            this.solicitudMantenimientoSolicitudSalidaAlmacenAgregar = solicitudMantenimientoSolicitudSalidaAlmacenAgregar;
        }

    public SolicitudMantenimientoSolicitudSalidaAlmacen getSolicitudMantenimientoSolicitudSalidaAlmacenGenerarSalida() {
        return solicitudMantenimientoSolicitudSalidaAlmacenGenerarSalida;
    }

    public void setSolicitudMantenimientoSolicitudSalidaAlmacenGenerarSalida(SolicitudMantenimientoSolicitudSalidaAlmacen solicitudMantenimientoSolicitudSalidaAlmacenGenerarSalida) {
        this.solicitudMantenimientoSolicitudSalidaAlmacenGenerarSalida = solicitudMantenimientoSolicitudSalidaAlmacenGenerarSalida;
    }

        


        
        

        
        
        
        
            

    
    
    
    
    
    
    
    
    
    
    
    //</editor-fold>
    
    
    SolicitudMantenimiento solicitudMantenimiento = new SolicitudMantenimiento();    
    SolicitudMantenimientoDetalleTareas solicitudMantenimientoDetalleTareas = new SolicitudMantenimientoDetalleTareas();
    SolicitudMantenimientoDetalleTareas solicitudMantenimientoDetalleTareasEditar = new SolicitudMantenimientoDetalleTareas();
    HtmlDataTable solicitudMantenimientoDetalleTareasDataTable = new HtmlDataTable();
    List tiposTareasList  = new ArrayList();
    List personalList  = new ArrayList();
    List proovedorList = new ArrayList();
    String enteAsignado= "";
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    
    
    public SolicitudMantenimiento getSolicitudMantenimiento() {
        return solicitudMantenimiento;
    }

    public void setSolicitudMantenimiento(SolicitudMantenimiento solicitudMantenimiento) {
        this.solicitudMantenimiento = solicitudMantenimiento;
    }

    public SolicitudMantenimientoDetalleTareas getSolicitudMantenimientoDetalleTareas() {
        return solicitudMantenimientoDetalleTareas;
    }

    public void setSolicitudMantenimientoDetalleTareas(SolicitudMantenimientoDetalleTareas solicitudMantenimientoDetalleTareas) {
        this.solicitudMantenimientoDetalleTareas = solicitudMantenimientoDetalleTareas;
    }

    public HtmlDataTable getSolicitudMantenimientoDetalleTareasDataTable() {
        return solicitudMantenimientoDetalleTareasDataTable;
    }

    public void setSolicitudMantenimientoDetalleTareasDataTable(HtmlDataTable solicitudMantenimientoDetalleTareasDataTable) {
        this.solicitudMantenimientoDetalleTareasDataTable = solicitudMantenimientoDetalleTareasDataTable;
    }

    public SolicitudMantenimientoDetalleTareas getSolicitudMantenimientoDetalleTareasEditar() {
        return solicitudMantenimientoDetalleTareasEditar;
    }

    public void setSolicitudMantenimientoDetalleTareasEditar(SolicitudMantenimientoDetalleTareas solicitudMantenimientoDetalleTareasEditar) {
        this.solicitudMantenimientoDetalleTareasEditar = solicitudMantenimientoDetalleTareasEditar;
    }



    public List getTiposTareasList() {
        return tiposTareasList;
    }

    public void setTiposTareasList(List tiposTareasList) {
        this.tiposTareasList = tiposTareasList;
    }

    public List getPersonalList() {
        return personalList;
    }

    public void setPersonalList(List personalList) {
        this.personalList = personalList;
    }

    public List getProovedorList() {
        return proovedorList;
    }

    public void setProovedorList(List proovedorList) {
        this.proovedorList = proovedorList;
    }

    public String getEnteAsignado() {
        return enteAsignado;
    }

    public void setEnteAsignado(String enteAsignado) {
        this.enteAsignado = enteAsignado;
    }

    public SolicitudMantenimiento getSolicitudMantenimientoDescribirEstado() {
        return solicitudMantenimientoDescribirEstado;
    }

    public void setSolicitudMantenimientoDescribirEstado(SolicitudMantenimiento solicitudMantenimientoDescribirEstado) {
        this.solicitudMantenimientoDescribirEstado = solicitudMantenimientoDescribirEstado;
    }

    public SolicitudMantenimientoDetalleMateriales getSolicitudMantenimientoDetalleMaterialBuscar() {
        return solicitudMantenimientoDetalleMaterialBuscar;
    }

    public void setSolicitudMantenimientoDetalleMaterialBuscar(SolicitudMantenimientoDetalleMateriales solicitudMantenimientoDetalleMaterialBuscar) {
        this.solicitudMantenimientoDetalleMaterialBuscar = solicitudMantenimientoDetalleMaterialBuscar;
    }

    public List<SolicitudMantenimientoDetalleMateriales> getSolicitudMantenimientoDetalleMaterialesList() {
        return solicitudMantenimientoDetalleMaterialesList;
    }

    public void setSolicitudMantenimientoDetalleMaterialesList(List<SolicitudMantenimientoDetalleMateriales> solicitudMantenimientoDetalleMaterialesList) {
        this.solicitudMantenimientoDetalleMaterialesList = solicitudMantenimientoDetalleMaterialesList;
    }

    public HtmlDataTable getSolicitudMantenimientoDetalleMaterialesDataTable() {
        return solicitudMantenimientoDetalleMaterialesDataTable;
    }

    public void setSolicitudMantenimientoDetalleMaterialesDataTable(HtmlDataTable solicitudMantenimientoDetalleMaterialesDataTable) {
        this.solicitudMantenimientoDetalleMaterialesDataTable = solicitudMantenimientoDetalleMaterialesDataTable;
    }

    public List<SelectItem> getAreasEmpresaSelectList() {
        return areasEmpresaSelectList;
    }

    public void setAreasEmpresaSelectList(List<SelectItem> areasEmpresaSelectList) {
        this.areasEmpresaSelectList = areasEmpresaSelectList;
    }

    public List<SelectItem> getTiposSolicitudMantenimientoSelectList() {
        return tiposSolicitudMantenimientoSelectList;
    }

    public void setTiposSolicitudMantenimientoSelectList(List<SelectItem> tiposSolicitudMantenimientoSelectList) {
        this.tiposSolicitudMantenimientoSelectList = tiposSolicitudMantenimientoSelectList;
    }

    public List<SelectItem> getTiposNivelSolicitudMantenimientoSelectList() {
        return tiposNivelSolicitudMantenimientoSelectList;
    }

    public void setTiposNivelSolicitudMantenimientoSelectList(List<SelectItem> tiposNivelSolicitudMantenimientoSelectList) {
        this.tiposNivelSolicitudMantenimientoSelectList = tiposNivelSolicitudMantenimientoSelectList;
    }

    public List<SelectItem> getEstadosSolicitudMantenimientoSelectList() {
        return estadosSolicitudMantenimientoSelectList;
    }

    public void setEstadosSolicitudMantenimientoSelectList(List<SelectItem> estadosSolicitudMantenimientoSelectList) {
        this.estadosSolicitudMantenimientoSelectList = estadosSolicitudMantenimientoSelectList;
    }

    public SolicitudMantenimiento getSolicitudMantenimientoAprobar() {
        return solicitudMantenimientoAprobar;
    }

    public void setSolicitudMantenimientoAprobar(SolicitudMantenimiento solicitudMantenimientoAprobar) {
        this.solicitudMantenimientoAprobar = solicitudMantenimientoAprobar;
    }

    public List<SelectItem> getMaquinariaSelectList() {
        return maquinariaSelectList;
    }

    public void setMaquinariaSelectList(List<SelectItem> maquinariaSelectList) {
        this.maquinariaSelectList = maquinariaSelectList;
    }

    public List<SelectItem> getPersonalSolicitudMantenimientoSelectList() {
        return personalSolicitudMantenimientoSelectList;
    }

    public void setPersonalSolicitudMantenimientoSelectList(List<SelectItem> personalSolicitudMantenimientoSelectList) {
        this.personalSolicitudMantenimientoSelectList = personalSolicitudMantenimientoSelectList;
    }

    public List<SelectItem> getAlmacenesSelectList() {
        return almacenesSelectList;
    }

    public void setAlmacenesSelectList(List<SelectItem> almacenesSelectList) {
        this.almacenesSelectList = almacenesSelectList;
    }
    
    
    
    

    
    
    
    
    
    

    public String editarSolicitudMantenimientoDetalleTareas_action(){
        try {
               con=Util.openConnection(con);
               Iterator i = solicitudMantenimientoDetalleTareasList.iterator();
               while(i.hasNext()){
                   SolicitudMantenimientoDetalleTareas solicitudMantenimientoDetalleTareasItem = (SolicitudMantenimientoDetalleTareas) i.next();
                   if(solicitudMantenimientoDetalleTareasItem.getChecked().booleanValue()==true){
                       solicitudMantenimientoDetalleTareas =solicitudMantenimientoDetalleTareasItem;
                       solicitudMantenimientoDetalleTareasEditar.getSolicitudMantenimiento().setCodSolicitudMantenimiento(solicitudMantenimientoDetalleTareasItem.getSolicitudMantenimiento().getCodSolicitudMantenimiento());
                       solicitudMantenimientoDetalleTareasEditar.getTiposTarea().setCodTipoTarea(solicitudMantenimientoDetalleTareasItem.getTiposTarea().getCodTipoTarea());
                       solicitudMantenimientoDetalleTareasEditar.getPersonal().setCodPersonal(solicitudMantenimientoDetalleTareasItem.getPersonal().getCodPersonal());

                       if(!solicitudMantenimientoDetalleTareas.getPersonal().getCodPersonal().equals("0")){
                           enteAsignado="interno";
                       }
                       if(solicitudMantenimientoDetalleTareas.getProveedores().getCodProveedor()>0){
                           enteAsignado="externo";
                       }
                       System.out.println("enteAsignado " + enteAsignado);


                       break;
                   }
               }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public String guardarEdicionSolicitudMantenimientoDetalleTareas_action(){
        try {
            con=Util.openConnection(con);
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd hh:mm");


            String consulta = " UPDATE SOLICITUDES_MANTENIMIENTO_DETALLE_TAREAS  SET   " +
                    "  COD_TIPO_TAREA = '"+solicitudMantenimientoDetalleTareas.getTiposTarea().getCodTipoTarea()+"'," +
                    "  DESCRIPCION = '"+solicitudMantenimientoDetalleTareas.getDescripcion()+"', ";
                    if(enteAsignado.equals("interno")){
                        consulta += "  COD_PERSONAL = '"+solicitudMantenimientoDetalleTareas.getPersonal().getCodPersonal()+"'," +
                        "  COD_PROVEEDOR = 0, " ;
                    }else{
                        consulta += "  COD_PERSONAL = '0'," +
                        "  COD_PROVEEDOR = "+solicitudMantenimientoDetalleTareas.getProveedores().getCodProveedor()+", " ;
                    }
                    consulta += "  FECHA_INICIAL = '"+sdf.format(solicitudMantenimientoDetalleTareas.getFechaInicial())+"',  " +
                    "  FECHA_FINAL = '"+ sdf.format(solicitudMantenimientoDetalleTareas.getFechaFinal())+"'  " +
                    " ,FECHA_ASIGNACION = '"+sdf.format(solicitudMantenimientoDetalleTareas.getFechaInicial())+"' " +
                    "  WHERE  COD_SOLICITUD_MANTENIMIENTO = '"+solicitudMantenimientoDetalleTareasEditar.getSolicitudMantenimiento().getCodSolicitudMantenimiento()+"' " +
                    "  AND COD_TIPO_TAREA = '"+solicitudMantenimientoDetalleTareasEditar.getTiposTarea().getCodTipoTarea()+"'" +
                    "  AND COD_PERSONAL = '"+solicitudMantenimientoDetalleTareasEditar.getPersonal().getCodPersonal()+"'  ";

             
             System.out.println("consulta" + consulta);
             Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
             st.executeUpdate(consulta);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    


    public String verSolicitudMantenimientoDetalleTareasMaterial_action(){
        try {
            SolicitudMantenimientoDetalleTareas SolicitudMantenimientoDetalleTareasItem = (SolicitudMantenimientoDetalleTareas)solicitudMantenimientoDetalleTareasDataTable.getRowData();
            ExternalContext externalContext = FacesContext.getCurrentInstance().getExternalContext();
            Map<String, Object> sessionMap = externalContext.getSessionMap();
            sessionMap.put("SolicitudMantenimientoDetalleTareas", SolicitudMantenimientoDetalleTareasItem);
            this.redireccionar("../SolicitudMantenimientoDetalleTareasMaterial/navegadorSolicitudMantenimientoDetalleTareasMaterial.jsf");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public String verSolicitudMantenimientoDetalleTareasMaquinaria_action(){
        try {
            SolicitudMantenimientoDetalleTareas SolicitudMantenimientoDetalleTareasItem = (SolicitudMantenimientoDetalleTareas)solicitudMantenimientoDetalleTareasDataTable.getRowData();
            ExternalContext externalContext = FacesContext.getCurrentInstance().getExternalContext();
            Map<String, Object> sessionMap = externalContext.getSessionMap();
            sessionMap.put("SolicitudMantenimientoDetalleTareas", SolicitudMantenimientoDetalleTareasItem);
            this.redireccionar("../SolicitudMantenimientoDetalleTareasMaquinaria/navegadorSolicitudMantenimientoDetalleTareasMaquinaria.jsf");
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

    


}
