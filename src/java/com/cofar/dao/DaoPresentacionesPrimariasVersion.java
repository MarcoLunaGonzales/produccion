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
import java.sql.PreparedStatement;
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
public class DaoPresentacionesPrimariasVersion extends DaoBean 
{
    public DaoPresentacionesPrimariasVersion() {
        LOGGER = LogManager.getRootLogger();
    }
    public DaoPresentacionesPrimariasVersion(Logger LOGGER) {
        this.LOGGER = LOGGER;
    }
    
    public boolean editarConDetalleEp(PresentacionesPrimarias presentacionesPrimarias, FormulaMaestraVersion formulaMaestraVersion)throws SQLException
    {
        boolean guardado = false;
        LOGGER.debug("---------------------------INICIO EDITAR PRESENTACION PRIMARIA-----------");
        try{
            con=Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta=new StringBuilder("update PRESENTACIONES_PRIMARIAS_VERSION ");
                        consulta.append(" set COD_ESTADO_REGISTRO=").append(presentacionesPrimarias.getEstadoReferencial().getCodEstadoRegistro());
                                consulta.append(" ,CANTIDAD=").append(presentacionesPrimarias.getCantidad());
                                consulta.append(" ,COD_TIPO_PROGRAMA_PROD=").append(presentacionesPrimarias.getTiposProgramaProduccion().getCodTipoProgramaProd());
                                consulta.append(" ,COD_ENVASEPRIM=").append(presentacionesPrimarias.getEnvasesPrimarios().getCodEnvasePrim());
                                consulta.append(" ,FECHA_MODIFICACION = GETDATE()");
                        consulta.append(" where COD_PRESENTACION_PRIMARIA=").append(presentacionesPrimarias.getCodPresentacionPrimaria());
                                consulta.append(" and COD_VERSION=").append(formulaMaestraVersion.getComponentesProd().getCodVersion());
            LOGGER.debug("consulta editar presentacion primaria "+consulta.toString());
            PreparedStatement pst=con.prepareStatement(consulta.toString());
            if(pst.executeUpdate()>0)LOGGER.info("se edito la presnetacion primaria");
            
            consulta = new StringBuilder("delete FORMULA_MAESTRA_DETALLE_EP_VERSION");
                                        consulta.append(" where COD_PRESENTACION_PRIMARIA=").append(presentacionesPrimarias.getCodPresentacionPrimaria());
                                                consulta.append(" and COD_VERSION=").append(formulaMaestraVersion.getCodVersion());
                                                consulta.append(" and COD_FORMULA_MAESTRA=").append(formulaMaestraVersion.getCodFormulaMaestra());
            LOGGER.debug("consulta delete fm pstDel1"+consulta.toString());
            pst = con.prepareStatement(consulta.toString());
            if(pst.executeUpdate()>0)LOGGER.info("se elimino detalle ep ");
            
            consulta=new StringBuilder("INSERT INTO FORMULA_MAESTRA_DETALLE_EP_VERSION(COD_VERSION, COD_FORMULA_MAESTRA,");
                                    consulta.append(" COD_PRESENTACION_PRIMARIA, COD_MATERIAL,CANTIDAD_UNITARIA,COD_UNIDAD_MEDIDA,");
                                    consulta.append(" PORCIENTO_EXCESO,FECHA_MODIFICACION)");
                                    
                            consulta.append(" VALUES (");
                                    consulta.append(formulaMaestraVersion.getCodVersion()).append(",");
                                    consulta.append(formulaMaestraVersion.getCodFormulaMaestra()).append(",");
                                    consulta.append("'").append(presentacionesPrimarias.getCodPresentacionPrimaria()).append("',");
                                    consulta.append("?,");//cod material
                                    consulta.append("?,");//CANTIDAD_UNITARIA
                                    consulta.append("?,");//COD UNIDAD MEDIDA
                                    consulta.append("?,");//PORCIENTO EXCESO
                                    consulta.append("getdate()");
                            consulta.append(")");
            LOGGER.debug("consulta insertar formula maestra detalle ep pstep : "+consulta.toString());
            pst=con.prepareStatement(consulta.toString());
            for(FormulaMaestraDetalleEP bean : presentacionesPrimarias.getFormulaMaestraDetalleEPList())
            {
                pst.setString(1,bean.getMateriales().getCodMaterial());LOGGER.info("p1 pstep: "+bean.getMateriales().getCodMaterial());
                pst.setDouble(2,bean.getCantidadUnitaria());LOGGER.info("p2 pstep: "+bean.getCantidadUnitaria());
                pst.setString(3,bean.getUnidadesMedida().getCodUnidadMedida());LOGGER.info("p3 pstep: "+bean.getUnidadesMedida().getCodUnidadMedida());
                pst.setDouble(4,bean.getPorcientoExceso());LOGGER.info("p4 pstep: "+bean.getPorcientoExceso());
                if(pst.executeUpdate()>0)LOGGER.info("se registro el empaque primario");
            }
            
            consulta = new StringBuilder("exec PAA_ACTUALIZACION_CANTIDADES_FORMULA_MAESTRA_VERSION ")
                                .append(formulaMaestraVersion.getComponentesProd().getCodVersion());
            LOGGER.debug("consulta actualizar cantidades "+consulta.toString());
            pst = con.prepareStatement(consulta.toString());
            if(pst.executeUpdate() > 0)LOGGER.info("se registro ");
            
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
        LOGGER.debug("---------------------------FIN EDITAR PRESENTACION PRIMARIA-----------");
        return guardado;
    }
    
    public boolean guardarConDetalleEp(PresentacionesPrimarias presentacionesPrimarias,FormulaMaestraVersion formulaMaestraVersion) throws SQLException
    {
        boolean guardado = false;
        LOGGER.debug("---------------------------INICIO REGISTRO NUEVA PRESENTACION PRIMARIA-----------");
        try{
            con=Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta=new StringBuilder("INSERT INTO PRESENTACIONES_PRIMARIAS(COD_COMPPROD,");
                                            consulta.append(" COD_ENVASEPRIM, CANTIDAD, COD_TIPO_PROGRAMA_PROD, COD_ESTADO_REGISTRO,");
                                            consulta.append(" FECHA_MODIFICACION)");
                                    consulta.append("VALUES( ");
                                            consulta.append(presentacionesPrimarias.getComponentesProd().getCodCompprod()).append(",");
                                            consulta.append("'").append(presentacionesPrimarias.getEnvasesPrimarios().getCodEnvasePrim()).append("',");
                                            consulta.append(presentacionesPrimarias.getCantidad()).append(",");
                                            consulta.append("'").append(presentacionesPrimarias.getTiposProgramaProduccion().getCodTipoProgramaProd()).append("',");
                                            consulta.append("1,");
                                            consulta.append("GETDATE()");
                                    consulta.append(")");
            LOGGER.debug("consulta registrar presentacion primaria "+consulta.toString());
            PreparedStatement pst=con.prepareStatement(consulta.toString(),PreparedStatement.RETURN_GENERATED_KEYS);
            if(pst.executeUpdate()>0)LOGGER.info("se registro la presentacion primaria");
            ResultSet res=pst.getGeneratedKeys();
            res.next();
            presentacionesPrimarias.setCodPresentacionPrimaria(res.getString(1));
            consulta=new StringBuilder("INSERT INTO PRESENTACIONES_PRIMARIAS_VERSION(COD_VERSION,COD_PRESENTACION_PRIMARIA, COD_COMPPROD, COD_ENVASEPRIM, CANTIDAD,");
                                                                        consulta.append(" COD_TIPO_PROGRAMA_PROD, COD_ESTADO_REGISTRO, FECHA_MODIFICACION)");
                        consulta.append(" select ").append(presentacionesPrimarias.getComponentesProd().getCodVersion()).append(" , pp.COD_PRESENTACION_PRIMARIA, pp.COD_COMPPROD, pp.COD_ENVASEPRIM");
                                consulta.append(" ,pp.CANTIDAD, pp.COD_TIPO_PROGRAMA_PROD, pp.COD_ESTADO_REGISTRO, pp.FECHA_MODIFICACION");
                        consulta.append(" from PRESENTACIONES_PRIMARIAS pp");
                        consulta.append(" where pp.COD_PRESENTACION_PRIMARIA=").append(presentacionesPrimarias.getCodPresentacionPrimaria());
            LOGGER.debug("consulta registrar presentacion primaria version "+consulta.toString());
            pst=con.prepareStatement(consulta.toString());
            if(pst.executeUpdate()>0)LOGGER.info("se registro la presentacion primaria version ");
            consulta=new StringBuilder("INSERT INTO FORMULA_MAESTRA_DETALLE_EP_VERSION(COD_VERSION, COD_FORMULA_MAESTRA,");
                                    consulta.append(" COD_PRESENTACION_PRIMARIA, COD_MATERIAL,CANTIDAD_UNITARIA, COD_UNIDAD_MEDIDA");
                                    consulta.append(" ,PORCIENTO_EXCESO, FECHA_MODIFICACION)");
                            consulta.append(" VALUES (");
                                    consulta.append(formulaMaestraVersion.getCodVersion()).append(",");
                                    consulta.append(formulaMaestraVersion.getCodFormulaMaestra()).append(",");
                                    consulta.append("'").append(presentacionesPrimarias.getCodPresentacionPrimaria()).append("',");
                                    consulta.append("?,");//cod material
                                    consulta.append("?,");//CANTIDAD_UNITARIA
                                    consulta.append("?,");//COD UNIDAD MEDIDA
                                    consulta.append("?,");//exceso
                                    consulta.append("getdate()");
                            consulta.append(")");
            LOGGER.debug("consulta insertar formula maestra detalle ep pstep : "+consulta.toString());
            pst=con.prepareStatement(consulta.toString());
            for(FormulaMaestraDetalleEP bean : presentacionesPrimarias.getFormulaMaestraDetalleEPList())
            {
                if(bean.getChecked())
                {
                    pst.setString(1,bean.getMateriales().getCodMaterial());LOGGER.info("p1 pstep: "+bean.getMateriales().getCodMaterial());
                    pst.setDouble(2,bean.getCantidadUnitaria());LOGGER.info("p2 pstep: "+bean.getCantidadUnitaria());
                    pst.setString(3,bean.getUnidadesMedida().getCodUnidadMedida());LOGGER.info("p3 pstep: "+bean.getUnidadesMedida().getCodUnidadMedida());
                    pst.setDouble(4,bean.getPorcientoExceso());LOGGER.info("p4 pstep: "+bean.getPorcientoExceso());
                    if(pst.executeUpdate()>0)LOGGER.info("se registro el empaque primario");
                }
            }
            consulta = new StringBuilder("exec PAA_ACTUALIZACION_CANTIDADES_FORMULA_MAESTRA_VERSION ")
                                .append(formulaMaestraVersion.getComponentesProd().getCodVersion());
            LOGGER.debug("consulta actualizar cantidades "+consulta.toString());
            pst = con.prepareStatement(consulta.toString());
            if(pst.executeUpdate() > 0)LOGGER.info("se registro ");
            
            guardado = true;
            con.commit();
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
        LOGGER.debug("---------------------------FIN REGISTRO PRESENTACION PRIMARIA-----------");
        return guardado;
        
    }
    
    public boolean eliminarConDetalleEp(PresentacionesPrimarias presentacionesPrimarias, FormulaMaestraVersion formulaMaestraVersion)throws SQLException
    {
        boolean eliminado = false;
        LOGGER.debug("---------------------------INICIO ELIMINAR PRESENTACION PRIMARIA-----------");
        try{
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta=new StringBuilder(" DELETE FORMULA_MAESTRA_DETALLE_EP_VERSION");
                                    consulta.append(" WHERE COD_VERSION = ").append(formulaMaestraVersion.getCodVersion());
                                            consulta.append(" and COD_FORMULA_MAESTRA = ").append(formulaMaestraVersion.getCodFormulaMaestra());
                                            consulta.append(" and COD_PRESENTACION_PRIMARIA = ").append(presentacionesPrimarias.getCodPresentacionPrimaria());
            LOGGER.debug("consulta delete materiales ep "+consulta.toString());
            PreparedStatement pst=con.prepareStatement(consulta.toString());
            if(pst.executeUpdate()>0)LOGGER.info("se eliminaron materiales ep "+consulta.toString());
            
            consulta=new StringBuilder("delete PRESENTACIONES_PRIMARIAS_VERSION");
                        consulta.append(" where COD_VERSION=").append(presentacionesPrimarias.getComponentesProd().getCodVersion());
                                consulta.append(" and COD_PRESENTACION_PRIMARIA=").append(presentacionesPrimarias.getCodPresentacionPrimaria());
            LOGGER.debug("consulta eliminar presentacion primaria "+consulta.toString());
            pst=con.prepareStatement(consulta.toString());
            if(pst.executeUpdate()>0)LOGGER.info("se elimino la presentacion primaria");
            
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
        LOGGER.debug("---------------------------TERMINO ELIMINAR PRESENTACION PRIMARIA-----------");
        return eliminado;
    }
    
}
