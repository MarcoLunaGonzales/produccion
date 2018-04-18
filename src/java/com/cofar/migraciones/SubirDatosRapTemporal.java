/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.migraciones;
import com.cofar.bean.util.CreacionGraficosOrdenManufactura;
import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics;
import java.awt.Point;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import javax.imageio.ImageIO;
import org.apache.commons.dbcp.BasicDataSource;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/**
 *
 * @author DASISAQ-
 */
public class SubirDatosRapTemporal 
{
    /*
        delete DIAGRAMA_PREPARADO_PRODUCTO_PROCESO_VERSION
    */
    private static Logger LOGGER=LogManager.getRootLogger();
    
    public static void main(String[] args) {
     
        NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
        DecimalFormat format = (DecimalFormat)nf;
        format.applyPattern("#,###.00");
        BasicDataSource basicDataSource=new BasicDataSource();
        basicDataSource.setUrl("jdbc:sqlserver://172.16.10.21;databaseName=SARTORIUS");
        basicDataSource.setDriverClassName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        basicDataSource.setUsername("sa");
        basicDataSource.setPassword("m0t1t4s@2009");
        basicDataSource.setInitialSize(6);
        basicDataSource.setMaxActive(2000);
        basicDataSource.setMaxWait(60000);
        SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm");
        try
        {
            Connection con=basicDataSource.getConnection();
            con.setAutoCommit(false);
            StringBuilder consulta =new StringBuilder("insert into TEMP_RAP_DATOS_CONTROL_CAMBIOS (COD_PROD,CODIGO_REGISTRO_CONTROL_CAMBIOS ,DESCRIPCION ,CAPA )");
                                    consulta.append("values(?,?,?,?)");
                        PreparedStatement pstDoc=con.prepareStatement(consulta.toString());
                        
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            
            consulta=new StringBuilder("set dateformat ymd;select tr.cod_prod,tr.codigoRegistro,tr.descripcion,tr.capa from temp_rap tr");
            LOGGER.debug("consults documento "+consulta.toString());
            ResultSet res=st.executeQuery(consulta.toString());
            while(res.next())
            {
                LOGGER.debug("entro");
                pstDoc.setInt(1,res.getInt("cod_prod"));
                String[] codigosProducto=res.getString("codigoRegistro").split(";");
                String[] descripcionProducto=res.getString("descripcion").split(";");
                String[] capaProducto=res.getString("capa").split(";");
                for(int i=0;i<codigosProducto.length;i++)
                {
                    pstDoc.setString(2,codigosProducto[i]);
                    if(i<descripcionProducto.length)
                        pstDoc.setString(3,descripcionProducto[i]);
                    else
                        pstDoc.setString(3,"");
                    if(i<capaProducto.length)
                        pstDoc.setString(4,capaProducto[i]);
                    else
                        pstDoc.setString(4,"");
                    if(pstDoc.executeUpdate()>0)LOGGER.info("se registro la prueba ");
                }
            }
            con.commit();
            
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
    }

      
    
    
}
