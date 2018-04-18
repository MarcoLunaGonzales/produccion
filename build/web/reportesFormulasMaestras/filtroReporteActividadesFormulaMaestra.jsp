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

        <script type="text/javascript">

            onerror= function(e){
                alert('error\n'+e);
            }

           

            function selecccionarTodoArea(f){
                for(var i=0;i<=f.codAreaEmpresa.options.length-1;i++)
                {
                    f.codAreaEmpresa.options[i].selected=f.chk_todoArea.checked;
                }
            }

            function selecccionarTodo(f){
                for(var i=0;i<=f.codCompProd.options.length-1;i++)
                {
                    f.codCompProd.options[i].selected=f.chk_todoTipo.checked;
                }
            }

            function selecccionarTodoLinea(f){
                for(var i=0;i<=f.codLineaMkt.options.length-1;i++)
                {   if(f.chk_todoLinea.checked==true)
                    {   f.codLineaMkt.options[i].selected=true;
                    }
                    else
                    {   f.codLineaMkt.options[i].selected=false;
                    }
                }
                return(true);
            }
            function construirCadena(name){
                //document.getElementById(name).value='';
                var codtiposingresoventas=document.getElementById(name);
                var options=codtiposingresoventas.getElementsByTagName('option');

                var j=0;
                var data=new Array();
                for(var i=0;i<options.length;i++){
                    if(options[i].selected){
                        data[j]=options[i].value;j++;
                    }
                }
                return data;
            }
            /****************** NUEVO AJAX ********************/
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
    function seleccionarTodoArea(f){
        for(var i=0;i<=f.codAreaEmpresa.options.length-1;i++){
            f.codAreaEmpresa.options[i].selected=f.checkTodoArea.checked;
        }
    }
    function seleccionarTodaFormulaMaestra(f){
        for(var i=0;i<=f.codFormulaMaestra.options.length-1;i++)
        {
            f.codFormulaMaestra.options[i].selected=f.chk_todaFormulaMaestra.checked;
        }
    }
    function verReporte(f){

        var arrayCodFormulaMaestra=new Array();
        for(var i=0;i<=f.codFormulaMaestra.options.length-1;i++)
        {
            if(f.codFormulaMaestra.options[i].selected){
                arrayCodFormulaMaestra.push(f.codFormulaMaestra.options[i].value);
            }
        }
        var arrayAreasActividad=new Array();
        for(var i=0;i<=f.codAreaEmpresa.options.length-1;i++)
        {
            if(f.codAreaEmpresa.options[i].selected){
                arrayAreasActividad.push(f.codAreaEmpresa.options[i].value);
            }
        }
        f.codFormulaMaestraP.value=arrayCodFormulaMaestra;
        f.codigosArea.value=arrayAreasActividad;
        switch(parseInt(f.codTipoReporte.value)){
            case 1:
                f.action="reporteActividadesFormulaMaestra.jsf";
                break;
            case 2:
                f.action="reporteActividadesFormulaEstandar.jsf";
                break;
            case 3:
                f.action="reporteActividadesFormulaEstandarResumido.jsf";
                break;
            case 4:
                f.action="reporteActividadesFormulaMaestraExcel.jsf";
                break;
        }
        f.submit();

    }




        </script>



    </head>
    <body><br><br>
        <h3 align="center">Reporte Actividades Segun Formula Maestra</h3>

        <form method="post" action="navegadorReporteProgramaProduccion.jsp" target="_blank" name="form1">
            <div align="center">
                <table cellpadding="0" cellspacing="0" class="tablaFiltroReporte" width="50%">
                    <thead>
                        <tr>
                            <td colspan="3">Introduzca Datos</td>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td class="outputTextBold">Producto</td>
                            <td class="outputTextBold">::</td>
                            <td>
                                <select name="codFormulaMaestra" size="15" class="inputText" multiple onchange="form1.chk_todaFormulaMaestra.checked=false">
                                    <%
                                        Connection con=null;
                                        try 
                                        {
                                            con = Util.openConnection(con);
                                            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                                            String consulta = " select fm.cod_formula_maestra,cp.nombre_prod_semiterminado"
                                                                + " from formula_maestra fm, ESTADOS_COMPPROD er, componentes_prod cp " +
                                                                "  WHERE fm.estado_sistema=1  and fm.cod_compprod=cp.cod_compprod and cp.COD_ESTADO_COMPPROD=er.COD_ESTADO_COMPPROD " +
                                                                        "  AND cp.COD_ESTADO_COMPPROD=1 and cp.cod_tipo_produccion in (1,3) order by cp.nombre_prod_semiterminado asc  ";
                                            System.out.println("consulta productos "+consulta);
                                            ResultSet rs = st.executeQuery(consulta);
                                            while(rs.next())
                                            {
                                                out.println("<option value='"+rs.getInt("cod_formula_maestra")+"'>"+rs.getString("nombre_prod_semiterminado")+"</option>");
                                            }
                                    %>
                                </select>
                                <br/>
                                <input type="checkbox"  onchange="seleccionarTodaFormulaMaestra(form1)" name="chk_todaFormulaMaestra" id="chk_todaFormulaMaestra" >
                                <label for="chk_todaFormulaMaestra">Seleccionar todos los productos</label>
                            </td>
                        </tr>
                         <tr>
                            <td class="outputTextBold">Tipo de Actividad</td>
                            <td class="outputTextBold">::</td>
                            <td >
                                <select name="codAreaEmpresa" multiple="true" size="4" id="codAreaEmpresa"  class="inputText">
                                <%
                                    consulta = "select ae.COD_AREA_EMPRESA,ae.NOMBRE_AREA_EMPRESA "+
                                                " from AREAS_ACTIVIDAD_PRODUCCION aap "+
                                                        " inner join AREAS_EMPRESA ae on ae.COD_AREA_EMPRESA=aap.COD_AREA_EMPRESA "+
                                                " where aap.APLICA_REGISTRO_ACTIVIDADES = 1"+
                                                " order by ae.NOMBRE_AREA_EMPRESA";
                                    System.out.println("consulta filtro "+consulta );
                                    rs = st.executeQuery(consulta);
                                    while(rs.next())
                                    {
                                        out.print("<option value="+rs.getInt("COD_AREA_EMPRESA")+">"+rs.getString("NOMBRE_AREA_EMPRESA")+"</option>");
                                    }
                                }
                                catch(Exception ex)
                                {
                                ex.printStackTrace();
                                }
                                finally{
                                con.close();
                                }
                                %>
                                </select>
                                </br>
                                <input type="checkbox"  onchange="seleccionarTodoArea(form1)" name="checkTodoArea" id="checkTodoArea" >
                                <label for="checkTodoArea">Seleccionar todos</label>
                            </td>
                        </tr>
                        <tr>
                            <td class="outputTextBold">Tipo de Reporte</td>
                            <td class="outputTextBold">::</td>
                            <td >
                                <select name="codTipoReporte" id="codTipoReporte"  class="inputText">
                                    <option value="1">Reporte Detallado</option>
                                    <option value="4">Reporte Detallado Excel</option>
                                    <option value="2">Reporte Horas Estandar</option>
                                    <option value="3">Reporte Horas Estandar Resumido</option>
                                </select>
                            </td>
                        </tr>
                    </tbody>
                    <tfoot>
                        <tr>
                            <td colspan="3" class="tdCenter">
                                <input type="button" class="btn"  value="Ver Reporte" name="reporte" onclick="verReporte(form1)"/>
                            </td>
                        </tr>
                    </tfoot>
                </table>

            </div>
            <input type="hidden" name="codigosArea" id="codigosArea">
            <input type="hidden" name="codFormulaMaestraP">
            <input type="hidden" name="nombreProductoP">
                




        </form>
        <script type="text/javascript" language="JavaScript"  src="../js/dlcalendar.js"></script>
    </body>
</html>