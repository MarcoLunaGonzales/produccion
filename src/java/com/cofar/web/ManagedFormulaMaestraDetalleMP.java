/*
 * ManagedTipoCliente.java
 * Created on 19 de febrero de 2008, 16:50
 */
package com.cofar.web;

import com.cofar.bean.FormulaMaestraDetalleMP;
import com.cofar.bean.FormulaMaestraDetalleMPfracciones;
import com.cofar.bean.SolicitudMantenimiento;
import com.cofar.bean.TiposAnalisisMaterialReactivo;
import com.cofar.bean.TiposReactivos;
import com.cofar.util.Util;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Properties;
import javax.faces.model.SelectItem;
import javax.mail.Message;
import javax.mail.Session;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

/**
 *
 *  @author Wilmer Manzaneda Chavez
 *  @company COFAR
 */
public class ManagedFormulaMaestraDetalleMP {

    /** Creates a new instance of ManagedTipoCliente */
    private FormulaMaestraDetalleMP formulaMaestraDetalleMPbean = new FormulaMaestraDetalleMP();
    private List formulaMaestraDetalleMPList = new ArrayList();
    private List formulaMaestraDetalleMReactivoList = new ArrayList();
    private List formulaMaestraDetalleMPAdicionarList = new ArrayList();
    private List formulaMaestraDetalleMPEliminarList = new ArrayList();
    private List formulaMaestraDetalleMPEditarList = new ArrayList();
    private List fraccionesDetalleMPList = new ArrayList();
    private List materialesList = new ArrayList();
    private List unidadesMedidaList = new ArrayList();
    private Connection con;
    private String codigo = "";
    private boolean swSi = false;
    private boolean swNo = false;
    private String nombreComProd = "";
    ManagedFormulaMaestra managedFormulaMaestra = new ManagedFormulaMaestra();
    List tiposMaterialReactivoList = new ArrayList();
    FormulaMaestraDetalleMP formulaMaestraDetalleMP = new FormulaMaestraDetalleMP();
    List tiposReactivosList = new ArrayList();
    List tiposAnalisisMaterialReactivo = new ArrayList();
    public ManagedFormulaMaestraDetalleMP() {
    }

    public String getObtenerCodigo() {

        //String cod=Util.getParameter("codigo");
        String cod = Util.getParameter("codigo");
        //cod="1";
        System.out.println("cxxxxxxxxxxxxxxxxxxxxxxxod:" + cod);
        if (cod != null) {
            setCodigo(cod);
            formulaMaestraDetalleMPbean.getFormulaMaestra().setCodFormulaMaestra(cod);
        }
        formulaMaestraDetalleMPList.clear();
        formulaMaestraDetalleMPList = cargarFormulaMaestraDetalleMP();
        cargarNombreComProd();
        return "";

    }

    public String getObtenerCodigoFracciones() {
        String codigoM = Util.getParameter("codigoM");
        System.out.println("codigoM.........:" + codigoM);
        if (codigoM != null) {
            formulaMaestraDetalleMPbean.getMateriales().setCodMaterial(codigoM);
        }
        fraccionesDetalleMPList.clear();
        cargarFraccionesDetalleMP();
        return "";
    }

    public void cargarFraccionesDetalleMP() {
        try {
            setCon(Util.openConnection(getCon()));
            String sql_00 = "select (select m.NOMBRE_MATERIAL from MATERIALES m where m.COD_MATERIAL=fd.COD_MATERIAL) as nombreMaterial,fd.CANTIDAD,fd.NRO_PREPARACIONES from FORMULA_MAESTRA_DETALLE_MP fd";
            sql_00 += " where fd.COD_FORMULA_MAESTRA=" + formulaMaestraDetalleMPbean.getFormulaMaestra().getCodFormulaMaestra() + " and fd.COD_MATERIAL=" + formulaMaestraDetalleMPbean.getMateriales().getCodMaterial();
            System.out.println("sql_00........:" + sql_00);
            Statement st_00 = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs_00 = st_00.executeQuery(sql_00);
            if (rs_00.next()) {
                formulaMaestraDetalleMPbean.getMateriales().setNombreMaterial(rs_00.getString(1));
                formulaMaestraDetalleMPbean.setCantidad(rs_00.getDouble(2));
            }
            String sql = "select ROUND(fmf.CANTIDAD,2) from FORMULA_MAESTRA_DETALLE_MP_FRACCIONES fmf where fmf.COD_FORMULA_MAESTRA=" + formulaMaestraDetalleMPbean.getFormulaMaestra().getCodFormulaMaestra();
            sql += " and fmf.COD_MATERIAL=" + formulaMaestraDetalleMPbean.getMateriales().getCodMaterial() + " order by fmf.COD_FORMULA_MAESTRA_FRACCIONES asc";
            sql = " select ROUND(ff.CANTIDAD,2),t.COD_TIPO_MATERIAL_PRODUCCION,t.NOMBRE_TIPO_MATERIAL_PRODUCCION" +
                    " from FORMULA_MAESTRA_DETALLE_MP_FRACCIONES ff" +
                    " left outer join TIPOS_MATERIAL_PRODUCCION t on t.COD_TIPO_MATERIAL_PRODUCCION = ff.COD_TIPO_MATERIAL_PRODUCCION" +
                    " where ff.COD_FORMULA_MAESTRA='"+formulaMaestraDetalleMPbean.getFormulaMaestra().getCodFormulaMaestra()+"' and ff.COD_MATERIAL='"+formulaMaestraDetalleMPbean.getMateriales().getCodMaterial()+"' ";
            Statement st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(sql);
            rs.last();
            int rows = rs.getRow();
            fraccionesDetalleMPList.clear();
            rs.first();
            for (int i = 0; i < rows; i++) {
                FormulaMaestraDetalleMPfracciones bean = new FormulaMaestraDetalleMPfracciones();
                bean.setRows(i + 1);
                bean.setCantidad(rs.getFloat(1));
                bean.setTiposMaterialProduccionList(this.cargarTiposMaterialProduccionList());
                bean.getTiposMaterialProduccion().setCodTipoMaterialProduccion(rs.getInt("cod_tipo_material_produccion"));
                fraccionesDetalleMPList.add(bean);
                rs.next();
            }
            if (rs != null) {
                rs.close();
                st.close();
            }


        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public List cargarTiposMaterialProduccionList(){
        List list = new ArrayList();
        try {
            Connection con = null;
            con = Util.openConnection(con);
            Statement st = con.createStatement();
            String consulta = " select cod_tipo_material_produccion,nombre_tipo_material_produccion from tipos_material_produccion ";
            System.out.println("consulta " + consulta);
            ResultSet rs = st.executeQuery(consulta);
            list.add(new SelectItem("0","-NINGUNO-"));
            while(rs.next()){
                list.add(new SelectItem(rs.getString("cod_tipo_material_produccion"),rs.getString("nombre_tipo_material_produccion")));
            }
            rs.close();
            st.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public String getObtenerCodigoReactivo() {

        //String cod=Util.getParameter("codigo");
        String cod = Util.getParameter("codigo");
        //cod="1";
        System.out.println("cxxxxxxxxxxxxxxxxxxxxxxxod:" + cod);
        if (cod != null) {
            setCodigo(cod);
        }
        tiposMaterialReactivoList = this.cargarTipoMaterial();
        formulaMaestraDetalleMP.getTiposMaterialReactivo().setCodTipoMaterialReactivo(1);        
        formulaMaestraDetalleMReactivoList.clear();
        formulaMaestraDetalleMReactivoList = cargarFormulaMaestraDetalleMReactivo();
        cargarNombreComProd();
        tiposAnalisisMaterialReactivo = this.cargarTipoAnalisisMaterialReactivo();
        
        //this.tiposMaterial_change();
        
        return "";

    }
    public String tiposMaterial_change(){
        try {
            formulaMaestraDetalleMReactivoList = this.cargarFormulaMaestraDetalleMReactivo();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List cargarTipoMaterial(){
        List tiposMaterial = new ArrayList();
        try {
            setCon(Util.openConnection(getCon()));
            String consulta = " select t.COD_TIPO_MATERIAL_REACTIVO,t.NOMBRE_TIPO_MATERIAL_REACTIVO from TIPOS_MATERIAL_REACTIVO t where t.COD_ESTADO_REGISTRO = 1 ";
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(consulta);
            tiposMaterial.clear();
            while(rs.next()){                
                tiposMaterial.add(new SelectItem(rs.getString("COD_TIPO_MATERIAL_REACTIVO"),rs.getString("NOMBRE_TIPO_MATERIAL_REACTIVO")));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return tiposMaterial;
    }
    public List cargarTipoAnalisisMaterialReactivo(){
        List tiposAnalisisMaterial = new ArrayList();
        try {
            setCon(Util.openConnection(getCon()));
            String consulta = " select t.cod_tipo_analisis_material_reactivo,t.nombre_tipo_analisis_material_reactivo from TIPOS_ANALISIS_MATERIAL_REACTIVO t ";
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(consulta);
            tiposAnalisisMaterial.clear();
            tiposAnalisisMaterial.add(new SelectItem("0", "-NINGUNO-"));
            while(rs.next()){
                tiposAnalisisMaterial.add(new SelectItem(rs.getString("cod_tipo_analisis_material_reactivo"),rs.getString("nombre_tipo_analisis_material_reactivo")));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return tiposAnalisisMaterial;
    }


    public String cancelar() {
        formulaMaestraDetalleMPList = cargarFormulaMaestraDetalleMP();
        return "navegadorFormulaMaestraDetalleMP";
    }

    public String cancelarReactivo() {
        formulaMaestraDetalleMReactivoList=cargarFormulaMaestraDetalleMReactivo();
        return "navegadorFormulaMaestraDetalleMR";
    }

    public String cargarNombreComProd() {
        try {
            setNombreComProd("");
            setCon(Util.openConnection(getCon()));
            String sql = " select cp.nombre_prod_semiterminado";
            sql += " from COMPONENTES_PROD cp,PRODUCTOS p,FORMULA_MAESTRA fm";
            sql += " where cp.COD_COMPPROD=fm.COD_COMPPROD and p.cod_prod=cp.COD_PROD";
            sql += " and fm.COD_FORMULA_MAESTRA='" + getCodigo() + "'";
            System.out.println("sql:-----------:" + sql);
            PreparedStatement st = getCon().prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                setNombreComProd(rs.getString(1));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        System.out.println("nombreComProd:" + nombreComProd);
        return "";
    }

    /**
     * metodo que genera los codigos
     * correlativamente
     */
    /**
     * Metodo para cargar los datos en
     * el datatable
     */
    public List cargarFormulaMaestraDetalleMP() {
        List formulaMaestraDetalleMPList = new ArrayList();
        try {
            System.out.println("codigo:" + getCodigo());
            String sql = "select fm.COD_FORMULA_MAESTRA,m.NOMBRE_MATERIAL,ROUND(fmp.CANTIDAD,2),um.NOMBRE_UNIDAD_MEDIDA,m.cod_material, fmp.nro_preparaciones,m.cod_grupo,e.nombre_estado_registro ";
            sql += " from FORMULA_MAESTRA fm,MATERIALES m,UNIDADES_MEDIDA um,FORMULA_MAESTRA_DETALLE_MP fmp,estados_referenciales e";
            sql += " where fm.COD_FORMULA_MAESTRA=fmp.COD_FORMULA_MAESTRA and um.COD_UNIDAD_MEDIDA=fmp.COD_UNIDAD_MEDIDA";
            sql += " and m.COD_MATERIAL=fmp.COD_MATERIAL ";
            sql += " and fmp.COD_MATERIAL IN(select m1.COD_MATERIAL from MATERIALES m1,grupos g where g.COD_GRUPO=m1.COD_GRUPO";
            sql += " and g.COD_CAPITULO=2) and fm.COD_FORMULA_MAESTRA='" + codigo + "' and m.cod_estado_registro=1 and e.cod_estado_registro=m.cod_estado_registro";
            sql += " order by m.NOMBRE_MATERIAL";
            System.out.println("sql formula detalle:  " + sql);
            setCon(Util.openConnection(getCon()));
            Statement st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(sql);
            rs.last();
            int rows = rs.getRow();
            formulaMaestraDetalleMPList.clear();
            rs.first();
            for (int i = 0; i < rows; i++) {
                FormulaMaestraDetalleMP bean = new FormulaMaestraDetalleMP();
                bean.setSwNo(false);
                bean.setSwSi(false);
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
                bean.setNroPreparaciones(rs.getInt(6));
                bean.getMateriales().getEstadoRegistro().setNombreEstadoRegistro(rs.getString("nombre_estado_registro"));
                String codGrupo = rs.getString(7);
                if (codGrupo.equals("5")) {
                    System.out.println("reactivo");
                    bean.setSwNo(false);
                    bean.setSwSi(true);
                } else {
                    System.out.println("no reactivo");
                    bean.setSwNo(true);
                    bean.setSwSi(false);
                }
                String sql_00 = "select ROUND(ff.CANTIDAD,2) from FORMULA_MAESTRA_DETALLE_MP_FRACCIONES ff where ff.COD_FORMULA_MAESTRA=" + bean.getFormulaMaestra().getCodFormulaMaestra();
                sql_00 += " and ff.COD_MATERIAL=" + bean.getMateriales().getCodMaterial();
                sql_00 = " select ROUND(ff.CANTIDAD,2),t.COD_TIPO_MATERIAL_PRODUCCION,t.NOMBRE_TIPO_MATERIAL_PRODUCCION" +
                        " from FORMULA_MAESTRA_DETALLE_MP_FRACCIONES ff" +
                        " left outer join TIPOS_MATERIAL_PRODUCCION t on t.COD_TIPO_MATERIAL_PRODUCCION = ff.COD_TIPO_MATERIAL_PRODUCCION" +
                        " where ff.COD_FORMULA_MAESTRA='"+bean.getFormulaMaestra().getCodFormulaMaestra()+"' and ff.COD_MATERIAL='"+bean.getMateriales().getCodMaterial()+"' ";

                System.out.println("sql_00...........:"+sql_00);
                Statement st_00 = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rs_00 = st_00.executeQuery(sql_00);
                List arrayAux = new ArrayList();
                while (rs_00.next()) {
                    FormulaMaestraDetalleMPfracciones val = new FormulaMaestraDetalleMPfracciones();
                    val.setCantidad(rs_00.getDouble(1));
                    val.getTiposMaterialProduccion().setCodTipoMaterialProduccion(rs_00.getInt("cod_tipo_material_produccion"));
                    val.getTiposMaterialProduccion().setNombreTipoMaterialProduccion(rs_00.getString("nombre_tipo_material_produccion"));
                    arrayAux.add(val);
                }
                bean.setFraccionesDetalleList(arrayAux);
                formulaMaestraDetalleMPList.add(bean);
                rs.next();
            }
            if (rs != null) {
                rs.close();
                st.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return formulaMaestraDetalleMPList;
    }

    public List cargarFormulaMaestraDetalleMReactivo() {
        List formulaMaestraDetalleMReactivoList = new ArrayList();
        try {
            System.out.println("codigo:" + getCodigo());
            String sql = "select fm.COD_FORMULA_MAESTRA,m.NOMBRE_MATERIAL,fmp.CANTIDAD,um.NOMBRE_UNIDAD_MEDIDA,m.cod_material, fmp.nro_preparaciones,m.cod_grupo,fmp.cod_tipo_material,e.nombre_estado_registro,fmp.cod_tipo_analisis_material";
            sql += " from FORMULA_MAESTRA fm,MATERIALES m,UNIDADES_MEDIDA um,FORMULA_MAESTRA_DETALLE_MR fmp,estados_referenciales e ";
            sql += " where fm.COD_FORMULA_MAESTRA=fmp.COD_FORMULA_MAESTRA and um.COD_UNIDAD_MEDIDA=fmp.COD_UNIDAD_MEDIDA";
            sql += " and m.COD_MATERIAL=fmp.COD_MATERIAL ";
            sql += " and fmp.COD_MATERIAL IN(select m1.COD_MATERIAL from MATERIALES m1,grupos g where g.COD_GRUPO=m1.COD_GRUPO";
            sql += " and g.COD_CAPITULO=2 ) and fm.COD_FORMULA_MAESTRA='" + codigo + "' " +
                    " and fmp.cod_tipo_material = '"+formulaMaestraDetalleMP.getTiposMaterialReactivo().getCodTipoMaterialReactivo()+"' and m.cod_estado_registro = e.cod_estado_registro"+(formulaMaestraDetalleMP.getTiposAnalisisMaterialReactivo().getCodTiposAnalisisMaterialReactivo()!=0?" and fmp.cod_tipo_analisis_material='"+formulaMaestraDetalleMP.getTiposAnalisisMaterialReactivo().getCodTiposAnalisisMaterialReactivo()+"' ":"");
            sql += " order by m.NOMBRE_MATERIAL";
            System.out.println("sql formula detalle:  " + sql);
            setCon(Util.openConnection(getCon()));
            Statement st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(sql);
            rs.last();
            int rows = rs.getRow();
            formulaMaestraDetalleMPList.clear();
            formulaMaestraDetalleMReactivoList.clear();
            rs.first();
            for (int i = 0; i < rows; i++) {
                FormulaMaestraDetalleMP bean = new FormulaMaestraDetalleMP();
                bean.getFormulaMaestra().setCodFormulaMaestra(rs.getString(1));
                bean.getMateriales().setNombreMaterial(rs.getString(2));
                double cantidad = rs.getDouble(3);
                cantidad = redondear(cantidad, 3);
                NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
                DecimalFormat form = (DecimalFormat) nf;
                form.applyPattern("#,#00.0#");
                bean.setCantidad(cantidad);
                //bean.setCantidad(rs.getString(3));
                bean.getUnidadesMedida().setNombreUnidadMedida(rs.getString(4));
                bean.getMateriales().setCodMaterial(rs.getString(5));
                bean.getMateriales().getEstadoRegistro().setNombreEstadoRegistro(rs.getString("nombre_estado_registro"));
                bean.setNroPreparaciones(rs.getInt(6));
                String codGrupo = rs.getString(7);
                if (codGrupo.equals("5")) {
                    System.out.println("reactivo");
                } else {
                    System.out.println("no reactivo");
                }
                bean.getTiposMaterialReactivo().setCodTipoMaterialReactivo(rs.getInt("cod_tipo_material"));
                bean.getTiposAnalisisMaterialReactivo().setCodTiposAnalisisMaterialReactivo(rs.getInt("cod_tipo_analisis_material"));
                bean.setTiposAnalisisMaterialReactivoList1(this.cargarTiposAnalisisMaterialReactivo(bean));
                formulaMaestraDetalleMReactivoList.add(bean);
                rs.next();
            }
            if (rs != null) {
                rs.close();
                st.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return formulaMaestraDetalleMReactivoList;
    }
    public List cargarTiposAnalisisMaterialReactivo(FormulaMaestraDetalleMP f){
        List tiposAnalisisMaterialReactivoList = new ArrayList();
        try {
            Connection con = null;
            con = Util.openConnection(con);
            Statement st = con.createStatement();
            String consulta = " select f.cod_formula_maestra,t.cod_tipo_analisis_material_reactivo,t.nombre_tipo_analisis_material_reactivo" +
                              " from TIPOS_ANALISIS_MATERIAL_REACTIVO t left outer join" +
                              " formula_maestra_mr_clasificacion f on f.cod_tipo_analisis_material_reactivo = t.cod_tipo_analisis_material_reactivo and f.cod_formula_maestra = '"+codigo+"'" +
                              " and f.cod_material = '"+f.getMateriales().getCodMaterial()+"' ";
            System.out.println("consulta " + consulta);
            ResultSet rs = st.executeQuery(consulta);
            while(rs.next()){
                TiposAnalisisMaterialReactivo t = new TiposAnalisisMaterialReactivo();
                if(rs.getInt("cod_formula_maestra")>0){t.setChecked(true);}
                t.setCodTiposAnalisisMaterialReactivo(rs.getInt("cod_tipo_analisis_material_reactivo"));
                t.setNombreTiposAnalisisMaterialReactivo(rs.getString("nombre_tipo_analisis_material_reactivo"));
                tiposAnalisisMaterialReactivoList.add(t);
            }
            rs.close();
            st.close();
            con.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return tiposAnalisisMaterialReactivoList;
    }
    


    public double redondear(double numero, int decimales) {
        return Math.round(numero * Math.pow(10, decimales)) / Math.pow(10, decimales);
    }

    public String actionAgregar() {
        System.out.println("entro4656532");
        cargarMateriaPrima();
        //cargarUnidadesMedida("",null);
        System.out.println("enrreknkjlsdf" + unidadesMedidaList.size());
        return "actionAgregarFormulaMaestraDetalleMP";
    }

    public String actionAgregarReactivo() {
        System.out.println("entro4656532");
        cargarMateriaPrimaReactivo();
        //cargarUnidadesMedida("",null);
        System.out.println("enrreknkjlsdf" + unidadesMedidaList.size());
        return "actionAgregarFormulaMaestraDetalleMR";
    }

    public String cargarMateriaPrimaReactivo() {
        try {
            System.out.println("entroooooooooooooooooooooooooooooooooo");
            formulaMaestraDetalleMPAdicionarList.clear();
            System.out.println("codigo:" + getCodigo());

            String sql = "select m1.COD_MATERIAL,m1.NOMBRE_MATERIAL,um.ABREVIATURA,um.cod_unidad_medida,g.cod_grupo "
                    + " from MATERIALES m1,grupos g,UNIDADES_MEDIDA um where g.COD_GRUPO=m1.COD_GRUPO";
            sql += " and g.COD_CAPITULO=2 and m1.movimiento_item in(1,2) and g.cod_grupo=5 and m1.COD_MATERIAL <> ";
            sql += " ALL(select fmp.COD_MATERIAL from FORMULA_MAESTRA_DETALLE_MR fmp where fmp.COD_FORMULA_MAESTRA='" + getCodigo() + "' ) and um.COD_UNIDAD_MEDIDA=m1.COD_UNIDAD_MEDIDA";
            sql += " order by m1.NOMBRE_MATERIAL";

            sql = "select m1.COD_MATERIAL,m1.NOMBRE_MATERIAL,um.ABREVIATURA,um.cod_unidad_medida,g.cod_grupo "
                    + " from MATERIALES m1,grupos g,UNIDADES_MEDIDA um where g.COD_GRUPO=m1.COD_GRUPO";
            sql += " and g.COD_CAPITULO=2 and m1.movimiento_item in(1) " +
                    " and m1.COD_MATERIAL <>  ALL(select fmp.COD_MATERIAL from FORMULA_MAESTRA_DETALLE_MR fmp where fmp.COD_FORMULA_MAESTRA='" + getCodigo() + "' ) " +
                    " and um.COD_UNIDAD_MEDIDA=m1.COD_UNIDAD_MEDIDA and m1.COD_ESTADO_REGISTRO = 1 ";
            sql += " order by m1.NOMBRE_MATERIAL";

            //" and m1.COD_MATERIAL <> ALL(select fmp.COD_MATERIAL from FORMULA_MAESTRA_DETALLE_MP fmp where fmp.COD_FORMULA_MAESTRA='" + getCodigo() + "' )

            System.out.println("sql:" + sql);
            setCon(Util.openConnection(getCon()));
            Statement st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(sql);
            rs.last();
            int rows = rs.getRow();
            rs.first();
            for (int i = 0; i < rows; i++) {
                FormulaMaestraDetalleMP bean = new FormulaMaestraDetalleMP();
                bean.getMateriales().setCodMaterial(rs.getString(1));
                bean.getMateriales().setNombreMaterial(rs.getString(2));
                bean.getUnidadesMedida().setAbreviatura(rs.getString(3));
                bean.getUnidadesMedida().setCodUnidadMedida(rs.getString(4));
                bean.setCantidad(0);
                String codGrupo = rs.getString(5);
                if (codGrupo.equals("5")) {
                    System.out.println("reactivo");
                    bean.setSwNo(false);
                    bean.setSwSi(true);
                } else {
                    System.out.println("no reactivo");
                    bean.setSwNo(true);
                    bean.setSwSi(false);
                }
                formulaMaestraDetalleMPAdicionarList.add(bean);
                rs.next();
            }

            if (rs != null) {
                rs.close();
                st.close();
            }


        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "";
    }

    public String cargarMateriaPrima() {

        try {
            System.out.println("entroooooooooooooooooooooooooooooooooo");
            formulaMaestraDetalleMPAdicionarList.clear();
            System.out.println("codigo:" + getCodigo());

            String sql = "select m1.COD_MATERIAL,m1.NOMBRE_MATERIAL,um.ABREVIATURA,um.cod_unidad_medida,g.cod_grupo "
                    + " from MATERIALES m1,grupos g,UNIDADES_MEDIDA um where g.COD_GRUPO=m1.COD_GRUPO";
            sql += " and g.COD_CAPITULO=2 and m1.movimiento_item in(1,2) and m1.COD_MATERIAL <> ";
            sql += " ALL(select fmp.COD_MATERIAL from FORMULA_MAESTRA_DETALLE_MP fmp where fmp.COD_FORMULA_MAESTRA='" + getCodigo() + "' ) and um.COD_UNIDAD_MEDIDA=m1.COD_UNIDAD_MEDIDA and m1.COD_ESTADO_REGISTRO = 1";
            sql += " order by m1.NOMBRE_MATERIAL";
            System.out.println("sql:" + sql);
            setCon(Util.openConnection(getCon()));
            Statement st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(sql);
            rs.last();
            int rows = rs.getRow();
            rs.first();
            for (int i = 0; i < rows; i++) {
                FormulaMaestraDetalleMP bean = new FormulaMaestraDetalleMP();
                bean.setSwNo(false);
                bean.setSwSi(false);
                bean.getMateriales().setCodMaterial(rs.getString(1));
                bean.getMateriales().setNombreMaterial(rs.getString(2));
                bean.getUnidadesMedida().setAbreviatura(rs.getString(3));
                bean.getUnidadesMedida().setCodUnidadMedida(rs.getString(4));
                bean.setCantidad(0);
                String codGrupo = rs.getString(5);
                if (codGrupo.equals("5")) {
                    System.out.println("reactivo");
                    bean.setSwNo(false);
                    bean.setSwSi(true);
                } else {
                    System.out.println("no reactivo");
                    bean.setSwNo(true);
                    bean.setSwSi(false);
                }
                formulaMaestraDetalleMPAdicionarList.add(bean);
                rs.next();
            }
            if (rs != null) {
                rs.close();
                st.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "";
    }

    public void cargarUnidadesMedida(String codigo, FormulaMaestraDetalleMP bean) {
        try {
            setCon(Util.openConnection(getCon()));
            String sql = "select um.COD_UNIDAD_MEDIDA,um.NOMBRE_UNIDAD_MEDIDA  from UNIDADES_MEDIDA um where um.COD_ESTADO_REGISTRO=1";
            ResultSet rs = null;
            unidadesMedidaList.clear();
            Statement st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            if (!codigo.equals("")) {
                sql += " and cod_estado_registro=" + codigo;
                System.out.println("update:" + sql);
                rs = st.executeQuery(sql);
                if (rs.next()) {
                }
            } else {
                unidadesMedidaList.clear();
                rs = st.executeQuery(sql);
                while (rs.next()) {
                    unidadesMedidaList.add(new SelectItem(rs.getString(1), rs.getString(2)));
                }
            }
            if (rs != null) {
                rs.close();
                st.close();
                rs = null;
                st = null;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    ////////////// Guardar ////////////////////////

    public String guardarFormulaMaestraDetalleMP() {
        //managedFormulaMaestra.guardarVersionFormulaMaestra(codigo);
        System.out.println("xxxxxxxxxxxxxxxx:" + getCodigo());
        //System.out.println("area_inferior:"+codigoAreaInferior);
        List formulaMaestraDetalleAnteriorList = this.cargarFormulaMaestraDetalleMP();
        Iterator index = formulaMaestraDetalleMPAdicionarList.iterator();
        String sql = "";
        int result = 0;
        while (index.hasNext()) {
            try {
                FormulaMaestraDetalleMP bean = (FormulaMaestraDetalleMP) index.next();
                if (bean.getChecked().booleanValue()) {
                    setCon(Util.openConnection(getCon()));
                    sql = "insert into FORMULA_MAESTRA_DETALLE_MP(COD_FORMULA_MAESTRA,COD_MATERIAL,COD_UNIDAD_MEDIDA,CANTIDAD, NRO_PREPARACIONES)values(";
                    sql += "'" + getCodigo() + "','" + bean.getMateriales().getCodMaterial() + "','" + bean.getUnidadesMedida().getCodUnidadMedida() + "'," + bean.getCantidad() + "," + bean.getNroPreparaciones() + ")";
                    System.out.println("sql:" + sql);
                    PreparedStatement st1 = getCon().prepareStatement(sql);
                    result = st1.executeUpdate();
                    System.out.println("result:" + result);
                    for (int i = 0; i <= bean.getNroPreparaciones() - 1; i++) {
                        double cantidadFraccion = bean.getCantidad() / bean.getNroPreparaciones();
                        String sql_01 = "insert into  FORMULA_MAESTRA_DETALLE_MP_FRACCIONES (COD_FORMULA_MAESTRA,COD_MATERIAL,COD_FORMULA_MAESTRA_FRACCIONES";
                        sql_01 += ",CANTIDAD) values(" + getCodigo() + "," + bean.getMateriales().getCodMaterial() + "," + i + "," + cantidadFraccion + ")";
                        PreparedStatement st_01 = getCon().prepareStatement(sql_01);
                        result = st_01.executeUpdate();
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        formulaMaestraDetalleMPList =  cargarFormulaMaestraDetalleMP();
        //managedFormulaMaestra.enviarCorreo("446,780,1195,826,1428,1479,2", formulaMaestraDetalleAnteriorList, formulaMaestraDetalleMPList,codigo,"MP");
        return "navegadorFormulaMaestraDetalleMP";
    }
    ////////////// Guardar fracciones ////////////////////////

    public String guardarFormulaMaestraDetalleMPfracciones() {
        Iterator index = fraccionesDetalleMPList.iterator();
        int i = 0;  
        
        while (index.hasNext()) {
            try {
                Statement stmt=null;
                FormulaMaestraDetalleMPfracciones bean = (FormulaMaestraDetalleMPfracciones) index.next();
                setCon(Util.openConnection(getCon()));
                String sql_01="";
                sql_01 = "update FORMULA_MAESTRA_DETALLE_MP_FRACCIONES set CANTIDAD=" + bean.getCantidad()+",cod_tipo_material_produccion='"+bean.getTiposMaterialProduccion().getCodTipoMaterialProduccion()+"' ";
                sql_01 += " where COD_FORMULA_MAESTRA=" + formulaMaestraDetalleMPbean.getFormulaMaestra().getCodFormulaMaestra();
                sql_01 += " and COD_MATERIAL= " + formulaMaestraDetalleMPbean.getMateriales().getCodMaterial();
                sql_01 += " and COD_FORMULA_MAESTRA_FRACCIONES=" + i;
               
                System.out.println("sql:" + sql_01);
                stmt = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                int rows = stmt.executeUpdate(sql_01);
                System.out.println("SQL---->" + bean.getCantidad() +" "+ formulaMaestraDetalleMPbean.getFormulaMaestra().getCodFormulaMaestra()+" "+ formulaMaestraDetalleMPbean.getMateriales().getCodMaterial()+" "+ i );
                i++;
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }// end While
        
        formulaMaestraDetalleMPList= cargarFormulaMaestraDetalleMP();
        return "navegadorFormulaMaestraDetalleMP";
    }

    public String guardarFormulaMaestraDetalleMR() {

        System.out.println("xxxxxxxxxxxxxxxx:" + getCodigo());
        //managedFormulaMaestra.guardarVersionFormulaMaestra(codigo);
        //System.out.println("area_inferior:"+codigoAreaInferior);
        List formulaMaestraDetalleMPReactivoAnteriorList = this.cargarFormulaMaestraDetalleMReactivo();
        Iterator index = formulaMaestraDetalleMPAdicionarList.iterator();
        String sql = "";
        int result = 0;
        while (index.hasNext()) {

            try {
                FormulaMaestraDetalleMP bean = (FormulaMaestraDetalleMP) index.next();
                if (bean.getChecked().booleanValue()) {
                    setCon(Util.openConnection(getCon()));
                    sql = "insert into FORMULA_MAESTRA_DETALLE_MR(COD_FORMULA_MAESTRA,COD_MATERIAL,COD_UNIDAD_MEDIDA,CANTIDAD, NRO_PREPARACIONES,COD_TIPO_MATERIAL,COD_TIPO_ANALISIS_MATERIAL)values(";
                    sql += "'" + getCodigo() + "','" + bean.getMateriales().getCodMaterial() + "','" + bean.getUnidadesMedida().getCodUnidadMedida() + "'," + bean.getCantidad() + "," + bean.getNroPreparaciones() + ", '"+formulaMaestraDetalleMP.getTiposMaterialReactivo().getCodTipoMaterialReactivo()+"','"+formulaMaestraDetalleMP.getTiposAnalisisMaterialReactivo().getCodTiposAnalisisMaterialReactivo()+"')";
                    System.out.println("sql:" + sql);
                    PreparedStatement st1 = getCon().prepareStatement(sql);
                    result = st1.executeUpdate();
                    System.out.println("result:" + result);
                }

            } catch (SQLException e) {
                e.printStackTrace();
            }



        }
        formulaMaestraDetalleMReactivoList=cargarFormulaMaestraDetalleMReactivo();
        //managedFormulaMaestra.enviarCorreo("446,780,1195,826,1428,1479,2",formulaMaestraDetalleMPReactivoAnteriorList,formulaMaestraDetalleMReactivoList,codigo,"MR");
        return "navegadorFormulaMaestraDetalleMR";
    }

    public String guardarEditarFormulaMaestraDetalleMP() {
        System.out.println("xxxxxxxxxxxxxxxx:" + getCodigo());
        //System.out.println("area_inferior:"+codigoAreaInferior);

        List formulaMaestraDetalleAnteriorList = cargarFormulaMaestraDetalleMP();
        //managedFormulaMaestra.guardarVersionFormulaMaestra(codigo);
        Iterator index = formulaMaestraDetalleMPEditarList.iterator();
        String sql = "";
        int result = 0;
        while (index.hasNext()) {
            try {
                FormulaMaestraDetalleMP bean = (FormulaMaestraDetalleMP) index.next();
                double cantidadAux=bean.getCantidad();//.replace(",","");
                bean.setCantidad(cantidadAux);
                setCon(Util.openConnection(getCon()));
                sql = "update FORMULA_MAESTRA_DETALLE_MP set"
                        + " CANTIDAD=" + bean.getCantidad() + ", NRO_PREPARACIONES=" + bean.getNroPreparaciones() + " "
                        + " where COD_FORMULA_MAESTRA='" + codigo + "' and COD_MATERIAL='" + bean.getMateriales().getCodMaterial() + "'";
                
                System.out.println("sql:" + sql);
                Statement st1 = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                result = st1.executeUpdate(sql);
                System.out.println("result:" + result);
                String sql_00 = "delete from FORMULA_MAESTRA_DETALLE_MP_FRACCIONES where COD_FORMULA_MAESTRA=" + getCodigo();
                sql_00 += " and COD_MATERIAL=" + bean.getMateriales().getCodMaterial();
                Statement st_00 = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                result = st_00.executeUpdate(sql_00);
                
                
                // /numCadena.replaceAll(",", ".");
                
                for (int i = 0; i <= bean.getNroPreparaciones() - 1; i++) {
                     double cantidadFraccion = bean.getCantidad() /bean.getNroPreparaciones();
                     
                    String sql_01 = "insert into  FORMULA_MAESTRA_DETALLE_MP_FRACCIONES (COD_FORMULA_MAESTRA,COD_MATERIAL,COD_FORMULA_MAESTRA_FRACCIONES,CANTIDAD) ";
                    sql_01 += "values(" +  getCodigo() + "," + bean.getMateriales().getCodMaterial() + "," + i + "," + cantidadFraccion + ")";
                    System.out.println("sql_01----------------------:"+sql_01);
                    
                    Statement st_01 = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    result = st_01.executeUpdate(sql_01);
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        //formulaMaestraDetalleAnteriorList=formulaMaestraDetalleMPList.subList(0,formulaMaestraDetalleMPList.size());
        //formulaMaestraDetalleAnteriorList = ((List)((ArrayList)formulaMaestraDetalleMPList).clone());
        formulaMaestraDetalleMPList = cargarFormulaMaestraDetalleMP();
        //managedFormulaMaestra.enviarCorreo("1479", formulaMaestraDetalleAnteriorList, formulaMaestraDetalleMPList,codigo,"MP");

        return "navegadorFormulaMaestraDetalleMP";
    }
    public List copiaLista(List formulaMaestraDetalleList){
        List copiaList = new ArrayList();
        Iterator i = formulaMaestraDetalleList.iterator();
        while(i.hasNext()){
            FormulaMaestraDetalleMP formulaMaestraDetalleMP = (FormulaMaestraDetalleMP) i.next();
            FormulaMaestraDetalleMP formulaMaestraDetalleMP1 = new FormulaMaestraDetalleMP();
            formulaMaestraDetalleMP1.setMateriales(formulaMaestraDetalleMP.getMateriales());
            formulaMaestraDetalleMP1.setCantidad(formulaMaestraDetalleMP.getCantidad());
            formulaMaestraDetalleMP1.setUnidadesMedida(formulaMaestraDetalleMP.getUnidadesMedida());
            copiaList.add(formulaMaestraDetalleMP1);
        }
        return copiaList;
    }

    

    public String guardarEditarFormulaMaestraDetalleMR() {

        System.out.println("xxxxxxxxxxxxxxxx:" + getCodigo());
        //managedFormulaMaestra.guardarVersionFormulaMaestra(codigo);
        //System.out.println("area_inferior:"+codigoAreaInferior);
        List formulaMaestraDetalleMPReactivoAnteriorList = this.cargarFormulaMaestraDetalleMReactivo();
        Iterator index = formulaMaestraDetalleMPEditarList.iterator();
        String sql = "";
        int result = 0;
        while (index.hasNext()) {

            try {
                FormulaMaestraDetalleMP bean = (FormulaMaestraDetalleMP) index.next();

                setCon(Util.openConnection(getCon()));
                sql = "update FORMULA_MAESTRA_DETALLE_MR set"
                        + " CANTIDAD=" + bean.getCantidad() + ", NRO_PREPARACIONES=" + bean.getNroPreparaciones() + "," +
                        " COD_TIPO_MATERIAL='"+bean.getTiposMaterialReactivo().getCodTipoMaterialReactivo()+"'," +
                        " COD_TIPO_ANALISIS_MATERIAL='"+bean.getTiposAnalisisMaterialReactivo().getCodTiposAnalisisMaterialReactivo()+"' "
                        + " where COD_FORMULA_MAESTRA='" + codigo + "' and COD_MATERIAL='" + bean.getMateriales().getCodMaterial() + "'";

                System.out.println("sql:" + sql);
                PreparedStatement st1 = getCon().prepareStatement(sql);
                result = st1.executeUpdate();
                System.out.println("result:" + result);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        formulaMaestraDetalleMReactivoList =  cargarFormulaMaestraDetalleMReactivo();
        //managedFormulaMaestra.enviarCorreo("446,780,1195,826,1428,1479,2",formulaMaestraDetalleMPReactivoAnteriorList,formulaMaestraDetalleMReactivoList,codigo,"MR");
        return "navegadorFormulaMaestraDetalleMR";
    }

    public String actionEditar() {
        Iterator index = formulaMaestraDetalleMPList.iterator();
        String sql = "";
        int result = 0;
        formulaMaestraDetalleMPEditarList.clear();
        while (index.hasNext()) {
            FormulaMaestraDetalleMP bean = (FormulaMaestraDetalleMP) index.next();
            if (bean.getChecked().booleanValue()) {
                System.out.println("qwiuweiruweiopru" + bean.getUnidadesMedida().getCodUnidadMedida());                
                formulaMaestraDetalleMPEditarList.add(bean);
            }
        }
        return "actionEditarFormulaMaestraDetalleMP";
    }

    public String actionEditarReactivos() {
        Iterator index = formulaMaestraDetalleMReactivoList.iterator();
        String sql = "";
        int result = 0;
        formulaMaestraDetalleMPEditarList.clear();
        while (index.hasNext()) {
            FormulaMaestraDetalleMP bean = (FormulaMaestraDetalleMP) index.next();
            if (bean.getChecked().booleanValue()) {
                System.out.println("qwiuweiruweiopru" + bean.getUnidadesMedida().getCodUnidadMedida());
                bean.setTiposMaterialReactivoList(tiposMaterialReactivoList);
                bean.setTiposAnalisisMaterialReactivoList(tiposAnalisisMaterialReactivo);
                formulaMaestraDetalleMPEditarList.add(bean);
            }
        }
        return "actionEditarFormulaMaestraDetalleMR";
    }

    public String actionEliminar() {
        Iterator index = formulaMaestraDetalleMPList.iterator();
        String sql = "";
        int result = 0;
        formulaMaestraDetalleMPEliminarList.clear();
        while (index.hasNext()) {
            FormulaMaestraDetalleMP bean = (FormulaMaestraDetalleMP) index.next();
            if (bean.getChecked().booleanValue()) {
                System.out.println("qwiuweiruweiopru" + bean.getUnidadesMedida().getCodUnidadMedida());
                formulaMaestraDetalleMPEliminarList.add(bean);
            }
        }

        return "actionEliminarFormulaMaestraDetalleMP";
    }

    public String actionEliminarReactivos() {
        Iterator index = formulaMaestraDetalleMReactivoList.iterator();
        String sql = "";
        int result = 0;
        formulaMaestraDetalleMPEliminarList.clear();
        while (index.hasNext()) {
            FormulaMaestraDetalleMP bean = (FormulaMaestraDetalleMP) index.next();
            if (bean.getChecked().booleanValue()) {
                System.out.println("qwiuweiruweiopru" + bean.getUnidadesMedida().getCodUnidadMedida());
                formulaMaestraDetalleMPEliminarList.add(bean);
            }
        }
        return "actionEliminarFormulaMaestraDetalleMR";
    }
    public String guardarFormulaMaestraReactivos_action(){
        try {
            Iterator i = formulaMaestraDetalleMReactivoList.iterator();
            String consulta = "  ";
            Connection con = null;
            con = Util.openConnection(con);
            Statement st = con.createStatement();

            while(i.hasNext()){
                FormulaMaestraDetalleMP f = (FormulaMaestraDetalleMP) i.next();
                consulta = " delete from FORMULA_MAESTRA_MR_CLASIFICACION where cod_formula_maestra = '"+f.getFormulaMaestra().getCodFormulaMaestra()+"' and cod_material = '"+f.getMateriales().getCodMaterial()+"' ";
                System.out.println("consulta " + consulta);
                st.executeUpdate(consulta);
                Iterator ii = f.getTiposAnalisisMaterialReactivoList1().iterator();
                while(ii.hasNext()){
                    TiposAnalisisMaterialReactivo t = (TiposAnalisisMaterialReactivo) ii.next();
                    if(t.getChecked()){
                        consulta = " insert into formula_maestra_mr_clasificacion(cod_formula_maestra,cod_material,cod_tipo_analisis_material_reactivo) values('"+f.getFormulaMaestra().getCodFormulaMaestra()+"','"+f.getMateriales().getCodMaterial()+"','"+t.getCodTiposAnalisisMaterialReactivo()+"') ";
                        System.out.println("consulta " + consulta);
                        st.executeUpdate(consulta);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public String guardarEliminarFormulaMaestraDetalleMP() {
        System.out.println("xxxxxxxxxxxxxxxx:" + getCodigo());
        //System.out.println("area_inferior:"+codigoAreaInferior);
        List formulaMaestraDetalleAnteriorList = this.cargarFormulaMaestraDetalleMP();
        //managedFormulaMaestra.guardarVersionFormulaMaestra(codigo);
        Iterator index = formulaMaestraDetalleMPEliminarList.iterator();
        int result  = 0;
        int result1 = 0;
        while (index.hasNext()) {
            try {
                FormulaMaestraDetalleMP bean = (FormulaMaestraDetalleMP) index.next();
                if (bean.getChecked().booleanValue()) {
                    setCon(Util.openConnection(getCon()));

                    String sql_00  = "delete from FORMULA_MAESTRA_DETALLE_MP_FRACCIONES where COD_FORMULA_MAESTRA=" + getCodigo();
                           sql_00 += " and COD_MATERIAL=" + bean.getMateriales().getCodMaterial();
                    Statement stmt = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);       
                    result = stmt.executeUpdate(sql_00);
                    System.out.println("result-------------->:" + result);
                   
                    String sql  = "delete from FORMULA_MAESTRA_DETALLE_MP ";
                           sql += " where COD_FORMULA_MAESTRA='" + codigo + "' and COD_MATERIAL='" + bean.getMateriales().getCodMaterial() + "'";
                    System.out.println("sql Eliminar:" + sql);
                    Statement stmt1 = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);       
                    result1 = stmt1.executeUpdate(sql);
                    System.out.println("result-------------->:" + result1);
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        formulaMaestraDetalleMPList = cargarFormulaMaestraDetalleMP();
        //managedFormulaMaestra.enviarCorreo("446,780,1195,826,1428,1479,2", formulaMaestraDetalleAnteriorList, formulaMaestraDetalleMPList,codigo,"MP");
        return "navegadorFormulaMaestraDetalleMP";
    }

    public String guardarEliminarFormulaMaestraDetalleMR() {
        System.out.println("xxxxxxxxxxxxxxxx:" + getCodigo());
        //System.out.println("area_inferior:"+codigoAreaInferior);
        //managedFormulaMaestra.guardarVersionFormulaMaestra(codigo);
        List formulaMaestraDetalleMPReactivoAnteriorList = this.cargarFormulaMaestraDetalleMReactivo();
        Iterator index = formulaMaestraDetalleMPEliminarList.iterator();
        String sql = "";
        while (index.hasNext()) {
            try {
                FormulaMaestraDetalleMP bean = (FormulaMaestraDetalleMP) index.next();
                if (bean.getChecked().booleanValue()) {
                    setCon(Util.openConnection(getCon()));
                    sql  = "delete from FORMULA_MAESTRA_DETALLE_MR ";
                    sql += " where COD_FORMULA_MAESTRA='" + codigo + "' and COD_MATERIAL='" + bean.getMateriales().getCodMaterial() + "'" +
                            " and COD_TIPO_MATERIAL = '"+formulaMaestraDetalleMP.getTiposMaterialReactivo().getCodTipoMaterialReactivo()+"' and COD_TIPO_ANALISIS_MATERIAL ='"+formulaMaestraDetalleMP.getTiposAnalisisMaterialReactivo().getCodTiposAnalisisMaterialReactivo()+"'";
                    System.out.println("sql Eliminar:" + sql);
                    //PreparedStatement st1 = getCon().prepareStatement(sql);                    
                    Statement stmt = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    int result = stmt.executeUpdate(sql);
                    System.out.println("resultXXXXXXXXXXXXXX--------->>>>:" + result);
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        formulaMaestraDetalleMReactivoList = cargarFormulaMaestraDetalleMReactivo();
        //managedFormulaMaestra.enviarCorreo("446,780,1195,826,1428,1479,2",formulaMaestraDetalleMPReactivoAnteriorList,formulaMaestraDetalleMReactivoList,codigo,"MR");
        return "navegadorFormulaMaestraDetalleMR";
    }

    /**
     * Metodo que cierra la conexion
     */
    public String getCloseConnection() throws SQLException {
        if (getCon() != null) {
            getCon().close();
        }
        return "";
    }
    public String getCargarTiposReactivos(){
        try {
            Connection con = null;
            con = Util.openConnection(con);
            String consulta = " select t.COD_TIPO_REACTIVO,t.NOMBRE_TIPO_REACTIVO from TIPOS_REACTIVOS t ";
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery(consulta);
            tiposReactivosList.clear();
            while(rs.next()){
                TiposReactivos tiposReactivos = new TiposReactivos();
                tiposReactivos.setCodTipoReactivo(rs.getInt("COD_TIPO_REACTIVO"));
                tiposReactivos.setNombreTipoReactivo(rs.getString("NOMBRE_TIPO_REACTIVO"));
                tiposReactivosList.add(tiposReactivos);
            }
            rs.close();
            st.close();
            con.close();
            } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Métodos de la Clase
     */
    public FormulaMaestraDetalleMP getFormulaMaestraDetalleMPbean() {
        return formulaMaestraDetalleMPbean;
    }

    public void setFormulaMaestraDetalleMPbean(FormulaMaestraDetalleMP formulaMaestraDetalleMPbean) {
        this.formulaMaestraDetalleMPbean = formulaMaestraDetalleMPbean;
    }

    public List getFormulaMaestraDetalleMPList() {
        return formulaMaestraDetalleMPList;
    }

    public void setFormulaMaestraDetalleMPList(List formulaMaestraDetalleMPList) {
        this.formulaMaestraDetalleMPList = formulaMaestraDetalleMPList;
    }

    public List getFormulaMaestraDetalleMPEliminarList() {
        return formulaMaestraDetalleMPEliminarList;
    }

    public void setFormulaMaestraDetalleMPEliminarList(List formulaMaestraDetalleMPEliminarList) {
        this.formulaMaestraDetalleMPEliminarList = formulaMaestraDetalleMPEliminarList;
    }

    public List getFormulaMaestraDetalleMPEditarList() {
        return formulaMaestraDetalleMPEditarList;
    }

    public void setFormulaMaestraDetalleMPEditarList(List formulaMaestraDetalleMPEditarList) {
        this.formulaMaestraDetalleMPEditarList = formulaMaestraDetalleMPEditarList;
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

    public List getFormulaMaestraDetalleMPAdicionarList() {
        return formulaMaestraDetalleMPAdicionarList;
    }

    public void setFormulaMaestraDetalleMPAdicionarList(List formulaMaestraDetalleMPAdicionarList) {
        this.formulaMaestraDetalleMPAdicionarList = formulaMaestraDetalleMPAdicionarList;
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

    public String getNombreComProd() {
        return nombreComProd;
    }

    public void setNombreComProd(String nombreComProd) {
        this.nombreComProd = nombreComProd;
    }

    public List getFormulaMaestraDetalleMReactivoList() {
        return formulaMaestraDetalleMReactivoList;
    }

    public void setFormulaMaestraDetalleMReactivoList(List formulaMaestraDetalleMReactivoList) {
        this.formulaMaestraDetalleMReactivoList = formulaMaestraDetalleMReactivoList;
    }

    /**
     * @return the fraccionesDetalleMPList
     */
    public List getFraccionesDetalleMPList() {
        return fraccionesDetalleMPList;
    }

    /**
     * @param fraccionesDetalleMPList the fraccionesDetalleMPList to set
     */
    public void setFraccionesDetalleMPList(List fraccionesDetalleMPList) {
        this.fraccionesDetalleMPList = fraccionesDetalleMPList;
    }

    public List getTiposMaterialReactivoList() {
        return tiposMaterialReactivoList;
    }

    public void setTiposMaterialReactivoList(List tiposMaterialReactivoList) {
        this.tiposMaterialReactivoList = tiposMaterialReactivoList;
    }

    public FormulaMaestraDetalleMP getFormulaMaestraDetalleMP() {
        return formulaMaestraDetalleMP;
    }

    public void setFormulaMaestraDetalleMP(FormulaMaestraDetalleMP formulaMaestraDetalleMP) {
        this.formulaMaestraDetalleMP = formulaMaestraDetalleMP;
    }

    public ManagedFormulaMaestra getManagedFormulaMaestra() {
        return managedFormulaMaestra;
    }

    public void setManagedFormulaMaestra(ManagedFormulaMaestra managedFormulaMaestra) {
        this.managedFormulaMaestra = managedFormulaMaestra;
    }

    public List getTiposReactivosList() {
        return tiposReactivosList;
    }

    public void setTiposReactivosList(List tiposReactivosList) {
        this.tiposReactivosList = tiposReactivosList;
    }

    public List getTiposAnalisisMaterialReactivo() {
        return tiposAnalisisMaterialReactivo;
    }

    public void setTiposAnalisisMaterialReactivo(List tiposAnalisisMaterialReactivo) {
        this.tiposAnalisisMaterialReactivo = tiposAnalisisMaterialReactivo;
    }
    
    
}
