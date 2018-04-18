package reportes.reporteTiempos_1;


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
        </style>

        <script >

            function selecccionarTodo(f){
                for(var i=0;i<=f.codProgramaProdPeriodo.options.length-1;i++)
                {
                    f.codProgramaProdPeriodo.options[i].selected=f.chk_todoTipo.checked;
                }
            }

           
            function filtraPorCodigoProgramaProduccion(codProgramaProduccionPeriodo){
                // var codigo=f.codAreaEmpresa.value;
                
                location.href="filtroReporteSeguimientoProgramaProduccion.jsf?codProgramaProduccionPeriodo="+codProgramaProduccionPeriodo;
            }

       function enviaProgramaProduccion(f){
           
       //sacar el valor del multiple
        /***** AREAS EMPRESA ******/

        

        //alert(document.getElementById('codProgramaProdPeriodo').options[document.getElementById('codProgramaProdPeriodo').selectedIndex].innerHTML);
        
    
        var arrayCompProd=new Array();
        var arrayCompProd1=new Array();
        var j=0;
        for(var i=0;i<=f.codProgramaProdPeriodo.options.length-1;i++)
        {	if(f.codProgramaProdPeriodo.options[i].selected)
            {	arrayCompProd[j]=f.codProgramaProdPeriodo.options[i].value;
                arrayCompProd1[j]=f.codProgramaProdPeriodo.options[i].innerHTML;
                j++;
            }
        }
        f.codCompProdArray.value=arrayCompProd;
        f.nombreCompProd.value=arrayCompProd1;       

       
        f.desdeFechaP.value=f.fecha_inicio.value;
        f.hastaFechaP.value=f.fecha_final.value;

        /*
        if(f.codTipoReporteDetallado.value==1){
            f.action="reporteSeguimientoProgramaProduccion.jsf";
        }else{
            f.action="reporteSeguimientoProgramaProduccionResumido.jsf";
        }*/
        f.action="reporteDeTiempos.jsf";
        f.submit();
            }
        

        </script>



    </head>
    <body><br><br>
        <h3 align="center">Reporte de Tiempos Producción</h3>

        <form method="post" action="navegadorReporteProgramaProduccion.jsp" target="_blank" name="form1">
            <div align="center">
                <table border="0"  border="0" class="border" width="50%">
                    <tr class="headerClassACliente">
                        <td  colspan="3" >
                            <div class="outputText3" align="center">
                                Introduzca Datos
                            </div>
                        </td>

                    </tr>

                    <tr class="outputText3">
                        <td class="">Programa de Producción</td>
                        <td class="">::</td>
                        <%
           String codProgramaProduccionPeriodoReq ="";
           if(request.getParameter("codProgramaProduccionPeriodo")!=null)
           {codProgramaProduccionPeriodoReq = request.getParameter("codProgramaProduccionPeriodo");}
           try {
            con = Util.openConnection(con);
            System.out.println("con:::::::::::::" + con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);            
            
            
            
            
            String sql = "SELECT PP.COD_PROGRAMA_PROD,PP.NOMBRE_PROGRAMA_PROD,PP.OBSERVACIONES";
            sql += ",(SELECT EP.NOMBRE_ESTADO_PROGRAMA_PROD FROM ESTADOS_PROGRAMA_PRODUCCION EP WHERE EP.COD_ESTADO_PROGRAMA_PROD = PP.COD_ESTADO_PROGRAMA)";
            sql += " FROM PROGRAMA_PRODUCCION_PERIODO PP WHERE PP.COD_ESTADO_PROGRAMA<>4";
            System.out.println("sql filtro:" + sql);
            ResultSet rs = st.executeQuery(sql);
                        %>
                        <td class="">
                            <div>
                            <select name="codProgramaProdPeriodo" class="outputText3" style="height:150px" multiple onchange="form1.chk_todoTipo.checked=false">
                                <%
                            String codProgramaProduccionPeriodo = "";
                            String nombreProgramaProduccionPeriodo = "";
                          
                            while (rs.next()) {
                                codProgramaProduccionPeriodo = rs.getString("COD_PROGRAMA_PROD");
                                nombreProgramaProduccionPeriodo = rs.getString("NOMBRE_PROGRAMA_PROD");                                
                                if(codProgramaProduccionPeriodo.equals(codProgramaProduccionPeriodoReq))
                                out.print("<option value="+codProgramaProduccionPeriodo+">"+nombreProgramaProduccionPeriodo+"</option>");
                                else
                                out.print("<option value="+codProgramaProduccionPeriodo+">"+nombreProgramaProduccionPeriodo+"</option>");
                            }%>
                            </select>
                            <input type="checkbox"  onclick="selecccionarTodo(form1)" name="chk_todoTipo" >Todo
                            </div>
                            <!--  <input type="checkbox"  onclick="selecccionarTodo(form1)" name="chk_todoTipo" >Todo-->
                            <%

        } catch (Exception e) {
        }
                            %>
                        </td>
                    </tr>
                    
                    <tr class="outputText3">
                        <td class="">Tipo Reporte</td>
                        <td class="">::</td>
                        <td class="">
                            <select name="codTipoReporteDetallado" class="outputText3">
                                <option value="1" selected>DETALLADO</option>
                                <option value="2">RESUMIDO</option>
                            </select>
                        </td>
                    </tr>
                    
                   
                    <%
                     SimpleDateFormat form = new SimpleDateFormat("dd/MM/yyyy");
                                Date fecha_inicio = new Date();
                                String fechaFinal = form.format(fecha_inicio);
                                String fechaInicio = "01";
                                fechaFinal.substring(2, 10);
                                fechaInicio = fechaInicio + fechaFinal.substring(2, 10);

                    %>

                    <tr class="outputText2">
                        <td >De fecha de ingreso acondicionamiento:
                        </td>
                        <td >::</td>
                        <td >
                            <input type="text"  size="12"  value="<%=fechaInicio%>" name="fecha_inicio" class="inputText">
                            <img id="imagenFecha1" src="../../img/fecha.bmp">
                            <DLCALENDAR tool_tip="Seleccione la Fecha"
                                        daybar_style="background-color: DBE1E7;
                                        font-family: verdana; color:000000;"navbar_style="background-color: 7992B7; color:ffffff;"
                                        input_element_id="fecha_inicio" click_element_id="imagenFecha1">
                             </DLCALENDAR>
                        </td>
                    </tr>

                    <tr class="outputText2">
                        <td>A fecha de ingreso acondicionamiento:
                        </td>
                        <td >::</td>
                        <td>
                            <input type="text"  size="12"  value="<%=fechaFinal%>" name="fecha_final" class="inputText">
                            <img id="imagenFecha2" src="../../img/fecha.bmp">
                            <DLCALENDAR tool_tip="Seleccione la Fecha"
                                        daybar_style="background-color: DBE1E7;
                                        font-family: verdana; color:000000;"navbar_style="background-color: 7992B7; color:ffffff;"
                                        input_element_id="fecha_final" click_element_id="imagenFecha2">
                             </DLCALENDAR>
                        </td>
                    </tr>

                </table>

            </div>
            <br>
            <center>
                <input type="button" class="btn"  value="Ver Reporte" name="reporte" onclick="enviaProgramaProduccion(form1)">
                <input type="hidden" name="codigosArea" id="codigosArea">

            </center>
            <!--datos de referencia para el envio de datos via post-->
            <input type="hidden" name="codProgramaProduccionPeriodo">
            <input type="hidden" name="nombreProgramaProduccionPeriodo">

            <input type="hidden" name="codCompProdArray">
            <input type="hidden" name="nombreCompProd">

            <input type="hidden" name="codAreaEmpresaP">
            <input type="hidden" name="nombreAreaEmpresaP">
            <input type="hidden" name="desdeFechaP">
            <input type="hidden" name="hastaFechaP">



        </form>
        <script type="text/javascript" language="JavaScript"  src="../../js/dlcalendar.js"></script>
    </body>
</html>