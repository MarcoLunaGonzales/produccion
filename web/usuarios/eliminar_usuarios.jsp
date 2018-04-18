<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ page language="java" %>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.sql.DriverManager"%> 
<%@ page import = "java.sql.ResultSet"%> 
<%@ page import = "java.sql.Statement"%> 
<%@ page import="com.cofar.util.*" %>
<%! 
Connection con=null;
String codPersonal="";
String [] arraydecodigos= new String[50];
String codigo="";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        
        <% 
        try {
            con=CofarConnection.getConnectionJsp();    //
            /*for(int m=0;m<=49;m++) {
                
                arraydecodigos[m]="";
            }*/
            //
            
            
            
            codigo="";
            codigo = request.getParameter("codigo");
            arraydecodigos=codigo.split(",");
            //String personal=request.getParameter("codigo");
            //System.out.println("personal:"+personal);
            
            
            for(int i=0;i<=arraydecodigos.length-1;i++) {
                Statement stm1 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                try{
                    
                    System.out.println("arraydecodigos:"+arraydecodigos[i]);
                    String sql_eliminar=" delete from USUARIOS_ACCESOS_MODULOS ";
                    sql_eliminar+=" where  cod_personal='"+arraydecodigos[i]+"'";
                    sql_eliminar+=" and cod_modulo=1";
                    System.out.println("sql_eliminar:"+sql_eliminar);
                    stm1.executeUpdate(sql_eliminar);
                    String sql_eliminar_1=" delete from usuarios_modulos ";
                    sql_eliminar_1+=" where  cod_personal='"+arraydecodigos[i]+"'";
                    sql_eliminar_1+=" and cod_modulo=1";
                    System.out.println("sql_eliminar:"+sql_eliminar_1);
                    stm1.executeUpdate(sql_eliminar_1);
                } catch(Exception e) {
                }
            }
            
        }
        
        catch(Exception e) {
        %><%=e%>
        <%
        }
        
        %>
        <script>
 
                   location='../usuarios/navegador_usuarios.jsf?codigo=1';
        </script>
    </body>
</html>
