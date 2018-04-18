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
            <h4 align="center">Reporte de Tiempos Maquinaria</h4>

                    <%
                    try {

                /*
                         <input type="hidden" name="codProgramaProduccionPeriodo">
                        <input type="hidden" name="codCompProd">
                        <input type="hidden" name="nombreCompProd">
                        */

                        String codProgramaProd=request.getParameter("codProgramaProd")==null?"''":request.getParameter("codProgramaProd");
                        String nombreProgramaProd=request.getParameter("nombreProgramaProd")==null?"''":request.getParameter("nombreProgramaProd");
                        String codMaquinaP=request.getParameter("codMaquinaP")==null?"''":request.getParameter("codMaquinaP");

                        String fechaInicial=request.getParameter("fechaInicial")==null?"''":request.getParameter("fechaInicial");
                        String fechaFinal=request.getParameter("fechaFinal")==null?"''":request.getParameter("fechaFinal");
                        
                        String[] arrayFechaInicial = fechaInicial.split("/");
                        String[] arrayFechaFinal = fechaFinal.split("/");

                        


                        NumberFormat numeroformato = NumberFormat.getNumberInstance(Locale.ENGLISH);
                        DecimalFormat formato = (DecimalFormat) numeroformato;
                        formato.applyPattern("#,###.##;-#,###.##");

                        SimpleDateFormat f=new SimpleDateFormat("dd/MM/yyyy");

                        con = Util.openConnection(con);

                        


                         //System.out.println("las fechas en el reporte" + desdeFecha + " " +hastaFecha );


                    %>

           

            <br>
            <table  class="outputText0" align="center" width="45%">
                    <tr>
                        <td align="left" rowspan="3"><img src= "../../img/cofar.png"></td>
                        <td width="25%"><b>Programa Produccion :: </b></td>
                        <td><%=nombreProgramaProd%></td>
                    </tr>
                    <tr>
                        <td><b>Fecha Inicial :: </b></td>
                        <td><%=fechaInicial%></td>
                    </tr>
                    <tr>
                        <td><b>Fecha Final ::</b></td>
                        <td><%=fechaFinal%></td>
                    </tr>
            </table>
                
            <table width="18%" align="center" class="outputText0" style="border : solid #000000 1px;" cellpadding="0" cellspacing="0" >


                <tr class="">
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2"  align="center" ><b>Tipo de Periodo</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2"  align="center" ><b>Horas Frecuencia</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2"  align="center" ><b>Total Horas</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2"  align="center" ><b>Diferencia</b></td>
                </tr>
                <%

                String consulta=" select m.COD_MAQUINA,m.NOMBRE_MAQUINA  from maquinarias m where m.COD_MAQUINA in ("+codMaquinaP+")  and m.COD_ESTADO_REGISTRO = 1 ORDER BY  m.NOMBRE_MAQUINA ASC";

                System.out.println("consulta maquinarias 1 "+ consulta);
                con=Util.openConnection(con);
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rs = st.executeQuery(consulta);
                while (rs.next()) {
                    //System.out.println("consulta 1 "+ consulta);
                    String codMaquina= rs.getString("COD_MAQUINA");
                    String nombreMaquina = rs.getString("NOMBRE_MAQUINA");
                %>
                <tr>
                    <td class="border"  align="left" colspan="4" bgcolor="#F9F9F9"><b><%=nombreMaquina%></b></td>
                </tr>
                                <%
                                //hallar las frecuencias
                            consulta = " select f.COD_MAQUINA,f.COD_TIPO_PERIODO,t.NOMBRE_TIPO_PERIODO, f.HORAS_FRECUENCIA " +
                                    " from FRECUENCIAS_MANTENIMIENTO_MAQUINA f inner join TIPOS_PERIODO t on t.COD_TIPO_PERIODO = f.COD_TIPO_PERIODO " +
                                    " where f.COD_MAQUINA = '"+codMaquina+"' ";

                            con=Util.openConnection(con);
                            st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                            ResultSet rsFrecuencias = st.executeQuery(consulta);                            
                            
                            consulta = "select sum(cast( horas_maquina as float) ) horas_maquina from ( " +
                                    " select (select top 1 sppr.horas_maquina from SEGUIMIENTO_PROGRAMA_PRODUCCION sppr " +
                                    " where sppr.COD_PROGRAMA_PROD = ppr.COD_PROGRAMA_PROD  and sppr.COD_ACTIVIDAD_PROGRAMA= afm.COD_ACTIVIDAD_FORMULA " +
                                    " and sppr.COD_FORMULA_MAESTRA = ppr.COD_FORMULA_MAESTRA  " +
                                    " and sppr.COD_COMPPROD=ppr.COD_COMPPROD  " +
                                    " and sppr.COD_LOTE_PRODUCCION = ppr.COD_LOTE_PRODUCCION  " +
                                    " and sppr.COD_MAQUINA = "+codMaquina+" " +
                                    " and sppr.FECHA_INICIO>='"+arrayFechaInicial[2]+"/"+arrayFechaInicial[1]+"/"+arrayFechaInicial[0]+"' and sppr.FECHA_FINAL<='"+arrayFechaFinal[2]+"/"+arrayFechaFinal[1]+"/"+arrayFechaFinal[0]+"' " +
                                    " order by sppr.COD_SEGUIMIENTO_PROGRAMA desc) horas_maquina,ppr.COD_PROGRAMA_PROD,pprp.NOMBRE_PROGRAMA_PROD " +
                                    " from PROGRAMA_PRODUCCION_PERIODO pprp inner join  " +
                                    " programa_produccion ppr on pprp.COD_PROGRAMA_PROD= ppr.COD_PROGRAMA_PROD " +
                                    " inner join FORMULA_MAESTRA fm on fm.COD_FORMULA_MAESTRA = ppr.COD_FORMULA_MAESTRA " +
                                    " inner join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_FORMULA_MAESTRA = fm.COD_FORMULA_MAESTRA " +
                                    " where ppr.COD_PROGRAMA_PROD in ("+codProgramaProd+")) as tabla ";

                            System.out.println("consulta" + consulta);
                            st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                            ResultSet rsHorasMaquina = st.executeQuery(consulta);

                            float horasMaquina = 0;
                            if(rsHorasMaquina.next()){
                                horasMaquina = rsHorasMaquina.getFloat("horas_maquina");                                
                            }
                            rsFrecuencias.last();
                            int filasFrecuencias = rsFrecuencias.getRow();
                            rsFrecuencias.first();
                            while(rsFrecuencias.next()){
                                float codTipoPeriodo = rsFrecuencias.getFloat("COD_TIPO_PERIODO");
                                String nombreTipoPeriodo = rsFrecuencias.getString("NOMBRE_TIPO_PERIODO");
                                float horasFrecuencia = rsFrecuencias.getFloat("HORAS_FRECUENCIA");

                                //rowspan='"+filasFrecuencias+"'
                                System.out.println("el numero de filas" + filasFrecuencias);
                                out.print("<tr>");

                                out.print("<td align='right'  style='border : solid #f2f2f2 1px'  >"+nombreTipoPeriodo+"</td>");
                                out.print("<td align='right'  style='border : solid #f2f2f2 1px'  >"+horasFrecuencia+"</td>");

                                if(rsFrecuencias.getRow()==2)
                                {out.print("<td  rowspan='"+(filasFrecuencias-1)+"' align='right'  style='border : solid #f2f2f2 1px' >"+formato.format(horasMaquina)+"</td>");}
                                
                                //columna de diferencia
                                out.print("<td  align='right'  style='border : solid #f2f2f2 1px' >"+formato.format(horasFrecuencia-horasMaquina)+"</td>");

                                out.print("</tr>");
                            }                            
                        }
                                out.print("<tr>");
                                out.print("<td align='right'  style='border : solid #D8D8D8 1px' bgcolor='#f2f2f2'></td>");
                                out.print("<td  class='border' style='border : solid #D8D8D8 1px' bgcolor='#f2f2f2' >&nbsp;</td>");                                
                                out.print("<td  class='border' style='border : solid #D8D8D8 1px' bgcolor='#f2f2f2' >&nbsp;</td>");                                
                                out.print("<td  class='border' style='border : solid #D8D8D8 1px' bgcolor='#f2f2f2' >&nbsp;</td>");                                
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