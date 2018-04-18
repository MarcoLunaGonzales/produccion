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
            ProgramaProduccion programaProduccion = (ProgramaProduccion) request.getSession().getAttribute("programaProduccion");
            String fecha=(request.getParameter("fecha")!=null?request.getParameter("fecha"):"");
            Map parameters = new HashMap();
            Connection con = null;
            con = Util.openConnection(con);

            //pasando parametros al reporte
            parameters.put("codProgramaProd", programaProduccion.getCodProgramaProduccion());
            parameters.put("codLoteProduccion", programaProduccion.getCodLoteProduccion());
            String reportFileName = application.getRealPath("/programaProduccion/etiquetasjrmx/impresionEtiquetasOM.jasper");
            System.out.println("direccion reporte "+reportFileName);
            SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyy");
            if(fecha.equals(""))fecha=sdf.format(new Date());
            parameters.put("FECHA_PESAJE",fecha);
            JasperPrint jasperPrint = JasperFillManager.fillReport(reportFileName, parameters, con);
            session.setAttribute(BaseHttpServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE, jasperPrint);
            con.close();
%>

<html>
    <body bgcolor="white" onload="location='../servlets/pdf'" >
    </body>
</html>



