/*
 * ManagedTipoCliente.java
 * Created on 19 de febrero de 2008, 16:50
 */

package com.cofar.web;


import com.cofar.bean.FormulaMaestraDetalleMP;
import com.cofar.bean.FormulaMaestraEP;
import com.cofar.bean.FormulaMaestraES;
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
public class ManagedFormulaMaestraEP {
    
    /** Creates a new instance of ManagedTipoCliente */
    private FormulaMaestraEP formulaMaestraEPbean=new FormulaMaestraEP();
    private List formulaMaestraEPList=new ArrayList();
    private List formulaMaestraESList=new ArrayList();
    private List formulaMaestraEPAdicionarList=new ArrayList();
    private List formulaMaestraEPEliminarList=new ArrayList();
    private List formulaMaestraEPEditarList=new ArrayList();
    private List materialesList=new ArrayList();
    private Connection con;
    private String codigo="";
    private boolean swSi=false;
    private boolean swNo=false;
    private String nombreComProd="";
    
    public ManagedFormulaMaestraEP() {
        
    }
    public String getObtenerCodigo(){
        
        //String cod=Util.getParameter("codigo");
        String cod=Util.getParameter("codigo");
        //cod="1";
        System.out.println("cxxxxxxxxxxxxxxxxxxxxxxxod:"+cod);
        if(cod!=null){
            setCodigo(cod);
        }
        formulaMaestraEPList.clear();
        cargarFormulaMaestraEP();
        cargarFormulaMaestraES();
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
            while (rs.next())
                nombreComProd=rs.getString(1);
            
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
    
    public void cargarFormulaMaestraES(){
        
        try {
            
            System.out.println("codigo:"+getCodigo());
            String sql=" select es.NOMBRE_ENVASESEC,es.COD_ENVASESEC,pp.NOMBRE_PRODUCTO_PRESENTACION,";
            sql+=" pp.cantidad_presentacion ,pp.cod_presentacion";
            sql+=" from PRESENTACIONES_PRODUCTO pp,ENVASES_SECUNDARIOS es,PRODUCTOS p";
            sql+=" where es.COD_ENVASESEC=pp.COD_ENVASESEC and pp.cod_prod in (select cp.COD_PROD from COMPONENTES_PROD cp,FORMULA_MAESTRA fm ";
            sql+=" where fm.COD_COMPPROD=cp.COD_COMPPROD and fm.COD_FORMULA_MAESTRA='"+codigo+"' ) and p.cod_prod=pp.cod_prod";
            sql+=" order by es.NOMBRE_ENVASESEC ";

            sql= " select es.NOMBRE_ENVASESEC,es.COD_ENVASESEC,pp.NOMBRE_PRODUCTO_PRESENTACION, " +
                    " pp.cantidad_presentacion ,pp.cod_presentacion,TPP.NOMBRE_TIPO_PROGRAMA_PROD, tpp.COD_TIPO_PROGRAMA_PROD   " +
                    " from formula_maestra fm  " +
                    " inner join COMPONENTES_PROD cp on cp.COD_COMPPROD = fm.COD_COMPPROD " +
                    " inner join COMPONENTES_PRESPROD c on c.COD_COMPPROD = cp.COD_COMPPROD " +
                    " inner join PRESENTACIONES_PRODUCTO pp on pp.cod_presentacion = c.COD_PRESENTACION " +
                    " inner join ENVASES_SECUNDARIOS es on es.COD_ENVASESEC = pp.COD_ENVASESEC " +
                    " inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=c.COD_TIPO_PROGRAMA_PROD" +
                    " where fm.COD_FORMULA_MAESTRA = '"+codigo+"' ";
            
            System.out.println("sql>"+sql);
            setCon(Util.openConnection(getCon()));
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(sql);
            rs.last();
            int rows=rs.getRow();
            formulaMaestraESList.clear();
            rs.first();
            for(int i=0;i<rows;i++){
                FormulaMaestraES bean=new FormulaMaestraES();
                bean.getPresentacionesProducto().getEnvasesSecundarios().setNombreEnvaseSec(rs.getString(1));
                bean.getPresentacionesProducto().getEnvasesSecundarios().setCodEnvaseSec(rs.getString(2));
                bean.getPresentacionesProducto().setNombreProductoPresentacion(rs.getString(3));
                bean.getPresentacionesProducto().setCantidadPresentacion(rs.getString(4));
                bean.getPresentacionesProducto().setCodPresentacion(rs.getString(5));
                bean.getPresentacionesProducto().getTiposProgramaProduccion().setCodTipoProgramaProd(rs.getString("COD_TIPO_PROGRAMA_PROD"));
                bean.getPresentacionesProducto().getTiposProgramaProduccion().setNombreProgramaProd(rs.getString("NOMBRE_TIPO_PROGRAMA_PROD"));
                formulaMaestraESList.add(bean);
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
    
    public void cargarFormulaMaestraEP() {
        try {
            System.out.println((new StringBuilder()).append("codigo:").append(getCodigo()).toString());
            String sql = " select fep.COD_FORMULA_MAESTRA,ep.nombre_envaseprim,ep.cod_envaseprim,pp.CANTIDAD,pp.cod_presentacion_primaria";
            sql+= " from FORMULA_MAESTRA fep,PRESENTACIONES_PRIMARIAS pp,ENVASES_PRIMARIOS ep";
            sql+= " where PP.COD_COMPPROD=fep.COD_COMPPROD AND fep.COD_FORMULA_MAESTRA='"+codigo+"'";
            sql+= " and ep.cod_envaseprim=pp.cod_envaseprim";
            sql+= " order by ep.nombre_envaseprim";
            sql = " select fep.COD_FORMULA_MAESTRA,   ep.nombre_envaseprim,       ep.cod_envaseprim,       pp.CANTIDAD,  pp.cod_presentacion_primaria,pp.COD_TIPO_PROGRAMA_PROD" +
                    " ,tppr.NOMBRE_TIPO_PROGRAMA_PROD,pp.COD_ESTADO_REGISTRO,erf.NOMBRE_ESTADO_REGISTRO" +
                    " from FORMULA_MAESTRA fep  " +
                    " inner join PRESENTACIONES_PRIMARIAS pp on PP.COD_COMPPROD = fep.COD_COMPPROD " +
                    " inner join ENVASES_PRIMARIOS ep on ep.cod_envaseprim = pp.cod_envaseprim " +
                    " left outer join tipos_programa_produccion tppr on tppr.COD_TIPO_PROGRAMA_PROD = pp.COD_TIPO_PROGRAMA_PROD " +
                    " left outer join ESTADOS_REFERENCIALES erf on erf.COD_ESTADO_REGISTRO = pp.COD_ESTADO_REGISTRO      " +
                    " where fep.COD_FORMULA_MAESTRA = '"+codigo+"' order by ep.nombre_envaseprim  ";
            
            System.out.println("sql mm:"+sql);
            setCon(Util.openConnection(getCon()));
            Statement st = getCon().createStatement(1004, 1007);
            ResultSet rs = st.executeQuery(sql);
            rs.last();
            int rows = rs.getRow();
            formulaMaestraEPList.clear();
            rs.first();
            for(int i = 0; i < rows; i++) {
                FormulaMaestraEP bean = new FormulaMaestraEP();
                bean.getFormulaMaestra().setCodFormulaMaestra(rs.getString(1));
                bean.getPresentacionesPrimarias().getEnvasesPrimarios().setNombreEnvasePrim(rs.getString(2));
                bean.getPresentacionesPrimarias().getEnvasesPrimarios().setCodEnvasePrim(rs.getString(3));
                bean.getPresentacionesPrimarias().setCantidad(rs.getInt(4));
                bean.getPresentacionesPrimarias().setCodPresentacionPrimaria(rs.getString(5));
                bean.getPresentacionesPrimarias().getTiposProgramaProduccion().setCodTipoProgramaProd(rs.getString("COD_TIPO_PROGRAMA_PROD"));
                bean.getPresentacionesPrimarias().getTiposProgramaProduccion().setNombreTipoProgramaProd(rs.getString("NOMBRE_TIPO_PROGRAMA_PROD"));
                bean.getPresentacionesPrimarias().getEstadoReferencial().setCodEstadoRegistro(rs.getString("COD_ESTADO_REGISTRO"));
                bean.getPresentacionesPrimarias().getEstadoReferencial().setNombreEstadoRegistro(rs.getString("NOMBRE_ESTADO_REGISTRO"));
                formulaMaestraEPList.add(bean);
                rs.next();
            }
            
            if(rs != null) {
                rs.close();
                st.close();
            }
        } catch(SQLException e) {
            e.printStackTrace();
        }
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
    
    public FormulaMaestraEP getFormulaMaestraEPbean() {
        return formulaMaestraEPbean;
    }
    
    public void setFormulaMaestraEPbean(FormulaMaestraEP formulaMaestraEPbean) {
        this.formulaMaestraEPbean = formulaMaestraEPbean;
    }
    
    public List getFormulaMaestraEPList() {
        return formulaMaestraEPList;
    }
    
    public void setFormulaMaestraEPList(List formulaMaestraEPList) {
        this.formulaMaestraEPList = formulaMaestraEPList;
    }
    
    public List getFormulaMaestraEPAdicionarList() {
        return formulaMaestraEPAdicionarList;
    }
    
    public void setFormulaMaestraEPAdicionarList(List formulaMaestraEPAdicionarList) {
        this.formulaMaestraEPAdicionarList = formulaMaestraEPAdicionarList;
    }
    
    public List getFormulaMaestraEPEliminarList() {
        return formulaMaestraEPEliminarList;
    }
    
    public void setFormulaMaestraEPEliminarList(List formulaMaestraEPEliminarList) {
        this.formulaMaestraEPEliminarList = formulaMaestraEPEliminarList;
    }
    
    public List getFormulaMaestraEPEditarList() {
        return formulaMaestraEPEditarList;
    }
    
    public void setFormulaMaestraEPEditarList(List formulaMaestraEPEditarList) {
        this.formulaMaestraEPEditarList = formulaMaestraEPEditarList;
    }
    
    public List getMaterialesList() {
        return materialesList;
    }
    
    public void setMaterialesList(List materialesList) {
        this.materialesList = materialesList;
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
    
    public List getFormulaMaestraESList() {
        return formulaMaestraESList;
    }
    
    public void setFormulaMaestraESList(List formulaMaestraESList) {
        this.formulaMaestraESList = formulaMaestraESList;
    }
    
    
}
