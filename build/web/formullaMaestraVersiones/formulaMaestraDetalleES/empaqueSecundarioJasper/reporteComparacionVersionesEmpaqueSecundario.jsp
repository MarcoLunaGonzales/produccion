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
            parameters.put("codFormulaMaestraEsVersion", Integer.valueOf(request.getParameter("codFormulaMaestraEsVersion")));
            String reportFileName = application.getRealPath("/formullaMaestraVersiones/formulaMaestraDetalleES/empaqueSecundarioJasper/reporteComparacionVersionEmpaqueSecundario.jasper");
            System.out.println("report "+reportFileName);
            JasperPrint jasperPrint = JasperFillManager.fillReport(reportFileName, parameters, con);
            JRPdfExporter exporter=new JRPdfExporter();
            exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
            response.setContentType("application/pdf");
            exporter.setParameter(JRExporterParameter.OUTPUT_STREAM,response.getOutputStream());
            exporter.exportReport();  
            con.close();
            


%>

<html>
</html>



