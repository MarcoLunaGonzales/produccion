/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.web;

import com.cofar.bean.FormulaMaestra;
import com.cofar.bean.FormulaMaestraDetalleMP;
import com.cofar.bean.ProgramaProduccion;
import com.cofar.util.Util;
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
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import org.richfaces.component.html.HtmlDataTable;
import javax.faces.context.ExternalContext;
import javax.faces.context.FacesContext;
import javax.faces.model.SelectItem;
import org.joda.time.DateTime;
import org.apache.logging.log4j.LogManager;
/**
 *
 * @author aquispe
 */

public class ManagedProgramaProduccionDesarrollo extends ManagedBean{

    private List<SelectItem> estadosProgramaProduccion=new ArrayList<SelectItem>();
    private ProgramaProduccion programaProduccionbean=new ProgramaProduccion();
    private String codProgramaProd="0";
    private List<ProgramaProduccion> programaProduccionList=new ArrayList<ProgramaProduccion>();
    private List tiposProgramaProdList = new ArrayList();
    private Connection con=null;
    private String codEstadoProgramaProduccion="";
    private HtmlDataTable programaProduccionDataTable=new HtmlDataTable();
    private HtmlDataTable programaProduccionAgregarDataTable=new HtmlDataTable();
    private ProgramaProduccion programaProduccionEditar=new ProgramaProduccion();
    private List<ProgramaProduccion> programaProduccionEditarList=new ArrayList<ProgramaProduccion>();
    private String codigo="";
    private List<SelectItem> formulaMaestraList=new ArrayList<SelectItem>();
    private List<ProgramaProduccion> programaProduccionAgregarList=new ArrayList<ProgramaProduccion>();
    private ProgramaProduccion currentProgramaProd= new ProgramaProduccion();
    private Date fechaLote=new Date();
    private HtmlDataTable programaProduccionEditarDataTable=new HtmlDataTable();
    private String mensaje="";
    private ProgramaProduccion programaProduccionDetalle=new ProgramaProduccion();
    private List formulaMaestraMPList=new ArrayList();
    private List formulaMaestraEPList=new ArrayList();
    private List formulaMaestraESList=new ArrayList();
    private List formulaMaestraMRList = new ArrayList();
    private List formulaMaestraMPROMList=new  ArrayList();
    public ManagedProgramaProduccionDesarrollo() {
        LOGGER=LogManager.getRootLogger();
    }

    public String  getCargarProgramaProduccion1(){
        this.cargarEstadosProgramProduccion();
        String codProgramaProdF=Util.getParameter("codProgramaProd");
        if(codProgramaProdF!=null){
            programaProduccionbean.setCodProgramaProduccion(codProgramaProdF);
            setCodProgramaProd(codProgramaProdF);
        }
        this.cargarProgramaProduccion_Action();
        return"";
    }

    public double redondear( double numero, int decimales ) {
        return Math.round(numero*Math.pow(10,decimales))/Math.pow(10,decimales);
    }
    private void cargarProgramaProduccion_Action()
    {
        try {
            ManagedAccesoSistema accesoSistema = (ManagedAccesoSistema) Util.getSessionBean("ManagedAccesoSistema");
            String consulta =" SELECT UAPR.COD_AREA_EMPRESA FROM USUARIOS_AREA_PRODUCCION UAPR " +
                             " WHERE UAPR.COD_PERSONAL = "+accesoSistema.getUsuarioModuloBean().getCodUsuarioGlobal()+" and uapr.cod_tipo_permiso = 1 ";
            System.out.println("consulta " + consulta);
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(consulta);
            String codAreaEmpresa ="''";
            while(rs.next()) {
                codAreaEmpresa= codAreaEmpresa + ","+rs.getString("COD_AREA_EMPRESA");
            }

            String sql="select pp.cod_programa_prod,fm.cod_formula_maestra,pp.cod_lote_produccion,"+
                       " pp.fecha_inicio,pp.fecha_final,pp.cod_estado_programa,pp.observacion,"+
                       " cp.nombre_prod_semiterminado,cp.cod_compprod,fm.cantidad_lote,epp.NOMBRE_ESTADO_PROGRAMA_PROD,pp.cant_lote_produccion,tp.COD_TIPO_PROGRAMA_PROD,tp.NOMBRE_TIPO_PROGRAMA_PROD"+
                       " ,ISNULL((SELECT C.NOMBRE_CATEGORIACOMPPROD FROM CATEGORIAS_COMPPROD C WHERE C.COD_CATEGORIACOMPPROD=cp.COD_CATEGORIACOMPPROD),''),pp.MATERIAL_TRANSITO " +
                       " ,(SELECT ISNULL(ae.NOMBRE_AREA_EMPRESA,'') FROM AREAS_EMPRESA ae WHERE ae.COD_AREA_EMPRESA =cp.COD_AREA_EMPRESA) NOMBRE_AREA_EMPRESA,cp.VIDA_UTIL,cp.COD_AREA_EMPRESA " +
                       " , (select top 1 ap.NOMBRE_ACTIVIDAD from SEGUIMIENTO_PROGRAMA_PRODUCCION s inner join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_ACTIVIDAD_FORMULA = s.COD_ACTIVIDAD_PROGRAMA " +
                       "  inner join ACTIVIDADES_PRODUCCION ap on ap.COD_ACTIVIDAD = afm.COD_ACTIVIDAD       " +
                       " where s.COD_PROGRAMA_PROD = pp.COD_PROGRAMA_PROD" +
                       "   and s.COD_COMPPROD = pp.COD_COMPPROD and s.COD_FORMULA_MAESTRA = pp.COD_FORMULA_MAESTRA and s.COD_LOTE_PRODUCCION = pp.COD_LOTE_PRODUCCION " +
                       "   and (s.HORAS_HOMBRE >0 or s.HORAS_MAQUINA >0) and s.COD_TIPO_PROGRAMA_PROD in( pp.COD_TIPO_PROGRAMA_PROD , 0) and ap.COD_TIPO_ACTIVIDAD_PRODUCCION = 1 " +
                       "   order by afm.COD_ACTIVIDAD_FORMULA  desc ) NOMBRE_ACTIVIDAD "+
                       " ,ISNULL((select ff.nombre_forma from FORMAS_FARMACEUTICAS ff where ff.cod_forma=cp.COD_FORMA),'') as formaFar"+
                       " from programa_produccion pp,formula_maestra fm,componentes_prod cp,ESTADOS_PROGRAMA_PRODUCCION epp,TIPOS_PROGRAMA_PRODUCCION tp"+
                       " where pp.cod_formula_maestra=fm.cod_formula_maestra and cp.cod_compprod=fm.cod_compprod and epp.COD_ESTADO_PROGRAMA_PROD=pp.cod_estado_programa"+
                       " and tp.COD_TIPO_PROGRAMA_PROD = pp.COD_TIPO_PROGRAMA_PROD and pp.cod_estado_programa in (2,5,6,7)"+((!codProgramaProd.equals("")&&!codProgramaProd.equals("0"))?" and pp.cod_programa_prod="+codProgramaProd:"")+
                       " and cp.cod_area_empresa in ("+codAreaEmpresa+")"+
                       ((codEstadoProgramaProduccion.equals("0")||codEstadoProgramaProduccion.equals(""))?"":" and pp.cod_estado_programa='"+codEstadoProgramaProduccion+"'");
                     
            System.out.println("sql navegador:"+sql);
            rs=st.executeQuery(sql);
            rs.last();
            int rows=rs.getRow();
            programaProduccionList.clear();
            rs.first();
            String cod="";
            for(int i=0;i<rows;i++){
                ProgramaProduccion bean=new ProgramaProduccion();
                bean.setCodProgramaProduccion(rs.getString(1));
                bean.getFormulaMaestra().setCodFormulaMaestra(rs.getString(2));
                bean.setCodLoteProduccion(rs.getString(3));
                bean.setCodLoteProduccionAnterior(rs.getString(3));
                String fechaInicio="";
                String fechaFinal="";
                bean.setCodEstadoPrograma(rs.getString(6));
                bean.setObservacion(rs.getString(7));
                bean.getFormulaMaestra().getComponentesProd().setNombreProdSemiterminado(rs.getString(8));
                bean.getFormulaMaestra().getComponentesProd().setCodCompprod(rs.getString(9));
                bean.getFormulaMaestra().getComponentesProd().getForma().setNombreForma(rs.getString("formaFar"));
                double cantidad=rs.getDouble(10);
                cantidad=redondear(cantidad,3);
                NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
                DecimalFormat form = (DecimalFormat)nf;
                form.applyPattern("#,#00.0#");
                bean.getFormulaMaestra().setCantidadLote(cantidad);
                bean.getEstadoProgramaProduccion().setNombreEstadoProgramaProd(rs.getString(11) + "(" +(rs.getString("NOMBRE_ACTIVIDAD")==null?"":rs.getString("NOMBRE_ACTIVIDAD")) +  ")");
                cantidad=rs.getDouble(12);
                cantidad=redondear(cantidad,3);
                bean.getTiposProgramaProduccion().setNombreProgramaProd(rs.getString(14));
                bean.getCategoriasCompProd().setNombreCategoriaCompProd(rs.getString(15));
                bean.setCantidadLote(cantidad);
                bean.getEstadoProgramaProduccion().setCodEstadoProgramaProd(rs.getString("cod_estado_programa"));
                bean.getFormulaMaestra().getComponentesProd().getAreasEmpresa().setNombreAreaEmpresa(rs.getString("NOMBRE_AREA_EMPRESA"));
                bean.getFormulaMaestra().getComponentesProd().getAreasEmpresa().setCodAreaEmpresa(rs.getString("COD_AREA_EMPRESA"));
                bean.getTiposProgramaProduccion().setCodTipoProgramaProd(rs.getString("COD_TIPO_PROGRAMA_PROD"));
                int materialTransito=rs.getInt(16);
                if (materialTransito == 0) {
                    bean.setMaterialTransito("CON EXISTENCIA");
                    bean.setStyleClass("b");
                }
                if (materialTransito == 1) {
                    bean.setMaterialTransito("EN TRÁNSITO");
                    bean.setStyleClass("a");
                }
                bean.getFormulaMaestra().getComponentesProd().setVidaUtil(rs.getInt("VIDA_UTIL"));
                programaProduccionList.add(bean);
                rs.next();
            }
            rs.close();
            st.close();
            con.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


    private void cargarEstadosProgramProduccion()
    {
        try
        {
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select epp.COD_ESTADO_PROGRAMA_PROD,epp.NOMBRE_ESTADO_PROGRAMA_PROD from ESTADOS_PROGRAMA_PRODUCCION epp ";
            ResultSet res=st.executeQuery(consulta);
            estadosProgramaProduccion.clear();
            estadosProgramaProduccion.add(new SelectItem("0","--TODOS--"));
            while(res.next())
            {
                estadosProgramaProduccion.add(new SelectItem(res.getString("COD_ESTADO_PROGRAMA_PROD"),res.getString("NOMBRE_ESTADO_PROGRAMA_PROD")));
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

    public void redireccionar(String direccion) {
        try {

            FacesContext facesContext = FacesContext.getCurrentInstance();
            ExternalContext ext = facesContext.getExternalContext();
            ext.redirect(direccion);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
     public String verActividadesProduccion_action(){
       try {

           ProgramaProduccion programaProduccion = (ProgramaProduccion)programaProduccionDataTable.getRowData();
           ExternalContext externalContext = FacesContext.getCurrentInstance().getExternalContext();
           Map<String, Object> sessionMap = externalContext.getSessionMap();
           Map<String,String> params = externalContext.getRequestParameterMap();
           sessionMap.put("programaProduccion",programaProduccion);
           sessionMap.put("codAreaEmpresa",params.get("codAreaEmpresa"));
           sessionMap.put("url",params.get("url"));
           this.redireccionar("../actividades_programa_produccion/navegador_actividades_programa.jsf");
       } catch (Exception e) {
           e.printStackTrace();
       }
       return null;
    }
    public String agregarProgramaProduccionDesarrollo_action(){
        programaProduccionbean.setCodProgramaProduccion(Util.getParameter("codProgramaProd")!=null?Util.getParameter("codProgramaProd"):codProgramaProd) ;
        this.redireccionar("agregar_programa_produccion_desarrollo.jsf");
        return null;
    }
    public String tipoProgramaProduccion_change(){
     try {
            ProgramaProduccion actual=(ProgramaProduccion)programaProduccionAgregarDataTable.getRowData();

            
            FormulaMaestra cabecera=this.formulaMaestraSeleccionada();
            actual.getFormulaMaestra().getComponentesProd().setCodCompprod(cabecera.getComponentesProd().getCodCompprod());
            List<SelectItem> nuevaLista=this.cargarProductosParaDivisionEdicionList(
                    cabecera.getComponentesProd().getCodCompprod(),
                    cabecera.getComponentesProd().getNombreProdSemiterminado(),
                    actual.getTiposProgramaProduccion().getCodTipoProgramaProd());
            actual.setProductosList(nuevaLista);
            String consulta="select fm.COD_FORMULA_MAESTRA,cp.nombre_prod_semiterminado,cp.COD_COMPPROD,fm.CANTIDAD_LOTE "+
                            " from FORMULA_MAESTRA fm inner join COMPONENTES_PROD cp "+
                            " on fm.COD_COMPPROD=cp.COD_COMPPROD  and fm.COD_ESTADO_REGISTRO=1"+
                            " where cp.COD_COMPPROD='"+cabecera.getComponentesProd().getCodCompprod()+"'";
            System.out.println("consulta "+consulta);
             Connection con1=null;
                con1=Util.openConnection(con1);
                Statement st=con1.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet res=st.executeQuery(consulta);
                if(res.next())
                {
                    actual.getFormulaMaestra().setCantidadLote(res.getDouble("CANTIDAD_LOTE"));
                    actual.getFormulaMaestra().setCodFormulaMaestra(res.getString("cod_formula_maestra"));
                    actual.getFormulaMaestra().getComponentesProd().setCodCompprod(res.getString("cod_compprod"));
                    actual.getFormulaMaestra().getComponentesProd().setNombreProdSemiterminado(res.getString("nombre_prod_semiterminado"));
                }
                res.close();
                st.close();
                con1.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public String mas_ActionAgregar()
    {
        ProgramaProduccion nuevo= this.nuevoProgramaProduccion();
        programaProduccionAgregarList.add(nuevo);
        return null;
    }
    public String menos_ActionAgregar()
    {
        List nuevaLista= new ArrayList();
        Iterator e=programaProduccionAgregarList.iterator();
        FormulaMaestra cabecera= this.formulaMaestraSeleccionada();
        while(e.hasNext())
        {
            ProgramaProduccion bean=(ProgramaProduccion)e.next();
            if(!bean.getChecked())
            {
                ProgramaProduccion nuevo= new ProgramaProduccion();
                nuevo.getFormulaMaestra().setCodFormulaMaestra(bean.getFormulaMaestra().getCodFormulaMaestra());
                nuevo.getFormulaMaestra().getComponentesProd().setCodCompprod(bean.getFormulaMaestra().getComponentesProd().getCodCompprod());
                nuevo.getFormulaMaestra().getComponentesProd().setNombreProdSemiterminado(bean.getFormulaMaestra().getComponentesProd().getNombreProdSemiterminado());
                nuevo.getTiposProgramaProduccion().setCodTipoProgramaProd(bean.getTiposProgramaProduccion().getCodTipoProgramaProd());
                nuevo.setCantidadLote(bean.getCantidadLote());
                nuevo.getFormulaMaestra().setCantidadLote(bean.getFormulaMaestra().getCantidadLote());
                List<SelectItem> listaSelect=this.cargarProductosParaDivisionEdicionList(
                        cabecera.getComponentesProd().getCodCompprod(),
                        cabecera.getComponentesProd().getNombreProdSemiterminado(),
                        nuevo.getTiposProgramaProduccion().getCodTipoProgramaProd());
                nuevo.setProductosList(listaSelect);
                nuevaLista.add(nuevo);
            }
        }
        programaProduccionAgregarList= new ArrayList();
        programaProduccionAgregarList= nuevaLista;
        return null;
    }

    public List<SelectItem> cargarProductosParaDivisionEdicionList(String codCompProd,String nombreProdSemiterminado,String codTipoProgramaProd) {
        List<SelectItem>listaProductosDivisibles= new ArrayList<SelectItem>();
        try {
            Connection con1=Util.openConnection(con);

            String consulta= "select pdl.COD_COMPPROD_DIVISION,cp.nombre_prod_semiterminado "+
                             " from PRODUCTOS_DIVISION_LOTES pdl inner join COMPONENTES_PROD cp"+
                             " on cp.COD_COMPPROD=pdl.COD_COMPPROD_DIVISION "+
                             " where pdl.COD_COMPPROD='"+codCompProd+"' and pdl.COD_TIPO_PROGRAMA_PRODUCCION='"+codTipoProgramaProd+"'";
            System.out.println("consulta productos divisibles" +consulta);
            Statement st=con1.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta);
            listaProductosDivisibles.clear();
            listaProductosDivisibles.add( new SelectItem(codCompProd.trim(),nombreProdSemiterminado));
            while(res.next())
            {
                listaProductosDivisibles.add(new SelectItem(res.getString("COD_COMPPROD_DIVISION"),res.getString("nombre_prod_semiterminado")));
            }

            res.close();
            st.close();
            con.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return listaProductosDivisibles;
    }
    public List cargarTiposProgramaProd1() {
        List tiposProgramaProdList = new ArrayList();
        try {
            con=Util.openConnection(con);
            String sql = "select a.COD_TIPO_PROGRAMA_PROD, a.NOMBRE_TIPO_PROGRAMA_PROD from TIPOS_PROGRAMA_PRODUCCION a where a.cod_estado_registro=1" +
                    "  order by a.COD_TIPO_PROGRAMA_PROD";
            System.out.println(" sql:" + sql);
            ResultSet rs = null;
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);


                tiposProgramaProdList.clear();
                rs = st.executeQuery(sql);
                tiposProgramaProdList.add(new SelectItem("0", "Seleccione una Opción"));
                while (rs.next()) {
                    tiposProgramaProdList.add(new SelectItem(rs.getString(1), rs.getString(2)));
                }
                rs.close();
                st.close();
                con.close();

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tiposProgramaProdList;
    }
    public String editarProgramaProduccion_action(){
           Iterator i=programaProduccionList.iterator();
           String codComprodMer="";
           String codComprodMues="";
           String codComprodLic="";
            while (i.hasNext()){
                ProgramaProduccion bean=(ProgramaProduccion)i.next();
                if(bean.getChecked())
                {
                    programaProduccionEditar.setCodLoteProduccion(bean.getCodLoteProduccion());
                    programaProduccionEditar.setCodProgramaProduccion(bean.getCodProgramaProduccion());
                    if(codComprodMer.equals("")&&bean.getTiposProgramaProduccion().getCodTipoProgramaProd().equals("1"))
                    {
                        codComprodMer=bean.getFormulaMaestra().getComponentesProd().getCodCompprod()+","+bean.getFormulaMaestra().getComponentesProd().getNombreProdSemiterminado();
                    }
                    if(codComprodMues.equals("")&&bean.getTiposProgramaProduccion().getCodTipoProgramaProd().equals("3"))
                    {
                        codComprodMues=bean.getFormulaMaestra().getComponentesProd().getCodCompprod()+","+bean.getFormulaMaestra().getComponentesProd().getNombreProdSemiterminado();
                    }
                    if(codComprodLic.equals("")&&bean.getTiposProgramaProduccion().getCodTipoProgramaProd().equals("2"))
                    {
                        codComprodLic=bean.getFormulaMaestra().getComponentesProd().getCodCompprod()+","+bean.getFormulaMaestra().getComponentesProd().getNombreProdSemiterminado();
                    }
                }

            }
            double cantidadLote=0d;
            System.out.println("lote "+programaProduccionEditar.getCodLoteProduccion());
            Iterator e=programaProduccionList.iterator();
            programaProduccionEditarList.clear();
            while (e.hasNext()){
                ProgramaProduccion bean=(ProgramaProduccion)e.next();
                if(bean.getCodLoteProduccion().equals(programaProduccionEditar.getCodLoteProduccion()))
                {
                    System.out.println("entro");
                    List<SelectItem> nuevaLista=this.cargarProductosParaDivisionEdicionList(
                    bean.getFormulaMaestra().getComponentesProd().getCodCompprod(),
                    bean.getFormulaMaestra().getComponentesProd().getNombreProdSemiterminado(),
                    bean.getTiposProgramaProduccion().getCodTipoProgramaProd());
                    bean.setProductosList(nuevaLista);
                    System.out.println("tam lista"+bean.getProductosList().size());
                    cantidadLote+=bean.getCantidadLote();
                    bean.setChecked(false);
                    programaProduccionEditarList.add(bean);

                }
            }
            programaProduccionEditar.setCantidadLote(cantidadLote);
            try
            {
                Connection con2=null;
                con2=Util.openConnection(con2);
                Statement st=con2.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                String consulta="select pp.COD_COMPPROD_PADRE,cp.nombre_prod_semiterminado "+
                                " from PROGRAMA_PRODUCCION pp inner join componentes_prod cp "+
                                " on cp.COD_COMPPROD=pp.COD_COMPPROD_PADRE"+
                                " where pp.COD_LOTE_PRODUCCION='"+programaProduccionEditar.getCodLoteProduccion()+"'" +
                                " and pp.COD_PROGRAMA_PROD='"+programaProduccionEditar.getCodProgramaProduccion()+"'";
                System.out.println("consulta cargar producto padre"+consulta );
                ResultSet res=st.executeQuery(consulta);
                if(res.next())
                {
                    programaProduccionEditar.getFormulaMaestra().getComponentesProd().setCodCompprod(res.getString("COD_COMPPROD_PADRE"));
                    programaProduccionEditar.getFormulaMaestra().getComponentesProd().setNombreProdSemiterminado(res.getString("nombre_prod_semiterminado"));
                }
                else
                {
                    if(!codComprodMer.equals(""))
                    {
                        programaProduccionEditar.getFormulaMaestra().getComponentesProd().setCodCompprod(codComprodMer.split("\\,")[0]);
                        programaProduccionEditar.getFormulaMaestra().getComponentesProd().setNombreProdSemiterminado(codComprodMer.split("\\,")[1]);
                    }
                    else
                    {
                        if(!codComprodMues.equals(""))
                        {
                            programaProduccionEditar.getFormulaMaestra().getComponentesProd().setCodCompprod(codComprodMues.split("\\,")[0]);
                            programaProduccionEditar.getFormulaMaestra().getComponentesProd().setNombreProdSemiterminado(codComprodMues.split("\\,")[1]);
                        }
                        else
                        {
                            if(codComprodLic.equals(""))
                            {
                                programaProduccionEditar.getFormulaMaestra().getComponentesProd().setCodCompprod(codComprodLic.split("\\,")[0]);
                                programaProduccionEditar.getFormulaMaestra().getComponentesProd().setNombreProdSemiterminado(codComprodLic.split("\\,")[1]);
                            }
                        }
                    }
                }
                consulta="select  top 1 fm.CANTIDAD_LOTE,fm.COD_FORMULA_MAESTRA from FORMULA_MAESTRA fm " +
                            " where fm.COD_COMPPROD='"+programaProduccionEditar.getFormulaMaestra().getComponentesProd().getCodCompprod()+"' and fm.COD_ESTADO_REGISTRO=1 ";
                System.out.println("consulta cargar datos fm "+consulta );
                res=st.executeQuery(consulta);
                if(res.next())
                {
                    programaProduccionEditar.getFormulaMaestra().setCodFormulaMaestra(res.getString("COD_FORMULA_MAESTRA"));
                    programaProduccionEditar.getFormulaMaestra().setCantidadLote(res.getDouble("CANTIDAD_LOTE"));
                }
                res.close();
                st.close();
                con2.close();
            }
            catch(SQLException ex)
            {
                ex.printStackTrace();
            }
            tiposProgramaProdList= this.cargarTiposProgramaProd1();
            tiposProgramaProdList.remove(0);
            this.redireccionar("editar_lotes_programa_produccion_desarrollo.jsf");
        return "";
    }
    public String mas_Action()
    {
        System.out.println("entro a mas action");
        ProgramaProduccion puntero=((ProgramaProduccion)programaProduccionEditarList.get(0));
        ProgramaProduccion nuevo= new ProgramaProduccion();
        nuevo.setCodLoteProduccion(puntero.getCodLoteProduccion());
        nuevo.getEstadoProgramaProduccion().setCodEstadoProgramaProd("2");
        nuevo.getEstadoProgramaProduccion().setNombreEstadoProgramaProd("APROBADO()");
        nuevo.setCodProgramaProduccion(puntero.getCodProgramaProduccion());

        double cantidad=0;
        for(ProgramaProduccion bean:programaProduccionEditarList)
        {
                cantidad+=bean.getCantidadLote();
        }
        if((programaProduccionEditar.getCantidadLote()-cantidad)>0)
            cantidad=programaProduccionEditar.getCantidadLote()-cantidad;
        else
            cantidad=0;

        nuevo.getFormulaMaestra().getComponentesProd().setCodCompprod(programaProduccionEditar.getFormulaMaestra().getComponentesProd().getCodCompprod());
        nuevo.getFormulaMaestra().getComponentesProd().setNombreProdSemiterminado(programaProduccionEditar.getFormulaMaestra().getComponentesProd().getNombreProdSemiterminado());
        nuevo.getFormulaMaestra().setCodFormulaMaestra(programaProduccionEditar.getFormulaMaestra().getCodFormulaMaestra());
        nuevo.getFormulaMaestra().setCantidadLote(programaProduccionEditar.getFormulaMaestra().getCantidadLote());
        nuevo.getTiposProgramaProduccion().setCodTipoProgramaProd("1");
        List<SelectItem> listaSelect= this.cargarProductosParaDivisionEdicionList(
        programaProduccionEditar.getFormulaMaestra().getComponentesProd().getCodCompprod(),
        programaProduccionEditar.getFormulaMaestra().getComponentesProd().getNombreProdSemiterminado(),
        nuevo.getTiposProgramaProduccion().getCodTipoProgramaProd());
        nuevo.setProductosList(listaSelect);
        nuevo.setCantidadLote(cantidad);
        programaProduccionEditarList.add(nuevo);
        return null;
    }
     public void cargarFormulaMaestra() {
        try {
            con=Util.openConnection(con);
            String consulta="select fm.COD_FORMULA_MAESTRA,cp.nombre_prod_semiterminado,fm.CANTIDAD_LOTE"+
                            " from FORMULA_MAESTRA fm inner join COMPONENTES_PROD cp on fm.COD_COMPPROD=cp.COD_COMPPROD"+
                            " where fm.COD_ESTADO_REGISTRO=1 and cp.COD_ESTADO_COMPPROD=1 and cp.COD_TIPO_PRODUCCION=2"+
                            " order by cp.nombre_prod_semiterminado";
            System.out.println("consulta cargar Prod "+consulta);
            ResultSet rs=null;
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            if (!codigo.equals("")) {
            } else {
                formulaMaestraList.clear();
                rs = st.executeQuery(consulta);
                formulaMaestraList.add(new SelectItem("0", "Seleccione una Opción"));
                while (rs.next()) {
                    formulaMaestraList.add(new SelectItem(rs.getString(1), rs.getString(2) + " " + rs.getString(3)));
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
     
    public String getCargarContenidoAgregarProgramaProduccionDesarrollo(){
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select fm.COD_FORMULA_MAESTRA,cp.nombre_prod_semiterminado,fm.CANTIDAD_LOTE");
                            consulta.append(" from FORMULA_MAESTRA fm inner join COMPONENTES_PROD cp on fm.COD_COMPPROD=cp.COD_COMPPROD");
                            consulta.append(" where fm.COD_ESTADO_REGISTRO=1 and cp.COD_ESTADO_COMPPROD=1 and cp.COD_TIPO_PRODUCCION=2");
                            consulta.append(" order by cp.nombre_prod_semiterminado");
            LOGGER.debug("consulta cargar productos agregar "+consulta.toString());   
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            formulaMaestraList.clear();
            formulaMaestraList.add(new SelectItem("0","--Seleccione una opción--"));
            while (res.next()) 
            {
                formulaMaestraList.add(new SelectItem(res.getString(1), res.getString(2) + " " + res.getString(3)));
            }
            st.close();
        } catch (SQLException ex) {
            LOGGER.warn("error", ex);
        } finally {
            this.cerrarConexion(con);
        }
        try {
            programaProduccionbean.setNroLotes(1);
            //inicio ale rehacer
            programaProduccionbean.getFormulaMaestra().setCodFormulaMaestra("0");
            programaProduccionAgregarList.clear();
            tiposProgramaProdList=this.cargarTiposProgramaProd1();



            //final ale rehacer

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public String estadoProgramaProduccion_Change()
    {
        this.cargarProgramaProduccion_Action();
        return null;
    }
    private FormulaMaestra formulaMaestraSeleccionada()
    {
       FormulaMaestra nuevaFormula= new FormulaMaestra();
       try
       {
           Connection con1=null;
           con1=Util.openConnection(con1);
           String consulta="select fm.CANTIDAD_LOTE,cp.COD_COMPPROD,cp.nombre_prod_semiterminado,fm.COD_FORMULA_MAESTRA"+
                            " from FORMULA_MAESTRA fm inner join COMPONENTES_PROD cp on"+
                            " fm.COD_COMPPROD=cp.COD_COMPPROD where fm.COD_FORMULA_MAESTRA='"+programaProduccionbean.getFormulaMaestra().getCodFormulaMaestra()+"'";
            System.out.println("consulta cargar detalle  form maest "+consulta);
           Statement st=con1.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
           ResultSet res=st.executeQuery(consulta);
           if(res.next())
           {
               nuevaFormula.setCodFormulaMaestra(res.getString("COD_FORMULA_MAESTRA"));
               nuevaFormula.getComponentesProd().setNombreProdSemiterminado(res.getString("nombre_prod_semiterminado"));
               nuevaFormula.getComponentesProd().setCodCompprod(res.getString("COD_COMPPROD"));
               nuevaFormula.setCantidadLote(res.getDouble("CANTIDAD_LOTE"));
           }
           res.close();
           st.close();
           con1.close();
       }
       catch(SQLException ex)
       {
           ex.printStackTrace();
       }
       return nuevaFormula;
    }
    private ProgramaProduccion nuevoProgramaProduccion()
    {
        ProgramaProduccion nuevo= new ProgramaProduccion();
        nuevo.setFormulaMaestra(this.formulaMaestraSeleccionada());
        nuevo.setProductosList(this.cargarProductosParaDivisionEdicionList(
                nuevo.getFormulaMaestra().getComponentesProd().getCodCompprod(),
                nuevo.getFormulaMaestra().getComponentesProd().getNombreProdSemiterminado(),"1"));
        nuevo.getTiposProgramaProduccion().setCodTipoProgramaProd("1");
        double cantidadRegistrar=0d;
        if(programaProduccionAgregarList.size()>0)
        {
            Iterator e= programaProduccionAgregarList.iterator();
            while(e.hasNext())
            {
                ProgramaProduccion current=(ProgramaProduccion)e.next();
                cantidadRegistrar+=current.getCantidadLote();
            }
            cantidadRegistrar=(nuevo.getFormulaMaestra().getCantidadLote()-cantidadRegistrar);
        }
        else
        {
            cantidadRegistrar=nuevo.getFormulaMaestra().getCantidadLote();
        }
        nuevo.setCantidadLote(cantidadRegistrar);
        return nuevo;
    }

    public String onChangeProductoAgregar()
    {
            currentProgramaProd=(ProgramaProduccion)programaProduccionAgregarDataTable.getRowData();
            
            String consulta="select fm.COD_FORMULA_MAESTRA,cp.nombre_prod_semiterminado,cp.COD_COMPPROD,fm.CANTIDAD_LOTE "+
                            " from FORMULA_MAESTRA fm inner join COMPONENTES_PROD cp "+
                            " on fm.COD_COMPPROD=cp.COD_COMPPROD  and fm.COD_ESTADO_REGISTRO=1"+
                            " where cp.COD_COMPPROD='"+currentProgramaProd.getFormulaMaestra().getComponentesProd().getCodCompprod()+"'";
            System.out.println("consulta "+consulta);
            try
            {
                Connection con1=null;
                con1=Util.openConnection(con1);
                Statement st=con1.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet res=st.executeQuery(consulta);
                if(res.next())
                {
                    currentProgramaProd.getFormulaMaestra().setCantidadLote(res.getDouble("CANTIDAD_LOTE"));
                    currentProgramaProd.getFormulaMaestra().setCodFormulaMaestra(res.getString("cod_formula_maestra"));
                    currentProgramaProd.getFormulaMaestra().getComponentesProd().setCodCompprod(res.getString("cod_compprod"));
                    currentProgramaProd.getFormulaMaestra().getComponentesProd().setNombreProdSemiterminado(res.getString("nombre_prod_semiterminado"));
                }
                res.close();
                st.close();
                con1.close();
            }
            catch(SQLException ex)
            {
                ex.printStackTrace();
            }
           return null;
    }
    private boolean verificarExistenciaMPEP(String codFormula)
    {
        boolean existe=true;
        mensaje="";
        try
        {
            Connection con1=null;
            con1=Util.openConnection(con1);
            Statement st=con1.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select top 1 * from FORMULA_MAESTRA_DETALLE_MP f where f.COD_FORMULA_MAESTRA='"+codFormula+"'";
            System.out.println("verificar "+consulta);
            ResultSet res=st.executeQuery(consulta);
            
            if(res.next())
            {
                existe=true;
                consulta="select top 1 * from FORMULA_MAESTRA_DETALLE_EP f where f.COD_FORMULA_MAESTRA='"+codFormula+"'";
                System.out.println("verificar "+consulta);
                res=st.executeQuery(consulta);
                existe=res.next();
                if(!existe)
                {
                    mensaje="No se puede registrar porque la formula maestra no tiene registrado empaque primario";
                }
            }
            else
            {
                existe=false;
                mensaje="No se puede registrar porque la formula maestra no tiene registrada materia prima";
                consulta="select top 1 * from FORMULA_MAESTRA_DETALLE_EP f where f.COD_FORMULA_MAESTRA='"+codFormula+"'";
                System.out.println("verificar "+consulta);
                res=st.executeQuery(consulta);
                if(!res.next())
                {
                    mensaje+=", empaque primario";
                }

                
            }
            st.close();
            con1.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
        return existe;
    }

    public String formulaMaestra_change1(){
        try {
            programaProduccionAgregarList.clear();
            programaProduccionAgregarList.add(this.nuevoProgramaProduccion());
            programaProduccionbean.getFormulaMaestra().setCantidadLote(this.formulaMaestraSeleccionada().getCantidadLote());
            tiposProgramaProdList=this.cargarTiposProgramaProd1();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
    public String codLoteProveedorEnProgramaProduccion(String codProgramaProduccion, String codComprod,String codFormulaMaestra,String codAreaEmpresaComponente){
            String codLote="";
            String restrColumnas="''";
        try {
            con = (Util.openConnection(con));
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);


            String consulta = " SELECT  DISTINCT IADE.COD_MATERIAL,IADE.LOTE_MATERIAL_PROVEEDOR,IADE.FECHA_VENCIMIENTO  " +
                    " FROM COMPONENTES_PROD CP INNER JOIN FORMULA_MAESTRA FM ON CP.COD_COMPPROD= FM.COD_COMPPROD " +
                    " INNER JOIN FORMULA_MAESTRA_DETALLE_EP FMEP ON FMEP.COD_FORMULA_MAESTRA = FM.COD_FORMULA_MAESTRA " +
                    " INNER JOIN INGRESOS_ALMACEN_DETALLE_ESTADO IADE ON IADE.COD_MATERIAL=FMEP.COD_MATERIAL " +
                    " WHERE IADE.CANTIDAD_RESTANTE>0 AND IADE.FECHA_VENCIMIENTO>=GETDATE() " +
                    " AND CP.COD_COMPPROD='"+codComprod+"' ORDER BY IADE.FECHA_VENCIMIENTO ASC ";

            consulta = "SELECT PPR.COD_COMPPROD,PPR.COD_FORMULA_MAESTRA,PPR.COD_LOTE_PRODUCCION " +
                    " FROM  PROGRAMA_PRODUCCION PPR WHERE PPR.COD_ESTADO_PROGRAMA = 2 " +
                    " AND PPR.COD_PROGRAMA_PROD = '"+codProgramaProduccion+"' " +
                    " AND PPR.COD_COMPPROD='"+codComprod+"'";
                    System.out.println("consulta" + consulta);
            ResultSet rs = st.executeQuery(consulta);

            while (rs.next()) {
                restrColumnas = restrColumnas +",'"+ rs.getString("COD_COMPPROD") + rs.getString("COD_FORMULA_MAESTRA") + rs.getString("COD_LOTE_PRODUCCION")+"'" ;
            }

            // MAYOR O IGUAL AL TAMAÑO DE LOTE 1 = 1000

            consulta = " SELECT DISTINCT IADE.COD_MATERIAL,IADE.LOTE_MATERIAL_PROVEEDOR,IADE.FECHA_VENCIMIENTO, IADE.CANTIDAD_RESTANTE,CP.nombre_prod_semiterminado   " +
                    " FROM COMPONENTES_PROD CP INNER JOIN FORMULA_MAESTRA FM ON CP.COD_COMPPROD= FM.COD_COMPPROD   " +
                    " INNER JOIN FORMULA_MAESTRA_DETALLE_EP FMEP ON FMEP.COD_FORMULA_MAESTRA = FM.COD_FORMULA_MAESTRA   " +
                    " INNER JOIN INGRESOS_ALMACEN_DETALLE_ESTADO IADE ON IADE.COD_MATERIAL=FMEP.COD_MATERIAL   " +
                    " WHERE IADE.CANTIDAD_RESTANTE>0 AND IADE.FECHA_VENCIMIENTO>=GETDATE()   " +
                    " AND CP.COD_COMPPROD='"+codComprod+"' " +
                    " AND convert(varchar,CP.COD_COMPPROD)+CONVERT(varchar,FM.COD_FORMULA_MAESTRA)+convert(varchar,IADE.LOTE_MATERIAL_PROVEEDOR) NOT IN("+restrColumnas+") " +
                    " ORDER BY IADE.FECHA_VENCIMIENTO ASC ";

            consulta = "select sum(iade.CANTIDAD_RESTANTE)as cantidad ,iad.cod_material, ia.COD_PROVEEDOR,isnull(iade.LOTE_MATERIAL_PROVEEDOR,'-')as LOTE_MATERIAL_PROVEEDOR,iade.FECHA_VENCIMIENTO, iade.COD_ESTADO_MATERIAL " +
                    " from INGRESOS_ALMACEN ia,INGRESOS_ALMACEN_DETALLE iad, " +
                    " INGRESOS_ALMACEN_DETALLE_ESTADO iade, proveedores p,FORMULA_MAESTRA FM,FORMULA_MAESTRA_DETALLE_EP FMDEP,presentaciones_primarias prp" +
                    " where ia.COD_INGRESO_ALMACEN=iad.COD_INGRESO_ALMACEN  " +
                    " and iad.COD_INGRESO_ALMACEN=iade.COD_INGRESO_ALMACEN  " +
                    " and ia.cod_proveedor=p.cod_proveedor  " +
                    " AND ia.cod_estado_ingreso_almacen=1 " +
                    " and iad.cod_material=iade.cod_material  " +
                    " AND FMDEP.COD_MATERIAL = IADE.COD_MATERIAL " +
                    " AND FM.COD_FORMULA_MAESTRA = FMDEP.COD_FORMULA_MAESTRA  " +
                    " and iade.CANTIDAD_RESTANTE>0 AND FM.COD_COMPPROD='"+codComprod+"' " +
                    " AND IADE.FECHA_VENCIMIENTO>=GETDATE() and prp.cod_presentacion_primaria=fmdep.cod_presentacion_primaria and prp.cod_compprod='"+codComprod+"'" +
                    " AND convert(varchar,FM.COD_COMPPROD)+CONVERT(varchar,FM.COD_FORMULA_MAESTRA)+convert(varchar,IADE.LOTE_MATERIAL_PROVEEDOR) NOT IN("+restrColumnas+") " +
                    " AND FMDEP.COD_MATERIAL IN ( select m1.COD_MATERIAL   from MATERIALES m1,grupos g where g.COD_GRUPO=m1.COD_GRUPO and g.COD_CAPITULO=3 ) " +
                    " GROUP BY iad.cod_material, ia.COD_PROVEEDOR,iade.LOTE_MATERIAL_PROVEEDOR,iade.FECHA_VENCIMIENTO, iade.COD_ESTADO_MATERIAL " +
                    " order by iade.FECHA_VENCIMIENTO asc ";

            System.out.println("la consulta armada " + consulta);

            rs = st.executeQuery(consulta);
            if(rs.next()){
                codLote = rs.getString("LOTE_MATERIAL_PROVEEDOR");
            }

            if(codLote.equals("")){
                        consulta= " select max(cast(SUBSTRING(p.COD_LOTE_PRODUCCION,5,LEN(p.COD_LOTE_PRODUCCION)+1) as int))+1 COD_LOTE_PRODUCCION from PROGRAMA_PRODUCCION p, componentes_prod c " +
                                        " where p.COD_PROGRAMA_PROD = " + codProgramaProduccion + " and " +
                                        " p.COD_ESTADO_PROGRAMA in (1,2,6)  and" +
                                        " c.cod_compprod=p.cod_compprod and c.cod_area_empresa in (" + codAreaEmpresaComponente + ") " +
                                        " and p.COD_LOTE_PRODUCCION like 'S%' " +
                                        " union all " +
                                        " select count(*)+1 COD_LOTE_PRODUCCION from PROGRAMA_PRODUCCION p, componentes_prod c " +
                                        " where p.COD_PROGRAMA_PROD = " + codProgramaProduccion + " and " +
                                        " p.COD_ESTADO_PROGRAMA in (1,2,6)  and" +
                                        " c.cod_compprod=p.cod_compprod and c.cod_area_empresa in (" + codAreaEmpresaComponente + ") " +
                                        " and p.COD_LOTE_PRODUCCION like 'S%' ";

                        System.out.println("consulta lote" + consulta);
                        st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                        rs = st.executeQuery(consulta);
                        if(rs.next()){
                            codLote = "S-L " + (rs.getString("COD_LOTE_PRODUCCION")==null?"1":rs.getString("COD_LOTE_PRODUCCION"));
                        }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return codLote;
      }
      public String generaCodLoteProduccion(String codProgramaPeriodo, String codCompProdP,int cantidadLoteP ,String codFormulaMaestraP,String obsProgProdP,String codTipoProgramaProduccionP) {
         String codLoteProduccion="";
        try {

            con = Util.openConnection(con);

            // deducir el prefijo para la forma farmaceutica
            String consulta = " select ffl.COD_LOTE_FORMA,cp.COD_AREA_EMPRESA from COMPONENTES_PROD cp  " +
                    "  inner join FORMAS_FARMACEUTICAS ff on ff.cod_forma = cp.COD_FORMA " +
                    " inner join FORMAS_FARMACEUTICAS_LOTE ffl on ffl.COD_FORMA = ff.cod_forma " +
                    " where cp.COD_COMPPROD = "+codCompProdP+" ";

            System.out.println("consulta" + consulta);
            Statement stLoteForma = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rsLoteForma= stLoteForma.executeQuery(consulta);
            String codLoteForma = "";
            String codAreaEmpresa = "";
            if(rsLoteForma.next()){
                codLoteForma = rsLoteForma.getString("COD_LOTE_FORMA");
                codAreaEmpresa = rsLoteForma.getString("COD_AREA_EMPRESA");
            }

            // el mes de la gestion
            System.out.println("cod area "+codAreaEmpresa+" "+codLoteForma);
            DateTime dt = new DateTime(fechaLote);



            SimpleDateFormat sdf = new SimpleDateFormat("MM");
            dt=dt.withMonthOfYear(Integer.valueOf(sdf.format(fechaLote)));
            String loteMes = "";
                if (dt.getMonthOfYear() < 10) {
                    loteMes = "0" + Integer.toString(dt.getMonthOfYear());
                } else {
                    loteMes = Integer.toString(dt.getMonthOfYear());
                }



            System.out.println("la fecha de lote que generara" +fechaLote.toString() +" lote mes " + loteMes );
            consulta = " SELECT MAX(CAST(SUBSTRING(PPR.COD_LOTE_PRODUCCION,5,LEN(SUBSTRING(PPR.COD_LOTE_PRODUCCION,5,50))-1) AS INT)) +1 correlativo " +
                        " FROM PROGRAMA_PRODUCCION PPR  " +
                        " INNER JOIN COMPONENTES_PROD CP ON CP.COD_COMPPROD = PPR.COD_COMPPROD " +
                        " INNER JOIN AREAS_EMPRESA AE ON AE.COD_AREA_EMPRESA = CP.COD_AREA_EMPRESA " +
                        " INNER JOIN FORMAS_FARMACEUTICAS FF ON FF.cod_forma = CP.COD_FORMA " +
                        " WHERE PPR.COD_PROGRAMA_PROD = "+codProgramaPeriodo+" " +
                        " AND AE.COD_AREA_EMPRESA in (select cp.COD_AREA_EMPRESA from COMPONENTES_PROD cp where cp.COD_COMPPROD = "+codCompProdP+") " +
                        " AND LEN(PPR.COD_LOTE_PRODUCCION)>=6 " ;
                    System.out.println("consulta" + consulta);
                    Statement stCorrelativo = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    ResultSet rsCorrelativo= stCorrelativo.executeQuery(consulta);
                    int correlativo = 0;
                    if(rsCorrelativo.next()){
                        System.out.println("corrrrrrrr " + rsCorrelativo.getString("correlativo"));
                        correlativo = rsCorrelativo.getInt("correlativo");
                    }
                    if(correlativo==0){
                        correlativo = 1;
                    }

                    String correlativoLote = "";
                    if(correlativo<10){
                        correlativoLote = "0"+String.valueOf(correlativo);
                    }else{
                        correlativoLote = String.valueOf(correlativo);
                    }



                    //calculo del año
                    dt = new DateTime(fechaLote);
                    String gestionLote = Integer.toString(dt.getYear()).substring(3, 4);

                    codLoteProduccion = "6"+codLoteForma+ loteMes + correlativoLote + gestionLote ;
                    System.out.println("codLoteProduccion " + codLoteProduccion);
            if(rsCorrelativo !=null) {
                rsCorrelativo.close();
                rsCorrelativo = null;
                stCorrelativo.close();
                stCorrelativo=null;
            }
            

            System.out.println("codLoteProduccion " + codLoteProduccion);
            if(rsLoteForma !=null ) {
                rsLoteForma.close();
                rsLoteForma=null;
                stLoteForma.close();
                stLoteForma=null;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return (codLoteProduccion);
    }

    public List cargarFormulaMaestraDetalleMPEditar(ProgramaProduccion bean){
        List formulaMaestraMPList = new ArrayList();
        try {
            String consulta = " select m.cod_material,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA, mp.CANTIDAD,um.COD_UNIDAD_MEDIDA, m.cod_grupo " +
                    " from FORMULA_MAESTRA_DETALLE_MP mp, MATERIALES m, UNIDADES_MEDIDA um " +
                    " where m.COD_MATERIAL = mp.cod_material and um.COD_UNIDAD_MEDIDA = m.COD_UNIDAD_MEDIDA " +
                    " and mp.cod_formula_maestra = '"+bean.getFormulaMaestra().getCodFormulaMaestra()+"' " +
                    " order by m.NOMBRE_MATERIAL ";
            System.out.println("consulta MP" + consulta );
            formulaMaestraMPList.clear();
            Connection con1=null;
            con1 = Util.openConnection(con1);
            Statement st = con1.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta);
            while(res.next()){
                FormulaMaestraDetalleMP formulaMaestraDetalleMP = new FormulaMaestraDetalleMP();
                formulaMaestraDetalleMP.getMateriales().setCodMaterial(res.getString("cod_material"));
                formulaMaestraDetalleMP.getMateriales().setNombreMaterial(res.getString("NOMBRE_MATERIAL"));
                formulaMaestraDetalleMP.getUnidadesMedida().setCodUnidadMedida(res.getString("COD_UNIDAD_MEDIDA"));
                formulaMaestraDetalleMP.getUnidadesMedida().setNombreUnidadMedida(res.getString("NOMBRE_UNIDAD_MEDIDA"));
                System.out.println("factor " + bean.getCantidadLote()+" "+bean.getFormulaMaestra().getCantidadLote());
                formulaMaestraDetalleMP.setCantidad(res.getDouble("CANTIDAD")*bean.getCantidadLote()/bean.getFormulaMaestra().getCantidadLote());
                formulaMaestraMPList.add(formulaMaestraDetalleMP);
            }
            st.close();
            con1.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return formulaMaestraMPList;
    }


     public List cargarFormulaMaestraDetalleMREditar(ProgramaProduccion bean){
        List formulaMaestraMPList = new ArrayList();
        try {
            String consulta = " select m.cod_material,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA,mp.CANTIDAD,um.COD_UNIDAD_MEDIDA " +
                    " from FORMULA_MAESTRA_DETALLE_MR mp, MATERIALES m,UNIDADES_MEDIDA um " +
                    " where m.COD_MATERIAL = mp.cod_material " +
                    " and um.COD_UNIDAD_MEDIDA = m.COD_UNIDAD_MEDIDA " +
                    " and mp.cod_formula_maestra = '"+bean.getFormulaMaestra().getCodFormulaMaestra()+"' ";

            System.out.println("consulta MR" + consulta );
            formulaMaestraMPList.clear();
            Connection con1 =null;
            con1=Util.openConnection(con1);
            Statement st = con1.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta);
            while(res.next()){

                FormulaMaestraDetalleMP formulaMaestraDetalleMP = new FormulaMaestraDetalleMP();
                formulaMaestraDetalleMP.getMateriales().setChecked(true);
                formulaMaestraDetalleMP.getMateriales().setCodMaterial(res.getString("cod_material"));
                formulaMaestraDetalleMP.getMateriales().setNombreMaterial(res.getString("NOMBRE_MATERIAL"));
                formulaMaestraDetalleMP.getUnidadesMedida().setCodUnidadMedida(res.getString("COD_UNIDAD_MEDIDA"));
                formulaMaestraDetalleMP.getUnidadesMedida().setNombreUnidadMedida(res.getString("NOMBRE_UNIDAD_MEDIDA"));
                formulaMaestraDetalleMP.setCantidad(res.getDouble("CANTIDAD")*bean.getCantidadLote()/bean.getFormulaMaestra().getCantidadLote());
                formulaMaestraMPList.add(formulaMaestraDetalleMP);
            }
            res.close();
            st.close();
            con1.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return formulaMaestraMPList;
    }
     public List cargarFormulaMaestraDetalleEPEditar(ProgramaProduccion bean){
        List formulaMaestraEPList = new ArrayList();
        try {

           String consulta = " select m.cod_material, m.NOMBRE_MATERIAL, um.NOMBRE_UNIDAD_MEDIDA, mp.CANTIDAD, um.COD_UNIDAD_MEDIDA " +
                    " from FORMULA_MAESTRA_DETALLE_EP mp,  MATERIALES m, UNIDADES_MEDIDA um, PRESENTACIONES_PRIMARIAS prp " +
                    " where m.COD_MATERIAL = mp.cod_material " +
                    " and um.COD_UNIDAD_MEDIDA = m.COD_UNIDAD_MEDIDA " +
                    " and prp.COD_PRESENTACION_PRIMARIA = mp.COD_PRESENTACION_PRIMARIA " +
                    " and prp.COD_TIPO_PROGRAMA_PROD = '"+bean.getTiposProgramaProduccion().getCodTipoProgramaProd()+"' " +
                    " and mp.cod_formula_maestra = '"+bean.getFormulaMaestra().getCodFormulaMaestra()+"' " +
                    " and prp.COD_ESTADO_REGISTRO = 1 ";
            System.out.println("consulta ES " + consulta );
            formulaMaestraEPList.clear();
            Connection con1=null;
            con1= Util.openConnection(con1);
            Statement st = con1.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta);
            while(res.next()){

                FormulaMaestraDetalleMP formulaMaestraDetalleMP = new FormulaMaestraDetalleMP();
                formulaMaestraDetalleMP.getMateriales().setChecked(true);
                formulaMaestraDetalleMP.getMateriales().setCodMaterial(res.getString("cod_material"));
                formulaMaestraDetalleMP.getMateriales().setNombreMaterial(res.getString("NOMBRE_MATERIAL"));
                formulaMaestraDetalleMP.getUnidadesMedida().setCodUnidadMedida(res.getString("COD_UNIDAD_MEDIDA"));
                formulaMaestraDetalleMP.getUnidadesMedida().setNombreUnidadMedida(res.getString("NOMBRE_UNIDAD_MEDIDA"));
                formulaMaestraDetalleMP.setCantidad(res.getDouble("CANTIDAD")*bean.getCantidadLote()/bean.getFormulaMaestra().getCantidadLote());
                formulaMaestraEPList.add(formulaMaestraDetalleMP);
            }
            res.close();
            st.close();
            con1.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return formulaMaestraEPList;
    }
     public List cargarFormulaMaestraDetalleESEditar(ProgramaProduccion bean){
        List formulaMaestraESList = new ArrayList();
        try {

            String  consulta = " select m.cod_material, m.NOMBRE_MATERIAL, u.NOMBRE_UNIDAD_MEDIDA, fmdes.CANTIDAD," +
                    " u.COD_UNIDAD_MEDIDA from COMPONENTES_PRESPROD c inner join COMPONENTES_PROD cp" +
                    " on cp.COD_COMPPROD = c.COD_COMPPROD " +
                    " inner join PRESENTACIONES_PRODUCTO prp on prp.cod_presentacion = c.COD_PRESENTACION " +
                    " inner join FORMULA_MAESTRA fm on fm.COD_COMPPROD = c.COD_COMPPROD " +
                    " inner join FORMULA_MAESTRA_DETALLE_ES fmdes on fmdes.COD_FORMULA_MAESTRA = fm.COD_FORMULA_MAESTRA " +
                    " and fmdes.COD_PRESENTACION_PRODUCTO = prp.cod_presentacion " +
                    " inner join materiales m on m.COD_MATERIAL = fmdes.COD_MATERIAL " +
                    " inner join UNIDADES_MEDIDA u on u.COD_UNIDAD_MEDIDA =fmdes.COD_UNIDAD_MEDIDA " +
                    " where prp.cod_estado_registro = 1 " +
                    " and c.COD_ESTADO_REGISTRO = 1 and c.COD_TIPO_PROGRAMA_PROD = '"+bean.getTiposProgramaProduccion().getCodTipoProgramaProd()+"' " +
                    " and fm.COD_FORMULA_MAESTRA = '"+bean.getFormulaMaestra().getCodFormulaMaestra()+"'  ";
            System.out.println("consulta ES" + consulta );
            formulaMaestraESList.clear();
            Connection con1=null;
            con1 = Util.openConnection(con1);
            Statement st = con1.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta);
            while(res.next()){

                FormulaMaestraDetalleMP formulaMaestraDetalleMP = new FormulaMaestraDetalleMP();
                formulaMaestraDetalleMP.getMateriales().setChecked(true);
                formulaMaestraDetalleMP.getMateriales().setCodMaterial(res.getString("cod_material"));
                formulaMaestraDetalleMP.getMateriales().setNombreMaterial(res.getString("NOMBRE_MATERIAL"));
                formulaMaestraDetalleMP.getUnidadesMedida().setCodUnidadMedida(res.getString("COD_UNIDAD_MEDIDA"));
                formulaMaestraDetalleMP.getUnidadesMedida().setNombreUnidadMedida(res.getString("NOMBRE_UNIDAD_MEDIDA"));
                formulaMaestraDetalleMP.setCantidad(res.getDouble("CANTIDAD")*bean.getCantidadLote()/bean.getFormulaMaestra().getCantidadLote());
                formulaMaestraESList.add(formulaMaestraDetalleMP);
            }



        } catch (Exception e) {
            e.printStackTrace();
        }
        return formulaMaestraESList;
    }

    public String guardarProgramaProduccion_action1() {
        //System.out.println("formulaMaestraEPList******************:"+formulaMaestraEPList.size());
        if(!this.verificarExistenciaMPEP(programaProduccionbean.getFormulaMaestra().getCodFormulaMaestra()))
        {
            //mensaje="No se puede registrar porque la formula maestra no tiene registrada materia prima y empaque primario";
            return null;
        }
        mensaje="";
        
        Connection con = null;
        String codLoteProd = "-";
        String codLoteProd1 = "";
        try {
            programaProduccionbean.getEstadoProgramaProduccion().setCodEstadoProgramaProd("2"); //estado aprobado
            programaProduccionbean.setVersionLote("1"); //version de lote

            // la iteracion para productos enteros
            for(int lotes = 1 ;lotes<= programaProduccionbean.getNroLotes();lotes++){
                //System.out.println("entro en la iteracion --------------");
            Iterator i = programaProduccionAgregarList.iterator();
            con = Util.openConnection(con);
            Statement st = con.createStatement();
            FormulaMaestra cabecera=this.formulaMaestraSeleccionada();
            String codLoteProduccion=this.generaCodLoteProduccion(programaProduccionbean.getCodProgramaProduccion(),cabecera.getComponentesProd().getCodCompprod(),
                            1,cabecera.getCodFormulaMaestra()
                        ,programaProduccionbean.getObservacion(), ((ProgramaProduccion)programaProduccionAgregarList.get(0)).getTiposProgramaProduccion().getCodTipoProgramaProd());
                    while(i.hasNext()){
                        ProgramaProduccion programaProduccion =(ProgramaProduccion) i.next();
                        String consulta = " insert into programa_produccion(cod_programa_prod,cod_formula_maestra,cod_lote_produccion, " +
                            " cod_estado_programa,observacion,CANT_LOTE_PRODUCCION,VERSION_LOTE,COD_COMPPROD,COD_TIPO_PROGRAMA_PROD,COD_PRESENTACION,nro_lotes,COD_COMPPROD_PADRE)" +
                            //inicio ale edicion
                            " values('"+programaProduccionbean.getCodProgramaProduccion()+"','"+programaProduccion.getFormulaMaestra().getCodFormulaMaestra() +"'," +
                            //final ale edicion
                            "'"+codLoteProduccion+"','"+programaProduccionbean.getEstadoProgramaProduccion().getCodEstadoProgramaProd()+"'," +
                            "'"+programaProduccion.getObservacion()+"','"+programaProduccion.getCantidadLote()+"','"+programaProduccionbean.getVersionLote()+"', " +
                            //inicio ale edicion
                            "'"+programaProduccion.getFormulaMaestra().getComponentesProd().getCodCompprod()+"','"+programaProduccion.getTiposProgramaProduccion().getCodTipoProgramaProd()+"', " +
                            //final ale edicion
                            " '"+programaProduccion.getPresentacionesProducto().getCodPresentacion()+"',1,'"+cabecera.getComponentesProd().getCodCompprod()+"');  ";
                        System.out.println("consulta " + consulta);
                        st.execute(consulta);
                        programaProduccion.getFormulaMaestra().setFormulaMaestraDetalleMPList(this.cargarFormulaMaestraDetalleMPEditar(programaProduccion));
                        Iterator i1 = programaProduccion.getFormulaMaestra().getFormulaMaestraDetalleMPList().iterator();
                        while(i1.hasNext()){
                            FormulaMaestraDetalleMP formulaMaestraDetalleMP = (FormulaMaestraDetalleMP)i1.next();
                            consulta = " insert into programa_produccion_detalle(cod_programa_prod,COD_COMPPROD, cod_material,cod_unidad_medida,cantidad,cod_lote_produccion,cod_tipo_programa_prod,cod_tipo_material,cod_estado_registro) " +
                                    //inicio ale edicion
                                    " values('"+programaProduccionbean.getCodProgramaProduccion()+"','"+programaProduccion.getFormulaMaestra().getComponentesProd().getCodCompprod()+"', " +
                                    //final ale edicion
                                    "'"+ formulaMaestraDetalleMP.getMateriales().getCodMaterial() +"','"+formulaMaestraDetalleMP.getUnidadesMedida().getCodUnidadMedida()+"','"+formulaMaestraDetalleMP.getCantidad()+"'," +
                                    "'"+codLoteProduccion+"','"+programaProduccion.getTiposProgramaProduccion().getCodTipoProgramaProd()+"','1' ,1) ";
                            System.out.println("consulta MP " + consulta);
                            st.executeUpdate(consulta);

                        }
                        programaProduccion.getFormulaMaestra().setFormulaMaestraDetalleMRList(this.cargarFormulaMaestraDetalleMREditar(programaProduccion));
                        i1 = programaProduccion.getFormulaMaestra().getFormulaMaestraDetalleMRList().iterator();
                        while(i1.hasNext()){
                            FormulaMaestraDetalleMP formulaMaestraDetalleMP = (FormulaMaestraDetalleMP)i1.next();
                            consulta = " insert into programa_produccion_detalle(cod_programa_prod,COD_COMPPROD, cod_material,cod_unidad_medida,cantidad,cod_lote_produccion,cod_tipo_programa_prod,cod_tipo_material,cod_estado_registro) " +
                                    //inicio ale edicion
                                    " values('"+programaProduccionbean.getCodProgramaProduccion()+"','"+programaProduccion.getFormulaMaestra().getComponentesProd().getCodCompprod()+"', " +
                                    //inicio ale edicion
                                    "'"+ formulaMaestraDetalleMP.getMateriales().getCodMaterial() +"','"+formulaMaestraDetalleMP.getUnidadesMedida().getCodUnidadMedida()+"','"+formulaMaestraDetalleMP.getCantidad()+"'," +
                                    "'"+codLoteProduccion+"','"+programaProduccion.getTiposProgramaProduccion().getCodTipoProgramaProd()+"','4',1) ";
                            System.out.println("consulta MR " + consulta);
                            st.executeUpdate(consulta);

                        }
                        programaProduccion.getFormulaMaestra().setFormulaMaestraDetalleEPList(this.cargarFormulaMaestraDetalleEPEditar(programaProduccion));
                         i1 = programaProduccion.getFormulaMaestra().getFormulaMaestraDetalleEPList().iterator();
                        while(i1.hasNext()){
                            FormulaMaestraDetalleMP formulaMaestraDetalleMP = (FormulaMaestraDetalleMP)i1.next();
                            consulta = " insert into programa_produccion_detalle(cod_programa_prod,COD_COMPPROD, cod_material,cod_unidad_medida,cantidad,cod_lote_produccion,cod_tipo_programa_prod,cod_tipo_material,cod_estado_registro) " +
                                    //inicio ale rehacer
                                    " values('"+programaProduccionbean.getCodProgramaProduccion()+"','"+programaProduccion.getFormulaMaestra().getComponentesProd().getCodCompprod()+"', " +
                                    //final ale rehacer
                                    "'"+ formulaMaestraDetalleMP.getMateriales().getCodMaterial() +"','"+formulaMaestraDetalleMP.getUnidadesMedida().getCodUnidadMedida()+"','"+formulaMaestraDetalleMP.getCantidad()+"'," +
                                    "'"+codLoteProduccion+"','"+programaProduccion.getTiposProgramaProduccion().getCodTipoProgramaProd()+"','2',1) ";
                            System.out.println("consulta EP " + consulta);
                            st.executeUpdate(consulta);

                        }
                        programaProduccion.getFormulaMaestra().setFormulaMaestraDetalleESList(this.cargarFormulaMaestraDetalleESEditar(programaProduccion));
                        i1 = programaProduccion.getFormulaMaestra().getFormulaMaestraDetalleESList().iterator();
                        while(i1.hasNext()){
                            FormulaMaestraDetalleMP formulaMaestraDetalleMP = (FormulaMaestraDetalleMP)i1.next();
                            consulta = " insert into programa_produccion_detalle(cod_programa_prod,COD_COMPPROD, cod_material,cod_unidad_medida,cantidad,cod_lote_produccion,cod_tipo_programa_prod,cod_tipo_material,cod_estado_registro) " +
                                    //inicio ale rehacer
                                    " values('"+programaProduccionbean.getCodProgramaProduccion()+"','"+programaProduccion.getFormulaMaestra().getComponentesProd().getCodCompprod()+"', " +
                                    //final ale rehacer
                                    "'"+ formulaMaestraDetalleMP.getMateriales().getCodMaterial() +"','"+formulaMaestraDetalleMP.getUnidadesMedida().getCodUnidadMedida()+"','"+formulaMaestraDetalleMP.getCantidad()+"'," +
                                    "'"+codLoteProduccion+"','"+programaProduccion.getTiposProgramaProduccion().getCodTipoProgramaProd()+"','3',1) ";
                            System.out.println("consulta ES " + consulta);
                            st.executeUpdate(consulta);
                        }
                        
                    }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        getCargarProgramaProduccion1();
        System.out.println("mensaje "+mensaje);
        return null;
    }
    public String limpiar_action(){
        programaProduccionAgregarList.clear();
        //inicio ale ultimo
        //this.formulaMaestra_change1();
        programaProduccionbean.getFormulaMaestra().setCodFormulaMaestra("0");
        //final ale ultimo
        return null;
    }
    public String menos_Action()
    {
        List<ProgramaProduccion> programaProduccionList= new ArrayList<ProgramaProduccion>();

        for(ProgramaProduccion bean:programaProduccionEditarList)
        {
            if(!bean.getChecked())
            {
                List<SelectItem> listaSelect= new ArrayList<SelectItem>();
                ProgramaProduccion nuevo= new ProgramaProduccion();
                nuevo.getFormulaMaestra().setCodFormulaMaestra(bean.getFormulaMaestra().getCodFormulaMaestra());
                nuevo.setCodLoteProduccion(bean.getCodLoteProduccion());
                nuevo.getEstadoProgramaProduccion().setCodEstadoProgramaProd(bean.getEstadoProgramaProduccion().getCodEstadoProgramaProd());
                nuevo.getEstadoProgramaProduccion().setNombreEstadoProgramaProd(bean.getEstadoProgramaProduccion().getNombreEstadoProgramaProd());
                nuevo.setCodProgramaProduccion(bean.getCodProgramaProduccion());
                nuevo.getFormulaMaestra().getComponentesProd().setCodCompprod(bean.getFormulaMaestra().getComponentesProd().getCodCompprod());
                nuevo.getFormulaMaestra().getComponentesProd().setNombreProdSemiterminado(bean.getFormulaMaestra().getComponentesProd().getNombreProdSemiterminado());
                nuevo.getFormulaMaestra().setCantidadLote(bean.getFormulaMaestra().getCantidadLote());
                nuevo.getTiposProgramaProduccion().setCodTipoProgramaProd(bean.getTiposProgramaProduccion().getCodTipoProgramaProd());
                nuevo.setCantidadLote(bean.getCantidadLote());
                listaSelect=this.cargarProductosParaDivisionEdicionList(
                String.valueOf(bean.getProductosList().get(0).getValue()),
                String.valueOf(bean.getProductosList().get(0).getLabel()),
                bean.getTiposProgramaProduccion().getCodTipoProgramaProd());
                nuevo.setProductosList(listaSelect);
                programaProduccionList.add(nuevo);
            }

        }
        programaProduccionEditarList.clear();
        programaProduccionEditarList=programaProduccionList;
        return null;
    }

    public String productoEditar_change()
    {
            ProgramaProduccion current=(ProgramaProduccion)programaProduccionEditarDataTable.getRowData();
            String consulta="select  top 1 fm.CANTIDAD_LOTE,fm.COD_FORMULA_MAESTRA from FORMULA_MAESTRA fm " +
                            " where fm.COD_COMPPROD='"+current.getFormulaMaestra().getComponentesProd().getCodCompprod()+"' and fm.COD_ESTADO_REGISTRO=1 ";
            System.out.println("consulta cambio de producto editar"+consulta);

            try
            {
                Connection con1=null;
                con1=Util.openConnection(con1);
                Statement st=con1.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet res=st.executeQuery(consulta);
                if(res.next())
                {

                current.getFormulaMaestra().setCantidadLote(res.getDouble("CANTIDAD_LOTE"));
                current.getFormulaMaestra().setCodFormulaMaestra(res.getString("COD_FORMULA_MAESTRA"));
                }
                res.close();
                st.close();
                con1.close();
            }
            catch(SQLException ex)
            {
                ex.printStackTrace();
            }
           return null;
    }

    public String tipoProgramaProduccionEditar_change(){
        try {

            ProgramaProduccion actual = (ProgramaProduccion)programaProduccionEditarDataTable.getRowData();
            System.out.println("actual "+actual.getFormulaMaestra().getComponentesProd().getCodCompprod());
            List<SelectItem> nuevaListax=this.cargarProductosParaDivisionEdicionList(
            programaProduccionEditar.getFormulaMaestra().getComponentesProd().getCodCompprod(),
            programaProduccionEditar.getFormulaMaestra().getComponentesProd().getNombreProdSemiterminado(),
            actual.getTiposProgramaProduccion().getCodTipoProgramaProd());
            actual.setProductosList(nuevaListax);
            String codComprod=programaProduccionEditar.getFormulaMaestra().getComponentesProd().getCodCompprod();
            actual.getFormulaMaestra().getComponentesProd().setCodCompprod(codComprod);
            actual.getFormulaMaestra().setCodFormulaMaestra(programaProduccionEditar.getFormulaMaestra().getCodFormulaMaestra());
            actual.getFormulaMaestra().setCantidadLote(programaProduccionEditar.getFormulaMaestra().getCantidadLote());
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public String eliminarProgProd(){
        try {
            con=Util.openConnection(con);
            Iterator i=programaProduccionList.iterator();
            int result=0;
            while (i.hasNext()){
                ProgramaProduccion bean=(ProgramaProduccion)i.next();
                if(bean.getChecked().booleanValue()){
                    String sql="delete from PROGRAMA_PRODUCCION_DETALLE where COD_PROGRAMA_PROD='"+bean.getCodProgramaProduccion()+"' and COD_COMPPROD="+bean.getFormulaMaestra().getComponentesProd().getCodCompprod();
                    sql+=" and cod_lote_produccion='"+bean.getCodLoteProduccion()+"' and cod_tipo_programa_prod = '"+bean.getTiposProgramaProduccion().getCodTipoProgramaProd()+"' ";
                    System.out.println("consulta delete PROGRAMA_PRODUCCION_DETALLE "+sql);
                    PreparedStatement pst=con.prepareStatement(sql);
                    if(pst.executeUpdate()>0)System.out.println("se elimino el detalle ");
                    sql="delete from PROGRAMA_PRODUCCION where COD_PROGRAMA_PROD='"+bean.getCodProgramaProduccion()+"' and COD_COMPPROD="+bean.getFormulaMaestra().getComponentesProd().getCodCompprod();
                    sql+=" and cod_lote_produccion='"+bean.getCodLoteProduccion()+"' and cod_tipo_programa_prod = '"+bean.getTiposProgramaProduccion().getCodTipoProgramaProd()+"' ";
                    System.out.println("consulta delete programa_produccion "+sql);
                    pst=con.prepareStatement(sql);
                    if(pst.executeUpdate()>0)System.out.println("se elimino la cabecera ");
                    String sql4="select cod_reserva from reserva  ";
                    sql4+=" where COD_PROGRAMA_PROD in ("+bean.getCodProgramaProduccion()+") and COD_COMPPROD='"+bean.getFormulaMaestra().getComponentesProd().getCodCompprod()+"' and COD_LOTE='"+bean.getCodLoteProduccion()+"' ";
                    System.out.println("sql4*****:"+sql4);
                    Statement st4= con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet rs4 = st4.executeQuery(sql4);
                    while(rs4.next()){
                        String cod_reserva=rs4.getString(1);
                        String sql2="delete from reserva " ;
                        sql2+=" where cod_reserva='"+cod_reserva+"'";
                        System.out.println(" delete reserva:"+sql2);
                        Statement st22=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                        int rs22=st22.executeUpdate(sql2);

                        sql2="delete from reserva_detalle " ;
                        sql2+=" where cod_reserva='"+cod_reserva+"'";
                        System.out.println("delete Detalle Reserva:"+sql2);
                        st22=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                        rs22=st22.executeUpdate(sql2);
                    }
                    con.close();

                }
            }

            this.cargarProgramaProduccion_Action();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "";
    }

    public String terminarRegistro_Action()
    {
        this.redireccionar("navegador_programa_produccion_desarrollo.jsf");
        return null;
    }
    public String detalleProgramProd(){

        formulaMaestraMPList.clear();
        formulaMaestraEPList.clear();
        formulaMaestraESList.clear();
        formulaMaestraMPROMList.clear();
        NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
        DecimalFormat form = (DecimalFormat)nf;
        form.applyPattern("#,###.00");
        try {

            String sql=" select m.cod_material,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA,ppd.CANTIDAD,um.COD_UNIDAD_MEDIDA" ;
            sql+=" from MATERIALES m,UNIDADES_MEDIDA um,PROGRAMA_PRODUCCION_DETALLE ppd,PROGRAMA_PRODUCCION pp";
            sql+=" where    um.COD_UNIDAD_MEDIDA = m.COD_UNIDAD_MEDIDA and m.COD_MATERIAL=ppd.COD_MATERIAL ";
            sql+=" and pp.COD_PROGRAMA_PROD=ppd.COD_PROGRAMA_PROD and pp.cod_formula_maestra = '"+programaProduccionDetalle.getFormulaMaestra().getCodFormulaMaestra()+"' ";
            sql+=" and pp.cod_programa_prod='"+codigo+"' and ppd.cod_compprod='"+programaProduccionDetalle.getFormulaMaestra().getComponentesProd().getCodCompprod()+"' and ppd.cod_lote_produccion='"+programaProduccionDetalle.getCodLoteProduccion()+"'";
            sql+=" and ppd.cod_lote_produccion=pp.cod_lote_produccion and pp.cod_compprod=ppd.cod_compprod ";
            sql+=" and m.COD_MATERIAL in (select ep.COD_MATERIAL from FORMULA_MAESTRA_DETALLE_MP ep where ep.COD_FORMULA_MAESTRA='"+programaProduccionDetalle.getFormulaMaestra().getCodFormulaMaestra()+"') " +
                 " and ppd.cod_tipo_programa_prod = pp.cod_tipo_programa_prod and pp.cod_tipo_programa_prod='"+programaProduccionDetalle.getTiposProgramaProduccion().getCodTipoProgramaProd()+"' ";
            sql+=" order by m.NOMBRE_MATERIAL";
            System.out.println("sql MP:"+sql);
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(sql);
            while(rs.next()){
                String codMaterial=rs.getString(1);
                String nombreMaterial=rs.getString(2);
                String unidadMedida=rs.getString(3);
                double cantidad=rs.getDouble(4);
                String codUnidadMedida=rs.getString(5);
                FormulaMaestraDetalleMP bean=new FormulaMaestraDetalleMP();
                bean.getMateriales().setCodMaterial(codMaterial);
                bean.getMateriales().setNombreMaterial(nombreMaterial);
                bean.getUnidadesMedida().setNombreUnidadMedida(unidadMedida);
                bean.setCantidad(cantidad);
                bean.getUnidadesMedida().setCodUnidadMedida(codUnidadMedida);
               
                formulaMaestraMPList.add(bean);
            }
            sql=" select m.cod_material,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA,ppd.CANTIDAD,um.COD_UNIDAD_MEDIDA" ;
            sql+=" from MATERIALES m,UNIDADES_MEDIDA um,PROGRAMA_PRODUCCION_DETALLE ppd,PROGRAMA_PRODUCCION pp";
            sql+=" where    um.COD_UNIDAD_MEDIDA = m.COD_UNIDAD_MEDIDA and m.COD_MATERIAL=ppd.COD_MATERIAL ";
            sql+=" and pp.COD_PROGRAMA_PROD=ppd.COD_PROGRAMA_PROD and pp.cod_formula_maestra = '"+programaProduccionDetalle.getFormulaMaestra().getCodFormulaMaestra()+"' ";
            sql+=" and pp.cod_programa_prod='"+codigo+"' and ppd.cod_compprod='"+programaProduccionDetalle.getFormulaMaestra().getComponentesProd().getCodCompprod()+"' " +
                 " and ppd.cod_lote_produccion='"+programaProduccionDetalle.getCodLoteProduccion()+"'";
            sql+=" and ppd.cod_lote_produccion=pp.cod_lote_produccion and pp.cod_compprod=ppd.cod_compprod";
            sql+=" and m.COD_MATERIAL in (select ep.COD_MATERIAL from FORMULA_MAESTRA_DETALLE_EP ep where ep.COD_FORMULA_MAESTRA='"+programaProduccionDetalle.getFormulaMaestra().getCodFormulaMaestra()+"')" +
                 " and ppd.cod_tipo_programa_prod = pp.cod_tipo_programa_prod and pp.cod_tipo_programa_prod='"+programaProduccionDetalle.getTiposProgramaProduccion().getCodTipoProgramaProd()+"' ";
            sql+=" order by m.NOMBRE_MATERIAL";
            System.out.println("sql EP:"+sql);
            st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            rs=st.executeQuery(sql);
            while(rs.next()){
                String codMaterial=rs.getString(1);
                String nombreMaterial=rs.getString(2);
                String unidadMedida=rs.getString(3);
                double cantidad=rs.getDouble(4);
                String codUnidadMedida=rs.getString(5);
                FormulaMaestraDetalleMP bean=new FormulaMaestraDetalleMP();
                bean.getMateriales().setCodMaterial(codMaterial);
                bean.getMateriales().setNombreMaterial(nombreMaterial);
                bean.getUnidadesMedida().setNombreUnidadMedida(unidadMedida);
                bean.setCantidad(cantidad);
                bean.getUnidadesMedida().setCodUnidadMedida(codUnidadMedida);
                formulaMaestraEPList.add(bean);
            }
            sql=" select m.cod_material,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA,ppd.CANTIDAD,um.COD_UNIDAD_MEDIDA" ;
            sql+=" from MATERIALES m,UNIDADES_MEDIDA um,PROGRAMA_PRODUCCION_DETALLE ppd,PROGRAMA_PRODUCCION pp";
            sql+=" where    um.COD_UNIDAD_MEDIDA = m.COD_UNIDAD_MEDIDA and m.COD_MATERIAL=ppd.COD_MATERIAL ";
            sql+=" and pp.COD_PROGRAMA_PROD=ppd.COD_PROGRAMA_PROD and pp.cod_formula_maestra = '"+programaProduccionDetalle.getFormulaMaestra().getCodFormulaMaestra()+"' ";
            sql+=" and pp.cod_programa_prod='"+codigo+"' and ppd.cod_compprod='"+programaProduccionDetalle.getFormulaMaestra().getComponentesProd().getCodCompprod()+"' and ppd.cod_lote_produccion='"+programaProduccionDetalle.getCodLoteProduccion()+"'";
            sql+=" and ppd.cod_lote_produccion=pp.cod_lote_produccion and pp.cod_compprod=ppd.cod_compprod";
            sql+=" and m.COD_MATERIAL in (select ep.COD_MATERIAL from FORMULA_MAESTRA_DETALLE_ES ep where ep.COD_FORMULA_MAESTRA='"+programaProduccionDetalle.getFormulaMaestra().getCodFormulaMaestra()+"') " +
                 " and ppd.cod_tipo_programa_prod = pp.cod_tipo_programa_prod and pp.cod_tipo_programa_prod='"+programaProduccionDetalle.getTiposProgramaProduccion().getCodTipoProgramaProd()+"' ";
            sql+=" order by m.NOMBRE_MATERIAL";
            System.out.println("sql ES:"+sql);
            rs=st.executeQuery(sql);
            while(rs.next()){
                String codMaterial=rs.getString(1);
                String nombreMaterial=rs.getString(2);
                String unidadMedida=rs.getString(3);
                double cantidad=rs.getDouble(4);
                String codUnidadMedida=rs.getString(5);
                FormulaMaestraDetalleMP bean=new FormulaMaestraDetalleMP();
                bean.getMateriales().setCodMaterial(codMaterial);
                bean.getMateriales().setNombreMaterial(nombreMaterial);
                bean.getUnidadesMedida().setNombreUnidadMedida(unidadMedida);
                bean.setCantidad(cantidad);
                bean.getUnidadesMedida().setCodUnidadMedida(codUnidadMedida);
                formulaMaestraESList.add(bean);
            }
            sql=" select m.cod_material,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA,ppd.CANTIDAD,um.COD_UNIDAD_MEDIDA" ;
            sql+=" from MATERIALES m,UNIDADES_MEDIDA um,PROGRAMA_PRODUCCION_DETALLE ppd,PROGRAMA_PRODUCCION pp";
            sql+=" where    um.COD_UNIDAD_MEDIDA = m.COD_UNIDAD_MEDIDA and m.COD_MATERIAL=ppd.COD_MATERIAL ";
            sql+=" and pp.COD_PROGRAMA_PROD=ppd.COD_PROGRAMA_PROD and pp.cod_formula_maestra = '"+programaProduccionDetalle.getFormulaMaestra().getCodFormulaMaestra()+"' ";
            sql+=" and pp.cod_programa_prod='"+codigo+"' and ppd.cod_compprod='"+programaProduccionDetalle.getFormulaMaestra().getComponentesProd().getCodCompprod()+"'" +
                 " and ppd.cod_lote_produccion='"+programaProduccionDetalle.getCodLoteProduccion()+"'";
            sql+=" and ppd.cod_lote_produccion=pp.cod_lote_produccion and pp.cod_compprod=ppd.cod_compprod";
            sql+=" and m.COD_MATERIAL in (select ep.COD_MATERIAL from FORMULA_MAESTRA_DETALLE_MPROM ep where ep.COD_FORMULA_MAESTRA='"+programaProduccionDetalle.getFormulaMaestra().getCodFormulaMaestra()+"')" +
                 " and ppd.cod_tipo_programa_prod = pp.cod_tipo_programa_prod and pp.cod_tipo_programa_prod='"+programaProduccionDetalle.getTiposProgramaProduccion().getCodTipoProgramaProd()+"' ";
            sql+=" order by m.NOMBRE_MATERIAL";
            System.out.println("sql MPROM:"+sql);
            rs=st.executeQuery(sql);
            while(rs.next()){
                String codMaterial=rs.getString(1);
                String nombreMaterial=rs.getString(2);
                String unidadMedida=rs.getString(3);
                double cantidad=rs.getDouble(4);
                String codUnidadMedida=rs.getString(5);
                FormulaMaestraDetalleMP bean=new FormulaMaestraDetalleMP();
                bean.getMateriales().setCodMaterial(codMaterial);
                bean.getMateriales().setNombreMaterial(nombreMaterial);
                bean.getUnidadesMedida().setNombreUnidadMedida(unidadMedida);
                bean.setCantidad(cantidad);
                bean.getUnidadesMedida().setCodUnidadMedida(codUnidadMedida);
                formulaMaestraMPROMList.add(bean);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return"";
    }
    public String getObtenerCodigo(){

        //String cod=Util.getParameter("codigo");
        String cod=Util.getParameter("codigo");
        String codFormula=Util.getParameter("codFormula");
        String nombre=Util.getParameter("nombre");
        String cantidad=Util.getParameter("cantidad");
        String codCompProd=Util.getParameter("cod_comp_prod");
        String codLote=Util.getParameter("cod_lote");
        String codTipoProgramaProd1 = Util.getParameter("codTipoProgramaProd");
        System.out.println("cxxxxxxxxxxxxxxxxxxxxxxxod:"+cod);
        if(cod!=null){
            setCodigo(cod);
        }
        if(nombre!=null){
            programaProduccionDetalle.getFormulaMaestra().getComponentesProd().setNombreProdSemiterminado(nombre);
        }
        if(codFormula!=null){
            programaProduccionDetalle.getFormulaMaestra().setCodFormulaMaestra(codFormula);
        }
        if(cantidad!=null){
            programaProduccionDetalle.getFormulaMaestra().setCantidadLote(Double.valueOf(cantidad));
        }
        if(codCompProd!=null){
            programaProduccionDetalle.getFormulaMaestra().getComponentesProd().setCodCompprod(codCompProd);
        }
        if(codLote!=null){
            programaProduccionDetalle.setCodLoteProduccion(codLote);
        }
        if(codTipoProgramaProd1!=null){
            programaProduccionDetalle.getTiposProgramaProduccion().setCodTipoProgramaProd(codTipoProgramaProd1);
        }


        detalleProgramProd();

        return "";

    }
    public String verReporteEtiquetas_action(){
       try {
           System.out.println("entro al action");
           ProgramaProduccion programaProduccion = (ProgramaProduccion)programaProduccionDataTable.getRowData();
           ExternalContext externalContext = FacesContext.getCurrentInstance().getExternalContext();
           Map<String, Object> sessionMap = externalContext.getSessionMap();
           sessionMap.put("programaProduccion",programaProduccion);
       } catch (Exception e) {
           e.printStackTrace();
       }
       return null;
   }

    public String cancelar(){
        this.redireccionar("navegador_programa_produccion_desarrollo.jsf");
        return null;
    }
    private boolean verificarExistenciaRegistro(ProgramaProduccion current)
    {
        boolean existe=false;
        try
        {
            Connection con1=null;
            con1=Util.openConnection(con1);
            String consulta="select top 1 * from PROGRAMA_PRODUCCION p where p.COD_LOTE_PRODUCCION ='"+current.getCodLoteProduccion()+"'"+
                            " and p.COD_COMPPROD='"+current.getFormulaMaestra().getComponentesProd().getCodCompprod()+"'" +
                            " and p.COD_PROGRAMA_PROD='"+programaProduccionEditar.getCodProgramaProduccion()+"'" +
                            " and p.COD_TIPO_PROGRAMA_PROD='"+current.getTiposProgramaProduccion().getCodTipoProgramaProd()+"'";
            System.out.println("consulta verificar registrado "+consulta);
            Statement st=con1.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta);
            existe=res.next();
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
    
    public String guardarLotes() throws SQLException{
        mensaje="";
        Connection con1=null;
        int cont=0;
        for(ProgramaProduccion bean:programaProduccionEditarList)
        {
            cont++;
            if(!bean.getCodLoteProduccion().equals(programaProduccionEditar.getCodLoteProduccion()))
            {
                if(verificarExistenciaRegistro(bean))
                {
                    mensaje="Los datos del registro "+cont+" ya se encuentran registrado para el lote "+bean.getCodLoteProduccion();
                    return null;
                }
            }
        }
        try {

            con1=Util.openConnection(con1);
            con1.setAutoCommit(false);
            Statement st=con1.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=null;
            mensaje="";
            String consulta="";

            consulta="delete from PROGRAMA_PRODUCCION_DETALLE where COD_PROGRAMA_PROD='"+programaProduccionEditar.getCodProgramaProduccion()+"'" +
                     " and cod_lote_produccion='"+programaProduccionEditar.getCodLoteProduccion()+"'";

            PreparedStatement pst=con1.prepareStatement(consulta);
            System.out.println("consulta delete detalle"+consulta);
            if(pst.executeUpdate()>0)System.out.println("se elimino el detalle");
            consulta="delete PROGRAMA_PRODUCCION where "+
                     "  COD_LOTE_PRODUCCION='"+programaProduccionEditar.getCodLoteProduccion()+"' " +
                     " and COD_PROGRAMA_PROD='"+programaProduccionEditar.getCodProgramaProduccion()+"'";
             pst=con1.prepareStatement(consulta);
            System.out.println("consulta delete "+consulta);
            if(pst.executeUpdate()>0)System.out.println("se elimino el registro de la tabla");

            for(ProgramaProduccion bean:programaProduccionEditarList)
            {
                bean.getFormulaMaestra().getFormulaMaestraDetalleMPList().clear();
                bean.getFormulaMaestra().getFormulaMaestraDetalleMRList().clear();
                bean.getFormulaMaestra().getFormulaMaestraDetalleEPList().clear();
                bean.getFormulaMaestra().getFormulaMaestraDetalleESList().clear();
                bean.getFormulaMaestra().setFormulaMaestraDetalleMPList(this.cargarFormulaMaestraDetalleMPEditar(bean));
                bean.getFormulaMaestra().setFormulaMaestraDetalleMRList(this.cargarFormulaMaestraDetalleMREditar(bean));
                bean.getFormulaMaestra().setFormulaMaestraDetalleEPList(this.cargarFormulaMaestraDetalleEPEditar(bean));
                bean.getFormulaMaestra().setFormulaMaestraDetalleESList(this.cargarFormulaMaestraDetalleESEditar(bean));
                 consulta= " insert into programa_produccion(cod_programa_prod,cod_formula_maestra,cod_lote_produccion, " +
                            " cod_estado_programa,observacion,CANT_LOTE_PRODUCCION,VERSION_LOTE,COD_COMPPROD,COD_TIPO_PROGRAMA_PROD,COD_PRESENTACION,nro_lotes,COD_COMPPROD_PADRE)" +
                            " values('"+programaProduccionEditar.getCodProgramaProduccion()+"','"+bean.getFormulaMaestra().getCodFormulaMaestra()+"'," +
                            "'"+bean.getCodLoteProduccion()+"','2'," +
                            "'"+bean.getObservacion()+"','"+bean.getCantidadLote()+"','1', " +
                            "'"+bean.getFormulaMaestra().getComponentesProd().getCodCompprod()+"','"+bean.getTiposProgramaProduccion().getCodTipoProgramaProd()+"', " +
                            " '0',1,'"+programaProduccionEditar.getFormulaMaestra().getComponentesProd().getCodCompprod()+"');  ";
                        System.out.println("consulta insert" + consulta);
                        pst=con1.prepareStatement(consulta);
                        if(pst.executeUpdate()>0)System.out.println("se registro satisfactoriamente");

                        Iterator i1 = bean.getFormulaMaestra().getFormulaMaestraDetalleMPList().iterator();

                        while(i1.hasNext()){
                            FormulaMaestraDetalleMP formulaMaestraDetalleMP = (FormulaMaestraDetalleMP)i1.next();
                            consulta = " insert into programa_produccion_detalle(cod_programa_prod,COD_COMPPROD, cod_material,cod_unidad_medida,cantidad,cod_lote_produccion,cod_tipo_programa_prod,cod_tipo_material,cod_estado_registro) " +
                                    " values('"+programaProduccionEditar.getCodProgramaProduccion()+"','"+bean.getFormulaMaestra().getComponentesProd().getCodCompprod()+"', " +
                                    "'"+ formulaMaestraDetalleMP.getMateriales().getCodMaterial() +"','"+formulaMaestraDetalleMP.getUnidadesMedida().getCodUnidadMedida()+"','"+formulaMaestraDetalleMP.getCantidad()+"'," +
                                    "'"+bean.getCodLoteProduccion()+"','"+bean.getTiposProgramaProduccion().getCodTipoProgramaProd()+"',1,1) ";
                            System.out.println("consulta MP " + consulta);
                            pst=con1.prepareStatement(consulta);
                            if(pst.executeUpdate()>0)System.out.println("se registro mat MP satisfactoriamente");

                        }

                        i1 = bean.getFormulaMaestra().getFormulaMaestraDetalleMRList().iterator();
                        while(i1.hasNext()){
                            FormulaMaestraDetalleMP formulaMaestraDetalleMP = (FormulaMaestraDetalleMP)i1.next();
                            consulta = " insert into programa_produccion_detalle(cod_programa_prod,COD_COMPPROD, cod_material,cod_unidad_medida,cantidad,cod_lote_produccion,cod_tipo_programa_prod,cod_tipo_material,cod_estado_registro) " +
                                    " values('"+programaProduccionEditar.getCodProgramaProduccion()+"','"+bean.getFormulaMaestra().getComponentesProd().getCodCompprod()+"', " +
                                    "'"+ formulaMaestraDetalleMP.getMateriales().getCodMaterial() +"','"+formulaMaestraDetalleMP.getUnidadesMedida().getCodUnidadMedida()+"','"+formulaMaestraDetalleMP.getCantidad()+"'," +
                                    "'"+bean.getCodLoteProduccion()+"','"+bean.getTiposProgramaProduccion().getCodTipoProgramaProd()+"',4,1) ";
                            System.out.println("consulta MR " + consulta);
                            pst=con1.prepareStatement(consulta);
                            if(pst.executeUpdate()>0)System.out.println("se registro mat mr satisfactoriamente");

                        }

                         i1 = bean.getFormulaMaestra().getFormulaMaestraDetalleEPList().iterator();
                        while(i1.hasNext()){
                            FormulaMaestraDetalleMP formulaMaestraDetalleMP = (FormulaMaestraDetalleMP)i1.next();
                            consulta = " insert into programa_produccion_detalle(cod_programa_prod,COD_COMPPROD, cod_material,cod_unidad_medida,cantidad,cod_lote_produccion,cod_tipo_programa_prod,cod_tipo_material,cod_estado_registro) " +
                                    " values('"+programaProduccionEditar.getCodProgramaProduccion()+"','"+bean.getFormulaMaestra().getComponentesProd().getCodCompprod()+"', " +
                                    "'"+ formulaMaestraDetalleMP.getMateriales().getCodMaterial() +"','"+formulaMaestraDetalleMP.getUnidadesMedida().getCodUnidadMedida()+"','"+formulaMaestraDetalleMP.getCantidad()+"'," +
                                    "'"+bean.getCodLoteProduccion()+"','"+bean.getTiposProgramaProduccion().getCodTipoProgramaProd()+"',2,1) ";
                            System.out.println("consulta EP " + consulta);
                            pst=con1.prepareStatement(consulta);
                            if(pst.executeUpdate()>0)System.out.println("se registro mat EP satisfactoriamente");

                        }

                        i1 = bean.getFormulaMaestra().getFormulaMaestraDetalleESList().iterator();
                        while(i1.hasNext()){
                            FormulaMaestraDetalleMP formulaMaestraDetalleMP = (FormulaMaestraDetalleMP)i1.next();
                            consulta = " insert into programa_produccion_detalle(cod_programa_prod,COD_COMPPROD, cod_material,cod_unidad_medida,cantidad,cod_lote_produccion,cod_tipo_programa_prod,cod_tipo_material,cod_estado_registro) " +
                                    " values('"+programaProduccionEditar.getCodProgramaProduccion()+"','"+bean.getFormulaMaestra().getComponentesProd().getCodCompprod()+"', " +
                                    "'"+ formulaMaestraDetalleMP.getMateriales().getCodMaterial() +"','"+formulaMaestraDetalleMP.getUnidadesMedida().getCodUnidadMedida()+"','"+formulaMaestraDetalleMP.getCantidad()+"'," +
                                    "'"+bean.getCodLoteProduccion()+"','"+bean.getTiposProgramaProduccion().getCodTipoProgramaProd()+"',3,1) ";
                            System.out.println("consulta ES " + consulta);
                            pst=con1.prepareStatement(consulta);
                            if(pst.executeUpdate()>0)System.out.println("se registro satisfactoriamente");
                        }
            }

           con1.commit();
           pst.close();
           //res.close();
           st.close();
          con1.close();


         } catch (Exception e) {
             e.printStackTrace();
             con1.rollback();
         }finally{
             con1.close();
         }
        getCargarProgramaProduccion1();
        mensaje="";
        return null;
    }

    public String getCodProgramaProd() {
        return codProgramaProd;
    }

    public void setCodProgramaProd(String codProgramaProd) {
        this.codProgramaProd = codProgramaProd;
    }

    public List<SelectItem> getEstadosProgramaProduccion() {
        return estadosProgramaProduccion;
    }

    public void setEstadosProgramaProduccion(List<SelectItem> estadosProgramaProduccion) {
        this.estadosProgramaProduccion = estadosProgramaProduccion;
    }

    public ProgramaProduccion getProgramaProduccionbean() {
        return programaProduccionbean;
    }

    public void setProgramaProduccionbean(ProgramaProduccion programaProduccionbean) {
        this.programaProduccionbean = programaProduccionbean;
    }

    public HtmlDataTable getProgramaProduccionDataTable() {
        return programaProduccionDataTable;
    }

    public void setProgramaProduccionDataTable(HtmlDataTable programaProduccionDataTable) {
        this.programaProduccionDataTable = programaProduccionDataTable;
    }

    public List<ProgramaProduccion> getProgramaProduccionList() {
        return programaProduccionList;
    }

    public void setProgramaProduccionList(List<ProgramaProduccion> programaProduccionList) {
        this.programaProduccionList = programaProduccionList;
    }

    public String getCodEstadoProgramaProduccion() {
        return codEstadoProgramaProduccion;
    }

    public void setCodEstadoProgramaProduccion(String codEstadoProgramaProduccion) {
        this.codEstadoProgramaProduccion = codEstadoProgramaProduccion;
    }

    public ProgramaProduccion getProgramaProduccionEditar() {
        return programaProduccionEditar;
    }

    public void setProgramaProduccionEditar(ProgramaProduccion programaProduccionEditar) {
        this.programaProduccionEditar = programaProduccionEditar;
    }

    public List<ProgramaProduccion> getProgramaProduccionEditarList() {
        return programaProduccionEditarList;
    }

    public void setProgramaProduccionEditarList(List<ProgramaProduccion> programaProduccionEditarList) {
        this.programaProduccionEditarList = programaProduccionEditarList;
    }

    public List getTiposProgramaProdList() {
        return tiposProgramaProdList;
    }

    public void setTiposProgramaProdList(List tiposProgramaProdList) {
        this.tiposProgramaProdList = tiposProgramaProdList;
    }

    public List<SelectItem> getFormulaMaestraList() {
        return formulaMaestraList;
    }

    public void setFormulaMaestraList(List<SelectItem> formulaMaestraList) {
        this.formulaMaestraList = formulaMaestraList;
    }

    public List<ProgramaProduccion> getProgramaProduccionAgregarList() {
        return programaProduccionAgregarList;
    }

    public void setProgramaProduccionAgregarList(List<ProgramaProduccion> programaProduccionAgregarList) {
        this.programaProduccionAgregarList = programaProduccionAgregarList;
    }

    public String getCodigo() {
        return codigo;
    }

    public void setCodigo(String codigo) {
        this.codigo = codigo;
    }

    public HtmlDataTable getProgramaProduccionAgregarDataTable() {
        return programaProduccionAgregarDataTable;
    }

    public void setProgramaProduccionAgregarDataTable(HtmlDataTable programaProduccionAgregarDataTable) {
        this.programaProduccionAgregarDataTable = programaProduccionAgregarDataTable;
    }

    public Date getFechaLote() {
        return fechaLote;
    }

    public void setFechaLote(Date fechaLote) {
        this.fechaLote = fechaLote;
    }

    public HtmlDataTable getProgramaProduccionEditarDataTable() {
        return programaProduccionEditarDataTable;
    }

    public void setProgramaProduccionEditarDataTable(HtmlDataTable programaProduccionEditarDataTable) {
        this.programaProduccionEditarDataTable = programaProduccionEditarDataTable;
    }

    public String getMensaje() {
        return mensaje;
    }

    public void setMensaje(String mensaje) {
        this.mensaje = mensaje;
    }

    public ProgramaProduccion getProgramaProduccionDetalle() {
        return programaProduccionDetalle;
    }

    public void setProgramaProduccionDetalle(ProgramaProduccion programaProduccionDetalle) {
        this.programaProduccionDetalle = programaProduccionDetalle;
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

    public List getFormulaMaestraMPList() {
        return formulaMaestraMPList;
    }

    public void setFormulaMaestraMPList(List formulaMaestraMPList) {
        this.formulaMaestraMPList = formulaMaestraMPList;
    }

    public List getFormulaMaestraMPROMList() {
        return formulaMaestraMPROMList;
    }

    public void setFormulaMaestraMPROMList(List formulaMaestraMPROMList) {
        this.formulaMaestraMPROMList = formulaMaestraMPROMList;
    }

    public List getFormulaMaestraMRList() {
        return formulaMaestraMRList;
    }

    public void setFormulaMaestraMRList(List formulaMaestraMRList) {
        this.formulaMaestraMRList = formulaMaestraMRList;
    }
    
      
}
