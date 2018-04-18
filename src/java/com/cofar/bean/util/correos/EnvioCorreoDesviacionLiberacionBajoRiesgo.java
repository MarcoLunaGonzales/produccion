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
import java.util.logging.Level;
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
public class EnvioCorreoDesviacionLiberacionBajoRiesgo extends EnvioCorreo 
{
    private int codDesviacion;
    private ServletContext servletContext;
    
    public EnvioCorreoDesviacionLiberacionBajoRiesgo(int codDesviacion, ServletContext servletContext) {
        super("Desviacion por liberacion bajo riesgo",LogManager.getRootLogger(),"desviacion liberacion cod:"+codDesviacion);
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
                String direccionJasper = servletContext.getRealPath("/desviacion/reporteDesviacion.jasper");
                this.crearAdjuntoJasperPdf(direccionJasper, parameters, con,"desviacion"+this.codDesviacion);
            //</editor-fold>
                
            
            SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy HH:mm");
            mensajeCorreo = new StringBuilder("<br/>");
                        mensajeCorreo.append("Estimad@:<br><br>");
                        mensajeCorreo.append("Se comunica la generación de una desviacion por liberación bajo riesgo, los datos del mismo son los siguientes:");
                        mensajeCorreo.append("<br><br>");
                        mensajeCorreo.append("<table style='margin-left:2em'>");
                        //<editor-fold desc="formacion de cuerpo" defaultstate="collapsed">
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
                            if(res.next())
                            {
                                mensajeCorreo.append("<tr><td class='detalle' colspan='3' bgcolor='#75327c'>DATOS DE DESVIACION</td></tr>");
                                mensajeCorreo.append("<tr><td><b>Lote</b></td><td><b>::</b></td><td>").append(res.getString("COD_LOTE_PRODUCCION")).append("</td></tr>");
                                mensajeCorreo.append("<tr><td><b>Descripción</b></td><td><b>::</b></td><td>").append(res.getString("DESCRIPCION_DESVIACION")).append("</td></tr>");

                            }
                        //</editor-fold>                     
                        mensajeCorreo.append("</table>");
                        mensajeCorreo.append("<br>");
                     LOGGER.debug("correo "+mensajeCorreo.toString());
            // <editor-fold defaultstate="collapsed" desc="destinatarios">
                consulta=new StringBuilder("select distinct cp.nombre_correopersonal");
                            consulta.append(" from CONFIGURACION_ENVIO_CORREO_ATLAS c ");
                                    consulta.append(" inner join correo_personal cp on cp.COD_PERSONAL=c.COD_PERSONAL");
                            consulta.append(" where c.COD_MOTIVO_ENVIO_CORREO_PERSONAL=36");
                LOGGER.debug("consulta destinatarios cc asignacion revision "+consulta.toString());
                res=st.executeQuery(consulta.toString());
                while(res.next())
                {
                    LOGGER.info("destinario: "+res.getString("nombre_correopersonal"));
                    correoDestinoList.add(new InternetAddress(res.getString("nombre_correopersonal")));
                }
            //</editor-fold>
            
            con.close();
            this.enviarCorreo();
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
        } catch (Exception ex) {
            LOGGER.warn("error", ex);
        }
    }

}
