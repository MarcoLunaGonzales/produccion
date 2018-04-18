
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ page language="java" %>
<%@ page import="com.cofar.web.*" %>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.sql.DriverManager"%> 
<%@ page import = "java.sql.ResultSet"%> 
<%@ page import = "java.sql.Statement"%>
<%@ page import = "java.util.Date"%>
<%@ page import = "java.text.*"%>
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
                location.href="filtroReporteExistenciasCombinado.jsp?codArea="+codigo;
            }

            function seleccionarTodoAlmacen(f){
                for(var i=0;i<=f.codAlmacenVenta.options.length-1;i++)
                {
                    f.codAlmacenVenta.options[i].selected=f.chk_todoAlmacen.checked;
                }
            }
            function almacenVenta_change(f){
                f.chk_todoAlmacen.checked=false
            }

            function verReporteExistenciasCombinado(f){            
            var arrayCodAlmacenVenta=new Array();
            var j=0;            
            for(var i=0;i<=f.codAlmacenVenta.options.length-1;i++)
            {	if(f.codAlmacenVenta.options[i].selected){
                    arrayCodAlmacenVenta[j]=f.codAlmacenVenta.options[i].value;
                    j++;
                }
            }
            f.codAlmacenVentaArray.value=arrayCodAlmacenVenta;
            
            return true;

            }
            function verReporte(){
                form1.nombreProgramaProduccion.value = form1.codProgramaProdPeriodo.options[form1.codProgramaProdPeriodo.selectedIndex].text;
                return true;
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
            function onChangeEstadoProducto(form){
                ajax=nuevoAjax();
                var a=Math.random();
                ajax.open("GET","ajaxProductosPorEstado.jsf?a="+a+"&codEstadoCompProd="+form.codEstadoProd.value,true);
                ajax.onreadystatechange=function(){
                    if (ajax.readyState==4) {
                        document.getElementById('divCodComProd').innerHTML=ajax.responseText;
                         
                    }
                }


              ajax.send(null);


            }
        </script>
    </head>
    <body><br><br>
        <h3 align="center">Reporte Productos Enviados a Almacen de Acondicionamientos</h3>
        
        <form method="post" action="navegadorReporteProductosEnviadosProgramaProduccion.jsp" target="_blank" name="form1">
            <div align="center">
                <table border="0"  border="0" class="tablaFiltroReporte" width="40%" style="border : solid #f3f3f3 1px;">
                    <tr class="headerClassACliente">
                        <td  colspan="3" >
                            <div class="outputText2" align="center">
                                Introduzca Datos
                            </div>
                        </td>
                    </tr>
                    <tr class="outputText2">
                        <td>Programa Produccion</td>
                        <td>::</td>
                        <%
                        try {
                            con = Util.openConnection(con);                            
                            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                            String sql = "SELECT PPRP.COD_PROGRAMA_PROD,PPRP.NOMBRE_PROGRAMA_PROD FROM PROGRAMA_PRODUCCION_PERIODO PPRP WHERE PPRP.COD_ESTADO_PROGRAMA IN (1,2,5) ";
                            ResultSet rs = st.executeQuery(sql);
                        %>
                        <td>
                            <select name="codProgramaProdPeriodo" class="outputText3" >
                                <option value="-1">-TODOS-</option>
                                <%
                                String codProgramaProduccionPeriodo = "";
                                String nombreProgramaProduccionPeriodo = "";
                                while (rs.next()) {
                                    codProgramaProduccionPeriodo = rs.getString("COD_PROGRAMA_PROD");
                                    nombreProgramaProduccionPeriodo = rs.getString("NOMBRE_PROGRAMA_PROD");
                                %>
                                <option value="<%=codProgramaProduccionPeriodo%>"><%=nombreProgramaProduccionPeriodo%></option>
                                <%
                                }%>
                            </select>
                            <%
                            
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                            %>
                        </td>
                    </tr>                    
                    <%
                        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
                        Date fechaInicial = new Date();
                        Date fechaFinal = new Date();                        
                    %>
                     <tr class="outputText2">
                        <td>Fecha Inicial (Ingreso Acond.) </td>
                        <td >::</td>
                        <td>
                            <input type="text"  size="12"  value="<%=sdf.format(fechaInicial)%>" name="fechaInicial" class="inputText" onblur="valFecha(this);">
                            <img id="imagenFecha1" src="../../img/fecha.bmp">
                            <DLCALENDAR tool_tip="Seleccione la Fecha Inicial"
                                        daybar_style="background-color: DBE1E7; font-family: verdana; color:000000;"
                                        navbar_style="background-color: 7992B7; color:ffffff;"
                                        input_element_id="fechaInicial" click_element_id="imagenFecha1">
                             </DLCALENDAR>
                        </td>
                    </tr>
                    <tr class="outputText2">
                        <td>Fecha Final (Ingreso Acond.)</td>
                        <td >::</td>
                        <td>
                            <input type="text"  size="12"  value="<%=sdf.format(fechaFinal)%>" name="fechaFinal" class="inputText" onblur="valFecha(this);">
                            <img id="imagenFecha2" src="../../img/fecha.bmp">
                            <DLCALENDAR tool_tip="Seleccione la Fecha Final"
                                        daybar_style="background-color: DBE1E7; font-family: verdana; color:000000;"
                                        navbar_style="background-color: 7992B7; color:ffffff;"
                                        input_element_id="fechaFinal" click_element_id="imagenFecha2">
                             </DLCALENDAR>
                        </td>
                    </tr>
                      <tr class="outputText2">
                        <td>Estado Producto</td>
                        <td>::</td>
                        <%
                        try {
                            con = Util.openConnection(con);
                            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                            String sql = " select ep.cod_estado_prod,ep.nombre_estado_prod from estados_producto ep order by ep.cod_estado_prod";
                            ResultSet rs = st.executeQuery(sql);
                        %>
                        <td>
                            <select name="codEstadoProd" id="codEstadoProd" class="outputText3" onchange="onChangeEstadoProducto(form1)">
                                <option value="-1">-TODOS-</option>
                                <%
                                String codEstado = "";
                                String nombreEstado = "";
                                while (rs.next()) {
                                    codEstado = rs.getString("cod_estado_prod");
                                    nombreEstado = rs.getString("nombre_estado_prod");
                                %>
                                <option value="<%=codEstado%>"><%=nombreEstado%></option>
                                <%
                                }%>
                            </select>
                            <%

                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                            %>
                        </td>
                    </tr>
                    <tr class="outputText2">
                        <td>Producto</td>
                        <td>::</td>
                        <td>
                            <div id="divCodComProd">
                         
                            <select name="codCompProd" class="outputText3" >
                                <option value="0">-TODOS-</option>
                        <%
                        try {
                            con = Util.openConnection(con);
                            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                            String sql = " select cp.COD_COMPPROD,cp.nombre_prod_semiterminado from COMPONENTES_PROD cp where isnull(cp.COD_TIPO_PRODUCCION,1)=1 order by cp.nombre_prod_semiterminado";
                            ResultSet res = st.executeQuery(sql);
                        %>
                        
                                <%
                                while(res.next())
                                    {
                                out.println("<option value='"+res.getString("COD_COMPPROD")+"'>"+res.getString("nombre_prod_semiterminado")+"</option>");
                                }


                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                            %>
                            </select>
                            </div>
                        </td>
                    </tr>
                    <tr class="outputText2">
                        <td>Lote</td>
                        <td>::</td>
                        <td><input type="text" class="inputText" style="width:10em" value="" name="nroLote"/></td>
                    </tr>
                </table>
            </div>
            <br>
            <center>
                <input type="submit"  size="35" value="Ver Reporte" name="reporte" class="btn" onclick="verReporte();" >
            </center>
            <input type="hidden" name="codAlmacenVentaArray">
            <input type="hidden" name="nombreProgramaProduccion" id="nombreProgramaProduccion">
        </form>
        <script type="text/javascript" language="JavaScript"  src="../../js/dlcalendar.js"></script>
    </body>
</html>