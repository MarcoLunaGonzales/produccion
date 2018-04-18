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

<%
        Connection con = null;
      
%>



<html>
    <head>
        <link rel="STYLESHEET" type="text/css" href="../../../css/ventas.css" />
        <script src="../../../js/general.js"></script>
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
            function seleccionarTodosproducto(f){
                for(var i=0;i<=f.codProducto.options.length-1;i++)
                {
                    f.codProducto.options[i].selected=f.checkTodosComponentesProd.checked;                    
                }
                
            }
            function selecccionarTodoArea(f){
                for(var i=0;i<=f.codAreaEmpresaProducto.options.length-1;i++)
                {
                    f.codAreaEmpresaProducto.options[i].selected=f.chk_todoArea.checked;                    
                }
                if(f.chk_todoArea.checked){
                    this.ajaxProductos(f);
                }else{
                    f.codProducto.options.length=0;
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
           
            function ajaxArea(f){
                /*var div_area;
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
                    if (ajax.readyState==4) 
                    {                        
                        div_area.innerHTML=ajax.responseText;
                    }
                }*/
                f.codCompProd.options.length=0;
                ajax.send(null);
                

            }
            
            function ajaxProductos(f){
                var div_area;
                div_area=document.getElementById("divProducto");
                ajax=nuevoAjax();
                var areasEmpresa=new Array();
                for(var i=0;i<=f.codAreaEmpresaProducto.options.length-1;i++)
                {	
                    if(f.codAreaEmpresaProducto.options[i].selected)
                    {
                        areasEmpresa[areasEmpresa.length]=f.codAreaEmpresaProducto.options[i].value;
                    }
                }

                ajax.open("GET","ajaxComponentesProd.jsf?codAreaEmpresa="+areasEmpresa+"&date="+(new Date()).getTime().toString(),true);
                ajax.onreadystatechange=function(){
                    if (ajax.readyState==4) 
                    {                        
                        div_area.innerHTML=ajax.responseText;
                    }
                }
                f.codCompProd.options.length=0;
                ajax.send(null);
                

            }    
                
            function buscarLote(f){
                
                var div_producto=document.getElementById("div_producto");
                var codAreaEmpresa=new Array();
                for(var i=0;i<=f.codAreaEmpresaProducto.options.length-1;i++)
                    if(f.codAreaEmpresaProducto.options[i].selected)codAreaEmpresa.push(f.codAreaEmpresaProducto.options[i].value);
                var codProgramaProd=new Array();
                for(var i=0;i<=f.codProgramaProdPeriodo.options.length-1;i++)
                    if(f.codProgramaProdPeriodo.options[i].selected)codProgramaProd.push(f.codProgramaProdPeriodo.options[i].value);
                var codCompProd=new Array();
                for(var i=0;i<f.codProducto.options.length;i++)
                    if(f.codProducto.options[i].selected)codCompProd.push(f.codProducto.options[i].value);
                ajax=nuevoAjax();
                ajax.open("GET","ajaxProducto.jsf?codProgramaProduccion="+codProgramaProd+
                    "&codEstadoPrograma="+(f.codEstadoPrograma.value)+"&codAreaEmpresa="+codAreaEmpresa+
                    "&codComProd="+codCompProd+
                    "&codLote="+(f.codLoteBuscar.value)+"&datos="+(new Date()).getTime().toString(),true);
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

       function enviaProgramaProduccion(f)
       {
        f.codProgramaProduccionPeriodo.value=document.getElementById('codProgramaProdPeriodo').options[document.getElementById('codProgramaProdPeriodo').selectedIndex].value;
        if(f.codProgramaProduccionPeriodo.value!='-1')
            {
                f.nombreProgramaProduccionPeriodo.value=document.getElementById('codProgramaProdPeriodo').options[document.getElementById('codProgramaProdPeriodo').selectedIndex].innerHTML;                
            } else{
                f.nombreProgramaProduccionPeriodo.value="";
            }
        var codCompProd=new Array();
        var nombreCompProd=new Array();
        for(var i=0;i<=f.codProducto.options.length-1;i++)
        {
            if(f.codProducto.options[i].selected)
            {
                codCompProd.push(f.codProducto.options[i].value);
                nombreCompProd.push(f.codProducto.options[i].innerHTML);
            }
        }
        f.codCompProdP.value=codCompProd;
        f.nombreComProdP.value=nombreCompProd;
        
        var codLote=new Array();
        var codLoteDescripcion=new Array();
        var j=0;
        for(var i=0;i<=f.lotesReporte.options.length-1;i++)
        {	
            	codLote.push(f.lotesReporte.options[i].value);
                codLoteDescripcion.push(f.lotesReporte.options[i].innerHTML);
        }
        
        f.codCompProdArray.value=codLote;
        f.nombreCompProd.value=codLoteDescripcion;       

        /*******************/

        var codAreaEmpresa=new Array();
        var nombreAreaEmpresa=new Array();
        j=0;
        for(var i=0;i<=f.codAreaEmpresaProducto.options.length-1;i++)
        {
            if(f.codAreaEmpresaProducto.options[i].selected)
            {	
                codAreaEmpresa.push(f.codAreaEmpresaProducto.options[i].value);
                nombreAreaEmpresa.push(f.codAreaEmpresaProducto.options[i].innerHTML);
            }
        }

        f.codAreaEmpresaP.value=codAreaEmpresa;
        f.nombreAreaEmpresaP.value=nombreAreaEmpresa;

        /************************/
        f.desdeFechaP.value=f.fecha_inicio.value;
        f.hastaFechaP.value=f.fecha_final.value;
        f.desdeFechaPers.value=f.fecha_inicioPer.value;
        f.hastaFechaPers.value=f.fecha_finalPer.value;
        var codProgramaProd=new Array();
        var nombreProgramaProd=new Array();
        for(var i=0;i<=f.codProgramaProdPeriodo.options.length-1;i++)
        {	if(f.codProgramaProdPeriodo.options[i].selected)
                {
                    codProgramaProd.push(f.codProgramaProdPeriodo.options[i].value);
                    nombreProgramaProd.push(f.codProgramaProdPeriodo.options[i].innerHTML);
                }
        }
        f.codProgramaProdArray.value=codProgramaProd;
        f.nombreProgramaProd.value=nombreProgramaProd;
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
        f.reporteLotes.value=(document.getElementById("reporteConLote").checked?1:0);
        if(f.codTipoReporteDetallado.value=='1')
            {
                f.action="reporteDeTiemposDetallado.jsf";
            }
            else
            {
                if(f.codTipoReporteDetallado.value=='2')
                    {
                        f.action="reporteDeTiemposResumido.jsf";
                    }
                    else
                        {
                            f.action="reporteDeTiemposDetalladoExcel.jsf";
                        }
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
        function verificarLote(celda)
        {
            document.getElementById("rowLote").style.display=(celda.checked?"table-row":"none");
            document.getElementById("rowLotesEncontrado").style.display=(celda.checked?"table-row":"none");
            document.getElementById("rowLotesReporte").style.display=(celda.checked?"table-row":"none");
        }
        function verificarIngresoAcond(celda)
        {
            document.getElementById("rowFechaInicioAcond").style.display=(celda.checked?"table-row":"none");
            document.getElementById("rowFechaFinalAcond").style.display=(celda.checked?"table-row":"none");
            
        }
        function verificarFechaPersona(celda)
        {
            document.getElementById("rowFechaInicioPersonal").style.display=(celda.checked?"table-row":"none");
            document.getElementById("rowFechaFinalPersonal").style.display=(celda.checked?"table-row":"none");

        }
        </script>



    </head>
    <body  onload="ajaxProductos(form1)">
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
                        sql += " FROM PROGRAMA_PRODUCCION_PERIODO PP WHERE PP.COD_ESTADO_PROGRAMA<>4 ";
                        System.out.println("sql filtro:" + sql);
                        ResultSet rs = st.executeQuery(sql);
                        %>
                        <td class="">
                            <select name="codProgramaProdPeriodo" class="outputText3" multiple onchange="">
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
                                <select name="codAreaEmpresaProducto" size="2" multiple class="inputText" >
                                    <option value="81" selected >LIQUIDOS ESTERILES</option>
                                </select>
                            
                            </div>
                        </td>
                    </tr>
                    <tr class="outputText3" >
                        <td class="">Producto</td>
                        <td class="">::</td>                        

                        <td class="">
                            <div id="divProducto">                            
                                <select name="codProducto" size="4" class="inputText" multiple onchange="form1.chk_todoArea.checked=false;">
                                <option value="-1">-NINGUNO-</option>
                            </select>
                            <input type="checkbox"  onclick="seleccionarTodosproducto(form1)" name="checkTodosComponentesProd" >Todo                           
                            </div>
                        </td>
                    </tr>
                    <tr class="outputText3">
                        <td class="">Estado Programa Produccion</td>
                        <td class="">::</td>
                        <td class="">
                            <select name="codEstadoPrograma" class="outputText3" >
                                <option value="2,5,6,7,8" selected>-TODOS-</option>
                                <option value="2,5">APROBADO</option>
                                <option value="6">TERMINADO / ENVIADO</option>
                                <option value="7">EN PROCESO</option>
                                <option value="8">FRV</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="3" class="outputText2">
                            <input type="checkbox" checked id="reporteConLote" name="reporteConLote" onclick="verificarLote(this)"/>
                            Reporte filtrado por Lote
                        </td>
                    </tr>
                    <tr id="rowLote" class="outputText3">
                        <td class="">Lote</td>
                        <td class="">::</td>
                        <td class="">
                            <input type="text" value="" id="codLoteBuscar">
                            <button onclick="buscarLote(form1)">Buscar</button>
                        </td>
                    </tr>


                    <tr id="rowLotesEncontrado" class="outputText3" >
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
                    
                     <tr class="outputText3"  id="rowLotesReporte">
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
                                <option value="3" >DETALLADO EXCEL</option>
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
                     <td colspan="4"><input type="checkbox" onclick="verificarIngresoAcond(this)"  name="chkfechas1">Reporte con fecha de ingresos acondicionamiento</td>
                    </tr>
                    <tr class="outputText2" id="rowFechaInicioAcond" style="display:none">
                        <td >De fecha de ingreso acond:
                        </td>
                        <td >::</td>
                        <td >
                            <input type="text"  size="12"  value="<%=fechaInicio%>" name="fecha_inicio" class="inputText">
                            <img id="imagenFecha1" src="../../../img/fecha.bmp">
                            <DLCALENDAR tool_tip="Seleccione la Fecha"
                                        daybar_style="background-color: DBE1E7;
                                        font-family: verdana; color:000000;"navbar_style="background-color: 7992B7; color:ffffff;"
                                        input_element_id="fecha_inicio" click_element_id="imagenFecha1">
                             </DLCALENDAR>
                        </td>
                    </tr>

                    <tr class="outputText2" id="rowFechaFinalAcond" style="display:none">
                        <td>A fecha de ingreso acond:
                        </td>
                        <td >::</td>
                        <td>
                            <input type="text"  size="12"  value="<%=fechaFinal%>" name="fecha_final" class="inputText">
                            <img id="imagenFecha2" src="../../../img/fecha.bmp">
                            <DLCALENDAR tool_tip="Seleccione la Fecha"
                                        daybar_style="background-color: DBE1E7;
                                        font-family: verdana; color:000000;"navbar_style="background-color: 7992B7; color:ffffff;"
                                        input_element_id="fecha_final" click_element_id="imagenFecha2">
                             </DLCALENDAR>
                        </td>
                    </tr>
                     <tr class="outputText2">
                     <td colspan="4"><input type="checkbox"  name="chkfechasPer" onclick="verificarFechaPersona(this)">Reporte con fechas de personal</td>
                    </tr>
                    <tr class="outputText2" id="rowFechaInicioPersonal" style="display:none">
                        <td >De fecha de ingreso personal:
                        </td>
                        <td >::</td>
                        <td >
                            <input type="text"  size="12"  value="<%=fechaInicioper%>" name="fecha_inicioPer" class="inputText">
                            <img id="imagenFechaPer1" src="../../../img/fecha.bmp">
                            <DLCALENDAR tool_tip="Seleccione la Fecha"
                                        daybar_style="background-color: DBE1E7;
                                        font-family: verdana; color:000000;"navbar_style="background-color: 7992B7; color:ffffff;"
                                        input_element_id="fecha_inicioPer" click_element_id="imagenFechaPer1">
                             </DLCALENDAR>
                        </td>
                    </tr>

                    <tr class="outputText2" id="rowFechaFinalPersonal" style="display:none">
                        <td>A fecha de salida personal:
                        </td>
                        <td >::</td>
                        <td>
                            <input type="text"  size="12"  value="<%=fechaFinalper%>" name="fecha_finalPer" class="inputText">
                            <img id="imagenFechaPer2" src="../../../img/fecha.bmp">
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
            <input type="hidden" name="codCompProdP">
            <input type="hidden" name="nombreComProdP">
            <input type="hidden" name="codAreaEmpresaP">
            <input type="hidden" name="nombreAreaEmpresaP">
            <input type="hidden" name="desdeFechaP">
            <input type="hidden" name="hastaFechaP">
            <input type="hidden" name="desdeFechaPers">
            <input type="hidden" name="hastaFechaPers">
            <input type="hidden" name="reporteconfechas">
            <input type="hidden" name="reporteLotes"/>
            <input type="hidden" name="reporteconfechasPer">
            <input type="hidden" name="nombreEstado">
            <input type="hidden" name="nombreTipoActividad">



        </form>
        <script type="text/javascript" language="JavaScript"  src="../../js/dlcalendar.js"></script>
    </body>
</html>