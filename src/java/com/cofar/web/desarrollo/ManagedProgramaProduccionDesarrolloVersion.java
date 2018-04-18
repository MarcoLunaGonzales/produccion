/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.web.desarrollo;

import com.cofar.bean.ComponentesProdVersion;
import com.cofar.bean.FormulaMaestraEsVersion;
import com.cofar.bean.FormulaMaestraVersion;
import com.cofar.bean.ProgramaProduccion;
import com.cofar.bean.ProgramaProduccionPeriodo;
import com.cofar.util.Util;
import com.cofar.web.ManagedAccesoSistema;
import com.cofar.web.ManagedBean;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import org.apache.logging.log4j.LogManager;
import org.richfaces.component.html.HtmlDataTable;

/**
 *
 * @author DASISAQ
 */
public class ManagedProgramaProduccionDesarrolloVersion extends ManagedBean{

    private Connection con=null;
    private String mensaje="";
    private List<ProgramaProduccionPeriodo> programaProduccionPeriodoDesarrolloList;
    private HtmlDataTable programaProduccionPeriodoDesarrolloDataTable=new HtmlDataTable();
    private ProgramaProduccionPeriodo programaProduccionPeriodoDesarrolloBean;
    private List<ProgramaProduccion> programaProduccionDesarrolloList;
    private List<ComponentesProdVersion> componentesProdVersionDesarrolloAgregarList;
    private HtmlDataTable componentesProdVersionDesarrolloAgregarDataTable=new HtmlDataTable();
    private ProgramaProduccionPeriodo programaPeriodoDesarroloAgregar;
    private ProgramaProduccionPeriodo programaPeriodoDesarroloEditar;
    
    private ProgramaProduccion programaProduccionDesarrolloAgregar;    
    /**
     * Creates a new instance of ManagedProgramaProduccionDesarrollo
     */
    
    //<editor-fold desc="programa periodo desarrollo" defaultstate="collapsed">
        public String eliminarProgramaPeriodoDesarrollo_action()throws SQLException
        {
            mensaje="";
            for(ProgramaProduccionPeriodo bean:programaProduccionPeriodoDesarrolloList)
            {
                if(bean.getChecked())
                {
                    try
                    {
                        con = Util.openConnection(con);
                        con.setAutoCommit(false);
                        String consulta = "select count(*)  as contLotes"+
                                          " from PROGRAMA_PRODUCCION p where p.COD_PROGRAMA_PROD='"+bean.getCodProgramaProduccion()+"'";
                        LOGGER.debug("consulta verificar que el programa no tenga registrado lotes "+consulta);
                        Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                        ResultSet res=st.executeQuery(consulta);
                        res.next();
                        PreparedStatement pst=null;
                        if(res.getInt("contLotes")>0)
                        {
                            mensaje="No se puede eliminar el Programa de Produccion porque tiene registrado "+res.getInt("contLotes")+" lotes";
                        }
                        else
                        {
                            consulta="delete PROGRAMA_PRODUCCION_PERIODO  where COD_PROGRAMA_PROD='"+bean.getCodProgramaProduccion()+"'";
                            LOGGER.debug("consulta delete programa produccion periodo "+consulta);
                            pst=con.prepareStatement(consulta);
                            if(pst.executeUpdate()>0)LOGGER.info("se elimino el programa de produccion periodo");
                            mensaje="1";
                        }
                        con.commit();

                        if(pst!=null)pst.close();
                        con.close();
                    }
                    catch (SQLException ex)
                    {
                        con.rollback();
                        con.close();
                        mensaje="Ocurrio un error al momento de eliminar el programa periodo, intente de nuevo";
                        LOGGER.warn("error", ex);
                    }
                }
            }
            if(mensaje.equals("1"))
            {
                this.cargarProgramaProduccionPeriodoDesarrollo_action();
            }
            return null;
        }
    
        public String guardarEdicionProgramaPeriodoDesarrollo_action()throws SQLException
        {
            mensaje="";
            try {
                con = Util.openConnection(con);
                con.setAutoCommit(false);
                SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");
                String consulta = "update PROGRAMA_PRODUCCION_PERIODO set" +
                                  " FECHA_INICIO='"+sdf.format(programaPeriodoDesarroloEditar.getFechaInicio())+"',"+
                                  " FECHA_FINAL='"+sdf.format(programaPeriodoDesarroloEditar.getFechaFinal())+"',"+
                                  " OBSERVACIONES='"+programaPeriodoDesarroloEditar.getObsProgramaProduccion()+"',"+
                                  " NOMBRE_PROGRAMA_PROD='"+programaPeriodoDesarroloEditar.getNombreProgramaProduccion()+"'"+
                                  " where COD_PROGRAMA_PROD='"+programaPeriodoDesarroloEditar.getCodProgramaProduccion()+"'";
                LOGGER.debug("consulta update programa produccion periodo "+consulta);
                PreparedStatement pst = con.prepareStatement(consulta);
                if (pst.executeUpdate() > 0)LOGGER.info("se actualizo el programa de produccion periodo");
                con.commit();
                mensaje="1";
                pst.close();
                con.close();
            } catch (SQLException ex) {
                con.rollback();
                con.close();
                mensaje="Ocurrio un error al momento de guardar la edicion,intente de nuevo";
                LOGGER.warn("error", ex);
            }
            return null;
        }
        public String editarProgramaPeriodoDesarrollo_action()
        {
            for(ProgramaProduccionPeriodo bean:programaProduccionPeriodoDesarrolloList)
            {
                if(bean.getChecked())
                {
                    programaPeriodoDesarroloEditar=bean;
                }
            }
            return null;
        }
    
        public String guardarNuevoProgramaPeriodoDesarrollo_action()throws SQLException
        {
            mensaje="";
            try 
            {
                con = Util.openConnection(con);
                con.setAutoCommit(false);
                String consulta = "select isnull(MAX(pp.COD_PROGRAMA_PROD),0)+1 as codProgProd"+
                                  " from PROGRAMA_PRODUCCION_PERIODO pp";
                Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet res=st.executeQuery(consulta);
                int codProgProd=0;
                SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");
                if(res.next())codProgProd=res.getInt("codProgProd");
                consulta="INSERT INTO PROGRAMA_PRODUCCION_PERIODO(COD_PROGRAMA_PROD, NOMBRE_PROGRAMA_PROD,"+
                         " OBSERVACIONES, COD_ESTADO_PROGRAMA, FECHA_INICIO, FECHA_FINAL,"+
                         " COD_TIPO_PRODUCCION)"+
                         " VALUES ('"+codProgProd+"','"+programaPeriodoDesarroloAgregar.getNombreProgramaProduccion()+"'," +
                         "'"+programaPeriodoDesarroloAgregar.getObsProgramaProduccion()+"',"+
                         " 1, '"+sdf.format(programaPeriodoDesarroloAgregar.getFechaInicio())+"'," +
                         "'"+sdf.format(programaPeriodoDesarroloAgregar.getFechaFinal())+"',2)";
                LOGGER.debug("consulta guardar nuevo programa "+consulta);
                PreparedStatement pst = con.prepareStatement(consulta);
                if (pst.executeUpdate() > 0)LOGGER.info("se registro el nuevo programa Produccion periodo");
                con.commit();
                mensaje="1";
                pst.close();
                con.close();
            } 
            catch (SQLException ex)
            {
                mensaje="Ocurrio un error al momento de guardar el nuevo programa produccion periodo,intente de nuevo";
                con.rollback();
                con.close();
                LOGGER.warn("error", ex);
            }
            return null;
        }
        public String getCargarAgregarProgramaPeriodoDesarrollo()
        {
            programaPeriodoDesarroloAgregar=new ProgramaProduccionPeriodo();
            try {
                con = Util.openConnection(con);
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                String consulta = "select max(p.FECHA_FINAL) as fechaInicio,DATEADD(MONTH,1,max(p.FECHA_FINAL)) as fechaFin"+
                                  " from PROGRAMA_PRODUCCION_PERIODO p where p.COD_ESTADO_PROGRAMA<>4 and p.COD_TIPO_PRODUCCION=2";
                LOGGER.debug("consulta fecha inicio fin "+consulta);
                ResultSet res = st.executeQuery(consulta);
                SimpleDateFormat sdfMes=new SimpleDateFormat("MMMM yyyy",new Locale("ES"));
                while (res.next()) 
                {
                    programaPeriodoDesarroloAgregar.setFechaInicio(res.getDate("fechaInicio"));
                    programaPeriodoDesarroloAgregar.getFechaInicio().setDate(27);
                    programaPeriodoDesarroloAgregar.setFechaFinal(res.getDate("fechaFin"));
                    programaPeriodoDesarroloAgregar.getFechaFinal().setDate(26);
                    programaPeriodoDesarroloAgregar.setNombreProgramaProduccion(sdfMes.format(res.getDate("fechaFin")).toUpperCase());
                    programaPeriodoDesarroloAgregar.setObsProgramaProduccion("Programa de Desarrollo "+programaPeriodoDesarroloAgregar.getNombreProgramaProduccion().toLowerCase());
                }
                res.close();
                st.close();
                con.close();
            } catch (SQLException ex) {
                LOGGER.warn("error", ex);
            }
            return null;
        }
    
    
//</editor-fold>
    public String agregarProgramaProduccionDesarrollo_action()
    {
        this.cargarProductosDesarrolloAgregar_action();
        return null;
    }
    public String eliminarLoteDesarrollo_action()throws SQLException
    {
        
        mensaje = "";
        for(ProgramaProduccion bean:programaProduccionDesarrolloList)
        {
            if(bean.getChecked())
            {
                try {
                    con = Util.openConnection(con);
                    con.setAutoCommit(false);
                    StringBuilder consulta = new StringBuilder("delete PROGRAMA_PRODUCCION");
                                                consulta.append(" where COD_LOTE_PRODUCCION='").append(bean.getCodLoteProduccion()).append("'");
                                                        consulta.append(" and COD_PROGRAMA_PROD=").append(programaProduccionPeriodoDesarrolloBean.getCodProgramaProduccion());
                    LOGGER.debug("consulta" + consulta.toString());
                    PreparedStatement pst = con.prepareStatement(consulta.toString(), PreparedStatement.RETURN_GENERATED_KEYS);
                    if (pst.executeUpdate() > 0) {
                        LOGGER.info("se registro");
                    }
                    con.commit();
                    mensaje = "1";
                } catch (SQLException ex) {
                    mensaje = "Ocurrio un error al momento de guardar el registro";
                    LOGGER.warn(ex.getMessage());
                    con.rollback();
                } catch (Exception ex) {
                    mensaje = "Ocurrio un error al momento de guardar el registro,verifique los datos introducidos";
                    LOGGER.warn(ex.getMessage());
                } finally {
                    this.cerrarConexion(con);
                }
            }
        }
        if(mensaje.equals("1"))
        {
            this.cargarProgramaProduccionDesarrolloList();
        }
        return null;
        
    }
    
    public String seleccionarCrearLoteDesarrollo_action()throws SQLException
    {
        ComponentesProdVersion loteCrear=(ComponentesProdVersion)componentesProdVersionDesarrolloAgregarDataTable.getRowData();
        mensaje = "";
        try {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            String codLoteDesarrollo="";
            StringBuilder consulta=new StringBuilder(" exec PAA_GENERACION_NUMERO_LOTE_DESARROLLO ");
                                    consulta.append(loteCrear.getCodVersion()).append(",");
                                    consulta.append(programaProduccionPeriodoDesarrolloBean.getCodProgramaProduccion()).append(",");
                                    consulta.append("?");
            LOGGER.debug("consulta obtener numero lote desarrollo "+consulta.toString());
            CallableStatement cstNroLote = con.prepareCall(consulta.toString());
            cstNroLote.registerOutParameter(1,java.sql.Types.VARCHAR);
            cstNroLote.execute();
            codLoteDesarrollo=cstNroLote.getString(1);
            LOGGER.info("nro lote obtenido "+codLoteDesarrollo);
            consulta = new StringBuilder(" insert into programa_produccion(cod_programa_prod,cod_formula_maestra,cod_lote_produccion, ");
                        consulta.append(" cod_estado_programa,observacion,CANT_LOTE_PRODUCCION,VERSION_LOTE,COD_COMPPROD,COD_TIPO_PROGRAMA_PROD,COD_PRESENTACION,nro_lotes");
                        consulta.append(",COD_COMPPROD_PADRE,cod_compprod_version,cod_formula_maestra_version,FECHA_REGISTRO,COD_FORMULA_MAESTRA_ES_VERSION)");
                        consulta.append(" values('").append(programaProduccionPeriodoDesarrolloBean.getCodProgramaProduccion()).append("','").append(loteCrear.getCodFormulaMaestra()).append("',");
                        consulta.append("'").append(codLoteDesarrollo).append("',2,'','").append(loteCrear.getTamanioLoteProduccion()).append("',1, ");
                        consulta.append(" '").append(loteCrear.getCodCompprod()).append("'," );
                        consulta.append("1, ");
                        consulta.append("0,1,");
                        consulta.append("").append(loteCrear.getCodCompprod()).append(",");
                        consulta.append("'").append(loteCrear.getCodVersion()).append("','").append(loteCrear.getCodFormulaMaestraVersion()).append("'");
                        consulta.append(",GETDATE()");
                        consulta.append(",0)");
            LOGGER.debug("consulta registrar lote desarrollo " + consulta.toString());
            PreparedStatement pst=con.prepareStatement(consulta.toString());
            if(pst.executeUpdate()>0)LOGGER.info("se registro el programa de desarrollo");
            
            con.commit();
            mensaje = "1";
        } catch (SQLException ex) {
            mensaje = "Ocurrio un error al momento de guardar el registro";
            LOGGER.warn(ex.getMessage());
            con.rollback();
        } catch (Exception ex) {
            mensaje = "Ocurrio un error al momento de guardar el registro,verifique los datos introducidos";
            LOGGER.warn(ex.getMessage());
        } finally {
            this.cerrarConexion(con);
        }
        if(mensaje.equals("1"))
        {
            this.cargarProgramaProduccionDesarrolloList();
        }
        return null;
    }
    
    public String cargarProductosDesarrolloAgregar_action()
    {
        try
        {
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            StringBuilder consulta = new StringBuilder("select cpv.COD_COMPPROD,cpv.COD_VERSION,cpv.nombre_prod_semiterminado,cpv.TAMANIO_LOTE_PRODUCCION,");
                                                consulta.append(" cpv.NRO_VERSION");
                                        consulta.append(" from COMPONENTES_PROD_VERSION cpv");
                                                consulta.append(" inner join FORMULA_MAESTRA_VERSION fmv on cpv.COD_VERSION=fmv.COD_COMPPROD_VERSION");
                                                    consulta.append(" and fmv.COD_COMPPROD=cpv.COD_COMPPROD");
                                        consulta.append(" where cpv.COD_ESTADO_VERSION in (2)");
                                                    consulta.append(" and cpv.COD_TIPO_PRODUCCION=2");
                                        consulta.append(" order by cpv.nombre_prod_semiterminado,cpv.TAMANIO_LOTE_PRODUCCION");
            LOGGER.debug("consulta cargar lote Agregar "+consulta.toString());
            ResultSet res = st.executeQuery(consulta.toString());
            componentesProdVersionDesarrolloAgregarList=new ArrayList<ComponentesProdVersion>();
            while (res.next())
            {
                ComponentesProdVersion nuevo=new ComponentesProdVersion();
                nuevo.setCodCompprod(res.getString("COD_COMPPROD"));
                nuevo.setCodVersion(res.getInt("COD_VERSION"));
                nuevo.setNombreProdSemiterminado(res.getString("nombre_prod_semiterminado"));
                nuevo.setTamanioLoteProduccion(res.getInt("TAMANIO_LOTE_PRODUCCION"));
                nuevo.setNroVersion(res.getInt("NRO_VERSION"));
                componentesProdVersionDesarrolloAgregarList.add(nuevo);
            }
            res.close();
            st.close();
            con.close();
        }
        catch (SQLException ex)
        {
            LOGGER.warn("error", ex);
        }
        return null;
    }
    public ManagedProgramaProduccionDesarrolloVersion() 
    {
        LOGGER=LogManager.getLogger("ProductosDesarrollo");
    }
    
    public String getCargarProgramaProduccionPeriodoDesarrollo()
    {
        this.cargarProgramaProduccionPeriodoDesarrollo_action();
        return null;
    }
    private void cargarProgramaProduccionPeriodoDesarrollo_action()
    {
        try {
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            StringBuilder consulta = new StringBuilder("select ppp.COD_ESTADO_PROGRAMA,ppp.COD_PROGRAMA_PROD,ppp.NOMBRE_PROGRAMA_PROD,ppp.OBSERVACIONES,epp.NOMBRE_ESTADO_PROGRAMA_PROD");
                              consulta.append(",ppp.FECHA_INICIO,ppp.FECHA_FINAL");
                              consulta.append(" from PROGRAMA_PRODUCCION_PERIODO ppp left outer join ESTADOS_PROGRAMA_PRODUCCION epp on ");
                              consulta.append(" ppp.COD_ESTADO_PROGRAMA=epp.COD_ESTADO_PROGRAMA_PROD");
                              consulta.append(" where ppp.COD_ESTADO_PROGRAMA<>4 and ISNULL(ppp.COD_TIPO_PRODUCCION,1) in (2)" );
                              consulta.append(" order by ppp.COD_PROGRAMA_PROD desc");
            LOGGER.debug("consulta cargar programa periodo desarrollo"+consulta);
            ResultSet res = st.executeQuery(consulta.toString());
            programaProduccionPeriodoDesarrolloList=new ArrayList<ProgramaProduccionPeriodo>();
            while (res.next())
            {
                ProgramaProduccionPeriodo nuevo=new ProgramaProduccionPeriodo();
                nuevo.setCodProgramaProduccion(res.getString("COD_PROGRAMA_PROD"));
                nuevo.setNombreProgramaProduccion(res.getString("NOMBRE_PROGRAMA_PROD"));
                nuevo.setObsProgramaProduccion(res.getString("OBSERVACIONES"));
                nuevo.getEstadoProgramaProduccion().setNombreEstadoProgramaProd(res.getString("NOMBRE_ESTADO_PROGRAMA_PROD"));
                nuevo.getEstadoProgramaProduccion().setCodEstadoProgramaProd(res.getString("COD_ESTADO_PROGRAMA"));
                nuevo.setFechaInicio(res.getDate("FECHA_INICIO"));
                nuevo.setFechaFinal(res.getDate("FECHA_FINAL"));
                programaProduccionPeriodoDesarrolloList.add(nuevo);
            }
            res.close();
            st.close();
            con.close();
        }
        catch (SQLException ex)
        {
            LOGGER.warn("error", ex);
        }
    }
    public String seleccionarProgramaProducccionPeriodoDesarrollo_action()
    {
        programaProduccionPeriodoDesarrolloBean=(ProgramaProduccionPeriodo)programaProduccionPeriodoDesarrolloDataTable.getRowData();
        return null;
    }
    public String getCargarProgramaProduccionDesarrolloList()
    {
        this.cargarProgramaProduccionDesarrolloList();
        return null;
    }
    private void cargarProgramaProduccionDesarrolloList()
    {
        try
        {
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            StringBuilder consulta =new StringBuilder("exec PAA_NAVEGADOR_PROGRAMA_PRODUCCION_DESARROLLO ");
                                            consulta.append(programaProduccionPeriodoDesarrolloBean!=null?programaProduccionPeriodoDesarrolloBean.getCodProgramaProduccion():"0");
            LOGGER.debug("consulta cargar Programa produccion DESARROLLO "+consulta.toString());
            ResultSet res=st.executeQuery(consulta.toString());
            NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
            DecimalFormat form = (DecimalFormat)nf;
            form.applyPattern("#,#00.0#");
            programaProduccionDesarrolloList=new ArrayList<ProgramaProduccion>();
            while(res.next())
            {
                ProgramaProduccion nuevo=new ProgramaProduccion();
                nuevo.getProgramaProduccionPeriodo().setNombreProgramaProduccion(res.getString("NOMBRE_PROGRAMA_PROD"));
                nuevo.setCodProgramaProduccion(res.getString("cod_programa_prod"));
                nuevo.getFormulaMaestra().setCodFormulaMaestra(res.getString("COD_FORMULA_MAESTRA"));
                nuevo.setCodLoteProduccion(res.getString("COD_LOTE_PRODUCCION"));
                nuevo.setCodEstadoPrograma(res.getString("COD_ESTADO_PROGRAMA"));
                nuevo.getEstadoProgramaProduccion().setCodEstadoProgramaProd(res.getString("COD_ESTADO_PROGRAMA"));
                nuevo.setObservacion(res.getString("OBSERVACION"));
                nuevo.getFormulaMaestra().getComponentesProd().setNombreProdSemiterminado(res.getString("nombre_prod_semiterminado"));
                nuevo.getFormulaMaestra().getComponentesProd().setCodCompprod(res.getString("COD_COMPPROD"));
                nuevo.getFormulaMaestra().setCantidadLote(res.getDouble("cantidad_lote"));
                nuevo.getEstadoProgramaProduccion().setNombreEstadoProgramaProd(res.getString("NOMBRE_ESTADO_PROGRAMA_PROD"));
                nuevo.getTiposProgramaProduccion().setNombreProgramaProd(res.getString("NOMBRE_TIPO_PROGRAMA_PROD"));
                nuevo.getCategoriasCompProd().setNombreCategoriaCompProd(res.getString("NOMBRE_CATEGORIACOMPPROD"));
                nuevo.setCantidadLote(res.getDouble("CANT_LOTE_PRODUCCION"));
                nuevo.getFormulaMaestra().getComponentesProd().getAreasEmpresa().setNombreAreaEmpresa(res.getString("NOMBRE_AREA_EMPRESA"));
                nuevo.getFormulaMaestra().getComponentesProd().getAreasEmpresa().setCodAreaEmpresa(res.getString("COD_AREA_EMPRESA"));
                nuevo.getTiposProgramaProduccion().setCodTipoProgramaProd(res.getString("COD_TIPO_PROGRAMA_PROD"));
                nuevo.getTiposProgramaProduccion().setNombreTipoProgramaProd(res.getString("NOMBRE_TIPO_PROGRAMA_PROD"));
                nuevo.getFormulaMaestra().getComponentesProd().setVidaUtil(res.getInt("VIDA_UTIL"));
                nuevo.getFormulaMaestra().getComponentesProd().getForma().setCodForma(res.getString("COD_FORMA"));
                nuevo.getComponentesProdVersion().setCodVersion(res.getInt("cod_version_cp"));
                nuevo.getComponentesProdVersion().setNroVersion(res.getInt("nro_version_cp"));
                nuevo.getFormulaMaestraVersion().setCodVersion(res.getInt("cod_version_fm"));
                nuevo.getFormulaMaestraVersion().setNroVersion(res.getInt("nro_version_fm"));
                nuevo.getFormulaMaestraEsVersion().setCodFormulaMaestraEsVersion(res.getInt("COD_FORMULA_MAESTRA_ES_VERSION"));
                nuevo.getFormulaMaestraEsVersion().setNroVersion(res.getInt("nroVersionFmEs"));
                nuevo.setFechaRegistro(res.getTimestamp("FECHA_REGISTRO"));
                programaProduccionDesarrolloList.add(nuevo);
            }
            res.close();
            st.close();
            con.close();
        }
        catch (SQLException ex)
        {
            LOGGER.warn("error", ex);
        }
    }
    
    
    //<editor-fold desc="getter and setter" defaultstate="collapsed">

        public List<ComponentesProdVersion> getComponentesProdVersionDesarrolloAgregarList() {
            return componentesProdVersionDesarrolloAgregarList;
        }

        public void setComponentesProdVersionDesarrolloAgregarList(List<ComponentesProdVersion> componentesProdVersionDesarrolloAgregarList) {
            this.componentesProdVersionDesarrolloAgregarList = componentesProdVersionDesarrolloAgregarList;
        }



        public ProgramaProduccion getProgramaProduccionDesarrolloAgregar() {
            return programaProduccionDesarrolloAgregar;
        }

        public void setProgramaProduccionDesarrolloAgregar(ProgramaProduccion programaProduccionDesarrolloAgregar) {
            this.programaProduccionDesarrolloAgregar = programaProduccionDesarrolloAgregar;
        }

        public HtmlDataTable getComponentesProdVersionDesarrolloAgregarDataTable() {
            return componentesProdVersionDesarrolloAgregarDataTable;
        }

        public void setComponentesProdVersionDesarrolloAgregarDataTable(HtmlDataTable componentesProdVersionDesarrolloAgregarDataTable) {
            this.componentesProdVersionDesarrolloAgregarDataTable = componentesProdVersionDesarrolloAgregarDataTable;
        }


        
    
    
        public ProgramaProduccionPeriodo getProgramaProduccionPeriodoDesarrolloBean() {
            return programaProduccionPeriodoDesarrolloBean;
        }

        public void setProgramaProduccionPeriodoDesarrolloBean(ProgramaProduccionPeriodo programaProduccionPeriodoDesarrolloBean) {
            this.programaProduccionPeriodoDesarrolloBean = programaProduccionPeriodoDesarrolloBean;
        }

        public List<ProgramaProduccion> getProgramaProduccionDesarrolloList() {
            return programaProduccionDesarrolloList;
        }

        public void setProgramaProduccionDesarrolloList(List<ProgramaProduccion> programaProduccionDesarrolloList) {
            this.programaProduccionDesarrolloList = programaProduccionDesarrolloList;
        }

    public ProgramaProduccionPeriodo getProgramaPeriodoDesarroloAgregar() {
        return programaPeriodoDesarroloAgregar;
    }

    public void setProgramaPeriodoDesarroloAgregar(ProgramaProduccionPeriodo programaPeriodoDesarroloAgregar) {
        this.programaPeriodoDesarroloAgregar = programaPeriodoDesarroloAgregar;
    }

    public ProgramaProduccionPeriodo getProgramaPeriodoDesarroloEditar() {
        return programaPeriodoDesarroloEditar;
    }

    public void setProgramaPeriodoDesarroloEditar(ProgramaProduccionPeriodo programaPeriodoDesarroloEditar) {
        this.programaPeriodoDesarroloEditar = programaPeriodoDesarroloEditar;
    }
        
    


    
        public String getMensaje() {
            return mensaje;
        }

        public void setMensaje(String mensaje) {
            this.mensaje = mensaje;
        }

        public List<ProgramaProduccionPeriodo> getProgramaProduccionPeriodoDesarrolloList() {
            return programaProduccionPeriodoDesarrolloList;
        }

        public void setProgramaProduccionPeriodoDesarrolloList(List<ProgramaProduccionPeriodo> programaProduccionPeriodoDesarrolloList) {
            this.programaProduccionPeriodoDesarrolloList = programaProduccionPeriodoDesarrolloList;
        }

        public HtmlDataTable getProgramaProduccionPeriodoDesarrolloDataTable() {
            return programaProduccionPeriodoDesarrolloDataTable;
        }

        public void setProgramaProduccionPeriodoDesarrolloDataTable(HtmlDataTable programaProduccionPeriodoDesarrolloDataTable) {
            this.programaProduccionPeriodoDesarrolloDataTable = programaProduccionPeriodoDesarrolloDataTable;
        }
    //</editor-fold>
}
