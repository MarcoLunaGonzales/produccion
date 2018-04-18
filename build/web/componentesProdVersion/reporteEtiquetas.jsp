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
            parameters.put("codProgramaProd","0");
            parameters.put("codLoteProduccion",request.getParameter("codLoteProduccion"));
            parameters.put("FECHA_PESAJE","01/11/2015");
            String reportFileName = application.getRealPath("/programaProduccion/etiquetasjrmx/impresionEtiquetasOM.jasper");
            SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyy");
            JasperPrint jasperPrint = JasperFillManager.fillReport(reportFileName, parameters, con);
            session.setAttribute(BaseHttpServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE, jasperPrint);
            con.close();
            


%>

<html>
    <body bgcolor="white" onload="location='../servlets/pdf'" >
    </body>
</html>



