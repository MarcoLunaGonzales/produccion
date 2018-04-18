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
String[] codPersonalAsignar=request.getParameter("codPersonalAsignar").split(",");
String[] fechaPermiso=request.getParameter("fechaPermiso").split("/");
String codActividad=request.getParameter("codActividad");
Connection con=null;
String mensaje="";
try
{   
     con=Util.openConnection(con);
     
     con.setAutoCommit(false);
     String consulta="";
     String fecha=fechaPermiso[2]+"/"+fechaPermiso[1]+"/"+fechaPermiso[0];
     SimpleDateFormat sdf= new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
     consulta="delete from TAREAS_INDIRECTAS_DIA  where "+
              "COD_ACTIVIDAD ='"+codActividad+"' and FECHA_TAREA BETWEEN '"+fecha+" 00:00' and '"+fecha+" 23:59'"+
              " and COD_ACTIVIDAD = '"+codActividad+"'";
     System.out.println("consulta delete eliminar anterior seguimiento"+consulta);
     PreparedStatement pst=con.prepareStatement(consulta);
     if(pst.executeUpdate()>0)System.out.println("se eliminaron las tareass ");
     for(int i=0;i<codPersonalAsignar.length;i++)
     {
        consulta="INSERT INTO TAREAS_INDIRECTAS_DIA(COD_PERSONAL, COD_ACTIVIDAD, FECHA_TAREA)"+
                 " VALUES ('"+codPersonalAsignar[i]+"','"+codActividad+"','"+fecha+" 12:00')";
        System.out.println("consulta insert "+consulta);
        pst=con.prepareStatement(consulta);
        if(pst.executeUpdate()>0)System.out.println("se registro la tarea para el personal");
     }
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
