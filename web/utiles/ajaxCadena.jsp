<%@page contentType="text/xml"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>
<%
out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
String codAreaEmpresa=request.getParameter("codAreaEmpresa");
String sql="select ca.COD_CADENACLIENTE,(select cc.NOMBRE_CADENACLIENTE from CADENAS_CLIENTE cc where cc.COD_CADENACLIENTE = ca.COD_CADENACLIENTE) as nombreCadenaCliente";
sql+=" from CADENAS_AGENCIA ca where ca.COD_ESTADO_REGISTRO = 1 and ca.cod_area_empresa = "+codAreaEmpresa;
System.out.println("sqlCliente"+sql);
Connection con=null;
con=Util.openConnection(con);
Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
ResultSet rs=st.executeQuery(sql);
out.println("<select id='codcadena' name='codcadena' class=\"inputText3\" onchange='validarCadena(this,this.form);'>");
out.println("<option value='0'>Seleccione una Opción</option>");
while(rs.next()){
    out.println("<option value=\" "+rs.getString(1)+" \">"+rs.getString(2)+"</option>");
}
out.println("</select>");
%>
