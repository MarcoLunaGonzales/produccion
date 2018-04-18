/*
 * ManagedTiposMercaderia.java
 *
 * Created on 18 de marzo de 2008, 17:30
 */

package com.cofar.web;

import com.cofar.bean.ModulosInstalaciones;

import com.cofar.bean.TiposMercaderia;
import com.cofar.util.Util;
import java.io.File;
import java.io.FileInputStream;
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
import javax.faces.event.ValueChangeEvent;
import javax.faces.model.SelectItem;
import org.apache.taglibs.standard.lang.jstl.ModulusOperator;

/**
 *
 * @author Wilson Choquehuanca Gonzales
 * @company COFAR
 */
public class ManagedModulosInstalaciones extends ManagedBean
{
    //<editor-fold desc="variables">
        private Connection con;
        private String mensaje="";
        private List<ModulosInstalaciones> modulosInstalacionesList;
        private ModulosInstalaciones modulosInstalacionesAgregar;
        private ModulosInstalaciones modulosInstalacionesEditar;
    //</editor-fold>
    //<editor-fold desc="funciones">
        private int cantidadRegistrosUtilizanModuloInstalacion(ModulosInstalaciones modulosInstalaciones)
        {
            int cantidadRegistros=0;
            try {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select count(*) as cantidadRegistros");
                                            consulta.append(" from AREAS_INSTALACIONES_MODULOS aim");
                                            consulta.append(" where aim.COD_MODULO_INSTALACION=").append(modulosInstalaciones.getCodModuloInstalacion());
                LOGGER.debug("consulta cargar modulos instalaciones" + consulta.toString());
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                if(res.next())cantidadRegistros+=res.getInt("cantidadRegistros");
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
        public String eliminarModulosInstalaciones_action()throws SQLException
        {
            mensaje="";
            for(ModulosInstalaciones bean:modulosInstalacionesList)
            {
                if(bean.getChecked())
                {
                    if(this.cantidadRegistrosUtilizanModuloInstalacion(bean)==0)
                    {
                        mensaje = "";
                        try 
                        {
                            con = Util.openConnection(con);
                            con.setAutoCommit(false);
                            StringBuilder consulta = new StringBuilder("delete MODULOS_INSTALACIONES ");
                                                        consulta.append(" where COD_MODULO_INSTALACION=").append(bean.getCodModuloInstalacion());
                            LOGGER.debug("consulta eliminar modulo instalacion" + consulta.toString());
                            PreparedStatement pst = con.prepareStatement(consulta.toString());
                            if (pst.executeUpdate() > 0) LOGGER.info("se elimino el modulo instalacion");
                            con.commit();
                            mensaje = "1";
                        }
                        catch (SQLException ex) 
                        {
                            mensaje = "Ocurrio un error al momento de eliminar el registro";
                            LOGGER.warn(ex.getMessage());
                            con.rollback();
                        }
                        catch (Exception ex) 
                        {
                            mensaje = "Ocurrio un error al momento de eliminar el registro,verifique los datos introducidos";
                            LOGGER.warn(ex.getMessage());
                        }
                        finally 
                        {
                            this.cerrarConexion(con);
                        }
                    }
                    else
                    {
                        mensaje="No se puede eliminar porque existen registros que lo utilizan";
                    }
                    break;
                }
            }
            if(mensaje.equals("1"))
            {
                this.cargarModulosInstalacionesList();
            }
            return null;
        }
        public String guardarEdicionModulosInstalaciones_action()throws SQLException
        {
            mensaje = "";
            try 
            {
                con = Util.openConnection(con);
                con.setAutoCommit(false);
                StringBuilder consulta = new StringBuilder("update MODULOS_INSTALACIONES");
                                        consulta.append(" set NOMBRE_MODULO_INSTALACION='").append(modulosInstalacionesEditar.getNombreModuloInstalacion()).append("'");
                                                consulta.append(" ,OBS_MODULO_INSTALACION=?");
                                                consulta.append(" ,COD_ESTADO_REGISTRO=").append(modulosInstalacionesEditar.getEstadoReferencial().getCodEstadoRegistro());
                                        consulta.append(" where COD_MODULO_INSTALACION=").append(modulosInstalacionesEditar.getCodModuloInstalacion());
                LOGGER.debug("consulta actualiza modulo instalacion" + consulta.toString());
                PreparedStatement pst = con.prepareStatement(consulta.toString());
                pst.setString(1,modulosInstalacionesEditar.getObsModuloInstalacion());
                if (pst.executeUpdate() > 0) LOGGER.info("se guarod la edicion");
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
        public String editarModulosInstalaciones_action()
        {
            for(ModulosInstalaciones bean:modulosInstalacionesList)
            {
                if(bean.getChecked())
                {
                    modulosInstalacionesEditar=bean;
                    break;
                }
            }
            return null;
        }
        public String getCargarAgregarModulosInstalaciones()
        {
            modulosInstalacionesAgregar=new ModulosInstalaciones();
            return null;
        }
        public String guardarAgregarModulosInstalaciones_action()throws SQLException
        {
            mensaje = "";
            try 
            {
                con = Util.openConnection(con);
                con.setAutoCommit(false);
                StringBuilder consulta = new StringBuilder("INSERT INTO MODULOS_INSTALACIONES(NOMBRE_MODULO_INSTALACION, OBS_MODULO_INSTALACION, COD_ESTADO_REGISTRO)");
                                            consulta.append(" VALUES (");
                                                    consulta.append("'").append(modulosInstalacionesAgregar.getNombreModuloInstalacion()).append("'");
                                                    consulta.append(",?");
                                                    consulta.append(",1");
                                            consulta.append(")");
                LOGGER.debug("consulta registrar modulo instalacion " + consulta.toString());
                PreparedStatement pst = con.prepareStatement(consulta.toString());
                pst.setString(1,modulosInstalacionesAgregar.getObsModuloInstalacion());
                if (pst.executeUpdate() > 0) LOGGER.info("se registro el modulo instalación");
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
        public String getCargarModulosInstalaciones()
        {
            this.cargarModulosInstalacionesList();
            return null;
        }
        private void cargarModulosInstalacionesList()
        {
            try 
            {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("SELECT mi.COD_MODULO_INSTALACION,mi.NOMBRE_MODULO_INSTALACION,mi.OBS_MODULO_INSTALACION,");
                                                    consulta.append(" er.COD_ESTADO_REGISTRO,er.NOMBRE_ESTADO_REGISTRO");
                                            consulta.append(" FROM MODULOS_INSTALACIONES mi");
                                                    consulta.append(" inner join ESTADOS_REFERENCIALES er on mi.COD_ESTADO_REGISTRO=er.COD_ESTADO_REGISTRO");
                LOGGER.debug("consulta cargar " + consulta.toString());
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                modulosInstalacionesList=new ArrayList<ModulosInstalaciones>();
                while (res.next()) 
                {
                    ModulosInstalaciones nuevo=new ModulosInstalaciones();
                    nuevo.setCodModuloInstalacion(res.getInt("COD_MODULO_INSTALACION"));
                    nuevo.setNombreModuloInstalacion(res.getString("NOMBRE_MODULO_INSTALACION"));
                    nuevo.setObsModuloInstalacion(res.getString("OBS_MODULO_INSTALACION"));
                    nuevo.getEstadoReferencial().setCodEstadoRegistro(res.getString("COD_ESTADO_REGISTRO"));
                    nuevo.getEstadoReferencial().setNombreEstadoRegistro(res.getString("NOMBRE_ESTADO_REGISTRO"));
                    modulosInstalacionesList.add(nuevo);
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
        public List<ModulosInstalaciones> getModulosInstalacionesList() {
            return modulosInstalacionesList;
        }

        public void setModulosInstalacionesList(List<ModulosInstalaciones> modulosInstalacionesList) {
            this.modulosInstalacionesList = modulosInstalacionesList;
        }

        public String getMensaje() {
            return mensaje;
        }

        public void setMensaje(String mensaje) {
            this.mensaje = mensaje;
        }

        public ModulosInstalaciones getModulosInstalacionesAgregar() {
            return modulosInstalacionesAgregar;
        }

        public void setModulosInstalacionesAgregar(ModulosInstalaciones modulosInstalacionesAgregar) {
            this.modulosInstalacionesAgregar = modulosInstalacionesAgregar;
        }

        public ModulosInstalaciones getModulosInstalacionesEditar() {
            return modulosInstalacionesEditar;
        }

        public void setModulosInstalacionesEditar(ModulosInstalaciones modulosInstalacionesEditar) {
            this.modulosInstalacionesEditar = modulosInstalacionesEditar;
        }

        
        
        
        
        
        

        
        
        
    //</editor-fold>
    
    
    
    /** Creates a new instance of ManagedPersonal */
    private List modulosInstalacionesEliminarList=new ArrayList();
    private List modulosInstalacionesNoEliminarList=new ArrayList();
    private ModulosInstalaciones modulosInstalacionesbean=new ModulosInstalaciones();
    private List estadoRegistro=new  ArrayList();
    private boolean swElimina1;
    private boolean swElimina2;
    public ManagedModulosInstalaciones() {
    }
    public void cargarModulosInstalaciones(){
        try {
            String sql="SELECT  M.COD_MODULO_INSTALACION,M.NOMBRE_MODULO_INSTALACION,M.OBS_MODULO_INSTALACION,";
            sql+=" M.COD_ESTADO_REGISTRO,ER.NOMBRE_ESTADO_REGISTRO";
            sql+=" FROM MODULOS_INSTALACIONES M,ESTADOS_REFERENCIALES ER";
            sql+=" WHERE M.COD_ESTADO_REGISTRO=ER.COD_ESTADO_REGISTRO";
            if(!getModulosInstalacionesbean().getEstadoReferencial().getCodEstadoRegistro().equals("") && !getModulosInstalacionesbean().getEstadoReferencial().getCodEstadoRegistro().equals("3")){
                sql+=" and  er.cod_estado_registro="+getModulosInstalacionesbean().getEstadoReferencial().getCodEstadoRegistro();
            }
            sql+=" ORDER BY M.NOMBRE_MODULO_INSTALACION";
            System.out.println("cargarMODULOS_INSTALACIONES:"+sql);
            setCon(Util.openConnection(getCon()));
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(sql);
            String cod="";
            modulosInstalacionesList.clear();
            while (rs.next()){
                ModulosInstalaciones bean=new ModulosInstalaciones();
                bean.setCodModuloInstalacion(rs.getInt(1));
                bean.setNombreModuloInstalacion(rs.getString(2));
                bean.setObsModuloInstalacion(rs.getString(3));
                bean.getEstadoReferencial().setCodEstadoRegistro(rs.getString(4));
                bean.getEstadoReferencial().setNombreEstadoRegistro(rs.getString(5));
                modulosInstalacionesList.add(bean);
            }
            
            if(rs!=null){
                rs.close();st.close();
                rs=null;st=null;
            }
            
            
            
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    /**
     * -------------------------------------------------------------------------
     * ESTADO REGISTRO
     * -------------------------------------------------------------------------
     **/
    public void changeEvent(ValueChangeEvent event){
        System.out.println("event:"+event.getNewValue());
        getModulosInstalacionesbean().getEstadoReferencial().setCodEstadoRegistro(event.getNewValue().toString());
        cargarModulosInstalaciones();
    }
    public void cargarEstadoRegistro(String codigo,ModulosInstalaciones bean){
        try {
            setCon(Util.openConnection(getCon()));
            String sql="select cod_estado_registro,nombre_estado_registro from estados_referenciales where cod_estado_registro<>3";
            ResultSet rs=null;
            
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            if(!codigo.equals("")){
            } else{
                getEstadoRegistro().clear();
                rs=st.executeQuery(sql);
                while (rs.next())
                    getEstadoRegistro().add(new SelectItem(rs.getString(1),rs.getString(2)));
            }
            if(rs!=null){
                rs.close();st.close();
                rs=null;st=null;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public void generarCodigo(){
        try {
            String  sql="select max(COD_MODULO_INSTALACION)+1 from MODULOS_INSTALACIONES";
            setCon(Util.openConnection(getCon()));
            Statement st=getCon().createStatement();
            ResultSet rs=st.executeQuery(sql);
            if(rs.next()){
                int cod=rs.getInt(1);
                if(cod<=0)
                    getModulosInstalacionesbean().setCodModuloInstalacion(1);
                else
                    getModulosInstalacionesbean().setCodModuloInstalacion(cod);
            }
            if(rs!=null){
                rs.close();
                st.close();
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public String actionSaveModulosInstalaciones(){
        clear();
        cargarEstadoRegistro("",null);
        return "actionSaveModulosInstalaciones";
    }
    public String actionCancelar(){
        clear();
        cargarModulosInstalaciones();
        return "navegadorModulosInstalaciones";
    }
    public String saveModulosInstalaciones(){
        try {
            generarCodigo();
            
            String sql="insert into MODULOS_INSTALACIONES(COD_MODULO_INSTALACION,NOMBRE_MODULO_INSTALACION,OBS_MODULO_INSTALACION,COD_ESTADO_REGISTRO)values(";
            sql+=""+getModulosInstalacionesbean().getCodModuloInstalacion()+",";
            sql+="'"+getModulosInstalacionesbean().getNombreModuloInstalacion()+"',";
            sql+="'"+getModulosInstalacionesbean().getObsModuloInstalacion()+"',1)";
            System.out.println("sql:insert:"+sql);
            setCon(Util.openConnection(getCon()));
            PreparedStatement st=getCon().prepareStatement(sql);
            int result=st.executeUpdate();
            st.close();
            clear();
            if(result>0){
                
                cargarModulosInstalaciones();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return "navegadorModulosInstalaciones";
    }
    public void clear(){
        ModulosInstalaciones tm=new ModulosInstalaciones();
        setModulosInstalacionesbean(tm);
    }
    
    public String actionEditModulosInstalaciones(){
        cargarEstadoRegistro("",null);
        Iterator i=getModulosInstalacionesList().iterator();
        while (i.hasNext()){
            ModulosInstalaciones bean=(ModulosInstalaciones)i.next();
            if(bean.getChecked().booleanValue()){
                setModulosInstalacionesbean(bean);
                break;
            }
            
        }
        return "actionEditModulosInstalaciones";
    }
    public String editModulosInstalaciones(){
        try {
            String sql="update MODULOS_INSTALACIONES set ";
            sql+="NOMBRE_MODULO_INSTALACION='"+getModulosInstalacionesbean().getNombreModuloInstalacion()+"',";
            sql+="OBS_MODULO_INSTALACION='"+getModulosInstalacionesbean().getObsModuloInstalacion()+"',";
            sql+="COD_ESTADO_REGISTRO="+getModulosInstalacionesbean().getEstadoReferencial().getCodEstadoRegistro();
            sql+="where COD_MODULO_INSTALACION="+getModulosInstalacionesbean().getCodModuloInstalacion();
            System.out.println("sql:Update:"+sql);
            setCon(Util.openConnection(getCon()));
            PreparedStatement st=getCon().prepareStatement(sql);
            int result=st.executeUpdate();
            st.close();
            clear();
            if(result>0){
                cargarModulosInstalaciones();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "navegadorModulosInstalaciones";
    }
    public String actionDeleteModulosInstalaciones(){
        setSwElimina2(false);
        setSwElimina1(false);
        getModulosInstalacionesEliminarList().clear();
        getModulosInstalacionesNoEliminarList().clear();
        int bandera=0;
        Iterator i=getModulosInstalacionesList().iterator();
        while (i.hasNext()){
            ModulosInstalaciones bean=(ModulosInstalaciones)i.next();
            if(bean.getChecked().booleanValue()){
                
                modulosInstalacionesEliminarList.add(bean);
                setSwElimina1(true);
                System.out.println("entro  eliminarrrrrrrrrrrr");
            }
        }
        return "actionDeleteModulosInstalaciones";
    }
    public String deleteModulosInstalaciones(){
        try {
            
            Iterator i=modulosInstalacionesEliminarList.iterator();
            int result=0;
            while (i.hasNext()){
                ModulosInstalaciones bean=(ModulosInstalaciones)i.next();
                String sql="delete from MODULOS_INSTALACIONES " +
                        "where COD_MODULO_INSTALACION="+bean.getCodModuloInstalacion();
                System.out.println("deleteMODULOS_INSTALACIONES:sql:"+sql);
                setCon(Util.openConnection(getCon()));
                Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                result=result+st.executeUpdate(sql);
            }
            getModulosInstalacionesEliminarList().clear();
            getModulosInstalacionesNoEliminarList().clear();
            if(result>0){
                cargarModulosInstalaciones();
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "navegadorModulosInstalaciones";
    }
    /**************************************************************/
    
   
    
    public List getModulosInstalacionesEliminarList() {
        return modulosInstalacionesEliminarList;
    }
    
    public void setModulosInstalacionesEliminarList(List modulosInstalacionesEliminarList) {
        this.modulosInstalacionesEliminarList = modulosInstalacionesEliminarList;
    }
    
    public List getModulosInstalacionesNoEliminarList() {
        return modulosInstalacionesNoEliminarList;
    }
    
    public void setModulosInstalacionesNoEliminarList(List modulosInstalacionesNoEliminarList) {
        this.modulosInstalacionesNoEliminarList = modulosInstalacionesNoEliminarList;
    }
    
    public ModulosInstalaciones getModulosInstalacionesbean() {
        return modulosInstalacionesbean;
    }
    
    public void setModulosInstalacionesbean(ModulosInstalaciones modulosInstalacionesbean) {
        this.modulosInstalacionesbean = modulosInstalacionesbean;
    }
    
    public Connection getCon() {
        return con;
    }
    
    public void setCon(Connection con) {
        this.con = con;
    }
    
    public List getEstadoRegistro() {
        return estadoRegistro;
    }
    
    public void setEstadoRegistro(List estadoRegistro) {
        this.estadoRegistro = estadoRegistro;
    }
    
    public boolean isSwElimina1() {
        return swElimina1;
    }
    
    public void setSwElimina1(boolean swElimina1) {
        this.swElimina1 = swElimina1;
    }
    
    public boolean isSwElimina2() {
        return swElimina2;
    }
    
    public void setSwElimina2(boolean swElimina2) {
        this.swElimina2 = swElimina2;
    }
    
    
}
