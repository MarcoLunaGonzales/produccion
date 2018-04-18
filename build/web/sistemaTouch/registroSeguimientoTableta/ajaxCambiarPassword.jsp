<%@page contentType="text/xml"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%
String nombreUsuario=request.getParameter("nombreUsuario");
String contrasenaUsuario=request.getParameter("contrasena");
String contrasenaNueva=request.getParameter("contrasenaNueva");
int codPersonal=0;
try
{

    Connection con=null;
    con=Util.openConnection(con);
    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
    String consulta="select u.COD_PERSONAL from USUARIOS_MODULOS u where u.COD_MODULO=6 and u.COD_PERSONAL ='"+nombreUsuario+"' and u.CONTRASENA_USUARIO='"+contrasenaUsuario+"'";
    System.out.println("consulta buscar usuario "+consulta);
    ResultSet res=st.executeQuery(consulta);
    if(res.next())
    {
        codPersonal=res.getInt("COD_PERSONAL");
    }
    if(codPersonal>0)
    {
        consulta="update USUARIOS_MODULOS set CONTRASENA_USUARIO=? where COD_PERSONAL='"+codPersonal+"' and COD_MODULO=6";
        System.out.println("consulta update contrasena "+consulta);
        PreparedStatement pst=con.prepareStatement(consulta);
        pst.setString(1,contrasenaNueva);
        if(pst.executeUpdate()>0)System.out.println("se cambio la contraseña");
    }
    res.close();
    st.close();
    con.close();
    out.clear();
    out.println(codPersonal);
    
}
catch(SQLException ex)
{
    ex.printStackTrace();
}
%>
