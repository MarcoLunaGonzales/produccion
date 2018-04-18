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
    Connection con=null;
    try{
        String  codSalidaAlmacen=request.getParameter("codSalidaAlmacen");
        con=Util.openConnection(con);
        String reportFileName = application.getRealPath("/reportes/reporteImpresionDevolucionMaterialPesaje/impresionEtiquetasSalidaSinNL.jasper");
        Map parameters = new HashMap();
        parameters.put("fechaEtiqueta", (new Date()));
		parameters.put("codSalidaAlmacen",codSalidaAlmacen);
        JasperPrint jasperPrint = JasperFillManager.fillReport(reportFileName, parameters, con);
        session.setAttribute(BaseHttpServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE, jasperPrint);
    } 
    catch(SQLException ex)
    {
        ex.printStackTrace();
    }
    finally
    {
        con.close();
    }
    %>
<html>
    <body bgcolor="white" onload="location='../../servlets/pdf'" >
    </body>
</html>
    
