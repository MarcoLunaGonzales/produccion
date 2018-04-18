package reportes.reporteKardexMovimiento;


<%@page contentType="text/xml"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>
<%
//out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");


String codFilial = request.getParameter("codFilial");
String consulta = " select cod_almacen, nombre_almacen from almacenes where cod_estado_registro=1 and cod_filial='"+codFilial+"' ";

System.out.println("consulta Filial "+consulta);
Connection con=null;
con=Util.openConnection(con);
Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
ResultSet rs=st.executeQuery(consulta);
out.println("<select name='codAlmacen'  class='inputText' >");
out.println("<option value='0'>-TODOS-</option>");
while(rs.next()){    
    out.println("<option value=\" "+rs.getString("cod_almacen")+" \">"+rs.getString("nombre_almacen")+"</option>");
}
out.println("</select>");
%>
