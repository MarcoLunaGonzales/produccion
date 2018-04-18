/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar;

import com.cofar.util.Util;
import java.io.File;
import java.io.FileOutputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import net.sf.jasperreports.engine.JRExporter;
import net.sf.jasperreports.engine.JRExporterParameter;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.export.JExcelApiExporterParameter;
import net.sf.jasperreports.engine.export.JRPdfExporter;
import net.sf.jasperreports.engine.export.JRXlsExporterParameter;
import net.sf.jasperreports.engine.export.ooxml.JRXlsxExporter;

/**
 *
 * @author DASISAQ-
 */
public class Main {

    public static void main(String[] args) {
        try{
            Map parameters = new HashMap();
            Connection con=null;
             Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
             String url="jdbc:sqlserver://172.16.10.21;user=sa;password=m0t1t4s@2009;databaseName=SARTORIUS";
             con=DriverManager.getConnection(url);
            SimpleDateFormat sdf =new SimpleDateFormat("yyyy/MM/dd HH:mm");
            parameters.put("COD_ALMACEN",1);
            parameters.put("COD_MATERIAL",1);    
            parameters.put("FECHA_INICIO", new Timestamp(sdf.parse("2017/01/01 00:00 ").getTime()));
            parameters.put("FECHA_FINAL",new Timestamp((new Date()).getTime()));
            parameters.put("dirLogoCofar","D:\\PROYECTOS\\ALMACENESV\\web\\img\\cofar.png");
            JasperPrint jasperPrint=JasperFillManager.fillReport("D:\\PROYECTOS\\ALMACENESV\\web\\reportes\\reporteKardexValoradoNuevo\\reporteKardexPdf.jasper",
                    parameters, con);
            String nombreTemp = "adjunto"+String.valueOf((new Date()).getTime());
            File ftemp=new File("D:\\prueba.xls");
            FileOutputStream fileOuputStream = new FileOutputStream(ftemp); 
            JRXlsxExporter xlsxExporter = new JRXlsxExporter();
            //xlsxExporter.setParameter(JRXlsExporterParameter.IGNORE_PAGE_MARGINS, Boolean.TRUE);
           /* xlsxExporter.setParameter(JRXlsExporterParameter.IS_ONE_PAGE_PER_SHEET, Boolean.FALSE);
            //xlsxExporter.setParameter(JRXlsExporterParameter.IS_AUTO_DETECT_CELL_TYPE, Boolean.TRUE);
            xlsxExporter.setParameter(JRXlsExporterParameter.IS_WHITE_PAGE_BACKGROUND, Boolean.FALSE);
            xlsxExporter.setParameter(JRXlsExporterParameter.IS_REMOVE_EMPTY_SPACE_BETWEEN_ROWS, Boolean.TRUE);
            xlsxExporter.setParameter(JExcelApiExporterParameter.IS_DETECT_CELL_TYPE, Boolean.TRUE);
            xlsxExporter.setParameter(JRXlsExporterParameter.IS_IGNORE_CELL_BORDER,Boolean.FALSE);     
            *///xlsxExporter.setParameter(JRXlsExporterParameter.IS_COLLAPSE_ROW_SPAN,Boolean.TRUE);   
            //xlsxExporter.setParameter(JRXlsExporterParameter.IS_IGNORE_GRAPHICS,Boolean.FALSE);
            //xlsxExporter.setParameter(JRXlsExporterParameter.MAXIMUM_ROWS_PER_SHEET,Boolean.TRUE);
            
            xlsxExporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
            xlsxExporter.setParameter(JRExporterParameter.OUTPUT_STREAM, fileOuputStream);
            xlsxExporter.exportReport();      
            fileOuputStream.close();
        }catch(Exception ex){
            ex.printStackTrace();
        }
               
        /*try {
             Connection con=null;
             Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
             String url="jdbc:sqlserver://172.16.10.21;user=sa;password=m0t1t4s@2009;databaseName=SARTORIUS";
             con=DriverManager.getConnection(url);
             con.setAutoCommit(false);
             String consulta="UPDATE FORMULA_MAESTRA_VERSION SET COD_ESTADO_VERSION_FORMULA_MAESTRA=6;"+
                             " UPDATE FORMULA_MAESTRA_VERSION_MODIFICACION SET COD_ESTADO_VERSION_FORMULA_MAESTRA=6;"+
                             " UPDATE COMPONENTES_PROD_VERSION_MODIFICACION SET COD_ESTADO_VERSION_COMPONENTES_PROD=6;"+
                             " UPDATE COMPONENTES_PROD_VERSION SET COD_ESTADO_VERSION=6;";
             PreparedStatement pst=con.prepareStatement(consulta);
             if(pst.executeUpdate()>0)System.out.println("se registro la transaccion a");

              consulta="select  max(c.COD_VERSION) as codVersionCP from COMPONENTES_PROD_VERSION c";
             int codVersionCP=0;
             Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
             ResultSet res=st.executeQuery(consulta);
             if(res.next())codVersionCP=res.getInt("codVersionCP");
             consulta="select max(f.COD_VERSION) as codVersionFm from FORMULA_MAESTRA_VERSION f ";
             int codVersionFM=0;
             res=st.executeQuery(consulta);
             if(res.next())codVersionFM=res.getInt("codVersionFm");
             int codFormulaMaestra=0;
             consulta="select max(f.COD_FORMULA_MAESTRA) as codFormulaMaestra from FORMULA_MAESTRA f ";
             res=st.executeQuery(consulta);
             if(res.next())codFormulaMaestra=res.getInt("codFormulaMaestra");
             consulta="select max(c.COD_COMPPROD) as COD_COMPPROD from COMPONENTES_PROD c ";
             int codCompProd=0;
             res=st.executeQuery(consulta);
             if(res.next())codCompProd=res.getInt("COD_COMPPROD");
             consulta="select max(p.COD_PRESENTACION_PRIMARIA) as codPresentacionPrimaria from PRESENTACIONES_PRIMARIAS p ";
             res=st.executeQuery(consulta);
             int codPresentacionPrimaria=0;
             if(res.next())codPresentacionPrimaria=res.getInt("codPresentacionPrimaria");
             consulta="select c.COD_COMPPROD" +
                      " ,isnull((select max(cpv.NRO_VERSION) from COMPONENTES_PROD_VERSION cpv where cpv.COD_COMPPROD=c.COD_COMPPROD),0)+1 as nroVersion"+
                      " from COMPONENTES_PROD c where c.COD_TIPO_PRODUCCION=1";
              res=st.executeQuery(consulta);
             Statement stDetalle=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
             ResultSet resDetalle=null;
             Statement stEsp=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
             ResultSet resEsp=null;
             SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
             
             while(res.next())
             {
                 //concentracion
                codVersionCP++;
                codVersionFM++;
                 //<editor-fold defaultstate="collapsed" desc="Especificaciones">
                consulta="SELECT V.COD_VERSION_ESPECIFICACION_PRODUCTO FROM VERSION_ESPECIFICACIONES_PRODUCTO v where V.COD_COMPPROD='"+res.getInt("COD_COMPPROD")+"' and  v.COD_TIPO_ANALISIS=0 and v.VERSION_ACTIVA=1";
                resEsp=stEsp.executeQuery(consulta);
                if(resEsp.next())
                {
                    consulta="INSERT INTO COMPONENTES_PROD_CONCENTRACION(COD_COMPPROD,COD_MATERIAL,CANTIDAD,COD_UNIDAD_MEDIDA,"+
                             " UNIDAD_PRODUCTO,COD_ESTADO_REGISTRO,NOMBRE_MATERIAL_EQUIVALENCIA,CANTIDAD_EQUIVALENCIA,COD_UNIDAD_MEDIDA_EQUIVALENCIA,COD_VERSION,COD_VERSION_ESPECIFICACION_PRODUCTO)"+
                             " select cpc.COD_COMPPROD,cpc.COD_MATERIAL,cpc.CANTIDAD,cpc.COD_UNIDAD_MEDIDA,"+
                             " cpc.UNIDAD_PRODUCTO,cpc.COD_ESTADO_REGISTRO,cpc.NOMBRE_MATERIAL_EQUIVALENCIA,"+
                             " cpc.CANTIDAD_EQUIVALENCIA,cpc.COD_UNIDAD_MEDIDA_EQUIVALENCIA,'"+codVersionCP+"',0"+
                             " from COMPONENTES_PROD_CONCENTRACION cpc where cpc.COD_VERSION_ESPECIFICACION_PRODUCTO='"+resEsp.getInt("COD_VERSION_ESPECIFICACION_PRODUCTO")+"'" +
                             " and cpc.cod_estado_registro=1";
                    System.out.println("consulta insertar copia concentracion "+consulta);
                    pst=con.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)System.out.println("se registro la copia de la concentración");
                }
                //fisicas
                consulta="SELECT V.COD_VERSION_ESPECIFICACION_PRODUCTO FROM VERSION_ESPECIFICACIONES_PRODUCTO v where V.COD_COMPPROD='"+res.getInt("COD_COMPPROD")+"' and  v.COD_TIPO_ANALISIS=1 and v.VERSION_ACTIVA=1";
                resEsp=stEsp.executeQuery(consulta);
                if(resEsp.next())
                {
                     consulta="INSERT INTO ESPECIFICACIONES_FISICAS_PRODUCTO(COD_PRODUCTO, COD_ESPECIFICACION,"+
                             " LIMITE_INFERIOR, LIMITE_SUPERIOR, DESCRIPCION, COD_REFERENCIA_CC, ESTADO,"+
                             " VALOR_EXACTO, COD_TIPO_ESPECIFICACION_FISICA, COD_VERSION,COD_VERSION_ESPECIFICACION_PRODUCTO)"+
                             " select efp.COD_PRODUCTO, efp.COD_ESPECIFICACION, efp.LIMITE_INFERIOR, efp.LIMITE_SUPERIOR,"+
                             " efp.DESCRIPCION, efp.COD_REFERENCIA_CC, efp.ESTADO, efp.VALOR_EXACTO,"+
                             " efp.COD_TIPO_ESPECIFICACION_FISICA, '"+codVersionCP+"',0"+
                             " from ESPECIFICACIONES_FISICAS_PRODUCTO efp where efp.COD_VERSION_ESPECIFICACION_PRODUCTO='"+resEsp.getInt("COD_VERSION_ESPECIFICACION_PRODUCTO")+"'" +
                             " and efp.ESTADO=1";
                    System.out.println("consulta insertar esp fisicas "+consulta);
                    pst=con.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)System.out.println("se registro la especificacion fisica");
                }
                consulta="SELECT V.COD_VERSION_ESPECIFICACION_PRODUCTO FROM VERSION_ESPECIFICACIONES_PRODUCTO v where V.COD_COMPPROD='"+res.getInt("COD_COMPPROD")+"' and  v.COD_TIPO_ANALISIS=2 and v.VERSION_ACTIVA=1";
                resEsp=stEsp.executeQuery(consulta);
                if(resEsp.next())
                {
                        consulta="INSERT INTO ESPECIFICACIONES_QUIMICAS_PRODUCTO(COD_ESPECIFICACION, COD_PRODUCTO,"+
                                 " COD_MATERIAL, LIMITE_INFERIOR, LIMITE_SUPERIOR, DESCRIPCION, ESTADO,"+
                                 " COD_REFERENCIA_CC, VALOR_EXACTO, COD_MATERIAL_COMPUESTO_CC, COD_VERSION,COD_VERSION_ESPECIFICACION_PRODUCTO)"+
                                 " select eqp.COD_ESPECIFICACION, eqp.COD_PRODUCTO, eqp.COD_MATERIAL, eqp.LIMITE_INFERIOR,"+
                                 " eqp.LIMITE_SUPERIOR, eqp.DESCRIPCION, eqp.ESTADO, eqp.COD_REFERENCIA_CC, eqp.VALOR_EXACTO,"+
                                 " eqp.COD_MATERIAL_COMPUESTO_CC,'"+codVersionCP+"',0"+
                                 " from ESPECIFICACIONES_QUIMICAS_PRODUCTO eqp where eqp.COD_VERSION_ESPECIFICACION_PRODUCTO='"+resEsp.getInt("COD_VERSION_ESPECIFICACION_PRODUCTO")+"'" +
                                 " and eqp.ESTADO=1";
                        System.out.println("consulta insertar especificaciones quimicas "+consulta);
                        pst=con.prepareStatement(consulta);
                        if(pst.executeUpdate()>0)System.out.println("se registraron las especificaciones quimicas");
                }
                consulta="SELECT V.COD_VERSION_ESPECIFICACION_PRODUCTO FROM VERSION_ESPECIFICACIONES_PRODUCTO v where V.COD_COMPPROD='"+res.getInt("COD_COMPPROD")+"' and  v.COD_TIPO_ANALISIS=3 and v.VERSION_ACTIVA=1";
                resEsp=stEsp.executeQuery(consulta);
                if(resEsp.next())
                {
                        consulta="INSERT INTO ESPECIFICACIONES_MICROBIOLOGIA_PRODUCTO(COD_COMPROD,"+
                                 " COD_ESPECIFICACION, LIMITE_INFERIOR, LIMITE_SUPERIOR, DESCRIPCION,"+
                                 " COD_REFERENCIA_CC, ESTADO, VALOR_EXACTO, COD_VERSION,COD_VERSION_ESPECIFICACION_PRODUCTO)"+
                                 " select  emp.COD_COMPROD, emp.COD_ESPECIFICACION, emp.LIMITE_INFERIOR, emp.LIMITE_SUPERIOR,"+
                                 " emp.DESCRIPCION, emp.COD_REFERENCIA_CC, emp.ESTADO, emp.VALOR_EXACTO, '"+codVersionCP+"',0"+
                                 " from ESPECIFICACIONES_MICROBIOLOGIA_PRODUCTO emp where emp.COD_VERSION_ESPECIFICACION_PRODUCTO='"+resEsp.getInt("COD_VERSION_ESPECIFICACION_PRODUCTO")+"'" +
                                 " and emp.ESTADO=1";
                        System.out.println("consulta insertar esp micro "+consulta);
                        pst=con.prepareStatement(consulta);
                        if(pst.executeUpdate()>0)System.out.println("se registraron las especificaciones microbio");
                }

                //</editor-fold>

                    consulta="select f.COD_FORMULA_MAESTRA,f.CANTIDAD_LOTE,f.COD_ESTADO_REGISTRO from FORMULA_MAESTRA f" +
                             " where f.COD_COMPPROD='"+res.getInt("COD_COMPPROD")+"'";
                    resDetalle=stDetalle.executeQuery(consulta);
                    if(resDetalle.next())
                    {
                       

                        consulta="INSERT INTO COMPONENTES_PROD_VERSION(COD_VERSION, COD_COMPPROD, COD_PROD,COD_FORMA, COD_ENVASEPRIM, COD_COLORPRESPRIMARIA, VOLUMENPESO_ENVASEPRIM,"+
                                 " CANTIDAD_COMPPROD, COD_AREA_EMPRESA, COD_SABOR, volumenpeso_aproximado,"+
                                 " COD_COMPUESTOPROD, nombre_prod_semiterminado, NOMBRE_GENERICO, REG_SANITARIO,"+
                                 " COD_LINEAMKT, COD_CATEGORIACOMPPROD, VIDA_UTIL, FECHA_VENCIMIENTO_RS,"+
                                 " COD_ESTADO_COMPPROD, RENDIMIENTO_PRODUCTO, COD_TIPO_PRODUCCION,"+
                                 " VOLUMEN_ENVASE_PRIMARIO, CONCENTRACION_ENVASE_PRIMARIO, PESO_ENVASE_PRIMARIO,"+
                                 " DIRECCION_ARCHIVO_REGISTRO_SANITARIO, COD_VIA_ADMINISTRACION_PRODUCTO,"+
                                 " CANTIDAD_VOLUMEN, COD_UNIDAD_MEDIDA_VOLUMEN, TOLERANCIA_VOLUMEN_FABRICAR,"+
                                 " COD_ESTADO_VERSION, NRO_VERSION, COD_TIPO_COMPPROD_FORMATO, FECHA_MODIFICACION,"+
                                 " COD_PERSONAL_CREACION, FECHA_INICIO_VIGENCIA,PRODUCTO_SEMITERMINADO,TAMANIO_LOTE_PRODUCCION," +
                                 " PRESENTACIONES_REGISTRADAS_RS,NOMBRE_COMERCIAL,COD_CONDICION_VENTA_PRODUCTO) " +
                                 " select "+codVersionCP+", cp.COD_COMPPROD, cp.COD_PROD,cp.COD_FORMA, cp.COD_ENVASEPRIM" +
                                 " , cp.COD_COLORPRESPRIMARIA, cp.VOLUMENPESO_ENVASEPRIM,"+
                                 " cp.CANTIDAD_COMPPROD, cp.COD_AREA_EMPRESA, cp.COD_SABOR, cp.volumenpeso_aproximado,"+
                                 " cp.COD_COMPUESTOPROD, cp.nombre_prod_semiterminado+' ("+resDetalle.getInt("CANTIDAD_LOTE")+")', cp.NOMBRE_GENERICO, cp.REG_SANITARIO,"+
                                 " cp.COD_LINEAMKT, cp.COD_CATEGORIACOMPPROD, cp.VIDA_UTIL, cp.FECHA_VENCIMIENTO_RS,"+
                                 " cp.COD_ESTADO_COMPPROD, cp.RENDIMIENTO_PRODUCTO, cp.COD_TIPO_PRODUCCION,"+
                                 " cp.VOLUMEN_ENVASE_PRIMARIO, cp.CONCENTRACION_ENVASE_PRIMARIO, cp.PESO_ENVASE_PRIMARIO,"+
                                 " cp.DIRECCION_ARCHIVO_REGISTRO_SANITARIO, cp.COD_VIA_ADMINISTRACION_PRODUCTO,"+
                                 " cp.CANTIDAD_VOLUMEN, cp.COD_UNIDAD_MEDIDA_VOLUMEN, cp.TOLERANCIA_VOLUMEN_FABRICAR,"+
                                 " 2,'"+res.getInt("nroVersion")+"', cp.COD_TIPO_COMPPROD_FORMATO,'"+sdf.format(new Date())+"',"+
                                 " '446','"+sdf.format(new Date())+"',cp.PRODUCTO_SEMITERMINADO" +
                                 " ,'"+resDetalle.getInt("CANTIDAD_LOTE")+"',cp.PRESENTACIONES_REGISTRADAS_RS,cp.NOMBRE_COMERCIAL" +
                                 " ,cp.COD_CONDICION_VENTA_PRODUCTO" +
                                 " FROM COMPONENTES_PROD cp where cp.COD_COMPPROD='"+res.getInt("COD_COMPPROD")+"'";
                                  System.out.println("consulta crear nueva version "+consulta);
                                pst=con.prepareStatement(consulta);
                                if(pst.executeUpdate()>0)System.out.println("se registro la nueva version");
                                 consulta="update COMPONENTES_PROD set TAMANIO_LOTE_PRODUCCION='"+resDetalle.getInt("CANTIDAD_LOTE")+"'"+
                                         " where COD_COMPPROD='"+res.getInt("COD_COMPPROD")+"'";
                                pst=con.prepareStatement(consulta);
                                if(pst.executeUpdate()>0)System.out.println("se registro el componentes prod");
                                consulta="INSERT INTO COMPONENTES_PROD_VERSION_MODIFICACION(COD_PERSONAL, COD_VERSION,"+
                                         " COD_ESTADO_VERSION_COMPONENTES_PROD,FECHA_INCLUSION_VERSION)"+
                                         " VALUES ('1195'," +
                                         " '"+codVersionCP+"',2,'"+sdf.format(new Date())+"')";
                                System.out.println("consulta insertar usuario modificacion "+consulta);
                                pst=con.prepareStatement(consulta);
                                if(pst.executeUpdate()>0)System.out.println("se registro el personal para la modificacion");
                                consulta="INSERT INTO COMPONENTES_PROD_VERSION_MODIFICACION(COD_PERSONAL, COD_VERSION,"+
                                         " COD_ESTADO_VERSION_COMPONENTES_PROD,FECHA_INCLUSION_VERSION)"+
                                         " VALUES ('446'," +
                                         " '"+codVersionCP+"',2,'"+sdf.format(new Date())+"')";
                                System.out.println("consulta insertar usuario modificacion "+consulta);
                                pst=con.prepareStatement(consulta);
                                if(pst.executeUpdate()>0)System.out.println("se registro el personal para la modificacion");
                                consulta="INSERT INTO COMPONENTES_PROD_VERSION_MODIFICACION(COD_PERSONAL, COD_VERSION,"+
                                         " COD_ESTADO_VERSION_COMPONENTES_PROD,FECHA_INCLUSION_VERSION)"+
                                         " VALUES ('1788'," +
                                         " '"+codVersionCP+"',2,'"+sdf.format(new Date())+"')";
                                System.out.println("consulta insertar usuario modificacion "+consulta);
                                pst=con.prepareStatement(consulta);
                                if(pst.executeUpdate()>0)System.out.println("se registro el personal para la modificacion");
                                consulta="INSERT INTO COMPONENTES_PROD_VERSION_MODIFICACION(COD_PERSONAL, COD_VERSION,"+
                                         " COD_ESTADO_VERSION_COMPONENTES_PROD,FECHA_INCLUSION_VERSION)"+
                                         " VALUES ('303'," +
                                         " '"+codVersionCP+"',2,'"+sdf.format(new Date())+"')";
                                System.out.println("consulta insertar usuario modificacion "+consulta);
                                pst=con.prepareStatement(consulta);
                                if(pst.executeUpdate()>0)System.out.println("se registro el personal para la modificacion");
                                consulta="INSERT INTO PRESENTACIONES_PRIMARIAS_VERSION(COD_VERSION,"+
                                         " COD_PRESENTACION_PRIMARIA, COD_COMPPROD, COD_ENVASEPRIM, CANTIDAD,"+
                                         " COD_TIPO_PROGRAMA_PROD, COD_ESTADO_REGISTRO, FECHA_MODIFICACION)"+
                                         " select '"+codVersionCP+"',pp.COD_PRESENTACION_PRIMARIA,pp.COD_COMPPROD,"+
                                         " pp.COD_ENVASEPRIM,pp.CANTIDAD,pp.COD_TIPO_PROGRAMA_PROD,pp.COD_ESTADO_REGISTRO,'"+sdf.format(new Date())+"'"+
                                         " from PRESENTACIONES_PRIMARIAS pp WHERE pp.COD_COMPPROD = '"+res.getInt("COD_COMPPROD")+"'";
                                System.out.println("consulta duplicar presentacion primaria "+consulta);
                                pst=con.prepareStatement(consulta);
                                if(pst.executeUpdate()>0)System.out.println("se registraron las presentaciones primarias");
                                
                                consulta="INSERT INTO COMPONENTES_PRESPROD_VERSION(COD_VERSION, COD_COMPPROD,"+
                                         " COD_PRESENTACION, CANT_COMPPROD, COD_TIPO_PROGRAMA_PROD, COD_ESTADO_REGISTRO)"+
                                         " select '"+codVersionCP+"',c.COD_COMPPROD,c.COD_PRESENTACION,c.CANT_COMPPROD,c.COD_TIPO_PROGRAMA_PROD,"+
                                         " c.COD_ESTADO_REGISTRO"+
                                         " from COMPONENTES_PRESPROD c where c.COD_COMPPROD='"+res.getInt("COD_COMPPROD")+"'";
                                System.out.println("consulta duplicar componentesPresProd "+consulta);
                                pst=con.prepareStatement(consulta);
                                if(pst.executeUpdate()>0)System.out.println("se registraron los componentes pres prod");


                                //fm
                                consulta="insert into FORMULA_MAESTRA_VERSION (COD_VERSION, COD_FORMULA_MAESTRA,COD_COMPPROD,CANTIDAD_LOTE,ESTADO_SISTEMA,"+
                                         " COD_ESTADO_REGISTRO,NRO_VERSION,FECHA_MODIFICACION,COD_ESTADO_VERSION_FORMULA_MAESTRA,COD_PERSONAL_CREACION,MODIFICACION_NF," +
                                         " MODIFICACION_MP_EP,MODIFICACION_ES,MODIFICACION_R,COD_COMPPROD_VERSION) select "+codVersionFM+",f.COD_FORMULA_MAESTRA,f.COD_COMPPROD,f.CANTIDAD_LOTE,f.ESTADO_SISTEMA"+
                                         " ,f.COD_ESTADO_REGISTRO,'"+res.getInt("nroVersion")+"','"+sdf.format(new Date())+"',2 ," +
                                         "446,0,1,1,1" +
                                         " ,'"+codVersionCP+"'"+
                                         " from FORMULA_MAESTRA f where f.COD_FORMULA_MAESTRA='"+resDetalle.getInt("COD_FORMULA_MAESTRA")+"'";
                                System.out.println("consulta insert copia cabecera "+consulta);
                                pst=con.prepareStatement(consulta);
                                if(pst.executeUpdate()>0)System.out.println("se inserto la cabecera de la version");

                                consulta="insert into FORMULA_MAESTRA_DETALLE_MP_VERSION (COD_VERSION,COD_FORMULA_MAESTRA,COD_MATERIAL,"+
                                         " CANTIDAD,COD_UNIDAD_MEDIDA,NRO_PREPARACIONES,FECHA_MODIFICACION)  select "+ codVersionFM+",f.COD_FORMULA_MAESTRA,f.COD_MATERIAL,f.CANTIDAD,"+
                                         " m.COD_UNIDAD_MEDIDA,f.NRO_PREPARACIONES,'"+sdf.format(new Date())+"'"+
                                         " from FORMULA_MAESTRA_DETALLE_MP f inner join materiales m on m.COD_MATERIAL=f.COD_MATERIAL" +
                                         " where f.COD_FORMULA_MAESTRA='"+resDetalle.getInt("COD_FORMULA_MAESTRA")+"' ";
                                System.out.println("consulta duplicar formula maestra detalle versione "+consulta);
                                pst=con.prepareStatement(consulta);
                                if(pst.executeUpdate()>0)System.out.println("se registraron la versiones detalle ");

                                consulta="insert into FORMULA_MAESTRA_DETALLE_MP_FRACCIONES_VERSION (COD_VERSION,COD_FORMULA_MAESTRA,COD_MATERIAL,"+
                                         " COD_FORMULA_MAESTRA_FRACCIONES,CANTIDAD,COD_TIPO_MATERIAL_PRODUCCION)" +
                                         " select "+codVersionFM+",f.COD_FORMULA_MAESTRA,f.COD_MATERIAL,f.COD_FORMULA_MAESTRA_FRACCIONES,f.CANTIDAD,F.COD_TIPO_MATERIAL_PRODUCCION"+
                                         " from FORMULA_MAESTRA_DETALLE_MP_FRACCIONES f where f.COD_FORMULA_MAESTRA='"+resDetalle.getInt("COD_FORMULA_MAESTRA")+"' ";
                                System.out.println("consulta duplicar fracciones detalle "+consulta);
                                pst=con.prepareStatement(consulta);
                                if(pst.executeUpdate()>0)System.out.println("se registro la version detalle fracciones");


                                consulta="INSERT INTO FORMULA_MAESTRA_DETALLE_EP_VERSION(COD_VERSION, COD_FORMULA_MAESTRA,"+
                                         " COD_PRESENTACION_PRIMARIA, COD_MATERIAL, CANTIDAD, COD_UNIDAD_MEDIDA)"+
                                         " select '"+codVersionFM+"',f.COD_FORMULA_MAESTRA,f.COD_PRESENTACION_PRIMARIA,f.COD_MATERIAL,f.CANTIDAD,m.COD_UNIDAD_MEDIDA"+
                                         " from FORMULA_MAESTRA_DETALLE_EP f inner join materiales m on m.COD_MATERIAL=f.COD_MATERIAL" +
                                         " where f.COD_FORMULA_MAESTRA='"+resDetalle.getInt("COD_FORMULA_MAESTRA")+"'";
                                         //" and f.COD_VERSION='"+codversionActiva+"'";
                                System.out.println("consulta duplicar ep "+consulta);
                                pst=con.prepareStatement(consulta);
                                if(pst.executeUpdate()>0)System.out.println("se duplicaron los ep");

                                consulta="INSERT INTO FORMULA_MAESTRA_DETALLE_ES_VERSION(COD_VERSION, COD_FORMULA_MAESTRA,"+
                                         " COD_MATERIAL, CANTIDAD, COD_UNIDAD_MEDIDA, COD_PRESENTACION_PRODUCTO,COD_TIPO_PROGRAMA_PROD)"+
                                         " select '"+codVersionFM+"',f.COD_FORMULA_MAESTRA,f.COD_MATERIAL,f.CANTIDAD,m.COD_UNIDAD_MEDIDA,"+
                                         " f.COD_PRESENTACION_PRODUCTO,f.COD_TIPO_PROGRAMA_PROD"+
                                         " from FORMULA_MAESTRA_DETALLE_ES f inner join materiales m on m.COD_MATERIAL=f.COD_MATERIAL " +
                                         " where f.COD_FORMULA_MAESTRA='"+resDetalle.getInt("COD_FORMULA_MAESTRA")+"'";
                                         //" and f.COD_VERSION='"+codversionActiva+"'";
                                System.out.println("consulta duplicar es "+consulta);
                                pst=con.prepareStatement(consulta);
                                if(pst.executeUpdate()>0)System.out.println("se duplicaron los es");

                                consulta="INSERT INTO FORMULA_MAESTRA_DETALLE_MR_VERSION(COD_VERSION, COD_FORMULA_MAESTRA,"+
                                         " COD_MATERIAL, CANTIDAD, COD_UNIDAD_MEDIDA, NRO_PREPARACIONES, COD_TIPO_MATERIAL,"+
                                         " COD_TIPO_ANALISIS_MATERIAL)"+
                                         " select '"+codVersionFM+"',f.COD_FORMULA_MAESTRA,f.COD_MATERIAL,f.CANTIDAD,m.COD_UNIDAD_MEDIDA,"+
                                         " f.NRO_PREPARACIONES,f.COD_TIPO_MATERIAL,f.COD_TIPO_ANALISIS_MATERIAL"+
                                         " from FORMULA_MAESTRA_DETALLE_MR f inner join materiales m on m.COD_MATERIAL=f.COD_MATERIAL" +
                                         " where f.COD_FORMULA_MAESTRA='"+resDetalle.getInt("COD_FORMULA_MAESTRA")+"' ";

                                System.out.println("consulta duplicar  mr "+consulta);
                                pst=con.prepareStatement(consulta);
                                if(pst.executeUpdate()>0)System.out.println("se duplicaron los mr");

                                consulta="INSERT INTO FORMULA_MAESTRA_MR_CLASIFICACION_VERSION(COD_VERSION,"+
                                         " COD_FORMULA_MAESTRA, COD_MATERIAL, COD_TIPO_ANALISIS_MATERIAL_REACTIVO)"+
                                         " select '"+codVersionFM+"',f.COD_FORMULA_MAESTRA,f.COD_MATERIAL,f.COD_TIPO_ANALISIS_MATERIAL_REACTIVO"+
                                         " from FORMULA_MAESTRA_MR_CLASIFICACION f where f.COD_FORMULA_MAESTRA='"+resDetalle.getInt("COD_FORMULA_MAESTRA")+"'";
                                System.out.println("consulta duplicar clasificacion mr "+consulta);
                                pst=con.prepareStatement(consulta);
                                if(pst.executeUpdate()>0)System.out.println("se registro el personal para la modificacion");
                               
                    }
                    else
                    {
                            codFormulaMaestra++;
                            
                            consulta="INSERT INTO COMPONENTES_PROD_VERSION(COD_VERSION, COD_COMPPROD, COD_PROD,COD_FORMA, COD_ENVASEPRIM, COD_COLORPRESPRIMARIA, VOLUMENPESO_ENVASEPRIM,"+
                                     " CANTIDAD_COMPPROD, COD_AREA_EMPRESA, COD_SABOR, volumenpeso_aproximado,"+
                                     " COD_COMPUESTOPROD, nombre_prod_semiterminado, NOMBRE_GENERICO, REG_SANITARIO,"+
                                     " COD_LINEAMKT, COD_CATEGORIACOMPPROD, VIDA_UTIL, FECHA_VENCIMIENTO_RS,"+
                                     " COD_ESTADO_COMPPROD, RENDIMIENTO_PRODUCTO, COD_TIPO_PRODUCCION,"+
                                     " VOLUMEN_ENVASE_PRIMARIO, CONCENTRACION_ENVASE_PRIMARIO, PESO_ENVASE_PRIMARIO,"+
                                     " DIRECCION_ARCHIVO_REGISTRO_SANITARIO, COD_VIA_ADMINISTRACION_PRODUCTO,"+
                                     " CANTIDAD_VOLUMEN, COD_UNIDAD_MEDIDA_VOLUMEN, TOLERANCIA_VOLUMEN_FABRICAR,"+
                                     " COD_ESTADO_VERSION, NRO_VERSION, COD_TIPO_COMPPROD_FORMATO, FECHA_MODIFICACION,"+
                                     " COD_PERSONAL_CREACION, FECHA_INICIO_VIGENCIA,PRODUCTO_SEMITERMINADO,TAMANIO_LOTE_PRODUCCION," +
                                     " PRESENTACIONES_REGISTRADAS_RS,NOMBRE_COMERCIAL,COD_CONDICION_VENTA_PRODUCTO) " +
                                     " select "+codVersionCP+", cp.COD_COMPPROD, cp.COD_PROD,cp.COD_FORMA, cp.COD_ENVASEPRIM" +
                                     " , cp.COD_COLORPRESPRIMARIA, cp.VOLUMENPESO_ENVASEPRIM,"+
                                     " cp.CANTIDAD_COMPPROD, cp.COD_AREA_EMPRESA, cp.COD_SABOR, cp.volumenpeso_aproximado,"+
                                     " cp.COD_COMPUESTOPROD, cp.nombre_prod_semiterminado, cp.NOMBRE_GENERICO, cp.REG_SANITARIO,"+
                                     " cp.COD_LINEAMKT, cp.COD_CATEGORIACOMPPROD, cp.VIDA_UTIL, cp.FECHA_VENCIMIENTO_RS,"+
                                     " cp.COD_ESTADO_COMPPROD, cp.RENDIMIENTO_PRODUCTO, cp.COD_TIPO_PRODUCCION,"+
                                     " cp.VOLUMEN_ENVASE_PRIMARIO, cp.CONCENTRACION_ENVASE_PRIMARIO, cp.PESO_ENVASE_PRIMARIO,"+
                                     " cp.DIRECCION_ARCHIVO_REGISTRO_SANITARIO, cp.COD_VIA_ADMINISTRACION_PRODUCTO,"+
                                     " cp.CANTIDAD_VOLUMEN, cp.COD_UNIDAD_MEDIDA_VOLUMEN, cp.TOLERANCIA_VOLUMEN_FABRICAR,"+
                                     " 2,'"+res.getInt("nroVersion")+"', cp.COD_TIPO_COMPPROD_FORMATO,'"+sdf.format(new Date())+"',"+
                                     " '446', '"+sdf.format(new Date())+"',cp.PRODUCTO_SEMITERMINADO" +
                                     " ,0,cp.PRESENTACIONES_REGISTRADAS_RS,cp.NOMBRE_COMERCIAL" +
                                     " ,cp.COD_CONDICION_VENTA_PRODUCTO" +
                                     " FROM COMPONENTES_PROD cp where cp.COD_COMPPROD='"+res.getInt("COD_COMPPROD")+"'";
                                      System.out.println("consulta crear nueva version "+consulta);
                                    pst=con.prepareStatement(consulta);
                                    if(pst.executeUpdate()>0)System.out.println("se registro la nueva version");
                                    consulta="update COMPONENTES_PROD set TAMANIO_LOTE_PRODUCCION=0"+
                                         " where COD_COMPPROD='"+res.getInt("COD_COMPPROD")+"'";
                                        pst=con.prepareStatement(consulta);
                                        if(pst.executeUpdate()>0)System.out.println("se registro el componentes prod");
                                    consulta="INSERT INTO COMPONENTES_PROD_VERSION_MODIFICACION(COD_PERSONAL, COD_VERSION,"+
                                             " COD_ESTADO_VERSION_COMPONENTES_PROD,FECHA_INCLUSION_VERSION)"+
                                             " VALUES ('1195'," +
                                             " '"+codVersionCP+"',2,'"+sdf.format(new Date())+"')";
                                    System.out.println("consulta insertar usuario modificacion "+consulta);
                                    pst=con.prepareStatement(consulta);
                                    if(pst.executeUpdate()>0)System.out.println("se registro el personal para la modificacion");
                                    consulta="INSERT INTO COMPONENTES_PROD_VERSION_MODIFICACION(COD_PERSONAL, COD_VERSION,"+
                                             " COD_ESTADO_VERSION_COMPONENTES_PROD,FECHA_INCLUSION_VERSION)"+
                                             " VALUES ('446'," +
                                             " '"+codVersionCP+"',2,'"+sdf.format(new Date())+"')";
                                    System.out.println("consulta insertar usuario modificacion "+consulta);
                                    pst=con.prepareStatement(consulta);
                                    if(pst.executeUpdate()>0)System.out.println("se registro el personal para la modificacion");
                                    consulta="INSERT INTO COMPONENTES_PROD_VERSION_MODIFICACION(COD_PERSONAL, COD_VERSION,"+
                                             " COD_ESTADO_VERSION_COMPONENTES_PROD,FECHA_INCLUSION_VERSION)"+
                                             " VALUES ('1788'," +
                                             " '"+codVersionCP+"',2,'"+sdf.format(new Date())+"')";
                                    System.out.println("consulta insertar usuario modificacion "+consulta);
                                    pst=con.prepareStatement(consulta);
                                    if(pst.executeUpdate()>0)System.out.println("se registro el personal para la modificacion");
                                    consulta="INSERT INTO COMPONENTES_PROD_VERSION_MODIFICACION(COD_PERSONAL, COD_VERSION,"+
                                             " COD_ESTADO_VERSION_COMPONENTES_PROD,FECHA_INCLUSION_VERSION)"+
                                             " VALUES ('303'," +
                                             " '"+codVersionCP+"',2,'"+sdf.format(new Date())+"')";
                                    System.out.println("consulta insertar usuario modificacion "+consulta);
                                    pst=con.prepareStatement(consulta);
                                    if(pst.executeUpdate()>0)System.out.println("se registro el personal para la modificacion");
                                    consulta="INSERT INTO PRESENTACIONES_PRIMARIAS_VERSION(COD_VERSION,"+
                                             " COD_PRESENTACION_PRIMARIA, COD_COMPPROD, COD_ENVASEPRIM, CANTIDAD,"+
                                             " COD_TIPO_PROGRAMA_PROD, COD_ESTADO_REGISTRO, FECHA_MODIFICACION)"+
                                             " select '"+codVersionCP+"',pp.COD_PRESENTACION_PRIMARIA,pp.COD_COMPPROD,"+
                                             " pp.COD_ENVASEPRIM,pp.CANTIDAD,pp.COD_TIPO_PROGRAMA_PROD,pp.COD_ESTADO_REGISTRO,'"+sdf.format(new Date())+"'"+
                                             " from PRESENTACIONES_PRIMARIAS pp WHERE pp.COD_COMPPROD = '"+res.getInt("COD_COMPPROD")+"'";
                                    System.out.println("consulta duplicar presentacion primaria "+consulta);
                                    pst=con.prepareStatement(consulta);
                                    if(pst.executeUpdate()>0)System.out.println("se registraron las presentaciones primarias");

                                    consulta="INSERT INTO COMPONENTES_PRESPROD_VERSION(COD_VERSION, COD_COMPPROD,"+
                                             " COD_PRESENTACION, CANT_COMPPROD, COD_TIPO_PROGRAMA_PROD, COD_ESTADO_REGISTRO)"+
                                             " select '"+codVersionCP+"',c.COD_COMPPROD,c.COD_PRESENTACION,c.CANT_COMPPROD,c.COD_TIPO_PROGRAMA_PROD,"+
                                             " c.COD_ESTADO_REGISTRO"+
                                             " from COMPONENTES_PRESPROD c where c.COD_COMPPROD='"+res.getInt("COD_COMPPROD")+"'";
                                    System.out.println("consulta duplicar componentesPresProd "+consulta);
                                    pst=con.prepareStatement(consulta);
                                    if(pst.executeUpdate()>0)System.out.println("se registraron los componentes pres prod");
                                    consulta="INSERT INTO dbo.FORMULA_MAESTRA(COD_FORMULA_MAESTRA, COD_COMPPROD, CANTIDAD_LOTE"+
                                             " , ESTADO_SISTEMA, COD_ESTADO_REGISTRO)"+
                                             " VALUES ('"+codFormulaMaestra+"','"+res.getInt("COD_COMPPROD")+"', 0, 1,1)";
                                    System.out.println("consulta insertar formua "+consulta);
                                    pst=con.prepareStatement(consulta);
                                    if(pst.executeUpdate()>0)System.out.println("se registro la formula");
                                     consulta="insert into FORMULA_MAESTRA_VERSION (COD_VERSION, COD_FORMULA_MAESTRA,COD_COMPPROD,CANTIDAD_LOTE,ESTADO_SISTEMA,"+
                                             " COD_ESTADO_REGISTRO,NRO_VERSION,FECHA_MODIFICACION,COD_ESTADO_VERSION_FORMULA_MAESTRA,COD_PERSONAL_CREACION,MODIFICACION_NF," +
                                             " MODIFICACION_MP_EP,MODIFICACION_ES,MODIFICACION_R,COD_COMPPROD_VERSION) select "+codVersionFM+"," +
                                             " f.COD_FORMULA_MAESTRA,f.COD_COMPPROD,f.CANTIDAD_LOTE,f.ESTADO_SISTEMA"+
                                             " ,f.COD_ESTADO_REGISTRO,'"+res.getInt("nroVersion")+"','"+sdf.format(new Date())+"',1 ," +
                                             " 446,0,1,1,1" +
                                             " ,'"+codVersionCP+"'"+
                                             " from FORMULA_MAESTRA f where f.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"'";
                                    System.out.println("consulta insert copia cabecera "+consulta);
                                    pst=con.prepareStatement(consulta);
                                    if(pst.executeUpdate()>0)System.out.println("se inserto la cabecera de la version");
                    }
                    while(resDetalle.next())
                    {
                            codCompProd++;
                            codVersionCP++;
                            codVersionFM++;
                            codFormulaMaestra++;
                            //<editor-fold defaultstate="collapsed" desc="Especificaciones">
                            consulta="SELECT V.COD_VERSION_ESPECIFICACION_PRODUCTO FROM VERSION_ESPECIFICACIONES_PRODUCTO v where V.COD_COMPPROD='"+res.getInt("COD_COMPPROD")+"' and  v.COD_TIPO_ANALISIS=0 and v.VERSION_ACTIVA=1";
                            resEsp=stEsp.executeQuery(consulta);
                            if(resEsp.next())
                            {
                                consulta="INSERT INTO COMPONENTES_PROD_CONCENTRACION(COD_COMPPROD,COD_MATERIAL,CANTIDAD,COD_UNIDAD_MEDIDA,"+
                                         " UNIDAD_PRODUCTO,COD_ESTADO_REGISTRO,NOMBRE_MATERIAL_EQUIVALENCIA,CANTIDAD_EQUIVALENCIA,COD_UNIDAD_MEDIDA_EQUIVALENCIA,COD_VERSION,COD_VERSION_ESPECIFICACION_PRODUCTO)"+
                                         " select '"+codCompProd+"',cpc.COD_MATERIAL,cpc.CANTIDAD,cpc.COD_UNIDAD_MEDIDA,"+
                                         " cpc.UNIDAD_PRODUCTO,cpc.COD_ESTADO_REGISTRO,cpc.NOMBRE_MATERIAL_EQUIVALENCIA,"+
                                         " cpc.CANTIDAD_EQUIVALENCIA,cpc.COD_UNIDAD_MEDIDA_EQUIVALENCIA,'"+codVersionCP+"',0"+
                                         " from COMPONENTES_PROD_CONCENTRACION cpc where cpc.COD_VERSION_ESPECIFICACION_PRODUCTO='"+resEsp.getInt("COD_VERSION_ESPECIFICACION_PRODUCTO")+"'" +
                                         " and  cpc.cod_estado_registro=1";
                                System.out.println("consulta insertar copia concentracion "+consulta);
                                pst=con.prepareStatement(consulta);
                                if(pst.executeUpdate()>0)System.out.println("se registro la copia de la concentración");
                            }
                            //fisicas
                            consulta="SELECT V.COD_VERSION_ESPECIFICACION_PRODUCTO FROM VERSION_ESPECIFICACIONES_PRODUCTO v where V.COD_COMPPROD='"+res.getInt("COD_COMPPROD")+"' and  v.COD_TIPO_ANALISIS=1 and v.VERSION_ACTIVA=1";
                            resEsp=stEsp.executeQuery(consulta);
                            if(resEsp.next())
                            {
                                 consulta="INSERT INTO ESPECIFICACIONES_FISICAS_PRODUCTO(COD_PRODUCTO, COD_ESPECIFICACION,"+
                                         " LIMITE_INFERIOR, LIMITE_SUPERIOR, DESCRIPCION, COD_REFERENCIA_CC, ESTADO,"+
                                         " VALOR_EXACTO, COD_TIPO_ESPECIFICACION_FISICA, COD_VERSION,COD_VERSION_ESPECIFICACION_PRODUCTO)"+
                                         " select '"+codCompProd+"', efp.COD_ESPECIFICACION, efp.LIMITE_INFERIOR, efp.LIMITE_SUPERIOR,"+
                                         " efp.DESCRIPCION, efp.COD_REFERENCIA_CC, efp.ESTADO, efp.VALOR_EXACTO,"+
                                         " efp.COD_TIPO_ESPECIFICACION_FISICA, '"+codVersionCP+"',0"+
                                         " from ESPECIFICACIONES_FISICAS_PRODUCTO efp where efp.COD_VERSION_ESPECIFICACION_PRODUCTO='"+resEsp.getInt("COD_VERSION_ESPECIFICACION_PRODUCTO")+"'" +
                                         " and efp.ESTADO=1";
                                System.out.println("consulta insertar esp fisicas "+consulta);
                                pst=con.prepareStatement(consulta);
                                if(pst.executeUpdate()>0)System.out.println("se registro la especificacion fisica");
                            }
                            consulta="SELECT V.COD_VERSION_ESPECIFICACION_PRODUCTO FROM VERSION_ESPECIFICACIONES_PRODUCTO v where V.COD_COMPPROD='"+res.getInt("COD_COMPPROD")+"' and  v.COD_TIPO_ANALISIS=2 and v.VERSION_ACTIVA=1";
                            resEsp=stEsp.executeQuery(consulta);
                            if(resEsp.next())
                            {
                                    consulta="INSERT INTO ESPECIFICACIONES_QUIMICAS_PRODUCTO(COD_ESPECIFICACION, COD_PRODUCTO,"+
                                             " COD_MATERIAL, LIMITE_INFERIOR, LIMITE_SUPERIOR, DESCRIPCION, ESTADO,"+
                                             " COD_REFERENCIA_CC, VALOR_EXACTO, COD_MATERIAL_COMPUESTO_CC, COD_VERSION,COD_VERSION_ESPECIFICACION_PRODUCTO)"+
                                             " select eqp.COD_ESPECIFICACION,'"+codCompProd+"', eqp.COD_MATERIAL, eqp.LIMITE_INFERIOR,"+
                                             " eqp.LIMITE_SUPERIOR, eqp.DESCRIPCION, eqp.ESTADO, eqp.COD_REFERENCIA_CC, eqp.VALOR_EXACTO,"+
                                             " eqp.COD_MATERIAL_COMPUESTO_CC,'"+codVersionCP+"',0"+
                                             " from ESPECIFICACIONES_QUIMICAS_PRODUCTO eqp where eqp.COD_VERSION_ESPECIFICACION_PRODUCTO='"+resEsp.getInt("COD_VERSION_ESPECIFICACION_PRODUCTO")+"'" +
                                             " and eqp.ESTADO=1";
                                    System.out.println("consulta insertar especificaciones quimicas "+consulta);
                                    pst=con.prepareStatement(consulta);
                                    if(pst.executeUpdate()>0)System.out.println("se registraron las especificaciones quimicas");
                            }
                            consulta="SELECT V.COD_VERSION_ESPECIFICACION_PRODUCTO FROM VERSION_ESPECIFICACIONES_PRODUCTO v where V.COD_COMPPROD='"+res.getInt("COD_COMPPROD")+"' and  v.COD_TIPO_ANALISIS=3 and v.VERSION_ACTIVA=1";
                            resEsp=stEsp.executeQuery(consulta);
                            if(resEsp.next())
                            {
                                    consulta="INSERT INTO ESPECIFICACIONES_MICROBIOLOGIA_PRODUCTO(COD_COMPROD,"+
                                             " COD_ESPECIFICACION, LIMITE_INFERIOR, LIMITE_SUPERIOR, DESCRIPCION,"+
                                             " COD_REFERENCIA_CC, ESTADO, VALOR_EXACTO, COD_VERSION,COD_VERSION_ESPECIFICACION_PRODUCTO)"+
                                             " select  '"+codCompProd+"', emp.COD_ESPECIFICACION, emp.LIMITE_INFERIOR, emp.LIMITE_SUPERIOR,"+
                                             " emp.DESCRIPCION, emp.COD_REFERENCIA_CC, emp.ESTADO, emp.VALOR_EXACTO, '"+codVersionCP+"',0"+
                                             " from ESPECIFICACIONES_MICROBIOLOGIA_PRODUCTO emp where emp.COD_VERSION_ESPECIFICACION_PRODUCTO='"+resEsp.getInt("COD_VERSION_ESPECIFICACION_PRODUCTO")+"'" +
                                             " and emp.ESTADO=1";
                                    System.out.println("consulta insertar esp micro "+consulta);
                                    pst=con.prepareStatement(consulta);
                                    if(pst.executeUpdate()>0)System.out.println("se registraron las especificaciones microbio");
                            }
                            //</editor-fold>

                            consulta="INSERT INTO COMPONENTES_PROD(COD_COMPPROD, COD_PROD,COD_FORMA, COD_ENVASEPRIM, COD_COLORPRESPRIMARIA, VOLUMENPESO_ENVASEPRIM,"+
                                     " CANTIDAD_COMPPROD, COD_AREA_EMPRESA, COD_SABOR, volumenpeso_aproximado,"+
                                     " COD_COMPUESTOPROD, nombre_prod_semiterminado, NOMBRE_GENERICO, REG_SANITARIO,"+
                                     " COD_LINEAMKT, COD_CATEGORIACOMPPROD, VIDA_UTIL, FECHA_VENCIMIENTO_RS,"+
                                     " COD_ESTADO_COMPPROD, RENDIMIENTO_PRODUCTO, COD_TIPO_PRODUCCION,"+
                                     " VOLUMEN_ENVASE_PRIMARIO, CONCENTRACION_ENVASE_PRIMARIO, PESO_ENVASE_PRIMARIO,"+
                                     " DIRECCION_ARCHIVO_REGISTRO_SANITARIO, COD_VIA_ADMINISTRACION_PRODUCTO,"+
                                     " CANTIDAD_VOLUMEN, COD_UNIDAD_MEDIDA_VOLUMEN, TOLERANCIA_VOLUMEN_FABRICAR,"+
                                     "  COD_TIPO_COMPPROD_FORMATO,"+
                                     " PRODUCTO_SEMITERMINADO,TAMANIO_LOTE_PRODUCCION," +
                                     " PRESENTACIONES_REGISTRADAS_RS,NOMBRE_COMERCIAL,COD_CONDICION_VENTA_PRODUCTO) " +
                                     " select '"+codCompProd+"', cp.COD_PROD,cp.COD_FORMA, cp.COD_ENVASEPRIM" +
                                     " , cp.COD_COLORPRESPRIMARIA, cp.VOLUMENPESO_ENVASEPRIM,"+
                                     " cp.CANTIDAD_COMPPROD, cp.COD_AREA_EMPRESA, cp.COD_SABOR, cp.volumenpeso_aproximado,"+
                                     " cp.COD_COMPUESTOPROD, cp.nombre_prod_semiterminado, cp.NOMBRE_GENERICO, cp.REG_SANITARIO,"+
                                     " cp.COD_LINEAMKT, cp.COD_CATEGORIACOMPPROD, cp.VIDA_UTIL, cp.FECHA_VENCIMIENTO_RS,"+
                                     " '"+resDetalle.getInt("COD_ESTADO_REGISTRO")+"', cp.RENDIMIENTO_PRODUCTO, cp.COD_TIPO_PRODUCCION,"+
                                     " cp.VOLUMEN_ENVASE_PRIMARIO, cp.CONCENTRACION_ENVASE_PRIMARIO, cp.PESO_ENVASE_PRIMARIO,"+
                                     " cp.DIRECCION_ARCHIVO_REGISTRO_SANITARIO, cp.COD_VIA_ADMINISTRACION_PRODUCTO,"+
                                     " cp.CANTIDAD_VOLUMEN, cp.COD_UNIDAD_MEDIDA_VOLUMEN, cp.TOLERANCIA_VOLUMEN_FABRICAR,"+
                                     "  cp.COD_TIPO_COMPPROD_FORMATO,"+
                                     "  cp.PRODUCTO_SEMITERMINADO" +
                                     " ,'"+resDetalle.getInt("CANTIDAD_LOTE")+"',cp.PRESENTACIONES_REGISTRADAS_RS,cp.NOMBRE_COMERCIAL" +
                                     " ,cp.COD_CONDICION_VENTA_PRODUCTO" +
                                     " FROM COMPONENTES_PROD cp where cp.COD_COMPPROD='"+res.getInt("COD_COMPPROD")+"'";
                                      System.out.println("consulta crear nueva version "+consulta);
                                    pst=con.prepareStatement(consulta);
                                    if(pst.executeUpdate()>0)System.out.println("se registro la nueva version");




                            consulta="INSERT INTO COMPONENTES_PROD_VERSION(COD_VERSION, COD_COMPPROD, COD_PROD,COD_FORMA, COD_ENVASEPRIM, COD_COLORPRESPRIMARIA, VOLUMENPESO_ENVASEPRIM,"+
                                 " CANTIDAD_COMPPROD, COD_AREA_EMPRESA, COD_SABOR, volumenpeso_aproximado,"+
                                 " COD_COMPUESTOPROD, nombre_prod_semiterminado, NOMBRE_GENERICO, REG_SANITARIO,"+
                                 " COD_LINEAMKT, COD_CATEGORIACOMPPROD, VIDA_UTIL, FECHA_VENCIMIENTO_RS,"+
                                 " COD_ESTADO_COMPPROD, RENDIMIENTO_PRODUCTO, COD_TIPO_PRODUCCION,"+
                                 " VOLUMEN_ENVASE_PRIMARIO, CONCENTRACION_ENVASE_PRIMARIO, PESO_ENVASE_PRIMARIO,"+
                                 " DIRECCION_ARCHIVO_REGISTRO_SANITARIO, COD_VIA_ADMINISTRACION_PRODUCTO,"+
                                 " CANTIDAD_VOLUMEN, COD_UNIDAD_MEDIDA_VOLUMEN, TOLERANCIA_VOLUMEN_FABRICAR,"+
                                 " COD_ESTADO_VERSION, NRO_VERSION, COD_TIPO_COMPPROD_FORMATO, FECHA_MODIFICACION,"+
                                 " COD_PERSONAL_CREACION, FECHA_INICIO_VIGENCIA,PRODUCTO_SEMITERMINADO,TAMANIO_LOTE_PRODUCCION," +
                                 " PRESENTACIONES_REGISTRADAS_RS,NOMBRE_COMERCIAL,COD_CONDICION_VENTA_PRODUCTO) " +
                                 " select "+codVersionCP+",'"+codCompProd+"', cp.COD_PROD,cp.COD_FORMA, cp.COD_ENVASEPRIM" +
                                 " , cp.COD_COLORPRESPRIMARIA, cp.VOLUMENPESO_ENVASEPRIM,"+
                                 " cp.CANTIDAD_COMPPROD, cp.COD_AREA_EMPRESA, cp.COD_SABOR, cp.volumenpeso_aproximado,"+
                                 " cp.COD_COMPUESTOPROD, cp.nombre_prod_semiterminado+' ("+resDetalle.getInt("CANTIDAD_LOTE")+")', cp.NOMBRE_GENERICO, cp.REG_SANITARIO,"+
                                 " cp.COD_LINEAMKT, cp.COD_CATEGORIACOMPPROD, cp.VIDA_UTIL, cp.FECHA_VENCIMIENTO_RS,"+
                                 " '"+resDetalle.getInt("COD_ESTADO_REGISTRO")+"', cp.RENDIMIENTO_PRODUCTO, cp.COD_TIPO_PRODUCCION,"+
                                 " cp.VOLUMEN_ENVASE_PRIMARIO, cp.CONCENTRACION_ENVASE_PRIMARIO, cp.PESO_ENVASE_PRIMARIO,"+
                                 " cp.DIRECCION_ARCHIVO_REGISTRO_SANITARIO, cp.COD_VIA_ADMINISTRACION_PRODUCTO,"+
                                 " cp.CANTIDAD_VOLUMEN, cp.COD_UNIDAD_MEDIDA_VOLUMEN, cp.TOLERANCIA_VOLUMEN_FABRICAR,"+
                                 " 2,'1', cp.COD_TIPO_COMPPROD_FORMATO,'"+sdf.format(new Date())+"',"+
                                 " '446','"+sdf.format(new Date())+"',cp.PRODUCTO_SEMITERMINADO" +
                                 " ,'"+resDetalle.getInt("CANTIDAD_LOTE")+"',cp.PRESENTACIONES_REGISTRADAS_RS,cp.NOMBRE_COMERCIAL" +
                                 " ,cp.COD_CONDICION_VENTA_PRODUCTO" +
                                 " FROM COMPONENTES_PROD cp where cp.COD_COMPPROD='"+res.getInt("COD_COMPPROD")+"'";
                                  System.out.println("consulta crear nueva version "+consulta);
                                pst=con.prepareStatement(consulta);
                                if(pst.executeUpdate()>0)System.out.println("se registro la nueva version");
                              consulta="INSERT INTO COMPONENTES_PRESPROD(COD_COMPPROD, COD_PRESENTACION, CANT_COMPPROD,COD_TIPO_PROGRAMA_PROD, COD_ESTADO_REGISTRO) "+
                                         " select '"+codCompProd+"',c.COD_PRESENTACION,c.CANT_COMPPROD,c.COD_TIPO_PROGRAMA_PROD,c.COD_ESTADO_REGISTRO"+
                                         " from COMPONENTES_PRESPROD c where c.COD_COMPPROD='"+res.getInt("COD_COMPPROD")+"'";
                                System.out.println("consulta insertar presprod "+consulta);
                                pst=con.prepareStatement(consulta);
                                if(pst.executeUpdate()>0)System.out.println("se registro componentes presprod");
                                 consulta="insert into FORMULA_MAESTRA(COD_FORMULA_MAESTRA,COD_COMPPROD,CANTIDAD_LOTE,ESTADO_SISTEMA,"+
                                         " COD_ESTADO_REGISTRO) select "+codFormulaMaestra+",'"+codCompProd+"',f.CANTIDAD_LOTE,f.ESTADO_SISTEMA"+
                                         " ,f.COD_ESTADO_REGISTRO"+
                                         " from FORMULA_MAESTRA f where f.COD_FORMULA_MAESTRA='"+resDetalle.getInt("COD_FORMULA_MAESTRA")+"'";
                                System.out.println("consulta insert copia cabecera "+consulta);
                                pst=con.prepareStatement(consulta);
                                if(pst.executeUpdate()>0)System.out.println("se inserto la cabecera de la version");
                                consulta="INSERT INTO FORMULA_MAESTRA_DETALLE_MP(COD_FORMULA_MAESTRA, COD_MATERIAL,"+
                                        " CANTIDAD, COD_UNIDAD_MEDIDA, NRO_PREPARACIONES)"+
                                        " select '"+codFormulaMaestra+"',f.COD_MATERIAL,f.CANTIDAD,f.COD_UNIDAD_MEDIDA,f.NRO_PREPARACIONES" +
                                        " from FORMULA_MAESTRA_DETALLE_MP f" +
                                        " where f.COD_FORMULA_MAESTRA='"+resDetalle.getInt("COD_FORMULA_MAESTRA")+"'";
                                System.out.println("consulta insert fmd "+consulta);
                                pst=con.prepareStatement(consulta);
                                if(pst.executeUpdate()>0)System.out.println("se registraron los materiales");
                                consulta="INSERT INTO FORMULA_MAESTRA_DETALLE_MP_FRACCIONES(COD_FORMULA_MAESTRA,"+
                                        " COD_MATERIAL, COD_FORMULA_MAESTRA_FRACCIONES, CANTIDAD,"+
                                        " COD_TIPO_MATERIAL_PRODUCCION)"+
                                        " select '"+codFormulaMaestra+"',f.COD_MATERIAL,f.COD_FORMULA_MAESTRA_FRACCIONES,"+
                                        " f.CANTIDAD,f.COD_TIPO_MATERIAL_PRODUCCION"+
                                        " from FORMULA_MAESTRA_DETALLE_MP_FRACCIONES  f where "+
                                        " f.COD_FORMULA_MAESTRA='"+resDetalle.getInt("COD_FORMULA_MAESTRA")+"'";
                                System.out.println("consulta insert mp fracciones "+consulta);
                                pst=con.prepareStatement(consulta);
                                if(pst.executeUpdate()>0)System.out.println("se registraron las mp fraccciones");
                                consulta="INSERT INTO FORMULA_MAESTRA_DETALLE_ES(COD_FORMULA_MAESTRA, COD_MATERIAL,"+
                                         " CANTIDAD, COD_UNIDAD_MEDIDA, COD_PRESENTACION_PRODUCTO, COD_TIPO_PROGRAMA_PROD)"+
                                         " select '"+codFormulaMaestra+"',f.COD_MATERIAL,f.CANTIDAD,f.COD_UNIDAD_MEDIDA,f.COD_PRESENTACION_PRODUCTO"+
                                         " ,f.COD_TIPO_PROGRAMA_PROD from FORMULA_MAESTRA_DETALLE_ES f where" +
                                         " f.COD_FORMULA_MAESTRA='"+resDetalle.getInt("COD_FORMULA_MAESTRA")+"'";
                                System.out.println("consulta insert fmd es "+consulta);
                                pst=con.prepareStatement(consulta);
                                if(pst.executeUpdate()>0)System.out.println("se registro el material");
                                consulta="INSERT INTO FORMULA_MAESTRA_DETALLE_MR(COD_FORMULA_MAESTRA, COD_MATERIAL,"+
                                         " CANTIDAD, COD_UNIDAD_MEDIDA, NRO_PREPARACIONES, COD_TIPO_MATERIAL,COD_TIPO_ANALISIS_MATERIAL)"+
                                         " select '"+codFormulaMaestra+"',f.COD_MATERIAL,f.CANTIDAD,f.COD_UNIDAD_MEDIDA,"+
                                         " f.NRO_PREPARACIONES,f.COD_TIPO_MATERIAL,f.COD_TIPO_ANALISIS_MATERIAL"+
                                         " from FORMULA_MAESTRA_DETALLE_MR f where" +
                                         " f.COD_FORMULA_MAESTRA='"+resDetalle.getInt("COD_FORMULA_MAESTRA")+"'";
                                System.out.println("consulta insert detalle mr "+consulta);
                                pst=con.prepareStatement(consulta);
                                if(pst.executeUpdate()>0)System.out.println("se registro fmd mr");
                                consulta="INSERT INTO FORMULA_MAESTRA_MR_CLASIFICACION(COD_FORMULA_MAESTRA, COD_MATERIAL,"+
                                         " COD_TIPO_ANALISIS_MATERIAL_REACTIVO)"+
                                         " select '"+codFormulaMaestra+"',f.COD_MATERIAL,f.COD_TIPO_ANALISIS_MATERIAL_REACTIVO"+
                                         " from FORMULA_MAESTRA_MR_CLASIFICACION f where " +
                                         " f.COD_FORMULA_MAESTRA='"+resDetalle.getInt("COD_FORMULA_MAESTRA")+"'";
                                System.out.println("consulta insert clasificacion "+consulta);
                                pst=con.prepareStatement(consulta);
                                if(pst.executeUpdate()>0)System.out.println("se registro las clasificaciones mr");
                                consulta="SELECT P.CANTIDAD,P.COD_ENVASEPRIM,P.COD_ESTADO_REGISTRO,P.COD_PRESENTACION_PRIMARIA,"+
                                         " P.COD_TIPO_PROGRAMA_PROD"+
                                         " FROM PRESENTACIONES_PRIMARIAS P WHERE P.COD_COMPPROD='"+res.getInt("COD_COMPPROD")+"'"+
                                         " ORDER BY P.COD_TIPO_PROGRAMA_PROD";
                                resEsp=stEsp.executeQuery(consulta);
                                while(resEsp.next())
                                {
                                    codPresentacionPrimaria++;
                                    consulta=" INSERT INTO PRESENTACIONES_PRIMARIAS(COD_PRESENTACION_PRIMARIA, COD_COMPPROD,"+
                                             " COD_ENVASEPRIM, CANTIDAD, COD_TIPO_PROGRAMA_PROD, COD_ESTADO_REGISTRO,"+
                                             " FECHA_MODIFICACION)"+
                                             " VALUES ('"+codPresentacionPrimaria+"', '"+codCompProd+"','"+resEsp.getInt("COD_ENVASEPRIM")+"'," +
                                             "'"+resEsp.getInt("CANTIDAD")+"','"+resEsp.getInt("COD_TIPO_PROGRAMA_PROD")+"'," +
                                             " '"+resEsp.getInt("COD_ESTADO_REGISTRO")+"','"+sdf.format(new Date())+"')";
                                    pst=con.prepareStatement(consulta);
                                    if(pst.executeUpdate()>0)System.out.println("se inserto la nueva presentacion primaria");
                                    consulta="INSERT INTO FORMULA_MAESTRA_DETALLE_EP(COD_FORMULA_MAESTRA,"+
                                             " COD_PRESENTACION_PRIMARIA, COD_MATERIAL, CANTIDAD, COD_UNIDAD_MEDIDA)"+
                                             " select '"+codFormulaMaestra+"','"+codPresentacionPrimaria+"', f.COD_MATERIAL,"+
                                             " f.CANTIDAD, f.COD_UNIDAD_MEDIDA"+
                                             " from FORMULA_MAESTRA_DETALLE_EP f WHERE  f.COD_FORMULA_MAESTRA='"+resDetalle.getInt("COD_FORMULA_MAESTRA")+"'" +
                                             " AND f.COD_PRESENTACION_PRIMARIA='"+resEsp.getInt("COD_PRESENTACION_PRIMARIA")+"'";
                                    pst=con.prepareStatement(consulta);
                                    if(pst.executeUpdate()>0)System.out.println("se registro fm ep");

                                }
                                consulta="INSERT INTO PRESENTACIONES_PRIMARIAS_VERSION(COD_VERSION,"+
                                         " COD_PRESENTACION_PRIMARIA, COD_COMPPROD, COD_ENVASEPRIM, CANTIDAD,"+
                                         " COD_TIPO_PROGRAMA_PROD, COD_ESTADO_REGISTRO, FECHA_MODIFICACION)"+
                                         " select '"+codVersionCP+"',pp.COD_PRESENTACION_PRIMARIA,pp.COD_COMPPROD,"+
                                         " pp.COD_ENVASEPRIM,pp.CANTIDAD,pp.COD_TIPO_PROGRAMA_PROD,pp.COD_ESTADO_REGISTRO,'"+sdf.format(new Date())+"'"+
                                         " from PRESENTACIONES_PRIMARIAS pp WHERE pp.COD_COMPPROD = '"+codCompProd+"'";
                                System.out.println("consulta duplicar presentacion primaria "+consulta);
                                pst=con.prepareStatement(consulta);
                                if(pst.executeUpdate()>0)System.out.println("se registraron las presentaciones primarias");

                                consulta="INSERT INTO COMPONENTES_PRESPROD_VERSION(COD_VERSION, COD_COMPPROD,"+
                                         " COD_PRESENTACION, CANT_COMPPROD, COD_TIPO_PROGRAMA_PROD, COD_ESTADO_REGISTRO)"+
                                         " select '"+codVersionCP+"',c.COD_COMPPROD,c.COD_PRESENTACION,c.CANT_COMPPROD,c.COD_TIPO_PROGRAMA_PROD,"+
                                         " c.COD_ESTADO_REGISTRO"+
                                         " from COMPONENTES_PRESPROD c where c.COD_COMPPROD='"+codCompProd+"'";
                                System.out.println("consulta duplicar componentesPresProd "+consulta);
                                pst=con.prepareStatement(consulta);
                                if(pst.executeUpdate()>0)System.out.println("se registraron los componentes pres prod");
                                 consulta="insert into FORMULA_MAESTRA_VERSION (COD_VERSION, COD_FORMULA_MAESTRA,COD_COMPPROD,CANTIDAD_LOTE,ESTADO_SISTEMA,"+
                                         " COD_ESTADO_REGISTRO,NRO_VERSION,FECHA_MODIFICACION,COD_ESTADO_VERSION_FORMULA_MAESTRA,COD_PERSONAL_CREACION,MODIFICACION_NF," +
                                         " MODIFICACION_MP_EP,MODIFICACION_ES,MODIFICACION_R,COD_COMPPROD_VERSION) select "+codVersionFM+",f.COD_FORMULA_MAESTRA,f.COD_COMPPROD,f.CANTIDAD_LOTE,f.ESTADO_SISTEMA"+
                                         " ,f.COD_ESTADO_REGISTRO,'1','"+sdf.format(new Date())+"',1 ," +
                                         "446,0,'1','1','1'" +
                                         " ,'"+codVersionCP+"'"+
                                         " from FORMULA_MAESTRA f where f.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"'";
                                System.out.println("consulta insert copia cabecera "+consulta);
                                pst=con.prepareStatement(consulta);
                                if(pst.executeUpdate()>0)System.out.println("se inserto la cabecera de la version");
                                consulta="insert into FORMULA_MAESTRA_DETALLE_MP_VERSION (COD_VERSION,COD_FORMULA_MAESTRA,COD_MATERIAL,"+
                                         " CANTIDAD,COD_UNIDAD_MEDIDA,NRO_PREPARACIONES,FECHA_MODIFICACION)  select "+codVersionFM+",f.COD_FORMULA_MAESTRA,f.COD_MATERIAL,f.CANTIDAD,"+
                                         " m.COD_UNIDAD_MEDIDA,f.NRO_PREPARACIONES,'"+sdf.format(new Date())+"'"+
                                         " from FORMULA_MAESTRA_DETALLE_MP f inner join materiales m on m.COD_MATERIAL=f.COD_MATERIAL where f.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"' ";
                                System.out.println("consulta duplicar formula maestra detalle versione "+consulta);
                                pst=con.prepareStatement(consulta);
                                if(pst.executeUpdate()>0)System.out.println("se registraron la versiones detalle ");

                                consulta="insert into FORMULA_MAESTRA_DETALLE_MP_FRACCIONES_VERSION (COD_VERSION,COD_FORMULA_MAESTRA,COD_MATERIAL,"+
                                         " COD_FORMULA_MAESTRA_FRACCIONES,CANTIDAD,COD_TIPO_MATERIAL_PRODUCCION)" +
                                         " select "+codVersionFM+",f.COD_FORMULA_MAESTRA,f.COD_MATERIAL,f.COD_FORMULA_MAESTRA_FRACCIONES,f.CANTIDAD,F.COD_TIPO_MATERIAL_PRODUCCION"+
                                         " from FORMULA_MAESTRA_DETALLE_MP_FRACCIONES f where f.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"' ";
                                System.out.println("consulta duplicar fracciones detalle "+consulta);
                                pst=con.prepareStatement(consulta);
                                if(pst.executeUpdate()>0)System.out.println("se registro la version detalle fracciones");

                                consulta="INSERT INTO FORMULA_MAESTRA_DETALLE_EP_VERSION(COD_VERSION, COD_FORMULA_MAESTRA,"+
                                         " COD_PRESENTACION_PRIMARIA, COD_MATERIAL, CANTIDAD, COD_UNIDAD_MEDIDA)"+
                                         " select '"+codVersionFM+"',f.COD_FORMULA_MAESTRA,f.COD_PRESENTACION_PRIMARIA,f.COD_MATERIAL,f.CANTIDAD,m.COD_UNIDAD_MEDIDA"+
                                         " from FORMULA_MAESTRA_DETALLE_EP f inner join materiales m on m.COD_MATERIAL=f.COD_MATERIAL" +
                                         " where f.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"'";
                                         //" and f.COD_VERSION='"+codversionActiva+"'";
                                System.out.println("consulta duplicar ep "+consulta);
                                pst=con.prepareStatement(consulta);
                                if(pst.executeUpdate()>0)System.out.println("se duplicaron los ep");

                                consulta="INSERT INTO FORMULA_MAESTRA_DETALLE_ES_VERSION(COD_VERSION, COD_FORMULA_MAESTRA,"+
                                         " COD_MATERIAL, CANTIDAD, COD_UNIDAD_MEDIDA, COD_PRESENTACION_PRODUCTO,COD_TIPO_PROGRAMA_PROD)"+
                                         " select '"+codVersionFM+"',f.COD_FORMULA_MAESTRA,f.COD_MATERIAL,f.CANTIDAD,m.COD_UNIDAD_MEDIDA,"+
                                         " f.COD_PRESENTACION_PRODUCTO,f.COD_TIPO_PROGRAMA_PROD"+
                                         " from FORMULA_MAESTRA_DETALLE_ES f inner join materiales m on m.COD_MATERIAL=f.COD_MATERIAL " +
                                         " where f.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"'";
                                         //" and f.COD_VERSION='"+codversionActiva+"'";
                                System.out.println("consulta duplicar es "+consulta);
                                pst=con.prepareStatement(consulta);
                                if(pst.executeUpdate()>0)System.out.println("se duplicaron los es");

                                consulta="INSERT INTO FORMULA_MAESTRA_DETALLE_MR_VERSION(COD_VERSION, COD_FORMULA_MAESTRA,"+
                                         " COD_MATERIAL, CANTIDAD, COD_UNIDAD_MEDIDA, NRO_PREPARACIONES, COD_TIPO_MATERIAL,"+
                                         " COD_TIPO_ANALISIS_MATERIAL)"+
                                         " select '"+codVersionFM+"',f.COD_FORMULA_MAESTRA,f.COD_MATERIAL,f.CANTIDAD,m.COD_UNIDAD_MEDIDA,"+
                                         " f.NRO_PREPARACIONES,f.COD_TIPO_MATERIAL,f.COD_TIPO_ANALISIS_MATERIAL"+
                                         " from FORMULA_MAESTRA_DETALLE_MR f inner join materiales m on m.COD_MATERIAL=f.COD_MATERIAL" +
                                         " where f.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"' ";

                                System.out.println("consulta duplicar  mr "+consulta);
                                pst=con.prepareStatement(consulta);
                                if(pst.executeUpdate()>0)System.out.println("se duplicaron los mr");

                                consulta="INSERT INTO FORMULA_MAESTRA_MR_CLASIFICACION_VERSION(COD_VERSION,"+
                                         " COD_FORMULA_MAESTRA, COD_MATERIAL, COD_TIPO_ANALISIS_MATERIAL_REACTIVO)"+
                                         " select '"+codVersionFM+"',f.COD_FORMULA_MAESTRA,f.COD_MATERIAL,f.COD_TIPO_ANALISIS_MATERIAL_REACTIVO"+
                                         " from FORMULA_MAESTRA_MR_CLASIFICACION f where f.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"'";
                                System.out.println("consulta duplicar clasificacion mr "+consulta);
                                pst=con.prepareStatement(consulta);
                                if(pst.executeUpdate()>0)System.out.println("se duplicarion las clasificaciones mr");
                                consulta="INSERT INTO COMPONENTES_PROD_VERSION_MODIFICACION(COD_PERSONAL, COD_VERSION,"+
                                         " COD_ESTADO_VERSION_COMPONENTES_PROD,FECHA_INCLUSION_VERSION)"+
                                         " VALUES ('1195'," +
                                         " '"+codVersionCP+"',2,'"+sdf.format(new Date())+"')";
                                System.out.println("consulta insertar usuario modificacion "+consulta);
                                pst=con.prepareStatement(consulta);
                                if(pst.executeUpdate()>0)System.out.println("se registro el personal para la modificacion");
                                consulta="INSERT INTO COMPONENTES_PROD_VERSION_MODIFICACION(COD_PERSONAL, COD_VERSION,"+
                                         " COD_ESTADO_VERSION_COMPONENTES_PROD,FECHA_INCLUSION_VERSION)"+
                                         " VALUES ('446'," +
                                         " '"+codVersionCP+"',2,'"+sdf.format(new Date())+"')";
                                System.out.println("consulta insertar usuario modificacion "+consulta);
                                pst=con.prepareStatement(consulta);
                                if(pst.executeUpdate()>0)System.out.println("se registro el personal para la modificacion");
                                consulta="INSERT INTO COMPONENTES_PROD_VERSION_MODIFICACION(COD_PERSONAL, COD_VERSION,"+
                                         " COD_ESTADO_VERSION_COMPONENTES_PROD,FECHA_INCLUSION_VERSION)"+
                                         " VALUES ('1788'," +
                                         " '"+codVersionCP+"',2,'"+sdf.format(new Date())+"')";
                                System.out.println("consulta insertar usuario modificacion "+consulta);
                                pst=con.prepareStatement(consulta);
                                if(pst.executeUpdate()>0)System.out.println("se registro el personal para la modificacion");
                                consulta="INSERT INTO COMPONENTES_PROD_VERSION_MODIFICACION(COD_PERSONAL, COD_VERSION,"+
                                         " COD_ESTADO_VERSION_COMPONENTES_PROD,FECHA_INCLUSION_VERSION)"+
                                         " VALUES ('303'," +
                                         " '"+codVersionCP+"',2,'"+sdf.format(new Date())+"')";
                                System.out.println("consulta insertar usuario modificacion "+consulta);
                                pst=con.prepareStatement(consulta);
                                if(pst.executeUpdate()>0)System.out.println("se registro el personal para la modificacion");
                                consulta="update FORMULA_MAESTRA set COD_ESTADO_REGISTRO='2',ESTADO_SISTEMA='2'"+
                                         " where COD_FORMULA_MAESTRA='"+resDetalle.getInt("COD_FORMULA_MAESTRA")+"'";
                                pst=con.prepareStatement(consulta);
                                if(pst.executeUpdate()>0)System.out.println("se cambio de estado");

                    }
             }
             consulta="UPDATE COMPONENTES_PROD SET nombre_prod_semiterminado=nombre_prod_semiterminado+(case when tamanio_lote_produccion>0 then"+
                      " ' ('+cast(tamanio_lote_produccion as varchar)+')'  else ''end)";
             pst=con.prepareStatement(consulta);
             if(pst.executeUpdate()>0)System.out.println("se actualizo 1");
             con.commit();
        }
        catch(Exception ex)
        {
            ex.printStackTrace();
        }
        */
    }
}
