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
public class EnvioCorreoFechaPesajeFueraDePrograma extends Thread {
    private static Logger LOGGER=LogManager.getRootLogger();
    private String codLoteProduccion;
    private String codProgramaProd;
    private String codActividadFormulaMaestra;

    public EnvioCorreoFechaPesajeFueraDePrograma(String codLoteProduccion, String codProgramaProd, String codActividadFormulaMaestra) {
        this.codLoteProduccion = codLoteProduccion;
        this.codProgramaProd = codProgramaProd;
        this.codActividadFormulaMaestra = codActividadFormulaMaestra;
    }
    
    
    
    @Override
    public void run() 
    {
        try 
        {
            Connection con=null;
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
                                                            correoPersonal.append("<span class='evento'>Motivo:<b>Registro de fecha de pesaje fuera del intervalo de tiempo de Programa de Producción </b></span>");
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
                                                correoPersonal.append("Se comunica que existe un registro de fecha de pesaje fuera del intervalo del programa de producción.<br><br>Los datos son:");
                                                correoPersonal.append("<br><br>");
                                                
                                                    // <editor-fold defaultstate="collapsed" desc="generando datos del lote">
                                                        correoPersonal.append("<table style='margin-left:4em'>");
                                                    correoPersonal.append("<tr><td><b>Lote</b></td><td><b>::</b></td><td>").append(codLoteProduccion).append("</td></tr>");
                                                        StringBuilder consulta=new StringBuilder(" select sppp.COD_LOTE_PRODUCCION,isnull((p.AP_PATERNO_PERSONAL + ' ' + p.AP_MATERNO_PERSONAL + ' ' +p.NOMBRES_PERSONAL), (pt.AP_PATERNO_PERSONAL + ' ' +pt.AP_MATERNO_PERSONAL + ' ' + pt.NOMBRES_PERSONAL)) as nombrePersona,");
                                                                                    consulta.append(" ppp.NOMBRE_PROGRAMA_PROD,ppp.FECHA_INICIO as fechaInicioPrograma,ppp.FECHA_FINAL as fechaFinalPrograma,sppp.HORAS_HOMBRE,");
                                                                                    consulta.append(" sppp.FECHA_INICIO,sppp.FECHA_FINAL");
                                                                                consulta.append(" from PROGRAMA_PRODUCCION_PERIODO ppp");
                                                                                    consulta.append(" inner join SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sppp on sppp.COD_PROGRAMA_PROD = ppp.COD_PROGRAMA_PROD");
                                                                                    consulta.append(" inner join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_FORMULA_MAESTRA = sppp.COD_FORMULA_MAESTRA and afm.COD_ACTIVIDAD_FORMULA = sppp.COD_ACTIVIDAD_PROGRAMA and afm.COD_AREA_EMPRESA = 97");
                                                                                    consulta.append(" left outer join personal p on p.COD_PERSONAL = sppp.COD_PERSONAL");
                                                                                    consulta.append(" left outer join PERSONAL_TEMPORAL pt on pt.COD_PERSONAL = sppp.COD_PERSONAL");
                                                                                consulta.append(" where sppp.COD_PROGRAMA_PROD =").append(codProgramaProd);
                                                                                consulta.append(" and sppp.COD_LOTE_PRODUCCION = '").append(codLoteProduccion).append("'");
                                                                                consulta.append(" and afm.COD_ACTIVIDAD in (76, 186)");
                                                                                consulta.append(" order by sppp.FECHA_INICIO");
                                                        LOGGER.debug("consulta registro tiempos pesaje");
                                                        res=st.executeQuery(consulta.toString());
                                                        
                                                        if(res.next())
                                                        {
                                                            correoPersonal.append("<tr><td><b>Programa Producción</b></td><td><b>::</b></td><td>").append(res.getString("NOMBRE_PROGRAMA_PROD")).append("</td></tr>");
                                                            correoPersonal.append("<tr><td><b>Fecha Inicio</b></td><td><b>::</b></td><td>").append(sdf.format(res.getTimestamp("fechaInicioPrograma"))).append("</td></tr>");
                                                            correoPersonal.append("<tr><td><b>Fecha Final</b></td><td><b>::</b></td><td>").append(sdf.format(res.getTimestamp("fechaFinalPrograma"))).append("</td></tr>");
                                                            correoPersonal.append("</table><br>");
                                                            sdf=new SimpleDateFormat("dd/MM/yyyy HH:mm");
                                                            correoPersonal.append("<table class='tablaDetalle' cellpading='0' cellspacing='0'>");
                                                            correoPersonal.append("<thead>");
                                                                correoPersonal.append("<tr>");
                                                                    correoPersonal.append("<td>Personal</td>");
                                                                    correoPersonal.append("<td>Fecha Inicio</td>");
                                                                    correoPersonal.append("<td>Fecha Final</td>");
                                                                    correoPersonal.append("<td>Horas Hombre</td>");
                                                                correoPersonal.append("</tr>");
                                                            correoPersonal.append("</thead>");
                                                            correoPersonal.append("<tbody>");
                                                                correoPersonal.append("<tr>");
                                                                    correoPersonal.append("<td>").append(res.getString("nombrePersona")).append("</td>");
                                                                    correoPersonal.append("<td>").append(sdf.format(res.getTimestamp("FECHA_INICIO"))).append("</td>");
                                                                    correoPersonal.append("<td>").append(sdf.format(res.getTimestamp("FECHA_FINAL"))).append("</td>");
                                                                    correoPersonal.append("<td>").append(res.getDouble("HORAS_HOMBRE")).append("</td>");
                                                                correoPersonal.append("</tr>");
                                                        }
                                                        while(res.next())
                                                        {
                                                            correoPersonal.append("<tr>");
                                                                correoPersonal.append("<td>").append(res.getString("nombrePersona")).append("</td>");
                                                                correoPersonal.append("<td>").append(sdf.format(res.getTimestamp("FECHA_INICIO"))).append("</td>");
                                                                correoPersonal.append("<td>").append(sdf.format(res.getTimestamp("FECHA_FINAL"))).append("</td>");
                                                                correoPersonal.append("<td>").append(res.getDouble("HORAS_HOMBRE")).append("</td>");
                                                            correoPersonal.append("</tr>");
                                                        }
                                                            correoPersonal.append("</tbody>");
                                                        correoPersonal.append("</table>");
                                                    //</editor-fold>
                                                
                                                correoPersonal.append("<br>");
                                                correoPersonal.append("<b>Nota:</b> El registro de fechas fuera del intervalo de tiempo del programa de produccion no esta restringido, sin embargo el mismo afecta la fecha de vencimiento");
                                                correoPersonal.append("<br><br>");
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
                    String asunto=("Fecha de Pesaje Fuera de Programa de Producción ");
                    msg.setSubject(codLoteProduccion+": Fecha de Pesaje Fuera de Programa de Producción");
                    msg.setFrom(new InternetAddress("controlDeCambios@cofar.com.bo", "ATLAS"));
                    
                    consulta=new StringBuilder("select cp.nombre_correopersonal");
                             consulta.append(" from CONFIGURACION_ENVIO_CORREO_ATLAS cec");
                             consulta.append(" inner join correo_personal cp on cec.COD_PERSONAL=cp.COD_PERSONAL");
                             consulta.append(" where cec.COD_MOTIVO_ENVIO_CORREO_PERSONAL=2");
                             consulta.append(" order by cp.nombre_correopersonal");
                    res=st.executeQuery(consulta.toString());
                    List<InternetAddress> correos=new ArrayList<InternetAddress>();
                    while(res.next())
                    {
                        correos.add(new InternetAddress(res.getString("nombre_correopersonal")));
                    }
                    if(correos.size()>0)
                    {
                        LOGGER.debug("inicio envio correo notificacion fecha de pesaje");
                        msg.addRecipients(Message.RecipientType.TO,correos.toArray(new InternetAddress[correos.size()]));
                        msg.setContent(correoPersonal.toString(), "text/html");
                        System.setProperty("java.net.preferIPv4Stack" , "true");
                        javax.mail.Transport.send(msg);
                        LOGGER.info("termino envio de correo fecha de pesaje");
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
    }

}
