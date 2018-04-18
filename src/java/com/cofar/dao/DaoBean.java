/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.dao;

import java.sql.Connection;
import java.sql.SQLException;
import org.apache.logging.log4j.Logger;

/**
 *
 * @author DASISAQ
 */
public class DaoBean 
{
    protected Logger LOGGER;
    protected Connection con=null;

    public DaoBean() {
    }

    public Logger getLOGGER() {
        return LOGGER;
    }

    public void setLOGGER(Logger LOGGER) {
        this.LOGGER = LOGGER;
    }

    public Connection getCon() {
        return con;
    }

    public void setCon(Connection con) {
        this.con = con;
    }
    protected void cerrarConexion(Connection conexion)
    {
        try
        {
            if(conexion!=null&&!conexion.isClosed())
            {
                conexion.close();
            }
        }
        catch(SQLException ex)
        {
            LOGGER.warn("error", ex);
        }
    }
    protected void rollbackConexion(Connection conexion)
    {
        try
        {
            if(conexion!=null && !conexion.isClosed() && (!conexion.getAutoCommit()))
            {
                conexion.rollback();
            }
        }
        catch(SQLException ex)
        {
            LOGGER.warn("error", ex);
        }
    }
}
