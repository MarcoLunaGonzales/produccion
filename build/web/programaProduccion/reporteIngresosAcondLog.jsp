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
    
    Connection con = null;
    try{
        System.out.println("codIngresoAcond: "+request.getParameter("codIngresoAcond"));
        int codIngresoAcond = Integer.valueOf(request.getParameter("codIngresoAcond"));
        Map parameters = new HashMap();
        con = Util.openConnection(con);
        parameters.put("codIngresoAcond", codIngresoAcond);
        String reportFileName = application.getRealPath("/programaProduccion/reporteIngresosAcondLog.jasper");
        JasperPrint jasperPrint = JasperFillManager.fillReport(reportFileName, parameters, con);
        JRPdfExporter exporter=new JRPdfExporter();
        exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
        response.setContentType("application/pdf");
        exporter.setParameter(JRExporterParameter.OUTPUT_STREAM,response.getOutputStream());
        exporter.exportReport();
        con.close();
    }
    catch(Exception ex){
        ex.printStackTrace();
        out.println("<b>Error al momento de procesar el reporte, intente de nuevo.<br/>Si el problema persistente comuniquese con sistemas.</b><br/>");
        out.println(ex);
        System.out.println("entro error farma");
    }
%>
