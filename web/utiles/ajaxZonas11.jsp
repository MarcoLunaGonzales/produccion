<%@page contentType="text/xml"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>
<%
out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
String coddistrito=request.getParameter("coddistrito");
System.out.println("coddistrito:"+coddistrito);
if(coddistrito.equals("")){
    coddistrito="0";
}
String sql="select cod_zona,nombre_zona from zonas where cod_estado_registro=1 and cod_distrito in("+coddistrito+")";
System.out.println("sqlZonas:"+sql);
Connection con=null;
con=Util.openConnection(con);
//Connection con =CofarConnection.getConnectionJsp();
Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
ResultSet rs=st.executeQuery(sql);
out.println("<select id='codzona' size='3' onchange='desabilitarZonas(form1);' name='codzona' class=\"outputText3\" multiple>");
while(rs.next()){
    out.println("<option value=\" "+rs.getString(1)+" \">"+rs.getString(2)+"</option>");
}
out.println("</select>");
out.println("<input type='checkbox' value='0' onclick='sel_todoZona(form1)' name='chk_todoZona'>Todo");
%>