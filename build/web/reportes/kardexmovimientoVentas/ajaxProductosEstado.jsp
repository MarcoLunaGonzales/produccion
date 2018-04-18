<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>
<%//out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
String codigo=request.getParameter("codEstadoProducto");
if(!codigo.equals("")){
System.out.println("COD ESTADO PRODUCTO: "+codigo);
String sql="select cod_presentacion,nombre_producto_presentacion from PRESENTACIONES_PRODUCTO where cod_estado_registro in ("+codigo+")";
sql+=" order by nombre_producto_presentacion asc";
System.out.println("sql:lineaMKT:"+sql);
Connection con=null;
con=Util.openConnection(con);
Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
ResultSet rs=st.executeQuery(sql);
out.println("<select id='codPresentacion' name='codPresentacion' class=\"inputText3\" multiple style='height:150px'>");
while(rs.next()){
out.println("<option value=\" "+rs.getString(1)+" \">"+rs.getString(2)+"</option>");
}
out.println("</select>");
}else{
out.println("<select id='codproducto' name='codproducto' class=\"inputText3\" >");    
out.println("<option value='0'></option>");
out.println("</select>");
}
%>
