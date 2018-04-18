<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>
<%
response.setContentType("text/html");
String codAreaEmpresa=request.getParameter("codAreaEmpresaArray");

String consulta = " select a.COD_AREA_INSTALACION,a.NOMBRE_AREA_INSTALACION+'('+ae.NOMBRE_AREA_EMPRESA+')' as nombreInst from AREAS_INSTALACIONES a inner join AREAS_EMPRESA ae on a.COD_AREA_EMPRESA=ae.COD_AREA_EMPRESA where a.COD_AREA_EMPRESA in("+codAreaEmpresa+") order by a.NOMBRE_AREA_INSTALACION";

System.out.println("consulta Maquinarias"+consulta);
Connection con=null;
con=Util.openConnection(con);
Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
ResultSet rs=st.executeQuery(consulta);
out.println("<select size='15' id='codInstalacion' class='inputText' multiple onchange='form1.chk_todoInstalacion.checked=false'>");
while(rs.next()){
     out.println("<option value="+rs.getString("COD_AREA_INSTALACION")+">"+rs.getString("nombreInst")+"</option>");
    //out.println("<option value="+rs.getString("COD_LOTE_PRODUCCION")+"/"+rs.getString("COD_COMPPROD")+"/"+rs.getString("COD_TIPO_PROGRAMA_PROD")+">"+"("+rs.getString("COD_LOTE_PRODUCCION")+") "+rs.getString("nombre_prod_semiterminado")+"("+rs.getString("NOMBRE_TIPO_PROGRAMA_PROD")+")"+"</option>");
}
out.println("</select>");
out.println("<input type='checkbox'  onclick='selecccionarTodoInstalacion(form1)' name='chk_todoInstalacion' >Todo");
con.close();
%>
