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
import net.sf.jasperreports.engine.JRExporterParameter;
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.export.ooxml.JRXlsxExporter;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;


/**
 *
 * @author DASISAQ-
 */
public class EnvioCorreoDesviacion extends Thread {
    private static Logger LOGGER=LogManager.getRootLogger();
    int codDesviacion;
    private ServletContext servletContext;
    public EnvioCorreoDesviacion(int codDesviacion,ServletContext servletContext) {
        this.servletContext=servletContext;
        this.codDesviacion=codDesviacion;
        LOGGER=LogManager.getLogger("EnvioCorreo");
    }
    @Override
    public void run() 
    {
        String codLoteProduccion="";
        try 
        {
            Connection con=null;
            con=Util.openConnection(con);
            MimeMultipart multiParte = new MimeMultipart();
            
            //<editor-fold desc="generando anexo xls" defaultstate="collapsed">
                Map parameters = new HashMap();
                parameters.put("codDesviacion",this.codDesviacion);
                JasperPrint jasperPrint=JasperFillManager.fillReport(servletContext.getRealPath("/desviacion/reporteDesviacion.jasper"), parameters, con);
                BodyPart adjunto = new MimeBodyPart();
                File ftemp=File.createTempFile("desviacionPlanificadaMateriales", ".pdf");
                FileOutputStream fileOuputStream = new FileOutputStream(ftemp); 
                fileOuputStream.write(JasperExportManager.exportReportToPdf(jasperPrint));
                fileOuputStream.close();
                adjunto.setDataHandler(new DataHandler(new FileDataSource(ftemp)));
                adjunto.setFileName("desviacionPlanificadaMateriales.pdf");
                multiParte.addBodyPart(adjunto);
                
            //</editor-fold>
            // <editor-fold defaultstate="collapsed" desc="adjuntando cambios por version">
                StringBuilder consulta = new StringBuilder(" select DISTINCT pp.COD_COMPPROD,pp.COD_COMPPROD_VERSION");
                                            consulta.append(" from DESVIACION d");
                                                    consulta.append(" inner join DESVIACION_PROGRAMA_PRODUCCION dpp on dpp.COD_DESVIACION=d.COD_DESVIACION");
                                                    consulta.append(" inner join PROGRAMA_PRODUCCION pp on pp.COD_LOTE_PRODUCCION=dpp.COD_LOTE_PRODUCCION");
                                                            consulta.append(" and pp.COD_PROGRAMA_PROD=dpp.COD_PROGRAMA_PROD");
                                            consulta.append(" where d.COD_DESVIACION=").append(codDesviacion);
                Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet res=st.executeQuery(consulta.toString());
                while(res.next())
                {
                    parameters = new HashMap();
                    parameters.put("codVersion",res.getInt("COD_COMPPROD_VERSION"));
                    parameters.put("codCompProd",res.getInt("COD_COMPPROD"));
                    jasperPrint=JasperFillManager.fillReport(servletContext.getRealPath("/componentesProdVersion/jasper/reporteComparacionVersion.jasper"), parameters, con);
                    BodyPart adjuntoVersionProducto = new MimeBodyPart();
                    File ftempVersion=File.createTempFile("CambiosProducto"+res.getInt("COD_COMPPROD_VERSION"), ".pdf");
                    FileOutputStream fileOuputStreamVersion = new FileOutputStream(ftempVersion); 
                    fileOuputStreamVersion.write(JasperExportManager.exportReportToPdf(jasperPrint));
                    fileOuputStreamVersion.close();
                    adjuntoVersionProducto.setDataHandler(new DataHandler(new FileDataSource(ftempVersion)));
                    adjuntoVersionProducto.setFileName("desviacionPlanificadaMateriales"+res.getInt("COD_COMPPROD_VERSION")+".pdf");
                    multiParte.addBodyPart(adjuntoVersionProducto);
                }
            //</editor-fold>
            
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
                                                            correoPersonal.append("<span class='evento'>Motivo:<b>Desviación Planificada</b></span>");
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
                                                correoPersonal.append("Se comunica la generación de una desviacion planificada con los siguientes datos:");
                                                correoPersonal.append("<br><br>");
                                                sdf=new SimpleDateFormat("dd/MM/yyyy HH:mm");
                                                    // <editor-fold defaultstate="collapsed" desc="generando datos del lote">
                                                        correoPersonal.append("<table style='margin-left:4em'>");
                                                        consulta=new StringBuilder("select top 1 ppp.NOMBRE_PROGRAMA_PROD,p.nombre_prod,pe.AP_PATERNO_PERSONAL+' '+pe.AP_MATERNO_PERSONAL+' '+pe.NOMBRES_PERSONAL as nombrePersonal,pp.COD_LOTE_PRODUCCION");
                                                                            consulta.append(" ,d.FECHA_DESVIACION");
                                                                    consulta.append(" from DESVIACION d");
                                                                            consulta.append(" inner join DESVIACION_PROGRAMA_PRODUCCION dpp on dpp.COD_DESVIACION=d.COD_DESVIACION");
                                                                            consulta.append(" inner join PROGRAMA_PRODUCCION pp on pp.COD_LOTE_PRODUCCION=dpp.COD_LOTE_PRODUCCION");
                                                                                    consulta.append(" and pp.COD_PROGRAMA_PROD=dpp.COD_PROGRAMA_PROD");
                                                                            consulta.append(" inner join PROGRAMA_PRODUCCION_PERIODO ppp on pp.COD_PROGRAMA_PROD=ppp.COD_PROGRAMA_PROD");
                                                                            consulta.append(" inner join COMPONENTES_PROD_VERSION cpv on cpv.COD_VERSION=pp.COD_COMPPROD_VERSION");
                                                                                    consulta.append(" and cpv.COD_COMPPROD=pp.COD_COMPPROD");
                                                                            consulta.append(" inner join PRODUCTOS p on p.cod_prod=cpv.COD_PROD");
                                                                            consulta.append(" left outer join PERSONAL pe on pe.COD_PERSONAL=d.COD_PERSONAL");
                                                                    consulta.append(" where d.COD_DESVIACION=").append(codDesviacion);
                                                        LOGGER.debug("consulta datos desviacion "+consulta.toString());
                                                        res=st.executeQuery(consulta.toString());
                                                        if(res.next())
                                                        {
                                                            codLoteProduccion=res.getString("COD_LOTE_PRODUCCION");
                                                            correoPersonal.append("<tr><td><b>Producto:</b></td><td><b>::</b></td><td>").append(res.getString("nombre_prod")).append("</td></tr>");
                                                            correoPersonal.append("<tr><td><b>Programa de Producción:</b></td><td><b>::</b></td><td>").append(res.getString("NOMBRE_PROGRAMA_PROD")).append("</td></tr>");
                                                            correoPersonal.append("<tr><td><b>Lote:</b></td><td><b>::</b></td><td>").append(res.getString("COD_LOTE_PRODUCCION")).append("</td></tr>");
                                                            correoPersonal.append("<tr><td><b>Fecha Creación:</b></td><td><b>::</b></td><td>").append(sdf.format(res.getTimestamp("FECHA_DESVIACION"))).append("</td></tr>");
                                                            correoPersonal.append("<tr><td><b>Personal que Registra:</b></td><td><b>::</b></td><td>").append(res.getString("nombrePersonal")).append("</td></tr>");
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
            String asunto=("Noficación de desviacion de material para el lote " +codLoteProduccion);
            msg.setSubject("Noficación de desviacion de material para el lote "+codLoteProduccion);
            msg.setFrom(new InternetAddress("controlDeCambios@cofar.com.bo", "Noficación de desviacion de material para el lote "+codLoteProduccion));
            consulta=new StringBuilder("SELECT cp.nombre_correopersonal");
                        consulta.append(" FROM CONFIGURACION_ENVIO_CORREO_ATLAS ceca ");
                                consulta.append(" inner join correo_personal cp on cp.COD_PERSONAL=ceca.COD_PERSONAL");
                        consulta.append(" where ceca.COD_MOTIVO_ENVIO_CORREO_PERSONAL=4");
            LOGGER.debug("consulta cargar personal envio correo "+consulta.toString());
            List<InternetAddress> correosPersonal=new ArrayList<InternetAddress>();
            res=st.executeQuery(consulta.toString());
            while(res.next())
            {
                correosPersonal.add(new InternetAddress(res.getString("nombre_correopersonal")));
            }
            
            st.close();
            con.close();
            if(correosPersonal.size()>0)
            {
                LOGGER.debug("inicio envio correo desviacion planificad mp,ep y es");
                msg.addRecipients(Message.RecipientType.TO,correosPersonal.toArray(new InternetAddress[correosPersonal.size()]));
                BodyPart mensaje = new MimeBodyPart();
                mensaje.setContent(correoPersonal.toString(),"text/html");
                multiParte.addBodyPart(mensaje);
                msg.setContent(multiParte);

                System.setProperty("java.net.preferIPv4Stack" , "true");
                javax.mail.Transport.send(msg);
                LOGGER.debug("termino envio correo desviacion planificad mp,ep y es");
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
