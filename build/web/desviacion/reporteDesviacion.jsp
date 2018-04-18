<%@page import="java.text.SimpleDateFormat"%>
<%@ page import="net.sf.jasperreports.engine.*" %>
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ page import="net.sf.jasperreports.engine.export.*" %>
<%@ page import="net.sf.jasperreports.j2ee.servlets.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.sql.Connection"%>
<%@ page import="com.cofar.util.*"%>
<%
        int codDesviacion=Integer.valueOf(request.getParameter("codDesviacion"));
        Map parameters = new HashMap();
        Connection con = null;
        con = Util.openConnection(con);
        parameters.put("codDesviacion", codDesviacion);
        String reportFileName = application.getRealPath("/desviacion/reporteDesviacion.jasper");
        parameters.put("dirLogoCofar",application.getRealPath("/img/cofar.jpg"));
        JasperPrint jasperPrint = JasperFillManager.fillReport(reportFileName, parameters, con);
        session.setAttribute(BaseHttpServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE, jasperPrint);
        con.close();
            


%>

<html>
    <body bgcolor="white" onload="location='../servlets/pdf'" >
    </body>
</html>



