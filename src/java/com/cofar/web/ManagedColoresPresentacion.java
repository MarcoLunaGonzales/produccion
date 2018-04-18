/*
 * ManagedTipoCliente.java
 * Created on 19 de febrero de 2008, 16:50
 */

package com.cofar.web;

import com.cofar.bean.ColoresPresentacion;
import com.cofar.util.Util;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import javax.faces.event.ValueChangeEvent;
import javax.faces.model.SelectItem;

/**
 *
 *  @author Wilmer Manzaneda Chavez
 *  @company COFAR
 */
public class ManagedColoresPresentacion{
    
    /** Creates a new instance of ManagedTipoCliente */
    private ColoresPresentacion colorPresentacionbean=new ColoresPresentacion();
    private List estadoRegistro=new ArrayList();
    private List coloresPresentacion=new ArrayList();
    private List coloresPresentacionEliminar=new ArrayList();
    private List coloresPresentacionNoEliminar=new ArrayList();
    private Connection con;
    private boolean swEliminaSi;
    private boolean swEliminaNo;
    
    
    public ManagedColoresPresentacion() {
        cargarColoresPresentacion();
    }
    /**
     * metodo que genera los codigos
     * correlativamente
     */
    public String getCodigoColores(){
        String codigo="1";
        try {
            setCon(Util.openConnection(getCon()));
            String sql="select max(cod_colorpresprimaria)+1 from colores_presprimaria";
            PreparedStatement st=getCon().prepareStatement(sql);
            System.out.println("sql:MAX:"+sql);
            ResultSet rs=st.executeQuery();
            while (rs.next())
                codigo=rs.getString(1);
            if(codigo==null)
                codigo="1";
            colorPresentacionbean.setCodColor(codigo);
            System.out.println("coiogogo:"+codigo);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return  "";
    }
    
    public void cargarEstadoRegistro(String codigo,ColoresPresentacion bean){
        try {
            setCon(Util.openConnection(getCon()));
            String sql="select cod_estado_registro,nombre_estado_registro from estados_referenciales where cod_estado_registro<>3";
            ResultSet rs=null;
            
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            if(!codigo.equals("")){
                sql+=" and cod_estado_registro="+codigo;
                System.out.println("update:"+sql);
                rs=st.executeQuery(sql);
                if(rs.next()){
                    bean.getEstadoReferencial().setCodEstadoRegistro(rs.getString(1));
                    bean.getEstadoReferencial().setNombreEstadoRegistro(rs.getString(2));
                }
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
    /**
     * Metodo para cargar los datos en
     * el datatable
     */
    public void cargarColoresPresentacion(){
        try {
            String sql="select cod_colorpresprimaria,nombre_colorpresprimaria,obs_colorpresprimaria,cod_estado_registro" +
                    " from colores_presprimaria";
            if(!colorPresentacionbean.getEstadoReferencial().getCodEstadoRegistro().equals("") && !colorPresentacionbean.getEstadoReferencial().getCodEstadoRegistro().equals("3")){
                sql+=" where cod_estado_registro="+colorPresentacionbean.getEstadoReferencial().getCodEstadoRegistro();
            }
            sql+=" order by nombre_colorpresprimaria asc";
            System.out.println("cargar:"+sql);
            setCon(Util.openConnection(getCon()));
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(sql);
            rs.last();
            int rows=rs.getRow();
            coloresPresentacion.clear();
            rs.first();
            String cod="";
            for(int i=0;i<rows;i++){
                ColoresPresentacion bean=new ColoresPresentacion();
                bean.setCodColor(rs.getString(1));
                bean.setNombreColor(rs.getString(2));
                bean.setObsColor(rs.getString(3));
                //bean.setCodEstadoRegistro(rs.getString(7));
                cod=rs.getString(4);
                cod=(cod==null)?"":cod;
                System.out.println("st xxx:"+cod);
                cargarEstadoRegistro(cod,bean);
                coloresPresentacion.add(bean);
                rs.next();
            }
            
            if(rs!=null){
                rs.close();
                st.close();
            }
            
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public String Guardar(){
        clearColoresPresentacion();
        return"actionAgregarColorPresentacion";
    }
    
    
    public String actionEditar(){
        cargarEstadoRegistro("",null);
        Iterator i=coloresPresentacion.iterator();
        while (i.hasNext()){
            ColoresPresentacion bean=(ColoresPresentacion)i.next();
            if(bean.getChecked().booleanValue()){
                colorPresentacionbean=bean;
                break;
            }
            
        }
        return "actionEditarColorPresentacion";
    }
    
    
    public String actionEliminar(){
        setSwEliminaSi(false);
        setSwEliminaNo(false);
        coloresPresentacionEliminar.clear();
        coloresPresentacionNoEliminar.clear();
        int bandera=0;
        Iterator i=coloresPresentacion.iterator();
        while (i.hasNext()){
            ColoresPresentacion bean=(ColoresPresentacion)i.next();
            if(bean.getChecked().booleanValue()){
                try {
                    String sql="select cod_colorpresprimaria from presentaciones_producto" +
                            " where cod_colorpresprimaria="+bean.getCodColor();
                    setCon(Util.openConnection(getCon()));
                    Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet rs=st.executeQuery(sql);
                    rs.last();
                    if (rs.getRow()==0){
                        bandera=1;
                    } else{
                        bandera=0;
                    }
                    
                    if (bandera==1){
                        coloresPresentacionEliminar.add(bean);
                        setSwEliminaSi(true);
                        System.out.println("entro  eliminarrrrrrrrrrrr");
                    }else{
                        coloresPresentacionNoEliminar.add(bean);
                        setSwEliminaNo(true);
                        System.out.println("entroooooooo   noooo eliminar");
                    }
                    if(rs!=null){
                        rs.close();st.close();
                        rs=null;st=null;
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
        return "EliminarColorPresentacion";
    }
    
    public void clearColoresPresentacion(){
        colorPresentacionbean.setCodColor("");
        colorPresentacionbean.setNombreColor("");
        colorPresentacionbean.setObsColor("");
        
    }
    
    public String guardarColoresPresentacion(){
        try {
            String sql="insert into colores_presprimaria(cod_colorpresprimaria,nombre_colorpresprimaria," +
                    "obs_colorpresprimaria,cod_estado_registro)values(";
            sql+="'"+colorPresentacionbean.getCodColor()+"','"+colorPresentacionbean.getNombreColor().toUpperCase()+"',"+
                    "'"+colorPresentacionbean.getObsColor()+"',1)";
            System.out.println("inset:"+sql);
            setCon(Util.openConnection(getCon()));
            PreparedStatement st=getCon().prepareStatement(sql);
            int result=st.executeUpdate();
            if(result>0){
                cargarColoresPresentacion();
                clearColoresPresentacion();
            }
            System.out.println("result:"+result);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return "navegadorColorPresentacion";
    }
    public String modificarColoresPresentacion(){
        try {
            setCon(Util.openConnection(getCon()));
            String  sql="update colores_presprimaria set";
            sql+=" nombre_colorpresprimaria='"+colorPresentacionbean.getNombreColor().toUpperCase()+"',";
            sql+=" obs_colorpresprimaria='"+colorPresentacionbean.getObsColor()+"',";
            sql+=" cod_estado_registro='"+colorPresentacionbean.getEstadoReferencial().getCodEstadoRegistro()+"'";
            sql+=" where cod_colorpresprimaria="+colorPresentacionbean.getCodColor();
            System.out.println("modifi:"+sql);
            PreparedStatement st=getCon().prepareStatement(sql);
            int result=st.executeUpdate();
            if(result>0){
                cargarColoresPresentacion();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return "navegadorColorPresentacion";
    }
    public String eliminarColoresPresentacion(){
        try {
            
            Iterator i=coloresPresentacionEliminar.iterator();
            int result=0;
            while (i.hasNext()){
                ColoresPresentacion bean=(ColoresPresentacion)i.next();
                String sql="delete from colores_presprimaria  ";
                sql+=" where cod_colorpresprimaria="+bean.getCodColor();;
                
                System.out.println("deleteAcciones:sql:"+sql);
                setCon(Util.openConnection(getCon()));
                Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                result=result+st.executeUpdate(sql);
            }
            coloresPresentacionEliminar.clear();
            coloresPresentacionNoEliminar.clear();
            if(result>0){
                cargarColoresPresentacion();
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "navegadorColorPresentacion";
    }
    public String Cancelar(){
        coloresPresentacion.clear();
        cargarColoresPresentacion();
        return "navegadorColorPresentacion";
    }
    
    
    /**********ESTADO REGISTRO****************/
    public void changeEvent(ValueChangeEvent event){
        System.out.println("event:"+event.getNewValue());
        colorPresentacionbean.getEstadoReferencial().setCodEstadoRegistro(event.getNewValue().toString());
        cargarColoresPresentacion();
    }
//Metodo que cierra la conexion
    
    public String getCloseConnection() throws SQLException{
        if(getCon()!=null){
            getCon().close();
        }
        return "";
    }
    /**
     * Métodos de la Clase
     */

    public ColoresPresentacion getColorPresentacionbean() {
        return colorPresentacionbean;
    }

    public void setColorPresentacionbean(ColoresPresentacion colorPresentacionbean) {
        this.colorPresentacionbean = colorPresentacionbean;
    }

    public List getEstadoRegistro() {
        return estadoRegistro;
    }

    public void setEstadoRegistro(List estadoRegistro) {
        this.estadoRegistro = estadoRegistro;
    }

    public List getColoresPresentacion() {
        return coloresPresentacion;
    }

    public void setColoresPresentacion(List coloresPresentacion) {
        this.coloresPresentacion = coloresPresentacion;
    }

    public List getColoresPresentacionEliminar() {
        return coloresPresentacionEliminar;
    }

    public void setColoresPresentacionEliminar(List coloresPresentacionEliminar) {
        this.coloresPresentacionEliminar = coloresPresentacionEliminar;
    }

    public List getColoresPresentacionNoEliminar() {
        return coloresPresentacionNoEliminar;
    }

    public void setColoresPresentacionNoEliminar(List coloresPresentacionNoEliminar) {
        this.coloresPresentacionNoEliminar = coloresPresentacionNoEliminar;
    }

    public Connection getCon() {
        return con;
    }

    public void setCon(Connection con) {
        this.con = con;
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

}
