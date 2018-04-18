<%@page contentType="text/xml"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.Enumeration" %>
<%@page import="java.util.Map" %>
<%@page import="java.util.Date" %>
<%@page import="java.net.URLDecoder" %>

<%

String codProgramaProd=request.getParameter("codProgramaProd");
String codFormulaMaestra=request.getParameter("codFormulaMaestra");
String codComprod=request.getParameter("codComprod");
String codLote=request.getParameter("codLote");
String codTipoProgramaProd=request.getParameter("codTipoProgramaProd");
String codActividad=request.getParameter("codActividad");
String codPersonal=request.getParameter("codPersonal");
String fecha=request.getParameter("fecha");
String horaInicio=request.getParameter("horaInicio");
Connection con=null;
String mensaje="";
try
{   
     con=Util.openConnection(con);
     
     SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");
     String consulta="select s.COD_LOTE_PRODUCCION,ap.NOMBRE_ACTIVIDAD from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL s " +
                     " inner join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_ACTIVIDAD_FORMULA=s.COD_ACTIVIDAD_PROGRAMA"+
                     " inner join ACTIVIDADES_PRODUCCION ap on ap.COD_ACTIVIDAD=afm.COD_ACTIVIDAD " +
                     " where s.COD_PERSONAL='"+codPersonal+"' and s.FECHA_INICIO>'"+sdf.format(new Date())+" 00:00'" +
                     " and (s.REGISTRO_CERRADO=0 or s.REGISTRO_CERRADO is null)";
     System.out.println("consulta verificar registro pendiente "+consulta);
     Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
     ResultSet res=st.executeQuery(consulta);
     if(res.next())
     {
            mensaje="No se puede iniciar la actividad, porque existe un registro abierto:<br>" +
                    "<b>Lote:</b>"+res.getString("COD_LOTE_PRODUCCION")+"<br>" +
                    "<b>Actividad:</b>"+res.getString("NOMBRE_ACTIVIDAD");
     }
     else
     {
         consulta="select ap.NOMBRE_ACTIVIDAD"+
                  " from SEGUIMIENTO_PROGRAMA_PRODUCCION_INDIRECTO_PERSONAL s inner join ACTIVIDADES_PRODUCCION ap"+
                  " on s.COD_ACTVIDAD=ap.COD_ACTIVIDAD"+
                  " where s.COD_PERSONAL='"+codPersonal+"' and s.FECHA_INICIO>'"+sdf.format(new Date())+" 00:00'" +
                  " and s.REGISTRO_CERRADO=0";
         System.out.println("consulta verificar registro pendiente indirecto "+consulta);
         res=st.executeQuery(consulta);
         if(res.next())
         {
             mensaje="No se puede iniciar la actividad, porque existe un registro abierto:<br>" +
                     "<b>Actividad Indirecta:</b>"+res.getString("NOMBRE_ACTIVIDAD");
         }
         else
         {
             con.setAutoCommit(false);
             String[] arrayFecha=fecha.split("/");
             fecha=arrayFecha[2]+"/"+arrayFecha[1]+"/"+arrayFecha[0];
             consulta="INSERT INTO SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL(COD_COMPPROD,"+
                              " COD_PROGRAMA_PROD, COD_LOTE_PRODUCCION, COD_FORMULA_MAESTRA,"+
                              " COD_ACTIVIDAD_PROGRAMA, COD_TIPO_PROGRAMA_PROD, COD_PERSONAL, HORAS_HOMBRE,"+
                              " UNIDADES_PRODUCIDAS, FECHA_REGISTRO, FECHA_INICIO, FECHA_FINAL"+
                              " ,REGISTRO_CERRADO, COD_FRACCION_OM)"+
                              " VALUES ('"+codComprod+"','"+codProgramaProd+"','"+codLote+"','"+codFormulaMaestra+"',"+
                              " '"+codActividad+"','"+codTipoProgramaProd+"','"+codPersonal+"',0,"+
                              " 0,'"+fecha+" "+horaInicio+"','"+fecha+" "+horaInicio+"','"+fecha+" "+horaInicio+"'"+
                              " ,0,0)";
             System.out.println("consulta insertar registro "+consulta);
             PreparedStatement pst=con.prepareStatement(consulta);
             if(pst.executeUpdate()>0)System.out.println("se inserto el registro directo ");
             con.commit();
             mensaje="1";
             pst.close();
         }
      }
     con.close();
}
catch(SQLException ex)
{
    mensaje="Ocurrio un error a la hora del registro intente de nuevo";
    ex.printStackTrace();
    con.rollback();
    con.close();
}
catch(Exception e)
{
    mensaje="Ocurrio un error a la hora del registro intente de nuevo";
    e.printStackTrace();
    con.rollback();
    con.close();

}
out.clear();

out.println(mensaje);


%>
