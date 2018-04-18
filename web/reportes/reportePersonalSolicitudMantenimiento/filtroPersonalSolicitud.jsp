
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
            function ajaxInstalaciones(f){
               
                codAreac=document.getElementById("codAreaEmpresa");
                var arrayAreas=new Array();
                 var j=0;
               
                for(var i=0;i<=codAreac.options.length-1;i++)
                {
                    if(codAreac.options[i].selected)
                    {
                        arrayAreas[j]=codAreac.options[i].value;
                        j++;
                    }
                }
             //   alert(arrayAreas);
                var div_instalaciones;
                div_instalaciones=document.getElementById("div_instalacion");
                ajax=nuevoAjax();
                ajax.open("GET","ajaxInstalacion.jsf?codAreaEmpresaArray="+arrayAreas,true);
                ajax.onreadystatechange=function(){
                    if (ajax.readyState==4) {
                        
                         div_instalaciones.innerHTML=ajax.responseText;
                    }
                }
              

              ajax.send(null);


            }
             function selecccionarTodoMaquina(f){
                 var selectedd=document.getElementById("codMaquinaria");
                 
                for(var i=0;i<=selectedd.options.length-1;i++)
                {
                    selectedd.options[i].selected=f.chk_todoMaquinaria.checked;
                }

            }
            function selecccionarTodoArea(f){
                 var areas=document.getElementById("codAreaEmpresa");

                for(var i=0;i<=areas.options.length-1;i++)
                {
                    
                    areas.options[i].selected=f.chk_todoArea.checked;
                }
                if(f.chk_todoArea.checked)
                    {
                        ajaxInstalaciones(f);
                    }

            }
            function selecccionarTodoEstado(f){
                 var estados=document.getElementById("codEstadoSolicitud");

                for(var i=0;i<=estados.options.length-1;i++)
                {

                    estados.options[i].selected=f.chk_todoEstado.checked;
                }
                

            }
            function selecccionarTodoInstalacion(f)
            {
                var instalaciones=document.getElementById("codInstalacion");
               for(var i=0;i<=instalaciones.options.length-1;i++)
                {
                    instalaciones.options[i].selected=f.chk_todoInstalacion.checked;
                }
            }
            function verReporte(f)
            {
              var arrayMaquinaria=new Array();
              var arrayNombresMaq=new Array();
                var j=0;
                var aMaquinas=document.getElementById("codMaquinaria");
                for(var i=0;i<=aMaquinas.options.length-1;i++)
                {
                    if(aMaquinas.options[i].selected)
                    {
                        arrayNombresMaq[j]=aMaquinas.options[i].innerHTML;
                        arrayMaquinaria[j]=aMaquinas.options[i].value;
                        j++;
                    }
                }
                form1.codMaquinariaArray.value=arrayMaquinaria;
                form1.nombreMaquinariaArray.value=encodeURIComponent(arrayNombresMaq);
                var arrayInstalaciones=new Array();
                var arrayNombresInstalaciones= new Array();
                var k=0;
                var aInstalaciones=document.getElementById("codInstalacion");
                for(var i=0;i<=aInstalaciones.options.length-1;i++)
                {
                    if(aInstalaciones.options[i].selected)
                    {
                        arrayInstalaciones[k]=aInstalaciones.options[i].value;
                        arrayNombresInstalaciones[k]=aInstalaciones.options[i].innerHTML;
                        k++;
                    }
                }
                
                
               
                f.codInstalacionArray.value=arrayInstalaciones;
                f.nombreInstalacionArray.value=arrayNombresInstalaciones;
                var arrayAreasEmpresa=new Array();
                var arrayNombresEmpresa= new Array();
                var aAreas=document.getElementById("codAreaEmpresa");
                for(var i=0;i<=aAreas.options.length-1;i++)
                {
                    if(aAreas.options[i].selected)
                    {
                        arrayAreasEmpresa.push(aAreas.options[i].value);
                        arrayNombresEmpresa.push(aAreas.options[i].innerHTML);

                    }
                }
                f.codAreaArray.value=arrayAreasEmpresa;
                f.nombreAreaArray.value=arrayNombresEmpresa;
                var arrayCodEstado=new Array();
                var arrayNombreEstado=new Array();
                var k=0;
                for(var j=0;j<f.codEstadoSolicitud.length;j++)
                    {
                        if(f.codEstadoSolicitud.options[j].selected)
                            {
                                arrayCodEstado[k]=f.codEstadoSolicitud.options[j].value;
                                arrayNombreEstado[k]=f.codEstadoSolicitud.options[j].innerHTML;
                                k++;
                            }
                    }
                f.nombreEstadoArray.value=arrayNombreEstado;
                f.codEstadoArray.value=arrayCodEstado;
                f.todoArea.value=(f.chk_todoArea.checked?"1":"0");
                f.todoEstado.value=(f.chk_todoEstado.checked?"1":"0");
                f.todoMaquinaria.value=(f.chk_todoMaquinaria.checked?"1":"0");
                f.todoInstalacion.value=(f.chk_todoInstalacion.checked?"1":"0");
                switch(parseInt(document.getElementById("codTipoReporte").value))
                {
                    case 1:
                        {
                            f.action='reportePersonalSolicitud.jsp';
                            break;
                        }
                    default:
                        {
                            f.action='reportePersonalSolicitudExcel.jsp';
                            break;
                        }
                }
                
            }
        </script>
    </head>
    <body>
        <span class="outputTextTituloSistema">Reporte Detalle de Ordenes de Trabajo</span>
        
        <form id="form1"  name="form1" method="post" action="reportePersonalSolicitud.jsp" target="_blank">
            <div align="center">
                <table  width="40%" class="tablaFiltroReporte" cellpadding="0" cellspacing="0" enctype="multipart/form-data">
                    <thead>
                        <tr >
                            <td  colspan="3" >
                                Introdusca Datos
                            </td>
                        </tr>
                    </thead>
                    
                    
                    <tr>
                        <td class="outputTextBold">Area Empresa</td>
                        <td class="outputTextBold">::</td>
                        <%
                        Connection con=null;
                        try 
                        {
                            con = Util.openConnection(con);
                            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                            String sql="select ae.COD_AREA_EMPRESA,ae.NOMBRE_AREA_EMPRESA  from AREAS_EMPRESA ae where ae.DIVISION=3 and ae.COD_ESTADO_REGISTRO=1";
                            System.out.println("sql filtro:" + sql);
                            ResultSet rs = st.executeQuery(sql);
                        %>
                        <td class="">
                            <select id="codAreaEmpresa" class="outputText3" multiple onchange="ajaxInstalaciones(form1);" >
                                
                                <%
                                String codAreaEmpresa = "";
                                String nombreAreaEmpresa= "";
                                while (rs.next()) {
                                    codAreaEmpresa = rs.getString("COD_AREA_EMPRESA");
                                    nombreAreaEmpresa = rs.getString("NOMBRE_AREA_EMPRESA");
                                %>
                                <option value="<%=codAreaEmpresa%>"><%=nombreAreaEmpresa%></option>
                                <%
                                }%>
                            </select>
                            <%
                            
                            } catch (Exception e) {
                            }
                            %>
                            <input type='checkbox'  onclick="selecccionarTodoArea(form1)" name="chk_todoArea" >Todo
                        </td>
                    </tr>

                    <tr class="outputText3" >
                        <td class="outputTextBold">Estado Solicitud</td>
                        <td class="outputTextBold">::</td>
                        <%
                        try {
                            con = Util.openConnection(con);
                            System.out.println("con:::::::::::::" + con);
                            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                            String sql="select e.COD_ESTADO_SOLICITUD,e.NOMBRE_ESTADO_SOLICITUD from ESTADOS_SOLICITUD_MANTENIMIENTO e where e.COD_ESTADO_REGISTRO=1 order by e.NOMBRE_ESTADO_SOLICITUD";
                            System.out.println("sql filtro:" + sql);
                            ResultSet rs = st.executeQuery(sql);
                        %>
                        <td class="">
                            <select id="codEstadoSolicitud" class="outputText3" multiple  >

                                <%
                                String codEstadoSolicitud = "";
                                String nombreEstadoSolicitud= "";
                                while (rs.next()) {
                                    codEstadoSolicitud = rs.getString("COD_ESTADO_SOLICITUD");
                                    nombreEstadoSolicitud = rs.getString("NOMBRE_ESTADO_SOLICITUD");
                                %>
                                <option value="<%=codEstadoSolicitud%>"><%=nombreEstadoSolicitud%></option>
                                <%
                                }%>
                            </select>
                            <%

                            } catch (Exception e) {
                            }
                            %>
                            <input type='checkbox'  onclick="selecccionarTodoEstado(form1)" name="chk_todoEstado" >Todo
                        </td>
                    </tr>



                     <tr class="outputText3" >
                        <td class="outputTextBold">Maquinaria</td>
                        <td class="outputTextBold">::</td>

                        <td class="">
                            <select id="codMaquinaria" size="15" class="inputText" multiple >
                            <%
                            try{
                                con=Util.openConnection(con);
                                String consulta="select m.COD_MAQUINA,m.NOMBRE_MAQUINA from maquinarias m where m.cod_estado_registro=1 order by m.NOMBRE_MAQUINA ";
                                Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                ResultSet res=st.executeQuery(consulta);
                                while(res.next())
                                    {
                                out.println("<option value='"+res.getString("COD_MAQUINA")+"'>"+res.getString("NOMBRE_MAQUINA")+"</option>");
                                }
                                st.close();
                                
                                con.close();
                            }
                            catch(SQLException ex)
                            {
                                ex.printStackTrace();
                            }
                            %>
                            </select>
                            <input type='checkbox'  onclick="selecccionarTodoMaquina(form1)" name="chk_todoMaquinaria" >Todo
                            
                        </td>
                    </tr>
                    <tr class="outputText3" >
                        <td class="outputTextBold">Instalacion</td>
                        <td class="outputTextBold">::</td>

                        <td class="">
                            <div id="div_instalacion">
                                <select name="codInstalacion" id="codInstalacion" size="15" class="inputText" multiple >
                                <option value="-1">-NINGUNO-</option>
                            </select>
                            <input type='checkbox'  onclick="selecccionarTodoInstalacion(form1)" name="chk_todoInstalacion" >Todo
                            </div>
                        </td>
                    </tr>
                    
                     <%
                     SimpleDateFormat form = new SimpleDateFormat("dd/MM/yyyy");
                                Date fecha_inicio = new Date();
                                String fechaFinal = form.format(fecha_inicio);
                                String fechaInicio = "01";
                                fechaFinal.substring(2, 10);
                                fechaInicio = fechaInicio + fechaFinal.substring(2, 10);
                                String fechaInicioper=fechaInicio;
                                String fechaFinalper=fechaFinal;

                    %>

                    <tr class="outputText2">
                        <td class="outputTextBold">De fecha de Seguimiento Personal
                        </td>
                        <td class="outputTextBold">::</td>
                        <td >
                            <input type="text"  size="12"  value="<%=fechaInicioper%>" name="fecha_inicioSol" id="fecha_inicioSol" class="inputText">
                            <img id="imagenFechaPer1" src="../../img/fecha.bmp">
                            <DLCALENDAR tool_tip="Seleccione la Fecha"
                                        daybar_style="background-color: DBE1E7;
                                        font-family: verdana; color:000000;"navbar_style="background-color: 7992B7; color:ffffff;"
                                        input_element_id="fecha_inicioSol" click_element_id="imagenFechaPer1">
                             </DLCALENDAR>
                        </td>
                    </tr>
                    <tr class="outputText2">
                        <td class="outputTextBold">A fecha de Seguimiento Personal
                        </td>
                        <td class="outputTextBold">::</td>
                        <td>
                            <input type="text"  size="12"  value="<%=fechaFinalper%>" name="fecha_finalSol" id="fecha_finalSol" class="inputText">
                            <img id="imagenFechaPer2" src="../../img/fecha.bmp">
                            <DLCALENDAR tool_tip="Seleccione la Fecha"
                                        daybar_style="background-color: DBE1E7;
                                        font-family: verdana; color:000000;"navbar_style="background-color: 7992B7; color:ffffff;"
                                        input_element_id="fecha_finalSol" click_element_id="imagenFechaPer2">
                             </DLCALENDAR>
                        </td>
                    </tr>
                    <tr>
                        <td class="outputTextBold">Tipo de Reporte</td>
                        <td class="outputTextBold">::</td>
                        <td>
                            <select id="codTipoReporte">
                                <option value="1">Detallado</option>
                                <option value="2">Detallado Excel</option>
                            </select>
                        </td>
                    </tr>
                    
                    <tr>
                        <td colspan="3" align="center">
                            <input type="submit" onclick="verReporte(form1)" class="btn" size="35" value="Ver Reporte" name="reporte"/>
                        </td>
                    </tr>
                </table>
                
            </div>
            <br>
                <input type="hidden" id="codMaquinariaArray" name="codMaquinariaArray">
                <input type="hidden" id="codInstalacionArray" name="codInstalacionArray">
                <input type="hidden" id="codAreaArray" name="codAreaArray">
                <input type="hidden" id="nombreMaquinariaArray" name="nombreMaquinariaArray">
                <input type="hidden" id="nombreInstalacionArray" name="nombreInstalacionArray">
                <input type="hidden" id="nombredAreaArray" name="nombreAreaArray">
                <input type="hidden" id="codEstadoArray" name="codEstadoArray">
                <input type="hidden" id="nombreEstadoArray" name="nombreEstadoArray">

                <input type="hidden" id="todoArea" name="todoArea">
                <input type="hidden" id="todoEstado" name="todoEstado">
                <input type="hidden" id="todoMaquinaria" name="todoMaquinaria">
                <input type="hidden" id="todoInstalacion" name="todoInstalacion">
            
        </form>
        <script type="text/javascript" language="JavaScript"  src="../../js/dlcalendar.js"></script>
    </body>
</html>