<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ page language="java" %>
<%@ page import="com.cofar.web.*"%>
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
        <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
        <script src="../../js/general.js"></script>
        <script>
            function cancelar(){
                // alert(codigo);
                location='../personal_jsp/navegador_personal.jsf';
            }
            function cargarAlmacen(f){
                var codigo=f.codAreaEmpresa.value;
                location.href="filtroReporteExistencias.jsp?codArea="+codigo;
            }
        </script>

        


    </head>
    <body>
        <h3 style="top:1px" align="center">Reporte de tiempos de parada</h3 >

        <form method="post" action="reporteTiemposParada.jsp" name="form1">
            <div align="center">
                <table border="0"  border="0" class="border" >
                    <tr class="headerClassACliente">
                        <td  colspan="3" >
                            <div class="outputText3" align="center">
                                Introduzca Datos
                            </div>
                        </td>

                    </tr>

                    <tr class="outputText3">
                        <td class="">Maquinaria</td>
                        <td class="">::</td>
                        <td>
                            <select id="codMaquinaria" name="codMaquinaria">
                                <%
                                    Connection con=null;
                                    try
                                    {
                                        con=Util.openConnection(con);
                                        StringBuilder consulta=new StringBuilder("select m.COD_MAQUINA,m.NOMBRE_MAQUINA+' ('+m.CODIGO+')'");
                                                                consulta.append(" from MAQUINARIAS m");
                                                                consulta.append(" where m.COD_ESTADO_REGISTRO=1");
                                                                consulta.append(" order by m.NOMBRE_MAQUINA");
                                        Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                        ResultSet res=st.executeQuery(consulta.toString());
                                        while(res.next())
                                        {
                                            out.println("<option value='"+res.getInt(1)+"'>"+res.getString(2)+"</option>");
                                        }
                                    }
                                    catch(SQLException ex)
                                    {
                                        ex.printStackTrace();
                                    }
                                    finally
                                    {
                                        con.close();
                                    }
                                %>
                            </select>
                        </td>
                    </tr>


                    

                </table>

            </div>
            <br>
            <center>
                <input type="submit" class="btn"  value="Ver Reporte" name="reporte">
                
                <input type="hidden" name="codigosArea" id="codigosArea">

            </center>
            <!--datos de referencia para el envio de datos via post-->
            <input type="hidden" name="codProgramaProduccionPeriodo">
            <input type="hidden" name="nombreProgramaProduccionPeriodo">

            <input type="hidden" name="codCompProdArray">
            <input type="hidden" name="nombreCompProd">
            <input type="hidden" name="codProgramaProdArray">
            <input type="hidden" name="nombreProgramaProd">
            <input type="hidden" name="codCompProdP">
            <input type="hidden" name="nombreComProdP">
            <input type="hidden" name="codAreaEmpresaP">
            <input type="hidden" name="nombreAreaEmpresaP">
            <input type="hidden" name="desdeFechaP">
            <input type="hidden" name="hastaFechaP">
            <input type="hidden" name="desdeFechaPers">
            <input type="hidden" name="hastaFechaPers">
            <input type="hidden" name="reporteconfechas">
            <input type="hidden" name="reporteLotes"/>
            <input type="hidden" name="reporteconfechasPer">
            <input type="hidden" name="nombreEstado">
            <input type="hidden" name="nombreTipoActividad">



        </form>
        <script type="text/javascript" language="JavaScript"  src="../../js/dlcalendar.js"></script>
    </body>
</html>