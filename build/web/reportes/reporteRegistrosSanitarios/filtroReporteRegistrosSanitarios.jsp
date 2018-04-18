

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


<html>
    <head>
        <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
        <script src="../../js/general.js"></script>
        <script>
            var cod=0;
            function openPopup1(url1)
            {

                izquierda = (screen.width) ? (screen.width-300)/2 : 100
                arriba = (screen.height) ? (screen.height-400)/2 : 200
                var url=url1+'&codP='+Math.random();
                 opciones='toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,width=700,height=400,left='+izquierda+ ',top=' + arriba + ''
                 cod++;
                window.open(url,('popUp'+cod),opciones)

            }
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
            function buscarComponentesProd()
            {
                
                ajax=nuevoAjax();
                var url="ajaxComponentesProd.jsf?nombreProducto="+document.getElementById("nombreProducto").value+
                                                "&noTemp="+(new Date()).getTime().toString();
                ajax.open("GET",url,true);
                ajax.onreadystatechange=function()
                {
                    if (ajax.readyState==4) {
                        document.getElementById("divProductos").innerHTML=ajax.responseText;
                    }
                }

                ajax.send(null);

            }
            function verReporte(f){

                   var count=0;
                   var elements=document.getElementById('dataLote');
                   var rowsElement=elements.rows;
                   var codLote="ninguno";
                   for(var i=1;i<rowsElement.length;i++){
                       
                    var cellsElement=rowsElement[i].cells;
                    var cel=cellsElement[0];
                    if(cel.getElementsByTagName('input').length>0)
                        {
                            if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                                //alert(cel.getElementsByTagName('input')[0].checked);
                                  if(cel.getElementsByTagName('input')[0].checked){
                                   codLote=cellsElement[1].getElementsByTagName("span")[0].innerHTML;
                                   f.codForma.value=cellsElement[1].getElementsByTagName("input")[0].value;
                                   f.codProd.value=cellsElement[2].getElementsByTagName("input")[0].value;
                                   count++;
                                 }

                             }
                        }

                   }
                  
                    
                  if(count==1){
                      f.codLote.value=codLote;
                      f.submit();
                      return true;
                   } else if(count==0){
                       alert('No escogio ningun registro');
                       return false;
                   }
                   else if(count>1){
                       alert('Solo puede escoger un registro');
                       return false;
                   }
                   form1.submit();

                }

        </script>
        <style>
            .tablaReporte
            {
                font-family: Verdana, Arial, Helvetica, sans-serif;
                border-left:1px solid #bbbbbb;
                border-top:1px solid #bbbbbb;
                font-family: Verdana, Arial, Helvetica, sans-serif;
                font-size: 11px;
            }
            .tablaReporte tr td
            {
                border-bottom:1px solid #bbbbbb;
                border-right:1px solid #bbbbbb;
                padding: 0.6em;
            }
            .tablaReporte thead tr td
            {
                font-weight: bold;
                background-color:#dddddd;
            }
        </style>
    </head>
    <body>
        <h3 align="center">Registros Sanitarios</h3>

        <form id="form1">
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
                        <td class="outputTextBold">Producto</td>
                        <td class="outputTextBold">::</td>
                        <td><input value="" class="inputText" type="text" id="nombreProducto"/> </td>
                    </tr>
                    <tr>
                    <td colspan="3" align="center">
                            <input type="button" class="btn" value="BUSCAR" onclick="buscarComponentesProd()"/>
                        </td>
                        
                    </tr>
                    <tr class="outputText3">
                        <td colspan="3" align="center">
                            <div id="divProductos" ></div>
                        </td>
                    </tr>
                  
                </table>

            </div>
            <br>
            
        </form>
        <script type="text/javascript" language="JavaScript"  src="../js/dlcalendar.js"></script>
    </body>
</html>