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
            String[] codigosProducto=request.getParameter("codigosProducto").split(",");
            StringBuilder consulta=new StringBuilder("IF OBJECT_ID('tempdb..##TEMP_COD_COMPPROD') IS NOT NULL DROP TABLE ##TEMP_COD_COMPPROD");
                                consulta.append(" CREATE TABLE ##TEMP_COD_COMPPROD(codCompProd integer);");
                                consulta.append(" INSERT INTO ##TEMP_COD_COMPPROD(codCompProd) VALUES (0)");
            for(int i=0;i<codigosProducto.length;i++)
            {
                consulta.append(",(").append(codigosProducto[i]).append(")");
            }
            PreparedStatement pst=con.prepareStatement(consulta.toString());
            System.out.println("consulta crear temporal "+consulta.toString());
            if(pst.executeUpdate()>0)System.out.println("se ergistro el temporal");
            SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy");
            
            Date fechaInicio=sdf.parse(request.getParameter("fechaInicio"));
            Date fechaFinal=sdf.parse(request.getParameter("fechaFinal"));
            parameters.put(JRParameter.REPORT_LOCALE,Locale.ENGLISH);
            parameters.put("fechaInicio",new Timestamp(fechaInicio.getTime()));
            parameters.put("fechaFinal",new Timestamp(fechaFinal.getTime()));
            parameters.put("dirLogoCofar",application.getRealPath("/img/nuevoLogoCofar.jpg"));
            String reportFileName = application.getRealPath("/reportes/reporteRAP2015/impresionRap2015.jasper");
            JasperPrint jasperPrint = JasperFillManager.fillReport(reportFileName, parameters, con);
            session.setAttribute(BaseHttpServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE, jasperPrint);
            con.close();
            


%>

<html>
    <body bgcolor="white" onload="location='../../servlets/pdf'" >
    </body>
</html>



