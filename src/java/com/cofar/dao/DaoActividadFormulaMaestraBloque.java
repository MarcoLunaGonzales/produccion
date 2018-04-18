/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.dao;
import com.cofar.bean.ActividadFormulaMaestraBloque;
import com.cofar.bean.ActividadesFormulaMaestra;
import com.cofar.util.Util;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import org.apache.logging.log4j.LogManager;

/**
 *
 * @author DASISAQ
 */
public class DaoActividadFormulaMaestraBloque extends DaoBean{

    public DaoActividadFormulaMaestraBloque() {
        LOGGER=LogManager.getRootLogger();
    }
    
    public boolean eliminar(int codActividadFormulaMaestraBloque)throws SQLException
    {
        boolean transaccionExitosa=false;
        try 
        {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta = new StringBuilder(" DELETE ACTIVIDAD_FORMULA_MAESTRA_BLOQUE ")
                                              .append(" where COD_ACTIVIDAD_FORMULA_MAESTRA_BLOQUE=").append(codActividadFormulaMaestraBloque);
            LOGGER.debug("consulta  deleta actividad formula BLOQUE" + consulta.toString());
            PreparedStatement pst = con.prepareStatement(consulta.toString());
            if (pst.executeUpdate() > 0) LOGGER.info("Se elimino la transacción");
            consulta=new StringBuilder("UPDATE ACTIVIDADES_FORMULA_MAESTRA ")
                                .append(" SET COD_ACTIVIDAD_FORMULA_MAESTRA_BLOQUE=NULL")
                                .append(" where COD_ACTIVIDAD_FORMULA_MAESTRA_BLOQUE=").append(codActividadFormulaMaestraBloque);
            LOGGER.debug("consulta desvincular actividades formula maestra "+consulta.toString());
            pst=con.prepareStatement(consulta.toString());
            if(pst.executeUpdate()>0)LOGGER.info("se desvincularon las actividades");
            con.commit();
            transaccionExitosa=true;
            pst.close();
        }
        catch (SQLException ex) 
        {
            transaccionExitosa=false;
            LOGGER.warn(ex.getMessage());
            con.rollback();
        } 
        catch (Exception ex) 
        {
            transaccionExitosa=false;
            LOGGER.warn(ex.getMessage());
            con.rollback();
        }
        finally 
        {
            this.cerrarConexion(con);
        }
               
        return transaccionExitosa;
    }
    
    
    public boolean modificar(ActividadFormulaMaestraBloque actividadFormulaMaestraBloque)throws SQLException
    {
        boolean transaccionExitosa=false;
        try 
        {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta = new StringBuilder("UPDATE ACTIVIDAD_FORMULA_MAESTRA_BLOQUE")
                                                .append(" SET DESCRIPCION = ?,")
                                                        .append(" HORAS_HOMBRE_ESTANDAR = ").append(actividadFormulaMaestraBloque.getHorasHombreEstandar())
                                                .append(" WHERE COD_ACTIVIDAD_FORMULA_MAESTRA_BLOQUE =").append(actividadFormulaMaestraBloque.getCodActividadFormulaMaestraBloque());
            LOGGER.debug("consulta editar actividad formula maestra bloque"+consulta.toString());   
            PreparedStatement pst = con.prepareStatement(consulta.toString());
            pst.setString(1, actividadFormulaMaestraBloque.getDescripcion());LOGGER.info("p1: "+actividadFormulaMaestraBloque.getDescripcion());
            if (pst.executeUpdate() > 0) LOGGER.info("se edito la actividad formula maestra bloque");
            if(actividadFormulaMaestraBloque.getActividadesFormulaMaestraList()!=null)
            {
                consulta=new StringBuilder("UPDATE ACTIVIDADES_FORMULA_MAESTRA ")
                                    .append(" SET COD_ACTIVIDAD_FORMULA_MAESTRA_BLOQUE=NULL")
                                    .append(" where COD_ACTIVIDAD_FORMULA_MAESTRA_BLOQUE=").append(actividadFormulaMaestraBloque.getCodActividadFormulaMaestraBloque());
                LOGGER.debug("consulta desvincular actividades formula maestra "+consulta.toString());
                pst=con.prepareStatement(consulta.toString());
                if(pst.executeUpdate()>0)LOGGER.info("se desvincularon las actividades");
                consulta=new StringBuilder(" UPDATE ACTIVIDADES_FORMULA_MAESTRA ")
                                    .append(" SET COD_ACTIVIDAD_FORMULA_MAESTRA_BLOQUE=").append(actividadFormulaMaestraBloque.getCodActividadFormulaMaestraBloque())
                                    .append(" where COD_ACTIVIDAD_FORMULA=?");
                LOGGER.debug("consulta asociad actividad fm pstAfm"+consulta.toString());
                pst=con.prepareStatement(consulta.toString());
                for(ActividadesFormulaMaestra bean:actividadFormulaMaestraBloque.getActividadesFormulaMaestraList())
                {
                    pst.setInt(1,bean.getCodActividadFormula());LOGGER.info("p1 pstAfm "+bean.getCodActividadFormula());
                    if(pst.executeUpdate()>0)LOGGER.info("se registro la asociacion");
                }
                
            }
            con.commit();
            transaccionExitosa=true;
            pst.close();
        } 
        catch (SQLException ex) 
        {
            transaccionExitosa=false;
            LOGGER.warn(ex.getMessage());
            con.rollback();
        }
        catch (NumberFormatException ex) 
        {
            transaccionExitosa=false;
            LOGGER.warn(ex.getMessage());
            con.rollback();
        }
        finally 
        {
            con.close();
        }
        return transaccionExitosa;
    }
    
    public boolean guardar(ActividadFormulaMaestraBloque actividadFormulaMaestraBloque)throws SQLException
    {
        boolean transaccionExitosa=false;
        try 
        {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta = new StringBuilder("INSERT INTO ACTIVIDAD_FORMULA_MAESTRA_BLOQUE(DESCRIPCION, HORAS_HOMBRE_ESTANDAR)")
                                        .append("VALUES (")
                                                .append("?,")//descripcion
                                                .append(actividadFormulaMaestraBloque.getHorasHombreEstandar())
                                        .append(")");
            LOGGER.debug("consulta registrar actividad formula maestra bloque" +consulta.toString());
            PreparedStatement pst = con.prepareStatement(consulta.toString(),PreparedStatement.RETURN_GENERATED_KEYS);
            pst.setString(1,actividadFormulaMaestraBloque.getDescripcion());LOGGER.info("p1 pstBloque "+actividadFormulaMaestraBloque.getDescripcion());
            if (pst.executeUpdate() > 0) LOGGER.info("se actualizo la actividad formula maestra");
            if(actividadFormulaMaestraBloque.getActividadesFormulaMaestraList()!=null)
            {
                ResultSet res=pst.getGeneratedKeys();
                res.next();
                consulta=new StringBuilder(" UPDATE ACTIVIDADES_FORMULA_MAESTRA ")
                                    .append(" SET COD_ACTIVIDAD_FORMULA_MAESTRA_BLOQUE=").append(res.getInt(1))
                                    .append(" where COD_ACTIVIDAD_FORMULA=?");
                LOGGER.debug("consulta asociad actividad fm pstAfm"+consulta.toString());
                pst=con.prepareStatement(consulta.toString());
                for(ActividadesFormulaMaestra bean:actividadFormulaMaestraBloque.getActividadesFormulaMaestraList())
                {
                    pst.setInt(1,bean.getCodActividadFormula());LOGGER.info("p1 pstAfm "+bean.getCodActividadFormula());
                    if(pst.executeUpdate()>0)LOGGER.info("se registro la asociacion");
                }
                
            }
            con.commit();
            transaccionExitosa=true;
            pst.close();
        } catch (SQLException ex) {
            con.rollback();
            transaccionExitosa=false;
            LOGGER.warn(ex.getMessage());
        }
        catch (Exception ex) {
            con.rollback();
            transaccionExitosa=false;
            LOGGER.warn(ex.getMessage());
        }
        finally 
        {
            con.close();
        }
        return transaccionExitosa;
    }
    
}
