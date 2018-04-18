--
<%@ page import="java.sql.*" %>
<%@ page import="com.cofar.util.*" %>
<%@ page import="com.cofar.web.*" %>
<%! Connection con=null;
%>
<%! String sql="";
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
    
    background-image: url('../../img/bar3.png');
    }
</style>
<html>
    <head>
        <!--link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" /-->
        <script>
            function cargarAlmacen(f){
            var codigo=f.codAreaEmpresa.value;
                location.href="navegadorKardexmovimientoVentasValorado.jsf?codArea="+codigo;
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
            /****************** AJAX PRODUCTOS ********************/
            function ajaxProducto(f)
            {	                
		var div_producto;
		div_producto=document.getElementById("div_producto");
                var arrayLinea=new Array();                
		var estadoProducto=f.estadoProducto.value;
		ajax=nuevoAjax();
		ajax.open("GET","ajaxProductosEstado.jsf?codEstadoProducto="+estadoProducto,true);                
		ajax.onreadystatechange=function(){
			if (ajax.readyState==4) {                       
                            div_producto.innerHTML=ajax.responseText;
		    }
                }                
		ajax.send(null);
            }

        </script>
    </head>
    <body>
        <h3 align="center" class="tituloCampo">Kardex de Movimiento General</h3>
        <form method="post" action="reporteKardexmovimientoVentasValorado.jsf" name="form1" target="_blank">
            <div align="center">
                <table border="0"  class="outputText2" style="border:1px solid #000000" cellspacing="0">    
                    <tr class="headerClassACliente">
                        <td  colspan="3" >
                            <div class="outputText3" align="center">
                                Introduzca los Parametros de Busqueda
                            </div>    
                        </td>
                        
                    </tr>
                    <tr class="outputText3">
                        <td >&nbsp;&nbsp;<b>Agencia</b></td>
                        <td>&nbsp;&nbsp;<b>::</b>&nbsp;&nbsp;</td>
                        <%
                        ManagedAccesoSistema obj=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
                        try{
                            con=Util.openConnection(con);
                            System.out.println("con:::::::::::::"+con);
                            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                            String sql="select av.cod_area_empresa,ae.nombre_area_empresa ";
                            sql+=" from agencias_venta av,areas_empresa ae, usuarios_agencia ua  ";
                            sql+=" where ua.cod_area_empresa=ae.cod_area_empresa and ua.cod_area_empresa=av.cod_area_empresa and ";
                            sql+=" av.cod_area_empresa=ae.cod_area_empresa and ua.cod_personal="+obj.getUsuarioModuloBean().getCodUsuarioGlobal();
                            ResultSet rs = st.executeQuery(sql);
                        %> 
                        <td>
                            <select name="codAreaEmpresa" class="outputText3" onchange="cargarAlmacen(this.form);"> 
                                <option value="0">Seleccione una opción</option>
                                <%
                                String codAreaEmpresa="";
                                String codAreaEmpresarecibida=request.getParameter("codArea");
                                String nombreAreaEmpresa="";
                                while (rs.next()) {
                                    codAreaEmpresa=rs.getString("cod_area_empresa");
                                    nombreAreaEmpresa=rs.getString("nombre_area_empresa");
                                    if(codAreaEmpresa.equals(codAreaEmpresarecibida)){
                                %>                      <option value="<%=codAreaEmpresa%>" selected><%=nombreAreaEmpresa%></option>				    
                                <%  } else{
                                %>                      <option value="<%=codAreaEmpresa%>"><%=nombreAreaEmpresa%></option>				    
                                <%  }
                                }       %>                
                            </select>
                            <%
                            
                            } catch(Exception e) {
                            }               
                            %>            
                        </td>
                    </tr>
                    
                    <tr class="outputText3">
                        <td>&nbsp;&nbsp;<b>Almacén</b></td>
                        <td>&nbsp;&nbsp;<b>::</b>&nbsp;&nbsp;</td>
                        <%
                        try{
                            String cod_agencia=request.getParameter("codArea");
                            
                            con=Util.openConnection(con);
                            System.out.println("xxxxxxxxxxxxxxxxxxxxxx:con:::::::::::::"+con);
                            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                            sql="select cod_almacen_venta,nombre_almacen_venta";
                            sql+=" from almacenes_ventas";
                            sql+=" where cod_estado_registro=1 ";
                            if (cod_agencia!=null) { sql+=" and cod_area_empresa="+cod_agencia;}
                            sql+=" order by nombre_almacen_venta";
                            ResultSet rs = st.executeQuery(sql);
                        %> 
                        <td>
                            <select name="codAlmacen" class="outputText3"> 
                                <option value="0">Seleccione una opción</option>
                                <%
                                String codAlmacen="";
                                String nombreAlmacen="";
                                while (rs.next()) {
                                    codAlmacen=rs.getString("cod_almacen_venta");
                                    nombreAlmacen=rs.getString("nombre_almacen_venta");
                                
                                %>                      <option value="<%=codAlmacen%>"><%=nombreAlmacen%></option>				    
                                <%                    }
                                %>                
                            </select>
                            <%
                            
                            } catch(Exception e) {
                            }               
                            %>            
                        </td>
                    </tr>
                    <tr class="outputText3">
                        <td>&nbsp;&nbsp;<b>Estado de Producto</b></td>
                        <td>&nbsp;&nbsp;<b>::</b>&nbsp;&nbsp;</td>
                        <td>
                            <select name="estadoProducto" class="outputText3" onchange="ajaxProducto(this.form);">
                                <option value="0">Seleccione una opción</option>
                                <option value=1>Activos</option>
                                <option value=2>Inactivos</option>
                            </select>
                        </td>
                    </tr>
                    <tr class="outputText3">
                        <td>&nbsp;&nbsp;<b>Presentación Producto</b></td>
                        <td>&nbsp;&nbsp;<b>::</b>&nbsp;&nbsp;</td>
                        <%
                        try{
                            Statement st2 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                            String sql2=" select cod_presentacion, nombre_producto_presentacion";
                            sql2+=" from presentaciones_producto";
                            sql2+=" where cod_estado_registro=1";
                            sql2+=" order by nombre_producto_presentacion ";
                            ResultSet rs2 = st2.executeQuery(sql2);
                        %> 
                        <td>
                            <div id="div_producto">
                                <select name="codPresentacion" class="outputText3"> 	
                                    <option value="0">Seleccione una opción</option>
                                    <%
                                    String codPresentacion="";
                                    String nombrePresentacion="";
                                    while (rs2.next()) {
                                    codPresentacion=rs2.getString("cod_presentacion");
                                    nombrePresentacion=rs2.getString("nombre_producto_presentacion");
                                    if(nombrePresentacion==null){
                                    nombrePresentacion="";
                                    }                                    
                                    %>                      <option value="<%=codPresentacion%>"><%=nombrePresentacion%></option>				    
                                    <%                    }
                                    %>                
                                </select>
                            </div>
                            <%
                           
                        } catch(Exception e) {
                        }               
                            %>            
                        </td>
                    </tr>
                    <tr class="outputText3">
                        <td>&nbsp;&nbsp;<b>Fecha Inicio</b></td>
                        <td>&nbsp;&nbsp;<b>::</b>&nbsp;&nbsp;</td>
                        <td>
                            <input type="text" class="outputText3" size="16"  value="" name="fecha_inicio" >
                            <img id="imagenFecha1" src="../../img/fecha.bmp">
                            <DLCALENDAR tool_tip="Seleccione la Fecha"
                                        daybar_style="background-color: DBE1E7; 
                                        font-family: verdana; color:000000;"navbar_style="background-color: 7992B7; color:ffffff;" 
                                        input_element_id="fecha_inicio"; click_element_id="imagenFecha1">
                                        </DLCALENDAR>            
                        </td>
                    </tr>  
                    <tr class="outputText3">
                        <td>&nbsp;&nbsp;<b>Fecha Final</b></td>
                        <td>&nbsp;&nbsp;<b>::</b>&nbsp;&nbsp;</td>
                        <td>
                            <input type="text" class="outputText3" size="16"  value="" name="fecha_final" >
                            <img id="imagenFecha2" src="../../img/fecha.bmp">
                            <DLCALENDAR tool_tip="Seleccione la Fecha"
                                        daybar_style="background-color: DBE1E7; 
                                        font-family: verdana; color:000000;"navbar_style="background-color: 7992B7; color:ffffff;" 
                                        input_element_id="fecha_final"; click_element_id="imagenFecha2">
                                        </DLCALENDAR>
                        </td>
                    </tr>              
                </table>
            </div>
            <br>
            <center>
                <input type="submit"   class="commandButtonR" value="Ver Reporte" name="btnVerReporte">
                <input type="reset"   class="commandButtonR"  value="Limpiar" name="limpiar">
            </center>
        </form>
        <script type="text/javascript" language="JavaScript"  src="../../js/dlcalendar.js"></script>
    </body>
</html>