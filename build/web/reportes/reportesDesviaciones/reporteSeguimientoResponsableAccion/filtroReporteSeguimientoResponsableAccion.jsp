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
                var url = "reporteSeguimientoResponsableAccion.jsf?codPersonalAsignado="+document.getElementById("codPersonalAsignado").value
                                                        +"&accionAsignada="+document.getElementById("accionAsignada").value
                                                        +"&fechaInicioAprobacion="+document.getElementById("fechaInicioAprobacion").value
                                                        +"&fechaFinAprobacion="+document.getElementById("fechaFinAprobacion").value
                                                        +"&fechaInicioCumplimiento="+document.getElementById("fechaInicioCumplimiento").value
                                                        +"&fechaFinCumplimiento="+document.getElementById("fechaFinCumplimiento").value
                                                        +"&codEstadoCapaAseguramiento="+document.getElementById("codEstadoCapaAseguramiento").value;
                abrirVentana(url);
            }
        </script>
    </head>
    <body>
        <h4 align="center">REPORTE DE DESVIACIONES POR SEGUIMIENTO DE RESPONSABLES DE ACCIONES APROBADAS</h4>
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
                            <td class="tdRight outputTextBold">Responsable asignado</td>
                            <td><b>::</b></td>
                            <td colspan="4">
                                <select id="codPersonalAsignado" name="codPersonalAsignado" class="inputText chosen" style="width:300px">
                                    <%                                    
                                        Connection con = null;

                                        try {
                                            con = Util.openConnection(con);
                                            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                                            String consulta = "select p.COD_PERSONAL, (p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL+' '+p.nombre2_personal) as NOMBRE_COMPLETO"                                                                +" from PERSONAL p"
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
                            <td class="tdRight outputTextBold">Acción asignada</td>
                            <td><b>::</b></td>
                            <td colspan="4">
                                <input id="accionAsignada" name="accionAsignada" type="text" value="" class="inputText" style="width:300px"/>
                            </td>
                        </tr>
                        <tr>
                            <td class="tdRight outputTextBold">Fecha de Aprobación</td>
                            <td><b>::</b></td>
                            <td>
                              Inicio  
                            </td>
                            <td>
                                <input type="text"  size="12"  value="" id="fechaInicioAprobacion" name="fechaInicioAprobacion" class="dlCalendar">                            
                            </td>
                            <td>
                              Fin 
                            </td>
                            <td>
                                <input type="text"  size="12"  value="" id="fechaFinAprobacion" name="fechaFinAprobacion" class="dlCalendar">
                            </td>
                        </tr>
                        <tr >
                            <td class="tdRight outputTextBold">Fecha Cumplimiento</td>
                            <td><b>::</b></td>
                            <td>
                              Inicio  
                            </td>
                            <td>
                                <input type="text"  size="12"  value="" id="fechaInicioCumplimiento" name="fechaInicioCumplimiento" class="dlCalendar">
                            </td>
                            <td>
                              Fin 
                            </td>
                            <td>
                                <input type="text"  size="12"  value="" id="fechaFinCumplimiento" name="fechaFinCumplimiento" class="dlCalendar">
                            </td>
                        </tr>
                        <tr>
                            <td class="tdRight outputTextBold">Estatus acciones del Responsable</td>
                            <td><b>::</b></td>
                            <td colspan="4">
                                <select id="codEstadoCapaAseguramiento" name="codEstadoCapaAseguramiento" class="inputText chosen" style="width:300px">
                                    <%                                    
                                            consulta = "select e.COD_ESTADO_CAPA_ASEGURAMIENTO_CALIDAD_PERSONAL_CUMPLIMIENTO,e.NOMBRE_ESTADO_CAPA_ASEGURAMIENTO_CALIDAD_PERSONAL_CUMPLIMIENTO"
                                                        +" from ESTADOS_CAPAS_ASEGURAMIENTO_CALIDAD_PERSONAL_CUMPLIMIENTO e"
                                                        +" order by e.NOMBRE_ESTADO_CAPA_ASEGURAMIENTO_CALIDAD_PERSONAL_CUMPLIMIENTO";
                                            res =st.executeQuery(consulta);
                                            out.println("<option value='0'>--TODOS--</option>");
                                            while(res.next()){
                                                out.println("<option value='"+res.getInt("COD_ESTADO_CAPA_ASEGURAMIENTO_CALIDAD_PERSONAL_CUMPLIMIENTO")+"'>"+res.getString("NOMBRE_ESTADO_CAPA_ASEGURAMIENTO_CALIDAD_PERSONAL_CUMPLIMIENTO")+"</option>");
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
