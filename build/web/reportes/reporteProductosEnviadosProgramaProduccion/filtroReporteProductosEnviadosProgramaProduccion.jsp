
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
    <body>
        <span class="outputTextTituloSistema">Reporte Productos Enviados a Almacen de Acondicionamientos</span>
        
        <form method="post" action="navegadorReporteProductosEnviadosProgramaProduccion.jsp" target="_blank" name="form1">
            <div align="center">
                <table cellpadding="0" cellspacing="0" class="tablaFiltroReporte" width="50%">
                    <thead>
                        <tr>
                            <td colspan="3" >Introduzca Parametros del Reporte</td>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td class="outputTextBold">Programa Produccion</td>
                            <td class="outputTextBold">::</td>
                            <td>
                                <select name="codProgramaProdPeriodo" class="inputText" >
                                    <option value="-1">-TODOS-</option>
                                        <%
                                            Connection con=null;
                                            try {
                                                con = Util.openConnection(con);                            
                                                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                                                String consulta = "SELECT PPRP.COD_PROGRAMA_PROD,PPRP.NOMBRE_PROGRAMA_PROD"+
                                                                    " FROM PROGRAMA_PRODUCCION_PERIODO PPRP"+
                                                                    " WHERE PPRP.COD_ESTADO_PROGRAMA IN (1,2,5) "+
                                                                    " and ISNULL(PPRP.COD_TIPO_PRODUCCION,0)=1";
                                                ResultSet res = st.executeQuery(consulta);
                                                while(res.next())
                                                {
                                                    out.println("<option value='"+res.getInt("COD_PROGRAMA_PROD")+"'>"+res.getString("NOMBRE_PROGRAMA_PROD")+"</option>");
                                                }
                                            } catch (Exception e) {
                                                e.printStackTrace();
                                            }
                                            finally
                                            {
                                                con.close();
                                            }
                                            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
                                        %>
                            
                                </select>
                            </td>
                        </tr>                    
                         <tr>
                            <td class="outputTextBold">Fecha Inicial (Ingreso Acond.) </td>
                            <td class="outputTextBold">::</td>
                            <td >
                                <input type="text"  size="12"  value="<%=sdf.format(new Date())%>" name="fechaInicial" id="fechaInicial" class="inputText" onblur="valFecha(this);">
                                <img id="imagenFecha1" src="../../img/fecha.bmp">
                                <DLCALENDAR tool_tip="Seleccione la Fecha Inicial"
                                            daybar_style="background-color: DBE1E7; font-family: verdana; color:000000;"
                                            navbar_style="background-color: 7992B7; color:ffffff;"
                                            input_element_id="fechaInicial" click_element_id="imagenFecha1">
                                 </DLCALENDAR>
                            </td>
                        </tr>
                        <tr>
                            <td class="outputTextBold">Fecha Final (Ingreso Acond.)</td>
                            <td class="outputTextBold">::</td>
                            <td>
                                <input type="text"  size="12"  value="<%=sdf.format(new Date())%>" name="fechaFinal" id="fechaFinal" class="inputText" onblur="valFecha(this);">
                                <img id="imagenFecha2" src="../../img/fecha.bmp">
                                <DLCALENDAR tool_tip="Seleccione la Fecha Final"
                                            daybar_style="background-color: DBE1E7; font-family: verdana; color:000000;"
                                            navbar_style="background-color: 7992B7; color:ffffff;"
                                            input_element_id="fechaFinal" click_element_id="imagenFecha2">
                                 </DLCALENDAR>
                            </td>
                        </tr>
                        <tr >
                            <td class="outputTextBold">Estado Producto</td>
                            <td class="outputTextBold">::</td>
                            <td>
                                <select name="codEstadoProd" id="codEstadoProd" class="outputText3" onchange="onChangeEstadoProducto(form1)">
                                    <option value="-1">-TODOS-</option>
                                    <%
                                    try {
                                        con = Util.openConnection(con);
                                        Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                                        String consulta = " select ep.cod_estado_prod,ep.nombre_estado_prod"+
                                                            " from estados_producto ep"+
                                                            " order by ep.cod_estado_prod";
                                        ResultSet res = st.executeQuery(consulta);
                                        while (res.next()) {
                                            out.println("<option value='"+res.getInt("cod_estado_prod")+"'>"+res.getString("nombre_estado_prod")+"</option>");
                                        }
                                    } catch (Exception e) {
                                        e.printStackTrace();
                                    }
                                    finally
                                    {
                                        con.close();
                                    }
                                    %>
                                </select>
                               
                            </td>
                        </tr>
                        <tr>
                            <td class="outputTextBold">Producto</td>
                            <td class="outputTextBold">::</td>
                            <td>
                                <div id="divCodComProd">
                                    <select name="codCompProd" class="outputText3" >
                                        <option value="0">-TODOS-</option>
                                            <%
                                            try {
                                                con = Util.openConnection(con);
                                                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                                                String consulta = " select cp.COD_COMPPROD,cp.nombre_prod_semiterminado"+
                                                                  " from COMPONENTES_PROD cp"+
                                                                  " where isnull(cp.COD_TIPO_PRODUCCION,1) in (1,3)"+
                                                                  " order by cp.nombre_prod_semiterminado";
                                                ResultSet res = st.executeQuery(consulta);
                                                while(res.next())
                                                {
                                                    out.println("<option value='"+res.getInt("COD_COMPPROD")+"'>"+res.getString("nombre_prod_semiterminado")+"</option>");
                                                }
                                            } catch (Exception e) {
                                                e.printStackTrace();
                                            }
                                            finally
                                            {
                                                con.close();
                                            }
                                            %>
                                    </select>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td class="outputTextBold">Lote</td>
                            <td class="outputTextBold">::</td>
                            <td><input type="text" class="inputText" style="width:10em" value="" name="nroLote"/></td>
                        </tr>
                    </tbody>
                    <tfoot>
                        <tr>
                            <td class="tdCenter" colspan="3">
                                <input type="submit"  size="35" value="Ver Reporte" name="reporte" class="btn" onclick="verReporte();" >
                            </td>
                        </tr>
                    </tfoot>
                </table>
            </div>
            <br>
            
            <input type="hidden" name="codAlmacenVentaArray">
            <input type="hidden" name="nombreProgramaProduccion" id="nombreProgramaProduccion">
        </form>
        <script type="text/javascript" language="JavaScript"  src="../../js/dlcalendar.js"></script>
    </body>
</html>