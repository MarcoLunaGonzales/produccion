/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.util;

/**
 *
 * @author hvaldivia
 */


import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.TimerTask;
import javax.mail.Session;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpSession;
import javax.mail.Message;
import org.joda.time.DateTime;
import org.joda.time.Days;

/**
 *
 * @author Wilmer Manzaneda
 */
public class TaskProduccion extends TimerTask{

    /** Creates a new instance of TareasZeus */
    Connection conexion;
    HttpSession session;
    Connection con = null;

    public TaskProduccion(HttpSession session) {
        System.out.println("session:"+session);
        this.session=session;
    }

    public TaskProduccion(Connection connection) {
        System.out.println("asignacion de conexion ");
        con = connection ;
    }

    public    Connection getConnectionVentas(){
        Connection con=null;
        try {
            String url="jdbc:sqlserver://172.16.10.16;user=sa;password=m0t1t4s@2009;databaseName=CAR2_CBBA";
            //String url="jdbc:sqlserver://172.16.10.21;user=sa;password=n3td4t4;databaseName=SARTORIUS";
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            con=DriverManager.getConnection(url);
            Statement st=con.createStatement();
            st.executeUpdate("set dateformat ymd");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch(SQLException e1){
            e1.printStackTrace();
        }
        return con;
    }


    public void run() {
        System.out.println("______________");
        while(true){
            try {
                //System.out.println("qqqqqqqqqqqqqqqqqqqqqqqqqqqqqq");
                 //*60
                
                SimpleDateFormat f=new SimpleDateFormat("HH:mm:ss");

                //System.out.println("EEE:"+FacesContext.getCurrentInstance());

                Date horaActual = new Date();
                //System.out.println("la hora actual : "+horaActual.getHours());
                //this.enviarCorreoPrueba_action();

                //this.enviarCorreoPrueba_action_1();
//                if(horaActual.getHours()==18){
                //this.enviarCorreoPrueba_action();
//                }
                //notificacion de biblioteca
                if(horaActual.getHours()==19){
                    this.enviarCorreoBiblioteca();
                }
             //  if(horaActual.getHours()==12){
                //    this.enviarCorreoRevisionBiblioteca();
              //  }
                    
              if(horaActual.getHours()==18){
                    this.enviarCorreoNotificacionTiemposLote();
              }
              if(horaActual.getDate()==27){ //el 27 de cada mes se cancelan los lotes que no se terminaron y estan en proceso
                    this.cancelaLoteProduccion();
              }

                //Thread.sleep(1000*60*60);

                Thread.sleep(1000*60*60);


                if(session!=null){
                    
                }

                System.out.println("hola:"+f.format( new java.util.Date() ));

            } catch (InterruptedException ex) {
                System.out.println("chau");
                ex.printStackTrace();
            }
        }
    }
    public void cancelaLoteProduccion(){
        //obtenemos la fecha actual
        try {


            Date fechaActual = new Date();
            DateTime fecha1 = new DateTime(fechaActual);
            fecha1 = fecha1.dayOfMonth().withMinimumValue();//el primer dia del mes
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
            String consulta = " update programa_produccion set cod_estado_programa = '9' " +
                    " where cast(COD_PROGRAMA_PROD as varchar) + '' + cast(COD_LOTE_PRODUCCION as varchar) + ''+ cast(COD_COMPPROD as varchar) + ''+ cast(COD_FORMULA_MAESTRA as varchar)+''+cast(COD_TIPO_PROGRAMA_PROD as varchar)" +
                    " in(select cast(p.COD_PROGRAMA_PROD as varchar) + '' + cast(p.COD_LOTE_PRODUCCION as varchar) + ''+ cast(p.COD_COMPPROD as varchar) + ''+ cast( p.COD_FORMULA_MAESTRA as varchar)+''+cast( p.COD_TIPO_PROGRAMA_PROD as varchar)" +
                    " from programa_produccion p" +
                    " inner join programa_produccion_periodo pp on p.COD_PROGRAMA_PROD = pp.COD_PROGRAMA_PROD" +
                    " where '"+sdf.format(fecha1.toDate())+"' between pp.FECHA_INICIO and pp.FECHA_FINAL " +
                    " and p.COD_ESTADO_PROGRAMA in (1,2,7))  ";
            System.out.println("consulta " + consulta);
            
            Connection con = null;
            con = Util.openConnection(con);
            Statement st = con.createStatement();
            st.executeUpdate(consulta);
            } catch (Exception e) {
                e.printStackTrace();
            }

    }
    public String enviarCorreoPrueba_action(){
        try {
            DecimalFormat formato=null;
            NumberFormat numeroformato = NumberFormat.getNumberInstance(Locale.ENGLISH);
            formato = (DecimalFormat) numeroformato;
            formato.applyPattern("###0.00;(###0.00)");
            DateTime fechaInicio1= new DateTime();
            DateTime fechaFinal1 = new DateTime();
            fechaInicio1= fechaInicio1.minusDays(2);
            fechaFinal1=fechaFinal1.minusDays(1);
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
            SimpleDateFormat sdf1 = new SimpleDateFormat("dd/MM/yyyy");
            String consulta = " select p.COD_LOTE_PRODUCCION,segui.horas_hombre,segui.unidades_producidas,segui.unidades_producidas_extra,segui.horas_maquina,cp1.nombre_prod_semiterminado,envAPT.cantidadEnviada" +
                    " from programa_produccion p inner join componentes_prod cp1 on cp1.cod_compprod = p.cod_compprod " +
                    " cross apply (select sum(datediff(second, s.FECHA_INICIO, s.FECHA_FINAL) / 60.0 / 60.0) horas_hombre,sum(s.UNIDADES_PRODUCIDAS) unidades_producidas,sum(s.UNIDADES_PRODUCIDAS_EXTRA) unidades_producidas_extra,sum(sppr.horas_maquina) horas_maquina" +
                    " from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL s" +
                    " inner join SEGUIMIENTO_PROGRAMA_PRODUCCION sppr on" +
                    " sppr.COD_COMPPROD = s.COD_COMPPROD " +
                    " and sppr.COD_FORMULA_MAESTRA = s.COD_FORMULA_MAESTRA" +
                    " and sppr.COD_LOTE_PRODUCCION = s.COD_LOTE_PRODUCCION" +
                    " and sppr.COD_TIPO_PROGRAMA_PROD = s.COD_TIPO_PROGRAMA_PROD" +
                    " and sppr.COD_PROGRAMA_PROD =  s.COD_PROGRAMA_PROD" +
                    " and sppr.COD_ACTIVIDAD_PROGRAMA = s.COD_ACTIVIDAD_PROGRAMA" +
                    " inner join ACTIVIDADES_FORMULA_MAESTRA afm on" +
                    " afm.COD_ACTIVIDAD_FORMULA = s.COD_ACTIVIDAD_PROGRAMA and" +
                    " afm.COD_FORMULA_MAESTRA = s.COD_FORMULA_MAESTRA and" +
                    " afm.COD_ESTADO_REGISTRO = 1" +
                    " inner join ACTIVIDADES_PRODUCCION ap on ap.COD_ACTIVIDAD = afm.COD_ACTIVIDAD and ap.COD_ESTADO_REGISTRO = 1" +
                    "              inner join personal p1 on p1.COD_PERSONAL = s.COD_PERSONAL and p1.COD_ESTADO_PERSONA = 1" +
                    "              where s.FECHA_INICIO between '"+sdf.format(fechaInicio1.toDate())+" 00:00:00' and  '"+sdf.format(fechaFinal1.toDate())+" 23:59:59'" +
                    "		       and s.FECHA_FINAL between '"+sdf.format(fechaInicio1.toDate())+" 00:00:00' and '"+sdf.format(fechaFinal1.toDate())+" 23:59:59'" +
                    "              and s.COD_LOTE_PRODUCCION = p.COD_LOTE_PRODUCCION and" +
                    "              s.COD_TIPO_PROGRAMA_PROD = p.COD_TIPO_PROGRAMA_PROD and" +
                    "              s.COD_COMPPROD = p.COD_COMPPROD and" +
                    "               s.COD_PROGRAMA_PROD = p.COD_PROGRAMA_PROD and" +
                    "               s.COD_FORMULA_MAESTRA = p.COD_FORMULA_MAESTRA) segui" +
                    " cross apply (select SUM(sd.CANT_TOTAL_SALIDADETALLEACOND) as cantidadEnviada"+
                    " from SALIDAS_ACOND sa inner join SALIDAS_DETALLEACOND sd on"+
                    " sa.COD_SALIDA_ACOND=sd.COD_SALIDA_ACOND"+
                    " where sa.COD_ALMACEN_VENTA in (select av.COD_ALMACEN_VENTA from ALMACENES_VENTAS av where av.COD_AREA_EMPRESA=1)"+
                    " and sd.COD_LOTE_PRODUCCION=p.cod_lote_produccion and sd.COD_COMPPROD=p.cod_compprod and "+
                    " sa.COD_ESTADO_SALIDAACOND not in (2)) envAPT" +
                    " where p.COD_TIPO_PROGRAMA_PROD = 1 and p.COD_LOTE_PRODUCCION " +
                    " in (select distinct sp.COD_LOTE_PRODUCCION " +
                    " from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sp where sp.FECHA_INICIO" +
                    " between '"+sdf.format(fechaInicio1.toDate())+" 00:00:00' and '"+sdf.format(fechaFinal1.toDate())+" 23:59:59'" +
                    " and sp.FECHA_FINAL between '"+sdf.format(fechaInicio1.toDate())+" 00:00:00' and '"+sdf.format(fechaFinal1.toDate())+" 23:59:59') and segui.horas_hombre >0 order by p.cod_lote_produccion";

            consulta = " select ae.nombre_area_empresa,p.COD_LOTE_PRODUCCION,segui.horas_hombre,segui.unidades_producidas,segui.unidades_producidas_extra,segui.horas_maquina,cp1.nombre_prod_semiterminado,envAPT.cantidadEnviada,envAPT1.cantidadEnviadaAPT" +
                    " from programa_produccion p inner join componentes_prod cp1 on cp1.cod_compprod = p.cod_compprod" +
                    " inner join areas_empresa ae on ae.cod_area_empresa = cp1.cod_area_empresa " +
                    " cross apply( select sum(datediff(second,s.FECHA_INICIO,s.FECHA_FINAL))/60.0/60.0 horas_hombre,sum(s.UNIDADES_PRODUCIDAS) unidades_producidas" +
                    "     ,sum(s.UNIDADES_PRODUCIDAS_EXTRA)unidades_producidas_extra,sum(sppr.HORAS_MAQUINA) horas_maquina" +
                    "     from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL s" +
                    "     inner join SEGUIMIENTO_PROGRAMA_PRODUCCION sppr on sppr.COD_COMPPROD = s.COD_COMPPROD and sppr.COD_FORMULA_MAESTRA = s.COD_FORMULA_MAESTRA" +
                    "     and sppr.COD_LOTE_PRODUCCION = s.COD_LOTE_PRODUCCION and sppr.COD_TIPO_PROGRAMA_PROD = s.COD_TIPO_PROGRAMA_PROD" +
                    "     and sppr.COD_PROGRAMA_PROD = s.COD_PROGRAMA_PROD" +
                    "     and sppr.COD_ACTIVIDAD_PROGRAMA = s.COD_ACTIVIDAD_PROGRAMA " +
                    "     inner join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_ACTIVIDAD_FORMULA = sppr.COD_ACTIVIDAD_PROGRAMA" +
                    "     and afm.COD_FORMULA_MAESTRA = p.COD_FORMULA_MAESTRA and afm.COD_ESTADO_REGISTRO = 1" +
                    "     inner join ACTIVIDADES_PRODUCCION a on a.COD_ACTIVIDAD = afm.COD_ACTIVIDAD and a.COD_ESTADO_REGISTRO = 1" +
                    "     inner join personal pe on pe.COD_PERSONAL = s.COD_PERSONAL" +
                    "     where s.FECHA_INICIO between '"+sdf.format(fechaInicio1.toDate())+" 00:00:00' and '"+sdf.format(fechaFinal1.toDate())+" 23:59:59'" +
                    "     and s.FECHA_FINAL between '"+sdf.format(fechaInicio1.toDate())+" 00:00:00' and '"+sdf.format(fechaFinal1.toDate())+" 23:59:59 '" +
                    "     and s.COD_LOTE_PRODUCCION = p.COD_LOTE_PRODUCCION" +
                    "     and s.COD_COMPPROD = p.COD_COMPPROD" +
                    "     and s.COD_FORMULA_MAESTRA =p.COD_FORMULA_MAESTRA" +
                    "     and s.COD_PROGRAMA_PROD = p.COD_PROGRAMA_PROD" +
                    "     and s.COD_TIPO_PROGRAMA_PROD = p.COD_TIPO_PROGRAMA_PROD) segui " +
                    " cross apply (select SUM(sd.CANT_TOTAL_SALIDADETALLEACOND) as cantidadEnviada"+
                    " from SALIDAS_ACOND sa inner join SALIDAS_DETALLEACOND sd on"+
                    " sa.COD_SALIDA_ACOND=sd.COD_SALIDA_ACOND"+
                    " where sa.COD_ALMACEN_VENTA in (select av.COD_ALMACEN_VENTA from ALMACENES_VENTAS av where av.COD_AREA_EMPRESA=1)"+
                    " and sd.COD_LOTE_PRODUCCION=p.cod_lote_produccion and sd.COD_COMPPROD=p.cod_compprod and "+
                    " sa.COD_ESTADO_SALIDAACOND not in (2)) envAPT" +
                    " cross apply( select SUM(sd.CANT_TOTAL_SALIDADETALLEACOND) as cantidadEnviadaAPT"+
                          " from SALIDAS_ACOND sa inner join SALIDAS_DETALLEACOND sd on"+
                          " sa.COD_SALIDA_ACOND=sd.COD_SALIDA_ACOND"+
                          " where sa.COD_ALMACEN_VENTA in (select av.COD_ALMACEN_VENTA from ALMACENES_VENTAS av where av.COD_AREA_EMPRESA=1)"+
                          " and sd.COD_LOTE_PRODUCCION=p.cod_lote_produccion and sd.COD_COMPPROD=p.cod_compprod and "+
                          " sa.COD_ESTADO_SALIDAACOND not in (2)) envAPT1 " +
                    " where p.COD_TIPO_PROGRAMA_PROD = 1 and p.COD_LOTE_PRODUCCION " +
                    " in (select distinct sp.COD_LOTE_PRODUCCION " +
                    " from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sp where sp.FECHA_INICIO" +
                    " between '"+sdf.format(fechaInicio1.toDate())+" 00:00:00' and '"+sdf.format(fechaFinal1.toDate())+" 23:59:59'" +
                    " and sp.FECHA_FINAL between '"+sdf.format(fechaInicio1.toDate())+" 00:00:00' and '"+sdf.format(fechaFinal1.toDate())+" 23:59:59') and segui.horas_hombre >0 order by ae.nombre_area_empresa";
            //consulta = "";

            System.out.println("consulta " + consulta);
            //con = null;
            //con = Util.openConnection(con);
            Statement st = con.createStatement();
            st.executeUpdate("set dateformat ymd");
            ResultSet rs = st.executeQuery(consulta);
            String nombreAreaEmpresa = "";
            String mensajeCorreo =
                    " Ingeniero:<br/> Se registro la siguiente informacion de seguimiento a programa de produccion con fechas desde "+sdf1.format(fechaInicio1.toDate())+" hasta  "+sdf1.format(fechaFinal1.toDate())+":<br/> "  +
                    "<table  align='center' width='60%' style='text-align:left' style = 'font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 10px;border : solid #f2f2f2 1px;' cellpadding='0' cellspacing='0'>";
            mensajeCorreo += " <tr class='tablaFiltroReporte'>" +
                            " <th  align='center' style='border : solid #f2f2f2 1px;' >PRODUCTO</th>" +
                            " <th  align='center' style='border : solid #f2f2f2 1px;' >LOTE PRODUCCION</th>" +
                            " <th  align='center' style='border : solid #f2f2f2 1px;' >HORAS HOMBRE</th>" +
                            " <th  align='center' style='border : solid #f2f2f2 1px;' >HORAS MAQUINA</th>" +
                            " <th  align='center' style='border : solid #f2f2f2 1px;' >UNIDADES PRODUCIDAS</th>" +
                            " <th  align='center' style='border : solid #f2f2f2 1px;' >UNIDADES PRODUCIDAS EXTRA</th>" +
                            " <th  align='center' style='border : solid #f2f2f2 1px;' >PRODUCTIVIDAD</th>" +
                            " </tr>";
            while(rs.next()){
                if(!rs.getString("nombre_area_empresa").equals(nombreAreaEmpresa)){
                    nombreAreaEmpresa = rs.getString("nombre_area_empresa");
                    mensajeCorreo +="<tr class='tablaFiltroReporte' colspan='6'><td><b><div align='center'>"+nombreAreaEmpresa+"</div></b></td></tr>  ";
                }
                mensajeCorreo +=
                    " <tr class='tablaFiltroReporte'>" +
                    " <td  align='left' style='border : solid #f2f2f2 1px;' >"+rs.getString("nombre_prod_semiterminado")+"</td>" +
                    " <td  align='center' style='border : solid #f2f2f2 1px;' >"+rs.getString("cod_lote_produccion")+"</td>" +
                    " <td  align='center' style='border : solid #f2f2f2 1px;' >"+formato.format(rs.getDouble("horas_hombre"))+"</td>" +
                    " <td  align='center' style='border : solid #f2f2f2 1px;' >"+formato.format(rs.getDouble("horas_maquina"))+"</td>" +
                    " <td  align='center' style='border : solid #f2f2f2 1px;' >"+formato.format(rs.getDouble("unidades_producidas"))+"</td>" +
                    " <td  align='center' style='border : solid #f2f2f2 1px;' >"+formato.format(rs.getDouble("unidades_producidas_extra"))+"</td>" +
                    " <td  align='center' style='border : solid #f2f2f2 1px;' >"+formato.format(rs.getDouble("cantidadEnviadaAPT")/rs.getDouble("horas_hombre"))+"</td>" +
                    "</tr>";
            }
            mensajeCorreo +="</table><br/><br/>Sistema Atlas";
            enviarCorreo("1479,780", mensajeCorreo, "Notificacion de seguimiento Programa Produccion", "Notificacion",con);




        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public String enviarCorreoPrueba_action_1(){
        try {
            DecimalFormat formato=null;
            NumberFormat numeroformato = NumberFormat.getNumberInstance(Locale.ENGLISH);
            formato = (DecimalFormat) numeroformato;
            formato.applyPattern("###0.00;(###0.00)");
            DateTime fechaInicio1= new DateTime();
            DateTime fechaFinal1 = new DateTime();
            fechaInicio1= fechaInicio1.minusDays(2);
            fechaFinal1=fechaFinal1.minusDays(1);
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
            SimpleDateFormat sdf1 = new SimpleDateFormat("dd/MM/yyyy");
            String consulta = " select ae.nombre_area_empresa,p.COD_LOTE_PRODUCCION,segui.horas_hombre,segui.unidades_producidas,segui.unidades_producidas_extra,segui.horas_maquina,cp1.nombre_prod_semiterminado,envAPT.cantidadEnviada,envAPT1.cantidadEnviadaAPT" +
                    " from programa_produccion p inner join componentes_prod cp1 on cp1.cod_compprod = p.cod_compprod" +
                    " inner join areas_empresa ae on ae.cod_area_empresa = cp1.cod_area_empresa " +
                    " cross apply( select sum(datediff(second,s.FECHA_INICIO,s.FECHA_FINAL))/60.0/60.0 horas_hombre,sum(s.UNIDADES_PRODUCIDAS) unidades_producidas" +
                    "     ,sum(s.UNIDADES_PRODUCIDAS_EXTRA)unidades_producidas_extra,sum(sppr.HORAS_MAQUINA) horas_maquina" +
                    "     from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL s" +
                    "     inner join SEGUIMIENTO_PROGRAMA_PRODUCCION sppr on sppr.COD_COMPPROD = s.COD_COMPPROD and sppr.COD_FORMULA_MAESTRA = s.COD_FORMULA_MAESTRA" +
                    "     and sppr.COD_LOTE_PRODUCCION = s.COD_LOTE_PRODUCCION and sppr.COD_TIPO_PROGRAMA_PROD = s.COD_TIPO_PROGRAMA_PROD" +
                    "     and sppr.COD_PROGRAMA_PROD = s.COD_PROGRAMA_PROD" +
                    "     and sppr.COD_ACTIVIDAD_PROGRAMA = s.COD_ACTIVIDAD_PROGRAMA " +
                    "     inner join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_ACTIVIDAD_FORMULA = sppr.COD_ACTIVIDAD_PROGRAMA" +
                    "     and afm.COD_FORMULA_MAESTRA = p.COD_FORMULA_MAESTRA and afm.COD_ESTADO_REGISTRO = 1" +
                    "     inner join ACTIVIDADES_PRODUCCION a on a.COD_ACTIVIDAD = afm.COD_ACTIVIDAD and a.COD_ESTADO_REGISTRO = 1" +
                    "     inner join personal pe on pe.COD_PERSONAL = s.COD_PERSONAL" +
                    "     where s.FECHA_INICIO between '"+sdf.format(fechaInicio1.toDate())+" 00:00:00' and '"+sdf.format(fechaFinal1.toDate())+" 23:59:59'" +
                    "     and s.FECHA_FINAL between '"+sdf.format(fechaInicio1.toDate())+" 00:00:00' and '"+sdf.format(fechaFinal1.toDate())+" 23:59:59 '" +
                    "     and s.COD_LOTE_PRODUCCION = p.COD_LOTE_PRODUCCION" +
                    "     and s.COD_COMPPROD = p.COD_COMPPROD" +
                    "     and s.COD_FORMULA_MAESTRA =p.COD_FORMULA_MAESTRA" +
                    "     and s.COD_PROGRAMA_PROD = p.COD_PROGRAMA_PROD" +
                    "     and s.COD_TIPO_PROGRAMA_PROD = p.COD_TIPO_PROGRAMA_PROD) segui " +
                    " cross apply (select SUM(sd.CANT_TOTAL_SALIDADETALLEACOND) as cantidadEnviada"+
                    " from SALIDAS_ACOND sa inner join SALIDAS_DETALLEACOND sd on"+
                    " sa.COD_SALIDA_ACOND=sd.COD_SALIDA_ACOND"+
                    " where sa.COD_ALMACEN_VENTA in (select av.COD_ALMACEN_VENTA from ALMACENES_VENTAS av where av.COD_AREA_EMPRESA=1)"+
                    " and sd.COD_LOTE_PRODUCCION=p.cod_lote_produccion and sd.COD_COMPPROD=p.cod_compprod and "+
                    " sa.COD_ESTADO_SALIDAACOND not in (2)) envAPT" +
                    " cross apply( select SUM(sd.CANT_TOTAL_SALIDADETALLEACOND) as cantidadEnviadaAPT"+
                          " from SALIDAS_ACOND sa inner join SALIDAS_DETALLEACOND sd on"+
                          " sa.COD_SALIDA_ACOND=sd.COD_SALIDA_ACOND"+
                          " where sa.COD_ALMACEN_VENTA in (select av.COD_ALMACEN_VENTA from ALMACENES_VENTAS av where av.COD_AREA_EMPRESA=1)"+
                          " and sd.COD_LOTE_PRODUCCION=p.cod_lote_produccion and sd.COD_COMPPROD=p.cod_compprod and "+
                          " sa.COD_ESTADO_SALIDAACOND not in (2)) envAPT1 " +
                    " where p.COD_TIPO_PROGRAMA_PROD = 1 and p.COD_LOTE_PRODUCCION " +
                    " in (select distinct sp.COD_LOTE_PRODUCCION " +
                    " from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sp where sp.FECHA_INICIO" +
                    " between '"+sdf.format(fechaInicio1.toDate())+" 00:00:00' and '"+sdf.format(fechaFinal1.toDate())+" 23:59:59'" +
                    " and sp.FECHA_FINAL between '"+sdf.format(fechaInicio1.toDate())+" 00:00:00' and '"+sdf.format(fechaFinal1.toDate())+" 23:59:59') and segui.horas_hombre >0 order by ae.nombre_area_empresa";
            System.out.println("consulta " + consulta);
            consulta = "select nombre_area_empresa_cp, COD_LOTE_PRODUCCION,  sum(horas_hombre),   sum(unidades_producidas),  sum(unidades_producidas_extra)," +
                    "      sum(horas_maquina),       nombre_prod_semiterminado,       nombre_area_empresa_actv from (select ae.nombre_area_empresa nombre_area_empresa_cp," +
                    "       p.COD_LOTE_PRODUCCION,      segui.horas_hombre,       segui.unidades_producidas,       segui.unidades_producidas_extra,       segui.horas_maquina," +
                    "       cp1.nombre_prod_semiterminado,       ae1.NOMBRE_AREA_EMPRESA nombre_area_empresa_actvfrom programa_produccion p" +
                    " inner join componentes_prod cp1 on cp1.cod_compprod = p.cod_compprod     inner join areas_empresa ae on ae.cod_area_empresa = cp1.cod_area_empresa" +
                    " inner join FORMULA_MAESTRA f on f.COD_COMPPROD = cp1.COD_COMPPROD and f.COD_ESTADO_REGISTRO = 1" +
                    " inner join ACTIVIDADES_FORMULA_MAESTRA afm1 on afm1.COD_FORMULA_MAESTRA = f.COD_FORMULA_MAESTRA" +
                    " inner join AREAS_EMPRESA ae1 on ae1.COD_AREA_EMPRESA = afm1.COD_AREA_EMPRESA" +
                    " cross apply( select sum(datediff(second, s.FECHA_INICIO, s.FECHA_FINAL)) / 60.0 / 60.0 horas_hombre," +
                    " sum(s.UNIDADES_PRODUCIDAS) unidades_producidas,sum(s.UNIDADES_PRODUCIDAS_EXTRA) unidades_producidas_extra," +
                    " sum(sppr.HORAS_MAQUINA) horas_maquina" +
                    " from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL s" +
                    " inner join SEGUIMIENTO_PROGRAMA_PRODUCCION sppr on sppr.COD_COMPPROD = s.COD_COMPPROD" +
                    " and sppr.COD_FORMULA_MAESTRA = s.COD_FORMULA_MAESTRA" +
                    " and sppr.COD_LOTE_PRODUCCION = s.COD_LOTE_PRODUCCION" +
                    " and sppr.COD_TIPO_PROGRAMA_PROD = s.COD_TIPO_PROGRAMA_PROD" +
                    "            and sppr.COD_PROGRAMA_PROD = s.COD_PROGRAMA_PROD" +
                    "            and sppr.COD_ACTIVIDAD_PROGRAMA = s.COD_ACTIVIDAD_PROGRAMA" +
                    "            inner join ACTIVIDADES_FORMULA_MAESTRA afm on" +
                    "            afm.COD_ACTIVIDAD_FORMULA = sppr.COD_ACTIVIDAD_PROGRAMA and" +
                    "            afm.COD_FORMULA_MAESTRA = p.COD_FORMULA_MAESTRA and" +
                    "            afm.COD_ESTADO_REGISTRO = 1 and afm.COD_ACTIVIDAD_FORMULA = afm1.COD_ACTIVIDAD_FORMULA" +
                    "            inner join ACTIVIDADES_PRODUCCION a on a.COD_ACTIVIDAD = afm.COD_ACTIVIDAD and a.COD_ESTADO_REGISTRO = 1            inner join personal pe on pe.COD_PERSONAL = s.COD_PERSONAL" +
                    "       where s.FECHA_INICIO >= '2014/02/01 00:00:00' and s.FECHA_FINAL <= '2014/02/13 23:59:59'" +
                    "             and s.COD_LOTE_PRODUCCION = p.COD_LOTE_PRODUCCION and             s.COD_COMPPROD = p.COD_COMPPROD and" +
                    "             s.COD_FORMULA_MAESTRA = p.COD_FORMULA_MAESTRA and             s.COD_PROGRAMA_PROD = p.COD_PROGRAMA_PROD and" +
                    "             s.COD_TIPO_PROGRAMA_PROD = p.COD_TIPO_PROGRAMA_PROD     ) segui" +
                    " where p.COD_TIPO_PROGRAMA_PROD = 1 and      p.COD_LOTE_PRODUCCION in (                                 select distinct sp.COD_LOTE_PRODUCCION" +
                    "                                 from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL             sp" +
                    "            where  sp.FECHA_INICIO >=                                 '2014/02/01 00:00:00' and                                       sp.FECHA_FINAL <= '2014/02/13 23:59:59'" +
                    "      ) and      segui.horas_hombre > 0      and afm1.COD_AREA_EMPRESA in(96,84,102,1003)" +
                    ")      as tabla group by nombre_area_empresa_cp,       COD_LOTE_PRODUCCION,       nombre_prod_semiterminado,       NOMBRE_AREA_EMPRESA_actv ";

            consulta = " select nombre_area_empresa_cp,COD_LOTE_PRODUCCION,    sum(horas_hombre) horas_hombre,  sum(unidades_producidas) unidades_producidas," +
                    " sum(unidades_producidas_extra) unidades_producidas_extra, sum(horas_maquina) horas_maquina,nombre_prod_semiterminado," +
                    " nombre_area_empresa_actv,horas_maquina_std,horas_hombre_std,nombre_actividad,cod_actividad_formula" +
                    " from ( select ae.nombre_area_empresa nombre_area_empresa_cp, p.COD_LOTE_PRODUCCION,segui.horas_hombre,segui.unidades_producidas," +
                    " segui.unidades_producidas_extra,segui.horas_maquina, cp1.nombre_prod_semiterminado," +
                    " ae1.NOMBRE_AREA_EMPRESA nombre_area_empresa_actv,maf.HORAS_HOMBRE horas_hombre_std,maf.HORAS_MAQUINA horas_maquina_std," +
                    " apr.NOMBRE_ACTIVIDAD,afm1.COD_ACTIVIDAD_FORMULA" +
                    " from programa_produccion p" +
                    " inner join componentes_prod cp1 on cp1.cod_compprod = p.cod_compprod" +
                    " inner join areas_empresa ae on ae.cod_area_empresa = cp1.cod_area_empresa" +
                    " inner join FORMULA_MAESTRA f on f.COD_COMPPROD = cp1.COD_COMPPROD and f.COD_ESTADO_REGISTRO = 1" +
                    " inner join ACTIVIDADES_FORMULA_MAESTRA afm1 on afm1.COD_FORMULA_MAESTRA = f.COD_FORMULA_MAESTRA" +
                    " inner join ACTIVIDADES_PRODUCCION apr on apr.COD_ACTIVIDAD = afm1.COD_ACTIVIDAD" +
                    " inner join AREAS_EMPRESA ae1 on ae1.COD_AREA_EMPRESA = afm1.COD_AREA_EMPRESA" +
                    " left outer join MAQUINARIA_ACTIVIDADES_FORMULA maf on maf.COD_ACTIVIDAD_FORMULA = afm1.COD_ACTIVIDAD_FORMULA and maf.COD_ESTADO_REGISTRO = 1" +
                    " cross apply( select sum(datediff(second, s.FECHA_INICIO, s.FECHA_FINAL)) / 60.0 / 60.0 horas_hombre," +
                    " sum(s.UNIDADES_PRODUCIDAS) unidades_producidas,sum(s.UNIDADES_PRODUCIDAS_EXTRA) unidades_producidas_extra," +
                    " sum(sppr.HORAS_MAQUINA) horas_maquina" +
                    " from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL s" +
                    " inner join SEGUIMIENTO_PROGRAMA_PRODUCCION sppr on sppr.COD_COMPPROD = s.COD_COMPPROD and sppr.COD_FORMULA_MAESTRA = s.COD_FORMULA_MAESTRA" +
                    " and sppr.COD_LOTE_PRODUCCION = s.COD_LOTE_PRODUCCION and sppr.COD_TIPO_PROGRAMA_PROD = s.COD_TIPO_PROGRAMA_PROD and sppr.COD_PROGRAMA_PROD = s.COD_PROGRAMA_PROD" +
                    " and sppr.COD_ACTIVIDAD_PROGRAMA = s.COD_ACTIVIDAD_PROGRAMA" +
                    " inner join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_ACTIVIDAD_FORMULA = sppr.COD_ACTIVIDAD_PROGRAMA and afm.COD_FORMULA_MAESTRA = p.COD_FORMULA_MAESTRA and afm.COD_ESTADO_REGISTRO = 1 and afm.COD_ACTIVIDAD_FORMULA = afm1.COD_ACTIVIDAD_FORMULA" +
                    " inner join ACTIVIDADES_PRODUCCION a on a.COD_ACTIVIDAD = afm.COD_ACTIVIDAD and a.COD_ESTADO_REGISTRO = 1" +
                    " inner join personal pe on pe.COD_PERSONAL = s.COD_PERSONAL" +
                    " where s.FECHA_INICIO >= '2014/02/01 00:00:00' and s.FECHA_FINAL <= '2014/02/13 23:59:59'" +
                    " and s.COD_LOTE_PRODUCCION = p.COD_LOTE_PRODUCCION and s.COD_COMPPROD = p.COD_COMPPROD" +
                    " and s.COD_FORMULA_MAESTRA = p.COD_FORMULA_MAESTRA and s.COD_PROGRAMA_PROD = p.COD_PROGRAMA_PROD" +
                    " and s.COD_TIPO_PROGRAMA_PROD = p.COD_TIPO_PROGRAMA_PROD) segui" +
                    " where p.COD_TIPO_PROGRAMA_PROD = 1 and p.COD_LOTE_PRODUCCION" +
                    " in (select distinct sp.COD_LOTE_PRODUCCION from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sp" +
                    " where  sp.FECHA_INICIO >= '2014/02/01 00:00:00' and sp.FECHA_FINAL <= '2014/02/13 23:59:59') and segui.horas_hombre > 0" +
                    " and afm1.COD_AREA_EMPRESA in(96,84,102,1003))as tabla" +
                    " group by nombre_area_empresa_cp,COD_LOTE_PRODUCCION,nombre_prod_semiterminado,NOMBRE_AREA_EMPRESA_actv,horas_maquina_std,horas_hombre_std,nombre_actividad,cod_actividad_formula" +
                    " order by cod_lote_produccion,cod_actividad_formula ";
            System.out.println("consulta " + consulta);
            //con = null;
            //con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            st.executeUpdate("set dateformat ymd");
            ResultSet rs = st.executeQuery(consulta);
            String nombreAreaEmpresa = "";
            String mensajeCorreo =
                    " Ingeniero:<br/> Se registro la siguiente informacion de seguimiento a programa de produccion con fechas desde "+sdf1.format(fechaInicio1.toDate())+" hasta  "+sdf1.format(fechaFinal1.toDate())+":<br/> "  +
                    "<table  align='center' width='60%' style='text-align:left' style = 'font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 10px;border : solid #f2f2f2 1px;' cellpadding='0' cellspacing='0'>";
            mensajeCorreo += " <tr class='tablaFiltroReporte'>" +
                            " <th  align='center' style='border : solid #f2f2f2 1px;' >PRODUCTO</th>" +
                            " <th  align='center' style='border : solid #f2f2f2 1px;' >LOTE PRODUCCION</th>" +
                            " <th  align='center' style='border : solid #f2f2f2 1px;' >HORAS HOMBRE</th>" +
                            " <th  align='center' style='border : solid #f2f2f2 1px;' >HORAS MAQUINA</th>" +
                            " <th  align='center' style='border : solid #f2f2f2 1px;' >UNIDADES PRODUCIDAS</th>" +
                            " <th  align='center' style='border : solid #f2f2f2 1px;' >UNIDADES PRODUCIDAS EXTRA</th>" +
                            " <th  align='center' style='border : solid #f2f2f2 1px;' >AREA</th>" +
                            " <th  align='center' style='border : solid #f2f2f2 1px;' >HORAS HOMBRE STD</th>" +
                            " <th  align='center' style='border : solid #f2f2f2 1px;' >HORAS MAQUINA STD</th>" +
                            //" <th  align='center' style='border : solid #f2f2f2 1px;' >PRODUCTIVIDAD</th>" +
                            " </tr>";
            rs.last();
            Object[][] reporte = new Object[20][rs.getRow()];
            rs.beforeFirst();
            List reportes = new ArrayList();
            int i = 0;
            //cargado de reportes
            while(rs.next()){
                Map f = new HashMap();
                f.put("nombreProdSemiterminado",rs.getString("nombre_prod_semiterminado"));
                f.put("nombreAreaEmpresaCp", rs.getString("nombre_area_empresa_cp"));
                f.put("codLoteProduccion",rs.getString("cod_lote_produccion"));
                f.put("horasHombre",rs.getDouble("horas_hombre"));
                f.put("horasMaquina",rs.getDouble("horas_maquina"));
                f.put("unidadesProducidas",rs.getDouble("unidades_producidas"));
                f.put("unidadesProducidasExtra",rs.getDouble("unidades_producidas_extra"));
                f.put("nombreAreaEmpresaActv",rs.getString("nombre_area_empresa_actv"));
                f.put("nombreActividad",rs.getString("nombre_actividad"));
                f.put("horasHombreStd",rs.getDouble("horas_hombre_std"));
                f.put("horasMaquinaStd",rs.getDouble("horas_maquina_std"));
                reportes.add(f);
//                reporte[i][0]= rs.getString("nombre_prod_semiterminado");
//                reporte[i][1]= rs.getString("cod_lote_produccion");
//                reporte[i][2]= rs.getDouble("horas_hombre");
//                reporte[i][3]= rs.getDouble("horas_maquina");
//                reporte[i][4]= rs.getDouble("unidades_producidas");
//                reporte[i][5]= rs.getDouble("unidades_producidas_extra");
//                reporte[i][6]= rs.getString("nombre_area_empresa_actv");
//                reporte[i][7]= rs.getString("nombre_actividad");
//                reporte[i][8]= rs.getDouble("horas_hombre_std");
//                reporte[i][9]= rs.getDouble("horas_maquina_std");
//                i++;
            }
            //impresion de reporte
            Iterator ii = reportes.iterator();
            while(ii.hasNext()){
                HashMap f = (HashMap) ii.next();
                mensajeCorreo +=
                    " <tr class='tablaFiltroReporte'>" +
                    " <td  align='left' style='border : solid #f2f2f2 1px;' colspan = '"+this.cantidadFilas(f.get("nombreProdSemiterminado").toString(), f.get("codLoteProduccion").toString(),f.get("nombreAreaEmpresa").toString(), reportes)+"' >"+f.get("nombreProdSemiterminado").toString()+"</td>" +
                    " <td  align='center' style='border : solid #f2f2f2 1px;' colspan='"+this.cantidadFilas(f.get("nombreProdSemiterminado").toString(), f.get("codLoteProduccion").toString(),f.get("nombreAreaEmpresa").toString(), reportes)+"' >"+f.get("codLoteProduccion").toString()+"</td>" +
                    " <td  align='center' style='border : solid #f2f2f2 1px;' >"+formato.format(f.get("horasHombre"))+"</td>" +
                    " <td  align='center' style='border : solid #f2f2f2 1px;' >"+formato.format(f.get("horasMaquina"))+"</td>" +
                    " <td  align='center' style='border : solid #f2f2f2 1px;' >"+formato.format(f.get("unidadesProducidas"))+"</td>" +
                    " <td  align='center' style='border : solid #f2f2f2 1px;' >"+formato.format(f.get("unidadesProducidasExtra"))+"</td>" +
                    " <td  align='center' style='border : solid #f2f2f2 1px;' >"+f.get("nombreAreaEmpresaActv")+"</td>" +
                    " <td  align='center' style='border : solid #f2f2f2 1px;' >"+f.get("nombre_actividad")+"</td>" +
                    " <td  align='center' style='border : solid #f2f2f2 1px;' >"+formato.format(f.get("horasHombreStd"))+"</td>" +
                    " <td  align='center' style='border : solid #f2f2f2 1px;' >"+formato.format(f.get("horasMaquinaStd"))+"</td>" +
                    //" <td  align='center' style='border : solid #f2f2f2 1px;' >"+formato.format(rs.getDouble("cantidadEnviadaAPT")/rs.getDouble("horas_hombre"))+"</td>" +
                    "</tr>";
            }
            
            mensajeCorreo +="</table><br/><br/>Sistema Atlas";
            enviarCorreo("1479,780", mensajeCorreo, "Notificacion de seguimiento Programa Produccion", "Notificacion",con);




        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public int cantidadFilas(String nombreProdSemiterminado,String codLoteProduccion,String nombreAreaEmpresa,List reporte){
        int cantidadFilas = 0;
        Iterator i = reporte.iterator();
        while(i.hasNext()){
            HashMap f = (HashMap) i.next();
            if(f.get("nombreProdSemiterminado").equals(nombreProdSemiterminado) && f.get("codLoteProduccion").equals(codLoteProduccion)&&f.get("nombreAreaEmpresa").equals(nombreAreaEmpresa)){
                cantidadFilas = cantidadFilas +1;
            }
        }
        return cantidadFilas;
    }
    public String enviarCorreoBiblioteca(){
        try {
            DecimalFormat formato=null;
            NumberFormat numeroformato = NumberFormat.getNumberInstance(Locale.ENGLISH);
            formato = (DecimalFormat) numeroformato;
            formato.applyPattern("###0.00;(###0.00)");
            DateTime fechaInicio1= new DateTime();
            DateTime fechaFinal1 = new DateTime();
            fechaInicio1= fechaInicio1.minusDays(2);
            fechaFinal1=fechaFinal1.minusDays(1);
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
            SimpleDateFormat sdf1 = new SimpleDateFormat("dd/MM/yyyy");
            //correo
            
            String consulta = " select d.NOMBRE_DOCUMENTO,pr.cod_personal,pr.NOMBRE_PILA + ' ' + pr.nombre2_personal + ' '+pr.AP_PATERNO_PERSONAL + ' ' + pr.AP_MATERNO_PERSONAL nombre_personal,cp.nombre_correopersonal " +
                    " from PERMISOS_DOCUMENTOS_PERSONAL p inner join DOCUMENTACION d on d.COD_DOCUMENTO = p.COD_DOCUMENTO" +
                    " inner join personal pr on pr.COD_PERSONAL = p.COD_PERSONAL inner join correo_personal cp on cp.cod_personal = p.cod_personal " +
                    " where p.DOCUMENTO_REVISADO = 0 and p.cod_personal in(1479,1677) ";
            consulta = " select p1.cod_personal,p1.NOMBRE_PILA + ' ' + p1.nombre2_personal + ' '+p1.AP_PATERNO_PERSONAL + ' ' + p1.AP_MATERNO_PERSONAL nombre_personal" +
                    " from personal p1 inner join correo_personal cp on cp.cod_personal = p1.cod_personal" +
                    " where p1.cod_personal in (select p.cod_personal " +
                    " from PERMISOS_DOCUMENTOS_PERSONAL p " +
                    " where p.DOCUMENTO_REVISADO = 0 ) "; //and p.cod_personal in(1479,1677)

            System.out.println("consulta " + consulta);
            //con = null;
            //con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            st.executeUpdate("set dateformat ymd");
            ResultSet rs = st.executeQuery(consulta);
            String nombreAreaEmpresa = "";
            String mensajeCorreo = "";
            String nombrePersonal = "";
            int codPersonal = 0;
            int correlativo = 1;
            int size = rs.getRow();
            mensajeCorreo += " " +
                    "<table><table/>";
            while(rs.next()){
                nombrePersonal = rs.getString("nombre_personal");
                codPersonal = rs.getInt("cod_personal");
                consulta = " select d.NOMBRE_DOCUMENTO " +
                    " from PERMISOS_DOCUMENTOS_PERSONAL p" +
                    " inner join DOCUMENTACION d on d.COD_DOCUMENTO = p.COD_DOCUMENTO" +
                    " where p.DOCUMENTO_REVISADO = 0 and p.cod_personal = '"+codPersonal+"' ";
                System.out.println("consulta " + consulta);
                Statement st1 = con.createStatement();
                ResultSet rs1 = st1.executeQuery(consulta);
                 mensajeCorreo ="Estimado(a) "+rs.getString("nombre_personal")+":<br/> Tiene los siguientes documentos a ser revisados: <br/>" +
                            "<table align='center' width='60%' style='text-align:left' style = 'font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 10px;border : solid #f2f2f2 1px; ' cellpadding='0' cellspacing='0'>";
                    mensajeCorreo +="<tr><td style='text-align:center'><b>Nro</b></td><td style='text-align:center'><b>Documento</b></td></tr>";
                while(rs1.next()){
                    mensajeCorreo +="<tr><td>"+correlativo+"</td><td>"+rs1.getString("nombre_documento")+"</td></tr>";
                    correlativo++;
                }
                    mensajeCorreo +="</table><br/> <p style='color:blue'>Sistema de Documentacion</p> ";
                    enviarCorreo(rs.getString("cod_personal")+"", mensajeCorreo, "REVISION DE DOCUMENTOS", "BIBLIOTECA",con);
                    
                
            }
                
                
                
            
            




        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public double cantidadEnvAcond(int codCompProd,String codLoteProduccion){
        double cantEnviada = 0.0;
        try{
            String consulta = " select sum(i.CANT_INGRESO_PRODUCCION) enviados_acond" +
                    "     from PROGRAMA_PRODUCCION ppr" +
                    "     inner join PROGRAMA_PRODUCCION_INGRESOS_ACOND ppria on" +
                    "     ppr.COD_PROGRAMA_PROD = ppria.COD_PROGRAMA_PROD and ppr.COD_LOTE_PRODUCCION = ppria.COD_LOTE_PRODUCCION and ppr.COD_COMPPROD = ppria.COD_COMPPROD and" +
                    "     ppr.COD_FORMULA_MAESTRA = ppria.COD_FORMULA_MAESTRA and" +
                    "     ppr.COD_TIPO_PROGRAMA_PROD = ppria.COD_TIPO_PROGRAMA_PROD" +
                    "     inner join INGRESOS_ACOND ia on ia.COD_INGRESO_ACOND = ppria.COD_INGRESO_ACOND" +
                    "     inner join INGRESOS_DETALLEACOND i on ia.COD_INGRESO_ACOND = i.COD_INGRESO_ACOND and ppria.COD_LOTE_PRODUCCION = i.COD_LOTE_PRODUCCION" +
                    "     and i.COD_COMPPROD = ppria.COD_COMPPROD" +
                    "     where ppria.COD_LOTE_PRODUCCION = '"+codLoteProduccion+"' and ppria.COD_COMPPROD = '"+codCompProd+"' and ia.COD_ESTADO_INGRESOACOND <> 2 ";
            System.out.println("consulta " + consulta);
            Statement st1 = con.createStatement();
            ResultSet rs = st1.executeQuery(consulta);
            if(rs.next()){
                cantEnviada = rs.getDouble("enviados_acond");
            }
        }catch(Exception e){e.printStackTrace();}
        return cantEnviada;
    }
    public double cantidadEnvAPT(int codCompProd,String codLoteProduccion){
        double cantEnviada = 0.0;
        try{
            String consulta = " select SUM(sd.CANT_TOTAL_SALIDADETALLEACOND) as cantidadEnviadaAPT" +
                    " from SALIDAS_ACOND sa" +
                    " inner join SALIDAS_DETALLEACOND sd on sa.COD_SALIDA_ACOND =  sd.COD_SALIDA_ACOND" +
                    " where sa.COD_ALMACEN_VENTA in ( select av.COD_ALMACEN_VENTA" +
                    " from ALMACENES_VENTAS av where av.COD_AREA_EMPRESA = 1" +
                    " ) and sd.COD_LOTE_PRODUCCION = '"+codLoteProduccion+"' and sd.COD_COMPPROD = '"+codCompProd+"'" +
                    " and sa.COD_ESTADO_SALIDAACOND not in (2)";
            System.out.println("consulta " + consulta);
            Statement st2 = con.createStatement();
            ResultSet rs = st2.executeQuery(consulta);
            if(rs.next()){
                cantEnviada = rs.getDouble("cantidadEnviadaAPT");
            }
        }catch(Exception e){e.printStackTrace();}
        return cantEnviada;
    }
    public String enviarCorreoNotificacionTiempos()
    {
        try{
            DecimalFormat formato=null;
            NumberFormat numeroformato = NumberFormat.getNumberInstance(Locale.ENGLISH);
            formato = (DecimalFormat) numeroformato;
            formato.applyPattern("###0.00;(###0.00)");
            DateTime fechaInicio1= new DateTime();
            DateTime fechaFinal1 = new DateTime();
            fechaInicio1= fechaInicio1.minusDays(2);
            fechaFinal1=fechaFinal1.minusDays(1);
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
            SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy/MM/dd");
            SimpleDateFormat sdfLocal = new SimpleDateFormat("dd/MM/yyyy");
            String consulta = " select ae.nombre_area_empresa,p.COD_LOTE_PRODUCCION,segui.horas_hombre,segui.unidades_producidas,segui.unidades_producidas_extra,segui.horas_maquina,cp1.nombre_prod_semiterminado,envAPT.cantidadEnviada,envAPT1.cantidadEnviadaAPT" +
                    " from programa_produccion p inner join componentes_prod cp1 on cp1.cod_compprod = p.cod_compprod" +
                    " inner join areas_empresa ae on ae.cod_area_empresa = cp1.cod_area_empresa " +
                    " cross apply( select sum(datediff(second,s.FECHA_INICIO,s.FECHA_FINAL))/60.0/60.0 horas_hombre,sum(s.UNIDADES_PRODUCIDAS) unidades_producidas" +
                    "     ,sum(s.UNIDADES_PRODUCIDAS_EXTRA)unidades_producidas_extra,sum(sppr.HORAS_MAQUINA) horas_maquina" +
                    "     from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL s" +
                    "     inner join SEGUIMIENTO_PROGRAMA_PRODUCCION sppr on sppr.COD_COMPPROD = s.COD_COMPPROD and sppr.COD_FORMULA_MAESTRA = s.COD_FORMULA_MAESTRA" +
                    "     and sppr.COD_LOTE_PRODUCCION = s.COD_LOTE_PRODUCCION and sppr.COD_TIPO_PROGRAMA_PROD = s.COD_TIPO_PROGRAMA_PROD" +
                    "     and sppr.COD_PROGRAMA_PROD = s.COD_PROGRAMA_PROD" +
                    "     and sppr.COD_ACTIVIDAD_PROGRAMA = s.COD_ACTIVIDAD_PROGRAMA " +
                    "     inner join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_ACTIVIDAD_FORMULA = sppr.COD_ACTIVIDAD_PROGRAMA" +
                    "     and afm.COD_FORMULA_MAESTRA = p.COD_FORMULA_MAESTRA and afm.COD_ESTADO_REGISTRO = 1" +
                    "     inner join ACTIVIDADES_PRODUCCION a on a.COD_ACTIVIDAD = afm.COD_ACTIVIDAD and a.COD_ESTADO_REGISTRO = 1" +
                    "     inner join personal pe on pe.COD_PERSONAL = s.COD_PERSONAL" +
                    "     where s.FECHA_INICIO between '"+sdf.format(fechaInicio1.toDate())+" 00:00:00' and '"+sdf.format(fechaFinal1.toDate())+" 23:59:59'" +
                    "     and s.FECHA_FINAL between '"+sdf.format(fechaInicio1.toDate())+" 00:00:00' and '"+sdf.format(fechaFinal1.toDate())+" 23:59:59 '" +
                    "     and s.COD_LOTE_PRODUCCION = p.COD_LOTE_PRODUCCION" +
                    "     and s.COD_COMPPROD = p.COD_COMPPROD" +
                    "     and s.COD_FORMULA_MAESTRA =p.COD_FORMULA_MAESTRA" +
                    "     and s.COD_PROGRAMA_PROD = p.COD_PROGRAMA_PROD" +
                    "     and s.COD_TIPO_PROGRAMA_PROD = p.COD_TIPO_PROGRAMA_PROD) segui " +
                    " cross apply (select SUM(sd.CANT_TOTAL_SALIDADETALLEACOND) as cantidadEnviada"+
                    " from SALIDAS_ACOND sa inner join SALIDAS_DETALLEACOND sd on"+
                    " sa.COD_SALIDA_ACOND=sd.COD_SALIDA_ACOND"+
                    " where sa.COD_ALMACEN_VENTA in (select av.COD_ALMACEN_VENTA from ALMACENES_VENTAS av where av.COD_AREA_EMPRESA=1)"+
                    " and sd.COD_LOTE_PRODUCCION=p.cod_lote_produccion and sd.COD_COMPPROD=p.cod_compprod and "+
                    " sa.COD_ESTADO_SALIDAACOND not in (2)) envAPT" +
                    " cross apply( select SUM(sd.CANT_TOTAL_SALIDADETALLEACOND) as cantidadEnviadaAPT"+
                          " from SALIDAS_ACOND sa inner join SALIDAS_DETALLEACOND sd on"+
                          " sa.COD_SALIDA_ACOND=sd.COD_SALIDA_ACOND"+
                          " where sa.COD_ALMACEN_VENTA in (select av.COD_ALMACEN_VENTA from ALMACENES_VENTAS av where av.COD_AREA_EMPRESA=1)"+
                          " and sd.COD_LOTE_PRODUCCION=p.cod_lote_produccion and sd.COD_COMPPROD=p.cod_compprod and "+
                          " sa.COD_ESTADO_SALIDAACOND not in (2)) envAPT1 " +
                    " where p.COD_TIPO_PROGRAMA_PROD = 1 and p.COD_LOTE_PRODUCCION " +
                    " in (select distinct sp.COD_LOTE_PRODUCCION " +
                    " from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sp where sp.FECHA_INICIO" +
                    " between '"+sdf.format(fechaInicio1.toDate())+" 00:00:00' and '"+sdf.format(fechaFinal1.toDate())+" 23:59:59'" +
                    " and sp.FECHA_FINAL between '"+sdf.format(fechaInicio1.toDate())+" 00:00:00' and '"+sdf.format(fechaFinal1.toDate())+" 23:59:59') and segui.horas_hombre >0 order by ae.nombre_area_empresa";
            System.out.println("consulta " + consulta);
            consulta = "select nombre_area_empresa_cp, COD_LOTE_PRODUCCION,  sum(horas_hombre),   sum(unidades_producidas),  sum(unidades_producidas_extra)," +
                    "      sum(horas_maquina),       nombre_prod_semiterminado,       nombre_area_empresa_actv from (select ae.nombre_area_empresa nombre_area_empresa_cp," +
                    "       p.COD_LOTE_PRODUCCION,      segui.horas_hombre,       segui.unidades_producidas,       segui.unidades_producidas_extra,       segui.horas_maquina," +
                    "       cp1.nombre_prod_semiterminado,       ae1.NOMBRE_AREA_EMPRESA nombre_area_empresa_actvfrom programa_produccion p" +
                    " inner join componentes_prod cp1 on cp1.cod_compprod = p.cod_compprod     inner join areas_empresa ae on ae.cod_area_empresa = cp1.cod_area_empresa" +
                    " inner join FORMULA_MAESTRA f on f.COD_COMPPROD = cp1.COD_COMPPROD and f.COD_ESTADO_REGISTRO = 1" +
                    " inner join ACTIVIDADES_FORMULA_MAESTRA afm1 on afm1.COD_FORMULA_MAESTRA = f.COD_FORMULA_MAESTRA" +
                    " inner join AREAS_EMPRESA ae1 on ae1.COD_AREA_EMPRESA = afm1.COD_AREA_EMPRESA" +
                    " cross apply( select sum(datediff(second, s.FECHA_INICIO, s.FECHA_FINAL)) / 60.0 / 60.0 horas_hombre," +
                    " sum(s.UNIDADES_PRODUCIDAS) unidades_producidas,sum(s.UNIDADES_PRODUCIDAS_EXTRA) unidades_producidas_extra," +
                    " sum(sppr.HORAS_MAQUINA) horas_maquina" +
                    " from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL s" +
                    " inner join SEGUIMIENTO_PROGRAMA_PRODUCCION sppr on sppr.COD_COMPPROD = s.COD_COMPPROD" +
                    " and sppr.COD_FORMULA_MAESTRA = s.COD_FORMULA_MAESTRA" +
                    " and sppr.COD_LOTE_PRODUCCION = s.COD_LOTE_PRODUCCION" +
                    " and sppr.COD_TIPO_PROGRAMA_PROD = s.COD_TIPO_PROGRAMA_PROD" +
                    "            and sppr.COD_PROGRAMA_PROD = s.COD_PROGRAMA_PROD" +
                    "            and sppr.COD_ACTIVIDAD_PROGRAMA = s.COD_ACTIVIDAD_PROGRAMA" +
                    "            inner join ACTIVIDADES_FORMULA_MAESTRA afm on" +
                    "            afm.COD_ACTIVIDAD_FORMULA = sppr.COD_ACTIVIDAD_PROGRAMA and" +
                    "            afm.COD_FORMULA_MAESTRA = p.COD_FORMULA_MAESTRA and" +
                    "            afm.COD_ESTADO_REGISTRO = 1 and afm.COD_ACTIVIDAD_FORMULA = afm1.COD_ACTIVIDAD_FORMULA" +
                    "            inner join ACTIVIDADES_PRODUCCION a on a.COD_ACTIVIDAD = afm.COD_ACTIVIDAD and a.COD_ESTADO_REGISTRO = 1            inner join personal pe on pe.COD_PERSONAL = s.COD_PERSONAL" +
                    "       where s.FECHA_INICIO >= '2014/02/01 00:00:00' and s.FECHA_FINAL <= '2014/02/13 23:59:59'" +
                    "             and s.COD_LOTE_PRODUCCION = p.COD_LOTE_PRODUCCION and             s.COD_COMPPROD = p.COD_COMPPROD and" +
                    "             s.COD_FORMULA_MAESTRA = p.COD_FORMULA_MAESTRA and             s.COD_PROGRAMA_PROD = p.COD_PROGRAMA_PROD and" +
                    "             s.COD_TIPO_PROGRAMA_PROD = p.COD_TIPO_PROGRAMA_PROD     ) segui" +
                    " where p.COD_TIPO_PROGRAMA_PROD = 1 and      p.COD_LOTE_PRODUCCION in (                                 select distinct sp.COD_LOTE_PRODUCCION" +
                    "                                 from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL             sp" +
                    "            where  sp.FECHA_INICIO >=                                 '2014/02/01 00:00:00' and                                       sp.FECHA_FINAL <= '2014/02/13 23:59:59'" +
                    "      ) and      segui.horas_hombre > 0      and afm1.COD_AREA_EMPRESA in(96,84,102,1003)" +
                    ")      as tabla group by nombre_area_empresa_cp,       COD_LOTE_PRODUCCION,       nombre_prod_semiterminado,       NOMBRE_AREA_EMPRESA_actv ";

            consulta = " select nombre_area_empresa_cp,COD_LOTE_PRODUCCION,    sum(horas_hombre) horas_hombre,  sum(unidades_producidas) unidades_producidas," +
                    " sum(unidades_producidas_extra) unidades_producidas_extra, sum(horas_maquina) horas_maquina,nombre_prod_semiterminado," +
                    "nombre_area_empresa_actv,horas_maquina_std,horas_hombre_std,nombre_actividad,cod_actividad_formula,orden_actividad" +
                    " from ( select ae.nombre_area_empresa nombre_area_empresa_cp, p.COD_LOTE_PRODUCCION,segui.horas_hombre,segui.unidades_producidas," +
                    "segui.unidades_producidas_extra,segui.horas_maquina, cp1.nombre_prod_semiterminado," +
                    "ae1.NOMBRE_AREA_EMPRESA nombre_area_empresa_actv,maf.HORAS_HOMBRE horas_hombre_std,maf.HORAS_MAQUINA horas_maquina_std," +
                    " apr.NOMBRE_ACTIVIDAD,afm1.COD_ACTIVIDAD_FORMULA,afm1.orden_actividad " +
                    " from programa_produccion p" +
                    " inner join componentes_prod cp1 on cp1.cod_compprod = p.cod_compprod" +
                    " inner join areas_empresa ae on ae.cod_area_empresa = cp1.cod_area_empresa" +
                    " inner join FORMULA_MAESTRA f on f.COD_COMPPROD = cp1.COD_COMPPROD and f.COD_ESTADO_REGISTRO = 1" +
                    " inner join ACTIVIDADES_FORMULA_MAESTRA afm1 on afm1.COD_FORMULA_MAESTRA = f.COD_FORMULA_MAESTRA" +
                    " inner join ACTIVIDADES_PRODUCCION apr on apr.COD_ACTIVIDAD = afm1.COD_ACTIVIDAD" +
                    " inner join AREAS_EMPRESA ae1 on ae1.COD_AREA_EMPRESA = afm1.COD_AREA_EMPRESA" +
                    " left outer join MAQUINARIA_ACTIVIDADES_FORMULA maf on maf.COD_ACTIVIDAD_FORMULA = afm1.COD_ACTIVIDAD_FORMULA and maf.COD_ESTADO_REGISTRO = 1" +
                    " cross apply( select sum(datediff(second, s.FECHA_INICIO, s.FECHA_FINAL)) / 60.0 / 60.0 horas_hombre," +
                    " sum(s.UNIDADES_PRODUCIDAS) unidades_producidas,sum(s.UNIDADES_PRODUCIDAS_EXTRA) unidades_producidas_extra," +
                    " sum(sppr.HORAS_MAQUINA) horas_maquina" +
                    " from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL s" +
                    " inner join SEGUIMIENTO_PROGRAMA_PRODUCCION sppr on sppr.COD_COMPPROD = s.COD_COMPPROD and sppr.COD_FORMULA_MAESTRA = s.COD_FORMULA_MAESTRA" +
                    " and sppr.COD_LOTE_PRODUCCION = s.COD_LOTE_PRODUCCION and sppr.COD_TIPO_PROGRAMA_PROD = s.COD_TIPO_PROGRAMA_PROD and sppr.COD_PROGRAMA_PROD = s.COD_PROGRAMA_PROD" +
                    " and sppr.COD_ACTIVIDAD_PROGRAMA = s.COD_ACTIVIDAD_PROGRAMA" +
                    " inner join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_ACTIVIDAD_FORMULA = sppr.COD_ACTIVIDAD_PROGRAMA and afm.COD_FORMULA_MAESTRA = p.COD_FORMULA_MAESTRA and afm.COD_ESTADO_REGISTRO = 1 and afm.COD_ACTIVIDAD_FORMULA = afm1.COD_ACTIVIDAD_FORMULA" +
                    " inner join ACTIVIDADES_PRODUCCION a on a.COD_ACTIVIDAD = afm.COD_ACTIVIDAD and a.COD_ESTADO_REGISTRO = 1" +
                    " inner join personal pe on pe.COD_PERSONAL = s.COD_PERSONAL" +
                    " where s.FECHA_INICIO >= '2014/02/01 00:00:00' and s.FECHA_FINAL <= '2014/02/28 23:59:59'" +
                    " and s.COD_LOTE_PRODUCCION = p.COD_LOTE_PRODUCCION and s.COD_COMPPROD = p.COD_COMPPROD" +
                    " and s.COD_FORMULA_MAESTRA = p.COD_FORMULA_MAESTRA and s.COD_PROGRAMA_PROD = p.COD_PROGRAMA_PROD" +
                    " and s.COD_TIPO_PROGRAMA_PROD = p.COD_TIPO_PROGRAMA_PROD) segui" +
                    " where p.COD_TIPO_PROGRAMA_PROD = 1 and p.COD_LOTE_PRODUCCION" +
                    " in (select distinct sp.COD_LOTE_PRODUCCION from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sp" +
                    " where  sp.FECHA_INICIO >= '2014/02/26 00:00:00' and sp.FECHA_FINAL <= '2014/02/27 23:59:59') and segui.horas_hombre > 0" +
                    " and afm1.COD_AREA_EMPRESA in(96,84,102,1003))as tabla" +
                    " group by nombre_area_empresa_cp,COD_LOTE_PRODUCCION,nombre_prod_semiterminado,NOMBRE_AREA_EMPRESA_actv,horas_maquina_std,horas_hombre_std,nombre_actividad,cod_actividad_formula,orden_actividad" +
                    " order by cod_lote_produccion,orden_actividad ";
            /*consulta = " select nombre_area_empresa_cp,COD_LOTE_PRODUCCION,    sum(horas_hombre) horas_hombre,  sum(unidades_producidas) unidades_producidas," +
                    " sum(unidades_producidas_extra) unidades_producidas_extra, sum(horas_maquina) horas_maquina,nombre_prod_semiterminado," +
                    " nombre_area_empresa_actv,cod_area_empresa_actv,sum(horas_maquina_std) horas_maquina_std,sum(horas_hombre_std) horas_hombre_std,cod_compprod,cod_formula_maestra,cod_programa_prod" +
                    " from ( select ae.nombre_area_empresa nombre_area_empresa_cp, p.COD_LOTE_PRODUCCION,segui.horas_hombre,segui.unidades_producidas," +
                    " segui.unidades_producidas_extra,segui.horas_maquina, cp1.nombre_prod_semiterminado," +
                    " ae1.NOMBRE_AREA_EMPRESA nombre_area_empresa_actv,ae1.cod_area_empresa cod_area_empresa_actv,maf.HORAS_HOMBRE horas_hombre_std,maf.HORAS_MAQUINA horas_maquina_std," +
                    " apr.NOMBRE_ACTIVIDAD,afm1.COD_ACTIVIDAD_FORMULA,afm1.orden_actividad,cp1.cod_compprod,f.cod_formula_maestra,p.cod_programa_prod " +
                    " from programa_produccion p" +
                    " inner join componentes_prod cp1 on cp1.cod_compprod = p.cod_compprod" +
                    " inner join areas_empresa ae on ae.cod_area_empresa = cp1.cod_area_empresa" +
                    " inner join FORMULA_MAESTRA f on f.COD_COMPPROD = cp1.COD_COMPPROD and f.COD_ESTADO_REGISTRO = 1" +
                    " inner join ACTIVIDADES_FORMULA_MAESTRA afm1 on afm1.COD_FORMULA_MAESTRA = f.COD_FORMULA_MAESTRA" +
                    " inner join ACTIVIDADES_PRODUCCION apr on apr.COD_ACTIVIDAD = afm1.COD_ACTIVIDAD" +
                    " inner join AREAS_EMPRESA ae1 on ae1.COD_AREA_EMPRESA = afm1.COD_AREA_EMPRESA" +
                    " left outer join MAQUINARIA_ACTIVIDADES_FORMULA maf on maf.COD_ACTIVIDAD_FORMULA = afm1.COD_ACTIVIDAD_FORMULA and maf.COD_ESTADO_REGISTRO = 1" +
                    " cross apply( select sum(datediff(second, s.FECHA_INICIO, s.FECHA_FINAL)) / 60.0 / 60.0 horas_hombre," +
                    " sum(s.UNIDADES_PRODUCIDAS) unidades_producidas,sum(s.UNIDADES_PRODUCIDAS_EXTRA) unidades_producidas_extra," +
                    " sum(sppr.HORAS_MAQUINA) horas_maquina" +
                    " from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL s" +
                    " inner join SEGUIMIENTO_PROGRAMA_PRODUCCION sppr on sppr.COD_COMPPROD = s.COD_COMPPROD and sppr.COD_FORMULA_MAESTRA = s.COD_FORMULA_MAESTRA" +
                    " and sppr.COD_LOTE_PRODUCCION = s.COD_LOTE_PRODUCCION and sppr.COD_TIPO_PROGRAMA_PROD = s.COD_TIPO_PROGRAMA_PROD and sppr.COD_PROGRAMA_PROD = s.COD_PROGRAMA_PROD" +
                    " and sppr.COD_ACTIVIDAD_PROGRAMA = s.COD_ACTIVIDAD_PROGRAMA" +
                    " inner join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_ACTIVIDAD_FORMULA = sppr.COD_ACTIVIDAD_PROGRAMA and afm.COD_FORMULA_MAESTRA = p.COD_FORMULA_MAESTRA and afm.COD_ESTADO_REGISTRO = 1 and afm.COD_ACTIVIDAD_FORMULA = afm1.COD_ACTIVIDAD_FORMULA" +
                    " inner join ACTIVIDADES_PRODUCCION a on a.COD_ACTIVIDAD = afm.COD_ACTIVIDAD and a.COD_ESTADO_REGISTRO = 1" +
                    " inner join personal pe on pe.COD_PERSONAL = s.COD_PERSONAL" +
                    " where s.FECHA_INICIO >= '2014/05/05 00:00:00' and s.FECHA_FINAL <= '2014/05/06 23:59:59'" +
                    " and s.COD_LOTE_PRODUCCION = p.COD_LOTE_PRODUCCION and s.COD_COMPPROD = p.COD_COMPPROD" +
                    " and s.COD_FORMULA_MAESTRA = p.COD_FORMULA_MAESTRA and s.COD_PROGRAMA_PROD = p.COD_PROGRAMA_PROD" +
                    " and s.COD_TIPO_PROGRAMA_PROD = p.COD_TIPO_PROGRAMA_PROD) segui" +
                    " where p.COD_TIPO_PROGRAMA_PROD = 1 and p.COD_LOTE_PRODUCCION" +
                    " in (select distinct sp.COD_LOTE_PRODUCCION from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sp" +
                    " where  sp.FECHA_INICIO >= '2014/05/05 00:00:00' and sp.FECHA_FINAL <= '2014/05/06 23:59:59') and segui.horas_hombre > 0" +
                    " and afm1.COD_AREA_EMPRESA in(96, 84, 102, 1003,97,76))as tabla" +
                    " group by nombre_area_empresa_cp,COD_LOTE_PRODUCCION,nombre_prod_semiterminado,nombre_area_empresa_actv,cod_area_empresa_actv,cod_compprod,cod_formula_maestra,cod_programa_prod,cod_lote_produccion" +
                    "  order by cod_lote_produccion,case when COD_AREA_EMPRESA_actv = 76 then 1" +
                    "  when COD_AREA_EMPRESA_actv =, 97 then 2" +
                    "  when COD_AREA_EMPRESA_actv = 96 then 3" +
                    "  when COD_AREA_EMPRESA_actv = 84 then 4  else 100 end  ";*/
                    //" order by cod_lote_produccion ";
            consulta = "	select nombre_area_empresa_cp,	"+
                        "	       COD_LOTE_PRODUCCION,	"+
                        "	       sum(horas_hombre) horas_hombre,	"+
                        "	       sum(unidades_producidas) unidades_producidas,	"+
                        "	       sum(unidades_producidas_extra) unidades_producidas_extra,	"+
                        "	       sum(horas_maquina) horas_maquina,	"+
                        "	       cod_compprod," +
                        "          nombre_prod_semiterminado,	"+
                        "	       nombre_area_empresa_actv,	"+
                        "	       cod_area_empresa_actv,	"+
                        "	       sum(horas_maquina_std) horas_maquina_std,	"+
                        "	       sum(horas_hombre_std) horas_hombre_std	"+
                        "	from (	"+
                        "	       select ae.nombre_area_empresa nombre_area_empresa_cp,	"+
                        "	              p.COD_LOTE_PRODUCCION,	"+
                        "	              segui.horas_hombre,	"+
                        "	              segui.unidades_producidas,	"+
                        "	              segui.unidades_producidas_extra,	"+
                        "	              segui.horas_maquina," +
                        "                 cp1.cod_compprod,	"+
                        "	              cp1.nombre_prod_semiterminado,	"+
                        "	              ae1.NOMBRE_AREA_EMPRESA nombre_area_empresa_actv,	"+
                        "	              ae1.COD_AREA_EMPRESA cod_area_empresa_actv,	"+
                        "	              maf.HORAS_HOMBRE horas_hombre_std,	"+
                        "	              maf.HORAS_MAQUINA horas_maquina_std,	"+
                        "	              apr.NOMBRE_ACTIVIDAD,	"+
                        "	              afm1.COD_ACTIVIDAD_FORMULA,	"+
                        "	              afm1.orden_actividad	"+
                        "	       from programa_produccion p	"+
                        "	            inner join componentes_prod cp1 on cp1.cod_compprod = p.cod_compprod	"+
                        "	            inner join areas_empresa ae on ae.cod_area_empresa =	"+
                        "	            cp1.cod_area_empresa	"+
                        "	            inner join FORMULA_MAESTRA f on f.COD_COMPPROD = cp1.COD_COMPPROD	"+
                        "	            and f.COD_ESTADO_REGISTRO = 1	"+
                        "	            inner join ACTIVIDADES_FORMULA_MAESTRA afm1 on	"+
                        "	            afm1.COD_FORMULA_MAESTRA = f.COD_FORMULA_MAESTRA	"+
                        "	            inner join ACTIVIDADES_PRODUCCION apr on apr.COD_ACTIVIDAD =	"+
                        "	            afm1.COD_ACTIVIDAD	"+
                        "	            inner join AREAS_EMPRESA ae1 on ae1.COD_AREA_EMPRESA =	"+
                        "	            afm1.COD_AREA_EMPRESA	"+
                        "	            left outer join MAQUINARIA_ACTIVIDADES_FORMULA maf on	"+
                        "	            maf.COD_ACTIVIDAD_FORMULA = afm1.COD_ACTIVIDAD_FORMULA and	"+
                        "	            maf.COD_ESTADO_REGISTRO = 1	"+
                        "	            cross apply	"+
                        "	            (	"+
                        "	              select sum(datediff(second, s.FECHA_INICIO, s.FECHA_FINAL)) / 60.0	"+
                        "	              / 60.0 horas_hombre,	"+
                        "	                     sum(s.UNIDADES_PRODUCIDAS) unidades_producidas,	"+
                        "	                     sum(s.UNIDADES_PRODUCIDAS_EXTRA) unidades_producidas_extra,	"+
                        "	                     sum(sppr.HORAS_MAQUINA) horas_maquina	"+
                        "	              from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL s	"+
                        "	                   inner join SEGUIMIENTO_PROGRAMA_PRODUCCION sppr on	"+
                        "	                   sppr.COD_COMPPROD = s.COD_COMPPROD and	"+
                        "	                   sppr.COD_FORMULA_MAESTRA = s.COD_FORMULA_MAESTRA and	"+
                        "	                   sppr.COD_LOTE_PRODUCCION = s.COD_LOTE_PRODUCCION and	"+
                        "	                   sppr.COD_TIPO_PROGRAMA_PROD = s.COD_TIPO_PROGRAMA_PROD and	"+
                        "	                   sppr.COD_PROGRAMA_PROD = s.COD_PROGRAMA_PROD and	"+
                        "	                   sppr.COD_ACTIVIDAD_PROGRAMA = s.COD_ACTIVIDAD_PROGRAMA	"+
                        "	                   inner join ACTIVIDADES_FORMULA_MAESTRA afm on	"+
                        "	                   afm.COD_ACTIVIDAD_FORMULA = sppr.COD_ACTIVIDAD_PROGRAMA and	"+
                        "	                   afm.COD_FORMULA_MAESTRA = p.COD_FORMULA_MAESTRA and	"+
                        "	                   afm.COD_ESTADO_REGISTRO = 1 and afm.COD_ACTIVIDAD_FORMULA =	"+
                        "	                   afm1.COD_ACTIVIDAD_FORMULA	"+
                        "	                   inner join ACTIVIDADES_PRODUCCION a on a.COD_ACTIVIDAD =	"+
                        "	                   afm.COD_ACTIVIDAD and a.COD_ESTADO_REGISTRO = 1	"+
                        //"	                   inner join personal pe on pe.COD_PERSONAL = s.COD_PERSONAL	"+
                        "	              where " +
 //                       "s.FECHA_INICIO >= '2014/02/01 00:00:00' and	"+
 //                       "	                    s.FECHA_FINAL <= '2014/02/28 23:59:59' and	"+
                        "	                    s.COD_LOTE_PRODUCCION = p.COD_LOTE_PRODUCCION and	"+
                        "	                    s.COD_COMPPROD = p.COD_COMPPROD and	"+
                        "	                    s.COD_FORMULA_MAESTRA = p.COD_FORMULA_MAESTRA and	"+
                        "	                    s.COD_PROGRAMA_PROD = p.COD_PROGRAMA_PROD and	"+
                        "	                    s.COD_TIPO_PROGRAMA_PROD = p.COD_TIPO_PROGRAMA_PROD	"+
                        "	            ) segui	"+
                        "	       where p.COD_TIPO_PROGRAMA_PROD = 1 and	"+
                        "	             p.COD_LOTE_PRODUCCION in (	"+
                        "	                                        select distinct ppia.COD_LOTE_PRODUCCION" +
                        "                                        from" +
                        "                                        PROGRAMA_PRODUCCION_INGRESOS_ACOND ppia" +
                        "                                        inner join INGRESOS_ACOND ia on ia.COD_INGRESO_ACOND = ppia.COD_INGRESO_ACOND" +
                        "                                        where ia.fecha_ingresoacond between '"+sdf1.format(fechaInicio1.toDate())+" 00:00:00' and '"+sdf1.format(fechaInicio1.toDate())+" 23:59:59'	"+
                        "	             ) and	"+
                        "	             segui.horas_hombre > 0 and	"+
                        "	             afm1.COD_AREA_EMPRESA in (96, 84, 102, 1003)	"+
                        "	     ) as tabla	"+
                        "	group by nombre_area_empresa_cp,	"+
                        "	         COD_LOTE_PRODUCCION," +
                        "            cod_compprod, "+
                        "	         nombre_prod_semiterminado,	"+
                        "	         NOMBRE_AREA_EMPRESA_actv,	"+
                        "	         cod_Area_empresa_actv	"+

                        "	order by cod_lote_produccion,	"+
                        "	         case	"+
                        "	           when cod_Area_empresa_actv = 76 then 1	"+
                        "	           when cod_area_empresa_actv = 97 then 2	"+
                        "	           when cod_Area_empresa_actv = 96 then 3	"+
                        "	           when cod_Area_empresa_Actv = 84 then 4	"+
                        "	           else 10	"+
                        "	         end	";


            System.out.println("consulta " + consulta);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            st.executeUpdate("set dateformat ymd");
            ResultSet rs = st.executeQuery(consulta);
            String nombreProducto = "";
            String codLoteProduccion = "";
            int count = 0;
            //en la primera pasada sacamos los rowspan para el producto y lote
            String detalle = "";
            String reporteLote = "";
            if(rs.next()){
                nombreProducto = rs.getString("nombre_prod_semiterminado");
                codLoteProduccion = rs.getString("cod_lote_produccion");
            }
            rs.beforeFirst();
            double cantidadProducida = 0.0;
            double totalHorasHombreLote = 0.0;
            double totalHorasMaquinaLote = 0.0;

            double totalHorasHombreStd = 0.0;
            double totalHorasMaquinaStd = 0.0;

            double totalHorasHombre = 0.0;
            double totalHorasMaquina = 0.0;

            while(rs.next()){
                System.out.println("cdcdcd");
                //PRIMERO GUARDAR EL DETALLE Y CONTABILIZAR CADA DETALLE DESPUES GUARDAR CON LA CABEZERA

                if(!(nombreProducto+codLoteProduccion).equals(rs.getString("nombre_prod_semiterminado")+rs.getString("cod_lote_produccion"))){


                    reporteLote += "<tr class='tablaFiltroReporte'><td rowspan='"+count+"' style='border : solid #f2f2f2 1px;'>"+codLoteProduccion+"</td><td rowspan='"+count+"' style='border : solid #f2f2f2 1px;'>"+nombreProducto+"</td>"+detalle+"  ";
                    reporteLote += "<tr class='tablaFiltroReporte' style='background-color:#f2f2f2'><td style='border : solid #f2f2f2 1px;text-align:right' colspan=3><b>total</b></td><td style='border : solid #f2f2f2 1px;text-align:center'><b>"+formato.format(totalHorasHombreLote)+"</b></td><td style='border : solid #f2f2f2 1px;text-align:center'><b>"+formato.format(totalHorasMaquinaLote)+"</b></td><td style='border : solid #f2f2f2 1px;text-align:center'><b>"+cantidadProducida+"</b></td><td style='border : solid #f2f2f2 1px;text-align:center'><b>"+formato.format(totalHorasHombreStd)+"</b></td><td style='border : solid #f2f2f2 1px;text-align:center'><b>"+formato.format(totalHorasMaquinaStd)+"</b></td>";
                    nombreProducto=rs.getString("nombre_prod_semiterminado");
                    codLoteProduccion=rs.getString("cod_lote_produccion");
                    count = 0;
                    detalle = "";
                    totalHorasHombreLote = 0.0;
                    totalHorasMaquinaLote = 0.0;
                    totalHorasHombreStd = 0.0;
                    totalHorasMaquinaStd = 0.0;
                  }
                 count ++;

                 if(rs.getInt("cod_Area_empresa_actv")==96)
                     cantidadProducida = this.cantidadEnvAcond(rs.getInt("cod_compprod"),rs.getString("cod_lote_produccion"));
                 System.out.println("cantidad enviada "+cantidadProducida);
                 if(rs.getInt("cod_Area_empresa_actv")==84)
                     cantidadProducida = this.cantidadEnvAPT(rs.getInt("cod_compprod"),rs.getString("cod_lote_produccion"));
                 //<td  align='center' style='border : solid #f2f2f2 1px;'>"+rs.getString("cod_lote_produccion")+" - "+count+"</td>
                 detalle += "<td  align='center' style='border : solid #f2f2f2 1px;'>"+rs.getString("nombre_area_empresa_actv")+"</td>"+
                    " <td  align='center' style='border : solid #f2f2f2 1px;'>"+formato.format(rs.getDouble("horas_hombre"))+"</td>"+
                    " <td  align='center' style='border : solid #f2f2f2 1px;' >"+formato.format(rs.getDouble("horas_maquina"))+"</td>" +
                    " <td  align='center' style='border : solid #f2f2f2 1px;' >"+formato.format(cantidadProducida)+"</td>" +
                    //" <td  align='center' style='border : solid #f2f2f2 1px;' >"+formato.format(rs.getDouble("unidades_producidas_extra"))+"</td>" +
                    " <td  align='center' style='border : solid #f2f2f2 1px;' >"+formato.format(rs.getDouble("horas_hombre_std"))+"</td>" +
                    " <td  align='center' style='border : solid #f2f2f2 1px;' >"+formato.format(rs.getDouble("horas_maquina_std"))+"</td>" +

                    //" <td  align='center' style='border : solid #f2f2f2 1px;' >"+formato.format(rs.getDouble("cantidadEnviadaAPT")/rs.getDouble("horas_hombre"))+"</td>" +
                    "</tr> ";
                 totalHorasHombreLote +=rs.getDouble("horas_hombre");
                 totalHorasMaquinaLote +=rs.getDouble("horas_maquina");
                 totalHorasHombreStd+=rs.getDouble("horas_hombre_std");
                 totalHorasMaquinaStd +=rs.getDouble("horas_maquina_std");


            }


            String mensajeCorreo =" Ingeniero:<br/> Se registro la siguiente informacion de seguimiento a produccion con productos acondicionados en fecha  "+sdfLocal.format(fechaInicio1.toDate())+" :<br/> "  + //hasta  "+sdf1.format(fechaFinal1.toDate())+"
                                  "<table  align='center' width='60%' style='text-align:left' style = 'font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 10px;border : solid #f2f2f2 1px;' cellpadding='0' cellspacing='0'><br/><br/>";
            mensajeCorreo += " <tr class='tablaFiltroReporte'>" +
                            " <th  align='center' style='border : solid #f2f2f2 1px;' >LOTE</th>" +
                            " <th  align='center' style='border : solid #f2f2f2 1px;' >PRODUCTO</th>" +
                            " <th  align='center' style='border : solid #f2f2f2 1px;' >AREA ETAPA</th>" +

                            " <th  align='center' style='border : solid #f2f2f2 1px;' >HORAS HOMBRE</th>" +
                            " <th  align='center' style='border : solid #f2f2f2 1px;' >HORAS MAQUINA</th>" +
                            " <th  align='center' style='border : solid #f2f2f2 1px;' >UNIDADES PRODUCIDAS</th>" +
                            //" <th  align='center' style='border : solid #f2f2f2 1px;' >UNIDADES PRODUCIDAS EXTRA</th>" +
                            //" <th  align='center' style='border : solid #f2f2f2 1px;' >AREA</th>" +
                            //" <th  align='center' style='border : solid #f2f2f2 1px;' >ACTIVIDAD</th>" +
                            " <th  align='center' style='border : solid #f2f2f2 1px;' >HORAS HOMBRE STD</th>" +
                            " <th  align='center' style='border : solid #f2f2f2 1px;' >HORAS MAQUINA STD</th>" +
                            //" <th  align='center' style='border : solid #f2f2f2 1px;' >PRODUCTIVIDAD</th>" +
                            " </tr>"+reporteLote;

            mensajeCorreo +="</table><br/><br/><span style='color:blue'>Sistema Atlas</span>";
            InternetAddress emails[] = new InternetAddress[3];
            emails[0]=new InternetAddress("jrivera@cofar.com.bo");
            emails[1]=new InternetAddress("hvaldivia@cofar.com.bo");
            emails[2]=new InternetAddress("aquispe@cofar.com.bo");
             Properties props = new Properties();
             props.put("mail.smtp.host", "mail.cofar.com.bo");
             props.put("mail.transport.protocol", "smtp");
             props.put("mail.smtp.auth", "false");
             props.setProperty("mail.user", "traspasos@cofar.com.bo");
             props.setProperty("mail.password", "n3td4t4");
             Session mailSession = Session.getInstance(props, null);
             Message msg = new MimeMessage(mailSession);
             msg.setSubject("Notificacion de Tiempos Atlas");
             msg.setFrom(new InternetAddress("traspasos@cofar.com.bo", "Notificacion de Tiempos Atlas"));
             msg.addRecipients(Message.RecipientType.TO, emails);

             String contenido = " <html> <head>  <title></title> " +
                     " <meta http-equiv='Content-Type' content='text/html; charset=windows-1252'> " +
                     " </head> " +
                     " <body style='font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 10px'>" + mensajeCorreo +
                     " </body> </html> " ;
            msg.setContent(contenido, "text/html");
            javax.mail.Transport.send(msg);
            
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
        return null;
    }

    public String enviarCorreoNotificacionTiemposLote()
    {
        try{

            DecimalFormat formato=null;
            NumberFormat numeroformato = NumberFormat.getNumberInstance(Locale.ENGLISH);
            formato = (DecimalFormat) numeroformato;
            formato.applyPattern("###0.00;(###0.00)");
            DateTime fechaInicio1= new DateTime();
            DateTime fechaFinal1 = new DateTime();
            fechaInicio1= fechaInicio1.minusDays(2);//2
            fechaFinal1=fechaFinal1.minusDays(1);
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
            SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy/MM/dd");
            SimpleDateFormat sdf2 = new SimpleDateFormat("dd/MM/yyyy");
            String consulta = " select ae.nombre_area_empresa,p.COD_LOTE_PRODUCCION,segui.horas_hombre,segui.unidades_producidas,segui.unidades_producidas_extra,segui.horas_maquina,cp1.nombre_prod_semiterminado,envAPT.cantidadEnviada,envAPT1.cantidadEnviadaAPT" +
                    " from programa_produccion p inner join componentes_prod cp1 on cp1.cod_compprod = p.cod_compprod" +
                    " inner join areas_empresa ae on ae.cod_area_empresa = cp1.cod_area_empresa " +
                    " cross apply( select sum(datediff(second,s.FECHA_INICIO,s.FECHA_FINAL))/60.0/60.0 horas_hombre,sum(s.UNIDADES_PRODUCIDAS) unidades_producidas" +
                    "     ,sum(s.UNIDADES_PRODUCIDAS_EXTRA)unidades_producidas_extra,sum(sppr.HORAS_MAQUINA) horas_maquina" +
                    "     from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL s" +
                    "     inner join SEGUIMIENTO_PROGRAMA_PRODUCCION sppr on sppr.COD_COMPPROD = s.COD_COMPPROD and sppr.COD_FORMULA_MAESTRA = s.COD_FORMULA_MAESTRA" +
                    "     and sppr.COD_LOTE_PRODUCCION = s.COD_LOTE_PRODUCCION and sppr.COD_TIPO_PROGRAMA_PROD = s.COD_TIPO_PROGRAMA_PROD" +
                    "     and sppr.COD_PROGRAMA_PROD = s.COD_PROGRAMA_PROD" +
                    "     and sppr.COD_ACTIVIDAD_PROGRAMA = s.COD_ACTIVIDAD_PROGRAMA " +
                    "     inner join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_ACTIVIDAD_FORMULA = sppr.COD_ACTIVIDAD_PROGRAMA" +
                    "     and afm.COD_FORMULA_MAESTRA = p.COD_FORMULA_MAESTRA and afm.COD_ESTADO_REGISTRO = 1" +
                    "     inner join ACTIVIDADES_PRODUCCION a on a.COD_ACTIVIDAD = afm.COD_ACTIVIDAD and a.COD_ESTADO_REGISTRO = 1" +
                    "     inner join personal pe on pe.COD_PERSONAL = s.COD_PERSONAL" +
                    "     where s.FECHA_INICIO between '"+sdf.format(fechaInicio1.toDate())+" 00:00:00' and '"+sdf.format(fechaFinal1.toDate())+" 23:59:59'" +
                    "     and s.FECHA_FINAL between '"+sdf.format(fechaInicio1.toDate())+" 00:00:00' and '"+sdf.format(fechaFinal1.toDate())+" 23:59:59 '" +
                    "     and s.COD_LOTE_PRODUCCION = p.COD_LOTE_PRODUCCION" +
                    "     and s.COD_COMPPROD = p.COD_COMPPROD" +
                    "     and s.COD_FORMULA_MAESTRA =p.COD_FORMULA_MAESTRA" +
                    "     and s.COD_PROGRAMA_PROD = p.COD_PROGRAMA_PROD" +
                    "     and s.COD_TIPO_PROGRAMA_PROD = p.COD_TIPO_PROGRAMA_PROD) segui " +
                    " cross apply (select SUM(sd.CANT_TOTAL_SALIDADETALLEACOND) as cantidadEnviada"+
                    " from SALIDAS_ACOND sa inner join SALIDAS_DETALLEACOND sd on"+
                    " sa.COD_SALIDA_ACOND=sd.COD_SALIDA_ACOND"+
                    " where sa.COD_ALMACEN_VENTA in (select av.COD_ALMACEN_VENTA from ALMACENES_VENTAS av where av.COD_AREA_EMPRESA=1)"+
                    " and sd.COD_LOTE_PRODUCCION=p.cod_lote_produccion and sd.COD_COMPPROD=p.cod_compprod and "+
                    " sa.COD_ESTADO_SALIDAACOND not in (2)) envAPT" +
                    " cross apply( select SUM(sd.CANT_TOTAL_SALIDADETALLEACOND) as cantidadEnviadaAPT"+
                          " from SALIDAS_ACOND sa inner join SALIDAS_DETALLEACOND sd on"+
                          " sa.COD_SALIDA_ACOND=sd.COD_SALIDA_ACOND"+
                          " where sa.COD_ALMACEN_VENTA in (select av.COD_ALMACEN_VENTA from ALMACENES_VENTAS av where av.COD_AREA_EMPRESA=1)"+
                          " and sd.COD_LOTE_PRODUCCION=p.cod_lote_produccion and sd.COD_COMPPROD=p.cod_compprod and "+
                          " sa.COD_ESTADO_SALIDAACOND not in (2)) envAPT1 " +
                    " where p.COD_TIPO_PROGRAMA_PROD = 1 and p.COD_LOTE_PRODUCCION " +
                    " in (select distinct sp.COD_LOTE_PRODUCCION " +
                    " from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sp where sp.FECHA_INICIO" +
                    " between '"+sdf.format(fechaInicio1.toDate())+" 00:00:00' and '"+sdf.format(fechaFinal1.toDate())+" 23:59:59'" +
                    " and sp.FECHA_FINAL between '"+sdf.format(fechaInicio1.toDate())+" 00:00:00' and '"+sdf.format(fechaFinal1.toDate())+" 23:59:59') and segui.horas_hombre >0 order by ae.nombre_area_empresa";
            System.out.println("consulta " + consulta);
            consulta = "select nombre_area_empresa_cp, COD_LOTE_PRODUCCION,  sum(horas_hombre),   sum(unidades_producidas),  sum(unidades_producidas_extra)," +
                    "      sum(horas_maquina),       nombre_prod_semiterminado,       nombre_area_empresa_actv from (select ae.nombre_area_empresa nombre_area_empresa_cp," +
                    "       p.COD_LOTE_PRODUCCION,      segui.horas_hombre,       segui.unidades_producidas,       segui.unidades_producidas_extra,       segui.horas_maquina," +
                    "       cp1.nombre_prod_semiterminado,       ae1.NOMBRE_AREA_EMPRESA nombre_area_empresa_actvfrom programa_produccion p" +
                    " inner join componentes_prod cp1 on cp1.cod_compprod = p.cod_compprod     inner join areas_empresa ae on ae.cod_area_empresa = cp1.cod_area_empresa" +
                    " inner join FORMULA_MAESTRA f on f.COD_COMPPROD = cp1.COD_COMPPROD and f.COD_ESTADO_REGISTRO = 1" +
                    " inner join ACTIVIDADES_FORMULA_MAESTRA afm1 on afm1.COD_FORMULA_MAESTRA = f.COD_FORMULA_MAESTRA" +
                    " inner join AREAS_EMPRESA ae1 on ae1.COD_AREA_EMPRESA = afm1.COD_AREA_EMPRESA" +
                    " cross apply( select sum(datediff(second, s.FECHA_INICIO, s.FECHA_FINAL)) / 60.0 / 60.0 horas_hombre," +
                    " sum(s.UNIDADES_PRODUCIDAS) unidades_producidas,sum(s.UNIDADES_PRODUCIDAS_EXTRA) unidades_producidas_extra," +
                    " sum(sppr.HORAS_MAQUINA) horas_maquina" +
                    " from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL s" +
                    " inner join SEGUIMIENTO_PROGRAMA_PRODUCCION sppr on sppr.COD_COMPPROD = s.COD_COMPPROD" +
                    " and sppr.COD_FORMULA_MAESTRA = s.COD_FORMULA_MAESTRA" +
                    " and sppr.COD_LOTE_PRODUCCION = s.COD_LOTE_PRODUCCION" +
                    " and sppr.COD_TIPO_PROGRAMA_PROD = s.COD_TIPO_PROGRAMA_PROD" +
                    "            and sppr.COD_PROGRAMA_PROD = s.COD_PROGRAMA_PROD" +
                    "            and sppr.COD_ACTIVIDAD_PROGRAMA = s.COD_ACTIVIDAD_PROGRAMA" +
                    "            inner join ACTIVIDADES_FORMULA_MAESTRA afm on" +
                    "            afm.COD_ACTIVIDAD_FORMULA = sppr.COD_ACTIVIDAD_PROGRAMA and" +
                    "            afm.COD_FORMULA_MAESTRA = p.COD_FORMULA_MAESTRA and" +
                    "            afm.COD_ESTADO_REGISTRO = 1 and afm.COD_ACTIVIDAD_FORMULA = afm1.COD_ACTIVIDAD_FORMULA" +
                    "            inner join ACTIVIDADES_PRODUCCION a on a.COD_ACTIVIDAD = afm.COD_ACTIVIDAD and a.COD_ESTADO_REGISTRO = 1            inner join personal pe on pe.COD_PERSONAL = s.COD_PERSONAL" +
                    "       where s.FECHA_INICIO >= '2014/02/01 00:00:00' and s.FECHA_FINAL <= '2014/02/13 23:59:59'" +
                    "             and s.COD_LOTE_PRODUCCION = p.COD_LOTE_PRODUCCION and             s.COD_COMPPROD = p.COD_COMPPROD and" +
                    "             s.COD_FORMULA_MAESTRA = p.COD_FORMULA_MAESTRA and             s.COD_PROGRAMA_PROD = p.COD_PROGRAMA_PROD and" +
                    "             s.COD_TIPO_PROGRAMA_PROD = p.COD_TIPO_PROGRAMA_PROD     ) segui" +
                    " where p.COD_TIPO_PROGRAMA_PROD = 1 and      p.COD_LOTE_PRODUCCION in (                                 select distinct sp.COD_LOTE_PRODUCCION" +
                    "                                 from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL             sp" +
                    "            where  sp.FECHA_INICIO >=                                 '2014/02/01 00:00:00' and                                       sp.FECHA_FINAL <= '2014/02/13 23:59:59'" +
                    "      ) and      segui.horas_hombre > 0      and afm1.COD_AREA_EMPRESA in(96,84,102,1003)" +
                    ")      as tabla group by nombre_area_empresa_cp,       COD_LOTE_PRODUCCION,       nombre_prod_semiterminado,       NOMBRE_AREA_EMPRESA_actv ";

            consulta = " select nombre_area_empresa_cp,COD_LOTE_PRODUCCION,    sum(horas_hombre) horas_hombre,  sum(unidades_producidas) unidades_producidas," +
                    " sum(unidades_producidas_extra) unidades_producidas_extra, sum(horas_maquina) horas_maquina,nombre_prod_semiterminado," +
                    "nombre_area_empresa_actv,horas_maquina_std,horas_hombre_std,nombre_actividad,cod_actividad_formula,orden_actividad" +
                    " from ( select ae.nombre_area_empresa nombre_area_empresa_cp, p.COD_LOTE_PRODUCCION,segui.horas_hombre,segui.unidades_producidas," +
                    "segui.unidades_producidas_extra,segui.horas_maquina, cp1.nombre_prod_semiterminado," +
                    "ae1.NOMBRE_AREA_EMPRESA nombre_area_empresa_actv,maf.HORAS_HOMBRE horas_hombre_std,maf.HORAS_MAQUINA horas_maquina_std," +
                    " apr.NOMBRE_ACTIVIDAD,afm1.COD_ACTIVIDAD_FORMULA,afm1.orden_actividad " +
                    " from programa_produccion p" +
                    " inner join componentes_prod cp1 on cp1.cod_compprod = p.cod_compprod" +
                    " inner join areas_empresa ae on ae.cod_area_empresa = cp1.cod_area_empresa" +
                    " inner join FORMULA_MAESTRA f on f.COD_COMPPROD = cp1.COD_COMPPROD and f.COD_ESTADO_REGISTRO = 1" +
                    " inner join ACTIVIDADES_FORMULA_MAESTRA afm1 on afm1.COD_FORMULA_MAESTRA = f.COD_FORMULA_MAESTRA" +
                    " inner join ACTIVIDADES_PRODUCCION apr on apr.COD_ACTIVIDAD = afm1.COD_ACTIVIDAD" +
                    " inner join AREAS_EMPRESA ae1 on ae1.COD_AREA_EMPRESA = afm1.COD_AREA_EMPRESA" +
                    " left outer join MAQUINARIA_ACTIVIDADES_FORMULA maf on maf.COD_ACTIVIDAD_FORMULA = afm1.COD_ACTIVIDAD_FORMULA and maf.COD_ESTADO_REGISTRO = 1" +
                    " cross apply( select sum(datediff(second, s.FECHA_INICIO, s.FECHA_FINAL)) / 60.0 / 60.0 horas_hombre," +
                    " sum(s.UNIDADES_PRODUCIDAS) unidades_producidas,sum(s.UNIDADES_PRODUCIDAS_EXTRA) unidades_producidas_extra," +
                    " sum(sppr.HORAS_MAQUINA) horas_maquina" +
                    " from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL s" +
                    " inner join SEGUIMIENTO_PROGRAMA_PRODUCCION sppr on sppr.COD_COMPPROD = s.COD_COMPPROD and sppr.COD_FORMULA_MAESTRA = s.COD_FORMULA_MAESTRA" +
                    " and sppr.COD_LOTE_PRODUCCION = s.COD_LOTE_PRODUCCION and sppr.COD_TIPO_PROGRAMA_PROD = s.COD_TIPO_PROGRAMA_PROD and sppr.COD_PROGRAMA_PROD = s.COD_PROGRAMA_PROD" +
                    " and sppr.COD_ACTIVIDAD_PROGRAMA = s.COD_ACTIVIDAD_PROGRAMA" +
                    " inner join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_ACTIVIDAD_FORMULA = sppr.COD_ACTIVIDAD_PROGRAMA and afm.COD_FORMULA_MAESTRA = p.COD_FORMULA_MAESTRA and afm.COD_ESTADO_REGISTRO = 1 and afm.COD_ACTIVIDAD_FORMULA = afm1.COD_ACTIVIDAD_FORMULA" +
                    " inner join ACTIVIDADES_PRODUCCION a on a.COD_ACTIVIDAD = afm.COD_ACTIVIDAD and a.COD_ESTADO_REGISTRO = 1" +
                    " inner join personal pe on pe.COD_PERSONAL = s.COD_PERSONAL" +
                    " where s.FECHA_INICIO >= '2014/02/01 00:00:00' and s.FECHA_FINAL <= '2014/02/28 23:59:59'" +
                    " and s.COD_LOTE_PRODUCCION = p.COD_LOTE_PRODUCCION and s.COD_COMPPROD = p.COD_COMPPROD" +
                    " and s.COD_FORMULA_MAESTRA = p.COD_FORMULA_MAESTRA and s.COD_PROGRAMA_PROD = p.COD_PROGRAMA_PROD" +
                    " and s.COD_TIPO_PROGRAMA_PROD = p.COD_TIPO_PROGRAMA_PROD) segui" +
                    " where p.COD_TIPO_PROGRAMA_PROD = 1 and p.COD_LOTE_PRODUCCION" +
                    " in (select distinct sp.COD_LOTE_PRODUCCION from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sp" +
                    " where  sp.FECHA_INICIO >= '2014/02/26 00:00:00' and sp.FECHA_FINAL <= '2014/02/27 23:59:59') and segui.horas_hombre > 0" +
                    " and afm1.COD_AREA_EMPRESA in(96,84,102,1003,40,75,76,84,96,97,1001))as tabla" +
                    " group by nombre_area_empresa_cp,COD_LOTE_PRODUCCION,nombre_prod_semiterminado,NOMBRE_AREA_EMPRESA_actv,horas_maquina_std,horas_hombre_std,nombre_actividad,cod_actividad_formula,orden_actividad" +
                    " order by cod_lote_produccion,orden_actividad ";
            /*consulta = " select nombre_area_empresa_cp,COD_LOTE_PRODUCCION,    sum(horas_hombre) horas_hombre,  sum(unidades_producidas) unidades_producidas," +
                    " sum(unidades_producidas_extra) unidades_producidas_extra, sum(horas_maquina) horas_maquina,nombre_prod_semiterminado," +
                    " nombre_area_empresa_actv,cod_area_empresa_actv,sum(horas_maquina_std) horas_maquina_std,sum(horas_hombre_std) horas_hombre_std,cod_compprod,cod_formula_maestra,cod_programa_prod" +
                    " from ( select ae.nombre_area_empresa nombre_area_empresa_cp, p.COD_LOTE_PRODUCCION,segui.horas_hombre,segui.unidades_producidas," +
                    " segui.unidades_producidas_extra,segui.horas_maquina, cp1.nombre_prod_semiterminado," +
                    " ae1.NOMBRE_AREA_EMPRESA nombre_area_empresa_actv,ae1.cod_area_empresa cod_area_empresa_actv,maf.HORAS_HOMBRE horas_hombre_std,maf.HORAS_MAQUINA horas_maquina_std," +
                    " apr.NOMBRE_ACTIVIDAD,afm1.COD_ACTIVIDAD_FORMULA,afm1.orden_actividad,cp1.cod_compprod,f.cod_formula_maestra,p.cod_programa_prod " +
                    " from programa_produccion p" +
                    " inner join componentes_prod cp1 on cp1.cod_compprod = p.cod_compprod" +
                    " inner join areas_empresa ae on ae.cod_area_empresa = cp1.cod_area_empresa" +
                    " inner join FORMULA_MAESTRA f on f.COD_COMPPROD = cp1.COD_COMPPROD and f.COD_ESTADO_REGISTRO = 1" +
                    " inner join ACTIVIDADES_FORMULA_MAESTRA afm1 on afm1.COD_FORMULA_MAESTRA = f.COD_FORMULA_MAESTRA" +
                    " inner join ACTIVIDADES_PRODUCCION apr on apr.COD_ACTIVIDAD = afm1.COD_ACTIVIDAD" +
                    " inner join AREAS_EMPRESA ae1 on ae1.COD_AREA_EMPRESA = afm1.COD_AREA_EMPRESA" +
                    " left outer join MAQUINARIA_ACTIVIDADES_FORMULA maf on maf.COD_ACTIVIDAD_FORMULA = afm1.COD_ACTIVIDAD_FORMULA and maf.COD_ESTADO_REGISTRO = 1" +
                    " cross apply( select sum(datediff(second, s.FECHA_INICIO, s.FECHA_FINAL)) / 60.0 / 60.0 horas_hombre," +
                    " sum(s.UNIDADES_PRODUCIDAS) unidades_producidas,sum(s.UNIDADES_PRODUCIDAS_EXTRA) unidades_producidas_extra," +
                    " sum(sppr.HORAS_MAQUINA) horas_maquina" +
                    " from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL s" +
                    " inner join SEGUIMIENTO_PROGRAMA_PRODUCCION sppr on sppr.COD_COMPPROD = s.COD_COMPPROD and sppr.COD_FORMULA_MAESTRA = s.COD_FORMULA_MAESTRA" +
                    " and sppr.COD_LOTE_PRODUCCION = s.COD_LOTE_PRODUCCION and sppr.COD_TIPO_PROGRAMA_PROD = s.COD_TIPO_PROGRAMA_PROD and sppr.COD_PROGRAMA_PROD = s.COD_PROGRAMA_PROD" +
                    " and sppr.COD_ACTIVIDAD_PROGRAMA = s.COD_ACTIVIDAD_PROGRAMA" +
                    " inner join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_ACTIVIDAD_FORMULA = sppr.COD_ACTIVIDAD_PROGRAMA and afm.COD_FORMULA_MAESTRA = p.COD_FORMULA_MAESTRA and afm.COD_ESTADO_REGISTRO = 1 and afm.COD_ACTIVIDAD_FORMULA = afm1.COD_ACTIVIDAD_FORMULA" +
                    " inner join ACTIVIDADES_PRODUCCION a on a.COD_ACTIVIDAD = afm.COD_ACTIVIDAD and a.COD_ESTADO_REGISTRO = 1" +
                    " inner join personal pe on pe.COD_PERSONAL = s.COD_PERSONAL" +
                    " where s.FECHA_INICIO >= '2014/05/05 00:00:00' and s.FECHA_FINAL <= '2014/05/06 23:59:59'" +
                    " and s.COD_LOTE_PRODUCCION = p.COD_LOTE_PRODUCCION and s.COD_COMPPROD = p.COD_COMPPROD" +
                    " and s.COD_FORMULA_MAESTRA = p.COD_FORMULA_MAESTRA and s.COD_PROGRAMA_PROD = p.COD_PROGRAMA_PROD" +
                    " and s.COD_TIPO_PROGRAMA_PROD = p.COD_TIPO_PROGRAMA_PROD) segui" +
                    " where p.COD_TIPO_PROGRAMA_PROD = 1 and p.COD_LOTE_PRODUCCION" +
                    " in (select distinct sp.COD_LOTE_PRODUCCION from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sp" +
                    " where  sp.FECHA_INICIO >= '2014/05/05 00:00:00' and sp.FECHA_FINAL <= '2014/05/06 23:59:59') and segui.horas_hombre > 0" +
                    " and afm1.COD_AREA_EMPRESA in(96, 84, 102, 1003,97,76))as tabla" +
                    " group by nombre_area_empresa_cp,COD_LOTE_PRODUCCION,nombre_prod_semiterminado,nombre_area_empresa_actv,cod_area_empresa_actv,cod_compprod,cod_formula_maestra,cod_programa_prod,cod_lote_produccion" +
                    "  order by cod_lote_produccion,case when COD_AREA_EMPRESA_actv = 76 then 1" +
                    "  when COD_AREA_EMPRESA_actv =, 97 then 2" +
                    "  when COD_AREA_EMPRESA_actv = 96 then 3" +
                    "  when COD_AREA_EMPRESA_actv = 84 then 4  else 100 end  ";*/
                    //" order by cod_lote_produccion ";
            consulta = "	select nombre_area_empresa_cp,	"+
                        "	       COD_LOTE_PRODUCCION,	"+
                        "	       sum(horas_hombre) horas_hombre,	"+
                        "	       sum(unidades_producidas) unidades_producidas,	"+
                        "	       sum(unidades_producidas_extra) unidades_producidas_extra,	"+
                        "	       sum(horas_maquina) horas_maquina,	"+
                        "	       cod_compprod," +
                        "          nombre_prod_semiterminado,	"+
                        "	       nombre_area_empresa_actv,	"+
                        "	       cod_area_empresa_actv,	"+
                        "	       sum(horas_maquina_std) horas_maquina_std,	"+
                        "	       sum(horas_hombre_std) horas_hombre_std	"+
                        "	from (	"+
                        "	       select ae.nombre_area_empresa nombre_area_empresa_cp,	"+
                        "	              p.COD_LOTE_PRODUCCION,	"+
                        "	              segui.horas_hombre,	"+
                        "	              segui.unidades_producidas,	"+
                        "	              segui.unidades_producidas_extra,	"+
                        "	              segui.horas_maquina," +
                        "                 cp1.cod_compprod,	"+
                        "	              cp1.nombre_prod_semiterminado,	"+
                        "	              ae1.NOMBRE_AREA_EMPRESA nombre_area_empresa_actv,	"+
                        "	              ae1.COD_AREA_EMPRESA cod_area_empresa_actv,	"+
                        "	              maf.HORAS_HOMBRE horas_hombre_std,	"+
                        "	              maf.HORAS_MAQUINA horas_maquina_std,	"+
                        "	              apr.NOMBRE_ACTIVIDAD,	"+
                        "	              afm1.COD_ACTIVIDAD_FORMULA,	"+
                        "	              afm1.orden_actividad	"+
                        "	       from programa_produccion p	"+
                        "	            inner join componentes_prod cp1 on cp1.cod_compprod = p.cod_compprod	"+
                        "	            inner join areas_empresa ae on ae.cod_area_empresa =	"+
                        "	            cp1.cod_area_empresa	"+
                        "	            inner join FORMULA_MAESTRA f on f.COD_COMPPROD = cp1.COD_COMPPROD	"+
                        "	            and f.COD_ESTADO_REGISTRO = 1	"+
                        "	            inner join ACTIVIDADES_FORMULA_MAESTRA afm1 on	"+
                        "	            afm1.COD_FORMULA_MAESTRA = f.COD_FORMULA_MAESTRA	"+
                        "	            inner join ACTIVIDADES_PRODUCCION apr on apr.COD_ACTIVIDAD =	"+
                        "	            afm1.COD_ACTIVIDAD	"+
                        "	            inner join AREAS_EMPRESA ae1 on ae1.COD_AREA_EMPRESA =	"+
                        "	            afm1.COD_AREA_EMPRESA "+
                        "	            left outer join MAQUINARIA_ACTIVIDADES_FORMULA maf on	"+
                        "	            maf.COD_ACTIVIDAD_FORMULA = afm1.COD_ACTIVIDAD_FORMULA and	"+
                        "	            maf.COD_ESTADO_REGISTRO = 1	"+
                        "	            cross apply	"+
                        "	            (	"+
                        "	              select sum(datediff(second, s.FECHA_INICIO, s.FECHA_FINAL)) / 60.0	"+
                        "	              / 60.0 horas_hombre,	"+
                        "	                     sum(s.UNIDADES_PRODUCIDAS) unidades_producidas,	"+
                        "	                     sum(s.UNIDADES_PRODUCIDAS_EXTRA) unidades_producidas_extra,	"+
                        "	                     sum(sppr.HORAS_MAQUINA) horas_maquina	"+
                        "	              from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL s	"+
                        "	                   inner join SEGUIMIENTO_PROGRAMA_PRODUCCION sppr on	"+
                        "	                   sppr.COD_COMPPROD = s.COD_COMPPROD and	"+
                        "	                   sppr.COD_FORMULA_MAESTRA = s.COD_FORMULA_MAESTRA and	"+
                        "	                   sppr.COD_LOTE_PRODUCCION = s.COD_LOTE_PRODUCCION and	"+
                        "	                   sppr.COD_TIPO_PROGRAMA_PROD = s.COD_TIPO_PROGRAMA_PROD and	"+
                        "	                   sppr.COD_PROGRAMA_PROD = s.COD_PROGRAMA_PROD and	"+
                        "	                   sppr.COD_ACTIVIDAD_PROGRAMA = s.COD_ACTIVIDAD_PROGRAMA	"+
                        "	                   inner join ACTIVIDADES_FORMULA_MAESTRA afm on	"+
                        "	                   afm.COD_ACTIVIDAD_FORMULA = sppr.COD_ACTIVIDAD_PROGRAMA and	"+
                        "	                   afm.COD_FORMULA_MAESTRA = p.COD_FORMULA_MAESTRA and	"+
                        "	                   afm.COD_ESTADO_REGISTRO = 1 and afm.COD_ACTIVIDAD_FORMULA =	"+
                        "	                   afm1.COD_ACTIVIDAD_FORMULA	"+
                        "	                   inner join ACTIVIDADES_PRODUCCION a on a.COD_ACTIVIDAD =	"+
                        "	                   afm.COD_ACTIVIDAD and a.COD_ESTADO_REGISTRO = 1	"+
                        //"	                   inner join personal pe on pe.COD_PERSONAL = s.COD_PERSONAL	"+
                        "	              where " +
 //                       "s.FECHA_INICIO >= '2014/02/01 00:00:00' and	"+
 //                       "	                    s.FECHA_FINAL <= '2014/02/28 23:59:59' and	"+
                        "	                    s.COD_LOTE_PRODUCCION = p.COD_LOTE_PRODUCCION and	"+
                        "	                    s.COD_COMPPROD = p.COD_COMPPROD and	"+
                        "	                    s.COD_FORMULA_MAESTRA = p.COD_FORMULA_MAESTRA and	"+
                        "	                    s.COD_PROGRAMA_PROD = p.COD_PROGRAMA_PROD and	"+
                        "	                    s.COD_TIPO_PROGRAMA_PROD = p.COD_TIPO_PROGRAMA_PROD	"+
                        "	            ) segui	"+
                        "	       where 	"+ //p.COD_TIPO_PROGRAMA_PROD = 1 and
                        "	             p.COD_LOTE_PRODUCCION in " +
                        "   (select distinct iad.COD_LOTE_PRODUCCION from INGRESOS_ACOND ia" +
                        " inner join INGRESOS_DETALLEACOND iad on iad.COD_INGRESO_ACOND = ia.COD_INGRESO_ACOND" +
                        " inner join SALIDAS_DETALLEINGRESOACOND sd on sd.COD_COMPPROD = iad.COD_COMPPROD and sd.COD_LOTE_PRODUCCION collate traditional_spanish_CI_AI = iad.COD_LOTE_PRODUCCION " +
                        " and sd.COD_INGRESO_ACOND = iad.COD_INGRESO_ACOND" +
                        " inner join SALIDAS_DETALLEACOND sad on sad.COD_LOTE_PRODUCCION = sd.COD_LOTE_PRODUCCION collate traditional_spanish_CI_AI and sad.COD_COMPPROD = sd.COD_COMPPROD" +
                        " and sad.COD_SALIDA_ACOND = sd.COD_SALIDA_ACOND" +
                        " inner join SALIDAS_ACOND sa on sa.COD_SALIDA_ACOND = sad.COD_SALIDA_ACOND" +
                        " where sa.FECHA_SALIDAACOND between '"+sdf1.format(fechaInicio1.toDate())+" 00:00:00' and '"+sdf1.format(fechaInicio1.toDate())+" 23:59:59'" +
                        " and iad.CANT_RESTANTE=0  ) and	"+
                        "	             segui.horas_hombre > 0 and	"+
                        "	             afm1.COD_AREA_EMPRESA in (96, 84, 102, 1003,40,75,76,84,96,97,1001)" +
                        "	         union all" +
                        "            select top 1 '0','999999999999','0','0','0','0','0','0','0','0','0','0','0','0','0' from programa_produccion"+
                        "	     ) as tabla	"+
                        "	group by nombre_area_empresa_cp,	"+
                        "	         COD_LOTE_PRODUCCION," +
                        "            cod_compprod, "+
                        "	         nombre_prod_semiterminado,	"+
                        "	         NOMBRE_AREA_EMPRESA_actv,	"+
                        "	         cod_Area_empresa_actv	"+
                       "  order by cod_lote_produccion,	"+
                        "	         case	"+
                        "	           when cod_Area_empresa_actv = 76 then 1	"+
                        "	           when cod_area_empresa_actv = 97 then 2	"+
                        "	           when cod_Area_empresa_actv = 96 then 3	"+
                        "	           when cod_Area_empresa_Actv = 84 then 4	"+
                        "	           else 10  "+
                        "	         end";



                        /*	"+
                        "	select distinct ppia.COD_LOTE_PRODUCCION" +
                        "   from" +
                        "   PROGRAMA_PRODUCCION_INGRESOS_ACOND ppia" +
                        "   inner join INGRESOS_ACOND ia on ia.COD_INGRESO_ACOND = ppia.COD_INGRESO_ACOND" +
                        "   where ia.fecha_ingresoacond between '"+sdf1.format(fechaInicio1.toDate())+" 00:00:00' and '"+sdf1.format(fechaInicio1.toDate())+" 23:59:59'	"+*/


            /* "+
                        "	select distinct ppia.COD_LOTE_PRODUCCION" +
                        "   from" +
                        "   PROGRAMA_PRODUCCION_INGRESOS_ACOND ppia" +
                        "   inner join INGRESOS_ACOND ia on ia.COD_INGRESO_ACOND = ppia.COD_INGRESO_ACOND" +
                        "   where ia.fecha_ingresoacond between '"+sdf1.format(fechaInicio1.toDate())+" 00:00:00' and '"+sdf1.format(fechaInicio1.toDate())+" 23:59:59' "+
                        "	              */

            System.out.println("consulta " + consulta);
            //con = null;
            //con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            st.executeUpdate("set dateformat ymd");
            ResultSet rs = st.executeQuery(consulta);
            String nombreProducto = "";
            String codLoteProduccion = "";
            int count = 0;
            //en la primera pasada sacamos los rowspan para el producto y lote
            String detalle = "";
            String reporteLote = "";
            if(rs.next()){
                nombreProducto = rs.getString("nombre_prod_semiterminado");
                codLoteProduccion = rs.getString("cod_lote_produccion");
            }
            rs.beforeFirst();
            double cantidadProducida = 0.0;
            double totalHorasHombreLote = 0.0;
            double totalHorasMaquinaLote = 0.0;

            double totalHorasHombreStd = 0.0;
            double totalHorasMaquinaStd = 0.0;

            double totalHorasHombre = 0.0;
            double totalHorasMaquina = 0.0;

            double cantUnitariaTotal = 0.0;
            double cantMMTotal = 0.0;
            double cantEstabilidad = 0.0 ;
            double cantCCTotal = 0.0;
            double cantSaldos = 0.0;

            //this.tamLote(rs.getInt("cod_compprod"), codLoteProduccion)*100)



            while(rs.next()){
                //PRIMERO GUARDAR EL DETALLE Y CONTABILIZAR CADA DETALLE DESPUES GUARDAR CON LA CABEZERA
                //System.out.println("lote repasado " + rs.getString("cod_lote_produccion"));

                //if(this.loteCerrado(rs.getString("cod_lote_produccion"), rs.getInt("cod_compprod"))==1){

                if(!(nombreProducto+codLoteProduccion).equals(rs.getString("nombre_prod_semiterminado")+rs.getString("cod_lote_produccion"))){


                    reporteLote += "<tr class='tablaFiltroReporte'><td rowspan='"+count+"' style='border : solid #f2f2f2 1px;'>"+codLoteProduccion+"</td>" +
                                   "<td rowspan='"+count+"' style='border : solid #f2f2f2 1px;'>"+nombreProducto+"</td>"+detalle+"  ";
                    //detalle producto y tiempos


                      cantUnitariaTotal +=   this.cantUnitariaTotal(rs.getInt("cod_compprod"), codLoteProduccion);
                      cantMMTotal +=   this.cantMMTotal(rs.getInt("cod_compprod"), codLoteProduccion);
                      cantEstabilidad +=  this.cantEstabilidadTotal(rs.getInt("cod_compprod"), codLoteProduccion);

                       cantCCTotal += this.cantCCTotal(rs.getInt("cod_compprod"), codLoteProduccion);
                       cantSaldos +=  this.saldos(rs.getInt("cod_compprod"), codLoteProduccion);






                    count = 0;
                    detalle = "";
                    nombreProducto=rs.getString("nombre_prod_semiterminado");


                  }
                if(!codLoteProduccion.equals(rs.getString("cod_lote_produccion"))){
                    reporteLote += "<tr class='tablaFiltroReporte' style='background-color:#f2f2f2'>" +
                            " <td style='border : solid #f2f2f2 1px;text-align:right' colspan=3><b>total</b></td>" +
                            " <td style='border : solid #f2f2f2 1px;text-align:center'><b>"+formato.format(totalHorasHombreLote)+"</b></td>" +
                            " <td style='border : solid #f2f2f2 1px;text-align:center'><b>"+formato.format(totalHorasMaquinaLote)+"</b></td>" +
                            " <td style='border : solid #f2f2f2 1px;text-align:center'><b>"+formato.format(totalHorasHombreStd)+"</b></td>" +
                            " <td style='border : solid #f2f2f2 1px;text-align:center'><b>"+formato.format(totalHorasMaquinaStd)+"</b></td>"+
                            " <td style='border : solid #f2f2f2 1px;text-align:center'><b>"+cantidadProducida+"</b></td>" +

                            " <td  align='center' style='border : solid #f2f2f2 1px;' ><b>"+formato.format(( //this.cantEnvAPT(rs.getInt("cod_compprod"), codLoteProduccion)+
                                                                                                                     (cantUnitariaTotal
                                                                                                                    +cantMMTotal
                                                                                                                    +cantEstabilidad
                                                                                                                    +cantCCTotal+cantSaldos)/this.tamLote(rs.getInt("cod_CompProd"), codLoteProduccion)*100))+
                            " ";

                   cantUnitariaTotal=0.0;
                   cantMMTotal = 0.0;
                   cantEstabilidad=0.0;
                   cantCCTotal=0.0;
                   cantSaldos=0.0;

                    reporteLote += " ";
                    totalHorasHombreLote = 0.0;
                    totalHorasMaquinaLote = 0.0;
                    totalHorasHombreStd = 0.0;
                    totalHorasMaquinaStd = 0.0;
                    nombreProducto=rs.getString("nombre_prod_semiterminado");
                    codLoteProduccion=rs.getString("cod_lote_produccion");
                }
                 count ++;

                 //if(rs.getInt("cod_Area_empresa_actv")==96)
                 //    cantidadProducida = this.cantidadEnvAcond(rs.getInt("cod_compprod"),rs.getString("cod_lote_produccion"));
                 //if(rs.getInt("cod_Area_empresa_actv")==84)
                     cantidadProducida = this.cantidadEnvAPT(rs.getInt("cod_compprod"),rs.getString("cod_lote_produccion"));
                 //<td  align='center' style='border : solid #f2f2f2 1px;'>"+rs.getString("cod_lote_produccion")+" - "+count+"</td>
                 detalle += "<td  align='center' style='border : solid #f2f2f2 1px;'>"+rs.getString("nombre_area_empresa_actv")+"</td>"+
                    " <td  align='center' style='border : solid #f2f2f2 1px;'>"+formato.format(rs.getDouble("horas_hombre"))+"</td>"+
                    " <td  align='center' style='border : solid #f2f2f2 1px;' >"+formato.format(rs.getDouble("horas_maquina"))+"</td>" +

                    //" <td  align='center' style='border : solid #f2f2f2 1px;' >"+formato.format(rs.getDouble("unidades_producidas_extra"))+"</td>" +
                    " <td  align='center' style='border : solid #f2f2f2 1px;' >"+formato.format(rs.getDouble("horas_hombre_std"))+"</td>" +
                    " <td  align='center' style='border : solid #f2f2f2 1px;' >"+formato.format(rs.getDouble("horas_maquina_std"))+"</td>" +
                    " <td  align='center' style='border : solid #f2f2f2 1px;' ></td><td></td>" +//"+formato.format(cantidadProducida)+"

                    //" <td  align='center' style='border : solid #f2f2f2 1px;' >"+formato.format(rs.getDouble("cantidadEnviadaAPT")/rs.getDouble("horas_hombre"))+"</td>" +
                    "</tr> ";
                 totalHorasHombreLote +=rs.getDouble("horas_hombre");
                 totalHorasMaquinaLote +=rs.getDouble("horas_maquina");
                 totalHorasHombreStd+=rs.getDouble("horas_hombre_std");
                 totalHorasMaquinaStd +=rs.getDouble("horas_maquina_std");


            //}
            }


            String mensajeCorreo =
                    " Ingeniero:<br/> Se registro la siguiente informacion de seguimiento a produccion con productos cerrados en fecha  "+sdf2.format(fechaInicio1.toDate())+" :<br/> "  + //hasta  "+sdf1.format(fechaFinal1.toDate())+"
                    "<table  align='center' width='60%' style='text-align:left' style = 'font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 10px;border : solid #f2f2f2 1px;' cellpadding='0' cellspacing='0'><br/><br/>";
            mensajeCorreo += " <tr class='tablaFiltroReporte'>" +
                            " <th  align='center' style='border : solid #f2f2f2 1px;' >LOTE</th>" +
                            " <th  align='center' style='border : solid #f2f2f2 1px;' >PRODUCTO</th>" +
                            " <th  align='center' style='border : solid #f2f2f2 1px;' >AREA ETAPA</th>" +

                            " <th  align='center' style='border : solid #f2f2f2 1px;' >HORAS HOMBRE</th>" +
                            " <th  align='center' style='border : solid #f2f2f2 1px;' >HORAS MAQUINA</th>" +
                              " <th  align='center' style='border : solid #f2f2f2 1px;' >HORAS HOMBRE STD</th>" +
                            " <th  align='center' style='border : solid #f2f2f2 1px;' >HORAS MAQUINA STD</th>" +
                            " <th  align='center' style='border : solid #f2f2f2 1px;' >CANT ENV. APT</th>" +
                            " <th  align='center' style='border : solid #f2f2f2 1px;' >RENDIMIENTO</th>" +
                            //" <th  align='center' style='border : solid #f2f2f2 1px;' >UNIDADES PRODUCIDAS EXTRA</th>" +
                            //" <th  align='center' style='border : solid #f2f2f2 1px;' >AREA</th>" +
                            //" <th  align='center' style='border : solid #f2f2f2 1px;' >ACTIVIDAD</th>" +

                            //" <th  align='center' style='border : solid #f2f2f2 1px;' >PRODUCTIVIDAD</th>" +
                            " </tr>"+reporteLote;

            mensajeCorreo +="</table><br/><br/><span style='color:blue'>Sistema Atlas</span>";
            InternetAddress emails[] = new InternetAddress[3];
            emails[0]=new InternetAddress("jrivera@cofar.com.bo");
            emails[1]=new InternetAddress("hvaldivia@cofar.com.bo");
            emails[2]=new InternetAddress("aquispe@cofar.com.bo");
             Properties props = new Properties();
             props.put("mail.smtp.host", "mail.cofar.com.bo");
             props.put("mail.transport.protocol", "smtp");
             props.put("mail.smtp.auth", "false");
             props.setProperty("mail.user", "traspasos@cofar.com.bo");
             props.setProperty("mail.password", "n3td4t4");
             Session mailSession = Session.getInstance(props, null);
             Message msg = new MimeMessage(mailSession);
             msg.setSubject("Notificacion de Tiempos Atlas");
             msg.setFrom(new InternetAddress("traspasos@cofar.com.bo", "Notificacion de Tiempos Atlas"));
             msg.addRecipients(Message.RecipientType.TO, emails);

             String contenido = " <html> <head>  <title></title> " +
                     " <meta http-equiv='Content-Type' content='text/html; charset=windows-1252'> " +
                     " </head> " +
                     " <body style='font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 10px'>" + mensajeCorreo +
                     " </body> </html> " ;
            msg.setContent(contenido, "text/html");
            javax.mail.Transport.send(msg);

        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
        return null;
    }

    double cantEnvAPT(int codCompProd,String codLoteProduccion){
    double cantEnvAPT = 0.0;
    try{
        String consulta = " select SUM(sd.CANT_TOTAL_SALIDADETALLEACOND) cant"+
                          " from SALIDAS_ACOND sa inner join SALIDAS_DETALLEACOND sd on"+
                          " sa.COD_SALIDA_ACOND=sd.COD_SALIDA_ACOND"+
                          " where sa.COD_ALMACEN_VENTA in (54,56,57)"+ //select av.COD_ALMACEN_VENTA from ALMACENES_VENTAS av where av.COD_AREA_EMPRESA=1
                          " and sd.COD_LOTE_PRODUCCION='"+codLoteProduccion+"' and sd.COD_COMPPROD='"+codCompProd+"' and "+
                          " sa.COD_ESTADO_SALIDAACOND not in (2) ";
        /*(case when t.COD_TIPO_PROGRAMA_PROD=1 then 54 else 0 end," +
                          " case when t.COD_TIPO_PROGRAMA_PROD=2 then 56 else 0 end," +
                          " case when t.COD_TIPO_PROGRAMA_PROD=3 then 57 else 0 end)*/
        //System.out.println("consulta ->>>>>>" + consulta);
       
        Statement st = con.createStatement();
        ResultSet rs = st.executeQuery(consulta);
        if(rs.next()){
            cantEnvAPT = rs.getDouble("cant");
        }
        rs.close();
        st.close();
        



    }catch(Exception e){
        e.printStackTrace();
    }
    return cantEnvAPT;
}

double cantUnitariaTotal(int codCompProd,String codLoteProduccion){
    double cantEnvAPT = 0.0;
    try{
        String consulta = " select sum((p.cantidad_presentacion * id.CANTIDAD) + id.CANTIDAD_UNITARIA) cant "+
                    " from INGRESOS_VENTAS i,   INGRESOS_DETALLEVENTAS id,     PRESENTACIONES_PRODUCTO p "+
                    " where id.COD_INGRESOVENTAS = i.COD_INGRESOVENTAS and "+
                    " id.COD_PRESENTACION = p.cod_presentacion and  i.COD_AREA_EMPRESA = 1 and "+
                    " id.COD_AREA_EMPRESA = 1 and i.COD_ALMACEN_VENTA in (54, 56) and "+
                    " i.FECHA_INGRESOVENTAS <= getdate() "+
                    " and   i.COD_ESTADO_INGRESOVENTAS not in  (2)  and id.COD_LOTE_PRODUCCION='"+codLoteProduccion+"' "+
                    //sql+=" and id.COD_PRESENTACION="+codPresentacion;
                    " group by id.COD_LOTE_PRODUCCION";
        //System.out.println("consulta ->>>>>>" + consulta);
       
        Statement st = con.createStatement();
        ResultSet rs = st.executeQuery(consulta);
        if(rs.next()){
            cantEnvAPT = rs.getDouble("cant");
        }
        rs.close();
        st.close();
        



    }catch(Exception e){
        e.printStackTrace();
    }
    return cantEnvAPT;
}
double cantMMTotal(int codCompProd,String codLoteProduccion){
    double cantEnvAPT = 0.0;
    try{
        String consulta = " select sum(sad.CANT_TOTAL_SALIDADETALLEACOND),  " +
                            " (select sum((id.CANTIDAD*p.cantidad_presentacion)+id.CANTIDAD_UNITARIA)  from INGRESOS_VENTAS i, INGRESOS_DETALLEVENTAS id, " +
                            " PRESENTACIONES_PRODUCTO p where id.COD_INGRESOVENTAS = i.COD_INGRESOVENTAS and " +
                            " i.COD_AREA_EMPRESA = 1 and i.COD_AREA_EMPRESA=id.COD_AREA_EMPRESA and id.COD_PRESENTACION=p.cod_presentacion " +
                            " and id.COD_AREA_EMPRESA = 1 and i.COD_ALMACEN_VENTA in (57) and i.FECHA_INGRESOVENTAS <= getdate() and " +
                            " id.COD_LOTE_PRODUCCION in ('"+codLoteProduccion+"') and i.COD_ESTADO_INGRESOVENTAS <> 2)as cantidadAPT "+
                    " from SALIDAS_ACOND sa,SALIDAS_DETALLEACOND sad where sa.COD_SALIDA_ACOND=sad.COD_SALIDA_ACOND and sad.COD_SALIDA_ACOND in( "+
                    " select  DISTINCT i.COD_SALIDA_ACOND from INGRESOS_VENTAS i,INGRESOS_DETALLEVENTAS id where id.COD_INGRESOVENTAS=i.COD_INGRESOVENTAS "+
                    " and i.COD_AREA_EMPRESA=1 and id.COD_AREA_EMPRESA=1 and i.COD_ALMACEN_VENTA in(57) "+
                    " and i.FECHA_INGRESOVENTAS <= getdate() and id.COD_LOTE_PRODUCCION='"+codLoteProduccion+"' "+
                    " and i.COD_ESTADO_INGRESOVENTAS<>2 ) and sa.COD_ESTADO_SALIDAACOND<>2 group by COD_COMPPROD,COD_LOTE_PRODUCCION,cod_presentacion ";
        //System.out.println("consulta ->>>>>>" + consulta);
        
        Statement st = con.createStatement();
        ResultSet rs = st.executeQuery(consulta);
        if(rs.next()){
            cantEnvAPT = rs.getDouble("cant");
        }
        rs.close();
        st.close();
       

    }catch(Exception e){
        e.printStackTrace();
    }
    return cantEnvAPT;
}

double cantEstabilidadTotal(int codCompProd,String codLoteProduccion){
    double cantEnvAPT = 0.0;
    try{
        String consulta = " select  (select  c.nombre_prod_semiterminado from COMPONENTES_PROD c where c.COD_COMPPROD=sad.COD_COMPPROD), "+
                    " sad.COD_COMPPROD,sad.COD_LOTE_PRODUCCION,sum(sad.CANT_TOTAL_SALIDADETALLEACOND) cant "+
                    " from SALIDAS_ACOND sa,SALIDAS_DETALLEACOND sad where sa.COD_SALIDA_ACOND=sad.COD_SALIDA_ACOND and "+
                    " sa.COD_ESTADO_SALIDAACOND<>2  and sa.COD_ALMACENACOND_DESTINO in(6) and  COD_LOTE_PRODUCCION='"+codLoteProduccion+"' and COD_COMPPROD="+codCompProd+" group by COD_COMPPROD,COD_LOTE_PRODUCCION ";
        //System.out.println("consulta ->>>>>>" + consulta);
       
        Statement st = con.createStatement();
        ResultSet rs = st.executeQuery(consulta);
        if(rs.next()){
            cantEnvAPT = rs.getDouble("cant");
        }
        rs.close();
        st.close();
       



    }catch(Exception e){
        e.printStackTrace();
    }
    return cantEnvAPT;
}

double cantCCTotal(int codCompProd,String codLoteProduccion){
    double cantEnvAPT = 0.0;
    try{
        String consulta = " select  (select  c.nombre_prod_semiterminado from COMPONENTES_PROD c where c.COD_COMPPROD=sad.COD_COMPPROD), "+
                    " sad.COD_COMPPROD,sad.COD_LOTE_PRODUCCION,sum(sad.CANT_TOTAL_SALIDADETALLEACOND) cant "+
                    " from SALIDAS_ACOND sa,SALIDAS_DETALLEACOND sad where sa.COD_SALIDA_ACOND=sad.COD_SALIDA_ACOND and "+
                    " sa.COD_ESTADO_SALIDAACOND<>2  and sa.COD_ALMACEN_VENTA in (29) and  COD_LOTE_PRODUCCION='"+codLoteProduccion+"' and COD_COMPPROD="+codCompProd+" group by COD_COMPPROD,COD_LOTE_PRODUCCION ";

        //System.out.println("consulta ->>>>>>" + consulta);
       
        Statement st = con.createStatement();
        ResultSet rs = st.executeQuery(consulta);
        if(rs.next()){
            cantEnvAPT = rs.getDouble("cant");
        }
        rs.close();
        st.close();
        

    }catch(Exception e){
        e.printStackTrace();
    }
    return cantEnvAPT;
}
double cantSaldosTotal(int codCompProd,String codLoteProduccion){
    double cantEnvAPT = 0.0;
    try{
        String consulta = "select  (select  c.nombre_prod_semiterminado from COMPONENTES_PROD c where c.COD_COMPPROD=sad.COD_COMPPROD), "+
                    " sad.COD_COMPPROD,sad.COD_LOTE_PRODUCCION,sum(sad.CANT_TOTAL_SALIDADETALLEACOND) cant "+
                    " from SALIDAS_ACOND sa,SALIDAS_DETALLEACOND sad where sa.COD_SALIDA_ACOND=sad.COD_SALIDA_ACOND and "+
                    " sa.COD_ESTADO_SALIDAACOND<>2  and sa.COD_ALMACENACOND_DESTINO in(4) and  COD_LOTE_PRODUCCION='"+codLoteProduccion+"' and COD_COMPPROD="+codCompProd+" group by COD_COMPPROD,COD_LOTE_PRODUCCION ";

        //System.out.println("consulta ->>>>>>" + consulta);
        
        Statement st = con.createStatement();
        ResultSet rs = st.executeQuery(consulta);
        if(rs.next()){
            cantEnvAPT = rs.getDouble("cant");
        }
        rs.close();
        st.close();
        

    }catch(Exception e){
        e.printStackTrace();
    }
    return cantEnvAPT;
}

double tamLote(int codCompProd,String codLoteProduccion){
    double cantEnvAPT = 0.0;
    try{
        String consulta = "  select sum(cant_lote_produccion) tam_lote_produccion" +
                " from programa_produccion p where p.cod_lote_produccion='"+codLoteProduccion+"' ";

        //System.out.println("consulta ->>>>>>" + consulta);
       
        Statement st = con.createStatement();
        ResultSet rs = st.executeQuery(consulta);
        if(rs.next()){
            cantEnvAPT = rs.getDouble("tam_lote_produccion");
        }
        rs.close();
        st.close();
        

    }catch(Exception e){
        e.printStackTrace();
    }
    return cantEnvAPT;
}
double saldos(int codCompProd,String codLoteProduccion){
    double cantEnvAPT = 0.0;
    try{
        String consulta = " select  (select  c.nombre_prod_semiterminado from COMPONENTES_PROD c where c.COD_COMPPROD=sad.COD_COMPPROD), "+
                    " sad.COD_COMPPROD,sad.COD_LOTE_PRODUCCION,sum(sad.CANT_TOTAL_SALIDADETALLEACOND) "+
                    " from SALIDAS_ACOND sa,SALIDAS_DETALLEACOND sad where sa.COD_SALIDA_ACOND=sad.COD_SALIDA_ACOND and "+
                    " sa.COD_ESTADO_SALIDAACOND<>2  and sa.COD_ALMACENACOND_DESTINO in(4) and  COD_LOTE_PRODUCCION='"+codLoteProduccion+"' and COD_COMPPROD="+codCompProd+" group by COD_COMPPROD,COD_LOTE_PRODUCCION ";

        //System.out.println("consulta ->>>>>>" + consulta);
        
        Statement st = con.createStatement();
        ResultSet rs = st.executeQuery(consulta);
        if(rs.next()){
            cantEnvAPT = rs.getDouble("tam_lote_produccion");
        }
        rs.close();
        st.close();
        

    }catch(Exception e){
        e.printStackTrace();
    }
    return cantEnvAPT;
}
public int loteCerradox(String codLoteProduccion, int codCompProd){
    int loteCerrado = 0;
    try {
        int cantidadCerradoSalida = 0;
        int cantidadCerradoIngreso = 0;
        String consulta ="  select  count(*) count,'IN' in from INGRESOS_ACOND i,INGRESOS_DETALLEACOND id where id.COD_INGRESO_ACOND=i.COD_INGRESO_ACOND "+
                    " and i.COD_TIPOINGRESOACOND=5 and id.COD_LOTE_PRODUCCION='"+codLoteProduccion+"' and id.COD_COMPPROD='"+codCompProd +"'"+
                    " UNION "+
                    " select count(*) cout,'SA' sa from SALIDAS_ACOND sa,SALIDAS_DETALLEACOND sad" +
                    " where  "+
                    " sad.COD_SALIDA_ACOND=sa.COD_SALIDA_ACOND and sa.COD_TIPOSALIDAACOND=6 and COD_LOTE_PRODUCCION='"+codLoteProduccion+"'" +
                    " and  sad.COD_COMPPROD='"+codCompProd+"'";
        System.out.println("consulta " + consulta );
        Statement st = con.createStatement();
        ResultSet rs = st.executeQuery(consulta);
        while(rs.next()){

                        if(rs.getString("in").equals("IN")){
                            cantidadCerradoIngreso=rs.getInt("count");
                        }

                        if(rs.getString("sa").equals("SA")){
                            cantidadCerradoSalida=rs.getInt("count");
                        }
                    }
         loteCerrado=(cantidadCerradoIngreso>0)?1:0;

                    if(loteCerrado==0){
                        loteCerrado=(cantidadCerradoSalida>0)?1:0;
                    }

                    if(loteCerrado==0){
                        consulta="select i.COD_INGRESO_ACOND from INGRESOS_DETALLEACOND id, INGRESOS_ACOND i where " +
                                " i.COD_INGRESO_ACOND=id.COD_INGRESO_ACOND and i.COD_ESTADO_INGRESOACOND not in (1,2) and " +
                                " id.COD_LOTE_PRODUCCION='"+codLoteProduccion+"' and id.loteCerrado=1";
                        System.out.println("consulta " + consulta);
                        Statement stVeriLote=con.createStatement();
                        ResultSet rsVeriLote=stVeriLote.executeQuery(consulta);
                        if(rsVeriLote.next()){
                            loteCerrado=1;
                        }
                    }


    } catch (Exception e) {
        e.printStackTrace();
    }
    return 0;
}



    public String enviarCorreoRevisionBiblioteca(){
        try {
            DecimalFormat formato=null;
            NumberFormat numeroformato = NumberFormat.getNumberInstance(Locale.ENGLISH);
            formato = (DecimalFormat) numeroformato;
            formato.applyPattern("###0.00;(###0.00)");
            DateTime fechaInicio1= new DateTime();
            DateTime fechaFinal1 = new DateTime();
            fechaInicio1= fechaInicio1.minusDays(2);
            fechaFinal1=fechaFinal1.minusDays(1);
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
            SimpleDateFormat sdf1 = new SimpleDateFormat("dd/MM/yyyy");
            String consulta = " select d.NOMBRE_DOCUMENTO,pr.cod_personal,pr.NOMBRE_PILA + ' ' + pr.nombre2_personal + ' '+pr.AP_PATERNO_PERSONAL + ' ' + pr.AP_MATERNO_PERSONAL nombre_personal,p.fecha_asignacion,p.fecha_revision_final,cp.nombre_correopersonal " +
                    " from DOCUMENTACION_REVISION_PERSONAL p inner join DOCUMENTACION d on d.COD_DOCUMENTO = p.COD_DOCUMENTO" +
                    " inner join personal pr on pr.COD_PERSONAL = p.COD_PERSONAL_ASIGNADO inner join correo_personal cp on cp.cod_personal = p.cod_personal_asignado " +
                    " where p.cod_estado_revision = 1 ";
            System.out.println("consulta " + consulta);
            //con = null;
            //con = Util.openConnection(con);
            Statement st = con.createStatement();
            st.executeUpdate("set dateformat ymd");
            ResultSet rs = st.executeQuery(consulta);
            String nombreAreaEmpresa = "";
            String mensajeCorreo = "";
            while(rs.next()){
                mensajeCorreo = " Estimado(a) " + rs.getString("nombre_personal");
                mensajeCorreo += "<br/>En fecha '"+sdf.format(rs.getDate("fecha_asignacion"))+"' se le asignó el documento '"+rs.getString("nombre_documento")+"' para que realize la modificación y/o actualización y envío del documento a ASC ya actualizado hasta "+sdf.format(rs.getDate("fecha_revision_final"))+" ";
                mensajeCorreo +="<br/> <p style='color:blue'>Sistema de Documentacion</p> ";
                mensajeCorreo +="</table>";
                enviarCorreo(rs.getString("cod_personal")+"", mensajeCorreo, "Notificacion de Biblioteca", "Notificacion",con);
            }





        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public static String enviarCorreo(String codPersonal,String mensaje,String asunto,String enviadoPor,Connection con){
         try {
             
             String consulta = " select nombre_correopersonal from correo_personal c where c.cod_personal in ("+ codPersonal +") ";
             System.out.println("consulta " + consulta);
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(consulta);
             InternetAddress emails[] = new InternetAddress[codPersonal.split(",").length];
             int i = 0;
             while(rs.next()){
             emails[i]=new InternetAddress(rs.getString("nombre_correopersonal"));
             i++;
             }
             Properties props = new Properties();
             props.put("mail.smtp.host", "mail.cofar.com.bo");
             props.put("mail.transport.protocol", "smtp");
             props.put("mail.smtp.auth", "false");
             props.setProperty("mail.user", "traspasos@cofar.com.bo");
             props.setProperty("mail.password", "n3td4t4");
             Session mailSession = Session.getInstance(props, null);
             Message msg = new MimeMessage(mailSession);
             msg.setSubject(asunto);
             msg.setFrom(new InternetAddress("traspasos@cofar.com.bo", enviadoPor));
             msg.addRecipients(Message.RecipientType.TO, emails);

             String contenido = " <html> <head>  <title></title> " +
                     " <meta http-equiv='Content-Type' content='text/html; charset=windows-1252'> " +
                     " </head> " +
                     " <body style='font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 10px'>" + mensaje +
                     " </body> </html> " ;
            msg.setContent(contenido, "text/html");
            javax.mail.Transport.send(msg);
             //System.out.println("cp "+rs.getString("nombre_correopersonal"));
         } catch (Exception e) {
             e.printStackTrace();
         }
         return null;
     }
    public static void main(String[] args) {
        //TareasZeus t=new TareasZeus();
        //t.cambiarClienteContado();
    }

    public void cambiarClienteContado(){


        SimpleDateFormat f=new SimpleDateFormat("yyyy-MM-dd");
        java.util.Date fechaActual=new java.util.Date();




        String fecha = f.format(fechaActual);
        String codCliente= "0";
        String codAreaEmpresa="49";
        //ManagedAccesoSistema bean=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
        //String codAreaEmpresa=bean.getCodAreaEmpresaGlobal();


        String codTipoDocumento="1,2,3";
        String nombreTipoDocumento="";
        String codCondicionPagoF="1,2";
        String nombreCondicionPagoF="";
        String verMora="";
        String verDetalle="";
        String incluirVendedor="";





        String fecha1=fecha;
        String sql="";
        String sql1="";
        String sql2="";

        Connection con=null;



        String cod_salidaventa="";
        String nro_salidaventa="";
        String fecha_salidaventa="";
        String cod_estado_salidaventa="";
        String nombre_estado_salidaventa="";
        String cod_almacen_venta="";
        String cod_cliente="";
        String nombre_cliente="";
        String cod_tipodoc_venta="";
        String abrev_tipodoc_venta="";
        String nro_factura="";
        String razon_social="";
        double monto_total=0;
        double monto_cancelado=0;
        double saldo=0;
        String nombre_area_empresa="";
        String cod_area_empresa="";
        String clientePivote="";
        String areaEmpresaPivote="";
        double clienteImporte=0;
        double clienteSaldo=0;
        double clienteACuenta=0;
        double total_cobranza=0;
        double totalImporte=0;
        double totalAcuenta=0;
        double totalSaldo=0;
        NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
        DecimalFormat form = (DecimalFormat)nf;
        form.applyPattern("#,###.00");

        try{
            con=conexion;




            sql=" select sv.cod_salidaventa, sv.nro_salidaventa, sv.fecha_salidaventa,";
            sql+=" sv.cod_estado_salidaventa,esv.nombre_estado_salidaventa,";
            sql+=" sv.cod_almacen_venta ,sv.cod_cliente, (select nombre_cliente from clientes c where sv.cod_cliente=c.cod_cliente) as nombre_cliente,";
            sql+=" sv.cod_tipodoc_venta, tdv.abrev_tipodoc_venta,sv.nro_factura,";
            sql+=" sv.monto_total,sv.monto_cancelado,";
            sql+=" av.cod_area_empresa, ae.nombre_area_empresa, ";
            sql+=" (select ISNULL(sum(monto_cobranza),0)as total_cobranza from cobranzas_detalle cd, cobranzas c " +
                    " where cd.cod_cobranza=c.cod_cobranza and cd.cod_area_empresa=c.cod_area_empresa  and cd.cod_area_empresa="+codAreaEmpresa+" and c.fecha_cobranza<='"+fecha1+" 23:59:59' and sv.COD_TIPODOC_VENTA in("+codTipoDocumento+")" +
                    " and cd.cod_salidaventa=sv.cod_salidaventa and c.cod_estado_cobranza<>2) as total_cobranza,";
            sql+=" (select cod_tipocliente from clientes c where sv.cod_cliente=c.cod_cliente) as cod_tipocliente ";
            sql+=" from salidas_ventas sv ,";
            sql+=" tipo_documentos_ventas tdv, estados_salida_ventas esv,";
            sql+=" almacenes_ventas av, areas_empresa ae ";
            sql+=" where ";
            sql+=" monto_total>(select ISNULL(sum(monto_cobranza), 0)+1 from ";
            sql+=" cobranzas_detalle cd, cobranzas c where cd.cod_cobranza = c.cod_cobranza  and cd.cod_area_empresa= c.cod_area_empresa and cd.cod_area_empresa="+codAreaEmpresa;
            sql+=" and c.fecha_cobranza <= '"+fecha1+" 23:59:59' and cd.cod_salidaventa = sv.cod_salidaventa and c.cod_estado_cobranza<>2)";
            sql+=" and sv.cod_tipodoc_venta=tdv.cod_tipodoc_venta and sv.COD_TIPODOC_VENTA in("+codTipoDocumento+")";
            sql+=" and sv.cod_estado_salidaventa=esv.cod_estado_salidaventa and sv.cod_estado_salidaventa=1 ";
            if(!codCliente.equals("0")){
                sql+=" and sv.cod_cliente='"+codCliente+"' ";
            }
            sql+=" and sv.fecha_salidaventa<='"+fecha1+" 23:59:59'";
            sql+=" and sv.cod_almacen_venta=av.cod_almacen_venta";
            if(!codAreaEmpresa.equals("0")){
                sql+=" and av.cod_area_empresa='"+codAreaEmpresa+"' ";
            }
            sql+=" and av.cod_area_empresa=ae.cod_area_empresa";
            sql+=" and sv.monto_total >(select ISNULL(sum(monto_cobranza),0)as total_cobranza  from cobranzas_detalle cd, cobranzas c  where cd.cod_cobranza=c.cod_cobranza  and cd.cod_area_empresa=c.cod_area_empresa and cd.cod_area_empresa in("+codAreaEmpresa+") and c.fecha_cobranza<='"+fecha1+" 23:59:59' and cd.cod_salidaventa=sv.cod_salidaventa and c.cod_estado_cobranza<>2)";
            sql+=" and sv.cod_tipoventa in ("+codCondicionPagoF+")";

            sql+=" and sv.cod_area_empresa in ("+codAreaEmpresa+")";

            sql+=" order by ae.nombre_area_empresa, nombre_cliente asc, sv.fecha_salidaventa";

            System.out.println(sql);


            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(sql);
            int sw1=0;
            int sw2=0;
            String cod_tipocliente="0";
            String obsDoc="";
            int banderaMoroso=0;

            while (rs.next()){

                cod_salidaventa=rs.getString("cod_salidaventa");
                nro_salidaventa=rs.getString("nro_salidaventa");
                fecha_salidaventa=rs.getString("fecha_salidaventa");
                String[] vectorFechaAux1 = fecha_salidaventa.split(" ");
                vectorFechaAux1=vectorFechaAux1[0].split("-");
                fecha_salidaventa=vectorFechaAux1[2]+"/"+vectorFechaAux1[1]+"/"+vectorFechaAux1[0];
                cod_estado_salidaventa=rs.getString("cod_estado_salidaventa");
                nombre_estado_salidaventa=rs.getString("nombre_estado_salidaventa");
                cod_almacen_venta=rs.getString("cod_almacen_venta");
                cod_cliente=rs.getString("cod_cliente");
                nombre_cliente=rs.getString("nombre_cliente");
                cod_tipodoc_venta=rs.getString("cod_tipodoc_venta");
                abrev_tipodoc_venta=rs.getString("abrev_tipodoc_venta");
                nro_factura=rs.getString("nro_factura");
                razon_social="";
                monto_total=rs.getFloat("monto_total");
                monto_cancelado=rs.getFloat("monto_cancelado");
                cod_area_empresa=rs.getString("cod_area_empresa");
                nombre_area_empresa=rs.getString("nombre_area_empresa");
                //razon_social=rs.getString("razon_social");
                total_cobranza=rs.getFloat("total_cobranza");
                cod_tipocliente=rs.getString("cod_tipocliente");



                //VEMOS PARA LOS MOROSOS
                String [] vectorFechaJoda = fecha_salidaventa.split("/");
                DateTime dt = new DateTime(Integer.parseInt(vectorFechaJoda[2]), Integer.parseInt(vectorFechaJoda[1]), Integer.parseInt(vectorFechaJoda[0]), 12, 0, 0, 0);
                //DateTime dt = new DateTime(2008, 11, 1, 0, 0, 0, 0);
                int diasMorosos=0;
                //sacamos los dias que tienen de mora
                String sqlMora="select dias_optimo from dias_credito where cod_area_empresa="+cod_area_empresa;
                Statement stMora=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rsMora=stMora.executeQuery(sqlMora);
                while(rsMora.next()){
                    diasMorosos=rsMora.getInt("dias_optimo");
                }
                rsMora.close();
                stMora.close();

                //sacamos los dias adicionales del cliente
                int diasAdicionalesCliente=0;
                String sqlDiasCliente="select c.cantidad_diascreditoespecial from clientes c " +
                        " where c.cod_estadoespecialcreditocliente = 1 and c.cod_cliente="+cod_cliente;
                Statement stDiasCliente=con.createStatement();
                ResultSet rsDiasCliente=stDiasCliente.executeQuery(sqlDiasCliente);
                if(rsDiasCliente.next()){
                    diasAdicionalesCliente=rsDiasCliente.getInt(1);
                }
                rsDiasCliente.close();
                stDiasCliente.close();


                DateTime dtActual=new DateTime();
                Days dias = Days.daysBetween(dt, dtActual);
                int diasMoraDocumento=dias.getDays();
                //FIN MOROSOS
                int diasVencido=30;

                diasMorosos=diasMorosos+diasAdicionalesCliente;
                int diasVigenciaDocumento=diasMorosos-diasMoraDocumento;


                //System.out.println("CODCLIENTE - DIASVIGENCIA -DIASMORADOCUMENTO ::: "+cod_cliente+" "+diasMorosos+" "+diasMoraDocumento);

                if(diasVigenciaDocumento<0){
                    obsDoc="Mora";
                    banderaMoroso=1;
                    double diasMoraCliente=Math.abs(diasVigenciaDocumento);
                    if(diasMoraCliente>60){
                        System.out.println("___CLIENTE_CAMBIADO_CONTADO:"+nombre_cliente+"\t"+cod_cliente);
                        String sqlUpdateCliente=" update clientes set COD_TIPOVENTA=1 where cod_cliente="+cod_cliente;
                        Statement stUpdatecliente=con.createStatement();
                        stUpdatecliente.executeUpdate(sqlUpdateCliente);

                        System.out.println("sqlUpdateCliente:"+sqlUpdateCliente);

                        if(diasMoraCliente>180){
                            sqlUpdateCliente=" update clientes set cod_estadocliente=4,COD_CATEGORIAVENTA=9 where cod_cliente="+cod_cliente;
                            stUpdatecliente.executeUpdate(sqlUpdateCliente);


                        }
                        stUpdatecliente.close();


                    }



                } else{
                    obsDoc="";
                    banderaMoroso=0;
                }

                saldo=monto_total-total_cobranza;
                if(saldo<1.0d)
                    saldo=0.0d;



                System.out.println(nro_factura+"\t"+fecha_salidaventa+"\t"+nombre_cliente+"\t"+form.format(monto_total)+"\t\t"+form.format(monto_cancelado)+"\t"+obsDoc+"\t"+diasVigenciaDocumento);




            }

            rs.close();
            st.close();



        }catch(SQLException e){
            e.printStackTrace();

        }


    }

    public void actionVerificar() {
        System.out.println("_______________________________");

        try{
            java.util.Date fechaActual= new java.util.Date();

            SimpleDateFormat dt= new SimpleDateFormat("yyyy/MM/dd");
            String fecha= dt.format(fechaActual)+" 00:00:00";
            String consulta="select td.cod_temporal,td.cod_cliente,td.dias_oficial from temporal_dias_cliente td where td.cod_estado='1' and td.fecha_vencimiento < '"+fecha+"'";
            //   System.out.println("consulta para verificar "+consulta);
            Statement st=conexion.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet result=st.executeQuery(consulta);
            if(result!=null) {
                while(result.next()) {
                    String updateCliente="UPDATE CLIENTES SET cantidad_diascreditoespecial = '"+result.getString("dias_oficial")+"'  WHERE  cod_cliente ='"+result.getString("cod_cliente")+"'";
                    String updateTabla="update temporal_dias_cliente set cod_estado=0 where cod_temporal='"+result.getString("cod_temporal")+"'";
                    // System.out.println("consulta para actualizar "+updateCliente);
                    PreparedStatement pst=conexion.prepareStatement(updateCliente);
                    if(pst.executeUpdate()>0) {
                        System.out.println("se actualizo la cantidad del cliente "+result.getString("cod_cliente"));
                    }
                    pst.close();
                    PreparedStatement pstTabla=conexion.prepareStatement(updateTabla);
                    if(pstTabla.executeUpdate()>0) {
                        System.out.println("se actualizo en la tabla");
                    }

                }
                result.close();
                st.close();
                //  conexion.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


}
