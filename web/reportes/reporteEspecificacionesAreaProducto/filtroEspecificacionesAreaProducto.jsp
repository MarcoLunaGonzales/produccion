

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

<%! Connection con = null;
%>



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

function nuevoAjax()
            {	var xmlhttp=false;
                try {
                        xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
                    } catch (e) {
                    try {
 			xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
                    } catch (E) {
                        	xmlhttp = false;
                    }
                    }
                    if (!xmlhttp && typeof XMLHttpRequest!="undefined") {
                       xmlhttp = new XMLHttpRequest();
                    }
                    return xmlhttp;
            }

            function selecccionarTodo(f){
                for(var i=0;i<=f.codAreaEmpresa.options.length-1;i++)
                {
                    f.codAreaEmpresa.options[i].selected=f.chk_todoTipo.checked;
                }
                ajaxProductos(f);
            }

           
            function filtraPorCodigoProgramaProduccion(codProgramaProduccionPeriodo){
                // var codigo=f.codAreaEmpresa.value;
                
                location.href="filtroReporteSeguimientoProgramaProduccion.jsf?codProgramaProduccionPeriodo="+codProgramaProduccionPeriodo;
            }

       function verReporte(f)
       {
        var arrayCodArea=new Array();
        var arrayNomArea=new Array();
        var j=0;
        for(var i=0;i<=f.codAreaEmpresa.options.length-1;i++)
        {	if(f.codAreaEmpresa.options[i].selected)
            {	arrayCodArea[j]=f.codAreaEmpresa.options[i].value;
                arrayNomArea[j]=f.codAreaEmpresa.options[i].innerHTML;
                j++;
            }
        }
        f.codArea.value=arrayCodArea;
        f.nombreArea.value=arrayNomArea;
        f.codProd.value=f.codCompProd.value;
        f.action="reporteEspecificacionesAreaProducto.jsf";
        f.submit();
        }
        function ajaxProductos(f)
        {
            var arrayCodArea=new Array();
            
            var j=0;
            for(var i=0;i<=f.codAreaEmpresa.options.length-1;i++)
            {	if(f.codAreaEmpresa.options[i].selected)
                {	
                    arrayCodArea[j]=f.codAreaEmpresa.options[i].value;
                    j++;
                }
            }
             var div_producto=document.getElementById("divProducto");
                
                ajax=nuevoAjax();
                ajax.open("GET","ajaxProducto.jsf?codArea="+arrayCodArea,true);
                ajax.onreadystatechange=function(){
                    if (ajax.readyState==4) {
                        div_producto.innerHTML=ajax.responseText;
                    }
                }
                ajax.send(null)
                return(true);
        }
        </script>



    </head>
    <body><br><br>
        <h3 align="center">Reporte de especificaciones por Area</h3>

        <form method="post" action="navegadorReporteProgramaProduccion.jsp" target="_blank" name="form1">
            <div align="center">
                <table border="0"  border="0" class="border" width="50%">
                    <tr class="headerClassACliente">
                        <td  colspan="3" >
                            <div class="outputText3" align="center">
                                Introduzca Datos
                            </div>
                        </td>

                    </tr>

                    <tr class="outputText3">
                        <td class="">Area Empresa</td>
                        <td class="">::</td>
                        <%
           
                       try {
                        con = Util.openConnection(con);
                        System.out.println("con:::::::::::::" + con);
                        Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);




                        String sql = "select ae.COD_AREA_EMPRESA,ae.NOMBRE_AREA_EMPRESA from AREAS_EMPRESA ae where ae.COD_AREA_EMPRESA in ("+
                                     " select cp.COD_AREA_EMPRESA from COMPONENTES_PROD cp )";
                        System.out.println("sql filtro:" + sql);
                        ResultSet rs = st.executeQuery(sql);
                        %>
                        <td class="">
                            <div>
                            <select name="codAreaEmpresa" class="outputText3" style="" multiple onchange="ajaxProductos(form1)">
                                <%
                           String codAreaEmpresa="";
                           String nombreAreaEmpresa="";
                            while (rs.next()) {
                                codAreaEmpresa = rs.getString("COD_AREA_EMPRESA");
                                nombreAreaEmpresa = rs.getString("NOMBRE_AREA_EMPRESA");
                                out.print("<option value="+codAreaEmpresa+">"+nombreAreaEmpresa+"</option>");
                            }%>
                            </select>
                            <input type="checkbox"  onclick="selecccionarTodo(form1)" name="chk_todoTipo" >Todo
                            </div>
                            
                            <%
                            }
                            catch (Exception e) {e.printStackTrace(); }
                            %>
                        </td>
                    </tr>
                    <tr class="outputText3">
                        <td class="">Producto</td>
                        <td class="">::</td>
                        <td class="">
                            <div id="divProducto">
                            <select class="inputText" id="codCompProd">
                                <option value="0">-TODOS-</option>
                            </select>
                            </div>
                        </td>
                    </tr>

                </table>

            </div>
            <br>
            <center>
                <input type="button" class="btn"  value="Ver Reporte" name="reporte" onclick="verReporte(form1)">
                <input type="hidden" name="codigosArea" id="codigosArea">
                
            </center>
            <!--datos de referencia para el envio de datos via post-->
            <input type="hidden" name="codProgramaProduccionPeriodo">
            <input type="hidden" name="nombreProgramaProduccionPeriodo">

            <input type="hidden" name="codArea">
            <input type="hidden" name="nombreArea">

            <input type="hidden" name="codAreaEmpresaP">
            <input type="hidden" name="nombreAreaEmpresaP">
            <input type="hidden" name="codProd">
            <input type="hidden" name="hastaFechaP">



        </form>
        <script type="text/javascript" language="JavaScript"  src="../../js/dlcalendar.js"></script>
    </body>
</html>