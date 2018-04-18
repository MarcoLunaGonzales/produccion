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
        System.out.println("entros");
        String [] detalleMateriales=request.getParameter("datosMateriales").split(",");
        
        con=Util.openConnection(con);
        String consulta="delete IMPRESION_ETIQUETA_MATERIAL_DEVOLUCION_PESAJE";
        PreparedStatement pst=con.prepareStatement(consulta);
        pst.executeUpdate();
        consulta="INSERT INTO IMPRESION_ETIQUETA_MATERIAL_DEVOLUCION_PESAJE(COD_MATERIAL, TARA, NETO, LOTE_PROVEEDOR)"+
                 " VALUES (?,?,?,?)";
        pst=con.prepareStatement(consulta);
        for(int i=0;i<detalleMateriales.length;i+=4)
        {
            pst.setString(1,detalleMateriales[i]);
            pst.setString(2,detalleMateriales[i+2]);
            pst.setString(3,detalleMateriales[i+3]);
            pst.setString(4,detalleMateriales[i+1]);
            pst.executeUpdate();
        }
        String reportFileName = application.getRealPath("/reportes/reporteImpresionDevolucionMaterialPesaje/impresionEtiquetasOMDesv.jasper");
        Map parameters = new HashMap();
        parameters.put("fechaEtiqueta", (new Date()));
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
    
