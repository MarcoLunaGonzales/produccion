

<%@page contentType="text/xml"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>
<%

String nombreProducto=request.getParameter("nombreProducto");
StringBuilder consulta=new StringBuilder("select c.nombre_prod_semiterminado,c.COD_VERSION");
			consulta.append(" from COMPONENTES_PROD_VERSION c");
			consulta.append(" where c.COD_ESTADO_VERSION=2");
					consulta.append(" and c.COD_TIPO_PRODUCCION=1");
				    	consulta.append(" and c.COD_ESTADO_COMPPROD=1");
                                        consulta.append(" and c.nombre_prod_semiterminado like '%").append(nombreProducto).append("%'");
			consulta.append(" order by c.nombre_prod_semiterminado");
System.out.println("consulta buscar producto "+consulta.toString());
Connection con=null;
con=Util.openConnection(con);
Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
ResultSet res=st.executeQuery(consulta.toString());
out.println("<table id='dataLote' class='tablaReporte' cellpadding='0' cellspacing='0' style='width:80%' > ");
out.println("<thead><tr>");
out.println("<td align='center' class='outputTextBold'>Nombre Producto</td>"+
        " <td bgcolor='#f2f2f2'  align='center' class='outputTextBold'><b>Ver Registro<br>Sanitario</b></td>"+
        " </tr></thead><tbody>");
while(res.next())
{
    out.println("<tr>");
        out.println("<td class='outputText2'>"+res.getString("nombre_prod_semiterminado")+"</td>");
        if(res.getInt("COD_VERSION")>0)
            out.println("<td><a href='#' onclick=\"openPopup1('getRegistroSanitario.jsf?codVersion="+res.getInt("COD_VERSION")+"')\"><img src='../../img/pdf.jpg'/></a></td>");
        else
            out.println("<td>&nbsp;</td>");
    out.println("<tr>");
}
out.println("</tbody></table>");
%>