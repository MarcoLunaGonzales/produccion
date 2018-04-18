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
    Connection con = null;
        try
        {
            Map parameters = new HashMap();
            System.out.println(request.getParameter("codAreaEmpresa"));
            System.out.println(request.getParameter("codTipoProduccion"));
            con = Util.openConnection(con);
            StringBuilder consulta=new StringBuilder("if object_id('tempdb.dbo.##codAreaEmpresaMaterialesProductoTemp') is not null");
                                    consulta.append(" begin");
                                        consulta.append(" drop table ##codAreaEmpresaMaterialesProductoTemp");
                                    consulta.append(" end");
                                      consulta.append(" create table ##codAreaEmpresaMaterialesProductoTemp");
                                      consulta.append(" (");
                                              consulta.append(" codAreaEmpresa integer");
                                      consulta.append(" )");
                                    
                                    consulta.append(" insert into ##codAreaEmpresaMaterialesProductoTemp");
                                    consulta.append(" values (0)");
                                    for(String codArea:request.getParameter("codAreaEmpresa").split(","))
                                        consulta.append(",(").append(codArea).append(")");
                                    consulta.append(" if object_id('tempdb.dbo.##codTipoProduccionMaterialesProductoTemp') is not null");
                                    consulta.append(" begin ");
                                        consulta.append(" drop table ##codTipoProduccionMaterialesProductoTemp");
                                    consulta.append(" end ");
                                        consulta.append(" create table ##codTipoProduccionMaterialesProductoTemp");
                                        consulta.append(" (");
                                                consulta.append(" codTipoProgramaProd integer");
                                        consulta.append(" )");
                                    consulta.append(" insert into ##codTipoProduccionMaterialesProductoTemp");
                                    consulta.append(" values (0)");
                                    for(String codTipoProd:request.getParameter("codTipoProduccion").split(","))
                                        consulta.append(",(").append(codTipoProd).append(")");
            System.out.println("consulta registrar parametro "+consulta.toString());
            PreparedStatement pst=con.prepareStatement(consulta.toString());
            if(pst.executeUpdate()>0)System.out.println("se registraron los parametros ");
            parameters.put("dirLogoCofar", application.getRealPath("/img/nuevoLogoCofar.jpg"));
            parameters.put("nombreAreaEmpresa", request.getParameter("nombreAreaEmpresa"));
            parameters.put("nombreTipoProduccion", request.getParameter("nombreTipoProduccion"));
            String reportFileName = application.getRealPath("/reportes/reporteMaterialesPorProducto/reporteProductosPorMaterial.jasper");
            JasperPrint jasperPrint = JasperFillManager.fillReport(reportFileName, parameters, con);
            session.setAttribute(BaseHttpServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE, jasperPrint);
        }
        catch(SQLException e)
        {
            e.printStackTrace();
        }
        catch(Exception ex)
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



