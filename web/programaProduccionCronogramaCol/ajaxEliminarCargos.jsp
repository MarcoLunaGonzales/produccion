package PINKI;

<%@page contentType="text/xml"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>
<%
String codAreaEmpresa=request.getParameter("codAreaEmpresa")==null?"0":request.getParameter("codAreaEmpresa");
String codigosCargos = request.getParameter("codigosCargos")==null?"0":request.getParameter("codigosCargos");
String[] cod=codigosCargos.split(",");
String consulta="DELETE AGENCIA_VENTA_CARGOS WHERE COD_AREA_EMPRESA ="+codAreaEmpresa+" AND CODIGO_CARGO IN ("+codigosCargos+")";
System.out.println("consulta delete "+consulta);
Connection con=null;
con=Util.openConnection(con);
PreparedStatement pst=con.prepareStatement(consulta);
if(pst.executeUpdate()>0)System.out.println("se elimino");
consulta="select c.DESCRIPCION_CARGO,c.CODIGO_CARGO,avg.orden "+
                                    " from AGENCIA_VENTA_CARGOS avg inner join cargos c on c.CODIGO_CARGO=avg.CODIGO_CARGO" +
                                    " WHERE avg.COD_AREA_EMPRESA='"+codAreaEmpresa+"' order by avg.orden";
pst.close();
System.out.println(consulta);
Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
ResultSet rs=st.executeQuery(consulta);
out.println("<center> <table border='0' id='cargosRegional'  border='0' class='border' width='50%'>" +
            "<tr class='headerClassACliente'><td></td><td height='35px' >"+
            "<div class='outputText3'  align='center'>CARGOS COMERCIALES</div>"+
            "</td><td height='35px'  >"+
            "<div class='outputText3'  align='center'>ORDEN</div>"+
            "</td></tr>");
while(rs.next())
{
    out.println("<tr class='outputText2'>");
    out.println("<td><input type='checkbox'></td>");
    out.println("<td><input type='hidden' value='"+rs.getString("CODIGO_CARGO")+"'>"+rs.getString("DESCRIPCION_CARGO")+"</td>");
    out.println("<td>"+rs.getString("orden")+"</td>");
    out.println("</tr>");
}
out.println(" </table></center>");
rs.close();
st.close();
con.close();
%>
