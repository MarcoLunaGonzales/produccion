/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.bean.util.correos;

import com.cofar.util.Util;
import java.io.File;
import java.io.FileOutputStream;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.List;
import java.sql.Connection;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;
import javax.mail.Message;
import javax.mail.Session;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import javax.activation.DataHandler;
import javax.activation.FileDataSource;
import javax.mail.BodyPart;
import javax.mail.MessagingException;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMultipart;
import javax.servlet.ServletContext;
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/**
 *
 * @author DASISAQ-
 */
public class EnviarCorreoAprobacionVersionProducto extends EnvioCorreo{
    private static final int COD_ESTADO_VERSION_ASIGNADO = 9;
    private int codCompProd;     
    private int codVersion;
    private ServletContext servletContext;
    private boolean enviarParaAprobacion;

    public EnviarCorreoAprobacionVersionProducto(int codCompProd, int codVersion,boolean enviarParaAprobacion,ServletContext servletContext) {
        super((enviarParaAprobacion?"Notificación de envio a aprobación de version":"Notificación de creación de versión"),LogManager.getLogger("EnvioCorreo"),"registro de presentacion : "+codVersion);
        this.codCompProd = codCompProd;
        this.codVersion = codVersion;
        this.enviarParaAprobacion=enviarParaAprobacion;
        this.servletContext=servletContext;
        
    }
    
    
    @Override
    public void run() 
    {
        try {
            Connection con=null;
            con=Util.openConnection(con);
            //<editor-fold desc="generando anexo pdf" defaultstate="collapsed">
                Map parameters = new HashMap();
                parameters.put("codVersion",this.codVersion);
                parameters.put("codCompProd",this.codCompProd);
                String direccionReporte = servletContext.getRealPath("/componentesProdVersion/jasper/reporteComparacionVersion.jasper");
                this.crearAdjuntoJasperPdf(direccionReporte, parameters, con,"cambiosVersion");
            //</editor-fold>
                SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy HH:mm");
                mensajeCorreo = new StringBuilder("<br/>");
                mensajeCorreo.append("Estimad@ : <br><br>");
                if(enviarParaAprobacion){
                    mensajeCorreo.append("Se envió a aprobación el versionamiento de un producto con los siguientes datos:");
                }
                else{
                    mensajeCorreo.append("Se comunica generación de una nueva versión de producto con los siguientes datos:");
                }
                mensajeCorreo.append("Se comunica el registro de una presentación con los siguientes datos :");
                mensajeCorreo.append("<br><br>");
                // <editor-fold defaultstate="collapsed" desc="generando datos de la version">
                    mensajeCorreo.append("<table style='margin-left:4em'>");
                    StringBuilder consulta=new StringBuilder("select c.nombre_prod_semiterminado,c.TAMANIO_LOTE_PRODUCCION,c.FECHA_MODIFICACION");
                                            consulta.append(" from COMPONENTES_PROD_VERSION c ");
                                            consulta.append(" where c.COD_VERSION=").append(this.codVersion);
                    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet res=st.executeQuery(consulta.toString());
                    if(res.next())
                    {
                        mensajeCorreo.append("<tr><td><b>Producto:</b></td><td><b>::</b></td><td>").append(res.getString("nombre_prod_semiterminado")).append("</td></tr>");
                        mensajeCorreo.append("<tr><td><b>Tamaño Lote:</b></td><td><b>::</b></td><td>").append(res.getDouble("TAMANIO_LOTE_PRODUCCION")).append("</td></tr>");
                        mensajeCorreo.append("<tr><td><b>Fecha Creación:</b></td><td><b>::</b></td><td>").append(sdf.format(res.getTimestamp("FECHA_MODIFICACION"))).append("</td></tr>");
                    }
                    mensajeCorreo.append("</table><br>");
                    mensajeCorreo.append("Para mas información del producto revise el archivo adjunto.");
                //</editor-fold>
                mensajeCorreo.append("<br>");
                LOGGER.debug("correo: "+mensajeCorreo.toString());
                
                consulta = new StringBuilder("select distinct cp.nombre_correopersonal")
                                    .append(" from COMPONENTES_PROD_VERSION_MODIFICACION c")
                                            .append(" inner join correo_personal cp on cp.COD_PERSONAL=c.COD_PERSONAL")
                                    .append(" where c.COD_VERSION = ").append(this.codVersion)
                                            .append(" and LEN(cp.nombre_correopersonal) >4");
                                        if (!enviarParaAprobacion)
                                            consulta.append(" and c.COD_ESTADO_VERSION_COMPONENTES_PROD =").append(COD_ESTADO_VERSION_ASIGNADO);
                LOGGER.debug("consulta cargar personal envio correo "+consulta.toString());
                res = st.executeQuery(consulta.toString());
                while(res.next()){
                    LOGGER.info("destino: "+res.getString("nombre_correopersonal"));
                    correoDestinoList.add(new InternetAddress(res.getString("nombre_correopersonal")));
                }
                consulta=new StringBuilder("SELECT distinct cp.nombre_correopersonal");
                            consulta.append(" FROM CONFIGURACION_ENVIO_CORREO_ATLAS ceca ");
                                    consulta.append(" inner join correo_personal cp on cp.COD_PERSONAL=ceca.COD_PERSONAL");
                            consulta.append(" where ceca.COD_MOTIVO_ENVIO_CORREO_PERSONAL=").append(enviarParaAprobacion?32:31);
                LOGGER.debug("consulta cargar personal envio correo "+consulta.toString());
                res=st.executeQuery(consulta.toString());
                while(res.next()){
                    LOGGER.info("copia: "+res.getString("nombre_correopersonal"));
                    correoCopiaList.add(new InternetAddress(res.getString("nombre_correopersonal")));
                }
            this.enviarCorreo();
        }
        catch (SQLException ex) 
        {
            LOGGER.warn("error", ex);
        } 
        catch (MessagingException ex) 
        {
            LOGGER.warn("error", ex);
        } 
        catch (UnsupportedEncodingException ex) 
        {
            LOGGER.warn("error", ex);
        }
        catch(Exception e)
        {
            LOGGER.warn("error", e);
        }
    }
    
}
