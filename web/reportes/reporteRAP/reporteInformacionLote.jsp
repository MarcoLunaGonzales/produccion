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
<%! public String nombrePresentacion1(String codPresentacion) {
        Connection con1=null;


        String nombreproducto = "";

        try {
            con1 = Util.openConnection(con1);
            String sql_aux = "select cod_presentacion, nombre_producto_presentacion from presentaciones_producto where cod_presentacion='" + codPresentacion + "'";
            System.out.println("PresentacionesProducto:sql:" + sql_aux);
            Statement st = con1.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(sql_aux);
            while (res.next()) {
                String codigo = res.getString(1);
                nombreproducto = res.getString(2);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "";
    }

%>

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
    </head>
    <body>
        <h3 align="center">Reporte Información del Lote</h3>
        <form>
            <table align="center" width="90%">

                <%
        Connection con=null;
        try {
            NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
            DecimalFormat format = (DecimalFormat) nf;
            format.applyPattern("#,###");
            String codLoteProduccionFiltro=request.getParameter("codLoteProduccion");
            boolean reporteConFechas=request.getParameter("checkFechaCambio")!=null;
            String fechaInicioReporte=request.getParameter("fechaInicioReporte");
            String fechaFinalReporte=request.getParameter("fechaFinalReporte");
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
                        <td>Nro</td>
                        <td>Producto</td>
                        <td>Tipo Programa Produccion</td>
                        <td>Programa Produccion</td>
                        <td>Lote</td>

                        <td>Fecha Pesaje</td>
                        <td>Fecha Venc.</td>
                        <td>Estado Produccion</td>
                        <td>Tamaño Lote</td>
                        <td>Cant. Enviada de Produccion ACD</td>
                        <td>Saldo en Proceso Produccion</td>
                        <td>Cant. Ingreso Acond</td>
                        <td>Devoluciones Produccion</td>
                        <td>Fecha Preparación Produccion</td>
                        <td>FRV Produccion</td>
                        <td>Rendimiento Producción</td>
                        <td>Fecha Ingreso Cuarentena</td>
                        <td>Cant. Ingreso APT MC</td>
                        <td>Cant. Ingreso APT MM</td>
                        <td>Cant. Ingreso APT MI</td>
                        <td>Cant. ReAcondicionado</td>
                        <td>Cant. Estabilidad</td>
                        <td>Cant. CC Quintanilla</td>
                        <td>Cant. Saldos</td>
                        <td>Rendimiento Total</td>
                        <td>Lote Cerrado</td>
                        <td>Fecha Liberación</td>
                        <td>Cant. Liberación</td>
                        <td>Estado Certificado C.C.</td>
                        <td>Fecha Emisión Certificado C.C.</td>
                        <td>OOS</td>
                        <td>Desviación</td>
                    </tr>
                </thead>
                <%
            String[] arrayFecha=fechaInicioReporte.split("/");
            fechaInicioReporte=arrayFecha[2]+"/"+arrayFecha[1]+"/"+arrayFecha[0];
            arrayFecha=fechaFinalReporte.split("/");
            fechaFinalReporte=arrayFecha[2]+"/"+arrayFecha[1]+"/"+arrayFecha[0];
            StringBuilder consulta =new StringBuilder("select cpv.nombre_prod_semiterminado,ppp.NOMBRE_PROGRAMA_PROD,pp.COD_LOTE_PRODUCCION,pp.COD_COMPPROD,");
                                                consulta.append(" tpp.COD_TIPO_PROGRAMA_PROD,tpp.NOMBRE_TIPO_PROGRAMA_PROD,pp.CANT_LOTE_PRODUCCION,epp.NOMBRE_ESTADO_PROGRAMA_PROD,cpv.COD_COMPPROD,");
                                                consulta.append(" DATEADD(MONTH,cpv.VIDA_UTIL,datosPesaje.fechaInicio) as fechaVencimiento,");      
                                               consulta.append(" datosProduccion.fechaInicio as fechaProduccion,datosPesaje.fechaInicio,cantidadIngresoAcond.cantidadIngresoProduccion,fechaAlmacen.fechaSalidaAlmacen,");
                                               consulta.append(" salidasAcond.cantidadEnviadaAPT,ultimoTipoEntrega.NOMBRE_TIPO_ENTREGA_ACOND,");
                                               consulta.append(" detalleIngresoAcond.cantidadTotalIngreso,detalleIngresoVenta.cantidadIngresoVentas,detalleIngresoVenta.fechaIngresoCuarentena,");
                                               consulta.append(" salidaAcondFrv.cantidaSalidaFrv,salidaAcondReacond.cantidaSalidaReacond,salidaAcondEst.cantidaSalidaEst,");
                                               consulta.append(" salidaAcondCc.cantidaSalidaCc,salidaAcondSaldo.cantidaSalidaSaldo,");
                                               consulta.append(" ingresosCierre.cantIngresosCierreLote,salidasCierre.cantSalidaCierreLote,");
                                               consulta.append(" detalleLiberacion.fechaLiberacion,detalleLiberacion.cantidadLiberacion,");
                                               consulta.append(" cierreAcond.cantidadCierres,isnull(era.NOMBRE_ESTADO_RESULTADO_ANALISIS,'No Registrado') as estadoCertificado,ra.FECHA_EMISION,");
                                               consulta.append(" detalleOos.cantOos,detalleDesviacion.cantDesviacion");
                                        consulta.append(" from PROGRAMA_PRODUCCION pp");
                                             consulta.append(" inner join PROGRAMA_PRODUCCION_PERIODO ppp on ppp.COD_PROGRAMA_PROD =pp.COD_PROGRAMA_PROD");
                                             consulta.append(" inner join COMPONENTES_PROD_VERSION cpv on cpv.COD_COMPPROD = pp.COD_COMPPROD");
                                                        consulta.append(" and cpv.COD_VERSION=pp.COD_COMPPROD_VERSION");
                                             consulta.append(" inner join ESTADOS_PROGRAMA_PRODUCCION epp on epp.COD_ESTADO_PROGRAMA_PROD=pp.COD_ESTADO_PROGRAMA");
                                             consulta.append(" inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD");
                                             consulta.append(" left outer join RESULTADO_ANALISIS ra on ra.COD_LOTE=pp.COD_LOTE_PRODUCCION");
                                                        consulta.append(" and ra.COD_COMPROD=pp.COD_COMPPROD");
                                             consulta.append(" left outer join ESTADOS_RESULTADO_ANALISIS era on era.COD_ESTADO_RESULTADO_ANALISIS=ra.COD_ESTADO_RESULTADO_ANALISIS ");
                                             if(reporteConFechas&&codEstadoProgramaProd==6)
                                             {
                                                        consulta.append(" inner join PROGRAMA_PRODUCCION_INGRESOS_ACOND ppia on pp.COD_LOTE_PRODUCCION=ppia.COD_LOTE_PRODUCCION");
                                                                consulta.append(" and ppia.COD_COMPPROD=pp.COD_COMPPROD");
                                                                consulta.append(" and ppia.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD");
                                                                consulta.append(" and ppia.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD");
                                                                consulta.append(" and ppia.COD_TIPO_ENTREGA_ACOND=2");
                                                        consulta.append(" inner join INGRESOS_ACOND ia on ia.COD_INGRESO_ACOND=ppia.COD_INGRESO_ACOND");
                                                                consulta.append(" and ia.fecha_ingresoacond BETWEEN '").append(fechaInicioReporte).append(" 00:00' and '").append(fechaFinalReporte).append(" 23:59'");
                                             }
                                             consulta.append(" outer apply ");
                                             consulta.append(" (");
                                                consulta.append(" select top 1 tea.NOMBRE_TIPO_ENTREGA_ACOND");
                                                consulta.append(" from PROGRAMA_PRODUCCION_INGRESOS_ACOND ppia");
                                                        consulta.append(" inner join TIPOS_ENTREGA_ACOND tea on tea.COD_TIPO_ENTREGA_ACOND=ppia.COD_TIPO_ENTREGA_ACOND");
                                                consulta.append(" where ppia.COD_PROGRAMA_PROD=ppp.COD_PROGRAMA_PROD");
                                                        consulta.append(" and ppia.COD_COMPPROD=pp.COD_COMPPROD");
                                                    consulta.append(" and ppia.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD");
                                                    consulta.append(" and ppia.COD_LOTE_PRODUCCION=pp.COD_LOTE_PRODUCCION");
                                                consulta.append(" order by ppia.COD_INGRESO_ACOND desc ");
                                             consulta.append(" ) as ultimoTipoEntrega");
                                             consulta.append(" left join");
                                             consulta.append(" (");
                                                 consulta.append(" select SUM(sd.CANT_TOTAL_SALIDADETALLEACOND) as cantidadEnviadaAPT,sd.COD_LOTE_PRODUCCION,sd.COD_COMPPROD,");
                                                                consulta.append(" case sa.COD_ALMACEN_VENTA when 54 then 1 when 56 then 2 when 57 then 3 else 0 end  as codTipoProgramaProd");
                                                 consulta.append(" from SALIDAS_ACOND sa");
                                                      consulta.append(" inner join SALIDAS_DETALLEACOND sd on sa.COD_SALIDA_ACOND =sd.COD_SALIDA_ACOND");
                                                 consulta.append(" where sa.COD_ESTADO_SALIDAACOND not in (2)");
                                                 consulta.append(" group by sd.COD_LOTE_PRODUCCION,sd.COD_COMPPROD,sd.COD_LOTE_PRODUCCION,sa.COD_ALMACEN_VENTA");
                                             consulta.append(" ) as salidasAcond on salidasAcond.codTipoProgramaProd=pp.COD_TIPO_PROGRAMA_PROD");
                                                        consulta.append(" and salidasAcond.COD_LOTE_PRODUCCION=pp.COD_LOTE_PRODUCCION");
                                                    consulta.append(" and salidasAcond.COD_COMPPROD=pp.COD_COMPPROD");
                                                    consulta.append(" and salidasAcond.codTipoProgramaProd=pp.COD_TIPO_PROGRAMA_PROD	");
                                             consulta.append(" LEFT JOIN ");
                                             consulta.append(" (");
                                                 consulta.append(" select MIN(sa.FECHA_SALIDA_ALMACEN) AS fechaSalidaAlmacen,sa.COD_LOTE_PRODUCCION");
                                                 consulta.append(" from SALIDAS_ALMACEN sa");
                                                 consulta.append(" where sa.COD_ESTADO_SALIDA_ALMACEN = 1");
                                                         consulta.append(" and sa.ESTADO_SISTEMA = 1 ");
                                                     consulta.append(" and sa.cod_almacen in (1, 2)");
                                                     consulta.append(" and LEN(sa.COD_LOTE_PRODUCCION)>4");
                                                 consulta.append(" group by sa.COD_LOTE_PRODUCCION    ");
                                             consulta.append(" ) as fechaAlmacen on fechaAlmacen.COD_LOTE_PRODUCCION=pp.COD_LOTE_PRODUCCION");
                                             consulta.append(" left join");
                                             consulta.append(" (");
                                                 consulta.append(" select sum(iad.CANT_INGRESO_PRODUCCION) as cantidadIngresoProduccion,iad.COD_LOTE_PRODUCCION,iad.COD_COMPPROD  ");
                                                 consulta.append(" from INGRESOS_ACOND ia");
                                                      consulta.append(" inner join INGRESOS_DETALLEACOND iad on iad.COD_INGRESO_ACOND =ia.COD_INGRESO_ACOND");
                                                 consulta.append(" where ia.COD_TIPOINGRESOACOND = 1 ");
                                                                consulta.append(" and ia.COD_ALMACENACOND in (1, 3)");
                                                        consulta.append(" and ia.cod_estado_ingresoacond not in (1, 2)");	
                                                 consulta.append(" group by iad.COD_LOTE_PRODUCCION,iad.COD_COMPPROD  ");    
                                             consulta.append(" ) as cantidadIngresoAcond on cantidadIngresoAcond.COD_LOTE_PRODUCCION=pp.COD_LOTE_PRODUCCION");
                                                        consulta.append(" and cantidadIngresoAcond.COD_COMPPROD=pp.COD_COMPPROD");
                                             consulta.append(" left join");
                                             consulta.append(" (");
                                                 consulta.append(" select max(s.FECHA_INICIO) as fechaInicio,s.COD_LOTE_PRODUCCION");
                                                 consulta.append(" from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL s");
                                                          consulta.append(" inner join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_ACTIVIDAD_FORMULA =s.COD_ACTIVIDAD_PROGRAMA");
                                                                consulta.append(" and afm.COD_AREA_EMPRESA=97");
                                                 consulta.append(" where afm.COD_ACTIVIDAD in (76, 186)");
                                                            if(codProgramaProdPeriodo.length()>0)
                                                                consulta.append(" and s.COD_PROGRAMA_PROD  in(").append(codProgramaProdPeriodo).append(")");
                                                      consulta.append(" and s.horas_hombre > 0");
                                                 consulta.append(" group by s.COD_LOTE_PRODUCCION     ");
                                             consulta.append(" ) as datosPesaje on datosPesaje.COD_LOTE_PRODUCCION=pp.COD_LOTE_PRODUCCION");       
                                            consulta.append(" left join");
                                            consulta.append(" (");
                                                consulta.append(" select max(s.FECHA_INICIO) as fechaInicio,s.COD_LOTE_PRODUCCION");
                                                consulta.append(" from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL s");
                                                         consulta.append(" inner join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_ACTIVIDAD_FORMULA =s.COD_ACTIVIDAD_PROGRAMA");
                                                               consulta.append(" and afm.COD_AREA_EMPRESA=96");
                                                consulta.append(" where afm.COD_ACTIVIDAD in (71, 48)");
                                                           if(codProgramaProdPeriodo.length()>0)
                                                               consulta.append(" and s.COD_PROGRAMA_PROD  in(").append(codProgramaProdPeriodo).append(")");
                                                     consulta.append(" and s.horas_hombre > 0");
                                                consulta.append(" group by s.COD_LOTE_PRODUCCION     ");
                                            consulta.append(" ) as datosProduccion on datosProduccion.COD_LOTE_PRODUCCION=pp.COD_LOTE_PRODUCCION");        
                                            consulta.append(" left join");
                                            consulta.append(" (");
                                                       consulta.append(" select sum(id.CANT_TOTAL_INGRESO) as cantidadTotalIngreso,id.COD_LOTE_PRODUCCION,id.COD_COMPPROD");
                                                               consulta.append(" from INGRESOS_ACOND ia ");
                                                       consulta.append(" inner join INGRESOS_DETALLEACOND id on id.COD_INGRESO_ACOND=ia.COD_INGRESO_ACOND");
                                                               consulta.append(" where  ia.COD_ESTADO_INGRESOACOND not in (1, 2)");
                                                       consulta.append(" and ia.COD_TIPOINGRESOACOND in (1)");
                                                   consulta.append(" group by id.COD_LOTE_PRODUCCION,id.COD_COMPPROD");
                                            consulta.append(" ) as detalleIngresoAcond on detalleIngresoAcond.COD_LOTE_PRODUCCION=pp.COD_LOTE_PRODUCCION");
                                                       consulta.append(" and detalleIngresoAcond.COD_COMPPROD=pp.COD_COMPPROD");
                                            consulta.append(" left join");
                                            consulta.append(" (");
                                                    consulta.append(" select sum((pp.cantidad_presentacion * idv.CANTIDAD) + idv.CANTIDAD_UNITARIA) as cantidadIngresoVentas,idv.COD_LOTE_PRODUCCION");
                                                            consulta.append(" ,min(iv.FECHA_INGRESOVENTAS) as fechaIngresoCuarentena");
                                                   consulta.append(" from INGRESOS_VENTAS iv");
                                                       consulta.append(" inner join INGRESOS_DETALLEVENTAS idv on iv.COD_INGRESOVENTAS=idv.COD_INGRESOVENTAS");
                                                               consulta.append(" and idv.COD_AREA_EMPRESA=iv.COD_AREA_EMPRESA");
                                                       consulta.append(" inner join PRESENTACIONES_PRODUCTO pp on pp.cod_presentacion=idv.COD_PRESENTACION");
                                                   consulta.append(" where iv.COD_AREA_EMPRESA = 1 ");
                                                         consulta.append(" and iv.COD_ALMACEN_VENTA in (54, 56)");
                                                         consulta.append(" and iv.COD_ESTADO_INGRESOVENTAS not in (2)");
                                                   consulta.append(" group by idv.COD_LOTE_PRODUCCION");
                                            consulta.append(" ) as detalleIngresoVenta on detalleIngresoVenta.COD_LOTE_PRODUCCION collate TRADITIONAL_SPANISH_CI_AI=pp.COD_LOTE_PRODUCCION");
                                            consulta.append(" left JOIN");
                                            consulta.append(" (");
                                                    consulta.append(" select sum(sd.CANT_TOTAL_SALIDADETALLEACOND) AS cantidaSalidaFrv,sd.COD_LOTE_PRODUCCION,sd.COD_COMPPROD");
                                                    consulta.append(" from SALIDAS_ACOND sa ");
                                                            consulta.append(" inner join SALIDAS_DETALLEACOND sd on sd.COD_SALIDA_ACOND=sa.COD_SALIDA_ACOND");
                                                    consulta.append(" where sa.COD_ESTADO_SALIDAACOND<>2 ");
                                                            consulta.append(" and sa.COD_ALMACENACOND_DESTINO in (2)");
                                                    consulta.append(" group by sd.COD_COMPPROD,sd.COD_LOTE_PRODUCCION    ");
                                            consulta.append(" ) as salidaAcondFrv on salidaAcondFrv.COD_LOTE_PRODUCCION=pp.COD_LOTE_PRODUCCION");
                                                       consulta.append(" and salidaAcondFrv.COD_COMPPROD=pp.COD_COMPPROD");
                                            consulta.append(" left JOIN");
                                            consulta.append(" (");
                                                    consulta.append(" select sum(sd.CANT_TOTAL_SALIDADETALLEACOND) AS cantidaSalidaReacond,sd.COD_LOTE_PRODUCCION,sd.COD_COMPPROD");
                                                    consulta.append(" from SALIDAS_ACOND sa ");
                                                            consulta.append(" inner join SALIDAS_DETALLEACOND sd on sd.COD_SALIDA_ACOND=sa.COD_SALIDA_ACOND");
                                                    consulta.append(" where sa.COD_ESTADO_SALIDAACOND<>2 ");
                                                            consulta.append(" and sa.COD_ALMACENACOND_DESTINO in (5)");
                                                    consulta.append(" group by sd.COD_COMPPROD,sd.COD_LOTE_PRODUCCION    ");
                                            consulta.append(" ) as salidaAcondReacond on salidaAcondReacond.COD_LOTE_PRODUCCION=pp.COD_LOTE_PRODUCCION");
                                                       consulta.append(" and salidaAcondReacond.COD_COMPPROD=pp.COD_COMPPROD");       
                                            consulta.append(" left JOIN");
                                            consulta.append(" (");
                                                    consulta.append(" select sum(sd.CANT_TOTAL_SALIDADETALLEACOND) AS cantidaSalidaEst,sd.COD_LOTE_PRODUCCION,sd.COD_COMPPROD");
                                                    consulta.append(" from SALIDAS_ACOND sa ");
                                                            consulta.append(" inner join SALIDAS_DETALLEACOND sd on sd.COD_SALIDA_ACOND=sa.COD_SALIDA_ACOND");
                                                    consulta.append(" where sa.COD_ESTADO_SALIDAACOND<>2 ");
                                                            consulta.append(" and sa.COD_ALMACENACOND_DESTINO in (6)");
                                                    consulta.append(" group by sd.COD_COMPPROD,sd.COD_LOTE_PRODUCCION    ");
                                            consulta.append(" ) as salidaAcondEst on salidaAcondEst.COD_LOTE_PRODUCCION=pp.COD_LOTE_PRODUCCION");
                                                       consulta.append(" and salidaAcondEst.COD_COMPPROD=pp.COD_COMPPROD      ");
                                            consulta.append(" left JOIN");
                                            consulta.append(" (");
                                                    consulta.append(" select sum(sd.CANT_TOTAL_SALIDADETALLEACOND) AS cantidaSalidaCc,sd.COD_LOTE_PRODUCCION,sd.COD_COMPPROD");
                                                    consulta.append(" from SALIDAS_ACOND sa ");
                                                            consulta.append(" inner join SALIDAS_DETALLEACOND sd on sd.COD_SALIDA_ACOND=sa.COD_SALIDA_ACOND");
                                                    consulta.append(" where sa.COD_ESTADO_SALIDAACOND<>2 ");
                                                            consulta.append(" and sa.COD_ALMACEN_VENTA in (29)");
                                                    consulta.append(" group by sd.COD_COMPPROD,sd.COD_LOTE_PRODUCCION    ");
                                            consulta.append(" ) as salidaAcondCc on salidaAcondCc.COD_LOTE_PRODUCCION=pp.COD_LOTE_PRODUCCION");
                                                       consulta.append(" and salidaAcondCc.COD_COMPPROD=pp.COD_COMPPROD   ");
                                            consulta.append(" left JOIN");
                                            consulta.append(" (");
                                                    consulta.append(" select sum(sd.CANT_TOTAL_SALIDADETALLEACOND) AS cantidaSalidaSaldo,sd.COD_LOTE_PRODUCCION,sd.COD_COMPPROD");
                                                    consulta.append(" from SALIDAS_ACOND sa ");
                                                            consulta.append(" inner join SALIDAS_DETALLEACOND sd on sd.COD_SALIDA_ACOND=sa.COD_SALIDA_ACOND");
                                                    consulta.append(" where sa.COD_ESTADO_SALIDAACOND<>2 ");
                                                            consulta.append(" and sa.COD_ALMACENACOND_DESTINO in (4)");
                                                    consulta.append(" group by sd.COD_COMPPROD,sd.COD_LOTE_PRODUCCION    ");
                                            consulta.append(" ) as salidaAcondSaldo on salidaAcondSaldo.COD_LOTE_PRODUCCION=pp.COD_LOTE_PRODUCCION");
                                                    consulta.append(" and salidaAcondSaldo.COD_COMPPROD=pp.COD_COMPPROD");
                                            consulta.append(" left join ");
                                            consulta.append(" (");
                                                    consulta.append(" select count(*) as cantIngresosCierreLote,id.COD_COMPPROD,id.COD_LOTE_PRODUCCION");
                                                    consulta.append(" from INGRESOS_ACOND ia ");
                                                            consulta.append(" inner join INGRESOS_DETALLEACOND id on id.COD_INGRESO_ACOND=ia.COD_INGRESO_ACOND");
                                                    consulta.append(" where ia.COD_TIPOINGRESOACOND=5");
                                                            consulta.append(" and ia.COD_ALMACENACOND in(1,3)");
                                                    consulta.append(" group by id.COD_COMPPROD,id.COD_LOTE_PRODUCCION    ");
                                            consulta.append(" ) as ingresosCierre on ingresosCierre.COD_COMPPROD=pp.COD_COMPPROD      ");
                                                            consulta.append(" and ingresosCierre.COD_LOTE_PRODUCCION=pp.COD_LOTE_PRODUCCION");
                                            consulta.append(" left join");
                                            consulta.append(" (");
                                                    consulta.append(" select count(*) as cantSalidaCierreLote,sd.COD_COMPPROD,sd.COD_LOTE_PRODUCCION");
                                                    consulta.append(" from SALIDAS_ACOND sa");
                                                            consulta.append(" inner join SALIDAS_DETALLEACOND sd on sd.COD_SALIDA_ACOND=sa.COD_SALIDA_ACOND");
                                                    consulta.append(" where sa.COD_TIPOSALIDAACOND=6");
                                                            consulta.append(" and sa.COD_ALMACENACOND in(1,3)");
                                                    consulta.append(" group by sd.COD_COMPPROD,sd.COD_LOTE_PRODUCCION    ");
                                            consulta.append(" ) as salidasCierre on salidasCierre.COD_COMPPROD=pp.COD_COMPPROD");      
                                                            consulta.append(" and salidasCierre.COD_LOTE_PRODUCCION=pp.COD_LOTE_PRODUCCION");
                                            consulta.append(" left join");
                                            consulta.append(" (");
                                                    consulta.append(" select MIN(sv.FECHA_SALIDAVENTA) as fechaLiberacion,(sum(sdv.CANTIDAD_TOTAL * pp.cantidad_presentacion) + sum(sdv.CANTIDAD_UNITARIATOTAL)) cantidadLiberacion,");
                                                            consulta.append(" sdv.COD_LOTE_PRODUCCION");
                                                    consulta.append(" from SALIDAS_VENTAS sv ");
                                                            consulta.append(" inner join SALIDAS_DETALLEVENTAS sdv on sv.COD_SALIDAVENTA=sdv.COD_SALIDAVENTAS");
                                                        consulta.append(" inner join PRESENTACIONES_PRODUCTO pp on pp.cod_presentacion=sdv.COD_PRESENTACION");
                                                    consulta.append(" where  sv.COD_TIPOSALIDAVENTAS = 4 ");
                                                            consulta.append(" and sv.COD_ALMACEN_VENTA in (54, 56, 57)");
                                                            consulta.append(" and sv.COD_ESTADO_SALIDAVENTA <> 2");
                                                            consulta.append(" and sv.COD_AREA_EMPRESA = 1 ");
                                                            consulta.append(" and len(sdv.COD_LOTE_PRODUCCION)>4");
                                                    consulta.append(" group by  sdv.COD_LOTE_PRODUCCION   ");
                                            consulta.append(" ) as detalleLiberacion on detalleLiberacion.COD_LOTE_PRODUCCION COLLATE TRADITIONAL_SPANISH_CI_AI=pp.COD_LOTE_PRODUCCION");
                                            consulta.append(" left join");
                                            consulta.append(" (");
                                                    consulta.append(" select id.COD_LOTE_PRODUCCION,count(*) as cantidadCierres");
                                                    consulta.append(" from INGRESOS_ACOND ia ");
                                                            consulta.append(" inner join INGRESOS_DETALLEACOND id on ia.COD_INGRESO_ACOND=id.COD_INGRESO_ACOND");
                                                    consulta.append(" where ia.COD_ESTADO_INGRESOACOND not in (1, 2)");
                                                             consulta.append(" and id.loteCerrado = 1");
                                                    consulta.append(" group by id.COD_LOTE_PRODUCCION   ");  
                                            consulta.append(" ) as cierreAcond on cierreAcond.COD_LOTE_PRODUCCION=pp.COD_LOTE_PRODUCCION ");
                                            consulta.append(" left JOIN");
                                            consulta.append(" (");
                                               consulta.append(" select count(*) as cantOos,ro.COD_LOTE,ro.COD_PROGRAMA_PROD");
                                               consulta.append(" from REGISTRO_OOS ro ");
                                               consulta.append(" group by ro.COD_LOTE,ro.COD_PROGRAMA_PROD");
                                            consulta.append(" ) as detalleOos on detalleOos.COD_LOTE=pp.COD_LOTE_PRODUCCION");
                                                       consulta.append(" and detalleOos.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD");
                                            consulta.append(" left join ");
                                            consulta.append(" (");
                                               consulta.append(" select count(*) as cantDesviacion,d.COD_LOTE_PRODUCCION,d.COD_PROGRAMA_PROD	");
                                               consulta.append(" from DESVIACION d ");
                                               consulta.append(" group by d.COD_LOTE_PRODUCCION,d.COD_PROGRAMA_PROD");
                                            consulta.append(" ) as detalleDesviacion on detalleDesviacion.COD_LOTE_PRODUCCION=pp.COD_LOTE_PRODUCCION");
                                                        consulta.append(" and detalleDesviacion.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD");
                                        consulta.append(" where pp.COD_ESTADO_PROGRAMA NOT IN (3,9,4)");
                                                if(reporteConFechas&&codEstadoProgramaProd==7)
                                                {
                                                    consulta.append(" and fechaAlmacen.fechaSalidaAlmacen BETWEEN '").append(fechaInicioReporte).append(" 00:00' and '").append(fechaFinalReporte).append(" 23:59'");
                                                }
                                                if(codEstadoProgramaProd>0)
                                                    consulta.append(" and pp.COD_ESTADO_PROGRAMA =").append(codEstadoProgramaProd);
                                                if(codProgramaProdPeriodo.length()>0)
                                                    consulta.append(" and ppp.cod_programa_prod in (").append(codProgramaProdPeriodo).append(")");
                                                if(codLoteProduccionFiltro.length()>0)
                                                    consulta.append(" and pp.COD_LOTE_PRODUCCION='").append(codLoteProduccionFiltro).append("'");
                                        consulta.append(" order by pp.COD_PROGRAMA_PROD,cpv.nombre_prod_semiterminado asc");
            System.out.println("consulta datos lote" + consulta.toString());
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            int cont = 1;
            StringBuilder consultaDev = new StringBuilder(" select d.COD_DEVOLUCION,d.NRO_DEVOLUCION");
                                        consultaDev.append(" from SALIDAS_ALMACEN s");
                                                consultaDev.append(" inner join devoluciones d on d.COD_SALIDA_ALMACEN = s.COD_SALIDA_ALMACEN");
                                        consultaDev.append(" where s.COD_PROD = ?");
                                                consultaDev.append(" and s.COD_LOTE_PRODUCCION = ?");
                                                consultaDev.append(" and s.COD_ESTADO_SALIDA_ALMACEN = 1 ");
                                                consultaDev.append(" and s.ESTADO_SISTEMA = 1");
                                                consultaDev.append(" and s.cod_almacen in (1, 2) ");
            PreparedStatement pstDev=con.prepareStatement(consultaDev.toString());
            ResultSet resDev;
            consultaDev=new StringBuilder("select sum(sd.CANT_TOTAL_SALIDADETALLEACOND),sum(detalleIngresoVentas.cantidadIngresoApt)");
                        consultaDev.append(" from SALIDAS_ACOND sa ");
                                consultaDev.append(" inner join SALIDAS_DETALLEACOND sd on sa.COD_SALIDA_ACOND=sd.COD_SALIDA_ACOND");
                            consultaDev.append(" inner JOIN");
                            consultaDev.append(" (");
                                consultaDev.append(" select iv.COD_SALIDA_ACOND,sum((idv.CANTIDAD * pp.cantidad_presentacion) +idv.CANTIDAD_UNITARIA) as cantidadIngresoApt");
                                consultaDev.append(" from INGRESOS_VENTAS iv ");
                                        consultaDev.append(" inner join INGRESOS_DETALLEVENTAS idv on idv.COD_INGRESOVENTAS=iv.COD_INGRESOVENTAS");
                                        consultaDev.append(" and iv.COD_AREA_EMPRESA=idv.COD_AREA_EMPRESA");
                                    consultaDev.append(" inner join PRESENTACIONES_PRODUCTO pp on pp.cod_presentacion=idv.COD_PRESENTACION    ");
                                consultaDev.append(" where  iv.COD_AREA_EMPRESA=1");
                                      consultaDev.append(" and iv.COD_ALMACEN_VENTA in (?)");
                                      consultaDev.append(" and iv.COD_ESTADO_INGRESOVENTAS<>2");
                                      consultaDev.append(" and idv.COD_LOTE_PRODUCCION=?");
                                consultaDev.append(" group by iv.COD_SALIDA_ACOND");
                            consultaDev.append(" ) as detalleIngresoVentas on detalleIngresoVentas.COD_SALIDA_ACOND=sa.COD_SALIDA_ACOND");
                        consultaDev.append(" where sa.COD_ESTADO_SALIDAACOND<>2  ");
                        consultaDev.append(" group by sd.COD_COMPPROD,sd.COD_LOTE_PRODUCCION,sd.COD_PRESENTACION  ");
            PreparedStatement pstCant=con.prepareStatement(consultaDev.toString());
            while (res.next()) 
            {
                String nombreProdSemiterminado = res.getString("nombre_prod_semiterminado");
                int codCompprod = res.getInt("cod_compprod");
                String codigoSemi = String.valueOf(codCompprod);
                String nombreProgramaProd = res.getString("NOMBRE_PROGRAMA_PROD");
                String codLoteProduccion = res.getString("COD_LOTE_PRODUCCION");
                String lote = codLoteProduccion;
                Date fechaInicio = res.getDate("fechaInicio");
                Date fechaVencimiento = res.getDate("fechaVencimiento");
                String nombreEstadoProgramaProd = res.getString("nombre_estado_programa_prod");
                double cantLoteProduccion = res.getDouble("cant_lote_produccion");
                double cantidadLote = cantLoteProduccion;
                double cantIngresoProduccion = res.getDouble("cantidadIngresoProduccion");
                double cantEnviadaAcond = res.getDouble("cantidadIngresoProduccion");
                double cantEnviadaApt = res.getDouble("cantidadEnviadaAPT");
                Date fechaInicialSalidas = res.getDate("fechaSalidaAlmacen");
                String nombreTipoProgramaProd = res.getString("nombre_tipo_programa_prod");
                int codTipoProgramaProd = res.getInt("cod_tipo_programa_prod");
                String nombreTipoEntregaAcond = res.getString("nombre_tipo_entrega_acond");

                int cantidadIngreso = res.getInt("cantidadTotalIngreso");

                int cantidadUnitariatotal =res.getInt("cantidadIngresoVentas");
                //muestras medicas
                int cantidadIngresoMM = 0;

                pstCant.setInt(1,57);
                pstCant.setString(2, codLoteProduccion);
                ResultSet resMM = pstCant.executeQuery();
                int cantidadMM = 0;
                if (resMM.next()) {
                    cantidadMM = resMM.getInt(1);
                    cantidadIngresoMM = resMM.getInt(2);
                }

                //finm muestras medicas


                //INSTITUCIONAL
                int cantidadIngresoIns = 0;

                pstCant.setInt(1,56);
                ResultSet resMI = pstCant.executeQuery();
                int cantidadIns = 0;
                if (resMI.next()) {
                    cantidadIns = resMI.getInt(1);
                    cantidadIngresoIns = resMI.getInt(2);
                }

                

                int cantidadSalidaFrv = res.getInt("cantidaSalidaFrv");
                int cantidadSalidaReacond =res.getInt("cantidaSalidaReacond");
                int cantidadSalidaEstabilidad =res.getInt("cantidaSalidaEst");
                int cantidadSalidaCc =res.getInt("cantidaSalidaCc");
                int cantSaldos =res.getInt("cantidaSalidaSaldo");

                double porcentaje1 = 0.0d;
                double porcentajeMM = 0.0d;
                double porcentaje2 = 0.0d;
                double porcentaje3 = 0.0d;
                double porcentaje4 = 0.0d;
                double porcentaje5 = 0.0d;
                double porcentaje6 = 0.0d;
                double porcentaje7 = 0.0d;
                double porcentajeSaldos = 0.0d;


                //FRV
                String sql;
                PreparedStatement stApt;
                ResultSet resApt;
                
                
                int cantidadCerradoIngreso = res.getInt("cantIngresosCierreLote");
                int  cantidadCerradoSalida= res.getInt("cantSalidaCierreLote");




                if (cantidadIngreso > 0) {
                    porcentaje1 = (double) cantidadUnitariatotal / (double) cantidadIngreso;
                    porcentajeMM = (double) cantidadIngresoMM / (double) cantidadIngreso;
                    porcentaje2 = (double) cantidadSalidaFrv / (double) cantidadIngreso;
                    porcentaje3 = (double) cantidadSalidaReacond / (double) cantidadIngreso;
                    porcentaje4 = (double) cantidadSalidaEstabilidad / (double) cantidadIngreso;
                    porcentaje5 = (double) cantidadSalidaCc / (double) cantidadIngreso;
                    porcentajeSaldos = (double) cantSaldos / (double) cantidadIngreso;

                    porcentaje1 = porcentaje1 * 100.0d;
                    porcentajeMM = porcentajeMM * 100.0d;
                    porcentaje2 = porcentaje2 * 100.0d;
                    porcentaje3 = porcentaje3 * 100.0d;
                    porcentaje4 = porcentaje4 * 100.0d;
                    porcentaje5 = porcentaje5 * 100.0d;
                    porcentajeSaldos = porcentajeSaldos * 100.0d;

                }
                double cantidadTotalRendimiento = 0d;
                if (cantidadLote > 0.0d) {
                    cantidadTotalRendimiento = cantidadUnitariatotal + cantidadMM + cantidadSalidaEstabilidad + cantidadSalidaCc + cantSaldos;
                    porcentaje6 = (double) cantidadTotalRendimiento / (double) cantidadLote;
                    porcentaje6 = porcentaje6 * 100.0d;

                }



                String loteCerrado = (cantidadCerradoIngreso > 0) ? "SI" : "NO";

                if (loteCerrado.equals("NO")) {
                    loteCerrado = (cantidadCerradoSalida > 0) ? "SI" : "NO";
                }

                if (loteCerrado.equals("NO")) {
                    if(res.getInt("cantidadCierres")>0)
                        loteCerrado = "SI";
                }



                if (cantidadLote > 0) {
                    porcentaje7 = ((double) cantidadIngreso / (double) cantidadLote) * 100.0d;
                }
                ;

                //FIN REPORTE ZEUS



                out.print("<tr>");
                out.print("<td class='bordeNegroTd' align='left'>" + cont + "</td>");
                out.print("<td class='bordeNegroTd' align='left'>" + nombreProdSemiterminado + "</td>");
                out.print("<td class='bordeNegroTd' align='left'>" + nombreTipoProgramaProd + "</td>");
                out.print("<td class='bordeNegroTd' align='left'>" + nombreProgramaProd + "</td>");
                out.print("<td class='bordeNegroTd' align='left'>" + codLoteProduccion + "</td>");
                out.print("<td class='bordeNegroTd' align='left'>" + (fechaInicio != null ? sdf.format(fechaInicio) : "") + "</td>");
                out.print("<td class='bordeNegroTd' align='left'>" + (fechaVencimiento != null ? sdf.format(fechaVencimiento) : "") + "</td>");
                out.print("<td class='bordeNegroTd' align='left'>" + nombreEstadoProgramaProd + "</td>");
                out.print("<td class='bordeNegroTd' align='left'>" + format.format(cantLoteProduccion) + "</td>");
                out.print("<td class='bordeNegroTd' align='left'>" + format.format(cantEnviadaAcond) + "</td>");
                out.print("<td class='bordeNegroTd' align='left'>" + format.format(cantLoteProduccion - cantEnviadaAcond) + "</td>");
                out.print("<td class='bordeNegroTd' align='left'>" + format.format(cantIngresoProduccion) + "</td>");
                out.print("<td class='bordeNegroTd'>");
                
                pstDev.setInt(1,res.getInt("COD_COMPPROD"));
                pstDev.setString(2,res.getString("COD_LOTE_PRODUCCION"));
                resDev=pstDev.executeQuery();
                String nroDevolucion = "";
                int codDevolucion = 0;
                while (resDev.next()) {
                    codDevolucion = resDev.getInt("cod_devolucion");
                    nroDevolucion = nroDevolucion + "<a href='#' onclick=\"openPopup('reporteDevolucionesAlmacen.jsf?codDevolucion=" + codDevolucion + "');return false\" class='outputText1'>" + resDev.getInt("nro_devolucion") + "</a> ";
                }
                //out.print("</table>");
                out.print(nroDevolucion);
                out.print("</td>");
                int codAlmacenVenta = 0;
                codAlmacenVenta = codTipoProgramaProd == 1 ? 54 : codAlmacenVenta;
                codAlmacenVenta = codTipoProgramaProd == 2 ? 56 : codAlmacenVenta;
                codAlmacenVenta = codTipoProgramaProd == 3 ? 57 : codAlmacenVenta;
                
                //out.print("</table>");

                //out.print(nroIngresoAPT);
                //out.print("</td>");

                double rendimientoProduccion = (cantEnviadaAcond / cantLoteProduccion) * 100;
                String fechaPreparacion=res.getTimestamp("fechaProduccion")!=null?sdf.format(res.getTimestamp("fechaProduccion")):"";

                out.print("<td class='bordeNegroTd' align='left'>"+fechaPreparacion+"</td>");
                out.print("<td class='bordeNegroTd' align='left'>" + cantidadSalidaFrv + "</td>");
                out.print("<td class='bordeNegroTd' align='left'>" + nf.format(rendimientoProduccion) + "%</td>");
                out.println("<td>"+(res.getTimestamp("fechaIngresoCuarentena")!=null?sdf.format(res.getTimestamp("fechaIngresoCuarentena")):"")+"</td>");
                out.print("<td class='bordeNegroTd' align='left'>" + cantidadUnitariatotal + "</td>");
                out.print("<td class='bordeNegroTd' align='left'>" + cantidadIngresoMM + "</td>");
                out.print("<td class='bordeNegroTd' align='left'>" + cantidadIngresoIns + "</td>");
                out.print("<td class='bordeNegroTd' align='left'>" + cantidadSalidaReacond + "</td>");
                out.print("<td class='bordeNegroTd' align='left'>" + cantidadSalidaEstabilidad + "</td>");
                out.print("<td class='bordeNegroTd' align='left'>" + cantidadSalidaCc + "</td>");
                out.print("<td class='bordeNegroTd' align='left'>" + cantSaldos + "</td>");
                out.print("<td class='bordeNegroTd' align='left'>" + nf.format(porcentaje6) + "%</td>");
                out.print("<td class='bordeNegroTd' align='left'>" + loteCerrado + "</td>");

                //fecha liberacion
                double cantidadLiberacion = res.getDouble("cantidadLiberacion");
                String fechaLiberacion = res.getTimestamp("fechaLiberacion")!=null?sdf.format(res.getTimestamp("fechaLiberacion")):"";
                out.print("<td class='bordeNegroTd' align='left'>" + fechaLiberacion + "</td>");
                out.print("<td class='bordeNegroTd' align='left'>" + nf.format(cantidadLiberacion) + "</td>");
                out.println("<td>"+res.getString("estadoCertificado")+"</td>");
                out.println("<td>"+(res.getTimestamp("FECHA_EMISION")!=null?sdf.format(res.getTimestamp("FECHA_EMISION")):"")+"</td>");
                out.println("<td>"+(res.getInt("cantOos")>0?"SI":"NO")+"</td>");
                out.println("<td>"+(res.getInt("cantDesviacion")>0?"SI":"NO")+"</td>");
                out.print("</tr>");
                cont++;
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