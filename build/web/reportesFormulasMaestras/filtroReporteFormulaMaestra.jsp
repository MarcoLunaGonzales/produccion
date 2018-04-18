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
<html>
    <head>
        <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
        <script src="../js/general.js"></script>
        <script>
            function cancelar(){
                // alert(codigo);
                location='../personal_jsp/navegador_personal.jsf';
            }
            function cargarAlmacen(f){
                var codigo=f.codAreaEmpresa.value;
                location.href="filtroReporteExistencias.jsp?codArea="+codigo;
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
            function selecionarTodo(nameSelect,buscar,check)
            {
                var select=document.getElementById(nameSelect);
                for(var i=0;i<select.options.length;i++)
                {
                    select.options[i].selected=check.checked;
                }
                if(buscar)buscarProductos();
            }

            function buscarProductos()
            {

                ajax=nuevoAjax();
                var selectAreas=document.getElementById("codAreaEmpresa");
                var arrayAreasEmpresa=new Array();
                var arrayNombresEmpresa=new Array();
                for(var i=0;i<selectAreas.options.length;i++)
                {
                    if(selectAreas.options[i].selected)
                    {
                        arrayAreasEmpresa[arrayAreasEmpresa.length]=selectAreas.options[i].value;
                        arrayNombresEmpresa[arrayNombresEmpresa.length]=selectAreas.options[i].innerHTML;
                    }
                }
                var selectTiposProduccion=document.getElementById("codTipoProduccion");
                var arraySelectTipos=new Array();
                var arrayNombreTipos=new Array();
                for(var i=0;i<selectTiposProduccion.options.length;i++)
                {
                    if(selectTiposProduccion.options[i].selected)
                    {
                        arraySelectTipos[arraySelectTipos.length]=selectTiposProduccion.options[i].value;
                        arrayNombreTipos[arrayNombreTipos.length]=selectTiposProduccion.options[i].innerHTML;
                    }
                }
                var productos=document.getElementById("productos");
                ajax.open("GET","ajaxProductos.jsf?areaEmpresa="+arrayAreasEmpresa+"&arrayTipos="+arraySelectTipos+"&alea="+Math.random(),true);
                ajax.onreadystatechange=function(){
                    if (ajax.readyState==4) {
                        productos.innerHTML=ajax.responseText;
                    }
                }

                ajax.send(null);

            }
            function verReporte(f)
            {
                var selectAreas=document.getElementById("codAreaEmpresa");
                var arrayAreasEmpresa=new Array();
                var arrayNombresEmpresa=new Array();
                for(var i=0;i<selectAreas.options.length;i++)
                {
                    if(selectAreas.options[i].selected)
                    {
                        arrayAreasEmpresa[arrayAreasEmpresa.length]=selectAreas.options[i].value;
                        arrayNombresEmpresa[arrayNombresEmpresa.length]=selectAreas.options[i].innerHTML;
                    }
                }
                var selectTiposProduccion=document.getElementById("codTipoProduccion");
                var arraySelectTipos=new Array();
                var arrayNombreTipos=new Array();
                for(var i=0;i<selectTiposProduccion.options.length;i++)
                {
                    if(selectTiposProduccion.options[i].selected)
                    {
                        arraySelectTipos[arraySelectTipos.length]=selectTiposProduccion.options[i].value;
                        arrayNombreTipos[arrayNombreTipos.length]=selectTiposProduccion.options[i].innerHTML;
                    }
                }
                var selectProductos=document.getElementById("selectProducto");
                var arraySelectProducto=new Array();
                var arrayNombreProducto=new Array();
                for(var i=0;i<selectProductos.options.length;i++)
                {
                    if(selectProductos.options[i].selected)
                    {
                        arraySelectProducto[arraySelectProducto.length]=selectProductos.options[i].value;
                        arrayNombreProducto[arrayNombreProducto.length]=selectProductos.options[i].innerHTML;
                    }
                }
                document.getElementById("codAreaEmpresa1").value=arrayAreasEmpresa;
                document.getElementById("nombreAreaEmpresa").value=arrayNombresEmpresa;
                document.getElementById("codTipoProduccionPost").value=arraySelectTipos;
                document.getElementById("nombreTipoProduccion").value=arrayNombreTipos;
                document.getElementById("codProducto").value=arraySelectProducto;
                
                f.action=(f.codTipoReporte.value=='1'?'reporteFormulaMaestra':'reporteFormulaMaestraExcel')+'.jsf';
                f.submit();

            }
        </script>
    </head>
    <body><br><br>
        <h3 align="center">Reporte Formulas Maestras</h3>

        <form method="post" id="form1" action="reporteFormulaMaestra.jsp" target="_blank">
            <div align="center">
                <table border="0"  border="0" class="tablaFiltroReporte" width="50%">
                    <tr class="headerClassACliente">
                        <td  colspan="3" >
                            <div class="outputText3" align="center">
                                Introduzca Datos
                            </div>
                        </td>

                    </tr>
                    <tr class="outputText3">
                        <td class="border">Area de Fabricación</td>
                        <td class="border">::</td>
                        <td class="border">
                            <select name="codAreaEmpresa" id="codAreaEmpresa" class="inputText" multiple onchange="buscarProductos()" >
                        <%
                         Connection con=null;
                        try {
                            con = Util.openConnection(con);
                            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                            String sql = "select ae.COD_AREA_EMPRESA,ae.NOMBRE_AREA_EMPRESA"+
                                         " from AREAS_EMPRESA ae where ae.COD_AREA_EMPRESA in (80,81,82,95)"+
                                         " order by ae.NOMBRE_AREA_EMPRESA";
                                        ResultSet res = st.executeQuery(sql);
                                        while (res.next())out.println("<option value='"+res.getInt("COD_AREA_EMPRESA")+"'>"+res.getString("NOMBRE_AREA_EMPRESA")+"</option>");
                                        %>
                            </select>
                            <input type="checkbox" onclick="selecionarTodo('codAreaEmpresa',true,this)">
                        </td>
                    </tr>
                     <tr class="outputText3">
                        <td class="border">Tipo Produccion</td>
                        <td class="border">::</td>
                        <td>
                          <select name="codTipoProduccion" id="codTipoProduccion" class="inputText" multiple size="3" onchange="buscarProductos()" >
                            <%
                            sql="select tp.COD_TIPO_PRODUCCION,tp.NOMBRE_TIPO_PRODUCCION from TIPOS_PRODUCCION tp order by tp.NOMBRE_TIPO_PRODUCCION";
                            res=st.executeQuery(sql);
                            while (res.next()) {
                                %>                               
                                <option value="<%=res.getString("COD_TIPO_PRODUCCION")%>"><%=res.getString("NOMBRE_TIPO_PRODUCCION")%></option>
                                <%
                            }%>
                            </select>
                            <input type="checkbox" onclick="selecionarTodo('codTipoProduccion',true,this)">
                        </td>
                     </tr>
                     <tr class="outputText3">
                        <td class="border">Producto</td>
                        <td class="border">::</td>
                        <td>
                            <div id="productos">
                                <select id='selectProducto' multiple size='5' class='inputText'></select>
                            </div>
                        </td>
                     </tr>
                     <tr class="outputText3">
                        <td class="border">Tipo Reporte</td>
                        <td class="border">::</td>
                        <td>
                            <div id="productos">
                                <select id='codTipoReporte' class='inputText'>
                                    <option value="1" selected>Detallado</option>
                                    <option value="2">Detallado Excel</option>
                                </select>
                            </div>
                        </td>
                     </tr>

         <%

        } catch (Exception e) {
        }
                            %>

                </table>

            </div>
            <br>
            <center>
                <button onclick="verReporte(form1)" class="btn">Ver Reporte</button>

            </center>
            <input type="hidden" value="0" id="codAreaEmpresa1" name="codAreaEmpresa1"/>
            <input type="hidden" value="0" id="nombreAreaEmpresa" name="nombreAreaEmpresa"/>
            <input type="hidden" value="0" id="codTipoProduccionPost" name="codTipoProduccionPost"/>
            <input type="hidden" value="0" id="nombreTipoProduccion" name="nombreTipoProduccion"/>
            <input type="hidden" value="0" id="codProducto" name="codProducto"/>
            <input type="hidden" value="0" id="nombreProducto" name="nombreProducto"/>
        </form>
        <script type="text/javascript" language="JavaScript"  src="../js/dlcalendar.js"></script>
    </body>
</html>