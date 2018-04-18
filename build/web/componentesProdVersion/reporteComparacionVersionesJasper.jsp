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
        try
        {
            Map parameters = new HashMap();
            int codVersion=Integer.valueOf(request.getParameter("codVersion"));
            int codCompProd=Integer.valueOf(request.getParameter("codCompProd"));
            con = Util.openConnection(con);
            parameters.put("codVersion",codVersion);
            parameters.put("codCompProd",codCompProd);
            String reportFileName = application.getRealPath("/componentesProdVersion/jasper/reporteComparacionVersion.jasper");
            JasperPrint jasperPrint = JasperFillManager.fillReport(reportFileName, parameters, con);
            JRPdfExporter exporter=new JRPdfExporter();
            exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
            response.setContentType("application/pdf");
            exporter.setParameter(JRExporterParameter.OUTPUT_STREAM,response.getOutputStream());
            exporter.exportReport();
            
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
        catch(Exception ex)
        {
            ex.printStackTrace();
        }
        finally
        {
            con.close();
        }
            


%>



