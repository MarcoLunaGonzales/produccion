/*
 * ManagedTipoCliente.java
 * Created on 19 de febrero de 2008, 16:50
 */

package com.cofar.web;

import com.cofar.bean.SaboresProducto;
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
public class ManagedSaboresProducto{
    
    /** Creates a new instance of ManagedTipoCliente */
    private SaboresProducto saboresProductobean=new SaboresProducto();
    private List estadoRegistro=new ArrayList();
    private List saboresProducto=new ArrayList();
    private List saboresProductoEliminar=new ArrayList();
    private List saboresProductoNoEliminar=new ArrayList();
    private Connection con;
    private boolean swEliminaSi;
    private boolean swEliminaNo;
    
    
    public ManagedSaboresProducto() {
        cargarSaboresProducto();
    }
    /**
     * metodo que genera los codigos
     * correlativamente
     */
    public String getCodigoSabores(){
        String codigo="1";
        try {
            setCon(Util.openConnection(getCon()));
            String sql="select max(cod_sabor)+1 from sabores_producto";
            PreparedStatement st=getCon().prepareStatement(sql);
            System.out.println("sql:MAX:"+sql);
            ResultSet rs=st.executeQuery();
            while (rs.next())
                codigo=rs.getString(1);
            if(codigo==null)
                codigo="1";
            saboresProductobean.setCodSabor(codigo);
            System.out.println("coiogogo:"+codigo);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return  "";
    }
    
    public void cargarEstadoRegistro(String codigo,SaboresProducto bean){
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
    public void cargarSaboresProducto(){
        try {
            String sql="select cod_sabor,nombre_sabor,obs_sabor,cod_estado_registro" +
                    " from sabores_producto";
            if(!saboresProductobean.getEstadoReferencial().getCodEstadoRegistro().equals("") && !saboresProductobean.getEstadoReferencial().getCodEstadoRegistro().equals("3")){
                sql+=" where cod_estado_registro="+saboresProductobean.getEstadoReferencial().getCodEstadoRegistro();
            }
            sql+=" order by nombre_sabor asc";
            System.out.println("cargar:"+sql);
            setCon(Util.openConnection(getCon()));
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(sql);
            rs.last();
            int rows=rs.getRow();
            saboresProducto.clear();
            rs.first();
            String cod="";
            for(int i=0;i<rows;i++){
                SaboresProducto bean=new SaboresProducto();
                bean.setCodSabor(rs.getString(1));
                bean.setNombreSabor(rs.getString(2));
                bean.setObsSabor(rs.getString(3));
                //bean.setCodEstadoRegistro(rs.getString(7));
                cod=rs.getString(4);
                cod=(cod==null)?"":cod;
                System.out.println("st xxx:"+cod);
                cargarEstadoRegistro(cod,bean);
                saboresProducto.add(bean);
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
        clearSaboresProducto();
        return"actionAgregarSaboresProducto";
    }
    
    
    public String actionEditar(){
        cargarEstadoRegistro("",null);
        Iterator i=saboresProducto.iterator();
        while (i.hasNext()){
            SaboresProducto bean=(SaboresProducto)i.next();
            if(bean.getChecked().booleanValue()){
                saboresProductobean=bean;
                break;
            }
            
        }
        return "actionEditarSaboresProducto";
    }
    
    
    public String actionEliminar(){
        setSwEliminaSi(false);
        setSwEliminaNo(false);
        saboresProductoEliminar.clear();
        saboresProductoNoEliminar.clear();
        int bandera=0;
        Iterator i=saboresProducto.iterator();
        while (i.hasNext()){
            SaboresProducto bean=(SaboresProducto)i.next();
            if(bean.getChecked().booleanValue()){
                try {
                    String sql="select cod_sabor from presentaciones_producto" +
                            " where cod_sabor="+bean.getCodSabor();
                    System.out.println("presentacionEliminar:"+sql);
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
                        saboresProductoEliminar.add(bean);
                        setSwEliminaSi(true);
                        System.out.println("entro  eliminarrrrrrrrrrrr");
                    }else{
                        saboresProductoNoEliminar.add(bean);
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
        return "EliminarSaboresProducto";
    }
    
    public void clearSaboresProducto(){
        saboresProductobean.setCodSabor("");
        saboresProductobean.setNombreSabor("");
        saboresProductobean.setObsSabor("");
        
    }
    
    public String guardarSaboresProducto(){
        try {
            String sql="insert into sabores_producto(cod_sabor,nombre_sabor," +
                    "obs_sabor,cod_estado_registro)values(";
            sql+="'"+saboresProductobean.getCodSabor()+"','"+saboresProductobean.getNombreSabor().toUpperCase()+"',"+
                    "'"+saboresProductobean.getObsSabor()+"',1)";
            System.out.println("inset:"+sql);
            setCon(Util.openConnection(getCon()));
            PreparedStatement st=getCon().prepareStatement(sql);
            int result=st.executeUpdate();
            if(result>0){
                cargarSaboresProducto();
                clearSaboresProducto();
            }
            System.out.println("result:"+result);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return "navegadorSaboresProducto";
    }
    public String modificarSaboresProducto(){
        try {
            setCon(Util.openConnection(getCon()));
            String  sql="update sabores_producto set";
            sql+=" nombre_sabor='"+saboresProductobean.getNombreSabor().toUpperCase()+"',";
            sql+=" obs_sabor='"+saboresProductobean.getObsSabor()+"',";
            sql+=" cod_estado_registro='"+saboresProductobean.getEstadoReferencial().getCodEstadoRegistro()+"'";
            sql+=" where cod_sabor="+saboresProductobean.getCodSabor();
            System.out.println("modifi:"+sql);
            PreparedStatement st=getCon().prepareStatement(sql);
            int result=st.executeUpdate();
            if(result>0){
                cargarSaboresProducto();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return "navegadorSaboresProducto";
    }
    public String eliminarSaboresProducto(){
        try {
            
            Iterator i=saboresProductoEliminar.iterator();
            int result=0;
            while (i.hasNext()){
                SaboresProducto bean=(SaboresProducto)i.next();
                String sql="delete from sabores_producto  ";
                sql+=" where cod_sabor="+bean.getCodSabor();;
                
                System.out.println("deleteAcciones:sql:"+sql);
                setCon(Util.openConnection(getCon()));
                Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                result=result+st.executeUpdate(sql);
            }
            saboresProductoEliminar.clear();
            saboresProductoNoEliminar.clear();
            if(result>0){
                cargarSaboresProducto();
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "navegadorSaboresProducto";
    }
    public String Cancelar(){
        saboresProducto.clear();
        cargarSaboresProducto();
        return "navegadorSaboresProducto";
    }
    
    
    /**********ESTADO REGISTRO****************/
    public void changeEvent(ValueChangeEvent event){
        System.out.println("event:"+event.getNewValue());
        saboresProductobean.getEstadoReferencial().setCodEstadoRegistro(event.getNewValue().toString());
        cargarSaboresProducto();
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
    
    public SaboresProducto getSaboresProductobean() {
        return saboresProductobean;
    }
    
    public void setSaboresProductobean(SaboresProducto saboresProductobean) {
        this.saboresProductobean = saboresProductobean;
    }
    
    public List getEstadoRegistro() {
        return estadoRegistro;
    }
    
    public void setEstadoRegistro(List estadoRegistro) {
        this.estadoRegistro = estadoRegistro;
    }
    
    public List getSaboresProducto() {
        return saboresProducto;
    }
    
    public void setSaboresProducto(List saboresProducto) {
        this.saboresProducto = saboresProducto;
    }
    
    public List getSaboresProductoEliminar() {
        return saboresProductoEliminar;
    }
    
    public void setSaboresProductoEliminar(List saboresProductoEliminar) {
        this.saboresProductoEliminar = saboresProductoEliminar;
    }
    
    public List getSaboresProductoNoEliminar() {
        return saboresProductoNoEliminar;
    }
    
    public void setSaboresProductoNoEliminar(List saboresProductoNoEliminar) {
        this.saboresProductoNoEliminar = saboresProductoNoEliminar;
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
