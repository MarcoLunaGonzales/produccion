<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ page language="java" %>
<%@ page import="com.cofar.web.*" %>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.sql.DriverManager"%> 
<%@ page import = "java.sql.ResultSet"%> 
<%@ page import = "java.sql.Statement"%> 
<%@ page import="com.cofar.util.*" %>
<%@ page language="java" import="java.util.*" %>
<%@ page errorPage="ExceptionHandler.jsp" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>


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
            .tablaSalidas
            {
                font-family: Verdana, Arial, Helvetica, sans-serif !important;  
                font-size: 11px;
                border-top: 1px solid #dddddd;
                border-right: 1px solid #dddddd;
               
            }
            .tablaSalidas thead tr td
            {
                background-color: #CCCCCC;
                font-weight: bold;
            }
            .tablaSalidas td
            {
                border-bottom: 1px solid #dddddd;
                border-left: 1px solid #dddddd;
                padding: 4px;
            }
            .seleccionado
            {
                background-color: #32CD32;
            }
        </style>

        <script >
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
            function buscarSalidas()
            {
                ajax=nuevoAjax();
                var request="ajaxMostrarDatosSalidas.jsf?codLote="+document.getElementById("codLote").value+
                            "&codCompProd="+document.getElementById("codProducto").value+
                            "&nroSalida="+document.getElementById("nroSalida").value+
                            "&fechaInicio="+document.getElementById("fechaInicio").value+
                            "&fechaFinal="+document.getElementById("fechaFinal").value+
                            "&noCache="+(new Date()).getTime().toString();
                ajax.open("GET",request,true);
                ajax.onreadystatechange=function()
                {
                    if (ajax.readyState==4) {
                        document.getElementById("dataSalidas").innerHTML=ajax.responseText;
                        document.getElementById("detalleSalida").innerHTML="";
                    }
                }
                ajax.send(null);
            }
            function detallarSalida(codSalida,celda)
            {
                var tabla=celda.parentNode.parentNode.parentNode;
                for(var i=0;i<tabla.rows.length;i++)
                {
                    tabla.rows[i].className="";
                }
                celda.parentNode.parentNode.className='seleccionado';
                ajax=nuevoAjax();
                var request="ajaxDetalleSalida.jsf?codSalida="+codSalida+
                            "&noCache="+(new Date()).getTime().toString();
                          
                ajax.open("GET",request,true);
                ajax.onreadystatechange=function()
                {
                    if (ajax.readyState==4) {
                        document.getElementById("detalleSalida").innerHTML=ajax.responseText;
                    }
                }
                ajax.send(null);
            }
			function etiquetasSalidasSinNL(codSalidaAlmacen)
			{
				var request="impresionSalidaSinNl.jsf?codSalidaAlmacen="+codSalidaAlmacen+
                            "&data="+(new Date()).getTime().toString();
                window.open(request,'detalle'+Math.round((Math.random()*1000)),'top=50,left=200,width=800,height=500,scrollbars=1,resizable=1');
			}
            function generarEtiquetas()
            {
                var tabla=document.getElementById("detalleSalidaMaterial");
                var datosDetalle=new Array();
                for(var i=2;i<tabla.rows.length;i++)
                {
                    if(tabla.rows[i].cells[0].getElementsByTagName("input")[0].checked)
                    {
                        datosDetalle[datosDetalle.length]=tabla.rows[i].cells[1].getElementsByTagName("input")[0].value;
                        datosDetalle[datosDetalle.length]=tabla.rows[i].cells[2].getElementsByTagName("input")[0].value;
                        datosDetalle[datosDetalle.length]=(tabla.rows[i].cells[3].getElementsByTagName("input")[0].value==''?0:tabla.rows[i].cells[3].getElementsByTagName("input")[0].value);
                        datosDetalle[datosDetalle.length]=(tabla.rows[i].cells[4].getElementsByTagName("input")[0].value==''?0:tabla.rows[i].cells[4].getElementsByTagName("input")[0].value);
                    }
                }
                if(datosDetalle.length==0)
                {
                    alert('No se selecciono ningun material para la impresion');
                    return false;
                }
                var request="impresionEtiquetasDevolucionMaterialPesaje.jsf?datosMateriales="+datosDetalle+
                            "&data="+(new Date()).getTime().toString();
                window.open(request,'detalle'+Math.round((Math.random()*1000)),'top=50,left=200,width=800,height=500,scrollbars=1,resizable=1');
        
            }
            
        </script>



    </head>
    <body>
        <h3 align="center"> Impresión etiquetas de devolucion de material (pesaje)</h3>
        <form method="post" action="reporteExistenciasAlmacen.jsp" target="_blank" name="form1">
            <div align="center">
                <table border="0"  border="0" style="border:1px solid maroon" class="border" cellpadding="2" width="80%">
                    <tr class="headerClassACliente">
                        <td height="50px" colspan="9" >
                            <div  align="center">
                                Introduzca Datos
                            </div>
                        </td>

                    </tr>

                    <tr class="outputText3">
                        <td height="50px" class=""><b>Lote</td>
                        <td class="">::</td>
                        <td><input class="inputText" id="codLote" value=""/></td>
                        <td style="font-weight:bold">Producto</td>
                        <td style="font-weight:bold">::</td>
                        <td colspan="4"><select id="codProducto">
                                <option value="0">--TODOS--</option>
                        <%
                            SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy");
                            Connection con=null;
                            try
                            {
                                con=Util.openConnection(con);
                                String consulta="select cp.COD_COMPPROD,cp.nombre_prod_semiterminado from COMPONENTES_PROD cp where cp.COD_ESTADO_COMPPROD=1 order by cp.nombre_prod_semiterminado";
                                Statement st =con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                ResultSet res=st.executeQuery(consulta);
                                while(res.next())
                                {
                                    out.println("<option value='"+res.getInt("COD_COMPPROD")+"'>"+res.getString("nombre_prod_semiterminado")+"</option>");
                                }
                            
                        %>
                        </select></td>
                    </tr>
                    
                     <tr class="outputText3">
                        <td  height="35px" class=""><b>Fecha Inicio</td>
                        <td class="">::</td>
                       
                       
                        <td class="">

                            <input id="fechaInicio" type="text"  size="12" style="color:#a43706"   value="<%=sdf.format(new Date()) %>" name="fecha1" class="inputText">
                            <img id="imagenFecha1" src="../../img/fecha.bmp">
                            <DLCALENDAR tool_tip="Seleccione la Fecha"
                                        daybar_style="background-color: DBE1E7;
                                        font-family: verdana; color:000000;"navbar_style="background-color: 7992B7; color:ffffff;"
                                        input_element_id="fecha1" click_element_id="imagenFecha1">
                             </DLCALENDAR>
                         </td>
                        <td  height="35px" class=""><b>Fecha Final</td>
                        <td class="">::</td>
                           <td class="">
                               <input id="fechaFinal" type="text"  size="12" style="color:#a43706"   value="<%=sdf.format(new Date()) %>" name="fecha2" class="inputText">
                            <img id="imagenFecha2" src="../../img/fecha.bmp">
                            <DLCALENDAR tool_tip="Seleccione la Fecha"
                                        daybar_style="background-color: DBE1E7;
                                        font-family: verdana; color:000000;"navbar_style="background-color: 7992B7; color:ffffff;"
                                        input_element_id="fecha2" click_element_id="imagenFecha2">
                             </DLCALENDAR>
                            </td>
                            <td  height="35px" class=""><b>Nro Salida</td>
                            <td class="">::</td>
                            <td><input class="inputText" value="" id="nroSalida"/></td>
                        </tr>
                        <tr >
                            <td colspan="9" style="text-align: center"><a onclick="buscarSalidas()" class="btn" >BUSCAR SALIDA</a></td>
                        </tr>
                        <tr>
                            <td  style="text-align:center" colspan="9" >
                                <center>
                                    <div style="height:8em; overflow-y: auto" id="dataSalidas">
                                    <table cellpadding="0" class="tablaSalidas" >

                                            <thead>
                                                <tr >
                                                    <td>Nro Salida</td>
                                                    <td>Producto</td>
                                                    <td>Lote</td>
                                                    <td>FechaSalida</td>
                                                    <td>Detallar</td>
													<td>Etiquetas Salidas Sin N.L. </td>
                                                </tr>
                                            </thead>
                                        <%
                                            sdf=new SimpleDateFormat("yyyy/MM/dd");
                                        consulta="select sa.COD_SALIDA_ALMACEN,sa.NRO_SALIDA_ALMACEN,isnull(cp.nombre_prod_semiterminado,'') as nombre_prod_semiterminado,isnull(sa.COD_LOTE_PRODUCCION,'') as COD_LOTE_PRODUCCION,sa.FECHA_SALIDA_ALMACEN"+
                                                 " from SALIDAS_ALMACEN sa left outer join COMPONENTES_PROD cp on sa.COD_PROD=cp.COD_COMPPROD"+
                                                 " where sa.COD_ALMACEN=1 and sa.FECHA_SALIDA_ALMACEN BETWEEN '"+sdf.format(new Date())+" 00:00' and '"+sdf.format(new Date())+" 23:59'"+
                                                 " and sa.COD_SALIDA_ALMACEN in  ("+
                                                 " select sad.COD_SALIDA_ALMACEN from SALIDAS_ALMACEN_DETALLE sad inner join materiales m on "+
                                                 "  sad.COD_MATERIAL=m.COD_MATERIAL inner join grupos g on g.COD_GRUPO=m.COD_GRUPO"+
                                                 "  and g.COD_CAPITULO=2)"+
                                                 
                                                 " order by sa.NRO_SALIDA_ALMACEN";
                                        System.out.println("consulta salidas "+consulta);
                                        res=st.executeQuery(consulta);
                                        while(res.next())
                                        {
                                            out.println("<tr>");
                                            out.println("<td>"+res.getInt("NRO_SALIDA_ALMACEN")+"</td>");
                                            out.println("<td>"+res.getString("nombre_prod_semiterminado")+"</td>");
                                            out.println("<td>"+res.getString("COD_LOTE_PRODUCCION")+"</td>");
                                            out.println("<td>"+sdf.format(res.getTimestamp("FECHA_SALIDA_ALMACEN"))+"</td>");
                                            out.println("<td><a onclick='detallarSalida("+res.getInt("COD_SALIDA_ALMACEN")+",this)' href='#'><img src='../../img/h2bg.gif'/></a></td>");
											out.println("<td>"+(res.getString("COD_LOTE_PRODUCCION").length()==0?"<a onclick='etiquetasSalidasSinNL("+res.getInt("COD_SALIDA_ALMACEN")+")' href='#'><img src='../../img/h2bg.gif'/></a>":"")+"</td>");
                                            out.println("</tr>");
                                        }
                                        %>

                                    </table>
                                </div>
                                </center>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="9" style="text-align: center">
                                <center>
                                    <div style="height:10em; overflow-y: auto" id="detalleSalida">

                                    </div>
                                </center>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="9" style="text-align: center">
                                <a class="btn" onclick="generarEtiquetas()">IMPRIMIR</a>
                            </td>
                        </tr>
                     
                        
                        <%
                            }   
                            catch(SQLException ex)
                            {
                                ex.printStackTrace();
                            }
                            finally
                            {
                                con.close();
                            }
                        %>
                  
                </table>
                


            </div>
            <br>
            <br>
            <center>
                
            </center>
            

        </form>
        <script type="text/javascript" language="JavaScript"  src="../../js/dlcalendar.js"></script>
    </body>
</html>