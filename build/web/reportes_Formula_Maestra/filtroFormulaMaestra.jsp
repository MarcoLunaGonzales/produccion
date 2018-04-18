<%@ page import="java.sql.*" %>
<%@ page import="com.cofar.util.*" %>
<%@ page import="com.cofar.web.*" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%! Connection con=null;
%>
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
	for(var i=0;i<=f.codMaquina.options.length-1;i++)
	{  
          if (f.chk_todoTipo.checked == true){
             f.codMaquina.options[i].selected=true; 
         }else{
            f.codMaquina.options[i].selected=false; 
         }    
        } 
       return(true);
    }
    
    
function selecccionarTodo2(f){
  for(var i=0;i<=f.codprograma.options.length-1;i++)
	{  
          if (f.chk_todoTipo2.checked == true){
             f.codprograma.options[i].selected=true; 
         }else{
            f.codprograma.options[i].selected=false; 
         }    
        } 
       return(true);
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
		{  
                  
                    if(f.chk_todoLinea.checked==true)
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
        var arrayCodProd=new Array();
        var j=0;
        for(var i=0;i<=form1.codprograma.options.length-1;i++)
        {  if(form1.codprograma.options[i].selected)
           {	
             arrayCodProd[j]=form1.codprograma.options[i].value;
             j++;
           }
        }  
        form1.codigosPrograma.value=arrayCodProd; 
      /*  
        var arrayFechaI=new Array();
        var h=0;
        for(var h = 0; h <= form1.FechaI.options.length-1;h++)
        {
          if (form1.FechaI.option[h].selected)
          {
            arrayFechaI[h] = form1.FechaI.option[h].value;
            h++;
          }
        }
        form1.FechaInicial.value = arrayFechaI
        
        var arrayFechaF = new Array();
        var k = 0;
        for(var k = 0;k <= form1.FechaF.option.length-1;k++)
        {
          if (form1.Fechaf.option[k].selected)
          {
            arrayFechaF[k] = form1.FechaF.option[k].value;
            k++;
          }
        }
        form1.FechaFinal.value  = arrayFechaF;
      
      
       // alert(form1.FechaInicial.value);
       // alert(form1.FechaFinal.value);
     */
      //  alert(form1.codigosPrograma.value);
        form1.action="navegadorFormulaMaestra.jsf";
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
               
</script>

<html>
    <head>
        <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
    </head>
    <title>
       Reporte Formula Maestra
    </title>
    <body>
        
        <form method="post" action="ventasAnoMovilZona.jsf" name="form1" target="_blank">
            <div align="center">
                <h4 align="center">REPORTE  DE  VERIFICACION  BACO  -  ATLAS (Fórmulas Maestras)</h4>
                
                <table border="0"  border="0" class="outputText2"  style="border:1px solid #000000"  cellspacing="0">    
                    <tr class="headerClassACliente">
                        <td  colspan="3" >
                            <div class="outputText2" align="center">
                                
                            </div>    
                        </td>
                    </tr>    
                    <tr><td>&nbsp;</td></tr>
                                       
                    <%
                    Date fechaSistema=new Date();
                    SimpleDateFormat formatoFecha = new SimpleDateFormat("dd/MM/yyyy");
                    String fechaActual = formatoFecha.format(fechaSistema);
                    String[] fechaIniMes = fechaActual.split("/");
                    String fechaInicioMes="01/"+fechaIniMes[1]+"/"+fechaIniMes[2];                    
                    con=Util.openConnection(con);
                    %> 
                    
                    <tr class="outputText3">
                        <td>&nbsp;&nbsp;<b>Programa Producción</b></td>
                        <td>&nbsp;&nbsp;<b>::</b>&nbsp;&nbsp;</td>
                        <%
                        try{
                             String sqla  = " select distinct cp.COD_COMPPROD, cp.nombre_prod_semiterminado ";
                                    sqla += " from componentes_prod cp ";
                                    sqla += " order by cp.nombre_prod_semiterminado ";
                            Statement stmt = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                            ResultSet rs = stmt.executeQuery(sqla);
                        %>
                        <td>
                            <select name="codprograma" size="4" class="inputText" multiple onchange="form1.chk_todoTipo2.checked=false">
                                <% 
                                String nombre_prod="";
                                String cod_prod="";
                                String codProd = "";
                                while(rs.next()){                                    
                                    codProd = rs.getString(1);
                                    nombre_prod=rs.getString(2);
                                    
                                %>
                                <option value="<%=codProd%>"><%=nombre_prod%></option>
                                <%}%>
                            </select>
                            <input type="checkbox"  onclick="selecccionarTodo2(form1)" name="chk_todoTipo2" >Todo
                            <%
                            
                            } catch(Exception e) {
                          }               
                            %>  
                        </td>
                    
                    <tr class="outputText3">
                        <td>&nbsp;&nbsp;<b>Fecha Inicio</b></td>
                        <td>&nbsp;&nbsp;<b>::</b>&nbsp;&nbsp;</td>
                        <td> 
                            <input type="text"  size="12"  value="" name="fecha_inicio" class="inputText">
                            <img id="imagenFecha1" src="../img/fecha.bmp">                            
                            <DLCALENDAR tool_tip="Seleccione la Fecha"
                                        daybar_style="background-color: DBE1E7;
                                        font-family: verdana; color:000000;"navbar_style="background-color: 7992B7; color:ffffff;"
                                        input_element_id="fecha_Inicio"; click_element_id="imagenFecha1">
                            </DLCALENDAR>
                        </td>
                     </tr>
                     
                    <tr class="outputText2">
                        <td>&nbsp;&nbsp;<b>Fecha Fin</b></td>
                        <td>&nbsp;&nbsp;<b>::</b>&nbsp;&nbsp;</td>
                        <td> 
                            <input type="text"  size="12"  value="" name="fecha_fin" class="inputText">
                            <img id="imagenFecha2" src="../img/fecha.bmp">                            
                            <DLCALENDAR tool_tip="Seleccione la Fecha" 
                                        daybar_style="background-color: DBE1E7;
                                        font-family: verdana; color:000000;"navbar_style="background-color: 7992B7; color:ffffff;"
                                        input_element_id="fecha_Fin"; click_element_id="imagenFecha2">
                            </DLCALENDAR>
                        </td>
                     </tr> 
                     
                                                                           
                    <tr>
                        <td>&nbsp;&nbsp;<b>Porcentaje de Variación</b></td>
                        <td>&nbsp;&nbsp;<b>::</b>&nbsp;&nbsp;</td>
                        <td>
                          <input type="text"  size="12"  value="" name="PorcentajeVariacion" class="inputText">
                        </td>
                    </tr>
                </table>
            </div>
            <br>
            <center>                
                <input type="button" class="commandButtonR"  value="Ver Reporte" name="reporte" onclick="mandar();">                
                <input type="reset"   class="commandButtonR"  value="Limpiar" name="limpiar">
            </center>
            <input type="hidden" name="codMaquinaF" id="codMaquinaF">
            <input type="hidden" name="codigosPrograma" id="codigosPrograma"> 
            <input type="hidden" name="FechaInicial" id="FechaInicial"> 
            <input type="hidden" name="FechaFinal" id="FechaFinal"> 
            <input type="hidden" name="PORCENTAJE_VARIACION" id="PORCENTAJE_VARIACION"> 
        </form>
        <script type="text/javascript" language="JavaScript"  src="../js/dlcalendar.js"></script>
    </body>
</html>
