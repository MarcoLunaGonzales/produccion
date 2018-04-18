<%@page contentType="text/xml"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%
String nombreUsuario=request.getParameter("nombreUsuario");
String contrasenaUsuario=request.getParameter("contrasena");
String usuario="codPersonalGeneral=0;codTipoPermiso=0;document.getElementById('nombreUsuarioPersonal').innerHTML='Sin Usuario'";
Connection con=null;
try
{

    
    con=Util.openConnection(con);
    StringBuilder consulta=new StringBuilder("select isnull(a.COD_AREA_EMPRESA, uap.COD_AREA_EMPRESA) as COD_AREA_EMPRESA,um.COD_PERSONAL");
                                        consulta.append(" ,isnull(c.COD_TIPO_PERMISO_ESPECIAL_ATLAS,0) as COD_TIPO_PERMISO_ESPECIAL_ATLAS");
                                        consulta.append(" ,isnull(p.AP_PATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL,pt.AP_PATERNO_PERSONAL+' '+pt.NOMBRES_PERSONAL) as nombrePersonal");
                                consulta.append(" from USUARIOS_MODULOS um");
                                        consulta.append(" left outer join PERSONAL_TEMPORAL pt on pt.COD_PERSONAL = um.COD_PERSONAL");
                                        consulta.append(" left outer join personal p on p.COD_PERSONAL = um.COD_PERSONAL");
                                        consulta.append(" left outer join ADMINISTRADORES_TABLETA a on a.COD_PERSONAL =p.COD_PERSONAL");
                                        consulta.append(" left outer join PERSONAL_AREA_PRODUCCION uap on uap.COD_PERSONAL =um.COD_PERSONAL");
                                        consulta.append(" left outer join CONFIGURACION_PERMISOS_ESPECIALES_ATLAS c on c.COD_PERSONAL=um.COD_PERSONAL");
                                                    consulta.append(" and c.COD_TIPO_PERMISO_ESPECIAL_ATLAS in (11,12)");
                                consulta.append(" where um.COD_MODULO = 10");
                                        consulta.append(" and um.NOMBRE_USUARIO = ?");
                                        consulta.append(" and um.CONTRASENA_USUARIO = ?");
    System.out.println("consulta buscar usuario "+consulta.toString());
    PreparedStatement pst=con.prepareStatement(consulta.toString());
    pst.setString(1,nombreUsuario);System.out.println("p1: "+nombreUsuario);
    pst.setString(2,contrasenaUsuario);System.out.println("p1: "+contrasenaUsuario);
    ResultSet res=pst.executeQuery();
    
    if(res.next())
    {
        usuario="codPersonalGeneral="+res.getInt("COD_PERSONAL")+";codTipoPermiso="+res.getInt("COD_TIPO_PERMISO_ESPECIAL_ATLAS")+";"+
                "document.getElementById('nombreUsuarioPersonal').innerHTML='"+res.getString("nombrePersonal")+"';";
    }
    out.clear();
    out.println(usuario);
}
catch(SQLException ex)
{
    ex.printStackTrace();
}
finally
{
    con.close();
}
%>
