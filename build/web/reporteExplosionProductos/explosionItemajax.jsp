<%@page contentType="text/xml"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@ page import="com.cofar.util.*" %>
<%@page import="java.sql.*"%>
<%
out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
Connection con=null;
con =Util.openConnection(con);
String codigo=request.getParameter("codigo");
String cod_grupo=request.getParameter("cod_grupo");
//String sql_g=" select cod_grupo from grupos where cod_grupo="+codigo;
String sql=" select m.COD_MATERIAL,m.NOMBRE_MATERIAL from GRUPOS g,MATERIALES m";
sql+=" where g.COD_GRUPO=m.COD_GRUPO  and g.COD_CAPITULO="+codigo;
if(!cod_grupo.equals("0")){
    sql+=" and g.cod_grupo in ("+cod_grupo+")";
}
sql+=" order by m.NOMBRE_MATERIAL ";
System.out.println("sql2_item"+sql);

Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
ResultSet rs=st.executeQuery(sql);
out.println("<select id='cod_item'  name='cod_item' class=\"inputText2\"  multiple >");
while(rs.next()){
    out.println("<option value=\" "+rs.getString(1)+" \">"+rs.getString(2)+"</option>");
}
out.println("</select>");
out.println("<input type='checkbox' value='0' onclick='sel_todoItem(form1)' name='chk_Item'>Todo");
 
%>

