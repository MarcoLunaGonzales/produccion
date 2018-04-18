/*
 * ManagedTipoCliente.java
 * Created on 19 de febrero de 2008, 16:50
 */

package com.cofar.web;

import com.cofar.bean.AccionesTerapeuticas;
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
public class ManagedAccionesTerapeuticas{
    
    /** Creates a new instance of ManagedTipoCliente */
    private AccionesTerapeuticas accionesTerapeuticasbean=new AccionesTerapeuticas();
    private List accionesTerapeuticas=new ArrayList();
    private List estadoRegistro=new ArrayList();
    private List accionesTerapeuticasEliminar=new ArrayList();
    private List accionesTerapeuticasNoEliminar=new ArrayList();
    private Connection con;
    private boolean swEliminaSi;
    private boolean swEliminaNo;
    
    
    public ManagedAccionesTerapeuticas() {
        cargarAccionesTerapeuticas();
    }
    /**
     * metodo que genera los codigos
     * correlativamente
     */
    public String getCodigoAccionTerapeutica(){
        String codigo="1";
        try {
            setCon(Util.openConnection(getCon()));
            String sql="select max(cod_accion_terapeutica)+1 from acciones_terapeuticas";
            PreparedStatement st=getCon().prepareStatement(sql);
            System.out.println("sql:MAX:"+sql);
            ResultSet rs=st.executeQuery();
            while (rs.next())
                codigo=rs.getString(1);
            if(codigo==null)
                codigo="1";
            
            accionesTerapeuticasbean.setCodAccionTerapeutica(codigo);
            System.out.println("coiogogo:"+codigo);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return  "";
    }
    
    public void cargarEstadoRegistro(String codigo,AccionesTerapeuticas bean){
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
    public void cargarAccionesTerapeuticas(){
        try {
            String sql="select cod_accion_terapeutica,nombre_accion_terapeutica,obs_accion_terapeutica,cod_estado_registro" +
                    " from acciones_terapeuticas";
            if(!accionesTerapeuticasbean.getEstadoReferencial().getCodEstadoRegistro().equals("") && !accionesTerapeuticasbean.getEstadoReferencial().getCodEstadoRegistro().equals("3")){
                sql+=" where cod_estado_registro="+accionesTerapeuticasbean.getEstadoReferencial().getCodEstadoRegistro();
            }
            sql+=" order by nombre_accion_terapeutica asc";
            System.out.println("cargar:"+sql);
            setCon(Util.openConnection(getCon()));
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(sql);
            rs.last();
            int rows=rs.getRow();
            accionesTerapeuticas.clear();
            rs.first();
            String cod="";
            for(int i=0;i<rows;i++){
                AccionesTerapeuticas bean=new AccionesTerapeuticas();
                bean.setCodAccionTerapeutica(rs.getString(1));
                bean.setNombreAccionTerapeutica(rs.getString(2));
                bean.setObsAccionTerapeutica(rs.getString(3));
                //bean.setCodEstadoRegistro(rs.getString(7));
                cod=rs.getString(4);
                cod=(cod==null)?"":cod;
                System.out.println("st xxx:"+cod);
                cargarEstadoRegistro(cod,bean);
                accionesTerapeuticas.add(bean);
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
        clearAccionesTerapeuticas();
        return"actionAgregarAccionesTerapeuticas";
    }
    
    
    public String actionEditar(){
        cargarEstadoRegistro("",null);
        Iterator i=accionesTerapeuticas.iterator();
        while (i.hasNext()){
            AccionesTerapeuticas bean=(AccionesTerapeuticas)i.next();
            if(bean.getChecked().booleanValue()){
                accionesTerapeuticasbean=bean;
                break;
            }
            
        }
        return "actionEditarAccionesTerapeuticas";
    }
    
    
    public String actionEliminar(){
        setSwEliminaSi(false);
        setSwEliminaNo(false);
        accionesTerapeuticasEliminar.clear();
        accionesTerapeuticasNoEliminar.clear();
        int bandera=0;
        Iterator i=accionesTerapeuticas.iterator();
        while (i.hasNext()){
            AccionesTerapeuticas bean=(AccionesTerapeuticas)i.next();
            if(bean.getChecked().booleanValue()){
                try {
                    String sql="select cod_accion_terapeutica from acciones_terapeuticas_producto" +
                            " where cod_accion_terapeutica="+bean.getCodAccionTerapeutica();
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
                        accionesTerapeuticasEliminar.add(bean);
                        setSwEliminaSi(true);
                        System.out.println("entro  eliminarrrrrrrrrrrr");
                    }else{
                        accionesTerapeuticasNoEliminar.add(bean);
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
        return "ActionEliminarAccionesTerapeuticas";
    }
    
    public void clearAccionesTerapeuticas(){
        accionesTerapeuticasbean.setCodAccionTerapeutica("");
        accionesTerapeuticasbean.setNombreAccionTerapeutica("");
        accionesTerapeuticasbean.setObsAccionTerapeutica("");
        
    }
    
    public String guardarAccionesTerapeuticas(){
        try {
            String sql="insert into acciones_terapeuticas(cod_accion_terapeutica,nombre_accion_terapeutica," +
                    "obs_accion_terapeutica,cod_estado_registro)values(";
            sql+="'"+accionesTerapeuticasbean.getCodAccionTerapeutica()+"','"+accionesTerapeuticasbean.getNombreAccionTerapeutica().toUpperCase()+"',"+
                    "'"+accionesTerapeuticasbean.getObsAccionTerapeutica()+"',1)";
            System.out.println("inset:"+sql);
            setCon(Util.openConnection(getCon()));
            PreparedStatement st=getCon().prepareStatement(sql);
            int result=st.executeUpdate();
            if(result>0){
                cargarAccionesTerapeuticas();
                clearAccionesTerapeuticas();
            }
            System.out.println("result:"+result);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return "navegadorAccionesTerapeuticas";
    }
    public String modificarAccionesTerapeuticas(){
        try {
            setCon(Util.openConnection(getCon()));
            String  sql="update acciones_terapeuticas set";
            sql+=" nombre_accion_terapeutica='"+accionesTerapeuticasbean.getNombreAccionTerapeutica().toUpperCase()+"',";
            sql+=" obs_accion_terapeutica='"+accionesTerapeuticasbean.getObsAccionTerapeutica()+"',";
            sql+=" cod_estado_registro='"+accionesTerapeuticasbean.getEstadoReferencial().getCodEstadoRegistro()+"'";
            sql+=" where cod_accion_terapeutica="+accionesTerapeuticasbean.getCodAccionTerapeutica();
            System.out.println("modifi:"+sql);
            PreparedStatement st=getCon().prepareStatement(sql);
            int result=st.executeUpdate();
            if(result>0){
                cargarAccionesTerapeuticas();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return "navegadorAccionesTerapeuticas";
    }
    public String eliminarPrincipiosActivos(){
        try {
            
            Iterator i=accionesTerapeuticasEliminar.iterator();
            int result=0;
            while (i.hasNext()){
                AccionesTerapeuticas bean=(AccionesTerapeuticas)i.next();
                String sql="delete from acciones_terapeuticas  ";
                sql+=" where cod_accion_terapeutica="+bean.getCodAccionTerapeutica();;
                
                System.out.println("deleteAcciones:sql:"+sql);
                setCon(Util.openConnection(getCon()));
                Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                result=result+st.executeUpdate(sql);
            }
            accionesTerapeuticasNoEliminar.clear();
            accionesTerapeuticasEliminar.clear();
            if(result>0){
                cargarAccionesTerapeuticas();
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "navegadorAccionesTerapeuticas";
    }
    public String Cancelar(){
        accionesTerapeuticas.clear();
        cargarAccionesTerapeuticas();
        return "navegadorAccionesTerapeuticas";
    }
    
    
    /**********ESTADO REGISTRO****************/
    public void changeEvent(ValueChangeEvent event){
        System.out.println("event:"+event.getNewValue());
        accionesTerapeuticasbean.getEstadoReferencial().setCodEstadoRegistro(event.getNewValue().toString());
        cargarAccionesTerapeuticas();
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
    
    public AccionesTerapeuticas getAccionesTerapeuticasbean() {
        return accionesTerapeuticasbean;
    }
    
    public void setAccionesTerapeuticasbean(AccionesTerapeuticas accionesTerapeuticasbean) {
        this.accionesTerapeuticasbean = accionesTerapeuticasbean;
    }
    
    public List getAccionesTerapeuticas() {
        return accionesTerapeuticas;
    }
    
    public void setAccionesTerapeuticas(List accionesTerapeuticas) {
        this.accionesTerapeuticas = accionesTerapeuticas;
    }
    
    public List getEstadoRegistro() {
        return estadoRegistro;
    }
    
    public void setEstadoRegistro(List estadoRegistro) {
        this.estadoRegistro = estadoRegistro;
    }
    
    public List getAccionesTerapeuticasEliminar() {
        return accionesTerapeuticasEliminar;
    }
    
    public void setAccionesTerapeuticasEliminar(List accionesTerapeuticasEliminar) {
        this.accionesTerapeuticasEliminar = accionesTerapeuticasEliminar;
    }
    
    public List getAccionesTerapeuticasNoEliminar() {
        return accionesTerapeuticasNoEliminar;
    }
    
    public void setAccionesTerapeuticasNoEliminar(List accionesTerapeuticasNoEliminar) {
        this.accionesTerapeuticasNoEliminar = accionesTerapeuticasNoEliminar;
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
