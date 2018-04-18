/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.bean.util.correos;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.sql.Connection;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import javax.activation.DataHandler;
import javax.activation.FileDataSource;
import javax.mail.BodyPart;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JRExporter;
import net.sf.jasperreports.engine.JRExporterParameter;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.export.JRPdfExporter;
import org.apache.logging.log4j.Logger;

/**
 *
 * @author DASISAQ
 */
public class EnvioCorreo extends Thread{
    //propiedades de envio de correo
    protected Properties propertiesGmail=null;
    protected Properties propertiesLocalMail=null;
    
    protected String asunto = "" ;
    protected String identificador = "";
    protected StringBuilder mensajeCorreo;
    protected MimeMultipart contenidoCorreo;
    protected Logger LOGGER;
    protected List<InternetAddress> correoDestinoList;
    protected List<InternetAddress> correoCopiaList;

    public EnvioCorreo(String asunto,Logger LOGGER,String identificador){
        // <editor-fold defaultstate="collapsed" desc="propiedades gmail">
            this.identificador = identificador;
            this.LOGGER = LOGGER;
            this.asunto = asunto;
            correoDestinoList = new ArrayList<InternetAddress>();
            correoCopiaList = new ArrayList<InternetAddress>();
            contenidoCorreo = new MimeMultipart();
            mensajeCorreo = new StringBuilder("");
            try
            {
                propertiesGmail = new Properties();
                propertiesGmail.load(EnvioCorreo.class.getClassLoader().getResourceAsStream("gMail.properties"));
                propertiesLocalMail = new Properties();
                propertiesLocalMail.load(EnvioCorreo.class.getClassLoader().getResourceAsStream("localMail.properties"));
            }
            catch(Exception ex)
            {
                LOGGER.warn("error inicializando configuracion correo ", ex);
            }
            
        //</editor-fold>
    }
    protected void crearAdjuntoJasperPdf(String direccionJasper,Map parameters,Connection con,String nombreAdjunto)throws JRException,IOException, MessagingException
    {
        BodyPart adjunto = new MimeBodyPart();
        LOGGER.debug("direccion archivo jasper generar "+direccionJasper);
        JasperPrint jasperPrint=JasperFillManager.fillReport(direccionJasper, parameters, con);
        String nombreTemp = "adjunto"+String.valueOf((new Date()).getTime());
        File ftemp=File.createTempFile(nombreTemp, ".pdf");
        FileOutputStream fileOuputStream = new FileOutputStream(ftemp); 
        JRExporter exporter = new JRPdfExporter();
        exporter.setParameter(JRExporterParameter.CHARACTER_ENCODING.JASPER_PRINT, jasperPrint);
        exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, fileOuputStream);
        exporter.exportReport();
        fileOuputStream.close();
        adjunto.setDataHandler(new DataHandler(new FileDataSource(ftemp)));
        adjunto.setFileName(nombreAdjunto+".pdf");
        contenidoCorreo.addBodyPart(adjunto);
    }
    
    protected void enviarCorreo()throws Exception
    {
        SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy HH:mm");
        StringBuilder mensajeCorreoEnviar=new StringBuilder("<html>");
                                    mensajeCorreoEnviar.append("<head>");
                                        mensajeCorreoEnviar.append("<style>");
                                            mensajeCorreoEnviar.append(".separador{width:100%;background-color:#75327c;font-size:3px;margin-top:3px;}");
                                            mensajeCorreoEnviar.append(".sistema{color:white;font-size:22px;font-style:italic;font-weight:bold;}");
                                            mensajeCorreoEnviar.append(".evento{color:white;font-size:14px;}");
                                            mensajeCorreoEnviar.append(".border{border: 1px solid #75327c}");
                                            mensajeCorreoEnviar.append(".detalle{color:white;font-size:15px;font-style:italic;font-weight:bold;}");
                                            mensajeCorreoEnviar.append(" body,table{font-family: Verdana, Arial, Helvetica, sans-serif;font-size:14px;}");
                                            mensajeCorreoEnviar.append(" td{padding:4px;}");
                                            mensajeCorreoEnviar.append(" .footer{font-size:10px;color:#aaaaaa;border:none !important;}");
                                            mensajeCorreoEnviar.append(" .footer tr td{border:1px solid #bbbbbb;}");
                                        mensajeCorreoEnviar.append("</style>");
                                    mensajeCorreoEnviar.append("</head>");
                                    mensajeCorreoEnviar.append("<body>");
                                        mensajeCorreoEnviar.append("<div>");
                                            mensajeCorreoEnviar.append("<table style='width:100%' cellpading='0' cellspacing='0'>");
                                                mensajeCorreoEnviar.append("<tr bgcolor='#75327c'>");
                                                    mensajeCorreoEnviar.append("<td rowspan='2' style='border'>");
                                                        mensajeCorreoEnviar.append("<span class='sistema'>ATLAS</span>");
                                                    mensajeCorreoEnviar.append("</td>");
                                                    mensajeCorreoEnviar.append("<td style='text-align:right'>");
                                                        mensajeCorreoEnviar.append("<span class='evento'>Motivo:<b>").append(asunto).append("</b></span>");
                                                    mensajeCorreoEnviar.append("</td>");
                                                mensajeCorreoEnviar.append("</tr>");
                                                mensajeCorreoEnviar.append("<tr bgcolor='#75327c'>");
                                                    mensajeCorreoEnviar.append("<td style='text-align:right'>");
                                                        mensajeCorreoEnviar.append("<span class='evento'>Fecha Notificación:<b>").append(sdf.format(new Date())).append("</b></span>");
                                                    mensajeCorreoEnviar.append("</td>");
                                                mensajeCorreoEnviar.append("</tr>");
                                            mensajeCorreoEnviar.append("</table>");
                                        mensajeCorreoEnviar.append("</div>");
                                        mensajeCorreoEnviar.append("<div class='separador'>&nbsp;</div>");
                                        mensajeCorreoEnviar.append("<div style='margin-left:15px'>");
                                                mensajeCorreoEnviar.append(mensajeCorreo.toString());
                                        mensajeCorreoEnviar.append("</div>");
                                        mensajeCorreoEnviar.append("<div align='left'>");
                                            mensajeCorreoEnviar.append("<table class='footer'>");
                                                mensajeCorreoEnviar.append("<tr>");
                                                    mensajeCorreoEnviar.append("<td bgcolor='#bbbbbb' class='evento'>ATLAS</td>");
                                                    mensajeCorreoEnviar.append("<td >");
                                                    mensajeCorreoEnviar.append("El presente correo tiene carácter puramente informativo.<br>");
                                                    mensajeCorreoEnviar.append("No trate de responder al remitente.");
                                                    mensajeCorreoEnviar.append("</td>");
                                                mensajeCorreoEnviar.append("</tr>");
                                            mensajeCorreoEnviar.append("<table>");
                                        mensajeCorreoEnviar.append("</div>");
                                    mensajeCorreoEnviar.append("</body>");
                                mensajeCorreoEnviar.append("</html>");
        BodyPart mensaje = new MimeBodyPart();
        mensaje.setContent(mensajeCorreoEnviar.toString(),"text/html");
        contenidoCorreo.addBodyPart(mensaje);
        if(correoDestinoList.size()>0)
        {
            try
            {
                LOGGER.debug("inicio envio "+asunto+" | "+identificador);
                Session mailSessionLocal = Session.getInstance(propertiesLocalMail, null);
                Message correoLocal = new MimeMessage(mailSessionLocal);
                correoLocal.setSubject(asunto);
                correoLocal.setSentDate(new Date());
                correoLocal.setFrom(new InternetAddress(propertiesLocalMail.getProperty("mail.user"),asunto));
                correoLocal.addRecipients(Message.RecipientType.TO,correoDestinoList.toArray(new InternetAddress[correoDestinoList.size()]));
                correoLocal.addRecipients(Message.RecipientType.CC,correoCopiaList.toArray(new InternetAddress[correoCopiaList.size()]));
                correoLocal.setContent(contenidoCorreo);
                System.setProperty("java.net.preferIPv4Stack" , "true");
                javax.mail.Transport.send(correoLocal);
                LOGGER.debug("termino envio "+asunto+" | "+identificador);
            }
            catch(MessagingException ex)
            {
                LOGGER.warn("error", ex);
                LOGGER.debug("enviado por correo alternativo "+asunto+" | "+identificador);
                Session mailSessionGmail = Session.getInstance(propertiesGmail,
                    new javax.mail.Authenticator() {
                          protected PasswordAuthentication getPasswordAuthentication() {
                                  return new PasswordAuthentication(propertiesGmail.getProperty("mail.user"), propertiesGmail.getProperty("mail.password"));
                          }
                    });
                Message correoGmail = new MimeMessage(mailSessionGmail);
                correoGmail.setSubject(asunto);
                correoGmail.setFrom(new InternetAddress(propertiesLocalMail.getProperty("mail.user"),asunto));
                correoGmail.addRecipients(Message.RecipientType.TO,correoDestinoList.toArray(new InternetAddress[correoDestinoList.size()]));
                correoGmail.addRecipients(Message.RecipientType.CC,correoCopiaList.toArray(new InternetAddress[correoCopiaList.size()]));
                correoGmail.setContent(contenidoCorreo);
                System.setProperty("java.net.preferIPv4Stack" , "true");
                javax.mail.Transport.send(correoGmail);
                LOGGER.debug("termino envio por correo alternativo "+asunto+" | "+identificador);
            }
        }
        
    }
    
}
