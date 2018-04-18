<%@page import="java.text.DecimalFormat"%>
<%@page import="java.text.NumberFormat"%>
<%@ page language="java" %>
<%@ page import="com.cofar.web.*" %>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.sql.DriverManager"%> 
<%@ page import = "java.sql.ResultSet"%> 
<%@ page import = "java.sql.Statement"%> 
<%@ page import="com.cofar.util.*" %>
<%@ page language="java" import="java.util.*" %>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page import="net.sf.jasperreports.engine.*" %>
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ page import="net.sf.jasperreports.engine.export.*" %>
<%@ page import="net.sf.jasperreports.j2ee.servlets.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.sql.*"%>
        <%
            String codCapa = request.getParameter("codCapa");
            String codEstadoCapa = request.getParameter("codEstadoCapa");
            String codDesviacion = request.getParameter("codDesviacion");
            String codTipoDesviacion = request.getParameter("codTipoDesviacion");
            System.out.println("--->codCapa"+codCapa);
            System.out.println("--->codEstadoCapa"+codEstadoCapa);
            System.out.println("--->codDesviacion"+codDesviacion);
            System.out.println("--->codTipoDesviacion"+codTipoDesviacion);
            Map parameters = new HashMap();
            Connection con = null;
            con = Util.openConnection(con);
            parameters.put("dirLogoCofar", application.getRealPath("/img/nuevoLogoCofar.jpg"));
            parameters.put("codCapaAseguramientoCalidad", Integer.valueOf(codCapa));
            parameters.put("codEstadoCapaAseguramientoCalidad",Integer.valueOf(codEstadoCapa));
            parameters.put("codDesviacionGenerica",Integer.valueOf(codDesviacion));
            parameters.put("codClasificacionRiesgoDesviacion", Integer.valueOf(codTipoDesviacion));
            parameters.put(JRParameter.REPORT_LOCALE,Locale.ENGLISH);
            String reportFileName = application.getRealPath("/reportes/reportesDesviaciones/reportePorCapasAsociadas/reportePorCapasAsociadasJasper.jasper");
            System.out.println("report "+reportFileName);
            JasperPrint jasperPrint = JasperFillManager.fillReport(reportFileName, parameters, con);
            JRPdfExporter exporter=new JRPdfExporter();
            exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
            response.setContentType("application/pdf");
            exporter.setParameter(JRExporterParameter.OUTPUT_STREAM,response.getOutputStream());
            exporter.exportReport();  
            con.close();
        %>