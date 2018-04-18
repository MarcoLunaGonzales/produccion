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
        <link rel="STYLESHEET" type="text/css" href="../../../css/ventas.css" />
        
    </head>
    <body>
      
        <form>

            <h4 align="center" class="outputText5"><b>Reporte de Ampollas Frv(Lavado)</b></h4>
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
                            out.println("<td>Producto</td>");
                            out.println("<td>Tipo Producción</td>");
                            out.println("<td>Personal</td>");
                            out.println("<td>Fecha Inicio</td>");
                            out.println("<td>Fecha Final</td>");
                            out.println("<td>Horas Hombre</td>");
                            out.println("<td>Ampollas Frv</td>");
                        out.println("</tr>");
                    out.println("</thead>");
                String codigosLotes=request.getParameter("codigosLotes");
                System.out.println("codigos "+codigosLotes);
                NumberFormat numeroformato = NumberFormat.getNumberInstance(Locale.ENGLISH);
                DecimalFormat formato = (DecimalFormat) numeroformato;
                formato.applyPattern("####.##;(####.##)");
                try
                {
                    Connection con=null;
                    String url="jdbc:sqlserver://172.16.10.21;user=sa;password=m0t1t4s@2009;databaseName=SARTORIUSACONDICIONAMIENTO";
                    con=DriverManager.getConnection(url);
                    Statement st1=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    st1.executeUpdate("set DATEFORMAT ymd");
                    StringBuilder consulta=new StringBuilder("select p.AP_PATERNO_PERSONAL + ' ' + p.AP_MATERNO_PERSONAL + ' ' +p.NOMBRES_PERSONAL + ' ' + p.nombre2_personal as nombrePersonal,");
                                                    consulta.append(" s.FECHA_INICIO,s.FECHA_FINAL,s.HORAS_HOMBRE,s.UNIDADES_PRODUCIDAS,s.UNIDADES_FRV");
                                                consulta.append(" from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL s");
                                                    consulta.append(" inner join personal p on p.COD_PERSONAL = s.COD_PERSONAL");
                                                consulta.append(" where s.COD_COMPPROD =?");
                                                    consulta.append(" and s.COD_PROGRAMA_PROD =?");
                                                    consulta.append(" and s.COD_TIPO_PROGRAMA_PROD =?");
                                                    consulta.append(" and s.COD_ACTIVIDAD_PROGRAMA =?");
                                                    consulta.append(" and s.COD_LOTE_PRODUCCION =?");
                                                    consulta.append(" and s.UNIDADES_FRV>0");
                                                consulta.append(" order by s.FECHA_INICIO");
                    PreparedStatement pst=con.prepareStatement(consulta.toString());
                    consulta=new StringBuilder("select pp.COD_PROGRAMA_PROD,pp.COD_COMPPROD,pp.COD_TIPO_PROGRAMA_PROD,pp.COD_FORMULA_MAESTRA,pp.COD_LOTE_PRODUCCION");
                                    consulta.append(" ,afm.COD_ACTIVIDAD_FORMULA as codActividadLavado,tpp.NOMBRE_TIPO_PROGRAMA_PROD");
                                    consulta.append(" ,cp.nombre_prod_semiterminado");
                                consulta.append(" from PROGRAMA_PRODUCCION pp");
                                    consulta.append(" inner join COMPONENTES_PROD cp on cp.COD_COMPPROD=pp.COD_COMPPROD");
                                    consulta.append(" inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD");
                                    consulta.append(" inner join PROGRAMA_PRODUCCION_PERIODO ppp on ppp.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD");
                                    consulta.append(" left outer join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_FORMULA_MAESTRA= pp.COD_FORMULA_MAESTRA and afm.COD_AREA_EMPRESA = 84");
                                    consulta.append(" and afm.COD_ACTIVIDAD = 110 and afm.COD_PRESENTACION = 0");
                                    
                                consulta.append( " where cast(pp.COD_PROGRAMA_PROD as varchar)+'$'+pp.COD_LOTE_PRODUCCION+'$'+cast(pp.COD_TIPO_PROGRAMA_PROD as varchar)+'$'+cast(pp.COD_COMPPROD as varchar)");
                                    consulta.append(" in (").append(codigosLotes).append(")");
                    System.out.println("consulta cargar prograsmas"+consulta.toString());
                    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet res=st.executeQuery(consulta.toString());
                    ResultSet resDetalle;
                    StringBuilder innerHTML;
                    int cantidadFilas;
                    SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy HH:mm");
                    int cantidadTotaLote=0;
                    while(res.next())
                    {
                        pst.setInt(1,res.getInt("COD_COMPPROD"));
                        pst.setInt(2,res.getInt("COD_PROGRAMA_PROD"));
                        pst.setInt(3,res.getInt("COD_TIPO_PROGRAMA_PROD"));
                        pst.setInt(4,res.getInt("codActividadLavado"));
                        pst.setString(5,res.getString("COD_LOTE_PRODUCCION"));
                        resDetalle=pst.executeQuery();
                        innerHTML=new StringBuilder("");
                        cantidadTotaLote=0;
                        cantidadFilas=0;
                        while(resDetalle.next())
                        {
                                if(innerHTML.length()>0)
                                    innerHTML.append("<tr>");
                                innerHTML.append("<td>").append(resDetalle.getString("nombrePersonal")).append("</td>");
                                innerHTML.append("<td>").append(sdf.format(resDetalle.getTimestamp("FECHA_INICIO"))).append("</td>");
                                innerHTML.append("<td>").append(sdf.format(resDetalle.getTimestamp("FECHA_FINAL"))).append("</td>");
                                innerHTML.append("<td>").append(formato.format(resDetalle.getDouble("HORAS_HOMBRE"))).append("</td>");
                                innerHTML.append("<td>").append(resDetalle.getInt("UNIDADES_FRV")).append("</td>");
                            innerHTML.append("</tr>");
                            cantidadFilas++;
                            cantidadTotaLote+=resDetalle.getInt("UNIDADES_FRV");
                        }
                        if(cantidadFilas==0)
                        {
                            cantidadFilas=1;
                                innerHTML.append("<td>&nbsp;</td>");
                                innerHTML.append("<td>&nbsp;</td>");
                                innerHTML.append("<td>&nbsp;</td>");
                                innerHTML.append("<td>&nbsp;</td>");
                                innerHTML.append("<td>&nbsp;</td>");
                            innerHTML.append("</tt>");
                        }
                        out.println("<tr>");
                            out.println("<td rowspan='"+cantidadFilas+"'>"+res.getString("COD_LOTE_PRODUCCION")+"</td>");
                            out.println("<td rowspan='"+cantidadFilas+"'>"+res.getString("nombre_prod_semiterminado")+"</td>");
                            out.println("<td rowspan='"+cantidadFilas+"'>"+res.getString("NOMBRE_TIPO_PROGRAMA_PROD")+"</td>");
                            out.println(innerHTML);
                        out.println("<tr>");    
                            out.println("<td bgcolor='rgb(221, 221, 221)' colspan='7' align='right'><b>Total Lote:</b></td>");
                            out.println("<td bgcolor='rgb(221, 221, 221)'>"+cantidadTotaLote+"</td>");
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