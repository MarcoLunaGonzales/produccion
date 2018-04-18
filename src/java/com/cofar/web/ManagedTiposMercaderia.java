/*
 * ManagedTiposMercaderia.java
 *
 * Created on 18 de marzo de 2008, 17:30
 */

package com.cofar.web;

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
public class ManagedTiposMercaderia extends ManagedBean{
    
    /** Creates a new instance of ManagedPersonal */
    private List tiposMercaderiaList=new ArrayList();
    private List tiposMercaderiaEli=new ArrayList();
    private List tiposMercaderiaEli2=new ArrayList();
    private TiposMercaderia tiposMercaderia=new TiposMercaderia();
    private Connection con;
    private List estadoRegistro=new  ArrayList();
    private boolean swElimina1;
    private boolean swElimina2;
    public ManagedTiposMercaderia() {
        cargarTiposMercaderia();
    }
    public void cargarTiposMercaderia(){
        try {
            String sql="select";
            sql+=" cod_tipomercaderia,nombre_tipomercaderia,obs_tipomercaderia,cod_estado_registro";
            sql+=" from tipos_mercaderia";
            if(!tiposMercaderia.getEstadoReferencial().getCodEstadoRegistro().equals("") && !tiposMercaderia.getEstadoReferencial().getCodEstadoRegistro().equals("3")){
                sql+=" where cod_estado_registro="+tiposMercaderia.getEstadoReferencial().getCodEstadoRegistro();
            }
            System.out.println("cargarPersonal:sql:"+sql);
            setCon(Util.openConnection(getCon()));
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(sql);
            String cod="";
            getTiposMercaderiaList().clear();
            while (rs.next()){
                TiposMercaderia bean=new TiposMercaderia();
                bean.setCodTipoMercaderia(rs.getString(1));
                bean.setNombreTipoMercaderia(rs.getString(2));
                bean.setObsTipoMercaderia(rs.getString(3));
                cod=rs.getString(4);
                cod=(cod==null)?"":cod;
                System.out.println("st xxx:"+st);
                cargarEstadoRegistro(cod,bean);
                //    bean.setCargos(getPersonal().getCargos());
                getTiposMercaderiaList().add(bean);
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
        tiposMercaderia.getEstadoReferencial().setCodEstadoRegistro(event.getNewValue().toString());
        cargarTiposMercaderia();
    }
    public void cargarEstadoRegistro(String codigo,TiposMercaderia bean){
        try {
            con=Util.openConnection(getCon());
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
    }
    public void generarCodigo(){
        try {
            String  sql="select max(cod_tipomercaderia)+1 from tipos_mercaderia";
            setCon(Util.openConnection(getCon()));
            Statement st=getCon().createStatement();
            ResultSet rs=st.executeQuery(sql);
            if(rs.next()){
                String cod=rs.getString(1);
                if(cod==null)
                    getTiposMercaderia().setCodTipoMercaderia("1");
                else
                    getTiposMercaderia().setCodTipoMercaderia(cod);
            }
            if(rs!=null){
                rs.close();
                st.close();
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public String actionSaveTipoMercaderia(){
        clear();
        generarCodigo();
        cargarEstadoRegistro("",null);
        return "actionSave";
    }
    public String actionCancelar(){
        clear();
        cargarTiposMercaderia();
        return "navegadortiposmercaderia";
    }
    public String saveTipoMercaderia(){
        try {
            
            String sql="insert into tipos_mercaderia(cod_tipomercaderia,nombre_tipomercaderia,obs_tipomercaderia,cod_estado_registro)values(";
            sql+=""+tiposMercaderia.getCodTipoMercaderia()+",";
            sql+="'"+tiposMercaderia.getNombreTipoMercaderia()+"',";
            sql+="'"+tiposMercaderia.getObsTipoMercaderia()+"',1)";
            System.out.println("sql:insert:"+sql);
            setCon(Util.openConnection(getCon()));
            PreparedStatement st=getCon().prepareStatement(sql);
            int result=st.executeUpdate();
            st.close();
            clear();
            if(result>0){
                
                cargarTiposMercaderia();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return "navegadortiposmercaderia";
    }
    public void clear(){
        TiposMercaderia tm=new TiposMercaderia();
        setTiposMercaderia(tm);
    }
    
    public String actionEditTipoMercaderia(){
        cargarEstadoRegistro("",null);
        Iterator i=getTiposMercaderiaList().iterator();
        while (i.hasNext()){
            TiposMercaderia bean=(TiposMercaderia)i.next();
            if(bean.getChecked().booleanValue()){
                setTiposMercaderia(bean);
                break;
            }
            
        }
        return "actionEdit";
    }
    public String editTipoMercaderia(){
        try {
            String sql="update tipos_mercaderia set ";
            sql+="nombre_tipomercaderia='"+tiposMercaderia.getNombreTipoMercaderia()+"',";
            sql+="obs_tipomercaderia='"+tiposMercaderia.getObsTipoMercaderia()+"',";
            sql+="cod_estado_registro="+tiposMercaderia.getEstadoReferencial().getCodEstadoRegistro();
            sql+="where cod_tipomercaderia="+tiposMercaderia.getCodTipoMercaderia();
            System.out.println("sql:Update:"+sql);
            setCon(Util.openConnection(getCon()));
            PreparedStatement st=getCon().prepareStatement(sql);
            int result=st.executeUpdate();
            st.close();
            clear();
            if(result>0){
                cargarTiposMercaderia();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "navegadortiposmercaderia";
    }
    public String actionDeleteTipoMercaderia(){
        setSwElimina2(false);
        setSwElimina1(false);
        getTiposMercaderiaEli().clear();
        getTiposMercaderiaEli2().clear();
        int bandera=0;
        Iterator i=getTiposMercaderiaList().iterator();
        while (i.hasNext()){
            TiposMercaderia bean=(TiposMercaderia)i.next();
            if(bean.getChecked().booleanValue()){
                try {
                    String sql="select cod_tipomercaderia from mat_promocional " +
                            " where cod_tipomercaderia="+bean.getCodTipoMercaderia();
                    setCon(Util.openConnection(getCon()));
                    Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet rs=st.executeQuery(sql);
                    rs.last();
                    if(rs.getRow()==0){
                        bandera=1;
                    }
                    if(bandera==1){
                        sql="select cod_tipomercaderia from presentaciones_producto " +
                                " where cod_tipomercaderia="+bean.getCodTipoMercaderia();
                        setCon(Util.openConnection(getCon()));
                        st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                        rs=st.executeQuery(sql);
                        rs.last();
                        if (rs.getRow()==0){
                            bandera=1;
                        } else{
                            bandera=0;
                        }
                    }
                    if (bandera==1){
                        tiposMercaderiaEli.add(bean);
                        setSwElimina1(true);
                        System.out.println("entro  eliminarrrrrrrrrrrr");
                    }else{
                        tiposMercaderiaEli2.add(bean);
                        setSwElimina2(true);
                        System.out.println("entrooooooooo   nooo eliminar");
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
    public String deleteTipoMercaderia(){
        try {
            
            Iterator i=getTiposMercaderiaEli().iterator();
            int result=0;
            while (i.hasNext()){
                TiposMercaderia bean=(TiposMercaderia)i.next();
                String sql="delete from tipos_mercaderia " +
                        "where cod_tipomercaderia="+bean.getCodTipoMercaderia();
                System.out.println("deletePersonal:sql:"+sql);
                setCon(Util.openConnection(getCon()));
                Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                result=result+st.executeUpdate(sql);
            }
            getTiposMercaderiaEli().clear();
            getTiposMercaderiaEli2().clear();
            if(result>0){
                cargarTiposMercaderia();
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "navegadortiposmercaderia";
    }
    
    public List getTiposMercaderiaList() {
        return tiposMercaderiaList;
    }
    
    public void setTiposMercaderiaList(List tiposMercaderiaList) {
        this.tiposMercaderiaList = tiposMercaderiaList;
    }
    
    public List getTiposMercaderiaEli() {
        return tiposMercaderiaEli;
    }
    
    public void setTiposMercaderiaEli(List tiposMercaderiaEli) {
        this.tiposMercaderiaEli = tiposMercaderiaEli;
    }
    
    public TiposMercaderia getTiposMercaderia() {
        return tiposMercaderia;
    }
    
    public void setTiposMercaderia(TiposMercaderia tiposMercaderia) {
        this.tiposMercaderia = tiposMercaderia;
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
    
    public List getTiposMercaderiaEli2() {
        return tiposMercaderiaEli2;
    }
    
    public void setTiposMercaderiaEli2(List tiposMercaderiaEli2) {
        this.tiposMercaderiaEli2 = tiposMercaderiaEli2;
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
