package programaProduccionCronograma_1;

package PINKI;

<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ page language="java" %>
<%@ page import="com.cofar.web.*" %>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.sql.DriverManager"%> 
<%@ page import = "java.sql.ResultSet"%> 
<%@ page import = "java.sql.Statement"%> 
<%@ page import="com.cofar.util.*" %>
<%@ page language="java" import="java.util.*" %>
<%@ page errorPage="ExceptionHandler.jsp" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>





<html>
    <head>
        <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
        <script src="../js/general.js"></script>
       
        <script >
        function verCargos(codAreaEmpresa)
        {
           
           //alert(codAreaEmpresa) ;
            location="navegadorCargos.jsf?codAreaEmpresa="+codAreaEmpresa;
           
        }
        </script>



    </head>
    <body>
        <h3 align="center">Agencias</h3>
        <form method="post" action="reporteResumenDevoluciones.jsp" target="_blank" name="form1">
            <div align="center">
                <center>
                <table border="0"  border="0" class="border" width="50%">
                    <tr class="headerClassACliente">
                        <td height="35px" colspan="6" >
                            <div class="outputText3" align="center">
                                Agencia
                            </div>
                        </td>

                    </tr>
                    
                        
                    <%
					try{
					Connection con=null;
					con=Util.openConnection(con);
					String consulta="select ae.COD_AREA_EMPRESA,ae.NOMBRE_AREA_EMPRESA from AGENCIAS_VENTA a inner join AREAS_EMPRESA ae on " +
                            "ae.COD_AREA_EMPRESA=a.COD_AREA_EMPRESA and ae.COD_AREA_EMPRESA <>1";
					Statement st=con.createStatement();
					ResultSet res=st.executeQuery(consulta);
                    while(res.next())
                        {
					%>
                    <tr style="cursor:hand" onmouseover="this.style.backgroundColor='#DDE3E4'" onmouseout="this.style.backgroundColor='#FFFFFF';" >
                        <td onclick="verCargos('<%=res.getString("COD_AREA_EMPRESA")%>')" class="outputText2">
                        <b><%=res.getString("NOMBRE_AREA_EMPRESA")%></b>

                               </td>
                    </tr>
					<%
                    }
                    res.close();
					}
					catch(SQLException ex)
					{
                        ex.printStackTrace();
					}
					%>
                            
                    
                </table>
                </center>


            </div>
            <br>
            <br>
            
        </form>
        
    </body>
</html>