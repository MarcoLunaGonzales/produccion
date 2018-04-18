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
String fechaInicio=request.getParameter("fecha_inicio")==null?"":request.getParameter("fecha_inicio");
String fechaFinal=request.getParameter("fecha_final")==null?"":request.getParameter("fecha_final");
System.out.println("parameters " + fechaInicio + " " +fechaFinal);
System.out.println("nombrePrograma :"+nombrePrograma);
System.out.println("obs :"+obs);
if(!fechaInicio.equals("") && !fechaFinal.equals("")){
    String[] fechaInicioArray = fechaInicio.split("/");
    fechaInicio = fechaInicioArray[2] + "/" + fechaInicioArray[1] + "/"+fechaInicioArray[0];
    String[] fechaFinalArray = fechaFinal.split("/");
    fechaFinal = fechaFinalArray[2] + "/" + fechaFinalArray[1] + "/"+fechaFinalArray[0];
}

try{
    con=Util.openConnection(con);
    String sql_1="update PROGRAMA_PRODUCCION_PERIODO set NOMBRE_PROGRAMA_PROD = '"+nombrePrograma+"',OBSERVACIONES = '"+obs+"',fecha_inicio='"+fechaInicio+"',fecha_final = '"+fechaFinal+"'  where COD_PROGRAMA_PROD ="+codProgramaPeriodo;
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