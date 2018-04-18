/*
 * ManagedEnvasesSecundarios.java
 *
 * Created on 18 de marzo de 2008, 17:30
 */

package com.cofar.web;

import com.cofar.bean.EnvasesSecundarios;
import com.cofar.bean.EnvasesTerciarios;
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

/**
 *
 * @author Osmar Hinojosa Miranda
 * @company COFAR
 */
public class ManagedEnvasesTerciarios extends ManagedBean{
    
    /** Creates a new instance of ManagedPersonal */
    private List envasesTerciariosList=new ArrayList();
    private List envasesTerciariosEliminar=new ArrayList();
    private List envasesTerciariosNoEliminar=new ArrayList();
    private EnvasesTerciarios envasesTerciariosbean=new EnvasesTerciarios();
    private Connection con;
    private List estadoRegistro=new  ArrayList();
    private boolean swEliminaSi;
    private boolean swEliminaNo;
    
    public ManagedEnvasesTerciarios() {
        cargarEnvasesTerciarios();
    }
    /**
     * -------------------------------------------------------------------------
     * ESTADO REGISTRO
     * -------------------------------------------------------------------------
     **/
    public void changeEvent(ValueChangeEvent event){
        //if(getCorte()==1){
        System.out.println("event:"+event.getNewValue());
        envasesTerciariosbean.getEstadoReferencial().setCodEstadoRegistro(event.getNewValue().toString());
        cargarEnvasesTerciarios();
        //}
    }
    public void cargarEstadoRegistro(String codigo,EnvasesTerciarios bean){
        try {
            setCon(Util.openConnection(getCon()));
            String sql="select cod_estado_registro,nombre_estado_registro from estados_referenciales where cod_estado_registro<>3";
            ResultSet rs=null;
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            if(!codigo.equals("")){
                sql+=" and cod_estado_registro="+codigo;
                System.out.println("sql"+sql);
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
    public void cargarEnvasesTerciarios(){
        envasesTerciariosList.clear();
        try {
            String sql="select ";
            sql+=" cod_envaseterciario,nombre_envaseterciario,obs_envaseterciario,cod_estado_registro";
            sql+=" from envases_terciarios";
            if(!envasesTerciariosbean.getEstadoReferencial().getCodEstadoRegistro().equals("") && !envasesTerciariosbean.getEstadoReferencial().getCodEstadoRegistro().equals("3")){
                sql+=" where cod_estado_registro="+envasesTerciariosbean.getEstadoReferencial().getCodEstadoRegistro();
            }
            sql+=" order by nombre_envaseterciario";
            System.out.println("select:"+sql);
            setCon(Util.openConnection(getCon()));
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(sql);
            String cod="";
            envasesTerciariosList.clear();
            while (rs.next()){
                EnvasesTerciarios bean=new EnvasesTerciarios();
                bean.setCodEnvaseTerciario(rs.getString(1));
                bean.setNombreEnvaseTerciario(rs.getString(2));
                bean.setObsEnvaseTerciario(rs.getString(3));
                cod=rs.getString(4);
                cod=(cod==null)?"":cod;
                System.out.println("st xxx:"+st);
                cargarEstadoRegistro(cod,bean);
                envasesTerciariosList.add(bean);
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
            String  sql="select max(cod_envaseterciario)+1 from envases_terciarios";
            setCon(Util.openConnection(getCon()));
            Statement st=getCon().createStatement();
            ResultSet rs=st.executeQuery(sql);
            if(rs.next()){
                String cod=rs.getString(1);
                if(cod==null)
                    getEnvasesTerciariosbean().setCodEnvaseTerciario("1");
                else
                    getEnvasesTerciariosbean().setCodEnvaseTerciario(cod);
            }
            if(rs!=null){
                rs.close();
                st.close();
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public String actionSaveEnvasesTerciarios(){
        clear();
        generarCodigo();
        cargarEstadoRegistro("",null);
        return "actionSaveEnvasesTerciarios";
    }
    public String saveEnvasesTerciarios(){
        try {
            
            String sql="insert into envases_terciarios(cod_envaseterciario,nombre_envaseterciario,obs_envaseterciario,cod_estado_registro)values(";
            sql+=""+envasesTerciariosbean.getCodEnvaseTerciario()+",";
            sql+="'"+envasesTerciariosbean.getNombreEnvaseTerciario()+"',";
            sql+="'"+envasesTerciariosbean.getObsEnvaseTerciario()+"',1)";
            System.out.println("sql:insert:"+sql);
            setCon(Util.openConnection(getCon()));
            PreparedStatement st=getCon().prepareStatement(sql);
            int result=st.executeUpdate();
            st.close();
            clear();
            if(result>0){
                
                cargarEnvasesTerciarios();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return "navegadorEnvasesTerciarios";
    }
    public void clear(){
        EnvasesTerciarios tm=new EnvasesTerciarios();
        setEnvasesTerciariosbean(tm);
    }
    
    public String actionEditEnvasesTerciarios(){
        cargarEstadoRegistro("",null);
        Iterator i=getEnvasesTerciariosList().iterator();
        while (i.hasNext()){
            EnvasesTerciarios bean=(EnvasesTerciarios)i.next();
            if(bean.getChecked().booleanValue()){
                setEnvasesTerciariosbean(bean);
                break;
            }
            
        }
        return "actionEditEnvasesTerciarios";
    }
    public String actionCancelar(){
        clear();
        cargarEnvasesTerciarios();
        return "navegadorEnvasesTerciarios";
    }
    public String editEnvasesTerciarios(){
        try {
            String sql="update envases_terciarios set ";
            sql+="nombre_envaseterciario='"+envasesTerciariosbean.getNombreEnvaseTerciario()+"',";
            sql+="obs_envaseterciario='"+envasesTerciariosbean.getObsEnvaseTerciario()+"',";
            sql+="cod_estado_registro="+envasesTerciariosbean.getEstadoReferencial().getCodEstadoRegistro();
            sql+="where cod_envaseterciario="+envasesTerciariosbean.getCodEnvaseTerciario();
            System.out.println("sql:Update:"+sql);
            setCon(Util.openConnection(getCon()));
            PreparedStatement st=getCon().prepareStatement(sql);
            int result=st.executeUpdate();
            st.close();
            clear();
            if(result>0){
                cargarEnvasesTerciarios();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "navegadorEnvasesTerciarios";
    }
    
    public String Cancelar(){
        return"navegadorEnvasesTerciarios";
    }
    public String actionDeleteEnvasesTerciarios(){
        setSwEliminaNo(false);
        setSwEliminaSi(false);
        getEnvasesTerciariosEliminar().clear();
        getEnvasesTerciariosNoEliminar().clear();
        int bandera=0;
        Iterator i=getEnvasesTerciariosList().iterator();
        while (i.hasNext()){
            EnvasesTerciarios bean=(EnvasesTerciarios)i.next();
            if(bean.getChecked().booleanValue()){
                try {
                    String sql="select cod_envaseterciario from presentaciones_producto" +
                            " where cod_envaseterciario="+bean.getCodEnvaseTerciario();
                    System.out.println("ActionDelete:"+sql);
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
                        envasesTerciariosEliminar.add(bean);
                        setSwEliminaSi(true);
                        System.out.println("entro  eliminarrrrrrrrrrrr");
                    }else{
                        envasesTerciariosNoEliminar.add(bean);
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
        return "actionDeleteEnvasesTerciarios";
    }
    public String deleteEnvasesTerciarios(){
        try {
            
            Iterator i=getEnvasesTerciariosEliminar().iterator();
            int result=0;
            while (i.hasNext()){
                EnvasesTerciarios bean=(EnvasesTerciarios)i.next();
                String sql="delete from envases_terciarios " +
                        "where cod_envaseterciario="+bean.getCodEnvaseTerciario();
                System.out.println("deletePersonal:sql:"+sql);
                setCon(Util.openConnection(getCon()));
                Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                result=result+st.executeUpdate(sql);
            }
            getEnvasesTerciariosEliminar().clear();
            getEnvasesTerciariosNoEliminar().clear();
            if(result>0){
                cargarEnvasesTerciarios();
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "navegadorEnvasesTerciarios";
    }
    public String getCloseConnection() throws SQLException{
        if(getCon()!=null){
            getCon().close();
        }
        return "";
    }
    ///////////Clases /////////////
    
    public List getEnvasesTerciariosList() {
        return envasesTerciariosList;
    }
    
    public void setEnvasesTerciariosList(List envasesTerciariosList) {
        this.envasesTerciariosList = envasesTerciariosList;
    }
    
    public List getEnvasesTerciariosEliminar() {
        return envasesTerciariosEliminar;
    }
    
    public void setEnvasesTerciariosEliminar(List envasesTerciariosEliminar) {
        this.envasesTerciariosEliminar = envasesTerciariosEliminar;
    }
    
    public List getEnvasesTerciariosNoEliminar() {
        return envasesTerciariosNoEliminar;
    }
    
    public void setEnvasesTerciariosNoEliminar(List envasesTerciariosNoEliminar) {
        this.envasesTerciariosNoEliminar = envasesTerciariosNoEliminar;
    }
    
    public EnvasesTerciarios getEnvasesTerciariosbean() {
        return envasesTerciariosbean;
    }
    
    public void setEnvasesTerciariosbean(EnvasesTerciarios envasesTerciariosbean) {
        this.envasesTerciariosbean = envasesTerciariosbean;
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
