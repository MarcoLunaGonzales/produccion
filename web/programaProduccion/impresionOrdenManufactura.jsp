<%@page import="java.text.SimpleDateFormat"%>
<%@ page import="net.sf.jasperreports.engine.*" %>
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ page import="net.sf.jasperreports.engine.export.*" %>
<%@ page import="net.sf.jasperreports.j2ee.servlets.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.sql.Connection"%>

<%@ page import="com.cofar.util.*"%>
<%@ page import="com.cofar.bean.*"%>
<%@ page import="java.io.*"%>

<%@ page import="java.sql.*"%>
<%
            
            Map parameters = new HashMap();
            Connection con = null;
            con = Util.openConnection(con);
            System.out.println(request.getSession().getServletContext().getRealPath("/programaProduccion/IMPRESION_OM")+File.separator);
            System.out.println(request.getParameter("codProgramaProd"));
            System.out.println(request.getParameter("codLote"));
            System.out.println(application.getRealPath("/img/cofarOm.jpg"));
            parameters.put("dirLogoCofar", application.getRealPath("/img/nuevoLogoCofar.jpg"));
            parameters.put("codProgramaProd", Integer.valueOf(request.getParameter("codProgramaProd")));
            parameters.put("codLoteProduccion", request.getParameter("codLote"));
            parameters.put("SUBREPORT_DIR",request.getSession().getServletContext().getRealPath("/programaProduccion/IMPRESION_OM")+File.separator);
            parameters.put(JRParameter.REPORT_LOCALE,Locale.ENGLISH);
            String reportFileName = application.getRealPath("/programaProduccion/IMPRESION_OM/impresionOrdenManufactura.jasper");
            System.out.println("report "+reportFileName);
            JasperPrint jasperPrint = JasperFillManager.fillReport(reportFileName, parameters, con);
            JRPdfExporter exporter=new JRPdfExporter();
            exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
            response.setContentType("application/pdf");
            exporter.setParameter(JRExporterParameter.OUTPUT_STREAM,response.getOutputStream());
            exporter.exportReport();  
            con.close();
            
%>




