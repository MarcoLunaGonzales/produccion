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
            <h4 align="center">Reporte Seguimiento Tiempos Maquinaria</h4>

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

                        
                        NumberFormat numeroformato = NumberFormat.getNumberInstance(Locale.ENGLISH);
                        DecimalFormat formato = (DecimalFormat) numeroformato;
                        formato.applyPattern("#,###.##;(#,###.##)");

                        SimpleDateFormat f=new SimpleDateFormat("dd/MM/yyyy");

                        con = Util.openConnection(con);

                        


                         //System.out.println("las fechas en el reporte" + desdeFecha + " " +hastaFecha );


                    %>

           

            <br>
            <table width="20%" align="center" class="outputText0" style="border : solid #000000 1px;" cellpadding="0" cellspacing="0" >


                <tr class="">
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='10%' align="center" ><b>Programa de Produccion</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='5%' align="center" ><b>Horas</b></td>                    
                </tr>
                <%

                String consulta=" select m.COD_MAQUINA,m.NOMBRE_MAQUINA  from maquinarias m where m.COD_MAQUINA in ("+codMaquinaP+")  and m.COD_ESTADO_REGISTRO = 1 ";

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
                    <td class="border"  align="left" colspan="2" bgcolor="#F9F9F9"><b><%=nombreMaquina%></b></td>
                </tr>
                                <%
                             String consultaTiemposProgramaProduccion=" select sum(cast( horas_maquina as float) ) horas_maquina, COD_PROGRAMA_PROD,NOMBRE_PROGRAMA_PROD from ( " +
                                     " select (select top 1 sppr.horas_maquina from SEGUIMIENTO_PROGRAMA_PRODUCCION sppr where  " +
                                     " sppr.COD_PROGRAMA_PROD = ppr.COD_PROGRAMA_PROD  " +
                                     " and sppr.COD_ACTIVIDAD_PROGRAMA= afm.COD_ACTIVIDAD_FORMULA  " +
                                     " and sppr.COD_FORMULA_MAESTRA = ppr.COD_FORMULA_MAESTRA  " +
                                     " and sppr.COD_COMPPROD=ppr.COD_COMPPROD  " +
                                     " and sppr.COD_LOTE_PRODUCCION = ppr.COD_LOTE_PRODUCCION  " +
                                     " and sppr.COD_MAQUINA = "+codMaquina+" " +
                                     " order by sppr.COD_SEGUIMIENTO_PROGRAMA desc) horas_maquina,ppr.COD_PROGRAMA_PROD,pprp.NOMBRE_PROGRAMA_PROD " +
                                     " from PROGRAMA_PRODUCCION_PERIODO pprp inner join  " +
                                     " programa_produccion ppr on pprp.COD_PROGRAMA_PROD= ppr.COD_PROGRAMA_PROD " +
                                     " inner join FORMULA_MAESTRA fm on fm.COD_FORMULA_MAESTRA = ppr.COD_FORMULA_MAESTRA " +
                                     " inner join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_FORMULA_MAESTRA = fm.COD_FORMULA_MAESTRA " +
                                     " where ppr.COD_PROGRAMA_PROD in ("+codProgramaProd+") " +
                                     ") as tabla group by cod_programa_prod,nombre_programa_prod  ";
                            
                            System.out.println("consulta 2 "+ consultaTiemposProgramaProduccion);
                            
                            Statement stActividad=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                            ResultSet rsHorasMaquinaProgramaProd=stActividad.executeQuery(consultaTiemposProgramaProduccion);
                            float subTotalhorasHombre = 0;
                            float subTotalhorasMaquina = 0;

                            float horasHombreFormulaMaestra1= 0;
                            float horasMaquinaFormulaMaestra1 = 0;
                            
                            while(rsHorasMaquinaProgramaProd.next()){
                                float horasMaquina = rsHorasMaquinaProgramaProd.getFloat("horas_maquina");
                                int codProgramaProduccion =rsHorasMaquinaProgramaProd.getInt("COD_PROGRAMA_PROD");
                                String nombreProgramaProduccion =rsHorasMaquinaProgramaProd.getString("NOMBRE_PROGRAMA_PROD");                                
                                
                                out.print("<tr>");
                                out.print("<td align='right'  style='border : solid #f2f2f2 1px'  width='5%' >"+nombreProgramaProduccion+"</td>");
                                out.print("<td align='right'  style='border : solid #f2f2f2 1px' >"+formato.format(horasMaquina)+"</td>");
                                out.print("</tr>");                                
                                subTotalhorasMaquina = subTotalhorasMaquina+ horasMaquina;
                            }
                            out.print("<tr>");
                            out.print("<td align='right'  style='border : solid #D8D8D8 1px' bgcolor='#f2f2f2'>TOTAL:</td>");
                            out.print("<td align='right'  class='border' style='border : solid #D8D8D8 1px' bgcolor='#f2f2f2' >"+formato.format(subTotalhorasMaquina)+"</td>");
                            out.print("</tr>");
                        }
                                out.print("<tr>");
                                out.print("<td align='right'  style='border : solid #D8D8D8 1px' bgcolor='#f2f2f2'></td>");
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