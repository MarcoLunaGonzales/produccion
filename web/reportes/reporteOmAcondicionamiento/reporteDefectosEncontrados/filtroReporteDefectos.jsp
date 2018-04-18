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
<%
//con=CofarConnection.getConnectionJsp();
        con = Util.openConnection(con);

%>



<html>
    <head>
        <link rel="STYLESHEET" type="text/css" href="../../../css/ventas.css" />
        <script src="../../../js/general.js"></script>
        <script>
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
            function ajaxBuscarProductos()
            {
                var select=document.getElementById('codProgramaProd').options;
                var codProgramaProd=new Array();
                for(var i=0;i<select.length;i++)
                {
                    if(select[i].selected)
                        codProgramaProd.push(select[i].value);
                }
                var url="ajaxLotesProduccion.jsf?codCompProd="+document.getElementById("codCompProd").value+
                                    '&codProgramaProd='+codProgramaProd+
                                    '&codLote='+document.getElementById("codLoteProduccion").value+
                                    '&nocache='+(new Date()).getTime().toString();
                ajax=nuevoAjax();

                ajax.open("GET",url,true);
                ajax.onreadystatechange=function()
                {
                    if (ajax.readyState==4) 
                    {
                        document.getElementById("lotesDiv").innerHTML=ajax.responseText;
                    }
                }                
                ajax.send(null);
            }
            function seleccionTodo()
            {
                var select=document.getElementById('codProgramaProd').options;
                for(var i=0;i<select.length;i++)
                {
                    select[i].selected=document.getElementById("checktodo").checked;
                }
            }
            function seleccionarTodoProducto(input)
            {
                var tablaProducto=document.getElementById("tablaProductos").tBodies[0];
                for(var i=0;i<tablaProducto.rows.length;i++)
                {
                    tablaProducto.rows[i].cells[0].getElementsByTagName("input")[0].checked=input.checked;
                }
            }
            function openPopup(url)
            {
                   window.open(url,'detalle'+Math.round((Math.random()*1000)),'top=50,left=200,width=800,height=600,scrollbars=1,resizable=1');
            }
            function verReporteDetallado()
            {
                var tablaProducto=document.getElementById("tablaProductos").tBodies[0];
                var arrayProductos=new Array();
                for(var i=0;i<tablaProducto.rows.length;i++)
                {
                    if(tablaProducto.rows[i].cells[0].getElementsByTagName("input")[0].checked)
                        arrayProductos.push("'"+tablaProducto.rows[i].cells[1].getElementsByTagName("input")[0].value.toString()+"'");
                }
                if(arrayProductos.length==0)
                {
                    alert('Debe seleccion por lo menos un lote');
                    return null;
                }
                document.getElementById("form1").action="reporteDefectosDetallado.jsf?data="+(new Date()).getTime().toString();
                document.getElementById("codigosLotes").value=arrayProductos;
                document.getElementById("form1").submit();
            }
            function verReporteResumido()
            {
                var tablaProducto=document.getElementById("tablaProductos").tBodies[0];
                var arrayProductos=new Array();
                for(var i=0;i<tablaProducto.rows.length;i++)
                {
                    if(tablaProducto.rows[i].cells[0].getElementsByTagName("input")[0].checked)
                        arrayProductos.push("'"+tablaProducto.rows[i].cells[1].getElementsByTagName("input")[0].value.toString()+"'");
                }
                if(arrayProductos.length==0)
                {
                    alert('Debe seleccion por lo menos un lote');
                    return null;
                }
                document.getElementById("form1").action="reporteDefectosResumido.jsf?data="+(new Date()).getTime().toString();
                document.getElementById("codigosLotes").value=arrayProductos;
                document.getElementById("form1").submit();
            }

        </script>
        <style>
            .filtroReporte
            {
                border:1px solid #bbbbbb;
            }
            .filtroReporte td
            {
                padding: 4px;
            }
        </style>


    </head>
    <body>
        
        <form method="post" action="reporteDefectos.jsf" target="_blank" id="form1" name="form1">
            <center>
                <h3>Reporte de defectos encontrados</h3>
                <table class="filtroReporte" cellpadding="0" cellspacing="0">
                    <tr>
                        <td colspan="6" align="center" class="headerClassACliente">Ampollas con Defectos</td>
                    </tr>
                    <tr>
                        <td class="outputTextBold"> Programa Producción</td>
                        <td class="outputTextBold"> ::</td>
                        <td>
                            <select id="codProgramaProd" multiple size="4" >
                                <%
                                SimpleDateFormat sdf=new SimpleDateFormat("MM/yyyy");
                                try
                                {
                                    Connection con=null;
                                    con=Util.openConnection(con);
                                    StringBuilder consulta=new StringBuilder("select ppp.cod_programa_prod,ppp.NOMBRE_PROGRAMA_PROD");
                                                             consulta.append(" from PROGRAMA_PRODUCCION_PERIODO ppp");
                                                             consulta.append(" where ppp.COD_TIPO_PRODUCCION=1");
                                                                 consulta.append(" and ppp.COD_ESTADO_PROGRAMA<>4");
                                                             consulta.append(" order by ppp.COD_TIPO_PRODUCCION");
                                    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                    ResultSet res=st.executeQuery(consulta.toString());
                                    while(res.next())
                                        out.println("<option value="+res.getInt("cod_programa_prod")+">"+res.getString("NOMBRE_PROGRAMA_PROD")+"</option>");

                                %>
                            </select>
                            <input type="checkbox" id="checktodo" onclick="seleccionTodo()"/>
                        </td>
                    </tr>
                    <tr>
                        <td class="outputTextBold"> Producto</td>
                        <td class="outputTextBold"> ::</td>
                        <td colspan="4">
                            <select id="codCompProd">
                                <option value="0">--TODOS--</option>
                                <%
                                    
                                        consulta=new StringBuilder("select cp.COD_COMPPROD,cp.nombre_prod_semiterminado");
                                                                consulta.append(" from COMPONENTES_PROD cp where cp.COD_TIPO_PRODUCCION=1");
                                                                consulta.append(" order by cp.nombre_prod_semiterminado");
                                        res=st.executeQuery(consulta.toString());
                                        while(res.next())out.println("<option value='"+res.getInt("COD_COMPPROD")+"'>"+res.getString("nombre_prod_semiterminado")+"</option>");
                                    }
                                    catch(SQLException ex)
                                    {
                                        ex.printStackTrace();
                                    }
                                %>
                            </select>
                        </td>
                    </tr>
                    <tr>    
                        <td class="outputTextBold"> Lote</td>
                        <td class="outputTextBold"> ::</td>
                        <td><input id="codLoteProduccion" type="Text"/></td>
                    </tr>
                    
                    <tr>
                        <td align="center" colspan="6">
                            <button class="btn" onclick="ajaxBuscarProductos()">BUSCAR</button>
                        </td>
                    </tr>
                </table>
            </center>
            <center>
                <table><tr><td> 
                    <div align="center" id="lotesDiv" style="margin-top:1em;height:14em;overflow-y: auto;overflow-x: hidden" >
                        <table class="tablaReporte" cellpadding="0" cellspacing="0">
                            <thead>
                                <tr>
                                    <td></td>
                                    <td>Lote</td>
                                    <td>Producto</td>
                                    <td>Tipo Producción</td>
                                </tr>
                            </thead>
                        </table>
                    </td></tr></table>       
            </center>
            <center style="margin-top:0.5em">
                <button class="btn" onclick="verReporteDetallado()">Ver Reporte Detallado</button>
                <button class="btn" onclick="verReporteResumido()">Ver Reporte Resumido</button>
            </center>               
            <br>
            <input id="codigosLotes" name="codigosLotes" type="hidden"/>

        </form>
        <script type="text/javascript" language="JavaScript"  src="../../js/dlcalendar.js"></script>
    </body>
</html>