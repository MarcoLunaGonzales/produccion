<%@ page import="java.sql.*" %>
<%@ page import="com.cofar.util.*" %>
<%@ page import="com.cofar.web.*" %>
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
    .commandButtonR{
    font-family: Verdana, Arial, Helvetica, sans-serif;
    font-size: 11px;
    width: 150px;
    height: 20px;
    background-repeat :repeat-x;
    
    background-image: url('../../img/bar3.png');
    }
</style>
<script type="text/javascript" src="../../js/general.js"></script>
<script language="javascript">
            function enviarForm(f)
            {   
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
            /**********************************************************/
            /****************** AJAX ALMCENES MATPROMOCIONAL ********************/
            function ajaxMatPromocional(f)
            {	
		var div_distrito;                
		div_distrito=document.getElementById("div_distrito");
		codAreaEmpresa=f.codAreaEmpresa.value;	
		ajax=nuevoAjax();
	
		ajax.open("GET","ajaxDistritos.jsf?codAreaEmpresa="+codAreaEmpresa,true);                
		ajax.onreadystatechange=function(){
			if (ajax.readyState==4) {
                        div_distrito.innerHTML=ajax.responseText;
		    }
                }                
		ajax.send(null)                
                var div_zona=document.getElementById("div_zona");
                clearChild(div_zona.firstChild);
            }

            
            function cargarAlmacen(f){
            var codigo=f.codAreaEmpresa.value;            
                location.href="FiltroR_IngresosMatPromocional.jsf?codArea="+codigo;
            }
</script>

<html>
    <head>
        <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
    </head>
    <body>
        <h4 align="center">Reporte De Rendimiento</h4>
        <form method="post" action="reporteIngresosCostos.jsf" name="form1" target="_blank">
            <div align="center">
                <table border="0" class="outputText2" style="border:1px solid #000000"  cellspacing="1" cellpadding="1">    
                    <tr class="headerClassACliente">
                        <td  colspan="3" >
                            <div class="outputText2" align="center">
                                Introduzca los Parámetros de Búsqueda
                            </div>    
                        </td>                        
                    </tr>                                        
                    
                    <tr class="outputText3">
                        <td>&nbsp;&nbsp;<b>Fecha Inicio</b></td>
                        <td><b>::</b>&nbsp;</td>
                        <td>
                            <input type="text" class="outputText3" size="16"  value="" name="fecha1"  >
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
                        <td><b>::</b></td>
                        <td>
                            <input type="text" class="outputText3" size="16"  value="" name="fecha2" >
                            <img id="imagenFecha2" src="../../img/fecha.bmp">
                            <DLCALENDAR tool_tip="Seleccione la Fecha"
                                        daybar_style="background-color: DBE1E7; 
                                        font-family: verdana; color:000000;"navbar_style="background-color: 7992B7; color:ffffff;" 
                                        input_element_id="fecha2" click_element_id="imagenFecha2">
                            </DLCALENDAR>            
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                    </tr>                    
                </table>
            </div>
            <br>            
            <center>
                <input type="submit" class="commandButtonR" value="Ver Reporte" name="reporte" onclick="enviarForm(form1)">                
                <input type="reset"   class="commandButtonR" value="Limpiar" name="limpiar">
            </center>
            <input type="hidden" name="codArea">
            <input type="hidden" name="codAlamcen">
        </form>
        <script type="text/javascript" language="JavaScript"  src="../../css/dlcalendar.js"></script>
    </body>
</html>