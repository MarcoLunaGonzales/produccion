<%@ page import="net.sf.jasperreports.engine.*" %>
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ page import="net.sf.jasperreports.engine.export.*" %>
<%@ page import="net.sf.jasperreports.j2ee.servlets.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.sql.Connection"%>
<%@ page import="com.cofar.util.*"%>
<%@ page import="com.cofar.bean.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.math.*"%>
<%@ page import="java.sql.*"%>
<%
            ProgramaProduccion programaProduccion = (ProgramaProduccion) request.getSession().getAttribute("programaProduccion");
            IngresosDetalleAcond ingresosAcondicionamientoEtiqueta=(IngresosDetalleAcond)request.getSession().getAttribute("ingresosAcondicionamientoEtiqueta");
            Map parameters = new HashMap();
            parameters.put("codProgramaProd", programaProduccion.getCodProgramaProduccion());
            parameters.put("codLoteProduccion", programaProduccion.getCodLoteProduccion());
            parameters.put("codCompProd", programaProduccion.getFormulaMaestra().getComponentesProd().getCodCompprod());
            parameters.put("codFormulaMaestra", programaProduccion.getFormulaMaestra().getCodFormulaMaestra());
            parameters.put("um",ingresosAcondicionamientoEtiqueta.getTiposEnvase().getNombreTipoEnvase());
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
            Connection con = null;
            con = Util.openConnection(con);
            String consulta = " delete from etiquetas_acond ";
            PreparedStatement pst=con.prepareStatement(consulta);
            pst.executeUpdate();
            Double cantidadIngresada=0d;
            Double cantidadPorCaja=Double.valueOf(ingresosAcondicionamientoEtiqueta.getCantidadEnvase());
            Double cantidadTotalIngreso=Double.valueOf(ingresosAcondicionamientoEtiqueta.getCantTotalIngreso());
            int contCajas=0;
            while(cantidadIngresada<cantidadTotalIngreso)
            {
                contCajas++;
                Double cantidadEtiqueta=((cantidadIngresada+cantidadPorCaja)<=cantidadTotalIngreso?cantidadPorCaja:(cantidadTotalIngreso-cantidadIngresada));
                consulta = " INSERT INTO ETIQUETAS_ACOND(  COD_USUARIO,  COD_COMPPROD,  COD_LOTE_PRODUCCION,  FECHA_VENC,  COD_PRESENTACION," +
                        "  CANT_TOTAL_SALIDADETALLEACOND,  CANT_PRESENTACION,  COD_TIPO_PROGRAMA_PROD,cod_cliente,NOMBRE_CLIENTE,NOMBRE_TIPO_PROGRAMA_PRODUCCION) VALUES " +
                        "( 0,'"+programaProduccion.getFormulaMaestra().getComponentesProd().getCodCompprod()+"'," +
                        "  '"+programaProduccion.getCodLoteProduccion()+"',  '"+sdf.format(programaProduccion.getFechaVencimiento())+"',  " +
                        "'"+programaProduccion.getPresentacionesProducto().getCodPresentacion()+"',  '"+cantidadEtiqueta+"'," +
                        "  '"+cantidadEtiqueta+"'," +
                        "  '"+programaProduccion.getTiposProgramaProduccion().getCodTipoProgramaProd()+"'," +
                        "'"+(programaProduccion.getTiposProgramaProduccion().getCodTipoProgramaProd().equals("2")?ingresosAcondicionamientoEtiqueta.getIngresosAcondicionamiento().getClientes().getCodCliente():-1)+"','"+programaProduccion.getObservacion()+"','"+programaProduccion.getTiposProgramaProduccion().getNombreTipoProgramaProd()+"') ";
                System.out.println("consulta insertr e "+consulta);
                cantidadIngresada+=cantidadEtiqueta;
                pst=con.prepareStatement(consulta);
                pst.executeUpdate();
                
                
            }
            
            File logofile = new File(application.getRealPath("/img/cofar.png"));
            java.io.FileInputStream inputStream = new java.io.FileInputStream(logofile);
            
            parameters.put("logo", inputStream);
            String reportFileName = application.getRealPath("/programaProduccion/etiquetasjrmx/impresionEtiquetas.jasper");
            parameters.put("cantCajas",contCajas);
            
            System.out.println(reportFileName);
            JasperPrint jasperPrint = JasperFillManager.fillReport(reportFileName, parameters, con);
            session.setAttribute(BaseHttpServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE, jasperPrint);
            con.close();
            
%>

<html>
    <body bgcolor="white" onload="location='../servlets/pdf'" >
    </body>
</html>



