<%@page contentType="text/xml"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>
<%
//out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");

//System.out.println("inicio el ajax");
String codProgramaProd = (request.getParameter("codProgramaProd")==null)||request.getParameter("codProgramaProd")==""?"0":request.getParameter("codProgramaProd");
String consulta = " select (CAST(pp.COD_PROGRAMA_PROD as varchar)+' '+CAST(pp.COD_COMPPROD as varchar)+' '+CAST(pp.COD_FORMULA_MAESTRA as varchar)"+
                  " +' '+CAST(pp.COD_TIPO_PROGRAMA_PROD AS VARCHAR)) AS CODIGOS,pp.COD_LOTE_PRODUCCION,cp.nombre_prod_semiterminado,tpp.NOMBRE_TIPO_PROGRAMA_PROD"+
                  " from PROGRAMA_PRODUCCION pp inner join TIPOS_PROGRAMA_PRODUCCION tpp on "+
                  " tpp.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD inner join "+
                  " COMPONENTES_PROD cp on cp.COD_COMPPROD=pp.COD_COMPPROD "+
                  " WHERE pp.COD_PROGRAMA_PROD='"+codProgramaProd+"' " +
                  " and cast(pp.COD_COMPPROD as varchar)+' '+cast(pp.COD_FORMULA_MAESTRA as varchar)+' '+"+
                  " cast(pp.COD_LOTE_PRODUCCION as varchar)+' '+cast(pp.COD_PROGRAMA_PROD as varchar)+' '+cast(pp.COD_TIPO_PROGRAMA_PROD as varchar)"+
                  " not IN( select CAST(ppc.COD_COMPPROD as varchar)+' '+cast(ppc.COD_FORMULA_MAESTRA as varchar)+' '+"+
                  " cast(ppc.COD_LOTE_PRODUCCION as varchar)+' '+cast(ppc.COD_PROGRAMA_PROD as varchar)+' '+cast(ppc.COD_TIPO_PROGRAMA_PROD as varchar)"+
                  " from PROGRAMA_PRODUCCION_CRONOGRAMA ppc where ppc.COD_ESTADO_PROGRAMA_PRODUCCION_CRONOGRAMA in (1,3))";

System.out.println("consulta Programas Prod "+consulta);
Connection con=null;
con=Util.openConnection(con);
Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
ResultSet rs=st.executeQuery(consulta);
out.println("<table id='programaProd' class='border'>");
out.println(" <tr class='headerClassACliente'><td></td> <td height='35px'>"+
            "PRODUCTO</td><td>LOTE</td><td>TIPO PROGRAMA PRODUCCION</td></tr>");
while(rs.next())
{
    out.println("<tr class='outputText2'>");
    out.println("<td><input type='checkbox'></input></td>");
    out.println("<td><input type='hidden' value='"+rs.getString("CODIGOS")+"'>"+rs.getString("nombre_prod_semiterminado")+"</td>");
    out.println("<td>"+rs.getString("COD_LOTE_PRODUCCION")+"</td>");
    out.println("<td>"+rs.getString("NOMBRE_TIPO_PROGRAMA_PROD")+"</td>");
    out.println("</tr>");
}
out.println("</table>");
rs.close();
st.close();
con.close();
%>
