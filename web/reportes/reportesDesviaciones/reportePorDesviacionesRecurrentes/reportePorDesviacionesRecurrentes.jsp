<%@page import="com.cofar.util.Util"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page import="net.sf.jasperreports.engine.*" %>
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ page import="net.sf.jasperreports.engine.export.*" %>
<%@ page import="net.sf.jasperreports.j2ee.servlets.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.sql.Connection"%>
<%@ page import="com.cofar.bean.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%
    String codDesviacion = request.getParameter("codDesviacion");
    String codAreaGeneradora = request.getParameter("codAreaGeneradora");
    String codTipoDesviacion = request.getParameter("codTipoDesviacion");
    System.out.println("--->codDesviacion"+codDesviacion);
    System.out.println("--->codAreaGeneradora"+codAreaGeneradora);
    System.out.println("--->codTipoDesviacion"+codTipoDesviacion);
    Map parameters = new HashMap();
    Connection con = null;
    con = Util.openConnection(con);
    parameters.put("dirLogoCofar", application.getRealPath("/img/nuevoLogoCofar.jpg"));
    parameters.put("codDesviacionGenerica", Integer.valueOf(codDesviacion));
    parameters.put("codClasificacionRiesgoDesviacion",Integer.valueOf(codTipoDesviacion));
    parameters.put("codAreaGeneradoraDesviacion",Integer.valueOf(codAreaGeneradora));
    parameters.put(JRParameter.REPORT_LOCALE,Locale.ENGLISH);
    String reportFileName = application.getRealPath("/reportes/reportesDesviaciones/reportePorDesviacionesRecurrentes/reportePorDesviacionesRecurrentesJasper.jasper");
    System.out.println("report "+reportFileName);
    JasperPrint jasperPrint = JasperFillManager.fillReport(reportFileName, parameters, con);
    JRPdfExporter exporter=new JRPdfExporter();
    exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
    response.setContentType("application/pdf");
    exporter.setParameter(JRExporterParameter.OUTPUT_STREAM,response.getOutputStream());
    exporter.exportReport();  
    con.close();

%>
 