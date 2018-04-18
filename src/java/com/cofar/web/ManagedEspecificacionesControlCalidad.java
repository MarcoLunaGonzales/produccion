/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.web;

import com.cofar.bean.ComponentesProd;
import com.cofar.bean.ComponentesProdConcentracion;
import com.cofar.bean.EspecificacionesFisicasCc;
import com.cofar.bean.EspecificacionesFisicasProducto;
import com.cofar.bean.EspecificacionesMicrobiologiaCc;
import com.cofar.bean.EspecificacionesMicrobiologiaProducto;
import com.cofar.bean.EspecificacionesQuimicasCc;
import com.cofar.bean.EspecificacionesQuimicasProducto;
import com.cofar.bean.FormasFarmaceuticas;
import com.cofar.bean.Materiales;
import com.cofar.bean.SubEspecificacionesOOS;
import com.cofar.bean.TiposReactivos;
import com.cofar.bean.TiposReferenciaCc;
import com.cofar.bean.VersionEspecificacionesProducto;
import com.cofar.util.Aleatorios;
import com.cofar.util.Util;
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
import javax.faces.context.ExternalContext;
import javax.faces.context.FacesContext;
import javax.faces.event.ValueChangeEvent;
import javax.faces.model.SelectItem;

import org.richfaces.component.html.HtmlDataTable;

/**
 *
 * @author hvaldivia
 */

public class ManagedEspecificacionesControlCalidad {
    List especificacionesFisicasCcList = new ArrayList();
    EspecificacionesFisicasCc especificacionesFisicasCc = new EspecificacionesFisicasCc();
    List tiposReferenciaCcList = new ArrayList();
    String mensaje = "";
    List especificacionesQuimicasCcList = new ArrayList();
    EspecificacionesQuimicasCc especificacionesQuimicasCc = new EspecificacionesQuimicasCc();
    List especificacionesMicrobiologiaCcList = new ArrayList();
    EspecificacionesMicrobiologiaCc especificacionesMicrobiologiaCc = new EspecificacionesMicrobiologiaCc();
    List tiposAnalisisCcList = new ArrayList();
    List formasFarmaceuticasList = new ArrayList();
    HtmlDataTable formasFarmaceuticasDataTable = new HtmlDataTable();
    FormasFarmaceuticas formasFarmaceuticasSeleccionado = new FormasFarmaceuticas();
    EspecificacionesFisicasCc especificacionesFisicasCcAgregar = new EspecificacionesFisicasCc();
    int codTipoAnalisisCc = 0;
    List especificacionesCcList = new ArrayList();
    List especificacionesAgregarList = new ArrayList();
    private List<EspecificacionesFisicasCc> listaEspecificaciones= new ArrayList<EspecificacionesFisicasCc>();
    private List<SelectItem> tiposResultadoAnalisisList=new ArrayList<SelectItem>();
    private List<ComponentesProd> componentesProductoList= new ArrayList<ComponentesProd>();
    private ComponentesProd componentesProdbean= new ComponentesProd();
    private HtmlDataTable componentesProdDataTable= new HtmlDataTable();
    private List<SelectItem> estadosCompProdList= new ArrayList<SelectItem>();
    private List<SelectItem> productosList= new ArrayList<SelectItem>();
    private List<Materiales> listaMaterialesPrincipioActivo=new ArrayList<Materiales>();
    private List<EspecificacionesFisicasProducto> listaEspecificacionesFisicasProducto= new ArrayList<EspecificacionesFisicasProducto>();
    private List<EspecificacionesQuimicasCc> listaEspecificacionesQuimicasCc= new ArrayList<EspecificacionesQuimicasCc>();
    private List<SelectItem> listaTiposReferenciaCc= new ArrayList<SelectItem>();
    private List<EspecificacionesMicrobiologiaProducto> listaEspecificacionesMicrobiologia= new ArrayList<EspecificacionesMicrobiologiaProducto>();
    private ComponentesProd componentesProd = new ComponentesProd();
    private List<Materiales> materialesList=new ArrayList<Materiales>();
    private Materiales materialBean=new Materiales();
    private Materiales materialEditar=new Materiales();
    private List<SelectItem> capitulosList=new ArrayList<SelectItem>();
    private List<SelectItem> gruposList=new ArrayList<SelectItem>();
    private int begin=0;
    private int end=0;
    private int cantidadFilas=0;
    private String nombreMaterialBaco="";
    private List<ComponentesProdConcentracion> componentesProdConcentracionList=new ArrayList<ComponentesProdConcentracion>();
    private List<SelectItem> unidadesMedidaList=new ArrayList<SelectItem>();
    private String unidadesProducto="";
    private List<SelectItem> tiposEspecificacionesFisicas=new ArrayList<SelectItem>();
    private List<TiposReferenciaCc> tiposReferenciaCcABMList=new ArrayList<TiposReferenciaCc>();
    private TiposReferenciaCc tiposReferenciaCcAgregar=new TiposReferenciaCc();
    private List<SelectItem> tiposProduccionSelectList=new ArrayList<SelectItem>();
    private String codMaterialCompuestoCC="";
    private List<SelectItem> formasFarmaceuticasSelectList=new ArrayList<SelectItem>();
    private List<SelectItem> componentesProdSelectList=new ArrayList<SelectItem>();
    private ComponentesProd componentesProdFormaClonar=new ComponentesProd();
    private ComponentesProd componentesProdClonarDestino=new ComponentesProd();
    private List<EspecificacionesFisicasProducto> listaEspecificacionesFisicasProductoClonar= null;
    private List<EspecificacionesQuimicasCc> listaEspecificacionesQuimicasProductoClonar= null;
    private List<EspecificacionesMicrobiologiaProducto> listaEspecificacionesMicrobiologiaProductoClonar= null;
    private List<VersionEspecificacionesProducto> versionEspecificacionesProductoList=new ArrayList<VersionEspecificacionesProducto>();
    private VersionEspecificacionesProducto versionEspecificacionesProductoFisico=new VersionEspecificacionesProducto();
    private VersionEspecificacionesProducto versionConcentracionProducto=new VersionEspecificacionesProducto();
    private VersionEspecificacionesProducto versionEspecificacionesProductoQuimica= new VersionEspecificacionesProducto();
    private VersionEspecificacionesProducto versionEspecificacionesProductoMicrobiologico=new VersionEspecificacionesProducto();
    private VersionEspecificacionesProducto versionEspecificacionRegistrar=new VersionEspecificacionesProducto();
    private int codigoAleatorio=0;
    private String autorizacion="";
    private String codMaterialesUsadosClonar="";
    private List<SelectItem> tiposEspecificacionesFisicasSelect=new ArrayList<SelectItem>();
    public String getCargarVersionesFisicas()
    {
        this.cargarVersionesEspecificacionProducto(1);
        return null;
    }
    public String getCargarVersionesMicrobiologicasProducto()
    {
        this.cargarVersionesEspecificacionProducto(3);
        return null;
    }
    public String getCargarVersionesQuimicasProducto()
    {
        this.cargarVersionesEspecificacionProducto(2);
        return null;
    }
    public String getCargarVersionesConcentracionProducto()
    {
        this.cargarVersionesEspecificacionProducto(0);
        return null;
    }
    public String agregarNuevaVersionQuimica_action()
    {
        this.redireccionar("agregarVersionAnalisisQuimico.jsf");
        return null;
    }
    public String agregarNuevaVersionConcentracion_action()
    {
        this.redireccionar("agregarVersionConcentracion.jsf");
        return null;
    }
    public String agregarNuevaVersionFisica_action()
    {
        this.redireccionar("agregarVersionEspecificacionesFisicas.jsf");
        return null;
    }
    public String agregarNuevaVersionMicrobiologica_action()
    {
        this.redireccionar("agregarVersionEspecificacionesMicro.jsf");
        return null;
    }
    public String editarVersionEspecificacionFisicaProducto_action()
    {
        for(VersionEspecificacionesProducto bean:versionEspecificacionesProductoList)
        {
            if(bean.getChecked())
            {
                versionEspecificacionesProductoFisico=bean;
            }
        }
        generarNumeroAleatorio_action();
       // this.redireccionar("editarVersionAnalisisFisico.jsf");
        return null;
    }
    public String editarVersionConcentracionProducto_action()
    {
        for(VersionEspecificacionesProducto bean:versionEspecificacionesProductoList)
        {
            if(bean.getChecked())
            {
                versionConcentracionProducto=bean;
            }
        }
        generarNumeroAleatorio_action();
        //this.redireccionar("editarVersionConcentracion.jsf");
        return null;
    }
    public String generarNumeroAleatorio_action()
    {
        Aleatorios a = new Aleatorios(1);
        int numeros[] = a.generar(1, 10, 10000);
        codigoAleatorio=numeros[0];
        System.out.println("ca "+codigoAleatorio);
        autorizacion="";
        return null;
    }
    public String editarVersionEspecificacionQuimicaProducto_action()
    {
        for(VersionEspecificacionesProducto bean:versionEspecificacionesProductoList)
        {
            if(bean.getChecked())
            {
                versionEspecificacionesProductoQuimica=bean;
            }
        }
        generarNumeroAleatorio_action();
        
        return null;
    }
    public String editarVersionEspecificacionMicroProducto_action()
    {
        for(VersionEspecificacionesProducto bean:versionEspecificacionesProductoList)
        {
            if(bean.getChecked())
            {
                versionEspecificacionesProductoMicrobiologico=bean;
                
            }
        }
        this.generarNumeroAleatorio_action();
        //this.redireccionar("editarVersionEspecificacionesMicro.jsf");
        return null;
    }

    public String activarVersionEspecificacionMicrobiologiaProducto_ation()throws SQLException
    {
        mensaje="";
        for(VersionEspecificacionesProducto bean:versionEspecificacionesProductoList)
        {
            if(bean.getChecked())
            {
                Connection con=null;
                try
                {
                    con=Util.openConnection(con);
                    con.setAutoCommit(false);
                    String consulta="update VERSION_ESPECIFICACIONES_PRODUCTO set VERSION_ACTIVA='0' where  COD_COMPPROD='"+componentesProd.getCodCompprod()+"' and COD_TIPO_ANALISIS=3";
                    System.out.println("consulta inabilitar general "+consulta);
                    PreparedStatement pst=con.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)System.out.println("se inactivaron todas las versiones");
                    consulta=" update VERSION_ESPECIFICACIONES_PRODUCTO set VERSION_ACTIVA='1' where COD_VERSION_ESPECIFICACION_PRODUCTO='"+bean.getCodVersionEspecificacionProducto()+"'";
                    pst=con.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)System.out.println("se activo la version seleccionada");
                    con.commit();
                    mensaje="1";
                    con.close();
                }
                catch(SQLException ex)
                {
                    mensaje="Ocurrio un error al momento de activar la version,intente de nuevo";
                    con.rollback();
                    con.close();
                    ex.printStackTrace();
                }
            }
        }
        if(mensaje.equals("1"))
        {
            this.cargarVersionesEspecificacionProducto(3);
        }
        return null;
    }
    public String activarVersionEspecificacionQuimicaProducto_ation()throws SQLException
    {
        mensaje="";
        for(VersionEspecificacionesProducto bean:versionEspecificacionesProductoList)
        {
            if(bean.getChecked())
            {
                Connection con=null;
                try
                {
                    con=Util.openConnection(con);
                    con.setAutoCommit(false);
                    String consulta="update VERSION_ESPECIFICACIONES_PRODUCTO set VERSION_ACTIVA='0' where  COD_COMPPROD='"+componentesProd.getCodCompprod()+"' and COD_TIPO_ANALISIS=2";
                    System.out.println("consulta inabilitar general "+consulta);
                    PreparedStatement pst=con.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)System.out.println("se inactivaron todas las versiones");
                    consulta=" update VERSION_ESPECIFICACIONES_PRODUCTO set VERSION_ACTIVA='1' where COD_VERSION_ESPECIFICACION_PRODUCTO='"+bean.getCodVersionEspecificacionProducto()+"'";
                    pst=con.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)System.out.println("se activo la version seleccionada");
                    con.commit();
                    mensaje="1";
                    con.close();
                }
                catch(SQLException ex)
                {
                    mensaje="Ocurrio un error al momento de activar la version,intente de nuevo";
                    con.rollback();
                    con.close();
                    ex.printStackTrace();
                }
            }
        }
        if(mensaje.equals("1"))
        {
            this.cargarVersionesEspecificacionProducto(2);
        }
        return null;
    }
    public String activarVersionConcentracionProducto_ation()throws SQLException
    {
        mensaje="";
        for(VersionEspecificacionesProducto bean:versionEspecificacionesProductoList)
        {
            if(bean.getChecked())
            {
                Connection con=null;
                try
                {
                    con=Util.openConnection(con);
                    con.setAutoCommit(false);
                    String consulta="update VERSION_ESPECIFICACIONES_PRODUCTO set VERSION_ACTIVA='0' where  COD_COMPPROD='"+componentesProd.getCodCompprod()+"' and COD_TIPO_ANALISIS=0";
                    System.out.println("consulta inabilitar general "+consulta);
                    PreparedStatement pst=con.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)System.out.println("se inactivaron todas las versiones");
                    consulta=" update VERSION_ESPECIFICACIONES_PRODUCTO set VERSION_ACTIVA='1' where COD_VERSION_ESPECIFICACION_PRODUCTO='"+bean.getCodVersionEspecificacionProducto()+"'";
                    System.out.println("consulta activar version "+consulta);
                    pst=con.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)System.out.println("se activo la version seleccionada");
                    con.commit();
                    mensaje="1";
                    con.close();
                }
                catch(SQLException ex)
                {
                    mensaje="Ocurrio un error al momento de activar la version,intente de nuevo";
                    con.rollback();
                    con.close();
                    ex.printStackTrace();
                }
            }
        }
        if(mensaje.equals("1"))
        {
            this.cargarVersionesEspecificacionProducto(0);
        }
        return null;
    }

    public String activarVersionEspecificacionFisicaProducto_ation()throws SQLException
    {
        mensaje="";
        for(VersionEspecificacionesProducto bean:versionEspecificacionesProductoList)
        {
            if(bean.getChecked())
            {
                Connection con=null;
                try
                {
                    con=Util.openConnection(con);
                    con.setAutoCommit(false);
                    String consulta="update VERSION_ESPECIFICACIONES_PRODUCTO set VERSION_ACTIVA='0' where  COD_COMPPROD='"+componentesProd.getCodCompprod()+"' and COD_TIPO_ANALISIS=1";
                    System.out.println("consulta inabilitar general "+consulta);
                    PreparedStatement pst=con.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)System.out.println("se inactivaron todas las versiones");
                    consulta=" update VERSION_ESPECIFICACIONES_PRODUCTO set VERSION_ACTIVA='1' where COD_VERSION_ESPECIFICACION_PRODUCTO='"+bean.getCodVersionEspecificacionProducto()+"'";
                    pst=con.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)System.out.println("se activo la version seleccionada");
                    con.commit();
                    mensaje="1";
                    con.close();
                }
                catch(SQLException ex)
                {
                    mensaje="Ocurrio un error al momento de activar la version,intente de nuevo";
                    con.rollback();
                    con.close();
                    ex.printStackTrace();
                }
            }
        }
        if(mensaje.equals("1"))
        {
            this.cargarVersionesEspecificacionProducto(1);
        }
        return null;
    }
    
    private void cargarVersionesEspecificacionProducto(int codTipoAnalisis)
    {
        try
        {
            Connection con=null;
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select vep.OBSERVACION,vep.COD_VERSION_ESPECIFICACION_PRODUCTO,vep.NRO_VERSION_ESPECIFICACION_PRODUCTO,"+
                            " vep.FECHA_CREACION,vep.COD_TIPO_ANALISIS,vep.VERSION_ACTIVA" +
                            " ,vep.COD_PERSONAL_MODIFICA,vep.COD_PERSONAL_REGISTRA"+
                            " ,(p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRE_PILA+' '+p.nombre2_personal) as personalRegistra"+
                            " ,(p1.AP_PATERNO_PERSONAL+' '+p1.AP_MATERNO_PERSONAL+' '+p1.NOMBRE_PILA+' '+p1.nombre2_personal) as personalModifica"+
                            " from VERSION_ESPECIFICACIONES_PRODUCTO vep" +
                            " left outer join PERSONAL p on p.COD_PERSONAL=vep.COD_PERSONAL_REGISTRA"+
                            " left outer join PERSONAL p1 on p1.COD_PERSONAL=vep.COD_PERSONAL_MODIFICA" +
                            " where vep.COD_TIPO_ANALISIS='"+codTipoAnalisis+"'" +
                            " and vep.COD_COMPPROD='"+componentesProd.getCodCompprod()+"'"+
                            " order by vep.NRO_VERSION_ESPECIFICACION_PRODUCTO";
            System.out.println("consulta cargar versiones producto "+consulta);
            ResultSet res=st.executeQuery(consulta);
            versionEspecificacionesProductoList.clear();
            while(res.next())
            {
                VersionEspecificacionesProducto nuevo=new VersionEspecificacionesProducto();
                nuevo.setCodVersionEspecificacionProducto(res.getInt("COD_VERSION_ESPECIFICACION_PRODUCTO"));
                nuevo.setNroVersionEspecificacionProducto(res.getInt("NRO_VERSION_ESPECIFICACION_PRODUCTO"));
                nuevo.setFechaCreacion(res.getTimestamp("FECHA_CREACION"));
                nuevo.setVersionActiva(res.getInt("VERSION_ACTIVA")>0);
                nuevo.getTipoAnalisis().setCodTipoAnalisis(codTipoAnalisis);
                nuevo.setObservacion(res.getString("OBSERVACION"));
                nuevo.getPersonalRegistra().setCodPersonal(res.getString("COD_PERSONAL_REGISTRA"));
                nuevo.getPersonalRegistra().setNombrePersonal(res.getInt("COD_PERSONAL_REGISTRA")>0?res.getString("personalRegistra"):"");
                nuevo.getPersonalModifica().setCodPersonal(res.getString("COD_PERSONAL_MODIFICA"));
                nuevo.getPersonalModifica().setNombrePersonal(res.getInt("COD_PERSONAL_MODIFICA")>0?res.getString("personalModifica"):"");
                versionEspecificacionesProductoList.add(nuevo);
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
    private void cargarFormasFarmaceuticasSelect()
    {
        try
        {
            Connection con=null;
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select f.cod_forma,f.nombre_forma from FORMAS_FARMACEUTICAS f where f.cod_estado_registro=1 order by f.nombre_forma";
            ResultSet res=st.executeQuery(consulta);
            formasFarmaceuticasSelectList.clear();
            while(res.next())
            {
                formasFarmaceuticasSelectList.add(new SelectItem(res.getString("cod_forma"),res.getString("nombre_forma")));
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

    public String formaFarmaceutica_change()
    {
        this.cargarComponentesProdSelect();
        return null;
    }
    private void cargarComponentesProdSelect()
    {
        try{
            Connection con=null;
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select cp.COD_COMPPROD,cp.nombre_prod_semiterminado"+
                            " from COMPONENTES_PROD cp where cp.COD_TIPO_PRODUCCION=1 and cp.COD_ESTADO_COMPPROD=1"+
                            " order by cp.nombre_prod_semiterminado";
            System.out.println("consulta cargar componentes prod  "+consulta);
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
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
    }
    public String getCargarNavegadorClonarEspecificacionesProducto()
    {
        this.cargarTiposRefenciasCc();
        this.cargarTiposEspecificacionesFisicas();
        //this.cargarFormasFarmaceuticasSelect();
        //componentesProdFormaClonar.getForma().setCodForma(formasFarmaceuticasSelectList.get(0).getValue().toString());
        this.cargarComponentesProdSelect();
        listaEspecificacionesFisicasProductoClonar=new ArrayList<EspecificacionesFisicasProducto>();
        listaEspecificacionesMicrobiologiaProductoClonar=new  ArrayList<EspecificacionesMicrobiologiaProducto>();
        listaEspecificacionesQuimicasProductoClonar=new ArrayList<EspecificacionesQuimicasCc>();
        return null;
    }
    public String getCargarTiposReferenciaAbmCc()
    {
        this.cargarTiposReferenciaABMCc();
        return null;
    }
    public String editarTiposReferenciaCc_action()
    {
        for(TiposReferenciaCc bean:tiposReferenciaCcABMList)
        {
            if(bean.getChecked())
            {
                tiposReferenciaCcAgregar=bean;
            }
        }
        return null;
    }
    public String buscarComponenteProd_action()
    {
        this.cargarComponentesProd();
        return null;
    }
    public String buscarEspecificacionesControlCalidad_action()
    {
        try
        {
            Connection con=null;
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select ISNULL(trcc.COD_REFERENCIACC, 0) as codTipoReferencia,efcc.COD_ESPECIFICACION,"+
                            " ISNULL(efcc.COEFICIENTE, '') AS COEFICIENTE,efcc.COD_TIPO_RESULTADO_ANALISIS,"+
                            " efcc.NOMBRE_ESPECIFICACION,ISNULL(efp.DESCRIPCION, '') as descripcion,"+
                            " ISNULL(efp.LIMITE_INFERIOR, 0) as limiteInferior,ISNULL(efp.LIMITE_SUPERIOR, 0) as limiteSuperior,"+
                            " ISNULL(efp.VALOR_EXACTO, 0) as valorExacto,ISNULL(efp.ESTADO, 2) as estado,"+
                            " isnull(tra.SIMBOLO, '') as simbolo,isnull(tef.COD_TIPO_ESPECIFICACION_FISICA, 0) as codTipoEspecificacion,"+
                            " isnull(tef.NOMBRE_TIPO_ESPECIFICACION_FISICA, '') as nombreTipoEspcificacion"+
                            " from ESPECIFICACIONES_FISICAS_PRODUCTO efp"+
                            " inner join ESPECIFICACIONES_FISICAS_CC efcc on efcc.COD_ESPECIFICACION ="+
                            " efp.COD_ESPECIFICACION" +
                            " inner join VERSION_ESPECIFICACIONES_PRODUCTO vep on "+
                            " vep.COD_VERSION_ESPECIFICACION_PRODUCTO=efp.COD_VERSION_ESPECIFICACION_PRODUCTO"+
                            " and vep.COD_TIPO_ANALISIS=1 and vep.COD_COMPPROD=efp.COD_PRODUCTO and vep.VERSION_ACTIVA=1"+
                            " left outer join TIPOS_REFERENCIACC trcc on trcc.COD_REFERENCIACC ="+
                            " efp.COD_REFERENCIA_CC"+
                            " left outer join TIPOS_RESULTADOS_ANALISIS tra on"+
                            " tra.COD_TIPO_RESULTADO_ANALISIS = efcc.COD_TIPO_RESULTADO_ANALISIS"+
                            " left outer join TIPOS_ESPECIFICACIONES_FISICAS tef on"+
                            " tef.COD_TIPO_ESPECIFICACION_FISICA = efp.COD_TIPO_ESPECIFICACION_FISICA"+
                            " where efp.COD_PRODUCTO='"+componentesProdFormaClonar.getCodCompprod()+"' "+//and efp.ESTADO=1
                            " order by efcc.NOMBRE_ESPECIFICACION";
            System.out.println("consulta buscar especificaciones activas fisicar "+consulta);
            ResultSet res=st.executeQuery(consulta);
            listaEspecificacionesFisicasProductoClonar.clear();
            
            while(res.next())
             {
                 EspecificacionesFisicasProducto bean= new EspecificacionesFisicasProducto();
                 bean.setValorExacto(res.getDouble("valorExacto"));
                 bean.setDescripcion(res.getString("descripcion"));
                 bean.setLimiteInferior(res.getDouble("limiteInferior"));
                 bean.setLimiteSuperior(res.getDouble("limiteSuperior"));
                 bean.getEspecificacionFisicaCC().setCodEspecificacion(res.getInt("COD_ESPECIFICACION"));
                 bean.getEspecificacionFisicaCC().getTipoResultadoAnalisis().setCodTipoResultadoAnalisis(res.getString("COD_TIPO_RESULTADO_ANALISIS"));
                 bean.getEspecificacionFisicaCC().setNombreEspecificacion(res.getString("NOMBRE_ESPECIFICACION"));
                 bean.getEspecificacionFisicaCC().getTiposReferenciaCc().setCodReferenciaCc(res.getInt("codTipoReferencia"));
                 bean.getEspecificacionFisicaCC().setCoeficiente(res.getString("COEFICIENTE"));
                 bean.getEspecificacionFisicaCC().getTipoResultadoAnalisis().setSimbolo(res.getString("simbolo"));
                 bean.getEstado().setCodEstadoRegistro(res.getString("estado"));
                 bean.getTiposEspecificacionesFisicas().setCodTipoEspecificacionFisica(res.getInt("codTipoEspecificacion"));
                 listaEspecificacionesFisicasProductoClonar.add(bean);
             }

            consulta=" select ISNULL(trcc.COD_REFERENCIACC, 0) as codReferencia,efcc.COD_ESPECIFICACION,"+
                     " efcc.COD_TIPO_RESULTADO_ANALISIS,efcc.NOMBRE_ESPECIFICACION,ISNULL(efp.DESCRIPCION, '') as descripcion,"+
                     " ISNULL(efp.LIMITE_INFERIOR, 0) as limiteInferior,ISNULL(efp.VALOR_EXACTO, 0) AS valorExacto,"+
                     " ISNULL(efp.LIMITE_SUPERIOR, 0) as limiteSuperior,ISNULL(efp.ESTADO, 2) as estadoRegistro,"+
                     " ISNULL(tra.SIMBOLO, '') as SIMBOLO,ISNULL(efcc.COEFICIENTE, '') as COEFICIENTE"+
                     " from ESPECIFICACIONES_MICROBIOLOGIA_PRODUCTO efp"+
                     " inner join ESPECIFICACIONES_MICROBIOLOGIA efcc on efcc.COD_ESPECIFICACION"+
                     " = efp.COD_ESPECIFICACION" +
                     " inner join VERSION_ESPECIFICACIONES_PRODUCTO vep on vep.COD_VERSION_ESPECIFICACION_PRODUCTO=efp.COD_VERSION_ESPECIFICACION_PRODUCTO"+
                     " and vep.COD_TIPO_ANALISIS=3 and vep.COD_COMPPROD=efp.COD_COMPROD and vep.VERSION_ACTIVA=1"+
                     " left outer join TIPOS_REFERENCIACC trcc on trcc.COD_REFERENCIACC ="+
                     " efp.COD_REFERENCIA_CC"+
                     " left outer join TIPOS_RESULTADOS_ANALISIS tra on"+
                     " tra.COD_TIPO_RESULTADO_ANALISIS = efcc.COD_TIPO_RESULTADO_ANALISIS"+
                     " where efp.COD_COMPROD='"+componentesProdFormaClonar.getCodCompprod()+"' and efp.ESTADO=1"+
                     " order by efcc.NOMBRE_ESPECIFICACION";
            System.out.println("consulta cargar especificaciones microbiologicas activas "+consulta);
            res=st.executeQuery(consulta);
            listaEspecificacionesMicrobiologiaProductoClonar.clear();
            while(res.next())
              {
                    EspecificacionesMicrobiologiaProducto bean= new EspecificacionesMicrobiologiaProducto();
                    bean.setComponenteProd(componentesProd);
                    bean.getEspecificacionMicrobiologiaCc().setCodEspecificacion(res.getInt("COD_ESPECIFICACION"));
                    bean.getEspecificacionMicrobiologiaCc().setNombreEspecificacion(res.getString("NOMBRE_ESPECIFICACION"));
                    bean.getEspecificacionMicrobiologiaCc().getTipoResultadoAnalisis().setCodTipoResultadoAnalisis(res.getString("COD_TIPO_RESULTADO_ANALISIS"));
                    bean.getEspecificacionMicrobiologiaCc().setCoeficiente(res.getString("COEFICIENTE"));
                    bean.setLimiteInferior(res.getDouble("limiteInferior"));
                    bean.setLimiteSuperior(res.getDouble("limiteSuperior"));
                    bean.setDescripcion(res.getString("descripcion"));
                    bean.setValorExacto(res.getDouble("valorExacto"));
                    bean.getEspecificacionMicrobiologiaCc().getTiposReferenciaCc().setCodReferenciaCc(res.getInt("codReferencia"));
                    bean.getEspecificacionMicrobiologiaCc().getTipoResultadoAnalisis().setSimbolo(res.getString("SIMBOLO"));
                    bean.getEstado().setCodEstadoRegistro(res.getString("estadoRegistro"));
                    listaEspecificacionesMicrobiologiaProductoClonar.add(bean);
              }
            consulta="select eqcc.COD_ESPECIFICACION,eqcc.NOMBRE_ESPECIFICACION,"+
                     " eqcc.COD_TIPO_RESULTADO_ANALISIS,tra.NOMBRE_TIPO_RESULTADO_ANALISIS,ISNULL(eqcc.COEFICIENTE, '') as coeficiente,"+
                     " ISNULL(tra.SIMBOLO, '') as simbolo"+
                     " from ESPECIFICACIONES_QUIMICAS_CC eqcc"+
                     " inner join TIPOS_RESULTADOS_ANALISIS tra on tra.COD_TIPO_RESULTADO_ANALISIS"+
                     " = eqcc.COD_TIPO_RESULTADO_ANALISIS"+
                     " inner join ESPECIFICACIONES_QUIMICAS_PRODUCTO eqp on eqp.COD_ESPECIFICACION="+
                     " eqcc.COD_ESPECIFICACION" +
                     " inner join VERSION_ESPECIFICACIONES_PRODUCTO vep on vep.COD_VERSION_ESPECIFICACION_PRODUCTO=eqp.COD_VERSION_ESPECIFICACION_PRODUCTO"+
                     " and vep.COD_COMPPROD=eqp.COD_PRODUCTO and vep.COD_TIPO_ANALISIS=2 and vep.VERSION_ACTIVA=1"+
                     " where eqp.COD_PRODUCTO='"+componentesProdFormaClonar.getCodCompprod()+"' "+//and eqp.ESTADO=1
                     " group by eqcc.COD_ESPECIFICACION,eqcc.NOMBRE_ESPECIFICACION,eqcc.COD_TIPO_RESULTADO_ANALISIS,"+
                     " tra.NOMBRE_TIPO_RESULTADO_ANALISIS,eqcc.COEFICIENTE,tra.SIMBOLO"+
                     " order by eqcc.NOMBRE_ESPECIFICACION";
            System.out.println("consulta cargar especificaciones quimicas generales "+consulta);
            res=st.executeQuery(consulta);
             listaEspecificacionesQuimicasProductoClonar.clear();
             codMaterialesUsadosClonar="";
             while(res.next())
            {
                EspecificacionesQuimicasCc bean= new EspecificacionesQuimicasCc();
                bean.setNombreEspecificacion(res.getString("NOMBRE_ESPECIFICACION"));
                bean.setCodEspecificacion(res.getInt("COD_ESPECIFICACION"));
                bean.setCoeficiente(res.getString("coeficiente"));
                bean.getTipoResultadoAnalisis().setSimbolo(res.getString("simbolo"));
                bean.getTipoResultadoAnalisis().setCodTipoResultadoAnalisis(res.getString("COD_TIPO_RESULTADO_ANALISIS"));
                bean.getTipoResultadoAnalisis().setNombreTipoResultadoAnalisis(res.getString("NOMBRE_TIPO_RESULTADO_ANALISIS"));
                bean.setListaEspecificacionesQuimicasProducto(this.cargarEspecificacionesQuimicasProductoClonar(bean.getCodEspecificacion(),componentesProdFormaClonar.getCodCompprod(),
                        componentesProdClonarDestino.getCodCompprod()));

                listaEspecificacionesQuimicasProductoClonar.add(bean);
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
    public String guardarAgregarTiposReferenciaCC_action()throws SQLException
    {
        mensaje="";
        Connection con=null;
        try
        {
            con=Util.openConnection(con);
            con.setAutoCommit(false);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select ISNULL(MAX(tr.COD_REFERENCIACC),0)+1 as cod from TIPOS_REFERENCIACC tr ";
            ResultSet res=st.executeQuery(consulta);
            int cod=0;
            if(res.next())
            {
                cod=res.getInt("cod");
            }
             consulta="INSERT INTO TIPOS_REFERENCIACC(COD_REFERENCIACC, NOMBRE_REFERENCIACC,OBSERVACION)"+
                            " VALUES ('"+cod+"','"+tiposReferenciaCcAgregar.getNombreReferenciaCc()+"','"+tiposReferenciaCcAgregar.getObservacion()+"')";
             System.out.println("consulta insert tipo referencia "+consulta);
            PreparedStatement pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se registro la especificacion");
            con.commit();
            mensaje="1";
            pst.close();
            con.close();
        }
        catch(SQLException ex)
        {
            mensaje="Ocurrio un error al momento de registrar el tipo de referencia,intente de nuevo";
            con.rollback();
            ex.printStackTrace();
        }
        if(mensaje.equals("1"))
        {
            this.cargarTiposReferenciaABMCc();
        }
        return null;
    }
    public String eliminarTiposReferenciaCc()throws SQLException
    {mensaje="";
        for(TiposReferenciaCc bean:tiposReferenciaCcABMList)
        {
            if(bean.getChecked())
            {
                Connection con=null;
                try
                {
                    
                    con=Util.openConnection(con);
                    con.setAutoCommit(false);
                    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    String consulta="select top 1 *  from ESPECIFICACIONES_FISICAS_PRODUCTO e where e.COD_REFERENCIA_CC='"+bean.getCodReferenciaCc()+"'";
                    System.out.println("consulta verificar referencia usada "+consulta);
                    ResultSet res=st.executeQuery(consulta);
                    if(res.next())
                    {
                        mensaje="No se puede borrar la referencia porque una especificacion fisica lo esta usando";
                        
                    }
                    else
                    {
                        consulta="select top 1 * from ESPECIFICACIONES_QUIMICAS_PRODUCTO e where e.COD_REFERENCIA_CC='"+bean.getCodReferenciaCc()+"'";
                        System.out.println("consulta verificar referencia usada quimica "+consulta);
                        res=st.executeQuery(consulta);
                        if(res.next())
                        {
                            mensaje="No se puede borrar la referencia porque una especificacion quimica lo esta usando";
                        }
                        else
                        {
                            consulta="select top 1 * from ESPECIFICACIONES_MICROBIOLOGIA_PRODUCTO e where e.COD_REFERENCIA_CC='"+bean.getCodReferenciaCc()+"'";
                            System.out.println("consulta verificar referencia usada micro "+consulta);
                            res=st.executeQuery(consulta);
                            if(res.next())
                            {
                                mensaje="No se puede borrar la referencia porque una especificacion microbiologica lo esta usando";
                            }
                            else
                            {
                                consulta="delete TIPOS_REFERENCIACC  where COD_REFERENCIACC='"+bean.getCodReferenciaCc()+"'";
                                System.out.println("consulta delete referencia "+consulta);
                                PreparedStatement pst=con.prepareStatement(consulta);
                                if(pst.executeUpdate()>0)System.out.println("se elimino el tipo de referencia");
                            }
                        }
                    }
                    con.commit();
                    mensaje="1";
                    st.close();
                    res.close();
                    con.close();
                }
                catch(SQLException ex)
                {
                    mensaje="Ocurrio un error al momento de eliminar el tipo de referencia, intente de nuevo";
                    con.rollback();
                    ex.printStackTrace();
                }
            }
        }
        if(mensaje.equals("1"))
        {
            this.cargarTiposReferenciaABMCc();
        }
        return null;
    }
    public String guardarEdicionTiposReferenciaCC_action()throws SQLException
    {
        mensaje="";
        Connection con=null;
        try
        {
            con=Util.openConnection(con);
            con.setAutoCommit(false);
            String consulta="UPDATE TIPOS_REFERENCIACC SET"+
                            " NOMBRE_REFERENCIACC = '"+tiposReferenciaCcAgregar.getNombreReferenciaCc()+"'"+
                            " WHERECOD_REFERENCIACC = '"+tiposReferenciaCcAgregar.getCodReferenciaCc()+"'";
            System.out.println("consulta update "+consulta);
            PreparedStatement pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se actualizo el tipo de referencia");
            con.commit();
            mensaje="1";
            con.close();
        }
        catch(SQLException ex)
        {
            mensaje="Ocurrio un error al momento de editar la referencia,intente de nuevo";
            con.rollback();
            ex.printStackTrace();
        }
        if(mensaje.equals("1"))
        {
            this.cargarTiposReferenciaABMCc();
        }
        return null;
    }
    private void cargarTiposReferenciaABMCc()
    {
        try
        {
            Connection con=null;
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select tr.COD_REFERENCIACC,tr.NOMBRE_REFERENCIACC,tr.OBSERVACION from TIPOS_REFERENCIACC tr"+
                            " order by tr.NOMBRE_REFERENCIACC";
            ResultSet res=st.executeQuery(consulta);
            tiposReferenciaCcABMList.clear();
            while(res.next())
            {
                TiposReferenciaCc nuevo=new TiposReferenciaCc();
                nuevo.setObservacion(res.getString("OBSERVACION"));
                nuevo.setCodReferenciaCc(res.getInt("COD_REFERENCIACC"));
                nuevo.setNombreReferenciaCc(res.getString("NOMBRE_REFERENCIACC"));
                tiposReferenciaCcABMList.add(nuevo);
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
    public String agregarTipoReferenciaCC_action()
    {
        tiposReferenciaCcAgregar=new TiposReferenciaCc();
        return null;
    }
    public String editarNombreMaterialCC()
    {
        for(Materiales m:materialesList)
        {
            if(m.getChecked())
            {
                materialEditar=m;
            }
        }
        return null;
    }
    public String atras_action()
    {
        end=begin;
        begin-=15;

        this.cargarMateriales();
        cantidadFilas=materialesList.size();
        return null;
    }
    public String siguiente_action()
    {
        begin=end;
        end+=15;
        this.cargarMateriales();
        cantidadFilas=materialesList.size();
        return null;
    }
    public String getCargarMateriales()
    {
        begin=0;
        end=15;
        materialBean=new Materiales();
        this.cargarCapitulosGruposSelectItem();
        this.cargarMateriales();
        cantidadFilas=materialesList.size();
        return null;
    }
    public String capitulos_change()
    {
        try
        {
            Connection con=null;
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select g.COD_GRUPO,g.NOMBRE_GRUPO from grupos g where g.COD_CAPITULO='"+materialBean.getGrupo().getCapitulo().getCodCapitulo()+"' order by g.NOMBRE_GRUPO";
            ResultSet res=st.executeQuery(consulta);
            gruposList.clear();
            gruposList.add(new SelectItem(0,"-TODOS-"));
            while(res.next())
            {
                gruposList.add(new SelectItem(res.getInt("COD_GRUPO"),res.getString("NOMBRE_GRUPO")));
            }
            res.close();
            st.close();
            con.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
        begin=0;
        end=15;
        //this.cargarMateriales();
        //cantidadFilas=materialesList.size();
        return null;
    }
    public String buscarMaterial_action()
    {
        begin=0;
        end=15;
        this.cargarMateriales();
        cantidadFilas=materialesList.size();
        return null;
    }

    public String guardarEdicionNombreMaterialCC_action()
    {
        try
        {
            Connection con=null;
            con=Util.openConnection(con);
            String consulta="update MATERIALES  set NOMBRE_CCC='"+materialEditar.getNombreCCC()+"' " +
                    " where COD_MATERIAL='"+materialEditar.getCodMaterial()+"'";
            System.out.println("consulta update nombre material "+consulta);
            PreparedStatement pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se actualizo el nombre del material");
            pst.close();
            con.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
        this.cargarMateriales();

        return null;
    }
    private void cargarCapitulosGruposSelectItem()
    {
        try
        {
            Connection con=null;
            con=Util.openConnection(con);
            String consulta="select c.COD_CAPITULO,c.NOMBRE_CAPITULO from capitulos c where c.COD_ESTADO_REGISTRO=1 order by c.NOMBRE_CAPITULO";
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta);
            capitulosList.clear();
            capitulosList.add(new SelectItem(0,"-TODOS-"));
            while(res.next())
            {
                capitulosList.add(new SelectItem(res.getInt("COD_CAPITULO"),res.getString("NOMBRE_CAPITULO")));
            }
            gruposList.clear();
            gruposList.add(new SelectItem(0,"-TODOS-"));
            res.close();
            st.close();
            con.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
    }
    private void cargarMateriales()
    {
        try
        {
            Connection con=null;
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select * from ( select ROW_NUMBER() OVER( order by m.NOMBRE_MATERIAL) as filas," +
                            " m.COD_MATERIAL,isnull(m.NOMBRE_CCC,'') as NOMBRE_CCC,m.NOMBRE_COMERCIAL_MATERIAL,"+
                            " m.NOMBRE_MATERIAL,g.NOMBRE_GRUPO,g.COD_GRUPO,c.COD_CAPITULO,c.NOMBRE_CAPITULO"+
                            " from MATERIALES m inner join grupos g on m.COD_GRUPO=g.COD_GRUPO"+
                            " inner join capitulos c on c.COD_CAPITULO=g.COD_CAPITULO"+
                            " where m.COD_ESTADO_REGISTRO=1" +
                            (materialBean.getGrupo().getCodGrupo()>0?" and g.COD_GRUPO='"+materialBean.getGrupo().getCodGrupo()+"'":"")+
                            (materialBean.getGrupo().getCapitulo().getCodCapitulo()>0?" and c.COD_CAPITULO='"+materialBean.getGrupo().getCapitulo().getCodCapitulo()+"'":"")+
                            (materialBean.getNombreMaterial().equals("")?"":" and m.NOMBRE_MATERIAL like '%"+materialBean.getNombreMaterial()+"%'")+
                            (materialBean.getNombreCCC().equals("")?"":" and m.NOMBRE_CCC like '%"+materialBean.getNombreCCC()+"%'")+
                            " ) as listado where filas BETWEEN "+begin+" and "+end;
            System.out.println("consulta materiales "+consulta);
            ResultSet res=st.executeQuery(consulta);
            materialesList.clear();
            while(res.next())
            {
                Materiales materiales=new Materiales();
                materiales.setCodMaterial(res.getString("COD_MATERIAL"));
                materiales.setNombreMaterial(res.getString("NOMBRE_MATERIAL"));
                materiales.setNombreComercialMaterial(res.getString("NOMBRE_COMERCIAL_MATERIAL"));
                materiales.setNombreCCC(res.getString("NOMBRE_CCC"));
                materiales.getGrupo().setCodGrupo(res.getInt("COD_GRUPO"));
                materiales.getGrupo().setNombreGrupo(res.getString("NOMBRE_GRUPO"));
                materiales.getGrupo().getCapitulo().setCodCapitulo(res.getInt("COD_CAPITULO"));
                materiales.getGrupo().getCapitulo().setNombreCapitulo(res.getString("NOMBRE_CAPITULO"));
                materialesList.add(materiales);
            }
            res.close();
            st.close();
            con.close();
            System.out.println("termino");
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
    }

    public List getEspecificacionesFisicasCcList() {
        return especificacionesFisicasCcList;
    }

    public void setEspecificacionesFisicasCcList(List especificacionesFisicasCcList) {
        this.especificacionesFisicasCcList = especificacionesFisicasCcList;
    }

    public EspecificacionesFisicasCc getEspecificacionesFisicasCc() {
        return especificacionesFisicasCc;
    }

    public void setEspecificacionesFisicasCc(EspecificacionesFisicasCc especificacionesFisicasCc) {
        this.especificacionesFisicasCc = especificacionesFisicasCc;
    }

    public List getTiposReferenciaCcList() {
        return tiposReferenciaCcList;
    }

    public void setTiposReferenciaCcList(List tiposReferenciaCcList) {
        this.tiposReferenciaCcList = tiposReferenciaCcList;
    }

    public String getMensaje() {
        return mensaje;
    }

    public void setMensaje(String mensaje) {
        this.mensaje = mensaje;
    }

    public EspecificacionesQuimicasCc getEspecificacionesQuimicasCc() {
        return especificacionesQuimicasCc;
    }

    public void setEspecificacionesQuimicasCc(EspecificacionesQuimicasCc especificacionesQuimicasCc) {
        this.especificacionesQuimicasCc = especificacionesQuimicasCc;
    }

    public List getEspecificacionesQuimicasCcList() {
        return especificacionesQuimicasCcList;
    }

    public void setEspecificacionesQuimicasCcList(List especificacionesQuimicasCcList) {
        this.especificacionesQuimicasCcList = especificacionesQuimicasCcList;
    }

    public EspecificacionesMicrobiologiaCc getEspecificacionesMicrobiologiaCc() {
        return especificacionesMicrobiologiaCc;
    }

    public void setEspecificacionesMicrobiologiaCc(EspecificacionesMicrobiologiaCc especificacionesMicrobiologiaCc) {
        this.especificacionesMicrobiologiaCc = especificacionesMicrobiologiaCc;
    }

    public List getEspecificacionesMicrobiologiaCcList() {
        return especificacionesMicrobiologiaCcList;
    }

    public void setEspecificacionesMicrobiologiaCcList(List especificacionesMicrobiologiaCcList) {
        this.especificacionesMicrobiologiaCcList = especificacionesMicrobiologiaCcList;
    }

    public List getTiposAnalisisCcList() {
        return tiposAnalisisCcList;
    }

    public void setTiposAnalisisCcList(List tiposAnalisisCcList) {
        this.tiposAnalisisCcList = tiposAnalisisCcList;
    }

    public HtmlDataTable getFormasFarmaceuticasDataTable() {
        return formasFarmaceuticasDataTable;
    }

    public void setFormasFarmaceuticasDataTable(HtmlDataTable formasFarmaceuticasDataTable) {
        this.formasFarmaceuticasDataTable = formasFarmaceuticasDataTable;
    }

    public List getFormasFarmaceuticasList() {
        return formasFarmaceuticasList;
    }

    public void setFormasFarmaceuticasList(List formasFarmaceuticasList) {
        this.formasFarmaceuticasList = formasFarmaceuticasList;
    }

    public HtmlDataTable getComponentesProdDataTable() {
        return componentesProdDataTable;
    }

    public void setComponentesProdDataTable(HtmlDataTable componentesProdDataTable) {
        this.componentesProdDataTable = componentesProdDataTable;
    }


    public FormasFarmaceuticas getFormasFarmaceuticasSeleccionado() {
        return formasFarmaceuticasSeleccionado;
    }

    public void setFormasFarmaceuticasSeleccionado(FormasFarmaceuticas formasFarmaceuticasSeleccionado) {
        this.formasFarmaceuticasSeleccionado = formasFarmaceuticasSeleccionado;
    }

    public int getCodTipoAnalisisCc() {
        return codTipoAnalisisCc;
    }

    public void setCodTipoAnalisisCc(int codTipoAnalisisCc) {
        this.codTipoAnalisisCc = codTipoAnalisisCc;
    }

    public List getEspecificacionesCcList() {
        return especificacionesCcList;
    }

    public void setEspecificacionesCcList(List especificacionesCcList) {
        this.especificacionesCcList = especificacionesCcList;
    }

    public EspecificacionesFisicasCc getEspecificacionesFisicasCcAgregar() {
        return especificacionesFisicasCcAgregar;
    }

    public void setEspecificacionesFisicasCcAgregar(EspecificacionesFisicasCc especificacionesFisicasCcAgregar) {
        this.especificacionesFisicasCcAgregar = especificacionesFisicasCcAgregar;
    }

    public List getEspecificacionesAgregarList() {
        return especificacionesAgregarList;
    }

    public void setEspecificacionesAgregarList(List especificacionesAgregarList) {
        this.especificacionesAgregarList = especificacionesAgregarList;
    }


    /** Creates a new instance of ManagedEspecificacionesControlCalidad */
    public ManagedEspecificacionesControlCalidad() {
    }
    public void cargarProductos(String cod,ComponentesProd bean){
        try {
            Connection con=null;
            con=Util.openConnection(con);
            String sql="select cod_prod,nombre_prod from productos" +
                    " where cod_estado_prod=1" ;

            System.out.println("select ALL:"+sql);
            ResultSet rs=null;

            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            if(!cod.equals("")){
                sql+=" and cod_prod="+cod;

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
                con.close();
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void cargarEstadoCompProd(String cod,ComponentesProd bean){
        try {
            Connection con=null;
            con=Util.openConnection(con);
            String sql="select COD_ESTADO_COMPPROD,NOMBRE_ESTADO_COMPPROD from ESTADOS_COMPPROD WHERE COD_ESTADO_REGISTRO=1" ;

            System.out.println("select ALL:"+sql);
            ResultSet rs=null;

            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
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
   private void cargarTiposProduccion_action(){
       try
       {
            ManagedAccesoSistema usuario=(ManagedAccesoSistema)Util.getSession("ManagedAccesoSistema");
            Connection con=null;
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select tp.COD_TIPO_PRODUCCION,tp.NOMBRE_TIPO_PRODUCCION from TIPOS_PRODUCCION tp inner join usuarios_area_produccion u on u.cod_area_empresa = tp.cod_area_empresa and u.cod_tipo_permiso = 2 and u.cod_personal = '"+usuario.getUsuarioModuloBean().getCodUsuarioGlobal() +"' order by tp.NOMBRE_TIPO_PRODUCCION";
            System.out.println("consulta cargar tipos_Produccion permisos "+consulta);
            ResultSet res=st.executeQuery(consulta);
            tiposProduccionSelectList.clear();
            
            while(res.next())
            {
                tiposProduccionSelectList.add(new SelectItem(res.getInt("COD_TIPO_PRODUCCION"),res.getString("NOMBRE_TIPO_PRODUCCION")));
            }
            if(tiposProduccionSelectList.size()==0){
                tiposProduccionSelectList.add(new SelectItem(0,"-No habilitado-"));
            }
            res.close();
            st.close();
            con.close();
       }
       catch(Exception ex)
       {
           ex.printStackTrace();
       }
   }
   public String getCargarComponenteProducto(){
        cargarTiposProduccion_action();
        String cod=Util.getParameter("codigo");
        
        if(cod!=null){
            cod=cod;
        }
        if(componentesProdbean.getTipoProduccion().getCodTipoProduccion()==0)
        {
            componentesProdbean.getTipoProduccion().setCodTipoProduccion(tiposProduccionSelectList.size()==0?-1:Integer.parseInt(tiposProduccionSelectList.get(0).getValue().toString()));
        }
        cargarProductos("",null);
        cargarEstadoCompProd("",null);
        this.cargarComponentesProd();
       return null;
   }
   private void cargarComponentesProd(){
        try {
            ManagedAccesoSistema usuario=(ManagedAccesoSistema)Util.getSession("ManagedAccesoSistema");

            String sql="select cp.COD_FORMA,cp.COD_COMPPROD,cp.nombre_prod_semiterminado,ff.cod_forma,ff.nombre_forma,cp.VOLUMENPESO_ENVASEPRIM,c.COD_COLORPRESPRIMARIA,c.NOMBRE_COLORPRESPRIMARIA,  " +
                     " s.COD_SABOR,s.NOMBRE_SABOR,ae.COD_AREA_EMPRESA,ae.NOMBRE_AREA_EMPRESA,cp.NOMBRE_GENERICO,cp.REG_SANITARIO," +
                     "cp.FECHA_VENCIMIENTO_RS,cp.VIDA_UTIL,ec.COD_ESTADO_COMPPROD,ec.NOMBRE_ESTADO_COMPPROD,cp.COD_COMPUESTOPROD,tp.NOMBRE_TIPO_PRODUCCION,cp.CONCENTRACION_ENVASE_PRIMARIO" +
                    " from componentes_prod cp left outer join FORMAS_FARMACEUTICAS ff on ff.cod_forma = cp.COD_FORMA " +
                    " inner join AREAS_EMPRESA ae on ae.COD_AREA_EMPRESA = cp.COD_AREA_EMPRESA " +
                    " inner join ESTADOS_COMPPROD ec on ec.COD_ESTADO_COMPPROD = cp.COD_ESTADO_COMPPROD " +
                    " left outer join COLORES_PRESPRIMARIA c on c.COD_COLORPRESPRIMARIA = cp.COD_COLORPRESPRIMARIA " +
                    " left outer join SABORES_PRODUCTO s on s.COD_SABOR = cp.COD_SABOR " +
                    " inner join TIPOS_PRODUCCION tp on tp.COD_TIPO_PRODUCCION=cp.COD_TIPO_PRODUCCION" +
                    " inner join usuarios_area_produccion u on u.cod_area_empresa = tp.cod_area_empresa and u.cod_tipo_permiso = 2 and u.cod_personal = '"+usuario.getUsuarioModuloBean().getCodUsuarioGlobal()+"' " +
                    " where ec.cod_estado_compprod = cp.cod_estado_compprod "+
                    ((componentesProdbean.getProducto().getCodProducto().equals("")||componentesProdbean.getProducto().getCodProducto().equals("0"))?"":" and cp.cod_prod="+componentesProdbean.getProducto().getCodProducto())+
                    ((componentesProdbean.getEstadoCompProd().getCodEstadoCompProd() == 0 )?"":" and cp.COD_ESTADO_COMPPROD="+componentesProdbean.getEstadoCompProd().getCodEstadoCompProd())+
                    ((componentesProdbean.getTipoProduccion().getCodTipoProduccion()>0)?" and cp.COD_TIPO_PRODUCCION="+componentesProdbean.getTipoProduccion().getCodTipoProduccion():"")+
                    " order by cp.nombre_prod_semiterminado ";
            System.out.println("cargar componente especificaciones :"+sql);
            Connection con=null;
             con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(sql);
            rs.last();
            int rows=rs.getRow();
            componentesProductoList.clear();
            rs.first();
            String cod="";
            for(int i=0;i<rows;i++){
                ComponentesProd componentesProd=new ComponentesProd();
                componentesProd.setConcentracionEnvasePrimario(rs.getString("CONCENTRACION_ENVASE_PRIMARIO"));
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
                componentesProd.getTipoProduccion().setNombreTipoProduccion(rs.getString("NOMBRE_TIPO_PRODUCCION"));


                componentesProductoList.add(componentesProd);
                rs.next();
            }

            if(rs!=null){
                rs.close();
                st.close();
                con.close();
            }


        } catch (SQLException e) {
            e.printStackTrace();
        }

    }

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
    public String agregarConcentracion_Action()
    {
        componentesProd=(ComponentesProd)componentesProdDataTable.getRowData();
        this.redireccionar("navegadorVersionesConcentracion.jsf");
        return null;
    }
    public String getCargarEditarVersionMicrobiologicaProducto()
    {
        try
          {
              Connection con=null;
              con=Util.openConnection(con);
              Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY) ;
              String consulta="select ISNULL(trcc.COD_REFERENCIACC,0) as codReferencia,efcc.COD_ESPECIFICACION,efcc.COD_TIPO_RESULTADO_ANALISIS,efcc.NOMBRE_ESPECIFICACION,ISNULL(efp.DESCRIPCION,'') as descripcion,"+
                              " ISNULL(efp.LIMITE_INFERIOR,0) as limiteInferior,ISNULL(efp.VALOR_EXACTO,0) AS valorExacto,ISNULL(efp.LIMITE_SUPERIOR,0) as limiteSuperior,ISNULL(efp.ESTADO,2) as estadoRegistro" +
                              " ,ISNULL(tra.SIMBOLO,'') as SIMBOLO,ISNULL(efcc.COEFICIENTE,'') as COEFICIENTE"+
                              " from ESPECIFICACIONES_MICROBIOLOGIA_PRODUCTO efp inner join"+
                              " ESPECIFICACIONES_MICROBIOLOGIA efcc on efcc.COD_ESPECIFICACION =efp.COD_ESPECIFICACION"+
                              " left outer join TIPOS_REFERENCIACC trcc on trcc.COD_REFERENCIACC=efp.COD_REFERENCIA_CC" +
                              " left outer join TIPOS_RESULTADOS_ANALISIS tra on tra.COD_TIPO_RESULTADO_ANALISIS=efcc.COD_TIPO_RESULTADO_ANALISIS"+
                              " where efp.COD_COMPROD ='"+componentesProd.getCodCompprod()+"' and efp.COD_VERSION_ESPECIFICACION_PRODUCTO = '"+versionEspecificacionesProductoMicrobiologico.getCodVersionEspecificacionProducto()+"' order by efcc.NOMBRE_ESPECIFICACION";
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
                    bean.getEspecificacionMicrobiologiaCc().setCoeficiente(res.getString("COEFICIENTE"));
                    bean.setLimiteInferior(res.getDouble("limiteInferior"));
                    bean.setLimiteSuperior(res.getDouble("limiteSuperior"));
                    bean.setDescripcion(res.getString("descripcion"));
                    bean.setValorExacto(res.getDouble("valorExacto"));
                    bean.getEspecificacionMicrobiologiaCc().getTiposReferenciaCc().setCodReferenciaCc(res.getInt("codReferencia"));
                    bean.getEspecificacionMicrobiologiaCc().getTipoResultadoAnalisis().setSimbolo(res.getString("SIMBOLO"));
                    bean.getEstado().setCodEstadoRegistro(res.getString("estadoRegistro"));
                    listaEspecificacionesMicrobiologia.add(bean);
              }
              this.cargarTiposRefenciasCc();
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
    public String getCargarAgregarVersionMicrobiologicaProducto()
    {
        versionEspecificacionRegistrar=new VersionEspecificacionesProducto();
        versionEspecificacionesProductoMicrobiologico=versionActual(3,componentesProd.getCodCompprod());
        try
          {
              Connection con=null;
              con=Util.openConnection(con);
              Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY) ;
              String consulta="select ISNULL(trcc.COD_REFERENCIACC,0) as codReferencia,efcc.COD_ESPECIFICACION,efcc.COD_TIPO_RESULTADO_ANALISIS,efcc.NOMBRE_ESPECIFICACION,ISNULL(efp.DESCRIPCION,'') as descripcion,"+
                              " ISNULL(efp.LIMITE_INFERIOR,0) as limiteInferior,ISNULL(efp.VALOR_EXACTO,0) AS valorExacto,ISNULL(efp.LIMITE_SUPERIOR,0) as limiteSuperior,ISNULL(efp.ESTADO,2) as estadoRegistro" +
                              " ,ISNULL(tra.SIMBOLO,'') as SIMBOLO,ISNULL(efcc.COEFICIENTE,'') as COEFICIENTE"+
                              " from ESPECIFICACIONES_ANALISIS_FORMAFAR eff inner join ESPECIFICACIONES_MICROBIOLOGIA efcc"+
                              " on efcc.COD_ESPECIFICACION=eff.COD_ESPECIFICACION left outer join ESPECIFICACIONES_MICROBIOLOGIA_PRODUCTO efp"+
                              " on efp.COD_ESPECIFICACION=efcc.COD_ESPECIFICACION and efp.COD_COMPROD='"+componentesProd.getCodCompprod()+"' and efp.COD_VERSION_ESPECIFICACION_PRODUCTO='"+versionEspecificacionesProductoMicrobiologico.getCodVersionEspecificacionProducto()+"'"+
                              " left outer join TIPOS_REFERENCIACC trcc on trcc.COD_REFERENCIACC=efp.COD_REFERENCIA_CC" +
                              " left outer join TIPOS_RESULTADOS_ANALISIS tra on tra.COD_TIPO_RESULTADO_ANALISIS=efcc.COD_TIPO_RESULTADO_ANALISIS"+
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
                    bean.getEspecificacionMicrobiologiaCc().setCoeficiente(res.getString("COEFICIENTE"));
                    bean.setLimiteInferior(res.getDouble("limiteInferior"));
                    bean.setLimiteSuperior(res.getDouble("limiteSuperior"));
                    bean.setDescripcion(res.getString("descripcion"));
                    bean.setValorExacto(res.getDouble("valorExacto"));
                    bean.getEspecificacionMicrobiologiaCc().getTiposReferenciaCc().setCodReferenciaCc(res.getInt("codReferencia"));
                    bean.getEspecificacionMicrobiologiaCc().getTipoResultadoAnalisis().setSimbolo(res.getString("SIMBOLO"));
                    bean.getEstado().setCodEstadoRegistro(res.getString("estadoRegistro"));
                    listaEspecificacionesMicrobiologia.add(bean);
              }
              this.cargarTiposRefenciasCc();
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
     public String agregarAnalisisMicrobiologia_Action()
     {
          componentesProd = (ComponentesProd)componentesProdDataTable.getRowData();

          this.redireccionar("navegadorVersionesAnalisisMicrobiologico.jsf");
          return null;
     }
     public void cargarTiposEspecificacionesFisicas()
     {
         try
         {
             Connection con=null;
             con=Util.openConnection(con);
             Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
             String consulta="select tef.COD_TIPO_ESPECIFICACION_FISICA,tef.NOMBRE_TIPO_ESPECIFICACION_FISICA "+
                             " from TIPOS_ESPECIFICACIONES_FISICAS tef order by tef.NOMBRE_TIPO_ESPECIFICACION_FISICA";
             ResultSet res=st.executeQuery(consulta);
             tiposEspecificacionesFisicas.clear();
             tiposEspecificacionesFisicas.add(new SelectItem(0,"-NINGUNO-"));
             while(res.next())
             {
                 tiposEspecificacionesFisicas.add(new SelectItem(res.getInt("COD_TIPO_ESPECIFICACION_FISICA"),res.getString("NOMBRE_TIPO_ESPECIFICACION_FISICA")));
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
     private VersionEspecificacionesProducto versionActual(int codTipoAnalisis,String codCompProd)
     {
         VersionEspecificacionesProducto actual= new VersionEspecificacionesProducto();
         try
         {
             String consulta="select vep.OBSERVACION, vep.COD_VERSION_ESPECIFICACION_PRODUCTO, vep.FECHA_CREACION,vep.NRO_VERSION_ESPECIFICACION_PRODUCTO"+
                            " from VERSION_ESPECIFICACIONES_PRODUCTO vep where vep.COD_COMPPROD='"+codCompProd+"'"+
                            " and vep.COD_TIPO_ANALISIS='"+codTipoAnalisis+"' and vep.VERSION_ACTIVA=1";
             System.out.println("consult cargar version actual "+consulta);
             Connection con=null;
             con=Util.openConnection(con);
             Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
             ResultSet res=st.executeQuery(consulta);
             if(res.next())
             {
                 actual.setCodVersionEspecificacionProducto(res.getInt("COD_VERSION_ESPECIFICACION_PRODUCTO"));
                 actual.setNroVersionEspecificacionProducto(res.getInt("NRO_VERSION_ESPECIFICACION_PRODUCTO"));
                 actual.setFechaCreacion(res.getTimestamp("FECHA_CREACION"));
                 actual.setObservacion(res.getString("OBSERVACION"));
             }
             res.close();
             st.close();
             con.close();
         }
         catch(SQLException sqlex)
         {
             sqlex.printStackTrace();
         }
         catch(Exception ex)
         {
             ex.printStackTrace();
         }
         return actual;
     }
     public String getCargarEditarVersionAnalisisFisico_action()
     {
       
         this.cargarTiposEspecificacionesFisicas();
        try {

             String consulta="select ISNULL(trcc.COD_REFERENCIACC,0) as codTipoReferencia,efcc.COD_ESPECIFICACION,ISNULL(efcc.COEFICIENTE,'') AS COEFICIENTE,efcc.COD_TIPO_RESULTADO_ANALISIS,efcc.NOMBRE_ESPECIFICACION,ISNULL(efp.DESCRIPCION,'') as descripcion,"+
                             " ISNULL(efp.LIMITE_INFERIOR,0) as limiteInferior,ISNULL(efp.LIMITE_SUPERIOR,0) as limiteSuperior," +
                             " ISNULL(efp.VALOR_EXACTO,0) as valorExacto,ISNULL(efp.ESTADO,2) as estado,isnull(tra.SIMBOLO,'') as simbolo" +
                             " ,isnull(tef.COD_TIPO_ESPECIFICACION_FISICA,0) as codTipoEspecificacion,"+
                             " isnull(tef.NOMBRE_TIPO_ESPECIFICACION_FISICA,'') as nombreTipoEspcificacion"+
                             " from ESPECIFICACIONES_FISICAS_PRODUCTO efp inner join"+
                             " ESPECIFICACIONES_FISICAS_CC efcc on efcc.COD_ESPECIFICACION =efp.COD_ESPECIFICACION" +
                             " left outer join TIPOS_REFERENCIACC trcc on trcc.COD_REFERENCIACC=efp.COD_REFERENCIA_CC"+
                             " left outer join TIPOS_RESULTADOS_ANALISIS tra on tra.COD_TIPO_RESULTADO_ANALISIS=efcc.COD_TIPO_RESULTADO_ANALISIS" +
                             " left outer join TIPOS_ESPECIFICACIONES_FISICAS tef on"+
                             " tef.COD_TIPO_ESPECIFICACION_FISICA=efp.COD_TIPO_ESPECIFICACION_FISICA" +
                             " where efp.COD_PRODUCTO='"+componentesProd.getCodCompprod()+"' and efp.COD_VERSION_ESPECIFICACION_PRODUCTO = '"+versionEspecificacionesProductoFisico.getCodVersionEspecificacionProducto()+"' order by efcc.NOMBRE_ESPECIFICACION";
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
                 bean.getEspecificacionFisicaCC().setCoeficiente(res.getString("COEFICIENTE"));
                 bean.getEspecificacionFisicaCC().getTipoResultadoAnalisis().setSimbolo(res.getString("simbolo"));
                 bean.getEstado().setCodEstadoRegistro(res.getString("estado"));
                 bean.getTiposEspecificacionesFisicas().setCodTipoEspecificacionFisica(res.getInt("codTipoEspecificacion"));
                 listaEspecificacionesFisicasProducto.add(bean);
             }
             this.cargarTiposRefenciasCc();
             res.close();
             st.close();
             con.close();

         } catch (Exception e) {
             e.printStackTrace();
         }
         return null;
     }

     public String getCargarAgregarAnalisisFisico_action()
     {
        versionEspecificacionRegistrar=new VersionEspecificacionesProducto();
        versionEspecificacionesProductoFisico=versionActual(1,componentesProd.getCodCompprod());
         this.cargarTiposEspecificacionesFisicas();
        try {

             String consulta="select ISNULL(trcc.COD_REFERENCIACC,0) as codTipoReferencia,efcc.COD_ESPECIFICACION,ISNULL(efcc.COEFICIENTE,'') AS COEFICIENTE,efcc.COD_TIPO_RESULTADO_ANALISIS,efcc.NOMBRE_ESPECIFICACION,ISNULL(efp.DESCRIPCION,'') as descripcion,"+
                             " ISNULL(efp.LIMITE_INFERIOR,0) as limiteInferior,ISNULL(efp.LIMITE_SUPERIOR,0) as limiteSuperior," +
                             " ISNULL(efp.VALOR_EXACTO,0) as valorExacto,ISNULL(efp.ESTADO,2) as estado,isnull(tra.SIMBOLO,'') as simbolo" +
                             " ,isnull(tef.COD_TIPO_ESPECIFICACION_FISICA,0) as codTipoEspecificacion,"+
                             " isnull(tef.NOMBRE_TIPO_ESPECIFICACION_FISICA,'') as nombreTipoEspcificacion"+
                             " from ESPECIFICACIONES_ANALISIS_FORMAFAR eff inner join ESPECIFICACIONES_FISICAS_CC efcc"+
                             " on efcc.COD_ESPECIFICACION=eff.COD_ESPECIFICACION left outer join ESPECIFICACIONES_FISICAS_PRODUCTO efp"+
                             " on efp.COD_ESPECIFICACION=efcc.COD_ESPECIFICACION and efp.COD_PRODUCTO='"+componentesProd.getCodCompprod()+"' and efp.COD_VERSION_ESPECIFICACION_PRODUCTO='"+versionEspecificacionesProductoFisico.getCodVersionEspecificacionProducto()+"'" +
                             " left outer join TIPOS_REFERENCIACC trcc on trcc.COD_REFERENCIACC=efp.COD_REFERENCIA_CC"+
                             " left outer join TIPOS_RESULTADOS_ANALISIS tra on tra.COD_TIPO_RESULTADO_ANALISIS=efcc.COD_TIPO_RESULTADO_ANALISIS" +
                             " left outer join TIPOS_ESPECIFICACIONES_FISICAS tef on"+
                             " tef.COD_TIPO_ESPECIFICACION_FISICA=efp.COD_TIPO_ESPECIFICACION_FISICA" +
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
                 bean.getEspecificacionFisicaCC().setCoeficiente(res.getString("COEFICIENTE"));
                 bean.getEspecificacionFisicaCC().getTipoResultadoAnalisis().setSimbolo(res.getString("simbolo"));
                 bean.getEstado().setCodEstadoRegistro(res.getString("estado"));
                 bean.getTiposEspecificacionesFisicas().setCodTipoEspecificacionFisica(res.getInt("codTipoEspecificacion"));
                 listaEspecificacionesFisicasProducto.add(bean);

             }
             this.cargarTiposRefenciasCc();
             res.close();
             st.close();
             con.close();

         } catch (Exception e) {
             e.printStackTrace();
         }
         return null;
     }

     public String agregarAnalisisFisico_action(){
         componentesProd = (ComponentesProd)componentesProdDataTable.getRowData();
         this.redireccionar("navegadorVersionesAnalisisFisico.jsf");
         return null;
     }
     public String guardarNuevaVersionConcentracion_action()throws SQLException
     {
         mensaje="";
         Connection con=null;
         try
         {
             con=Util.openConnection(con);
             con.setAutoCommit(false);
             ManagedAccesoSistema managed=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
             String consulta=" select isnull(MAX(v.COD_VERSION_ESPECIFICACION_PRODUCTO),0)+1 as codVersion  from VERSION_ESPECIFICACIONES_PRODUCTO v ";
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta);
            int codVersionEspecificacion=0;
            if(res.next())codVersionEspecificacion=res.getInt("codVersion");
            SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
            consulta="UPDATE  VERSION_ESPECIFICACIONES_PRODUCTO SET VERSION_ACTIVA=0 WHERE COD_COMPPROD='"+componentesProd.getCodCompprod()+"' and COD_TIPO_ANALISIS=0;" +
                    " INSERT INTO VERSION_ESPECIFICACIONES_PRODUCTO(COD_VERSION_ESPECIFICACION_PRODUCTO,NRO_VERSION_ESPECIFICACION_PRODUCTO"+
                     " ,FECHA_CREACION, VERSION_ACTIVA, COD_TIPO_ANALISIS, COD_COMPPROD, OBSERVACION,COD_PERSONAL_REGISTRA,COD_PERSONAL_MODIFICA)"+
                     "VALUES ('"+codVersionEspecificacion+"',(select isnull(max(v.NRO_VERSION_ESPECIFICACION_PRODUCTO),0)+1 from VERSION_ESPECIFICACIONES_PRODUCTO v where v.COD_TIPO_ANALISIS=0 and v.COD_COMPPROD='"+componentesProd.getCodCompprod()+"'),"+
                     "'"+sdf.format(new Date())+"',1,0,'"+componentesProd.getCodCompprod()+"','"+versionEspecificacionRegistrar.getObservacion()+"'" +
                     ",'"+managed.getUsuarioModuloBean().getCodUsuarioGlobal()+"',0)";
            System.out.println("consulta insertar nueva version  "+consulta);
            PreparedStatement pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se registro la nueva version" );
            
             for(ComponentesProdConcentracion bean:componentesProdConcentracionList)
             {
                     consulta="INSERT INTO COMPONENTES_PROD_CONCENTRACION(COD_COMPPROD, COD_MATERIAL,"+
                              " CANTIDAD, COD_UNIDAD_MEDIDA, UNIDAD_PRODUCTO, COD_ESTADO_REGISTRO" +
                              ",CANTIDAD_EQUIVALENCIA,NOMBRE_MATERIAL_EQUIVALENCIA,COD_UNIDAD_MEDIDA_EQUIVALENCIA,COD_VERSION_ESPECIFICACION_PRODUCTO)"+
                              " VALUES ('"+componentesProd.getCodCompprod()+"', '"+bean.getMateriales().getCodMaterial()+"'," +
                              "'"+bean.getCantidad()+"', '"+bean.getUnidadesMedida().getCodUnidadMedida()+"',"+
                              "'"+unidadesProducto+"','"+bean.getEstadoRegistro().getCodEstadoRegistro()+"'" +
                              ",'"+bean.getCantidadEquivalencia()+"','"+bean.getNombreMaterialEquivalencia()+"'," +
                              "'"+bean.getUnidadMedidaEquivalencia().getCodUnidadMedida()+"','"+codVersionEspecificacion+"')";
                     System.out.println("consulta insert "+consulta);
                     pst=con.prepareStatement(consulta);
                     if(pst.executeUpdate()>0)System.out.println("se inserto la concentracion");
                     
             }
             consulta="select m.NOMBRE_CCC,cp.CANTIDAD,um.ABREVIATURA"+
                      " from COMPONENTES_PROD_CONCENTRACION cp inner join materiales m on cp.COD_MATERIAL=m.COD_MATERIAL"+
                      " inner join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=cp.COD_UNIDAD_MEDIDA"+
                      " where cp.COD_COMPPROD='"+componentesProd.getCodCompprod()+"' and cp.COD_VERSION_ESPECIFICACION_PRODUCTO='"+codVersionEspecificacion+"'" +
                      " and cp.COD_ESTADO_REGISTRO=1"+
                      " order by m.NOMBRE_CCC";
             res=st.executeQuery(consulta);
             String concentracion="";
             while(res.next())
             {
                 concentracion+=(concentracion.equals("")?"":",")+res.getString("NOMBRE_CCC")+" "+res.getDouble("CANTIDAD")+" "+res.getString("ABREVIATURA");
             }
             concentracion+=(concentracion.equals("")?"":"/"+unidadesProducto);
             consulta="update COMPONENTES_PROD set CONCENTRACION_ENVASE_PRIMARIO='"+concentracion+"' where COD_COMPPROD='"+componentesProd.getCodCompprod()+"'";
             System.out.println("consulta update componentes Prod "+consulta);
             pst=con.prepareStatement(consulta);
             if(pst.executeUpdate()>0)System.out.println("se actualizo la concentracion del producto");
             con.commit();
             mensaje="1";
             pst.close();
             con.close();
         }
         catch(SQLException ex)
         {
             con.rollback();
             con.close();
             ex.printStackTrace();
             mensaje="Ocurrio un error al momento de guardar la nueva version, intente de nuevo\n Si el problema persiste favor comunicar con sistemas.";
         }
         
         //this.redireccionar("navegador_componentesProducto.jsf");
         return null;
     }
     public String guardarEditarVersionConcentracion_action()throws SQLException
     {
         mensaje="";
          Connection con=null;
         try
         {
             con=Util.openConnection(con);
             con.setAutoCommit(false);
             ManagedAccesoSistema managed=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
             String consulta="update VERSION_ESPECIFICACIONES_PRODUCTO set COD_PERSONAL_MODIFICA='"+managed.getUsuarioModuloBean().getCodUsuarioGlobal()+"', OBSERVACION='"+versionConcentracionProducto.getObservacion()+"'" +
                             " where COD_VERSION_ESPECIFICACION_PRODUCTO='"+versionConcentracionProducto.getCodVersionEspecificacionProducto()+"'";
             System.out.println("consulta editar version concentracion "+consulta);
             PreparedStatement pst=con.prepareStatement(consulta);
             if(pst.executeUpdate()>0)System.out.println("se guardo la edicion de la version de la concentracion");

             consulta="delete COMPONENTES_PROD_CONCENTRACION where COD_COMPPROD='"+componentesProd.getCodCompprod()+"'" +
                             " and COD_VERSION_ESPECIFICACION_PRODUCTO='"+versionConcentracionProducto.getCodVersionEspecificacionProducto()+"'";
             System.out.println("consulta delete componentes prod "+consulta);
             pst=con.prepareStatement(consulta);
             if(pst.executeUpdate()>0)System.out.println("se eliminaron anteriores concentraciones");
             
             for(ComponentesProdConcentracion bean:componentesProdConcentracionList)
             {
                     consulta="INSERT INTO COMPONENTES_PROD_CONCENTRACION(COD_COMPPROD, COD_MATERIAL,"+
                              " CANTIDAD, COD_UNIDAD_MEDIDA, UNIDAD_PRODUCTO, COD_ESTADO_REGISTRO" +
                              ",CANTIDAD_EQUIVALENCIA,NOMBRE_MATERIAL_EQUIVALENCIA,COD_UNIDAD_MEDIDA_EQUIVALENCIA,COD_VERSION_ESPECIFICACION_PRODUCTO)"+
                              " VALUES ('"+componentesProd.getCodCompprod()+"', '"+bean.getMateriales().getCodMaterial()+"'," +
                              "'"+bean.getCantidad()+"', '"+bean.getUnidadesMedida().getCodUnidadMedida()+"',"+
                              "'"+unidadesProducto+"','"+bean.getEstadoRegistro().getCodEstadoRegistro()+"'" +
                              ",'"+bean.getCantidadEquivalencia()+"','"+bean.getNombreMaterialEquivalencia()+"'," +
                              "'"+bean.getUnidadMedidaEquivalencia().getCodUnidadMedida()+"','"+versionConcentracionProducto.getCodVersionEspecificacionProducto()+"')";
                     System.out.println("consulta insert "+consulta);
                     pst=con.prepareStatement(consulta);
                     if(pst.executeUpdate()>0)System.out.println("se inserto la concentracion");
                     
             }
             consulta="select m.NOMBRE_CCC,cp.CANTIDAD,um.ABREVIATURA"+
                      " from COMPONENTES_PROD_CONCENTRACION cp inner join materiales m on cp.COD_MATERIAL=m.COD_MATERIAL"+
                      " inner join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=cp.COD_UNIDAD_MEDIDA"+
                      " where cp.COD_COMPPROD='"+componentesProd.getCodCompprod()+"' and cp.COD_VERSION_ESPECIFICACION_PRODUCTO='"+versionConcentracionProducto.getCodVersionEspecificacionProducto()+"'" +
                      " and cp.COD_ESTADO_REGISTRO=1"+
                      " order by m.NOMBRE_CCC";
             Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
             ResultSet res=st.executeQuery(consulta);
             String concentracionProducto="";
             while(res.next())
             {
                 concentracionProducto+=(concentracionProducto.equals("")?"":",")+res.getString("NOMBRE_CCC")+" "+res.getDouble("CANTIDAD")+" "+res.getString("ABREVIATURA");
             }
             concentracionProducto+=(concentracionProducto.equals("")?"":"/"+unidadesProducto);
             consulta="update COMPONENTES_PROD set CONCENTRACION_ENVASE_PRIMARIO='"+concentracionProducto+"' where COD_COMPPROD='"+componentesProd.getCodCompprod()+"'";
             System.out.println("consulta update componentes Prod "+consulta);
             pst=con.prepareStatement(consulta);
             if(pst.executeUpdate()>0)System.out.println("se actualizo la concentracion del producto");
             con.commit();
             mensaje="1";
             pst.close();
             con.close();
         }
         catch(SQLException ex)
         {
             con.rollback();
             con.close();
             ex.printStackTrace();
             mensaje="Ocurrio un error al momento de guardar la edicion de la version, intente de nuevo\n Si el problema persiste favor comunicar con sistemas.";
         }
         //this.redireccionar("navegador_componentesProducto.jsf");
         return null;
     }
     public String getCargarEditarVersionConcentracionProd()
     {
         try
         {
            Connection con=null;
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta=" select m.NOMBRE_CCC,m.COD_MATERIAL,isnull(cpc.cod_estado_registro,2) as registrado,"+
                            " ISNULL(cpc.CANTIDAD,0) as cantidad,ISNULL(cpc.UNIDAD_PRODUCTO,'') as unidadProducto,"+
                            " ISNULL(cpc.COD_UNIDAD_MEDIDA,m.COD_UNIDAD_MEDIDA) as unidadMedida" +
                            " ,isnull(cpc.CANTIDAD_EQUIVALENCIA,0) as CANTIDAD_EQUIVALENCIA"+
                            " ,isnull(cpc.NOMBRE_MATERIAL_EQUIVALENCIA,'') as NOMBRE_MATERIAL_EQUIVALENCIA"+
                            " ,isnull(cpc.COD_UNIDAD_MEDIDA_EQUIVALENCIA,0) as COD_UNIDAD_MEDIDA_EQUIVALENCIA"+
                            " from  MATERIALES m inner join COMPONENTES_PROD_CONCENTRACION cpc on"+
                            " m.COD_MATERIAL=cpc.COD_MATERIAL"+
                            " where cpc.COD_COMPPROD = '"+componentesProd.getCodCompprod()+"' and cpc.COD_VERSION_ESPECIFICACION_PRODUCTO = '"+versionConcentracionProducto.getCodVersionEspecificacionProducto()+"'"+
                            " group by m.NOMBRE_CCC,m.COD_MATERIAL,cpc.COD_ESTADO_REGISTRO, cpc.CANTIDAD,cpc.UNIDAD_PRODUCTO,"+
                            " cpc.COD_UNIDAD_MEDIDA,cpc.CANTIDAD_EQUIVALENCIA,cpc.NOMBRE_MATERIAL_EQUIVALENCIA,cpc.COD_UNIDAD_MEDIDA_EQUIVALENCIA,m.COD_UNIDAD_MEDIDA"+
                            " order by m.NOMBRE_CCC";
             System.out.println("consulta cargar concentraciones materiales "+consulta);
            ResultSet res=st.executeQuery(consulta);
            componentesProdConcentracionList.clear();
            while(res.next())
            {
                ComponentesProdConcentracion nuevo=new ComponentesProdConcentracion();
                nuevo.getMateriales().setCodMaterial(res.getString("COD_MATERIAL"));
                nuevo.getMateriales().setNombreCCC(res.getString("NOMBRE_CCC"));
                nuevo.getUnidadesMedida().setCodUnidadMedida(res.getString("unidadMedida"));
                nuevo.getEstadoRegistro().setCodEstadoRegistro(res.getString("registrado"));
                nuevo.setUnidadProducto(res.getString("unidadProducto"));
                nuevo.setCantidad(res.getDouble("cantidad"));
                nuevo.setNombreMaterialEquivalencia(res.getString("NOMBRE_MATERIAL_EQUIVALENCIA"));
                nuevo.setCantidadEquivalencia(res.getDouble("CANTIDAD_EQUIVALENCIA"));
                nuevo.getUnidadMedidaEquivalencia().setCodUnidadMedida(res.getString("COD_UNIDAD_MEDIDA_EQUIVALENCIA"));
                unidadesProducto=nuevo.getUnidadProducto();
                componentesProdConcentracionList.add(nuevo);
            }
            consulta=" select um.COD_UNIDAD_MEDIDA, um.ABREVIATURA from UNIDADES_MEDIDA um where um.COD_ESTADO_REGISTRO=1 order by um.ABREVIATURA";
            res=st.executeQuery(consulta);
            unidadesMedidaList.clear();
            while(res.next())
            {
                unidadesMedidaList.add(new SelectItem(res.getString("COD_UNIDAD_MEDIDA"),res.getString("ABREVIATURA")));
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
     public String getCargarAgregarVersionConcentracionMaterialesProd()
     {
         versionEspecificacionRegistrar=new VersionEspecificacionesProducto();
        versionConcentracionProducto=versionActual(0,componentesProd.getCodCompprod());
         try
         {
            Connection con=null;
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta=" select m.NOMBRE_CCC,m.COD_MATERIAL,isnull(cpc.cod_estado_registro,2) as registrado,"+
                            " ISNULL(cpc.CANTIDAD,0) as cantidad,ISNULL(cpc.UNIDAD_PRODUCTO,'') as unidadProducto,"+
                            " ISNULL(cpc.COD_UNIDAD_MEDIDA,m.COD_UNIDAD_MEDIDA) as unidadMedida" +
                            " ,isnull(cpc.CANTIDAD_EQUIVALENCIA,0) as CANTIDAD_EQUIVALENCIA"+
                            " ,isnull(cpc.NOMBRE_MATERIAL_EQUIVALENCIA,'') as NOMBRE_MATERIAL_EQUIVALENCIA"+
                            " ,isnull(cpc.COD_UNIDAD_MEDIDA_EQUIVALENCIA,0) as COD_UNIDAD_MEDIDA_EQUIVALENCIA"+
                            " from FORMULA_MAESTRA fm inner join FORMULA_MAESTRA_DETALLE_MP fmd on fm.COD_FORMULA_MAESTRA ="+
                            " fmd.COD_FORMULA_MAESTRA inner join MATERIALES m on m.COD_MATERIAL = fmd.COD_MATERIAL"+
                            " left outer join COMPONENTES_PROD_CONCENTRACION cpc on"+
                            " cpc.COD_COMPPROD=fm.COD_COMPPROD and cpc.COD_MATERIAL=fmd.COD_MATERIAL and cpc.COD_VERSION_ESPECIFICACION_PRODUCTO='"+versionConcentracionProducto.getCodVersionEspecificacionProducto()+"'"+
                            " where fm.COD_COMPPROD = '"+componentesProd.getCodCompprod()+"' and m.COD_GRUPO in (2,3,4,99) and fm.COD_ESTADO_REGISTRO=1 "+
                            " group by m.NOMBRE_CCC,m.COD_MATERIAL,cpc.COD_ESTADO_REGISTRO, cpc.CANTIDAD,cpc.UNIDAD_PRODUCTO,"+
                            " cpc.COD_UNIDAD_MEDIDA,cpc.CANTIDAD_EQUIVALENCIA,cpc.NOMBRE_MATERIAL_EQUIVALENCIA,cpc.COD_UNIDAD_MEDIDA_EQUIVALENCIA,m.COD_UNIDAD_MEDIDA"+
                            " order by m.NOMBRE_CCC";
             System.out.println("consulta cargar concentraciones materiales "+consulta);
            ResultSet res=st.executeQuery(consulta);
            componentesProdConcentracionList.clear();
            while(res.next())
            {
                ComponentesProdConcentracion nuevo=new ComponentesProdConcentracion();
                nuevo.getMateriales().setCodMaterial(res.getString("COD_MATERIAL"));
                nuevo.getMateriales().setNombreCCC(res.getString("NOMBRE_CCC"));
                nuevo.getUnidadesMedida().setCodUnidadMedida(res.getString("unidadMedida"));
                nuevo.getEstadoRegistro().setCodEstadoRegistro(res.getString("registrado"));
                nuevo.setUnidadProducto(res.getString("unidadProducto"));
                nuevo.setCantidad(res.getDouble("cantidad"));
                nuevo.setNombreMaterialEquivalencia(res.getString("NOMBRE_MATERIAL_EQUIVALENCIA"));
                nuevo.setCantidadEquivalencia(res.getDouble("CANTIDAD_EQUIVALENCIA"));
                nuevo.getUnidadMedidaEquivalencia().setCodUnidadMedida(res.getString("COD_UNIDAD_MEDIDA_EQUIVALENCIA"));
                unidadesProducto=nuevo.getUnidadProducto();
                componentesProdConcentracionList.add(nuevo);
            }
            consulta=" select um.COD_UNIDAD_MEDIDA, um.ABREVIATURA from UNIDADES_MEDIDA um where um.COD_ESTADO_REGISTRO=1 order by um.ABREVIATURA";
            res=st.executeQuery(consulta);
            unidadesMedidaList.clear();
            while(res.next())
            {
                unidadesMedidaList.add(new SelectItem(res.getString("COD_UNIDAD_MEDIDA"),res.getString("ABREVIATURA")));
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
     private void cargarMaterialesPrincipioActivoVersion(String codComprod,int codVersion)
     {
         try
         {
             Connection con=null;
             con=Util.openConnection(con);
             Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
             String consulta=" select m.NOMBRE_CCC,m.COD_MATERIAL,ISNULL(eqp.ESTADO, 1) as estado"+
                             " from MATERIALES m inner join ESPECIFICACIONES_QUIMICAS_PRODUCTO eqp on eqp.COD_MATERIAL=m.COD_MATERIAL"+
                             " where eqp.COD_VERSION_ESPECIFICACION_PRODUCTO = '"+codVersion+"' and eqp.COD_PRODUCTO='"+codComprod+"'"+
                             " group by m.NOMBRE_CCC,m.COD_MATERIAL,eqp.ESTADO order by m.NOMBRE_CCC";
             System.out.println("consulta materiales principio activo "+consulta);
             ResultSet res=st.executeQuery(consulta);
             listaMaterialesPrincipioActivo.clear();
             String codMaterialesPrincipioActivo="";
             while(res.next())
             {
                Materiales bean= new Materiales();
                bean.setCodMaterial(res.getString("COD_MATERIAL"));
                codMaterialesPrincipioActivo+=(codMaterialesPrincipioActivo.equals("")?"":",")+res.getString("COD_MATERIAL");
                bean.setNombreMaterial(res.getString("NOMBRE_CCC"));
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
             codMaterialCompuestoCC="";
             if(!codMaterialesPrincipioActivo.equals(""))
             {
                 consulta="select DISTINCT m.COD_MATERIAL_COMPUESTO_CC from MATERIALES_COMPUESTOS_CC m"+
                          " where m.COD_MATERIAL_1 in ("+codMaterialesPrincipioActivo+") and m.COD_MATERIAL_2 in (" +
                          codMaterialesPrincipioActivo+") and m.COD_MATERIAL_1 <> m.COD_MATERIAL_2";
                 System.out.println("consulta buscar materiales compuestos "+consulta);
                 res=st.executeQuery(consulta);
                 while(res.next())
                 {
                     codMaterialCompuestoCC+=(codMaterialCompuestoCC.equals("")?"":",")+res.getString("COD_MATERIAL_COMPUESTO_CC");
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
     private void cargarMaterialesPrincipioActivo(String codComprod,int codVersion)
     {
         try
         {
             Connection con=null;
             con=Util.openConnection(con);
             Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
             String consulta="select m.NOMBRE_CCC,m.COD_MATERIAL,ISNULL(eqp.ESTADO, 1) as estado"+
                             " from FORMULA_MAESTRA fm inner join FORMULA_MAESTRA_DETALLE_MP fmd on "+
                             " fm.COD_FORMULA_MAESTRA = fmd.COD_FORMULA_MAESTRA inner join MATERIALES m on" +
                             " m.COD_MATERIAL = fmd.COD_MATERIAL left outer join ESPECIFICACIONES_QUIMICAS_PRODUCTO eqp on" +
                             " eqp.COD_MATERIAL = fmd.COD_MATERIAL and fm.COD_COMPPROD = eqp.COD_PRODUCTO and eqp.COD_VERSION_ESPECIFICACION_PRODUCTO='"+codVersion+"' "+
                             " where fm.COD_COMPPROD = '"+codComprod+"' and m.COD_GRUPO in (2,3,4,99) group by m.NOMBRE_CCC,m.COD_MATERIAL,eqp.ESTADO order by m.NOMBRE_CCC";
             System.out.println("consulta materiales principio activo "+consulta);
             ResultSet res=st.executeQuery(consulta);
             listaMaterialesPrincipioActivo.clear();
             String codMaterialesPrincipioActivo="";
             while(res.next())
             {
                Materiales bean= new Materiales();
                bean.setCodMaterial(res.getString("COD_MATERIAL"));
                codMaterialesPrincipioActivo+=(codMaterialesPrincipioActivo.equals("")?"":",")+res.getString("COD_MATERIAL");
                bean.setNombreMaterial(res.getString("NOMBRE_CCC"));
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
             codMaterialCompuestoCC="";
             if(!codMaterialesPrincipioActivo.equals(""))
             {
                 consulta="select DISTINCT m.COD_MATERIAL_COMPUESTO_CC from MATERIALES_COMPUESTOS_CC m"+
                          " where m.COD_MATERIAL_1 in ("+codMaterialesPrincipioActivo+") and m.COD_MATERIAL_2 in (" +
                          codMaterialesPrincipioActivo+") and m.COD_MATERIAL_1 <> m.COD_MATERIAL_2";
                 System.out.println("consulta buscar materiales compuestos "+consulta);
                 res=st.executeQuery(consulta);
                 while(res.next())
                 {
                     codMaterialCompuestoCC+=(codMaterialCompuestoCC.equals("")?"":",")+res.getString("COD_MATERIAL_COMPUESTO_CC");
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
     private List<EspecificacionesQuimicasProducto> cargarEspecificacionesQuimicasProductoClonar(int codEspecificacion,String codCompProd,String codCompProdDestino)
     {
         List<EspecificacionesQuimicasProducto> lista= new ArrayList<EspecificacionesQuimicasProducto>();
         String consulta="select eqp.COD_REFERENCIA_CC,eqp.DESCRIPCION,eqp.LIMITE_INFERIOR,"+
                         " eqp.LIMITE_SUPERIOR,eqp.ESTADO,eqp.VALOR_EXACTO"+
                         " from ESPECIFICACIONES_QUIMICAS_PRODUCTO eqp " +
                         " inner join VERSION_ESPECIFICACIONES_PRODUCTO vep on vep.COD_COMPPROD=eqp.COD_PRODUCTO"+
                         " and vep.COD_VERSION_ESPECIFICACION_PRODUCTO=eqp.COD_VERSION_ESPECIFICACION_PRODUCTO"+
                         " and vep.COD_TIPO_ANALISIS=2 and vep.VERSION_ACTIVA=1"+
                         " where eqp.COD_ESPECIFICACION='"+codEspecificacion+"' " +
                         " and eqp.COD_PRODUCTO='"+codCompProd+"' and eqp.COD_MATERIAL=-1 ";//and eqp.estado=1
         System.out.println("consulta cargar especificaciones "+consulta);
         try
         {
             Connection cone=null;
             cone=Util.openConnection(cone);
             Statement st1=cone.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
             ResultSet res1=st1.executeQuery(consulta);
             EspecificacionesQuimicasProducto bean1= new EspecificacionesQuimicasProducto();
             bean1.getComponenteProd().setCodCompprod(codCompProd);
             bean1.getMaterial().setNombreMaterial("SIN MATERIALES");
             bean1.getMaterial().setCodMaterial("-1");
             bean1.getEstado().setCodEstadoRegistro("2");
             bean1.getMaterialesCompuestosCc().setCodMaterialCompuestoCc(0);
             if(res1.next())
             {
                 bean1.setLimiteInferior(res1.getDouble("LIMITE_INFERIOR"));
                 bean1.setLimiteSuperior(res1.getDouble("LIMITE_SUPERIOR"));
                 bean1.setDescripcion(res1.getString("DESCRIPCION"));
                 bean1.getEspecificacionQuimica().setCodEspecificacion(codEspecificacion);
                 bean1.getEstado().setCodEstadoRegistro(res1.getString("ESTADO"));
                 bean1.getTiposReferenciaCc().setCodReferenciaCc(res1.getInt("COD_REFERENCIA_CC"));
                 bean1.setValorExacto(res1.getDouble("VALOR_EXACTO"));
                 lista.add(bean1);
             }
             consulta="select ISNULL(eqp.COD_REFERENCIA_CC,1) AS CODREFER, m.NOMBRE_CCC,m.COD_MATERIAL,ISNULL(eqp.DESCRIPCION,'') as descripciom,"+
                         " ISNULL(eqp.LIMITE_INFERIOR,0) as limiteInferior,ISNULL(eqp.LIMITE_SUPERIOR,0) as limiteSuperior,"+
                         " ISNULL(eqp.ESTADO,2) as estado,ISNULL(eqp.VALOR_EXACTO,0) as valorExacto"+
                         " from FORMULA_MAESTRA fm inner join FORMULA_MAESTRA_DETALLE_MP fmd on"+
                         " fm.COD_FORMULA_MAESTRA=fmd.COD_FORMULA_MAESTRA inner join MATERIALES m on"+
                         " m.COD_MATERIAL=fmd.COD_MATERIAL inner join ESPECIFICACIONES_QUIMICAS_PRODUCTO eqp"+
                         " on eqp.COD_MATERIAL=fmd.COD_MATERIAL and eqp.COD_ESPECIFICACION='"+codEspecificacion+"'" +
                         " and eqp.COD_MATERIAL_COMPUESTO_CC=0 " +//and eqp.estado=1
                         " inner join VERSION_ESPECIFICACIONES_PRODUCTO vep on vep.COD_COMPPROD=eqp.COD_PRODUCTO"+
                         " and vep.COD_VERSION_ESPECIFICACION_PRODUCTO=eqp.COD_VERSION_ESPECIFICACION_PRODUCTO"+
                         " and vep.COD_TIPO_ANALISIS=2 and vep.VERSION_ACTIVA=1"+
                         " where eqp.COD_PRODUCTO='"+codCompProd+"' and fm.COD_ESTADO_REGISTRO=1 and  fm.COD_COMPPROD='"+codCompProdDestino+"' and m.COD_GRUPO in(2,3,4,99) order by m.NOMBRE_CCC";
         System.out.println("consulta detalle "+consulta);
         this.cargarTiposRefenciasCc();
         res1=st1.executeQuery(consulta);
         while(res1.next())
         {
             EspecificacionesQuimicasProducto bean= new EspecificacionesQuimicasProducto();
             bean.getComponenteProd().setCodCompprod(codCompProd);
             bean.setLimiteInferior(res1.getDouble("limiteInferior"));
             bean.setLimiteSuperior(res1.getDouble("limiteSuperior"));
             bean.setDescripcion(res1.getString("descripciom"));
             bean.getEspecificacionQuimica().setCodEspecificacion(codEspecificacion);
             bean.getMaterial().setCodMaterial(res1.getString("COD_MATERIAL"));
             codMaterialesUsadosClonar+=(codMaterialesUsadosClonar.equals("")?"":",")+res1.getString("COD_MATERIAL");
             bean.getMaterial().setNombreMaterial(res1.getString("NOMBRE_CCC"));
             bean.getEstado().setCodEstadoRegistro(res1.getString("estado"));
             bean.getTiposReferenciaCc().setCodReferenciaCc(res1.getInt("CODREFER"));
             bean.getMaterialesCompuestosCc().setCodMaterialCompuestoCc(0);
             bean.setValorExacto(res1.getDouble("valorExacto"));
             lista.add(bean);
         }
         /*if(!codMaterialCompuestoCC.equals(""))
         {
             consulta="select ISNULL(eqp.COD_REFERENCIA_CC, 1) AS CODREFER,mccc.NOMBRE_MATERIAL_COMPUESTO_CC,"+
                      " mccc.COD_MATERIAL_COMPUESTO_CC, ISNULL(eqp.DESCRIPCION, '') as descripciom,ISNULL(eqp.LIMITE_INFERIOR, 0) as limiteInferior,"+
                      " ISNULL(eqp.LIMITE_SUPERIOR, 0) as limiteSuperior, ISNULL(eqp.ESTADO, 2) as estado,ISNULL(eqp.VALOR_EXACTO, 0) as valorExacto"+
                      " from MATERIALES_COMPUESTOS_CC mccc inner join ESPECIFICACIONES_QUIMICAS_PRODUCTO eqp on eqp.COD_MATERIAL_COMPUESTO_CC"+
                      "  =mccc.COD_MATERIAL_COMPUESTO_CC and eqp.COD_PRODUCTO='"+codCompProd+"' and eqp.COD_ESPECIFICACION = '"+codEspecificacion+"'"+
                      " and eqp.COD_MATERIAL=0 and eqp.estado=1 where mccc.COD_MATERIAL_COMPUESTO_CC in ("+codMaterialCompuestoCC+")";
             System.out.println("consulta cargar especificaciones material compuesto cc "+consulta);
             res1=st1.executeQuery(consulta);
             while(res1.next())
             {
                 EspecificacionesQuimicasProducto bean= new EspecificacionesQuimicasProducto();
                 bean.getComponenteProd().setCodCompprod(codCompProd);
                 bean.setLimiteInferior(res1.getDouble("limiteInferior"));
                 bean.setLimiteSuperior(res1.getDouble("limiteSuperior"));
                 bean.setDescripcion(res1.getString("descripciom"));
                 bean.getEspecificacionQuimica().setCodEspecificacion(codEspecificacion);
                 bean.getMaterial().setCodMaterial("0");
                 bean.getMaterialesCompuestosCc().setCodMaterialCompuestoCc(res1.getInt("COD_MATERIAL_COMPUESTO_CC"));
                 bean.getMaterialesCompuestosCc().setNombreMaterialCompuestoCc(res1.getString("NOMBRE_MATERIAL_COMPUESTO_CC"));
                 bean.getEstado().setCodEstadoRegistro(res1.getString("estado"));
                 bean.getTiposReferenciaCc().setCodReferenciaCc(res1.getInt("CODREFER"));
                 bean.setValorExacto(res1.getDouble("valorExacto"));
                 lista.add(bean);
             }
         }*/
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
     private List<EspecificacionesQuimicasProducto> cargarEspecificacionesQuimicasProducto(int codEspecificacion,ComponentesProd componente)
     {
         List<EspecificacionesQuimicasProducto> lista= new ArrayList<EspecificacionesQuimicasProducto>();
         String consulta="select eqp.COD_REFERENCIA_CC,eqp.DESCRIPCION,eqp.LIMITE_INFERIOR,"+
                         " eqp.LIMITE_SUPERIOR,eqp.ESTADO,eqp.VALOR_EXACTO"+
                         " from ESPECIFICACIONES_QUIMICAS_PRODUCTO eqp "+
                         " where eqp.COD_ESPECIFICACION='"+codEspecificacion+"' " +
                         " and eqp.COD_PRODUCTO='"+componente.getCodCompprod()+"' and eqp.COD_MATERIAL=-1 and eqp.COD_VERSION_ESPECIFICACION_PRODUCTO='"+versionEspecificacionesProductoQuimica.getCodVersionEspecificacionProducto()+"'";
         System.out.println("consulta cargar especificaciones "+consulta);
         try
         {
             Connection cone=null;
             cone=Util.openConnection(cone);
             Statement st1=cone.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
             ResultSet res1=st1.executeQuery(consulta);
             EspecificacionesQuimicasProducto bean1= new EspecificacionesQuimicasProducto();
             bean1.setComponenteProd(componente);
             bean1.getMaterial().setNombreCCC("SIN MATERIALES");
             bean1.getMaterial().setCodMaterial("-1");
             bean1.getEstado().setCodEstadoRegistro("2");
             bean1.getMaterialesCompuestosCc().setCodMaterialCompuestoCc(0);
             if(res1.next())
             {
                 bean1.setLimiteInferior(res1.getDouble("LIMITE_INFERIOR"));
                 bean1.setLimiteSuperior(res1.getDouble("LIMITE_SUPERIOR"));
                 bean1.setDescripcion(res1.getString("DESCRIPCION"));
                 bean1.getEspecificacionQuimica().setCodEspecificacion(codEspecificacion);
                 bean1.getEstado().setCodEstadoRegistro(res1.getString("ESTADO"));
                 bean1.getTiposReferenciaCc().setCodReferenciaCc(res1.getInt("COD_REFERENCIA_CC"));
                 bean1.setValorExacto(res1.getDouble("VALOR_EXACTO"));
                 
             }
             lista.add(bean1);
             consulta="select ISNULL(eqp.COD_REFERENCIA_CC,1) AS CODREFER, m.NOMBRE_CCC,m.COD_MATERIAL,m.NOMBRE_MATERIAL,ISNULL(eqp.DESCRIPCION,'') as descripciom,"+
                         " ISNULL(eqp.LIMITE_INFERIOR,0) as limiteInferior,ISNULL(eqp.LIMITE_SUPERIOR,0) as limiteSuperior,"+
                         " ISNULL(eqp.ESTADO,2) as estado,ISNULL(eqp.VALOR_EXACTO,0) as valorExacto"+
                         " from FORMULA_MAESTRA fm inner join FORMULA_MAESTRA_DETALLE_MP fmd on"+
                         " fm.COD_FORMULA_MAESTRA=fmd.COD_FORMULA_MAESTRA inner join MATERIALES m on"+
                         " m.COD_MATERIAL=fmd.COD_MATERIAL left outer join ESPECIFICACIONES_QUIMICAS_PRODUCTO eqp"+
                         " on eqp.COD_MATERIAL=fmd.COD_MATERIAL and fm.COD_COMPPROD=eqp.COD_PRODUCTO and eqp.COD_ESPECIFICACION='"+codEspecificacion+"'" +
                         " and eqp.COD_MATERIAL_COMPUESTO_CC=0 and eqp.COD_VERSION_ESPECIFICACION_PRODUCTO='"+versionEspecificacionesProductoQuimica.getCodVersionEspecificacionProducto()+"'"+
                         " where fm.COD_COMPPROD='"+componente.getCodCompprod()+"' and fm.COD_ESTADO_REGISTRO=1 and m.COD_GRUPO in(2,3,4,99)" +
                         " group by eqp.COD_REFERENCIA_CC,m.NOMBRE_CCC,m.COD_MATERIAL,m.NOMBRE_MATERIAL,"+
                         " eqp.DESCRIPCION,eqp.LIMITE_INFERIOR,eqp.LIMITE_SUPERIOR,"+
                         " eqp.ESTADO,eqp.VALOR_EXACTO order by m.NOMBRE_CCC";
         System.out.println("consulta detalle "+consulta);
         this.cargarTiposRefenciasCc();
         res1=st1.executeQuery(consulta);
         while(res1.next())
         {
             EspecificacionesQuimicasProducto bean= new EspecificacionesQuimicasProducto();
             bean.setComponenteProd(componente);

             bean.setLimiteInferior(res1.getDouble("limiteInferior"));
             bean.setLimiteSuperior(res1.getDouble("limiteSuperior"));
             bean.setDescripcion(res1.getString("descripciom"));
             bean.getEspecificacionQuimica().setCodEspecificacion(codEspecificacion);
             bean.getMaterial().setCodMaterial(res1.getString("COD_MATERIAL"));
             bean.getMaterial().setNombreCCC(res1.getString("NOMBRE_CCC"));
             bean.getMaterial().setNombreMaterial(res1.getString("NOMBRE_MATERIAL"));
             bean.getEstado().setCodEstadoRegistro(res1.getString("estado"));
             bean.getTiposReferenciaCc().setCodReferenciaCc(res1.getInt("CODREFER"));
             bean.getMaterialesCompuestosCc().setCodMaterialCompuestoCc(0);
             bean.setValorExacto(res1.getDouble("valorExacto"));
             lista.add(bean);
         }
         if(!codMaterialCompuestoCC.equals(""))
         {
             System.out.println("ccdcd");
             consulta="select ISNULL(eqp.COD_REFERENCIA_CC, 1) AS CODREFER,mccc.NOMBRE_MATERIAL_COMPUESTO_CC,"+
                      " mccc.COD_MATERIAL_COMPUESTO_CC, ISNULL(eqp.DESCRIPCION, '') as descripciom,ISNULL(eqp.LIMITE_INFERIOR, 0) as limiteInferior,"+
                      " ISNULL(eqp.LIMITE_SUPERIOR, 0) as limiteSuperior, ISNULL(eqp.ESTADO, 2) as estado,ISNULL(eqp.VALOR_EXACTO, 0) as valorExacto"+
                      " from MATERIALES_COMPUESTOS_CC mccc left outer join ESPECIFICACIONES_QUIMICAS_PRODUCTO eqp on eqp.COD_MATERIAL_COMPUESTO_CC"+
                      "  =mccc.COD_MATERIAL_COMPUESTO_CC and eqp.COD_PRODUCTO='"+componente.getCodCompprod()+"' and eqp.COD_ESPECIFICACION = '"+codEspecificacion+"'" +
                      " and eqp.COD_VERSION_ESPECIFICACION_PRODUCTO='"+versionEspecificacionesProductoQuimica.getCodVersionEspecificacionProducto()+"'"+
                      " and eqp.COD_MATERIAL=0 where mccc.COD_MATERIAL_COMPUESTO_CC in ("+codMaterialCompuestoCC+")";
             System.out.println("consulta cargar especificaciones material compuesto cc "+consulta);
             res1=st1.executeQuery(consulta);
             while(res1.next())
             {
                 EspecificacionesQuimicasProducto bean= new EspecificacionesQuimicasProducto();
                 bean.setComponenteProd(componente);
                 bean.setLimiteInferior(res1.getDouble("limiteInferior"));
                 bean.setLimiteSuperior(res1.getDouble("limiteSuperior"));
                 bean.setDescripcion(res1.getString("descripciom"));
                 bean.getEspecificacionQuimica().setCodEspecificacion(codEspecificacion);
                 bean.getMaterial().setCodMaterial("0");
                 bean.getMaterialesCompuestosCc().setCodMaterialCompuestoCc(res1.getInt("COD_MATERIAL_COMPUESTO_CC"));
                 bean.getMaterialesCompuestosCc().setNombreMaterialCompuestoCc(res1.getString("NOMBRE_MATERIAL_COMPUESTO_CC"));
                 bean.getEstado().setCodEstadoRegistro(res1.getString("estado"));
                 bean.getTiposReferenciaCc().setCodReferenciaCc(res1.getInt("CODREFER"));
                 bean.setValorExacto(res1.getDouble("valorExacto"));
                 lista.add(bean);
             }
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

     private List<EspecificacionesQuimicasProducto> cargarEspecificacionesQuimicasProductoVersion(int codEspecificacion,ComponentesProd componente)
     {
         List<EspecificacionesQuimicasProducto> lista= new ArrayList<EspecificacionesQuimicasProducto>();
         String consulta="select eqp.COD_REFERENCIA_CC,eqp.DESCRIPCION,eqp.LIMITE_INFERIOR,"+
                         " eqp.LIMITE_SUPERIOR,eqp.ESTADO,eqp.VALOR_EXACTO"+
                         " from ESPECIFICACIONES_QUIMICAS_PRODUCTO eqp "+
                         " where eqp.COD_ESPECIFICACION='"+codEspecificacion+"' " +
                         " and eqp.COD_PRODUCTO='"+componente.getCodCompprod()+"' and eqp.COD_MATERIAL=-1 and eqp.COD_VERSION_ESPECIFICACION_PRODUCTO='"+versionEspecificacionesProductoQuimica.getCodVersionEspecificacionProducto()+"'";
         System.out.println("consulta cargar especificaciones "+consulta);
         try
         {
             Connection cone=null;
             cone=Util.openConnection(cone);
             Statement st1=cone.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
             ResultSet res1=st1.executeQuery(consulta);
             EspecificacionesQuimicasProducto bean1= new EspecificacionesQuimicasProducto();
             bean1.setComponenteProd(componente);
             bean1.getMaterial().setNombreCCC("SIN MATERIALES");
             bean1.getMaterial().setCodMaterial("-1");
             bean1.getEstado().setCodEstadoRegistro("2");
             bean1.getMaterialesCompuestosCc().setCodMaterialCompuestoCc(0);
             if(res1.next())
             {
                 bean1.setLimiteInferior(res1.getDouble("LIMITE_INFERIOR"));
                 bean1.setLimiteSuperior(res1.getDouble("LIMITE_SUPERIOR"));
                 bean1.setDescripcion(res1.getString("DESCRIPCION"));
                 bean1.getEspecificacionQuimica().setCodEspecificacion(codEspecificacion);
                 bean1.getEstado().setCodEstadoRegistro(res1.getString("ESTADO"));
                 bean1.getTiposReferenciaCc().setCodReferenciaCc(res1.getInt("COD_REFERENCIA_CC"));
                 bean1.setValorExacto(res1.getDouble("VALOR_EXACTO"));

             }
             lista.add(bean1);
             consulta="select ISNULL(eqp.COD_REFERENCIA_CC,1) AS CODREFER, m.NOMBRE_CCC,m.COD_MATERIAL,m.NOMBRE_MATERIAL,ISNULL(eqp.DESCRIPCION,'') as descripciom,"+
                         " ISNULL(eqp.LIMITE_INFERIOR,0) as limiteInferior,ISNULL(eqp.LIMITE_SUPERIOR,0) as limiteSuperior,"+
                         " ISNULL(eqp.ESTADO,2) as estado,ISNULL(eqp.VALOR_EXACTO,0) as valorExacto"+
                         " from  MATERIALES m inner join ESPECIFICACIONES_QUIMICAS_PRODUCTO eqp on eqp.COD_MATERIAL=m.COD_MATERIAL"+
                         " and  eqp.COD_ESPECIFICACION = '"+codEspecificacion+"' and eqp.COD_MATERIAL_COMPUESTO_CC = 0 "+
                         " where eqp.COD_VERSION_ESPECIFICACION_PRODUCTO = '"+versionEspecificacionesProductoQuimica.getCodVersionEspecificacionProducto()+"'" +
                         " and eqp.COD_PRODUCTO = '"+componentesProd.getCodCompprod()+"'"+
                         " group by eqp.COD_REFERENCIA_CC,m.NOMBRE_CCC,m.COD_MATERIAL,m.NOMBRE_MATERIAL,"+
                         " eqp.DESCRIPCION,eqp.LIMITE_INFERIOR,eqp.LIMITE_SUPERIOR,"+
                         " eqp.ESTADO,eqp.VALOR_EXACTO order by m.NOMBRE_CCC";
         System.out.println("consulta detalle "+consulta);
         this.cargarTiposRefenciasCc();
         res1=st1.executeQuery(consulta);
         while(res1.next())
         {
             EspecificacionesQuimicasProducto bean= new EspecificacionesQuimicasProducto();
             bean.setComponenteProd(componente);

             bean.setLimiteInferior(res1.getDouble("limiteInferior"));
             bean.setLimiteSuperior(res1.getDouble("limiteSuperior"));
             bean.setDescripcion(res1.getString("descripciom"));
             bean.getEspecificacionQuimica().setCodEspecificacion(codEspecificacion);
             bean.getMaterial().setCodMaterial(res1.getString("COD_MATERIAL"));
             bean.getMaterial().setNombreCCC(res1.getString("NOMBRE_CCC"));
             bean.getMaterial().setNombreMaterial(res1.getString("NOMBRE_MATERIAL"));
             bean.getEstado().setCodEstadoRegistro(res1.getString("estado"));
             bean.getTiposReferenciaCc().setCodReferenciaCc(res1.getInt("CODREFER"));
             bean.getMaterialesCompuestosCc().setCodMaterialCompuestoCc(0);
             bean.setValorExacto(res1.getDouble("valorExacto"));
             lista.add(bean);
         }
         if(!codMaterialCompuestoCC.equals(""))
         {
             
             consulta="select ISNULL(eqp.COD_REFERENCIA_CC, 1) AS CODREFER,mccc.NOMBRE_MATERIAL_COMPUESTO_CC,"+
                      " mccc.COD_MATERIAL_COMPUESTO_CC, ISNULL(eqp.DESCRIPCION, '') as descripciom,ISNULL(eqp.LIMITE_INFERIOR, 0) as limiteInferior,"+
                      " ISNULL(eqp.LIMITE_SUPERIOR, 0) as limiteSuperior, ISNULL(eqp.ESTADO, 2) as estado,ISNULL(eqp.VALOR_EXACTO, 0) as valorExacto"+
                      " from MATERIALES_COMPUESTOS_CC mccc inner join ESPECIFICACIONES_QUIMICAS_PRODUCTO eqp on eqp.COD_MATERIAL_COMPUESTO_CC"+
                      "  =mccc.COD_MATERIAL_COMPUESTO_CC and eqp.COD_PRODUCTO='"+componente.getCodCompprod()+"' and eqp.COD_ESPECIFICACION = '"+codEspecificacion+"'" +
                      " and eqp.COD_VERSION_ESPECIFICACION_PRODUCTO='"+versionEspecificacionesProductoQuimica.getCodVersionEspecificacionProducto()+"'"+
                      " and eqp.COD_MATERIAL=0";
             System.out.println("consulta cargar especificaciones material compuesto cc "+consulta);
             res1=st1.executeQuery(consulta);
             while(res1.next())
             {
                 EspecificacionesQuimicasProducto bean= new EspecificacionesQuimicasProducto();
                 bean.setComponenteProd(componente);
                 bean.setLimiteInferior(res1.getDouble("limiteInferior"));
                 bean.setLimiteSuperior(res1.getDouble("limiteSuperior"));
                 bean.setDescripcion(res1.getString("descripciom"));
                 bean.getEspecificacionQuimica().setCodEspecificacion(codEspecificacion);
                 bean.getMaterial().setCodMaterial("0");
                 bean.getMaterialesCompuestosCc().setCodMaterialCompuestoCc(res1.getInt("COD_MATERIAL_COMPUESTO_CC"));
                 bean.getMaterialesCompuestosCc().setNombreMaterialCompuestoCc(res1.getString("NOMBRE_MATERIAL_COMPUESTO_CC"));
                 bean.getEstado().setCodEstadoRegistro(res1.getString("estado"));
                 bean.getTiposReferenciaCc().setCodReferenciaCc(res1.getInt("CODREFER"));
                 bean.setValorExacto(res1.getDouble("valorExacto"));
                 lista.add(bean);
             }
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
     public String getCargarEditarVersionAnalisisQuimico()
     {
         this.cargarMaterialesPrincipioActivoVersion(componentesProd.getCodCompprod(),versionEspecificacionesProductoQuimica.getCodVersionEspecificacionProducto());
         try
         {
            Connection con=null;
            con=Util.openConnection(con);
            Statement st=con.createStatement();
            String consulta="select eqcc.COD_ESPECIFICACION,eqcc.NOMBRE_ESPECIFICACION,eqcc.COD_TIPO_RESULTADO_ANALISIS,"+
                            " tra.NOMBRE_TIPO_RESULTADO_ANALISIS,ISNULL(eqcc.COEFICIENTE, '') as coeficiente,ISNULL(tra.SIMBOLO, '') as simbolo"+
                            " from ESPECIFICACIONES_QUIMICAS_CC eqcc"+
                            " inner join TIPOS_RESULTADOS_ANALISIS tra on tra.COD_TIPO_RESULTADO_ANALISIS"+
                            " = eqcc.COD_TIPO_RESULTADO_ANALISIS"+
                            " inner join ESPECIFICACIONES_QUIMICAS_PRODUCTO eqp on eqp.COD_ESPECIFICACION=eqcc.COD_ESPECIFICACION"+
                            " where eqp.COD_PRODUCTO='"+componentesProd.getCodCompprod()+"' and eqp.COD_VERSION_ESPECIFICACION_PRODUCTO='"+versionEspecificacionesProductoQuimica.getCodVersionEspecificacionProducto()+"'"+
                            " group by eqcc.COD_ESPECIFICACION,eqcc.NOMBRE_ESPECIFICACION,eqcc.COD_TIPO_RESULTADO_ANALISIS,"+
                            " tra.NOMBRE_TIPO_RESULTADO_ANALISIS,eqcc.COEFICIENTE,tra.SIMBOLO"+
                            " order by eqcc.NOMBRE_ESPECIFICACION";
            System.out.println("consulta "+consulta);
            ResultSet res=st.executeQuery(consulta);
            listaEspecificacionesQuimicasCc.clear();
            while(res.next())
            {
                EspecificacionesQuimicasCc bean= new EspecificacionesQuimicasCc();
                bean.setNombreEspecificacion(res.getString("NOMBRE_ESPECIFICACION"));
                bean.setCodEspecificacion(res.getInt("COD_ESPECIFICACION"));
                bean.setCoeficiente(res.getString("coeficiente"));
                bean.getTipoResultadoAnalisis().setSimbolo(res.getString("simbolo"));
                bean.getTipoResultadoAnalisis().setCodTipoResultadoAnalisis(res.getString("COD_TIPO_RESULTADO_ANALISIS"));
                bean.getTipoResultadoAnalisis().setNombreTipoResultadoAnalisis(res.getString("NOMBRE_TIPO_RESULTADO_ANALISIS"));
                bean.setListaEspecificacionesQuimicasProducto(this.cargarEspecificacionesQuimicasProductoVersion(bean.getCodEspecificacion(), componentesProd));

                listaEspecificacionesQuimicasCc.add(bean);
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

     public String getCargarAgregarVersionAnalisisQuimico()
     {
         versionEspecificacionRegistrar=new VersionEspecificacionesProducto();
        versionEspecificacionesProductoQuimica=versionActual(2,componentesProd.getCodCompprod());
         this.cargarMaterialesPrincipioActivo(componentesProd.getCodCompprod(),versionEspecificacionesProductoQuimica.getCodVersionEspecificacionProducto());
         try
         {
            Connection con=null;
            con=Util.openConnection(con);
            Statement st=con.createStatement();
            String consulta="select eqcc.COD_ESPECIFICACION,eqcc.NOMBRE_ESPECIFICACION,eqcc.COD_TIPO_RESULTADO_ANALISIS,tra.NOMBRE_TIPO_RESULTADO_ANALISIS ," +
                            " ISNULL(eqcc.COEFICIENTE,'') as coeficiente,ISNULL(tra.SIMBOLO,'') as simbolo" +
                            " from ESPECIFICACIONES_QUIMICAS_CC eqcc inner join TIPOS_RESULTADOS_ANALISIS tra "+
                            " on tra.COD_TIPO_RESULTADO_ANALISIS=eqcc.COD_TIPO_RESULTADO_ANALISIS inner join ESPECIFICACIONES_ANALISIS_FORMAFAR eqf"+
                            " on eqcc.COD_ESPECIFICACION=eqf.COD_ESPECIFICACION where eqf.COD_FORMAFAR='"+componentesProd.getForma().getCodForma()+"' and eqf.COD_TIPO_ANALISIS=2 " +
                            " group by  eqcc.COD_ESPECIFICACION,eqcc.NOMBRE_ESPECIFICACION,eqcc.COD_TIPO_RESULTADO_ANALISIS,tra.NOMBRE_TIPO_RESULTADO_ANALISIS ," +
                            " eqcc.COEFICIENTE,tra.SIMBOLO"+
                             " order by eqcc.NOMBRE_ESPECIFICACION";
            System.out.println("consulta "+consulta);
            ResultSet res=st.executeQuery(consulta);
            listaEspecificacionesQuimicasCc.clear();
            while(res.next())
            {
                EspecificacionesQuimicasCc bean= new EspecificacionesQuimicasCc();
                bean.setNombreEspecificacion(res.getString("NOMBRE_ESPECIFICACION"));
                bean.setCodEspecificacion(res.getInt("COD_ESPECIFICACION"));
                bean.setCoeficiente(res.getString("coeficiente"));
                bean.getTipoResultadoAnalisis().setSimbolo(res.getString("simbolo"));
                bean.getTipoResultadoAnalisis().setCodTipoResultadoAnalisis(res.getString("COD_TIPO_RESULTADO_ANALISIS"));
                bean.getTipoResultadoAnalisis().setNombreTipoResultadoAnalisis(res.getString("NOMBRE_TIPO_RESULTADO_ANALISIS"));
                bean.setListaEspecificacionesQuimicasProducto(this.cargarEspecificacionesQuimicasProducto(bean.getCodEspecificacion(), componentesProd));

                listaEspecificacionesQuimicasCc.add(bean);
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

     public String agregarAnalisisQuimico_Action()
     {

          componentesProd = (ComponentesProd)componentesProdDataTable.getRowData();
          this.redireccionar("navegadorVersionesAnalisisQuimico.jsf");

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
      public String clonarEspecificacionesProductoDestino()throws SQLException
     {
        mensaje="";
        Connection con =null;
        try
        {
            con=Util.openConnection(con);
            con.setAutoCommit(false);
            String consulta=" select isnull(MAX(v.COD_VERSION_ESPECIFICACION_PRODUCTO),0)+1 as codVersion  from VERSION_ESPECIFICACIONES_PRODUCTO v ";
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta);
            int codVersionEspecificacion=0;

            if(res.next())codVersionEspecificacion=res.getInt("codVersion");
            SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
            ManagedAccesoSistema managed=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
            consulta="UPDATE  VERSION_ESPECIFICACIONES_PRODUCTO SET VERSION_ACTIVA=0 WHERE COD_COMPPROD='"+componentesProdClonarDestino.getCodCompprod()+"' and COD_TIPO_ANALISIS=1;" +
                    " INSERT INTO VERSION_ESPECIFICACIONES_PRODUCTO(COD_VERSION_ESPECIFICACION_PRODUCTO,NRO_VERSION_ESPECIFICACION_PRODUCTO"+
                     " ,FECHA_CREACION, VERSION_ACTIVA, COD_TIPO_ANALISIS, COD_COMPPROD, OBSERVACION,COD_PERSONAL_REGISTRA,COD_PERSONAL_MODIFICA)"+
                     "VALUES ('"+codVersionEspecificacion+"',(select isnull(max(v.NRO_VERSION_ESPECIFICACION_PRODUCTO),0)+1 from VERSION_ESPECIFICACIONES_PRODUCTO v where v.COD_TIPO_ANALISIS=1 and v.COD_COMPPROD='"+componentesProdClonarDestino.getCodCompprod()+"'),"+
                     "'"+sdf.format(new Date())+"',1,1,'"+componentesProdClonarDestino.getCodCompprod()+"','creada por duplicacion producto cod "+componentesProdFormaClonar.getCodCompprod()+"'" +
                     ",'"+managed.getUsuarioModuloBean().getCodUsuarioGlobal()+"',0)";
            System.out.println("consulta insertar nueva version  "+consulta);
            PreparedStatement pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se registro la nueva version" );
                    /*select m.NOMBRE_CCC from materiales m where m.COD_MATERIAL in ("+codMaterialesUsadosClonar+")"+
                            " and m.COD_MATERIAL  not in ("+
                            " select fmdp.COD_MATERIAL from FORMULA_MAESTRA fm inner join FORMULA_MAESTRA_DETALLE_MP fmdp"+
                            " on fm.COD_FORMULA_MAESTRA=fmdp.COD_FORMULA_MAESTRA"+
                            " where fm.COD_COMPPROD='"+componentesProdClonarDestino.getCodCompprod()+"' and fm.COD_ESTADO_REGISTRO=1)" +
                            " and m.COD_GRUPO in (2,3,4,99) order by  m.NOMBRE_MATERIAL";
            System.out.println("consulta verificar misma materia prima ambos productos "+consulta);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta);
            while(res.next())
            {
                mensaje+=(mensaje.equals("")?"No se pueden registrar las especificaciones porque sus materias primas no son las mismas: ":",")+res.getString("NOMBRE_CCC");
            }
            if(mensaje.equals(""))
            {*/
                    /*consulta="delete from ESPECIFICACIONES_FISICAS_PRODUCTO where COD_PRODUCTO='"+componentesProdClonarDestino.getCodCompprod()+"'";
                    System.out.println("consulta delete "+consulta);
                    pst=con.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)System.out.println("existian detalles y se eliminaron ");*/
                    for(EspecificacionesFisicasProducto current: listaEspecificacionesFisicasProductoClonar)
                    {
                        consulta="INSERT INTO ESPECIFICACIONES_FISICAS_PRODUCTO(COD_PRODUCTO, COD_ESPECIFICACION,"+
                                 " LIMITE_INFERIOR, LIMITE_SUPERIOR, DESCRIPCION,COD_REFERENCIA_CC,ESTADO,VALOR_EXACTO,COD_TIPO_ESPECIFICACION_FISICA,COD_VERSION_ESPECIFICACION_PRODUCTO)VALUES("+
                                 "'"+componentesProdClonarDestino.getCodCompprod()+"','"+current.getEspecificacionFisicaCC().getCodEspecificacion()+"'," +
                                 "'"+current.getLimiteInferior()+"','"+current.getLimiteSuperior()+"','"+current.getDescripcion()+"','"+current.getEspecificacionFisicaCC().getTiposReferenciaCc().getCodReferenciaCc()+"'" +
                                 ",'"+current.getEstado().getCodEstadoRegistro()+"','"+current.getValorExacto()+"','"+current.getTiposEspecificacionesFisicas().getCodTipoEspecificacionFisica()+"'" +
                                 ",'"+codVersionEspecificacion+"')";
                        System.out.println("consulta "+consulta);
                        pst=con.prepareStatement(consulta);
                        if(pst.executeUpdate()>0)System.out.println("se registro el detalle");
                    }
                    codVersionEspecificacion++;
                    consulta="UPDATE  VERSION_ESPECIFICACIONES_PRODUCTO SET VERSION_ACTIVA=0 WHERE COD_COMPPROD='"+componentesProdClonarDestino.getCodCompprod()+"' and COD_TIPO_ANALISIS=2" +
                    " INSERT INTO VERSION_ESPECIFICACIONES_PRODUCTO(COD_VERSION_ESPECIFICACION_PRODUCTO,NRO_VERSION_ESPECIFICACION_PRODUCTO"+
                     " ,FECHA_CREACION, VERSION_ACTIVA, COD_TIPO_ANALISIS, COD_COMPPROD, OBSERVACION,COD_PERSONAL_REGISTRA,COD_PERSONAL_MODIFICA)"+
                     "VALUES ('"+codVersionEspecificacion+"',(select isnull(max(v.NRO_VERSION_ESPECIFICACION_PRODUCTO),0)+1 from VERSION_ESPECIFICACIONES_PRODUCTO v where v.COD_TIPO_ANALISIS=2 and v.COD_COMPPROD='"+componentesProdClonarDestino.getCodCompprod()+"'),"+
                     "'"+sdf.format(new Date())+"',1,2,'"+componentesProdClonarDestino.getCodCompprod()+"','creada por duplicacion producto cod "+componentesProdFormaClonar.getCodCompprod()+"'" +
                     ",'"+managed.getUsuarioModuloBean().getCodUsuarioGlobal()+"',0)";
                    System.out.println("consulta insertar nueva version  "+consulta);
                    pst=con.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)System.out.println("se registro la nueva version" );

                    
                     for(EspecificacionesQuimicasCc current:listaEspecificacionesQuimicasProductoClonar)
                     {

                         for(EspecificacionesQuimicasProducto current1:current.getListaEspecificacionesQuimicasProducto())
                         {
                             consulta="INSERT INTO ESPECIFICACIONES_QUIMICAS_PRODUCTO(COD_ESPECIFICACION, COD_PRODUCTO,"+
                                              "COD_MATERIAL, LIMITE_INFERIOR, LIMITE_SUPERIOR, DESCRIPCION, ESTADO,"+
                                              " COD_REFERENCIA_CC,VALOR_EXACTO,COD_MATERIAL_COMPUESTO_CC,COD_VERSION_ESPECIFICACION_PRODUCTO) VALUES (" +
                                              "'"+current.getCodEspecificacion()+"','"+componentesProdClonarDestino.getCodCompprod()+"','"+current1.getMaterial().getCodMaterial()+"'"+
                                              ",'"+current1.getLimiteInferior()+"','"+current1.getLimiteSuperior()+"','"+current1.getDescripcion()+"'," +
                                              "'"+current1.getEstado().getCodEstadoRegistro()+"','"+current1.getTiposReferenciaCc().getCodReferenciaCc()+"'" +
                                              ",'"+current1.getValorExacto()+"','"+current1.getMaterialesCompuestosCc().getCodMaterialCompuestoCc()+"','"+codVersionEspecificacion+"')";
                                              System.out.println("consulta "+consulta);
                             pst=con.prepareStatement(consulta);
                             if(pst.executeUpdate()>0)System.out.println("se registro el detalle");
                         }
                     }
                     codVersionEspecificacion++;
                     consulta="UPDATE  VERSION_ESPECIFICACIONES_PRODUCTO SET VERSION_ACTIVA=0 WHERE COD_COMPPROD='"+componentesProdClonarDestino.getCodCompprod()+"' and COD_TIPO_ANALISIS=3" +
                    " INSERT INTO VERSION_ESPECIFICACIONES_PRODUCTO(COD_VERSION_ESPECIFICACION_PRODUCTO,NRO_VERSION_ESPECIFICACION_PRODUCTO"+
                     " ,FECHA_CREACION, VERSION_ACTIVA, COD_TIPO_ANALISIS, COD_COMPPROD, OBSERVACION,COD_PERSONAL_REGISTRA,COD_PERSONAL_MODIFICA)"+
                     "VALUES ('"+codVersionEspecificacion+"',(select isnull(max(v.NRO_VERSION_ESPECIFICACION_PRODUCTO),0)+1 from VERSION_ESPECIFICACIONES_PRODUCTO v where v.COD_TIPO_ANALISIS=3 and v.COD_COMPPROD='"+componentesProdClonarDestino.getCodCompprod()+"'),"+
                     "'"+sdf.format(new Date())+"',1,3,'"+componentesProdClonarDestino.getCodCompprod()+"','creada por duplicacion producto cod "+componentesProdFormaClonar.getCodCompprod()+"'" +
                             ",'"+managed.getUsuarioModuloBean().getCodUsuarioGlobal()+"',0)";
                    System.out.println("consulta insertar nueva version  "+consulta);
                    pst=con.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)System.out.println("se registro la nueva version" );

                    
                     for(EspecificacionesMicrobiologiaProducto current: listaEspecificacionesMicrobiologiaProductoClonar)
                     {
                         consulta="INSERT INTO ESPECIFICACIONES_MICROBIOLOGIA_PRODUCTO(COD_COMPROD,"+
                                   " COD_ESPECIFICACION, LIMITE_INFERIOR, LIMITE_SUPERIOR, DESCRIPCION,COD_REFERENCIA_CC,ESTADO,VALOR_EXACTO,COD_VERSION_ESPECIFICACION_PRODUCTO)"+
                                   " VALUES ('"+componentesProdClonarDestino.getCodCompprod()+"','"+current.getEspecificacionMicrobiologiaCc().getCodEspecificacion()+"'," +
                                   " '"+current.getLimiteInferior()+"','"+current.getLimiteSuperior()+"','"+current.getDescripcion()+"','"+current.getEspecificacionMicrobiologiaCc().getTiposReferenciaCc().getCodReferenciaCc()+"'" +
                                   ",'"+current.getEstado().getCodEstadoRegistro()+"','"+current.getValorExacto()+"','"+codVersionEspecificacion+"')";
                         System.out.println("consulta "+consulta);
                         pst=con.prepareStatement(consulta);
                         if(pst.executeUpdate()>0)System.out.println("se registro el detalle");
                     }

                     mensaje="1";
            
            con.commit();
           
            if(pst!=null)pst.close();
            con.close();
        }
        catch(SQLException ex)
        {
            mensaje=" Ocurrio un error al momento de registrar las especificaciones intente de nuevo.Si el problema persiste comuniquese con sistemas";
            con.rollback();
            ex.printStackTrace();
            con.close();

        }
       
        //this.redireccionar("navegador_componentesProducto.jsf");
        return null;
     }
      public String guardarEdicionVersionAnalisisFisico_Action()throws SQLException
     {
        mensaje="";
        Connection con =null;
        try
        {
            con=Util.openConnection(con);
            con.setAutoCommit(false);
            ManagedAccesoSistema managed=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
            String consulta="update VERSION_ESPECIFICACIONES_PRODUCTO set COD_PERSONAL_MODIFICA='"+managed.getUsuarioModuloBean().getCodUsuarioGlobal()+"', OBSERVACION='"+versionEspecificacionesProductoFisico.getObservacion()+"' where COD_VERSION_ESPECIFICACION_PRODUCTO='"+versionEspecificacionesProductoFisico.getCodVersionEspecificacionProducto()+"'";
            PreparedStatement pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se actualizo la observacion de la version");
            consulta="delete from ESPECIFICACIONES_FISICAS_PRODUCTO where COD_PRODUCTO='"+componentesProd.getCodCompprod()+"' and COD_VERSION_ESPECIFICACION_PRODUCTO='"+versionEspecificacionesProductoFisico.getCodVersionEspecificacionProducto()+"'";
            System.out.println("consulta delete "+consulta);
            pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se eliminaron registros de la version");
            for(EspecificacionesFisicasProducto current: listaEspecificacionesFisicasProducto)
            {
                consulta="INSERT INTO ESPECIFICACIONES_FISICAS_PRODUCTO(COD_PRODUCTO, COD_ESPECIFICACION,"+
                         " LIMITE_INFERIOR, LIMITE_SUPERIOR, DESCRIPCION,COD_REFERENCIA_CC,ESTADO,VALOR_EXACTO,COD_TIPO_ESPECIFICACION_FISICA,COD_VERSION_ESPECIFICACION_PRODUCTO)VALUES("+
                         "'"+current.getComponenteProd().getCodCompprod()+"','"+current.getEspecificacionFisicaCC().getCodEspecificacion()+"'," +
                         "'"+current.getLimiteInferior()+"','"+current.getLimiteSuperior()+"','"+current.getDescripcion()+"','"+current.getEspecificacionFisicaCC().getTiposReferenciaCc().getCodReferenciaCc()+"'" +
                         ",'"+current.getEstado().getCodEstadoRegistro()+"','"+current.getValorExacto()+"','"+current.getTiposEspecificacionesFisicas().getCodTipoEspecificacionFisica()+"','"+versionEspecificacionesProductoFisico.getCodVersionEspecificacionProducto()+"')";
                System.out.println("consulta "+consulta);
                pst=con.prepareStatement(consulta);
                if(pst.executeUpdate()>0)System.out.println("se registro el detalle");

            }
            con.commit();
            mensaje="1";
            pst.close();
            con.close();
        }
        catch(SQLException ex)
        {
            mensaje=" Ocurrio un error al momento de registrar las especificaciones intente de nuevo.Si el problema persiste comuniquese con sistemas";
            con.rollback();
            ex.printStackTrace();

        }
        finally
        {
            con.close();
        }
        //this.redireccionar("navegador_componentesProducto.jsf");
        return null;
     }
     public String guardarVersionAnalisisFisico_Action()throws SQLException
     {
        mensaje="";
        Connection con =null;
        try
        {
            con=Util.openConnection(con);
            con.setAutoCommit(false);
            String consulta=" select isnull(MAX(v.COD_VERSION_ESPECIFICACION_PRODUCTO),0)+1 as codVersion  from VERSION_ESPECIFICACIONES_PRODUCTO v ";
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta);
            int codVersionEspecificacion=0;
            
            if(res.next())codVersionEspecificacion=res.getInt("codVersion");
            SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
            ManagedAccesoSistema managed=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
            consulta="UPDATE  VERSION_ESPECIFICACIONES_PRODUCTO SET VERSION_ACTIVA=0 WHERE COD_COMPPROD='"+componentesProd.getCodCompprod()+"' and COD_TIPO_ANALISIS=1;" +
                    " INSERT INTO VERSION_ESPECIFICACIONES_PRODUCTO(COD_VERSION_ESPECIFICACION_PRODUCTO,NRO_VERSION_ESPECIFICACION_PRODUCTO"+
                     " ,FECHA_CREACION, VERSION_ACTIVA, COD_TIPO_ANALISIS, COD_COMPPROD, OBSERVACION,COD_PERSONAL_REGISTRA,COD_PERSONAL_MODIFICA)"+
                     "VALUES ('"+codVersionEspecificacion+"',(select isnull(max(v.NRO_VERSION_ESPECIFICACION_PRODUCTO),0)+1 from VERSION_ESPECIFICACIONES_PRODUCTO v where v.COD_TIPO_ANALISIS=1 and v.COD_COMPPROD='"+componentesProd.getCodCompprod()+"'),"+
                     "'"+sdf.format(new Date())+"',1,1,'"+componentesProd.getCodCompprod()+"','"+versionEspecificacionRegistrar.getObservacion()+"'" +
                     ",'"+managed.getUsuarioModuloBean().getCodUsuarioGlobal()+"',0)";
            System.out.println("consulta insertar nueva version  "+consulta);
            PreparedStatement pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se registro la nueva version" );
            for(EspecificacionesFisicasProducto current: listaEspecificacionesFisicasProducto)
            {
                consulta="INSERT INTO ESPECIFICACIONES_FISICAS_PRODUCTO(COD_PRODUCTO, COD_ESPECIFICACION,"+
                         " LIMITE_INFERIOR, LIMITE_SUPERIOR, DESCRIPCION,COD_REFERENCIA_CC,ESTADO,VALOR_EXACTO,COD_TIPO_ESPECIFICACION_FISICA,COD_VERSION_ESPECIFICACION_PRODUCTO)VALUES("+
                         "'"+current.getComponenteProd().getCodCompprod()+"','"+current.getEspecificacionFisicaCC().getCodEspecificacion()+"'," +
                         "'"+current.getLimiteInferior()+"','"+current.getLimiteSuperior()+"','"+current.getDescripcion()+"','"+current.getEspecificacionFisicaCC().getTiposReferenciaCc().getCodReferenciaCc()+"'" +
                         ",'"+current.getEstado().getCodEstadoRegistro()+"','"+current.getValorExacto()+"','"+current.getTiposEspecificacionesFisicas().getCodTipoEspecificacionFisica()+"','"+codVersionEspecificacion+"')";
                System.out.println("consulta "+consulta);
                pst=con.prepareStatement(consulta);
                if(pst.executeUpdate()>0)System.out.println("se registro el detalle");

            }
            con.commit();
            mensaje="1";
            pst.close();
            con.close();
        }
        catch(SQLException ex)
        {
            mensaje=" Ocurrio un error al momento de registrar las especificaciones intente de nuevo.Si el problema persiste comuniquese con sistemas";
            con.rollback();
            ex.printStackTrace();

        }
        finally
        {
            con.close();
        }
        return null;
     }
     public String guardarEditarVersionAnalisisMicrobiologico_Action()throws SQLException
     {
         Connection con=null;
         mensaje="";
         try
         {
             con=Util.openConnection(con);
             con.setAutoCommit(false);
             ManagedAccesoSistema managed=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
             String consulta="update VERSION_ESPECIFICACIONES_PRODUCTO set COD_PERSONAL_MODIFICA='"+managed.getUsuarioModuloBean().getCodUsuarioGlobal()+"'," +
                             " OBSERVACION='"+versionEspecificacionesProductoMicrobiologico.getObservacion()+"' where COD_VERSION_ESPECIFICACION_PRODUCTO='"+versionEspecificacionesProductoMicrobiologico.getCodVersionEspecificacionProducto()+"'";
             System.out.println("consulta actualizar version activa "+consulta);
            PreparedStatement pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se actualizo la observacion de la version");
            consulta="delete from ESPECIFICACIONES_MICROBIOLOGIA_PRODUCTO where COD_COMPROD='"+componentesProd.getCodCompprod()+"' and COD_VERSION_ESPECIFICACION_PRODUCTO='"+versionEspecificacionesProductoMicrobiologico.getCodVersionEspecificacionProducto()+"'";
            System.out.println("consulta delete "+consulta);
            pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se eliminaron anteriores registros");
            for(EspecificacionesMicrobiologiaProducto current: listaEspecificacionesMicrobiologia)
             {
                 consulta="INSERT INTO ESPECIFICACIONES_MICROBIOLOGIA_PRODUCTO(COD_COMPROD,"+
                           " COD_ESPECIFICACION, LIMITE_INFERIOR, LIMITE_SUPERIOR, DESCRIPCION,COD_REFERENCIA_CC,ESTADO,VALOR_EXACTO,COD_VERSION_ESPECIFICACION_PRODUCTO)"+
                           " VALUES ('"+current.getComponenteProd().getCodCompprod()+"','"+current.getEspecificacionMicrobiologiaCc().getCodEspecificacion()+"'," +
                           " '"+current.getLimiteInferior()+"','"+current.getLimiteSuperior()+"','"+current.getDescripcion()+"','"+current.getEspecificacionMicrobiologiaCc().getTiposReferenciaCc().getCodReferenciaCc()+"'" +
                           ",'"+current.getEstado().getCodEstadoRegistro()+"','"+current.getValorExacto()+"','"+versionEspecificacionesProductoMicrobiologico.getCodVersionEspecificacionProducto()+"')";
                 System.out.println("consulta "+consulta);
                 pst=con.prepareStatement(consulta);
                 if(pst.executeUpdate()>0)System.out.println("se registro el detalle");
             }
             con.commit();
             mensaje="1";
             pst.close();
             con.close();
             
         }
         catch(SQLException ex)
         {
             mensaje=" Ocurrio un error al momento de registrar las especificaciones intente de nuevo.Si el problema persiste comuniquese con sistemas";
             con.rollback();
             con.close();
             ex.printStackTrace();
         }
         

        return null;

     }
     public String guardarVersionAnalisisMicrobiologico_Action()throws SQLException
     {
         Connection con=null;
         mensaje="";
         try
         {
             con=Util.openConnection(con);
             con.setAutoCommit(false);
             String consulta=" select isnull(MAX(v.COD_VERSION_ESPECIFICACION_PRODUCTO),0)+1 as codVersion  from VERSION_ESPECIFICACIONES_PRODUCTO v ";
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta);
            int codVersionEspecificacion=0;

            if(res.next())codVersionEspecificacion=res.getInt("codVersion");
            SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
            ManagedAccesoSistema managed=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
            consulta="UPDATE  VERSION_ESPECIFICACIONES_PRODUCTO SET VERSION_ACTIVA=0 WHERE COD_COMPPROD='"+componentesProd.getCodCompprod()+"' and COD_TIPO_ANALISIS=3;" +
                    " INSERT INTO VERSION_ESPECIFICACIONES_PRODUCTO(COD_VERSION_ESPECIFICACION_PRODUCTO,NRO_VERSION_ESPECIFICACION_PRODUCTO"+
                     " ,FECHA_CREACION, VERSION_ACTIVA, COD_TIPO_ANALISIS, COD_COMPPROD, OBSERVACION,COD_PERSONAL_REGISTRA,COD_PERSONAL_MODIFICA)"+
                     "VALUES ('"+codVersionEspecificacion+"',(select isnull(max(v.NRO_VERSION_ESPECIFICACION_PRODUCTO),0)+1 from VERSION_ESPECIFICACIONES_PRODUCTO v where v.COD_TIPO_ANALISIS=3 and v.COD_COMPPROD='"+componentesProd.getCodCompprod()+"'),"+
                     "'"+sdf.format(new Date())+"',1,3,'"+componentesProd.getCodCompprod()+"','"+versionEspecificacionRegistrar.getObservacion()+"'" +
                     ",'"+managed.getUsuarioModuloBean().getCodUsuarioGlobal()+"',0)";
            System.out.println("consulta insertar nueva version  "+consulta);
            PreparedStatement pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se registro la nueva version" );
             for(EspecificacionesMicrobiologiaProducto current: listaEspecificacionesMicrobiologia)
             {
                 consulta="INSERT INTO ESPECIFICACIONES_MICROBIOLOGIA_PRODUCTO(COD_COMPROD,"+
                           " COD_ESPECIFICACION, LIMITE_INFERIOR, LIMITE_SUPERIOR, DESCRIPCION,COD_REFERENCIA_CC,ESTADO,VALOR_EXACTO,COD_VERSION_ESPECIFICACION_PRODUCTO)"+
                           " VALUES ('"+current.getComponenteProd().getCodCompprod()+"','"+current.getEspecificacionMicrobiologiaCc().getCodEspecificacion()+"'," +
                           " '"+current.getLimiteInferior()+"','"+current.getLimiteSuperior()+"','"+current.getDescripcion()+"','"+current.getEspecificacionMicrobiologiaCc().getTiposReferenciaCc().getCodReferenciaCc()+"'" +
                           ",'"+current.getEstado().getCodEstadoRegistro()+"','"+current.getValorExacto()+"','"+codVersionEspecificacion+"')";
                 System.out.println("consulta "+consulta);
                 pst=con.prepareStatement(consulta);
                 if(pst.executeUpdate()>0)System.out.println("se registro el detalle");
             }
             con.commit();
             mensaje="1";
             pst.close();
             con.close();
         }
         catch(SQLException ex)
         {
             mensaje=" Ocurrio un error al momento de registrar las especificaciones intente de nuevo.Si el problema persiste comuniquese con sistemas";
             con.rollback();
             con.close();
             ex.printStackTrace();
         }
        

        return null;

     }
    public List cargarEspecificacionesFisicas(){
        List especificacionesFisicasCcList = new ArrayList();
        try {
            String consulta = "select e.COD_ESPECIFICACION,e.NOMBRE_ESPECIFICACION,e.COD_TIPO_RESULTADO_ANALISIS,t.NOMBRE_TIPO_RESULTADO_ANALISIS,ISNULL(e.COEFICIENTE,'') AS COEFICIENTE,ISNULL(e.UNIDAD,'') as UNIDAD from ESPECIFICACIONES_FISICAS_CC e "+
                               " inner join TIPOS_RESULTADOS_ANALISIS t on t.COD_TIPO_RESULTADO_ANALISIS=e.COD_TIPO_RESULTADO_ANALISIS order by e.NOMBRE_ESPECIFICACION";
            Connection con = null;
            con = Util.openConnection(con);
            Statement st = con.createStatement();
            System.out.println("consulta " + consulta);
            ResultSet rs = st.executeQuery(consulta);
            especificacionesFisicasCcList.clear();
            while(rs.next()){
                EspecificacionesFisicasCc especificacionesFisicasCc = new EspecificacionesFisicasCc();
                especificacionesFisicasCc.setCodEspecificacion(rs.getInt("COD_ESPECIFICACION"));
                especificacionesFisicasCc.setNombreEspecificacion(rs.getString("NOMBRE_ESPECIFICACION"));
                especificacionesFisicasCc.setCoeficiente(rs.getString("COEFICIENTE"));
                especificacionesFisicasCc.getTipoResultadoAnalisis().setCodTipoResultadoAnalisis(rs.getString("COD_TIPO_RESULTADO_ANALISIS"));
                especificacionesFisicasCc.getTipoResultadoAnalisis().setNombreTipoResultadoAnalisis(rs.getString("NOMBRE_TIPO_RESULTADO_ANALISIS"));
                especificacionesFisicasCc.setUnidad(rs.getString("UNIDAD"));
                especificacionesFisicasCcList.add(especificacionesFisicasCc);
            }
            rs.close();
            st.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return especificacionesFisicasCcList;
    }
    public String getCargarEspecificacionesFisicasCc(){
        especificacionesFisicasCcList = this.cargarEspecificacionesFisicas();
        this.tiposResultadoAnalisisList=this.tiposResultadosAnalisis();
        this.cargarTiposReferenciaCc();
        return null;
    }
    public List<SelectItem> tiposResultadosAnalisis()
    {
        List<SelectItem> resultado=new ArrayList<SelectItem>();
        try
        {
            String consulta="select tra.COD_TIPO_RESULTADO_ANALISIS,tra.NOMBRE_TIPO_RESULTADO_ANALISIS from TIPOS_RESULTADOS_ANALISIS tra";
            Connection con1=null;
            con1=Util.openConnection(con1);
            Statement st=con1.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta);
            resultado.clear();
            while(res.next())
            {
                resultado.add(new SelectItem(res.getString("COD_TIPO_RESULTADO_ANALISIS"),res.getString("NOMBRE_TIPO_RESULTADO_ANALISIS")));
            }
            res.close();
            st.close();
            con1.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
        return  resultado;
    }
    private void cargarTiposReferenciaCc()
    {

        String consulta=" select t.COD_REFERENCIACC,t.NOMBRE_REFERENCIACC from TIPOS_REFERENCIACC t ";
        try
        {
           Connection con = null;
           con=Util.openConnection(con);
           Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
           ResultSet rs=st.executeQuery(consulta);
           tiposReferenciaCcList.clear();
           while(rs.next()){
               tiposReferenciaCcList.add(new SelectItem(rs.getString("COD_REFERENCIACC"),rs.getString("NOMBRE_REFERENCIACC")));
           }
           rs.close();
           st.close();
           con.close();
        }
        catch(Exception ex)
        {
            ex.printStackTrace();
        }
    }
    public String agregarEspecificacionesFisicas_action(){
        especificacionesFisicasCc = new EspecificacionesFisicasCc();
        return null;
    }
    public String guardarEspecificacionesFisicas_action()throws SQLException
    {
        mensaje="";
        Connection con = null;
        try
        {
           con=Util.openConnection(con);
           con.setAutoCommit(false);
           String consulta=" INSERT INTO ESPECIFICACIONES_FISICAS_CC(COD_ESPECIFICACION, NOMBRE_ESPECIFICACION,COD_TIPO_RESULTADO_ANALISIS,COEFICIENTE,UNIDAD) " +
                   "VALUES ((select isnull(max(e.COD_ESPECIFICACION),0)+1 from ESPECIFICACIONES_FISICAS_CC e), '"+especificacionesFisicasCc.getNombreEspecificacion()+"','"+especificacionesFisicasCc.getTipoResultadoAnalisis().getCodTipoResultadoAnalisis()+"','"+especificacionesFisicasCc.getCoeficiente()+"','"+especificacionesFisicasCc.getUnidad()+"') ";
           System.out.println("consulta " + consulta);
           PreparedStatement pst=con.prepareStatement(consulta);
           if(pst.executeUpdate()>0)System.out.println("se registro la especificacion");
           con.commit();
           mensaje="1";
           pst.close();
           con.close();
        }
        catch(Exception ex)
        {
            mensaje="Ocurrio un error al momento de registrar, intente de nuevo";
            con.rollback();
            ex.printStackTrace();
        }
        finally
        {
            con.close();
        }
        if(mensaje.equals("1"))
        {
        especificacionesFisicasCcList = this.cargarEspecificacionesFisicas();
        }
        return null;
    }
    public String eliminarEspecificacionesFisicas_action()throws SQLException
    {
        mensaje="";
        Connection con = null;
        try
        {
            Iterator i = especificacionesFisicasCcList.iterator();
            EspecificacionesFisicasCc especificacionesFisicasCc = new EspecificacionesFisicasCc();
            while(i.hasNext()){
                especificacionesFisicasCc = (EspecificacionesFisicasCc)i.next();
                if(especificacionesFisicasCc.getChecked().booleanValue()==true){
                    break;
                }
            }
           String consulta=" DELETE FROM ESPECIFICACIONES_FISICAS_CC WHERE COD_ESPECIFICACION = '"+especificacionesFisicasCc.getCodEspecificacion()+"' ";
           System.out.println("consulta " + consulta);
           con=Util.openConnection(con);
           con.setAutoCommit(false);
           PreparedStatement pst=con.prepareStatement(consulta);
           if(pst.executeUpdate()>0)System.out.println("se elimino la especificacion");
           con.commit();
           mensaje="1";
           pst.close();
           con.close();

        }
        catch(Exception ex)
        {
            mensaje="Ocurrio un error al momento de eliminar la especificacion, intente de nuevo";
            con.rollback();
            ex.printStackTrace();
        }
        finally
        {
            con.close();
        }
        if(mensaje.equals("1"))
        {
            especificacionesFisicasCcList = this.cargarEspecificacionesFisicas();
        }
        return null;
    }
    public String editarEspecificacionesFisicas_action(){
        try
        {
            Iterator i = especificacionesFisicasCcList.iterator();
            especificacionesFisicasCc = new EspecificacionesFisicasCc();
            while(i.hasNext()){
                especificacionesFisicasCc = (EspecificacionesFisicasCc)i.next();
                if(especificacionesFisicasCc.getChecked().booleanValue()==true){
                    break;
                }
            }
        }
        catch(Exception ex)
        {
            ex.printStackTrace();
        }
        return null;
    }
    public String guardarEditarEspecificacionesFisicas_action()throws SQLException
    {
        mensaje="1";
        Connection con = null;
        try
        {
           String consulta=" UPDATE ESPECIFICACIONES_FISICAS_CC  SET  NOMBRE_ESPECIFICACION = '"+especificacionesFisicasCc.getNombreEspecificacion()+"'," +
                   " COEFICIENTE='"+especificacionesFisicasCc.getCoeficiente()+"' ,COD_TIPO_RESULTADO_ANALISIS = '"+especificacionesFisicasCc.getTipoResultadoAnalisis().getCodTipoResultadoAnalisis()+"'," +
                   " UNIDAD='"+especificacionesFisicasCc.getUnidad()+"' WHERE " +
                   " COD_ESPECIFICACION = '"+especificacionesFisicasCc.getCodEspecificacion()+"' ";
           System.out.println("consulta " + consulta);
           con=Util.openConnection(con);
           con.setAutoCommit(false);
           PreparedStatement pst=con.prepareStatement(consulta);
           if(pst.executeUpdate()>0)System.out.println("se edito la especificacion");
           con.commit();
           mensaje="1";
           pst.close();
           con.close();

        }
        catch(Exception ex)
        {
            mensaje="Ocurrio un problema la momento de editar la especificacion, intente  de nuevo";
            con.rollback();
            ex.printStackTrace();
        }
        finally
        {
            con.close();
        }
        if(mensaje.equals("1"))
        {
            especificacionesFisicasCcList = this.cargarEspecificacionesFisicas();
        }
        return null;
    }
    /*-------------   */
    public List cargarEspecificacionesQuimicas(){
        List especificacionesQuimicasCcList = new ArrayList();
        try {
            String consulta = "select e.COD_ESPECIFICACION,e.NOMBRE_ESPECIFICACION,e.COD_TIPO_RESULTADO_ANALISIS,t.NOMBRE_TIPO_RESULTADO_ANALISIS," +
                              " ISNULL(e.COEFICIENTE,'') AS COEFICIENTE,ISNULL(e.UNIDAD,'') AS UNIDAD"+
                              " from ESPECIFICACIONES_QUIMICAS_CC e inner join TIPOS_RESULTADOS_ANALISIS t on e.COD_TIPO_RESULTADO_ANALISIS=t.COD_TIPO_RESULTADO_ANALISIS"+
                              " order by e.NOMBRE_ESPECIFICACION";
            Connection con = null;
            con = Util.openConnection(con);
            Statement st = con.createStatement();
            System.out.println("consulta " + consulta);
            ResultSet rs = st.executeQuery(consulta);
            especificacionesQuimicasCcList.clear();
            while(rs.next()){
                EspecificacionesQuimicasCc especificacionesQuimicasCc = new EspecificacionesQuimicasCc();
                especificacionesQuimicasCc.setCodEspecificacion(rs.getInt("COD_ESPECIFICACION"));
                especificacionesQuimicasCc.setNombreEspecificacion(rs.getString("NOMBRE_ESPECIFICACION"));
                especificacionesQuimicasCc.getTipoResultadoAnalisis().setCodTipoResultadoAnalisis(rs.getString("COD_TIPO_RESULTADO_ANALISIS"));
                especificacionesQuimicasCc.getTipoResultadoAnalisis().setNombreTipoResultadoAnalisis(rs.getString("NOMBRE_TIPO_RESULTADO_ANALISIS"));
                especificacionesQuimicasCc.setCoeficiente(rs.getString("COEFICIENTE"));
                especificacionesQuimicasCc.setUnidad(rs.getString("UNIDAD"));
                especificacionesQuimicasCcList.add(especificacionesQuimicasCc);
            }
            rs.close();
            st.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return especificacionesQuimicasCcList;
    }
    public String getCargarEspecificacionesQuimicasCc(){
        especificacionesQuimicasCcList = this.cargarEspecificacionesQuimicas();
        this.tiposResultadoAnalisisList=this.tiposResultadosAnalisis();
        return null;
    }
    public String agregarEspecificacionesQuimicas_action(){
        especificacionesQuimicasCc = new EspecificacionesQuimicasCc();
        return null;
    }
    public String guardarEspecificacionesQuimicas_action()throws SQLException
    {
        mensaje="";
        Connection con=null;
        try
        {
           String consulta=" INSERT INTO ESPECIFICACIONES_QUIMICAS_CC(  COD_ESPECIFICACION,  NOMBRE_ESPECIFICACION,COD_TIPO_RESULTADO_ANALISIS,COEFICIENTE,UNIDAD) " +
                   "VALUES ( (select isnull(max(e.COD_ESPECIFICACION),0)+1 from ESPECIFICACIONES_QUIMICAS_CC e),'"+especificacionesQuimicasCc.getNombreEspecificacion()+"', " +
                   "'"+especificacionesQuimicasCc.getTipoResultadoAnalisis().getCodTipoResultadoAnalisis()+"','"+especificacionesQuimicasCc.getCoeficiente()+"','"+especificacionesQuimicasCc.getUnidad()+"');";
           System.out.println("consulta " + consulta);
           con=Util.openConnection(con);
           con.setAutoCommit(false);
           PreparedStatement pst=con.prepareStatement(consulta);
           if(pst.executeUpdate()>0)System.out.println("se registro la especificacion quimica");
           con.commit();
           mensaje="1";
           pst.close();
           con.close();

        }
        catch(Exception ex)
        {
            mensaje="Ocurrio un error el momento de guardar la especificacion,intente de nuevo";
            con.rollback();
            ex.printStackTrace();
        }
        finally
        {
            con.close();
        }
        if(mensaje.equals("1"))
        {
            especificacionesQuimicasCcList = this.cargarEspecificacionesQuimicas();
        }

        return null;
    }
    public String eliminarEspecificacionesQuimicas_action()throws SQLException
    {
        mensaje="";
        Connection con = null;
        try
        {
            Iterator i = especificacionesQuimicasCcList.iterator();
            EspecificacionesQuimicasCc especificacionesQuimicasCc = new EspecificacionesQuimicasCc();
            while(i.hasNext()){
                especificacionesQuimicasCc = (EspecificacionesQuimicasCc)i.next();
                if(especificacionesQuimicasCc.getChecked().booleanValue()==true){
                    break;
                }
            }
           String consulta=" DELETE FROM ESPECIFICACIONES_QUIMICAS_CC WHERE COD_ESPECIFICACION = '"+especificacionesQuimicasCc.getCodEspecificacion()+"' ";
           System.out.println("consulta " + consulta);

           con=Util.openConnection(con);
           con.setAutoCommit(false);
           PreparedStatement pst=con.prepareStatement(consulta);
           if(pst.executeUpdate()>0)System.out.println("se elimino la especificacion");
           con.commit();
           mensaje="1";
           pst.close();
           con.close();

        }
        catch(Exception ex)
        {
            mensaje="Ocurrio un problema al momento de eliminar la especificacion,intente de nuevo";
            con.rollback();
            ex.printStackTrace();
        }
        finally
        {
            con.close();
        }
        if(mensaje.equals("1"))
        {
            especificacionesQuimicasCcList = this.cargarEspecificacionesQuimicas();
        }
        return null;
    }
    public String editarEspecificacionesQuimicas_action(){
        try
        {
            Iterator i = especificacionesQuimicasCcList.iterator();
            especificacionesQuimicasCc = new EspecificacionesQuimicasCc();
            while(i.hasNext()){
                especificacionesQuimicasCc = (EspecificacionesQuimicasCc)i.next();
                if(especificacionesQuimicasCc.getChecked().booleanValue()==true){
                    break;
                }
            }
        }
        catch(Exception ex)
        {
            ex.printStackTrace();
        }
        return null;
    }
    public String guardarEditarEspecificacionesQuimicas_action()throws SQLException
    {
        mensaje="";
        Connection con = null;
        try
        {
           String consulta = " UPDATE ESPECIFICACIONES_QUIMICAS_CC  SET   NOMBRE_ESPECIFICACION = '"+especificacionesQuimicasCc.getNombreEspecificacion()+"'," +
                   " COEFICIENTE='"+especificacionesQuimicasCc.getCoeficiente()+"', " +
                   " COD_TIPO_RESULTADO_ANALISIS = '"+especificacionesQuimicasCc.getTipoResultadoAnalisis().getCodTipoResultadoAnalisis()+"'" +
                   " ,UNIDAD ='"+especificacionesQuimicasCc.getUnidad()+"' WHERE COD_ESPECIFICACION = '"+especificacionesQuimicasCc.getCodEspecificacion()+"' ";
           System.out.println("consulta " + consulta);
           con=Util.openConnection(con);
           con.setAutoCommit(false);
           PreparedStatement pst=con.prepareStatement(consulta);
           if(pst.executeUpdate()>0)System.out.println("se edito la especificacion");
           con.commit();
           mensaje="1";
           pst.close();
           con.close();

        }
        catch(Exception ex)
        {
            mensaje="Ocurrio un problema al momento de registrar la edicion, intente de nuevo";
            con.rollback();
            ex.printStackTrace();
        }
        finally
        {
            con.close();
        }
        if(mensaje.equals("1"))
        {
            especificacionesQuimicasCcList = this.cargarEspecificacionesQuimicas();
        }
        return null;
    }
    /*-------------------- */
    public List cargarEspecificacionesMicrobiologia(){
        List especificacionesMicrobiologiaCcList = new ArrayList();
        try {
            String consulta = "select e.COD_ESPECIFICACION,e.NOMBRE_ESPECIFICACION,e.COD_TIPO_RESULTADO_ANALISIS,t.NOMBRE_TIPO_RESULTADO_ANALISIS," +
                              " ISNULL(e.COEFICIENTE,'') AS COEFICIENTE,ISNULL(e.UNIDAD,'') as UNIDAD"+
                              " from ESPECIFICACIONES_MICROBIOLOGIA e INNER JOIN TIPOS_RESULTADOS_ANALISIS t"+
                              " on e.COD_TIPO_RESULTADO_ANALISIS=t.COD_TIPO_RESULTADO_ANALISIS order by e.NOMBRE_ESPECIFICACION";

            Connection con = null;
            con = Util.openConnection(con);
            Statement st = con.createStatement();
            System.out.println("consulta " + consulta);
            ResultSet rs = st.executeQuery(consulta);
            especificacionesMicrobiologiaCcList.clear();
            while(rs.next()){
                EspecificacionesMicrobiologiaCc especificacionesMicrobiologiaCc = new EspecificacionesMicrobiologiaCc();
                especificacionesMicrobiologiaCc.setCodEspecificacion(rs.getInt("COD_ESPECIFICACION"));
                especificacionesMicrobiologiaCc.setNombreEspecificacion(rs.getString("NOMBRE_ESPECIFICACION"));
                especificacionesMicrobiologiaCc.setCoeficiente(rs.getString("COEFICIENTE"));
               // especificacionesMicrobiologiaCc.getTiposReferenciaCc().setCodReferenciaCc(rs.getInt("COD_REFERENCIACC"));
               // especificacionesMicrobiologiaCc.getTiposReferenciaCc().setNombreReferenciaCc(rs.getString("NOMBRE_REFERENCIACC"));
                //especificacionesMicrobiologiaCc.setDescriptivo(rs.getInt("DESCRIPTIVO"));
                especificacionesMicrobiologiaCc.getTipoResultadoAnalisis().setCodTipoResultadoAnalisis(rs.getString("COD_TIPO_RESULTADO_ANALISIS"));
                especificacionesMicrobiologiaCc.getTipoResultadoAnalisis().setNombreTipoResultadoAnalisis(rs.getString("NOMBRE_TIPO_RESULTADO_ANALISIS"));
                especificacionesMicrobiologiaCc.setUnidad(rs.getString("UNIDAD"));
                especificacionesMicrobiologiaCcList.add(especificacionesMicrobiologiaCc);
            }
            rs.close();
            st.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return especificacionesMicrobiologiaCcList;
    }
    public String getCargarEspecificacionesMicrobiologiaCc(){
        this.tiposResultadoAnalisisList=this.tiposResultadosAnalisis();
        especificacionesMicrobiologiaCcList = this.cargarEspecificacionesMicrobiologia();
        this.cargarTiposReferenciaCc();
        return null;
    }
    public String agregarEspecificacionesMicrobiologia_action(){
        especificacionesMicrobiologiaCc = new EspecificacionesMicrobiologiaCc();
        return null;
    }
    public String guardarEspecificacionesMicrobiologia_action()throws SQLException
    {
        Connection con=null;
        mensaje="";
        try
        {
           String consulta=" INSERT INTO ESPECIFICACIONES_MICROBIOLOGIA(COD_ESPECIFICACION, NOMBRE_ESPECIFICACION,COD_TIPO_RESULTADO_ANALISIS,COEFICIENTE,UNIDAD) " +
                   "VALUES ((select isnull(max(e.COD_ESPECIFICACION),0)+1 from ESPECIFICACIONES_MICROBIOLOGIA e), '"+especificacionesMicrobiologiaCc.getNombreEspecificacion()+"'," +
                   " '"+especificacionesMicrobiologiaCc.getTipoResultadoAnalisis().getCodTipoResultadoAnalisis()+"','"+especificacionesMicrobiologiaCc.getCoeficiente()+"','"+especificacionesMicrobiologiaCc.getUnidad()+"'); ";
           System.out.println("consulta " + consulta);
           con=Util.openConnection(con);
           con.setAutoCommit(false);
           PreparedStatement pst=con.prepareStatement(consulta);
           if(pst.executeUpdate()>0)System.out.println("se registro la especificacion");
           con.commit();
           mensaje="1";
           pst.close();
           con.close();

        }
        catch(Exception ex)
        {
            con.rollback();
            ex.printStackTrace();
            mensaje="Ocurrio un problema al momento de registrar la especificacion, intente de nuevo";
        }
        finally
        {
            con.close();
        }
        if(mensaje.equals("1"))
        {
            especificacionesMicrobiologiaCcList = this.cargarEspecificacionesMicrobiologia();
        }
        return null;
    }
    public String eliminarEspecificacionesMicrobiologia_action()throws SQLException
    {
        Connection con = null;
        mensaje="";
        try
        {
            Iterator i = especificacionesMicrobiologiaCcList.iterator();
            EspecificacionesMicrobiologiaCc especificacionesMicrobiologiaCc = new EspecificacionesMicrobiologiaCc();
            while(i.hasNext()){
                especificacionesMicrobiologiaCc = (EspecificacionesMicrobiologiaCc)i.next();
                if(especificacionesMicrobiologiaCc.getChecked().booleanValue()==true){
                    break;
                }
            }
           String consulta=" DELETE FROM ESPECIFICACIONES_MICROBIOLOGIA WHERE COD_ESPECIFICACION = '"+especificacionesMicrobiologiaCc.getCodEspecificacion()+"' ";
           System.out.println("consulta " + consulta);
           con=Util.openConnection(con);
           PreparedStatement pst=con.prepareStatement(consulta);
           if(pst.executeUpdate()>0)System.out.println("se elimino la especificacion");
           con.commit();
           mensaje="1";
           pst.close();
           con.close();

        }
        catch(Exception ex)
        {
            mensaje="Ocurrio un problema al momento de eliminar la especificacion, intente de nuevo";
            con.rollback();
            ex.printStackTrace();
        }
        finally
        {
            con.close();
        }
        if(mensaje.equals("1"))
        {
            especificacionesMicrobiologiaCcList = this.cargarEspecificacionesMicrobiologia();
        }
        return null;
    }
    public String editarEspecificacionesMicrobiologia_action(){
        try
        {
            Iterator i = especificacionesMicrobiologiaCcList.iterator();
            especificacionesMicrobiologiaCc = new EspecificacionesMicrobiologiaCc();
            while(i.hasNext()){
                especificacionesMicrobiologiaCc = (EspecificacionesMicrobiologiaCc)i.next();
                if(especificacionesMicrobiologiaCc.getChecked().booleanValue()==true){
                    break;
                }
            }
        }
        catch(Exception ex)
        {
            ex.printStackTrace();
        }
        return null;
    }
    public String guardarEditarEspecificacionesMicrobiologia_action()throws SQLException
    {
        Connection con = null;
        mensaje="";
        try
        {
           String consulta=" UPDATE ESPECIFICACIONES_MICROBIOLOGIA  SET  NOMBRE_ESPECIFICACION = '"+especificacionesMicrobiologiaCc.getNombreEspecificacion()+"'," +
                   " COEFICIENTE='"+especificacionesMicrobiologiaCc.getCoeficiente()+"'," +
                   " UNIDAD='"+especificacionesMicrobiologiaCc.getUnidad()+"'," +
                   " COD_TIPO_RESULTADO_ANALISIS = '"+especificacionesMicrobiologiaCc.getTipoResultadoAnalisis().getCodTipoResultadoAnalisis()+"' WHERE " +
                   " COD_ESPECIFICACION = '"+especificacionesMicrobiologiaCc.getCodEspecificacion()+"' ";
           System.out.println("consulta " + consulta);

           con=Util.openConnection(con);
           con.setAutoCommit(false);
           PreparedStatement pst=con.prepareStatement(consulta);
           if(pst.executeUpdate()>0)System.out.println("se guardo la edicion");
           con.commit();
           mensaje="1";
           pst.close();
           con.close();

        }
        catch(Exception ex)
        {
            mensaje="Ocurrio un problema al momento de guardar la edicion, intente de nuevo";
            con.rollback();
            ex.printStackTrace();
        }
        finally
        {
            con.close();
        }
        if(mensaje.equals("1"))
        {
            especificacionesMicrobiologiaCcList = this.cargarEspecificacionesMicrobiologia();
        }
        return null;
    }
    private void cargarTiposEspecificacionesFisicasSelect()
     {
         try
         {
             Connection con=null;
             con=Util.openConnection(con);
             Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
             String consulta="select tef.COD_TIPO_ESPECIFICACION_FISICA,tef.NOMBRE_TIPO_ESPECIFICACION_FISICA "+
                             " from TIPOS_ESPECIFICACIONES_FISICAS tef order by tef.NOMBRE_TIPO_ESPECIFICACION_FISICA";
             ResultSet res=st.executeQuery(consulta);
             tiposEspecificacionesFisicasSelect=new ArrayList<SelectItem>();
             tiposEspecificacionesFisicasSelect.add(new SelectItem(0,"-NINGUNO-"));
             while(res.next())
             {
                 tiposEspecificacionesFisicasSelect.add(new SelectItem(res.getInt("COD_TIPO_ESPECIFICACION_FISICA"),res.getString("NOMBRE_TIPO_ESPECIFICACION_FISICA")));
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
    public String getCargarFormasFarmaceuticasCc(){
        this.cargarTiposEspecificacionesFisicasSelect();
        formasFarmaceuticasList = this.cargarFormasFarmaceuticas();
        return null;
    }
    public List cargarFormasFarmaceuticas(){
        List formasFarmaceuticasList = new ArrayList();
        try {
            String consulta = "select f.cod_forma,f.nombre_forma,f.abreviatura_forma,u.COD_UNIDAD_MEDIDA,u.NOMBRE_UNIDAD_MEDIDA " +
                    " from FORMAS_FARMACEUTICAS f inner join UNIDADES_MEDIDA u on u.COD_UNIDAD_MEDIDA = f.cod_unidad_medida " +
                    " where f.cod_estado_registro = 1 order by f.nombre_forma";
            Connection con = null;
            con = Util.openConnection(con);
            Statement st = con.createStatement();
            System.out.println("consulta " + consulta);
            ResultSet rs = st.executeQuery(consulta);
            formasFarmaceuticasList.clear();
            while(rs.next()){
                FormasFarmaceuticas formasFarmaceuticas = new FormasFarmaceuticas();
                formasFarmaceuticas.setCodForma(rs.getString("cod_forma"));
                formasFarmaceuticas.setNombreForma(rs.getString("nombre_forma"));
                formasFarmaceuticas.setAbreviaturaForma(rs.getString("abreviatura_forma"));
                formasFarmaceuticas.getUnidadMedida().setCodUnidadMedida(rs.getString("cod_unidad_medida"));
                formasFarmaceuticas.getUnidadMedida().setNombreUnidadMedida(rs.getString("nombre_unidad_medida"));
                formasFarmaceuticasList.add(formasFarmaceuticas);
            }
            rs.close();
            st.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return formasFarmaceuticasList;
    }
    public String seleccionarFormaFarmaceutica_action(){
        formasFarmaceuticasSeleccionado = (FormasFarmaceuticas)formasFarmaceuticasDataTable.getRowData();
        this.redireccionar("navegadorEspecificacionesFormaFar.jsf");
        return null;
    }
    private void cargarTiposAnalisisCc()
    {

        String consulta=" select t.COD_TIPO_ANALISIS,t.NOMBRE_TIPO_ANALISIS from TIPOS_ANALISIS t order by t.NOMBRE_TIPO_ANALISIS";
        try
        {
           Connection con = null;
           con=Util.openConnection(con);
           Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
           ResultSet rs=st.executeQuery(consulta);
           tiposAnalisisCcList.clear();
           while(rs.next()){
               tiposAnalisisCcList.add(new SelectItem(rs.getInt("COD_TIPO_ANALISIS"),rs.getString("NOMBRE_TIPO_ANALISIS")));
           }
           codTipoAnalisisCc=1;
           this.tiposAnalisisControlCalidad_change();
           rs.close();
           st.close();
           con.close();
        }
        catch(Exception ex)
        {
            ex.printStackTrace();
        }
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
    public String getCargarAnalisisControlCalidad(){
        this.cargarTiposAnalisisCc();
        return null;
    }
    public String tiposAnalisisControlCalidad_change(){
        try {

        String consulta = "";
        String consulta1 = "";
        if(codTipoAnalisisCc==1){
        consulta = " select e1.COD_TIPO_ESPECIFICACION_FISICA,e.COD_ESPECIFICACION,  e.NOMBRE_ESPECIFICACION, e.COD_TIPO_RESULTADO_ANALISIS,t.NOMBRE_TIPO_RESULTADO_ANALISIS " +
                ",ISNULL(e.COEFICIENTE, '') AS COEFICIENTE,ISNULL(e.UNIDAD, '') as UNIDAD" +
                " ,isnull(tef.NOMBRE_TIPO_ESPECIFICACION_FISICA,'') as NOMBRE_TIPO_ESPECIFICACION_FISICA" +
                " from ESPECIFICACIONES_FISICAS_CC e inner join TIPOS_RESULTADOS_ANALISIS t on t.COD_TIPO_RESULTADO_ANALISIS=e.COD_TIPO_RESULTADO_ANALISIS" +
                " inner join ESPECIFICACIONES_ANALISIS_FORMAFAR e1 on e1.COD_ESPECIFICACION = e.COD_ESPECIFICACION and e1.COD_TIPO_ANALISIS = '"+codTipoAnalisisCc+"' and e1.cod_formafar = '"+formasFarmaceuticasSeleccionado.getCodForma()+"'" +
                " left outer join TIPOS_ESPECIFICACIONES_FISICAS tef on tef.COD_TIPO_ESPECIFICACION_FISICA=e1.COD_TIPO_ESPECIFICACION_FISICA" +
                " order by e.NOMBRE_ESPECIFICACION";
        consulta1 = " select e.COD_ESPECIFICACION,  e.NOMBRE_ESPECIFICACION ,isnull(e.COEFICIENTE,'') as COEFICIENTE,isnull(e.UNIDAD,'') as UNIDAD from ESPECIFICACIONES_FISICAS_CC e where e.cod_especificacion not in (select e.COD_ESPECIFICACION from ESPECIFICACIONES_FISICAS_CC e inner join ESPECIFICACIONES_ANALISIS_FORMAFAR e1 on e1.COD_ESPECIFICACION = e.COD_ESPECIFICACION and e1.COD_TIPO_ANALISIS = '"+codTipoAnalisisCc+"' and e1.cod_formafar = '"+formasFarmaceuticasSeleccionado.getCodForma()+"') order by e.NOMBRE_ESPECIFICACION";
        }
        if(codTipoAnalisisCc==2){
        consulta = " select e.COD_ESPECIFICACION,  e.NOMBRE_ESPECIFICACION,e.COD_TIPO_RESULTADO_ANALISIS,t.NOMBRE_TIPO_RESULTADO_ANALISIS " +
                " ,ISNULL(e.COEFICIENTE, '') AS COEFICIENTE,ISNULL(e.UNIDAD, '') as UNIDAD from ESPECIFICACIONES_QUIMICAS_CC e inner join TIPOS_RESULTADOS_ANALISIS t on t.COD_TIPO_RESULTADO_ANALISIS=e.COD_TIPO_RESULTADO_ANALISIS" +
                " inner join ESPECIFICACIONES_ANALISIS_FORMAFAR e1 on e1.COD_ESPECIFICACION = e.COD_ESPECIFICACION and e1.COD_TIPO_ANALISIS = '"+codTipoAnalisisCc+"' and e1.cod_formafar = '"+formasFarmaceuticasSeleccionado.getCodForma()+"' order by e.NOMBRE_ESPECIFICACION";
        consulta1 = " select e.COD_ESPECIFICACION,  e.NOMBRE_ESPECIFICACION,isnull(e.COEFICIENTE,'') as COEFICIENTE,isnull(e.UNIDAD,'') as UNIDAD from ESPECIFICACIONES_QUIMICAS_CC e where e.cod_especificacion not in (select e.COD_ESPECIFICACION from ESPECIFICACIONES_QUIMICAS_CC e inner join ESPECIFICACIONES_ANALISIS_FORMAFAR e1 on e1.COD_ESPECIFICACION = e.COD_ESPECIFICACION and e1.COD_TIPO_ANALISIS = '"+codTipoAnalisisCc+"' and e1.cod_formafar = '"+formasFarmaceuticasSeleccionado.getCodForma()+"') order by e.NOMBRE_ESPECIFICACION";
        }
        if(codTipoAnalisisCc==3){
        consulta = " select e.COD_ESPECIFICACION,  e.NOMBRE_ESPECIFICACION,e.COD_TIPO_RESULTADO_ANALISIS,t.NOMBRE_TIPO_RESULTADO_ANALISIS " +
                " ,ISNULL(e.COEFICIENTE, '') AS COEFICIENTE,ISNULL(e.UNIDAD, '') as UNIDAD from ESPECIFICACIONES_MICROBIOLOGIA e inner join TIPOS_RESULTADOS_ANALISIS t on t.COD_TIPO_RESULTADO_ANALISIS=e.COD_TIPO_RESULTADO_ANALISIS" +
                " inner join ESPECIFICACIONES_ANALISIS_FORMAFAR e1 on e1.COD_ESPECIFICACION = e.COD_ESPECIFICACION and e1.COD_TIPO_ANALISIS = '"+codTipoAnalisisCc+"' and e1.cod_formafar = '"+formasFarmaceuticasSeleccionado.getCodForma()+"' order by e.NOMBRE_ESPECIFICACION";
        consulta1 = " select e.COD_ESPECIFICACION,  e.NOMBRE_ESPECIFICACION,isnull(e.COEFICIENTE,'') as COEFICIENTE,isnull(e.UNIDAD,'') as UNIDAD from ESPECIFICACIONES_MICROBIOLOGIA e where e.cod_especificacion not in (select e.COD_ESPECIFICACION from ESPECIFICACIONES_MICROBIOLOGIA e inner join ESPECIFICACIONES_ANALISIS_FORMAFAR e1 on e1.COD_ESPECIFICACION = e.COD_ESPECIFICACION and e1.COD_TIPO_ANALISIS = '"+codTipoAnalisisCc+"' and e1.cod_formafar = '"+formasFarmaceuticasSeleccionado.getCodForma()+"') order by e.NOMBRE_ESPECIFICACION";
        }
            System.out.println("consulta " + consulta);
           Connection con = null;
           con=Util.openConnection(con);
           Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
           ResultSet rs=st.executeQuery(consulta);
           especificacionesCcList.clear();
           while(rs.next()){
               EspecificacionesFisicasCc especificacionesFisicasCc = new EspecificacionesFisicasCc();
               if(codTipoAnalisisCc==1)
               {
                   especificacionesFisicasCc.getTiposEspecificacionesFisicas().setCodTipoEspecificacionFisica(rs.getInt("COD_TIPO_ESPECIFICACION_FISICA"));
                   especificacionesFisicasCc.getTiposEspecificacionesFisicas().setNombreTipoEspecificacionFisica(rs.getString("NOMBRE_TIPO_ESPECIFICACION_FISICA"));
               }
               especificacionesFisicasCc.setCodEspecificacion(rs.getInt("cod_especificacion"));
               especificacionesFisicasCc.setNombreEspecificacion(rs.getString("nombre_especificacion"));
               especificacionesFisicasCc.setUnidad(rs.getString("UNIDAD"));
               especificacionesFisicasCc.setCoeficiente(rs.getString("COEFICIENTE"));
               especificacionesFisicasCc.getTipoResultadoAnalisis().setCodTipoResultadoAnalisis(rs.getString("COD_TIPO_RESULTADO_ANALISIS"));
               especificacionesFisicasCc.getTipoResultadoAnalisis().setNombreTipoResultadoAnalisis(rs.getString("NOMBRE_TIPO_RESULTADO_ANALISIS"));
               especificacionesCcList.add(especificacionesFisicasCc);
           }
           rs.close();
           st.close();
           con.close();
           this.cargarEspecificacionesAgregar(consulta1);
           } catch (Exception e) {
               e.printStackTrace();
        }
        return null;
    }
    private void cargarEspecificacionesAgregar(String consulta)
    {
        try
        {
           System.out.println("consulta " + consulta);
           Connection con = null;
           con=Util.openConnection(con);
           Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
           ResultSet rs=st.executeQuery(consulta);
           especificacionesAgregarList.clear();
           especificacionesAgregarList.add(new SelectItem("0","-NINGUNO-"));
           listaEspecificaciones.clear();
           while(rs.next()){
              EspecificacionesFisicasCc bean= new EspecificacionesFisicasCc();
              bean.setCodEspecificacion(rs.getInt("COD_ESPECIFICACION"));
              bean.setNombreEspecificacion(rs.getString("NOMBRE_ESPECIFICACION"));
              bean.setUnidad(rs.getString("UNIDAD"));
              bean.setCoeficiente(rs.getString("COEFICIENTE"));
              listaEspecificaciones.add(bean);
               especificacionesAgregarList.add(new SelectItem(rs.getString("COD_ESPECIFICACION"),rs.getString("NOMBRE_ESPECIFICACION")));
           }
           rs.close();
           st.close();
           con.close();
        }
        catch(Exception ex)
        {
            ex.printStackTrace();
        }
    }
    public String guardarEspecificaciones_action(){

        try
        {
            Connection con = null;
           con=Util.openConnection(con);
           String consulta="";
           for(EspecificacionesFisicasCc current:listaEspecificaciones)
           {
           if(current.getChecked().booleanValue())
           {
           consulta = " INSERT INTO ESPECIFICACIONES_ANALISIS_FORMAFAR(COD_FORMAFAR,  COD_ESPECIFICACION,  COD_TIPO_ANALISIS,COD_TIPO_ESPECIFICACION_FISICA) " +
                   "VALUES (  '"+formasFarmaceuticasSeleccionado.getCodForma()+"', '"+current.getCodEspecificacion()+"', '"+codTipoAnalisisCc+"','"+current.getTiposEspecificacionesFisicas().getCodTipoEspecificacionFisica()+"') ";
           System.out.println("consulta " + consulta);
           PreparedStatement pst=con.prepareStatement(consulta);
           if(pst.executeUpdate()>0)System.out.println("se inserto la especificacion");
           pst.close();
           }
           }
           setMensaje("");



           con.close();
           tiposAnalisisControlCalidad_change();
        }
        catch(Exception ex)
        {
            ex.printStackTrace();
        }
        return null;
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
    public String cancelar()
     {
         this.redireccionar("navegador_componentesProducto.jsf");
         return null;
     }
    public String guardarEdicionVersionAnalisisQuimico_Action() throws SQLException
     {
          Connection con=null;
          mensaje="";
         try
         {
             con=Util.openConnection(con);
             con.setAutoCommit(false);
             ManagedAccesoSistema managed=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
             String consulta="update VERSION_ESPECIFICACIONES_PRODUCTO set COD_PERSONAL_MODIFICA='"+managed.getUsuarioModuloBean().getCodUsuarioGlobal()+"'," +
                     " OBSERVACION='"+versionEspecificacionesProductoQuimica.getObservacion()+"'" +
                     " where COD_VERSION_ESPECIFICACION_PRODUCTO='"+versionEspecificacionesProductoQuimica.getCodVersionEspecificacionProducto()+"'";
            PreparedStatement pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se actualizo la observacion de la version");
            consulta="delete from ESPECIFICACIONES_QUIMICAS_PRODUCTO where COD_PRODUCTO='"+componentesProd.getCodCompprod()+"' and COD_VERSION_ESPECIFICACION_PRODUCTO='"+versionEspecificacionesProductoQuimica.getCodVersionEspecificacionProducto()+"'";
            System.out.println("consulta delete "+consulta);
            pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se eliminaron registros de la version");
            for(EspecificacionesQuimicasCc current:listaEspecificacionesQuimicasCc)
                 {

                     for(EspecificacionesQuimicasProducto current1:current.getListaEspecificacionesQuimicasProducto())
                     {

                         consulta="INSERT INTO ESPECIFICACIONES_QUIMICAS_PRODUCTO(COD_ESPECIFICACION, COD_PRODUCTO,"+
                                          "COD_MATERIAL, LIMITE_INFERIOR, LIMITE_SUPERIOR, DESCRIPCION, ESTADO,"+
                                          " COD_REFERENCIA_CC,VALOR_EXACTO,COD_MATERIAL_COMPUESTO_CC,COD_VERSION_ESPECIFICACION_PRODUCTO) VALUES (" +
                                          "'"+current.getCodEspecificacion()+"','"+current1.getComponenteProd().getCodCompprod()+"','"+current1.getMaterial().getCodMaterial()+"'"+
                                          ",'"+current1.getLimiteInferior()+"','"+current1.getLimiteSuperior()+"','"+current1.getDescripcion()+"'," +
                                          "'"+current1.getEstado().getCodEstadoRegistro()+"','"+current1.getTiposReferenciaCc().getCodReferenciaCc()+"'" +
                                          ",'"+current1.getValorExacto()+"','"+current1.getMaterialesCompuestosCc().getCodMaterialCompuestoCc()+"','"+versionEspecificacionesProductoQuimica.getCodVersionEspecificacionProducto()+"')";
                                          System.out.println("consulta "+consulta);

                         pst=con.prepareStatement(consulta);
                         if(pst.executeUpdate()>0)System.out.println("se registro el detalle");
                     }
                 }
            con.commit();
            pst.close();
            mensaje="1";
            con.close();
         }
         catch(SQLException ex)
         {
             System.out.println("error control de calidad quimicas "+listaEspecificacionesQuimicasCc.size());
             mensaje=" Ocurrio un error al momento de registrar las especificaciones intente de nuevo. Si el problema persiste comuniquese con sistemas";
             con.rollback();
             con.close();
             ex.printStackTrace();
         }
        
         return null;
     }
      public String guardarAnalisisQuimico_Action() throws SQLException
     {
          Connection con=null;
          mensaje="";
         try
         {
             con=Util.openConnection(con);
             con.setAutoCommit(false);
             String consulta=" select isnull(MAX(v.COD_VERSION_ESPECIFICACION_PRODUCTO),0)+1 as codVersion  from VERSION_ESPECIFICACIONES_PRODUCTO v ";
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta);
            int codVersionEspecificacion=0;
            ManagedAccesoSistema managed=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
            if(res.next())codVersionEspecificacion=res.getInt("codVersion");
            SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
            consulta="UPDATE  VERSION_ESPECIFICACIONES_PRODUCTO SET VERSION_ACTIVA=0 WHERE COD_COMPPROD='"+componentesProd.getCodCompprod()+"' and COD_TIPO_ANALISIS=2;" +
                    " INSERT INTO VERSION_ESPECIFICACIONES_PRODUCTO(COD_VERSION_ESPECIFICACION_PRODUCTO,NRO_VERSION_ESPECIFICACION_PRODUCTO"+
                     " ,FECHA_CREACION, VERSION_ACTIVA, COD_TIPO_ANALISIS, COD_COMPPROD, OBSERVACION,COD_PERSONAL_REGISTRA,COD_PERSONAL_MODIFICA)"+
                     "VALUES ('"+codVersionEspecificacion+"',(select isnull(max(v.NRO_VERSION_ESPECIFICACION_PRODUCTO),0)+1 from VERSION_ESPECIFICACIONES_PRODUCTO v where v.COD_TIPO_ANALISIS=2 and v.COD_COMPPROD='"+componentesProd.getCodCompprod()+"'),"+
                     "'"+sdf.format(new Date())+"',1,2,'"+componentesProd.getCodCompprod()+"','"+versionEspecificacionRegistrar.getObservacion()+"'" +
                     ",'"+managed.getUsuarioModuloBean().getCodUsuarioGlobal()+"',0)";
            System.out.println("consulta insertar nueva version  "+consulta);
            PreparedStatement pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se registro la nueva version" );
            for(EspecificacionesQuimicasCc current:listaEspecificacionesQuimicasCc)
                 {

                     for(EspecificacionesQuimicasProducto current1:current.getListaEspecificacionesQuimicasProducto())
                     {

                         consulta="INSERT INTO ESPECIFICACIONES_QUIMICAS_PRODUCTO(COD_ESPECIFICACION, COD_PRODUCTO,"+
                                          "COD_MATERIAL, LIMITE_INFERIOR, LIMITE_SUPERIOR, DESCRIPCION, ESTADO,"+
                                          " COD_REFERENCIA_CC,VALOR_EXACTO,COD_MATERIAL_COMPUESTO_CC,COD_VERSION_ESPECIFICACION_PRODUCTO) VALUES (" +
                                          "'"+current.getCodEspecificacion()+"','"+current1.getComponenteProd().getCodCompprod()+"','"+current1.getMaterial().getCodMaterial()+"'"+
                                          ",'"+current1.getLimiteInferior()+"','"+current1.getLimiteSuperior()+"','"+current1.getDescripcion()+"'," +
                                          "'"+current1.getEstado().getCodEstadoRegistro()+"','"+current1.getTiposReferenciaCc().getCodReferenciaCc()+"'" +
                                          ",'"+current1.getValorExacto()+"','"+current1.getMaterialesCompuestosCc().getCodMaterialCompuestoCc()+"','"+codVersionEspecificacion+"')";
                                          System.out.println("consulta "+consulta);

                         pst=con.prepareStatement(consulta);
                         if(pst.executeUpdate()>0)System.out.println("se registro el detalle");
                     }
                 }
            con.commit();
            pst.close();
            mensaje="1";
            con.close();
         }
         catch(SQLException ex)
         {
             System.out.println("error control de calidad quimicas "+listaEspecificacionesQuimicasCc.size());
               for(EspecificacionesQuimicasCc current:listaEspecificacionesQuimicasCc)
               {
                   System.out.println("cod cc "+current.getCodEspecificacion());
               }
             mensaje=" Ocurrio un error al momento de registrar las especificaciones intente de nuevo. Si el problema persiste comuniquese con sistemas";
             con.rollback();
             ex.printStackTrace();
         }
         finally
         {
              con.close();
         }
         //this.redireccionar("navegador_componentesProducto.jsf");
         return null;
     }
    public String eliminarEspecificaciones_action(){
        try
        {
            Iterator i = especificacionesCcList.iterator();
            EspecificacionesFisicasCc especificacionesFisicasCc = new EspecificacionesFisicasCc();
            while(i.hasNext()){
                especificacionesFisicasCc = (EspecificacionesFisicasCc)i.next();
                if(especificacionesFisicasCc.getChecked().booleanValue()==true){
                    break;
                }
            }
           String consulta=" DELETE FROM ESPECIFICACIONES_QUIMICAS_CC WHERE COD_ESPECIFICACION = '"+especificacionesQuimicasCc.getCodEspecificacion()+"' ";
           consulta = " DELETE FROM ESPECIFICACIONES_ANALISIS_FORMAFAR WHERE COD_FORMAFAR = '"+formasFarmaceuticasSeleccionado.getCodForma()+"' AND  COD_ESPECIFICACION = '"+especificacionesFisicasCc.getCodEspecificacion()+"' AND COD_TIPO_ANALISIS = '"+codTipoAnalisisCc+"'";
           System.out.println("consulta " + consulta);
           Connection con = null;
           con=Util.openConnection(con);
           Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
           st.executeUpdate(consulta);
           st.close();
           con.close();
           tiposAnalisisControlCalidad_change();
        }
        catch(Exception ex)
        {
            ex.printStackTrace();
        }
        return null;
    }

    public List<EspecificacionesFisicasCc> getListaEspecificaciones() {
        return listaEspecificaciones;
    }

    public void setListaEspecificaciones(List<EspecificacionesFisicasCc> listaEspecificaciones) {
        this.listaEspecificaciones = listaEspecificaciones;
    }

    public List<SelectItem> getTiposResultadoAnalisisList() {
        return tiposResultadoAnalisisList;
    }

    public void setTiposResultadoAnalisisList(List<SelectItem> tiposResultadoAnalisisList) {
        this.tiposResultadoAnalisisList = tiposResultadoAnalisisList;
    }

    public ComponentesProd getComponentesProdbean() {
        return componentesProdbean;
    }

    public void setComponentesProdbean(ComponentesProd componentesProdbean) {
        this.componentesProdbean = componentesProdbean;
    }

    public List<ComponentesProd> getComponentesProductoList() {
        return componentesProductoList;
    }

    public void setComponentesProductoList(List<ComponentesProd> componentesProductoList) {
        this.componentesProductoList = componentesProductoList;
    }

    public List<SelectItem> getEstadosCompProdList() {
        return estadosCompProdList;
    }

    public void setEstadosCompProdList(List<SelectItem> estadosCompProdList) {
        this.estadosCompProdList = estadosCompProdList;
    }

    public List<SelectItem> getProductosList() {
        return productosList;
    }

    public void setProductosList(List<SelectItem> productosList) {
        this.productosList = productosList;
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

    public ComponentesProd getComponentesProd() {
        return componentesProd;
    }

    public void setComponentesProd(ComponentesProd componentesProd) {
        this.componentesProd = componentesProd;
    }

    public List<SelectItem> getCapitulosList() {
        return capitulosList;
    }

    public void setCapitulosList(List<SelectItem> capitulosList) {
        this.capitulosList = capitulosList;
    }

    public List<SelectItem> getGruposList() {
        return gruposList;
    }

    public void setGruposList(List<SelectItem> gruposList) {
        this.gruposList = gruposList;
    }

    public Materiales getMaterialBean() {
        return materialBean;
    }

    public void setMaterialBean(Materiales materialBean) {
        this.materialBean = materialBean;
    }

    public List<Materiales> getMaterialesList() {
        return materialesList;
    }

    public void setMaterialesList(List<Materiales> materialesList) {
        this.materialesList = materialesList;
    }

    public int getBegin() {
        return begin;
    }

    public void setBegin(int begin) {
        this.begin = begin;
    }

    public int getEnd() {
        return end;
    }

    public void setEnd(int end) {
        this.end = end;
    }

    public int getCantidadFilas() {
        return cantidadFilas;
    }

    public void setCantidadFilas(int cantidadFilas) {
        this.cantidadFilas = cantidadFilas;
    }

    public String getNombreMaterialBaco() {
        return nombreMaterialBaco;
    }

    public void setNombreMaterialBaco(String nombreMaterialBaco) {
        this.nombreMaterialBaco = nombreMaterialBaco;
    }

    public Materiales getMaterialEditar() {
        return materialEditar;
    }

    public void setMaterialEditar(Materiales materialEditar) {
        this.materialEditar = materialEditar;
    }

    public List<ComponentesProdConcentracion> getComponentesProdConcentracionList() {
        return componentesProdConcentracionList;
    }

    public void setComponentesProdConcentracionList(List<ComponentesProdConcentracion> componentesProdConcentracionList) {
        this.componentesProdConcentracionList = componentesProdConcentracionList;
    }

    public List<SelectItem> getUnidadesMedidaList() {
        return unidadesMedidaList;
    }

    public void setUnidadesMedidaList(List<SelectItem> unidadesMedidaList) {
        this.unidadesMedidaList = unidadesMedidaList;
    }

    public String getUnidadesProducto() {
        return unidadesProducto;
    }

    public void setUnidadesProducto(String unidadesProducto) {
        this.unidadesProducto = unidadesProducto;
    }

    public List<SelectItem> getTiposEspecificacionesFisicas() {
        return tiposEspecificacionesFisicas;
    }

    public void setTiposEspecificacionesFisicas(List<SelectItem> tiposEspecificacionesFisicas) {
        this.tiposEspecificacionesFisicas = tiposEspecificacionesFisicas;
    }

    public List<TiposReferenciaCc> getTiposReferenciaCcABMList() {
        return tiposReferenciaCcABMList;
    }

    public void setTiposReferenciaCcABMList(List<TiposReferenciaCc> tiposReferenciaCcABMList) {
        this.tiposReferenciaCcABMList = tiposReferenciaCcABMList;
    }

    public TiposReferenciaCc getTiposReferenciaCcAgregar() {
        return tiposReferenciaCcAgregar;
    }

    public void setTiposReferenciaCcAgregar(TiposReferenciaCc tiposReferenciaCcAgregar) {
        this.tiposReferenciaCcAgregar = tiposReferenciaCcAgregar;
    }

    public List<SelectItem> getTiposProduccionSelectList() {
        return tiposProduccionSelectList;
    }

    public void setTiposProduccionSelectList(List<SelectItem> tiposProduccionSelectList) {
        this.tiposProduccionSelectList = tiposProduccionSelectList;
    }

    public ComponentesProd getComponentesProdFormaClonar() {
        return componentesProdFormaClonar;
    }

    public void setComponentesProdFormaClonar(ComponentesProd componentesProdFormaClonar) {
        this.componentesProdFormaClonar = componentesProdFormaClonar;
    }

    public List<SelectItem> getComponentesProdSelectList() {
        return componentesProdSelectList;
    }

    public void setComponentesProdSelectList(List<SelectItem> componentesProdSelectList) {
        this.componentesProdSelectList = componentesProdSelectList;
    }

    public List<SelectItem> getFormasFarmaceuticasSelectList() {
        return formasFarmaceuticasSelectList;
    }

    public void setFormasFarmaceuticasSelectList(List<SelectItem> formasFarmaceuticasSelectList) {
        this.formasFarmaceuticasSelectList = formasFarmaceuticasSelectList;
    }

    public ComponentesProd getComponentesProdClonarDestino() {
        return componentesProdClonarDestino;
    }

    public void setComponentesProdClonarDestino(ComponentesProd componentesProdClonarDestino) {
        this.componentesProdClonarDestino = componentesProdClonarDestino;
    }

    public List<EspecificacionesFisicasProducto> getListaEspecificacionesFisicasProductoClonar() {
        return listaEspecificacionesFisicasProductoClonar;
    }

    public void setListaEspecificacionesFisicasProductoClonar(List<EspecificacionesFisicasProducto> listaEspecificacionesFisicasProductoClonar) {
        this.listaEspecificacionesFisicasProductoClonar = listaEspecificacionesFisicasProductoClonar;
    }

    public List<EspecificacionesMicrobiologiaProducto> getListaEspecificacionesMicrobiologiaProductoClonar() {
        return listaEspecificacionesMicrobiologiaProductoClonar;
    }

    public void setListaEspecificacionesMicrobiologiaProductoClonar(List<EspecificacionesMicrobiologiaProducto> listaEspecificacionesMicrobiologiaProductoClonar) {
        this.listaEspecificacionesMicrobiologiaProductoClonar = listaEspecificacionesMicrobiologiaProductoClonar;
    }

    public List<EspecificacionesQuimicasCc> getListaEspecificacionesQuimicasProductoClonar() {
        return listaEspecificacionesQuimicasProductoClonar;
    }

    public void setListaEspecificacionesQuimicasProductoClonar(List<EspecificacionesQuimicasCc> listaEspecificacionesQuimicasProductoClonar) {
        this.listaEspecificacionesQuimicasProductoClonar = listaEspecificacionesQuimicasProductoClonar;
    }

    public List<VersionEspecificacionesProducto> getVersionEspecificacionesProductoList() {
        return versionEspecificacionesProductoList;
    }

    public void setVersionEspecificacionesProductoList(List<VersionEspecificacionesProducto> versionEspecificacionesProductoList) {
        this.versionEspecificacionesProductoList = versionEspecificacionesProductoList;
    }

    public VersionEspecificacionesProducto getVersionEspecificacionesProductoFisico() {
        return versionEspecificacionesProductoFisico;
    }

    public void setVersionEspecificacionesProductoFisico(VersionEspecificacionesProducto versionEspecificacionesProductoFisico) {
        this.versionEspecificacionesProductoFisico = versionEspecificacionesProductoFisico;
    }

    public VersionEspecificacionesProducto getVersionEspecificacionesProductoMicrobiologico() {
        return versionEspecificacionesProductoMicrobiologico;
    }

    public void setVersionEspecificacionesProductoMicrobiologico(VersionEspecificacionesProducto versionEspecificacionesProductoMicrobiologico) {
        this.versionEspecificacionesProductoMicrobiologico = versionEspecificacionesProductoMicrobiologico;
    }

    public VersionEspecificacionesProducto getVersionEspecificacionRegistrar() {
        return versionEspecificacionRegistrar;
    }

    public void setVersionEspecificacionRegistrar(VersionEspecificacionesProducto versionEspecificacionRegistrar) {
        this.versionEspecificacionRegistrar = versionEspecificacionRegistrar;
    }

    public VersionEspecificacionesProducto getVersionEspecificacionesProductoQuimica() {
        return versionEspecificacionesProductoQuimica;
    }

    public void setVersionEspecificacionesProductoQuimica(VersionEspecificacionesProducto versionEspecificacionesProductoQuimica) {
        this.versionEspecificacionesProductoQuimica = versionEspecificacionesProductoQuimica;
    }

    public VersionEspecificacionesProducto getVersionConcentracionProducto() {
        return versionConcentracionProducto;
    }

    public void setVersionConcentracionProducto(VersionEspecificacionesProducto versionConcentracionProducto) {
        this.versionConcentracionProducto = versionConcentracionProducto;
    }

    public String getAutorizacion() {
        return autorizacion;
    }

    public void setAutorizacion(String autorizacion) {
        this.autorizacion = autorizacion;
    }

    public int getCodigoAleatorio() {
        return codigoAleatorio;
    }

    public void setCodigoAleatorio(int codigoAleatorio) {
        this.codigoAleatorio = codigoAleatorio;
    }

    public List<SelectItem> getTiposEspecificacionesFisicasSelect() {
        return tiposEspecificacionesFisicasSelect;
    }

    public void setTiposEspecificacionesFisicasSelect(List<SelectItem> tiposEspecificacionesFisicasSelect) {
        this.tiposEspecificacionesFisicasSelect = tiposEspecificacionesFisicasSelect;
    }

    
    
}
