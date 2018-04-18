<%@page contentType="text/xml"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@ page import="com.cofar.util.*" %>
<%
out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
String codigo=request.getParameter("codigo");

String sql=" select g.COD_GRUPO,g.NOMBRE_GRUPO from GRUPOS  g " ;
sql+=" where g.COD_CAPITULO="+codigo;
sql+=" order by g.NOMBRE_GRUPO ";
System.out.println("sql:"+sql);
Connection con=null;
con =Util.openConnection(con);
Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
ResultSet rs=st.executeQuery(sql);
out.println("<select id='cod_grupo'  name='cod_grupo' class=\"inputText2\" onchange='Item(this.value,this.form);' multiple >");

while(rs.next()){
    out.println("<option value=\" "+rs.getString(1)+" \">"+rs.getString(2)+"</option>");
}
out.println("</select>");

%>
