/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.dao;

import com.cofar.bean.ComponentesPresProdVersion;
import com.cofar.bean.FormulaMaestraDetalleES;
import com.cofar.bean.FormulaMaestraEsVersion;
import com.cofar.util.Util;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/**
 *
 * @author DASISAQ
 */
public class DaoFormulaMaestraDetalleEsVersion extends DaoBean 
{
    public DaoFormulaMaestraDetalleEsVersion() {
        LOGGER=LogManager.getLogger("Versionamiento");
    }
    public DaoFormulaMaestraDetalleEsVersion(Logger LOGGER) {
        this.LOGGER = LOGGER;
    }
    
    public List<FormulaMaestraDetalleES> listarAgregar()
    {
        List<FormulaMaestraDetalleES> formulaMaestraDetalleESList = new ArrayList<>();
        try {
            con = Util.openConnection(con);
            StringBuilder consulta=new StringBuilder(" select m.COD_MATERIAL,m.NOMBRE_MATERIAL,um.ABREVIATURA,um.cod_unidad_medida");
                                    consulta.append(" from materiales m");
                                            consulta.append(" inner join grupos g on g.COD_GRUPO=m.COD_GRUPO");
                                                    consulta.append(" inner join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=m.COD_UNIDAD_MEDIDA");
                                    consulta.append(" where g.COD_CAPITULO in (4,8)");
                                            consulta.append(" and m.COD_MATERIAL  not in (1)");
                                                    consulta.append(" and m.MOVIMIENTO_ITEM=1");
                                    consulta.append(" order by m.NOMBRE_MATERIAL");
            LOGGER.debug(" consulta cargar materiales agregar es  "+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta.toString());
            while(res.next())
            {
                FormulaMaestraDetalleES nuevo=new FormulaMaestraDetalleES();
                nuevo.getMateriales().setCodMaterial(res.getString("COD_MATERIAL"));
                nuevo.getMateriales().setNombreMaterial(res.getString("NOMBRE_MATERIAL"));
                nuevo.getUnidadesMedida().setAbreviatura(res.getString("ABREVIATURA"));
                nuevo.getUnidadesMedida().setCodUnidadMedida(res.getString("cod_unidad_medida"));
                nuevo.setCantidad(0d);
                
                formulaMaestraDetalleESList.add(nuevo);
            }
            res.close();
            st.close();
        } catch (SQLException ex) {
            LOGGER.warn("error", ex);
        } catch (Exception ex) {
            LOGGER.warn("error", ex);
        } finally {
            this.cerrarConexion(con);
        }
        return formulaMaestraDetalleESList;
    }
    
    public List<ComponentesPresProdVersion> listarPorComponentesPresProd(FormulaMaestraEsVersion formulaMaestraEsVersion)
    {
        List<ComponentesPresProdVersion> componentesPresProdList = new ArrayList<>();
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("SELECT cppv.COD_ESTADO_REGISTRO,er.NOMBRE_ESTADO_REGISTRO,cppv.CANT_COMPPROD,cppv.COD_TIPO_PROGRAMA_PROD,tpp.NOMBRE_TIPO_PROGRAMA_PROD,");
                                                consulta.append(" cppv.COD_PRESENTACION,pp.NOMBRE_PRODUCTO_PRESENTACION,m.COD_MATERIAL,m.NOMBRE_MATERIAL,fmdev.CANTIDAD,um.COD_UNIDAD_MEDIDA,um.NOMBRE_UNIDAD_MEDIDA,fmdev.DEFINE_NUMERO_LOTE");
                                        consulta.append(" from COMPONENTES_PRESPROD_VERSION cppv");
                                                consulta.append(" inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=cppv.COD_TIPO_PROGRAMA_PROD");
                                                consulta.append(" inner join PRESENTACIONES_PRODUCTO pp on pp.cod_presentacion=cppv.COD_PRESENTACION");
                                                consulta.append(" inner join ESTADOS_REFERENCIALES er on er.COD_ESTADO_REGISTRO=cppv.COD_ESTADO_REGISTRO");
                                                consulta.append(" inner join FORMULA_MAESTRA_DETALLE_ES_VERSION fmdev");
                                                        consulta.append(" on fmdev.COD_PRESENTACION_PRODUCTO=cppv.COD_PRESENTACION");
                                                        consulta.append(" and cppv.COD_TIPO_PROGRAMA_PROD=fmdev.COD_TIPO_PROGRAMA_PROD");
                                                        consulta.append(" and cppv.COD_FORMULA_MAESTRA_ES_VERSION=fmdev.COD_FORMULA_MAESTRA_ES_VERSION");
                                                consulta.append(" inner join MATERIALES m on m.COD_MATERIAL=fmdev.COD_MATERIAL");
                                                consulta.append(" inner join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=fmdev.COD_UNIDAD_MEDIDA");
                                        consulta.append(" where cppv.COD_VERSION=").append(formulaMaestraEsVersion.getComponentesProdVersion().getCodVersion());
                                                consulta.append(" and cppv.COD_FORMULA_MAESTRA_ES_VERSION=").append(formulaMaestraEsVersion.getCodFormulaMaestraEsVersion());
                                        consulta.append(" order by tpp.NOMBRE_TIPO_PROGRAMA_PROD,pp.NOMBRE_PRODUCTO_PRESENTACION,m.NOMBRE_MATERIAL");
            LOGGER.debug(" consulta cargar componentesPrespord fm " + consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            ComponentesPresProdVersion nuevo=new ComponentesPresProdVersion();
            while (res.next()) 
            {
                if((!nuevo.getPresentacionesProducto().getCodPresentacion().equals(res.getString("COD_PRESENTACION")))||
                        (!nuevo.getTiposProgramaProduccion().getCodTipoProgramaProd().equals(res.getString("COD_TIPO_PROGRAMA_PROD"))))
                {
                    if(!nuevo.getPresentacionesProducto().getCodPresentacion().equals(""))
                    {
                        componentesPresProdList.add(nuevo);
                    }
                    nuevo=new ComponentesPresProdVersion();
                    nuevo.getEstadoReferencial().setCodEstadoRegistro(res.getString("COD_ESTADO_REGISTRO"));
                    nuevo.getEstadoReferencial().setNombreEstadoRegistro(res.getString("NOMBRE_ESTADO_REGISTRO"));
                    nuevo.getTiposProgramaProduccion().setCodTipoProgramaProd(res.getString("COD_TIPO_PROGRAMA_PROD"));
                    nuevo.getTiposProgramaProduccion().setNombreTipoProgramaProd(res.getString("NOMBRE_TIPO_PROGRAMA_PROD"));
                    nuevo.getPresentacionesProducto().setCodPresentacion(res.getString("COD_PRESENTACION"));
                    nuevo.getPresentacionesProducto().setNombreProductoPresentacion(res.getString("NOMBRE_PRODUCTO_PRESENTACION"));
                    nuevo.setCantCompProd(res.getFloat("CANT_COMPPROD"));
                    nuevo.setFormulaMaestraDetalleESList(new ArrayList<FormulaMaestraDetalleES>());
                }
                FormulaMaestraDetalleES bean=new FormulaMaestraDetalleES();
                bean.setCantidad(res.getDouble("CANTIDAD"));
                bean.getMateriales().setCodMaterial(res.getString("COD_MATERIAL"));
                bean.getMateriales().setNombreMaterial(res.getString("NOMBRE_MATERIAL"));
                bean.getUnidadesMedida().setCodUnidadMedida(res.getString("COD_UNIDAD_MEDIDA"));
                bean.getUnidadesMedida().setNombreUnidadMedida(res.getString("NOMBRE_UNIDAD_MEDIDA"));
                bean.setDefineNumeroLote(res.getInt("DEFINE_NUMERO_LOTE")>0);
                nuevo.getFormulaMaestraDetalleESList().add(bean);
            }
            if(!nuevo.getPresentacionesProducto().getCodPresentacion().equals(""))
            {
                componentesPresProdList.add(nuevo);
            }
            res.close();
            st.close();
        } catch (SQLException ex) {
            LOGGER.warn("error", ex);
        } catch (Exception ex) {
            LOGGER.warn("error", ex);
        } finally {
            this.cerrarConexion(con);
        }
        return componentesPresProdList;
    }
    
    public List<FormulaMaestraDetalleES> listarEditar(ComponentesPresProdVersion componentesPresProdVersion,FormulaMaestraEsVersion formulaMaestraEsVersion)
    {
        List<FormulaMaestraDetalleES> formulaEsEditarList = new ArrayList<>();
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select m.COD_MATERIAL,m.NOMBRE_MATERIAL,um.ABREVIATURA,um.cod_unidad_medida,fmdev.CANTIDAD,fmdev.DEFINE_NUMERO_LOTE");
                                            consulta.append(" from materiales m");
                                                    consulta.append(" inner join grupos g on g.COD_GRUPO = m.COD_GRUPO");
                                                    consulta.append(" inner join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA = m.COD_UNIDAD_MEDIDA");
                                                    consulta.append(" left outer join FORMULA_MAESTRA_DETALLE_ES_VERSION fmdev on fmdev.COD_MATERIAL=m.COD_MATERIAL");
                                                            consulta.append(" and fmdev.COD_PRESENTACION_PRODUCTO=").append(componentesPresProdVersion.getPresentacionesProducto().getCodPresentacion());
                                                            consulta.append(" and fmdev.COD_TIPO_PROGRAMA_PROD=").append(componentesPresProdVersion.getTiposProgramaProduccion().getCodTipoProgramaProd());
                                                            consulta.append(" and fmdev.COD_FORMULA_MAESTRA_ES_VERSION=").append(formulaMaestraEsVersion.getCodFormulaMaestraEsVersion());
                                            consulta.append(" where g.COD_CAPITULO in (4, 8) and");
                                                    consulta.append(" m.COD_MATERIAL not in (1) and");
                                                    consulta.append(" m.MOVIMIENTO_ITEM = 1");
                                            consulta.append(" order by case when fmdev.CANTIDAD>0 then 1 else 2 end,m.NOMBRE_MATERIAL");
            LOGGER.debug("consulta cargar " + consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            while (res.next()) 
            {
                FormulaMaestraDetalleES nuevo=new FormulaMaestraDetalleES();
                nuevo.getMateriales().setCodMaterial(res.getString("COD_MATERIAL"));
                nuevo.getMateriales().setNombreMaterial(res.getString("NOMBRE_MATERIAL"));
                nuevo.getUnidadesMedida().setAbreviatura(res.getString("ABREVIATURA"));
                nuevo.getUnidadesMedida().setCodUnidadMedida(res.getString("cod_unidad_medida"));
                nuevo.setChecked(res.getDouble("cantidad")>0);
                nuevo.setCantidad(res.getDouble("cantidad"));
                nuevo.setDefineNumeroLote( res.getInt("DEFINE_NUMERO_LOTE") > 0);
                formulaEsEditarList.add(nuevo);
            }
            res.close();
            st.close();
        } catch (SQLException ex) {
            LOGGER.warn("error", ex);
        } catch (Exception ex) {
            LOGGER.warn("error", ex);
        } finally {
            this.cerrarConexion(con);
        }
        return formulaEsEditarList;
    }
    
    
}
