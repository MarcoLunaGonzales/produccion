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
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import javax.faces.model.SelectItem;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;


public class DaoComponentesPresProdVersion extends DaoBean{

    public DaoComponentesPresProdVersion() {
        LOGGER=LogManager.getRootLogger();
    }
    public DaoComponentesPresProdVersion(Logger LOGGER) {
        this.LOGGER = LOGGER;
    }
    
    public List<SelectItem> listarPresentacionesProductoSelectList()
    {
        List<SelectItem> presentacionesProductoSelectList=new ArrayList<SelectItem>();
        try 
        {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select pp.cod_presentacion,pp.NOMBRE_PRODUCTO_PRESENTACION");
                                        consulta.append(" from PRESENTACIONES_PRODUCTO pp");
                                        consulta.append(" where pp.cod_estado_registro=1");
                                        consulta.append(" order by pp.NOMBRE_PRODUCTO_PRESENTACION");
            LOGGER.debug(" consulta cargar tipos programa produccion "+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            while(res.next()) 
            {
                presentacionesProductoSelectList.add(new SelectItem(res.getString("cod_presentacion"),res.getString("NOMBRE_PRODUCTO_PRESENTACION")));
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
        return presentacionesProductoSelectList;
    }
    
    public boolean guardarConDetalleEs(ComponentesPresProdVersion componentesPresProdVersion,FormulaMaestraEsVersion formulaMaestraEsVersion) throws SQLException
    {
        boolean guardado = false;
        LOGGER.debug("------------------------------inicio registro componentes pres prod version---------------------------");
        try {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta = new StringBuilder("INSERT INTO COMPONENTES_PRESPROD_VERSION(COD_VERSION, COD_COMPPROD,COD_PRESENTACION, CANT_COMPPROD, COD_TIPO_PROGRAMA_PROD, COD_ESTADO_REGISTRO,COD_FORMULA_MAESTRA_ES_VERSION)");
                                        consulta.append(" VALUES (");
                                                consulta.append(formulaMaestraEsVersion.getComponentesProdVersion().getCodVersion()).append(",");
                                                consulta.append(formulaMaestraEsVersion.getComponentesProdVersion().getCodCompprod()).append(",");
                                                consulta.append(componentesPresProdVersion.getPresentacionesProducto().getCodPresentacion()).append(",");
                                                consulta.append(componentesPresProdVersion.getCantCompProd()).append(",");
                                                consulta.append(componentesPresProdVersion.getTiposProgramaProduccion().getCodTipoProgramaProd()).append(",");
                                                consulta.append("1,");
                                                consulta.append(formulaMaestraEsVersion.getCodFormulaMaestraEsVersion());
                                        consulta.append(")");
            LOGGER.debug("consulta registrar componentes presprod version " + consulta.toString());
            PreparedStatement pst = con.prepareStatement(consulta.toString());
            if (pst.executeUpdate() > 0) LOGGER.info(" se registro la presentacion secundaria ");
            consulta=new StringBuilder("INSERT INTO FORMULA_MAESTRA_DETALLE_ES_VERSION(COD_VERSION, COD_FORMULA_MAESTRA,COD_MATERIAL, CANTIDAD, COD_UNIDAD_MEDIDA, COD_PRESENTACION_PRODUCTO,");
                                consulta.append("COD_TIPO_PROGRAMA_PROD, FECHA_MODIFICACION, COD_FORMULA_MAESTRA_ES_VERSION,DEFINE_NUMERO_LOTE)");
                        consulta.append("VALUES (");
                                consulta.append(formulaMaestraEsVersion.getComponentesProdVersion().getCodFormulaMaestraVersion()).append(",");//codversion fm
                                consulta.append(formulaMaestraEsVersion.getComponentesProdVersion().getCodFormulaMaestra()).append(",");//cod formula maestra
                                consulta.append("?,");//cod material
                                consulta.append("?,");//cantidad
                                consulta.append("?,");//unidad medida
                                consulta.append(componentesPresProdVersion.getPresentacionesProducto().getCodPresentacion()).append(",");
                                consulta.append(componentesPresProdVersion.getTiposProgramaProduccion().getCodTipoProgramaProd()).append(",");
                                consulta.append("GETDATE(),");
                                consulta.append(formulaMaestraEsVersion.getCodFormulaMaestraEsVersion()).append(",");
                                consulta.append("?");
                        consulta.append(")");
            LOGGER.debug("consulta registrar detalle es "+consulta.toString());
            pst=con.prepareStatement(consulta.toString());
            for(FormulaMaestraDetalleES bean : componentesPresProdVersion.getFormulaMaestraDetalleESList())
            {
                pst.setString(1, bean.getMateriales().getCodMaterial());LOGGER.debug("p1: "+bean.getMateriales().getCodMaterial());
                pst.setDouble(2,bean.getCantidad());LOGGER.debug("p2: "+bean.getCantidad());
                pst.setString(3, bean.getUnidadesMedida().getCodUnidadMedida());LOGGER.debug("p3: "+bean.getUnidadesMedida().getCodUnidadMedida());
                pst.setBoolean(4,bean.getDefineNumeroLote());LOGGER.debug("p4: "+bean.getDefineNumeroLote());
                if(pst.executeUpdate()>0)LOGGER.info("se registro el detalle material "+bean.getMateriales().getCodMaterial());
            }
            con.commit();
            guardado = true;
        }
        catch (SQLException ex) 
        {
            guardado = false;
            LOGGER.warn(ex.getMessage());
            con.rollback();
        } catch (Exception ex) {
            guardado = false;
            LOGGER.warn(ex.getMessage());
        } finally {
            this.cerrarConexion(con);
        }
        LOGGER.debug("------------------------------final registro componentes pres prod version---------------------------");
        return guardado;
    }
    
    public boolean editarConDetalleEs(ComponentesPresProdVersion componentesPresProdVersion,FormulaMaestraEsVersion formulaMaestraEsVersion) throws SQLException
    {
        boolean guardado = false;
        LOGGER.debug("------------------------------inicio editar componentes pres prod version---------------------------");
        try {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta = new StringBuilder("update COMPONENTES_PRESPROD_VERSION ");
                                        consulta.append(" set"); 
                                                consulta.append(" CANT_COMPPROD=").append(componentesPresProdVersion.getCantCompProd());
                                                consulta.append(" ,COD_ESTADO_REGISTRO=").append(componentesPresProdVersion.getEstadoReferencial().getCodEstadoRegistro());
                                        consulta.append(" where COD_FORMULA_MAESTRA_ES_VERSION=").append(formulaMaestraEsVersion.getCodFormulaMaestraEsVersion());
                                                consulta.append(" and COD_TIPO_PROGRAMA_PROD=").append(componentesPresProdVersion.getTiposProgramaProduccion().getCodTipoProgramaProd());
                                                consulta.append(" and COD_PRESENTACION=").append(componentesPresProdVersion.getPresentacionesProducto().getCodPresentacion());
            LOGGER.debug("consulta update componentes pres prod version " + consulta.toString());
            PreparedStatement pst = con.prepareStatement(consulta.toString(), PreparedStatement.RETURN_GENERATED_KEYS);
            if (pst.executeUpdate() > 0)LOGGER.info("se actualizo el estado del producto");
            
            consulta=new StringBuilder("delete from FORMULA_MAESTRA_DETALLE_ES_VERSION ");
                        consulta.append(" where COD_FORMULA_MAESTRA_ES_VERSION=").append(formulaMaestraEsVersion.getCodFormulaMaestraEsVersion());
                                consulta.append(" and COD_PRESENTACION_PRODUCTO=").append(componentesPresProdVersion.getPresentacionesProducto().getCodPresentacion());
                                consulta.append(" and COD_TIPO_PROGRAMA_PROD=").append(componentesPresProdVersion.getTiposProgramaProduccion().getCodTipoProgramaProd());
            LOGGER.debug("consulta eliminar formula maestra detalle es "+consulta.toString());
            pst=con.prepareStatement(consulta.toString());
            if(pst.executeUpdate()>0)LOGGER.info("se elimino el detalle");
            
            consulta=new StringBuilder("INSERT INTO FORMULA_MAESTRA_DETALLE_ES_VERSION(COD_VERSION, COD_FORMULA_MAESTRA,COD_MATERIAL, CANTIDAD, COD_UNIDAD_MEDIDA, COD_PRESENTACION_PRODUCTO,");
                                consulta.append("COD_TIPO_PROGRAMA_PROD, FECHA_MODIFICACION, COD_FORMULA_MAESTRA_ES_VERSION,DEFINE_NUMERO_LOTE)");
                        consulta.append("VALUES (");
                                consulta.append(formulaMaestraEsVersion.getComponentesProdVersion().getCodFormulaMaestraVersion()).append(",");//codversion fm
                                consulta.append(formulaMaestraEsVersion.getComponentesProdVersion().getCodFormulaMaestra()).append(",");//cod formula maestra
                                consulta.append("?,");//cod material
                                consulta.append("?,");//cantidad
                                consulta.append("?,");//unidad medida
                                consulta.append(componentesPresProdVersion.getPresentacionesProducto().getCodPresentacion()).append(",");
                                consulta.append(componentesPresProdVersion.getTiposProgramaProduccion().getCodTipoProgramaProd()).append(",");
                                consulta.append("GETDATE(),");
                                consulta.append(formulaMaestraEsVersion.getCodFormulaMaestraEsVersion()).append(",");
                                consulta.append("?");//define nro de lote
                        consulta.append(")");
            LOGGER.debug("consulta registrar detalle es "+consulta.toString());
            pst=con.prepareStatement(consulta.toString());
            for(FormulaMaestraDetalleES bean : componentesPresProdVersion.getFormulaMaestraDetalleESList())
            {
                if(bean.getChecked())
                {
                    pst.setString(1, bean.getMateriales().getCodMaterial());LOGGER.debug("p1: "+bean.getMateriales().getCodMaterial());
                    pst.setDouble(2,bean.getCantidad());LOGGER.debug("p2: "+bean.getCantidad());
                    pst.setString(3, bean.getUnidadesMedida().getCodUnidadMedida());LOGGER.debug("p3: "+bean.getUnidadesMedida().getCodUnidadMedida());
                    pst.setBoolean(4, bean.getDefineNumeroLote());LOGGER.debug("p4: "+bean.getDefineNumeroLote());
                    if(pst.executeUpdate()>0)LOGGER.info("se registro el detalle material "+bean.getMateriales().getCodMaterial());
                }
            }

            con.commit();
            guardado =  true;
        } catch (SQLException ex) {
            guardado = false;
            LOGGER.warn(ex.getMessage());
            con.rollback();
        } catch (Exception ex) {
            guardado = false;
            LOGGER.warn(ex.getMessage());
        } finally {
            this.cerrarConexion(con);
        }
        LOGGER.debug("------------------------------final editar componentes pres prod version---------------------------");
        return guardado;
    }
    
    public boolean eliminar(ComponentesPresProdVersion componentesPresProdVersion) throws SQLException
    {
        boolean eliminado = false;
        LOGGER.debug("------------------------------inicio eliminar componentes pres prod version---------------------------");
        try{
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta = new StringBuilder("DELETE COMPONENTES_PRESPROD_VERSION ");
                                        consulta.append(" where COD_FORMULA_MAESTRA_ES_VERSION=").append(componentesPresProdVersion.getFormulaMaestraEsVersion().getCodFormulaMaestraEsVersion());
                                        consulta.append(" AND COD_TIPO_PROGRAMA_PROD=").append(componentesPresProdVersion.getTiposProgramaProduccion().getCodTipoProgramaProd());
                                        consulta.append(" AND COD_PRESENTACION=").append(componentesPresProdVersion.getPresentacionesProducto().getCodPresentacion());
            LOGGER.debug("consulta delete componentes pres prod version " + consulta.toString());
            PreparedStatement pst = con.prepareStatement(consulta.toString());
            if (pst.executeUpdate() > 0) LOGGER.info("se elimino el registro");
            
            consulta=new StringBuilder("delete from FORMULA_MAESTRA_DETALLE_ES_VERSION ");
                        consulta.append(" where COD_FORMULA_MAESTRA_ES_VERSION=").append(componentesPresProdVersion.getFormulaMaestraEsVersion().getCodFormulaMaestraEsVersion());
                                consulta.append(" and COD_PRESENTACION_PRODUCTO=").append(componentesPresProdVersion.getPresentacionesProducto().getCodPresentacion());
                                consulta.append(" and COD_TIPO_PROGRAMA_PROD=").append(componentesPresProdVersion.getTiposProgramaProduccion().getCodTipoProgramaProd());
            pst=con.prepareStatement(consulta.toString());
            LOGGER.debug("consulta eliminar formula maestra detalle es version " + consulta.toString());
            if(pst.executeUpdate()>0)LOGGER.info("se eliminaron los materiales ");
            con.commit();
            eliminado = true;
        }
        catch (SQLException ex) 
        {
            eliminado = false;
            LOGGER.warn(ex.getMessage());
            con.rollback();
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
        LOGGER.debug("------------------------------final eliminar componentes pres prod version---------------------------");
        return eliminado;
    }
}
