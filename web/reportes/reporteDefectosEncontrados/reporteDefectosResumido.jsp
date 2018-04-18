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

            <h4 align="center" class="outputText5"><b>Reporte Resumido de Defectos</b></h4>
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
                            out.println("<td>Lote</td>");
                            out.println("<td>Datos Defectos</td>");
                        out.println("</tr>");
                    out.println("</thead>");
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
                    StringBuilder consulta=new StringBuilder("select sppp.COD_PERSONAL,ISNULL(p.AP_PATERNO_PERSONAL+'<br/>'+p.AP_MATERNO_PERSONAL+'<br/>'+p.NOMBRES_PERSONAL,pt.AP_PATERNO_PERSONAL+'<br/>'+pt.AP_MATERNO_PERSONAL+'<br/>'+pt.NOMBRES_PERSONAL) as nombrePersonal");
                                consulta.append(" from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sppp ");
                                consulta.append(" inner join ACTIVIDADES_FORMULA_MAESTRA afm on sppp.COD_ACTIVIDAD_PROGRAMA = afm.COD_ACTIVIDAD_FORMULA");
                                consulta.append(" inner join ACTIVIDADES_PRODUCCION ap on ap.COD_ACTIVIDAD=afm.COD_ACTIVIDAD");
                                consulta.append(" and ap.COD_ACTIVIDAD in (29,40,157)");
                                consulta.append(" LEFT OUTER join personal p on sppp.COD_PERSONAL=p.COD_PERSONAL");
                                consulta.append(" LEFT OUTER join personal_TEMPORAL pt on sppp.COD_PERSONAL=pt.COD_PERSONAL");
                                consulta.append(" where sppp.COD_COMPPROD=?");
                                consulta.append(" and sppp.COD_LOTE_PRODUCCION=?");
                                consulta.append(" and sppp.COD_FORMULA_MAESTRA=?");
                                consulta.append(" and sppp.COD_PROGRAMA_PROD=?");
                                consulta.append(" and sppp.COD_TIPO_PROGRAMA_PROD=?");
                                consulta.append(" group by SPPP.COD_PERSONAL,p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRES_PERSONAL,");
                                consulta.append(" pt.AP_PATERNO_PERSONAL,pt.AP_MATERNO_PERSONAL,pt.NOMBRES_PERSONAL");
                                consulta.append(" order by 2");
                    PreparedStatement pstOpe=con.prepareStatement(consulta.toString());
                    consulta=new StringBuilder("select distinct pp.COD_PROGRAMA_PROD,pp.COD_COMPPROD,pp.COD_TIPO_PROGRAMA_PROD,pp.COD_FORMULA_MAESTRA,pp.COD_LOTE_PRODUCCION");
                                    consulta.append(" ,afm.COD_ACTIVIDAD_FORMULA as codActividadInspeccion,tpp.NOMBRE_TIPO_PROGRAMA_PROD");
                                    consulta.append(" ,sil.COD_SEGUIMIENTO_INSPECCION_LOTE_ACOND,cp.nombre_prod_semiterminado");
                                consulta.append(" from PROGRAMA_PRODUCCION pp");
                                    consulta.append(" inner join COMPONENTES_PROD cp on cp.COD_COMPPROD=pp.COD_COMPPROD");
                                    consulta.append(" inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD");
                                    consulta.append(" inner join PROGRAMA_PRODUCCION_PERIODO ppp on ppp.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD");
                                    consulta.append(" left outer join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_AREA_EMPRESA =84 and afm.COD_ACTIVIDAD = 96");
                                            consulta.append(" and afm.COD_FORMULA_MAESTRA =pp.COD_FORMULA_MAESTRA");
                                            consulta.append(" and afm.COD_PRESENTACION = pp.COD_PRESENTACION");
                                    consulta.append(" inner join SEGUIMIENTO_INSPECCION_LOTE_ACOND sil on sil.COD_LOTE=pp.COD_LOTE_PRODUCCION and sil.COD_COMPPROD=pp.COD_COMPPROD");
                                        consulta.append(" and sil.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD and sil.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD");
                                    if(aplicaFecha)
                                    {
                                        consulta.append(" inner join SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sppp on sppp.COD_LOTE_PRODUCCION=pp.COD_LOTE_PRODUCCION ");
                                                                consulta.append(" and sppp.COD_COMPPROD=pp.COD_COMPPROD ");
                                                                consulta.append(" and sppp.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD ");
                                                                consulta.append(" and sppp.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD ");
                                                                consulta.append(" and sppp.COD_ACTIVIDAD_PROGRAMA=afm.COD_ACTIVIDAD_FORMULA ");
                                                                consulta.append(" and sppp.FECHA_INICIO>='").append(fechaInicio).append(" 00:00'");
                                                                consulta.append(" and sppp.FECHA_FINAL<='").append(fechaFinal).append(" 23:59'");
                                    }    
                                if(codigosLotes.length()>0)
                                {
                                        consulta.append( " where cast(pp.COD_PROGRAMA_PROD as varchar)+'$'+pp.COD_LOTE_PRODUCCION+'$'+cast(pp.COD_TIPO_PROGRAMA_PROD as varchar)+'$'+cast(pp.COD_COMPPROD as varchar)");
                                            consulta.append(" in (").append(codigosLotes).append(")");
                                }
                    System.out.println("consulta cargar prograsmas"+consulta.toString());
                    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    Statement stDetalle=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet res=st.executeQuery(consulta.toString());
                    ResultSet resDetalle;
                    SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy HH:mm");
                    while(res.next())
                    {
                        pstOpe.setInt(1,res.getInt("COD_COMPPROD"));
                        pstOpe.setString(2,res.getString("COD_LOTE_PRODUCCION"));
                        pstOpe.setInt(3, res.getInt("COD_FORMULA_MAESTRA"));
                        pstOpe.setInt(4,res.getInt("COD_PROGRAMA_PROD"));
                        pstOpe.setInt(5,res.getInt("COD_TIPO_PROGRAMA_PROD"));
                        resDetalle=pstOpe.executeQuery();
                        consulta=new StringBuilder("");
                        StringBuilder cabeceras=new StringBuilder("");
                        int cantidadEnvasadores=0;
                        out.println("<tr>");
                        out.println("<td align='left'><b>Lote:</b><br>"+res.getString("COD_LOTE_PRODUCCION")+"<br><b>Producto:</b><br>"+res.getString("nombre_prod_semiterminado")+"<br><b>Tipo Programa Producción:</b><br>"+res.getString("NOMBRE_TIPO_PROGRAMA_PROD")+"</td>");
                        out.println("<td>");
                            out.println("<table cellpadding='0' cellspacing='0' class='tablaReporte'>");
                                out.println("<thead>");
                                    out.println("<tr>");
                                        out.println("<td>Defecto</td>");
                                    
                        while(resDetalle.next())
                        {
                            out.println("<td>"+resDetalle.getString("nombrePersonal")+"</td>");
                            cabeceras.append(",isnull((select sum(depp").append(resDetalle.getRow()).append(".CANTIDAD_DEFECTOS_ENCONTRADOS)");
                            cabeceras.append(" from DEFECTOS_ENVASE_PROGRAMA_PRODUCCION depp").append(resDetalle.getRow());
                            if(aplicaFecha)
                            {
                                cabeceras.append(" inner join SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sppp on sppp.COD_REGISTRO_ORDEN_MANUFACTURA=depp").append(resDetalle.getRow()).append(".COD_REGISTRO_ORDEN_MANUFACTURA");
                                        cabeceras.append(" and sppp.COD_PERSONAL=depp").append(resDetalle.getRow()).append(".COD_PERSONAL");
                                        cabeceras.append(" and sppp.COD_PROGRAMA_PROD=").append(res.getInt("COD_PROGRAMA_PROD"));
                                        cabeceras.append(" and sppp.COD_LOTE_PRODUCCION='").append(res.getString("COD_LOTE_PRODUCCION")).append("'");
                                        cabeceras.append(" and sppp.COD_COMPPROD=").append(res.getInt("COD_COMPPROD"));
                                        cabeceras.append(" and sppp.COD_TIPO_PROGRAMA_PROD=").append(res.getInt("COD_TIPO_PROGRAMA_PROD"));
                                        cabeceras.append(" and sppp.FECHA_INICIO>='").append(fechaInicio).append(" 00:00'");
                                        cabeceras.append(" and sppp.FECHA_FINAL<='").append(fechaFinal).append(" 23:59'");
                            }
                            cabeceras.append(" where depp").append(resDetalle.getRow()).append(".COD_DEFECTO_ENVASE=de.COD_DEFECTO_ENVASE ");
                                cabeceras.append(" and depp").append(resDetalle.getRow()).append(".COD_SEGUIMIENTO_INSPECCION_LOTE_ACOND=").append(res.getInt("COD_SEGUIMIENTO_INSPECCION_LOTE_ACOND"));
                                cabeceras.append(" and depp").append(resDetalle.getRow()).append(".COD_PERSONAL_OPERARIO=").append(resDetalle.getInt("COD_PERSONAL")).append("),0) AS CANTIDAD_DEFECTOS_ENCONTRADOS").append(resDetalle.getRow());
                            cantidadEnvasadores++;
                        }
                                        out.println("</tr>");
                                    out.println("</thead>");
                        resDetalle=stDetalle.executeQuery("select de.COD_DEFECTO_ENVASE,de.NOMBRE_DEFECTO_ENVASE "+cabeceras+
                                                         " from DEFECTOS_ENVASE de  where de.cod_estado_registro=1" +
                                                         " group by de.COD_DEFECTO_ENVASE,de.NOMBRE_DEFECTO_ENVASE,de.ORDEN order by de.ORDEN");
                        System.out.println("select de.COD_DEFECTO_ENVASE,de.NOMBRE_DEFECTO_ENVASE "+cabeceras+
                                                         " from DEFECTOS_ENVASE de  where de.cod_estado_registro=1" +
                                                         " group by de.COD_DEFECTO_ENVASE,de.NOMBRE_DEFECTO_ENVASE,de.ORDEN order by de.ORDEN");
                            while(resDetalle.next())
                            {
                                out.println("<tr>");
                                    out.println("<td>"+resDetalle.getString("NOMBRE_DEFECTO_ENVASE")+"</td>");
                                    for(int i=1;i<=cantidadEnvasadores;i++)
                                    {
                                        out.println("<td>"+resDetalle.getInt("CANTIDAD_DEFECTOS_ENCONTRADOS"+i)+"</td>");
                                    }
                                out.println("</tr>");
                            }
                            out.println("</table>");
                        out.println("</td>");
                        out.println("</tr>");
                        
                    }
                    out.println("</table>");
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