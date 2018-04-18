package evaluaProveedores;

<%@page contentType="text/xml"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>
<%
//out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
System.out.println("entro");
String codPeriodoEvaluacion=request.getParameter("codPeriodoEvaluacion");
String consulta = "  ";

//System.out.println("consulta Programa Produccion"+codMaterial);
Connection con=null;
con=Util.openConnection(con);
Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
consulta = " delete from EVALUACION_PROVEEDORES_MATERIAL where cod_periodo_evaluacion = '"+codPeriodoEvaluacion+"' ";
System.out.println("consulta " + consulta);
st.executeUpdate(consulta);
//ResultSet rs=st.executeQuery(consulta);
//out.println("<select name='codAreaEmpresa' size='15' class='inputText' multiple onchange='ajaxProductos(form1);form1.chk_todoArea.checked=false;'>");
//while(rs.next()){
    //out.println("<option value=\" "+rs.getString("COD_AREA_EMPRESA")+" \">"+rs.getString("NOMBRE_AREA_EMPRESA")+"</option>");
//}
//out.println("</select>");
//out.println("<input type='checkbox'  onclick='selecccionarTodoArea(form1)' name='chk_todoArea' >Todo");
%>
