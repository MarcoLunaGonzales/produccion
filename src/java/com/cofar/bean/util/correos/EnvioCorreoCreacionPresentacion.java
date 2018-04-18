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
public class EnvioCorreoCreacionPresentacion extends EnvioCorreo 
{
    private int codPresentacion;
    
    public EnvioCorreoCreacionPresentacion(int codPresentacion) {
        super("Registro de presentación ",LogManager.getRootLogger(),"registro de presentacion : "+codPresentacion);
        this.codPresentacion = codPresentacion;
    }
    
    @Override
    public void run() 
    {
        try 
        {
            Connection con=null;
            con=Util.openConnection(con);
            
            SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy HH:mm");
            mensajeCorreo = new StringBuilder("<br/>");
                        mensajeCorreo.append("Estimad@ : <br><br>");
                        mensajeCorreo.append("Se comunica el registro de una presentación con los siguientes datos :");
                        mensajeCorreo.append("<br><br>");
                        mensajeCorreo.append("<table style='margin-left:2em'>");
                        //<editor-fold desc="formacion de cuerpo" defaultstate="collapsed">
                            StringBuilder consulta=new StringBuilder("select pp.NOMBRE_PRODUCTO_PRESENTACION,p.nombre_prod,tm.nombre_tipomercaderia,pp.cantidad_presentacion,")
                                                                    .append(" lmkt.NOMBRE_LINEAMKT,cp.NOMBRE_CATEGORIA,es.NOMBRE_ENVASESEC,e.NOMBRE_ESTADO_PRESENTACION_PRODUCTO")
                                                            .append(" from PRESENTACIONES_PRODUCTO pp")
                                                                    .append(" left outer join productos p on p.cod_prod = pp.cod_prod")
                                                                    .append(" left outer join lineas_mkt lmkt on lmkt.COD_LINEAMKT = pp.COD_LINEAMKT")
                                                                    .append(" left outer join TIPOS_MERCADERIA tm on tm.cod_tipomercaderia = pp.cod_tipomercaderia")
                                                                    .append(" left outer join CARTONES_CORRUGADOS c on c.COD_CARTON = pp.COD_CARTON")
                                                                    .append(" left outer join ESTADOS_PRESENTACIONES_PRODUCTO e on e.COD_ESTADO_PRESENTACION_PRODUCTO = pp.cod_estado_registro")
                                                                    .append(" left outer join tipos_programa_produccion tppr on tppr.cod_tipo_programa_prod = pp.cod_tipo_programa_prod")
                                                                    .append(" left outer join ENVASES_SECUNDARIOS es on es.COD_ENVASESEC = pp.COD_ENVASESEC")
                                                                    .append(" left outer join CATEGORIAS_PRODUCTO cp on cp.COD_CATEGORIA = pp.COD_CATEGORIA")
                                                            .append(" where pp.cod_presentacion =").append(codPresentacion);
                            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                            ResultSet res=st.executeQuery(consulta.toString());
                            if(res.next())
                            {
                                mensajeCorreo.append("<tr><td class='detalle' colspan='3' bgcolor='#75327c'>DATOS DE PRESENTACIÓN</td></tr>");
                                mensajeCorreo.append("<tr><td><b>Nombre Presentación</b></td><td><b>::</b></td><td>").append(res.getString("NOMBRE_PRODUCTO_PRESENTACION")).append("</td></tr>");
                                mensajeCorreo.append("<tr><td><b>Nombre Comercial</b></td><td><b>::</b></td><td>").append(res.getString("nombre_prod")).append("</td></tr>");
                                mensajeCorreo.append("<tr><td><b>Tipo de Mercaderia</b></td><td><b>::</b></td><td>").append(res.getString("nombre_tipomercaderia")).append("</td></tr>");
                                mensajeCorreo.append("<tr><td><b>Cantidad por Presentación</b></td><td><b>::</b></td><td>").append(res.getInt("cantidad_presentacion")).append("</td></tr>");
                                mensajeCorreo.append("<tr><td><b>Linea</b></td><td><b>::</b></td><td>").append(res.getString("NOMBRE_LINEAMKT")).append("</td></tr>");
                                mensajeCorreo.append("<tr><td><b>Categoria</b></td><td><b>::</b></td><td>").append(res.getString("NOMBRE_CATEGORIA")).append("</td></tr>");
                                mensajeCorreo.append("<tr><td><b>Envase Secundario</b></td><td><b>::</b></td><td>").append(res.getString("NOMBRE_ENVASESEC")).append("</td></tr>");
                                mensajeCorreo.append("<tr><td><b>Estado</b></td><td><b>::</b></td><td>").append(res.getString("NOMBRE_ESTADO_PRESENTACION_PRODUCTO")).append("</td></tr>");
                                

                            }
                        //</editor-fold>                     
                        mensajeCorreo.append("</table>");
                        mensajeCorreo.append("<br>");
                     LOGGER.debug("correo "+mensajeCorreo.toString());
            // <editor-fold defaultstate="collapsed" desc="destinatarios">
                consulta=new StringBuilder("select distinct cp.nombre_correopersonal");
                            consulta.append(" from CONFIGURACION_ENVIO_CORREO_ATLAS c ");
                                    consulta.append(" inner join correo_personal cp on cp.COD_PERSONAL=c.COD_PERSONAL");
                            consulta.append(" where c.COD_MOTIVO_ENVIO_CORREO_PERSONAL=37");
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
