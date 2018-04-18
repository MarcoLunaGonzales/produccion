<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ page language="java" %>
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


<%! Connection con = null;
String codPresentacion = "";
String nombrePresentacion = "";
String linea_mkt = "";
String agenciaVenta = "";
%>
<%! public String nombrePresentacion1() {



    String nombreproducto = "";
//ManagedAccesoSistema bean1=(ManagedAccesoSistema)com.cofar.util.Util.getSessionBean("ManagedAccesoSistema");
    try {
        con = Util.openConnection(con);
        String sql_aux = "select cod_presentacion, nombre_producto_presentacion from presentaciones_producto where cod_presentacion='" + codPresentacion + "'";
        System.out.println("PresentacionesProducto:sql:" + sql_aux);
        Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        ResultSet rs = st.executeQuery(sql_aux);
        while (rs.next()) {
            String codigo = rs.getString(1);
            nombreproducto = rs.getString(2);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return nombreproducto;
}

public Double[] sumaRegistroMaquinarias(int codCompProd,String fechaInicial,String FechaFinal,int codActividadFormula) {

Double[] sumaRegistros =  new Double[3];
    
//ManagedAccesoSistema bean1=(ManagedAccesoSistema)com.cofar.util.Util.getSessionBean("ManagedAccesoSistema");
    try {
        con = Util.openConnection(con);
        String consulta = " select sum(REGISTRO_HORAS_HOMBRE) REGISTRO_HORAS_HOMBRE,sum(REGISTRO_HORAS_MAQUINA) REGISTRO_HORAS_MAQUINA FROM " +
                " ( select m.NOMBRE_MAQUINA,sppr.HORAS_HOMBRE,sppr.HORAS_MAQUINA,(CASE WHEN CAST(sppr.HORAS_HOMBRE AS FLOAT)>0 THEN 1 ELSE 0 END) REGISTRO_HORAS_HOMBRE, " +
                " (CASE WHEN CAST(sppr.HORAS_MAQUINA AS FLOAT)>0 THEN 1 ELSE 0 END) REGISTRO_HORAS_MAQUINA " +
                " from PROGRAMA_PRODUCCION ppr inner join FORMULA_MAESTRA fm on fm.COD_FORMULA_MAESTRA = ppr.COD_FORMULA_MAESTRA " +
                " inner join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_FORMULA_MAESTRA = fm.COD_FORMULA_MAESTRA " +
                " inner join MAQUINARIA_ACTIVIDADES_FORMULA maf on maf.COD_ACTIVIDAD_FORMULA = afm.COD_ACTIVIDAD_FORMULA " +
                " inner join MAQUINARIAS m on m.COD_MAQUINA = maf.COD_MAQUINA " +
                " inner join SEGUIMIENTO_PROGRAMA_PRODUCCION sppr on sppr.COD_PROGRAMA_PROD = ppr.COD_PROGRAMA_PROD " +
                " and sppr.COD_LOTE_PRODUCCION = ppr.COD_LOTE_PRODUCCION  and sppr.COD_COMPPROD = ppr.COD_COMPPROD " +
                " and sppr.COD_FORMULA_MAESTRA = ppr.COD_FORMULA_MAESTRA and sppr.COD_MAQUINA = maf.COD_MAQUINA " +
                " and sppr.COD_ACTIVIDAD_PROGRAMA = afm.COD_ACTIVIDAD_FORMULA where maf.COD_ACTIVIDAD_FORMULA = "+codActividadFormula+" " +
                " AND PPR.COD_ESTADO_PROGRAMA IN (2,5,6)   " +
                " and sppr.FECHA_INICIO>='"+fechaInicial+" 00:00:00'  and  sppr.FECHA_FINAL<= '"+FechaFinal+" 23:59:59'" +
                " and ppr.COD_PROGRAMA_PROD in (select s.COD_PROGRAMA_PROD from SEGUIMIENTO_PROGRAMA_PRODUCCION s where s.COD_COMPPROD = ppr.COD_COMPPROD   " +
                " and s.COD_FORMULA_MAESTRA = fm.COD_FORMULA_MAESTRA and  s.COD_LOTE_PRODUCCION = ppr.COD_LOTE_PRODUCCION    " +
                " and s.FECHA_INICIO>='"+fechaInicial+" 00:00:00'  and  s.FECHA_FINAL<= '"+FechaFinal+" 23:59:59') " +
                " and ppr.COD_COMPPROD = "+codCompProd+" union all " +
                " select '',sppr.HORAS_HOMBRE,sppr.HORAS_MAQUINA,(CASE WHEN CAST(sppr.HORAS_HOMBRE AS FLOAT)>0 THEN 1 ELSE 0 END) REGISTRO_HORAS_HOMBRE, " +
                " (CASE WHEN CAST(sppr.HORAS_MAQUINA AS FLOAT)>0 THEN 1 ELSE 0 END) REGISTRO_HORAS_MAQUINA " +
                " from PROGRAMA_PRODUCCION ppr  " +
                " inner join FORMULA_MAESTRA fm on fm.COD_FORMULA_MAESTRA = ppr.COD_FORMULA_MAESTRA " +
                " inner join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_FORMULA_MAESTRA = fm.COD_FORMULA_MAESTRA " +
                " inner join SEGUIMIENTO_PROGRAMA_PRODUCCION sppr on sppr.COD_PROGRAMA_PROD = ppr.COD_PROGRAMA_PROD " +
                " and sppr.COD_FORMULA_MAESTRA = ppr.COD_FORMULA_MAESTRA and sppr.COD_COMPPROD = ppr.COD_COMPPROD " +
                " and sppr.COD_LOTE_PRODUCCION = ppr.COD_LOTE_PRODUCCION AND sppr.COD_ACTIVIDAD_PROGRAMA = afm.COD_ACTIVIDAD_FORMULA " +
                " where sppr.FECHA_INICIO>='"+fechaInicial+" 00:00:00'  and  sppr.FECHA_FINAL<= '"+FechaFinal+" 23:59:59' and sppr.COD_ACTIVIDAD_PROGRAMA = "+codActividadFormula+" " +
                " and ppr.COD_ESTADO_PROGRAMA IN (2,5,6) and (sppr.COD_MAQUINA = '' or sppr.cod_maquina =0 or sppr.COD_MAQUINA is null) " +
                " and ppr.COD_PROGRAMA_PROD in (select s.COD_PROGRAMA_PROD from SEGUIMIENTO_PROGRAMA_PRODUCCION s where s.COD_COMPPROD = ppr.COD_COMPPROD   " +
                " and s.COD_FORMULA_MAESTRA = fm.COD_FORMULA_MAESTRA and  s.COD_LOTE_PRODUCCION = ppr.COD_LOTE_PRODUCCION    " +
                " and s.FECHA_INICIO>='"+fechaInicial+" 00:00:00'  and  s.FECHA_FINAL<= '"+FechaFinal+" 23:59:59') and ppr.COD_COMPPROD = "+codCompProd+"  ) AS TABLA2 ";
                
        System.out.println("consulta cuenta horas" + consulta);
        Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        ResultSet rs = st.executeQuery(consulta);
        if (rs.next()) {
            sumaRegistros[1] = rs.getDouble("REGISTRO_HORAS_HOMBRE");
            sumaRegistros[2] = rs.getDouble("REGISTRO_HORAS_MAQUINA");            
        }
        System.out.println("parametros recibidos codCompProd " + codCompProd + " codActividadFormula " +codActividadFormula +  " " + sumaRegistros[1] + " " + sumaRegistros[2]);
        
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return sumaRegistros;
}


%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
        <script src="../../js/general.js"></script>
    </head>
    <body>
        <form>
            <h4 align="center">Reporte de Tiempos Promedio de Programa Produccion</h4>

                    <%
                    try {

                /*
                         <input type="hidden" name="codProgramaProduccionPeriodo">
                        <input type="hidden" name="codCompProd">
                        <input type="hidden" name="nombreCompProd">
                        */

                        NumberFormat numeroformato = NumberFormat.getNumberInstance(Locale.ENGLISH);
                        DecimalFormat formato = (DecimalFormat) numeroformato;
                        formato.applyPattern("#,###.##;(#,###.##)");

                        SimpleDateFormat f=new SimpleDateFormat("dd/MM/yyyy");

                        con = Util.openConnection(con);

                        String codAreaEmpresa=request.getParameter("codAreaEmpresa")==null?"0":request.getParameter("codAreaEmpresaP");
                        String codComponenteProd=request.getParameter("codCompProdP")==null?"0":request.getParameter("codCompProdP");
                        String codTipoActividadProduccion=request.getParameter("codTipoActividadProduccion")==null?"0":request.getParameter("codTipoActividadProduccion");

                        String fechaInicial = request.getParameter("desdeFechaP")==null?"01/01/2001":request.getParameter("desdeFechaP");
                        String fechaFinal = request.getParameter("hastaFechaP")==null?"01/01/2001":request.getParameter("hastaFechaP");

                        String[] arrayFechaInicial = fechaInicial.split("/");
                        String[] arrayFechaFinal = fechaFinal.split("/");
                        fechaInicial = arrayFechaInicial[2]+"/"+arrayFechaInicial[1]+"/"+arrayFechaInicial[0];
                        fechaFinal = arrayFechaFinal[2]+"/"+arrayFechaFinal[1]+"/"+arrayFechaFinal[0];
                        //String codFormulaMaestra=request.getParameter("codFormulaMaestra")==null?"0":request.getParameter("codFormulaMaestra");

                         //System.out.println("las fechas en el reporte" + desdeFecha + " " +hastaFecha );


                    %>
<%--
            <div class="outputText0" align="center">
                PROGRAMA PRODUCCION: <%= nombreProgramaProduccionPeriodo %> <br>
                AREA(S) : <%= arrayNombreAreaEmpresa %><br>
                DE <%= arraydesde[0] +"/"+ arraydesde[1]+"/"+arraydesde[2] %> <br>
                HASTA <%= arrayhasta[0] +"/"+ arrayhasta[1]+"/"+arrayhasta[2] %>
            </div>
--%>
            <br>
            <table width="60%" align="center" class="outputText0" style="border : solid #000000 1px;" cellpadding="0" cellspacing="0" >


                <tr class="">
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='10%' align="center" ><b>Orden</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='5%' align="center" ><b>Actividad</b></td>                    
                    <td align="center" style="border : solid #D8D8D8 1px" class="border"  bgcolor="#f2f2f2" width='5%' align="center"><b>Horas Hombre</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='10%' align="center"><b>Horas Maquina</b></td>
                    <td align="center" style="border : solid #D8D8D8 1px" class="border"  bgcolor="#f2f2f2" width='5%' align="center"><b>Horas Hombre (Standard)</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='10%' align="center"><b>Horas Maquina (Standard)</b></td>
                    
                </tr>

                <%

                String consulta=" select cp.COD_COMPPROD, cp.nombre_prod_semiterminado ,fm.cod_formula_maestra " +
                        " from COMPONENTES_PROD cp,FORMULA_MAESTRA fm where cp.cod_compprod = fm.cod_compprod " +
                        " and cp.COD_AREA_EMPRESA in ("+codAreaEmpresa+") " +
                         " and cp.COD_COMPPROD in ("+codComponenteProd+")" ;
                System.out.println("consulta 1 "+ consulta);
                con=Util.openConnection(con);
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rs = st.executeQuery(consulta);
                while (rs.next()) {
                        String nombreProductoSemiterminado = rs.getString("nombre_prod_semiterminado");
                        int codCompProd = rs.getInt("COD_COMPPROD");
                        int codFormulaMaestra = rs.getInt("cod_formula_maestra");
                %>
                <tr>
                    <td class="border"  align="left" colspan="6"><b><%=nombreProductoSemiterminado%></b></td>
                </tr>
                                <%
                                consulta = "  select ORDEN_ACTIVIDAD , COD_ACTIVIDAD_FORMULA,NOMBRE_ACTIVIDAD, " +
                                        " sum( horas_hombre) horas_hombre,sum( con_horas_hombre) con_horas_hombre, sum( horas_maquina) horas_maquina ,sum( con_horas_maquina) con_horas_maquina, " +
                                        " sum( horas_hombre1) horas_hombre1,sum( con_horas_hombre1) con_horas_hombre1, sum( horas_maquina1) horas_maquina1,sum( con_horas_maquina1) con_horas_maquina1 " +
                                        " from  ( select a.ORDEN_ACTIVIDAD , a.COD_ACTIVIDAD_FORMULA,apr.NOMBRE_ACTIVIDAD " +
                                        " ,sum(sppr.horas_hombre) horas_hombre,sum( (case when sppr.horas_hombre>0 then 1 else 0 end)) con_horas_hombre  " +
                                        " ,sum(sppr.HORAS_maquina) horas_maquina,sum((case when sppr.horas_maquina>0 then 1 else 0 end)) con_horas_maquina " +
                                        " ,sum(maf.horas_hombre) horas_hombre1,sum( (case when maf.horas_hombre>0 then 1 else 0 end)) con_horas_hombre1  " +
                                        " ,sum(maf.HORAS_maquina) horas_maquina1,sum((case when maf.horas_maquina>0 then 1 else 0 end)) con_horas_maquina1 " +
                                        " from ACTIVIDADES_FORMULA_MAESTRA a  " +
                                        " inner join MAQUINARIA_ACTIVIDADES_FORMULA maf on maf.COD_ACTIVIDAD_FORMULA = a.COD_ACTIVIDAD_FORMULA " +
                                        " inner join ACTIVIDADES_PRODUCCION apr on apr.COD_ACTIVIDAD = a.COD_ACTIVIDAD " +
                                        " left outer join SEGUIMIENTO_PROGRAMA_PRODUCCION sppr on sppr.COD_ACTIVIDAD_PROGRAMA = maf.COD_ACTIVIDAD_FORMULA " +
                                        " and (sppr.COD_MAQUINA = maf.COD_MAQUINA) " +
                                        " left outer join PROGRAMA_PRODUCCION ppr on sppr.COD_PROGRAMA_PROD = ppr.COD_PROGRAMA_PROD " +
                                        " and sppr.COD_LOTE_PRODUCCION = ppr.COD_LOTE_PRODUCCION " +
                                        " and sppr.COD_COMPPROD = ppr.COD_COMPPROD and sppr.COD_FORMULA_MAESTRA = ppr.COD_FORMULA_MAESTRA " +
                                        " and sppr.COD_TIPO_PROGRAMA_PROD = ppr.COD_TIPO_PROGRAMA_PROD AND (Sppr.HORAS_HOMBRE>0 or sppr.HORAS_MAQUINA>0) " +
                                        " AND sppr.FECHA_INICIO >='"+fechaInicial+" 00:00:00'  AND sppr.FECHA_FINAL <= '"+fechaFinal+" 23:59:59' " +
                                        " where a.COD_FORMULA_MAESTRA = '"+codFormulaMaestra+"' and apr.COD_TIPO_ACTIVIDAD_PRODUCCION = '"+codTipoActividadProduccion+"'  and apr.COD_ESTADO_REGISTRO = 1 " +
                                        " AND PPR.COD_ESTADO_PROGRAMA IN (2,5,6) " +
                                        " group by a.ORDEN_ACTIVIDAD , a.COD_ACTIVIDAD_FORMULA,apr.NOMBRE_ACTIVIDAD " +
                                        " union all " +
                                        " select a.ORDEN_ACTIVIDAD , a.COD_ACTIVIDAD_FORMULA,apr.NOMBRE_ACTIVIDAD ,sum(sppr.horas_hombre),sum((case when sppr.horas_hombre>0 then 1 else 0 end)) con_horas_hombre " +
                                        " ,sum(sppr.HORAS_maquina),sum((case when sppr.horas_maquina>0 then 1 else 0 end)) con_horas_maquina " +
                                        " ,sum(maf.horas_hombre) horas_hombre1,sum( (case when maf.horas_hombre>0 then 1 else 0 end)) con_horas_hombre1  " +
                                        " ,sum(maf.HORAS_maquina) horas_maquina1,sum((case when maf.horas_maquina>0 then 1 else 0 end)) con_horas_maquina1 " +
                                        " from ACTIVIDADES_FORMULA_MAESTRA a  " +
                                        " inner join MAQUINARIA_ACTIVIDADES_FORMULA maf on maf.COD_ACTIVIDAD_FORMULA = a.COD_ACTIVIDAD_FORMULA " +
                                        " inner join ACTIVIDADES_PRODUCCION apr on apr.COD_ACTIVIDAD = a.COD_ACTIVIDAD " +
                                        " left outer join SEGUIMIENTO_PROGRAMA_PRODUCCION sppr on sppr.COD_ACTIVIDAD_PROGRAMA = maf.COD_ACTIVIDAD_FORMULA " +
                                        " left outer join PROGRAMA_PRODUCCION ppr on sppr.COD_PROGRAMA_PROD = ppr.COD_PROGRAMA_PROD " +
                                        " and sppr.COD_LOTE_PRODUCCION = ppr.COD_LOTE_PRODUCCION " +
                                        " and sppr.COD_COMPPROD = ppr.COD_COMPPROD " +
                                        " and sppr.COD_FORMULA_MAESTRA = ppr.COD_FORMULA_MAESTRA and sppr.COD_TIPO_PROGRAMA_PROD = ppr.COD_TIPO_PROGRAMA_PROD " +
                                        " AND sppr.FECHA_INICIO >='"+fechaInicial+" 00:00:00'  AND sppr.FECHA_FINAL <= '"+fechaFinal+" 23:59:59' " +
                                        " AND (Sppr.HORAS_HOMBRE>0 or sppr.HORAS_MAQUINA>0) and (sppr.COD_MAQUINA = 0 or sppr.COD_MAQUINA is null) " +
                                        " where a.COD_FORMULA_MAESTRA = '"+codFormulaMaestra+"'  and apr.COD_TIPO_ACTIVIDAD_PRODUCCION = '"+codTipoActividadProduccion+"' and apr.COD_ESTADO_REGISTRO = 1 " +
                                        " AND PPR.COD_ESTADO_PROGRAMA IN (2,5,6) " +
                                        " group by a.ORDEN_ACTIVIDAD , a.COD_ACTIVIDAD_FORMULA,apr.NOMBRE_ACTIVIDAD ) AS TABLA  " +
                                        " group by ORDEN_ACTIVIDAD , COD_ACTIVIDAD_FORMULA,NOMBRE_ACTIVIDAD " +
                                        " order by ORDEN_ACTIVIDAD ASC   ";

                                System.out.println("consulta " + consulta);

                                con=Util.openConnection(con);
                                Statement st1 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                                ResultSet rs1 = st1.executeQuery(consulta);
                                while(rs1.next()){

                                    out.print("<tr>");
                                    out.print("<td  style='border : solid #f2f2f2 1px; background:#F9F9F9'  align='right' width='9.17%' >"+ (rs1.getString("ORDEN_ACTIVIDAD")==null?"":rs1.getString("ORDEN_ACTIVIDAD")) +" </td>");
                                    out.print("<td  style='border : solid #f2f2f2 1px; background:#F9F9F9'  align='left' width='9.17%'  >"+ (rs1.getString("NOMBRE_ACTIVIDAD")==null?"":rs1.getString("NOMBRE_ACTIVIDAD")) +" </td>");
                                    
                                    out.print("<td  style='border : solid #f2f2f2 1px; background:#F9F9F9'  align='right' width='9.17%' >"+ formato.format(rs1.getDouble("con_horas_hombre")>0?(rs1.getDouble("horas_hombre") / rs1.getDouble("con_horas_hombre")):0)+" </td>");
                                    out.print("<td  style='border : solid #f2f2f2 1px; background:#F9F9F9'  align='right' width='9.17%' >"+ formato.format(rs1.getDouble("con_horas_maquina")>0?(rs1.getDouble("horas_maquina") / rs1.getDouble("con_horas_maquina")):0) +" </td>");

                                    out.print("<td  style='border : solid #f2f2f2 1px; background:#F9F9F9'  align='right' width='9.17%' >"+ formato.format(rs1.getDouble("con_horas_hombre1")>0?(rs1.getDouble("horas_hombre1") / rs1.getDouble("con_horas_hombre1")):0)+" </td>");
                                    out.print("<td  style='border : solid #f2f2f2 1px; background:#F9F9F9'  align='right' width='9.17%' >"+ formato.format(rs1.getDouble("con_horas_maquina1")>0?(rs1.getDouble("horas_maquina1") / rs1.getDouble("con_horas_maquina1")):0) +" </td>");

                                    
                                    out.print("</tr>");
                                    
                                }
                            

                        }

               %>
               </table>

                <%
                    } catch (Exception e) {
                        e.printStackTrace();
                    }

                %>
            <br>

            <br>
            <div align="center">
                <%--<INPUT type="button" class="commandButton" name="btn_registrar" value="<-- Atrás" onClick="cancelar();"  >--%>

            </div>
        </form>
    </body>
</html>

