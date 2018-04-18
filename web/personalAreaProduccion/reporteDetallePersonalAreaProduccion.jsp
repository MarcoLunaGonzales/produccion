
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
<%@ page errorPage="ExceptionHandler.jsp" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        
        <%--meta http-equiv="Content-Type" content="text/html; charset=UTF-8"--%>
        <title>JSP Page</title>
        <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
        <script src="../js/general.js"></script>
        <style>
            
        </style>
    </head>
    <body>
        <h3 align="center">Histórico de Areas del Personal</h3>
        <form>
            
                <%
                Connection con=null;
                try{
                    NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
                    DecimalFormat format = (DecimalFormat)nf;
                    format.applyPattern("#,###.00");
                    String codPersonal=request.getParameter("codPersonal");
                    con = Util.openConnection(con);  
                    StringBuilder consulta=new StringBuilder("select isnull((p.AP_PATERNO_PERSONAL + ' ' + p.AP_MATERNO_PERSONAL + ' ' +p.NOMBRES_PERSONAL + ' ' + p.nombre2_personal), (pt.AP_PATERNO_PERSONAL +' ' + pt.AP_MATERNO_PERSONAL + ' ' + pt.NOMBRES_PERSONAL + ' ' +pt.nombre2_personal)) as nombrePersonal,");
                                  consulta.append(" ae.NOMBRE_AREA_EMPRESA,pap.FECHA_INICIO,epap.NOMBRE_ESTADO_PERSONAL_AREA_PRODUCCION");
                                  consulta.append(" from PERSONAL_AREA_PRODUCCION pap left outer join personal p on p.COD_PERSONAL = pap.COD_PERSONAL");
                                  consulta.append(" left outer join PERSONAL_TEMPORAL pt on pt.COD_PERSONAL = pap.COD_PERSONAL");
                                  consulta.append(" inner join AREAS_EMPRESA ae on ae.COD_AREA_EMPRESA = pap.COD_AREA_EMPRESA");
                                  consulta.append(" inner join ESTADOS_PERSONAL_AREA_PRODUCCION epap on epap.COD_ESTADO_PERSONAL_AREA_PRODUCCION = pap.COD_ESTADO_PERSONAL_AREA_PRODUCCION");
                                  consulta.append("  where pap.COD_PERSONAL='").append(codPersonal).append("'");
                               System.out.println(consulta.toString());
                    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet res=st.executeQuery(consulta.toString());
                    res.next();
                   SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy HH:mm");
                %>
                <table align="center" cellpadding="0" cellspacing="0">
                    <tr>
                        <td class="outputTextBold">Personal:</td>
                        <td class="outputText2"><%=(res.getString("nombrePersonal"))%></td>
                    </tr>
                    <tr>
                        <td class="outputTextBold">Area Empresa Actual:</td>
                        <td class="outputText2"><%=(res.getString("NOMBRE_AREA_EMPRESA"))%></td>
                    </tr>
                    <tr>
                        <td class="outputTextBold">Fecha Inicio Area"</td>
                        <td class="outputText2"><%=(res.getTimestamp("FECHA_INICIO")!=null?sdf.format(res.getTimestamp("FECHA_INICIO")):"")%></td>
                    </tr>
                </table>
                    <table  style="margin-top:1em" align="center" width="60%" class="tablaReporte" cellpadding="0" cellspacing="0">
                <thead>
                <tr >
                    <td>Area Empresa</td>
                    <td>Fecha Inicio</td>
                    <td>Fecha Final</td>
                    <td>Observación</td>
                    <td>Estado Persona</td>
                    
                </tr>
                </thead>
                <tbody>
                <%
                              consulta=new StringBuilder("select papd.FECHA_INICIO,papd.FECHA_FINAL,ae.NOMBRE_AREA_EMPRESA,epap.NOMBRE_ESTADO_PERSONAL_AREA_PRODUCCION,papd.COMENTARIO");
                              consulta.append(" from PERSONAL_AREA_PRODUCCION_DETALLE papd inner join AREAS_EMPRESA ae on ae.COD_AREA_EMPRESA=papd.COD_AREA_EMPRESA");
                              consulta.append(" inner join ESTADOS_PERSONAL_AREA_PRODUCCION epap on epap.COD_ESTADO_PERSONAL_AREA_PRODUCCION=papd.COD_ESTADO_PERSONAL_AREA_PRODUCCION");
                              consulta.append(" where papd.COD_PERSONAL='").append(codPersonal).append("'");
                              consulta.append(" order by papd.FECHA_INICIO");
                    System.out.println("consulta Detalle cambios"+consulta.toString());
                                              
                     res=st.executeQuery(consulta.toString());
                    
                    while (res.next())
                    {
                        out.print("<tr>");
                        out.print("<td  align='left'>"+sdf.format(res.getTimestamp("FECHA_INICIO"))+"</td>");
                        out.print("<td  align='left'>"+sdf.format(res.getTimestamp("FECHA_FINAL"))+"</td>");
                        out.print("<td  align='left'>"+res.getString("NOMBRE_AREA_EMPRESA")+"</td>");
                        out.print("<td  align='left'>"+res.getString("COMENTARIO")+"&nbsp;</td>");
                        out.print("<td  align='left'>"+res.getString("NOMBRE_ESTADO_PERSONAL_AREA_PRODUCCION")+"&nbsp;</td>");
                        out.print("</tr>");
                    }
                
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
            </tbody>
            </table>
        </form>
    </body>
</html>