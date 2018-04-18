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

  function verReporteDiferenciaFechas(f){
      
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
        

        f.action="reporteFechasAcond.jsf";
        
        f.submit();

            }




        </script>



    </head>
    <body><br><br>
        <h3 align="center">Reporte de Fechas de Vencimiento Acond</h3>

        <form method="post" action="reporteFechasAcond.jsp" target="_blank" name="form1">
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
                                Connection con=null;
        try {
            
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
           String sql = "SELECT PP.COD_PROGRAMA_PROD,PP.NOMBRE_PROGRAMA_PROD,PP.OBSERVACIONES";
            sql += ",(SELECT EP.NOMBRE_ESTADO_PROGRAMA_PROD FROM ESTADOS_PROGRAMA_PRODUCCION EP WHERE EP.COD_ESTADO_PROGRAMA_PROD = PP.COD_ESTADO_PROGRAMA)";
            sql += " FROM PROGRAMA_PRODUCCION_PERIODO PP WHERE PP.COD_ESTADO_PROGRAMA<>4 and (pp.COD_TIPO_PRODUCCION is null or  pp.COD_TIPO_PRODUCCION =1)" +
                    " and cod_programa_prod>223";
            
            ResultSet res = st.executeQuery(sql);
                        %>

                        <td class="">
                            <!--   <select name="codAreaEmpresa" class="outputText3" >-->
                            <select name="codProgramaProd" size="10" class="inputText" multiple onchange="form1.chk_todoProg.checked=false">
                                <%
                            String codProgProd = "";
                            String nombreProgProd = "";
                            while (res.next()) {
                                codProgProd = "'"+res.getString("COD_PROGRAMA_PROD")+"'";
                                nombreProgProd = res.getString("NOMBRE_PROGRAMA_PROD");
                                %>
                                <option value="<%=codProgProd%>"><%=nombreProgProd%></option>
                                <%
                            }
                            
                            %>
                            </select>
                            <input type="checkbox"  onclick="seleccionarTodosProg(form1)" name="chk_todoProg" >Todo
                            <%
                            }catch(SQLException ex)
                            {
                                ex.printStackTrace();
                            }
                                  
                            %>
                        </td>
                    </tr>

                    
                     
                     <tr class="outputText3" >
                        <td class="">Lote</td>
                        <td class="">::</td>


                        <td class=""><input type="text" value="" id="codLote" name="codLote" class="inputText"/></td>
                     </tr>

                </table>

            </div>
            <br>
            <center>
                <input type="button" class="btn"  value="Ver Reporte" name="reporte" onclick="verReporteDiferenciaFechas(form1)">
                <input type="hidden" name="codigosArea" id="codigosArea">

            </center>
            <!--datos de referencia para el envio de datos via post-->

            <input type="hidden" name="codFormulaMaestraP">
            <input type="hidden" name="nombreProductoP">
            <input type="hidden" name="codProg">
             <input type="hidden" name="nombreProg">
            <input type="hidden" name="codTodoProg" value="">
             <input type="hidden" name="codTodoActividad" value="">
            <input type="hidden" name="nomProgPeriodo" value="">
             <input type="hidden" name="nomTipoActividad" value="">


        </form>
        <script type="text/javascript" language="JavaScript"  src="../js/dlcalendar.js"></script>
    </body>
</html>