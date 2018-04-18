package evaluaProveedores;

package calculoPremiosBimensuales_1;


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
con=CofarConnection.getConnectionJsp();    
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
            String datos=request.getParameter("datos");
            String cod_tipo_incentivo_regional="";
            String sql2="";
            String sql3="";
            int tamanio=0;
            String codigos[]=datos.split(",");
            tamanio=codigos.length;
            System.out.println(tamanio);
            System.out.println(tamanio);
            for(int i=0; i<tamanio; i++){
                   cod_tipo_incentivo_regional=codigos[i];
                    System.out.println(cod_tipo_incentivo_regional);
                   try {
                    
                    sql2=" delete from TIPOS_INCENTIVO_REGIONAL_OTROS";
                    sql2+=" where COD_TIPO_INCENTIVO_REGIONAL='"+cod_tipo_incentivo_regional+"'";
                    System.out.println("sql2"+sql2);
                    Statement st2=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    int rs2=st2.executeUpdate(sql2);
                    
                    sql3=" delete from TIPOS_INCENTIVO_REGIONAL_OTROS_DETALLE ";
                    sql3+=" where COD_TIPO_INCENTIVO_REGIONAL='"+cod_tipo_incentivo_regional+"'";
                    System.out.println("sql3"+sql3);
                    Statement st3=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    int rs3=st3.executeUpdate(sql3);
                    
                    } catch (SQLException e) {
                     e.printStackTrace();
                    }
            }
         
              %>
              
        </form>
    </body>
</html>
<script language="JavaScript">
	location.href="navegadorTipoIncentivoRegional.jsf";
</script>
