/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.bean.util.correos;

import com.cofar.util.Util;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
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
import javax.mail.Session;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.servlet.ServletContext;
import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JRExporterParameter;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.export.ooxml.JRXlsxExporter;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;


/**
 *
 * @author DASISAQ-
 */
public class EnvioCorreoDesviacionBajoRendimiento extends Thread 
{
    private static Logger LOGGER;
    private int codDesviacion;
    private ServletContext servletContext;
    
    public EnvioCorreoDesviacionBajoRendimiento(int codDesviacion, ServletContext servletContext) {
        LOGGER=LogManager.getRootLogger();
        this.codDesviacion = codDesviacion;
        this.servletContext = servletContext;
    }
    
    @Override
    public void run() 
    {
        try 
        {
            Connection con=null;
            con=Util.openConnection(con);
            //<editor-fold desc="generando anexo" defaultstate="collapsed">
                Map parameters = new HashMap();
                parameters.put("codDesviacion",this.codDesviacion);
                JasperPrint jasperPrint=JasperFillManager.fillReport(servletContext.getRealPath("/desviacion/reporteDesviacion.jasper"), parameters, con);
                LOGGER.debug(servletContext.getRealPath("/desviacion/reporteDesviacion.jasper"));
                BodyPart adjunto = new MimeBodyPart();
                File ftemp=File.createTempFile("desviacionBajoRendimiento", ".xlsx");
                FileOutputStream fileOuputStream = new FileOutputStream(ftemp); 
                JRXlsxExporter exporter=new JRXlsxExporter();
                exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
                exporter.setParameter(JRExporterParameter.OUTPUT_STREAM,fileOuputStream);
                exporter.exportReport();
                fileOuputStream.close();
                adjunto.setDataHandler(new DataHandler(new FileDataSource(ftemp)));
                adjunto.setFileName("desviacionBajoRendimiento"+this.codDesviacion+".xlsx");
            //</editor-fold>
            
            SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy HH:mm");
            StringBuilder correoPersonal=new StringBuilder("<html>");
                                        correoPersonal.append("<head>");
                                            correoPersonal.append("<style>");
                                                correoPersonal.append(".separador{width:100%;background-color:#75327c;font-size:3px;margin-top:3px;}");
                                                correoPersonal.append(".sistema{color:white;font-size:22px;font-style:italic;font-weight:bold;}");
                                                correoPersonal.append(".evento{color:white;font-size:14px;}");
                                                correoPersonal.append(".border{border: 1px solid #75327c}");
                                                correoPersonal.append(".detalle{color:white;font-size:15px;font-style:italic;font-weight:bold;}");
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
                                                            correoPersonal.append("<span class='evento'>Motivo:<b>Desviación por Rendimiento Fuera del Estandar</b></span>");
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
                                            correoPersonal.append("<div style='margin-left:15px'>");
                                                correoPersonal.append("<br>");
                                                correoPersonal.append("Estimad@:<br><br>");
                                                correoPersonal.append("Se comunica la generación  de una desviación por rendimiento fuera del estandar con los siguientes datos:");
                                                correoPersonal.append("<br><br>");
                                                correoPersonal.append("<table style='margin-left:2em'>");
                                                // <editor-fold defaultstate="collapsed" desc="datos cabecera">
                                                StringBuilder consulta=new StringBuilder("select dpp.COD_LOTE_PRODUCCION,d.DESCRIPCION_DESVIACION,cpv.COD_AREA_EMPRESA");
                                                                        consulta.append(" from DESVIACION d");
                                                                                consulta.append(" inner join DESVIACION_PROGRAMA_PRODUCCION dpp on dpp.COD_DESVIACION=d.COD_DESVIACION");
                                                                                consulta.append(" inner join PROGRAMA_PRODUCCION pp on pp.COD_PROGRAMA_PROD=dpp.COD_PROGRAMA_PROD");
                                                                                        consulta.append(" and pp.COD_LOTE_PRODUCCION=dpp.COD_LOTE_PRODUCCION");
                                                                                consulta.append(" inner join COMPONENTES_PROD_VERSION cpv on cpv.COD_COMPPROD=pp.COD_COMPPROD");
                                                                                        consulta.append(" and cpv.COD_VERSION=pp.COD_COMPPROD_VERSION");
                                                                        consulta.append(" where d.COD_DESVIACION=").append(codDesviacion);
                                                Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                                ResultSet res=st.executeQuery(consulta.toString());
                                                int codMotivoEnvioCorreo=0;
                                                if(res.next())
                                                {
                                                    correoPersonal.append("<tr><td class='detalle' colspan='3' bgcolor='#75327c'>DATOS DE DESVIACION</td></tr>");
                                                    correoPersonal.append("<tr><td><b>Lote</b></td><td><b>::</b></td><td>").append(res.getString("COD_LOTE_PRODUCCION")).append("</td></tr>");
                                                    correoPersonal.append("<tr><td><b>Descripción</b></td><td><b>::</b></td><td>").append(res.getString("DESCRIPCION_DESVIACION")).append("</td></tr>");
                                                    switch(res.getInt("COD_AREA_EMPRESA"))
                                                    {
                                                        case 80:
                                                        {
                                                            codMotivoEnvioCorreo=20;
                                                            break;
                                                        }
                                                        case 81:
                                                        {
                                                            codMotivoEnvioCorreo=21;
                                                            break;
                                                        }
                                                        case 92:
                                                        {
                                                            codMotivoEnvioCorreo=22;
                                                            break;
                                                        }
                                                        default:
                                                        {
                                                            codMotivoEnvioCorreo=23;
                                                            break;
                                                        }
                                                    }
                                                }
                                            //</editor-fold>                                
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
                     props.setProperty("mail.user", "traspasos@cofar.com.bo");
                     props.setProperty("mail.password", "n3td4t4");
                    
                    Session mailSession = Session.getInstance(props, null);
                    Message msg = new MimeMessage(mailSession);
                    String asunto=("Desviación Automatica Por Rendimiento Fuera del Estandar");
                    msg.setSubject("Desviación Automatica Por Rendimiento Fuera del Estandar");
                    msg.setFrom(new InternetAddress("traspasos@cofar.com.bo", "Desviación Automatica Por Rendimiento Fuera del Estandar"));
                    
                    consulta=new StringBuilder("select cp.nombre_correopersonal");
                             consulta.append(" from CONFIGURACION_ENVIO_CORREO_ATLAS cec");
                                    consulta.append(" inner join correo_personal cp on cec.COD_PERSONAL=cp.COD_PERSONAL");
                             consulta.append(" where cec.COD_MOTIVO_ENVIO_CORREO_PERSONAL=").append(codMotivoEnvioCorreo);
                             consulta.append(" order by cp.nombre_correopersonal");
                    LOGGER.debug("consulta correo envio "+consulta.toString());
                    res=st.executeQuery(consulta.toString());
                    List<InternetAddress> correos=new ArrayList<InternetAddress>();
                    while(res.next())
                    {
                        LOGGER.info("correo destino"+res.getString("nombre_correopersonal"));
                        correos.add(new InternetAddress(res.getString("nombre_correopersonal")));
                    }
                    if(correos.size()>0)
                    {
                        LOGGER.debug("inicio envio correo notificacion Desviación Automatica Por Rendimiento Fuera del Estandar "+codDesviacion);
                        msg.addRecipients(Message.RecipientType.TO,correos.toArray(new InternetAddress[correos.size()]));
                        BodyPart mensaje = new MimeBodyPart();
                        mensaje.setContent(correoPersonal.toString(),"text/html");
                        MimeMultipart multiParte = new MimeMultipart();
                        multiParte.addBodyPart(adjunto);
                        multiParte.addBodyPart(mensaje);
                        msg.setContent(multiParte);
                        System.setProperty("java.net.preferIPv4Stack" , "true");
                        javax.mail.Transport.send(msg);
                        LOGGER.debug("termino envio correo notificacion Desviación Automatica Por Rendimiento Fuera del Estandar "+codDesviacion);
                    }
                    con.close();
        }
        catch(SQLException ex)
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
        } catch (JRException ex) {
            LOGGER.warn("error", ex);
        } catch (IOException ex) {
            LOGGER.warn("error", ex);
        }
    }

}
