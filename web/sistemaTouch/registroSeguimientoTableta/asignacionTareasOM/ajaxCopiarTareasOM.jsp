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
Connection con=null;
try
{
     con=Util.openConnection(con);
     Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
     String consulta="select t.COD_TAREA_OM,t.COD_PERSONAL from TAREAS_OM_PERSONAL_LOTE t " +
                    " INNER JOIN TAREAS_OM t1 on t1.COD_TAREA_OM=t.COD_TAREA_OM where" +
                    " t.COD_LOTE='"+codLote+"' and t.COD_PROGRAMA_PROD='"+codProgramaProd+"'"+
                     " order by t.COD_TAREA_OM,t.COD_PERSONAL";
     System.out.println("consulta tareas a copiar "+consulta);
     ResultSet res=st.executeQuery(consulta);
     out.clear();
     while(res.next())
     {
         out.println("tarea"+res.getInt("COD_TAREA_OM")+".asociarPersonalScript("+res.getInt("COD_PERSONAL")+");");
     }
     res.close();
     st.close();
     con.close();
}
catch(SQLException ex)
{
    ex.printStackTrace();
    con.rollback();
}
catch(Exception ex)
{
    ex.printStackTrace();
    con.rollback();
}




%>
