<html>
<%@ page language="java"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.cofar.util.*" %>
<%@ page import="com.cofar.web.*" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>




    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
        <title>Costo Estandar</title>
        <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
        <script type="text/javascript">
            function verReporteCostoReal()
            {
                document.getElementById("formulario").action="reporteCostoProducto.jsf";
                document.getElementById("formulario").submit();
            }
            function verReporteCostoEstandar()
            {
                document.getElementById("formulario").action="reporteCostoProductoEstandar.jsf";
                document.getElementById("formulario").submit();
            }
            
        </script>
    </head>
    
    <body>
        
        <form method="post"  id="formulario" action="reporteCostoProducto.jsf" name="upform" target="_blank" >
            
            <div align="center">
                <h4 align="center">Costo Estandar</h4>
                
                <table border="0"  border="0" class="tablaFiltroReporte"  style="border:1px solid #000000"  cellspacing="0">    
                    <thead>
                        <tr>
                            <td colspan="3" >Filtro Reporte Costo Estandar</td>
                        </tr>    
                    </thead>
                    <tbody>
                        <tr>
                            <td class="outputTextBold">Año</td>
                            <td class="outputTextBold">::</td>
                            <td>
                                <select class="inputText" name="anio">
                                    <%
                                        
                                        Connection con=null;
                                        con=Util.openConnection(con);
                                        Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                        StringBuilder consulta=new StringBuilder("select DATEPART(year,g.FECHA_FIN) as anio")
                                                                    .append(" from gestiones g ")
                                                                    .append(" where g.FECHA_FIN is not null")
                                                                    .append(" order by g.COD_GESTION desc");
                                        ResultSet res=st.executeQuery(consulta.toString());
                                        while(res.next())
                                        {
                                            out.println("<option value='"+res.getInt("anio")+"'>"+res.getString("anio")+"</option>");
                                        }
                                    %>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td class="outputTextBold">Mes</td>
                            <td class="outputTextBold">::</td>
                            <td>
                                <select class="inputText" name="nroMes">
                                    <%
                                        consulta=new StringBuilder("select m.COD_MES,m.NOMBRE_MES")
                                                            .append(" from meses m ")
                                                            .append(" where m.COD_MES BETWEEN 1 and 12")
                                                            .append(" order by m.COD_MES");
                                        res=st.executeQuery(consulta.toString());
                                        while(res.next())
                                        {
                                            out.println("<option value='"+res.getInt("COD_MES")+"'>"+res.getString("NOMBRE_MES")+"</option>");
                                        }
                                        con.close();
                                    %>
                                </select>
                            </td>
                        </tr>
                    </tbody>
                    <tfoot>
                        <tr>
                        <td class="tdCenter" colspan="3">
                            <a class="btn" onclick="verReporteCostoReal()">Costo Real</a>
                            <a class="btn" onclick="verReporteCostoEstandar()">Costo Estandar</a>
                        </td>
                        </tr>
                    </tfoot>
                    
                </table>
            </div>
            
            
        </form>
        <script type="text/javascript" language="JavaScript"  src="../js/dlcalendar.js"></script>
    </body>
</html>

