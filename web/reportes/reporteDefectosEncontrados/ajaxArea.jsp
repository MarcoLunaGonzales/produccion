<%@page contentType="text/xml"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>
<%
//out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
String codProgramaProduccion=request.getParameter("codProgramaProduccion");
System.out.println("codPrograma" +codProgramaProduccion);
String consulta = "SELECT AE.COD_AREA_EMPRESA,AE.NOMBRE_AREA_EMPRESA FROM AREAS_EMPRESA AE WHERE AE.COD_AREA_EMPRESA IN " +
                    "(SELECT CP.COD_AREA_EMPRESA FROM COMPONENTES_PROD CP INNER JOIN PROGRAMA_PRODUCCION PPR ON PPR.COD_COMPPROD=CP.COD_COMPPROD" +
                    " WHERE PPR.COD_PROGRAMA_PROD in ("+codProgramaProduccion+"))";

System.out.println("consulta Programa Produccion"+consulta);
Connection con=null;
con=Util.openConnection(con);
Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
ResultSet rs=st.executeQuery(consulta);
out.println("<select name='codAreaEmpresa' size='15' class='inputText' multiple onchange='ajaxProductos(form1);form1.chk_todoArea.checked=false;'>");
while(rs.next()){
    out.println("<option value=\" "+rs.getString("COD_AREA_EMPRESA")+" \">"+rs.getString("NOMBRE_AREA_EMPRESA")+"</option>");
}
out.println("</select>");
out.println("<input type='checkbox'  onclick='selecccionarTodoArea(form1)' name='chk_todoArea' >Todo");
%>
