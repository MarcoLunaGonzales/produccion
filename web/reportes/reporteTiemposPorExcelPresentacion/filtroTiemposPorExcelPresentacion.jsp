<html>
<%@ page language="java"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.cofar.util.*" %>
<%@ page import="com.cofar.web.*" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>




    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
        <title>
            Reporte Formula Maestra
         </title>
        <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
        <script type="text/javascript">
            function mandar()
            {
                upform.action="reporteTiemposPorExcelPresentacion.jsp";
                upform.submit();
            }
        </script>
    </head>
    
    <body>
        
        <form method="post" action="reporteTiemposPorExcelPresentacion.jsf" name="upform" target="_blank" enctype="multipart/form-data" >
            
            <div align="center">
                <h4 align="center">Reporte De Tiempos por Excel</h4>
                
                <table border="0"  border="0" class="tablaFiltroReporte"  style="border:1px solid #000000"  cellspacing="0">    
                    <thead>
                        <tr>
                            <td colspan="3" >Filtro Reporte De Tiempos por Presentación</td>
                        </tr>    
                    </thead>
                    <tbody>
                        <tr class="outputText3">
                            <td>&nbsp;&nbsp;<b>Adjuntar Archivo</b></td>
                             <td  class="border">
                                <input type="file" name="uploadfile" size="50" />
                                <input type="hidden" name="todo" value="upload"/>                              
                            </td>
                        </tr>
                    </tbody>
                    <tfoot>
                        <tr>
                        <td class="tdCenter" colspan="3">
                                    <a type="button" class="btn" name="reporte" onclick="mandar();"><span>Ver Reporte</span></a>                
                                    <input type="reset"   class="btn"  value="Limpiar" name="limpiar">
                            </td>
                        </tr>
                    </tfoot>
                    
                </table>
            </div>
            
            
        </form>
        <script type="text/javascript" language="JavaScript"  src="../js/dlcalendar.js"></script>
    </body>
</html>

