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
        <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
        <script src="../js/general.js"></script>
        <style>
            .tablaFormaReporte
            {
                border-top: 1px solid #cccccc;
                border-left: 1px solid #cccccc;
            }
            .tablaFormaReporte thead tr td
            {
                background-color: rgb(157, 90, 158);
                font-weight: bold;
                color: white;
                text-align: center;
            }
            .tablaFormaReporte tr td
            {
                border-bottom: 1px solid #cccccc;
                border-right: 1px solid #cccccc;
                padding: 3px;
            }
        </style>
        <script type="text/javascript">
            function verReporte(codGrupoForma)
            {
                   window.open("reporteEspecificacionesCC2015.jsf?codGrupoForma="+codGrupoForma+"&data="+(new Date()).getTime().toString(),'detalle'+Math.round((Math.random()*1000)),'top=50,left=200,width=800,height=600,scrollbars=1,resizable=1');
            }
        </script>
    </head>
    <body><br><br>
        <h3 align="center">Especificaciones de Productos </h3>

        <form method="post" action="reporteProgramaProduccionEstados.jsp" target="_blank" name="form1">
            <div align="center">
                <table class="outputText2 tablaFormaReporte" width="50%" cellpadding="0" cellspacing="0">
                    <thead>
                        <tr>
                            <td>&nbsp</td>
                            <td>Reporte</td>
                        </tr>
                    </thead>

                    <tr>
                        <td>CAPSULAS</td>
                        <td align="center"><img onclick="verReporte(1)" src="../../img/pdf.jpg" style="cursor:hand"/></td>
                    </tr>
                    <tr>
                        <td >COMPRIMIDOS</td>
                        <td align="center"><img onclick="verReporte(2)" src="../../img/pdf.jpg" style="cursor:hand"/></td>
                    </tr>
                    <tr>
                        <td>GRANULADOS</td>
                        <td align="center"><img onclick="verReporte(3)" src="../../img/pdf.jpg" style="cursor:hand"/></td>
                    </tr>
                    <tr>
                        <td>INYECTABLES</td>
                        <td align="center"><img onclick="verReporte(4)" src="../../img/pdf.jpg" style="cursor:hand"/></td>
                    </tr>
                    <tr>
                        <td>LIQUIDOS NO ESTERILES</td>
                        <td align="center"><img onclick="verReporte(5)" src="../../img/pdf.jpg" style="cursor:hand"/></td>
                    </tr>
                    <tr>
                        <td>OFTALMICOS</td>
                        <td align="center"><img onclick="verReporte(6)" src="../../img/pdf.jpg" style="cursor:hand"/></td>
                    </tr>
                    <tr>
                        <td>SEMISOLIDOS</td>
                        <td align="center"><img onclick="verReporte(7)" src="../../img/pdf.jpg" style="cursor:hand"/></td>
                    </tr>
                    <tr>
                        <td>SUSPERSIÓN EXTEMPORANEA</td>
                        <td align="center"><img onclick="verReporte(8)" src="../../img/pdf.jpg" style="cursor:hand"/></td>
                    </tr>
                        
                </table>

            </div>
            <br>

        </form>
    </body>
</html>