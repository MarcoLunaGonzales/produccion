<%@page contentType="text/xml"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.Enumeration" %>
<%@page import="java.util.Map" %>
<%@page import="java.util.Date" %>
<%
String codLote=request.getParameter("codLote");
String codProgramaProd=request.getParameter("codProgramaProd");
String[] arrayPersonal=request.getParameter("personalAsignar").split(",");
Connection con=null;
String mensaje="";
try
{
     con=Util.openConnection(con);
     Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
     PreparedStatement pst=null;
     con.setAutoCommit(false);
     String consulta="delete TAREAS_OM_PERSONAL_LOTE  where cod_lote='"+codLote+"' and COD_PROGRAMA_PROD='"+codProgramaProd+"'";
     System.out.println("consulta eliminar registro anterior "+consulta);
     pst=con.prepareStatement(consulta);
     if(pst.executeUpdate()>0)System.out.println("se eliminaron anteriores tareas asignadas");
     for(int i=0;(i<arrayPersonal.length&&arrayPersonal.length>1);i+=2)
     {
         consulta="INSERT INTO TAREAS_OM_PERSONAL_LOTE(COD_LOTE, COD_PROGRAMA_PROD, COD_TAREA_OM,COD_PERSONAL)"+
                  " VALUES ('"+codLote+"','"+codProgramaProd+"','"+arrayPersonal[i]+"','"+arrayPersonal[i+1]+"')";
         System.out.println("consulta insert "+consulta);
         pst=con.prepareStatement(consulta);
         if(pst.executeUpdate()>0)System.out.println("se registro la tarea para el personal");
     }
     con.commit();
     mensaje="1";
     if(pst!=null)pst.close();
     con.close();
}
catch(SQLException ex)
{
    mensaje="Ocurrio un error a la hora del registro intente de nuevo";
    ex.printStackTrace();
    con.rollback();
}
catch(Exception ex)
{
    mensaje="Ocurrio un error de informacion al momento de registrar la informacion, comunicar sistemas";
    ex.printStackTrace();
    con.rollback();
}


out.clear();

out.println(mensaje);


%>
