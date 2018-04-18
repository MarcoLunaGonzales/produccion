/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.dao;

import com.cofar.bean.ProcesosPreparadoProducto;
import com.cofar.bean.ProcesosPreparadoProductoEspecificacionesMaquinaria;
import com.cofar.bean.ProcesosPreparadoProductoMaquinaria;
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
public class DaoProcesosPreparadoProductoEspecificacionesMaquinaria extends DaoBean{
    
    public DaoProcesosPreparadoProductoEspecificacionesMaquinaria() {
        LOGGER = LogManager.getRootLogger();
    }
    
    public DaoProcesosPreparadoProductoEspecificacionesMaquinaria(Logger LOGGER) {
        this.LOGGER = LOGGER;
    }
    
    public List<ProcesosPreparadoProductoEspecificacionesMaquinaria> listarEditar(ProcesosPreparadoProductoMaquinaria procesosPreparadoProductoMaquinaria)
    {
        List<ProcesosPreparadoProductoEspecificacionesMaquinaria> procesosMaquinariaEspecificacionesList = new ArrayList<>();
        try 
        {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select pppem.COD_PROCESO_PREPARADO_PRODUCTO_ESPECIFICACIONES_MAQUINARIA,");
                                            consulta.append(" ep.NOMBRE_ESPECIFICACIONES_PROCESO,ep.COD_ESPECIFICACION_PROCESO,");
                                            consulta.append(" isnull(pppem.PORCIENTO_TOLERANCIA,ep.PORCIENTO_TOLERANCIA) as PORCIENTO_TOLERANCIA,");
                                            consulta.append(" isnull(pppem.COD_TIPO_DESCRIPCION,ep.COD_TIPO_DESCRIPCION) as COD_TIPO_DESCRIPCION,isnull(pppem.VALOR_EXACTO, ep.VALOR_EXACTO) as VALOR_EXACTO, ");
                                            consulta.append(" isnull(pppem.VALOR_TEXTO, ep.VALOR_TEXTO) as VALOR_TEXTO,isnull(pppem.VALOR_MINIMO, ep.VALOR_MINIMO) as VALOR_MINIMO, ");
                                            consulta.append(" isnull(pppem.VALOR_MAXIMO, ep.VALOR_MAXIMO) as VALOR_MAXIMO,isnull(pppem.RESULTADO_ESPERADO_LOTE, ep.RESULTADO_ESPERADO_LOTE) as RESULTADO_ESPERADO_LOTE");
                                            consulta.append(" ,isnull(pppem.COD_UNIDAD_MEDIDA,ep.COD_UNIDAD_MEDIDA) as COD_UNIDAD_MEDIDA");
                                            consulta.append(" ,isnull(pppem.RESULTADO_ESPERADO_LOTE,ep.RESULTADO_ESPERADO_LOTE) as RESULTADO_ESPERADO_LOTE");
                                        consulta.append(" from ESPECIFICACIONES_PROCESOS ep");
                                            consulta.append(" left outer join PROCESOS_PREPARADO_PRODUCTO_ESPECIFICACIONES_MAQUINARIA pppem on ");
                                            consulta.append(" pppem.COD_ESPECIFICACION_PROCESO=ep.COD_ESPECIFICACION_PROCESO ");
                                            consulta.append(" and pppem.COD_PROCESO_PREPARADO_PRODUCTO_MAQUINARIA=").append(procesosPreparadoProductoMaquinaria.getCodProcesoPreparadProductoMaquinaria());
                                        consulta.append(" where ep.COD_FORMA=0");
                                        consulta.append(" order by case when pppem.COD_PROCESO_PREPARADO_PRODUCTO_ESPECIFICACIONES_MAQUINARIA is not null then 1 else 2 end,");
                                            consulta.append(" ep.NOMBRE_ESPECIFICACIONES_PROCESO");
            LOGGER.debug("consulta cargar especificaciones maquinaria "+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            while (res.next()){
                
                ProcesosPreparadoProductoEspecificacionesMaquinaria  nuevo=new ProcesosPreparadoProductoEspecificacionesMaquinaria();
                nuevo.setChecked(res.getInt("COD_PROCESO_PREPARADO_PRODUCTO_ESPECIFICACIONES_MAQUINARIA")>0);
                nuevo.setCodProcesoPreparadoProductoEspecificacionesMaquinaria(res.getInt("COD_PROCESO_PREPARADO_PRODUCTO_ESPECIFICACIONES_MAQUINARIA"));
                nuevo.getEspecificacionesProcesos().setNombreEspecificacionProceso(res.getString("NOMBRE_ESPECIFICACIONES_PROCESO"));
                nuevo.getEspecificacionesProcesos().setCodEspecificacionProceso(res.getInt("COD_ESPECIFICACION_PROCESO"));
                nuevo.getTiposDescripcion().setCodTipoDescripcion(res.getInt("COD_TIPO_DESCRIPCION"));
                nuevo.setValorExacto(res.getDouble("VALOR_EXACTO"));
                nuevo.setValorMaximo(res.getDouble("VALOR_MAXIMO"));
                nuevo.setValorMinimo(res.getDouble("VALOR_MINIMO"));
                nuevo.setValorTexto(res.getString("VALOR_TEXTO"));
                nuevo.setPorcientoTolerancia(res.getDouble("PORCIENTO_TOLERANCIA"));
                nuevo.getUnidadesMedida().setCodUnidadMedida(res.getString("COD_UNIDAD_MEDIDA"));
                nuevo.setResultadoEsperadoLote(res.getInt("RESULTADO_ESPERADO_LOTE")>0);
                procesosMaquinariaEspecificacionesList.add(nuevo);
            }
            st.close();
        }
        catch (SQLException ex)
        {
            LOGGER.warn(ex);
        } 
        finally 
        {
            this.cerrarConexion(con);
        }
        return procesosMaquinariaEspecificacionesList;
    }
    
    public boolean guardarDetalle(ProcesosPreparadoProductoMaquinaria procesosPreparadoProductoMaquinaria) throws SQLException
    {
        boolean guardado = false;
        LOGGER.debug("---------------------------INICIO REGISTRO ESPECIFICACIONES MAQUINARIA-----------");
        try {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta=new StringBuilder("DELETE PROCESOS_PREPARADO_PRODUCTO_ESPECIFICACIONES_MAQUINARIA");
                                    consulta.append(" WHERE COD_PROCESO_PREPARADO_PRODUCTO_MAQUINARIA=").append(procesosPreparadoProductoMaquinaria.getCodProcesoPreparadProductoMaquinaria());
            LOGGER.debug("consulta delete especificaciones equipo "+consulta.toString());
            PreparedStatement pst=con.prepareStatement(consulta.toString());
            if(pst.executeUpdate()>0)LOGGER.info("se eliminaron especificaciones anteriores");
            
            consulta= new StringBuilder("INSERT INTO PROCESOS_PREPARADO_PRODUCTO_ESPECIFICACIONES_MAQUINARIA(COD_PROCESO_PREPARADO_PRODUCTO_MAQUINARIA, COD_ESPECIFICACION_PROCESO,");
                                consulta.append(" VALOR_EXACTO, VALOR_MINIMO, VALOR_MAXIMO, VALOR_TEXTO, COD_TIPO_DESCRIPCION,COD_UNIDAD_MEDIDA, PORCIENTO_TOLERANCIA, RESULTADO_ESPERADO_LOTE)");
                                consulta.append(" VALUES (");
                                    consulta.append(procesosPreparadoProductoMaquinaria.getCodProcesoPreparadProductoMaquinaria()).append(",");
                                    consulta.append(" ?,?,?, ?, ?, ?, ?,?,?");
                                consulta.append(")");
            LOGGER.debug("consulta insertar especificacion proceso maquinaria "+consulta.toString());
            pst=con.prepareStatement(consulta.toString());
            for(ProcesosPreparadoProductoEspecificacionesMaquinaria bean : procesosPreparadoProductoMaquinaria.getProcesosPreparadoProductoEspecificacionesMaquinariaList())
            {
                pst.setInt(1,bean.getEspecificacionesProcesos().getCodEspecificacionProceso());
                pst.setDouble(2,bean.getValorExacto());
                pst.setDouble(3,bean.getValorMinimo());
                pst.setDouble(4,bean.getValorMaximo());
                pst.setString(5,bean.getValorTexto());
                pst.setInt(6,bean.getTiposDescripcion().getCodTipoDescripcion());
                pst.setInt(7,Integer.valueOf(bean.getUnidadesMedida().getCodUnidadMedida()));
                pst.setDouble(8,bean.getPorcientoTolerancia());
                pst.setInt(9,(bean.isResultadoEsperadoLote()?1:0));
                if(pst.executeUpdate()>0)LOGGER.info("se registro la especificacion "+bean.getEspecificacionesProcesos().getCodEspecificacionProceso());
            }
            con.commit();
            guardado = true;
        }
        catch (SQLException ex) 
        {
            guardado = false;
            LOGGER.warn(ex.getMessage());
            con.rollback();
        }
        catch (Exception ex) 
        {
            guardado = false;
            LOGGER.warn(ex.getMessage());
        }
        finally 
        {
            this.cerrarConexion(con);
        }
        LOGGER.debug("---------------------------FIN REGISTRO ESPECIFICACIONES MAQUINARIA-----------");
        return guardado;
        
    }
    
}
