/*
 * ManagedTipoCliente.java
 * Created on 19 de febrero de 2008, 16:50
 */
package com.cofar.web;

import com.cofar.bean.ActividadesFormulaMaestra;
import com.cofar.bean.FormulaMaestra;
import com.cofar.bean.FormulaMaestraDetalleEP;
import com.cofar.bean.FormulaMaestraDetalleES;
import com.cofar.bean.FormulaMaestraDetalleMP;
import com.cofar.bean.MaquinariaActividadesFormula;
import com.cofar.bean.FormulaMaestraDetalleMPfracciones;import com.cofar.bean.ProgramaProduccion;
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
import java.util.Map;
import java.util.Properties;
import javax.faces.context.ExternalContext;
import javax.faces.context.FacesContext;
import javax.faces.event.ValueChangeEvent;
import javax.faces.model.SelectItem;
import javax.mail.Message;
import javax.mail.Session;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import org.richfaces.component.html.HtmlDataTable;

/**
 *
 *  @author Wilmer Manzaneda Chavez
 *  @company COFAR
 */
public class ManagedFormulaMaestra {

    /** Creates a new instance of ManagedTipoCliente */
    private FormulaMaestra formulaMaestrabean = new FormulaMaestra();
    private FormulaMaestra formulaMaestrabeanReferencia = new FormulaMaestra(); //para guardar los datos antes de actualizar
    private List componentesProd = new ArrayList();
    private List<FormulaMaestra> formulaMaestraList = new ArrayList<FormulaMaestra>();
    private List formulaMaestraEliminar = new ArrayList();
    private List formulaMaestraNoEliminar = new ArrayList();
    private List areasEmpresaList = new ArrayList();
    private Connection con;
    private int cantidadeliminar = 0;
    private String codigo = "";
    private List lista = new ArrayList();
    private List estadoRegistro = new ArrayList();
    private boolean swEliminaSi;
    private boolean swEliminaNo;
    HtmlDataTable formulaMaestraDataTable = new HtmlDataTable();
    FormulaMaestra formulaMaestra = new FormulaMaestra();
    String codAreaEmpresaPersonal="";
    private List<SelectItem> tiposProduccionList=new ArrayList<SelectItem>();
    private ActividadesFormulaMaestra actividadesFormulaMaestraBean=new ActividadesFormulaMaestra();
    private List<SelectItem> areasActividadesList=new ArrayList<SelectItem>();
    private String codAreaEmpresaActividad="";
    private List<SelectItem> actividadesList=new ArrayList<SelectItem>();
    private MaquinariaActividadesFormula maquinariaActividadesFormula= new MaquinariaActividadesFormula();
    private List<MaquinariaActividadesFormula> maquinariaActividadesFormulasList= new ArrayList<MaquinariaActividadesFormula>();
    private String mensaje="";

    private FormulaMaestra formulaMaestraSeleccionado = new FormulaMaestra();
    private FormulaMaestra formulaMaestraCopia = new FormulaMaestra();
    private List formulaMaestraCopiaList = new ArrayList();
    private List<FormulaMaestra> formulaMaestrasProduccionList=null;
    private HtmlDataTable formulasMaestrasProduccionDataTable=new HtmlDataTable();
    private FormulaMaestra formulaMaestraBuscar= new FormulaMaestra();
    private List<SelectItem> areasEmpresaProduccionSelectList=new ArrayList<SelectItem>();
    //<editor-fold defaultstate="collapsed" desc="variables Duplicar Tamañio Lote">
    private FormulaMaestra formulaMaestraDuplicarLote=null;
    private double cantidadNuevoLote=0;
    //</editor-fold>
    //<editor-fold defaultstate="collapsed" desc="funciones Duplicar Tamañio Lote">
    public String seleccionFormulaMaestraDuplicar()
    {
        for(FormulaMaestra bean:formulaMaestraList)
        {
            if(bean.getChecked())
            {
                formulaMaestraDuplicarLote=bean;
            }
        }
        return null;
    }
    public String guardarCrearNuevoTamanioLoteFMDesarrollo()throws SQLException
    {
        mensaje="";
        try
        {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res;
            int codFormulaMaestra=0;
            String consulta="INSERT INTO FORMULA_MAESTRA(COD_COMPPROD, CANTIDAD_LOTE"+
                     " , ESTADO_SISTEMA, COD_ESTADO_REGISTRO) "+
                     " select f.COD_COMPPROD, '"+cantidadNuevoLote+"',1,1"+
                     " from FORMULA_MAESTRA f where f.COD_FORMULA_MAESTRA='"+formulaMaestraDuplicarLote.getCodFormulaMaestra()+"'";
            PreparedStatement pst = con.prepareStatement(consulta,PreparedStatement.RETURN_GENERATED_KEYS);
            if (pst.executeUpdate() > 0)System.out.println("se registro la nueva formula");
            res=pst.getGeneratedKeys();
            if(res.next())codFormulaMaestra=res.getInt(1);
            consulta="INSERT INTO FORMULA_MAESTRA_DETALLE_MP(COD_FORMULA_MAESTRA, COD_MATERIAL,CANTIDAD, COD_UNIDAD_MEDIDA, NRO_PREPARACIONES)"+
                     " select '"+codFormulaMaestra+"',f.COD_MATERIAL,(f.CANTIDAD*"+(cantidadNuevoLote/formulaMaestraDuplicarLote.getCantidadLote())+"),f.COD_UNIDAD_MEDIDA,"+
                     " f.NRO_PREPARACIONES"+
                     " from FORMULA_MAESTRA_DETALLE_MP f where f.COD_FORMULA_MAESTRA='"+formulaMaestraDuplicarLote.getCodFormulaMaestra()+"'";
            System.out.println("consulta duplicar mp "+consulta);
            pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se duplico mp");
            consulta="INSERT INTO FORMULA_MAESTRA_DETALLE_MP_FRACCIONES(COD_FORMULA_MAESTRA,COD_MATERIAL, COD_FORMULA_MAESTRA_FRACCIONES, CANTIDAD,"+
                     " COD_TIPO_MATERIAL_PRODUCCION)"+
                     " select '"+codFormulaMaestra+"',f.COD_MATERIAL,f.COD_FORMULA_MAESTRA_FRACCIONES,f.CANTIDAD*"+(cantidadNuevoLote/formulaMaestraDuplicarLote.getCantidadLote())+"" +
                     " ,f.COD_TIPO_MATERIAL_PRODUCCION"+
                     " from FORMULA_MAESTRA_DETALLE_MP_FRACCIONES f where f.COD_FORMULA_MAESTRA='"+formulaMaestraDuplicarLote.getCodFormulaMaestra()+"'";
            System.out.println("consulta duplicar mp fracciones "+consulta);
            pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se duplico mp fracciones");
            consulta="INSERT INTO FORMULA_MAESTRA_DETALLE_EP(COD_FORMULA_MAESTRA,"+
                     " COD_PRESENTACION_PRIMARIA, COD_MATERIAL, CANTIDAD, COD_UNIDAD_MEDIDA)"+
                     " select '"+codFormulaMaestra+"',f.COD_PRESENTACION_PRIMARIA,f.COD_MATERIAL,f.CANTIDAD*"+(cantidadNuevoLote/formulaMaestraDuplicarLote.getCantidadLote())+",f.COD_UNIDAD_MEDIDA"+
                     " from FORMULA_MAESTRA_DETALLE_EP f where f.COD_FORMULA_MAESTRA='"+formulaMaestraDuplicarLote.getCodFormulaMaestra()+"'";
            System.out.println("consulta duplicar lote ep"+consulta);
            pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se duplico ep");
            con.commit();
            mensaje="1";
            pst.close();
            con.close();
        }
        catch (SQLException ex)
        {
            con.rollback();
            con.close();
            mensaje="Ocurrio un error al momento de duplicar el tamaño del lote, intente de nuevo";
            ex.printStackTrace();
        }
        this.cargarFormulaMaestra();
        return null;
    }
    public String guardarFormulaMaestra() {

        try {
            String sql = "insert into formula_maestra(cod_compprod,cantidad_lote,estado_sistema,cod_estado_registro)values";
            sql += "(" + formulaMaestrabean.getComponentesProd().getCodCompprod();
            sql += "," + formulaMaestrabean.getCantidadLote() + ",1,1)";
            System.out.println("insert:" + sql);
            setCon(Util.openConnection(getCon()));
            PreparedStatement st = getCon().prepareStatement(sql);
            int result = st.executeUpdate();
            if (result > 0) {
                cargarFormulaMaestra();
                FormulaMaestra formulaMaestrabean = new FormulaMaestra();
            }
            System.out.println("result:" + result);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        FormulaMaestra formulaMaestrabean = new FormulaMaestra();
        System.out.println("paso por aqui");
        return "navegadorFormulaMaestra";
    }
    //</editor-fold>
    private void cargarAreasEmpresaSelectList()
    {
        try {
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            String consulta = "select ae.COD_AREA_EMPRESA,ae.NOMBRE_AREA_EMPRESA "+
                              " from AREAS_EMPRESA ae where ae.COD_AREA_EMPRESA in (80,81,82,95) order by ae.NOMBRE_AREA_EMPRESA";
            ResultSet res = st.executeQuery(consulta);
            areasEmpresaProduccionSelectList.clear();
            while (res.next())
            {
                areasEmpresaProduccionSelectList.add(new SelectItem(res.getString("COD_AREA_EMPRESA"),res.getString("NOMBRE_AREA_EMPRESA")));
            }
            res.close();
            st.close();
            con.close();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }
    public String getCargarFormulasMaestrasProduccion()
    {
        this.cargarAreasEmpresaSelectList();
        this.cargarFormulasMaestrasProduccion();
        return null;
    }
    public String buscarFormulaMaestraProduccion()
    {
        this.cargarFormulasMaestrasProduccion();
        return null;
    }
    private void cargarFormulasMaestrasProduccion()
    {
        try {
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            String consulta = "select fm.cod_formula_maestra,fm.cod_compprod,fm.cantidad_lote,fm.estado_sistema,tp.COD_TIPO_PRODUCCION,tp.NOMBRE_TIPO_PRODUCCION,"+
                              " cp.COD_ESTADO_COMPPROD,ec.NOMBRE_ESTADO_COMPPROD,cp.nombre_prod_semiterminado,"+
                              " er.cod_estado_registro,er.nombre_estado_registro,version.NRO_VERSION,version.FECHA_INICIO_VIGENCIA"+
                              " from FORMULA_MAESTRA fm inner join COMPONENTES_PROD cp on"+
                              " fm.COD_COMPPROD=cp.COD_COMPPROD left outer join ESTADOS_COMPPROD ec on"+
                              " ec.COD_ESTADO_COMPPROD=cp.COD_ESTADO_COMPPROD"+
                              " left outer join ESTADOS_REFERENCIALES er on er.COD_ESTADO_REGISTRO=fm.COD_ESTADO_REGISTRO" +
                              " left outer join TIPOS_PRODUCCION tp on tp.COD_TIPO_PRODUCCION=cp.COD_TIPO_PRODUCCION"+
                              " outer APPLY(select fmv.NRO_VERSION,fmv.FECHA_INICIO_VIGENCIA from FORMULA_MAESTRA_VERSION fmv where fmv.COD_FORMULA_MAESTRA=fm.COD_FORMULA_MAESTRA"+
                              " and fmv.COD_ESTADO_VERSION_FORMULA_MAESTRA=2 and fm.COD_COMPPROD=fmv.COD_COMPPROD) version"+
                              " where cp.COD_TIPO_PRODUCCION=1"+
                              (formulaMaestraBuscar.getEstadoRegistro().getCodEstadoRegistro().equals("0")?"":" and fm.COD_ESTADO_REGISTRO='"+formulaMaestraBuscar.getEstadoRegistro().getCodEstadoRegistro()+"'" )+
                              (formulaMaestraBuscar.getComponentesProd().getAreasEmpresa().getCodAreaEmpresa().equals("0")?"":" and cp.cod_area_empresa='"+formulaMaestraBuscar.getComponentesProd().getAreasEmpresa().getCodAreaEmpresa()+"'")+
                              " order by cp.nombre_prod_semiterminado";
            System.out.println("consulta cargar formulas "+consulta);
            ResultSet res = st.executeQuery(consulta);
            formulaMaestrasProduccionList=new ArrayList<FormulaMaestra>();
            while (res.next()) {
                FormulaMaestra nuevo=new FormulaMaestra();
                nuevo.setCodFormulaMaestra(res.getString("cod_formula_maestra"));
                nuevo.getComponentesProd().setCodCompprod(res.getString("cod_compprod"));
                nuevo.setCantidadLote(res.getDouble("cantidad_lote"));
                nuevo.getEstadoRegistro().setCodEstadoRegistro(res.getString("cod_estado_registro"));
                nuevo.getEstadoRegistro().setNombreEstadoRegistro(res.getString("nombre_estado_registro"));
                nuevo.getComponentesProd().setNombreProdSemiterminado(res.getString("nombre_prod_semiterminado"));
                nuevo.getComponentesProd().getTipoProduccion().setCodTipoProduccion(res.getInt("COD_TIPO_PRODUCCION"));
                nuevo.getComponentesProd().getTipoProduccion().setNombreTipoProduccion(res.getString("NOMBRE_TIPO_PRODUCCION"));
                nuevo.setNroVersionFormulaActiva(res.getInt("NRO_VERSION"));
                nuevo.setFechaInicioVigenciaFormulaActiva(res.getTimestamp("FECHA_INICIO_VIGENCIA"));
                formulaMaestrasProduccionList.add(nuevo);
            }
            res.close();
            st.close();
            con.close();
        }
        catch (SQLException ex) {
            ex.printStackTrace();
        }
    }
    public String verVersionesFormulaMaestra(){
        try {
            formulaMaestra = (FormulaMaestra)formulasMaestrasProduccionDataTable.getRowData();
            FacesContext facesContext = FacesContext.getCurrentInstance();
            ExternalContext externalContext = facesContext.getExternalContext();
            Map map = externalContext.getSessionMap();
            map.put("formulaMaestra",formulaMaestra);
            ManagedProgramaProduccion managedProgramaProduccion = new ManagedProgramaProduccion();
            managedProgramaProduccion.redireccionar("../formullaMaestraVersiones/navegadorVersionesFormulaMaestra.jsf");


        } catch (Exception e) {
        }
        return null;
    }
    public String copiarFormulaMaestra_action(){
        try {
            Connection con = null;
            con = Util.openConnection(con);
            Statement st = con.createStatement();

            String consulta = " delete from formula_maestra_detalle_mr where cod_formula_maestra = '"+formulaMaestraCopia.getCodFormulaMaestra()+"' ";
            System.out.println("consulta " + consulta);
            st.executeUpdate(consulta);
            consulta = "insert into formula_maestra_detalle_mr" +
                    " select '"+formulaMaestraCopia.getCodFormulaMaestra()+"',cod_material,cantidad,cod_unidad_medida,nro_preparaciones,cod_tipo_material,cod_tipo_analisis_material from formula_maestra_detalle_mr where cod_formula_maestra = '"+formulaMaestraSeleccionado.getCodFormulaMaestra()+"'";
            System.out.println("consulta " + consulta);
            st.executeUpdate(consulta);
            
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }



    
    
    

    public ManagedFormulaMaestra() {

        cargarFormulaMaestra();
        formulaMaestraBuscar.getEstadoRegistro().setCodEstadoRegistro("1");
        formulaMaestraBuscar.getComponentesProd().getAreasEmpresa().setCodAreaEmpresa("0");
    }
    
    
     public String inactivarMaquinariasAction()throws SQLException
    {
         mensaje="";
         Connection con1=null;
        try
        {
            String consulta="update MAQUINARIA_ACTIVIDADES_FORMULA set COD_ESTADO_REGISTRO=2"+
                            " WHERE COD_MAQUINARIA_ACTIVIDAD IN("+
                            " select maf.COD_MAQUINARIA_ACTIVIDAD"+
                            " from ACTIVIDADES_FORMULA_MAESTRA afm"+
                            " inner join FORMULA_MAESTRA fm on afm.COD_FORMULA_MAESTRA ="+
                            " fm.COD_FORMULA_MAESTRA inner join COMPONENTES_PROD cp on fm.COD_ESTADO_REGISTRO = 1 and"+
                            " fm.COD_COMPPROD = cp.COD_COMPPROD inner JOIN"+
                            " MAQUINARIA_ACTIVIDADES_FORMULA maf on "+
                            " maf.COD_ACTIVIDAD_FORMULA=afm.COD_ACTIVIDAD_FORMULA"+
                            " where "+(formulaMaestrabean.getComponentesProd().getAreasEmpresa().getCodAreaEmpresa().equals("0")?"":"cp.COD_AREA_EMPRESA = '"+formulaMaestrabean.getComponentesProd().getAreasEmpresa().getCodAreaEmpresa()+"' and")+
                            " afm.COD_ACTIVIDAD = '"+maquinariaActividadesFormula.getActividadesFormulaMaestra().getActividadesProduccion().getCodActividad()+"'"+
                            " and maf.COD_MAQUINA='"+maquinariaActividadesFormula.getMaquinaria().getCodMaquina()+"')";
            System.out.println("consulta update "+consulta);
            
            con1=Util.openConnection(con1);
            con1.setAutoCommit(false);
            PreparedStatement pst=con1.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se actualizo de manera general");
            con1.commit();
            mensaje="1";
            pst.close();
            con1.close();
        }
        catch(SQLException ex)
        {
            mensaje="Ocurrio un error al momento de inactivar la maquinaria,intente de nuevo";
            con1.close();
            ex.printStackTrace();

        }
        return null;
    }
     public String activarMaquinariasAction()throws SQLException
    {
         mensaje="";
         Connection con1=null;
        try
        {
            String consulta="update MAQUINARIA_ACTIVIDADES_FORMULA set COD_ESTADO_REGISTRO=1"+
                            " WHERE COD_MAQUINARIA_ACTIVIDAD IN("+
                            " select maf.COD_MAQUINARIA_ACTIVIDAD"+
                            " from ACTIVIDADES_FORMULA_MAESTRA afm"+
                            " inner join FORMULA_MAESTRA fm on afm.COD_FORMULA_MAESTRA ="+
                            " fm.COD_FORMULA_MAESTRA inner join COMPONENTES_PROD cp on fm.COD_ESTADO_REGISTRO = 1 and"+
                            " fm.COD_COMPPROD = cp.COD_COMPPROD inner JOIN"+
                            " MAQUINARIA_ACTIVIDADES_FORMULA maf on "+
                            " maf.COD_ACTIVIDAD_FORMULA=afm.COD_ACTIVIDAD_FORMULA"+
                            " where "+(formulaMaestrabean.getComponentesProd().getAreasEmpresa().getCodAreaEmpresa().equals("0")?"":"cp.COD_AREA_EMPRESA = '"+formulaMaestrabean.getComponentesProd().getAreasEmpresa().getCodAreaEmpresa()+"' and")+
                            " afm.COD_ACTIVIDAD = '"+maquinariaActividadesFormula.getActividadesFormulaMaestra().getActividadesProduccion().getCodActividad()+"'"+
                            " and maf.COD_MAQUINA='"+maquinariaActividadesFormula.getMaquinaria().getCodMaquina()+"')";
            System.out.println("consulta update "+consulta);

            con1=Util.openConnection(con1);
            con1.setAutoCommit(false);
            PreparedStatement pst=con1.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se actualizo de manera general");
            con1.commit();
            mensaje="1";
            pst.close();
            con1.close();
        }
        catch(SQLException ex)
        {
            mensaje="Ocurrio un error al momento de inactivar la maquinaria,intente de nuevo";
            con1.close();
            ex.printStackTrace();

        }
        return null;
    }
   
    public String inactivarActividadGeneral_action()throws SQLException
    {
        Connection con1=null;
        mensaje="";
        try
        {
            
            con1=Util.openConnection(con1);
            con1.setAutoCommit(false);
            String consulta="update ACTIVIDADES_FORMULA_MAESTRA set COD_ESTADO_REGISTRO=2 "+
                            " where COD_ACTIVIDAD='"+actividadesFormulaMaestraBean.getActividadesProduccion().getCodActividad()+"'"+
                            (actividadesFormulaMaestraBean.getFormulaMaestra().getComponentesProd().getAreasEmpresa().getCodAreaEmpresa().equals("")||actividadesFormulaMaestraBean.getFormulaMaestra().getComponentesProd().getAreasEmpresa().getCodAreaEmpresa().equals("0")?"":
                             " and COD_FORMULA_MAESTRA in (select fm.COD_FORMULA_MAESTRA from FORMULA_MAESTRA fm inner join COMPONENTES_PROD cp on fm.COD_COMPPROD=cp.COD_COMPPROD and  cp.COD_AREA_EMPRESA='"+actividadesFormulaMaestraBean.getFormulaMaestra().getComponentesProd().getAreasEmpresa().getCodAreaEmpresa()+"')")+
                             (codAreaEmpresaActividad.equals("")||codAreaEmpresaActividad.equals("0")?"":"and COD_AREA_EMPRESA='"+codAreaEmpresaActividad+"'");
            System.out.println(" consulta update general "+consulta);
            PreparedStatement pst=con1.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println(" se inactivo la actividade general");
            con1.commit();
            mensaje="1";
            pst.close();
            con1.close();
        }
        catch(SQLException ex)
        {
            mensaje="Ocurrio un error al momento de inactivar la maquinaria,intente de nuevo";
            con1.rollback();
            con1.close();
            
            ex.printStackTrace();
        }
        return null;
    }
    
    
    
    
    public String getObtenerCodigo() {

        //String cod=Util.getParameter("codigo");
        
        this.cargarTiposProduccion();
        this.obtenerCodAreaPersonal();
        formulaMaestraList.clear();
        cargarFormulaMaestra();
        this.cargarProductosDesarrolloAgregar();
        //this.tiposProduccion_change();
        return "";
    }

    public void cargarEstadoRegistro(String codigo, FormulaMaestra bean) {
        try {
            setCon(Util.openConnection(getCon()));
            String sql = "select ecp.COD_ESTADO_COMPPROD, ecp.NOMBRE_ESTADO_COMPPROD from ESTADOS_COMPPROD ecp where ecp.COD_ESTADO_REGISTRO = 1";
            ResultSet rs = null;

            Statement st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            if (!codigo.equals("")) {
                sql += " and cod_estado_registro=" + codigo;
                System.out.println("update:" + sql);
                rs = st.executeQuery(sql);
                if (rs.next()) {
                    bean.getEstadoRegistro().setCodEstadoRegistro(rs.getString(1));
                    bean.getEstadoRegistro().setNombreEstadoRegistro(rs.getString(2));
                }
            } else {
                getEstadoRegistro().clear();
                rs = st.executeQuery(sql);
                while (rs.next()) {
                    getEstadoRegistro().add(new SelectItem(rs.getString(1), rs.getString(2)));
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

    public String getCodigoCliente() {
        String codigo = "1";
        try {
            setCon(Util.openConnection(getCon()));
            String sql = "select max(cod_formula_maestra)+1 from formula_maestra";
            PreparedStatement st = getCon().prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                codigo = rs.getString(1);
            }
            if (codigo == null) {
                codigo = "1";
            }

            getFormulaMaestrabean().setCodFormulaMaestra(codigo);
            cargarProductosDesarrolloAgregar();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "";
    }
    private void cargarFormulasMaestras()
    {
        try {
            ManagedAccesoSistema usuario=(ManagedAccesoSistema)Util.getSession("ManagedAccesoSistema");
            System.out.println(" el tipo produccion " + getFormulaMaestrabean().getComponentesProd().getTipoProduccion().getCodTipoProduccion());
            String sql = "select fm.cod_formula_maestra,fm.cod_compprod,fm.cantidad_lote,fm.estado_sistema,";
            sql += " cp.COD_ESTADO_COMPPROD,er.NOMBRE_ESTADO_COMPPROD,cp.nombre_prod_semiterminado,e.cod_estado_registro,e.nombre_estado_registro" +
                    " ,tp.COD_TIPO_PRODUCCION,tp.NOMBRE_TIPO_PRODUCCION " +
                    " ,(select max(fmv.NRO_VERSION) from FORMULA_MAESTRA_VERSION fmv where fmv.COD_FORMULA_MAESTRA=fm.COD_FORMULA_MAESTRA"+
                    " and fmv.COD_ESTADO_VERSION_FORMULA_MAESTRA=2) as nroVersion";
            sql += " from formula_maestra fm, ESTADOS_COMPPROD er, componentes_prod cp,estados_referenciales e,TIPOS_PRODUCCION tp";
            sql += " WHERE cp.COD_TIPO_PRODUCCION=tp.COD_TIPO_PRODUCCION and fm.estado_sistema=1 and fm.cod_compprod=cp.cod_compprod" +
                    " and cp.COD_ESTADO_COMPPROD=er.COD_ESTADO_COMPPROD and e.cod_estado_registro = fm.cod_estado_registro" +
                 (formulaMaestrabean.getComponentesProd().getNombreProdSemiterminado().equals("")?"":" and cp.nombre_prod_semiterminado LIKE '%"+formulaMaestrabean.getComponentesProd().getNombreProdSemiterminado()+"%'");
            if (!getFormulaMaestrabean().getEstadoRegistro().getCodEstadoRegistro().equals("") && !getFormulaMaestrabean().getEstadoRegistro().getCodEstadoRegistro().equals("3")) {
                sql += " AND fm.cod_estado_registro=" + getFormulaMaestrabean().getEstadoRegistro().getCodEstadoRegistro();
            }
            if (!getFormulaMaestrabean().getComponentesProd().getAreasEmpresa().getCodAreaEmpresa().equals("") && !getFormulaMaestrabean().getComponentesProd().getAreasEmpresa().getCodAreaEmpresa().equals("0")) {
                sql += " and cp.cod_area_empresa=" + getFormulaMaestrabean().getComponentesProd().getAreasEmpresa().getCodAreaEmpresa();
            }
            sql+=" and cp.COD_TIPO_PRODUCCION=2";
            sql += " order by cp.nombre_prod_semiterminado asc";
            System.out.println("sql:" + sql);
            setCon(Util.openConnection(getCon()));
            Statement st = getCon().createStatement(
                    ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(sql);
            rs.last();
            int rows = rs.getRow();
            formulaMaestraList.clear();
            rs.first();
            String cod = "";
            for (int i = 0; i < rows; i++) {
                FormulaMaestra bean = new FormulaMaestra();
                bean.setNroVersionFormulaActiva(rs.getInt("nroVersion"));
                bean.setCodFormulaMaestra(rs.getString(1));
                bean.getComponentesProd().setCodCompprod(rs.getString(2));
                double cantidad = rs.getDouble(3);
                cantidad = redondear(cantidad, 3);
                NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
                DecimalFormat form = (DecimalFormat) nf;
                form.applyPattern("#,#00.0#");
                bean.setCantidadLote(cantidad);
                bean.getEstadoRegistro().setCodEstadoRegistro(rs.getString("cod_estado_registro"));
                bean.getEstadoRegistro().setNombreEstadoRegistro(rs.getString("nombre_estado_registro"));
                bean.getComponentesProd().setNombreProdSemiterminado(rs.getString(7));
                bean.getComponentesProd().getTipoProduccion().setCodTipoProduccion(rs.getInt("COD_TIPO_PRODUCCION"));
                bean.getComponentesProd().getTipoProduccion().setNombreTipoProduccion(rs.getString("NOMBRE_TIPO_PRODUCCION"));
                formulaMaestraList.add(bean);
                rs.next();
            }

            if (rs != null) {
                rs.close();
                st.close();
            }
            cargarAreasEmpresa("", null);


        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public void cargarFormulaMaestra()
    {
        this.cargarFormulasMaestras();
    }
    public String buscarFormulaMaestra_action()
    {
        this.cargarFormulasMaestras();
        return null;
    }
   public double redondear(double numero, int decimales) {
        return Math.round(numero * Math.pow(10, decimales)) / Math.pow(10, decimales);
    }

    public void cargarComponentesProd() {
        try {
            String sql = "select c.cod_compprod,c.nombre_prod_semiterminado" +
                    " from componentes_prod c,productos p" +
                    " where p.cod_prod=c.cod_prod and p.cod_estado_prod=1 " +
                    (getFormulaMaestrabean().getComponentesProd().getTipoProduccion().getCodTipoProduccion()!=0?
                    " and c.COD_TIPO_PRODUCCION='"+getFormulaMaestrabean().getComponentesProd().getTipoProduccion().getCodTipoProduccion()+"'":"")+
                    " order by nombre_prod_semiterminado asc";
            System.out.println("sql:" + sql);
            setCon(Util.openConnection(getCon()));
            Statement st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(sql);
            rs.last();
            int rows = rs.getRow();
            getComponentesProd().clear();
            rs.first();
            String cod = "";
            for (int i = 0; i < rows; i++) {
                //ComponentesProd bean=new ComponentesProd();
                //bean.setCodCompprod(rs.getString(1));
                //bean.setNombreProdSemiterminado(rs.getString(2));
                //componentesProd.add(bean);
                String nomCompProd=rs.getString(2);
                if(nomCompProd==null){
                    nomCompProd="";
                }
                componentesProd.add(new SelectItem(rs.getString(1), nomCompProd));
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
    private void cargarProductosDesarrolloAgregar()
    {
        try {
           Connection con =null;
           con=Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            String consulta = "select c.COD_COMPPROD,c.nombre_prod_semiterminado from COMPONENTES_PROD c where c.COD_TIPO_PRODUCCION=2 order by c.nombre_prod_semiterminado";
            componentesProd.clear();
            ResultSet res = st.executeQuery(consulta);
            while (res.next()) 
            {
                componentesProd.add(new SelectItem(res.getString("COD_COMPPROD"),res.getString("nombre_prod_semiterminado")));
            }
            res.close();
            st.close();
            con.close();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }
    public String actionEditar() {
        System.out.println("Entro Editar");
        cargarEstadoRegistro("", null);
        cargarComponentesProd();
        Iterator i = getFormulaMaestraList().iterator();
        while (i.hasNext()) {
            FormulaMaestra bean = (FormulaMaestra) i.next();
            if (bean.getChecked().booleanValue()) {
                formulaMaestrabean = bean;
                //formulaMaestrabean.setCantidadLote(formulaMaestrabean.getCantidadLote().replace(",",""));
                //guardado de datos de referencia para actualizar de acuerdo a esos datos
                formulaMaestrabeanReferencia.getComponentesProd().setCodCompprod(bean.getComponentesProd().getCodCompprod());
                formulaMaestrabeanReferencia.setCodFormulaMaestra(bean.getCodFormulaMaestra());
                
                //areasempresabean.getEstadoReferencial().setCodEstadoRegistro(bean.getCodEstadoRegistro());
                break;
            }
        }
        System.out.println("Entro Editar:" + formulaMaestrabean.getCodFormulaMaestra());
        return "actionEditarFormulaMaestra";
    }
    public String editarEstadoFormulaMaestra_action() {
        cargarEstadoRegistro("", null);
        Iterator i = getFormulaMaestraList().iterator();
        while (i.hasNext()) {
            FormulaMaestra bean = (FormulaMaestra) i.next();
            if (bean.getChecked().booleanValue()) {
                formulaMaestrabean = bean;
                break;
            }
        }
        return null;
    }
    public String guardarEstadoFormulaMaestra_action(){
        try {
            Connection con = null;
            con = Util.openConnection(con);
            Statement st = con.createStatement();
            String consulta = " update formula_maestra set cod_estado_registro = '"+formulaMaestrabean.getEstadoRegistro().getCodEstadoRegistro()+"' " +
                    " where cod_formula_maestra = '"+formulaMaestrabean.getCodFormulaMaestra()+"'  ";
            System.out.println("consulta " + consulta);
            st.executeUpdate(consulta);
            st.close();
            con.close();
            Util.redireccionar("navegador_formula_maestra.jsf");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }


    public void cargarAreasEmpresa(String codigo, FormulaMaestra bean) {
        try {
            setCon(Util.openConnection(getCon()));
            String sql = "select a.cod_area_empresa, a.nombre_area_empresa from areas_empresa a where a.cod_area_empresa " +
                    " in (select cod_area_fabricacion from areas_fabricacion) order by a.nombre_area_empresa";
            System.out.println(" sql:" + sql);
            ResultSet rs = null;

            Statement st = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            if (!codigo.equals("")) {
            } else {
                areasEmpresaList.clear();
                rs = st.executeQuery(sql);
                areasEmpresaList.add(new SelectItem("0", "Seleccione una Opción"));
                while (rs.next()) {
                    areasEmpresaList.add(new SelectItem(rs.getString(1), rs.getString(2)));
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

    

    public String modificarFormulaMaestra() {
         try{
//              setCon(Util.openConnection(getCon()));
//            String consulta = " update componentes_prod set COD_ESTADO_COMPPROD="+getFormulaMaestrabean().getEstadoRegistro().getCodEstadoRegistro()+" where COD_COMPPROD = "+getFormulaMaestrabean().getComponentesProd().getCodCompprod()+" ";
//            System.out.println(" consulta de actualizacion de componente: " +  consulta);
//            PreparedStatement st = getCon().prepareStatement(consulta);
//            st.executeUpdate();

        }catch(Exception e){
            e.printStackTrace();
        }


        try {
            setCon(Util.openConnection(getCon()));
            //actualizar la formula maestra
            String sql = "update formula_maestra set";
            //      sql+=" cod_filial='"+getAreasempresabean().getFiliales().getCodFilial()+"',";
            sql += " cod_compprod=" + getFormulaMaestrabean().getComponentesProd().getCodCompprod() + ",";
            sql += " cantidad_lote=" + getFormulaMaestrabean().getCantidadLote() + ",";
            sql += " cod_estado_registro=" + getFormulaMaestrabean().getEstadoRegistro().getCodEstadoRegistro() + "";
            sql += " where cod_formula_maestra=" + getFormulaMaestrabean().getCodFormulaMaestra();
            PreparedStatement st = getCon().prepareStatement(sql);
            //actualizar el estado de componente

            System.out.println("entro Modificar Formula Maestra : "+ sql);
            int result = st.executeUpdate();
            if (result > 0) {
                cargarFormulaMaestra();
                FormulaMaestra formulaMaestrabean = new FormulaMaestra();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
       

        cargarFormulaMaestra();
        return "navegadorFormulaMaestra";
    }

    public String Cancelar() {
        formulaMaestraList.clear();
        cargarFormulaMaestra();
        return "navegadorFormulaMaestra";
    }

public String eliminarFormulaMaestra() {
    
        try {
            con = Util.openConnection(con);
            Iterator i = formulaMaestraList.iterator();
            int result = 0;
            while (i.hasNext()) {
                FormulaMaestra bean = (FormulaMaestra) i.next();
                if (bean.getChecked().booleanValue()) {
//                    this.guardarVersionFormulaMaestra(bean,bean.getCodFormulaMaestra());
                    String sql = " delete from formula_maestra  ";
                    sql += " where cod_formula_maestra=" + bean.getCodFormulaMaestra();
                    System.out.println("deleteformula_maestra:sql:" + sql);                    
                    Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);                    
                    result = result + st.executeUpdate(sql);
                    
                    sql += " delete from formula_maestra_detalle_es  ";
                    sql += " where cod_formula_maestra=" + bean.getCodFormulaMaestra();
                    System.out.println("formula_maestra_ep:sql:" + sql);
                    st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    result = result + st.executeUpdate(sql);
                    
                    sql += " delete from formula_maestra_detalle_ep ";
                    sql += " where cod_formula_maestra=" + bean.getCodFormulaMaestra();
                    System.out.println("formula_maestra_detalle_ep:sql:" + sql);
                    st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    result = result + st.executeUpdate(sql);
                    
                    sql += " delete from formula_maestra_detalle_mp ";
                    sql += " where cod_formula_maestra=" + bean.getCodFormulaMaestra();
                    System.out.println("formula_maestra_detalle_mp:sql:" + sql);
                    st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);                    
                    result = result + st.executeUpdate(sql);
                    
                    sql += " delete from formula_maestra_detalle_mprom ";
                    sql += " where cod_formula_maestra=" + bean.getCodFormulaMaestra();
                    System.out.println("formula_maestra_detalle_mprom:sql:" + sql);
                    st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    result = result + st.executeUpdate(sql);
                    
                    sql += " delete from FORMULA_MAESTRA_DETALLE_MP_FRACCIONES";
                    sql += " where cod_formula_maestra=" + bean.getCodFormulaMaestra();
                    System.out.println("formula_maestra_detalle_mprom:sql:" + sql);
                    st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    result = result + st.executeUpdate(sql);
                    
                    
              
                }
            }
            cargarFormulaMaestra();
            

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
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

    public String actionagregar() {
        System.out.println("klfsdaf");
        cargarComponentesProd();
        FormulaMaestra formulaMaestrabean = new FormulaMaestra();
        return "actionAgregarFormulaMaestra";

    }

    /**********ESTADO REGISTRO****************/
    public void changeEvent(ValueChangeEvent event) {
        System.out.println("event:" + event.getNewValue());
        formulaMaestrabean.getEstadoRegistro().setCodEstadoRegistro(event.getNewValue().toString());
        cargarFormulaMaestra();
    }

    public void changeEvent1(ValueChangeEvent event) {
        System.out.println("event1:" + event.getNewValue());
        formulaMaestrabean.getComponentesProd().getAreasEmpresa().setCodAreaEmpresa(event.getNewValue().toString());
        cargarFormulaMaestra();
    }
    public String enviarCorreo(String[] codPersonal,List formulaMaestraDetalleAnteriorList,List formulaMaestraDetalleActualList,String codFormulaMaestra,String formulaMaestra){
         try {
             ManagedAccesoSistema bean1 = (ManagedAccesoSistema) Util.getSessionBean("ManagedAccesoSistema");
             //String consulta = " select nombre_correopersonal from correo_personal c where c.cod_personal in ("+ codPersonal +") ";
             //System.out.println("consulta " + consulta);
             //Connection con = null;
             //con = Util.openConnection(con);
             //Statement st = con.createStatement();
             //ResultSet rs = st.executeQuery(consulta);
             System.out.println(codPersonal.length);
             InternetAddress emails[] = new InternetAddress[codPersonal.length]; //codPersonal.length
             int i1 = 0;
             //System.out.println("entro 1");
             //System.out.println("entro 1");
             for(int i = 0;i<codPersonal.length;i++){
                 //System.out.println("entro 2");
                 //System.out.println("entro 2");rs.getString("nombre_correopersonal")
                 //System.out.println("email  " + codPersonal[i] );
                 emails[i]=new InternetAddress(codPersonal[i]);
                 //System.out.println("entro x");
             }
             if(codPersonal.length==0){return null;}
             Properties props = new Properties();
             props.put("mail.smtp.host", "mail.cofar.com.bo");
             props.put("mail.transport.protocol", "smtp");
             props.put("mail.smtp.auth", "false");
             props.setProperty("mail.user", "traspasos@cofar.com.bo");
             props.setProperty("mail.password", "n3td4t4");
             Session mailSession = Session.getInstance(props, null);
             Message msg = new MimeMessage(mailSession);
             msg.setSubject("Formula Maestra");
             msg.setFrom(new InternetAddress("traspasos@cofar.com.bo", "Formula Maestra"));
             msg.addRecipients(Message.RecipientType.TO, emails);
             FormulaMaestra formulaMaestra1 = this.obtieneFormulaMaestra(codFormulaMaestra);
             String contenido = " <html> " +
                     " <head>  <title></title> " +
                     " <meta http-equiv='Content-Type' content='text/html; charset=windows-1252'> " +
                     " </head> " +
                     " <body> "+
                     " <br/> La formula Maestra "+formulaMaestra+" de "+formulaMaestra1.getComponentesProd().getNombreProdSemiterminado()+" : <br/><br/> " +
                     " <table  style='font-family: Arial;border: 1px solid black'> ";
                     contenido = contenido +" <tbody><tr><td>Material<td><td>Cantidad</td><td>Unidad Medida</td><td>estado Material</td></tr> ";
                     Iterator i = formulaMaestraDetalleAnteriorList.iterator();
                     if(formulaMaestra.equals("MP")||formulaMaestra.equals("MR")){
                     while(i.hasNext()){
                         FormulaMaestraDetalleMP formulaMaestraDetalleMP = (FormulaMaestraDetalleMP)i.next();
                     contenido = contenido + " <tr><td>"+formulaMaestraDetalleMP.getMateriales().getNombreMaterial()+"<td>" +
                             " <td>"+formulaMaestraDetalleMP.getCantidad()+"</td><td>"+formulaMaestraDetalleMP.getUnidadesMedida().getNombreUnidadMedida()+"</td>" +
                             " <td>"+formulaMaestraDetalleMP.getMateriales().getEstadoRegistro().getNombreEstadoRegistro()+"</td></tr> " ;
                     }
                     }
                     if(formulaMaestra.equals("EP")){
                     while(i.hasNext()){
                         FormulaMaestraDetalleEP formulaMaestraDetalleEP = (FormulaMaestraDetalleEP)i.next();
                     contenido = contenido + " <tr><td>"+formulaMaestraDetalleEP.getMateriales().getNombreMaterial()+"<td>" +
                             " <td>"+formulaMaestraDetalleEP.getCantidad()+"</td><td>"+formulaMaestraDetalleEP.getUnidadesMedida().getNombreUnidadMedida()+"</td>" +
                             " <td>"+formulaMaestraDetalleEP.getMateriales().getEstadoRegistro().getNombreEstadoRegistro()+"</td></tr> " ;
                     }
                     }
                     if(formulaMaestra.equals("ES")){
                     while(i.hasNext()){
                         FormulaMaestraDetalleES formulaMaestraDetalleES = (FormulaMaestraDetalleES)i.next();
                     contenido = contenido + " <tr><td>"+formulaMaestraDetalleES.getMateriales().getNombreMaterial()+"<td>" +
                             " <td>"+formulaMaestraDetalleES.getCantidad()+"</td><td>"+formulaMaestraDetalleES.getUnidadesMedida().getNombreUnidadMedida()+"</td>" +
                             " <td>"+formulaMaestraDetalleES.getMateriales().getEstadoRegistro().getNombreEstadoRegistro()+"</td></tr> " ;
                     }
                     }
                     contenido = contenido +" </tbody></table> <br/> se actualizo con la siguiente informacion: " +
                             " <table border='0' style='font-family: Arial;border: 1px solid black'> " +
                     " <tbody><tr><td>Material<td><td>Cantidad</td><td>Unidad Medida</td><td>estado Material</td></tr> ";
                     i = formulaMaestraDetalleActualList.iterator();
                     if(formulaMaestra.equals("MP") || formulaMaestra.equals("MR")){
                     while(i.hasNext()){
                         FormulaMaestraDetalleMP formulaMaestraDetalleMP = (FormulaMaestraDetalleMP)i.next();
                     contenido = contenido + " <tr><td>"+formulaMaestraDetalleMP.getMateriales().getNombreMaterial()+"<td>" +
                             " <td>"+formulaMaestraDetalleMP.getCantidad()+"</td><td>"+formulaMaestraDetalleMP.getUnidadesMedida().getNombreUnidadMedida()+"</td>" +
                             " <td>"+formulaMaestraDetalleMP.getMateriales().getEstadoRegistro().getNombreEstadoRegistro()+"</td></tr> " ;
                     }
                     }
                     if(formulaMaestra.equals("EP")){
                     while(i.hasNext()){
                         FormulaMaestraDetalleEP formulaMaestraDetalleEP = (FormulaMaestraDetalleEP)i.next();
                     contenido = contenido + " <tr><td>"+formulaMaestraDetalleEP.getMateriales().getNombreMaterial()+"<td>" +
                             " <td>"+formulaMaestraDetalleEP.getCantidad()+"</td><td>"+formulaMaestraDetalleEP.getUnidadesMedida().getNombreUnidadMedida()+"</td>" +
                             " <td>"+formulaMaestraDetalleEP.getMateriales().getEstadoRegistro().getNombreEstadoRegistro()+"</td></tr> " ;
                     }
                     }
                     if(formulaMaestra.equals("ES")){
                     while(i.hasNext()){
                         FormulaMaestraDetalleES formulaMaestraDetalleES = (FormulaMaestraDetalleES)i.next();
                     contenido = contenido + " <tr><td>"+formulaMaestraDetalleES.getMateriales().getNombreMaterial()+"<td>" +
                             " <td>"+formulaMaestraDetalleES.getCantidad()+"</td><td>"+formulaMaestraDetalleES.getUnidadesMedida().getNombreUnidadMedida()+"</td>" +
                             " <td>"+formulaMaestraDetalleES.getMateriales().getEstadoRegistro().getNombreEstadoRegistro()+"</td></tr> " ;
                     }
                     }
                     contenido = contenido +" </tbody></table> <br><br> Formulas Maestras - Atlas "+
                     " </body> </html> " ;
            msg.setContent(contenido, "text/html");
            javax.mail.Transport.send(msg);
         } catch (Exception e) {
             e.printStackTrace();
         }
         return null;
     }
    public List cargarFormulaMaestraDetalleMP(String codigo) {
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
                System.out.println("sql_00...........:"+sql_00);
                Statement st_00 = getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rs_00 = st_00.executeQuery(sql_00);
                List arrayAux = new ArrayList();
                while (rs_00.next()) {
                    FormulaMaestraDetalleMPfracciones val = new FormulaMaestraDetalleMPfracciones();
                    val.setCantidad(rs_00.getDouble(1));
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
    public FormulaMaestra obtieneFormulaMaestra(String codFormulaMaestra){
        FormulaMaestra formulaMaestra = new FormulaMaestra();
        try {
            String consulta = " select c.nombre_prod_semiterminado from formula_maestra fm inner join componentes_prod c on c.cod_compprod = fm.cod_compprod " +
                    " where fm.cod_formula_maestra = '"+codFormulaMaestra+"' ";
            System.out.println("consulta " + consulta);
            Connection con = null;
            con=Util.openConnection(con);
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery(consulta);
            if(rs.next()){
                formulaMaestra.getComponentesProd().setNombreProdSemiterminado(rs.getString("nombre_prod_semiterminado"));
            }
            rs.close();
            st.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return formulaMaestra;
    }
    public String verActividadesFormulaMaestraDesarrollo_action(){
        try {
            formulaMaestra = (FormulaMaestra)formulaMaestraDataTable.getRowData();
            FacesContext facesContext = FacesContext.getCurrentInstance();
            ExternalContext externalContext = facesContext.getExternalContext();
            Map map = externalContext.getSessionMap();
            map.put("formulaMaestra",formulaMaestra);
            ManagedProgramaProduccion managedProgramaProduccion = new ManagedProgramaProduccion();
            managedProgramaProduccion.redireccionar("../actividades_formula_maestra/navegador_actividades_formula.jsf");


        } catch (Exception e) {
        }
        return null;
    }
    public String verActividadesFormulaMaestra_action(){
        try {
            formulaMaestra = (FormulaMaestra)formulasMaestrasProduccionDataTable.getRowData();
            FacesContext facesContext = FacesContext.getCurrentInstance();
            ExternalContext externalContext = facesContext.getExternalContext();
            Map map = externalContext.getSessionMap();
            map.put("formulaMaestra",formulaMaestra);
            ManagedProgramaProduccion managedProgramaProduccion = new ManagedProgramaProduccion();
            managedProgramaProduccion.redireccionar("../actividades_formula_maestra/navegador_actividades_formula.jsf");
            

        } catch (Exception e) {
        }
        return null;
    }
    private void obtenerCodAreaPersonal()
    {
        try
        {
            Connection con2=null;
            con2=Util.openConnection(con2);
            Statement st=con2.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ManagedAccesoSistema user=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
            String consulta="select p.COD_AREA_EMPRESA  from PERSONAL p where p.COD_PERSONAL='"+user.getUsuarioModuloBean().getCodUsuarioGlobal()+"'";
            System.out.println("consulta codArea "+consulta);
            ResultSet res=st.executeQuery(consulta);
            if(res.next())
            {
                codAreaEmpresaPersonal=res.getString("COD_AREA_EMPRESA");
            }
            res.close();
            st.close();
            con2.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
    }
    public String tiposProduccion_change()
    {
        this.cargarFormulaMaestra();
        return null;
    }
    private void cargarAreasEmpresaActividad()
    {
        try
        {
            Connection con=null;
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select a.COD_AREA_EMPRESA,a.NOMBRE_AREA_EMPRESA from areas_empresa a where a.COD_AREA_EMPRESA in (96,75,40,84,76,97,1001) order by a.NOMBRE_AREA_EMPRESA asc";
            ResultSet res=st.executeQuery(consulta);
            areasActividadesList.clear();
            areasActividadesList.add(new SelectItem("0","-TODOS-"));
            while(res.next())
            {
                areasActividadesList.add(new SelectItem(res.getString("COD_AREA_EMPRESA"),res.getString("NOMBRE_AREA_EMPRESA")));
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
    private void cargarTiposProduccion()
    {
        ManagedAccesoSistema usuario=(ManagedAccesoSistema)Util.getSession("ManagedAccesoSistema");
        try
        {
            Connection con1=null;
            con1=Util.openConnection(con1);
            Statement st=con1.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select tp.COD_TIPO_PRODUCCION,tp.NOMBRE_TIPO_PRODUCCION from TIPOS_PRODUCCION tp inner join usuarios_area_produccion u on u.cod_area_empresa = tp.cod_area_empresa and u.cod_tipo_permiso = 2 and u.cod_personal = '"+usuario.getUsuarioModuloBean().getCodUsuarioGlobal()+"' ";
            //consulta="select tp.COD_TIPO_PRODUCCION,tp.NOMBRE_TIPO_PRODUCCION from TIPOS_PRODUCCION tp ";
            System.out.println("consulta " + consulta);
            ResultSet res=st.executeQuery(consulta);
            tiposProduccionList.clear();
            //tiposProduccionList.add(new SelectItem(0,"-TODOS-"));
            while(res.next())
            {
                tiposProduccionList.add(new SelectItem(res.getInt("COD_TIPO_PRODUCCION"),res.getString("NOMBRE_TIPO_PRODUCCION")));
            }
            if(tiposProduccionList.size()==0){
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
    public String actualizarProductosProgramaProduccion_action(){
        try {
            Iterator i = formulaMaestraList.iterator();
            FormulaMaestra formulaMaestraSeleccionada = new FormulaMaestra();
            while(i.hasNext()){
                formulaMaestraSeleccionada = (FormulaMaestra) i.next();
                if(formulaMaestraSeleccionada.getChecked()==true){
                    break;
                }
            }
            
            String  consulta = " select ppr.COD_PROGRAMA_PROD,ppr.COD_COMPPROD,ppr.COD_FORMULA_MAESTRA,ppr.COD_LOTE_PRODUCCION,ppr.COD_TIPO_PROGRAMA_PROD,ppr.COD_ESTADO_PROGRAMA,ppr.cant_lote_produccion,fm.cantidad_lote" +
                    " from PROGRAMA_PRODUCCION ppr inner join formula_maestra fm on fm.cod_compprod = ppr.cod_compprod inner join programa_produccion_periodo prpp on prpp.cod_programa_prod = ppr.cod_programa_prod where ppr.COD_ESTADO_PROGRAMA in (1,2,7,4) and fm.cod_formula_maestra='"+formulaMaestraSeleccionada.getCodFormulaMaestra()+"' and prpp.cod_estado_programa in(1,2,4)";
            System.out.println("consulta " + consulta);
            Connection con = null;
            con = Util.openConnection(con);
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery(consulta);
            Statement st1 = con.createStatement();
            List mpList = new ArrayList();
            List epList = new ArrayList();
            List esList = new ArrayList();
            List mrList = new ArrayList();
            ManagedProgramaProduccion managedProgramaProduccion = new ManagedProgramaProduccion();
            while(rs.next()){
                ProgramaProduccion p = new ProgramaProduccion();
                p.setCodLoteProduccion(rs.getString("cod_lote_produccion"));
                p.getFormulaMaestra().getComponentesProd().setCodCompprod(rs.getString("cod_compprod"));
                p.getFormulaMaestra().setCodFormulaMaestra(rs.getString("cod_formula_maestra"));
                p.setCodProgramaProduccion(rs.getString("cod_programa_prod"));
                p.getTiposProgramaProduccion().setCodTipoProgramaProd(rs.getString("cod_tipo_programa_prod"));
                p.setCantidadLote(rs.getDouble("cant_lote_produccion"));
                p.getFormulaMaestra().setCantidadLote(rs.getDouble("cantidad_lote"));
                consulta = " delete from PROGRAMA_PRODUCCION_DETALLE where COD_PROGRAMA_PROD='"+p.getCodProgramaProduccion()+"'" +
                     " and cod_lote_produccion='"+p.getCodLoteProduccion()+"' and cod_compprod = '"+p.getFormulaMaestra().getComponentesProd().getCodCompprod()+"' and cod_tipo_programa_prod = '"+p.getTiposProgramaProduccion().getCodTipoProgramaProd()+"' ";
                System.out.println("consulta " + consulta);
                st1.executeUpdate(consulta);
                consulta = "UPDATE PROGRAMA_PRODUCCION SET COD_COMPPROD = '"+rs.getInt("cod_compprod")+"',  COD_FORMULA_MAESTRA = '"+rs.getInt("cod_formula_maestra")+"'," +
                        "CANT_LOTE_PRODUCCION = '"+rs.getString("cantidad_lote")+"'" +
                        "WHERE  cod_formula_maestra ='"+rs.getInt("cod_formula_maestra")+"'  and cod_lote_produccion = '"+rs.getString("cod_lote_produccion")+"'  and cod_compprod = '"+rs.getInt("cod_compprod")+"'  and cod_tipo_programa_prod = '"+rs.getInt("cod_tipo_programa_prod")+"'" +
                        "  and cod_programa_prod = '"+rs.getInt("cod_programa_prod")+"'";
                System.out.println("consulta " + consulta);
                st1.executeUpdate(consulta);
                mpList = managedProgramaProduccion.cargarFormulaMaestraDetalleMPEditar(p);
                epList = managedProgramaProduccion.cargarFormulaMaestraDetalleEPEditar(p);
                mrList = managedProgramaProduccion.cargarFormulaMaestraDetalleMREditar(p);

                Iterator i1 = mpList.iterator();

                        while(i1.hasNext()){
                            FormulaMaestraDetalleMP formulaMaestraDetalleMP = (FormulaMaestraDetalleMP)i1.next();
                            consulta = " insert into programa_produccion_detalle(cod_programa_prod,COD_COMPPROD, cod_material,cod_unidad_medida,cantidad,cod_lote_produccion,cod_tipo_programa_prod,cod_tipo_material) " +
                                    " values('"+p.getCodProgramaProduccion()+"','"+p.getFormulaMaestra().getComponentesProd().getCodCompprod()+"', " +
                                    "'"+ formulaMaestraDetalleMP.getMateriales().getCodMaterial() +"','"+formulaMaestraDetalleMP.getUnidadesMedida().getCodUnidadMedida()+"','"+formulaMaestraDetalleMP.getCantidad()+"'," +
                                    "'"+p.getCodLoteProduccion()+"','"+p.getTiposProgramaProduccion().getCodTipoProgramaProd()+"',1 ) ";
                            System.out.println("consulta MP " + consulta);
                            if(st1.executeUpdate(consulta)>0)System.out.println("se registro mat MP satisfactoriamente");

                        }

                        i1 = mrList.iterator();
                        while(i1.hasNext()){
                            FormulaMaestraDetalleMP formulaMaestraDetalleMP = (FormulaMaestraDetalleMP)i1.next();
                            consulta = " insert into programa_produccion_detalle(cod_programa_prod,COD_COMPPROD, cod_material,cod_unidad_medida,cantidad,cod_lote_produccion,cod_tipo_programa_prod,cod_tipo_material) " +
                                    " values('"+p.getCodProgramaProduccion()+"','"+p.getFormulaMaestra().getComponentesProd().getCodCompprod()+"', " +
                                    "'"+ formulaMaestraDetalleMP.getMateriales().getCodMaterial() +"','"+formulaMaestraDetalleMP.getUnidadesMedida().getCodUnidadMedida()+"','"+formulaMaestraDetalleMP.getCantidad()+"'," +
                                    "'"+p.getCodLoteProduccion()+"','"+p.getTiposProgramaProduccion().getCodTipoProgramaProd()+"',4 ) ";
                            System.out.println("consulta MR " + consulta);
                            if(st1.executeUpdate(consulta)>0)System.out.println("se registro mat mr satisfactoriamente");

                        }

                         i1 = epList.iterator();
                        while(i1.hasNext()){
                            FormulaMaestraDetalleMP formulaMaestraDetalleMP = (FormulaMaestraDetalleMP)i1.next();
                            consulta = " insert into programa_produccion_detalle(cod_programa_prod,COD_COMPPROD, cod_material,cod_unidad_medida,cantidad,cod_lote_produccion,cod_tipo_programa_prod,cod_tipo_material) " +
                                    " values('"+p.getCodProgramaProduccion()+"','"+p.getFormulaMaestra().getComponentesProd().getCodCompprod()+"', " +
                                    "'"+ formulaMaestraDetalleMP.getMateriales().getCodMaterial() +"','"+formulaMaestraDetalleMP.getUnidadesMedida().getCodUnidadMedida()+"','"+formulaMaestraDetalleMP.getCantidad()+"'," +
                                    "'"+p.getCodLoteProduccion()+"','"+p.getTiposProgramaProduccion().getCodTipoProgramaProd()+"',2 ) ";
                            System.out.println("consulta EP " + consulta);
                            if(st1.executeUpdate(consulta)>0)System.out.println("se registro mat EP satisfactoriamente");

                        }

                        i1 = esList.iterator();
                        while(i1.hasNext()){
                            FormulaMaestraDetalleMP formulaMaestraDetalleMP = (FormulaMaestraDetalleMP)i1.next();
                            consulta = " insert into programa_produccion_detalle(cod_programa_prod,COD_COMPPROD, cod_material,cod_unidad_medida,cantidad,cod_lote_produccion,cod_tipo_programa_prod,cod_tipo_material) " +
                                    " values('"+p.getCodProgramaProduccion()+"','"+p.getFormulaMaestra().getComponentesProd().getCodCompprod()+"', " +
                                    "'"+ formulaMaestraDetalleMP.getMateriales().getCodMaterial() +"','"+formulaMaestraDetalleMP.getUnidadesMedida().getCodUnidadMedida()+"','"+formulaMaestraDetalleMP.getCantidad()+"'," +
                                    "'"+p.getCodLoteProduccion()+"','"+p.getTiposProgramaProduccion().getCodTipoProgramaProd()+"',3 ) ";
                            System.out.println("consulta ES " + consulta);
                            if(st1.executeUpdate(consulta)>0)System.out.println("se registro satisfactoriamente");
                        }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public String guardarVersionActual_action(){
        try {
            Iterator i = formulaMaestraList.iterator();
            FormulaMaestra fm = new FormulaMaestra();
            while(i.hasNext()){
                fm = (FormulaMaestra)i.next();
                if(fm.getChecked()){
                    break;
                }
            }
//            this.guardarVersionFormulaMaestra(fm,fm.getCodFormulaMaestra());
           // this.enviarCorreo(this.cargarConfiguracionEnvioCorreo(), this.cargarFormulaMaestraDetalleMP(fm.getCodFormulaMaestra()),this.cargarFormulaMaestraDetalleMP(fm.getCodFormulaMaestra()), fm.getCodFormulaMaestra(), "MP");
            //Util.enviarCorreo("1479", "se mifico la formula maestra", "modificacion de formula maestra", "user que envia");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public String[] cargarConfiguracionEnvioCorreo(){
        String[] correos = new String[0];
        try {
            Connection con = null;
            con = Util.openConnection(con);
            String consulta = " select c.cod_personal,cp.nombre_correopersonal from configuracion_envio_correo c" +
                    " inner join tipos_envio_correo t on t.cod_tipo_envio_correo = c.cod_tipo_envio_correo" +
                    " inner join correo_personal cp on cp.COD_PERSONAL = c.cod_personal" +
                    " where t.cod_tipo_envio_correo = 1";
            System.out.println("consulta " + consulta);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(consulta);
            int i = 0;
            rs.last();
            correos = new String[rs.getRow()];
            
            rs.beforeFirst();
            while(rs.next()){
                correos[i] = rs.getString("nombre_correopersonal");
                i++;
            }
            rs.close();
            st.close();
            con.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return correos;
    }
    
    public List cargarFormulasReplicar(){
        List formulaMaestraList = new ArrayList();
        try {
            Connection con = null;
            con = Util.openConnection(con);
            Statement st = con.createStatement();
            String consulta = " select p.nombre_prod_semiterminado,f.CANTIDAD_LOTE,f.cod_formula_maestra,p.cod_compprod,e.NOMBRE_ESTADO_REGISTRO" +
                    " from formula_maestra f" +
                    " inner join componentes_prod p on p.cod_compprod = f.cod_compprod" +
                    " inner join estados_registro where f.cod_estado_registro = 1 and p.COD_TIPO_PRODUCCION = 1" +
                    " inner join ESTADOS_REFERENCIALES e on e.COD_ESTADO_REGISTRO = f.COD_ESTADO_REGISTRO" +
                    " where p.cod_area_empresa = '"+formulaMaestrabean.getComponentesProd().getAreasEmpresa().getCodAreaEmpresa()+"' " +
                    " order by p.nombre_prod_semiterminado asc ";
            ResultSet rs = st.executeQuery(consulta);
            while(rs.next()){
                FormulaMaestra f = new FormulaMaestra();
                f.getComponentesProd().setNombreProdSemiterminado(rs.getString("nombre_prod_semiterminado"));
                f.setCantidadLote(rs.getDouble("cantidad_lote"));
                f.setCodFormulaMaestra(rs.getString("cod_formula_maestra"));
                f.getComponentesProd().setCodCompprod(rs.getString("cod_compprod"));
                f.getEstadoRegistro().setNombreEstadoRegistro(rs.getString("nombre_estado_registro"));
                formulaMaestraList.add(f);
            }


        } catch (Exception e) {
            e.printStackTrace();
        }
        return formulaMaestraList;
    }
    /* ------------------Métodos---------------------------*/
    public Connection getCon() {
        return con;
    }

    public void setCon(Connection con) {
        this.con = con;
    }

    public FormulaMaestra getFormulaMaestrabean() {
        return formulaMaestrabean;
    }

    public void setFormulaMaestrabean(FormulaMaestra formulaMaestrabean) {
        this.formulaMaestrabean = formulaMaestrabean;
    }

    public List getFormulaMaestraEliminar() {
        return formulaMaestraEliminar;
    }

    public void setFormulaMaestraEliminar(List formulaMaestraEliminar) {
        this.formulaMaestraEliminar = formulaMaestraEliminar;
    }

    public List getFormulaMaestraNoEliminar() {
        return formulaMaestraNoEliminar;
    }

    public void setFormulaMaestraNoEliminar(List formulaMaestraNoEliminar) {
        this.formulaMaestraNoEliminar = formulaMaestraNoEliminar;
    }

    public int getCantidadeliminar() {
        return cantidadeliminar;
    }

    public void setCantidadeliminar(int cantidadeliminar) {
        this.cantidadeliminar = cantidadeliminar;
    }

    public String getCodigo() {
        return codigo;
    }

    public void setCodigo(String codigo) {
        this.codigo = codigo;
    }

    public List getLista() {
        return lista;
    }

    public void setLista(List lista) {
        this.lista = lista;
    }

    public List getEstadoRegistro() {
        return estadoRegistro;
    }

    public void setEstadoRegistro(List estadoRegistro) {
        this.estadoRegistro = estadoRegistro;
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

    public List getFormulaMaestraList() {
        return formulaMaestraList;
    }

    public void setFormulaMaestraList(List formulaMaestraList) {
        this.formulaMaestraList = formulaMaestraList;
    }

    public List getComponentesProd() {
        return componentesProd;
    }

    public void setComponentesProd(List componentesProd) {
        this.componentesProd = componentesProd;
    }

    public List getAreasEmpresaList() {
        return areasEmpresaList;
    }

    public void setAreasEmpresaList(List areasEmpresaList) {
        this.areasEmpresaList = areasEmpresaList;
    }

    public HtmlDataTable getFormulaMaestraDataTable() {
        return formulaMaestraDataTable;
    }

    public void setFormulaMaestraDataTable(HtmlDataTable formulaMaestraDataTable) {
        this.formulaMaestraDataTable = formulaMaestraDataTable;
    }

    public String getCodAreaEmpresaPersonal() {
        return codAreaEmpresaPersonal;
    }

    public void setCodAreaEmpresaPersonal(String codAreaEmpresaPersonal) {
        this.codAreaEmpresaPersonal = codAreaEmpresaPersonal;
    }

    public List<SelectItem> getTiposProduccionList() {
        return tiposProduccionList;
    }

    public void setTiposProduccionList(List<SelectItem> tiposProduccionList) {
        this.tiposProduccionList = tiposProduccionList;
    }

    public List<SelectItem> getActividadesList() {
        return actividadesList;
    }

    public void setActividadesList(List<SelectItem> actividadesList) {
        this.actividadesList = actividadesList;
    }

    public MaquinariaActividadesFormula getMaquinariaActividadesFormula() {
        return maquinariaActividadesFormula;
    }

    public void setMaquinariaActividadesFormula(MaquinariaActividadesFormula maquinariaActividadesFormula) {
        this.maquinariaActividadesFormula = maquinariaActividadesFormula;
    }

    public List<MaquinariaActividadesFormula> getMaquinariaActividadesFormulasList() {
        return maquinariaActividadesFormulasList;
    }

    public void setMaquinariaActividadesFormulasList(List<MaquinariaActividadesFormula> maquinariaActividadesFormulasList) {
        this.maquinariaActividadesFormulasList = maquinariaActividadesFormulasList;
    }


    public ActividadesFormulaMaestra getActividadesFormulaMaestraBean() {
        return actividadesFormulaMaestraBean;
    }

    public void setActividadesFormulaMaestraBean(ActividadesFormulaMaestra actividadesFormulaMaestraBean) {
        this.actividadesFormulaMaestraBean = actividadesFormulaMaestraBean;
    }

    public List<SelectItem> getAreasActividadesList() {
        return areasActividadesList;
    }

    public void setAreasActividadesList(List<SelectItem> areasActividadesList) {
        this.areasActividadesList = areasActividadesList;
    }

    public String getMensaje() {
        return mensaje;
    }

    public void setMensaje(String mensaje) {
        this.mensaje = mensaje;
    }

    public String getCodAreaEmpresaActividad() {
        return codAreaEmpresaActividad;
    }

    public void setCodAreaEmpresaActividad(String codAreaEmpresaActividad) {
        this.codAreaEmpresaActividad = codAreaEmpresaActividad;
    }

    public FormulaMaestra getFormulaMaestraCopia() {
        return formulaMaestraCopia;
    }

    public void setFormulaMaestraCopia(FormulaMaestra formulaMaestraCopia) {
        this.formulaMaestraCopia = formulaMaestraCopia;
    }

    public List getFormulaMaestraCopiaList() {
        return formulaMaestraCopiaList;
    }

    public void setFormulaMaestraCopiaList(List formulaMaestraCopiaList) {
        this.formulaMaestraCopiaList = formulaMaestraCopiaList;
    }

    public FormulaMaestra getFormulaMaestraSeleccionado() {
        return formulaMaestraSeleccionado;
    }

    public void setFormulaMaestraSeleccionado(FormulaMaestra formulaMaestraSeleccionado) {
        this.formulaMaestraSeleccionado = formulaMaestraSeleccionado;
    }

    public List<FormulaMaestra> getFormulaMaestrasProduccionList() {
        return formulaMaestrasProduccionList;
    }

    public void setFormulaMaestrasProduccionList(List<FormulaMaestra> formulaMaestrasProduccionList) {
        this.formulaMaestrasProduccionList = formulaMaestrasProduccionList;
    }

    public HtmlDataTable getFormulasMaestrasProduccionDataTable() {
        return formulasMaestrasProduccionDataTable;
    }

    public void setFormulasMaestrasProduccionDataTable(HtmlDataTable formulasMaestrasProduccionDataTable) {
        this.formulasMaestrasProduccionDataTable = formulasMaestrasProduccionDataTable;
    }

    public FormulaMaestra getFormulaMaestraBuscar() {
        return formulaMaestraBuscar;
    }

    public void setFormulaMaestraBuscar(FormulaMaestra formulaMaestraBuscar) {
        this.formulaMaestraBuscar = formulaMaestraBuscar;
    }

    public List<SelectItem> getAreasEmpresaProduccionSelectList() {
        return areasEmpresaProduccionSelectList;
    }

    public void setAreasEmpresaProduccionSelectList(List<SelectItem> areasEmpresaProduccionSelectList) {
        this.areasEmpresaProduccionSelectList = areasEmpresaProduccionSelectList;
    }

    public FormulaMaestra getFormulaMaestraDuplicarLote() {
        return formulaMaestraDuplicarLote;
    }

    public void setFormulaMaestraDuplicarLote(FormulaMaestra formulaMaestraDuplicarLote) {
        this.formulaMaestraDuplicarLote = formulaMaestraDuplicarLote;
    }

    public double getCantidadNuevoLote() {
        return cantidadNuevoLote;
    }

    public void setCantidadNuevoLote(double cantidadNuevoLote) {
        this.cantidadNuevoLote = cantidadNuevoLote;
    }

    
    
    
}
