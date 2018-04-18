package evaluaProveedores;


<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ page language="java" %>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.sql.DriverManager"%> 
<%@ page import = "java.sql.ResultSet"%> 
<%@ page import = "java.sql.Statement"%> 
<%@ page import = "org.joda.time.DateTime"%>
<%@ page import="com.cofar.util.*" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>
<%@ page import = "java.text.DecimalFormat"%> 
<%@ page import = "java.text.NumberFormat"%> 
<%@ page import = "java.util.Locale"%> 
<%! Connection con=null;
%>
<%
con=Util.openConnection(con)   ;
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title></title>
        <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
        <script src="../js/general.js"></script>
        <script>                        
        </script>
    </head>
    <body>
        <form name="form1" action="">
<%  
            String sql="";
            String sql2="";       
            String cod_gestion=request.getParameter("cod_gestion");
            String cod_mes=request.getParameter("cod_mes");
            String fecha_inicio=request.getParameter("fecha_inicio");
            String fecha_inicioV[]=fecha_inicio.split("/");
            fecha_inicio=fecha_inicioV[2]+"/"+fecha_inicioV[1]+"/"+fecha_inicioV[0];
            String fecha_final=request.getParameter("fecha_final");
            String fecha_finalV[]=fecha_final.split("/");
            fecha_final=fecha_finalV[2]+"/"+fecha_finalV[1]+"/"+fecha_finalV[0];
            String cod_tipo_incentivo_regional="1";
            try {
                    
                    sql="select max(COD_PERIODO_EVALUACION)+1 from PERIODOS_EVALUACION_PROVEEDORES";
                    
                    System.out.println("sql"+sql);
                    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet rs=st.executeQuery(sql);
                    while (rs.next()){
                        cod_tipo_incentivo_regional=rs.getString(1);
                        if(cod_tipo_incentivo_regional==null){
                            cod_tipo_incentivo_regional="1";
                        }
                    }
                    sql2="insert into PERIODOS_EVALUACION_PROVEEDORES(COD_PERIODO_EVALUACION, cod_gestion, cod_mes,FECHA_INICIO,FECHA_FINAL)";
                    sql2+="values('"+cod_tipo_incentivo_regional+"','"+cod_gestion+"','"+cod_mes+"','"+fecha_inicio+"','"+fecha_final+"')";
                    System.out.println("sql2"+sql2);
                    Statement st2=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    int rs2=st2.executeUpdate(sql2);
            
           } catch (SQLException e) {
            e.printStackTrace();
            }
%>       
        </form>
    </body>
</html>
<script language="JavaScript">
	location.href="navegadorPeriodosEvalucionProveedor.jsp";
</script>
