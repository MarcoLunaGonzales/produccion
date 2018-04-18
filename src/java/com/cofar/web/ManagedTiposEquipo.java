/*
 * ManagedTiposMercaderia.java
 *
 * Created on 18 de marzo de 2008, 17:30
 */

package com.cofar.web;

import com.cofar.bean.TiposEquiposMaquinaria;

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

/**
 *
 * @author Osmar Hinojosa Miranda
 * @company COFAR
 */
public class ManagedTiposEquipo extends ManagedBean{
    
    /** Creates a new instance of ManagedPersonal */
    private List tiposEquipoList=new ArrayList();
    private List tiposEquipoEliminarList=new ArrayList();
    private List tiposEquipoNoEliminarList=new ArrayList();
    private TiposEquiposMaquinaria tiposEquipobean=new TiposEquiposMaquinaria();
    private Connection con;
    private List estadoRegistro=new  ArrayList();
    private boolean swElimina1;
    private boolean swElimina2;
    public ManagedTiposEquipo() {
        cargarTiposEquiposMaquinaria();
    }
    public void cargarTiposEquiposMaquinaria(){
        try {
            String sql="select";
            sql+=" te.cod_tipo_equipo,te.nombre_tipo_equipo,te.cod_estado_registro,er.nombre_estado_registro";
            sql+=" from tipos_equipos_maquinaria te,estados_referenciales er";
            sql+=" where er.cod_estado_registro=te.cod_estado_registro ";
            if(!getTiposEquipobean().getEstadoReferencial().getCodEstadoRegistro().equals("") && !getTiposEquipobean().getEstadoReferencial().getCodEstadoRegistro().equals("3")){
                sql+=" and  er.cod_estado_registro="+getTiposEquipobean().getEstadoReferencial().getCodEstadoRegistro();
            }
            
            System.out.println("cargarTiposEquiposMaquinaria:sql:"+sql);
            setCon(Util.openConnection(getCon()));
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(sql);
            String cod="";
            getTiposEquipoList().clear();
            while (rs.next()){
                TiposEquiposMaquinaria bean=new TiposEquiposMaquinaria();
                bean.setCodTipoEquipo(rs.getString(1));
                bean.setNombreTipoEquipo(rs.getString(2));
                bean.getEstadoReferencial().setCodEstadoRegistro(rs.getString(3));
                bean.getEstadoReferencial().setNombreEstadoRegistro(rs.getString(4));
                getTiposEquipoList().add(bean);
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
        getTiposEquipobean().getEstadoReferencial().setCodEstadoRegistro(event.getNewValue().toString());
        cargarTiposEquiposMaquinaria();
    }
    public void cargarEstadoRegistro(String codigo,TiposEquiposMaquinaria bean){
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
            String  sql="select max(cod_tipo_equipo)+1 from tipos_equipos_maquinaria";
            setCon(Util.openConnection(getCon()));
            Statement st=getCon().createStatement();
            ResultSet rs=st.executeQuery(sql);
            if(rs.next()){
                String cod=rs.getString(1);
                if(cod==null)
                    getTiposEquipobean().setCodTipoEquipo("1");
                else
                    getTiposEquipobean().setCodTipoEquipo(cod);
            }
            if(rs!=null){
                rs.close();
                st.close();
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public String actionSaveTipoEquipo(){
        clear();
        cargarEstadoRegistro("",null);
        return "actionSaveTiposEquiposMaquinaria";
    }
    public String actionCancelar(){
        clear();
        cargarTiposEquiposMaquinaria();
        return "navegadorTiposEquiposMaquinaria";
    }
    public String saveTipoEquipo(){
        try {
            generarCodigo();
            String sql="insert into tipos_equipos_maquinaria(cod_tipo_equipo,nombre_tipo_equipo,cod_estado_registro)values(";
            sql+=""+getTiposEquipobean().getCodTipoEquipo()+",";
            sql+="'"+getTiposEquipobean().getNombreTipoEquipo()+"'";
            sql+=",1)";
            System.out.println("sql:insert:"+sql);
            setCon(Util.openConnection(getCon()));
            PreparedStatement st=getCon().prepareStatement(sql);
            int result=st.executeUpdate();
            st.close();
            clear();
            if(result>0){
                
                cargarTiposEquiposMaquinaria();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return "navegadorTiposEquiposMaquinaria";
    }
    public void clear(){
        TiposEquiposMaquinaria tm=new TiposEquiposMaquinaria();
        setTiposEquipobean(tm);
    }
    
    public String actionEditTiposEquiposMaquinaria(){
        cargarEstadoRegistro("",null);
        Iterator i=getTiposEquipoList().iterator();
        while (i.hasNext()){
            TiposEquiposMaquinaria bean=(TiposEquiposMaquinaria)i.next();
            if(bean.getChecked().booleanValue()){
                setTiposEquipobean(bean);
                break;
            }
            
        }
        return "actionEditTiposEquiposMaquinaria";
    }
    public String editTipoEquipo(){
        try {
            String sql="update tipos_equipos_maquinaria set ";
            sql+="nombre_tipo_equipo='"+getTiposEquipobean().getNombreTipoEquipo()+"',";
            sql+="cod_estado_registro="+getTiposEquipobean().getEstadoReferencial().getCodEstadoRegistro();
            sql+="where cod_tipo_equipo="+getTiposEquipobean().getCodTipoEquipo();
            System.out.println("sql:Update:"+sql);
            setCon(Util.openConnection(getCon()));
            PreparedStatement st=getCon().prepareStatement(sql);
            int result=st.executeUpdate();
            st.close();
            clear();
            if(result>0){
                cargarTiposEquiposMaquinaria();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "navegadorTiposEquiposMaquinaria";
    }
    public String actionDeleteTipoEquipo(){
        setSwElimina2(false);
        setSwElimina1(false);
        getTiposEquipoEliminarList().clear();
        getTiposEquipoNoEliminarList().clear();
        int bandera=0;
        Iterator i=getTiposEquipoList().iterator();
        while (i.hasNext()){
            TiposEquiposMaquinaria bean=(TiposEquiposMaquinaria)i.next();
            if(bean.getChecked().booleanValue()){
                
                getTiposEquipoEliminarList().add(bean);
                setSwElimina1(true);
                System.out.println("entro  eliminarrrrrrrrrrrr");
            }
        }
        return "actionDeleteTiposEquiposMaquinaria";
    }
    public String deleteTipoEquipo(){
        try {
            
            Iterator i=getTiposEquipoEliminarList().iterator();
            int result=0;
            while (i.hasNext()){
                TiposEquiposMaquinaria bean=(TiposEquiposMaquinaria)i.next();
                String sql="delete from tipos_equipos_maquinaria " +
                        "where cod_tipo_equipo="+bean.getCodTipoEquipo();
                System.out.println("deletePersonal:sql:"+sql);
                setCon(Util.openConnection(getCon()));
                Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                result=result+st.executeUpdate(sql);
            }
            getTiposEquipoEliminarList().clear();
            getTiposEquipoNoEliminarList().clear();
            if(result>0){
                cargarTiposEquiposMaquinaria();
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "navegadorTiposEquiposMaquinaria";
    }
    /**************************************************************/

    public List getTiposEquipoList() {
        return tiposEquipoList;
    }

    public void setTiposEquipoList(List tiposEquipoList) {
        this.tiposEquipoList = tiposEquipoList;
    }

    public List getTiposEquipoEliminarList() {
        return tiposEquipoEliminarList;
    }

    public void setTiposEquipoEliminarList(List tiposEquipoEliminarList) {
        this.tiposEquipoEliminarList = tiposEquipoEliminarList;
    }

    public List getTiposEquipoNoEliminarList() {
        return tiposEquipoNoEliminarList;
    }

    public void setTiposEquipoNoEliminarList(List tiposEquipoNoEliminarList) {
        this.tiposEquipoNoEliminarList = tiposEquipoNoEliminarList;
    }

    public TiposEquiposMaquinaria getTiposEquipobean() {
        return tiposEquipobean;
    }

    public void setTiposEquipobean(TiposEquiposMaquinaria tiposEquipobean) {
        this.tiposEquipobean = tiposEquipobean;
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
