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
String codProgramaPeriodo=request.getParameter("codProgramaPeriodo");

System.out.println("nombrePrograma :"+nombrePrograma);
System.out.println("obs :"+obs);
try{
    con=Util.openConnection(con);
    String sql_1="update PROGRAMA_PRODUCCION_PERIODO set NOMBRE_PROGRAMA_PROD = '"+nombrePrograma+"',OBSERVACIONES = '"+obs+"' where COD_PROGRAMA_PROD ="+codProgramaPeriodo;    
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