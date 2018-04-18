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
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import javax.faces.model.SelectItem;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/**
 *
 * @author DASISAQ
 */
public class DaoFormulaMaestraDetalleMpFraccionesVersion extends DaoBean 
{
    public DaoFormulaMaestraDetalleMpFraccionesVersion() {
        LOGGER = LogManager.getRootLogger();
    }
    
    public DaoFormulaMaestraDetalleMpFraccionesVersion(Logger LOGGER) {
        this.LOGGER = LOGGER;
    }
    
    public boolean registrarFormulaMaestraDetalleMpFraccionesVersion(FormulaMaestraDetalleMP formulaMaestraDetalleMPRegistrar)throws SQLException
    {
        LOGGER.info("---------------------------------------INICIO MODIFICANDO FRACCIONES-----------------------------");
        boolean registroExitoso=false;
        try {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta = new StringBuilder("delete FORMULA_MAESTRA_DETALLE_MP_FRACCIONES_VERSION");
                                    consulta.append(" where COD_FORMULA_MAESTRA_DETALLE_MP_VERSION=").append(formulaMaestraDetalleMPRegistrar.getCodFormulaMastraDetalleMpVersion());
            LOGGER.debug("consulta eliminar fracciones " + consulta.toString());
            PreparedStatement pst = con.prepareStatement(consulta.toString());
            if(pst.executeUpdate()>0)LOGGER.info("se eliminaron las fracciones ");
            consulta=new StringBuilder("INSERT INTO FORMULA_MAESTRA_DETALLE_MP_FRACCIONES_VERSION(COD_VERSION,COD_FORMULA_MAESTRA, COD_MATERIAL, COD_FORMULA_MAESTRA_FRACCIONES, CANTIDAD,");
                        consulta.append(" COD_TIPO_MATERIAL_PRODUCCION, PORCIENTO_FRACCION,COD_FORMULA_MAESTRA_DETALLE_MP_VERSION)");
                        consulta.append(" VALUES (");
                                consulta.append(formulaMaestraDetalleMPRegistrar.getFormulaMaestra().getCodVersion()).append(",");
                                consulta.append(formulaMaestraDetalleMPRegistrar.getFormulaMaestra().getCodFormulaMaestra()).append(",");
                                consulta.append(formulaMaestraDetalleMPRegistrar.getMateriales().getCodMaterial()).append(",");
                                consulta.append("?,");//cod formula maestra fracciones
                                consulta.append("?,");//cantidad
                                consulta.append(formulaMaestraDetalleMPRegistrar.getTiposMaterialProduccion().getCodTipoMaterialProduccion()).append(",");
                                consulta.append("?,");//porciento fraccion
                                consulta.append(formulaMaestraDetalleMPRegistrar.getCodFormulaMastraDetalleMpVersion());
                        consulta.append(")");
            LOGGER.debug("consulta registrar fracciones modificadas "+consulta.toString());
            pst=con.prepareStatement(consulta.toString());
            int cont=0;
            for(FormulaMaestraDetalleMPfracciones bean:formulaMaestraDetalleMPRegistrar.getFormulaMaestraDetalleMPfraccionesList())
            {
                bean.setPorcientoFraccion(bean.getCantidad()/formulaMaestraDetalleMPRegistrar.getCantidadTotalGramos()*100);
                pst.setInt(1, cont);LOGGER.info("p1: "+cont);
                pst.setDouble(2,bean.getCantidad());LOGGER.info("p2: "+bean.getCantidad());
                pst.setDouble(3,bean.getPorcientoFraccion());LOGGER.info("p3:"+bean.getPorcientoFraccion());
                if(pst.executeUpdate()>0)LOGGER.info("se registro la fraccion ");
                cont++;
            }
            
            con.commit();
            registroExitoso=true;
            pst.close();
        } catch (SQLException ex) {
            con.rollback();
            registroExitoso=false;
            LOGGER.warn(ex.getMessage());
        } catch (NumberFormatException ex) {
            con.rollback();
            registroExitoso=false;
            LOGGER.warn(ex.getMessage());
        } finally {
            con.close();
        }
        LOGGER.info("---------------------------------------FIN MODIFICANDO FRACCIONES-----------------------------");
        return registroExitoso;
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
                                            consulta.append(",isnull(ffme.COD_FORMA,0) as registradoNoSuma");
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
    
}
