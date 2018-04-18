<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@page import="com.cofar.util.*" %>
<%@page import="com.cofar.web.*"%>
<%@page import="java.sql.*"%>
<%@page import="java.text.DecimalFormat"%> 
<%@page import="java.text.NumberFormat"%> 
<%@page import="java.util.Locale"%> 
<%@page import="org.joda.time.DateTime"%> 
<%@page import="java.util.*"%> 
<%@page import="java.text.*"%> 
<%@page import="java.text.DecimalFormat"%> 
<%@page import="java.text.NumberFormat"%> 
<%@page import="java.util.Locale"%> 
<link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
<html>
    <head>
        <meta charset="utf-8" /> 
        <style type="text/css">
            .totalSalida
            {
                background-color: #fcf8b8 !important;
                font-size: 12px;
                border:2px solid #fec778;
                padding: 0.6em;
            }
            .saldoActual
            {
                background-color: #c0f4bf !important;
                font-size: 12px;
                border:2px solid #6e9c6d;
                padding: 0.6em;
            }
            .saldoAnterior
            {
                background-color: #fdcfa1 !important;
                font-size: 12px;
                border:2px solid #f5a565;
                padding: 0.6em;
            }
            
            .subTotalProducto
            {
                font-weight: bold;
                background-color:#eeeeee;
            }
            .cabeceraReporte
            {
               background-color: rgb(157, 90, 158) !important;
               color: white;
               font-weight: bold;
               font-size: 22px;
            }
            .celdaAlmacenDestino
            {
                background-color: rgb(157, 90, 158) !important;
                color: white;
                font-weight: bold;
            }
            .tablaReporte
            {
                border:1px solid #784879;
            }
            .tablaReporte thead tr td
            {
                background-color: rgb(157, 90, 158) !important;
                color: white;
                font-weight: bold;
                border-right:1px solid #bbbbbb;
                
                border-bottom: none;
                font-size: 12px;
            }
            .borderTop
            {
                border-top:1px solid #bbbbbb;
            }
            .borderBottom
            {
                border-bottom:1px solid #784879 !important;
            }
            .cambioPresentacion td
            {
                background-color:#ead9eb;
                color: black;
                font-weight: bold;
                text-align: center;
                border-top:1px solid #784879 !important;
                border-right:1px solid #784879 !important;
                
            }
            .textoCofar {
                font-weight: bold;
                font-size: 24px;
                font-style: italic;
                position: relative;
                top:5px;
            }
        </style>
    </head>
    <body class="tdCenter">
        <center>
                <%
                    Connection con=null;
                    SimpleDateFormat sdfFecha=new SimpleDateFormat("dd/MM/yyyy");
                    SimpleDateFormat sdfHora=new SimpleDateFormat("HH:mm");
                    String codAlmacenVenta="58,28,27,32,29";
                    java.util.Date fechaInicio;
                    java.util.Date fechaFinal;
                    String[] codPresentacion=request.getParameterValues("codPresentacion");
                    String codigosPresentacion="";
                    for(String codPre:codPresentacion)
                    {
                        codigosPresentacion+=(codigosPresentacion.length()>0?",":"")+codPre;
                    }
                    NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
                    DecimalFormat format = (DecimalFormat)nf;
                    format.applyPattern("#,##0.0");
                    int cantidadPresentacion=0;
                    try
                    {
                        SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy");
                        fechaInicio=sdf.parse(request.getParameter("fechaInicio"));
                        fechaFinal=sdf.parse(request.getParameter("fechaFinal"));
                        con=Util.openConnection(con);
                        int cantidadMesesTexto=(fechaFinal.getYear()*12+fechaFinal.getMonth())-(fechaInicio.getYear()*12+fechaInicio.getMonth());
                        
                        int codVersion=0;
                        StringBuilder consulta=new StringBuilder("select pp.cantidad_presentacion,pp.NOMBRE_PRODUCTO_PRESENTACION,cpv.REG_SANITARIO,cpv.COD_VERSION");
                                                consulta.append(" from PRESENTACIONES_PRODUCTO pp");
                                                consulta.append(" inner join ");
                                                consulta.append(" (");
                                                    consulta.append(" select cp.COD_PRESENTACION,MAX(fmes.COD_VERSION) AS codVersion");
                                                    consulta.append(" from COMPONENTES_PRESPROD_VERSION cp ");
                                                            consulta.append(" inner join FORMULA_MAESTRA_ES_VERSION fmes on fmes.COD_FORMULA_MAESTRA_ES_VERSION=cp.COD_FORMULA_MAESTRA_ES_VERSION");
                                                            consulta.append(" inner join COMPONENTES_PROD_VERSION cpv on cpv.COD_VERSION=fmes.COD_VERSION");
                                                    consulta.append(" where cp.COD_PRESENTACION in(").append(codigosPresentacion).append(")");
                                                            consulta.append(" and cpv.COD_ESTADO_VERSION=2");
                                                    consulta.append(" group by cp.COD_PRESENTACION");
                                                consulta.append(" )as datosVersion on pp.cod_presentacion=datosVersion.COD_PRESENTACION");
                                                consulta.append(" inner join COMPONENTES_PROD_VERSION cpv on cpv.COD_VERSION=datosVersion.codVersion");
                                                
                        System.out.println("consulta cargar datos cabecera "+consulta.toString());
                        Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                        ResultSet res=st.executeQuery(consulta.toString());
                        out.println("<table cellpading=0 class='tablaReporte' style='width:95%' cellspacing='0'>");
                            out.println("<thead>");
                                out.println("<tr><td colspan='3' class='cabeceraReporte' ><div style='width:20%;float:left;text-align:center'><img style='width:30px' src='../../img/icon1.gif'/><span class='textoCofar'>COFAR</span></div><div style='width:80%;text-align:center'><span style='top:6px;position:relative;font-size:22px'>REPORTE CONSOLIDADO "+(cantidadMesesTexto>4?"ANUAL":"TRIMESTRAL")+"</span></div></td></tr>");
                            out.println("</thead>");
                        String nombrePresentacion="";
                        String codigosVersion="";
                        String registroSanitario="";
                        while(res.next())
                        {
                            nombrePresentacion+=(nombrePresentacion.length()>0?"<br>":"")+res.getString("NOMBRE_PRODUCTO_PRESENTACION");
                            codigosVersion+=(codigosVersion.length()>0?",":"")+res.getInt("COD_VERSION");
                        }
                        consulta=new StringBuilder("select DISTINCT cpv.REG_SANITARIO");
                                    consulta.append(" from COMPONENTES_PROD_VERSION cpv"); 
                                    consulta.append(" where cpv.COD_VERSION in (").append(codigosVersion).append(")");
                                    consulta.append(" order by cpv.REG_SANITARIO");
                        res=st.executeQuery(consulta.toString());
                        while(res.next())
                        {
                            registroSanitario+=(registroSanitario.length()>0?"<br>":"")+res.getString("REG_SANITARIO");
                        }
                        
                        consulta=new StringBuilder("select DISTINCT p.nombre_prod");
                                    consulta.append(" from COMPONENTES_PROD_VERSION cpv"); 
                                            consulta.append(" inner join PRODUCTOS p on p.cod_prod=cpv.COD_PROD");
                                    consulta.append(" where cpv.COD_VERSION in (").append(codigosVersion).append(")");
                                    consulta.append(" order by p.nombre_prod");
                        res=st.executeQuery(consulta.toString());
                        String nombreProd="";
                        while(res.next())
                        {
                            nombreProd+=(nombreProd.length()>0?"<br>":"")+res.getString("nombre_prod");
                        }
                        
                        consulta=new StringBuilder("select DISTINCT ff.nombre_forma");
                                    consulta.append(" from COMPONENTES_PROD_VERSION cpv ");
                                            consulta.append(" inner join FORMAS_FARMACEUTICAS ff on ff.cod_forma=cpv.COD_FORMA");
                                    consulta.append(" where cpv.COD_VERSION in (").append(codigosVersion).append(")");
                                    consulta.append(" order by ff.nombre_forma");
                        res=st.executeQuery(consulta.toString());
                        String nombreForma="";
                        while(res.next())
                        {
                            nombreForma+=(nombreForma.length()>0?"<br>":"")+res.getString("nombre_forma");
                        }
                        out.println("<tr>");
                            out.println("<td class='outputTextBold'>Nombre del Producto</td>");
                            out.println("<td class='outputTextBold'>:</td>");
                            out.println("<td class='outputText2'>"+nombreProd+"</td>");
                        out.println("</tr>");
                        out.println("<tr>");
                            out.println("<td class='outputTextBold'>Presentación</td>");
                            out.println("<td class='outputTextBold'>:</td>");
                            out.println("<td class='outputText2'>"+nombrePresentacion+"</td>");
                        out.println("</tr>");
                        out.println("<tr>");
                            out.println("<td class='outputTextBold'>Forma Farmaceútica</td>");
                            out.println("<td class='outputTextBold'>:</td>");
                            out.println("<td class='outputText2'>"+nombreForma+"</td>");
                        out.println("</tr>");
                        out.println("<tr>");
                            out.println("<td class='outputTextBold'>Registro Sanitario</td>");
                            out.println("<td class='outputTextBold'>:</td>");
                            out.println("<td class='outputText2'>"+registroSanitario+"</td>");
                        out.println("</tr>");
                        consulta=new StringBuilder("select distinct m.NOMBRE_CCC,cpc.CANTIDAD,um.ABREVIATURA,cpc.UNIDAD_PRODUCTO");
                                        consulta.append(" from COMPONENTES_PROD_CONCENTRACION cpc");
                                                consulta.append(" inner join MATERIALES m on m.COD_MATERIAL=cpc.COD_MATERIAL");
                                                consulta.append(" left outer join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=cpc.COD_UNIDAD_MEDIDA");
                                                
                                        consulta.append(" where cpc.COD_VERSION in (").append(codigosVersion).append(")");
                                                consulta.append(" and isnull(cpc.EXCIPIENTE,0)=0");
                                        consulta.append(" order by m.NOMBRE_CCC");
                        System.out.println("consulta concentracion "+consulta.toString());
                        res=st.executeQuery(consulta.toString());
                        StringBuilder denominacion=new StringBuilder("");
                        StringBuilder concentracion=new StringBuilder("");
                        String unidadDeConcentracion="";
                        while(res.next())
                        {
                            unidadDeConcentracion=res.getString("UNIDAD_PRODUCTO");
                            if(denominacion.length()>0)denominacion.append(",");
                            if(concentracion.length()>0)concentracion.append(",");
                            denominacion.append(res.getString("NOMBRE_CCC"));
                            concentracion.append(res.getString("NOMBRE_CCC")+" "+res.getDouble("CANTIDAD")+" "+res.getString("ABREVIATURA"));
                        }
                                out.println("<tr>");
                                    out.println("<td class='outputTextBold'>Denominación Común Internacional D.C.I.</td>");
                                    out.println("<td class='outputTextBold'>:</td>");
                                    out.println("<td class='outputText2' >"+denominacion.toString()+"</td>");
                                out.println("</tr>");
                                out.println("<tr>");
                                    out.println("<td class='outputTextBold'>Concentración</td>");
                                    out.println("<td class='outputTextBold'>:</td>");
                                    out.println("<td class='outputText2' >"+concentracion.toString()+"/"+unidadDeConcentracion+"</td>");
                                out.println("</tr>");
                                out.println("<tr>");
                                    out.println("<td class='outputTextBold'>Laboratorio Producto</td>");
                                    out.println("<td class='outputTextBold'>:</td>");
                                    out.println("<td class='outputText2'>Laboratorios COFAR S.A.</td>");
                                out.println("</tr>");
                                out.println("<tr>");
                                    out.println("<td class='outputTextBold'>Origen</td>");
                                    out.println("<td class='outputTextBold'>:</td>");
                                    out.println("<td class='outputText2'>Bolivia</td>");
                                out.println("</tr>");
                                out.println("<tr>");
                                    out.println("<td class='outputTextBold'>Fecha Inicio</td>");
                                    out.println("<td class='outputTextBold'>:</td>");
                                    out.println("<td class='outputText2'>"+sdf.format(fechaInicio)+"</td>");
                                out.println("</tr>");
                                out.println("<tr>");
                                    out.println("<td class='outputTextBold'>Fecha Final</td>");
                                    out.println("<td class='outputTextBold'>:</td>");
                                    out.println("<td class='outputText2'>"+sdf.format(fechaFinal)+"</td>");
                                out.println("</tr>");
                        out.println("</table>");
                        sdf=new SimpleDateFormat("yyyy/MM/dd");
                        consulta=new StringBuilder("select av.COD_ALMACEN_VENTA,av.COD_TIPOALMACENVENTA,av.NOMBRE_ALMACEN_VENTA,av.COD_AREA_EMPRESA,av.COD_ESTADO_REGISTRO,av.OBS_ALMACEN_VENTA,");
                                                consulta.append(" cantidadCajasIngresoAnterior,cantidadIngresoUnidadesAnterior,cantidadSalidaAnterior,cantidadSalidaAnteriorUnidades,");
                                                consulta.append(" cantidadCajasIngresoTrimestre,cantidadIngresoUnidadesTrimestre,cantidadSalidaTrimestre,cantidadSalidaUnidadesTrimestre");
                                                consulta.append(" ,pp.cod_presentacion,pp.NOMBRE_PRODUCTO_PRESENTACION,pp.cantidad_presentacion");
                                 consulta.append(" from ALMACENES_VENTAS av");
                                        consulta.append(" inner join PRESENTACIONES_PRODUCTO pp  on 1=1 and pp.cod_presentacion in (").append(codigosPresentacion).append(")");
                                         consulta.append(" left join");
                                     consulta.append(" (");
                                         consulta.append(" select iv.COD_ALMACEN_VENTA,idv.COD_PRESENTACION,ISNULL(sum(idv.cantidad), 0) as cantidadCajasIngresoAnterior,");
                                               consulta.append(" ISNULL(sum(idv.CANTIDAD_UNITARIA), 0) as cantidadIngresoUnidadesAnterior");
                                         consulta.append(" from INGRESOS_VENTAS iv");
                                                 consulta.append(" inner join INGRESOS_DETALLEVENTAS idv on idv.COD_INGRESOVENTAS=iv.COD_INGRESOVENTAS");
                                                         consulta.append(" and iv.COD_AREA_EMPRESA=idv.COD_AREA_EMPRESA");
                                         consulta.append(" where idv.COD_PRESENTACION in (").append(codigosPresentacion).append(")");
                                                 consulta.append(" and idv.COD_AREA_EMPRESA=1");
                                             consulta.append(" and iv.COD_ALMACEN_VENTA in (").append(codAlmacenVenta).append(")");
                                             consulta.append(" and iv.COD_ESTADO_INGRESOVENTAS<>2");
                                             consulta.append(" and iv.FECHA_INGRESOVENTAS<'").append(sdf.format(fechaInicio)).append(" 00:00'");
                                         consulta.append(" group by iv.COD_ALMACEN_VENTA,idv.COD_PRESENTACION");
                                     consulta.append(" ) as ingresoAnterior on ingresoAnterior.COD_ALMACEN_VENTA=av.COD_ALMACEN_VENTA");
                                            consulta.append(" and ingresoAnterior.COD_PRESENTACION=pp.COD_PRESENTACION");
                                     consulta.append(" left join");
                                     consulta.append(" (");
                                         consulta.append(" select sv.COD_ALMACEN_VENTA,sdv.COD_PRESENTACION,ISNULL(sum(sdv.cantidad_total), 0) as cantidadSalidaAnterior,");
                                               consulta.append(" ISNULL(sum(sdv.CANTIDAD_UNITARIATOTAL), 0) as");
                                               consulta.append(" cantidadSalidaAnteriorUnidades");
                                         consulta.append(" from SALIDAS_VENTAS sv");
                                                 consulta.append(" inner join SALIDAS_DETALLEVENTAS sdv on sv.COD_AREA_EMPRESA=sdv.COD_AREA_EMPRESA");
                                                         consulta.append(" and sv.COD_SALIDAVENTA=sdv.COD_SALIDAVENTAS");
                                         consulta.append(" where sv.COD_AREA_EMPRESA=1");
                                                 consulta.append(" and sv.COD_ESTADO_SALIDAVENTA<>2");
                                             consulta.append(" and sdv.COD_PRESENTACION in (").append(codigosPresentacion).append(")");
                                             consulta.append(" and sv.FECHA_SALIDAVENTA<'").append(sdf.format(fechaInicio)).append(" 00:00:00'");
                                             consulta.append(" and sv.COD_ALMACEN_VENTA in (").append(codAlmacenVenta).append(")");
                                         consulta.append(" group by sv.COD_ALMACEN_VENTA,sdv.COD_PRESENTACION");
                                        consulta.append(" ");
                                      consulta.append(" ) as salidaAnterior on salidaAnterior.COD_ALMACEN_VENTA=av.COD_ALMACEN_VENTA");
                                            consulta.append(" and salidaAnterior.COD_PRESENTACION=pp.COD_PRESENTACION");
                                      consulta.append(" left join");
                                     consulta.append(" (");
                                         consulta.append(" select iv.COD_ALMACEN_VENTA,idv.COD_PRESENTACION,ISNULL(sum(idv.cantidad), 0) as cantidadCajasIngresoTrimestre,");
                                               consulta.append(" ISNULL(sum(idv.CANTIDAD_UNITARIA), 0) as cantidadIngresoUnidadesTrimestre");
                                         consulta.append(" from INGRESOS_VENTAS iv");
                                                 consulta.append(" inner join INGRESOS_DETALLEVENTAS idv on idv.COD_INGRESOVENTAS=iv.COD_INGRESOVENTAS");
                                                         consulta.append(" and iv.COD_AREA_EMPRESA=idv.COD_AREA_EMPRESA");
                                         consulta.append(" where idv.COD_PRESENTACION in (").append(codigosPresentacion).append(")");
                                                 consulta.append(" and idv.COD_AREA_EMPRESA=1");
                                             consulta.append(" and iv.COD_ALMACEN_VENTA in (").append(codAlmacenVenta).append(")");
                                             consulta.append(" and iv.COD_ESTADO_INGRESOVENTAS<>2");
                                             consulta.append(" and iv.FECHA_INGRESOVENTAS  between '").append(sdf.format(fechaInicio)).append(" 00:00:00' and '").append(sdf.format(fechaFinal)).append(" 23:59:59'");
                                         consulta.append(" group by iv.COD_ALMACEN_VENTA,idv.COD_PRESENTACION");
                                        consulta.append(" ) as ingresoTrimestre on ingresoTrimestre.COD_ALMACEN_VENTA=av.COD_ALMACEN_VENTA");
                                                consulta.append(" and ingresoTrimestre.COD_PRESENTACION=pp.COD_PRESENTACION");
                                        consulta.append(" left join");
                                        consulta.append(" (");
                                            consulta.append(" select sv.COD_ALMACEN_VENTA,sdv.COD_PRESENTACION,ISNULL(sum(sdv.cantidad_total), 0) as cantidadSalidaTrimestre,");
                                                  consulta.append(" ISNULL(sum(sdv.CANTIDAD_UNITARIATOTAL), 0) as cantidadSalidaUnidadesTrimestre");
                                            consulta.append(" from SALIDAS_VENTAS sv");
                                                    consulta.append(" inner join SALIDAS_DETALLEVENTAS sdv on sv.COD_AREA_EMPRESA=sdv.COD_AREA_EMPRESA");
                                                            consulta.append(" and sv.COD_SALIDAVENTA=sdv.COD_SALIDAVENTAS");
                                            consulta.append(" where sv.COD_AREA_EMPRESA=1");
                                                    consulta.append(" and sv.COD_ESTADO_SALIDAVENTA<>2");
                                                consulta.append(" and sdv.COD_PRESENTACION in (").append(codigosPresentacion).append(")");
                                                consulta.append(" and sv.FECHA_SALIDAVENTA between  '").append(sdf.format(fechaInicio)).append(" 00:00:00' and '").append(sdf.format(fechaFinal)).append(" 23:59:59'");
                                                consulta.append(" and sv.COD_ALMACEN_VENTA in (").append(codAlmacenVenta).append(")");
                                            consulta.append(" group by sv.COD_ALMACEN_VENTA,sdv.COD_PRESENTACION");
                                         consulta.append(" ) as salidaTrimestre on salidaTrimestre.COD_ALMACEN_VENTA=av.COD_ALMACEN_VENTA");
                                                consulta.append(" and salidaTrimestre.COD_PRESENTACION=pp.COD_PRESENTACION");
                                    consulta.append(" where av.COD_ALMACEN_VENTA in (").append(codAlmacenVenta).append(")");
                                    consulta.append(" order by pp.NOMBRE_PRODUCTO_PRESENTACION,pp.cod_presentacion,av.NOMBRE_ALMACEN_VENTA");
                        System.out.println("consulta datos informacion "+consulta.toString());
                        res=st.executeQuery(consulta.toString());
                        int saldoAnteriorCajas=0;
                        int saldoAnteriorUnitario=0;
                        int cantidadIngresoCajas=0;
                        int cantidadIngresoUnitario=0;
                        int cantidadSalidaCajas=0;
                        int cantidadSalidaUnitario=0;
                        int saldoActualCajas=0;
                        int saldoActualUnitario=0;
                        int saldoAnteriorUnitarioTotal=0;
                        int cantidadIngresoUnitarioTotal=0;
                        int cantidadSalidaUnitarioTotal=0;
                        int saldoActualUnitarioTotal=0;
                        
                        out.println("<br/><table cellpadding='0' cellspacing='0' class='tablaReporte' style='width:95%'>");
                            out.println("<thead><tr><td rowspan='2' class='tdCenter'>Almacen</td><td colspan='2' class='tdCenter'>Saldo Anterior</td><td colspan='2' class='tdCenter'>Ingresos</td>");
                            out.println("<td colspan='2' class='tdCenter'>Egresos</td><td colspan='2' class='tdCenter'>Saldo Actual</td></tr>");
                            out.println("<tr>");
                                out.println("<td class='tdCenter borderTop'>Cajas</td><td class='tdCenter borderTop'>Unidades</td>");
                                out.println("<td class='tdCenter borderTop'>Cajas</td><td class='tdCenter borderTop'>Unidades</td>");
                                out.println("<td class='tdCenter borderTop'>Cajas</td><td class='tdCenter borderTop'>Unidades</td>");
                                out.println("<td class='tdCenter borderTop'>Cajas</td><td class='tdCenter borderTop'>Unidades</td>");
                            out.println("</tr>");
                            out.println("</thead>");
                            out.println("<tbody>");
                        int codPresentacionCabecera=0;
                        while(res.next())
                        {
                            if(codPresentacionCabecera!=res.getInt("cod_presentacion"))
                            {
                                if(codPresentacionCabecera>0)
                                {
                                    out.println("<tr class='cambioPresentacion'>"+
                                                        "<td class='outputTextBold'>Sub Total</td><td class='tdRight'>"+format.format(saldoAnteriorCajas)+"</td>" +
                                                        "<td  class='tdRight'>"+format.format(saldoAnteriorUnitario)+"</td>" +
                                                        "<td class='tdRight'>"+format.format(cantidadIngresoCajas)+"</td>" +
                                                        "<td  class='tdRight'>"+format.format(cantidadIngresoUnitario)+"</td>" +
                                                        "<td class='tdRight'>"+format.format(cantidadSalidaCajas)+"</td>" +
                                                        "<td class='tdRight'>"+format.format(cantidadSalidaUnitario)+"</td>" +
                                                        "<td class='tdRight'>"+format.format(saldoActualCajas)+"</td>" +
                                                        "<td class='tdRight'>"+format.format(saldoActualUnitario)+"</td></tr>"+
                                                "<tr>");
                                }
                                saldoAnteriorCajas=0;
                                saldoAnteriorUnitario=0;
                                cantidadIngresoCajas=0;
                                cantidadIngresoUnitario=0;
                                cantidadSalidaCajas=0;
                                cantidadSalidaUnitario=0;
                                saldoActualCajas=0;
                                saldoActualUnitario=0;
                                out.println("<tr class='cambioPresentacion'><td colspan='9' class='borderBottom' >"+res.getString("NOMBRE_PRODUCTO_PRESENTACION")+"</td></tr>");
                                codPresentacionCabecera=res.getInt("cod_presentacion");
                            }
                            cantidadPresentacion=res.getInt("cantidad_presentacion");
                            out.print("<tr>");
                            
                            int cantidadTotalUnitariaAnterior=((res.getInt("cantidadCajasIngresoAnterior") -res.getInt("cantidadSalidaAnterior"))*cantidadPresentacion)+
                                                                (res.getInt("cantidadIngresoUnidadesAnterior")-res.getInt("cantidadSalidaAnteriorUnidades"));
                            int cantidadTotalUnitariaActual=((res.getInt("cantidadCajasIngresoTrimestre")-res.getInt("cantidadSalidaTrimestre"))*cantidadPresentacion)+
                                                            (res.getInt("cantidadIngresoUnidadesTrimestre")-res.getInt("cantidadSalidaUnidadesTrimestre"));
                            cantidadTotalUnitariaActual+=cantidadTotalUnitariaAnterior;
                            int cantidadCajasAnterior=(cantidadTotalUnitariaAnterior/cantidadPresentacion);
                            int cantidadUnitariaCajasAnterior=(cantidadTotalUnitariaAnterior%cantidadPresentacion);
                            int cantidadCajasActual=(cantidadTotalUnitariaActual/cantidadPresentacion);
                            int cantidadUnitariaCajasActual=(cantidadTotalUnitariaActual%cantidadPresentacion);
                            out.print("<td >"+res.getString("NOMBRE_ALMACEN_VENTA")+"</td>" +
                                      "<td class='tdRight'>"+format.format(cantidadCajasAnterior)+"</td>" +
                                      "<td class='tdRight'>"+format.format(cantidadUnitariaCajasAnterior)+"</td>");
                            out.print("<td class='tdRight'>"+format.format(res.getInt("cantidadCajasIngresoTrimestre"))+"</td>" +
                                      "<td class='tdRight'>"+format.format(res.getInt("cantidadIngresoUnidadesTrimestre"))+"</td>" +
                                      "<td class='tdRight'>"+format.format(res.getInt("cantidadSalidaTrimestre"))+"</td>" +
                                      "<td class='tdRight'>"+format.format(res.getInt("cantidadSalidaUnidadesTrimestre"))+"</td>");
                            out.print("<td class='tdRight'>"+format.format(cantidadCajasActual)+"</td>"+
                                      "<td class='tdRight'>"+format.format(cantidadUnitariaCajasActual)+"</td>");

                            saldoAnteriorCajas += cantidadCajasAnterior;
                            saldoAnteriorUnitario+=cantidadUnitariaCajasAnterior;
                            saldoAnteriorUnitarioTotal+=(cantidadCajasAnterior*cantidadPresentacion)+cantidadUnitariaCajasAnterior;
                            cantidadIngresoCajas+=res.getInt("cantidadCajasIngresoTrimestre");
                            cantidadIngresoUnitario+=res.getInt("cantidadIngresoUnidadesTrimestre");
                            cantidadIngresoUnitarioTotal+=(res.getInt("cantidadCajasIngresoTrimestre")*cantidadPresentacion)+res.getInt("cantidadIngresoUnidadesTrimestre");
                            cantidadSalidaCajas+=res.getInt("cantidadSalidaTrimestre");
                            cantidadSalidaUnitario+=res.getInt("cantidadSalidaUnidadesTrimestre");
                            cantidadSalidaUnitarioTotal+=(res.getInt("cantidadSalidaTrimestre")*cantidadPresentacion)+res.getInt("cantidadSalidaUnidadesTrimestre");
                            saldoActualCajas+=cantidadCajasActual;
                            saldoActualUnitario+=cantidadUnitariaCajasActual;
                            saldoActualUnitarioTotal+=(cantidadCajasActual*cantidadPresentacion)+cantidadUnitariaCajasActual;
                            out.print("</tr>");
                        }
                        out.print("<tr class='cambioPresentacion'><td class='outputTextBold'>Sub Total</td><td class='tdRight'>"+format.format(saldoAnteriorCajas)+"</td>" +
                                    "<td  class='tdRight'>"+format.format(saldoAnteriorUnitario)+"</td>" +
                                    "<td class='tdRight'>"+format.format(cantidadIngresoCajas)+"</td>" +
                                    "<td  class='tdRight'>"+format.format(cantidadIngresoUnitario)+"</td>" +
                                    "<td class='tdRight'>"+format.format(cantidadSalidaCajas)+"</td>" +
                                    "<td class='tdRight'>"+format.format(cantidadSalidaUnitario)+"</td>" +
                                    "<td class='tdRight'>"+format.format(saldoActualCajas)+"</td>" +
                                    "<td class='tdRight'>"+format.format(saldoActualUnitario)+"</td></tr>"+
                                    "<tr class='cambioPresentacion'>"+
                                        "<td class='outputTextBold' style='padding:0px'>Total En Unidades</td>"+
                                        "<td colspan='2' style='padding:0px' class='tdRight' ><div class='saldoActual outputTextBold'>"+format.format(saldoAnteriorUnitarioTotal)+"</div></td>"+
                                        "<td colspan='2' class='tdRight outputTextBold' >"+format.format(cantidadIngresoUnitarioTotal)+"</td>"+
                                        "<td colspan='2' style='padding:0px' class='tdRight' ><div class='totalSalida outputTextBold'>"+format.format(cantidadSalidaUnitarioTotal)+"</div></td>"+
                                        "<td colspan='2' style='padding:0px' class='tdRight' ><div class='saldoActual outputTextBold'>"+format.format(saldoActualUnitarioTotal)+"</div></td>"+
                                    "</tr>");
                        out.print("</table>");
                        consulta=new StringBuilder("select sv.FECHA_SALIDAVENTA,sum(sdv.CANTIDAD_UNITARIATOTAL + sdv.CANTIDAD_TOTAL *pp.cantidad_presentacion) as cantidadUnitariaTotal");
                                             consulta.append(" from SALIDAS_VENTAS sv");
                                                    consulta.append(" inner join SALIDAS_DETALLEVENTAS sdv on sdv.COD_SALIDAVENTAS =sv.COD_SALIDAVENTA");
                                                          consulta.append(" and sdv.COD_AREA_EMPRESA = sv.COD_AREA_EMPRESA");
                                                    consulta.append(" inner join PRESENTACIONES_PRODUCTO pp on pp.cod_presentacion =sdv.COD_PRESENTACION");
                                             consulta.append(" where sv.COD_ESTADO_SALIDAVENTA <> 2");
                                                    consulta.append(" and sv.COD_ALMACEN_VENTA in (58, 28, 27, 32, 29)");
                                                    consulta.append(" and sv.COD_AREA_EMPRESA = 1");
                                                    consulta.append(" and sv.FECHA_SALIDAVENTA BETWEEN '").append(sdf.format(fechaInicio)).append(" 00:00:00' and '").append(sdf.format(fechaFinal)).append(" 23:59:59'");
                                                    consulta.append(" and sdv.COD_PRESENTACION in (").append(codigosPresentacion).append(")");
                        StringBuilder consultaSalidaAlmacen=new StringBuilder(consulta.toString());
                                                            consultaSalidaAlmacen.append(" and sv.COD_ALMACEN_VENTADESTINO=?");
                                            consultaSalidaAlmacen.append(" group by sv.FECHA_SALIDAVENTA");
                        System.out.println("consulta detalle almacen destino "+consultaSalidaAlmacen.toString());
                        PreparedStatement pstSalidaAlmacen=con.prepareStatement(consultaSalidaAlmacen.toString());
                        StringBuilder consultaSalidaCliente=new StringBuilder(consulta.toString());
                                                            consultaSalidaCliente.append(" and isnull(sv.COD_ALMACEN_VENTADESTINO,0)=0");
                                                            consultaSalidaCliente.append(" and sv.COD_CLIENTE=?");
                                            consultaSalidaCliente.append(" group by sv.FECHA_SALIDAVENTA");
                        PreparedStatement pstSalidaCliente=con.prepareStatement(consultaSalidaCliente.toString());
                        StringBuilder consultaSalidaTipo=new StringBuilder(consulta.toString());
                                                        consultaSalidaTipo.append(" and isnull(sv.COD_ALMACEN_VENTADESTINO,0)=0");
                                                        consultaSalidaTipo.append(" and isnull(sv.COD_CLIENTE,0)=0");
                                                        consultaSalidaTipo.append(" and sv.COD_TIPOSALIDAVENTAS=?");
                                            consultaSalidaTipo.append(" group by sv.FECHA_SALIDAVENTA");
                        PreparedStatement pstSalidaTipo=con.prepareStatement(consultaSalidaTipo.toString());
                        
                        consulta=new StringBuilder("select isnull(isnull(av.NOMBRE_ALMACEN_VENTA,c.nombre_cliente),case when ISNULL(tsv.COD_TIPOSALIDAVENTAS,0)=5 then 'ANALISIS ESTABILIDAD' when ISNULL(tsv.COD_TIPOSALIDAVENTAS,0)=6 then 'ANALISIS DE MARKETING' else tsv.NOMBRE_TIPOSALIDAVENTAS end) as motivoEnvio ,sum(sdv.CANTIDAD_TOTAL) as cantidadTotal,sum(sdv.CANTIDAD_UNITARIATOTAL+sdv.CANTIDAD_TOTAL*pp.cantidad_presentacion) as cantidadUnitariaTotal");
                                            consulta.append(" ,tsv.NOMBRE_TIPOSALIDAVENTAS,isnull(sv.COD_ALMACEN_VENTADESTINO,0) as COD_ALMACEN_VENTADESTINO,isnull(sv.COD_CLIENTE,0) as COD_CLIENTE,ISNULL(tsv.COD_TIPOSALIDAVENTAS,0) as COD_TIPOSALIDAVENTAS");
                                    consulta.append(" from SALIDAS_VENTAS sv");
                                            consulta.append(" inner join SALIDAS_DETALLEVENTAS sdv on sdv.COD_SALIDAVENTAS=sv.COD_SALIDAVENTA");
                                            consulta.append(" and sdv.COD_AREA_EMPRESA=sv.COD_AREA_EMPRESA");
                                            consulta.append(" left outer join ALMACENES_VENTAS av on av.COD_ALMACEN_VENTA=sv.COD_ALMACEN_VENTADESTINO");
                                            consulta.append(" left outer join clientes c on c.COD_CLIENTE=sv.COD_CLIENTE and c.cod_cliente not in (0)");
                                            consulta.append(" left outer join TIPOS_SALIDAVENTAS tsv on tsv.COD_TIPOSALIDAVENTAS=sv.COD_TIPOSALIDAVENTAS");
                                            consulta.append(" inner join PRESENTACIONES_PRODUCTO pp on pp.cod_presentacion=sdv.COD_PRESENTACION");
                                    consulta.append(" where sv.COD_ESTADO_SALIDAVENTA<>2");
                                            consulta.append(" and sv.COD_ALMACEN_VENTA in (").append(codAlmacenVenta).append(")");
                                        consulta.append(" and sv.COD_AREA_EMPRESA=1");
                                        consulta.append(" and sv.FECHA_SALIDAVENTA BETWEEN '").append(sdf.format(fechaInicio)).append(" 00:00:00' and '").append(sdf.format(fechaFinal)).append(" 23:59:59'");
                                        consulta.append(" and sdv.COD_PRESENTACION in (").append(codigosPresentacion).append(")");
                                    consulta.append(" group by av.NOMBRE_ALMACEN_VENTA,c.nombre_cliente,tsv.NOMBRE_TIPOSALIDAVENTAS,isnull(sv.COD_ALMACEN_VENTADESTINO,0),isnull(sv.COD_CLIENTE,0),ISNULL(tsv.COD_TIPOSALIDAVENTAS,0)");
                                    consulta.append(" order by 1");
                        System.out.println("consulta cargar detalle salidas regional "+consulta.toString());
                        res=st.executeQuery(consulta.toString());
                        StringBuilder detalleCabecera=new StringBuilder("");
                        StringBuilder detalleCuerpo=new StringBuilder("");
                        StringBuilder detalleSalida=new StringBuilder("");
                        int cantidadTotal=0;
                        ResultSet resDetalle;
                        int contador=0;
                        out.println("<br/><table cellpadding='0' cellspacing='0' class='tablaReporte' style='min-width:90%;margin-top:2rem'>");
                            out.println("<thead><tr><td colspan='24' class='tdCenter'>DESTINO DE EGRESOS DEL PRODUCTO EN UNIDADES</td></tr></thead>");
                            out.println("<tbody>");
                        while(res.next())
                        {
                            
                                if(contador==12)
                                {
                                    out.println("<tr class='celdaAlmacenDestino'>"+detalleCabecera.toString()+"</tr>");
                                    out.println("<tr>"+detalleCuerpo.toString()+"</tr>");
                                    out.println("<tr>"+detalleSalida.toString()+"</tr>");
                                    detalleCuerpo=new StringBuilder("");
                                    detalleSalida=new StringBuilder("");
                                    detalleCabecera=new StringBuilder("");
                                    contador=0;
                                }
                                contador++;
                                detalleCabecera.append("<td class='tdCenter borderTop'>").append(res.getString("motivoEnvio")).append("</td>");
                                detalleCuerpo.append("<td class='tdRight'>").append(format.format(res.getInt("cantidadUnitariaTotal"))).append("</td>");
                                cantidadTotal+=res.getInt("cantidadUnitariaTotal");
                                detalleSalida.append("<td style='padding:0px;vertical-align:top'><table style='width:100%' class='tablaReporte' cellpadding='0' cellspacing='0'><thead><tr><td class='tdCenter' colspan='2'>Detalle</td></tr><tr><td class='borderTop tdCenter'>Fecha</td><td class='borderTop tdCenter'>Cantidad</td></tr></thead><tbody>");
                                if(res.getInt("COD_ALMACEN_VENTADESTINO")>0)
                                {
                                    pstSalidaAlmacen.setInt(1,res.getInt("COD_ALMACEN_VENTADESTINO"));
                                    resDetalle=pstSalidaAlmacen.executeQuery();
                                    while(resDetalle.next())
                                    {
                                        detalleSalida.append("<tr><td><div>").append(sdfFecha.format(resDetalle.getTimestamp("FECHA_SALIDAVENTA"))).append("</div><div>"+sdfHora.format(resDetalle.getTimestamp("FECHA_SALIDAVENTA"))+"</div></td><td class='tdRight'>"+format.format(resDetalle.getDouble("cantidadUnitariaTotal"))+"</td></tr>");
                                    }
                                }
                                else
                                {
                                    if(res.getInt("COD_CLIENTE")>0)
                                    {
                                        pstSalidaCliente.setInt(1,res.getInt("COD_CLIENTE"));
                                        resDetalle=pstSalidaCliente.executeQuery();
                                        while(resDetalle.next())
                                        {
                                            detalleSalida.append("<tr><td><div>").append(sdfFecha.format(resDetalle.getTimestamp("FECHA_SALIDAVENTA"))).append("</div><div>"+sdfHora.format(resDetalle.getTimestamp("FECHA_SALIDAVENTA"))+"</div></td><td class='tdRight'>"+format.format(resDetalle.getDouble("cantidadUnitariaTotal"))+"</td></tr>");
                                        }
                                    }
                                    else
                                    {
                                        pstSalidaTipo.setInt(1,res.getInt("COD_TIPOSALIDAVENTAS"));
                                        resDetalle=pstSalidaTipo.executeQuery();
                                        while(resDetalle.next())
                                        {
                                            detalleSalida.append("<tr><td><div>").append(sdfFecha.format(resDetalle.getTimestamp("FECHA_SALIDAVENTA"))).append("</div><div>"+sdfHora.format(resDetalle.getTimestamp("FECHA_SALIDAVENTA"))+"</div></td><td class='tdRight'>"+format.format(resDetalle.getDouble("cantidadUnitariaTotal"))+"</td></tr>");
                                        }
                                    }
                                }
                                detalleSalida.append("</tbody></table></td>");
                                
                            
                        }
                        if(contador<=12&&contador>0)
                        {
                            out.println("<tr class='celdaAlmacenDestino'>"+detalleCabecera.toString()+"<td class='tdCenter borderTop'>TOTAL</td></tr>");
                            out.println("<tr>"+detalleCuerpo.toString()+"<td class='tdRight' style='padding:0px'><div class='totalSalida outputTextBold'>"+format.format(cantidadTotal)+"</div></td></tr>");
                            out.println("<tr>"+detalleSalida.toString()+"</tr>");
                        }
                                
                            out.println("</tbody>");
                        out.println("</table>");
                    }
                    catch(ParseException ex)
                    {
                        ex.printStackTrace();
                    }
                    catch(SQLException ex)
                    {
                        ex.printStackTrace();
                    }
                    catch(Exception e)
                    {
                        e.printStackTrace();
                    }
                    finally
                    {
                        con.close();
                    }
                %>
                
        
        </form>
        <div style="width: 100%;text-align: left">
            <br/>
                <span class="outputTextBold">Nota:&nbsp;</span><span class="outputText2">Para el caso de Licitaciones la facturación se realiza desde la casa Matriz situada en La Paz, razón por la cual se detalla dicha transacción en el reporte por cliente.</span>
            <br/>
        </div>
        <script type="text/javascript" language="JavaScript"  src="../../css/dlcalendar.js"></script>
        </center>
    </body>
</html>