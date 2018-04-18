<%@ page import="com.cofar.util.*" %>
<%@ page import="com.cofar.web.*" %>
<%@ page import = "java.sql.Connection"%>
<%@ page import = "java.sql.DriverManager"%> 
<%@ page import = "java.sql.ResultSet"%> 
<%@ page import = "java.sql.Statement"%> 
<%@ page import = "java.sql.*"%> 
<%@ page import = "java.text.SimpleDateFormat"%> 
<%@ page import = "java.util.ArrayList"%> 
<%@ page import = "java.util.Date"%> 
<%@ page import = "javax.servlet.http.HttpServletRequest"%>
<%@ page import = "java.text.DecimalFormat"%> 
<%@ page import = "java.text.NumberFormat"%> 
<%@ page import = "java.util.Locale"%> 
<%@ page language="java" import="java.util.*,com.cofar.util.CofarConnection" %>
<%@ page errorPage="ExceptionHandler.jsp" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>

        <%--meta http-equiv="Content-Type" content="text/html; chareset=UTF-8"--%>
        <title>JSP Page</title>
        <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
        <script src="../../js/general.js"></script>
        <script>
            function openPopup(url){
                window.open(url,'DETALLE'+Math.round(Math.random()*1000),'top=50,left=200,width=800,height=600,scrollbares=1,resizable=1');
                return false;
            }
            function openPopup1(url,height){
                window.open(url,'DETALLE'+Math.round(Math.random()*1000),'top=50,left=200,width=800,height='+height+',scrollbares=1,resizable=1');
                return false;
            }
        </script>
        <style type="text/css">
            .celdaProduccion
            {
                background-color: #e6f8e9;
            }
            .celdaReacondicionados
            {
                background-color: #feedf1;
            }
            .celdaRendimiento
            {
                background-color: #e6f8e9;
                border:2px solid #5fc569 !important;
                border-right:2px solid #5fc569 !important;
                border-bottom:2px solid #5fc569 !important;
                font-weight: bold;
            }
        </style>
    </head>
    <body>
        <h3 align="center">Reporte Información del Lote</h3>
        <form>
            <table align="center" width="90%">

                <%
        Connection con=null;
        try {
            
            String codLoteProduccionFiltro=request.getParameter("codLoteProduccion");
            boolean reporteConFechas = request.getParameter("checkFechaCambio")!=null;
            String fechaInicioReporte = request.getParameter("fechaInicioReporte");
            String fechaFinalReporte = request.getParameter("fechaFinalReporte");
            System.out.println("reporte con fechas "+reporteConFechas);
            String codProgramaProdPeriodo = request.getParameter("codProgramaProduccionPeriodo") == null ? "0" : request.getParameter("codProgramaProduccionPeriodo");
            String nombreProgramaProdPeriodo = request.getParameter("nombreProgramaProduccionPeriodo") == null ? "0" : request.getParameter("nombreProgramaProduccionPeriodo");
            int codEstadoProgramaProd = Integer.valueOf(request.getParameter("codEstadoProgramaProd") == null ? "0" : request.getParameter("codEstadoProgramaProd"));
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
            out.println("<table align='center' width='60%' class='outputText0'>");
                out.println("<tr>");
                        out.println("<td width='10%' rowspan='5'>");
                            out.println("<img src='../../img/cofar.png'>");
                        out.println("</td>");
                        out.println("<td width='25%' class='outputTextBold' >Programa Producción : </td>");
                        out.println("<td class='outputText2'>"+nombreProgramaProdPeriodo+"</td>");
                out.println("</tr>");
                out.println("<tr>");
                        out.println("<td class='outputTextBold'>Estado Programa Producción:</td>");
                        out.println("<td class='outputText2'>"+request.getParameter("nombreEstadoProgramaProduccion")+"</td>");
                    out.println("</tr>");
                if(reporteConFechas)
                {
                    out.println("<tr>");
                        out.println("<td class='outputTextBold'>Fecha Inicio:</td>");
                        out.println("<td class='outputText2'>"+fechaInicioReporte+"</td>");
                    out.println("</tr>");
                    out.println("<tr>");
                        out.println("<td class='outputTextBold'>Fecha Final:</td>");
                        out.println("<td class='outputText2'>"+fechaFinalReporte+"</td>");
                    out.println("</tr>");
                }
            out.println("</table>");
                   
            %>
                
            </table>
            <table  ></table>
            <table  align="center" class="tablaReporte" cellpadding="0" cellspacing="0">
                <thead>
                    <tr>
                        <td rowspan='2'>Nro</td>
                        <td rowspan='2'>Producto</td>
                        <td rowspan='2'>Area</td>
                        <td rowspan='2'>Programa Produccion</td>
                        <td rowspan='2'>Lote</td>
                        <td rowspan='2'>Fecha Pesaje</td>
                        <td rowspan='2'>Fecha Venc.</td>
                        <td rowspan='2'>Tamaño Lote</td>
                        <td rowspan='2'>Cant. Enviada de Produccion ACD</td>
                        <td rowspan='2'>Saldo en Proceso Produccion</td>
                        <td rowspan='2'>Fecha Preparación Produccion</td>
                        <td rowspan='2'>Rendimiento Producción</td>
                        <td rowspan='2'>Fecha Ingreso Cuarentena</td>
                        <td rowspan='2'>Fecha Cierre Producción</td>
                        <td colspan='7' class="tdCenter">Producto de Producción Acondicionado</td>
                        <td colspan='7' class="tdCenter">Producto Reacondicionado</td>
                        <td rowspan='2'>Cant. Existencia Acond. a la fecha</td>
                        <td rowspan='2'>Rendimiento Total</td>
                        <td rowspan='2'>Lote Cerrado</td>
                        <td rowspan='2'>Fecha Liberación</td>
                        <td rowspan='2'>Cant. Liberación</td>
                        <td rowspan='2'>OOS</td>
                        <td rowspan='2'>Desviación</td>
                        <td rowspan='2'>Horas Hombre Pesaje</td>
                        <td rowspan='2'>Horas Hombre Producción</td>
                        <td rowspan='2'>Horas Hombre Almacen</td>
                        <td rowspan='2'>Horas Hombre Control Calidad</td>
                        <td rowspan='2'>Horas Hombre Soporte a la Manufactura</td>
                        <td rowspan='2'>Horas Hombre Microbiologia</td>
                        <td rowspan='2'>Horas Hombre Acondicionamiento</td>
                        <td rowspan='2'>Horas Hombre Acondicionamiento Presentación</td>
                    </tr>
                    <tr>
                        <td >Cant. Enviada APT MC</td>
                        <td >Cant. Enviada APT MM</td>
                        <td >Cant. Enviada APT MI</td>
                        <td >Cant. ReAcondicionado</td>
                        <td >Cant. Estabilidad</td>
                        <td >Cant. CC Quintanilla</td>
                        <td >Cant. Saldos</td>
                        <td >Cant. Enviada APT MC</td>
                        <td >Cant. Enviada APT MM</td>
                        <td >Cant. Enviada APT MI</td>
                        <td >Cant. ReAcondicionado</td>
                        <td >Cant. Estabilidad</td>
                        <td >Cant. CC Quintanilla</td>
                        <td >Cant. Saldos</td>
                    </tr>
                </thead>
                <%
            NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);        
            DecimalFormat format = (DecimalFormat) nf;
            format.applyPattern("#,##0.00");        
            String[] arrayFecha=fechaInicioReporte.split("/");
            fechaInicioReporte=arrayFecha[2]+"/"+arrayFecha[1]+"/"+arrayFecha[0];
            arrayFecha=fechaFinalReporte.split("/");
            fechaFinalReporte=arrayFecha[2]+"/"+arrayFecha[1]+"/"+arrayFecha[0];
            StringBuilder consulta =new StringBuilder(" SET NOCOUNT ON DECLARE @codigosProgramaProduccion TdatosIntegerRef ");
                                consulta.append(" INSERT INTO @codigosProgramaProduccion ");
                                if(codProgramaProdPeriodo.length()>0)
                                {
                                        consulta.append(" VALUES (0)");
                                    for(String codProgramaProdRef:codProgramaProdPeriodo.split(","))
                                        consulta.append(" ,(").append(codProgramaProdRef).append(")");
                                }
                                else
                                {
                                    consulta.append(" SELECT PP.COD_PROGRAMA_PROD FROM PROGRAMA_PRODUCCION_PERIODO PP WHERE PP.COD_ESTADO_PROGRAMA<>4 and pp.cod_tipo_produccion=1");
                                }
                                consulta.append(" EXEC PAA_LISTAR_REPORTE_INFORMACION_LOTE ");
                                    consulta.append(" @codigosProgramaProduccion,");
                                    consulta.append(" '"+codLoteProduccionFiltro+"',");
                                    consulta.append(codEstadoProgramaProd).append(",");
                                    if(reporteConFechas)
                                    {
                                        consulta.append("'"+fechaInicioReporte+" 00:00','"+fechaFinalReporte+" 23:59'");
                                    }
                                    else
                                    {
                                        consulta.append("null,null");
                                    }
                                    
                                consulta.append(" SET NOCOUNT OFF ");
            System.out.println("consulta datos lote" + consulta.toString());
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            SimpleDateFormat sdfDias=new SimpleDateFormat("dd/MM/yyyy");
            SimpleDateFormat sdfDiasHoras = new SimpleDateFormat("dd/MM/yyyy HH:mm");
            while(res.next())
            {
                out.print("<tr>");
                    out.println("<td >"+res.getRow()+"</td>");
                    out.println("<td >"+res.getString("nombreProducto")+"</td>");
                    out.println("<td >"+res.getString("NOMBRE_AREA_EMPRESA")+"</td>");
                    out.println("<td >"+res.getString("NOMBRE_PROGRAMA_PROD")+"</td>");
                    out.println("<td >"+res.getString("COD_LOTE_PRODUCCION")+"</td>");
                    out.println("<td >"+(res.getDate("fechaPesaje")!=null?sdfDias.format(res.getDate("fechaPesaje")):"&nbsp;")+"</td>");
                    out.println("<td >"+res.getString("fechaVencimiento")+"</td>");
                    out.println("<td  align='right'>"+res.getInt("cantLoteProduccion")+"</td>");
                    out.println("<td  align='right'>"+res.getInt("cantidadIngresoProduccion")+"</td>");
                    out.println("<td  align='right'>"+(res.getInt("cantLoteProduccion")-res.getInt("cantidadIngresoProduccion"))+"</td>");
                    out.println("<td  align='right'>"+(res.getDate("fechaProduccion")!=null?sdfDias.format(res.getDate("fechaProduccion")):"&nbsp;")+"</td>");
                    out.println("<td  align='right' class='celdaRendimiento'>"+format.format(res.getDouble("cantidadIngresoProduccion")/res.getDouble("cantLoteProduccion")*100)+"</td>");
                    out.println("<td  align='right'>"+(res.getDate("fechaIngresoCuarentena")!=null?sdfDias.format(res.getDate("fechaIngresoCuarentena")):"&nbsp;")+"</td>");
                    out.println("<td  align='right'>"+((res.getInt("cantidadLotesNoCerrados") == 0 && res.getDate("ultimaFechaIngresoAcond")!=null) ?sdfDiasHoras.format(res.getTimestamp("ultimaFechaIngresoAcond")):"&nbsp;")+"</td>");
                    out.println("<td  align='right' class='celdaProduccion'>"+res.getInt("cantidadIngresoCuarentenaMC")+"</td>");
                    out.println("<td  align='right' class='celdaProduccion'>"+res.getInt("cantidadIngresoCuarentenaMM")+"</td>");
                    out.println("<td  align='right' class='celdaProduccion'>"+res.getInt("cantidadIngresoCuarentenaIns")+"</td>");
                    out.println("<td  align='right' class='celdaProduccion'>"+res.getInt("cantidaSalidaReacond")+"</td>");
                    out.println("<td  align='right' class='celdaProduccion'>"+res.getInt("cantidaSalidaEst")+"</td>");
                    out.println("<td  align='right' class='celdaProduccion'>"+res.getInt("cantidaSalidaCc")+"</td>");
                    out.println("<td  align='right' class='celdaProduccion'>"+res.getInt("cantidaSalidaSaldo")+"</td>");
                    out.println("<td  align='right' class='celdaReacondicionados'>"+res.getInt("cantidadIngresoCuarentenaMCReacond")+"</td>");
                    out.println("<td  align='right' class='celdaReacondicionados'>"+res.getInt("cantidadIngresoCuarentenaMMReacond")+"</td>");
                    out.println("<td  align='right' class='celdaReacondicionados'>"+res.getInt("cantidadIngresoCuarentenaInsReacond")+"</td>");
                    out.println("<td  align='right' class='celdaReacondicionados'>"+res.getInt("cantidaSalidaReacondReacond")+"</td>");
                    out.println("<td  align='right' class='celdaReacondicionados'>"+res.getInt("cantidaSalidaEstReacond")+"</td>");
                    out.println("<td  align='right' class='celdaReacondicionados'>"+res.getInt("cantidaSalidaCcReacond")+"</td>");
                    out.println("<td  align='right' class='celdaReacondicionados'>"+res.getInt("cantidaSalidaSaldoReacond")+"</td>");
                    out.println("<td  align='right'>"+res.getInt("cantidadRestanteAcond")+"</td>");
                    out.println("<td  align='right' class='celdaRendimiento'>"+format.format((res.getDouble("cantidaSalidaSaldo")+res.getDouble("cantidaSalidaCc")+res.getDouble("cantidaSalidaEst")+res.getDouble("cantidadIngresoCuarentenaIns")+res.getDouble("cantidadIngresoCuarentenaMC")+res.getDouble("cantidadIngresoCuarentenaMM")+res.getDouble("cantidadEnviadaAptSinAceptar"))/res.getDouble("cantLoteProduccion")*100)+"</td>");
                    out.println("<td >"+(res.getInt("cantidadRestanteAcond")==0&&res.getInt("cantidadLotesNoCerrados")==0?"SI":"NO")+"</td>");
                    out.println("<td >"+(res.getDate("fechaLiberacion")!=null?sdfDias.format(res.getDate("fechaLiberacion")):"&nbsp;")+"</td>");
                    out.println("<td >"+res.getInt("cantidadLiberacion")+"</td>");
                    out.println("<td >"+(res.getInt("cantOos")>0?"SI":"NO")+"</td>");
                    out.println("<td >"+(res.getInt("cantDesviacion")>0?"SI":"NO")+"</td>");
                    out.println("<td  align='right'>"+format.format(res.getDouble("sumaPesaje"))+"</td>");
                    out.println("<td  align='right'>"+format.format(res.getDouble("sumaProduccion"))+"</td>");
                    out.println("<td  align='right'>"+format.format(res.getDouble("sumaAlmacen"))+"</td>");
                    out.println("<td  align='right'>"+format.format(res.getDouble("sumaControlCalidad"))+"</td>");
                    out.println("<td  align='right'>"+format.format(res.getDouble("sumaSoporte"))+"</td>");
                    out.println("<td  align='right'>"+format.format(res.getDouble("sumaMicrobiologia"))+"</td>");
                    out.println("<td  align='right'>"+format.format(res.getDouble("sumaAcondicionamiento"))+"</td>");
                    out.println("<td  align='right'>"+res.getString("horaPresentacion")+"</td>");
                out.print("</tr>");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        finally
        {
            con.close();
        }
                %>

            </table>



        </form>
    </body>
</html>