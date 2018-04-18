<%@page contentType="text/xml"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>
<%
out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
String codAreaEmpresa=request.getParameter("codAreaEmpresa");
codAreaEmpresa = codAreaEmpresa.equals("")?"0":codAreaEmpresa;


String consulta = " SELECT CP.COD_COMPPROD,CP.nombre_prod_semiterminado FROM COMPONENTES_PROD CP WHERE CP.COD_AREA_EMPRESA IN ("+codAreaEmpresa+") order by CP.nombre_prod_semiterminado asc";

System.out.println("consulta Productos"+consulta);
Connection con=null;
con=Util.openConnection(con);
Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
ResultSet rs=st.executeQuery(consulta);
out.println("<select name='codCompProd' size='15' class='inputText' multiple onchange='form1.chk_todoTipo.checked=false'>");
while(rs.next()){
    out.println("<option value=\"'"+rs.getString("COD_COMPPROD")+"'\">"+rs.getString("nombre_prod_semiterminado")+"</option>");
}
out.println("</select>");
out.println("<input type='checkbox'  onclick='selecccionarTodo(form1)' name='chk_todoTipo' >Todo");
%>
