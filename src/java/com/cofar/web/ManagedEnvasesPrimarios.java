/*
 * ManagedPersonal.java
 *
 * Created on 7 de marzo de 2008, 16:35
 */

package com.cofar.web;
import com.cofar.bean.EnvasesPrimarios;
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
 * @author Gabriela Quelali
 * @company COFAR
 */
public class ManagedEnvasesPrimarios extends ManagedBean{
    
    /** Creates a new instance of ManagedPersonal */
    private List envasesPrimariosList=new ArrayList();
    private List envasePrimarioEli=new ArrayList();
    private List envasePrimarioEli2=new ArrayList();
    private EnvasesPrimarios envasePrimario=new EnvasesPrimarios();
    private Connection con;
    private List estadoRegistro=new ArrayList();
    private boolean swElimina1;
    private boolean swElimina2;
    
    public ManagedEnvasesPrimarios() {
        cargarEnvasesPrimarios();
        
    }
    public void cargarEnvasesPrimarios(){
        envasesPrimariosList.clear();
        try {
            String sql="select cod_envaseprim,nombre_envaseprim,obs_envaseprim,cod_estado_registro";
            sql+=" from envases_primarios ";
            
            if(!envasePrimario.getEstadoReferencial().getCodEstadoRegistro().equals("") && !envasePrimario.getEstadoReferencial().getCodEstadoRegistro().equals("3")){
                sql+=" where cod_estado_registro="+envasePrimario.getEstadoReferencial().getCodEstadoRegistro();
            }
            sql+=" order by nombre_envaseprim   ";
            System.out.println("sql:"+sql);
            System.out.println("sql:sql:"+sql);
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(sql);
            String cod="";
            getEnvasesPrimariosList().clear();
            while (rs.next()){
                EnvasesPrimarios bean=new EnvasesPrimarios();
                //rs.getString(1);
                bean.setCodEnvasePrim(rs.getString(1));
                bean.setNombreEnvasePrim(rs.getString(2));
                bean.setObsEnvasePrim(rs.getString(3));
                cod=rs.getString(4);
                cod=(cod==null)?"":cod;
                cargarEstadoRegistro(cod,bean);
                envasesPrimariosList.add(bean);
            }
            if(rs!=null){
                rs.close();st.close();
                rs=null;st=null;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    /* -------------------------------------------------------------------------
     * ESTADO REGISTRO
     * -------------------------------------------------------------------------
     **/
    public void changeEvent(ValueChangeEvent event){
       
        System.out.println("event:"+event.getNewValue());
        envasePrimario.getEstadoReferencial().setCodEstadoRegistro(event.getNewValue().toString());
        cargarEnvasesPrimarios();
    }
    public void cargarEstadoRegistro(String codigo,EnvasesPrimarios bean){
        try {
            con=Util.openConnection(con);
            String sql="select cod_estado_registro,nombre_estado_registro from estados_referenciales";
            ResultSet rs=null;
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            if(!codigo.equals("")){
                sql+=" where cod_estado_registro="+codigo;
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
            String  sql="select max(cod_envaseprim)+1 from envases_primarios";
            con=Util.openConnection(con);
            Statement st=con.createStatement();
            ResultSet rs=st.executeQuery(sql);
            if(rs.next()){
                String cod=rs.getString(1);
                if(cod==null)
                    getEnvasePrimario().setCodEnvasePrim("1");
                else
                    getEnvasePrimario().setCodEnvasePrim(cod);
            }
            if(rs!=null){
                rs.close();
                st.close();
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public String actionSaveEnvasesPrimarios(){
        cargarEstadoRegistro("",null);
        return "actionSave";
    }
    public String saveEnvasesPrimarios(){
        generarCodigo();
        try {
            String sql="insert into envases_primarios(cod_envaseprim,nombre_envaseprim,obs_envaseprim,cod_estado_registro)values(" ;
            sql+=""+envasePrimario.getCodEnvasePrim()+",";
            sql+="'"+envasePrimario.getNombreEnvasePrim()+"',";
            sql+="'"+envasePrimario.getObsEnvasePrim()+"',";
            //ESTADO ACTIVO VALOR ES 1
            sql+="1)";
            System.out.println("sql:insert:"+sql);
            con=Util.openConnection(con);
            PreparedStatement st=con.prepareStatement(sql);
            int result=st.executeUpdate();
            st.close();
            
            clear();
            
            if(result>0){
                
                cargarEnvasesPrimarios();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return "navegadorenvasesprimarios";
    }
    public void clear(){
        EnvasesPrimarios ep=new EnvasesPrimarios();
        setEnvasePrimario(ep);
    }
    
    public String actionEditEnvasesPrimarios(){
        cargarEstadoRegistro("",null);
        Iterator i=getEnvasesPrimariosList().iterator();
        while (i.hasNext()){
            EnvasesPrimarios bean=(EnvasesPrimarios)i.next();
            if(bean.getChecked().booleanValue()){
                setEnvasePrimario(bean);
                break;
            }
        }
        return "actionEdit";
    }
    
    public String editEnvasesPrimarios(){
        try {
            String sql="update envases_primarios set ";
            sql+="nombre_envaseprim='"+envasePrimario.getNombreEnvasePrim()+"',";
            sql+="obs_envaseprim='"+envasePrimario.getObsEnvasePrim()+"',";
            sql+="cod_estado_registro="+envasePrimario.getEstadoReferencial().getCodEstadoRegistro();
            sql+="where cod_envaseprim="+envasePrimario.getCodEnvasePrim();
            System.out.println("sql:Update:"+sql);
            con=Util.openConnection(con);
            PreparedStatement st=con.prepareStatement(sql);
            /*setCon(Util.openConnection(getCon()));
            PreparedStatement st=getCon().prepareStatement(sql);*/
            int result=st.executeUpdate();
            st.close();
            clear();
            if(result>0){
                cargarEnvasesPrimarios();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "navegadorenvasesprimarios";
    }
    public String actionDeleteEnvasesPrimarios(){
        setSwElimina2(false);
        setSwElimina1(false);
        getEnvasePrimarioEli().clear();
        getEnvasePrimarioEli2().clear();
        Iterator i=getEnvasesPrimariosList().iterator();
        while (i.hasNext()){
            EnvasesPrimarios bean=(EnvasesPrimarios)i.next();
            if(bean.getChecked().booleanValue()){
                try {
                    String sql="select * from formasfar_envaseprim" +
                            " where cod_envaseprim="+bean.getCodEnvasePrim();
                    System.out.println("sqldelete"+sql);
                    con=Util.openConnection(con);
                    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet rs=st.executeQuery(sql);
                    
                    rs.last();
                    if(rs.getRow()>0){
                        getEnvasePrimarioEli2().add(bean);
                        setSwElimina2(true);
                    }else{
                        getEnvasePrimarioEli().add(bean);
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
    public String deleteEnvasesPrimarios(){
        try {
            
            Iterator i=envasePrimarioEli.iterator();
            int result=0;
            while (i.hasNext()){
                EnvasesPrimarios bean=(EnvasesPrimarios)i.next();
                String sql="delete from envases_primarios " +
                        " where cod_envaseprim="+bean.getCodEnvasePrim();
                System.out.println("sql Eliminar="+sql);
               /* String sql="update envases_primarios set cod_estado_registro=2";
                sql+=" where cod_envaseprim="+bean.getCodEnvasePrim();*/
                System.out.println("deleteEnvasesPrimarios:sql:"+sql);
                con=Util.openConnection(con);
                Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                result=result+st.executeUpdate(sql);
            }
            envasePrimarioEli.clear();
            if(result>0){
                cargarEnvasesPrimarios();
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "navegadorenvasesprimarios";
    }
    
    
    public List getEnvasesPrimariosList() {
        return envasesPrimariosList;
    }
    
    public List getEstadoRegistro() {
        return estadoRegistro;
    }
    
    public void setEstadoRegistro(List estadoRegistro) {
        this.estadoRegistro = estadoRegistro;
    }
    
    public EnvasesPrimarios getEnvasePrimario() {
        return envasePrimario;
    }
    
    public void setEnvasePrimario(EnvasesPrimarios envasePrimario) {
        this.envasePrimario = envasePrimario;
    }
    
    public List getEnvasePrimarioEli() {
        return envasePrimarioEli;
    }
    
    public void setEnvasePrimarioEli(List envasePrimarioEli) {
        this.envasePrimarioEli = envasePrimarioEli;
    }
    
    public List getEnvasePrimarioEli2() {
        return envasePrimarioEli2;
    }
    
    public void setEnvasePrimarioEli2(List envasePrimarioEli2) {
        this.envasePrimarioEli2 = envasePrimarioEli2;
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
