/*
 * ManagedTipoCliente.java
 * Created on 19 de febrero de 2008, 16:50
 */

package com.cofar.web;

import com.cofar.bean.PrincipiosActivos;
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
public class ManagedPrincipiosActivos{
    
    /** Creates a new instance of ManagedTipoCliente */
    private PrincipiosActivos principiosActivosbean=new PrincipiosActivos();
    private List principiosActivos=new ArrayList();
    private List estadoRegistro=new ArrayList();
    private List principiosActivosEliminar=new ArrayList();
    private List principiosActivosNOEliminar=new ArrayList();
    private Connection con;
    private boolean swEliminaSi;
    private boolean swEliminaNo;
    
    
    public ManagedPrincipiosActivos() {
        cargarPrincipiosActivos();
    }
    /**
     * metodo que genera los codigos
     * correlativamente
     */
    public String getCodigoPrincipioActivo(){
        String codigo="1";
        try {
            setCon(Util.openConnection(getCon()));
            String sql="select max(cod_principio_activo)+1 from principios_activos";
            PreparedStatement st=getCon().prepareStatement(sql);
            ResultSet rs=st.executeQuery();
            while (rs.next())
                codigo=rs.getString(1);
            if(codigo==null)
                codigo="1";
            
            principiosActivosbean.setCodPrincipioActivo(codigo);
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return  "";
    }
    
    public void cargarEstadoRegistro(String codigo,PrincipiosActivos bean){
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
    public void cargarPrincipiosActivos(){
        try {
            String sql="select cod_principio_activo,nombre_principio_activo,obs_principio_activo,cod_estado_registro" +
                    " from principios_activos";
            if(!principiosActivosbean.getEstadoReferencial().getCodEstadoRegistro().equals("") && !principiosActivosbean.getEstadoReferencial().getCodEstadoRegistro().equals("3")){
                sql+=" where cod_estado_registro="+principiosActivosbean.getEstadoReferencial().getCodEstadoRegistro();
            }
            sql+=" order by nombre_principio_activo asc";
            System.out.println("cargar:"+sql);
            setCon(Util.openConnection(getCon()));
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(sql);
            rs.last();
            int rows=rs.getRow();
            principiosActivos.clear();
            rs.first();
            String cod="";
            for(int i=0;i<rows;i++){
                PrincipiosActivos bean=new PrincipiosActivos();
                bean.setCodPrincipioActivo(rs.getString(1));
                bean.setNombrePrincipioActivo(rs.getString(2));
                bean.setObsPrincipioActivo(rs.getString(3));
                //bean.setCodEstadoRegistro(rs.getString(7));
                cod=rs.getString(4);
                cod=(cod==null)?"":cod;
                System.out.println("st xxx:"+cod);
                cargarEstadoRegistro(cod,bean);
                principiosActivos.add(bean);
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
        clearPrincipiosActivos();
        return"actionAgregarPrincipiosActivos";
    }
    public String actionEditar(){
        cargarEstadoRegistro("",null);
        Iterator i=principiosActivos.iterator();
        while (i.hasNext()){
            PrincipiosActivos bean=(PrincipiosActivos)i.next();
            if(bean.getChecked().booleanValue()){
                principiosActivosbean=bean;
                //cargosbean.getEstadoReferencial().setCodEstadoRegistro(bean.getCodEstadoRegistro());
                break;
            }
            
        }
        return "actionEditarPrincipiosActivos";
    }
    public String actionEliminar(){
        setSwEliminaSi(false);
        setSwEliminaNo(false);
        principiosActivosEliminar.clear();
        principiosActivosNOEliminar.clear();
        int bandera=0;
        Iterator i=principiosActivos.iterator();
        while (i.hasNext()){
            PrincipiosActivos bean=(PrincipiosActivos)i.next();
            if(bean.getChecked().booleanValue()){
                try {
                    String sql="select cod_principio_activo from principios_activos_producto " +
                            " where cod_principio_activo="+bean.getCodPrincipioActivo();
                    System.out.println("eliminar:"+sql);
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
                        principiosActivosEliminar.add(bean);
                        setSwEliminaSi(true);
                        System.out.println("entro  eliminarrrrrrrrrrrr");
                    }else{
                        principiosActivosNOEliminar.add(bean);
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
        return "ActioneliminarPrincipiosActivos";
    }
    
    public void clearPrincipiosActivos(){
        principiosActivosbean.setCodPrincipioActivo("");
        principiosActivosbean.setNombrePrincipioActivo("");
        principiosActivosbean.setObsPrincipioActivo("");
        
    }
    
    public String guardarPrincipiosActivos(){
        try {
            String sql="insert into principios_activos(cod_principio_activo,nombre_principio_activo," +
                    "obs_principio_activo,cod_estado_registro)values(";
            sql+=" "+principiosActivosbean.getCodPrincipioActivo()+",'"+principiosActivosbean.getNombrePrincipioActivo().toUpperCase()+"',"+
                    "'"+principiosActivosbean.getObsPrincipioActivo()+"',1)";
            System.out.println("insert:"+sql);
            setCon(Util.openConnection(getCon()));
            PreparedStatement st=getCon().prepareStatement(sql);
            int result=st.executeUpdate();
            if(result>0){
                cargarPrincipiosActivos();
                clearPrincipiosActivos();
            }
            System.out.println("result:"+result);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return "navegadorPrincipiosActivos";
    }
    public String modificarPrincipiosActivos(){
        try {
            setCon(Util.openConnection(getCon()));
            String  sql="update principios_activos set";
            sql+=" nombre_principio_activo='"+principiosActivosbean.getNombrePrincipioActivo().toUpperCase()+"',";
            sql+=" obs_principio_activo='"+principiosActivosbean.getObsPrincipioActivo()+"',";
            sql+=" cod_estado_registro='"+principiosActivosbean.getEstadoReferencial().getCodEstadoRegistro()+"'";
            sql+=" where cod_principio_activo="+principiosActivosbean.getCodPrincipioActivo();
            PreparedStatement st=getCon().prepareStatement(sql);
            int result=st.executeUpdate();
            if(result>0){
                cargarPrincipiosActivos();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return "navegadorPrincipiosActivos";
    }
    public String eliminarPrincipiosActivos(){
        try {
            
            Iterator i=principiosActivosEliminar.iterator();
            int result=0;
            while (i.hasNext()){
                PrincipiosActivos bean=(PrincipiosActivos)i.next();
                String sql="delete from principios_activos  ";
                sql+="where cod_principio_activo="+bean.getCodPrincipioActivo();;
                
                System.out.println("deleteprincipio:sql:"+sql);
                setCon(Util.openConnection(getCon()));
                Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                result=result+st.executeUpdate(sql);
            }
            principiosActivosEliminar.clear();
            principiosActivosNOEliminar.clear();
            if(result>0){
                cargarPrincipiosActivos();
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "navegadorPrincipiosActivos";
    }
    public String Cancelar(){
        principiosActivos.clear();
        cargarPrincipiosActivos();
        return "navegadorPrincipiosActivos";
    }
    
    
    /**********ESTADO REGISTRO****************/
    public void changeEvent(ValueChangeEvent event){
        System.out.println("event:"+event.getNewValue());
        principiosActivosbean.getEstadoReferencial().setCodEstadoRegistro(event.getNewValue().toString());
        cargarPrincipiosActivos();
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

    public PrincipiosActivos getPrincipiosActivosbean() {
        return principiosActivosbean;
    }

    public void setPrincipiosActivosbean(PrincipiosActivos principiosActivosbean) {
        this.principiosActivosbean = principiosActivosbean;
    }

    public List getPrincipiosActivos() {
        return principiosActivos;
    }

    public void setPrincipiosActivos(List principiosActivos) {
        this.principiosActivos = principiosActivos;
    }

    public List getEstadoRegistro() {
        return estadoRegistro;
    }

    public void setEstadoRegistro(List estadoRegistro) {
        this.estadoRegistro = estadoRegistro;
    }

    public List getPrincipiosActivosEliminar() {
        return principiosActivosEliminar;
    }

    public void setPrincipiosActivosEliminar(List principiosActivosEliminar) {
        this.principiosActivosEliminar = principiosActivosEliminar;
    }

    public List getPrincipiosActivosNOEliminar() {
        return principiosActivosNOEliminar;
    }

    public void setPrincipiosActivosNOEliminar(List principiosActivosNOEliminar) {
        this.principiosActivosNOEliminar = principiosActivosNOEliminar;
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
