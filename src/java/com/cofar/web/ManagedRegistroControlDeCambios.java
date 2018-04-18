/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.web;

import com.cofar.bean.ComponentesProd;
import com.cofar.bean.ComponentesProdVersion;
import com.cofar.bean.EspecificacionesControlCambios;

import com.cofar.bean.RegistroControlCambios;
import com.cofar.bean.RegistroControlCambiosActividadPropuesta;
import com.cofar.bean.RegistroControlCambiosDetalle;
import com.cofar.bean.RegistroControlCambiosProposito;
import com.cofar.bean.TiposEspecificacionesControlCambios;
import com.cofar.util.Util;
import com.lowagie.text.Document;
import com.lowagie.text.PageSize;
import com.lowagie.text.html.simpleparser.HTMLWorker;
import com.lowagie.text.pdf.PdfWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.io.StringReader;
import java.net.URI;
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
import java.util.Properties;
import javax.faces.model.SelectItem;
import javax.mail.Message;
import javax.mail.Session;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import org.richfaces.component.html.HtmlDataTable;



/**
 *
 * @author DASISAQ-
 */

public class ManagedRegistroControlDeCambios extends ManagedBean{

    private Connection con=null;
    private List<RegistroControlCambiosDetalle> registroControlCambiosDetalleRevisarList=new ArrayList<RegistroControlCambiosDetalle>();
    private String mensaje="";
    private RegistroControlCambios registroControlCambios=new RegistroControlCambios();
    private List<SelectItem> personalRegistroSelect=new ArrayList<SelectItem>();
    private List<ComponentesProd> componentesProdList=new ArrayList<ComponentesProd>();
    private HtmlDataTable componentesProdDataTable=new HtmlDataTable();
    private ComponentesProd componentesProdSeleccionado=new ComponentesProd();
    private List<RegistroControlCambios> registroControlCambiosList=new ArrayList<RegistroControlCambios>();
    private HtmlDataTable registroControlCambiosData=new HtmlDataTable();
    private RegistroControlCambios registroControlCambiosSeleccionado=new RegistroControlCambios();
    private List<TiposEspecificacionesControlCambios> tiposEspecificacionesControlCambiosList=new ArrayList<TiposEspecificacionesControlCambios>();
    int codTipoEnvioCorreo=0;
    /** Creates a new instance of ManagedRegistroControlDeCambios */
    public ManagedRegistroControlDeCambios() {
    }
    public String seleccionRegistroControlCambios_select()
    {
        registroControlCambiosSeleccionado=(RegistroControlCambios)registroControlCambiosData.getRowData();
        return null;
    }
    public String seleccionProducto_action()
    {
        componentesProdSeleccionado=(ComponentesProd)componentesProdDataTable.getRowData();
        return null;
    }
    public String getCargarControldeCambiosProducto()
    {
        try
        {
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select rcc.COORELATIVO,rcc.COD_REGISTRO_CONTROL_CAMBIOS,cp.nombre_prod_semiterminado,"+
                            " p.COD_PERSONAL,(p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL+' '+p.nombre2_personal) as nombrePersonal,"+
                            " ae.COD_AREA_EMPRESA,ae.NOMBRE_AREA_EMPRESA,rcc.COD_VERSION_FM,rcc.COD_VERSION_PROD,rcc.AMERITA_CAMBIO,rcc.CAMBIO_DEFINITIVO,rcc.CLASIFICACION_DEL_CAMBIO"+
                            " ,rcc.PROPOSITO_DEL_CAMBIO,rcc.CAMBIO_PROPUESTO,rcc.FECHA_REGISTRO"+
                            " from REGISTRO_CONTROL_CAMBIOS rcc inner join COMPONENTES_PROD cp on rcc.COD_COMPPROD = cp.COD_COMPPROD"+
                            " left outer join PERSONAL p on p.COD_PERSONAL=rcc.COD_PERSONAL_REGISTRA"+
                            " left outer join AREAS_EMPRESA ae on ae.COD_AREA_EMPRESA=rcc.COD_AREA_EMPRESA"+
                            " where rcc.COD_COMPPROD = '"+componentesProdSeleccionado.getCodCompprod()+"'"+
                            " order by rcc.FECHA_REGISTRO";
            System.out.println("consulta controles de cambio "+consulta);
            ResultSet res=st.executeQuery(consulta);
            registroControlCambiosList.clear();
            while(res.next())
            {
                RegistroControlCambios nuevo=new RegistroControlCambios();
                nuevo.getComponentesProd().setNombreProdSemiterminado(res.getString("nombre_prod_semiterminado"));
                nuevo.setCoorelativo(res.getString("COORELATIVO"));
                nuevo.setCodRegistroControlCambios(res.getInt("COD_REGISTRO_CONTROL_CAMBIOS"));
                nuevo.getPersonalRegistra().setCodPersonal(res.getString("COD_PERSONAL"));
                nuevo.getPersonalRegistra().setNombrePersonal(res.getString("nombrePersonal"));
                nuevo.getAreasEmpresa().setCodAreaEmpresa(res.getString("COD_AREA_EMPRESA"));
                nuevo.getAreasEmpresa().setNombreAreaEmpresa(res.getString("NOMBRE_AREA_EMPRESA"));
                nuevo.getFormulaMaestraVersion().setCodVersion(res.getInt("COD_VERSION_FM"));
                nuevo.getComponentesProd().setCodVersion(res.getInt("COD_VERSION_PROD"));
                nuevo.setAmeritaCambio(res.getInt("AMERITA_CAMBIO")>0);
                nuevo.setCambioDefinitivo(res.getInt("CAMBIO_DEFINITIVO")>0);
                nuevo.setClasificacionCambio(res.getString("CLASIFICACION_DEL_CAMBIO"));
                nuevo.setPropositoCambio(res.getString("PROPOSITO_DEL_CAMBIO"));
                nuevo.setCambioPropuesto(res.getString("CAMBIO_PROPUESTO"));
                nuevo.setFechaRegistro(res.getTimestamp("FECHA_REGISTRO"));
                registroControlCambiosList.add(nuevo);
            }
            res.close();
            st.close();
            con.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
        return null;
    }
   
    
    public String getCargarComponentesProdControlCambios()
    {
        this.cargarComponentesProdControlCambios();
        return null;
    }

    private void cargarComponentesProdControlCambios()
    {
        try
        {
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select cp.COD_COMPPROD,cp.nombre_prod_semiterminado,cp.COD_FORMA,ff.nombre_forma,control.cantidadCambios"+
                            " ,ae.COD_AREA_EMPRESA,ae.NOMBRE_AREA_EMPRESA,cp.NOMBRE_GENERICO,cp.VIDA_UTIL,cp.REG_SANITARIO"+
                            " from COMPONENTES_PROD cp inner join AREAS_EMPRESA ae on ae.COD_AREA_EMPRESA=cp.COD_AREA_EMPRESA"+
                            " inner join FORMAS_FARMACEUTICAS ff on ff.cod_forma=cp.COD_FORMA"+
                            " cross apply ( select count(*) as cantidadCambios from REGISTRO_CONTROL_CAMBIOS rcc where rcc.COD_COMPPROD=cp.COD_COMPPROD)as control" +
                            " where control.cantidadCambios>0"+
                            " order by cp.nombre_prod_semiterminado";
            ResultSet res=st.executeQuery(consulta);
            componentesProdList.clear();
            while(res.next())
            {
                ComponentesProdVersion nuevo= new ComponentesProdVersion();
                nuevo.setCodCompprod(res.getString("COD_COMPPROD"));
                nuevo.setNombreProdSemiterminado(res.getString("nombre_prod_semiterminado"));
                nuevo.getForma().setCodForma(res.getString("COD_FORMA"));
                nuevo.getForma().setNombreForma(res.getString("nombre_forma"));
                nuevo.setNroVersion(res.getInt("cantidadCambios"));
                nuevo.getAreasEmpresa().setCodAreaEmpresa(res.getString("COD_AREA_EMPRESA"));
                nuevo.getAreasEmpresa().setNombreAreaEmpresa(res.getString("NOMBRE_AREA_EMPRESA"));
                nuevo.setVidaUtil(res.getInt("VIDA_UTIL"));
                nuevo.setNombreGenerico(res.getString("NOMBRE_GENERICO"));
                nuevo.setRegSanitario(res.getString("REG_SANITARIO"));
                componentesProdList.add(nuevo);
            }
            st.close();
            con.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
    }
    public String getCargarRevisionRegistroControlCambios()
    {
        try
        {
            con=Util.openConnection(con);
            Statement st =con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select rccd.COD_ESPECIFICACION_CONTROL_CAMBIOS,ecc.NOMBRE_ESPECIFICACION_CONTROL_CAMBIOS,"+
                            " rccd.APLICA,rccd.ACTIVIDAD,rccd.COD_RESPONSABLE,rccd.FECHA_LIMITE"+
                            " from REGISTRO_CONTROL_CAMBIOS_DETALLE rccd inner join ESPECIFICACIONES_CONTROL_CAMBIOS ecc on "+
                            " rccd.COD_ESPECIFICACION_CONTROL_CAMBIOS=ecc.COD_ESPECIFICACION_CONTROL_CAMBIOS"+
                            " where rccd.COD_REGISTRO_CONTROL_CAMBIOS='"+registroControlCambiosSeleccionado.getCodRegistroControlCambios()+"'"+
                            " order by ecc.NOMBRE_ESPECIFICACION_CONTROL_CAMBIOS";
            System.out.println("consulta detalle control de cambios "+consulta);
            registroControlCambiosDetalleRevisarList.clear();
            ResultSet res=st.executeQuery(consulta);
            while(res.next())
            {
                RegistroControlCambiosDetalle nuevo=new RegistroControlCambiosDetalle();
                nuevo.getEspecificacionesControlCambios().setCodEspecificacionControlCambios(res.getInt("COD_ESPECIFICACION_CONTROL_CAMBIOS"));
                nuevo.getEspecificacionesControlCambios().setNombreEspecificacionControlCambios(res.getString("NOMBRE_ESPECIFICACION_CONTROL_CAMBIOS"));
                nuevo.setActividad(res.getString("ACTIVIDAD"));
                nuevo.setAplica(res.getInt("APLICA")>0);
                nuevo.getPersonalResponsable().setCodPersonal(res.getString("COD_RESPONSABLE"));
                nuevo.setFechaLimite(res.getTimestamp("FECHA_LIMITE"));
                registroControlCambiosDetalleRevisarList.add(nuevo);
            }
            res.close();
            st.close();
            con.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
        this.cargarPersonalSelect();
        return null;
    }
    public String getCargarAgregarRegistroControlCambios()
    {
        try
        {
            ManagedAccesoSistema managed=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            int codCompProdVersion=(Util.getParameter("codCompProdVersion")!=null?Integer.valueOf(Util.getParameter("codCompProdVersion")):0);
            String consulta="select cpv.nombre_prod_semiterminado,ff.nombre_forma,cpv.COD_COMPPROD,fmv.COD_VERSION as codVersionFM"+
                            " from COMPONENTES_PROD_VERSION cpv inner join FORMAS_FARMACEUTICAS ff "+
                            " on  cpv.COD_FORMA=ff.cod_forma" +
                            " inner join FORMULA_MAESTRA_VERSION fmv on fmv.COD_COMPPROD_VERSION=cpv.COD_VERSION"+
                            " and fmv.COD_COMPPROD=fmv.COD_COMPPROD"+
                            " where cpv.COD_VERSION='"+codCompProdVersion+"'";
            System.out.println("consulta cargar datos cp "+consulta);
            ResultSet res=st.executeQuery(consulta);
            if(res.next())
            {
                registroControlCambios=new RegistroControlCambios();
                registroControlCambios.getComponentesProd().setCodVersion(codCompProdVersion);
                registroControlCambios.getComponentesProd().setCodCompprod(res.getString("COD_COMPPROD"));
                registroControlCambios.getComponentesProd().setNombreProdSemiterminado(res.getString("nombre_prod_semiterminado"));
                registroControlCambios.getComponentesProd().getForma().setNombreForma(res.getString("nombre_forma"));
                registroControlCambios.getFormulaMaestraVersion().setCodVersion(res.getInt("codVersionFM"));
            }
            consulta="select r.COD_REGISTRO_CONTROL_CAMBIOS"+
                     " from REGISTRO_CONTROL_CAMBIOS r where r.COD_VERSION_PROD='"+registroControlCambios.getComponentesProd().getCodVersion()+"'" +
                     " and r.COD_VERSION_FM='"+registroControlCambios.getFormulaMaestraVersion().getCodVersion()+"'";
            System.out.println("consulta verificar registroControlCambios Registrado");
            res=st.executeQuery(consulta);
            if(res.next())
            {
                registroControlCambios.setCodRegistroControlCambios(res.getInt("COD_REGISTRO_CONTROL_CAMBIOS"));
            }
            consulta="select (p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL) as nombrePersonal,"+
                     " rccp.PROPOSITO_CAMBIO"+
                     " from REGISTRO_CONTROL_CAMBIOS_PROPOSITO rccp inner join personal p "+
                     " on rccp.COD_PERSONAL=p.COD_PERSONAL"+
                     " where rccp.COD_REGISTRO_CONTROL_CAMBIOS='"+registroControlCambios.getCodRegistroControlCambios()+"' order by p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRES_PERSONAL";
            System.out.println("consulta cargar cambios propuestos anteriores "+consulta);
            res=st.executeQuery(consulta);
            registroControlCambios.setRegistroControlCambiosPropositoList(new ArrayList<RegistroControlCambiosProposito>());
            while(res.next())
            {
                RegistroControlCambiosProposito nuevo=new RegistroControlCambiosProposito();
                nuevo.getPersonal().setNombrePersonal(res.getString("nombrePersonal"));
                nuevo.setPropositoCambio(res.getString("PROPOSITO_CAMBIO"));
                registroControlCambios.getRegistroControlCambiosPropositoList().add(nuevo);
            }
            RegistroControlCambiosProposito nuevoC=new RegistroControlCambiosProposito();
            nuevoC.setChecked(true);
            nuevoC.getPersonal().setCodPersonal(managed.getUsuarioModuloBean().getCodUsuarioGlobal());
            nuevoC.getPersonal().setNombrePersonal(managed.getUsuarioModuloBean().getApPaternoUsuarioGlobal()+" "+managed.getUsuarioModuloBean().getApMaternoUsuarioGlobal()+" "+managed.getUsuarioModuloBean().getNombrePilaUsuarioGlobal());
            registroControlCambios.getRegistroControlCambiosPropositoList().add(nuevoC);
            consulta="select tecc.NOMBRE_TIPO_ESPECIFICACION_CONTROL_CAMBIOS,tecc.COD_TIPO_ESPECIFICACION_CONTROL_CAMBIOS,"+
                     " ecc.COD_ESPECIFICACION_CONTROL_CAMBIOS,ecc.NOMBRE_ESPECIFICACION_CONTROL_CAMBIOS"+
                     " from ESPECIFICACIONES_CONTROL_CAMBIOS ecc inner join TIPOS_ESPECIFICACIONES_CONTROL_CAMBIOS tecc"+
                     " on ecc.COD_TIPO_ESPECIFICACION_CONTROL_CAMBIOS=tecc.COD_TIPO_ESPECIFICACION_CONTROL_CAMBIOS"+
                     " where ecc.COD_ESTADO_REGISTRO=1"+
                     " order by tecc.ORDEN,ecc.NOMBRE_ESPECIFICACION_CONTROL_CAMBIOS";
            System.out.println("consulta actividades propuestas "+consulta);
            res=st.executeQuery(consulta);
            tiposEspecificacionesControlCambiosList.clear();
            TiposEspecificacionesControlCambios nuevo=new TiposEspecificacionesControlCambios();
            List<EspecificacionesControlCambios> especificacionesControlCambiosList=new ArrayList<EspecificacionesControlCambios>();
            Statement stDetalle=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet resDetalle=null;
            while(res.next())
            {
                if(nuevo.getCodTipoEspecificacionControlCambios()!=res.getInt("COD_TIPO_ESPECIFICACION_CONTROL_CAMBIOS"))
                {
                    if(nuevo.getCodTipoEspecificacionControlCambios()>0)
                    {
                        nuevo.setEspecificacionesControlCambiosList(especificacionesControlCambiosList);
                        tiposEspecificacionesControlCambiosList.add(nuevo);
                    }
                    nuevo=new TiposEspecificacionesControlCambios();
                    nuevo.setCodTipoEspecificacionControlCambios(res.getInt("COD_TIPO_ESPECIFICACION_CONTROL_CAMBIOS"));
                    nuevo.setNombreTipoEspecificacionControlCambios(res.getString("NOMBRE_TIPO_ESPECIFICACION_CONTROL_CAMBIOS"));
                    especificacionesControlCambiosList=new ArrayList<EspecificacionesControlCambios>();
                }
                EspecificacionesControlCambios especificacion=new EspecificacionesControlCambios();
                especificacion.setCodEspecificacionControlCambios(res.getInt("COD_ESPECIFICACION_CONTROL_CAMBIOS"));
                especificacion.setNombreEspecificacionControlCambios(res.getString("NOMBRE_ESPECIFICACION_CONTROL_CAMBIOS"));
                especificacionesControlCambiosList.add(especificacion);
                especificacion.setRegistroControlCambiosActividadPropuestList(new ArrayList<RegistroControlCambiosActividadPropuesta>());
                consulta="select p.COD_PERSONAL,(p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL) as nombrePersonal,"+
                         " ra.ACTIVIDAD_SUGERIDA"+
                         " from REGISTRO_CONTROL_CAMBIOS_ACTIVIDAD_PROPUESTA ra inner join personal p on"+
                         " ra.COD_PERSONAL=p.COD_PERSONAL"+
                         " where ra.COD_REGISTRO_CONTROL_CAMBIOS='"+registroControlCambios.getCodRegistroControlCambios()+"'" +
                         " and ra.COD_ESPECIFICACION_CONTROL_CAMBIOS='"+res.getInt("COD_ESPECIFICACION_CONTROL_CAMBIOS")+"'"+
                         " order by 2";
                resDetalle=stDetalle.executeQuery(consulta);
                while(resDetalle.next())
                {
                    RegistroControlCambiosActividadPropuesta nuevoR=new RegistroControlCambiosActividadPropuesta();
                    nuevoR.getPersonal().setCodPersonal(resDetalle.getString("COD_PERSONAL"));
                    nuevoR.getPersonal().setNombrePersonal(resDetalle.getString("nombrePersonal"));
                    nuevoR.setActividadSugerida(resDetalle.getString("ACTIVIDAD_SUGERIDA"));
                    especificacion.getRegistroControlCambiosActividadPropuestList().add(nuevoR);
                }
                RegistroControlCambiosActividadPropuesta nuevoR=new RegistroControlCambiosActividadPropuesta();
                nuevoR.getPersonal().setCodPersonal(managed.getUsuarioModuloBean().getCodUsuarioGlobal());
                nuevoR.getPersonal().setNombrePersonal(managed.getUsuarioModuloBean().getApPaternoUsuarioGlobal()+" "+managed.getUsuarioModuloBean().getApMaternoUsuarioGlobal()+" "+managed.getUsuarioModuloBean().getNombrePilaUsuarioGlobal());
                nuevoR.setChecked(true);
                especificacion.getRegistroControlCambiosActividadPropuestList().add(nuevoR);
            }
            if(nuevo.getCodTipoEspecificacionControlCambios()>0)
            {
                nuevo.setEspecificacionesControlCambiosList(especificacionesControlCambiosList);
                tiposEspecificacionesControlCambiosList.add(nuevo);
            }
            consulta="select p.COD_PERSONAL,(p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL+' '+p.nombre2_personal) as nombrePersonal,"+
                     " ae.COD_AREA_EMPRESA,ae.NOMBRE_AREA_EMPRESA"+
                     " from personal p  inner join AREAS_EMPRESA ae on ae.COD_AREA_EMPRESA=p.COD_AREA_EMPRESA"+
                     " where p.COD_PERSONAL='"+managed.getUsuarioModuloBean().getCodUsuarioGlobal()+"'";
            System.out.println("consulta pesonal");
            res=st.executeQuery(consulta);
            while(res.next())
            {
                registroControlCambios.getPersonalRegistra().setCodPersonal(res.getString("COD_PERSONAL"));
                registroControlCambios.getPersonalRegistra().setNombrePersonal(res.getString("nombrePersonal"));
                registroControlCambios.getAreasEmpresa().setCodAreaEmpresa(res.getString("COD_AREA_EMPRESA"));
                registroControlCambios.getAreasEmpresa().setNombreAreaEmpresa(res.getString("NOMBRE_AREA_EMPRESA"));
            }
            consulta="select isnull(max(cast((SUBSTRING(rcc.COORELATIVO,(LEN(rcc.COORELATIVO)-5),3)) as int) ),0)+1 as cod"+
                     " from REGISTRO_CONTROL_CAMBIOS rcc";
            res=st.executeQuery(consulta);
            System.out.println("consulta coorelativo "+consulta);
            String codigo="";
            if(res.next())
            {
                codigo = res.getString("cod");
                if(res.getDouble("cod")<10){
                    codigo = "00"+res.getInt("cod");
                }
                if(res.getDouble("cod")>=10 && res.getDouble("cod")<100){
                    codigo = "0"+res.getInt("cod");
                }
                    
            }

            consulta="select SUBSTRING(g.ANIO_MENOR,(LEN(g.ANIO_MENOR)-1),2) as gestion from GESTIONES g where g.GESTION_ESTADO=1";
            res=st.executeQuery(consulta);
            if(res.next())
            {
                registroControlCambios.setCoorelativo(codigo+"/"+res.getString("gestion"));
            }
            con.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
        //this.cargarPersonalSelect();
        return null;
    }
    private void cargarPersonalSelect()
    {
        try
        {
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select p.COD_PERSONAL,(p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL+' '+p.nombre2_personal)as nombrePersonal"+
                     " from PERSONAL p where p.COD_ESTADO_PERSONA=1"+
                    " order by p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRES_PERSONAL,p.nombre2_personal";
            ResultSet res=st.executeQuery(consulta);
            personalRegistroSelect.clear();
            personalRegistroSelect.add(new SelectItem("0","--Seleccione una opcion--"));
            while(res.next())
            {
                personalRegistroSelect.add(new SelectItem(res.getString("COD_PERSONAL"),res.getString("nombrePersonal")));
            }
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
    }
    public String guardarRevisionControlCambios_action()throws SQLException
    {
        mensaje="";
        try
        {
            con=Util.openConnection(con);
            con.setAutoCommit(false);
            SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
            String consulta="UPDATE REGISTRO_CONTROL_CAMBIOS SET CAMBIO_PROPUESTO = ?,"+
                            " PROPOSITO_DEL_CAMBIO = ?,"+
                            " CLASIFICACION_DEL_CAMBIO ='"+(registroControlCambiosSeleccionado.getClasificacionCambio())+"',"+
                            " AMERITA_CAMBIO = '"+(registroControlCambiosSeleccionado.isAmeritaCambio()?1:0)+"',"+
                            " CAMBIO_DEFINITIVO = '"+(registroControlCambiosSeleccionado.isCambioDefinitivo()?1:0)+"'"+
                            " WHERE COD_REGISTRO_CONTROL_CAMBIOS = '"+(registroControlCambiosSeleccionado.getCodRegistroControlCambios())+"'";
            System.out.println("consulta registrar control de cambios "+consulta);
            PreparedStatement pst=con.prepareStatement(consulta);
            pst.setString(1,registroControlCambiosSeleccionado.getCambioPropuesto());
            pst.setString(2,registroControlCambiosSeleccionado.getPropositoCambio());
            if(pst.executeUpdate()>0)System.out.println("se registro el control de cambios");
            consulta="delete REGISTRO_CONTROL_CAMBIOS_DETALLE where COD_REGISTRO_CONTROL_CAMBIOS='"+registroControlCambiosSeleccionado.getCodRegistroControlCambios()+"'";
            System.out.println("consulta delete detalle "+consulta);
            pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se elimino el detalle");
            for(RegistroControlCambiosDetalle bean:registroControlCambiosDetalleRevisarList)
            {
                consulta="INSERT INTO REGISTRO_CONTROL_CAMBIOS_DETALLE(COD_REGISTRO_CONTROL_CAMBIOS,"+
                         " COD_ESPECIFICACION_CONTROL_CAMBIOS, APLICA, ACTIVIDAD, COD_RESPONSABLE,FECHA_LIMITE)"+
                         " VALUES ('"+registroControlCambiosSeleccionado.getCodRegistroControlCambios()+"'," +
                         "'"+bean.getEspecificacionesControlCambios().getCodEspecificacionControlCambios()+"',"+
                         " '"+(bean.isAplica()?1:0)+"',?,'"+bean.getPersonalResponsable().getCodPersonal()+"'," +
                         (bean.getFechaLimite()!=null?"'"+sdf.format(bean.getFechaLimite())+"'":"null")+")";
                System.out.println("consulta insert registro detalle "+consulta);
                pst=con.prepareStatement(consulta);
                pst.setString(1,bean.getActividad());
                if(pst.executeUpdate()>0)System.out.println("se registro el detalle");
            }
            con.commit();
            mensaje="1";
            pst.close();
            con.close();
        }
        catch(SQLException ex)
        {
            con.rollback();
            con.close();
            mensaje="Ocurrio un error al momento de guardar la revision, intente de nuevo";
            ex.printStackTrace();
        }
        return null;
    }
    private String cambioPropuesto()
    {
      String innerHTML="<table class='tablaComparacion' cellpadding='0' cellspacing='0'>"+
                        "<thead><tr><td colspan='3'>DATOS DEL PRODUCTO</td></tr>"+
                        "<tr><td>Especificación</td><td>Version Activa</td><td>Version Propuesta</td></tr>"+
                        "</thead>";
                    try
                    {
                        con=Util.openConnection(con);
                        NumberFormat numeroformato = NumberFormat.getNumberInstance(Locale.ENGLISH);
                        DecimalFormat formato = (DecimalFormat) numeroformato;
                        formato.applyPattern("#,##0.00");
                        String consulta="select isnull(cp.COD_COMPPROD,0) as codComprodOfi,isnull(cp.nombre_prod_semiterminado,'') as nombre_prod_semiterminado,cpv.nombre_prod_semiterminado as nombre_prod_semiterminadoVersion" +
                                        ",isnull(ae.NOMBRE_AREA_EMPRESA,'') as NOMBRE_AREA_EMPRESA,ae1.NOMBRE_AREA_EMPRESA as NOMBRE_AREA_EMPRESAVersion" +
                                        ",ISNULL(p.nombre_prod,'')as nombre_prod,p1.nombre_prod as nombre_prodVersion" +
                                        " ,isnull(cp.NOMBRE_GENERICO,'') as NOMBRE_GENERICO,cpv.NOMBRE_GENERICO as NOMBRE_GENERICOVersion" +
                                        " ,isnull(ff.nombre_forma,'') as nombre_forma,ff1.nombre_forma as nombre_formaVersion" +
                                        " ,isnull(cpp.NOMBRE_COLORPRESPRIMARIA,'') as NOMBRE_COLORPRESPRIMARIA,isnull(cpp1.NOMBRE_COLORPRESPRIMARIA,'') as NOMBRE_COLORPRESPRIMARIAVersion" +
                                        " ,isnull(vap.NOMBRE_VIA_ADMINISTRACION_PRODUCTO,'') as NOMBRE_VIA_ADMINISTRACION_PRODUCTO,isnull(vap1.NOMBRE_VIA_ADMINISTRACION_PRODUCTO,'') as NOMBRE_VIA_ADMINISTRACION_PRODUCTOVersion" +
                                        " ,isnull(cp.PESO_ENVASE_PRIMARIO,'') as PESO_ENVASE_PRIMARIO,cpv.PESO_ENVASE_PRIMARIO as PESO_ENVASE_PRIMARIOVersion" +
                                        " ,isnull(cp.TOLERANCIA_VOLUMEN_FABRICAR,0) as TOLERANCIA_VOLUMEN_FABRICAR,isnull(cpv.TOLERANCIA_VOLUMEN_FABRICAR,0) as TOLERANCIA_VOLUMEN_FABRICARVersion" +
                                        " ,isnull(sp.NOMBRE_SABOR,'') as NOMBRE_SABOR,isnull(sp1.NOMBRE_SABOR,'') as NOMBRE_SABORVersion" +
                                        " ,isnull(tap.NOMBRE_TAMANIO_CAPSULA_PRODUCCION,'') as NOMBRE_TAMANIO_CAPSULA_PRODUCCION,ISNULL(tap1.NOMBRE_TAMANIO_CAPSULA_PRODUCCION,'') as NOMBRE_TAMANIO_CAPSULA_PRODUCCIONVersion" +
                                        " ,isnull(ec.NOMBRE_ESTADO_COMPPROD,'') as NOMBRE_ESTADO_COMPPROD,ec1.NOMBRE_ESTADO_COMPPROD as NOMBRE_ESTADO_COMPPRODVersion" +
                                        " ,isnull(cp.REG_SANITARIO,'') as REG_SANITARIO,cpv.REG_SANITARIO as REG_SANITARIOVersion"+
                                        " ,isnull(cp.VIDA_UTIL,0) as VIDA_UTIL,cpv.VIDA_UTIL as VIDA_UTILVersion"+
                                        " ,cp.FECHA_VENCIMIENTO_RS,cpv.FECHA_VENCIMIENTO_RS as FECHA_VENCIMIENTO_RSVersion" +
                                        " ,isnull(cast(cp.CANTIDAD_VOLUMEN as varchar)+' '+um.ABREVIATURA,'') as volumen"+
                                        " ,isnull(cast(cpv.CANTIDAD_VOLUMEN as varchar)+' '+um1.ABREVIATURA,'') as volumenVersion" +
                                        " ,isnull(cp.PRODUCTO_SEMITERMINADO,0) as PRODUCTO_SEMITERMINADO,isnull(cpv.PRODUCTO_SEMITERMINADO,0) as PRODUCTO_SEMITERMINADOVersion" +
                                        " ,isnull(cvp.NOMBRE_CONDICION_VENTA_PRODUCTO,'') as NOMBRE_CONDICION_VENTA_PRODUCTO,"+
                                        " isnull(cvp1.NOMBRE_CONDICION_VENTA_PRODUCTO,'') as NOMBRE_CONDICION_VENTA_PRODUCTOVersion,"+
                                        " isnull(cp.PRESENTACIONES_REGISTRADAS_RS,'') as PRESENTACIONES_REGISTRADAS_RS,"+
                                        " isnull(cpv.PRESENTACIONES_REGISTRADAS_RS,'') as PRESENTACIONES_REGISTRADAS_RSVersion,"+
                                        " isnull(cp.NOMBRE_COMERCIAL,'') as NOMBRE_COMERCIAL,isnull(cpv.NOMBRE_COMERCIAL,'') as NOMBRE_COMERCIALVersion" +
                                        " ,cp.TAMANIO_LOTE_PRODUCCION,cpv.TAMANIO_LOTE_PRODUCCION as TAMANIO_LOTE_PRODUCCIONVersion"+
                                        " from COMPONENTES_PROD_VERSION cpv left outer join COMPONENTES_PROD cp on cp.COD_COMPPROD=cpv.COD_COMPPROD" +
                                        " left outer join AREAS_EMPRESA ae on ae.COD_AREA_EMPRESA=cp.COD_AREA_EMPRESA"+
                                        " left outer join AREAS_EMPRESA ae1 on ae1.COD_AREA_EMPRESA=cpv.COD_AREA_EMPRESA" +
                                        " left outer join PRODUCTOS p on p.cod_prod=cp.COD_PROD"+
                                        " left outer join PRODUCTOS p1 on p1.cod_prod=cpv.COD_PROD" +
                                        " left outer join FORMAS_FARMACEUTICAS ff on ff.cod_forma=cp.COD_FORMA"+
                                        " left outer join FORMAS_FARMACEUTICAS ff1 on ff1.cod_forma=cpv.COD_FORMA" +
                                        " left outer join COLORES_PRESPRIMARIA cpp on cp.COD_COLORPRESPRIMARIA=cpp.COD_COLORPRESPRIMARIA"+
                                        " left outer join COLORES_PRESPRIMARIA cpp1 on cpv.COD_COLORPRESPRIMARIA=cpp1.COD_COLORPRESPRIMARIA" +
                                        " left outer join VIAS_ADMINISTRACION_PRODUCTO vap on vap.COD_VIA_ADMINISTRACION_PRODUCTO=cp.COD_VIA_ADMINISTRACION_PRODUCTO"+
                                        " left outer join VIAS_ADMINISTRACION_PRODUCTO vap1 on vap1.COD_VIA_ADMINISTRACION_PRODUCTO=cpv.COD_VIA_ADMINISTRACION_PRODUCTO" +
                                        " left outer join SABORES_PRODUCTO sp on sp.COD_SABOR=cp.COD_SABOR"+
                                        " left outer join SABORES_PRODUCTO sp1 on sp1.COD_SABOR=cpv.COD_SABOR" +
                                        " left outer join TAMANIOS_CAPSULAS_PRODUCCION tap on tap.COD_TAMANIO_CAPSULA_PRODUCCION=cp.COD_TAMANIO_CAPSULA_PRODUCCION"+
                                        " left outer join TAMANIOS_CAPSULAS_PRODUCCION tap1 on tap1.COD_TAMANIO_CAPSULA_PRODUCCION=cpv.COD_TAMANIO_CAPSULA_PRODUCCION" +
                                        " left outer join ESTADOS_COMPPROD ec on ec.COD_ESTADO_COMPPROD=cp.COD_ESTADO_COMPPROD"+
                                        " left outer join ESTADOS_COMPPROD ec1 on ec1.COD_ESTADO_COMPPROD=cpv.COD_ESTADO_COMPPROD" +
                                        " left outer join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=cp.COD_UNIDAD_MEDIDA_VOLUMEN"+
                                        " left outer join UNIDADES_MEDIDA um1 on um1.COD_UNIDAD_MEDIDA=cpv.COD_UNIDAD_MEDIDA_VOLUMEN" +
                                        " left outer join CONDICIONES_VENTA_PRODUCTO cvp on cvp.COD_CONDICION_VENTA_PRODUCTO=cp.COD_CONDICION_VENTA_PRODUCTO"+
                                        " left outer join CONDICIONES_VENTA_PRODUCTO cvp1 on cvp1.COD_CONDICION_VENTA_PRODUCTO=cpv.COD_CONDICION_VENTA_PRODUCTO"+
                                        " where cpv.COD_COMPPROD='"+registroControlCambios.getComponentesProd().getCodCompprod()+"'" +
                                        " and cpv.COD_VERSION='"+registroControlCambios.getComponentesProd().getCodVersion()+"'";
                        System.out.println("consulta verificar cambios "+consulta);
                        Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                        ResultSet res=st.executeQuery(consulta);
                        Statement stDetalle=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                        ResultSet resDetalle=null;
                        boolean nuevo=false;
                        SimpleDateFormat sdfDias=new SimpleDateFormat("dd/MM/yyyy");
                        boolean productoSemiterminado=false;
                        if(res.next())
                        {
                            productoSemiterminado=res.getInt("PRODUCTO_SEMITERMINADOVersion")>0;
                            nuevo=res.getInt("codComprodOfi")==0;
                            innerHTML+="<tr class='"+(nuevo?"nuevo":(res.getString("nombre_prod_semiterminado").equals(res.getString("nombre_prod_semiterminadoVersion"))?"":"modificado"))+"'><td class='especificacion'>Nombre Producto</td><td>"+res.getString("nombre_prod_semiterminado")+"&nbsp;</td><td>&nbsp;"+res.getString("nombre_prod_semiterminadoVersion")+"</td></tr>"+
                                        "<tr class='"+(nuevo?"nuevo":(res.getString("NOMBRE_AREA_EMPRESA").equals(res.getString("NOMBRE_AREA_EMPRESAVersion"))?"":"modificado"))+"'><td class='especificacion'>Area Empresa</td><td>"+res.getString("NOMBRE_AREA_EMPRESA")+"&nbsp;</td><td>"+res.getString("NOMBRE_AREA_EMPRESAVersion")+"</td></tr>"+
                                        "<tr class='"+(nuevo?"nuevo":(res.getString("PRODUCTO_SEMITERMINADO").equals(res.getString("PRODUCTO_SEMITERMINADOVersion"))?"":"modificado"))+"'><td class='especificacion'>Producto Semiterminado</td><td>"+(res.getInt("PRODUCTO_SEMITERMINADO")>0?"SI":"NO")+"</td><td>"+(res.getInt("PRODUCTO_SEMITERMINADOVersion")>0?"SI":"NO")+"</td></tr>"+
                                        (productoSemiterminado?"":"<tr class='"+(nuevo?"nuevo":(res.getString("NOMBRE_COMERCIAL").equals(res.getString("NOMBRE_COMERCIALVersion"))?"":"modificado"))+"'><td class='especificacion'>Nombre Comercial</td><td>&nbsp;"+res.getString("NOMBRE_COMERCIAL")+"</td><td>"+res.getString("NOMBRE_COMERCIALVersion")+"</td></tr>"+
                                        "<tr class='"+(nuevo?"nuevo":(res.getInt("TAMANIO_LOTE_PRODUCCION")==res.getInt("TAMANIO_LOTE_PRODUCCIONVersion")?"":"modificado"))+"'><td class='especificacion'>Tamaño Lote Producción</td><td>&nbsp;"+res.getInt("TAMANIO_LOTE_PRODUCCION")+"</td><td>"+res.getInt("TAMANIO_LOTE_PRODUCCIONVersion")+"</td></tr>"+
                                        "<tr class='"+(nuevo?"nuevo":(res.getString("REG_SANITARIO").equals(res.getString("REG_SANITARIOVersion"))?"":"modificado"))+"'><td class='especificacion'>Registro Sanitario</td><td>&nbsp;"+res.getString("REG_SANITARIO")+"</td><td>"+res.getString("REG_SANITARIOVersion")+"</td></tr>"+
                                        "<tr class='"+(nuevo?"nuevo":(res.getInt("VIDA_UTIL")==res.getInt("VIDA_UTILVersion")?"":"modificado"))+"'><td class='especificacion'>Vida Util</td><td>"+res.getInt("VIDA_UTIL")+"</td><td>"+res.getInt("VIDA_UTILVersion")+"</td></tr>"+
                                        "<tr class='"+(nuevo?"nuevo":(sdfDias.format(res.getTimestamp("FECHA_VENCIMIENTO_RS")).equals(sdfDias.format(res.getTimestamp("FECHA_VENCIMIENTO_RSVersion")))?"":"modificado"))+"'><td class='especificacion'>Fecha Vencimiento R.S.</td><td>"+(res.getTimestamp("FECHA_VENCIMIENTO_RS")!=null?sdfDias.format(res.getTimestamp("FECHA_VENCIMIENTO_RS")):"&nbsp;")+"</td><td>"+sdfDias.format(res.getTimestamp("FECHA_VENCIMIENTO_RSVersion"))+"</td></tr>"+
                                        "<tr class='"+(nuevo?"nuevo":(res.getString("NOMBRE_SABOR").equals(res.getString("NOMBRE_SABORVersion"))?"":"modificado"))+"'><td class='especificacion'>Sabor</td><td>&nbsp;"+res.getString("NOMBRE_SABOR")+"</td><td>&nbsp;"+res.getString("NOMBRE_SABORVersion")+"</td></tr>"+
                                        "<tr class='"+(nuevo?"nuevo":(res.getString("NOMBRE_CONDICION_VENTA_PRODUCTO").equals(res.getString("NOMBRE_CONDICION_VENTA_PRODUCTOVersion"))?"":"modificado"))+"'><td class='especificacion'>Condición Venta</td><td>&nbsp;"+res.getString("NOMBRE_CONDICION_VENTA_PRODUCTO")+"</td><td>&nbsp;"+res.getString("NOMBRE_CONDICION_VENTA_PRODUCTOVersion")+"</td></tr>"+
                                        "<tr class='"+(nuevo?"nuevo":(res.getString("PRESENTACIONES_REGISTRADAS_RS").equals(res.getString("PRESENTACIONES_REGISTRADAS_RSVersion"))?"":"modificado"))+"'><td class='especificacion'>Presentaciones Registradas</td><td>&nbsp;"+res.getString("PRESENTACIONES_REGISTRADAS_RS")+"</td><td>&nbsp;"+res.getString("PRESENTACIONES_REGISTRADAS_RSVersion")+"</td></tr>")+
                                        //"<tr class='"+(nuevo?"nuevo":(res.getString("NOMBRE_GENERICO").equals(res.getString("NOMBRE_GENERICOVersion"))?"":"modificado"))+"'><td class='especificacion'>Nombre Generico</td><td>"+res.getString("NOMBRE_GENERICO")+"</td><td>"+res.getString("NOMBRE_GENERICOVersion")+"</td></tr>"+
                                        "<tr class='"+(nuevo?"nuevo":(res.getString("nombre_forma").equals(res.getString("nombre_formaVersion"))?"":"modificado"))+"'><td class='especificacion'>Forma Farmaceútica</td><td>&nbsp;"+res.getString("nombre_forma")+"</td><td>"+res.getString("nombre_formaVersion")+"</td></tr>"+
                                        "<tr class='"+(nuevo?"nuevo":(res.getString("NOMBRE_COLORPRESPRIMARIA").equals(res.getString("NOMBRE_COLORPRESPRIMARIAVersion"))?"":"modificado"))+"'><td class='especificacion'>Color Presentación Primaria</td><td> &nbsp;"+res.getString("NOMBRE_COLORPRESPRIMARIA")+"</td><td>&nbsp;"+res.getString("NOMBRE_COLORPRESPRIMARIAVersion")+"</td></tr>"+
                                        "<tr class='"+(nuevo?"nuevo":(res.getString("NOMBRE_VIA_ADMINISTRACION_PRODUCTO").equals(res.getString("NOMBRE_VIA_ADMINISTRACION_PRODUCTOVersion"))?"":"modificado"))+"'><td class='especificacion'>Via Administración</td><td>&nbsp;"+res.getString("NOMBRE_VIA_ADMINISTRACION_PRODUCTO")+"</td><td>"+res.getString("NOMBRE_VIA_ADMINISTRACION_PRODUCTOVersion")+"</td></tr>"+
                                        "<tr class='"+(nuevo?"nuevo":(res.getString("PESO_ENVASE_PRIMARIO").equals(res.getString("PESO_ENVASE_PRIMARIOVersion"))?"":"modificado"))+"'><td class='especificacion'>Peso teorico</td><td>&nbsp;"+res.getString("PESO_ENVASE_PRIMARIO")+"</td><td>&nbsp;"+res.getString("PESO_ENVASE_PRIMARIOVersion")+"</td></tr>"+
                                        "<tr class='"+(nuevo?"nuevo":(res.getDouble("TOLERANCIA_VOLUMEN_FABRICAR")!=res.getDouble("TOLERANCIA_VOLUMEN_FABRICARVersion")?"modificado":""))+"'><td class='especificacion'>Tolerancia Volumen a Fabricar</td><td>"+res.getDouble("TOLERANCIA_VOLUMEN_FABRICAR")+"</td><td>"+res.getDouble("TOLERANCIA_VOLUMEN_FABRICARVersion")+"</td></tr>"+
                                        "<tr class='"+(nuevo?"nuevo":(res.getString("NOMBRE_TAMANIO_CAPSULA_PRODUCCION").equals(res.getString("NOMBRE_TAMANIO_CAPSULA_PRODUCCIONVersion"))?"":"modificado"))+"'><td class='especificacion'>Tamaño Capsula</td><td>&nbsp;"+res.getString("NOMBRE_TAMANIO_CAPSULA_PRODUCCION")+"</td><td>&nbsp;"+res.getString("NOMBRE_TAMANIO_CAPSULA_PRODUCCIONVersion")+"</td></tr>"+
                                        "<tr class='"+(nuevo?"nuevo":(res.getString("volumen").equals(res.getString("volumenVersion"))?"":"modificado"))+"'><td class='especificacion'>Volumen Envase Primario</td><td>&nbsp;"+res.getString("volumen")+"</td><td>&nbsp;"+res.getString("volumenVersion")+"</td></tr>"+
                                        "<tr class='"+(nuevo?"nuevo":(res.getString("NOMBRE_ESTADO_COMPPROD").equals(res.getString("NOMBRE_ESTADO_COMPPRODVersion"))?"":"modificado"))+"'><td class='especificacion'>Estado</td><td>&nbsp;"+res.getString("NOMBRE_ESTADO_COMPPROD")+"</td><td>"+res.getString("NOMBRE_ESTADO_COMPPRODVersion")+"</td></tr>";
                      }
                        int codVersionActiva=0;
                        consulta="select cpv.COD_VERSION from COMPONENTES_PROD_VERSION cpv where cpv.COD_ESTADO_VERSION=2 and cpv.COD_COMPPROD='"+registroControlCambios.getComponentesProd().getCodCompprod()+"'";
                        res=st.executeQuery(consulta);
                        if(res.next())codVersionActiva=res.getInt("COD_VERSION");
                        innerHTML+="</table><table class='tablaComparacion' cellpadding='0' cellspacing='0'>" +
                                    "<thead><tr><td colspan='11'>Concentracion</td></tr>" +
                                    "<tr><td rowspan=2>Material</td><td colspan='2'>Cantidad</td><td colspan=2>Unidad Medida</td><td colspan=2>Material Equivalencia</td>" +
                                    "<td colspan=2>Cantidad Equivalencia</td><td colspan=2>Unidad Medidad<br>Equivalencia</td></tr>" +
                                    "<tr><td>Antes</td><td>Despues</td><td>Antes</td><td>Despues</td><td>Antes</td><td>Despues</td><td>Antes</td><td>Despues</td><td>Antes</td><td>Despues</td></tr></thead>";
                        //diferencias de concentración
                        consulta="select m.NOMBRE_MATERIAL,"+
                                 " cpc.COD_VERSION,cpc.CANTIDAD,isnull(um.ABREVIATURA,'') as ABREVIATURA,isnull(cpc.NOMBRE_MATERIAL_EQUIVALENCIA,'') as NOMBRE_MATERIAL_EQUIVALENCIA,cpc.CANTIDAD_EQUIVALENCIA,isnull(ume.ABREVIATURA,'') as ABREVIATURAE,"+
                                 " cpc1.COD_VERSION as COD_VERSIONVersion,cpc1.CANTIDAD as CANTIDADVersion,isnull(um1.ABREVIATURA,'') as ABREVIATURAVersion,isnull(cpc1.NOMBRE_MATERIAL_EQUIVALENCIA,'') as NOMBRE_MATERIAL_EQUIVALENCIAVersion,cpc1.CANTIDAD_EQUIVALENCIA  as CANTIDAD_EQUIVALENCIAVersion,isnull(ume1.ABREVIATURA,'') as ABREVIATURAEVersion"+
                                 " from COMPONENTES_PROD_CONCENTRACION cpc full outer join COMPONENTES_PROD_CONCENTRACION cpc1"+
                                 " on cpc.COD_MATERIAL=cpc1.COD_MATERIAL"+
                                 " and cpc.COD_VERSION='"+codVersionActiva+"' and cpc1.COD_VERSION='"+registroControlCambios.getComponentesProd().getCodVersion()+"'"+
                                 " left outer join materiales m on m.COD_MATERIAL=isnull(cpc.COD_MATERIAL,cpc1.COD_MATERIAL)"+
                                 " left outer join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=cpc.COD_UNIDAD_MEDIDA"+
                                 " left outer join UNIDADES_MEDIDA um1 on um1.COD_UNIDAD_MEDIDA=cpc1.COD_UNIDAD_MEDIDA"+
                                 " left outer join UNIDADES_MEDIDA ume on ume.COD_UNIDAD_MEDIDA=cpc.COD_UNIDAD_MEDIDA_EQUIVALENCIA"+
                                 " left outer join UNIDADES_MEDIDA ume1 on ume1.COD_UNIDAD_MEDIDA=cpc1.COD_UNIDAD_MEDIDA_EQUIVALENCIA"+
                                 " where (cpc.COD_VERSION='"+codVersionActiva+"'" +
                                 " or cpc1.COD_VERSION='"+registroControlCambios.getComponentesProd().getCodVersion()+"')"+
                                 " order by m.NOMBRE_MATERIAL";
                        System.out.println("consulta diferencias concentracion "+consulta);
                        res=st.executeQuery(consulta);
                        while(res.next())
                        {
                            innerHTML+="<tr class='"+(res.getInt("COD_VERSION")==0?"nuevo":(res.getInt("COD_VERSIONVersion")==0?"eliminado":""))+"'>" +
                                        "<td>"+res.getString("NOMBRE_MATERIAL")+"</td>"+
                                        "<td class='"+((res.getInt("COD_VERSION")!=0&&res.getInt("COD_VERSIONVersion")!=0)?(res.getDouble("CANTIDAD")==res.getDouble("CANTIDADVersion")?"":"modificado"):"")+"' >&nbsp;"+res.getDouble("CANTIDAD")+"</td>" +
                                        "<td class='"+((res.getInt("COD_VERSION")!=0&&res.getInt("COD_VERSIONVersion")!=0)?(res.getDouble("CANTIDAD")==res.getDouble("CANTIDADVersion")?"":"modificado"):"")+"' >&nbsp;"+res.getDouble("CANTIDADVersion")+"</td>" +
                                        "<td class='"+((res.getInt("COD_VERSION")!=0&&res.getInt("COD_VERSIONVersion")!=0)?(res.getString("ABREVIATURA").equals(res.getString("ABREVIATURAVersion"))?"":"modificado"):"")+"' >&nbsp;"+res.getString("ABREVIATURA")+"</td>" +
                                        "<td class='"+((res.getInt("COD_VERSION")!=0&&res.getInt("COD_VERSIONVersion")!=0)?(res.getString("ABREVIATURA").equals(res.getString("ABREVIATURAVersion"))?"":"modificado"):"")+"' >&nbsp;"+res.getString("ABREVIATURAVersion")+"</td>" +
                                        "<td class='"+((res.getInt("COD_VERSION")!=0&&res.getInt("COD_VERSIONVersion")!=0)?(res.getString("NOMBRE_MATERIAL_EQUIVALENCIA").equals(res.getString("NOMBRE_MATERIAL_EQUIVALENCIAVersion"))?"":"modificado"):"")+"' >&nbsp;"+res.getString("NOMBRE_MATERIAL_EQUIVALENCIA")+"</td>" +
                                        "<td class='"+((res.getInt("COD_VERSION")!=0&&res.getInt("COD_VERSIONVersion")!=0)?(res.getString("NOMBRE_MATERIAL_EQUIVALENCIA").equals(res.getString("NOMBRE_MATERIAL_EQUIVALENCIAVersion"))?"":"modificado"):"")+"' >&nbsp;"+res.getString("NOMBRE_MATERIAL_EQUIVALENCIAVersion")+"</td>" +
                                        "<td class='"+((res.getInt("COD_VERSION")!=0&&res.getInt("COD_VERSIONVersion")!=0)?(res.getDouble("CANTIDAD")==res.getDouble("CANTIDADVersion")?"":"modificado"):"")+"' >&nbsp;"+res.getDouble("CANTIDAD_EQUIVALENCIA")+"</td>" +
                                        "<td class='"+((res.getInt("COD_VERSION")!=0&&res.getInt("COD_VERSIONVersion")!=0)?(res.getDouble("CANTIDAD")==res.getDouble("CANTIDADVersion")?"":"modificado"):"")+"' >&nbsp;"+res.getDouble("CANTIDAD_EQUIVALENCIAVersion")+"</td>" +
                                        "<td class='"+((res.getInt("COD_VERSION")!=0&&res.getInt("COD_VERSIONVersion")!=0)?(res.getString("ABREVIATURAE").equals(res.getString("ABREVIATURAEVersion"))?"":"modificado"):"")+"' >&nbsp;"+res.getString("ABREVIATURAE")+"</td>" +
                                        "<td class='"+((res.getInt("COD_VERSION")!=0&&res.getInt("COD_VERSIONVersion")!=0)?(res.getString("ABREVIATURAE").equals(res.getString("ABREVIATURAEVersion"))?"":"modificado"):"")+"' >&nbsp;"+res.getString("ABREVIATURAEVersion")+"</td>" +

                                        "</tr>";
                        }
                        innerHTML+="</table><table class='tablaComparacion' cellpadding='0' cellspacing='0'>" +
                                    "<thead><tr><td colspan='8'>Presentacion Primaria</td></tr>" +
                                    "<tr><td colspan=2>Envase Primario</td><td colspan=2>Cantidad</td><td colspan=2>Tipo Programa Producción</td><td colspan=2>Estado</td></tr>" +
                                    "<tr><td>Antes</td><td>Despues</td><td>Antes</td><td>Despues</td><td>Antes</td><td>Despues</td><td>Antes</td><td>Despues</td></tr></thead>";
                        consulta="select isnull(ep.nombre_envaseprim,'') as nombre_envaseprim,isnull(ep1.nombre_envaseprim,'') as nombre_envaseprimVersion,"+
                                 " isnull(tpp.NOMBRE_TIPO_PROGRAMA_PROD,'') as NOMBRE_TIPO_PROGRAMA_PROD,isnull(tpp1.NOMBRE_TIPO_PROGRAMA_PROD,'') as NOMBRE_TIPO_PROGRAMA_PRODVersion" +
                                 " ,isnull(pp.CANTIDAD,0) as CANTIDAD,isnull(ppv.CANTIDAD,0) as CANTIDADVersion"+
                                 " ,isnull(tpp.NOMBRE_TIPO_PROGRAMA_PROD,'') as NOMBRE_TIPO_PROGRAMA_PROD"+
                                 " ,isnull(tpp1.NOMBRE_TIPO_PROGRAMA_PROD,'') as NOMBRE_TIPO_PROGRAMA_PRODVersion" +
                                 " ,isnull(er.NOMBRE_ESTADO_REGISTRO,'') as NOMBRE_ESTADO_REGISTRO"+
                                 " ,isnull(er1.NOMBRE_ESTADO_REGISTRO,'') as NOMBRE_ESTADO_REGISTROVersion" +
                                 " ,isnull(pp.COD_PRESENTACION_PRIMARIA,0) as codPresentacionPrimOfi" +
                                 " ,isnull(ppv.COD_PRESENTACION_PRIMARIA,0) as codPresentacionPrimVer"+
                                 " from PRESENTACIONES_PRIMARIAS pp full outer join PRESENTACIONES_PRIMARIAS_VERSION ppv"+
                                 " on pp.COD_PRESENTACION_PRIMARIA=ppv.COD_PRESENTACION_PRIMARIA" +
                                 " and pp.COD_COMPPROD='"+registroControlCambios.getComponentesProd().getCodCompprod()+"'" +
                                 " and ppv.COD_VERSION='"+registroControlCambios.getComponentesProd().getCodVersion()+"'"+
                                 " left outer join ENVASES_PRIMARIOS ep on ep.cod_envaseprim=pp.COD_ENVASEPRIM"+
                                 " left outer join ENVASES_PRIMARIOS ep1 on ep1.cod_envaseprim=ppv.COD_ENVASEPRIM"+
                                 " left outer join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD"+
                                 " left outer join TIPOS_PROGRAMA_PRODUCCION tpp1 on tpp1.COD_TIPO_PROGRAMA_PROD=ppv.COD_TIPO_PROGRAMA_PROD" +
                                 " left outer join ESTADOS_REFERENCIALES er on er.COD_ESTADO_REGISTRO=pp.COD_ESTADO_REGISTRO"+
                                 " left outer join ESTADOS_REFERENCIALES er1 on er1.COD_ESTADO_REGISTRO=ppv.COD_ESTADO_REGISTRO"+
                                 " where ( pp.COD_COMPPROD='"+registroControlCambios.getComponentesProd().getCodCompprod()+"' OR" +
                                 " ( ppv.COD_COMPPROD = '"+registroControlCambios.getComponentesProd().getCodCompprod()+"'" +
                                 " and ppv.COD_VERSION = '"+registroControlCambios.getComponentesProd().getCodVersion()+"'))";
                        System.out.println("consulta diferencias pres prim "+consulta);
                        res=st.executeQuery(consulta);

                        while(res.next())
                        {
                            innerHTML+="<tr class='"+(res.getInt("codPresentacionPrimOfi")==0?"nuevo":(res.getInt("codPresentacionPrimVer")==0?"eliminado":""))+"'>" +
                                        "<td class='"+((res.getInt("codPresentacionPrimOfi")!=0&&res.getInt("codPresentacionPrimVer")!=0)?(res.getString("nombre_envaseprim").equals(res.getString("nombre_envaseprimVersion"))?"":"modificado"):"")+"' >&nbsp;"+res.getString("nombre_envaseprim")+"</td>" +
                                        "<td class='"+((res.getInt("codPresentacionPrimOfi")!=0&&res.getInt("codPresentacionPrimVer")!=0)?(res.getString("nombre_envaseprim").equals(res.getString("nombre_envaseprimVersion"))?"":"modificado"):"")+"' >&nbsp;"+res.getString("nombre_envaseprimVersion")+"</td>" +
                                        "<td class='"+((res.getInt("codPresentacionPrimOfi")!=0&&res.getInt("codPresentacionPrimVer")!=0)?(res.getInt("CANTIDAD")!=res.getInt("CANTIDADVersion")?"modificado":""):"")+"'>&nbsp;"+(res.getInt("CANTIDAD")>0?res.getInt("CANTIDAD"):"")+"</td>" +
                                        "<td class='"+((res.getInt("codPresentacionPrimOfi")!=0&&res.getInt("codPresentacionPrimVer")!=0)?(res.getInt("CANTIDAD")!=res.getInt("CANTIDADVersion")?"modificado":""):"")+"'>&nbsp;"+(res.getInt("CANTIDADVersion")>0?res.getInt("CANTIDADVersion"):"")+"</td>" +
                                        "<td class='"+((res.getInt("codPresentacionPrimOfi")!=0&&res.getInt("codPresentacionPrimVer")!=0)?(res.getString("NOMBRE_TIPO_PROGRAMA_PROD").equals(res.getString("NOMBRE_TIPO_PROGRAMA_PRODVersion"))?"":"modificado"):"")+"' >&nbsp;"+res.getString("NOMBRE_TIPO_PROGRAMA_PROD")+"</td>" +
                                        "<td class='"+((res.getInt("codPresentacionPrimOfi")!=0&&res.getInt("codPresentacionPrimVer")!=0)?(res.getString("NOMBRE_TIPO_PROGRAMA_PROD").equals(res.getString("NOMBRE_TIPO_PROGRAMA_PRODVersion"))?"":"modificado"):"")+"' >&nbsp;"+res.getString("NOMBRE_TIPO_PROGRAMA_PRODVersion")+"</td>" +
                                        "<td class='"+((res.getInt("codPresentacionPrimOfi")!=0&&res.getInt("codPresentacionPrimVer")!=0)?(res.getString("NOMBRE_ESTADO_REGISTRO").equals(res.getString("NOMBRE_ESTADO_REGISTROVersion"))?"":"modificado"):"")+"' >&nbsp;"+res.getString("NOMBRE_ESTADO_REGISTRO")+"</td>" +
                                        "<td class='"+((res.getInt("codPresentacionPrimOfi")!=0&&res.getInt("codPresentacionPrimVer")!=0)?(res.getString("NOMBRE_ESTADO_REGISTRO").equals(res.getString("NOMBRE_ESTADO_REGISTROVersion"))?"":"modificado"):"")+"'>&nbsp;"+res.getString("NOMBRE_ESTADO_REGISTROVersion")+"</td>" +
                                        "</tr>";
                        }
                        innerHTML+="</table><table class='tablaComparacion' cellpadding='0' cellspacing='0'>" +
                                    "<thead><tr><td colspan='8'>Presentaciones Secundarias</td></tr>" +
                                    "<tr><td colspan=2>Presentación Secundaria</td><td colspan=2>Cantidad</td><td colspan=2>Tipo Programa Producción</td><td colspan=2>Estado</td></tr>" +
                                    "<tr><td>Antes</td><td>Despues</td><td>Antes</td><td>Despues</td><td>Antes</td><td>Despues</td><td>Antes</td><td>Despues</td></tr></thead>";
                        consulta="select cpp.COD_TIPO_PROGRAMA_PROD as codVersionOficial,isnull(cpv.COD_VERSION,0) as codVersion,isnull(tpp.NOMBRE_TIPO_PROGRAMA_PROD,'') as NOMBRE_TIPO_PROGRAMA_PROD"+
                                 " ,isnull(tpp1.NOMBRE_TIPO_PROGRAMA_PROD,'') as NOMBRE_TIPO_PROGRAMA_PRODVersion" +
                                 " ,isnull(pp.NOMBRE_PRODUCTO_PRESENTACION,'') as NOMBRE_PRODUCTO_PRESENTACION"+
                                 " ,isnull(pp1.NOMBRE_PRODUCTO_PRESENTACION,'') as NOMBRE_PRODUCTO_PRESENTACIONVersion"+
                                 " ,isnull(er.NOMBRE_ESTADO_REGISTRO,'') as NOMBRE_ESTADO_REGISTRO"+
                                 " ,isnull(er1.NOMBRE_ESTADO_REGISTRO,'') as NOMBRE_ESTADO_REGISTROVersion"+
                                 " ,cpp.CANT_COMPPROD,cpv.CANT_COMPPROD as CANT_COMPPRODVersion"+
                                 " from COMPONENTES_PRESPROD cpp full outer join COMPONENTES_PRESPROD_VERSION cpv on"+
                                 " cpp.COD_PRESENTACION=cpv.COD_PRESENTACION and cpp.COD_COMPPROD=cpv.COD_COMPPROD"+
                                 " and cpp.COD_TIPO_PROGRAMA_PROD=cpv.COD_TIPO_PROGRAMA_PROD"+
                                 " and cpp.COD_COMPPROD='"+registroControlCambios.getComponentesProd().getCodCompprod()+"'" +
                                 " and cpv.COD_VERSION='"+registroControlCambios.getComponentesProd().getCodVersion()+"'"+
                                 " left outer join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=cpp.COD_TIPO_PROGRAMA_PROD"+
                                 " left outer join TIPOS_PROGRAMA_PRODUCCION tpp1 on tpp1.COD_TIPO_PROGRAMA_PROD=cpv.COD_TIPO_PROGRAMA_PROD"+
                                 " left outer join PRESENTACIONES_PRODUCTO pp on pp.cod_presentacion=cpp.COD_PRESENTACION"+
                                 " left outer join PRESENTACIONES_PRODUCTO pp1 on pp1.cod_presentacion=cpv.COD_PRESENTACION"+
                                 " left outer join ESTADOS_REFERENCIALES er on er.COD_ESTADO_REGISTRO=cpp.COD_ESTADO_REGISTRO"+
                                 " left outer join ESTADOS_REFERENCIALES er1 on er1.COD_ESTADO_REGISTRO=cpv.COD_ESTADO_REGISTRO"+
                                 " where(cpp.COD_COMPPROD='"+registroControlCambios.getComponentesProd().getCodCompprod()+"' or"+
                                 " (cpv.COD_COMPPROD='"+registroControlCambios.getComponentesProd().getCodCompprod()+"'" +
                                 " and cpv.COD_VERSION='"+registroControlCambios.getComponentesProd().getCodVersion()+"'))";
                        System.out.println("consulta cargar diferencias presnetacione secun "+consulta);
                        res=st.executeQuery(consulta);

                        while(res.next())
                        {
                            innerHTML+="<tr class='"+(res.getInt("codVersionOficial")==0?"nuevo":(res.getInt("codVersion")==0?"eliminado":""))+"'>" +
                                        "<td class='"+(res.getInt("codVersion")!=0&&res.getInt("codVersionOficial")!=0?(res.getString("NOMBRE_PRODUCTO_PRESENTACION").equals(res.getString("NOMBRE_PRODUCTO_PRESENTACIONVersion"))?"":"modificado"):"")+"' >&nbsp;"+res.getString("NOMBRE_PRODUCTO_PRESENTACION")+"</td>" +
                                        "<td class='"+(res.getInt("codVersion")!=0&&res.getInt("codVersionOficial")!=0?(res.getString("NOMBRE_PRODUCTO_PRESENTACION").equals(res.getString("NOMBRE_PRODUCTO_PRESENTACIONVersion"))?"":"modificado"):"")+"' >&nbsp;"+res.getString("NOMBRE_PRODUCTO_PRESENTACIONVersion")+"</td>" +
                                        "<td class='"+(res.getInt("codVersion")!=0&&res.getInt("codVersionOficial")!=0?(res.getInt("CANT_COMPPROD")!=res.getInt("CANT_COMPPRODVersion")?"modificado":""):"")+"' >&nbsp;"+res.getInt("CANT_COMPPROD")+"</td>" +
                                        "<td class='"+(res.getInt("codVersion")!=0&&res.getInt("codVersionOficial")!=0?(res.getInt("CANT_COMPPROD")!=res.getInt("CANT_COMPPRODVersion")?"modificado":""):"")+"' >&nbsp;"+res.getInt("CANT_COMPPRODVersion")+"</td>" +
                                        "<td class='"+(res.getInt("codVersion")!=0&&res.getInt("codVersionOficial")!=0?(res.getString("NOMBRE_TIPO_PROGRAMA_PROD").equals(res.getString("NOMBRE_TIPO_PROGRAMA_PRODVersion"))?"":"modificado"):"")+"' >&nbsp;"+res.getString("NOMBRE_TIPO_PROGRAMA_PROD")+"</td>" +
                                        "<td class='"+(res.getInt("codVersion")!=0&&res.getInt("codVersionOficial")!=0?(res.getString("NOMBRE_TIPO_PROGRAMA_PROD").equals(res.getString("NOMBRE_TIPO_PROGRAMA_PRODVersion"))?"":"modificado"):"")+"' >&nbsp;"+res.getString("NOMBRE_TIPO_PROGRAMA_PRODVersion")+"</td>" +
                                        "<td class='"+(res.getInt("codVersion")!=0&&res.getInt("codVersionOficial")!=0?(res.getString("NOMBRE_ESTADO_REGISTRO").equals(res.getString("NOMBRE_ESTADO_REGISTROVersion"))?"":"modificado"):"")+"' >&nbsp;"+res.getString("NOMBRE_ESTADO_REGISTRO")+"</td>" +
                                        "<td class='"+(res.getInt("codVersion")!=0&&res.getInt("codVersionOficial")!=0?(res.getString("NOMBRE_ESTADO_REGISTRO").equals(res.getString("NOMBRE_ESTADO_REGISTROVersion"))?"":"modificado"):"")+"' >&nbsp;"+res.getString("NOMBRE_ESTADO_REGISTROVersion")+"</td>" +
                                        "</tr>";
                        }

                        innerHTML+="</table><table class='tablaComparacion' cellpadding='0' cellspacing='0'>" +
                                    "<thead><tr><td colspan='6'>Especificaciones Fisicas de Control de Calidad</td></tr>" +
                                    "<tr><td rowspan=2>Analisis Físico</td><td colspan=2>Especificación</td>" +
                                    "<td colspan=2>Tipo de Referencia</td><td rowspan='2'>Unidad</td></tr>" +
                                    "<tr><td>Antes</td><td>Despues</td><td>Antes</td><td>Despues</td></tr></thead>";
                        consulta="select efc.NOMBRE_ESPECIFICACION,efc.COEFICIENTE,ISNULL(efc.UNIDAD,'') AS UNIDAD,tra.NOMBRE_TIPO_RESULTADO_ANALISIS,tra.COD_TIPO_RESULTADO_ANALISIS,tra.SIMBOLO"+
                                 " ,efp.COD_ESPECIFICACION,efp.LIMITE_INFERIOR,efp.LIMITE_SUPERIOR,efp.VALOR_EXACTO,isnull(efp.DESCRIPCION,'') as DESCRIPCION,efp.COD_REFERENCIA_CC,isnull(tr.NOMBRE_REFERENCIACC,'') as NOMBRE_REFERENCIACC"+
                                 " ,efp1.COD_ESPECIFICACION as COD_ESPECIFICACIONVersion,efp1.LIMITE_INFERIOR as LIMITE_INFERIORVersion,efp1.LIMITE_SUPERIOR as LIMITE_SUPERIORVersion,efp1.VALOR_EXACTO AS VALOR_EXACTOVersion,isnull(efp1.DESCRIPCION,'') as DESCRIPCIONVersion,efp1.COD_REFERENCIA_CC,isnull(tr1.NOMBRE_REFERENCIACC,'') as NOMBRE_REFERENCIACCVersion"+
                                 " from ESPECIFICACIONES_FISICAS_PRODUCTO efp "+
                                 " full outer join ESPECIFICACIONES_FISICAS_PRODUCTO efp1 on"+
                                 " efp.COD_ESPECIFICACION=efp1.COD_ESPECIFICACION"+
                                 " and efp.COD_VERSION='"+codVersionActiva+"' and efp1.COD_VERSION='"+registroControlCambios.getComponentesProd().getCodVersion()+"'"+
                                 " left outer join ESPECIFICACIONES_FISICAS_CC efc on ("+
                                 " efc.COD_ESPECIFICACION=efp.COD_ESPECIFICACION or efp1.COD_ESPECIFICACION=efc.COD_ESPECIFICACION)"+
                                 " left outer join TIPOS_REFERENCIACC tr on tr.COD_REFERENCIACC=efp.COD_REFERENCIA_CC"+
                                 " left outer join TIPOS_REFERENCIACC tr1 on tr1.COD_REFERENCIACC=efp1.COD_REFERENCIA_CC"+
                                 " left outer join TIPOS_RESULTADOS_ANALISIS tra on tra.COD_TIPO_RESULTADO_ANALISIS=efc.COD_TIPO_RESULTADO_ANALISIS"+
                                 " where (efp.COD_VERSION='"+codVersionActiva+"' or efp1.COD_VERSION='"+registroControlCambios.getComponentesProd().getCodVersion()+"')"+
                                 " order by efc.NOMBRE_ESPECIFICACION";
                        System.out.println("consulta diferencias especificaciones fisicas "+consulta);
                        res=st.executeQuery(consulta);
                        String especificacion="";
                        String especificacionVersion="";
                        while(res.next())
                        {
                            switch(res.getInt("COD_TIPO_RESULTADO_ANALISIS"))
                            {
                                case 1:
                                {
                                    especificacion=res.getString("DESCRIPCION");
                                    especificacionVersion=res.getString("DESCRIPCIONVersion");
                                    break;
                                }
                                case 2:
                                {
                                    especificacion=res.getDouble("LIMITE_INFERIOR")+" "+res.getString("UNIDAD")+"-"+res.getDouble("LIMITE_SUPERIOR")+" "+res.getString("UNIDAD");
                                    especificacionVersion=res.getDouble("LIMITE_INFERIORVersion")+" "+res.getString("UNIDAD")+"-"+res.getDouble("LIMITE_SUPERIORVersion")+" "+res.getString("UNIDAD");
                                    break;
                                }
                                default:
                                {
                                    especificacion=res.getString("COEFICIENTE")+res.getString("SIMBOLO")+" "+res.getDouble("VALOR_EXACTO")+" "+res.getString("UNIDAD");
                                    especificacionVersion=res.getString("COEFICIENTE")+res.getString("SIMBOLO")+" "+res.getDouble("VALOR_EXACTOVersion")+" "+res.getString("UNIDAD");

                                }
                            }
                            innerHTML+="<tr class='"+(res.getInt("COD_ESPECIFICACION")==0?"nuevo":(res.getInt("COD_ESPECIFICACIONVersion")==0?"eliminado":""))+"'>" +
                                        "<td>&nbsp;"+res.getString("NOMBRE_ESPECIFICACION")+"</td>" +

                                        "<td class='"+(res.getInt("COD_ESPECIFICACION")!=0&&res.getInt("COD_ESPECIFICACIONVersion")!=0?(especificacion.equals(especificacionVersion)?"":"modificado"):"")+"' >&nbsp;"+especificacion+"</td>" +
                                        "<td class='"+(res.getInt("COD_ESPECIFICACION")!=0&&res.getInt("COD_ESPECIFICACIONVersion")!=0?(especificacion.equals(especificacionVersion)?"":"modificado"):"")+"' >&nbsp;"+especificacionVersion+"</td>" +
                                        "<td class='"+(res.getInt("COD_ESPECIFICACION")!=0&&res.getInt("COD_ESPECIFICACIONVersion")!=0?(res.getString("NOMBRE_REFERENCIACC").equals(res.getString("NOMBRE_REFERENCIACCVersion"))?"":"modificado"):"")+"' >&nbsp;"+res.getString("NOMBRE_REFERENCIACC")+"</td>" +
                                        "<td class='"+(res.getInt("COD_ESPECIFICACION")!=0&&res.getInt("COD_ESPECIFICACIONVersion")!=0?(res.getString("NOMBRE_REFERENCIACC").equals(res.getString("NOMBRE_REFERENCIACCVersion"))?"":"modificado"):"")+"' >&nbsp;"+res.getString("NOMBRE_REFERENCIACCVersion")+"</td>" +
                                        "<td>&nbsp;"+res.getString("UNIDAD")+"</td>" +
                                        "</tr>";
                        }
                        innerHTML+="</table><table class='tablaComparacion' cellpadding='0' cellspacing='0'>" +
                                    "<thead><tr><td colspan='6'>Especificaciones Quimicas de Control de Calidad</td></tr>" +
                                    "<tr><td rowspan=2>Analisis Quimico</td><td colspan=2>Especificación</td>" +
                                    "<td colspan=2>Tipo de Referencia</td><td rowspan='2'>Unidad</td></tr>" +
                                    "<tr><td>Antes</td><td>Despues</td><td>Antes</td><td>Despues</td></tr></thead>";
                        consulta="select eqc.COD_ESPECIFICACION,eqc.NOMBRE_ESPECIFICACION,eqc.COD_TIPO_RESULTADO_ANALISIS,ISNULL(eqc.COEFICIENTE, '') as COEFICIENTE,"+
                                 " ISNULL(tra.SIMBOLO, '') as SIMBOLO,ISNULL(eqc.UNIDAD, '') AS unidad"+
                                 " from ESPECIFICACIONES_QUIMICAS_CC eqc left outer join TIPOS_RESULTADOS_ANALISIS tra"+
                                 " on eqc.COD_TIPO_RESULTADO_ANALISIS=tra.COD_TIPO_RESULTADO_ANALISIS"+
                                 " where (eqc.COD_ESPECIFICACION in (select eqp.COD_ESPECIFICACION from ESPECIFICACIONES_QUIMICAS_PRODUCTO eqp where eqp.COD_VERSION='"+codVersionActiva+"')"+
                                 " or eqc.COD_ESPECIFICACION in (select eqp1.COD_ESPECIFICACION from ESPECIFICACIONES_QUIMICAS_PRODUCTO eqp1 where eqp1.COD_VERSION='"+registroControlCambios.getComponentesProd().getCodVersion()+"'))"+
                                 " order by eqc.NOMBRE_ESPECIFICACION";
                        System.out.println("consulta especificaciones quimicas "+consulta);
                        res=st.executeQuery(consulta);
                        while(res.next())
                        {
                            innerHTML+="<tr><td class='celdaQuimica' colspan='6'>"+res.getString("NOMBRE_ESPECIFICACION")+"</td></tr>";
                            consulta="select isnull(m.NOMBRE_MATERIAL,'ESPECIFICACION GENERAL') as NOMBRE_MATERIAL"+
                                     " ,eqp.COD_ESPECIFICACION,eqp.VALOR_EXACTO,eqp.LIMITE_INFERIOR,eqp.LIMITE_SUPERIOR,isnull(eqp.DESCRIPCION,'') as DESCRIPCION,isnull(tr.NOMBRE_REFERENCIACC,'') as NOMBRE_REFERENCIACC,"+
                                     " eqp1.COD_ESPECIFICACION as COD_ESPECIFICACIONVersion,eqp1.VALOR_EXACTO as VALOR_EXACTOVersion,eqp1.LIMITE_INFERIOR as LIMITE_INFERIORVersion" +
                                     ",eqp1.LIMITE_SUPERIOR as LIMITE_SUPERIORVersion,isnull(eqp1.DESCRIPCION,'') as  DESCRIPCIONVersion,isnull(tr1.NOMBRE_REFERENCIACC,'') as NOMBRE_REFERENCIACCVersion"+
                                     " from ESPECIFICACIONES_QUIMICAS_PRODUCTO eqp "+
                                     " full outer join ESPECIFICACIONES_QUIMICAS_PRODUCTO eqp1 on"+
                                     " eqp.COD_ESPECIFICACION=eqp1.COD_ESPECIFICACION"+
                                     " and eqp.COD_VERSION='"+codVersionActiva+"' and eqp1.COD_VERSION='"+registroControlCambios.getComponentesProd().getCodVersion()+"'"+
                                     " and eqp.COD_MATERIAL=eqp1.COD_MATERIAL"+
                                     " left outer join TIPOS_REFERENCIACC tr on tr.COD_REFERENCIACC=eqp.COD_REFERENCIA_CC"+
                                     " left outer join TIPOS_REFERENCIACC tr1 on tr1.COD_REFERENCIACC=eqp1.COD_REFERENCIA_CC"+
                                     " left outer join MATERIALES m on (m.COD_MATERIAL=eqp.COD_MATERIAL or m.COD_MATERIAL=eqp1.COD_MATERIAL)"+
                                     " where ((eqp.COD_VERSION='"+codVersionActiva+"' and eqp.COD_ESPECIFICACION='"+res.getInt("COD_ESPECIFICACION")+"')" +
                                     " or (eqp1.COD_VERSION='"+registroControlCambios.getComponentesProd().getCodVersion()+"'" +
                                     " and eqp1.COD_ESPECIFICACION='"+res.getInt("COD_ESPECIFICACION")+"'))"+
                                     " order by m.NOMBRE_MATERIAL";
                            System.out.println("consulta detalle especificaciones "+consulta);
                            resDetalle=stDetalle.executeQuery(consulta);
                            while(resDetalle.next())
                            {
                                switch(res.getInt("COD_TIPO_RESULTADO_ANALISIS"))
                                {
                                    case 1:
                                    {
                                        especificacion=resDetalle.getString("DESCRIPCION");
                                        especificacionVersion=resDetalle.getString("DESCRIPCIONVersion");
                                        break;
                                    }
                                    case 2:
                                    {
                                        especificacion=resDetalle.getDouble("LIMITE_INFERIOR")+" "+res.getString("UNIDAD")+"-"+resDetalle.getDouble("LIMITE_SUPERIOR")+" "+res.getString("UNIDAD");
                                        especificacionVersion=resDetalle.getDouble("LIMITE_INFERIORVersion")+" "+res.getString("UNIDAD")+"-"+resDetalle.getDouble("LIMITE_SUPERIORVersion")+" "+res.getString("UNIDAD");
                                        break;
                                    }
                                    default:
                                    {
                                        especificacion=res.getString("COEFICIENTE")+res.getString("SIMBOLO")+" "+resDetalle.getDouble("VALOR_EXACTO")+" "+res.getString("UNIDAD");
                                        especificacionVersion=res.getString("COEFICIENTE")+res.getString("SIMBOLO")+" "+resDetalle.getDouble("VALOR_EXACTOVersion")+" "+res.getString("UNIDAD");

                                    }
                                }
                                innerHTML+="<tr class='"+(resDetalle.getInt("COD_ESPECIFICACION")==0?"nuevo":(resDetalle.getInt("COD_ESPECIFICACIONVersion")==0?"eliminado":""))+"'>" +
                                        "<td>&nbsp;"+resDetalle.getString("NOMBRE_MATERIAL")+"</td>"+
                                        "<td class='"+(resDetalle.getInt("COD_ESPECIFICACION")!=0&&resDetalle.getInt("COD_ESPECIFICACIONVersion")!=0?(especificacion.equals(especificacionVersion)?"":"modificado"):"")+"' >&nbsp;"+especificacion+"</td>" +
                                        "<td class='"+(resDetalle.getInt("COD_ESPECIFICACION")!=0&&resDetalle.getInt("COD_ESPECIFICACIONVersion")!=0?(especificacion.equals(especificacionVersion)?"":"modificado"):"")+"' >&nbsp;"+especificacionVersion+"</td>"+
                                        "<td class='"+(resDetalle.getInt("COD_ESPECIFICACION")!=0&&resDetalle.getInt("COD_ESPECIFICACIONVersion")!=0?(resDetalle.getString("NOMBRE_REFERENCIACC").equals(resDetalle.getString("NOMBRE_REFERENCIACCVersion"))?"":"modificado"):"")+"' >&nbsp;"+resDetalle.getString("NOMBRE_REFERENCIACC")+"</td>" +
                                        "<td class='"+(resDetalle.getInt("COD_ESPECIFICACION")!=0&&resDetalle.getInt("COD_ESPECIFICACIONVersion")!=0?(resDetalle.getString("NOMBRE_REFERENCIACC").equals(resDetalle.getString("NOMBRE_REFERENCIACCVersion"))?"":"modificado"):"")+"' >&nbsp;"+resDetalle.getString("NOMBRE_REFERENCIACCVersion")+"</td>" +
                                        "<td>&nbsp;"+res.getString("UNIDAD")+"</td>" +
                                        "</tr>";
                            }
                        }
                        innerHTML+="</table><table class='tablaComparacion' cellpadding='0' cellspacing='0'>" +
                                    "<thead><tr><td colspan='6'>Especificaciones Microbiologicas de Control de Calidad</td></tr>" +
                                    "<tr><td rowspan=2>Analisis Microbiológico</td><td colspan=2>Especificación</td>" +
                                    "<td colspan=2>Tipo de Referencia</td><td rowspan='2'>Unidad</td></tr>" +
                                    "<tr><td>Antes</td><td>Despues</td><td>Antes</td><td>Despues</td></tr></thead>";
                        consulta="select em.NOMBRE_ESPECIFICACION,em.COEFICIENTE,ISNULL(em.UNIDAD,'') as UNIDAD,tra.COD_TIPO_RESULTADO_ANALISIS,tra.SIMBOLO,"+
                                 " emp.COD_ESPECIFICACION,emp.VALOR_EXACTO,emp.LIMITE_INFERIOR,emp.LIMITE_SUPERIOR,isnull(emp.DESCRIPCION,'') as DESCRIPCION,isnull(tr.NOMBRE_REFERENCIACC,'') as NOMBRE_REFERENCIACC,"+
                                 " emp1.COD_ESPECIFICACION as COD_ESPECIFICACIONVersion,emp1.VALOR_EXACTO as VALOR_EXACTOVersion,emp1.LIMITE_INFERIOR as LIMITE_INFERIORVersion,emp1.LIMITE_SUPERIOR as LIMITE_SUPERIORVersion,ISNULL(emp1.DESCRIPCION,'') as DESCRIPCIONVersion,isnull(tr1.NOMBRE_REFERENCIACC,'') as NOMBRE_REFERENCIACCVersion"+
                                 " from ESPECIFICACIONES_MICROBIOLOGIA_PRODUCTO emp full outer join"+
                                 " ESPECIFICACIONES_MICROBIOLOGIA_PRODUCTO emp1 on emp.COD_ESPECIFICACION=emp1.COD_ESPECIFICACION"+
                                 " and emp.COD_VERSION='"+codVersionActiva+"' and emp1.COD_VERSION='"+registroControlCambios.getComponentesProd().getCodVersion()+"'"+
                                 " left outer join ESPECIFICACIONES_MICROBIOLOGIA em on"+
                                 " (em.COD_ESPECIFICACION=emp.COD_ESPECIFICACION or em.COD_ESPECIFICACION=emp1.COD_ESPECIFICACION)"+
                                 " left outer join TIPOS_RESULTADOS_ANALISIS tra on tra.COD_TIPO_RESULTADO_ANALISIS=em.COD_TIPO_RESULTADO_ANALISIS"+
                                 " left outer join TIPOS_REFERENCIACC tr on tr.COD_REFERENCIACC=emp.COD_REFERENCIA_CC"+
                                 " left outer join TIPOS_REFERENCIACC tr1 on tr1.COD_REFERENCIACC=emp1.COD_REFERENCIA_CC"+
                                 " where (emp.COD_VERSION='"+codVersionActiva+"' or emp1.COD_VERSION='"+registroControlCambios.getComponentesProd().getCodVersion()+"')"+
                                 " order by em.NOMBRE_ESPECIFICACION";
                        System.out.println("consulta cargar especificaciones micro "+consulta);
                        res=st.executeQuery(consulta);
                        while(res.next())
                        {
                            switch(res.getInt("COD_TIPO_RESULTADO_ANALISIS"))
                            {
                                case 1:
                                {
                                    especificacion=res.getString("DESCRIPCION");
                                    especificacionVersion=res.getString("DESCRIPCIONVersion");
                                    break;
                                }
                                case 2:
                                {
                                    especificacion=res.getDouble("LIMITE_INFERIOR")+" "+res.getString("UNIDAD")+"-"+res.getDouble("LIMITE_SUPERIOR")+" "+res.getString("UNIDAD");
                                    especificacion=res.getDouble("LIMITE_INFERIORVersion")+" "+res.getString("UNIDAD")+"-"+res.getDouble("LIMITE_SUPERIORVersion")+" "+res.getString("UNIDAD");
                                    break;
                                }
                                default:
                                {
                                    especificacion=res.getString("COEFICIENTE")+res.getString("SIMBOLO")+" "+res.getDouble("VALOR_EXACTO")+" "+res.getString("UNIDAD");
                                    especificacionVersion=res.getString("COEFICIENTE")+res.getString("SIMBOLO")+" "+res.getDouble("VALOR_EXACTOVersion")+" "+res.getString("UNIDAD");

                                }
                            }
                            innerHTML+="<tr class='"+(res.getInt("COD_ESPECIFICACION")==0?"nuevo":(res.getInt("COD_ESPECIFICACIONVersion")==0?"eliminado":""))+"'>" +
                                        "<td>&nbsp;"+res.getString("NOMBRE_ESPECIFICACION")+"</td>" +

                                        "<td class='"+(res.getInt("COD_ESPECIFICACION")!=0&&res.getInt("COD_ESPECIFICACIONVersion")!=0?(especificacion.equals(especificacionVersion)?"":"modificado"):"")+"' >&nbsp;"+especificacion+"</td>" +
                                        "<td class='"+(res.getInt("COD_ESPECIFICACION")!=0&&res.getInt("COD_ESPECIFICACIONVersion")!=0?(especificacion.equals(especificacionVersion)?"":"modificado"):"")+"' >&nbsp;"+especificacionVersion+"</td>" +
                                        "<td class='"+(res.getInt("COD_ESPECIFICACION")!=0&&res.getInt("COD_ESPECIFICACIONVersion")!=0?(res.getString("NOMBRE_REFERENCIACC").equals(res.getString("NOMBRE_REFERENCIACCVersion"))?"":"modificado"):"")+"' >&nbsp;"+res.getString("NOMBRE_REFERENCIACC")+"</td>" +
                                        "<td class='"+(res.getInt("COD_ESPECIFICACION")!=0&&res.getInt("COD_ESPECIFICACIONVersion")!=0?(res.getString("NOMBRE_REFERENCIACC").equals(res.getString("NOMBRE_REFERENCIACCVersion"))?"":"modificado"):"")+"' >&nbsp;"+res.getString("NOMBRE_REFERENCIACCVersion")+"</td>" +
                                        "<td>&nbsp;"+res.getString("UNIDAD")+"</td>" +
                                        "</tr>";
                        }
                       innerHTML+="</table>";
                       innerHTML+="<table class='tablaComparacion'  cellpadding='0' cellspacing='0' id='tablaMP' style='margin-top:1em;'> "+
                                    " <thead><tr  align='center'><td  colspan='8'><span class='outputText2'>Diferencias MP</span></td>"+
                                    " </tr><tr  align='center'><td rowspan='2' ><span class='outputText2' >Material</span></td>"+
                                    "<td colspan='2' ><span class='outputText2'>Cantidad</span></td>" +
                                    "<td rowspan='2' ><span class='outputText2'>Unidad Medida</span></td>"+
                                    "<td colspan='2'><span class='outputText2'>Nro Fracciones</span></td>"+
                                    "<td colspan='2' ><span class='outputText2'>Fracciones</span></td></tr><tr>" +
                                    "<td><span class='outputText2'>Antes</span></td><td><span class='outputText2'>Despues</span></td>" +
                                    "<td><span class='outputText2'>Antes</span></td><td><span class='outputText2'>Despues</span></td>" +
                                    "<td><span class='outputText2'>Antes</span></td><td><span class='outputText2'>Despues</span></td> </tr></thead><tbody>";
                        consulta="select c.COD_FORMULA_MAESTRA,c.COD_VERSION from FORMULA_MAESTRA_VERSION c where c.COD_COMPPROD_VERSION='"+registroControlCambios.getComponentesProd().getCodVersion()+"'";
                        res=st.executeQuery(consulta);
                        if(res.next())
                        {
                            registroControlCambios.getFormulaMaestraVersion().setCodFormulaMaestra(res.getString("COD_FORMULA_MAESTRA"));
                            registroControlCambios.getFormulaMaestraVersion().setCodVersion(res.getInt("COD_VERSION"));
                        }

                        consulta="select m.NOMBRE_MATERIAL,m.COD_MATERIAL,fmd.CANTIDAD,fmdv.CANTIDAD as cantidad2,"+
                                 " fmd.NRO_PREPARACIONES,fmdv.NRO_PREPARACIONES as NRO_PREPARACIONES2,um.NOMBRE_UNIDAD_MEDIDA,fracciones.cantidadIni,fracciones.cantidadFin"+
                                 " from  FORMULA_MAESTRA_DETALLE_MP fmd full outer join FORMULA_MAESTRA_DETALLE_MP_VERSION fmdv"+
                                 " on fmd.COD_MATERIAL=fmdv.COD_MATERIAL and fmdv.COD_VERSION='"+registroControlCambios.getFormulaMaestraVersion().getCodVersion()+"'" +
                                 " and fmd.COD_FORMULA_MAESTRA=fmdv.COD_FORMULA_MAESTRA"+
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
                                 " where ((fmd.COD_FORMULA_MAESTRA='"+registroControlCambios.getFormulaMaestraVersion().getCodFormulaMaestra()+"' and fmdv.COD_VERSION is null) OR"+
                                 " (fmd.COD_FORMULA_MAESTRA is null and fmdv.COD_FORMULA_MAESTRA='"+registroControlCambios.getFormulaMaestraVersion().getCodFormulaMaestra()+"'" +
                                 " and fmdv.COD_VERSION='"+registroControlCambios.getFormulaMaestraVersion().getCodVersion()+"')"+
                                 " OR( fmd.COD_FORMULA_MAESTRA=fmdv.COD_FORMULA_MAESTRA and fmdv.COD_VERSION='"+registroControlCambios.getFormulaMaestraVersion().getCodVersion()+"'" +
                                 " and fmd.COD_FORMULA_MAESTRA='"+registroControlCambios.getFormulaMaestraVersion().getCodFormulaMaestra()+"'))"+
                                 " order by m.NOMBRE_MATERIAL";
                                System.out.println("consulta version propuesta mp "+consulta);
                                res=st.executeQuery(consulta);
                                int codMaterialCabecera=0;
                                String fracciones="";
                                int contFracciones=0;
                                while(res.next())
                                {
                                    if(codMaterialCabecera!=res.getInt("COD_MATERIAL"))
                                    {
                                        if(codMaterialCabecera>0)
                                        {
                                            res.previous();
                                            innerHTML+="<tr>" +
                                                    "<td class='"+(res.getString("cantidad")==null?"nuevo":(res.getString("cantidad2")==null?"eliminado":""))+"' rowspan='"+contFracciones+"' ><span class='outputText2'>"+res.getString("NOMBRE_MATERIAL")+"</span></td>" +
                                                    "<td class='"+(res.getString("cantidad")==null?"nuevo":(res.getString("cantidad2")==null?"eliminado":(res.getDouble("cantidad2")!=res.getInt("CANTIDAD")?"modificado":"")))+"' rowspan='"+contFracciones+"' ><span class='outputText2'>"+formato.format(res.getDouble("CANTIDAD"))+"</span></td>" +
                                                    "<td class='"+(res.getString("cantidad")==null?"nuevo":(res.getString("cantidad2")==null?"eliminado":(res.getDouble("cantidad2")!=res.getInt("CANTIDAD")?"modificado":"")))+"' rowspan='"+contFracciones+"' ><span class='outputText2'>"+formato.format(res.getDouble("CANTIDAD2"))+"</span></td>" +
                                                    "<td class='"+(res.getString("cantidad")==null?"nuevo":(res.getString("cantidad2")==null?"eliminado":""))+"' rowspan='"+contFracciones+"' ><span class='outputText2'>"+res.getString("NOMBRE_UNIDAD_MEDIDA")+"</span></td>" +
                                                    "<td class='"+(res.getString("cantidad")==null?"nuevo":(res.getString("cantidad2")==null?"eliminado":(res.getDouble("NRO_PREPARACIONES")!=res.getInt("NRO_PREPARACIONES2")?"modificado":"")))+"' rowspan='"+contFracciones+"' ><span class='outputText2'>"+res.getInt("NRO_PREPARACIONES")+"</span></td>" +
                                                    "<td class='"+(res.getString("cantidad")==null?"nuevo":(res.getString("cantidad2")==null?"eliminado":(res.getDouble("NRO_PREPARACIONES")!=res.getInt("NRO_PREPARACIONES2")?"modificado":"")))+"' rowspan='"+contFracciones+"' ><span class='outputText2'>"+res.getInt("NRO_PREPARACIONES2")+"</span></td>" +
                                                    fracciones;
                                            res.next();

                                        }
                                        codMaterialCabecera=res.getInt("COD_MATERIAL");
                                        contFracciones=0;
                                        fracciones="";
                                    }
                                    contFracciones++;
                                    fracciones+=(contFracciones==1?"":"<tr>")+"<td class="+(res.getString("cantidadIni")==null?"nuevo":(res.getString("cantidadFin")==null?"eliminado":(res.getDouble("cantidadIni")!=res.getDouble("cantidadFin")?"modificado":"")))+" ><span class='outputText2'>"+formato.format(res.getDouble("cantidadIni"))+"</span></td>" +
                                                "<td class="+(res.getString("cantidadIni")==null?"nuevo":(res.getString("cantidadFin")==null?"eliminado":(res.getDouble("cantidadIni")!=res.getDouble("cantidadFin")?"modificado":"")))+" ><span class='outputText2'>"+formato.format(res.getDouble("cantidadFin"))+"</span></td></tr>";
                                 }
                                 if(codMaterialCabecera>0)
                                 {
                                     res.last();
                                     innerHTML+="<tr>" +
                                                    "<td class='"+(res.getString("cantidad")==null?"nuevo":(res.getString("cantidad2")==null?"eliminado":""))+"' rowspan='"+contFracciones+"' ><span class='outputText2'>"+res.getString("NOMBRE_MATERIAL")+"</span></td>" +
                                                    "<td class='"+(res.getString("cantidad")==null?"nuevo":(res.getString("cantidad2")==null?"eliminado":(res.getDouble("cantidad2")!=res.getInt("CANTIDAD")?"modificado":"")))+"' rowspan='"+contFracciones+"' ><span class='outputText2'>"+formato.format(res.getDouble("CANTIDAD"))+"</span></td>" +
                                                    "<td class='"+(res.getString("cantidad")==null?"nuevo":(res.getString("cantidad2")==null?"eliminado":(res.getDouble("cantidad2")!=res.getInt("CANTIDAD")?"modificado":"")))+"' rowspan='"+contFracciones+"' ><span class='outputText2'>"+formato.format(res.getDouble("CANTIDAD2"))+"</span></td>" +
                                                    "<td class='"+(res.getString("cantidad")==null?"nuevo":(res.getString("cantidad2")==null?"eliminado":""))+"' rowspan='"+contFracciones+"' ><span class='outputText2'>"+res.getString("NOMBRE_UNIDAD_MEDIDA")+"</span></td>" +
                                                    "<td class='"+(res.getString("cantidad")==null?"nuevo":(res.getString("cantidad2")==null?"eliminado":(res.getDouble("NRO_PREPARACIONES")!=res.getInt("NRO_PREPARACIONES2")?"modificado":"")))+"' rowspan='"+contFracciones+"' ><span class='outputText2'>"+res.getInt("NRO_PREPARACIONES")+"</span></td>" +
                                                    "<td class='"+(res.getString("cantidad")==null?"nuevo":(res.getString("cantidad2")==null?"eliminado":(res.getDouble("NRO_PREPARACIONES")!=res.getInt("NRO_PREPARACIONES2")?"modificado":"")))+"' rowspan='"+contFracciones+"' ><span class='outputText2'>"+res.getInt("NRO_PREPARACIONES2")+"</span></td>" +
                                                    fracciones;
                                 }
                                 innerHTML+="</tbody></table><table class='tablaComparacion'  cellpadding='0' cellspacing='0' style='margin-top:1em;' id='tablaEP'>"+
                                        " <thead><tr  align='center'><td  colspan='8'><span class='outputText2'>Diferencias EP</span></td>"+
                                        " </tr></thead><tbody>";
                                 consulta="select ep.nombre_envaseprim,ep.cod_envaseprim,p.CANTIDAD,"+
                                          " p.cod_presentacion_primaria,tpp.COD_TIPO_PROGRAMA_PROD,tpp.NOMBRE_TIPO_PROGRAMA_PROD,"+
                                          " er.COD_ESTADO_REGISTRO,er.NOMBRE_ESTADO_REGISTRO"+
                                          " from PRESENTACIONES_PRIMARIAS_VERSION p inner join ENVASES_PRIMARIOS ep on"+
                                          " p.COD_ENVASEPRIM=ep.cod_envaseprim"+
                                          " inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=p.COD_TIPO_PROGRAMA_PROD"+
                                          " inner join ESTADOS_REFERENCIALES er on er.COD_ESTADO_REGISTRO=p.COD_ESTADO_REGISTRO"+
                                          " where p.COD_VERSION='"+registroControlCambios.getComponentesProd().getCodVersion()+"'" +
                                          " and p.COD_COMPPROD='"+registroControlCambios.getComponentesProd().getCodCompprod()+"'" +
                                          " order by tpp.NOMBRE_TIPO_PROGRAMA_PROD";
                                 System.out.println("consulta presentaciones primarias"+consulta);
                                 res=st.executeQuery(consulta);
                                 while(res.next())
                                 {
                                     innerHTML+="<tr><td class='cabecera1' colspan='8' align='center'><span class='outputText2'>" +
                                             "Tipo Prog:"+res.getString("NOMBRE_TIPO_PROGRAMA_PROD")+"<br/>Envase:"+res.getString("nombre_envaseprim")+"<br/>" +
                                             "Estado:"+res.getString("NOMBRE_ESTADO_REGISTRO")+"<br/>Cantidad:"+res.getInt("CANTIDAD")+"</span></td></tr>" +
                                             "<tr  class='cabecera1' align='center'><td rowspan='2' ><span class='outputText2' >Material</span></td>"+
                                            "<td colspan='2' ><span class='outputText2'>Cantidad</span></td>" +
                                            "<td rowspan='2' ><span class='outputText2'>Unidad Medida</span></td><tr class='cabecera1'>" +
                                            "<td><span class='outputText2'>Antes</span></td><td><span class='outputText2'>Despues</span></td></tr>";
                                     consulta="select m.NOMBRE_MATERIAL,fmde.CANTIDAD,fmdev.CANTIDAD as cantidad2,um.NOMBRE_UNIDAD_MEDIDA"+
                                             " from FORMULA_MAESTRA_DETALLE_EP fmde full outer join FORMULA_MAESTRA_DETALLE_EP_VERSION fmdev"+
                                             "  on fmde.COD_FORMULA_MAESTRA=fmdev.COD_FORMULA_MAESTRA and fmde.COD_MATERIAL=fmdev.COD_MATERIAL and fmdev.COD_VERSION="+registroControlCambios.getFormulaMaestraVersion().getCodVersion()+
                                             " and fmde.COD_PRESENTACION_PRIMARIA=fmdev.COD_PRESENTACION_PRIMARIA"+
                                             " inner join materiales m on (m.COD_MATERIAL=fmde.COD_MATERIAL or m.COD_MATERIAL=fmdev.COD_MATERIAL)"+
                                             " inner join UNIDADES_MEDIDA um on (um.COD_UNIDAD_MEDIDA=fmde.COD_UNIDAD_MEDIDA or um.COD_UNIDAD_MEDIDA=fmdev.COD_UNIDAD_MEDIDA)"+
                                             " where ((fmde.COD_FORMULA_MAESTRA='"+registroControlCambios.getFormulaMaestraVersion().getCodFormulaMaestra()+"'" +
                                             " and fmde.COD_PRESENTACION_PRIMARIA='"+res.getString("cod_presentacion_primaria")+"' and fmdev.COD_VERSION is null)"+
                                             " or(fmde.COD_FORMULA_MAESTRA is null and fmdev.COD_FORMULA_MAESTRA='"+registroControlCambios.getFormulaMaestraVersion().getCodFormulaMaestra()+"'" +
                                             " and fmdev.COD_VERSION='"+registroControlCambios.getFormulaMaestraVersion().getCodVersion()+"'"+
                                             " and fmdev.COD_PRESENTACION_PRIMARIA='"+res.getString("cod_presentacion_primaria")+"')OR"+
                                             " (fmde.COD_FORMULA_MAESTRA='"+registroControlCambios.getFormulaMaestraVersion().getCodFormulaMaestra()+"'" +
                                             " and fmde.COD_PRESENTACION_PRIMARIA='"+res.getString("cod_presentacion_primaria")+"'" +
                                             " and fmdev.COD_VERSION ='"+registroControlCambios.getFormulaMaestraVersion().getCodVersion()+"'))";
                                     System.out.println("consulta detalle ep "+consulta);
                                     resDetalle=stDetalle.executeQuery(consulta);
                                     while(resDetalle.next())
                                     {
                                          innerHTML+="<tr>" +
                                                "<td class='"+(resDetalle.getString("cantidad")==null?"nuevo":(resDetalle.getString("cantidad2")==null?"eliminado":""))+"'><span class='outputText2'>"+resDetalle.getString("NOMBRE_MATERIAL")+"</span></td>" +
                                                "<td class='"+(resDetalle.getString("cantidad")==null?"nuevo":(resDetalle.getString("cantidad2")==null?"eliminado":(resDetalle.getDouble("cantidad")!=resDetalle.getDouble("cantidad2")?"modificado":"")))+"'><span class='outputText2'>"+formato.format(resDetalle.getDouble("cantidad"))+"</span></td>" +
                                                "<td class='"+(resDetalle.getString("cantidad")==null?"nuevo":(resDetalle.getString("cantidad2")==null?"eliminado":(resDetalle.getDouble("cantidad")!=resDetalle.getDouble("cantidad2")?"modificado":"")))+"'><span class='outputText2'>"+formato.format(resDetalle.getDouble("cantidad2"))+"</span></td>" +
                                                "<td class='"+(resDetalle.getString("cantidad")==null?"nuevo":(resDetalle.getString("cantidad2")==null?"eliminado":""))+"'><span class='outputText2'>"+resDetalle.getString("NOMBRE_UNIDAD_MEDIDA")+"</span></td>" +
                                                "</tr>";
                                     }

                                 }
                            innerHTML+="</tbody></table><table class='tablaComparacion'  cellpadding='0' cellspacing='0' style='margin-top:1em;' id='tablaES'>"+
                                    " <thead><tr  align='center'><td  colspan='8'><span class='outputText2'>Diferencias ES</span></td>"+
                                    " </tr></thead><tbody>";
                             consulta="select es.NOMBRE_ENVASESEC,es.COD_ENVASESEC,pp.NOMBRE_PRODUCTO_PRESENTACION,pp.cantidad_presentacion,"+
                                     " pp.cod_presentacion,TPP.NOMBRE_TIPO_PROGRAMA_PROD,tpp.COD_TIPO_PROGRAMA_PROD"+
                                     " from COMPONENTES_PRESPROD_VERSION cpp inner join PRESENTACIONES_PRODUCTO pp on"+
                                     " cpp.COD_PRESENTACION=pp.cod_presentacion"+
                                     " inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=cpp.COD_TIPO_PROGRAMA_PROD"+
                                     " inner join ENVASES_SECUNDARIOS es on es.COD_ENVASESEC=pp.COD_ENVASESEC"+
                                     " where cpp.COD_COMPPROD='"+registroControlCambios.getComponentesProd().getCodCompprod()+"'" +
                                     " and cpp.COD_VERSION='"+registroControlCambios.getComponentesProd().getCodVersion()+"'"+
                                     " order by tpp.COD_TIPO_PROGRAMA_PROD";
                             System.out.println("consulta eS "+consulta);
                             res=st.executeQuery(consulta);
                             while(res.next())
                             {
                                 innerHTML+="<tr><td class='cabecera1' colspan='8' align='center'><span class='outputText2'>" +
                                             "Tipo Prog:"+res.getString("NOMBRE_TIPO_PROGRAMA_PROD")+"<br/>Presentacion:"+res.getString("NOMBRE_ENVASESEC")+"<br/>" +
                                             "Cantidad:"+res.getInt("cantidad_presentacion")+"</span></td></tr>" +
                                             "<tr  class='cabecera1' align='center'><td rowspan='2' ><span class='outputText2' >Material</span></td>"+
                                            "<td colspan='2' ><span class='outputText2'>Cantidad</span></td>" +
                                            "<td rowspan='2' ><span class='outputText2'>Unidad Medida</span></td><tr class='cabecera1'>" +
                                            "<td><span class='outputText2'>Antes</span></td><td><span class='outputText2'>Despues</span></td></tr>";
                                     consulta="select m.NOMBRE_MATERIAL,fmd.CANTIDAD,fmdv.CANTIDAD as cantidad2,um.NOMBRE_UNIDAD_MEDIDA,er.NOMBRE_ESTADO_REGISTRO"+
                                              " from FORMULA_MAESTRA_DETALLE_ES fmd full outer join FORMULA_MAESTRA_DETALLE_ES_VERSION fmdv"+
                                              " on fmdv.COD_FORMULA_MAESTRA=fmd.COD_FORMULA_MAESTRA and fmd.COD_MATERIAL=fmdv.COD_MATERIAL"+
                                              " and fmdv.COD_PRESENTACION_PRODUCTO=fmd.COD_PRESENTACION_PRODUCTO"+
                                              " and fmdv.COD_TIPO_PROGRAMA_PROD=fmd.COD_TIPO_PROGRAMA_PROD and fmdv.COD_VERSION='"+registroControlCambios.getFormulaMaestraVersion().getCodVersion()+"'"+
                                              " inner join materiales m on (m.COD_MATERIAL=fmd.COD_MATERIAL or m.COD_MATERIAL=fmdv.COD_MATERIAL)"+
                                              " inner join UNIDADES_MEDIDA um on (um.COD_UNIDAD_MEDIDA=fmdv.COD_UNIDAD_MEDIDA or um.COD_UNIDAD_MEDIDA=fmd.COD_UNIDAD_MEDIDA)"+
                                              " inner join ESTADOS_REFERENCIALES er on er.COD_ESTADO_REGISTRO=m.COD_ESTADO_REGISTRO"+
                                              " where ((fmd.COD_FORMULA_MAESTRA='"+registroControlCambios.getFormulaMaestraVersion().getCodFormulaMaestra()+"'" +
                                              " and fmd.COD_PRESENTACION_PRODUCTO='"+res.getInt("cod_presentacion")+"' and fmd.COD_TIPO_PROGRAMA_PROD='"+res.getInt("COD_TIPO_PROGRAMA_PROD")+"'" +
                                              " and fmdv.COD_VERSION is null) or"+
                                              " (fmdv.COD_FORMULA_MAESTRA='"+registroControlCambios.getFormulaMaestraVersion().getCodFormulaMaestra()+"'" +
                                              " and fmdv.COD_VERSION='"+registroControlCambios.getFormulaMaestraVersion().getCodVersion()+"'" +
                                              " and fmdv.COD_TIPO_PROGRAMA_PROD='"+res.getInt("COD_TIPO_PROGRAMA_PROD")+"'" +
                                              " and fmdv.COD_PRESENTACION_PRODUCTO='"+res.getInt("cod_presentacion")+"' )"+
                                              " or (fmdv.COD_FORMULA_MAESTRA='"+registroControlCambios.getFormulaMaestraVersion().getCodFormulaMaestra()+"'" +
                                              " and fmdv.COD_VERSION='"+registroControlCambios.getFormulaMaestraVersion().getCodVersion()+"'" +
                                              " and fmdv.COD_TIPO_PROGRAMA_PROD='"+res.getInt("COD_TIPO_PROGRAMA_PROD")+"' and fmdv.COD_PRESENTACION_PRODUCTO='"+res.getInt("cod_presentacion")+"'"+
                                              " and fmdv.COD_FORMULA_MAESTRA=fmd.COD_FORMULA_MAESTRA and fmd.COD_PRESENTACION_PRODUCTO=fmdv.COD_PRESENTACION_PRODUCTO"+
                                              " and fmdv.COD_TIPO_PROGRAMA_PROD=fmd.COD_TIPO_PROGRAMA_PROD))order by m.NOMBRE_MATERIAL";
                                     System.out.println("consulta detalle es "+consulta);
                                     resDetalle=stDetalle.executeQuery(consulta);
                                     while(resDetalle.next())
                                     {
                                         innerHTML+="<tr>" +
                                                "<td class='"+(resDetalle.getString("cantidad")==null?"nuevo":(resDetalle.getString("cantidad2")==null?"eliminado":""))+"'><span class='outputText2'>"+resDetalle.getString("NOMBRE_MATERIAL")+"</span></td>" +
                                                "<td class='"+(resDetalle.getString("cantidad")==null?"nuevo":(resDetalle.getString("cantidad2")==null?"eliminado":(resDetalle.getDouble("cantidad")!=resDetalle.getDouble("cantidad2")?"modificado":"")))+"'><span class='outputText2'>"+formato.format(resDetalle.getDouble("cantidad"))+"</span></td>" +
                                                "<td class='"+(resDetalle.getString("cantidad")==null?"nuevo":(resDetalle.getString("cantidad2")==null?"eliminado":(resDetalle.getDouble("cantidad")!=resDetalle.getDouble("cantidad2")?"modificado":"")))+"'><span class='outputText2'>"+formato.format(resDetalle.getDouble("cantidad2"))+"</span></td>" +
                                                "<td class='"+(resDetalle.getString("cantidad")==null?"nuevo":(resDetalle.getString("cantidad2")==null?"eliminado":""))+"'><span class='outputText2'>"+resDetalle.getString("NOMBRE_UNIDAD_MEDIDA")+"</span></td>" +
                                                "</tr>";
                                     }

                                 }
                                 innerHTML+="</tbody></table><table class='tablaComparacion'  cellpadding='0' cellspacing='0' style='margin-top:1em;' id='tablaMR'>"+
                                        " <thead><tr  align='center'><td  colspan='8'><span class='outputText2'>Diferencias MR</span></td>"+
                                        " </tr></thead><tbody>";
                                 consulta="select tmr.COD_TIPO_MATERIAL_REACTIVO,tmr.NOMBRE_TIPO_MATERIAL_REACTIVO from TIPOS_MATERIAL_REACTIVO tmr where tmr.COD_ESTADO_REGISTRO=1 order by tmr.NOMBRE_TIPO_MATERIAL_REACTIVO";
                                 res=st.executeQuery(consulta);
                                 while(res.next())
                                 {
                                     innerHTML+="<tr><td class='cabecera1' colspan='8' align='center'><span class='outputText2'>" +
                                             "Tipo Material:"+res.getString("NOMBRE_TIPO_MATERIAL_REACTIVO")+"</span></td></tr>" +
                                             "<tr  class='cabecera1' align='center'><td rowspan='2' ><span class='outputText2' >Material</span></td>"+
                                            "<td colspan='2' ><span class='outputText2'>Cantidad</span></td>" +
                                            "<td rowspan='2' ><span class='outputText2'>Estado Material</span></td>" +
                                            "<td colspan='2' ><span class='outputText2'>Estado Analisis</span></td>"+
                                            "<td rowspan='2' ><span class='outputText2'>Analisis</span></td>"+
                                            "</tr><tr class='cabecera1'>" +
                                            "<td><span class='outputText2'>Antes</span></td><td><span class='outputText2'>Despues</span></td>" +
                                            "<td><span class='outputText2'>Antes</span></td><td><span class='outputText2'>Despues</span></td></tr>";
                                      consulta="select m.NOMBRE_MATERIAL,m.COD_MATERIAL,fmd.CANTIDAD,fmdv.CANTIDAD as cantidad2,er.NOMBRE_ESTADO_REGISTRO,"+
                                               " tamr.nombre_tipo_analisis_material_reactivo,detalle.registrado,detalle.registrado2"+
                                               " from FORMULA_MAESTRA_DETALLE_MR fmd full outer join FORMULA_MAESTRA_DETALLE_MR_VERSION fmdv on "+
                                               " fmd.COD_FORMULA_MAESTRA=fmdv.COD_FORMULA_MAESTRA and fmd.COD_MATERIAL=fmdv.COD_MATERIAL"+
                                               " and fmd.COD_TIPO_MATERIAL=fmdv.COD_TIPO_MATERIAL"+
                                               " and fmdv.COD_VERSION='"+registroControlCambios.getFormulaMaestraVersion().getCodVersion()+"'"+
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
                                               " where ((fmd.COD_FORMULA_MAESTRA='"+registroControlCambios.getFormulaMaestraVersion().getCodFormulaMaestra()+"'" +
                                               " and fmd.COD_TIPO_MATERIAL='"+res.getInt("COD_TIPO_MATERIAL_REACTIVO")+"')"+
                                               " or(fmdv.COD_FORMULA_MAESTRA='"+registroControlCambios.getFormulaMaestraVersion().getCodFormulaMaestra()+"'" +
                                               " and fmdv.COD_VERSION='"+registroControlCambios.getFormulaMaestraVersion().getCodVersion()+"'" +
                                               " and fmdv.COD_TIPO_MATERIAL='"+res.getInt("COD_TIPO_MATERIAL_REACTIVO")+"' )) order by m.NOMBRE_MATERIAL,tamr.nombre_tipo_analisis_material_reactivo";
                                           System.out.println("consulta detalle mr "+consulta);
                                           resDetalle=stDetalle.executeQuery(consulta);
                                           codMaterialCabecera=0;
                                           fracciones="";
                                           while(resDetalle.next())
                                           {

                                               if((resDetalle.getRow()%2)==0)
                                               {
                                                    innerHTML+="<tr>" +
                                                                "<td rowspan='2' class='"+(resDetalle.getString("cantidad")==null?"nuevo":(resDetalle.getString("cantidad2")==null?"eliminado":""))+"'><span class='outputText2'>"+resDetalle.getString("NOMBRE_MATERIAL")+"</span></td>" +
                                                                "<td rowspan='2' class='"+(resDetalle.getString("cantidad")==null?"nuevo":(resDetalle.getString("cantidad2")==null?"eliminado":(resDetalle.getDouble("cantidad")!=resDetalle.getDouble("cantidad2")?"modificado":"")))+"'><span class='outputText2'>"+formato.format(resDetalle.getDouble("cantidad"))+"</span></td>" +
                                                                "<td rowspan='2' class='"+(resDetalle.getString("cantidad")==null?"nuevo":(resDetalle.getString("cantidad2")==null?"eliminado":(resDetalle.getDouble("cantidad")!=resDetalle.getDouble("cantidad2")?"modificado":"")))+"'><span class='outputText2'>"+formato.format(resDetalle.getDouble("cantidad2"))+"</span></td>" +
                                                                "<td rowspan='2' class='"+(resDetalle.getString("cantidad")==null?"nuevo":(resDetalle.getString("cantidad2")==null?"eliminado":""))+"'><span class='outputText2'>"+resDetalle.getString("NOMBRE_ESTADO_REGISTRO")+"</span></td>" +
                                                                fracciones+
                                                                "</tr><tr>"+
                                                                "<td class='"+(resDetalle.getString("cantidad")==null?"nuevo":(resDetalle.getString("cantidad2")==null?"eliminado":(resDetalle.getInt("registrado")!=resDetalle.getInt("registrado2")?"modificado":"")))+"'><input disabled='true' type='checkbox' "+(resDetalle.getInt("registrado")>0?"checked":"")+"/></td>"+
                                                               "<td class='"+(resDetalle.getString("cantidad")==null?"nuevo":(resDetalle.getString("cantidad2")==null?"eliminado":(resDetalle.getInt("registrado")!=resDetalle.getInt("registrado2")?"modificado":"")))+"'><input disabled='true' type='checkbox' "+(resDetalle.getInt("registrado2")>0?"checked":"")+"/></td>"+
                                                               "<td class='"+(resDetalle.getString("cantidad")==null?"nuevo":(resDetalle.getString("cantidad2")==null?"eliminado":""))+"'><span class='outputText2'>"+resDetalle.getString("nombre_tipo_analisis_material_reactivo")+"</span></td></tr>";

                                               }
                                               else
                                               {
                                                   fracciones="<td class='"+(resDetalle.getString("cantidad")==null?"nuevo":(resDetalle.getString("cantidad2")==null?"eliminado":(resDetalle.getInt("registrado")!=resDetalle.getInt("registrado2")?"modificado":"")))+"'><input disabled='true' type='checkbox' "+(resDetalle.getInt("registrado")>0?"checked":"")+"/></td>"+
                                                               "<td class='"+(resDetalle.getString("cantidad")==null?"nuevo":(resDetalle.getString("cantidad2")==null?"eliminado":(resDetalle.getInt("registrado")!=resDetalle.getInt("registrado2")?"modificado":"")))+"'><input disabled='true' type='checkbox' "+(resDetalle.getInt("registrado2")>0?"checked":"")+"/></td>"+
                                                               "<td class='"+(resDetalle.getString("cantidad")==null?"nuevo":(resDetalle.getString("cantidad2")==null?"eliminado":""))+"'><span class='outputText2'>"+resDetalle.getString("nombre_tipo_analisis_material_reactivo")+"</span></td>";
                                               }
                                           }
                                 }
                                 innerHTML+="</tbody></table>";
                    }
                    catch(SQLException ex)
                    {
                        ex.printStackTrace();
                    }
      return innerHTML;
    }

    public void enviarControlDeCambios()
    {
        String correoDetalle="";
        try
        {
            con=Util.openConnection(con);
        
            if(codTipoEnvioCorreo!=1)
                {
                   String consulta="select  c.COD_ESTADO_VERSION from COMPONENTES_PROD_VERSION c" +
                                   " where c.COD_VERSION='"+registroControlCambios.getComponentesProd().getCodVersion()+"'";
                    System.out.println("consulta verificar usuarios pendientes de enviar a aproibac "+consulta);
                    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet res=st.executeQuery(consulta);
                    if(res.next())codTipoEnvioCorreo=(res.getInt("COD_ESTADO_VERSION")==3?2:0);
                }
            
            for(TiposEspecificacionesControlCambios tipoE:tiposEspecificacionesControlCambiosList)
                {
                    correoDetalle+="<tr><td style='border:1px solid #9d5a9e;border-top:none;background-color:#eec2ef' colspan='3'><span>"+tipoE.getNombreTipoEspecificacionControlCambios()+"</span></td>" +
                                   "</tr>";
                    for(EspecificacionesControlCambios bean:tipoE.getEspecificacionesControlCambiosList())
                    {
                        correoDetalle+="<tr><td rowspan='"+bean.getRegistroControlCambiosActividadPropuestListSize()+"' class='' style='border:1px solid #9d5a9e;border-top:none;background-color:red;padding:1em'><span>"+bean.getNombreEspecificacionControlCambios()+"</span></td>";
                                       
                        int cont=0;
                        for(RegistroControlCambiosActividadPropuesta bean1:bean.getRegistroControlCambiosActividadPropuestList())
                        {
                            if(!bean1.getActividadSugerida().equals(""))
                            {
                                correoDetalle+=(cont==0?"":"<tr>");
                                correoDetalle+="<td style='border:1px solid #9d5a9e;border-top:none;padding:1em;border-left:none;line-height:14px;background-color:white'><span style='font-weight:bold'>"+(bean1.getPersonal().getNombrePersonal())+"</span></td>" +
                                               "<td style='border:1px solid #9d5a9e;border-top:none;padding:1em;border-left:none;line-height:14px;background-color:white'><span>"+(bean1.getActividadSugerida())+"</span></td></tr>" ;
                                cont++;
                            }
                        }
                    }
                }
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
        if(codTipoEnvioCorreo>0)
        {
            SimpleDateFormat sdf=new SimpleDateFormat();
                String mensajeCorreo="<html> <head>  <title></title><meta http-equiv='Content-Type' content='text/html; charset=windows-1252'>" +
                                     "<style>span{font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 11px;}" +
                                     ".celdaDetalle{padding:3px !important; border-right: solid #bbbbbb 1px !important;border-bottom: solid #bbbbbb 1px !important;}" +
                                     ".cabecera{background-color:#9d5a9e;color:white;padding:2px;}" +
                                     ".cabecera td{padding:3px !important; border-right: solid white 1px !important;border-bottom: solid white 1px !important;}" +
                                     ".cabeceraVersion{background-color:#eeeeee;}" +
                                     ".cabeceraVersionDetalle{padding:3px !important;}" +
                                     ".tablaComparacion{font-family:Verdana, Arial, Helvetica, sans-serif;font-size:11px;margin-top:1em;top:1em;border-top:1px solid #aaaaaa;border-left:1px solid #aaaaaa;}"+
                                     " .tablaComparacion tr td{padding:0.4em;border-bottom:1px solid #aaaaaa;border-right:1px solid #aaaaaa;}"+
                                     " .tablaComparacion thead tr td{font-weight:bold;background-color:#ebeaeb;color:black;text-align:center;}" +
                                     ".eliminado{background-color:#FFB6C1;}"+
                                     ".modificado{background-color:#F0E68C;}"+
                                     " .especificacion{font-weight:bold;background-color:white;}"+
                                     " .nuevo{background-color:#b6f5b6;}"+
                                     ".celdaQuimica{background-color:white;font-weight:bold;}" +
                                     "</style><span>Se generó el control de cambios con el correlativo "+registroControlCambios.getCoorelativo()+" con los siguientes Datos:</span><br/><br/>" +
                                    "<center><table class='cabeceraVersion' cellpadding='0' cellspacing='0' ><tr class='cabecera'><td colspan='3' align='center'><span>Datos del Control de Cambios</span></td></tr>" +
                                    "<tr><td class='cabeceraVersionDetalle'><span style='font-weight:bold'>Correlativo</span></td><td class='cabeceraVersionDetalle'><span style='font-weight:bold'>::</span></td><td class='cabeceraVersionDetalle'><span>"+registroControlCambios.getCoorelativo()+"</span></td></tr>" +
                                    "<tr><td class='cabeceraVersionDetalle'><span style='font-weight:bold'>Funcionario</span></td><td class='cabeceraVersionDetalle'><span style='font-weight:bold'>::</span></td><td class='cabeceraVersionDetalle'><span>"+registroControlCambios.getPersonalRegistra().getNombrePersonal()+"</span></td></tr>" +
                                    "<tr><td class='cabeceraVersionDetalle'><span style='font-weight:bold'>Area Empresa</span></td><td class='cabeceraVersionDetalle'><span style='font-weight:bold'>::</span></td><td class='cabeceraVersionDetalle'><span>"+registroControlCambios.getAreasEmpresa().getNombreAreaEmpresa()+"</span></td></tr>" +
                                    "<tr><td class='cabeceraVersionDetalle'><span style='font-weight:bold'>Producto</span></td><td class='cabeceraVersionDetalle'><span style='font-weight:bold'>::</span></td><td class='cabeceraVersionDetalle'><span>"+registroControlCambios.getComponentesProd().getNombreProdSemiterminado()+"</span></td></tr>" +
                                    "<tr><td class='cabeceraVersionDetalle'><span style='font-weight:bold'>Fecha</span></td><td class='cabeceraVersionDetalle'><span style='font-weight:bold'>::</span></td><td class='cabeceraVersionDetalle'><span>"+sdf.format(new Date())+"</span></td></tr>" +
                                    "</table><br/><br/>" +
                                    "<table class='cabeceraVersion' cellpadding='0' cellspacing='0' ><tr class='cabecera'><td colspan='4' align='center'><span>1. Información Diligenciada por Funcionario</span></td></tr>" +
                                    "<tr><td class='cabeceraVersionDetalle' colspan='4'><span style='font-weight:bold'>Cambio Propuesto:</span></td></tr>" +
                                    "<tr><td  style='padding:1em;border:1px solid black;background-color:white' colspan='4'><center>"+cambioPropuesto()+"</center></td></tr>" +
                                    "<tr><td class='cabeceraVersionDetalle' colspan='4'><span style='font-weight:bold'>Proposito del cambio:</span></td></tr>";
                for(RegistroControlCambiosProposito bean:registroControlCambios.getRegistroControlCambiosPropositoList())
                {
                    mensajeCorreo+="<tr><td colspan='3' style='background-color:white;padding:1em;line-height:14px;border:1px solid black'><span style='font-weight:bold'>"+bean.getPersonal().getNombrePersonal()+":  </span><span>"+bean.getPropositoCambio()+"</span></td></tr>";
                }
                                    mensajeCorreo+=
                                    "<tr>" +
                                    "<td class='cabecera' ><span style='font-weight:bold'>REQUERIMIENTO</span></td>" +
                                    "<td class='cabecera' colspan='2' ><span style='font-weight:bold'>ACTIVIDAD SUGERIDA</span></td></tr>"+
                                    correoDetalle+"</table>";

                
                try {
                     Properties props = new Properties();
                     props.put("mail.smtp.host", "mail.cofar.com.bo");
                     props.put("mail.transport.protocol", "smtp");
                     props.put("mail.smtp.auth", "false");
                     props.setProperty("mail.user", "controlDeCambios@cofar.com.bo");
                     props.setProperty("mail.password", "105021ej");
                     Session mailSession = Session.getInstance(props, null);
                     Message msg = new MimeMessage(mailSession);
                     String asunto="Control de Cambios correlativo "+registroControlCambios.getCoorelativo();
                     msg.setSubject(asunto);
                     msg.setFrom(new InternetAddress("controlDeCambios@cofar.com.bo", "Registro de Control De Cambios"));
                     con = Util.openConnection(con);
                     Statement st = con.createStatement();
                     String consulta =(codTipoEnvioCorreo==1?" select cp.nombre_correopersonal,cp.COD_PERSONAL from correo_personal cp inner join PERMISOS_VERSION_CP pv on " +
                                       "cp.COD_PERSONAL=pv.COD_PERSONAL where pv.PERSONAL_INVOLUCRADO_VERSION=1":
                                       "select e.CORREO_PERSONAL from ENVIO_CORREOS_APROBACION_VERSION e where e.ENVIO_CONTROL_DE_CAMBIOS=1");
                     System.out.println("consulta buscar correos personal oos "+consulta);
                     ResultSet res = st.executeQuery(consulta);
                     List<String> correosPersonal=new ArrayList<String>();
                     while(res.next())
                     {
                         correosPersonal.add(res.getString(codTipoEnvioCorreo==1?"nombre_correopersonal":"CORREO_PERSONAL"));
                     }
                     int codCorreos=0;
                     InternetAddress emails[] = new InternetAddress[correosPersonal.size()];
                     for(String a:correosPersonal)
                     {
                             emails[codCorreos]=new InternetAddress(a);
                             codCorreos++;
                     }
                     msg.addRecipients(Message.RecipientType.TO, emails);
                     msg.setContent(mensajeCorreo, "text/html");
                     javax.mail.Transport.send(msg);
                     st.close();
                     con.close();
                }
                catch(Exception ex)
                {
                    ex.printStackTrace();
                }
        }
        
    }
    public String guardarRegistroControlCambios_action()throws SQLException
    {
        mensaje="";
        codTipoEnvioCorreo=0;
        SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
        try
        {
            con=Util.openConnection(con);
            con.setAutoCommit(false);
            PreparedStatement pst=null;
            String consulta="";
            if(registroControlCambios.getCodRegistroControlCambios()<=0)
            {
                consulta="select isnull(max(r.COD_REGISTRO_CONTROL_CAMBIOS),0)+1 as codRegistro from REGISTRO_CONTROL_CAMBIOS r";
                int codRegistro=0;
                Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet res=st.executeQuery(consulta);
                if(res.next())registroControlCambios.setCodRegistroControlCambios(res.getInt("codRegistro"));
                consulta="INSERT INTO REGISTRO_CONTROL_CAMBIOS(COD_REGISTRO_CONTROL_CAMBIOS,COD_COMPPROD, COD_VERSION_PROD, COD_VERSION_FM, COD_PERSONAL_REGISTRA,"+
                         " COD_AREA_EMPRESA, COORELATIVO,"+
                         " CLASIFICACION_DEL_CAMBIO, AMERITA_CAMBIO, CAMBIO_DEFINITIVO, FECHA_REGISTRO)"+
                         " VALUES ('"+registroControlCambios.getCodRegistroControlCambios()+"','"+registroControlCambios.getComponentesProd().getCodCompprod()+"'," +
                         "'"+registroControlCambios.getComponentesProd().getCodVersion()+"','"+registroControlCambios.getFormulaMaestraVersion().getCodVersion()+"'," +
                         "'"+registroControlCambios.getPersonalRegistra().getCodPersonal()+"','"+registroControlCambios.getAreasEmpresa().getCodAreaEmpresa()+"'," +
                         "'"+registroControlCambios.getCoorelativo()+"',0,0,0,'"+sdf.format(new Date())+"')";
                System.out.println("consulta insert "+consulta);
                pst=con.prepareStatement(consulta);
                if(pst.executeUpdate()>0)System.out.println("se inserto el registro de control de cambios");
                codTipoEnvioCorreo=1;
            }
            for(RegistroControlCambiosProposito bean:registroControlCambios.getRegistroControlCambiosPropositoList())
            {
                if(bean.getChecked())
                {
                    consulta="INSERT INTO REGISTRO_CONTROL_CAMBIOS_PROPOSITO(COD_REGISTRO_CONTROL_CAMBIOS,COD_PERSONAL, PROPOSITO_CAMBIO)"+
                             " VALUES ('"+registroControlCambios.getCodRegistroControlCambios()+"','"+registroControlCambios.getPersonalRegistra().getCodPersonal()+"',?)";
                    System.out.println("consulta registrar proposito cambio"+consulta);
                    pst=con.prepareStatement(consulta);
                    pst.setString(1,bean.getPropositoCambio());
                    if(pst.executeUpdate()>0)System.out.println("se registro el proposito del cambio");
                }
            }
            for(TiposEspecificacionesControlCambios tipoE:tiposEspecificacionesControlCambiosList)
            {
                for(EspecificacionesControlCambios bean:tipoE.getEspecificacionesControlCambiosList())
                {
                    
                    for(RegistroControlCambiosActividadPropuesta bean1:bean.getRegistroControlCambiosActividadPropuestList())
                    {
                        if(bean1.getChecked()&&(!bean1.getActividadSugerida().equals("")))
                        {
                            consulta="INSERT INTO REGISTRO_CONTROL_CAMBIOS_ACTIVIDAD_PROPUESTA("+
                                     " COD_REGISTRO_CONTROL_CAMBIOS, COD_PERSONAL, COD_ESPECIFICACION_CONTROL_CAMBIOS,ACTIVIDAD_SUGERIDA)"+
                                     " VALUES ('"+registroControlCambios.getCodRegistroControlCambios()+"','"+registroControlCambios.getPersonalRegistra().getCodPersonal()+"',"+
                                     "'"+bean.getCodEspecificacionControlCambios()+"',?)";
                            pst=con.prepareStatement(consulta);
                            pst.setString(1,bean1.getActividadSugerida());
                            if(pst.executeUpdate()>0)System.out.println("se registro la actividad sugerida");
                        }
                    }
                }
            }
            
            con.commit();
            mensaje="1";
            pst.close();
            con.close();
        }
        catch(SQLException ex)
        {
            con.rollback();
            con.close();
            mensaje="Ocurrio un error al momento de guardar el registro de control de cambios,intente de nuevo";
            ex.printStackTrace();
        }
        this.enviarControlDeCambios();
        //verificando envio de correo
        
            
               
        return null;
    }
    public String getMensaje() {
        return mensaje;
    }

    public void setMensaje(String mensaje) {
        this.mensaje = mensaje;
    }

    public RegistroControlCambios getRegistroControlCambios() {
        return registroControlCambios;
    }

    public void setRegistroControlCambios(RegistroControlCambios registroControlCambios) {
        this.registroControlCambios = registroControlCambios;
    }


    public List<SelectItem> getPersonalRegistroSelect() {
        return personalRegistroSelect;
    }

    public void setPersonalRegistroSelect(List<SelectItem> personalRegistroSelect) {
        this.personalRegistroSelect = personalRegistroSelect;
    }

    public List<ComponentesProd> getComponentesProdList() {
        return componentesProdList;
    }

    public void setComponentesProdList(List<ComponentesProd> componentesProdList) {
        this.componentesProdList = componentesProdList;
    }

    

    public HtmlDataTable getComponentesProdDataTable() {
        return componentesProdDataTable;
    }

    public void setComponentesProdDataTable(HtmlDataTable componentesProdDataTable) {
        this.componentesProdDataTable = componentesProdDataTable;
    }

    public ComponentesProd getComponentesProdSeleccionado() {
        return componentesProdSeleccionado;
    }

    public void setComponentesProdSeleccionado(ComponentesProd componentesProdSeleccionado) {
        this.componentesProdSeleccionado = componentesProdSeleccionado;
    }

    public List<RegistroControlCambios> getRegistroControlCambiosList() {
        return registroControlCambiosList;
    }

    public void setRegistroControlCambiosList(List<RegistroControlCambios> registroControlCambiosList) {
        this.registroControlCambiosList = registroControlCambiosList;
    }

    public HtmlDataTable getRegistroControlCambiosData() {
        return registroControlCambiosData;
    }

    public void setRegistroControlCambiosData(HtmlDataTable registroControlCambiosData) {
        this.registroControlCambiosData = registroControlCambiosData;
    }

    public List<RegistroControlCambiosDetalle> getRegistroControlCambiosDetalleRevisarList() {
        return registroControlCambiosDetalleRevisarList;
    }

    public void setRegistroControlCambiosDetalleRevisarList(List<RegistroControlCambiosDetalle> registroControlCambiosDetalleRevisarList) {
        this.registroControlCambiosDetalleRevisarList = registroControlCambiosDetalleRevisarList;
    }

    public RegistroControlCambios getRegistroControlCambiosSeleccionado() {
        return registroControlCambiosSeleccionado;
    }

    public void setRegistroControlCambiosSeleccionado(RegistroControlCambios registroControlCambiosSeleccionado) {
        this.registroControlCambiosSeleccionado = registroControlCambiosSeleccionado;
    }

    public List<TiposEspecificacionesControlCambios> getTiposEspecificacionesControlCambiosList() {
        return tiposEspecificacionesControlCambiosList;
    }

    public void setTiposEspecificacionesControlCambiosList(List<TiposEspecificacionesControlCambios> tiposEspecificacionesControlCambiosList) {
        this.tiposEspecificacionesControlCambiosList = tiposEspecificacionesControlCambiosList;
    }

    
    
}
