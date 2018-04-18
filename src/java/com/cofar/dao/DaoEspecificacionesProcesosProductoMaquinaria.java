/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.dao;
import com.cofar.bean.ComponentesProdVersionMaquinariaProceso;
import com.cofar.bean.EspecificacionesProcesosProductoMaquinaria;
import com.cofar.util.Util;
import java.sql.PreparedStatement;
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
public class DaoEspecificacionesProcesosProductoMaquinaria extends DaoBean{

    public DaoEspecificacionesProcesosProductoMaquinaria() {
        LOGGER=LogManager.getRootLogger();
    }
    public DaoEspecificacionesProcesosProductoMaquinaria(Logger LOGGER) {
        this.LOGGER = LOGGER;
    }
    
    public List<EspecificacionesProcesosProductoMaquinaria> listarEditar(ComponentesProdVersionMaquinariaProceso maquinariaProceso){
        
        List<EspecificacionesProcesosProductoMaquinaria> especificacionesList = new ArrayList<>();
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select ep.NOMBRE_ESPECIFICACIONES_PROCESO,isnull(um.NOMBRE_UNIDAD_MEDIDA, '') as NOMBRE_UNIDAD_MEDIDA,ep.COD_ESPECIFICACION_PROCESO,");
                                            consulta.append(" ep.RESULTADO_NUMERICO,isnull(eppm.PORCIENTO_TOLERANCIA,ep.PORCIENTO_TOLERANCIA) as PORCIENTO_TOLERANCIA,um.COD_UNIDAD_MEDIDA");
                                            consulta.append(" ,td.COD_TIPO_DESCRIPCION,td.NOMBRE_TIPO_DESCRIPCION,td.ESPECIFICACION,");
                                            consulta.append(" isnull(eppm.VALOR_EXACTO,ep.VALOR_EXACTO) as VALOR_EXACTO,");
                                            consulta.append(" isnull(eppm.VALOR_TEXTO,ep.VALOR_TEXTO) as VALOR_TEXTO,");
                                            consulta.append(" isnull(eppm.VALOR_MINIMO,ep.VALOR_MINIMO) as VALOR_MINIMO,");
                                            consulta.append(" isnull(eppm.VALOR_MAXIMO,ep.VALOR_MAXIMO) as VALOR_MAXIMO,");
                                            consulta.append(" isnull(eppm.RESULTADO_ESPERADO_LOTE,ep.RESULTADO_ESPERADO_LOTE) as RESULTADO_ESPERADO_LOTE,");
                                            consulta.append(" eppm.COD_ESPECIFICACION_PROCESO_PRODUCTO_MAQUINARIA");
                                            consulta.append(" ,eppm.COD_TIPO_ESPECIFICACIONES_PROCESOS_PRODUCTO_MAQUINARIA");
                                    consulta.append(" from ESPECIFICACIONES_PROCESOS ep");
                                            consulta.append(" left outer join ESPECIFICACIONES_PROCESOS_PRODUCTO_MAQUINARIA eppm on");
                                                consulta.append(" eppm.COD_ESPECIFICACION_PROCESO = ep.COD_ESPECIFICACION_PROCESO and");
                                                consulta.append(" eppm.COD_COMPPROD_VERSION_MAQUINARIA_PROCESO=").append(maquinariaProceso.getCodCompprodVesionMaquinariaProceso());
                                            consulta.append(" left outer join TIPOS_DESCRIPCION td on td.COD_TIPO_DESCRIPCION=isnull(eppm.COD_TIPO_DESCRIPCION,ep.COD_TIPO_DESCRIPCION)");
                                            consulta.append(" left outer join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA =ISNULL(eppm.COD_UNIDAD_MEDIDA,ep.COD_UNIDAD_MEDIDA)");
                                    consulta.append(" where ep.COD_TIPO_ESPECIFICACION_PROCESO=1");
                                            consulta.append(" and ep.COD_FORMA=0");
                                    consulta.append(" order by case when eppm.COD_ESPECIFICACION_PROCESO_PRODUCTO_MAQUINARIA>0 then 1");
                                            consulta.append(" else 2 end");
                                            consulta.append(",ep.ORDEN");
            LOGGER.debug("consulta cargar " + consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            while (res.next()) 
            {
                EspecificacionesProcesosProductoMaquinaria nuevo=new EspecificacionesProcesosProductoMaquinaria();
                nuevo.getEspecificacionesProcesos().setCodEspecificacionProceso(res.getInt("COD_ESPECIFICACION_PROCESO"));
                nuevo.getEspecificacionesProcesos().setNombreEspecificacionProceso(res.getString("NOMBRE_ESPECIFICACIONES_PROCESO"));
                nuevo.getEspecificacionesProcesos().setResultadoNumerico(res.getInt("RESULTADO_NUMERICO")>0);
                nuevo.getEspecificacionesProcesos().setPorcientoTolerancia(res.getDouble("PORCIENTO_TOLERANCIA"));
                nuevo.getEspecificacionesProcesos().getUnidadMedida().setNombreUnidadMedida(res.getString("NOMBRE_UNIDAD_MEDIDA"));
                nuevo.getTiposDescripcion().setCodTipoDescripcion(res.getInt("COD_TIPO_DESCRIPCION"));
                nuevo.getTiposDescripcion().setNombreTipoDescripcion(res.getString("NOMBRE_TIPO_DESCRIPCION"));
                nuevo.getTiposDescripcion().setEspecificacion(res.getString("ESPECIFICACION"));
                nuevo.getUnidadesMedida().setCodUnidadMedida(res.getString("COD_UNIDAD_MEDIDA"));
                nuevo.setValorMinimo(res.getDouble("VALOR_MINIMO"));
                nuevo.setValorMaximo(res.getDouble("VALOR_MAXIMO"));
                nuevo.setValorExacto(res.getDouble("VALOR_EXACTO"));
                nuevo.setValorTexto(res.getString("VALOR_TEXTO"));
                nuevo.setResultadoEsperadoLote(res.getInt("RESULTADO_ESPERADO_LOTE")>0);
                nuevo.setChecked(res.getInt("COD_ESPECIFICACION_PROCESO_PRODUCTO_MAQUINARIA")>0);
                nuevo.getTiposEspecificacionesProcesosProductoMaquinaria().setCodTipoEspecificacionProcesoProductoMaquinaria(res.getInt("COD_TIPO_ESPECIFICACIONES_PROCESOS_PRODUCTO_MAQUINARIA"));
                especificacionesList.add(nuevo);
            }
            res.close();
            st.close();
        }
        catch (SQLException ex) 
        {
            LOGGER.warn("error", ex);
        }
        catch (Exception ex) 
        {
            LOGGER.warn("error", ex);
        }
        finally 
        {
            this.cerrarConexion(con);
        }
        return especificacionesList;
    }
    
    public List<EspecificacionesProcesosProductoMaquinaria> listarAgregarPorRecetaMaquinaria(ComponentesProdVersionMaquinariaProceso maquinariaProceso){
        List<EspecificacionesProcesosProductoMaquinaria> especificacionesProcesosProductoMaquinariaList = new ArrayList<>();
        
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select ep.NOMBRE_ESPECIFICACIONES_PROCESO,isnull(um.NOMBRE_UNIDAD_MEDIDA, '') as NOMBRE_UNIDAD_MEDIDA,ep.COD_ESPECIFICACION_PROCESO,");
                                            consulta.append(" ep.RESULTADO_NUMERICO,ep.PORCIENTO_TOLERANCIA,um.COD_UNIDAD_MEDIDA");
                                            consulta.append(" ,td.COD_TIPO_DESCRIPCION,td.NOMBRE_TIPO_DESCRIPCION,td.ESPECIFICACION,");
                                            consulta.append(" ep.VALOR_EXACTO,ep.VALOR_TEXTO,ep.VALOR_MINIMO,ep.VALOR_MAXIMO,");
                                            consulta.append(" ep.RESULTADO_ESPERADO_LOTE,mrd.COD_ESPECIFICACION_PROCESO as registradoReceta");
                                    consulta.append(" from ESPECIFICACIONES_PROCESOS ep");
                                            consulta.append(" left outer join TIPOS_DESCRIPCION td on td.COD_TIPO_DESCRIPCION=ep.COD_TIPO_DESCRIPCION");
                                            consulta.append(" left outer join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA =ep.COD_UNIDAD_MEDIDA");
                                            consulta.append(" left outer join MAQUINARIA_RECETA_DETALLE_ESPECIFICACION_PROCESO mrd on mrd.COD_ESPECIFICACION_PROCESO=ep.COD_ESPECIFICACION_PROCESO");
                                                    consulta.append(" and  mrd.COD_MAQUINARIA=").append(maquinariaProceso.getMaquinaria().getCodMaquina());
                                    consulta.append(" where ep.COD_TIPO_ESPECIFICACION_PROCESO=1");
                                            consulta.append(" and ep.COD_FORMA=0");
                                    consulta.append(" order by case  when mrd.COD_ESPECIFICACION_PROCESO>0 then 1 ");
                                            consulta.append(" else 2 end");
                                            consulta.append(",ep.ORDEN");
            LOGGER.debug("consulta cargar especificaciones "+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            while (res.next()) 
            {
                EspecificacionesProcesosProductoMaquinaria nuevo=new EspecificacionesProcesosProductoMaquinaria();
                nuevo.getEspecificacionesProcesos().setCodEspecificacionProceso(res.getInt("COD_ESPECIFICACION_PROCESO"));
                nuevo.getEspecificacionesProcesos().setNombreEspecificacionProceso(res.getString("NOMBRE_ESPECIFICACIONES_PROCESO"));
                nuevo.getEspecificacionesProcesos().setResultadoNumerico(res.getInt("RESULTADO_NUMERICO")>0);
                nuevo.getEspecificacionesProcesos().setPorcientoTolerancia(res.getDouble("PORCIENTO_TOLERANCIA"));
                nuevo.getEspecificacionesProcesos().getUnidadMedida().setNombreUnidadMedida(res.getString("NOMBRE_UNIDAD_MEDIDA"));
                nuevo.getTiposDescripcion().setCodTipoDescripcion(res.getInt("COD_TIPO_DESCRIPCION"));
                nuevo.getTiposDescripcion().setNombreTipoDescripcion(res.getString("NOMBRE_TIPO_DESCRIPCION"));
                nuevo.getTiposDescripcion().setEspecificacion(res.getString("ESPECIFICACION"));
                nuevo.getUnidadesMedida().setCodUnidadMedida(res.getString("COD_UNIDAD_MEDIDA"));
                nuevo.setValorMinimo(res.getDouble("VALOR_MINIMO"));
                nuevo.setValorMaximo(res.getDouble("VALOR_MAXIMO"));
                nuevo.setValorExacto(res.getDouble("VALOR_EXACTO"));
                nuevo.setValorTexto(res.getString("VALOR_TEXTO"));
                nuevo.setResultadoEsperadoLote(res.getInt("RESULTADO_ESPERADO_LOTE")>0);
                nuevo.setChecked(res.getInt("registradoReceta")>0);
                especificacionesProcesosProductoMaquinariaList.add(nuevo);
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
        return especificacionesProcesosProductoMaquinariaList;
    }
    
    public List<ComponentesProdVersionMaquinariaProceso> listarPorMaquinaria(ComponentesProdVersionMaquinariaProceso maquinariaBuscar){
        List<ComponentesProdVersionMaquinariaProceso> componentesProdVersionMaquinariaProcesoList = new ArrayList<>();
        try{
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select *")
                                                .append(" from VISTA_ESPECIFICACIONES_PROCESOS_PRODUCTO_MAQUINARIA vep")
                                                .append(" where vep.COD_VERSION = ").append(maquinariaBuscar.getComponentesProdVersion().getCodVersion())
                                                        .append(" and vep.COD_PROCESO_ORDEN_MANUFACTURA=").append(maquinariaBuscar.getProcesosOrdenManufactura().getCodProcesoOrdenManufactura())
                                            .append(" order by vep.NOMBRE_PROCESO_ORDEN_MANUFACTURA,vep.NOMBRE_MAQUINA,vep.ORDEN");
            LOGGER.debug("consulta cargar maquinarias por producto "+consulta);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            ComponentesProdVersionMaquinariaProceso nuevo=new ComponentesProdVersionMaquinariaProceso();
            while (res.next()){
                if(nuevo.getCodCompprodVesionMaquinariaProceso() != res.getInt("COD_COMPPROD_VERSION_MAQUINARIA_PROCESO")){
                    if(nuevo.getCodCompprodVesionMaquinariaProceso() > 0){
                        componentesProdVersionMaquinariaProcesoList.add(nuevo);
                    }
                    nuevo = new ComponentesProdVersionMaquinariaProceso();
                    nuevo.setCodCompprodVesionMaquinariaProceso(res.getInt("COD_COMPPROD_VERSION_MAQUINARIA_PROCESO"));
                    nuevo.getMaquinaria().setCodMaquina(res.getString("COD_MAQUINA"));
                    nuevo.getMaquinaria().setCodigo(res.getString("CODIGO"));
                    nuevo.getMaquinaria().setNombreMaquina(res.getString("NOMBRE_MAQUINA"));
                    nuevo.getProcesosOrdenManufactura().setCodProcesoOrdenManufactura(res.getInt("COD_PROCESO_ORDEN_MANUFACTURA"));
                    nuevo.getProcesosOrdenManufactura().setNombreProcesoOrdenManufactura(res.getString("NOMBRE_PROCESO_ORDEN_MANUFACTURA"));
                    nuevo.setEspecificacionesProcesosProductoMaquinariaList(new ArrayList<>());
                }
                EspecificacionesProcesosProductoMaquinaria esp=new EspecificacionesProcesosProductoMaquinaria();
                esp.getEspecificacionesProcesos().setCodEspecificacionProceso(res.getInt("COD_ESPECIFICACION_PROCESO"));
                esp.getEspecificacionesProcesos().setNombreEspecificacionProceso(res.getString("NOMBRE_ESPECIFICACIONES_PROCESO"));
                esp.getEspecificacionesProcesos().getUnidadMedida().setCodUnidadMedida(res.getString("COD_UNIDAD_MEDIDA"));
                esp.getEspecificacionesProcesos().getUnidadMedida().setNombreUnidadMedida(res.getString("NOMBRE_UNIDAD_MEDIDA"));
                esp.getEspecificacionesProcesos().setResultadoNumerico(res.getInt("RESULTADO_NUMERICO")>0);
                esp.getEspecificacionesProcesos().setPorcientoTolerancia(res.getDouble("PORCIENTO_TOLERANCIA"));
                esp.getTiposDescripcion().setEspecificacion(res.getString("ESPECIFICACION"));
                esp.getTiposDescripcion().setNombreTipoDescripcion(res.getString("NOMBRE_TIPO_DESCRIPCION"));
                esp.getTiposDescripcion().setCodTipoDescripcion(res.getInt("COD_TIPO_DESCRIPCION"));
                esp.setValorExacto(res.getDouble("VALOR_EXACTO"));
                esp.setValorTexto(res.getString("VALOR_TEXTO"));
                esp.setValorMinimo(res.getDouble("VALOR_MINIMO"));
                esp.setValorMaximo(res.getDouble("VALOR_MAXIMO"));
                esp.setResultadoEsperadoLote(res.getInt("RESULTADO_ESPERADO_LOTE")>0);
                esp.getTiposEspecificacionesProcesosProductoMaquinaria().setCodTipoEspecificacionProcesoProductoMaquinaria(res.getInt("COD_TIPO_ESPECIFICACIONES_PROCESOS_PRODUCTO_MAQUINARIA"));
                esp.getTiposEspecificacionesProcesosProductoMaquinaria().setNombreTipoEspecificacionProcesoProductoMaquinaria(res.getString("NOMBRE_TIPO_ESPECIFICACIONES_PROCESOS_PRODUCTO_MAQUINARIA"));
                if(esp.getEspecificacionesProcesos().getCodEspecificacionProceso() > 0){
                    nuevo.getEspecificacionesProcesosProductoMaquinariaList().add(esp);
                }
            }
            if(nuevo.getCodCompprodVesionMaquinariaProceso() > 0){
                componentesProdVersionMaquinariaProcesoList.add(nuevo);
            }
            
        } 
        catch (SQLException ex){
            LOGGER.warn("error", ex);
        }
        finally{
            this.cerrarConexion(con);
        }
        return componentesProdVersionMaquinariaProcesoList;
    }
    
}
