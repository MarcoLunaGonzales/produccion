

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
                for(var i=0;i<=f.codForma.options.length-1;i++)
                {
                    f.codForma.options[i].selected=f.chk_todoTipo.checked;
                }
            }

           
            function filtraPorCodigoProgramaProduccion(codProgramaProduccionPeriodo){
                // var codigo=f.codAreaEmpresa.value;
                
                location.href="filtroReporteSeguimientoProgramaProduccion.jsf?codProgramaProduccionPeriodo="+codProgramaProduccionPeriodo;
            }

       function enviaProgramaProduccion(f){
           
        var arrayCompProd=new Array();
        var arrayCompProd1=new Array();
        var j=0;
        for(var i=0;i<=f.codForma.options.length-1;i++)
        {	if(f.codForma.options[i].selected)
            {	arrayCompProd[j]=f.codForma.options[i].value;
                arrayCompProd1[j]=f.codForma.options[i].innerHTML;
                j++;
            }
        }
        f.codCompProdArray.value=arrayCompProd;
        f.nombreCompProd.value=arrayCompProd1;       

       
        
        f.action="reporteEspecificacionesFormaFarmaceutica.jsf";
        f.submit();
            }
        

        </script>



    </head>
    <body><br><br>
        <h3 align="center">Reporte de Especificaciones por forma Farmaceútica</h3>

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
                        <td class="">Formas Farmaceuticas</td>
                        <td class="">::</td>
                        <%
                           String codProgramaProduccionPeriodoReq ="";
                           if(request.getParameter("codProgramaProduccionPeriodo")!=null)
                           {codProgramaProduccionPeriodoReq = request.getParameter("codProgramaProduccionPeriodo");}
                           try {
                            con = Util.openConnection(con);
                            System.out.println("con:::::::::::::" + con);
                            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                            String consulta = "select f.cod_forma,f.nombre_forma,f.abreviatura_forma,u.COD_UNIDAD_MEDIDA,u.NOMBRE_UNIDAD_MEDIDA " +
                                    " from FORMAS_FARMACEUTICAS f inner join UNIDADES_MEDIDA u on u.COD_UNIDAD_MEDIDA = f.cod_unidad_medida " +
                                    " where f.cod_estado_registro = 1 order by f.nombre_forma";
                            ResultSet rs = st.executeQuery(consulta);
                        %>
                        <td class="">
                            <div>
                            <select name="codForma" class="outputText3" style="height:150px" multiple >
                                <%
                            String codProgramaProduccionPeriodo = "";
                            String nombreProgramaProduccionPeriodo = "";
                          
                            while (rs.next()) {
                                codProgramaProduccionPeriodo = rs.getString("cod_forma");
                                nombreProgramaProduccionPeriodo = rs.getString("nombre_forma");
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