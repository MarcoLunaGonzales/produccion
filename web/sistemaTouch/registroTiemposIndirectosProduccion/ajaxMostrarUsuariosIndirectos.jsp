<%@page contentType="text/xml"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.Date" %>
<%
String codAreaEmpresa=request.getParameter("codAreaEmpresa");
Connection con=null;
String innerHTML="";
try {
    con = Util.openConnection(con);
    Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
    String consulta = "select u.NOMBRE_USUARIO,u.COD_PERSONAL from USUARIOS_MODULOS u where ( u.COD_PERSONAL in (select pap.COD_PERSONAL from PERSONAL_AREA_PRODUCCION pap where pap.COD_AREA_EMPRESA in ("+codAreaEmpresa+"))" +
            " or u.COD_PERSONAL in (select ad.COD_PERSONAL from ADMINISTRADORES_TABLETA ad where ad.COD_AREA_EMPRESA in ("+codAreaEmpresa+"))) and u.COD_MODULO=10 order by u.NOMBRE_USUARIO";
    ResultSet res = st.executeQuery(consulta);
    while (res.next()) {
        innerHTML+="<option value='"+res.getString("COD_PERSONAL")+"'>"+res.getString("NOMBRE_USUARIO")+"</option>";
    }
    res.close();
    st.close();
    con.close();
}
catch (SQLException ex)
{
       ex.printStackTrace();
}
out.clear();
out.println(innerHTML);
%>
