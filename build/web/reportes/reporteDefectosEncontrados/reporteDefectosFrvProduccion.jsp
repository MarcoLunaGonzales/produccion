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

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
        
    </head>
    <body>
      
        <form>

            <h4 align="center" class="outputText5"><b>Reporte frv Producción</b></h4>
            <center>
                <%
                    String codigosLotes=request.getParameter("codigosLotes");
                %>
                <table style="width:70%">
                    <thead>
                        <tr>
                            <td class="outputTextBold">Lotes::</td>
                            <td class="outputText2"><%=(codigosLotes.replace("'"," "))%></td>
                        </tr>
                    </thead>
                </table>
            
            <%
                
                out.println("<table cellpadding='0' cellspacing='0' class='tablaReporte'>");
                    out.println("<thead>");
                        out.println("<tr>");
                            out.println("<td>Lote</td>");
                            out.println("<td>Personal</td>");
                            out.println("<td>Actividad</td>");
                            out.println("<td>Cantidad Frv</td>");
                        out.println("</tr>");
                    out.println("</thead>");
                
                DecimalFormat formato=null;
                NumberFormat numeroformato = NumberFormat.getNumberInstance(Locale.ENGLISH);
                formato = (DecimalFormat) numeroformato;
                formato.applyPattern("#,##0.00");
                try
                {
                    Connection con=null;
                    
                    con=Util.openConnection(con);
                    StringBuilder consulta=new StringBuilder("SELECT sppp.FECHA_INICIO,sppp.FECHA_FINAL,sppp.HORAS_HOMBRE,sppp.CANTIDAD_FRV,sppp.CANTIDAD_PRODUCIDA,")
                                                                .append(" sppp.CANTIDAD_FRV,")
                                                                .append(" isnull(p.AP_PATERNO_PERSONAL + ' ' + p.AP_MATERNO_PERSONAL + ' ' +p.NOMBRES_PERSONAL, pt.AP_PATERNO_PERSONAL + ' ' +pt.AP_MATERNO_PERSONAL + ' ' + pt.NOMBRES_PERSONAL) as nombresPersonal")
                                                                .append(" ,ap.NOMBRE_ACTIVIDAD,spp.COD_LOTE_PRODUCCION")
                                                    .append(" FROM SEGUIMIENTO_PROGRAMA_PRODUCCION_PROCESO spp")
                                                            .append(" inner join SEGUIMIENTO_PROGRAMA_PRODUCCION_PROCESO_PERSONAL sppp on spp.COD_SEGUIMIENTO_PROGRAMA_PRODUCCION_PROCESO=sppp.COD_SEGUIMIENTO_PROGRAMA_PRODUCCION_PROCESO")
                                                            .append(" inner join ACTIVIDADES_PRODUCCION ap on ap.COD_ACTIVIDAD = sppp.COD_ACTIVIDAD")
                                                            .append(" left outer join SEGUIMIENTO_PROGRAMA_PRODUCCION_PROCESO_PERSONAL_BANDEJAS sppb on sppp.COD_SEGUIMIENTO_PROGRAMA_PRODUCCION_PROCESO_PERSONAL = sppb.COD_SEGUIMIENTO_PROGRAMA_PRODUCCION_PROCESO_PERSONAL")
                                                            .append(" left outer join personal p on p.COD_PERSONAL = sppp.COD_PERSONAL")
                                                            .append(" left outer join PERSONAL_TEMPORAL pt on pt.COD_PERSONAL = sppp.COD_PERSONAL")
                                                    .append(" where sppp.CANTIDAD_FRV>0")
                                                        .append(" and spp.COD_LOTE_PRODUCCION in (").append(codigosLotes).append(")")
                                                    .append(" order by spp.COD_LOTE_PRODUCCION,nombresPersonal");
                    System.out.println("consulta reporte: "+consulta.toString());
                    Statement st = con.createStatement();
                    ResultSet res = st.executeQuery(consulta.toString());
                    Double cantidadTotal = 0d;
                    String codLoteCabecera = ""; 
                    while(res.next()){
                        if(!codLoteCabecera.equals(res.getString("COD_LOTE_PRODUCCION"))){
                            if(codLoteCabecera.trim().length() > 0){
                                out.println("<tr>");
                                    out.println("<td colspan='3' class='outputTextBold'>Cantidad Total:</td>");
                                    out.println("<td class='tdRight outputTextBold'>"+formato.format(cantidadTotal)+"</td>");
                                out.println("</tr>");
                            }
                            cantidadTotal = 0d;
                            codLoteCabecera = res.getString("COD_LOTE_PRODUCCION");
                        }
                        out.println("<tr>");
                            out.println("<td>"+res.getString("COD_LOTE_PRODUCCION")+"</td>");
                            out.println("<td>"+res.getString("nombresPersonal")+"</td>");
                            out.println("<td>"+res.getString("NOMBRE_ACTIVIDAD")+"</td>");
                            out.println("<td class='tdRight'>"+formato.format(res.getDouble("CANTIDAD_FRV"))+"</td>");
                        out.println("</tr>");
                        cantidadTotal += res.getDouble("CANTIDAD_FRV");
                    }
                    if(codLoteCabecera.trim().length() > 0){
                        out.println("<tr>");
                            out.println("<td colspan='3' class='outputTextBold'>Cantidad Total:</td>");
                            out.println("<td class='tdRight outputTextBold'>"+formato.format(cantidadTotal)+"</td>");
                        out.println("</tr>");
                    }
                    con.close();
                }
                catch(SQLException ex)
                {
                    ex.printStackTrace();
                }
                        
    %>
             <center>
        </form>
    </body>
</html>