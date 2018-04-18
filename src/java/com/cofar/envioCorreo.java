/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar;
import com.cofar.bean.util.correos.EnvioCorreoLiberacionLotes;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.DriverManager;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import javax.faces.context.FacesContext;
import javax.mail.BodyPart;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import net.sf.jasperreports.engine.JRExporterParameter;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.export.JRXlsExporter;
import net.sf.jasperreports.engine.export.ooxml.JRXlsxExporter;

/**
 *
 * @author DASISAQ-
 */
public class envioCorreo {

    public static void main(String[] args) throws MessagingException {
System.setProperty("java.net.preferIPv4Stack" , "true");
        try {
             Connection con=null;
             Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
             String url="jdbc:sqlserver://172.16.10.228;user=sa;password=m0t1t4s@2009;databaseName=SARTORIUS20160105";
             
             Properties props = new Properties();
             props.put("mail.smtp.host", "host2.cofar.com.bo");
             props.put("mail.transport.protocol", "smtp");
             props.put("mail.smtp.auth", "false");
             props.setProperty("mail.user", "controlDeCambios@cofar.com.bo");
             props.setProperty("mail.password", "105021ej");
                     Session mailSession = Session.getInstance(props, null);
                     Message msg = new MimeMessage(mailSession);
                     String asunto=("Notificación de creación de versión");
                     msg.setSubject(asunto);
                     
                     
                     List<String> correosPersonal=new ArrayList<String>();
                     correosPersonal.add("aquispe@cofar.com.bo");
                     correosPersonal.add("aquispe@cofar.com.bo");
                     correosPersonal.add("aquispe@cofar.com.bo");
                     msg.setFrom(new InternetAddress("controlDeCambios@cofar.com.bo", "Registro de Nueva Versión"));
                     InternetAddress emails[] = new InternetAddress[1];
                     for(String a:correosPersonal)
                     {
                         
                         emails[0]=new InternetAddress(a);
                         msg.setRecipient(Message.RecipientType.TO, new InternetAddress(a));
                         StringBuilder correoPersona=new StringBuilder("prueba");
                         System.out.println("enviando correo a "+a);
                         msg.setContent(correoPersona.toString(), "text/html");
                         javax.mail.Transport.send(msg);
                     }
        }
        catch(Exception ex)
        {
            ex.printStackTrace();
        }

    }
}
