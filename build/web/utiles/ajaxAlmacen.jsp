<%@page contentType="text/xml"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>
<%
out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
String codAreaEmpresa=request.getParameter("codAreaEmpresa");
String sql="select cod_almacen_venta,nombre_almacen_venta from ALMACENES_VENTAS where cod_area_empresa="+codAreaEmpresa;
sql+=" order by nombre_almacen_venta asc";
System.out.println("sqlClienteAlmacen..............."+sql);
Connection con=null;
con=Util.openConnection(con);
Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
ResultSet rs=st.executeQuery(sql);
out.println("<select id='codalmacenventa' name='codalmacenventa' class=\"inputText3\" multiple>");
while(rs.next()){
    out.println("<option value=\" "+rs.getString(1)+" \">"+rs.getString(2)+"</option>");
}
out.println("</select>");
out.println("<input type='checkbox' value='0' onclick='sel_todoAlmacen(form1)' name='chk_todoAlmacen'>Todo");
%>
