/*
 * ManagedTipoCliente.java
 * Created on 19 de febrero de 2008, 16:50
 */

package com.cofar.web;



import com.cofar.bean.ComponentesProd;



import com.cofar.bean.EspecificacionesQuimicasCc;

import com.cofar.bean.EspecificacionesQuimicasProducto;
import com.cofar.bean.IngresosDetalleAcond;
import com.cofar.bean.IngresosdetalleCantidadPeso;
import com.cofar.bean.ProgramaProduccion;
import com.cofar.bean.ProgramaProduccionPeriodo;
import com.cofar.bean.ResultadoAnalisisEspecificaciones;
import com.cofar.bean.ResultadoAnalisis;
import com.cofar.bean.ResultadosAnalisisEspecificacionesQuimicas;
import com.cofar.bean.util.correos.EnvioCorreoAprobacionCertificadoControlCalidad;

import com.cofar.util.Aleatorios;
import com.cofar.util.Util;
import java.sql.CallableStatement;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DecimalFormat;

import java.util.ArrayList;
import java.util.Date;

import java.util.List;
import java.util.Locale;

import javax.faces.model.SelectItem;
import java.text.NumberFormat;

import java.text.SimpleDateFormat;
import javax.faces.context.ExternalContext;
import javax.faces.context.FacesContext;

import javax.faces.model.ListDataModel;
import org.richfaces.component.html.HtmlDataTable;

/**
 *
 *  @author Wilmer Manzaneda Chavez
 *  @company COFAR
 */
public class ManagedResultadoAnalisis extends ManagedBean{
   /** Creates a new instance of ManagedTipoCliente */
    private ProgramaProduccion programaProduccionbean=new ProgramaProduccion();
    private List<ProgramaProduccion> programaProduccionList=new ArrayList<ProgramaProduccion>();
    private String codProgramaProd="0";
    private String mensaje="";
    String codTipoProgramaProd = "";
    private ProgramaProduccion currentProgramaProduccion=new ProgramaProduccion();
    private ResultadoAnalisis resultadoAnalisis= new ResultadoAnalisis();
    private List<ResultadoAnalisisEspecificaciones> listaAnalisisFisicos= new ArrayList<ResultadoAnalisisEspecificaciones>();
    private List<EspecificacionesQuimicasCc> listaAnalisisQuimicos= new ArrayList<EspecificacionesQuimicasCc>();
    private List<ResultadoAnalisisEspecificaciones> listaAnalisisMicrobiologia= new ArrayList<ResultadoAnalisisEspecificaciones>();
    private String nroAnalisis="";
    private String codAnalisis="";
    private List<SelectItem> listaAnalistas= new ArrayList<SelectItem>();
    private List<SelectItem> listaTiposResultadoDescriptivo= new ArrayList<SelectItem>();
    private String codAnalista="";
    private HtmlDataTable progProdResultadoAnalisDataTable = new HtmlDataTable();
    private List programaProduccionPeriodoList = new ArrayList();
    private String loteBuscar="";
    private String mensajeDenegado="";
    private ListDataModel lista=new ListDataModel();
    private List<ResultadoAnalisis> resultadosAnalisisList=new ArrayList<ResultadoAnalisis>();
    private ResultadoAnalisis resultadoAnalisisBean=new ResultadoAnalisis();
    private ResultadoAnalisis resultadoAnalisisBuscar=new ResultadoAnalisis();
    private List<SelectItem> analistasList=new ArrayList<SelectItem>();
    private List<SelectItem> estadosResultadosList=new ArrayList<SelectItem>();
    private List<SelectItem> listaTiposResultadoDescriptivoAlternativo=new ArrayList<SelectItem>();
    private HtmlDataTable programaProduccionPeriodoDataTable=new HtmlDataTable();
    private int codigoAleatorio=0;
    private String autorizacion="";
    private Date fechaInicioRevision=null;
    private Date fechaFinalRevision=null;
    private Date fechaInicioEmision=null;
    private Date fechaFinalEmision=null;
    private List<SelectItem> programaProdPeriodoSelectList=new ArrayList<SelectItem>();
    private String[] codProgramaProdPerSeleccionado=null;
    private List<SelectItem> componentesProdSelectList=new ArrayList<SelectItem>();
    private String codCompProdBuscar="";
    private String fechaVencimientoLoteRegistro="";
    public ManagedResultadoAnalisis() {



    }
    private void cargarDatosBuscador()
    {
        //resultadoAnalisisBuscar=new ResultadoAnalisis();
        try
        {
            Connection con=null;
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select (p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRE_PILA) as nombreAnalista,p.COD_PERSONAL"+
                            " from PERSONAL p inner join FIRMAS_CERTIFICADO_CC fcc on "+
                            " p.COD_PERSONAL=fcc.COD_PERSONAL"+
                            " order by p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRE_PILA";
            ResultSet res=st.executeQuery(consulta);
            analistasList.clear();
            analistasList.add(new SelectItem("0","-TODOS-"));
            while(res.next())
            {
                analistasList.add(new SelectItem(res.getString("COD_PERSONAL"),res.getString("nombreAnalista")));
            }
            consulta="select era.COD_ESTADO_RESULTADO_ANALISIS,era.NOMBRE_ESTADO_RESULTADO_ANALISIS"+
                     " from ESTADOS_RESULTADO_ANALISIS era order by era.NOMBRE_ESTADO_RESULTADO_ANALISIS";
            res=st.executeQuery(consulta);
            estadosResultadosList.clear();
            estadosResultadosList.add(new SelectItem(0,"-TODOS-"));
            while(res.next())
            {
                estadosResultadosList.add(new SelectItem(res.getInt("COD_ESTADO_RESULTADO_ANALISIS"),res.getString("NOMBRE_ESTADO_RESULTADO_ANALISIS")));
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

    public double redondear( double numero, int decimales ) {
        return Math.round(numero*Math.pow(10,decimales))/Math.pow(10,decimales);
    }
    public String buscarResultadoAnalisis_action()
    {
        begin=0;
        end=20;
        this.cargarResultadosAnalisis();
        return null;
    }
    public String getCargarResultadoAnalisis()
    {
        begin=0;
        end=20;
        this.cargarDatosBuscador();
        this.cargarResultadosAnalisis();
        return null;
    }
    public String aprobarResultadoAnalisis_action()throws SQLException 
    {
        mensaje="";
        Connection con1=null;
        try
        {
            con1=Util.openConnection(con1);
            con1.setAutoCommit(false);
            SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
            StringBuilder consulta=new StringBuilder("update RESULTADO_ANALISIS");
                                    consulta.append(" set COD_ESTADO_RESULTADO_ANALISIS=1,");
                                        consulta.append(" FECHA_REVISION='").append(sdf.format(resultadoAnalisisBean.getFechaRevision())).append("',");
                                        consulta.append(" FECHA_EMISION='").append(sdf.format(resultadoAnalisisBean.getFechaEmision())).append("',");
                                        consulta.append(" COD_PERSONAL_APRUEBA_CCC=(select pjp.COD_PERSONAL from PERSONAL_JEFE_AREA_PRODUCCION pjp where pjp.COD_AREA_EMPRESA=40 and pjp.COD_ESTADO_REGISTRO=1)");//jefe de area de produccion segun unimed
                                    consulta.append(" where COD_LOTE='").append(resultadoAnalisisBean.getCodLote()).append("'");
                                        consulta.append(" and COD_COMPROD='").append(resultadoAnalisisBean.getComponenteProd().getCodCompprod()).append("'");
            System.out.println("consulta aprobar resultado Analisis "+consulta.toString());
            PreparedStatement pst=con1.prepareStatement(consulta.toString());
            if(pst.executeUpdate()>0)System.out.println("se aprobo el analisis");
            con1.commit();
            mensaje="1";
            pst.close();
            con1.close();
        }
        catch(SQLException ex)
        {
            con1.rollback();
            ex.printStackTrace();
            mensaje="Ocurrio un error al momento de aprobar el resultado, intente de nuevo";
        }
        if(mensaje.equals("1"))
        {
            /*EnvioCorreoAprobacionCertificadoControlCalidad correo=new EnvioCorreoAprobacionCertificadoControlCalidad(resultadoAnalisisBean);
            correo.start();*/
        }
        return null;
    }
    public String rechazarResultadoAnalisis_action()throws SQLException
    {
        Connection con1=null;
        mensaje="";
        try
        {
            con1=Util.openConnection(con1);
            con1.setAutoCommit(false);
            SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
            StringBuilder consulta=new StringBuilder("update RESULTADO_ANALISIS");
                                    consulta.append(" set COD_ESTADO_RESULTADO_ANALISIS=2,");
                                        consulta.append(" FECHA_REVISION='").append(sdf.format(resultadoAnalisisBean.getFechaRevision())).append("',");
                                        consulta.append("FECHA_EMISION='").append(sdf.format(resultadoAnalisisBean.getFechaEmision())).append("',");
                                        consulta.append(" COD_PERSONAL_APRUEBA_CCC=(select pjp.COD_PERSONAL from PERSONAL_JEFE_AREA_PRODUCCION pjp where pjp.COD_AREA_EMPRESA=40 and pjp.COD_ESTADO_REGISTRO=1)");//jefe de area de produccion segun unimed
                                    consulta.append(" where COD_LOTE='").append(resultadoAnalisisBean.getCodLote()).append("'");
                                        consulta.append(" and COD_COMPROD='").append(resultadoAnalisisBean.getComponenteProd().getCodCompprod()).append("'");
            System.out.println("consulta rechazar resultado analisis "+consulta.toString());
            PreparedStatement pst=con1.prepareStatement(consulta.toString());
            if(pst.executeUpdate()>0)System.out.println("se aprobo el analisis");
            con1.commit();
            mensaje="1";
            pst.close();
            con1.close();
        }
        catch(SQLException ex)
        {
            mensaje="Ocurrio un error al momento de rechazar el analisis,intente de nuevo ";
            con1.rollback();
            ex.printStackTrace();
        }
        return null;
    }
    public String siguientePagina_action()
    {
        begin+=20;
        end+=20;
        this.cargarResultadosAnalisis();
        return null;
    }
    public String anteriorPagina_action()
    {
        begin-=20;
        end-=20;
        this.cargarResultadosAnalisis();
        return null;
    }
    private void cargarResultadosAnalisis()
    {
        try
        {
            Connection con1=null;
            con1=Util.openConnection(con1);
            
            SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");
            String consulta="select * from (select ROW_NUMBER() OVER (ORDER BY ra.NRO_ANALISIS) as 'FILAS'," +
                            " pr.nombre_prod,ra.TOMO,ra.PAGINA,ra.COD_ANALISIS,ra.COD_LOTE,ra.NRO_ANALISIS_MICROBIOLOGICO,ra.NRO_ANALISIS,cp.nombre_prod_semiterminado,era.COD_ESTADO_RESULTADO_ANALISIS,cp.COD_COMPPROD,"+
                            " era.NOMBRE_ESTADO_RESULTADO_ANALISIS,(p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRE_PILA) as nombrePersonal,p.COD_PERSONAL" +
                            ",ra.FECHA_EMISION,ra.FECHA_REVISION,versionProducto.COD_PROD,versionProducto.COD_FORMA" +
                            " ,isnull(vep.COD_VERSION_ESPECIFICACION_PRODUCTO,0) as codversionFisica,isnull(vep.NRO_VERSION_ESPECIFICACION_PRODUCTO,0) as nroVersionfisica"+
                            " ,isnull(vep1.COD_VERSION_ESPECIFICACION_PRODUCTO,0) as codversionQuimica,isnull(vep1.NRO_VERSION_ESPECIFICACION_PRODUCTO,0) as nroVersionQuimica"+
                            " ,isnull(vep2.COD_VERSION_ESPECIFICACION_PRODUCTO,0) as codversionMicro,isnull(vep2.NRO_VERSION_ESPECIFICACION_PRODUCTO,0) as nroVersionmicro"+
                            " ,isnull(vep3.COD_VERSION_ESPECIFICACION_PRODUCTO,0) as codversionConcentracion,isnull(vep3.NRO_VERSION_ESPECIFICACION_PRODUCTO,0) as nroVersionConcentracion" +
                            " ,versionProducto.COD_COMPPROD_VERSION,cp.NOMBRE_COMERCIAL"+
                            " from RESULTADO_ANALISIS ra inner join COMPONENTES_PROD cp"+
                            " on cp.COD_COMPPROD=ra.COD_COMPROD inner join ESTADOS_RESULTADO_ANALISIS era on "+
                            " era.COD_ESTADO_RESULTADO_ANALISIS=ra.COD_ESTADO_RESULTADO_ANALISIS"+
                            " inner join PERSONAL p on p.COD_PERSONAL=ra.COD_PERSONAL_ANALISTA " +
                            " left outer join PRODUCTOS pr on pr.cod_prod=cp.COD_PROD " +
                            " left outer join VERSION_ESPECIFICACIONES_PRODUCTO vep on vep.COD_VERSION_ESPECIFICACION_PRODUCTO=ra.COD_VERSION_ESPECIFICACION_FISICA"+
                            " left outer join VERSION_ESPECIFICACIONES_PRODUCTO vep1 on vep1.COD_VERSION_ESPECIFICACION_PRODUCTO=ra.COD_VERSION_ESPECIFICACION_QUIMICA"+
                            " left outer join VERSION_ESPECIFICACIONES_PRODUCTO vep2 on vep2.COD_VERSION_ESPECIFICACION_PRODUCTO=ra.COD_VERSION_ESPECIFICACION_MICRO"+
                            " left outer join VERSION_ESPECIFICACIONES_PRODUCTO vep3 on vep3.COD_VERSION_ESPECIFICACION_PRODUCTO=ra.COD_VERSION_CONCENTRACION" +
                            " outer apply(select top 1 pp.COD_COMPPROD_VERSION,cpv.COD_FORMA,cpv.COD_PROD from PROGRAMA_PRODUCCION pp inner join COMPONENTES_PROD_VERSION cpv on cpv.COD_COMPPROD=pp.COD_COMPPROD and cpv.COD_VERSION=pp.COD_COMPPROD_VERSION where pp.COD_LOTE_PRODUCCION=ra.COD_LOTE and pp.COD_COMPPROD=ra.COD_COMPROD"+
                            " )as versionProducto" +
                            " where 1=1 " +
                            (resultadoAnalisisBuscar.getComponenteProd().getProducto().getNombreProducto().equals("")?"":" and pr.nombre_prod like '%"+resultadoAnalisisBuscar.getComponenteProd().getProducto().getNombreProducto()+"%'")+
                            (resultadoAnalisisBuscar.getNroAnalisisMicrobiologico().equals("")?"":" and ra.NRO_ANALISIS_MICROBIOLOGICO  like '%"+resultadoAnalisisBuscar.getNroAnalisisMicrobiologico()+"%'")+
                            (resultadoAnalisisBuscar.getTomo().equals("")?"":" and ra.TOMO='"+resultadoAnalisisBuscar.getTomo()+"'")+
                            (resultadoAnalisisBuscar.getPagina().equals("")?"":" and ra.PAGINA='"+resultadoAnalisisBuscar.getPagina()+"'")+
                            (resultadoAnalisisBuscar.getNroAnalisis().equals("")?"":" and ra.NRO_ANALISIS  like '%"+resultadoAnalisisBuscar.getNroAnalisis()+"%'")+
                            (resultadoAnalisisBuscar.getCodLote().equals("")?"": " and ra.COD_LOTE like '%"+resultadoAnalisisBuscar.getCodLote()+"%'")+
                            (resultadoAnalisisBuscar.getComponenteProd().getNombreProdSemiterminado().equals("")?"":" and cp.nombre_prod_semiterminado like '%"+resultadoAnalisisBuscar.getComponenteProd().getNombreProdSemiterminado()+"%'")+
                            (resultadoAnalisisBuscar.getEstadoResultadoAnalisis().getCodEstadoResultadoAnalisis()>0?" and ra.COD_ESTADO_RESULTADO_ANALISIS='"+resultadoAnalisisBuscar.getEstadoResultadoAnalisis().getCodEstadoResultadoAnalisis()+"'":"")+
                            (resultadoAnalisisBuscar.getPersonalAnalista().getCodPersonal().equals("0")||resultadoAnalisisBuscar.getPersonalAnalista().getCodPersonal().equals("")?"":" and  ra.COD_PERSONAL_ANALISTA='"+resultadoAnalisisBuscar.getPersonalAnalista().getCodPersonal()+"'")+
                            ((fechaInicioEmision!=null&&fechaFinalEmision!=null)?" and ra.FECHA_EMISION between '"+sdf.format(fechaInicioEmision)+" 00:00:00' and '"+sdf.format(fechaFinalEmision)+" 23:59:59'":"")+
                            ((fechaInicioRevision!=null&&fechaFinalRevision!=null)?" and ra.FECHA_REVISION between '"+sdf.format(fechaInicioRevision)+" 00:00:00' and '"+sdf.format(fechaFinalRevision)+" 23:59:59'":"")+
                            " ) AS listado where FILAS BETWEEN "+begin+" AND "+end;
            System.out.println("consulta cargar resultados "+consulta);
            Statement st=con1.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta);
            resultadosAnalisisList.clear();
            while(res.next())
            {
                ResultadoAnalisis nuevo=new ResultadoAnalisis();
                nuevo.getVersionConcentracionProducto().setCodVersionEspecificacionProducto(res.getInt("codversionConcentracion"));
                nuevo.getVersionConcentracionProducto().setNroVersionEspecificacionProducto(res.getInt("nroVersionConcentracion"));
                nuevo.getVersionEspecificacionFisica().setCodVersionEspecificacionProducto(res.getInt("codversionFisica"));
                nuevo.getVersionEspecificacionFisica().setNroVersionEspecificacionProducto(res.getInt("nroVersionfisica"));
                nuevo.getVersionEspecificacionMicrobiologica().setCodVersionEspecificacionProducto(res.getInt("codversionMicro"));
                nuevo.getVersionEspecificacionMicrobiologica().setNroVersionEspecificacionProducto(res.getInt("nroVersionmicro"));
                nuevo.getVersionEspecificacionQuimica().setCodVersionEspecificacionProducto(res.getInt("codversionQuimica"));
                nuevo.getVersionEspecificacionQuimica().setNroVersionEspecificacionProducto(res.getInt("nroVersionQuimica"));
                nuevo.getComponenteProd().getProducto().setNombreProducto(res.getString("nombre_prod"));
                nuevo.getComponenteProd().setNombreComercial(res.getString("NOMBRE_COMERCIAL"));
                nuevo.getComponenteProd().getProducto().setCodProducto(res.getString("COD_PROD"));
                nuevo.getComponenteProd().setCodVersion(res.getInt("COD_COMPPROD_VERSION"));
                nuevo.getComponenteProd().getForma().setCodForma(res.getString("COD_FORMA"));
                nuevo.setTomo(res.getString("TOMO"));
                nuevo.setPagina(res.getString("PAGINA"));
                nuevo.setCodLote(res.getString("COD_LOTE"));
                nuevo.getComponenteProd().setNombreProdSemiterminado(res.getString("nombre_prod_semiterminado"));
                nuevo.getComponenteProd().setCodCompprod(res.getString("COD_COMPPROD"));
                nuevo.setFechaEmision(res.getTimestamp("FECHA_EMISION"));
                nuevo.setFechaRevision(res.getTimestamp("FECHA_REVISION"));
                nuevo.getEstadoResultadoAnalisis().setCodEstadoResultadoAnalisis(res.getInt("COD_ESTADO_RESULTADO_ANALISIS"));
                nuevo.getEstadoResultadoAnalisis().setNombreEstadoResultadoAnalisis(res.getString("NOMBRE_ESTADO_RESULTADO_ANALISIS"));
                nuevo.setNroAnalisis(res.getString("NRO_ANALISIS"));
                nuevo.setNroAnalisisMicrobiologico(res.getString("NRO_ANALISIS_MICROBIOLOGICO"));
                nuevo.setCodAnalisis(res.getInt("COD_ANALISIS"));
                nuevo.getPersonalAnalista().setNombrePersonal(res.getString("nombrePersonal"));
                nuevo.getPersonalAnalista().setCodPersonal(res.getString("COD_PERSONAL"));
                nuevo.setColorFila(res.getString("COD_ESTADO_RESULTADO_ANALISIS"));
                resultadosAnalisisList.add(nuevo);
            }
            cantidadfilas=resultadosAnalisisList.size();
            res.close();
            st.close();
            con1.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
    }
    public String revisarResultadoAnalisis_action()
    {
        mensaje="";
        for(ResultadoAnalisis current:resultadosAnalisisList)
        {
            if(current.getChecked())
            {
                resultadoAnalisisBean=current;
                if(resultadoAnalisisBean.getVersionConcentracionProducto().getCodVersionEspecificacionProducto()>0||
                   resultadoAnalisisBean.getVersionEspecificacionFisica().getCodVersionEspecificacionProducto()>0||
                   resultadoAnalisisBean.getVersionEspecificacionMicrobiologica().getCodVersionEspecificacionProducto()>0||
                   resultadoAnalisisBean.getVersionEspecificacionQuimica().getCodVersionEspecificacionProducto()>0)
                {
                    mensaje="No se pueden revisar certificados generados con el anterior versionamiento";
                }
                else
                {
                    mensaje="1";
                }
                if(resultadoAnalisisBean.getFechaEmision()==null)
                {
                    resultadoAnalisisBean.setFechaEmision(new Date());
                }
                if(resultadoAnalisisBean.getFechaRevision()==null)
                {
                    resultadoAnalisisBean.setFechaRevision(new Date());
                }
            }
        }
        return null;
    }
    public String  getCogerCodProgProdPeriodo(){
        try {

            ManagedAccesoSistema accesoSistema = (ManagedAccesoSistema) Util.getSessionBean("ManagedAccesoSistema");

            String consulta = " SELECT UAPR.COD_AREA_EMPRESA FROM USUARIOS_AREA_PRODUCCION UAPR WHERE UAPR.COD_PERSONAL = "+accesoSistema.getUsuarioModuloBean().getCodUsuarioGlobal()+" and uapr.cod_tipo_permiso = 1 ";
            System.out.println("consulta " + consulta);
            Connection con =null;
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(consulta);
            String codAreaEmpresa ="''";
            while(rs.next()) {
                codAreaEmpresa= codAreaEmpresa + ","+rs.getString("COD_AREA_EMPRESA");
            }

            String sql="select pp.cod_programa_prod,fm.cod_formula_maestra,pp.cod_lote_produccion,";

            sql+=" pp.fecha_inicio,pp.fecha_final,pp.cod_estado_programa,pp.observacion,";
            sql+=" cp.nombre_prod_semiterminado,cp.cod_compprod,fm.cantidad_lote,epp.NOMBRE_ESTADO_PROGRAMA_PROD,pp.cant_lote_produccion,tp.COD_TIPO_PROGRAMA_PROD,tp.NOMBRE_TIPO_PROGRAMA_PROD";
            sql+=" ,ISNULL((SELECT C.NOMBRE_CATEGORIACOMPPROD FROM CATEGORIAS_COMPPROD C WHERE C.COD_CATEGORIACOMPPROD=cp.COD_CATEGORIACOMPPROD),''),pp.MATERIAL_TRANSITO " +
                 " ,(SELECT ISNULL(ae.NOMBRE_AREA_EMPRESA,'') FROM AREAS_EMPRESA ae WHERE ae.COD_AREA_EMPRESA =cp.COD_AREA_EMPRESA) NOMBRE_AREA_EMPRESA,cp.VIDA_UTIL,cp.COD_AREA_EMPRESA " +
                 " , (select top 1 ap.NOMBRE_ACTIVIDAD from SEGUIMIENTO_PROGRAMA_PRODUCCION s inner join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_ACTIVIDAD_FORMULA = s.COD_ACTIVIDAD_PROGRAMA " +
                 "  inner join ACTIVIDADES_PRODUCCION ap on ap.COD_ACTIVIDAD = afm.COD_ACTIVIDAD       " +
                 " where s.COD_PROGRAMA_PROD = pp.COD_PROGRAMA_PROD" +
                 "   and s.COD_COMPPROD = pp.COD_COMPPROD and s.COD_FORMULA_MAESTRA = pp.COD_FORMULA_MAESTRA and s.COD_LOTE_PRODUCCION = pp.COD_LOTE_PRODUCCION " +
                 "   and (s.HORAS_HOMBRE >0 or s.HORAS_MAQUINA >0) and s.COD_TIPO_PROGRAMA_PROD in( pp.COD_TIPO_PROGRAMA_PROD , 0) and ap.COD_TIPO_ACTIVIDAD_PRODUCCION = 1 " +
                 "   order by afm.COD_ACTIVIDAD_FORMULA  desc ) NOMBRE_ACTIVIDAD "+
                 " ,ISNULL((select ff.nombre_forma from FORMAS_FARMACEUTICAS ff where ff.cod_forma=cp.COD_FORMA),'') as formaFar" +
                 " ,p.nombre_prod,ppp.NOMBRE_PROGRAMA_PROD,cp.COD_FORMA,pp.COD_COMPPROD_VERSION" +
                 " ,cp.NOMBRE_COMERCIAL"+
                 " from programa_produccion pp inner join formula_maestra fm on "+
                 " pp.cod_formula_maestra = fm.cod_formula_maestra"+
                 " inner join componentes_prod cp on cp.cod_compprod = fm.cod_compprod"+
                 " inner join ESTADOS_PROGRAMA_PRODUCCION epp on epp.COD_ESTADO_PROGRAMA_PROD = pp.cod_estado_programa"+
                 " inner join TIPOS_PROGRAMA_PRODUCCION tp on tp.COD_TIPO_PROGRAMA_PROD = pp.COD_TIPO_PROGRAMA_PROD"+
                 " left outer join PRODUCTOS p on cp.COD_PROD = p.cod_prod"+
                 " inner join PROGRAMA_PRODUCCION_PERIODO ppp on ppp.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD and isnull(ppp.COD_TIPO_PRODUCCION,1)=1"+
                 " where pp.cod_estado_programa in (2, 5, 6, 7) ";
                 if(programaProduccionbean.getCodProgramaProduccion().equals("0"))
                 {
                     if(programaProduccionbean.getCodLoteProduccion().equals(""))
                     {
                         String codProgramaProdPer="";
                         for(String codProgPer:codProgramaProdPerSeleccionado)
                         {
                             codProgramaProdPer+=(codProgramaProdPer.equals("")?"":",")+codProgPer;
                         }
                         sql+=" and pp.COD_PROGRAMA_PROD in ("+codProgramaProdPer+") and pp.COD_COMPPROD='"+codCompProdBuscar+"'";
                     }
                     else
                     {
                         sql+=" and pp.cod_lote_produccion='"+programaProduccionbean.getCodLoteProduccion()+"'";
                     }
                 }
                 else
                 {
                    sql+=" and pp.cod_programa_prod="+programaProduccionbean.getCodProgramaProduccion();
                 }
                 sql+=" and cp.cod_area_empresa in ("+ codAreaEmpresa +") order by ppp.COD_PROGRAMA_PROD, cp.nombre_prod_semiterminado ";
            System.out.println("consulta periodo:"+sql);
            rs=st.executeQuery(sql);
            rs.last();
            int rows=rs.getRow();
            programaProduccionList.clear();
            rs.first();
            String cod="";
            for(int i=0;i<rows;i++){
                ProgramaProduccion bean=new ProgramaProduccion();
                bean.getProgramaProduccionPeriodo().setNombreProgramaProduccion(rs.getString("NOMBRE_PROGRAMA_PROD"));
                bean.getFormulaMaestra().getComponentesProd().getProducto().setNombreProducto(rs.getString("nombre_prod"));
                bean.setCodProgramaProduccion(rs.getString(1));
                bean.getFormulaMaestra().getComponentesProd().setNombreComercial(rs.getString("NOMBRE_COMERCIAL"));
                bean.getFormulaMaestra().getComponentesProd().setCodVersion(rs.getInt("COD_COMPPROD_VERSION"));
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
                bean.getFormulaMaestra().getComponentesProd().getForma().setCodForma(rs.getString("COD_FORMA"));
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
            st.close();
            con.close();

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return"";
    }
    private void cargarComponetesProdSelect()
    {
        try
        {
            Connection con=null;
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select cp.COD_COMPPROD,cp.nombre_prod_semiterminado"+
                            " from COMPONENTES_PROD cp where cp.COD_TIPO_PRODUCCION=1 order by cp.nombre_prod_semiterminado";
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
   public String getCargarProgProdPeriodo(){
        loteBuscar="";
        this.cargarComponetesProdSelect();
        this.cargarProgramasProduccion();
        return null;
    }
   public String buscarLote_Action()
   {
       programaProduccionbean.setCodProgramaProduccion("0");
       programaProduccionbean.setCodLoteProduccion(loteBuscar);
       programaProduccionbean.getFormulaMaestra().getComponentesProd().setCodCompprod(codCompProdBuscar);
       System.out.println("buscar lote para registro de cc");
       return null;
   }
   private void cargarProgramasProduccion()
   {
        try {

            Connection con = null;
            con = Util.openConnection(con);
            Statement st = con.createStatement();
            String consulta = " SELECT PP.COD_PROGRAMA_PROD,PP.NOMBRE_PROGRAMA_PROD,PP.OBSERVACIONES,(SELECT EP.NOMBRE_ESTADO_PROGRAMA_PROD FROM ESTADOS_PROGRAMA_PRODUCCION EP" +
                              " WHERE EP.COD_ESTADO_PROGRAMA_PROD = PP.COD_ESTADO_PROGRAMA) NOMBRE_ESTADO_PROGRAMA_PROD FROM PROGRAMA_PRODUCCION_PERIODO PP WHERE PP.COD_ESTADO_PROGRAMA<>4" +
                              " and isnull(pp.COD_TIPO_PRODUCCION,1)=1 order by 1 desc";
            /*if(!loteBuscar.equals(""))
            {
                consulta+=" and PP.COD_PROGRAMA_PROD in (select pp1.COD_PROGRAMA_PROD from PROGRAMA_PRODUCCION pp1 where pp1.COD_LOTE_PRODUCCION like '%"+loteBuscar+"%')";
            }*/
            System.out.println("consulta cargar Periodos"+consulta);
            ResultSet rs = st.executeQuery(consulta);
            programaProduccionPeriodoList.clear();
            programaProdPeriodoSelectList.clear();
            while(rs.next()){
                ProgramaProduccionPeriodo programaProduccionPeriodo = new ProgramaProduccionPeriodo();
                programaProduccionPeriodo.setCodProgramaProduccion(rs.getString("COD_PROGRAMA_PROD"));
                programaProduccionPeriodo.setNombreProgramaProduccion(rs.getString("NOMBRE_PROGRAMA_PROD"));
                programaProduccionPeriodo.getEstadoProgramaProduccion().setNombreEstadoProgramaProd(rs.getString("NOMBRE_ESTADO_PROGRAMA_PROD"));
                programaProduccionPeriodo.setObsProgramaProduccion(rs.getString("OBSERVACIONES"));
                programaProduccionPeriodoList.add(programaProduccionPeriodo);
                programaProdPeriodoSelectList.add(new SelectItem(rs.getString("COD_PROGRAMA_PROD"),rs.getString("NOMBRE_PROGRAMA_PROD")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
   }

    private List<ResultadosAnalisisEspecificacionesQuimicas> listaResultadosEspecificaionesQuimicas(String codLote,String codEspecificacion,String codComprod,
            String codTipoResultado)
    {
           List<ResultadosAnalisisEspecificacionesQuimicas> lista= new ArrayList<ResultadosAnalisisEspecificacionesQuimicas>();
           try
           {
               Connection con1= null;
               con1=Util.openConnection(con1);
               Statement st1=con1.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

               String consulta=" select case  when eqp.COD_MATERIAL>0 then m.NOMBRE_CCC else mcc.NOMBRE_MATERIAL_COMPUESTO_CC"+
                               " end as NOMBRE_CCC ,eqp.COD_MATERIAL_COMPUESTO_CC,eqp.COD_MATERIAL,eqp.DESCRIPCION,eqp.LIMITE_INFERIOR,eqp.LIMITE_SUPERIOR,eqp.VALOR_EXACTO,"+
                               " eqp.COD_REFERENCIA_CC,tr.NOMBRE_REFERENCIACC,ISNULL(raeq.RESULTADO_NUMERICO,0) as resultadoNumerico,"+
                               " ISNULL(raeq.COD_TIPO_RESULTADO_DESCRIPTIVO,"+(codTipoResultado.equals("1")?"1":"0")+") as resultadoDescriptivo  from ESPECIFICACIONES_QUIMICAS_PRODUCTO eqp " +
                               " left outer join MATERIALES m on m.COD_MATERIAL=eqp.COD_MATERIAL " +
                               " left outer join MATERIALES_COMPUESTOS_CC mcc on mcc.COD_MATERIAL_COMPUESTO_CC=eqp.COD_MATERIAL_COMPUESTO_CC" +
                               " inner join TIPOS_REFERENCIACC tr on tr.COD_REFERENCIACC=eqp.COD_REFERENCIA_CC"+
                               " left outer join RESULTADO_ANALISIS_ESPECIFICACIONES_QUIMICAS raeq on "+
                               " raeq.COD_ESPECIFICACION=eqp.COD_ESPECIFICACION and raeq.COD_MATERIAL=eqp.COD_MATERIAL" +
                               " and raeq.COD_MATERIAL_COMPUESTO_CC=eqp.COD_MATERIAL_COMPUESTO_CC " +
                               " and raeq.COD_COMPPROD=eqp.COD_PRODUCTO" +
                               " and raeq.COD_LOTE='"+codLote+"'"+
                               " where eqp.COD_ESPECIFICACION='"+codEspecificacion+"' and eqp.COD_PRODUCTO='"+codComprod+"' and eqp.ESTADO=1" +
                               " and eqp.COD_MATERIAL<>-1 and eqp.COD_VERSION='"+resultadoAnalisis.getComponenteProd().getCodVersion()+"'" +
                               " order by m.NOMBRE_CCC";
               System.out.println("consulta detalle quimico "+consulta);
               ResultSet res1=st1.executeQuery(consulta);
               while(res1.next())
               {
                   ResultadosAnalisisEspecificacionesQuimicas bean= new ResultadosAnalisisEspecificacionesQuimicas();
                   bean.getEspecificacionesQuimicasProducto().getMaterial().setNombreMaterial(res1.getString("NOMBRE_CCC"));
                   bean.getEspecificacionesQuimicasProducto().getMaterial().setCodMaterial(res1.getString("COD_MATERIAL"));
                   bean.getEspecificacionesQuimicasProducto().getMaterialesCompuestosCc().setCodMaterialCompuestoCc(res1.getInt("COD_MATERIAL_COMPUESTO_CC"));
                   bean.getEspecificacionesQuimicasProducto().getTiposReferenciaCc().setNombreReferenciaCc(res1.getString("NOMBRE_REFERENCIACC"));
                   bean.getEspecificacionesQuimicasProducto().setLimiteInferior(res1.getDouble("LIMITE_INFERIOR"));
                   bean.getEspecificacionesQuimicasProducto().setLimiteSuperior(res1.getDouble("LIMITE_SUPERIOR"));
                   bean.getEspecificacionesQuimicasProducto().setDescripcion(res1.getString("DESCRIPCION"));
                   bean.getEspecificacionesQuimicasProducto().setValorExacto(res1.getDouble("VALOR_EXACTO"));
                   bean.getEspecificacionesQuimicasProducto().getTiposReferenciaCc().setCodReferenciaCc(res1.getInt("COD_REFERENCIA_CC"));
                   bean.getEspecificacionesQuimicasProducto().getTiposReferenciaCc().setNombreReferenciaCc(res1.getString("NOMBRE_REFERENCIACC"));
                   bean.setResultadoNumerico(res1.getDouble("resultadoNumerico"));
                   bean.getTipoResultadoDescriptivo().setCodTipoResultadoDescriptivo(res1.getString("resultadoDescriptivo"));
                   bean.getResultadoDescriptivoAlternativo().setCodTipoResultadoDescriptivo(codTipoResultado.equals("1")?"0":res1.getString("resultadoDescriptivo"));
                   lista.add(bean);
               }
               res1.close();
               st1.close();
               con1.close();

           }
           catch(SQLException ex)
           {
               ex.printStackTrace();
           }
           return lista;
    }
    private String verificarResultadoAprobar(String codTipoResultadoAnalisis,String codTipoResultadoDescriptivo,double resultadoNumerico,double limiteSuperior,double limiteInferior,double valorExacto)
    {
        String resultado="";
        if(codTipoResultadoAnalisis.equals("1"))
        {
            if(codTipoResultadoDescriptivo.equals("2"))
            {
                resultado="No esta conforme con la especificación";
            }
        }
        if(codTipoResultadoAnalisis.equals("2"))
        {
            if((resultadoNumerico>limiteSuperior)||(resultadoNumerico<limiteInferior))
            {
                resultado=resultadoNumerico+" esta fuera de los rangos de la especificación";
            }
        }
        if(codTipoResultadoAnalisis.equals("3"))
        {
            if(resultadoNumerico!=valorExacto)
            {
                resultado=resultadoNumerico+" no es igual al valor de la especificación";
            }
        }
        if(codTipoResultadoAnalisis.equals("4"))
        {
            if(resultadoNumerico<=valorExacto)
            {
                resultado=resultadoNumerico+ " es menor o igual que el valor de la especificación";
            }
        }
        if(codTipoResultadoAnalisis.equals("5"))
        {
            if(resultadoNumerico>=valorExacto)
            {
                resultado=resultadoNumerico+" es mayor o igual que el valor de la especificación";
            }
        }
        if(codTipoResultadoAnalisis.equals("6"))
        {
            if(resultadoNumerico<valorExacto)
            {
                resultado=resultadoNumerico+" es menor que el valor de la espeficicación";
            }
        }
        if(codTipoResultadoAnalisis.equals("7"))
        {
            if(resultadoNumerico>valorExacto)
            {
               resultado=resultadoNumerico+" es mayor que el valor de la especificación";
            }
        }
        if(codTipoResultadoAnalisis.equals("8"))
        {
            if((resultadoNumerico<(-valorExacto))||(resultadoNumerico>valorExacto))
            {
                resultado=resultadoNumerico+" no esta dentro del intervalo establecido establecido en la especificación";
            }
        }
        if(codTipoResultadoAnalisis.equals("9"))
        {
            if(resultadoNumerico>valorExacto)
            {
                resultado=resultadoNumerico+" es mayor que el valor establecido establecido en la especificación";
            }
        }
        if(codTipoResultadoAnalisis.equals("10"))
        {
            if(resultadoNumerico<valorExacto)
            {
                resultado=resultadoNumerico+" es menor que el valor establecido establecido en la especificación";
            }
        }
        return resultado;
    }


    public String verificarOperacion_Action()
    {
        List lista1=new ArrayList();
        mensaje="";
        for(ResultadoAnalisisEspecificaciones current: listaAnalisisFisicos)
        {
            current.setColorFila("");
            String resultado=verificarResultadoAprobar(current.getEspecificacionesFisicasProducto().getEspecificacionFisicaCC().getTipoResultadoAnalisis().getCodTipoResultadoAnalisis(),
                    current.getTipoResultadoDescriptivo().getCodTipoResultadoDescriptivo(),current.getResultadoNumerico(), current.getEspecificacionesFisicasProducto().getLimiteSuperior(),
                    current.getEspecificacionesFisicasProducto().getLimiteInferior(),current.getEspecificacionesFisicasProducto().getValorExacto());
          if(!resultado.equals(""))
          {
              current.setColorFila("fuera");
              mensaje="1";
              String[] datos=new String[3];
              datos[0]="Análisis Físico";
              datos[1]=  ((current.getEspecificacionesFisicasProducto().getEspecificacionFisicaCC().getTipoResultadoAnalisis().getCodTipoResultadoAnalisis().equals("1"))?current.getEspecificacionesFisicasProducto().getDescripcion():
                         ((current.getEspecificacionesFisicasProducto().getEspecificacionFisicaCC().getTipoResultadoAnalisis().getCodTipoResultadoAnalisis().equals("2"))?(current.getEspecificacionesFisicasProducto().getLimiteInferior()+"-"+ current.getEspecificacionesFisicasProducto().getLimiteSuperior()):
                           (current.getEspecificacionesFisicasProducto().getEspecificacionFisicaCC().getCoeficiente()+current.getEspecificacionesFisicasProducto().getEspecificacionFisicaCC().getTipoResultadoAnalisis().getSimbolo()+current.getEspecificacionesFisicasProducto().getValorExacto())));
              datos[2]=resultado;
              lista1.add(datos);
          }
        }
        for(EspecificacionesQuimicasCc current1:listaAnalisisQuimicos)
        {
            current1.setColorFila("");
            if(current1.getEspecificacionQuimicaGeneral().getEspecificacionesFisicasProducto().getEstado().getCodEstadoRegistro().equals("1"))
            {
                  String resultado=verificarResultadoAprobar(current1.getTipoResultadoAnalisis().getCodTipoResultadoAnalisis()
                                , current1.getEspecificacionQuimicaGeneral().getTipoResultadoDescriptivo().getCodTipoResultadoDescriptivo(),
                                current1.getEspecificacionQuimicaGeneral().getResultadoNumerico(),current1.getEspecificacionQuimicaGeneral().getEspecificacionesFisicasProducto().getLimiteSuperior(),
                                current1.getEspecificacionQuimicaGeneral().getEspecificacionesFisicasProducto().getLimiteInferior(),current1.getEspecificacionQuimicaGeneral().getEspecificacionesFisicasProducto().getValorExacto());
                  if(!resultado.equals(""))
                  {
                      current1.setColorFila("fuera");
                      mensaje="2";
                      String[] datos=new String[3];
                      datos[0]="Analisis Químico general";
                      datos[1]=(current1.getTipoResultadoAnalisis().getCodTipoResultadoAnalisis().equals("1")?current1.getEspecificacionQuimicaGeneral().getEspecificacionesFisicasProducto().getDescripcion():
                                (current1.getTipoResultadoAnalisis().getCodTipoResultadoAnalisis().equals("2")?(current1.getEspecificacionQuimicaGeneral().getEspecificacionesFisicasProducto().getLimiteInferior()+
                                            "-"+current1.getEspecificacionQuimicaGeneral().getEspecificacionesFisicasProducto().getLimiteSuperior()):(
                                            current1.getCoeficiente()+current1.getTipoResultadoAnalisis().getSimbolo()+current1.getEspecificacionQuimicaGeneral().getEspecificacionesFisicasProducto().getValorExacto())));

                      datos[2]=resultado;
                      lista1.add(datos);
                  }
            }
            else
            {
                for(ResultadosAnalisisEspecificacionesQuimicas current2:current1.getListaResultadoAnalisisEspecificacionesQuimicas())
                {
                    current2.setColorFila("");
                      String resultado=verificarResultadoAprobar(current1.getTipoResultadoAnalisis().getCodTipoResultadoAnalisis()
                                , current2.getTipoResultadoDescriptivo().getCodTipoResultadoDescriptivo(),
                                current2.getResultadoNumerico(), current2.getEspecificacionesQuimicasProducto().getLimiteSuperior(),
                                current2.getEspecificacionesQuimicasProducto().getLimiteInferior(),current2.getEspecificacionesQuimicasProducto().getValorExacto());
                        if(!resultado.equals(""))
                        {
                            current2.setColorFila("fuera");
                            mensaje="2";
                            String[] datos=new String[3];
                            datos[0]="Análisis Químico \n"+current2.getEspecificacionesQuimicasProducto().getMaterial().getNombreMaterial();
                            datos[1]=(current1.getTipoResultadoAnalisis().getCodTipoResultadoAnalisis().equals("1")?current2.getEspecificacionesQuimicasProducto().getDescripcion():(
                                      current1.getTipoResultadoAnalisis().getCodTipoResultadoAnalisis().equals("2")?(current2.getEspecificacionesQuimicasProducto().getLimiteInferior()+
                                      "-"+current2.getEspecificacionesQuimicasProducto().getLimiteSuperior()):(current1.getCoeficiente()+current1.getTipoResultadoAnalisis().getSimbolo()+
                                            current2.getEspecificacionesQuimicasProducto().getValorExacto())));
                            datos[2]=resultado;
                            lista1.add(datos);
                        }

                }
            }
        }
        for(ResultadoAnalisisEspecificaciones current3:listaAnalisisMicrobiologia)
        {
            current3.setColorFila("");
            String resultado=verificarResultadoAprobar(current3.getEspecificacionesMicrobiologiaProducto().getEspecificacionMicrobiologiaCc().getTipoResultadoAnalisis().getCodTipoResultadoAnalisis(),
                    current3.getTipoResultadoDescriptivo().getCodTipoResultadoDescriptivo(),
                    current3.getResultadoNumerico(),current3.getEspecificacionesMicrobiologiaProducto().getLimiteSuperior(),
                    current3.getEspecificacionesMicrobiologiaProducto().getLimiteInferior(),current3.getEspecificacionesMicrobiologiaProducto().getValorExacto());
            if(!resultado.equals(""))
            {
                current3.setColorFila("fuera");
                mensaje="3";
                String[] datos=new String[3];
                datos[0]="Análisis Microbiologico";
                datos[1]=(current3.getEspecificacionesMicrobiologiaProducto().getEspecificacionMicrobiologiaCc().getTipoResultadoAnalisis().getCodTipoResultadoAnalisis().equals("1")?
                         current3.getEspecificacionesMicrobiologiaProducto().getDescripcion():((current3.getEspecificacionesMicrobiologiaProducto().getEspecificacionMicrobiologiaCc().getTipoResultadoAnalisis().getCodTipoResultadoAnalisis().equals("2")?
                           (current3.getEspecificacionesMicrobiologiaProducto().getLimiteInferior()+"-"+current3.getEspecificacionesMicrobiologiaProducto().getLimiteSuperior()):
                           (current3.getEspecificacionesMicrobiologiaProducto().getEspecificacionMicrobiologiaCc().getCoeficiente()+current3.getEspecificacionesMicrobiologiaProducto().getEspecificacionMicrobiologiaCc().getTipoResultadoAnalisis().getSimbolo()+
                           current3.getEspecificacionesMicrobiologiaProducto().getValorExacto()))));
                datos[2]=resultado;
                lista1.add(datos);
            }
        }
        if(lista1.size()==0)
        {
            mensaje="0";
        }
        lista.setWrappedData(lista1);
        return null;

    }
    private ResultadoAnalisisEspecificaciones cargarResultadosEspecificacionQuimicaGeneral(String codLoteProduccion,String codEspecificacion,String codCompProd,String codTipoResultadoAnalisis)
    {
        ResultadoAnalisisEspecificaciones resultado=new ResultadoAnalisisEspecificaciones();
        resultado.getEspecificacionesFisicasProducto().getEstado().setCodEstadoRegistro("2");
        try
           {
               Connection con1= null;
               con1=Util.openConnection(con1);
               Statement st1=con1.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
               String consulta=" select eqp.DESCRIPCION,eqp.LIMITE_INFERIOR,eqp.LIMITE_SUPERIOR,eqp.VALOR_EXACTO,"+
                               "eqp.COD_REFERENCIA_CC,tr.NOMBRE_REFERENCIACC,ISNULL(raeq.RESULTADO_NUMERICO, 0) as resultadoNumerico,"+
                               "ISNULL(raeq.COD_TIPO_RESULTADO_DESCRIPTIVO, "+(codTipoResultadoAnalisis.equals("1")?"1":"0")+") as resultadoDescriptivo"+
                               " from ESPECIFICACIONES_QUIMICAS_PRODUCTO eqp"+
                               " inner join TIPOS_REFERENCIACC tr on tr.COD_REFERENCIACC ="+
                               " eqp.COD_REFERENCIA_CC"+
                               " left outer join RESULTADO_ANALISIS_ESPECIFICACIONES_QUIMICAS raeq on"+
                               " raeq.COD_ESPECIFICACION = eqp.COD_ESPECIFICACION and raeq.COD_MATERIAL ="+
                               " eqp.COD_MATERIAL and raeq.COD_LOTE = '"+codLoteProduccion+"'" +
                               " and eqp.COD_PRODUCTO=raeq.COD_COMPPROD"+
                               " where eqp.COD_ESPECIFICACION = '"+codEspecificacion+"' and"+
                               " eqp.COD_PRODUCTO = '"+codCompProd+"' and"+
                               " eqp.ESTADO = 1 and eqp.COD_MATERIAL=-1 and eqp.COD_VERSION='"+resultadoAnalisis.getComponenteProd().getCodVersion()+"'";
               System.out.println("consulta detalle quimico "+consulta);
               ResultSet res1=st1.executeQuery(consulta);
               while(res1.next())
               {
                   resultado.getEspecificacionesFisicasProducto().getEspecificacionFisicaCC().getTiposReferenciaCc().setNombreReferenciaCc(res1.getString("NOMBRE_REFERENCIACC"));
                   resultado.getEspecificacionesFisicasProducto().setLimiteInferior(res1.getDouble("LIMITE_INFERIOR"));
                   resultado.getEspecificacionesFisicasProducto() .setLimiteSuperior(res1.getDouble("LIMITE_SUPERIOR"));
                   resultado.getEspecificacionesFisicasProducto().setDescripcion(res1.getString("DESCRIPCION"));
                   resultado.getEspecificacionesFisicasProducto().setValorExacto(res1.getDouble("VALOR_EXACTO"));
                   resultado.getEspecificacionesFisicasProducto().getEspecificacionFisicaCC().getTiposReferenciaCc().setCodReferenciaCc(res1.getInt("COD_REFERENCIA_CC"));
                   resultado.getEspecificacionesFisicasProducto().getEspecificacionFisicaCC().getTiposReferenciaCc().setNombreReferenciaCc(res1.getString("NOMBRE_REFERENCIACC"));
                   resultado.setResultadoNumerico(res1.getDouble("resultadoNumerico"));
                   resultado.getTipoResultadoDescriptivo().setCodTipoResultadoDescriptivo(res1.getString("resultadoDescriptivo"));
                   resultado.getResultadoDescriptivoAlternativo().setCodTipoResultadoDescriptivo(codTipoResultadoAnalisis.equals("1")?"0":res1.getString("resultadoDescriptivo"));
                   resultado.getEspecificacionesFisicasProducto().getEstado().setCodEstadoRegistro("1");
               }
               res1.close();
               st1.close();
               con1.close();

           }
           catch(SQLException ex)
           {
               ex.printStackTrace();
           }
        return resultado;
    }
     public String getCargarAgregarControlDeCalidad()
    {
        mensaje="";
        try
        {
            Connection con=null;
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="";
            ResultSet res=null;
            consulta="select efcc.COD_ESPECIFICACION,efcc.NOMBRE_ESPECIFICACION,efp.LIMITE_INFERIOR,"+
                     " efp.VALOR_EXACTO,efp.LIMITE_SUPERIOR,efp.DESCRIPCION," +
                     "tr.NOMBRE_REFERENCIACC,ISNULL(rae.COD_TIPO_RESULTADO_DESCRIPTIVO,(case when efcc.COD_TIPO_RESULTADO_ANALISIS=1 then 1 else 0 end) ) as cod_tipoResultado,"+
                     " ISNULL(rae.RESULTADO_NUMERICO,0) as resultadoNumerico,efcc.COD_TIPO_RESULTADO_ANALISIS" +
                     " ,ISNULL(efcc.COEFICIENTE,'') AS COEFICIENTE,"+
                     " ISNULL(tra.SIMBOLO,'') as SIMBOLO" +
                     " ,ISNULL(tef.COD_TIPO_ESPECIFICACION_FISICA,0) as codTipoEspecificacion,"+
                     " ISNULL(tef.NOMBRE_TIPO_ESPECIFICACION_FISICA,'NINGUNO') as nombreTipoEspecificacion"+
                     " from ESPECIFICACIONES_FISICAS_PRODUCTO efp inner join ESPECIFICACIONES_FISICAS_CC efcc"+
                     " on efp.COD_ESPECIFICACION=efcc.COD_ESPECIFICACION inner join TIPOS_REFERENCIACC tr on"+
                     " tr.COD_REFERENCIACC=efp.COD_REFERENCIA_CC "+
                     " left outer join RESULTADO_ANALISIS_ESPECIFICACIONES rae on rae.COD_TIPO_ANALISIS=1"+
                     " and  rae.COD_ESPECIFICACION=efcc.COD_ESPECIFICACION"+
                     " and rae.COD_LOTE='"+currentProgramaProduccion.getCodLoteProduccion()+"'" +
                     " and rae.COD_COMPPROD=efp.COD_PRODUCTO"+
                     " LEFT OUTER JOIN TIPOS_RESULTADOS_ANALISIS tra on tra.COD_TIPO_RESULTADO_ANALISIS=efcc.COD_TIPO_RESULTADO_ANALISIS" +
                     " left outer join TIPOS_ESPECIFICACIONES_FISICAS tef on "+
                     " tef.COD_TIPO_ESPECIFICACION_FISICA=efp.COD_TIPO_ESPECIFICACION_FISICA"+
                     " where efp.ESTADO = 1 and efp.COD_PRODUCTO='"+currentProgramaProduccion.getFormulaMaestra().getComponentesProd().getCodCompprod()+"'" +
                     " and efp.COD_VERSION='"+resultadoAnalisis.getComponenteProd().getCodVersion()+"'"+
                     " order by isnull(tef.NOMBRE_TIPO_ESPECIFICACION_FISICA,''),efcc.NOMBRE_ESPECIFICACION";
            System.out.println("consulta cargar analisis fisico "+consulta);
            res=st.executeQuery(consulta);
            listaAnalisisFisicos.clear();

            while(res.next())
            {
                ResultadoAnalisisEspecificaciones bean= new ResultadoAnalisisEspecificaciones();
                bean.getEspecificacionesFisicasProducto().getEspecificacionFisicaCC().setCoeficiente(res.getString("COEFICIENTE"));
                bean.getEspecificacionesFisicasProducto().getEspecificacionFisicaCC().getTipoResultadoAnalisis().setSimbolo(res.getString("SIMBOLO"));
                bean.getEspecificacionesFisicasProducto().getEspecificacionFisicaCC().setNombreEspecificacion(res.getString("NOMBRE_ESPECIFICACION"));
                bean.getEspecificacionesFisicasProducto().getEspecificacionFisicaCC().setCodEspecificacion(res.getInt("COD_ESPECIFICACION"));
                bean.getEspecificacionesFisicasProducto().getEspecificacionFisicaCC().getTipoResultadoAnalisis().setCodTipoResultadoAnalisis(res.getString("COD_TIPO_RESULTADO_ANALISIS"));
                bean.getEspecificacionesFisicasProducto().setDescripcion(res.getString("DESCRIPCION"));
                bean.getEspecificacionesFisicasProducto().setLimiteInferior(res.getDouble("LIMITE_INFERIOR"));
                bean.getEspecificacionesFisicasProducto().setLimiteSuperior(res.getDouble("LIMITE_SUPERIOR"));
                bean.getEspecificacionesFisicasProducto().setValorExacto(res.getDouble("VALOR_EXACTO"));
                bean.getTipoAnalisis().setCodTipoAnalisis(1);
                bean.getTipoResultadoDescriptivo().setCodTipoResultadoDescriptivo(res.getString("cod_tipoResultado"));
                bean.getResultadoDescriptivoAlternativo().setCodTipoResultadoDescriptivo(bean.getEspecificacionesFisicasProducto().getEspecificacionFisicaCC().getTipoResultadoAnalisis().getCodTipoResultadoAnalisis().equals("1")?"0":res.getString("cod_tipoResultado"));
                bean.setResultadoNumerico(res.getDouble("resultadoNumerico"));
                bean.getEspecificacionesFisicasProducto().getEspecificacionFisicaCC().getTiposReferenciaCc().setNombreReferenciaCc(res.getString("NOMBRE_REFERENCIACC"));
                bean.getEspecificacionesFisicasProducto().getTiposEspecificacionesFisicas().setCodTipoEspecificacionFisica(res.getInt("codTipoEspecificacion"));
                bean.getEspecificacionesFisicasProducto().getTiposEspecificacionesFisicas().setNombreTipoEspecificacionFisica(res.getString("nombreTipoEspecificacion"));
                listaAnalisisFisicos.add(bean);
            }
            consulta="select eqcc.COD_ESPECIFICACION,eqcc.NOMBRE_ESPECIFICACION,eqcc.COD_TIPO_RESULTADO_ANALISIS" +
                     " ,ISNULL(eqcc.COEFICIENTE,'') as COEFICIENTE,ISNULL(tra.SIMBOLO,'') as SIMBOLO"+
                     " from ESPECIFICACIONES_QUIMICAS_PRODUCTO eqp inner join"+
                     " ESPECIFICACIONES_QUIMICAS_CC eqcc on eqp.COD_ESPECIFICACION=eqcc.COD_ESPECIFICACION" +
                     " LEFT OUTER JOIN TIPOS_RESULTADOS_ANALISIS tra on tra.COD_TIPO_RESULTADO_ANALISIS=eqcc.COD_TIPO_RESULTADO_ANALISIS"+
                     " where eqp.COD_PRODUCTO='"+currentProgramaProduccion.getFormulaMaestra().getComponentesProd().getCodCompprod()+"'  and eqp.ESTADO=1 " +
                     " and eqp.COD_VERSION='"+resultadoAnalisis.getComponenteProd().getCodVersion()+"'" +
                     " group by tra.SIMBOLO,eqcc.COEFICIENTE,eqcc.COD_ESPECIFICACION,eqcc.NOMBRE_ESPECIFICACION,eqcc.COD_TIPO_RESULTADO_ANALISIS";
            System.out.println("consulta para cargar analisis quimico "+consulta);
            res=st.executeQuery(consulta);
            listaAnalisisQuimicos.clear();
            while(res.next())
            {
                EspecificacionesQuimicasCc bean= new EspecificacionesQuimicasCc();
                bean.setNombreEspecificacion(res.getString("NOMBRE_ESPECIFICACION"));
                bean.setCodEspecificacion(res.getInt("COD_ESPECIFICACION"));
                bean.getTipoResultadoAnalisis().setCodTipoResultadoAnalisis(res.getString("COD_TIPO_RESULTADO_ANALISIS"));
                bean.setCoeficiente(res.getString("COEFICIENTE"));
                bean.getTipoResultadoAnalisis().setSimbolo(res.getString("SIMBOLO"));

                bean.setEspecificacionQuimicaGeneral(this.cargarResultadosEspecificacionQuimicaGeneral(currentProgramaProduccion.getCodLoteProduccion(), res.getString("COD_ESPECIFICACION"), currentProgramaProduccion.getFormulaMaestra().getComponentesProd().getCodCompprod(),
                        bean.getTipoResultadoAnalisis().getCodTipoResultadoAnalisis()));
                if(!bean.getEspecificacionQuimicaGeneral().getEspecificacionesFisicasProducto().getEstado().getCodEstadoRegistro().equals("1"))
                {
                    bean.setListaResultadoAnalisisEspecificacionesQuimicas(this.listaResultadosEspecificaionesQuimicas(currentProgramaProduccion.getCodLoteProduccion(), res.getString("COD_ESPECIFICACION"), currentProgramaProduccion.getFormulaMaestra().getComponentesProd().getCodCompprod(),
                        bean.getTipoResultadoAnalisis().getCodTipoResultadoAnalisis()));
                }

                listaAnalisisQuimicos.add(bean);
            }
            consulta=" select em.COD_ESPECIFICACION,em.NOMBRE_ESPECIFICACION,emp.LIMITE_INFERIOR,"+
                     " emp.LIMITE_SUPERIOR,emp.DESCRIPCION,emp.VALOR_EXACTO,tr.NOMBRE_REFERENCIACC,ISNULL(rae.COD_TIPO_RESULTADO_DESCRIPTIVO,(case when em.COD_TIPO_RESULTADO_ANALISIS=1 then 1 else 0 end)) as cod_tipoResultado,"+
                     " ISNULL(rae.RESULTADO_NUMERICO,0) as resultadoNumerico,em.COD_TIPO_RESULTADO_ANALISIS" +
                     " ,ISNULL(em.COEFICIENTE,'') as COEFICIENTE,ISNULL(tra.SIMBOLO,'') as SIMBOLO"+
                     " from ESPECIFICACIONES_MICROBIOLOGIA_PRODUCTO emp inner join ESPECIFICACIONES_MICROBIOLOGIA em on " +
                     " emp.COD_ESPECIFICACION = em.COD_ESPECIFICACION inner join TIPOS_REFERENCIACC tr on " +
                     " tr.COD_REFERENCIACC = emp.COD_REFERENCIA_CC left outer join RESULTADO_ANALISIS_ESPECIFICACIONES rae on"+
                     " rae.COD_TIPO_ANALISIS = 3 and "+
                     " rae.COD_ESPECIFICACION = emp.COD_ESPECIFICACION and rae.COD_LOTE='"+currentProgramaProduccion.getCodLoteProduccion()+"'" +
                     " and rae.COD_COMPPROD=emp.COD_COMPROD" +
                     " left outer join TIPOS_RESULTADOS_ANALISIS tra on tra.COD_TIPO_RESULTADO_ANALISIS=em.COD_TIPO_RESULTADO_ANALISIS"+
                     " where emp.ESTADO=1 and  emp.COD_COMPROD = '"+currentProgramaProduccion.getFormulaMaestra().getComponentesProd().getCodCompprod()+"'" +
                     " and emp.COD_VERSION='"+resultadoAnalisis.getComponenteProd().getCodVersion()+"' order by em.NOMBRE_ESPECIFICACION";
            System.out.println("cargar microbiologia "+consulta);
            res=st.executeQuery(consulta);
            listaAnalisisMicrobiologia.clear();
            while(res.next())
            {
                ResultadoAnalisisEspecificaciones bean= new ResultadoAnalisisEspecificaciones();
                bean.getEspecificacionesMicrobiologiaProducto().getEspecificacionMicrobiologiaCc().setCoeficiente(res.getString("COEFICIENTE"));
                bean.getEspecificacionesMicrobiologiaProducto().getEspecificacionMicrobiologiaCc().getTipoResultadoAnalisis().setSimbolo(res.getString("SIMBOLO"));
                bean.getEspecificacionesMicrobiologiaProducto().getEspecificacionMicrobiologiaCc().setNombreEspecificacion(res.getString("NOMBRE_ESPECIFICACION"));
                bean.getEspecificacionesMicrobiologiaProducto().getEspecificacionMicrobiologiaCc().setCodEspecificacion(res.getInt("COD_ESPECIFICACION"));
                bean.getEspecificacionesMicrobiologiaProducto().getEspecificacionMicrobiologiaCc().getTipoResultadoAnalisis().setCodTipoResultadoAnalisis(res.getString("COD_TIPO_RESULTADO_ANALISIS"));
                bean.getEspecificacionesMicrobiologiaProducto().setDescripcion(res.getString("DESCRIPCION"));
                bean.getEspecificacionesMicrobiologiaProducto().setLimiteInferior(res.getDouble("LIMITE_INFERIOR"));
                bean.getEspecificacionesMicrobiologiaProducto().setLimiteSuperior(res.getDouble("LIMITE_SUPERIOR"));
                bean.getEspecificacionesMicrobiologiaProducto().setValorExacto(res.getDouble("VALOR_EXACTO"));
                bean.getTipoAnalisis().setCodTipoAnalisis(3);
                bean.getTipoResultadoDescriptivo().setCodTipoResultadoDescriptivo(res.getString("cod_tipoResultado"));
                bean.getResultadoDescriptivoAlternativo().setCodTipoResultadoDescriptivo(bean.getEspecificacionesMicrobiologiaProducto().getEspecificacionMicrobiologiaCc().getTipoResultadoAnalisis().getCodTipoResultadoAnalisis().equals("1")?"0":
                res.getString("cod_tipoResultado"));
                bean.setResultadoNumerico(res.getDouble("resultadoNumerico"));
                bean.getEspecificacionesMicrobiologiaProducto().getEspecificacionMicrobiologiaCc().getTiposReferenciaCc().setNombreReferenciaCc(res.getString("NOMBRE_REFERENCIACC"));
                listaAnalisisMicrobiologia.add(bean);
            }

            consulta="select p.COD_PERSONAL,(p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRE_PILA) as nombrePersonal"+
                     " from PERSONAL p inner join FIRMAS_CERTIFICADO_CC fcc "+
                     " on fcc.COD_PERSONAL=p.COD_PERSONAL and fcc.cod_estado_registro=1 order by p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRE_PILA";
            System.out.println("consulta cargar analista "+consulta);
            listaAnalistas.clear();
            res=st.executeQuery(consulta);
            while(res.next())
            {
                listaAnalistas.add(new SelectItem(res.getString("COD_PERSONAL"),res.getString("nombrePersonal")));
            }
            consulta="select trd.COD_TIPO_RESULTADO_DESCRIPTIVO,trd.NOMBRE_TIPO_RESULTADO_DESCRIPTIVO from TIPO_RESULTADO_DESCRIPTIVO trd";
            listaTiposResultadoDescriptivo.clear();
            listaTiposResultadoDescriptivoAlternativo.clear();
            listaTiposResultadoDescriptivoAlternativo.add(new SelectItem("0","-Ninguno-"));
            res=st.executeQuery(consulta);
            while(res.next())
            {
                listaTiposResultadoDescriptivoAlternativo.add(new SelectItem(res.getString("COD_TIPO_RESULTADO_DESCRIPTIVO"),res.getString("NOMBRE_TIPO_RESULTADO_DESCRIPTIVO")));
                listaTiposResultadoDescriptivo.add(new SelectItem(res.getString("COD_TIPO_RESULTADO_DESCRIPTIVO"),res.getString("NOMBRE_TIPO_RESULTADO_DESCRIPTIVO")));
            }
            currentProgramaProduccion.setFechaVencimiento(null);
            consulta="SELECT MAX(P.COD_PROGRAMA_PROD)"+
                    "  FROM PROGRAMA_PRODUCCION P "+
                    " WHERE P.COD_LOTE_PRODUCCION='"+currentProgramaProduccion.getCodLoteProduccion()+"'";
            res=st.executeQuery(consulta);
            res.next();
            StringBuilder consulta1=new StringBuilder(" exec PAA_LISTAR_FECHA_VENCIMIENTO_LOTE")
                                    .append("'").append(currentProgramaProduccion.getCodLoteProduccion()).append("',")
                                    .append(res.getInt(1)).append(",")
                                    .append(currentProgramaProduccion.getFormulaMaestra().getComponentesProd().getCodCompprod()).append(",")
                                    .append(currentProgramaProduccion.getFormulaMaestra().getComponentesProd().getForma().getCodForma()).append(",")
                                    .append("?,")//mensaje
                                    .append("?,")//fecha vencimiento
                                    .append("?");//fecha pesaje
            System.out.println("consulta obtener vida util producto "+consulta1.toString());
            CallableStatement callVersionCopia=con.prepareCall(consulta1.toString());
            callVersionCopia.registerOutParameter(1,java.sql.Types.VARCHAR);
            callVersionCopia.registerOutParameter(2,java.sql.Types.TIMESTAMP);
            callVersionCopia.registerOutParameter(3,java.sql.Types.TIMESTAMP);
            callVersionCopia.execute();
            SimpleDateFormat sdf =new SimpleDateFormat("MM/yyyy");
            fechaVencimientoLoteRegistro=(callVersionCopia.getString(1).length()>0 ? callVersionCopia.getString(1):sdf.format(callVersionCopia.getTimestamp(2)));
            
            
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
    public String agregarControlDeCalidad()
    {
        setMensaje("");
       currentProgramaProduccion=(ProgramaProduccion)progProdResultadoAnalisDataTable.getRowData();
        try
        {
            Connection con=null;
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select ra.COD_VERSION_ESPECIFICACION_FISICA,ra.COD_VERSION_ESPECIFICACION_MICRO,ra.COD_VERSION_ESPECIFICACION_QUIMICA,ra.COD_VERSION_CONCENTRACION," +
                            " ra.TOMO,ra.PAGINA,ra.COD_ANALISIS,ra.COD_COMPROD,ra.NRO_ANALISIS,ra.NRO_ANALISIS_MICROBIOLOGICO,ra.COD_PERSONAL_ANALISTA,ra.COD_ESTADO_RESULTADO_ANALISIS " +
                            " from RESULTADO_ANALISIS ra where ra.COD_LOTE='"+currentProgramaProduccion.getCodLoteProduccion()+"' and ra.COD_COMPROD='"+currentProgramaProduccion.getFormulaMaestra().getComponentesProd().getCodCompprod()+"'";
            System.out.println("consulta analisis de lote "+consulta) ;
            ResultSet res=st.executeQuery(consulta);
            resultadoAnalisis= new ResultadoAnalisis();
            resultadoAnalisis.setCodLote(currentProgramaProduccion.getCodLoteProduccion());
            resultadoAnalisis.setComponenteProd(currentProgramaProduccion.getFormulaMaestra().getComponentesProd());
            if(res.next())
            {
                resultadoAnalisis.getVersionEspecificacionFisica().setCodVersionEspecificacionProducto(res.getInt("COD_VERSION_ESPECIFICACION_FISICA"));
                resultadoAnalisis.getVersionEspecificacionQuimica().setCodVersionEspecificacionProducto(res.getInt("COD_VERSION_ESPECIFICACION_QUIMICA"));
                resultadoAnalisis.getVersionEspecificacionMicrobiologica().setCodVersionEspecificacionProducto(res.getInt("COD_VERSION_ESPECIFICACION_MICRO"));
                resultadoAnalisis.getVersionConcentracionProducto().setCodVersionEspecificacionProducto(res.getInt("COD_VERSION_CONCENTRACION"));
                resultadoAnalisis.getEstadoResultadoAnalisis().setCodEstadoResultadoAnalisis(res.getInt("COD_ESTADO_RESULTADO_ANALISIS"));
                resultadoAnalisis.setComponenteProd(currentProgramaProduccion.getFormulaMaestra().getComponentesProd());
                resultadoAnalisis.setTomo(res.getString("TOMO"));
                resultadoAnalisis.setPagina(res.getString("PAGINA"));
                resultadoAnalisis.setNroAnalisis(res.getString("NRO_ANALISIS"));
                resultadoAnalisis.setNroAnalisisMicrobiologico(res.getString("NRO_ANALISIS_MICROBIOLOGICO"));
                resultadoAnalisis.getPersonalAnalista().setCodPersonal(res.getString("COD_PERSONAL_ANALISTA"));
                resultadoAnalisis.setCodAnalisis(res.getInt("COD_ANALISIS"));
                if(currentProgramaProduccion.getFormulaMaestra().getComponentesProd().getCodCompprod().equals(res.getString("COD_COMPROD")))
                {
                    setMensaje("Ya se registro un analisis para el lote,desea editarlo?");
                }
                else
                {
                    consulta="select cp.nombre_prod_semiterminado from COMPONENTES_PROD cp where cp.COD_COMPPROD='"+res.getString("COD_COMPROD")+"'";

                    System.out.println(consulta);
                    res=st.executeQuery(consulta);
                    if(res.next())
                    {
                        setMensaje("Ya se registro un analisis para el lote con el producto "+res.getString("nombre_prod_semiterminado")+" desea editarlo con las especificaciones de "+resultadoAnalisis.getComponenteProd().getNombreProdSemiterminado()+"?");
                    }

                }
                if(resultadoAnalisis.getEstadoResultadoAnalisis().getCodEstadoResultadoAnalisis()==1)
                {
                    Aleatorios a = new Aleatorios(1);
                    int numeros[] = a.generar(1, 10, 10000);
                    codigoAleatorio=numeros[0];
                    autorizacion="";
                    setMensaje("2");
                }
            }
            else
            {
                setMensaje("");
                consulta="select ISNULL(MAX(ra.COD_ANALISIS),0)+1 as cod from RESULTADO_ANALISIS ra ";
                res=st.executeQuery(consulta);
                if(res.next())
                {
                    resultadoAnalisis.setCodAnalisis(res.getInt("cod"));
                }
                resultadoAnalisis.setComponenteProd(currentProgramaProduccion.getFormulaMaestra().getComponentesProd());
            }

            res.close();
            st.close();
            con.close();
            //this.redireccionar("agregarResultadoAnalisis.jsf");
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
        if(resultadoAnalisis.getVersionConcentracionProducto().getCodVersionEspecificacionProducto()>0||
           resultadoAnalisis.getVersionEspecificacionFisica().getCodVersionEspecificacionProducto()>0||
           resultadoAnalisis.getVersionEspecificacionMicrobiologica().getCodVersionEspecificacionProducto()>0||
           resultadoAnalisis.getVersionEspecificacionQuimica().getCodVersionEspecificacionProducto()>0)
        {
            mensaje="-1";
        }
       
        return null;
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
    public String mostrarAnalisisControlDeCalidad()
    {
        this.redireccionar("agregarResultadoAnalisis.jsf");
        return null;
    }
    public String cancelarAnalisisControlDeCalidad()
    {
        this.redireccionar("navProgProdResultadoAnalisis.jsf");
        return null;
    }
    public String guardarAnalisisControlDeCalidad()throws SQLException
    {
        mensaje="";
        Connection con=null;
        try
        {
            String consulta="DELETE RESULTADO_ANALISIS where COD_LOTE='"+currentProgramaProduccion.getCodLoteProduccion()+"' and COD_COMPROD='"+resultadoAnalisis.getComponenteProd().getCodCompprod()+"'";
            con=Util.openConnection(con);
            con.setAutoCommit(false);
            System.out.println("consulta delete "+consulta);
            PreparedStatement pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("existia un registro anterior de resultado de analisis");
            SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm");
            consulta="INSERT INTO RESULTADO_ANALISIS(COD_LOTE, COD_COMPROD, NRO_ANALISIS, COD_ANALISIS, COD_PERSONAL_ANALISTA,TOMO,PAGINA,COD_ESTADO_RESULTADO_ANALISIS,NRO_ANALISIS_MICROBIOLOGICO,FECHA_EMISION," +
                    " COD_VERSION_ESPECIFICACION_FISICA,COD_VERSION_ESPECIFICACION_QUIMICA,COD_VERSION_ESPECIFICACION_MICRO,COD_VERSION_CONCENTRACION)"+
                     " VALUES ('"+resultadoAnalisis.getCodLote()+"','"+resultadoAnalisis.getComponenteProd().getCodCompprod()+"'," +
                     "'"+resultadoAnalisis.getNroAnalisis()+"','"+resultadoAnalisis.getCodAnalisis()+"','"+resultadoAnalisis.getPersonalAnalista().getCodPersonal()+"'" +
                     ",'"+resultadoAnalisis.getTomo()+"','"+resultadoAnalisis.getPagina()+"',3,'"+resultadoAnalisis.getNroAnalisisMicrobiologico()+"','"+sdf.format(new Date())+"'" +
                     ",'"+resultadoAnalisis.getVersionEspecificacionFisica().getCodVersionEspecificacionProducto()+"','"+resultadoAnalisis.getVersionEspecificacionQuimica().getCodVersionEspecificacionProducto()+"'," +
                     "'"+resultadoAnalisis.getVersionEspecificacionMicrobiologica().getCodVersionEspecificacionProducto()+"','"+resultadoAnalisis.getVersionConcentracionProducto().getCodVersionEspecificacionProducto()+"')";
            System.out.println("consulta insertar"+consulta);
            pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se inserto el detalle de analisis especificaciones");
            consulta= "DELETE RESULTADO_ANALISIS_ESPECIFICACIONES  WHERE COD_LOTE='"+resultadoAnalisis.getCodLote()+"' and COD_COMPPROD='"+resultadoAnalisis.getComponenteProd().getCodCompprod()+"'";
            pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("existian registro del detalle y fueron eliminados");
            for(ResultadoAnalisisEspecificaciones current:listaAnalisisFisicos)
            {
                consulta="INSERT INTO RESULTADO_ANALISIS_ESPECIFICACIONES(COD_LOTE, COD_TIPO_ANALISIS,COD_ESPECIFICACION, COD_TIPO_RESULTADO_DESCRIPTIVO, RESULTADO_NUMERICO,COD_COMPPROD)"+
                         " VALUES ('"+resultadoAnalisis.getCodLote()+"',1,'"+current.getEspecificacionesFisicasProducto().getEspecificacionFisicaCC().getCodEspecificacion()+"',"+
                         " '"+(current.getEspecificacionesFisicasProducto().getEspecificacionFisicaCC().getTipoResultadoAnalisis().getCodTipoResultadoAnalisis().equals("1")?
                             current.getTipoResultadoDescriptivo().getCodTipoResultadoDescriptivo():
                             current.getResultadoDescriptivoAlternativo().getCodTipoResultadoDescriptivo())+
                         "','"+current.getResultadoNumerico()+"','"+resultadoAnalisis.getComponenteProd().getCodCompprod()+"')";
                System.out.println("consulta insert "+consulta);
                pst=con.prepareStatement(consulta);
                if(pst.executeUpdate()>0)System.out.println("se inserto el resultado correctamente");
            }
            for(ResultadoAnalisisEspecificaciones current1:listaAnalisisMicrobiologia)
            {
                 consulta="INSERT INTO RESULTADO_ANALISIS_ESPECIFICACIONES(COD_LOTE, COD_TIPO_ANALISIS,COD_ESPECIFICACION, COD_TIPO_RESULTADO_DESCRIPTIVO, RESULTADO_NUMERICO,COD_COMPPROD)"+
                         " VALUES ('"+resultadoAnalisis.getCodLote()+"',3,'"+current1.getEspecificacionesMicrobiologiaProducto().getEspecificacionMicrobiologiaCc().getCodEspecificacion()+"',"+
                         " '"+(current1.getEspecificacionesMicrobiologiaProducto().getEspecificacionMicrobiologiaCc().getTipoResultadoAnalisis().getCodTipoResultadoAnalisis().equals("1")?
                             current1.getTipoResultadoDescriptivo().getCodTipoResultadoDescriptivo():
                             current1.getResultadoDescriptivoAlternativo().getCodTipoResultadoDescriptivo())+
                         "','"+current1.getResultadoNumerico()+"','"+resultadoAnalisis.getComponenteProd().getCodCompprod()+"')";
                 System.out.println("consulta insert micro "+consulta );
                 pst=con.prepareStatement(consulta);
                 if(pst.executeUpdate()>0)System.out.println("se inserto el detalle de microbiologia correctamente ");

            }
            consulta="DELETE RESULTADO_ANALISIS_ESPECIFICACIONES_QUIMICAS  where  COD_LOTE='"+currentProgramaProduccion.getCodLoteProduccion()+"' and COD_COMPPROD='"+resultadoAnalisis.getComponenteProd().getCodCompprod()+"'";
            System.out.println("delete analisis quimicos "+consulta);
            pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("Existian detalles y se eliminaron");
            for(EspecificacionesQuimicasCc current2:listaAnalisisQuimicos)
            {
                if(current2.getEspecificacionQuimicaGeneral().getEspecificacionesFisicasProducto().getEstado().getCodEstadoRegistro().equals("1"))
                {
                    consulta="INSERT INTO RESULTADO_ANALISIS_ESPECIFICACIONES_QUIMICAS(COD_LOTE, COD_MATERIAL,COD_ESPECIFICACION, COD_TIPO_RESULTADO_DESCRIPTIVO, RESULTADO_NUMERICO,COD_MATERIAL_COMPUESTO_CC,COD_COMPPROD)"+
                                 " VALUES ('"+resultadoAnalisis.getCodLote()+"','-1'," +
                                 " '"+current2.getCodEspecificacion()+"','"+
                                 (current2.getTipoResultadoAnalisis().getCodTipoResultadoAnalisis().equals("1")?current2.getEspecificacionQuimicaGeneral().getTipoResultadoDescriptivo().getCodTipoResultadoDescriptivo()
                                 :current2.getEspecificacionQuimicaGeneral().getResultadoDescriptivoAlternativo().getCodTipoResultadoDescriptivo())+"'" +
                                 ",'"+current2.getEspecificacionQuimicaGeneral().getResultadoNumerico()+"','0','"+resultadoAnalisis.getComponenteProd().getCodCompprod()+"');";
                        System.out.println("consulta insert quimica general"+consulta);
                        pst=con.prepareStatement(consulta);
                        if(pst.executeUpdate()>0)System.out.println("se inserto el resultado de analisis quimico");
                }
                else
                {
                    for(ResultadosAnalisisEspecificacionesQuimicas currentQ: current2.getListaResultadoAnalisisEspecificacionesQuimicas())
                    {
                        consulta="INSERT INTO RESULTADO_ANALISIS_ESPECIFICACIONES_QUIMICAS(COD_LOTE, COD_MATERIAL,COD_ESPECIFICACION, COD_TIPO_RESULTADO_DESCRIPTIVO, RESULTADO_NUMERICO,COD_MATERIAL_COMPUESTO_CC,COD_COMPPROD)"+
                                 " VALUES ('"+resultadoAnalisis.getCodLote()+"','"+currentQ.getEspecificacionesQuimicasProducto().getMaterial().getCodMaterial()+"'," +
                                 " '"+current2.getCodEspecificacion()+"','"+
                                 (current2.getTipoResultadoAnalisis().getCodTipoResultadoAnalisis().equals("1")?currentQ.getTipoResultadoDescriptivo().getCodTipoResultadoDescriptivo():
                                     currentQ.getResultadoDescriptivoAlternativo().getCodTipoResultadoDescriptivo())+"','"+currentQ.getResultadoNumerico()+"','"+currentQ.getEspecificacionesQuimicasProducto().getMaterialesCompuestosCc().getCodMaterialCompuestoCc()+"'" +
                                     ",'"+resultadoAnalisis.getComponenteProd().getCodCompprod()+"')";
                        System.out.println("consulta insert quimica "+consulta);
                        pst=con.prepareStatement(consulta);
                        if(pst.executeUpdate()>0)System.out.println("se inserto el resultado de analisis quimico");

                    }
                }

            }
            con.commit();
            mensaje="registrado";
            pst.close();
            con.close();
            //this.redireccionar("navProgProdResultadoAnalisis.jsf");
        }
        catch(SQLException ex)
        {
            mensaje="Ocurrio un problema al registrar el analisis,intente de nuevo . Si el problema persiste comuniquese con Sistemas";
            con.rollback();
            con.close();
            System.out.println("error control de calidad");
            ex.printStackTrace();
        }
        
        return null;

    }
    public String seleccionarProgramaProduccionPeriodoAction()
    {
        ProgramaProduccionPeriodo current=(ProgramaProduccionPeriodo)programaProduccionPeriodoDataTable.getRowData();
        programaProduccionbean.getProgramaProduccionPeriodo().setNombreProgramaProduccion(current.getNombreProgramaProduccion());
        programaProduccionbean.setCodProgramaProduccion(current.getCodProgramaProduccion());
        programaProduccionbean.setCodLoteProduccion("");
        return null;
    }

    public List<ResultadoAnalisisEspecificaciones> getListaAnalisisFisicos() {
        return listaAnalisisFisicos;
    }

    public void setListaAnalisisFisicos(List<ResultadoAnalisisEspecificaciones> listaAnalisisFisicos) {
        this.listaAnalisisFisicos = listaAnalisisFisicos;
    }

    public List<ResultadoAnalisisEspecificaciones> getListaAnalisisMicrobiologia() {
        return listaAnalisisMicrobiologia;
    }

    public void setListaAnalisisMicrobiologia(List<ResultadoAnalisisEspecificaciones> listaAnalisisMicrobiologia) {
        this.listaAnalisisMicrobiologia = listaAnalisisMicrobiologia;
    }

    public List<EspecificacionesQuimicasCc> getListaAnalisisQuimicos() {
        return listaAnalisisQuimicos;
    }

    public void setListaAnalisisQuimicos(List<EspecificacionesQuimicasCc> listaAnalisisQuimicos) {
        this.listaAnalisisQuimicos = listaAnalisisQuimicos;
    }



    public ProgramaProduccion getCurrentProgramaProduccion() {
        return currentProgramaProduccion;
    }

    public void setCurrentProgramaProduccion(ProgramaProduccion currentProgramaProduccion) {
        this.currentProgramaProduccion = currentProgramaProduccion;
    }

    public String getNroAnalisis() {
        return nroAnalisis;
    }

    public void setNroAnalisis(String nroAnalisis) {
        this.nroAnalisis = nroAnalisis;
    }

    public String getCodAnalista() {
        return codAnalista;
    }

    public void setCodAnalista(String codAnalista) {
        this.codAnalista = codAnalista;
    }

    public List<SelectItem> getListaAnalistas() {
        return listaAnalistas;
    }

    public void setListaAnalistas(List<SelectItem> listaAnalistas) {
        this.listaAnalistas = listaAnalistas;
    }

    public ResultadoAnalisis getResultadoAnalisis() {
        return resultadoAnalisis;
    }

    public void setResultadoAnalisis(ResultadoAnalisis resultadoAnalisis) {
        this.resultadoAnalisis = resultadoAnalisis;
    }

    public List<SelectItem> getListaTiposResultadoDescriptivo() {
        return listaTiposResultadoDescriptivo;
    }

    public void setListaTiposResultadoDescriptivo(List<SelectItem> listaTiposResultadoDescriptivo) {
        this.listaTiposResultadoDescriptivo = listaTiposResultadoDescriptivo;
    }

    public String getCodAnalisis() {
        return codAnalisis;
    }

    public void setCodAnalisis(String codAnalisis) {
        this.codAnalisis = codAnalisis;
    }

    public String getCodProgramaProd() {
        return codProgramaProd;
    }

    public void setCodProgramaProd(String codProgramaProd) {
        this.codProgramaProd = codProgramaProd;
    }

    public String getCodTipoProgramaProd() {
        return codTipoProgramaProd;
    }

    public void setCodTipoProgramaProd(String codTipoProgramaProd) {
        this.codTipoProgramaProd = codTipoProgramaProd;
    }

    public String getMensaje() {
        return mensaje;
    }

    public void setMensaje(String mensaje) {
        this.mensaje = mensaje;
    }

    public HtmlDataTable getProgProdResultadoAnalisDataTable() {
        return progProdResultadoAnalisDataTable;
    }

    public void setProgProdResultadoAnalisDataTable(HtmlDataTable progProdResultadoAnalisDataTable) {
        this.progProdResultadoAnalisDataTable = progProdResultadoAnalisDataTable;
    }


    public List<ProgramaProduccion> getProgramaProduccionList() {
        return programaProduccionList;
    }

    public void setProgramaProduccionList(List<ProgramaProduccion> programaProduccionList) {
        this.programaProduccionList = programaProduccionList;
    }

    public List getProgramaProduccionPeriodoList() {
        return programaProduccionPeriodoList;
    }

    public void setProgramaProduccionPeriodoList(List programaProduccionPeriodoList) {
        this.programaProduccionPeriodoList = programaProduccionPeriodoList;
    }

    public ProgramaProduccion getProgramaProduccionbean() {
        return programaProduccionbean;
    }

    public void setProgramaProduccionbean(ProgramaProduccion programaProduccionbean) {
        this.programaProduccionbean = programaProduccionbean;
    }

    public String getLoteBuscar() {
        return loteBuscar;
    }

    public void setLoteBuscar(String loteBuscar) {
        this.loteBuscar = loteBuscar;
    }

    public ListDataModel getLista() {
        return lista;
    }

    public void setLista(ListDataModel lista) {
        this.lista = lista;
    }

    public List<ResultadoAnalisis> getResultadosAnalisisList() {
        return resultadosAnalisisList;
    }

    public void setResultadosAnalisisList(List<ResultadoAnalisis> resultadosAnalisisList) {
        this.resultadosAnalisisList = resultadosAnalisisList;
    }

    public String getMensajeDenegado() {
        return mensajeDenegado;
    }

    public void setMensajeDenegado(String mensajeDenegado) {
        this.mensajeDenegado = mensajeDenegado;
    }

    public ResultadoAnalisis getResultadoAnalisisBean() {
        return resultadoAnalisisBean;
    }

    public void setResultadoAnalisisBean(ResultadoAnalisis resultadoAnalisisBean) {
        this.resultadoAnalisisBean = resultadoAnalisisBean;
    }

    public ResultadoAnalisis getResultadoAnalisisBuscar() {
        return resultadoAnalisisBuscar;
    }

    public void setResultadoAnalisisBuscar(ResultadoAnalisis resultadoAnalisisBuscar) {
        this.resultadoAnalisisBuscar = resultadoAnalisisBuscar;
    }

    public List<SelectItem> getAnalistasList() {
        return analistasList;
    }

    public void setAnalistasList(List<SelectItem> analistasList) {
        this.analistasList = analistasList;
    }

    public List<SelectItem> getEstadosResultadosList() {
        return estadosResultadosList;
    }

    public void setEstadosResultadosList(List<SelectItem> estadosResultadosList) {
        this.estadosResultadosList = estadosResultadosList;
    }

    public List<SelectItem> getListaTiposResultadoDescriptivoAlternativo() {
        return listaTiposResultadoDescriptivoAlternativo;
    }

    public void setListaTiposResultadoDescriptivoAlternativo(List<SelectItem> listaTiposResultadoDescriptivoAlternativo) {
        this.listaTiposResultadoDescriptivoAlternativo = listaTiposResultadoDescriptivoAlternativo;
    }

    public HtmlDataTable getProgramaProduccionPeriodoDataTable() {
        return programaProduccionPeriodoDataTable;
    }

    public void setProgramaProduccionPeriodoDataTable(HtmlDataTable programaProduccionPeriodoDataTable) {
        this.programaProduccionPeriodoDataTable = programaProduccionPeriodoDataTable;
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

    public Date getFechaFinalEmision() {
        return fechaFinalEmision;
    }

    public void setFechaFinalEmision(Date fechaFinalEmision) {
        this.fechaFinalEmision = fechaFinalEmision;
    }

    public Date getFechaFinalRevision() {
        return fechaFinalRevision;
    }

    public void setFechaFinalRevision(Date fechaFinalRevision) {
        this.fechaFinalRevision = fechaFinalRevision;
    }

    public Date getFechaInicioEmision() {
        return fechaInicioEmision;
    }

    public void setFechaInicioEmision(Date fechaInicioEmision) {
        this.fechaInicioEmision = fechaInicioEmision;
    }

    public Date getFechaInicioRevision() {
        return fechaInicioRevision;
    }

    public void setFechaInicioRevision(Date fechaInicioRevision) {
        this.fechaInicioRevision = fechaInicioRevision;
    }

    public String[] getCodProgramaProdPerSeleccionado() {
        return codProgramaProdPerSeleccionado;
    }

    public void setCodProgramaProdPerSeleccionado(String[] codProgramaProdPerSeleccionado) {
        this.codProgramaProdPerSeleccionado = codProgramaProdPerSeleccionado;
    }

    public List<SelectItem> getComponentesProdSelectList() {
        return componentesProdSelectList;
    }

    public void setComponentesProdSelectList(List<SelectItem> componentesProdSelectList) {
        this.componentesProdSelectList = componentesProdSelectList;
    }

    public List<SelectItem> getProgramaProdPeriodoSelectList() {
        return programaProdPeriodoSelectList;
    }

    public void setProgramaProdPeriodoSelectList(List<SelectItem> programaProdPeriodoSelectList) {
        this.programaProdPeriodoSelectList = programaProdPeriodoSelectList;
    }

    public String getCodCompProdBuscar() {
        return codCompProdBuscar;
    }

    public void setCodCompProdBuscar(String codCompProdBuscar) {
        this.codCompProdBuscar = codCompProdBuscar;
    }

    public String getFechaVencimientoLoteRegistro() {
        return fechaVencimientoLoteRegistro;
    }

    public void setFechaVencimientoLoteRegistro(String fechaVencimientoLoteRegistro) {
        this.fechaVencimientoLoteRegistro = fechaVencimientoLoteRegistro;
    }

    
    
}
