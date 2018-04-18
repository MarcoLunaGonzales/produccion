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
    try
    {
            int codSolicitudMantenimiento=Integer.valueOf(request.getParameter("codSolicitudMantenimiento"));
            System.out.println("reporte solicitud "+codSolicitudMantenimiento);
            Map parameters = new HashMap();
            Connection con = null;
            con = Util.openConnection(con);
            parameters.put("dirLogoCofar", application.getRealPath("/img/nuevoLogoCofar.jpg"));
            parameters.put("codSolicitudMantenimiento", codSolicitudMantenimiento);
            String reportFileName = application.getRealPath("/mantenimiento/impresionSolicitudMantenimientoOT.jasper");
            JasperPrint jasperPrint = JasperFillManager.fillReport(reportFileName, parameters, con);
            session.setAttribute(BaseHttpServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE, jasperPrint);
            con.close();
    }
    catch(Exception ex)
    {
        ex.printStackTrace();
    }


%>

<html>
    <body bgcolor="white" onload="location='../servlets/pdf'" >
    </body>
</html>



