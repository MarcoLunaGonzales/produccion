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
                        String fechaInicial = request.getParameter("desdeFechaP")==null?"01/01/2001":request.getParameter("desdeFechaP");
                        String fechaFinal = request.getParameter("hastaFechaP")==null?"01/01/2001":request.getParameter("hastaFechaP");

                        String[] arrayFechaInicial = fechaInicial.split("/");
                        String[] arrayFechaFinal = fechaFinal.split("/");
                        fechaInicial = arrayFechaInicial[2]+"/"+arrayFechaInicial[1]+"/"+arrayFechaInicial[0];
                        fechaFinal = arrayFechaFinal[2]+"/"+arrayFechaFinal[1]+"/"+arrayFechaFinal[0];


                        

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

                String consulta=" select cp.COD_COMPPROD, cp.nombre_prod_semiterminado from COMPONENTES_PROD cp where cp.COD_AREA_EMPRESA in ("+codAreaEmpresa+") " +
                         " and cp.COD_COMPPROD in ("+codComponenteProd+")" ;
                System.out.println("consulta 1 "+ consulta);
                con=Util.openConnection(con);
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rs = st.executeQuery(consulta);
                while (rs.next()) {
                        String nombreProductoSemiterminado = rs.getString("nombre_prod_semiterminado");
                        int codCompProd = rs.getInt("COD_COMPPROD");
                %>
                <tr>
                    <td class="border"  align="left" colspan="6"><b><%=nombreProductoSemiterminado%></b></td>
                </tr>
                                <%
                             String consultaActividadesFormula=" select COD_COMPPROD,nombre_prod_semiterminado,COD_ACTIVIDAD_FORMULA,NOMBRE_ACTIVIDAD,ORDEN_ACTIVIDAD,SUM(CAST(HORAS_HOMBRE AS float))/SUM(REGISTRO) HORAS_HOMBRE,SUM(cast(HORAS_MAQUINA as float))/SUM(REGISTRO) HORAS_MAQUINA from " +
                                    " (SELECT CPR.COD_COMPPROD,CPR.nombre_prod_semiterminado ,AFM.COD_ACTIVIDAD_FORMULA , " +
                                    " APR.NOMBRE_ACTIVIDAD,AFM.ORDEN_ACTIVIDAD,FM.COD_FORMULA_MAESTRA, " +
                                    " (select top 1 s.HORAS_HOMBRE FROM SEGUIMIENTO_PROGRAMA_PRODUCCION s   where s.COD_ACTIVIDAD_PROGRAMA=afm.COD_ACTIVIDAD_FORMULA " +
                                    " and s.COD_PROGRAMA_PROD=ppr.COD_PROGRAMA_PROD and s.COD_COMPPROD=ppr.COD_COMPPROD  and s.COD_FORMULA_MAESTRA=fm.COD_FORMULA_MAESTRA    " +
                                    " and s.COD_LOTE_PRODUCCION=ppr.COD_LOTE_PRODUCCION  and s.FECHA_INICIO>='"+fechaInicial+" 00:00:00'  and  s.FECHA_FINAL<= '"+fechaFinal+" 23:59:59'  " +
                                    " order by s.COD_SEGUIMIENTO_PROGRAMA desc ) HORAS_HOMBRE ,(select top 1 s.HORAS_MAQUINA FROM SEGUIMIENTO_PROGRAMA_PRODUCCION s  " +
                                    " WHERE s.COD_ACTIVIDAD_PROGRAMA=afm.COD_ACTIVIDAD_FORMULA " +
                                    " and s.COD_PROGRAMA_PROD=ppr.COD_PROGRAMA_PROD and s.COD_COMPPROD=ppr.COD_COMPPROD  and s.COD_FORMULA_MAESTRA=fm.COD_FORMULA_MAESTRA    " +
                                    " and s.COD_LOTE_PRODUCCION=ppr.COD_LOTE_PRODUCCION and s.FECHA_INICIO>='"+fechaInicial+" 00:00:00'  and  s.FECHA_FINAL<= '"+fechaFinal+" 23:59:59'  " +
                                    " order by s.COD_SEGUIMIENTO_PROGRAMA desc ) HORAS_MAQUINA, " +
                                    " 1 REGISTRO FROM ACTIVIDADES_FORMULA_MAESTRA AFM    INNER JOIN ACTIVIDADES_PRODUCCION APR ON AFM.COD_ACTIVIDAD = APR.COD_ACTIVIDAD    " +
                                    " INNER JOIN FORMULA_MAESTRA FM ON FM.COD_FORMULA_MAESTRA = AFM.COD_FORMULA_MAESTRA    " +
                                    " INNER JOIN PROGRAMA_PRODUCCION PPR ON PPR.COD_FORMULA_MAESTRA = FM.COD_FORMULA_MAESTRA   " +
                                    " INNER JOIN COMPONENTES_PROD CPR ON PPR.COD_COMPPROD = CPR.COD_COMPPROD " +
                                    " AND CPR.COD_COMPPROD = FM.COD_COMPPROD   " +
                                    " WHERE PPR.COD_COMPPROD = "+codCompProd +"  AND PPR.COD_ESTADO_PROGRAMA IN (2,5,6)  and apr.COD_ESTADO_REGISTRO = 1 " +
                                    " and ppr.COD_PROGRAMA_PROD in (select s.COD_PROGRAMA_PROD from SEGUIMIENTO_PROGRAMA_PRODUCCION s where s.COD_COMPPROD = ppr.COD_COMPPROD " +
                                    " and s.COD_FORMULA_MAESTRA = fm.COD_FORMULA_MAESTRA and  s.COD_LOTE_PRODUCCION = ppr.COD_LOTE_PRODUCCION  " +
                                    " and s.FECHA_INICIO>='"+fechaInicial+" 00:00:00'  and  s.FECHA_FINAL<= '"+fechaFinal+" 23:59:59')  ) as tabla group by nombre_prod_semiterminado,NOMBRE_ACTIVIDAD,ORDEN_ACTIVIDAD,COD_ACTIVIDAD_FORMULA,COD_COMPPROD " +
                                    " order by ORDEN_ACTIVIDAD asc ";
                                    
                                    //setCon(Util.openConnection(getCon()));
                                    System.out.println("consulta 2 "+ consultaActividadesFormula);
                                    
                                    Statement stActividadesFormula=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                    ResultSet rsActividadesFormula=stActividadesFormula.executeQuery(consultaActividadesFormula);

                            while(rsActividadesFormula.next()){
                                //System.out.println("consulta 1 "+ consulta);                                
                                int codActividaFormula = rsActividadesFormula.getInt("COD_ACTIVIDAD_FORMULA");
                                String nombreActividad = rsActividadesFormula.getString("NOMBRE_ACTIVIDAD");
                                int ordenActividad = rsActividadesFormula.getInt("ORDEN_ACTIVIDAD");
                                Double horasHombre = rsActividadesFormula.getDouble("HORAS_HOMBRE");
                                Double horasMaquina = rsActividadesFormula.getDouble("HORAS_MAQUINA");

                                out.print("<tr>");
                                out.print("<td  style='border : solid #f2f2f2 1px'  align='right' width='9.17%' >"+(ordenActividad)+" </td>");
                                out.print("<td  style='border : solid #f2f2f2 1px'  align='left' width='9.17%'  >"+nombreActividad+" </td>");
                                out.print("<td  style='border : solid #f2f2f2 1px'  align='right' width='9.17%' >"+formato.format(horasHombre)+" </td>");
                                out.print("<td  style='border : solid #f2f2f2 1px'  align='right' width='9.17%' >"+ formato.format(horasMaquina) +" </td>");
                                //setCon(Util.openConnection(getCon()));

                                String consultaActividadFormulaMaestra = " SELECT FM.COD_COMPPROD,AFM.COD_ACTIVIDAD_FORMULA," +
                                        " MAF.HORAS_HOMBRE,MAF.HORAS_MAQUINA " +
                                        " FROM FORMULA_MAESTRA FM " +
                                        " INNER JOIN ACTIVIDADES_FORMULA_MAESTRA AFM ON FM.COD_FORMULA_MAESTRA = AFM.COD_FORMULA_MAESTRA " +
                                        " INNER JOIN MAQUINARIA_ACTIVIDADES_FORMULA MAF ON MAF.COD_ACTIVIDAD_FORMULA = AFM.COD_ACTIVIDAD_FORMULA " +
                                        " WHERE FM.COD_COMPPROD ="+codCompProd+" AND MAF.COD_ACTIVIDAD_FORMULA = "+codActividaFormula+" ";
                                
                                System.out.println("consulta 3 "+consultaActividadFormulaMaestra);
                                Statement stActividadFormulaMaestra=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                ResultSet rsActividadFormulaMaestra=stActividadFormulaMaestra.executeQuery(consultaActividadFormulaMaestra);
                                String codActividadFormula = "";

                                Double horasHombreFormulaMaestra = 0.0;
                                Double horasMaquinaFormulaMaestra = 0.0;

                                if(rsActividadFormulaMaestra.next()){
                                    codActividadFormula = rsActividadFormulaMaestra.getString("COD_ACTIVIDAD_FORMULA");
                                    horasHombreFormulaMaestra =  (rsActividadFormulaMaestra.getString("HORAS_HOMBRE").trim().equals("")||rsActividadFormulaMaestra.getString("HORAS_HOMBRE")==null)?0.0:Double.valueOf(rsActividadFormulaMaestra.getString("HORAS_HOMBRE"));
                                    horasMaquinaFormulaMaestra =  (rsActividadFormulaMaestra.getString("HORAS_MAQUINA").trim().equals("")||rsActividadFormulaMaestra.getString("HORAS_MAQUINA")==null)?0.0:Double.valueOf(rsActividadFormulaMaestra.getString("HORAS_MAQUINA"));
                                }
                                out.print("<td  style='border : solid #f2f2f2 1px'  align='right' width='9.17%' >"+formato.format( horasHombreFormulaMaestra)+" </td>");
                                out.print("<td  style='border : solid #f2f2f2 1px'  align='right' width='9.17%' >"+ formato.format(horasMaquinaFormulaMaestra) +" </td>");
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

