package evaluaProveedores;

package calculoPremiosBimensuales_1;

package calculoTipoIncentivoRegionalesOtros_1;

package calculoTipoIncentivoRegionales_1;

package reportePresupuestos1;

<%@page contentType="text/xml"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>
<%
out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
String codGestion=request.getParameter("codGestion");
String sql="select cod_periodo,obs from PERIODOS_VENTAS where cod_gestion="+codGestion;
System.out.println("sqlPeriodo"+sql);
Connection con=null;
con=Util.openConnection(con);
Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
ResultSet rs=st.executeQuery(sql);
out.println("<select id='codPeriodoGestion' name='codPeriodoGestion' class=\"inputText3\" >");
while(rs.next()){
    out.println("<option value="+rs.getString(1)+" >"+rs.getString(2)+"</option>");
}
out.println("</select>");
%>
