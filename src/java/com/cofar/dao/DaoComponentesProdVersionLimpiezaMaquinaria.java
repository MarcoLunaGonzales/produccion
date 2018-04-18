/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.dao;

import com.cofar.bean.ComponentesProdVersion;
import com.cofar.bean.ComponentesProdVersionLimpiezaMaquinaria;
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
public class DaoComponentesProdVersionLimpiezaMaquinaria extends DaoBean{

    public DaoComponentesProdVersionLimpiezaMaquinaria() {
        this.LOGGER = LogManager.getRootLogger();
    }
    public DaoComponentesProdVersionLimpiezaMaquinaria(Logger LOGGER) {
        this.LOGGER = LOGGER;
    }
    
    public List<ComponentesProdVersionLimpiezaMaquinaria> listar(ComponentesProdVersionLimpiezaMaquinaria limpiezaMaquinaria){
        List<ComponentesProdVersionLimpiezaMaquinaria> limpiezaMaquinariaList = new ArrayList<>();
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select *");
                                    consulta.append(" from VISTA_LIMPIEZA_MAQUINARIA vlm")
                                            .append(" where vlm.COD_VERSION=").append(limpiezaMaquinaria.getComponentesProdVersion().getCodVersion());
                                                consulta.append(" and vlm.COD_AREA_EMPRESA=").append(limpiezaMaquinaria.getAreasEmpresa().getCodAreaEmpresa());
                                                consulta.append(" and isnull(vlm.COD_COMPONENTES_PROD_VERSION_LIMPIEZA_SECCION,0) = 0");
                                    consulta.append(" order by vlm.NOMBRE_MAQUINA");
            LOGGER.debug("consulta cargar maquinarias limpieza "+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            while (res.next()) 
            {
                ComponentesProdVersionLimpiezaMaquinaria nuevo=new ComponentesProdVersionLimpiezaMaquinaria();
                nuevo.setCodComponentesProdVersionLimpiezaMaquinaria(res.getInt("COD_COMPONENTES_PROD_VERSION_LIMPIEZA_MAQUINARIA"));
                nuevo.getMaquinaria().setNombreMaquina(res.getString("NOMBRE_MAQUINA"));
                nuevo.getMaquinaria().setCodigo(res.getString("CODIGO"));
                nuevo.getMaquinaria().getTiposEquiposMaquinaria().setNombreTipoEquipo(res.getString("NOMBRE_TIPO_EQUIPO"));
                limpiezaMaquinariaList.add(nuevo);
                
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
        return limpiezaMaquinariaList;
    }
    
    public List<ComponentesProdVersionLimpiezaMaquinaria> listarAgregarUtensilios(ComponentesProdVersion componentesProdVersion){
        List<ComponentesProdVersionLimpiezaMaquinaria> limpiezaMaquinariaList = new ArrayList<>();
        try 
        {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select m.COD_MAQUINA,m.NOMBRE_MAQUINA,m.CODIGO,tem.NOMBRE_TIPO_EQUIPO");
                                        consulta.append(" from MAQUINARIAS m ");
                                                consulta.append(" inner join TIPOS_EQUIPOS_MAQUINARIA tem on tem.COD_TIPO_EQUIPO=m.COD_TIPO_EQUIPO");
                                        consulta.append(" where m.COD_TIPO_EQUIPO in (8)");
                                                consulta.append("and m.COD_MAQUINA not in");
                                                consulta.append("(");
                                                        consulta.append(" select c.COD_MAQUINA from COMPONENTES_PROD_VERSION_LIMPIEZA_MAQUINARIA c where c.COD_AREA_EMPRESA=97 and c.COD_VERSION=").append(componentesProdVersion.getCodVersion());
                                                consulta.append(" )");
                                                consulta.append(" and m.COD_ESTADO_REGISTRO=1");
                                        consulta.append(" order by m.NOMBRE_MAQUINA");
            LOGGER.debug("consulta agregar maquinarias "+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            while (res.next()) 
            {
                ComponentesProdVersionLimpiezaMaquinaria nuevo=new ComponentesProdVersionLimpiezaMaquinaria();
                nuevo.getMaquinaria().setCodMaquina(res.getString("COD_MAQUINA"));
                nuevo.getMaquinaria().setNombreMaquina(res.getString("NOMBRE_MAQUINA"));
                nuevo.getMaquinaria().setCodigo(res.getString("CODIGO"));
                nuevo.getMaquinaria().getTiposEquiposMaquinaria().setNombreTipoEquipo(res.getString("NOMBRE_TIPO_EQUIPO"));
                limpiezaMaquinariaList.add(nuevo);
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
        return limpiezaMaquinariaList;
    }
    
    public List<ComponentesProdVersionLimpiezaMaquinaria> listarAgregar(ComponentesProdVersion componentesProdVersion){
        List<ComponentesProdVersionLimpiezaMaquinaria> limpiezaMaquinariaList = new ArrayList<>();
        try 
        {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select m.COD_MAQUINA,m.NOMBRE_MAQUINA,m.CODIGO,tem.NOMBRE_TIPO_EQUIPO");
                                        consulta.append(" from MAQUINARIAS m ");
                                                consulta.append(" inner join TIPOS_EQUIPOS_MAQUINARIA tem on tem.COD_TIPO_EQUIPO=m.COD_TIPO_EQUIPO");
                                        consulta.append(" where m.COD_TIPO_EQUIPO in (2,8)");
                                                consulta.append("and m.COD_MAQUINA not in");
                                                consulta.append("(");
                                                        consulta.append(" select c.COD_MAQUINA from COMPONENTES_PROD_VERSION_LIMPIEZA_MAQUINARIA c where c.COD_AREA_EMPRESA=96 and c.COD_VERSION=").append(componentesProdVersion.getCodVersion());
                                                consulta.append(" )");
                                                consulta.append(" and m.COD_ESTADO_REGISTRO=1");
                                        consulta.append(" order by m.NOMBRE_MAQUINA");
            LOGGER.debug("consulta agregar maquinarias "+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            while (res.next()) 
            {
                ComponentesProdVersionLimpiezaMaquinaria nuevo=new ComponentesProdVersionLimpiezaMaquinaria();
                nuevo.getMaquinaria().setCodMaquina(res.getString("COD_MAQUINA"));
                nuevo.getMaquinaria().setNombreMaquina(res.getString("NOMBRE_MAQUINA"));
                nuevo.getMaquinaria().setCodigo(res.getString("CODIGO"));
                nuevo.getMaquinaria().getTiposEquiposMaquinaria().setNombreTipoEquipo(res.getString("NOMBRE_TIPO_EQUIPO"));
                limpiezaMaquinariaList.add(nuevo);
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
        return limpiezaMaquinariaList;
    }
    public List<ComponentesProdVersionLimpiezaMaquinaria> listarAgregarParaSeccion(){
        List<ComponentesProdVersionLimpiezaMaquinaria> limpiezaMaquinariaList = new ArrayList<>();
        try 
        {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select m.COD_MAQUINA,m.NOMBRE_MAQUINA,m.CODIGO,tem.NOMBRE_TIPO_EQUIPO");
                                                consulta.append(" ,m.OBS_MAQUINA");
                                        consulta.append(" from MAQUINARIAS m");
                                                consulta.append(" inner join TIPOS_EQUIPOS_MAQUINARIA tem on tem.COD_TIPO_EQUIPO =m.COD_TIPO_EQUIPO");
                                        consulta.append(" where m.COD_TIPO_EQUIPO in (2,4) ");
                                                consulta.append(" and m.COD_ESTADO_REGISTRO = 1");
                                        consulta.append(" order by m.NOMBRE_MAQUINA");
            LOGGER.debug("consulta agregar maquinarias "+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            while (res.next()) 
            {
                ComponentesProdVersionLimpiezaMaquinaria nuevo=new ComponentesProdVersionLimpiezaMaquinaria();
                nuevo.getMaquinaria().setCodMaquina(res.getString("COD_MAQUINA"));
                nuevo.getMaquinaria().setNombreMaquina(res.getString("NOMBRE_MAQUINA"));
                nuevo.getMaquinaria().setCodigo(res.getString("CODIGO"));
                nuevo.getMaquinaria().getTiposEquiposMaquinaria().setNombreTipoEquipo(res.getString("NOMBRE_TIPO_EQUIPO"));
                limpiezaMaquinariaList.add(nuevo);
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
        return limpiezaMaquinariaList;
    }
    
    public boolean guardarLista(List<ComponentesProdVersionLimpiezaMaquinaria> limpiezaMaquinariaList,ComponentesProdVersion componentesProdVersion,int codAreaEmpresa) throws SQLException{
        boolean guardado = false;
        LOGGER.debug("-----------------------------------INICIO REGISTRAR LIMPIEZA MAQUINARIA--------------------------");
        try 
        {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta = new StringBuilder("INSERT INTO COMPONENTES_PROD_VERSION_LIMPIEZA_MAQUINARIA(COD_VERSION,COD_MAQUINA,COD_AREA_EMPRESA,COD_COMPONENTES_PROD_VERSION_LIMPIEZA_SECCION)");
                                    consulta.append(" VALUES(").append(componentesProdVersion.getCodVersion()).append(",?,").append(codAreaEmpresa).append(",0)");
            LOGGER.debug("consulta registrar limpieza maquinaria " + consulta.toString());
            PreparedStatement pst = con.prepareStatement(consulta.toString(), PreparedStatement.RETURN_GENERATED_KEYS);
            for(ComponentesProdVersionLimpiezaMaquinaria bean : limpiezaMaquinariaList)
            {
                pst.setString(1, bean.getMaquinaria().getCodMaquina());
                if(pst.executeUpdate()>0)LOGGER.info("se registro la maquinaria "+bean.getMaquinaria().getCodMaquina());
            }
            con.commit();
            guardado = true;
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
        LOGGER.debug("-----------------------------------TERMINO REGISTRAR LIMPIEZA MAQUINARIA--------------------------");
        return guardado;
    }
    public boolean eliminar(int codComponentesProdVersionLimpiezaMaquinaria)throws SQLException{
        boolean eliminado = false;
        LOGGER.debug("----------------------------------INICIO ELIMINAR LIMPIEZA MAQUINARIA-----------------------------------");
        try 
        {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta = new StringBuilder("delete COMPONENTES_PROD_VERSION_LIMPIEZA_MAQUINARIA");
                                     consulta.append(" where COD_COMPONENTES_PROD_VERSION_LIMPIEZA_MAQUINARIA=").append(codComponentesProdVersionLimpiezaMaquinaria);
            LOGGER.debug("consulta eliminar maquinaria limpieza" + consulta.toString());
            PreparedStatement pst = con.prepareStatement(consulta.toString(), PreparedStatement.RETURN_GENERATED_KEYS);
            if (pst.executeUpdate() > 0) LOGGER.info("Se elimino la maquinaria de limpieza ");
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
        LOGGER.debug("----------------------------------TERMINO ELIMINAR LIMPIEZA MAQUINARIA-----------------------------------");
        return eliminado;
    }
    
}
