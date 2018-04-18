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
 * @author DASISAQ
 * Envio de correo al momento de la aprobacion de version de un producto por D.T.
 */
public class EnviarCorreoAprobacionVersion extends Thread{

    private static Logger LOGGER=LogManager.getRootLogger();
    private int codVersion;
    private String codCompProd;
    private ServletContext servletContext;

    public EnviarCorreoAprobacionVersion(int codVersion,String codCompProd,ServletContext servletContext) {
        this.codVersion = codVersion;
        this.codCompProd=codCompProd;
        this.servletContext=servletContext;
        LOGGER=LogManager.getLogger("EnvioCorreo");
    }
    
    
    @Override
    public void run() 
    {
        try 
        {
            Connection con=null;
            con=Util.openConnection(con);
            StringBuilder consulta;
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res;
            //<editor-fold desc="generando anexo pdf" defaultstate="collapsed">
                Map parameters = new HashMap();
                parameters.put("codVersion",this.codVersion);
                parameters.put("codCompProd",Integer.valueOf(this.codCompProd));
                JasperPrint jasperPrint=JasperFillManager.fillReport(servletContext.getRealPath("/componentesProdVersion/jasper/reporteComparacionVersion.jasper"), parameters, con);
                BodyPart adjunto = new MimeBodyPart();
                File ftemp=File.createTempFile("cambiosVersion", ".pdf");
                FileOutputStream fileOuputStream = new FileOutputStream(ftemp); 
                fileOuputStream.write(JasperExportManager.exportReportToPdf(jasperPrint));
                fileOuputStream.close();
                adjunto.setDataHandler(new DataHandler(new FileDataSource(ftemp)));
                adjunto.setFileName("cambiosVersion.pdf");
            //</editor-fold>
            // <editor-fold defaultstate="collapsed" desc="generando anexo de empaque secundario">
                parameters = new HashMap();
                consulta=new StringBuilder("select fmes.COD_FORMULA_MAESTRA_ES_VERSION");
                            consulta.append(" from FORMULA_MAESTRA_ES_VERSION fmes");
                            consulta.append(" where fmes.COD_VERSION=").append(codVersion);
                LOGGER.debug("consulta obtener codigo formula maestra es version "+consulta.toString());
                res=st.executeQuery(consulta.toString());
                if(res.next()){
                    parameters.put("codFormulaMaestraEsVersion",res.getInt("COD_FORMULA_MAESTRA_ES_VERSION"));
                }
                jasperPrint=JasperFillManager.fillReport(servletContext.getRealPath("/formullaMaestraVersiones/formulaMaestraDetalleES/empaqueSecundarioJasper/reporteComparacionVersionEmpaqueSecundario.jasper"), parameters, con);
                File ftempEs=File.createTempFile("cambiosEsVersion", ".pdf");
                fileOuputStream = new FileOutputStream(ftempEs); 
                fileOuputStream.write(JasperExportManager.exportReportToPdf(jasperPrint));
                fileOuputStream.close();
                BodyPart adjuntoEs = new MimeBodyPart();
                adjuntoEs.setDataHandler(new DataHandler(new FileDataSource(ftempEs)));
                adjuntoEs.setFileName("cambiosVersionEs.pdf");
            //</editor-fold>
            
            String asunto="Aprobación de nueva versión de producto";
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
                                                            correoPersonal.append("<span class='evento'>Motivo:<b>").append(asunto).append("</b></span>");
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
                                                correoPersonal.append("Se aprobó el versionamiento de un producto, los datos del mismo son los siguientes:");
                                                correoPersonal.append("<br><br>");
                                                sdf=new SimpleDateFormat("dd/MM/yyyy HH:mm");
                                                    // <editor-fold defaultstate="collapsed" desc="generando datos del lote">
                                                        correoPersonal.append("<table style='margin-left:4em'>");
                                                        consulta=new StringBuilder("select c.nombre_prod_semiterminado,c.TAMANIO_LOTE_PRODUCCION,c.FECHA_MODIFICACION");
                                                                    consulta.append(" from COMPONENTES_PROD_VERSION c ");
                                                                    consulta.append(" where c.COD_VERSION=").append(this.codVersion);
                                                        res=st.executeQuery(consulta.toString());
                                                        if(res.next())
                                                        {
                                                            correoPersonal.append("<tr><td><b>Producto:</b></td><td><b>::</b></td><td>").append(res.getString("nombre_prod_semiterminado")).append("</td></tr>");
                                                            correoPersonal.append("<tr><td><b>Tamaño Lote:</b></td><td><b>::</b></td><td>").append(res.getDouble("TAMANIO_LOTE_PRODUCCION")).append("</td></tr>");
                                                            correoPersonal.append("<tr><td><b>Fecha Creación:</b></td><td><b>::</b></td><td>").append(sdf.format(res.getTimestamp("FECHA_MODIFICACION"))).append("</td></tr>");
                                                        }
                                                        correoPersonal.append("</table><br>");
                                                        
                                                    //</editor-fold>
                                                
                                            correoPersonal.append("</div>");
                                            correoPersonal.append(" Para mas información de los cambios realizados revise los archivos adjuntos.");
                                            correoPersonal.append("<br/>");
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
            
            LOGGER.info(correoPersonal.toString());
            System.setProperty("java.net.preferIPv4Stack" , "true");
            Properties props = new Properties();
            props.put("mail.smtp.host", "host2.cofar.com.bo");
            props.put("mail.transport.protocol", "smtp");
            props.put("mail.smtp.auth", "false");
            props.setProperty("mail.user", "controlDeCambios@cofar.com.bo");
            props.setProperty("mail.password", "105021ej");

            Session mailSession = Session.getInstance(props, null);
            Message msg = new MimeMessage(mailSession);
            
            msg.setSubject(asunto);
            msg.setFrom(new InternetAddress("controlDeCambios@cofar.com.bo",asunto));
            consulta=new StringBuilder("SELECT distinct cp.nombre_correopersonal");
                        consulta.append(" FROM CONFIGURACION_ENVIO_CORREO_ATLAS ceca ");
                                consulta.append(" inner join correo_personal cp on cp.COD_PERSONAL=ceca.COD_PERSONAL");
                        consulta.append(" where ceca.COD_MOTIVO_ENVIO_CORREO_PERSONAL=33");
            LOGGER.debug("consulta cargar personal envio correo "+consulta.toString());
            List<InternetAddress> correosPersonal=new ArrayList<InternetAddress>();
            res=st.executeQuery(consulta.toString());
            while(res.next())
            {
                LOGGER.info("destinatario: "+res.getString("nombre_correopersonal"));
                correosPersonal.add(new InternetAddress(res.getString("nombre_correopersonal")));
            }
            st.close();
            con.close();
            if(correosPersonal.size()>0)
            {
                LOGGER.debug("inicio envio correo "+asunto);
                msg.addRecipients(Message.RecipientType.TO,correosPersonal.toArray(new InternetAddress[correosPersonal.size()]));
                BodyPart mensaje = new MimeBodyPart();
                mensaje.setContent(correoPersonal.toString(),"text/html");
                MimeMultipart multiParte = new MimeMultipart();
                multiParte.addBodyPart(adjunto);
                multiParte.addBodyPart(adjuntoEs);
                multiParte.addBodyPart(mensaje);
                msg.setContent(multiParte);

                System.setProperty("java.net.preferIPv4Stack" , "true");
                javax.mail.Transport.send(msg);
                LOGGER.debug("termino envio correo "+asunto);
            }
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
