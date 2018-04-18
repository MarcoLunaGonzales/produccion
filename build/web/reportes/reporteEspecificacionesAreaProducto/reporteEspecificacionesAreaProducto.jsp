

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
            try{
                con=Util.openConnection(con);
                Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet res=null;
                
                String codArea=request.getParameter("codArea");
                String nombresArea=request.getParameter("nombreArea");
                String codComprod=request.getParameter("codProd");
                String nombreProducto="";
                String consulta="select cp.nombre_prod_semiterminado from COMPONENTES_PROD cp where cp.COD_COMPPROD='"+codComprod+"' order by cp.nombre_prod_semiterminado";
                System.out.println("consulta ca "+codComprod+" ca "+codArea+" na "+nombresArea);
                if(!codComprod.equals("0"))
                {
                    res=st.executeQuery(consulta);
                    if(res.next())
                    {
                        nombreProducto=res.getString("nombre_prod_semiterminado");
                    }
                }
                else
                {
                    nombreProducto="-TODOS-";
                }
            %>
        <form>
            
            <h3 align="center">Reporte de especificaciones por Area</h3>
            
                <center>
            <span class="outputText2"><b>Area Empresa: </b></span>
            <span class="outputText2"><%=nombresArea%></span><br>
            <span class="outputText2"><b>Producto: </b></span>
            <span class="outputText2"><%=nombreProducto%></span>
            </center>
            
            <br>
            <table width="70%" align="center" class="outputTextNormal" style="border : solid #000000 1px;" cellpadding="0" cellspacing="0" >
             <%
                 String[] codAreaEmpresa=codArea.split(",");
                 String[] nombreAreaEmpresa=nombresArea.split(",");
                 Statement stdetalle=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                 ResultSet resDetalle=null;
                 String especificacion="";
                 String codTipoResultadoAnalisis="";
                 double limiteSuperior=0d;
                 double limiteInferior=0d;
                 double valorExacto=0d;
                 String codproducto="";
                 String cabeceraQuimica="";
                 String nombreEspecificacion="";
                 for(int i=0;i<codAreaEmpresa.length;i++)
                 {

                      out.println(" <tr class=''>");
                      out.println("<td colspan='3' class='border tituloCabezera' style='border : solid #D8D8D8 1px' bgcolor='#696969' width='10%' align='center'><b>"+nombreAreaEmpresa[i]+"</b></td>");
                      out.println("</tr>");
                      consulta="select cp.nombre_prod_semiterminado,cp.COD_COMPPROD " +
                              " from COMPONENTES_PROD cp where cp.COD_AREA_EMPRESA='"+codAreaEmpresa[i]+"'" +(codComprod.equals("0")?"":" and cp.COD_COMPPROD='"+codComprod+"'")+
                              " and (cp.COD_COMPPROD in (select emp.COD_COMPROD from ESPECIFICACIONES_MICROBIOLOGIA_PRODUCTO emp where emp.ESTADO=1) or"+
                              "  cp.COD_COMPPROD in (select efp.COD_PRODUCTO from ESPECIFICACIONES_FISICAS_PRODUCTO efp where efp.ESTADO=1) or"+
                              "  cp.COD_COMPPROD in (select eqp.COD_PRODUCTO from ESPECIFICACIONES_QUIMICAS_PRODUCTO eqp where eqp.ESTADO=1)"+
                              "  ) order by cp.nombre_prod_semiterminado";
                      System.out.println("consulta producto de area Empresa "+consulta);
                      res=st.executeQuery(consulta);
                      while(res.next())
                      {
                          cabeceraQuimica="";
                            out.println(" <tr class=''>");
                            out.println("<td colspan='3' class='border' style='border : solid #D8D8D8 1px' bgcolor='#909090' width='10%' align='center'><b>"+res.getString("nombre_prod_semiterminado")+"</b></td>");
                            out.println("</tr>");
                               out.println("<tr class=''>");
                            out.println("<td colspan='3' class='border' style='border : solid #D8D8D8 1px' bgcolor='#f2f2f2' width='10%' align='center'><b>Especificaciones Físicas</b></td>");
                            out.println("</tr>");
                            out.println(" <tr class=''>");
                            out.println("<td  class='border' style='border : solid #D8D8D8 1px' bgcolor='#f2f2f2' width='10%' align='center'><b>Nombre Especificacion</b></td>");
                            out.println("<td  class='border' style='border : solid #D8D8D8 1px' bgcolor='#f2f2f2' width='10%' align='center'><b>Especificación</b></td>");
                            out.println("<td  class='border' style='border : solid #D8D8D8 1px' bgcolor='#f2f2f2' width='10%' align='center'><b>Referencia</b></td>");
                            out.println("</tr>");
                            codproducto=res.getString("COD_COMPPROD");
                            consulta="select ISNULL(tra.SIMBOLO,'') as SIMBOLO,ISNULL(efcc.COEFICIENTE,'') AS COEFICIENTE,efp.DESCRIPCION,efcc.COD_TIPO_RESULTADO_ANALISIS,efcc.NOMBRE_ESPECIFICACION,efp.LIMITE_SUPERIOR,efp.LIMITE_INFERIOR,efp.VALOR_EXACTO,"+
                                    " trcc.NOMBRE_REFERENCIACC from ESPECIFICACIONES_FISICAS_PRODUCTO efp inner join ESPECIFICACIONES_FISICAS_CC efcc on"+
                                    " efp.COD_ESPECIFICACION=efcc.COD_ESPECIFICACION left outer join "+
                                    " TIPOS_REFERENCIACC  trcc on  trcc.COD_REFERENCIACC=efp.COD_REFERENCIA_CC"+
                                    " left outer join TIPOS_RESULTADOS_ANALISIS tra on tra.COD_TIPO_RESULTADO_ANALISIS=efcc.COD_TIPO_RESULTADO_ANALISIS" +
                                    " inner join VERSION_ESPECIFICACIONES_PRODUCTO vep on vep.COD_COMPPROD=efp.COD_PRODUCTO"+
                                    " and vep.COD_TIPO_ANALISIS=1 and vep.COD_VERSION_ESPECIFICACION_PRODUCTO=efp.COD_VERSION_ESPECIFICACION_PRODUCTO"+
                                    " and vep.VERSION_ACTIVA=1"+
                                    " where efp.COD_PRODUCTO='"+codproducto+"'  and efp.ESTADO=1 ORDER BY efcc.NOMBRE_ESPECIFICACION";
                            System.out.println(" consulta esp fis "+consulta);
                            resDetalle=stdetalle.executeQuery(consulta);
                            while(resDetalle.next())
                            {
                                limiteInferior=resDetalle.getDouble("LIMITE_INFERIOR");
                                limiteSuperior=resDetalle.getDouble("LIMITE_SUPERIOR");
                                valorExacto=resDetalle.getDouble("VALOR_EXACTO");
                                codTipoResultadoAnalisis=resDetalle.getString("COD_TIPO_RESULTADO_ANALISIS");
                                especificacion=(codTipoResultadoAnalisis.equals("1")?resDetalle.getString("DESCRIPCION"):
                                    (codTipoResultadoAnalisis.equals("2")?(String.valueOf(limiteInferior)+" - "+String.valueOf(limiteSuperior)):
                                    (resDetalle.getString("COEFICIENTE")+" "+resDetalle.getString("SIMBOLO")+" "+String.valueOf(valorExacto))));
                                    out.println(" <tr class=>");
                                    out.println("<td  class='border' style='border : solid #D8D8D8 1px' bgcolor='#FFFFFF' width='10%' align='left'>"+resDetalle.getString("NOMBRE_ESPECIFICACION")+"</td>");
                                    out.println("<td  class='border' style='border : solid #D8D8D8 1px' bgcolor='#FFFFFF' width='10%' align='center'>"+especificacion+"</td>");
                                    out.println("<td  class='border' style='border : solid #D8D8D8 1px' bgcolor='#FFFFFF' width='10%' align='center'>"+resDetalle.getString("NOMBRE_REFERENCIACC")+"</td>");
                                    out.println("</tr>");
                            }
                            consulta="select eqcc.NOMBRE_ESPECIFICACION,eqcc.COD_ESPECIFICACION,ISNULL(m.NOMBRE_CCC,'SIN MATERIALES') AS NOMBRE_CCC,tra.COD_TIPO_RESULTADO_ANALISIS,"+
                                    " eqp.LIMITE_INFERIOR,eqp.LIMITE_SUPERIOR,eqp.DESCRIPCION,eqp.VALOR_EXACTO,"+
                                    " ISNULL(tra.SIMBOLO,'') as SIMBOLO,ISNULL(eqcc.COEFICIENTE,'') as COEFICIENTE,"+
                                    " tr.NOMBRE_REFERENCIACC"+
                                    " from ESPECIFICACIONES_QUIMICAS_PRODUCTO eqp inner join ESPECIFICACIONES_QUIMICAS_CC eqcc on"+
                                    " eqp.COD_ESPECIFICACION=eqcc.COD_ESPECIFICACION left outer join MATERIALES m on "+
                                    " eqp.COD_MATERIAL=m.COD_MATERIAL left outer join TIPOS_RESULTADOS_ANALISIS tra on "+
                                    " tra.COD_TIPO_RESULTADO_ANALISIS=eqcc.COD_TIPO_RESULTADO_ANALISIS"+
                                    " left outer join TIPOS_REFERENCIACC  tr on tr.COD_REFERENCIACC=eqp.COD_REFERENCIA_CC" +
                                    " inner join VERSION_ESPECIFICACIONES_PRODUCTO vep on vep.COD_COMPPROD=eqp.COD_PRODUCTO"+
                                    " and vep.COD_TIPO_ANALISIS=2 and vep.COD_VERSION_ESPECIFICACION_PRODUCTO=eqp.COD_VERSION_ESPECIFICACION_PRODUCTO"+
                                    " and vep.VERSION_ACTIVA=1"+
                                    " where eqp.COD_PRODUCTO='"+codproducto+"' and eqp.ESTADO=1" +
                                    " order by eqcc.NOMBRE_ESPECIFICACION ASC,m.NOMBRE_CCC";
                            System.out.println("consulta esp qui"+consulta);
                            resDetalle=stdetalle.executeQuery(consulta);
                            out.println("</tr>");
                               out.println("<tr class=''>");
                            out.println("<td colspan='3' class='border' style='border : solid #D8D8D8 1px' bgcolor='#f2f2f2' width='10%' align='center'><b>Especificaciones Quimicas</b></td>");
                            out.println("</tr>");
                            while(resDetalle.next())
                            {
                                nombreEspecificacion=resDetalle.getString("NOMBRE_ESPECIFICACION");
                                if(!cabeceraQuimica.equals(nombreEspecificacion))
                                {
                                     out.println(" <tr class=''>");
                                     out.println("<td colspan='3' class='border' style='border : solid #D8D8D8 1px' bgcolor='#ffffff' width='10%' align='left'><b>"+nombreEspecificacion+"</b></td>");
                                     out.println("</tr>");
                                     cabeceraQuimica=nombreEspecificacion;
                                }
                                limiteInferior=resDetalle.getDouble("LIMITE_INFERIOR");
                                limiteSuperior=resDetalle.getDouble("LIMITE_SUPERIOR");
                                valorExacto=resDetalle.getDouble("VALOR_EXACTO");
                                codTipoResultadoAnalisis=resDetalle.getString("COD_TIPO_RESULTADO_ANALISIS");
                                especificacion=(codTipoResultadoAnalisis.equals("1")?resDetalle.getString("DESCRIPCION"):
                                    (codTipoResultadoAnalisis.equals("2")?(String.valueOf(limiteInferior)+" - "+String.valueOf(limiteSuperior)):
                                    (resDetalle.getString("COEFICIENTE")+" "+resDetalle.getString("SIMBOLO")+" "+String.valueOf(valorExacto))));
                                    out.println(" <tr class=>");
                                    out.println("<td  class='border' style='border : solid #D8D8D8 1px' bgcolor='#FFFFFF' width='10%' align='left'>"+resDetalle.getString("NOMBRE_CCC")+"</td>");
                                    out.println("<td  class='border' style='border : solid #D8D8D8 1px' bgcolor='#FFFFFF' width='10%' align='center'>"+especificacion+"</td>");
                                    out.println("<td  class='border' style='border : solid #D8D8D8 1px' bgcolor='#FFFFFF' width='10%' align='center'>"+resDetalle.getString("NOMBRE_REFERENCIACC")+"</td>");
                                    out.println("</tr>");
                            }
                            consulta="select em.NOMBRE_ESPECIFICACION,emp.LIMITE_INFERIOR,emp.DESCRIPCION,emp.LIMITE_SUPERIOR,emp.VALOR_EXACTO,"+
                                     " ISNULL(em.COEFICIENTE,'') as COEFICIENTE,ISNULL(tra.SIMBOLO,'') as SIMBOLO,"+
                                     " tr.NOMBRE_REFERENCIACC,em.COD_TIPO_RESULTADO_ANALISIS"+
                                     " from ESPECIFICACIONES_MICROBIOLOGIA_PRODUCTO emp inner join ESPECIFICACIONES_MICROBIOLOGIA em on"+
                                     " emp.COD_ESPECIFICACION=em.COD_ESPECIFICACION left outer join TIPOS_RESULTADOS_ANALISIS tra on"+
                                     " tra.COD_TIPO_RESULTADO_ANALISIS=em.COD_TIPO_RESULTADO_ANALISIS left outer join "+
                                     " TIPOS_REFERENCIACC tr on tr.COD_REFERENCIACC=emp.COD_REFERENCIA_CC" +
                                     " inner join VERSION_ESPECIFICACIONES_PRODUCTO vep on  vep.COD_VERSION_ESPECIFICACION_PRODUCTO=emp.COD_VERSION_ESPECIFICACION_PRODUCTO"+
                                     " and vep.COD_COMPPROD=emp.COD_COMPROD and vep.COD_TIPO_ANALISIS=3 and vep.VERSION_ACTIVA=1"+
                                     " where emp.COD_COMPROD='"+codproducto+"' and emp.ESTADO=1 ORDER BY em.NOMBRE_ESPECIFICACION";
                            System.out.println("consulta esp micro "+consulta);
                            out.println("</tr>");
                               out.println("<tr class=''>");
                            out.println("<td colspan='3' class='border' style='border : solid #D8D8D8 1px' bgcolor='#f2f2f2' width='10%' align='center'><b>Especificaciones Microbiologia</b></td>");
                            out.println("</tr>");
                            resDetalle=stdetalle.executeQuery(consulta);
                            while(resDetalle.next())
                            {
                                 limiteInferior=resDetalle.getDouble("LIMITE_INFERIOR");
                                limiteSuperior=resDetalle.getDouble("LIMITE_SUPERIOR");
                                valorExacto=resDetalle.getDouble("VALOR_EXACTO");
                                codTipoResultadoAnalisis=resDetalle.getString("COD_TIPO_RESULTADO_ANALISIS");
                                especificacion=(codTipoResultadoAnalisis.equals("1")?resDetalle.getString("DESCRIPCION"):
                                    (codTipoResultadoAnalisis.equals("2")?(String.valueOf(limiteInferior)+" - "+String.valueOf(limiteSuperior)):
                                    (resDetalle.getString("COEFICIENTE")+" "+resDetalle.getString("SIMBOLO")+" "+String.valueOf(valorExacto))));
                                    out.println(" <tr class=>");
                                    out.println("<td  class='border' style='border : solid #D8D8D8 1px' bgcolor='#FFFFFF' width='10%' align='left'>"+resDetalle.getString("NOMBRE_ESPECIFICACION")+"</td>");
                                    out.println("<td  class='border' style='border : solid #D8D8D8 1px' bgcolor='#FFFFFF' width='10%' align='center'>"+especificacion+"</td>");
                                    out.println("<td  class='border' style='border : solid #D8D8D8 1px' bgcolor='#FFFFFF' width='10%' align='center'>"+resDetalle.getString("NOMBRE_REFERENCIACC")+"</td>");
                                    out.println("</tr>");
                            }
                            resDetalle.close();
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