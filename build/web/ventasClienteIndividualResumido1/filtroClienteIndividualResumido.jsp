<%@ page import="java.sql.*" %>
<%@ page import="com.cofar.util.*" %>
<%@ page import="com.cofar.web.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>

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

<script type="text/javascript" src="../../js/general.js"></script>
<script language="javascript">
            function enviarForm(f)
            {   //sacar el valor del multiple
                /***** AREAS EMPRESA ******/
                f.codArea.value=f.codAreaEmpresa.value;
                /*************************** LINEA MKT *************************/
                var arrayLineaMkt=new Array();
                var arrayLineaMkt1=new Array();
		var j=0;
		for(var i=0;i<=f.codLineaMkt.options.length-1;i++)
		{	if(f.codLineaMkt.options[i].selected)
			{	arrayLineaMkt[j]=f.codLineaMkt.options[i].value;
                                arrayLineaMkt1[j]=f.codLineaMkt.options[i].innerHTML;
				j++;
			}
		}                
                f.codLinea.value=arrayLineaMkt;   
                f.nombreLinea.value=arrayLineaMkt1;                   
                /*************************** CLIENTE *************************/
                var arrayCliente=new Array();
                var arrayCliente1=new Array();
		var j=0;
		for(var i=0;i<=f.codcliente.options.length-1;i++)
		{	if(f.codcliente.options[i].selected)
			{	arrayCliente[j]=f.codcliente.options[i].value;
                                arrayCliente1[j]=f.codcliente.options[i].innerHTML;
				j++;
			}
		}                           
                f.codCliente.value=arrayCliente;
                f.nombreCliente.value=arrayCliente1;
                /*************************** TIPO DE CLIENTE *************************/
                var arrayTipoCliente=new Array();
                var arrayTipoCliente1=new Array();
		var j=0;
		for(var i=0;i<=f.codTipoCliente.options.length-1;i++)
		{	if(f.codTipoCliente.options[i].selected)
			{	arrayTipoCliente[j]=f.codTipoCliente.options[i].value;
                                arrayTipoCliente1[j]=f.codTipoCliente.options[i].innerHTML;
				j++;
			}
		}                           
                f.codTipoClienteF.value=arrayTipoCliente;
                f.nombreTipoClienteF.value=arrayTipoCliente1;                
                if(f.chk_todoTipoCliente.checked==true){
                    f.todoTipoClienteF.value=1;
                }else{                    
                    f.todoTipoClienteF.value=0;
                }
                if(f.chk_todoCliente.checked==true){
                    f.todoClienteF.value=1;
                }else{                    
                    f.todoClienteF.value=0;
                }
                if(f.chk_todoLineaMkt.checked==true){
                    f.todoLineaF.value=1;
                }else{                    
                    f.todoLineaF.value=0;
                }                
                /*************************** CADENA CIENTE *************************/
                f.codCadena.value=f.codcadena.value;
                /*************************** RED CLIENTE *************************/
                f.codRed.value=f.codred.value;                
                f.action="rptClienteIndividualResumido.jsf";
                f.submit();
            }
            function sel_todoLineaMkt(f){
		for(var i=0;i<=f.codLineaMkt.options.length-1;i++)
		{   if(f.chk_todoLineaMkt.checked==true)
                    {   f.codLineaMkt.options[i].selected=true;                        
                    }
                    else
                    {   f.codLineaMkt.options[i].selected=false;
                    }
		} 
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

            /*******************************************************************/
            /****************** AJAX CLIENTE ********************/
            function ajaxClientes(f)
            {	
		var div_cliente;
		div_cliente=document.getElementById("div_cliente");
		codigo=f.codAreaEmpresa.value;	
		ajax=nuevoAjax();
		ajax.open("GET","../utiles/ajaxClienteMultiple.jsf?codigo="+codigo+"&sw=1",true);                
		ajax.onreadystatechange=function(){
			if (ajax.readyState==4) {
                        div_cliente.innerHTML=ajax.responseText;
                        ajaxCadenaCliente(f);                        
		    }
                }                
		ajax.send(null)                                
            }
            /*********************    VALIDAR CLIENTE     *********************/
            function validarCadena(obj,f){                   
                if(obj.value!=0){
                    form1.codred.value=0;
                    form1.codcliente.value=0;
                    var div_cliente;
                    div_cliente=document.getElementById("div_cliente");
                    codigo=obj.value;	
                    ajax=nuevoAjax();
                    ajax.open("GET","../utiles/ajaxClienteMultiple.jsf?codigo="+codigo+"&sw=2",true);                
                    ajax.onreadystatechange=function(){
                            if (ajax.readyState==4) {
                            div_cliente.innerHTML=ajax.responseText;
                        }
                    }                
                    ajax.send(null);
                 }else{
                    ajaxClientes(f);
                 }
            }
            
            function validarRed(obj){                                    
                    form1.codcadena.value=0;
                    form1.codcliente.value=0;                
            }            
            function validarCliente(obj){    
                form1.chk_todoCliente.checked=false;
                    /*form1.codcadena.value=0;
                    form1.codred.value=0;*/
            }
            /**********************************************************/
            function sel_todoCliente(f){
		for(var i=0;i<=f.codcliente.options.length-1;i++)
		{   if(f.chk_todoCliente.checked==true)
                    {   f.codcliente.options[i].selected=true;                        
                    }
                    else
                    {   f.codcliente.options[i].selected=false;
                    }
		} 
                return(true);
            }
            /**********************************************************/
            function sel_todoTipoCliente(f){
                var arrayTipoCliente=new Array();
                var j=0;
		for(var i=0;i<=f.codTipoCliente.options.length-1;i++)
		{   if(f.chk_todoTipoCliente.checked==true)
                    {   f.codTipoCliente.options[i].selected=true;
                        arrayTipoCliente[j]=f.codTipoCliente.options[i].value;
			j++;
                    }
                    else
                    {   f.codTipoCliente.options[i].selected=false;
                    }
		}
                if(f.chk_todoTipoCliente.checked==false){
                    arrayTipoCliente="1";
                }
		var div_cliente;
		div_cliente=document.getElementById("div_cliente");
                codigoArea=f.codAreaEmpresa.value;                
		codigo=arrayTipoCliente;
		ajax=nuevoAjax();
		ajax.open("GET","../utiles/ajaxClienteMultiple.jsf?codigo="+codigo+"&sw="+codigoArea,true);
		ajax.onreadystatechange=function(){
			if (ajax.readyState==4) {
                        div_cliente.innerHTML=ajax.responseText;
		    }
                }                
		ajax.send(null)
                return(true);
            }                        
            /*******************************************************************/
            /****************** AJAX TIPO CLIENTE ********************/
            function ajaxTipoClientes(f)
            {	        
                var arrayTipoCliente=new Array();                
		var j=0;
		for(var i=0;i<=f.codTipoCliente.options.length-1;i++)
		{	if(f.codTipoCliente.options[i].selected)
			{	arrayTipoCliente[j]=f.codTipoCliente.options[i].value;                                
				j++;
			}
		}                
		var div_cliente;
		div_cliente=document.getElementById("div_cliente");
                codigoArea=f.codAreaEmpresa.value;
		codigo=arrayTipoCliente;
		ajax=nuevoAjax();
		ajax.open("GET","../utiles/ajaxClienteMultiple.jsf?codigo="+codigo+"&sw="+codigoArea,true);
		ajax.onreadystatechange=function(){
			if (ajax.readyState==4) {
                        div_cliente.innerHTML=ajax.responseText;
		    }
                }                
		ajax.send(null)
            }
            function desabilitarTipoCliente(f){            
                f.chk_todoTipoCliente.checked=false;
            }
            function desabilitarLinea(f){            
                f.chk_todoLineaMkt.checked=false;
            }
            /*******************************************************************/
            /****************** AJAX CADENA CLIENTE ********************/
            function ajaxCadenaCliente(f)
            {	
		var div_cadenacliente;
		div_cadenacliente=document.getElementById("div_cadenacliente");
		codigo=f.codAreaEmpresa.value;	
		ajax=nuevoAjax();
		ajax.open("GET","../utiles/ajaxCadena.jsf?codAreaEmpresa="+codigo,true);
		ajax.onreadystatechange=function(){
			if (ajax.readyState==4) {
                        div_cadenacliente.innerHTML=ajax.responseText;
                        ajaxRedCliente(f);
		    }
                }                
		ajax.send(null)                                
            }
            /*******************************************************************/
            /****************** AJAX RED CLIENTE ********************/
            function ajaxRedCliente(f)
            {	
		var div_redcliente;
		div_redcliente=document.getElementById("div_redcliente");
		codigo=f.codAreaEmpresa.value;	
		ajax=nuevoAjax();
		ajax.open("GET","../utiles/ajaxRed.jsf?codAreaEmpresa="+codigo,true);
		ajax.onreadystatechange=function(){
			if (ajax.readyState==4) {
                        div_redcliente.innerHTML=ajax.responseText;
		    }
                }                
		ajax.send(null)                                
            }            
</script>

<html>
    <head>
        <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
    </head>
    <body>        
        <h4 align="center">Ventas por Cliente Individual Resumido</h4>
        <form method="post" action="rptClienteIndividualResumido.jsf" name="form1" target="_blank">
            <div align="center">
                <table border="0" class="outputText2" style="border:1px solid #000000" cellspacing="0" cellpadding="0">    
                    <tr class="headerClassACliente">
                        <td  colspan="3" >
                            <div class="outputText2" align="center">
                                Introduzca los Parámetros de Búsqueda
                            </div>    
                        </td>                        
                    </tr>
                    <tr><td>&nbsp;</td></tr>
                    <tr class="outputText3">
                        <td>&nbsp;&nbsp;<b>Agencia</b></td>
                        <td>&nbsp;&nbsp;<b>::</b>&nbsp;&nbsp;</td>
                        <%
                        String codAreaEmpresa="";
                        ManagedAccesoSistema obj=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
                        
                        try{
                            con=Util.openConnection(con);
                            Statement st1 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                            String sql1="select av.cod_area_empresa,ae.nombre_area_empresa ";
                            sql1+=" from agencias_venta av,areas_empresa ae, usuarios_agencia ua  ";
                            sql1+=" where ua.cod_area_empresa=ae.cod_area_empresa and ua.cod_area_empresa=av.cod_area_empresa and " +
                                    "av.cod_area_empresa=ae.cod_area_empresa and ua.cod_personal="+obj.getUsuarioModuloBean().getCodUsuarioGlobal();
                            ResultSet rs1 = st1.executeQuery(sql1);
                        %> 
                        <td>
                            <select name="codAreaEmpresa" class="outputText3" onChange="ajaxClientes(this.form)" >
                                <option value="0"></option>
                                <% 
                                String cod_area_empresa="", nombre_area_empresa="";
                                while(rs1.next()){
                                    cod_area_empresa=rs1.getString("cod_area_empresa");
                                    nombre_area_empresa=rs1.getString("nombre_area_empresa");
                                    codAreaEmpresa=cod_area_empresa;
                                %>
                                <option value="<%=cod_area_empresa%>"><%=nombre_area_empresa%></option>
                                <%
                                }
                                %>
                            </select>                            
                            <%
                            st1.close();
                            rs1.close();
                        } catch(Exception e) {
                        }               
                            %>  
                        &nbsp;&nbsp;</td>
                    </tr>
                    <tr>
                        <td >&nbsp;&nbsp;<b>Cadena</b></td>
                        <td>&nbsp;&nbsp;<b>::</b>&nbsp;&nbsp;</td>
                        <td>
                            <div id="div_cadenacliente">
                                <select name="codcadena" class="inputText2"  >
                                    <option><b>---</b></option>
                                </select>                                
                            </div>                                                                                                                                                
                        </td>
                    </tr>
                    <tr>
                        <td >&nbsp;&nbsp;<b>Red</b></td>
                        <td>&nbsp;&nbsp;<b>::</b>&nbsp;&nbsp;</td>
                        <td>
                            <div id="div_redcliente">
                                <select name="codred" class="inputText2"  >
                                    <option><b>---</b></option>
                                </select>                                
                            </div>                                                                                                                                                
                        </td>
                    </tr>                                        
                    <tr class="outputText3">
                        <td>&nbsp;&nbsp;<b>Tipo de Cliente</b></td>
                        <td>&nbsp;&nbsp;<b>::</b>&nbsp;&nbsp;</td>
                        <%
                        try{
                            String sql4="select tc.cod_tipocliente,tc.nombre_tipocliente";
                            sql4+=" from USUARIOS_TIPOCLIENTE utc,tipos_cliente tc";
                            sql4+=" where utc.COD_TIPOCLIENTE = tc.cod_tipocliente and tc.cod_estado_registro = 1";
                            sql4+=" and utc.COD_PERSONAL = "+obj.getUsuarioModuloBean().getCodUsuarioGlobal();
                            sql4+=" order by tc.nombre_tipocliente asc";
                            Statement st4 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                            ResultSet rs4 = st4.executeQuery(sql4);
                        %> 
                        <td>
                            <select id="codTipoCliente" name="codTipoCliente" class="outputText3" size="7" onchange="ajaxTipoClientes(this.form);desabilitarTipoCliente(form1);" multiple >
                                <% 
                                String cod_tipocliente="", nombre_tipocliente="";
                                while(rs4.next()){
                                    cod_tipocliente=rs4.getString("cod_tipocliente");
                                    nombre_tipocliente=rs4.getString("nombre_tipocliente");
                                %>
                                <option value="<%=cod_tipocliente%>"><%=nombre_tipocliente%></option>
                                <%
                                }
                                %>
                            </select>
                            <input type="checkbox" value="0" onclick="sel_todoTipoCliente(form1)" name="chk_todoTipoCliente">Todo
                            <%
                            st4.close();
                            rs4.close();
                        } catch(Exception e) {
                        }               
                            %>  
                        &nbsp;&nbsp;</td>                        
                    </tr>
                    <tr>
                        <td >&nbsp;&nbsp;<b>Cliente</b></td>
                        <td>&nbsp;&nbsp;<b>::</b>&nbsp;&nbsp;</td>
                        <td>
                            <div id="div_cliente">
                                <select name="codcliente" class="inputText2" onchange="validarCliente(this);"  >
                                </select>                                
                            </div>                                                                                                                                                
                        </td>
                    </tr>
                    <tr class="outputText3">
                        <td>&nbsp;&nbsp;<b>Linea</b></td>
                        <td>&nbsp;&nbsp;<b>::</b>&nbsp;&nbsp;</td>
                        <%
                        try{
                            Statement st7 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                            String sql7="select l.cod_lineamkt, l.nombre_lineamkt ";
                            sql7+=" from lineas_mkt l, usuarios_lineasmkt u";
                            sql7+=" where l.cod_lineamkt=u.cod_lineamkt and l.cod_estado_registro=1 and u.cod_personal="+obj.getUsuarioModuloBean().getCodUsuarioGlobal()+" order by nombre_lineamkt ";
                            ResultSet rs7 = st7.executeQuery(sql7);
                        %>
                        <td>
                            <select name="codLineaMkt" size="7" class="outputText3" onchange="desabilitarLinea(this.form)" multiple>
                                <% 
                                String cod_lineamkt="", nombre_lineamkt="";
                                while(rs7.next()){
                                    cod_lineamkt=rs7.getString("cod_lineamkt");
                                    nombre_lineamkt=rs7.getString("nombre_lineamkt");
                                %>
                                <option value="<%=cod_lineamkt%>"><%=nombre_lineamkt%></option>
                                <%
                                }
                                %>
                            </select>
                            <input type="checkbox" value="0" onclick="sel_todoLineaMkt(form1)" name="chk_todoLineaMkt">Todo
                            <%
                            st7.close();
                            rs7.close();
                        } catch(Exception e) {
                        }
                        con.close();
                            %>  
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                    </tr>
                    <%
                    Date fechaSistema=new Date();
                    SimpleDateFormat formatoFecha = new SimpleDateFormat("dd/MM/yyyy");
                    String fechaActual = formatoFecha.format(fechaSistema);
                    String[] fechaIniMes = fechaActual.split("/");
                    String fechaInicioMes="01/"+fechaIniMes[1]+"/"+fechaIniMes[2];                    
                    %>
                    <tr class="outputText3">
                        <td>&nbsp;&nbsp;<b>Fecha Inicio</b></td>
                        <td>&nbsp;&nbsp;<b>::</b>&nbsp;&nbsp;</td>
                        <td>
                            <input type="text" class="outputText3" size="16"  value="<%=fechaInicioMes%>" name="fecha1"  >
                            <img id="imagenFecha1" src="../../img/fecha.bmp">
                            <DLCALENDAR tool_tip="Seleccione la Fecha"
                                        daybar_style="background-color: DBE1E7; 
                                        font-family: verdana; color:000000;"navbar_style="background-color: 7992B7; color:ffffff;" 
                                        input_element_id="fecha1" click_element_id="imagenFecha1">
                            </DLCALENDAR>            
                        </td>
                    </tr>  
                    <tr class="outputText3">
                        <td>&nbsp;&nbsp;<b>Fecha Final</b></td>
                        <td>&nbsp;&nbsp;<b>::</b>&nbsp;&nbsp;</td>
                        <td>
                            <input type="text" class="outputText3" size="16"  value="<%=fechaActual%>" name="fecha2"  >
                            <img id="imagenFecha2" src="../../img/fecha.bmp">
                            <DLCALENDAR tool_tip="Seleccione la Fecha"
                                        daybar_style="background-color: DBE1E7; 
                                        font-family: verdana; color:000000;"navbar_style="background-color: 7992B7; color:ffffff;" 
                                        input_element_id="fecha2" click_element_id="imagenFecha2">
                            </DLCALENDAR>            
                        </td>
                    </tr>
                    <tr><td>&nbsp;</td></tr>
                </table>
            </div>
            <br>            
            <center>
                <input type="button" class="commandButtonR"  value="Ver Reporte" name="reporte" onclick="enviarForm(form1)">                
                <input type="reset"   class="commandButtonR" value="Limpiar" name="limpiar">
            </center>
            <input type="hidden" name="codArea">
            <input type="hidden" name="codCliente">
            <input type="hidden" name="nombreCliente">
            <input type="hidden" name="codCadena">
            <input type="hidden" name="codRed">
            <input type="hidden" name="codLinea">
            <input type="hidden" name="nombreLinea">
            <input type="hidden" name="codTipoClienteF">
            <input type="hidden" name="nombreTipoClienteF">
            <input type="hidden" name="todoTipoClienteF">
            <input type="hidden" name="todoClienteF">
            <input type="hidden" name="todoLineaF">
        </form>
        <script type="text/javascript" language="JavaScript"  src="../../css/dlcalendar.js"></script>
    </body>
</html>