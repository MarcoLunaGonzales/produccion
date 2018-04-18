/*
 * ManagedTipoCliente.java
 * Created on 19 de Octuble de 2010, 7:00 PM
 */

package com.cofar.web;

import com.cofar.bean.FormulaMaestraDetalleEP;
import com.cofar.bean.Materiales;
import com.cofar.util.Util;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import javax.faces.model.SelectItem;
import java.text.NumberFormat;
import java.util.Locale;
/**
 *
 *  @author Guery Garcia Jaldin
 *  @company COFAR
 */
public class ManagedFormulaMaestraDetalleEP {
    
    /** Creates a new instance of ManagedTipoCliente */
    private FormulaMaestraDetalleEP formulaMaestraDetalleEPbean=new FormulaMaestraDetalleEP();
    private List formulaMaestraDetalleEPList=new ArrayList();
    private List formulaMaestraDetalleEPAdicionarList=new ArrayList();
    private List formulaMaestraDetalleEPEliminarList=new ArrayList();
    private List formulaMaestraDetalleEPEditarList=new ArrayList();
    private List materialesList=new ArrayList();
    private List unidadesMedidaList=new ArrayList();
    private Connection con;
    private String codigo="";
    private String codigoPresPrim="";
    private boolean swSi=false;
    private boolean swNo=false;
    private String nombreComProd="";
    private String nombrePresentacion="";
    private String cantidadPresentacion="";
    private ManagedFormulaMaestra managedFormulaMaestra = new ManagedFormulaMaestra();
    
    public ManagedFormulaMaestraDetalleEP() {
        
    }
    public String getObtenerCodigo(){
        
        //String cod=Util.getParameter("codigo");
        String cod=Util.getParameter("codigo");
        String cod1=Util.getParameter("codigo1");
        nombrePresentacion=Util.getParameter("nombre");
        cantidadPresentacion=Util.getParameter("cantidad");
        //cod="1";
        //cod1="1";
        System.out.println("cxxxxxxxxxxxxxxxxxxxxxxxod:"+cod);
        if(cod!=null){
            setCodigo(cod);
        }
        if(cod1!=null){
            setCodigoPresPrim(cod1);
        }
        formulaMaestraDetalleEPList.clear();
        formulaMaestraDetalleEPList = cargarFormulaMaestraDetalleEP();
        cargarNombreComProd();
        return "";
        
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
        System.out.println("nombreComProd:"+nombreComProd);
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
    
    public List cargarFormulaMaestraDetalleEP(){
        List formulaMaestraDetalleEPList = new ArrayList();
        try {
            
            System.out.println("codigo:"+getCodigo());
            String sql="select fm.COD_FORMULA_MAESTRA,m.NOMBRE_MATERIAL,fmp.CANTIDAD,um.NOMBRE_UNIDAD_MEDIDA,m.cod_material,e.nombre_estado_registro";
            sql+=" from FORMULA_MAESTRA fm,MATERIALES m,UNIDADES_MEDIDA um,FORMULA_MAESTRA_DETALLE_EP fmp,estados_referenciales e";
            sql+=" where fm.COD_FORMULA_MAESTRA=fmp.COD_FORMULA_MAESTRA and um.COD_UNIDAD_MEDIDA=fmp.COD_UNIDAD_MEDIDA";
            sql+=" and m.COD_MATERIAL=fmp.COD_MATERIAL ";
            sql+=" and fmp.COD_MATERIAL IN(select m1.COD_MATERIAL from MATERIALES m1,grupos g where g.COD_GRUPO=m1.COD_GRUPO";
            sql+=" and g.COD_CAPITULO=3) and fmp.COD_FORMULA_MAESTRA='"+codigo+"' and fmp.COD_PRESENTACION_PRIMARIA='"+codigoPresPrim+"' and e.cod_estado_registro = m.cod_estado_registro";
            sql+=" order by m.NOMBRE_MATERIAL";
            System.out.println("sql>"+sql);
            setCon(Util.openConnection(getCon()));
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(sql);
            rs.last();
            int rows=rs.getRow();
            formulaMaestraDetalleEPList.clear();
            rs.first();
            for(int i=0;i<rows;i++){
                FormulaMaestraDetalleEP bean=new FormulaMaestraDetalleEP();
                bean.getFormulaMaestra().setCodFormulaMaestra(rs.getString(1));
                bean.getMateriales().setNombreMaterial(rs.getString(2));
                double cantidad = rs.getDouble(3);
                cantidad = redondear(cantidad, 3);
                NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
                DecimalFormat form = (DecimalFormat) nf;
                form.applyPattern("#,#00.0#");
                bean.setCantidad(form.format(cantidad));
                //bean.setCantidad(rs.getString(3));
                bean.getUnidadesMedida().setNombreUnidadMedida(rs.getString(4));
                bean.getMateriales().setCodMaterial(rs.getString(5));
                bean.getMateriales().getEstadoRegistro().setNombreEstadoRegistro(rs.getString("nombre_estado_registro"));
                formulaMaestraDetalleEPList.add(bean);
                rs.next();
            }
            if(rs!=null){
                rs.close();
                st.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return formulaMaestraDetalleEPList;
    }
    
       public double redondear(double numero, int decimales) {
        return Math.round(numero * Math.pow(10, decimales)) / Math.pow(10, decimales);
    }

    public String actionAgregar(){
        System.out.println("entro4656532");
        cargarMateriaPrima();
        //cargarUnidadesMedida("",null);
        System.out.println("enrreknkjlsdf"+getUnidadesMedidaList().size());
        return "actionAgregarFormulaMaestraDetalleEP";
    }
    public String cargarMateriaPrima(){
        
        try {
            System.out.println("entroooooooooooooooooooooooooooooooooo");
            formulaMaestraDetalleEPAdicionarList.clear();
            System.out.println("codigo:"+getCodigo());
            
            String sql="select m1.COD_MATERIAL,m1.NOMBRE_MATERIAL,um.ABREVIATURA,um.cod_unidad_medida " +
                    " from MATERIALES m1,grupos g,UNIDADES_MEDIDA um where g.COD_GRUPO=m1.COD_GRUPO";
            sql+=" and g.COD_CAPITULO=3 and m1.COD_MATERIAL <> ";
            sql+=" ALL(select fmp.COD_MATERIAL from FORMULA_MAESTRA_DETALLE_EP fmp " +
                    " where fmp.cod_formula_maestra='"+codigo+"' and " +
                    " fmp.cod_presentacion_primaria='"+codigoPresPrim+"')" +
                    " and m1.movimiento_item=1 and um.COD_UNIDAD_MEDIDA=m1.COD_UNIDAD_MEDIDA" +
                    " order by m1.NOMBRE_MATERIAL";
            
            System.out.println("sql:"+sql);
            setCon(Util.openConnection(getCon()));
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(sql);
            rs.last();
            int rows=rs.getRow();
            rs.first();
            for(int i=0;i<rows;i++){
                FormulaMaestraDetalleEP bean=new FormulaMaestraDetalleEP();
                bean.getMateriales().setCodMaterial(rs.getString(1));
                bean.getMateriales().setNombreMaterial(rs.getString(2));
                bean.getUnidadesMedida().setAbreviatura(rs.getString(3));
                bean.getUnidadesMedida().setCodUnidadMedida(rs.getString(4));
                bean.setCantidad("0");
                formulaMaestraDetalleEPAdicionarList.add(bean);
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
    public void cargarUnidadesMedida(String codigo,FormulaMaestraDetalleEP bean){
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
    public String guardarFormulaMaestraDetalleEP(){
        
        System.out.println("xxxxxxxxxxxxxxxx:"+getCodigo());
        //System.out.println("area_inferior:"+codigoAreaInferior);
        //managedFormulaMaestra.guardarVersionFormulaMaestra(codigo);
        List formulaMaestraDetalleEPAnteriorList = this.cargarFormulaMaestraDetalleEP();
        Iterator index=formulaMaestraDetalleEPAdicionarList.iterator();
        String sql="";
        int result=0;
        while (index.hasNext()){
            
            try {
                FormulaMaestraDetalleEP bean=(FormulaMaestraDetalleEP)index.next();
                if(bean.getChecked().booleanValue()){
                    setCon(Util.openConnection(getCon()));
                    sql="insert into FORMULA_MAESTRA_DETALLE_EP(COD_FORMULA_MAESTRA,COD_PRESENTACION_PRIMARIA,COD_MATERIAL,COD_UNIDAD_MEDIDA,CANTIDAD)values(" ;
                    sql+="'"+getCodigo()+"','"+codigoPresPrim+"','"+bean.getMateriales().getCodMaterial()+"','"+bean.getUnidadesMedida().getCodUnidadMedida()+"',"+bean.getCantidad()+")";
                    System.out.println("sql:"+sql);
                    PreparedStatement st1=getCon().prepareStatement(sql);
                    result=st1.executeUpdate();
                    System.out.println("result:"+result);
                }
                
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        formulaMaestraDetalleEPList = cargarFormulaMaestraDetalleEP();
        //managedFormulaMaestra.enviarCorreo("446,780,1195,826,1428,1479,2",formulaMaestraDetalleEPAnteriorList,formulaMaestraDetalleEPList,codigo,"EP");
        return "navegadorFormulaMaestraDetalleEP";
    }
    public String guardarEditarFormulaMaestraDetalleEP(){
        System.out.println("xxxxxxxxxxxxxxxx:"+getCodigo());
        //managedFormulaMaestra.guardarVersionFormulaMaestra(codigo);
        List formulaMaestraDetalleEPAnteriorList = this.cargarFormulaMaestraDetalleEP();
        Iterator index=formulaMaestraDetalleEPEditarList.iterator();
        String sql="";
        int result=0;
        double cantidad ;
        while (index.hasNext()){
            try {
                FormulaMaestraDetalleEP bean=(FormulaMaestraDetalleEP)index.next();
                setCon(Util.openConnection(getCon()));
                String cantidades = bean.getCantidad().replace(",","");
                sql  = " update formula_maestra_detalle_ep set ";
                sql += " cantidad = " + Float.parseFloat(cantidades);
                sql += " where COD_FORMULA_MAESTRA='"+getCodigo()+"' ";
                sql += " and COD_MATERIAL='" + bean.getMateriales().getCodMaterial()+"'";
                sql += " and cod_presentacion_primaria='"+codigoPresPrim+"'" ;
                Statement stmt = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                int rs = stmt.executeUpdate(sql);
                System.out.println("RESULTADO INSERCION-------->>> " + sql);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        formulaMaestraDetalleEPList = cargarFormulaMaestraDetalleEP();
        //managedFormulaMaestra.enviarCorreo("446,780,1195,826,1428,1479,2",formulaMaestraDetalleEPAnteriorList,formulaMaestraDetalleEPList,codigo,"EP");
        return "navegadorFormulaMaestraDetalleEP";
    }
    public String actionEditar(){
        Iterator index=formulaMaestraDetalleEPList.iterator();
        String sql="";
        int result=0;
        formulaMaestraDetalleEPEditarList.clear();
        while (index.hasNext()){
            FormulaMaestraDetalleEP bean=(FormulaMaestraDetalleEP)index.next();
            if(bean.getChecked().booleanValue()){
                formulaMaestraDetalleEPEditarList.add(bean);
            }
        }
        
        return "actionEditarFormulaMaestraDetalleEP";
    }
    public String cancelar(){
        formulaMaestraDetalleEPList= cargarFormulaMaestraDetalleEP();
        return "navegadorFormulaMaestraDetalleEP";
    }
    public String cancelar1(){
       
        return "cancelarEP";
    }
    public String actionEliminar(){
        Iterator index=formulaMaestraDetalleEPList.iterator();
        String sql="";
        int result=0;
        formulaMaestraDetalleEPEliminarList.clear();
        while (index.hasNext()){
            FormulaMaestraDetalleEP bean=(FormulaMaestraDetalleEP)index.next();
            if(bean.getChecked().booleanValue()){
                System.out.println("qwiuweiruweiopru"+bean.getUnidadesMedida().getCodUnidadMedida());
                formulaMaestraDetalleEPEliminarList.add(bean);
            }
        }
        
        return "actionEliminarFormulaMaestraDetalleEP";
    }
    
    public String guardarEliminarFormulaMaestraDetalleEP(){
        System.out.println("xxxxxxxxxxxxxxxx:"+getCodigo());
        //System.out.println("area_inferior:"+codigoAreaInferior);
        //managedFormulaMaestra.guardarVersionFormulaMaestra(codigo);
        List formulaMaestraDetalleEPAnteriorList = this.cargarFormulaMaestraDetalleEP();
        Iterator index=formulaMaestraDetalleEPEliminarList.iterator();
        String sql="";
        int result=0;
        while (index.hasNext()){            
            try {
                FormulaMaestraDetalleEP bean=(FormulaMaestraDetalleEP)index.next();
                if(bean.getChecked().booleanValue()){
                    setCon(Util.openConnection(getCon()));
                    sql="delete from FORMULA_MAESTRA_DETALLE_EP" +
                            " where COD_FORMULA_MAESTRA='"+getCodigo()+"' " +
                            " and COD_MATERIAL='"+bean.getMateriales().getCodMaterial()+"'" +
                            " and cod_presentacion_primaria='"+codigoPresPrim+"'" ;
                    System.out.println("sql Eliminar:"+sql);
                    PreparedStatement st1=getCon().prepareStatement(sql);
                    result=st1.executeUpdate();
                    //Statement st1 = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    //result=st1.executeUpdate(sql);
                    System.out.println("result:"+result);
      
                              
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        formulaMaestraDetalleEPList=cargarFormulaMaestraDetalleEP();
        //managedFormulaMaestra.enviarCorreo("446,780,1195,826,1428,1479,2",formulaMaestraDetalleEPAnteriorList,formulaMaestraDetalleEPList,codigo,"EP");
        return "navegadorFormulaMaestraDetalleEP";
    }

   
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
    
    public FormulaMaestraDetalleEP getFormulaMaestraDetalleEPbean() {
        return formulaMaestraDetalleEPbean;
    }
    
    public void setFormulaMaestraDetalleEPbean(FormulaMaestraDetalleEP formulaMaestraDetalleEPbean) {
        this.formulaMaestraDetalleEPbean = formulaMaestraDetalleEPbean;
    }
    
    public List getFormulaMaestraDetalleEPList() {
        return formulaMaestraDetalleEPList;
    }
    
    public void setFormulaMaestraDetalleEPList(List formulaMaestraDetalleEPList) {
        this.formulaMaestraDetalleEPList = formulaMaestraDetalleEPList;
    }
    
    public List getFormulaMaestraDetalleEPAdicionarList() {
        return formulaMaestraDetalleEPAdicionarList;
    }
    
    public void setFormulaMaestraDetalleEPAdicionarList(List formulaMaestraDetalleEPAdicionarList) {
        this.formulaMaestraDetalleEPAdicionarList = formulaMaestraDetalleEPAdicionarList;
    }
    
    public List getFormulaMaestraDetalleEPEliminarList() {
        return formulaMaestraDetalleEPEliminarList;
    }
    
    public void setFormulaMaestraDetalleEPEliminarList(List formulaMaestraDetalleEPEliminarList) {
        this.formulaMaestraDetalleEPEliminarList = formulaMaestraDetalleEPEliminarList;
    }
    
    public List getFormulaMaestraDetalleEPEditarList() {
        return formulaMaestraDetalleEPEditarList;
    }
    
    public void setFormulaMaestraDetalleEPEditarList(List formulaMaestraDetalleEPEditarList) {
        this.formulaMaestraDetalleEPEditarList = formulaMaestraDetalleEPEditarList;
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
    
    public String getCodigoPresPrim() {
        return codigoPresPrim;
    }
    
    public void setCodigoPresPrim(String codigoPresPrim) {
        this.codigoPresPrim = codigoPresPrim;
    }
    
    public String getNombreComProd() {
        return nombreComProd;
    }
    
    public void setNombreComProd(String nombreComProd) {
        this.nombreComProd = nombreComProd;
    }

    public String getNombrePresentacion() {
        return nombrePresentacion;
    }

    public void setNombrePresentacion(String nombrePresentacion) {
        this.nombrePresentacion = nombrePresentacion;
    }

    public String getCantidadPresentacion() {
        return cantidadPresentacion;
    }

    public void setCantidadPresentacion(String cantidadPresentacion) {
        this.cantidadPresentacion = cantidadPresentacion;
    }
    
    
}
