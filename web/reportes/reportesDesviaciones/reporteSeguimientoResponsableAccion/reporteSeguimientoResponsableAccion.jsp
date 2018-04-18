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
            int codPersonalAsignado = Integer.valueOf(request.getParameter("codPersonalAsignado"));
            String accionAsignada = request.getParameter("accionAsignada");
            Date fechaInicioAprobacion = (request.getParameter("fechaInicioAprobacion").equals("")?null:sdf.parse(request.getParameter("fechaInicioAprobacion")+" 00:00"));
            Date fechaFinAprobacion = (request.getParameter("fechaFinAprobacion").equals("")?null:sdf.parse(request.getParameter("fechaFinAprobacion")+" 00:00"));
            Date fechaInicioCumplimiento = (request.getParameter("fechaInicioCumplimiento").equals("")?null:sdf.parse(request.getParameter("fechaInicioCumplimiento")+" 00:00"));
            Date fechaFinCumplimiento = (request.getParameter("fechaFinCumplimiento").equals("")?null:sdf.parse(request.getParameter("fechaFinCumplimiento")+" 00:00"));
            int codEstadoCapaAseguramiento = Integer.valueOf(request.getParameter("codEstadoCapaAseguramiento"));
            System.out.println("--->codPersonalAsignado"+codPersonalAsignado);
            System.out.println("--->accionAsignada"+accionAsignada);
            System.out.println("--->fechaInicioAprobacion"+fechaInicioAprobacion);
            System.out.println("--->fechaFinAprobacion"+fechaFinAprobacion);
            System.out.println("--->fechaInicioCumplimiento"+fechaInicioCumplimiento);
            System.out.println("--->fechaFinCumplimiento"+fechaFinCumplimiento);
            System.out.println("--->codEstadoCapaAseguramiento"+codEstadoCapaAseguramiento);
            Map parameters = new HashMap();
            Connection con = null;
            con = Util.openConnection(con);
            parameters.put("dirLogoCofar", application.getRealPath("/img/nuevoLogoCofar.jpg"));
            parameters.put("codPersonalAsignado", Integer.valueOf(codPersonalAsignado));
            parameters.put("descripcionAccion","%"+accionAsignada+"%");
            parameters.put("fechaInicioAsignacion",fechaInicioAprobacion);
            parameters.put("fechaFinalAsignacion", fechaFinAprobacion);
            parameters.put("fechaInicioLimiteCumplimiento", fechaInicioCumplimiento);
            parameters.put("fechaFinalLimiteCumplimiento", fechaFinCumplimiento);
            parameters.put(JRParameter.REPORT_LOCALE,Locale.ENGLISH);
            String reportFileName = application.getRealPath("/reportes/reportesDesviaciones/reporteSeguimientoResponsableAccion/reporteSeguimientoResponsableAccionJasper.jasper");
            System.out.println("report "+reportFileName);
            JasperPrint jasperPrint = JasperFillManager.fillReport(reportFileName, parameters, con);
            JRPdfExporter exporter=new JRPdfExporter();
            exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
            response.setContentType("application/pdf");
            exporter.setParameter(JRExporterParameter.OUTPUT_STREAM,response.getOutputStream());
            exporter.exportReport();  
            con.close();
        %>