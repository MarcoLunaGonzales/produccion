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
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
        <script src="../../js/general.js"></script>
        <style>
            .acondicionamiento{
            background-color:#90EE90;
            }
            .apt{
            background-color:#7FFFD4;
            }
            .produccion{
            background-color:#ded583;
            }
            .baco{
            background-color:#ADD8E6;
            }
            .celdaApt{
            background-color:#c2fde9;
            }
            .celdaAcondicionamiento{
            background-color:#b7f6b7;
            }
            .celdaProduccion{
            background-color:#F0E68C;
            }
            .celdaBaco{
            background-color:#d2f1fb;
            }
            .bordeNegroTd1 {
                padding: 5px;
                border-right-width: 1px;
                border-bottom-width: 1px;
                border-right-style: solid;
                border-bottom-style: solid;
                border-right-color: #bbbbbb;
                border-bottom-color: #bbbbbb;
                font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10px;
                }
        </style>
    <script>
        function verDetalle(codLote,codAlmacen)
        {
            urlOOS="reporteKardexAcond.jsf?codLote="+codLote+"&almacen="+codAlmacen+"&almacen="+codLote+"&date="+(new Date()).getTime().toString()+"&ale="+Math.random();
                    window.open(urlOOS,'detalle'+Math.round((Math.random()*1000)),'top=50,left=200,width=800,height=600,scrollbars=1,resizable=1');
                    
        }
    </script>    
</head>
    <body>
        <form>
            <table align="center" width="90%">
                <tr>
                    <td colspan="3" align="center" >
                        <h4>Reporte Existencias Acond - APT - Prog. Prod.</h4>
                    </td>
                </tr>
                <%
                Connection con=null;
                String codProgramaProd=request.getParameter("codProgramaProd");
                String codProducto=request.getParameter("codCompProd");
                String codLote=request.getParameter("codLote");
                NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
                DecimalFormat form = (DecimalFormat)nf;
                form.applyPattern("#,###");
                %>                
                
            </table>
            <table  align="center" width="90%" class="outputText2" style="border : solid #f2f2f2 1px;" cellpadding="0" cellspacing="0">
                
                <tr class="tablaFiltroReporte">
                    <td align="center" class="bordeNegroTd1" rowspan="3"><b>Código</b></td>
                    <td align="center" class="bordeNegroTd1" rowspan="3"><b>Producto</b></td>
                    <td align="center" class="bordeNegroTd1" rowspan="3"><b>Lote</b></td>
                    <td align="center" class="bordeNegroTd1" rowspan="3"><b>Estado<br>Programa<br>Producción</b></td>
                    <td align="center" class="bordeNegroTd1" rowspan="3"><b>Tamaño<br>Lote</b></td>
                    <td align="center" class="bordeNegroTd1" rowspan="3"><b>Tipo<br>Programa<br>Producción</b></td>
                    <td align="center" class="bordeNegroTd1 mc" colspan="7" ><b>Acond. M. Corriente</b></td>
                    <td  align="center" class="bordeNegroTd1 mm" colspan="6"><b>Acond. Muestra Medica</b></td>
                    <td  align="center" class="bordeNegroTd1 mm" colspan="5"><b>Salidas y Devoluciones(BACO)</b></td>
                    
                </tr>
                <tr class="tablaFiltroReporte">
                    <td align="center" class="bordeNegroTd1 acondicionamiento " rowspan="2" ><b>Cant. Total Ing. Acond</b></td>
                    <td align="center" class="bordeNegroTd1 apt" colspan="3" ><b>Cantidad Ingreso APT</b></td>
                    <td align="center" class="bordeNegroTd1 apt" rowspan="2" ><b>Cantidad Total Ingreso APT</b></td>
                    <td align="center" class="bordeNegroTd1 produccion" rowspan="2" ><b>Cant. Ingresos Por Cierre</b></td>
                    <td align="center" class="bordeNegroTd1 produccion" rowspan="2" ><b>Cant. Salidas Por Cierre</b></td>
                    <td align="center" class="bordeNegroTd1 acondicionamiento" rowspan="2"><b>Cant. Total Ing. Acond</b></td>
                    <td align="center" class="bordeNegroTd1 apt" colspan="2"><b>Cant. Ingreso Apt</b></td>
                    <td align="center" class="bordeNegroTd1 apt" rowspan="2"><b>Cantidad Total Ingreso APT</b></td>
                    <td align="center" class="bordeNegroTd1 produccion" rowspan="2" ><b>Cant. Ingresos Por Cierre</b></td>
                    <td align="center" class="bordeNegroTd1 produccion" rowspan="2" ><b>Cant. Salidas Por Cierre</b></td>
                    <td align="center" class="bordeNegroTd1 baco" rowspan="2" ><b>Almacen</b></td>
                    <td align="center" class="bordeNegroTd1 baco" rowspan="2" ><b>Material</b></td>
                    <td align="center" class="bordeNegroTd1 baco" rowspan="2" ><b>Unidad</b></td>
                    <td align="center" class="bordeNegroTd1 baco" rowspan="2" ><b>Cant. Salidas</b></td>
                    <td align="center" class="bordeNegroTd1 baco" rowspan="2" ><b>Cant. Devoluciones</b></td>
                </tr>
                <tr class="tablaFiltroReporte">
                    <td align="center" class="bordeNegroTd1 apt"><b>CC Quintanilla</b></td>
                    <td align="center" class="bordeNegroTd1 apt"><b>Cuarentena MC</b></td>
                    <td align="center" class="bordeNegroTd1 apt"><b>Cuarentena Ins.</b></td>
                    <td align="center" class="bordeNegroTd1 apt"><b>CC Quintanilla</b></td>
                    <td align="center" class="bordeNegroTd1 apt"><b>Cuarentena MM</b></td>
                    
                </tr>
                    
                <%
                try{
                    con=Util.openConnection(con);
                    StringBuilder consulta=new StringBuilder("select pp.COD_COMPPROD,pp.COD_LOTE_PRODUCCION,ppp.NOMBRE_PROGRAMA_PROD,cpv.nombre_prod_semiterminado");
                                   consulta.append(",tpp.NOMBRE_TIPO_PROGRAMA_PROD,pp.CANT_LOTE_PRODUCCION,epp.NOMBRE_ESTADO_PROGRAMA_PROD");
                                   consulta.append(" ,(select sum(id.CANT_TOTAL_INGRESO) as cantidadIngresoMC from INGRESOS_DETALLEACOND id inner join INGRESOS_ACOND ia on ");
                                   consulta.append("ia.COD_INGRESO_ACOND=id.COD_INGRESO_ACOND where id.COD_LOTE_PRODUCCION=pp.COD_LOTE_PRODUCCION and pp.COD_COMPPROD=id.COD_COMPPROD and ia.COD_ESTADO_INGRESOACOND<>2 and ia.COD_ALMACENACOND=1 ) as cantidadIngresoMC");
                                   consulta.append(",( select sum(ide.CANT_TOTAL_INGRESO) as cantidadIngresoMM from INGRESOS_DETALLEACOND ide inner join INGRESOS_ACOND iac on  iac.COD_INGRESO_ACOND=ide.COD_INGRESO_ACOND");
                                   consulta.append(" where ide.COD_LOTE_PRODUCCION=pp.COD_LOTE_PRODUCCION and pp.COD_COMPPROD=ide.COD_COMPPROD and iac.COD_ESTADO_INGRESOACOND<>2 and iac.COD_ALMACENACOND=3 ) as cantidadIngresoMM");
                                   consulta.append(",(select sum((isnull(idv.CANTIDAD, 0) * isnull(ppr.cantidad_presentacion,0)) + isnull(idv.CANTIDAD_UNITARIA, 0)) from INGRESOS_VENTAS iv inner join INGRESOS_DETALLEVENTAS idv on iv.COD_INGRESOVENTAS =idv.COD_INGRESOVENTAS");
                                   consulta.append(" inner join PRESENTACIONES_PRODUCTO ppr on ppr.cod_presentacion =idv.COD_PRESENTACION inner join SALIDAS_DETALLEACOND sd on sd.COD_SALIDA_ACOND =iv.COD_SALIDA_ACOND and idv.COD_PRESENTACION = sd.COD_PRESENTACION");
                                   consulta.append(" and idv.COD_LOTE_PRODUCCION = sd.COD_LOTE_PRODUCCION COLLATE Traditional_Spanish_CI_AI and sd.COD_COMPPROD = pp.COD_COMPPROD where iv.COD_ALMACEN_VENTA =54 and idv.COD_LOTE_PRODUCCION = pp.COD_LOTE_PRODUCCION COLLATE Traditional_Spanish_CI_AI ) as cantidadIngresoAPTMC");
                                   consulta.append(",(select sum((isnull(idv.CANTIDAD, 0) * isnull(ppr.cantidad_presentacion,0)) + isnull(idv.CANTIDAD_UNITARIA, 0)) from INGRESOS_VENTAS iv inner join INGRESOS_DETALLEVENTAS idv on iv.COD_INGRESOVENTAS =idv.COD_INGRESOVENTAS");
                                   consulta.append(" inner join PRESENTACIONES_PRODUCTO ppr on ppr.cod_presentacion =idv.COD_PRESENTACION inner join SALIDAS_DETALLEACOND sd on sd.COD_SALIDA_ACOND =iv.COD_SALIDA_ACOND and idv.COD_PRESENTACION = sd.COD_PRESENTACION and idv.COD_LOTE_PRODUCCION = sd.COD_LOTE_PRODUCCION COLLATE");
                                   consulta.append(" Traditional_Spanish_CI_AI and sd.COD_COMPPROD = pp.COD_COMPPROD where iv.COD_ALMACEN_VENTA =57 and idv.COD_LOTE_PRODUCCION = pp.COD_LOTE_PRODUCCION COLLATE Traditional_Spanish_CI_AI ) as cantidadIngresoAPTMM");
                                   consulta.append(",( select sum((isnull(idv.CANTIDAD, 0) * isnull(ppr.cantidad_presentacion, 0)) + isnull(idv.CANTIDAD_UNITARIA, 0)) from INGRESOS_VENTAS iv inner join INGRESOS_DETALLEVENTAS idv on iv.COD_INGRESOVENTAS =idv.COD_INGRESOVENTAS");
                                   consulta.append(" inner join PRESENTACIONES_PRODUCTO ppr on ppr.cod_presentacion =idv.COD_PRESENTACION inner join SALIDAS_DETALLEACOND sd on sd.COD_SALIDA_ACOND = iv.COD_SALIDA_ACOND and idv.COD_PRESENTACION = sd.COD_PRESENTACION and idv.COD_LOTE_PRODUCCION = sd.COD_LOTE_PRODUCCION COLLATE");
                                   consulta.append("  Traditional_Spanish_CI_AI and sd.COD_COMPPROD = pp.COD_COMPPROD where iv.COD_ALMACEN_VENTA =56 and idv.COD_LOTE_PRODUCCION = pp.COD_LOTE_PRODUCCION COLLATE Traditional_Spanish_CI_AI ) as cantidadIngresoAPTInstitucional");
                                   consulta.append(" ,isnull(( SELECT SUM((isnull(idv2.CANTIDAD, 0) * isnull( ppr2.cantidad_presentacion, 0)) + isnull(idv2.CANTIDAD_UNITARIA, 0)) FROM INGRESOS_VENTAS iv2 INNER JOIN INGRESOS_DETALLEVENTAS idv2 ON iv2.COD_INGRESOVENTAS = idv2.COD_INGRESOVENTAS");
                                   consulta.append(" INNER JOIN PRESENTACIONES_PRODUCTO ppr2 ON ppr2.cod_presentacion = idv2.COD_PRESENTACION inner join SALIDAS_ACOND s2 on s2.COD_SALIDA_ACOND = iv2.COD_SALIDA_ACOND inner JOIN SALIDAS_DETALLEACOND sd2 on sd2.COD_SALIDA_ACOND= s2.COD_SALIDA_ACOND");
                                   consulta.append(" and sd2.COD_PRESENTACION =idv2.COD_PRESENTACION and idv2.COD_LOTE_PRODUCCION = sd2.COD_LOTE_PRODUCCION COLLATE Traditional_Spanish_CI_AI and sd2.COD_COMPPROD = pp.cod_compprod WHERE iv2.COD_ALMACEN_VENTA = 29 and s2.COD_ALMACENACOND =1 AND idv2.COD_LOTE_PRODUCCION = pp.COD_LOTE_PRODUCCION COLLATE Traditional_Spanish_CI_AI), 0) AS cantidadCCQuintanillaMC");
                                   consulta.append(" ,isnull(( SELECT SUM((isnull(idv2.CANTIDAD, 0) * isnull( ppr2.cantidad_presentacion, 0)) + isnull(idv2.CANTIDAD_UNITARIA,0))");
                                   consulta.append(" FROM INGRESOS_VENTAS iv2 INNER JOIN INGRESOS_DETALLEVENTAS idv2 ON iv2.COD_INGRESOVENTAS = idv2.COD_INGRESOVENTAS INNER JOIN PRESENTACIONES_PRODUCTO ppr2 ON ppr2.cod_presentacion = idv2.COD_PRESENTACION");
                                   consulta.append(" inner join SALIDAS_ACOND s2 on s2.COD_SALIDA_ACOND = iv2.COD_SALIDA_ACOND inner JOIN SALIDAS_DETALLEACOND sd2 on sd2.COD_SALIDA_ACOND= s2.COD_SALIDA_ACOND and sd2.COD_PRESENTACION =idv2.COD_PRESENTACION");
                                   consulta.append(" and idv2.COD_LOTE_PRODUCCION = sd2.COD_LOTE_PRODUCCION COLLATE Traditional_Spanish_CI_AI and sd2.COD_COMPPROD = pp.cod_compprod WHERE iv2.COD_ALMACEN_VENTA = 29 and s2.COD_ALMACENACOND =3");
                                   consulta.append(" AND idv2.COD_LOTE_PRODUCCION = pp.COD_LOTE_PRODUCCION COLLATE Traditional_Spanish_CI_AI), 0) AS cantidadCCQuintanillaMM");
                                   consulta.append(",( select count(*) from INGRESOS_ACOND ia1 inner join INGRESOS_DETALLEACOND id1 on ia1.COD_INGRESO_ACOND = id1.COD_INGRESO_ACOND");
                                   consulta.append(" where ia1.COD_ESTADO_INGRESOACOND not in (2) and id1.COD_LOTE_PRODUCCION = pp.COD_LOTE_PRODUCCION and ia1.COD_TIPOINGRESOACOND = 5 and ia1.COD_ALMACENACOND = 1 and id1.COD_COMPPROD = pp.COD_COMPPROD ) as cantIngresosCierreMC");
                                   consulta.append(",( select count(*) from INGRESOS_ACOND ia1 inner join INGRESOS_DETALLEACOND id1 on ia1.COD_INGRESO_ACOND = id1.COD_INGRESO_ACOND");
                                   consulta.append(" where ia1.COD_ESTADO_INGRESOACOND not in (2) and id1.COD_LOTE_PRODUCCION = pp.COD_LOTE_PRODUCCION and ia1.COD_TIPOINGRESOACOND = 5 and ia1.COD_ALMACENACOND =3 and id1.COD_COMPPROD = pp.COD_COMPPROD ) as cantIngresosCierreMM");
                                   consulta.append(",(select COUNT(*) from SALIDAS_ACOND sa3 inner join SALIDAS_DETALLEACOND sd3 on sa3.COD_SALIDA_ACOND = sd3.COD_SALIDA_ACOND where sd3.COD_LOTE_PRODUCCION = pp.COD_LOTE_PRODUCCION and sa3.COD_ALMACENACOND = 1 and sa3.COD_ESTADO_SALIDAACOND not in (2) and sa3.COD_TIPOSALIDAACOND = 6 and sd3.COD_COMPPROD = pp.COD_COMPPROD ) as cantSalidasCierreMC");
                                   consulta.append(",( select COUNT(*) from SALIDAS_ACOND sa3 inner join SALIDAS_DETALLEACOND sd3 on sa3.COD_SALIDA_ACOND = sd3.COD_SALIDA_ACOND where sd3.COD_LOTE_PRODUCCION = pp.COD_LOTE_PRODUCCION and sa3.COD_ALMACENACOND = 3 and sa3.COD_ESTADO_SALIDAACOND not in (2) and sa3.COD_TIPOSALIDAACOND = 6 and sd3.COD_COMPPROD = pp.COD_COMPPROD) as cantSalidasCierreMM");
                                  consulta.append(" from PROGRAMA_PRODUCCION pp inner join PROGRAMA_PRODUCCION_PERIODO ppp");
                                  consulta.append(" on pp.COD_PROGRAMA_PROD=ppp.COD_PROGRAMA_PROD");
                                  consulta.append(" inner join COMPONENTES_PROD_VERSION cpv on cpv.COD_VERSION=pp.COD_COMPPROD_VERSION");
                                  consulta.append(" and cpv.COD_COMPPROD=pp.COD_COMPPROD");
                                  consulta.append(" inner join ESTADOS_PROGRAMA_PRODUCCION epp on epp.COD_ESTADO_PROGRAMA_PROD=pp.COD_ESTADO_PROGRAMA");
                                  consulta.append(" inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD");
                                  consulta.append(" where pp.COD_COMPPROD='").append(codProducto).append("'");
                                  consulta.append(" and pp.COD_PROGRAMA_PROD='").append(codProgramaProd).append("'");
                                  if(codLote.length()>0)consulta.append(" and pp.COD_LOTE_PRODUCCION='").append(codLote).append("'");
                            System.out.println(consulta.toString());
                    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    ResultSet res=st.executeQuery(consulta.toString());
                    Statement stDetalle=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet resDetalle=null;
                    while(res.next())
                    {
                        consulta=new StringBuilder("select nombre_material,abreviatura,NOMBRE_ALMACEN,sum(cantidad_salida_almacen) as cantidadSalidaAlmacen, sum(devoluciones_material) as cantidadDevolucion");
                        consulta.append(" from( select m.nombre_material, um.abreviatura, a.NOMBRE_ALMACEN, sad.cantidad_salida_almacen,");
                        consulta.append(" isnull(( select sum(isnull(iad.CANT_TOTAL_INGRESO_FISICO, 0)) from devoluciones d inner join ingresos_almacen ia on d.cod_devolucion =ia.cod_devolucion and ia.cod_almacen = 1");
                        consulta.append(" inner join ingresos_almacen_detalle iad on iad.cod_ingreso_almacen = ia.cod_ingreso_almacen");
                        consulta.append(" where d.estado_sistema = 1 and d.cod_almacen = '1' and ia.cod_estado_ingreso_almacen = 1 and d.cod_estado_devolucion = 1");
                        consulta.append(" and iad.cod_material = m.cod_material and d.COD_SALIDA_ALMACEN = sa.COD_SALIDA_ALMACEN), 0) devoluciones_material");
                        consulta.append(" from SALIDAS_ALMACEN sa inner join SALIDAS_ALMACEN_DETALLE sad on sad.COD_SALIDA_ALMACEN =sa.COD_SALIDA_ALMACEN");
                        consulta.append(" inner join materiales m on m.COD_MATERIAL = sad.COD_MATERIAL inner join unidades_medida um on um.cod_unidad_medida =m.cod_unidad_medida");
                        consulta.append(" inner join almacenes a on a.COD_ALMACEN=sa.COD_ALMACEN");
                        consulta.append(" where sa.COD_LOTE_PRODUCCION = '").append(res.getString("COD_LOTE_PRODUCCION")).append("' and sa.COD_ESTADO_SALIDA_ALMACEN = 1 and sa.ESTADO_SISTEMA = 1) as tabla");
                        consulta.append(" group by nombre_material,abreviatura,NOMBRE_ALMACEN order by NOMBRE_ALMACEN,nombre_material");
                        System.out.println("consulta detalle "+consulta);
                        resDetalle=stDetalle.executeQuery(consulta.toString());
                        StringBuilder materialDetalle=new StringBuilder();
                        while(resDetalle.next())
                        {
                            if(materialDetalle.length()>0)materialDetalle.append("<tr>");
                            materialDetalle.append("<td class='bordeNegroTd1 celdaBaco'>").append(resDetalle.getString("NOMBRE_ALMACEN")).append("</td>");
                            materialDetalle.append("<td class='bordeNegroTd1 celdaBaco'>").append(resDetalle.getString("nombre_material")).append("</td>");
                            materialDetalle.append("<td class='bordeNegroTd1 celdaBaco'>").append(resDetalle.getString("abreviatura")).append("</td>");
                            materialDetalle.append("<td class='bordeNegroTd1 celdaBaco'>").append(form.format(resDetalle.getDouble("cantidadSalidaAlmacen"))).append("</td>");
                            materialDetalle.append("<td class='bordeNegroTd1 celdaBaco'>").append(form.format(resDetalle.getDouble("cantidadDevolucion"))).append("</td>");
                            materialDetalle.append("</tr>");
                        }
                        resDetalle.last();
                            out.println("<tr><th rowspan='"+resDetalle.getRow()+"' class='bordeNegroTd1'  align='left'>"+res.getString("COD_COMPPROD")+"</th>");
                            out.println("<th rowspan='"+resDetalle.getRow()+"' class='bordeNegroTd1' style='font-weight:normal'>"+res.getString("nombre_prod_semiterminado")+"</th>");
                            out.println("<th rowspan='"+resDetalle.getRow()+"' class='bordeNegroTd1' style='font-weight:normal'> "+res.getString("COD_LOTE_PRODUCCION")+"</th>");
                            out.println("<th rowspan='"+resDetalle.getRow()+"' class='bordeNegroTd1' style='font-weight:normal'> "+res.getString("NOMBRE_ESTADO_PROGRAMA_PROD")+"</th>");
                            out.println("<th rowspan='"+resDetalle.getRow()+"' class='bordeNegroTd1' style='font-weight:normal'> "+res.getString("CANT_LOTE_PRODUCCION")+"</th>");
                            out.println("<th rowspan='"+resDetalle.getRow()+"' class='bordeNegroTd1' style='font-weight:normal'> "+res.getString("NOMBRE_TIPO_PROGRAMA_PROD")+"</th>");
                            out.println("<th rowspan='"+resDetalle.getRow()+"' class='bordeNegroTd1 celdaAcondicionamiento' style='font-weight:normal'>"+(res.getInt("cantidadIngresoMC"))+"</th>");
                            out.println("<th rowspan='"+resDetalle.getRow()+"' class='bordeNegroTd1 celdaApt' style='font-weight:normal'>"+res.getInt("cantidadCCQuintanillaMC")+"</th>");
                            out.println("<th rowspan='"+resDetalle.getRow()+"' class='bordeNegroTd1 celdaApt' style='font-weight:normal'>"+res.getInt("cantidadIngresoAPTMC")+"</th>");
                            out.println("<th  rowspan='"+resDetalle.getRow()+"' class='bordeNegroTd1 celdaApt' style='font-weight:normal'>"+res.getInt("cantidadIngresoAPTInstitucional")+"</th>");
                            out.println("<th rowspan='"+resDetalle.getRow()+"' class='bordeNegroTd1 celdaApt' style='font-weight:normal'>"+(res.getInt("cantidadCCQuintanillaMC")+res.getInt("cantidadIngresoAPTMC")+res.getInt("cantidadIngresoAPTInstitucional"))+"</th>");
                            out.println("<th rowspan='"+resDetalle.getRow()+"' class='bordeNegroTd1 celdaProduccion' style='font-weight:normal'>"+(res.getInt("cantIngresosCierreMC"))+"</th>");
                            out.println("<th rowspan='"+resDetalle.getRow()+"' class='bordeNegroTd1 celdaProduccion' style='font-weight:normal'>"+res.getInt("cantSalidasCierreMC")+"</th>");
                            out.println("<th rowspan='"+resDetalle.getRow()+"' class='bordeNegroTd1 celdaAcondicionamiento' style='font-weight:normal'>"+res.getInt("cantidadIngresoMM")+"</th>");
                            out.println("<th rowspan='"+resDetalle.getRow()+"' class='bordeNegroTd1 celdaApt' style='font-weight:normal'>"+res.getInt("cantidadCCQuintanillaMM")+"</th>");
                            out.println("<th rowspan='"+resDetalle.getRow()+"' class='bordeNegroTd1 celdaApt' style='font-weight:normal'>"+res.getInt("cantidadIngresoAPTMM")+"</th>");
                            out.println("<th rowspan='"+resDetalle.getRow()+"' class='bordeNegroTd1 celdaApt' style='font-weight:normal'>"+(res.getInt("cantidadCCQuintanillaMM")+res.getInt("cantidadIngresoAPTMM"))+"</th>");
                            out.println("<th rowspan='"+resDetalle.getRow()+"' class='bordeNegroTd1 celdaProduccion' style='font-weight:normal'>"+res.getInt("cantIngresosCierreMM")+"</th>");
                            out.println("<th rowspan='"+resDetalle.getRow()+"' class='bordeNegroTd1 celdaProduccion' style='font-weight:normal'>"+res.getInt("cantSalidasCierreMM")+"</th>");
                            out.println(materialDetalle.toString()); 
                        }
                }
                catch (SQLException e) {
                    e.printStackTrace();
                }
                catch(Exception ex)
                {
                    ex.printStackTrace();
                }
                %>
            </table>
        </form>
    </body>
</html>