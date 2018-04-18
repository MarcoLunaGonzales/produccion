/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.bean.util;

import com.cofar.util.Util;
import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics;
import java.awt.Point;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Properties;
import java.util.logging.Level;
import javax.imageio.ImageIO;
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
public class GeneracionImagenPreparadoVersion extends Thread {
    private static Logger LOGGER=LogManager.getRootLogger();
    private int codVersion;
    private int codProcesoOrdeManufactura;
    private Connection con=null;

    public GeneracionImagenPreparadoVersion(int codVersion, int codProcesoOrdeManufactura,Connection con) {
        this.codVersion = codVersion;
        this.codProcesoOrdeManufactura = codProcesoOrdeManufactura;
        this.con=con;
    }

    
    
    @Override
    public void run() 
    {
        int coorXSubProceso=7;
        int coorXProceso=547;
        int orden=0;
        try {
            
            StringBuilder consulta=new StringBuilder("select ep.NOMBRE_ESPECIFICACIONES_PROCESO,pppem.COD_TIPO_DESCRIPCION,pppem.VALOR_EXACTO,pppem.VALOR_TEXTO,pppem.VALOR_MINIMO, pppem.VALOR_MAXIMO,pppem.RESULTADO_ESPERADO_LOTE,pppem.COD_UNIDAD_MEDIDA");
                                    consulta.append(" ,M.COD_MAQUINA,M.NOMBRE_MAQUINA,M.CODIGO,isnull(um.ABREVIATURA,'') as ABREVIATURA,td.ESPECIFICACION");
                                    consulta.append(" from PROCESOS_PREPARADO_PRODUCTO_MAQUINARIA pppm");
                                        consulta.append(" inner join MAQUINARIAS m on m.COD_MAQUINA=pppm.COD_MAQUINA");
                                        consulta.append(" inner join PROCESOS_PREPARADO_PRODUCTO_ESPECIFICACIONES_MAQUINARIA pppem on pppem.COD_PROCESO_PREPARADO_PRODUCTO_MAQUINARIA=pppm.COD_PROCESO_PREPARADO_PRODUCTO_MAQUINARIA");
                                        consulta.append(" inner join ESPECIFICACIONES_PROCESOS ep on ep.COD_ESPECIFICACION_PROCESO=pppem.COD_ESPECIFICACION_PROCESO");
                                        consulta.append(" inner join TIPOS_DESCRIPCION td on td.COD_TIPO_DESCRIPCION=pppem.COD_TIPO_DESCRIPCION");
                                        consulta.append(" left outer join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=pppem.COD_UNIDAD_MEDIDA");
                                    consulta.append(" where pppm.COD_PROCESO_PREPARADO_PRODUCTO=?");
                                    consulta.append(" order by m.NOMBRE_MAQUINA,ep.NOMBRE_ESPECIFICACIONES_PROCESO");
            PreparedStatement pstMaquina=con.prepareStatement(consulta.toString(), ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            consulta=new StringBuilder("INSERT INTO DIAGRAMA_PREPARADO_PRODUCTO_PROCESO_VERSION(COD_VERSION,COD_PROCESO_ORDEN_MANUFACTURA, DIAGRAMA, ORDEN)");
                    consulta.append("VALUES (").append(codVersion).append(",").append(codProcesoOrdeManufactura).append(",?, ?);");
            PreparedStatement pst=con.prepareStatement(consulta.toString());
            LOGGER.debug("consulta especificaciones "+consulta.toString());
            consulta=new StringBuilder("select m.NOMBRE_MATERIAL,round(sum(fmd.CANTIDAD),2) as CANTIDAD,um.ABREVIATURA");
                    consulta.append(" from PROCESOS_PREPARADO_PRODUCTO_CONSUMO_MATERIAL pppcm ");
                        consulta.append(" inner join FORMULA_MAESTRA_DETALLE_MP_FRACCIONES_VERSION fmd on fmd.COD_MATERIAL=pppcm.COD_MATERIAL");
                        consulta.append(" and fmd.COD_FORMULA_MAESTRA_FRACCIONES=pppcm.COD_FORMULA_MAESTRA_FRACCIONES");
                        consulta.append(" inner join MATERIALES m on m.COD_MATERIAL=fmd.COD_MATERIAL");
                        consulta.append(" inner join FORMULA_MAESTRA_DETALLE_MP_VERSION fmd1 on fmd1.COD_MATERIAL=fmd.COD_MATERIAL");
                        consulta.append(" and fmd1.COD_VERSION=fmd.COD_VERSION");
                        consulta.append(" inner join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=fmd1.COD_UNIDAD_MEDIDA");
                        consulta.append(" inner join FORMULA_MAESTRA_VERSION fmv on fmv.COD_VERSION=fmd.COD_VERSION");
                    consulta.append(" where pppcm.COD_PROCESO_PREPARADO_PRODUCTO=?");
                    consulta.append(" and fmv.cod_compprod_version=").append(codVersion);
                    consulta.append(" group by m.NOMBRE_MATERIAL,um.ABREVIATURA");
                    consulta.append(" order by m.NOMBRE_MATERIAL");
            LOGGER.debug("consutla materiales formula"+consulta.toString());
            PreparedStatement pstMaterial=con.prepareStatement(consulta.toString(),ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            consulta = new StringBuilder("select ppp.COD_PROCESO_PREPARADO_PRODUCTO,ppp.NRO_PASO,ppp.COD_ACTIVIDAD_PREPARADO,ap.NOMBRE_ACTIVIDAD_PREPARADO,ppp.DESCRIPCION,");
                         consulta.append(" ppp.OPERARIO_TIEMPO_COMPLETO,ppp.TIEMPO_PROCESO,ppp.TOLERANCIA_TIEMPO");
                         consulta.append(" ,(select count(ppm.COD_MAQUINA) as maquinasRegistradas from PROCESOS_PREPARADO_PRODUCTO_MAQUINARIA ppm where ppm.COD_PROCESO_PREPARADO_PRODUCTO=ppp.COD_PROCESO_PREPARADO_PRODUCTO) as cantidadMaquinarias");
                        consulta.append(" from PROCESOS_PREPARADO_PRODUCTO ppp");
                            consulta.append(" inner join ACTIVIDADES_PREPARADO ap on ap.COD_ACTIVIDAD_PREPARADO =ppp.COD_ACTIVIDAD_PREPARADO");
                        consulta.append(" where ppp.COD_VERSION =").append(codVersion);
                            consulta.append("  and  ppp.COD_PROCESO_ORDEN_MANUFACTURA =").append(codProcesoOrdeManufactura);
                            consulta.append("  and  ppp.COD_PROCESO_PREPARADO_PRODUCTO_PADRE =?");
                        consulta.append(" order by ppp.NRO_PASO,");
                            consulta.append(" ppp.COD_PROCESO_PREPARADO_PRODUCTO");
            PreparedStatement pstSubProceso=con.prepareStatement(consulta.toString(),ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            LOGGER.debug("consulta sub proceso "+consulta.toString());
            consulta = new StringBuilder("select ppp.COD_PROCESO_PREPARADO_PRODUCTO,ppp.NRO_PASO,ppp.COD_ACTIVIDAD_PREPARADO,ap.NOMBRE_ACTIVIDAD_PREPARADO,ppp.DESCRIPCION,");
                         consulta.append(" ppp.OPERARIO_TIEMPO_COMPLETO,ppp.TIEMPO_PROCESO,ppp.TOLERANCIA_TIEMPO");
                         consulta.append(" ,(select count(ppm.COD_MAQUINA) as maquinasRegistradas from PROCESOS_PREPARADO_PRODUCTO_MAQUINARIA ppm where ppm.COD_PROCESO_PREPARADO_PRODUCTO=ppp.COD_PROCESO_PREPARADO_PRODUCTO) as cantidadMaquinarias");
                        consulta.append(" from PROCESOS_PREPARADO_PRODUCTO ppp");
                            consulta.append(" inner join ACTIVIDADES_PREPARADO ap on ap.COD_ACTIVIDAD_PREPARADO =ppp.COD_ACTIVIDAD_PREPARADO");
                        consulta.append(" where ppp.COD_VERSION =").append(codVersion);
                            consulta.append("  and  ppp.COD_PROCESO_ORDEN_MANUFACTURA =").append(codProcesoOrdeManufactura);
                            consulta.append("  and  ppp.COD_PROCESO_PREPARADO_PRODUCTO_PADRE = 0");
                        consulta.append(" order by ppp.NRO_PASO,");
                            consulta.append(" ppp.COD_PROCESO_PREPARADO_PRODUCTO");
            LOGGER.debug("consulta cargar pasos "+consulta.toString());
            BufferedImage image=new BufferedImage(1054,1274, BufferedImage.TYPE_INT_RGB);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            //edifinimos tamano de texto para imagenes 
            Font fuente=new Font("SansSerif", Font.PLAIN, 12);
            Font fuenteBold=new Font("SansSerif", Font.BOLD, 12);
            Color colorMaquinaria=new Color(164,231,196);
            Color colorCabecera=new Color(160,233,146);
            Color colorMaterial=new Color(231,218,145);
            Color colorNodo=new Color(247,171,97);
            Graphics grafico=image.getGraphics();
            grafico.setColor(Color.white);
            grafico.fillRect(0, 0, 1054, 1274);
            grafico.setColor(Color.BLACK);
            int cooryProceso=0;
            int coorySubProceso=0;
            
            int codMaquinaCabecera=0;
            int coorYNodo=20;
            int coorYaux=20;
            ResultSet resDetalle;
            ResultSet resSubProceso;
            Point ultimoProceso=new Point();
            Point ultimoSubProceso=null;
            String[] subNodos={"A","B","C","D","E","F","G","H","I"};
            while (res.next()) 
            {
                // <editor-fold defaultstate="collapsed" desc="verificando nueva hoja">
                if(cooryProceso+310>=1274)
                {
                    if(ultimoProceso.y>0)
                    {

                        grafico.setColor(Color.BLACK);
                        grafico.fillRect(ultimoProceso.x-1,ultimoProceso.y,2,(1220-ultimoProceso.y));
                        int[] pointsx={ultimoProceso.x,(ultimoProceso.x+8),(ultimoProceso.x-8)};
                        int[] pointsy={1220,1212,1212};
                        grafico.fillPolygon(pointsx,pointsy, 3);
                    }
                    grafico.setColor(colorNodo);
                    grafico.fillOval(coorXProceso+230,1220, 20, 20);
                    grafico.setColor(Color.BLACK);
                    grafico.drawString(subNodos[orden],coorXProceso+238,1235);
                    File ftemp=File.createTempFile("imagenPrueba"+orden, ".jpg");
                    ImageIO.write(image,"jpg",ftemp);
                    FileInputStream input=new FileInputStream(ftemp);
                    pst.setBinaryStream(1,input);
                    pst.setInt(2,orden);
                    if(pst.executeUpdate()>0)LOGGER.info("se registro la imagen");
                    
                    image=new BufferedImage(1054,1274, BufferedImage.TYPE_INT_RGB);
                    grafico=image.getGraphics();
                    cooryProceso=0;
                    coorySubProceso=0;
                    grafico.setColor(Color.white);
                    grafico.fillRect(0, 0, 1054, 1274);
                    grafico.setColor(colorNodo);
                    cooryProceso+=10;
                    grafico.fillOval(coorXProceso+230, cooryProceso, 20, 20);
                    grafico.setColor(Color.BLACK);
                    grafico.setFont(fuenteBold);
                    grafico.drawString(subNodos[orden],coorXProceso+238, cooryProceso+15);
                    ultimoProceso=new Point(coorXProceso+240,cooryProceso+20);
                    cooryProceso+=55;
                    coorySubProceso=cooryProceso;
                    orden++;
                }
                //</editor-fold>
                coorYNodo=cooryProceso;
                // <editor-fold defaultstate="collapsed" desc="dibujando conector si aplica">
                if(ultimoProceso.y>0)
                {
                    
                    grafico.setColor(Color.BLACK);
                    grafico.fillRect(ultimoProceso.x-1,ultimoProceso.y,2,(cooryProceso-ultimoProceso.y));
                    int[] pointsx={ultimoProceso.x,(ultimoProceso.x+8),(ultimoProceso.x-8)};
                    int[] pointsy={cooryProceso,(cooryProceso-8),(cooryProceso-8)};
                    grafico.fillPolygon(pointsx,pointsy, 3);
                }
                //</editor-fold>
                // <editor-fold defaultstate="collapsed" desc="dibujando cabecera">
                    grafico.setColor(colorCabecera);
                    grafico.fillRoundRect(coorXProceso+5,cooryProceso+3, 490,50, 10, 10);
                    cooryProceso+=15;
                    grafico.setColor(Color.BLACK);
                    grafico.setFont(fuenteBold);
                    grafico.drawString(res.getString("NRO_PASO"),coorXProceso+240, cooryProceso);
                    cooryProceso+=15;
                    grafico.drawString(res.getString("NOMBRE_ACTIVIDAD_PREPARADO"),coorXProceso+240-(res.getString("NOMBRE_ACTIVIDAD_PREPARADO").length()*3), cooryProceso);
                    cooryProceso+=15;
                    grafico.drawString("OPERARIO TIEMPO COMPLETO: "+(res.getInt("OPERARIO_TIEMPO_COMPLETO")>0?"SI":"NO"),coorXProceso+140,cooryProceso);
                //</editor-fold>
                // <editor-fold defaultstate="collapsed" desc="dibujando especificaicones de equipo">

                    cooryProceso+=15;
                    coorYaux=cooryProceso;
                    grafico.setFont(fuenteBold);
                    pstMaquina.setInt(1,res.getInt("COD_PROCESO_PREPARADO_PRODUCTO"));
                    resDetalle=pstMaquina.executeQuery();
                    resDetalle.last();
                    grafico.setColor(colorMaquinaria);
                    grafico.fillRoundRect(coorXProceso+5,coorYaux, 490,5+((resDetalle.getRow()+res.getInt("cantidadMaquinarias"))*15), 8, 8);
                    resDetalle.absolute(0);
                    grafico.setColor(Color.BLACK);
                    while(resDetalle.next())
                    {
                    
                        if(codMaquinaCabecera!=resDetalle.getInt("COD_MAQUINA"))
                        {
                            codMaquinaCabecera=resDetalle.getInt("COD_MAQUINA");
                            cooryProceso+=15;
                            grafico.setFont(fuenteBold);
                            grafico.drawString(resDetalle.getString("NOMBRE_MAQUINA")+" ("+resDetalle.getString("CODIGO")+")",coorXProceso+10,cooryProceso);
                        }
                            cooryProceso+=15;
                            grafico.setFont(fuente);
                            String descripcion="";
                            // <editor-fold defaultstate="collapsed" desc="determinando el tipo de descripcion">
                            switch(resDetalle.getInt("COD_TIPO_DESCRIPCION"))
                            {
                                case 1:
                                {
                                    descripcion=(resDetalle.getInt("RESULTADO_ESPERADO_LOTE")>0?"________________":resDetalle.getString("VALOR_TEXTO"));
                                    break;
                                }
                                case 2:
                                {
                                    descripcion=(resDetalle.getInt("RESULTADO_ESPERADO_LOTE")>0?"_______-________":resDetalle.getDouble("VALOR_MINIMO")+"-"+resDetalle.getDouble("VALOR_MAXIMO"));
                                    break;
                                }
                                default:
                                {
                                    descripcion=resDetalle.getString("ESPECIFICACION")+" "+(resDetalle.getInt("RESULTADO_ESPERADO_LOTE")>0? "__________":resDetalle.getDouble("VALOR_EXACTO"));
                                    break;      
                                }
                            }
                            //</editor-fold>
                            grafico.drawString(resDetalle.getString("NOMBRE_ESPECIFICACIONES_PROCESO")+" : "+descripcion+" ("+resDetalle.getString("ABREVIATURA")+")",coorXProceso+15, cooryProceso);
                    }
                    cooryProceso+=15;
                //</editor-fold>    
                // <editor-fold defaultstate="collapsed" desc="dibujando materiales">
                pstMaterial.setInt(1,res.getInt("COD_PROCESO_PREPARADO_PRODUCTO"));
                resDetalle=pstMaterial.executeQuery();
                resDetalle.last();
                grafico.setColor(colorMaterial);
                grafico.fillRoundRect(coorXProceso+5,cooryProceso, 490,(resDetalle.getRow()*15)+19, 12,12);
                cooryProceso+=15;
                grafico.setFont(fuenteBold);
                grafico.setColor(Color.BLACK);
                grafico.drawString("Materiales",coorXProceso+10, cooryProceso);
                grafico.setFont(fuente);
                resDetalle.absolute(0);
                while(resDetalle.next())
                {
                    cooryProceso+=15;
                    grafico.drawString(resDetalle.getString("NOMBRE_MATERIAL")+": "+resDetalle.getString("CANTIDAD")+" "+resDetalle.getString("ABREVIATURA"),coorXProceso+15,cooryProceso);
                }
                cooryProceso+=25;
                //</editor-fold>
                //<editor-fold defaultstate="collapsed" desc="dibujando datos para relleno">
                grafico.setFont(fuenteBold);
                grafico.drawString("OPERARIOS:",coorXProceso+10, cooryProceso);
                cooryProceso+=15;
                grafico.drawString("-___________________________________________________",coorXProceso+10, cooryProceso);
                cooryProceso+=15;
                grafico.drawString("-___________________________________________________",coorXProceso+10, cooryProceso);
                cooryProceso+=15;
                grafico.drawString("CONFORME :_____",coorXProceso+10, cooryProceso);
                cooryProceso+=15;
                grafico.drawString("OBSERVACIONES :",coorXProceso+10, cooryProceso);
                cooryProceso+=15;
                grafico.drawString("_________________________________________________________________",coorXProceso+10, cooryProceso);
                cooryProceso+=15;
                //</editor-fold>
                // <editor-fold defaultstate="collapsed" desc="dibujando conector sub proceso proceso si aplica">
                if(ultimoSubProceso!=null)
                {
                    grafico.setColor(Color.BLACK);
                    int coorYdestino=coorYNodo+((cooryProceso-coorYNodo)/2);
                    grafico.fillRect(ultimoSubProceso.x,ultimoSubProceso.y,2,coorYdestino-ultimoSubProceso.y);
                    grafico.fillRect(ultimoSubProceso.x,coorYdestino,300,2);
                    int[] pointsx={ultimoSubProceso.x+292,ultimoSubProceso.x+292,ultimoSubProceso.x+300};
                    int[] pointsy={coorYdestino+8,coorYdestino-8,coorYdestino};
                    grafico.fillPolygon(pointsx,pointsy, 3);
                }
                //</editor-fold>
                ultimoProceso=new Point(coorXProceso+240,cooryProceso);
                ultimoSubProceso=null;
                grafico.drawRoundRect(coorXProceso,coorYNodo,500,cooryProceso-coorYNodo,12,12);
                cooryProceso+=40;
                // <editor-fold defaultstate="collapsed" desc="subProcesos">
                pstSubProceso.setInt(1,res.getInt("COD_PROCESO_PREPARADO_PRODUCTO"));
                resSubProceso=pstSubProceso.executeQuery();
                while(resSubProceso.next())
                {
                    // <editor-fold defaultstate="collapsed" desc="dibujando conectores">
                    grafico.setColor(Color.BLACK);
                    if(ultimoSubProceso!=null)
                    {
                        grafico.fillRect(ultimoSubProceso.x-1,ultimoSubProceso.y,2,(coorySubProceso-ultimoSubProceso.y));
                        int[] pointsx={ultimoSubProceso.x,(ultimoSubProceso.x+8),(ultimoSubProceso.x-8)};
                        int[] pointsy={coorySubProceso,(coorySubProceso-8),(coorySubProceso-8)};
                        grafico.fillPolygon(pointsx,pointsy, 3);
                    }
                    
                    //</editor-fold>
                    // <editor-fold defaultstate="collapsed" desc="dibujando cabecera">
                        coorYNodo=coorySubProceso;
                        grafico.setColor(colorCabecera);
                        grafico.fillRoundRect(coorXSubProceso+5,coorySubProceso+3, 490,50, 10, 10);
                        coorySubProceso+=15;
                        grafico.setColor(Color.BLACK);
                        grafico.setFont(fuenteBold);
                        grafico.drawString(res.getString("NRO_PASO")+"."+resSubProceso.getString("NRO_PASO"),coorXSubProceso+240, coorySubProceso);
                        coorySubProceso+=15;
                        grafico.drawString(resSubProceso.getString("NOMBRE_ACTIVIDAD_PREPARADO"),coorXSubProceso+240-(resSubProceso.getString("NOMBRE_ACTIVIDAD_PREPARADO").length()*3), coorySubProceso);
                        coorySubProceso+=15;
                        grafico.drawString("OPERARIO TIEMPO COMPLETO: "+(resSubProceso.getInt("OPERARIO_TIEMPO_COMPLETO")>0?"SI":"NO"),coorXSubProceso+140,coorySubProceso);
                    //</editor-fold>
                    // <editor-fold defaultstate="collapsed" desc="dibujando especificaicones de equipo">
                    coorySubProceso+=15;
                    coorYaux=coorySubProceso;
                    grafico.setFont(fuenteBold);
                    pstMaquina.setInt(1,resSubProceso.getInt("COD_PROCESO_PREPARADO_PRODUCTO"));
                    resDetalle=pstMaquina.executeQuery();
                    resDetalle.last();
                    grafico.setColor(colorMaquinaria);
                    grafico.fillRoundRect(coorXSubProceso+5,coorYaux, 490,5+((resDetalle.getRow()+resSubProceso.getInt("cantidadMaquinarias"))*15), 8, 8);
                    resDetalle.absolute(0);
                    grafico.setColor(Color.BLACK);
                    while(resDetalle.next())
                    {
                    
                        if(codMaquinaCabecera!=resDetalle.getInt("COD_MAQUINA"))
                        {
                            codMaquinaCabecera=resDetalle.getInt("COD_MAQUINA");
                            coorySubProceso+=15;
                            grafico.setFont(fuenteBold);
                            grafico.drawString(resDetalle.getString("NOMBRE_MAQUINA"),coorXSubProceso+10,coorySubProceso);
                        }
                            coorySubProceso+=15;
                            grafico.setFont(fuente);
                            String descripcion="";
                    // <editor-fold defaultstate="collapsed" desc="determinando el tipo de descripcion">
                            switch(resDetalle.getInt("COD_TIPO_DESCRIPCION"))
                            {
                                case 1:
                                {
                                    descripcion=(resDetalle.getInt("RESULTADO_ESPERADO_LOTE")>0?"________________":resDetalle.getString("VALOR_TEXTO"));
                                    break;
                                }
                                case 2:
                                {
                                    descripcion=(resDetalle.getInt("RESULTADO_ESPERADO_LOTE")>0?"_______-________":resDetalle.getDouble("VALOR_MINIMO")+"-"+resDetalle.getDouble("VALOR_MAXIMO"));
                                    break;
                                }
                                default:
                                {
                                    descripcion=resDetalle.getString("ESPECIFICACION")+" "+(resDetalle.getInt("RESULTADO_ESPERADO_LOTE")>0? "__________":resDetalle.getDouble("VALOR_EXACTO"));
                                    break;      
                                }
                            }
                        //</editor-fold>
                            grafico.drawString(resDetalle.getString("NOMBRE_ESPECIFICACIONES_PROCESO")+" : "+descripcion+" ("+resDetalle.getString("ABREVIATURA")+")",coorXSubProceso+15, coorySubProceso);
                    }
                    coorySubProceso+=15;
                //</editor-fold>      
                    // <editor-fold defaultstate="collapsed" desc="dibujando materiales">
                        pstMaterial.setInt(1,resSubProceso.getInt("COD_PROCESO_PREPARADO_PRODUCTO"));
                        resDetalle=pstMaterial.executeQuery();
                        resDetalle.last();
                        grafico.setColor(colorMaterial);
                        grafico.fillRoundRect(coorXSubProceso+5,coorySubProceso, 490,(resDetalle.getRow()*15)+19, 12,12);
                        coorySubProceso+=15;
                        grafico.setFont(fuenteBold);
                        grafico.setColor(Color.BLACK);
                        grafico.drawString("Materiales",coorXSubProceso+10, coorySubProceso);
                        grafico.setFont(fuente);
                        resDetalle.absolute(0);
                        while(resDetalle.next())
                        {
                            coorySubProceso+=15;
                            grafico.drawString(resDetalle.getString("NOMBRE_MATERIAL")+": "+resDetalle.getString("CANTIDAD")+" "+resDetalle.getString("ABREVIATURA"),coorXSubProceso+15,coorySubProceso);
                        }
                        coorySubProceso+=25;
                        //</editor-fold>    
                    //<editor-fold defaultstate="collapsed" desc="dibujando datos para relleno">
                    grafico.setFont(fuenteBold);
                    grafico.drawString("OPERARIOS:",coorXSubProceso+10, coorySubProceso);
                    coorySubProceso+=15;
                    grafico.drawString("-___________________________________________________",coorXSubProceso+10, coorySubProceso);
                    coorySubProceso+=15;
                    grafico.drawString("-___________________________________________________",coorXSubProceso+10, coorySubProceso);
                    coorySubProceso+=15;
                    grafico.drawString("CONFORME :_____",coorXSubProceso+10, coorySubProceso);
                    coorySubProceso+=15;
                    grafico.drawString("OBSERVACIONES :",coorXSubProceso+10, coorySubProceso);
                    coorySubProceso+=15;
                    grafico.drawString("__________________________________________________________________",coorXSubProceso+10, coorySubProceso);
                    coorySubProceso+=15;
                    //</editor-fold>    
                    // <editor-fold defaultstate="collapsed" desc="dibujando conector proceso sub proceso si aplica">
                    if(ultimoSubProceso==null)
                    {
                        grafico.setColor(Color.BLACK);
                        grafico.fillRect(coorXSubProceso+500,(coorYNodo+((coorySubProceso-coorYNodo)/2)),40,2);
                        int[] pointsx={coorXSubProceso+500,(coorXSubProceso+508),(coorXSubProceso+508)};
                        int[] pointsy={(coorYNodo+((coorySubProceso-coorYNodo)/2)),(coorYNodo+8+((coorySubProceso-coorYNodo)/2)),(coorYNodo-8+((coorySubProceso-coorYNodo)/2))};
                        grafico.fillPolygon(pointsx,pointsy, 3);
                    }
                    //</editor-fold>
                    coorySubProceso+=15;
                    ultimoSubProceso=new Point(coorXSubProceso+240,coorySubProceso);
                    grafico.drawRoundRect(coorXSubProceso,coorYNodo,500,coorySubProceso-coorYNodo,12,12);
                    coorySubProceso+=40;
                    if(cooryProceso>coorySubProceso)coorySubProceso=cooryProceso;
                }
                if(cooryProceso>coorySubProceso)
                {
                    coorySubProceso=cooryProceso;
                }
                else
                {
                    cooryProceso=coorySubProceso;
                }
                //</editor-fold>
                
            }
            File ftemp=File.createTempFile("imagenPrueba"+orden, ".jpg");
            ImageIO.write(image,"jpg",ftemp);
            FileInputStream input=new FileInputStream(ftemp);
            pst.setBinaryStream(1,input);
            pst.setInt(2,orden);
            if(pst.executeUpdate()>0)LOGGER.info("se registro la imagen");
            st.close();
        } 
        catch (SQLException ex) 
        {
            LOGGER.warn("error", ex);
        }
        catch (IOException ex) 
        {
            LOGGER.warn("error", ex);
        } 
    }

}