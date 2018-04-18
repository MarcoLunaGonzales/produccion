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
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
            Date fechaInicioEnvio = (request.getParameter("fechaInicioEnvio").equals("")?null:sdf.parse(request.getParameter("fechaInicioEnvio")+" 00:00"));
            Date fechaFinEnvio = (request.getParameter("fechaFinEnvio").equals("")?null:sdf.parse(request.getParameter("fechaFinEnvio")+" 23:59"));
            String codPersonalAsignado = request.getParameter("codPersonalAsignado");
            Date fechaInicioLimiteRevision = (request.getParameter("fechaInicioLimiteRevision").equals("")?null:sdf.parse(request.getParameter("fechaInicioLimiteRevision")+" 00:00"));
            Date fechaFinLimiteRevision = (request.getParameter("fechaFinLimiteRevision").equals("")?null:sdf.parse(request.getParameter("fechaFinLimiteRevision")+" 23:59"));
            Date fechaInicioRevision = (request.getParameter("fechaInicioRevision").equals("")?null:sdf.parse(request.getParameter("fechaInicioRevision")+" 00:00"));
            Date fechaFinRevision = (request.getParameter("fechaFinRevision").equals("")?null:sdf.parse(request.getParameter("fechaFinRevision")+" 23:59"));
            String codPersonalRevisor = request.getParameter("codPersonalRevisor");
            String codEstadoDesviacion = request.getParameter("codEstadoDesviacion");
            System.out.println("--->fechaInicioEnvio"+fechaInicioEnvio);
            System.out.println("--->fechaFinEnvio"+fechaFinEnvio);
            System.out.println("--->codPersonalAsignado"+codPersonalAsignado);
            System.out.println("--->fechaInicioLimiteRevision"+fechaInicioLimiteRevision);
            System.out.println("--->fechaFinLimiteRevision"+fechaFinLimiteRevision);
            System.out.println("--->fechaInicioRevision"+fechaInicioRevision);
            System.out.println("--->fechaFinRevision"+fechaFinRevision);
            System.out.println("--->codPersonalRevisor"+codPersonalRevisor);
            System.out.println("--->codEstadoDesviacion"+codEstadoDesviacion);
            Map parameters = new HashMap();
            Connection con = null;
            con = Util.openConnection(con);
            parameters.put("dirLogoCofar", application.getRealPath("/img/nuevoLogoCofar.jpg"));
            parameters.put("codPersonalAsignado", Integer.valueOf(codPersonalAsignado));
            parameters.put("codPersonalRevisado", Integer.valueOf(codPersonalRevisor));
            parameters.put("codEstadoDesviacion", Integer.valueOf(codEstadoDesviacion));
            parameters.put("fechaInicioEnvioRevision",fechaInicioEnvio);
            parameters.put("fechaFinalEnvioRevision",fechaFinEnvio);
            parameters.put("fechaInicioLimiteRevision",fechaInicioLimiteRevision);
            parameters.put("fechaFinalLimiteRevision",fechaFinLimiteRevision);
            parameters.put("fechaInicioRevisionUsuario",fechaInicioRevision);
            parameters.put("fechaFinalRevisionUsuario",fechaFinRevision);
            
            parameters.put(JRParameter.REPORT_LOCALE,Locale.ENGLISH);
            String reportFileName = application.getRealPath("/reportes/reportesDesviaciones/reporteRevisionDesviaciones/reporteRevisionDesviacionesJasper.jasper");
            System.out.println("report "+reportFileName);
            JasperPrint jasperPrint = JasperFillManager.fillReport(reportFileName, parameters, con);
            JRPdfExporter exporter=new JRPdfExporter();
            exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
            response.setContentType("application/pdf");
            exporter.setParameter(JRExporterParameter.OUTPUT_STREAM,response.getOutputStream());
            exporter.exportReport();  
            con.close();

        %>