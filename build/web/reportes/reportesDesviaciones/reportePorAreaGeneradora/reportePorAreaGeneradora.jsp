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
        String codAreaGeneradora = request.getParameter("codAreaGeneradora");
        String codTipoDesviacion = request.getParameter("codTipoDesviacion");
        System.out.println("--->codAreaGeneradora"+codAreaGeneradora);
        System.out.println("--->codTipoDesviacion"+codTipoDesviacion);
        Map parameters = new HashMap();
        Connection con = null;
        con = Util.openConnection(con);
        parameters.put("dirLogoCofar", application.getRealPath("/img/nuevoLogoCofar.jpg"));
        parameters.put("codAreaGeneradoraDesviacion", Integer.valueOf(codAreaGeneradora));
        parameters.put("codClasificacionRiesgoDesviacion",Integer.valueOf(codTipoDesviacion));
        parameters.put(JRParameter.REPORT_LOCALE,Locale.ENGLISH);
        String reportFileName = application.getRealPath("/reportes/reportesDesviaciones/reportePorAreaGeneradora/reportePorAreaGeneradoraJasper.jasper");
        System.out.println("report "+reportFileName);
        JasperPrint jasperPrint = JasperFillManager.fillReport(reportFileName, parameters, con);
        JRPdfExporter exporter=new JRPdfExporter();
        exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
        response.setContentType("application/pdf");
        exporter.setParameter(JRExporterParameter.OUTPUT_STREAM,response.getOutputStream());
        exporter.exportReport();  
        con.close();

    %>
