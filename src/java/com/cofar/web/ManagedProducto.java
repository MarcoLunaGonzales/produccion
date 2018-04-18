/*
 * ManagedPermiso.java
 *
 * Created on 4 de marzo de 2008, 10:19 AM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.cofar.web;

import com.cofar.bean.Producto;
import com.cofar.bean.FormasFarmaceuticas;
import com.cofar.bean.EstadoProducto;
import com.cofar.util.Util;
import java.sql.Connection;
import java.sql.DriverManager;
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
import javax.servlet.jsp.tagext.TryCatchFinally;
/**
 *
 *  @author René Ergueta Illanes
 *  @company COFAR
 */
public class ManagedProducto {
    
    /** Creates a new instance of ManagedComision */
    private List productoList=new ArrayList();
    private List productoEli=new ArrayList();
    private Producto productoBean=new Producto();
    private FormasFarmaceuticas formaFarmaceuticaBean=new FormasFarmaceuticas();
    private List estadoproducto=new ArrayList();
    private List formafarmaceutica=new ArrayList();
    private Connection con;
    public ManagedProducto() {
        cargarDatoProductos();
    }
    /**
     * -------------------------------------------------------------------------
     * GENERAR CODIGO
     * -------------------------------------------------------------------------
     **/
    public void generarCodigo(){
        System.out.println("asDFASDFASDF");
        try {
            String  sql="select max(cod_prod)+1 from productos";
            setCon(Util.openConnection(getCon()));
            Statement st=getCon().createStatement();
            ResultSet rs=st.executeQuery(sql);
            if(rs.next()){
                String cod=rs.getString(1);
                if(cod==null)
                    getProductoBean().setCodProducto("1");
                else
                    getProductoBean().setCodProducto(cod);
            }
            if(rs!=null){
                rs.close();
                st.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public String[] cargarEstadoRefenreciales(String codigo,String option){
        String values[]=new String[2];
        try {
            
            String sql="";
            if(option.equals("CARGAR_PROD")){
                sql="select cod_estado_prod,nombre_estado_prod from estados_producto where cod_estado_registro=1 and cod_estado_prod="+codigo;
            }
            System.out.println("sql:"+sql);
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            if(!sql.equals("")){
                ResultSet rs=st.executeQuery(sql);
                if(rs.next()){
                    values[0]=rs.getString(1);
                    values[1]=rs.getString(2);
                }
                if(rs!=null){
                    rs.close();
                    st.close();
                }
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return values;
    }
    /**
     * -------------------------------------------------------------------------
     * CARGAR ESTADOS PRODUCTO
     * -------------------------------------------------------------------------
     **/
    public void cargarEstadoProducto(){
        getEstadoproducto().clear();
        try {
            String sql="select cod_estado_prod,nombre_estado_prod from estados_producto where " +
                    " cod_estado_registro=1";
            setCon(Util.openConnection(getCon()));
            Statement st=getCon().createStatement();
            ResultSet rs=st.executeQuery(sql);
            //getHorariolist().add(new SelectItem("0","Seleccione una opcion"));
            while (rs.next())
                getEstadoproducto().add(new SelectItem(rs.getString(1),rs.getString(2)));
            if(rs!=null){
                rs.close();
                st.close();
                rs=null;
                st=null;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    /**
     * -------------------------------------------------------------------------
     * CARGAR FORMA FARMACEUTICA
     * -------------------------------------------------------------------------
     **/
    public void cargarFormaFarmaceutica(){
        formafarmaceutica.clear();
        try {
            String sql="select cod_forma,nombre_forma from formas_farmaceuticas where " +
                    " cod_estado_registro=1";
            setCon(Util.openConnection(getCon()));
            Statement st=getCon().createStatement();
            ResultSet rs=st.executeQuery(sql);
            //getHorariolist().add(new SelectItem("0","Seleccione una opcion"));
            while (rs.next())
                formafarmaceutica.add(new SelectItem(rs.getString(1),rs.getString(2)));
            if(rs!=null){
                rs.close();
                st.close();
                rs=null;
                st=null;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    /**
     * -------------------------------------------------------------------------
     * CARGAR DATOS
     * -------------------------------------------------------------------------
     **/
    public void cargarDatoProductos(){
        productoList.clear();
        try {
            String sql="select cod_prod,nombre_prod,cod_estado_prod, obs_prod";
            sql+=" from productos";

            if(!getProductoBean().getEstadoProducto().getCodEstadoProducto().equals("") ){
                sql+=" where cod_estado_prod="+getProductoBean().getEstadoProducto().getCodEstadoProducto();
            }
            sql+=" order by nombre_prod";
            System.out.println("cargarDatos:sql:"+sql);
            setCon(Util.openConnection(getCon()));
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(sql);
            //String cod="";
            getProductoList().clear();
            while (rs.next()){
                Producto bean=new Producto();
                bean.setCodProducto(rs.getString(1));
                bean.setNombreProducto(rs.getString(2));
                
                String codEstadoProd=rs.getString(3);
                String value[]=cargarEstadoRefenreciales(codEstadoProd,"CARGAR_PROD");
                bean.getEstadoProducto().setCodEstadoProducto(value[0]);
                bean.getEstadoProducto().setNombreEstadoProducto(value[1]);
                /*
                bean.setLoteMinimoProd(rs.getString(5));
                bean.setLoteMaximoProd(rs.getString(6));
                bean.setRnProd(rs.getString(7));*/
                /*trato de las fechas*/
               /* Date date1=rs.getDate(8);
                SimpleDateFormat f=new SimpleDateFormat("dd/MM/yyyy");
                bean.setVigencia(f.format(date1));
                date1= rs.getDate(9);
                bean.setExpiracion(f.format(date1));
                bean.setTamSubLote(rs.getString(10));
                bean.setTamanoLoteProd(rs.getString(11));*/
                bean.setObsProd(rs.getString(4));
                getProductoList().add(bean);
            }
            cargarEstadoProducto();
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
        getProductoBean().getEstadoProducto().setCodEstadoProducto(event.getNewValue().toString());
        cargarDatoProductos();
    }
    /**
     * -------------------------------------------------------------------------
     * CARGAR ESTADO REGISTRO
     * -------------------------------------------------------------------------
     **/
    public void cargarEstadoRegistro(String codigo,Producto bean){
        try {
            setCon(Util.openConnection(getCon()));
            String sql="select cod_estado_registro,nombre_estado_registro from estados_referenciales where cod_estado_registro<>3";
            ResultSet rs=null;
            
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            if(!codigo.equals("")){
                sql+=" and cod_estado_registro="+codigo;
                rs=st.executeQuery(sql);
                if(rs.next()){
                    // bean.getEstadoReferencial().setCodEstadoRegistro(rs.getString(1));
                    // bean.getEstadoReferencial().setNombreEstadoRegistro(rs.getString(2));
                }
            } else{
                // getEstadoRegistro().clear();
                rs=st.executeQuery(sql);
                // while (rs.next())
                //    getEstadoRegistro().add(new SelectItem(rs.getString(1),rs.getString(2)));
            }
            if(rs!=null){
                rs.close();st.close();
                rs=null;st=null;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public void clear(){
        Producto ep=new Producto();
        setProductoBean(ep);
    }
    /**
     * -------------------------------------------------------------------------
     * ACTION REGISTRAR
     * -------------------------------------------------------------------------
     **/
    public String actionRegistrarProducto(){
        clear();
        System.out.println("dddddddddddddddddddddddd");
        generarCodigo();
        cargarEstadoProducto();
        cargarFormaFarmaceutica();
        return "actionAgregarProducto";
    }
    /**
     * -------------------------------------------------------------------------
     * ACTION EDITAR
     * -------------------------------------------------------------------------
     **/
    public String actionEditarProducto(){
        Iterator i=productoList.iterator();
        while (i.hasNext()){
            Producto bean=(Producto)i.next();
            if(bean.getChecked().booleanValue()){
                setProductoBean(bean);
                break;
            }
        }
        cargarEstadoProducto();
        cargarFormaFarmaceutica();
        return "actionEditarProducto";
    }
    /**
     * -------------------------------------------------------------------------
     * ACTION ELIMINAR
     * -------------------------------------------------------------------------
     **/
    public String actionEliminarProducto(){
        getProductoEli().clear();
        Iterator i=productoList.iterator();
        while (i.hasNext()){
            Producto bean=(Producto)i.next();
            if(bean.getChecked().booleanValue()){
                getProductoEli().add(bean);
            }
        }
        return "actionEliminarProducto";
    }
    /**
     * -------------------------------------------------------------------------
     * ACTION CANCELAR
     * -------------------------------------------------------------------------
     **/
    public String actionCancelar(){
        cargarDatoProductos();
        return "cancelarProducto";
    }
    /**
     * -------------------------------------------------------------------------
     * GUARDAR PRODUCTOR
     * -------------------------------------------------------------------------
     **/
    public String guardarProducto(){
        try {
            /*guarda los datos segun consuta*/
          
            String sql="insert into productos(cod_prod,nombre_prod,cod_estado_prod,obs_prod)";
            sql+=" values(";
            sql+=""+getProductoBean().getCodProducto()+",";
            sql+="'"+getProductoBean().getNombreProducto()+"',1,";
            //sql+=""+getProductoBean().getEstadoProducto().getCodEstadoProducto()+",";
            sql+="'"+getProductoBean().getObsProd()+"')";
            System.out.println("save:sql:"+sql);
            setCon(Util.openConnection(getCon()));
            
            PreparedStatement st=getCon().prepareStatement(sql);
            int result=st.executeUpdate();
            st.close();
            productoList.clear();
            if(result>0){
                cargarDatoProductos();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "navegadorProducto";
    }
    /**
     * -------------------------------------------------------------------------
     * MODIFICAR PRODUCTOR
     * -------------------------------------------------------------------------
     **/
    public String modificarProducto(){
        Date date1=getProductoBean().getVigenciaProd();
        SimpleDateFormat f1=new SimpleDateFormat("yyyy/MM/dd");
        Date date2=getProductoBean().getExpiracionProd();
        SimpleDateFormat f2=new SimpleDateFormat("yyyy/MM/dd");
        try {
            String sql="update productos set ";
            sql+=" nombre_prod='"+getProductoBean().getNombreProducto()+"',";
            sql+=" obs_prod='"+getProductoBean().getObsProd()+"'";
            sql+=" where cod_prod="+getProductoBean().getCodProducto();
            System.out.println("editProducto sql:"+sql);
            con=Util.openConnection(con);
            PreparedStatement st=con.prepareStatement(sql);
            int result=st.executeUpdate();
            if(result>0){
                cargarDatoProductos();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "navegadorProducto";
    }
    /**
     * -------------------------------------------------------------------------
     * ELIMINAR PRODUCTOS
     * -------------------------------------------------------------------------
     **/
    public String eliminarProducto(){
        try {
            Iterator i=productoEli.iterator();
            con=Util.openConnection(con);
            int result=0;
            while (i.hasNext()){
                Producto bean=(Producto)i.next();
                String sql="select cod_presentacion from presentaciones_producto where cod_prod="+bean.getCodProducto();
                System.out.println("LISTA PRESENTACIONES: "+ sql);
                Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                Statement stDelete=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rs=st.executeQuery(sql);
                while(rs.next()){
                    String codPresentacion=rs.getString("cod_presentacion");
                    String sqlDelete="delete from componentes_presprod where cod_presentacion="+codPresentacion;
                    System.out.println("DELETE PRESENTACIONES COMP: "+ sqlDelete);
                    
                    stDelete.executeUpdate(sqlDelete);
                    sqlDelete="delete from presentaciones_producto where cod_prod="+bean.getCodProducto();
                    System.out.println("DELETE PRESENTACIONES.."+sqlDelete);
                    stDelete.executeUpdate(sqlDelete);
                }
                
                String sqlComponentes="select cod_compprod from componentes_prod where cod_prod="+bean.getCodProducto();
                System.out.println("LISTA COMPONENETES:"+sqlComponentes);
                Statement stm=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rsComponentes=stm.executeQuery(sqlComponentes);
                while(rsComponentes.next()){
                    String codComponente=rsComponentes.getString("cod_compprod");
                    sql="delete from componentes_proddetalle where cod_compprod="+codComponente;
                    System.out.println("DELETE COMP. DETALLE:" +sql);
                    stDelete.executeUpdate(sql);
                    sql="delete from componentes_prod where cod_compprod="+codComponente;
                    System.out.println("DELETE COMPONENTES:"+sql);
                    stDelete.executeUpdate(sql);
                }
                sql="delete productos ";
                sql+=" where cod_prod="+bean.getCodProducto();
                System.out.println("DELETE PRODUCTOS: "+sql);
                stm.executeUpdate(sql);
            }
            productoList.clear();
            cargarDatoProductos();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        productoEli.clear();
        return "navegadorProducto";
    }
/*    public static void main(String[] args) throws ClassNotFoundException {
        try {
            Connection con = null;
            Class.forName("sun.jdbc.odbc.JdbcOdbcDriver");
            con=DriverManager.getConnection("jdbc:odbc:ventas","sa","4868422");
            
//            con=Util.openConnection(con);
            int codProducto=43;
            String sql="select cod_presentacion from presentaciones_producto where cod_prod="+codProducto;
            System.out.println("LISTA PRESENTACIONES: "+ sql);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            Statement stDelete=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(sql);
            while(rs.next()){
                String codPresentacion=rs.getString("cod_presentacion");
                String sqlDelete="delete from componentes_presprod where cod_presentacion="+codPresentacion;
                System.out.println("DELETE PRESENTACIONES COMP: "+ sqlDelete);
                
                stDelete.executeUpdate(sqlDelete);
                sqlDelete="delete from presentaciones_producto where cod_prod="+codProducto;
                System.out.println("DELETE PRESENTACIONES.."+sqlDelete);
                stDelete.executeUpdate(sqlDelete);
            }
            
            String sqlComponentes="select cod_compprod from componentes_prod where cod_prod="+codProducto;
            System.out.println("LISTA COMPONENETES:"+sqlComponentes);
            Statement stm=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rsComponentes=stm.executeQuery(sqlComponentes);
            while(rsComponentes.next()){
                String codComponente=rsComponentes.getString("cod_compprod");
                sql="delete from componentes_proddetalle where cod_compprod="+codComponente;
                System.out.println("DELETE COMP. DETALLE:" +sql);
                stDelete.executeUpdate(sql);
                sql="delete from componentes_prod where cod_compprod="+codComponente;
                System.out.println("DELETE COMPONENTES:"+sql);
                stDelete.executeUpdate(sql);
            }
            sql="delete productos ";
            sql+=" where cod_prod="+codProducto;
            System.out.println("DELETE PRODUCTOS: "+sql);
            stm.executeUpdate(sql);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }*/
    
    /**
     * -------------------------------------------------------------------------
     * CERRAR CONEXION
     * -------------------------------------------------------------------------
     **/
    public String getCloseConnection() throws SQLException{
        if(getCon()!=null){
            getCon().close();
        }
        return "";
    }
    
    public List getProductoList() {
        return productoList;
    }
    
    public void setProductoList(List productoList) {
        this.productoList = productoList;
    }
    
    public List getProductoEli() {
        return productoEli;
    }
    
    public void setProductoEli(List productoEli) {
        this.productoEli = productoEli;
    }
    
    public FormasFarmaceuticas getFormaFarmaceuticaBean() {
        return formaFarmaceuticaBean;
    }
    
    public void setFormaFarmaceuticaBean(FormasFarmaceuticas formaFarmaceuticaBean) {
        this.formaFarmaceuticaBean = formaFarmaceuticaBean;
    }
    
    public List getEstadoproducto() {
        return estadoproducto;
    }
    
    public void setEstadoproducto(List estadoproducto) {
        this.estadoproducto = estadoproducto;
    }
    
    public List getFormafarmaceutica() {
        return formafarmaceutica;
    }
    
    public void setFormafarmaceutica(List formafarmaceutica) {
        this.formafarmaceutica = formafarmaceutica;
    }
    
    public Connection getCon() {
        return con;
    }
    
    public void setCon(Connection con) {
        this.con = con;
    }
    
    public Producto getProductoBean() {
        return productoBean;
    }
    
    public void setProductoBean(Producto productoBean) {
        this.productoBean = productoBean;
    }
}
