<%@page contentType="text/xml"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%
String nombreUsuario=request.getParameter("nombreUsuario");
String contrasenaUsuario=request.getParameter("contrasena");
String usuario="codPersonal=0;administrador=0;document.getElementById('nombreUsuarioPersonal').innerHTML='Sin Usuario'";
try
{

    Connection con=null;
    con=Util.openConnection(con);
    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
    String consulta="SELECT um.COD_PERSONAL,isnull(at.COD_PERSONAL,0) as administrador,(p.AP_PATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL) as nombrePersonal"+
                    " from USUARIOS_MODULOS um left OUTER JOIN ADMINISTRADORES_TABLETA at on "+
                    " um.COD_MODULO=6 and um.COD_PERSONAL=at.COD_PERSONAL inner join PERSONAL p on p.COD_PERSONAL=um.COD_PERSONAL"+
                    " where um.COD_PERSONAL='"+nombreUsuario+"' and um.CONTRASENA_USUARIO='"+contrasenaUsuario+"' and um.COD_MODULO=6";
    System.out.println("consulta buscar usuario "+consulta);
    ResultSet res=st.executeQuery(consulta);
    
    if(res.next())
    {
        usuario="codPersonal="+(res.getInt("COD_PERSONAL")*4)+";administrador="+res.getInt("administrador")+";"+
                "document.getElementById('nombreUsuarioPersonal').innerHTML='"+res.getString("nombrePersonal")+"';";
    }
    res.close();
    st.close();
    con.close();
    out.clear();
    out.println(usuario);
}
catch(SQLException ex)
{
    ex.printStackTrace();
}
%>
