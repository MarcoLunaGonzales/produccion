/*
 * ManagedBeanProductosCombinados.java
 *
 * Created on 15 de septiembre de 2008, 16:57
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.cofar.web;

import com.cofar.bean.MaterialPromocional;
import com.cofar.bean.PresentacionesProducto;
import com.cofar.bean.ComponentesProd;
import com.cofar.bean.PresentacionesProductoMaterialPromocional;

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
import java.util.Map;
import javax.faces.event.ActionEvent;
import javax.faces.event.ValueChangeEvent;
import javax.faces.model.ResultDataModel;
import javax.faces.model.SelectItem;
import javax.servlet.jsp.jstl.sql.ResultSupport;
import org.ajax4jsf.component.html.HtmlAjaxCommandLink;
/**
 *
 * @author Rene
 */
public class ManagedBeanProductosCombinados {
    
    /** Creates a new instance of ManagedBeanProductosCombinados */
    private List presentacionesProductoList=new ArrayList();
    private List presentacionesProductoEli=new ArrayList();
    private List presentacionesProductoEli2=new ArrayList();
    private PresentacionesProducto presentacionesProducto=new PresentacionesProducto();
    private ComponentesProd componentesProd=new ComponentesProd();
    private Connection con;
    private List estadoRegistro=new  ArrayList();
    private List productos=new  ArrayList();
    private List tiposMercaderia=new  ArrayList();
    private List envasesSecundarios=new  ArrayList();
    private List lineasMKTList=new ArrayList();
    private List formasFarList=new ArrayList();
    private List envasesTerciarios=new ArrayList();
    private List cartonesCorrugados=new ArrayList();
    private String codigo="";
    private ResultDataModel componentesList;
    //*datos de los componentes
    private List listaComponentesBuscar=new ArrayList();
    private List listaComponentesSeleccionados=new ArrayList();
    private List listaComponentesLista=new ArrayList();
    private List eliminaComponentesSeleccionados=new ArrayList();
    private boolean swEliminaSi;
    private boolean swEliminaNo;
    private String principioActivo="";
    private List componentespresentaciones=new ArrayList();
    private PresentacionesProductoMaterialPromocional presentacionesProductoMaterialPromocional=new PresentacionesProductoMaterialPromocional();
    private List componentes1Lista=new ArrayList();
    private List componentes2Lista=new ArrayList();
    private String buscarDato="";
    private ResultDataModel productoList=new ResultDataModel();
    private int indice=0;
    private int indice0=0;
    private List componentes1AuxiliarLista=new ArrayList();
    private boolean banderaEdit=false;
    public ManagedBeanProductosCombinados() {
        cargarPresentacionesProducto();
    }
    
    
    public String getCargarComponentespresentaciones(){
        String codpresentacion=Util.getParameter("codpresentacion");
        
        try {
            String sql="select c.cod_compprod,c.cod_envaseprim,c.cod_colorpresprimaria,c.volumenpeso_envaseprim," +
                    " c.cantidad_compprod,c.cod_sabor from componentes_prod c,componentes_presprod cp";
            sql+="  where  c.cod_compprod=cp.cod_compprod and cp.cod_presentacion="+codpresentacion;
            System.out.println("sql:"+sql);
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(sql);
            componentespresentaciones.clear();
            while (rs.next()){
                componentesProd=new ComponentesProd();
                String cod="";
                componentesProd.setCodCompprod(rs.getString(1));
                cargarPrincipiosActivos(componentesProd.getCodCompprod());
                cod=rs.getString(2);
                System.out.println("sql:"+componentesProd.getCodCompprod());
                cod=(cod==null)?"":cod;
                cargarEnvasePrimario(cod);
                System.out.println("sql:"+componentesProd.getEnvasesPrimarios().getNombreEnvasePrim());
                cod=rs.getString(3);
                cod=(cod==null)?"":cod;
                System.out.println("st xxx:"+st);
                //cargarColor(cod);
                System.out.println("sql:"+componentesProd.getColoresPresentacion().getNombreColor());
                componentesProd.setVolumenPesoEnvasePrim(rs.getString(4));
                System.out.println("sql:"+componentesProd.getVolumenPesoEnvasePrim());                componentesProd.setCantidadCompprod(rs.getString(5));
                System.out.println("sql:"+componentesProd.getCantidadCompprod());
                cod=rs.getString(6);
                cod=(cod==null)?"":cod;
                cargarSabor(cod);
                principioActivo=componentesProd.getSaboresProductos().getNombreSabor()+principioActivo;
                componentesProd.getSaboresProductos().setNombreSabor(principioActivo);
                System.out.println("sql:"+componentesProd.getSaboresProductos().getNombreSabor());
                System.out.println("principios:"+componentesProd.getSaboresProductos().getNombreSabor());
                componentespresentaciones.add(componentesProd);
            }
            if(rs!=null){
                rs.close();
                
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return "";
    }
    public String getObtenerCodigo(){
        String cod=Util.getParameter("codigo");
        System.out.println("CodProd :"+cod);
        if(cod!=null){
            setCodigo(cod);
        }
        // cargarProdFormasFar();
        return "";
    }
    
    /**
     * -------------------------------------------------------------------------
     * CARGAR DATOS PRESENTACIONES PRODUCTO
     * -------------------------------------------------------------------------
     **/
    public String cargarNombrePresentacion(String cod){
        String nombre="";
        try{
            
            //String sql_aux="select p.nombre_prod, ";
            //String sql_aux="select p.cod_prod,p.nombre_prod, ";
            String sql_aux=" select (select sp.nombre_sabor from SABORES_PRODUCTO sp where sp.COD_SABOR =cp.COD_SABOR and cp.cod_sabor<>0) as nombreSabor,";
            sql_aux+=" cp.VOLUMENPESO_ENVASEPRIM,";
            sql_aux+=" (select es.NOMBRE_ENVASESEC from ENVASES_SECUNDARIOS es where es.COD_ENVASESEC = pp.COD_ENVASESEC) as nombreEnvaseSec,";
            sql_aux+=" pp.cantidad_presentacion,";
            sql_aux+=" (select ff.nombre_forma from FORMAS_FARMACEUTICAS ff where ff.cod_forma= cp.cod_forma) as nombreForma ";
            //sql_aux+=" from COMPONENTES_PROD cp, COMPONENTES_PRESPROD cpp, PRESENTACIONES_PRODUCTO pp, PRODUCTOS p";
            sql_aux+=" from COMPONENTES_PROD cp, COMPONENTES_PRESPROD cpp, PRESENTACIONES_PRODUCTO pp";
            sql_aux+=" where cp.COD_COMPPROD = cpp.COD_COMPPROD";
            sql_aux+=" and cpp.COD_PRESENTACION = pp.cod_presentacion";
            //sql_aux+=" and cp.COD_PROD = p.cod_prod ";
            sql_aux+=" and pp.cod_presentacion='"+cod+"'";
            
            
            System.out.println("PresentacionesProducto:sql:"+sql_aux);
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(sql_aux);
            while (rs.next()){
                
                //nombre=rs.getString(1)+" ";
                String aux=rs.getString(1);
                System.out.println("aux:"+aux);
                if(aux!=null){
                    nombre+=aux+" ";
                }
                nombre+=rs.getString(2)+" "+rs.getString(3)+" x "+rs.getString(4)+" "+rs.getString(5);
            }
            if(rs!=null){
                rs.close();
                st.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return nombre;
    }
    public void cargarPresentacionesProducto(){
        try {
            
            String sql=" select cod_presentacion,CANT_ENVASE_SECUNDARIO,nombre_producto_presentacion,cod_tipomercaderia,cod_carton,cod_lineamkt,obs_presentacion,cod_anterior,cod_estado_registro,cantidad_presentacion,cod_envaseterciario";
            sql+=" from PRESENTACIONES_PRODUCTO";
            sql+=" where COD_TIPO_PRESENTACION=2";
            if(!getPresentacionesProducto().getEstadoReferencial().getCodEstadoRegistro().equals("") && !getPresentacionesProducto().getEstadoReferencial().getCodEstadoRegistro().equals("3")){
                sql+=" and cod_estado_registro="+getPresentacionesProducto().getEstadoReferencial().getCodEstadoRegistro();
            }
            System.out.println("PresentacionesProducto:sql:"+sql);
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(sql);
            String cod="";
            presentacionesProductoList.clear();
            while (rs.next()){
                PresentacionesProducto bean=new PresentacionesProducto();
                String cod_presentacion=rs.getString("cod_presentacion");
                String peso_neto_presentacion=rs.getString("peso_neto_presentacion");
                String nombre_producto_presentacion=rs.getString("nombre_producto_presentacion");
                String cod_tipomercaderia=rs.getString("cod_tipomercaderia");
                String cod_carton=rs.getString("cod_carton");
                String cod_lineamkt=rs.getString("cod_lineamkt");
                String obs_presentacion=rs.getString("obs_presentacion");
                String cod_anterior=rs.getString("cod_anterior");
                String cod_estado_registro=rs.getString("cod_estado_registro");
                String cantidad_presentacion=rs.getString("cantidad_presentacion");
                String cod_envaseterciario=rs.getString("cod_envaseterciario");
                bean.setCodPresentacion(cod_presentacion);
                bean.setCantEnvaseSecundario(peso_neto_presentacion);
                bean.setNombreProductoPresentacion(nombre_producto_presentacion);
                String data1[]=obtenerDatosReferenciales(cod_tipomercaderia,"TIPO_MERCADERIA");
                bean.getTiposMercaderia().setCodTipoMercaderia(data1[0]);
                bean.getTiposMercaderia().setNombreTipoMercaderia(data1[1]);
                String data2[]=obtenerDatosReferenciales(cod_carton,"CARTONES");
                bean.getCartonesCorrugados().setCodCaton(data2[0]);
                bean.getCartonesCorrugados().setNombreCarton(data2[1]);
                String data3[]=obtenerDatosReferenciales(cod_lineamkt,"LINEAS_MKT");
                bean.getLineaMKT().setCodLineaMKT(data3[0]);
                bean.getLineaMKT().setNombreLineaMKT(data3[1]);
                bean.setObsPresentacion(obs_presentacion);
                String data4[]=obtenerDatosReferenciales(cod_estado_registro,"ESTADO_REFERENCIAL");
                bean.getEstadoReferencial().setCodEstadoRegistro(data4[0]);
                bean.getEstadoReferencial().setNombreEstadoRegistro(data4[1]);
                bean.setCantidadPresentacion(cantidad_presentacion);
                String data5[]=obtenerDatosReferenciales(cod_estado_registro,"ENVASE_TERCIARIO");
                bean.getEnvasesTerciarios().setCodEnvaseTerciario(data5[0]);
                bean.getEnvasesTerciarios().setNombreEnvaseTerciario(data5[1]);
                presentacionesProductoList.add(bean);
                //listaComponentes(bean.getCodPresentacion(),bean);
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
        getPresentacionesProducto().getEstadoReferencial().setCodEstadoRegistro(event.getNewValue().toString());
        cargarPresentacionesProducto();
    }
    /**
     * -------------------------------------------------------------------------
     * CARGAR ESTADO REGISTRO
     * -------------------------------------------------------------------------
     **/
    public void cargarEstadoRegistro(String codigo,PresentacionesProducto bean){
        try {
            setCon(Util.openConnection(getCon()));
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
    
    public void cargarCartonCorrugado(String codigo,PresentacionesProducto bean){
        try {
            setCon(Util.openConnection(getCon()));
            String sql="select cod_carton,nombre_carton from cartones_corrugados where cod_estado_registro=1";
            ResultSet rs=null;
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            if(!codigo.equals("")){
                sql+=" and cod_carton="+codigo;
                rs=st.executeQuery(sql);
                if(rs.next()){
                    bean.getCartonesCorrugados().setCodCaton(rs.getString(1));
                    bean.getCartonesCorrugados().setNombreCarton(rs.getString(2));
                }
            } else{
                getCartonesCorrugados().clear();
                rs=st.executeQuery(sql);
                while (rs.next())
                    getCartonesCorrugados().add(new SelectItem(rs.getString(1),rs.getString(2)));
            }
            if(rs!=null){
                rs.close();st.close();
                rs=null;st=null;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
    }
    public void cargarEnvaseSecundario(String codigo,PresentacionesProducto bean){
        try {
            setCon(Util.openConnection(getCon()));
            String sql="select cod_envasesec,nombre_envasesec from envases_secundarios where cod_estado_registro=1";
            ResultSet rs=null;
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            if(!codigo.equals("")){
                sql+=" and cod_envasesec="+codigo;
                rs=st.executeQuery(sql);
                if(rs.next()){
                    bean.getEnvasesSecundarios().setCodEnvaseSec(rs.getString(1));
                    bean.getEnvasesSecundarios().setNombreEnvaseSec(rs.getString(2));
                }
            } else{
                getEnvasesSecundarios().clear();
                rs=st.executeQuery(sql);
                while (rs.next())
                    getEnvasesSecundarios().add(new SelectItem(rs.getString(1),rs.getString(2)));
            }
            if(rs!=null){
                rs.close();st.close();
                rs=null;st=null;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
    }
    public void cargarEnvaseTerciario(String codigo,PresentacionesProducto bean){
        try {
            setCon(Util.openConnection(getCon()));
            String sql="select cod_envaseterciario,nombre_envaseterciario from envases_terciarios where cod_estado_registro=1";
            ResultSet rs=null;
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            if(!codigo.equals("")){
                sql+=" and cod_envaseterciario="+codigo;
                rs=st.executeQuery(sql);
                if(rs.next()){
                    bean.getEnvasesTerciarios().setCodEnvaseTerciario(rs.getString(1));
                    bean.getEnvasesTerciarios().setNombreEnvaseTerciario(rs.getString(2));
                }
            } else{
                getEnvasesTerciarios().clear();
                rs=st.executeQuery(sql);
                getEnvasesTerciarios().add(new SelectItem("0","            "));
                while (rs.next())
                    getEnvasesTerciarios().add(new SelectItem(rs.getString(1),rs.getString(2)));
            }
            if(rs!=null){
                rs.close();st.close();
                rs=null;st=null;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
    }
    public void cargarProducto(String codigo,PresentacionesProducto bean){
        try {
            setCon(Util.openConnection(getCon()));
            String sql="select cod_prod,nombre_prod from productos";
            ResultSet rs=null;
            
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            if(!codigo.equals("")){
                sql+=" where cod_prod="+codigo;
                rs=st.executeQuery(sql);
                if(rs.next()){
                    bean.getProducto().setCodProducto(rs.getString(1));
                    bean.getProducto().setNombreProducto(rs.getString(2));
                }
            } else{
                getProductos().clear();
                rs=st.executeQuery(sql);
                while (rs.next())
                    getProductos().add(new SelectItem(rs.getString(1),rs.getString(2)));
            }
            if(rs!=null){
                rs.close();st.close();
                rs=null;st=null;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public void cargarLineaMKT(String codigo,PresentacionesProducto bean){
        try {
            con=Util.openConnection(con);
            String sql="select cod_lineamkt,nombre_lineamkt from lineas_mkt where cod_estado_registro=1";
            ResultSet rs=null;
            
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            if(!codigo.equals("")){
                sql+=" and cod_lineamkt="+codigo;
                rs=st.executeQuery(sql);
                if(rs.next()){
                    bean.getLineaMKT().setCodLineaMKT(rs.getString(1));
                    bean.getLineaMKT().setNombreLineaMKT(rs.getString(2));
                }
            } else{
                getLineasMKTList().clear();
                rs=st.executeQuery(sql);
                while (rs.next())
                    getLineasMKTList().add(new SelectItem(rs.getString(1),rs.getString(2)));
            }
            if(rs!=null){
                rs.close();st.close();
                rs=null;st=null;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    public void cargarTipoMercaderia(String codigo,PresentacionesProducto bean){
        try {
            setCon(Util.openConnection(getCon()));
            String sql="select cod_tipomercaderia,nombre_tipomercaderia from tipos_mercaderia where cod_estado_registro=1";
            ResultSet rs=null;
            
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            if(!codigo.equals("")){
                sql+=" and cod_tipomercaderia="+codigo;
                rs=st.executeQuery(sql);
                if(rs.next()){
                    bean.getTiposMercaderia().setCodTipoMercaderia(rs.getString(1));
                    bean.getTiposMercaderia().setNombreTipoMercaderia(rs.getString(2));
                }
            } else{
                getTiposMercaderia().clear();
                rs=st.executeQuery(sql);
                while (rs.next())
                    getTiposMercaderia().add(new SelectItem(rs.getString(1),rs.getString(2)));
            }
            if(rs!=null){
                rs.close();st.close();
                rs=null;st=null;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    public String generarCodigo(){
        String codigo="";
        try {
            String  sql="select max(cod_presentacion)+1 from presentaciones_producto";
            setCon(Util.openConnection(getCon()));
            Statement st=getCon().createStatement();
            ResultSet rs=st.executeQuery(sql);
            if(rs.next()){
                codigo=rs.getString(1);
                if(codigo==null)
                    codigo="1";
            }
            if(rs!=null){
                rs.close();
                st.close();
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return codigo;
    }
    public String actionSavePresentacionesProducto(){
        setBanderaEdit(true);
        clear();
        componentesProd=new ComponentesProd();
        getListaComponentesSeleccionados().add(componentesProd);
        listaComponentesSeleccionados.clear();
        presentacionesProducto= new PresentacionesProducto();
        cargarProducto("",null);
        cargarTipoMercaderia("",null);
        cargarEnvaseSecundario("",null);
        cargarEnvaseTerciario("",null);
        cargarCartonCorrugado("",null);
        cargarEstadoRegistro("",null);
        cargarLineaMKT("",null);
        /*limpiar*/
        listaComponentesSeleccionados.clear();
        componentes2Lista.clear();
        return "actionRegistrarProductosCombinados";
    }
    public String actionCancelar(){
        cargarPresentacionesProducto();
        return "actionCancelarProductosCombinados";
    }
    /*
     *
     * ***************** SAVE ****************************
     *
     */
    public String savePresentacionesProducto(){
        try {
            String codigo="";
            if(banderaEdit==true){
                codigo=generarCodigo();
            }else{
                codigo=presentacionesProducto.getCodPresentacion();
            }
            
            /* GUARDAR CABEZERA */
            String sql="insert into presentaciones_producto(cod_presentacion,cod_prod,CANT_ENVASE_SECUNDARIO,";
            sql+=" cod_envasesec,cod_envaseterciario,cod_lineamkt,cantidad_presentacion,";
            sql+=" cod_tipomercaderia,cod_carton,obs_presentacion,cod_anterior,cod_estado_registro,nombre_producto_presentacion,cod_tipo_presentacion)values(";
            sql+=""+codigo+",0,";
            sql+="'"+getPresentacionesProducto().getCantEnvaseSecundario()+"',";
            sql+="'"+getPresentacionesProducto().getEnvasesSecundarios().getCodEnvaseSec()+"',";
            sql+="'"+getPresentacionesProducto().getEnvasesTerciarios().getCodEnvaseTerciario()+"',";
            sql+="'"+getPresentacionesProducto().getLineaMKT().getCodLineaMKT()+"',";
            sql+="'"+getPresentacionesProducto().getCantidadPresentacion()+"',";
            sql+="'"+getPresentacionesProducto().getTiposMercaderia().getCodTipoMercaderia()+"',";
            sql+="'"+getPresentacionesProducto().getCartonesCorrugados().getCodCaton()+"',";
            sql+="'"+getPresentacionesProducto().getObsPresentacion()+"'," ;
            sql+="'"+getPresentacionesProducto().getCodAnterior()+"',1,";
            sql+="'"+getPresentacionesProducto().getNombreProductoPresentacion()+"',2)";
            System.out.println("sqlLLLLLLLLLLLLL:"+sql);
            con=Util.openConnection(con);
            PreparedStatement st=con.prepareStatement(sql);
            int result=st.executeUpdate();
            st.close();
            clear();
            Iterator i=getListaComponentesSeleccionados().iterator();
            while (i.hasNext()){
                ComponentesProd bean=(ComponentesProd)i.next();
                String sql_1="insert into componentes_presprod(cod_compprod,cod_presentacion,cant_compprod)values(";
                sql_1+=""+bean.getCodCompprod()+",";
                sql_1+=""+codigo+",";
                sql_1+=""+bean.getCantidadComponente()+")";
                System.out.println("sql_Insert1111111111:"+sql_1);
                PreparedStatement st_1=con.prepareStatement(sql_1);
                result=st_1.executeUpdate();
            }
            Iterator j=componentes2Lista.iterator();
            while(j.hasNext()){
                MaterialPromocional bean1=(MaterialPromocional)j.next();
                String sql_2="insert into presentacionesproducto_matpromocional(cod_matpromocional,cod_presentacion,cant_matpromocional) values(";
                sql_2+=""+bean1.getCodMatPromocional()+",";
                sql_2+=""+codigo+",";
                sql_2+=""+bean1.getCantidadMatPromocional()+")";
                System.out.println("sql_Insert222222222:"+sql_2);
                PreparedStatement st_2=con.prepareStatement(sql_2);
                result=st_2.executeUpdate();
            }
            if(result>0){
                cargarPresentacionesProducto();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        setBanderaEdit(false);
        return "actionCancelarProductosCombinados";
    }
    public void clear(){
        PresentacionesProducto tm=new PresentacionesProducto();
        setPresentacionesProducto(tm);
    }
    /**
     * --------------------------------------------------------------------------
     *
     * ACTION EDITAR
     *
     *--------------------------------------------------------------------------
     **/
    public String actionEditPresentacionesProductoCombinados(){
        setBanderaEdit(false);
        clear();
        cargarProducto("",null);
        cargarTipoMercaderia("",null);
        cargarEnvaseSecundario("",null);
        cargarEnvaseTerciario("",null);
        cargarCartonCorrugado("",null);
        cargarEstadoRegistro("",null);
        cargarLineaMKT("",null);
        System.out.println("Entrooooooooooooooooo");
        Iterator i=presentacionesProductoList.iterator();
        while (i.hasNext()){
            PresentacionesProducto bean=(PresentacionesProducto)i.next();
            if(bean.getChecked().booleanValue()){
                System.out.println("bean:"+bean.getCantidadPresentacion());
                //cargarFormaEdit(bean.getProducto().getCodProducto());
                System.out.println("bean.getCodPresentacion()::::::::"+bean.getCodPresentacion());
                setPresentacionesProducto(bean);
                break;
            }
        }
//*carga los componenetes
        try {
            String sql="select c.cod_compprod,c.cod_envaseprim,c.cod_colorpresprimaria,c.volumenpeso_envaseprim," +
                    "c.cantidad_compprod,c.cod_sabor,cp.cant_compprod,c.cod_prod from componentes_prod c,componentes_presprod cp";
            sql+="  where c.cod_compprod=cp.cod_compprod and cp.cod_presentacion="+getPresentacionesProducto().getCodPresentacion();
            listaComponentesSeleccionados.clear();
            System.out.println("sql:"+sql);
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(sql);
            System.out.println("sql:"+sql);
            while (rs.next()){
                componentesProd=new ComponentesProd();
                String cod="";
                componentesProd.setCodCompprod(rs.getString(1));
                cargarPrincipiosActivos(componentesProd.getCodCompprod());
                cod=rs.getString(2);
                System.out.println("sql:"+componentesProd.getCodCompprod());
                cod=(cod==null)?"":cod;
                cargarEnvasePrimario(cod);
                System.out.println("sql:"+componentesProd.getEnvasesPrimarios().getNombreEnvasePrim());
                cod=rs.getString(3);
                cod=(cod==null)?"":cod;
                System.out.println("st xxx:"+st);
                cargarColor(cod);
                System.out.println("sql:"+componentesProd.getColoresPresentacion().getNombreColor());
                componentesProd.setVolumenPesoEnvasePrim(rs.getString(4));
                System.out.println("sql:"+componentesProd.getVolumenPesoEnvasePrim());
                componentesProd.setCantidadCompprod(rs.getString(5));
                System.out.println("sql:"+componentesProd.getCantidadCompprod());
                cod=rs.getString(6);
                cod=(cod==null)?"":cod;
                cargarSabor(cod);
                componentesProd.setCantidadComponente(rs.getInt(7));
                principioActivo=componentesProd.getSaboresProductos().getNombreSabor()+principioActivo;
                componentesProd.getSaboresProductos().setNombreSabor(principioActivo);
                System.out.println("sql:"+componentesProd.getSaboresProductos().getNombreSabor());
                String codProd=rs.getString(8);
                String data1[]=obtenerDatosReferenciales(codProd,"PRODUCTO");
                componentesProd.getProducto().setCodProducto(data1[0]);
                componentesProd.getProducto().setNombreProducto(data1[1]);
                getListaComponentesSeleccionados().add(componentesProd);
            }
            String sql_1=" select cod_matpromocional,cod_presentacion,cant_matpromocional from presentacionesproducto_matpromocional where cod_presentacion="+getPresentacionesProducto().getCodPresentacion();
            System.out.println("sql_1:"+sql_1);
            Statement st_1=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs_1=st_1.executeQuery(sql_1);
            componentes2Lista.clear();
            int count=1;
            while(rs_1.next()){
                MaterialPromocional bean1=new MaterialPromocional();
                bean1.setCodTemp(count);
                count++;
                String cod_matpromocional=rs_1.getString("cod_matpromocional");
                String cod_presentacion=rs_1.getString("cod_presentacion");
                int cant_matpromocional=rs_1.getInt("cant_matpromocional");
                String data1[]=obtenerDatosReferenciales(cod_matpromocional,"MATERIAL_PROMOCIONAL");
                bean1.setCodMatPromocional(data1[0]);
                bean1.setNombreMatPromocional(data1[1]);
                bean1.setCantidadMatPromocional(cant_matpromocional);
                componentes2Lista.add(bean1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
//****
        
        System.out.println("cantidad: "+getPresentacionesProducto().getCantidadPresentacion());
        return "actionEditarProductosCombinados";
    }
    public String updatePresentacionesProducto(){
        try {
            con=Util.openConnection(con);
            //elimina las anteriores componentes
            String sql="delete from componentes_presprod ";
            sql+="where cod_presentacion="+getPresentacionesProducto().getCodPresentacion();
            System.out.println("deletePersonal:sql:"+sql);
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            int result=st.executeUpdate(sql);
            /* ELIMINA LOS DATOS DE PRESENTACIONPRODUCTO_ MATERIAL PROMOCIONAL*/
            String sql_1=" delete from presentacionesproducto_matpromocional where cod_presentacion="+getPresentacionesProducto().getCodPresentacion();
            System.out.println("sql_1:"+sql_1);
            Statement st_1=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            result=result+st_1.executeUpdate(sql_1);
            String sql_2=" delete from presentaciones_producto where cod_presentacion="+getPresentacionesProducto().getCodPresentacion();
            System.out.println("sql_2:"+sql_2);
            Statement st_2=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            result=result+st_2.executeUpdate(sql_2);
            savePresentacionesProducto();
            cargarPresentacionesProducto();
            clear();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "actionCancelarProductosCombinados";
    }
    public String actionDeletePresentacionesProducto(){
        getPresentacionesProductoEli().clear();
        getPresentacionesProductoEli2().clear();
        setSwEliminaSi(false);
        setSwEliminaNo(false);
        Iterator i=presentacionesProductoList.iterator();
        System.out.println("sizeeeeeeeee:"+presentacionesProductoList.size());
        while (i.hasNext()){
            PresentacionesProducto bean=(PresentacionesProducto)i.next();
            if(bean.getChecked().booleanValue()){
                try {
                    String sql="select cod_presentacion from presentaciones_producto_datoscomerciales" +
                            " where cod_presentacion="+bean.getCodPresentacion();
                    System.out.println("sql_11111111111111_"+sql);
                    setCon(Util.openConnection(getCon()));
                    Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet rs=st.executeQuery(sql);
                    rs.last();
                    if(rs.getRow()==0){
                        getPresentacionesProductoEli().add(bean);
                        setSwEliminaSi(true);
                        System.out.println("entrooooooooo eliminar");
                    }else{
                        getPresentacionesProductoEli2().add(bean);
                        setSwEliminaNo(true);
                        System.out.println("entrooooooooo no eliminar");
                    }                    
                    sql="select cod_presentacion from salida_detalleingresoventas where cod_presentacion="+bean.getCodPresentacion();
                    System.out.println("sql_2222222:"+sql);
                    st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    rs=st.executeQuery(sql);
                    rs.last();
                    if(rs.getRow()==0){                        
                        setSwEliminaSi(true);
                        System.out.println("entrooooooooo eliminar");
                    }else{                        
                        setSwEliminaNo(true);
                        System.out.println("entrooooooooo no eliminar");
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
        return "actionEliminarProductosCombinados";
    }
    public String deletePresentacionesProducto(){
        try {
            
            Iterator i=getPresentacionesProductoEli().iterator();
            int result=0;
            while (i.hasNext()){
                PresentacionesProducto bean=(PresentacionesProducto)i.next();
                con=Util.openConnection(con);
                //  elimar componentes material promocional
                String sql="delete from presentacionesproducto_matpromocional where cod_presentacion="+bean.getCodPresentacion();
                System.out.println("delete from presentacionesproducto_matpromocional:"+sql);
                Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                st.executeUpdate(sql);
                //elimina las anteriores componentes
                sql="delete from componentes_presprod " +
                        "where cod_presentacion="+bean.getCodPresentacion();
                System.out.println("deletePersonal:sql:"+sql);
                st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                st.executeUpdate(sql);
                sql="delete from presentaciones_producto " +
                        "where cod_presentacion="+bean.getCodPresentacion();
                System.out.println("deletePersonal:sql:"+sql);
                st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                result=result+st.executeUpdate(sql);
            }
            getPresentacionesProductoEli().clear();
            if(result>0){
                cargarPresentacionesProducto();
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "navegadorpresentacionesproducto";
    }
    public String changeEventProducto(ValueChangeEvent event){
        System.out.println("limpia");
        getListaComponentesSeleccionados().clear();
        return "";
    }
    
    public String cargarComponentes(){
        System.out.println("1:");
        //getListaComponentesSeleccionados().clear();
        System.out.println("2:");
        Iterator i=getListaComponentesBuscar().iterator();
        while (i.hasNext()){
            System.out.println("3:");
            ComponentesProd bean=(ComponentesProd)i.next();
            if(bean.getChecked().booleanValue()){
                getListaComponentesSeleccionados().add(bean);
            }
        }
        listaComponentesBuscar.clear();
        return "";
        
    }
    public String eliminaComponentes(){
        System.out.println("1:");
        getEliminaComponentesSeleccionados().clear();
        System.out.println("2:");
        Iterator i=getListaComponentesSeleccionados().iterator();
        while (i.hasNext()){
            System.out.println("3:");
            ComponentesProd bean=(ComponentesProd)i.next();
            if(bean.getChecked().booleanValue()){
            }else{
                getEliminaComponentesSeleccionados().add(bean);
            }
        }
        getListaComponentesSeleccionados().clear();
        i=getEliminaComponentesSeleccionados().iterator();
        while (i.hasNext()){
            System.out.println("3:");
            ComponentesProd bean=(ComponentesProd)i.next();
            if(bean.getChecked().booleanValue()){
            }else{
                getListaComponentesSeleccionados().add(bean);
            }
        }
        return "";
    }
    /**
     * -------------------------------------------------------------------------
     * -------------------------------------------------------------------------
     * CARGAR DATOS REFERENCIALES
     * -------------------------------------------------------------------------
     * -------------------------------------------------------------------------
     **/
    public String[] obtenerDatosReferenciales(String codigo,String option){
        
        String values[]=new String[2];
        try {
            
            String sql="";
            if(option.equals("COLOR_PRIMARIO")){
                sql="select cod_envaseprim,nombre_envaseprim from envases_primarios where cod_envaseprim="+codigo;
            }else if(option.equals("ENVASE_PRIMARIO")){
                sql="select cod_colorpresprimaria,nombre_colorpresprimaria from colores_presprimaria where cod_colorpresprimaria="+codigo;
            }else if(option.equals("SABOR")){
                sql="select cod_sabor,nombre_sabor from sabores_producto where cod_sabor="+codigo;
            }else if(option.equals("TIPO_MERCADERIA")){
                sql="select cod_tipomercaderia,nombre_tipomercaderia from tipos_mercaderia where cod_tipomercaderia="+codigo;
            }else if(option.equals("CARTONES")){
                sql="select cod_carton,nombre_carton from cartones_corrugados where cod_carton="+codigo;
            }else if(option.equals("LINEAS_MKT")){
                sql="select cod_lineamkt,nombre_lineamkt from lineas_mkt where cod_lineamkt="+codigo;
            }else if(option.equals("ESTADO_REFERENCIAL")){
                sql="select cod_estado_registro,nombre_estado_registro from estados_referenciales where cod_estado_registro="+codigo;
            }else if(option.equals("MATERIAL_PROMOCIONAL")){
                sql="select cod_matpromocional,nombre_matpromocional from mat_promocional where cod_estado_registro=1 and cod_matpromocional="+codigo;
            }else if(option.equals("ENVASE_TERCIARIO")){
                sql="select cod_envaseterciario,nombre_envaseterciario from envases_terciarios where cod_estado_registro=1 and cod_envaseterciario="+codigo;
            }else if(option.equals("PRODUCTO")){
                sql="select cod_prod,nombre_prod from productos where cod_prod="+codigo;
            }
            
            System.out.println("sql:__________________________"+sql);
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
                    rs=null;st=null;
                }
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return values;
        
    }
    /*
     *
     *      LISTADO DE PRODUCTOS
     *--------------------------------------------------------------------------
     */
    public String buscarComponentes(){
        //listaComponentesBuscar.clear();
        ManagedAccesoSistema bean1=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
        componentes1Lista.clear();
        try {
            String sql="select cod_prod,nombre_prod from productos order by nombre_prod asc";
            System.out.println("sql:"+sql);
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(sql);
            while(rs.next()){
                componentes1Lista.add(new SelectItem(rs.getString(1),rs.getString(2)));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "";
    }
    /**
     * -------------------------------------------------------------------------
     * MAS(+) PRODUCTOS COMPONENTES
     * -------------------------------------------------------------------------
     **/
    
    public String masActionComponentesProducto(){
        System.out.println("mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm");
        int size=listaComponentesSeleccionados.size();
        int codigo=1;
        if(size>0){
            size--;
            ComponentesProd obj=(ComponentesProd)listaComponentesSeleccionados.get(size);
            //codigo=obj.getCodTemp0();
            codigo++;
        }
        setIndice(codigo);
        ComponentesProd bean=new ComponentesProd();
        //bean.setCodTemp(codigo);
        listaComponentesSeleccionados.add(bean);
        return "";
    }
    /**
     * -------------------------------------------------------------------------
     * MAS(+) ACTION MATERIAL PROMOCIONAL
     * -------------------------------------------------------------------------
     **/
    
    public String masActionMaterialPromocional(){
        System.out.println("mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm");
        int size=componentes2Lista.size();
        int codigo=1;
        if(size>0){
            size--;
            MaterialPromocional obj=(MaterialPromocional)componentes2Lista.get(size);
            codigo=obj.getCodTemp();
            codigo++;
        }
        setIndice(codigo);
        MaterialPromocional bean=new MaterialPromocional();
        bean.setCodTemp(codigo);
        componentes2Lista.add(bean);
        return "";
    }
    /**
     * -------------------------------------------------------------------------
     * MENOS(-) ACTION MATERIAL PROMOCIONAL
     * -------------------------------------------------------------------------
     **/
    public String menosActionMaterialPromocioal(){
        int size=componentes2Lista.size();
        size--;
        componentes2Lista.remove(size);
        return "";
    }
    /**
     * -------------------------------------------------------------------------
     * COGER ID (EVENTO)
     * -------------------------------------------------------------------------
     **/
    public void cogerId(ActionEvent event){
        HtmlAjaxCommandLink link=(HtmlAjaxCommandLink )event.getComponent();
        System.out.println("link.getData():"+link.getData());
        if(link.getData()!=null){
            setIndice(Integer.parseInt(link.getData().toString()));
            // clearWrapper();
        }
        
        System.out.println("indice:"+getIndice());
    }
    /**
     *
     *      CARGAR COMPONENTES SELECCIONADOs
     *--------------------------------------------------------------------------
     **/
    public void changeEventProductos(ValueChangeEvent event){
        if(event.getNewValue()!=null){
            String codigoProd=event.getNewValue().toString();
            System.out.println("codigoProd:"+codigoProd);
            //listaComponentesBuscar.clear();
            listaComponentesBuscar.clear();
            try {                
                String sql="select cod_compprod,cod_envaseprim,cod_colorpresprimaria,volumenpeso_envaseprim,";
                sql+=" cantidad_compprod,cod_sabor,cod_prod from componentes_prod ";
                sql+="  where  cod_prod="+codigoProd;
                /*Iterator i=getListaComponentesSeleccionados().iterator();
                while (i.hasNext()){
                    ComponentesProd bean=(ComponentesProd)i.next();
                    sql+="  and  cod_compprod<>"+bean.getCodCompprod();
                }*/
                System.out.println("sqlEEEEEEEEEEEEEEEEEEEEE:"+sql);
                con=Util.openConnection(con);
                Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet rs=st.executeQuery(sql);
                while (rs.next()){
                    componentesProd=new ComponentesProd();
                    String cod="";
                    componentesProd.setCodCompprod(rs.getString(1));
                    cargarPrincipiosActivos(componentesProd.getCodCompprod());
                    cod=rs.getString(2);
                    System.out.println("sql:"+componentesProd.getCodCompprod());
                    cod=(cod==null)?"":cod;
                    cargarEnvasePrimario(cod);
                    System.out.println("sql:"+componentesProd.getEnvasesPrimarios().getNombreEnvasePrim());
                    cod=rs.getString(3);
                    cod=(cod==null)?"":cod;
                    System.out.println("st xxx:"+st);
                    cargarColor(cod);
                    System.out.println("sql:"+componentesProd.getColoresPresentacion().getNombreColor());
                    componentesProd.setVolumenPesoEnvasePrim(rs.getString(4));
                    System.out.println("sql:"+componentesProd.getVolumenPesoEnvasePrim());
                    componentesProd.setCantidadCompprod(rs.getString(5));
                    System.out.println("sql:"+componentesProd.getCantidadCompprod());
                    cod=rs.getString(6);
                    cod=(cod==null)?"":cod;
                    cargarSabor(cod);
                    principioActivo=componentesProd.getSaboresProductos().getNombreSabor()+principioActivo;
                    componentesProd.getSaboresProductos().setNombreSabor(principioActivo);
                    System.out.println("sql:"+componentesProd.getSaboresProductos().getNombreSabor());
                    System.out.println("principios:"+componentesProd.getSaboresProductos().getNombreSabor());                    
                    String codProd=rs.getString(7);
                    String data1[]=obtenerDatosReferenciales(codProd,"PRODUCTO");
                    componentesProd.getProducto().setCodProducto(data1[0]);
                    componentesProd.getProducto().setNombreProducto(data1[1]);
                    listaComponentesBuscar.add(componentesProd);
                    //getPresentacionesProductoList().add(bean1);
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
            /*
             *
             *      CARGAR MATERIAL PROMOCIONAL
             *--------------------------------------------------------------------------
             */
    public void changeEventMaterialPromocional(ValueChangeEvent event){
        
        if(event.getNewValue()!=null){
            String codigoProd=event.getNewValue().toString();
            System.out.println("codigoProd:"+codigoProd);
            //listaComponentesBuscar.clear();
            listaComponentesSeleccionados.clear();
            try {
                String sql="select cod_compprod,cod_envaseprim,cod_colorpresprimaria,volumenpeso_envaseprim,";
                sql+=" cantidad_compprod,cod_sabor from componentes_prod ";
                sql+="  where  cod_prod="+codigoProd;
                /*Iterator i=getListaComponentesSeleccionados().iterator();
                while (i.hasNext()){
                    ComponentesProd bean=(ComponentesProd)i.next();
                    sql+="  and  cod_compprod<>"+bean.getCodCompprod();
                }*/
                System.out.println("sqlEEEEEEEEEEEEEEEEEEEEE:"+sql);
                con=Util.openConnection(con);
                Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet rs=st.executeQuery(sql);
                while (rs.next()){
                    componentesProd=new ComponentesProd();
                    String cod="";
                    componentesProd.setCodCompprod(rs.getString(1));
                    cargarPrincipiosActivos(componentesProd.getCodCompprod());
                    cod=rs.getString(2);
                    System.out.println("sql:"+componentesProd.getCodCompprod());
                    cod=(cod==null)?"":cod;
                    cargarEnvasePrimario(cod);
                    System.out.println("sql:"+componentesProd.getEnvasesPrimarios().getNombreEnvasePrim());
                    cod=rs.getString(3);
                    cod=(cod==null)?"":cod;
                    System.out.println("st xxx:"+st);
                    cargarColor(cod);
                    System.out.println("sql:"+componentesProd.getColoresPresentacion().getNombreColor());
                    componentesProd.setVolumenPesoEnvasePrim(rs.getString(4));
                    System.out.println("sql:"+componentesProd.getVolumenPesoEnvasePrim());
                    componentesProd.setCantidadCompprod(rs.getString(5));
                    System.out.println("sql:"+componentesProd.getCantidadCompprod());
                    cod=rs.getString(6);
                    cod=(cod==null)?"":cod;
                    cargarSabor(cod);
                    principioActivo=componentesProd.getSaboresProductos().getNombreSabor()+principioActivo;
                    componentesProd.getSaboresProductos().setNombreSabor(principioActivo);
                    System.out.println("sql:"+componentesProd.getSaboresProductos().getNombreSabor());
                    System.out.println("principios:"+componentesProd.getSaboresProductos().getNombreSabor());
                    getListaComponentesBuscar().add(componentesProd);
                    listaComponentesSeleccionados.add(componentesProd);
                    //getPresentacionesProductoList().add(bean1);
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    public String listaComponentes(String codigo,PresentacionesProducto bean1){
        try {
            String sql="select c.cod_compprod,c.cod_envaseprim,c.cod_colorpresprimaria,c.volumenpeso_envaseprim," +
                    " c.cantidad_compprod,c.cod_sabor from componentes_prod c,componentes_presprod cp";
            sql+="  where  c.cod_compprod=cp.cod_compprod and cp.cod_presentacion="+codigo;
            
            System.out.println("sql:"+sql);
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(sql);
            System.out.println("sql:"+sql);
            while (rs.next()){
                componentesProd=new ComponentesProd();
                String cod="";
                componentesProd.setCodCompprod(rs.getString(1));
                cargarPrincipiosActivos(componentesProd.getCodCompprod());
                cod=rs.getString(2);
                System.out.println("sql:"+componentesProd.getCodCompprod());
                cod=(cod==null)?"":cod;
                cargarEnvasePrimario(cod);
                System.out.println("sql:"+componentesProd.getEnvasesPrimarios().getNombreEnvasePrim());
                cod=rs.getString(3);
                cod=(cod==null)?"":cod;
                System.out.println("st xxx:"+st);
                //cargarColor(cod);
                System.out.println("sql:"+componentesProd.getColoresPresentacion().getNombreColor());
                componentesProd.setVolumenPesoEnvasePrim(rs.getString(4));
                System.out.println("sql:"+componentesProd.getVolumenPesoEnvasePrim());
                componentesProd.setCantidadCompprod(rs.getString(5));
                System.out.println("sql:"+componentesProd.getCantidadCompprod());
                cod=rs.getString(6);
                cod=(cod==null)?"":cod;
                cargarSabor(cod);
                principioActivo=componentesProd.getSaboresProductos().getNombreSabor()+principioActivo;
                componentesProd.getSaboresProductos().setNombreSabor(principioActivo);
                System.out.println("sql:"+componentesProd.getSaboresProductos().getNombreSabor());
                System.out.println("principios:"+componentesProd.getSaboresProductos().getNombreSabor());
                bean1.getComponentesList().add(componentesProd);
            }
            if(rs!=null){
                rs.close();
                
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        
        return "";
    }
    
    public void cargarEnvasePrimario(String codigo){
        try {
            con=Util.openConnection(con);
            String sql="select nombre_envaseprim from envases_primarios where cod_envaseprim="+codigo;
            ResultSet rs=null;
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            rs=st.executeQuery(sql);
            if(rs.next()){
                componentesProd.getEnvasesPrimarios().setNombreEnvasePrim(rs.getString(1));
            }
            if(rs!=null){
                rs.close();st.close();
                rs=null;st=null;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public void cargarPrincipiosActivos(String codigo){
        try {
            
            con=Util.openConnection(con);
            String sql="select pa.nombre_principio_activo,cd.concentracion from principios_activos pa,componentes_proddetalle cd where pa.cod_principio_activo=cd.cod_principio_activo and cd.cod_compprod="+codigo;
            System.out.println("cargar  princi"+sql);
            ResultSet rs=null;
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            rs=st.executeQuery(sql);
            principioActivo="(";
            while(rs.next()){
                principioActivo+=rs.getString(1)+" "+rs.getString(2)+",";
            }
            principioActivo+=")";
            if(rs!=null){
                rs.close();st.close();
                rs=null;st=null;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public void cargarColor(String codigo){
        try {
            setCon(Util.openConnection(getCon()));
            String sql="select nombre_colorpresprimaria from colores_presprimaria where cod_colorpresprimaria="+codigo;
            ResultSet rs=null;
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            rs=st.executeQuery(sql);
            if(rs.next()){
                componentesProd.getColoresPresentacion().setNombreColor(rs.getString(1));
            }
            if(rs!=null){
                rs.close();st.close();
                rs=null;st=null;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public void cargarSabor(String codigo){
        try {
            con=Util.openConnection(con);
            String sql="select nombre_sabor from sabores_producto where cod_sabor="+codigo;
            ResultSet rs=null;
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            rs=st.executeQuery(sql);
            if(rs.next()){
                componentesProd.getSaboresProductos().setNombreSabor(rs.getString(1));
            }
            if(rs!=null){
                rs.close();st.close();
                rs=null;st=null;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public String getCloseConnection() throws SQLException{
        if(getCon()!=null){
            getCon().close();
        }
        return "";
    }
    
    public List getPresentacionesProductoList() {
        cargarPresentacionesProducto();
        return presentacionesProductoList;
    }
    
    public void setPresentacionesProductoList(List presentacionesProductoList) {
        this.presentacionesProductoList = presentacionesProductoList;
    }
    
    public List getPresentacionesProductoEli() {
        return presentacionesProductoEli;
    }
    
    public void setPresentacionesProductoEli(List presentacionesProductoEli) {
        this.presentacionesProductoEli = presentacionesProductoEli;
    }
    
    public List getPresentacionesProductoEli2() {
        return presentacionesProductoEli2;
    }
    
    public void setPresentacionesProductoEli2(List presentacionesProductoEli2) {
        this.presentacionesProductoEli2 = presentacionesProductoEli2;
    }
    
    public PresentacionesProducto getPresentacionesProducto() {
        return presentacionesProducto;
    }
    
    public void setPresentacionesProducto(PresentacionesProducto presentacionesProducto) {
        this.presentacionesProducto = presentacionesProducto;
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
    
    public List getProductos() {
        return productos;
    }
    
    public void setProductos(List productos) {
        this.productos = productos;
    }
    
    public List getTiposMercaderia() {
        return tiposMercaderia;
    }
    
    public void setTiposMercaderia(List tiposMercaderia) {
        this.tiposMercaderia = tiposMercaderia;
    }
    
    public List getEnvasesSecundarios() {
        return envasesSecundarios;
    }
    
    public void setEnvasesSecundarios(List envasesSecundarios) {
        this.envasesSecundarios = envasesSecundarios;
    }
    
    public List getLineasMKTList() {
        return lineasMKTList;
    }
    
    public void setLineasMKTList(List lineasMKTList) {
        this.lineasMKTList = lineasMKTList;
    }
    
    public List getFormasFarList() {
        return formasFarList;
    }
    
    public void setFormasFarList(List formasFarList) {
        this.formasFarList = formasFarList;
    }
    
    public List getEnvasesTerciarios() {
        return envasesTerciarios;
    }
    
    public void setEnvasesTerciarios(List envasesTerciarios) {
        this.envasesTerciarios = envasesTerciarios;
    }
    
    public List getCartonesCorrugados() {
        return cartonesCorrugados;
    }
    
    public void setCartonesCorrugados(List cartonesCorrugados) {
        this.cartonesCorrugados = cartonesCorrugados;
    }
    
    public String getCodigo() {
        return codigo;
    }
    
    public void setCodigo(String codigo) {
        this.codigo = codigo;
    }
    
    public ResultDataModel getComponentesList() {
        return componentesList;
    }
    
    public void setComponentesList(ResultDataModel componentesList) {
        this.componentesList = componentesList;
    }
    
    public List getListaComponentesBuscar() {
        return listaComponentesBuscar;
    }
    
    public void setListaComponentesBuscar(List listaComponentesBuscar) {
        this.listaComponentesBuscar = listaComponentesBuscar;
    }
    
    public List getListaComponentesSeleccionados() {
        return listaComponentesSeleccionados;
    }
    
    public void setListaComponentesSeleccionados(List listaComponentesSeleccionados) {
        this.listaComponentesSeleccionados = listaComponentesSeleccionados;
    }
    
    public List getEliminaComponentesSeleccionados() {
        return eliminaComponentesSeleccionados;
    }
    
    public void setEliminaComponentesSeleccionados(List eliminaComponentesSeleccionados) {
        this.eliminaComponentesSeleccionados = eliminaComponentesSeleccionados;
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
    
    public String getPrincipioActivo() {
        return principioActivo;
    }
    
    public void setPrincipioActivo(String principioActivo) {
        this.principioActivo = principioActivo;
    }
    
    public List getListaComponentesLista() {
        return listaComponentesLista;
    }
    
    public void setListaComponentesLista(List listaComponentesLista) {
        this.listaComponentesLista = listaComponentesLista;
    }
    
    public List getComponentespresentaciones() {
        return componentespresentaciones;
    }
    
    public void setComponentespresentaciones(List componentespresentaciones) {
        this.componentespresentaciones = componentespresentaciones;
    }
    public String generaNombrePresentacion(){
        try {
            con=Util.openConnection(con);
            String sql="select nombre_prod from productos where cod_prod="+getPresentacionesProducto().getProducto().getCodProducto();
            System.out.println("sqlGenerarNombre:"+sql);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(sql);
            String nombrePresentacion="";
            if(rs.next()){
                nombrePresentacion=rs.getString(1);
            }
            nombrePresentacion=nombrePresentacion+" "+getPresentacionesProducto().getCantidadPresentacion();
            /******************ENVASE SECUNDARIO**************/
            String sql1="select nombre_envasesec from envases_secundarios where cod_envasesec="+getPresentacionesProducto().getEnvasesSecundarios().getCodEnvaseSec();
            System.out.println("sq11:"+sql1);
            Statement st1=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs1=st1.executeQuery(sql1);
            if(rs1.next()){
                nombrePresentacion=nombrePresentacion+" "+rs1.getString(1);
            }
            /********************ENVASE SECUNDARIO************/
            String sql2="select nombre_envaseterciario from envases_terciarios where cod_envaseterciario="+getPresentacionesProducto().getEnvasesSecundarios().getCodEnvaseSec();
            System.out.println("sq12:"+sql2);
            Statement st2=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs2=st2.executeQuery(sql2);
            if(rs2.next()){
                nombrePresentacion=nombrePresentacion+" "+rs2.getString(1);
            }
            nombrePresentacion=nombrePresentacion+" x "+getPresentacionesProducto().getCantEnvaseSecundario();
            getPresentacionesProducto().setNombreProductoPresentacion(nombrePresentacion);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "";
    }
    
    public PresentacionesProductoMaterialPromocional getPresentacionesProductoMaterialPromocional() {
        return presentacionesProductoMaterialPromocional;
    }
    
    public void setPresentacionesProductoMaterialPromocional(PresentacionesProductoMaterialPromocional presentacionesProductoMaterialPromocional) {
        this.presentacionesProductoMaterialPromocional = presentacionesProductoMaterialPromocional;
    }
    
    public List getComponentes1Lista() {
        return componentes1Lista;
    }
    
    public void setComponentes1Lista(List componentes1Lista) {
        this.componentes1Lista = componentes1Lista;
    }
    
    public List getComponentes2Lista() {
        return componentes2Lista;
    }
    
    public void setComponentes2Lista(List componentes2Lista) {
        this.componentes2Lista = componentes2Lista;
    }
    
    public String getBuscarDato() {
        return buscarDato;
    }
    
    public void setBuscarDato(String buscarDato) {
        this.buscarDato = buscarDato;
    }
    /**
     * -------------------------------------------------------------------------
     * BUSCAR PRODUCTO
     * -------------------------------------------------------------------------
     **/
    public void buscarDatos(ActionEvent e){
        String varBuscar=getBuscarDato();
        System.out.println("nombreProducto:"+varBuscar);
        if(varBuscar.compareTo("")!=0){
            try {
                String sql="select cod_matpromocional, nombre_matpromocional";
                sql+=" from mat_promocional";
                sql+=" where cod_estado_registro = 1 and";
                sql+=" nombre_matpromocional like '%"+varBuscar+"%'";
                System.out.println("sql:"+sql);
                con=Util.openConnection(con);
                Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet rs=st.executeQuery(sql);
                productoList.setWrappedData(ResultSupport.toResult(rs));
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
    }
    
    public ResultDataModel getProductoList() {
        return productoList;
    }
    
    public void setProductoList(ResultDataModel productoList) {
        this.productoList = productoList;
    }
    /**
     * -------------------------------------------------------------------------
     * COGER CODIGO (EVENTO)
     * -------------------------------------------------------------------------
     **/
    
    public void cogerCodigo(ActionEvent event){
        Map map=(Map)productoList.getRowData();
        String cod_matpromocional=map.get("cod_matpromocional").toString();
        String nombre_matpromocional=map.get("nombre_matpromocional").toString();
        /*String CONCENTRACION_FORMA="";
        if(map.get("CONCENTRACION_FORMA")!=null){
            CONCENTRACION_FORMA=map.get("CONCENTRACION_FORMA").toString();
        }*/
        Iterator i=componentes2Lista.iterator();
        int j=1;
        List array=new ArrayList();
        while (i.hasNext()){
            MaterialPromocional bean=(MaterialPromocional)i.next();
            if(j==getIndice()){
                bean.setCodMatPromocional(cod_matpromocional);
                bean.setNombreMatPromocional(nombre_matpromocional);
            }
            j++;
            array.add(bean);
        }
        componentes2Lista.clear();
        componentes2Lista=array;
    }
    
    public int getIndice() {
        return indice;
    }
    
    public void setIndice(int indice) {
        this.indice = indice;
    }
    
    public int getIndice0() {
        return indice0;
    }
    
    public void setIndice0(int indice0) {
        this.indice0 = indice0;
    }
    
    public List getComponentes1AuxiliarLista() {
        return componentes1AuxiliarLista;
    }
    
    public void setComponentes1AuxiliarLista(List componentes1AuxiliarLista) {
        this.componentes1AuxiliarLista = componentes1AuxiliarLista;
    }
    
    public boolean isBanderaEdit() {
        return banderaEdit;
    }
    
    public void setBanderaEdit(boolean banderaEdit) {
        this.banderaEdit = banderaEdit;
    }
}
