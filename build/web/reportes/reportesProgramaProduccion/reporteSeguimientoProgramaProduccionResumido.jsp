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
        <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
        <script src="../js/general.js"></script>
    </head>
    <body>
        <form>
            <h4 align="center">Reporte Seguimiento Programa Producción</h4>

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

                        String codProgramaProdPeriodo=request.getParameter("codProgramaProduccionPeriodo")==null?"''":request.getParameter("codProgramaProduccionPeriodo");
                        String arrayCodCompProd = request.getParameter("codCompProdArray")==null?"''":request.getParameter("codCompProdArray");
                        String nombreProgramaProduccionPeriodo = request.getParameter("nombreProgramaProduccionPeriodo")==null?"''":request.getParameter("nombreProgramaProduccionPeriodo");
                        arrayCodCompProd = arrayCodCompProd + (arrayCodCompProd.length()==0?"' '":"");


                        System.out.println("los datos de peticion para el reporte : "+request.getParameter("codAreaEmpresaP"));
                        System.out.println(request.getParameter("nombreAreaEmpresaP"));

                        System.out.println(request.getParameter("desdeFechaP"));
                        System.out.println(request.getParameter("hastaFechaP"));

                        String arrayCodAreaEmpresa= request.getParameter("codAreaEmpresaP");
                        String arrayNombreAreaEmpresa= request.getParameter("nombreAreaEmpresaP");

                        String desdeFecha=request.getParameter("desdeFechaP");
                        String hastaFecha=request.getParameter("hastaFechaP");

                        String codEstadoProgramaProduccion=request.getParameter("codEstadoPrograma");
                         String arraydesde[]=desdeFecha.split("/");
                         desdeFecha=arraydesde[2] +"/"+ arraydesde[1]+"/"+arraydesde[0];

                         String arrayhasta[]=hastaFecha.split("/");
                         hastaFecha=arrayhasta[2]+"/"+arrayhasta[1]+"/"+arrayhasta[0];

                         //Double totalHoraInicio=0.0d;
                         //Double totalHoraFinal=0.0d;

                         Double totalHorasHombre=0.0d;
                         Double totalHorasMaquina=0.0d;

                         Double totalHorasHombreFormulaMaestra=0.0d;
                         Double totalHorasMaquinaFormulaMaestra=0.0d;

                         //1:todos , 2:con seguimiento, 3:sin seguimiento


                         String codTipoReporteSeguimientoProgramaProduccion=request.getParameter("codTipoReporteSeguimientoProgramaProduccion");
                         String codTipoActividadProduccion=request.getParameter("codTipoActividadProduccion")==null?"0":request.getParameter("codTipoActividadProduccion");
                         


                         //System.out.println("las fechas en el reporte" + desdeFecha + " " +hastaFecha );


                    %>

            <div class="outputText0" align="center">
                PROGRAMA PRODUCCION: <%= nombreProgramaProduccionPeriodo %> <br>
                AREA(S) : <%= arrayNombreAreaEmpresa %><br>
                DE <%= arraydesde[0] +"/"+ arraydesde[1]+"/"+arraydesde[2] %> <br>
                HASTA <%= arrayhasta[0] +"/"+ arrayhasta[1]+"/"+arrayhasta[2] %>
                <%--PRODUCTO<%=nombreComponenteProd%>--%>
            </div>

            <br>
            <table width="60%" align="center" class="outputText0" style="border : solid #000000 1px;" cellpadding="0" cellspacing="0" >


                <tr class="">
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='45%' align="center" colspan="2"><b>Producto - Actividades</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='5%' align="center" ><b>Lote</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='5%' align="center"><b>Horas Hombre (Standard)</b></td>
                    <td align="center" style="border : solid #D8D8D8 1px" class="border"  bgcolor="#f2f2f2" width='5%' align="center"><b>Horas Maquina (Standard)</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='5%' align="center"><b>Horas Hombre</b></td>
                    <td align="center" style="border : solid #D8D8D8 1px" class="border"  bgcolor="#f2f2f2" width='5%' align="center"><b>Horas Maquina</b></td>
                </tr>

                <%

                String consulta=" SELECT  PPR.COD_LOTE_PRODUCCION,CPR.COD_COMPPROD ,CPR.nombre_prod_semiterminado " +
                                " FROM PROGRAMA_PRODUCCION PPR INNER JOIN COMPONENTES_PROD CPR ON PPR.COD_COMPPROD = CPR.COD_COMPPROD " +
                                " WHERE PPR.COD_ESTADO_PROGRAMA IN ("+codEstadoProgramaProduccion+") AND PPR.COD_PROGRAMA_PROD='"+codProgramaProdPeriodo+ "'" +
                                " AND PPR.COD_LOTE_PRODUCCION +''+ CAST(PPR.COD_COMPPROD  AS VARCHAR(20)) IN ("+arrayCodCompProd+")" +
                                " AND CPR.COD_AREA_EMPRESA IN ("+arrayCodAreaEmpresa+") " +
                                " ORDER BY CPR.nombre_prod_semiterminado,PPR.COD_LOTE_PRODUCCION ";

                System.out.println("consulta 1 "+ consulta);
                con=Util.openConnection(con);
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rs = st.executeQuery(consulta);
                while (rs.next()) {
                    //System.out.println("consulta 1 "+ consulta);
                    String nombreProductoSemiterminado= rs.getString("nombre_prod_semiterminado");
                    String codLoteProduccion = rs.getString("COD_LOTE_PRODUCCION");
                    String codCompProd = rs.getString("COD_COMPPROD");
                
                out.print("<tr>");
                out.print("<td class='border'  align='left' colspan='2'><b>"+nombreProductoSemiterminado+"</b></td>");
                out.print("<td class='border' align='center'><b>"+codLoteProduccion+"</b></td>");

                String consultaTiemposActividades = "select COD_COMPPROD,nombre_prod_semiterminado,COD_LOTE_PRODUCCION, SUM(CAST(HORAS_HOMBRE AS float)) HORAS_HOMBRE,SUM(cast(HORAS_MAQUINA as float)) HORAS_MAQUINA, " +
                                    " SUM(CAST(HORAS_HOMBRE_FORMULA_MAESTRA AS float)) HORAS_HOMBRE_FORMULA_MAESTRA,SUM(cast(HORAS_MAQUINA_FORMULA_MAESTRA as float)) HORAS_MAQUINA_FORMULA_MAESTRA   " +
                                    " from ( SELECT PPR.COD_LOTE_PRODUCCION,CPR.COD_COMPPROD,CPR.nombre_prod_semiterminado ,AFM.COD_ACTIVIDAD_FORMULA ,  " +
                                    "  APR.NOMBRE_ACTIVIDAD,AFM.ORDEN_ACTIVIDAD,FM.COD_FORMULA_MAESTRA,  " +
                                    " (select top 1 s.HORAS_HOMBRE FROM SEGUIMIENTO_PROGRAMA_PRODUCCION s   where s.COD_ACTIVIDAD_PROGRAMA=afm.COD_ACTIVIDAD_FORMULA  " +
                                    " and s.COD_PROGRAMA_PROD=ppr.COD_PROGRAMA_PROD and s.COD_COMPPROD=ppr.COD_COMPPROD  and s.COD_FORMULA_MAESTRA=fm.COD_FORMULA_MAESTRA     " +
                                    " and s.COD_LOTE_PRODUCCION=ppr.COD_LOTE_PRODUCCION  and s.FECHA_INICIO>='"+ desdeFecha +" 00:00:00'  and  s.FECHA_FINAL<= '"+hastaFecha+" 23:59:59'   " +
                                    " order by s.COD_SEGUIMIENTO_PROGRAMA desc ) HORAS_HOMBRE , (select top 1 s.HORAS_MAQUINA FROM SEGUIMIENTO_PROGRAMA_PRODUCCION s  " +
                                    " WHERE s.COD_ACTIVIDAD_PROGRAMA=afm.COD_ACTIVIDAD_FORMULA " +
                                    " and s.COD_PROGRAMA_PROD=ppr.COD_PROGRAMA_PROD and s.COD_COMPPROD=ppr.COD_COMPPROD  and s.COD_FORMULA_MAESTRA=fm.COD_FORMULA_MAESTRA    " +
                                    " and s.COD_LOTE_PRODUCCION=ppr.COD_LOTE_PRODUCCION and s.FECHA_INICIO>='"+ desdeFecha +" 00:00:00'  and  s.FECHA_FINAL<= '"+hastaFecha+" 23:59:59'  " +
                                    " order by s.COD_SEGUIMIENTO_PROGRAMA desc ) HORAS_MAQUINA, 1 REGISTRO,  " +
                                    " (SELECT sum(CAST( maf.HORAS_HOMBRE AS float)) FROM MAQUINARIA_ACTIVIDADES_FORMULA maf where maf.COD_ACTIVIDAD_FORMULA = afm.COD_ACTIVIDAD_FORMULA) HORAS_HOMBRE_FORMULA_MAESTRA, " +
                                    " (SELECT sum(CAST( maf.HORAS_MAQUINA AS float)) FROM MAQUINARIA_ACTIVIDADES_FORMULA maf where maf.COD_ACTIVIDAD_FORMULA = afm.COD_ACTIVIDAD_FORMULA) HORAS_MAQUINA_FORMULA_MAESTRA " +
                                    " FROM ACTIVIDADES_FORMULA_MAESTRA AFM    INNER JOIN ACTIVIDADES_PRODUCCION APR ON AFM.COD_ACTIVIDAD = APR.COD_ACTIVIDAD     " +
                                    " INNER JOIN FORMULA_MAESTRA FM ON FM.COD_FORMULA_MAESTRA = AFM.COD_FORMULA_MAESTRA    " +
                                    " INNER JOIN PROGRAMA_PRODUCCION PPR ON PPR.COD_FORMULA_MAESTRA = FM.COD_FORMULA_MAESTRA   " +
                                    " INNER JOIN COMPONENTES_PROD CPR ON PPR.COD_COMPPROD = CPR.COD_COMPPROD " +
                                    " AND CPR.COD_COMPPROD = FM.COD_COMPPROD    WHERE PPR.COD_COMPPROD = "+codCompProd+"  AND PPR.COD_ESTADO_PROGRAMA IN (2,5,6)  and apr.COD_ESTADO_REGISTRO = 1 " +
                                    " and ppr.COD_PROGRAMA_PROD ="+codProgramaProdPeriodo+" AND PPR.COD_LOTE_PRODUCCION = '"+codLoteProduccion+"' " +
                                    " and apr.COD_TIPO_ACTIVIDAD_PRODUCCION ='"+codTipoActividadProduccion+"' ) as tabla  group by nombre_prod_semiterminado,COD_COMPPROD,COD_LOTE_PRODUCCION " ;
                                    System.out.println("consulta "+consultaTiemposActividades);
                Statement stTiemposActividades=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet rsTiemposActividades=stTiemposActividades.executeQuery(consultaTiemposActividades);
                Double subTotalHorasHombre = 0.0;
                Double subTotalHorasMaquina = 0.0;
                Double subTotalHorasHombreFormulaMaestra = 0.0;
                Double subTotalHorasMaquinaFormulaMaestra = 0.0;


                if(rsTiemposActividades.next()){                    
                    subTotalHorasHombreFormulaMaestra = rsTiemposActividades.getDouble("HORAS_HOMBRE_FORMULA_MAESTRA");
                    subTotalHorasMaquinaFormulaMaestra = rsTiemposActividades.getDouble("HORAS_MAQUINA_FORMULA_MAESTRA");
                    subTotalHorasHombre = rsTiemposActividades.getDouble("HORAS_HOMBRE");
                    subTotalHorasMaquina = rsTiemposActividades.getDouble("HORAS_MAQUINA");
                }

                out.print("<td class='border' align='right'>"+formato.format(subTotalHorasHombreFormulaMaestra)+"</td>");
                out.print("<td class='border' align='right'>"+formato.format(subTotalHorasMaquinaFormulaMaestra)+"</td>");
                out.print("<td class='border' align='right'>"+formato.format(subTotalHorasHombre)+"</td>");
                out.print("<td class='border' align='right'>"+formato.format(subTotalHorasMaquina)+"</td>");
                out.print("</tr>");

                totalHorasHombreFormulaMaestra = totalHorasHombreFormulaMaestra + subTotalHorasHombreFormulaMaestra;
                totalHorasMaquinaFormulaMaestra = totalHorasMaquinaFormulaMaestra + subTotalHorasMaquinaFormulaMaestra;
                totalHorasHombre = totalHorasHombre + subTotalHorasHombre;
                totalHorasMaquina = totalHorasMaquina + subTotalHorasMaquina;                
                        }
                                out.print("<tr>");
                                out.print("<td align='right'  style='border : solid #D8D8D8 1px' ></td>");
                                out.print("<td  class='border' style='border : solid #D8D8D8 1px' bgcolor='#f2f2f2' ></td>");
                                out.print("<td align='center' style='border : solid #D8D8D8 1px' class='border'  bgcolor='#f2f2f2' >TOTAL GENERAL</td>");
                                out.print("<td align='right' style='border : solid #D8D8D8 1px' bgcolor='#f2f2f2' >"+formato.format(totalHorasHombreFormulaMaestra)+"</td>");
                                out.print("<td align='right' style='border : solid #D8D8D8 1px' bgcolor='#f2f2f2' >"+formato.format(totalHorasMaquinaFormulaMaestra)+"</td>");
                                out.print("<td align='right' style='border : solid #D8D8D8 1px' bgcolor='#f2f2f2' >"+formato.format(totalHorasHombre)+"</td>");
                                out.print("<td align='right' style='border : solid #D8D8D8 1px' bgcolor='#f2f2f2' >"+formato.format(totalHorasMaquina)+"</td>");
                                out.print("</tr>");

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