<%@page contentType="text/xml"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>
<%
out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
String codAreaEmpresa=request.getParameter("codAreaEmpresa");
String codTipoCliente=request.getParameter("codTipoCliente");
String sql="select ra.COD_REDCLIENTE,(select rc.NOMBRE_REDCLIENTE from REDES_CLIENTE rc where rc.COD_REDCLIENTE = ra.COD_REDCLIENTE) as nombreRedCliente";
sql+=" from REDES_AGENCIA ra,CLIENTES CL where ra.COD_ESTADO_REGISTRO = 1 AND ra.COD_AREA_EMPRESA = "+codAreaEmpresa;
sql+=" cl.cod_redcliente = ra.COD_REDCLIENTE cl.cod_tipocliente in ("+codTipoCliente+") group by ra.COD_REDCLIENTE";
System.out.println("sqlRed:::::::::::::::::::::::::::::::::."+sql);
Connection con=null;
con=Util.openConnection(con);
Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
ResultSet rs=st.executeQuery(sql);
out.println("<select id='codred' name='codred' class=\"inputText3\" onchange='validarRed(this);'>");
out.println("<option value='0'>Seleccione una Opción</option>");
while(rs.next()){
    out.println("<option value=\" "+rs.getString(1)+" \">"+rs.getString(2)+"</option>");
}
out.println("</select>");
%>
