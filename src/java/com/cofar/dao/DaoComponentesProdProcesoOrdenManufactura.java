/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.dao;

import com.cofar.bean.ComponentesProdProcesoOrdenManufactura;
import com.cofar.bean.ComponentesProdVersion;
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
public class DaoComponentesProdProcesoOrdenManufactura extends DaoBean{
    
    public DaoComponentesProdProcesoOrdenManufactura() {
        LOGGER = LogManager.getRootLogger();
    }
    public DaoComponentesProdProcesoOrdenManufactura(Logger LOGGER) {
        this.LOGGER = LOGGER;
    }
    public boolean guardarLista(List<ComponentesProdProcesoOrdenManufactura> componentesProdProcesoOrdenManufacturaList,int codVersionProducto)throws SQLException{
        
        boolean guardado = false;
        LOGGER.debug("---------------------------INICIO REGISTRO PROCESOS ORDEN MANUFACTURA PRODUCTO-----------");
        try {
            
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta = new StringBuilder("DELETE COMPONENTES_PROD_PROCESO_ORDEN_MANUFACTURA");
                                    consulta.append(" WHERE COD_VERSION=").append(codVersionProducto);
            LOGGER.debug("consulta eliminar anteriores registros" + consulta.toString());
            PreparedStatement pst = con.prepareStatement(consulta.toString());
            if (pst.executeUpdate() > 0) LOGGER.info("Se eliminaron registros anteriores");
            
            consulta = new StringBuilder("INSERT INTO COMPONENTES_PROD_PROCESO_ORDEN_MANUFACTURA(COD_VERSION,COD_FORMA_FARMACEUTICA_PROCESO_ORDEN_MANUFACTURA, ORDEN)");
                        consulta.append("VALUES (");
                            consulta.append(codVersionProducto).append(",?,?");
                        consulta.append(")");
            LOGGER.debug("consulta registrar componentes prod procesos OM : "+consulta.toString());
            pst=con.prepareStatement(consulta.toString());
            int orden = 0;
            for(ComponentesProdProcesoOrdenManufactura bean : componentesProdProcesoOrdenManufacturaList)
            {
                orden ++;
                pst.setInt(1,bean.getFormasFarmaceuticasProcesoOrdenManufactura().getCodFormaFarmaceuticaProcesoOrdenManufactura());LOGGER.info("p1 : "+bean.getFormasFarmaceuticasProcesoOrdenManufactura().getCodFormaFarmaceuticaProcesoOrdenManufactura());
                pst.setInt(2,orden);LOGGER.info("p2 : "+orden);
                if(pst.executeUpdate()>0)LOGGER.info("se registro el paso ");
            }

            con.commit();
            guardado = true;
        } catch (SQLException ex) {
            guardado = false;
            con.rollback();
            LOGGER.warn(ex.getMessage());
        } catch (Exception ex) {
            guardado = false;
            LOGGER.warn(ex.getMessage());
        } finally {
            this.cerrarConexion(con);
        }
        LOGGER.debug("---------------------------FIN REGISTRO PROCESOS ORDEN MANUFACTURA PRODUCTO-----------");
        return guardado;
    }
    
    public List<ComponentesProdProcesoOrdenManufactura> listarNoUtilizado(ComponentesProdVersion componentesProdVersion){
        
        List<ComponentesProdProcesoOrdenManufactura> componentesProdProcesoOrdenManufacturaList = new ArrayList<>();
        try{
            con = Util.openConnection(con);
            StringBuilder consulta=new StringBuilder("select pom.COD_PROCESO_ORDEN_MANUFACTURA,ffpom.COD_FORMA_FARMACEUTICA_PROCESO_ORDEN_MANUFACTURA,")
                                                    .append(" pom.NOMBRE_PROCESO_ORDEN_MANUFACTURA,ffpom.APLICA_ESPECIFICACIONES_MAQUINARIA,")
                                                    .append(" ffpom.APLICA_ESPECIFICACIONES_PROCESO,ffpom.APLICA_FLUJOGRAMA,ffpom.ORDEN")
                                            .append(" from FORMAS_FARMACEUTICAS_PROCESO_ORDEN_MANUFACTURA ffpom")
                                                    .append(" inner join PROCESOS_ORDEN_MANUFACTURA pom on pom.COD_PROCESO_ORDEN_MANUFACTURA = ffpom.COD_PROCESO_ORDEN_MANUFACTURA")
                                                    .append(" left outer join COMPONENTES_PROD_PROCESO_ORDEN_MANUFACTURA cppom on cppom.COD_FORMA_FARMACEUTICA_PROCESO_ORDEN_MANUFACTURA =ffpom.COD_FORMA_FARMACEUTICA_PROCESO_ORDEN_MANUFACTURA")
                                                    .append(" and cppom.COD_VERSION = ").append(componentesProdVersion.getCodVersion())
                                            .append(" where ffpom.COD_FORMA = ").append(componentesProdVersion.getForma().getCodForma())
                                            .append(" and cppom.COD_VERSION is null")
                                            .append(" order by ffpom.ORDEN");
            LOGGER.debug("consulta procesos no utilizados : "+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            while (res.next()) {
                ComponentesProdProcesoOrdenManufactura bean = new ComponentesProdProcesoOrdenManufactura();
                bean.getFormasFarmaceuticasProcesoOrdenManufactura().getProcesosOrdenManufactura().setCodProcesoOrdenManufactura(res.getInt("COD_PROCESO_ORDEN_MANUFACTURA"));
                bean.getFormasFarmaceuticasProcesoOrdenManufactura().getProcesosOrdenManufactura().setNombreProcesoOrdenManufactura(res.getString("NOMBRE_PROCESO_ORDEN_MANUFACTURA"));
                bean.getFormasFarmaceuticasProcesoOrdenManufactura().setCodFormaFarmaceuticaProcesoOrdenManufactura(res.getInt("COD_FORMA_FARMACEUTICA_PROCESO_ORDEN_MANUFACTURA"));
                bean.getFormasFarmaceuticasProcesoOrdenManufactura().setAplicaEspecificacionesMaquinaria(res.getInt("APLICA_ESPECIFICACIONES_MAQUINARIA") > 0);
                bean.getFormasFarmaceuticasProcesoOrdenManufactura().setAplicaEspecificacionesProceso(res.getInt("APLICA_ESPECIFICACIONES_PROCESO") > 0);
                bean.getFormasFarmaceuticasProcesoOrdenManufactura().setAplicaFlujograma(res.getInt("APLICA_FLUJOGRAMA") > 0);
                componentesProdProcesoOrdenManufacturaList.add(bean);
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
        return componentesProdProcesoOrdenManufacturaList;
    }
    
    public List<ComponentesProdProcesoOrdenManufactura> listar(ComponentesProdVersion componentesProdVersion)
    {
        List<ComponentesProdProcesoOrdenManufactura> componentesProdProcesoOrdenManufacturaList = new ArrayList<>();
        try{
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select pom.COD_PROCESO_ORDEN_MANUFACTURA,fpom.COD_FORMA_FARMACEUTICA_PROCESO_ORDEN_MANUFACTURA,")
                                                        .append(" pom.NOMBRE_PROCESO_ORDEN_MANUFACTURA,cpom.ORDEN,fpom.APLICA_ESPECIFICACIONES_MAQUINARIA,")
                                                        .append(" fpom.APLICA_ESPECIFICACIONES_PROCESO,fpom.APLICA_FLUJOGRAMA,fpom.ORDEN as ordenFF")
                                                .append(" from COMPONENTES_PROD_PROCESO_ORDEN_MANUFACTURA cpom")
                                                        .append(" inner join FORMAS_FARMACEUTICAS_PROCESO_ORDEN_MANUFACTURA fpom on fpom.COD_FORMA_FARMACEUTICA_PROCESO_ORDEN_MANUFACTURA = cpom.COD_FORMA_FARMACEUTICA_PROCESO_ORDEN_MANUFACTURA")
                                                        .append(" inner join PROCESOS_ORDEN_MANUFACTURA pom on pom.COD_PROCESO_ORDEN_MANUFACTURA = fpom.COD_PROCESO_ORDEN_MANUFACTURA")
                                                .append(" where cpom.COD_VERSION =").append(componentesProdVersion.getCodVersion())
                                                .append(" order by cpom.ORDEN");
            LOGGER.debug("consulta procesos de preparado configurados version "+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            while (res.next()) {
                ComponentesProdProcesoOrdenManufactura bean = new ComponentesProdProcesoOrdenManufactura();
                bean.getFormasFarmaceuticasProcesoOrdenManufactura().getProcesosOrdenManufactura().setCodProcesoOrdenManufactura(res.getInt("COD_PROCESO_ORDEN_MANUFACTURA"));
                bean.getFormasFarmaceuticasProcesoOrdenManufactura().getProcesosOrdenManufactura().setNombreProcesoOrdenManufactura(res.getString("NOMBRE_PROCESO_ORDEN_MANUFACTURA"));
                bean.getFormasFarmaceuticasProcesoOrdenManufactura().setCodFormaFarmaceuticaProcesoOrdenManufactura(res.getInt("COD_FORMA_FARMACEUTICA_PROCESO_ORDEN_MANUFACTURA"));
                bean.getFormasFarmaceuticasProcesoOrdenManufactura().setAplicaEspecificacionesMaquinaria(res.getInt("APLICA_ESPECIFICACIONES_MAQUINARIA") > 0);
                bean.getFormasFarmaceuticasProcesoOrdenManufactura().setAplicaEspecificacionesProceso(res.getInt("APLICA_ESPECIFICACIONES_PROCESO") > 0);
                bean.getFormasFarmaceuticasProcesoOrdenManufactura().setAplicaFlujograma(res.getInt("APLICA_FLUJOGRAMA") > 0);
                bean.setOrden(res.getInt("ORDEN"));
                componentesProdProcesoOrdenManufacturaList.add(bean);
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
        return componentesProdProcesoOrdenManufacturaList;
    }
    
}
