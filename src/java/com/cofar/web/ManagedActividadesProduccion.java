

package com.cofar.web;


import com.cofar.bean.ActividadesProduccion;
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
 *  @author Guery Garcia Jaldin
 *  @company COFAR
 */
public class ManagedActividadesProduccion extends  ManagedBean
{
    private List<ActividadesProduccion> actividadesProduccionList;
    private List<SelectItem> tiposActividadSelectList;
    private String mensaje="";
    private List<SelectItem> unidadesMedidaSelectList;
    private List<SelectItem> tiposActividadProducionSelectList;
    private ActividadesProduccion actividadesProduccionBuscar=new ActividadesProduccion();
    private Connection con;
    private ActividadesProduccion actividadesProduccionAgregar;
    private ActividadesProduccion actividadesProduccionEditar;
    
    
    
    public ManagedActividadesProduccion() 
    {
        LOGGER=LogManager.getRootLogger();
        actividadesProduccionBuscar.getEstadoReferencial().setCodEstadoRegistro("1");
        actividadesProduccionBuscar.getTiposActividadProduccion().setCodTipoActividadProduccion(0);
        actividadesProduccionBuscar.getTipoActividad().setCodTipoActividad(0);
    }
    // <editor-fold defaultstate="collapsed" desc="funciones eliminar actividades produccion">
        public String eliminarActividadProduccion_action()throws SQLException
        {
            mensaje="";
            for(ActividadesProduccion bean:actividadesProduccionList)
            {
                if(bean.getChecked())
                {
                    if(bean.getProcesosOrdenManufactura().getCodProcesoOrdenManufactura()==0)
                    {
                        if(this.cantidadDatosRegistradosActividad(bean.getCodActividad())==0)
                        {
                            mensaje = "";
                            try 
                            {
                                con = Util.openConnection(con);
                                con.setAutoCommit(false);
                                StringBuilder consulta = new StringBuilder("delete ACTIVIDADES_PRODUCCION");
                                                            consulta.append(" where COD_ACTIVIDAD=").append(bean.getCodActividad());
                                LOGGER.debug("consulta eliminar actividad" + consulta.toString());
                                PreparedStatement pst = con.prepareStatement(consulta.toString());
                                if (pst.executeUpdate() > 0) LOGGER.info("Se elimino la actividad");
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

                        }
                        else
                        {
                            mensaje="No se puede eliminar la actividad porque existen datos relacionados al mismo";
                        }
                    }
                    else
                    {
                        mensaje="No se puede eliminar la actividad porque la actividad esta relacionada con la OM";
                    }
                    break;
                }
            }
            if(mensaje.equals("1"))
            {
                this.cargarActividadesProduccion();
            }
            return null;
        }
    //</editor-fold>
    // <editor-fold defaultstate="collapsed" desc="funciones editar actividad produccion">
        public String editarActividadProduccion_action()
        {
            for(ActividadesProduccion bean:actividadesProduccionList)
            {
                if(bean.getChecked())
                {
                    actividadesProduccionEditar=bean;
                    actividadesProduccionEditar.setCantidadDatosRelacionados(this.cantidadDatosRegistradosActividad(bean.getCodActividad()));
                    break;
                }
            }
            return null;
        }
        public String guardarEdicionActividadProduccion_action()throws SQLException
        {
            mensaje = "";
            try 
            {
                con = Util.openConnection(con);
                con.setAutoCommit(false);
                StringBuilder consulta = new StringBuilder("update ACTIVIDADES_PRODUCCION");
                                            consulta.append(" set NOMBRE_ACTIVIDAD=?");
                                                    consulta.append(" ,OBS_ACTIVIDAD=?");
                                                    consulta.append(" ,COD_UNIDAD_MEDIDA=").append(actividadesProduccionEditar.getUnidadesMedida().getCodUnidadMedida());
                                                    consulta.append(" ,COD_TIPO_ACTIVIDAD_PRODUCCION=").append(actividadesProduccionEditar.getTiposActividadProduccion().getCodTipoActividadProduccion());
                                                    consulta.append(" ,COD_TIPO_ACTIVIDAD=").append(actividadesProduccionEditar.getTipoActividad().getCodTipoActividad());
                                                    consulta.append(" ,COD_ESTADO_REGISTRO=").append(actividadesProduccionEditar.getEstadoReferencial().getCodEstadoRegistro());
                                            consulta.append(" where COD_ACTIVIDAD=").append(actividadesProduccionEditar.getCodActividad());
                LOGGER.debug("consulta " + consulta.toString());
                PreparedStatement pst = con.prepareStatement(consulta.toString(), PreparedStatement.RETURN_GENERATED_KEYS);
                pst.setString(1,actividadesProduccionEditar.getNombreActividad());LOGGER.info("p1:"+actividadesProduccionEditar.getNombreActividad());
                pst.setString(2,actividadesProduccionEditar.getObsActividad());LOGGER.info("p2:"+actividadesProduccionEditar.getObsActividad());
                if (pst.executeUpdate() > 0) LOGGER.info("Se registro la transacción");
                con.commit();
                mensaje = "1";
                pst.close();
            } 
            catch (SQLException ex) {
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
    //</editor-fold>
    private int cantidadDatosRegistradosActividad(int codActividad)
    {
        int cantidadDatos=0;
        try 
        {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select count(*) as cantidadRegistros");
                                        consulta.append(" from ACTIVIDADES_FORMULA_MAESTRA afm ");
                                        consulta.append(" where afm.COD_ACTIVIDAD=").append(codActividad);
            LOGGER.debug("consulta verificar cantidad registro actividad formula "+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            if(res.next())cantidadDatos+=res.getInt(1);
            consulta=new StringBuilder("select count (*) as cantidadDatosRegistrados");
                        consulta.append(" from ACTIVIDADES_PROGRAMA_PRODUCCION a ");
                        consulta.append(" where a.COD_ACTIVIDAD=").append(codActividad);
            LOGGER.debug("consulta verificar cantidad registros actividad produccion "+consulta.toString());
            res=st.executeQuery(consulta.toString());
            if(res.next())cantidadDatos+=res.getInt(1);
            consulta=new StringBuilder("select count(*) as cantidadRegistros");
                        consulta.append(" from SEGUIMIENTO_PROGRAMA_PRODUCCION_PROCESO_PERSONAL sp");
                        consulta.append(" where sp.COD_ACTIVIDAD=").append(codActividad);
            LOGGER.debug("consulta verificar cantida registros seguimiento om "+consulta.toString());
            if(res.next())cantidadDatos+=res.getInt(1);
            consulta=new StringBuilder("select COUNT(*) as cantidadRegistros");
                       consulta.append(" from SEGUIMIENTO_PROGRAMA_PRODUCCION_INDIRECTO s");
                       consulta.append(" where s.COD_ACTIVIDAD=").append(codActividad);
            LOGGER.debug("consulta verificar registro seguimiento "+consulta.toString());
            res=st.executeQuery(consulta.toString());
            if(res.next())cantidadDatos+=res.getInt(1);
            consulta=new StringBuilder("select COUNT(*) as cantidadRegistros");
                        consulta.append(" from SEGUIMIENTO_PROGRAMA_PRODUCCION_INDIRECTO_PERSONAL s");
                        consulta.append(" where s.COD_ACTVIDAD=").append(codActividad);
            LOGGER.debug("consulta verificar registro seguimiento personal "+consulta.toString());
            res=st.executeQuery(consulta.toString());
            if(res.next())cantidadDatos+=res.getInt(1);
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
        return cantidadDatos;
    }
    // <editor-fold defaultstate="collapsed" desc="funciones agregar actividad">
        public String getCargarAgregarActividadesProduccion()
        {
            actividadesProduccionAgregar=new ActividadesProduccion();
            return null;
        }
        public String guardarAgregarActividadProduccion_action()throws SQLException
        {
            mensaje = "";
            try {
                con = Util.openConnection(con);
                con.setAutoCommit(false);
                StringBuilder consulta = new StringBuilder("INSERT INTO ACTIVIDADES_PRODUCCION( NOMBRE_ACTIVIDAD,OBS_ACTIVIDAD, COD_ESTADO_REGISTRO, COD_TIPO_ACTIVIDAD_PRODUCCION,COD_TIPO_ACTIVIDAD, COD_UNIDAD_MEDIDA)");
                                    consulta.append("VALUES (");
                                            consulta.append("?,");
                                            consulta.append("?,");
                                            consulta.append("1,");
                                            consulta.append(actividadesProduccionAgregar.getTiposActividadProduccion().getCodTipoActividadProduccion()).append(",");
                                            consulta.append(actividadesProduccionAgregar.getTipoActividad().getCodTipoActividad()).append(",");
                                            consulta.append(actividadesProduccionAgregar.getUnidadesMedida().getCodUnidadMedida());
                                    consulta.append(")");
                LOGGER.debug("consulta registrar actividad" + consulta.toString());
                PreparedStatement pst = con.prepareStatement(consulta.toString(), PreparedStatement.RETURN_GENERATED_KEYS);
                pst.setString(1,actividadesProduccionAgregar.getNombreActividad());LOGGER.info("p1:"+actividadesProduccionAgregar.getNombreActividad());
                pst.setString(2,actividadesProduccionAgregar.getObsActividad());LOGGER.info("p2:"+actividadesProduccionAgregar.getObsActividad());
                if (pst.executeUpdate() > 0)LOGGER.info("Se registro la actividad");
                con.commit();
                mensaje = "1";
                pst.close();
            } catch (SQLException ex) {
                mensaje = "Ocurrio un error al momento de guardar la transaccion";
                con.rollback();
                LOGGER.warn(ex.getMessage());
            } catch (Exception ex) {
                mensaje = "Ocurrio un error al momento de guardar la transaccion,verifique los datos introducidos";
                LOGGER.warn(ex.getMessage());
            } finally {
                this.cerrarConexion(con);
            }
            return null;
        }
    //</editor-fold>
    
    // <editor-fold defaultstate="collapsed" desc="funciones cargar navegador">

    
        public String getCargarActividadesProduccion()
        {
            this.cargarTiposActividadProduccionSelectList();
            this.cargarTiposActividadSelectList();
            this.cargarUnidadesMedidaSelectList();
            this.cargarActividadesProduccion();
            return null;
        }
        public String buscarActividadesProduccion_action()
        {
            this.cargarActividadesProduccion();
            return null;
        }
        private void cargarActividadesProduccion()
        {
            try 
            {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select ap.COD_ACTIVIDAD,ap.NOMBRE_ACTIVIDAD,ap.OBS_ACTIVIDAD,ap.COD_ESTADO_REGISTRO,");
                                                    consulta.append(" er.NOMBRE_ESTADO_REGISTRO,ap.COD_UNIDAD_MEDIDA,isnull(um.NOMBRE_UNIDAD_MEDIDA,'') as NOMBRE_UNIDAD_MEDIDA");
                                                    consulta.append(" ,ap.COD_PROCESO_ORDEN_MANUFACTURA,pom.NOMBRE_PROCESO_ORDEN_MANUFACTURA");
                                                    consulta.append(" ,ap.COD_TIPO_ACTIVIDAD_PRODUCCION,tap.NOMBRE_TIPO_ACTIVIDAD_PRODUCCION");
                                                    consulta.append(" ,ap.COD_TIPO_ACTIVIDAD,ta.NOMBRE_TIPO_ACTIVIDAD");
                                            consulta.append(" from ACTIVIDADES_PRODUCCION ap ");
                                                    consulta.append(" inner join ESTADOS_REFERENCIALES er on er.COD_ESTADO_REGISTRO=ap.COD_ESTADO_REGISTRO");
                                                    consulta.append(" left outer join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=ap.COD_UNIDAD_MEDIDA");
                                                    consulta.append(" left outer join PROCESOS_ORDEN_MANUFACTURA pom on pom.COD_PROCESO_ORDEN_MANUFACTURA=ap.COD_PROCESO_ORDEN_MANUFACTURA");
                                                    consulta.append(" inner join TIPOS_ACTIVIDAD ta on ta.COD_TIPO_ACTIVIDAD=ap.COD_TIPO_ACTIVIDAD");
                                                    consulta.append(" inner join TIPOS_ACTIVIDAD_PRODUCCION tap on tap.COD_TIPO_ACTIVIDAD_PRODUCCION=ap.COD_TIPO_ACTIVIDAD_PRODUCCION");
                                            consulta.append(" where 1=1");
                                                    if(actividadesProduccionBuscar.getNombreActividad().length()>0)
                                                        consulta.append(" and ap.NOMBRE_ACTIVIDAD like '%").append(actividadesProduccionBuscar.getNombreActividad()).append("%'");
                                                    if(actividadesProduccionBuscar.getTipoActividad().getCodTipoActividad()>0)
                                                        consulta.append(" and ap.COD_TIPO_ACTIVIDAD=").append(actividadesProduccionBuscar.getTipoActividad().getCodTipoActividad());
                                                    if(actividadesProduccionBuscar.getTiposActividadProduccion().getCodTipoActividadProduccion()>0)
                                                        consulta.append("  and ap.COD_TIPO_ACTIVIDAD_PRODUCCION=").append(actividadesProduccionBuscar.getTiposActividadProduccion().getCodTipoActividadProduccion());
                                                    if(!actividadesProduccionBuscar.getEstadoReferencial().getCodEstadoRegistro().equals("0"))
                                                        consulta.append(" and ap.COD_ESTADO_REGISTRO=").append(actividadesProduccionBuscar.getEstadoReferencial().getCodEstadoRegistro());
                                            consulta.append(" order by ap.NOMBRE_ACTIVIDAD");
                LOGGER.debug("consulta cargar actividades produccion "+consulta.toString());
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                actividadesProduccionList=new ArrayList<ActividadesProduccion>();
                while (res.next()) 
                {
                    ActividadesProduccion nuevo=new ActividadesProduccion();
                    nuevo.setCodActividad(res.getInt("COD_ACTIVIDAD"));
                    nuevo.setNombreActividad(res.getString("NOMBRE_ACTIVIDAD"));
                    nuevo.setObsActividad(res.getString("OBS_ACTIVIDAD"));
                    nuevo.getEstadoReferencial().setCodEstadoRegistro(res.getString("COD_ESTADO_REGISTRO"));
                    nuevo.getEstadoReferencial().setNombreEstadoRegistro(res.getString("NOMBRE_ESTADO_REGISTRO"));
                    nuevo.getUnidadesMedida().setCodUnidadMedida(res.getString("COD_UNIDAD_MEDIDA"));
                    nuevo.getUnidadesMedida().setNombreUnidadMedida(res.getString("NOMBRE_UNIDAD_MEDIDA"));
                    nuevo.getProcesosOrdenManufactura().setCodProcesoOrdenManufactura(res.getInt("COD_PROCESO_ORDEN_MANUFACTURA"));
                    nuevo.getProcesosOrdenManufactura().setNombreProcesoOrdenManufactura(res.getString("NOMBRE_PROCESO_ORDEN_MANUFACTURA"));
                    nuevo.getTipoActividad().setCodTipoActividad(res.getInt("COD_TIPO_ACTIVIDAD"));
                    nuevo.getTipoActividad().setNombreTipoActividad(res.getString("NOMBRE_TIPO_ACTIVIDAD"));
                    nuevo.getTiposActividadProduccion().setCodTipoActividadProduccion(res.getInt("COD_TIPO_ACTIVIDAD_PRODUCCION"));
                    nuevo.getTiposActividadProduccion().setNombreTipoActividadProduccion(res.getString("NOMBRE_TIPO_ACTIVIDAD_PRODUCCION"));
                    actividadesProduccionList.add(nuevo);
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
    //</editor-fold>
    // <editor-fold defaultstate="collapsed" desc="cargando listas select">
        private void cargarUnidadesMedidaSelectList()
        {
            try {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select um.COD_UNIDAD_MEDIDA,um.NOMBRE_UNIDAD_MEDIDA");
                                           consulta.append(" from UNIDADES_MEDIDA um");
                                           consulta.append(" where um.COD_ESTADO_REGISTRO=1");
                                           consulta.append(" order by um.NOMBRE_UNIDAD_MEDIDA asc");
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                unidadesMedidaSelectList=new ArrayList<SelectItem>();
                while (res.next()) 
                {
                    unidadesMedidaSelectList.add(new SelectItem(res.getString("COD_UNIDAD_MEDIDA"),res.getString("NOMBRE_UNIDAD_MEDIDA")));
                    
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
        private void cargarTiposActividadSelectList()
        {
            try 
            {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select ta.COD_TIPO_ACTIVIDAD,ta.NOMBRE_TIPO_ACTIVIDAD");
                                          consulta.append(" from TIPOS_ACTIVIDAD ta");
                                          consulta.append(" order by ta.NOMBRE_TIPO_ACTIVIDAD");
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                tiposActividadSelectList=new ArrayList<SelectItem>();
                while (res.next()) 
                {
                    tiposActividadSelectList.add(new SelectItem(res.getInt("COD_TIPO_ACTIVIDAD"),res.getString("NOMBRE_TIPO_ACTIVIDAD")));
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
        private void cargarTiposActividadProduccionSelectList()
        {
            try 
            {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select tap.COD_TIPO_ACTIVIDAD_PRODUCCION,tap.NOMBRE_TIPO_ACTIVIDAD_PRODUCCION");
                                            consulta.append(" from TIPOS_ACTIVIDAD_PRODUCCION tap");
                                            consulta.append(" order by tap.NOMBRE_TIPO_ACTIVIDAD_PRODUCCION");
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                tiposActividadProducionSelectList=new ArrayList<SelectItem>();
                while (res.next()) 
                {
                    tiposActividadProducionSelectList.add(new SelectItem(res.getInt("COD_TIPO_ACTIVIDAD_PRODUCCION"),res.getString("NOMBRE_TIPO_ACTIVIDAD_PRODUCCION")));
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
    //</editor-fold>

    public List<ActividadesProduccion> getActividadesProduccionList() {
        return actividadesProduccionList;
    }

    public void setActividadesProduccionList(List<ActividadesProduccion> actividadesProduccionList) {
        this.actividadesProduccionList = actividadesProduccionList;
    }

    public List<SelectItem> getTiposActividadSelectList() {
        return tiposActividadSelectList;
    }

    public void setTiposActividadSelectList(List<SelectItem> tiposActividadSelectList) {
        this.tiposActividadSelectList = tiposActividadSelectList;
    }

    public String getMensaje() {
        return mensaje;
    }

    public void setMensaje(String mensaje) {
        this.mensaje = mensaje;
    }

    public List<SelectItem> getUnidadesMedidaSelectList() {
        return unidadesMedidaSelectList;
    }

    public void setUnidadesMedidaSelectList(List<SelectItem> unidadesMedidaSelectList) {
        this.unidadesMedidaSelectList = unidadesMedidaSelectList;
    }

    public List<SelectItem> getTiposActividadProducionSelectList() {
        return tiposActividadProducionSelectList;
    }

    public void setTiposActividadProducionSelectList(List<SelectItem> tiposActividadProducionSelectList) {
        this.tiposActividadProducionSelectList = tiposActividadProducionSelectList;
    }

    public ActividadesProduccion getActividadesProduccionBuscar() {
        return actividadesProduccionBuscar;
    }

    public void setActividadesProduccionBuscar(ActividadesProduccion actividadesProduccionBuscar) {
        this.actividadesProduccionBuscar = actividadesProduccionBuscar;
    }

    
    public ActividadesProduccion getActividadesProduccionAgregar() {
        return actividadesProduccionAgregar;
    }

    public void setActividadesProduccionAgregar(ActividadesProduccion actividadesProduccionAgregar) {
        this.actividadesProduccionAgregar = actividadesProduccionAgregar;
    }

    public ActividadesProduccion getActividadesProduccionEditar() {
        return actividadesProduccionEditar;
    }

    public void setActividadesProduccionEditar(ActividadesProduccion actividadesProduccionEditar) {
        this.actividadesProduccionEditar = actividadesProduccionEditar;
    }
    
    
    
}
