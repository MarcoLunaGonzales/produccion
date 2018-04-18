<%@page contentType="text/xml"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>

<%
out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
String codigo=request.getParameter("codigo");
String sw=request.getParameter("sw");
String sql="";
if(sw.equals("1")){
    sql="select cod_cliente,nombre_cliente from clientes where cod_cliente<>0 and cod_area_empresa="+codigo;
}else if(sw.equals("2")){
    sql="select cod_cliente,nombre_cliente from clientes where cod_cliente<>0 and cod_cadenacliente="+codigo;
}
sql+=" and cod_estadocliente<>4 order by nombre_cliente asc";
System.out.println("sqlCliente"+sql);
System.out.println("codigo.....................:"+codigo);
Connection con=null;
con=Util.openConnection(con);
Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
ResultSet rs=st.executeQuery(sql);
out.println("<select id='codcliente' name='codcliente' size=\"10\" class=\"inputText3\" onchange='desabilitarCliente(form1);desabilitarCliente(form1);' multiple >");
while(rs.next()){
    out.println("<option value=\" "+rs.getString(1)+" \">"+rs.getString(2)+"</option>");
}
out.println("</select>");
out.println("<input type='checkbox' value='0' onclick='sel_todoCliente(form1)' name='chk_todoCliente'>Todo");
%>
