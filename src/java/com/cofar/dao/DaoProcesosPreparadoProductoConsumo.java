/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.dao;

import com.cofar.bean.ProcesosPreparadoConsumoMaterialFm;
import com.cofar.bean.ProcesosPreparadoProducto;
import com.cofar.bean.ProcesosPreparadoProductoConsumo;
import com.cofar.bean.ProcesosPreparadoProductoConsumoProceso;
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
public class DaoProcesosPreparadoProductoConsumo extends DaoBean{
    
    public DaoProcesosPreparadoProductoConsumo() {
        LOGGER = LogManager.getRootLogger();
    }
    public DaoProcesosPreparadoProductoConsumo(Logger LOGGER) {
        this.LOGGER = LOGGER;
    }
    
    public List<ProcesosPreparadoProductoConsumo> listarNoUtilizado(ProcesosPreparadoProducto procesosPreparadoProducto){
        List<ProcesosPreparadoProductoConsumo> procesosPreparadoProductoConsumoList = new ArrayList<>();
        try{
            con = Util.openConnection(con);
            StringBuilder consulta=new StringBuilder("select fmdf.CANTIDAD,m.NOMBRE_MATERIAL,m.COD_MATERIAL,")
                                                .append(" um.ABREVIATURA,fmdf.COD_FORMULA_MAESTRA_FRACCIONES,pasosPosibles.NOMBRE_ACTIVIDAD_PREPARADO")
                                                .append(" ,pasosPosibles.nroPaso,pasosPosibles.pasoPadre")
                                                .append(" ,tmp.COD_TIPO_MATERIAL_PRODUCCION,tmp.NOMBRE_TIPO_MATERIAL_PRODUCCION")
                                                .append(" ,pesoOrdenProducto.pesoOrden as pesoOrdenProducto,pasosPosibles.pesoOrden as pesoPasosPosibles")
                                    .append(" from FORMULA_MAESTRA_DETALLE_MP_VERSION fmd ")
                                            .append(" inner join FORMULA_MAESTRA_DETALLE_MP_FRACCIONES_VERSION fmdf on fmdf.COD_VERSION = fmd.COD_VERSION ")
                                                    .append(" and fmd.COD_MATERIAL = fmdf.COD_MATERIAL")
                                                    .append(" and fmd.COD_TIPO_MATERIAL_PRODUCCION = fmdf.COD_TIPO_MATERIAL_PRODUCCION")
                                            .append(" inner join TIPOS_MATERIAL_PRODUCCION tmp on tmp.COD_TIPO_MATERIAL_PRODUCCION=fmd.COD_TIPO_MATERIAL_PRODUCCION")
                                            .append(" inner join MATERIALES m on m.COD_MATERIAL = fmd.COD_MATERIAL")
                                            .append(" inner join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA =fmd.COD_UNIDAD_MEDIDA")
                                            .append(" left join")
                                            .append(" (")
                                                        .append(" select isnull(ppp2.NRO_PASO,0)*40+ppp1.NRO_PASO*case when isnull(ppp1.COD_PROCESO_PREPARADO_PRODUCTO_PADRE,0)>0 then 1 else 40 end AS pesoOrden")
                                                        .append(" from PROCESOS_PREPARADO_PRODUCTO ppp1")
                                                        .append(" left outer join PROCESOS_PREPARADO_PRODUCTO ppp2 on ppp1.COD_PROCESO_PREPARADO_PRODUCTO_PADRE=ppp2.COD_PROCESO_PREPARADO_PRODUCTO")
                                                        .append(" where ppp1.COD_PROCESO_PREPARADO_PRODUCTO=").append(procesosPreparadoProducto.getCodProcesoPreparadoProducto())
                                                .append(" ) as pesoOrdenProducto on 1=1")    
                                            .append(" left JOIN")
                                            .append(" (")
                                                    .append(" select ppcm.COD_FORMULA_MAESTRA_FRACCIONES,ppcm.COD_MATERIAL,ppcm.COD_TIPO_MATERIAL_PRODUCCION")
                                                    .append(" from PROCESOS_PREPARADO_PRODUCTO_CONSUMO pppc ")
                                                    .append(" inner join PROCESOS_PREPARADO_PRODUCTO_CONSUMO_MATERIAL_FM ppcm on pppc.COD_PROCESO_PREPARADO_PRODUCTO_CONSUMO=ppcm.COD_PROCESO_PREPARADO_PRODUCTO_CONSUMO")
                                                    .append(" where pppc.COD_PROCESO_PREPARADO_PRODUCTO=").append(procesosPreparadoProducto.getCodProcesoPreparadoProducto())
                                            .append(" ) as datoConsumoFm on datoConsumoFm.COD_FORMULA_MAESTRA_FRACCIONES =fmdf.COD_FORMULA_MAESTRA_FRACCIONES")
                                                    .append(" and datoConsumoFm.COD_MATERIAL = fmdf.COD_MATERIAL")
                                                    .append(" and datoConsumoFm.COD_TIPO_MATERIAL_PRODUCCION = fmdf.COD_TIPO_MATERIAL_PRODUCCION")
                                            .append(" left join")
                                            .append(" (")
                                                    .append(" select cast (pp1.NRO_PASO as varchar) as pasoPadre,ISNULL(ppp.NRO_PASO, '') as nroPaso,ap.NOMBRE_ACTIVIDAD_PREPARADO,")
                                                            .append(" ppcm1.COD_FORMULA_MAESTRA_FRACCIONES,ppcm1.COD_MATERIAL,ppcm1.COD_TIPO_MATERIAL_PRODUCCION")
                                                            .append(" ,isnull(pp1.NRO_PASO, 0) * 40 + ppp.NRO_PASO * case when isnull( ppp.COD_PROCESO_PREPARADO_PRODUCTO_PADRE, 0) > 0 then 1 else 40 end AS pesoOrden")
                                                    .append(" from PROCESOS_PREPARADO_PRODUCTO ppp")
                                                            .append(" inner join PROCESOS_PREPARADO_PRODUCTO_CONSUMO ppc1 on ppc1.COD_PROCESO_PREPARADO_PRODUCTO =ppp.COD_PROCESO_PREPARADO_PRODUCTO")
                                                            .append(" inner join PROCESOS_PREPARADO_PRODUCTO_CONSUMO_MATERIAL_FM ppcm1 on ppcm1.COD_PROCESO_PREPARADO_PRODUCTO_CONSUMO=ppc1.COD_PROCESO_PREPARADO_PRODUCTO_CONSUMO")
                                                            .append(" left outer join PROCESOS_PREPARADO_PRODUCTO pp1 on pp1.COD_PROCESO_PREPARADO_PRODUCTO = ppp.COD_PROCESO_PREPARADO_PRODUCTO_PADRE")
                                                            .append(" inner join ACTIVIDADES_PREPARADO ap on ap.COD_ACTIVIDAD_PREPARADO = ppp.COD_ACTIVIDAD_PREPARADO")
                                                    .append(" where ppp.COD_VERSION = ").append(procesosPreparadoProducto.getComponentesProdVersion().getCodVersion())
                                                            .append(" and ppc1.MATERIAL_TRANSITORIO <> 1 ")
                                                            .append(" and ppp.COD_PROCESO_PREPARADO_PRODUCTO <>").append(procesosPreparadoProducto.getCodProcesoPreparadoProducto())
                                            .append(" ) pasosPosibles on pasosPosibles.COD_FORMULA_MAESTRA_FRACCIONES=fmdf.COD_FORMULA_MAESTRA_FRACCIONES")
                                                    .append(" and pasosPosibles.COD_MATERIAL=fmdf.COD_MATERIAL")
                                                    .append(" and pasosPosibles.COD_TIPO_MATERIAL_PRODUCCION=fmdf.COD_TIPO_MATERIAL_PRODUCCION")
                                    .append(" where fmd.COD_VERSION = ").append(procesosPreparadoProducto.getComponentesProdVersion().getCodFormulaMaestraVersion())
                                            .append(" and datoConsumoFm.COD_MATERIAL is null")
                                    .append(" order by m.NOMBRE_MATERIAL,fmdf.COD_FORMULA_MAESTRA_FRACCIONES");
            LOGGER.debug(" materiales no utilizados "+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            while (res.next()) 
            {
                ProcesosPreparadoProductoConsumo nuevo=new ProcesosPreparadoProductoConsumo();
                nuevo.getProcesosPreparadoProducto().setNroPaso(res.getInt("nroPaso"));
                nuevo.getProcesosPreparadoProducto().getActividadesPreparado().setNombreActividadPreparado(res.getString("NOMBRE_ACTIVIDAD_PREPARADO"));
                nuevo.getProcesosPreparadoProducto().setProcesosPreparadoProductoPadre(new ProcesosPreparadoProducto());
                nuevo.getProcesosPreparadoProducto().getProcesosPreparadoProductoPadre().setNroPaso(res.getInt("pasoPadre"));
                nuevo.setChecked(res.getInt("pesoOrdenProducto") < res.getInt("pesoPasosPosibles") || res.getInt("pesoPasosPosibles") == 0 );
                nuevo.setProcesosPreparadoConsumoMaterialFm(new ProcesosPreparadoConsumoMaterialFm());
                nuevo.getProcesosPreparadoConsumoMaterialFm().getFormulaMaestraDetalleMPfracciones().getMateriales().setCodMaterial(res.getString("COD_MATERIAL"));
                nuevo.getProcesosPreparadoConsumoMaterialFm().getFormulaMaestraDetalleMPfracciones().getMateriales().setNombreMaterial(res.getString("NOMBRE_MATERIAL"));
                nuevo.getProcesosPreparadoConsumoMaterialFm().getFormulaMaestraDetalleMPfracciones().setCodFormulaMaestraFracciones(res.getString("COD_FORMULA_MAESTRA_FRACCIONES"));
                nuevo.getProcesosPreparadoConsumoMaterialFm().getFormulaMaestraDetalleMPfracciones().getMateriales().getUnidadesMedida().setAbreviatura(res.getString("ABREVIATURA"));
                nuevo.getProcesosPreparadoConsumoMaterialFm().getFormulaMaestraDetalleMPfracciones().getTiposMaterialProduccion().setCodTipoMaterialProduccion(res.getInt("COD_TIPO_MATERIAL_PRODUCCION"));
                nuevo.getProcesosPreparadoConsumoMaterialFm().getFormulaMaestraDetalleMPfracciones().getTiposMaterialProduccion().setNombreTipoMaterialProduccion(res.getString("NOMBRE_TIPO_MATERIAL_PRODUCCION"));
                nuevo.getProcesosPreparadoConsumoMaterialFm().getFormulaMaestraDetalleMPfracciones().setCantidad(res.getDouble("CANTIDAD"));
                
                procesosPreparadoProductoConsumoList.add(nuevo);
            }
            consulta=new StringBuilder("select ppp.COD_PROCESO_PREPARADO_PRODUCTO,ppp.SUSTANCIA_RESULTANTE")
                                        .append(" ,pasosPosibles.NOMBRE_ACTIVIDAD_PREPARADO,pasosPosibles.nroPaso,pasosPosibles.pasoPadre")
                                        .append(" ,pesoOrdenProducto.pesoOrden as pesoOrdenProducto,pasosPosibles.pesoOrden as pesoPasosPosibles")
                                .append(" from PROCESOS_PREPARADO_PRODUCTO ppp")
                                        .append(" left outer join PROCESOS_PREPARADO_PRODUCTO pp1 on ppp.COD_PROCESO_PREPARADO_PRODUCTO_PADRE=pp1.COD_PROCESO_PREPARADO_PRODUCTO")
                                        .append(" left join")
                                        .append(" (")
                                                .append(" select ppcp.COD_PROCESO_PREPARADO_PRODUCTO ")
                                                .append(" from PROCESOS_PREPARADO_PRODUCTO_CONSUMO  ppc")
                                                .append(" inner join PROCESOS_PREPARADO_PRODUCTO_CONSUMO_PROCESO ppcp on ppc.COD_PROCESO_PREPARADO_PRODUCTO_CONSUMO = ppcp.COD_PROCESO_PREPARADO_PRODUCTO_CONSUMO")
                                                .append(" where ppc.COD_PROCESO_PREPARADO_PRODUCTO =").append(procesosPreparadoProducto.getCodProcesoPreparadoProducto())
                                                .append(" and ppc.MATERIAL_TRANSITORIO<>1")
                                        .append(" ) as consumoRegistrado on consumoRegistrado.COD_PROCESO_PREPARADO_PRODUCTO=ppp.COD_PROCESO_PREPARADO_PRODUCTO")
                                        .append(" inner join")
                                        .append(" (")
                                                .append(" select isnull(ppp2.NRO_PASO,0)*40+ppp1.NRO_PASO*case when isnull(ppp1.COD_PROCESO_PREPARADO_PRODUCTO_PADRE,0)>0 then 1 else 40 end ")
                                                .append(" AS pesoOrden")
                                                .append(" from PROCESOS_PREPARADO_PRODUCTO ppp1")
                                                .append(" left outer join PROCESOS_PREPARADO_PRODUCTO ppp2 on ppp1.COD_PROCESO_PREPARADO_PRODUCTO_PADRE=ppp2.COD_PROCESO_PREPARADO_PRODUCTO")
                                                .append(" where ppp1.COD_PROCESO_PREPARADO_PRODUCTO=").append(procesosPreparadoProducto.getCodProcesoPreparadoProducto())
                                        .append(" ) as pesoOrdenProducto on pesoOrdenProducto.pesoOrden>isnull(pp1.NRO_PASO,0)*40+ppp.NRO_PASO*case when isnull(ppp.COD_PROCESO_PREPARADO_PRODUCTO_PADRE,0) > 0 then 1 else 40 end ")    
                                        .append(" LEFT JOIN")
                                        .append(" (")
                                                .append(" SELECT cast (pp2.NRO_PASO as varchar) as pasoPadre,ISNULL(pp1.NRO_PASO, '') as nroPaso,ap.NOMBRE_ACTIVIDAD_PREPARADO,")
                                                        .append(" ppcp1.COD_PROCESO_PREPARADO_PRODUCTO,")
                                                        .append(" isnull(pp2.NRO_PASO, 0) * 40 + pp1.NRO_PASO * case when isnull( pp1.COD_PROCESO_PREPARADO_PRODUCTO_PADRE, 0) > 0 then 1 else 40 end AS pesoOrden")
                                                .append(" FROM PROCESOS_PREPARADO_PRODUCTO pp1")
                                                        .append(" inner join PROCESOS_PREPARADO_PRODUCTO_CONSUMO ppc1 on ppc1.COD_PROCESO_PREPARADO_PRODUCTO=pp1.COD_PROCESO_PREPARADO_PRODUCTO")
                                                        .append(" inner join PROCESOS_PREPARADO_PRODUCTO_CONSUMO_PROCESO ppcp1 on ppcp1.COD_PROCESO_PREPARADO_PRODUCTO_CONSUMO=ppc1.COD_PROCESO_PREPARADO_PRODUCTO_CONSUMO")
                                                        .append(" left outer join PROCESOS_PREPARADO_PRODUCTO pp2 on pp2.COD_PROCESO_PREPARADO_PRODUCTO = pp1.COD_PROCESO_PREPARADO_PRODUCTO_PADRE")
                                                        .append(" inner join ACTIVIDADES_PREPARADO ap on ap.COD_ACTIVIDAD_PREPARADO = pp1.COD_ACTIVIDAD_PREPARADO")
                                                .append(" where pp1.COD_VERSION=").append(procesosPreparadoProducto.getComponentesProdVersion().getCodVersion())
                                                        .append(" and pp1.COD_PROCESO_PREPARADO_PRODUCTO<>").append(procesosPreparadoProducto.getCodProcesoPreparadoProducto())
                                                        .append(" AND ppc1.MATERIAL_TRANSITORIO<>1")
                                        .append(" )pasosPosibles on pasosPosibles.COD_PROCESO_PREPARADO_PRODUCTO=ppp.COD_PROCESO_PREPARADO_PRODUCTO")
                                .append(" where ppp.COD_VERSION=").append(procesosPreparadoProducto.getComponentesProdVersion().getCodVersion())
                                        .append(" and len(RTRIM(ppp.SUSTANCIA_RESULTANTE))>0")
                                        .append(" and consumoRegistrado.COD_PROCESO_PREPARADO_PRODUCTO is null")
                                .append(" order by ppp.NRO_PASO,ppp.DESCRIPCION");
            LOGGER.debug("consulta cargar sustancia resultantes no incluidas "+consulta.toString());
            res=st.executeQuery(consulta.toString());
            while(res.next())
            {
                ProcesosPreparadoProductoConsumo nuevo=new ProcesosPreparadoProductoConsumo();
                nuevo.setChecked(res.getInt("pesoOrdenProducto") < res.getInt("pesoPasosPosibles") || res.getInt("pesoPasosPosibles") == 0 );
                nuevo.getProcesosPreparadoProducto().setNroPaso(res.getInt("nroPaso"));
                nuevo.getProcesosPreparadoProducto().getActividadesPreparado().setNombreActividadPreparado(res.getString("NOMBRE_ACTIVIDAD_PREPARADO"));
                nuevo.getProcesosPreparadoProducto().setProcesosPreparadoProductoPadre(new ProcesosPreparadoProducto());
                nuevo.getProcesosPreparadoProducto().getProcesosPreparadoProductoPadre().setNroPaso(res.getInt("pasoPadre"));
                nuevo.setProcesosPreparadoProductoConsumoProceso(new ProcesosPreparadoProductoConsumoProceso());
                nuevo.getProcesosPreparadoProductoConsumoProceso().getProcesosPreparadoProducto().setCodProcesoPreparadoProducto(res.getInt("COD_PROCESO_PREPARADO_PRODUCTO"));
                nuevo.getProcesosPreparadoProductoConsumoProceso().getProcesosPreparadoProducto().setSustanciaResultante(res.getString("SUSTANCIA_RESULTANTE"));
                procesosPreparadoProductoConsumoList.add(nuevo);
            }
            st.close();
        }
        catch (SQLException ex) 
        {
            LOGGER.warn("error", ex);
        } 
        finally 
        {
            this.cerrarConexion(con);
        }
        return procesosPreparadoProductoConsumoList;
    }
    
    public List<ProcesosPreparadoProductoConsumo> listar(ProcesosPreparadoProducto procesosPreparadoProducto)
    {
        List<ProcesosPreparadoProductoConsumo> procesosPreparadoProductoConsumoList = new ArrayList<>();
        try{
            con = Util.openConnection(con);
            StringBuilder consulta =
                    new StringBuilder("select * ")
                                .append(" from ")
                                .append(" (")
                                        .append(" select vpc.NOMBRE_MATERIAL,vpc.COD_MATERIAL,vpc.ABREVIATURA,vpc.CANTIDAD,vpc.MATERIAL_TRANSITORIO,")
                                                .append(" vpc.COD_FORMULA_MAESTRA_FRACCIONES,vpc.COD_TIPO_MATERIAL_PRODUCCION,")
                                                .append(" vpc.NOMBRE_TIPO_MATERIAL_PRODUCCION,0 as COD_PROCESO_PREPARADO_PRODUCTO,'' AS SUSTANCIA_RESULTANTE,")
                                                .append(" pasosPosibles.NOMBRE_ACTIVIDAD_PREPARADO,pasosPosibles.nroPaso,pasosPosibles.pasoPadre,vpc.ORDEN_ADICION")
                                        .append(" from VISTA_PROCESOS_PREPARADO_PRODUCTO_CONSUMO vpc")
                                                .append(" left join")
                                                .append(" (")
                                                        .append(" select cast (pp1.NRO_PASO as varchar) as pasoPadre,ISNULL(ppp.NRO_PASO, '') as nroPaso,ap.NOMBRE_ACTIVIDAD_PREPARADO,")
                                                                .append(" ppcm1.COD_FORMULA_MAESTRA_FRACCIONES,ppcm1.COD_MATERIAL,ppcm1.COD_TIPO_MATERIAL_PRODUCCION")
                                                        .append(" from PROCESOS_PREPARADO_PRODUCTO ppp")
                                                                .append(" inner join PROCESOS_PREPARADO_PRODUCTO_CONSUMO ppc1 on ppc1.COD_PROCESO_PREPARADO_PRODUCTO =ppp.COD_PROCESO_PREPARADO_PRODUCTO")
                                                                .append(" inner join PROCESOS_PREPARADO_PRODUCTO_CONSUMO_MATERIAL_FM ppcm1 on ppcm1.COD_PROCESO_PREPARADO_PRODUCTO_CONSUMO=ppc1.COD_PROCESO_PREPARADO_PRODUCTO_CONSUMO")
                                                                .append(" left outer join PROCESOS_PREPARADO_PRODUCTO pp1 on pp1.COD_PROCESO_PREPARADO_PRODUCTO = ppp.COD_PROCESO_PREPARADO_PRODUCTO_PADRE")
                                                                .append(" inner join ACTIVIDADES_PREPARADO ap on ap.COD_ACTIVIDAD_PREPARADO = ppp.COD_ACTIVIDAD_PREPARADO")
                                                        .append(" where ppp.COD_VERSION = ").append(procesosPreparadoProducto.getComponentesProdVersion().getCodVersion())
                                                                .append(" and ppc1.MATERIAL_TRANSITORIO <> 1 ")
                                                                .append(" and ppp.COD_PROCESO_PREPARADO_PRODUCTO <>").append(procesosPreparadoProducto.getCodProcesoPreparadoProducto())
                                                .append(" ) pasosPosibles on pasosPosibles.COD_FORMULA_MAESTRA_FRACCIONES=vpc.COD_FORMULA_MAESTRA_FRACCIONES")
                                                        .append(" and pasosPosibles.COD_MATERIAL=vpc.COD_MATERIAL")
                                                        .append(" and pasosPosibles.COD_TIPO_MATERIAL_PRODUCCION=vpc.COD_TIPO_MATERIAL_PRODUCCION")
                                        .append(" where vpc.COD_VERSION_FORMULA = ").append(procesosPreparadoProducto.getComponentesProdVersion().getCodFormulaMaestraVersion())
                                        .append(" and vpc.COD_PROCESO_PREPARADO_PRODUCTO = ").append(procesosPreparadoProducto.getCodProcesoPreparadoProducto())
                                    .append(" union")
                                        .append(" select '' as NOMBRE_MATERIAL,0 as COD_MATERIAL,'' as ABREVIATURA,0 as CANTIDAD,vpp.MATERIAL_TRANSITORIO,")
                                                .append(" 0 as COD_FORMULA_MAESTRA_FRACCIONES,0 as COD_TIPO_MATERIAL_PRODUCCION,")
                                                .append(" '' as NOMBRE_TIPO_MATERIAL_PRODUCCION,vpp.COD_PROCESO_PREPARADO_PRODUCTO,vpp.SUSTANCIA_RESULTANTE,")
                                                .append(" pasosPosibles.NOMBRE_ACTIVIDAD_PREPARADO,pasosPosibles.nroPaso,pasosPosibles.pasoPadre,vpp.ORDEN_ADICION")
                                        .append(" from VISTA_PROCESOS_PREPARADO_PRODUCTO_CONSUMO_PROCESO vpp")
                                                .append(" LEFT JOIN")
                                                .append(" (")
                                                        .append(" SELECT cast (pp2.NRO_PASO as varchar) as pasoPadre,ISNULL(pp1.NRO_PASO, '') as nroPaso,ap.NOMBRE_ACTIVIDAD_PREPARADO,")
                                                                .append(" ppcp1.COD_PROCESO_PREPARADO_PRODUCTO")
                                                        .append(" FROM PROCESOS_PREPARADO_PRODUCTO pp1")
                                                                .append(" inner join PROCESOS_PREPARADO_PRODUCTO_CONSUMO ppc1 on ppc1.COD_PROCESO_PREPARADO_PRODUCTO=pp1.COD_PROCESO_PREPARADO_PRODUCTO")
                                                                .append(" inner join PROCESOS_PREPARADO_PRODUCTO_CONSUMO_PROCESO ppcp1 on ppcp1.COD_PROCESO_PREPARADO_PRODUCTO_CONSUMO=ppc1.COD_PROCESO_PREPARADO_PRODUCTO_CONSUMO")
                                                                .append(" left outer join PROCESOS_PREPARADO_PRODUCTO pp2 on pp2.COD_PROCESO_PREPARADO_PRODUCTO = pp1.COD_PROCESO_PREPARADO_PRODUCTO_PADRE")
                                                                .append(" inner join ACTIVIDADES_PREPARADO ap on ap.COD_ACTIVIDAD_PREPARADO = pp1.COD_ACTIVIDAD_PREPARADO")
                                                        .append(" where pp1.COD_VERSION=").append(procesosPreparadoProducto.getComponentesProdVersion().getCodVersion())
                                                                .append(" and pp1.COD_PROCESO_PREPARADO_PRODUCTO<>").append(procesosPreparadoProducto.getCodProcesoPreparadoProducto())
                                                                .append(" AND ppc1.MATERIAL_TRANSITORIO<>1")
                                                .append(" )pasosPosibles on pasosPosibles.COD_PROCESO_PREPARADO_PRODUCTO=vpp.COD_PROCESO_PREPARADO_PRODUCTO")
                                        .append(" where vpp.COD_PROCESO_PREPARADO_PRODUCTO_BASE=").append(procesosPreparadoProducto.getCodProcesoPreparadoProducto())
                                .append(" ) as datosConsumo")
                                .append(" order by datosConsumo.ORDEN_ADICION");
            LOGGER.debug("consulta materiales utilizados "+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            while (res.next()) 
            {
                ProcesosPreparadoProductoConsumo nuevo=new ProcesosPreparadoProductoConsumo();
                nuevo.setMaterialTransitorio(res.getInt("MATERIAL_TRANSITORIO")>0);
                nuevo.getProcesosPreparadoProducto().setNroPaso(res.getInt("nroPaso"));
                nuevo.getProcesosPreparadoProducto().getActividadesPreparado().setNombreActividadPreparado(res.getString("NOMBRE_ACTIVIDAD_PREPARADO"));
                nuevo.getProcesosPreparadoProducto().setProcesosPreparadoProductoPadre(new ProcesosPreparadoProducto());
                nuevo.getProcesosPreparadoProducto().getProcesosPreparadoProductoPadre().setNroPaso(res.getInt("pasoPadre"));
                if(res.getInt("COD_MATERIAL")>0)
                {
                    nuevo.setProcesosPreparadoConsumoMaterialFm(new ProcesosPreparadoConsumoMaterialFm());
                    nuevo.getProcesosPreparadoConsumoMaterialFm().getFormulaMaestraDetalleMPfracciones().getMateriales().setCodMaterial(res.getString("COD_MATERIAL"));
                    nuevo.getProcesosPreparadoConsumoMaterialFm().getFormulaMaestraDetalleMPfracciones().getMateriales().setNombreMaterial(res.getString("NOMBRE_MATERIAL"));
                    nuevo.getProcesosPreparadoConsumoMaterialFm().getFormulaMaestraDetalleMPfracciones().setCodFormulaMaestraFracciones(res.getString("COD_FORMULA_MAESTRA_FRACCIONES"));
                    nuevo.getProcesosPreparadoConsumoMaterialFm().getFormulaMaestraDetalleMPfracciones().getMateriales().getUnidadesMedida().setAbreviatura(res.getString("ABREVIATURA"));
                    nuevo.getProcesosPreparadoConsumoMaterialFm().getFormulaMaestraDetalleMPfracciones().getTiposMaterialProduccion().setCodTipoMaterialProduccion(res.getInt("COD_TIPO_MATERIAL_PRODUCCION"));
                    nuevo.getProcesosPreparadoConsumoMaterialFm().getFormulaMaestraDetalleMPfracciones().getTiposMaterialProduccion().setNombreTipoMaterialProduccion(res.getString("NOMBRE_TIPO_MATERIAL_PRODUCCION"));
                    nuevo.getProcesosPreparadoConsumoMaterialFm().getFormulaMaestraDetalleMPfracciones().setCantidad(res.getDouble("CANTIDAD"));
                }
                if(res.getInt("COD_PROCESO_PREPARADO_PRODUCTO")>0)
                {
                    nuevo.setProcesosPreparadoProductoConsumoProceso(new ProcesosPreparadoProductoConsumoProceso());
                    nuevo.getProcesosPreparadoProductoConsumoProceso().getProcesosPreparadoProducto().setCodProcesoPreparadoProducto(res.getInt("COD_PROCESO_PREPARADO_PRODUCTO"));
                    nuevo.getProcesosPreparadoProductoConsumoProceso().getProcesosPreparadoProducto().setSustanciaResultante(res.getString("SUSTANCIA_RESULTANTE"));
                }
                procesosPreparadoProductoConsumoList.add(nuevo);
            }
            st.close();
        }
        catch (SQLException ex) 
        {
            LOGGER.warn("error", ex);
        } 
        finally 
        {
            this.cerrarConexion(con);
        }
        return procesosPreparadoProductoConsumoList;
    }
    
}
