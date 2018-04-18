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
        <link rel="STYLESHEET" type="text/css" href="../../css/chosen.css" />
        <script src="../../js/general.js"></script>
        <script src="../../js/chosen.js"></script>
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


        <script >
            function seleccionTodoPrograma(f)
            {
                for(var i=0;i<f.codProgramaProdPeriodo.options.length;i++)
                    {
                        f.codProgramaProdPeriodo.options[i].selected=f.chkProgramaProd.checked;
                    }
      
            }
            function verReporteEspecificacionesControlCalidad(f)
            {
                var codProgramaProd=new Array();
                var nombreProgramaProd=new Array();
                for(var i=0;i<f.codProgramaProdPeriodo.options.length;i++)
                {
                    if(f.codProgramaProdPeriodo.options[i].selected)
                    {
                        codProgramaProd.push(f.codProgramaProdPeriodo.options[i].value);
                        nombreProgramaProd.push(f.codProgramaProdPeriodo.options[i].innerHTML);
                    }
                }
                var codEstadoResultado=new Array();
                var nombreEstadoResultado=new Array();
                for(var i=0;i<f.codEstadoCertificado.options.length;i++){
                    if(f.codEstadoCertificado.options[i].selected){
                        codEstadoResultado.push(f.codEstadoCertificado.options[i].value)
                        nombreEstadoResultado.push(f.codEstadoCertificado.options[i].innerHTML);
                    }

                }
                f.nombreComponenteProd.value=f.codComprodProducto.options[f.codComprodProducto.selectedIndex].innerHTML;
                f.nombreEstadoProgramaProd.value=nombreEstadoResultado;
                f.codEstadoProgramaProd.value=codEstadoResultado;
                f.nombreProgramaProd.value=nombreProgramaProd;
                f.codProgramaProd.value=codProgramaProd;
                f.submit();

            }


        </script>



    </head>
    <body>
        <h3 style="top:1px" align="center">Reporte Resultados de Especificaciones de Control de Calidad</h3 >

        <form method="post" action="reporteEspecificacionesCCLote.jsf" target="_blank" style="top:1px" name="form1">
            <div align="center">
                <table cellpading="0" cellspacing="0" class="tablaFiltroReporte" >
                    <thead>
                        <tr>
                            <td colspan="3">Introduzca los parámetros del reporte</td>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                        <td class="outputTextBold">Programa de Producción</td>
                        <td class="outputTextBold">::</td>
                        <%
                            Connection con=null;
                            try {
                                con = Util.openConnection(con);
                                Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                String consulta= "SELECT PP.COD_PROGRAMA_PROD,PP.NOMBRE_PROGRAMA_PROD,PP.OBSERVACIONES"+
                                                ",(SELECT EP.NOMBRE_ESTADO_PROGRAMA_PROD FROM ESTADOS_PROGRAMA_PRODUCCION EP WHERE EP.COD_ESTADO_PROGRAMA_PROD = PP.COD_ESTADO_PROGRAMA)"+
                                                " FROM PROGRAMA_PRODUCCION_PERIODO PP WHERE PP.COD_ESTADO_PROGRAMA<>4 and (pp.COD_TIPO_PRODUCCION is null or  pp.COD_TIPO_PRODUCCION =1)";
                                ResultSet res=st.executeQuery(consulta);
                        %>
                        <td>
                            <select name="codProgramaProdPeriodo" size="6" class="inputText" multiple onchange="form1.chkProgramaProd.checked=false;">
                                <%
                                while (res.next()) {
                                    out.println("<option value='"+res.getString("COD_PROGRAMA_PROD")+"'>"+res.getString("NOMBRE_PROGRAMA_PROD")+"</option>");
                                }%>
                            </select>
                            <input type="checkbox"  onclick="seleccionTodoPrograma(form1)" name="chkProgramaProd" >Todo
                        </td>
                    </tr>
                     <tr>
                        <td class="outputTextBold">Producto</td>
                        <td class="outputTextBold">::</td>
                        <td class="">
                            <select id="codComprodProducto" name="codComprodProducto" class="chosen">
                                <%
                                    consulta="select cp.COD_COMPPROD,cp.nombre_prod_semiterminado"+
                                             " from COMPONENTES_PROD cp where cp.COD_TIPO_PRODUCCION IN (1,3) and cp.COD_ESTADO_COMPPROD=1"+
                                             " order by cp.nombre_prod_semiterminado";
                                    res=st.executeQuery(consulta);
                                    while(res.next())
                                    {
                                        out.println("<option value='"+res.getInt("COD_COMPPROD")+"'>"+res.getString("nombre_prod_semiterminado")+"</option>");
                                    }
                                %>
                             </select>
                        </td>
                    </tr>
                    <tr>
                        <td class="outputTextBold">Estado Certificado CC</td>
                        <td class="outputTextBold">::</td>
                        <td class="">
                            <select id="codEstadoCertificado" name="codEstadoCertificado" multiple size="5" class="inputText">
                                <%
                                    consulta="select er.NOMBRE_ESTADO_RESULTADO_ANALISIS,er.COD_ESTADO_RESULTADO_ANALISIS"+
                                            " from ESTADOS_RESULTADO_ANALISIS er order by er.NOMBRE_ESTADO_RESULTADO_ANALISIS";
                                    res=st.executeQuery(consulta);
                                    while(res.next())
                                    {
                                        out.println("<option value='"+res.getInt("COD_ESTADO_RESULTADO_ANALISIS")+"'>"+res.getString("NOMBRE_ESTADO_RESULTADO_ANALISIS")+"</option>");
                                    }
                                %>
                             </select>
                        </td>
                    </tr>

                     <%
                            }
                            catch(SQLException ex){
                                ex.printStackTrace();
                            }
                            finally{
                                con.close();
                            }
                     %>
                    </tbody>
                    <tfoot>
                        <tr>
                            <td colspan="3" class="tdCenter">
                                <input type="button" class="btn"  value="Ver Reporte" name="reporte" onclick="verReporteEspecificacionesControlCalidad(form1)">
                            </td>
                        </tr>
                    </tfoot>
                </table>

            </div>
                
                
            <input type="hidden" name="codProgramaProd" id="codProgramaProd"/>
            <input type="hidden" name="nombreProgramaProd" id="nombreProgramaProd"/>
            <input type="hidden" name="codEstadoProgramaProd" id="codEstadoProgramaProd"/>
            <input type="hidden" name="nombreEstadoProgramaProd" id="nombreEstadoProgramaProd"/>
            <input type="hidden" name="nombreComponenteProd" id="nombreComponenteProd"/>
            <script type="text/javascript">
                cargarChosen();
            </script>
        </form>
        
    </body>
</html>