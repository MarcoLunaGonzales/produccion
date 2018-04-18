package reportes.reporteEvaluacionStocks;

<%@page contentType="text/xml"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@ page import="com.cofar.util.*" %>
<%
out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
String codCapitulo=request.getParameter("codCapitulo");

String sql=" select g.COD_GRUPO,g.NOMBRE_GRUPO from GRUPOS  g " ;
sql+=" where g.COD_CAPITULO="+codCapitulo;
sql+=" order by g.NOMBRE_GRUPO ";
System.out.println("sql:"+sql);
Connection con=null;
con =Util.openConnection(con);
Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
ResultSet rs=st.executeQuery(sql);
out.println("<select id='codGrupo' name='codGrupo' class=\"inputText2\">");

while(rs.next()){
    out.println("<option value=\" "+rs.getString(1)+" \">"+rs.getString(2)+"</option>");
}
out.println("</select>");

%>
