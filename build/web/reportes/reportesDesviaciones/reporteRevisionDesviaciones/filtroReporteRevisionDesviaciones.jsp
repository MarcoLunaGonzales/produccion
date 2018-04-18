
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
                var url = "reporteRevisionDesviaciones.jsf?fechaInicioEnvio="+document.getElementById("fechaInicioEnvio").value
                                                        +"&fechaFinEnvio="+document.getElementById("fechaFinEnvio").value
                                                        +"&codPersonalAsignado="+document.getElementById("codPersonalAsignado").value
                                                        +"&fechaInicioLimiteRevision="+document.getElementById("fechaInicioLimiteRevision").value
                                                        +"&fechaFinLimiteRevision="+document.getElementById("fechaFinLimiteRevision").value
                                                        +"&fechaInicioRevision="+document.getElementById("fechaInicioRevision").value
                                                        +"&fechaFinRevision="+document.getElementById("fechaFinRevision").value
                                                        +"&codPersonalRevisor="+document.getElementById("codPersonalRevisor").value
                                                        +"&codEstadoDesviacion="+document.getElementById("codEstadoDesviacion").value;
                abrirVentana(url);
            }
        </script>
    </head>
    <body>
        <h4 align="center">REPORTE DE DESVIACIONES POR REVISIÓN</h4>
        <form id="form1">
            <div align="center">
                <table border="0" class="outputText2" style="border:1px solid #000000" cellspacing="2" cellpadding="3">   
                    <tr class="headerClassACliente">
                        <td  colspan="6" >
                            <div class="outputText2" align="center">
                            Introduzca los Parámetros del Reporte
                            </div> 
                        </td>
                    </tr>     
                    <tr >
                        <td class="tdRight outputTextBold">Fecha de envío</td>
                        <td class="outputTextBold">::</td>
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
                        <td class="tdRight outputTextBold">Usuario asignado</td>
                        <td class="outputTextBold">::</td>
                        <td colspan="4">
                            <select id="codPersonalAsignado" name="codPersonalAsignado" class="inputText chosen" style="width:300px">
                                <%                                    
                                    Connection con = null;
                                    
                                    try {
                                        con = Util.openConnection(con);
                                        Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                                        String consulta = "select p.COD_PERSONAL, (p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL+' '+p.nombre2_personal) as NOMBRE_COMPLETO"
                                                +" from PERSONAL p"
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
                        <td class="tdRight outputTextBold">Fecha límite de revisión</td>
                        <td class="outputTextBold">::</td>
                        <td>Inicio</td>
                        <td>
                            <input type="text"  size="12"  value="" id="fechaInicioLimiteRevision" name="fechaInicioLimiteRevision" class="dlCalendar">
                        </td>
                        <td>Fin</td>
                        <td>
                            <input type="text"  size="12"  value="" id="fechaFinLimiteRevision" name="fechaFinLimiteRevision" class="dlCalendar">
                        </td>
                    </tr>
                    <tr>
                        <td class="tdRight outputTextBold">Fecha de revisión de ususarios</td>
                        <td class="outputTextBold">::</td>
                        <td>Inicio</td>
                        <td>
                            <input type="text"  size="12"  value="" id="fechaInicioRevision" name="fechaInicioRevision" class="dlCalendar">
                        </td>
                        <td>Fin</td>
                        <td>
                            <input type="text"  size="12"  value="" id="fechaFinRevision" name="fechaFinRevision" class="dlCalendar">
                        </td>
                    </tr>
                    <tr>
                        <td class="tdRight outputTextBold">Usuario revisor</td>
                        <td class="outputTextBold">::</td>
                        <td colspan="4">
                            <select id="codPersonalRevisor" name="codPersonalRevisor" class="inputText chosen" style="width:300px">
                                <%       
                                        consulta = "select p.COD_PERSONAL, (p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL+' '+p.nombre2_personal) as NOMBRE_COMPLETO"
                                                +" from PERSONAL p"
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
                    <tr>
                        <td class="tdRight outputTextBold">Estatus (en fecha vencido)</td>
                        <td class="outputTextBold">::</td>
                        <td colspan="4">
                            <select id="codEstadoDesviacion" name="codEstadoDesviacion" class="inputText chosen" style="width:300px">
                                <%
                                        consulta = "select ed.COD_ESTADO_DESVIACION, ed.NOMBRES_ESTADO_DESVIACION "
                                                +" from ESTADOS_DESVIACION ed"
                                                +" where ed.COD_ESTADO_REGISTRO = 1"
                                                +" order by ed.NOMBRES_ESTADO_DESVIACION";
                                        st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                                        res =st.executeQuery(consulta);
                                        out.println("<option value='0'>--TODOS--</option>");
                                        while(res.next()){
                                            out.println("<option value='"+res.getInt("COD_ESTADO_DESVIACION")+"'>"+res.getString("NOMBRES_ESTADO_DESVIACION")+"</option>");
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
                </table>
            </div>
        </form>
        <script src="../../../js/chosen.js"></script>                        
        <script type="text/javascript" language="JavaScript"  src="../../../js/dlcalendar.js"></script>
    </body>
</html>

