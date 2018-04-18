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


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
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
             /****************** NUEVO AJAX ********************/
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
            function buscarHojasLote()
            {
                
                ajax=nuevoAjax();
                var div_lotes=document.getElementById("divLotes");
                var lote=document.getElementById("lote").value;
                ajax.open("GET","ajaxLotes.jsf?lote="+lote+"&dATA="+(new Date()).getTime().toString(),true);
                ajax.onreadystatechange=function(){
                    if (ajax.readyState==4) {
                        div_lotes.innerHTML=ajax.responseText;
                    }
                }

                ajax.send(null);

            }
            function verReporte(codCompProd,codHoja,codProgramaProd,codLote,codReceta,codForma)
            {
                var urlHoja='';
                switch(codHoja)
                {
                    case 1:urlHoja='reporteLimpiezaAmbiente.jsf';
                           break;
                    case 2:urlHoja='reporteRepesada.jsf';
                           break;
                    case 3:urlHoja=(codForma==2?'reporteLavado.jsf':'reporteLavadoColirios.jsf');
                           break;
                    case 4:urlHoja='reporteDespirogenizado.jsf';
                           break;
                    case 5:urlHoja='reportePreparado.jsf';
                           break;
                    case 6:urlHoja=(codForma==2?'reporteDosificado.jsf':'reporteDosificadoColirios.jsf');
                           break;
                    case 7:urlHoja=(codForma==2?'reporteControlLLenadoVolumen.jsf':'reporteControlPeso.jsf');
                           break;
                    case 8:urlHoja=(codForma==2?'reporteControlDosificado.jsf':'reporteControlDosificadoColirios.jsf');
                           break;
                    case 9:urlHoja='reporteRendimientoDosificado.jsf';
                           break;
                    case 10:urlHoja='reporteEsterilizacionCalorHumedo.jsf';
                           break;
                    case 11:urlHoja='reporteGeneral.jsf';
                           break;
                    case 12:urlHoja='reporteGrafadoFrascos.jsf';
                           break;
                    default:urlHoja='';
                           break;
                }
                urlHoja='hojasOM/'+urlHoja+"?codCompProd="+codCompProd+"&codLote="+codLote+"&codProgramaProd="+codProgramaProd+
                    "&data="+(new Date()).getTime().toString()+"&codReceta="+codReceta+"&imp=0&codForma="+codForma;
                
                window.open(urlHoja,('hoja'+(new Date()).getTime().toString()),'top=50,left=200,width=800,height=500,scrollbars=1,resizable=1');
                
            }
        </script>
        <style>
            .tablaDetalle
            {
                padding:0.5em;
            }
            .tablaDetalle thead tr td
            {
                background-color:rgb(157, 90, 158);
            }
            .tablaDetalle tbody tr td
            {
                border-bottom:solid #666666 1px;
                border-left:solid #666666 1px;
                padding:5px;
                background-color:#f2f2f2;
                text-align:center;
            }
        </style>
    </head>
    <body><br><br>
        <h3 align="center">Impresion de Hojas OM(LIQUIDOS ESTERILES)</h3>

        <form id="form1" method="post" action="reporteControlCalidad.jsp" target="_blank">
            <div align="center">
                <table border="0"  border="0" class="tablaFiltroReporte" width="50%">
                    <tr class="headerClassACliente">
                        <td  colspan="3" >
                            <div class="outputText3" align="center">
                                Introduzca Datos
                            </div>
                        </td>

                    </tr>
                    <tr>
                        <td class="outputText2">Lote</td>
                        <td class="outputText2">:</td>
                        <td><input value="" class="inputText" type="text" id="lote"/> </td>
                        
                    </tr>
                    <tr>
                        <td colspan="3"><center><input type="button" class="btn" value="BUSCAR" onclick="buscarHojasLote()"/>
                        </center></td>
                        
                    </tr>
                    <tr class="outputText3">
                        <td colspan="3"><div id="divLotes" style="height:200px;overflow:auto;"></div>
                        </td>
                    </tr>
                  
                </table>

            </div>
            <br>
            <center>
                <input type="button"   class="btn" size="35" value="Ver Reporte" onclick="verReporte(form1)" name="reporte" >
                <input type="hidden" name="codLote" id="codLote">
                <input type="hidden" name="codProd" id="codProd">
            </center>
        </form>
        <script type="text/javascript" language="JavaScript"  src="../js/dlcalendar.js"></script>
    </body>
</html>