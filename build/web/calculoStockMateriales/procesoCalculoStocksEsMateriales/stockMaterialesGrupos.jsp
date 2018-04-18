<%@page contentType="text/xml"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@ page import="com.cofar.util.*" %>

<%
try
{
        String codGrupo=request.getParameter("codGrupo");

        String consulta=" select g.COD_GRUPO,g.NOMBRE_GRUPO,g.NRO_MESES_STOCK_REPOSICION"+
                   " from grupos g where g.cod_grupo in ("+codGrupo+")order by g.NOMBRE_GRUPO";
        System.out.println("consulta stock minimo  :"+consulta);
        Connection con=null;
        con =Util.openConnection(con);
        Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
        ResultSet res=st.executeQuery(consulta);
        out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
        out.println("<table id='tablaGruposReposicion'><tr><td class='headerClassACliente' colspan='2'>Nro Meses Stock de reposicion</td></tr>" +
                    "<tr><td class='headerClassACliente' style='text-align:center' >Grupo</td>" +
                    "<td class='headerClassACliente' style='text-align:center'>Nro Meses de<br>reposición</td></tr>");
        while(res.next())
        {
            out.println("<tr><td><input type='hidden' value='"+res.getInt("COD_GRUPO")+"'/>" +
                        "<span class='outputText2'>"+res.getString("NOMBRE_GRUPO")+"</span></td>" +
                        "<td><input type='text' value='"+res.getDouble("NRO_MESES_STOCK_REPOSICION")+"'/></td></tr>");
        }
        out.println("<tr><td colspan='2'><center><button id='buttonMat1' class='btn' onclick='guardarMesesReposicionGrupos();'>Guardar</button><button id='buttonMat2' onclick='ocultarDefinirMesesReposicion();' class='btn'>Cancelar</button></center></td></tr></table>");
}
catch(Exception ex)
{
    ex.printStackTrace();
}
%>
