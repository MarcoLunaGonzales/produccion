/*
 * ManagedEnvasesSecundarios.java
 *
 * Created on 18 de marzo de 2008, 17:30
 */

package com.cofar.web;

import com.cofar.bean.EnvasesSecundarios;
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
public class ManagedEnvasesSecundarios extends ManagedBean{
    
    /** Creates a new instance of ManagedPersonal */
    private List envasesSecundariosList=new ArrayList();
    private List envasesSecundariosEli=new ArrayList();
    private List envasesSecundariosEli2=new ArrayList();
    private EnvasesSecundarios envasesSecundarios=new EnvasesSecundarios();
    private Connection con;
    private List estadoRegistro=new  ArrayList();
    private boolean swElimina1;
    private boolean swElimina2;
    
    public ManagedEnvasesSecundarios() {
        cargarEnvasesSecundarios();
    }
    /**
     * -------------------------------------------------------------------------
     * ESTADO REGISTRO
     * -------------------------------------------------------------------------
     **/
    public void changeEvent(ValueChangeEvent event){
        //if(getCorte()==1){
        System.out.println("event:"+event.getNewValue());
        envasesSecundarios.getEstadoReferencial().setCodEstadoRegistro(event.getNewValue().toString());
        cargarEnvasesSecundarios();
        //}
    }
    public void cargarEstadoRegistro(String codigo,EnvasesSecundarios bean){
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
    public void cargarEnvasesSecundarios(){
        getEnvasesSecundariosList().clear();
        try {
            String sql="select ";
            sql+=" cod_envasesec,nombre_envasesec,obs_envasesec,cod_estado_registro";
            sql+=" from envases_secundarios";
            if(!envasesSecundarios.getEstadoReferencial().getCodEstadoRegistro().equals("") && !envasesSecundarios.getEstadoReferencial().getCodEstadoRegistro().equals("3")){
                sql+=" where cod_estado_registro="+envasesSecundarios.getEstadoReferencial().getCodEstadoRegistro();
            }
            con=Util.openConnection(con);
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(sql);
            String cod="";
            getEnvasesSecundariosList().clear();
            while (rs.next()){
                EnvasesSecundarios bean=new EnvasesSecundarios();
                bean.setCodEnvaseSec(rs.getString(1));
                bean.setNombreEnvaseSec(rs.getString(2));
                bean.setObsEnvaseSec(rs.getString(3));
                cod=rs.getString(4);
                cod=(cod==null)?"":cod;
                System.out.println("st xxx:"+st);
                cargarEstadoRegistro(cod,bean);
                getEnvasesSecundariosList().add(bean);
            }
            if(rs!=null){
                rs.close();st.close();
                rs=null;st=null;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
/*    public void cargarEstadoRegistro(String codigo,EnvasesSecundarios bean){
        try {
            setCon(Util.openConnection(getCon()));
            String sql="select cod_estado_registro,nombre_estado_registro from estados_referenciales where cod_estado_registro<>3";
            ResultSet rs=null;
            
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            if(!codigo.equals("")){
                sql+=" and cod_estado_registro="+codigo;
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
    }*/
    public void generarCodigo(){
        try {
            String  sql="select max(cod_envasesec)+1 from envases_secundarios";
            setCon(Util.openConnection(getCon()));
            Statement st=getCon().createStatement();
            ResultSet rs=st.executeQuery(sql);
            if(rs.next()){
                String cod=rs.getString(1);
                if(cod==null)
                    getEnvasesSecundarios().setCodEnvaseSec("1");
                else
                    getEnvasesSecundarios().setCodEnvaseSec(cod);
            }
            if(rs!=null){
                rs.close();
                st.close();
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public String actionSaveEnvasesSecundarios(){
        clear();
        generarCodigo();
        cargarEstadoRegistro("",null);
        return "actionSave";
    }
    public String saveEnvasesSecundarios(){
        try {
            
            String sql="insert into envases_secundarios(cod_envasesec,nombre_envasesec,obs_envasesec,cod_estado_registro)values(";
            sql+=""+envasesSecundarios.getCodEnvaseSec()+",";
            sql+="'"+envasesSecundarios.getNombreEnvaseSec()+"',";
            sql+="'"+envasesSecundarios.getObsEnvaseSec()+"',1)";
            System.out.println("sql:insert:"+sql);
            setCon(Util.openConnection(getCon()));
            PreparedStatement st=getCon().prepareStatement(sql);
            int result=st.executeUpdate();
            st.close();
            clear();
            if(result>0){
                
                cargarEnvasesSecundarios();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return "navegadorenvasessecundarios";
    }
    public void clear(){
        EnvasesSecundarios tm=new EnvasesSecundarios();
        setEnvasesSecundarios(tm);
    }
    
    public String actionEditEnvasesSecundarios(){
        cargarEstadoRegistro("",null);
        Iterator i=getEnvasesSecundariosList().iterator();
        while (i.hasNext()){
            EnvasesSecundarios bean=(EnvasesSecundarios)i.next();
            if(bean.getChecked().booleanValue()){
                setEnvasesSecundarios(bean);
                break;
            }
            
        }
        return "actionEdit";
    }
    public String actionCancelar(){
        clear();
        cargarEnvasesSecundarios();
        return "navegadorenvasessecundarios";
    }
    public String editEnvasesSecundarios(){
        try {
            String sql="update envases_secundarios set ";
            sql+="nombre_envasesec='"+envasesSecundarios.getNombreEnvaseSec()+"',";
            sql+="obs_envasesec='"+envasesSecundarios.getObsEnvaseSec()+"',";
            sql+="cod_estado_registro="+envasesSecundarios.getEstadoReferencial().getCodEstadoRegistro();
            sql+="where cod_envasesec="+envasesSecundarios.getCodEnvaseSec();
            System.out.println("sql:Update:"+sql);
            setCon(Util.openConnection(getCon()));
            PreparedStatement st=getCon().prepareStatement(sql);
            int result=st.executeUpdate();
            st.close();
            clear();
            if(result>0){
                cargarEnvasesSecundarios();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "navegadorenvasessecundarios";
    }
    public String actionDeleteEnvasesSecundarios(){
        setSwElimina2(false);
        setSwElimina1(false);
        getEnvasesSecundariosEli().clear();
        getEnvasesSecundariosEli2().clear();
        Iterator i=getEnvasesSecundariosList().iterator();
        while (i.hasNext()){
            EnvasesSecundarios bean=(EnvasesSecundarios)i.next();
            if(bean.getChecked().booleanValue()){
                try {
                    String sql="select cod_tipomercaderia from presentaciones_producto" +
                            " where cod_envasesec="+bean.getCodEnvaseSec();
                    setCon(Util.openConnection(getCon()));
                    Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet rs=st.executeQuery(sql);
                    rs.last();
                    if(rs.getRow()>0){
                        getEnvasesSecundariosEli2().add(bean);
                        setSwElimina2(true);
                    }else{
                        getEnvasesSecundariosEli().add(bean);
                        setSwElimina1(true);
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
        return "actionDelete";
    }
    public String deleteEnvasesSecundarios(){
        try {
            
            Iterator i=getEnvasesSecundariosEli().iterator();
            int result=0;
            while (i.hasNext()){
                EnvasesSecundarios bean=(EnvasesSecundarios)i.next();
                String sql="delete from envases_secundarios " +
                        "where cod_envasesec="+bean.getCodEnvaseSec();
                System.out.println("deletePersonal:sql:"+sql);
                setCon(Util.openConnection(getCon()));
                Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                result=result+st.executeUpdate(sql);
            }
            getEnvasesSecundariosEli().clear();
            getEnvasesSecundariosEli2().clear();
            if(result>0){
                cargarEnvasesSecundarios();
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "navegadorenvasessecundarios";
    }
    
    public List getEnvasesSecundariosList() {
        return envasesSecundariosList;
    }
    
    public void setEnvasesSecundariosList(List envasesSecundariosList) {
        this.envasesSecundariosList = envasesSecundariosList;
    }
    
    public List getEnvasesSecundariosEli() {
        return envasesSecundariosEli;
    }
    
    public void setEnvasesSecundariosEli(List envasesSecundariosEli) {
        this.envasesSecundariosEli = envasesSecundariosEli;
    }
    
    public List getEnvasesSecundariosEli2() {
        return envasesSecundariosEli2;
    }
    
    public void setEnvasesSecundariosEli2(List envasesSecundariosEli2) {
        this.envasesSecundariosEli2 = envasesSecundariosEli2;
    }
    
    public EnvasesSecundarios getEnvasesSecundarios() {
        return envasesSecundarios;
    }
    
    public void setEnvasesSecundarios(EnvasesSecundarios envasesSecundarios) {
        this.envasesSecundarios = envasesSecundarios;
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
    public String getCloseConnection() throws SQLException{
        if(con!=null){
            con.close();
        }
        return "";
    }
    
    
}
