

/*
 * ManagedTipoCliente.java
 * Created on 19 de febrero de 2008, 16:50
 */

package com.cofar.web;

import com.cofar.bean.FormulaMaestraDetalleMPROM;
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
public class ManagedFormulaMaestraDetalleMPROM {
    
    /** Creates a new instance of ManagedTipoCliente */
    private FormulaMaestraDetalleMPROM formulaMaestraDetalleMPROMbean=new FormulaMaestraDetalleMPROM();
    private List formulaMaestraDetalleMPROMList=new ArrayList();
    private List formulaMaestraDetalleMPROMAdicionarList=new ArrayList();
    private List formulaMaestraDetalleMPROMEliminarList=new ArrayList();
    private List formulaMaestraDetalleMPROMEditarList=new ArrayList();
    private List materialesList=new ArrayList();
    private List unidadesMedidaList=new ArrayList();
    private Connection con;
    private String codigo="";
    private boolean swSi=false;
    private boolean swNo=false;
    private String nombreComProd="";
    
    public ManagedFormulaMaestraDetalleMPROM() {
        
    }
    public String getObtenerCodigo(){
        
        //String cod=Util.getParameter("codigo");
        String cod=Util.getParameter("codigo");
        //cod="1";
        System.out.println("cxxxxxxxxxxxxxxxxxxxxxxxod:"+cod);
        if(cod!=null){
            setCodigo(cod);
        }
        formulaMaestraDetalleMPROMList.clear();
        cargarFormulaMaestraDetalleMPROM();
        cargarNombreComProd();
        return "";
        
    }
    public String cancelar(){
        System.out.println("entrofsdfsdfsdfsdfsdf");
        //cargarFormulaMaestraDetalleMPROM();
        return "navegadorFormulaMaestraDetalleMPROM";
    }
    public String cargarNombreComProd(){
        try {
            setCon(Util.openConnection(getCon()));
            String sql=" select cp.nombre_prod_semiterminado";
            sql+=" from COMPONENTES_PROD cp,PRODUCTOS p,FORMULA_MAESTRA fm";
            sql+=" where cp.COD_COMPPROD=fm.COD_COMPPROD and p.cod_prod=cp.COD_PROD";
            sql+=" and fm.COD_FORMULA_MAESTRA='"+getCodigo()+"'";
            System.out.println("sql:-----------:"+sql);
            PreparedStatement st=getCon().prepareStatement(sql);
            ResultSet rs=st.executeQuery();
            while (rs.next()){
                setNombreComProd(rs.getString(1));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        System.out.println("nombreComProd:"+getNombreComProd());
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
    
    public void cargarFormulaMaestraDetalleMPROM(){
        
        try {
            System.out.println("codigo:"+getCodigo());
            String sql="select fm.COD_FORMULA_MAESTRA,m.NOMBRE_MATERIAL,fmp.CANTIDAD,um.NOMBRE_UNIDAD_MEDIDA,m.cod_material";
            sql+=" from FORMULA_MAESTRA fm,MATERIALES m,UNIDADES_MEDIDA um,FORMULA_MAESTRA_DETALLE_MPROM fmp";
            sql+=" where fm.COD_FORMULA_MAESTRA=fmp.COD_FORMULA_MAESTRA and um.COD_UNIDAD_MEDIDA=fmp.COD_UNIDAD_MEDIDA";
            sql+=" and m.COD_MATERIAL=fmp.COD_MATERIAL ";
            sql+=" and fmp.COD_MATERIAL IN(select m1.COD_MATERIAL from MATERIALES m1,grupos g where g.COD_GRUPO=m1.COD_GRUPO";
            sql+=" and g.COD_CAPITULO=12) and fm.COD_FORMULA_MAESTRA='"+getCodigo()+"'";
            sql+=" order by m.NOMBRE_MATERIAL";
            System.out.println("sql>"+sql);
            setCon(Util.openConnection(getCon()));
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(sql);
            rs.last();
            int rows=rs.getRow();
            formulaMaestraDetalleMPROMList.clear();
            rs.first();
            for(int i=0;i<rows;i++){
                FormulaMaestraDetalleMPROM bean=new FormulaMaestraDetalleMPROM();
                bean.getFormulaMaestra().setCodFormulaMaestra(rs.getString(1));
                bean.getMateriales().setNombreMaterial(rs.getString(2));
                bean.setCantidad(rs.getString(3));
                bean.getUnidadesMedida().setNombreUnidadMedida(rs.getString(4));
                bean.getMateriales().setCodMaterial(rs.getString(5));
                formulaMaestraDetalleMPROMList.add(bean);
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
        cargarMateriaPrima();
        //cargarUnidadesMedida("",null);
        System.out.println("enrreknkjlsdf"+getUnidadesMedidaList().size());
        return "actionAgregarFormulaMaestraDetalleMPROM";
    }
    public String cargarMateriaPrima(){
        
        try {
            System.out.println("entroooooooooooooooooooooooooooooooooo");
            formulaMaestraDetalleMPROMAdicionarList.clear();
            System.out.println("codigo:"+getCodigo());
            
            String sql="select m1.COD_MATERIAL,m1.NOMBRE_MATERIAL,um.ABREVIATURA,um.cod_unidad_medida " +
                    " from MATERIALES m1,grupos g,UNIDADES_MEDIDA um where g.COD_GRUPO=m1.COD_GRUPO";
            sql+=" and g.COD_CAPITULO=12 and m1.movimiento_item=1 and m1.COD_MATERIAL <> ";
            sql+=" ALL(select fmp.COD_MATERIAL from FORMULA_MAESTRA_DETALLE_MPROM fmp where fmp.COD_FORMULA_MAESTRA='"+getCodigo()+"' ) and um.COD_UNIDAD_MEDIDA=m1.COD_UNIDAD_MEDIDA";
            sql+=" order by m1.NOMBRE_MATERIAL";
            System.out.println("sql:"+sql);
            setCon(Util.openConnection(getCon()));
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(sql);
            rs.last();
            int rows=rs.getRow();
            rs.first();
            for(int i=0;i<rows;i++){
                FormulaMaestraDetalleMPROM bean=new FormulaMaestraDetalleMPROM();
                bean.getMateriales().setCodMaterial(rs.getString(1));
                bean.getMateriales().setNombreMaterial(rs.getString(2));
                bean.getUnidadesMedida().setAbreviatura(rs.getString(3));
                bean.getUnidadesMedida().setCodUnidadMedida(rs.getString(4));
                bean.setCantidad("0");
                formulaMaestraDetalleMPROMAdicionarList.add(bean);
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
    public void cargarUnidadesMedida(String codigo,FormulaMaestraDetalleMPROM bean){
        try {
            setCon(Util.openConnection(getCon()));
            String sql="select um.COD_UNIDAD_MEDIDA,um.NOMBRE_UNIDAD_MEDIDA  from UNIDADES_MEDIDA um where um.COD_ESTADO_REGISTRO=1";
            ResultSet rs=null;
            getUnidadesMedidaList().clear();
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            if(!codigo.equals("")){
                sql+=" and cod_estado_registro="+codigo;
                System.out.println("update:"+sql);
                rs=st.executeQuery(sql);
                if(rs.next()){
                    
                }
            } else{
                getUnidadesMedidaList().clear();
                rs=st.executeQuery(sql);
                while (rs.next())
                    getUnidadesMedidaList().add(new SelectItem(rs.getString(1),rs.getString(2)));
            }
            if(rs!=null){
                rs.close();st.close();
                rs=null;st=null;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    ////////////// Guardar ////////////////////////
    public String guardarFormulaMaestraDetalleMPROM(){
        
        System.out.println("xxxxxxxxxxxxxxxx:"+getCodigo());
        //System.out.println("area_inferior:"+codigoAreaInferior);
        Iterator index=formulaMaestraDetalleMPROMAdicionarList.iterator();
        String sql="";
        int result=0;
        while (index.hasNext()){
            
            try {
                FormulaMaestraDetalleMPROM bean=(FormulaMaestraDetalleMPROM)index.next();
                if(bean.getChecked().booleanValue()){
                    setCon(Util.openConnection(getCon()));
                    sql="insert into FORMULA_MAESTRA_DETALLE_MPROM(COD_FORMULA_MAESTRA,COD_MATERIAL,COD_UNIDAD_MEDIDA,CANTIDAD)values(" ;
                    sql+="'"+getCodigo()+"','"+bean.getMateriales().getCodMaterial()+"','"+bean.getUnidadesMedida().getCodUnidadMedida()+"',"+bean.getCantidad()+")";
                    System.out.println("sql:"+sql);
                    PreparedStatement st1=getCon().prepareStatement(sql);
                    result=st1.executeUpdate();
                    System.out.println("result:"+result);
                }
                
            } catch (SQLException e) {
                e.printStackTrace();
            }
            
            
            
        }
        cargarFormulaMaestraDetalleMPROM();
        return "navegadorFormulaMaestraDetalleMPROM";
    }
    public String guardarEditarFormulaMaestraDetalleMPROM(){
        
        System.out.println("xxxxxxxxxxxxxxxx:"+getCodigo());
        //System.out.println("area_inferior:"+codigoAreaInferior);
        Iterator index=formulaMaestraDetalleMPROMEditarList.iterator();
        String sql="";
        int result=0;
        while (index.hasNext()){
            
            try {
                FormulaMaestraDetalleMPROM bean=(FormulaMaestraDetalleMPROM)index.next();
                
                setCon(Util.openConnection(getCon()));
                sql="update FORMULA_MAESTRA_DETALLE_MPROM set" +
                        " CANTIDAD="+bean.getCantidad()+"" +
                        " where COD_FORMULA_MAESTRA='"+getCodigo()+"' and COD_MATERIAL='"+bean.getMateriales().getCodMaterial()+"'" ;
                
                System.out.println("sql:"+sql);
                PreparedStatement st1=getCon().prepareStatement(sql);
                result=st1.executeUpdate();
                System.out.println("result:"+result);
                
                
            } catch (SQLException e) {
                e.printStackTrace();
            }
            
       }
        cargarFormulaMaestraDetalleMPROM();
        return "navegadorFormulaMaestraDetalleMPROM";
    }
    public String actionEditar(){
        Iterator index=formulaMaestraDetalleMPROMList.iterator();
        String sql="";
        int result=0;
        formulaMaestraDetalleMPROMEditarList.clear();
        while (index.hasNext()){
            FormulaMaestraDetalleMPROM bean=(FormulaMaestraDetalleMPROM)index.next();
            if(bean.getChecked().booleanValue()){
                System.out.println("qwiuweiruweiopru"+bean.getUnidadesMedida().getCodUnidadMedida());
                formulaMaestraDetalleMPROMEditarList.add(bean);
            }
        }
        
        return "actionEditarFormulaMaestraDetalleMPROM";
    }
    public String actionEliminar(){
        Iterator index=formulaMaestraDetalleMPROMList.iterator();
        String sql="";
        int result=0;
        formulaMaestraDetalleMPROMEliminarList.clear();
        while (index.hasNext()){
            FormulaMaestraDetalleMPROM bean=(FormulaMaestraDetalleMPROM)index.next();
            if(bean.getChecked().booleanValue()){
                System.out.println("qwiuweiruweiopru"+bean.getUnidadesMedida().getCodUnidadMedida());
                formulaMaestraDetalleMPROMEliminarList.add(bean);
            }
        }
        
        return "actionEliminarFormulaMaestraDetalleMPROM";
    }
    
    public String guardarEliminarFormulaMaestraDetalleMPROM(){
        
        System.out.println("xxxxxxxxxxxxxxxx:"+getCodigo());
        //System.out.println("area_inferior:"+codigoAreaInferior);
        Iterator index=formulaMaestraDetalleMPROMEliminarList.iterator();
        String sql="";
        int result=0;
        while (index.hasNext()){
            
            try {
                FormulaMaestraDetalleMPROM bean=(FormulaMaestraDetalleMPROM)index.next();
                if(bean.getChecked().booleanValue()){
                    setCon(Util.openConnection(getCon()));
                    sql="delete from FORMULA_MAESTRA_DETALLE_MPROM" +
                            " where COD_FORMULA_MAESTRA='"+getCodigo()+"' and COD_MATERIAL='"+bean.getMateriales().getCodMaterial()+"'" ;
                    System.out.println("sql Eliminar:"+sql);
                    PreparedStatement st1=getCon().prepareStatement(sql);
                    result=st1.executeUpdate();
                    System.out.println("result:"+result);
                }
                
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        cargarFormulaMaestraDetalleMPROM();
        return "navegadorFormulaMaestraDetalleMPROM";
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

    public FormulaMaestraDetalleMPROM getFormulaMaestraDetalleMPROMbean() {
        return formulaMaestraDetalleMPROMbean;
    }

    public void setFormulaMaestraDetalleMPROMbean(FormulaMaestraDetalleMPROM formulaMaestraDetalleMPROMbean) {
        this.formulaMaestraDetalleMPROMbean = formulaMaestraDetalleMPROMbean;
    }

    public List getFormulaMaestraDetalleMPROMList() {
        return formulaMaestraDetalleMPROMList;
    }

    public void setFormulaMaestraDetalleMPROMList(List formulaMaestraDetalleMPROMList) {
        this.formulaMaestraDetalleMPROMList = formulaMaestraDetalleMPROMList;
    }

    public List getFormulaMaestraDetalleMPROMAdicionarList() {
        return formulaMaestraDetalleMPROMAdicionarList;
    }

    public void setFormulaMaestraDetalleMPROMAdicionarList(List formulaMaestraDetalleMPROMAdicionarList) {
        this.formulaMaestraDetalleMPROMAdicionarList = formulaMaestraDetalleMPROMAdicionarList;
    }

    public List getFormulaMaestraDetalleMPROMEliminarList() {
        return formulaMaestraDetalleMPROMEliminarList;
    }

    public void setFormulaMaestraDetalleMPROMEliminarList(List formulaMaestraDetalleMPROMEliminarList) {
        this.formulaMaestraDetalleMPROMEliminarList = formulaMaestraDetalleMPROMEliminarList;
    }

    public List getFormulaMaestraDetalleMPROMEditarList() {
        return formulaMaestraDetalleMPROMEditarList;
    }

    public void setFormulaMaestraDetalleMPROMEditarList(List formulaMaestraDetalleMPROMEditarList) {
        this.formulaMaestraDetalleMPROMEditarList = formulaMaestraDetalleMPROMEditarList;
    }

    public List getMaterialesList() {
        return materialesList;
    }

    public void setMaterialesList(List materialesList) {
        this.materialesList = materialesList;
    }

    public List getUnidadesMedidaList() {
        return unidadesMedidaList;
    }

    public void setUnidadesMedidaList(List unidadesMedidaList) {
        this.unidadesMedidaList = unidadesMedidaList;
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

    public String getNombreComProd() {
        return nombreComProd;
    }

    public void setNombreComProd(String nombreComProd) {
        this.nombreComProd = nombreComProd;
    }

   
  
}
