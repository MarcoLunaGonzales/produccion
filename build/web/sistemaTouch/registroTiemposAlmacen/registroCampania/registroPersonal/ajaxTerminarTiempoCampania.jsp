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
String codCampania=request.getParameter("codCampania");
String codActividad=request.getParameter("codActividad");
String codPersonal=request.getParameter("codPersonal");
String fecha=request.getParameter("fecha");
String horaFin=request.getParameter("horaFin");
String horasHombre=request.getParameter("horasHombre");
Connection con=null;
String mensaje="";
try
{   
     con=Util.openConnection(con);
     con.setAutoCommit(false);
     String[] arrayFecha=fecha.split("/");
     fecha=arrayFecha[2]+"/"+arrayFecha[1]+"/"+arrayFecha[0];
     String consulta="update SEGUIMIENTO_CAMPANIA_PROGRAMA_PRODUCCION_PERSONAL "+
                     " set HORAS_HOMBRE='"+horasHombre+"'"+
                     " ,FECHA_FINAL='"+fecha+" "+horaFin+"'"+
                     " ,REGISTRO_CERRADO=1"+
                     " where COD_CAMPANIA_PROGRAMA_PRODUCCION='"+codCampania+"'"+
                     " and COD_ACTIVIDAD_PROGRAMA='"+codActividad+"'"+
                     " and FECHA_INICIO>'"+fecha+" 00:00'";
     System.out.println("consulta registrar termino "+consulta);
     PreparedStatement pst=con.prepareStatement(consulta);
     if(pst.executeUpdate()>0)System.out.println("se registro el inicio");
     CallableStatement cstVencimiento= con.prepareCall("{call dbo.prorateoTiempoCampaniaProgramaProduccion_ps(?,?,?,?,?)}");
     cstVencimiento.setInt(1,Integer.valueOf(codCampania));
     cstVencimiento.setString(2,fecha+" "+horaFin);
     cstVencimiento.setDouble(3,Double.valueOf(horasHombre));
     cstVencimiento.setString(4, codActividad);
     cstVencimiento.setString(5,codPersonal);
     cstVencimiento.execute();
     con.commit();
     mensaje="1";
     pst.close();
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
