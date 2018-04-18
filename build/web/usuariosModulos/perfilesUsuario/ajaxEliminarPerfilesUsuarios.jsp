<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ page language="java" %>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.sql.DriverManager"%> 
<%@ page import = "java.sql.ResultSet"%> 
<%@ page import = "java.sql.Statement"%> 
<%@ page import="com.cofar.util.*" %>

<%
    String mensaje="";
    Connection con=null;
    try
    {
        String codPerfil=request.getParameter("codPerfil");
        con=Util.openConnection(con);
        con.setAutoCommit(false);
        StringBuilder consulta=new StringBuilder("select count(*) as cantidadUsuarios");
                                consulta.append(" from USUARIOS_ACCESOS_MODULOS u");
                                consulta.append(" where u.COD_MODULO=6 ");
                                consulta.append(" and u.COD_PERFIL=").append(codPerfil);
        System.out.println("consulta verificar usuarios "+consulta.toString());
        Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
        ResultSet res=st.executeQuery(consulta.toString());
        res.next();
        if(res.getInt("cantidadUsuarios")==0)
        {
            consulta=new StringBuilder("DELETE PERFIL_ACCESO_VENTANA_ATLAS");
                                    consulta.append(" WHERE COD_PERFIL=").append(codPerfil);
            System.out.println("consulta delete perfil acceso ventanas atlas "+consulta.toString());
            PreparedStatement pst=con.prepareStatement(consulta.toString());
            if(pst.executeUpdate()>0)System.out.println("se elimino detalle ventanas");
            consulta=new StringBuilder("DELETE PERFILES_USUARIOS_ATLAS");
                        consulta.append(" where COD_PERFIL=").append(codPerfil);
            System.out.println("consulta delete perfil atlas "+consulta.toString());
            pst=con.prepareStatement(consulta.toString());
            if(pst.executeUpdate()>0)System.out.println("se elimino detalle ventanas");
            mensaje="1";
        }
        else
        {
            mensaje="No se puede eliminar porque existen usuarios que utilizan el perfil";
        }
        con.commit();
    }
    catch(SQLException ex) 
    {
        ex.printStackTrace();
        mensaje="Ocurrio un error al momento de registrar el perfil";
    }
    catch(Exception ex) 
    {
        ex.printStackTrace();
        mensaje="Ocurrio un error al momento de registrar el perfil";
    }
    finally
    {
        con.close();
    }
    out.clear();
    out.println(mensaje);
%>


