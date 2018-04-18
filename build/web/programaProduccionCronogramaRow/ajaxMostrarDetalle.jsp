<%@page contentType="text/xml"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%
String codProgProdCron= (request.getParameter("codProgProdCron")==null)||request.getParameter("codProgProdCron")==""?"0":request.getParameter("codProgProdCron");
String consulta = " select ap.NOMBRE_ACTIVIDAD,m.NOMBRE_MAQUINA,ppcd.FECHA_INICIO,ppcd.FECHA_FINAL,afm.ORDEN_ACTIVIDAD"+
                  " from PROGRAMA_PRODUCCION_CRONOGRAMA ppc inner join PROGRAMA_PRODUCCION_CRONOGRAMA_DETALLE ppcd on"+
                  " ppcd.COD_PROGRAMA_PRODUCCION_CRONOGRAMA=ppc.COD_PROGRAMA_PRODUCCION_CRONOGRAMA inner join maquinarias m"+
                  " on m.COD_MAQUINA=ppcd.COD_MAQUINA inner JOIN ACTIVIDADES_FORMULA_MAESTRA afm on "+
                  " afm.COD_ACTIVIDAD_FORMULA=ppcd.COD_ACTIVIDAD_FORMULA and afm.COD_ESTADO_REGISTRO=1 and"+
                  " afm.COD_AREA_EMPRESA=96 inner join ACTIVIDADES_PRODUCCION ap on ap.COD_ACTIVIDAD=afm.COD_ACTIVIDAD"+
                  " where ppc.COD_PROGRAMA_PRODUCCION_CRONOGRAMA='"+codProgProdCron+"'"+
                  " group by ap.NOMBRE_ACTIVIDAD,m.NOMBRE_MAQUINA,ppcd.FECHA_INICIO,ppcd.FECHA_FINAL,afm.ORDEN_ACTIVIDAD"+
                  " order by afm.ORDEN_ACTIVIDAD asc,ppcd.FECHA_INICIO ";
System.out.println("consulta Detalle"+consulta);
Connection con=null;
con=Util.openConnection(con);
Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
ResultSet res=st.executeQuery(consulta);
out.println("<table id='detalleCronograma' class='border'>");
out.println(" <tr class='headerClassACliente'><td>ACTIVIDAD</td><td height='35px'>"+
            "MAQUINARIA</td><td>FECHA INICIO</td><td>FECHA FINAL</td></tr>");
SimpleDateFormat sdf= new SimpleDateFormat("HH:mm");
SimpleDateFormat sdt= new SimpleDateFormat("dd/MM/yyyy");
while(res.next())
{
    out.println("<tr class='outputText2'>");
    out.println("<td>"+res.getString("NOMBRE_ACTIVIDAD")+"</td>");
    out.println("<td>"+res.getString("NOMBRE_MAQUINA")+"</td>");
    out.println("<td><span>"+sdt.format(res.getTimestamp("FECHA_INICIO"))+"</span><input class='celda' value='"+sdf.format(res.getTimestamp("FECHA_INICIO"))+"'/></td><td><span>"+sdt.format(res.getTimestamp("FECHA_FINAL"))+"</span><input class='celda' value='"+sdf.format(res.getTimestamp("FECHA_FINAL"))+"'/></td>");
    out.println("</tr>");
}
out.println("</table>");
res.close();
st.close();
con.close();
%>
