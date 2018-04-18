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
            System.out.println("cdcdcd");
            parameters.put("codGrupoForma",request.getParameter("codGrupoForma"));
            parameters.put("dirLogoCofar",request.getParameter("/img/nuevoLogoCofar.jpg"));
            String reportFileName = application.getRealPath("/reportes/reporteEspecificacionesCC2015/reporteEspecificacionesCC2015.jasper");
            JasperPrint jasperPrint = JasperFillManager.fillReport(reportFileName, parameters, con);
            System.out.println("cdcdcd"+reportFileName);
            session.setAttribute(BaseHttpServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE, jasperPrint);
            con.close();
            


%>

<html>
    <body bgcolor="white" onload="location='../../servlets/pdf'" >
    </body>
</html>



