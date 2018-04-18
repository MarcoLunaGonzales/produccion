/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.bean.util;

import com.cofar.ProcesoDestino;
import java.awt.Font;
import java.awt.Graphics;
import java.awt.Color;
import java.awt.Point;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.StringTokenizer;
import javax.imageio.ImageIO;
import org.apache.logging.log4j.Logger;

/**
 *
 * @author DASISAQ-
 */
public class CreacionGraficosOrdenManufactura 
{
    Graphics grafico = null;
    int cantidadAlturaPixelesPorHoja = 0;
    static final int  ALTURA_PIXELES_MAXIMO = 1274;
    int cantidadPixelesPreDiagrama = 0 ;
    // <editor-fold defaultstate="collapsed" desc="estilos">
        Font fuente=new Font("Helvetica", Font.PLAIN, 12);
        Font fuenteBold=new Font("Helvetica", Font.BOLD, 12);
        Color colorMaquinaria=new Color(164,231,196);
        Color colorBordeMaquinaria=new Color(75,109,91);
        Color colorDescripcion=new Color(165,194,194);
        Color colorBordeDescripcion=new Color(137,136,136);
        Color colorCabecera=new Color(160,233,146);
        Color colorBordeCabecera=new Color(93,138,84);
        Color colorSustanciaResultante=new Color(181,218,253);
        Color colorBordeSustanciaResultante=new Color(48,120,186);
        Color colorMaterial=new Color(231,218,145);
        Color colorBordeMaterial=new Color(157,120,22);
        Color colorNodo=new Color(247,171,97);
    //</editor-fold>
    
    public void dibujarNodo(int x, int y,String texto)
    {
        grafico.setColor(colorNodo);
        grafico.fillOval(x,y, 20, 20);
        grafico.setColor(Color.BLACK);
        grafico.setFont(fuenteBold);
        grafico.drawString(texto , x+8 , y+14);
    }
    public void dibujarFlecha( int coorXIni, int coorYIni,int coorXFin,int coorYFin)
    {
        grafico.setColor(Color.BLACK);
        grafico.fillRect(coorXIni-1,coorYIni,2,(coorYFin-coorYIni));
        int[] pointsx={coorXIni,(coorXIni+8),(coorXIni-8)};
        int[] pointsy={coorYFin,coorYFin - 8,coorYFin - 8};
        grafico.fillPolygon(pointsx,pointsy, 3);
    }
    public void crearFlujogramaOrdenManufacturaProduccion(Connection con,Logger LOGGER,String codLoteProduccion,int codProgramaProd,int codProcesoOrdenManufactura)throws SQLException,IOException
    {
        StringBuilder consultaProcesos=new StringBuilder("select ffpom.COD_PROCESO_ORDEN_MANUFACTURA,ffpom.CANTIDAD_PIXELES_PRE_DIAGRAMA")
                                                .append(" from programa_produccion pp ")
                                                        .append(" inner join COMPONENTES_PROD_PROCESO_ORDEN_MANUFACTURA cppo on cppo.COD_VERSION=pp.COD_COMPPROD_VERSION ")
                                                        .append(" inner join FORMAS_FARMACEUTICAS_PROCESO_ORDEN_MANUFACTURA ffpom on ffpom.COD_FORMA_FARMACEUTICA_PROCESO_ORDEN_MANUFACTURA=cppo.COD_FORMA_FARMACEUTICA_PROCESO_ORDEN_MANUFACTURA")
                                                .append(" where pp.COD_LOTE_PRODUCCION='").append(codLoteProduccion).append("'")
                                                        .append(" and pp.COD_PROGRAMA_PROD=").append(codProgramaProd)
                                                        .append(" and ffpom.APLICA_FLUJOGRAMA=1")
                                                .append(" group by ffpom.COD_PROCESO_ORDEN_MANUFACTURA,ffpom.CANTIDAD_PIXELES_PRE_DIAGRAMA");
        LOGGER.debug("consulta procesos habilitados "+consultaProcesos.toString());
        Statement stP=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
        ResultSet resP=stP.executeQuery(consultaProcesos.toString());
        while(resP.next())
        {
            codProcesoOrdenManufactura = resP.getInt("COD_PROCESO_ORDEN_MANUFACTURA");
            cantidadPixelesPreDiagrama = resP.getInt("CANTIDAD_PIXELES_PRE_DIAGRAMA");
            cantidadAlturaPixelesPorHoja = ALTURA_PIXELES_MAXIMO - cantidadPixelesPreDiagrama;
            
            // <editor-fold defaultstate="collapsed" desc="generacion de imagenes">
                NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
                DecimalFormat format = (DecimalFormat)nf;
                format.applyPattern("#,##0.00");
                int coorXSubProceso=16;
                int coorXProceso=552;
                int orden=0;
                int codVersion=0;
                int codAreaEmpresa=0;
                List<ProcesoDestino> codProcesosDestino=new ArrayList<ProcesoDestino>();
                List<Point> coordenadasPuntoDestino=new ArrayList<Point>();
                List<Color> coloresDestinoList=new ArrayList<Color>();

                coloresDestinoList.add(Color.blue);

                coloresDestinoList.add(new Color(206,128,27));
                coloresDestinoList.add(Color.red);
                coloresDestinoList.add(new Color(135,23,131));
                coloresDestinoList.add(new Color(48, 124,27));
                coloresDestinoList.add(new Color(48, 124,27));
                coloresDestinoList.add(new Color(118, 51,51));
                coloresDestinoList.add(new Color(159, 121,121));
                coloresDestinoList.add(new Color(121, 159,121));
                coloresDestinoList.add(new Color(159, 121,159));
                


                StringBuilder consulta=new StringBuilder("select top 1 pp.COD_COMPPROD_VERSION,cpv.COD_AREA_EMPRESA");
                                        consulta.append(" from PROGRAMA_PRODUCCION pp");
                                                consulta.append(" inner join COMPONENTES_PROD_VERSION cpv on cpv.COD_VERSION=pp.COD_COMPPROD_VERSION");
                                        consulta.append(" where pp.COD_PROGRAMA_PROD=").append(codProgramaProd);
                                        consulta.append(" and pp.COD_LOTE_PRODUCCION='").append(codLoteProduccion).append("'");
                                        consulta.append(" order by case when pp.COD_COMPPROD=pp.COD_COMPPROD_VERSION then 1 else 2 end");
                                        consulta.append(" ,pp.COD_TIPO_PROGRAMA_PROD");
                LOGGER.debug("consulta buscar codigo version lote "+consulta.toString());
                Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet res=st.executeQuery(consulta.toString());
                if(res.next()){
                    codVersion=res.getInt("COD_COMPPROD_VERSION");
                    codAreaEmpresa=res.getInt("COD_AREA_EMPRESA");
                }
                // <editor-fold defaultstate="collapsed" desc="consulta especificaciones maquinaria producto">
                    consulta=new StringBuilder("select ep.NOMBRE_ESPECIFICACIONES_PROCESO,pppem.COD_TIPO_DESCRIPCION,pppem.VALOR_EXACTO,pppem.VALOR_TEXTO,pppem.VALOR_MINIMO, pppem.VALOR_MAXIMO,pppem.RESULTADO_ESPERADO_LOTE,pppem.COD_UNIDAD_MEDIDA,pppem.PORCIENTO_TOLERANCIA");
                                consulta.append(" ,M.COD_MAQUINA,M.NOMBRE_MAQUINA,M.CODIGO,isnull(um.ABREVIATURA,'') as ABREVIATURA,td.ESPECIFICACION,ep.COD_ESPECIFICACION_PROCESO");
                                consulta.append(" from PROCESOS_PREPARADO_PRODUCTO_MAQUINARIA pppm");
                                    consulta.append(" inner join MAQUINARIAS m on m.COD_MAQUINA=pppm.COD_MAQUINA");
                                    consulta.append(" left outer join PROCESOS_PREPARADO_PRODUCTO_ESPECIFICACIONES_MAQUINARIA pppem on pppem.COD_PROCESO_PREPARADO_PRODUCTO_MAQUINARIA=pppm.COD_PROCESO_PREPARADO_PRODUCTO_MAQUINARIA");
                                    consulta.append(" left outer join ESPECIFICACIONES_PROCESOS ep on ep.COD_ESPECIFICACION_PROCESO=pppem.COD_ESPECIFICACION_PROCESO");
                                    consulta.append(" left outer join TIPOS_DESCRIPCION td on td.COD_TIPO_DESCRIPCION=pppem.COD_TIPO_DESCRIPCION");
                                    consulta.append(" left outer join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=pppem.COD_UNIDAD_MEDIDA");
                                consulta.append(" where pppm.COD_PROCESO_PREPARADO_PRODUCTO=?");
                                consulta.append(" order by m.NOMBRE_MAQUINA,ep.NOMBRE_ESPECIFICACIONES_PROCESO");
                    LOGGER.debug("consulta maquinaria "+consulta.toString());
                    PreparedStatement pstMaquina=con.prepareStatement(consulta.toString(), ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                //</editor-fold>
                // <editor-fold defaultstate="collapsed" desc="consulta registrar flujo preparado">
                    consulta=new StringBuilder(" INSERT INTO PROGRAMA_PRODUCCION_DIAGRAMA_PREPARADO_PRODUCTO(COD_LOTE_PRODUCCION,COD_PROGRAMA_PROD,COD_PROCESO_ORDEN_MANUFACTURA,DIAGRAMA,ORDEN)");
                                consulta.append("VALUES (");
                                        consulta.append("'").append(codLoteProduccion).append("',");
                                        consulta.append(codProgramaProd).append(",");
                                        consulta.append(codProcesoOrdenManufactura).append(",");
                                        consulta.append(" ?,");
                                        consulta.append("?");
                                consulta.append(")");
                    PreparedStatement pst=con.prepareStatement(consulta.toString());
                    LOGGER.debug("consulta registra grafico preparado "+consulta.toString());
                //</editor-fold>
                // <editor-fold defaultstate="collapsed" desc="consulta consumo materiales">
                    consulta=new StringBuilder("exec PAA_PROCESOS_PREPARADO_PRODUCTO_CONSUMO_MATERIAL ?,?,?");
                    LOGGER.debug("consutla materiales formula"+consulta.toString());
                    PreparedStatement pstMaterial=con.prepareStatement(consulta.toString(),ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    pstMaterial.setInt(2,codProgramaProd);LOGGER.info("p2 "+codProgramaProd);
                    pstMaterial.setString(3,codLoteProduccion);LOGGER.info("p3 "+codLoteProduccion);
                //</editor-fold>
                // <editor-fold defaultstate="collapsed" desc="procesos de preparado">
                    consulta = new StringBuilder("select ppp.COD_PROCESO_PREPARADO_PRODUCTO,ppp.NRO_PASO,ppp.COD_ACTIVIDAD_PREPARADO,ap.NOMBRE_ACTIVIDAD_PREPARADO,ppp.DESCRIPCION,");
                                        consulta.append(" ppp.OPERARIO_TIEMPO_COMPLETO,ppp.TIEMPO_PROCESO,ppp.TOLERANCIA_TIEMPO");
                                        consulta.append(" ,(select count(ppm.COD_MAQUINA) as maquinasRegistradas from PROCESOS_PREPARADO_PRODUCTO_MAQUINARIA ppm where ppm.COD_PROCESO_PREPARADO_PRODUCTO=ppp.COD_PROCESO_PREPARADO_PRODUCTO) as cantidadMaquinarias");
                                        consulta.append(",ppp.COD_PROCESO_PREPARADO_PRODUCTO_DESTINO")
                                                .append(" ,isnull(ppp.SUSTANCIA_RESULTANTE,'') as SUSTANCIA_RESULTANTE");
                                consulta.append(" from PROCESOS_PREPARADO_PRODUCTO ppp");
                                    consulta.append(" inner join ACTIVIDADES_PREPARADO ap on ap.COD_ACTIVIDAD_PREPARADO =ppp.COD_ACTIVIDAD_PREPARADO");
                                consulta.append(" where ppp.COD_VERSION =").append(codVersion);
                                    consulta.append("  and  ppp.COD_PROCESO_ORDEN_MANUFACTURA =").append(codProcesoOrdenManufactura);
                                    consulta.append("  and  ppp.COD_PROCESO_PREPARADO_PRODUCTO_PADRE =?");
                                consulta.append(" order by ppp.NRO_PASO,");
                                    consulta.append(" ppp.COD_PROCESO_PREPARADO_PRODUCTO");
                    LOGGER.debug("consulta sub proceso "+consulta.toString());
                    PreparedStatement pstSubProceso=con.prepareStatement(consulta.toString(),ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                //</editor-fold>
                // <editor-fold defaultstate="collapsed" desc=" CONSULTA ELIMINAR ANTEROIRES GRAFICOS">
                    consulta=new StringBuilder("DELETE PROGRAMA_PRODUCCION_DIAGRAMA_PREPARADO_PRODUCTO");
                            consulta.append(" where COD_LOTE_PRODUCCION='").append(codLoteProduccion).append("'");
                                    consulta.append(" and COD_PROCESO_ORDEN_MANUFACTURA=").append(codProcesoOrdenManufactura);
                                    consulta.append(" and COD_PROGRAMA_PROD=").append(codProgramaProd);
                    LOGGER.debug("consulta eliminar anteriores pasos si existieran "+consulta.toString());    
                    PreparedStatement pstDel=con.prepareStatement(consulta.toString());
                    pstDel.executeUpdate();
                //</editor-fold>

                
                consulta=new StringBuilder("select isnull(ppp.SUSTANCIA_RESULTANTE,'') as SUSTANCIA_RESULTANTE,ppp.COD_PROCESO_PREPARADO_PRODUCTO,ppp.NRO_PASO,ppp.COD_ACTIVIDAD_PREPARADO,ap.NOMBRE_ACTIVIDAD_PREPARADO,isnull(ppp.DESCRIPCION,'') as DESCRIPCION,");
                             consulta.append(" ppp.OPERARIO_TIEMPO_COMPLETO,ppp.TIEMPO_PROCESO,ppp.TOLERANCIA_TIEMPO");
                             consulta.append(" ,(select count(ppm.COD_MAQUINA) as maquinasRegistradas from PROCESOS_PREPARADO_PRODUCTO_MAQUINARIA ppm where ppm.COD_PROCESO_PREPARADO_PRODUCTO=ppp.COD_PROCESO_PREPARADO_PRODUCTO) as cantidadMaquinarias");
                             consulta.append(" ,ppp.PROCESO_SECUENCIAL");
                            consulta.append(" from PROCESOS_PREPARADO_PRODUCTO ppp");
                                consulta.append(" inner join ACTIVIDADES_PREPARADO ap on ap.COD_ACTIVIDAD_PREPARADO =ppp.COD_ACTIVIDAD_PREPARADO");
                            consulta.append(" where ppp.COD_VERSION =").append(codVersion);
                                consulta.append("  and  ppp.COD_PROCESO_ORDEN_MANUFACTURA =").append(codProcesoOrdenManufactura);
                                consulta.append("  and  ppp.COD_PROCESO_PREPARADO_PRODUCTO_PADRE = 0");
                            consulta.append(" order by ppp.NRO_PASO,");
                                consulta.append(" ppp.COD_PROCESO_PREPARADO_PRODUCTO");
                LOGGER.debug("consulta cargar pasos "+consulta.toString());
                BufferedImage image=new BufferedImage(1054,cantidadAlturaPixelesPorHoja, BufferedImage.TYPE_INT_RGB);
                res = st.executeQuery(consulta.toString());
                //edifinimos tamano de texto para imagenes 
                grafico=image.getGraphics();
                grafico.setColor(Color.white);
                grafico.fillRect(0, 0, 1054, cantidadAlturaPixelesPorHoja);
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
                String[] subNodos={"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T"};
                
                while (res.next()) 
                {
                    
                    // <editor-fold defaultstate="collapsed" desc="verificando nueva hoja">
                    if(cooryProceso+310 >= cantidadAlturaPixelesPorHoja)
                    {
                        if(ultimoProceso.y > 0)
                        {
                            this.dibujarFlecha(ultimoProceso.x, ultimoProceso.y, ultimoProceso.x, cantidadAlturaPixelesPorHoja - 50);
                            this.dibujarNodo(coorXProceso+230,cantidadAlturaPixelesPorHoja - 50,subNodos[orden]);
                        }
                        // <editor-fold defaultstate="collapsed" desc="dibujando conector destino siguiente hoja">
                            for(int i=0;i<codProcesosDestino.size();i++)
                            {
                                if(codProcesosDestino.get(i).getCodProcesoDestino()>0)
                                {
                                    grafico.setColor(coloresDestinoList.get(i));
                                    grafico.fillRect(coordenadasPuntoDestino.get(i).x,coordenadasPuntoDestino.get(i).y,2,12);
                                    grafico.fillRect((i+1)*4,coordenadasPuntoDestino.get(i).y+10,coordenadasPuntoDestino.get(i).x-((i+1)*4),2);
                                    grafico.fillRect((i+1)*4,coordenadasPuntoDestino.get(i).y+10,2,1235-coordenadasPuntoDestino.get(i).y);
                                    coordenadasPuntoDestino.get(i).y=15;
                                    coordenadasPuntoDestino.get(i).x=(i+1)*4;
                                }
                            }
                        //</editor-fold>
                        
                        LOGGER.debug("iniciando grafico");
                        File ftemp=File.createTempFile("imagenPrueba"+orden, ".jpg");
                        ImageIO.write(image,"jpg",ftemp);
                        FileInputStream input=new FileInputStream(ftemp);
                        pst.setBinaryStream(1,input,ftemp.length());
                        pst.setInt(2,orden);
                        if(pst.executeUpdate()>0)LOGGER.info("se registro la imagen inicio");
                        
                        LOGGER.debug("termino  grafico"+orden);
                        // <editor-fold defaultstate="collapsed" desc="nueva pagina blanco">
                            cantidadAlturaPixelesPorHoja = ALTURA_PIXELES_MAXIMO;
                            image=new BufferedImage(1054,cantidadAlturaPixelesPorHoja, BufferedImage.TYPE_INT_RGB);
                            grafico=image.getGraphics();
                            grafico.setColor(Color.white);
                            grafico.fillRect(0, 0, 1054, cantidadAlturaPixelesPorHoja);
                        //</editor-fold>
                        cooryProceso=10;
                        coorySubProceso=0;
                        if(ultimoProceso.y  > 0 )
                        {
                            this.dibujarNodo(coorXProceso+230, cooryProceso, subNodos[orden]);
                            ultimoProceso=new Point(coorXProceso+240,cooryProceso+20);
                            orden++;
                        }
                        cooryProceso+=55;
                        coorySubProceso=cooryProceso;
                        
                    }
                    //</editor-fold>
                    coorYNodo=cooryProceso;
                    // <editor-fold defaultstate="collapsed" desc="dibujando conector si aplica">
                        if(ultimoProceso.y > 0)
                        {
                            this.dibujarFlecha(ultimoProceso.x, ultimoProceso.y, ultimoProceso.x, cooryProceso);
                        }
                    //</editor-fold>

                    // <editor-fold defaultstate="collapsed" desc="dibujando conector destino si aplica">
                        for(int i=0;i<codProcesosDestino.size();i++)
                        {
                            if(codProcesosDestino.get(i).getCodProcesoDestino()==res.getInt("COD_PROCESO_PREPARADO_PRODUCTO"))
                            {
                                grafico.setColor(coloresDestinoList.get(i));

                                grafico.fillRect(coordenadasPuntoDestino.get(i).x,coordenadasPuntoDestino.get(i).y,2,12);
                                grafico.fillRect((i+1)*4,coordenadasPuntoDestino.get(i).y+10,coordenadasPuntoDestino.get(i).x-((i+1)*4),2);
                                grafico.fillRect((i+1)*4,coordenadasPuntoDestino.get(i).y+10,2,(coorYNodo-20-(i*4))-coordenadasPuntoDestino.get(i).y);
                                grafico.fillRect((i+1)*4,coorYNodo-10-(i*4),coorXProceso+90-(i+1)*4,2);
                                grafico.fillRect(coorXProceso+90,coorYNodo-10-(i*4),2,2+(i*4));


                                int[] pointsx={coorXProceso+90,coorXProceso+98,coorXProceso+82};
                                int[] pointsy={coorYNodo,coorYNodo-8,coorYNodo-8};
                                grafico.fillPolygon(pointsx,pointsy, 3);
                                codProcesosDestino.get(i).setCodProcesoDestino(-1);
                                //dibujando proceso
                                int cantidadPixelesDescripcionEnlace=codProcesosDestino.get(i).getDescripcionEnlace().length()*7;
                                grafico.fillRect(coorXProceso-60-cantidadPixelesDescripcionEnlace,coorYNodo-20-(i*4),cantidadPixelesDescripcionEnlace,20);
                                grafico.setColor(Color.WHITE);
                                grafico.drawString(codProcesosDestino.get(i).getDescripcionEnlace(),coorXProceso-50-cantidadPixelesDescripcionEnlace,coorYNodo-(i*4)-6);

                            }
                        }
                    //</editor-fold>
                    if(res.getInt("COD_ACTIVIDAD_PREPARADO")==4)//verificando si es aforar para dibujar tabla de rpm
                    {
                        //<editor-fold desc="dibujando rpm maquinaria" defaultstate="collapsed">
                            Statement stm=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                            StringBuilder consultaMaquinaria=new StringBuilder("select top 1 c.COD_FORMA");
                                                    consultaMaquinaria.append(" from COMPONENTES_PROD_VERSION c");
                                                    consultaMaquinaria.append(" where c.COD_VERSION=").append(codVersion);
                                                            consultaMaquinaria.append(" and c.COD_FORMA in (2,25,27)");
                            ResultSet resm=stm.executeQuery(consultaMaquinaria.toString());
                            if(resm.next())
                            {
                                    consultaMaquinaria=new StringBuilder(" select m.NOMBRE_MAQUINA,mr.DESCRIPCION_MAQUINARIA_RPM,");
                                                        consultaMaquinaria.append(" mrd.NRO_MAQUINARIA_RPM_DETALLE,mrd.VALOR_MINIMO,mrd.VALOR_MAXIMO,mrd.COD_TIPO_DESCRIPCION,");
                                                        consultaMaquinaria.append(" mrd.VALOR_MAXIMO,mrd.VALOR_MINIMO");
                                                consultaMaquinaria.append(" from MAQUINARIAS_RPM mr ");
                                                        consultaMaquinaria.append(" inner join MAQUINARIAS m on m.COD_MAQUINA=mr.COD_MAQUINARIA");
                                                        consultaMaquinaria.append(" inner join MAQUINARIAS_RPM_DETALLE mrd on mr.COD_MAQUINARIA_RPM=mrd.COD_MAQUINARIA_RPM");
                                                consultaMaquinaria.append(" where mr.COD_ESTADO_REGISTRO=1");
                                                consultaMaquinaria.append(" order by m.NOMBRE_MAQUINA,mrd.NRO_MAQUINARIA_RPM_DETALLE");
                                    LOGGER.debug("consulta tabla revolucion maquinaia "+consultaMaquinaria.toString());
                                    resm=stm.executeQuery(consultaMaquinaria.toString());
                                    resm.last();
                                    Color colorDescripcionRpm=new Color(186,217,228);
                                    Color colorlineaDescripcionRpm=new Color(112,148,162);
                                    grafico.setColor(colorDescripcionRpm);
                                    Double cantidad=resm.getRow()/2d;
                                    cantidad=Math.ceil(cantidad);

                                    grafico.fillRoundRect(coorXSubProceso,cooryProceso+2,400,(cantidad.intValue()*18)+60,5,5);
                                    grafico.setColor(colorlineaDescripcionRpm);
                                    grafico.drawRoundRect(coorXSubProceso,cooryProceso+2,400,(cantidad.intValue()*18)+60,5,5);
                                    int cooryMaquinaria=cooryProceso;
                                    String descripcionRpm="";
                                    if(resm.first())
                                    {
                                        grafico.setColor(Color.BLACK);
                                        grafico.setFont(fuenteBold);
                                        grafico.drawString("MAQUINARIA :"+resm.getString("NOMBRE_MAQUINA"),coorXSubProceso+200-("MAQUINARIA :"+resm.getString("NOMBRE_MAQUINA")).length()*3,cooryProceso+18);
                                        grafico.drawString(resm.getString("DESCRIPCION_MAQUINARIA_RPM"),coorXSubProceso+200-resm.getString("DESCRIPCION_MAQUINARIA_RPM").length()*3,cooryProceso+36);
                                        grafico.drawString("N°",coorXSubProceso+24,cooryProceso+54);
                                        grafico.drawString("N°",coorXSubProceso+224,cooryProceso+54);
                                        grafico.drawString("RPM",coorXSubProceso+120,cooryProceso+54);
                                        grafico.drawString("RPM",coorXSubProceso+320,cooryProceso+54);
                                        grafico.setFont(fuenteBold);
                                        grafico.drawString(resm.getString("NRO_MAQUINARIA_RPM_DETALLE"),coorXSubProceso+24,cooryProceso+73);
                                        descripcionRpm=resm.getDouble("VALOR_MINIMO")+"  -  "+resm.getDouble("VALOR_MAXIMO");
                                        grafico.drawString(descripcionRpm,coorXSubProceso+120-(descripcionRpm.length()*3),cooryProceso+73);
                                        if(resm.next())
                                        {
                                            descripcionRpm=resm.getDouble("VALOR_MINIMO")+"  -  "+resm.getDouble("VALOR_MAXIMO");
                                            grafico.drawString(resm.getString("NRO_MAQUINARIA_RPM_DETALLE"),coorXSubProceso+224,cooryProceso+73);
                                            grafico.drawString(descripcionRpm,coorXSubProceso+320-(descripcionRpm.length()*3),cooryProceso+73);
                                        }
                                        grafico.setColor(colorlineaDescripcionRpm);
                                        grafico.drawRect(coorXSubProceso,cooryProceso+39,50,18);
                                        grafico.drawRect(coorXSubProceso+50,cooryProceso+39,150,18);
                                        grafico.drawRect(coorXSubProceso+200,cooryProceso+39,50,18);
                                        grafico.drawRect(coorXSubProceso+250,cooryProceso+39,150,18);
                                        grafico.drawRect(coorXSubProceso,cooryProceso+57,50,18);
                                        grafico.drawRect(coorXSubProceso+50,cooryProceso+57,150,18);
                                        grafico.drawRect(coorXSubProceso+200,cooryProceso+57,50,18);
                                        grafico.drawRect(coorXSubProceso+250,cooryProceso+57,150,18);
                                        cooryMaquinaria+=75;
                                    }
                                    while(resm.next())
                                    {
                                        grafico.setColor(colorlineaDescripcionRpm);
                                        grafico.drawRect(coorXSubProceso,cooryMaquinaria,50,18);
                                        grafico.drawRect(coorXSubProceso+50,cooryMaquinaria,150,18);
                                        grafico.drawRect(coorXSubProceso+200,cooryMaquinaria,50,18);
                                        grafico.drawRect(coorXSubProceso+250,cooryMaquinaria,150,18);
                                        cooryMaquinaria+=18;
                                        grafico.setColor(Color.BLACK);
                                        grafico.drawString(resm.getString("NRO_MAQUINARIA_RPM_DETALLE"),coorXSubProceso+24,cooryMaquinaria-2);
                                        descripcionRpm=resm.getDouble("VALOR_MINIMO")+"  -  "+resm.getDouble("VALOR_MAXIMO");
                                        grafico.drawString(descripcionRpm,coorXSubProceso+120-(descripcionRpm.length()*3),cooryMaquinaria-2);
                                        if(resm.next())
                                        {
                                            descripcionRpm=resm.getDouble("VALOR_MINIMO")+"  -  "+resm.getDouble("VALOR_MAXIMO");
                                            grafico.drawString(resm.getString("NRO_MAQUINARIA_RPM_DETALLE"),coorXSubProceso+224,cooryMaquinaria-2);
                                            grafico.drawString(descripcionRpm,coorXSubProceso+320-(descripcionRpm.length()*3),cooryMaquinaria-2);
                                        }
                                    }
                            }
                        //</editor-fold>
                    }
                    // <editor-fold defaultstate="collapsed" desc="dibujando cabecera">
                        grafico.setColor(colorCabecera);
                        grafico.fillRoundRect(coorXProceso+5,cooryProceso+3, 490,50, 10, 10);
                        grafico.setColor(colorBordeCabecera);
                        grafico.drawRoundRect(coorXProceso+5,cooryProceso+3, 490,50, 10, 10);
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
                        if(res.getInt("cantidadMaquinarias")>0)
                        {
                            coorYaux=cooryProceso;
                            pstMaquina.setInt(1,res.getInt("COD_PROCESO_PREPARADO_PRODUCTO"));
                            resDetalle=pstMaquina.executeQuery();
                            resDetalle.last();
                            grafico.setColor(colorMaquinaria);
                            grafico.fillRoundRect(coorXProceso+5,coorYaux, 490,5+((resDetalle.getRow()+res.getInt("cantidadMaquinarias")+1)*15), 8, 8);
                            grafico.setColor(colorBordeMaquinaria);
                            grafico.drawRoundRect(coorXProceso+5,coorYaux, 490,5+((resDetalle.getRow()+res.getInt("cantidadMaquinarias")+1)*15), 8, 8);
                            cooryProceso+=15;
                            grafico.setColor(Color.BLACK);
                            grafico.setFont(fuenteBold);
                            grafico.drawString("MAQUINARIAS:",coorXProceso+10,cooryProceso);

                            resDetalle.absolute(0);

                            codMaquinaCabecera=0;
                            while(resDetalle.next())
                            {

                                if(codMaquinaCabecera!=resDetalle.getInt("COD_MAQUINA"))
                                {
                                    codMaquinaCabecera=resDetalle.getInt("COD_MAQUINA");
                                    cooryProceso+=15;
                                    grafico.setFont(fuenteBold);
                                    grafico.drawString("-"+resDetalle.getString("NOMBRE_MAQUINA")+" ("+resDetalle.getString("CODIGO")+")",coorXProceso+15,cooryProceso);
                                }
                                cooryProceso+=15;
                                if(resDetalle.getInt("COD_ESPECIFICACION_PROCESO")>0)
                                {

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
                                    if(resDetalle.getInt("COD_ESPECIFICACION_PROCESO")==135)
                                    {
                                        consulta=new StringBuilder("select  sum((fmd.CANTIDAD*(pp.CANT_LOTE_PRODUCCION/fmv.CANTIDAD_LOTE)/(case when fmd.COD_UNIDAD_MEDIDA = 7 then 1000 else 1 end))) as cantidadProducto");
                                                consulta.append(" from PROGRAMA_PRODUCCION pp");
                                                consulta.append(" inner join FORMULA_MAESTRA_VERSION fmv on fmv.COD_VERSION=pp.COD_FORMULA_MAESTRA_VERSION");
                                                consulta.append(" inner join FORMULA_MAESTRA_DETALLE_MP_VERSION fmd on fmd.COD_VERSION=pp.COD_FORMULA_MAESTRA_VERSION");
                                                consulta.append(" where pp.COD_LOTE_PRODUCCION='").append(codLoteProduccion).append("'");
                                                consulta.append(" and pp.COD_PROGRAMA_PROD=").append(codProgramaProd);
                                        LOGGER.debug("consulta cantidad aforo "+consulta.toString());
                                        Statement stPisc=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                        ResultSet resPisc=stPisc.executeQuery(consulta.toString());
                                        if(resPisc.next())descripcion="Igual a "+format.format(resPisc.getDouble("cantidadProducto"));
                                    }
                                    //</editor-fold>
                                    grafico.drawString(resDetalle.getString("NOMBRE_ESPECIFICACIONES_PROCESO")+" : "+descripcion+(resDetalle.getString("ABREVIATURA").length()>0?" ("+resDetalle.getString("ABREVIATURA")+")":"")+(resDetalle.getDouble("PORCIENTO_TOLERANCIA")>0?" ±"+format.format(resDetalle.getDouble("PORCIENTO_TOLERANCIA"))+" %":""),coorXProceso+20, cooryProceso);
                                }
                            }
                            cooryProceso+=15;
                        }

                    //</editor-fold>    

                    // <editor-fold defaultstate="collapsed" desc="dibujando materiales">
                    pstMaterial.setInt(1,res.getInt("COD_PROCESO_PREPARADO_PRODUCTO"));LOGGER.info("PAA_PROCESOS_PREPARADO_PRODUCTO_CONSUMO_MATERIAL p1:"+res.getInt("COD_PROCESO_PREPARADO_PRODUCTO"));
                    resDetalle=pstMaterial.executeQuery();
                    if(resDetalle.last())
                    {
                        grafico.setColor(colorMaterial);
                        grafico.fillRoundRect(coorXProceso+5,cooryProceso, 490,(resDetalle.getRow()*15)+19, 12,12);
                        grafico.setColor(colorBordeMaterial);
                        grafico.drawRoundRect(coorXProceso+5,cooryProceso, 490,(resDetalle.getRow()*15)+19, 12,12);
                        cooryProceso+=15;
                        grafico.setFont(fuenteBold);
                        grafico.setColor(Color.BLACK);
                        grafico.drawString("Materiales",coorXProceso+10, cooryProceso);
                        grafico.setFont(fuente);
                        resDetalle.absolute(0);
                        while(resDetalle.next())
                        {
                            cooryProceso+=15;
                            grafico.drawString(resDetalle.getString("NOMBRE_MATERIAL")+(resDetalle.getInt("COD_MATERIAL")>0?" :  "+format.format(resDetalle.getDouble("CANTIDAD"))+" "+resDetalle.getString("ABREVIATURA"):""),coorXProceso+15,cooryProceso);
                        }
                        cooryProceso+=15;
                    }
                    //</editor-fold>
                    // <editor-fold defaultstate="collapsed" desc="dibujando sustancia resultante">
                        if(res.getString("SUSTANCIA_RESULTANTE").length()>0)
                        {
                            grafico.setColor(colorSustanciaResultante);
                            grafico.fillRoundRect(coorXProceso+5,cooryProceso, 490,34, 0,0);
                            grafico.setColor(colorBordeSustanciaResultante);
                            grafico.drawRoundRect(coorXProceso+5,cooryProceso, 490,34, 0,0);
                            cooryProceso+=15;
                            grafico.setFont(fuenteBold);
                            grafico.setColor(Color.BLACK);
                            grafico.drawString("Combinación Resultante:",coorXProceso+10, cooryProceso);
                            grafico.setFont(fuente);
                            cooryProceso+=15;
                            grafico.drawString(res.getString("SUSTANCIA_RESULTANTE"),coorXProceso+15, cooryProceso);
                            cooryProceso+=15;
                        }
                    //</editor-fold>
                    // <editor-fold defaultstate="collapsed" desc="dibujando descripcion">
                        if(res.getString("DESCRIPCION").length()>0)
                        {
                            grafico.setColor(colorDescripcion);
                            grafico.fillRoundRect(coorXProceso+5,cooryProceso, 490,(45)+19, 12,12);
                            grafico.setColor(colorBordeDescripcion);
                            grafico.drawRoundRect(coorXProceso+5,cooryProceso, 490,(45)+19, 12,12);
                            cooryProceso+=15;
                            grafico.setFont(fuenteBold);
                            grafico.setColor(Color.BLACK);
                            grafico.drawString("Descripción:",coorXProceso+10, cooryProceso);
                            StringTokenizer stt=new StringTokenizer(res.getString("DESCRIPCION")," ", true);
                            String descripcion="";
                            grafico.setFont(fuente);
                            int cont=2;
                            while(stt.hasMoreTokens())
                            {
                                String token=stt.nextToken();
                                if((descripcion+token).length()<=80)
                                {
                                    descripcion=descripcion+token;
                                }
                                else
                                {
                                    cooryProceso+=15;
                                    cont--;
                                    grafico.drawString(descripcion,coorXProceso+10, cooryProceso);
                                    descripcion=token;
                                }
                            }
                            cooryProceso+=15;
                            grafico.drawString(descripcion,coorXProceso+10, cooryProceso);
                            cooryProceso+=(cont*15);
                            cooryProceso+=15;
                        }
                    //</editor-fold>



                    //<editor-fold defaultstate="collapsed" desc="dibujando datos para relleno">
                    cooryProceso+=10;
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
                            grafico.fillRect(ultimoSubProceso.x,ultimoSubProceso.y,2,coorYNodo-ultimoSubProceso.y-20);
                            grafico.fillRect(ultimoSubProceso.x+390,coorYNodo-20,2,20);
                            grafico.fillRect(ultimoSubProceso.x,coorYNodo-20,390,2);
                            int[] pointsx={ultimoSubProceso.x+390,ultimoSubProceso.x+398,ultimoSubProceso.x+382};
                            int[] pointsy={coorYNodo,coorYNodo-8,coorYNodo-8};
                            grafico.fillPolygon(pointsx,pointsy, 3);
                        }
                    //</editor-fold>
                    if(res.getBoolean("PROCESO_SECUENCIAL"))
                        ultimoProceso=new Point(coorXProceso+240,cooryProceso);
                    else
                        ultimoProceso = new Point(0,0);
                    ultimoSubProceso=null;
                    grafico.drawRoundRect(coorXProceso,coorYNodo,500,cooryProceso-coorYNodo,12,12);
                    cooryProceso+=40;
                    // <editor-fold defaultstate="collapsed" desc="subProcesos">
                        pstSubProceso.setInt(1,res.getInt("COD_PROCESO_PREPARADO_PRODUCTO"));
                        resSubProceso=pstSubProceso.executeQuery();
                        while(resSubProceso.next())
                        {
                            // <editor-fold defaultstate="collapsed" desc="verificando nueva hoja">
                                if(coorySubProceso+420 >= cantidadAlturaPixelesPorHoja)
                                {
                                    if(ultimoSubProceso == null)
                                    {
                                        this.dibujarFlecha(coorXSubProceso+240, coorYNodo+100, coorXSubProceso+240, cantidadAlturaPixelesPorHoja - 50);
                                    }
                                    else
                                    {
                                        if(ultimoSubProceso.y>0)
                                        {
                                            this.dibujarFlecha(ultimoSubProceso.x, ultimoSubProceso.y, ultimoSubProceso.x, cantidadAlturaPixelesPorHoja - 50);
                                        }
                                    }
                                    if(ultimoProceso.y>0)
                                    {
                                        this.dibujarFlecha(ultimoProceso.x, ultimoProceso.y, ultimoProceso.x, cantidadAlturaPixelesPorHoja - 50);
                                        this.dibujarNodo(coorXProceso+230, cantidadAlturaPixelesPorHoja - 50 , subNodos[orden]);
                                        orden ++;
                                    }

                                    // <editor-fold defaultstate="collapsed" desc="dibujando conector destino siguiente hoja">
                                        for(int i=0;i<codProcesosDestino.size();i++)
                                        {
                                            if(codProcesosDestino.get(i).getCodProcesoDestino()>0)
                                            {
                                                grafico.setColor(coloresDestinoList.get(i));
                                                grafico.fillRect(coordenadasPuntoDestino.get(i).x,coordenadasPuntoDestino.get(i).y,2,12);
                                                grafico.fillRect((i+1)*4,coordenadasPuntoDestino.get(i).y+10,coordenadasPuntoDestino.get(i).x-((i+1)*4),2);
                                                grafico.fillRect((i+1)*4,coordenadasPuntoDestino.get(i).y+10,2,1235-coordenadasPuntoDestino.get(i).y);
                                                coordenadasPuntoDestino.get(i).y=15;
                                                coordenadasPuntoDestino.get(i).x=(i+1)*4;
                                            }
                                        }
                                    //</editor-fold>
                                    // <editor-fold defaultstate="collapsed" desc="dibujando nodo final pagina">
                                        this.dibujarNodo(coorXSubProceso+230, cantidadAlturaPixelesPorHoja - 50 ,subNodos[orden]);
                                    //</editor-fold>
                                    
                                    LOGGER.debug("inicio final guardado");
                                    File ftemp=File.createTempFile("imagenPrueba"+orden, ".jpg");
                                    ImageIO.write(image,"jpg",ftemp);
                                    FileInputStream input=new FileInputStream(ftemp);
                                    pst.setBinaryStream(1,input);
                                    pst.setInt(2,orden);
                                    if(pst.executeUpdate()>0)LOGGER.info("se registro la imagen medio");

                                    
                                    // <editor-fold defaultstate="collapsed" desc="dibujando fondo blanco">
                                        cantidadAlturaPixelesPorHoja = ALTURA_PIXELES_MAXIMO;
                                        image=new BufferedImage(1054,cantidadAlturaPixelesPorHoja, BufferedImage.TYPE_INT_RGB);
                                        grafico=image.getGraphics();
                                        cooryProceso=0;
                                        coorySubProceso=0;
                                        grafico.setColor(Color.white);
                                        grafico.fillRect(0, 0, 1054, cantidadAlturaPixelesPorHoja);
                                    //</editor-fold>
                                    cooryProceso += 10;
                                    //dibujando nodo inicio pagina
                                    this.dibujarNodo(coorXSubProceso+230, cooryProceso,subNodos[orden]);
                                    ultimoSubProceso =  new Point(coorXSubProceso + 240,cooryProceso+20);
                                    if(ultimoProceso.y>0)
                                    {
                                        this.dibujarNodo(coorXProceso+230, cooryProceso, subNodos[orden-1]);
                                        ultimoProceso = new Point(coorXProceso+240,cooryProceso+20);
                                    }
                                    orden ++;
                                    cooryProceso+=55;
                                    coorySubProceso=cooryProceso;
                                }
                            //</editor-fold>
                            // <editor-fold defaultstate="collapsed" desc="dibujando conectores">
                            if(ultimoSubProceso!=null)
                            {
                                this.dibujarFlecha(ultimoSubProceso.x, ultimoSubProceso.y, ultimoSubProceso.x, coorySubProceso);
                            }

                            //</editor-fold>
                            // <editor-fold defaultstate="collapsed" desc="dibujando cabecera">
                                coorYNodo=coorySubProceso;
                                grafico.setColor(colorCabecera);
                                grafico.fillRoundRect(coorXSubProceso+5,coorySubProceso+3, 490,50, 10, 10);
                                grafico.setColor(colorBordeCabecera);
                                grafico.drawRoundRect(coorXSubProceso+5,coorySubProceso+3, 490,50, 10, 10);
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
                            if(res.getInt("cantidadMaquinarias")>0)
                            {
                                coorySubProceso+=15;
                                coorYaux=coorySubProceso;
                                grafico.setFont(fuenteBold);
                                pstMaquina.setInt(1,resSubProceso.getInt("COD_PROCESO_PREPARADO_PRODUCTO"));
                                LOGGER.debug("pstMaquina p1:"+resSubProceso.getInt("COD_PROCESO_PREPARADO_PRODUCTO"));
                                resDetalle=pstMaquina.executeQuery();
                                resDetalle.last();
                                grafico.setColor(colorMaquinaria);
                                grafico.fillRoundRect(coorXSubProceso+5,coorYaux, 490,5+((resDetalle.getRow()+resSubProceso.getInt("cantidadMaquinarias")+1)*15), 8, 8);
                                grafico.setColor(colorBordeMaquinaria);
                                grafico.drawRoundRect(coorXSubProceso+5,coorYaux, 490,5+((resDetalle.getRow()+resSubProceso.getInt("cantidadMaquinarias")+1)*15), 8, 8);
                                coorySubProceso+=15;
                                grafico.setFont(fuenteBold);
                                grafico.setColor(Color.BLACK);
                                grafico.drawString("MAQUINARIAS:",coorXSubProceso+10,coorySubProceso);
                                resDetalle.absolute(0);
                                codMaquinaCabecera=0;
                                while(resDetalle.next())
                                {

                                    if(codMaquinaCabecera!=resDetalle.getInt("COD_MAQUINA"))
                                    {
                                        codMaquinaCabecera=resDetalle.getInt("COD_MAQUINA");
                                        coorySubProceso+=15;
                                        grafico.setFont(fuenteBold);
                                        grafico.drawString("-"+resDetalle.getString("NOMBRE_MAQUINA"),coorXSubProceso+15,coorySubProceso);
                                    }
                                    coorySubProceso+=15;
                                    if(resDetalle.getInt("COD_ESPECIFICACION_PROCESO")>0)
                                    {

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
                                        grafico.drawString(resDetalle.getString("NOMBRE_ESPECIFICACIONES_PROCESO")+" : "+descripcion+(resDetalle.getString("ABREVIATURA").length()>0?" ("+resDetalle.getString("ABREVIATURA")+")":"")+(resDetalle.getDouble("PORCIENTO_TOLERANCIA")>0?" ±"+format.format(resDetalle.getDouble("PORCIENTO_TOLERANCIA"))+" %":""),coorXSubProceso+20, coorySubProceso);
                                    }
                                }
                                coorySubProceso+=15;
                            }
                        //</editor-fold>      
                            // <editor-fold defaultstate="collapsed" desc="dibujando materiales">
                                pstMaterial.setInt(1,resSubProceso.getInt("COD_PROCESO_PREPARADO_PRODUCTO"));
                                resDetalle=pstMaterial.executeQuery();
                                if(resDetalle.last())
                                {
                                    grafico.setColor(colorMaterial);
                                    grafico.fillRoundRect(coorXSubProceso+5,coorySubProceso, 490,(resDetalle.getRow()*15)+19, 12,12);
                                    grafico.setColor(colorBordeMaterial);
                                    grafico.drawRoundRect(coorXSubProceso+5,coorySubProceso, 490,(resDetalle.getRow()*15)+19, 12,12);
                                    coorySubProceso+=15;
                                    grafico.setFont(fuenteBold);
                                    grafico.setColor(Color.BLACK);
                                    grafico.drawString("Materiales",coorXSubProceso+10, coorySubProceso);
                                    grafico.setFont(fuente);
                                    resDetalle.absolute(0);
                                    while(resDetalle.next())
                                    {
                                        coorySubProceso+=15;
                                        grafico.drawString(resDetalle.getString("NOMBRE_MATERIAL")+(resDetalle.getInt("COD_MATERIAL")>0?" : "+resDetalle.getString("CANTIDAD")+" "+resDetalle.getString("ABREVIATURA"):""),coorXSubProceso+15,coorySubProceso);
                                    }

                                    coorySubProceso+=15;
                                }

                                //</editor-fold>    
                            // <editor-fold defaultstate="collapsed" desc="dibujando sustancia resultante">
                            System.out.println("ds "+resSubProceso.getString("SUSTANCIA_RESULTANTE"));
                                if(resSubProceso.getString("SUSTANCIA_RESULTANTE").length()>0)
                                {
                                    grafico.setColor(colorSustanciaResultante);
                                    grafico.fillRoundRect(coorXSubProceso+5,coorySubProceso, 490,34, 0,0);
                                    grafico.setColor(colorBordeSustanciaResultante);
                                    grafico.drawRoundRect(coorXSubProceso+5,coorySubProceso, 490,34, 0,0);
                                    coorySubProceso+=15;
                                    grafico.setFont(fuenteBold);
                                    grafico.setColor(Color.BLACK);
                                    grafico.drawString("Combinación Resultante:",coorXSubProceso+10, coorySubProceso);
                                    grafico.setFont(fuente);
                                    coorySubProceso+=15;
                                    grafico.drawString(resSubProceso.getString("SUSTANCIA_RESULTANTE"),coorXSubProceso+15, coorySubProceso);
                                    coorySubProceso+=15;
                                }
                            //</editor-fold>
                            // <editor-fold defaultstate="collapsed" desc="dibujando descripcion">
                                if(resSubProceso.getString("DESCRIPCION").length()>0)
                                {
                                    grafico.setColor(colorDescripcion);
                                    grafico.fillRoundRect(coorXSubProceso+5,coorySubProceso, 490,(45)+19, 12,12);
                                    grafico.setColor(colorBordeDescripcion);
                                    grafico.drawRoundRect(coorXSubProceso+5,coorySubProceso, 490,(45)+19, 12,12);
                                    coorySubProceso+=15;
                                    grafico.setFont(fuenteBold);
                                    grafico.setColor(Color.BLACK);
                                    grafico.drawString("Descripción:",coorXSubProceso+10, coorySubProceso);
                                    StringTokenizer stt=new StringTokenizer(resSubProceso.getString("DESCRIPCION")," ", true);
                                    String descripcion="";
                                    grafico.setFont(fuente);
                                    int cont=2;
                                    while(stt.hasMoreTokens())
                                    {
                                        String token=stt.nextToken();
                                        if((descripcion+token).length()<=80)
                                        {
                                            descripcion=descripcion+token;
                                        }
                                        else
                                        {
                                            coorySubProceso+=15;
                                            cont--;
                                            grafico.drawString(descripcion,coorXSubProceso+10, coorySubProceso);
                                            descripcion=token;
                                        }
                                    }
                                    coorySubProceso+=15;
                                    grafico.drawString(descripcion,coorXSubProceso+10, coorySubProceso);
                                    coorySubProceso+=(cont*15);
                                    coorySubProceso+=15;
                                }
                            //</editor-fold>
                            //<editor-fold defaultstate="collapsed" desc="dibujando datos para relleno">
                            coorySubProceso+=10;
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
                                grafico.fillRect(coorXSubProceso+500,(coorYNodo+((coorySubProceso-coorYNodo)/2)),37,2);
                                int[] pointsx={coorXSubProceso+500,(coorXSubProceso+508),(coorXSubProceso+508)};
                                int[] pointsy={(coorYNodo+((coorySubProceso-coorYNodo)/2)),(coorYNodo+8+((coorySubProceso-coorYNodo)/2)),(coorYNodo-8+((coorySubProceso-coorYNodo)/2))};
                                grafico.fillPolygon(pointsx,pointsy, 3);
                            }
                            //</editor-fold>
                            coorySubProceso+=15;
                            grafico.drawRoundRect(coorXSubProceso,coorYNodo,500,coorySubProceso-coorYNodo,12,12);
                            if(resSubProceso.getInt("COD_PROCESO_PREPARADO_PRODUCTO_DESTINO")==0)
                            {
                                ultimoSubProceso=new Point(coorXSubProceso+240,coorySubProceso);
                            }
                            else
                            {
                                ultimoSubProceso=null;

                                codProcesosDestino.add(new ProcesoDestino(resSubProceso.getInt("COD_PROCESO_PREPARADO_PRODUCTO_DESTINO"),"( PASO: "+res.getString("NRO_PASO")+"."+resSubProceso.getString("NRO_PASO")+")   "+resSubProceso.getString("SUSTANCIA_RESULTANTE")));
                                coordenadasPuntoDestino.add(new Point(coorXSubProceso+240, coorySubProceso));
                            }
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
                LOGGER.debug("codAreaEmpresa: "+codAreaEmpresa);
                // <editor-fold defaultstate="collapsed" desc="descripcion caso liquidos no esteriles">
                if(codAreaEmpresa==80){
                    cooryProceso = cooryProceso > coorySubProceso ? cooryProceso:coorySubProceso;
                    Color colorDescripcionRpm=new Color(186,217,228);
                    Color colorCabeceraEsp=new Color(77,77,77);
                    Color colorTextoCabeceraEsp=new Color(255,255,255);
                    //1185
                    grafico.setColor(colorDescripcionRpm);
                    grafico.fillRoundRect(25,cooryProceso+10,430,75,5,5);
                    grafico.setColor(colorCabeceraEsp);
                    grafico.fillRoundRect(25,cooryProceso,430,20,5,5);
                    grafico.drawRoundRect(25,cooryProceso,430,85,5,5);
                    grafico.setFont(fuenteBold);
                    grafico.setColor(colorTextoCabeceraEsp);
                    grafico.drawString("Verificar que las medidas de los siguientes parametros se cumplan",30,cooryProceso + 15);
                    grafico.setColor(Color.BLACK);
                    grafico.setFont(fuente);
                    grafico.drawString("Distancia de la base del reactor a la parte inferior de la primera aspa 25 cm",30,cooryProceso +35);
                    grafico.drawString("Distancia entre aspas 50 cm",30,cooryProceso+55);
                    grafico.drawString("Distancia de la base del reactor a la parte inferior de la segunda aspa 81 cm",30,cooryProceso + 75);
                    grafico.setColor(colorCabeceraEsp);
                    grafico.drawLine(25, cooryProceso+39, 455, cooryProceso+39);
                    grafico.drawLine(25, cooryProceso+59, 455, cooryProceso+59);
                    cooryProceso+=90;
                    LOGGER.debug("entro generar liquidos no esteriles");
                }
                //</editor-fold>
                LOGGER.debug("termino generacion de imagenes");
                if(cooryProceso>0 || coorySubProceso>0)
                {
                    
                    BufferedImage nImg = new BufferedImage(1054,cooryProceso>coorySubProceso?cooryProceso:coorySubProceso,image.getType());
                    Graphics grafico1=nImg.getGraphics();
                    grafico1.drawImage(image, 0,0,null);
                    File ftemp=File.createTempFile("imagenPrueba"+orden, ".jpg");
                    ImageIO.write(nImg,"jpg",ftemp);
                    FileInputStream input=new FileInputStream(ftemp);
                    pst.setBinaryStream(1,input,ftemp.length());
                    pst.setInt(2,orden);
                    if(pst.executeUpdate()>0)LOGGER.info("se registro la imagen");
                    st.close();  
                }
                    LOGGER.debug("termino generacion de imagenes1");
            //</editor-fold>
        }
    }
    
}
