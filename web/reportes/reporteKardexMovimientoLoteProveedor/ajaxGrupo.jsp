package reportes.reporteKardexMovimiento;


<%@page contentType="text/xml"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>
<%
out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");

String codCapitulo=request.getParameter("codCapitulo");

String consulta =" SELECT GR.COD_GRUPO,GR.NOMBRE_GRUPO FROM GRUPOS GR WHERE GR.COD_CAPITULO IN ("+codCapitulo+") AND GR.COD_ESTADO_REGISTRO = 1 ";

System.out.println("consulta Grupos"+consulta);
Connection con=null;
con=Util.openConnection(con);
Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
ResultSet rs=st.executeQuery(consulta);
out.println("<select name='codGrupo'  class='inputText' style='width:200px' >");
out.println("<option value '0'>-NINGUNO-</option>");
while(rs.next()){
    out.println("<option value=\"'"+rs.getString("COD_GRUPO")+"'\">"+""+rs.getString("NOMBRE_GRUPO")+""+"</option>");
}
out.println("</select>");
%>
