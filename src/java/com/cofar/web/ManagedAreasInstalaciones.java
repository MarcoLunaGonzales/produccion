/*
 * ManagedTiposMercaderia.java
 *
 * Created on 18 de marzo de 2008, 17:30
 */

package com.cofar.web;
import com.cofar.bean.AreasInstalaciones;
import com.cofar.bean.AreasInstalacionesModulos;
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
 * @author Wilson Choquehuanca Gonzales
 * @company COFAR
 */
public class ManagedAreasInstalaciones extends ManagedBean
{
    //<editor-fold desc="variables">
        private Connection con;
        private List<AreasInstalaciones> areasInstalacionesList;
        private HtmlDataTable areasInstalacionesDataTable=new HtmlDataTable();
        private AreasInstalaciones areaInstalacionAgregar;
        private AreasInstalaciones areaInstalacionEditar;
        private List<SelectItem> areasEmpresaSelectList;
        private String mensaje="";
        private AreasInstalaciones areasInstalacionesBean;
        private List<AreasInstalacionesModulos> areasInstalacionesModuloList;
        private List<AreasInstalacionesModulos> areasInstalacionesModuloAgregarList;
    //</editor-fold>
        
        public ManagedAreasInstalaciones() 
        {
            LOGGER=LogManager.getLogger("Mantenimiento");
        }
    //<editor-fold desc="funciones">
        public String eliminarAreasInstalacionesModulos_action()throws SQLException
        {
            mensaje="";
            for(AreasInstalacionesModulos bean:areasInstalacionesModuloList)
            {
                if(bean.getChecked())
                {
                    mensaje = "";
                    try 
                    {
                        con = Util.openConnection(con);
                        con.setAutoCommit(false);
                        StringBuilder consulta = new StringBuilder("delete AREAS_INSTALACIONES_MODULOS ");
                                                    consulta.append(" where COD_AREA_INSTALACION=").append(bean.getAreasInstalaciones().getCodAreaInstalacion());
                                                            consulta.append(" and COD_MODULO_INSTALACION=").append(bean.getModulosInstalaciones().getCodModuloInstalacion());
                        LOGGER.debug("consulta eliminar areas instalaciones modulos" + consulta.toString());
                        PreparedStatement pst = con.prepareStatement(consulta.toString());
                        if (pst.executeUpdate() > 0) LOGGER.info("se elimino el area instalacion");
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
                this.cargarAreasInstalacionesModulos();
            }
            return null;
        }
        public String guardarAgregarAreasInstalacionModulos_action()throws SQLException
        {
            mensaje="";
            try 
            {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("INSERT INTO AREAS_INSTALACIONES_MODULOS(COD_AREA_INSTALACION,COD_MODULO_INSTALACION, CODIGO)");
                                            consulta.append("VALUES (");
                                                    consulta.append(areasInstalacionesBean.getCodAreaInstalacion());
                                                    consulta.append(",?");
                                                    consulta.append(",?");
                                            consulta.append(")");
                LOGGER.debug("consulta registrar areas instlacion modulo " + consulta.toString());
                PreparedStatement pst = con.prepareStatement(consulta.toString());
                for(AreasInstalacionesModulos bean:areasInstalacionesModuloAgregarList)
                {
                    if(bean.getChecked())
                    {
                        pst.setInt(1,bean.getModulosInstalaciones().getCodModuloInstalacion());
                        pst.setString(2,bean.getCodigo());
                        if(pst.executeUpdate()>0)LOGGER.info("se registro el area instalacion modulo");
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
        public String getCargarAgregarAreasInstalacionesModulos()
        {
            try 
            {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select mi.COD_MODULO_INSTALACION,mi.NOMBRE_MODULO_INSTALACION");
                                        consulta.append(" from MODULOS_INSTALACIONES mi");
                                        consulta.append(" where mi.COD_MODULO_INSTALACION not in ");
                                            consulta.append(" (");
                                                    consulta.append(" select aim.COD_MODULO_INSTALACION");
                                                    consulta.append(" from AREAS_INSTALACIONES_MODULOS aim");
                                                    consulta.append(" where aim.COD_AREA_INSTALACION=").append(areasInstalacionesBean.getCodAreaInstalacion());
                                            consulta.append(" )");
                                        consulta.append(" order by mi.NOMBRE_MODULO_INSTALACION");
                LOGGER.debug("consulta cargar agregar areas instalaciones modulos" + consulta.toString());
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                areasInstalacionesModuloAgregarList=new ArrayList<AreasInstalacionesModulos>();
                while (res.next()) 
                {
                    AreasInstalacionesModulos nuevo=new AreasInstalacionesModulos();
                    nuevo.getModulosInstalaciones().setCodModuloInstalacion(res.getInt("COD_MODULO_INSTALACION"));
                    nuevo.getModulosInstalaciones().setNombreModuloInstalacion(res.getString("NOMBRE_MODULO_INSTALACION"));
                    areasInstalacionesModuloAgregarList.add(nuevo);
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
        public String seleccionarAreaInstalacion_action()
        {
            areasInstalacionesBean=(AreasInstalaciones)areasInstalacionesDataTable.getRowData();
            return null;
        }
        public String getCargarAreasInstalacionesModulos()
        {
            this.cargarAreasInstalacionesModulos();
            return null;
        }
        private void cargarAreasInstalacionesModulos()
        {
            try
            {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select aim.COD_AREA_INSTALACION,aim.COD_MODULO_INSTALACION,");
                                                    consulta.append(" mi.NOMBRE_MODULO_INSTALACION,aim.CODIGO");
                                            consulta.append(" from AREAS_INSTALACIONES_MODULOS aim ");
                                                    consulta.append(" inner join MODULOS_INSTALACIONES mi on mi.COD_MODULO_INSTALACION=aim.COD_MODULO_INSTALACION");
                                            consulta.append(" where aim.COD_AREA_INSTALACION=").append(areasInstalacionesBean.getCodAreaInstalacion());
                                            consulta.append(" order by mi.NOMBRE_MODULO_INSTALACION");
                LOGGER.debug("consulta cargar modulos instalacion" + consulta.toString());
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                areasInstalacionesModuloList=new ArrayList<AreasInstalacionesModulos>();
                while (res.next()) 
                {
                    AreasInstalacionesModulos nuevo=new AreasInstalacionesModulos();
                    nuevo.getAreasInstalaciones().setCodAreaInstalacion(res.getInt("COD_AREA_INSTALACION"));
                    nuevo.getModulosInstalaciones().setCodModuloInstalacion(res.getInt("COD_MODULO_INSTALACION"));
                    nuevo.getModulosInstalaciones().setNombreModuloInstalacion(res.getString("NOMBRE_MODULO_INSTALACION"));
                    nuevo.setCodigo(res.getString("CODIGO"));
                    areasInstalacionesModuloList.add(nuevo);
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
        
        private int cantidadRegistrosUtilizanAreaInstalacion(AreasInstalaciones areaInstalacion)
        {
            int cantidadRegistros=0;
            try {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select count(*) as cantidadRegistros");
                                           consulta.append(" from SOLICITUDES_MANTENIMIENTO s");
                                           consulta.append(" where s.COD_AREA_INSTALACION=").append(areaInstalacion.getCodAreaInstalacion());
                LOGGER.debug("consulta cargar cantidad registros utilizan el area instalacion" + consulta.toString());
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                while (res.next())cantidadRegistros+=res.getInt("cantidadRegistros");
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
            return cantidadRegistros;
        }
        public String eliminarAreaInstalacion_action()throws SQLException
        {
            mensaje = "";
            ManagedAccesoSistema managed=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
            if(managed!=null)
            {
                for(AreasInstalaciones bean:areasInstalacionesList)
                {
                    if(bean.getChecked())
                    {
                        if(cantidadRegistrosUtilizanAreaInstalacion(bean)==0)
                        {
                            try {
                                con = Util.openConnection(con);
                                con.setAutoCommit(false);
                                StringBuilder consulta = new StringBuilder("INSERT INTO AREAS_INSTALACIONES_LOG");
                                                            consulta.append(" SELECT *,");
                                                                consulta.append(managed.getUsuarioModuloBean().getCodUsuarioGlobal());//personal transaccion
                                                                consulta.append(" ,GETDATE()");//fecha transaccion
                                                                consulta.append(" ,2");//tipo transaccion eliminacion
                                                            consulta.append(" FROM AREAS_INSTALACIONES ai");
                                                            consulta.append(" where ai.COD_AREA_INSTALACION=").append(bean.getCodAreaInstalacion());
                                LOGGER.debug("consulta registrar historico" + consulta.toString());
                                PreparedStatement pst = con.prepareStatement(consulta.toString());
                                if (pst.executeUpdate() > 0)LOGGER.info("se registrar historico");
                                consulta=new StringBuilder("delete AREAS_INSTALACIONES ");
                                            consulta.append(" where COD_AREA_INSTALACION=").append(bean.getCodAreaInstalacion());
                                LOGGER.debug("consulta delete area instlaacion "+consulta.toString());
                                pst=con.prepareStatement(consulta.toString());
                                if(pst.executeUpdate()>0)LOGGER.info("se elimino el area instalacion");
                                con.commit();
                                mensaje = "1";
                            }
                            catch (SQLException ex) 
                            {
                                mensaje = "Ocurrio un error al momento de guardar el registro";
                                con.rollback();
                                LOGGER.warn(ex.getMessage());
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
                        else
                        {
                            mensaje="No se puede eliminar el area porque existen registros que lo utilizan";
                        }
                        break;
                    }
                }
            }
            else
            {
                mensaje="No se encuentra con sesión activa";
            }
            if(mensaje.equals("1"))
            {
                this.cargarAreasInstalacionesList();
            }
            return null;
        }
        public String guardarEditarAreaInstalacion_action()throws SQLException
        {
            mensaje = "";
            try 
            {
                ManagedAccesoSistema managed=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
                if(managed!=null)
                {
                    con = Util.openConnection(con);
                    con.setAutoCommit(false);
                    StringBuilder consulta = new StringBuilder("INSERT INTO AREAS_INSTALACIONES_LOG ");
                                            consulta.append(" SELECT *");
                                                    consulta.append(",").append(managed.getUsuarioModuloBean().getCodUsuarioGlobal());//personal transaccion
                                                    consulta.append(" ,GETDATE()");//fecha transaccion
                                                    consulta.append(" ,1");//tipo transaccion edicion
                                            consulta.append(" FROM AREAS_INSTALACIONES  a");
                                            consulta.append(" where a.COD_AREA_INSTALACION=").append(areaInstalacionEditar.getCodAreaInstalacion());
                    LOGGER.debug("consulta guardar historico " + consulta.toString());
                    PreparedStatement pst = con.prepareStatement(consulta.toString(), PreparedStatement.RETURN_GENERATED_KEYS);
                    if (pst.executeUpdate() > 0)LOGGER.info("se registro el historico ");
                    consulta=new StringBuilder("update AREAS_INSTALACIONES set ");
                                        consulta.append(" NOMBRE_AREA_INSTALACION='").append(areaInstalacionEditar.getNombreAreaInstalacion()).append("'");
                                        consulta.append(" ,CODIGO='").append(areaInstalacionEditar.getCodigo()).append("'");
                                        consulta.append(" ,COD_AREA_EMPRESA=").append(areaInstalacionEditar.getAreasEmpresa().getCodAreaEmpresa());
                                consulta.append(" where COD_AREA_INSTALACION=").append(areaInstalacionEditar.getCodAreaInstalacion());
                    LOGGER.debug("consulta editar area instalacion "+consulta.toString());
                    pst=con.prepareStatement(consulta.toString());
                    if(pst.executeUpdate()>0)LOGGER.info("se guardo la edicion");
                    con.commit();
                    mensaje = "1";
                }
                else
                {
                    mensaje="No se encuentra con sesion activa";
                }
            }
            catch (SQLException ex) 
            {
                mensaje = "Ocurrio un error al momento de guardar el registro";
                con.rollback();
                LOGGER.warn(ex.getMessage());
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
        public String editarAreaInstalacion_action()
        {
            for(AreasInstalaciones bean:areasInstalacionesList)
            {
                if(bean.getChecked())
                {
                    areaInstalacionEditar=bean;
                    this.cargarAreasEmpresaSelectList();
                    break;
                }
            }
            return null;
        }
        public String guardarAgregarAreaInstalacion_action()throws SQLException
        {
            mensaje = "";
            try 
            {
                con = Util.openConnection(con);
                con.setAutoCommit(false);
                StringBuilder consulta = new StringBuilder("INSERT INTO AREAS_INSTALACIONES(COD_AREA_EMPRESA,NOMBRE_AREA_INSTALACION, CODIGO)");
                                            consulta.append(" VALUES (");
                                                    consulta.append(areaInstalacionAgregar.getAreasEmpresa().getCodAreaEmpresa());
                                                    consulta.append(",'").append(areaInstalacionAgregar.getNombreAreaInstalacion()).append("'");
                                                    consulta.append(",'").append(areaInstalacionAgregar.getCodigo()).append("'");
                                            consulta.append(")");
                LOGGER.debug("consulta area instalacion " + consulta.toString());
                PreparedStatement pst = con.prepareStatement(consulta.toString());
                if (pst.executeUpdate() > 0) LOGGER.info("se registro la nueva instalacion");
                con.commit();
                mensaje = "1";
            }
            catch (SQLException ex) 
            {
                mensaje = "Ocurrio un error al momento de guardar el registro";
                con.rollback();
                LOGGER.warn(ex.getMessage());
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
        public String getCargarAgregarAreaInstalacion()
        {
            areaInstalacionAgregar=new AreasInstalaciones();
            this.cargarAreasEmpresaSelectList();
            return null;
        }
        private void cargarAreasEmpresaSelectList()
        {
            try 
            {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select ae.COD_AREA_EMPRESA,ae.NOMBRE_AREA_EMPRESA");
                                            consulta.append(" from AREAS_EMPRESA ae");
                                            consulta.append(" where ae.COD_ESTADO_REGISTRO=1");
                                            consulta.append(" order by ae.NOMBRE_AREA_EMPRESA");
                LOGGER.debug("consulta cargar areas empresa select " + consulta.toString());
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
        public String getCargarAreasInstalaciones()
        {
            this.cargarAreasInstalacionesList();
            return null;
        }
        private void cargarAreasInstalacionesList()
        {
            try 
            {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select ai.COD_AREA_INSTALACION,ai.COD_AREA_EMPRESA,ai.NOMBRE_AREA_INSTALACION,");
                                            consulta.append(" ai.CODIGO,ae.NOMBRE_AREA_EMPRESA,isnull(aim.CODIGO,'') as codigoModulo,aim.COD_MODULO_INSTALACION,isnull(mi.NOMBRE_MODULO_INSTALACION,'') as NOMBRE_MODULO_INSTALACION");
                                            consulta.append(" from AREAS_EMPRESA ae");
                                                    consulta.append(" inner join AREAS_INSTALACIONES ai on ae.COD_AREA_EMPRESA =ai.COD_AREA_EMPRESA");
                                                    consulta.append(" left outer join AREAS_INSTALACIONES_MODULOS aim on aim.COD_AREA_INSTALACION=ai.COD_AREA_INSTALACION");
                                                    consulta.append(" left outer join MODULOS_INSTALACIONES mi on mi.COD_MODULO_INSTALACION=aim.COD_MODULO_INSTALACION");
                                            consulta.append(" order by ae.NOMBRE_AREA_EMPRESA,mi.NOMBRE_MODULO_INSTALACION");
                LOGGER.debug("consulta cargar " + consulta);
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                areasInstalacionesList=new ArrayList<AreasInstalaciones>();
                AreasInstalaciones nuevo=new AreasInstalaciones();
                while (res.next()) 
                {
                    if(nuevo.getCodAreaInstalacion()!=res.getInt("COD_AREA_INSTALACION"))
                    {
                        if(nuevo.getCodAreaInstalacion()>0)
                        {
                            areasInstalacionesList.add(nuevo);
                        }
                        nuevo=new AreasInstalaciones();
                        nuevo.setCodAreaInstalacion(res.getInt("COD_AREA_INSTALACION"));
                        nuevo.getAreasEmpresa().setCodAreaEmpresa(res.getString("COD_AREA_EMPRESA"));
                        nuevo.setNombreAreaInstalacion(res.getString("NOMBRE_AREA_INSTALACION"));
                        nuevo.setCodigo(res.getString("CODIGO"));
                        nuevo.getAreasEmpresa().setNombreAreaEmpresa(res.getString("NOMBRE_AREA_EMPRESA"));
                        nuevo.setAreasInstalacionesModuloList(new ArrayList<AreasInstalacionesModulos>());
                    }
                    AreasInstalacionesModulos bean=new AreasInstalacionesModulos();
                    bean.setCodigo(res.getString("codigoModulo"));
                    bean.getModulosInstalaciones().setCodModuloInstalacion(res.getInt("COD_MODULO_INSTALACION"));
                    bean.getModulosInstalaciones().setNombreModuloInstalacion(res.getString("NOMBRE_MODULO_INSTALACION"));
                    nuevo.getAreasInstalacionesModuloList().add(bean);
                }
                if(nuevo.getCodAreaInstalacion()>0)
                {
                    areasInstalacionesList.add(nuevo);
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
    //<editor-fold desc="getter and setter">
        public List<AreasInstalaciones> getAreasInstalacionesList() {
            return areasInstalacionesList;
        }

        public void setAreasInstalacionesList(List<AreasInstalaciones> areasInstalacionesList) {
            this.areasInstalacionesList = areasInstalacionesList;
        }
        public HtmlDataTable getAreasInstalacionesDataTable() {
            return areasInstalacionesDataTable;
        }

        public void setAreasInstalacionesDataTable(HtmlDataTable areasInstalacionesDataTable) {
            this.areasInstalacionesDataTable = areasInstalacionesDataTable;
        }

        public AreasInstalaciones getAreaInstalacionAgregar() {
            return areaInstalacionAgregar;
        }

        public void setAreaInstalacionAgregar(AreasInstalaciones areaInstalacionAgregar) {
            this.areaInstalacionAgregar = areaInstalacionAgregar;
        }

        public List<SelectItem> getAreasEmpresaSelectList() {
            return areasEmpresaSelectList;
        }

        public void setAreasEmpresaSelectList(List<SelectItem> areasEmpresaSelectList) {
            this.areasEmpresaSelectList = areasEmpresaSelectList;
        }

        public String getMensaje() {
            return mensaje;
        }

        public void setMensaje(String mensaje) {
            this.mensaje = mensaje;
        }

        public AreasInstalaciones getAreaInstalacionEditar() {
            return areaInstalacionEditar;
        }

        public void setAreaInstalacionEditar(AreasInstalaciones areaInstalacionEditar) {
            this.areaInstalacionEditar = areaInstalacionEditar;
        }
        public AreasInstalaciones getAreasInstalacionesBean() {
            return areasInstalacionesBean;
        }

        public void setAreasInstalacionesBean(AreasInstalaciones areasInstalacionesBean) {
            this.areasInstalacionesBean = areasInstalacionesBean;
        }

        public List<AreasInstalacionesModulos> getAreasInstalacionesModuloList() {
            return areasInstalacionesModuloList;
        }

        public void setAreasInstalacionesModuloList(List<AreasInstalacionesModulos> areasInstalacionesModuloList) {
            this.areasInstalacionesModuloList = areasInstalacionesModuloList;
        }
        
        
        
        
        
        
        
        
        
    //</editor-fold>

    public List<AreasInstalacionesModulos> getAreasInstalacionesModuloAgregarList() {
        return areasInstalacionesModuloAgregarList;
    }

    public void setAreasInstalacionesModuloAgregarList(List<AreasInstalacionesModulos> areasInstalacionesModuloAgregarList) {
        this.areasInstalacionesModuloAgregarList = areasInstalacionesModuloAgregarList;
    }

    
    
    
}
