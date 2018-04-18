

<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ page language="java" %>
<%@ page import = "java.sql.Statement"%> 
<%@ page import="com.cofar.util.*" %>
<%@ page language="java" import="java.util.*" %>
<%@ page errorPage="ExceptionHandler.jsp" %>
<%@ page import = "java.text.*"%>
<%@ page import="com.cofar.web.*" %>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.sql.DriverManager"%> 
<%@ page import = "java.sql.ResultSet"%> 
<%@ page import = "java.util.Date"%>
<%! Connection con = null;
%>
<%
//con=CofarConnection.getConnectionJsp();
con = Util.openConnection(con);

%>



<html>
    <head>
        <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
<script src="../js/general.js"></script>
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
             
    function selecccionarTodo(f){
        for(var i=0;i<=f.codAreaEmpresa.options.length-1;i++)
	{
            f.codAreaEmpresa.options[i].selected=f.chk_todoTipo.checked;
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
       var arrayCodArea=new Array();
       var arrayNombreArea=new Array();
       var j=0;
       for(var i=0;i<=form1.codAreaEmpresa.options.length-1;i++)
	{
          if(form1.codAreaEmpresa.options[i].selected)
	  {	
            arrayCodArea[j]=form1.codAreaEmpresa.options[i].value;
            arrayNombreArea[j]=form1.codAreaEmpresa.options[i].innerHTML;
            
	    j++;
	  }
	}      

      form1.codigosArea.value=arrayCodArea;
      form1.nombresArea.value=arrayNombreArea;
      form1.nombreProgramaProduccion.value = form1.codProgramaProd.options[form1.codProgramaProd.selectedIndex].text;
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
            
            function clearChild(obj){
                while(obj.hasChildNodes())
                    obj.removeChild(obj.lastChild);
           }
           function validarFecha(oTxt){
                    var bOk = true;
                    /*
                    if (oTxt.value == ""){
                        alert("Fecha inválida");
                        oTxt.focus();
                    }*/
                    if (oTxt.value != ""){
                    bOk = bOk && (valAno(oTxt));
                    bOk = bOk && (valMes(oTxt));
                    bOk = bOk && (valDia(oTxt));
                    bOk = bOk && (valSep(oTxt));
                    if (!bOk){
                        alert("Fecha inválida");
                    //oTxt.value = "";
                    oTxt.focus();
                    }
                  }
                }
               
</script>
         
         
       
    </head>
    <body><br><br>
        <h3 align="center">Reporte Programa Produccion</h3>
        
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
                    <tr class="outputText3" >
                        <td class="">Area de Fabricación</td>
                        <td class="">::</td>
                        <%
                        try {
                            con = Util.openConnection(con);
                            System.out.println("con:::::::::::::" + con);
                            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                            String sql = "select av.COD_AREA_FABRICACION,ae.nombre_area_empresa ";
                            sql += " from areas_fabricacion av,areas_empresa ae ";
                            sql += " where av.COD_AREA_FABRICACION=ae.cod_area_empresa ";
                            System.out.println("sql filtro:" + sql);
                            ResultSet rs = st.executeQuery(sql);
                        %>
                        
                        
                        
                        <td class="">
                         <!--   <select name="codAreaEmpresa" class="outputText3" >-->
                            <select name="codAreaEmpresa" size="4" class="inputText" multiple onchange="form1.chk_todoTipo.checked=false">                                  
                                <%
                                String codAreaEmpresa = "";
                                String nombreAreaEmpresa = "";
                                while (rs.next()) {
                                    codAreaEmpresa = rs.getString("COD_AREA_FABRICACION");
                                    nombreAreaEmpresa = rs.getString("nombre_area_empresa");
                                %>
                                <option value="<%=codAreaEmpresa%>"><%=nombreAreaEmpresa%></option>
                                <%
                                }%>
                            </select>                             
                             <input type="checkbox"  onclick="selecccionarTodo(form1)" name="chk_todoTipo" >Todo
                            <%
                            
                            } catch (Exception e) {
                            }
                            %>
                        </td>
                    </tr>
                    
                    <tr class="outputText3">
                        <td class="">Programa de Producción</td>
                        <td class="">::</td>
                        <%
                        try {
                            con = Util.openConnection(con);
                            System.out.println("con:::::::::::::" + con);
                            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                            String sql = "SELECT PP.COD_PROGRAMA_PROD,PP.NOMBRE_PROGRAMA_PROD,PP.OBSERVACIONES";
                            sql += ",(SELECT EP.NOMBRE_ESTADO_PROGRAMA_PROD FROM ESTADOS_PROGRAMA_PRODUCCION EP WHERE EP.COD_ESTADO_PROGRAMA_PROD = PP.COD_ESTADO_PROGRAMA)";
                            sql += " FROM PROGRAMA_PRODUCCION_PERIODO PP WHERE PP.COD_ESTADO_PROGRAMA<>4";
                            System.out.println("sql filtro:" + sql);
                            ResultSet rs = st.executeQuery(sql);
                        %>
                        <td class="">
                           <select name="codProgramaProd" id="codProgramaProd" class="outputText3" >
                               <option value="-1">-TODOS-</option>
                                <%
                                String codAreaEmpresa = "";
                                String nombreAreaEmpresa = "";
                                while (rs.next()) {
                                    codAreaEmpresa = rs.getString("COD_PROGRAMA_PROD");
                                    nombreAreaEmpresa = rs.getString("NOMBRE_PROGRAMA_PROD");
                                %>
                                <option value="<%=codAreaEmpresa%>"><%=nombreAreaEmpresa%></option>
                                <%
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
                    <tr class="outputText3">
                        <td class="">Lote</td>
                        <td class="">::</td>
                        <td><input class="inputText" value="" id="codLote" name="codLote"/></td>
                    </tr>
                    <%
                        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
                        Date fechaInicial = new Date();
                        Date fechaFinal = new Date();
                    %>
                    <tr class="outputText2">
                        <td>Fecha Inicial</td>
                        <td>::</td>
                        <td>
                            <input type="text"  size="12"  value="<%=sdf.format(fechaInicial)%>" name="fechaInicial" class="inputText" onblur="validarFecha(this);" >
                            <img id="imagenFecha1" src="../img/fecha.bmp">
                            <DLCALENDAR tool_tip="Seleccione la Fecha Inicial"
                                        daybar_style="background-color: DBE1E7; font-family: verdana; color:000000;"
                                        navbar_style="background-color: 7992B7; color:ffffff;"
                                        input_element_id="fechaInicial" click_element_id="imagenFecha1">
                             </DLCALENDAR>
                        </td>
                    </tr>
                    <tr class="outputText2">
                        <td>Fecha Final</td>
                        <td >::</td>
                        <td>
                            <input type="text"  size="12"  value="<%=sdf.format(fechaFinal)%>" name="fechaFinal" class="inputText" onblur="validarFecha(this);">
                            <img id="imagenFecha2" src="../img/fecha.bmp">
                            <DLCALENDAR tool_tip="Seleccione la Fecha Final"
                                        daybar_style="background-color: DBE1E7; font-family: verdana; color:000000;"
                                        navbar_style="background-color: 7992B7; color:ffffff;"
                                        input_element_id="fechaFinal" click_element_id="imagenFecha2">
                             </DLCALENDAR>
                        </td>
                    </tr>
                    
                </table>
                
            </div>
            <br>
            <center>                
                <input type="button" class="commandButton"  value="Ver Reporte" name="reporte" onclick="mandar()" class="btn">
                <input type="hidden" name="codigosArea" id="codigosArea">
                <input type="hidden" name="nombresArea" id="nombresArea">
                <input type="hidden" name="nombreProgramaProduccion" id="nombreProgramaProduccion">                
            </center>
        </form>
        <script type="text/javascript" language="JavaScript"  src="../js/dlcalendar.js"></script>
    </body>
</html>