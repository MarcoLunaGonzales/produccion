<%@page import="javax.faces.context.FacesContext"%>
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
        <script src="../../js/general.js"></script>
        <style>
            .outputTextNormal{
                font-family: Verdana, Arial, Helvetica, sans-serif;
                font-size: 9px;
                font-weight: normal;
            }
            .max{
                background-color:blue;
            }
        </style>
    </head>

    <body>
        
        <form>
            
            <h4 align="center" class="outputText5"><b>Reporte de Tiempos Por Personal Detallado</b></h4>
            <%
                String fechaInicio=request.getParameter("fecha_inicio");
                String fechaFinal=request.getParameter("fecha_final");
            %>

            <br>
                <center>
                    <table align="center" width="70%" class='outputText0'>
                <tr>
                    <td width="10%">
                        <img src="../../img/cofar.png">
                    </td>
                    <td align="center" width="80%">
                        <table class="outputTextNormal">
                            <tr>
                                <td align="left"><b>Fecha Inicio:</b></td>
                                <td align="left"><%=(fechaInicio)%></td>
                            </tr>
                            <tr>
                                <td align="left"><b>Fecha Final:</b></td>
                                <td align="left"><%=(fechaFinal)%></td>
                            </tr>
                           
                        </table>
                    </td>
                <td align="center" >
                </td>
                </tr>
            </table>
            <br/>
               
            <table id="tablaReporte" width="70%" align="center" class="tablaReporte" style="border : solid #000000 1px;" cellpadding="0" cellspacing="0" >

                    <%
                        NumberFormat numeroformato = NumberFormat.getNumberInstance(Locale.ENGLISH);
                        DecimalFormat formato = (DecimalFormat) numeroformato;
                        formato.applyPattern("####.##;(####.##)");
                        String[] arrayFecha=fechaInicio.split("/");
                        fechaInicio=arrayFecha[2]+"/"+arrayFecha[1]+"/"+arrayFecha[0];
                        arrayFecha=fechaFinal.split("/");
                        fechaFinal=arrayFecha[2]+"/"+arrayFecha[1]+"/"+arrayFecha[0];
                        
                        Connection con=null;
                        try{
                            con=Util.openConnection(con);
                            StringBuilder consulta=new StringBuilder("select personalArea.COD_PERSONAL,personalArea.nombrePersonal");
                                                        consulta.append(" ,detalleTiempo.tipoTiempo,detalleTiempo.NOMBRE_ACTIVIDAD,detalleTiempo.COD_LOTE_PRODUCCION,detalleTiempo.nombreProd,detalleTiempo.FECHA_INICIO,detalleTiempo.FECHA_FINAL");
                                                        consulta.append(" ,isnull(detalleTiempo.HORAS_HOMBRE,0) as horasHombre");
                                                    consulta.append(" from (select distinct pap.COD_PERSONAL,isnull(p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL,pt.AP_PATERNO_PERSONAL+' '+pt.AP_MATERNO_PERSONAL+' '+pt.NOMBRES_PERSONAL) as nombrePersonal");
                                                        consulta.append(" from PERSONAL_AREA_PRODUCCION pap");
                                                        consulta.append(" left outer join personal p on p.COD_PERSONAL=pap.COD_PERSONAL");
                                                        consulta.append(" left outer join PERSONAL_TEMPORAL pt on pt.COD_PERSONAL=pap.COD_PERSONAL");
                                                        consulta.append(" where pap.COD_ESTADO_PERSONAL_AREA_PRODUCCION = 1");
                                                                consulta.append(" and pap.COD_PERSONAL IN (").append(request.getParameter("codPersonalReporte")).append(")");
                                                        consulta.append(" ) as personalArea ");
                                                        consulta.append(" left outer join");
                                                        consulta.append(" (");
                                                                consulta.append(" select sppp.COD_PERSONAL,'TIEMPO DIRECTO' as tipoTiempo,ap.NOMBRE_ACTIVIDAD,pp.COD_LOTE_PRODUCCION,cpv.nombre_prod_semiterminado as nombreProd,sppp.FECHA_INICIO,sppp.FECHA_FINAL,");
                                                                consulta.append(" sppp.HORAS_HOMBRE,sppp.[INDEX] as codigo");
                                                            consulta.append(" from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sppp");
                                                                consulta.append(" inner join PROGRAMA_PRODUCCION pp on pp.COD_PROGRAMA_PROD =sppp.COD_PROGRAMA_PROD");
                                                                                consulta.append(" and sppp.COD_LOTE_PRODUCCION=pp.COD_LOTE_PRODUCCION");
                                                                        consulta.append(" and sppp.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD");
                                                                        consulta.append(" and sppp.COD_COMPPROD=pp.COD_COMPPROD");
                                                                consulta.append(" inner join COMPONENTES_PROD_VERSION cpv on cpv.COD_COMPPROD=pp.COD_COMPPROD");
                                                                                consulta.append(" and cpv.COD_VERSION=pp.COD_COMPPROD_VERSION");
                                                                consulta.append(" inner join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_FORMULA_MAESTRA=sppp.COD_FORMULA_MAESTRA");
                                                                                consulta.append(" and afm.COD_ACTIVIDAD_FORMULA=sppp.COD_ACTIVIDAD_PROGRAMA");
                                                                consulta.append(" inner join ACTIVIDADES_PRODUCCION ap on ap.COD_ACTIVIDAD=afm.COD_ACTIVIDAD");
                                                            consulta.append(" where sppp.FECHA_INICIO BETWEEN '").append(fechaInicio).append(" 00:00' and '").append(fechaFinal).append(" 23:59'");
                                                            consulta.append(" union");
                                                            consulta.append(" select sppi.COD_PERSONAL,'TIEMPO INDIRECTO' as tipoTiempo,ap.NOMBRE_ACTIVIDAD ,'N.A.' as COD_LOTE_PRODUCCION,'N.A.' as nombreProd,sppi.FECHA_INICIO,sppi.FECHA_FINAL,sppi.HORAS_HOMBRE,sppi.COD_SEGUIMIENTO_PROGRAMA_PRODUCCION_INDIRECTO_PERSONAL as codigo");
                                                            consulta.append(" from SEGUIMIENTO_PROGRAMA_PRODUCCION_INDIRECTO_PERSONAL sppi");
                                                                consulta.append(" inner join ACTIVIDADES_PRODUCCION ap on ap.COD_ACTIVIDAD=sppi.COD_ACTVIDAD");
                                                                
                                                            consulta.append(" where sppi.FECHA_INICIO BETWEEN '").append(fechaInicio).append(" 00:00' and '").append(fechaFinal).append(" 23:59'");
                                                        consulta.append(" ) as detalleTiempo on detalleTiempo.COD_PERSONAL=personalArea.COD_PERSONAL");
                                                    consulta.append(" order by personalArea.nombrePersonal,personalArea.COD_PERSONAL,detalleTiempo.FECHA_INICIO");
                            System.out.println("consulta datos "+consulta.toString());
                            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                            ResultSet res=st.executeQuery(consulta.toString());
                            int codPersonalCabecera=0;
                            SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy");
                            SimpleDateFormat sdfHora=new SimpleDateFormat("HH:mm");
                            Double sumaHorasHombre=0d;
                            while(res.next())
                            {
                                if(codPersonalCabecera!=res.getInt("COD_PERSONAL"))
                                {
                                    if(codPersonalCabecera>0)
                                    {
                                        out.println("<tr class='separador'><td class='tdRight' colspan='7'>Horas Registradas:</td><td class='tdRight'>"+formato.format(sumaHorasHombre)+"</td></tr>");
                                        out.println("</tbody>");
                                    }
                                    out.println("<thead><tr>");
                                        out.println("<td colspan='8' class='tdCenter' >"+res.getString("nombrePersonal")+"</td>");
                                    out.println("</tr><tr><td>Tipo Tiempo</td><td>Actividad</td><td>Lote</td><td>Producto</td><td>Fecha</td><td>Hora Inicio</td><td>Hora Final</td><td>Horas Hombre</td></tr></thead><tbody>");
                                    codPersonalCabecera=res.getInt("COD_PERSONAL");
                                    sumaHorasHombre=0d;
                                }
                                if(res.getDouble("horasHombre")>0)
                                {
                                        out.println("<tr>");
                                            out.println("<td>"+res.getString("tipoTiempo")+"</td>");
                                            out.println("<td>"+res.getString("NOMBRE_ACTIVIDAD")+"</td>");
                                            out.println("<td>"+res.getString("COD_LOTE_PRODUCCION")+"</td>");
                                            out.println("<td>"+res.getString("nombreProd")+"</td>");
                                            out.println("<td>"+sdf.format(res.getTimestamp("FECHA_INICIO"))+"</td>");
                                            out.println("<td>"+sdfHora.format(res.getTimestamp("FECHA_INICIO"))+"</td>");
                                            out.println("<td>"+sdfHora.format(res.getTimestamp("FECHA_FINAL"))+"</td>");
                                            out.println("<td class='tdRight'>"+formato.format(res.getDouble("horasHombre"))+"</td>");
                                        out.println("</tr>");
                                        sumaHorasHombre+=res.getDouble("horasHombre");
                                }
                            }
                            if(codPersonalCabecera>0)
                            {
                                out.println("<tr class='separador'><td class='tdRight' colspan='7'>Horas Registradas:</td><td class='tdRight'>"+formato.format(sumaHorasHombre)+"</td></tr>");
                                out.println("</tbody>");
                            }
                        }
                        catch(SQLException ex)
                        {
                            ex.printStackTrace();
                        }
                        catch(Exception e)
                        {
                            e.printStackTrace();
                        }
                        finally
                        {
                            con.close();
                        }
                    %>
                    
            </table>       
            
        </form>
    </body>
</html>