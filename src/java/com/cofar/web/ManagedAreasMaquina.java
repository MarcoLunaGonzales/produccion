/*
 * ManagedTipoCliente.java
 * Created on 19 de febrero de 2008, 16:50
 */

package com.cofar.web;

import com.cofar.bean.AreasMaquina;
import com.cofar.bean.FormulaMaestraDetalleEP;
import com.cofar.bean.Materiales;
import com.cofar.util.Util;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import javax.faces.model.SelectItem;

/**
 *
 *  @author Wilmer Manzaneda Chavez
 *  @company COFAR
 */
public class ManagedAreasMaquina {
    
    /** Creates a new instance of ManagedTipoCliente */
    private AreasMaquina areasMaquinabean=new AreasMaquina();
    private List areasMaquinaList=new ArrayList();
    private List areasMaquinaAdicionarList=new ArrayList();
    private List areasMaquinaEliminarList=new ArrayList();
    private List areasMaquinaEditarList=new ArrayList();
    
    private Connection con;
    private String codigo="";
    
    private boolean swSi=false;
    private boolean swNo=false;
    private String nombreAreaFabricacion="";
    
    
    public ManagedAreasMaquina() {
        
    }
    public String getObtenerCodigo(){
        
        //String cod=Util.getParameter("codigo");
        String cod=Util.getParameter("codigo");
        
        System.out.println("cxxxxxxxxxxxxxxxxxxxxxxxod:"+cod);
        if(cod!=null){
            setCodigo(cod);
        }
        areasMaquinaList.clear();
        cargarAreasMaquina();
        cargarNombreAreaFabricacion();
        return "";
    }
    
    public String cargarNombreAreaFabricacion(){
        try {
            setCon(Util.openConnection(getCon()));
            String sql=" select nombre_area_empresa";
            sql+=" from areas_empresa";
            sql+=" where cod_area_empresa='"+getCodigo()+"'";
            System.out.println("sql:-----------:"+sql);
            PreparedStatement st=getCon().prepareStatement(sql);
            ResultSet rs=st.executeQuery();
            while (rs.next()){
                setNombreAreaFabricacion(rs.getString(1));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        System.out.println("nombreAreaFabricacion:"+nombreAreaFabricacion);
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
    
    public void cargarAreasMaquina(){
        try {
            
            System.out.println("codigo:"+getCodigo());
            String sql="select m.COD_MAQUINA,m.NOMBRE_MAQUINA,m.codigo from MAQUINARIA_AREA a , MAQUINARIAS m";
            sql+=" where a.COD_AREA_FABRICACION='"+codigo+"'  and a.cod_maquina=m.cod_maquina  order by m.NOMBRE_MAQUINA";
            System.out.println("sql>"+sql);
            setCon(Util.openConnection(getCon()));
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(sql);
            rs.last();
            int rows=rs.getRow();
            areasMaquinaList.clear();
            rs.first();
            for(int i=0;i<rows;i++){
                AreasMaquina bean=new AreasMaquina();
                bean.getMaquinaria().setCodMaquina(rs.getString(1));
                bean.getMaquinaria().setNombreMaquina(rs.getString(2));
                bean.getMaquinaria().setCodigo(rs.getString(3));
                areasMaquinaList.add(bean);
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
    public String actionAgregar(){
        System.out.println("entro4656532");
        cargarMaquinaria();
        return "actionAgregarAreasMaquina";
    }
    public String cargarMaquinaria(){
        
        try {
            System.out.println("entroooooooooooooooooooooooooooooooooo");
            areasMaquinaAdicionarList.clear();
            System.out.println("codigo:"+getCodigo());
            
            String sql="select m.COD_MAQUINA,m.NOMBRE_MAQUINA,m.codigo from MAQUINARIAS m" ;
            sql+=" where m.COD_ESTADO_REGISTRO=1 and m.COD_MAQUINA <> all  ";
            sql+=" (select ma.COD_MAQUINA from MAQUINARIA_AREA ma where ma.COD_AREA_FABRICACION='"+codigo+"')";
            sql+=" order by m.NOMBRE_MAQUINA";
            
            System.out.println("sql:"+sql);
            setCon(Util.openConnection(getCon()));
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(sql);
            rs.last();
            int rows=rs.getRow();
            rs.first();
            for(int i=0;i<rows;i++){
                AreasMaquina bean=new AreasMaquina();
                bean.getMaquinaria().setCodMaquina(rs.getString(1));
                bean.getMaquinaria().setNombreMaquina(rs.getString(2));
                bean.getMaquinaria().setCodigo(rs.getString(3));
                areasMaquinaAdicionarList.add(bean);
                rs.next();
            }
            if(rs!=null){
                rs.close();
                st.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "";
    }
    
    ////////////// Guardar ////////////////////////
    public String guardarAreasMaquina(){
        System.out.println("xxxxxxxxxxxxxxxx:"+getCodigo());
        //System.out.println("area_inferior:"+codigoAreaInferior);
        Iterator index=areasMaquinaAdicionarList.iterator();
        String sql="";
        int result=0;
        while (index.hasNext()){
            try {
                AreasMaquina bean=(AreasMaquina)index.next();
                if(bean.getChecked().booleanValue()){
                    setCon(Util.openConnection(getCon()));
                    sql="insert into MAQUINARIA_AREA(COD_AREA_FABRICACION,COD_MAQUINA)values(" ;
                    sql+="'"+getCodigo()+"','"+bean.getMaquinaria().getCodMaquina()+"')";
                    System.out.println("sql:"+sql);
                    PreparedStatement st1=getCon().prepareStatement(sql);
                    result=st1.executeUpdate();
                    System.out.println("result:"+result);
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        cargarAreasMaquina();
        return "navegadorAreasMaquina";
    }
    
    public String cancelar(){
        cargarAreasMaquina();
        return "navegadorAreasMaquina";
    }
    public String cancelar1(){
        
        return "cancelarEP";
    }
    public String eliminarAreasMaquina(){
        System.out.println("xxxxxxxxxxxxxxxx:"+getCodigo());
        Iterator index=areasMaquinaList.iterator();
        String sql="";
        int result=0;
        while (index.hasNext()){
            try {
                AreasMaquina bean=(AreasMaquina)index.next();
                if(bean.getChecked().booleanValue()){
                    //System.out.println("bean.getBonoDetalle().getMontoBono()--"+bean.getMontoBono());
                    setCon(Util.openConnection(getCon()));
                    sql="delete from MAQUINARIA_AREA where " ;
                    sql+="cod_maquina='"+bean.getMaquinaria().getCodMaquina()+"'" +
                            " and cod_area_fabricacion='"+getCodigo()+"'";
                    System.out.println("sql eliminar:"+sql);
                    PreparedStatement st=getCon().prepareStatement(sql);
                    result=st.executeUpdate();
                    
                    System.out.println("result:"+result);
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        if(result>0){
            cargarAreasMaquina();
            
        }
        
        return "navegadorAreasMaquina";
    }
   
/////////////////////////////////////////////////////////////
   
    /**
   * Metodo que cierra la conexion
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
    
    public AreasMaquina getAreasMaquinabean() {
        return areasMaquinabean;
    }
    
    public void setAreasMaquinabean(AreasMaquina areasMaquinabean) {
        this.areasMaquinabean = areasMaquinabean;
    }
    
    public List getAreasMaquinaList() {
        return areasMaquinaList;
    }
    
    public void setAreasMaquinaList(List areasMaquinaList) {
        this.areasMaquinaList = areasMaquinaList;
    }
    
    public List getAreasMaquinaAdicionarList() {
        return areasMaquinaAdicionarList;
    }
    
    public void setAreasMaquinaAdicionarList(List areasMaquinaAdicionarList) {
        this.areasMaquinaAdicionarList = areasMaquinaAdicionarList;
    }
    
    public List getAreasMaquinaEliminarList() {
        return areasMaquinaEliminarList;
    }
    
    public void setAreasMaquinaEliminarList(List areasMaquinaEliminarList) {
        this.areasMaquinaEliminarList = areasMaquinaEliminarList;
    }
    
    public List getAreasMaquinaEditarList() {
        return areasMaquinaEditarList;
    }
    
    public void setAreasMaquinaEditarList(List areasMaquinaEditarList) {
        this.areasMaquinaEditarList = areasMaquinaEditarList;
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
    
    public String getNombreAreaFabricacion() {
        return nombreAreaFabricacion;
    }
    
    public void setNombreAreaFabricacion(String nombreAreaFabricacion) {
        this.nombreAreaFabricacion = nombreAreaFabricacion;
    }
    
}
