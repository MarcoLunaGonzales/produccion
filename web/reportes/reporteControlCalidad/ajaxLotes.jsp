

<%@page contentType="text/xml"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>
<%
out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
String codComprod=request.getParameter("codComprod")!=null?request.getParameter("codComprod"):"";
String lote=request.getParameter("lote")!=null?request.getParameter("lote"):"";
System.out.println("lote"+lote);
String consulta ="select era.NOMBRE_ESTADO_RESULTADO_ANALISIS,datosPrograma.COD_FORMA,era.COD_ESTADO_RESULTADO_ANALISIS,ra.COD_LOTE,cp.nombre_prod_semiterminado,datosPrograma.COD_PROD from RESULTADO_ANALISIS ra inner join COMPONENTES_PROD cp"+
" on cp.COD_COMPPROD=ra.COD_COMPROD inner join ESTADOS_RESULTADO_ANALISIS era on era.COD_ESTADO_RESULTADO_ANALISIS=ra.COD_ESTADO_RESULTADO_ANALISIS"+
" outer apply( select TOP 1 cpv.COD_FORMA,cpv.COD_PROD from PROGRAMA_PRODUCCION p  inner join COMPONENTES_PROD_VERSION cpv on cpv.COD_COMPPROD=p.COD_COMPPROD"+
" and cpv.COD_VERSION=p.COD_COMPPROD_VERSION where p.COD_LOTE_PRODUCCION=ra.COD_LOTE and p.COD_COMPPROD=ra.COD_COMPROD"+
") as datosPrograma"
        + " where 1=1";//where ra.COD_ESTADO_RESULTADO_ANALISIS in (1,2)
if(!lote.equals(""))
    {
    consulta+=" and ra.COD_LOTE = '"+lote+"'";
    }
if(!codComprod.equals("0"))
{
    consulta+=" and ra.COD_COMPROD='"+codComprod+"'";
}
consulta+=" order by cp.nombre_prod_semiterminado,ra.COD_LOTE";
System.out.println("consulta lotes "+consulta);
Connection con=null;
con=Util.openConnection(con);
Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
ResultSet rs=st.executeQuery(consulta);
out.println("<table id='dataLote' class='outputText0' cellpadding='0' cellspacing='0' style='width:80%' > <tr bgcolor='#cccccc'>");
out.println("<td height='30px'  style='border-bottom: solid #666666 1px; border-left: solid #666666 1px;border-top: solid #666666 1px;' bgcolor='#f2f2f2'  align='center' ></td> " +
        " <td  style='border-bottom: solid #666666 1px; border-left: solid #666666 1px;border-top: solid #666666 1px;' bgcolor='#f2f2f2'  align='center' class='outputText2' ><b>Lote</b></td> " +
        " <td  style='border-bottom: solid #666666 1px; border-left: solid #666666 1px;border-top: solid #666666 1px;' bgcolor='#f2f2f2'  align='center' class='outputText2'><b>Producto</b></td>"+
        " <td  style='border-bottom: solid #666666 1px; border-left: solid #666666 1px;border-top: solid #666666 1px;' bgcolor='#f2f2f2'  align='center' class='outputText2'><b>Estado CC</b></td>"+
        " </tr>");

while(rs.next()){
    out.println("<tr><td style='border-bottom: solid #666666 1px; border-left: solid #666666 1px;padding:5px' bgcolor='#f2f2f2' >"+(rs.getString("COD_ESTADO_RESULTADO_ANALISIS").equals("3")?"&nbsp;":"<input type='checkbox' />")+"</td>" +
            "<td style='border-bottom: solid #666666 1px; border-left: solid #666666 1px;;padding:5px' bgcolor='#f2f2f2' class='outputText2' ><input type='hidden' value='"+rs.getString("COD_FORMA")+"'/><span>"+rs.getString("COD_LOTE")+"</span></td>" +
            "<td style='border-bottom: solid #666666 1px; border-left: solid #666666 1px;;padding:5px' bgcolor='#f2f2f2' class='outputText2'><input type='hidden' value='"+rs.getString("COD_PROD")+"'/>"+rs.getString("nombre_prod_semiterminado")+"</td>" +
            "<td style='border-bottom: solid #666666 1px; border-left: solid #666666 1px;;padding:5px' bgcolor='#f2f2f2' class='outputText2'>"+rs.getString("NOMBRE_ESTADO_RESULTADO_ANALISIS")+"</td>" +
            "</tr>");
}
out.println("</table>");
%>