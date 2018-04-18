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
<%!
public void productoMix(ProgramaProduccion programaProduccion,String reportFileName,Map parameters, ServletContext application){
    try{
        Connection con = null;
        con = Util.openConnection(con);
        String consulta = "select cp.nombre_prod_semiterminado,c.COD_COMPROD_MIX,p1.COD_COMPPROD cod_compprod1,p2.COD_COMPPROD cod_compprod2,p2.COD_LOTE_PRODUCCION,p1.COD_FORMULA_MAESTRA cod_formula_maestra1,p2.COD_FORMULA_MAESTRA cod_formula_maestra2" +
                " from COMPONENTES_PROD_MIX c inner join PROGRAMA_PRODUCCION p1 on p1.COD_COMPPROD = c.COD_COMPROD1" +
                " inner join PROGRAMA_PRODUCCION p2 on p2.COD_COMPPROD = c.COD_COMPROD2 and p2.COD_LOTE_PRODUCCION = p1.COD_LOTE_PRODUCCION" +
                " inner join COMPONENTES_PROD cp on cp.COD_COMPPROD = c.COD_COMPROD_MIX" +
                " where p2.COD_LOTE_PRODUCCION = '"+programaProduccion.getCodLoteProduccion()+"' ";
        System.out.println("consulta " + consulta);
        Statement st = con.createStatement();
        ResultSet rs = st.executeQuery(consulta);
        if(rs.next()){
            parameters.put("nombreProductoMix", rs.getString("nombre_prod_semiterminado"));
            parameters.put("codCompProdMix",rs.getString("COD_COMPROD_MIX"));
            parameters.put("codCompprod1", rs.getString("cod_compprod1"));
            parameters.put("codCompprod2", rs.getString("cod_compprod2"));
            parameters.put("codformulaMaestra1", rs.getString("cod_formula_maestra1"));
            parameters.put("codFormulaMaestra2", rs.getString("cod_formula_maestra2"));
            parameters.put("codLoteProduccion", rs.getString("cod_lote_produccion"));
            reportFileName = application.getRealPath("/programaProduccion/impresionEtiquetasMix.jasper");
        }

        }catch(Exception e){e.printStackTrace();}
}
%>


<%
            ProgramaProduccion programaProduccion = (ProgramaProduccion) request.getSession().getAttribute("programaProduccion");

            Map parameters = new HashMap();
            Connection con = null;
            con = Util.openConnection(con);


            parameters.put("codProgramaProd", programaProduccion.getCodProgramaProduccion());
            parameters.put("codLoteProduccion", programaProduccion.getCodLoteProduccion());
            parameters.put("codCompProd", programaProduccion.getFormulaMaestra().getComponentesProd().getCodCompprod());
            parameters.put("codFormulaMaestra", programaProduccion.getFormulaMaestra().getCodFormulaMaestra());
            System.out.println("datos para el reporte " + programaProduccion.getCodProgramaProduccion() + " " + programaProduccion.getCodLoteProduccion() +
                    " " + programaProduccion.getFormulaMaestra().getComponentesProd().getCodCompprod() + " " + programaProduccion.getFormulaMaestra().getCodFormulaMaestra());
            File logofile = new File(application.getRealPath("/img/cofar.png"));
            java.io.FileInputStream inputStream = new java.io.FileInputStream(logofile);

            parameters.put("logo", inputStream);

            String reportFileName = application.getRealPath("/programaProduccionDesarrollo/impresionEtiquetasOMDesarrollo.jasper");
            // verificar si pertenece a un producto mix
            
            String consulta = "select cp.nombre_prod_semiterminado,c.COD_COMPROD_MIX,p1.COD_COMPPROD cod_compprod1,p2.COD_COMPPROD cod_compprod2,p2.COD_LOTE_PRODUCCION,p1.COD_FORMULA_MAESTRA cod_formula_maestra1,p2.COD_FORMULA_MAESTRA cod_formula_maestra2" +
                " from COMPONENTES_PROD_MIX c inner join PROGRAMA_PRODUCCION p1 on p1.COD_COMPPROD = c.COD_COMPROD1" +
                " inner join PROGRAMA_PRODUCCION p2 on p2.COD_COMPPROD = c.COD_COMPROD2 and p2.COD_LOTE_PRODUCCION = p1.COD_LOTE_PRODUCCION" +
                " inner join COMPONENTES_PROD cp on cp.COD_COMPPROD = c.COD_COMPROD_MIX" +
                " where p2.COD_LOTE_PRODUCCION = '"+programaProduccion.getCodLoteProduccion()+"' ";
                System.out.println("consulta " + consulta);
                Statement st = con.createStatement();
                ResultSet rs = st.executeQuery(consulta);
                if(rs.next()){
                    parameters.put("nombre_prod_semiterminado_mix", rs.getString("nombre_prod_semiterminado"));
                    parameters.put("codCompProdMix",rs.getString("COD_COMPROD_MIX"));
                    parameters.put("codCompProd1", rs.getString("cod_compprod1"));
                    parameters.put("codCompProd2", rs.getString("cod_compprod2"));
                    parameters.put("codFormulaMaestra1", rs.getString("cod_formula_maestra1"));
                    parameters.put("codFormulaMaestra2", rs.getString("cod_formula_maestra2"));
                    parameters.put("codLoteProduccion", rs.getString("cod_lote_produccion"));
                    reportFileName = application.getRealPath("/programaProduccion/impresionEtiquetasMix.jasper");
                }
            //
         
            
            System.out.println(reportFileName);
            


            JasperPrint jasperPrint = JasperFillManager.fillReport(reportFileName, parameters, con);
            session.setAttribute(BaseHttpServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE, jasperPrint);
            System.out.println(jasperPrint.getLocaleCode());



%>

<html>
    <body bgcolor="white" onload="location='../servlets/pdf'" >
    </body>
</html>



