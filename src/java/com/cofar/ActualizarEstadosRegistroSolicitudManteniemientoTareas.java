/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 *
 * @author DASISAQ-
 */
public class ActualizarEstadosRegistroSolicitudManteniemientoTareas {

    public static void main(String[] args) {

        try {
             Connection con=null;
             Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
             String url="jdbc:sqlserver://172.16.10.21;user=sa;password=m0t1t4s@2009;databaseName=SARTORIUS";
             con=DriverManager.getConnection(url);
             con.setAutoCommit(false);
             StringBuilder consulta=new StringBuilder("select s.COD_SOLICITUD_MANTENIMIENTO from SOLICITUDES_MANTENIMIENTO s where s.COD_ESTADO_SOLICITUD_MANTENIMIENTO=4");
             Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
             ResultSet res=st.executeQuery(consulta.toString());
             while(res.next())
             {
                 consulta=new StringBuilder("UPDATE SOLICITUDES_MANTENIMIENTO_DETALLE_TAREAS");
                         consulta.append(" set TERMINADO=1");
                         consulta.append(" WHERE COD_SOLICITUD_MANTENIMIENTO=").append(res.getInt("COD_SOLICITUD_MANTENIMIENTO"));
                            consulta.append(" and COD_PERSONAL=? and COD_TIPO_TAREA=? and FECHA_INICIAL=?");
                System.out.println("consulta terminar actividades"+consulta.toString());
                PreparedStatement pst=con.prepareStatement(consulta.toString());
                consulta=new StringBuilder("select smdt.COD_PERSONAL,smdt.COD_TIPO_TAREA,max(smdt.FECHA_INICIAL) as fechaInicial");
                         consulta.append(" from SOLICITUDES_MANTENIMIENTO_DETALLE_TAREAS smdt ");
                         consulta.append(" where smdt.COD_SOLICITUD_MANTENIMIENTO=").append(res.getInt("COD_SOLICITUD_MANTENIMIENTO"));
                         consulta.append(" group by smdt.COD_PERSONAL,smdt.COD_TIPO_TAREA");
                System.out.println("consulta buscar ultimos registro de tareas");
                Statement std=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet resd=std.executeQuery(consulta.toString());
                while(resd.next())
                {
                    pst.setInt(1,resd.getInt("COD_PERSONAL"));
                    pst.setInt(2,resd.getInt("COD_TIPO_TAREA"));
                    pst.setTimestamp(3,resd.getTimestamp("fechaInicial"));
                    if(pst.executeUpdate()>0)System.out.println("termino la actividad");
                }
             }
             con.commit();
        }
        catch(Exception ex)
        {
            ex.printStackTrace();
        }

    }
}
