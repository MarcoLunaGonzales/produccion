/*
 * ManagedTipoCliente.java
 * Created on 19 de febrero de 2008, 16:50
 */

package com.cofar.web;

import com.cofar.bean.PartesModulosInstalacion;
import com.cofar.bean.Materiales;
import com.cofar.util.Util;
import com.sun.mail.util.BEncoderStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import javax.faces.model.SelectItem;

/**
 *
 *  @author Wilmer Manzaneda Chavez
 *  @company COFAR
 */
public class ManagedPartesModulosInstalacion {
    
    /** Creates a new instance of ManagedTipoCliente */
    private PartesModulosInstalacion partesModulosInstalacionbean=new PartesModulosInstalacion();
    private List partesModulosInstalacionList=new ArrayList();
    private List partesModulosInstalacionAdicionarList=new ArrayList();
    private List partesModulosInstalacionEliminarList=new ArrayList();
    private List partesModulosInstalacionEditarList=new ArrayList();
    private Connection con;
    private String codigo="";
    private boolean swSi=false;
    private boolean swNo=false;
    private String nombreModuloInstalacion="";
    
    public ManagedPartesModulosInstalacion() {
        
    }
    
    public void generarCodigo(){
        try {
            String  sql="select max(COD_PARTE_MODULO)+1 from PARTES_MODULOS_INSTALACION";
            setCon(Util.openConnection(getCon()));
            Statement st=getCon().createStatement();
            ResultSet rs=st.executeQuery(sql);
            if(rs.next()){
                String cod=rs.getString(1);
                if(cod==null)
                    getPartesModulosInstalacionbean().setCodParteModulo("1");
                else
                    getPartesModulosInstalacionbean().setCodParteModulo(cod);
            }
            if(rs!=null){
                rs.close();
                st.close();
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public String getObtenerCodigo(){
        
        //String cod=Util.getParameter("codigo");
        String cod=Util.getParameter("codigo");
        //cod="1";
        System.out.println("cxxxxxxxxxxxxxxxxxxxxxxxod:"+cod);
        if(cod!=null){
            setCodigo(cod);
        }
        partesModulosInstalacionList.clear();
        cargarPartesModulosInstalacion();
        cargarNombreModulo();
        return "";
        
    }
    
    public String cancelar(){
        cargarPartesModulosInstalacion();
        return "navegadorPartesModulosInstalacion";
    }
    
    public String cargarNombreModulo(){
        try {
            setNombreModuloInstalacion("");
            setCon(Util.openConnection(getCon()));
            String sql=" select m.NOMBRE_MODULO_INSTALACION from MODULOS_INSTALACIONES m";
            sql+=" where m.COD_MODULO_INSTALACION='"+getCodigo()+"'";
            System.out.println("sql:-----------:"+sql);
            PreparedStatement st=getCon().prepareStatement(sql);
            ResultSet rs=st.executeQuery();
            while (rs.next()){
                setNombreModuloInstalacion(rs.getString(1));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        System.out.println("nombreModuloInstalacion:"+nombreModuloInstalacion);
        return  "";
    }
    
    /**
     * metodo que genera los codigos
     * correlativamente
     */
    
    /**
     * Metodo para cargar los datos en
     * el datatable
     */
    
    public void cargarPartesModulosInstalacion(){
        
        try {
            System.out.println("codigo:"+getCodigo());
            String sql="select P.COD_PARTE_MODULO,P.NOMBRE_PARTE_MODULO from PARTES_MODULOS_INSTALACION p";
            sql+=" where p.COD_MODULO_INSTALACION='"+codigo+"' ORDER BY p.NOMBRE_PARTE_MODULO";
            System.out.println("sql PARTES_MODULOS_INSTALACION:  "+sql);
            setCon(Util.openConnection(getCon()));
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(sql);
            rs.last();
            int rows=rs.getRow();
            partesModulosInstalacionList.clear();
            rs.first();
            for(int i=0;i<rows;i++){
                
                PartesModulosInstalacion bean=new PartesModulosInstalacion();
                bean.setCodParteModulo(rs.getString(1));
                bean.setNombreParteModulo(rs.getString(2));
                partesModulosInstalacionList.add(bean);
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
    
    
    public double redondear(double numero, int decimales) {
        return Math.round(numero * Math.pow(10, decimales)) / Math.pow(10, decimales);
    }
    public String actionAgregar(){
        System.out.println("entro4656532");
        PartesModulosInstalacion p=new PartesModulosInstalacion();
        partesModulosInstalacionbean=p;
        return "actionAgregarPartesModulosInstalacion";
    }
    
    
    
    ////////////// Guardar ////////////////////////
    
    public String guardarPartesModulosInstalacion(){
        
        try {
            
            setCon(Util.openConnection(getCon()));
            generarCodigo();
            String sql="insert into PARTES_MODULOS_INSTALACION(COD_PARTE_MODULO,NOMBRE_PARTE_MODULO,COD_MODULO_INSTALACION)values(" ;
            sql+="'"+partesModulosInstalacionbean.getCodParteModulo()+"','"+partesModulosInstalacionbean.getNombreParteModulo()+"',"+codigo+")";
            System.out.println("sql:"+sql);
            PreparedStatement st1=getCon().prepareStatement(sql);
            int result=st1.executeUpdate();
            System.out.println("result:"+result);
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        cargarPartesModulosInstalacion();
        return "navegadorPartesModulosInstalacion";
    }
    
    public String guardarEditarPartesModulosInstalacion(){
        
        System.out.println("xxxxxxxxxxxxxxxx:"+getCodigo());
        
        try {
            setCon(Util.openConnection(getCon()));
            String sql="update PARTES_MODULOS_INSTALACION set" ;
            sql+=" NOMBRE_PARTE_MODULO='"+partesModulosInstalacionbean.getNombreParteModulo()+"' " ;
            sql+=" where COD_PARTE_MODULO='"+partesModulosInstalacionbean.getCodParteModulo()+"' and COD_MODULO_INSTALACION='"+getCodigo()+"'" ;
            System.out.println("sql:"+sql);
            PreparedStatement st1=getCon().prepareStatement(sql);
            int result=st1.executeUpdate();
            System.out.println("result:"+result);
            
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        cargarPartesModulosInstalacion();
        return "navegadorPartesModulosInstalacion";
    }
    
    public String actionEditar(){
        Iterator i=partesModulosInstalacionList.iterator();
        while (i.hasNext()){
            PartesModulosInstalacion bean=(PartesModulosInstalacion)i.next();
            if(bean.getChecked().booleanValue()){
                setPartesModulosInstalacionbean(bean);
                break;
            }
            
        }
        
        return "actionEditarPartesModulosInstalacion";
    }
    
    
    public String guardarEliminarPartesModulosInstalacion(){
        
        System.out.println("xxxxxxxxxxxxxxxx:"+getCodigo());
        //System.out.println("area_inferior:"+codigoAreaInferior);
        Iterator index=partesModulosInstalacionList.iterator();
        String sql="";
        int result=0;
        while (index.hasNext()){
            
            try {
                PartesModulosInstalacion bean=(PartesModulosInstalacion)index.next();
                if(bean.getChecked().booleanValue()){
                    setCon(Util.openConnection(getCon()));
                    sql="delete from PARTES_MODULOS_INSTALACION" +
                            " where COD_MODULO_INSTALACION='"+getCodigo()+"' and COD_PARTE_MODULO='"+bean.getCodParteModulo()+"'" ;
                    System.out.println("sql Eliminar:"+sql);
                    PreparedStatement st1=getCon().prepareStatement(sql);
                    result=st1.executeUpdate();
                    System.out.println("result:"+result);
                }
                
            } catch (SQLException e) {
                e.printStackTrace();
            }
            
        }
        cargarPartesModulosInstalacion();
        return "navegadorPartesModulosInstalacion";
    }
    
    
    /**
     *  Este metodo limpia los datos del bean
     */
    
    public String getCloseConnection() throws SQLException{
        if(getCon()!=null){
            getCon().close();
        }
        return "";
    }
    /**
     * Métodos de la Clase
     */
    
    public PartesModulosInstalacion getPartesModulosInstalacionbean() {
        return partesModulosInstalacionbean;
    }
    
    public void setPartesModulosInstalacionbean(PartesModulosInstalacion partesModulosInstalacionbean) {
        this.partesModulosInstalacionbean = partesModulosInstalacionbean;
    }
    
    public List getPartesModulosInstalacionList() {
        return partesModulosInstalacionList;
    }
    
    public void setPartesModulosInstalacionList(List partesModulosInstalacionList) {
        this.partesModulosInstalacionList = partesModulosInstalacionList;
    }
    
    public List getPartesModulosInstalacionAdicionarList() {
        return partesModulosInstalacionAdicionarList;
    }
    
    public void setPartesModulosInstalacionAdicionarList(List partesModulosInstalacionAdicionarList) {
        this.partesModulosInstalacionAdicionarList = partesModulosInstalacionAdicionarList;
    }
    
    public List getPartesModulosInstalacionEliminarList() {
        return partesModulosInstalacionEliminarList;
    }
    
    public void setPartesModulosInstalacionEliminarList(List partesModulosInstalacionEliminarList) {
        this.partesModulosInstalacionEliminarList = partesModulosInstalacionEliminarList;
    }
    
    public List getPartesModulosInstalacionEditarList() {
        return partesModulosInstalacionEditarList;
    }
    
    public void setPartesModulosInstalacionEditarList(List partesModulosInstalacionEditarList) {
        this.partesModulosInstalacionEditarList = partesModulosInstalacionEditarList;
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
    
    public boolean isSwSi() {
        return swSi;
    }
    
    public void setSwSi(boolean swSi) {
        this.swSi = swSi;
    }
    
    public boolean isSwNo() {
        return swNo;
    }
    
    public void setSwNo(boolean swNo) {
        this.swNo = swNo;
    }
    
    public String getNombreModuloInstalacion() {
        return nombreModuloInstalacion;
    }
    
    public void setNombreModuloInstalacion(String nombreModuloInstalacion) {
        this.nombreModuloInstalacion = nombreModuloInstalacion;
    }
    
    
    
}
