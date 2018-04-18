<%-- 
    Document   : filtroReporteComportamientoCostos
    Created on : Jul 10, 2017, 4:13:37 PM
    Author     : DASISAQ
--%>
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
<%@ page import="java.util.Date" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
        <title>JSP Page</title>
        <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
        <script src="../../js/general.js"></script>
        <script type="text/javascript">
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
            function ajaxGrupo(){
                var selectCapitulo = document.getElementById("codCapitulo");
                var arrayCodCapitulo = new Array();
                for(var i=0 ; i <= selectCapitulo.options.length - 1 ; i++)
                {
                    if(selectCapitulo.options[i].selected){
                        arrayCodCapitulo.push(selectCapitulo.options[i].value);
                    }
                }


                var div_grupo = document.getElementById("div_grupo");
                ajax=nuevoAjax();
                ajax.open("GET","ajaxGrupos.jsf?codCapitulo="+arrayCodCapitulo,true);
                ajax.onreadystatechange=function(){
                    if (ajax.readyState==4) {
                        div_grupo.innerHTML=ajax.responseText;
                    }
                }

                ajax.send(null);


            }
            function verReporte(form)
            {
                var arrayCodTipoCompra = new Array();
                var arrayNombreTipoCompra = new Array();
                for(var i = 0 ; i < form.codTipoCompra.options.length ; i++)
                {
                     if(form.codTipoCompra.options[i].selected){
                        arrayCodTipoCompra.push(form.codTipoCompra.options[i].value);
                        arrayNombreTipoCompra.push(form.codTipoCompra.options[i].innerHTML);
                    }
                }
                var arrayCodTipoTransporte  = new Array();
                var arrayNombreTipoTransporte  = new Array();
                for(var i = 0 ; i < form.codTipoTransporte.options.length ; i++)
                {
                     if(form.codTipoTransporte.options[i].selected){
                        arrayCodTipoTransporte.push(form.codTipoTransporte.options[i].value);
                        arrayNombreTipoTransporte.push(form.codTipoTransporte.options[i].innerHTML);
                    }
                }
                
                var arrayCodCapitulo = new Array();
                var arrayNombreCapitulo = new Array();
                for(var i = 0 ; i < form.codCapitulo.options.length ; i++)
                {
                     if(form.codCapitulo.options[i].selected){
                        arrayCodCapitulo.push(form.codCapitulo.options[i].value);
                        arrayNombreCapitulo.push(form.codCapitulo.options[i].innerHTML);
                    }
                }
                
                var arrayCodGrupo = new Array();
                var arrayNombreGrupo = new Array();
                for(var i = 0 ; i < form.codGrupo.options.length ; i++)
                {
                     if(form.codGrupo.options[i].selected){
                        arrayCodGrupo.push(form.codGrupo.options[i].value);
                        arrayNombreGrupo.push(form.codGrupo.options[i].innerHTML);
                    }
                }
                
                form.codTipoCompraPost.value = arrayCodTipoCompra;
                form.nombreTipoCompraPost.value = arrayNombreTipoCompra;
                form.codTipoTransportePost.value = arrayCodTipoTransporte;
                form.nombreTipoTransportePost.value = arrayNombreTipoTransporte;
                form.codCapituloPost.value = arrayCodCapitulo;
                form.nombreCapituloPost.value = arrayNombreCapitulo;
                form.codGrupoPost.value = arrayCodGrupo;
                form.nombreGrupoPost.value = arrayNombreGrupo;
                
                form.submit();
                
            }
        </script>
    </head>
    <body>
        <h3 align="center">Reporte de Comportamiento de Costos</h3>
        <form method="post" action="reporteComportamientoCostos.jsp" target="_blank" name="form1">
            <div align="center">
                <table border="0"  border="0" class="tablaFiltroReporte" cellpading="0" cellspacing="0">
                    <thead>
                        <tr >
                            <td  colspan="5" >Introduzca Datos</td>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td class="outputTextBold">Tipo Compra</td>
                            <td class="outputTextBold">::</td>
                            <td colspan="2">
                                <select multiple="true" name="codTipoCompra" size="4" class="inputText">
                                    <%
                                        Connection con = null;
                                        try {
                                            con = Util.openConnection(con);
                                            String consulta = "select tc.COD_TIPO_COMPRA,tc.NOMBRE_TIPO_COMPRA"
                                                                +" from TIPOS_COMPRA tc"
                                                                +" order by tc.NOMBRE_TIPO_COMPRA";
                                            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                                            ResultSet res =st.executeQuery(consulta);
                                            while(res.next()){
                                                out.println("<option value='"+res.getInt("COD_TIPO_COMPRA")+"'>"+res.getString("NOMBRE_TIPO_COMPRA")+"</option>");
                                            }
                                    %>

                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td class="outputTextBold">Tipo Transporte</td>
                            <td class="outputTextBold">::</td>
                            <td colspan="2">
                                <select multiple="true" name="codTipoTransporte" size="4" class="inputText">
                                    <%
                                        consulta = "select tt.COD_TIPO_TRANSPORTE,tt.NOMBRE_TIPO_TRANSPORTE"
                                                +" from TIPOS_TRANSPORTE tt"
                                                +" order by tt.NOMBRE_TIPO_TRANSPORTE";
                                        res =st.executeQuery(consulta);
                                        while(res.next()){
                                            out.println("<option value='"+res.getInt("COD_TIPO_TRANSPORTE")+"'>"+res.getString("NOMBRE_TIPO_TRANSPORTE")+"</option>");
                                        }
                                    %>

                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td class="outputTextBold">Capitulos</td>
                            <td class="outputTextBold">::</td>
                            <td colspan="2">
                                <select id="codCapitulo" name="codCapitulo" multiple size="10"  class="inputText" onchange="ajaxGrupo();">
                                <%

                                    consulta = " select c.COD_CAPITULO,c.NOMBRE_CAPITULO"
                                                + "  from CAPITULOS c"
                                                 + " where c.COD_ESTADO_REGISTRO = 1";
                                    System.out.println("consulta capitulos:" + consulta);
                                    res = st.executeQuery(consulta);
                                    while(res.next())
                                    {
                                        out.println("<option value='"+res.getInt("COD_CAPITULO")+"'>"+res.getString("NOMBRE_CAPITULO")+"</option>");
                                    }
                                }
                                catch(SQLException ex){
                                    ex.printStackTrace();
                                }
                                finally{
                                    con.close();
                                }
                                %>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td class="outputTextBold">Grupo</td>
                            <td class="outputTextBold">::</td>
                            <td colspan="2">
                                <div id="div_grupo">
                                    <select name="codGrupo" class="inputText" multiple size="10" style="width:200px;">
                                        <option value="-1">-TODOS-</option>
                                    </select>

                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td class="outputTextBold">Fecha Ingreso</td>
                            <td class="outputTextBold">::</td>
                            <td class="outputText2">De fecha</td>
                            <td>
                                <input id="fechaInicioIngreso" name="fechaInicioIngreso" class="inputText dlCalendar"/>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2"></td>
                            <td class="outputText2"> a fecha</td>
                            <td>
                                <input id="fechaFinalIngreso" name="fechaFinalIngreso" class="inputText dlCalendar"/>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="5" style="text-align:center">
                               
                                <button class="btn" onclick="verReporte(form1)">VER REPORTE</button>
                            </td>
                        </tr>
                    </tbody>
                    <input type="hidden" value="" name="codTipoCompraPost"/>
                    <input type="hidden" value="" name="nombreTipoCompraPost"/>
                    <input type="hidden" value="" name="codTipoTransportePost"/>
                    <input type="hidden" value="" name="nombreTipoTransportePost"/>
                    <input type="hidden" value="" name="codCapituloPost"/>
                    <input type="hidden" value="" name="nombreCapituloPost"/>
                    <input type="hidden" value="" name="codGrupoPost"/>
                    <input type="hidden" value="" name="nombreGrupoPost"/>
                </table>
                
            </div>
            
            <script src="../../js/dlcalendar.js"></script>
        </form>
    </body>
</html>
