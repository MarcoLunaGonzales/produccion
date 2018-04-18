package reportes.reportePersonalSolicitudMantenimiento;



<%@page contentType="text/xml"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>
<%
out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
String codAreaEmpresaArray=request.getParameter("codAreaEmpresaArray");



String consulta = " select m.COD_MAQUINA,m.NOMBRE_MAQUINA from maquinarias m where m.COD_AREA_EMPRESA  in ("+codAreaEmpresaArray+") order by m.NOMBRE_MAQUINA";

System.out.println("consulta Maquinarias"+consulta);
Connection con=null;
con=Util.openConnection(con);
Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
ResultSet rs=st.executeQuery(consulta);
out.println("<select name='codMaquinaria' size='15' class='inputText' multiple onchange='form1.chk_todoMaquinaria.checked=false'>");
while(rs.next()){
     out.println("<option value="+rs.getString("COD_MAQUINA")+">"+rs.getString("NOMBRE_MAQUINA")+"</option>");
    //out.println("<option value="+rs.getString("COD_LOTE_PRODUCCION")+"/"+rs.getString("COD_COMPPROD")+"/"+rs.getString("COD_TIPO_PROGRAMA_PROD")+">"+"("+rs.getString("COD_LOTE_PRODUCCION")+") "+rs.getString("nombre_prod_semiterminado")+"("+rs.getString("NOMBRE_TIPO_PROGRAMA_PROD")+")"+"</option>");
}
out.println("</select>");
out.println("<input type='checkbox'  onclick='selecccionarTodoMaquina(form1)' name='chk_todoMaquinaria' >Todo");
con.close();
%>
