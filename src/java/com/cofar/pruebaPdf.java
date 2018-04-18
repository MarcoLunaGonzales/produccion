/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar;

import com.cofar.bean.util.CreacionGraficosOrdenManufactura;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

import org.apache.commons.dbcp.BasicDataSource;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;




/**
 *
 * @author DASISAQ-
 */
public class pruebaPdf {

    protected static Logger LOGGER=LogManager.getRootLogger();
    public static void main(String[] args) throws IOException,SQLException
    {
        BasicDataSource basicDataSource=new BasicDataSource();
        basicDataSource.setUrl("jdbc:sqlserver://172.16.10.228;databaseName=SARTORIUS20171010");
        basicDataSource.setDriverClassName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        basicDataSource.setUsername("sa");
        basicDataSource.setPassword("m0t1t4s@2009");
        basicDataSource.setInitialSize(6);
        basicDataSource.setMaxActive(2000);
        basicDataSource.setMaxWait(60000);
        Connection con=basicDataSource.getConnection();
        (new CreacionGraficosOrdenManufactura()).crearFlujogramaOrdenManufacturaProduccion(con, LOGGER,"H3429",0, 10);
        

    }
    
    
}
