<%@page contentType="text/xml"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>
<%
//out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
String codProgramaProduccion=request.getParameter("codProgramaProduccion")==null?"0":request.getParameter("codProgramaProduccion");
String consulta = "select m.COD_MAQUINA,m.NOMBRE_MAQUINA from maquinarias m where m.COD_MAQUINA in( " +
        " select DISTINCT(sppr.COD_MAQUINA) from SEGUIMIENTO_PROGRAMA_PRODUCCION sppr  " +
        " where sppr.COD_PROGRAMA_PROD in ("+codProgramaProduccion+")) and m.COD_ESTADO_REGISTRO = 1 ORDER BY m.NOMBRE_MAQUINA ASC";

System.out.println("consulta maquina"+consulta);
Connection con=null;
con=Util.openConnection(con);
Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
ResultSet rs=st.executeQuery(consulta);
out.println("<select name='codMaquina'  size='8' class='outputText2' multiple onchange='chk_todoMaquina.checked = false;'>");
while(rs.next()){
    out.println("<option value='"+rs.getString("COD_MAQUINA")+"'>"+rs.getString("NOMBRE_MAQUINA")+"</option>");
}
out.println("</select>");
if(rs!=null){
    rs.close();
    st.close();
    con.close();
}
%>
