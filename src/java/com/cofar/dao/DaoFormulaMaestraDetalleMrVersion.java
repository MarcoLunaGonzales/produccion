/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.dao;

import com.cofar.bean.FormulaMaestraDetalleMP;
import com.cofar.bean.FormulaMaestraDetalleMr;
import com.cofar.bean.FormulaMaestraVersion;
import com.cofar.bean.TiposAnalisisMaterialReactivo;
import com.cofar.util.Util;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/**
 *
 * @author DASISAQ
 */
public class DaoFormulaMaestraDetalleMrVersion extends DaoBean 
{
    public DaoFormulaMaestraDetalleMrVersion() {
        LOGGER=LogManager.getLogger("Versionamiento");
    }
    public DaoFormulaMaestraDetalleMrVersion(Logger LOGGER) {
        this.LOGGER = LOGGER;
    }
    public boolean editarLista(List<FormulaMaestraDetalleMr> formulaMaestraDetalleMrList)throws SQLException
    {
        LOGGER.debug("----------------------inicio edicion de material reactivo-----------------");
        boolean guardado = false;
        try
        {
            con=Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta;
            PreparedStatement pst;
            for(FormulaMaestraDetalleMP bean : formulaMaestraDetalleMrList)
            {
                consulta = new StringBuilder(" UPDATE FORMULA_MAESTRA_DETALLE_MR_VERSION SET CANTIDAD ='").append(bean.getCantidad()).append("',")
                                    .append(" COD_TIPO_MATERIAL = '").append(bean.getTiposMaterialReactivo().getCodTipoMaterialReactivo()).append("'")
                        .append(" WHERE COD_VERSION = ").append(bean.getFormulaMaestra().getCodVersion())
                        .append(" and COD_MATERIAL = '").append(bean.getMateriales().getCodMaterial()).append("'");
                LOGGER.debug("consulta actualizar formula reactivos "+consulta.toString());
                pst=con.prepareStatement(consulta.toString());
                if(pst.executeUpdate()>0)LOGGER.info("se actualizo el material reactivo");
                consulta = new StringBuilder("delete FORMULA_MAESTRA_MR_CLASIFICACION_VERSION")
                                    .append(" where COD_VERSION = ").append(bean.getFormulaMaestra().getCodVersion())
                                           .append(" and COD_MATERIAL='").append(bean.getMateriales().getCodMaterial()).append("'");
                LOGGER.debug("consulta eliminar detalle material reactivo "+consulta.toString());
                pst=con.prepareStatement(consulta.toString());
                if(pst.executeUpdate()>0)LOGGER.info("se eliminaron los detalles del material");
                for(TiposAnalisisMaterialReactivo bean1 : (List<TiposAnalisisMaterialReactivo>)bean.getTiposAnalisisMaterialReactivoList1())
                {
                    if(bean1.getChecked())
                    {
                        consulta = new StringBuilder("INSERT INTO FORMULA_MAESTRA_MR_CLASIFICACION_VERSION(COD_VERSION,")
                                                        .append(" COD_FORMULA_MAESTRA, COD_MATERIAL, COD_TIPO_ANALISIS_MATERIAL_REACTIVO)")
                                            .append(" VALUES (").append(bean.getFormulaMaestra().getCodVersion()).append(",")
                                            .append("'").append(bean.getFormulaMaestra().getCodFormulaMaestra()).append("',")
                                            .append("'").append(bean.getMateriales().getCodMaterial()).append("',")
                                            .append("'").append(bean1.getCodTiposAnalisisMaterialReactivo()).append("')");
                        LOGGER.debug("consulta registrar clasificacion "+consulta.toString());
                        pst=con.prepareStatement(consulta.toString());
                        if(pst.executeUpdate() > 0)LOGGER.debug("se registro la clasificacion");
                    }
                }
            }
            con.commit();
            guardado = true;
        }
        catch(SQLException ex)
        {
            con.rollback();
            guardado = false;
            LOGGER.warn("error", ex);
        }
        catch(Exception e)
        {
            guardado = false;
            LOGGER.warn("error", e);
        }
        finally{
            this.cerrarConexion(con);
        }
        LOGGER.debug("----------------------final edicion de material reactivo-----------------");
        return guardado;
    }
    
    public boolean guardarLista(List<FormulaMaestraDetalleMr> formulaMaestraDetalleMrList,FormulaMaestraVersion formulaMaestraVersion)throws SQLException
    {
        boolean guardado = false;
        LOGGER.debug("----------------------inicio registro de material reactivo-----------------");
        if(formulaMaestraDetalleMrList.size() > 0)
        {
            try
            {
                con=Util.openConnection(con);
                con.setAutoCommit(false);
                StringBuilder consulta=new StringBuilder("INSERT INTO FORMULA_MAESTRA_DETALLE_MR_VERSION(COD_VERSION, COD_FORMULA_MAESTRA,");
                              consulta.append("COD_MATERIAL, CANTIDAD, COD_UNIDAD_MEDIDA, NRO_PREPARACIONES, COD_TIPO_MATERIAL)");
                              consulta.append("VALUES('").append(formulaMaestraVersion.getCodVersion()).append("',");
                              consulta.append("'").append(formulaMaestraVersion.getCodFormulaMaestra()).append("',?,?,?,0,?)");
                LOGGER.debug("consulta registrar detalle mr pstMr");
                PreparedStatement pstMaterial=con.prepareStatement(consulta.toString());
                consulta=new StringBuilder("INSERT INTO FORMULA_MAESTRA_MR_CLASIFICACION_VERSION(COD_VERSION,");
                          consulta.append(" COD_FORMULA_MAESTRA, COD_MATERIAL, COD_TIPO_ANALISIS_MATERIAL_REACTIVO)");
                          consulta.append("VALUES('").append(formulaMaestraVersion.getCodVersion()).append("',");
                          consulta.append("'").append(formulaMaestraVersion.getCodFormulaMaestra()).append("',?,?)");
                LOGGER.debug("consulta registrar clasificacion pstMC");
                PreparedStatement pstClasificacion=con.prepareStatement(consulta.toString());
                for(FormulaMaestraDetalleMr bean : formulaMaestraDetalleMrList)
                {
                    pstMaterial.setString(1,bean.getMateriales().getCodMaterial());LOGGER.info("pstMr p1: "+bean.getMateriales().getCodMaterial());
                    pstMaterial.setDouble(2,bean.getCantidad());LOGGER.info("pstMr p2: "+bean.getCantidad());
                    pstMaterial.setString(3,bean.getUnidadesMedida().getCodUnidadMedida());LOGGER.info("pstMr p3: "+bean.getUnidadesMedida().getCodUnidadMedida());
                    pstMaterial.setInt(4,bean.getTiposMaterialReactivo().getCodTipoMaterialReactivo());LOGGER.info("pstMr p4: "+bean.getTiposMaterialReactivo().getCodTipoMaterialReactivo());
                    if(pstMaterial.executeUpdate()>0)LOGGER.info("se registro el material");
                    for(TiposAnalisisMaterialReactivo bean1 : (List<TiposAnalisisMaterialReactivo>)bean.getTiposAnalisisMaterialReactivoList())
                    {
                        if(bean1.getChecked())
                        {
                            pstClasificacion.setString(1,bean.getMateriales().getCodMaterial());LOGGER.info("pstMC p1: "+bean.getMateriales().getCodMaterial());
                            pstClasificacion.setInt(2,bean1.getCodTiposAnalisisMaterialReactivo());LOGGER.info("pstMC p1: "+bean1.getCodTiposAnalisisMaterialReactivo());
                            if(pstClasificacion.executeUpdate()>0)LOGGER.info("se registro la clasificacion");
                        }
                    }


                }
                
                con.commit();
                guardado = true;
            }
            catch(SQLException ex)
            {
                con.rollback();
                guardado = false;
                LOGGER.warn("error",ex);
            }
            catch(Exception e)
            {
                guardado = false;
                LOGGER.warn("error",e);
            }
            finally
            {
                this.cerrarConexion(con);
            }
        }
        LOGGER.debug("----------------------termino registro de material reactivo-----------------");
        return guardado;
    }
    
    public boolean eliminarLista(List<FormulaMaestraDetalleMr> formulaMaestraDetalleMrList)throws SQLException
    {
        boolean eliminado=false;
        LOGGER.debug("----------------------inicio eliminando material reactivo-----------------");
        try
        {
            con=Util.openConnection(con);
            con.setAutoCommit(false);
            PreparedStatement pst;
            StringBuilder consulta;
            for(FormulaMaestraDetalleMr bean : formulaMaestraDetalleMrList)
            {
                consulta = new StringBuilder("DELETE FORMULA_MAESTRA_DETALLE_MR_VERSION ")
                                    .append(" WHERE COD_VERSION = ").append(bean.getFormulaMaestra().getCodVersion())
                                            .append(" and COD_FORMULA_MAESTRA = ").append(bean.getFormulaMaestra().getCodFormulaMaestra())
                                            .append(" and COD_MATERIAL = ").append(bean.getMateriales().getCodMaterial());
                LOGGER.debug("consulta eliminar material reactivo "+consulta.toString());
                pst=con.prepareStatement(consulta.toString());
                if(pst.executeUpdate() > 0)LOGGER.info("se eliminaron los materiales");
                
                consulta = new StringBuilder("delete FORMULA_MAESTRA_MR_CLASIFICACION_VERSION")
                             .append(" where COD_FORMULA_MAESTRA = ").append(bean.getFormulaMaestra().getCodFormulaMaestra())
                             .append(" and COD_VERSION = ").append(bean.getFormulaMaestra().getCodVersion())
                             .append(" and COD_MATERIAL = ").append(bean.getMateriales().getCodMaterial());
                LOGGER.debug("consulta eliminar mr clasificacion "+consulta.toString());
                pst=con.prepareStatement(consulta.toString());
                if(pst.executeUpdate()>0)LOGGER.info("se elimino la clasificacion");
            }
            con.commit();
            eliminado = true;
        }
        catch(SQLException ex){
            eliminado = false;
            LOGGER.warn("error", ex);
            con.rollback();
        }
        catch(Exception ex){
            eliminado = false;
            LOGGER.warn("error", ex);
        }
        finally{
            this.cerrarConexion(con);
        }
        LOGGER.debug("----------------------termino eliminando material reactivo-----------------");
        return eliminado;
    }
    public List<FormulaMaestraDetalleMr> listar(FormulaMaestraVersion formulaMaestraVersion,int codTipoMaterial)
    {
        List<FormulaMaestraDetalleMr> formulaMaestraDetalleMrList = new ArrayList<>();
        
        try
        {
            con=Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            StringBuilder consulta=new StringBuilder("select fmv.COD_FORMULA_MAESTRA,m.NOMBRE_MATERIAL,fmdv.CANTIDAD,um.NOMBRE_UNIDAD_MEDIDA,");
                            consulta.append(" m.cod_material,fmdv.NRO_PREPARACIONES,m.cod_grupo,fmdv.COD_TIPO_MATERIAL,er.NOMBRE_ESTADO_REGISTRO,fmdv.COD_TIPO_ANALISIS_MATERIAL");
                            consulta.append(" ,analisis.nombre_tipo_analisis_material_reactivo,analisis.COD_MATERIAL as registrado");
                            consulta.append(" ,analisis.COD_TIPO_ANALISIS_MATERIAL_REACTIVO,um.ABREVIATURA");
                            consulta.append(" from FORMULA_MAESTRA_VERSION fmv")
                                    .append(" inner join FORMULA_MAESTRA_DETALLE_MR_VERSION fmdv on fmv.COD_FORMULA_MAESTRA=fmdv.COD_FORMULA_MAESTRA")
                                            .append(" and fmv.COD_VERSION=fmdv.COD_VERSION");
                            consulta.append(" inner join materiales m on m.COD_MATERIAL=fmdv.COD_MATERIAL");
                            consulta.append(" inner join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=fmdv.COD_UNIDAD_MEDIDA");
                            consulta.append(" inner join ESTADOS_REFERENCIALES er on er.COD_ESTADO_REGISTRO=m.COD_ESTADO_REGISTRO");
                            consulta.append(" inner join grupos g on g.COD_GRUPO=m.COD_GRUPO");
                            consulta.append(" outer APPLY(select tamr.COD_TIPO_ANALISIS_MATERIAL_REACTIVO,tamr.nombre_tipo_analisis_material_reactivo,fmmcv.COD_MATERIAL from TIPOS_ANALISIS_MATERIAL_REACTIVO tamr left outer join FORMULA_MAESTRA_MR_CLASIFICACION_VERSION fmmcv");
                            consulta.append(" on fmmcv.COD_TIPO_ANALISIS_MATERIAL_REACTIVO=tamr.cod_tipo_analisis_material_reactivo and fmmcv.COD_FORMULA_MAESTRA=fmv.COD_FORMULA_MAESTRA");
                            consulta.append(" and fmmcv.COD_VERSION=fmv.COD_VERSION and fmmcv.COD_MATERIAL=fmdv.COD_MATERIAL ) as analisis");
                            consulta.append(" where g.COD_CAPITULO=2 and fmv.COD_FORMULA_MAESTRA='").append(formulaMaestraVersion.getCodFormulaMaestra()).append("'" );
                            consulta.append(" and fmv.COD_VERSION='").append(formulaMaestraVersion.getCodVersion()).append("'");
                            consulta.append(" and fmdv.COD_TIPO_MATERIAL = ").append(codTipoMaterial);
                            consulta.append(" order by m.NOMBRE_MATERIAL,analisis.nombre_tipo_analisis_material_reactivo");
            LOGGER.debug("consulta materiales mr "+consulta.toString());
            ResultSet res=st.executeQuery(consulta.toString());
            NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
            DecimalFormat form = (DecimalFormat) nf;
            form.applyPattern("#,#00.0#");
            FormulaMaestraDetalleMr nuevo = new FormulaMaestraDetalleMr();
            while(res.next())
            {
                if(!nuevo.getMateriales().getCodMaterial().equals(res.getString("COD_MATERIAL")))
                {
                    if(!nuevo.getMateriales().getCodMaterial().equals(""))
                    {
                        formulaMaestraDetalleMrList.add(nuevo);
                    }
                    nuevo= new FormulaMaestraDetalleMr();
                    nuevo.getFormulaMaestra().setCodFormulaMaestra(res.getString("COD_FORMULA_MAESTRA"));
                    nuevo.getFormulaMaestra().setCodVersion(formulaMaestraVersion.getCodVersion());
                    nuevo.getMateriales().setNombreMaterial(res.getString("NOMBRE_MATERIAL"));
                    nuevo.setCantidad(res.getDouble("CANTIDAD"));
                    nuevo.getUnidadesMedida().setNombreUnidadMedida(res.getString("NOMBRE_UNIDAD_MEDIDA"));
                    nuevo.getUnidadesMedida().setAbreviatura(res.getString("ABREVIATURA"));
                    nuevo.getMateriales().setCodMaterial(res.getString("cod_material"));
                    nuevo.getMateriales().getEstadoRegistro().setNombreEstadoRegistro(res.getString("nombre_estado_registro"));
                    nuevo.setNroPreparaciones(res.getInt("NRO_PREPARACIONES"));
                    nuevo.getTiposMaterialReactivo().setCodTipoMaterialReactivo(res.getInt("cod_tipo_material"));
                    nuevo.getTiposAnalisisMaterialReactivo().setCodTiposAnalisisMaterialReactivo(res.getInt("cod_tipo_analisis_material"));
                }
                TiposAnalisisMaterialReactivo nuevo1=new TiposAnalisisMaterialReactivo();
                nuevo1.setChecked(res.getInt("registrado")>0);
                nuevo1.setNombreTiposAnalisisMaterialReactivo(res.getString("nombre_tipo_analisis_material_reactivo"));
                nuevo1.setCodTiposAnalisisMaterialReactivo(res.getInt("COD_TIPO_ANALISIS_MATERIAL_REACTIVO"));
                nuevo.getTiposAnalisisMaterialReactivoList1().add(nuevo1);
            }
            if(!nuevo.getMateriales().getCodMaterial().equals(""))
            {
                formulaMaestraDetalleMrList.add(nuevo);
            }
            res.close();
            st.close();
            con.close();
        }
        catch(SQLException ex)
        {
            LOGGER.warn("error", ex);
        }
        return formulaMaestraDetalleMrList;
    }
    public List<FormulaMaestraDetalleMr> listarAgregar(FormulaMaestraVersion formulaMaestraVersion)
    {
        List<FormulaMaestraDetalleMr> formulaMaestraDetalleMrList = new ArrayList<>();
        try
        {
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            StringBuilder consulta=new StringBuilder("select m.COD_MATERIAL,m.NOMBRE_MATERIAL,um.ABREVIATURA,um.cod_unidad_medida,g.cod_grupo");
                          consulta.append(" from MATERIALES m inner join grupos g on g.COD_GRUPO=m.COD_GRUPO");
                          consulta.append(" inner join UNIDADES_MEDIDA  um on um.COD_UNIDAD_MEDIDA=m.COD_UNIDAD_MEDIDA");
                          consulta.append(" where g.COD_CAPITULO=2 and m.MOVIMIENTO_ITEM in (1) and");
                          consulta.append(" m.COD_MATERIAL not in (select fmdv.COD_MATERIAL from FORMULA_MAESTRA_DETALLE_MR_VERSION fmdv ");
                          consulta.append(" where fmdv.COD_FORMULA_MAESTRA='").append(formulaMaestraVersion.getCodFormulaMaestra()).append("'");
                          consulta.append(" and fmdv.COD_VERSION='").append(formulaMaestraVersion.getCodVersion()).append("')");
                          consulta.append(" and m.COD_ESTADO_REGISTRO=1 order by m.NOMBRE_MATERIAL");
            LOGGER.debug("consulta cargar materiales mr agregar "+consulta.toString());
            ResultSet res=st.executeQuery(consulta.toString());
            while(res.next())
            {
                FormulaMaestraDetalleMr nuevo = new FormulaMaestraDetalleMr();
                nuevo.getMateriales().setCodMaterial(res.getString("COD_MATERIAL"));
                nuevo.getMateriales().setNombreMaterial(res.getString("NOMBRE_MATERIAL"));
                nuevo.getUnidadesMedida().setAbreviatura(res.getString("ABREVIATURA"));
                nuevo.getUnidadesMedida().setCodUnidadMedida(res.getString("cod_unidad_medida"));
                nuevo.setCantidad(0);
                if (res.getInt("COD_GRUPO")==5) {
                    nuevo.setSwNo(false);
                    nuevo.setSwSi(true);
                } else {
                    nuevo.setSwNo(true);
                    nuevo.setSwSi(false);
                }
                TiposAnalisisMaterialReactivo nuevo1=new TiposAnalisisMaterialReactivo();
                nuevo1.setCodTiposAnalisisMaterialReactivo(1);
                nuevo.getTiposAnalisisMaterialReactivoList().add(nuevo1);
                TiposAnalisisMaterialReactivo nuevo2=new TiposAnalisisMaterialReactivo();
                nuevo2.setCodTiposAnalisisMaterialReactivo(2);
                nuevo.getTiposAnalisisMaterialReactivoList().add(nuevo2);
                formulaMaestraDetalleMrList.add(nuevo);
            }
            st.close();
            con.close();
        }
        catch(SQLException ex)
        {
            LOGGER.warn("error",ex);
        }
        return formulaMaestraDetalleMrList;
    }
}
