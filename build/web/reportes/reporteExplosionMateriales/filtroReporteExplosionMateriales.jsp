<%@ page import="java.sql.*" %>
<%@ page import="com.cofar.util.*" %>
<%@ page import="com.cofar.web.*" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%! Connection con=null;
%>
<script type="text/javascript" src="../../js/general.js"></script>
<script language="javascript">
            function enviarForm(f)
            {   //sacar el valor del multiple
                /***** AREAS EMPRESA ******/
                var arrayareas=new Array();
                var arrayareas1=new Array();
		var j=0;
		for(var i=0;i<=f.codAreaEmpresa.options.length-1;i++)
		{	if(f.codAreaEmpresa.options[i].selected)
			{	arrayareas[j]=f.codAreaEmpresa.options[i].value;
                                arrayareas1[j]=f.codAreaEmpresa.options[i].innerHTML;
				j++;
			}
		}                
                f.codArea.value=arrayareas;
                f.nombreArea.value=arrayareas1;
                if(f.chk_todoAgencia.checked==true){                    
                    f.nombreArea.value="Todo";
                }
                /*********************** TIPO CLIENTE **************************/
                var arrayCliente=new Array();
                var arrayCliente1=new Array();
		var j=0;
		for(var i=0;i<=f.codTipoCliente.options.length-1;i++)
		{	if(f.codTipoCliente.options[i].selected)
			{	arrayCliente[j]=f.codTipoCliente.options[i].value;
                                arrayCliente1[j]=f.codTipoCliente.options[i].innerHTML;
				j++;
			}
		}                
                f.codTipoClienteF.value=arrayCliente;
                f.nombreTipoClienteF.value=arrayCliente1;
                if(f.chk_todoTipoCliente.checked==true){                    
                    f.nombreTipoClienteF.value="Todo";
                }
                /*********************** LINEAS **************************/
                var arrayLineas=new Array();
                var arrayLineas1=new Array();
		var j=0;
		for(var i=0;i<=f.codLinea.options.length-1;i++)
		{	if(f.codLinea.options[i].selected)
			{	arrayLineas[j]=f.codLinea.options[i].value;
                                arrayLineas1[j]=f.codLinea.options[i].innerHTML;
				j++;
			}
		}                
                f.codLineas.value=arrayLineas;
                f.nombreLineas.value=arrayLineas1;
                /*********************** TIPO DE SALIDA VENTA **************************/
                var arrayTipoSalida=new Array();
                var arrayTipoSalida1=new Array();
		var j=0;
		for(var i=0;i<=f.codSalidaVenta.options.length-1;i++)
		{	if(f.codSalidaVenta.options[i].selected)
			{	arrayTipoSalida[j]=f.codSalidaVenta.options[i].value;
                                arrayTipoSalida1[j]=f.codSalidaVenta.options[i].innerHTML;
				j++;
			}
		}                
                f.codSalidaVentaF.value=arrayTipoSalida;
                f.nombreSalidaVentaF.value=arrayTipoSalida1;
                
                if(f.chk_todoLinea.checked==true){                    
                    f.nombreLineas.value="Todo";
                }
                if(f.chk_tipoSalidaVenta.checked==true){                    
                    f.nombreSalidaVentaF.value="Todo";
                }
                var result="";                
                if(f.filtroReporte.value==1){                                        
                    result="rptAnioMovilProductos.jsf";
                }
                if(f.filtroReporte.value==2){
                    result="rptAnioMovilProductosCantidades.jsf";
                }
                if(f.filtroReporte.value==3){
                    result="rptAnioMovilProductosValoresCantidades.jsf";
                }                
                f.action=result;
                f.submit();
            }
            /****************** FUNCION TIPO CLIENTE ********************/
            function sel_todoTipoCliente(f){
		for(var i=0;i<=f.codTipoCliente.options.length-1;i++)
		{   if(f.chk_todoTipoCliente.checked==true)
                    {   f.codTipoCliente.options[i].selected=true;
                    }
                    else
                    {   f.codTipoCliente.options[i].selected=false;
                    }
		} 
                return(true);
            }
            /****************** FUNCION LINEA ********************/
            function sel_todoLinea(f){
		for(var i=0;i<=f.codLinea.options.length-1;i++)
		{   if(f.chk_todoLinea.checked==true)
                    {   f.codLinea.options[i].selected=true;                        
                    }
                    else
                    {   f.codLinea.options[i].selected=false;
                    }
		} 
                return(true);
            }
            /****************** FUNCION AGENCIAS********************/
            function sel_todoAgencia(f){
		for(var i=0;i<=f.codAreaEmpresa.options.length-1;i++)
		{   if(f.chk_todoAgencia.checked==true)
                    {   f.codAreaEmpresa.options[i].selected=true;                        
                    }
                    else
                    {   f.codAreaEmpresa.options[i].selected=false;
                    }
		} 
                return(true);
            }
            /****************** TODO TIPO DE SALIDA ********************/
            function sel_todoTipoSalidaVenta(f){
		for(var i=0;i<=f.codSalidaVenta.options.length-1;i++)
		{   if(f.chk_tipoSalidaVenta.checked==true)
                    {   f.codSalidaVenta.options[i].selected=true;                        
                    }
                    else
                    {   f.codSalidaVenta.options[i].selected=false;
                    }
		} 
                return(true);
            }            
            /****************** FUNCION TIPO CLIENTE ********************/
            function seleccionarTipoClienteVenta(f){
                f.codSalidaVenta.options[2].selected=true;
                f.codAreaEmpresa.options[0].selected=true;
                f.codLinea.options[0].selected=true;
                f.codTipoCliente.options[0].selected=true;
                return(true);
            }




            function enviarForm1(f)
            {

                var arrayCodTipoMaterial=new Array();
                var j=0;
                for(var i=0;i<=f.codTipoMaterial.options.length-1;i++)
                {	if(f.codTipoMaterial.options[i].selected){
                    arrayCodTipoMaterial[j]=f.codTipoMaterial.options[i].value;
                    j++;
                }
                }
                f.codTipoMaterialArray.value=arrayCodTipoMaterial;

                //alert(f.codTipoMaterialArray.value);
                
                if(f.codTodosMateriales.checked){
                    f.codTodoTipoMaterial.value = 1;
                }else{
                    f.codTodoTipoMaterial.value = 0;
                }

                

                //alert(f.codTipoPrograma.value);
                var action = "";
                
                if(f.codTipoPrograma.value==1){
                    action = "navgador_programa_periodo.jsf";
                }
                if(f.codTipoPrograma.value==2){
                    action = "navgador_programa_produccion.jsf";
                }
                

                f.action=action;
                f.submit();
            }

        function almacenVentaSeleccionarTodo_change(f){
		for(var i=0;i<=f.codAlmacenVenta.options.length-1;i++)
		{   if(f.chk_todoAlmacen.checked==true)
                    {   f.codAlmacenVenta.options[i].selected=true;
                    }
                    else
                    {   f.codAlmacenVenta.options[i].selected=false;
                    }
		}
                return(true);
            }

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
        function capitulo_change(codCapitulo){
                //alert();

                var ajax=nuevoAjax();
                var url='grupoAjax.jsp?codCapitulo='+codCapitulo;
                url+='&pq='+(Math.random()*1000);
                // alert(url);
                ajax.open ('GET', url, true);
                ajax.onreadystatechange = function() {
                    //alert(ajax.readyState);
                    if (ajax.readyState==1) {
                        //alert("hola");
                    }else if(ajax.readyState==4){
                        if(ajax.status==200){
                            //alert(ajax.responseText);
                            var divGrupo=document.getElementById('div_grupo');
                            divGrupo.innerHTML=ajax.responseText;
                        }
                    }
                }
                ajax.send(null);
            }

         function obtieneCodigo(f){
              var i;
                    var j=0;
                     //alert(f.personal.value);
                     //alert(f.usuario.value);
                     //alert(f.contrasena.value);
                    codigo=new Array();
                    for(i=0;i<=f.length-1;i++)
                    {
                	if(f.elements[i].type=='checkbox')
                        {	if(f.elements[i].checked==true)
                                {	codigo[j]=f.elements[i].value;
                                	j=j+1;
                                }
                        }
                    }
                    alert(codigo);

         }


            
            
</script>

<html>
    <head>
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
        <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
    </head>
    <body>
        <h4 align="center">Explosion de Materiales</h4>
        <form method="post" action="navegadorReporteEvaluacionStocks.jsf" name="form1" >
            <div align="center">
                <table border="0" class="outputText2" style="border:1px solid #000000" cellspacing="0" cellpadding="0">    
                    <tr class="headerClassACliente">
                        <td  colspan="3" >
                            <div class="outputText2" align="center">
                                Introduzca los Parámetros del Reporte
                            </div>    
                        </td>                        
                    </tr>
                    <tr class="outputText3">
                        <td>&nbsp</td>
                        <td></td>
                        <td></td>
                    </tr>

                    <tr class="outputText3">
                        <td>&nbsp;&nbsp;<b>Capitulo</b></td>
                        <td><b>::</b>&nbsp;</td>                      
                        <td>
                            <select name="codTipoPrograma" id="codTipoPrograma" class="outputText2">
                                <option value="1">Simulacion Programa Produccion</option>
                                <option value="2">Programa Produccion</option>
                            </select>
                        </td>
                    </tr>




                     <tr class="outputText3">
                        <td>&nbsp;&nbsp;<b>Materiales</b></td>
                        <td><b>::</b>&nbsp;</td>
                        <td>
                              <select name="codTipoMaterial" size="5" class="inputText" multiple >
                                <option value="1">Materia Prima</option>
                                <option value="2">Empaque Primario </option>
                                <option value="3">Empaque Secundario</option>
                                <option value="4">Material Reactivo</option>
                                <option value="5">Material Promocional</option>
                              </select>
                        </td>
                    </tr>

                    <tr class="outputText3">
                        <td>&nbsp;&nbsp;<b>Items</b></td>
                        <td><b>::</b>&nbsp;</td>
                        <td>
                            <input type="checkbox" name="codTodosMateriales"  /> Todos los Materiales<br />
                        </td>
                    </tr>

                    <tr class="outputText3">
                        <td>&nbsp</td>
                        <td></td>
                        <td></td>
                    </tr>

                    
                    
                </table>
            </div>
            <br>            
            <center>
                <input type="button" class="commandButtonR" size="35" value="Ver Reporte" name="reporte" onclick="enviarForm1(form1)">
                <input type="reset"   class="commandButtonR"  size="35" value="Limpiar" name="limpiar">
            </center>


            <input type="hidden" name="codAlmacenVentaP">
            <input type="hidden" name="codTipoClienteP">
            <input type="hidden" name="nombreAlmacenVentaP">
            <input type="hidden" name="nombreTipoClienteP">
            <input type="hidden" name="fechaFinalP">
            <input type="hidden" name="codTipoMaterialArray">
            <input type="hidden" name="codTodoTipoMaterial">
                




        </form>
        <script type="text/javascript" language="JavaScript"  src="../../js/dlcalendar.js"></script>
    </body>
</html>