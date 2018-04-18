/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.web;

import com.cofar.bean.ComponentesPresProd;
import com.cofar.bean.ComponentesProd;
import com.cofar.bean.Desviacion;
import com.cofar.bean.DesviacionFormulaMaestraDetalleEp;
import com.cofar.bean.DesviacionFormulaMaestraDetalleEs;
import com.cofar.bean.DesviacionFormulaMaestraDetalleMpFracciones;
import com.cofar.bean.FormulaMaestraDetalleEP;
import com.cofar.bean.FormulaMaestraDetalleES;
import com.cofar.bean.FormulaMaestraDetalleMP;
import com.cofar.bean.FormulaMaestraDetalleMPfracciones;
import com.cofar.bean.FormulaMaestraEsVersion;
import com.cofar.bean.PresentacionesPrimarias;
import com.cofar.bean.PresentacionesProducto;
import com.cofar.bean.ProgramaProduccion;
import com.cofar.bean.TiposMaterialProduccion;
import com.cofar.bean.util.correos.EnvioCorreoDesviacion;
import com.cofar.util.Util;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import javax.faces.context.ExternalContext;
import javax.faces.context.FacesContext;
import javax.faces.model.SelectItem;
import javax.servlet.ServletContext;
import org.apache.logging.log4j.LogManager;
import org.richfaces.component.html.HtmlDataTable;

/**
 *
 * @author DASISAQ
 */
public class ManagedProgramaProduccionDesviacion extends ManagedBean
{
    //<editor-fold defaultstate="collapsed" desc="variables">
        private static final int COD_ESTADO_IMPRESION_ANULADO_POR_EDICION = 4;
        private Connection con=null;
        private String mensaje="";
        private List<ComponentesProd> desviacionFormulaMaestraDetalleMpList;
        private Desviacion desviacionProgramaProduccion;
        private List<PresentacionesPrimarias> desviacionFormulaMaestraEpList;
        private List<SelectItem> presentacionesPrimariasSelectList;
        private List<ComponentesPresProd> desviacionFormulaMaestraEsList;
        
        
        private List<ProgramaProduccion> programaProduccionDesviacionList;
        private HtmlDataTable programaProduccionDesviacionDataTable;
        private ProgramaProduccion programaProduccionCambioPresentacion;

        
        private FormulaMaestraDetalleMP desviacionFormulaMaestraDetalleMpEditarFraccion;
        //formula maestra detalle ep
        
        private PresentacionesPrimarias presentacionesPrimariasBean;
        private DesviacionFormulaMaestraDetalleEp desviacionFormulaMaestraDetalleEpAgregar;
        private DesviacionFormulaMaestraDetalleEp desviacionFormulaMaestraDetalleEpEditar;
        private DesviacionFormulaMaestraDetalleEp desviacionFormulaMaestraDetalleEpEliminar;
        //formula maestra detalle es
        private DesviacionFormulaMaestraDetalleEs desviacionFormulaMaestraDetalleEsAgregar;
        private DesviacionFormulaMaestraDetalleEs desviacionFormulaMaestraDetalleEsEditar;
        private DesviacionFormulaMaestraDetalleEs desviacionFormulaMaestraDetalleEsEliminar;
        private ComponentesPresProd componentesPresProdBean;

        private List<SelectItem> materialesDesviacionSelectList;


        private List<SelectItem> tiposMaterialProduccionSelectList;
        private List<ComponentesPresProd> componentesPresProdDesviacionList;
        private String codCompprodDesviacion="";
        
        private ComponentesProd componentesProdBean;
        private TiposMaterialProduccion tiposMaterialProduccionBean;
        private FormulaMaestraDetalleMP desviacionFormulaMaestraDetalleMpAgregar;
        private FormulaMaestraDetalleMP desviacionFormulaMaestraDetalleMpEditar;
        private FormulaMaestraDetalleMP desviacionFormulaMaestraDetalleMpEliminar;
        private FormulaMaestraDetalleMPfracciones desviacionFormulaMaestraDetalleMpFraccionesEliminar;

    //</editor-fold>
        
        
    // <editor-fold defaultstate="collapsed" desc="desviaciones">
    
    
    
    public String seleccionarPresentacionSecundariaDesviacion_action()
    {
        
        programaProduccionCambioPresentacion.setChecked(true);
        LOGGER.debug("entro");
        Map<String,String> params=FacesContext.getCurrentInstance().getExternalContext().getRequestParameterMap();
        programaProduccionCambioPresentacion.getPresentacionesProducto().setCodPresentacion(params.get("codPresentacionProducto"));
        programaProduccionCambioPresentacion.getPresentacionesProducto().setNombreProductoPresentacion(params.get("nombrePresentacionProducto"));
/*        for(PresentacionesProducto bean:desviacionFormulaMaestraEsList)
        {
            if(bean.getTiposProgramaProduccion().getCodTipoProgramaProd().equals(programaProduccionCambioPresentacion.getTiposProgramaProduccion().getCodTipoProgramaProd()))
            {
                bean.setCodPresentacion(params.get("codPresentacionProducto"));
                bean.setNombreProductoPresentacion(params.get("nombrePresentacionProducto"));
                try {
                    con = Util.openConnection(con);
                    StringBuilder consulta = new StringBuilder("select m.COD_MATERIAL,m.NOMBRE_MATERIAL,CEILING(fmdev.CANTIDAD*(").append(programaProduccionCambioPresentacion.getCantidadLote()).append("/fmv.CANTIDAD_LOTE)) as cantidadMaterial,");
                                                        consulta.append(" um.COD_UNIDAD_MEDIDA,um.NOMBRE_UNIDAD_MEDIDA");
                                            consulta.append(" from FORMULA_MAESTRA_VERSION fmv");
                                                        consulta.append(" inner join FORMULA_MAESTRA_DETALLE_ES_VERSION fmdev on fmdev.COD_VERSION=fmv.COD_VERSION");
                                                                consulta.append(" and fmdev.COD_FORMULA_MAESTRA=fmv.COD_FORMULA_MAESTRA");
                                                        consulta.append(" inner join materiales m on m.COD_MATERIAL=fmdev.COD_MATERIAL");
                                                        consulta.append(" inner join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=fmdev.COD_UNIDAD_MEDIDA");
                                            consulta.append(" where fmv.COD_COMPPROD_VERSION=").append(params.get("codVersionProducto"));
                                                        consulta.append(" and fmdev.COD_PRESENTACION_PRODUCTO=").append(programaProduccionCambioPresentacion.getPresentacionesProducto().getCodPresentacion());
                                                        consulta.append(" and fmdev.COD_TIPO_PROGRAMA_PROD=").append(programaProduccionCambioPresentacion.getTiposProgramaProduccion().getCodTipoProgramaProd());
                                            consulta.append(" order by m.NOMBRE_MATERIAL");
                    LOGGER.debug("consulta sacar materiales es "+consulta.toString());
                    Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    ResultSet res = st.executeQuery(consulta.toString());
                    bean.setDesviacionFormulaMaestraDetalleEsList(new ArrayList<DesviacionFormulaMaestraDetalleEs>());
                    while (res.next()) 
                    {
                        DesviacionFormulaMaestraDetalleEs nuevo=new DesviacionFormulaMaestraDetalleEs();
                        nuevo.getMateriales().setCodMaterial(res.getString("COD_MATERIAL"));
                        nuevo.getMateriales().setNombreMaterial(res.getString("NOMBRE_MATERIAL"));
                        nuevo.setCantidad(res.getDouble("cantidadMaterial"));
                        nuevo.getUnidadesMedida().setCodUnidadMedida(res.getString("COD_UNIDAD_MEDIDA"));
                        nuevo.getUnidadesMedida().setNombreUnidadMedida(res.getString("NOMBRE_UNIDAD_MEDIDA"));
                        bean.getDesviacionFormulaMaestraDetalleEsList().add(nuevo);
                        
                    }
                    st.close();
                } catch (SQLException ex) {
                    LOGGER.warn("error", ex);
                } finally {
                    this.cerrarConexion(con);
                }
                
            }
        }*/
        return null;
    }
    
    
    public String cargarPresentacionesVersion_action()
    {
        programaProduccionCambioPresentacion=(ProgramaProduccion)programaProduccionDesviacionDataTable.getRowData();
        try 
        {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select cpv.NRO_VERSION,pp.NOMBRE_PRODUCTO_PRESENTACION");
                                            consulta.append(" ,cppv.COD_PRESENTACION,cpv.COD_VERSION");
                                    consulta.append(" from COMPONENTES_PROD_VERSION cpv ");
                                            consulta.append(" inner join COMPONENTES_PRESPROD_VERSION cppv on cpv.COD_VERSION=cppv.COD_VERSION");
                                            consulta.append(" inner join PRESENTACIONES_PRODUCTO pp on pp.cod_presentacion=cppv.COD_PRESENTACION");
                                    consulta.append(" where cpv.COD_COMPPROD=").append(programaProduccionCambioPresentacion.getComponentesProdVersion().getCodCompprod());
                                            consulta.append(" and cppv.COD_TIPO_PROGRAMA_PROD=").append(programaProduccionCambioPresentacion.getTiposProgramaProduccion().getCodTipoProgramaProd());
                                            consulta.append(" and pp.COD_PRESENTACION<>").append(programaProduccionCambioPresentacion.getPresentacionesProducto().getCodPresentacion());
                                    consulta.append(" order by cpv.NRO_VERSION,pp.NOMBRE_PRODUCTO_PRESENTACION");
            LOGGER.debug("consulta cargar cambios presentacion "+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            componentesPresProdDesviacionList=new ArrayList<ComponentesPresProd>();
            while (res.next()) 
            {
                ComponentesPresProd nuevo=new ComponentesPresProd();
                nuevo.getComponentesProd().setNroVersion(res.getInt("NRO_VERSION"));
                nuevo.getPresentacionesProducto().setCodPresentacion(res.getString("COD_PRESENTACION"));
                nuevo.getComponentesProd().setCodVersion(res.getInt("COD_VERSION"));
                nuevo.getPresentacionesProducto().setNombreProductoPresentacion(res.getString("NOMBRE_PRODUCTO_PRESENTACION"));
                componentesPresProdDesviacionList.add(nuevo);
            }
            st.close();
        } catch (SQLException ex) {
            LOGGER.warn("error", ex);
        } finally {
            this.cerrarConexion(con);
        }
        return null;
    }
    private void cargarTiposMaterialProduccionSelectList()
    {
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select tmp.COD_TIPO_MATERIAL_PRODUCCION,tmp.NOMBRE_TIPO_MATERIAL_PRODUCCION" );
                         consulta.append(" from TIPOS_MATERIAL_PRODUCCION tmp order by tmp.COD_TIPO_MATERIAL_PRODUCCION");
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            tiposMaterialProduccionSelectList=new ArrayList<SelectItem>();
            while (res.next()) 
            {
                tiposMaterialProduccionSelectList.add(new SelectItem(res.getInt("COD_TIPO_MATERIAL_PRODUCCION"),res.getString("NOMBRE_TIPO_MATERIAL_PRODUCCION")));
            }
            st.close();
            con.close();
        } catch (SQLException ex) {
            LOGGER.warn("error", ex);
        }
    }
    public String agregarDesviacionFormulaMaestraDetalleEs_action()
    {
        desviacionFormulaMaestraDetalleEsAgregar=new DesviacionFormulaMaestraDetalleEs();
        StringBuilder materialesRegistrados=new StringBuilder();
        for(DesviacionFormulaMaestraDetalleEs bean1:componentesPresProdBean.getDesviacionFormulaMaestraDetalleEsList())
        {
            materialesRegistrados.append(materialesRegistrados.length()>0?",":"").append(bean1.getMateriales().getCodMaterial());
        }
        this.cargarMaterialesCapitulo("4,8",materialesRegistrados.toString());
        return null;
    }
    
    
    
    
    
    
    
    
    
    
    /**
     * carga lista select de materiales para agregar nuevo material a la desviacion
     * @param codCapitulo 
     */
    private void cargarMaterialesCapitulo(String codCapitulo,String codMaterialesRegistrados)
    {
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select m.COD_MATERIAL,(m.NOMBRE_MATERIAL+'('+um.ABREVIATURA+')') as MATERIAL");
                          consulta.append(" from materiales m inner join grupos g on g.COD_GRUPO=m.COD_GRUPO");
                          consulta.append(" inner join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=m.COD_UNIDAD_MEDIDA");
                          consulta.append(" where g.COD_CAPITULO in (").append(codCapitulo).append(")");
                          if(codMaterialesRegistrados.length()>0)consulta.append(" and m.COD_MATERIAL NOT IN (").append(codMaterialesRegistrados).append(")");
                          consulta.append(" and m.COD_ESTADO_REGISTRO=1");
                          consulta.append(" order by m.NOMBRE_MATERIAL");
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            materialesDesviacionSelectList=new ArrayList<SelectItem>();
            while (res.next()) 
            {
                materialesDesviacionSelectList.add(new SelectItem(res.getString("COD_MATERIAL"),res.getString("MATERIAL")));
            }
            st.close();
            con.close();
        }
        catch (SQLException ex) {
            LOGGER.warn("error", ex);
        }
        
    }
    public String guardarDesviacionProgramaProduccionMaterial_action()throws SQLException
    {
        mensaje="";
        try 
        {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            ManagedAccesoSistema managed=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
            
            StringBuilder consulta;
            PreparedStatement pst;
            
            SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy HH:mm");
            desviacionProgramaProduccion.setDescripcionDesviacion("<span style='background-color: rgb(0, 0, 102);color:white;'><b>"+managed.getUsuarioModuloBean().getApPaternoUsuarioGlobal()+" "+managed.getUsuarioModuloBean().getApMaternoUsuarioGlobal()+" "+managed.getUsuarioModuloBean().getNombrePilaUsuarioGlobal()+ " ("+sdf.format(new Date())+"):</b></span><br/>"+desviacionProgramaProduccion.getDescripcionDesviacion()+"<br/>");
            if(desviacionProgramaProduccion.getCodDesviacion()>0)
            {
                // <editor-fold defaultstate="collapsed" desc="actualizando datos desviacion">
                    consulta=new StringBuilder("update DESVIACION");
                                    consulta.append(" set DESCRIPCION_DESVIACION= CAST(DESCRIPCION_DESVIACION as nvarchar(MAX))+?");
                                    consulta.append(" ,FECHA_DESVIACION=GETDATE()");
                            consulta.append(" where COD_DESVIACION=").append(desviacionProgramaProduccion.getCodDesviacion());
                    LOGGER.debug("consulta actualizar datos desviacion "+consulta.toString());
                    pst=con.prepareStatement(consulta.toString());
                    pst.setString(1,desviacionProgramaProduccion.getDescripcionDesviacion());
                    if(pst.executeUpdate()>0)LOGGER.info("se actualizo la desviacion");
                //</editor-fold>
            }
            else
            {
                // <editor-fold defaultstate="collapsed" desc="registra desviacion">
                    consulta=new StringBuilder("INSERT INTO dbo.DESVIACION( FECHA_DESVIACION, COD_PERSONAL,DESVIACION_PLANIFICADA, DESCRIPCION_DESVIACION,");
                                        consulta.append(" COD_SEGUIMIENTO_PROGRAMA_PRODUCCION_PROCESO, COD_TIPO_DESVIACION,COD_FUENTE_DESVIACION, FECHA_DETECCION, COD_PERSONAL_DETECTA,");
                                        consulta.append(" COD_AREA_EMPRESA_DETECTA_DESVIACION, CODIGO, COD_TIPO_REPORTE_DESVIACION,DESCRIPCION_INVESTIGACION, COD_AREA_GENERADORA_DESVIACION,");
                                        consulta.append(" COD_DESVIACION_GENERICA, COD_ESTADO_DESVIACION, FECHA_APROBACION_ASEGURAMIENTO,FECHA_ENVIO_ASEGURAMIENTO, FECHA_CUMPLIMIENTO_REVISION)");
                                consulta.append(" VALUES (");
                                        consulta.append(" getdate(),");
                                        consulta.append(managed.getUsuarioModuloBean().getCodUsuarioGlobal()).append(",");
                                        consulta.append(" 1,");//desviacion planificada
                                        consulta.append(" ?,");//descripcion de la desviacion
                                        consulta.append(" 0,");//seguimiento de programa produccion proceso
                                        consulta.append(" 4,");// tipo desviacion producto
                                        consulta.append(" 4,");//fuente desviacion proceso
                                        consulta.append(" GETDATE(),");
                                        consulta.append(managed.getUsuarioModuloBean().getCodUsuarioGlobal()).append(",");
                                        consulta.append("(select p.COD_AREA_EMPRESA from personal p where p.COD_PERSONAL= ").append(managed.getUsuarioModuloBean().getCodUsuarioGlobal()).append("),");
                                        consulta.append("'',");
                                        consulta.append("4,");// tipo reporte desviacion planificada
                                        consulta.append("'',");
                                        consulta.append("0,");//area GENERADORA
                                        consulta.append("0,");//DESVIACION GENERICA
                                        consulta.append("7,");//ESTAO DESVIACION ENVIADA ASEGURAMIENTO
                                        consulta.append("null,");//FECHA APROBACION ASEGURAMIENTO
                                        consulta.append("GETDATE(),");//FECHA ENVIO ASEGURAMINETO
                                        consulta.append("null");//FECHA CUMPLIMIENTO REVISION
                                consulta.append(")");
                    LOGGER.debug("consulta registrar nueva desviacion" + consulta.toString());
                    pst = con.prepareStatement(consulta.toString(),PreparedStatement.RETURN_GENERATED_KEYS);
                    pst.setString(1,desviacionProgramaProduccion.getDescripcionDesviacion());
                    if (pst.executeUpdate() > 0)LOGGER.info("Se registro la desviacion");
                    ResultSet res=pst.getGeneratedKeys();
                    if(res.next())desviacionProgramaProduccion.setCodDesviacion(res.getInt(1));
                    consulta=new StringBuilder("INSERT INTO DESVIACION_PROGRAMA_PRODUCCION(COD_DESVIACION, COD_PROGRAMA_PROD,COD_LOTE_PRODUCCION)");
                                consulta.append(" VALUES(");
                                        consulta.append(desviacionProgramaProduccion.getCodDesviacion()).append(",");
                                        consulta.append(desviacionProgramaProduccion.getProgramaProduccion().getCodProgramaProduccion()).append(",");
                                        consulta.append("'").append(desviacionProgramaProduccion.getProgramaProduccion().getCodLoteProduccion()).append("'");
                                consulta.append(")");
                    LOGGER.debug("consulta registrar desviacion programa produccion "+consulta.toString());
                    pst=con.prepareStatement(consulta.toString());
                    if(pst.executeUpdate()>0)LOGGER.info("Se registro desviacion programa produccion ");
                //</editor-fold>
            }
            // <editor-fold defaultstate="collapsed" desc="registrando programa produccion">
                consulta=new StringBuilder("exec PAA_REGISTRO_PROGRAMA_PRODUCCION_LOG ");
                                    consulta.append("'").append(desviacionProgramaProduccion.getProgramaProduccion().getCodLoteProduccion()).append("',");
                                    consulta.append(desviacionProgramaProduccion.getProgramaProduccion().getCodProgramaProduccion()).append(",");
                                    consulta.append(managed.getUsuarioModuloBean().getCodUsuarioGlobal()).append(",");
                                    consulta.append("1,");
                                    consulta.append(desviacionProgramaProduccion.getCodDesviacion()).append(",");
                                    consulta.append("'Por levantamiento de desviacion'");
                LOGGER.debug("consulta registrar programa produccion log "+consulta.toString());
                pst=con.prepareStatement(consulta.toString());
                if(pst.executeUpdate()>0)LOGGER.info("se registro progrma produccion log");
            //</editor-fold>
            
            for(ComponentesProd bean:desviacionFormulaMaestraDetalleMpList)
            {
                // <editor-fold defaultstate="collapsed" desc="registrando version alterna si procede">
                    //realizar desviacion solo si la version inicial del producto no es una version del producto
                    if(bean.getTiposComponentesProdVersion().getCodTipoComponentesProdVersion()==1)
                    {
                        consulta=new StringBuilder("EXEC PAA_GENERACION_NUEVA_VERSION_PRODUCTO ");
                                        consulta.append(bean.getCodCompprod()).append(",");
                                        consulta.append("2,");//modificacion por desviacion
                                        consulta.append(0).append(",");
                                        consulta.append(0).append(",");
                                        consulta.append("?,");
                                        consulta.append(bean.getCodVersion()).append(",");
                                        consulta.append(bean.getFormulaMaestraEsVersion().getCodFormulaMaestraEsVersion());
                        LOGGER.debug("consulta registrar version alterna "+consulta.toString());
                        CallableStatement callCreateVersion=con.prepareCall(consulta.toString());
                        callCreateVersion.registerOutParameter(1,java.sql.Types.INTEGER);
                        callCreateVersion.execute();
                        bean.setCodVersion(callCreateVersion.getInt(1));
                        consulta=new StringBuilder(" update PROGRAMA_PRODUCCION set COD_COMPPROD_VERSION=cpv.COD_VERSION");
                                            consulta.append(" ,COD_FORMULA_MAESTRA_VERSION=fmv.COD_VERSION");
                                            consulta.append(" ,COD_FORMULA_MAESTRA_ES_VERSION=fmes.COD_FORMULA_MAESTRA_ES_VERSION");
                                    consulta.append(" FROM PROGRAMA_PRODUCCION pp");
                                            consulta.append(" inner join COMPONENTES_PROD_VERSION cpv on cpv.COD_COMPPROD=pp.COD_COMPPROD");
                                            consulta.append(" inner join FORMULA_MAESTRA_VERSION fmv on fmv.COD_COMPPROD=cpv.COD_COMPPROD");
                                                    consulta.append(" and cpv.COD_VERSION=fmv.COD_COMPPROD_VERSION");
                                            consulta.append(" inner join FORMULA_MAESTRA_ES_VERSION fmes on fmes.COD_VERSION=cpv.COD_VERSION");
                                    consulta.append(" where pp.COD_LOTE_PRODUCCION='").append(desviacionProgramaProduccion.getProgramaProduccion().getCodLoteProduccion()).append("'");
                                            consulta.append(" and pp.COD_COMPPROD=").append(bean.getCodCompprod());
                                            consulta.append(" and pp.COD_PROGRAMA_PROD=").append(desviacionProgramaProduccion.getProgramaProduccion().getCodProgramaProduccion());
                                            consulta.append(" and cpv.COD_VERSION=").append(bean.getCodVersion());
                                    LOGGER.debug("consulta registrar programa produccion desviacion "+consulta.toString());
                                    pst=con.prepareStatement(consulta.toString());
                                    if(pst.executeUpdate()>0)LOGGER.info("se registro el cambio");
                    }
                //</editor-fold>  apertura 
                consulta=new StringBuilder("select f.COD_FORMULA_MAESTRA,f.COD_VERSION");
                            consulta.append(" from FORMULA_MAESTRA_VERSION f");
                            consulta.append(" where f.COD_COMPPROD_VERSION=").append(bean.getCodVersion());
                LOGGER.debug("consulta obtener datos de version fm "+consulta.toString());
                Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet res=st.executeQuery(consulta.toString());
                if(res.next())
                {
                    bean.setCodFormulaMaestra(res.getInt("COD_FORMULA_MAESTRA"));
                    bean.setCodFormulaMaestraVersion(res.getInt("COD_VERSION"));
                }
                
                // <editor-fold defaultstate="collapsed" desc="registrando materia prima">
                    consulta=new StringBuilder(" delete FORMULA_MAESTRA_DETALLE_MP_FRACCIONES_VERSION");
                                consulta.append(" where COD_FORMULA_MAESTRA=").append(bean.getCodFormulaMaestra());
                                        consulta.append(" and COD_VERSION=").append(bean.getCodFormulaMaestraVersion());
                    LOGGER.debug("consulta delete formula fracciones "+consulta.toString());
                    pst=con.prepareStatement(consulta.toString());
                    if(pst.executeUpdate()>0)LOGGER.info(" se eliminaron las fracciones");
                    consulta=new StringBuilder(" delete FORMULA_MAESTRA_DETALLE_MP_VERSION ");
                                consulta.append(" WHERE COD_FORMULA_MAESTRA=").append(bean.getCodFormulaMaestra());
                                        consulta.append(" and COD_VERSION=").append(bean.getCodFormulaMaestraVersion());
                    LOGGER.debug("consulta delete formula mp "+consulta.toString());
                    pst=con.prepareStatement(consulta.toString());
                    if(pst.executeUpdate()>0)LOGGER.info(" se elimino el material de la formula");
                    consulta=new StringBuilder("INSERT INTO FORMULA_MAESTRA_DETALLE_MP_VERSION(COD_VERSION, COD_FORMULA_MAESTRA,COD_MATERIAL, CANTIDAD, COD_UNIDAD_MEDIDA, NRO_PREPARACIONES,");
                        consulta.append("CANTIDAD_UNITARIA_GRAMOS, CANTIDAD_TOTAL_GRAMOS,CANTIDAD_MAXIMA_MATERIAL_POR_FRACCION, DENSIDAD_MATERIAL,COD_TIPO_MATERIAL_PRODUCCION)");
                    consulta.append(" VALUES (");
                            consulta.append(bean.getCodFormulaMaestraVersion()).append(",");
                            consulta.append(bean.getCodFormulaMaestra()).append(",");
                            consulta.append("?,?,?,1,?,?,?,?,");
                            consulta.append("?");//tipo material produccion 
                    consulta.append(")");
                    LOGGER.debug("consulta registrar fm mp pstmp"+consulta.toString());
                    PreparedStatement pstMaterial=con.prepareStatement(consulta.toString(),PreparedStatement.RETURN_GENERATED_KEYS);
                    
                    consulta=new StringBuilder("INSERT INTO FORMULA_MAESTRA_DETALLE_MP_FRACCIONES_VERSION(COD_VERSION,COD_FORMULA_MAESTRA, COD_MATERIAL, COD_FORMULA_MAESTRA_FRACCIONES, CANTIDAD,");
                                        consulta.append(" PORCIENTO_FRACCION,COD_TIPO_MATERIAL_PRODUCCION,COD_FORMULA_MAESTRA_DETALLE_MP_VERSION)");
                                consulta.append(" VALUES (");
                                        consulta.append(bean.getCodFormulaMaestraVersion()).append(",");
                                        consulta.append(bean.getCodFormulaMaestra()).append(",");
                                        consulta.append("?,?,?,?,");
                                        consulta.append("?,?");
                                consulta.append(")");
                    LOGGER.debug("consulta registra fm fracciones pstfmf "+consulta.toString());
                    PreparedStatement pstFracciones=con.prepareStatement(consulta.toString());
                    Double incrementoVolumen=(bean.getAreasEmpresa().getCodAreaEmpresa().equals("81")?
                              (bean.getCantidadVolumenDeDosificado()/bean.getCantidadVolumen()):1);
                    for(TiposMaterialProduccion tipoMaterial:bean.getDesviacionFormulaMaestraDetalleMpList())
                    {
                        pstMaterial.setInt(8,tipoMaterial.getCodTipoMaterialProduccion());LOGGER.info("p8  pstMaterial "+tipoMaterial.getCodTipoMaterialProduccion());
                        pstFracciones.setInt(5, tipoMaterial.getCodTipoMaterialProduccion());
                        for(FormulaMaestraDetalleMP mp:tipoMaterial.getFormulaMaestraDetalleMPList())
                        {
                            
                                mp.setCantidadTotalGramos(mp.getCantidadUnitariaGramos()*bean.getTamanioLoteProduccion()*incrementoVolumen);
                                mp.setCantidadTotalGramos(mp.getCantidadTotalGramos()+(mp.getCantidadTotalGramos()*bean.getToleranciaVolumenfabricar()/100));
                                mp.setCantidadTotalGramos(Util.redondeoProduccionSuperior(mp.getCantidadTotalGramos(),9));
                                if(mp.getUnidadesMedida().getTipoMedida().getCodTipoMedida()!=2)
                                {
                                    mp.setCantidad(mp.getCantidadTotalGramos()*(1/mp.getEquivalenciaAMiliLitros())*(1d/mp.getDensidadMaterial()));
                                }
                                else
                                {
                                    mp.setCantidad(mp.getCantidadTotalGramos()*(1/mp.getEquivalenciaAGramos()));
                                }
                                pstMaterial.setString(1, mp.getMateriales().getCodMaterial());LOGGER.info("pstmp p1:"+mp.getMateriales().getCodMaterial());
                                pstMaterial.setDouble(2,mp.getCantidad());LOGGER.info("pstmp p2:"+mp.getCantidad());
                                pstMaterial.setString(3,mp.getUnidadesMedida().getCodUnidadMedida());LOGGER.info("pstmp p3:"+mp.getUnidadesMedida().getCodUnidadMedida());
                                pstMaterial.setDouble(4,mp.getCantidadUnitariaGramos());LOGGER.info("pstmp p4:"+mp.getCantidadUnitariaGramos());
                                pstMaterial.setDouble(5,mp.getCantidadTotalGramos());LOGGER.info("pstmp p5:"+mp.getCantidadTotalGramos());
                                pstMaterial.setDouble(6,mp.isAplicaCantidadMaximaPorFraccion()?mp.getCantidadMaximaMaterialPorFraccion():0);LOGGER.info("pstmp p6:"+(mp.isAplicaCantidadMaximaPorFraccion()?mp.getCantidadMaximaMaterialPorFraccion():0));
                                pstMaterial.setDouble(7,mp.getDensidadMaterial());LOGGER.info("pstmp p7:"+mp.getDensidadMaterial());
                                if(pstMaterial.executeUpdate()>0)LOGGER.info(" se registro el nuevo material ");
                                res=pstMaterial.getGeneratedKeys();
                                res.next();
                                pstFracciones.setString(1,mp.getMateriales().getCodMaterial());LOGGER.info("pstfmf p1: "+mp.getMateriales().getCodMaterial());
                                pstFracciones.setInt(6,res.getInt(1));LOGGER.info("pstfmf p5: "+res.getInt(1));

                                if(mp.isAplicaCantidadMaximaPorFraccion())
                                {
                                    LOGGER.debug("registro por tamaño maximo fraccion");
                                    int codFormulaMaestraFracciones=0;
                                    Double cantidadTotalAsignar=mp.getCantidadTotalGramos();
                                    while(cantidadTotalAsignar>0)
                                    {
                                        pstFracciones.setInt(2,codFormulaMaestraFracciones);LOGGER.info("pstfmf p2: "+codFormulaMaestraFracciones);
                                        if(cantidadTotalAsignar>mp.getCantidadMaximaMaterialPorFraccion())
                                        {
                                            pstFracciones.setDouble(3,mp.getCantidadMaximaMaterialPorFraccion());LOGGER.info("pstfmf p3: "+mp.getCantidadMaximaMaterialPorFraccion());
                                            pstFracciones.setDouble(4,(mp.getCantidadMaximaMaterialPorFraccion()/mp.getCantidadTotalGramos())*100);LOGGER.info("pstfmf p4: "+(mp.getCantidadMaximaMaterialPorFraccion()/mp.getCantidadTotalGramos())*100);
                                            cantidadTotalAsignar-=mp.getCantidadMaximaMaterialPorFraccion();
                                        }
                                        else
                                        {
                                            pstFracciones.setDouble(3,cantidadTotalAsignar);LOGGER.info("pstfmf p3: "+cantidadTotalAsignar);
                                            pstFracciones.setDouble(4,(cantidadTotalAsignar/mp.getCantidadTotalGramos())*100);LOGGER.info("pstfmf p4: "+(cantidadTotalAsignar/mp.getCantidadTotalGramos())*100);
                                            cantidadTotalAsignar=0d;
                                        }
                                        if(pstFracciones.executeUpdate()>0)LOGGER.info("se registro la fraccion entera");
                                        codFormulaMaestraFracciones++;
                                    }
                                }
                                else
                                {
                                    LOGGER.debug("registro de fracciones definidas");
                                    int codFormulaMaestraFracciones=0;
                                    for(FormulaMaestraDetalleMPfracciones fraccion:mp.getFormulaMaestraDetalleMPfraccionesList())
                                    {
                                        pstFracciones.setDouble(3,fraccion.getCantidad());LOGGER.info("pstfmf p3: "+fraccion.getCantidad());
                                        pstFracciones.setInt(2,codFormulaMaestraFracciones);LOGGER.info("pstfmf p2: "+0);
                                        pstFracciones.setDouble(4,fraccion.getPorcientoFraccion());LOGGER.info("pstfmf p4: "+100);
                                        if(pstFracciones.executeUpdate()>0)LOGGER.info("se registro la fraccion definida");
                                        codFormulaMaestraFracciones++;
                                    }
                                }

                        }
                    }
                //</editor-fold>   
            }
            // <editor-fold defaultstate="collapsed" desc="registrando empaque primario">
                for(PresentacionesPrimarias bean:desviacionFormulaMaestraEpList)
                {
                    for(ComponentesProd producto:desviacionFormulaMaestraDetalleMpList)
                    {
                        if(producto.getCodCompprod().equals(bean.getComponentesProd().getCodCompprod()))
                        {
                            bean.setComponentesProd(producto);
                        }
                    }
                    consulta=new StringBuilder(" select ppv.COD_PRESENTACION_PRIMARIA");
                            consulta.append(" from PRESENTACIONES_PRIMARIAS_VERSION ppv");
                            consulta.append(" where ppv.COD_VERSION=").append(bean.getComponentesProd().getCodVersion());
                                    consulta.append(" and ppv.COD_ENVASEPRIM=").append(bean.getEnvasesPrimarios().getCodEnvasePrim());
                                    consulta.append(" and ppv.COD_TIPO_PROGRAMA_PROD=").append(bean.getTiposProgramaProduccion().getCodTipoProgramaProd());
                    LOGGER.debug("consulta obtener codigo de presentacion primar "+consulta.toString());
                    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet res=st.executeQuery(consulta.toString());
                    if(res.next())
                        bean.setCodPresentacionPrimaria(res.getString("COD_PRESENTACION_PRIMARIA"));
                    
                    consulta = new StringBuilder("delete FORMULA_MAESTRA_DETALLE_EP_VERSION");
                                consulta.append(" where COD_PRESENTACION_PRIMARIA=").append(bean.getCodPresentacionPrimaria());
                                        consulta.append(" and COD_VERSION=").append(bean.getComponentesProd().getCodFormulaMaestraVersion());
                                        consulta.append(" and COD_FORMULA_MAESTRA=").append(bean.getComponentesProd().getCodFormulaMaestra());
                    LOGGER.debug("consulta delete fm pstDel1"+consulta.toString());
                    pst = con.prepareStatement(consulta.toString());
                    if(pst.executeUpdate()>0)LOGGER.info("se elimino detalle ep ");
                    consulta=new StringBuilder("INSERT INTO FORMULA_MAESTRA_DETALLE_EP_VERSION(COD_VERSION, COD_FORMULA_MAESTRA,");
                                            consulta.append(" COD_PRESENTACION_PRIMARIA, COD_MATERIAL,CANTIDAD_UNITARIA,CANTIDAD, COD_UNIDAD_MEDIDA)");
                                    consulta.append(" VALUES (");
                                            consulta.append(bean.getComponentesProd().getCodFormulaMaestraVersion()).append(",");
                                            consulta.append(bean.getComponentesProd().getCodFormulaMaestra()).append(",");
                                            consulta.append(bean.getCodPresentacionPrimaria()).append(",");
                                            consulta.append("?,");//cod material
                                            consulta.append("?,");//CANTIDAD_UNITARIA
                                            consulta.append("?,");//CANTIDAD
                                            consulta.append("?");//COD UNIDAD MEDIDA
                                    consulta.append(")");
                    LOGGER.debug("consulta insertar formula maestra detalle ep pstep : "+consulta.toString());
                    pst=con.prepareStatement(consulta.toString());
                    for(DesviacionFormulaMaestraDetalleEp ep:bean.getDesviacionFormulaMaestraDetalleEpList())
                    {
                            pst.setString(1,ep.getMateriales().getCodMaterial());LOGGER.info("p1 pstep: "+ep.getMateriales().getCodMaterial());
                            pst.setDouble(2,ep.getCantidadUnitaria());LOGGER.info("p2 pstep: "+ep.getCantidadUnitaria());
                            Double cantidadLote=ep.getCantidadUnitaria()*(bean.getComponentesProd().getTamanioLoteProduccion()/bean.getCantidad());
                            pst.setDouble(3,cantidadLote);LOGGER.info("p3 pstep: "+cantidadLote);
                            pst.setString(4,ep.getUnidadesMedida().getCodUnidadMedida());LOGGER.info("p4 pstep: "+ep.getUnidadesMedida().getCodUnidadMedida());
                            if(pst.executeUpdate()>0)LOGGER.info("se registro el empaque primario");
                    }
                }
            //</editor-fold>
            // <editor-fold defaultstate="collapsed" desc="empaque secundario">
                for(ComponentesPresProd bean:desviacionFormulaMaestraEsList)
                {
                    for(ComponentesProd producto:desviacionFormulaMaestraDetalleMpList)
                    {
                        if(producto.getCodCompprod().equals(bean.getComponentesProd().getCodCompprod()))
                        {
                            bean.setComponentesProd(producto);
                        }
                    }
                    int codFormulaMaestraEsVersion=0;
                    consulta=new StringBuilder("select f.COD_FORMULA_MAESTRA_ES_VERSION");
                                consulta.append(" from FORMULA_MAESTRA_ES_VERSION f");
                                consulta.append(" where f.COD_VERSION=").append(bean.getComponentesProd().getCodVersion());
                    LOGGER.debug("consulta buscar version es "+consulta.toString());
                    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet res=st.executeQuery(consulta.toString());
                    if(res.next())codFormulaMaestraEsVersion=res.getInt("COD_FORMULA_MAESTRA_ES_VERSION");
                    consulta=new StringBuilder("DELETE FORMULA_MAESTRA_DETALLE_ES_VERSION ");
                            consulta.append(" where COD_FORMULA_MAESTRA_ES_VERSION=").append(codFormulaMaestraEsVersion);
                                    consulta.append(" and COD_TIPO_PROGRAMA_PROD=").append(bean.getTiposProgramaProduccion().getCodTipoProgramaProd());
                                    consulta.append(" and COD_PRESENTACION_PRODUCTO=").append(bean.getPresentacionesProducto().getCodPresentacion());
                    LOGGER.debug("consulta eliminar formula maestra detalle es "+consulta.toString());
                    pst=con.prepareStatement(consulta.toString());
                    if(pst.executeUpdate()>0)LOGGER.info("Se elimino la formula maestra detalle es");
                    
                    consulta=new StringBuilder("INSERT INTO FORMULA_MAESTRA_DETALLE_ES_VERSION(COD_VERSION, COD_FORMULA_MAESTRA,COD_MATERIAL, CANTIDAD, COD_UNIDAD_MEDIDA, COD_PRESENTACION_PRODUCTO,");
                                        consulta.append("COD_TIPO_PROGRAMA_PROD, FECHA_MODIFICACION, COD_FORMULA_MAESTRA_ES_VERSION)");
                                consulta.append("VALUES (");
                                        consulta.append(bean.getComponentesProd().getCodFormulaMaestraVersion()).append(",");//codversion fm
                                        consulta.append(bean.getComponentesProd().getCodFormulaMaestra()).append(",");//cod formula maestra
                                        consulta.append("?,");//cod material
                                        consulta.append("?,");//cantidad
                                        consulta.append("?,");//unidad medida
                                        consulta.append(bean.getPresentacionesProducto().getCodPresentacion()).append(",");
                                        consulta.append(bean.getTiposProgramaProduccion().getCodTipoProgramaProd()).append(",");
                                        consulta.append("GETDATE(),");
                                        consulta.append(codFormulaMaestraEsVersion);
                                consulta.append(")");
                    LOGGER.debug("consulta registrar detalle es "+consulta.toString());
                    pst=con.prepareStatement(consulta.toString());
                    for(DesviacionFormulaMaestraDetalleEs es:bean.getDesviacionFormulaMaestraDetalleEsList())
                    {
                        
                            pst.setString(1, es.getMateriales().getCodMaterial());LOGGER.debug("p1: "+es.getMateriales().getCodMaterial());
                            pst.setDouble(2,es.getCantidad());LOGGER.debug("p2: "+es.getCantidad());
                            pst.setString(3, es.getUnidadesMedida().getCodUnidadMedida());LOGGER.debug("p3: "+es.getUnidadesMedida().getCodUnidadMedida());
                            if(pst.executeUpdate()>0)LOGGER.info("se registro el detalle material "+es.getMateriales().getCodMaterial());
                        
                    }
                }
            
                consulta=new StringBuilder("update FORMULA_MAESTRA_DETALLE_ES_VERSION set CANTIDAD=cpv.TAMANIO_LOTE_PRODUCCION/pp.CANT_LOTE_PRODUCCION*fmdev.CANTIDAD");
                            consulta.append(" from FORMULA_MAESTRA_DETALLE_ES_VERSION fmdev");
                                    consulta.append(" inner join PROGRAMA_PRODUCCION pp on pp.COD_FORMULA_MAESTRA_ES_VERSION=fmdev.COD_FORMULA_MAESTRA_ES_VERSION");
                                            consulta.append(" and pp.COD_FORMULA_MAESTRA_VERSION=fmdev.COD_VERSION");
                                            consulta.append(" and pp.COD_PRESENTACION=fmdev.COD_PRESENTACION_PRODUCTO");
                                            consulta.append(" and pp.COD_TIPO_PROGRAMA_PROD=fmdev.COD_TIPO_PROGRAMA_PROD");
                                    consulta.append(" inner join COMPONENTES_PROD_VERSION cpv on cpv.COD_VERSION=pp.COD_COMPPROD_VERSION");
                                            consulta.append(" and pp.COD_COMPPROD=cpv.COD_COMPPROD");
                            consulta.append(" where  pp.COD_LOTE_PRODUCCION='").append(desviacionProgramaProduccion.getProgramaProduccion().getCodLoteProduccion()).append("'");
                                    consulta.append(" and pp.COD_PROGRAMA_PROD=").append(desviacionProgramaProduccion.getProgramaProduccion().getCodProgramaProduccion());
                LOGGER.debug("consulta actualizar cantidades "+consulta.toString());
                pst=con.prepareStatement(consulta.toString());
                if(pst.executeUpdate()>0)LOGGER.info("se actualizaron las cantidades");
            
            //</editor-fold>
            // <editor-fold defaultstate="collapsed" desc="recalculando cantidades totales">
                consulta=new StringBuilder(" exec PAA_ACTUALIZACION_CANTIDADES_FORMULA_MAESTRA_VERSION ");
                            consulta.append("?");//codigo de version
                LOGGER.debug("consulta actualizar cantidades totales pstact "+consulta.toString());
                pst=con.prepareStatement(consulta.toString());
                for(ComponentesProd bean:desviacionFormulaMaestraDetalleMpList)
                {
                    pst.setInt(1,bean.getCodVersion());LOGGER.info("p1 pstact : "+bean.getCodVersion());
                    pst.executeUpdate();
                }
            //</editor-fold>
            // <editor-fold defaultstate="collapsed" desc="generando etiquetas lote">
                consulta=new StringBuilder("EXEC PAA_REGISTRO_PROGRAMA_PRODUCCION_DETALLE ");
                            consulta.append(desviacionProgramaProduccion.getProgramaProduccion().getCodProgramaProduccion()).append(",");
                            consulta.append("'").append(desviacionProgramaProduccion.getProgramaProduccion().getCodLoteProduccion()).append("'");
                LOGGER.debug("consulta REGISTRAR PROGRAMA PRODUCCION DETALLE "+consulta.toString());
                pst=con.prepareStatement(consulta.toString());
                if(pst.executeUpdate()>0)LOGGER.info("se guardo la materia prima");
            //</editor-fold>
            //<editor-fold defaultstate="collapsed" desc="deshabilitar impresiones de producto">
                
                    consulta = new StringBuilder("select count(*) as cantidadEnvios")
                            .append(" from PROGRAMA_PRODUCCION_INGRESOS_ACOND ppia ")
                                    .append(" inner join INGRESOS_ACOND ia on ia.COD_INGRESO_ACOND = ppia.COD_INGRESO_ACOND")
                            .append(" where ppia.COD_LOTE_PRODUCCION = '").append(desviacionProgramaProduccion.getProgramaProduccion().getCodLoteProduccion()).append("'")
                                    .append(" and ppia.COD_PROGRAMA_PROD = ").append(desviacionProgramaProduccion.getProgramaProduccion().getCodProgramaProduccion())
                                    .append(" and ia.COD_ESTADO_INGRESOACOND<>2");
                    LOGGER.debug("consulta verificar envios de producto: "+consulta);
                    Statement st = con.createStatement();
                    ResultSet res = st.executeQuery(consulta.toString());
                    res.next();
                    if(res.getInt("cantidadEnvios") == 0){
                        consulta = new StringBuilder("update PROGRAMA_PRODUCCION_IMPRESION_OM set COD_ESTADO_PROGRAMA_PRODUCCION_IMPRESION_OM = ").append(COD_ESTADO_IMPRESION_ANULADO_POR_EDICION)
                                    .append(" where COD_LOTE_PRODUCCION ='").append(desviacionProgramaProduccion.getProgramaProduccion().getCodLoteProduccion()).append("'")
                                            .append(" and COD_PROGRAMA_PROD = ").append(desviacionProgramaProduccion.getProgramaProduccion().getCodProgramaProduccion());
                        LOGGER.debug("consulta inhabilitar impresion de O.M.: "+consulta);
                        pst = con.prepareStatement(consulta.toString());
                        if(pst.executeUpdate() > 0)LOGGER.info("se actualizaron O.M. existentes");
                    }
                //</editor-fold>
            con.commit();
            mensaje="1";
            pst.close();
        } 
        catch (SQLException ex) 
        {
            con.rollback();
            mensaje="Ocurrio un error al momento de guardar la desviacion,intente de nuevo";
            LOGGER.warn(ex.getMessage());
        }
        catch (NumberFormatException ex) 
        {
            con.rollback();
            mensaje="Ocurrio un error de datos al momento de guardar la desviacion, verifique la información e intente de nuevo";
            LOGGER.warn(ex.getMessage());
        }
        finally 
        {
            con.close();
        }
        if(mensaje.equals("1"))
        {
            EnvioCorreoDesviacion correo=new EnvioCorreoDesviacion(desviacionProgramaProduccion.getCodDesviacion(),(ServletContext)FacesContext.getCurrentInstance().getExternalContext().getContext());
            correo.start();
        }
        return null;
    }
            
    public String getCargarDesviacionFormulaMaestraMateriales()
    {
        //<editor-fold defaultstate="collapsed" desc="obteniendo programa de produccion">
            FacesContext facesContext = FacesContext.getCurrentInstance();
            ExternalContext externalContext = facesContext.getExternalContext();
            Map map = externalContext.getSessionMap();
            desviacionProgramaProduccion=new Desviacion();
            desviacionProgramaProduccion.setProgramaProduccion((ProgramaProduccion)((ProgramaProduccion)map.get("programaProduccionDesviacion")).clone());
        //</editor-fold>
        // <editor-fold defaultstate="collapsed" desc="lotes incluidos en la desviacion y productos para desviacion de materiales">
        try {
            con = Util.openConnection(con);
            StringBuilder consulta =new StringBuilder("select pp.COD_COMPPROD,pp.COD_COMPPROD_VERSION,pp.COD_FORMULA_MAESTRA_VERSION,cpv.nombre_prod_semiterminado");
                         consulta.append(",pp.COD_FORMULA_MAESTRA,tpp.NOMBRE_TIPO_PROGRAMA_PROD,tpp.COD_TIPO_PROGRAMA_PROD ,pp.CANT_LOTE_PRODUCCION");
                         consulta.append(",pp.COD_PRESENTACION,pp1.NOMBRE_PRODUCTO_PRESENTACION");
                         consulta.append(" from PROGRAMA_PRODUCCION pp");
                                consulta.append(" inner join COMPONENTES_PROD_VERSION cpv on cpv.COD_COMPPROD=pp.COD_COMPPROD");
                                        consulta.append(" and cpv.COD_VERSION=pp.COD_COMPPROD_VERSION ");
                                consulta.append(" inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD");
                                consulta.append(" left outer join PRESENTACIONES_PRODUCTO pp1 on pp.COD_PRESENTACION=pp1.cod_presentacion");
                         consulta.append(" where pp.COD_LOTE_PRODUCCION='").append(desviacionProgramaProduccion.getProgramaProduccion().getCodLoteProduccion()).append("'");
                         consulta.append(" and pp.COD_PROGRAMA_PROD='").append(desviacionProgramaProduccion.getProgramaProduccion().getCodProgramaProduccion()).append("'");
                         consulta.append(" order by cpv.nombre_prod_semiterminado,tpp.NOMBRE_TIPO_PROGRAMA_PROD");
             LOGGER.debug("consulta cargar lotes desviacion "+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            programaProduccionDesviacionList=new ArrayList<ProgramaProduccion>();
            while (res.next()) 
            {
                ProgramaProduccion nuevo=new ProgramaProduccion();
                nuevo.getComponentesProdVersion().setCodCompprod(res.getString("COD_COMPPROD"));
                nuevo.getComponentesProdVersion().setCodVersion(res.getInt("COD_COMPPROD_VERSION"));
                nuevo.getComponentesProdVersion().setNombreProdSemiterminado(res.getString("nombre_prod_semiterminado"));
                nuevo.getFormulaMaestraVersion().setCodFormulaMaestra(res.getString("COD_FORMULA_MAESTRA"));
                nuevo.getFormulaMaestraVersion().setCodVersion(res.getInt("COD_FORMULA_MAESTRA_VERSION"));
                nuevo.getTiposProgramaProduccion().setCodTipoProgramaProd(res.getString("COD_TIPO_PROGRAMA_PROD"));
                nuevo.getTiposProgramaProduccion().setNombreTipoProgramaProd(res.getString("NOMBRE_TIPO_PROGRAMA_PROD"));
                nuevo.setCantidadLote(res.getDouble("CANT_LOTE_PRODUCCION"));
                nuevo.getPresentacionesProducto().setCodPresentacion(res.getString("COD_PRESENTACION"));
                nuevo.getPresentacionesProducto().setNombreProductoPresentacion(res.getString("NOMBRE_PRODUCTO_PRESENTACION"));
                programaProduccionDesviacionList.add(nuevo);
                
            }
            consulta=new StringBuilder("select d.COD_DESVIACION");
                        consulta.append(" from DESVIACION d");
                                consulta.append(" inner join DESVIACION_PROGRAMA_PRODUCCION dpp on dpp.COD_DESVIACION=d.COD_DESVIACION");
                        consulta.append(" where dpp.COD_LOTE_PRODUCCION='").append(desviacionProgramaProduccion.getProgramaProduccion().getCodLoteProduccion()).append("'");
                                consulta.append(" AND dpp.COD_PROGRAMA_PROD='").append(desviacionProgramaProduccion.getProgramaProduccion().getCodProgramaProduccion()).append("'");
                                consulta.append(" and d.DESVIACION_PLANIFICADA=1");
            LOGGER.debug("consulta buscar desviacion lote "+consulta.toString());
            res=st.executeQuery(consulta.toString());
            if(res.next())desviacionProgramaProduccion.setCodDesviacion(res.getInt("COD_DESVIACION"));
            consulta=new StringBuilder("select pp.COD_COMPPROD,cpv.nombre_prod_semiterminado,cpv.CANTIDAD_VOLUMEN,cpv.CANTIDAD_VOLUMEN_DE_DOSIFICADO,");
                        consulta.append(" pp.COD_COMPPROD_VERSION,cpv.TOLERANCIA_VOLUMEN_FABRICAR,cpv.COD_AREA_EMPRESA,sum(pp.CANT_LOTE_PRODUCCION) as cantidadLoteProduccion");
                        consulta.append(" ,cpv.COD_TIPO_COMPONENTES_PROD_VERSION,pp.COD_FORMULA_MAESTRA_ES_VERSION");
                        consulta.append(" from PROGRAMA_PRODUCCION pp");
                                consulta.append(" inner join COMPONENTES_PROD_VERSION cpv on cpv.COD_COMPPROD=pp.COD_COMPPROD");
                                            consulta.append(" and cpv.COD_VERSION=pp.COD_COMPPROD_VERSION");
                                consulta.append(" inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD");
                        consulta.append(" where pp.COD_LOTE_PRODUCCION='").append(desviacionProgramaProduccion.getProgramaProduccion().getCodLoteProduccion()).append("'");
                                consulta.append(" and pp.COD_PROGRAMA_PROD='").append(desviacionProgramaProduccion.getProgramaProduccion().getCodProgramaProduccion()).append("'");
                        consulta.append(" GROUP BY pp.COD_COMPPROD,pp.COD_COMPPROD_VERSION,cpv.nombre_prod_semiterminado,cpv.CANTIDAD_VOLUMEN,cpv.CANTIDAD_VOLUMEN_DE_DOSIFICADO,");
                                consulta.append(" cpv.TOLERANCIA_VOLUMEN_FABRICAR,cpv.COD_AREA_EMPRESA,cpv.COD_TIPO_COMPONENTES_PROD_VERSION,pp.COD_FORMULA_MAESTRA_ES_VERSION");
                        consulta.append(" order by cpv.nombre_prod_semiterminado,cpv.CANTIDAD_VOLUMEN");
            LOGGER.debug("consulta cargar productos distintos para desviacion "+consulta.toString());
            desviacionFormulaMaestraDetalleMpList=new ArrayList<ComponentesProd>();
            res=st.executeQuery(consulta.toString());
            while(res.next())
            {
                ComponentesProd  nuevo=new ComponentesProd();
                nuevo.setCodCompprod(res.getString("COD_COMPPROD"));
                nuevo.setNombreProdSemiterminado(res.getString("nombre_prod_semiterminado"));
                nuevo.setCantidadVolumen(res.getDouble("CANTIDAD_VOLUMEN"));
                nuevo.setCantidadVolumenDeDosificado(res.getDouble("CANTIDAD_VOLUMEN_DE_DOSIFICADO"));
                nuevo.setToleranciaVolumenfabricar(res.getDouble("TOLERANCIA_VOLUMEN_FABRICAR"));
                nuevo.getAreasEmpresa().setCodAreaEmpresa(res.getString("COD_AREA_EMPRESA"));
                nuevo.setTamanioLoteProduccion(res.getInt("cantidadLoteProduccion"));
                nuevo.setCodVersion(res.getInt("COD_COMPPROD_VERSION"));
                nuevo.setFormulaMaestraEsVersion(new FormulaMaestraEsVersion());
                nuevo.getFormulaMaestraEsVersion().setCodFormulaMaestraEsVersion(res.getInt("COD_FORMULA_MAESTRA_ES_VERSION"));
                nuevo.getTiposComponentesProdVersion().setCodTipoComponentesProdVersion(res.getInt("COD_TIPO_COMPONENTES_PROD_VERSION"));
                desviacionFormulaMaestraDetalleMpList.add(nuevo);
            }
            st.close();
            con.close();
        } 
        catch (SQLException ex) 
        {
            LOGGER.warn("error", ex);
        }
        //</editor-fold>
        materialesDesviacionSelectList=new ArrayList<SelectItem>();
        this.cargarTiposMaterialProduccionSelectList();
        desviacionFormulaMaestraDetalleMpAgregar=new FormulaMaestraDetalleMP();
        
        this.cargarDesviacionFormulaMaestraMateriales();
        return null;
    }
    //</editor-fold>
    public ManagedProgramaProduccionDesviacion() {
        LOGGER=LogManager.getLogger("DesviacionProduccion");
        
    }
    // <editor-fold defaultstate="collapsed" desc="empaque secundario">
        public String eliminarDesviacionFormulaMaestraDetalleEs_action()
        {
            componentesPresProdBean.getDesviacionFormulaMaestraDetalleEsList().remove(desviacionFormulaMaestraDetalleEsEliminar);
            return null;
        }
        public String completarAgregarDesviacionFormulaMaestraDetalleEs_action()
        {
            try {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select m.NOMBRE_MATERIAL,um.COD_UNIDAD_MEDIDA,um.NOMBRE_UNIDAD_MEDIDA");
                              consulta.append(" from materiales m inner join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=m.COD_UNIDAD_MEDIDA"); 
                              consulta.append(" where m.COD_MATERIAL='").append(desviacionFormulaMaestraDetalleEsAgregar.getMateriales().getCodMaterial()).append("'");
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                while (res.next()) 
                {
                    desviacionFormulaMaestraDetalleEsAgregar.getMateriales().setNombreMaterial(res.getString("NOMBRE_MATERIAL"));
                    desviacionFormulaMaestraDetalleEsAgregar.getUnidadesMedida().setCodUnidadMedida(res.getString("COD_UNIDAD_MEDIDA"));
                    desviacionFormulaMaestraDetalleEsAgregar.getUnidadesMedida().setNombreUnidadMedida(res.getString("NOMBRE_UNIDAD_MEDIDA"));
                }
                st.close();
                con.close();
            } catch (SQLException ex) {
                LOGGER.warn("error", ex);
            }
            componentesPresProdBean.getDesviacionFormulaMaestraDetalleEsList().add(desviacionFormulaMaestraDetalleEsAgregar);
                
            return null;
        }
    //</editor-fold>
    // <editor-fold defaultstate="collapsed" desc="empaque primario">
        public String agregarDesviacionFormulaMaestraDetalleEp_action()
        {
            StringBuilder materialesRegistrados=new StringBuilder();
            for(DesviacionFormulaMaestraDetalleEp bean1:presentacionesPrimariasBean.getDesviacionFormulaMaestraDetalleEpList())
            {
                materialesRegistrados.append(materialesRegistrados.length()>0?",":"").append(bean1.getMateriales().getCodMaterial());
            }
            this.cargarMaterialesCapitulo("3",materialesRegistrados.toString());
            desviacionFormulaMaestraDetalleEpAgregar=new DesviacionFormulaMaestraDetalleEp();
            return null;
        }
        
        public String eliminarDesviacionFormulaMaestraDetalleEp_action()
        {
            presentacionesPrimariasBean.getDesviacionFormulaMaestraDetalleEpList().remove(desviacionFormulaMaestraDetalleEpEliminar);
            return null;
        }
        
        public String completarAgregarDesviacionFormulaMaestraDetalleEp_action()
        {
            try 
            {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select m.NOMBRE_MATERIAL,um.COD_UNIDAD_MEDIDA,um.NOMBRE_UNIDAD_MEDIDA");
                              consulta.append(" from materiales m inner join  UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=m.COD_UNIDAD_MEDIDA");
                              consulta.append(" where m.COD_MATERIAL='").append(desviacionFormulaMaestraDetalleEpAgregar.getMateriales().getCodMaterial()).append("'");
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                while (res.next()) 
                {
                    desviacionFormulaMaestraDetalleEpAgregar.getMateriales().setNombreMaterial(res.getString("NOMBRE_MATERIAL"));
                    desviacionFormulaMaestraDetalleEpAgregar.getUnidadesMedida().setCodUnidadMedida(res.getString("COD_UNIDAD_MEDIDA"));
                    desviacionFormulaMaestraDetalleEpAgregar.getUnidadesMedida().setNombreUnidadMedida(res.getString("NOMBRE_UNIDAD_MEDIDA"));
                    desviacionFormulaMaestraDetalleEpAgregar.setCantidad(desviacionFormulaMaestraDetalleEpAgregar.getCantidadUnitaria()*(presentacionesPrimariasBean.getCantidadPresentacionesPrimarias()));
                }
                st.close();
                con.close();
            } 
            catch (SQLException ex) 
            {
                LOGGER.warn("error", ex);
            }
            presentacionesPrimariasBean.getDesviacionFormulaMaestraDetalleEpList().add(desviacionFormulaMaestraDetalleEpAgregar);
            return null;
        }
        public String completarEditarDesviacionFormulaMaestraDetalleEp_action()
        {
            desviacionFormulaMaestraDetalleEpEditar.setCantidad(desviacionFormulaMaestraDetalleEpEditar.getCantidadUnitaria()*(presentacionesPrimariasBean.getCantidadPresentacionesPrimarias()));
            return null;
        }
        
    //</editor-fold>
    // <editor-fold defaultstate="collapsed" desc="materia prima">
        // <editor-fold defaultstate="collapsed" desc="fracciones de materia prima">
            public String completarEditarFraccionesFormulaMaestraDetalleMp_action()
            {
                
                for(FormulaMaestraDetalleMPfracciones bean:desviacionFormulaMaestraDetalleMpEditarFraccion.getFormulaMaestraDetalleMPfraccionesList())
                {
                    bean.setPorcientoFraccion(bean.getCantidad()/desviacionFormulaMaestraDetalleMpEditarFraccion.getCantidadTotalGramos()*100);
                }
                return null;
            }
            public String agregarFraccionDesviacionFormulaMaestraDetalleMp_action()
            {
                FormulaMaestraDetalleMPfracciones nuevo=new FormulaMaestraDetalleMPfracciones();
                desviacionFormulaMaestraDetalleMpEditarFraccion.getFormulaMaestraDetalleMPfraccionesList().add(nuevo);
                return null;
            }
            public String eliminarFraccionDesviacionFormulaMaestraDetalleMp_action()
            {
                desviacionFormulaMaestraDetalleMpEditarFraccion.getFormulaMaestraDetalleMPfraccionesList().remove(desviacionFormulaMaestraDetalleMpFraccionesEliminar);
                return null;
            }
        //</editor-fold>
            
        public String codMaterialDesviacionFormulaMaestraDetalleMpAgregar_change()
        {
            try {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select um.COD_UNIDAD_MEDIDA,um.NOMBRE_UNIDAD_MEDIDA,um.ABREVIATURA,tm.COD_TIPO_MEDIDA,tm.NOMBRE_TIPO_MEDIDA");
                                                    consulta.append(" ,m.COD_MATERIAL,m.NOMBRE_MATERIAL,e.VALOR_EQUIVALENCIA as equivalenciaG,eml.VALOR_EQUIVALENCIA as equivalenciaMl");
                                                    consulta.append(" ,er.COD_ESTADO_REGISTRO,er.NOMBRE_ESTADO_REGISTRO");
                                            consulta.append(" from materiales m ");
                                                    consulta.append(" inner join ESTADOS_REFERENCIALES er on er.COD_ESTADO_REGISTRO=m.COD_ESTADO_REGISTRO");
                                                    consulta.append(" inner join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=m.COD_UNIDAD_MEDIDA");
                                                    consulta.append(" inner join TIPOS_MEDIDA tm on tm.COD_TIPO_MEDIDA=um.COD_TIPO_MEDIDA");
                                                    consulta.append(" left outer join EQUIVALENCIAS e on e.COD_UNIDAD_MEDIDA =m.COD_UNIDAD_MEDIDA");
                                                            consulta.append(" and e.COD_UNIDAD_MEDIDA2 = 7 and e.COD_ESTADO_REGISTRO = 1");
                                                    consulta.append(" left outer join EQUIVALENCIAS eml on eml.COD_UNIDAD_MEDIDA =m.COD_UNIDAD_MEDIDA");
                                                            consulta.append(" and eml.COD_UNIDAD_MEDIDA2 = 2 and eml.COD_ESTADO_REGISTRO = 1");
                                            consulta.append(" where m.COD_MATERIAL=").append(desviacionFormulaMaestraDetalleMpAgregar.getMateriales().getCodMaterial());
                LOGGER.debug("consulta cargar datos material "+consulta.toString());
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                if(res.next()) 
                {
                    desviacionFormulaMaestraDetalleMpAgregar.setEquivalenciaAGramos(res.getDouble("equivalenciaG"));
                    desviacionFormulaMaestraDetalleMpAgregar.setEquivalenciaAMiliLitros(res.getDouble("equivalenciaMl"));
                    desviacionFormulaMaestraDetalleMpAgregar.getMateriales().setCodMaterial(res.getString("COD_MATERIAL"));
                    desviacionFormulaMaestraDetalleMpAgregar.getMateriales().setNombreMaterial(res.getString("NOMBRE_MATERIAL"));
                    desviacionFormulaMaestraDetalleMpAgregar.getMateriales().getEstadoRegistro().setCodEstadoRegistro(res.getString("COD_ESTADO_REGISTRO"));
                    desviacionFormulaMaestraDetalleMpAgregar.getMateriales().getEstadoRegistro().setNombreEstadoRegistro(res.getString("NOMBRE_ESTADO_REGISTRO"));
                    desviacionFormulaMaestraDetalleMpAgregar.getUnidadesMedida().setCodUnidadMedida(res.getString("COD_UNIDAD_MEDIDA"));
                    desviacionFormulaMaestraDetalleMpAgregar.getUnidadesMedida().setAbreviatura(res.getString("ABREVIATURA"));
                    desviacionFormulaMaestraDetalleMpAgregar.getUnidadesMedida().setNombreUnidadMedida(res.getString("NOMBRE_UNIDAD_MEDIDA"));
                    desviacionFormulaMaestraDetalleMpAgregar.getUnidadesMedida().getTipoMedida().setCodTipoMedida(res.getInt("COD_TIPO_MEDIDA"));
                    desviacionFormulaMaestraDetalleMpAgregar.getUnidadesMedida().getTipoMedida().setNombre_tipo_medida(res.getString("NOMBRE_TIPO_MEDIDA"));
                    
                }

                mensaje = "1";
            } catch (SQLException ex) {
                LOGGER.warn(ex.getMessage());
            } catch (NumberFormatException ex) {
                LOGGER.warn(ex.getMessage());
            } finally {
                this.cerrarConexion(con);
            }
            return null;
        }
        public String codTipoMaterialDesviacionFormulaMaestraDetalleMpAgregar_change()
        {
            StringBuilder materialesRegistrados=new StringBuilder();
            for(TiposMaterialProduccion beanT:componentesProdBean.getDesviacionFormulaMaestraDetalleMpList())
            {
                if(beanT.getCodTipoMaterialProduccion()==desviacionFormulaMaestraDetalleMpAgregar.getTiposMaterialProduccion().getCodTipoMaterialProduccion())
                {
                    for(FormulaMaestraDetalleMP bean1:beanT.getFormulaMaestraDetalleMPList())
                    {
                        materialesRegistrados.append(materialesRegistrados.length()>0?",":"").append(bean1.getMateriales().getCodMaterial());
                    }
                }
            }
            this.cargarMaterialesCapitulo("2",materialesRegistrados.toString());
            return null;
        }
        public String agregarDesviacionFormulaMaestraDetalleMP_action()
        {
            desviacionFormulaMaestraDetalleMpAgregar=new FormulaMaestraDetalleMP();
            desviacionFormulaMaestraDetalleMpAgregar.setFormulaMaestraDetalleMPfraccionesList(new ArrayList<FormulaMaestraDetalleMPfracciones>());
            desviacionFormulaMaestraDetalleMpAgregar.getTiposMaterialProduccion().setCodTipoMaterialProduccion(Integer.valueOf(tiposMaterialProduccionSelectList.get(0).getValue().toString()));
            codTipoMaterialDesviacionFormulaMaestraDetalleMpAgregar_change();

            return null;
        }    
        public String eliminarMaterialesDesviacionFormulaMaestraMP_action()
        {
            tiposMaterialProduccionBean.getFormulaMaestraDetalleMPList().remove(desviacionFormulaMaestraDetalleMpEliminar);
            return null;
        }
            
        public String completarEditarFormulaMaestraAgregarMp_action()
        {
            // <editor-fold defaultstate="collapsed" desc="calculand ingremento de volumen de acuerdo al producto">
                    Double incrementoVolumen=(componentesProdBean.getAreasEmpresa().getCodAreaEmpresa().equals("81")?
                                            (componentesProdBean.getCantidadVolumenDeDosificado()/componentesProdBean.getCantidadVolumen()):1);
                    //</editor-fold>
            // <editor-fold defaultstate="collapsed" desc="calculando cantidad total del lote">
                desviacionFormulaMaestraDetalleMpEditar.setCantidadTotalGramos(desviacionFormulaMaestraDetalleMpEditar.getCantidadUnitariaGramos()*componentesProdBean.getTamanioLoteProduccion()*incrementoVolumen);
                desviacionFormulaMaestraDetalleMpEditar.setCantidadTotalGramos(desviacionFormulaMaestraDetalleMpEditar.getCantidadTotalGramos()+(desviacionFormulaMaestraDetalleMpEditar.getCantidadTotalGramos()*componentesProdBean.getToleranciaVolumenfabricar()/100));
                desviacionFormulaMaestraDetalleMpEditar.setCantidadTotalGramos(Util.redondeoProduccionSuperior(desviacionFormulaMaestraDetalleMpEditar.getCantidadTotalGramos(),9));
                if(desviacionFormulaMaestraDetalleMpEditar.getUnidadesMedida().getTipoMedida().getCodTipoMedida()!=2)
                {
                    desviacionFormulaMaestraDetalleMpEditar.setCantidad(desviacionFormulaMaestraDetalleMpEditar.getCantidadTotalGramos()*(1/desviacionFormulaMaestraDetalleMpEditar.getEquivalenciaAMiliLitros())*(1d/desviacionFormulaMaestraDetalleMpEditar.getDensidadMaterial()));
                }
                else
                {
                    desviacionFormulaMaestraDetalleMpEditar.setCantidad(desviacionFormulaMaestraDetalleMpEditar.getCantidadTotalGramos()*(1/desviacionFormulaMaestraDetalleMpEditar.getEquivalenciaAGramos()));
                }

                if(desviacionFormulaMaestraDetalleMpEditar.isAplicaCantidadMaximaPorFraccion())
                {
                    desviacionFormulaMaestraDetalleMpEditar.setFormulaMaestraDetalleMPfraccionesList(new ArrayList<FormulaMaestraDetalleMPfracciones>());
                    Double cantidadFraccion=desviacionFormulaMaestraDetalleMpEditar.getCantidadTotalGramos();
                    while(cantidadFraccion>0.01)
                    {
                        FormulaMaestraDetalleMPfracciones bean=new FormulaMaestraDetalleMPfracciones();
                        bean.setCantidad(desviacionFormulaMaestraDetalleMpEditar.getCantidadMaximaMaterialPorFraccion()<cantidadFraccion?desviacionFormulaMaestraDetalleMpEditar.getCantidadMaximaMaterialPorFraccion():cantidadFraccion);
                        desviacionFormulaMaestraDetalleMpEditar.getFormulaMaestraDetalleMPfraccionesList().add(bean);
                        cantidadFraccion-=desviacionFormulaMaestraDetalleMpEditar.getCantidadMaximaMaterialPorFraccion();
                    }
                }
                else
                {
                    for(FormulaMaestraDetalleMPfracciones bean:desviacionFormulaMaestraDetalleMpEditar.getFormulaMaestraDetalleMPfraccionesList())
                    {
                        bean.setCantidad(desviacionFormulaMaestraDetalleMpEditar.getCantidadTotalGramos()*(bean.getPorcientoFraccion()/100));
                    }

                }
            //</editor-fold>

            return null;
        }
        public String completarAdicionFormulaMaestraAgregarMp_action()
        {
            // <editor-fold defaultstate="collapsed" desc="calculand ingremento de volumen de acuerdo al producto">
                    Double incrementoVolumen=(componentesProdBean.getAreasEmpresa().getCodAreaEmpresa().equals("81")?
                                            (componentesProdBean.getCantidadVolumenDeDosificado()/componentesProdBean.getCantidadVolumen()):1);
                    //</editor-fold>
            // <editor-fold defaultstate="collapsed" desc="calculando cantidad total del lote">
                desviacionFormulaMaestraDetalleMpAgregar.setCantidadTotalGramos(desviacionFormulaMaestraDetalleMpAgregar.getCantidadUnitariaGramos()*componentesProdBean.getTamanioLoteProduccion()*incrementoVolumen);
                desviacionFormulaMaestraDetalleMpAgregar.setCantidadTotalGramos(desviacionFormulaMaestraDetalleMpAgregar.getCantidadTotalGramos()+(desviacionFormulaMaestraDetalleMpAgregar.getCantidadTotalGramos()*componentesProdBean.getToleranciaVolumenfabricar()/100));
                desviacionFormulaMaestraDetalleMpAgregar.setCantidadTotalGramos(Util.redondeoProduccionSuperior(desviacionFormulaMaestraDetalleMpAgregar.getCantidadTotalGramos(),9));
                if(desviacionFormulaMaestraDetalleMpAgregar.getUnidadesMedida().getTipoMedida().getCodTipoMedida()!=2)
                {
                    desviacionFormulaMaestraDetalleMpAgregar.setCantidad(desviacionFormulaMaestraDetalleMpAgregar.getCantidadTotalGramos()*(1/desviacionFormulaMaestraDetalleMpAgregar.getEquivalenciaAMiliLitros())*(1d/desviacionFormulaMaestraDetalleMpAgregar.getDensidadMaterial()));
                }
                else
                {
                    desviacionFormulaMaestraDetalleMpAgregar.setCantidad(desviacionFormulaMaestraDetalleMpAgregar.getCantidadTotalGramos()*(1/desviacionFormulaMaestraDetalleMpAgregar.getEquivalenciaAGramos()));
                }
                desviacionFormulaMaestraDetalleMpAgregar.setFormulaMaestraDetalleMPfraccionesList(new ArrayList<FormulaMaestraDetalleMPfracciones>());
                if(desviacionFormulaMaestraDetalleMpAgregar.isAplicaCantidadMaximaPorFraccion())
                {
                    Double cantidadFraccion=desviacionFormulaMaestraDetalleMpAgregar.getCantidadTotalGramos();
                    while(cantidadFraccion>0.01)
                    {
                        FormulaMaestraDetalleMPfracciones bean=new FormulaMaestraDetalleMPfracciones();
                        bean.setCantidad(desviacionFormulaMaestraDetalleMpAgregar.getCantidadMaximaMaterialPorFraccion()<cantidadFraccion?desviacionFormulaMaestraDetalleMpAgregar.getCantidadMaximaMaterialPorFraccion():cantidadFraccion);
                        desviacionFormulaMaestraDetalleMpAgregar.getFormulaMaestraDetalleMPfraccionesList().add(bean);
                        cantidadFraccion-=desviacionFormulaMaestraDetalleMpAgregar.getCantidadMaximaMaterialPorFraccion();
                    }
                }
                else
                {
                    FormulaMaestraDetalleMPfracciones bean=new FormulaMaestraDetalleMPfracciones();
                    bean.setCantidad(desviacionFormulaMaestraDetalleMpAgregar.getCantidadTotalGramos());
                    bean.setPorcientoFraccion(100d);
                    desviacionFormulaMaestraDetalleMpAgregar.getFormulaMaestraDetalleMPfraccionesList().add(bean);
                }
            //</editor-fold>
            for(TiposMaterialProduccion bean:componentesProdBean.getDesviacionFormulaMaestraDetalleMpList())
            {
                if(bean.getCodTipoMaterialProduccion() == desviacionFormulaMaestraDetalleMpAgregar.getTiposMaterialProduccion().getCodTipoMaterialProduccion())
                {
                    bean.getFormulaMaestraDetalleMPList().add(desviacionFormulaMaestraDetalleMpAgregar);
                    return null;
                }
            }
            // <editor-fold defaultstate="collapsed" desc="tipos material produccion">
                try 
                {
                    con = Util.openConnection(con);
                    StringBuilder consulta = new StringBuilder("select tmp.COD_TIPO_MATERIAL_PRODUCCION,tmp.NOMBRE_TIPO_MATERIAL_PRODUCCION");
                                                consulta.append(" from TIPOS_MATERIAL_PRODUCCION tmp");
                                                consulta.append(" where tmp.COD_TIPO_MATERIAL_PRODUCCION=").append(desviacionFormulaMaestraDetalleMpAgregar.getTiposMaterialProduccion().getCodTipoMaterialProduccion());
                    Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    ResultSet res = st.executeQuery(consulta.toString());
                    if(res.next()){
                        TiposMaterialProduccion nuevo=new TiposMaterialProduccion();
                        nuevo.setCodTipoMaterialProduccion(res.getInt("COD_TIPO_MATERIAL_PRODUCCION"));
                        nuevo.setNombreTipoMaterialProduccion(res.getString("NOMBRE_TIPO_MATERIAL_PRODUCCION"));
                        nuevo.setFormulaMaestraDetalleMPList(new ArrayList<FormulaMaestraDetalleMP>());
                        nuevo.getFormulaMaestraDetalleMPList().add(desviacionFormulaMaestraDetalleMpAgregar);
                        componentesProdBean.getDesviacionFormulaMaestraDetalleMpList().add(nuevo);
                    }

                } catch (SQLException ex) {
                    LOGGER.warn(ex.getMessage());
                } catch (NumberFormatException ex) {
                    LOGGER.warn(ex.getMessage());
                } finally {
                    this.cerrarConexion(con);
                }
            //</editor-fold>
            return null;
        }
        
    
    //</editor-fold>
    private void cargarDesviacionFormulaMaestraMateriales()
    {
        try 
        {
            con = Util.openConnection(con);
            // <editor-fold defaultstate="collapsed" desc="Materia prima">
                StringBuilder consulta=new StringBuilder("select distinct fmv.COD_FORMULA_MAESTRA, m.NOMBRE_MATERIAL,fmdv.CANTIDAD as CANTIDAD,");
                                                consulta.append(" um.NOMBRE_UNIDAD_MEDIDA,m.cod_material,fmdv.nro_preparaciones,m.cod_grupo,er.nombre_estado_registro");
                                                consulta.append(" ,fmdv.CANTIDAD_UNITARIA_GRAMOS,fmdv.CANTIDAD_MAXIMA_MATERIAL_POR_FRACCION");
                                                consulta.append(" ,fmdv.DENSIDAD_MATERIAL,tmp.COD_TIPO_MATERIAL_PRODUCCION,tmp.NOMBRE_TIPO_MATERIAL_PRODUCCION");
                                                consulta.append(",e.VALOR_EQUIVALENCIA as equivalenciaG,eml.VALOR_EQUIVALENCIA as equivalenciaMl,um.COD_TIPO_MEDIDA,fmdv.COD_FORMULA_MAESTRA_DETALLE_MP_VERSION");
                                                consulta.append(",isnull(ffme.COD_FORMA,0) as registradoNoSuma,fmdv.COD_UNIDAD_MEDIDA");
                                        consulta.append(" FROM PROGRAMA_PRODUCCION pp ");
                                                consulta.append(" inner join COMPONENTES_PROD_VERSION cpv on cpv.COD_VERSION=pp.COD_COMPPROD_VERSION");
                                                        consulta.append(" and cpv.COD_COMPPROD=pp.COD_COMPPROD");      
                                                consulta.append(" inner join FORMULA_MAESTRA_VERSION fmv on pp.COD_FORMULA_MAESTRA=fmv.COD_FORMULA_MAESTRA");
                                                        consulta.append(" and fmv.COD_VERSION=pp.COD_FORMULA_MAESTRA_VERSION");
                                                consulta.append(" inner join FORMULA_MAESTRA_DETALLE_MP_VERSION fmdv on fmv.COD_FORMULA_MAESTRA=fmdv.COD_FORMULA_MAESTRA");
                                                        consulta.append(" and fmv.COD_VERSION=fmdv.COD_VERSION ");
                                                consulta.append(" inner join MATERIALES m on m.COD_MATERIAL=fmdv.COD_MATERIAL ");
                                                consulta.append(" inner join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=fmdv.COD_UNIDAD_MEDIDA");
                                                consulta.append(" inner join ESTADOS_REFERENCIALES er on er.COD_ESTADO_REGISTRO=m.COD_ESTADO_REGISTRO");
                                                consulta.append(" inner join TIPOS_MATERIAL_PRODUCCION tmp on tmp.COD_TIPO_MATERIAL_PRODUCCION=fmdv.COD_TIPO_MATERIAL_PRODUCCION");
                                                consulta.append(" left outer join EQUIVALENCIAS e on e.COD_UNIDAD_MEDIDA=fmdv.COD_UNIDAD_MEDIDA");
                                                        consulta.append(" and e.COD_UNIDAD_MEDIDA2=7 and e.COD_ESTADO_REGISTRO=1");
                                                consulta.append(" left outer join EQUIVALENCIAS eml on eml.COD_UNIDAD_MEDIDA=fmdv.COD_UNIDAD_MEDIDA");
                                                        consulta.append(" and eml.COD_UNIDAD_MEDIDA2=2 and eml.COD_ESTADO_REGISTRO=1");
                                                consulta.append(" left outer join FORMAS_FARMACEUTICAS_MATERIALES_EXCEPCION_SUMA_TOTAL ffme");
                                                        consulta.append(" on ffme.COD_MATERIAL=fmdv.COD_MATERIAL and ffme.COD_TIPO_MATERIAL=fmdv.COD_TIPO_MATERIAL_PRODUCCION");
                                                        consulta.append(" and ffme.COD_FORMA=cpv.COD_FORMA");
                                        consulta.append(" where pp.COD_PROGRAMA_PROD=").append(desviacionProgramaProduccion.getProgramaProduccion().getCodProgramaProduccion());
                                                consulta.append(" and pp.COD_LOTE_PRODUCCION='").append(desviacionProgramaProduccion.getProgramaProduccion().getCodLoteProduccion()).append("'");
                                                consulta.append(" and pp.COD_COMPPROD=?");
                                        consulta.append(" order by tmp.COD_TIPO_MATERIAL_PRODUCCION,m.NOMBRE_MATERIAL");
                LOGGER.debug("consulta cargar desviacion mp PSTmAT"+consulta);
                PreparedStatement pst=con.prepareStatement(consulta.toString());
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res;
                consulta=new StringBuilder(" select sum(fmdf.PORCIENTO_FRACCION)/count(*) as porcientoFraccion,fmdf.COD_FORMULA_MAESTRA_FRACCIONES");
                            consulta.append(" FROM PROGRAMA_PRODUCCION pp");
                                    consulta.append(" inner join FORMULA_MAESTRA_DETALLE_MP_FRACCIONES_VERSION fmdf on fmdf.COD_FORMULA_MAESTRA=pp.COD_FORMULA_MAESTRA");
                                    consulta.append(" and fmdf.COD_VERSION=pp.COD_FORMULA_MAESTRA_VERSION");
                            consulta.append(" where pp.COD_PROGRAMA_PROD=").append(desviacionProgramaProduccion.getProgramaProduccion().getCodProgramaProduccion());
                                    consulta.append(" and pp.COD_LOTE_PRODUCCION='").append(desviacionProgramaProduccion.getProgramaProduccion().getCodLoteProduccion()).append("'");
                                    consulta.append(" and pp.COD_COMPPROD = ?");
                                    consulta.append(" and fmdf.COD_MATERIAL=?");
                            consulta.append(" group by fmdf.COD_FORMULA_MAESTRA_FRACCIONES");
                            consulta.append(" order by fmdf.COD_FORMULA_MAESTRA_FRACCIONES");
                LOGGER.debug(" consulta fracciones pstFraccion "+consulta.toString());
                PreparedStatement pstFraccion=con.prepareStatement(consulta.toString());
                ResultSet resFraccion;
                for(ComponentesProd bean:desviacionFormulaMaestraDetalleMpList)
                {
                    // <editor-fold defaultstate="collapsed" desc="calculand ingremento de volumen de acuerdo al producto">
                    Double incrementoVolumen=(bean.getAreasEmpresa().getCodAreaEmpresa().equals("81")?
                                            (bean.getCantidadVolumenDeDosificado()/bean.getCantidadVolumen()):1);
                    //</editor-fold>

                    bean.setDesviacionFormulaMaestraDetalleMpList(new ArrayList<TiposMaterialProduccion>());
                    pst.setString(1,bean.getCodCompprod());LOGGER.info("PSTmAT p1:"+bean.getCodCompprod());

                    res=pst.executeQuery();
                    TiposMaterialProduccion tipo=new TiposMaterialProduccion();
                    while (res.next()) 
                    {
                        if(tipo.getCodTipoMaterialProduccion()!=res.getInt("COD_TIPO_MATERIAL_PRODUCCION"))
                        {
                            if(tipo.getCodTipoMaterialProduccion()>0)
                            {
                                bean.getDesviacionFormulaMaestraDetalleMpList().add(tipo);
                            }
                            tipo=new TiposMaterialProduccion();
                            tipo.setCodTipoMaterialProduccion(res.getInt("COD_TIPO_MATERIAL_PRODUCCION"));
                            tipo.setNombreTipoMaterialProduccion(res.getString("NOMBRE_TIPO_MATERIAL_PRODUCCION"));
                            tipo.setFormulaMaestraDetalleMPList(new ArrayList<FormulaMaestraDetalleMP>());
                        }
                        FormulaMaestraDetalleMP nuevo=new FormulaMaestraDetalleMP();
                        nuevo.getUnidadesMedida().setCodUnidadMedida(res.getString("COD_UNIDAD_MEDIDA"));
                        nuevo.getUnidadesMedida().setNombreUnidadMedida(res.getString("NOMBRE_UNIDAD_MEDIDA"));
                        nuevo.setMaterialExcepcionSumaTotal(res.getInt("registradoNoSuma")>0);
                        nuevo.getUnidadesMedida().getTipoMedida().setCodTipoMedida(res.getInt("COD_TIPO_MEDIDA"));
                        nuevo.setEquivalenciaAGramos(res.getDouble("equivalenciaG"));
                        nuevo.setEquivalenciaAMiliLitros(res.getDouble("equivalenciaMl"));
                        nuevo.getFormulaMaestra().setCodFormulaMaestra(res.getString(1));
                        nuevo.getTiposMaterialProduccion().setCodTipoMaterialProduccion(res.getInt("COD_TIPO_MATERIAL_PRODUCCION"));
                        nuevo.getTiposMaterialProduccion().setNombreTipoMaterialProduccion(res.getString("NOMBRE_TIPO_MATERIAL_PRODUCCION"));
                        nuevo.getMateriales().setNombreMaterial(res.getString(2));
                        nuevo.setCantidadUnitariaGramos(res.getDouble("CANTIDAD_UNITARIA_GRAMOS"));
                        nuevo.setCantidadMaximaMaterialPorFraccion(res.getDouble("CANTIDAD_MAXIMA_MATERIAL_POR_FRACCION"));
                        nuevo.setAplicaCantidadMaximaPorFraccion(res.getDouble("CANTIDAD_MAXIMA_MATERIAL_POR_FRACCION")>0);
                        nuevo.setDensidadMaterial(res.getDouble("DENSIDAD_MATERIAL"));
                        nuevo.setCodFormulaMastraDetalleMpVersion(res.getInt("COD_FORMULA_MAESTRA_DETALLE_MP_VERSION"));
                        Double cantidad =Util.redondeoProduccionSuperior(res.getDouble("CANTIDAD"), 2);
                        nuevo.setCantidad(cantidad);
                        nuevo.getUnidadesMedida().setNombreUnidadMedida(res.getString(4));
                        nuevo.getMateriales().setCodMaterial(res.getString(5));
                        nuevo.setNroPreparaciones(res.getInt(6));
                        nuevo.getMateriales().getEstadoRegistro().setNombreEstadoRegistro(res.getString("nombre_estado_registro"));
                        // <editor-fold defaultstate="collapsed" desc="calculando cantidad total del lote">
                            nuevo.setCantidadTotalGramos(nuevo.getCantidadUnitariaGramos()*bean.getTamanioLoteProduccion()*incrementoVolumen);
                            nuevo.setCantidadTotalGramos(nuevo.getCantidadTotalGramos()+(nuevo.getCantidadTotalGramos()*bean.getToleranciaVolumenfabricar()/100));
                            nuevo.setCantidadTotalGramos(Util.redondeoProduccionSuperior(nuevo.getCantidadTotalGramos(),9));
                            if(nuevo.getUnidadesMedida().getTipoMedida().getCodTipoMedida()!=2)
                            {
                                nuevo.setCantidad(nuevo.getCantidadTotalGramos()*(1/nuevo.getEquivalenciaAMiliLitros())*(1d/nuevo.getDensidadMaterial()));
                            }
                            else
                            {
                                nuevo.setCantidad(nuevo.getCantidadTotalGramos()*(1/nuevo.getEquivalenciaAGramos()));
                            }
                        //</editor-fold>
                        // <editor-fold defaultstate="collapsed" desc="cantidad por fraccion">
                            nuevo.setFormulaMaestraDetalleMPfraccionesList(new ArrayList<FormulaMaestraDetalleMPfracciones>());
                            if(nuevo.isAplicaCantidadMaximaPorFraccion())
                            {
                                Double cantidadFraccion=nuevo.getCantidadTotalGramos();
                                while(cantidadFraccion>0.01)
                                {
                                    FormulaMaestraDetalleMPfracciones bean1=new FormulaMaestraDetalleMPfracciones();
                                    bean1.setCantidad(nuevo.getCantidadMaximaMaterialPorFraccion()<cantidadFraccion?nuevo.getCantidadMaximaMaterialPorFraccion():cantidadFraccion);
                                    nuevo.getFormulaMaestraDetalleMPfraccionesList().add(bean1);
                                    cantidadFraccion-=nuevo.getCantidadMaximaMaterialPorFraccion();
                                }
                            }
                            else
                            {
                                pstFraccion.setString(1,bean.getCodCompprod());LOGGER.info("pstFraccion p1:"+bean.getCodCompprod());
                                pstFraccion.setString(2,nuevo.getMateriales().getCodMaterial());LOGGER.info("pstFraccion p1:"+nuevo.getMateriales().getCodMaterial());
                                resFraccion=pstFraccion.executeQuery();
                                while(resFraccion.next())
                                {
                                    FormulaMaestraDetalleMPfracciones bean1=new FormulaMaestraDetalleMPfracciones();
                                    bean1.setCantidad(nuevo.getCantidadTotalGramos()*resFraccion.getDouble("porcientoFraccion")/100);
                                    bean1.setPorcientoFraccion(resFraccion.getDouble("porcientoFraccion"));
                                    nuevo.getFormulaMaestraDetalleMPfraccionesList().add(bean1);
                                }
                            }
                        //</editor-fold>

                        tipo.getFormulaMaestraDetalleMPList().add(nuevo);
                    }
                    if(tipo.getCodTipoMaterialProduccion()>0)
                    {
                        bean.getDesviacionFormulaMaestraDetalleMpList().add(tipo);
                    }
                }
            //</editor-fold>
            // <editor-fold defaultstate="collapsed" desc="empaque primario">

            consulta=new StringBuilder("select tpp.NOMBRE_TIPO_PROGRAMA_PROD,ppv.COD_PRESENTACION_PRIMARIA,ep.nombre_envaseprim,ppv.CANTIDAD,");
                            consulta.append(" m.COD_MATERIAL,m.NOMBRE_MATERIAL,um.COD_UNIDAD_MEDIDA,um.NOMBRE_UNIDAD_MEDIDA" );
                            consulta.append(" ,sum(pp.CANT_LOTE_PRODUCCION) as cantidadLote");
                            consulta.append(" ,pp.COD_TIPO_PROGRAMA_PROD,pp.COD_COMPPROD,fmdep.CANTIDAD_UNITARIA,ppv.COD_ENVASEPRIM");
                    consulta.append(" from PROGRAMA_PRODUCCION pp");
                            consulta.append(" inner join FORMULA_MAESTRA_VERSION fmv on fmv.COD_VERSION=pp.COD_FORMULA_MAESTRA_VERSION");
                                    consulta.append(" and pp.COD_FORMULA_MAESTRA=fmv.COD_FORMULA_MAESTRA");
                            consulta.append(" INNER JOIN TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD");
                            consulta.append(" inner join PRESENTACIONES_PRIMARIAS_VERSION ppv on ppv.COD_COMPPROD=pp.COD_COMPPROD");
                                    consulta.append(" and ppv.COD_VERSION=pp.COD_COMPPROD_VERSION");
                                    consulta.append(" and  ppv.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD");
                            consulta.append(" inner join ENVASES_PRIMARIOS ep on ep.cod_envaseprim=ppv.COD_ENVASEPRIM");
                            consulta.append(" left outer join FORMULA_MAESTRA_DETALLE_EP_VERSION fmdep on fmdep.COD_FORMULA_MAESTRA=fmv.COD_FORMULA_MAESTRA");
                                    consulta.append(" and fmdep.COD_VERSION=fmv.COD_VERSION and fmdep.COD_PRESENTACION_PRIMARIA=ppv.COD_PRESENTACION_PRIMARIA");
                            consulta.append(" left outer join materiales m on m.COD_MATERIAL=fmdep.COD_MATERIAL");
                            consulta.append(" left outer join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=fmdep.COD_UNIDAD_MEDIDA");
                                    
                    consulta.append(" where pp.COD_LOTE_PRODUCCION='").append(desviacionProgramaProduccion.getProgramaProduccion().getCodLoteProduccion()).append("'");
                            consulta.append(" and pp.COD_PROGRAMA_PROD=").append(desviacionProgramaProduccion.getProgramaProduccion().getCodProgramaProduccion());
                    consulta.append(" group by tpp.NOMBRE_TIPO_PROGRAMA_PROD,ppv.COD_PRESENTACION_PRIMARIA,ep.nombre_envaseprim,ppv.CANTIDAD,");
                            consulta.append(" m.COD_MATERIAL,m.NOMBRE_MATERIAL,um.COD_UNIDAD_MEDIDA,um.NOMBRE_UNIDAD_MEDIDA");
                            consulta.append(" ,pp.COD_TIPO_PROGRAMA_PROD,fmdep.CANTIDAD_UNITARIA,pp.COD_COMPPROD,ppv.COD_ENVASEPRIM");
                    consulta.append(" order by ppv.COD_PRESENTACION_PRIMARIA");
            LOGGER.debug("consulta cargar desviacion ep "+consulta.toString());
            res=st.executeQuery(consulta.toString());
            desviacionFormulaMaestraEpList=new ArrayList<PresentacionesPrimarias>();
            PresentacionesPrimarias bean=new PresentacionesPrimarias();
            DesviacionFormulaMaestraDetalleEp beanEp=new DesviacionFormulaMaestraDetalleEp();
            presentacionesPrimariasSelectList=new ArrayList<SelectItem>();
            while(res.next())
            {
                if(!bean.getCodPresentacionPrimaria().equals(res.getString("COD_PRESENTACION_PRIMARIA")))
                {
                    if(Integer.valueOf(bean.getCodPresentacionPrimaria())>0)
                    {
                        desviacionFormulaMaestraEpList.add(bean);
                        presentacionesPrimariasSelectList.add(new SelectItem(bean.getCodPresentacionPrimaria(),bean.getTiposProgramaProduccion().getNombreTipoProgramaProd()+"("+bean.getEnvasesPrimarios().getNombreEnvasePrim()+")"));
                    }
                    bean=new PresentacionesPrimarias();
                    bean.setCantidadLote(res.getDouble("cantidadLote"));
                    bean.setCantidadPresentacionesPrimarias(res.getDouble("cantidadLote")/res.getInt("CANTIDAD"));
                    bean.setCodPresentacionPrimaria(res.getString("COD_PRESENTACION_PRIMARIA"));
                    bean.getTiposProgramaProduccion().setNombreTipoProgramaProd(res.getString("NOMBRE_TIPO_PROGRAMA_PROD"));
                    bean.getTiposProgramaProduccion().setCodTipoProgramaProd(res.getString("COD_TIPO_PROGRAMA_PROD"));
                    bean.getEnvasesPrimarios().setNombreEnvasePrim(res.getString("nombre_envaseprim"));
                    bean.getEnvasesPrimarios().setCodEnvasePrim(res.getString("COD_ENVASEPRIM"));
                    bean.getComponentesProd().setCodCompprod(res.getString("COD_COMPPROD"));
                    bean.setCantidad(res.getInt("CANTIDAD"));
                   
                    bean.setDesviacionFormulaMaestraDetalleEpList(new ArrayList<DesviacionFormulaMaestraDetalleEp>());
                }
                if(res.getInt("COD_MATERIAL")>0)
                {
                    beanEp=new DesviacionFormulaMaestraDetalleEp();
                    beanEp.getMateriales().setCodMaterial(res.getString("COD_MATERIAL"));
                    beanEp.getMateriales().setNombreMaterial(res.getString("NOMBRE_MATERIAL"));
                    beanEp.setCantidad(bean.getCantidadPresentacionesPrimarias()*res.getDouble("CANTIDAD_UNITARIA"));
                    beanEp.setCantidadUnitaria(res.getDouble("CANTIDAD_UNITARIA"));
                    beanEp.getUnidadesMedida().setCodUnidadMedida(res.getString("COD_UNIDAD_MEDIDA"));
                    beanEp.getUnidadesMedida().setNombreUnidadMedida(res.getString("NOMBRE_UNIDAD_MEDIDA"));
                    bean.getDesviacionFormulaMaestraDetalleEpList().add(beanEp);
                }
            }
            if(Integer.valueOf(bean.getCodPresentacionPrimaria())>0)
            {
                desviacionFormulaMaestraEpList.add(bean);
                presentacionesPrimariasSelectList.add(new SelectItem(bean.getCodPresentacionPrimaria(),bean.getTiposProgramaProduccion().getNombreTipoProgramaProd()+"("+bean.getEnvasesPrimarios().getNombreEnvasePrim()+")"));
            }
            //</editor-fold>
            // <editor-fold defaultstate="collapsed" desc="empaque secundario">
                consulta=new StringBuilder("select pp.COD_TIPO_PROGRAMA_PROD,tpp.NOMBRE_TIPO_PROGRAMA_PROD,pp.COD_PRESENTACION,pp1.NOMBRE_PRODUCTO_PRESENTACION,");
                                consulta.append(" m.COD_MATERIAL,m.NOMBRE_MATERIAL,ROUND(fmdev.CANTIDAD*pp.CANT_LOTE_PRODUCCION/fmv.CANTIDAD_LOTE,2) as cantidad,um.COD_UNIDAD_MEDIDA,um.NOMBRE_UNIDAD_MEDIDA");
                                consulta.append(" ,pp.COD_COMPPROD");
                         consulta.append(" from PROGRAMA_PRODUCCION pp");
                                consulta.append(" inner join PRESENTACIONES_PRODUCTO pp1 on pp.COD_PRESENTACION=pp1.cod_presentacion");
                                consulta.append(" inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD");
                                consulta.append(" inner join FORMULA_MAESTRA_VERSION fmv on fmv.COD_VERSION=pp.COD_FORMULA_MAESTRA_VERSION and fmv.COD_FORMULA_MAESTRA=pp.COD_FORMULA_MAESTRA");
                                consulta.append(" left outer join FORMULA_MAESTRA_DETALLE_ES_VERSION fmdev on fmdev.COD_FORMULA_MAESTRA=fmv.COD_FORMULA_MAESTRA");
                                        consulta.append(" and fmdev.COD_VERSION=fmv.COD_VERSION");
                                        consulta.append(" and pp.COD_PRESENTACION=fmdev.COD_PRESENTACION_PRODUCTO");
                                        consulta.append(" and pp.COD_TIPO_PROGRAMA_PROD=fmdev.COD_TIPO_PROGRAMA_PROD");
                                        consulta.append(" and pp.COD_FORMULA_MAESTRA_ES_VERSION=fmdev.COD_FORMULA_MAESTRA_ES_VERSION");
                                consulta.append(" left outer join materiales m on m.COD_MATERIAL=fmdev.COD_MATERIAL");
                                consulta.append(" left outer join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=fmdev.COD_UNIDAD_MEDIDA");
                         consulta.append(" where pp.COD_LOTE_PRODUCCION='").append(desviacionProgramaProduccion.getProgramaProduccion().getCodLoteProduccion()).append("'");
                                consulta.append(" and pp.COD_PROGRAMA_PROD='").append(desviacionProgramaProduccion.getProgramaProduccion().getCodProgramaProduccion()).append("'");
                         consulta.append("order by tpp.NOMBRE_TIPO_PROGRAMA_PROD,pp1.NOMBRE_PRODUCTO_PRESENTACION,m.NOMBRE_MATERIAL");
                LOGGER.debug("consulta cargar desviacion es "+consulta);
                res=st.executeQuery(consulta.toString());
                desviacionFormulaMaestraEsList=new ArrayList<ComponentesPresProd>();
                ComponentesPresProd beanPP=new ComponentesPresProd();

                while(res.next())
                {
                    if((!beanPP.getPresentacionesProducto().getCodPresentacion().equals(res.getString("COD_PRESENTACION")))||(!beanPP.getTiposProgramaProduccion().getCodTipoProgramaProd().equals(res.getString("COD_TIPO_PROGRAMA_PROD"))))
                    {
                        if(beanPP.getPresentacionesProducto().getCodPresentacion().length()>0)
                        {
                            desviacionFormulaMaestraEsList.add(beanPP);
                        }
                        beanPP=new ComponentesPresProd();
                        beanPP.getPresentacionesProducto().setCodPresentacion(res.getString("COD_PRESENTACION"));
                        beanPP.getPresentacionesProducto().setNombreProductoPresentacion(res.getString("NOMBRE_PRODUCTO_PRESENTACION"));
                        beanPP.getComponentesProd().setCodCompprod(res.getString("COD_COMPPROD"));
                        beanPP.getTiposProgramaProduccion().setCodTipoProgramaProd(res.getString("COD_TIPO_PROGRAMA_PROD"));
                        beanPP.getTiposProgramaProduccion().setNombreTipoProgramaProd(res.getString("NOMBRE_TIPO_PROGRAMA_PROD"));
                        beanPP.setDesviacionFormulaMaestraDetalleEsList(new ArrayList<DesviacionFormulaMaestraDetalleEs>());
                    }
                    if(res.getInt("COD_MATERIAL")>0)
                    {
                        DesviacionFormulaMaestraDetalleEs nuevoEs =new DesviacionFormulaMaestraDetalleEs();
                        nuevoEs.getMateriales().setCodMaterial(res.getString("COD_MATERIAL"));
                        nuevoEs.getMateriales().setNombreMaterial(res.getString("NOMBRE_MATERIAL"));
                        nuevoEs.setCantidad(res.getDouble("CANTIDAD"));
                        nuevoEs.getUnidadesMedida().setCodUnidadMedida(res.getString("COD_UNIDAD_MEDIDA"));
                        nuevoEs.getUnidadesMedida().setNombreUnidadMedida(res.getString("NOMBRE_UNIDAD_MEDIDA"));
                        beanPP.getDesviacionFormulaMaestraDetalleEsList().add(nuevoEs);
                    }
                }
                if(beanPP.getPresentacionesProducto().getCodPresentacion().length()>0)
                {
                    desviacionFormulaMaestraEsList.add(beanPP);
                }
                
            //</editor-fold>
            
            st.close();
            con.close();
        }
        catch (SQLException ex) {
            LOGGER.warn("error", ex);
        }
    }
    
    
    //<editor-fold defaultstate="collapsed" desc="getter and setter">
    
    
        public String getMensaje() {
            return mensaje;
        }

        public void setMensaje(String mensaje) {
            this.mensaje = mensaje;
        }

        public List<ComponentesProd> getDesviacionFormulaMaestraDetalleMpList() {
            return desviacionFormulaMaestraDetalleMpList;
        }
        public int getDesviacionFormulaMaestraDetalleMpListSize() {
            return (desviacionFormulaMaestraDetalleMpList!=null?desviacionFormulaMaestraDetalleMpList.size():0);
        }

        public void setDesviacionFormulaMaestraDetalleMpList(List<ComponentesProd> desviacionFormulaMaestraDetalleMpList) {
            this.desviacionFormulaMaestraDetalleMpList = desviacionFormulaMaestraDetalleMpList;
        }

        public Desviacion getDesviacionProgramaProduccion() {
            return desviacionProgramaProduccion;
        }

        public void setDesviacionProgramaProduccion(Desviacion desviacionProgramaProduccion) {
            this.desviacionProgramaProduccion = desviacionProgramaProduccion;
        }

        public List<PresentacionesPrimarias> getDesviacionFormulaMaestraEpList() {
            return desviacionFormulaMaestraEpList;
        }

        public void setDesviacionFormulaMaestraEpList(List<PresentacionesPrimarias> desviacionFormulaMaestraEpList) {
            this.desviacionFormulaMaestraEpList = desviacionFormulaMaestraEpList;
        }

        public List<SelectItem> getPresentacionesPrimariasSelectList() {
            return presentacionesPrimariasSelectList;
        }

        public void setPresentacionesPrimariasSelectList(List<SelectItem> presentacionesPrimariasSelectList) {
            this.presentacionesPrimariasSelectList = presentacionesPrimariasSelectList;
        }
        


        public FormulaMaestraDetalleMPfracciones getDesviacionFormulaMaestraDetalleMpFraccionesEliminar() {
            return desviacionFormulaMaestraDetalleMpFraccionesEliminar;
        }

        public void setDesviacionFormulaMaestraDetalleMpFraccionesEliminar(FormulaMaestraDetalleMPfracciones desviacionFormulaMaestraDetalleMpFraccionesEliminar) {
            this.desviacionFormulaMaestraDetalleMpFraccionesEliminar = desviacionFormulaMaestraDetalleMpFraccionesEliminar;
        }

        

        public List<ProgramaProduccion> getProgramaProduccionDesviacionList() {
            return programaProduccionDesviacionList;
        }

        public List<ComponentesPresProd> getDesviacionFormulaMaestraEsList() {
            return desviacionFormulaMaestraEsList;
        }

        public void setDesviacionFormulaMaestraEsList(List<ComponentesPresProd> desviacionFormulaMaestraEsList) {
            this.desviacionFormulaMaestraEsList = desviacionFormulaMaestraEsList;
        }

        public void setProgramaProduccionDesviacionList(List<ProgramaProduccion> programaProduccionDesviacionList) {
            this.programaProduccionDesviacionList = programaProduccionDesviacionList;
        }

        public HtmlDataTable getProgramaProduccionDesviacionDataTable() {
            return programaProduccionDesviacionDataTable;
        }

        public void setProgramaProduccionDesviacionDataTable(HtmlDataTable programaProduccionDesviacionDataTable) {
            this.programaProduccionDesviacionDataTable = programaProduccionDesviacionDataTable;
        }

        public ProgramaProduccion getProgramaProduccionCambioPresentacion() {
            return programaProduccionCambioPresentacion;
        }

        public void setProgramaProduccionCambioPresentacion(ProgramaProduccion programaProduccionCambioPresentacion) {
            this.programaProduccionCambioPresentacion = programaProduccionCambioPresentacion;
        }

        public FormulaMaestraDetalleMP getDesviacionFormulaMaestraDetalleMpAgregar() {
            return desviacionFormulaMaestraDetalleMpAgregar;
        }

        public void setDesviacionFormulaMaestraDetalleMpAgregar(FormulaMaestraDetalleMP desviacionFormulaMaestraDetalleMpAgregar) {
            this.desviacionFormulaMaestraDetalleMpAgregar = desviacionFormulaMaestraDetalleMpAgregar;
        }

        public FormulaMaestraDetalleMP getDesviacionFormulaMaestraDetalleMpEditarFraccion() {
            return desviacionFormulaMaestraDetalleMpEditarFraccion;
        }

        public void setDesviacionFormulaMaestraDetalleMpEditarFraccion(FormulaMaestraDetalleMP desviacionFormulaMaestraDetalleMpEditarFraccion) {
            this.desviacionFormulaMaestraDetalleMpEditarFraccion = desviacionFormulaMaestraDetalleMpEditarFraccion;
        }

        public DesviacionFormulaMaestraDetalleEp getDesviacionFormulaMaestraDetalleEpAgregar() {
            return desviacionFormulaMaestraDetalleEpAgregar;
        }

        public void setDesviacionFormulaMaestraDetalleEpAgregar(DesviacionFormulaMaestraDetalleEp desviacionFormulaMaestraDetalleEpAgregar) {
            this.desviacionFormulaMaestraDetalleEpAgregar = desviacionFormulaMaestraDetalleEpAgregar;
        }

        public DesviacionFormulaMaestraDetalleEp getDesviacionFormulaMaestraDetalleEpEditar() {
            return desviacionFormulaMaestraDetalleEpEditar;
        }

        public void setDesviacionFormulaMaestraDetalleEpEditar(DesviacionFormulaMaestraDetalleEp desviacionFormulaMaestraDetalleEpEditar) {
            this.desviacionFormulaMaestraDetalleEpEditar = desviacionFormulaMaestraDetalleEpEditar;
        }

        public DesviacionFormulaMaestraDetalleEs getDesviacionFormulaMaestraDetalleEsAgregar() {
            return desviacionFormulaMaestraDetalleEsAgregar;
        }

        public void setDesviacionFormulaMaestraDetalleEsAgregar(DesviacionFormulaMaestraDetalleEs desviacionFormulaMaestraDetalleEsAgregar) {
            this.desviacionFormulaMaestraDetalleEsAgregar = desviacionFormulaMaestraDetalleEsAgregar;
        }

        public DesviacionFormulaMaestraDetalleEs getDesviacionFormulaMaestraDetalleEsEditar() {
            return desviacionFormulaMaestraDetalleEsEditar;
        }

        public void setDesviacionFormulaMaestraDetalleEsEditar(DesviacionFormulaMaestraDetalleEs desviacionFormulaMaestraDetalleEsEditar) {
            this.desviacionFormulaMaestraDetalleEsEditar = desviacionFormulaMaestraDetalleEsEditar;
        }

        public List<SelectItem> getMaterialesDesviacionSelectList() {
            return materialesDesviacionSelectList;
        }





        public FormulaMaestraDetalleMP getDesviacionFormulaMaestraDetalleMpEliminar() {
            return desviacionFormulaMaestraDetalleMpEliminar;
        }

        public TiposMaterialProduccion getTiposMaterialProduccionBean() {
            return tiposMaterialProduccionBean;
        }

        public void setTiposMaterialProduccionBean(TiposMaterialProduccion tiposMaterialProduccionBean) {
            this.tiposMaterialProduccionBean = tiposMaterialProduccionBean;
        }

        public void setDesviacionFormulaMaestraDetalleMpEliminar(FormulaMaestraDetalleMP desviacionFormulaMaestraDetalleMpEliminar) {
            this.desviacionFormulaMaestraDetalleMpEliminar = desviacionFormulaMaestraDetalleMpEliminar;
        }


        public void setMaterialesDesviacionSelectList(List<SelectItem> materialesDesviacionSelectList) {
            this.materialesDesviacionSelectList = materialesDesviacionSelectList;
        }

        public List<SelectItem> getTiposMaterialProduccionSelectList() {
            return tiposMaterialProduccionSelectList;
        }

        public FormulaMaestraDetalleMP getDesviacionFormulaMaestraDetalleMpEditar() {
            return desviacionFormulaMaestraDetalleMpEditar;
        }

        public void setDesviacionFormulaMaestraDetalleMpEditar(FormulaMaestraDetalleMP desviacionFormulaMaestraDetalleMpEditar) {
            this.desviacionFormulaMaestraDetalleMpEditar = desviacionFormulaMaestraDetalleMpEditar;
        }

        public DesviacionFormulaMaestraDetalleEs getDesviacionFormulaMaestraDetalleEsEliminar() {
            return desviacionFormulaMaestraDetalleEsEliminar;
        }

        public void setDesviacionFormulaMaestraDetalleEsEliminar(DesviacionFormulaMaestraDetalleEs desviacionFormulaMaestraDetalleEsEliminar) {
            this.desviacionFormulaMaestraDetalleEsEliminar = desviacionFormulaMaestraDetalleEsEliminar;
        }

        public ComponentesPresProd getComponentesPresProdBean() {
            return componentesPresProdBean;
        }

        public void setComponentesPresProdBean(ComponentesPresProd componentesPresProdBean) {
            this.componentesPresProdBean = componentesPresProdBean;
        }





        public PresentacionesPrimarias getPresentacionesPrimariasBean() {
            return presentacionesPrimariasBean;
        }

        public void setPresentacionesPrimariasBean(PresentacionesPrimarias presentacionesPrimariasBean) {
            this.presentacionesPrimariasBean = presentacionesPrimariasBean;
        }

        public DesviacionFormulaMaestraDetalleEp getDesviacionFormulaMaestraDetalleEpEliminar() {
            return desviacionFormulaMaestraDetalleEpEliminar;
        }

        public void setDesviacionFormulaMaestraDetalleEpEliminar(DesviacionFormulaMaestraDetalleEp desviacionFormulaMaestraDetalleEpEliminar) {
            this.desviacionFormulaMaestraDetalleEpEliminar = desviacionFormulaMaestraDetalleEpEliminar;
        }

    
        


        public void setTiposMaterialProduccionSelectList(List<SelectItem> tiposMaterialProduccionSelectList) {
            this.tiposMaterialProduccionSelectList = tiposMaterialProduccionSelectList;
        }

        public List<ComponentesPresProd> getComponentesPresProdDesviacionList() {
            return componentesPresProdDesviacionList;
        }

        public void setComponentesPresProdDesviacionList(List<ComponentesPresProd> componentesPresProdDesviacionList) {
            this.componentesPresProdDesviacionList = componentesPresProdDesviacionList;
        }

        public String getCodCompprodDesviacion() {
            return codCompprodDesviacion;
        }

        public void setCodCompprodDesviacion(String codCompprodDesviacion) {
            this.codCompprodDesviacion = codCompprodDesviacion;
        }

        public ComponentesProd getComponentesProdBean() {
            return componentesProdBean;
        }

        public void setComponentesProdBean(ComponentesProd componentesProdBean) {
            this.componentesProdBean = componentesProdBean;
        }
        
    
    
    
    
    //</editor-fold>

    
    

    
}
