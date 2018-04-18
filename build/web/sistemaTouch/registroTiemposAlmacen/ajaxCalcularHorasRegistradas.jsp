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
<%@ page import = "java.text.DecimalFormat"%>
<%@ page import = "java.text.NumberFormat"%>
<%@ page language="java" import="java.util.*" %>
<%
String codPersonal=request.getParameter("codPersonal");
Connection con=null;
String mensaje="<b>Horas Trabajadas:</b><br>0.0";
try
{   
     con=Util.openConnection(con);
     con.setAutoCommit(false);
     NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
     DecimalFormat format = (DecimalFormat)nf;
     format.applyPattern("#,##0.00");
     SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");
     String consulta="select sum(s.HORAS_HOMBRE) as horasHombre from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL s" +
                     " where s.COD_PERSONAL='"+codPersonal+"'"+
                     " and s.FECHA_INICIO BETWEEN '"+sdf.format(new Date())+" 00:00' and '"+sdf.format(new Date())+" 23:59'";
     System.out.println("consulta HORAS TRABAJADAS "+consulta);
     double horasDirectas=0;
     Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
     ResultSet res=st.executeQuery(consulta);
     if(res.next())horasDirectas=res.getDouble("horasHombre");
     consulta="select sum(s.HORAS_HOMBRE) as horasHombre"+
             " from SEGUIMIENTO_PROGRAMA_PRODUCCION_INDIRECTO_PERSONAL s where s.COD_PERSONAL='"+codPersonal+"'"+
             " and s.FECHA_INICIO between '"+sdf.format(new Date())+" 00:00' and '"+sdf.format(new Date())+" 23:59'";
     res=st.executeQuery(consulta);
     if(res.next())mensaje="<b>Horas Trabajadas:</b><br>"+(format.format(res.getDouble("horasHombre")+horasDirectas));
     con.commit();
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
