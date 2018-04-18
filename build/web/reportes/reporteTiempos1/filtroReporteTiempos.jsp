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



            /****************** AJAX CLIENTE ********************/
            function ajaxClientes(f)
            {	ajaxDistritos(f);


            }


            function sel_todoLineaMkt(f){
                for(var i=0;i<=f.codfuncionario.options.length-1;i++)
                {   if(f.chk_todoFuncionario.checked==true)
                    {   f.codfuncionario.options[i].selected=true;
                    }
                    else
                    {   f.codfuncionario.options[i].selected=false;
                    }
                }
                return(true);
            }

            function selecccionarTodoArea(f){
                for(var i=0;i<=f.codAreaEmpresa.options.length-1;i++)
                {
                    f.codAreaEmpresa.options[i].selected=f.chk_todoArea.checked;                    
                }
                if(f.chk_todoArea.checked){
                    this.ajaxProductos(f);
                }else{
                    f.codCompProd.options.length=0;
                }
                
            }
            function selecccionarTodoLotes(f){
                for(var i=0;i<=f.lotesReporte.options.length-1;i++)
                {
                    f.lotesReporte.options[i].selected=f.chk_todoLote.checked;
                }
                

            }

            function selecccionarTodo(f){
                for(var i=0;i<=f.codCompProd.options.length-1;i++)
                {
                    f.codCompProd.options[i].selected=f.chk_todoTipo.checked;
                }
            }

            function sel_todoDistrito(f){
                var arrayDistrito=new Array();
                var j=0;
                for(var i=0;i<=f.coddistrito.options.length-1;i++)
                {   if(f.chk_todoDistrito.checked==true)
                    {   f.coddistrito.options[i].selected=true;
                        arrayDistrito[j]=f.coddistrito.options[i].value;
                        j++;
                    }
                    else
                    {   f.coddistrito.options[i].selected=false;
                    }
                }
                f.coddistrio=arrayDistrito;
                var div_zona;
                div_zona=document.getElementById("div_codzona");
                coddistrito=f.coddistrito;
                ajax=nuevoAjax();
                ajax.open("GET","../utiles/ajaxZonas.jsf?coddistrito="+arrayDistrito,true);
                ajax.onreadystatechange=function(){
                    if (ajax.readyState==4) {
                        div_zona.innerHTML=ajax.responseText;
                    }
                }
                ajax.send(null)
                return(true);
            }
            function sel_todoZona(f){
                for(var i=0;i<=f.codzona.options.length-1;i++)
                {   if(f.chk_todoZona.checked==true)
                    {   f.codzona.options[i].selected=true;
                    }
                    else
                    {   f.codzona.options[i].selected=false;
                    }
                }
                return(true);
            }

            function selecccionarTodoLinea(f){
                for(var i=0;i<=f.codLineaMkt.options.length-1;i++)
                {   if(f.chk_todoLinea.checked==true)
                    {   f.codLineaMkt.options[i].selected=true;
                    }
                    else
                    {   f.codLineaMkt.options[i].selected=false;
                    }
                }
                return(true);
            }
            function construirCadena(name){
                //document.getElementById(name).value='';
                var codtiposingresoventas=document.getElementById(name);
                var options=codtiposingresoventas.getElementsByTagName('option');

                var j=0;
                var data=new Array();
                for(var i=0;i<options.length;i++){
                    if(options[i].selected){
                        data[j]=options[i].value;j++;
                    }
                }
                return data;
            }

            function mandar(){
                var arrayMaquina=new Array();
                var j=0;
                for(var i=0;i<=form1.codAreaEmpresa.options.length-1;i++)
                {
                    if(form1.codAreaEmpresa.options[i].selected)
                    {
                        arrayMaquina[j]=form1.codAreaEmpresa.options[i].value;
                        j++;
                    }
                }
                form1.codigosArea.value=arrayMaquina;
                form1.action="navegadorReporteProgramaProduccion.jsf";

                form1.submit();
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
            /****************** AJAX DISTRITOS ********************/
            function ajaxDistritos(f)
            {
                var div_distrito;
                div_distrito=document.getElementById("div_distrito");
                codAreaEmpresa=f.codareaempresa.value;
                ajax=nuevoAjax();

                ajax.open("GET","../utiles/ajaxDistritos.jsf?codAreaEmpresa="+codAreaEmpresa,true);
                ajax.onreadystatechange=function(){
                    if (ajax.readyState==4) {
                        div_distrito.innerHTML=ajax.responseText;
                    }
                }
                ajax.send(null)
                var div_zona=document.getElementById("div_codzona");
                clearChild(div_zona.firstChild);
            }


            function ajaxX(f){
                var div_distrito;
                div_distrito=document.getElementById("div_coddistrito");
                codAreaEmpresa=f.codareaempresa.value;
                ajax=nuevoAjax();

                ajax.open("GET","../utiles/ajaxDistritos.jsf?codAreaEmpresa="+codAreaEmpresa,true);
                ajax.onreadystatechange=function(){
                    if (ajax.readyState==4) {
                        div_distrito.innerHTML=ajax.responseText;
                    }
                }
                ajax.send(null);
            }
            function desabilitarDistrito(f){
                f.chk_todoDistrito.checked=false;
            }
            function desabilitarZonas(f){
                f.chk_todoZona.checked=false;
            }
            function ajaxZonas(f){
                var div_zona;
                div_zona=document.getElementById("div_zona");

                var arrayDistrito=new Array();
                var j=0;
                for(var i=0;i<=f.coddistrito.options.length-1;i++)
                {	if(f.coddistrito.options[i].selected)
                    {	arrayDistrito[j]=f.coddistrito.options[i].value;
                        j++;
                    }
                }
                coddistrito=arrayDistrito;
                ajax=nuevoAjax();

                ajax.open("GET","../utiles/ajaxZonas.jsf?coddistrito="+coddistrito,true);
                ajax.onreadystatechange=function(){
                    if (ajax.readyState==4) {

                        div_codzona.innerHTML=ajax.responseText;
                    }
                }
                ajax.send(null);
            }
            function ajaxArea(f){
                var div_area;
                div_area=document.getElementById("div_area");
                
                ajax=nuevoAjax();
                 var arrayCompProd=new Array();

                  var j=0;
                   for(var i=0;i<=f.codProgramaProdPeriodo.options.length-1;i++)
                      {	if(f.codProgramaProdPeriodo.options[i].selected)
                           {
                               arrayCompProd[j]=f.codProgramaProdPeriodo.options[i].value;
                               j++;
                           }
                       }

                ajax.open("GET","ajaxArea.jsf?codProgramaProduccion="+arrayCompProd,true);
                ajax.onreadystatechange=function(){
                    if (ajax.readyState==4) {                        
                        div_area.innerHTML=ajax.responseText;
                    }
                }
                f.codCompProd.options.length=0;
                ajax.send(null);
                

            }

            function buscarLote(f){
                
                var div_producto=document.getElementById("div_producto");
                var arrayCodAreaEmpresa=new Array();
                var j=0;
                for(var i=0;i<=f.codAreaEmpresa.options.length-1;i++)
                {	if(f.codAreaEmpresa.options[i].selected)
                    {	arrayCodAreaEmpresa[j]=f.codAreaEmpresa.options[i].value;
                        j++;
                    }
                }
                 var arrayCompProd=new Array();

                  var j=0;
                   for(var i=0;i<=f.codProgramaProdPeriodo.options.length-1;i++)
                      {	if(f.codProgramaProdPeriodo.options[i].selected)
                           {	arrayCompProd[j]=f.codProgramaProdPeriodo.options[i].value;

                               j++;
                           }
                       }
                
                ajax=nuevoAjax();
                var aleatorio=Math.random();
                ajax.open("GET","ajaxProducto.jsf?codProgramaProduccion="+arrayCompProd+
                    "&codEstadoPrograma="+(f.codEstadoPrograma.value)+"&codAreaEmpresa="+arrayCodAreaEmpresa+
                    "&codLote="+(f.codLoteBuscar.value)+"&aleatorio="+aleatorio,true);
                ajax.onreadystatechange=function(){
                    if (ajax.readyState==4) {

                        div_producto.innerHTML=ajax.responseText;
                    }
                }                
                ajax.send(null);
            }
            


            function clearChild(obj){
                while(obj.hasChildNodes())
                    obj.removeChild(obj.lastChild);
            }
            function filtraPorCodigoProgramaProduccion(codProgramaProduccionPeriodo){
                // var codigo=f.codAreaEmpresa.value;
                
                location.href="filtroReporteSeguimientoProgramaProduccion.jsf?codProgramaProduccionPeriodo="+codProgramaProduccionPeriodo;
            }

       function enviaProgramaProduccion(f){
        f.codProgramaProduccionPeriodo.value=document.getElementById('codProgramaProdPeriodo').options[document.getElementById('codProgramaProdPeriodo').selectedIndex].value;
        if(f.codProgramaProduccionPeriodo.value!='-1')
            {
                f.nombreProgramaProduccionPeriodo.value=document.getElementById('codProgramaProdPeriodo').options[document.getElementById('codProgramaProdPeriodo').selectedIndex].innerHTML;                
            } else{
                f.nombreProgramaProduccionPeriodo.value="";
            }

        
        var arrayCompProd=new Array();
        var arrayCompProd1=new Array();
        var j=0;
        for(var i=0;i<=f.lotesReporte.options.length-1;i++)
        {	
            	arrayCompProd[j]=f.lotesReporte.options[i].value;
                arrayCompProd1[j]=f.lotesReporte.options[i].innerHTML;
                j++;
            
        }
        
        f.codCompProdArray.value=arrayCompProd;
        f.nombreCompProd.value=arrayCompProd1;       

        /*******************/

        var arrayCodAreaEmpresa=new Array();
        var arrayNombreAreaEmpresa=new Array();
        j=0;
        for(var i=0;i<=f.codAreaEmpresa.options.length-1;i++)
        {	if(f.codAreaEmpresa.options[i].selected)
            {	arrayCodAreaEmpresa[j]=f.codAreaEmpresa.options[i].value;
                arrayNombreAreaEmpresa[j]=f.codAreaEmpresa.options[i].innerHTML;
                j++;
            }
        }

        f.codAreaEmpresaP.value=arrayCodAreaEmpresa;
        f.nombreAreaEmpresaP.value=arrayNombreAreaEmpresa;

        /************************/
        f.desdeFechaP.value=f.fecha_inicio.value;
        f.hastaFechaP.value=f.fecha_final.value;
        f.desdeFechaPers.value=f.fecha_inicioPer.value;
        f.hastaFechaPers.value=f.fecha_finalPer.value;
        /*
        if(f.codTipoReporteDetallado.value==1){
            f.action="reporteSeguimientoProgramaProduccion.jsf";
        }else{
            f.action="reporteSeguimientoProgramaProduccionResumido.jsf";
        }*/
        //echo por ale
         var arrayCompProd=new Array();
        var arrayCompProd1=new Array();
        var j=0;
        for(var i=0;i<=f.codProgramaProdPeriodo.options.length-1;i++)
        {	if(f.codProgramaProdPeriodo.options[i].selected)
            {	arrayCompProd[j]=f.codProgramaProdPeriodo.options[i].value;
                arrayCompProd1[j]=f.codProgramaProdPeriodo.options[i].innerHTML;
                j++;
            }
        }
        f.codProgramaProdArray.value=arrayCompProd;
        f.nombreProgramaProd.value=arrayCompProd1;
        if(f.chkfechas1.checked)
        {
        f.reporteconfechas.value='1';
        }
        else
            {
        f.reporteconfechas.value='0';
            }
        if(f.chkfechasPer.checked)
        {
        f.reporteconfechasPer.value='1';
        }
        else
        {
        f.reporteconfechasPer.value='0';
        }
        
        if(f.codTipoReporteDetallado.value=='1')
            {
                f.action="reporteDeTiemposDetallado.jsf";
            }
            else
            {
                f.action="reporteDeTiemposResumido.jsf";
            }
        f.nombreEstado.value=f.codEstadoPrograma.options[f.codEstadoPrograma.selectedIndex].innerHTML;
        f.nombreTipoActividad.value=f.codAreaEmpresaActividad.options[f.codAreaEmpresaActividad.selectedIndex].innerHTML;
        f.submit();
            }
        function areaEmpresa_change(f){

        

        
        alert("entro333333333333");
        

            f.chk_todoArea.checked=false
        }
        function selecccionarTodo1(f){
                for(var i=0;i<=f.codProgramaProdPeriodo.options.length-1;i++)
                {
                    f.codProgramaProdPeriodo.options[i].selected=f.chk_todoTipo1.checked;
                }
                if(f.chk_todoTipo1.checked)
                    {
                this.ajaxArea(f);
                    }

            }
        function adicionarProducto(f)
        {
            var cant=f.lotesReporte.options.length;
            
            for(var i=0;i<f.codCompProd.options.length;i++)
                {
                    if(f.codCompProd.options[i].selected)
                    {
                        
                        f.lotesReporte.options[cant]=new Option(f.codCompProd.options[i].innerHTML,f.codCompProd.options[i].value,"");
                        cant++;
                    }
                }
        }
		function quitarLotes(f)
		{
            var eliminar=new Array();
            var cont=0;
			for(var i=0;i<f.lotesReporte.length;i++)
			{
				if(f.lotesReporte.options[i].selected)
				{
                    eliminar[cont]=i;
                    cont++;
				}
			}
            eliminar=eliminar.reverse();
            for(var j=0;j<cont;j++)
                {
                    f.lotesReporte.remove(eliminar[j]);
                }
		}

        </script>



    </head>
    <body>
        <h3 style="top:1px" align="center">Reporte de tiempos de Produccion</h3 >

        <form method="post" action="reporteDeTiempos.jsp" target="_blank" style="top:1px" name="form1">
            <div align="center">
                <table border="0"  border="0" class="border" >
                    <tr class="headerClassACliente">
                        <td  colspan="3" >
                            <div class="outputText3" align="center">
                                Introduzca Datos
                            </div>
                        </td>

                    </tr>

                    <tr class="outputText3">
                        <td class="">Programa de Producción</td>
                        <td class="">::</td>
                        <%
           String codProgramaProduccionPeriodoReq ="";
           if(request.getParameter("codProgramaProduccionPeriodo")!=null)
           {codProgramaProduccionPeriodoReq = request.getParameter("codProgramaProduccionPeriodo");}
           try {
            con = Util.openConnection(con);
            System.out.println("con:::::::::::::" + con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);            
            
            
            
            
            String sql = "SELECT PP.COD_PROGRAMA_PROD,PP.NOMBRE_PROGRAMA_PROD,PP.OBSERVACIONES";
            sql += ",(SELECT EP.NOMBRE_ESTADO_PROGRAMA_PROD FROM ESTADOS_PROGRAMA_PRODUCCION EP WHERE EP.COD_ESTADO_PROGRAMA_PROD = PP.COD_ESTADO_PROGRAMA)";
            sql += " FROM PROGRAMA_PRODUCCION_PERIODO PP WHERE PP.COD_ESTADO_PROGRAMA<>4 and (pp.COD_TIPO_PRODUCCION is null or  pp.COD_TIPO_PRODUCCION =1)";
            System.out.println("sql filtro:" + sql);
            ResultSet rs = st.executeQuery(sql);
                        %>
                        <td class="">
                            <select name="codProgramaProdPeriodo" class="outputText3" multiple onchange="ajaxArea(form1);">
                                <%
                            String codProgramaProduccionPeriodo = "";
                            String nombreProgramaProduccionPeriodo = "";
                            
                            while (rs.next()) {
                                codProgramaProduccionPeriodo = rs.getString("COD_PROGRAMA_PROD");
                                nombreProgramaProduccionPeriodo = rs.getString("NOMBRE_PROGRAMA_PROD");                                
                                if(codProgramaProduccionPeriodo.equals(codProgramaProduccionPeriodoReq))
                                out.print("<option value="+codProgramaProduccionPeriodo+" >"+nombreProgramaProduccionPeriodo+"</option>");
                                else
                                out.print("<option value="+codProgramaProduccionPeriodo+">"+nombreProgramaProduccionPeriodo+"</option>");
                            }%>
                            </select>
                            <input type="checkbox"  onclick="selecccionarTodo1(form1)" name="chk_todoTipo1" >Todo
                            <!--  <input type="checkbox"  onclick="selecccionarTodo(form1)" name="chk_todoTipo" >Todo-->
                            <%

        } catch (Exception e) {
        }
                            %>
                        </td>
                    </tr>


                    <tr class="outputText3" >
                        <td class="">Area</td>
                        <td class="">::</td>                        

                        <td class="">
                            <div id="div_area">                            
                                <select name="codAreaEmpresa" size="15" class="inputText" multiple onchange="form1.chk_todoArea.checked=false;">
                                <option value="-1">-NINGUNO-</option>
                            </select>
                            <input type="checkbox"  onclick="selecccionarTodoArea(form1)" name="chk_todoArea" >Todo                           
                            </div>
                        </td>
                    </tr>
                    <tr class="outputText3">
                        <td class="">Estado Programa Produccion</td>
                        <td class="">::</td>
                        <td class="">
                            <select name="codEstadoPrograma" class="outputText3" >
                                <option value="2,5,6,7" selected>-TODOS-</option>
                                <option value="2,5">APROBADO</option>
                                <option value="6">TERMINADO / ENVIADO</option>
                                <option value="7">EN PROCESO</option>
                            </select>
                        </td>
                    </tr>
                    <tr class="outputText3">
                        <td class="">Lote</td>
                        <td class="">::</td>
                        <td class="">
                            <input type="text" value="" id="codLoteBuscar">
                            <button onclick="buscarLote(form1)">Buscar</button>
                        </td>
                    </tr>


                    <tr class="outputText3" >
                        <td class="">Productos</td>
                        <td class="">::</td>
                        

                        <td class="">
                            <div id="div_producto">
                            <select name="codCompProd" size="15" class="inputText" multiple onchange="form1.chk_todoTipo.checked=false">
                                <option value="0">-NINGUNO-</option>
                            </select>
                            <input type="checkbox"  onclick="selecccionarTodo(form1)" name="chk_todoTipo" >Todo
                            
                            </div>
                            
                            <button onclick="adicionarProducto(form1)">(˅)Adicionar Lotes</button>
                            <button onclick="quitarLotes(form1)">(˄) Quitar Lotes</button>
                            
                        </td>
                    </tr>
                    
                     <tr class="outputText3" >
                        <td class="">Lotes Para Reporte</td>
                        <td class="">::</td>


                        <td class="">
                            <div>
                            <select name="lotesReporte" size="15" class="inputText" multiple  style="min-width:100px;">
                                
                            </select>
                            <input type="checkbox"  onclick="selecccionarTodoLotes(form1)" name="chk_todoLote" >Todo
                            </div>
                            
                        </td>
                    </tr>
				
                    
                    <%--tr class="outputText3">
                        <td class="">Estado Programa Produccion</td>
                        <td class="">::</td>
                        <td class="">
                            <select name="codTipoReporteSeguimientoProgramaProduccion" class="outputText3">
                                <option value="1" selected>-TODOS-</option>
                                <option value="2">CON SEGUIMIENTO</option>
                                <option value="3">SIN SEGUIMIENTO</option>
                            </select>
                        </td>
                    </tr--%>

                    <tr class="outputText3">
                        <td class="">Tipo Reporte</td>
                        <td class="">::</td>
                        <td class="">
                            <select name="codTipoReporteDetallado" class="outputText3">
                                <option value="1" selected>DETALLADO</option>
                                <option value="2">RESUMIDO</option>
                            </select>
                        </td>
                    </tr>
                    
                    <tr class="outputText3">
                        <td class="">Tipo de Actividad</td>
                        <td class="">::</td>
                        <%           
                    try {
                    con = Util.openConnection(con);                    
                    Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

            String sql = " select a.cod_area_empresa,a.nombre_area_empresa from areas_empresa a where a.cod_area_empresa in (84,96,40,75,76,97,1001) ";
            System.out.println("sql filtro tipo actividad:" + sql);
            ResultSet rs = st.executeQuery(sql);
                        %>
                        <td class="">
                            <select name="codAreaEmpresaActividad" id="codAreaEmpresaActividad"  class="outputText3">
                                <%
                            String codAreaEmpresa = "";
                            String nombreAreaEmpresa = "";
                             out.print("<option value='0' selected>-TODOS-</option>");
                            while (rs.next()) {
                                codAreaEmpresa = rs.getString("cod_area_empresa");
                                nombreAreaEmpresa = rs.getString("nombre_area_empresa");
                               
                                out.print("<option value="+codAreaEmpresa+">"+nombreAreaEmpresa+"</option>");
                            }%>
                            </select>
                            <!--  <input type="checkbox"  onclick="selecccionarTodo(form1)" name="chk_todoTipo" >Todo-->
                            <%                              
                               
                    } catch (Exception e) {
                      e.printStackTrace();
                    }
                            %>
                        </td>
                    </tr>
                    <%
                     SimpleDateFormat form = new SimpleDateFormat("dd/MM/yyyy");
                                Date fecha_inicio = new Date();
                                String fechaFinal = form.format(fecha_inicio);
                                String fechaInicio = "01";
                                fechaFinal.substring(2, 10);
                                fechaInicio = fechaInicio + fechaFinal.substring(2, 10);
                                String fechaInicioper=fechaInicio;
                                String fechaFinalper=fechaFinal;

                    %>

                    <tr class="outputText2">
                     <td colspan="4"><input type="checkbox"  name="chkfechas1">Reporte con fecha de ingresos acondicionamiento</td>
                    </tr>
                    <tr class="outputText2">
                        <td >De fecha de ingreso acond:
                        </td>
                        <td >::</td>
                        <td >
                            <input type="text"  size="12"  value="<%=fechaInicio%>" name="fecha_inicio" class="inputText">
                            <img id="imagenFecha1" src="../../img/fecha.bmp">
                            <DLCALENDAR tool_tip="Seleccione la Fecha"
                                        daybar_style="background-color: DBE1E7;
                                        font-family: verdana; color:000000;"navbar_style="background-color: 7992B7; color:ffffff;"
                                        input_element_id="fecha_inicio" click_element_id="imagenFecha1">
                             </DLCALENDAR>
                        </td>
                    </tr>

                    <tr class="outputText2">
                        <td>A fecha de ingreso acond:
                        </td>
                        <td >::</td>
                        <td>
                            <input type="text"  size="12"  value="<%=fechaFinal%>" name="fecha_final" class="inputText">
                            <img id="imagenFecha2" src="../../img/fecha.bmp">
                            <DLCALENDAR tool_tip="Seleccione la Fecha"
                                        daybar_style="background-color: DBE1E7;
                                        font-family: verdana; color:000000;"navbar_style="background-color: 7992B7; color:ffffff;"
                                        input_element_id="fecha_final" click_element_id="imagenFecha2">
                             </DLCALENDAR>
                        </td>
                    </tr>
                     <tr class="outputText2">
                     <td colspan="4"><input type="checkbox"  name="chkfechasPer">Reporte con fechas de personal</td>
                    </tr>
                    <tr class="outputText2">
                        <td >De fecha de ingreso personal:
                        </td>
                        <td >::</td>
                        <td >
                            <input type="text"  size="12"  value="<%=fechaInicioper%>" name="fecha_inicioPer" class="inputText">
                            <img id="imagenFechaPer1" src="../../img/fecha.bmp">
                            <DLCALENDAR tool_tip="Seleccione la Fecha"
                                        daybar_style="background-color: DBE1E7;
                                        font-family: verdana; color:000000;"navbar_style="background-color: 7992B7; color:ffffff;"
                                        input_element_id="fecha_inicioPer" click_element_id="imagenFechaPer1">
                             </DLCALENDAR>
                        </td>
                    </tr>

                    <tr class="outputText2">
                        <td>A fecha de salida personal:
                        </td>
                        <td >::</td>
                        <td>
                            <input type="text"  size="12"  value="<%=fechaFinalper%>" name="fecha_finalPer" class="inputText">
                            <img id="imagenFechaPer2" src="../../img/fecha.bmp">
                            <DLCALENDAR tool_tip="Seleccione la Fecha"
                                        daybar_style="background-color: DBE1E7;
                                        font-family: verdana; color:000000;"navbar_style="background-color: 7992B7; color:ffffff;"
                                        input_element_id="fecha_finalPer" click_element_id="imagenFechaPer2">
                             </DLCALENDAR>
                        </td>
                    </tr>

                </table>

            </div>
            <br>
            <center>
                <input type="button" class="btn"  value="Ver Reporte" name="reporte" onclick="enviaProgramaProduccion(form1)">
                <input type="hidden" name="codigosArea" id="codigosArea">

            </center>
            <!--datos de referencia para el envio de datos via post-->
            <input type="hidden" name="codProgramaProduccionPeriodo">
            <input type="hidden" name="nombreProgramaProduccionPeriodo">

            <input type="hidden" name="codCompProdArray">
            <input type="hidden" name="nombreCompProd">
            <input type="hidden" name="codProgramaProdArray">
            <input type="hidden" name="nombreProgramaProd">

            <input type="hidden" name="codAreaEmpresaP">
            <input type="hidden" name="nombreAreaEmpresaP">
            <input type="hidden" name="desdeFechaP">
            <input type="hidden" name="hastaFechaP">
            <input type="hidden" name="desdeFechaPers">
            <input type="hidden" name="hastaFechaPers">
            <input type="hidden" name="reporteconfechas">
            <input type="hidden" name="reporteconfechasPer">
            <input type="hidden" name="nombreEstado">
            <input type="hidden" name="nombreTipoActividad">



        </form>
        <script type="text/javascript" language="JavaScript"  src="../../js/dlcalendar.js"></script>
    </body>
</html>