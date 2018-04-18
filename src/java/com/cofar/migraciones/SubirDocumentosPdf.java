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
public class SubirDocumentosPdf 
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
            StringBuilder consulta =new StringBuilder("INSERT INTO DOCUMENTACION(COD_DOCUMENTO,NOMBRE_DOCUMENTO, CODIGO_DOCUMENTO,");
                                    consulta.append(" COD_TIPO_DOCUMENTO_BIBLIOTECA, COD_AREA_EMPRESA,COD_MAQUINA,NRO_PREGUNTAS_CUESTIONARIO,COD_COMPPROD,CODIGO_NUEVO,");
                                    consulta.append(" COD_ESTADO_REGISTRO,COD_TIPO_DOCUMENTO_CONTROL_CALIDAD)");
                                    consulta.append(" values(");
                                        consulta.append("?,");//CODDOCUMENTO
                                        consulta.append("?,");
                                        consulta.append("?,");//CODIGOS DOCUMENTOS
                                        consulta.append("?,");// TIPO DE DOCUMENTO
                                        consulta.append("?,");//AREA eMPRESA
                                        consulta.append("?,");//mauqinaria
                                        consulta.append("0,");
                                        consulta.append("0,");//codigos producto 0
                                        consulta.append("?,");//codigo nuevo
                                        consulta.append("1,");
                                        consulta.append("?");//cod tipo documento CC
                                    consulta.append(")");
                        PreparedStatement pstDoc=con.prepareStatement(consulta.toString());
                        LOGGER.debug("consult insercat d "+consulta.toString());
                        consulta=new StringBuilder("INSERT INTO VERSION_DOCUMENTACION(COD_DOCUMENTO, NRO_VERSION, FECHA_CARGADO,");
                                    consulta.append("  FECHA_INGRESO_VIGENCIA, FECHA_PROXIMA_REVISION,");
                                    consulta.append(" COD_PERSONAL_ELABORA, COD_ESTADO_DOCUMENTO, URL_DOCUMENTO,APLICA_DOCUMENTO,CODIGO_VERSION_DOCUMENTO,");
                                    consulta.append(" OBSERVACION,NOMBRE_DOCUMENTO_VERSION,NOMBRE_PERSONA_ELABORA_OTROS)");
                                    consulta.append(" VALUES(");
                                            consulta.append("?,");//cod documento
                                            consulta.append("?,");//nro version
                                            consulta.append("?,");//fecha cargado
                                            consulta.append("?,");//fecha ingreso vigencia
                                            consulta.append("?,");//fecha proxima revision
                                            consulta.append("0,");//personal elabora
                                            consulta.append("?,");//estado documentos
                                            consulta.append("'',");//url documento
                                            consulta.append("1,");
                                            consulta.append("?,");//codigo documento version
                                            consulta.append("'',");//observacion 
                                            consulta.append("?,");// nombre documento version
                                            consulta.append("?");//nombre persona elabora
                                    consulta.append(")");
                        PreparedStatement pstVersion=con.prepareStatement(consulta.toString());
                                    
                                            
                    
                    consulta=new StringBuilder("set dateformat ymd; select max(d.COD_DOCUMENTO) as codDocumento from DOCUMENTACION d");
                    
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta.toString());
            int codDocumento=0;
            if(res.next())codDocumento=res.getInt("codDocumento");
            pstDoc.setInt(4, 5);//procedimiento
            //pstDoc.setInt(4,9);//protocolo
           // pstDoc.setInt(4,4);//MANUALES
            //pstDoc.setInt(4, 6);//instructivo
            //pstDoc.setInt(4, 3);//especifiacion
            //pstDoc.setInt(4, 7);//politica
            //pstDoc.setInt(5,1007);//seguridad industrial
            //pstDoc.setInt(5,103);//calibracion y proyectos
            //pstDoc.setInt(5,86);//mantenimiento
            //pstDoc.setInt(5,85);//ingenieria industrial
            //pstDoc.setInt(5,76);//almacen amp
            //pstDoc.setInt(5,97);//pesaje
            //pstDoc.setInt(5,35);//aseguramiento de calidad
            //pstDoc.setInt(5,1010);//soporte
            //pstDoc.setInt(5,41);//direcccion
            //pstDoc.setInt(5,1);//APT
            //pstDoc.setInt(5, 84);//acondicionamiento
            //pstDoc.setInt(5, 96);//.priductops
            //pstDoc.setInt(5, 80);//lne
            //pstDoc.setInt(5, 95);//sms
            //pstDoc.setInt(5, 1009);//ESTABILIDAD
            //pstDoc.setInt(5,82);//sne
            //pstDoc.setInt(5,1004);//farmacovigikancia
            //pstDoc.setInt(5,81);//le
            //pstDoc.setInt(5,75);//microbiologia
            //pstDoc.setInt(5,39);//REGENCIA
            //pstDoc.setInt(5,78);//servicios
            pstDoc.setInt(5,40);//cc
            
            pstDoc.setInt(6,0);//sin maquianria
            pstDoc.setInt(8,0);//nivel de documento cc
            
            //revisiones
            pstVersion.setString(3,sdf.format(new Date()));
            pstVersion.setInt(6,4);
            consulta=new StringBuilder("select * from auxSubirDocumentacion");
            LOGGER.debug("consults documento "+consulta.toString());
            res=st.executeQuery(consulta.toString());
            while(res.next())
            {
                LOGGER.debug("entro");
                codDocumento++;
                pstDoc.setInt(1,codDocumento);
                pstDoc.setString(2,res.getString("nombreDocumento"));
                pstDoc.setString(3,res.getString("codigoDocumento"));
                pstDoc.setString(7,res.getString("codigoDocumento"));
                LOGGER.debug("entro 1");
                if(pstDoc.executeUpdate()>0)LOGGER.info("se registro el documento "+res.getString("nombreDocumento"));
                pstVersion.setInt(1, codDocumento);
                pstVersion.setInt(2, res.getInt("nroRevision"));
                pstVersion.setString(4,sdf.format(res.getTimestamp("fechaINgresoVigencia")));
                pstVersion.setString(5,sdf.format(res.getTimestamp("fechaProximaRevision")));
                pstVersion.setString(7,res.getString("codigoDocumento"));
                pstVersion.setString(8,res.getString("nombreDocumento"));
                pstVersion.setString(9,"");
                if(pstVersion.executeUpdate()>0)LOGGER.info("se registro la version");
            }
            con.commit();
            
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
    }

      
    
    
}
