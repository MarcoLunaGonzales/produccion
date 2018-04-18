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
            Date fechaInicioDetecta = (request.getParameter("fechaInicioDetecta").equals("")?null:sdf.parse(request.getParameter("fechaInicioDetecta")+" 00:00"));
            Date fechaFinDetecta = (request.getParameter("fechaFinDetecta").equals("")?null:sdf.parse(request.getParameter("fechaFinDetecta")+" 23:59"));
            Date fechaInicioEnvio = (request.getParameter("fechaInicioEnvio").equals("")?null:sdf.parse(request.getParameter("fechaInicioEnvio")+" 00:00"));
            Date fechaFinEnvio = (request.getParameter("fechaFinEnvio").equals("")?null:sdf.parse(request.getParameter("fechaFinEnvio")+" 23:59"));
            String codAreaDetectora = request.getParameter("codAreaDetectora");
            String codAreaGeneradora = request.getParameter("codAreaGeneradora");
            String codPersonalDetecta = request.getParameter("codPersonalDetecta");
            String codPersonalEnvia = request.getParameter("codPersonalEnvia");
            System.out.println("--->codPersonalDetecta"+codPersonalDetecta);
            System.out.println("--->codPersonalEnvia"+codPersonalEnvia);
            System.out.println("--->fechaInicioDetecta"+fechaInicioDetecta);
            System.out.println("--->fechaFinDetecta"+fechaFinDetecta);
            System.out.println("--->fechaInicioEnvio"+fechaInicioEnvio);
            System.out.println("--->fechaFinEnvio"+fechaFinEnvio);
            System.out.println("--->codAreaDetectora"+codAreaDetectora);
            System.out.println("--->codAreaGeneradora"+codAreaGeneradora);
            Map parameters = new HashMap();
            Connection con = null;
            con = Util.openConnection(con);
            parameters.put("dirLogoCofar", application.getRealPath("/img/nuevoLogoCofar.jpg"));
            parameters.put("codPersonalDetecta", Integer.valueOf(codPersonalDetecta));
            parameters.put("fechaInicioDetecta",fechaInicioDetecta);
            parameters.put("fechaFinalDetecta",fechaFinDetecta);
            parameters.put("codPersonalReporta", Integer.valueOf(codPersonalEnvia));
            parameters.put("fechaInicioReporta", fechaInicioEnvio);
            parameters.put("fechaFinalReporta", fechaFinEnvio);
            parameters.put("codAreaEmpresaDetectora", Integer.valueOf(codAreaDetectora));
            parameters.put("codAreaGeneradora", Integer.valueOf(codAreaGeneradora));
            parameters.put(JRParameter.REPORT_LOCALE,Locale.ENGLISH);
            String reportFileName = application.getRealPath("/reportes/reportesDesviaciones/reportePersonalDetectorGenerador/reportePersonalDetectorGeneradorJasper.jasper");
            System.out.println("report "+reportFileName);
            JasperPrint jasperPrint = JasperFillManager.fillReport(reportFileName, parameters, con);
            JRPdfExporter exporter=new JRPdfExporter();
            exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
            response.setContentType("application/pdf");
            exporter.setParameter(JRExporterParameter.OUTPUT_STREAM,response.getOutputStream());
            exporter.exportReport();  
            con.close();

        %>
    </body>
</html>
