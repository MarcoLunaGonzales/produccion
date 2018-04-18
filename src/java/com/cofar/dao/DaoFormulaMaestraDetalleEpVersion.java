/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.dao;

import com.cofar.bean.FormulaMaestraDetalleEP;
import com.cofar.bean.FormulaMaestraVersion;
import com.cofar.bean.PresentacionesPrimarias;
import com.cofar.util.Util;
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
public class DaoFormulaMaestraDetalleEpVersion extends DaoBean 
{
    public DaoFormulaMaestraDetalleEpVersion() {
        LOGGER=LogManager.getLogger("Versionamiento");
    }
    public DaoFormulaMaestraDetalleEpVersion(Logger LOGGER) {
        this.LOGGER = LOGGER;
    }
    
    public List<PresentacionesPrimarias> listarPorPresentacionPrimaria ( FormulaMaestraVersion formulaMaestraVersion)
    {
        List<PresentacionesPrimarias> presentacionesPrimariasList = new ArrayList<>();
        try
        {
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            StringBuilder consulta=new StringBuilder("select ep.nombre_envaseprim,ep.cod_envaseprim,ppv.CANTIDAD,ppv.cod_presentacion_primaria,");
                                                consulta.append(" ppv.COD_TIPO_PROGRAMA_PROD,tpp.NOMBRE_TIPO_PROGRAMA_PROD,ppv.COD_ESTADO_REGISTRO,er.NOMBRE_ESTADO_REGISTRO,");
                                                consulta.append(" m.NOMBRE_MATERIAL,fmdep.CANTIDAD as cantidadMaterial,fmdep.COD_MATERIAL,fmdep.PORCIENTO_EXCESO,um.NOMBRE_UNIDAD_MEDIDA,fmdep.CANTIDAD_UNITARIA");
                                    consulta.append(" from PRESENTACIONES_PRIMARIAS_VERSION ppv left outer join ENVASES_PRIMARIOS ep on ep.cod_envaseprim=ppv.COD_ENVASEPRIM");
                                            consulta.append(" left outer join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=ppv.COD_TIPO_PROGRAMA_PROD");
                                            consulta.append(" left outer join ESTADOS_REFERENCIALES er on er.COD_ESTADO_REGISTRO=ppv.COD_ESTADO_REGISTRO");
                                            consulta.append(" left outer join FORMULA_MAESTRA_DETALLE_EP_VERSION fmdep on fmdep.COD_PRESENTACION_PRIMARIA=ppv.COD_PRESENTACION_PRIMARIA");
                                                    consulta.append(" and fmdep.COD_FORMULA_MAESTRA=").append(formulaMaestraVersion.getCodFormulaMaestra());
                                                    consulta.append(" and fmdep.COD_VERSION=").append(formulaMaestraVersion.getCodVersion());
                                            consulta.append(" left outer join materiales m on m.COD_MATERIAL=fmdep.COD_MATERIAL");
                                            consulta.append(" left outer join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=fmdep.COD_UNIDAD_MEDIDA");
                                    consulta.append(" where ppv.COD_VERSION=").append(formulaMaestraVersion.getComponentesProd().getCodVersion());
                                    consulta.append(" order by tpp.NOMBRE_TIPO_PROGRAMA_PROD,ppv.COD_PRESENTACION_PRIMARIA,m.NOMBRE_MATERIAL");
            System.out.println("consulta cargar versiones ep "+consulta.toString());
            ResultSet res=st.executeQuery(consulta.toString());
            PresentacionesPrimarias nuevo=new PresentacionesPrimarias();
            NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
            DecimalFormat form = (DecimalFormat) nf;
            form.applyPattern("###0.0#");
            while(res.next())
            {
                if(!nuevo.getCodPresentacionPrimaria().equals(res.getString("cod_presentacion_primaria")))
                {
                    if(!nuevo.getCodPresentacionPrimaria().equals("0"))
                    {
                        presentacionesPrimariasList.add(nuevo);
                    }
                    nuevo=new PresentacionesPrimarias();
                    nuevo.getEnvasesPrimarios().setNombreEnvasePrim(res.getString("nombre_envaseprim"));
                    nuevo.getEnvasesPrimarios().setCodEnvasePrim(res.getString("cod_envaseprim"));
                    nuevo.setCantidad(res.getInt("CANTIDAD"));
                    nuevo.setCodPresentacionPrimaria(res.getString("cod_presentacion_primaria"));
                    nuevo.getTiposProgramaProduccion().setCodTipoProgramaProd(res.getString("COD_TIPO_PROGRAMA_PROD"));
                    nuevo.getTiposProgramaProduccion().setNombreTipoProgramaProd(res.getString("NOMBRE_TIPO_PROGRAMA_PROD"));
                    nuevo.getEstadoReferencial().setCodEstadoRegistro(res.getString("COD_ESTADO_REGISTRO"));
                    nuevo.getEstadoReferencial().setNombreEstadoRegistro(res.getString("NOMBRE_ESTADO_REGISTRO"));
                    nuevo.setFormulaMaestraDetalleEPList(new ArrayList<FormulaMaestraDetalleEP>());
                }
                FormulaMaestraDetalleEP bean = new FormulaMaestraDetalleEP();
                bean.getMateriales().setNombreMaterial(res.getString("NOMBRE_MATERIAL"));
                bean.getMateriales().setCodMaterial(res.getString("COD_MATERIAL"));
                bean.getUnidadesMedida().setNombreUnidadMedida(res.getString("NOMBRE_UNIDAD_MEDIDA"));
                bean.setCantidad(form.format(res.getDouble("cantidadMaterial")));
                bean.setCantidadUnitaria(res.getDouble("CANTIDAD_UNITARIA"));
                bean.setPorcientoExceso(res.getDouble("PORCIENTO_EXCESO"));
                nuevo.getFormulaMaestraDetalleEPList().add(bean);
            }
            if(nuevo.getCodPresentacionPrimaria().length()>0)
            {
                presentacionesPrimariasList.add(nuevo);
            }
            res.close();
            st.close();
            con.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
        return presentacionesPrimariasList;
    }
    
    public List<FormulaMaestraDetalleEP> listarEditar(PresentacionesPrimarias presentacionesPrimarias,FormulaMaestraVersion formulaMaestraVersion)
    {
        List<FormulaMaestraDetalleEP> formulaMaestraDetalleEPList = new ArrayList<>();
        try
        {
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            StringBuilder consulta=new StringBuilder("select m.COD_MATERIAL,m.NOMBRE_MATERIAL,um.ABREVIATURA,um.COD_UNIDAD_MEDIDA");
                                            consulta.append(",isnull(fmde.COD_MATERIAL,0) as registrado,fmde.CANTIDAD,fmde.CANTIDAD_UNITARIA,fmde.PORCIENTO_EXCESO");
                                    consulta.append(" from materiales m inner join grupos g on g.COD_GRUPO=m.COD_GRUPO");
                                            consulta.append(" inner join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=m.COD_UNIDAD_MEDIDA");
                                            consulta.append(" left outer join FORMULA_MAESTRA_DETALLE_EP_VERSION fmde on fmde.COD_MATERIAL=m.COD_MATERIAL");
                                                    consulta.append(" and fmde.COD_VERSION=").append(formulaMaestraVersion.getCodVersion());
                                                    consulta.append(" and fmde.COD_FORMULA_MAESTRA=").append(formulaMaestraVersion.getCodFormulaMaestra());
                                                    consulta.append(" and fmde.COD_PRESENTACION_PRIMARIA=").append(presentacionesPrimarias.getCodPresentacionPrimaria());
                                    consulta.append(" where g.COD_CAPITULO=3 and  m.MOVIMIENTO_ITEM=1 and m.COD_ESTADO_REGISTRO=1");
                                    consulta.append(" order by case when fmde.COD_MATERIAL is null then 2 else 1 end,m.NOMBRE_MATERIAL");
            LOGGER.debug("consulta cargar agregar editar ep "+consulta.toString());
            ResultSet res=st.executeQuery(consulta.toString());
            NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
            DecimalFormat form = (DecimalFormat) nf;
            form.applyPattern("###0.0#");
            while(res.next())
            {
                FormulaMaestraDetalleEP nuevo=new FormulaMaestraDetalleEP();
                nuevo.setChecked(res.getInt("registrado")>0);
                nuevo.setPorcientoExceso(res.getDouble("PORCIENTO_EXCESO"));
                nuevo.getMateriales().setCodMaterial(res.getString("COD_MATERIAL"));
                nuevo.getMateriales().setNombreMaterial(res.getString("NOMBRE_MATERIAL"));
                nuevo.getUnidadesMedida().setAbreviatura(res.getString("ABREVIATURA"));
                nuevo.getUnidadesMedida().setCodUnidadMedida(res.getString("COD_UNIDAD_MEDIDA"));
                nuevo.setCantidad(form.format(Util.redondeoProduccionSuperior(res.getDouble("CANTIDAD"),2)));
                nuevo.setCantidadUnitaria(res.getDouble("CANTIDAD_UNITARIA"));
                formulaMaestraDetalleEPList.add(nuevo);
            }
            res.close();
            st.close();
            con.close();
        } catch (SQLException ex) {
            LOGGER.warn("error", ex);
        } catch (Exception ex) {
            LOGGER.warn("error", ex);
        } finally {
            this.cerrarConexion(con);
        }
        return formulaMaestraDetalleEPList;
    }
    
    public List<FormulaMaestraDetalleEP> listarAgregar()
    {
        List<FormulaMaestraDetalleEP> formulaMaestraDetalleEPList = new ArrayList<>();
        try{
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            StringBuilder consulta=new StringBuilder("select m.COD_MATERIAL,m.NOMBRE_MATERIAL,um.ABREVIATURA,um.COD_UNIDAD_MEDIDA");
                                    consulta.append(" from materiales m inner join grupos g on g.COD_GRUPO=m.COD_GRUPO");
                                            consulta.append(" inner join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=m.COD_UNIDAD_MEDIDA");
                                    consulta.append(" where g.COD_CAPITULO=3 and  m.MOVIMIENTO_ITEM=1 and m.COD_ESTADO_REGISTRO=1");
                                    consulta.append(" order by m.NOMBRE_MATERIAL");
            LOGGER.debug("consulta cargar agregar ep "+consulta.toString());
            ResultSet res=st.executeQuery(consulta.toString());
            while(res.next())
            {
                FormulaMaestraDetalleEP nuevo=new FormulaMaestraDetalleEP();
                nuevo.getMateriales().setCodMaterial(res.getString("COD_MATERIAL"));
                nuevo.getMateriales().setNombreMaterial(res.getString("NOMBRE_MATERIAL"));
                nuevo.getUnidadesMedida().setAbreviatura(res.getString("ABREVIATURA"));
                nuevo.getUnidadesMedida().setCodUnidadMedida(res.getString("COD_UNIDAD_MEDIDA"));
                nuevo.setCantidad("0");
                formulaMaestraDetalleEPList.add(nuevo);
            }
            res.close();
            st.close();
            con.close();
        } catch (SQLException ex) {
            LOGGER.warn("error", ex);
        } catch (Exception ex) {
            LOGGER.warn("error", ex);
        } finally {
            this.cerrarConexion(con);
        }
        return formulaMaestraDetalleEPList;
    }
    
}
