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

                        SimpleDateFormat format=new SimpleDateFormat("dd/MM/yyyy");

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
                        /* String arraydesde[]=desdeFecha.split("/");
                         desdeFecha=arraydesde[2] +"/"+ arraydesde[1]+"/"+arraydesde[0];

                         String arrayhasta[]=hastaFecha.split("/");
                         hastaFecha=arrayhasta[2]+"/"+arrayhasta[1]+"/"+arrayhasta[0];*/

                         //Double totalHoraInicio=0.0d;
                         //Double totalHoraFinal=0.0d;

                         Double totalHorasHombre=0.0d;
                         Double totalHorasMaquina=0.0d;

                         Double totalHorasHombreFormulaMaestra=0.0d;
                         Double totalHorasMaquinaFormulaMaestra=0.0d;

                         //1:todos , 2:con seguimiento, 3:sin seguimiento


                         String codTipoReporteSeguimientoProgramaProduccion=request.getParameter("codTipoReporteSeguimientoProgramaProduccion");

                         String codAreaEmpresaActividad=request.getParameter("codAreaEmpresaActividad")==null?"0":request.getParameter("codAreaEmpresaActividad");
                         String codTipoReporteDetallado = request.getParameter("codTipoReporteDetallado")==null?"0":request.getParameter("codTipoReporteDetallado");
                         //System.out.println("el parametro de detalle "+codTipoReporteDetallado);

                         //System.out.println("las fechas en el reporte" + desdeFecha + " " +hastaFecha );


                    %>

                    <%--
            <div class="outputText0" align="center">
                PROGRAMA PRODUCCION: <%= nombreProgramaProduccionPeriodo %> <br>
                AREA(S) : <%= arrayNombreAreaEmpresa %><br>
                DE <%= arraydesde[0] +"/"+ arraydesde[1]+"/"+arraydesde[2] %> <br>
                HASTA <%= arrayhasta[0] +"/"+ arrayhasta[1]+"/"+arrayhasta[2] %>
                <%--PRODUCTO<%=nombreComponenteProd%>--%>
                <%--
            </div--%>

            <br>
            <table width="70%" align="center" class="outputText0" style="border : solid #000000 1px;" cellpadding="0" cellspacing="0" >


                <tr class="">
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='20%' align="center" colspan="2"><b>Producto - Lote</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='5%' align="center" ><b>Cantidad de Produccion </b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='5%' align="center"><b>Horas Hombre</b></td>
                    <td align="center" style="border : solid #D8D8D8 1px" class="border"  bgcolor="#f2f2f2" width='5%' align="center"><b>Horas Maquina</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='5%' align="center"><b>Maquina </b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='5%' align="center"><b>Fecha Inicial </b></td>
                    <td align="center" style="border : solid #D8D8D8 1px" class="border"  bgcolor="#f2f2f2" width='5%' align="center"><b>Fecha Final</b></td>                    
                    <td align="center" style="border : solid #D8D8D8 1px" class="border"  bgcolor="#f2f2f2" width='5%' align="center"><b>Maquina (Standard)</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='5%' align="center"><b>Horas Hombre (Standard)</b></td>
                    <td align="center" style="border : solid #D8D8D8 1px" class="border"  bgcolor="#f2f2f2" width='5%' align="center"><b>Horas Maquina (Standard)</b></td>
                    
                    
                </tr>

                <%

                String consulta=" SELECT  PPR.COD_LOTE_PRODUCCION,CPR.COD_COMPPROD,PPR.COD_FORMULA_MAESTRA ,CPR.nombre_prod_semiterminado,PPR.COD_TIPO_PROGRAMA_PROD,TPPR.NOMBRE_TIPO_PROGRAMA_PROD, " +
                                " PPR.CANT_LOTE_PRODUCCION " +
                                " FROM PROGRAMA_PRODUCCION PPR INNER JOIN COMPONENTES_PROD CPR ON PPR.COD_COMPPROD = CPR.COD_COMPPROD " +
                                " INNER JOIN TIPOS_PROGRAMA_PRODUCCION TPPR ON TPPR.COD_TIPO_PROGRAMA_PROD = PPR.COD_TIPO_PROGRAMA_PROD " +
                                " WHERE PPR.COD_ESTADO_PROGRAMA IN ("+codEstadoProgramaProduccion+") AND PPR.COD_PROGRAMA_PROD='"+codProgramaProdPeriodo+ "'" +
                                " AND PPR.COD_LOTE_PRODUCCION +''+ CAST(PPR.COD_COMPPROD  AS VARCHAR(20))+''+cast( PPR.COD_TIPO_PROGRAMA_PROD as varchar(20)) IN ("+arrayCodCompProd+")" +
                                " AND CPR.COD_AREA_EMPRESA IN ("+arrayCodAreaEmpresa+") " +
                                " ORDER BY CPR.nombre_prod_semiterminado,PPR.COD_LOTE_PRODUCCION ";

                System.out.println("consulta 1 "+ consulta);
                con=Util.openConnection(con);
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rs = st.executeQuery(consulta);
                while (rs.next()) {
                    //System.out.println("consulta 1 "+ consulta);
                    String nombreProductoSemiternimando= rs.getString("nombre_prod_semiterminado");
                    String codLoteProduccion = rs.getString("COD_LOTE_PRODUCCION");
                    String codCompProd = rs.getString("COD_COMPPROD");
                    String codFormulaMaestra = rs.getString("COD_FORMULA_MAESTRA");
                    String codTipoProgramaProd = rs.getString("COD_TIPO_PROGRAMA_PROD");
                %>
                <tr>
                    <td class="border"  align="left" colspan="2"><%--b><%=nombreProductoSemiternimando +"(" +rs.getString("NOMBRE_TIPO_PROGRAMA_PROD") + ") "+ codLoteProduccion  %></b--%></td>
                    <td class="border" align="center"><b><%=rs.getDouble("CANT_LOTE_PRODUCCION")  %></b></td>
                    <td class="border" align="right" colspan="8">&nbsp;</td>
                </tr>
                                <%                                
                             String consultaActividades=" select afm.COD_ACTIVIDAD,  ap.NOMBRE_ACTIVIDAD,   afm.COD_ACTIVIDAD_FORMULA,   " +
                                     " afm.ORDEN_ACTIVIDAD, sppr.HORAS_HOMBRE,  sppr.HORAS_MAQUINA, sppr.FECHA_INICIO,  sppr.FECHA_FINAL, " +
                                     " sppr.COD_MAQUINA,  m.NOMBRE_MAQUINA,       maf.HORAS_HOMBRE HORAS_HOMBRE_STANDARD," +
                                     "  maf.HORAS_MAQUINA HORAS_MAQUINA_STANDARD,  m1.NOMBRE_MAQUINA NOMBRE_MAQUINA_STANDARD " +
                                     " from ACTIVIDADES_FORMULA_MAESTRA afm " +
                                     " inner join ACTIVIDADES_PRODUCCION ap on afm.COD_ACTIVIDAD = ap.COD_ACTIVIDAD " +
                                     " inner join FORMULA_MAESTRA fm on fm.COD_FORMULA_MAESTRA = afm.COD_FORMULA_MAESTRA" +
                                     " left outer join SEGUIMIENTO_PROGRAMA_PRODUCCION sppr on sppr.COD_FORMULA_MAESTRA = fm.COD_FORMULA_MAESTRA " +
                                     " and sppr.COD_ACTIVIDAD_PROGRAMA = afm.COD_ACTIVIDAD_FORMULA " +
                                     " and sppr.COD_PROGRAMA_PROD = '"+codProgramaProdPeriodo+"'  " +
                                     " and sppr.COD_COMPPROD = '"+codCompProd+"'  " +
                                     " and sppr.COD_FORMULA_MAESTRA = afm.COD_FORMULA_MAESTRA " +
                                     " and sppr.COD_LOTE_PRODUCCION = '"+codLoteProduccion+"' and sppr.COD_TIPO_PROGRAMA_PROD = '"+codTipoProgramaProd+"'  " +
                                     " left outer join maquinarias m on m.cod_maquina = sppr.cod_maquina " +
                                     " left outer join MAQUINARIA_ACTIVIDADES_FORMULA maf on maf.COD_MAQUINA = sppr.COD_MAQUINA " +
                                     " and maf.COD_ACTIVIDAD_FORMULA = afm.COD_ACTIVIDAD_FORMULA " +
                                     " left outer join maquinarias m1 on m1.COD_MAQUINA = maf.COD_MAQUINA      " +
                                     " where afm.COD_FORMULA_MAESTRA = '"+codFormulaMaestra+"'  " +
                                     " and afm.cod_area_empresa = '"+codAreaEmpresaActividad +"'  " +
                                     " order by afm.ORDEN_ACTIVIDAD asc ";

                                    //setCon(Util.openConnection(getCon()));
                            System.out.println("consulta 2 "+ consultaActividades);

                            Statement stActividad=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                            ResultSet rs1=stActividad.executeQuery(consultaActividades);
                            float horasHombre = 0;
                            float horasMaquina = 0;

                            float horasHombreFormulaMaestra = 0;
                            float horasMaquinaFormulaMaestra = 0;

                            float subtotalHorasHombre = 0;
                            float subTotalHorasMaquina = 0;
                            float subTotalHorasHombreStandard = 0;
                            float subTotalHorasMaquinaStandard = 0;

                            while(rs1.next()){
                                //si el reporte es detallado
                                if(codTipoReporteDetallado.equals("1")){
                                out.print("<tr>");
                                out.print("<td align='right'  style='border : solid #f2f2f2 1px'  width='5%' ><b>"+rs1.getString("ORDEN_ACTIVIDAD")+"</b></td>");
                                out.print("<td align='left'  style='border : solid #f2f2f2 1px'   colspan='2'><b>"+rs1.getString("NOMBRE_ACTIVIDAD")+"</b></td>");
                                out.print("<td align='left'  style='border : solid #f2f2f2 1px' >&nbsp;"+rs1.getDouble("HORAS_HOMBRE")+"</td>");
                                out.print("<td align='left'  style='border : solid #f2f2f2 1px' >&nbsp;"+rs1.getDouble("HORAS_MAQUINA")+"</td>");
                                out.print("<td align='left'  style='border : solid #f2f2f2 1px' >&nbsp;"+(rs1.getString("NOMBRE_MAQUINA")!=null?rs1.getString("NOMBRE_MAQUINA"):"")+"</td>");
                                out.print("<td align='left'  style='border : solid #f2f2f2 1px' >&nbsp;"+(rs1.getDate("FECHA_INICIO")!=null?format.format(rs1.getDate("FECHA_INICIO")):"") +"</td>");
                                out.print("<td align='left'  style='border : solid #f2f2f2 1px' >&nbsp;"+(rs1.getDate("FECHA_FINAL")!=null?format.format(rs1.getDate("FECHA_FINAL")):"") +"</td>");
                                out.print("<td align='left'  style='border : solid #f2f2f2 1px' >&nbsp;"+rs1.getDouble("HORAS_HOMBRE_STANDARD")+"</td>");
                                out.print("<td align='left'  style='border : solid #f2f2f2 1px' >&nbsp;"+rs1.getDouble("HORAS_MAQUINA_STANDARD")+"</td>");
                                out.print("<td align='left'  style='border : solid #f2f2f2 1px' >&nbsp;"+(rs1.getString("NOMBRE_MAQUINA_STANDARD")!=null?rs1.getString("NOMBRE_MAQUINA_STANDARD"):"")+"</td>");
                                out.print("</tr>");
                                }
                                subtotalHorasHombre = subtotalHorasHombre + (float)rs1.getDouble("HORAS_HOMBRE") ;
                                subTotalHorasMaquina = subTotalHorasMaquina + (float) rs1.getDouble("HORAS_MAQUINA");
                                subTotalHorasHombreStandard = subTotalHorasHombreStandard +(float) rs1.getDouble("HORAS_HOMBRE_STANDARD");
                                subTotalHorasMaquinaStandard = subTotalHorasMaquinaStandard +(float) rs1.getDouble("HORAS_MAQUINA_STANDARD");
                        }

                                out.print("<tr>");
                                out.print("<td class='border' align='right'  style='border : solid #D8D8D8 1px' >"+codLoteProduccion+"</td>");
                                out.print("<td  class='border' style='border : solid #D8D8D8 1px' bgcolor='#f2f2f2' align='left'  colspan='1'>"+(nombreProductoSemiternimando +"(" +rs.getString("NOMBRE_TIPO_PROGRAMA_PROD") + ") ")+"</td>");
                                out.print("<td  class='border' style='border : solid #D8D8D8 1px' bgcolor='#f2f2f2' align='right'  colspan='1'>&nbsp;SUB TOTAL</td>");
                                out.print("<td align='left' style='border : solid #D8D8D8 1px' class='border'  bgcolor='#f2f2f2' >"+subtotalHorasHombre+"</td>");
                                out.print("<td align='left' style='border : solid #D8D8D8 1px' class='border'  bgcolor='#f2f2f2' >"+subTotalHorasMaquina+"</td>");
                                out.print("<td align='center' style='border : solid #D8D8D8 1px' class='border'  bgcolor='#f2f2f2' ></td>");
                                out.print("<td align='center' style='border : solid #D8D8D8 1px' class='border'  bgcolor='#f2f2f2' ></td>");
                                out.print("<td align='right' style='border : solid #D8D8D8 1px' bgcolor='#f2f2f2' ></td>");
                                out.print("<td align='left' style='border : solid #D8D8D8 1px' bgcolor='#f2f2f2' >"+subTotalHorasHombreStandard+"</td>");
                                out.print("<td align='left' style='border : solid #D8D8D8 1px' bgcolor='#f2f2f2' >"+subTotalHorasMaquinaStandard+"</td>");
                                out.print("<td align='right' style='border : solid #D8D8D8 1px' bgcolor='#f2f2f2' ></td>");
                                out.print("</tr>");
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