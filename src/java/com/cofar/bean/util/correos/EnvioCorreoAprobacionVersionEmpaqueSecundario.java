/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.bean.util.correos;

import com.cofar.util.Util;
import java.io.File;
import java.io.FileOutputStream;
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
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;


/**
 *
 * @author DASISAQ-
 */
public class EnvioCorreoAprobacionVersionEmpaqueSecundario extends Thread {
    private static Logger LOGGER=LogManager.getRootLogger();
    private int codFormulaMaestraEsVersion=0;
    private ServletContext servletContext;

    public EnvioCorreoAprobacionVersionEmpaqueSecundario(int codFormulaMaestraEsVersion,ServletContext servletContext) {
        this.codFormulaMaestraEsVersion=codFormulaMaestraEsVersion;
        this.servletContext=servletContext;
    }
    
    @Override
    public void run() 
    {
        Connection con=null;
        try 
        {
            
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res;
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
                                                correoPersonal.append(" .tablaDetalle{font-size:14px;}");
                                                correoPersonal.append(" .tablaDetalle thead tr td{background-color:#75327c;color:white;font-weight:bold;}");
                                                correoPersonal.append(" .tablaDetalle tr td{border:1px solid #bbbbbb;}");
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
                                                            correoPersonal.append("<span class='evento'>Motivo:<b>Aprobación de Cambio de Empaque Secundario</b></span>");
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
                                                correoPersonal.append("Estimad@ Usuari@:<br><br>");
                                                correoPersonal.append("Se comunica que se realizó la aprobación de modificaciones en empaque secundario para un producto.<br><br>Los datos son:");
                                                correoPersonal.append("<br><br>");
                                                
                                                    // <editor-fold defaultstate="collapsed" desc="generando datos del lote">
                                                        correoPersonal.append("<table style='margin-left:4em'>");
                                                        StringBuilder consulta=new StringBuilder("select p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL+' '+p.nombre2_personal as nombresPersonal,");
                                                                                        consulta.append(" cpv.nombre_prod_semiterminado,cpv.TAMANIO_LOTE_PRODUCCION,fmev.FECHA_CREACION,fmev.FECHA_ENVIO_APROBACION,fmev.FECHA_APROBACION,");
                                                                                        consulta.append(" fmev.OBSERVACION");
                                                                                consulta.append(" from FORMULA_MAESTRA_ES_VERSION fmev");
                                                                                        consulta.append(" inner join COMPONENTES_PROD_VERSION cpv on cpv.COD_VERSION=fmev.COD_VERSION");
                                                                                        consulta.append(" inner join PERSONAL p on p.COD_PERSONAL=fmev.COD_PERSONAL");
                                                                                consulta.append(" where fmev.COD_FORMULA_MAESTRA_ES_VERSION=").append(codFormulaMaestraEsVersion);
                                                        res=st.executeQuery(consulta.toString());
                                                        if(res.next())
                                                        {
                                                            correoPersonal.append("<tr><td><b>Producto:</b></td><td><b>::</b></td><td>").append(res.getString("nombre_prod_semiterminado")).append("</td></tr>");
                                                            correoPersonal.append("<tr><td><b>Tamaño Lote Producción:</b></td><td><b>::</b></td><td>").append(res.getDouble("TAMANIO_LOTE_PRODUCCION")).append("</td></tr>");                                                        
                                                            correoPersonal.append("<tr><td><b>Persona Registra:</b></td><td><b>::</b></td><td>").append(res.getString("nombresPersonal")).append("</td></tr>");
                                                            correoPersonal.append("<tr><td><b>Fecha Creación:</b></td><td><b>::</b></td><td>").append(sdf.format(res.getTimestamp("FECHA_CREACION"))).append("</td></tr>");
                                                            correoPersonal.append("<tr><td><b>Fecha Envio Aprobación:</b></td><td><b>::</b></td><td>").append(sdf.format(res.getTimestamp("FECHA_ENVIO_APROBACION"))).append("</td></tr>");
                                                            correoPersonal.append("<tr><td><b>Fecha Aprobación/Inicio Vigencia:</b></td><td><b>::</b></td><td>").append(sdf.format(res.getTimestamp("FECHA_APROBACION"))).append("</td></tr>");
                                                            correoPersonal.append("<tr><td><b>Observación:</b></td><td><b>::</b></td><td>").append(res.getString("OBSERVACION")).append("</td></tr>");
                                                        }
                                                        correoPersonal.append("</table><br>");
                                                        
                                                    //</editor-fold>
                                                
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
                    String asunto=("Aprobación Modificaciones Empaque Secundario");
                    msg.setSubject("Aprobación Modificaciones Empaque Secundario");
                    msg.setFrom(new InternetAddress("controlDeCambios@cofar.com.bo", "ATLAS"));
                    
                    consulta=new StringBuilder("select cp.nombre_correopersonal");
                             consulta.append(" from CONFIGURACION_ENVIO_CORREO_ATLAS cec");
                                    consulta.append(" inner join correo_personal cp on cec.COD_PERSONAL=cp.COD_PERSONAL");
                             consulta.append(" where cec.COD_MOTIVO_ENVIO_CORREO_PERSONAL=6");
                             consulta.append(" order by cp.nombre_correopersonal");
                    res=st.executeQuery(consulta.toString());
                    List<InternetAddress> correos=new ArrayList<InternetAddress>();
                    while(res.next())
                    {
                        correos.add(new InternetAddress(res.getString("nombre_correopersonal")));
                    }
                    if(correos.size()>0)
                    {
                        //<editor-fold desc="recuperando pdf">
                            Map parameters = new HashMap();
                            parameters.put("codFormulaMaestraEsVersion",this.codFormulaMaestraEsVersion);
                            JasperPrint jasperPrint=JasperFillManager.fillReport(servletContext.getRealPath("/formullaMaestraVersiones/formulaMaestraDetalleES/empaqueSecundarioJasper/reporteComparacionVersionEmpaqueSecundario.jasper"), parameters, con);
                            BodyPart adjunto = new MimeBodyPart();
                            File ftemp=File.createTempFile("comparacionEs", ".pdf");
                            FileOutputStream fileOuputStream = new FileOutputStream(ftemp); 
                            fileOuputStream.write(JasperExportManager.exportReportToPdf(jasperPrint));
                            fileOuputStream.close();
                            adjunto.setDataHandler(new DataHandler(new FileDataSource(ftemp)));
                            adjunto.setFileName("comparacionEs.pdf");

                        //</editor-fold>
                        LOGGER.debug("inicio envio correo notificacion aprobacion formula maestra empaque secundario");
                        msg.addRecipients(Message.RecipientType.TO,correos.toArray(new InternetAddress[correos.size()]));
                        BodyPart mensaje = new MimeBodyPart();
                        mensaje.setContent(correoPersonal.toString(),"text/html");
                        MimeMultipart multiParte = new MimeMultipart();
                        multiParte.addBodyPart(adjunto);
                        multiParte.addBodyPart(mensaje);
                        msg.setContent(multiParte);
                        
                        System.setProperty("java.net.preferIPv4Stack" , "true");
                        javax.mail.Transport.send(msg);
                        LOGGER.debug("termino envio correo notificacion aprobacion formula maestra empaque secundario");
                    }
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
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
        finally
        {
            try
            {
                con.close();
            }
            catch(SQLException ex)
            {
                LOGGER.warn("error", ex);
            }
        }
    }

}
