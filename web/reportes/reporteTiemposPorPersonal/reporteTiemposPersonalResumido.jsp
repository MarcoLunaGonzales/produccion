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
            .outputTextNormal
            {
                font-family: Verdana, Arial, Helvetica, sans-serif;
                font-size: 9px;
                font-weight: normal;
            }
            .max
            {
                background-color:blue;
            }
            .domingo
            {
                background-color: #f6ecbf;
            }
        </style>
    </head>

    <body>
        
        <form>
            
            <h4 align="center" class="outputText5"><b>Reporte de Tiempos Por Personal Resumido</b></h4>
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
               
            <table id="tablaReporte" width="70%" align="center" class="tablaReporte"  cellpadding="0" cellspacing="0" >

                    <%
                        String[] diasSemana={"LUNES","MARTES","MIERCOLES","JUEVES","VIERNES","SABADO","DOMINGO"};
                        NumberFormat numeroformato = NumberFormat.getNumberInstance(Locale.ENGLISH);
                        DecimalFormat formato = (DecimalFormat) numeroformato;
                        formato.applyPattern("####.##;(####.##)");
                        String[] arrayFecha=fechaInicio.split("/");
                        fechaInicio=arrayFecha[2]+"/"+arrayFecha[1]+"/"+arrayFecha[0];
                        arrayFecha=fechaFinal.split("/");
                        fechaFinal=arrayFecha[2]+"/"+arrayFecha[1]+"/"+arrayFecha[0];
                        
                        Connection con=null;
                        try
                        {
                            con=Util.openConnection(con);
                            StringBuilder consulta=new StringBuilder(" set NOCOUNT on;IF OBJECT_ID (N'AUX_FECHAS_RPT', N'U') IS NOT NULL");
                                                        consulta.append(" DROP TABLE AUX_FECHAS_RPT");
                                                        consulta.append(" CREATE TABLE AUX_FECHAS_RPT(COD_PERSONAL integer,FECHA_REPORTE DATETIME )");
                                                        consulta.append(" declare @fechaInicioReporte datetime='").append(fechaInicio).append(" 00:00'");
                                                        consulta.append(" declare @fechaFinalReporte datetime='").append(fechaFinal).append(" 23:59'");
                                                        consulta.append(" declare @fechaRegistroAux datetime=@fechaInicioReporte");

                                                        consulta.append(" while @fechaRegistroAux<=@fechaFinalReporte");
                                                        consulta.append(" begin");
                                                                consulta.append(" INSERT INTO AUX_FECHAS_RPT (COD_PERSONAL,FECHA_REPORTE) VALUES(1,@fechaRegistroAux)");
                                                            consulta.append(" set @fechaRegistroAux=DATEADD(day,1,@fechaRegistroAux)");
                                                        consulta.append(" end set NOCOUNT off ");
                                                        PreparedStatement pst=con.prepareStatement(consulta.toString());
                                                        pst.executeUpdate();
                                                        consulta=new StringBuilder(" select detalleFechaDia.COD_PERSONAL,detalleFechaDia.nombrePersonal,detalleFechaDia.FECHA_REPORTE,DATEPART(dw,detalleFechaDia.FECHA_REPORTE) AS diaSemana,sum(detalleTiempo.HORAS_HOMBRE) as sumaReporte");
                                                        consulta.append(" from (");
                                                                        consulta.append(" select DISTINCT pap.COD_PERSONAL,isnull(p.AP_PATERNO_PERSONAL + ' ' + p.AP_MATERNO_PERSONAL + ' ' +p.NOMBRES_PERSONAL, pt.AP_PATERNO_PERSONAL + ' ' +pt.AP_MATERNO_PERSONAL + ' ' + pt.NOMBRES_PERSONAL) as nombrePersonal,");
                                                                        consulta.append(" afm.FECHA_REPORTE");
                                                                        consulta.append(" from AUX_FECHAS_RPT afm,");
                                                                        consulta.append(" PERSONAL_AREA_PRODUCCION pap");
                                                                        consulta.append(" left outer join personal p on p.COD_PERSONAL = pap.COD_PERSONAL");
                                                                        consulta.append(" left outer join PERSONAL_TEMPORAL pt on pt.COD_PERSONAL =pap.COD_PERSONAL");
                                                                        consulta.append(" where pap.COD_PERSONAL IN (").append(request.getParameter("codPersonalReporte")).append(")");
                                                                        consulta.append(" and pap.COD_ESTADO_PERSONAL_AREA_PRODUCCION=1");
                                                             consulta.append(" ) as detalleFechaDia");
                                                             consulta.append(" left outer join ");
                                                             consulta.append(" (");
                                                                consulta.append(" select sppp.COD_PERSONAL,sppp.HORAS_HOMBRE,sppp.FECHA_INICIO,sppp.COD_ACTIVIDAD_PROGRAMA");
                                                                        consulta.append(",sppp.[INDEX] as codigo,1 as tipoTiempo");
                                                               consulta.append(" from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sppp");
                                                                    consulta.append(" inner join PROGRAMA_PRODUCCION pp on pp.COD_PROGRAMA_PROD =");
                                                                    consulta.append(" sppp.COD_PROGRAMA_PROD and sppp.COD_LOTE_PRODUCCION =");
                                                                    consulta.append(" pp.COD_LOTE_PRODUCCION and sppp.COD_TIPO_PROGRAMA_PROD =");
                                                                    consulta.append(" pp.COD_TIPO_PROGRAMA_PROD and sppp.COD_COMPPROD =pp.COD_COMPPROD");
                                                                    consulta.append(" inner join COMPONENTES_PROD_VERSION cpv on cpv.COD_COMPPROD =");
                                                                    consulta.append(" pp.COD_COMPPROD and cpv.COD_VERSION = pp.COD_COMPPROD_VERSION");
                                                                    consulta.append(" inner join ACTIVIDADES_FORMULA_MAESTRA afm on");
                                                                    consulta.append(" afm.COD_FORMULA_MAESTRA = sppp.COD_FORMULA_MAESTRA and");
                                                                    consulta.append(" afm.COD_ACTIVIDAD_FORMULA = sppp.COD_ACTIVIDAD_PROGRAMA");
                                                               consulta.append(" where sppp.FECHA_INICIO BETWEEN '").append(fechaInicio).append(" 00:00' and '").append(fechaFinal).append(" 23:59' ");
                                                                     consulta.append(" and sppp.COD_PERSONAL in (").append(request.getParameter("codPersonalReporte")).append(")");
                                                               consulta.append(" union");
                                                               consulta.append(" select sppi.COD_PERSONAL,sppi.HORAS_HOMBRE,sppi.FECHA_INICIO,sppi.COD_ACTVIDAD as COD_ACTIVIDAD_PROGRAMA");
                                                                        consulta.append(" ,sppi.COD_SEGUIMIENTO_PROGRAMA_PRODUCCION_INDIRECTO_PERSONAL as codigo,2 as tipoTiempo");
                                                               consulta.append(" from SEGUIMIENTO_PROGRAMA_PRODUCCION_INDIRECTO_PERSONAL sppi");
                                                               consulta.append(" where sppi.FECHA_INICIO BETWEEN '").append(fechaInicio).append(" 00:00' and '").append(fechaFinal).append(" 23:59' ");
                                                                     consulta.append(" and sppi.COD_PERSONAL in (").append(request.getParameter("codPersonalReporte")).append(")");
                                                             consulta.append(" ) as detalleTiempo on detalleTiempo.COD_PERSONAL = detalleFechaDia.COD_PERSONAL");
                                                             consulta.append(" and detalleTiempo.FECHA_INICIO BETWEEN detalleFechaDia.FECHA_REPORTE and dateadd(minute,-1,dateadd(day,1,detalleFechaDia.FECHA_REPORTE))");
                                                        consulta.append(" group by detalleFechaDia.COD_PERSONAL,detalleFechaDia.nombrePersonal,detalleFechaDia.FECHA_REPORTE");
                                                        consulta.append(" order by detalleFechaDia.nombrePersonal,detalleFechaDia.FECHA_REPORTE");
                            System.out.println("consulta datos "+consulta.toString());
                            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                            ResultSet res=st.executeQuery(consulta.toString());
                            int codPersonalCabecera=0;
                            SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy");
                            SimpleDateFormat sdfHora=new SimpleDateFormat("HH:mm");
                            out.println("<thead><tr><td rowspan='2'>Personal</td><td colspan='111' class='tdCenter'>Resumen por dia</td></tr><tr>");
                            StringBuilder detalle=new StringBuilder("");
                            StringBuilder detalleCabecera=new StringBuilder("");
                            boolean mostrarCabecera=true;
                            while(res.next())
                            {
                                if(res.getInt("COD_PERSONAL")!=codPersonalCabecera)
                                {
                                    if(codPersonalCabecera>0)
                                    {
                                        if(mostrarCabecera)
                                        {
                                            out.println(detalleCabecera);
                                            out.println("</tr></thead>");
                                            mostrarCabecera=false;
                                        }
                                        out.println("<tr>"+detalle.toString()+"</tr>");
                                    }
                                    codPersonalCabecera=res.getInt("COD_PERSONAL");
                                    detalle=new StringBuilder("<td>"+res.getString("nombrePersonal")+"</td>");
                                }
                                detalleCabecera.append("<td class='tdCenter'>"+diasSemana[res.getInt("diaSemana")-1]+"<br>"+sdf.format(res.getTimestamp("FECHA_REPORTE"))+"</td>");
                                detalle.append("<td class='tdRight "+(res.getInt("diaSemana")==7?"domingo":"")+"'>"+formato.format(res.getDouble("sumaReporte"))+"</td>");
                                
                            }
                            if(codPersonalCabecera>0)
                            {
                                if(mostrarCabecera)
                                {
                                    out.println(detalleCabecera);
                                    out.println("</tr></thead>");
                                    mostrarCabecera=false;
                                }
                                out.println("<tr>"+detalle.toString()+"</tr>");
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