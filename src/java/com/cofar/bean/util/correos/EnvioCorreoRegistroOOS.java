/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.bean.util.correos;

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
public class EnvioCorreoRegistroOOS extends Thread 
{
    private static Logger LOGGER=LogManager.getRootLogger();
    private int codRegistroOOS;
    
    public EnvioCorreoRegistroOOS(int codRegistroOOS)
    {
        this.codRegistroOOS=codRegistroOOS;
    }
    
    @Override
    public void run() 
    {
        LOGGER.info("entro envio correo oos "+codRegistroOOS);
        try {
            Connection con=null;
            con=Util.openConnection(con);
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
                                                            correoPersonal.append("<span class='evento'>Motivo:<b>Registro de nuevo OOS</b></span>");
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
                                                correoPersonal.append("Se comunica el registro de un OOS con los siguientes datos:");
                                                correoPersonal.append("<br><br>");
                                                correoPersonal.append("<table style='margin-left:4em'>");
                                                // <editor-fold defaultstate="collapsed" desc="datos cabecera">
                                                StringBuilder consulta=new StringBuilder("select pp.cod_lote_produccion,ro.CORRELATIVO_OOS,ro.FECHA_DETECCION,ro.FECHA_ENVIO_ASC,(p.AP_PATERNO_PERSONAL + ' ' + p.AP_MATERNO_PERSONAL + ' ' +p.NOMBRES_PERSONAL) as nombrePersonal,");
                                                                            consulta.append(" ro.COD_LOTE,cp.nombre_prod_semiterminado,ro.PROVEEDOR");
                                                                        consulta.append(" from REGISTRO_OOS ro");
                                                                            consulta.append(" inner join PROGRAMA_PRODUCCION pp on pp.COD_PROGRAMA_PROD =ro.COD_PROGRAMA_PROD and pp.COD_LOTE_PRODUCCION = ro.COD_LOTE");
                                                                            consulta.append(" inner join COMPONENTES_PROD cp on cp.COD_COMPPROD = pp.COD_COMPPROD");
                                                                            consulta.append(" left outer join personal p on p.COD_PERSONAL = ro.COD_PERSONAL_DETECTA");
                                                                        consulta.append(" where ro.COD_REGISTRO_OOS =").append(codRegistroOOS);
                                                Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                                ResultSet res=st.executeQuery(consulta.toString());
                                                res.next();
                                                    correoPersonal.append("<tr><td><b>N° Correlativo OOS</b></td><td><b>::</b></td><td>").append(res.getString("CORRELATIVO_OOS")).append("</td></tr>");
                                                    correoPersonal.append("<tr><td><b>Lote</b></td><td><b>::</b></td><td>").append(res.getString("cod_lote_produccion")).append("</td></tr>");
                                                    correoPersonal.append("<tr><td><b>Fecha Detección</b></td><td><b>::</b></td><td>").append(sdf.format(res.getTimestamp("FECHA_DETECCION"))).append("</td></tr>");
                                                    correoPersonal.append("<tr><td><b>Fecha Envio a Aseguramiento</b></td><td><b>::</b></td><td>").append(sdf.format(res.getTimestamp("FECHA_ENVIO_ASC"))).append("</td></tr>");
                                                    correoPersonal.append("<tr><td><b>Nombre de la personal que detecta el OOS</b></td><td><b>::</b></td><td>").append(res.getString("nombrePersonal")).append("</td></tr>");
                                                    correoPersonal.append("<tr><td><b>Material/Producto</b></td><td><b>::</b></td><td>").append(res.getString("nombre_prod_semiterminado")).append("</td></tr>");
                                                    correoPersonal.append("<tr><td><b>PROVEEDOR(Si Aplica)</b></td><td><b>::</b></td><td>").append(res.getString("PROVEEDOR")).append("</td></tr>");
                                                
                                            //</editor-fold>                                
                                                correoPersonal.append("</table>");
                                                correoPersonal.append("<br>");
                                                correoPersonal.append("Para poder ver el Registro de OOS generado haga click sobre el siguiente link:");
                                                correoPersonal.append("<a href=\"http://172.16.10.31:8080/PRODUCCION/controlCalidadOS/reporteOOSControlCalidad.jsf?codRegistroOOS=").append(codRegistroOOS).append("\">Registro OOS generado").append("</a>");
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
                    String asunto=("Registro de OOS");
                    msg.setSubject("Notificación de Registro de OOS");
                    msg.setFrom(new InternetAddress("controlDeCambios@cofar.com.bo", "Registro de OOS"));
                    List<InternetAddress> direcciones=new ArrayList<InternetAddress>();
                    consulta=new StringBuilder("SELECT CP.nombre_correopersonal");
                            consulta.append(" FROM CONFIGURACION_ENVIO_CORREO_ATLAS CE INNER JOIN correo_personal CP ON");
                            consulta.append(" CP.COD_PERSONAL=CE.COD_PERSONAL");
                            consulta.append(" WHERE CE.COD_MOTIVO_ENVIO_CORREO_PERSONAL=3");
                    res=st.executeQuery(consulta.toString());
                    while(res.next())
                    {
                        direcciones.add(new InternetAddress(res.getString("nombre_correopersonal")));
                    }
                    msg.addRecipients(Message.RecipientType.TO, direcciones.toArray(new InternetAddress[direcciones.size()]));
                    msg.setContent(correoPersonal.toString(), "text/html");
                    System.setProperty("java.net.preferIPv4Stack" , "true");
                    LOGGER.info("iniciando envio correo oos "+codRegistroOOS);
                    javax.mail.Transport.send(msg);
                    LOGGER.info("temrino envio correo oos "+codRegistroOOS);
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
        }
    }

}
