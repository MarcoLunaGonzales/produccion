/*
 * ManagedPersonal.java
 *
 * Created on 7 de marzo de 2008, 16:35
 */

package com.cofar.web;
import com.cofar.bean.FormasFarmaceuticas;
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
public class ManagedFormasFarmaceuticas extends ManagedBean{
    
    /** Creates a new instance of ManagedPersonal */
    private List formasFarmaceuticasList=new ArrayList();
    private List formaFarmaceuticaEli=new ArrayList();
    private List formaFarmaceuticaEli2=new ArrayList();
    private FormasFarmaceuticas formaFarmaceutica=new FormasFarmaceuticas();
    private Connection con;
    private List estadoRegistroList=new  ArrayList();
    private List unidadMedidaList=new  ArrayList();
    private List tipoMedidaList=new  ArrayList();
    private boolean swElimina1;
    private boolean swElimina2;
    private int corte=0;
    
    public ManagedFormasFarmaceuticas() {
        cargarFormasFarmaceuticas();
    }
    public String[] cargarEstadoRefenreciales(String codigo,String option){
        String values[]=new String[2];
        try {
            
            String sql="";
            if(option.equals("ESTADO_REGISTRO")){
                sql="select cod_estado_registro, nombre_estado_registro from estados_referenciales where cod_estado_registro="+codigo;
            }
            System.out.println("sql:"+sql);
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            if(!sql.equals("")){
                ResultSet rs=st.executeQuery(sql);
                if(rs.next()){
                    values[0]=rs.getString(1);
                    values[1]=rs.getString(2);
                }
                if(rs!=null){
                    rs.close();
                    st.close();
                }
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return values;        
    }
    public void cargarFormasFarmaceuticas(){
        try {
            String sql="select ";
            sql+=" cod_forma,nombre_forma,cod_unidad_medida,abreviatura_forma,obs_forma,cod_estado_registro";            
            sql+=" from formas_farmaceuticas ";
            if(!formaFarmaceutica.getEstadoReferencial().getCodEstadoRegistro().equals("") && !formaFarmaceutica.getEstadoReferencial().getCodEstadoRegistro().equals("3")){
                sql+=" where cod_estado_registro="+formaFarmaceutica.getEstadoReferencial().getCodEstadoRegistro();
            }
            System.out.println("sql:sql:"+sql);
            setCon(Util.openConnection(getCon()));
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(sql);
            String cod="";
            getFormasFarmaceuticasList().clear();
            while (rs.next()){
                FormasFarmaceuticas bean=new FormasFarmaceuticas();
                bean.setCodForma(rs.getString(1));
                bean.setNombreForma(rs.getString(2));
                cod=rs.getString(3);
                cod=(cod==null)?"":cod;
                cargarUnidadMedida(cod,bean);
                bean.setAbreviaturaForma(rs.getString(4));
                bean.setObsForma(rs.getString(5));
                cod=rs.getString(6);
                cod=(cod==null)?"":cod;
                cargarEstadoRegistro(cod,bean);                
                formasFarmaceuticasList.add(bean);
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
        //if(getCorte()==1){
        System.out.println("event:"+event.getNewValue());
        formaFarmaceutica.getEstadoReferencial().setCodEstadoRegistro(event.getNewValue().toString());
        cargarFormasFarmaceuticas();
        //}
        setCorte(1);
    }
    public void cargarEstadoRegistro(String codigo,FormasFarmaceuticas bean){
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
                getEstadoRegistroList().clear();
                rs=st.executeQuery(sql);
                while (rs.next())
                    getEstadoRegistroList().add(new SelectItem(rs.getString(1),rs.getString(2)));
            }
            if(rs!=null){
                rs.close();st.close();
                rs=null;st=null;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public void cargarTipoMedida(String codigo,FormasFarmaceuticas bean){
        try {
            setCon(Util.openConnection(getCon()));
            String sql="select cod_tipo_medida,nombre_tipo_medida from tipos_medida ";
            System.out.println("sql"+sql);
            ResultSet rs=null;
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            if(!codigo.equals("")){
                sql+=" where cod_tipo_medida="+codigo;
                rs=st.executeQuery(sql);
                if(rs.next()){
                    bean.getUnidadMedida().getTipoMedida().setCod_tipo_medida(rs.getString(1));
                    bean.getUnidadMedida().getTipoMedida().setNombre_tipo_medida(rs.getString(2));
                    
                }
            } else{
                getTipoMedidaList().clear();
                rs=st.executeQuery(sql);
                while (rs.next())
                    getTipoMedidaList().add(new SelectItem(rs.getString(1),rs.getString(2)));
            }
            if(rs!=null){
                rs.close();st.close();
                rs=null;st=null;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public void cargarUnidadMedida(String codigo,FormasFarmaceuticas bean){
        try {
            setCon(Util.openConnection(getCon()));
            String sql="select cod_unidad_medida,nombre_unidad_medida,cod_tipo_medida";
            sql=sql+" from unidades_medida ";
            ResultSet rs=null;
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            if(!codigo.equals("")){
                sql+=" where cod_unidad_medida="+codigo;
                rs=st.executeQuery(sql);
                if(rs.next()){
                    
                    bean.getUnidadMedida().setCodUnidadMedida(rs.getString(1));
                    bean.getUnidadMedida().setNombreUnidadMedida(rs.getString(2));
                    bean.getUnidadMedida().getTipoMedida().setCod_tipo_medida(rs.getString(3));
                    
                }
            } else{
                getUnidadMedidaList().clear();
                rs=st.executeQuery(sql);
                while (rs.next())
                    getUnidadMedidaList().add(new SelectItem(rs.getString(1),rs.getString(2)));
            }
            if(rs!=null){
                rs.close();st.close();
                rs=null;st=null;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public void cargarUnidadMedida2(javax.faces.event.ValueChangeEvent event){
        String codigo="";
        if(event==null){
            codigo=formaFarmaceutica.getUnidadMedida().getTipoMedida().getCod_tipo_medida();
        }else{
            codigo=event.getNewValue().toString();
        }
        try {
            setCon(Util.openConnection(getCon()));
            String sql="select cod_unidad_medida,nombre_unidad_medida,cod_tipo_medida";
            sql+=" from unidades_medida ";
            sql+=" where cod_tipo_medida="+codigo;
            ResultSet rs=null;
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            getUnidadMedidaList().clear();
            rs=st.executeQuery(sql);
            while (rs.next())
                getUnidadMedidaList().add(new SelectItem(rs.getString(1),rs.getString(2)));
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
            String  sql="select max(cod_forma)+1 from formas_farmaceuticas";
            con=Util.openConnection(con);
            Statement st=con.createStatement();
            ResultSet rs=st.executeQuery(sql);
            if(rs.next()){
                String cod=rs.getString(1);
                if(cod==null)
                    getFormaFarmaceutica().setCodForma("1");
                else
                    getFormaFarmaceutica().setCodForma(cod);
            }
            if(rs!=null){
                rs.close();
                st.close();
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public String actionSaveFormasFarmaceuticas(){
        
        cargarTipoMedida("",null);
        cargarUnidadMedida("",null);
        cargarEstadoRegistro("",null);
        return "actionSave";
    }
    public String saveFormasFarmaceuticas(){
        generarCodigo();
        try {
            String sql="insert into formas_farmaceuticas(cod_forma,nombre_forma,cod_unidad_medida,abreviatura_forma,obs_forma,cod_estado_registro)values(" ;
            sql+=""+formaFarmaceutica.getCodForma()+",";
            sql+="'"+formaFarmaceutica.getNombreForma()+"',";
            sql+=""+formaFarmaceutica.getUnidadMedida().getCodUnidadMedida()+",";
            sql+="'"+formaFarmaceutica.getAbreviaturaForma()+"',";
            sql+="'"+formaFarmaceutica.getObsForma()+"',";
            //ESTADO ACTIVO VALOR ES 1
            sql+="1)";
            System.out.println("sql:insert:"+sql);
            con=Util.openConnection(con);
            PreparedStatement st=con.prepareStatement(sql);
            int result=st.executeUpdate();
            st.close();
            
            clear();
            
            if(result>0){
                
                cargarFormasFarmaceuticas();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return "navegadorformasfarmaceuticas";
    }
    public void clear(){
        FormasFarmaceuticas ep=new FormasFarmaceuticas();
        setFormaFarmaceutica(ep);
    }
    public String actionEditFormasFarmaceuticas(){
        Iterator i=getFormasFarmaceuticasList().iterator();
        while (i.hasNext()){
            FormasFarmaceuticas bean=(FormasFarmaceuticas)i.next();
            if(bean.getChecked().booleanValue()){
                setFormaFarmaceutica(bean);
                break;
            }
        }
        cargarUnidadMedida(getFormaFarmaceutica().getUnidadMedida().getCodUnidadMedida(),formaFarmaceutica);
        cargarEstadoRegistro("",null);
        cargarTipoMedida("",null);
        cargarUnidadMedida2(null);
        
        return "actionEdit";
    }
    public String actionCancelar(){
        clear();
        cargarFormasFarmaceuticas();
        return "navegadorformasfarmaceuticas";
    }
    public String editFormasFarmaceuticas(){
        try {
            String sql="update formas_farmaceuticas set ";
            sql+="nombre_forma='"+formaFarmaceutica.getNombreForma()+"',";
            sql+="cod_unidad_medida="+formaFarmaceutica.getUnidadMedida().getCodUnidadMedida()+",";
            sql+="abreviatura_forma='"+formaFarmaceutica.getAbreviaturaForma()+"',";
            sql+="obs_forma='"+formaFarmaceutica.getObsForma()+"',";
            sql+="cod_estado_registro="+formaFarmaceutica.getEstadoReferencial().getCodEstadoRegistro();
            sql+="where cod_forma="+formaFarmaceutica.getCodForma();
            System.out.println("sql:Update:"+sql);
            con=Util.openConnection(con);
            PreparedStatement st=con.prepareStatement(sql);
            int result=st.executeUpdate();
            st.close();
            clear();
            if(result>0){
                cargarFormasFarmaceuticas();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "navegadorformasfarmaceuticas";
    }
    public String actionDeleteFormasFarmaceuticas(){
        setSwElimina2(false);
        setSwElimina1(false);
        getFormaFarmaceuticaEli().clear();
        getFormaFarmaceuticaEli2().clear();
        Iterator i=getFormasFarmaceuticasList().iterator();
        while (i.hasNext()){
            FormasFarmaceuticas bean=(FormasFarmaceuticas)i.next();
            if(bean.getChecked().booleanValue()){
                try {
                    String sql="select * from formasfar_envaseprim" +
                            " where cod_forma="+bean.getCodForma();
                    System.out.println("sqldelete"+sql);
                    con=Util.openConnection(con);
                    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet rs=st.executeQuery(sql);
                    
                    rs.last();
                    if(rs.getRow()>0){
                        getFormaFarmaceuticaEli2().add(bean);
                        setSwElimina2(true);
                    }else{
                        getFormaFarmaceuticaEli().add(bean);
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
    public String deleteFormasFarmaceuticas(){
        try {
            
            Iterator i=formaFarmaceuticaEli.iterator();
            int result=0;
            while (i.hasNext()){
                FormasFarmaceuticas bean=(FormasFarmaceuticas)i.next();
                String sql="delete from formas_farmaceuticas " +
                        " where cod_forma="+bean.getCodForma();
                System.out.println("deleteFormasFarmaceuticas:sql:"+sql);
                con=Util.openConnection(con);
                Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                result=result+st.executeUpdate(sql);
            }
            formaFarmaceuticaEli.clear();
            if(result>0){
                cargarFormasFarmaceuticas();
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "navegadorformasfarmaceuticas";
    }
    
    public List getFormasFarmaceuticasList() {
        return formasFarmaceuticasList;
    }
    
    public void setFormasFarmaceuticasList(List formasFarmaceuticasList) {
        this.formasFarmaceuticasList = formasFarmaceuticasList;
    }
    
    public List getFormaFarmaceuticaEli() {
        return formaFarmaceuticaEli;
    }
    
    public void setFormaFarmaceuticaEli(List formaFarmaceuticaEli) {
        this.formaFarmaceuticaEli = formaFarmaceuticaEli;
    }
    
    public List getFormaFarmaceuticaEli2() {
        return formaFarmaceuticaEli2;
    }
    
    public void setFormaFarmaceuticaEli2(List formaFarmaceuticaEli2) {
        this.formaFarmaceuticaEli2 = formaFarmaceuticaEli2;
    }
    
    public FormasFarmaceuticas getFormaFarmaceutica() {
        return formaFarmaceutica;
    }
    
    public void setFormaFarmaceutica(FormasFarmaceuticas formaFarmaceutica) {
        this.formaFarmaceutica = formaFarmaceutica;
    }
    
    public Connection getCon() {
        return con;
    }
    
    public void setCon(Connection con) {
        this.con = con;
    }
    
    public List getEstadoRegistroList() {
        return estadoRegistroList;
    }
    
    public void setEstadoRegistroList(List estadoRegistroList) {
        this.estadoRegistroList = estadoRegistroList;
    }
    
    public List getUnidadMedidaList() {
        return unidadMedidaList;
    }
    
    public void setUnidadMedidaList(List unidadMedidaList) {
        this.unidadMedidaList = unidadMedidaList;
    }
    
    public List getTipoMedidaList() {
        return tipoMedidaList;
    }
    
    public void setTipoMedidaList(List tipoMedidaList) {
        this.tipoMedidaList = tipoMedidaList;
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
    
    public int getCorte() {
        return corte;
    }
    
    public void setCorte(int corte) {
        this.corte = corte;
    }
    
}
