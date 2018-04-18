/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.web;

import com.cofar.bean.FormulaMaestraDetalleEP;
import com.cofar.bean.FormulaMaestraDetalleES;
import com.cofar.util.Util;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import com.cofar.bean.FormulaMaestraVersion;
import com.cofar.bean.FormulaMaestraDetalleMP;
import com.cofar.bean.FormulaMaestraDetalleMPfracciones;
import com.cofar.bean.FormulaMaestraEP;
import com.cofar.bean.FormulaMaestraES;
import javax.faces.model.SelectItem;
import org.richfaces.component.html.HtmlDataTable;
/**
 *
 * @author sistemas1
 */

public class ManagedFormulaMaestraVersion {
    Connection con = null;
    List formulaMaestraList = new ArrayList();
    List formulaMaestraVersionList = new ArrayList();

    HtmlDataTable formulaMaestraVersionDataTable = new HtmlDataTable();
    List formulaMaestraDetalleMPList = new ArrayList();
    HtmlDataTable formulaMaestraDataTable = new HtmlDataTable();
    FormulaMaestraVersion formulaMaestraSeleccionada = new FormulaMaestraVersion();
    List formulaMaestraDetalleMReactivoList = new ArrayList();
    List formulaMaestraEPList = new ArrayList();
    List formulaMaestraESList = new ArrayList();
    List formulaMaestraDetalleEPList = new ArrayList();
    HtmlDataTable formulaMaestraEPDataTable = new HtmlDataTable();
    HtmlDataTable formulaMaestraESDataTable = new HtmlDataTable();
    List formulaMaestraDetalleESList = new ArrayList();
    
    /** Creates a new instance of ManagedFormulaMaestraVersion */
    public ManagedFormulaMaestraVersion() {
    }

    public List getFormulaMaestraList() {
        return formulaMaestraList;
    }

    public void setFormulaMaestraList(List formulaMaestraList) {
        this.formulaMaestraList = formulaMaestraList;
    }

    public String getCargarFormulaMaestraVersion(){
        this.cargarFormulaMaestra();
        return null;
    }

    public HtmlDataTable getFormulaMaestraVersionDataTable() {
        return formulaMaestraVersionDataTable;
    }

    public void setFormulaMaestraVersionDataTable(HtmlDataTable formulaMaestraVersionDataTable) {
        this.formulaMaestraVersionDataTable = formulaMaestraVersionDataTable;
    }

    public List getFormulaMaestraVersionList() {
        return formulaMaestraVersionList;
    }

    public void setFormulaMaestraVersionList(List formulaMaestraVersionList) {
        this.formulaMaestraVersionList = formulaMaestraVersionList;
    }

    public HtmlDataTable getFormulaMaestraDataTable() {
        return formulaMaestraDataTable;
    }

    public void setFormulaMaestraDataTable(HtmlDataTable formulaMaestraDataTable) {
        this.formulaMaestraDataTable = formulaMaestraDataTable;
    }

    public List getFormulaMaestraDetalleMPList() {
        return formulaMaestraDetalleMPList;
    }

    public void setFormulaMaestraDetalleMPList(List formulaMaestraDetalleMPList) {
        this.formulaMaestraDetalleMPList = formulaMaestraDetalleMPList;
    }

    public FormulaMaestraVersion getFormulaMaestraSeleccionada() {
        return formulaMaestraSeleccionada;
    }

    public void setFormulaMaestraSeleccionada(FormulaMaestraVersion formulaMaestraSeleccionada) {
        this.formulaMaestraSeleccionada = formulaMaestraSeleccionada;
    }

    public List getFormulaMaestraDetalleMReactivoList() {
        return formulaMaestraDetalleMReactivoList;
    }

    public void setFormulaMaestraDetalleMReactivoList(List formulaMaestraDetalleMReactivoList) {
        this.formulaMaestraDetalleMReactivoList = formulaMaestraDetalleMReactivoList;
    }

    public List getFormulaMaestraEPList() {
        return formulaMaestraEPList;
    }

    public void setFormulaMaestraEPList(List formulaMaestraEPList) {
        this.formulaMaestraEPList = formulaMaestraEPList;
    }

    public List getFormulaMaestraESList() {
        return formulaMaestraESList;
    }

    public void setFormulaMaestraESList(List formulaMaestraESList) {
        this.formulaMaestraESList = formulaMaestraESList;
    }

    public HtmlDataTable getFormulaMaestraEPDataTable() {
        return formulaMaestraEPDataTable;
    }

    public void setFormulaMaestraEPDataTable(HtmlDataTable formulaMaestraEPDataTable) {
        this.formulaMaestraEPDataTable = formulaMaestraEPDataTable;
    }

    public HtmlDataTable getFormulaMaestraESDataTable() {
        return formulaMaestraESDataTable;
    }

    public void setFormulaMaestraESDataTable(HtmlDataTable formulaMaestraESDataTable) {
        this.formulaMaestraESDataTable = formulaMaestraESDataTable;
    }

    public List getFormulaMaestraDetalleEPList() {
        return formulaMaestraDetalleEPList;
    }

    public void setFormulaMaestraDetalleEPList(List formulaMaestraDetalleEPList) {
        this.formulaMaestraDetalleEPList = formulaMaestraDetalleEPList;
    }

    public List getFormulaMaestraDetalleESList() {
        return formulaMaestraDetalleESList;
    }

    public void setFormulaMaestraDetalleESList(List formulaMaestraDetalleESList) {
        this.formulaMaestraDetalleESList = formulaMaestraDetalleESList;
    }


    

    
    
    public void cargarFormulaMaestra() {
        try {
            String sql = "select distinct fm.cod_formula_maestra,fm.cod_compprod,fm.cantidad_lote,fm.estado_sistema,";
            sql += " cp.COD_ESTADO_COMPPROD,er.NOMBRE_ESTADO_COMPPROD,cp.nombre_prod_semiterminado";
            sql += " from formula_maestra fm, ESTADOS_COMPPROD er, componentes_prod cp,FORMULA_MAESTRA_VERSION fmv  ";
            sql += " WHERE fm.estado_sistema=1 and fm.cod_compprod=cp.cod_compprod and cp.COD_ESTADO_COMPPROD=er.COD_ESTADO_COMPPROD" +
                   " and fm.COD_FORMULA_MAESTRA = fmv.COD_FORMULA_MAESTRA ";
            sql += " order by cp.nombre_prod_semiterminado asc";
            
            System.out.println("sql:" + sql);
            con=Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(sql);
            formulaMaestraList.clear();
            while(rs.next()){
                FormulaMaestraVersion formulaMaestraItem = new FormulaMaestraVersion();
                formulaMaestraItem.setCodFormulaMaestra(rs.getString("cod_formula_maestra"));
                formulaMaestraItem.getComponentesProd().setCodCompprod(rs.getString("cod_compprod"));
                formulaMaestraItem.setCantidadLote(rs.getDouble("cantidad_lote"));
                formulaMaestraItem.getEstadoRegistro().setCodEstadoRegistro(rs.getString("COD_ESTADO_COMPPROD"));
                formulaMaestraItem.getEstadoRegistro().setNombreEstadoRegistro(rs.getString("NOMBRE_ESTADO_COMPPROD"));
                formulaMaestraItem.getComponentesProd().setNombreProdSemiterminado(rs.getString("nombre_prod_semiterminado"));
                formulaMaestraList.add(formulaMaestraItem);
            }

            if (rs != null) {
                rs.close();
                st.close();
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    public List cargarVersiones(String codFormulaMaestra){
        List versionesList = new ArrayList();
        try {
            String consulta = " SELECT FM.COD_VERSION,FM.NRO_VERSION " +
                    " from FORMULA_MAESTRA_VERSION FM WHERE FM.COD_FORMULA_MAESTRA = '"+codFormulaMaestra+"' ";
            con=Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(consulta);
            versionesList.clear();
            while(rs.next()){
                versionesList.add(new SelectItem(rs.getString("COD_VERSION"), rs.getString("NRO_VERSION")));
            }
            
            if (rs != null) {
                rs.close();
                st.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return versionesList;
    }
    public String verFormulaMaestraVersion_action(){
        try {
            formulaMaestraSeleccionada = (FormulaMaestraVersion)formulaMaestraDataTable.getRowData();
            
            String sql = "select fm.NRO_VERSION,fm.cod_formula_maestra,fm.cod_compprod,fm.cantidad_lote,fm.estado_sistema, " +
                    " cp.COD_ESTADO_COMPPROD,er.NOMBRE_ESTADO_COMPPROD,cp.nombre_prod_semiterminado " +
                    " from FORMULA_MAESTRA_VERSION fm, ESTADOS_COMPPROD er, COMPONENTES_PROD_VERSION cp " +
                    " WHERE fm.estado_sistema=1  and fm.cod_compprod=cp.cod_compprod  " +
                    " and cp.COD_ESTADO_COMPPROD=er.COD_ESTADO_COMPPROD " +
                    " and fm.cod_formula_maestra = "+ formulaMaestraSeleccionada.getCodFormulaMaestra()  +
                    " order by cp.nombre_prod_semiterminado,fm.NRO_VERSION asc ";

            sql= " select fm.cod_version,fm.NRO_VERSION,fm.cod_formula_maestra,fm.cod_compprod,fm.cantidad_lote,fm.estado_sistema,  cp.COD_ESTADO_COMPPROD,er.NOMBRE_ESTADO_COMPPROD," +
                    " cp.nombre_prod_semiterminado from FORMULA_MAESTRA_VERSION fm, ESTADOS_COMPPROD_VERSION er, COMPONENTES_PROD_VERSION cp   " +
                    " WHERE fm.estado_sistema=1 and fm.cod_compprod=cp.cod_compprod    and cp.COD_ESTADO_COMPPROD=er.COD_ESTADO_COMPPROD " +
                    " and fm.cod_formula_maestra = "+formulaMaestraSeleccionada.getCodFormulaMaestra()+"  " +
                    " and fm.COD_VERSION = cp.COD_VERSION " +
                    " and cp.COD_VERSION = er.COD_VERSION " +
                    " order by fm.NRO_VERSION ,cp.nombre_prod_semiterminado asc  ";

            
            System.out.println("sql:" + sql);
            con=Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(sql);
            formulaMaestraVersionList.clear();
            while(rs.next()){
                FormulaMaestraVersion formulaMaestraVersionItem = new FormulaMaestraVersion();
                formulaMaestraVersionItem.setCodVersion(rs.getInt("cod_version"));
                formulaMaestraVersionItem.setNroVersion(rs.getInt("NRO_VERSION"));
                formulaMaestraVersionItem.setCodFormulaMaestra(rs.getString("cod_formula_maestra"));
                formulaMaestraVersionItem.getComponentesProd().setCodCompprod(rs.getString("cod_compprod"));
                formulaMaestraVersionItem.setCantidadLote(rs.getDouble("cantidad_lote"));
                formulaMaestraVersionItem.getEstadoRegistro().setCodEstadoRegistro(rs.getString("COD_ESTADO_COMPPROD"));
                formulaMaestraVersionItem.getEstadoRegistro().setNombreEstadoRegistro(rs.getString("NOMBRE_ESTADO_COMPPROD"));
                formulaMaestraVersionItem.getComponentesProd().setNombreProdSemiterminado(rs.getString("nombre_prod_semiterminado"));
                formulaMaestraVersionList.add(formulaMaestraVersionItem);
            }
            
            if (rs != null) {
                rs.close();
                st.close();
            }


        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public String seleccionarFormulaMaestraVersion_action(){
        try{
            
            FormulaMaestraVersion formulaMaestraVersion = (FormulaMaestraVersion)formulaMaestraVersionDataTable.getRowData();
            formulaMaestraSeleccionada.setCodVersion(formulaMaestraVersion.getCodVersion());
            formulaMaestraSeleccionada.setNroVersion(formulaMaestraVersion.getNroVersion());
            

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    

    public String verFormulaMaestraDetalleMP_action() {
        try {
            formulaMaestraSeleccionada = (FormulaMaestraVersion)formulaMaestraDataTable.getRowData();
            

            String sql = "select fm.COD_FORMULA_MAESTRA,m.NOMBRE_MATERIAL,ROUND(fmp.CANTIDAD,2),um.NOMBRE_UNIDAD_MEDIDA,m.cod_material, fmp.nro_preparaciones,m.cod_grupo ";
            sql += " from FORMULA_MAESTRA fm,MATERIALES m,UNIDADES_MEDIDA um,FORMULA_MAESTRA_DETALLE_MP fmp";
            sql += " where fm.COD_FORMULA_MAESTRA=fmp.COD_FORMULA_MAESTRA and um.COD_UNIDAD_MEDIDA=fmp.COD_UNIDAD_MEDIDA";
            sql += " and m.COD_MATERIAL=fmp.COD_MATERIAL ";
            sql += " and fmp.COD_MATERIAL IN(select m1.COD_MATERIAL from MATERIALES m1,grupos g where g.COD_GRUPO=m1.COD_GRUPO";
            sql += " and g.COD_CAPITULO=2) and fm.COD_FORMULA_MAESTRA='" + formulaMaestraSeleccionada.getCodFormulaMaestra() + "'";
            sql += " order by m.NOMBRE_MATERIAL";

            sql= " select fm.COD_FORMULA_MAESTRA,m.NOMBRE_MATERIAL,ROUND(fmp.CANTIDAD,2),um.NOMBRE_UNIDAD_MEDIDA,m.cod_material, fmp.nro_preparaciones,m.cod_grupo  " +
                 " from FORMULA_MAESTRA_VERSION fm,MATERIALES_VERSION m,UNIDADES_MEDIDA_VERSION um,FORMULA_MAESTRA_DETALLE_MP_VERSION fmp " +
                 " where fm.COD_FORMULA_MAESTRA=fmp.COD_FORMULA_MAESTRA and um.COD_UNIDAD_MEDIDA=fmp.COD_UNIDAD_MEDIDA " +
                 " and m.COD_MATERIAL=fmp.COD_MATERIAL  and fmp.COD_MATERIAL IN(select m1.COD_MATERIAL from MATERIALES m1,grupos g where g.COD_GRUPO=m1.COD_GRUPO " +
                 " and g.COD_CAPITULO=2) and fm.COD_FORMULA_MAESTRA='" + formulaMaestraSeleccionada.getCodFormulaMaestra() + "' " +
                 " and fm.COD_VERSION = fmp.COD_VERSION " +
                 " and fmp.COD_VERSION = m.COD_VERSION " +
                 " and m.COD_VERSION = um.COD_VERSION " +                 
                 " AND fm.COD_VERSION = '"+formulaMaestraSeleccionada.getCodVersion()+"' " +
                 " order by m.NOMBRE_MATERIAL ";            

            System.out.println("sql formula detalle:  " + sql);
            con =Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(sql);
            formulaMaestraDetalleMPList.clear();
            while(rs.next()){
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
                String codGrupo = rs.getString(7);
                if (codGrupo.equals("5")) {
                    //System.out.println("reactivo");
                    bean.setSwNo(false);
                    bean.setSwSi(true);
                } else {
                    //System.out.println("no reactivo");
                    bean.setSwNo(true);
                    bean.setSwSi(false);
                }
                String sql_00 = "select ROUND(ff.CANTIDAD,2) from FORMULA_MAESTRA_DETALLE_MP_FRACCIONES_VERSION ff where ff.COD_FORMULA_MAESTRA=" + bean.getFormulaMaestra().getCodFormulaMaestra();
                sql_00 += " and ff.COD_MATERIAL=" + bean.getMateriales().getCodMaterial() + " " +
                        " and ff.COD_VERSION = '"+formulaMaestraSeleccionada.getCodVersion()+"' ";
                System.out.println("sql_00...........:"+sql_00);
                Statement st_00 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rs_00 = st_00.executeQuery(sql_00);
                List arrayAux = new ArrayList();
                while (rs_00.next()) {
                    FormulaMaestraDetalleMPfracciones val = new FormulaMaestraDetalleMPfracciones();
                    val.setCantidad(rs_00.getDouble(1));
                    arrayAux.add(val);
                }
                bean.setFraccionesDetalleList(arrayAux);
                formulaMaestraDetalleMPList.add(bean);
                
            }
            
            if (rs != null) {
                rs.close();
                st.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    public double redondear(double numero, int decimales) {
        return Math.round(numero * Math.pow(10, decimales)) / Math.pow(10, decimales);
    }

    public String verFormulaMaestraDetalleMReactivo() {
        try {
            formulaMaestraSeleccionada = (FormulaMaestraVersion)formulaMaestraDataTable.getRowData();
            String sql = "select fm.COD_FORMULA_MAESTRA,m.NOMBRE_MATERIAL,fmp.CANTIDAD,um.NOMBRE_UNIDAD_MEDIDA,m.cod_material, fmp.nro_preparaciones,m.cod_grupo ";
            sql += " from FORMULA_MAESTRA fm,MATERIALES m,UNIDADES_MEDIDA um,FORMULA_MAESTRA_DETALLE_MR fmp";
            sql += " where fm.COD_FORMULA_MAESTRA=fmp.COD_FORMULA_MAESTRA and um.COD_UNIDAD_MEDIDA=fmp.COD_UNIDAD_MEDIDA";
            sql += " and m.COD_MATERIAL=fmp.COD_MATERIAL ";
            sql += " and fmp.COD_MATERIAL IN(select m1.COD_MATERIAL from MATERIALES m1,grupos g where g.COD_GRUPO=m1.COD_GRUPO";
            sql += " and g.COD_CAPITULO=2 ) and fm.COD_FORMULA_MAESTRA='" + formulaMaestraSeleccionada.getCodFormulaMaestra() + "' ";
            sql += " order by m.NOMBRE_MATERIAL";
            
            sql = " select fm.COD_FORMULA_MAESTRA,m.NOMBRE_MATERIAL,fmp.CANTIDAD,um.NOMBRE_UNIDAD_MEDIDA,m.cod_material, fmp.nro_preparaciones,m.cod_grupo " +
                    " from FORMULA_MAESTRA_VERSION fm,MATERIALES_VERSION m,UNIDADES_MEDIDA_VERSION um,FORMULA_MAESTRA_DETALLE_MR_VERSION fmp " +
                    " where fm.COD_FORMULA_MAESTRA=fmp.COD_FORMULA_MAESTRA  " +
                    " and um.COD_UNIDAD_MEDIDA=fmp.COD_UNIDAD_MEDIDA " +
                    " and m.COD_MATERIAL=fmp.COD_MATERIAL   " +
                    " and fmp.COD_MATERIAL IN(select m1.COD_MATERIAL from MATERIALES_VERSION m1,grupos g where g.COD_GRUPO=m1.COD_GRUPO " +
                    " and g.COD_CAPITULO=2 and m1.COD_VERSION = fmp.COD_VERSION)  " +
                    " and fm.COD_FORMULA_MAESTRA="+formulaMaestraSeleccionada.getCodFormulaMaestra()+" " +
                    " and fm.COD_VERSION = "+formulaMaestraSeleccionada.getCodVersion()+" " +
                    " and fm.COD_VERSION = fmp.COD_VERSION " +
                    " and fmp.COD_VERSION = m.COD_VERSION " +
                    " and um.COD_VERSION = fmp.COD_VERSION " +
                    " order by m.NOMBRE_MATERIAL " ;
            

            System.out.println("sql formula reactivo detalle:  " + sql);
            con=Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(sql);
            rs.last();
            int rows = rs.getRow();
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
                bean.setNroPreparaciones(rs.getInt(6));
                String codGrupo = rs.getString(7);
                if (codGrupo.equals("5")) {
                    System.out.println("reactivo");
                } else {
                    System.out.println("no reactivo");
                }
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
        return null;
    }
    public String verFormulaMaestraEP_action() {
        try {
            formulaMaestraSeleccionada = (FormulaMaestraVersion)formulaMaestraDataTable.getRowData();
            String sql = " select fep.COD_FORMULA_MAESTRA,ep.nombre_envaseprim,ep.cod_envaseprim,pp.CANTIDAD,pp.cod_presentacion_primaria";
            sql+= " from FORMULA_MAESTRA fep,PRESENTACIONES_PRIMARIAS pp,ENVASES_PRIMARIOS ep";
            sql+= " where PP.COD_COMPPROD=fep.COD_COMPPROD AND fep.COD_FORMULA_MAESTRA='"+formulaMaestraSeleccionada.getCodFormulaMaestra()+"'";
            sql+= " and ep.cod_envaseprim=pp.cod_envaseprim";
            sql+= " order by ep.nombre_envaseprim";
            
            sql = "  select fep.COD_FORMULA_MAESTRA,ep.nombre_envaseprim,ep.cod_envaseprim,pp.CANTIDAD,pp.cod_presentacion_primaria " +
                    " from FORMULA_MAESTRA_VERSION fep,PRESENTACIONES_PRIMARIAS_VERSION pp,ENVASES_PRIMARIOS_VERSION ep " +
                    " where PP.COD_COMPPROD=fep.COD_COMPPROD  " +
                    " and ep.cod_envaseprim=pp.cod_envaseprim " +
                    " and fep.COD_VERSION = pp.COD_VERSION " +
                    " and ep.COD_VERSION = pp.COD_VERSION " +
                    " and fep.COD_VERSION = "+formulaMaestraSeleccionada.getCodVersion()+" " +
                    " AND fep.COD_FORMULA_MAESTRA='"+formulaMaestraSeleccionada.getCodFormulaMaestra()+"' " +
                    " order by ep.nombre_envaseprim  "; 

            System.out.println("sql mm:"+sql);
            con=Util.openConnection(con);
            Statement st = con.createStatement(1004, 1007);
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
        return null;
    }

    public String verFormulaMaestraES_action(){
        try {
            formulaMaestraSeleccionada = (FormulaMaestraVersion)formulaMaestraDataTable.getRowData();

            String sql = " select es.NOMBRE_ENVASESEC,es.COD_ENVASESEC,pp.NOMBRE_PRODUCTO_PRESENTACION, " +
                    " pp.cantidad_presentacion ,pp.cod_presentacion   " +
                    " from FORMULA_MAESTRA_VERSION fm   " +
                    " inner join COMPONENTES_PROD_VERSION cp on cp.COD_COMPPROD = fm.COD_COMPPROD " +
                    " and fm.COD_VERSION = cp.COD_VERSION  " +
                    " inner join COMPONENTES_PRESPROD_VERSION c on c.COD_COMPPROD = cp.COD_COMPPROD  " +
                    " and c.COD_VERSION = cp.COD_VERSION " +
                    " inner join PRESENTACIONES_PRODUCTO_VERSION pp on pp.cod_presentacion = c.COD_PRESENTACION " +
                    " and pp.COD_VERSION = c.COD_VERSION  " +
                    " inner join ENVASES_SECUNDARIOS es on es.COD_ENVASESEC = pp.COD_ENVASESEC  " +
                    " where fm.COD_FORMULA_MAESTRA = '"+formulaMaestraSeleccionada.getCodFormulaMaestra()+"' " +
                    " and fm.COD_VERSION = '"+formulaMaestraSeleccionada.getCodVersion() +"'";
            
            System.out.println("sql>"+sql);
            con= Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
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
        return null;
    }

    public String verFormulaMaestraDetalleEP_action(){
        try {
            FormulaMaestraEP formulaMaestraEP = (FormulaMaestraEP)formulaMaestraEPDataTable.getRowData();
            
            String sql="select fm.COD_FORMULA_MAESTRA,m.NOMBRE_MATERIAL,fmp.CANTIDAD,um.NOMBRE_UNIDAD_MEDIDA,m.cod_material";
            sql+=" from FORMULA_MAESTRA fm,MATERIALES m,UNIDADES_MEDIDA um,FORMULA_MAESTRA_DETALLE_EP fmp";
            sql+=" where fm.COD_FORMULA_MAESTRA=fmp.COD_FORMULA_MAESTRA and um.COD_UNIDAD_MEDIDA=fmp.COD_UNIDAD_MEDIDA";
            sql+=" and m.COD_MATERIAL=fmp.COD_MATERIAL ";
            sql+=" and fmp.COD_MATERIAL IN(select m1.COD_MATERIAL from MATERIALES m1,grupos g where g.COD_GRUPO=m1.COD_GRUPO";
            sql+=" and g.COD_CAPITULO=3) and fmp.COD_FORMULA_MAESTRA='"+formulaMaestraSeleccionada.getCodFormulaMaestra()+"' and fmp.COD_PRESENTACION_PRIMARIA='"+formulaMaestraEP.getPresentacionesPrimarias().getCodPresentacionPrimaria()+"'";
            sql+=" order by m.NOMBRE_MATERIAL";
            System.out.println("sql>"+sql);
            con=Util.openConnection(con);

            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
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
        return null;
    }


    public void verFormulaMaestraDetalleES_action(){
        try {
            FormulaMaestraES formulaMaestraES = (FormulaMaestraES)formulaMaestraESDataTable.getRowData();
            
            String sql="select fm.COD_FORMULA_MAESTRA,m.NOMBRE_MATERIAL,fmp.CANTIDAD,um.NOMBRE_UNIDAD_MEDIDA,m.cod_material";
            sql+=" from FORMULA_MAESTRA fm,MATERIALES m,UNIDADES_MEDIDA um,FORMULA_MAESTRA_DETALLE_ES fmp";
            sql+=" where fm.COD_FORMULA_MAESTRA=fmp.COD_FORMULA_MAESTRA and um.COD_UNIDAD_MEDIDA=fmp.COD_UNIDAD_MEDIDA";
            sql+=" and m.COD_MATERIAL=fmp.COD_MATERIAL ";
            sql+=" and fmp.COD_MATERIAL IN(select m1.COD_MATERIAL from MATERIALES m1,grupos g where g.COD_GRUPO=m1.COD_GRUPO";
            sql+=" and g.COD_CAPITULO IN (4,8)) and fm.COD_FORMULA_MAESTRA='"+formulaMaestraSeleccionada.getCodFormulaMaestra()+"' and fmp.cod_presentacion_producto='"+formulaMaestraES.getPresentacionesProducto().getCodPresentacion()+"'";
            sql+=" order by m.NOMBRE_MATERIAL";
            System.out.println("sql>"+sql);
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
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
    }


}
