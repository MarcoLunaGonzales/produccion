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
<%! 


%>
<%! 
public String nombrePresentacion1(String codPresentacion){
    

 
String  nombreproducto="";
Connection con=null;
try{
con=Util.openConnection(con);
String sql_aux="select cod_presentacion, nombre_producto_presentacion from presentaciones_producto where cod_presentacion='"+codPresentacion+"'";
System.out.println("PresentacionesProducto:sql:"+sql_aux);
Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
ResultSet rs=st.executeQuery(sql_aux);
while (rs.next()){
String codigo=rs.getString(1);
nombreproducto=rs.getString(2);
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
        
        <%--meta http-equiv="Content-Type" content="text/html; charset=UTF-8"--%>
        <title>JSP Page</title>
        <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
        <script src="../../js/general.js"></script>
        <script>
            function openPopup(url){
                window.open(url,'DETALLE'+Math.round(Math.random()*1000),'top=50,left=200,width=800,height=600,scrollbars=1,resizable=1');
                    return false;
                }
                function openPopup1(url,height){
                window.open(url,'DETALLE'+Math.round(Math.random()*1000),'top=50,left=200,width=800,height='+height+',scrollbars=1,resizable=1');
                    return false;
                }
        </script>
    </head>
    <body>
        <h3 align="center">Reporte de Programa Produccion por Estados</h3>
        <br>
        <form>
            <table align="center" width="90%">

                <%
                    Connection con=null;
                    try
                    {
                        NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
                        DecimalFormat format = (DecimalFormat)nf;
                        format.applyPattern("#,###");

                        String codProgramaProdPeriodo=request.getParameter("codProgramaProduccionPeriodo")==null?"0":request.getParameter("codProgramaProduccionPeriodo");
                        String nombreProgramaProdPeriodo=request.getParameter("nombreProgramaProduccionPeriodo")==null?"0":request.getParameter("nombreProgramaProduccionPeriodo");
                        String codEstadoProgramaProd=request.getParameter("codEstadoProgramaProd")==null?"0":request.getParameter("codEstadoProgramaProd");
                        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
                    
                %>
                <table align="center" width="60%" class='outputText0'>
                <tr>
                    <td width="10%">
                        <img src="../../img/cofar.png">
                    </td>
                <td align="center" width="80%">
                <br>
                    Programa Produccion : <b><%=nombreProgramaProdPeriodo%></b>
                    <%--br><br>
                    Fecha Inicial : <b><%=fechaInicial%></b>
                    <br><br>
                    Fecha Final : <b><%=fechaFinal%></b--%>

                </td>
                <td align="center" >
                </td>
                </tr>
            </table>
            </table>
            <br>
            <br>
            <br>
                <table  ></table>
            <table  align="center"  width="60%" class="tablaReporte" cellpadding="0" cellspacing="0">
                <thead>
                    <tr>
                        <td  ><b>Nro</b></td>
                        <td  ><b>Producto</b></td>
                        <td  ><b>Tipo Programa Produccion</b></td>
                        <td  ><b>Programa Produccion</b></td>
                        <td  ><b>Lote</b></td>

                        <td  ><b>fecha pesaje</b></td>
                        <td  ><b>fecha Venc.</b></td>
                        <td  ><b>Estado</b></td>
                        <td  ><b>Lote Produccion</b></td>
                        <td  ><b>Cant. Enviada Produccion</b></td>
                        <td  ><b>Saldo en Proceso</b></td>
                        <td  ><b>Cant. Ingreso Acond</b></td>
                        <td  ><b>Cant. Enviada APT</b></td>
                        <td  ><b>Entrega</b></td>
                        <td  ><b>Salidas</b></td>
                        <td  ><b>Fecha Inicial de <br/> Salidas</b></td>
                        <td  ><b>Devoluciones</b></td>
                        <td  ><b>Ingresos APT</b></td>
                    </tr>
                </thead>
                <tbody>

                <%
                /*
                String consulta = " SELECT CP.nombre_prod_semiterminado,IDAC.COD_LOTE_PRODUCCION,IA.NRO_INGRESOACOND,IDAC.CANT_INGRESO_PRODUCCION,IA.fecha_ingresoacond " +
                        " FROM PROGRAMA_PRODUCCION PPR  INNER JOIN INGRESOS_DETALLEACOND IDAC ON IDAC.COD_LOTE_PRODUCCION = PPR.COD_LOTE_PRODUCCION AND IDAC.COD_COMPPROD =PPR.COD_COMPPROD " +
                        " INNER JOIN INGRESOS_ACOND IA ON IA.COD_INGRESO_ACOND = IDAC.COD_INGRESO_ACOND " +
                        " INNER JOIN COMPONENTES_PROD CP ON PPR.COD_COMPPROD = CP.COD_COMPPROD " +
                        " WHERE PPR.COD_ESTADO_PROGRAMA in (1,2,6,7) " +
                        " AND PPR.COD_PROGRAMA_PROD = '"+codProgramaProdPeriodo+"' " +
                        " AND IA.COD_TIPOINGRESOACOND IN(1,4)  ";


                consulta = " SELECT CP.nombre_prod_semiterminado,IDA.COD_LOTE_PRODUCCION,IA.NRO_INGRESOACOND,IDA.CANT_INGRESO_PRODUCCION,IA.fecha_ingresoacond,A.NOMBRE_ALMACENACOND,fm.cantidad_lote,AE.NOMBRE_AREA_EMPRESA     " +
                        " FROM INGRESOS_ACOND IA INNER JOIN INGRESOS_DETALLEACOND IDA ON IA.COD_INGRESO_ACOND = IDA.COD_INGRESO_ACOND " +
                        " INNER JOIN COMPONENTES_PROD CP ON CP.COD_COMPPROD = IDA.COD_COMPPROD " +
                        " INNER JOIN ALMACENES_ACOND A ON A.COD_ALMACENACOND = IA.COD_ALMACENACOND " +
                        " INNER JOIN FORMULA_MAESTRA FM ON FM.COD_COMPPROD = CP.COD_COMPPROD " +
                        " INNER JOIN AREAS_EMPRESA AE ON AE.COD_AREA_EMPRESA=CP.COD_AREA_EMPRESA " +
                        " WHERE IA.COD_ESTADO_INGRESOACOND IN (1,4) AND IA.COD_TIPOINGRESOACOND=1 " +
                        " AND FM.COD_ESTADO_REGISTRO = 1 " ;
                        if(!codProgramaProdPeriodo.equals("-1")){
                        consulta = consulta + " AND  IDA.COD_LOTE_PRODUCCION IN (SELECT PPR.COD_LOTE_PRODUCCION FROM PROGRAMA_PRODUCCION PPR WHERE PPR.COD_PROGRAMA_PROD = "+codProgramaProdPeriodo+" " +
                        " AND PPR.COD_ESTADO_PROGRAMA IN (1,2,6,7))  " ;
                        }
                        consulta = consulta + " AND IA.fecha_ingresoacond >='"+arrayFechaInicial[2]+"/" +arrayFechaInicial[1] + "/" + arrayFechaInicial[0]+" 00:00:00' " +
                                " AND IA.fecha_ingresoacond<='"+arrayFechaFinal[2]+"/" +arrayFechaFinal[1] + "/" + arrayFechaFinal[0]+" 23:59:59'" ;
                        
                 consulta = " SELECT CP.nombre_prod_semiterminado, IDA.COD_LOTE_PRODUCCION, IA.NRO_INGRESOACOND, IDA.CANT_INGRESO_PRODUCCION,  IA.fecha_ingresoacond, " +
                         " A.NOMBRE_ALMACENACOND, fm.cantidad_lote, AE.NOMBRE_AREA_EMPRESA,cp.VIDA_UTIL,IDA.FECHA_VEN, (SELECT S.FECHA_INICIO FROM SEGUIMIENTO_PROGRAMA_PRODUCCION S " +
                         " inner join ACTIVIDADES_FORMULA_MAESTRA a on a.COD_FORMULA_MAESTRA = s.COD_FORMULA_MAESTRA and a.COD_ACTIVIDAD_FORMULA = s.COD_ACTIVIDAD_PROGRAMA " +
                         " WHERE S.COD_LOTE_PRODUCCION = IDA.COD_LOTE_PRODUCCION AND S.COD_FORMULA_MAESTRA = FM.COD_FORMULA_MAESTRA  " +
                         " AND S.COD_COMPPROD = CP.COD_COMPPROD AND a.COD_ACTIVIDAD = 76 "+(!codProgramaProdPeriodo.equals("-1")?"AND S.COD_PROGRAMA_PROD = '"+codProgramaProdPeriodo+"'":"") +" ) FECHA_PESAJE " +
                         " FROM INGRESOS_ACOND IA " +
                         " INNER JOIN INGRESOS_DETALLEACOND IDA ON IA.COD_INGRESO_ACOND = IDA.COD_INGRESO_ACOND " +
                         " INNER JOIN COMPONENTES_PROD CP ON CP.COD_COMPPROD = IDA.COD_COMPPROD " +
                         " INNER JOIN ALMACENES_ACOND A ON A.COD_ALMACENACOND = IA.COD_ALMACENACOND " +
                         " INNER JOIN FORMULA_MAESTRA FM ON FM.COD_COMPPROD = CP.COD_COMPPROD " +
                         " INNER JOIN AREAS_EMPRESA AE ON AE.COD_AREA_EMPRESA = CP.COD_AREA_EMPRESA " +
                         " WHERE IA.COD_ESTADO_INGRESOACOND IN (1, 4) AND " +
                         " IA.COD_TIPOINGRESOACOND = 1 AND FM.COD_ESTADO_REGISTRO = 1 ";
                         if(!codProgramaProdPeriodo.equals("-1")){
                             consulta = consulta + " AND IDA.COD_LOTE_PRODUCCION IN (SELECT PPR.COD_LOTE_PRODUCCION FROM PROGRAMA_PRODUCCION PPR " +
                         " WHERE PPR.COD_PROGRAMA_PROD = '"+codProgramaProdPeriodo+"' AND PPR.COD_ESTADO_PROGRAMA IN (1, 2, 6, 7) ) " ;
                         }
                         consulta = consulta + " AND IA.fecha_ingresoacond >='"+arrayFechaInicial[2]+"/" +arrayFechaInicial[1] + "/" + arrayFechaInicial[0]+" 00:00:00' " +
                                " AND IA.fecha_ingresoacond<='"+arrayFechaFinal[2]+"/" +arrayFechaFinal[1] + "/" + arrayFechaFinal[0]+" 23:59:59'" ;*/
                 String consulta = " select cp.COD_FORMA,cp.nombre_prod_semiterminado,pprp.COD_PROGRAMA_PROD,pprp.NOMBRE_PROGRAMA_PROD,ppr.COD_LOTE_PRODUCCION,ppr.cod_compprod," +
                                        "(select top 1 sppr.FECHA_INICIO  from seguimiento_programa_produccion sppr " +
                                        "inner join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_ACTIVIDAD_FORMULA = sppr.COD_ACTIVIDAD_PROGRAMA" +
                                        " and afm.COD_FORMULA_MAESTRA = sppr.COD_FORMULA_MAESTRA " +
                                        " where sppr.COD_PROGRAMA_PROD = ppr.COD_PROGRAMA_PROD " +
                                        " and sppr.COD_COMPPROD = ppr.COD_COMPPROD " +
                                        " and sppr.COD_FORMULA_MAESTRA = ppr.COD_FORMULA_MAESTRA " +
                                        " and sppr.COD_LOTE_PRODUCCION = ppr.COD_LOTE_PRODUCCION " +
                                        " and sppr.COD_TIPO_PROGRAMA_PROD = ppr.COD_TIPO_PROGRAMA_PROD " +
                                        " and afm.COD_ACTIVIDAD  in (76,186) ) fecha_inicio, " +
                                        " dateadd(MONTH,cp.VIDA_UTIL,(select top 1 sppr.FECHA_INICIO  from seguimiento_programa_produccion sppr  " +
                                        " inner join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_ACTIVIDAD_FORMULA = sppr.COD_ACTIVIDAD_PROGRAMA " +
                                        " and afm.COD_FORMULA_MAESTRA = sppr.COD_FORMULA_MAESTRA " +
                                        " where sppr.COD_PROGRAMA_PROD = ppr.COD_PROGRAMA_PROD " +
                                        " and sppr.COD_COMPPROD = ppr.COD_COMPPROD " +
                                        " and sppr.COD_FORMULA_MAESTRA = ppr.COD_FORMULA_MAESTRA " +
                                        " and sppr.COD_LOTE_PRODUCCION = ppr.COD_LOTE_PRODUCCION " +
                                        " and sppr.COD_TIPO_PROGRAMA_PROD = ppr.COD_TIPO_PROGRAMA_PROD " +
                                        " and afm.COD_ACTIVIDAD in(76,186) )) fecha_vencimiento,e.nombre_estado_programa_prod,ppr.cant_lote_produccion,(select  " +
                                        " sum( ida.cant_ingreso_produccion) from programa_produccion_ingresos_acond ppria inner join ingresos_detalleacond ida " +
                                        " on ida.cod_ingreso_acond = ppria.cod_ingreso_acond and ida.cod_lote_produccion = ppria.cod_lote_produccion and ida.cod_compprod = ppria.cod_compprod" +
                                        " inner join ingresos_acond ia on ia.cod_ingreso_acond = ida.cod_ingreso_acond " +
                                        " where ppria.cod_programa_prod = ppr.cod_programa_prod and ppria.cod_compprod = ppr.cod_compprod " +
                                        " and ppria.cod_lote_produccion = ppr.cod_lote_produccion " +
                                        " and ppria.cod_tipo_programa_prod = ppr.cod_tipo_programa_prod " +
                                        " and ppria.cod_formula_maestra = ppr.cod_formula_maestra and ia.cod_almacenacond in (1,3) and ia.cod_tipoingresoacond = 1 and ia.cod_estado_ingresoacond not in(2)) cant_ingreso_produccion1," +
                                        " (select sum(iad.CANT_INGRESO_PRODUCCION) from INGRESOS_ACOND ia inner join INGRESOS_DETALLEACOND iad on iad.COD_INGRESO_ACOND = ia.COD_INGRESO_ACOND " +
                                        " where iad.COD_LOTE_PRODUCCION = ppr.cod_lote_produccion and iad.COD_COMPPROD = ppr.cod_compprod and ia.COD_TIPOINGRESOACOND = 1 and ia.COD_ALMACENACOND in (1,3) and ia.cod_estado_ingresoacond not in(1,2)) cant_ingreso_produccion" +
                                        " ,( select top 1 s.FECHA_SALIDA_ALMACEN from SALIDAS_ALMACEN s       where s.COD_PROD = ppr.COD_COMPPROD and s.COD_LOTE_PRODUCCION = ppr.COD_LOTE_PRODUCCION and" +
                                        " s.COD_ESTADO_SALIDA_ALMACEN = 1 and s.ESTADO_SISTEMA = 1 and s.cod_almacen in (1, 2) order by s.FECHA_SALIDA_ALMACEN asc" +
                                        " ) fecha_salida_almacen,t.nombre_tipo_programa_prod,t.cod_tipo_programa_prod,(" +
                                        " select SUM(sd.CANT_TOTAL_SALIDADETALLEACOND)"+
                                         " from SALIDAS_ACOND sa inner join SALIDAS_DETALLEACOND sd on"+
                                         " sa.COD_SALIDA_ACOND=sd.COD_SALIDA_ACOND"+
                                         " where sa.COD_ALMACEN_VENTA in (case when t.COD_TIPO_PROGRAMA_PROD=1 then 54 else 0 end," +
                                         " case when t.COD_TIPO_PROGRAMA_PROD=2 then 56 else 0 end," +
                                         " case when t.COD_TIPO_PROGRAMA_PROD=3 then 57 else 0 end)"+ //select av.COD_ALMACEN_VENTA from ALMACENES_VENTAS av where av.COD_AREA_EMPRESA=1
                                         " and sd.COD_LOTE_PRODUCCION=ppr.cod_lote_produccion and sd.COD_COMPPROD=ppr.cod_compprod and "+
                                         " sa.COD_ESTADO_SALIDAACOND not in (2)) cantidadEnviadaAPT,(select top 1 t.nombre_tipo_entrega_acond from programa_produccion_ingresos_acond ppria inner join tipos_entrega_acond t on t.cod_tipo_entrega_acond = ppria.cod_tipo_entrega_acond where ppria.cod_compprod = ppr.cod_compprod and ppria.cod_formula_maestra = ppr.cod_formula_maestra and ppria.cod_lote_produccion = ppr.cod_lote_produccion and ppr.cod_tipo_programa_prod = ppria.cod_tipo_programa_prod order by ppria.cod_ingreso_acond desc) nombre_tipo_entrega_acond" +
                                 " from programa_produccion ppr"+
                                        " inner join PROGRAMA_PRODUCCION_PERIODO pprp on pprp.COD_PROGRAMA_PROD = ppr.COD_PROGRAMA_PROD " +
                                        " inner join COMPONENTES_PROD cp on cp.COD_COMPPROD = ppr.COD_COMPPROD " +
                                        " inner join estados_programa_produccion e on e.cod_estado_programa_prod = ppr.cod_estado_programa" +
                                        " inner join tipos_programa_produccion t on t.cod_tipo_programa_prod = ppr.cod_tipo_programa_prod " +
                                 " where ppr.COD_ESTADO_PROGRAMA = '"+codEstadoProgramaProd+"' "+(!codProgramaProdPeriodo.equals("-1")?" and pprp.cod_programa_prod in("+codProgramaProdPeriodo+")":"")+
                                 " order by cp.nombre_prod_semiterminado, ppr.COD_PROGRAMA_PROD";
                
                System.out.println("consulta"+consulta);
                con = Util.openConnection(con);
                Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet rs=st.executeQuery(consulta);
                int cont = 1;
                
                
                while (rs.next()){
                    StringBuilder consulta1=new StringBuilder(" exec PAA_LISTAR_FECHA_VENCIMIENTO_LOTE ")
                                                        .append("'").append(rs.getString("COD_LOTE_PRODUCCION")).append("',")//lote
                                                        .append(rs.getInt("COD_PROGRAMA_PROD")).append(",")//programa
                                                        .append(rs.getInt("cod_compprod")).append(",")//producto
                                                        .append(rs.getInt("COD_FORMA")).append(",")//forma farmaceutica
                                                        .append("?,")//mensaje
                                                        .append("?,")//fecha vencimiento
                                                        .append("?");//fecha pesaje
                    CallableStatement callFechaVencimiento=con.prepareCall(consulta1.toString());
                    callFechaVencimiento.registerOutParameter(1,java.sql.Types.VARCHAR);
                    callFechaVencimiento.registerOutParameter(2,java.sql.Types.TIMESTAMP);
                    callFechaVencimiento.registerOutParameter(3,java.sql.Types.TIMESTAMP);
                    callFechaVencimiento.execute();
                    Date fechaVencimiento = callFechaVencimiento.getTimestamp(2);
                    String nombreProdSemiterminado = rs.getString("nombre_prod_semiterminado");
                    int codCompprod = rs.getInt("cod_compprod");
                    String nombreProgramaProd = rs.getString("NOMBRE_PROGRAMA_PROD");
                    String codLoteProduccion = rs.getString("COD_LOTE_PRODUCCION");
                    Date fechaInicio = rs.getDate("FECHA_INICIO");
                    
                    String nombreEstadoProgramaProd = rs.getString("nombre_estado_programa_prod");
                    double cantLoteProduccion = rs.getDouble("cant_lote_produccion");
                    double cantIngresoProduccion = rs.getDouble("cant_ingreso_produccion");
                    double cantEnviadaAcond = rs.getDouble("cant_ingreso_produccion1");
                    double cantEnviadaApt = rs.getDouble("cantidadEnviadaAPT");
                    Date fechaInicialSalidas = rs.getDate("fecha_salida_almacen");
                    String nombreTipoProgramaProd = rs.getString("nombre_tipo_programa_prod");
                    int codTipoProgramaProd = rs.getInt("cod_tipo_programa_prod");
                    String nombreTipoEntregaAcond = rs.getString("nombre_tipo_entrega_acond");

                    out.print("<tr>");
                    out.print("<td >"+cont+"</td>");
                    out.print("<td >"+nombreProdSemiterminado+"</td>");
                    out.print("<td >"+nombreTipoProgramaProd+"</td>");
                    out.print("<td >"+nombreProgramaProd+"</td>");
                    out.print("<td >"+codLoteProduccion+"</td>");
                    out.print("<td >"+(fechaInicio!=null?sdf.format(fechaInicio):"")+"</td>");
                    out.print("<td >"+(fechaVencimiento!=null?sdf.format(fechaVencimiento):"") +"</td>");
                    out.print("<td >"+nombreEstadoProgramaProd +"</td>");
                    out.print("<td >"+format.format(cantLoteProduccion) +"</td>");
                    out.print("<td >"+ format.format(cantEnviadaAcond)+"</td>");
                    out.print("<td >"+ format.format(cantLoteProduccion-cantEnviadaAcond)+"</td>");
                    out.print("<td >"+format.format(cantIngresoProduccion) +"</td>");
                    out.print("<td >"+format.format(cantEnviadaApt) +"</td>");
                    out.print("<td >"+(nombreTipoEntregaAcond!=null?nombreTipoEntregaAcond:"")+"</td>");
                    
                    out.print("<td class='bordeNegroTd'>");
                    consulta = " select s.NRO_SALIDA_ALMACEN,s.cod_salida_almacen from SALIDAS_ALMACEN s where s.COD_PROD = '"+codCompprod+"' and s.COD_LOTE_PRODUCCION = '"+codLoteProduccion+"' and s.COD_ESTADO_SALIDA_ALMACEN = 1 and s.ESTADO_SISTEMA=1 and s.cod_almacen in (1,2) ";
                    System.out.println("consulta " + consulta);
                    Statement st1=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet rs1 = st1.executeQuery(consulta);
                    //out.print("<table>");
                    String nroSalida = "";
                    while(rs1.next()){
                        int codSalidaAlmacen = rs1.getInt("cod_salida_almacen");
                        nroSalida=nroSalida + "<a href='#' onclick=\"openPopup('navegadorDetalleSalidasAlmacen.jsf?codSalidaAlmacen="+codSalidaAlmacen+"');return false\" class='outputText1'>"+rs1.getInt("nro_salida_almacen")+"</a> ";
                    }
                    //out.print("</table>");
                    out.print(nroSalida);
                    out.print("</td>");
                    
                    out.print("<td >"+(fechaInicialSalidas!=null?sdf.format(fechaInicialSalidas):"")+"</td>");
                    out.print("<td class='bordeNegroTd'>");
                    consulta = " select d.COD_DEVOLUCION,d.NRO_DEVOLUCION from SALIDAS_ALMACEN s inner join devoluciones d on d.COD_SALIDA_ALMACEN = s.COD_SALIDA_ALMACEN" +
                            " where s.COD_PROD = '"+codCompprod+"' and s.COD_LOTE_PRODUCCION = '"+codLoteProduccion+"' and s.COD_ESTADO_SALIDA_ALMACEN = 1 " +
                            " and s.ESTADO_SISTEMA = 1 and s.cod_almacen in (1, 2) ";
                    System.out.println("consulta " + consulta);
                    Statement st2=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet rs2 = st2.executeQuery(consulta);
                    //out.print("<table>");
                    String nroDevolucion = "";
                    int codDevolucion = 0;
                    while(rs2.next()){
                        codDevolucion = rs2.getInt("cod_devolucion");
                        nroDevolucion=nroDevolucion + "<a href='#' onclick=\"openPopup('reporteDevolucionesAlmacen.jsf?codDevolucion="+codDevolucion+"');return false\" class='outputText1'>"+rs2.getInt("nro_devolucion")+"</a> ";
                    }
                    //out.print("</table>");
                    out.print(nroDevolucion);
                    out.print("</td>");
                    int codAlmacenVenta = 0;
                    codAlmacenVenta = codTipoProgramaProd ==1?54:codAlmacenVenta;
                    codAlmacenVenta = codTipoProgramaProd ==2?56:codAlmacenVenta;
                    codAlmacenVenta = codTipoProgramaProd ==3?57:codAlmacenVenta;
                    consulta = " select i.NRO_INGRESOVENTAS, i.COD_INGRESOVENTAS" +
                            " from INGRESOS_VENTAS i, INGRESOS_DETALLEVENTAS id, ALMACENES_VENTAS a, PRESENTACIONES_PRODUCTO p" +
                            " where i.COD_INGRESOVENTAS= id.COD_INGRESOVENTAS and i.COD_AREA_EMPRESA=id.COD_AREA_EMPRESA and" +
                            " i.COD_AREA_EMPRESA=1 and i.COD_ALMACEN_VENTA = '"+codAlmacenVenta+"' and id.COD_LOTE_PRODUCCION='"+codLoteProduccion+"' and" +
                            " p.cod_presentacion=id.COD_PRESENTACION and a.COD_ALMACEN_VENTA=i.COD_ALMACEN_VENTA; ";
                    out.print("<td class='bordeNegroTd'>");
                    System.out.println("consulta " + consulta);
                    Statement st3=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet rs3 = st3.executeQuery(consulta);
                    //out.print("<table>");
                    String nroIngresoAPT = "";
                    int codIngresoAPT = 0;
                    while(rs3.next()){
                        codIngresoAPT = rs3.getInt("COD_INGRESOVENTAS");
                        nroIngresoAPT=nroIngresoAPT + "<a href='#' onclick=\"openPopup1('reporteIngresosAPT.jsf?codIngresoAPT="+codIngresoAPT+"&codLoteProduccion="+codLoteProduccion+"',250);return false\" class='outputText1'>"+rs3.getInt("NRO_INGRESOVENTAS")+"</a> ";
                    }
                    //out.print("</table>");
                    out.print(nroIngresoAPT);
                    out.print("</td>");
                    out.print("</tr>");
                    cont++;
                    }
                
                }catch(Exception e){
                e.printStackTrace();
                }
                %>
               </tbody>
            </table>
            
            
            
        </form>
    </body>
</html>