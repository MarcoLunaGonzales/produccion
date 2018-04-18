<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ page language="java" %>
<%@ page import="com.cofar.web.*" %>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.sql.DriverManager"%> 
<%@ page import = "java.sql.ResultSet"%> 
<%@ page import = "java.sql.Statement"%> 
<%@ page import = "java.util.Date"%>
<%@ page import = "java.text.SimpleDateFormat"%>
<%@ page import="com.cofar.util.*" %>
<%@ page language="java" import="java.util.*" %>
<%@ page errorPage="ExceptionHandler.jsp" %>


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

                ajax.open("GET","ajaxArea.jsf?codProgramaProduccion="+(f.codProgramaProdPeriodo.value),true);
                ajax.onreadystatechange=function(){
                    if (ajax.readyState==4) {                        
                        div_area.innerHTML=ajax.responseText;
                    }
                }
                f.codCompProd.options.length=0;
                ajax.send(null);
                

            }

            function ajaxProductos(f){
                
                var div_producto=document.getElementById("div_producto");
                var arrayCodAreaEmpresa=new Array();
                var j=0;
                for(var i=0;i<=f.codAreaEmpresa.options.length-1;i++)
                {	if(f.codAreaEmpresa.options[i].selected)
                    {	arrayCodAreaEmpresa[j]=f.codAreaEmpresa.options[i].value;
                        j++;
                    }
                }
                
                ajax=nuevoAjax();

                ajax.open("GET","ajaxProducto.jsf?codProgramaProduccion="+(f.codProgramaProdPeriodo.value)+
                    "&codEstadoPrograma="+(f.codEstadoPrograma.value)+"&codAreaEmpresa="+arrayCodAreaEmpresa,true);
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

       function verReporte(f){
           
       //sacar el valor del multiple
        /***** AREAS EMPRESA ******/

        //alert(document.getElementById('codProgramaProdPeriodo').options[document.getElementById('codProgramaProdPeriodo').selectedIndex].innerHTML);
        
        //maquinas
        
       
        //f.nombreCompProd.value=arrayNombreMaquina;

        /*******************/

        //programa produccion
        
        var arrayCodProgramaProduccion=new Array();
        var arrayNombreProgramaProduccion=new Array();
        j=0;
        for(var i=0;i<=f.codProgramaProdPeriodo.options.length-1;i++)
        {	if(f.codProgramaProdPeriodo.options[i].selected)
            {	arrayCodProgramaProduccion[j]=f.codProgramaProdPeriodo.options[i].value;
                arrayNombreProgramaProduccion[j]=f.codProgramaProdPeriodo.options[i].innerHTML;
                j++;
            }
        }

        //maquinas
        var arraycodMaquina=new Array();
        var arrayNombreMaquina=new Array();
        var j=0;
        for(var i=0;i<=f.codMaquina.options.length-1;i++)
        {	if(f.codMaquina.options[i].selected)
            {	arraycodMaquina[j]=f.codMaquina.options[i].value;
                arrayNombreMaquina[j]=f.codMaquina.options[i].innerHTML;
                j++;
            }
        }
        f.codMaquinaP.value=arraycodMaquina;

        f.codProgramaProd.value=arrayCodProgramaProduccion;
        f.nombreProgramaProd.value=arrayNombreProgramaProduccion;

        /************************/
       // f.desdeFechaP.value=f.fecha_inicio.value;
       // f.hastaFechaP.value=f.fecha_final.value;

       /*
        if(f.codTipoReporteDetallado.value==1){
            f.action="reporteSeguimientoProgramaProduccion.jsf";
        }else{
            f.action="reporteSeguimientoProgramaProduccionResumido.jsf";
        }
       */       
        if(f.codTipoReporte.value==1){
        f.action="reporteTiempoMaquinariaProgramaProduccion.jsf";
        }
        if(f.codTipoReporte.value==2){
        f.action="reporteTiempoPeriodoMaquinariaProgramaProduccion.jsf";
        }        
        f.submit();
    }
        function areaEmpresa_change(f){

        

        
        alert("entro333333333333");
        /*var arrayCodAreaEmpresa=new Array();
        var arrayNombreAreaEmpresa=new Array();
        var j=0;
        for(var i=0;i<=f.codAreaEmpresa.options.length-1;i++)
        {	if(f.codAreaEmpresa.options[i].selected)
            {	arrayCodAreaEmpresa[j]=f.codAreaEmpresa.options[i].value;
                arrayNombreAreaEmpresa[j]=f.codAreaEmpresa.options[i].innerHTML;
                j++;
            }
        }

        f.codAreaEmpresaP.value=arrayCodAreaEmpresa;
        f.nombreAreaEmpresaP.value=arrayNombreAreaEmpresa;
        */

            f.chk_todoArea.checked=false
           // location.href="filtroReporteSeguimientoProgramaProduccion.jsf?codAreaEmpresa="+arrayCodAreaEmpresa;
        }


     function sel_todoMaquina(f){
		for(var i=0;i<=f.codMaquina.options.length-1;i++)
		{   if(f.chk_todoMaquina.checked==true)
            {   f.codMaquina.options[i].selected=true;
            }
            else
            {   f.codMaquina.options[i].selected=false;
            }
		}
        return(true);
       }
       function sel_todoProgramaProd(f){
		for(var i=0;i<=f.codProgramaProdPeriodo.options.length-1;i++)
		{   if(f.chk_todoProgramaProd.checked==true)
            {   f.codProgramaProdPeriodo.options[i].selected=true;
            }
            else
            {   f.codProgramaProdPeriodo.options[i].selected=false;
            }
		}
        return(true);
     }

       function ajaxMaquinas(f){

                var div_maquina=document.getElementById("div_maquina");
                var arrayCodProgramaPeriodo=new Array();
                var j=0;
                for(var i=0;i<=f.codProgramaProdPeriodo.options.length-1;i++)
                {	if(f.codProgramaProdPeriodo.options[i].selected)
                    {	arrayCodProgramaPeriodo[j]=f.codProgramaProdPeriodo.options[i].value;
                        j++;
                    }
                }
                
                ajax=nuevoAjax();
                ajax.open("GET","ajaxMaquina.jsf?codProgramaProduccion="+(arrayCodProgramaPeriodo),true);
                ajax.onreadystatechange=function(){
                    if (ajax.readyState==4) {
                        div_maquina.innerHTML=ajax.responseText;
                    }
                }
                ajax.send(null);
            }

        </script>

    </head>
    <body><br><br>
        <h3 align="center">Reporte de Tiempos de Maquinaria en Programa Produccion</h3>

        <form method="post" action="reporteTiempoMaquinariaProgramaProduccion.jsp" target="_blank" name="form1">
            <div align="center">
                <table border="0"  border="0" class="border" width="40%">
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
           try {
            con = Util.openConnection(con);            
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            String sql = "SELECT PP.COD_PROGRAMA_PROD,PP.NOMBRE_PROGRAMA_PROD,PP.OBSERVACIONES";
            sql += ",(SELECT EP.NOMBRE_ESTADO_PROGRAMA_PROD FROM ESTADOS_PROGRAMA_PRODUCCION EP WHERE EP.COD_ESTADO_PROGRAMA_PROD = PP.COD_ESTADO_PROGRAMA)";
            sql += " FROM PROGRAMA_PRODUCCION_PERIODO PP WHERE PP.COD_ESTADO_PROGRAMA<>4 and pp.cod_tipo_produccion=1";
            System.out.println("programa de produccion:" + sql);
            ResultSet rs = st.executeQuery(sql);
                        %>
                        <td class="">
                            <select name="codProgramaProdPeriodo" class="outputText3" multiple size="5" style="width:200px" onchange="ajaxMaquinas(form1);chk_todoProgramaProd.checked = false;">
                                <%
                            String codProgramaProduccionPeriodo = "";
                            String nombreProgramaProduccionPeriodo = "";                            
                            while (rs.next()) {
                                codProgramaProduccionPeriodo = rs.getString("COD_PROGRAMA_PROD");
                                nombreProgramaProduccionPeriodo = rs.getString("NOMBRE_PROGRAMA_PROD");                                
                                out.print("<option value="+codProgramaProduccionPeriodo+" >"+nombreProgramaProduccionPeriodo+"</option>");                                
                            }%>
                            </select>
                            <!--  <input type="checkbox"  onclick="selecccionarTodo(form1)" name="chk_todoTipo" >Todo-->
                            <%

        } catch (Exception e) {
            e.printStackTrace();
        }
                            %>
                          <input type="checkbox" value="0" onclick="sel_todoProgramaProd(form1)" name="chk_todoProgramaProd">Todo
                        </td>
                    </tr>
                    
                    <tr class="outputText3">
                        <td>&nbsp;&nbsp;Maquinaria</td>
                        <td>&nbsp;&nbsp;::&nbsp;&nbsp;</td>
                        <td>
                            <div id="div_maquina">
                            <select name="codMaquina"  size="8" class="outputText2" multiple onchange="chk_todoMaquina.checked = false;">
                            </select>
                            </div>
                            <input type="checkbox" value="0" onclick="sel_todoMaquina(form1)" name="chk_todoMaquina">Todo
                        </td>
                    </tr>
                    <%
                    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
                    Date fechaInicial = new Date();
                    Date fechaFinal = new Date();
                    %>

                    <tr class="outputText3">
                        <td>&nbsp;&nbsp;De Fecha</td>
                        <td>&nbsp;&nbsp;::&nbsp;&nbsp;</td>
                        <td>
                            <input type="text" class="outputText3" size="16"  value="<%=sdf.format(fechaInicial)%>" name="fechaInicial" >
                            <img id="imagenFecha1" src="../../img/fecha.bmp">
                            <DLCALENDAR tool_tip="Seleccione la Fecha"
                                        daybar_style="background-color: DBE1E7;
                                        font-family: verdana; color:000000;"navbar_style="background-color: 7992B7; color:ffffff;"
                                        input_element_id="fechaInicial" click_element_id="imagenFecha1">
                            </DLCALENDAR>
                        </td>
                    </tr>
                    
                    <tr class="outputText3">
                        <td>&nbsp;&nbsp;A Fecha</td>
                        <td>&nbsp;&nbsp;::&nbsp;&nbsp;</td>
                        <td>
                            <input type="text" class="outputText3" size="16"  value="<%=sdf.format(fechaFinal)%>" name="fechaFinal" >
                            <img id="imagenFecha2" src="../../img/fecha.bmp">
                            <DLCALENDAR tool_tip="Seleccione la Fecha"
                                        daybar_style="background-color: DBE1E7;
                                        font-family: verdana; color:000000;"navbar_style="background-color: 7992B7; color:ffffff;"
                                        input_element_id="fechaFinal" click_element_id="imagenFecha2">
                            </DLCALENDAR>

                        </td>
                    </tr>
                    <tr class="outputText3">
                        <td>&nbsp;&nbsp;Tipo Reporte</td>
                        <td>&nbsp;&nbsp;::&nbsp;&nbsp;</td>
                        <td>                            
                            <select name="codTipoReporte" class="outputText2">
                                <option value="1" label="POR PROGRAMA PRODUCCION" />
                                <option value="2" label="POR FECHA" />
                            </select>
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
            <input type="hidden" name="codProgramaProd">
            <input type="hidden" name="nombreProgramaProd">

            <input type="hidden" name="codMaquinaP">

            <input type="hidden" name="desdeFechaP">
            <input type="hidden" name="hastaFechaP">



        </form>
        <script type="text/javascript" language="JavaScript"  src="../../js/dlcalendar.js"></script>
    </body>
</html>