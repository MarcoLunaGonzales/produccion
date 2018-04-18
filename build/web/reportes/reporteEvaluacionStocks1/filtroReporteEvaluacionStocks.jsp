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
            {   //sacar el valor del multiple
                /***** TIPO CLIENTE ******/
                var arrayCodTipoCliente=new Array();
                var arrayNombreTipoCliente=new Array();
		var j=0;
		for(var i=0;i<=f.codTipoCliente.options.length-1;i++)
		{	if(f.codTipoCliente.options[i].selected)
			{	arrayCodTipoCliente[j]=f.codTipoCliente.options[i].value;
                arrayNombreTipoCliente[j]=f.codTipoCliente.options[i].innerHTML;
				j++;
			}
		}
                f.codTipoClienteP.value=arrayCodTipoCliente;
                f.nombreTipoClienteP.value=arrayNombreTipoCliente;

          // ALMACEN DE PRODUCTOS TERMINADOS

          var arrayCodAlmacenVenta=new Array();
          var arrayNombreAlmacenVenta=new Array();
          j=0;
            for(var i=0;i<=f.codTipoCliente.options.length-1;i++)
            {	if(f.codTipoCliente.options[i].selected)
			{	arrayCodAlmacenVenta[j]=f.codAlmacenVenta.options[i].value;
                arrayNombreAlmacenVenta[j]=f.codAlmacenVenta.options[i].innerHTML;
				j++;
			}
		}
        f.codAlmacenVentaP.value=arrayCodAlmacenVenta;
        f.nombreAlmacenVentaP.value=arrayNombreAlmacenVenta;
        f.fechaFinalP.value =f.fecha2.value;
        
                f.action="navegadorReporteEvaluacionStocks.jsf";
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
        <h4 align="center">Evaluacion de Stocks</h4>
        <form method="post" action="navegadorReporteEvaluacionStocks.jsf" name="form1" target="_blank">
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
                        <td>&nbsp;&nbsp;<b>Tipo de Cliente</b></td>
                        <td><b>::</b>&nbsp;</td>
                        <%
                        try{
                            con=Util.openConnection(con);
                            Statement st4 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                            String sql4="select DISTINCT tc.cod_tipocliente,tc.nombre_tipocliente";
                            sql4+=" from USUARIOS_TIPOCLIENTE utc,tipos_cliente tc";
                            sql4+=" where utc.COD_TIPOCLIENTE = tc.cod_tipocliente and tc.cod_estado_registro = 1";
                            sql4+=" order by tc.nombre_tipocliente asc";
                            System.out.println(sql4);
                            ResultSet rs4 = st4.executeQuery(sql4);
                        %>
                        <td>
                            <select name="codTipoCliente" size="8" class="outputText2" multiple onchange="chk_todoTipoCliente.checked = false;">
                                <%
                                String codTipoCliente="", nombreTipoCliente="";
                                while(rs4.next()){
                                    codTipoCliente=rs4.getString("cod_tipocliente");
                                    nombreTipoCliente=rs4.getString("nombre_tipocliente");
                                %>
                                <option value="<%=codTipoCliente%>"><%=nombreTipoCliente%></option>
                                <%
                                }
                                %>
                            </select>
                            <input type="checkbox" value="0" onclick="sel_todoTipoCliente(form1)" name="chk_todoTipoCliente">Todo
                            <%

                            } catch(Exception e) {
                                e.printStackTrace();
                            }
                            %>
                        </td>
                    </tr>

                    <tr class="outputText3" >
                        <td class=""><b>Almacen de Productos Terminados</b></td>
                        <td class="">::</td>
                        <%
        try {
            con = Util.openConnection(con);
            System.out.println("con:::::::::::::" + con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            String sql = " SELECT A.COD_ALMACEN_VENTA,A.NOMBRE_ALMACEN_VENTA,A.COD_AREA_EMPRESA FROM ALMACENES_VENTAS A WHERE A.COD_AREA_EMPRESA=1; ";

            System.out.println("sql filtro:" + sql);
            ResultSet rs = st.executeQuery(sql);
                        %>

                        <td class="">
                            <select name="codAlmacenVenta" size="10" class="inputText" multiple onchange="chk_todoAlmacen.checked = false;">
                                <%
                            String codAlmacenVenta = "";
                            String nombreAlmacenVenta= "";
                            while (rs.next()) {
                                codAlmacenVenta = "'"+rs.getString("COD_ALMACEN_VENTA")+"'";
                                nombreAlmacenVenta = rs.getString("NOMBRE_ALMACEN_VENTA");
                                %>
                                <option value="<%=codAlmacenVenta%>"><%=nombreAlmacenVenta%></option>
                                <%
                            }%>
                            </select>
                            <input type="checkbox"  onclick="almacenVentaSeleccionarTodo_change(form1)" name="chk_todoAlmacen" >Todo
                            <%

        } catch (Exception e) {
        }
                            %>
                        </td>
                    </tr>

                    <tr class="outputText3">
                        <td>&nbsp;&nbsp;<b>Capitulo</b></td>
                        <td><b>::</b>&nbsp;</td>
                        <%
                        try{
                            con=Util.openConnection(con);
                            Statement st4 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                            String sql4="select cod_capitulo,nombre_capitulo from capitulos";
                            sql4 += " where cod_estado_registro=1 order by nombre_capitulo";
                            System.out.println(sql4);
                            ResultSet rs4 = st4.executeQuery(sql4);
                        %>
                        <td>
                            <select name="codCapitulo" class="outputText2" onchange="capitulo_change(this.value)">
                                <%
                                String codCapitulo="", nombreCapitulo="";
                                while(rs4.next()){
                                    codCapitulo=rs4.getString("cod_capitulo");
                                    nombreCapitulo=rs4.getString("nombre_capitulo");
                                %>
                                <option value="<%=codCapitulo%>"><%=nombreCapitulo%></option>
                                <%
                                }
                                %>
                            </select>                            
                            <%

                            } catch(Exception e) {
                                e.printStackTrace();
                            }
                            %>
                        </td>
                    </tr>

                    <tr class="border">
                    <td>&nbsp;&nbsp;<b>Grupos</b></td>
                    <td >::</td>
                    <td>
                        <div id="div_grupo">
                            <select name="codGrupo" id="codGrupo" class="inputText2" >
                                <option>Seleccione una opcion</option>
                            </select>
                        </div>
                    </td>
                    </tr>


                    <%
                    Date fechaSistema=new Date();
                    SimpleDateFormat formatoFecha = new SimpleDateFormat("dd/MM/yyyy");
                    String fechaActual = formatoFecha.format(fechaSistema);
                    String[] fechaIniMes = fechaActual.split("/");
                    String fechaInicioMes="01/"+fechaIniMes[1]+"/"+fechaIniMes[2];
                    
                    %>                    
                    
                    <tr class="outputText3">
                        <td>&nbsp;&nbsp;<b>A Fecha</b></td>
                        <td>&nbsp;&nbsp;<b>::</b>&nbsp;&nbsp;</td>
                        <td>
                            <input type="text" class="outputText3" size="16"  value="<%=fechaActual%>" name="fecha2" >
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
                <input type="button" class="commandButtonR" size="35" value="Ver Reporte" name="reporte" onclick="enviarForm1(form1)">
                <input type="reset"   class="commandButtonR"  size="35" value="Limpiar" name="limpiar">
            </center>


            <input type="hidden" name="codAlmacenVentaP">
            <input type="hidden" name="codTipoClienteP">
            <input type="hidden" name="nombreAlmacenVentaP">
            <input type="hidden" name="nombreTipoClienteP">
            <input type="hidden" name="fechaFinalP">
                




        </form>
        <script type="text/javascript" language="JavaScript"  src="../../js/dlcalendar.js"></script>
    </body>
</html>