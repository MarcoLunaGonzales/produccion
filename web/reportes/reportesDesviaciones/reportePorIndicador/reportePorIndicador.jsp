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
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
            Date fechaInicio = (request.getParameter("fechaInicio").equals("")?null:sdf.parse(request.getParameter("fechaInicio")+" 00:00"));
            Date fechaFin = (request.getParameter("fechaFin").equals("")?null:sdf.parse(request.getParameter("fechaFin")+" 00:00"));
            System.out.println("--->fechaInicio"+fechaInicio);
            System.out.println("--->fechaFin"+fechaFin);
            Map parameters = new HashMap();
            Connection con = null;
            con = Util.openConnection(con);
            parameters.put("dirLogoCofar", application.getRealPath("/img/nuevoLogoCofar.jpg"));
            parameters.put("fechaInicioIndicador",fechaInicio);
            parameters.put("fechaFinalIndicador",fechaFin);
            parameters.put(JRParameter.REPORT_LOCALE,Locale.ENGLISH);
            String reportFileName = application.getRealPath("/reportes/reportesDesviaciones/reportePorIndicador/reportePorIndicadorJasper.jasper");
            System.out.println("report "+reportFileName);
            JasperPrint jasperPrint = JasperFillManager.fillReport(reportFileName, parameters, con);
            JRPdfExporter exporter=new JRPdfExporter();
            exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
            response.setContentType("application/pdf");
            exporter.setParameter(JRExporterParameter.OUTPUT_STREAM,response.getOutputStream());
            exporter.exportReport();  
            con.close();

        %>

