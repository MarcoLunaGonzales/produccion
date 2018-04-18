/*
 * ManagedPresentacionesProducto.java
 *
 * Created on 18 de marzo de 2008, 17:30
 */

package com.cofar.web;

import com.cofar.bean.Clientes;
import com.cofar.bean.LineaMKT;
import com.cofar.bean.PresentacionesProducto;
import com.cofar.bean.PresentacionesProductoDatosComerciales;

import com.cofar.util.Util;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import javax.faces.event.ActionEvent;
import javax.faces.event.ValueChangeEvent;
import javax.faces.model.ListDataModel;

/**
 *
 * @author Osmar Hinojosa Miranda
 * @company COFAR
 */
public class ManagedPresentacionesProductoDatosComerciales extends ManagedBean{
    
    private List presentacionesProductoList=new ArrayList();
    private PresentacionesProducto presentacionesProducto=new PresentacionesProducto();
    private Connection con;
    private String codigo="";
    private String codigoAreaEmpresa="";
    private String codigoLinea="";
    private List AgenciasVentaList=new ArrayList();
    private List PresentacionesProductoDetalleList=new ArrayList();
    
    private List presentacionesProductoDatosComerciales=new ArrayList();
    private List productosPresentacion=new ArrayList();
    private ListDataModel datamodel=new ListDataModel();
    private String nombreproducto="";
    private String mensaje="";
    private List areasAgencias=new ArrayList();
    private List lineaMKT=new ArrayList();
    private int stockMinimo;
    private int stockSeguridad;
    private int stockMaximo;
    private String codigopresentacion="0";
    private float precioPorcentaje;
    private String codprecio="0";
    private String codAreaEmpresaS="0";
    
    
    /**********************************************************/
    public ManagedPresentacionesProductoDatosComerciales() {
        cargarAgencias();
    }
    public String getObtenerCodigo(){
        String cod=Util.getParameter("codigo");
        System.out.println("CodProd :"+cod);
        if(cod!=null){
            setCodigo(cod);
        }
        cargarPresentacionesProductoDetalle();
        return "";
    }
    
    
    public String getCogerCodigo(){
        String codigoAreaEmpresa=Util.getParameter("codigoAreaEmpresa");
        if(codigoAreaEmpresa!=null){
            setCodigoAreaEmpresa(codigoAreaEmpresa);
        }
        try {
            cargarLineaMKT();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "";
    }
    public String getCogerCodigoStock(){
        String codigoAreaEmpresa=Util.getParameter("codigoAreaEmpresa");
        if(codigoAreaEmpresa!=null){
            setCodigoAreaEmpresa(codigoAreaEmpresa);
        }
        try {
            cargarStock();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "";
    }
    
    public void cargarStock()throws SQLException{
        String sql="";
        sql="select pp.cod_presentacion,pp.nombre_producto_presentacion,dm.stock_minimo,dm.stock_seguridad,dm.stock_maximo ";
        sql+=" from PRESENTACIONES_PRODUCTO pp,PRESENTACIONES_PRODUCTO_DATOSCOMERCIALES dm";
        sql+=" where pp.cod_presentacion=dm.cod_presentacion and dm.COD_AREA_EMPRESA="+getCodigoAreaEmpresa();
        sql+=" and cod_tipomercaderia=1 ";
        sql+=" order by   pp.nombre_producto_presentacion      ";
        
        
        System.out.println("sql:"+sql);
        con=Util.openConnection(con);
        Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
        ResultSet rs=st.executeQuery(sql);
        List array=new ArrayList();
        while (rs.next()){
            String data[]=new String [5];
            data[0]=rs.getString(1);
            data[1]=rs.getString(2);
            data[2]=rs.getString(3);
            data[3]=rs.getString(4);
            data[4]=rs.getString(5);
            array.add(data);
        }
        datamodel.setWrappedData(array);
        
    }
    
    public void cargarProductos()throws SQLException{
        String sql="";
        sql="select pp.cod_presentacion,pp.nombre_producto_presentacion,round(dm.precio_lista,3),round(dm.precio_minimo,3),round(dm.precio_ventacorriente,3),round(dm.precio_especial,3) ";
        sql+=",round(dm.precio_institucional,3),round(dm.precio_institucional2,3)";
        sql+=" from PRESENTACIONES_PRODUCTO pp,PRESENTACIONES_PRODUCTO_DATOSCOMERCIALES dm";
        sql+=" where pp.cod_presentacion=dm.cod_presentacion and dm.COD_AREA_EMPRESA="+getCodigoAreaEmpresa();
        if(!getCodigoLinea().equals("0")){
            sql+=" and pp.cod_lineamkt="+getCodigoLinea();
        }
        //sql+=" and cod_tipomercaderia=1 and dm.cod_estado_registro=1";
        sql+=" and dm.cod_estado_registro=1 and cod_tipomercaderia=1";
        sql+=" order by pp.nombre_producto_presentacion ";
        System.out.println("sql1111111111111111:"+sql);
        con=Util.openConnection(con);
        Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
        ResultSet rs=st.executeQuery(sql);
        List array=new ArrayList();
        while (rs.next()){
            String data[]=new String [8];
            data[0]=rs.getString(1);
            data[1]=rs.getString(2);
            data[2]=rs.getString(3);
            float data1=rs.getFloat(4);;
            NumberFormat n=NumberFormat.getInstance();
            n.setMaximumFractionDigits(2);
            n.setMinimumFractionDigits(2);
            String monto=n.format(data1);
            monto=monto.replace(".","");
            monto=monto.replace(',','.');
            data[3]=monto;
            data[4]=rs.getString(5);
            data[5]=rs.getString(6);
            data[6]=rs.getString(7);
            data[7]=rs.getString(8);
            array.add(data);
        }
        datamodel.setWrappedData(array);
        
    }
    public void onclickEvent(ActionEvent e){
        String[] data=(String[])datamodel.getRowData();
        setNombreproducto(data[1]+" "+data[5]+" "+data[3]+" "+data[6]+"x"+data[7]+" "+data[9]);
        System.out.println("nombrexxxxxxxxxxxxxx:"+getNombreproducto());
    }
    
    public String Cancelar(){
        // cargarPresentacionesProducto();
        return"navegadorPresentacionesProductoComerciales";
    }
    public String CancelarInstitucional(){
        // cargarPresentacionesProducto();
        return"navegadorPresentacionesProductoComercialesInstitucional";
    }
    public String Cancelar1(){
        //cargarPresentacionesProducto();
        return"cancelarPresentacionesProductoComerciales";
    }
    public String Cancelar1Institucional(){
        //cargarPresentacionesProducto();
        return"cancelarPresentacionesProductoComercialesInstitucional";
    }
    //*********************************************
    /*public void cargarNombrePresentacionesProducto(){
        nombrePresentacionProductoList.clear();
        try {
            String sql="select cod_presentacion,cod_prod,PESO_NETO_PRESENTACION,COD_ENVASESEC,COD_ENVASETERCIARIO,";
            sql+=" COD_LINEAMKT,cantidad_presentacion,cod_tipomercaderia,COD_CARTON,OBS_PRESENTACION,";
            sql+=" cod_estado_registro from PRESENTACIONES_PRODUCTO where cod_estado_registro=1 and " +
             " cod_presentacion='"+codigo+"'";
            System.out.println("PresentacionesProducto:sql:"+sql);
            setCon(Util.openConnection(getCon()));
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(sql);
            String cod="";
            getPresentacionesProductoList().clear();
            while (rs.next()){
                PresentacionesProductoDatosComerciales bean=new PresentacionesProductoDatosComerciales();
                bean.getPresentacionesProducto().setCodPresentacion(rs.getString(1));
                cod=rs.getString(2);
                cod=(cod==null)?"":cod;
                System.out.println("st xxx:"+st);
                cargarProducto(cod,bean);
                bean.getPresentacionesProducto().setPesoNetoPresentacion(rs.getString(3));
                cod=rs.getString(4);
                cod=(cod==null)?"":cod;
                System.out.println("st xxx:"+st);
                cargarEnvaseSecundario(cod,bean);
                cod=rs.getString(5);
                cod=(cod==null)?"":cod;
                System.out.println("st xxx:"+st);
                cargarEnvaseTerciario(cod,bean);
                cod=rs.getString(6);
                cod=(cod==null)?"":cod;
                cargarLineaMKT(cod,bean);
                bean.getPresentacionesProducto().setCantidadPresentacion(rs.getString(7));
                cod=rs.getString(8);
                cod=(cod==null)?"":cod;
                System.out.println("st xxx:"+st);
                cargarTipoMercaderia(cod,bean);
                cod=rs.getString(9);
                cod=(cod==null)?"":cod;
                System.out.println("st xxx:"+st);
                cargarCartonCorrugado(cod,bean);
                bean.getPresentacionesProducto().setObsPresentacion(rs.getString(10));
                cod=rs.getString(11);
                cod=(cod==null)?"":cod;
                System.out.println("st xxx:"+st);
                cargarEstadoRegistro(cod,bean);
                //carga el detalle de comonenetes
                listaComponentes(bean.getPresentacionesProducto().getCodPresentacion(),bean);
                nombrePresentacionProductoList.add(bean);
                //getPresentacionesProductoList().add(bean1);
            }
            if(rs!=null){
                rs.close();st.close();
                rs=null;st=null;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }*/
    //*************************************************
    /**
     * -------------------------------------------------------------------------
     * ESTADO REGISTRO
     * -------------------------------------------------------------------------
     **/
    public void changeEvent(ValueChangeEvent event){
        System.out.println("event:"+event.getNewValue());
        getPresentacionesProducto().getEstadoReferencial().setCodEstadoRegistro(event.getNewValue().toString());
        //cargarPresentacionesProducto();
    }
    /**
     * -------------------------------------------------------------------------
     * CARGAR ESTADO REGISTRO
     * -------------------------------------------------------------------------
     **/
   /* public void cargarEstadoRegistro(String codigo,PresentacionesProductoDatosComerciales bean){
        try {
            setCon(Util.openConnection(getCon()));
            String sql="select cod_estado_registro,nombre_estado_registro from estados_referenciales where cod_estado_registro<>3";
            ResultSet rs=null;
    
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            if(!codigo.equals("")){
                sql+=" and cod_estado_registro="+codigo;
                rs=st.executeQuery(sql);
                if(rs.next()){
                    bean.getPresentacionesProducto().getEstadoReferencial().setCodEstadoRegistro(rs.getString(1));
                    bean.getPresentacionesProducto().getEstadoReferencial().setNombreEstadoRegistro(rs.getString(2));
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
    }*/
    
    /*public void cargarCartonCorrugado(String codigo,PresentacionesProductoDatosComerciales bean){
        try {
            setCon(Util.openConnection(getCon()));
            String sql="select cod_carton,nombre_carton from cartones_corrugados where cod_estado_registro=1";
            ResultSet rs=null;
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            if(!codigo.equals("")){
                sql+=" and cod_carton="+codigo;
                rs=st.executeQuery(sql);
                if(rs.next()){
                    bean.getPresentacionesProducto().getCartonesCorrugados().setCodCaton(rs.getString(1));
                    bean.getPresentacionesProducto().getCartonesCorrugados().setNombreCarton(rs.getString(2));
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
     
    }*/
    /*public void cargarEnvaseSecundario(String codigo,PresentacionesProductoDatosComerciales bean){
        try {
            setCon(Util.openConnection(getCon()));
            String sql="select cod_envasesec,nombre_envasesec from envases_secundarios where cod_estado_registro=1";
            ResultSet rs=null;
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            if(!codigo.equals("")){
                sql+=" and cod_envasesec="+codigo;
                rs=st.executeQuery(sql);
                if(rs.next()){
                    bean.getPresentacionesProducto().getEnvasesSecundarios().setCodEnvaseSec(rs.getString(1));
                    bean.getPresentacionesProducto().getEnvasesSecundarios().setNombreEnvaseSec(rs.getString(2));
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
     
    }*/
    /*public void cargarEnvaseTerciario(String codigo,PresentacionesProductoDatosComerciales bean){
        try {
            setCon(Util.openConnection(getCon()));
            String sql="select cod_envaseterciario,nombre_envaseterciario from envases_terciarios where cod_estado_registro=1";
            ResultSet rs=null;
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            if(!codigo.equals("")){
                sql+=" and cod_envaseterciario="+codigo;
                rs=st.executeQuery(sql);
                if(rs.next()){
                    bean.getPresentacionesProducto().getEnvasesTerciarios().setCodEnvaseTerciario(rs.getString(1));
                    bean.getPresentacionesProducto().getEnvasesTerciarios().setNombreEnvaseTerciario(rs.getString(2));
                }
            } else{
                getEnvasesTerciarios().clear();
                rs=st.executeQuery(sql);
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
     
    }*/
   /* public void cargarProducto(String codigo,PresentacionesProductoDatosComerciales bean){
        try {
            setCon(Util.openConnection(getCon()));
            String sql="select cod_prod,nombre_prod from productos";
            ResultSet rs=null;
    
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            if(!codigo.equals("")){
                sql+=" where cod_prod="+codigo;
                rs=st.executeQuery(sql);
                if(rs.next()){
                    bean.getPresentacionesProducto().getProducto().setCodProducto(rs.getString(1));
                    bean.getPresentacionesProducto().getProducto().setNombreProducto(rs.getString(2));
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
    }*/
   /* public void cargarLineaMKT(String codigo,PresentacionesProductoDatosComerciales bean){
        try {
            setCon(Util.openConnection(getCon()));
            String sql="select cod_lineamkt,nombre_lineamkt from lineas_mkt where cod_estado_registro=1";
            ResultSet rs=null;
    
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            if(!codigo.equals("")){
                sql+=" and cod_lineamkt="+codigo;
                rs=st.executeQuery(sql);
                if(rs.next()){
                    bean.getPresentacionesProducto().getLineaMKT().setCodLineaMKT(rs.getString(1));
                    bean.getPresentacionesProducto().getLineaMKT().setNombreLineaMKT(rs.getString(2));
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
    }*/
    
   /* public void cargarTipoMercaderia(String codigo,PresentacionesProductoDatosComerciales bean){
        try {
            setCon(Util.openConnection(getCon()));
            String sql="select cod_tipomercaderia,nombre_tipomercaderia from tipos_mercaderia where cod_estado_registro=1";
            ResultSet rs=null;
    
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            if(!codigo.equals("")){
                sql+=" and cod_tipomercaderia="+codigo;
                rs=st.executeQuery(sql);
                if(rs.next()){
                    bean.getPresentacionesProducto().getTiposMercaderia().setCodTipoMercaderia(rs.getString(1));
                    bean.getPresentacionesProducto().getTiposMercaderia().setNombreTipoMercaderia(rs.getString(2));
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
    }*/
    
    public void generarCodigo(){
        try {
            String  sql="select max(cod_presentacion)+1 from presentaciones_producto";
            setCon(Util.openConnection(getCon()));
            Statement st=getCon().createStatement();
            ResultSet rs=st.executeQuery(sql);
            if(rs.next()){
                String cod=rs.getString(1);
                if(cod==null)
                    getPresentacionesProducto().setCodPresentacion("1");
                else
                    getPresentacionesProducto().setCodPresentacion(cod);
            }
            if(rs!=null){
                rs.close();
                st.close();
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public String actionSavePresentacionesProductoDatosComerciales(){
        int count=verificar();
        if(count==0){
            cargarAgenciasVenta();
        }else{
            setMensaje("LOS PRECIOS YA ESTAN REGISTRADOS SI DESEA MODIFICARLOS VAYA A LA OPCION EDITAR.");
        }
        
        return "actionAgregarPresentacionesProductoComerciales";
    }
    public String actionCancelar(){
        //cargarPresentacionesProducto();
        return "navegadorpresentacionesproducto";
    }
    /*public String savePresentacionesProducto(){
        try {
            generarCodigo();
            Iterator i=getListaComponentesSeleccionados().iterator();
            while (i.hasNext()){
                System.out.println("3:");
                ComponentesProd bean=(ComponentesProd)i.next();
                String sql="insert into componentes_presprod(cod_compprod,cod_presentacion)values(";
                sql+=""+bean.getCodCompprod()+",";
                sql+=""+getPresentacionesProducto().getCodPresentacion()+")";
                setCon(Util.openConnection(getCon()));
                System.out.println("sql:insert:"+sql);
                PreparedStatement st=getCon().prepareStatement(sql);
                int result=st.executeUpdate();
            }
            String sql="insert into presentaciones_producto(cod_presentacion,cod_prod,peso_neto_presentacion,"+
             " cod_envasesec,cod_envaseterciario,cod_lineamkt,cantidad_presentacion,"+
             " cod_tipomercaderia,cod_carton,obs_presentacion,cod_estado_registro)values(";
            sql+=""+getPresentacionesProducto().getCodPresentacion()+",";
            sql+=""+getPresentacionesProducto().getProducto().getCodProducto()+",";
            sql+=""+getPresentacionesProducto().getPesoNetoPresentacion()+",";
            sql+=""+getPresentacionesProducto().getEnvasesSecundarios().getCodEnvaseSec()+",";
            sql+=""+getPresentacionesProducto().getEnvasesTerciarios().getCodEnvaseTerciario()+",";
            sql+="'"+getPresentacionesProducto().getLineaMKT().getCodLineaMKT()+"',";
            sql+=""+getPresentacionesProducto().getCantidadPresentacion()+",";
            sql+=""+getPresentacionesProducto().getTiposMercaderia().getCodTipoMercaderia()+",";
            sql+=""+getPresentacionesProducto().getCartonesCorrugados().getCodCaton()+",";
            sql+="'"+getPresentacionesProducto().getObsPresentacion()+"',1)";
            System.out.println("sql:insert:"+sql);
            setCon(Util.openConnection(getCon()));
            PreparedStatement st=getCon().prepareStatement(sql);
            int result=st.executeUpdate();
            st.close();
            clear();
            if(result>0){
                //cargarPresentacionesProducto();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "navegadorpresentacionesproducto";
    }*/
    public void clear(){
        PresentacionesProducto tm=new PresentacionesProducto();
        setPresentacionesProducto(tm);
    }
    
    public String actionEditPresentacionesProductoDatosComerciales(){
        cargarPresentacionesComercial();
        return "actionEditarPresentacionesProductoComerciales";
    }
    public String actionEditPresentacionesProductoDatosComercialesInstitucional(){
        cargarPresentacionesComercial();
        return "actionEditarPresentacionesProductoComercialesInstitucional";
    }
    public String SavePresentacionesProductoDatosComerciales(){
        
        try {
            
            for(Object element:AgenciasVentaList){
                PresentacionesProductoDatosComerciales bean=(PresentacionesProductoDatosComerciales)element;
                String sql="insert into presentaciones_producto_datoscomerciales(cod_presentacion," +
                        "cod_area_empresa,stock_minimo,stock_seguridad,stock_maximo," +
                        "precio_lista,precio_minimo,precio_ventacorriente,costo,precio_especial,precio_institucional)values(";
                sql+="'"+codigo+"',";
                sql+="'"+bean.getAreasEmpresa().getCodAreaEmpresa()+"',";
                sql+="0,";
                sql+="0,";
                sql+="0,";
                sql+="'"+bean.getPrecioLista()+"',";
                sql+="'"+bean.getPrecioMinimo()+"',";
                sql+="'"+bean.getPrecioVentaCorriente()+"',";
                sql+="0,";
                sql+="'"+bean.getPrecioEspecial()+"',";
                sql+="'"+bean.getPrecioInstitucional()+"')";
                System.out.println("sql:insert:"+sql);
                PreparedStatement st1=con.prepareStatement(sql);
                int result=st1.executeUpdate();
                st1.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        cargarPresentacionesProductoDetalle();
        return "cancelarPresentacionesProductoComerciales";
    }
    public String EditPresentacionesProductoDatosComerciales(){
        
        try {
            for(Object e:AgenciasVentaList){
                PresentacionesProductoDatosComerciales bean=(PresentacionesProductoDatosComerciales)e;
                String sql="update  presentaciones_producto_datoscomerciales set" +
                        " precio_lista='"+bean.getPrecioLista()+"'," +
                        " precio_minimo='"+bean.getPrecioMinimo()+"'," +
                        " precio_ventacorriente='"+bean.getPrecioVentaCorriente()+"'," +
                        " precio_especial='"+bean.getPrecioEspecial()+"'" +
                        //" precio_institucional='"+bean.getPrecioInstitucional()+"'" +
                        " where cod_presentacion='"+codigo+"' and   " +
                        "   cod_area_empresa='"+bean.getAreasEmpresa().getCodAreaEmpresa()+"'"+
                        " and cod_estado_registro=1";
                System.out.println("sql:update:"+sql);
                PreparedStatement st1=getCon().prepareStatement(sql);
                int result=st1.executeUpdate();
                st1.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        cargarPresentacionesProductoDetalle();
        return "cancelarPresentacionesProductoComerciales";
    }
    public String EditPresentacionesProductoDatosComercialesInstitucional(){
        
        try {
            for(Object e:AgenciasVentaList){
                PresentacionesProductoDatosComerciales bean=(PresentacionesProductoDatosComerciales)e;
                String sql="update  presentaciones_producto_datoscomerciales set" +
                        " precio_institucional='"+bean.getPrecioInstitucional()+"'," +
                        " precio_institucional2='"+bean.getPrecioInstitucional2()+"'" +
                        " where cod_presentacion='"+codigo+"' and   " +
                        "   cod_area_empresa='"+bean.getAreasEmpresa().getCodAreaEmpresa()+"'"+
                        " and cod_estado_registro=1";
                System.out.println("sql:update:"+sql);
                PreparedStatement st1=getCon().prepareStatement(sql);
                int result=st1.executeUpdate();
                st1.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        cargarPresentacionesProductoDetalle();
        return "cancelarPresentacionesProductoComercialesInstitucional";
    }
    /*public String actionDeletePresentacionesProducto(){
        getPresentacionesProductoEli().clear();
        getPresentacionesProductoEli2().clear();
        setSwEliminaSi(false);
        setSwEliminaNo(false);
        Iterator i=getPresentacionesProductoList().iterator();
        while (i.hasNext()){
            PresentacionesProducto bean=(PresentacionesProducto)i.next();
            if(bean.getChecked().booleanValue()){
                try {
                    String sql="select cod_presentacion from presentaciones_producto_datoscomerciales" +
                     " where cod_presentacion="+bean.getCodPresentacion();
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
    }*/
   /* public String deletePresentacionesProducto(){
        try {
    
            Iterator i=getPresentacionesProductoEli().iterator();
            int result=0;
            while (i.hasNext()){
                PresentacionesProducto bean=(PresentacionesProducto)i.next();
                //elimina las anteriores componentes
                String sql="delete from componentes_presprod " +
                 "where cod_presentacion="+bean.getCodPresentacion();
                System.out.println("deletePersonal:sql:"+sql);
                setCon(Util.openConnection(getCon()));
                Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                st.executeUpdate(sql);
                sql="delete from presentaciones_producto " +
                 "where cod_presentacion="+bean.getCodPresentacion();
                System.out.println("deletePersonal:sql:"+sql);
                setCon(Util.openConnection(getCon()));
                st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                result=result+st.executeUpdate(sql);
            }
            getPresentacionesProductoEli().clear();
            if(result>0){
                //cargarPresentacionesProducto();
            }
    
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "navegadorpresentacionesproducto";
    }
    public String changeEventProducto(ValueChangeEvent event){
        System.out.println("limpia");
        getListaComponentesSeleccionados().clear();
        System.out.println("limpia");
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
    }*/
////////////////////////////////////
    
    public int verificar(){
        int count=0;
        
        try {
            String sql="select count(*) from presentaciones_producto_datoscomerciales ";
            sql+=" where cod_presentacion="+codigo;
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(sql);
            if(rs.next()){
                count=rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }
    
    public void cargarAgenciasVenta(){
        AgenciasVentaList.clear();
        try {
            
            String sql="select av.cod_area_empresa,ae.nombre_area_empresa " +
                    " from areas_empresa ae, agencias_venta av" +
                    " where ae.cod_area_empresa=av.cod_area_empresa " ;
            
            System.out.println("cargarAgenciasVenta:sql:"+sql);
            setCon(Util.openConnection(getCon()));
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(sql);
            while (rs.next()){
                PresentacionesProductoDatosComerciales bean =new PresentacionesProductoDatosComerciales();
                bean.getAreasEmpresa().setCodAreaEmpresa(rs.getString(1));
                bean.getAreasEmpresa().setNombreAreaEmpresa(rs.getString(2));
                AgenciasVentaList.add(bean);
            }
            
            
        } catch (SQLException s) {
            s.printStackTrace();
        }
        
        
    }
    /**
     *
     * GARCAR DATOS PARA EDITAR
     *
     **/
    public void cargarPresentacionesComercial(){
        
        try {
            
            String sql="select ppc.cod_presentacion,ppc.cod_area_empresa,isnull(ppc.stock_minimo,0)," +
                    "isnull(ppc.stock_seguridad,0),isnull(ppc.stock_maximo,0),isnull(ppc.precio_lista,0),isnull(ppc.precio_minimo,0)," +
                    "isnull(ppc.precio_ventacorriente,0),ae.nombre_area_empresa,ppc.precio_especial,isnull(ppc.precio_institucional,0),isnull(ppc.precio_institucional2,0)" +
                    " from presentaciones_producto_datoscomerciales ppc,areas_empresa ae" +
                    " where ppc.cod_area_empresa=ae.cod_area_empresa and ppc.cod_estado_registro=1" +
                    " and ppc.cod_presentacion='"+codigo+"' and ae.cod_area_empresa="+getCodigoAreaEmpresa() ;
            System.out.println("Presentacion Comercial:"+sql);
            con=Util.openConnection(con);
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(sql);
            AgenciasVentaList.clear();
            while (rs.next()){
                PresentacionesProductoDatosComerciales bean =new PresentacionesProductoDatosComerciales();
                bean.getPresentacionesProducto().setCodPresentacion(rs.getString(1));
                bean.getAreasEmpresa().setCodAreaEmpresa(rs.getString(2));
                bean.setStockMinimo(rs.getString(3));
                bean.setStockSeguridad(rs.getString(4));
                bean.setStockMaximo(rs.getString(5));
                bean.setPrecioLista(rs.getString(6));
                String monto=rs.getString(7);
                String monto1=monto.replace(",",".");
                System.out.println("monto1:"+monto1);
                bean.setPrecioMinimo(monto1);
                bean.setPrecioVentaCorriente(rs.getString(8));
                bean.getAreasEmpresa().setNombreAreaEmpresa(rs.getString(9));
                bean.setPrecioEspecial(rs.getString(10));
                bean.setPrecioInstitucional(rs.getString(11));
                bean.setPrecioInstitucional2(rs.getString(12));
                AgenciasVentaList.add(bean);
            }
            
            
        } catch (SQLException s) {
            s.printStackTrace();
        }
        
        
    }
    
    public void cargarPresentacionesProductoDetalle(){
        PresentacionesProductoDetalleList.clear();
        try {
            String sql="select ppc.cod_presentacion,ppc.cod_area_empresa,ppc.stock_minimo," +
                    "ppc.stock_seguridad,ppc.stock_maximo,ppc.precio_lista,ppc.precio_minimo," +
                    "ppc.precio_ventacorriente,ae.nombre_area_empresa,precio_especial,ppc.precio_institucional,ppc.fecha_registro,ppc.cod_estado_registro,ppc.precio_institucional2,ppc.stock_reposicion" +
                    " from presentaciones_producto_datoscomerciales ppc,areas_empresa ae" +
                    " where ppc.cod_area_empresa=ae.cod_area_empresa " +
                    " and ppc.cod_presentacion='"+codigo+"' and ae.cod_area_empresa="+getCodAreaEmpresaS();
            System.out.println("Presentacion Comercial:"+sql);
            setCon(Util.openConnection(getCon()));
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(sql);
            while (rs.next()){
                PresentacionesProductoDatosComerciales bean =new PresentacionesProductoDatosComerciales();
                bean.getPresentacionesProducto().setCodPresentacion(rs.getString(1));
                bean.getAreasEmpresa().setCodAreaEmpresa(rs.getString(2));
                bean.setStockMinimo(rs.getString(3));
                bean.setStockSeguridad(rs.getString(4));
                bean.setStockMaximo(rs.getString(5));
                bean.setPrecioLista(rs.getString(6));
                float data1=rs.getFloat(7);
                NumberFormat n=NumberFormat.getInstance();
                n.setMaximumFractionDigits(2);
                n.setMinimumFractionDigits(2);
                String monto=n.format(data1);
                monto=monto.replace(",",".");
                monto=monto.replace(',','.');
                bean.setPrecioMinimo(monto);
                bean.setPrecioVentaCorriente(rs.getString(8));
                bean.getAreasEmpresa().setNombreAreaEmpresa(rs.getString(9));
                bean.setPrecioEspecial(rs.getString(10));
                bean.setPrecioInstitucional(rs.getString(11));
                Date date=rs.getDate(12);
                SimpleDateFormat f=new SimpleDateFormat("dd/MM/yyyy");
                bean.setFechaRegistro(f.format(date));
                int codEstado=rs.getInt(13);
                bean.setPrecioInstitucional2(rs.getString(14));
                bean.setStockReposicion(rs.getString(15));
                if(codEstado==1){
                    bean.setNombreEstadoREgistro("Activo");
                }else{
                    bean.setNombreEstadoREgistro("Inactivo");
                }
                PresentacionesProductoDetalleList.add(bean);
            }
            
            //resultado.setWrappedData(ResultSupport.toResult(rs));
        } catch (SQLException s) {
            s.printStackTrace();
        }
        
        
    }
///////////////////////////////////
    public void buscarProductoVenta(ValueChangeEvent e){
        Object o=e.getNewValue();
        presentacionesProductoList.clear();
        if(o!=null){
           /* try {
                String codigo=o.toString();
                String sql="select cod_presentacion,cod_prod,PESO_NETO_PRESENTACION,COD_ENVASESEC,COD_ENVASETERCIARIO,";
                sql+=" COD_LINEAMKT,cantidad_presentacion,cod_tipomercaderia,COD_CARTON,OBS_PRESENTACION,";
                sql+=" cod_estado_registro from PRESENTACIONES_PRODUCTO where cod_estado_registro=1"+
                        " and p.ap_paterno_personal like '%"+codigo+"%' " ;
            
                System.out.println("Buscar Paterno:"+sql);
                setCon(Util.openConnection(getCon()));
                Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet rs=st.executeQuery(sql);
                while (rs.next()){
                    VacacionesTomadas bean =new VacacionesTomadas();
                    bean.getPersonal().setCodPersonal(rs.getString(1));
                    bean.getPersonal().setNombrePersonal(rs.getString(2));
                    bean.getPersonal().setApPaternoPersonal(rs.getString(3));
                    bean.getPersonal().setApMaternoPersonal(rs.getString(4));
                    bean.getPersonal().getCargos().setDescripcionCargo(rs.getString(5));
                    bean.getPersonal().setSexo(rs.getString(6));
                    bean.getPersonal().getEmpresa().setNombreAreaEmpresa(rs.getString(7));
                    personal.add(bean);
                }
            
                //resultado.setWrappedData(ResultSupport.toResult(rs));
            } catch (SQLException s) {
                s.printStackTrace();
            }*/
        }
    }
////////////////////////////
    /*public String buscarComponentes(){
     
     
        listaComponentesBuscar.clear();
        System.out.println("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
     
        System.out.println("presentacionesProducto.producto.codProducto:"+presentacionesProducto.getProducto().getCodProducto());
        System.out.println("presentacionesProducto.producto.codProducto:"+presentacionesProducto.getProducto().getNombreProducto());
        try {
            String sql="select cod_compprod,cod_envaseprim,cod_colorpresprimaria,volumenpeso_envaseprim," +
             "cantidad_compprod,cod_sabor from componentes_prod ";
            sql+="  where  cod_prod="+getPresentacionesProducto().getProducto().getCodProducto();
            Iterator i=getListaComponentesSeleccionados().iterator();
            while (i.hasNext()){
                ComponentesProd bean=(ComponentesProd)i.next();
                sql+="  and  cod_compprod<>"+bean.getCodCompprod();
            }
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
                principioActivo=componentesProd.getSaboresProductos().getNombreSabor()+principioActivo;
                componentesProd.getSaboresProductos().setNombreSabor(principioActivo);
                System.out.println("sql:"+componentesProd.getSaboresProductos().getNombreSabor());
                System.out.println("principios:"+componentesProd.getSaboresProductos().getNombreSabor());
                getListaComponentesBuscar().add(componentesProd);
     
                //getPresentacionesProductoList().add(bean1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
     
     
        return "";
    }*/
    /*public String listaComponentes(String codigo,PresentacionesProductoDatosComerciales bean1){
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
                bean1.getComponentesList().add(componentesProd);
     
                //getPresentacionesProductoList().add(bean1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
     
     
        return "";
    }*/
    
   /* public void cargarEnvasePrimario(String codigo){
        try {
            setCon(Util.openConnection(getCon()));
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
    }*/
    /*public void cargarPrincipiosActivos(String codigo){
        try {
            setCon(Util.openConnection(getCon()));
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
    }*/
   /* public void cargarColor(String codigo){
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
    }*/
    /*public void cargarSabor(String codigo){
        try {
            setCon(Util.openConnection(getCon()));
            String sql="select nombre_sabor from sabores_producto where cod_sabor="+codigo;
            ResultSet rs=null;
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
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
    }*/
    public String getCloseConnection() throws SQLException{
        if(getCon()!=null){
            getCon().close();
        }
        return "";
    }
    
    public List getPresentacionesProductoList() {
        return presentacionesProductoList;
    }
    
    public void setPresentacionesProductoList(List presentacionesProductoList) {
        this.presentacionesProductoList = presentacionesProductoList;
    }
    
    /*public List getPresentacionesProductoEli() {
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
    }*/
    
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
    
    
    
    public String getCodigo() {
        return codigo;
    }
    
    public void setCodigo(String codigo) {
        this.codigo = codigo;
    }
    
    
    
    public List getAgenciasVentaList() {
        return AgenciasVentaList;
    }
    
    public void setAgenciasVentaList(List AgenciasVentaList) {
        this.AgenciasVentaList = AgenciasVentaList;
    }
    
    public List getPresentacionesProductoDetalleList() {
        return PresentacionesProductoDetalleList;
    }
    
    public void setPresentacionesProductoDetalleList(List PresentacionesProductoDetalleList) {
        this.PresentacionesProductoDetalleList = PresentacionesProductoDetalleList;
    }
    
    /*public List getNombrePresentacionProductoList() {
        return nombrePresentacionProductoList;
    }
     
    public void setNombrePresentacionProductoList(List nombrePresentacionProductoList) {
        this.nombrePresentacionProductoList = nombrePresentacionProductoList;
    }*/
    
    public List getProductosPresentacion() {
        return productosPresentacion;
    }
    
    public void setProductosPresentacion(List productosPresentacion) {
        this.productosPresentacion = productosPresentacion;
    }
    
    public ListDataModel getDatamodel() {
        return datamodel;
    }
    
    public void setDatamodel(ListDataModel datamodel) {
        this.datamodel = datamodel;
    }
    
    public String getNombreproducto() {
        return nombreproducto;
    }
    
    public void setNombreproducto(String nombreproducto) {
        this.nombreproducto = nombreproducto;
    }
    
    public String escogerProducto(){
        String[] data=(String[])datamodel.getRowData();
        setNombreproducto(data[1]);
        setCodigo(data[0]);
        cargarPresentacionesProductoDetalle();
        mensaje="";
        return "navegadorDetalleDatosComerciales";
    }
    
    public String escogerProductoInstitucional(){
        String[] data=(String[])datamodel.getRowData();
        setNombreproducto(data[1]);
        setCodigo(data[0]);
        cargarPresentacionesProductoDetalle();
        mensaje="";
        return "navegadorDetalleDatosComercialesInstitucional";
    }
    
    public String getMensaje() {
        return mensaje;
    }
    
    public void setMensaje(String mensaje) {
        this.mensaje = mensaje;
    }
    public String cargarAgencias(){
        areasAgencias.clear();
        System.out.println("cargarDistritos");
        try {
            setCon(Util.openConnection(getCon()));
            String sql=" select av.cod_area_empresa,ae.nombre_area_empresa";
            sql+=" from areas_empresa ae,agencias_venta av";
            sql+=" where ae.COD_AREA_EMPRESA=av.COD_AREA_EMPRESA and av.cod_area_empresa>40";
            ResultSet rs=null;
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            rs=st.executeQuery(sql);
            while(rs.next()){
                Clientes bean=new Clientes();
                bean.getAreasEmpresa().setCodAreaEmpresa(rs.getString(1));
                bean.getAreasEmpresa().setNombreAreaEmpresa(rs.getString(2));
                areasAgencias.add(bean);
            }
            if(rs!=null){
                rs.close();st.close();
                rs=null;st=null;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return"";
    }
    
    public List getAreasAgencias() {
        return areasAgencias;
    }
    
    public void setAreasAgencias(List areasAgencias) {
        this.areasAgencias = areasAgencias;
    }
    
    public String getCodigoAreaEmpresa() {
        return codigoAreaEmpresa;
    }
    
    public void setCodigoAreaEmpresa(String codigoAreaEmpresa) {
        this.codigoAreaEmpresa = codigoAreaEmpresa;
    }
    
    public int getStockMinimo() {
        return stockMinimo;
    }
    
    public void setStockMinimo(int stockMinimo) {
        this.stockMinimo = stockMinimo;
    }
    
    public int getStockSeguridad() {
        return stockSeguridad;
    }
    
    public void setStockSeguridad(int stockSeguridad) {
        this.stockSeguridad = stockSeguridad;
    }
    
    public int getStockMaximo() {
        return stockMaximo;
    }
    
    public void setStockMaximo(int stockMaximo) {
        this.stockMaximo = stockMaximo;
    }
    public void modificar(ActionEvent e){
        try {
            String sql="update PRESENTACIONES_PRODUCTO_DATOSCOMERCIALES set stock_minimo="+stockMinimo+",stock_seguridad="+stockSeguridad+",stock_maximo="+stockMaximo;
            sql+=" where cod_presentacion="+codigopresentacion;
            sql+=" and cod_area_empresa="+codigoAreaEmpresa;
            System.out.println("preModificar:sql:"+sql);
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            st.executeUpdate(sql);
            st.close();
            cargarStock();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        
        
        
    }
    
    public void preModificar(ActionEvent e){
        System.out.println("preModificar");
        Object obj=datamodel.getRowData();
        if(obj!=null){
            String data[]=(String[])obj;
            System.out.println("obj:"+data.length);
            codigopresentacion=data[0];
            String nombre_producto_presentacion=data[1];
            data[2]=(data[2]==null)?"0":data[2];
            data[3]=(data[3]==null)?"0":data[3];
            data[4]=(data[4]==null)?"0":data[4];
            data[2]=(data[2].equals(""))?"0":data[2];
            data[3]=(data[3].equals(""))?"0":data[3];
            data[4]=(data[4].equals(""))?"0":data[4];
            stockMinimo=Integer.parseInt(data[2]);
            stockSeguridad=Integer.parseInt(data[3]);
            stockMaximo=Integer.parseInt(data[4]);
        }
        
    }
    public String calcular(){
        try {
            
            String sql="select precio_minimo,cod_presentacion from PRESENTACIONES_PRODUCTO_DATOSCOMERCIALES where COD_AREA_EMPRESA="+codigoAreaEmpresa+" and cod_estado_registro=1";
            if(!codigoLinea.equals("0")){
                sql+=" and cod_presentacion in (select cod_presentacion from PRESENTACIONES_PRODUCTO where cod_lineamkt in ("+codigoLinea+"))";
            }
            System.out.println("sqLLLLLLLLLLLL:"+sql);
            con=Util.openConnection(con);
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(sql);
            while (rs.next()){
                float precio=rs.getFloat(1);
                String codpresentacion=rs.getString(2);
                float precioAsignar=precio*(precioPorcentaje/100f);
                System.out.println("precioAsignar:"+precioAsignar);
                System.out.println("precio:"+precio);
                sql="update PRESENTACIONES_PRODUCTO_DATOSCOMERCIALES set "+codprecio+"=round("+precioAsignar+",3) where COD_AREA_EMPRESA="+codigoAreaEmpresa+" and cod_presentacion="+codpresentacion+" and cod_estado_registro=1";
                if(!codigoLinea.equals("0")){
                    sql+=" and cod_presentacion in (select cod_presentacion from PRESENTACIONES_PRODUCTO where cod_lineamkt in ("+codigoLinea+"))";
                }
                System.out.println("sql:"+sql);
                Statement st2 = con.createStatement();
                st2.executeUpdate(sql);
                
            }
            
            
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        
        return "";
    }
    public String calcularPrecioInstitucional2(){
        try {
            
            String sql="select precio_institucional,cod_presentacion from PRESENTACIONES_PRODUCTO_DATOSCOMERCIALES where COD_AREA_EMPRESA="+codigoAreaEmpresa+" and cod_estado_registro=1";
            if(!codigoLinea.equals("0")){
                sql+=" and cod_presentacion in (select cod_presentacion from PRESENTACIONES_PRODUCTO where cod_lineamkt in ("+codigoLinea+"))";
            }
            System.out.println("sqLLLLLLLLLLLL:"+sql);
            con=Util.openConnection(con);
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(sql);
            while (rs.next()){
                float precio=rs.getFloat(1);
                String codpresentacion=rs.getString(2);
                float precioAsignar=precio*(precioPorcentaje/100f);
                System.out.println("precioAsignar:"+precioAsignar);
                System.out.println("precio:"+precio);
                sql="update PRESENTACIONES_PRODUCTO_DATOSCOMERCIALES set "+codprecio+"=round("+precioAsignar+",3) where COD_AREA_EMPRESA="+codigoAreaEmpresa+" and cod_presentacion="+codpresentacion+" and cod_estado_registro=1";
                if(!codigoLinea.equals("0")){
                    sql+=" and cod_presentacion in (select cod_presentacion from PRESENTACIONES_PRODUCTO where cod_lineamkt in ("+codigoLinea+"))";
                }
                System.out.println("sql:"+sql);
                Statement st2 = con.createStatement();
                st2.executeUpdate(sql);
                
            }
            
            
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        
        return "";
    }
    
    public float getPrecioPorcentaje() {
        //codigoAreaEmpresa
        
        return precioPorcentaje;
    }
    
    public void setPrecioPorcentaje(float precioPorcentaje) {
        this.precioPorcentaje = precioPorcentaje;
    }
    
    public String getCodprecio() {
        return codprecio;
    }
    
    public void setCodprecio(String codprecio) {
        this.codprecio = codprecio;
    }
    public String getCargarLinea(){
        
        return "";
    }
    
    public List getLineaMKT() {
        return lineaMKT;
    }
    
    public void setLineaMKT(List lineaMKT) {
        this.lineaMKT = lineaMKT;
    }
    public void cargarLineaMKT()throws SQLException{
        lineaMKT.clear();
        try {
            con=Util.openConnection(con);
            String sql="select cod_lineamkt,nombre_lineamkt from LINEAS_MKT where cod_estado_registro=1 order by nombre_lineamkt";
            ResultSet rs=null;
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            rs=st.executeQuery(sql);
            
            while(rs.next()){
                LineaMKT bean=new LineaMKT();
                bean.setCodLineaMKT(rs.getString(1));
                bean.setNombreLineaMKT(rs.getString(2));
                lineaMKT.add(bean);
            }
            LineaMKT bean1=new LineaMKT();
            bean1.setCodLineaMKT("0");
            bean1.setNombreLineaMKT("TODAS LAS LINEAS");
            lineaMKT.add(bean1);
            if(rs!=null){
                rs.close();st.close();
                rs=null;st=null;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public String getCogerCodigoLineaMKT(){
        String codLinea=Util.getParameter("codLinea");
        System.out.println("codLinea:"+codLinea);
        if(codLinea!=null){
            setCodigoLinea(codLinea);
        }
        try {
            cargarProductos();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "";
    }
    
    public String getCodigoLinea() {
        return codigoLinea;
    }
    
    public void setCodigoLinea(String codigoLinea) {
        this.codigoLinea = codigoLinea;
    }
    /**************************************************************************/
    /**************************************************************************
     * STOCK MINIMOS
     **************************************************************************/
    /**************************************************************************/
    public String getCogerCodigoAreaEmpresaS(){
        String codigoS=Util.getParameter("codigo");
        System.out.println("codigoS:"+codigoS);
        if(codigoS!=null){
            setCodAreaEmpresaS(codigoS);
        }
        try {
            cargarProductosS();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "";
    }
    public void cargarProductosS()throws SQLException{
        String sql="";
        sql="select pp.cod_presentacion,pp.nombre_producto_presentacion,round(dm.STOCK_MINIMO, 3)";
        sql+=" ,round(dm.STOCK_SEGURIDAD, 3),round(dm.STOCK_MAXIMO, 3),round(dm.STOCK_REPOSICION, 3)";
        sql+=" from PRESENTACIONES_PRODUCTO pp,STOCK_PRESENTACIONES dm";
        sql+=" where pp.cod_presentacion = dm.cod_presentacion and dm.COD_AREA_EMPRESA = "+getCodAreaEmpresaS();
        sql+=" and pp.cod_tipomercaderia = 1 order by pp.nombre_producto_presentacion ";
        System.out.println("sql1111111111111111:"+sql);
        con=Util.openConnection(con);
        Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
        ResultSet rs=st.executeQuery(sql);
        List array=new ArrayList();
        while (rs.next()){
            String data[]=new String [6];
            data[0]=rs.getString(1);
            data[1]=rs.getString(2);
            data[2]=rs.getString(3);
            data[3]=rs.getString(4);
            data[4]=rs.getString(5);
            data[5]=rs.getString(6);
            array.add(data);
        }
        datamodel.setWrappedData(array);
    }
    public String escogerProductoS(){
        String[] data=(String[])datamodel.getRowData();
        setNombreproducto(data[1]);
        setCodigo(data[0]);
        cargarPresentacionesProductoDetalleS();
        mensaje="";
        return "navegadorDetalleDatosComercialesStocks";
    }
    public void cargarPresentacionesProductoDetalleS(){
        PresentacionesProductoDetalleList.clear();
        try {
            String sql="select pp.cod_presentacion,pp.nombre_producto_presentacion";
            sql+=",round(dm.STOCK_MINIMO, 3),round(dm.STOCK_SEGURIDAD, 3),round(dm.STOCK_MAXIMO, 3),round(dm.STOCK_REPOSICION, 3)";
            sql+=" from PRESENTACIONES_PRODUCTO pp,STOCK_PRESENTACIONES dm";
            sql+=" where pp.cod_presentacion = dm.cod_presentacion and dm.COD_AREA_EMPRESA = "+getCodAreaEmpresaS();
            sql+=" and pp.cod_tipomercaderia = 1 and dm.COD_PRESENTACION = "+getCodigo();
            sql+=" order by pp.nombre_producto_presentacion";
            System.out.println("Presentacion Comercial:"+sql);
            setCon(Util.openConnection(getCon()));
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(sql);
            while (rs.next()){
                PresentacionesProductoDatosComerciales bean =new PresentacionesProductoDatosComerciales();
                bean.getPresentacionesProducto().setCodPresentacion(rs.getString(1));
                bean.getAreasEmpresa().setCodAreaEmpresa(rs.getString(2));
                bean.setStockMinimo(rs.getString(3));
                bean.setStockSeguridad(rs.getString(4));
                bean.setStockMaximo(rs.getString(5));
                bean.setStockReposicion(rs.getString(6));
                PresentacionesProductoDetalleList.add(bean);
            }
        } catch (SQLException s) {
            s.printStackTrace();
        }
    }
    public String CancelarS(){
        // cargarPresentacionesProducto();
        return"navegadorPresentacionesProductoComercialesStock";
    }
    public String CancelarS12(){
        return"navegadorPresentacionesProductoComercialesStockCancelar";
    }
    public void cargarPresentacionesComercialS(){
        AgenciasVentaList.clear();
        try {
            String sql="select pp.cod_presentacion,pp.nombre_producto_presentacion";
            sql+=",round(dm.STOCK_MINIMO, 3),round(dm.STOCK_SEGURIDAD, 3),round(dm.STOCK_MAXIMO, 3),round(dm.STOCK_REPOSICION, 3)";
            sql+=" from PRESENTACIONES_PRODUCTO pp,STOCK_PRESENTACIONES dm";
            sql+=" where pp.cod_presentacion = dm.cod_presentacion and dm.COD_AREA_EMPRESA = "+getCodAreaEmpresaS();
            sql+=" and pp.cod_tipomercaderia = 1 and dm.COD_PRESENTACION = "+getCodigo();
            sql+=" order by pp.nombre_producto_presentacion";
            System.out.println("Presentacion Comercial:"+sql);
            setCon(Util.openConnection(getCon()));
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(sql);
            while (rs.next()){
                PresentacionesProductoDatosComerciales bean =new PresentacionesProductoDatosComerciales();
                bean.getPresentacionesProducto().setCodPresentacion(rs.getString(1));
                bean.getAreasEmpresa().setCodAreaEmpresa(rs.getString(2));
                bean.setStockMinimo(rs.getString(3));
                bean.setStockSeguridad(rs.getString(4));
                bean.setStockMaximo(rs.getString(5));
                bean.setStockReposicion(rs.getString(6));
                AgenciasVentaList.add(bean);
            }
        } catch (SQLException s) {
            s.printStackTrace();
        }
    }
    
    public String actionEditPresentacionesProductoDatosComercialesStock(){
        cargarPresentacionesComercialS();
        return "actionEditarPresentacionesProductoComercialesStock";
    }
    public String EditPresentacionesProductoDatosComercialesS(){
        
        try {
            for(Object e:AgenciasVentaList){
                PresentacionesProductoDatosComerciales bean=(PresentacionesProductoDatosComerciales)e;
                String sql="update  STOCK_PRESENTACIONES set" +
                        " STOCK_MINIMO='"+bean.getStockMinimo()+"'," +
                        " STOCK_SEGURIDAD='"+bean.getStockSeguridad()+"'," +
                        " STOCK_MAXIMO='"+bean.getStockMaximo()+"'," +
                        " STOCK_REPOSICION='"+bean.getStockReposicion()+"'" +
                        //" precio_institucional='"+bean.getPrecioInstitucional()+"'" +
                        " where cod_presentacion='"+codigo+"' and   " +
                        "   cod_area_empresa='"+codAreaEmpresaS+"'";
                System.out.println("sql:update:"+sql);
                PreparedStatement st1=getCon().prepareStatement(sql);
                int result=st1.executeUpdate();
                st1.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        cargarPresentacionesProductoDetalleS();
        return "cancelarPresentacionesProductoComercialesStock";
    }
    public String Cancelar1S(){
        //cargarPresentacionesProducto();
        return"cancelarPresentacionesProductoComercialesStock";
    }
    public String getCodAreaEmpresaS() {
        return codAreaEmpresaS;
    }
    
    public void setCodAreaEmpresaS(String codAreaEmpresaS) {
        this.codAreaEmpresaS = codAreaEmpresaS;
    }
    /**************************************************************************/
    /**************************************************************************
     * STOCK DE REPOSICION
     **************************************************************************/
    /**************************************************************************/
    public String getCogerCodigoAreaEmpresaStockReposicion(){
        String codigoS=Util.getParameter("codigo");
        System.out.println("codigoS:"+codigoS);
        if(codigoS!=null){
            setCodAreaEmpresaS(codigoS);
        }
        try {
            cargarProductosStockReposicion();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "";
    }
    public void cargarProductosStockReposicion()throws SQLException{
        String sql="";
        sql="select pp.cod_presentacion,pp.nombre_producto_presentacion,round(ppd.stock_reposicion,3)";
        sql+=" from PRESENTACIONES_PRODUCTO pp,PRESENTACIONES_PRODUCTO_DATOSCOMERCIALES ppd";
        sql+=" where pp.cod_presentacion = ppd.cod_presentacion and ppd.COD_AREA_EMPRESA = "+getCodAreaEmpresaS();
        sql+=" and pp.cod_tipomercaderia = 1 order by pp.nombre_producto_presentacion ";
        System.out.println("sql1111111111111111:"+sql);
        con=Util.openConnection(con);
        Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
        ResultSet rs=st.executeQuery(sql);
        List array=new ArrayList();
        while (rs.next()){
            String data[]=new String [3];
            data[0]=rs.getString(1);
            data[1]=rs.getString(2);
            data[2]=rs.getString(3);
            array.add(data);
        }
        datamodel.setWrappedData(array);
    }
    public String escogerProductoStockReposicion(){
        String[] data=(String[])datamodel.getRowData();
        setNombreproducto(data[1]);
        setCodigo(data[0]);
        cargarPresentacionesProductoDetalleS();
        mensaje="";
        return "navegadorDetalleDatosComercialesStockReposicion";
    }
    public String actionEditPresentacionesProductoDatosComercialesStockReposicion(){
        cargarPresentacionesComercialS();
        return "actionEditarPresentacionesProductoComercialesStockReposicion";
    }
}
