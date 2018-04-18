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
public class EnvioCorreoLiberacionLotes extends EnvioCorreo 
{
    private int codIngresoAlmacenLiberado;
    
    public EnvioCorreoLiberacionLotes(int codIngresoAlmacenLiberado)
    {
        super("Notificación de Liberación de Producto",LogManager.getLogger("LiberacionLotes"),"liberacion lote "+codIngresoAlmacenLiberado);
        LOGGER=LogManager.getLogger("LiberacionLotes");
        this.codIngresoAlmacenLiberado=codIngresoAlmacenLiberado;
    }
    
    @Override
    public void run() 
    {
        try {
            Connection con=null;
            con=Util.openConnection(con);
            SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy HH:mm");
            mensajeCorreo = new StringBuilder("<br>");
                                mensajeCorreo.append("Estimad@:<br><br>");
                                mensajeCorreo.append("Se comunica la liberación de producto con los siguientes datos :");
                                mensajeCorreo.append("<br><br>");
                                mensajeCorreo.append("<table style='margin-left:2em'>");
                                // <editor-fold defaultstate="collapsed" desc="datos cabecera">
                                StringBuilder consulta=new StringBuilder("select iv.NRO_INGRESOVENTAS,av.NOMBRE_ALMACEN_VENTA,iv1.NRO_INGRESOVENTAS AS NRO_INGRESOVENTASgenerado,av1.NOMBRE_ALMACEN_VENTA as NOMBRE_ALMACEN_VENTAgenerado,");
                                                                consulta.append(" (p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL) as personalAprueba,");
                                                                consulta.append(" pp.NOMBRE_PRODUCTO_PRESENTACION,idv.CANTIDAD_RESTANTE,idv.CANTIDAD_UNITARIARESTANTE,ll.FECHA_LIBERACION");
                                                                consulta.append(" ,idv.COD_LOTE_PRODUCCION,idv.FECHA_VENC,tll.NOMBRE_TIPO_LIBERACION_LOTE");
                                                        consulta.append(" from LIBERACION_LOTES ll");
                                                                consulta.append(" inner join PERSONAL p on p.COD_PERSONAL=ll.COD_PERSONAL");
                                                                consulta.append(" inner join INGRESOS_VENTAS iv on iv.COD_INGRESOVENTAS=ll.COD_INGRESOVENTAS");
                                                                        consulta.append(" and iv.COD_AREA_EMPRESA=1");
                                                                consulta.append(" inner join ALMACENES_VENTAS av on av.COD_ALMACEN_VENTA=iv.COD_ALMACEN_VENTA        ");
                                                                consulta.append(" inner join INGRESOS_VENTAS iv1 on iv1.COD_INGRESOVENTAS=ll.COD_INGRESOVENTAS_GENERADO");
                                                                        consulta.append(" and iv1.COD_AREA_EMPRESA=1");
                                                                consulta.append(" inner join ALMACENES_VENTAS av1 on av1.COD_ALMACEN_VENTA=iv1.COD_ALMACEN_VENTA");
                                                                consulta.append(" inner join INGRESOS_DETALLEVENTAS idv on idv.COD_INGRESOVENTAS=iv1.COD_INGRESOVENTAS");
                                                                        consulta.append(" and idv.COD_AREA_EMPRESA=iv1.COD_AREA_EMPRESA");
                                                                consulta.append(" inner join PRESENTACIONES_PRODUCTO pp on pp.cod_presentacion=idv.COD_PRESENTACION        ");
                                                                consulta.append(" inner join TIPOS_LIBERACION_LOTE tll on tll.COD_TIPO_LIBERACION_LOTE=ll.COD_TIPO_LIBERACION_LOTE");
                                                        consulta.append(" where ll.COD_INGRESOVENTAS=").append(codIngresoAlmacenLiberado);
                                Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                ResultSet res=st.executeQuery(consulta.toString());
                                res.next();
                                    mensajeCorreo.append("<tr><td class='detalle' colspan='3' bgcolor='#75327c'>LIBERACIÓN</td></tr>");
                                    mensajeCorreo.append("<tr><td><b>Persona que libera</b></td><td><b>::</b></td><td>").append(res.getString("personalAprueba")).append("</td></tr>");
                                    mensajeCorreo.append("<tr><td><b>Fecha Liberación</b></td><td><b>::</b></td><td>").append(sdf.format(res.getTimestamp("FECHA_LIBERACION"))).append("</td></tr>");
                                    mensajeCorreo.append("<tr><td><b>Tipo Liberación</b></td><td><b>::</b></td><td>").append(res.getString("NOMBRE_TIPO_LIBERACION_LOTE")).append("</td></tr>");
                                    mensajeCorreo.append("<tr><td class='detalle' colspan='3' bgcolor='#75327c'>INGRESO LIBERADO</td></tr>");
                                    mensajeCorreo.append("<tr><td><b>Número Ingreso</b></td><td><b>::</b></td><td>").append(res.getInt("NRO_INGRESOVENTAS")).append("</td></tr>");
                                    mensajeCorreo.append("<tr><td><b>Almacen</b></td><td><b>::</b></td><td>").append(res.getString("NOMBRE_ALMACEN_VENTA")).append("</td></tr>");
                                    mensajeCorreo.append("<tr><td class='detalle' colspan='3' bgcolor='#75327c'>INGRESO GENERADO</td></tr>");
                                    mensajeCorreo.append("<tr><td><b>Número Ingreso</b></td><td><b>::</b></td><td>").append(res.getInt("NRO_INGRESOVENTASgenerado")).append("</td></tr>");
                                    mensajeCorreo.append("<tr><td><b>Almacen</b></td><td><b>::</b></td><td>").append(res.getString("NOMBRE_ALMACEN_VENTAgenerado")).append("</td></tr>");
                                    mensajeCorreo.append("<tr><td class='detalle' colspan='3' bgcolor='#75327c'>DATOS DEL PRODUCTO</td></tr>");
                                    mensajeCorreo.append("<tr><td colspan='3'><table cellpading='0' cellspacing='0'>");
                                        mensajeCorreo.append("<tr bgcolor='#75327c'><td class='detalle' style='border-right:1px solid white'>Producto</td><td class='detalle' style='border-right:1px solid white'>N° Lote</td><td class='detalle' style='border-right:1px solid white'>Fecha Vencimiento</td><td class='detalle' style='border-right:1px solid white'>Cantidad</td><td class='detalle'>Cantidad Unitaria</td></tr>");
                                        sdf=new SimpleDateFormat("dd/MM/yyyy");
                                        mensajeCorreo.append("<tr>");
                                                mensajeCorreo.append(" <td class='border'>").append(res.getString("NOMBRE_PRODUCTO_PRESENTACION")).append("</td>");
                                                mensajeCorreo.append(" <td class='border'>").append(res.getString("COD_LOTE_PRODUCCION")).append("</td>");
                                                mensajeCorreo.append(" <td class='border'>").append(sdf.format(res.getTimestamp("FECHA_VENC"))).append("</td>");
                                                mensajeCorreo.append(" <td class='border'>").append(res.getDouble("CANTIDAD_RESTANTE")).append("</td>");
                                                mensajeCorreo.append(" <td class='border'>").append(res.getDouble("CANTIDAD_UNITARIARESTANTE")).append("</td>");
                                        mensajeCorreo.append("</tr>");
                                    mensajeCorreo.append("</table><td></tr>");
                            //</editor-fold>                                
                                mensajeCorreo.append("</table>");
                                mensajeCorreo.append("<br>");
            LOGGER.debug("correo "+mensajeCorreo.toString());
            // <editor-fold defaultstate="collapsed" desc="destinatario">
                consulta=new StringBuilder("SELECT CP.nombre_correopersonal");
                       consulta.append(" FROM CONFIGURACION_ENVIO_CORREO_ATLAS CE INNER JOIN correo_personal CP ON");
                       consulta.append(" CP.COD_PERSONAL=CE.COD_PERSONAL");
                       consulta.append(" WHERE CE.COD_MOTIVO_ENVIO_CORREO_PERSONAL=10");
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
        }
        catch (Exception ex) {
            LOGGER.warn("error", ex);
        }
    }

}
