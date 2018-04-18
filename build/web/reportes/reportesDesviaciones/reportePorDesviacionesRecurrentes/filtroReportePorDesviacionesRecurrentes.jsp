
<%@ page import="java.sql.*" %>
<%@ page import="com.cofar.util.*" %>
<%@ page import="com.cofar.web.*" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>

<html>
    <head>
        <link rel="STYLESHEET" type="text/css" href="../../../css/ventas.css" />
        <link rel="STYLESHEET" type="text/css" href="../../../css/chosen.css" />
        <script src="../../../js/general.js"></script>
        
        <script type="text/javascript"> 
            function verReporte(){
                var url = "reportePorDesviacionesRecurrentes.jsf?codDesviacion="+document.getElementById("codDesviacion").value
                                                        +"&codAreaGeneradora="+document.getElementById("codAreaGeneradora").value
                                                        +"&codTipoDesviacion="+document.getElementById("codTipoDesviacion").value;
                abrirVentana(url);
            }
        </script>
    </head>
    <body>
        <h4 align="center">REPORTE DE DESVIACIONES POR RECURRENCIA</h4>
        <form id="form1">
            <div align="center">
                <table border="0" class="tablaFiltroReporte" cellspacing="2" cellpadding="3">   
                    <thead>
                        <tr>
                            <td  colspan="3" >
                                <div class="outputText2" align="center">
                                Introduzca los Parámetros del Reporte
                                </div> 
                            </td>
                        </tr>  
                    </thead>
                    <tbody>
                        <tr>
                            <td class="tdRight outputTextBold">Desviación genérica</td>
                            <td><b>::</b></td>
                            <td>
                                <select id="codDesviacion" name="codDesviacion" class="inputText chosen" style="width:300px">
                                    <%                                    
                                        Connection con = null;

                                        try {
                                            con = Util.openConnection(con);
                                            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                                            String consulta = "select dg.COD_DESVIACION_GENERICA, dg.NOMBRE_DESVIACION_GENERICA"
                                                    +" from DESVIACIONES_GENERICAS dg"
                                                    +" where dg.COD_ESTADO_REGISTRO = 1"
                                                    +" order by dg.NOMBRE_DESVIACION_GENERICA";
                                            ResultSet res =st.executeQuery(consulta);
                                            out.println("<option value='0'>--TODOS--</option>");
                                            while(res.next()){
                                                out.println("<option value='"+res.getInt("COD_DESVIACION_GENERICA")+"'>"+res.getString("NOMBRE_DESVIACION_GENERICA")+"</option>");
                                            }

                                    %>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td class="tdRight outputTextBold">Area generadora</td>
                            <td><b>::</b></td>
                            <td>
                                <select id="codAreaGeneradora" name="codAreaGeneradora" class="inputText chosen" style="width:300px">
                                    <%
                                            consulta = "SELECT agd.COD_AREA_GENERADORA_DESVIACION, agd.NOMBRE_AREA_GENERADORA_DESVIACION"
                                                                +" FROM AREAS_GENERADORAS_DESVIACION agd"
                                                                +" order by agd.NOMBRE_AREA_GENERADORA_DESVIACION";
                                            st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                                            res =st.executeQuery(consulta);
                                            out.println("<option value='0'>--TODOS--</option>");
                                            while(res.next()){
                                                out.println("<option value='"+res.getInt("COD_AREA_GENERADORA_DESVIACION")+"'>"+res.getString("NOMBRE_AREA_GENERADORA_DESVIACION")+"</option>");
                                            }
                                    %>

                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td class="tdRight outputTextBold">Tipo de desviación</td>
                            <td><b>::</b></td>
                            <td>
                                <select id="codTipoDesviacion" name="codTipoDesviacion" class="inputText chosen" style="width:300px">
                                    <%
                                            consulta = "SELECT crd.COD_CLASIFICACION_RIESGO_DESVIACION, crd.NOMBRE_CLASIFICACION_RIESGO_DESVIACION"
                                                    +" FROM CLASIFICACION_RIESGO_DESVIACION crd"
                                                    +" order by crd.NOMBRE_CLASIFICACION_RIESGO_DESVIACION";
                                            st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                                            res =st.executeQuery(consulta);
                                            out.println("<option value='0'>--TODOS--</option>");
                                            while(res.next()){
                                                out.println("<option value='"+res.getInt("COD_CLASIFICACION_RIESGO_DESVIACION")+"'>"+res.getString("NOMBRE_CLASIFICACION_RIESGO_DESVIACION")+"</option>");
                                            }
                                        }
                                        catch(Exception e){
                                            e.printStackTrace();
                                        }
                                        finally{
                                            con.close();
                                        }
                                    %>

                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="3" style="text-align:center">
                                <a class="btn" onclick="verReporte()">VER REPORTE</a>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </form>
        <script src="../../../js/chosen.js"></script>
    </body>
</html>

