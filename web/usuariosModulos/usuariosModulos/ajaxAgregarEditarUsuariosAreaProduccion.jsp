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
        String codPersonal=request.getParameter("codPersonal");
        String[] codAreasEmpresa=request.getParameter("codigosArea").split(",");
        con=Util.openConnection(con);
        con.setAutoCommit(false);
        StringBuilder consulta=new StringBuilder(" DELETE USUARIOS_AREA_PRODUCCION");
                                consulta.append(" where cod_personal=").append(codPersonal);
        System.out.println("consulta delete area produccion "+consulta.toString());
        PreparedStatement pst=con.prepareStatement(consulta.toString());
        if(pst.executeUpdate()>0)System.out.println("Se GUARDO LA EDICION DE USUARIO");
        consulta=new StringBuilder("INSERT INTO USUARIOS_AREA_PRODUCCION(COD_PERSONAL, COD_AREA_EMPRESA,COD_TIPO_PERMISO)");
                    consulta.append(" VALUES (");
                        consulta.append(codPersonal);
                        consulta.append(",?");
                        consulta.append(",1");
                    consulta.append(")");
        System.out.println("consulta registrar usuario area produccion "+consulta.toString());
        pst=con.prepareStatement(consulta.toString());
        for(String codAreaEmpresa:codAreasEmpresa)
        {
            pst.setString(1, codAreaEmpresa);
            if(pst.executeUpdate()>0)System.out.println("se registro el area produccion");
        }
        con.commit();
        mensaje="1";
 
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


