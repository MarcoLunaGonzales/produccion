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
        for(var i=0;i<=f.codTipoActividad.options.length-1;i++)
        {	if(f.codTipoActividad.options[i].selected)
            {	arrayCompProd[j]=f.codTipoActividad.options[i].value;
                arrayCompProd1[j]=f.codTipoActividad.options[i].innerHTML;
                j++;
            }
        }
        f.nomTipoActividad.value=arrayCompProd1;
        f.codCompProdArray.value=arrayCompProd;
        f.nombreCompProd.value=arrayCompProd1;       
        alert(f.nomTipoActividad.value);
        /*******************/

        var arrayCodAreaEmpresa=new Array();
        var arrayNombreAreaEmpresa=new Array();
        j=0;
        for(var i=0;i<=f.codAreaEmpresa.options.length-1;i++)
        {	if(f.codAreaEmpresa.options[i].selected)
            {	arrayCodAreaEmpresa[j]=f.codAreaEmpresa.options[i].value;
                arrayNombreAreaEmpresa[j]=f.codAreaEmpresa.options[i].innerHTML;
                j++;
            }
        }

        f.codAreaEmpresaP.value=arrayCodAreaEmpresa;
        f.nombreAreaEmpresaP.value=arrayNombreAreaEmpresa;

        /************************/
        f.desdeFechaP.value=f.fecha_inicio.value;
        f.hastaFechaP.value=f.fecha_final.value;


        f.action="reporteSeguimientoProgramaProduccion.jsf";
        f.submit();

            }

            function seleccionarTodosTipos(f){
                for(var i=0;i<=f.codTipoActividad.options.length-1;i++)
                {
                    f.codTipoActividad.options[i].selected=f.chk_todaFormulaMaestra.checked;
                }
            }
            function seleccionarTodosProg(f){
                for(var i=0;i<=f.codProgramaProd.options.length-1;i++)
                {
                    f.codProgramaProd.options[i].selected=f.chk_todoProg.checked;
                }
            }

  function enviaCodActividad(f){
      
       //sacar el valor del multiple
        
        var arrayCodFormulaMaestra=new Array();
        var arrayNombreProducto=new Array();
        j=0;
        for(var i=0;i<=f.codTipoActividad.options.length-1;i++)
        {	if(f.codTipoActividad.options[i].selected)
            {	arrayCodFormulaMaestra[j]=f.codTipoActividad.options[i].value;
                arrayNombreProducto[j]=f.codTipoActividad.options[i].innerHTML;
                j++;
            }
        }

        f.codFormulaMaestraP.value=arrayCodFormulaMaestra;
        f.nombreProductoP.value=arrayNombreProducto;
        f.nomTipoActividad.value=arrayNombreProducto;
        var arrayCodProg=new Array();
        var arrayNombreProg=new Array();
        j=0;
        for(var i=0;i<=f.codProgramaProd.options.length-1;i++)
        {	if(f.codProgramaProd.options[i].selected)
            {	arrayCodProg[j]=f.codProgramaProd.options[i].value;
                arrayNombreProg[j]=f.codProgramaProd.options[i].innerHTML;
                j++;
            }
        }


        f.codProg.value=arrayCodProg;
        f.nombreProg.value=arrayNombreProg;
        f.nomProgPeriodo.value=arrayNombreProg;
        if(f.chk_todaFormulaMaestra.checked)
            {
                f.codTodoActividad.value='1';
            }

        if(f.chk_todoProg.checked)
            {
                f.codTodoActividad.value='1';
            }
          
        switch(parseInt(f.codTipoReporte.value))
        {
            case 1:
                  f.action="reporteProgProdInd.jsf";
                  break;
            case 2:
                  f.action="reporteProgProdIndResumido.jsf";
                  break;
            case 3:
                  f.action="reporteProgProdIndExcel.jsf";
                  break;
        }
        
        f.submit();

            }




        </script>



    </head>
    <body><br><br>
        <h3 align="center">Reporte Actividades Indirectas de Producción</h3>

        <form method="post" action="reporteProgProdInd.jsp" target="_blank" name="form1">
            <div align="center">
                <table border="0"  border="0" class="border" width="50%">
                    <tr class="headerClassACliente">
                        <td  colspan="3" >
                            <div class="outputText3" align="center">
                                Introduzca Datos
                            </div>
                        </td>

                    </tr>
                  <tr class="outputText3" >
                        <td class="">Programa Produccion</td>
                        <td class="">::</td>
                        <%
        try {
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            String sql = "SELECT PPRP.COD_PROGRAMA_PROD,PPRP.NOMBRE_PROGRAMA_PROD FROM PROGRAMA_PRODUCCION_PERIODO PPRP WHERE PPRP.COD_ESTADO_PROGRAMA IN (1,2,5) ";

            ResultSet rs1 = st.executeQuery(sql);
                        %>

                        <td class="">
                            <!--   <select name="codAreaEmpresa" class="outputText3" >-->
                            <select name="codProgramaProd" size="15" class="inputText" multiple onchange="form1.chk_todoProg.checked=false">
                                <%
                            String codProgProd = "";
                            String nombreProgProd = "";
                            while (rs1.next()) {
                                codProgProd = "'"+rs1.getString("COD_PROGRAMA_PROD")+"'";
                                nombreProgProd = rs1.getString("NOMBRE_PROGRAMA_PROD");
                                %>
                                <option value="<%=codProgProd%>"><%=nombreProgProd%></option>
                                <%
                            }
                            rs1.close();
                            st.close();
                            %>
                            </select>
                            <input type="checkbox"  onclick="seleccionarTodosProg(form1)" name="chk_todoProg" >Todo
                            <%

                                    } catch (Exception e) {
                                        e.printStackTrace();
                                    }
                            %>
                        </td>
                    </tr>

                    <tr class="outputText3" >
                        <td class="">Tipo Actidad:</td>
                        <td class="">::</td>
                        <%
        try {
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            
            String sql = " SELECT AE.COD_AREA_EMPRESA,AE.NOMBRE_AREA_EMPRESA FROM AREAS_EMPRESA AE WHERE AE.COD_AREA_EMPRESA IN (96,75,40,84,102,76,97,1001,80,81,82,95) ORDER BY AE.NOMBRE_AREA_EMPRESA";
            
            ResultSet rs = st.executeQuery(sql);
                        %>

                        <td class="">
                            <!--   <select name="codAreaEmpresa" class="outputText3" >-->
                            <select name="codTipoActividad" size="15" class="inputText" multiple onchange="form1.chk_todaFormulaMaestra.checked=false">
                                <%
                            String codTipoPrograma = "";
                            String nombreTipoPrograma = "";
                            while (rs.next()) {
                                codTipoPrograma = "'"+rs.getString("COD_AREA_EMPRESA")+"'";
                                nombreTipoPrograma = rs.getString("NOMBRE_AREA_EMPRESA");
                                %>
                                <option value="<%=codTipoPrograma%>"><%=nombreTipoPrograma%></option>
                                <%
                            }%>
                            </select>
                            <input type="checkbox"  onclick="seleccionarTodosTipos(form1)" name="chk_todaFormulaMaestra" >Todo
                            <%

                                    } catch (Exception e) {
                                        e.printStackTrace();
                                    }
                            %>
                        </td>
                    </tr>
                    <tr class="outputText3" >
                        <td class="">Tipo reporte</td>
                        <td class="">::</td>


                        <td class="">
                            <!--   <select name="codAreaEmpresa" class="outputText3" >-->
                            
                            <select name="codTipoReporte" id="codTipoReporte" class="outputText3" >
                            <option value="1">Detallado</option>
                            <%--option value="1">Detallado Excel</option--%>
                            <option value="2">Resumido</option>
                            <option value="3">Detallado Excel</option>
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
                        <td >De fecha:
                        </td>
                        <td >::</td>
                        <td >
                            <input type="text"  size="12"  value="<%=fechaInicio%>" name="fecha_inicio" id="fecha_inicio" class="inputText dlCalendar">
                            
                        </td>
                    </tr>

                    <tr class="outputText2">
                        <td>A fecha:
                        </td>
                        <td >::</td>
                        <td>
                            <input type="text"  size="12"  value="<%=fechaFinal%>" name="fecha_final" id="fecha_final" class="dlCalendar">
                        </td>
                    </tr> 
                </table>
            </div>
            <br>
            <center>
                <input type="button" class="btn"  value="Ver Reporte" name="reporte" onclick="enviaCodActividad(form1)">
                <input type="hidden" name="codigosArea" id="codigosArea">
            </center>
            <input type="hidden" name="codFormulaMaestraP">
            <input type="hidden" name="nombreProductoP">
            <input type="hidden" name="codProg">
            <input type="hidden" name="nombreProg">
            <input type="hidden" name="codTodoProg" value="">
            <input type="hidden" name="codTodoActividad" value="">
            <input type="hidden" name="nomProgPeriodo" value="">
            <input type="hidden" name="nomTipoActividad" value="">
        </form>
        <script type="text/javascript" language="JavaScript"  src="../../js/dlcalendar.js"></script>
    </body>
</html>