

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

%>

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
        </style>
        
    </head>
    <body>
        <%
        
            String codFormas=request.getParameter("codCompProdArray");
            String nombresFormas=request.getParameter("nombreCompProd");
            
            %>
        <form>
            
            <h3 align="center">Reporte de Especificaciones por forma Farmaceútica</h3>
            
                <center>
            <span class="outputText2"><b>Forma Farmaceútica : </b></span>
            <span class="outputText2"><%=nombresFormas%></span>
            </center>
            
            <br>
            <table width="70%" align="center" class="outputTextNormal" style="border : solid #000000 1px;" cellpadding="0" cellspacing="0" >

               
                <%
                try{
                String[] codigoForma=codFormas.split(",");
                String[] nombreForma=nombresFormas.split(",");
                con=Util.openConnection(con);
                Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet res=null;
                for(int i=0;i<codigoForma.length;i++)
                {
                    out.println(" <tr class=''>");
                    out.println("<td colspan='3' class='border tituloCabezera' style='border : solid #D8D8D8 1px' bgcolor='#696969' width='10%' align='center'><b>"+nombreForma[i]+"</b></td>");
                    out.println("</tr>");
                    out.println(" <tr class=''>");
                    out.println("<td colspan='3' class='border' style='border : solid #D8D8D8 1px' bgcolor='#f2f2f2' width='10% ' align='center'><b>Especificaciones Fisicas</b></td>");
                    out.println("</tr>");
                    out.println(" <tr class=''>");
                    out.println("<td  class='border' style='border : solid #D8D8D8 1px' bgcolor='#f2f2f2' width='10%' align='center'><b>Nombre Especificacion</b></td>");
                    out.println("<td  class='border' style='border : solid #D8D8D8 1px' bgcolor='#f2f2f2' width='10%' align='center'><b>Tipo de Resultado</b></td>");
                    out.println("<td  class='border' style='border : solid #D8D8D8 1px' bgcolor='#f2f2f2' width='10%' align='center'><b>Coeficiente</b></td>");
                    out.println("</tr>");
                    String consulta="select e.COD_ESPECIFICACION,e.NOMBRE_ESPECIFICACION,e.COD_TIPO_RESULTADO_ANALISIS,"+
                                    " t.NOMBRE_TIPO_RESULTADO_ANALISIS,ISNULL(e.COEFICIENTE,'') AS COEFICIENTE from ESPECIFICACIONES_FISICAS_CC e"+
                                    " inner join TIPOS_RESULTADOS_ANALISIS t on t.COD_TIPO_RESULTADO_ANALISIS =e.COD_TIPO_RESULTADO_ANALISIS"+
                                    " inner join ESPECIFICACIONES_ANALISIS_FORMAFAR e1 on e1.COD_ESPECIFICACION ="+
                                    " e.COD_ESPECIFICACION and e1.COD_TIPO_ANALISIS = '1' and e1.cod_formafar ="+codigoForma[i]+
                                    " order by e.NOMBRE_ESPECIFICACION";
                    System.out.println("consulta edpecificaciones fisicas forma far "+consulta);
                    res=st.executeQuery(consulta);
                    while(res.next())
                    {
                        out.println(" <tr class=>");
                        out.println("<td  class='border' style='border : solid #D8D8D8 1px' bgcolor='#FFFFFF' width='10%' align='left'>"+res.getString("NOMBRE_ESPECIFICACION")+"</td>");
                        out.println("<td  class='border' style='border : solid #D8D8D8 1px' bgcolor='#FFFFFF' width='10%' align='center'>"+res.getString("NOMBRE_TIPO_RESULTADO_ANALISIS")+"</td>");
                        out.println("<td  class='border' style='border : solid #D8D8D8 1px' bgcolor='#FFFFFF' width='10%' align='center'>"+res.getString("COEFICIENTE")+"</td>");
                        out.println("</tr>");

                    }
                    out.println(" <tr class=''>");
                    out.println("<td colspan='3' class='border' style='border : solid #D8D8D8 1px' bgcolor='#f2f2f2' width='10%' align='center'><b>Especificaciones Quimicas</b></td>");
                    out.println("</tr>");
                    out.println(" <tr class=''>");
                    out.println("<td  class='border' style='border : solid #D8D8D8 1px' bgcolor='#f2f2f2' width='10%' align='center'><b>Nombre Especificacion</b></td>");
                    out.println("<td  class='border' style='border : solid #D8D8D8 1px' bgcolor='#f2f2f2' width='10%' align='center'><b>Tipo de Resultado</b></td>");
                    out.println("<td  class='border' style='border : solid #D8D8D8 1px' bgcolor='#f2f2f2' width='10%' align='center'><b>Coeficiente</b></td>");
                    out.println("</tr>");
                    consulta="select e.COD_ESPECIFICACION,e.NOMBRE_ESPECIFICACION,e.COD_TIPO_RESULTADO_ANALISIS,"+
                             " t.NOMBRE_TIPO_RESULTADO_ANALISIS,ISNULL(e.COEFICIENTE,'') AS COEFICIENTE"+
                             " from ESPECIFICACIONES_QUIMICAS_CC e"+
                             " inner join TIPOS_RESULTADOS_ANALISIS t on t.COD_TIPO_RESULTADO_ANALISIS ="+
                             " e.COD_TIPO_RESULTADO_ANALISIS"+
                             " inner join ESPECIFICACIONES_ANALISIS_FORMAFAR e1 on e1.COD_ESPECIFICACION ="+
                             " e.COD_ESPECIFICACION and e1.COD_TIPO_ANALISIS = '2' and e1.cod_formafar ="+codigoForma[i]+
                             " order by e.NOMBRE_ESPECIFICACION";
                    System.out.println("consulta edpecificaciones quimicas forma far "+consulta);
                    res=st.executeQuery(consulta);
                     while(res.next())
                    {
                        out.println(" <tr class=>");
                        out.println("<td  class='border' style='border : solid #D8D8D8 1px' bgcolor='#FFFFFF' width='10%' align='left'>"+res.getString("NOMBRE_ESPECIFICACION")+"</td>");
                        out.println("<td  class='border' style='border : solid #D8D8D8 1px' bgcolor='#FFFFFF' width='10%' align='center'>"+res.getString("NOMBRE_TIPO_RESULTADO_ANALISIS")+"</td>");
                        out.println("<td  class='border' style='border : solid #D8D8D8 1px' bgcolor='#FFFFFF' width='10%' align='center'>"+res.getString("COEFICIENTE")+"</td>");
                        out.println("</tr>");

                    }
                     out.println(" <tr class=''>");
                    out.println("<td colspan='3' class='border' style='border : solid #D8D8D8 1px' bgcolor='#f2f2f2' width='10%' align='center'><b>Especificaciones Microbiológicas</b></td>");
                    out.println("</tr>");
                    out.println(" <tr class=''>");
                    out.println("<td  class='border' style='border : solid #D8D8D8 1px' bgcolor='#f2f2f2' width='10%' align='center'><b>Nombre Especificacion</b></td>");
                    out.println("<td  class='border' style='border : solid #D8D8D8 1px' bgcolor='#f2f2f2' width='10%' align='center'><b>Tipo de Resultado</b></td>");
                    out.println("<td  class='border' style='border : solid #D8D8D8 1px' bgcolor='#f2f2f2' width='10%' align='center'><b>Coeficiente</b></td>");
                    out.println("</tr>");
                    consulta="select e.COD_ESPECIFICACION,e.NOMBRE_ESPECIFICACION,e.COD_TIPO_RESULTADO_ANALISIS,"+
                             " t.NOMBRE_TIPO_RESULTADO_ANALISIS,ISNULL(e.COEFICIENTE, '') as COEFICIENTE"+
                             " from ESPECIFICACIONES_MICROBIOLOGIA e inner join TIPOS_RESULTADOS_ANALISIS t on " +
                             " t.COD_TIPO_RESULTADO_ANALISIS =e.COD_TIPO_RESULTADO_ANALISIS"+
                             " inner join ESPECIFICACIONES_ANALISIS_FORMAFAR e1 on e1.COD_ESPECIFICACION ="+
                             " e.COD_ESPECIFICACION and e1.COD_TIPO_ANALISIS = '3' and e1.cod_formafar ="+codigoForma[i]+
                             " order by e.NOMBRE_ESPECIFICACION";
                    res=st.executeQuery(consulta);
                    while(res.next())
                    {
                         out.println(" <tr class=>");
                        out.println("<td  class='border' style='border : solid #D8D8D8 1px' bgcolor='#FFFFFF' width='10%' align='left'>"+res.getString("NOMBRE_ESPECIFICACION")+"</td>");
                        out.println("<td  class='border' style='border : solid #D8D8D8 1px' bgcolor='#FFFFFF' width='10%' align='center'>"+res.getString("NOMBRE_TIPO_RESULTADO_ANALISIS")+"</td>");
                        out.println("<td  class='border' style='border : solid #D8D8D8 1px' bgcolor='#FFFFFF' width='10%' align='center'>"+res.getString("COEFICIENTE")+"</td>");
                        out.println("</tr>");
                    }
                    res.close();
                }
                st.close();
                con.close();
                }
                catch(Exception ex)
                {
                    ex.printStackTrace();
                }
                %>
                           
            


               </table>

              
            <br>

            <br>
            <div align="center">
                <%--<INPUT type="button" class="commandButton" name="btn_registrar" value="<-- Atrás" onClick="cancelar();"  >--%>

            </div>
        </form>
    </body>
</html>