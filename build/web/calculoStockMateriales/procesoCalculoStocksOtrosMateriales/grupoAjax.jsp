<%@page contentType="text/html"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@ page import="com.cofar.util.*" %>
<%
String codCapitulo=request.getParameter("codCapitulo");
StringBuilder consulta=new StringBuilder(" select g.COD_GRUPO,g.NOMBRE_GRUPO");
                        consulta.append(" from GRUPOS  g ");
                        consulta.append(" where g.COD_CAPITULO in (").append(codCapitulo).append(")");
                        consulta.append(" order by g.NOMBRE_GRUPO ");
Connection con=null;
try
{
    con =Util.openConnection(con);
    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
    ResultSet res=st.executeQuery(consulta.toString());
    out.println("<select id='codGrupo' name='codGrupo' class='inputText' multiple size='10'>");
    while(res.next())
    {
        out.println("<option value='"+res.getString(1)+"'>"+res.getString(2)+"</option>");
    }
    out.println("</select>");
}
catch(SQLException ex)
{
    ex.printStackTrace();
    out.println("Ocurrio un error vuelva a ingresar al reporte");
}
catch(Exception e)
{
    e.printStackTrace();
    out.println("Ocurrio un error vuelva a ingresar al reporte");
}
finally
{
    con.close();
}

%>
