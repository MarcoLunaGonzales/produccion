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
String[] dataTiempos=request.getParameter("dataTiempos").split(",");
Connection con=null;
String mensaje="";
try
{   
     con=Util.openConnection(con);
     con.setAutoCommit(false);
     String consulta="delete FROM SEGUIMIENTO_CAMPANIA_PROGRAMA_PRODUCCION_PERSONAL  where" +
                    " COD_CAMPANIA_PROGRAMA_PRODUCCION='"+codCampania+"'"+
                    " AND COD_ACTIVIDAD_PROGRAMA='"+codActividad+"'";
     System.out.println("consulta delete seguimiento programa produccion"+consulta);
     PreparedStatement pst=con.prepareStatement(consulta);
     if(pst.executeUpdate()>0)System.out.println("se eliminaron anteriores registros");
     for(int i=0;(i<dataTiempos.length&&dataTiempos.length>2);i+=6)
     {
         String[] fechaArray=dataTiempos[i+1].split("/");
         String fecha=fechaArray[2]+"/"+fechaArray[1]+"/"+fechaArray[0];
         consulta="INSERT INTO SEGUIMIENTO_CAMPANIA_PROGRAMA_PRODUCCION_PERSONAL("+
                  " COD_CAMPANIA_PROGRAMA_PRODUCCION, COD_ACTIVIDAD_PROGRAMA, COD_PERSONAL,"+
                  " HORAS_HOMBRE, FECHA_INICIO, FECHA_FINAL, REGISTRO_CERRADO)"+
                  " VALUES ('"+codCampania+"','"+codActividad+"',"+
                  "'"+dataTiempos[i]+"','"+dataTiempos[i+4]+"'," +
                  " '"+fecha+" "+dataTiempos[i+2]+"','"+fecha+" "+dataTiempos[i+3]+"','"+dataTiempos[i+5]+"')";
         System.out.println("consulta insertar registro "+consulta);
         pst=con.prepareStatement(consulta);
         if(pst.executeUpdate()>0)System.out.println("se registro el tiempo de personal");
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
