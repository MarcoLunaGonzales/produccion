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
            
            function verReporteDetallado(codTipoReporte)
            {
                var tablaProducto=document.getElementById("tablaProductos").tBodies[0];
                var arrayProductos=new Array();
                for(var i=0;i<tablaProducto.rows.length;i++)
                {
                    if(tablaProducto.rows[i].cells[0].getElementsByTagName("input")[0].checked)
                        arrayProductos.push("'"+tablaProducto.rows[i].cells[1].getElementsByTagName("input")[0].value.toString()+"'");
                }
                document.getElementById("aplicaFechaR").value=(document.getElementById("aplicaFecha").checked?1:0);
                if(arrayProductos.length==0)
                {
                    if(!document.getElementById("aplicaFecha").checked)
                    {
                        alert('Debe seleccion por lo menos un lote');
                        return null;
                    }
                }
                switch(codTipoReporte)
                {
                    case 1:
                    {
                        document.getElementById("form1").action="reporteDefectosDetallado.jsf?data="+(new Date()).getTime().toString();
                        break;
                    }
                    case 2:
                    {   
                        document.getElementById("form1").action="reporteDefectosDetalladoExcel.jsf?data="+(new Date()).getTime().toString();
                        break;
                    }
                    case 4:
                    {
                        document.getElementById("form1").action="reporteDefectosFrvProduccion.jsf?data="+(new Date()).getTime().toString();
                        arrayProductos=new Array();
                        for(var i=0;i<tablaProducto.rows.length;i++)
                        {
                            if(tablaProducto.rows[i].cells[0].getElementsByTagName("input")[0].checked)
                                arrayProductos.push("'"+tablaProducto.rows[i].cells[1].getElementsByTagName("input")[0].value.toString().split("$")[1]+"'");
                        }
                        break;
                    }
                    default:
                    {  
                        document.getElementById("form1").action="reporteDefectosResumido.jsf?data="+(new Date()).getTime().toString();
                    }
                }
                
                document.getElementById("codigosLotes").value=arrayProductos;
                document.getElementById("form1").submit();
            }
            
            function reportePorFecha()
            {
                document.getElementById("fechaInicioTr").style.display=(document.getElementById("aplicaFecha").checked?'':'none');
                document.getElementById("fechaFinalTr").style.display=(document.getElementById("aplicaFecha").checked?'':'none');
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
                                Connection con=null;
                                try
                                {
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
                                    finally
                                    {
                                        con.close();
                                    }
                            SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy");
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
                        <td class="outputTextBold">Filtrar por fecha de operario</td>
                        <td class="outputTextBold"> ::</td>
                        <td><input type="checkbox" id="aplicaFecha" id="aplicaFecha" onclick="reportePorFecha()"/></td>
                    </tr>
                    <tr style="display:none" id="fechaInicioTr">
                        <td class="outputTextBold">De fecha de operario</td>
                        <td class="outputTextBold">::</td>
                        <td >
                            <input type="text"  size="12"  value="<%=(sdf.format(new Date()))%>" id="fecha_inicio" name="fecha_inicio" class="inputText">
                            <img id="imagenFecha1" src="../../img/fecha.bmp">
                            <DLCALENDAR tool_tip="Seleccione la Fecha"
                                        daybar_style="background-color: DBE1E7;
                                        font-family: verdana; color:000000;"navbar_style="background-color: 7992B7; color:ffffff;"
                                        input_element_id="fecha_inicio" click_element_id="imagenFecha1">
                             </DLCALENDAR>
                        </td>
                    </tr>
                    <tr style="display:none" id="fechaFinalTr">
                        <td class="outputTextBold">A fecha de operario</td>
                        <td class="outputTextBold">::</td>
                        <td>
                            <input type="text"  size="12"  value="<%=(sdf.format(new Date()))%>" id="fecha_final" name="fecha_final" class="inputText">
                            <img id="imagenFecha2" src="../../img/fecha.bmp">
                            <DLCALENDAR tool_tip="Seleccione la Fecha"
                                        daybar_style="background-color: DBE1E7;
                                        font-family: verdana; color:000000;"navbar_style="background-color: 7992B7; color:ffffff;"
                                        input_element_id="fecha_final" click_element_id="imagenFecha2">
                             </DLCALENDAR>
                        </td>
                    </tr>
                    <tr>
                        <td align="center" colspan="6">
                            <a class="btn" onclick="ajaxBuscarProductos()">BUSCAR</a>
                        </td>
                    </tr>
                </table>
            </center>
            <center>
                <table><tr><td> 
                    <div align="center" id="lotesDiv" style="margin-top:1em;height:14em;overflow-y: auto;overflow-x: hidden" >
                        <table class="tablaReporte" cellpadding="0" cellspacing="0" id="tablaProductos">
                            <thead>
                                <tr>
                                    <td></td>
                                    <td>Lote</td>
                                    <td>Producto</td>
                                    <td>Tipo Producción</td>
                                </tr>
                            </thead>
                            <tbody>
                                
                            </tbody>
                        </table>
                    </td></tr></table>       
            </center>
            <center style="margin-top:0.5em">
                <a class="btn" onclick="verReporteDetallado(1)">Ver Reporte Detallado</a>
                <a class="btn" onclick="verReporteDetallado(2)">Ver Reporte Detallado Excel</a>
                <a class="btn" onclick="verReporteDetallado(3)">Ver Reporte Resumido</a>
                <a class="btn" onclick="verReporteDetallado(4)">Reporte Frv Producción</a>
            </center>               
            <br>
            <input id="codigosLotes" name="codigosLotes" type="hidden"/>
            <input id="aplicaFechaR" name="aplicaFechaR" type="hidden"/>

        </form>
        <script type="text/javascript" language="JavaScript"  src="../../js/dlcalendar.js"></script>
    </body>
</html>