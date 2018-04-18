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
  {
     ajaxDistritos(f);
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
        var arrayMaquina=new Array();
        var j=0;
        for(var i=0;i<=form1.codMaquina.options.length-1;i++)
        {  if(form1.codMaquina.options[i].selected)
           {	
             arrayMaquina[j]=+form1.codMaquina.options[i].value;
             j++;
           }
        }  
        form1.codMaquinaF.value=arrayMaquina;    
        
        var arrayPrograma=new Array();
        var j=0;
        for(var i=0;i<=form1.codprograma.options.length-1;i++)
         {  if(form1.codprograma.options[i].selected)
            {	
              arrayPrograma[j]=form1.codprograma.options[i].value;
              j++;
            }
        }  
        form1.codigosPrograma.value=arrayPrograma;
        form1.action="navegadorReporteMateriaExplocion.jsf";
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
       Explosion de Maquinaria
    </title>
    <body>
        
        <form method="post" action="navegadorReporteMateriaExplocion.jsf" name="form1" target="_blank">
            <div align="center">
                <h4 align="center">Reporte de Explosion de Maquinaria</h4>
                
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
                        <td>&nbsp;&nbsp;<b>Programa Produccion</b></td>
                        <td>&nbsp;&nbsp;<b>::</b>&nbsp;&nbsp;</td>
                        <%
                        try{
                           
                            String sqlPP  = "select p.COD_PROGRAMA_PROD,p.NOMBRE_PROGRAMA_PROD,p.COD_ESTADO_PROGRAMA from PROGRAMA_PRODUCCION_PERIODO p ";
                                   sqlPP += " order by p.NOMBRE_PROGRAMA_PROD";
                            Statement stmt = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                            ResultSet rs = stmt.executeQuery(sqlPP);
                        %>
                        <td>
                            <select name="codprograma" size="7" class="inputText" multiple onchange="form1.chk_todoTipo2.checked=false">
                                <% 
                                String codmaquina="";
                                String nombremaquina="";
                                while(rs.next()){
                                    codmaquina=rs.getString(1);
                                    nombremaquina=rs.getString(2);
                                %>
                                <option value="<%=codmaquina%>"><%=nombremaquina%></option>
                                <%}%>
                            </select>
                            <input type="checkbox"  onclick="selecccionarTodo2(form1)" name="chk_todoTipo2" >Todo
                            <%
                            
                            } catch(Exception e) {
                            }               
                            %>  
                        </td>
                    
                    <tr class="outputText3">
                        <td>&nbsp;&nbsp;<b>Maquinaria</b></td>
                        <td>&nbsp;&nbsp;<b>::</b>&nbsp;&nbsp;</td>
                        <%
                        try{
                            String sql  = "SELECT COD_MAQUINA, CODIGO,NOMBRE_MAQUINA, FECHA_COMPRA, COD_TIPO_EQUIPO, GMP,OBS_MAQUINA,COD_ESTADO_REGISTRO ";
                                   sql += "FROM MAQUINARIAS order by NOMBRE_MAQUINA ";
                            Statement stmt = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                            ResultSet rs = stmt.executeQuery(sql);
                            
                        %>
                        <td>
                            <select name="codMaquina" size="7" class="inputText" multiple onchange="form1.chk_todoTipo.checked=false">
                                <% 
                                String codmaquina="";
                                String nombremaquina="";
                                
                                while(rs.next()){
                                    codmaquina=rs.getString(1);
                                    nombremaquina=rs.getString(3);
                                %>
                                <option value="<%=codmaquina%>"><%=nombremaquina%></option>
                                <%}%>
                            </select>
                            <input type="checkbox"  onclick="selecccionarTodo(form1)" name="chk_todoTipo" id="chk_todoTipo">Todo
                            <%
                            
                            } catch(Exception e) {
                            }               
                            %>  
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
        </form>
       <!-- <script type="text/javascript" language="JavaScript"  src="../css/dlcalendar.js"></script>-->
        <script type="text/javascript" language="JavaScript"  src="../js/dlcalendar.js"></script>
    </body>
</html>







