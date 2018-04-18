<%@ page import="java.sql.*" %>
<%@ page import="com.cofar.util.*" %>
<%@ page import="com.cofar.web.*" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>

<html>
    <head>
        <link rel="STYLESHEET" type="text/css" href="../../../css/ventas.css" />
        <script src="../../../js/general.js"></script>
        
        <script type="text/javascript"> 
            function verReporte(){
                var url = "reportePorIndicador.jsf?fechaInicio="+document.getElementById("fechaInicio").value
                                                        +"&fechaFin="+document.getElementById("fechaFin").value;
                abrirVentana(url);
            }
        </script>
    </head>
    <body>
        <h4 align="center">REPORTE POR INDICADOR</h4>
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
                        <tr >
                            <td class="tdRight outputTextBold">Fecha</td>
                            <td class="outputTextBold">::</td>
                            <td>
                              Inicio  
                            </td>
                            <td>
                                <input type="text"  size="12"  value="" id="fechaInicio" name="fechaInicio" class="dlCalendar">
                            </td>
                            <td>
                              Fin 
                            </td>
                            <td>
                                <input type="text"  size="12"  value="" id="fechaFin" name="fechaFin" class="dlCalendar">
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
        <script type="text/javascript" language="JavaScript"  src="../../../js/dlcalendar.js"></script>
    </body>
</html>
