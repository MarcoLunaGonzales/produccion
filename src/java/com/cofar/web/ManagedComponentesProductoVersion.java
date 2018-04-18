/*
 * ManagedTipoCliente.java
 * Created on 19 de febrero de 2008, 16:50
 */

package com.cofar.web;

import com.cofar.bean.ComponentesProd;
import com.cofar.bean.AccionesTerapeuticas;
import com.cofar.bean.ComponentesPresProd;
import com.cofar.bean.EspecificacionesFisicasProducto;
import com.cofar.bean.EspecificacionesMicrobiologiaProducto;
import com.cofar.bean.EspecificacionesQuimicasCc;
import com.cofar.bean.EspecificacionesQuimicasProducto;
import com.cofar.bean.MaquinariaActividadesFormula;
import com.cofar.bean.Materiales;
import com.cofar.bean.PresentacionesPrimarias;
import com.cofar.bean.PrincipiosActivosProducto;
import com.cofar.bean.ViasAdministracionProducto;
import com.cofar.util.Util;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import javax.faces.context.ExternalContext;
import javax.faces.context.FacesContext;
import javax.faces.event.ActionEvent;
import javax.faces.event.ValueChangeEvent;
import javax.faces.model.ResultDataModel;
import javax.faces.model.SelectItem;
import javax.servlet.jsp.jstl.sql.ResultSupport;
import org.ajax4jsf.component.html.HtmlAjaxCommandLink;
import org.richfaces.component.html.HtmlDataTable;

/**
 *
 *  @author Wilmer Manzaneda Chavez
 *  @company COFAR
 */
public class ManagedComponentesProductoVersion extends ManagedBean{
    
    /** Creates a new instance of ManagedTipoCliente */
    private ComponentesProd componentesProdbean=new ComponentesProd();
    private List componentesProductoList=new ArrayList();
    private List componentesProductoEliminar=new ArrayList();
    private List componentesProductoNoEliminar=new ArrayList();
    private Connection con;
    private List productosList=new  ArrayList();
    private List detalleList=new  ArrayList();
    private List productosFormasFarList=new ArrayList();
    private List saboresProductoList = new ArrayList();
    private List envasesPrimariosList=new  ArrayList();
    private List coloresProductoList=new  ArrayList();
    private List areasEmpresaList=new ArrayList();
    private List estadoRegistro=new  ArrayList();
    private String codigo="";
    private String nombreProducto="";
    private boolean swEliminaSi;
    private boolean swEliminaNo;
    private List productosproceso=new ArrayList();
    private List presentacionesPrimariasList=new ArrayList();
    private String codigoPP="";
    private PresentacionesPrimarias presentacionesPrimarias=new PresentacionesPrimarias();
    private String nombreComProd="";
    private ResultDataModel resultado=new ResultDataModel();
    private List accionesTerapeuticasList=new ArrayList();
    private List estadosCompProdList=new ArrayList();
    private String accionTerapeutica ="";
    private List tiposProgramaProduccionList = new ArrayList();
    private List estadoRegistroList = new ArrayList();
    private PresentacionesPrimarias presentacionesPrimariasEditar = new PresentacionesPrimarias();
    private HtmlDataTable componentesProdDataTable = new HtmlDataTable();
    private ComponentesProd componentesProd = new ComponentesProd();
    private List componentesPresProdList = new ArrayList();
    private ComponentesPresProd componentesPresProd = new ComponentesPresProd();
    private List presentacionesSecundariasList = new ArrayList();
    private ComponentesPresProd componentesPresProdEditar = new ComponentesPresProd();
    private List<Materiales> listaMaterialesPrincipioActivo=new ArrayList<Materiales>();
    private List<EspecificacionesFisicasProducto> listaEspecificacionesFisicasProducto= new ArrayList<EspecificacionesFisicasProducto>();
    private List<EspecificacionesQuimicasCc> listaEspecificacionesQuimicasCc= new ArrayList<EspecificacionesQuimicasCc>();
    private List<SelectItem> listaTiposReferenciaCc= new ArrayList<SelectItem>();
    private List<EspecificacionesMicrobiologiaProducto> listaEspecificacionesMicrobiologia= new ArrayList<EspecificacionesMicrobiologiaProducto>();
    //private List tiposProduccionList = new ArrayList();
    private List<SelectItem> tiposProduccionList=new ArrayList<SelectItem>();
    private String mensaje="";
    private List<String> presentacionesProducto=new ArrayList<String>();
    private boolean  agregarEdicionProd=false;
    private boolean editarRs=false;
    private boolean editarTipoProd=false;
    private boolean opcionPresPrim=false;
    private boolean opcionPresSecun=false;
    private List<ViasAdministracionProducto> viasAdministracionProductoList=new ArrayList<ViasAdministracionProducto>();
    private ViasAdministracionProducto viasAdministracionProductoBean=new ViasAdministracionProducto();
    private List<SelectItem> viasAdministracionSelectList=new ArrayList<SelectItem>();
    private List<SelectItem> unidadesMedidadSelectList=new ArrayList<SelectItem>();
    public ManagedComponentesProductoVersion() {
        
        //this.cargarTiposProduccion(true);
    }

    private void cargarUnidadesMedidaSelect()
    {
        try
        {
            Connection con1=null;
            con1=Util.openConnection(con1);
            Statement st=con1.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select um.COD_UNIDAD_MEDIDA,um.ABREVIATURA as unidadMedida"+
                            " from UNIDADES_MEDIDA um where um.COD_ESTADO_REGISTRO=1 order by um.NOMBRE_UNIDAD_MEDIDA";
            ResultSet res=st.executeQuery(consulta);
            unidadesMedidadSelectList.clear();
            unidadesMedidadSelectList.add(new SelectItem("0","-Ninguno-"));
            while(res.next())
            {
                unidadesMedidadSelectList.add(new SelectItem(res.getString("COD_UNIDAD_MEDIDA"),res.getString("unidadMedida")));
            }
            st.close();
            con1.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
    }
    private void cargarViasAdministracionSelect()
    {
        try
        {
            Connection con1=null;
            con1=Util.openConnection(con1);
            Statement st=con1.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select vap.COD_VIA_ADMINISTRACION_PRODUCTO,vap.NOMBRE_VIA_ADMINISTRACION_PRODUCTO "+
                            " from VIAS_ADMINISTRACION_PRODUCTO vap "+
                            " where vap.COD_ESTADO_REGISTRO=1"+
                            " order by vap.NOMBRE_VIA_ADMINISTRACION_PRODUCTO";
            viasAdministracionSelectList.clear();
            viasAdministracionSelectList.add(new SelectItem(0,"-Ninguno-"));
            ResultSet res=st.executeQuery(consulta);
            while(res.next())
            {
                viasAdministracionSelectList.add(new SelectItem(res.getInt("COD_VIA_ADMINISTRACION_PRODUCTO"),res.getString("NOMBRE_VIA_ADMINISTRACION_PRODUCTO")));
            }
            res.close();
            st.close();
            con1.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
    }
    public String agregarViasAdministracionProducto_action()
    {
        viasAdministracionProductoBean=new ViasAdministracionProducto();
        return null;
    }
    public String editarViasAdministracionProducto_action()
    {
        for(ViasAdministracionProducto bean:viasAdministracionProductoList)
        {
            if(bean.getChecked())
            {
                viasAdministracionProductoBean=bean;
            }
        }
        return null;
    }
    public String guardarEdicionViaAdministracionProducto_action()throws SQLException
    {
        Connection con1=null;
        mensaje="";
        try
        {
            con1=Util.openConnection(con1);
            con1.setAutoCommit(false);
            String consulta="UPDATE VIAS_ADMINISTRACION_PRODUCTO"+
                           " SET NOMBRE_VIA_ADMINISTRACION_PRODUCTO = '"+viasAdministracionProductoBean.getNombreViaAdministracionProducto()+"',"+
                           " COD_ESTADO_REGISTRO = '"+viasAdministracionProductoBean.getEstadoRegistro().getCodEstadoRegistro()+"'"+
                           " WHERE COD_VIA_ADMINISTRACION_PRODUCTO = '"+viasAdministracionProductoBean.getCodViaAdministracionProducto()+"'";
            System.out.println("consulta update via administracion "+consulta);
            PreparedStatement pst=con1.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se actualizo la informacion del producto ");
            con1.commit();
            mensaje="1";
            pst.close();
            con1.close();
        }
        catch(SQLException ex)
        {
            mensaje="Ocurrio un error al momento de edigat la vida de administracion,intente de nuevo";
            con1.rollback();
            con1.close();
            ex.printStackTrace();
        }
        if(mensaje.equals("1"))
        {
            this.cargarViasAdministracionProducto();
        }
        return null;
    }
    public String eliminarViaAdministracionProducto_action()throws SQLException
    {
        Connection con1=null;
        mensaje="";
        for(ViasAdministracionProducto bean:viasAdministracionProductoList)
        {
            if(bean.getChecked())
            {
                try
                {
                    con1=Util.openConnection(con1);
                    con1.setAutoCommit(false);
                    String consulta="delete VIAS_ADMINISTRACION_PRODUCTO where COD_VIA_ADMINISTRACION_PRODUCTO='"+bean.getCodViaAdministracionProducto()+"'";
                    System.out.println("consulta delete via administracion "+consulta);
                    PreparedStatement pst=con1.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)System.out.println("se elimino la via de administracion");
                    con1.commit();
                    mensaje="1";
                    pst.close();
                    con1.close();
                }
                catch(SQLException ex)
                {
                    mensaje="Ocurrion un error al momento de eliminar la via de administracion,intente de nuevo";
                    con1.rollback();
                    con1.close();
                    ex.printStackTrace();
                }
            }
        }
        if(mensaje.equals("1"))
        {
            this.cargarViasAdministracionProducto();
        }
        return null;
    }
    public String guardarNuevaViaAdministracionProducto_action()throws SQLException
    {
        Connection con1=null;
        mensaje="";
        try
        {
            con1=Util.openConnection(con1);
            con1.setAutoCommit(false);
            String consulta="select isnull(max(vap.COD_VIA_ADMINISTRACION_PRODUCTO),0)+1 as codVia from VIAS_ADMINISTRACION_PRODUCTO vap";
            Statement st=con1.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta);
            String codVia="";
            if(res.next())
            {
                codVia=res.getString("codVia");
            }
            consulta="INSERT INTO VIAS_ADMINISTRACION_PRODUCTO(COD_VIA_ADMINISTRACION_PRODUCTO,"+
                            " NOMBRE_VIA_ADMINISTRACION_PRODUCTO, COD_ESTADO_REGISTRO)"+
                            " VALUES ('"+codVia+"','"+viasAdministracionProductoBean.getNombreViaAdministracionProducto()+"',"+
                            " 1)";
            System.out.println("consulta insert via adm "+consulta);
            PreparedStatement pst=con1.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se registro la vida de administracion");
            con1.commit();
            mensaje="1";
            pst.close();
            st.close();
            con1.close();
        }
        catch(SQLException ex)
        {
            con1.rollback();
            mensaje="Ocurrio un error al momento de registrar la via de administracion, intente de nuevo";
            con1.close();
            ex.printStackTrace();
        }
        if(mensaje.equals("1"))
        {
            this.cargarViasAdministracionProducto();
        }
        return null;
    }
    public String getCargarViasAdministracioProducto()
    {
        this.cargarViasAdministracionProducto();
        return null;
    }
    private void cargarViasAdministracionProducto()
    {
        try
        {
            Connection con1=null;
            con1=Util.openConnection(con1);
            Statement st=con1.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select vap.COD_VIA_ADMINISTRACION_PRODUCTO,vap.NOMBRE_VIA_ADMINISTRACION_PRODUCTO,"+
                            " er.COD_ESTADO_REGISTRO,er.NOMBRE_ESTADO_REGISTRO"+
                            " from VIAS_ADMINISTRACION_PRODUCTO vap inner join ESTADOS_REFERENCIALES er"+
                            " on er.COD_ESTADO_REGISTRO=vap.COD_ESTADO_REGISTRO"+
                            " order by vap.NOMBRE_VIA_ADMINISTRACION_PRODUCTO";
            ResultSet res=st.executeQuery(consulta);
            viasAdministracionProductoList.clear();
            while(res.next())
            {
                ViasAdministracionProducto nuevo=new ViasAdministracionProducto();
                nuevo.setCodViaAdministracionProducto(res.getInt("COD_VIA_ADMINISTRACION_PRODUCTO"));
                nuevo.setNombreViaAdministracionProducto(res.getString("NOMBRE_VIA_ADMINISTRACION_PRODUCTO"));
                nuevo.getEstadoRegistro().setCodEstadoRegistro(res.getString("COD_ESTADO_REGISTRO"));
                nuevo.getEstadoRegistro().setNombreEstadoRegistro(res.getString("NOMBRE_ESTADO_REGISTRO"));
                viasAdministracionProductoList.add(nuevo);
            }
            res.close();
            st.close();
            con1.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
    }
    public void cargarProductosProceso(){
        try {
            con=Util.openConnection(con);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
    }
    /**
     * metodo que genera los codigos
     * correlativamente
     */
    private void establecerOpcionesCompProd()
    {
        try
        {
            ManagedAccesoSistema usuario=(ManagedAccesoSistema)Util.getSession("ManagedAccesoSistema");
            con=Util.openConnection(con);
            System.out.println(usuario.getUsuarioModuloBean().getCodUsuarioGlobal());
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select top 1 * from PERMISOS_COMPONENTES_PROD p where p.COD_PERSONAL='"+usuario.getUsuarioModuloBean().getCodUsuarioGlobal()+"'" +
                    " and p.COD_TIPO_PERMISO=1";
            System.out.println("consulta perm 1 "+consulta);
            ResultSet res=st.executeQuery(consulta);
            agregarEdicionProd=res.next();
            consulta="select top 1 * from PERMISOS_COMPONENTES_PROD p where p.COD_PERSONAL='"+usuario.getUsuarioModuloBean().getCodUsuarioGlobal()+"'" +
                    " and p.COD_TIPO_PERMISO=2";
            System.out.println("consulta perm 2 "+consulta );
            res=st.executeQuery(consulta);
            editarRs=res.next();
            consulta="select top 1 * from PERMISOS_COMPONENTES_PROD p where p.COD_PERSONAL='"+usuario.getUsuarioModuloBean().getCodUsuarioGlobal()+"'" +
                    " and p.COD_TIPO_PERMISO=3";
            System.out.println("consulta perm 3 "+consulta);
            res=st.executeQuery(consulta);
            editarTipoProd=res.next();
            consulta="select top 1 * from PERMISOS_COMPONENTES_PROD p where p.COD_PERSONAL='"+usuario.getUsuarioModuloBean().getCodUsuarioGlobal()+"'" +
                    " and p.COD_TIPO_PERMISO=4";
            System.out.println("consulta perm 3 "+consulta);
            res=st.executeQuery(consulta);
            opcionPresPrim=res.next();
            consulta="select top 1 * from PERMISOS_COMPONENTES_PROD p where p.COD_PERSONAL='"+usuario.getUsuarioModuloBean().getCodUsuarioGlobal()+"'" +
                    " and p.COD_TIPO_PERMISO=5";
            System.out.println("consulta perm 3 "+consulta);
            res=st.executeQuery(consulta);
            opcionPresSecun=res.next();
            st.close();
            con.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
        catch(Exception ex)
        {
            ex.printStackTrace();
        }
    }
    public String getObtenerCodigo(){
        //componentesProdbean=new ComponentesProd();
        tiposProduccionList = this.cargarTipoProduccion();
        cargarEstadoCompProd("",null);
        componentesProdbean.getProducto().setCodProducto("0");
        this.establecerOpcionesCompProd();
        String cod=Util.getParameter("codigo");
        System.out.println("cxxxxxxxxxxxxxxxxxxxxxxxod:"+cod);
        if(cod!=null){
            setCodigo(cod);
        }
        this.cargarUnidadesMedidaSelect();
        cargarViasAdministracionSelect();
        cargarComponentesProducto1();
        cargarProductos("",null);
        this.cargarEnvasePrimarios();
        //cargarNombreProducto();

        
        
        return "";
        
    }
    public String getCodigoProductosVenta(){
        String codigo="1";
        try {
            setCon(Util.openConnection(getCon()));
            String sql="select max(cod_compprod)+1 from componentes_prod";
            PreparedStatement st=getCon().prepareStatement(sql);
            ResultSet rs=st.executeQuery();
            while (rs.next())
                codigo=rs.getString(1);
            if(codigo==null)
                codigo="1";
            
            getComponentesProdbean().setCodCompprod(codigo);
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return  "";
    }
    
    
    public String CancelarProducto(){
        return"CancelarProductos";
    }
    
    public void cargarProductos(String cod,ComponentesProd bean){
        try {
            setCon(Util.openConnection(getCon()));
            String sql="select cod_prod,nombre_prod from productos" +
                    " where cod_estado_prod=1" ;
            
            System.out.println("select ALL:"+sql);
            ResultSet rs=null;
            
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            if(!cod.equals("")){
                sql+=" and cod_prod="+cod;
                System.out.println("update:"+sql);
                rs=st.executeQuery(sql);
                if(rs.next()){
                    bean.getProducto().setCodProducto(rs.getString(1));
                    bean.getProducto().setNombreProducto(rs.getString(2));
                }
            } else{
                sql+=" order by nombre_prod";
                productosList.clear();
                rs=st.executeQuery(sql);
                productosList.add(new SelectItem("0",""));
                while (rs.next())
                    productosList.add(new SelectItem(rs.getString(1),rs.getString(2)));
            }
            if(rs!=null){
                rs.close();st.close();
                rs=null;st=null;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    public void cargarEstadoCompProd(String cod,ComponentesProd bean){
        try {
            setCon(Util.openConnection(getCon()));
            String sql="select COD_ESTADO_COMPPROD,NOMBRE_ESTADO_COMPPROD from ESTADOS_COMPPROD WHERE COD_ESTADO_REGISTRO=1" ;
            
            System.out.println("select ALL:"+sql);
            ResultSet rs=null;
            
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            if(!cod.equals("")){
                
            } else{
                sql+=" order by NOMBRE_ESTADO_COMPPROD";
                estadosCompProdList.clear();
                rs=st.executeQuery(sql);
                estadosCompProdList.add(new SelectItem("0","Todos"));
                while (rs.next())
                    estadosCompProdList.add(new SelectItem(rs.getString(1),rs.getString(2)));
            }
            if(rs!=null){
                rs.close();st.close();
                rs=null;st=null;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public List cargarTipoProduccion(){
        ManagedAccesoSistema usuario=(ManagedAccesoSistema)Util.getSession("ManagedAccesoSistema");
        List tiposProduccionList = new ArrayList();
        try{
            Connection con = null;
            con = Util.openConnection(con);
            Statement st = con.createStatement();
            String consulta = " select t.COD_TIPO_PRODUCCION,t.NOMBRE_TIPO_PRODUCCION from TIPOS_PRODUCCION t inner join usuarios_area_produccion u on u.cod_area_empresa = t.cod_area_empresa and u.cod_tipo_permiso = 2 and u.cod_personal = '"+usuario.getUsuarioModuloBean().getCodUsuarioGlobal()+"' ";
            ResultSet rs = st.executeQuery(consulta);
            //tiposProduccionList.add(new SelectItem("0","-TODOS-"));
            while(rs.next()){
                tiposProduccionList.add(new SelectItem(rs.getString("cod_tipo_produccion"),rs.getString("nombre_tipo_produccion")));
            }
            if(tiposProduccionList.size()==0){tiposProduccionList.add(new SelectItem("0","-TODOS-"));}
            st.close();
            rs.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return tiposProduccionList;
    }
    public void cargarProductosFormasFar(String cod,ComponentesProd bean){
        try {
            setCon(Util.openConnection(getCon()));
            String sql="select cod_forma,nombre_forma from formas_farmaceuticas" +
                    " where cod_estado_registro=1" ;
            
            System.out.println("select ALL:"+sql);
            ResultSet rs=null;
            
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            if(!cod.equals("")){
                sql+=" and  cod_forma="+cod;
                System.out.println("update:"+sql);
                rs=st.executeQuery(sql);
                if(rs.next()){
                    bean.getForma().setCodForma(rs.getString(1));
                    bean.getForma().setNombreForma(rs.getString(2));
                }
            } else{
                sql+=" order by nombre_forma";
                getProductosFormasFarList().clear();
                rs=st.executeQuery(sql);
                productosFormasFarList.add(new SelectItem("0",""));
                while (rs.next())
                    getProductosFormasFarList().add(new SelectItem(rs.getString(1),rs.getString(2)));
            }
            if(rs!=null){
                rs.close();st.close();
                rs=null;st=null;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public void cargarSaborProducto(String cod,ComponentesProd bean){
        try {
            setCon(Util.openConnection(getCon()));
            String sql="select cod_sabor,nombre_sabor " +
                    " from sabores_producto where cod_estado_registro=1 " ;
            
            System.out.println("select ALL:"+sql);
            ResultSet rs=null;
            
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            if(!cod.equals("")){
                sql+=" and cod_sabor="+cod;
                System.out.println("update:"+sql);
                rs=st.executeQuery(sql);
                if(rs.next()){
                    bean.getSaboresProductos().setCodSabor(rs.getString(1));
                    bean.getSaboresProductos().setNombreSabor(rs.getString(2));
                }
            } else{
                sql+=" order by nombre_sabor";
                getSaboresProductoList().clear();
                rs=st.executeQuery(sql);
                getSaboresProductoList().add(new SelectItem("0","       "));
                while (rs.next())
                    getSaboresProductoList().add(new SelectItem(rs.getString(1),rs.getString(2)));
            }
            if(rs!=null){
                rs.close();st.close();
                rs=null;st=null;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public void cargarEnvasePrimario(String codigo,ComponentesProd bean){
        try {
            setCon(Util.openConnection(getCon()));
            String sql="select cod_envaseprim,nombre_envaseprim " +
                    "from envases_primarios where cod_estado_registro=1";
            ResultSet rs=null;
            
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            if(!codigo.equals("")){
                sql+=" and cod_envaseprim="+codigo;
                System.out.println("update:"+sql);
                rs=st.executeQuery(sql);
                if(rs.next()){
                    bean.getEnvasesPrimarios().setCodEnvasePrim(rs.getString(1));
                    bean.getEnvasesPrimarios().setNombreEnvasePrim(rs.getString(2));
                }
            } else{
                sql+=" order by nombre_envaseprim";
                envasesPrimariosList.clear();
                rs=st.executeQuery(sql);
                envasesPrimariosList.add(new SelectItem("0",""));
                while (rs.next())
                    envasesPrimariosList.add(new SelectItem(rs.getString(1),rs.getString(2)));
            }
            if(rs!=null){
                rs.close();st.close();
                rs=null;st=null;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public void cargarEnvasePrimarios(){
        try {

            Connection con = null;
            con = Util.openConnection(con);
            String sql="select cod_envaseprim,nombre_envaseprim " +
                    " from envases_primarios where cod_estado_registro=1 order by nombre_envaseprim";
            System.out.println("consulta " + sql);
            ResultSet rs=null;

            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                envasesPrimariosList.clear();
                rs=st.executeQuery(sql);
                envasesPrimariosList.add(new SelectItem("0",""));
                while (rs.next())
                    envasesPrimariosList.add(new SelectItem(rs.getString(1),rs.getString(2)));
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public void cargarColorPresentacion(String codigo,ComponentesProd bean){
        try {
            setCon(Util.openConnection(getCon()));
            String sql="select cod_colorpresprimaria,nombre_colorpresprimaria " +
                    "from colores_presprimaria where cod_estado_registro=1";
            ResultSet rs=null;
            
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            if(!codigo.equals("")){
                sql+=" and cod_colorpresprimaria="+codigo;
                System.out.println("update:"+sql);
                rs=st.executeQuery(sql);
                
                if(rs.next()){
                    bean.getColoresPresentacion().setCodColor(rs.getString(1));
                    bean.getColoresPresentacion().setNombreColor(rs.getString(2));
                }
            } else{
                sql+=" order by nombre_colorpresprimaria";
                getColoresProductoList().clear();
                rs=st.executeQuery(sql);
                getColoresProductoList().add(new SelectItem("0","      "));
                while (rs.next())
                    getColoresProductoList().add(new SelectItem(rs.getString(1),rs.getString(2)));
            }
            if(rs!=null){
                rs.close();st.close();
                rs=null;st=null;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public void cargarAreasEmpresa(String codigo,ComponentesProd bean){
        try {
            setCon(Util.openConnection(getCon()));
            String sql="select cod_area_empresa,nombre_area_empresa" +
                    " from areas_empresa where cod_estado_registro=1";
            ResultSet rs=null;
            sql+=" and cod_area_empresa in(80,81,82,95)";
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            if(!codigo.equals("")){
                sql+=" and cod_area_empresa="+codigo;
                System.out.println("update:"+sql);
                rs=st.executeQuery(sql);
                if(rs.next()){
                    bean.getAreasEmpresa().setCodAreaEmpresa(rs.getString(1));
                    bean.getAreasEmpresa().setNombreAreaEmpresa(rs.getString(2));
                }
            } else{
                sql+=" order by nombre_area_empresa";
                areasEmpresaList.clear();
                areasEmpresaList.add(new SelectItem("0",""));
                rs=st.executeQuery(sql);
                while (rs.next())
                    areasEmpresaList.add(new SelectItem(rs.getString(1),rs.getString(2)));
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
    
    public List obtenerPrincipioActivo(String codCompProd){
        
        
        List array=new ArrayList();
        try {
            
            String sql="select d.cod_principio_activo,d.concentracion," +
                    "p.nombre_principio_activo" +
                    " from principios_activos p,componentes_proddetalle d " +
                    " where d.cod_principio_activo=p.cod_principio_activo and " +
                    " d.cod_compprod="+codCompProd+" " ;
            
            System.out.println("sqlPRINCIPIOS:"+sql);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(sql);
            while (rs.next()){
                PrincipiosActivosProducto bean=new PrincipiosActivosProducto();
                bean.getPrincipiosActivos().setCodPrincipioActivo(rs.getString(1));
                bean.setConcentracion(rs.getString(2));
                bean.getPrincipiosActivos().setNombrePrincipioActivo(rs.getString(3));
                array.add(bean);
                
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return array;
    }
    public void cargarComponentesProducto(){
        try {
            String sql="select c.cod_compprod,c.cod_prod,c.cod_forma,c.cod_envaseprim," +
                    " c.cod_colorpresprimaria,c.volumenpeso_envaseprim,c.cantidad_compprod," +
                    " c.cod_area_empresa,c.cod_sabor,cod_compuestoprod," +
                    " c.nombre_prod_semiterminado,c.nombre_generico,c.reg_sanitario,c.vida_util,c.FECHA_VENCIMIENTO_RS," +
                    " c.COD_ESTADO_COMPPROD,e.NOMBRE_ESTADO_COMPPROD" +
                    " from componentes_prod c,ESTADOS_COMPPROD e" +
                    " where e.COD_ESTADO_COMPPROD=c.COD_ESTADO_COMPPROD";
            String codigo=componentesProdbean.getProducto().getCodProducto();
            codigo=(codigo.equals("")?"0":codigo);
            componentesProdbean.getProducto().setCodProducto(codigo);
            if(!componentesProdbean.getProducto().getCodProducto().equals("0"))
                sql+=" and c.cod_prod="+componentesProdbean.getProducto().getCodProducto();
            System.out.println("componentesProdbean.getEstadoCompProd().getCodEstadoCompProd():"+componentesProdbean.getEstadoCompProd().getCodEstadoCompProd());
            if(componentesProdbean.getEstadoCompProd().getCodEstadoCompProd() > 0)
                sql+=" and c.COD_ESTADO_COMPPROD="+componentesProdbean.getEstadoCompProd().getCodEstadoCompProd();
            
            sql+=" order by c.nombre_prod_semiterminado ";
            System.out.println("cargar:"+sql);
            con=Util.openConnection(con);
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(sql);
            rs.last();
            int rows=rs.getRow();
            componentesProductoList.clear();
            rs.first();
            String cod="";
            for(int i=0;i<rows;i++){
                ComponentesProd bean=new ComponentesProd();
                String codCompProd=rs.getString(1);
                List list=obtenerPrincipioActivo(codCompProd);
                bean.setCodCompprod(codCompProd);
                bean.getProducto().setCodProducto(rs.getString(2));
                cod=rs.getString(3);
                cod=(cod==null)?"":cod;
                //System.out.println("st xxx:"+cod);
                cargarProductosFormasFar(cod,bean);
                //bean.setConcentracionForma(rs.getString(4));
                cod=rs.getString(4);
                cod=(cod==null)?"":cod;
                //System.out.println("st xxx:"+cod);
                cargarEnvasePrimario(cod,bean);
                cod=rs.getString(5);
                cod=(cod==null)?"":cod;
                //System.out.println("st xxx:"+cod);
                cargarColorPresentacion(cod,bean);
                bean.setVolumenPesoEnvasePrim(rs.getString(6));
                bean.setCantidadCompprod(rs.getString(7));
                cod=rs.getString(8);
                cod=(cod==null)?"":cod;
                //System.out.println("st xxx:"+cod);
                cargarAreasEmpresa(cod,bean);
                cod=rs.getString(9);
                cod=(cod==null)?"":cod;
                //System.out.println("st xxx:"+cod);
                cargarSaborProducto(cod,bean);
                //bean.getProducto().setNombreProducto(rs.getString(10));
                bean.setCodcompuestoprod(rs.getString(10));
                bean.setNombreProdSemiterminado(rs.getString(11));
                bean.setNombreGenerico(rs.getString(12));
                bean.setRegSanitario(rs.getString(13));
                bean.setVidaUtil(rs.getInt(14));
                
                bean.setFechaVencimientoRS(rs.getDate(15));
                if(bean.getCodcompuestoprod().equals("2"))
                    bean.setColumnStyle("codcompuestoprod");
                else
                    bean.setColumnStyle("nocodcompuestoprod");
                bean.getEstadoCompProd().setCodEstadoCompProd(rs.getInt(16));
                bean.getEstadoCompProd().setNombreEstadoCompProd(rs.getString(17));
                bean.setPrincipiosList(list);
                componentesProductoList.add(bean);
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
    public void cargarComponentesProducto1(){
        try {
            ManagedAccesoSistema usuario=(ManagedAccesoSistema)Util.getSession("ManagedAccesoSistema");
            String sql=" select cp.COD_PROD,cp.COD_COMPPROD,cp.nombre_prod_semiterminado,ff.cod_forma,ff.nombre_forma,cp.VOLUMENPESO_ENVASEPRIM,c.COD_COLORPRESPRIMARIA,c.NOMBRE_COLORPRESPRIMARIA,  " +
                    " s.COD_SABOR,s.NOMBRE_SABOR,ae.COD_AREA_EMPRESA,ae.NOMBRE_AREA_EMPRESA,cp.NOMBRE_GENERICO,cp.REG_SANITARIO,cp.FECHA_VENCIMIENTO_RS,cp.VIDA_UTIL,ec.COD_ESTADO_COMPPROD,ec.NOMBRE_ESTADO_COMPPROD,cp.COD_COMPUESTOPROD " +
                    ",cp.VOLUMEN_ENVASE_PRIMARIO,cp.CONCENTRACION_ENVASE_PRIMARIO,cp.PESO_ENVASE_PRIMARIO" +
                    " ,tp.COD_TIPO_PRODUCCION,tp.NOMBRE_TIPO_PRODUCCION" +
                    " ,cp.COD_VIA_ADMINISTRACION_PRODUCTO,ISNULL(vap.NOMBRE_VIA_ADMINISTRACION_PRODUCTO,'') as NOMBRE_VIA_ADMINISTRACION_PRODUCTO" +
                    " ,cp.CANTIDAD_VOLUMEN,isnull(cp.COD_UNIDAD_MEDIDA_VOLUMEN,0) as COD_UNIDAD_MEDIDA_VOLUMEN,isnull(um.ABREVIATURA,'') as abreviatura,cp.TOLERANCIA_VOLUMEN_FABRICAR" +
                    " from componentes_prod cp left outer join FORMAS_FARMACEUTICAS ff on ff.cod_forma = cp.COD_FORMA " +
                    " inner join AREAS_EMPRESA ae on ae.COD_AREA_EMPRESA = cp.COD_AREA_EMPRESA " +
                    " inner join ESTADOS_COMPPROD ec on ec.COD_ESTADO_COMPPROD = cp.COD_ESTADO_COMPPROD " +
                    " left outer join COLORES_PRESPRIMARIA c on c.COD_COLORPRESPRIMARIA = cp.COD_COLORPRESPRIMARIA " +
                    " left outer join SABORES_PRODUCTO s on s.COD_SABOR = cp.COD_SABOR "+
                    " inner join TIPOS_PRODUCCION tp on tp.COD_TIPO_PRODUCCION=cp.COD_TIPO_PRODUCCION" +
                    " inner join usuarios_area_produccion u on u.cod_area_empresa = tp.cod_area_empresa and u.cod_tipo_permiso = 2 and u.cod_personal = '"+usuario.getUsuarioModuloBean().getCodUsuarioGlobal()+"' " +
                    " left outer join VIAS_ADMINISTRACION_PRODUCTO vap on vap.COD_VIA_ADMINISTRACION_PRODUCTO=cp.COD_VIA_ADMINISTRACION_PRODUCTO" +
                    " left outer join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=cp.COD_UNIDAD_MEDIDA_VOLUMEN" +
                    " where ec.cod_estado_compprod = cp.cod_estado_compprod ";
            String codigo=componentesProdbean.getProducto().getCodProducto();
            codigo=(codigo.equals("")?"0":codigo);
            componentesProdbean.getProducto().setCodProducto(codigo);
            if(!componentesProdbean.getProducto().getCodProducto().equals("0"))
                sql+=" and cp.cod_prod="+componentesProdbean.getProducto().getCodProducto();
            System.out.println("componentesProdbean.getEstadoCompProd().getCodEstadoCompProd():"+componentesProdbean.getEstadoCompProd().getCodEstadoCompProd());
            if(componentesProdbean.getEstadoCompProd().getCodEstadoCompProd() > 0)
                sql+=" and cp.COD_ESTADO_COMPPROD="+componentesProdbean.getEstadoCompProd().getCodEstadoCompProd();
            if(componentesProdbean.getTipoProduccion().getCodTipoProduccion()!=0)
                sql+=" and cp.COD_TIPO_PRODUCCION='"+componentesProdbean.getTipoProduccion().getCodTipoProduccion()+"'";
            sql+=" order by cp.nombre_prod_semiterminado ";
            System.out.println("cargar:"+sql);
            con=Util.openConnection(con);
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(sql);
            rs.last();
            int rows=rs.getRow();
            componentesProductoList.clear();
            rs.first();
            String cod="";
            for(int i=0;i<rows;i++){
                ComponentesProd componentesProd=new ComponentesProd();
                componentesProd.getUnidadMedidaVolumen().setCodUnidadMedida(rs.getString("COD_UNIDAD_MEDIDA_VOLUMEN"));
                componentesProd.getUnidadMedidaVolumen().setAbreviatura(rs.getString("abreviatura"));
                componentesProd.setCantidadVolumen(rs.getDouble("CANTIDAD_VOLUMEN"));
                componentesProd.setToleranciaVolumenfabricar(rs.getDouble("TOLERANCIA_VOLUMEN_FABRICAR"));
                componentesProd.getViasAdministracionProducto().setCodViaAdministracionProducto(rs.getInt("COD_VIA_ADMINISTRACION_PRODUCTO"));
                componentesProd.getViasAdministracionProducto().setNombreViaAdministracionProducto(rs.getString("NOMBRE_VIA_ADMINISTRACION_PRODUCTO"));
                componentesProd.setCodCompprod(rs.getString("cod_compprod"));
                componentesProd.setNombreProdSemiterminado(rs.getString("nombre_prod_semiterminado"));
                componentesProd.getForma().setCodForma(rs.getString("cod_forma"));
                componentesProd.getForma().setNombreForma(rs.getString("nombre_forma"));
                componentesProd.setVolumenPesoEnvasePrim(rs.getString("VOLUMENPESO_ENVASEPRIM"));
                componentesProd.getColoresPresentacion().setCodColor(rs.getString("COD_COLORPRESPRIMARIA"));
                componentesProd.getColoresPresentacion().setNombreColor(rs.getString("NOMBRE_COLORPRESPRIMARIA"));
                componentesProd.getSaboresProductos().setCodSabor(rs.getString("COD_SABOR"));
                componentesProd.getSaboresProductos().setNombreSabor(rs.getString("NOMBRE_SABOR"));
                componentesProd.getAreasEmpresa().setCodAreaEmpresa(rs.getString("COD_AREA_EMPRESA"));
                componentesProd.getAreasEmpresa().setNombreAreaEmpresa(rs.getString("NOMBRE_AREA_EMPRESA"));
                componentesProd.setNombreGenerico(rs.getString("NOMBRE_GENERICO"));
                componentesProd.setRegSanitario(rs.getString("REG_SANITARIO"));
                componentesProd.setFechaVencimientoRS(rs.getDate("FECHA_VENCIMIENTO_RS"));
                componentesProd.setVidaUtil(rs.getInt("VIDA_UTIL"));
                componentesProd.getEstadoCompProd().setCodEstadoCompProd(rs.getInt("COD_ESTADO_COMPPROD"));
                componentesProd.getEstadoCompProd().setNombreEstadoCompProd(rs.getString("NOMBRE_ESTADO_COMPPROD"));
                componentesProd.setCodcompuestoprod(rs.getString("COD_COMPUESTOPROD"));
                componentesProd.setPesoEnvasePrimario(rs.getString("PESO_ENVASE_PRIMARIO"));
                componentesProd.setConcentracionEnvasePrimario(rs.getString("CONCENTRACION_ENVASE_PRIMARIO"));
                componentesProd.setVolumenEnvasePrimario(rs.getString("VOLUMEN_ENVASE_PRIMARIO"));
                componentesProd.getProducto().setCodProducto(rs.getString("COD_PROD"));
                componentesProd.getTipoProduccion().setCodTipoProduccion(rs.getInt("COD_TIPO_PRODUCCION"));
                componentesProd.getTipoProduccion().setNombreTipoProduccion(rs.getString("NOMBRE_TIPO_PRODUCCION"));
                if(componentesProd.getCodcompuestoprod().equals("2"))
                    componentesProd.setColumnStyle("codcompuestoprod");
                else
                    componentesProd.setColumnStyle("nocodcompuestoprod");


//                String codCompProd=rs.getString(1);
//                List list=obtenerPrincipioActivo(codCompProd);
//                bean.setCodCompprod(codCompProd);
//                bean.getProducto().setCodProducto(rs.getString(2));
//                cod=rs.getString(3);
//                cod=(cod==null)?"":cod;
//                //System.out.println("st xxx:"+cod);
//                cargarProductosFormasFar(cod,bean);
//                //bean.setConcentracionForma(rs.getString(4));
//                cod=rs.getString(4);
//                cod=(cod==null)?"":cod;
//                //System.out.println("st xxx:"+cod);
//                cargarEnvasePrimario(cod,bean);
//                cod=rs.getString(5);
//                cod=(cod==null)?"":cod;
//                //System.out.println("st xxx:"+cod);
//                cargarColorPresentacion(cod,bean);
//                bean.setVolumenPesoEnvasePrim(rs.getString(6));
//                bean.setCantidadCompprod(rs.getString(7));
//                cod=rs.getString(8);
//                cod=(cod==null)?"":cod;
//                //System.out.println("st xxx:"+cod);
//                cargarAreasEmpresa(cod,bean);
//                cod=rs.getString(9);
//                cod=(cod==null)?"":cod;
//                //System.out.println("st xxx:"+cod);
//                cargarSaborProducto(cod,bean);
//                //bean.getProducto().setNombreProducto(rs.getString(10));
//                bean.setCodcompuestoprod(rs.getString(10));
//                bean.setNombreProdSemiterminado(rs.getString(11));
//                bean.setNombreGenerico(rs.getString(12));
//                bean.setRegSanitario(rs.getString(13));
//                bean.setVidaUtil(rs.getString(14));
//
//                bean.setFechaVencimientoRS(rs.getDate(15));
//                if(bean.getCodcompuestoprod().equals("2"))
//                    bean.setColumnStyle("codcompuestoprod");
//                else
//                    bean.setColumnStyle("nocodcompuestoprod");
//                bean.getEstadoCompProd().setCodEstadoCompProd(rs.getString(16));
//                bean.getEstadoCompProd().setNombreEstadoCompProd(rs.getString(17));
//                bean.setPrincipiosList(list);
                componentesProductoList.add(componentesProd);
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
        productosList.clear();
        componentesProdbean.getProducto().setCodProducto("0");
        componentesProdbean.getEstadoCompProd().setCodEstadoCompProd(0);
        clearComponentesProd();
        cargarColorPresentacion("",null);
        cargarProductosFormasFar("",null);
        cargarEnvasePrimario("",null);
        cargarSaborProducto("",null);
        cargarAreasEmpresa("",null);
        cargarProductos("",null);
        cargarEstadoCompProd("",null);
        detalleList.clear();
        this.cargarTiposProduccion(false);
        
        return"actionAgregarComponentesProd";
    }
    public String cancelarEdicion_action()
    {
        Util.redireccionar("navegador_componentesProducto.jsf");
        return null;
    }
    public String guardarEdicionRegistroSanitario_action()throws SQLException
    {
        try
        {
            con=Util.openConnection(con);
            con.setAutoCommit(false);
            SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");
            String consulta="update COMPONENTES_PROD " +
                    "set REG_SANITARIO='"+componentesProdbean.getRegSanitario()+"' ," +
                    "FECHA_VENCIMIENTO_RS='"+sdf.format(componentesProdbean.getFechaVencimientoRS())+"' " +
                    ",VIDA_UTIL='"+componentesProdbean.getVidaUtil()+"'"+
                    " where COD_COMPPROD='"+componentesProdbean.getCodCompprod()+"'";
            System.out.println("consulta update datos rs "+consulta);
            PreparedStatement pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se actualizaron los datos r.s. del producto");
            con.commit();
            pst.close();
            con.close();
        }
        catch(SQLException ex)
        {
            con.rollback();
            con.close();
            ex.printStackTrace();
        }
        Util.redireccionar("navegador_componentesProducto.jsf");
        return null;
    }
    public String editarRegistroSanitario_action()
    {
        Iterator e=componentesProductoList.iterator();
        while(e.hasNext())
        {
            componentesProdbean=(ComponentesProd)e.next();
            if(componentesProdbean.getChecked())
            {
                break;
            }
        }
        Util.redireccionar("editarRegistroSanitario.jsf");
        return null;
    }
    public String actionEditar(){
        cargarColorPresentacion("",null);
        cargarProductosFormasFar("",null);
        cargarEnvasePrimario("",null);
        cargarSaborProducto("",null);
        cargarAreasEmpresa("",null);
        cargarProductos("",null);
        cargarEstadoCompProd("",null);
        
        Iterator i=getComponentesProductoList().iterator();
        while (i.hasNext()){
            ComponentesProd bean=(ComponentesProd)i.next();
            detalleList.clear();
            if(bean.getChecked().booleanValue()){
                try {
                    setComponentesProdbean(bean);
                    String codCompProd=componentesProdbean.getCodCompprod();
                    System.out.println("codCompProd:"+codCompProd);
                    
                    
                    String sql=" select a.cod_accion_terapeutica,a.nombre_accion_terapeutica" +
                            " from acciones_terapeuticas a,acciones_terapeuticas_producto d ";
                    sql+=" where d.cod_accion_terapeutica = a.cod_accion_terapeutica and" +
                            " d.cod_compprod="+codCompProd+"";
                    System.out.println("cargar:"+sql);
                    setCon(Util.openConnection(getCon()));
                    Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet rs=st.executeQuery(sql);
                    int index=1;
                    while (rs.next()){
                        ComponentesProd bean1=new ComponentesProd();
                        bean1.getAccionesTerapeuticas().setCodAccionTerapeutica(rs.getString(1));
                        bean1.getAccionesTerapeuticas().setNombreAccionTerapeutica(rs.getString(2));
//                        bean1.setCodTemp(index);
                        index++;
                        detalleList.add(bean1);
                    }
                   String consulta="select (m.NOMBRE_CCC+' '+cast(cpc.CANTIDAD as varchar)+' '+um.ABREVIATURA) as datoMaterial,cpc.UNIDAD_PRODUCTO"+
                                 " from COMPONENTES_PROD_CONCENTRACION cpc inner join materiales m"+
                                 " on cpc.COD_MATERIAL=m.COD_MATERIAL inner join UNIDADES_MEDIDA um on "+
                                 " um.COD_UNIDAD_MEDIDA=cpc.COD_UNIDAD_MEDIDA"+
                                 " where cpc.COD_ESTADO_REGISTRO=1 and cpc.COD_COMPPROD='"+componentesProdbean.getCodCompprod()+"'"+
                                 " order by m.NOMBRE_CCC";
                    System.out.println("consulta concentracion "+consulta);
                        ResultSet res=st.executeQuery(consulta);
                        String concentracion="";
                        String porUnidadProd="";
                        if(res.next())
                        {
                            concentracion=res.getString("datoMaterial");
                            porUnidadProd=res.getString("UNIDAD_PRODUCTO");
                        }
                        while(res.next())
                        {
                            concentracion+=", "+res.getString("datoMaterial");
                        }
                        concentracion+=(porUnidadProd.equals("")?"":" / ")+porUnidadProd;
                        componentesProdbean.setConcentracionEnvasePrimario(concentracion);
                        consulta="select tpp.ABREVIATURA, isnull(ep.nombre_envaseprim,'') as nombre_envaseprim,isnull(ppcp.CANTIDAD,'') as CANTIDAD "+
                                 " from PRESENTACIONES_PRIMARIAS ppcp inner join ENVASES_PRIMARIOS ep on ep.cod_envaseprim ="+
                                 " ppcp.COD_ENVASEPRIM inner join TIPOS_PROGRAMA_PRODUCCION tpp " +
                                 " on tpp.COD_TIPO_PROGRAMA_PROD=ppcp.COD_TIPO_PROGRAMA_PROD"+
                                 " where ppcp.COD_COMPPROD ='"+componentesProdbean.getCodCompprod()+"' and ppcp.COD_ESTADO_REGISTRO=1"+
                                 " order by tpp.NOMBRE_TIPO_PROGRAMA_PROD";
                        System.out.println("consulta presentaciones "+consulta);
                        presentacionesProducto=new ArrayList<String>();
                        String nombrePresentacionPrimaria="";
                        String cantidadPresnt="";
                        String nombrePresentacion="";
                        res=st.executeQuery(consulta);
                        while(res.next())
                        {
                            nombrePresentacionPrimaria=res.getString("nombre_envaseprim");
                            cantidadPresnt=res.getString("CANTIDAD");
                            int codForma=Integer.valueOf(componentesProdbean.getForma().getCodForma());
                             String nombreFormaPresentacion="";
                                if((codForma==6||codForma==1||codForma==32||codForma==37||codForma==38||codForma==39))
                                {
                                    String[] array=componentesProdbean.getForma().getNombreForma().split(" ");
                                    for(String a:array)
                                    {
                                        nombreFormaPresentacion+=a+"s ";
                                    }

                                }
                            nombrePresentacion=nombrePresentacionPrimaria+" "+((codForma==2||codForma==14||codForma==33||codForma==16|| codForma==10||codForma==26||codForma==27||codForma==29)?(componentesProdbean.getColoresPresentacion().getNombreColor()==null?"--":componentesProdbean.getColoresPresentacion().getNombreColor())+" por "+componentesProdbean.getCantidadVolumen()+" "+componentesProdbean.getUnidadMedidaVolumen().getAbreviatura():
                                         ((codForma==6||codForma==1||codForma==32||codForma==37||codForma==38||codForma==39)?"por "+cantidadPresnt+" "+nombreFormaPresentacion:
                                         ((codForma==7||codForma==25)?"por "+componentesProdbean.getCantidadVolumen()+" "+componentesProdbean.getUnidadMedidaVolumen().getAbreviatura():
                                         ((codForma==12||codForma==20||codForma==31||codForma==11||codForma==34||codForma==30||codForma==13)?"por "+componentesProdbean.getPesoEnvasePrimario():
                                          ((codForma==36)?"por "+cantidadPresnt+"comprimidos":"") ))))+"("+res.getString("ABREVIATURA")+")";
                            presentacionesProducto.add(nombrePresentacion.toLowerCase());
                        }
                } catch (SQLException s) {
                    s.printStackTrace();
                }
                break;
            }
            
        }
        this.cargarTiposProduccion(false);
        return "actionEditarComponentesProd";
    }
    public String actionEliminar(){
        setSwEliminaSi(false);
        setSwEliminaNo(false);
        componentesProductoNoEliminar.clear();
        componentesProductoEliminar.clear();
        int bandera=0;
        Iterator i=componentesProductoList.iterator();
        try {
            while (i.hasNext()){
                ComponentesProd bean=(ComponentesProd)i.next();
                if(bean.getChecked().booleanValue()){
                    
                    String sql="select cod_compprod from ingresos_detalleacond " +
                            " where cod_compprod="+bean.getCodCompprod();
                    setCon(Util.openConnection(getCon()));
                    Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet rs=st.executeQuery(sql);
                    rs.last();
                    if(rs.getRow()==0){
                        bandera=1;
                    }
                    if(bandera==1){
                        sql="select cod_compprod from salidas_detalleacond " +
                                " where cod_compprod="+bean.getCodCompprod();
                        setCon(Util.openConnection(getCon()));
                        st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                        rs=st.executeQuery(sql);
                        rs.last();
                        if(rs.getRow()==0){
                            bandera=1;
                        }else{
                            bandera=0;
                        }
                    }
                    if(bandera==1){
                        sql="select cod_compprod from salidas_detalleingresoacond " +
                                " where cod_compprod="+bean.getCodCompprod();
                        setCon(Util.openConnection(getCon()));
                        st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                        rs=st.executeQuery(sql);
                        rs.last();
                        if(rs.getRow()==0){
                            bandera=1;
                        }else{
                            bandera=0;
                        }
                    }
                    if(bandera==1){
                        sql="select cod_compprod from componentes_proddetalle " +
                                " where cod_compprod="+bean.getCodCompprod();
                        setCon(Util.openConnection(getCon()));
                        st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                        rs=st.executeQuery(sql);
                        rs.last();
                        if(rs.getRow()==0){
                            bandera=1;
                        }else{
                            bandera=0;
                        }
                    }
                    if(bandera==1){
                        sql="select cod_compprod from componentes_presprod " +
                                " where cod_compprod="+bean.getCodCompprod();
                        setCon(Util.openConnection(getCon()));
                        st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                        rs=st.executeQuery(sql);
                        rs.last();
                        if (rs.getRow()==0){
                            bandera=1;
                        }else{
                            bandera=0;
                        }
                    }
                    if(bandera==1){
                        sql=" SELECT S.COD_PROD FROM SALIDAS_ALMACEN S WHERE S.COD_PROD="+bean.getCodCompprod();
                        System.out.println("ENTRO ELIMINAR"+sql);
                        setCon(Util.openConnection(getCon()));
                        st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                        rs=st.executeQuery(sql);
                        rs.last();
                        if (rs.getRow()==0){
                            bandera=1;
                            System.out.println("ENTRO ELIMINAR");
                        } else{
                            bandera=0;
                            System.out.println("ENTRO no ELIMINAR");
                        }
                    }
                    
                    //FORZAMOS QUE INGRESE A ELIMINAR
                    //bandera=1;
                    if (bandera==1){
                        getComponentesProductoEliminar().add(bean);
                        setSwEliminaSi(true);
                        System.out.println("ENTRO ELIMINAR");
                    }else{
                        getComponentesProductoNoEliminar().add(bean);
                        setSwEliminaNo(true);
                        System.out.println("ENTRO NO ELIMINAR");
                    }
                    if(rs!=null){
                        rs.close();st.close();
                        rs=null;st=null;
                    }
                    
                    
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "eliminarComponentesProd";
    }
    
    public void clearComponentesProd(){
        getComponentesProdbean().setConcentracionForma("");
        getComponentesProdbean().setVolumenPesoEnvasePrim("");
        getComponentesProdbean().setCantidadCompprod("");
        
    }
    
    public String guardarComponentesProd(){
        System.out.println("entro en el evento...");
        System.out.println("componentesProdbean.codcompuestoprod:"+componentesProdbean.getCodcompuestoprod());
        getCodigoProductosVenta();
        try {
            SimpleDateFormat df=new SimpleDateFormat("yyyy/MM/dd");
            String fechaVencRS=df.format(getComponentesProdbean().getFechaVencimientoRS());
            String sql="insert into componentes_prod(cod_compprod,cod_prod,cod_forma," +
                    " cod_colorpresprimaria,volumenpeso_envaseprim,cantidad_compprod,cod_area_empresa," +
                    " cod_sabor,cod_compuestoprod,nombre_prod_semiterminado,nombre_generico," +
                    " COD_ESTADO_COMPPROD,VOLUMEN_ENVASE_PRIMARIO,CONCENTRACION_ENVASE_PRIMARIO,PESO_ENVASE_PRIMARIO,COD_TIPO_PRODUCCION,COD_VIA_ADMINISTRACION_PRODUCTO" +
                    " ,CANTIDAD_VOLUMEN,COD_UNIDAD_MEDIDA_VOLUMEN,TOLERANCIA_VOLUMEN_FABRICAR) values(" ;
            sql+=" '"+getComponentesProdbean().getCodCompprod()+"'," ;
            sql+=" '"+getComponentesProdbean().getProducto().getCodProducto()+"'," ;
            sql+=" '"+getComponentesProdbean().getForma().getCodForma()+"'," ;
            //sql+=" '"+getComponentesProdbean().getConcentracionForma()+"'," ;
            //sql+=" '"+getComponentesProdbean().getEnvasesPrimarios().getCodEnvasePrim()+"'," ;
            sql+=" '"+getComponentesProdbean().getColoresPresentacion().getCodColor()+"'," ;
            sql+=" '"+getComponentesProdbean().getVolumenPesoEnvasePrim()+"'," ;
            sql+=" '"+getComponentesProdbean().getCantidadCompprod()+"'," ;
            sql+=" '"+getComponentesProdbean().getAreasEmpresa().getCodAreaEmpresa()+"'," ;
            sql+=" '"+getComponentesProdbean().getSaboresProductos().getCodSabor()+"'," ;
            sql+=" '"+getComponentesProdbean().getCodcompuestoprod()+"'," ;
            sql+=" '"+getComponentesProdbean().getNombreProdSemiterminado()+"'," ;
            sql+=" '"+getComponentesProdbean().getNombreGenerico()+"'," ;
           // sql+=" '"+getComponentesProdbean().getRegSanitario()+"'," ;
           // sql+=" '"+getComponentesProdbean().getVidaUtil()+"','"+fechaVencRS+"',
                    sql+="1" +
                    ",'"+getComponentesProdbean().getVolumenEnvasePrimario()+"'," +
                    "'"+getComponentesProdbean().getConcentracionEnvasePrimario()+"'" +
                    ",'"+getComponentesProdbean().getPesoEnvasePrimario()+"','"+getComponentesProdbean().getTipoProduccion().getCodTipoProduccion()+"'" +
                    ",'"+componentesProdbean.getViasAdministracionProducto().getCodViaAdministracionProducto()+"'" +
                    ",'"+componentesProdbean.getCantidadVolumen()+"','"+componentesProdbean.getUnidadMedidaVolumen().getCodUnidadMedida()+"'" +
                    ",'"+componentesProdbean.getToleranciaVolumenfabricar()+"')" ;
            System.out.println("insert:"+sql);
            con=Util.openConnection(con);
            PreparedStatement st=con.prepareStatement(sql);
            int result=st.executeUpdate();
            
            if(componentesProdbean.getCodcompuestoprod().equals("2")){
                sql="update COMPONENTES_PROD set  cod_compuestoprod=2 where cod_prod="+componentesProdbean.getProducto().getCodProducto();
                System.out.println("COMPONENTES_PROD:"+sql);
                Statement st5=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                st5.executeUpdate(sql);
            }
            if(result>0){
                //cargarComponentesProducto();
                clearComponentesProd();
            }
            
            Iterator i=detalleList.iterator();
            int result1=0;
            sql="";
            while (i.hasNext()){
                ComponentesProd bean=(ComponentesProd)i.next();
                sql="insert into acciones_terapeuticas_producto(cod_compprod,cod_accion_terapeutica)" +
                        "  values(" ;
                sql+=" '"+componentesProdbean.getCodCompprod()+"'," ;
                sql+=" '"+bean.getAccionesTerapeuticas().getCodAccionTerapeutica()+"')" ;
                System.out.println("INSERTANDO acciones_terapeuticas_producto:"+sql);
                setCon(Util.openConnection(getCon()));
                PreparedStatement st1=getCon().prepareStatement(sql);
                result1=st1.executeUpdate();
            }
            
            if(result1>0){
                cargarComponentesProducto();
                clearComponentesProd();
            }
            
            System.out.println("result:"+result);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        componentesProdbean=new ComponentesProd();
        return "navegadorComponentesProd";
    }
    public String modificarComponentesProd(){
        try {
            System.out.println("entrtrotortorotortorot*****:");
            setCon(Util.openConnection(getCon()));
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
            String  sql="update componentes_prod set";
            sql+=" cod_prod= '"+getComponentesProdbean().getProducto().getCodProducto()+"'," ;
            sql+="cod_forma= '"+getComponentesProdbean().getForma().getCodForma()+"'," ;
            //sql+="concentracion_forma= '"+getComponentesProdbean().getConcentracionForma()+"'," ;
            //sql+="cod_envaseprim= '"+getComponentesProdbean().getEnvasesPrimarios().getCodEnvasePrim()+"'," ;
            sql+="cod_colorpresprimaria= '"+getComponentesProdbean().getColoresPresentacion().getCodColor()+"'," ;
            sql+="volumenpeso_envaseprim='"+getComponentesProdbean().getVolumenPesoEnvasePrim()+"'," ;
            sql+="cantidad_compprod= '"+getComponentesProdbean().getCantidadCompprod()+"'," ;
            sql+="cod_area_empresa= '"+getComponentesProdbean().getAreasEmpresa().getCodAreaEmpresa()+"'," ;
            sql+="cod_sabor= '"+getComponentesProdbean().getSaboresProductos().getCodSabor()+"'," ;
            sql+="nombre_prod_semiterminado='"+getComponentesProdbean().getNombreProdSemiterminado()+"',";
            
            sql+="nombre_generico= '"+getComponentesProdbean().getNombreGenerico()+"'," ;
           // sql+="reg_sanitario= '"+getComponentesProdbean().getRegSanitario()+"'," ;
            //sql+="vida_util='"+getComponentesProdbean().getVidaUtil()+"',";
            sql+="COD_ESTADO_COMPPROD='"+getComponentesProdbean().getEstadoCompProd().getCodEstadoCompProd()+"'," +
                 //" FECHA_VENCIMIENTO_RS = '"+sdf.format(getComponentesProdbean().getFechaVencimientoRS())+"' "+
                 "VOLUMEN_ENVASE_PRIMARIO='"+getComponentesProdbean().getVolumenEnvasePrimario()+"'"+
                 ",CONCENTRACION_ENVASE_PRIMARIO='"+getComponentesProdbean().getConcentracionEnvasePrimario()+"'" +
                 ",PESO_ENVASE_PRIMARIO='"+getComponentesProdbean().getPesoEnvasePrimario()+"'" +
                 ",COD_VIA_ADMINISTRACION_PRODUCTO='"+componentesProdbean.getViasAdministracionProducto().getCodViaAdministracionProducto()+"'" +
                 ",CANTIDAD_VOLUMEN='"+componentesProdbean.getCantidadVolumen()+"'" +
                 ",COD_UNIDAD_MEDIDA_VOLUMEN='"+componentesProdbean.getUnidadMedidaVolumen().getCodUnidadMedida()+"'" +
                 ",TOLERANCIA_VOLUMEN_FABRICAR='"+componentesProdbean.getToleranciaVolumenfabricar()+"'";
            sql+=" where cod_compprod='"+getComponentesProdbean().getCodCompprod()+"'" ;
            System.out.println("update:"+sql);
            PreparedStatement st=getCon().prepareStatement(sql);
            int result=st.executeUpdate();
            if(result>0){
                cargarComponentesProducto();
            }
            sql="delete from componentes_proddetalle  ";
            sql+=" where cod_compprod="+componentesProdbean.getCodCompprod()+"  " ;
            System.out.println("deleteprincipio:sql:"+sql);
            setCon(Util.openConnection(getCon()));
            Statement st1=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            result=result+st1.executeUpdate(sql);
            /////////inserta componentes_proddedtalle/////////////
            sql="delete from acciones_terapeuticas_producto  ";
            sql+=" where cod_compprod="+componentesProdbean.getCodCompprod()+"  " ;
            System.out.println("deleteprincipio:sql:"+sql);
            setCon(Util.openConnection(getCon()));
            st1=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            result=result+st1.executeUpdate(sql);
            /////////inserta componentes_proddedtalle/////////////
            Iterator i=detalleList.iterator();
            int result1=0;
            sql="";
            while (i.hasNext()){
                ComponentesProd bean=(ComponentesProd)i.next();
                sql="insert into acciones_terapeuticas_producto(cod_compprod,cod_accion_terapeutica)" +
                        "  values(" ;
                sql+=" '"+componentesProdbean.getCodCompprod()+"'," ;
                sql+=" '"+bean.getAccionesTerapeuticas().getCodAccionTerapeutica()+"')" ;
                System.out.println("inset Componentes DetlleList22:"+sql);
                setCon(Util.openConnection(getCon()));
                PreparedStatement st2=getCon().prepareStatement(sql);
                result1=st2.executeUpdate();
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return "navegadorComponentesProd";
    }
    public String eliminarComponentesProd(){
        mensaje="";
        Iterator ite=componentesProductoEliminar.iterator();
        while(ite.hasNext())
        {
            ComponentesProd bean=(ComponentesProd)ite.next();
            if(bean.getChecked())
            {
                if(verificarFormulaMaestraProgramaProduccion(bean.getCodCompprod()))
                {
                    System.out.println("no se puede eliminar");
                    mensaje="No se puede eliminar el producto "+bean.getNombreProdSemiterminado()+" porque esta siendo usado en una formula maestra o programa de producción";
                    return null;
                }
            }
        }
        try {
            
            Iterator i=getComponentesProductoEliminar().iterator();
            int result=0;
            while (i.hasNext()){
                ComponentesProd bean=(ComponentesProd)i.next();
                setCon(Util.openConnection(getCon()));
                String sqlPresentacion="select cod_presentacion from componentes_presprod where cod_compprod="+bean.getCodCompprod();
                
                System.out.println("LISTADO PRESENTACIONES: "+sqlPresentacion);
                
                Statement stmPresentacion=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rsDelete=stmPresentacion.executeQuery(sqlPresentacion);
                Statement stmDelete=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                String sqlDelete="";
                while(rsDelete.next()){
                    String codPresentacion=rsDelete.getString("cod_presentacion");
                    sqlDelete="delete from presentaciones_producto where cod_presentacion="+codPresentacion;
                    System.out.println("DELETE PRESENTACIONES: "+sqlDelete);
                    
                    stmDelete.executeUpdate(sqlDelete);
                }
                sqlDelete="delete from componentes_presprod where cod_compprod="+bean.getCodCompprod();
                System.out.println("DELETE PRESENTACIONES COMPONENTES: "+sqlDelete);
                
                stmDelete.executeUpdate(sqlDelete);
                String sql="delete from componentes_proddetalle where cod_compprod="+bean.getCodCompprod();
                
                System.out.println("DELETE COMPONENTES DETALLE: "+sql);
                Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                result=result+st.executeUpdate(sql);
                //////////////////////////////////
                sql="delete from componentes_prod where cod_compprod="+bean.getCodCompprod();
                System.out.println("DELETE COMPONENTES: "+sql);
                st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                result=result+st.executeUpdate(sql);
                ////////////////////////////////
                sql="delete from acciones_terapeuticas_producto where cod_compprod="+bean.getCodCompprod();
                System.out.println("DELETE acciones_terapeuticas_producto: "+sql);
                st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                result=result+st.executeUpdate(sql);
                sql="delete PRESENTACIONES_PRIMARIAS  where COD_COMPPROD='"+bean.getCodCompprod()+"'";
                System.out.println("consulta delete pre p "+sql);
                PreparedStatement pst=con.prepareStatement(sql);
                if(pst.executeUpdate()>0)   System.out.println("se eliminaron las presentaciones primarias");
                pst.close();
            }

            getComponentesProductoEliminar().clear();
            getComponentesProductoNoEliminar().clear();
            if(result>0){
                cargarComponentesProducto();
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        //return "navegadorComponentesProd";
        return null;
    }
    public String Cancelar(){
        componentesProductoList.clear();
        //cargarComponentesProducto();
        return "navegadorComponentesProd";
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
    
    public void buscarAccionesTerapeuticas(ValueChangeEvent e){
        Object o=e.getNewValue();
        if(o!=null){
            String codigo=o.toString();
            String sql="select cod_accion_terapeutica,nombre_accion_terapeutica" +
                    " from acciones_terapeuticas ";
            sql+=" where  nombre_accion_terapeutica like '%"+codigo+"%'";
            
            System.out.println("cargar:"+sql);
            try {
                setCon(Util.openConnection(getCon()));
                Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet rs=st.executeQuery(sql);
                resultado.setWrappedData(ResultSupport.toResult(rs));
                System.out.println("resultado:"+resultado);
            } catch (SQLException s) {
                s.printStackTrace();
            }
        }
    }
    public void cogerCodigo(ActionEvent g){
        Map map=(Map)resultado.getRowData();
        String cod_accion_terapeutica=map.get("cod_accion_terapeutica").toString();
        String nombre_accion_terapeutica=map.get("nombre_accion_terapeutica").toString();
        
        Iterator i=detalleList.iterator();
        System.out.println("cod_accion_terapeutica:"+cod_accion_terapeutica);
        System.out.println("nombre_accion_terapeutica:"+nombre_accion_terapeutica);
        int j=1;
        List array=new ArrayList();
        while (i.hasNext()){
            ComponentesProd bean=(ComponentesProd)i.next();
            if(j==getIndice()){
                bean.getAccionesTerapeuticas().setCodAccionTerapeutica(cod_accion_terapeutica);
                bean.getAccionesTerapeuticas().setNombreAccionTerapeutica(nombre_accion_terapeutica);
//                bean.setCodTemp(j);
            }
            j++;
            array.add(bean);
        }
        detalleList.clear();
        detalleList=array;
        
    }
    
    
    private int indice=0;
    
    public void cogerId(ActionEvent event){
        HtmlAjaxCommandLink link=(HtmlAjaxCommandLink )event.getComponent();
        System.out.println("link.getData():"+link.getData());
        if(link.getData()!=null){
            setIndice(Integer.parseInt(link.getData().toString()));
            // clearWrapper();
        }
        
        System.out.println("indice:"+getIndice());
    }
    public String  mas(){
        System.out.println("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx:"+componentesProdbean.getCodcompuestoprod());
        System.out.println("entro mMAS");
        /*int size=detalleList.size();
        System.out.println("sizeeeeeeeeee:"+size);
        int codigo=1;
        if(size>0){
            size--;
            ComponentesProd obj=(ComponentesProd)detalleList.get(size);
            codigo=obj.getCodTemp();
            codigo++;
        }
        ComponentesProd bean=new ComponentesProd();
        bean.setCodTemp(codigo);
        detalleList.add(bean);*/
        
        int size=detalleList.size();
        size++;
        ComponentesProd bean=new ComponentesProd();
//        bean.setCodTemp(size);
        detalleList.add(bean);
        return"";
    }
    public String menos(){
        //PrincipiosActivos bean =new PrincipiosActivos();
        int size=detalleList.size();
        size--;
        if(size>=0){
            detalleList.remove(size);
        }
        
        
        return"";
        
    }
    
    public void filtrarProductos(ValueChangeEvent event){
        
        Object obj=event.getNewValue();
        if(obj!=null){
            String codproducto=obj.toString();
            componentesProdbean.getProducto().setCodProducto(codproducto);
            
            //cargarComponentesProducto();
        }
    }
    
    public void filtrarEstadosCompProd(ValueChangeEvent event){
        
        Object obj=event.getNewValue();
        if(obj!=null){
            int cod_estado = Integer.valueOf(obj.toString());
            componentesProdbean.getEstadoCompProd().setCodEstadoCompProd(cod_estado);
            //cargarComponentesProducto();
        }
    }
    
    
    public void obtenerRegistrado(ValueChangeEvent event){
        Object obj=event.getNewValue();
        if(obj!=null){
            String codproducto=obj.toString();
            if(!codproducto.equals("")){
                String sql="select count(*)  from COMPONENTES_PROD where cod_prod="+codproducto;
                System.out.println("obtenerRegistrado:sql:"+sql);
                try {
                    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet rs=st.executeQuery(sql);
                    int count=0;
                    if(rs.next())
                        count=rs.getInt(1);
                    System.out.println("obtenerRegistrado:count:"+count);
                    rs.close();
                    st.close();
                    if(count>0) {
                        componentesProdbean.setColumnStyle("2");
                    }
                    
                    else{
                        componentesProdbean.setColumnStyle("1");
                    }
                    
                } catch (SQLException e) {
                    e.printStackTrace();
                }
                
                
                
            }
            
        }
        
    }
    ///////////////////////////////////////////////////////clases
    
    public ComponentesProd getComponentesProdbean() {
        return componentesProdbean;
    }
    
    public void setComponentesProdbean(ComponentesProd componentesProdbean) {
        this.componentesProdbean = componentesProdbean;
    }
    
    public List getComponentesProductoList() {
        return componentesProductoList;
    }
    
    public void setComponentesProductoList(List componentesProductoList) {
        this.componentesProductoList = componentesProductoList;
    }
    
    public List getComponentesProductoEliminar() {
        return componentesProductoEliminar;
    }
    
    public void setComponentesProductoEliminar(List componentesProductoEliminar) {
        this.componentesProductoEliminar = componentesProductoEliminar;
    }
    
    public List getComponentesProductoNoEliminar() {
        return componentesProductoNoEliminar;
    }
    
    public void setComponentesProductoNoEliminar(List componentesProductoNoEliminar) {
        this.componentesProductoNoEliminar = componentesProductoNoEliminar;
    }
    
    public Connection getCon() {
        return con;
    }
    
    public void setCon(Connection con) {
        this.con = con;
    }
    
    public List getProductosList() {
        return productosList;
    }
    
    public void setProductosList(List productosList) {
        this.productosList = productosList;
    }
    
    public List getProductosFormasFarList() {
        return productosFormasFarList;
    }
    
    public void setProductosFormasFarList(List productosFormasFarList) {
        this.productosFormasFarList = productosFormasFarList;
    }
    
    public List getSaboresProductoList() {
        return saboresProductoList;
    }
    
    public void setSaboresProductoList(List saboresProductoList) {
        this.saboresProductoList = saboresProductoList;
    }
    
    public List getEnvasesPrimariosList() {
        return envasesPrimariosList;
    }
    
    public void setEnvasesPrimariosList(List envasesPrimariosList) {
        this.envasesPrimariosList = envasesPrimariosList;
    }
    
    public List getColoresProductoList() {
        return coloresProductoList;
    }
    
    public void setColoresProductoList(List coloresProductoList) {
        this.coloresProductoList = coloresProductoList;
    }
    
    public List getAreasEmpresaList() {
        return areasEmpresaList;
    }
    
    public void setAreasEmpresaList(List areasEmpresaList) {
        this.areasEmpresaList = areasEmpresaList;
    }
    
    public List getEstadoRegistro() {
        return estadoRegistro;
    }
    
    public void setEstadoRegistro(List estadoRegistro) {
        this.estadoRegistro = estadoRegistro;
    }
    
    public String getCodigo() {
        return codigo;
    }
    
    public void setCodigo(String codigo) {
        this.codigo = codigo;
    }
    
    public String getNombreProducto() {
        return nombreProducto;
    }
    
    public void setNombreProducto(String nombreProducto) {
        this.nombreProducto = nombreProducto;
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
    
    public List getDetalleList() {
        return detalleList;
    }
    
    public void setDetalleList(List detalleList) {
        this.detalleList = detalleList;
    }
    
    public ResultDataModel getResultado() {
        return resultado;
    }
    
    public void setResultado(ResultDataModel resultado) {
        this.resultado = resultado;
    }
    
    public int getIndice() {
        return indice;
    }
    
    public void setIndice(int indice) {
        this.indice = indice;
    }
    
    public List getProductosproceso() {
        return productosproceso;
    }
    
    public void setProductosproceso(List productosproceso) {
        this.productosproceso = productosproceso;
    }
    
    public List getPresentacionesPrimariasList() {
        return presentacionesPrimariasList;
    }
    
    public void setPresentacionesPrimariasList(List presentacionesPrimariasList) {
        this.presentacionesPrimariasList = presentacionesPrimariasList;
    }

    public String getAccionTerapeutica() {
        return accionTerapeutica;
    }

    public void setAccionTerapeutica(String accionTerapeutica) {
        this.accionTerapeutica = accionTerapeutica;
    }
    

    public String getObtenerCodigoPresentacionesPrimarias(){
        String cod=Util.getParameter("codigo");
        System.out.println("presentaciones primariasssssssssssssssssssssssssss:"+cod);
        if(cod!=null){
            setCodigoPP(cod);
        }
        cargarPresenacionesPrimarias();
        cargarNombreComProd();
        return "";
    }
    
    public String getObtenerCodigoAccionesTerapeuticas(){
        String cod=Util.getParameter("codigo");
        System.out.println("acciones:"+cod);
        if(cod!=null){
            setCodigoPP(cod);
        }
        cargarAccionesTerapeuticas();
        cargarNombreComProd();
        return "";
    }
    public void cargarAccionesTerapeuticas(){
        try {
            accionesTerapeuticasList.clear();
            con=Util.openConnection(con);
            
            String sql=" select a.cod_accion_terapeutica,a.nombre_accion_terapeutica";
            sql+=" from acciones_terapeuticas a,acciones_terapeuticas_producto d";
            sql+=" where d.cod_accion_terapeutica = a.cod_accion_terapeutica and d.COD_COMPPROD = "+getCodigoPP();
            sql+=" order by nombre_accion_terapeutica asc";
            System.out.println("cargarSQLLLLLLLLLLLLLL:"+sql);
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(sql);
            while(rs.next()){
                AccionesTerapeuticas bean=new AccionesTerapeuticas();
                bean.setCodAccionTerapeutica(rs.getString(1));
                bean.setNombreAccionTerapeutica(rs.getString(2));
                accionesTerapeuticasList.add(bean);
            }
            if(rs!=null){
                rs.close();
                st.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public String cargarNombreComProd(){
        try {
            setCon(Util.openConnection(getCon()));
            String sql=" select cp.nombre_prod_semiterminado";
            sql+=" from COMPONENTES_PROD cp";
            sql+=" where cp.COD_COMPPROD='"+getCodigoPP()+"'";
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
    public void cargarPresenacionesPrimarias(){
        try {
            presentacionesPrimariasList.clear();
            con=Util.openConnection(con);
            String sql="select p.COD_COMPPROD,(select cp.nombre_prod_semiterminado from COMPONENTES_PROD cp where cp.COD_COMPPROD = p.COD_COMPPROD) nombreProdSemiterminado";
            sql+=",p.COD_ENVASEPRIM,(select ep.nombre_envaseprim from ENVASES_PRIMARIOS ep where ep.cod_envaseprim = p.COD_ENVASEPRIM) as nombreEvasePrimaria";
            sql+=",p.CANTIDAD from PRESENTACIONES_PRIMARIAS p where p.COD_COMPPROD = "+getCodigoPP();
            sql+=" order by nombreProdSemiterminado asc";
            
            sql = " select cp.cod_compprod ,cp.nombre_prod_semiterminado,   ep.cod_envaseprim ,  ep.nombre_envaseprim,   pp.CANTIDAD,   pp.cod_presentacion_primaria," +
                    " tppr.NOMBRE_TIPO_PROGRAMA_PROD,pp.COD_TIPO_PROGRAMA_PROD,erf.NOMBRE_ESTADO_REGISTRO,pp.COD_ESTADO_REGISTRO,pp.COD_PRESENTACION_PRIMARIA" +
                    " from FORMULA_MAESTRA fep  " +
                    " inner join PRESENTACIONES_PRIMARIAS pp on PP.COD_COMPPROD = fep.COD_COMPPROD" +
                    " inner join ENVASES_PRIMARIOS ep on ep.cod_envaseprim = pp.cod_envaseprim " +
                    " inner join componentes_prod cp on cp.cod_compprod = fep.cod_compprod " +
                    " left outer join tipos_programa_produccion tppr on tppr.COD_TIPO_PROGRAMA_PROD = pp.COD_TIPO_PROGRAMA_PROD" +
                    " left outer join ESTADOS_REFERENCIALES erf on erf.COD_ESTADO_REGISTRO = pp.COD_ESTADO_REGISTRO          " +
                    " where fep.COD_COMPPROD = '"+getCodigoPP()+"' and fep.cod_estado_registro = 1  order by ep.nombre_envaseprim ";
            
            System.out.println("cargarSQLLLLLLLLLLLLLL:"+sql);
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(sql);
            while(rs.next()){
                PresentacionesPrimarias bean=new PresentacionesPrimarias();
                bean.getComponentesProd().setCodCompprod(rs.getString(1));
                bean.getComponentesProd().setNombreProdSemiterminado(rs.getString(2));
                bean.getEnvasesPrimarios().setCodEnvasePrim(rs.getString(3));
                bean.getEnvasesPrimarios().setNombreEnvasePrim(rs.getString(4));
                bean.setCantidad(rs.getInt(5));
                bean.getTiposProgramaProduccion().setCodTipoProgramaProd(rs.getString("COD_TIPO_PROGRAMA_PROD"));
                bean.getTiposProgramaProduccion().setNombreTipoProgramaProd(rs.getString("NOMBRE_TIPO_PROGRAMA_PROD"));
                bean.getEstadoReferencial().setCodEstadoRegistro(rs.getString("COD_ESTADO_REGISTRO"));
                bean.getEstadoReferencial().setNombreEstadoRegistro(rs.getString("NOMBRE_ESTADO_REGISTRO"));
                bean.setCodPresentacionPrimaria(rs.getString("COD_PRESENTACION_PRIMARIA"));
                presentacionesPrimariasList.add(bean);
            }
            if(rs!=null){
                rs.close();
                st.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public String registrarPresentacionesPrimarias(){
        tiposProgramaProduccionList = this.cargarTiposProgramaProduccion();
        estadoRegistroList = this.cargarEstadoRegistro();
        cargarEnvasePrimario("",null);
        return "registrarPresentacionesPrimarias";
    }
    public String cancelarPresentacionesPrimarias(){
        return "cancelarPresentacionesPrimarias";
    }
    public List cargarTiposProgramaProduccion(){
        List tiposProgramaProduccionList = new ArrayList();
        try {
            Connection con = null;
            con = Util.openConnection(con);
            String consulta = " select t.COD_TIPO_PROGRAMA_PROD,t.NOMBRE_TIPO_PROGRAMA_PROD from tipos_programa_produccion t where t.COD_ESTADO_REGISTRO = 1 ";
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(consulta);
            while(rs.next()){
                tiposProgramaProduccionList.add(new SelectItem(rs.getString("COD_TIPO_PROGRAMA_PROD"),rs.getString("NOMBRE_TIPO_PROGRAMA_PROD")));
            }
            rs.close();
            st.close();
            con.close();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return tiposProgramaProduccionList;
    }
    public List cargarEstadoRegistro(){
        List estadosRegistroList = new ArrayList();
        try {
            Connection con = null;
            con = Util.openConnection(con);
            String consulta = " select e.COD_ESTADO_REGISTRO,e.NOMBRE_ESTADO_REGISTRO from ESTADOS_REFERENCIALES e where e.COD_ESTADO_REGISTRO in (1,2) ";
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(consulta);
            while(rs.next()){
                estadosRegistroList.add(new SelectItem(rs.getString("COD_ESTADO_REGISTRO"),rs.getString("NOMBRE_ESTADO_REGISTRO")));
            }
            rs.close();
            st.close();
            con.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return estadosRegistroList;
    }
    public String guardarPresentacionesPrimarias(){
        System.out.println("1233333333333333333");
        try {
            String sql="insert into presentaciones_primarias(COD_PRESENTACION_PRIMARIA,COD_COMPPROD,COD_ENVASEPRIM,CANTIDAD,COD_TIPO_PROGRAMA_PROD,COD_ESTADO_REGISTRO) values(";
            sql+=" "+generarCodigo()+"," ;
            sql+=" '"+getCodigoPP()+"'," ;
            sql+=" "+getPresentacionesPrimarias().getEnvasesPrimarios().getCodEnvasePrim()+"," ;
            sql+=" "+getPresentacionesPrimarias().getCantidad()+",'"+presentacionesPrimarias.getTiposProgramaProduccion().getCodTipoProgramaProd()+"'," +
                    "'"+presentacionesPrimarias.getEstadoReferencial().getCodEstadoRegistro()+"')" ;
            System.out.println("insert Presentaciones primarias:"+sql);
            con=Util.openConnection(con);
            PreparedStatement st=con.prepareStatement(sql);
            int result=st.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        componentesProdbean=new ComponentesProd();
        return "navegadorPresentacionesPrimarias";
    }
    public String cancelarPresentacionesPrimarias1(){
        return "navegadorPresentacionesPrimarias";
    }
    public String getCodigoPP() {
        return codigoPP;
    }
    
    public void setCodigoPP(String codigoPP) {
        this.codigoPP = codigoPP;
    }
    /**
     * -------------------------------------------------------------------------
     * GENERAR CODIGO
     * -------------------------------------------------------------------------
     **/
    public String generarCodigo() {
        String codigo = "";
        try {
            con = Util.openConnection(con);
            String sql = "select max(COD_PRESENTACION_PRIMARIA)+1 from presentaciones_primarias";
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(sql);
            if (rs.next()) {
                codigo = rs.getString(1);
            }
            if (codigo == null) {
                codigo="1";
            }
            if (rs != null) {
                rs.close();
                st.close();
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return codigo;
    }
    
    public PresentacionesPrimarias getPresentacionesPrimarias() {
        return presentacionesPrimarias;
    }
    public String actionEliminarPresentacionesPrimarias(){
        Iterator i=presentacionesPrimariasList.iterator();
        try {
            while (i.hasNext()){
                PresentacionesPrimarias bean=(PresentacionesPrimarias)i.next();
                if(bean.getChecked().booleanValue()){
                    String sql="delete from PRESENTACIONES_PRIMARIAS where COD_ENVASEPRIM='"+bean.getEnvasesPrimarios().getCodEnvasePrim()+"' and COD_COMPPROD="+bean.getComponentesProd().getCodCompprod();
                    System.out.println("delete :"+sql);
                    con=Util.openConnection(con);
                    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet rs=st.executeQuery(sql);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        cargarPresenacionesPrimarias();
        return "navegadorPresentacionesPrimarias";
    }
    public String actionEditarPresentacionesPrimarias(){
        try {
            Iterator i = presentacionesPrimariasList.iterator();
                while(i.hasNext()){
                    PresentacionesPrimarias presentacionesPrimarias1 = (PresentacionesPrimarias)i.next();
                    if(presentacionesPrimarias1.getChecked().booleanValue()==true){
                        //presentacionesPrimarias = presentacionesPrimarias1;
                        presentacionesPrimarias.setCantidad(presentacionesPrimarias1.getCantidad());
                        presentacionesPrimarias.setCodPresentacionPrimaria(presentacionesPrimarias1.getCodPresentacionPrimaria());
                        presentacionesPrimarias.setComponentesProd(presentacionesPrimarias1.getComponentesProd());
                        presentacionesPrimarias.setEnvasesPrimarios(presentacionesPrimarias1.getEnvasesPrimarios());
                        presentacionesPrimarias.setEstadoReferencial(presentacionesPrimarias1.getEstadoReferencial());
                        presentacionesPrimarias.setTiposProgramaProduccion(presentacionesPrimarias1.getTiposProgramaProduccion());
                        //presentacionesPrimariasEditar = presentacionesPrimarias1;
                        presentacionesPrimariasEditar.setCantidad(presentacionesPrimarias1.getCantidad());
                        presentacionesPrimariasEditar.setCodPresentacionPrimaria(presentacionesPrimarias1.getCodPresentacionPrimaria());
                        presentacionesPrimariasEditar.setComponentesProd(presentacionesPrimarias1.getComponentesProd());
                        presentacionesPrimariasEditar.setEnvasesPrimarios(presentacionesPrimarias1.getEnvasesPrimarios());
                        presentacionesPrimariasEditar.setEstadoReferencial(presentacionesPrimarias1.getEstadoReferencial());
                        presentacionesPrimariasEditar.setTiposProgramaProduccion(presentacionesPrimarias1.getTiposProgramaProduccion());
                        break;
                    }            
                }

                tiposProgramaProduccionList = this.cargarTiposProgramaProduccion();
                estadoRegistroList = this.cargarEstadoRegistro();
                this.redireccionar("editarPresentacionesPrimarias.jsf");
                
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public String guardarEditarPresentacionesPrimarias_action(){
        try {
            Connection con = null;            
            String consulta = " UPDATE PRESENTACIONES_PRIMARIAS  SET COD_COMPPROD = '"+presentacionesPrimarias.getComponentesProd().getCodCompprod()+"', " +
                    " COD_ENVASEPRIM = '"+presentacionesPrimarias.getEnvasesPrimarios().getCodEnvasePrim()+"' ," +
                    " CANTIDAD = '"+presentacionesPrimarias.getCantidad()+"', " +
                    " COD_TIPO_PROGRAMA_PROD = '"+presentacionesPrimarias.getTiposProgramaProduccion().getCodTipoProgramaProd()+"', " +
                    " COD_ESTADO_REGISTRO = '"+presentacionesPrimarias.getEstadoReferencial().getCodEstadoRegistro()+"' " +
                    " WHERE  COD_PRESENTACION_PRIMARIA = '"+presentacionesPrimarias.getCodPresentacionPrimaria()+"' ";
            System.out.println("consulta " + consulta );
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            st.executeUpdate(consulta);
            this.redireccionar("navegadorPresentacionesPrimarias.jsf");
        
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
     public String redireccionar(String direccion) {
        try {

            FacesContext facesContext = FacesContext.getCurrentInstance();
            ExternalContext ext = facesContext.getExternalContext();
            ext.redirect(direccion);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
     public String editarPresentacionesSecundarias_action(){
         try {
             componentesProd = (ComponentesProd)componentesProdDataTable.getRowData();
             this.redireccionar("navegadorPresentacionesSecundarias.jsf");
         } catch (Exception e) {
             e.printStackTrace();
         }
         return null;
     }
     public String getCargarPresentacionesSecundariasComponentesProd(){
         try {
             componentesPresProdList = this.cargarComponentesPresProd();
             presentacionesSecundariasList = this.cargarPresentacionesProducto();
             tiposProgramaProduccionList = this.cargarTiposProgramaProduccion();
             estadoRegistroList = this.cargarEstadoRegistro();
         } catch (Exception e) {
             e.printStackTrace();
         }
         return null;
     }
     public List cargarComponentesPresProd(){
         List componentesPresProdList = new ArrayList();
         try {
             Connection con = null;
             con = Util.openConnection(con);
             Statement st = con.createStatement();
             String consulta = " select cpp.cod_compprod,p.cod_presentacion,p.NOMBRE_PRODUCTO_PRESENTACION,cpp.CANT_COMPPROD,e.COD_ESTADO_REGISTRO,e.NOMBRE_ESTADO_REGISTRO,t.COD_TIPO_PROGRAMA_PROD,t.NOMBRE_TIPO_PROGRAMA_PROD " +
                     " from COMPONENTES_PRESPROD cpp " +
                     " inner join PRESENTACIONES_PRODUCTO p on p.cod_presentacion = cpp.COD_PRESENTACION " +
                     " left outer join ESTADOS_REFERENCIALES e on e.COD_ESTADO_REGISTRO = cpp.COD_ESTADO_REGISTRO " +
                     " left outer join TIPOS_PROGRAMA_PRODUCCION t on t.COD_TIPO_PROGRAMA_PROD = cpp.COD_TIPO_PROGRAMA_PROD " +
                     " where cpp.COD_COMPPROD = '"+componentesProd.getCodCompprod()+"'  ";
             System.out.println("consulta "+ consulta);
             ResultSet rs = st.executeQuery(consulta);
             componentesPresProdList.clear();
             while(rs.next()){
                 ComponentesPresProd componentesPresProd = new ComponentesPresProd();
                 componentesPresProd.getComponentesProd().setCodCompprod(rs.getString("cod_compprod"));
                 componentesPresProd.getPresentacionesProducto().setCodPresentacion(rs.getString("COD_PRESENTACION"));
                 componentesPresProd.getPresentacionesProducto().setNombreProductoPresentacion(rs.getString("NOMBRE_PRODUCTO_PRESENTACION"));
                 componentesPresProd.setCantCompProd(rs.getFloat("CANT_COMPPROD"));
                 componentesPresProd.getTiposProgramaProduccion().setCodTipoProgramaProd(rs.getString("COD_TIPO_PROGRAMA_PROD"));
                 componentesPresProd.getTiposProgramaProduccion().setNombreTipoProgramaProd(rs.getString("NOMBRE_TIPO_PROGRAMA_PROD"));
                 componentesPresProd.getEstadoReferencial().setCodEstadoRegistro(rs.getString("COD_ESTADO_REGISTRO"));
                 componentesPresProd.getEstadoReferencial().setNombreEstadoRegistro(rs.getString("NOMBRE_ESTADO_REGISTRO"));
                 componentesPresProdList.add(componentesPresProd);
             }
         } catch (Exception e) {
             e.printStackTrace();
         }
         return componentesPresProdList;
     }
     public String agregarComponentesPresProd_action(){
         componentesPresProd = new ComponentesPresProd();
         componentesPresProd.setComponentesProd(componentesProd);
         estadoRegistroList = this.cargarEstadoRegistro();
         return null;
     }
     public List cargarPresentacionesProducto(){
         List presentacionesProductoList = new ArrayList();
         try {
             Connection con = null;
             con = Util.openConnection(con);
             Statement st = con.createStatement();
             String consulta = " select p.cod_presentacion,p.NOMBRE_PRODUCTO_PRESENTACION  " +
                     " from PRESENTACIONES_PRODUCTO p where p.cod_presentacion not in (select c.COD_COMPPROD from COMPONENTES_PRESPROD c where c.COD_COMPPROD = '"+componentesProd.getCodCompprod()+"') " +
                     " and p.cod_estado_registro = 1 " +
                     " order by p.NOMBRE_PRODUCTO_PRESENTACION asc ";
             System.out.println("consulta " + consulta);
             ResultSet rs = st.executeQuery(consulta);
             while(rs.next()){
                 presentacionesProductoList.add(new SelectItem(rs.getString("COD_PRESENTACION"),rs.getString("NOMBRE_PRODUCTO_PRESENTACION")));
             }
         } catch (Exception e) {
             e.printStackTrace();
         }
         return presentacionesProductoList;
     }
     public String guardarComponentesPresProd_action(){
         try {
             Connection con = null;
             con = Util.openConnection(con);
             String consulta = " INSERT INTO COMPONENTES_PRESPROD(COD_COMPPROD,  COD_PRESENTACION,  CANT_COMPPROD,COD_TIPO_PROGRAMA_PROD,COD_ESTADO_REGISTRO) " +
                     " VALUES ('"+componentesPresProd.getComponentesProd().getCodCompprod()+"', '"+componentesPresProd.getPresentacionesProducto().getCodPresentacion()+"'," +
                     " '"+ (int)componentesPresProd.getCantCompProd()+"','"+componentesPresProd.getTiposProgramaProduccion().getCodTipoProgramaProd()+"'" +
                     ",'"+componentesPresProd.getEstadoReferencial().getCodEstadoRegistro()+"' ); ";

             System.out.println("consulta " + consulta);
             Statement st = con.createStatement();
             st.executeUpdate(consulta);
             componentesPresProdList = this.cargarComponentesPresProd();
         } catch (Exception e) {
             e.printStackTrace();
         }
         return null;
     }
    public String eliminarComponentesPresProd_action(){
        try {
            Iterator i = componentesPresProdList.iterator();
            while(i.hasNext()){
                ComponentesPresProd componentesPresProd1 = (ComponentesPresProd) i.next();
                System.out.println("iteracion " + componentesPresProd1.getChecked().booleanValue());
                if(componentesPresProd1.getChecked().booleanValue()==true){
                    Connection con = null;
                    con = Util.openConnection(con);
                    Statement st = con.createStatement();
                    String consulta = " delete from componentes_presprod where cod_compprod = '"+componentesPresProd1.getComponentesProd().getCodCompprod()+"' " +
                            " and cod_presentacion = '"+componentesPresProd1.getPresentacionesProducto().getCodPresentacion()+"' ";
                    System.out.println("consulta" + consulta);
                    st.executeUpdate(consulta);
                    break;
                }
            }
            componentesPresProdList = this.cargarComponentesPresProd();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public String editarComponentesPresProd_action(){
        try {
            Iterator i = componentesPresProdList.iterator();
            while(i.hasNext()){
                ComponentesPresProd componentesPresProd1 = (ComponentesPresProd) i.next();
                if(componentesPresProd1.getChecked().booleanValue()==true){
                    componentesPresProdEditar = componentesPresProd1;
                    //componentesPresProd = componentesPresProd1;
                    componentesPresProd.getComponentesProd().setCodCompprod(componentesPresProd1.getComponentesProd().getCodCompprod());
                    componentesPresProd.getPresentacionesProducto().setCodPresentacion(componentesPresProd1.getPresentacionesProducto().getCodPresentacion());
                    break;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public String guardarEditarComponentesPresProd_action(){
        try {
            Connection con = null;
            con = Util.openConnection(con);
            Statement st = con.createStatement();
            String consulta = " update componentes_presprod set cod_presentacion = '"+componentesPresProdEditar.getPresentacionesProducto().getCodPresentacion()+"', " +
                    " cant_compprod='"+(int)componentesPresProdEditar.getCantCompProd()+"',cod_tipo_programa_prod = '"+componentesPresProdEditar.getTiposProgramaProduccion().getCodTipoProgramaProd()+"', " +
                    " cod_estado_registro = '"+componentesPresProdEditar.getEstadoReferencial().getCodEstadoRegistro()+"' " +
                    " where cod_compprod = '"+componentesPresProd.getComponentesProd().getCodCompprod()+"' and cod_presentacion = '"+componentesPresProd.getPresentacionesProducto().getCodPresentacion()+"'  ";
            System.out.println("consulta " + consulta);
            st.executeUpdate(consulta);
            componentesPresProdList = this.cargarComponentesPresProd();
        } catch (Exception e) {
            e.printStackTrace();
        }
       return null;
    }
    //inicio ale
     private void cargarTiposRefenciasCc()
     {
         try
         {
             Connection con=null;
             con=Util.openConnection(con);
             Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
             ResultSet res=st.executeQuery("select tr.COD_REFERENCIACC,tr.NOMBRE_REFERENCIACC from TIPOS_REFERENCIACC tr ");
             listaTiposReferenciaCc.clear();
             while(res.next())
             {
                 listaTiposReferenciaCc.add(new SelectItem(res.getInt("COD_REFERENCIACC"),res.getString("NOMBRE_REFERENCIACC")));
             }
             res.close();
             st.close();
             con.close();
         }
         catch(SQLException ex)
         {
             ex.printStackTrace();
         }
     }
     public String agregarAnalisisMicrobiologia_Action()
     {
          componentesProd = (ComponentesProd)componentesProdDataTable.getRowData();
          try
          {
              Connection con=null;
              con=Util.openConnection(con);
              Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY) ;
              String consulta="select ISNULL(trcc.COD_REFERENCIACC,0) as codReferencia,efcc.COD_ESPECIFICACION,efcc.COD_TIPO_RESULTADO_ANALISIS,efcc.NOMBRE_ESPECIFICACION,ISNULL(efp.DESCRIPCION,'') as descripcion,"+
                              " ISNULL(efp.LIMITE_INFERIOR,0) as limiteInferior,ISNULL(efp.VALOR_EXACTO,0) AS valorExacto,ISNULL(efp.LIMITE_SUPERIOR,0) as limiteSuperior,ISNULL(efp.ESTADO,1) as estadoRegistro"+
                              " from ESPECIFICACIONES_ANALISIS_FORMAFAR eff inner join ESPECIFICACIONES_MICROBIOLOGIA efcc"+
                              " on efcc.COD_ESPECIFICACION=eff.COD_ESPECIFICACION left outer join ESPECIFICACIONES_MICROBIOLOGIA_PRODUCTO efp"+
                              " on efp.COD_ESPECIFICACION=efcc.COD_ESPECIFICACION and efp.COD_COMPROD='"+componentesProd.getCodCompprod()+"'"+
                              " left outer join TIPOS_REFERENCIACC trcc on trcc.COD_REFERENCIACC=efp.COD_REFERENCIA_CC"+
                              " where eff.COD_FORMAFAR='"+componentesProd.getForma().getCodForma()+"' AND eff.COD_TIPO_ANALISIS=3 order by efcc.NOMBRE_ESPECIFICACION";
              System.out.println("consulta "+consulta);
              ResultSet res=st.executeQuery(consulta);
              listaEspecificacionesMicrobiologia.clear();
              while(res.next())
              {
                    EspecificacionesMicrobiologiaProducto bean= new EspecificacionesMicrobiologiaProducto();
                    bean.setComponenteProd(componentesProd);
                    bean.getEspecificacionMicrobiologiaCc().setCodEspecificacion(res.getInt("COD_ESPECIFICACION"));
                    bean.getEspecificacionMicrobiologiaCc().setNombreEspecificacion(res.getString("NOMBRE_ESPECIFICACION"));
                    bean.getEspecificacionMicrobiologiaCc().getTipoResultadoAnalisis().setCodTipoResultadoAnalisis(res.getString("COD_TIPO_RESULTADO_ANALISIS"));
                    bean.setLimiteInferior(res.getDouble("limiteInferior"));
                    bean.setLimiteSuperior(res.getDouble("limiteSuperior"));
                    bean.setDescripcion(res.getString("descripcion"));
                    bean.setValorExacto(res.getDouble("valorExacto"));
                    bean.getEspecificacionMicrobiologiaCc().getTiposReferenciaCc().setCodReferenciaCc(res.getInt("codReferencia"));
                    bean.getEstado().setCodEstadoRegistro(res.getString("estadoRegistro"));
                    listaEspecificacionesMicrobiologia.add(bean);
              }
              this.cargarTiposRefenciasCc();
              res.close();
              st.close();
              con.close();
              this.redireccionar("agregarAnalisisMicrobiologia.jsf");
          }
          catch(SQLException ex)
          {
              ex.printStackTrace();
          }
          return null;
     }
     public String agregarAnalisisFisico_action(){
         try {
             componentesProd = (ComponentesProd)componentesProdDataTable.getRowData();
             String consulta="select ISNULL(trcc.COD_REFERENCIACC,0) as codTipoReferencia,efcc.COD_ESPECIFICACION,efcc.COD_TIPO_RESULTADO_ANALISIS,efcc.NOMBRE_ESPECIFICACION,ISNULL(efp.DESCRIPCION,'') as descripcion,"+
                             " ISNULL(efp.LIMITE_INFERIOR,0) as limiteInferior,ISNULL(efp.LIMITE_SUPERIOR,0) as limiteSuperior,ISNULL(efp.VALOR_EXACTO,0) as valorExacto,ISNULL(efp.ESTADO,1) as estado"+
                             " from ESPECIFICACIONES_ANALISIS_FORMAFAR eff inner join ESPECIFICACIONES_FISICAS_CC efcc"+
                             " on efcc.COD_ESPECIFICACION=eff.COD_ESPECIFICACION left outer join ESPECIFICACIONES_FISICAS_PRODUCTO efp"+
                             " on efp.COD_ESPECIFICACION=efcc.COD_ESPECIFICACION and efp.COD_PRODUCTO='"+componentesProd.getCodCompprod()+"'" +
                             " left outer join TIPOS_REFERENCIACC trcc on trcc.COD_REFERENCIACC=efp.COD_REFERENCIA_CC"+
                             " where eff.COD_FORMAFAR='"+componentesProd.getForma().getCodForma()+"' AND eff.COD_TIPO_ANALISIS=1 order by efcc.NOMBRE_ESPECIFICACION";
             System.out.println("consulta "+consulta);
             Connection con=null;
             con=Util.openConnection(con);
             Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
             ResultSet res=st.executeQuery(consulta);
             listaEspecificacionesFisicasProducto.clear();
             while(res.next())
             {
                 EspecificacionesFisicasProducto bean= new EspecificacionesFisicasProducto();
                 bean.setComponenteProd(componentesProd);
                 bean.setValorExacto(res.getDouble("valorExacto"));
                 bean.setDescripcion(res.getString("descripcion"));
                 bean.setLimiteInferior(res.getDouble("limiteInferior"));
                 bean.setLimiteSuperior(res.getDouble("limiteSuperior"));
                 bean.getEspecificacionFisicaCC().setCodEspecificacion(res.getInt("COD_ESPECIFICACION"));
                 bean.getEspecificacionFisicaCC().getTipoResultadoAnalisis().setCodTipoResultadoAnalisis(res.getString("COD_TIPO_RESULTADO_ANALISIS"));
                 bean.getEspecificacionFisicaCC().setNombreEspecificacion(res.getString("NOMBRE_ESPECIFICACION"));
                 bean.getEspecificacionFisicaCC().getTiposReferenciaCc().setCodReferenciaCc(res.getInt("codTipoReferencia"));
                 bean.getEstado().setCodEstadoRegistro(res.getString("estado"));
                 listaEspecificacionesFisicasProducto.add(bean);

             }
             this.cargarTiposRefenciasCc();
             res.close();
             st.close();
             con.close();
             this.redireccionar("agregarAnalisisFisico.jsf");
         } catch (Exception e) {
             e.printStackTrace();
         }
         return null;
     }
     private void cargarMaterialesPrincipioActivo(String codComprod)
     {
         try
         {
             Connection con=null;
             con=Util.openConnection(con);
             Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
             String consulta="select m.NOMBRE_MATERIAL,m.COD_MATERIAL,ISNULL(eqp.ESTADO, 1) as estado"+
                             " from FORMULA_MAESTRA fm inner join FORMULA_MAESTRA_DETALLE_MP fmd on "+
                             " fm.COD_FORMULA_MAESTRA = fmd.COD_FORMULA_MAESTRA inner join MATERIALES m on" +
                             " m.COD_MATERIAL = fmd.COD_MATERIAL left outer join ESPECIFICACIONES_QUIMICAS_PRODUCTO eqp on" +
                             " eqp.COD_MATERIAL = fmd.COD_MATERIAL and fm.COD_COMPPROD = eqp.COD_PRODUCTO "+
                             " where fm.COD_COMPPROD = '"+codComprod+"' and m.COD_GRUPO in (2,4) group by m.NOMBRE_MATERIAL,m.COD_MATERIAL,eqp.ESTADO order by m.NOMBRE_MATERIAL";
             System.out.println("consulta materiales principio activo "+consulta);
             ResultSet res=st.executeQuery(consulta);
             listaMaterialesPrincipioActivo.clear();
             while(res.next())
             {
                Materiales bean= new Materiales();
                bean.setCodMaterial(res.getString("COD_MATERIAL"));
                bean.setNombreMaterial(res.getString("NOMBRE_MATERIAL"));
                bean.getEstadoRegistro().setCodEstadoRegistro(res.getString("estado"));
                if(listaMaterialesPrincipioActivo.size()>0)
                {
                    if(listaMaterialesPrincipioActivo.get(listaMaterialesPrincipioActivo.size()-1).getCodMaterial().equals(bean.getCodMaterial()))
                    {
                        listaMaterialesPrincipioActivo.get(listaMaterialesPrincipioActivo.size()-1).getEstadoRegistro().setCodEstadoRegistro("3");
                    }

                    else
                    {
                        listaMaterialesPrincipioActivo.add(bean);
                    }
                }
                else
                {
                listaMaterialesPrincipioActivo.add(bean);
                }
             }
             res.close();
             st.close();
             con.close();
         }
         catch(SQLException ex)
         {
             ex.printStackTrace();
         }
     }
     private List<EspecificacionesQuimicasProducto> cargarEspecificacionesQuimicasProducto(int codEspecificacion,ComponentesProd componente)
     {
         List<EspecificacionesQuimicasProducto> lista= new ArrayList<EspecificacionesQuimicasProducto>();
         String consulta="select ISNULL(eqp.COD_REFERENCIA_CC,1) AS CODREFER, m.NOMBRE_MATERIAL,m.COD_MATERIAL,ISNULL(eqp.DESCRIPCION,'') as descripciom,"+
                         " ISNULL(eqp.LIMITE_INFERIOR,0) as limiteInferior,ISNULL(eqp.LIMITE_SUPERIOR,0) as limiteSuperior,"+
                         " ISNULL(eqp.ESTADO,1) as estado,ISNULL(eqp.VALOR_EXACTO,0) as valorExacto"+
                         " from FORMULA_MAESTRA fm inner join FORMULA_MAESTRA_DETALLE_MP fmd on"+
                         " fm.COD_FORMULA_MAESTRA=fmd.COD_FORMULA_MAESTRA inner join MATERIALES m on"+
                         " m.COD_MATERIAL=fmd.COD_MATERIAL left outer join ESPECIFICACIONES_QUIMICAS_PRODUCTO eqp"+
                         " on eqp.COD_MATERIAL=fmd.COD_MATERIAL and fm.COD_COMPPROD=eqp.COD_PRODUCTO and eqp.COD_ESPECIFICACION='"+codEspecificacion+"'"+
                         " where fm.COD_COMPPROD='"+componente.getCodCompprod()+"' and m.COD_GRUPO in(2,4) order by m.NOMBRE_MATERIAL";
         System.out.println("consulta detalle "+consulta);
         this.cargarTiposRefenciasCc();
         try
         {
         Connection cone=null;
         cone=Util.openConnection(cone);
         Statement st1=cone.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
         ResultSet res1=st1.executeQuery(consulta);
         while(res1.next())
         {
             EspecificacionesQuimicasProducto bean= new EspecificacionesQuimicasProducto();
             bean.setComponenteProd(componente);

             bean.setLimiteInferior(res1.getDouble("limiteInferior"));
             bean.setLimiteSuperior(res1.getDouble("limiteSuperior"));
             bean.setDescripcion(res1.getString("descripciom"));
             bean.getEspecificacionQuimica().setCodEspecificacion(codEspecificacion);
             bean.getMaterial().setCodMaterial(res1.getString("COD_MATERIAL"));
             bean.getMaterial().setNombreMaterial(res1.getString("NOMBRE_MATERIAL"));
             bean.getEstado().setCodEstadoRegistro(res1.getString("estado"));
             bean.getTiposReferenciaCc().setCodReferenciaCc(res1.getInt("CODREFER"));
             bean.setValorExacto(res1.getDouble("valorExacto"));
             lista.add(bean);
         }
         res1.close();
         st1.close();
         cone.close();
         }
         catch(SQLException ex)
         {
             ex.printStackTrace();
         }
         return lista;
     }
     public String agregarAnalisisQuimico_Action()
     {

          componentesProd = (ComponentesProd)componentesProdDataTable.getRowData();
          this.cargarMaterialesPrincipioActivo(componentesProd.getCodCompprod());
         try
         {
            Connection con=null;
            con=Util.openConnection(con);
            Statement st=con.createStatement();
            String consulta="select eqcc.COD_ESPECIFICACION,eqcc.NOMBRE_ESPECIFICACION,eqcc.COD_TIPO_RESULTADO_ANALISIS,tra.NOMBRE_TIPO_RESULTADO_ANALISIS from ESPECIFICACIONES_QUIMICAS_CC eqcc inner join TIPOS_RESULTADOS_ANALISIS tra "+
                            " on tra.COD_TIPO_RESULTADO_ANALISIS=eqcc.COD_TIPO_RESULTADO_ANALISIS inner join ESPECIFICACIONES_ANALISIS_FORMAFAR eqf"+
                            " on eqcc.COD_ESPECIFICACION=eqf.COD_ESPECIFICACION where eqf.COD_FORMAFAR='"+componentesProd.getForma().getCodForma()+"' and eqf.COD_TIPO_ANALISIS=2 order by eqcc.NOMBRE_ESPECIFICACION";
            System.out.println("consulta "+consulta);
            ResultSet res=st.executeQuery(consulta);
            listaEspecificacionesQuimicasCc.clear();
            while(res.next())
            {
                EspecificacionesQuimicasCc bean= new EspecificacionesQuimicasCc();
                bean.setNombreEspecificacion(res.getString("NOMBRE_ESPECIFICACION"));
                bean.setCodEspecificacion(res.getInt("COD_ESPECIFICACION"));
                bean.getTipoResultadoAnalisis().setCodTipoResultadoAnalisis(res.getString("COD_TIPO_RESULTADO_ANALISIS"));
                bean.getTipoResultadoAnalisis().setNombreTipoResultadoAnalisis(res.getString("NOMBRE_TIPO_RESULTADO_ANALISIS"));
                bean.setListaEspecificacionesQuimicasProducto(this.cargarEspecificacionesQuimicasProducto(bean.getCodEspecificacion(), componentesProd));

                listaEspecificacionesQuimicasCc.add(bean);
            }
            res.close();
            st.close();
            con.close();
            this.redireccionar("agregarAnalisisQuimico.jsf");
         }
         catch(SQLException ex)
         {
             ex.printStackTrace();
         }
         return null;
     }
     public String guardarAnalisisFisico_Action()
     {
        try
        {
            Connection con =null;
            con=Util.openConnection(con);
            String consulta="";
            for(EspecificacionesFisicasProducto current: listaEspecificacionesFisicasProducto)
            {
                consulta=" delete from ESPECIFICACIONES_FISICAS_PRODUCTO where COD_PRODUCTO='"+current.getComponenteProd().getCodCompprod()+"' and COD_ESPECIFICACION='"+current.getEspecificacionFisicaCC().getCodEspecificacion()+"'";
                System.out.println("consulta delete "+consulta);
                PreparedStatement pst=con.prepareStatement(consulta);
                if(pst.executeUpdate()>0)System.out.println("existian detalles y se eliminaron ");
                consulta="INSERT INTO ESPECIFICACIONES_FISICAS_PRODUCTO(COD_PRODUCTO, COD_ESPECIFICACION,"+
                         " LIMITE_INFERIOR, LIMITE_SUPERIOR, DESCRIPCION,COD_REFERENCIA_CC,ESTADO,VALOR_EXACTO)VALUES("+
                         "'"+current.getComponenteProd().getCodCompprod()+"','"+current.getEspecificacionFisicaCC().getCodEspecificacion()+"'," +
                         "'"+current.getLimiteInferior()+"','"+current.getLimiteSuperior()+"','"+current.getDescripcion()+"','"+current.getEspecificacionFisicaCC().getTiposReferenciaCc().getCodReferenciaCc()+"'" +
                         ",'"+current.getEstado().getCodEstadoRegistro()+"','"+current.getValorExacto()+"')";
                System.out.println("consulta "+consulta);
                pst=con.prepareStatement(consulta);
                if(pst.executeUpdate()>0)System.out.println("se registro el detalle");
                pst.close();
            }
            con.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
        this.redireccionar("navegador_componentesProducto.jsf");
        return null;
     }
     public String guardarAnalisisMicrobiologico_Action()
     {
         try
         {
             Connection con=null;
             con=Util.openConnection(con);
             PreparedStatement pst=null;
             for(EspecificacionesMicrobiologiaProducto current: listaEspecificacionesMicrobiologia)
             {
                 String consulta="DELETE ESPECIFICACIONES_MICROBIOLOGIA_PRODUCTO WHERE COD_COMPROD='"+current.getComponenteProd().getCodCompprod()+"' and COD_ESPECIFICACION='"+current.getEspecificacionMicrobiologiaCc().getCodEspecificacion()+"'";
                 System.out.println("consulta delete "+consulta);
                 pst=con.prepareStatement(consulta);
                 if(pst.executeUpdate()>0)System.out.println("se elimino correctamente los detalles");
                 consulta="INSERT INTO ESPECIFICACIONES_MICROBIOLOGIA_PRODUCTO(COD_COMPROD,"+
                           " COD_ESPECIFICACION, LIMITE_INFERIOR, LIMITE_SUPERIOR, DESCRIPCION,COD_REFERENCIA_CC,ESTADO,VALOR_EXACTO)"+
                           " VALUES ('"+current.getComponenteProd().getCodCompprod()+"','"+current.getEspecificacionMicrobiologiaCc().getCodEspecificacion()+"'," +
                           " '"+current.getLimiteInferior()+"','"+current.getLimiteSuperior()+"','"+current.getDescripcion()+"','"+current.getEspecificacionMicrobiologiaCc().getTiposReferenciaCc().getCodReferenciaCc()+"'" +
                           ",'"+current.getEstado().getCodEstadoRegistro()+"','"+current.getValorExacto()+"')";
                 System.out.println("consulta "+consulta);
                 pst=con.prepareStatement(consulta);
                 if(pst.executeUpdate()>0)System.out.println("se registro el detalle");
             }
             con.close();
             this.redireccionar("navegador_componentesProducto.jsf");
         }
         catch(SQLException ex)
         {
             ex.printStackTrace();
         }

        return null;

     }
     public String cancelar()
     {
         this.redireccionar("navegador_componentesProducto.jsf");
         return null;
     }
     public  String habilitarMaterialesPrincipioActivo()
     {
        for(EspecificacionesQuimicasCc current:listaEspecificacionesQuimicasCc)
        {
            for(EspecificacionesQuimicasProducto current1:current.getListaEspecificacionesQuimicasProducto())
            {
                for(Materiales currentM:listaMaterialesPrincipioActivo)
                {
                    if(currentM.getCodMaterial().equals(current1.getMaterial().getCodMaterial())&&(!currentM.getCodMaterial().equals("3")))
                    {
                        current1.getEstado().setCodEstadoRegistro(currentM.getEstadoRegistro().getCodEstadoRegistro());
                    }
                }
            }
        }
       return null;
     }
     public String guardarAnalisisQuimico_Action()
     {
         try
         {
             Connection con=null;
             con=Util.openConnection(con);
             PreparedStatement pst=null;

         for(EspecificacionesQuimicasCc current:listaEspecificacionesQuimicasCc)
         {

             for( EspecificacionesQuimicasProducto current1:current.getListaEspecificacionesQuimicasProducto())
             {
                 String consulta="DELETE ESPECIFICACIONES_QUIMICAS_PRODUCTO WHERE COD_PRODUCTO ='"+current1.getComponenteProd().getCodCompprod()+"' AND COD_ESPECIFICACION='"+current.getCodEspecificacion()+"' AND COD_MATERIAL='"+current1.getMaterial().getCodMaterial()+"'";
                 System.out.println("consulta delete "+consulta);
                 pst=con.prepareStatement(consulta);
                 if(pst.executeUpdate()>0)System.out.println("se elimino el detalle");
                 consulta="INSERT INTO ESPECIFICACIONES_QUIMICAS_PRODUCTO(COD_ESPECIFICACION, COD_PRODUCTO,"+
                                  "COD_MATERIAL, LIMITE_INFERIOR, LIMITE_SUPERIOR, DESCRIPCION, ESTADO,"+
                                  " COD_REFERENCIA_CC,VALOR_EXACTO) VALUES (" +
                                  "'"+current.getCodEspecificacion()+"','"+current1.getComponenteProd().getCodCompprod()+"','"+current1.getMaterial().getCodMaterial()+"'"+
                                  ",'"+current1.getLimiteInferior()+"','"+current1.getLimiteSuperior()+"','"+current1.getDescripcion()+"'," +
                                  "'"+current1.getEstado().getCodEstadoRegistro()+"','"+current1.getTiposReferenciaCc().getCodReferenciaCc()+"'" +
                                  ",'"+current1.getValorExacto()+"')";
                                  System.out.println("consulta "+consulta);

                 pst=con.prepareStatement(consulta);
                 if(pst.executeUpdate()>0)System.out.println("se registro el detalle");
             }
         }
         con.close();
         }
         catch(SQLException ex)
         {
             ex.printStackTrace();
         }
         this.redireccionar("navegador_componentesProducto.jsf");
         return null;
     }
     private void cargarTiposProduccion(boolean navegador)
    {
         ManagedAccesoSistema usuario=(ManagedAccesoSistema)Util.getSession("ManagedAccesoSistema");
        try
        {
            Connection con1=null;
            con1=Util.openConnection(con1);
            Statement st=con1.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select tp.COD_TIPO_PRODUCCION,tp.NOMBRE_TIPO_PRODUCCION from TIPOS_PRODUCCION tp inner join usuarios_area_produccion ua on ua.cod_area_empresa = tp.cod_area_empresa and ua.cod_tipo_permiso = 2 and ua.cod_personal = '"+usuario.getUsuarioModuloBean().getCodUsuarioGlobal()+"'";
            System.out.println("consulta cargar tipos produccion "+consulta);
            ResultSet res=st.executeQuery(consulta);
            tiposProduccionList.clear();
            
            while(res.next())
            {
                tiposProduccionList.add(new SelectItem(res.getInt("COD_TIPO_PRODUCCION"),res.getString("NOMBRE_TIPO_PRODUCCION")));
            }
            if(navegador || tiposProduccionList.size()==0)
            {
                tiposProduccionList.add(new SelectItem(0,"-TODOS-"));
            }
            res.close();
            st.close();
            con1.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
    }
     private boolean verificarFormulaMaestraProgramaProduccion(String codCompProd)
    {
        boolean existe=false;
        try
        {
            Connection con1=null;
            con1=Util.openConnection(con1);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select top 1 * from FORMULA_MAESTRA f where f.COD_COMPPROD='"+codCompProd+"'";
            System.out.println("consulta veriricar "+consulta);
            ResultSet res=st.executeQuery(consulta);
            existe=res.next();
            if(!existe)
            {
                consulta="select top 1 * from PROGRAMA_PRODUCCION p where p.COD_COMPPROD='"+codCompProd+"'";
                System.out.println("cnsulva verificar programa"+consulta);
                res=st.executeQuery(consulta);
                existe=res.next();
            }
            res.close();
            st.close();
            con1.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
        return existe;
    }
     public String onChangeFiltroProductos()
    {
        this.cargarComponentesProducto1();
        return null;
    }
    public String getCargarNuevoProductoSemiterminado()
    {
        this.cargarTiposProduccion(false);
        componentesProdbean=new ComponentesProd();
        cargarColorPresentacion("",null);
        cargarProductosFormasFar("",null);
        cargarEnvasePrimario("",null);
        cargarSaborProducto("",null);
        cargarAreasEmpresa("",null);
        cargarProductos("",null);
        cargarEstadoCompProd("",null);
        
        componentesProdbean=new ComponentesProd();
        return null;

    }
    public String tiposProduccion_change()
    {
        this.cargarComponentesProducto1();
        return null;
    }
    
    public String editarTipoProduccion_action(){
        Iterator i = componentesProductoList.iterator();
        while(i.hasNext()){
            componentesProdbean = (ComponentesProd) i.next();
            if(componentesProdbean.getChecked()){
                break;
            }
        }
        Util.redireccionar("modificartipoProduccionComponentesProducto.jsf");
        return null;
    }
    public String guardarEditarTipoProduccion_action(){
        try {
            Connection con = null;
            con = Util.openConnection(con);
            Statement st = con.createStatement();
            String consulta = " update componentes_prod set cod_tipo_produccion = '"+componentesProdbean.getTipoProduccion().getCodTipoProduccion()+"' where cod_compprod = '"+componentesProdbean.getCodCompprod()+"'";
            System.out.println("consulta " + consulta);
            st.executeUpdate(consulta);
            st.close();
            con.close();
            Util.redireccionar("navegador_componentesProducto.jsf");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    //----------------------
    public String getCargarComponentesProdFormato(){
        try {
            ManagedAccesoSistema usuario=(ManagedAccesoSistema)Util.getSession("ManagedAccesoSistema");
            
            String consulta = " select cp.COD_PROD,cp.COD_COMPPROD,cp.nombre_prod_semiterminado,ff.cod_forma,ff.nombre_forma,cp.VOLUMENPESO_ENVASEPRIM,  " +
                    " ae.COD_AREA_EMPRESA,ae.NOMBRE_AREA_EMPRESA,cp.NOMBRE_GENERICO,cp.REG_SANITARIO,cp.FECHA_VENCIMIENTO_RS,cp.VIDA_UTIL,ec.COD_ESTADO_COMPPROD,ec.NOMBRE_ESTADO_COMPPROD,cp.COD_COMPUESTOPROD " +
                    ",cp.VOLUMEN_ENVASE_PRIMARIO,cp.CONCENTRACION_ENVASE_PRIMARIO,cp.PESO_ENVASE_PRIMARIO" +
                    " ,tp.COD_TIPO_PRODUCCION,tp.NOMBRE_TIPO_PRODUCCION" +
                    " ,cp.CANTIDAD_VOLUMEN,isnull(cp.COD_UNIDAD_MEDIDA_VOLUMEN,0) as COD_UNIDAD_MEDIDA_VOLUMEN,isnull(um.ABREVIATURA,'') as abreviatura,cp.TOLERANCIA_VOLUMEN_FABRICAR,tcf.valor_tipo_compprod_formato" +
                    " from componentes_prod cp left outer join FORMAS_FARMACEUTICAS ff on ff.cod_forma = cp.COD_FORMA " +
                    " inner join AREAS_EMPRESA ae on ae.COD_AREA_EMPRESA = cp.COD_AREA_EMPRESA " +
                    " inner join ESTADOS_COMPPROD ec on ec.COD_ESTADO_COMPPROD = cp.COD_ESTADO_COMPPROD " +
                    " inner join TIPOS_PRODUCCION tp on tp.COD_TIPO_PRODUCCION=cp.COD_TIPO_PRODUCCION" +
                    " inner join usuarios_area_produccion u on u.cod_area_empresa = t.cod_area_empresa and u.cod_tipo_permiso = 2 and u.cod_personal = '"+usuario.getUsuarioModuloBean().getCodUsuarioGlobal()+"' " +
                    " left outer join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=cp.COD_UNIDAD_MEDIDA_VOLUMEN" +
                    " left outer join tipos_compprod_formato tcf on tcf.cod_tipo_compprod_formato = cp.cod_tipo_compprod_formato " +
                    " where ec.cod_estado_compprod = cp.cod_estado_compprod  and cp.cod_estado_compprod = 1 "+(codTipoCompProdFormato==0?"":" AND cp.COD_TIPO_COMPPROD_FORMATO = '"+codTipoCompProdFormato+"' ");
                    System.out.println("consulta " + consulta);
                    Connection con = null;
                    con = Util.openConnection(con);
                    Statement st = con.createStatement();
                    ResultSet rs = st.executeQuery(consulta);
                    componentesProductoList.clear();
                while(rs.next()){
                ComponentesProd componentesProd=new ComponentesProd();
                componentesProd.getUnidadMedidaVolumen().setCodUnidadMedida(rs.getString("COD_UNIDAD_MEDIDA_VOLUMEN"));
                componentesProd.getUnidadMedidaVolumen().setAbreviatura(rs.getString("abreviatura"));
                componentesProd.setCantidadVolumen(rs.getDouble("CANTIDAD_VOLUMEN"));
                //componentesProd.setToleranciaVolumenfabricar(rs.getDouble("TOLERANCIA_VOLUMEN_FABRICAR"));
                //componentesProd.getViasAdministracionProducto().setCodViaAdministracionProducto(rs.getInt("COD_VIA_ADMINISTRACION_PRODUCTO"));
                //componentesProd.getViasAdministracionProducto().setNombreViaAdministracionProducto(rs.getString("NOMBRE_VIA_ADMINISTRACION_PRODUCTO"));
                componentesProd.setCodCompprod(rs.getString("cod_compprod"));
                componentesProd.setNombreProdSemiterminado(rs.getString("nombre_prod_semiterminado"));
                componentesProd.getForma().setCodForma(rs.getString("cod_forma"));
                componentesProd.getForma().setNombreForma(rs.getString("nombre_forma"));
                //componentesProd.setVolumenPesoEnvasePrim(rs.getString("VOLUMENPESO_ENVASEPRIM"));
                //componentesProd.getColoresPresentacion().setCodColor(rs.getString("COD_COLORPRESPRIMARIA"));
                //componentesProd.getColoresPresentacion().setNombreColor(rs.getString("NOMBRE_COLORPRESPRIMARIA"));
                //componentesProd.getSaboresProductos().setCodSabor(rs.getString("COD_SABOR"));
                //componentesProd.getSaboresProductos().setNombreSabor(rs.getString("NOMBRE_SABOR"));
                componentesProd.getAreasEmpresa().setCodAreaEmpresa(rs.getString("COD_AREA_EMPRESA"));
                componentesProd.getAreasEmpresa().setNombreAreaEmpresa(rs.getString("NOMBRE_AREA_EMPRESA"));
                componentesProd.setNombreGenerico(rs.getString("NOMBRE_GENERICO"));
                //componentesProd.setRegSanitario(rs.getString("REG_SANITARIO"));
                //componentesProd.setFechaVencimientoRS(rs.getDate("FECHA_VENCIMIENTO_RS"));
                //componentesProd.setVidaUtil(rs.getString("VIDA_UTIL"));
                componentesProd.getEstadoCompProd().setCodEstadoCompProd(rs.getInt("COD_ESTADO_COMPPROD"));
                componentesProd.getEstadoCompProd().setNombreEstadoCompProd(rs.getString("NOMBRE_ESTADO_COMPPROD"));
                //componentesProd.setCodcompuestoprod(rs.getString("COD_COMPUESTOPROD"));
                //componentesProd.setPesoEnvasePrimario(rs.getString("PESO_ENVASE_PRIMARIO"));
                //componentesProd.setConcentracionEnvasePrimario(rs.getString("CONCENTRACION_ENVASE_PRIMARIO"));
                //componentesProd.setVolumenEnvasePrimario(rs.getString("VOLUMEN_ENVASE_PRIMARIO"));
                //componentesProd.getProducto().setCodProducto(rs.getString("COD_PROD"));
                componentesProd.getTipoProduccion().setCodTipoProduccion(rs.getInt("COD_TIPO_PRODUCCION"));
                componentesProd.getTipoProduccion().setNombreTipoProduccion(rs.getString("NOMBRE_TIPO_PRODUCCION"));
                componentesProd.getTiposCompProdFormato().setValorTipoCompProdFormato(rs.getFloat("valor_tipo_compprod_formato"));
                componentesProductoList.add(componentesProd);
                //rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    List componentesProdFormatosList = new ArrayList();
    String codFormatoMaquinaria = "";
    
    public List cargarFormatoComponentesProd(){
        List formatoComponentesProdList = new ArrayList();
        try {
            Connection con = null;
            con = Util.openConnection(con);
            Statement st = con.createStatement();
            String consulta = " select maf.cod_maquinaria_actividad,c.nombre_prod_semiterminado,apr.NOMBRE_ACTIVIDAD,m.NOMBRE_MAQUINA,maf.HORAS_HOMBRE,maf.HORAS_MAQUINA " +
                    " ,c.COD_COMPPROD,fm.COD_FORMULA_MAESTRA,afm.COD_ACTIVIDAD_FORMULA,afm.COD_ACTIVIDAD,m.COD_MAQUINA,t.cod_tipo_formato_maquina,t.nombre_tipo_formato_maquina" +
                    " from COMPONENTES_PROD c inner join FORMULA_MAESTRA fm on fm.COD_COMPPROD = c.COD_COMPPROD" +
                    " inner join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_FORMULA_MAESTRA = fm.COD_FORMULA_MAESTRA" +
                    " inner join ACTIVIDADES_PRODUCCION apr on apr.COD_ACTIVIDAD = afm.COD_ACTIVIDAD" +
                    " inner join MAQUINARIA_ACTIVIDADES_FORMULA maf on maf.COD_ACTIVIDAD_FORMULA = afm.COD_ACTIVIDAD_FORMULA" +
                    " inner join MAQUINARIAS m on m.COD_MAQUINA = maf.COD_MAQUINA" +
                    " left outer join TIPOS_FORMATO_MAQUINARIA t on t.cod_tipo_formato_maquina = maf.cod_tipo_formato_maquina " +
                    " where afm.COD_ESTADO_REGISTRO = 1 and maf.COD_ESTADO_REGISTRO = 1 and m.cod_maquina in (66,73,86,170,78,85,81,83)" +
                    (codTipoCompProdFormato!=0?" and t.cod_tipo_formato_maquina = '"+codTipoCompProdFormato+"' ":"") +
                    (!codAreaEmpresa.equals("0")?" and c.cod_area_empresa = '"+codAreaEmpresa+"' ":"") +
                    " order by c.nombre_prod_semiterminado, afm.ORDEN_ACTIVIDAD asc ";
            System.out.println("consulta " + consulta);
            ResultSet rs = st.executeQuery(consulta);
            while(rs.next()){
                MaquinariaActividadesFormula m = new MaquinariaActividadesFormula();
                m.getActividadesFormulaMaestra().getFormulaMaestra().getComponentesProd().setNombreProdSemiterminado(rs.getString("nombre_prod_semiterminado"));
                m.getActividadesFormulaMaestra().getActividadesProduccion().setNombreActividad(rs.getString("nombre_actividad"));
                m.getMaquinaria().setNombreMaquina(rs.getString("nombre_maquina"));
                m.getMaquinaria().setCodMaquina(rs.getString("cod_maquina"));
                m.setHorasMaquina(rs.getFloat("horas_maquina"));
                m.setHorasHombre(rs.getFloat("horas_hombre"));
                m.getActividadesFormulaMaestra().getFormulaMaestra().setCodFormulaMaestra(rs.getString("cod_formula_maestra"));
                m.setCodMaquinariaActividad(rs.getString("cod_maquinaria_actividad"));
                m.getActividadesFormulaMaestra().getFormulaMaestra().getComponentesProd().setCodCompprod(rs.getString("cod_compprod"));
                m.getActividadesFormulaMaestra().setCodActividadFormula(rs.getInt("cod_actividad_formula"));
                m.setFormatoMaquina(rs.getString("nombre_tipo_formato_maquina"));
                formatoComponentesProdList.add(m);
            }
            rs.close();
            st.close();
            con.close();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return formatoComponentesProdList;
    }
    public String getCargarFormatoMaquinarias(){
        tiposComponentesProdFormatoList = this.cargarCompProdFormato();
        this.cargarAreasEmpresa("", new ComponentesProd());
        componentesProdFormatosList = this.cargarFormatoComponentesProd();
        return null;
    }
    public String actualizarFormatoMaquinaria_action(){
        try {
            Connection con = null;
            con = Util.openConnection(con);
            Statement st = con.createStatement();
            String consulta = "";
            Iterator i = componentesProdFormatosList.iterator();
            while(i.hasNext()){
                MaquinariaActividadesFormula m = (MaquinariaActividadesFormula) i.next();
                if(m.getChecked()){
                consulta = " UPDATE MAQUINARIA_ACTIVIDADES_FORMULA  SET COD_TIPO_FORMATO_MAQUINA = '"+codTipoCompProdFormato+"'" +
                        " where COD_MAQUINA = '"+m.getMaquinaria().getCodMaquina()+"' and " +
                        " COD_ACTIVIDAD_FORMULA = '"+m.getActividadesFormulaMaestra().getCodActividadFormula()+"'" +
                        " and cod_maquinaria_actividad = '"+m.getCodMaquinariaActividad()+"'";
                System.out.println("consulta "+ consulta);
                st.executeUpdate(consulta);
                }
            }
            st.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    List tiposComponentesProdFormatoList = new ArrayList();
    int codTipoCompProdFormato = 0;
    String codAreaEmpresa = "";
    public List cargarCompProdFormato(){
        List list = new ArrayList();
        try {
            String consulta = " select cod_tipo_formato_maquina,nombre_tipo_formato_maquina from tipos_formato_maquinaria t ";
            Connection con = null;
            con = Util.openConnection(con);
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery(consulta);
            list.add(new SelectItem("0","-TODOS-"));
            while(rs.next()) {
                list.add(new SelectItem(rs.getString("cod_tipo_formato_maquina"),rs.getString("nombre_tipo_formato_maquina")));
            }
            rs.close();
            st.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    public String editarCompProdFormato(){
        try {
            Iterator i = componentesProductoList.iterator();
            while(i.hasNext()){
                ComponentesProd c = (ComponentesProd) i.next();
                if(c.getChecked()){
                    componentesProdbean = c;
                    break;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public String guardarTipoCompProdFormato_action(){
        try {
        Iterator i  = componentesProductoList.iterator();
        String consulta = "";
        Connection con = null;
        con = Util.openConnection(con);
        Statement st = con.createStatement();
        while(i.hasNext()){
              ComponentesProd c = (ComponentesProd) i.next();
              if(c.getChecked()){
                  consulta = " update componentes_prod set cod_tipo_compprod_formato = '"+codTipoCompProdFormato+"'  where cod_compprod = '"+c.getCodCompprod()+"' ";
                  System.out.println("consulta " + consulta);
                  st.executeUpdate(consulta);
              }
        }
        st.close();
        con.close();
        this.codTipoCompProdFormato = 0;
        this.getCargarComponentesProdFormato();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public String getCargarCompProdFormato_1(){
        tiposComponentesProdFormatoList = this.cargarCompProdFormato();
        this.getCargarComponentesProdFormato();
        return null;
    }
    public String tiposCompProdFormato_change(){
        componentesProdFormatosList = this.cargarFormatoComponentesProd();
        return null;
    }

    


    //---------------
    public String getCargarAgregarPresentacionPrimaria()
    {
        presentacionesPrimarias=new PresentacionesPrimarias();
        return null;
    }
     //final ale
    public void setPresentacionesPrimarias(PresentacionesPrimarias presentacionesPrimarias) {
        this.presentacionesPrimarias = presentacionesPrimarias;
    }
    
    public String getNombreComProd() {
        return nombreComProd;
    }
    
    public void setNombreComProd(String nombreComProd) {
        this.nombreComProd = nombreComProd;
    }
    
    public List getAccionesTerapeuticasList() {
        return accionesTerapeuticasList;
    }
    
    public void setAccionesTerapeuticasList(List accionesTerapeuticasList) {
        this.accionesTerapeuticasList = accionesTerapeuticasList;
    }
    
    public List getEstadosCompProdList() {
        return estadosCompProdList;
    }
    
    public void setEstadosCompProdList(List estadosCompProdList) {
        this.estadosCompProdList = estadosCompProdList;
    }

    public List getEstadoRegistroList() {
        return estadoRegistroList;
    }

    public void setEstadoRegistroList(List estadoRegistroList) {
        this.estadoRegistroList = estadoRegistroList;
    }

    public List getTiposProgramaProduccionList() {
        return tiposProgramaProduccionList;
    }

    public void setTiposProgramaProduccionList(List tiposProgramaProduccionList) {
        this.tiposProgramaProduccionList = tiposProgramaProduccionList;
    }

    public HtmlDataTable getComponentesProdDataTable() {
        return componentesProdDataTable;
    }

    public void setComponentesProdDataTable(HtmlDataTable componentesProdDataTable) {
        this.componentesProdDataTable = componentesProdDataTable;
    }

    public ComponentesProd getComponentesProd() {
        return componentesProd;
    }

    public void setComponentesProd(ComponentesProd componentesProd) {
        this.componentesProd = componentesProd;
    }

    public List getComponentesPresProdList() {
        return componentesPresProdList;
    }

    public void setComponentesPresProdList(List componentesPresProdList) {
        this.componentesPresProdList = componentesPresProdList;
    }

    public ComponentesPresProd getComponentesPresProd() {
        return componentesPresProd;
    }

    public void setComponentesPresProd(ComponentesPresProd componentesPresProd) {
        this.componentesPresProd = componentesPresProd;
    }

    public List getPresentacionesSecundariasList() {
        return presentacionesSecundariasList;
    }

    public void setPresentacionesSecundariasList(List presentacionesSecundariasList) {
        this.presentacionesSecundariasList = presentacionesSecundariasList;
    }

    public ComponentesPresProd getComponentesPresProdEditar() {
        return componentesPresProdEditar;
    }

    public void setComponentesPresProdEditar(ComponentesPresProd componentesPresProdEditar) {
        this.componentesPresProdEditar = componentesPresProdEditar;
    }

    public List<EspecificacionesFisicasProducto> getListaEspecificacionesFisicasProducto() {
        return listaEspecificacionesFisicasProducto;
    }

    public void setListaEspecificacionesFisicasProducto(List<EspecificacionesFisicasProducto> listaEspecificacionesFisicasProducto) {
        this.listaEspecificacionesFisicasProducto = listaEspecificacionesFisicasProducto;
    }

    public List<EspecificacionesMicrobiologiaProducto> getListaEspecificacionesMicrobiologia() {
        return listaEspecificacionesMicrobiologia;
    }

    public void setListaEspecificacionesMicrobiologia(List<EspecificacionesMicrobiologiaProducto> listaEspecificacionesMicrobiologia) {
        this.listaEspecificacionesMicrobiologia = listaEspecificacionesMicrobiologia;
    }

    public List<EspecificacionesQuimicasCc> getListaEspecificacionesQuimicasCc() {
        return listaEspecificacionesQuimicasCc;
    }

    public void setListaEspecificacionesQuimicasCc(List<EspecificacionesQuimicasCc> listaEspecificacionesQuimicasCc) {
        this.listaEspecificacionesQuimicasCc = listaEspecificacionesQuimicasCc;
    }

    public List<Materiales> getListaMaterialesPrincipioActivo() {
        return listaMaterialesPrincipioActivo;
    }

    public void setListaMaterialesPrincipioActivo(List<Materiales> listaMaterialesPrincipioActivo) {
        this.listaMaterialesPrincipioActivo = listaMaterialesPrincipioActivo;
    }

    public List<SelectItem> getListaTiposReferenciaCc() {
        return listaTiposReferenciaCc;
    }

    public void setListaTiposReferenciaCc(List<SelectItem> listaTiposReferenciaCc) {
        this.listaTiposReferenciaCc = listaTiposReferenciaCc;
    }

    public List getTiposProduccionList() {
        return tiposProduccionList;
    }

    public void setTiposProduccionList(List tiposProduccionList) {
        this.tiposProduccionList = tiposProduccionList;
    }

    public List<String> getPresentacionesProducto() {
        return presentacionesProducto;
    }

    public void setPresentacionesProducto(List<String> presentacionesProducto) {
        this.presentacionesProducto = presentacionesProducto;
    }

    public boolean isAgregarEdicionProd() {
        return agregarEdicionProd;
    }

    public void setAgregarEdicionProd(boolean agregarEdicionProd) {
        this.agregarEdicionProd = agregarEdicionProd;
    }

    public boolean isEditarRs() {
        return editarRs;
    }

    public void setEditarRs(boolean editarRs) {
        this.editarRs = editarRs;
    }

    public boolean isEditarTipoProd() {
        return editarTipoProd;
    }

    public void setEditarTipoProd(boolean editarTipoProd) {
        this.editarTipoProd = editarTipoProd;
    }

    public boolean isOpcionPresPrim() {
        return opcionPresPrim;
    }

    public void setOpcionPresPrim(boolean opcionPresPrim) {
        this.opcionPresPrim = opcionPresPrim;
    }

    public boolean isOpcionPresSecun() {
        return opcionPresSecun;
    }

    public void setOpcionPresSecun(boolean opcionPresSecun) {
        this.opcionPresSecun = opcionPresSecun;
    }

    public ViasAdministracionProducto getViasAdministracionProductoBean() {
        return viasAdministracionProductoBean;
    }

    public void setViasAdministracionProductoBean(ViasAdministracionProducto viasAdministracionProductoBean) {
        this.viasAdministracionProductoBean = viasAdministracionProductoBean;
    }

    public List<ViasAdministracionProducto> getViasAdministracionProductoList() {
        return viasAdministracionProductoList;
    }

    public void setViasAdministracionProductoList(List<ViasAdministracionProducto> viasAdministracionProductoList) {
        this.viasAdministracionProductoList = viasAdministracionProductoList;
    }

    public String getMensaje() {
        return mensaje;
    }

    public void setMensaje(String mensaje) {
        this.mensaje = mensaje;
    }

    public List<SelectItem> getViasAdministracionSelectList() {
        return viasAdministracionSelectList;
    }

    public void setViasAdministracionSelectList(List<SelectItem> viasAdministracionSelectList) {
        this.viasAdministracionSelectList = viasAdministracionSelectList;
    }

    public List<SelectItem> getUnidadesMedidadSelectList() {
        return unidadesMedidadSelectList;
    }

    public void setUnidadesMedidadSelectList(List<SelectItem> unidadesMedidadSelectList) {
        this.unidadesMedidadSelectList = unidadesMedidadSelectList;
    }

    public int getCodTipoCompProdFormato() {
        return codTipoCompProdFormato;
    }

    public void setCodTipoCompProdFormato(int codTipoCompProdFormato) {
        this.codTipoCompProdFormato = codTipoCompProdFormato;
    }

    public List getTiposComponentesProdFormatoList() {
        return tiposComponentesProdFormatoList;
    }

    public void setTiposComponentesProdFormatoList(List tiposComponentesProdFormatoList) {
        this.tiposComponentesProdFormatoList = tiposComponentesProdFormatoList;
    }

    public String getCodFormatoMaquinaria() {
        return codFormatoMaquinaria;
    }

    public void setCodFormatoMaquinaria(String codFormatoMaquinaria) {
        this.codFormatoMaquinaria = codFormatoMaquinaria;
    }

    public List getComponentesProdFormatosList() {
        return componentesProdFormatosList;
    }

    public void setComponentesProdFormatosList(List componentesProdFormatosList) {
        this.componentesProdFormatosList = componentesProdFormatosList;
    }

    public String getCodAreaEmpresa() {
        return codAreaEmpresa;
    }

    public void setCodAreaEmpresa(String codAreaEmpresa) {
        this.codAreaEmpresa = codAreaEmpresa;
    }


    



    
    
}
