/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean.util.correos;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Properties;
import java.util.TimerTask;
import javax.mail.Message;
import javax.mail.Session;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;


/**
 *
 * @author DASISAQ-
 */
public class EnvioCorreoVencimientoCertificados extends TimerTask {
    /** Creates a new instance of TareasZeus */
    Connection conexion;
    
    Connection con = null;


    public EnvioCorreoVencimientoCertificados(Connection connection) {
        con = connection ;
    }
    public void run() {
        
        while(true)
        {
            try
            {
               Date fechaActual=new Date();
                
               if(fechaActual.getDay()==5&&fechaActual.getHours()<13)
               {
                       SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");
                       SimpleDateFormat sdfLocal=new SimpleDateFormat("dd/MM/yyyy");


                        String consulta="set dateformat ymd;SELECT mp.NOMBRE_MARCA_PRODUCTO,DATEADD(YEAR,10,mp.FECHA_REGISTRO_MARCA) As FECHA_VENCIMIENTO,"+
                                        " mp.OBSERVACION,mp.RESOLUCION_RENOVACION FROM MARCAS_PRODUCTO mp"+
                                        " where mp.FECHA_REGISTRO_MARCA between DATEADD(YEAR,-10,'"+sdf.format(new Date())+" 00:00:00') and"+
                                        " DATEADD(MONTH,3,DATEADD(YEAR,-10,'"+sdf.format(new Date())+" 23:59:59'))"+
                                        " and mp.PRODUCTO_NO_RENOVACION<>1 and mp.COD_ESTADO_MARCA_PRODUCTO NOT IN(2,4) order by mp.NOMBRE_MARCA_PRODUCTO";
                                     System.out.println("consulta corre "+consulta);
                        Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                        ResultSet res=st.executeQuery(consulta);
                        String correo="";
                        while(res.next())
                        {
                            correo+=" <tr><td style='border-bottom:1px solid black;border-right:1px solid black;width:30%;padding:3px'><span >"+res.getString("NOMBRE_MARCA_PRODUCTO")+"</span></td>"+
                                    "<td style='border-bottom:1px solid black;border-right:1px solid black;width:30%;padding:3px'><span >"+sdfLocal.format(res.getTimestamp("FECHA_VENCIMIENTO"))+"</span></td>"+
                                    "<td style='border-bottom:1px solid black;border-right:1px solid black;width:30%;padding:3px'><span >"+res.getString("RESOLUCION_RENOVACION")+"</span></td>"+
                                    " <td style='border-bottom:1px solid black;padding:3px'><span >&nbsp;"+res.getString("OBSERVACION")+"</span></td></tr>";
                        }
                        if(!correo.equals(""))
                        {
                        correo="<html> <head>  <title></title><meta http-equiv='Content-Type' content='text/html; charset=windows-1252'> " +
                               "<style>span{font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 11px;}</style>"+
                               "</head><body><span>Las siguientes marcas estan proximas a vencer:</span><br><br><table style='width:90%;border-right: 1px solid black;border-left: 1px solid black;border-top: 1px solid black;' cellpadding='0' cellspacing='0'>"+
                              " <tr><td style='color:white;background-color:#9d5a9e;border-bottom:1px solid black;padding:3px;' colspan=4><center><span style='font-weight:bold'>MARCAS PROXIMAS A VENCIMIENTO(3 MESES)</span></center></td></tr>" +
                              " <tr><td style='color:white;background-color:#9d5a9e;border-bottom:1px solid black;border-right:1px solid black;padding:3px;' ><center><span style='font-weight:bold'>NOMBRE MARCA</span></center></td>"+
                             " <td style='color:white;background-color:#9d5a9e;border-bottom:1px solid black;border-right:1px solid black;padding:3px;' ><center><span style='font-weight:bold'>FECHA VENCIMIENTO</span></center></td>"+
                              " <td style='color:white;background-color:#9d5a9e;border-bottom:1px solid black;border-right:1px solid black;padding:3px;' ><center><span style='font-weight:bold'>RESOLUCION DE RENOVACION</span></center></td>"+
                             "  <td style='color:white;background-color:#9d5a9e;border-bottom:1px solid black;padding:3px;' ><center><span style='font-weight:bold'>OBSERVACION</span></center></td>"+
                              " </tr>"+correo+
                              "</table><center></body> </html>";
                         System.out.println("Marca proxima vencimiento "+correo);
                         InternetAddress emails[] = new InternetAddress[2];
                         emails[0]=new InternetAddress("aquispe@cofar.com.bo");
                         emails[1]=new InternetAddress("ctorrejon@cofar.com.bo");
                         Properties props = new Properties();
                         props.put("mail.smtp.host", "mail.cofar.com.bo");
                         props.put("mail.transport.protocol", "smtp");
                         props.put("mail.smtp.auth", "false");
                         props.setProperty("mail.user", "traspasos@cofar.com.bo");
                         props.setProperty("mail.password", "n3td4t4");
                         Session mailSession = Session.getInstance(props, null);
                         Message msg = new MimeMessage(mailSession);
                         String asunto="NOTIFICACION DE MARCAS PROXIMAS A VENCIMIENTO";
                         msg.setSubject(asunto);
                         msg.setFrom(new InternetAddress("traspasos@cofar.com.bo", ""));
                         msg.addRecipients(Message.RecipientType.TO, emails);
                         msg.setContent(correo, "text/html");
                         javax.mail.Transport.send(msg);


                        }
                  res.close();
                  st.close();
               }
                
            Thread.sleep((fechaActual.getHours()>12?12:24)*1000*60*60);
            }
            
            catch(Exception ex)
            {
                System.out.println("error envio correo");
                ex.printStackTrace();
            }
        }
    }

}
