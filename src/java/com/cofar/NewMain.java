/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar;

import com.cofar.bean.util.correos.EnviarCorreoAprobacionVersionProducto;
import com.cofar.util.Util;
import com.mysql.jdbc.JDBC4PreparedStatement;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Properties;
import javax.mail.Message;
import javax.mail.Session;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.sql.DataSource;
import org.apache.commons.dbcp.BasicDataSource;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/**
 *
 * @author DASISAQ-
 */
public class NewMain {

    private static Logger LOGGER=LogManager.getRootLogger();
    
    public static void main(String[] args) {
     
        BasicDataSource basicDataSource=new BasicDataSource();
        basicDataSource.setUrl("jdbc:sqlserver://localhost;databaseName=SARTORIUS20170721");
        basicDataSource.setDriverClassName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        basicDataSource.setUsername("sa");
        basicDataSource.setPassword("m0t1t4s@2009");
        basicDataSource.setInitialSize(6);
        basicDataSource.setMaxActive(2000);
        basicDataSource.setMaxWait(60000);
        try
        {
            int codVersion=1177;
            double cantidadFin=1000;//cantidad llegar
            double cantidadIni=1000;//cantidad sistema
            double cantidadIncremento=-((cantidadIni-cantidadFin)/cantidadIni);
            Connection con=basicDataSource.getConnection();
            Statement st =con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta = "update USUARIOS_MODULOS set CONTRASENA_USUARIO=?";
            PreparedStatement pst = con.prepareStatement(consulta);
            pst.setString(1, "3");
            
            pst.executeUpdate();
            
            
                  
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
        
    }

      
    
    
}
