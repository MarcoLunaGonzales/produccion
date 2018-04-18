/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.dao;

import com.cofar.bean.ComponentesProdVersion;
import com.cofar.bean.ComponentesProdVersionLimpiezaMaquinaria;
import com.cofar.bean.ComponentesProdVersionLimpiezaSeccion;
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
public class DaoComponentesProdVersionLimpiezaSeccion extends DaoBean{

    public DaoComponentesProdVersionLimpiezaSeccion() {
        this.LOGGER = LogManager.getRootLogger();
    }
    public DaoComponentesProdVersionLimpiezaSeccion(Logger LOGGER) {
        this.LOGGER = LOGGER;
    }
    
    public List<ComponentesProdVersionLimpiezaSeccion> listarAgregar(ComponentesProdVersion componentesProdVersion){
        List<ComponentesProdVersionLimpiezaSeccion> listaAgregar = new ArrayList<>();
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder(" select som.COD_SECCION_ORDEN_MANUFACTURA,som.NOMBRE_SECCION_ORDEN_MANUFACTURA,som.DESCRIPCION_SECCION_ORDEN_MANUFACTURA");
                                        consulta.append(" from SECCIONES_ORDEN_MANUFACTURA som");
                                        consulta.append(" where som.COD_SECCION_ORDEN_MANUFACTURA not in");
                                            consulta.append(" ( ");
                                                    consulta.append(" select cpvl.COD_SECCION_ORDEN_MANUFACTURA");
                                                    consulta.append(" from COMPONENTES_PROD_VERSION_LIMPIEZA_SECCION cpvl");
                                                    consulta.append(" where cpvl.COD_VERSION=").append(componentesProdVersion.getCodVersion());
                                                            consulta.append(" and cpvl.COD_AREA_EMPRESA=96");
                                            consulta.append(")");
                                            consulta.append(" and som.COD_ESTADO_REGISTRO=1");
                                        consulta.append(" order by som.NOMBRE_SECCION_ORDEN_MANUFACTURA");
            LOGGER.debug("consulta cargar secciones limpieza agregar "+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            while (res.next()) 
            {
                ComponentesProdVersionLimpiezaSeccion nuevo=new ComponentesProdVersionLimpiezaSeccion();
                nuevo.getSeccionesOrdenManufactura().setCodSeccionOrdenManufactura(res.getInt("COD_SECCION_ORDEN_MANUFACTURA"));
                nuevo.getSeccionesOrdenManufactura().setNombreSeccionOrdenManufactura(res.getString("NOMBRE_SECCION_ORDEN_MANUFACTURA"));
                nuevo.getSeccionesOrdenManufactura().setDescripcionSeccionOrdenManufactura(res.getString("DESCRIPCION_SECCION_ORDEN_MANUFACTURA"));
                listaAgregar.add(nuevo);
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
        return listaAgregar;
    }
    
    public List<ComponentesProdVersionLimpiezaSeccion> listar(ComponentesProdVersionLimpiezaSeccion limpiezaSeccion){
        List<ComponentesProdVersionLimpiezaSeccion> limpiezaSeccionList = new ArrayList<>();
        try 
        {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder(" select * ")
                                                .append(" from VISTA_LIMPIEZA_SECCION vls ")
                                                .append(" where vls.COD_VERSION=").append(limpiezaSeccion.getComponentesProdVersion().getCodVersion())
                                                        .append(" and vls.COD_AREA_EMPRESA = '").append(limpiezaSeccion.getAreasEmpresa().getCodAreaEmpresa()).append("'")
                                                .append(" order by vls.NOMBRE_SECCION_ORDEN_MANUFACTURA");
            LOGGER.debug("consulta cargar limpieza seccciones "+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            ComponentesProdVersionLimpiezaSeccion nuevo=new ComponentesProdVersionLimpiezaSeccion();
            while (res.next()) 
            {
                    if(nuevo.getCodComponentesProdVersionLimpiezaSeccion()!=res.getInt("COD_COMPONENTES_PROD_VERSION_LIMPIEZA_SECCION"))
                    {
                            if(nuevo.getCodComponentesProdVersionLimpiezaSeccion()>0)
                            {
                                limpiezaSeccionList.add(nuevo);
                            }
                            nuevo=new ComponentesProdVersionLimpiezaSeccion();
                            nuevo.setCodComponentesProdVersionLimpiezaSeccion(res.getInt("COD_COMPONENTES_PROD_VERSION_LIMPIEZA_SECCION"));
                            nuevo.getSeccionesOrdenManufactura().setDescripcionSeccionOrdenManufactura(res.getString("DESCRIPCION_SECCION_ORDEN_MANUFACTURA"));
                            nuevo.getSeccionesOrdenManufactura().setNombreSeccionOrdenManufactura(res.getString("NOMBRE_SECCION_ORDEN_MANUFACTURA"));
                            nuevo.getSeccionesOrdenManufactura().setCodSeccionOrdenManufactura(res.getInt("COD_SECCION_ORDEN_MANUFACTURA"));
                            nuevo.setComponentesProdVersionLimpiezaMaquinariaList(new ArrayList<ComponentesProdVersionLimpiezaMaquinaria>());   
                    }
                    ComponentesProdVersionLimpiezaMaquinaria bean=new ComponentesProdVersionLimpiezaMaquinaria();
                    bean.getMaquinaria().setCodMaquina(res.getString("COD_MAQUINA"));
                    bean.getMaquinaria().setNombreMaquina(res.getString("NOMBRE_MAQUINA"));
                    bean.getMaquinaria().setCodigo(res.getString("CODIGO"));
                    bean.getMaquinaria().getTiposEquiposMaquinaria().setNombreTipoEquipo(res.getString("NOMBRE_TIPO_EQUIPO"));
                    nuevo.getComponentesProdVersionLimpiezaMaquinariaList().add(bean);
            }
            if(nuevo.getCodComponentesProdVersionLimpiezaSeccion()>0)
            {
                limpiezaSeccionList.add(nuevo);
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
        return limpiezaSeccionList;
    }
    public boolean eliminar(int codComponentesProdVersionLimpiezaSeccion)throws SQLException{
        boolean eliminado = false;
        LOGGER.debug("--------------------------------------INICIO ELIMINAR LIMPIEZA SECCION-------------------------");
        try{
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta = new StringBuilder("delete COMPONENTES_PROD_VERSION_LIMPIEZA_MAQUINARIA ")
                                                .append(" where COD_COMPONENTES_PROD_VERSION_LIMPIEZA_SECCION =").append(codComponentesProdVersionLimpiezaSeccion);
            LOGGER.debug("consulta eliminar limpieza maquinaria relacionada: "+consulta.toString());
            PreparedStatement pst = con.prepareStatement(consulta.toString());
            if(pst.executeUpdate() > 0)LOGGER.info("se eliminaron las maquinarias relacionadas");
            
            consulta = new StringBuilder("delete COMPONENTES_PROD_VERSION_LIMPIEZA_SECCION");
                                      consulta.append(" where COD_COMPONENTES_PROD_VERSION_LIMPIEZA_SECCION=").append(codComponentesProdVersionLimpiezaSeccion);
            LOGGER.debug("consulta eliminar limpieza seccion " + consulta.toString());
            pst = con.prepareStatement(consulta.toString());
            if (pst.executeUpdate() > 0) LOGGER.info("Se elimino la limpieza de la seccion");
            con.commit();
            eliminado = true;
        }
        catch (SQLException ex) 
        {
            eliminado = false;
            con.rollback();
            LOGGER.warn(ex.getMessage());
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
        LOGGER.debug("--------------------------------------TERMINO ELIMINAR LIMPIEZA SECCION-------------------------");
        return eliminado;
    }
    public boolean guardar(ComponentesProdVersionLimpiezaSeccion componentesProdVersionLimpiezaSeccion)throws SQLException{
        LOGGER.debug("---------------------------------------INICIO REGISTRO LIMPIEZA SECCION-------------------------------");
        boolean guardado = false;
        try{
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta = new StringBuilder("INSERT INTO COMPONENTES_PROD_VERSION_LIMPIEZA_SECCION(COD_VERSION,COD_SECCION_ORDEN_MANUFACTURA,COD_AREA_EMPRESA)");
                                        consulta.append(" VALUES (");
                                                    consulta.append(componentesProdVersionLimpiezaSeccion.getComponentesProdVersion().getCodVersion()).append(",");
                                                    consulta.append(componentesProdVersionLimpiezaSeccion.getSeccionesOrdenManufactura().getCodSeccionOrdenManufactura()).append(",");
                                                    consulta.append(componentesProdVersionLimpiezaSeccion.getAreasEmpresa().getCodAreaEmpresa());//area de pesaje
                                        consulta.append(")");
            LOGGER.debug("consulta registrar limpieza seccion : " + consulta.toString());
            PreparedStatement pst = con.prepareStatement(consulta.toString(), PreparedStatement.RETURN_GENERATED_KEYS);
            if (pst.executeUpdate() > 0) LOGGER.info("se registro la instalacion");
            ResultSet res=pst.getGeneratedKeys();
            if(res.next())componentesProdVersionLimpiezaSeccion.setCodComponentesProdVersionLimpiezaSeccion(res.getInt(1));
            consulta = new StringBuilder("INSERT INTO COMPONENTES_PROD_VERSION_LIMPIEZA_MAQUINARIA(COD_VERSION,COD_MAQUINA,COD_COMPONENTES_PROD_VERSION_LIMPIEZA_SECCION,COD_AREA_EMPRESA)");
                        consulta.append(" VALUES(");
                                consulta.append(componentesProdVersionLimpiezaSeccion.getComponentesProdVersion().getCodVersion()).append(",");
                                consulta.append(" ?,");
                                consulta.append(componentesProdVersionLimpiezaSeccion.getCodComponentesProdVersionLimpiezaSeccion()).append(",");
                                consulta.append(componentesProdVersionLimpiezaSeccion.getAreasEmpresa().getCodAreaEmpresa());
                        consulta.append(")");
            LOGGER.debug("consulta registrar maquinaria seccion limpieza"+consulta.toString());
            pst=con.prepareStatement(consulta.toString());
            for(ComponentesProdVersionLimpiezaMaquinaria bean : componentesProdVersionLimpiezaSeccion.getComponentesProdVersionLimpiezaMaquinariaList())
            {
                pst.setString(1,bean.getMaquinaria().getCodMaquina());LOGGER.info("p1:"+bean.getMaquinaria().getCodMaquina());
                if(pst.executeUpdate()>0)LOGGER.info("se registro la maquinaria");
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
        } finally {
            this.cerrarConexion(con);
        }
        LOGGER.debug("---------------------------------------TERMINO REGISTRO LIMPIEZA SECCION-------------------------------");
        return guardado;
    }
    
    public boolean guardarLista(List<ComponentesProdVersionLimpiezaSeccion> limpiezaList,ComponentesProdVersion componentesProdVersion)throws SQLException{
        LOGGER.debug("-------------------------------------INICIO REGISTRO LIMPIEZA SECCCION---------------------------------");
        boolean guardado = false;
        try{
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta = new StringBuilder("INSERT INTO COMPONENTES_PROD_VERSION_LIMPIEZA_SECCION(COD_VERSION,COD_SECCION_ORDEN_MANUFACTURA,COD_AREA_EMPRESA)");
                                        consulta.append(" VALUES (");
                                                    consulta.append(componentesProdVersion.getCodVersion());
                                                    consulta.append(",?");//secciones orden manufactura
                                                    consulta.append(",96");//area de produccion
                                        consulta.append(")");
            LOGGER.debug("consulta registrar limpieza secciones" + consulta.toString());
            PreparedStatement pst = con.prepareStatement(consulta.toString());
            for(ComponentesProdVersionLimpiezaSeccion bean : limpiezaList)
            {
                    pst.setInt(1, bean.getSeccionesOrdenManufactura().getCodSeccionOrdenManufactura());
                    if(pst.executeUpdate()>0)LOGGER.info("se registrao la limpieza seccion "+bean.getSeccionesOrdenManufactura().getCodSeccionOrdenManufactura());
            }
            con.commit();
            guardado= true;
        }
        catch (SQLException ex) 
        {
            guardado = false;
            con.rollback();
            LOGGER.warn(ex.getMessage());
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
        LOGGER.debug("-------------------------------------TERMINO REGISTRO LIMPIEZA SECCCION---------------------------------");
        return guardado;
    }
    
    
}
