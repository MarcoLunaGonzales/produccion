<%@page import="com.cofar.util.Util"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date" %>
<%@ page import="net.sf.jasperreports.engine.*" %>
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ page import="net.sf.jasperreports.engine.export.*" %>
<%@ page import="net.sf.jasperreports.j2ee.servlets.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="com.cofar.web.ManagedProgramaProduccion"%>

<%

            String codProgramaProd=request.getParameter("codProgProd");
            String codLote=request.getParameter("codLote");
            Map parameters = new HashMap();
            //preparando datos para el reporte
            parameters.put("codProgramaProd", codProgramaProd);
            parameters.put("codLoteProduccion", codLote);
            SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy");
            parameters.put("FECHA_PESAJE",sdf.format(new Date()));
            Connection con=null;
            con=Util.openConnection(con);
            String reportFileName = application.getRealPath("/programaProduccion/etiquetasjrmx/impresionEtiquetasOMDesarrollo.jasper");
            JasperPrint jasperPrint = JasperFillManager.fillReport(reportFileName, parameters, con);
            session.setAttribute(BaseHttpServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE, jasperPrint);
            con.close();



%>

<html>
    <body bgcolor="white" onload="location='../servlets/pdf'" >
    </body>
</html>



