<%@page contentType="text/xml"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>
<%
out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
String codGrupo=request.getParameter("codGrupo");
String sql="  ";
System.out.println("sqlDistrito:"+sql);
Connection con=null;
con=Util.openConnection(con);
Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
ResultSet rs=st.executeQuery(sql);
out.println("<select id='codSubGrupo' name='codSubGrupo'  class=\"outputText3\">");
out.println("<option value='0'>-- Todos --</option>");
while(rs.next()){
    out.println("<option value=\" "+rs.getString(1)+" \">"+rs.getString(2)+"</option>");
}
out.println("</select>");
%>