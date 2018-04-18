/*
 * ManagedTipoCliente.java
 * Created on 19 de febrero de 2008, 16:50
 */

package com.cofar.web;

import com.cofar.bean.FormulaMaestraDetalleEP;
import com.cofar.bean.FormulaMaestraDetalleES;
import com.cofar.bean.Materiales;
import com.cofar.util.Util;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import javax.faces.model.SelectItem;

/**
 *
 *  @author Wilmer Manzaneda Chavez
 *  @company COFAR
 */
public class ManagedFormulaMaestraDetalleES {
    
    /** Creates a new instance of ManagedTipoCliente */
    private FormulaMaestraDetalleES formulaMaestraDetalleESbean=new FormulaMaestraDetalleES();
    private List formulaMaestraDetalleESList=new ArrayList();
    private List formulaMaestraDetalleESAdicionarList=new ArrayList();
    private List formulaMaestraDetalleESEliminarList=new ArrayList();
    private List formulaMaestraDetalleESEditarList=new ArrayList();
    private List materialesList=new ArrayList();
    private List unidadesMedidaList=new ArrayList();
    private Connection con;
    private String codigo="";
    private boolean swSi=false;
    private boolean swNo=false;
    private String nombreComProd="";
    private String codPresProducto="";
    private String nombrePresentacion="";
    private String cantidadPresentacion="";
    private ManagedFormulaMaestra managedFormulaMaestra = new ManagedFormulaMaestra();
    private String codTipoProgProd="";
    private String nombreTipoProgProd="";
    public ManagedFormulaMaestraDetalleES() {
        
    }
    public String getObtenerCodigo(){
        //String cod=Util.getParameter("codigo");
        String cod=Util.getParameter("codigo");
        String cod1=Util.getParameter("codigo1");
        nombrePresentacion=Util.getParameter("nombre");
        cantidadPresentacion=Util.getParameter("cantidad");
        //cod="1";
        //inicio ale tipo
        if(Util.getParameter("codTipoProg")!=null)
        {
            codTipoProgProd=Util.getParameter("codTipoProg");
        }
        if(Util.getParameter("nombreTipoProg")!=null)
        {
            nombreTipoProgProd=Util.getParameter("nombreTipoProg");
        }
        System.out.println("nom "+nombreTipoProgProd+"cods "+cod+"cod1"+cod1+"codTipoProgProd" + codTipoProgProd);
        //final ale tipo
        System.out.println("cxxxxxxxxxxxxxxxxxxxxxxxod:"+cod);
        if(cod!=null){
            setCodigo(cod);
        }
        if(cod1!=null){
            codPresProducto=cod1;
        }
        formulaMaestraDetalleESList.clear();
        formulaMaestraDetalleESList = cargarFormulaMaestraDetalleES();
        cargarNombreComProd();
        return "";
        

    }
    public String cancelar(){
        formulaMaestraDetalleESList = cargarFormulaMaestraDetalleES();
        return "navegadorFormulaMaestraDetalleES";
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
    
    public List cargarFormulaMaestraDetalleES(){
        List formulaMaestraDetalleESList = new ArrayList();
        try {
            System.out.println("codigo:"+getCodigo());
            String sql="select fm.COD_FORMULA_MAESTRA,m.NOMBRE_MATERIAL,fmp.CANTIDAD,um.NOMBRE_UNIDAD_MEDIDA,m.cod_material,e.nombre_estado_registro";
            sql+=" from FORMULA_MAESTRA fm,MATERIALES m,UNIDADES_MEDIDA um,FORMULA_MAESTRA_DETALLE_ES fmp,estados_referenciales e";
            sql+=" where fm.COD_FORMULA_MAESTRA=fmp.COD_FORMULA_MAESTRA and um.COD_UNIDAD_MEDIDA=fmp.COD_UNIDAD_MEDIDA";
            sql+=" and m.COD_MATERIAL=fmp.COD_MATERIAL ";
            sql+=" and fmp.COD_MATERIAL IN(select m1.COD_MATERIAL from MATERIALES m1,grupos g where g.COD_GRUPO=m1.COD_GRUPO";
            sql+=" and g.COD_CAPITULO IN (4,8)) and fm.COD_FORMULA_MAESTRA='"+getCodigo()+"' and fmp.cod_presentacion_producto='"+codPresProducto+"' and m.cod_estado_registro = e.cod_estado_registro ";
            sql+=" and fmp.COD_TIPO_PROGRAMA_PROD='"+codTipoProgProd+"'";
            sql+=" order by m.NOMBRE_MATERIAL";
            System.out.println("sql>"+sql);
            setCon(Util.openConnection(getCon()));
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(sql);
            rs.last();
            int rows=rs.getRow();
            formulaMaestraDetalleESList.clear();
            rs.first();
            
           
            
            for(int i=0;i<rows;i++){
                FormulaMaestraDetalleES bean=new FormulaMaestraDetalleES();
                bean.getFormulaMaestra().setCodFormulaMaestra(rs.getString(1));
                bean.getMateriales().setNombreMaterial(rs.getString(2));
                double cantidad = rs.getDouble(3);
                cantidad = redondear(cantidad, 3);
                NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
                DecimalFormat form = (DecimalFormat) nf;
                form.applyPattern("#,#00.0#");
                bean.setCantidad(cantidad);
                bean.getUnidadesMedida().setNombreUnidadMedida(rs.getString(4));
                bean.getMateriales().setCodMaterial(rs.getString(5));
                bean.getMateriales().getEstadoRegistro().setNombreEstadoRegistro(rs.getString("nombre_estado_registro"));
                formulaMaestraDetalleESList.add(bean);
                rs.next();
            }            
            if(rs!=null){
                rs.close();
                st.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return formulaMaestraDetalleESList;
    }
    
    public double redondear(double numero, int decimales) {
        return Math.round(numero * Math.pow(10, decimales)) / Math.pow(10, decimales);
    }
    
    
    public String actionAgregar(){
        System.out.println("entro4656532");
        cargarMateriaPrima();
        //cargarUnidadesMedida("",null);
        System.out.println("enrreknkjlsdf"+getUnidadesMedidaList().size());
        return "actionAgregarFormulaMaestraDetalleES";
    }
    public String cargarMateriaPrima(){
        try {
            System.out.println("entroooooooooooooooooooooooooooooooooo");
            formulaMaestraDetalleESAdicionarList.clear();
            System.out.println("codigo:"+getCodigo());
            
            String sql="select m1.COD_MATERIAL,m1.NOMBRE_MATERIAL,um.ABREVIATURA,um.cod_unidad_medida " +
                    " from MATERIALES m1,grupos g,UNIDADES_MEDIDA um where g.COD_GRUPO=m1.COD_GRUPO";
            sql+=" and g.COD_CAPITULO IN (4,8) and m1.COD_MATERIAL <> ";
            sql+=" ALL(select fmp.COD_MATERIAL from FORMULA_MAESTRA_DETALLE_ES fmp " +
                    " where fmp.cod_formula_maestra='"+codigo+"' and m1.movimiento_item=1  and fmp.cod_presentacion_producto='"+codPresProducto+"')" +
                    " and um.COD_UNIDAD_MEDIDA=m1.COD_UNIDAD_MEDIDA";
            sql+=" order by m1.NOMBRE_MATERIAL";
            System.out.println("sql:"+sql);
            setCon(Util.openConnection(getCon()));
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(sql);
            rs.last();
            int rows=rs.getRow();
            rs.first();   
            

            
            for(int i=0;i<rows;i++){
                FormulaMaestraDetalleES bean=new FormulaMaestraDetalleES();
                bean.getMateriales().setCodMaterial(rs.getString(1));
                bean.getMateriales().setNombreMaterial(rs.getString(2));
                bean.getUnidadesMedida().setAbreviatura(rs.getString(3));
                bean.getUnidadesMedida().setCodUnidadMedida(rs.getString(4));
                bean.setCantidad(0d);
                formulaMaestraDetalleESAdicionarList.add(bean);
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
    public void cargarUnidadesMedida(String codigo,FormulaMaestraDetalleES bean){
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
    public String guardarFormulaMaestraDetalleES(){
        
        System.out.println("xxxxxxxxxxxxxxxx:"+getCodigo());
        //System.out.println("area_inferior:"+codigoAreaInferior);
        //managedFormulaMaestra.guardarVersionFormulaMaestra(codigo);
        List formulaMaestraDetalleESAnteriorList = this.cargarFormulaMaestraDetalleES();
        Iterator index=formulaMaestraDetalleESAdicionarList.iterator();
        String sql="";
        int result=0;
        while (index.hasNext()){
            try {
                FormulaMaestraDetalleES bean=(FormulaMaestraDetalleES)index.next();
                if(bean.getChecked().booleanValue()){
                    setCon(Util.openConnection(getCon()));
                    sql="insert into FORMULA_MAESTRA_DETALLE_ES(COD_FORMULA_MAESTRA,COD_PRESENTACION_PRODUCTO,COD_MATERIAL,COD_UNIDAD_MEDIDA,CANTIDAD,COD_TIPO_PROGRAMA_PROD)values(" ;
                    sql+="'"+getCodigo()+"','"+codPresProducto+"','"+bean.getMateriales().getCodMaterial()+"','"+bean.getUnidadesMedida().getCodUnidadMedida()+"',"+bean.getCantidad()+",'"+codTipoProgProd+"')";
                    System.out.println("sql:"+sql);
                    PreparedStatement st1=getCon().prepareStatement(sql);
                    result=st1.executeUpdate();
                    System.out.println("result:"+result);
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        formulaMaestraDetalleESList = cargarFormulaMaestraDetalleES();
        //managedFormulaMaestra.enviarCorreo("446,780,1195,826,1428,1479,2",formulaMaestraDetalleESAnteriorList,formulaMaestraDetalleESList,codigo,"ES");
        return "navegadorFormulaMaestraDetalleES";
    }
    
    public String guardarEditarFormulaMaestraDetalleES(){
        System.out.println("xxxxxxxxxxxxxxxx:"+getCodigo());
        //System.out.println("area_inferior:"+codigoAreaInferior);
        //managedFormulaMaestra.guardarVersionFormulaMaestra(codigo);
        List formulaMaestraDetalleESAnteriorList = this.cargarFormulaMaestraDetalleES();
        Iterator index=formulaMaestraDetalleESEditarList.iterator();
        String sql="";
        int result=0;
        while (index.hasNext()){
            try {
                FormulaMaestraDetalleES bean=(FormulaMaestraDetalleES)index.next();
                setCon(Util.openConnection(getCon()));
                sql="update FORMULA_MAESTRA_DETALLE_ES set" +
                        " CANTIDAD = " + bean.getCantidad() + " " +
                        " where COD_FORMULA_MAESTRA='"+getCodigo()+"' and " +
                        " COD_MATERIAL='"+bean.getMateriales().getCodMaterial()+"'" +
                        " and cod_presentacion_producto='"+codPresProducto+"'"+
                        " and COD_TIPO_PROGRAMA_PROD='"+codTipoProgProd+"'";
                System.out.println("sql:"+sql);
                PreparedStatement st1=getCon().prepareStatement(sql);
                result=st1.executeUpdate();
                System.out.println("result:"+result);                
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        formulaMaestraDetalleESList = cargarFormulaMaestraDetalleES();
        //managedFormulaMaestra.enviarCorreo("446,780,1195,826,1428,1479,2",formulaMaestraDetalleESAnteriorList,formulaMaestraDetalleESList,codigo,"ES");
        return "navegadorFormulaMaestraDetalleES";
    }
    public String actionEditar(){
        Iterator index=formulaMaestraDetalleESList.iterator();
        String sql="";
        int result=0;
        formulaMaestraDetalleESEditarList.clear();
        while (index.hasNext()){
            FormulaMaestraDetalleES bean=(FormulaMaestraDetalleES)index.next();
            if(bean.getChecked().booleanValue()){
                System.out.println("qwiuweiruweiopru"+bean.getUnidadesMedida().getCodUnidadMedida());
                formulaMaestraDetalleESEditarList.add(bean);
            }
        }
        
        return "actionEditarFormulaMaestraDetalleES";
    }
    public String actionEliminar(){
        Iterator index=formulaMaestraDetalleESList.iterator();
        String sql="";
        int result=0;
        formulaMaestraDetalleESEliminarList.clear();
        while (index.hasNext()){
            FormulaMaestraDetalleES bean=(FormulaMaestraDetalleES)index.next();
            if(bean.getChecked().booleanValue()){
                System.out.println("qwiuweiruweiopru"+bean.getUnidadesMedida().getCodUnidadMedida());
                formulaMaestraDetalleESEliminarList.add(bean);
            }
        }
        
        return "actionEliminarFormulaMaestraDetalleES";
    }
    
    public String guardarEliminarFormulaMaestraDetalleES(){
        System.out.println("xxxxxxxxxxxxxxxx:"+getCodigo());        
        Iterator index=formulaMaestraDetalleESEliminarList.iterator();
        //managedFormulaMaestra.guardarVersionFormulaMaestra(codigo);
        List formulaMaestraDetalleESAnteriorList = this.cargarFormulaMaestraDetalleES();
        String sql="";
        int result=0;
        while (index.hasNext()){
            try {
                FormulaMaestraDetalleES bean=(FormulaMaestraDetalleES)index.next();
                if(bean.getChecked().booleanValue()){
                    setCon(Util.openConnection(getCon()));
                    sql="delete from FORMULA_MAESTRA_DETALLE_ES" +
                            " where COD_FORMULA_MAESTRA='"+getCodigo()+"' and" +
                            " COD_MATERIAL='"+bean.getMateriales().getCodMaterial()+"'" +
                            " and cod_presentacion_producto='"+codPresProducto+"'"+
                            " and COD_TIPO_PROGRAMA_PROD='"+codTipoProgProd+"'";
                    System.out.println("sql Eliminar:"+sql);
                  //  PreparedStatement st1=getCon().prepareStatement(sql);
                  //  result=st1.executeUpdate();
                    Statement stmt = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    result = stmt.executeUpdate(sql);
                    System.out.println("result:"+result);
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        formulaMaestraDetalleESList = cargarFormulaMaestraDetalleES();
        //managedFormulaMaestra.enviarCorreo("446,780,1195,826,1428,1479,2",formulaMaestraDetalleESAnteriorList,formulaMaestraDetalleESList,codigo,"ES");
        return "navegadorFormulaMaestraDetalleES";
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
    
    public FormulaMaestraDetalleES getFormulaMaestraDetalleESbean() {
        return formulaMaestraDetalleESbean;
    }
    
    public void setFormulaMaestraDetalleESbean(FormulaMaestraDetalleES formulaMaestraDetalleESbean) {
        this.formulaMaestraDetalleESbean = formulaMaestraDetalleESbean;
    }
    
    public List getFormulaMaestraDetalleESList() {
        return formulaMaestraDetalleESList;
    }
    
    public void setFormulaMaestraDetalleESList(List formulaMaestraDetalleESList) {
        this.formulaMaestraDetalleESList = formulaMaestraDetalleESList;
    }
    
    public List getFormulaMaestraDetalleESAdicionarList() {
        return formulaMaestraDetalleESAdicionarList;
    }
    
    public void setFormulaMaestraDetalleESAdicionarList(List formulaMaestraDetalleESAdicionarList) {
        this.formulaMaestraDetalleESAdicionarList = formulaMaestraDetalleESAdicionarList;
    }
    
    public List getFormulaMaestraDetalleESEliminarList() {
        return formulaMaestraDetalleESEliminarList;
    }
    
    public void setFormulaMaestraDetalleESEliminarList(List formulaMaestraDetalleESEliminarList) {
        this.formulaMaestraDetalleESEliminarList = formulaMaestraDetalleESEliminarList;
    }
    
    public List getFormulaMaestraDetalleESEditarList() {
        return formulaMaestraDetalleESEditarList;
    }
    
    public void setFormulaMaestraDetalleESEditarList(List formulaMaestraDetalleESEditarList) {
        this.formulaMaestraDetalleESEditarList = formulaMaestraDetalleESEditarList;
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
    
    public String getCodPresProducto() {
        return codPresProducto;
    }
    
    public void setCodPresProducto(String codPresProducto) {
        this.codPresProducto = codPresProducto;
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

    public String getNombreTipoProgProd() {
        return nombreTipoProgProd;
    }

    public void setNombreTipoProgProd(String nombreTipoProgProd) {
        this.nombreTipoProgProd = nombreTipoProgProd;
    }
    
}
