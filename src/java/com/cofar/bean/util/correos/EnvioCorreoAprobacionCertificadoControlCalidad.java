/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.bean.util.correos;

import com.cofar.bean.ResultadoAnalisis;
import com.cofar.util.Util;
import java.io.UnsupportedEncodingException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Properties;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;


/**
 *
 * @author DASISAQ-
 */
public class EnvioCorreoAprobacionCertificadoControlCalidad extends Thread {
    private static Logger LOGGER=LogManager.getRootLogger();
    private ResultadoAnalisis resultadoAnalisis;
    
    public EnvioCorreoAprobacionCertificadoControlCalidad(ResultadoAnalisis resultadoAnalisis)
    {
        this.resultadoAnalisis=resultadoAnalisis;
    }
    
    @Override
    public void run() 
    {
        try {
            
            SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy HH:mm");
            StringBuilder correoPersonal=new StringBuilder("<html>");
                                        correoPersonal.append("<head>");
                                            correoPersonal.append("<style>");
                                                correoPersonal.append(".separador{width:100%;background-color:#75327c;font-size:3px;margin-top:3px;}");
                                                correoPersonal.append(".sistema{color:white;font-size:22px;font-style:italic;font-weight:bold;}");
                                                correoPersonal.append(".evento{color:white;font-size:14px;}");
                                                correoPersonal.append("	body,table{font-family: Verdana, Arial, Helvetica, sans-serif;font-size:14px;}");
                                                correoPersonal.append("	td{padding:4px;}");
                                                correoPersonal.append("	.footer{font-size:10px;color:#aaaaaa;border:none !important;}");
                                                correoPersonal.append("	.footer tr td{border:1px solid #bbbbbb;}");
                                            correoPersonal.append("</style>");
                                        correoPersonal.append("</head>");
                                        correoPersonal.append("<body>");
                                            correoPersonal.append("<div>");
                                                correoPersonal.append("<table style='width:100%' cellpading='0' cellspacing='0'>");
                                                    correoPersonal.append("<tr bgcolor='#75327c'>");
                                                        correoPersonal.append("<td rowspan='2' style='border'>");
                                                            correoPersonal.append("<span class='sistema'>ATLAS</span>");
                                                        correoPersonal.append("</td>");
                                                        correoPersonal.append("<td style='text-align:right'>");
                                                            correoPersonal.append("<span class='evento'>Motivo:<b>Aprobación de certificado de control de calidad</b></span>");
                                                        correoPersonal.append("</td>");
                                                    correoPersonal.append("</tr>");
                                                    correoPersonal.append("<tr bgcolor='#75327c'>");
                                                        correoPersonal.append("<td style='text-align:right'>");
                                                            correoPersonal.append("<span class='evento'>Fecha Notificación:<b>").append(sdf.format(new Date())).append("</b></span>");
                                                        correoPersonal.append("</td>");
                                                    correoPersonal.append("</tr>");
                                                correoPersonal.append("</table>");
                                            correoPersonal.append("</div>");
                                            correoPersonal.append("<div class='separador'>&nbsp;</div>");
                                            sdf=new SimpleDateFormat("dd/MM/yyyy");
                                            correoPersonal.append("<div style='margin-left:15px'>");
                                                correoPersonal.append("<br>");
                                                correoPersonal.append("Estimad@:<br><br>");
                                                correoPersonal.append("Se comunica la aprobación del certificado de control de calidad con los siguientes datos:");
                                                correoPersonal.append("<br>");
                                                correoPersonal.append("<table style='margin-left:4em'>");
                                                    correoPersonal.append("<tr><td><b>Lote</b></td><td><b>::</b></td><td>").append(resultadoAnalisis.getCodLote()).append("</td></tr>");
                                                    correoPersonal.append("<tr><td><b>Producto</b></td><td><b>::</b></td><td>").append(resultadoAnalisis.getComponenteProd().getProducto().getNombreProducto()).append("</td></tr>");
                                                    correoPersonal.append("<tr><td><b>Nro. Analisis Químico</b></td><td><b>::</b></td><td>").append(resultadoAnalisis.getNroAnalisis()).append("</td></tr>");
                                                    correoPersonal.append("<tr><td><b>Nro. Analisis Microbiologico</b></td><td><b>::</b></td><td>").append(resultadoAnalisis.getNroAnalisisMicrobiologico()).append("</td></tr>");
                                                    correoPersonal.append("<tr><td><b>Fecha Emisión</b></td><td><b>::</b></td><td>").append(sdf.format(resultadoAnalisis.getFechaEmision())).append("</td></tr>");
                                                    correoPersonal.append("<tr><td><b>Fecha Revisión</b></td><td><b>::</b></td><td>").append(sdf.format(resultadoAnalisis.getFechaRevision())).append("</td></tr>");
                                                    correoPersonal.append("<tr><td><b>Personal Analista</b></td><td><b>::</b></td><td>").append(resultadoAnalisis.getPersonalAnalista().getNombrePersonal()).append("</td></tr>");
                                                correoPersonal.append("</table>");
                                                correoPersonal.append("<br>");
                                            correoPersonal.append("</div>");
                                            correoPersonal.append("<div align='left'>");
                                                correoPersonal.append("<table class='footer'>");
                                                    correoPersonal.append("<tr>");
                                                        correoPersonal.append("<td bgcolor='#bbbbbb' class='evento'>ATLAS</td>");
                                                        correoPersonal.append("<td >");
                                                        correoPersonal.append("El presente correo tiene carácter puramente informativo.<br>");
                                                        correoPersonal.append("No trate de responder al remitente.");
                                                        correoPersonal.append("</td>");
                                                    correoPersonal.append("</tr>");
                                                correoPersonal.append("<table>");
                                            correoPersonal.append("</div>");
                                        correoPersonal.append("</body>");
                                    correoPersonal.append("</html>");
                                    LOGGER.debug("correo "+correoPersonal.toString());
                     System.setProperty("java.net.preferIPv4Stack" , "true");
                     Properties props = new Properties();
                     props.put("mail.smtp.host", "host2.cofar.com.bo");
                     props.put("mail.transport.protocol", "smtp");
                     props.put("mail.smtp.auth", "false");
                     props.setProperty("mail.user", "controlDeCambios@cofar.com.bo");
                     props.setProperty("mail.password", "105021ej");
                    
                    Session mailSession = Session.getInstance(props, null);
                    Message msg = new MimeMessage(mailSession);
                    String asunto=("Aprobación de certificado de control de calidad ");
                    msg.setSubject("Noficación de aprobación de certificado de control de calidad, lote:"+resultadoAnalisis.getCodLote());
                    msg.setFrom(new InternetAddress("controlDeCambios@cofar.com.bo", "Noficación de aprobación de certificado de control de calidad, lote:"+resultadoAnalisis.getCodLote()));
                    InternetAddress emails[] = new InternetAddress[1];
                    emails[0]=new InternetAddress("cgarfias@cofar.com.bo");
                    msg.addRecipients(Message.RecipientType.TO, emails);
                    msg.setContent(correoPersonal.toString(), "text/html");
                    System.setProperty("java.net.preferIPv4Stack" , "true");
                    javax.mail.Transport.send(msg);
        }
        catch (MessagingException ex) 
        {
            LOGGER.warn("error", ex);
        } 
        catch (UnsupportedEncodingException ex) 
        {
            LOGGER.warn("error", ex);
        }
    }

}
