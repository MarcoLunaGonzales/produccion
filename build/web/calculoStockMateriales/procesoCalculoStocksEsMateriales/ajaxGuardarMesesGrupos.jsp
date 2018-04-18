<%@page contentType="text/xml"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@ page import="com.cofar.util.*" %>
<%
Connection con=null;
String mensaje="";
try
{
        String[] datos=request.getParameter("datos").split(",");
        
        con =Util.openConnection(con);
        con.setAutoCommit(false);
        PreparedStatement pst=null;
        for(int i=0;i<datos.length;i+=2)
        {
            pst=con.prepareStatement("UPDATE GRUPOS SET NRO_MESES_STOCK_REPOSICION='"+datos[i+1]+"' WHERE COD_GRUPO="+datos[i]);
            pst.executeUpdate();
        }
        con.commit();
        mensaje="1";
        if(pst!=null)pst.close();
        con.close();
}
catch(SQLException ex)
{
    con.rollback();
    mensaje="Ocurrio un error al momento de guardar los meses,intente de nuevo";
    ex.printStackTrace();
}
out.clear();
out.println(mensaje);
%>
