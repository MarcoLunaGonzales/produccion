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
System.out.println("entroe");
String codCampania=request.getParameter("codCampania");
String codActividad=request.getParameter("codActividad");
String codPersonal=request.getParameter("codPersonal");
String fecha=request.getParameter("fecha");
String horaInicio=request.getParameter("horaInicio");
Connection con=null;
String mensaje="";
try
{   
     con=Util.openConnection(con);
     con.setAutoCommit(false);
     String[] arrayFecha=fecha.split("/");
     fecha=arrayFecha[2]+"/"+arrayFecha[1]+"/"+arrayFecha[0];
     String consulta="INSERT INTO SEGUIMIENTO_CAMPANIA_PROGRAMA_PRODUCCION_PERSONAL("+
                     " COD_CAMPANIA_PROGRAMA_PRODUCCION, COD_ACTIVIDAD_PROGRAMA, COD_PERSONAL,"+
                     " HORAS_HOMBRE, FECHA_INICIO, FECHA_FINAL, REGISTRO_CERRADO)"+
                     " VALUES ('"+codCampania+"','"+codActividad+"',"+
                     "'"+codPersonal+"','0', '"+fecha+" "+horaInicio+"','"+fecha+" "+horaInicio+"',0);";
     System.out.println("consulta insertar registro "+consulta);
     PreparedStatement pst=con.prepareStatement(consulta);
     if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento progrma ind ");
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
