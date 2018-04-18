<%@ page import="net.sf.jasperreports.engine.*" %>
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ page import="net.sf.jasperreports.engine.export.*" %>
<%@ page import="net.sf.jasperreports.j2ee.servlets.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Connection"%>
<%@ page import="com.cofar.util.*"%>
<%@ page import="com.cofar.bean.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>


<%
            Map parameters = new HashMap();
            

            parameters.put("codMaterial",Integer.valueOf(request.getParameter("codMaterial")));
            parameters.put("codAlmacen",Integer.valueOf(request.getParameter("codAlmacen")));
            String[] arrayFecha=request.getParameter("fechaInicial").split("/");
            parameters.put("fechaInicio",arrayFecha[2]+"/"+arrayFecha[1]+"/"+arrayFecha[0]+" 00:00");
            arrayFecha=request.getParameter("fechaFinal").split("/");
            parameters.put("fechaFinal",arrayFecha[2]+"/"+arrayFecha[1]+"/"+arrayFecha[0]+" 23:59");
            parameters.put("loteProveedor",request.getParameter("loteProveedor"));


            String reportFileName = application.getRealPath("/reportes/reporteKardexMovimientoLoteProveedor/kardexloteproveedor.jasper");
            System.out.println("re"+reportFileName);
            Connection con = null;
            con = Util.openConnection(con);
            JasperPrint jasperPrint = JasperFillManager.fillReport(reportFileName, parameters, con);
            session.setAttribute(BaseHttpServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE, jasperPrint);
            System.out.println(jasperPrint.getLocaleCode());
            



%>

<html>
    <body bgcolor="white" onload="location='../../servlets/pdf'" >
    </body>
</html>



