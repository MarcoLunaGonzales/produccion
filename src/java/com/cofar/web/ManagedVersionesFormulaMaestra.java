/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.web;

import com.cofar.bean.FormulaMaestra;
import com.cofar.bean.FormulaMaestraDetalleEP;
import com.cofar.bean.FormulaMaestraDetalleES;
import com.cofar.bean.FormulaMaestraDetalleMP;
import com.cofar.bean.FormulaMaestraDetalleMPfracciones;
import com.cofar.bean.FormulaMaestraDetalleMr;
import com.cofar.bean.FormulaMaestraEP;
import com.cofar.bean.FormulaMaestraES;
import com.cofar.bean.FormulaMaestraVersion;

import com.cofar.bean.FormulaMaestraVersionModificacion;
import com.cofar.bean.PresentacionesPrimarias;
import com.cofar.bean.TiposMaterialProduccion;
import com.cofar.dao.DaoEnvasesPrimarios;
import com.cofar.dao.DaoFormulaMaestraDetalleEpVersion;
import com.cofar.dao.DaoFormulaMaestraDetalleMpFraccionesVersion;
import com.cofar.dao.DaoFormulaMaestraDetalleMpVersion;
import com.cofar.dao.DaoFormulaMaestraDetalleMrVersion;
import com.cofar.dao.DaoPresentacionesPrimariasVersion;
import com.cofar.dao.DaoTiposMaterialReactivo;
import com.cofar.dao.DaoTiposProgramaProduccion;
import com.cofar.util.Util;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import javax.faces.context.ExternalContext;
import javax.faces.context.FacesContext;
import javax.faces.model.SelectItem;
import org.richfaces.component.html.HtmlDataTable;
import org.apache.logging.log4j.LogManager;


/**
 *
 * @author DASISAQ
 */

public class ManagedVersionesFormulaMaestra extends ManagedBean
{
    private Connection con=null;
    private List<FormulaMaestraVersion> formulaMaestraVersionesList=new ArrayList<FormulaMaestraVersion>();
    private FormulaMaestra formulaMaestraBean=new FormulaMaestra();
    private String mensaje="";
    private HtmlDataTable formulaMaestraVersionesData=new HtmlDataTable();
    private FormulaMaestraVersion formulaMaestraVersionaBean=new FormulaMaestraVersion();
    private FormulaMaestraVersion formulaMaestraVersionRevisar=new FormulaMaestraVersion();
    //<editor-fold desc="mp" defaultstate="collapsed">
        private List<TiposMaterialProduccion> formulaMaestraDetalleMPList=null;
        private TiposMaterialProduccion tiposMaterialProduccionAgregar;
        private FormulaMaestraDetalleMP formulaMaestraDetalleMPBean;
    //</editor-fold>
    //<editor-fold desc="ep" defaultstate="collapsed">
        private List<PresentacionesPrimarias> formulaMaestraEPList;
        private List<SelectItem> envasesPrimariosSelectList;
        private List<SelectItem> tiposProgramaProduccionSelectList;
        private PresentacionesPrimarias presentacionesPrimariasAgregar;
        private PresentacionesPrimarias presentacionesPrimariasEditar;
    //</editor-fold>    
        
    
    private List<FormulaMaestraDetalleMP> formulaMaestraDetalleMPEditarList=new ArrayList<FormulaMaestraDetalleMP>();
    
    private List<FormulaMaestraDetalleMPfracciones> formulaMaestraDetalleMPfraccionesEditar=new ArrayList<FormulaMaestraDetalleMPfracciones>();
    private List<SelectItem> tiposMaterialProduccionSelectList=new ArrayList<SelectItem>();
    private List<FormulaMaestraDetalleMP> formulaMaestraDetalleMPAgregarList=new ArrayList<FormulaMaestraDetalleMP>();
    private List<FormulaMaestraVersion> formulaMaestraVersionAprobarList=new ArrayList<FormulaMaestraVersion>();
    private List<FormulaMaestraVersion> formulasMaestrasNuevasList=new ArrayList<FormulaMaestraVersion>();
    private List<SelectItem> componentesProdSelectList=new ArrayList<SelectItem>();
    private List<SelectItem> tiposProduccionSelectList=new ArrayList<SelectItem>();
    private FormulaMaestraVersion formulaMaestraVersionAbm=new FormulaMaestraVersion();
    private HtmlDataTable formulasMaestrasNuevasDataTable=new HtmlDataTable();
    private FormulaMaestraVersion formulaMaestraVersionEditar=new FormulaMaestraVersion();
    
    private HtmlDataTable formulaMaestraEpDataTable=new HtmlDataTable();
    private  FormulaMaestraEP formulaMaestraEPBean=new  FormulaMaestraEP();
    
    private List<FormulaMaestraES> formulaMaestraESList=new ArrayList<FormulaMaestraES>();
    private HtmlDataTable formulaMaestraESDataTable=new HtmlDataTable();
    private FormulaMaestraES formulaMaestraESBean=new FormulaMaestraES();
    private List<FormulaMaestraDetalleES> formulaMaestraDetalleESList=new ArrayList<FormulaMaestraDetalleES>();
    private List<FormulaMaestraDetalleES> formulaMaestraDetalleESAgregarList=new ArrayList<FormulaMaestraDetalleES>();
    private List<FormulaMaestraDetalleES> formulaMaestraDetalleESEditarList=new ArrayList<FormulaMaestraDetalleES>();
    private List<SelectItem> tiposAnalisisMaterialReactivoSelectList=new ArrayList<SelectItem>();
    private List<SelectItem> tiposMaterialReactivoSelectList=new ArrayList<SelectItem>();
    private List<FormulaMaestraDetalleMr> formulaMaestraDetalleMRList=new ArrayList<>();
    private List<FormulaMaestraDetalleMr> formulaMaestraDetalleMRAgregarList=new ArrayList<>();
    private List<FormulaMaestraDetalleMr> formulaMaestraDetalleMREditarList = new ArrayList<>();
    private int codTipoMaterialReactivo=1;
    private int codAreaEmpresaPersonal=0;
    private String mensajeCorreo="";
    
    /** Creates a new instance of ManagedVersionesFormulaMaestra */
    public ManagedVersionesFormulaMaestra() {
        LOGGER=LogManager.getLogger("Versionamiento");
        
    }
    
    private void cargarAreaEmpresaPersonal()
    {
        try
        {
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ManagedAccesoSistema usuario=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
            String consulta="select p.COD_AREA_EMPRESA  from PERSONAL p where p.COD_PERSONAL='"+usuario.getUsuarioModuloBean().getCodUsuarioGlobal()+"'";
            ResultSet res=st.executeQuery(consulta);
            if(res.next())
            {
                codAreaEmpresaPersonal=res.getInt("COD_AREA_EMPRESA");
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
    public String eliminarFormulaMaestraDetalleMRVersion_action() throws SQLException
    {
        mensaje  = "";
        DaoFormulaMaestraDetalleMrVersion daoFormulaMr = new DaoFormulaMaestraDetalleMrVersion(LOGGER);
        List<FormulaMaestraDetalleMr> eliminarList = new ArrayList<>();
        for(FormulaMaestraDetalleMr bean:formulaMaestraDetalleMRList){
            if(bean.getChecked())
            {
                eliminarList.add(bean);
            }
        }
        if(daoFormulaMr.eliminarLista(eliminarList))
        {
            mensaje = "1";
            this.cargarFormulaMaestraDetalleMRVersiones();
        }
        else
        {
            mensaje = "Ocurrio un error al momento de eliminar el/los item(s) seleccionado(s)";
        }
        return null;
    }
    public String editarFormulaMaestraDetalleMRVersion_action()
    {
        formulaMaestraDetalleMREditarList = new ArrayList<>();
        for(FormulaMaestraDetalleMr bean : formulaMaestraDetalleMRList)
        {
            if(bean.getChecked())
            {
                formulaMaestraDetalleMREditarList.add(bean);
            }
        }
        return null;
    }
    public String guardarEdicionFormulaMaestraDetalleMrVersion_action()throws SQLException
    {
        mensaje="";
        DaoFormulaMaestraDetalleMrVersion daoFormulaMr = new DaoFormulaMaestraDetalleMrVersion(LOGGER);
        if(daoFormulaMr.editarLista(formulaMaestraDetalleMREditarList)){
            mensaje  = "1";
        }
        else{
            mensaje = "Ocurrio un error al momento de editar los materiales, intente de nuevo";
        }
        return null;
    }
    public String guardarFormulaMaestraDetalleMRVersion_action()throws SQLException
    {
        mensaje="";
        List<FormulaMaestraDetalleMr> listaAgregar = new ArrayList<>();
        for(FormulaMaestraDetalleMr bean : formulaMaestraDetalleMRAgregarList){
            if(bean.getChecked()){
                bean.getTiposMaterialReactivo().setCodTipoMaterialReactivo(codTipoMaterialReactivo);
                listaAgregar.add(bean);
            }
        }
        DaoFormulaMaestraDetalleMrVersion daoFormulaMr = new DaoFormulaMaestraDetalleMrVersion(LOGGER);
        if(daoFormulaMr.guardarLista(listaAgregar, formulaMaestraVersionaBean)){
            mensaje = "1";
        }
        else{
            mensaje = "Ocurrio un error al momento de registrar el material reactivo, intente de nuevo";
        }
        return null;
    }
    public String codTipoMaterialReactivo_change()
    {
        this.cargarFormulaMaestraDetalleMRVersiones();
        return null;
    }
    public String getCargarFormulaMaestraDetalleMrAgregar()
    {
        this.cargarFormulaMaestraDetalleMrAgregar();
        return null;
    }
    private void cargarFormulaMaestraDetalleMrAgregar()
    {
        DaoFormulaMaestraDetalleMrVersion daoFormulaMr = new DaoFormulaMaestraDetalleMrVersion(LOGGER);
        formulaMaestraDetalleMRAgregarList = daoFormulaMr.listarAgregar(formulaMaestraVersionaBean);
    }
    public String getCargarFormulaMaestraDetalleMR_action()
    {
        FacesContext facesContext = FacesContext.getCurrentInstance();
        ExternalContext externalContext = facesContext.getExternalContext();
        Map map = externalContext.getSessionMap();
        formulaMaestraVersionaBean = (FormulaMaestraVersion)map.get("formulaMaestraVersion");
        this.cargarTiposAnalisisMaterialReactivo();
        this.cargarTiposMaterialReactivo();
        this.cargarFormulaMaestraDetalleMRVersiones();
        return null;
    }
    private void cargarFormulaMaestraDetalleMRVersiones()
    {
        DaoFormulaMaestraDetalleMrVersion daoFormulaMr = new DaoFormulaMaestraDetalleMrVersion(LOGGER);
        formulaMaestraDetalleMRList = daoFormulaMr.listar(formulaMaestraVersionaBean, codTipoMaterialReactivo);
    }
    private void cargarTiposMaterialReactivo()
    {
        DaoTiposMaterialReactivo daoTiposMr = new DaoTiposMaterialReactivo(LOGGER);
        tiposMaterialReactivoSelectList = daoTiposMr.listarSelectItem();
        
    }
    private void cargarTiposAnalisisMaterialReactivo()
    {
        try
        {
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select tamr.cod_tipo_analisis_material_reactivo,tamr.nombre_tipo_analisis_material_reactivo"+
                            " from TIPOS_ANALISIS_MATERIAL_REACTIVO tamr order by tamr.nombre_tipo_analisis_material_reactivo";
            ResultSet res=st.executeQuery(consulta);
            tiposAnalisisMaterialReactivoSelectList.clear();
            while(res.next())
            {
                tiposAnalisisMaterialReactivoSelectList.add(new SelectItem(res.getInt("cod_tipo_analisis_material_reactivo"),res.getString("nombre_tipo_analisis_material_reactivo")));

            }
            st.close();
            con.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
    }
    public String eliminarFormulaMaestraDetalleESVersion_action()throws SQLException
    {
        mensaje="";
        for(FormulaMaestraDetalleES bean:formulaMaestraDetalleESList)
        {
            if(bean.getChecked())
            {
                try
                {
                    con=Util.openConnection(con);
                    con.setAutoCommit(false);
                    String consulta=" DELETE FORMULA_MAESTRA_DETALLE_ES_VERSION "+
                                     " WHERE COD_VERSION = '"+formulaMaestraVersionaBean.getCodVersion()+"' and"+
                                     " COD_FORMULA_MAESTRA = '"+formulaMaestraVersionaBean.getCodFormulaMaestra()+"' and"+
                                     " COD_MATERIAL = '"+bean.getMateriales().getCodMaterial()+"' and"+
                                     " COD_PRESENTACION_PRODUCTO = '"+formulaMaestraESBean.getPresentacionesProducto().getCodPresentacion()+"' and"+
                                     " COD_TIPO_PROGRAMA_PROD = '"+formulaMaestraESBean.getPresentacionesProducto().getTiposProgramaProduccion().getCodTipoProgramaProd()+"'";
                    System.out.println("consulta DELETE MATERIAL es "+consulta);
                    PreparedStatement pst=con.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)System.out.println("se elimino el material");
                    con.commit();
                    mensaje="1";
                    pst.close();
                    con.close();
                }
                catch(SQLException ex)
                {
                    con.rollback();
                    con.close();
                    mensaje="Ocurrio un error al momento de eliminar el material, intente de nuevo";
                    ex.printStackTrace();
                }
            }
        }
        if(mensaje.equals("1"))
        {
            this.cargarFormulaMaestraDetalleESVersion();
        }
        return null;
    }
    public String guardarEdicionFormulaMaestraDetalleESVersion_action()throws SQLException
    {
        mensaje="";
        try
        {
            con=Util.openConnection(con);
            con.setAutoCommit(false);
            PreparedStatement pst=null;
            String consulta="";
            for(FormulaMaestraDetalleES bean:formulaMaestraDetalleESEditarList)
            {
                consulta=" UPDATE FORMULA_MAESTRA_DETALLE_ES_VERSION SET CANTIDAD = '"+bean.getCantidad()+"'"+
                         " WHERE COD_VERSION = '"+formulaMaestraVersionaBean.getCodVersion()+"' and"+
                         " COD_FORMULA_MAESTRA = '"+formulaMaestraVersionaBean.getCodFormulaMaestra()+"' and"+
                         " COD_MATERIAL = '"+bean.getMateriales().getCodMaterial()+"' and"+
                         " COD_PRESENTACION_PRODUCTO = '"+formulaMaestraESBean.getPresentacionesProducto().getCodPresentacion()+"' and"+
                         " COD_TIPO_PROGRAMA_PROD = '"+formulaMaestraESBean.getPresentacionesProducto().getTiposProgramaProduccion().getCodTipoProgramaProd()+"'";
                System.out.println("consulta update cantidad es "+consulta);
                pst=con.prepareStatement(consulta);
                if(pst.executeUpdate()>0)System.out.println("se realizo el update");
            }
            con.commit();
            mensaje="1";
            if(pst!=null)pst.close();
            con.close();
        }
        catch(SQLException ex)
        {
            con.rollback();
            con.close();
            mensaje="Ocurrio un error al momento de guardar la edicion, intente de nuevo";
            ex.printStackTrace();
        }
        return null;
    }
    public String editarFormulaMaestraDetalleEsVersion_action()
    {
        formulaMaestraDetalleESEditarList.clear();
        for(FormulaMaestraDetalleES bean:formulaMaestraDetalleESList)
        {
            if(bean.getChecked())
            {
                formulaMaestraDetalleESEditarList.add(bean);
            }
        }
        return null;
    }
    public String guardarNuevosMaterialesFormulaMaestraDetalleES_action()throws SQLException
    {
        mensaje="1";
        try
        {
            con=Util.openConnection(con);
            con.setAutoCommit(false);
            PreparedStatement pst=null;
            String consulta="";
            for(FormulaMaestraDetalleES bean:formulaMaestraDetalleESAgregarList)
            {
                if(bean.getChecked())
                {
                    consulta="INSERT INTO FORMULA_MAESTRA_DETALLE_ES_VERSION(COD_VERSION, COD_FORMULA_MAESTRA,"+
                            " COD_MATERIAL, CANTIDAD, COD_UNIDAD_MEDIDA, COD_PRESENTACION_PRODUCTO,"+
                            " COD_TIPO_PROGRAMA_PROD)"+
                            "  VALUES ('"+formulaMaestraVersionaBean.getCodVersion()+"','"+formulaMaestraVersionaBean.getCodFormulaMaestra()+"'," +
                            "'"+bean.getMateriales().getCodMaterial()+"','"+bean.getCantidad()+"',"+
                            "'"+bean.getUnidadesMedida().getCodUnidadMedida()+"','"+formulaMaestraESBean.getPresentacionesProducto().getCodPresentacion()+"'," +
                            "'"+formulaMaestraESBean.getPresentacionesProducto().getTiposProgramaProduccion().getCodTipoProgramaProd()+"')";
                    System.out.println("consulta guardar material es "+consulta);
                    pst=con.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)System.out.println("se registro el nuevo materiales es");
                }
            }
            con.commit();
            if(pst!=null)pst.close();
            mensaje="1";
            con.close();
        }
        catch(SQLException ex)
        {
            con.rollback();
            con.close();
            mensaje="Ocurrio un error al momento de guardar los materiales, intente de nuevo";
            ex.printStackTrace();
        }
        return null;
    }
    public String getCargarAgregarFormulaMaestraDetalleES_action()
    {
//        this.cargarAgregarMaterialesEsVersion();
        return null;
    }
    
    public String getCargarFormulaMaestraDetalleEsVersion()
    {
        this.cargarFormulaMaestraDetalleESVersion();
        return null;
    }
    private void cargarFormulaMaestraDetalleESVersion()
    {
        try
        {
            String consulta="select fmdev.COD_FORMULA_MAESTRA,m.NOMBRE_MATERIAL,fmdev.CANTIDAD,"+
                            " um.NOMBRE_UNIDAD_MEDIDA,m.cod_material,er.nombre_estado_registro"+
                            " from FORMULA_MAESTRA_DETALLE_ES_VERSION fmdev inner join MATERIALES m"+
                            " on fmdev.COD_MATERIAL=m.COD_MATERIAL inner join UNIDADES_MEDIDA um on"+
                            " um.COD_UNIDAD_MEDIDA=fmdev.COD_UNIDAD_MEDIDA"+
                            " inner join ESTADOS_REFERENCIALES er on er.COD_ESTADO_REGISTRO=m.COD_ESTADO_REGISTRO"+
                            " inner join grupos g on g.COD_GRUPO=m.COD_GRUPO"+
                            " where g.COD_CAPITULO IN (4, 8) and fmdev.COD_FORMULA_MAESTRA='"+formulaMaestraVersionaBean.getCodFormulaMaestra()+"'"+
                            " and fmdev.COD_PRESENTACION_PRODUCTO='"+formulaMaestraESBean.getPresentacionesProducto().getCodPresentacion()+"'" +
                            " and fmdev.COD_TIPO_PROGRAMA_PROD='"+formulaMaestraESBean.getPresentacionesProducto().getTiposProgramaProduccion().getCodTipoProgramaProd()+"'"+
                            " and fmdev.COD_VERSION='"+formulaMaestraVersionaBean.getCodVersion()+"'"+
                            " order by m.NOMBRE_MATERIAL";
            System.out.println("consulta cargar detalle Es Version "+consulta);
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta);
            formulaMaestraDetalleESList.clear();
            NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
            DecimalFormat form = (DecimalFormat) nf;
            form.applyPattern("##00.0#");
            while(res.next())
            {
                FormulaMaestraDetalleES nuevo=new FormulaMaestraDetalleES();
                nuevo.getFormulaMaestra().setCodFormulaMaestra(res.getString("COD_FORMULA_MAESTRA"));
                nuevo.getMateriales().setNombreMaterial(res.getString("NOMBRE_MATERIAL"));
                nuevo.setCantidad(redondear(res.getDouble("CANTIDAD"),3));
                nuevo.getUnidadesMedida().setNombreUnidadMedida(res.getString("NOMBRE_UNIDAD_MEDIDA"));
                nuevo.getMateriales().setCodMaterial(res.getString("cod_material"));
                nuevo.getMateriales().getEstadoRegistro().setNombreEstadoRegistro(res.getString("nombre_estado_registro"));
                formulaMaestraDetalleESList.add(nuevo);
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
    public String seleccionarFormulaMaestraES_action()
    {
        formulaMaestraESBean=(FormulaMaestraES)formulaMaestraESDataTable.getRowData();
        return null;
    }
    public String getCargarFormulaMaestraEsVersion()
    {
        FacesContext facesContext = FacesContext.getCurrentInstance();
        ExternalContext externalContext = facesContext.getExternalContext();
        Map map = externalContext.getSessionMap();
        formulaMaestraVersionaBean = (FormulaMaestraVersion)map.get("formulaMaestraVersion");
        this.cargarFormulaMaestraEs();
        return null;
    }
    private void cargarFormulaMaestraEs()
    {
        try
        {
            con=Util.openConnection(con);
            System.out.println("cod "+formulaMaestraVersionaBean.getComponentesProd().getCodVersionActiva());
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select es.NOMBRE_ENVASESEC,es.COD_ENVASESEC,pp.NOMBRE_PRODUCTO_PRESENTACION,c.CANT_COMPPROD,"+
                             " pp.cod_presentacion,TPP.NOMBRE_TIPO_PROGRAMA_PROD,tpp.COD_TIPO_PROGRAMA_PROD"+
                             " from FORMULA_MAESTRA_VERSION fm "+
                             " inner join COMPONENTES_PRESPROD_VERSION c on c.COD_COMPPROD = fm.COD_COMPPROD" +
                             " and c.cod_version=fm.COD_COMPPROD_VERSION and c.COD_ESTADO_REGISTRO=1"+
                             " inner join PRESENTACIONES_PRODUCTO pp on pp.cod_presentacion =c.COD_PRESENTACION"+
                             " inner join ENVASES_SECUNDARIOS es on es.COD_ENVASESEC = pp.COD_ENVASESEC"+
                             " inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD =c.COD_TIPO_PROGRAMA_PROD"+
                             " where fm.COD_FORMULA_MAESTRA = '"+formulaMaestraVersionaBean.getCodFormulaMaestra()+"'" +
                             " and fm.COD_VERSION='"+formulaMaestraVersionaBean.getCodVersion()+"'";
            System.out.println("consulta cargar presentaciones secundarias "+consulta);
            ResultSet res=st.executeQuery(consulta);
            formulaMaestraESList.clear();
            while(res.next())
            {
                FormulaMaestraES nuevo=new FormulaMaestraES();
                nuevo.getPresentacionesProducto().getEnvasesSecundarios().setNombreEnvaseSec(res.getString("NOMBRE_ENVASESEC"));
                nuevo.getPresentacionesProducto().getEnvasesSecundarios().setCodEnvaseSec(res.getString("COD_ENVASESEC"));
                nuevo.getPresentacionesProducto().setNombreProductoPresentacion(res.getString("NOMBRE_PRODUCTO_PRESENTACION"));
                nuevo.getPresentacionesProducto().setCantidadPresentacion(res.getString("CANT_COMPPROD"));
                nuevo.getPresentacionesProducto().setCodPresentacion(res.getString("cod_presentacion"));
                nuevo.getPresentacionesProducto().getTiposProgramaProduccion().setCodTipoProgramaProd(res.getString("COD_TIPO_PROGRAMA_PROD"));
                nuevo.getPresentacionesProducto().getTiposProgramaProduccion().setNombreProgramaProd(res.getString("NOMBRE_TIPO_PROGRAMA_PROD"));
                formulaMaestraESList.add(nuevo);
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
    
    public String guardarEdicionFormulaMaestraDetalleEpVersion_action()throws SQLException
    {
        DaoPresentacionesPrimariasVersion daoPresentacionPrimaria = new DaoPresentacionesPrimariasVersion(LOGGER);
        List<FormulaMaestraDetalleEP> detalleEPList = new ArrayList<>();
        for(FormulaMaestraDetalleEP bean : presentacionesPrimariasEditar.getFormulaMaestraDetalleEPList())
        {
            if(bean.getChecked())detalleEPList.add(bean);
        }
        presentacionesPrimariasEditar.setFormulaMaestraDetalleEPList(detalleEPList);
        
        if(daoPresentacionPrimaria.editarConDetalleEp(presentacionesPrimariasEditar, formulaMaestraVersionaBean))
        {
            mensaje = "1";
        }
        else
        {
            mensaje = "Ocurrio un error al momento de guardar el registro,verifique los datos introducidos";
        }
        return null;
    }
    public String editarFormulasMaestradDetalleEpVersion_action()
    {
        for(PresentacionesPrimarias bean:formulaMaestraEPList)
        {
            if(bean.getChecked())
            {
                presentacionesPrimariasEditar=bean;
                break;
            }
        }
        return null;
    }
    //<editor-fold desc="empaque primario" defaultstate="collapsed">
        public String eliminarPresentacionPrimaria_action()throws SQLException
        {
            mensaje="";
            for(PresentacionesPrimarias bean : formulaMaestraEPList)
            {
                if(bean.getChecked())
                {
                    DaoPresentacionesPrimariasVersion daoFmEp = new DaoPresentacionesPrimariasVersion(LOGGER);
                    bean.setComponentesProd(formulaMaestraVersionaBean.getComponentesProd());
                    if(daoFmEp.eliminarConDetalleEp(bean, formulaMaestraVersionaBean))
                    {
                        mensaje = "1";
                        this.cargarFormulaMaestraEp();
                    }
                    else
                    {
                        mensaje = "Ocurrio un error al momento de eliminar la presentación primaria, intente de nuevo";
                    }
                    break;
                }
            }
            return null;
        }
        private void cargarEnvasesPrimariosSelectList()
        {
            DaoEnvasesPrimarios daoEnvases = new DaoEnvasesPrimarios(LOGGER);
            envasesPrimariosSelectList = daoEnvases.listarSelectItem();
        }
        private void cargarTiposProgramaProduccionSelectList()
        {
            DaoTiposProgramaProduccion daoTipo = new DaoTiposProgramaProduccion();
            tiposProgramaProduccionSelectList = daoTipo.listarSelectItem();
        }
        
        public String getCargarAgregarFormulaMaestraDetallaEpAgregar()
        {
            this.cargarEnvasesPrimariosSelectList();
            this.cargarTiposProgramaProduccionSelectList();
            presentacionesPrimariasAgregar=new PresentacionesPrimarias();
            DaoFormulaMaestraDetalleEpVersion daoFmEp = new DaoFormulaMaestraDetalleEpVersion(LOGGER);
            presentacionesPrimariasAgregar.setFormulaMaestraDetalleEPList(daoFmEp.listarAgregar());
            return null;
        }
    //</editor-fold>
    
    public String guardarFormulaMaestraDetalleEpVersion_action()throws SQLException
    {
        mensaje = "";
        DaoPresentacionesPrimariasVersion daoPresentacionPrimaria  = new DaoPresentacionesPrimariasVersion(LOGGER);
        List<FormulaMaestraDetalleEP> formulaEpAgregarList = new ArrayList<>();
        for(FormulaMaestraDetalleEP bean : presentacionesPrimariasAgregar.getFormulaMaestraDetalleEPList()){
            if(bean.getChecked()){
                formulaEpAgregarList.add(bean);
            }
        }
        presentacionesPrimariasAgregar.setFormulaMaestraDetalleEPList(formulaEpAgregarList);
        presentacionesPrimariasAgregar.setComponentesProd(formulaMaestraVersionaBean.getComponentesProd());
        if(daoPresentacionPrimaria.guardarConDetalleEp(presentacionesPrimariasAgregar, formulaMaestraVersionaBean))
        {
            mensaje = "1";
        }
        else
        {
            mensaje = "Ocurrio un error al momento de guardar el registro";
        }
        
        return null;
    }
    
    
    public String seleccionarFormulaMaestraEp_action()
    {

        formulaMaestraEPBean=(FormulaMaestraEP)formulaMaestraEpDataTable.getRowData();
        return null;
    }
    public String getCargarFormulaMaestraEPVersion()
    {
        FacesContext facesContext = FacesContext.getCurrentInstance();
        ExternalContext externalContext = facesContext.getExternalContext();
        Map map = externalContext.getSessionMap();
        formulaMaestraVersionaBean = (FormulaMaestraVersion)map.get("formulaMaestraVersion");
        this.cargarFormulaMaestraEp();
        return null;
    }
    public String getCargarEditarPresentacionPrimaria()
    {
        this.cargarEnvasesPrimariosSelectList();
        this.cargarTiposProgramaProduccionSelectList();
        DaoFormulaMaestraDetalleEpVersion daoFmEp = new DaoFormulaMaestraDetalleEpVersion(LOGGER);
        presentacionesPrimariasEditar.setFormulaMaestraDetalleEPList(daoFmEp.listarEditar(presentacionesPrimariasEditar, formulaMaestraVersionaBean));
        return null;
    }
    private void cargarFormulaMaestraEp()
    {
        DaoFormulaMaestraDetalleEpVersion daoFormulaEp = new DaoFormulaMaestraDetalleEpVersion(LOGGER);
        formulaMaestraEPList = daoFormulaEp.listarPorPresentacionPrimaria(formulaMaestraVersionaBean);
    }
    public String guardarEdicionVersionFormulaMaestra_action()throws SQLException
    {
        mensaje="";
        try
        {
            con=Util.openConnection(con);
            con.setAutoCommit(false);
            String consulta="update FORMULA_MAESTRA_VERSION set CANTIDAD_LOTE='"+formulaMaestraVersionEditar.getCantidadLote()+"',"+
                            " COD_COMPPROD='"+formulaMaestraVersionEditar.getComponentesProd().getCodCompprod()+"'," +
                            " COD_ESTADO_REGISTRO='"+formulaMaestraVersionEditar.getEstadoRegistro().getCodEstadoRegistro()+"'"+
                            " where COD_VERSION='"+formulaMaestraVersionEditar.getCodVersion()+"'" +
                            " and COD_FORMULA_MAESTRA='"+formulaMaestraVersionEditar.getCodFormulaMaestra()+"'";
            System.out.println("consulta guardar edicion version "+consulta);
            PreparedStatement pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se guardo la edicion de la version");
            con.commit();
            mensaje="1";
            pst.close();
            con.close();
        }
        catch(SQLException ex)
        {
            mensaje="Ocurrio un error al momento de guardar la edicion, intente de nuevo";
            con.rollback();
            con.close();
            ex.printStackTrace();
        }
       
        return null;
    }
    public String eliminarVersionFormulaMaestra_action()throws SQLException
    {
        mensaje="";
        for(FormulaMaestraVersion bean:formulaMaestraVersionesList)
        {
            if(bean.getChecked())
            {
                if(bean.getEstadoVersionFormulaMaestra().getCodEstadoVersionFormulaMaestra()!=2&&
                   bean.getEstadoVersionFormulaMaestra().getCodEstadoVersionFormulaMaestra()!=4)
                        {
                        try {
                            con = Util.openConnection(con);
                            con.setAutoCommit(false);
                            String consulta = "delete FORMULA_MAESTRA_VERSION_MODIFICACION where COD_VERSION_FM='"+bean.getCodVersion()+"'";
                            System.out.println("consulta delete personal version"+consulta);
                            PreparedStatement pst = con.prepareStatement(consulta);
                            if (pst.executeUpdate() > 0)System.out.println("se elimino la version");
                            consulta="delete FORMULA_MAESTRA_MR_CLASIFICACION_VERSION where COD_VERSION='"+bean.getCodVersion()+"'";
                            System.out.println("consulta delete mr clasificacion version"+consulta);
                            pst=con.prepareStatement(consulta);
                            if(pst.executeUpdate()>0)System.out.println("se elimino mr clasificacion version");
                            consulta="delete FORMULA_MAESTRA_DETALLE_MR_VERSION where COD_VERSION='"+bean.getCodVersion()+"'";
                            System.out.println("consulta delete mr version");
                            pst=con.prepareStatement(consulta);
                            if(pst.executeUpdate()>0)System.out.println("se elimino mr version");
                            consulta="delete FORMULA_MAESTRA_DETALLE_ES_VERSION where COD_VERSION='"+bean.getCodVersion()+"'";
                            System.out.println("consulta delete es version "+consulta);
                            pst=con.prepareStatement(consulta);
                            if(pst.executeUpdate()>0)System.out.println("se elimino es version");
                            consulta="delete FORMULA_MAESTRA_DETALLE_EP_VERSION where COD_VERSION='"+bean.getCodVersion()+"'";
                            System.out.println("consulta delete ep version "+consulta);
                            pst=con.prepareStatement(consulta);
                            if(pst.executeUpdate()>0)System.out.println("se elimino ep version");
                            consulta="delete FORMULA_MAESTRA_DETALLE_MP_FRACCIONES_VERSION where COD_VERSION='"+bean.getCodVersion()+"'";
                            System.out.println("consulta delete mp fraccion version "+consulta);
                            pst=con.prepareStatement(consulta);
                            if(pst.executeUpdate()>0)System.out.println("se elimino mp fraccion version");
                            consulta="delete FORMULA_MAESTRA_DETALLE_MP_VERSION where COD_VERSION='"+bean.getCodVersion()+"'";
                            System.out.println("consulta delete mp version "+consulta);
                            pst=con.prepareStatement(consulta);
                            if(pst.executeUpdate()>0)System.out.println("se elimino mp version");
                            consulta="delete FORMULA_MAESTRA_VERSION where COD_VERSION='"+bean.getCodVersion()+"'";
                            System.out.println("consulta delete cabecera version "+consulta);
                            pst=con.prepareStatement(consulta);
                            if(pst.executeUpdate()>0)System.out.println("se elimino cabecera version");
                            con.commit();
                            mensaje="1";
                            pst.close();
                            con.close();
                        }
                        catch (SQLException ex) {
                            con.rollback();
                            con.close();
                            ex.printStackTrace();
                            mensaje="Ocurrio un error al momento de eliminar la version, intente de nuevo";
                        }
                }
                else
                {
                    mensaje="No se puede eliminar una version estado: Activo u Obsoleto";
                }
            }
        }
        if(mensaje.equals("1"))
        {
            this.cargarVersionesFormulaMaestra();
        }
        return null;
    }
    public String editarFormulaMaestraDuplicada_action()
    {
        for(FormulaMaestraVersion bean:formulaMaestraVersionesList)
        {
            if(bean.getChecked())
            {
                formulaMaestraVersionEditar=bean;
            }
        }
        return null;
    }
    public String editarNuevaFormulaMaestraVersion_action()
    {
        for(FormulaMaestraVersion bean:formulasMaestrasNuevasList)
        {
            if(bean.getChecked())
            {
                formulaMaestraVersionEditar=bean;
            }
        }
        return null;
    }
    public String getCargarAgregarNuevaFormulaMaestra()
    {
        formulaMaestraVersionAbm=new FormulaMaestraVersion();
        return null;
    }
    private void cargarTiposProduccionProdSelect()
    {
        try
        {
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            String consulta = "select tp.COD_TIPO_PRODUCCION,tp.NOMBRE_TIPO_PRODUCCION from TIPOS_PRODUCCION tp order by tp.NOMBRE_TIPO_PRODUCCION";
            ResultSet res = st.executeQuery(consulta);
            tiposProduccionSelectList.clear();
            while (res.next())
            {
                tiposProduccionSelectList.add(new SelectItem(res.getInt("COD_TIPO_PRODUCCION"),res.getString("NOMBRE_TIPO_PRODUCCION")));
            }
            res.close();
            st.close();
            con.close();
        }
        catch (SQLException ex)
        {
            ex.printStackTrace();
        }
    }
    private void cargarComponentesProdSelect()
    {
        try {
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            String consulta="select cp.COD_COMPPROD,cp.nombre_prod_semiterminado"+
                            " from COMPONENTES_PROD cp where cp.COD_ESTADO_COMPPROD=1 and cp.COD_TIPO_PRODUCCION=1 "+
                            " order by cp.nombre_prod_semiterminado";
            ResultSet res=st.executeQuery(consulta);
            componentesProdSelectList.clear();
            while(res.next())
            {
                componentesProdSelectList.add(new SelectItem(res.getString("COD_COMPPROD"),res.getString("nombre_prod_semiterminado")));
            }
            res.close();
            st.close();
            con.close();
        }
        catch (SQLException ex) {
            ex.printStackTrace();
        }
    }
    public String getCargarFormulasMaestrasNuevas()
    {
        this.cargarComponentesProdSelect();
        this.cargarTiposProduccionProdSelect();
        this.cargarFormulasMaestrasNuevas_action();
        this.cargarAreaEmpresaPersonal();
        return null;
    }
    
    private void cargarFormulasMaestrasNuevas_action()
    {
        try
        {
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select f.COD_VERSION,f.COD_FORMULA_MAESTRA, f.COD_COMPPROD,cp.nombre_prod_semiterminado,f.CANTIDAD_LOTE,"+
                            " f.COD_ESTADO_REGISTRO,er.NOMBRE_ESTADO_REGISTRO,ev.COD_ESTADO_VERSION_FORMULA_MAESTRA,"+
                            " ev.NOMBRE_ESTADO_VERSION_FORMULA_MAESTRA" +
                            " ,tp.COD_TIPO_PRODUCCION,tp.NOMBRE_TIPO_PRODUCCION" +
                            " ,(p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL+' '+p.nombre2_personal) as nombrePersonal" +
                            " ,f.FECHA_MODIFICACION,f.MODIFICACION_NF,f.MODIFICACION_MP_EP,f.MODIFICACION_ES,f.MODIFICACION_R"+
                            " from FORMULA_MAESTRA_VERSION f "+
                            " inner join COMPONENTES_PROD cp on cp.COD_COMPPROD=f.COD_COMPPROD"+
                            " inner join ESTADOS_REFERENCIALES er on er.COD_ESTADO_REGISTRO=f.COD_ESTADO_REGISTRO"+
                            " inner join ESTADOS_VERSION_FORMULA_MAESTRA ev on ev.COD_ESTADO_VERSION_FORMULA_MAESTRA=f.COD_ESTADO_VERSION_FORMULA_MAESTRA" +
                            " inner join TIPOS_PRODUCCION tp on tp.COD_TIPO_PRODUCCION=cp.COD_TIPO_PRODUCCION" +
                            " inner join PERSONAL p on p.COD_PERSONAL=f.COD_PERSONAL_CREACION"+
                            "  where f.COD_FORMULA_MAESTRA<0"+
                            " order by cp.nombre_prod_semiterminado";
            System.out.println("consulta cargar nuevas formulas "+consulta);
            ResultSet res=st.executeQuery(consulta);
            Statement stDetalle=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet resDetalle=null;
            formulasMaestrasNuevasList.clear();
            while(res.next())
            {
                FormulaMaestraVersion nuevo=new FormulaMaestraVersion();
                nuevo.setModificacionNF(res.getInt("MODIFICACION_NF")>0);
                nuevo.setModificacionMPEP(res.getInt("MODIFICACION_MP_EP")>0);
                nuevo.setModificacionES(res.getInt("MODIFICACION_ES")>0);
                nuevo.setModificacionR(res.getInt("MODIFICACION_R")>0);
                nuevo.setCodVersion(res.getInt("COD_VERSION"));
                nuevo.setCodFormulaMaestra(res.getString("COD_FORMULA_MAESTRA"));
                nuevo.getComponentesProd().setCodCompprod(res.getString("COD_COMPPROD"));
                nuevo.getComponentesProd().setNombreProdSemiterminado(res.getString("nombre_prod_semiterminado"));
                nuevo.setCantidadLote(res.getDouble("CANTIDAD_LOTE"));
                nuevo.getEstadoRegistro().setCodEstadoRegistro(res.getString("COD_ESTADO_REGISTRO"));
                nuevo.getEstadoRegistro().setNombreEstadoRegistro(res.getString("NOMBRE_ESTADO_REGISTRO"));
                nuevo.getEstadoVersionFormulaMaestra().setCodEstadoVersionFormulaMaestra(res.getInt("COD_ESTADO_VERSION_FORMULA_MAESTRA"));
                nuevo.getEstadoVersionFormulaMaestra().setNombreEstadoVersionFormulaMaestra(res.getString("NOMBRE_ESTADO_VERSION_FORMULA_MAESTRA"));
                nuevo.getComponentesProd().getTipoProduccion().setCodTipoProduccion(res.getInt("COD_TIPO_PRODUCCION"));
                nuevo.getComponentesProd().getTipoProduccion().setNombreTipoProduccion(res.getString("NOMBRE_TIPO_PRODUCCION"));
                nuevo.getPersonalCreacion().setNombrePersonal(res.getString("nombrePersonal"));
                nuevo.setFechaModificacion(res.getTimestamp("FECHA_MODIFICACION"));
                List<FormulaMaestraVersionModificacion> formulaMaestraVersionModificacionList=new ArrayList<FormulaMaestraVersionModificacion>();
                consulta="select f.COD_PERSONAL,(p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+NOMBRES_PERSONAL+' '+p.nombre2_personal) as nombresPersonal,evfm.NOMBRE_ESTADO_VERSION_FORMULA_MAESTRA" +
                         " ,evfm.NOMBRE_ESTADO_VERSION_FORMULA_MAESTRA"+
                         " from FORMULA_MAESTRA_VERSION_MODIFICACION f "+
                         " inner join PERSONAL p on p.COD_PERSONAL=f.COD_PERSONAL" +
                         " inner join ESTADOS_VERSION_FORMULA_MAESTRA evfm on evfm.COD_ESTADO_VERSION_FORMULA_MAESTRA=f.COD_ESTADO_VERSION_FORMULA_MAESTRA"+
                         " WHERE F.COD_VERSION_FM='"+nuevo.getCodVersion()+"' order by 2";
                resDetalle=stDetalle.executeQuery(consulta);
                while(resDetalle.next())
                {
                    FormulaMaestraVersionModificacion n1=new FormulaMaestraVersionModificacion();
                    n1.getPersonal().setCodPersonal(resDetalle.getString("COD_PERSONAL"));
                    n1.getPersonal().setNombrePersonal(resDetalle.getString("nombresPersonal"));
                    n1.getEstadosVersionFormulaMaestra().setNombreEstadoVersionFormulaMaestra(resDetalle.getString("NOMBRE_ESTADO_VERSION_FORMULA_MAESTRA"));
                    formulaMaestraVersionModificacionList.add(n1);
                }
                if(formulaMaestraVersionModificacionList.size()>0)nuevo.setFormulaMaestraVersionModificacionList(formulaMaestraVersionModificacionList);
                formulasMaestrasNuevasList.add(nuevo);
            }
            stDetalle.close();
            res.close();
            st.close();
            con.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
    }
    public String revisarVersionFormulaMaestra_action()
    {
        for(FormulaMaestraVersion bean:formulaMaestraVersionAprobarList)
        {
            if(bean.getChecked())
            {
                formulaMaestraVersionRevisar=bean;
            }
        }
        return null;
    }
    public String getCargarFormulaMaestraEnAprobacion()
    {
        this.cargarFormulaMaestraAprovacion();
        return null;
    }
    private void cargarFormulaMaestraAprovacion()
    {
        try
        {
            con=Util.openConnection(con);
            String consulta="select fmv.COD_VERSION,fmv.NRO_VERSION,fmv.COD_FORMULA_MAESTRA,cp.nombre_prod_semiterminado,"+
                            " fmv.CANTIDAD_LOTE,fmv.FECHA_MODIFICACION,"+
                            " (p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL+' '+p.nombre2_personal) as nombrePersonal,"+
                            " tp.NOMBRE_TIPO_PRODUCCION,er.NOMBRE_ESTADO_REGISTRO,fmv.MODIFICACION_NF,fmv.MODIFICACION_MP_EP,fmv.MODIFICACION_ES,fmv.MODIFICACION_R"+
                            " from FORMULA_MAESTRA_VERSION fmv inner join COMPONENTES_PROD cp ON"+
                            " fmv.COD_COMPPROD=cp.COD_COMPPROD " +
                            " inner join TIPOS_PRODUCCION tp on tp.COD_TIPO_PRODUCCION=cp.COD_TIPO_PRODUCCION"+
                            " inner join personal p on p.COD_PERSONAL=fmv.COD_PERSONAL_CREACION"+
                            " inner join ESTADOS_REFERENCIALES er on er.COD_ESTADO_REGISTRO=fmv.COD_ESTADO_REGISTRO"+
                            " where fmv.COD_ESTADO_VERSION_FORMULA_MAESTRA=3" +
                            " order by cp.nombre_prod_semiterminado,fmv.FECHA_MODIFICACION";
            System.out.println("consulta cargar versiones "+consulta);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta);
            Statement stDetalle=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet resDetalle=null;
            formulaMaestraVersionAprobarList.clear();
            while(res.next())
            {
                FormulaMaestraVersion nuevo=new FormulaMaestraVersion();
                nuevo.setModificacionNF(res.getInt("MODIFICACION_NF")>0);
                nuevo.setModificacionMPEP(res.getInt("MODIFICACION_MP_EP")>0);
                nuevo.setModificacionES(res.getInt("MODIFICACION_ES")>0);
                nuevo.setModificacionR(res.getInt("MODIFICACION_R")>0);
                nuevo.setCodFormulaMaestra(res.getString("COD_FORMULA_MAESTRA"));
                nuevo.getComponentesProd().setNombreProdSemiterminado(res.getString("nombre_prod_semiterminado"));
                nuevo.setCodVersion(res.getInt("COD_VERSION"));
                nuevo.setNroVersion(res.getInt("NRO_VERSION"));
                nuevo.setCantidadLote(res.getDouble("CANTIDAD_LOTE"));
                nuevo.setFechaModificacion(res.getTimestamp("FECHA_MODIFICACION"));
                nuevo.getPersonalCreacion().setNombrePersonal(res.getString("nombrePersonal"));
                nuevo.getComponentesProd().getTipoProduccion().setNombreTipoProduccion(res.getString("NOMBRE_TIPO_PRODUCCION"));
                nuevo.getEstadoRegistro().setNombreEstadoRegistro(res.getString("NOMBRE_ESTADO_REGISTRO"));
                List<FormulaMaestraVersionModificacion> formulaMaestraVersionModificacionList=new ArrayList<FormulaMaestraVersionModificacion>();
                consulta="select f.COD_PERSONAL,(p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+NOMBRES_PERSONAL+' '+p.nombre2_personal) as nombresPersonal,evfm.NOMBRE_ESTADO_VERSION_FORMULA_MAESTRA" +
                         " ,evfm.NOMBRE_ESTADO_VERSION_FORMULA_MAESTRA"+
                         " from FORMULA_MAESTRA_VERSION_MODIFICACION f "+
                         " inner join PERSONAL p on p.COD_PERSONAL=f.COD_PERSONAL" +
                         " inner join ESTADOS_VERSION_FORMULA_MAESTRA evfm on evfm.COD_ESTADO_VERSION_FORMULA_MAESTRA=f.COD_ESTADO_VERSION_FORMULA_MAESTRA"+
                         " WHERE F.COD_VERSION_FM='"+nuevo.getCodVersion()+"' order by 2";
                resDetalle=stDetalle.executeQuery(consulta);
                while(resDetalle.next())
                {
                    FormulaMaestraVersionModificacion n1=new FormulaMaestraVersionModificacion();
                    n1.getPersonal().setCodPersonal(resDetalle.getString("COD_PERSONAL"));
                    n1.getPersonal().setNombrePersonal(resDetalle.getString("nombresPersonal"));
                    n1.getEstadosVersionFormulaMaestra().setNombreEstadoVersionFormulaMaestra(resDetalle.getString("NOMBRE_ESTADO_VERSION_FORMULA_MAESTRA"));
                    formulaMaestraVersionModificacionList.add(n1);
                }
                if(formulaMaestraVersionModificacionList.size()>0)nuevo.setFormulaMaestraVersionModificacionList(formulaMaestraVersionModificacionList);
                formulaMaestraVersionAprobarList.add(nuevo);
            }
            resDetalle.close();
            res.close();
            st.close();
            con.close();

        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
    }
    public String recalcularFraccionesDesviacionFormulaMaestraDetalleMp_action()
    {
        Double cantidadTotal=formulaMaestraDetalleMPBean.getCantidadTotalGramos();
        formulaMaestraDetalleMPBean.setFormulaMaestraDetalleMPfraccionesList(new ArrayList<FormulaMaestraDetalleMPfracciones>());
        while(cantidadTotal>0)
        {
            FormulaMaestraDetalleMPfracciones nuevo=new FormulaMaestraDetalleMPfracciones();
            nuevo.setCantidad(cantidadTotal>formulaMaestraDetalleMPBean.getCantidadMaximaMaterialPorFraccion()?formulaMaestraDetalleMPBean.getCantidadMaximaMaterialPorFraccion():cantidadTotal);
            formulaMaestraDetalleMPBean.getFormulaMaestraDetalleMPfraccionesList().add(nuevo);
            cantidadTotal-=formulaMaestraDetalleMPBean.getCantidadMaximaMaterialPorFraccion();
            
        }
        return null;
    }
    public String agregarFraccionDesviacionFormulaMaestraDetalleMp_action()
    {
        FormulaMaestraDetalleMPfracciones nuevo=new FormulaMaestraDetalleMPfracciones();
        formulaMaestraDetalleMPBean.getFormulaMaestraDetalleMPfraccionesList().add(nuevo);
        return null;
    }
    public String eliminarFraccionDesviacionFormulaMaestraDetalleMp_action()
    {
        for(FormulaMaestraDetalleMPfracciones bean:formulaMaestraDetalleMPBean.getFormulaMaestraDetalleMPfraccionesList())
        {
            if(bean.getChecked())
            {
                formulaMaestraDetalleMPBean.getFormulaMaestraDetalleMPfraccionesList().remove(bean);
                break;
            }
        }
        return null;
    }
    public String seleccionesFormulaMaestraDetalleMPVersion_action()
    {
        formulaMaestraDetalleMPBean=new FormulaMaestraDetalleMP();
        Map<String,String> params=FacesContext.getCurrentInstance().getExternalContext().getRequestParameterMap();
        int codTipoMaterialProduccion=Integer.valueOf(params.get("codTipoMaterial"));
        String codMaterial=params.get("codMaterial");
        for(TiposMaterialProduccion bean:formulaMaestraDetalleMPList)
        {
            if(bean.getCodTipoMaterialProduccion()==codTipoMaterialProduccion)
            {
                for(FormulaMaestraDetalleMP bean1:bean.getFormulaMaestraDetalleMPList())
                {
                    if(bean1.getMateriales().getCodMaterial().equals(codMaterial))
                    {
                        formulaMaestraDetalleMPBean=bean1;
                        break;
                    }
                }
            }
        }
        return null;
    }
    public String guardarAgregarFormulaMaestraDetalleMpVersion_action()throws SQLException
    {
        mensaje="";
        DaoFormulaMaestraDetalleMpVersion daoFmMp = new DaoFormulaMaestraDetalleMpVersion(LOGGER);
        List<FormulaMaestraDetalleMP> formulaMpAgregarList = new ArrayList<>();
        for(FormulaMaestraDetalleMP bean : formulaMaestraDetalleMPAgregarList){
            if(bean.getChecked()){
                formulaMpAgregarList.add(bean);
            }
        }
        if(daoFmMp.guardarLista(formulaMpAgregarList, formulaMaestraVersionaBean)){
            mensaje = "1";
        }
        else{
            mensaje = "Ocurrio un error al momento de registrar los materiales, intente de nuevo";
        }
        return null;
    }
    private void cargarTiposMaterialProduccionSelect()
    {
        try
        {
            con=Util.openConnection(con);
            Statement st =con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select tp.COD_TIPO_MATERIAL_PRODUCCION,tp.NOMBRE_TIPO_MATERIAL_PRODUCCION"+
                            " from TIPOS_MATERIAL_PRODUCCION tp order by tp.NOMBRE_TIPO_MATERIAL_PRODUCCION";
            ResultSet res=st.executeQuery(consulta);
            tiposMaterialProduccionSelectList.clear();
            tiposMaterialProduccionSelectList.add(new SelectItem(0,"--Ninguno--"));
            while(res.next())
            {
                tiposMaterialProduccionSelectList.add(new SelectItem(res.getInt("COD_TIPO_MATERIAL_PRODUCCION"),res.getString("NOMBRE_TIPO_MATERIAL_PRODUCCION")));
            }
            st.close();
            con.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
    }
    public String getCargarFormulaMaestraDetalleMpFracciones()
    {
        this.cargarTiposMaterialProduccionSelect();
        try
        {
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select f.COD_FORMULA_MAESTRA_FRACCIONES,f.CANTIDAD,f.COD_TIPO_MATERIAL_PRODUCCION"+
                            " from FORMULA_MAESTRA_DETALLE_MP_FRACCIONES_VERSION f"+
                            " where f.COD_FORMULA_MAESTRA='"+formulaMaestraVersionaBean.getCodFormulaMaestra()+"'" +
                            " and f.COD_MATERIAL='"+formulaMaestraDetalleMPBean.getMateriales().getCodMaterial()+"'" +
                            " and f.COD_VERSION='"+formulaMaestraVersionaBean.getCodVersion()+"'" +
                            " order by f.COD_FORMULA_MAESTRA_FRACCIONES";
            System.out.println("consulta cargar fracciones material "+consulta);
            ResultSet res=st.executeQuery(consulta);
            formulaMaestraDetalleMPfraccionesEditar.clear();
            while(res.next())
            {
                FormulaMaestraDetalleMPfracciones nuevo= new FormulaMaestraDetalleMPfracciones();
                nuevo.setCodFormulaMaestraFracciones(res.getString("COD_FORMULA_MAESTRA_FRACCIONES"));
                nuevo.setCantidad(res.getDouble("CANTIDAD"));
                nuevo.getTiposMaterialProduccion().setCodTipoMaterialProduccion(res.getInt("COD_TIPO_MATERIAL_PRODUCCION"));
                formulaMaestraDetalleMPfraccionesEditar.add(nuevo);
            }
            st.close();
            con.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
        return null;
    }

    public String getCargarAgregarMaterialesFormulaMaestraMP() {

        DaoFormulaMaestraDetalleMpVersion daoFormulaMp = new DaoFormulaMaestraDetalleMpVersion(LOGGER);
        formulaMaestraDetalleMPAgregarList = daoFormulaMp.listaAgregar(formulaMaestraVersionaBean.getCodVersion(), tiposMaterialProduccionAgregar.getCodTipoMaterialProduccion());
        return null;
    }

    public String eliminarFormulaMaestraDetalleMP_action()throws SQLException
    {
        mensaje="";
        List<FormulaMaestraDetalleMP> formulaMpEliminarList = new ArrayList<FormulaMaestraDetalleMP>();
        for(TiposMaterialProduccion tipo:formulaMaestraDetalleMPList)
        {
            for(FormulaMaestraDetalleMP bean:tipo.getFormulaMaestraDetalleMPList())
            {
                if(bean.getChecked())
                {
                    formulaMpEliminarList.add(bean);
                }
            }
        }
        DaoFormulaMaestraDetalleMpVersion daoMpVersion = new DaoFormulaMaestraDetalleMpVersion(LOGGER);
        if(daoMpVersion.eliminarLista(formulaMpEliminarList))
        {
            mensaje = "1";
            this.cargarFormulaMaestraDetalleMPVersion();
        }
        return null;
    }
    public String editarFormulaMaestraDetalleMp_action()
    {
        formulaMaestraDetalleMPEditarList.clear();
        for(TiposMaterialProduccion tipo:formulaMaestraDetalleMPList)
        {
            for(FormulaMaestraDetalleMP bean:tipo.getFormulaMaestraDetalleMPList())
            {
                if(bean.getChecked())
                {
                    formulaMaestraDetalleMPEditarList.add(bean);
                }
            }
        }
        return null;
    }
    public String guardarEdicionFormulaMaestraDetalleMp_action()throws SQLException
    {
        mensaje="";
        DaoFormulaMaestraDetalleMpVersion daoFormulaMp = new DaoFormulaMaestraDetalleMpVersion(LOGGER);
        if(daoFormulaMp.editarLista(formulaMaestraDetalleMPEditarList, formulaMaestraVersionaBean)){
            mensaje = "1";
        }
        else{
            mensaje = "Ocurrio un error al momento de guardar la edicion,intente de nuevo";
        }
        return null;
    }
    public String seleccionarFormulaMaestraNuevaVersion()
    {
        formulaMaestraVersionaBean=(FormulaMaestraVersion)formulasMaestrasNuevasDataTable.getRowData();
        return null;
    }
    public String seleccionarFormulaMaestraVersion()
    {
        formulaMaestraVersionaBean=(FormulaMaestraVersion)formulaMaestraVersionesData.getRowData();
        return null;
    }
    public double redondear(double numero, int decimales) 
    {
        LOGGER.debug("numero "+String.valueOf(numero));
        BigDecimal decimal=new BigDecimal(String.valueOf(numero));
        return decimal.setScale(decimales, BigDecimal.ROUND_HALF_EVEN).doubleValue();
    }
  
    public String getCargarFormulaMaestraDetalleMPVersion()
    {
        FacesContext facesContext = FacesContext.getCurrentInstance();
        ExternalContext externalContext = facesContext.getExternalContext();
        Map map = externalContext.getSessionMap();
        formulaMaestraVersionaBean = (FormulaMaestraVersion)map.get("formulaMaestraVersion");
        this.cargarFormulaMaestraDetalleMPVersion();
        return null;
    }
    public String agregarFormulaMaestraDetalleMp_action()
    {
        tiposMaterialProduccionAgregar=new TiposMaterialProduccion();
        tiposMaterialProduccionAgregar.setCodTipoMaterialProduccion(1);
        return null;
    }
    public String agregarFormulaMaestraDetalleMpRecubrimiento_action()
    {
        tiposMaterialProduccionAgregar=new TiposMaterialProduccion();
        tiposMaterialProduccionAgregar.setCodTipoMaterialProduccion(2);
        return null;
    }
    public String completarEditarFraccionesFormulaMaestraDetalleMp_action()throws SQLException
    {
        mensaje = "";
        
        DaoFormulaMaestraDetalleMpFraccionesVersion  daoFmFraccion=new DaoFormulaMaestraDetalleMpFraccionesVersion(LOGGER);
        if(daoFmFraccion.registrarFormulaMaestraDetalleMpFraccionesVersion(formulaMaestraDetalleMPBean))
        {
            mensaje="1";
        }
        else
        {
            mensaje="Ocurrio un error el momento de registrar las fracciones, intente de nuevo";
        }
        if(mensaje.equals("1"))
        {
            this.cargarFormulaMaestraDetalleMPVersion();
        }
        return null;
    }
    
    private void cargarFormulaMaestraDetalleMPVersion()
    {
        DaoFormulaMaestraDetalleMpVersion daoFmMp=new DaoFormulaMaestraDetalleMpVersion(LOGGER);
        formulaMaestraDetalleMPList=daoFmMp.getFormulaMaestraDetalleMpGroupByTiposMaterialProduccionList(formulaMaestraVersionaBean);
    }
    public String getCargarVersionesFormulaMaestra()
    {
        FacesContext facesContext = FacesContext.getCurrentInstance();
        ExternalContext externalContext = facesContext.getExternalContext();
        Map map = externalContext.getSessionMap();
        formulaMaestraBean = (FormulaMaestra)map.get("formulaMaestra");
        this.cargarVersionesFormulaMaestra();
        this.cargarAreaEmpresaPersonal();
        return null;
    }
    private void cargarVersionesFormulaMaestra()
    {
        try
        {
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select isnull(fmv.COD_COMPPROD_VERSION,0) as COD_COMPPROD_VERSION,fmv.COD_FORMULA_MAESTRA,fmv.CANTIDAD_LOTE,fmv.COD_ESTADO_REGISTRO,er.NOMBRE_ESTADO_REGISTRO,fmv.FECHA_MODIFICACION,fmv.NRO_VERSION,fmv.COD_VERSION" +
                            ",evf.COD_ESTADO_VERSION_FORMULA_MAESTRA,evf.NOMBRE_ESTADO_VERSION_FORMULA_MAESTRA,fmv.FECHA_INICIO_VIGENCIA" +
                            " ,cp.nombre_prod_semiterminado,tp.NOMBRE_TIPO_PRODUCCION"+
                            " ,fmv.COD_COMPPROD,fmv.MODIFICACION_NF,fmv.MODIFICACION_MP_EP,fmv.MODIFICACION_ES,fmv.MODIFICACION_R"+
                            " ,(p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL+' '+p.nombre2_personal)as personalCreacion" +
                            " from FORMULA_MAESTRA_VERSION fmv inner join ESTADOS_REFERENCIALES er on "+
                            " fmv.COD_ESTADO_REGISTRO=er.COD_ESTADO_REGISTRO inner join ESTADOS_VERSION_FORMULA_MAESTRA evf on evf.COD_ESTADO_VERSION_FORMULA_MAESTRA=fmv.COD_ESTADO_VERSION_FORMULA_MAESTRA" +
                            " inner join COMPONENTES_PROD cp on cp.COD_COMPPROD=fmv.COD_COMPPROD"+
                            " inner join TIPOS_PRODUCCION tp on tp.COD_TIPO_PRODUCCION=cp.COD_TIPO_PRODUCCION" +
                            " inner join PERSONAL p on p.COD_PERSONAL=fmv.COD_PERSONAL_CREACION"+
                            " where fmv.COD_FORMULA_MAESTRA='"+formulaMaestraBean.getCodFormulaMaestra()+"'"+
                            " order by fmv.NRO_VERSION";
            LOGGER.debug("consulta cargar versiones fm  "+consulta);
            ResultSet res=st.executeQuery(consulta);
            Statement stDetalle=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet resDetalle=null;
            formulaMaestraVersionesList.clear();
            while(res.next())
            {
                FormulaMaestraVersion nuevo=new FormulaMaestraVersion();
                nuevo.setModificacionNF(res.getInt("MODIFICACION_NF")>0);
                nuevo.setModificacionMPEP(res.getInt("MODIFICACION_MP_EP")>0);
                nuevo.setModificacionES(res.getInt("MODIFICACION_ES")>0);
                nuevo.setModificacionR(res.getInt("MODIFICACION_R")>0);
                nuevo.getComponentesProd().setCodVersionActiva(res.getInt("COD_COMPPROD_VERSION"));
                nuevo.getComponentesProd().setNombreProdSemiterminado(res.getString("nombre_prod_semiterminado"));
                nuevo.getComponentesProd().getTipoProduccion().setNombreTipoProduccion(res.getString("NOMBRE_TIPO_PRODUCCION"));
                nuevo.getEstadoVersionFormulaMaestra().setCodEstadoVersionFormulaMaestra(res.getInt("COD_ESTADO_VERSION_FORMULA_MAESTRA"));
                nuevo.getEstadoVersionFormulaMaestra().setNombreEstadoVersionFormulaMaestra(res.getString("NOMBRE_ESTADO_VERSION_FORMULA_MAESTRA"));
                nuevo.getComponentesProd().setCodCompprod(res.getString("COD_COMPPROD"));
                nuevo.setCodFormulaMaestra(res.getString("COD_FORMULA_MAESTRA"));
                nuevo.setCantidadLote(res.getDouble("CANTIDAD_LOTE"));
                nuevo.getEstadoRegistro().setCodEstadoRegistro(res.getString("COD_ESTADO_REGISTRO"));
                nuevo.getEstadoRegistro().setNombreEstadoRegistro(res.getString("NOMBRE_ESTADO_REGISTRO"));
                nuevo.setFechaModificacion(res.getTimestamp("FECHA_MODIFICACION"));
                nuevo.setFechaInicioVigencia(res.getTimestamp("FECHA_INICIO_VIGENCIA"));
                nuevo.getPersonalCreacion().setNombrePersonal(res.getString("personalCreacion"));
                nuevo.setCodVersion(res.getInt("COD_VERSION"));
                nuevo.setNroVersion(res.getInt("NRO_VERSION"));
                List<FormulaMaestraVersionModificacion> formulaMaestraVersionModificacionList=new ArrayList<FormulaMaestraVersionModificacion>();
                consulta="select f.COD_PERSONAL,(p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+NOMBRES_PERSONAL+' '+p.nombre2_personal) as nombresPersonal,evfm.NOMBRE_ESTADO_VERSION_FORMULA_MAESTRA" +
                         " ,evfm.NOMBRE_ESTADO_VERSION_FORMULA_MAESTRA"+
                         " from FORMULA_MAESTRA_VERSION_MODIFICACION f "+
                         " inner join PERSONAL p on p.COD_PERSONAL=f.COD_PERSONAL" +
                         " inner join ESTADOS_VERSION_FORMULA_MAESTRA evfm on evfm.COD_ESTADO_VERSION_FORMULA_MAESTRA=f.COD_ESTADO_VERSION_FORMULA_MAESTRA"+
                         " WHERE F.COD_VERSION_FM='"+nuevo.getCodVersion()+"' order by 2";
                resDetalle=stDetalle.executeQuery(consulta);
                while(resDetalle.next())
                {
                    FormulaMaestraVersionModificacion n1=new FormulaMaestraVersionModificacion();
                    n1.getPersonal().setCodPersonal(resDetalle.getString("COD_PERSONAL"));
                    n1.getPersonal().setNombrePersonal(resDetalle.getString("nombresPersonal"));
                    n1.getEstadosVersionFormulaMaestra().setNombreEstadoVersionFormulaMaestra(resDetalle.getString("NOMBRE_ESTADO_VERSION_FORMULA_MAESTRA"));
                    formulaMaestraVersionModificacionList.add(n1);
                }
                if(formulaMaestraVersionModificacionList.size()>0)nuevo.setFormulaMaestraVersionModificacionList(formulaMaestraVersionModificacionList);
                formulaMaestraVersionesList.add(nuevo);
            }
            if(resDetalle!=null)resDetalle.close();
            stDetalle.close();
            res.close();
            st.close();
            con.close();
        }
        catch(SQLException ex)
        {
            LOGGER.warn("error",ex);
        }
    }

    public String guardarFormulaMaestraDetalleMpFracccionesVersion_action()throws SQLException
    {
        mensaje="";
        try
        {
            con=Util.openConnection(con);
            con.setAutoCommit(false);
            String consulta="delete FORMULA_MAESTRA_DETALLE_MP_FRACCIONES_VERSION where COD_FORMULA_MAESTRA='"+formulaMaestraVersionaBean.getCodFormulaMaestra()+"'" +
                            " and COD_MATERIAL='"+formulaMaestraDetalleMPBean.getMateriales().getCodMaterial()+"' and COD_VERSION='"+formulaMaestraVersionaBean.getCodVersion()+"'";
            System.out.println("consulta delete fracciones version "+consulta);
            PreparedStatement pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se eliminaron las fracciones anteriores");
            
            for(FormulaMaestraDetalleMPfracciones bean:formulaMaestraDetalleMPfraccionesEditar)
            {
                consulta="INSERT INTO FORMULA_MAESTRA_DETALLE_MP_FRACCIONES_VERSION(COD_VERSION,"+
                        " COD_FORMULA_MAESTRA, COD_MATERIAL, COD_FORMULA_MAESTRA_FRACCIONES, CANTIDAD,COD_TIPO_MATERIAL_PRODUCCION,PORCIENTO_FRACCION)"+
                        " VALUES ('"+formulaMaestraVersionaBean.getCodVersion()+"','"+formulaMaestraVersionaBean.getCodFormulaMaestra()+"'," +
                        "'"+formulaMaestraDetalleMPBean.getMateriales().getCodMaterial()+"','"+bean.getCodFormulaMaestraFracciones()+"' ," +
                        "'"+bean.getCantidad()+"','"+bean.getTiposMaterialProduccion().getCodTipoMaterialProduccion()+"',?)";
                System.out.println("consulta guardar formula maestra fracciones "+consulta);
                pst=con.prepareStatement(consulta);
                pst.setDouble(1,bean.getCantidad()/formulaMaestraDetalleMPBean.getCantidad()*100);
                if(pst.executeUpdate()>0)System.out.println("se registro la fraccion");
            }
            con.commit();
            mensaje="1";
            pst.close();
            con.close();
        }
        catch(SQLException ex)
        {
            mensaje="Ocurrio un error al momento de guardar las fracciones, intente de nuevo";
            con.rollback();
            con.close();
            ex.printStackTrace();
        }
        return null;
    }
   
    public String aprobarVersionFormulaMaestra_action()throws SQLException
    {
        mensaje="1";
        this.prepararEnvioCorreo();
        try
        {
            con=Util.openConnection(con);
            con.setAutoCommit(false);
            String consulta="";
            PreparedStatement pst=null;
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=null;
            SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
            consulta="select isnull(max(c.COD_VERSION),0) as COD_VERSION from COMPONENTES_PROD_VERSION c where c.cod_estado_version=2"+
                     " and c.COD_COMPPROD='"+formulaMaestraVersionRevisar.getComponentesProd().getCodCompprod()+"'";
            System.out.println("consulta buscar version producto actual "+consulta);
            res=st.executeQuery(consulta);
            int codVersionProducto=0;
            if(res.next())
            {
                codVersionProducto=res.getInt("COD_VERSION");
            }
            if(Integer.valueOf(formulaMaestraVersionRevisar.getCodFormulaMaestra())<0)
            {
                consulta="select isnull(MAX(f.COD_FORMULA_MAESTRA),0)+1 as codFormula from FORMULA_MAESTRA f";
                res=st.executeQuery(consulta);
                int codFormulaMaestra=0;
                if(res.next())
                {
                    codFormulaMaestra=res.getInt("codFormula");
                }
                consulta="update FORMULA_MAESTRA_VERSION set COD_FORMULA_MAESTRA='"+codFormulaMaestra+"',COD_ESTADO_VERSION_FORMULA_MAESTRA=2,FECHA_INICIO_VIGENCIA='"+sdf.format(new Date())+"'" +
                        " ,COD_COMPPROD_VERSION='"+codVersionProducto+"' "+
                        " WHERE COD_VERSION='"+formulaMaestraVersionRevisar.getCodVersion()+"' and COD_FORMULA_MAESTRA='"+formulaMaestraVersionRevisar.getCodFormulaMaestra()+"'";
                System.out.println("consulta update version nueva "+consulta);
                pst=con.prepareStatement(consulta);
                if(pst.executeUpdate()>0)System.out.println("se cambio el codigo de formula");
                consulta="update FORMULA_MAESTRA_DETALLE_MP_VERSION set COD_FORMULA_MAESTRA='"+codFormulaMaestra+"'"+
                        " WHERE COD_VERSION='"+formulaMaestraVersionRevisar.getCodVersion()+"' and COD_FORMULA_MAESTRA='"+formulaMaestraVersionRevisar.getCodFormulaMaestra()+"'";
                System.out.println("consulta update version nueva "+consulta);
                pst=con.prepareStatement(consulta);
                if(pst.executeUpdate()>0)System.out.println("se cambio el codigo de formula");
                consulta="update FORMULA_MAESTRA_DETALLE_MP_FRACCIONES_VERSION set COD_FORMULA_MAESTRA='"+codFormulaMaestra+"'"+
                        " WHERE COD_VERSION='"+formulaMaestraVersionRevisar.getCodVersion()+"' and COD_FORMULA_MAESTRA='"+formulaMaestraVersionRevisar.getCodFormulaMaestra()+"'";
                System.out.println("consulta update version nueva "+consulta);
                pst=con.prepareStatement(consulta);
                if(pst.executeUpdate()>0)System.out.println("se cambio el codigo de formula");

                consulta="update FORMULA_MAESTRA_DETALLE_EP_VERSION set COD_FORMULA_MAESTRA='"+codFormulaMaestra+"'"+
                        " WHERE COD_VERSION='"+formulaMaestraVersionRevisar.getCodVersion()+"' and COD_FORMULA_MAESTRA='"+formulaMaestraVersionRevisar.getCodFormulaMaestra()+"'";
                System.out.println("consulta update version nueva "+consulta);
                pst=con.prepareStatement(consulta);
                if(pst.executeUpdate()>0)System.out.println("se cambio el codigo de formula");

                consulta="update FORMULA_MAESTRA_DETALLE_ES_VERSION set COD_FORMULA_MAESTRA='"+codFormulaMaestra+"'"+
                        " WHERE COD_VERSION='"+formulaMaestraVersionRevisar.getCodVersion()+"' and COD_FORMULA_MAESTRA='"+formulaMaestraVersionRevisar.getCodFormulaMaestra()+"'";
                System.out.println("consulta update version nueva "+consulta);
                pst=con.prepareStatement(consulta);
                if(pst.executeUpdate()>0)System.out.println("se cambio el codigo de formula");

                consulta="update FORMULA_MAESTRA_DETALLE_MR_VERSION set COD_FORMULA_MAESTRA='"+codFormulaMaestra+"'"+
                        " WHERE COD_VERSION='"+formulaMaestraVersionRevisar.getCodVersion()+"' and COD_FORMULA_MAESTRA='"+formulaMaestraVersionRevisar.getCodFormulaMaestra()+"'";
                System.out.println("consulta update version nueva "+consulta);
                pst=con.prepareStatement(consulta);
                if(pst.executeUpdate()>0)System.out.println("se cambio el codigo de formula");

                consulta="update FORMULA_MAESTRA_MR_CLASIFICACION_VERSION set COD_FORMULA_MAESTRA='"+codFormulaMaestra+"'"+
                        " WHERE COD_VERSION='"+formulaMaestraVersionRevisar.getCodVersion()+"' and COD_FORMULA_MAESTRA='"+formulaMaestraVersionRevisar.getCodFormulaMaestra()+"'";
                System.out.println("consulta update version nueva "+consulta);
                pst=con.prepareStatement(consulta);
                if(pst.executeUpdate()>0)System.out.println("se cambio el codigo de formula");

                formulaMaestraVersionRevisar.setCodFormulaMaestra(String.valueOf(codFormulaMaestra));
                consulta="INSERT INTO FORMULA_MAESTRA select fmv.COD_FORMULA_MAESTRA,fmv.COD_COMPPROD,fmv.CANTIDAD_LOTE,fmv.ESTADO_SISTEMA,fmv.COD_ESTADO_REGISTRO from FORMULA_MAESTRA_VERSION fmv where"+
                         " fmv.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"' and fmv.COD_VERSION='"+formulaMaestraVersionRevisar.getCodVersion()+"'";
                System.out.println("consulta insert formula maestra "+consulta);
                pst=con.prepareStatement(consulta);
                if(pst.executeUpdate()>0)System.out.println("se registro la cabecera de la formula");
            }
            else
            {
                consulta="update FORMULA_MAESTRA_VERSION set COD_ESTADO_VERSION_FORMULA_MAESTRA=4 WHERE COD_FORMULA_MAESTRA='"+formulaMaestraVersionRevisar.getCodFormulaMaestra()+"' AND COD_ESTADO_VERSION_FORMULA_MAESTRA=2";
                System.out.println("consulta update obsoleto anterior version "+consulta);
                pst=con.prepareStatement(consulta);
                if(pst.executeUpdate()>0)System.out.println("se cambiaron los estados de las versiones");
                
                consulta="update FORMULA_MAESTRA_VERSION set COD_ESTADO_VERSION_FORMULA_MAESTRA=2,FECHA_INICIO_VIGENCIA='"+sdf.format(new Date())+"'" +
                        ",COD_COMPPROD_VERSION='"+codVersionProducto+"'" +
                        " WHERE COD_VERSION='"+formulaMaestraVersionRevisar.getCodVersion()+"' and COD_FORMULA_MAESTRA='"+formulaMaestraVersionRevisar.getCodFormulaMaestra()+"'";
                System.out.println("consulta enviar a apobacion "+consulta);
                pst=con.prepareStatement(consulta);
                if(pst.executeUpdate()>0)System.out.println("se envio  la version a aprovacion");
                
                if(formulaMaestraVersionRevisar.isModificacionMPEP()||
                    formulaMaestraVersionRevisar.isModificacionNF())
                {
                    consulta="select f.CANTIDAD_LOTE,f.COD_ESTADO_REGISTRO from FORMULA_MAESTRA_VERSION f " +
                    " where f.COD_FORMULA_MAESTRA='"+formulaMaestraVersionRevisar.getCodFormulaMaestra()+"'" +
                    " and f.COD_VERSION='"+formulaMaestraVersionRevisar.getCodVersion()+"'";
                    System.out.println("consulta cabecera cantidad lote");
                    res=st.executeQuery(consulta);
                    if(res.next())
                    {
                        consulta="update FORMULA_MAESTRA set CANTIDAD_LOTE='"+res.getDouble("CANTIDAD_LOTE")+"' , COD_ESTADO_REGISTRO='"+res.getInt("COD_ESTADO_REGISTRO")+"'"+
                                 " where COD_FORMULA_MAESTRA='"+formulaMaestraVersionRevisar.getCodFormulaMaestra()+"'";
                        System.out.println("consulta update formula maestra cabecera "+consulta);
                        pst=con.prepareStatement(consulta);
                        if(pst.executeUpdate()>0)System.out.println("se actualizo la cabecera");
                    }
                    consulta="delete FORMULA_MAESTRA_DETALLE_MP  where COD_FORMULA_MAESTRA='"+formulaMaestraVersionRevisar.getCodFormulaMaestra()+"'";
                    System.out.println("consulta delete formula Maestra Mp"+consulta);
                    pst=con.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)System.out.println("se eliminaron los registros");

                    consulta="delete FORMULA_MAESTRA_DETALLE_MP_FRACCIONES  where COD_FORMULA_MAESTRA='"+formulaMaestraVersionRevisar.getCodFormulaMaestra()+"'";
                    System.out.println("consulta delete formula Maestra Mp fracciones "+consulta);
                    pst=con.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)System.out.println("se eliminaron los registros");

                    consulta="delete FORMULA_MAESTRA_DETALLE_EP  where COD_FORMULA_MAESTRA='"+formulaMaestraVersionRevisar.getCodFormulaMaestra()+"'";
                    System.out.println("consulta delete formula Maestra Mp fracciones "+consulta);
                    pst=con.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)System.out.println("se eliminaron los registros");
                 }
                 if(formulaMaestraVersionRevisar.isModificacionES())
                 {
                    consulta="delete FORMULA_MAESTRA_DETALLE_ES  where COD_FORMULA_MAESTRA='"+formulaMaestraVersionRevisar.getCodFormulaMaestra()+"'";
                    System.out.println("consulta delete formula Maestra Mp fracciones "+consulta);
                    pst=con.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)System.out.println("se eliminaron los registros");
                 }
                 if(formulaMaestraVersionRevisar.isModificacionR())
                 {
                    consulta="delete FORMULA_MAESTRA_DETALLE_MR  where COD_FORMULA_MAESTRA='"+formulaMaestraVersionRevisar.getCodFormulaMaestra()+"'";
                    System.out.println("consulta delete formula Maestra Mp fracciones "+consulta);
                    pst=con.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)System.out.println("se eliminaron los registros");
                    consulta="delete FORMULA_MAESTRA_MR_CLASIFICACION  where COD_FORMULA_MAESTRA='"+formulaMaestraVersionRevisar.getCodFormulaMaestra()+"'";
                    System.out.println("consulta delete formula Maestra Mp fracciones "+consulta);
                    pst=con.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)System.out.println("se eliminaron los registros");
                 }
                
                
            }
            consulta="update FORMULA_MAESTRA_VERSION_MODIFICACION set COD_ESTADO_VERSION_FORMULA_MAESTRA='2' where COD_VERSION_FM='"+formulaMaestraVersionRevisar.getCodVersion()+"'";
            System.out.println("consulta update personal modificacion "+consulta);
            pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se registro la modificacion del personal a activo");
            if(formulaMaestraVersionRevisar.isModificacionNF()||formulaMaestraVersionRevisar.isModificacionMPEP())
            {
                consulta="INSERT INTO FORMULA_MAESTRA_DETALLE_MP(COD_FORMULA_MAESTRA, COD_MATERIAL,"+
                        " CANTIDAD, COD_UNIDAD_MEDIDA, NRO_PREPARACIONES)"+
                        " select f.COD_FORMULA_MAESTRA,f.COD_MATERIAL,f.CANTIDAD,f.COD_UNIDAD_MEDIDA,f.NRO_PREPARACIONES from FORMULA_MAESTRA_DETALLE_MP_VERSION f" +
                        " where f.COD_FORMULA_MAESTRA='"+formulaMaestraVersionRevisar.getCodFormulaMaestra()+"'"+
                        " and f.COD_VERSION='"+formulaMaestraVersionRevisar.getCodVersion()+"'";
                System.out.println("consulta insert fmd "+consulta);
                pst=con.prepareStatement(consulta);
                if(pst.executeUpdate()>0)System.out.println("se registraron los materiales");

                consulta="INSERT INTO FORMULA_MAESTRA_DETALLE_MP_FRACCIONES(COD_FORMULA_MAESTRA,"+
                        " COD_MATERIAL, COD_FORMULA_MAESTRA_FRACCIONES, CANTIDAD,"+
                        " COD_TIPO_MATERIAL_PRODUCCION)"+
                        " select f.COD_FORMULA_MAESTRA,f.COD_MATERIAL,f.COD_FORMULA_MAESTRA_FRACCIONES,"+
                        " f.CANTIDAD,f.COD_TIPO_MATERIAL_PRODUCCION"+
                        " from FORMULA_MAESTRA_DETALLE_MP_FRACCIONES_VERSION f where "+
                        " f.COD_FORMULA_MAESTRA='"+formulaMaestraVersionRevisar.getCodFormulaMaestra()+"'"+
                        " and f.COD_VERSION='"+formulaMaestraVersionRevisar.getCodVersion()+"'";
                System.out.println("consulta insert mp fracciones "+consulta);
                pst=con.prepareStatement(consulta);
                if(pst.executeUpdate()>0)System.out.println("se registraron las mp fraccciones");

                consulta="INSERT INTO FORMULA_MAESTRA_DETALLE_EP(COD_FORMULA_MAESTRA,"+
                         " COD_PRESENTACION_PRIMARIA, COD_MATERIAL, CANTIDAD, COD_UNIDAD_MEDIDA)"+
                         " select f.COD_FORMULA_MAESTRA,f.COD_PRESENTACION_PRIMARIA,f.COD_MATERIAL,"+
                         " f.CANTIDAD,f.COD_UNIDAD_MEDIDA"+
                         " from FORMULA_MAESTRA_DETALLE_EP_VERSION f where f.COD_FORMULA_MAESTRA='"+formulaMaestraVersionRevisar.getCodFormulaMaestra()+"'"+
                         " and f.COD_VERSION='"+formulaMaestraVersionRevisar.getCodVersion()+"'";
                System.out.println("consulta insert fmd ep "+consulta);
                pst=con.prepareStatement(consulta);
                if(pst.executeUpdate()>0)System.out.println("se registraron los materiales ep");

            }
            if(formulaMaestraVersionRevisar.isModificacionES())
            {
                consulta="INSERT INTO FORMULA_MAESTRA_DETALLE_ES(COD_FORMULA_MAESTRA, COD_MATERIAL,"+
                         " CANTIDAD, COD_UNIDAD_MEDIDA, COD_PRESENTACION_PRODUCTO, COD_TIPO_PROGRAMA_PROD)"+
                         " select f.COD_FORMULA_MAESTRA,f.COD_MATERIAL,f.CANTIDAD,f.COD_UNIDAD_MEDIDA,f.COD_PRESENTACION_PRODUCTO"+
                         " ,f.COD_TIPO_PROGRAMA_PROD from FORMULA_MAESTRA_DETALLE_ES_VERSION f where" +
                         " f.COD_FORMULA_MAESTRA='"+formulaMaestraVersionRevisar.getCodFormulaMaestra()+"'"+
                         " and f.COD_VERSION='"+formulaMaestraVersionRevisar.getCodVersion()+"'";
                System.out.println("consulta insert fmd es "+consulta);
                pst=con.prepareStatement(consulta);
                if(pst.executeUpdate()>0)System.out.println("se registro el material");
            }
            if(formulaMaestraVersionRevisar.isModificacionR())
            {
                consulta="INSERT INTO FORMULA_MAESTRA_DETALLE_MR(COD_FORMULA_MAESTRA, COD_MATERIAL,"+
                         " CANTIDAD, COD_UNIDAD_MEDIDA, NRO_PREPARACIONES, COD_TIPO_MATERIAL,COD_TIPO_ANALISIS_MATERIAL)"+
                         " select f.COD_FORMULA_MAESTRA,f.COD_MATERIAL,f.CANTIDAD,f.COD_UNIDAD_MEDIDA,"+
                         " f.NRO_PREPARACIONES,f.COD_TIPO_MATERIAL,f.COD_TIPO_ANALISIS_MATERIAL"+
                         " from FORMULA_MAESTRA_DETALLE_MR_VERSION f where" +
                         " f.COD_FORMULA_MAESTRA='"+formulaMaestraVersionRevisar.getCodFormulaMaestra()+"'"+
                         " and f.COD_VERSION='"+formulaMaestraVersionRevisar.getCodVersion()+"'";
                System.out.println("consulta insert detalle mr "+consulta);
                pst=con.prepareStatement(consulta);
                if(pst.executeUpdate()>0)System.out.println("se registro fmd mr");

                consulta="INSERT INTO FORMULA_MAESTRA_MR_CLASIFICACION(COD_FORMULA_MAESTRA, COD_MATERIAL,"+
                         " COD_TIPO_ANALISIS_MATERIAL_REACTIVO)"+
                         " select f.COD_FORMULA_MAESTRA,f.COD_MATERIAL,f.COD_TIPO_ANALISIS_MATERIAL_REACTIVO"+
                         " from FORMULA_MAESTRA_MR_CLASIFICACION_VERSION f where " +
                         " f.COD_FORMULA_MAESTRA='"+formulaMaestraVersionRevisar.getCodFormulaMaestra()+"'"+
                         " and f.COD_VERSION='"+formulaMaestraVersionRevisar.getCodVersion()+"'";
                System.out.println("consulta insert clasificacion "+consulta);
                pst=con.prepareStatement(consulta);
                if(pst.executeUpdate()>0)System.out.println("se registro las clasificaciones mr");
            }
            con.commit();
            mensaje="1";
            pst.close();
            st.close();
            if(res!=null)res.close();
            con.close();
        }
        catch(SQLException ex)
        {
            mensaje="Ocurrio un error al momento de enviar a aprovacion, intente de nuevo";
            con.rollback();con.close();
            ex.printStackTrace();
        }
        if(mensaje.equals("1"))
        {
            enviarCorreoNotificacion();
        }
        return null;
       
    }
    private void enviarCorreoNotificacion()
    {
        String asunto="Cambio de formula Maestra "+formulaMaestraVersionRevisar.getComponentesProd().getNombreProdSemiterminado()+"("+formulaMaestraVersionRevisar.getCantidadLote()+")";
        try
        {
            Connection con1=null;
            con1=Util.openConnection(con1);
            Statement st=con1.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery("SELECT  cnv.COD_PERSONAL FROM CORREOS_NOTIFICACION_VERSION cnv");
            while(res.next())
            {
                Util.enviarCorreo(res.getString("COD_PERSONAL"),mensajeCorreo, asunto, "Cambio Formula Maestra");
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
    private void prepararEnvioCorreo()
    {
        SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy  HH:mm");
        mensajeCorreo="<style>span{font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 11px;}" +
                             ".celdaDetalle{padding:3px !important; border-right: solid #bbbbbb 1px !important;border-bottom: solid #bbbbbb 1px !important;}" +
                             ".cabecera{background-color:#9d5a9e;color:white;}" +
                             ".cabecera td{padding:3px !important; border-right: solid white 1px !important;border-bottom: solid white 1px !important;}" +
                             ".cabeceraVersion{background-color:#eeeeee;}" +
                             ".cabeceraVersionDetalle{padding:3px !important;}" +
                             "</style><span>Se aprobo la version No "+formulaMaestraVersionRevisar.getNroVersion()+" del producto "+formulaMaestraVersionRevisar.getComponentesProd().getNombreProdSemiterminado()+"" +
                    " con los siguientes Datos:</span><br/><br/>" +
                    "<center><table class='cabeceraVersion' cellpadding='0' cellspacing='0' ><tr class='cabecera'><td colspan='3' align='center'><span>Datos de la Version</span></td></tr>" +
                    "<tr><td class='cabeceraVersionDetalle'><span style='font-weight:bold'>Producto</span></td><td class='cabeceraVersionDetalle'><span style='font-weight:bold'>::</span></td><td class='cabeceraVersionDetalle'><span>"+formulaMaestraVersionRevisar.getComponentesProd().getNombreProdSemiterminado()+"</span></td></tr>" +
                    /*((formulaMaestraVersionRevisar.getTiposModificacionFormula().getCodTipoModificacionFormula()==2||
                    formulaMaestraVersionRevisar.getTiposModificacionFormula().getCodTipoModificacionFormula()==3)?"":"<tr><td class='cabeceraVersionDetalle'><span style='font-weight:bold'>Tamaño Lote</span></td><td class='cabeceraVersionDetalle'><span style='font-weight:bold'>::</span></td><td><span>"+formulaMaestraVersionRevisar.getCantidadLote()+"</span></td></tr>" )+*/
                    "<tr><td class='cabeceraVersionDetalle'><span style='font-weight:bold'>Fecha Creacion</span></td><td class='cabeceraVersionDetalle'><span style='font-weight:bold'>::</span></td><td class='cabeceraVersionDetalle'><span>"+sdf.format(formulaMaestraVersionRevisar.getFechaModificacion())+"</span></td></tr>" +
                    "<tr><td class='cabeceraVersionDetalle'><span style='font-weight:bold'>Personal Creacion</span></td ><td class='cabeceraVersionDetalle'><span style='font-weight:bold'>::</span></td><td class='cabeceraVersionDetalle'><span>"+formulaMaestraVersionRevisar.getPersonalCreacion().getNombrePersonal()+"</span></td></tr>" +
                    "<tr><td class='cabeceraVersionDetalle'><span style='font-weight:bold'>Tipo Modificacion</span></td><td class='cabeceraVersionDetalle'><span style='font-weight:bold'>::</span></td><td class='cabeceraVersionDetalle'><span>"+formulaMaestraVersionRevisar.isModificacionES()+"</span></td></tr>" +
                    "<tr><td class='cabeceraVersionDetalle'><span style='font-weight:bold'>No Version</span></td><td class='cabeceraVersionDetalle'><span style='font-weight:bold'>::</span></td><td class='cabeceraVersionDetalle'><span>"+formulaMaestraVersionRevisar.getNroVersion()+"</span></td></tr>" +
                    "</table><br/><br/><table cellpadding='0' cellspacing='0' ><tr><td><span>Nuevo</span></td><td bgColor='#90EE90'><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></td>" +
                    "<td><span>Modificado</span></td><td bgColor='#F0E68C'><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></td>" +
                    "<td><span>Eliminado</span></td><td bgColor='#FFB6C1'><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></td></tr></table></center><br/><br/>";
        try
        {
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="";
            ResultSet res=null;
            NumberFormat numeroformato = NumberFormat.getNumberInstance(Locale.ENGLISH);
            DecimalFormat formato = (DecimalFormat) numeroformato;
            formato.applyPattern("#,##0.00");
            boolean intercalar=false;
            if(formulaMaestraVersionRevisar.isModificacionMPEP()||
                    formulaMaestraVersionRevisar.isModificacionNF())
            {
                mensajeCorreo+="<center><table cellpadding='0' cellspacing='0'>"+
                        " <tr class='cabecera'  align='center'><td  colspan='4'><span>Datos Formula</span></td>"+
                        " </tr><tr class='cabecera' align='center'><td colspan='2' ><span >Cantidad Lote</span></td>"+
                        "<td colspan='2' ><span>Estado</span></td>" +
                        "</tr><tr class='cabecera'>" +
                        "<td><span >Antes</span></td><td><span class='outputText2'>Despues</span></td>" +
                        "<td><span >Antes</span></td><td><span class='outputText2'>Despues</span></td>" +
                        "</tr>";
                consulta="select fm.CANTIDAD_LOTE,fmv.CANTIDAD_LOTE as cantidadLote2,ISNULL(er.NOMBRE_ESTADO_REGISTRO,'') as NOMBRE_ESTADO_REGISTRO," +
                                        "er1.NOMBRE_ESTADO_REGISTRO as NOMBRE_ESTADO_REGISTRO2,fm.COD_ESTADO_REGISTRO,fmv.COD_ESTADO_REGISTRO as COD_ESTADO_REGISTRO2"+
                                        " from FORMULA_MAESTRA fm full outer join FORMULA_MAESTRA_VERSION fmv on "+
                                        " fm.COD_FORMULA_MAESTRA=fmv.COD_FORMULA_MAESTRA and fmv.COD_VERSION='"+formulaMaestraVersionRevisar.getCodVersion()+"'"+
                                        " LEFT OUTER JOIN ESTADOS_REFERENCIALES er on er.COD_ESTADO_REGISTRO=fm.COD_ESTADO_REGISTRO"+
                                        " LEFT OUTER JOIN ESTADOS_REFERENCIALES er1 on er1.COD_ESTADO_REGISTRO=fmv.COD_ESTADO_REGISTRO"+
                                        " where (fm.COD_FORMULA_MAESTRA='"+formulaMaestraVersionRevisar.getCodFormulaMaestra()+"')" +
                                        " or (fmv.COD_FORMULA_MAESTRA='"+formulaMaestraVersionRevisar.getCodFormulaMaestra()+"'"+
                                        " and fmv.COD_VERSION='"+formulaMaestraVersionRevisar.getCodVersion()+"')";
                System.out.println("consulta diferencias fm "+consulta);
                res=st.executeQuery(consulta);
                if(res.next())
                {
                    mensajeCorreo+="<tr>" +
                                    "<td class='celdaDetalle' bgColor='"+(res.getString("CANTIDAD_LOTE")==null?"#90EE90":(res.getDouble("CANTIDAD_LOTE")!=res.getDouble("cantidadLote2")?"#F0E68C":""))+"'><span >"+formato.format(res.getDouble("CANTIDAD_LOTE"))+"</span></td>" +
                                    "<td class='celdaDetalle' bgColor='"+(res.getString("CANTIDAD_LOTE")==null?"#90EE90":(res.getDouble("CANTIDAD_LOTE")!=res.getDouble("cantidadLote2")?"#F0E68C":""))+"'><span >"+formato.format(res.getDouble("cantidadLote2"))+"</span></td>" +
                                    "<td class='celdaDetalle' bgColor='"+(res.getString("COD_ESTADO_REGISTRO")==null?"#90EE90":(res.getDouble("COD_ESTADO_REGISTRO")!=res.getDouble("COD_ESTADO_REGISTRO2")?"#F0E68C":""))+"'><span >"+res.getString("NOMBRE_ESTADO_REGISTRO")+"</span></td>" +
                                    "<td class='celdaDetalle' bgColor='"+(res.getString("COD_ESTADO_REGISTRO")==null?"#90EE90":(res.getDouble("COD_ESTADO_REGISTRO")!=res.getDouble("COD_ESTADO_REGISTRO2")?"#F0E68C":""))+"'><span >"+res.getString("NOMBRE_ESTADO_REGISTRO2")+"</span></td>" +
                                    "</tr>";
                }
                mensajeCorreo+="</tbody></table><br/><br/>";
                mensajeCorreo+="<table cellpadding='0' cellspacing='0'> "+
                                "<tr class='cabecera' align='center'><td  colspan='8'><span>Cambios Materia Prima</span></td>"+
                                " </tr><tr class='cabecera' align='center'><td rowspan='2' ><span>Material</span></td>"+
                                "<td colspan='2' ><span >Cantidad</span></td>" +
                                "<td rowspan='2' ><span >Unidad Medida</span></td>"+
                                "<td colspan='2'><span >Nro Fracciones</span></td>"+
                                "<td colspan='2' ><span>Fracciones</span></td></tr><tr class='cabecera'>" +
                                "<td><span >Antes</span></td><td><span class='outputText2'>Despues</span></td>" +
                                "<td><span >Antes</span></td><td><span class='outputText2'>Despues</span></td>" +
                                "<td><span >Antes</span></td><td><span class='outputText2'>Despues</span></td> </tr>";
                consulta="select m.NOMBRE_MATERIAL,m.COD_MATERIAL,fmd.CANTIDAD,fmdv.CANTIDAD as cantidad2,"+
                         " fmd.NRO_PREPARACIONES,fmdv.NRO_PREPARACIONES as NRO_PREPARACIONES2,um.NOMBRE_UNIDAD_MEDIDA,fracciones.cantidadIni,fracciones.cantidadFin"+
                         " from  FORMULA_MAESTRA_DETALLE_MP fmd full outer join FORMULA_MAESTRA_DETALLE_MP_VERSION fmdv"+
                         " on fmd.COD_MATERIAL=fmdv.COD_MATERIAL and fmdv.COD_VERSION='"+formulaMaestraVersionRevisar.getCodVersion()+"' and fmd.COD_FORMULA_MAESTRA=fmdv.COD_FORMULA_MAESTRA"+
                         " inner join materiales m on (m.COD_MATERIAL=fmd.COD_MATERIAL or m.COD_MATERIAL=fmdv.COD_MATERIAL)"+
                         " inner join UNIDADES_MEDIDA um on (um.COD_UNIDAD_MEDIDA=fmd.COD_UNIDAD_MEDIDA or um.COD_UNIDAD_MEDIDA=fmdv.COD_UNIDAD_MEDIDA)"+
                         " outer apply(select fmdf.CANTIDAD as cantidadIni,fmdfv.CANTIDAD as cantidadFin"+
                         "  from FORMULA_MAESTRA_DETALLE_MP_FRACCIONES fmdf full outer join FORMULA_MAESTRA_DETALLE_MP_FRACCIONES_VERSION fmdfv on "+
                         " fmdf.COD_MATERIAL=fmdfv.COD_MATERIAL and fmdf.COD_FORMULA_MAESTRA=fmdfv.COD_FORMULA_MAESTRA  and fmdf.COD_FORMULA_MAESTRA_FRACCIONES=fmdfv.COD_FORMULA_MAESTRA_FRACCIONES"+
                         " and fmdfv.COD_VERSION=fmdv.COD_VERSION"+
                         " where ((fmdf.COD_FORMULA_MAESTRA=fmd.COD_FORMULA_MAESTRA and fmdf.COD_MATERIAL=fmd.COD_MATERIAL  and fmdfv.COD_FORMULA_MAESTRA_FRACCIONES is null)or"+
                         " (fmdfv.COD_FORMULA_MAESTRA=fmdv.COD_FORMULA_MAESTRA and fmdfv.COD_MATERIAL=fmdv.COD_MATERIAL and fmdfv.COD_VERSION=fmdv.COD_VERSION and fmdf.COD_FORMULA_MAESTRA_FRACCIONES is null)OR"+
                         " (fmdfv.COD_FORMULA_MAESTRA=fmdv.COD_FORMULA_MAESTRA and fmdfv.COD_MATERIAL=fmdv.COD_MATERIAL and fmdfv.COD_VERSION=fmdv.COD_VERSION and fmdf.COD_FORMULA_MAESTRA_FRACCIONES=fmdfv.COD_FORMULA_MAESTRA_FRACCIONES"+
                         " and fmdf.COD_MATERIAL=fmdfv.COD_MATERIAL and fmdfv.COD_FORMULA_MAESTRA_FRACCIONES=fmdf.COD_FORMULA_MAESTRA_FRACCIONES))) fracciones"+
                         " where ((fmd.COD_FORMULA_MAESTRA='"+formulaMaestraVersionRevisar.getCodFormulaMaestra()+"' and fmdv.COD_VERSION is null) OR"+
                         " (fmd.COD_FORMULA_MAESTRA is null and fmdv.COD_FORMULA_MAESTRA='"+formulaMaestraVersionRevisar.getCodFormulaMaestra()+"'" +
                         " and fmdv.COD_VERSION='"+formulaMaestraVersionRevisar.getCodVersion()+"')"+
                         " OR( fmd.COD_FORMULA_MAESTRA=fmdv.COD_FORMULA_MAESTRA and fmdv.COD_VERSION='"+formulaMaestraVersionRevisar.getCodVersion()+"'" +
                         " and fmd.COD_FORMULA_MAESTRA='"+formulaMaestraVersionRevisar.getCodFormulaMaestra()+"'))"+
                         " order by m.NOMBRE_MATERIAL";
                System.out.println("consulta cargar diferencias mp "+consulta);
                res=st.executeQuery(consulta);
                int  codMaterialCabecera=0;
                String fracciones="";
                int contFracciones=0;
                while(res.next())
                {
                    if(codMaterialCabecera!=res.getInt("COD_MATERIAL"))
                    {
                        if(codMaterialCabecera>0)
                        {
                            res.previous();
                            mensajeCorreo+="<tr>" +
                                    "<td class='celdaDetalle' bgColor='"+(res.getString("cantidad")==null?"#90EE90":(res.getString("cantidad2")==null?"#FFB6C1":(intercalar?"#eeeeee":"")))+"' rowspan='"+contFracciones+"' ><span class='outputText2'>"+res.getString("NOMBRE_MATERIAL")+"</span></td>" +
                                    "<td class='celdaDetalle' bgColor='"+(res.getString("cantidad")==null?"#90EE90":(res.getString("cantidad2")==null?"#FFB6C1":(res.getDouble("cantidad2")!=res.getInt("CANTIDAD")?"#F0E68C":(intercalar?"#eeeeee":""))))+"' rowspan='"+contFracciones+"' ><span class='outputText2'>"+formato.format(res.getDouble("CANTIDAD"))+"</span></td>" +
                                    "<td class='celdaDetalle' bgColor='"+(res.getString("cantidad")==null?"#90EE90":(res.getString("cantidad2")==null?"#FFB6C1":(res.getDouble("cantidad2")!=res.getInt("CANTIDAD")?"#F0E68C":(intercalar?"#eeeeee":""))))+"' rowspan='"+contFracciones+"' ><span class='outputText2'>"+formato.format(res.getDouble("CANTIDAD2"))+"</span></td>" +
                                    "<td class='celdaDetalle' bgColor='"+(res.getString("cantidad")==null?"#90EE90":(res.getString("cantidad2")==null?"#FFB6C1":(intercalar?"#eeeeee":"")))+"' rowspan='"+contFracciones+"' ><span class='outputText2'>"+res.getString("NOMBRE_UNIDAD_MEDIDA")+"</span></td>" +
                                    "<td class='celdaDetalle' bgColor='"+(res.getString("cantidad")==null?"#90EE90":(res.getString("cantidad2")==null?"#FFB6C1":(res.getDouble("NRO_PREPARACIONES")!=res.getInt("NRO_PREPARACIONES2")?"#F0E68C":(intercalar?"#eeeeee":""))))+"' rowspan='"+contFracciones+"' ><span class='outputText2'>"+res.getInt("NRO_PREPARACIONES")+"</span></td>" +
                                    "<td class='celdaDetalle' bgColor='"+(res.getString("cantidad")==null?"#90EE90":(res.getString("cantidad2")==null?"#FFB6C1":(res.getDouble("NRO_PREPARACIONES")!=res.getInt("NRO_PREPARACIONES2")?"#F0E68C":(intercalar?"#eeeeee":""))))+"' rowspan='"+contFracciones+"' ><span class='outputText2'>"+res.getInt("NRO_PREPARACIONES2")+"</span></td>"
                                    +fracciones;
                            res.next();

                        }
                        codMaterialCabecera=res.getInt("COD_MATERIAL");
                        contFracciones=0;
                        fracciones="";
                        intercalar=!intercalar;
                    }
                    contFracciones++;
                    fracciones+=(contFracciones==1?"":"<tr>")+"<td class='celdaDetalle' bgColor='"+(res.getString("cantidadIni")==null?"#90EE90":(res.getString("cantidadFin")==null?"#FFB6C1":(res.getDouble("cantidadIni")!=res.getDouble("cantidadFin")?"#F0E68C":(intercalar?"#eeeeee":""))))+"' ><span class='outputText2'>"+formato.format(res.getDouble("cantidadIni"))+"</span></td>" +
                                "<td class='celdaDetalle' bgColor='"+(res.getString("cantidadIni")==null?"#90EE90":(res.getString("cantidadFin")==null?"#FFB6C1":(res.getDouble("cantidadIni")!=res.getDouble("cantidadFin")?"#F0E68C":(intercalar?"#eeeeee":""))))+"' ><span class='outputText2'>"+formato.format(res.getDouble("cantidadFin"))+"</span></td></tr>";
                 }
                 if(codMaterialCabecera>0)
                {
                     res.last();
                     mensajeCorreo+="<tr>" +
                                    "<td class='celdaDetalle' bgColor='"+(res.getString("cantidad")==null?"#90EE90":(res.getString("cantidad2")==null?"#FFB6C1":(intercalar?"#eeeeee":"")))+"' rowspan='"+contFracciones+"' ><span class='outputText2'>"+res.getString("NOMBRE_MATERIAL")+"</span></td>" +
                                    "<td class='celdaDetalle' bgColor='"+(res.getString("cantidad")==null?"#90EE90":(res.getString("cantidad2")==null?"#FFB6C1":(res.getDouble("cantidad2")!=res.getInt("CANTIDAD")?"#F0E68C":(intercalar?"#eeeeee":""))))+"' rowspan='"+contFracciones+"' ><span class='outputText2'>"+formato.format(res.getDouble("CANTIDAD"))+"</span></td>" +
                                    "<td class='celdaDetalle' bgColor='"+(res.getString("cantidad")==null?"#90EE90":(res.getString("cantidad2")==null?"#FFB6C1":(res.getDouble("cantidad2")!=res.getInt("CANTIDAD")?"#F0E68C":(intercalar?"#eeeeee":""))))+"' rowspan='"+contFracciones+"' ><span class='outputText2'>"+formato.format(res.getDouble("CANTIDAD2"))+"</span></td>" +
                                    "<td class='celdaDetalle' bgColor='"+(res.getString("cantidad")==null?"#90EE90":(res.getString("cantidad2")==null?"#FFB6C1":(intercalar?"#eeeeee":"")))+"' rowspan='"+contFracciones+"' ><span class='outputText2'>"+res.getString("NOMBRE_UNIDAD_MEDIDA")+"</span></td>" +
                                    "<td class='celdaDetalle' bgColor='"+(res.getString("cantidad")==null?"#90EE90":(res.getString("cantidad2")==null?"#FFB6C1":(res.getDouble("NRO_PREPARACIONES")!=res.getInt("NRO_PREPARACIONES2")?"#F0E68C":(intercalar?"#eeeeee":""))))+"' rowspan='"+contFracciones+"' ><span class='outputText2'>"+res.getInt("NRO_PREPARACIONES")+"</span></td>" +
                                    "<td class='celdaDetalle' bgColor='"+(res.getString("cantidad")==null?"#90EE90":(res.getString("cantidad2")==null?"#FFB6C1":(res.getDouble("NRO_PREPARACIONES")!=res.getInt("NRO_PREPARACIONES2")?"#F0E68C":(intercalar?"#eeeeee":""))))+"' rowspan='"+contFracciones+"' ><span class='outputText2'>"+res.getInt("NRO_PREPARACIONES2")+"</span></td>"
                                    +fracciones;
                     }
                     mensajeCorreo+="</tbody></table><br/><br/>"+
                                    "<table cellpadding='0' cellspacing='0' >"+
                                    "<tr  align='center' class='cabecera'><td  colspan='4'><span>Cambios de Empaque Primario</span></td>"+
                                    " </tr>";
                             consulta="select fep.COD_FORMULA_MAESTRA,ep.nombre_envaseprim,ep.cod_envaseprim,pp.CANTIDAD,"+
                                      " pp.cod_presentacion_primaria,pp.COD_TIPO_PROGRAMA_PROD,tppr.NOMBRE_TIPO_PROGRAMA_PROD,"+
                                      " pp.COD_ESTADO_REGISTRO,erf.NOMBRE_ESTADO_REGISTRO"+
                                      " from FORMULA_MAESTRA_VERSION fep inner join PRESENTACIONES_PRIMARIAS pp on PP.COD_COMPPROD =fep.COD_COMPPROD"+
                                      " inner join ENVASES_PRIMARIOS ep on ep.cod_envaseprim = pp.cod_envaseprim"+
                                      " left outer join tipos_programa_produccion tppr on tppr.COD_TIPO_PROGRAMA_PROD = pp.COD_TIPO_PROGRAMA_PROD"+
                                      " left outer join ESTADOS_REFERENCIALES erf on erf.COD_ESTADO_REGISTRO =pp.COD_ESTADO_REGISTRO"+
                                      " where fep.COD_FORMULA_MAESTRA = '"+formulaMaestraVersionRevisar.getCodFormulaMaestra()+"'" +
                                      " and fep.COD_VERSION = '"+formulaMaestraVersionRevisar.getCodVersion()+"' order by ep.nombre_envaseprim";
                             System.out.println("consulta presentaciones primarias"+consulta);
                             res=st.executeQuery(consulta);
                             Statement stDetalle=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                             ResultSet resDetalle=null;
                             while(res.next())
                             {
                                 mensajeCorreo+="<tr class='cabecera'><td  colspan='5' align='center'><span>" +
                                         "Tipo Prog:"+res.getString("NOMBRE_TIPO_PROGRAMA_PROD")+"<br/>Envase:"+res.getString("nombre_envaseprim")+"<br/>" +
                                         "Estado:"+res.getString("NOMBRE_ESTADO_REGISTRO")+"<br/>Cantidad:"+res.getInt("CANTIDAD")+"</span></td></tr>" +
                                         "<tr  class='cabecera' align='center'><td rowspan='2' ><span>Material</span></td>"+
                                        "<td colspan='2' ><span >Cantidad</span></td>" +
                                        "<td rowspan='2' ><span >Unidad Medida</span></td><tr class='cabecera'>" +
                                        "<td><span >Antes</span></td><td><span >Despues</span></td></tr>";
                                 consulta="select m.NOMBRE_MATERIAL,fmde.CANTIDAD,fmdev.CANTIDAD as cantidad2,um.NOMBRE_UNIDAD_MEDIDA"+
                                         " from FORMULA_MAESTRA_DETALLE_EP fmde full outer join FORMULA_MAESTRA_DETALLE_EP_VERSION fmdev"+
                                         "  on fmde.COD_FORMULA_MAESTRA=fmdev.COD_FORMULA_MAESTRA and fmde.COD_MATERIAL=fmdev.COD_MATERIAL and fmdev.COD_VERSION="+formulaMaestraVersionRevisar.getCodVersion()+
                                         " inner join materiales m on (m.COD_MATERIAL=fmde.COD_MATERIAL or m.COD_MATERIAL=fmdev.COD_MATERIAL)"+
                                         " inner join UNIDADES_MEDIDA um on (um.COD_UNIDAD_MEDIDA=fmde.COD_UNIDAD_MEDIDA or um.COD_UNIDAD_MEDIDA=fmdev.COD_UNIDAD_MEDIDA)"+
                                         " where ((fmde.COD_FORMULA_MAESTRA='"+formulaMaestraVersionRevisar.getCodFormulaMaestra()+"'" +
                                         " and fmde.COD_PRESENTACION_PRIMARIA='"+res.getString("cod_presentacion_primaria")+"' and fmdev.COD_VERSION is null)"+
                                         " or(fmde.COD_FORMULA_MAESTRA is null and fmdev.COD_FORMULA_MAESTRA='"+formulaMaestraVersionRevisar.getCodFormulaMaestra()+"'" +
                                         " and fmdev.COD_VERSION='"+formulaMaestraVersionRevisar.getCodVersion()+"'"+
                                         " and fmdev.COD_PRESENTACION_PRIMARIA='"+res.getString("cod_presentacion_primaria")+"')OR"+
                                         " (fmde.COD_FORMULA_MAESTRA='"+formulaMaestraVersionRevisar.getCodFormulaMaestra()+"'" +
                                         " and fmde.COD_PRESENTACION_PRIMARIA='"+res.getString("cod_presentacion_primaria")+"'" +
                                         " and fmdev.COD_VERSION ='"+formulaMaestraVersionRevisar.getCodVersion()+"'))";
                                 System.out.println("consulta detalle ep "+consulta);
                                 resDetalle=stDetalle.executeQuery(consulta);
                                 while(resDetalle.next())
                                 {
                                      mensajeCorreo+="<tr>" +
                                            "<td class='celdaDetalle' bgColor='"+(resDetalle.getString("cantidad")==null?"#90EE90":(resDetalle.getString("cantidad2")==null?"#FFB6C1":(intercalar?"#eeeeee":"")))+"'><span >"+resDetalle.getString("NOMBRE_MATERIAL")+"</span></td>" +
                                            "<td class='celdaDetalle' bgColor='"+(resDetalle.getString("cantidad")==null?"#90EE90":(resDetalle.getString("cantidad2")==null?"#FFB6C1":(resDetalle.getDouble("cantidad")!=resDetalle.getDouble("cantidad2")?"#F0E68C":(intercalar?"#eeeeee":""))))+"'><span >"+formato.format(resDetalle.getDouble("cantidad"))+"</span></td>" +
                                            "<td class='celdaDetalle' bgColor='"+(resDetalle.getString("cantidad")==null?"#90EE90":(resDetalle.getString("cantidad2")==null?"#FFB6C1":(resDetalle.getDouble("cantidad")!=resDetalle.getDouble("cantidad2")?"#F0E68C":(intercalar?"#eeeeee":""))))+"'><span >"+formato.format(resDetalle.getDouble("cantidad2"))+"</span></td>" +
                                            "<td class='celdaDetalle' bgColor='"+(resDetalle.getString("cantidad")==null?"#90EE90":(resDetalle.getString("cantidad2")==null?"#FFB6C1":(intercalar?"#eeeeee":"")))+"'><span >"+resDetalle.getString("NOMBRE_UNIDAD_MEDIDA")+"</span></td>" +
                                            "</tr>";
                                      intercalar=!intercalar;
                                 }

                             }

                     mensajeCorreo+="</tbody></table></center>";
            }

            if(formulaMaestraVersionRevisar.isModificacionR())
            {
                Statement stDetalle=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet resDetalle=null;
                consulta="select tmr.COD_TIPO_MATERIAL_REACTIVO,tmr.NOMBRE_TIPO_MATERIAL_REACTIVO from TIPOS_MATERIAL_REACTIVO tmr where tmr.COD_ESTADO_REGISTRO=1 order by tmr.NOMBRE_TIPO_MATERIAL_REACTIVO";
                 res=st.executeQuery(consulta);
                 mensajeCorreo+="<center><table  cellpadding='0' cellspacing='0' style='top:12px;' >"+
                               " <tr class='cabecera' align='center'><td  colspan='7'><span>Cambios Material Reactivo</span></td>"+
                               " </tr>";
                 while(res.next())
                 {
                     mensajeCorreo+="<tr class='cabecera'><td colspan='7' align='center'><span >" +
                             "Tipo Material:"+res.getString("NOMBRE_TIPO_MATERIAL_REACTIVO")+"</span></td></tr>" +
                             "<tr  class='cabecera' align='center'><td rowspan='2' ><span class='' >Material</span></td>"+
                            "<td colspan='2' ><span >Cantidad</span></td>" +
                            "<td rowspan='2' ><span >Estado Material</span></td>" +
                            "<td colspan='2' ><span >Estado Analisis</span></td>"+
                            "<td rowspan='2' ><span >Analisis</span></td>"+
                            "</tr><tr class='cabecera'>" +
                            "<td><span >Antes</span></td><td><span >Despues</span></td>" +
                            "<td><span >Antes</span></td><td><span>Despues</span></td></tr>";
                      consulta="select m.NOMBRE_MATERIAL,m.COD_MATERIAL,fmd.CANTIDAD,fmdv.CANTIDAD as cantidad2,er.NOMBRE_ESTADO_REGISTRO,"+
                               " tamr.nombre_tipo_analisis_material_reactivo,detalle.registrado,detalle.registrado2"+
                               " from FORMULA_MAESTRA_DETALLE_MR fmd full outer join FORMULA_MAESTRA_DETALLE_MR_VERSION fmdv on "+
                               " fmd.COD_FORMULA_MAESTRA=fmdv.COD_FORMULA_MAESTRA and fmd.COD_MATERIAL=fmdv.COD_MATERIAL"+
                               " and fmd.COD_TIPO_MATERIAL=fmdv.COD_TIPO_MATERIAL"+
                               " and fmdv.COD_VERSION='"+formulaMaestraVersionRevisar.getCodVersion()+"'"+
                               " inner join MATERIALES m on (m.COD_MATERIAL=fmd.COD_MATERIAL or fmdv.COD_MATERIAL=m.COD_MATERIAL)"+
                               " inner join ESTADOS_REFERENCIALES er on er.COD_ESTADO_REGISTRO=m.COD_ESTADO_REGISTRO"+
                               " outer APPLY TIPOS_ANALISIS_MATERIAL_REACTIVO tamr"+
                               " OUTER APPLY (select case when fmc.COD_MATERIAL>0 then 1 else 0 end as registrado, case when fmcv.COD_MATERIAL >0 then 1 else 0 end as registrado2"+
                               " from FORMULA_MAESTRA_MR_CLASIFICACION fmc full outer join FORMULA_MAESTRA_MR_CLASIFICACION_VERSION fmcv"+
                               " on fmc.COD_FORMULA_MAESTRA=fmcv.COD_FORMULA_MAESTRA and fmc.COD_MATERIAL=fmcv.COD_MATERIAL"+
                               " and fmc.COD_TIPO_ANALISIS_MATERIAL_REACTIVO=fmcv.COD_TIPO_ANALISIS_MATERIAL_REACTIVO"+
                               " and fmcv.COD_VERSION=fmdv.COD_VERSION"+
                               " where ((fmc.COD_FORMULA_MAESTRA=fmd.COD_FORMULA_MAESTRA and fmc.COD_MATERIAL=fmd.COD_MATERIAL ) or"+
                               " (fmcv.COD_FORMULA_MAESTRA=fmdv.COD_FORMULA_MAESTRA and  fmcv.COD_MATERIAL=fmdv.COD_MATERIAL and "+
                               " fmcv.COD_VERSION=fmdv.COD_VERSION )) and (fmc.COD_TIPO_ANALISIS_MATERIAL_REACTIVO=tamr.COD_TIPO_ANALISIS_MATERIAL_REACTIVO"+
                               " or fmcv.COD_TIPO_ANALISIS_MATERIAL_REACTIVO=tamr.COD_TIPO_ANALISIS_MATERIAL_REACTIVO)) as detalle"+
                               " where ((fmd.COD_FORMULA_MAESTRA='"+formulaMaestraVersionRevisar.getCodFormulaMaestra()+"'" +
                               " and fmd.COD_TIPO_MATERIAL='"+res.getInt("COD_TIPO_MATERIAL_REACTIVO")+"')"+
                               " or(fmdv.COD_FORMULA_MAESTRA='"+formulaMaestraVersionRevisar.getCodFormulaMaestra()+"'" +
                               " and fmdv.COD_VERSION='"+formulaMaestraVersionRevisar.getCodVersion()+"'" +
                               " and fmdv.COD_TIPO_MATERIAL='"+res.getInt("COD_TIPO_MATERIAL_REACTIVO")+"' )) order by m.NOMBRE_MATERIAL,tamr.nombre_tipo_analisis_material_reactivo";
                           System.out.println("consulta detalle mr "+consulta);
                           resDetalle=stDetalle.executeQuery(consulta);
                           String fracciones="";
                           while(resDetalle.next())
                           {

                               if((resDetalle.getRow()%2)==0)
                               {
                                    mensajeCorreo+= "<tr class='celdaDetalle'>" +
                                                "<td bgColor='"+(resDetalle.getString("cantidad")==null?"#90EE90":(resDetalle.getString("cantidad2")==null?"#FFB6C1":(intercalar?"#eeeeee":"")))+"' rowspan='2' class='celdaDetalle'><span class=''>"+resDetalle.getString("NOMBRE_MATERIAL")+"</span></td>" +
                                                "<td bgColor='"+(resDetalle.getString("cantidad")==null?"#90EE90":(resDetalle.getString("cantidad2")==null?"#FFB6C1":(resDetalle.getDouble("cantidad")!=resDetalle.getDouble("cantidad2")?"#F0E68C":(intercalar?"#eeeeee":""))))+"' rowspan='2' class='celdaDetalle'><span >"+formato.format(resDetalle.getDouble("cantidad"))+"</span></td>" +
                                                "<td bgColor='"+(resDetalle.getString("cantidad")==null?"#90EE90":(resDetalle.getString("cantidad2")==null?"#FFB6C1":(resDetalle.getDouble("cantidad")!=resDetalle.getDouble("cantidad2")?"#F0E68C":(intercalar?"#eeeeee":""))))+"'  rowspan='2' class='celdaDetalle'><span >"+formato.format(resDetalle.getDouble("cantidad2"))+"</span></td>" +
                                                "<td bgColor='"+(resDetalle.getString("cantidad")==null?"#90EE90":(resDetalle.getString("cantidad2")==null?"#FFB6C1":(intercalar?"#eeeeee":"")))+"' rowspan='2' class='celdaDetalle'><span class=''>"+resDetalle.getString("NOMBRE_ESTADO_REGISTRO")+"</span></td>" +
                                                fracciones+
                                                "</tr><tr >"+
                                                "<td bgColor='"+(resDetalle.getString("cantidad")==null?"#90EE90":(resDetalle.getString("cantidad2")==null?"#FFB6C1":(resDetalle.getInt("registrado")!=resDetalle.getInt("registrado2")?"#F0E68C":(intercalar?"#eeeeee":""))))+"' class='celdaDetalle'><span> "+(resDetalle.getInt("registrado")>0?"SI":"NO")+"</span></td>"+
                                               "<td bgColor='"+(resDetalle.getString("cantidad")==null?"#90EE90":(resDetalle.getString("cantidad2")==null?"#FFB6C1":(resDetalle.getInt("registrado")!=resDetalle.getInt("registrado2")?"#F0E68C":(intercalar?"#eeeeee":""))))+"' class='celdaDetalle'><span> "+(resDetalle.getInt("registrado2")>0?"SI":"NO")+"</span></td>"+
                                               "<td bgColor='"+(resDetalle.getString("cantidad")==null?"#90EE90":(resDetalle.getString("cantidad2")==null?"#FFB6C1":(intercalar?"#eeeeee":"")))+"' class='celdaDetalle'><span class='outputText2'>"+resDetalle.getString("nombre_tipo_analisis_material_reactivo")+"</span></td></tr>";
                                 intercalar=!intercalar;
                               }
                               else
                               {
                                   fracciones="<td bgColor='"+(resDetalle.getString("cantidad")==null?"#90EE90":(resDetalle.getString("cantidad2")==null?"#FFB6C1":(resDetalle.getInt("registrado")!=resDetalle.getInt("registrado2")?"#F0E68C":(intercalar?"#eeeeee":""))))+"' class='celdaDetalle'><span> "+(resDetalle.getInt("registrado")>0?"SI":"NO")+"</span></td>"+
                                               "<td bgColor='"+(resDetalle.getString("cantidad")==null?"#90EE90":(resDetalle.getString("cantidad2")==null?"#FFB6C1":(resDetalle.getInt("registrado")!=resDetalle.getInt("registrado2")?"#F0E68C":(intercalar?"#eeeeee":""))))+"' class='celdaDetalle'><span> "+(resDetalle.getInt("registrado2")>0?"SI":"NO")+"</span></td>"+
                                               "<td bgColor='"+(resDetalle.getString("cantidad")==null?"#90EE90":(resDetalle.getString("cantidad2")==null?"#FFB6C1":(intercalar?"#eeeeee":"")))+"' class='celdaDetalle'><span class='outputText2'>"+resDetalle.getString("nombre_tipo_analisis_material_reactivo")+"</span></td>";
                               }
                           }
                 }
                 mensajeCorreo+="</tbody></table></center>";
            }
            if(formulaMaestraVersionRevisar.isModificacionES())
            {
                 mensajeCorreo+="<center><table cellpadding='0' cellspacing='0' >"+
                        " <tr  align='center' class='cabecera'><td  colspan='4'><span>Cambios Material Empaque Secundario</span></td>"+
                        " </tr>";
                 consulta="select es.NOMBRE_ENVASESEC,es.COD_ENVASESEC,pp.NOMBRE_PRODUCTO_PRESENTACION,pp.cantidad_presentacion,"+
                          " pp.cod_presentacion,TPP.NOMBRE_TIPO_PROGRAMA_PROD,tpp.COD_TIPO_PROGRAMA_PROD"+
                          " from FORMULA_MAESTRA_VERSION fm inner join COMPONENTES_PROD cp on cp.COD_COMPPROD = fm.COD_COMPPROD"+
                          " inner join COMPONENTES_PRESPROD c on c.COD_COMPPROD = cp.COD_COMPPROD"+
                          " inner join PRESENTACIONES_PRODUCTO pp on pp.cod_presentacion =c.COD_PRESENTACION"+
                          " inner join ENVASES_SECUNDARIOS es on es.COD_ENVASESEC = pp.COD_ENVASESEC"+
                          " inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD =c.COD_TIPO_PROGRAMA_PROD"+
                          " where fm.COD_FORMULA_MAESTRA = '"+formulaMaestraVersionRevisar.getCodFormulaMaestra()+"' and"+
                          " fm.COD_VERSION = '"+formulaMaestraVersionRevisar.getCodVersion()+"'";
                 System.out.println("consulta eS "+consulta);
                 Statement stDetalle=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                 ResultSet resDetalle=null;
                 res=st.executeQuery(consulta);
                 while(res.next())
                 {
                         mensajeCorreo+="<tr class='cabecera'><td  colspan='4' align='center'><span >" +
                                 "Tipo Prog:"+res.getString("NOMBRE_TIPO_PROGRAMA_PROD")+"<br/>Presentacion:"+res.getString("NOMBRE_ENVASESEC")+"<br/>" +
                                 "Cantidad:"+res.getInt("cantidad_presentacion")+"</span></td></tr>" +
                                 "<tr  class='cabecera' align='center'><td rowspan='2' ><span >Material</span></td>"+
                                "<td colspan='2' ><span >Cantidad</span></td>" +
                                "<td rowspan='2' ><span >Unidad Medida</span></td></tr>" +
                                "<tr class='cabecera'>" +
                                "<td><span>Antes</span></td><td><span >Despues</span></td></tr>";
                         consulta="select m.NOMBRE_MATERIAL,fmd.CANTIDAD,fmdv.CANTIDAD as cantidad2,um.NOMBRE_UNIDAD_MEDIDA,er.NOMBRE_ESTADO_REGISTRO"+
                                  " from FORMULA_MAESTRA_DETALLE_ES fmd full outer join FORMULA_MAESTRA_DETALLE_ES_VERSION fmdv"+
                                  " on fmdv.COD_FORMULA_MAESTRA=fmd.COD_FORMULA_MAESTRA and fmd.COD_MATERIAL=fmdv.COD_MATERIAL"+
                                  " and fmdv.COD_PRESENTACION_PRODUCTO=fmd.COD_PRESENTACION_PRODUCTO"+
                                  " and fmdv.COD_TIPO_PROGRAMA_PROD=fmd.COD_TIPO_PROGRAMA_PROD and fmdv.COD_VERSION='"+formulaMaestraVersionRevisar.getCodVersion()+"'"+
                                  " inner join materiales m on (m.COD_MATERIAL=fmd.COD_MATERIAL or m.COD_MATERIAL=fmdv.COD_MATERIAL)"+
                                  " inner join UNIDADES_MEDIDA um on (um.COD_UNIDAD_MEDIDA=fmdv.COD_UNIDAD_MEDIDA or um.COD_UNIDAD_MEDIDA=fmd.COD_UNIDAD_MEDIDA)"+
                                  " inner join ESTADOS_REFERENCIALES er on er.COD_ESTADO_REGISTRO=m.COD_ESTADO_REGISTRO"+
                                  " where ((fmd.COD_FORMULA_MAESTRA='"+formulaMaestraVersionRevisar.getCodFormulaMaestra()+"'" +
                                  " and fmd.COD_PRESENTACION_PRODUCTO='"+res.getInt("cod_presentacion")+"' and fmd.COD_TIPO_PROGRAMA_PROD='"+res.getInt("COD_TIPO_PROGRAMA_PROD")+"'" +
                                  " and fmdv.COD_VERSION is null) or"+
                                  " (fmdv.COD_FORMULA_MAESTRA='"+formulaMaestraVersionRevisar.getCodFormulaMaestra()+"'" +
                                  " and fmdv.COD_VERSION='"+formulaMaestraVersionRevisar.getCodVersion()+"' and fmdv.COD_TIPO_PROGRAMA_PROD='"+res.getInt("COD_TIPO_PROGRAMA_PROD")+"'" +
                                  " and fmdv.COD_PRESENTACION_PRODUCTO='"+res.getInt("cod_presentacion")+"' )"+
                                  " or (fmdv.COD_FORMULA_MAESTRA='"+formulaMaestraVersionRevisar.getCodFormulaMaestra()+"'" +
                                  " and fmdv.COD_VERSION='"+formulaMaestraVersionRevisar.getCodVersion()+"'" +
                                  " and fmdv.COD_TIPO_PROGRAMA_PROD='"+res.getInt("COD_TIPO_PROGRAMA_PROD")+"' and fmdv.COD_PRESENTACION_PRODUCTO='"+res.getInt("cod_presentacion")+"'"+
                                  " and fmdv.COD_FORMULA_MAESTRA=fmd.COD_FORMULA_MAESTRA and fmd.COD_PRESENTACION_PRODUCTO=fmdv.COD_PRESENTACION_PRODUCTO"+
                                  " and fmdv.COD_TIPO_PROGRAMA_PROD=fmd.COD_TIPO_PROGRAMA_PROD))order by m.NOMBRE_MATERIAL";
                         System.out.println("consulta detalle es "+consulta);

                         resDetalle=stDetalle.executeQuery(consulta);
                         while(resDetalle.next())
                         {
                             mensajeCorreo+="<tr>" +
                                    "<td class='celdaDetalle' bgColor='"+(resDetalle.getString("cantidad")==null?"#90EE90":(resDetalle.getString("cantidad2")==null?"#FFB6C1":(intercalar?"#eeeeee":"")))+"'><span>"+resDetalle.getString("NOMBRE_MATERIAL")+"</span></td>" +
                                    "<td class='celdaDetalle' bgColor='"+(resDetalle.getString("cantidad")==null?"#90EE90":(resDetalle.getString("cantidad2")==null?"#FFB6C1":(resDetalle.getDouble("cantidad")!=resDetalle.getDouble("cantidad2")?"#F0E68C":(intercalar?"#eeeeee":""))))+"'><span >"+formato.format(resDetalle.getDouble("cantidad"))+"</span></td>" +
                                    "<td class='celdaDetalle' bgColor='"+(resDetalle.getString("cantidad")==null?"#90EE90":(resDetalle.getString("cantidad2")==null?"#FFB6C1":(resDetalle.getDouble("cantidad")!=resDetalle.getDouble("cantidad2")?"#F0E68C":(intercalar?"#eeeeee":""))))+"'><span >"+formato.format(resDetalle.getDouble("cantidad2"))+"</span></td>" +
                                    "<td class='celdaDetalle' bgColor='"+(resDetalle.getString("cantidad")==null?"#90EE90":(resDetalle.getString("cantidad2")==null?"#FFB6C1":(intercalar?"#eeeeee":"")))+"'><span>"+resDetalle.getString("NOMBRE_UNIDAD_MEDIDA")+"</span></td>" +
                                    "</tr>";
                             intercalar=!intercalar;
                         }

                     }
                     mensajeCorreo+="</tbody></table></center>";
                 }
            System.out.println("tabla "+mensajeCorreo);
            st.close();
            
            con.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
    }
    
    public String enviarNuevaFormulaAAprovacion_action()throws SQLException
    {
        mensaje="1";
        for(FormulaMaestraVersion bean:formulasMaestrasNuevasList)
        {
            if(bean.getChecked())
            {
                try
                {
                    con=Util.openConnection(con);
                    con.setAutoCommit(false);
                    ManagedAccesoSistema managed=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
                    String consulta="update FORMULA_MAESTRA_VERSION_MODIFICACION set COD_ESTADO_VERSION_FORMULA_MAESTRA=3"+
                                    "where COD_PERSONAL='"+managed.getUsuarioModuloBean().getCodUsuarioGlobal()+"'" +
                                    " and COD_VERSION_FM='"+bean.getCodVersion()+"'";
                    System.out.println("consulta actualizar "+consulta);
                    PreparedStatement pst=con.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)System.out.println("se envio  la version a aprovacion");
                    consulta="select count(*) as cont from FORMULA_MAESTRA_VERSION_MODIFICACION f where f.COD_VERSION_FM='"+bean.getCodVersion()+"' and "+
                             " f.COD_ESTADO_VERSION_FORMULA_MAESTRA<>3";
                    System.out.println("consulta verificar fm pendientes "+consulta);
                    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet res=st.executeQuery(consulta);
                    res.next();
                    consulta="update FORMULA_MAESTRA_VERSION set COD_ESTADO_VERSION_FORMULA_MAESTRA='"+(res.getInt("cont")>0?5:3)+"'" +
                             " WHERE COD_VERSION='"+bean.getCodVersion()+"' and COD_FORMULA_MAESTRA='"+bean.getCodFormulaMaestra()+"'";
                    System.out.println("consulta enviar a apobacion "+consulta);
                    pst=con.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)System.out.println("se envio  la version a aprovacion");
                    con.commit();
                    mensaje="1";
                    pst.close();
                    con.close();
                }
                catch(SQLException ex)
                {
                    mensaje="Ocurrio un error al momento de enviar a aprovacion, intente de nuevo";
                    con.rollback();con.close();
                    ex.printStackTrace();
                }
            }
        }
        if(mensaje.equals("1"))
        {
            this.cargarFormulasMaestrasNuevas_action();
        }
        return null;
    }
    public String enviarVersionAAprobacion_action()throws SQLException
    {
        mensaje="1";
        for(FormulaMaestraVersion bean:formulaMaestraVersionesList)
        {
            if(bean.getChecked())
            {
                try
                {
                    con=Util.openConnection(con);
                    con.setAutoCommit(false);
                    ManagedAccesoSistema managed=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
                    String consulta="update FORMULA_MAESTRA_VERSION_MODIFICACION set COD_ESTADO_VERSION_FORMULA_MAESTRA=3"+
                                    "where COD_PERSONAL='"+managed.getUsuarioModuloBean().getCodUsuarioGlobal()+"'" +
                                    " and COD_VERSION_FM='"+bean.getCodVersion()+"'";
                    System.out.println("consulta actualizar "+consulta);
                    PreparedStatement pst=con.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)System.out.println("se registro el cambio");
                    consulta="select count(*) as cont from FORMULA_MAESTRA_VERSION_MODIFICACION f where f.COD_VERSION_FM='"+bean.getCodVersion()+"' and "+
                             " f.COD_ESTADO_VERSION_FORMULA_MAESTRA<>3";
                    System.out.println("consulta verificar fm pendientes "+consulta);
                    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet res=st.executeQuery(consulta);
                    res.next();
                    consulta="update FORMULA_MAESTRA_VERSION set COD_ESTADO_VERSION_FORMULA_MAESTRA='"+(res.getInt("cont")>0?5:3)+"'" +
                             " WHERE COD_VERSION='"+bean.getCodVersion()+"' and COD_FORMULA_MAESTRA='"+bean.getCodFormulaMaestra()+"'";
                    System.out.println("consulta enviar a apobacion "+consulta);
                    pst=con.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)System.out.println("se envio  la version a aprovacion");
                    con.commit();
                    mensaje="1";
                    pst.close();
                    con.close();
                }
                catch(SQLException ex)
                {
                    mensaje="Ocurrio un error al momento de enviar a aprovacion, intente de nuevo";
                    con.rollback();con.close();
                    ex.printStackTrace();
                }
            }
        }
        if(mensaje.equals("1"))
        {
            this.cargarVersionesFormulaMaestra();
        }
        return null;
    }
    public String adjuntarPersonalModificacion()throws SQLException
    {
        ManagedAccesoSistema managed=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
        mensaje="";
        try {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            PreparedStatement pst=null;
            for(FormulaMaestraVersion bean:formulaMaestraVersionesList)
            {
                if(bean.getChecked())
                {
                    String consulta="INSERT INTO FORMULA_MAESTRA_VERSION_MODIFICACION(COD_PERSONAL, COD_VERSION_FM,COD_ESTADO_VERSION_FORMULA_MAESTRA)"+
                            " VALUES ('"+managed.getUsuarioModuloBean().getCodUsuarioGlobal()+"','"+bean.getCodVersion()+"',1)";
                    System.out.println("consulta insertar permiso "+consulta);
                    pst=con.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)System.out.println("se registro el permiso");
                    consulta="UPDATE FORMULA_MAESTRA_VERSION  set " +
                            (codAreaEmpresaPersonal==41?" MODIFICACION_MP_EP=1":"")+
                            (codAreaEmpresaPersonal==85||codAreaEmpresaPersonal==93?" MODIFICACION_ES=1":"") +
                            (codAreaEmpresaPersonal==40?" MODIFICACION_R=1":"")+
                             " where COD_VERSION='"+bean.getCodVersion()+"'";
                    System.out.println("consulta adicionar tipo cambio "+consulta);
                    pst=con.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)System.out.println("se registro el cambio");
                }
            }
            con.commit();
            mensaje="1";
            con.close();
        }
        catch (SQLException ex) {
            con.rollback();
            con.close();
            mensaje="Ocurrio un error al momento de asociar los permisos, intente de nuevo";
            ex.printStackTrace();
        }
        if(mensaje.equals("1"))
        {
            this.cargarVersionesFormulaMaestra();
        }
        System.out.println("term"+mensaje);
        return null;
    }
    public String adjuntarPersonalNuevaFormula()throws SQLException
    {
        ManagedAccesoSistema managed=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
        mensaje="";
        try {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            PreparedStatement pst=null;
            for(FormulaMaestraVersion bean:formulasMaestrasNuevasList)
            {
                if(bean.getChecked())
                {
                    String consulta="INSERT INTO FORMULA_MAESTRA_VERSION_MODIFICACION(COD_PERSONAL, COD_VERSION_FM,COD_ESTADO_VERSION_FORMULA_MAESTRA)"+
                            " VALUES ('"+managed.getUsuarioModuloBean().getCodUsuarioGlobal()+"','"+bean.getCodVersion()+"',1)";
                    System.out.println("consulta insertar permiso "+consulta);
                    pst=con.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)System.out.println("se registro el permiso");
                    consulta="UPDATE FORMULA_MAESTRA_VERSION  set " +
                            (codAreaEmpresaPersonal==41?" MODIFICACION_MP_EP=1":"")+
                            (codAreaEmpresaPersonal==85||codAreaEmpresaPersonal==93?" MODIFICACION_ES=1":"") +
                            (codAreaEmpresaPersonal==40?" MODIFICACION_R=1":"")+
                             " where COD_VERSION='"+bean.getCodVersion()+"'";
                    System.out.println("consulta adicionar tipo cambio "+consulta);
                    pst=con.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)System.out.println("se registro el cambio");
                }
            }
            con.commit();
            mensaje="1";
            con.close();
        }
        catch (SQLException ex) {
            con.rollback();
            con.close();
            mensaje="Ocurrio un error al momento de asociar los permisos, intente de nuevo";
            ex.printStackTrace();
        }
        if(mensaje.equals("1"))
        {
            this.cargarFormulasMaestrasNuevas_action();
        }
        System.out.println("term"+mensaje);
        return null;
    }
    public String crearNuevaVersionFormulaMaestra_action() throws SQLException
    {
        mensaje="";
        try
        {
                con=Util.openConnection(con);
                con.setAutoCommit(false);
                PreparedStatement pst=null;
                String consulta="select count(*) as contador from FORMULA_MAESTRA_VERSION f where f.COD_ESTADO_VERSION_FORMULA_MAESTRA in (1,3)"+
                                " and f.COD_FORMULA_MAESTRA='"+formulaMaestraBean.getCodFormulaMaestra()+"'";
                System.out.println("consulta verificar existencia de formula maestra aprobacion generada "+consulta);
                Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet res=st.executeQuery(consulta);
                res.next();
                if(res.getInt("contador")>0)
                {
                    mensaje="No se puede crear otra version porque ya existe una version generada o en aprobacion";
                }
                else
                {
                        consulta="select isnull(max(f.NRO_VERSION),0)+1 as nroVersion from FORMULA_MAESTRA_VERSION f where f.COD_FORMULA_MAESTRA='"+formulaMaestraBean.getCodFormulaMaestra()+"'";
                        res=st.executeQuery(consulta);
                        int nroversion=0;
                        if(res.next())
                        {
                            nroversion=res.getInt("nroVersion");
                        }
                        consulta="select isnull(max(f.COD_VERSION),0)+1 as codVersion from FORMULA_MAESTRA_VERSION f";
                        res=st.executeQuery(consulta);
                        int codVersion=0;
                        if(res.next())
                        {
                            codVersion=res.getInt("codVersion");
                        }

                        ManagedAccesoSistema usuario=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
                        SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm");
                        consulta="insert into FORMULA_MAESTRA_VERSION (COD_VERSION, COD_FORMULA_MAESTRA,COD_COMPPROD,CANTIDAD_LOTE,ESTADO_SISTEMA,"+
                                 " COD_ESTADO_REGISTRO,NRO_VERSION,FECHA_MODIFICACION,COD_ESTADO_VERSION_FORMULA_MAESTRA,COD_PERSONAL_CREACION,MODIFICACION_NF,MODIFICACION_MP_EP,MODIFICACION_ES,MODIFICACION_R) select "+codVersion+",f.COD_FORMULA_MAESTRA,f.COD_COMPPROD,f.CANTIDAD_LOTE,f.ESTADO_SISTEMA"+
                                       " ,f.COD_ESTADO_REGISTRO,"+nroversion+",'"+sdf.format(new Date())+"',1 ,"+usuario.getUsuarioModuloBean().getCodUsuarioGlobal()+",0,'"+(codAreaEmpresaPersonal==41?1:0)+"','"+(codAreaEmpresaPersonal==85||codAreaEmpresaPersonal==93?1:0)+"','"+(codAreaEmpresaPersonal==40?1:0)+"'"+
                                       " from FORMULA_MAESTRA f where f.COD_FORMULA_MAESTRA='"+formulaMaestraBean.getCodFormulaMaestra()+"'";
                        System.out.println("consulta insert copia cabecera "+consulta);
                        pst=con.prepareStatement(consulta);
                        if(pst.executeUpdate()>0)System.out.println("se inserto la cabecera de la version");

                        consulta="insert into FORMULA_MAESTRA_DETALLE_MP_VERSION (COD_VERSION,COD_FORMULA_MAESTRA,COD_MATERIAL,"+
                                 " CANTIDAD,COD_UNIDAD_MEDIDA,NRO_PREPARACIONES,FECHA_MODIFICACION)  select "+codVersion+",f.COD_FORMULA_MAESTRA,f.COD_MATERIAL,f.CANTIDAD,"+
                                 " m.COD_UNIDAD_MEDIDA,f.NRO_PREPARACIONES,'"+sdf.format(new Date())+"'"+
                                 " from FORMULA_MAESTRA_DETALLE_MP f inner join materiales m on m.COD_MATERIAL=f.COD_MATERIAL where f.COD_FORMULA_MAESTRA='"+formulaMaestraBean.getCodFormulaMaestra()+"' ";//and f.COD_VERSION='"+codversionActiva+"'
                        System.out.println("consulta duplicar formula maestra detalle versione "+consulta);
                        pst=con.prepareStatement(consulta);
                        if(pst.executeUpdate()>0)System.out.println("se registraron la versiones detalle ");

                        consulta="insert into FORMULA_MAESTRA_DETALLE_MP_FRACCIONES_VERSION (COD_VERSION,COD_FORMULA_MAESTRA,COD_MATERIAL,"+
                                 " COD_FORMULA_MAESTRA_FRACCIONES,CANTIDAD,COD_TIPO_MATERIAL_PRODUCCION)" +
                                 " select "+codVersion+",f.COD_FORMULA_MAESTRA,f.COD_MATERIAL,f.COD_FORMULA_MAESTRA_FRACCIONES,f.CANTIDAD,F.COD_TIPO_MATERIAL_PRODUCCION"+
                                 " from FORMULA_MAESTRA_DETALLE_MP_FRACCIONES f where f.COD_FORMULA_MAESTRA='"+formulaMaestraBean.getCodFormulaMaestra()+"' ";//and f.COD_VERSION='"+codversionActiva+"'
                        System.out.println("consulta duplicar fracciones detalle "+consulta);
                        pst=con.prepareStatement(consulta);
                        if(pst.executeUpdate()>0)System.out.println("se registro la version detalle fracciones");


                        consulta="INSERT INTO FORMULA_MAESTRA_DETALLE_EP_VERSION(COD_VERSION, COD_FORMULA_MAESTRA,"+
                                 " COD_PRESENTACION_PRIMARIA, COD_MATERIAL, CANTIDAD, COD_UNIDAD_MEDIDA)"+
                                 " select '"+codVersion+"',f.COD_FORMULA_MAESTRA,f.COD_PRESENTACION_PRIMARIA,f.COD_MATERIAL,f.CANTIDAD,m.COD_UNIDAD_MEDIDA"+
                                 " from FORMULA_MAESTRA_DETALLE_EP f inner join materiales m on m.COD_MATERIAL=f.COD_MATERIAL" +
                                 " where f.COD_FORMULA_MAESTRA='"+formulaMaestraBean.getCodFormulaMaestra()+"'";
                                 //" and f.COD_VERSION='"+codversionActiva+"'";
                        System.out.println("consulta duplicar ep "+consulta);
                        pst=con.prepareStatement(consulta);
                        if(pst.executeUpdate()>0)System.out.println("se duplicaron los ep");

                        consulta="INSERT INTO FORMULA_MAESTRA_DETALLE_ES_VERSION(COD_VERSION, COD_FORMULA_MAESTRA,"+
                                 " COD_MATERIAL, CANTIDAD, COD_UNIDAD_MEDIDA, COD_PRESENTACION_PRODUCTO,COD_TIPO_PROGRAMA_PROD)"+
                                 " select '"+codVersion+"',f.COD_FORMULA_MAESTRA,f.COD_MATERIAL,f.CANTIDAD,m.COD_UNIDAD_MEDIDA,"+
                                 " f.COD_PRESENTACION_PRODUCTO,f.COD_TIPO_PROGRAMA_PROD"+
                                 " from FORMULA_MAESTRA_DETALLE_ES f inner join materiales m on m.COD_MATERIAL=f.COD_MATERIAL " +
                                 " where f.COD_FORMULA_MAESTRA='"+formulaMaestraBean.getCodFormulaMaestra()+"'";
                                 //" and f.COD_VERSION='"+codversionActiva+"'";
                        System.out.println("consulta duplicar es "+consulta);
                        pst=con.prepareStatement(consulta);
                        if(pst.executeUpdate()>0)System.out.println("se duplicaron los es");

                        consulta="INSERT INTO FORMULA_MAESTRA_DETALLE_MR_VERSION(COD_VERSION, COD_FORMULA_MAESTRA,"+
                                 " COD_MATERIAL, CANTIDAD, COD_UNIDAD_MEDIDA, NRO_PREPARACIONES, COD_TIPO_MATERIAL,"+
                                 " COD_TIPO_ANALISIS_MATERIAL)"+
                                 " select '"+codVersion+"',f.COD_FORMULA_MAESTRA,f.COD_MATERIAL,f.CANTIDAD,m.COD_UNIDAD_MEDIDA,"+
                                 " f.NRO_PREPARACIONES,f.COD_TIPO_MATERIAL,f.COD_TIPO_ANALISIS_MATERIAL"+
                                 " from FORMULA_MAESTRA_DETALLE_MR f inner join materiales m on m.COD_MATERIAL=f.COD_MATERIAL" +
                                 " where f.COD_FORMULA_MAESTRA='"+formulaMaestraBean.getCodFormulaMaestra()+"' ";
                                 //" f.COD_VERSION='"+codversionActiva+"'";
                        System.out.println("consulta duplicar  mr "+consulta);
                        pst=con.prepareStatement(consulta);
                        if(pst.executeUpdate()>0)System.out.println("se duplicaron los mr");

                        consulta="INSERT INTO FORMULA_MAESTRA_MR_CLASIFICACION_VERSION(COD_VERSION,"+
                                 " COD_FORMULA_MAESTRA, COD_MATERIAL, COD_TIPO_ANALISIS_MATERIAL_REACTIVO)"+
                                 " select '"+codVersion+"',f.COD_FORMULA_MAESTRA,f.COD_MATERIAL,f.COD_TIPO_ANALISIS_MATERIAL_REACTIVO"+
                                 " from FORMULA_MAESTRA_MR_CLASIFICACION f where f.COD_FORMULA_MAESTRA='"+formulaMaestraBean.getCodFormulaMaestra()+"'";
                                 //" and f.COD_VERSION='"+codversionActiva+"'";
                        System.out.println("consulta duplicar clasificacion mr "+consulta);
                        pst=con.prepareStatement(consulta);
                        if(pst.executeUpdate()>0)System.out.println("se duplicarion las clasificaciones mr");
                        consulta="INSERT INTO FORMULA_MAESTRA_VERSION_MODIFICACION(COD_PERSONAL, COD_VERSION_FM,"+
                                 " COD_ESTADO_VERSION_FORMULA_MAESTRA)"+
                                 " VALUES ('"+usuario.getUsuarioModuloBean().getCodUsuarioGlobal()+"','"+codVersion+"',1)";
                        System.out.println("consulta insert personal modificaicon "+consulta);
                        pst=con.prepareStatement(consulta);
                        if(pst.executeUpdate()>0)System.out.println("se registro el permiso usuario");
                }
                con.commit();
                mensaje=(mensaje.equals("")?"1":mensaje);
                st.close();
                if(pst!=null)pst.close();
                con.close();

        }
        catch(SQLException ex)
        {
            mensaje="Ocurrion un error al momento de crear la nueva version,intente de nuevo";
            con.rollback();
            con.close();
            ex.printStackTrace();
        }
        if(mensaje.equals("1"))
        {
            this.cargarVersionesFormulaMaestra();
        }
        return null;
    }


    public String guardarNuevaFormulaMaestra()throws SQLException
    {
        mensaje="";
        try
        {
            con=Util.openConnection(con);
            con.setAutoCommit(false);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select isnull(max(f.COD_VERSION),0)+1 as codVersion,isnull(MIN(f.COD_FORMULA_MAESTRA),0)-1 as codFormulaMAestra from FORMULA_MAESTRA_VERSION f";
            ResultSet res=st.executeQuery(consulta);
            int codVersionFormula=0;
            int codFormulaMaestra=0;
            if(res.next())
            {
                codVersionFormula=res.getInt("codVersion");
                codFormulaMaestra=(res.getInt("codFormulaMAestra")<0?res.getInt("codFormulaMAestra"):-1);
            }
            SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm");
            ManagedAccesoSistema managed=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
            consulta="INSERT INTO FORMULA_MAESTRA_VERSION(COD_VERSION, COD_FORMULA_MAESTRA,"+
                     " COD_COMPPROD, CANTIDAD_LOTE, ESTADO_SISTEMA, COD_ESTADO_REGISTRO, NRO_VERSION,"+
                     " FECHA_MODIFICACION, FECHA_INICIO_VIGENCIA, COD_ESTADO_VERSION_FORMULA_MAESTRA,COD_PERSONAL_CREACION,MODIFICACION_NF,MODIFICACION_MP_EP)"+
                     " VALUES ('"+codVersionFormula+"','"+codFormulaMaestra+"','"+formulaMaestraVersionAbm.getComponentesProd().getCodCompprod()+"'," +
                     " '"+formulaMaestraVersionAbm.getCantidadLote()+"',"+
                     "1, 1, 1,'"+sdf.format(new Date())+"',null,1,'"+managed.getUsuarioModuloBean().getCodUsuarioGlobal()+"',1,1)";
            System.out.println("consulta guardar nueva Formula maestra "+consulta);
            PreparedStatement pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se registro la nueva formula en version");
            consulta="INSERT INTO FORMULA_MAESTRA_VERSION_MODIFICACION(COD_PERSONAL, COD_VERSION_FM,COD_ESTADO_VERSION_FORMULA_MAESTRA)"+
                     " VALUES ('"+managed.getUsuarioModuloBean().getCodUsuarioGlobal()+"', '"+codVersionFormula+"', 1)";
            System.out.println("consulta insert permiso modificacion "+consulta);
            pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se registro la nueva version modificacion");
            con.commit();
            mensaje="1";
            pst.close();
            res.close();
            st.close();
            con.close();
        }
        catch(SQLException ex)
        {
            mensaje="Ocurrio un error al momento de guardar la nueva formula maestra,intente de nuevo";
            con.rollback();
            con.close();
            ex.printStackTrace();
        }
        return null;

    }


    //<editor-fold desc="getter and setter" defaultstate="collapsed">

    public List<SelectItem> getEnvasesPrimariosSelectList() {
        return envasesPrimariosSelectList;
    }

    public void setEnvasesPrimariosSelectList(List<SelectItem> envasesPrimariosSelectList) {
        this.envasesPrimariosSelectList = envasesPrimariosSelectList;
    }

    public List<SelectItem> getTiposProgramaProduccionSelectList() {
        return tiposProgramaProduccionSelectList;
    }

    public void setTiposProgramaProduccionSelectList(List<SelectItem> tiposProgramaProduccionSelectList) {
        this.tiposProgramaProduccionSelectList = tiposProgramaProduccionSelectList;
    }

    public PresentacionesPrimarias getPresentacionesPrimariasAgregar() {
        return presentacionesPrimariasAgregar;
    }

    public void setPresentacionesPrimariasAgregar(PresentacionesPrimarias presentacionesPrimariasAgregar) {
        this.presentacionesPrimariasAgregar = presentacionesPrimariasAgregar;
    }

    
    
    
    public FormulaMaestra getFormulaMaestraBean() {
        return formulaMaestraBean;
    }

    public void setFormulaMaestraBean(FormulaMaestra formulaMaestraBean) {
        this.formulaMaestraBean = formulaMaestraBean;
    }

    public List<FormulaMaestraVersion> getFormulaMaestraVersionesList() {
        return formulaMaestraVersionesList;
    }

    public void setFormulaMaestraVersionesList(List<FormulaMaestraVersion> formulaMaestraVersionesList) {
        this.formulaMaestraVersionesList = formulaMaestraVersionesList;
    }

    public String getMensaje() {
        return mensaje;
    }

    public void setMensaje(String mensaje) {
        this.mensaje = mensaje;
    }

    public HtmlDataTable getFormulaMaestraVersionesData() {
        return formulaMaestraVersionesData;
    }

    public void setFormulaMaestraVersionesData(HtmlDataTable formulaMaestraVersionesData) {
        this.formulaMaestraVersionesData = formulaMaestraVersionesData;
    }

    public List<TiposMaterialProduccion> getFormulaMaestraDetalleMPList() {
        return formulaMaestraDetalleMPList;
    }

    public void setFormulaMaestraDetalleMPList(List<TiposMaterialProduccion> formulaMaestraDetalleMPList) {
        this.formulaMaestraDetalleMPList = formulaMaestraDetalleMPList;
    }

    public TiposMaterialProduccion getTiposMaterialProduccionAgregar() {
        return tiposMaterialProduccionAgregar;
    }

    public void setTiposMaterialProduccionAgregar(TiposMaterialProduccion tiposMaterialProduccionAgregar) {
        this.tiposMaterialProduccionAgregar = tiposMaterialProduccionAgregar;
    }

    

    public FormulaMaestraVersion getFormulaMaestraVersionaBean() {
        return formulaMaestraVersionaBean;
    }

    public void setFormulaMaestraVersionaBean(FormulaMaestraVersion formulaMaestraVersionaBean) {
        this.formulaMaestraVersionaBean = formulaMaestraVersionaBean;
    }

    public List<FormulaMaestraDetalleMP> getFormulaMaestraDetalleMPEditarList() {
        return formulaMaestraDetalleMPEditarList;
    }

    public void setFormulaMaestraDetalleMPEditarList(List<FormulaMaestraDetalleMP> formulaMaestraDetalleMPEditarList) {
        this.formulaMaestraDetalleMPEditarList = formulaMaestraDetalleMPEditarList;
    }

    public FormulaMaestraDetalleMP getFormulaMaestraDetalleMPBean() {
        return formulaMaestraDetalleMPBean;
    }

    public void setFormulaMaestraDetalleMPBean(FormulaMaestraDetalleMP formulaMaestraDetalleMPBean) {
        this.formulaMaestraDetalleMPBean = formulaMaestraDetalleMPBean;
    }

    public List<FormulaMaestraDetalleMPfracciones> getFormulaMaestraDetalleMPfraccionesEditar() {
        return formulaMaestraDetalleMPfraccionesEditar;
    }

    public void setFormulaMaestraDetalleMPfraccionesEditar(List<FormulaMaestraDetalleMPfracciones> formulaMaestraDetalleMPfraccionesEditar) {
        this.formulaMaestraDetalleMPfraccionesEditar = formulaMaestraDetalleMPfraccionesEditar;
    }


    public List<SelectItem> getTiposMaterialProduccionSelectList() {
        return tiposMaterialProduccionSelectList;
    }

    public void setTiposMaterialProduccionSelectList(List<SelectItem> tiposMaterialProduccionSelectList) {
        this.tiposMaterialProduccionSelectList = tiposMaterialProduccionSelectList;
    }

    public List<FormulaMaestraDetalleMP> getFormulaMaestraDetalleMPAgregarList() {
        return formulaMaestraDetalleMPAgregarList;
    }

    public void setFormulaMaestraDetalleMPAgregarList(List<FormulaMaestraDetalleMP> formulaMaestraDetalleMPAgregarList) {
        this.formulaMaestraDetalleMPAgregarList = formulaMaestraDetalleMPAgregarList;
    }

    public List<FormulaMaestraVersion> getFormulaMaestraVersionAprobarList() {
        return formulaMaestraVersionAprobarList;
    }

    public void setFormulaMaestraVersionAprobarList(List<FormulaMaestraVersion> formulaMaestraVersionAprobarList) {
        this.formulaMaestraVersionAprobarList = formulaMaestraVersionAprobarList;
    }

    
    public List<FormulaMaestraVersion> getFormulasMaestrasNuevasList() {
        return formulasMaestrasNuevasList;
    }

    public void setFormulasMaestrasNuevasList(List<FormulaMaestraVersion> formulasMaestrasNuevasList) {
        this.formulasMaestrasNuevasList = formulasMaestrasNuevasList;
    }

    public List<SelectItem> getComponentesProdSelectList() {
        return componentesProdSelectList;
    }

    public void setComponentesProdSelectList(List<SelectItem> componentesProdSelectList) {
        this.componentesProdSelectList = componentesProdSelectList;
    }

    public FormulaMaestraVersion getFormulaMaestraVersionAbm() {
        return formulaMaestraVersionAbm;
    }

    public void setFormulaMaestraVersionAbm(FormulaMaestraVersion formulaMaestraVersionAbm) {
        this.formulaMaestraVersionAbm = formulaMaestraVersionAbm;
    }

    public List<SelectItem> getTiposProduccionSelectList() {
        return tiposProduccionSelectList;
    }

    public void setTiposProduccionSelectList(List<SelectItem> tiposProduccionSelectList) {
        this.tiposProduccionSelectList = tiposProduccionSelectList;
    }

    public HtmlDataTable getFormulasMaestrasNuevasDataTable() {
        return formulasMaestrasNuevasDataTable;
    }

    public void setFormulasMaestrasNuevasDataTable(HtmlDataTable formulasMaestrasNuevasDataTable) {
        this.formulasMaestrasNuevasDataTable = formulasMaestrasNuevasDataTable;
    }

    public FormulaMaestraVersion getFormulaMaestraVersionEditar() {
        return formulaMaestraVersionEditar;
    }

    public void setFormulaMaestraVersionEditar(FormulaMaestraVersion formulaMaestraVersionEditar) {
        this.formulaMaestraVersionEditar = formulaMaestraVersionEditar;
    }

    public List<PresentacionesPrimarias> getFormulaMaestraEPList() {
        return formulaMaestraEPList;
    }

    public void setFormulaMaestraEPList(List<PresentacionesPrimarias> formulaMaestraEPList) {
        this.formulaMaestraEPList = formulaMaestraEPList;
    }

    

    public HtmlDataTable getFormulaMaestraEpDataTable() {
        return formulaMaestraEpDataTable;
    }

    public void setFormulaMaestraEpDataTable(HtmlDataTable formulaMaestraEpDataTable) {
        this.formulaMaestraEpDataTable = formulaMaestraEpDataTable;
    }

    

    public List<FormulaMaestraES> getFormulaMaestraESList() {
        return formulaMaestraESList;
    }

    public void setFormulaMaestraESList(List<FormulaMaestraES> formulaMaestraESList) {
        this.formulaMaestraESList = formulaMaestraESList;
    }

    public FormulaMaestraEP getFormulaMaestraEPBean() {
        return formulaMaestraEPBean;
    }

    public void setFormulaMaestraEPBean(FormulaMaestraEP formulaMaestraEPBean) {
        this.formulaMaestraEPBean = formulaMaestraEPBean;
    }

    public FormulaMaestraES getFormulaMaestraESBean() {
        return formulaMaestraESBean;
    }

    public void setFormulaMaestraESBean(FormulaMaestraES formulaMaestraESBean) {
        this.formulaMaestraESBean = formulaMaestraESBean;
    }

    public HtmlDataTable getFormulaMaestraESDataTable() {
        return formulaMaestraESDataTable;
    }

    public void setFormulaMaestraESDataTable(HtmlDataTable formulaMaestraESDataTable) {
        this.formulaMaestraESDataTable = formulaMaestraESDataTable;
    }

    public List<FormulaMaestraDetalleES> getFormulaMaestraDetalleESList() {
        return formulaMaestraDetalleESList;
    }

    public void setFormulaMaestraDetalleESList(List<FormulaMaestraDetalleES> formulaMaestraDetalleESList) {
        this.formulaMaestraDetalleESList = formulaMaestraDetalleESList;
    }

    public List<FormulaMaestraDetalleES> getFormulaMaestraDetalleESAgregarList() {
        return formulaMaestraDetalleESAgregarList;
    }

    public void setFormulaMaestraDetalleESAgregarList(List<FormulaMaestraDetalleES> formulaMaestraDetalleESAgregarList) {
        this.formulaMaestraDetalleESAgregarList = formulaMaestraDetalleESAgregarList;
    }

    public List<FormulaMaestraDetalleES> getFormulaMaestraDetalleESEditarList() {
        return formulaMaestraDetalleESEditarList;
    }

    public PresentacionesPrimarias getPresentacionesPrimariasEditar() {
        return presentacionesPrimariasEditar;
    }

    public void setPresentacionesPrimariasEditar(PresentacionesPrimarias presentacionesPrimariasEditar) {
        this.presentacionesPrimariasEditar = presentacionesPrimariasEditar;
    }
    

    public void setFormulaMaestraDetalleESEditarList(List<FormulaMaestraDetalleES> formulaMaestraDetalleESEditarList) {
        this.formulaMaestraDetalleESEditarList = formulaMaestraDetalleESEditarList;
    }

    public List<FormulaMaestraDetalleMr> getFormulaMaestraDetalleMRList() {
        return formulaMaestraDetalleMRList;
    }

    public void setFormulaMaestraDetalleMRList(List<FormulaMaestraDetalleMr> formulaMaestraDetalleMRList) {
        this.formulaMaestraDetalleMRList = formulaMaestraDetalleMRList;
    }

    public List<SelectItem> getTiposAnalisisMaterialReactivoSelectList() {
        return tiposAnalisisMaterialReactivoSelectList;
    }

    public void setTiposAnalisisMaterialReactivoSelectList(List<SelectItem> tiposAnalisisMaterialReactivoSelectList) {
        this.tiposAnalisisMaterialReactivoSelectList = tiposAnalisisMaterialReactivoSelectList;
    }

    public List<SelectItem> getTiposMaterialReactivoSelectList() {
        return tiposMaterialReactivoSelectList;
    }

    public void setTiposMaterialReactivoSelectList(List<SelectItem> tiposMaterialReactivoSelectList) {
        this.tiposMaterialReactivoSelectList = tiposMaterialReactivoSelectList;
    }

    public List<FormulaMaestraDetalleMr> getFormulaMaestraDetalleMRAgregarList() {
        return formulaMaestraDetalleMRAgregarList;
    }

    public void setFormulaMaestraDetalleMRAgregarList(List<FormulaMaestraDetalleMr> formulaMaestraDetalleMRAgregarList) {
        this.formulaMaestraDetalleMRAgregarList = formulaMaestraDetalleMRAgregarList;
    }

    public int getCodTipoMaterialReactivo() {
        return codTipoMaterialReactivo;
    }

    public void setCodTipoMaterialReactivo(int codTipoMaterialReactivo) {
        this.codTipoMaterialReactivo = codTipoMaterialReactivo;
    }

    public List<FormulaMaestraDetalleMr> getFormulaMaestraDetalleMREditarList() {
        return formulaMaestraDetalleMREditarList;
    }

    public void setFormulaMaestraDetalleMREditarList(List<FormulaMaestraDetalleMr> formulaMaestraDetalleMREditarList) {
        this.formulaMaestraDetalleMREditarList = formulaMaestraDetalleMREditarList;
    }

    public FormulaMaestraVersion getFormulaMaestraVersionRevisar() {
        return formulaMaestraVersionRevisar;
    }

    public void setFormulaMaestraVersionRevisar(FormulaMaestraVersion formulaMaestraVersionRevisar) {
        this.formulaMaestraVersionRevisar = formulaMaestraVersionRevisar;
    }

    public int getCodAreaEmpresaPersonal() {
        return codAreaEmpresaPersonal;
    }

    public void setCodAreaEmpresaPersonal(int codAreaEmpresaPersonal) {
        this.codAreaEmpresaPersonal = codAreaEmpresaPersonal;
    }
    //</editor-fold>
}
