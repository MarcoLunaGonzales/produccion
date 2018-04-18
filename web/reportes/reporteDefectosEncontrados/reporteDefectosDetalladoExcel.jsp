<%@ page contentType="application/vnd.ms-excel"%>
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
        <style type="text/css">
            .tablaReporte
            {
                font-family: Verdana, Arial, Helvetica, sans-serif;
                border-left:1px solid #bbbbbb;
                border-top:1px solid #bbbbbb;
                font-family: Verdana, Arial, Helvetica, sans-serif;
                font-size: 11px;
            }
            .tablaReporte tr td
            {
                border-bottom:1px solid #bbbbbb;
                border-right:1px solid #bbbbbb;
                padding: 0.6em;
            }
            .tablaReporte thead tr td
            {
                font-weight: bold;
                background-color:#dddddd;
            }
        </style>
        
    </head>
    <body>
      
        <form>

            <h4 align="center" class="outputText5"><b>Reporte Detallado de Defectos</b></h4>
            <center>
            <table>
                <thead>
                    <tr>
                        <td></td>
                    </tr>
                </thead>
            </table>
            
            <%
                out.println("<table cellpadding='0' cellspacing='0' class='tablaReporte'>");
                    out.println("<thead>");
                        out.println("<tr>");
                            out.println("<td rowspan='2'>Programa de Producción</td>");
                            out.println("<td rowspan='2'>Lote</td>");
                            out.println("<td rowspan='2'>Producto</td>");
                            out.println("<td rowspan='2'>Tipo Producción</td>");
                            out.println("<td rowspan='2'>Personal Acondicionamiento<br>(Inpección de ampollas)</td>");
                            out.println("<td rowspan='2'>Fecha Inicio</td>");
                            out.println("<td rowspan='2'>Fecha Final</td>");
                            out.println("<td rowspan='2'>Personal Envasador</td>");
                            out.println("<td colspan='7' align='center'>Defectos</td>");
                        out.println("</tr><tr>");
                            out.println("<td>Pelusa</td>");
                            out.println("<td>Vidrio</td>");
                            out.println("<td>Carbones y Quemadas</td>");
                            out.println("<td>Globos y defectos de cerrado</td>");
                            out.println("<td>Rajadas</td>");
                            out.println("<td>Mal Serigrafiadas</td>");
                            out.println("<td>Volumen Bajo</td>");
                    out.println("</tr></thead>");
                String codigosLotes=request.getParameter("codigosLotes");
                boolean aplicaFecha=(Integer.valueOf(request.getParameter("aplicaFechaR"))>0);
                String fechaInicio=request.getParameter("fecha_inicio");
                String fechaFinal=request.getParameter("fecha_final");
                String[] fechaArray=fechaInicio.split("/");
                fechaInicio=fechaArray[2]+"/"+fechaArray[1]+"/"+fechaArray[0];
                fechaArray=fechaFinal.split("/");
                fechaFinal=fechaArray[2]+"/"+fechaArray[1]+"/"+fechaArray[0];
                System.out.println("codigos "+codigosLotes);
                NumberFormat numeroformato = NumberFormat.getNumberInstance(Locale.ENGLISH);
                DecimalFormat formato = (DecimalFormat) numeroformato;
                formato.applyPattern("####.##;(####.##)");
                try
                {
                    Connection con=null;
                    
                    con=Util.openConnection(con);
                    Statement st1=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    st1.executeUpdate("set DATEFORMAT ymd");
                    StringBuilder consulta=new StringBuilder("select ppp.NOMBRE_PROGRAMA_PROD,pp.COD_LOTE_PRODUCCION,cp.nombre_prod_semiterminado,tpp.NOMBRE_TIPO_PROGRAMA_PROD,");
                                                        consulta.append(" sppp.FECHA_INICIO,sppp.FECHA_FINAL,isnull(p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL,pt.AP_PATERNO_PERSONAL+' '+pt.AP_MATERNO_PERSONAL+' '+pt.NOMBRES_PERSONAL) as nombrePersonal");
                                                        consulta.append(" ,envasadores.nombreEnvasador,depp1.CANTIDAD_DEFECTOS_ENCONTRADOS as cantPelusa,depp2.CANTIDAD_DEFECTOS_ENCONTRADOS as cantVidrios, ");
                                                        consulta.append(" depp3.CANTIDAD_DEFECTOS_ENCONTRADOS as cantCarbon, depp4.CANTIDAD_DEFECTOS_ENCONTRADOS as cantGlobos, ");
                                                        consulta.append(" depp5.CANTIDAD_DEFECTOS_ENCONTRADOS as cantRajada,depp6.CANTIDAD_DEFECTOS_ENCONTRADOS as cantSerigra, ");
                                                        consulta.append(" depp7.CANTIDAD_DEFECTOS_ENCONTRADOS as cantVoumen ");
                                                consulta.append(" from PROGRAMA_PRODUCCION pp ");
                                                     consulta.append(" inner join COMPONENTES_PROD cp on cp.COD_COMPPROD = pp.COD_COMPPROD ");
                                                     consulta.append(" inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD =pp.COD_TIPO_PROGRAMA_PROD ");
                                                     consulta.append(" inner join PROGRAMA_PRODUCCION_PERIODO ppp on ppp.COD_PROGRAMA_PROD =pp.COD_PROGRAMA_PROD ");
                                                     consulta.append(" inner join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_AREA_EMPRESA =84 ");
                                                                consulta.append(" and afm.COD_ACTIVIDAD = 96  ");
                                                                consulta.append(" and afm.COD_FORMULA_MAESTRA =pp.COD_FORMULA_MAESTRA ");
                                                                consulta.append(" and afm.COD_PRESENTACION = pp.COD_PRESENTACION ");
                                                     consulta.append(" inner join SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sppp on sppp.COD_LOTE_PRODUCCION=pp.COD_LOTE_PRODUCCION ");
                                                                consulta.append(" and sppp.COD_COMPPROD=pp.COD_COMPPROD ");
                                                                consulta.append(" and sppp.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD ");
                                                                consulta.append(" and sppp.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD ");
                                                                consulta.append(" and sppp.COD_ACTIVIDAD_PROGRAMA=afm.COD_ACTIVIDAD_FORMULA ");
                                                                if(aplicaFecha)
                                                                {
                                                                    consulta.append(" and sppp.FECHA_INICIO>='").append(fechaInicio).append(" 00:00'");
                                                                    consulta.append(" and sppp.FECHA_FINAL<='").append(fechaFinal).append(" 23:59'");
                                                                }
                                                     consulta.append(" outer apply ");
                                                     consulta.append("( ");
                                                                consulta.append(" select DISTINCT isnull(p1.AP_PATERNO_PERSONAL+' '+p1.AP_MATERNO_PERSONAL+' '+p1.NOMBRES_PERSONAL,pt1.AP_PATERNO_PERSONAL+' '+pt1.AP_MATERNO_PERSONAL+' '+pt1.NOMBRES_PERSONAL) as nombreEnvasador ");
                                                                        consulta.append(" ,sppp1.COD_PERSONAL as codPersonalEnvasador ");
                                                                consulta.append(" from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sppp1 ");
                                                                            consulta.append(" left outer join personal p1 on p1.COD_PERSONAL=sppp1.COD_PERSONAL ");
                                                                            consulta.append(" left outer join PERSONAL_TEMPORAL pt1 on pt1.COD_PERSONAL=sppp1.COD_PERSONAL ");
                                                                            consulta.append(" inner join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_FORMULA_MAESTRA=sppp1.COD_FORMULA_MAESTRA ");
                                                                                    consulta.append(" and afm.COD_ACTIVIDAD in (29,40,157)	 ");
                                                                consulta.append(" where sppp1.COD_LOTE_PRODUCCION=pp.COD_LOTE_PRODUCCION ");
                                                                            consulta.append(" and sppp1.COD_COMPPROD=pp.COD_COMPPROD ");
                                                                            consulta.append(" and sppp1.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD ");
                                                                            consulta.append(" and sppp1.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD ");
                                                                            consulta.append(" and sppp1.COD_ACTIVIDAD_PROGRAMA=afm.COD_ACTIVIDAD_FORMULA        ");
                                                     consulta.append(") envasadores        ");
                                                     consulta.append(" left outer join personal p on sppp.COD_PERSONAL = p.COD_PERSONAL ");
                                                     consulta.append(" left outer join personal_temporal pt on sppp.COD_PERSONAL = pt.COD_PERSONAL       ");
                                                     consulta.append(" inner join SEGUIMIENTO_INSPECCION_LOTE_ACOND sil on sil.COD_LOTE =pp.COD_LOTE_PRODUCCION ");
                                                                consulta.append(" and sil.COD_COMPPROD = pp.COD_COMPPROD ");
                                                                consulta.append(" and sil.COD_PROGRAMA_PROD = pp.COD_PROGRAMA_PROD ");
                                                                consulta.append(" and sil.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD ");
                                                     consulta.append(" left outer join DEFECTOS_ENVASE_PROGRAMA_PRODUCCION depp1 on  ");
                                                                consulta.append("  depp1.COD_SEGUIMIENTO_INSPECCION_LOTE_ACOND = sil.COD_SEGUIMIENTO_INSPECCION_LOTE_ACOND ");
                                                                consulta.append(" and depp1.COD_PERSONAL = sppp.COD_PERSONAL ");
                                                                consulta.append(" and depp1.COD_PERSONAL_OPERARIO = envasadores.codPersonalEnvasador ");
                                                                consulta.append(" and depp1.COD_REGISTRO_ORDEN_MANUFACTURA= sppp.COD_REGISTRO_ORDEN_MANUFACTURA ");
                                                                consulta.append(" and depp1.COD_DEFECTO_ENVASE=1 ");
                                                     consulta.append(" left outer join DEFECTOS_ENVASE_PROGRAMA_PRODUCCION depp2 on  ");
                                                                consulta.append(" depp2.COD_SEGUIMIENTO_INSPECCION_LOTE_ACOND = sil.COD_SEGUIMIENTO_INSPECCION_LOTE_ACOND ");
                                                                consulta.append(" and depp2.COD_PERSONAL = sppp.COD_PERSONAL ");
                                                                consulta.append(" and depp2.COD_PERSONAL_OPERARIO = envasadores.codPersonalEnvasador ");
                                                                consulta.append(" and depp2.COD_REGISTRO_ORDEN_MANUFACTURA= sppp.COD_REGISTRO_ORDEN_MANUFACTURA ");
                                                                consulta.append(" and depp2.COD_DEFECTO_ENVASE=2 ");
                                                     consulta.append(" left outer join DEFECTOS_ENVASE_PROGRAMA_PRODUCCION depp3 on  ");
                                                                consulta.append(" depp3.COD_SEGUIMIENTO_INSPECCION_LOTE_ACOND = sil.COD_SEGUIMIENTO_INSPECCION_LOTE_ACOND ");
                                                                consulta.append(" and depp3.COD_PERSONAL = sppp.COD_PERSONAL ");
                                                                consulta.append(" and depp3.COD_PERSONAL_OPERARIO = envasadores.codPersonalEnvasador ");
                                                                consulta.append(" and depp3.COD_REGISTRO_ORDEN_MANUFACTURA= sppp.COD_REGISTRO_ORDEN_MANUFACTURA ");
                                                                consulta.append(" and depp3.COD_DEFECTO_ENVASE=3 ");
                                                     consulta.append(" left outer join DEFECTOS_ENVASE_PROGRAMA_PRODUCCION depp4 on  ");
                                                                consulta.append(" depp4.COD_SEGUIMIENTO_INSPECCION_LOTE_ACOND = sil.COD_SEGUIMIENTO_INSPECCION_LOTE_ACOND ");
                                                                consulta.append(" and depp4.COD_PERSONAL = sppp.COD_PERSONAL ");
                                                                consulta.append(" and depp4.COD_PERSONAL_OPERARIO = envasadores.codPersonalEnvasador ");
                                                                consulta.append(" and depp4.COD_REGISTRO_ORDEN_MANUFACTURA= sppp.COD_REGISTRO_ORDEN_MANUFACTURA ");
                                                                consulta.append(" and depp4.COD_DEFECTO_ENVASE=4 ");
                                                     consulta.append(" left outer join DEFECTOS_ENVASE_PROGRAMA_PRODUCCION depp5 on  ");
                                                                consulta.append(" depp5.COD_SEGUIMIENTO_INSPECCION_LOTE_ACOND = sil.COD_SEGUIMIENTO_INSPECCION_LOTE_ACOND ");
                                                                consulta.append(" and depp5.COD_PERSONAL = sppp.COD_PERSONAL ");
                                                                consulta.append(" and depp5.COD_PERSONAL_OPERARIO = envasadores.codPersonalEnvasador ");
                                                                consulta.append(" and depp5.COD_REGISTRO_ORDEN_MANUFACTURA= sppp.COD_REGISTRO_ORDEN_MANUFACTURA ");
                                                                consulta.append(" and depp5.COD_DEFECTO_ENVASE=5 ");
                                                     consulta.append("left outer join DEFECTOS_ENVASE_PROGRAMA_PRODUCCION depp6 on  ");
                                                                consulta.append(" depp6.COD_SEGUIMIENTO_INSPECCION_LOTE_ACOND = sil.COD_SEGUIMIENTO_INSPECCION_LOTE_ACOND ");
                                                                consulta.append(" and depp6.COD_PERSONAL = sppp.COD_PERSONAL ");
                                                                consulta.append(" and depp6.COD_PERSONAL_OPERARIO = envasadores.codPersonalEnvasador ");
                                                                consulta.append(" and depp6.COD_REGISTRO_ORDEN_MANUFACTURA= sppp.COD_REGISTRO_ORDEN_MANUFACTURA ");
                                                                consulta.append(" and depp6.COD_DEFECTO_ENVASE=6 ");
                                                     consulta.append(" left outer join DEFECTOS_ENVASE_PROGRAMA_PRODUCCION depp7 on  ");
                                                                consulta.append(" depp7.COD_SEGUIMIENTO_INSPECCION_LOTE_ACOND = sil.COD_SEGUIMIENTO_INSPECCION_LOTE_ACOND ");
                                                                consulta.append(" and depp7.COD_PERSONAL = sppp.COD_PERSONAL ");
                                                                consulta.append(" and depp7.COD_PERSONAL_OPERARIO = envasadores.codPersonalEnvasador ");
                                                                consulta.append(" and depp7.COD_REGISTRO_ORDEN_MANUFACTURA= sppp.COD_REGISTRO_ORDEN_MANUFACTURA ");
                                                                consulta.append(" and depp7.COD_DEFECTO_ENVASE=7                ");
                                                if(codigosLotes.length()>0)
                                                {
                                                        consulta.append(" where cast (pp.COD_PROGRAMA_PROD as varchar) + '$' + pp.COD_LOTE_PRODUCCION + ");
                                                        consulta.append(" '$' + cast (pp.COD_TIPO_PROGRAMA_PROD as varchar) + '$' + cast (pp.COD_COMPPROD ");
                                                        consulta.append(" as varchar) in (");
                                                                consulta.append(codigosLotes);
                                                        consulta.append(")");
                                                }
                                                consulta.append(" order by ppp.COD_PROGRAMA_PROD,pp.COD_LOTE_PRODUCCION,cp.nombre_prod_semiterminado,tpp.NOMBRE_TIPO_PROGRAMA_PROD,sppp.FECHA_INICIO,sppp.FECHA_FINAL,7,8");
                    System.out.println("consulta cargar segimiento "+consulta.toString());
                    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet res=st.executeQuery(consulta.toString());
                    SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy HH:mm");
                    while(res.next())
                    {
                        out.println("<tr>");
                            out.println("<td>"+res.getString("NOMBRE_PROGRAMA_PROD")+"</td>");
                            out.println("<td>"+res.getString("COD_LOTE_PRODUCCION")+"</td>");
                            out.println("<td>"+res.getString("nombre_prod_semiterminado")+"</td>");
                            out.println("<td>"+res.getString("NOMBRE_TIPO_PROGRAMA_PROD")+"</td>");
                            out.println("<td>"+res.getString("nombrePersonal")+"</td>");
                            out.println("<td>"+sdf.format(res.getTimestamp("FECHA_INICIO"))+"</td>");
                            out.println("<td>"+sdf.format(res.getTimestamp("FECHA_FINAL"))+"</td>");
                            out.println("<td>"+res.getString("nombreEnvasador")+"</td>");
                            out.println("<td>"+res.getInt("cantPelusa")+"</td>");
                            out.println("<td>"+res.getInt("cantVidrios")+"</td>");
                            out.println("<td>"+res.getInt("cantCarbon")+"</td>");
                            out.println("<td>"+res.getInt("cantGlobos")+"</td>");
                            out.println("<td>"+res.getInt("cantRajada")+"</td>");
                            out.println("<td>"+res.getInt("cantSerigra")+"</td>");
                            out.println("<td>"+res.getInt("cantVoumen")+"</td>");
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