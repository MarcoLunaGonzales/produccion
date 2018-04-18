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

        <style type="text/css">
            .tituloCampo1{
                font-family: Verdana, Arial, Helvetica, sans-serif;
                font-size: 11px;
                font-weight: bold;
            }
            .outputText3{
                font-family: Verdana, Arial, Helvetica, sans-serif;
                font-size: 11px;
            }
            .inputText3{
                font-family: Verdana, Arial, Helvetica, sans-serif;
                font-size: 11px;
            }
            .commandButtonR{
                font-family: Verdana, Arial, Helvetica, sans-serif;
                font-size: 11px;
                width: 150px;
                height: 20px;
                background-repeat :repeat-x;

                background-image: url('../img/bar3.png');
            }
        </style>

        <style type="text/css">
            .tituloCampo1{
                font-family: Verdana, Arial, Helvetica, sans-serif;
                font-size: 11px;
                font-weight: bold;
            }
            .outputText3{
                font-family: Verdana, Arial, Helvetica, sans-serif;
                font-size: 11px;
            }
            .inputText3{
                font-family: Verdana, Arial, Helvetica, sans-serif;
                font-size: 11px;
            }
            .commandButtonR{
                font-family: Verdana, Arial, Helvetica, sans-serif;
                font-size: 11px;
                width: 150px;
                height: 20px;
                background-repeat :repeat-x;

                background-image: url('../img/bar3.png');
            }
        </style>

        <script >
        function enviaProgramaProduccion(f)
        {
            var arrayCodProgramaProd=new Array();
            var arrayNombreProgramaProd=new Array();
            for(var i=0;i<=f.codProgramaProdPeriodo.options.length-1;i++)
            {
                if(f.codProgramaProdPeriodo.options[i].selected)
                {
                    arrayCodProgramaProd.push(f.codProgramaProdPeriodo.options[i].value);
                    arrayNombreProgramaProd.push(f.codProgramaProdPeriodo.options[i].innerHTML);
                }
            }
            if(arrayCodProgramaProd.length==0&&document.getElementById("codLoteProduccion").value.length==0)
            {
                alert('Debe seleccionar un programa de produccion o introducir un numero de lote para el reporte');
                return false;
            }
            else
            {
                f.nombreEstadoProgramaProduccion.value=document.getElementById("codEstadoProgramaProd").options[document.getElementById("codEstadoProgramaProd").selectedIndex].innerHTML;
                f.codProgramaProduccionPeriodo.value=arrayCodProgramaProd;
                f.nombreProgramaProduccionPeriodo.value=arrayNombreProgramaProd;
                f.action="reporteInformacionLote.jsf";
                f.submit();
            }
        }
        function onchangeCodEstadoProgramaProd()
        {
            document.getElementById("inputCheckFechaCambio").checked=false;
            if(parseInt(document.getElementById("codEstadoProgramaProd").value)==0)
                document.getElementById("checkFechaCambioEstado").style.display='none';
            else
                document.getElementById("checkFechaCambioEstado").style.display='';
        }
        function onChangeCheckFechaCambio()
        {
            if(document.getElementById("inputCheckFechaCambio").checked)
            {
                document.getElementById("fechaIniCambioEstado").style.display='';
                document.getElementById("fechaFinCambioEstado").style.display='';
            }
            else
            {
                document.getElementById("fechaIniCambioEstado").style.display='none';
                document.getElementById("fechaFinCambioEstado").style.display='none';
            }    
                
                
        }
        document.onload=function()
        {
            document.getElementById("inputCheckFechaCambio").checked=false;
            document.getElementById("codEstadoProgramaProd").value=0;
        }
        </script>



    </head>
    <body >
        <span class="outputTextTituloSistema">Reporte Información del Lote</span>

        <form method="post" action="reporteProgramaProduccionEstados.jsp" target="_blank" name="form1">
            <div align="center">
                <table border="0"  border="0" cellpadding="0" cellspacing="0" class="tablaFiltroReporte" width="50%">
                    <thead>
                        <tr>
                            <td  colspan="3" >Introduzca Datos</td>
                        </tr>
                    </thead>
                    <tbody>
                        <tr class="outputText3">
                            <td class="outputTextBold">Programa de Producción</td>
                            <td class="outputTextBold">::</td>
                            <td class="">
                                <select name="codProgramaProdPeriodo" class="inputText"  multiple="true" style="height:200px">
                            <%
                                Connection con=null;
                                try
                                {
                                    String codProgramaProduccionPeriodoReq ="";
                                    if(request.getParameter("codProgramaProduccionPeriodo")!=null)
                                    {
                                        codProgramaProduccionPeriodoReq = request.getParameter("codProgramaProduccionPeriodo");
                                    }
                                    con = Util.openConnection(con);
                                    Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);            
                                    StringBuilder consulta =new StringBuilder("SELECT PP.COD_PROGRAMA_PROD,PP.NOMBRE_PROGRAMA_PROD,PP.OBSERVACIONES");
                                                                    consulta.append(",(SELECT EP.NOMBRE_ESTADO_PROGRAMA_PROD FROM ESTADOS_PROGRAMA_PRODUCCION EP WHERE EP.COD_ESTADO_PROGRAMA_PROD = PP.COD_ESTADO_PROGRAMA)");
                                                            consulta.append(" FROM PROGRAMA_PRODUCCION_PERIODO PP");
                                                            consulta.append(" WHERE PP.COD_ESTADO_PROGRAMA<>4 and pp.cod_tipo_produccion=1");
                                    ResultSet res = st.executeQuery(consulta.toString());
                                    while (res.next()) 
                                    {
                                        out.print("<option value="+res.getInt("COD_PROGRAMA_PROD")+" >"+res.getString("NOMBRE_PROGRAMA_PROD")+"</option>");
                                    }
                                    
                                }
                                catch(Exception ex)
                                {
                                    ex.printStackTrace();
                                }
                                finally
                                {
                                    con.close();
                                }
                                SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy");
                                    %>
                                
                                </select>
                            </td>
                        </tr>

                        <tr class="outputText3">
                            <td class="outputTextBold">Estado Programa de Producción</td>
                            <td class="outputTextBold">::</td>
                            <td class="">
                                <select id="codEstadoProgramaProd" name="codEstadoProgramaProd" class="inputText" onchange="onchangeCodEstadoProgramaProd()">
                                    <option value=0 selected>--TODOS--</option>
                                    <option value=1>EN PROCESO PRODUCCION</option>
                                    <option value=2>TERMINADO PRODUCCION</option>
                                    <option value=3>TERMINADO ACONDICIONAMIENTO</option>
                                </select>

                            </td>
                        </tr>
                        <tr style="display: none" id="checkFechaCambioEstado">
                            <td class="outputTextBold" >Filtrar por Fecha de Cambio de Estado</td>
                            <td class="outputTextBold">::</td>
                            <td><input type="checkbox" name="checkFechaCambio" id="inputCheckFechaCambio" onclick="onChangeCheckFechaCambio()"/></td>
                        </tr>
                        <tr style="display: none" id="fechaIniCambioEstado">
                            <td class="outputTextBold" >Fecha Inicio Cambio Estado</td>
                            <td class="outputTextBold">::</td>
                            <td>
                                <input value="<%=(sdf.format(new Date()))%>" type="text" id="fechaInicioReporte" name="fechaInicioReporte" class="inputText"/>
                                <img id="imagenFechaInicio" src="../../img/fecha.bmp">
                                <DLCALENDAR tool_tip="Seleccione la Fecha"
                                            daybar_style="background-color: DBE1E7;
                                            font-family: verdana; color:000000;"navbar_style="background-color: 7992B7; color:ffffff;"
                                            input_element_id="fechaInicioReporte" click_element_id="imagenFechaInicio">
                                </DLCALENDAR>
                            </td>
                        </tr>
                        <tr style="display: none" id="fechaFinCambioEstado">
                            <td class="outputTextBold" >Fecha Final Cambio Estado</td>
                            <td class="outputTextBold">::</td>
                            <td>
                                <input value="<%=(sdf.format(new Date()))%>" id="fechaFinalReporte" name="fechaFinalReporte" type="text" class="inputText"/>
                                <img id="imagenFechaFinal" src="../../img/fecha.bmp">
                                <DLCALENDAR tool_tip="Seleccione la Fecha"
                                            daybar_style="background-color: DBE1E7;
                                            font-family: verdana; color:000000;"navbar_style="background-color: 7992B7; color:ffffff;"
                                            input_element_id="fechaFinalReporte" click_element_id="imagenFechaFinal">
                                </DLCALENDAR>
                            </td>
                        </tr>
                        <tr >
                            <td class="outputTextBold" >Lote</td>
                            <td class="outputTextBold">::</td>
                            <td><input type="text" name="codLoteProduccion" id="codLoteProduccion" class="inputText"/></td>
                        </tr>
                        <tr>
                            <td colspan="3" align="center">
                                <a class="btn" onclick="enviaProgramaProduccion(form1)">Ver Reporte</button>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <input type="hidden" name="codProgramaProduccionPeriodo">
            <input type="hidden" name="nombreProgramaProduccionPeriodo">
            <input type="hidden" name="nombreEstadoProgramaProduccion">
            <script type="text/javascript" language="JavaScript"  src="../../js/dlcalendar.js"></script>
        </form>
    </body>
</html>