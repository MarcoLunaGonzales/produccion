
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
                var url = "reportePersonalDetectorGenerador.jsf?fechaInicioDetecta="+document.getElementById("fechaInicioDetecta").value
                                                        +"&fechaFinDetecta="+document.getElementById("fechaFinDetecta").value
                                                        +"&fechaInicioEnvio="+document.getElementById("fechaInicioEnvio").value
                                                        +"&fechaFinEnvio="+document.getElementById("fechaFinEnvio").value
                                                        +"&codPersonalDetecta="+document.getElementById("codPersonalDetecta").value
                                                        +"&codPersonalEnvia="+document.getElementById("codPersonalEnvia").value
                                                        +"&codAreaDetectora="+document.getElementById("codAreaDetectora").value
                                                        +"&codAreaGeneradora="+document.getElementById("codAreaGeneradora").value;
                abrirVentana(url);
            }
        </script>
    </head>
    <body>
        <h4 align="center">REPORTE DE DESVIACIONES POR PERSONAL DETECTOR - GENERADOR</h4>
        <form id="form1">
            <div align="center">
                <table border="0" class="tablaFiltroReporte" style="border:1px solid #000000" cellspacing="2" cellpadding="3">   
                    <thead>
                        <tr>
                            <td  colspan="6" >
                                <div class="outputText2" align="center">
                                Introduzca los Parámetros del Reporte
                                </div> 
                            </td>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td class="tdRight outputTextBold">Personal que detecta</td>
                            <td><b>::</b></td>
                            <td colspan="4">
                                <select id="codPersonalDetecta" name="codPersonalDetecta" class="inputText chosen" style="width:300px">
                                    <%                                    
                                        Connection con = null;

                                        try {
                                            con = Util.openConnection(con);
                                            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                                            String consulta = "select p.COD_PERSONAL, (p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL+' '+p.nombre2_personal) as NOMBRE_COMPLETO"                                                            +" from PERSONAL p"
                                                            +" where p.COD_ESTADO_PERSONA = 1"
                                                            +" order by (p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL)";
                                            ResultSet res =st.executeQuery(consulta);
                                            out.println("<option value='0'>--TODOS--</option>");
                                            while(res.next()){
                                                out.println("<option value='"+res.getInt("COD_PERSONAL")+"'>"+res.getString("NOMBRE_COMPLETO")+"</option>");
                                            }

                                    %>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td class="tdRight outputTextBold">Fecha Detección</td>
                            <td><b>::</b></td>
                            <td>
                              Inicio  
                            </td>
                            <td>
                                <input type="text"  size="12"  value="" id="fechaInicioDetecta" name="fechaInicioDetecta" class="dlCalendar">

                            </td>
                            <td>
                              Fin 
                            </td>
                            <td>
                                <input type="text"  size="12"  value="" id="fechaFinDetecta" name="fechaFinDetecta" class="dlCalendar">                          
                            </td>
                        </tr>
                        <tr>
                            <td class="tdRight outputTextBold">Personal que envía</td>
                            <td><b>::</b></td>
                            <td colspan="4">
                                <select id="codPersonalEnvia" name="codPersonalEnvia" class="inputText chosen" style="width:300px">
                                    <%                                    
                                            consulta = "select p.COD_PERSONAL, (p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL+' '+p.nombre2_personal) as NOMBRE_COMPLETO"                                                            +" from PERSONAL p"
                                                            +" where p.COD_ESTADO_PERSONA = 1"
                                                            +" order by (p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL)";
                                            res =st.executeQuery(consulta);
                                            out.println("<option value='0'>--TODOS--</option>");
                                            while(res.next()){
                                                out.println("<option value='"+res.getInt("COD_PERSONAL")+"'>"+res.getString("NOMBRE_COMPLETO")+"</option>");
                                            }

                                    %>
                                </select>
                            </td>
                        </tr>
                        <tr >
                            <td class="tdRight outputTextBold">Fecha Envío</td>
                            <td><b>::</b></td>
                            <td>
                              Inicio  
                            </td>
                            <td>
                                <input type="text"  size="12"  value="" id="fechaInicioEnvio" name="fechaInicioEnvio" class="dlCalendar">
                            </td>
                            <td>
                              Fin 
                            </td>
                            <td>
                                <input type="text"  size="12"  value="" id="fechaFinEnvio" name="fechaFinEnvio" class="dlCalendar">                        
                            </td>
                        </tr>
                        <tr>
                            <td class="tdRight outputTextBold">Area detectora</td>
                            <td><b>::</b></td>
                            <td colspan="4">
                                <select id="codAreaDetectora" name="codAreaDetectora" class="inputText chosen" style="width:300px">
                                    <%                                    
                                        consulta = "select ae.COD_AREA_EMPRESA, ae.NOMBRE_AREA_EMPRESA"
                                                                +" from AREAS_EMPRESA ae"
                                                                +" where ae.COD_ESTADO_REGISTRO = 1  "
                                                                +" order by ae.NOMBRE_AREA_EMPRESA";
                                            res =st.executeQuery(consulta);
                                            out.println("<option value='0'>--TODOS--</option>");
                                            while(res.next()){
                                                out.println("<option value='"+res.getInt("COD_AREA_EMPRESA")+"'>"+res.getString("NOMBRE_AREA_EMPRESA")+"</option>");
                                            }

                                    %>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td class="tdRight outputTextBold">Area generadora</td>
                            <td><b>::</b></td>
                            <td colspan="4">
                                <select id="codAreaGeneradora" name="codAreaGeneradora" class="inputText chosen" style="width:300px">
                                    <%
                                            consulta = "SELECT agd.COD_AREA_GENERADORA_DESVIACION, agd.NOMBRE_AREA_GENERADORA_DESVIACION"
                                                        +" FROM AREAS_GENERADORAS_DESVIACION agd"
                                                        +" where agd.COD_ESTADO_REGISTRO =1"
                                                        +" order by agd.NOMBRE_AREA_GENERADORA_DESVIACION";
                                            st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                                            res =st.executeQuery(consulta);
                                            out.println("<option value='0'>--TODOS--</option>");
                                            while(res.next()){
                                                out.println("<option value='"+res.getInt("COD_AREA_GENERADORA_DESVIACION")+"'>"+res.getString("NOMBRE_AREA_GENERADORA_DESVIACION")+"</option>");
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
                            <td colspan="6" style="text-align:center">
                                <a class="btn" onclick="verReporte()">VER REPORTE</a>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </form>
        <script src="../../../js/chosen.js"></script>                            
        <script type="text/javascript" language="JavaScript"  src="../../../js/dlcalendar.js"></script>
        
    </body>
</html>

