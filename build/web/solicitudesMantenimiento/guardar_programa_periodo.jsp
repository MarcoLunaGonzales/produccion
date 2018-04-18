<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ page language="java" %>
<%@ page import="com.cofar.util.*" %>
<%@ page import="com.cofar.web.*" %>
<%@ page import = "java.sql.Connection"%>
<%@ page import = "java.sql.DriverManager"%> 
<%@ page import = "java.sql.ResultSet"%> 
<%@ page import = "java.sql.Statement"%> 
<%@ page import = "java.sql.*"%> 
<%@ page import = "java.text.SimpleDateFormat"%> 
<%@ page import = "java.util.ArrayList"%> 
<%@ page import = "java.util.Date"%> 
<%@ page import = "javax.servlet.http.HttpServletRequest"%>
<%@ page import = "java.nio.*"%>
<%@ page language="java" import="java.util.*,com.cofar.util.CofarConnection" %>
<%@ page import="java.text.*" %>
<%! Connection con=null;%>
<%

String nombrePrograma=request.getParameter("nombreProgramaF");
String obs=request.getParameter("obsF");

System.out.println("nombrePrograma :"+nombrePrograma);
System.out.println("obs :"+obs);
try{
    con=Util.openConnection(con);
    String sql_0="select isnull(max(COD_PROGRAMA_PROD) + 1, 1) from PROGRAMA_PRODUCCION_PERIODO";
    Statement st_0=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
    ResultSet rs_0=st_0.executeQuery(sql_0);
    int codProgramaPord=0;
    if(rs_0.next())
        codProgramaPord=rs_0.getInt(1);
    String sql_1="insert into PROGRAMA_PRODUCCION_PERIODO (COD_PROGRAMA_PROD,NOMBRE_PROGRAMA_PROD,OBSERVACIONES,COD_ESTADO_PROGRAMA)";
    sql_1+=" values("+codProgramaPord+",'"+nombrePrograma+"','"+obs+"',1)";
    System.out.println("sql_1:"+sql_1);
    Statement st_1=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
    int result=st_1.executeUpdate(sql_1);
    con.close();
} catch (SQLException e) {
    e.printStackTrace();
}    
%>
<script>
           location='navgador_programa_periodo.jsf';
</script>