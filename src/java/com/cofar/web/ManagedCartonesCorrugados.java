/*
 * ManagedCartonesCorrugados.java
 * Created on 25 de Junio de 2008, 10:50
 */

package com.cofar.web;


import com.cofar.bean.CartonesCorrugados;
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
 *  @author Wilson Choquehuanca Gonzales
 *  @company COFAR
 */
public class ManagedCartonesCorrugados{
    
    private CartonesCorrugados cartonesCorrugadosbean=new CartonesCorrugados();
    private List cartonesCorrugados=new ArrayList();
    private List estadoRegistro=new ArrayList();
    private List cartonesCorrugadosEliminar=new ArrayList();
    private List cartonesCorrugadosNoEliminar=new ArrayList();
    private Connection con;
    private boolean swEliminaSi;
    private boolean swEliminaNo;
    
    
    public ManagedCartonesCorrugados() {
        cargarCartonesCorrugados();
    }
    /**
     * metodo que genera los codigos
     * correlativamente
     */
    public String getCodigoCartonesCorrugados(){
        String codigo="1";
        try {
            setCon(Util.openConnection(getCon()));
            String sql="select max(cod_carton)+1 from cartones_corrugados";
            PreparedStatement st=getCon().prepareStatement(sql);
            System.out.println("sql:MAX:"+sql);
            ResultSet rs=st.executeQuery();
            while (rs.next())
                codigo=rs.getString(1);
            if(codigo==null)
                codigo="1";
            
            cartonesCorrugadosbean.setCodCaton(codigo);
            System.out.println("coiogogo:"+codigo);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return  "";
    }
    
    public void cargarEstadoRegistro(String codigo,CartonesCorrugados bean){
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
    public void cargarCartonesCorrugados(){
        try {
            String sql="select cod_carton,nombre_carton,dim_alto,dim_largo,dim_ancho," +
                    "peso_gramos,obs_carton,cod_estado_registro" +
                    " from cartones_corrugados";
            if(!cartonesCorrugadosbean.getEstadoReferencial().getCodEstadoRegistro().equals("") && !cartonesCorrugadosbean.getEstadoReferencial().getCodEstadoRegistro().equals("3")){
                sql+=" where cod_estado_registro="+cartonesCorrugadosbean.getEstadoReferencial().getCodEstadoRegistro();
            }
            sql+=" order by nombre_carton asc";
            System.out.println("cargar:"+sql);
            setCon(Util.openConnection(getCon()));
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(sql);
            rs.last();
            int rows=rs.getRow();
            cartonesCorrugados.clear();
            rs.first();
            String cod="";
            for(int i=0;i<rows;i++){
                CartonesCorrugados bean=new CartonesCorrugados();
                bean.setCodCaton(rs.getString(1));
                bean.setNombreCarton(rs.getString(2));
                bean.setDimAlto(rs.getString(3));
                bean.setDimLargo(rs.getString(4));
                bean.setDimAncho(rs.getString(5));
                bean.setPesoGramos(rs.getString(6));
                bean.setObsCarton(rs.getString(7));
                cod=rs.getString(8);
                cod=(cod==null)?"":cod;
                System.out.println("st xxx:"+cod);
                cargarEstadoRegistro(cod,bean);
                cartonesCorrugados.add(bean);
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
        clearCartonesCorrugados();
        return"actionAgregarCartonesCorrugados";
    }
    
    
    public String actionEditar(){
        cargarEstadoRegistro("",null);
        Iterator i=cartonesCorrugados.iterator();
        while (i.hasNext()){
            CartonesCorrugados bean=(CartonesCorrugados)i.next();
            if(bean.getChecked().booleanValue()){
                cartonesCorrugadosbean=bean;
                break;
            }
            
        }
        return "actionEditarCartonesCorrugados";
    }
    
    
    public String actionEliminar(){
        setSwEliminaSi(false);
        setSwEliminaNo(false);
        cartonesCorrugadosEliminar.clear();
        cartonesCorrugadosNoEliminar.clear();
        int bandera=0;
        Iterator i=cartonesCorrugados.iterator();
        while (i.hasNext()){
            CartonesCorrugados bean=(CartonesCorrugados)i.next();
            if(bean.getChecked().booleanValue()){
                try {
                    String sql="select cod_carton from presentaciones_producto" +
                            " where cod_carton="+bean.getCodCaton();
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
                        cartonesCorrugadosEliminar.add(bean);
                        setSwEliminaSi(true);
                        System.out.println("entro  eliminarrrrrrrrrrrr");
                    }else{
                        cartonesCorrugadosNoEliminar.add(bean);
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
        return "actionEliminarCartonesCorrugados";
    }
    
    public void clearCartonesCorrugados(){
        cartonesCorrugadosbean.setCodCaton("");
        cartonesCorrugadosbean.setNombreCarton("");
        cartonesCorrugadosbean.setDimAlto("");
        cartonesCorrugadosbean.setDimLargo("");
        cartonesCorrugadosbean.setDimAncho("");
        cartonesCorrugadosbean.setPesoGramos("");
        cartonesCorrugadosbean.setObsCarton("");
    }
    
    public String guardarCartonesCorrugados(){
        try {
            String sql="insert into cartones_corrugados(cod_carton,nombre_carton,dim_alto,dim_largo," +
                    "dim_ancho,peso_gramos,obs_carton,cod_estado_registro)values(";
            sql+="'"+cartonesCorrugadosbean.getCodCaton()+"',";
            sql+="'"+cartonesCorrugadosbean.getNombreCarton().toUpperCase()+"',";
            sql+="'"+cartonesCorrugadosbean.getDimAlto()+"',";
            sql+="'"+cartonesCorrugadosbean.getDimLargo()+"',";
            sql+="'"+cartonesCorrugadosbean.getDimAncho()+"',";
            sql+="'"+cartonesCorrugadosbean.getPesoGramos()+"',";
            sql+="'"+cartonesCorrugadosbean.getObsCarton()+"',1)";
            System.out.println("inset:"+sql);
            setCon(Util.openConnection(getCon()));
            PreparedStatement st=getCon().prepareStatement(sql);
            int result=st.executeUpdate();
            if(result>0){
                cargarCartonesCorrugados();
                clearCartonesCorrugados();
            }
            System.out.println("result:"+result);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return "navegadorCartonesCorrugados";
    }
    public String modificarCartonesCorrugados(){
        try {
            setCon(Util.openConnection(getCon()));
            String  sql="update cartones_corrugados set";
            sql+=" nombre_carton='"+cartonesCorrugadosbean.getNombreCarton().toUpperCase()+"',";
            sql+=" dim_alto='"+cartonesCorrugadosbean.getDimAlto()+"',";
            sql+=" dim_largo='"+cartonesCorrugadosbean.getDimLargo()+"',";
            sql+=" dim_ancho='"+cartonesCorrugadosbean.getDimAncho()+"',";
            sql+=" peso_gramos='"+cartonesCorrugadosbean.getPesoGramos()+"',";
            sql+=" cod_estado_registro='"+cartonesCorrugadosbean.getEstadoReferencial().getCodEstadoRegistro()+"'";
            sql+=" where cod_carton="+cartonesCorrugadosbean.getCodCaton();
            System.out.println("modifi:"+sql);
            PreparedStatement st=getCon().prepareStatement(sql);
            int result=st.executeUpdate();
            if(result>0){
                cargarCartonesCorrugados();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return "navegadorCartonesCorrugados";
    }
    public String eliminarCartonesCorrugados(){
        try {
            
            Iterator i=cartonesCorrugadosEliminar.iterator();
            int result=0;
            while (i.hasNext()){
                CartonesCorrugados bean=(CartonesCorrugados)i.next();
                String sql="delete from cartones_corrugados  ";
                sql+=" where cod_carton="+bean.getCodCaton();;
                System.out.println("deleteCartones:sql:"+sql);
                setCon(Util.openConnection(getCon()));
                Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                result=result+st.executeUpdate(sql);
            }
            cartonesCorrugadosEliminar.clear();
            cartonesCorrugadosNoEliminar.clear();
            if(result>0){
                cargarCartonesCorrugados();
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "navegadorCartonesCorrugados";
    }
    public String Cancelar(){
        cartonesCorrugados.clear();
        cargarCartonesCorrugados();
        return "navegadorCartonesCorrugados";
    }
    
    
    /**********ESTADO REGISTRO****************/
    public void changeEvent(ValueChangeEvent event){
        System.out.println("event:"+event.getNewValue());
        cartonesCorrugadosbean.getEstadoReferencial().setCodEstadoRegistro(event.getNewValue().toString());
        cargarCartonesCorrugados();
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
    
    public CartonesCorrugados getCartonesCorrugadosbean() {
        return cartonesCorrugadosbean;
    }
    
    public void setCartonesCorrugadosbean(CartonesCorrugados cartonesCorrugadosbean) {
        this.cartonesCorrugadosbean = cartonesCorrugadosbean;
    }
    
    public List getCartonesCorrugados() {
        return cartonesCorrugados;
    }
    
    public void setCartonesCorrugados(List cartonesCorrugados) {
        this.cartonesCorrugados = cartonesCorrugados;
    }
    
    public List getEstadoRegistro() {
        return estadoRegistro;
    }
    
    public void setEstadoRegistro(List estadoRegistro) {
        this.estadoRegistro = estadoRegistro;
    }
    
    public List getCartonesCorrugadosEliminar() {
        return cartonesCorrugadosEliminar;
    }
    
    public void setCartonesCorrugadosEliminar(List cartonesCorrugadosEliminar) {
        this.cartonesCorrugadosEliminar = cartonesCorrugadosEliminar;
    }
    
    public List getCartonesCorrugadosNoEliminar() {
        return cartonesCorrugadosNoEliminar;
    }
    
    public void setCartonesCorrugadosNoEliminar(List cartonesCorrugadosNoEliminar) {
        this.cartonesCorrugadosNoEliminar = cartonesCorrugadosNoEliminar;
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
