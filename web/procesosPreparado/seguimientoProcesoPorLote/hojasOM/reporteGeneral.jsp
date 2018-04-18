package procesosPreparado.seguimientoProcesoPorLote.hojasOM;

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
<%@ page import="java.util.Calendar"%>
<%@ page import="java.util.GregorianCalendar"%>
<%@ page language="java" import = "org.joda.time.*"%>
<%@ page language="java" import="java.util.*,com.cofar.util.CofarConnection" %>
<html>
    <head>
        <script type="text/javascript">
             function imprimirFrame()
             {
                  for (var i=0; i<window.frames.length; i++)
                  {
                    window.frames[i].focus();
                    window.frames[i].print();
                  }
                  window.location.href="reportePreparado.jsf?codLote="+document.getElementById("codLoteProduccion").value+
                                       "&codProgramaProd="+document.getElementById("codProgramaProd").value+"&imp=1&data="+(new Date()).getTime().toString()+
                                       "&codForma="+document.getElementById("codForma").value;
             }

     </script>
 </head>
<body>
    <center>
        <button onclick="imprimirFrame();">Imprimir Hojas</button>
    </center>
 <%
                int codForma=Integer.valueOf(request.getParameter("codForma"));
                int codReceta=Integer.valueOf(request.getParameter("codReceta"));
                int codProgramaProd=Integer.valueOf(request.getParameter("codProgramaProd"));
                String codLoteProduccion=request.getParameter("codLote");
                Date fecha=new Date();
                out.println("<iframe id='ifrm' src='reporteLimpiezaAmbiente.jsf?codLote="+codLoteProduccion+"&codProgramaProd="+codProgramaProd+"&data="+fecha.getTime()+"' width='100%' height='100%' ></iframe>");
                out.println("<iframe id='ifrm1' src='reporteRepesada.jsf?codLote="+codLoteProduccion+"&codProgramaProd="+codProgramaProd+"&data="+fecha.getTime()+"' width='100%' height='100%'></iframe>");
                out.println("<iframe id='ifrm2' src='"+(codForma==2?"reporteLavado":"reporteLavadoColirios")+".jsf?codLote="+codLoteProduccion+"&codProgramaProd="+codProgramaProd+"&data="+fecha.getTime()+"' width='100%' height='100%' ></iframe>");
                if(codForma==2)out.println("<iframe id='ifrm3' src='reporteDespirogenizado.jsf?codLote="+codLoteProduccion+"&codProgramaProd="+codProgramaProd+"&data="+fecha.getTime()+"' width='100%' height='100%'></iframe>");
                //out.println("<iframe class='frame' width='600px' height='300px' id='ifrm4' src='reportePreparado.jsf?codLote="+codLoteProduccion+"&codProgramaProd="+codProgramaProd+"&data="+fecha.getTime()+"'></iframe>");
                out.println("<iframe id='ifrm1' src='"+(codForma==2?"reporteDosificado":"reporteDosificadoColirios")+".jsf?codLote="+codLoteProduccion+"&codProgramaProd="+codProgramaProd+"&data="+fecha.getTime()+"' width='100%' height='100%'></iframe>");
                if(codForma!=2)out.println("<iframe id='ifrm3' src='reporteGrafadoFrascos.jsf?codLote="+codLoteProduccion+"&codProgramaProd="+codProgramaProd+"&data="+fecha.getTime()+"' width='100%' height='100%'></iframe>");
                out.println("<iframe id='ifrm1' src='"+(codForma==2?"reporteControlLLenadoVolumen":"reporteControlPeso")+".jsf?codLote="+codLoteProduccion+"&codProgramaProd="+codProgramaProd+"&data="+fecha.getTime()+"' width='100%' height='100%'></iframe>");
                out.println("<iframe id='ifrm1' src='"+(codForma==2?"reporteControlDosificado":"reporteControlDosificadoColirios")+".jsf?codLote="+codLoteProduccion+"&codProgramaProd="+codProgramaProd+"&data="+fecha.getTime()+"' width='100%' height='100%'></iframe>");
                out.println("<iframe id='ifrm1' src='reporteRendimientoDosificado.jsf?codLote="+codLoteProduccion+"&codProgramaProd="+codProgramaProd+"&data="+fecha.getTime()+"&codForma="+codForma+"' width='100%' height='100%'></iframe>");
               if(codReceta>0)out.println("<iframe id='ifrm1' src='reporteEsterilizacionCalorHumedo.jsf?codLote="+codLoteProduccion+"&codProgramaProd="+codProgramaProd+"&data="+fecha.getTime()+"' width='100%' height='100%'></iframe>");
                %>
 </body>
<input type="hidden" value="<%=(codLoteProduccion)%>" id="codLoteProduccion" name="codLoteProduccion"/>
<input type="hidden" value="<%=(codProgramaProd)%>" id="codProgramaProd" name="codProgramaProd"/>
<input type="hidden" value="<%=(codForma)%>" id="codForma" name="codForma"/>
</html>
