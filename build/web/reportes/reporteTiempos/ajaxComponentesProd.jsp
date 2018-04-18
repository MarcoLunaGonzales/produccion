

<%@page contentType="text/xml"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>
<%
out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
String codAreaEmpresa=request.getParameter("codAreaEmpresa");
String consulta = " select c.COD_COMPPROD,c.nombre_prod_semiterminado"+
                  " from COMPONENTES_PROD c where c.COD_AREA_EMPRESA in ("+codAreaEmpresa+") and c.COD_TIPO_PRODUCCION in(1,3)"+
                  " order by c.nombre_prod_semiterminado";
System.out.println("consulta productos "+consulta);
Connection con=null;
con=Util.openConnection(con);
Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
ResultSet res=st.executeQuery(consulta);
out.println("<select name='codProducto' size='5' class='inputText' multiple onchange='form1.chk_todoTipo.checked=false'>");
while(res.next()){
     out.println("<option value=\"'"+res.getString("COD_COMPPROD")+"'\">"+res.getString("nombre_prod_semiterminado")+"</option>");
    //out.println("<option value="+rs.getString("COD_LOTE_PRODUCCION")+"/"+rs.getString("COD_COMPPROD")+"/"+rs.getString("COD_TIPO_PROGRAMA_PROD")+">"+"("+rs.getString("COD_LOTE_PRODUCCION")+") "+rs.getString("nombre_prod_semiterminado")+"("+rs.getString("NOMBRE_TIPO_PROGRAMA_PROD")+")"+"</option>");
}
out.println("</select>");
out.println("<input type='checkbox'  onclick='seleccionarTodosproducto(form1)' name='checkTodosComponentesProd' >Todo");
%>
