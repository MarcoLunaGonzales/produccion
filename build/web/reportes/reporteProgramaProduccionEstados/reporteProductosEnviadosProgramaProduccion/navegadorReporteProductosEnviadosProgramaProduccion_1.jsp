package reportes.reporteProductosEnviadosProgramaProduccion;

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
<%! Connection con=null;


%>
<%! public String nombrePresentacion1(String codPresentacion){
    

 
String  nombreproducto="";

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
    </head>
    <body>
        <h3 align="center">Reporte de Productos Enviados a Acondicionamiento</h3>
        <br>
        <form>
            <table align="center" width="90%">

                <%
                try{
                NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
                DecimalFormat format = (DecimalFormat)nf;
                format.applyPattern("#,###.00");



                    String codProgramaProdPeriodo=request.getParameter("codProgramaProdPeriodo")==null?"0":request.getParameter("codProgramaProdPeriodo");
                    String nombreProgramaProdPeriodo=request.getParameter("nombreProgramaProduccion")==null?"0":request.getParameter("nombreProgramaProduccion");
                    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
                    String fechaInicial=request.getParameter("fechaInicial")==null?"0":request.getParameter("fechaInicial");
                    String fechaFinal=request.getParameter("fechaFinal")==null?"0":request.getParameter("fechaFinal");
                    
                    String[] arrayFechaInicial = fechaInicial.split("/");
                    String[] arrayFechaFinal = fechaFinal.split("/");
                    
                %>
                <table align="center" width="60%" class='outputText0'>
                <tr>
                    <td width="10%">
                        <img src="../../img/cofar.png">
                    </td>
                <td align="center" width="80%">
                <br>
                    Programa Produccion : <b><%=nombreProgramaProdPeriodo%></b>
                    <br><br>
                    Fecha Inicial : <b><%=fechaInicial%></b>
                    <br><br>
                    Fecha Final : <b><%=fechaFinal%></b>

                </td>
                <td align="center" >
                </td>
                </tr>
            </table>
            </table>
            <br>
            <br>
            <br>
            <table  align="center" width="60%" class="outputText2" style="border : solid #f2f2f2 1px;" cellpadding="0" cellspacing="0">

                <tr class="tablaFiltroReporte">
                    <td  align="center" class="bordeNegroTd" width="20%" ><b>Programa Produccion</b></td>
                    <td  align="center" class="bordeNegroTd" width="20%" ><b>Producto</b></td>
                    <td  align="center" class="bordeNegroTd"><b>Lote</b></td>
                    <td  align="center" class="bordeNegroTd"><b>Cantidad Lote</b></td>

                    <td  align="center" class="bordeNegroTd" width="5%"><b>Nro de ingreso Acond.</b></td>
                    <td  align="center" class="bordeNegroTd"><b>Cantidad Ingreso Acond.</b></td>
                    <td  align="center" class="bordeNegroTd" width="10%"><b>Rendimiento de Produccion</b></td>


                    <td  align="center" class="bordeNegroTd" width="10%"><b>Fecha de Ingreso Acond.</b></td>
                    <td  align="center" class="bordeNegroTd" ><b>Almacen Acondicionamiento</b></td>
                    <td  align="center" class="bordeNegroTd" ><b>Area</b></td>
                    <td  align="center" class="bordeNegroTd" ><b>Fecha Pesaje</b></td>
                    <td  align="center" class="bordeNegroTd" ><b>Vida Util</b></td>
                    <td  align="center" class="bordeNegroTd" ><b>Fecha Vencimiento</b></td>
                </tr>

                <%
                
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
                                " AND IA.fecha_ingresoacond<='"+arrayFechaFinal[2]+"/" +arrayFechaFinal[1] + "/" + arrayFechaFinal[0]+" 23:59:59'" ;
                  consulta =" SELECT pprp.NOMBRE_PROGRAMA_PROD,ppr.COD_PROGRAMA_PROD,CP.nombre_prod_semiterminado, IDA.COD_LOTE_PRODUCCION, " +
                          "IA.NRO_INGRESOACOND, IDA.CANT_INGRESO_PRODUCCION, IA.fecha_ingresoacond," +
                          " A.NOMBRE_ALMACENACOND,       fm.cantidad_lote,       AE.NOMBRE_AREA_EMPRESA,       cp.VIDA_UTIL,   IDA.FECHA_VEN," +
                          "(    SELECT top 1 S.FECHA_INICIO         FROM SEGUIMIENTO_PROGRAMA_PRODUCCION S              " +
                          " inner join ACTIVIDADES_FORMULA_MAESTRA a on a.COD_FORMULA_MAESTRA = s.COD_FORMULA_MAESTRA " +
                          " and a.COD_ACTIVIDAD_FORMULA =             s.COD_ACTIVIDAD_PROGRAMA " +
                          " WHERE S.COD_LOTE_PRODUCCION = IDA.COD_LOTE_PRODUCCION " +
                          " AND S.COD_FORMULA_MAESTRA = FM.COD_FORMULA_MAESTRA AND S.COD_COMPPROD = CP.COD_COMPPROD " +
                          " AND a.COD_ACTIVIDAD = 76 and s.COD_TIPO_PROGRAMA_PROD = ppr.COD_TIPO_PROGRAMA_PROD ) FECHA_PESAJE " +
                          " FROM PROGRAMA_PRODUCCION_INGRESOS_ACOND ppria  " +
                          " inner join PROGRAMA_PRODUCCION ppr on ppr.COD_PROGRAMA_PROD = ppria.COD_PROGRAMA_PROD and ppr.COD_COMPPROD = ppria.COD_COMPPROD  " +
                          " and ppr.COD_FORMULA_MAESTRA = ppria.COD_FORMULA_MAESTRA and ppr.COD_LOTE_PRODUCCION = ppria.COD_LOTE_PRODUCCION and ppria.cod_tipo_programa_prod = ppr.cod_tipo_programa_prod " +
                          " inner join INGRESOS_ACOND IA on ia.COD_INGRESO_ACOND = ppria.COD_INGRESO_ACOND " +
                          "  INNER JOIN INGRESOS_DETALLEACOND IDA ON IA.COD_INGRESO_ACOND = IDA.COD_INGRESO_ACOND " +
                          " INNER JOIN COMPONENTES_PROD CP ON CP.COD_COMPPROD = IDA.COD_COMPPROD " +
                          " INNER JOIN ALMACENES_ACOND A ON A.COD_ALMACENACOND = IA.COD_ALMACENACOND " +
                          " INNER JOIN FORMULA_MAESTRA FM ON FM.COD_COMPPROD = CP.COD_COMPPROD and fm.cod_formula_maestra = ppr.cod_formula_maestra" +
                          " INNER JOIN AREAS_EMPRESA AE ON AE.COD_AREA_EMPRESA = CP.COD_AREA_EMPRESA " +
                          " inner join PROGRAMA_PRODUCCION_PERIODO pprp on pprp.COD_PROGRAMA_PROD = ppr.COD_PROGRAMA_PROD " +
                          " WHERE IA.COD_ESTADO_INGRESOACOND IN (1, 4) AND IA.COD_TIPOINGRESOACOND = 1 " +
                          " AND FM.COD_ESTADO_REGISTRO = 1  ";
                  if(!codProgramaProdPeriodo.equals("-1")){
                             consulta = consulta + " and pprp.cod_programa_prod = '"+codProgramaProdPeriodo+"' " ;
                         }
                  consulta = consulta + " AND IA.fecha_ingresoacond >='"+arrayFechaInicial[2]+"/" +arrayFechaInicial[1] + "/" + arrayFechaInicial[0]+" 00:00:00' " +
                                " AND IA.fecha_ingresoacond<='"+arrayFechaFinal[2]+"/" +arrayFechaFinal[1] + "/" + arrayFechaFinal[0]+" 23:59:59'" ;

                System.out.println("consulta"+consulta);
                con = Util.openConnection(con);                            
                Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet rs=st.executeQuery(consulta);

                while (rs.next()){
                    String nombreProgramaProd = rs.getString("nombre_programa_prod");
                    String nombreProdSemiterminado = rs.getString("nombre_prod_semiterminado");
                    String codLoteProduccion= rs.getString("COD_LOTE_PRODUCCION");
                    String nroIngresoAcond = rs.getString("NRO_INGRESOACOND");
                    float cantIngresoProduccion = rs.getFloat("CANT_INGRESO_PRODUCCION");
                    String fechaIngresoAcond=rs.getString("fecha_ingresoacond");
                    String almacenAcond = rs.getString("NOMBRE_ALMACENACOND");
                    String[] arrayFechaIngresoAcond = fechaIngresoAcond.split(" ");
                    fechaIngresoAcond= arrayFechaIngresoAcond[0];
                    arrayFechaIngresoAcond = fechaIngresoAcond.split("-");
                    float cantidadLote = rs.getFloat("cantidad_lote");
                    String nombreAreaEmpresa= rs.getString("NOMBRE_AREA_EMPRESA");
                    Date fechaPesaje = rs.getDate("FECHA_PESAJE");
                    String vidaUtil = rs.getString("VIDA_UTIL");
                    Date fechaVencimiento = rs.getDate("FECHA_VEN");



                    out.print("<tr>");
                    out.print("<td class='bordeNegroTd' align='left'>"+nombreProgramaProd+"</td>");
                    out.print("<td class='bordeNegroTd' align='left'>"+nombreProdSemiterminado+"</td>");
                    out.print("<td class='bordeNegroTd' align='left'>"+codLoteProduccion+"</td>");
                    out.print("<td class='bordeNegroTd' align='left'>"+format.format(cantidadLote)+"</td>");
                    out.print("<td class='bordeNegroTd' align='left'>"+nroIngresoAcond+"</td>");
                    out.print("<td class='bordeNegroTd' align='left'>"+format.format(cantIngresoProduccion) +"</td>");
                    out.print("<td class='bordeNegroTd' align='left'>"+format.format((cantIngresoProduccion/cantidadLote)*100) +"%</td>");
                    out.print("<td class='bordeNegroTd' align='left'>"+arrayFechaIngresoAcond[2]+"/"+arrayFechaIngresoAcond[1]+"/"+arrayFechaIngresoAcond[0] +"</td>");
                    out.print("<td class='bordeNegroTd' align='left'>"+almacenAcond+"</td>");
                    out.print("<td class='bordeNegroTd' align='left'>"+nombreAreaEmpresa+"</td>");
                    out.print("<td class='bordeNegroTd' align='left'>"+(fechaPesaje==null?"":sdf.format( fechaPesaje))+"</td>");
                    out.print("<td class='bordeNegroTd' align='left'>"+(vidaUtil==null?"":vidaUtil)+"</td>");
                    out.print("<td class='bordeNegroTd' align='left'>"+(fechaVencimiento==null?"":sdf.format(fechaVencimiento))+"</td>");


                    out.print("</tr>");
                    }

             

                
                }catch(Exception e){
                e.printStackTrace();
                }
                %>
               
            </table>
            
            
            
        </form>
    </body>
</html>