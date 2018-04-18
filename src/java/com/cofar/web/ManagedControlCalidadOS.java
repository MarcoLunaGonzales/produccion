/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.web;

import com.cofar.bean.EspecificacionesOos;
import com.cofar.bean.ProgramaProduccion;
import com.cofar.bean.ProgramaProduccionPeriodo;

import com.cofar.bean.SeguimientoProgramaProduccionPersonal;
import com.cofar.bean.SubEspecificacionesOOS;
import com.cofar.bean.util.correos.EnvioCorreoRegistroOOS;
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
import java.util.List;
import java.util.Locale;
import javax.faces.model.SelectItem;
import org.apache.logging.log4j.LogManager;
import org.richfaces.component.html.HtmlDataTable;


/**
 *
 * @author DASISAQ
 */

public class ManagedControlCalidadOS extends ManagedBean{

    private List<ProgramaProduccionPeriodo> programaProduccionPeriodoList= new ArrayList<ProgramaProduccionPeriodo>();
    private HtmlDataTable programaProduccionPeriodoDataTable=new HtmlDataTable();
    private ProgramaProduccionPeriodo programaProduccionPeriodoSeleccionado=new ProgramaProduccionPeriodo();
    private List<ProgramaProduccion> programaProduccionList=new ArrayList<ProgramaProduccion>();
    private SeguimientoProgramaProduccionPersonal seguimientoProgramaProduccionPersonalBuscar=new SeguimientoProgramaProduccionPersonal();
    private HtmlDataTable programaProduccionDataTable=new HtmlDataTable();
    private List<SeguimientoProgramaProduccionPersonal> seguimientoProgramaProduccionPersonalOS=new ArrayList<SeguimientoProgramaProduccionPersonal>();
    private ProgramaProduccion programaProduccionSeleccionado=new ProgramaProduccion();
    private String mensaje="";
    private List<SelectItem> tiposProgrProdSelectList=new ArrayList<SelectItem>();
    private List<SelectItem> areasEmpresaSelectList=new ArrayList<SelectItem>();
    private List<SelectItem> componentesProdSelectList= new ArrayList<SelectItem>();
    private List<SelectItem> estadosProgramaProdSelectList=new ArrayList<SelectItem>();
    private List<SelectItem> programaProduccionSelectList=new ArrayList<SelectItem>();
    private String[] codProgramaProduccion=null;
    private List<EspecificacionesOos> especificacionesOosList=new ArrayList<EspecificacionesOos>();
    private List<SelectItem> tiposEspecificacionesOosSelectList=new ArrayList<SelectItem>();
    private EspecificacionesOos especificacionesOosRegistrar=new EspecificacionesOos();
    private int codTipoEspecificacionOosFiltro=0;
    private List<SubEspecificacionesOOS> subEspecificacionesOOSList=new ArrayList<SubEspecificacionesOOS>();
    private HtmlDataTable especificacionesOOSDataTable=new HtmlDataTable();
    private SubEspecificacionesOOS subEspecificacionesOOSRegistrar=new SubEspecificacionesOOS();
    private List<EspecificacionesOos> especificacionesOosInvestigacion=new ArrayList<EspecificacionesOos>();
    private List<EspecificacionesOos> especificacionesOosEvaluacion=new ArrayList<EspecificacionesOos>();
    private List<EspecificacionesOos> especificacionesOosLaboratorio=new ArrayList<EspecificacionesOos>();
    private List<EspecificacionesOos> especificacionesOosProduccion=new ArrayList<EspecificacionesOos>();
    Connection con=null;
    int codPermisoOOs=0;
    private int estadoRegistroOOS=0;
    private List<SelectItem> personalRegistroSelectList=new ArrayList<SelectItem>();
    
    /** Creates a new instance of ManagedControlCalidadOS */
    public ManagedControlCalidadOS() {
        LOGGER=LogManager.getLogger("OOS");
    }
    private void cargarPersonalSelectRegistro()
    {
        try
        {
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery("select p.COD_PERSONAL,(p.AP_PATERNO_PERSONAL +' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL+' '+p.nombre2_personal) as nombrePersonal from personal p where p.COD_ESTADO_PERSONA=1"+
                                          "order by p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRES_PERSONAL,p.nombre2_personal");
            personalRegistroSelectList.clear();
            personalRegistroSelectList.add(new SelectItem("0","--Seleccione una opcion-"));
            while(res.next())
            {
                personalRegistroSelectList.add(new SelectItem(res.getString("COD_PERSONAL"),res.getString("nombrePersonal")));
            }
            st.close();
            con.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
    }
    
    public String guardarRegistroOOS_action()throws SQLException
    {
        
        mensaje="";
        try
        {
            con=Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta=new StringBuilder("");
            PreparedStatement pst=null;
            SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");
            if(programaProduccionSeleccionado.getRegistroOOS().getCodRegistroOOS()==0)
            {
                
                consulta=new StringBuilder("INSERT INTO REGISTRO_OOS( CORRELATIVO_OOS, COD_LOTE,COD_PROGRAMA_PROD,FECHA_DETECCION,FECHA_ENVIO_ASC,COD_PERSONAL_DETECTA,PROVEEDOR)");
                         consulta.append(" VALUES (");
                             consulta.append("'").append(programaProduccionSeleccionado.getRegistroOOS().getCorrelativoOOS()).append("',");
                             consulta.append("'").append(programaProduccionSeleccionado.getCodLoteProduccion()).append("',");
                             consulta.append(programaProduccionSeleccionado.getProgramaProduccionPeriodo().getCodProgramaProduccion()).append(",");
                             consulta.append("'").append(sdf.format(programaProduccionSeleccionado.getRegistroOOS().getFechaDeteccion())).append("',");
                             consulta.append("'").append(sdf.format(programaProduccionSeleccionado.getRegistroOOS().getFechaEnvioAsc())).append("',");
                             consulta.append(programaProduccionSeleccionado.getRegistroOOS().getPersonalDetectaOOS().getCodPersonal()).append(",");
                             consulta.append("'").append(programaProduccionSeleccionado.getRegistroOOS().getProveedor()).append("'");
                         consulta.append(")");
                LOGGER.debug("consulta guardarRegistro oos "+consulta);
                pst=con.prepareStatement(consulta.toString(),PreparedStatement.RETURN_GENERATED_KEYS);
                if(pst.executeUpdate()>0)LOGGER.info("se registro el oos");
                ResultSet res=pst.getGeneratedKeys();
                if(res.next())programaProduccionSeleccionado.getRegistroOOS().setCodRegistroOOS(res.getInt(1));
            }
            else
            {
                consulta=new StringBuilder("UPDATE REGISTRO_OOS");
                            consulta.append(" SET ");
                                consulta.append(" COD_PERSONAL_DETECTA = ").append(programaProduccionSeleccionado.getRegistroOOS().getPersonalDetectaOOS().getCodPersonal()).append(",");
                                consulta.append(" FECHA_DETECCION = '").append(sdf.format(programaProduccionSeleccionado.getRegistroOOS().getFechaDeteccion())).append("',");
                                consulta.append(" FECHA_ENVIO_ASC = '").append(sdf.format(programaProduccionSeleccionado.getRegistroOOS().getFechaEnvioAsc())).append("',");
                                consulta.append(" PROVEEDOR ='").append(programaProduccionSeleccionado.getRegistroOOS().getProveedor()).append("'");
                            consulta.append(" WHERE  COD_REGISTRO_OOS = ").append(programaProduccionSeleccionado.getRegistroOOS().getCodRegistroOOS());
                LOGGER.debug("consulta update registro oos"+consulta.toString());
                pst=con.prepareStatement(consulta.toString());
                if(pst.executeUpdate()>0)LOGGER.info("se actualizo el registro oos");
                consulta=new StringBuilder(" delete REGISTRO_OOS_DETALLE where COD_REGISTRO_OOS=").append(programaProduccionSeleccionado.getRegistroOOS().getCodRegistroOOS());
                LOGGER.debug("consulta delete resultados existentes "+consulta.toString());
                pst=con.prepareStatement(consulta.toString());
                if(pst.executeUpdate()>0)LOGGER.info("se eliminaron anteriores registros");
            }
            consulta=new StringBuilder("INSERT INTO REGISTRO_OOS_DETALLE(COD_REGISTRO_OOS, COD_ESPECIFICACION_OOS,COD_SUB_ESPECIFICACION_OOS, DESCRIPCION,FECHA_CUMPLIMIENTO)");
                       consulta.append(" VALUES (");
                            consulta.append(programaProduccionSeleccionado.getRegistroOOS().getCodRegistroOOS()).append(",");
                            consulta.append("?,?,?,?");
                       consulta.append(")");
            LOGGER.debug("consulta registro detalle oos pstrd"+consulta.toString());
            pst=con.prepareStatement(consulta.toString());
            for(EspecificacionesOos esp:especificacionesOosInvestigacion)
            {
                if(esp.getSubEspecificacionesOOSList()==null)
                {
                    pst.setInt(1,esp.getCodEspecificacionOos());LOGGER.info("p1 pstrd:"+esp.getCodEspecificacionOos());
                    pst.setInt(2,0);LOGGER.info("p2 pstrd: 0");
                    pst.setString(3,esp.getDescripcionEspecificacion());LOGGER.info("p3 pstrd:"+esp.getDescripcionEspecificacion());
                    pst.setString(4,null);LOGGER.info("p4 pstrd:"+null);
                    if(pst.executeUpdate()>0)LOGGER.info("se registro el detalle");
                }
                else
                {
                    for(SubEspecificacionesOOS subEsp:esp.getSubEspecificacionesOOSList())
                    {
                        pst.setInt(1,esp.getCodEspecificacionOos());LOGGER.info("p1 pstrd:"+esp.getCodEspecificacionOos());
                        pst.setInt(2,subEsp.getCodSubEspecificacionOOS());LOGGER.info("p2 pstrd:"+subEsp.getCodSubEspecificacionOOS());
                        pst.setString(3,subEsp.getDescripcionEspecificaciones());LOGGER.info("p3 pstrd:"+subEsp.getDescripcionEspecificaciones());
                        pst.setString(4,null);LOGGER.info("p4 pstrd:"+null);
                        if(pst.executeUpdate()>0)LOGGER.info("Se registro el detalle");
                    }
                }
            }
            for(EspecificacionesOos esp:especificacionesOosEvaluacion)
            {
                if(esp.getSubEspecificacionesOOSList()==null)
                {
                    pst.setInt(1,esp.getCodEspecificacionOos());LOGGER.info("p1 pstrd:"+esp.getCodEspecificacionOos());
                    pst.setInt(2,0);LOGGER.info("p2 pstrd: 0");
                    pst.setString(3,esp.getDescripcionEspecificacion());LOGGER.info("p3 pstrd: "+esp.getDescripcionEspecificacion());
                    pst.setString(4,(esp.getFechaCumplimientoOos()!=null?sdf.format(esp.getFechaCumplimientoOos()):null));LOGGER.info("p4 pstrd: "+(esp.getFechaCumplimientoOos()!=null?sdf.format(esp.getFechaCumplimientoOos()):null));
                    if(pst.executeUpdate()>0)LOGGER.info("Se registro el detalle");
                }
                else
                {
                    for(SubEspecificacionesOOS subEsp:esp.getSubEspecificacionesOOSList())
                    {
                         pst.setInt(1,esp.getCodEspecificacionOos());LOGGER.info("p1 pstrd:"+esp.getCodEspecificacionOos());
                        pst.setInt(2,subEsp.getCodSubEspecificacionOOS());LOGGER.info("p2 pstrd:"+subEsp.getCodSubEspecificacionOOS());
                        pst.setString(3,subEsp.getDescripcionEspecificaciones());LOGGER.info("p3 pstrd:"+subEsp.getDescripcionEspecificaciones());
                        pst.setString(4,null);LOGGER.info("p4 pstrd:"+null);
                        if(pst.executeUpdate()>0)LOGGER.info("sLOGGER.infolle");
                    }
                }
            }
            for(EspecificacionesOos esp:especificacionesOosLaboratorio)
            {
                if(esp.getSubEspecificacionesOOSList()==null)
                {
                    pst.setInt(1,esp.getCodEspecificacionOos());LOGGER.info("p1 pstrd:"+esp.getCodEspecificacionOos());
                    pst.setInt(2,0);LOGGER.info("p2 pstrd: 0");
                    pst.setString(3,esp.getDescripcionEspecificacion());LOGGER.info("p3 pstrd:"+esp.getDescripcionEspecificacion());
                    pst.setString(4,(esp.getFechaCumplimientoOos()!=null?sdf.format(esp.getFechaCumplimientoOos()):null));LOGGER.info("p4 pstrd: "+(esp.getFechaCumplimientoOos()!=null?sdf.format(esp.getFechaCumplimientoOos()):null));
                    if(pst.executeUpdate()>0)LOGGER.info("Se registro el detalle");           
                }
                else
                {
                    for(SubEspecificacionesOOS subEsp:esp.getSubEspecificacionesOOSList())
                    {
                        pst.setInt(1,esp.getCodEspecificacionOos());LOGGER.info("p1 pstrd:"+esp.getCodEspecificacionOos());
                        pst.setInt(2,subEsp.getCodSubEspecificacionOOS());LOGGER.info("p2 pstrd:"+subEsp.getCodSubEspecificacionOOS());
                        pst.setString(3,subEsp.getDescripcionEspecificaciones());LOGGER.info("p3 pstrd:"+subEsp.getDescripcionEspecificaciones());
                        pst.setString(4,null);LOGGER.info("p4 pstrd:"+null);
                        if(pst.executeUpdate()>0)LOGGER.info("se registro el detalle");
                    }
                }
            }
            if(codPermisoOOs>1)
            {
                for(EspecificacionesOos esp:especificacionesOosProduccion)
                {
                    if(esp.getSubEspecificacionesOOSList()==null)
                    {
                        pst.setInt(1,esp.getCodEspecificacionOos());LOGGER.info("p1 pstrd:"+esp.getCodEspecificacionOos());
                        pst.setInt(2,0);LOGGER.info("p2 pstrd: 0");
                        pst.setString(3,esp.getDescripcionEspecificacion());LOGGER.info("p3 pstrd:"+esp.getDescripcionEspecificacion());
                        pst.setString(4,(esp.getFechaCumplimientoOos()!=null?sdf.format(esp.getFechaCumplimientoOos()):null));LOGGER.info("p4 pstrd: "+(esp.getFechaCumplimientoOos()!=null?sdf.format(esp.getFechaCumplimientoOos()):null));
                        if(pst.executeUpdate()>0)LOGGER.info("se registro el detalle");
                    }
                    else
                    {
                        for(SubEspecificacionesOOS subEsp:esp.getSubEspecificacionesOOSList())
                        {
                            pst.setInt(1,esp.getCodEspecificacionOos());LOGGER.info("p1 pstrd:"+esp.getCodEspecificacionOos());
                            pst.setInt(2,subEsp.getCodSubEspecificacionOOS());LOGGER.info("p2 pstrd:"+subEsp.getCodSubEspecificacionOOS());
                            pst.setString(3,subEsp.getDescripcionEspecificaciones());LOGGER.info("p3 pstrd:"+subEsp.getDescripcionEspecificaciones());
                            pst.setString(4,null);LOGGER.info("p4 pstrd:"+null);
                            if(pst.executeUpdate()>0)LOGGER.info("se registro el detalle");
                        }
                    }
                }
            }
            con.commit();
            mensaje="1";
            con.close();
        }
        catch(SQLException ex)
        {
            mensaje="Ocurrio un error al momento de registrar las descripciones,intente nuevo";
            con.rollback();
            con.close();
            ex.printStackTrace();
        }
        if(mensaje.equals("1")&&(codPermisoOOs==1))
        {
            EnvioCorreoRegistroOOS correo=new EnvioCorreoRegistroOOS(programaProduccionSeleccionado.getRegistroOOS().getCodRegistroOOS());
            correo.start();
        }
        return null;
    }
    public String getCargarRegistroOOSLote()
    {
        this.cargarPersonalSelectRegistro();
        ManagedAccesoSistema acceso=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
        try
        {
            con=Util.openConnection(con);
            StringBuilder consulta=new StringBuilder(" SELECT p.COD_ACCION_OOS");
                                     consulta.append(" from PERSONAL_REGISTRO_OOS p");
                                     consulta.append(" where p.COD_PERSONAL=").append(acceso.getUsuarioModuloBean().getCodUsuarioGlobal());
            LOGGER.debug("consulta verificar persmisos "+consulta.toString());
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta.toString());
            if(res.next())
            {
                codPermisoOOs=res.getInt("COD_ACCION_OOS");
            }
            
            consulta=new StringBuilder("select  isnull(max(cast((SUBSTRING(ro.CORRELATIVO_OOS,(LEN(ro.CORRELATIVO_OOS)-5),3)) as int) ),0)+1 as cod");
                            consulta.append(" from REGISTRO_OOS ro");
                                consulta.append(" inner join PROGRAMA_PRODUCCION pp on ro.COD_LOTE=pp.COD_LOTE_PRODUCCION AND pp.COD_PROGRAMA_PROD=ro.COD_PROGRAMA_PROD");
                                consulta.append(" inner join COMPONENTES_PROD cp on cp.COD_COMPPROD=pp.COD_COMPPROD ");
                                consulta.append(" inner join GESTIONES g on g.GESTION_ESTADO=1 and ro.FECHA_ENVIO_ASC BETWEEN g.FECHA_INI and g.FECHA_FIN");
                            consulta.append(" where cp.COD_AREA_EMPRESA=").append(programaProduccionSeleccionado.getFormulaMaestra().getComponentesProd().getAreasEmpresa().getCodAreaEmpresa());
            if(programaProduccionSeleccionado.getRegistroOOS().getCodRegistroOOS()==0&&(codPermisoOOs>0))
            {
                LOGGER.debug("consulta buscar correlativo "+consulta.toString());
                res=st.executeQuery(consulta.toString());
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
                consulta=new StringBuilder(" select SUBSTRING(g.ANIO_MENOR,(LEN(g.ANIO_MENOR)-1),2) as gestion");
                           consulta.append(" from GESTIONES g where g.GESTION_ESTADO=1");
                res=st.executeQuery(consulta.toString());
                if(res.next())
                {
                    codigo+="/"+res.getString("gestion");
                }
                programaProduccionSeleccionado.getRegistroOOS().setCorrelativoOOS("00S-"+programaProduccionSeleccionado.getFormulaMaestra().getComponentesProd().getAreasEmpresa().getAbreaviaturaDocumentacion()+"-"+codigo);
                consulta=new StringBuilder("select top 1 sppp.FECHA_FINAL,sppp.COD_PERSONAL");
                        consulta.append(" from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sppp");
                            consulta.append(" inner join ACTIVIDADES_FORMULA_MAESTRA afm on sppp.COD_ACTIVIDAD_PROGRAMA = afm.COD_ACTIVIDAD_FORMULA");
                                consulta.append(" and  afm.COD_FORMULA_MAESTRA = sppp.COD_FORMULA_MAESTRA");
                                consulta.append(" and afm.COD_ACTIVIDAD = 137");
                        consulta.append(" where sppp.COD_PROGRAMA_PROD =").append(programaProduccionSeleccionado.getCodProgramaProduccion());
                            consulta.append(" and sppp.COD_LOTE_PRODUCCION='").append(programaProduccionSeleccionado.getCodLoteProduccion()).append("'");
                        consulta.append(" ORDER BY  sppp.FECHA_FINAL DESC");
                LOGGER.debug("consulta buscar"+consulta.toString());
                res=st.executeQuery(consulta.toString());
                if(res.next())
                {
                    programaProduccionSeleccionado.getRegistroOOS().setFechaDeteccion(res.getTimestamp("FECHA_FINAL"));
                    programaProduccionSeleccionado.getRegistroOOS().getPersonalDetectaOOS().setCodPersonal(res.getString("COD_PERSONAL"));
                }
            }
            PreparedStatement pst=null;
            if(codPermisoOOs>0)
            {
                consulta=new StringBuilder("SELECT ro.COD_PERSONAL_DETECTA,ro.FECHA_DETECCION,ro.FECHA_ENVIO_ASC,ro.PROVEEDOR");
                        consulta.append(" FROM REGISTRO_OOS ro");
                        consulta.append(" where ro.COD_REGISTRO_OOS=").append(programaProduccionSeleccionado.getRegistroOOS().getCodRegistroOOS());
                LOGGER.debug("consula cabecera "+consulta.toString());
                res=st.executeQuery(consulta.toString());
                if(res.next())
                {
                    programaProduccionSeleccionado.getRegistroOOS().setFechaDeteccion(res.getTimestamp("FECHA_DETECCION")!=null?res.getTimestamp("FECHA_DETECCION"):new Date());
                    programaProduccionSeleccionado.getRegistroOOS().setFechaEnvioAsc(res.getTimestamp("FECHA_ENVIO_ASC")!=null?res.getTimestamp("FECHA_ENVIO_ASC"):new Date());
                    programaProduccionSeleccionado.getRegistroOOS().setProveedor(res.getString("PROVEEDOR"));
                    programaProduccionSeleccionado.getRegistroOOS().getPersonalDetectaOOS().setCodPersonal(res.getString("COD_PERSONAL_DETECTA"));
                }
                consulta=new StringBuilder("select eo.COD_ESPECIFICACION_OOS,eo.NOMBRE_ESPECIFICACION_OOS,seo.COD_SUB_ESPECIFICACION_OOS,");
                                consulta.append(" seo.NOMBRE_SUB_ESPECIFICACION_OOS,isnull(rod.DESCRIPCION,'') as DESCRIPCION");
                                consulta.append(" ,eo.FECHA_CUMPLIMIENTO as registrarFechaCumplimiento,rod.FECHA_CUMPLIMIENTO");
                            consulta.append(" from ESPECIFICACIONES_OOS eo");
                                consulta.append(" left outer join SUB_ESPECIFICACIONES_OOS seo on eo.COD_ESPECIFICACION_OOS=seo.COD_ESPECIFICACION_OOS");
                                consulta.append(" left outer join REGISTRO_OOS_DETALLE rod on rod.COD_ESPECIFICACION_OOS=eo.COD_ESPECIFICACION_OOS");
                                    consulta.append(" and rod.COD_SUB_ESPECIFICACION_OOS=isnull(seo.COD_SUB_ESPECIFICACION_OOS,0)");
                                    consulta.append(" and rod.COD_REGISTRO_OOS='").append(programaProduccionSeleccionado.getRegistroOOS().getCodRegistroOOS()).append("'");
                            consulta.append(" WHERE eo.COD_TIPO_ESPECIFICACION_OOS=?");
                            consulta.append(" order by eo.NRO_ORDEN,seo.NRO_ORDEN");
                pst=con.prepareStatement(consulta.toString());
                LOGGER.debug("consulta especificaciones investigacion "+consulta.toString()+"?=1");
                pst.setInt(1,1);
                res=pst.executeQuery();
                especificacionesOosInvestigacion.clear();
                List<SubEspecificacionesOOS> aux=new ArrayList<SubEspecificacionesOOS>();
                EspecificacionesOos nuevo=new EspecificacionesOos();
                while(res.next())
                {
                    if(nuevo.getCodEspecificacionOos()!=res.getInt("COD_ESPECIFICACION_OOS"))
                    {
                        if(nuevo.getCodEspecificacionOos()>0)
                        {
                            nuevo.setSubEspecificacionesOOSList((aux.size()>0?aux:null));
                            especificacionesOosInvestigacion.add(nuevo);
                        }
                        nuevo=new EspecificacionesOos();
                        aux=new ArrayList<SubEspecificacionesOOS>();
                        nuevo.setCodEspecificacionOos(res.getInt("COD_ESPECIFICACION_OOS"));
                        nuevo.setNombreEspecificacionOos(res.getString("NOMBRE_ESPECIFICACION_OOS"));
                        nuevo.setDescripcionEspecificacion(res.getString("DESCRIPCION"));
                        
                    }
                    if(res.getInt("COD_SUB_ESPECIFICACION_OOS")>0)
                    {
                        SubEspecificacionesOOS nuevoSub=new SubEspecificacionesOOS();
                        nuevoSub.setCodSubEspecificacionOOS(res.getInt("COD_SUB_ESPECIFICACION_OOS"));
                        nuevoSub.setNombreSubEspecificacionesOOS(res.getString("NOMBRE_SUB_ESPECIFICACION_OOS"));
                        nuevoSub.setDescripcionEspecificaciones(res.getString("DESCRIPCION"));
                        aux.add(nuevoSub);
                    }
                }
                if(nuevo.getCodEspecificacionOos()>0)
                {
                    nuevo.setSubEspecificacionesOOSList((aux.size()>0?aux:null));
                    especificacionesOosInvestigacion.add(nuevo);
                }
                LOGGER.debug("consulta especificaciones evaluacion "+consulta.toString()+"?=2");
                pst.setInt(1,2);
                res=pst.executeQuery();
                especificacionesOosEvaluacion.clear();
                aux=new ArrayList<SubEspecificacionesOOS>();
                nuevo=new EspecificacionesOos();
                while(res.next())
                {
                    if(nuevo.getCodEspecificacionOos()!=res.getInt("COD_ESPECIFICACION_OOS"))
                    {
                        if(nuevo.getCodEspecificacionOos()>0)
                        {
                            nuevo.setSubEspecificacionesOOSList((aux.size()>0?aux:null));
                            especificacionesOosEvaluacion.add(nuevo);
                        }
                        nuevo=new EspecificacionesOos();
                        aux=new ArrayList<SubEspecificacionesOOS>();
                        nuevo.setCodEspecificacionOos(res.getInt("COD_ESPECIFICACION_OOS"));
                        nuevo.setNombreEspecificacionOos(res.getString("NOMBRE_ESPECIFICACION_OOS"));
                        nuevo.setDescripcionEspecificacion(res.getString("DESCRIPCION"));
                        nuevo.setFechaCumplimiento(res.getInt("registrarFechaCumplimiento")>0);
                        nuevo.setFechaCumplimientoOos(res.getDate("FECHA_CUMPLIMIENTO"));
                    }
                    if(res.getInt("COD_SUB_ESPECIFICACION_OOS")>0)
                    {
                        SubEspecificacionesOOS nuevoSub=new SubEspecificacionesOOS();
                        nuevoSub.setCodSubEspecificacionOOS(res.getInt("COD_SUB_ESPECIFICACION_OOS"));
                        nuevoSub.setNombreSubEspecificacionesOOS(res.getString("NOMBRE_SUB_ESPECIFICACION_OOS"));
                        nuevoSub.setDescripcionEspecificaciones(res.getString("DESCRIPCION"));
                        aux.add(nuevoSub);
                    }
                }
                if(nuevo.getCodEspecificacionOos()>0)
                {
                    nuevo.setSubEspecificacionesOOSList((aux.size()>0?aux:null));
                    especificacionesOosEvaluacion.add(nuevo);
                }
                LOGGER.debug("consulta especificaciones laboratorio"+consulta.toString()+"?=3");
                pst.setInt(1, 3);
                res=pst.executeQuery();
                especificacionesOosLaboratorio.clear();
                aux=new ArrayList<SubEspecificacionesOOS>();
                nuevo=new EspecificacionesOos();
                while(res.next())
                {
                    if(nuevo.getCodEspecificacionOos()!=res.getInt("COD_ESPECIFICACION_OOS"))
                    {
                        if(nuevo.getCodEspecificacionOos()>0)
                        {
                            nuevo.setSubEspecificacionesOOSList((aux.size()>0?aux:null));
                            especificacionesOosLaboratorio.add(nuevo);
                        }
                        nuevo=new EspecificacionesOos();
                        aux=new ArrayList<SubEspecificacionesOOS>();
                        nuevo.setCodEspecificacionOos(res.getInt("COD_ESPECIFICACION_OOS"));
                        nuevo.setNombreEspecificacionOos(res.getString("NOMBRE_ESPECIFICACION_OOS"));
                        nuevo.setDescripcionEspecificacion(res.getString("DESCRIPCION"));
                        nuevo.setFechaCumplimiento(res.getInt("registrarFechaCumplimiento")>0);
                        nuevo.setFechaCumplimientoOos(res.getDate("FECHA_CUMPLIMIENTO"));
                    }
                    if(res.getInt("COD_SUB_ESPECIFICACION_OOS")>0)
                    {
                        SubEspecificacionesOOS nuevoSub=new SubEspecificacionesOOS();
                        nuevoSub.setCodSubEspecificacionOOS(res.getInt("COD_SUB_ESPECIFICACION_OOS"));
                        nuevoSub.setNombreSubEspecificacionesOOS(res.getString("NOMBRE_SUB_ESPECIFICACION_OOS"));
                        nuevoSub.setDescripcionEspecificaciones(res.getString("DESCRIPCION"));
                        aux.add(nuevoSub);
                    }
                }
                if(nuevo.getCodEspecificacionOos()>0)
                {
                    nuevo.setSubEspecificacionesOOSList((aux.size()>0?aux:null));
                    especificacionesOosLaboratorio.add(nuevo);
                }
            }
            if(codPermisoOOs>1)
            {
                LOGGER.debug("consulta cargar especificaciones oos Produccion "+consulta.toString()+"?=4");
                pst.setInt(1, 4);
                res=pst.executeQuery();
                especificacionesOosProduccion.clear();
                List<SubEspecificacionesOOS> aux=new ArrayList<SubEspecificacionesOOS>();
                EspecificacionesOos nuevo=new EspecificacionesOos();
                while(res.next())
                {
                    if(nuevo.getCodEspecificacionOos()!=res.getInt("COD_ESPECIFICACION_OOS"))
                    {
                        if(nuevo.getCodEspecificacionOos()>0)
                        {
                            nuevo.setSubEspecificacionesOOSList((aux.size()>0?aux:null));
                            especificacionesOosProduccion.add(nuevo);
                        }
                        nuevo=new EspecificacionesOos();
                        aux=new ArrayList<SubEspecificacionesOOS>();
                        nuevo.setCodEspecificacionOos(res.getInt("COD_ESPECIFICACION_OOS"));
                        nuevo.setNombreEspecificacionOos(res.getString("NOMBRE_ESPECIFICACION_OOS"));
                        nuevo.setDescripcionEspecificacion(res.getString("DESCRIPCION"));
                        nuevo.setFechaCumplimiento(res.getInt("registrarFechaCumplimiento")>0);
                        nuevo.setFechaCumplimientoOos(res.getDate("FECHA_CUMPLIMIENTO"));
                    }
                    if(res.getInt("COD_SUB_ESPECIFICACION_OOS")>0)
                    {
                        SubEspecificacionesOOS nuevoSub=new SubEspecificacionesOOS();
                        nuevoSub.setCodSubEspecificacionOOS(res.getInt("COD_SUB_ESPECIFICACION_OOS"));
                        nuevoSub.setNombreSubEspecificacionesOOS(res.getString("NOMBRE_SUB_ESPECIFICACION_OOS"));
                        nuevoSub.setDescripcionEspecificaciones(res.getString("DESCRIPCION"));
                        aux.add(nuevoSub);
                    }
                }
                if(nuevo.getCodEspecificacionOos()>0)
                {
                    nuevo.setSubEspecificacionesOOSList((aux.size()>0?aux:null));
                    especificacionesOosProduccion.add(nuevo);
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
        return null;
    }
    public String masSubEspecificaciones_action()
    {
        SubEspecificacionesOOS nuevo= new SubEspecificacionesOOS();
        nuevo.setNroOrden(subEspecificacionesOOSList.size()>0?(subEspecificacionesOOSList.get(subEspecificacionesOOSList.size()-1).getNroOrden()+1):1);
        subEspecificacionesOOSList.add(nuevo);
        return null;
    }
    public String menosSubEspecificaciones_action()
    {
        List<SubEspecificacionesOOS> aux=new ArrayList<SubEspecificacionesOOS>();
        for(SubEspecificacionesOOS bean:subEspecificacionesOOSList)
        {
            if(!bean.getChecked())
            {
                SubEspecificacionesOOS nuevo= new SubEspecificacionesOOS();
                nuevo.setNombreSubEspecificacionesOOS(bean.getNombreSubEspecificacionesOOS());
                nuevo.setNroOrden(bean.getNroOrden());
                nuevo.getEstadoRegistro().setCodEstadoRegistro(bean.getEstadoRegistro().getCodEstadoRegistro());
                aux.add(nuevo);
            }
        }
        subEspecificacionesOOSList.clear();
        subEspecificacionesOOSList=aux;
        return null;
    }
    public String guardarSubEspecificacionesOOs_action()throws SQLException
    {
        mensaje="";
        try
        {
            con=Util.openConnection(con);
            con.setAutoCommit(false);
            String consulta="DELETE SUB_ESPECIFICACIONES_OOS where COD_ESPECIFICACION_OOS='"+especificacionesOosRegistrar.getCodEspecificacionOos()+"'";
            LOGGER.debug("consulta delete sub especificaciones "+consulta);
            PreparedStatement pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)LOGGER.info("se eliminaron anteriores registros");
            int cont=0;
            for(SubEspecificacionesOOS bean:subEspecificacionesOOSList)
            {cont++;
                consulta="INSERT INTO SUB_ESPECIFICACIONES_OOS(COD_ESPECIFICACION_OOS,"+
                         " COD_SUB_ESPECIFICACION_OOS, NOMBRE_SUB_ESPECIFICACION_OOS, NRO_ORDEN,COD_ESTADO_REGISTRO)"+
                         " VALUES ('"+especificacionesOosRegistrar.getCodEspecificacionOos()+"','"+cont+"',"+
                         " '"+bean.getNombreSubEspecificacionesOOS()+"','"+bean.getNroOrden()+"','"+bean.getEstadoRegistro().getCodEstadoRegistro()+"')";
                LOGGER.debug("consulta insert sub especificacion "+consulta);
                pst=con.prepareStatement(consulta);
                if(pst.executeUpdate()>0)LOGGER.info("Se registro el detalle");
            }
            con.commit();
            mensaje="1";
            pst.close();
            con.close();
        }
        catch(SQLException ex)
        {
            mensaje="Ocurrio un error al momento de registrar las subespecificaciones,intente de nuevo";
            con.rollback();
            con.close();
            ex.printStackTrace();
        }
        return null;
        
    }
    public String getCargarSubEspecificacionesOOSPagina()
    {
        this.cargarSubEspecificacionesOOS();
        return null;
    }
    private void cargarSubEspecificacionesOOS()
    {
        try
        {
            con=Util.openConnection(con);
            String consulta="select seo.COD_SUB_ESPECIFICACION_OOS,seo.NOMBRE_SUB_ESPECIFICACION_OOS,"+
                            " seo.NRO_ORDEN,er.COD_ESTADO_REGISTRO,er.NOMBRE_ESTADO_REGISTRO"+
                            " from SUB_ESPECIFICACIONES_OOS seo inner join ESTADOS_REFERENCIALES er"+
                            " on er.COD_ESTADO_REGISTRO=seo.COD_ESTADO_REGISTRO " +
                            " where seo.COD_ESPECIFICACION_OOS='"+especificacionesOosRegistrar.getCodEspecificacionOos()+"'"+
                            " order by seo.NRO_ORDEN";
            LOGGER.debug("consulta cargar sub especificaciones "+consulta);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta);
            subEspecificacionesOOSList.clear();
            while(res.next())
            {
                SubEspecificacionesOOS nuevo=new SubEspecificacionesOOS();
                nuevo.setCodSubEspecificacionOOS(res.getInt("COD_SUB_ESPECIFICACION_OOS"));
                nuevo.setNombreSubEspecificacionesOOS(res.getString("NOMBRE_SUB_ESPECIFICACION_OOS"));
                nuevo.setNroOrden(res.getInt("NRO_ORDEN"));
                nuevo.getEstadoRegistro().setCodEstadoRegistro(res.getString("COD_ESTADO_REGISTRO"));
                nuevo.getEstadoRegistro().setNombreEstadoRegistro(res.getString("NOMBRE_ESTADO_REGISTRO"));
                subEspecificacionesOOSList.add(nuevo);

            }
            res.close();
            con.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
    }
    public String cargarSubEspecificacionesOOS_action()
    {
        especificacionesOosRegistrar=(EspecificacionesOos)especificacionesOOSDataTable.getRowData();
        
        return null;
    }
    public String cargarAgregarEspecificacionOos_action()
    {
        int nroPaso=0;
        try
        {
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select isnull(max(eo.NRO_ORDEN),0)+1 as nroOrden from ESPECIFICACIONES_OOS eo" +
                            " where eo.COD_TIPO_ESPECIFICACION_OOS='"+codTipoEspecificacionOosFiltro+"'";
            ResultSet res=st.executeQuery(consulta);
            if(res.next())
            {
                nroPaso=res.getInt("nroOrden");
            }
            res.close();
            st.close();
            con.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
        especificacionesOosRegistrar=new EspecificacionesOos();
        especificacionesOosRegistrar.setNroOrden(nroPaso);
        return null;
    }
    public String editarEspecificacionesOos_action()
    {
        for(EspecificacionesOos bean:especificacionesOosList)
        {
            if(bean.getChecked())
            {
                especificacionesOosRegistrar=bean;
            }
        }
        return null;
    }
    public String guardarNuevaEspecificacionOos_action()throws SQLException
    {
        mensaje="";
        try
        {
            con=Util.openConnection(con);
            con.setAutoCommit(false);
            String consulta="select isnull(max(eo.COD_ESPECIFICACION_OOS),0)+1 as codEspecificacion from ESPECIFICACIONES_OOS eo ";
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta);
            int codEspecificacion=0;
            if(res.next())
            {
                codEspecificacion=res.getInt("codEspecificacion");
            }
            consulta="INSERT INTO ESPECIFICACIONES_OOS(COD_ESPECIFICACION_OOS,NOMBRE_ESPECIFICACION_OOS, COD_ESTADO_REGISTRO, COD_TIPO_ESPECIFICACION_OOS,NRO_ORDEN,FECHA_CUMPLIMIENTO)"+
                     " VALUES ('"+codEspecificacion+"','"+especificacionesOosRegistrar.getNombreEspecificacionOos()+"',"+
                     " 1,'"+especificacionesOosRegistrar.getTiposEspecificacionesOos().getCodTipoEspecificacionOos()+"'" +
                     ",'"+especificacionesOosRegistrar.getNroOrden()+"','"+(especificacionesOosRegistrar.isFechaCumplimiento()?"1":"0")+"')";
            LOGGER.debug("consulta registrar especificacion oos "+consulta);
            PreparedStatement pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)LOGGER.info("se registro la especificacion oos");
            con.commit();
            mensaje="1";
            st.close();
            con.close();
        }
        catch(SQLException ex)
        {
            mensaje="Ocurrio un error al momento de registrar las especificacion Oos, intente de nuevo";
            con.rollback();
            con.close();
            ex.printStackTrace();
        }
        catch(Exception e)
        {
            mensaje="Ocurrio un error al momento de registrar las especificacion Oos, intente de nuevo";
            con.rollback();
            con.close();
            e.printStackTrace();
        }
        if(mensaje.equals("1"))
        {
            this.cargarEspecificacionesOos();
        }
        return null;
    }
    public String eliminarEspecifiacionOos_action()throws SQLException
    {
        mensaje="";
        for(EspecificacionesOos bean:especificacionesOosList)
        {
            if(bean.getChecked())
            {
                try
                {
                    con=Util.openConnection(con);
                    con.setAutoCommit(false);
                    String consulta="delete ESPECIFICACIONES_OOS where COD_ESPECIFICACION_OOS='"+bean.getCodEspecificacionOos()+"'";
                    LOGGER.debug("consulta delete especificacion oos "+consulta);
                    PreparedStatement pst=con.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)LOGGER.info("se elimino la especificacion de oos");
                    con.commit();
                    mensaje="1";
                    pst.close();
                    con.close();
                }
                catch(SQLException ex)
                {
                    mensaje="Ocurrio un error al momento de eliminar la especificacion, intente de nuevo";
                    con.rollback();
                    con.close();
                    ex.printStackTrace();
                }
            }
        }
        if(mensaje.equals("1"))
        {
            this.cargarEspecificacionesOos();
        }
        return null;
    }
    public String guardarEditarEspecificacionOos_action()throws SQLException
    {
        mensaje="";
        try
        {
            con=Util.openConnection(con);
            con.setAutoCommit(false);
            String consulta=" UPDATE ESPECIFICACIONES_OOS SET NOMBRE_ESPECIFICACION_OOS ='"+especificacionesOosRegistrar.getNombreEspecificacionOos()+"',"+
                            " COD_ESTADO_REGISTRO = '"+especificacionesOosRegistrar.getEstadoRegistro().getCodEstadoRegistro()+"',"+
                            " COD_TIPO_ESPECIFICACION_OOS = '"+especificacionesOosRegistrar.getTiposEspecificacionesOos().getCodTipoEspecificacionOos()+"'" +
                            " ,NRO_ORDEN='"+especificacionesOosRegistrar.getNroOrden()+"'"+
                            " ,FECHA_CUMPLIMIENTO='"+(especificacionesOosRegistrar.isFechaCumplimiento()?"1":"0")+"'"+
                            " WHERE COD_ESPECIFICACION_OOS = '"+especificacionesOosRegistrar.getCodEspecificacionOos()+"'";
            LOGGER.debug("consulta update especificacion oos "+consulta);
            PreparedStatement pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)LOGGER.info("se guardo la edicion d la  especificacion");
            con.commit();
            mensaje="1";
            pst.close();
            con.close();
        }
        catch(SQLException ex)
        {
            mensaje="Ocurrio un error al momento de guardar la edicion,intente de nuevo";
            con.rollback();
            con.close();
            ex.printStackTrace();
        }
        catch(Exception e)
        {
            mensaje="Ocurrio un error al momento de guardar la edicion,intente de nuevo";
            con.rollback();
            con.close();
            e.printStackTrace();
        }
        if(mensaje.equals("1"))
        {
            this.cargarEspecificacionesOos();
        }
        return null;
    }
    public String cargarAgregarSubEspecificacionOOS_action()
    {
        subEspecificacionesOOSRegistrar=new SubEspecificacionesOOS();
        subEspecificacionesOOSRegistrar.setNroOrden(subEspecificacionesOOSList.size()>0?(subEspecificacionesOOSList.size()+1):1);
        return null;
    }
    public String editarSubEspecificacionesOOS_action()
    {
        for(SubEspecificacionesOOS bean:subEspecificacionesOOSList)
        {
            if(bean.getChecked())
            {
                subEspecificacionesOOSRegistrar=bean;
            }
        }
        return null;
    }
    public String guardarNuevaSubEspecificacionOOS_action()throws SQLException
    {
        mensaje="";
        try
        {
            con=Util.openConnection(con);
            con.setAutoCommit(false);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select isnull(max(s.COD_SUB_ESPECIFICACION_OOS),0)+1 as codSubEspecificacion from SUB_ESPECIFICACIONES_OOS s " +
                            " where s.COD_ESPECIFICACION_OOS='"+especificacionesOosRegistrar.getCodEspecificacionOos()+"'";
            ResultSet res=st.executeQuery(consulta);
            int codSubEspecificacion=0;
            if(res.next())
            {
                codSubEspecificacion=res.getInt("codSubEspecificacion");
            }
            consulta="INSERT INTO SUB_ESPECIFICACIONES_OOS(COD_ESPECIFICACION_OOS,"+
                    " COD_SUB_ESPECIFICACION_OOS, NOMBRE_SUB_ESPECIFICACION_OOS, NRO_ORDEN,COD_ESTADO_REGISTRO)"+
                    " VALUES ('"+especificacionesOosRegistrar.getCodEspecificacionOos()+"','"+codSubEspecificacion+"',"+
                    "'"+subEspecificacionesOOSRegistrar.getNombreSubEspecificacionesOOS()+"','"+subEspecificacionesOOSRegistrar.getNroOrden()+"'," +
                    "1)";
            LOGGER.debug("consulta insert nueva sub especificacion  "+consulta);
            PreparedStatement pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)LOGGER.info("se registro la nueva subespecificacion");
            con.commit();
            mensaje="1";
            pst.close();
            st.close();
            con.close();
        }
        catch(SQLException ex)
        {
            mensaje="Ocurrio un error al momento de registrar la SubEspecificacion,intente de nuevo";
            con.rollback();
            con.close();
            ex.printStackTrace();
        }
        if(mensaje.equals("1"))
        {
            this.cargarSubEspecificacionesOOS();
        }
        return null;
    }
    public String guardarEdicionSubEspecificaciones_action()throws SQLException
    {
        mensaje="";
        try
        {
            con=Util.openConnection(con);
            con.setAutoCommit(false);
            String consulta=" UPDATE SUB_ESPECIFICACIONES_OOS SET NOMBRE_SUB_ESPECIFICACION_OOS = '"+subEspecificacionesOOSRegistrar.getNombreSubEspecificacionesOOS()+"',"+
                            " NRO_ORDEN = '"+subEspecificacionesOOSRegistrar.getNroOrden()+"',"+
                            " COD_ESTADO_REGISTRO = '"+subEspecificacionesOOSRegistrar.getEstadoRegistro().getCodEstadoRegistro()+"'"+
                            " WHERE COD_ESPECIFICACION_OOS = '"+especificacionesOosRegistrar.getCodEspecificacionOos()+"' and"+
                            " COD_SUB_ESPECIFICACION_OOS = '"+subEspecificacionesOOSRegistrar.getCodSubEspecificacionOOS()+"'";
            LOGGER.debug("consulta guardar EdicionSub especificacion "+consulta);
            PreparedStatement pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)LOGGER.info("se guardo la edicion de la sub especificacion");
            con.commit();
            mensaje="1";
            con.close();
        }
        catch(SQLException ex)
        {
            mensaje="Ocurrio un error al momento de guardar la edicion de la sub especificacion, intente de nuevo";
            con.rollback();
            con.close();
            ex.printStackTrace();
        }
        if(mensaje.equals("1"))
        {
            this.cargarSubEspecificacionesOOS();
        }
        return null;

    }
    public String eliminarSubEspecificacionOOS_action()throws SQLException
    {
        mensaje="";
        for(SubEspecificacionesOOS bean:subEspecificacionesOOSList)
        {
            if(bean.getChecked())
            {
                try
                {
                    con=Util.openConnection(con);
                    con.setAutoCommit(false);
                    String consulta="delete SUB_ESPECIFICACIONES_OOS where COD_ESPECIFICACION_OOS='"+especificacionesOosRegistrar.getCodEspecificacionOos()+"'" +
                            " and COD_SUB_ESPECIFICACION_OOS='"+bean.getCodSubEspecificacionOOS()+"'";
                    LOGGER.debug("consulta delete sub especificaciones "+consulta);
                    PreparedStatement pst= con.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)LOGGER.info("se elimino la especificacion oos");
                    con.commit();
                    mensaje="1";
                    pst.close();
                    con.close();
                }
                catch(SQLException ex)
                {
                    con.rollback();
                    con.close();
                    mensaje="Ocurrio un error al momento de eliminar la sub especificacion, intente de nuevo";
                    ex.printStackTrace();
                }
            }
        }
        if(mensaje.equals("1"))
        {
            this.cargarSubEspecificacionesOOS();
        }
        return null;
    }
    public String getCargarEspecificacionesOos()
    {
        this.cargarEspecificacionesOos();
        this.cargarTiposEspecificacionesOos();
        return null;
    }
    private void cargarTiposEspecificacionesOos()
    {
        try
        {
            con=Util.openConnection(con);
            String consulta="select teo.COD_TIPO_ESPECIFICACION_OOS,teo.NOMBRE_TIPO_ESPECIFICACION_OOS from  TIPOS_ESPECIFICACIONES_OOS teo"+
                            " where teo.COD_ESTADO_REGISTRO=1 order by teo.NOMBRE_TIPO_ESPECIFICACION_OOS";
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta);
            tiposEspecificacionesOosSelectList.clear();
            while(res.next())
            {
                tiposEspecificacionesOosSelectList.add(new SelectItem(res.getInt("COD_TIPO_ESPECIFICACION_OOS"),res.getString("NOMBRE_TIPO_ESPECIFICACION_OOS")));
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
    public String codTipoEspecificacion_change()
    {
        this.cargarEspecificacionesOos();
        return null;
    }
    private void cargarEspecificacionesOos()
    {
        try
        {
            con=Util.openConnection(con);
            Statement st =con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select eo.COD_ESPECIFICACION_OOS,eo.NOMBRE_ESPECIFICACION_OOS,teo.NOMBRE_TIPO_ESPECIFICACION_OOS,"+
                            " teo.COD_TIPO_ESPECIFICACION_OOS,er.COD_ESTADO_REGISTRO,er.NOMBRE_ESTADO_REGISTRO" +
                            " ,ISNULL(seo.COD_SUB_ESPECIFICACION_OOS,0) as COD_SUB_ESPECIFICACION_OOS,"+
                            " seo.NOMBRE_SUB_ESPECIFICACION_OOS,er1.NOMBRE_ESTADO_REGISTRO as EstadoRegistroSub,seo.NRO_ORDEN" +
                            " ,EO.NRO_ORDEN as nroOrdenPrincipal,eo.FECHA_CUMPLIMIENTO"+
                            " from ESPECIFICACIONES_OOS eo inner join TIPOS_ESPECIFICACIONES_OOS teo"+
                            " on eo.COD_TIPO_ESPECIFICACION_OOS=teo.COD_TIPO_ESPECIFICACION_OOS"+
                            " inner join ESTADOS_REFERENCIALES er on er.COD_ESTADO_REGISTRO=eo.COD_ESTADO_REGISTRO" +
                            " left outer join SUB_ESPECIFICACIONES_OOS seo on seo.COD_ESPECIFICACION_OOS=eo.COD_ESPECIFICACION_OOS"+
                            " left outer join ESTADOS_REFERENCIALES er1 on er1.COD_ESTADO_REGISTRO=seo.COD_ESTADO_REGISTRO"+
                            (codTipoEspecificacionOosFiltro>0?" where eo.COD_TIPO_ESPECIFICACION_OOS='"+codTipoEspecificacionOosFiltro+"'":"")+
                            " order by teo.NOMBRE_TIPO_ESPECIFICACION_OOS,eo.NRO_ORDEN,seo.NRO_ORDEN";
            LOGGER.debug("consulta cargar especificaciones OOs "+consulta);
            ResultSet res=st.executeQuery(consulta);
            especificacionesOosList.clear();
            EspecificacionesOos nuevo=new EspecificacionesOos();
            List<SubEspecificacionesOOS> aux=new ArrayList<SubEspecificacionesOOS>();
            while(res.next())
            {
                if(nuevo.getCodEspecificacionOos()!=res.getInt("COD_ESPECIFICACION_OOS"))
                {
                    if(nuevo.getCodEspecificacionOos()>0)
                    {
                        nuevo.setSubEspecificacionesOOSList(aux);
                        especificacionesOosList.add(nuevo);
                    }
                    aux=new ArrayList<SubEspecificacionesOOS>();
                    nuevo=new EspecificacionesOos();
                    nuevo.setCodEspecificacionOos(res.getInt("COD_ESPECIFICACION_OOS"));
                    nuevo.setNombreEspecificacionOos(res.getString("NOMBRE_ESPECIFICACION_OOS"));
                    nuevo.getTiposEspecificacionesOos().setCodTipoEspecificacionOos(res.getInt("COD_TIPO_ESPECIFICACION_OOS"));
                    nuevo.getTiposEspecificacionesOos().setNombreTipoEspecificacionOos(res.getString("NOMBRE_TIPO_ESPECIFICACION_OOS"));
                    nuevo.getEstadoRegistro().setCodEstadoRegistro(res.getString("COD_ESTADO_REGISTRO"));
                    nuevo.getEstadoRegistro().setNombreEstadoRegistro(res.getString("NOMBRE_ESTADO_REGISTRO"));
                    nuevo.setNroOrden(res.getInt("nroOrdenPrincipal"));
                    nuevo.setFechaCumplimiento(res.getInt("FECHA_CUMPLIMIENTO")>0);
                }
                SubEspecificacionesOOS nuevoSub=new SubEspecificacionesOOS();
                nuevoSub.setNombreSubEspecificacionesOOS(res.getString("NOMBRE_SUB_ESPECIFICACION_OOS"));
                nuevoSub.setNroOrden(res.getInt("NRO_ORDEN"));
                nuevoSub.getEstadoRegistro().setNombreEstadoRegistro(res.getString("EstadoRegistroSub"));
                nuevoSub.setCodSubEspecificacionOOS(res.getInt("COD_SUB_ESPECIFICACION_OOS"));
                aux.add(nuevoSub);
                
            }
            if(nuevo.getCodEspecificacionOos()>0)
            {
                nuevo.setSubEspecificacionesOOSList(aux);
                especificacionesOosList.add(nuevo);
            }
            st.close();
            con.close();

        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
    }
    public String seleccionarProgramaProduccionPeriodo_action()
    {
        programaProduccionPeriodoSeleccionado=(ProgramaProduccionPeriodo)programaProduccionPeriodoDataTable.getRowData();
        return null;
    }
    private void cargarTiposProgramaProduccionAreasEmpresaEstados()
    {
        try
        {
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select tpp.COD_TIPO_PROGRAMA_PROD,tpp.NOMBRE_TIPO_PROGRAMA_PROD"+
                             " from TIPOS_PROGRAMA_PRODUCCION tpp where tpp.COD_ESTADO_REGISTRO=1 order by tpp.NOMBRE_TIPO_PROGRAMA_PROD";
            LOGGER.debug("consult car tipo prog pord "+consulta);
            ResultSet res=st.executeQuery(consulta);
            tiposProgrProdSelectList.clear();
            tiposProgrProdSelectList.add(new SelectItem("0","--Todos--"));
            while(res.next())
            {
                tiposProgrProdSelectList.add(new SelectItem(res.getString("COD_TIPO_PROGRAMA_PROD"),res.getString("NOMBRE_TIPO_PROGRAMA_PROD")));
            }
            consulta="select ae.COD_AREA_EMPRESA,ae.NOMBRE_AREA_EMPRESA "+
                     " from AREAS_EMPRESA ae where ae.COD_AREA_EMPRESA in (80,81,82,95) order by ae.NOMBRE_AREA_EMPRESA";
            areasEmpresaSelectList.clear();
            areasEmpresaSelectList.add(new SelectItem("0","--Todos--"));
            res=st.executeQuery(consulta);
            while(res.next())
            {
                areasEmpresaSelectList.add(new SelectItem(res.getString("COD_AREA_EMPRESA"),res.getString("NOMBRE_AREA_EMPRESA")));
            }
            
            consulta="select epp.COD_ESTADO_PROGRAMA_PROD,epp.NOMBRE_ESTADO_PROGRAMA_PROD"+
                     " from ESTADOS_PROGRAMA_PRODUCCION epp where epp.COD_ESTADO_PROGRAMA_PROD in (2, 5, 6, 7) order by epp.NOMBRE_ESTADO_PROGRAMA_PROD";
            res=st.executeQuery(consulta);
            estadosProgramaProdSelectList.clear();
            estadosProgramaProdSelectList.add(new SelectItem("0","--Todos--"));
            while(res.next())
            {
                estadosProgramaProdSelectList.add(new SelectItem(res.getString("COD_ESTADO_PROGRAMA_PROD"),res.getString("NOMBRE_ESTADO_PROGRAMA_PROD")));
            }
            areasEmpresa_change();
            st.close();
            con.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
    }
    public String areasEmpresa_change()
    {
        try
        {
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select cp.COD_COMPPROD,cp.nombre_prod_semiterminado"+
                            " from COMPONENTES_PROD cp where cp.COD_TIPO_PRODUCCION=1"+
                            ((seguimientoProgramaProduccionPersonalBuscar.getSeguimientoProgramaProduccion().getProgramaProduccion().getFormulaMaestra().getComponentesProd().getAreasEmpresa().getCodAreaEmpresa().equals("0")
                            ||seguimientoProgramaProduccionPersonalBuscar.getSeguimientoProgramaProduccion().getProgramaProduccion().getFormulaMaestra().getComponentesProd().getAreasEmpresa().getCodAreaEmpresa().equals(""))?"":
                            " and cp.COD_AREA_EMPRESA ='"+seguimientoProgramaProduccionPersonalBuscar.getSeguimientoProgramaProduccion().getProgramaProduccion().getFormulaMaestra().getComponentesProd().getAreasEmpresa().getCodAreaEmpresa()+"'")+
                            " order by cp.nombre_prod_semiterminado";
            LOGGER.debug("consulta cargar componentes prod "+consulta);
            ResultSet res=st.executeQuery(consulta);
            componentesProdSelectList.clear();
            componentesProdSelectList.add(new SelectItem("0","--Todos--"));
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
        return null;
    }
    public String getCargarContenidoProgramaProduccionPeriodo(){
        this.cargarTiposProgramaProduccionAreasEmpresaEstados();
        try {
            con = Util.openConnection(con);
            Statement st = con.createStatement();
            String consulta = " select ppp.COD_PROGRAMA_PROD,ppp.NOMBRE_PROGRAMA_PROD,ppp.OBSERVACIONES"+
                                        " ,epp.NOMBRE_ESTADO_PROGRAMA_PROD"+
                                " from PROGRAMA_PRODUCCION_PERIODO ppp inner join ESTADOS_PROGRAMA_PRODUCCION epp"+
                                        " on epp.COD_ESTADO_PROGRAMA_PROD=ppp.COD_ESTADO_PROGRAMA"+
                                " where ppp.COD_ESTADO_PROGRAMA<>4"+
                                        " AND ppp.COD_TIPO_PRODUCCION=1 "+
                                "order by ppp.COD_PROGRAMA_PROD desc";
            LOGGER.debug("consula cargar programa os "+consulta);
            ResultSet res = st.executeQuery(consulta);
            programaProduccionPeriodoList.clear();
            programaProduccionSelectList.clear();
            while(res.next()){
                programaProduccionSelectList.add(new SelectItem(res.getString("COD_PROGRAMA_PROD"),res.getString("NOMBRE_PROGRAMA_PROD")));
                ProgramaProduccionPeriodo nuevo=new ProgramaProduccionPeriodo();
                nuevo.setCodProgramaProduccion(res.getString("COD_PROGRAMA_PROD"));
                nuevo.setNombreProgramaProduccion(res.getString("NOMBRE_PROGRAMA_PROD"));
                nuevo.setObsProgramaProduccion(res.getString("OBSERVACIONES"));
                nuevo.getEstadoProgramaProduccion().setNombreEstadoProgramaProd(res.getString("NOMBRE_ESTADO_PROGRAMA_PROD"));
                programaProduccionPeriodoList.add(nuevo);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public double redondear( double numero, int decimales ) {
        return Math.round(numero*Math.pow(10,decimales))/Math.pow(10,decimales);
    }

    public String getCargarProgramaProduccion()
    {


        try {

            ManagedAccesoSistema accesoSistema = (ManagedAccesoSistema) Util.getSessionBean("ManagedAccesoSistema");
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            
            String consulta="select pp.cod_programa_prod,fm.cod_formula_maestra,pp.cod_lote_produccion,"+
                " pp.fecha_inicio,pp.fecha_final,pp.cod_estado_programa,pp.observacion,"+
                " cp.nombre_prod_semiterminado,cp.cod_compprod,fm.cantidad_lote,epp.NOMBRE_ESTADO_PROGRAMA_PROD,pp.cant_lote_produccion,tp.COD_TIPO_PROGRAMA_PROD,tp.NOMBRE_TIPO_PROGRAMA_PROD"+
                 " ,ISNULL((SELECT C.NOMBRE_CATEGORIACOMPPROD FROM CATEGORIAS_COMPPROD C WHERE C.COD_CATEGORIACOMPPROD=cp.COD_CATEGORIACOMPPROD),''),pp.MATERIAL_TRANSITO " +
                 " ,isnull(ae.NOMBRE_AREA_EMPRESA,'') as NOMBRE_AREA_EMPRESA,ISNULL(ae.ABREVIATURA_DOCUMENTACION,'') ABREVIATURA_DOCUMENTACION,cp.VIDA_UTIL,cp.COD_AREA_EMPRESA " +
                 " , (select top 1 ap.NOMBRE_ACTIVIDAD from SEGUIMIENTO_PROGRAMA_PRODUCCION s inner join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_ACTIVIDAD_FORMULA = s.COD_ACTIVIDAD_PROGRAMA " +
                 "  inner join ACTIVIDADES_PRODUCCION ap on ap.COD_ACTIVIDAD = afm.COD_ACTIVIDAD       " +
                 " where s.COD_PROGRAMA_PROD = pp.COD_PROGRAMA_PROD" +
                 "   and s.COD_COMPPROD = pp.COD_COMPPROD and s.COD_FORMULA_MAESTRA = pp.COD_FORMULA_MAESTRA and s.COD_LOTE_PRODUCCION = pp.COD_LOTE_PRODUCCION " +
                 "   and (s.HORAS_HOMBRE >0 or s.HORAS_MAQUINA >0) and s.COD_TIPO_PROGRAMA_PROD in( pp.COD_TIPO_PROGRAMA_PROD , 0) and ap.COD_TIPO_ACTIVIDAD_PRODUCCION = 1 " +
                 "   order by afm.COD_ACTIVIDAD_FORMULA  desc ) NOMBRE_ACTIVIDAD ,ppp.COD_PROGRAMA_PROD,ppp.NOMBRE_PROGRAMA_PROD" +
                 " ,isnull(ro.COD_REGISTRO_OOS,0) as COD_REGISTRO_OOS,isnull(ro.CORRELATIVO_OOS,'') as CORRELATIVO_OOS" +
                 " ,seguimiento.cantidadSeg"+
                 " from programa_produccion pp inner join FORMULA_MAESTRA fm on pp.COD_FORMULA_MAESTRA=fm.COD_FORMULA_MAESTRA"+
                 " inner join COMPONENTES_PROD cp on cp.COD_COMPPROD=fm.COD_COMPPROD"+
                 " inner join ESTADOS_PROGRAMA_PRODUCCION epp on epp.COD_ESTADO_PROGRAMA_PROD = pp.cod_estado_programa"+
                 " inner join TIPOS_PROGRAMA_PRODUCCION tp on tp.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD"+
                 " left outer join PROGRAMA_PRODUCCION_PERIODO ppp on ppp.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD"+
                 " left outer join REGISTRO_OOS ro on ro.COD_LOTE=pp.COD_LOTE_PRODUCCION and  pp.COD_PROGRAMA_PROD=ro.COD_PROGRAMA_PROD" +
                 " left outer join AREAS_EMPRESA ae on ae.COD_AREA_EMPRESA=cp.COD_AREA_EMPRESA" +
                 " outer apply(select COUNT(*) as cantidadSeg from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sppp inner join ACTIVIDADES_FORMULA_MAESTRA afm on "+
                 " sppp.COD_ACTIVIDAD_PROGRAMA=afm.COD_ACTIVIDAD_FORMULA and afm.COD_FORMULA_MAESTRA=sppp.COD_FORMULA_MAESTRA"+
                 " and afm.COD_ACTIVIDAD=137 where sppp.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD and sppp.COD_FORMULA_MAESTRA=pp.COD_FORMULA_MAESTRA"+
                 " and sppp.COD_COMPPROD=pp.COD_COMPPROD and sppp.COD_LOTE_PRODUCCION=pp.COD_LOTE_PRODUCCION"+
                 " and sppp.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD) seguimiento"+
                 " where pp.cod_estado_programa in (2,5,6,7)";
                 if(programaProduccionPeriodoSeleccionado.getCodProgramaProduccion().equals(""))
                 {
                     String codProgramasProduccion="";
                     for(String variable:codProgramaProduccion)
                     {
                         codProgramasProduccion+=(codProgramasProduccion.equals("")?"":",")+variable;
                     }
                     consulta+=(seguimientoProgramaProduccionPersonalBuscar.getSeguimientoProgramaProduccion().getProgramaProduccion().getCodLoteProduccion().equals("")?"":(" and pp.cod_lote_produccion='"+seguimientoProgramaProduccionPersonalBuscar.getSeguimientoProgramaProduccion().getProgramaProduccion().getCodLoteProduccion()+"'"))+
                             (codProgramasProduccion.equals("")?"":" and pp.cod_programa_prod in ("+codProgramasProduccion+")")+
                             (seguimientoProgramaProduccionPersonalBuscar.getSeguimientoProgramaProduccion().getProgramaProduccion().getFormulaMaestra().getComponentesProd().getAreasEmpresa().getCodAreaEmpresa().equals("0")?"":
                              " and cp.cod_area_empresa = "+seguimientoProgramaProduccionPersonalBuscar.getSeguimientoProgramaProduccion().getProgramaProduccion().getFormulaMaestra().getComponentesProd().getAreasEmpresa().getCodAreaEmpresa())+
                             (seguimientoProgramaProduccionPersonalBuscar.getSeguimientoProgramaProduccion().getProgramaProduccion().getFormulaMaestra().getComponentesProd().getCodCompprod().equals("0")?"":
                             " and cp.cod_compprod='"+seguimientoProgramaProduccionPersonalBuscar.getSeguimientoProgramaProduccion().getProgramaProduccion().getFormulaMaestra().getComponentesProd().getCodCompprod()+"'")+
                             (seguimientoProgramaProduccionPersonalBuscar.getSeguimientoProgramaProduccion().getProgramaProduccion().getTiposProgramaProduccion().getCodTipoProgramaProd().equals("0")?"":
                             " and  pp.COD_TIPO_PROGRAMA_PROD='"+seguimientoProgramaProduccionPersonalBuscar.getSeguimientoProgramaProduccion().getProgramaProduccion().getTiposProgramaProduccion().getCodTipoProgramaProd()+"'")+
                             (seguimientoProgramaProduccionPersonalBuscar.getSeguimientoProgramaProduccion().getProgramaProduccion().getEstadoProgramaProduccion().getCodEstadoProgramaProd().equals("0")?"":
                             " and pp.cod_estado_programa='"+seguimientoProgramaProduccionPersonalBuscar.getSeguimientoProgramaProduccion().getProgramaProduccion().getEstadoProgramaProduccion().getCodEstadoProgramaProd()+"'");

                 }
                 else
                 {
                    consulta+=" and pp.cod_programa_prod="+programaProduccionPeriodoSeleccionado.getCodProgramaProduccion();
                 }
                  
                if(estadoRegistroOOS>0)
                {
                    if(estadoRegistroOOS==1)
                    {
                       consulta+=" and seguimiento.cantidadSeg>1";
                    }
                    if(estadoRegistroOOS==2)
                    {
                        consulta+=" and COD_REGISTRO_OOS>0";
                    }
                }
                consulta+= "  order by ro.COD_REGISTRO_OOS ";

            LOGGER.debug("consulta programa produccion  :"+consulta);
            con=Util.openConnection(con);
            ResultSet res=st.executeQuery(consulta);
            programaProduccionList.clear();
            String cod="";
            while(res.next())
            {
                ProgramaProduccion bean=new ProgramaProduccion();
                bean.setChecked(res.getInt("cantidadSeg")>1);
                bean.getProgramaProduccionPeriodo().setCodProgramaProduccion(res.getString("COD_PROGRAMA_PROD"));
                bean.getProgramaProduccionPeriodo().setNombreProgramaProduccion(res.getString("NOMBRE_PROGRAMA_PROD"));
                bean.setCodProgramaProduccion(res.getString(1));
                bean.getFormulaMaestra().setCodFormulaMaestra(res.getString("cod_formula_maestra"));
                bean.setCodLoteProduccion(res.getString(3));
                bean.setCodLoteProduccionAnterior(res.getString(3));
                String fechaInicio="";
                String fechaFinal="";
                bean.setCodEstadoPrograma(res.getString(6));
                bean.setObservacion(res.getString(7));
                bean.getFormulaMaestra().getComponentesProd().setNombreProdSemiterminado(res.getString(8));
                bean.getFormulaMaestra().getComponentesProd().setCodCompprod(res.getString(9));
                double cantidad=res.getDouble(10);
                cantidad=redondear(cantidad,3);
                NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
                DecimalFormat form = (DecimalFormat)nf;
                form.applyPattern("#,#00.0#");
                bean.getFormulaMaestra().setCantidadLote(cantidad);
                bean.getEstadoProgramaProduccion().setNombreEstadoProgramaProd(res.getString(11) + "(" +(res.getString("NOMBRE_ACTIVIDAD")==null?"":res.getString("NOMBRE_ACTIVIDAD")) +  ")");
                cantidad=res.getDouble(12);
                cantidad=redondear(cantidad,3);
                //bean.getTiposProgramaProduccion().setCodTipoProgramaProd(rs.getString(13));
                bean.getTiposProgramaProduccion().setNombreProgramaProd(res.getString(14));
                bean.getCategoriasCompProd().setNombreCategoriaCompProd(res.getString(15));
                bean.setCantidadLote(cantidad);
                bean.getEstadoProgramaProduccion().setCodEstadoProgramaProd(res.getString("cod_estado_programa"));
                bean.getFormulaMaestra().getComponentesProd().getAreasEmpresa().setNombreAreaEmpresa(res.getString("NOMBRE_AREA_EMPRESA"));
                bean.getFormulaMaestra().getComponentesProd().getAreasEmpresa().setCodAreaEmpresa(res.getString("COD_AREA_EMPRESA"));
                bean.getFormulaMaestra().getComponentesProd().getAreasEmpresa().setAbreaviaturaDocumentacion(res.getString("ABREVIATURA_DOCUMENTACION"));
                bean.getTiposProgramaProduccion().setCodTipoProgramaProd(res.getString("COD_TIPO_PROGRAMA_PROD"));
                int materialTransito=res.getInt(16);
                if (materialTransito == 0) {

                    bean.setMaterialTransito("CON EXISTENCIA");
                    bean.setStyleClass("b");
                }
                if (materialTransito == 1) {

                    bean.setMaterialTransito("EN TRÁNSITO");
                    bean.setStyleClass("a");
                    //System.out.println("ENTRO TRANSITO:"+bean.getMaterialTransito());
                }
                bean.getFormulaMaestra().getComponentesProd().setVidaUtil(res.getInt("VIDA_UTIL"));
                bean.getRegistroOOS().setCorrelativoOOS(res.getString("CORRELATIVO_OOS"));
                bean.getRegistroOOS().setCodRegistroOOS(res.getInt("COD_REGISTRO_OOS"));
                programaProduccionList.add(bean);
               
            }
            res.close();
            st.close();
            con.close();

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return"";
    
    }

    public String seleccionarProgramaProduccion()
    {
        programaProduccionSeleccionado=(ProgramaProduccion)programaProduccionDataTable.getRowData();
        return null;
    }
    public String getCargarSeguimientoProgramaProduccionOS()
    {
        try
        {
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select ap.NOMBRE_ACTIVIDAD,spp.fecha_inicio,(p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRE_PILA+' '+p.nombre2_personal) as nombrePersonal,"+
                            " spp.COD_PERSONAL,isnull(spp.OS,-1) as OS,af.COD_ACTIVIDAD_FORMULA"+
                            " from ACTIVIDADES_FORMULA_MAESTRA af"+
                            " left outer join SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL spp on"+
                            " spp.COD_ACTIVIDAD_PROGRAMA = af.COD_ACTIVIDAD_FORMULA and"+
                           "  spp.COD_LOTE_PRODUCCION = '"+programaProduccionSeleccionado.getCodLoteProduccion()+"' " +
                           " and spp.COD_PROGRAMA_PROD = '"+programaProduccionSeleccionado.getCodProgramaProduccion()+"'" +
                           " and spp.COD_FORMULA_MAESTRA = af.COD_FORMULA_MAESTRA and " +
                           " spp.COD_TIPO_PROGRAMA_PROD='"+programaProduccionSeleccionado.getTiposProgramaProduccion().getCodTipoProgramaProd()+"'" +
                           " and spp.COD_COMPPROD='"+programaProduccionSeleccionado.getFormulaMaestra().getComponentesProd().getCodCompprod()+"'" +
                           " left outer join personal p on p.COD_PERSONAL=spp.COD_PERSONAL"+
                           " left outer join ACTIVIDADES_PRODUCCION ap on ap.COD_ACTIVIDAD=af.COD_ACTIVIDAD"+
                           "  where af.COD_ACTIVIDAD = 137  and af.COD_AREA_EMPRESA=40"+
                           " and af.COD_FORMULA_MAESTRA = '"+programaProduccionSeleccionado.getFormulaMaestra().getCodFormulaMaestra()+"'";
            LOGGER.debug("consulta cargar seguimiento programa OS "+consulta);
            ResultSet res =st.executeQuery(consulta);
            seguimientoProgramaProduccionPersonalOS.clear();
            while(res.next())
            {
               SeguimientoProgramaProduccionPersonal nuevo=new SeguimientoProgramaProduccionPersonal();
               nuevo.setFechaInicio(res.getTimestamp("fecha_inicio"));
               nuevo.getSeguimientoProgramaProduccion().getActividadesProduccion().setNombreActividad(res.getString("NOMBRE_ACTIVIDAD"));
               nuevo.getSeguimientoProgramaProduccion().getActividadesProduccion().setCodActividad(res.getInt("COD_ACTIVIDAD_FORMULA"));
               nuevo.getPersonal().setNombrePersonal(res.getString("nombrePersonal"));
               nuevo.getPersonal().setCodPersonal(res.getString("COD_PERSONAL"));
               //nuevo.setOs(res.getInt("OS"));
               seguimientoProgramaProduccionPersonalOS.add(nuevo);
            }
            st.close();
            con.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
        return "";
    }

    public String guardarOsSeguimientoProgramaProd()throws SQLException
    {
        mensaje="";
        try
        {
            con=Util.openConnection(con);
            PreparedStatement pst=null;
            con.setAutoCommit(false);
            String consulta="";
            SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
            /*for(SeguimientoProgramaProduccionPersonal bean:seguimientoProgramaProduccionPersonalOS)
            {
               consulta="UPDATE SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL SET   OS = '"+bean.getOs()+"'"+
                        " WHERE COD_COMPPROD = '"+programaProduccionSeleccionado.getFormulaMaestra().getComponentesProd().getCodCompprod()+"' and "+
                         " COD_PROGRAMA_PROD = '"+programaProduccionSeleccionado.getCodProgramaProduccion()+"' and "+
                        " COD_LOTE_PRODUCCION = '"+programaProduccionSeleccionado.getCodLoteProduccion()+"' and "+
                        " COD_FORMULA_MAESTRA = '"+programaProduccionSeleccionado.getFormulaMaestra().getCodFormulaMaestra()+"' and "+
                        " COD_ACTIVIDAD_PROGRAMA = '"+bean.getSeguimientoProgramaProduccion().getActividadesProduccion().getCodActividad()+"' and "+
                        " COD_TIPO_PROGRAMA_PROD = '"+programaProduccionSeleccionado.getTiposProgramaProduccion().getCodTipoProgramaProd()+"' and "+
                        " COD_PERSONAL = '"+bean.getPersonal().getCodPersonal()+"' and "+
                        " FECHA_INICIO='"+sdf.format(bean.getFechaInicio())+"'";
                LOGGER.debug("consulta update os "+consulta);
                pst=con.prepareStatement(consulta);
                if(pst.executeUpdate()>0)LOGGER.info("se actualizo el os");
                
            }*/
            con.commit();
            if(pst!=null)pst.close();
            mensaje="1";
            con.close();
        }
        catch(SQLException ex)
        {
            mensaje="Ocurrio un error al momento de registrar el os, intente de nuevo";
            con.rollback();
            con.close();
            ex.printStackTrace();
        }
        catch(Exception e)
        {
            mensaje="Ocurrio un error al momento de registrar el os, intente de nuevo";
            con.rollback();
            con.close();
            e.printStackTrace();
        }
        return null;
    }
    public String buscarLotesProgramaProduccion_action()
    {
        programaProduccionPeriodoSeleccionado.setCodProgramaProduccion("");
        return null;
    }

    public List<ProgramaProduccionPeriodo> getProgramaProduccionPeriodoList() {
        return programaProduccionPeriodoList;
    }

    public void setProgramaProduccionPeriodoList(List<ProgramaProduccionPeriodo> programaProduccionPeriodoList) {
        this.programaProduccionPeriodoList = programaProduccionPeriodoList;
    }

    public HtmlDataTable getProgramaProduccionPeriodoDataTable() {
        return programaProduccionPeriodoDataTable;
    }

    public void setProgramaProduccionPeriodoDataTable(HtmlDataTable programaProduccionPeriodoDataTable) {
        this.programaProduccionPeriodoDataTable = programaProduccionPeriodoDataTable;
    }

    public List<ProgramaProduccion> getProgramaProduccionList() {
        return programaProduccionList;
    }

    public void setProgramaProduccionList(List<ProgramaProduccion> programaProduccionList) {
        this.programaProduccionList = programaProduccionList;
    }

    public ProgramaProduccionPeriodo getProgramaProduccionPeriodoSeleccionado() {
        return programaProduccionPeriodoSeleccionado;
    }

    public void setProgramaProduccionPeriodoSeleccionado(ProgramaProduccionPeriodo programaProduccionPeriodoSeleccionado) {
        this.programaProduccionPeriodoSeleccionado = programaProduccionPeriodoSeleccionado;
    }

    public SeguimientoProgramaProduccionPersonal getSeguimientoProgramaProduccionPersonalBuscar() {
        return seguimientoProgramaProduccionPersonalBuscar;
    }

    public void setSeguimientoProgramaProduccionPersonalBuscar(SeguimientoProgramaProduccionPersonal seguimientoProgramaProduccionPersonalBuscar) {
        this.seguimientoProgramaProduccionPersonalBuscar = seguimientoProgramaProduccionPersonalBuscar;
    }

    public HtmlDataTable getProgramaProduccionDataTable() {
        return programaProduccionDataTable;
    }

    public void setProgramaProduccionDataTable(HtmlDataTable programaProduccionDataTable) {
        this.programaProduccionDataTable = programaProduccionDataTable;
    }

    public ProgramaProduccion getProgramaProduccionSeleccionado() {
        return programaProduccionSeleccionado;
    }

    public void setProgramaProduccionSeleccionado(ProgramaProduccion programaProduccionSeleccionado) {
        this.programaProduccionSeleccionado = programaProduccionSeleccionado;
    }

    public List<SeguimientoProgramaProduccionPersonal> getSeguimientoProgramaProduccionPersonalOS() {
        return seguimientoProgramaProduccionPersonalOS;
    }

    public void setSeguimientoProgramaProduccionPersonalOS(List<SeguimientoProgramaProduccionPersonal> seguimientoProgramaProduccionPersonalOS) {
        this.seguimientoProgramaProduccionPersonalOS = seguimientoProgramaProduccionPersonalOS;
    }

    public String getMensaje() {
        return mensaje;
    }

    public void setMensaje(String mensaje) {
        this.mensaje = mensaje;
    }

    public List<SelectItem> getAreasEmpresaSelectList() {
        return areasEmpresaSelectList;
    }

    public void setAreasEmpresaSelectList(List<SelectItem> areasEmpresaSelectList) {
        this.areasEmpresaSelectList = areasEmpresaSelectList;
    }

    public List<SelectItem> getComponentesProdSelectList() {
        return componentesProdSelectList;
    }

    public void setComponentesProdSelectList(List<SelectItem> componentesProdSelectList) {
        this.componentesProdSelectList = componentesProdSelectList;
    }

    public List<SelectItem> getEstadosProgramaProdSelectList() {
        return estadosProgramaProdSelectList;
    }

    public void setEstadosProgramaProdSelectList(List<SelectItem> estadosProgramaProdSelectList) {
        this.estadosProgramaProdSelectList = estadosProgramaProdSelectList;
    }

    public List<SelectItem> getTiposProgrProdSelectList() {
        return tiposProgrProdSelectList;
    }

    public void setTiposProgrProdSelectList(List<SelectItem> tiposProgrProdSelectList) {
        this.tiposProgrProdSelectList = tiposProgrProdSelectList;
    }

    public String[] getCodProgramaProduccion() {
        return codProgramaProduccion;
    }

    public void setCodProgramaProduccion(String[] codProgramaProduccion) {
        this.codProgramaProduccion = codProgramaProduccion;
    }

    public List<SelectItem> getProgramaProduccionSelectList() {
        return programaProduccionSelectList;
    }

    public void setProgramaProduccionSelectList(List<SelectItem> programaProduccionSelectList) {
        this.programaProduccionSelectList = programaProduccionSelectList;
    }

    public List<EspecificacionesOos> getEspecificacionesOosList() {
        return especificacionesOosList;
    }

    public void setEspecificacionesOosList(List<EspecificacionesOos> especificacionesOosList) {
        this.especificacionesOosList = especificacionesOosList;
    }

    public EspecificacionesOos getEspecificacionesOosRegistrar() {
        return especificacionesOosRegistrar;
    }

    public void setEspecificacionesOosRegistrar(EspecificacionesOos especificacionesOosRegistrar) {
        this.especificacionesOosRegistrar = especificacionesOosRegistrar;
    }

    public List<SelectItem> getTiposEspecificacionesOosSelectList() {
        return tiposEspecificacionesOosSelectList;
    }

    public void setTiposEspecificacionesOosSelectList(List<SelectItem> tiposEspecificacionesOosSelectList) {
        this.tiposEspecificacionesOosSelectList = tiposEspecificacionesOosSelectList;
    }

    public int getCodTipoEspecificacionOosFiltro() {
        return codTipoEspecificacionOosFiltro;
    }

    public void setCodTipoEspecificacionOosFiltro(int codTipoEspecificacionOosFiltro) {
        this.codTipoEspecificacionOosFiltro = codTipoEspecificacionOosFiltro;
    }

    public HtmlDataTable getEspecificacionesOOSDataTable() {
        return especificacionesOOSDataTable;
    }

    public void setEspecificacionesOOSDataTable(HtmlDataTable especificacionesOOSDataTable) {
        this.especificacionesOOSDataTable = especificacionesOOSDataTable;
    }

    public List<SubEspecificacionesOOS> getSubEspecificacionesOOSList() {
        return subEspecificacionesOOSList;
    }

    public void setSubEspecificacionesOOSList(List<SubEspecificacionesOOS> subEspecificacionesOOSList) {
        this.subEspecificacionesOOSList = subEspecificacionesOOSList;
    }

    public SubEspecificacionesOOS getSubEspecificacionesOOSRegistrar() {
        return subEspecificacionesOOSRegistrar;
    }

    public void setSubEspecificacionesOOSRegistrar(SubEspecificacionesOOS subEspecificacionesOOSRegistrar) {
        this.subEspecificacionesOOSRegistrar = subEspecificacionesOOSRegistrar;
    }

    public List<EspecificacionesOos> getEspecificacionesOosInvestigacion() {
        return especificacionesOosInvestigacion;
    }

    public void setEspecificacionesOosInvestigacion(List<EspecificacionesOos> especificacionesOosInvestigacion) {
        this.especificacionesOosInvestigacion = especificacionesOosInvestigacion;
    }

    public List<EspecificacionesOos> getEspecificacionesOosEvaluacion() {
        return especificacionesOosEvaluacion;
    }

    public void setEspecificacionesOosEvaluacion(List<EspecificacionesOos> especificacionesOosEvaluacion) {
        this.especificacionesOosEvaluacion = especificacionesOosEvaluacion;
    }

    public List<EspecificacionesOos> getEspecificacionesOosLaboratorio() {
        return especificacionesOosLaboratorio;
    }

    public void setEspecificacionesOosLaboratorio(List<EspecificacionesOos> especificacionesOosLaboratorio) {
        this.especificacionesOosLaboratorio = especificacionesOosLaboratorio;
    }

    public int getEstadoRegistroOOS() {
        return estadoRegistroOOS;
    }

    public void setEstadoRegistroOOS(int estadoRegistroOOS) {
        this.estadoRegistroOOS = estadoRegistroOOS;
    }

    public List<EspecificacionesOos> getEspecificacionesOosProduccion() {
        return especificacionesOosProduccion;
    }

    public void setEspecificacionesOosProduccion(List<EspecificacionesOos> especificacionesOosProduccion) {
        this.especificacionesOosProduccion = especificacionesOosProduccion;
    }

    public int getCodPermisoOOs() {
        return codPermisoOOs;
    }

    public void setCodPermisoOOs(int codPermisoOOs) {
        this.codPermisoOOs = codPermisoOOs;
    }

    public List<SelectItem> getPersonalRegistroSelectList() {
        return personalRegistroSelectList;
    }

    public void setPersonalRegistroSelectList(List<SelectItem> personalRegistroSelectList) {
        this.personalRegistroSelectList = personalRegistroSelectList;
    }

    
    
}
