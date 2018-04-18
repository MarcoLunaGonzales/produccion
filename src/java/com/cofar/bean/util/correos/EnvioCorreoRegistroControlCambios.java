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
import javax.faces.context.FacesContext;
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
public class EnvioCorreoRegistroControlCambios extends Thread {
    private static Logger LOGGER=LogManager.getRootLogger();
    private int codRegistroControlCambios=0;
    private ServletContext servletContext;

    public EnvioCorreoRegistroControlCambios(int codRegistroControlCambios,ServletContext servletContext) {
        this.codRegistroControlCambios=codRegistroControlCambios;
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
                                                            correoPersonal.append("<span class='evento'>Motivo:<b>Registro de Control de Cambios</b></span>");
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
                                                correoPersonal.append("Se comunica que se creo un registro de control de cambios.<br><br>Los datos son:");
                                                correoPersonal.append("<br><br>");
                                                
                                                    // <editor-fold defaultstate="collapsed" desc="generando datos del lote">
                                                        correoPersonal.append("<table style='margin-left:4em'>");
                                                        StringBuilder consulta=new StringBuilder(" select cpv.nombre_prod_semiterminado,(p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL+' '+p.nombre2_personal) as nombrePersonal");
                                                                                        consulta.append(" from REGISTRO_CONTROL_CAMBIOS rcc ");
                                                                                                consulta.append(" left outer join COMPONENTES_PROD_VERSION cpv on cpv.COD_VERSION=rcc.COD_VERSION_PROD");
                                                                                                        consulta.append(" and cpv.COD_COMPPROD=rcc.COD_COMPPROD");
                                                                                                consulta.append(" inner join personal p on p.COD_PERSONAL=rcc.COD_PERSONAL_REGISTRA");
                                                                                    consulta.append(" where rcc.COD_REGISTRO_CONTROL_CAMBIOS=").append(codRegistroControlCambios);
                                                        res=st.executeQuery(consulta.toString());
                                                        if(res.next())
                                                        {
                                                            correoPersonal.append("<tr><td><b>Producto:</b></td><td><b>::</b></td><td>").append(res.getString("nombre_prod_semiterminado")).append("</td></tr>");
                                                            correoPersonal.append("<tr><td><b>Persona Registra:</b></td><td><b>::</b></td><td>").append(res.getString("nombrePersonal")).append("</td></tr>");                                                        
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
                    String asunto=("Registro de Control de Cambios");
                    msg.setSubject("Registro de Control de Cambios");
                    msg.setFrom(new InternetAddress("controlDeCambios@cofar.com.bo", "ATLAS"));
                    
                    consulta=new StringBuilder("select cp.nombre_correopersonal");
                             consulta.append(" from CONFIGURACION_ENVIO_CORREO_ATLAS cec");
                             consulta.append(" inner join correo_personal cp on cec.COD_PERSONAL=cp.COD_PERSONAL");
                             consulta.append(" where cec.COD_MOTIVO_ENVIO_CORREO_PERSONAL=5");
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
                            parameters.put("codRegistroControlCambios",this.codRegistroControlCambios);
                            JasperPrint jasperPrint=JasperFillManager.fillReport(servletContext.getRealPath("/controlDeCambios/reporteControlCambios.jasper"), parameters, con);
                            BodyPart adjunto = new MimeBodyPart();
                            File ftemp=File.createTempFile("registroControlCambios", ".pdf");
                            FileOutputStream fileOuputStream = new FileOutputStream(ftemp); 
                            fileOuputStream.write(JasperExportManager.exportReportToPdf(jasperPrint));
                            fileOuputStream.close();
                            adjunto.setDataHandler(new DataHandler(new FileDataSource(ftemp)));
                            adjunto.setFileName("registroControlCambios.pdf");

                        //</editor-fold>
                        LOGGER.debug("inicio envio correo notificacion registro control cambios");
                        msg.addRecipients(Message.RecipientType.TO,correos.toArray(new InternetAddress[correos.size()]));
                        BodyPart mensaje = new MimeBodyPart();
                        mensaje.setContent(correoPersonal.toString(),"text/html");
                        MimeMultipart multiParte = new MimeMultipart();
                        multiParte.addBodyPart(adjunto);
                        multiParte.addBodyPart(mensaje);
                        msg.setContent(multiParte);
                        
                        System.setProperty("java.net.preferIPv4Stack" , "true");
                        javax.mail.Transport.send(msg);
                        LOGGER.info("termino envio de correo registor control cambios");
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
