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
import javax.faces.model.SelectItem;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/**
 *
 * @author DASISAQ
 */
public class DaoComponentesProdVersionMaquinariaProceso extends DaoBean{

    public DaoComponentesProdVersionMaquinariaProceso() {
        this.LOGGER = LogManager.getRootLogger();
    }
    
    public DaoComponentesProdVersionMaquinariaProceso(Logger LOGGER) {
        this.LOGGER = LOGGER;
    }
    
    public List<SelectItem> listarSelectMaquinariaNoUtilizada(ComponentesProdVersionMaquinariaProceso maquinariaProceso){
        List<SelectItem> maquinariaSelectList = new ArrayList<>();
        try {
            
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder(" select m.COD_MAQUINA,m.NOMBRE_MAQUINA+'('+m.CODIGO+')' as nombreMaquina");
                                    consulta.append(" from MAQUINARIAS m ");
                                    consulta.append(" where m.COD_MAQUINA not in ");
                                    consulta.append(" (");
                                            consulta.append(" select cpvm.COD_MAQUINA");
                                            consulta.append(" from COMPONENTES_PROD_VERSION_MAQUINARIA_PROCESO cpvm");
                                            consulta.append(" where cpvm.COD_VERSION=").append(maquinariaProceso.getComponentesProdVersion().getCodVersion());
                                            consulta.append(" and cpvm.COD_PROCESO_ORDEN_MANUFACTURA=").append(maquinariaProceso.getProcesosOrdenManufactura().getCodProcesoOrdenManufactura());
                                    consulta.append(" )");
                                            consulta.append(" and m.COD_AREA_EMPRESA IN (80,81,82,95)");
                                            consulta.append(" and m.COD_TIPO_EQUIPO=2");
                                            consulta.append(" and m.COD_ESTADO_REGISTRO=1");
                                    consulta.append(" order by m.NOMBRE_MAQUINA");
            LOGGER.debug("consulta cargar maquinarias no registradas "+consulta.toString());  
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            while (res.next()) {
                maquinariaSelectList.add(new SelectItem(res.getString("COD_MAQUINA"),res.getString("nombreMaquina")));
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
        return maquinariaSelectList;
    }
    
    public boolean eliminar(int codComponentesProdVersionMaquinariaProceso)throws SQLException{
        LOGGER.debug("----------------------------------INICIO ELIMINAR COMPONENTES PROD VERSION MAQUINARIA PROCESO----------------");
        boolean eliminado = false;
        try{
            
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta =new StringBuilder("delete ESPECIFICACIONES_PROCESOS_PRODUCTO_MAQUINARIA ");
                                    consulta.append(" where COD_COMPPROD_VERSION_MAQUINARIA_PROCESO=").append(codComponentesProdVersionMaquinariaProceso);
            LOGGER.debug("consulta eliminar especificaciones proceso maquinaria "+consulta.toString());
            PreparedStatement pst = con.prepareStatement(consulta.toString());
            if(pst.executeUpdate()>0)LOGGER.info("se eliminaron las especificaciones");
            
            consulta=new StringBuilder("delete COMPONENTES_PROD_VERSION_MAQUINARIA_PROCESO");
                     consulta.append(" where COD_COMPPROD_VERSION_MAQUINARIA_PROCESO=").append(codComponentesProdVersionMaquinariaProceso);
            LOGGER.debug("consulta eliminar maquinaria proceso version "+consulta.toString());
            pst=con.prepareStatement(consulta.toString());
            if(pst.executeUpdate()>0)System.out.println("se eliminaron las maquinarias");
            con.commit();
            eliminado = true;
        }
        catch (SQLException ex) 
        {
            eliminado = false;
            LOGGER.warn(ex.getMessage());
            
        }
        finally 
        {
            con.close();
        }
        LOGGER.debug("----------------------------------TERMINO ELIMINAR COMPONENTES PROD VERSION MAQUINARIA PROCESO----------------");
        return eliminado;
    }
    public boolean guardar(ComponentesProdVersionMaquinariaProceso maquinariaProceso)throws SQLException{
        LOGGER.debug("----------------------------------INICIO GUARDAR COMPONENTES PROD VERSION MAQUINARIA PROCESO----------------");
        boolean guardado = false;
        try {
            
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            
            StringBuilder consulta= new StringBuilder("INSERT INTO COMPONENTES_PROD_VERSION_MAQUINARIA_PROCESO(COD_VERSION,COD_MAQUINA, COD_PROCESO_ORDEN_MANUFACTURA)");
                            consulta.append("VALUES (");
                                consulta.append(maquinariaProceso.getComponentesProdVersion().getCodVersion()).append(",");
                                consulta.append(maquinariaProceso.getMaquinaria().getCodMaquina()).append(",");
                                consulta.append(maquinariaProceso.getProcesosOrdenManufactura().getCodProcesoOrdenManufactura());
                            consulta.append(")");
            LOGGER.debug("consulta guardar maquinaria proceso" + consulta.toString());
            PreparedStatement pst = con.prepareStatement(consulta.toString(),PreparedStatement.RETURN_GENERATED_KEYS);
            if (pst.executeUpdate() > 0) LOGGER.info("Se registro la maquinaria");
            ResultSet res=pst.getGeneratedKeys();
            if(res.next())maquinariaProceso.setCodCompprodVesionMaquinariaProceso(res.getInt(1));
            consulta=new StringBuilder("delete ESPECIFICACIONES_PROCESOS_PRODUCTO_MAQUINARIA");
                     consulta.append(" where COD_COMPPROD_VERSION_MAQUINARIA_PROCESO=").append(maquinariaProceso.getCodCompprodVesionMaquinariaProceso());
            LOGGER.debug("consulta eliminar especificaciones maquinaria "+consulta);
            pst=con.prepareStatement(consulta.toString());
            if(pst.executeUpdate()>0)LOGGER.info("se eliminaron las especificaciones");
            consulta=new StringBuilder("INSERT INTO ESPECIFICACIONES_PROCESOS_PRODUCTO_MAQUINARIA(COD_COMPPROD_VERSION_MAQUINARIA_PROCESO,COD_ESPECIFICACION_PROCESO, VALOR_EXACTO, VALOR_TEXTO,VALOR_MINIMO,VALOR_MAXIMO,COD_TIPO_DESCRIPCION,COD_UNIDAD_MEDIDA,PORCIENTO_TOLERANCIA,RESULTADO_ESPERADO_LOTE,COD_TIPO_ESPECIFICACIONES_PROCESOS_PRODUCTO_MAQUINARIA)");
                     consulta.append("VALUES(")
                             .append(maquinariaProceso.getCodCompprodVesionMaquinariaProceso());
                             consulta.append(",?,?,?,?,?,?,?,?,?,?)");
            LOGGER.debug("consulta registrar especificacion esp: "+consulta.toString());
            pst=con.prepareStatement(consulta.toString());
            for(EspecificacionesProcesosProductoMaquinaria bean : maquinariaProceso.getEspecificacionesProcesosProductoMaquinariaList())
            {
                LOGGER.info("---------------------------------inicio REGISTRANDO ESPECIFICACION "+bean.getEspecificacionesProcesos().getCodEspecificacionProceso()+"--------------------");
                pst.setInt(1,bean.getEspecificacionesProcesos().getCodEspecificacionProceso());LOGGER.info("p1 esp "+bean.getEspecificacionesProcesos().getCodEspecificacionProceso());
                pst.setDouble(2,bean.getValorExacto());LOGGER.info("p2 esp: "+bean.getValorExacto());
                pst.setString(3,bean.getValorTexto());LOGGER.info("p3 esp: "+bean.getValorTexto());
                pst.setDouble(4,bean.getValorMinimo());LOGGER.info("p4 esp: "+bean.getValorMinimo());
                pst.setDouble(5,bean.getValorMaximo());LOGGER.info("p5 esp: "+bean.getValorMaximo());
                pst.setInt(6,bean.getTiposDescripcion().getCodTipoDescripcion());LOGGER.info("p6 esp: "+bean.getTiposDescripcion().getCodTipoDescripcion());
                pst.setString(7,bean.getUnidadesMedida().getCodUnidadMedida());LOGGER.info("p7 esp: "+bean.getUnidadesMedida().getCodUnidadMedida());
                pst.setDouble(8,bean.getPorcientoTolerancia());LOGGER.info("p8 esp: "+bean.getPorcientoTolerancia());
                pst.setBoolean(9,bean.isResultadoEsperadoLote());LOGGER.info("p9 esp: "+bean.isResultadoEsperadoLote());
                pst.setInt(10,bean.getTiposEspecificacionesProcesosProductoMaquinaria().getCodTipoEspecificacionProcesoProductoMaquinaria());LOGGER.info("p10 esp: "+bean.getTiposEspecificacionesProcesosProductoMaquinaria().getCodTipoEspecificacionProcesoProductoMaquinaria());
                if(pst.executeUpdate()>0)LOGGER.info(" se registro la especificacion ");
                LOGGER.info("---------------------------------fin REGISTRANDO ESPECIFICACION "+bean.getEspecificacionesProcesos().getCodEspecificacionProceso()+"--------------------");
                        
            }
            con.commit();
            guardado = true;
        } 
        catch (SQLException ex) 
        {
            guardado = false;
            con.rollback();
            LOGGER.warn(ex);
        } 
        catch (Exception ex)
        {
            guardado = false;
            LOGGER.warn(ex);
        }
        finally 
        {
            this.cerrarConexion(con);
        }
        LOGGER.debug("----------------------------------TERMINO GUARDAR COMPONENTES PROD VERSION MAQUINARIA PROCESO----------------");
        return guardado;
    }
    
    public boolean editar(ComponentesProdVersionMaquinariaProceso maquinariaProceso)throws SQLException{
        boolean editado = false;
        LOGGER.debug("----------------------------------INICIO EDITAR COMPONENTES PROD VERSION MAQUINARIA PROCESO----------------");
        try 
        {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta=new StringBuilder("delete ESPECIFICACIONES_PROCESOS_PRODUCTO_MAQUINARIA");
                                    consulta.append(" where COD_COMPPROD_VERSION_MAQUINARIA_PROCESO=").append(maquinariaProceso.getCodCompprodVesionMaquinariaProceso());
            LOGGER.debug("consulta eliminar especificaciones maquinaria "+consulta.toString());
            PreparedStatement pst=con.prepareStatement(consulta.toString());
            if(pst.executeUpdate()>0)LOGGER.info("se eliminaron las especificaciones");
            consulta=new StringBuilder("INSERT INTO ESPECIFICACIONES_PROCESOS_PRODUCTO_MAQUINARIA(COD_COMPPROD_VERSION_MAQUINARIA_PROCESO,COD_ESPECIFICACION_PROCESO, VALOR_EXACTO, VALOR_TEXTO,VALOR_MINIMO,VALOR_MAXIMO,COD_TIPO_DESCRIPCION,COD_UNIDAD_MEDIDA,PORCIENTO_TOLERANCIA,RESULTADO_ESPERADO_LOTE,COD_TIPO_ESPECIFICACIONES_PROCESOS_PRODUCTO_MAQUINARIA)");
                     consulta.append("VALUES(")
                             .append(maquinariaProceso.getCodCompprodVesionMaquinariaProceso()).append(",")
                             .append(" ?,?,?,?,?,?,?,?,?,?)");
            LOGGER.debug("consulta registrar especificaciones proceso maquinaria esp: "+consulta.toString());
            pst=con.prepareStatement(consulta.toString());
            for(EspecificacionesProcesosProductoMaquinaria bean : maquinariaProceso.getEspecificacionesProcesosProductoMaquinariaList())
            {
                LOGGER.info("---------------------------------inicio REGISTRANDO ESPECIFICACION "+bean.getEspecificacionesProcesos().getCodEspecificacionProceso()+"--------------------");
                pst.setInt(1,bean.getEspecificacionesProcesos().getCodEspecificacionProceso());LOGGER.info("p1 esp "+bean.getEspecificacionesProcesos().getCodEspecificacionProceso());
                pst.setDouble(2,bean.getValorExacto());LOGGER.info("p2 esp: "+bean.getValorExacto());
                pst.setString(3,bean.getValorTexto());LOGGER.info("p3 esp: "+bean.getValorTexto());
                pst.setDouble(4,bean.getValorMinimo());LOGGER.info("p4 esp: "+bean.getValorMinimo());
                pst.setDouble(5,bean.getValorMaximo());LOGGER.info("p5 esp: "+bean.getValorMaximo());
                pst.setInt(6,bean.getTiposDescripcion().getCodTipoDescripcion());LOGGER.info("p6 esp: "+bean.getTiposDescripcion().getCodTipoDescripcion());
                pst.setString(7,bean.getUnidadesMedida().getCodUnidadMedida());LOGGER.info("p7 esp: "+bean.getUnidadesMedida().getCodUnidadMedida());
                pst.setDouble(8,bean.getPorcientoTolerancia());LOGGER.info("p8 esp: "+bean.getPorcientoTolerancia());
                pst.setBoolean(9,bean.isResultadoEsperadoLote());LOGGER.info("p9 esp: "+bean.isResultadoEsperadoLote());
                pst.setInt(10,bean.getTiposEspecificacionesProcesosProductoMaquinaria().getCodTipoEspecificacionProcesoProductoMaquinaria());LOGGER.info("p10 esp: "+bean.getTiposEspecificacionesProcesosProductoMaquinaria().getCodTipoEspecificacionProcesoProductoMaquinaria());
                if(pst.executeUpdate()>0)LOGGER.info(" se registro la especificacion ");
                LOGGER.info("---------------------------------fin REGISTRANDO ESPECIFICACION "+bean.getEspecificacionesProcesos().getCodEspecificacionProceso()+"--------------------");
                
            }
            con.commit();
            editado = true;
            
        } 
        catch (SQLException ex) 
        {
            editado = false;
            con.rollback();
            LOGGER.warn(ex.getMessage());
        } 
        catch (Exception ex)
        {
            editado = false;
            LOGGER.warn(ex.getMessage());
        }
        finally 
        {
            this.cerrarConexion(con);
        }
        LOGGER.debug("----------------------------------TERMINO EDITAR COMPONENTES PROD VERSION MAQUINARIA PROCESO----------------");
        return editado;
    }
    
    
}
