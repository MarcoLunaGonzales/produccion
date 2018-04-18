/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.dao;

import com.cofar.bean.ComponentesProdVersion;
import com.cofar.bean.FormulaMaestraDetalleMP;
import com.cofar.bean.FormulaMaestraDetalleMPfracciones;
import com.cofar.bean.FormulaMaestraVersion;
import com.cofar.bean.TiposMaterialProduccion;
import com.cofar.util.Util;
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
import org.apache.logging.log4j.Logger;

/**
 *
 * @author DASISAQ
 */
public class DaoFormulaMaestraDetalleMpVersion extends DaoBean 
{
    public DaoFormulaMaestraDetalleMpVersion() {
        LOGGER = LogManager.getRootLogger();
    }
    public DaoFormulaMaestraDetalleMpVersion(Logger LOGGER) {
        this.LOGGER = LOGGER;
    }
    public boolean editarLista(List<FormulaMaestraDetalleMP> formulaMaestraDetalleMPList,FormulaMaestraVersion formulaMaestraVersion)throws SQLException
    {
        boolean guardado = false;
        LOGGER.debug("----------------------inicio edicion de materia prima-----------------");
        try{
            con=Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta=new StringBuilder("UPDATE FORMULA_MAESTRA_DETALLE_MP_VERSION ");
                                        consulta.append(" SET CANTIDAD_UNITARIA_GRAMOS = ?,");
                                                consulta.append(" DENSIDAD_MATERIAL = ?,");
                                                consulta.append(" CANTIDAD_MAXIMA_MATERIAL_POR_FRACCION=?,")
                                                        .append(" FECHA_MODIFICACION = GETDATE()");
                                        consulta.append(" WHERE COD_FORMULA_MAESTRA_DETALLE_MP_VERSION = ?");
            LOGGER.debug("consulta editar version pstEMp "+consulta.toString());
            PreparedStatement pst=con.prepareStatement(consulta.toString());
            consulta=new StringBuilder("INSERT INTO FORMULA_MAESTRA_DETALLE_MP_FRACCIONES_VERSION(COD_VERSION,COD_FORMULA_MAESTRA, COD_MATERIAL, COD_FORMULA_MAESTRA_FRACCIONES, CANTIDAD,");
                                consulta.append(" PORCIENTO_FRACCION,COD_TIPO_MATERIAL_PRODUCCION,COD_FORMULA_MAESTRA_DETALLE_MP_VERSION)");
                        consulta.append(" VALUES (");
                                consulta.append(formulaMaestraVersion.getCodVersion()).append(",");
                                consulta.append(formulaMaestraVersion.getCodFormulaMaestra()).append(",");
                                consulta.append("?,?,?,?,?,?");
                        consulta.append(")");
            LOGGER.debug("consulta registrar fraccion pstFrac "+consulta.toString());
            PreparedStatement pstFracciones=con.prepareStatement(consulta.toString());
            consulta=new StringBuilder("delete FORMULA_MAESTRA_DETALLE_MP_FRACCIONES_VERSION ");
                        consulta.append(" where COD_FORMULA_MAESTRA_DETALLE_MP_VERSION=?");
            LOGGER.debug("consulta delete fracciones material pstDel"+consulta.toString());
            PreparedStatement pstDelFrac=con.prepareStatement(consulta.toString());
            for(FormulaMaestraDetalleMP bean:formulaMaestraDetalleMPList)
            {
                pst.setDouble(1,bean.getCantidadUnitariaGramos());LOGGER.info("pstEMp p1: "+bean.getCantidadUnitariaGramos());
                pst.setDouble(2,bean.getDensidadMaterial());LOGGER.info("pstEMp p2:"+bean.getDensidadMaterial());
                pst.setDouble(3,(bean.isAplicaCantidadMaximaPorFraccion()?bean.getCantidadMaximaMaterialPorFraccion():0));LOGGER.info("pstEMp p3:"+(bean.isAplicaCantidadMaximaPorFraccion()?bean.getCantidadMaximaMaterialPorFraccion():0));
                pst.setInt(4,bean.getCodFormulaMastraDetalleMpVersion());LOGGER.info("pstEMp p4:"+bean.getCodFormulaMastraDetalleMpVersion());
                if(pst.executeUpdate()>0)LOGGER.info("se registro la edicion del material");
            }
            consulta = new StringBuilder("exec PAA_ACTUALIZACION_CANTIDADES_FORMULA_MAESTRA_VERSION ")
                                .append(formulaMaestraVersion.getComponentesProd().getCodVersion());
            LOGGER.debug("consulta actualizar cantidades "+consulta.toString());
            pst = con.prepareStatement(consulta.toString());
            if(pst.executeUpdate() > 0)LOGGER.info("se registro ");
            con.commit();
            guardado = true;
            
        }
        catch(SQLException ex)
        {
            guardado = false;
            con.rollback();
            con.close();
            LOGGER.warn("error", ex);
        }
        finally{
            this.cerrarConexion(con);
        }
        LOGGER.debug("----------------------termino edicion de materia prima-----------------");
        return guardado;
    }
    
    public boolean guardarLista(List<FormulaMaestraDetalleMP> formulaMaestraDetalleMPList,FormulaMaestraVersion formulaMaestraVersion)throws SQLException
    {
        boolean guardado = false;
        LOGGER.debug("----------------------inicio registro de materia prima-----------------");
        if(formulaMaestraDetalleMPList.size() > 0)
        {
            try
            {
                con=Util.openConnection(con);
                con.setAutoCommit(false);
                StringBuilder consulta = new StringBuilder("  INSERT INTO FORMULA_MAESTRA_DETALLE_MP_VERSION(COD_VERSION, COD_FORMULA_MAESTRA,COD_MATERIAL,  COD_UNIDAD_MEDIDA, NRO_PREPARACIONES,");
                                                    consulta.append("CANTIDAD_UNITARIA_GRAMOS, CANTIDAD_MAXIMA_MATERIAL_POR_FRACCION, DENSIDAD_MATERIAL,COD_TIPO_MATERIAL_PRODUCCION,FECHA_MODIFICACION,NRO_DECIMALES_ALMACEN)");
                                            consulta.append(" VALUES (");
                                                    consulta.append(formulaMaestraVersion.getCodVersion()).append(",");
                                                    consulta.append(formulaMaestraVersion.getCodFormulaMaestra()).append(",");
                                                    consulta.append("?,?,1,?,?,?,");
                                                    consulta.append(formulaMaestraDetalleMPList.get(0).getTiposMaterialProduccion().getCodTipoMaterialProduccion()).append(",")
                                                            .append("getdate(),")
                                                            .append("2");
                                            consulta.append(")");
                LOGGER.debug("consulta registrar fm mp pstmp "+consulta.toString());
                PreparedStatement pstMaterial=con.prepareStatement(consulta.toString(),PreparedStatement.RETURN_GENERATED_KEYS);
                ResultSet res;
                consulta=new StringBuilder("INSERT INTO FORMULA_MAESTRA_DETALLE_MP_FRACCIONES_VERSION(COD_VERSION,COD_FORMULA_MAESTRA, COD_MATERIAL, COD_FORMULA_MAESTRA_FRACCIONES, CANTIDAD,");
                                    consulta.append(" PORCIENTO_FRACCION,COD_TIPO_MATERIAL_PRODUCCION,COD_FORMULA_MAESTRA_DETALLE_MP_VERSION)");
                            consulta.append(" VALUES (");
                                    consulta.append(formulaMaestraVersion.getCodVersion()).append(",");
                                    consulta.append(formulaMaestraVersion.getCodFormulaMaestra()).append(",");
                                    consulta.append("?,?,?,?,");
                                    consulta.append(formulaMaestraDetalleMPList.get(0).getTiposMaterialProduccion().getCodTipoMaterialProduccion()).append(",?");
                            consulta.append(")");
                LOGGER.debug("consulta registra fm fracciones pstfmf "+consulta.toString());
                PreparedStatement pstFracciones=con.prepareStatement(consulta.toString());
                for(FormulaMaestraDetalleMP bean:formulaMaestraDetalleMPList)
                {
                    if(bean.getChecked())
                    {
                        pstMaterial.setString(1, bean.getMateriales().getCodMaterial());LOGGER.info("pstmp p1:"+bean.getMateriales().getCodMaterial());
                        pstMaterial.setString(2,bean.getUnidadesMedida().getCodUnidadMedida());LOGGER.info("pstmp p2:"+bean.getUnidadesMedida().getCodUnidadMedida());
                        pstMaterial.setDouble(3,bean.getCantidadUnitariaGramos());LOGGER.info("pstmp p3:"+bean.getCantidadUnitariaGramos());
                        pstMaterial.setDouble(4,bean.isAplicaCantidadMaximaPorFraccion()?bean.getCantidadMaximaMaterialPorFraccion():0);LOGGER.info("pstmp p4:"+(bean.isAplicaCantidadMaximaPorFraccion()?bean.getCantidadMaximaMaterialPorFraccion():0));
                        pstMaterial.setDouble(5,bean.getDensidadMaterial());LOGGER.info("pstmp p5:"+bean.getDensidadMaterial());
                        if(pstMaterial.executeUpdate()>0)LOGGER.info(" se registro el nuevo material ");
                        res=pstMaterial.getGeneratedKeys();
                        res.next();
                        pstFracciones.setString(1,bean.getMateriales().getCodMaterial());LOGGER.info("pstfmf p1: "+bean.getMateriales().getCodMaterial());
                        pstFracciones.setInt(5,res.getInt(1));LOGGER.info("pstfmf p5: "+res.getInt(1));

                        if(bean.isAplicaCantidadMaximaPorFraccion())
                        {
                            int codFormulaMaestraFracciones=0;
                            Double cantidadTotalAsignar=bean.getCantidadTotalGramos();
                            while(cantidadTotalAsignar>0)
                            {
                                pstFracciones.setInt(2,codFormulaMaestraFracciones);LOGGER.info("pstfmf p2: "+codFormulaMaestraFracciones);
                                if(cantidadTotalAsignar>bean.getCantidadMaximaMaterialPorFraccion())
                                {
                                    pstFracciones.setDouble(3,bean.getCantidadMaximaMaterialPorFraccion());LOGGER.info("pstfmf p3: "+bean.getCantidadMaximaMaterialPorFraccion());
                                    pstFracciones.setDouble(4,(bean.getCantidadMaximaMaterialPorFraccion()/bean.getCantidadTotalGramos())*100);LOGGER.info("pstfmf p4: "+(bean.getCantidadMaximaMaterialPorFraccion()/bean.getCantidadTotalGramos())*100);
                                    cantidadTotalAsignar-=bean.getCantidadMaximaMaterialPorFraccion();
                                }
                                else
                                {
                                    pstFracciones.setDouble(3,cantidadTotalAsignar);LOGGER.info("pstfmf p3: "+cantidadTotalAsignar);
                                    pstFracciones.setDouble(4,(cantidadTotalAsignar/bean.getCantidadTotalGramos())*100);LOGGER.info("pstfmf p4: "+(cantidadTotalAsignar/bean.getCantidadTotalGramos())*100);
                                    cantidadTotalAsignar=0d;
                                }
                                if(pstFracciones.executeUpdate()>0)LOGGER.info("se registro la fraccion entera");
                                codFormulaMaestraFracciones++;
                            }
                        }
                        else
                        {
                            pstFracciones.setDouble(3,bean.getCantidadTotalGramos());LOGGER.info("pstfmf p3: "+bean.getCantidadTotalGramos());
                            pstFracciones.setInt(2,0);LOGGER.info("pstfmf p2: "+0);
                            pstFracciones.setDouble(4,100);LOGGER.info("pstfmf p4: "+100);
                            if(pstFracciones.executeUpdate()>0)LOGGER.info("se registro la fraccion entera");
                        }
                    }
                }
                consulta = new StringBuilder("exec PAA_ACTUALIZACION_CANTIDADES_FORMULA_MAESTRA_VERSION ")
                                .append(formulaMaestraVersion.getComponentesProd().getCodVersion());
                LOGGER.debug("consulta actualizar cantidades "+consulta.toString());
                PreparedStatement pst = con.prepareStatement(consulta.toString());
                if(pst.executeUpdate() > 0)LOGGER.info("se registro ");
                
                con.commit();
                guardado = true;
                pstFracciones.close();
                pstMaterial.close();
            }
            catch(SQLException ex)
            {
                guardado = false;
                con.rollback();
                ex.printStackTrace();
            }
            catch(Exception ex)
            {
                con.rollback();
                guardado  = false;
                ex.printStackTrace();
            }
            finally{
                this.cerrarConexion(con);
            }
        }
        LOGGER.debug("----------------------termino registro de materia prima-----------------");
        return guardado;
    }
    
    public boolean eliminarLista(List<FormulaMaestraDetalleMP> formulaMaestraDetalleMPList)throws SQLException
    {
        boolean eliminado=false;
        LOGGER.debug("----------------------inicio eliminando materia prima-----------------");
        try 
        {
            
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            
            StringBuilder consulta = new StringBuilder("delete FORMULA_MAESTRA_DETALLE_MP_FRACCIONES_VERSION")
                                                .append(" where COD_FORMULA_MAESTRA_DETALLE_MP_VERSION=?");
            LOGGER.debug("consutla eliminar fracciones mp pstDelFrac "+consulta.toString());
            PreparedStatement pstDelFrac = con.prepareStatement(consulta.toString());
            consulta = new StringBuilder(" delete FORMULA_MAESTRA_DETALLE_MP_VERSION ")
                                .append(" where COD_FORMULA_MAESTRA_DETALLE_MP_VERSION=?");
            LOGGER.debug("consulta eliminar detalle mp pstDel "+consulta.toString());
            PreparedStatement pstDel = con.prepareStatement(consulta.toString());
            for(FormulaMaestraDetalleMP bean :  formulaMaestraDetalleMPList)
            {
                 pstDelFrac.setInt(1,bean.getCodFormulaMastraDetalleMpVersion());LOGGER.info("p1 pstDelFrac: "+bean.getCodFormulaMastraDetalleMpVersion());
                 if(pstDelFrac.executeUpdate()> 0)LOGGER.info("se eliminaron las fracciones");
                 pstDel.setInt(1,bean.getCodFormulaMastraDetalleMpVersion());LOGGER.info("p1 pstDel: "+bean.getCodFormulaMastraDetalleMpVersion());
                 if(pstDel.executeUpdate()> 0)LOGGER.info("se elimino el material");
            }
            con.commit();
            eliminado = true;
        } 
        catch (SQLException ex) 
        {
            eliminado = false;
            LOGGER.warn(ex.getMessage());
            con.rollback();
        }
        catch (Exception ex) 
        {
            eliminado = false;
            LOGGER.warn(ex.getMessage());
        }
        finally 
        {
            this.cerrarConexion(con);
        }
        LOGGER.debug("----------------------termino eliminando materia prima-----------------");
        return eliminado;
    }
    public List<TiposMaterialProduccion> getFormulaMaestraDetalleMpGroupByTiposMaterialProduccionList ( FormulaMaestraVersion formulaMaestraVersionBuscar)
    {
        List<TiposMaterialProduccion> tiposMaterialProduccionList=new ArrayList<TiposMaterialProduccion>();
        
        try 
        {
            con = Util.openConnection(con);
            StringBuilder consulta=new StringBuilder("select  fmv.COD_FORMULA_MAESTRA, m.NOMBRE_MATERIAL,fmdv.CANTIDAD as CANTIDAD,");
                                            consulta.append(" um.NOMBRE_UNIDAD_MEDIDA,m.cod_material,fmdv.nro_preparaciones,m.cod_grupo,er.nombre_estado_registro");
                                            consulta.append(" ,fmdv.CANTIDAD_UNITARIA_GRAMOS,fmdv.CANTIDAD_TOTAL_GRAMOS,fmdv.CANTIDAD_MAXIMA_MATERIAL_POR_FRACCION");
                                            consulta.append(" ,fmdv.DENSIDAD_MATERIAL,tmp.COD_TIPO_MATERIAL_PRODUCCION,tmp.NOMBRE_TIPO_MATERIAL_PRODUCCION");
                                            consulta.append(",e.VALOR_EQUIVALENCIA as equivalenciaG,eml.VALOR_EQUIVALENCIA as equivalenciaMl,um.COD_TIPO_MEDIDA,fmdv.COD_FORMULA_MAESTRA_DETALLE_MP_VERSION");
                                            consulta.append(",isnull(ffme.COD_FORMA,0) as registradoNoSuma,fmv.COD_VERSION,fmv.COD_FORMULA_MAESTRA");
                                    consulta.append(" FROM FORMULA_MAESTRA_VERSION fmv");
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
                                                    consulta.append(" and ffme.COD_FORMA=").append(formulaMaestraVersionBuscar.getComponentesProd().getForma().getCodForma());
                                    consulta.append(" where fmdv.COD_VERSION=").append(formulaMaestraVersionBuscar.getCodVersion());
                                            consulta.append(" and fmdv.COD_FORMULA_MAESTRA=").append(formulaMaestraVersionBuscar.getCodFormulaMaestra());
                                    consulta.append(" order by tmp.COD_TIPO_MATERIAL_PRODUCCION,m.NOMBRE_MATERIAL");
            System.out.println("consulta mp"+consulta.toString());
            PreparedStatement pst=con.prepareStatement(consulta.toString());
            consulta=new StringBuilder(" select ff.CANTIDAD,t.COD_TIPO_MATERIAL_PRODUCCION,t.NOMBRE_TIPO_MATERIAL_PRODUCCION,ff.PORCIENTO_FRACCION");
                        consulta.append(" from FORMULA_MAESTRA_DETALLE_MP_FRACCIONES_VERSION ff");
                                consulta.append(" left outer join TIPOS_MATERIAL_PRODUCCION t on t.COD_TIPO_MATERIAL_PRODUCCION = ff.COD_TIPO_MATERIAL_PRODUCCION");
                        consulta.append(" where ff.COD_FORMULA_MAESTRA_DETALLE_MP_VERSION=?");
                        consulta.append(" ORDER BY ff.COD_FORMULA_MAESTRA_FRACCIONES");
            LOGGER.debug("consulta fracciones pst"+consulta.toString());
            PreparedStatement pstFraccion=con.prepareStatement(consulta.toString());
            ResultSet res=pst.executeQuery();
            ResultSet resDetalle=null;
            TiposMaterialProduccion tipo=new TiposMaterialProduccion();
            while(res.next())
            {
                    if(tipo.getCodTipoMaterialProduccion()!=res.getInt("COD_TIPO_MATERIAL_PRODUCCION"))
                    {
                        if(tipo.getCodTipoMaterialProduccion()>0)
                        {
                            tiposMaterialProduccionList.add(tipo);
                        }
                        tipo=new TiposMaterialProduccion();
                        tipo.setCodTipoMaterialProduccion(res.getInt("COD_TIPO_MATERIAL_PRODUCCION"));
                        tipo.setNombreTipoMaterialProduccion(res.getString("NOMBRE_TIPO_MATERIAL_PRODUCCION"));
                        tipo.setFormulaMaestraDetalleMPList(new ArrayList<FormulaMaestraDetalleMP>());
                    }
                        FormulaMaestraDetalleMP nuevo=new FormulaMaestraDetalleMP();
                        nuevo.getFormulaMaestra().setCodVersion(res.getInt("COD_VERSION"));
                        nuevo.getFormulaMaestra().setCodFormulaMaestra(res.getString("COD_FORMULA_MAESTRA"));
                        nuevo.setMaterialExcepcionSumaTotal(res.getInt("registradoNoSuma")>0);
                        nuevo.getUnidadesMedida().getTipoMedida().setCodTipoMedida(res.getInt("COD_TIPO_MEDIDA"));
                        nuevo.setEquivalenciaAGramos(res.getDouble("equivalenciaG"));
                        nuevo.setEquivalenciaAMiliLitros(res.getDouble("equivalenciaMl"));
                        nuevo.getFormulaMaestra().setCodFormulaMaestra(res.getString(1));
                        nuevo.getTiposMaterialProduccion().setCodTipoMaterialProduccion(res.getInt("COD_TIPO_MATERIAL_PRODUCCION"));
                        nuevo.getTiposMaterialProduccion().setNombreTipoMaterialProduccion(res.getString("NOMBRE_TIPO_MATERIAL_PRODUCCION"));
                        nuevo.getMateriales().setNombreMaterial(res.getString(2));
                        nuevo.setCantidadUnitariaGramos(res.getDouble("CANTIDAD_UNITARIA_GRAMOS"));
                        nuevo.setCantidadTotalGramos(Util.redondeoProduccionSuperior(res.getDouble("CANTIDAD_TOTAL_GRAMOS"),2));
                        nuevo.setCantidadMaximaMaterialPorFraccion(res.getDouble("CANTIDAD_MAXIMA_MATERIAL_POR_FRACCION"));
                        nuevo.setAplicaCantidadMaximaPorFraccion(res.getDouble("CANTIDAD_MAXIMA_MATERIAL_POR_FRACCION")>0);
                        nuevo.setDensidadMaterial(res.getDouble("DENSIDAD_MATERIAL"));
                        nuevo.setCodFormulaMastraDetalleMpVersion(res.getInt("COD_FORMULA_MAESTRA_DETALLE_MP_VERSION"));
                        Double cantidad =Util.redondeoProduccionSuperior(res.getDouble("CANTIDAD"), 2);
                        NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
                        DecimalFormat form = (DecimalFormat) nf;
                        form.applyPattern("#,#00.0#");
                        nuevo.setCantidad(cantidad);
                        nuevo.getUnidadesMedida().setNombreUnidadMedida(res.getString(4));
                        nuevo.getMateriales().setCodMaterial(res.getString(5));
                        nuevo.setNroPreparaciones(res.getInt(6));
                        nuevo.getMateriales().getEstadoRegistro().setNombreEstadoRegistro(res.getString("nombre_estado_registro"));
                        pstFraccion.setInt(1,res.getInt("COD_FORMULA_MAESTRA_DETALLE_MP_VERSION"));
                        resDetalle=pstFraccion.executeQuery();
                        nuevo.setFormulaMaestraDetalleMPfraccionesList(new ArrayList<FormulaMaestraDetalleMPfracciones>());
                        while (resDetalle.next()) 
                        {
                            FormulaMaestraDetalleMPfracciones val = new FormulaMaestraDetalleMPfracciones();
                            val.setCantidad(resDetalle.getDouble(1));
                            val.setPorcientoFraccion(resDetalle.getDouble("PORCIENTO_FRACCION"));
                            nuevo.getFormulaMaestraDetalleMPfraccionesList().add(val);
                        }
                        
                        tipo.getFormulaMaestraDetalleMPList().add(nuevo);
                }
                if(tipo.getCodTipoMaterialProduccion()>0)
                {
                    tiposMaterialProduccionList.add(tipo);
                }
            
        }
        catch (SQLException ex) 
        {
            LOGGER.warn(ex.getMessage());
        }
        finally 
        {
            this.cerrarConexion(con);
        }
        return tiposMaterialProduccionList;
    }
    
    /*
        obtiene listado para agregar materiales a la formula
    */
    public List<FormulaMaestraDetalleMP> listaAgregar(int codFormulaMaestraVersion, int codTipoMaterialProduccion)
    {
        List<FormulaMaestraDetalleMP> formulaMaestraDetalleMPList = new ArrayList<FormulaMaestraDetalleMP>();
        try 
        {
            StringBuilder consulta = new StringBuilder("select m.COD_MATERIAL,m.NOMBRE_MATERIAL,um.ABREVIATURA,um.cod_unidad_medida,g.cod_grupo");
                                                consulta.append(" ,um.COD_TIPO_MEDIDA,e.VALOR_EQUIVALENCIA as equivalenciag,eml.VALOR_EQUIVALENCIA as equivalenciaMl");
                                        consulta.append(" from MATERIALES m inner join GRUPOS g on m.COD_GRUPO=g.COD_GRUPO");
                                                consulta.append(" inner join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=m.COD_UNIDAD_MEDIDA");
                                                consulta.append(" left outer join EQUIVALENCIAS e on e.COD_UNIDAD_MEDIDA=m.COD_UNIDAD_MEDIDA");
                                                        consulta.append(" and e.COD_UNIDAD_MEDIDA2=7 and e.COD_ESTADO_REGISTRO=1");
                                                consulta.append(" left outer join EQUIVALENCIAS eml on eml.COD_UNIDAD_MEDIDA=m.COD_UNIDAD_MEDIDA");
                                                        consulta.append(" and eml.COD_UNIDAD_MEDIDA2=2 and eml.COD_ESTADO_REGISTRO=1");
                                        consulta.append(" where m.COD_ESTADO_REGISTRO=1 and g.COD_CAPITULO=2 and m.MOVIMIENTO_ITEM in (1,2)");
                                                consulta.append(" and um.COD_TIPO_MEDIDA in (1,2)");
                                                consulta.append(" and m.COD_MATERIAL not in (");
                                                        consulta.append(" SELECT fmp.COD_MATERIAL");
                                                        consulta.append(" FROM FORMULA_MAESTRA_DETALLE_MP_VERSION fmp");
                                                        consulta.append(" WHERE fmp.COD_VERSION=").append(codFormulaMaestraVersion);
                                                                consulta.append(" and fmp.COD_TIPO_MATERIAL_PRODUCCION=").append(codTipoMaterialProduccion);
                                                consulta.append(")");
                                        consulta.append(" order by m.NOMBRE_MATERIAL");
            LOGGER.debug("consulta cargar agregar material "+consulta.toString());
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta.toString());
            while(res.next())
            {
                FormulaMaestraDetalleMP nuevo=new FormulaMaestraDetalleMP();
                nuevo.getTiposMaterialProduccion().setCodTipoMaterialProduccion(codTipoMaterialProduccion);
                nuevo.getMateriales().setCodMaterial(res.getString("COD_MATERIAL"));
                nuevo.getMateriales().setNombreMaterial(res.getString("NOMBRE_MATERIAL"));
                nuevo.getUnidadesMedida().getTipoMedida().setCodTipoMedida(res.getInt("COD_TIPO_MEDIDA"));
                nuevo.setEquivalenciaAGramos(res.getDouble("equivalenciag"));
                nuevo.setEquivalenciaAMiliLitros(res.getDouble("equivalenciaMl"));
                nuevo.getUnidadesMedida().setAbreviatura(res.getString("ABREVIATURA"));
                nuevo.getUnidadesMedida().setCodUnidadMedida(res.getString("cod_unidad_medida"));
                nuevo.setCantidad(0);
                nuevo.setCantidadUnitariaGramos(0d);
                nuevo.setCantidadTotalGramos(0d);
                nuevo.setNroDecimalesAlmacen(2);
                formulaMaestraDetalleMPList.add(nuevo);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        finally{
            this.cerrarConexion(con);
        }
        return formulaMaestraDetalleMPList;
    }
    
}
