
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






<html >
    <head>
       <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
        
       <script src="scripts.js"></script>
       <style>
           .select
           {
                background-color:#9FEE9F;
           }
           .celda
           {
               width:40px;
           }
           .headerCol{
                height: 100%;
                color: #ffffff;
                font-family: Verdana, Arial, Helvetica, sans-serif;
                font-size: 11px;
                background-color: #800080;
            }
       </style>

    </head>
    <body  >
     <form method="post" action="procesoPresupuestoVentas.jsf"  name="form1">
            <br>
            <div align="center">
                <%
        try {
            Connection con=null;
            con = Util.openConnection(con);
                %>
                <STRONG STYLE="font-size:16px;color:#000000;">Programa Producción</STRONG>
                <br><br>
                <table border="0" class="outputText2"  style="border:1px solid #000000"  width="95%" cellspacing="0" cellpadding="2" id="navegador">
                    <tr class="headerClassACliente">
                        <td>
                            <div class="outputText2"><b>Nombre Programa Producción</b></div>
                        </td>
                        <td>
                            <div class="outputText2"><b>Obervaciones</b></div>
                        </td>
                        <td>
                            <div class="outputText2"><b>Estado</b></div>
                        </td>
                    </tr>
                    <%
                    String sql_1 = "SELECT PP.COD_PROGRAMA_PROD,PP.NOMBRE_PROGRAMA_PROD,PP.OBSERVACIONES";
                    sql_1 += ",(SELECT EP.NOMBRE_ESTADO_PROGRAMA_PROD FROM ESTADOS_PROGRAMA_PRODUCCION EP WHERE EP.COD_ESTADO_PROGRAMA_PROD = PP.COD_ESTADO_PROGRAMA)";
                    sql_1 += " FROM PROGRAMA_PRODUCCION_PERIODO PP WHERE PP.COD_ESTADO_PROGRAMA<>4";
                    Statement st_1 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    ResultSet rs_1 = st_1.executeQuery(sql_1);
                    while (rs_1.next()) {
                        String COD_PROGRAMA_PROD = rs_1.getString(1);
                        String NOMBRE_PROGRAMA_PROD = rs_1.getString(2);
                        String OBSERVACIONES = rs_1.getString(3);
                        String NOMBRE_ESTADO_PROGRAMA_PROD = rs_1.getString(4);
                    %>
                    <tr>
                        <h2>
                            
                            <td>
                                &nbsp;&nbsp;<a href="navegadorCronogramaProductos.jsf?codProgramaProd=<%=COD_PROGRAMA_PROD%>&nomProgProd='<%=NOMBRE_PROGRAMA_PROD%>'" title="Click para ingresasar"><%=NOMBRE_PROGRAMA_PROD%></a>
                            </td>
                            <td style="color:#000000" ><%=OBSERVACIONES%></td>
                            <td style="color:#000000"><%=NOMBRE_ESTADO_PROGRAMA_PROD%></td>
                        </h2>
                    </tr>
                    <%}%>
                </table>
                <%
            con.close();
        } catch (Exception e) {
        }
                %>
            </div>
        </form>
        </body>
</html>