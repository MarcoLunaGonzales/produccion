/*
 * ManagedCartonesCorrugados.java
 * Created on 25 de Junio de 2008, 10:50
 */

package com.cofar.web;


import com.cofar.bean.ActividadesProduccion;
import com.cofar.bean.CartonesCorrugados;
import com.cofar.bean.ParosInesperadosProd;
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
public class ManagedParosInesperadosProd{
    
    private ParosInesperadosProd parosInesperadosProdbean=new ParosInesperadosProd();
    private List parosInesperadosProdList=new ArrayList();
    private List estadoRegistro=new ArrayList();
    private List parosInesperadosProdEliminar=new ArrayList();
    private List parosInesperadosProdNoEliminar=new ArrayList();
    private Connection con;
    private boolean swEliminaSi;
    private boolean swEliminaNo;
    
    
    public ManagedParosInesperadosProd() {
        cargarParosInesperados();
    }
    /**
     * metodo que genera los codigos
     * correlativamente
     */
    public String getCodigoParosInesperados(){
        String codigo="1";
        try {
            setCon(Util.openConnection(getCon()));
            String sql="select max(cod_paro)+1 from paros_inesperados";
            PreparedStatement st=getCon().prepareStatement(sql);
            System.out.println("sql:MAX:"+sql);
            ResultSet rs=st.executeQuery();
            while (rs.next())
                codigo=rs.getString(1);
            if(codigo==null)
                codigo="1";
            
            parosInesperadosProdbean.setCodParo(codigo);
            System.out.println("coiogogo:"+codigo);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return  "";
    }
    
    public void cargarEstadoRegistro(String codigo,ParosInesperadosProd bean){
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
    public void cargarParosInesperados(){
        try {
            String sql="select cod_paro,nombre_paro,obs_paro,cod_estado_registro" +
                    " from paros_inesperados";
            if(!parosInesperadosProdbean.getEstadoReferencial().getCodEstadoRegistro().equals("") && !parosInesperadosProdbean.getEstadoReferencial().getCodEstadoRegistro().equals("3")){
                sql+=" where cod_estado_registro="+parosInesperadosProdbean.getEstadoReferencial().getCodEstadoRegistro();
            }
            sql+=" order by nombre_paro asc";
            System.out.println("cargar:"+sql);
            setCon(Util.openConnection(getCon()));
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(sql);
            rs.last();
            int rows=rs.getRow();
            parosInesperadosProdList.clear();
            rs.first();
            String cod="";
            for(int i=0;i<rows;i++){
                ParosInesperadosProd bean=new ParosInesperadosProd();
                bean.setCodParo(rs.getString(1));
                bean.setNombreParo(rs.getString(2));
                bean.setObsParo(rs.getString(3));
                cod=rs.getString(4);
                cod=(cod==null)?"":cod;
                System.out.println("st xxx:"+cod);
                cargarEstadoRegistro(cod,bean);
                parosInesperadosProdList.add(bean);
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
        clearParosInesperados();
        return"actionAgregarParoInesperado";
    }
    
    
    public String actionEditar(){
        cargarEstadoRegistro("",null);
        Iterator i=parosInesperadosProdList.iterator();
        while (i.hasNext()){
            ParosInesperadosProd bean=(ParosInesperadosProd)i.next();
            if(bean.getChecked().booleanValue()){
                parosInesperadosProdbean=bean;
                break;
            }
            
        }
        return "actionEditarParoInesperado";
    }
    
    
    public String actionEliminar(){
        setSwEliminaSi(false);
        setSwEliminaNo(false);
        parosInesperadosProdEliminar.clear();
        parosInesperadosProdNoEliminar.clear();
        int bandera=0;
        Iterator i=parosInesperadosProdList.iterator();
        while (i.hasNext()){
            ParosInesperadosProd bean=(ParosInesperadosProd)i.next();
            if(bean.getChecked().booleanValue()){
                parosInesperadosProdEliminar.add(bean);
                setSwEliminaSi(true);
            }
        }
        return "actionEliminarParoInesperado";
    }
    
    public void clearParosInesperados(){
        parosInesperadosProdbean.setCodParo("");
        parosInesperadosProdbean.setNombreParo("");
        parosInesperadosProdbean.setObsParo("");
    }
    
    public String guardarParosInesperados(){
        try {
            String sql="insert into paros_inesperados(cod_paro,nombre_paro,obs_paro,cod_estado_registro)values(";
            sql+="'"+parosInesperadosProdbean.getCodParo()+"',";
            sql+="'"+parosInesperadosProdbean.getNombreParo().toUpperCase()+"',";
            sql+="'"+parosInesperadosProdbean.getObsParo()+"',1)";
            System.out.println("inset:"+sql);
            setCon(Util.openConnection(getCon()));
            PreparedStatement st=getCon().prepareStatement(sql);
            int result=st.executeUpdate();
            if(result>0){
                cargarParosInesperados();
                clearParosInesperados();
            }
            System.out.println("result:"+result);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return "navegadorParoInesperado";
    }
    public String modificarParoInesperado(){
        try {
            setCon(Util.openConnection(getCon()));
            String  sql="update paros_inesperados set";
            sql+=" nombre_paro='"+parosInesperadosProdbean.getNombreParo().toUpperCase()+"',";
            sql+=" obs_paro='"+parosInesperadosProdbean.getObsParo()+"',";
            sql+=" cod_estado_registro='"+parosInesperadosProdbean.getEstadoReferencial().getCodEstadoRegistro()+"'";
            sql+=" where cod_paro="+parosInesperadosProdbean.getCodParo();
            System.out.println("modifi:"+sql);
            PreparedStatement st=getCon().prepareStatement(sql);
            int result=st.executeUpdate();
            if(result>0){
                cargarParosInesperados();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return "navegadorParoInesperado";
    }
    public String eliminarParosinesperados(){
        try {
            
            Iterator i=parosInesperadosProdEliminar.iterator();
            int result=0;
            while (i.hasNext()){
                ParosInesperadosProd bean=(ParosInesperadosProd)i.next();
                String sql="delete from paros_inesperados  ";
                sql+=" where cod_paro="+bean.getCodParo();;
                System.out.println("deleteParo:sql:"+sql);
                setCon(Util.openConnection(getCon()));
                Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                result=result+st.executeUpdate(sql);
            }
            parosInesperadosProdEliminar.clear();
            parosInesperadosProdNoEliminar.clear();
            if(result>0){
                cargarParosInesperados();
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "navegadorParoInesperado";
    }
    public String Cancelar(){
        parosInesperadosProdList.clear();
        cargarParosInesperados();
        return "navegadorParoInesperado";
    }
    
    
    /**********ESTADO REGISTRO****************/
    public void changeEvent(ValueChangeEvent event){
        System.out.println("event:"+event.getNewValue());
        parosInesperadosProdbean.getEstadoReferencial().setCodEstadoRegistro(event.getNewValue().toString());
        cargarParosInesperados();
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

    public ParosInesperadosProd getParosInesperadosProdbean() {
        return parosInesperadosProdbean;
    }

    public void setParosInesperadosProdbean(ParosInesperadosProd parosInesperadosProdbean) {
        this.parosInesperadosProdbean = parosInesperadosProdbean;
    }

    public List getParosInesperadosProdList() {
        return parosInesperadosProdList;
    }

    public void setParosInesperadosProdList(List parosInesperadosProdList) {
        this.parosInesperadosProdList = parosInesperadosProdList;
    }

    public List getEstadoRegistro() {
        return estadoRegistro;
    }

    public void setEstadoRegistro(List estadoRegistro) {
        this.estadoRegistro = estadoRegistro;
    }

    public List getParosInesperadosProdEliminar() {
        return parosInesperadosProdEliminar;
    }

    public void setParosInesperadosProdEliminar(List parosInesperadosProdEliminar) {
        this.parosInesperadosProdEliminar = parosInesperadosProdEliminar;
    }

    public List getParosInesperadosProdNoEliminar() {
        return parosInesperadosProdNoEliminar;
    }

    public void setParosInesperadosProdNoEliminar(List parosInesperadosProdNoEliminar) {
        this.parosInesperadosProdNoEliminar = parosInesperadosProdNoEliminar;
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
