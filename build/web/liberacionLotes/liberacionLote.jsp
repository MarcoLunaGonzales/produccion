<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>
<%@page contentType="text/html"%>
<%@ page language="java" %>
<%@ page import="com.cofar.util.*" %>
<%@ page import="com.cofar.web.*" %>
<%@ page import = "java.sql.Connection"%>
<%@ page import="java.math.RoundingMode"%>
<%@ page import = "java.sql.DriverManager"%>
<%@ page import = "java.sql.ResultSet"%>
<%@ page import = "java.sql.Statement"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.text.SimpleDateFormat"%>
<%@ page import = "java.text.DecimalFormat"%>
<%@ page import = "java.text.NumberFormat"%>
<%@ page import="java.util.Locale" %>
<%@ page import="java.text.DecimalFormatSymbols" %>
<%@ page import = "java.text.NumberFormat"%>
<f:view>
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
            <script type="text/javascript" src="../js/general.js"></script>
            <style>
                .tablaDatosProducto
                {
                    border-top:1px solid #bbb;
                    border-left:1px solid #bbb;
                }
                .tablaDatosProducto td
                {
                    padding: 7px;
                    border-bottom: 1px solid #bbb;
                    border-right: 1px solid #bbb;
                    /*background-color: #FFF;*/
                }
                .tablaDatosProducto thead tr td
                {
                    background-color: #9d5a9e !important;
                }
                
                .tablaDatosProducto tbody td
                {
                    background-color: #FFF;
                }
            </style>
            <script type="text/javascript">
                function verCertificado(codLote,codForma,codProducto)
                {
                        openPopup('../reportes/reporteControlCalidad/reporteControlCalidad.jsf?codForma='+codForma+'&codLote='+codLote+'&codProd='+codProducto+'&data='+(new Date()).getTime().toString());
                }
                function verOOS(codRegistroOOs)
                {
                    openPopup('../controlCalidadOS/reporteOOSControlCalidad.jsf?codRegistroOOS='+codRegistroOOs+'&data='+(new Date()).getTime().toString());
                }
                function verDesviacion(codDesviacion)
                {
                    openPopup('../desviacion/reporteDesviacion.jsf?codDesviacion='+codDesviacion+'&data='+(new Date()).getTime().toString());
                }
                function openPopup(url){
                       window.open(url,'detalle'+Math.round((Math.random()*1000)),'top=50,left=200,width=800,height=600,scrollbars=1,resizable=1');
                }
            </script>
        </head>
            <a4j:form id="form1">                
                <div align="center">                    
                    <h:outputText value="Liberación de Lotes" styleClass="outputTextTituloSistema"/>
                    <rich:panel headerClass="headerClassACliente" style="width:80%">
                        <f:facet name="header">
                            <h:outputText value="LIBERACIÓN DE LOTES"/>
                        </f:facet>
                        <h:panelGrid columns="6">
                            <h:outputText value="Nro Ingreso" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:outputText value="#{ManagedLiberacionLotes.liberacionLoteBean.nroIngresoVentas}" styleClass="outputText2"/>
                            
                            <h:outputText value="Almacén" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:outputText value="#{ManagedLiberacionLotes.liberacionLoteBean.almacenesVentas.nombreAlmacenVenta}" styleClass="outputText2"/>
                            <h:outputText value="Tipo Ingreso" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:outputText value="#{ManagedLiberacionLotes.liberacionLoteBean.tiposIngresoVentas.nombreTipoIngresoVentas}" styleClass="outputText2"/>
                            <h:outputText value="Cliente" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:outputText value="#{ManagedLiberacionLotes.liberacionLoteBean.clientes.nombreCliente}" styleClass="outputText2"/>
                        </h:panelGrid>
                        <%
                            Connection con=null;
                            try
                            {
                                con=Util.openConnection(con);
                                SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy");
                                ManagedLiberacionLotes managed=(ManagedLiberacionLotes)Util.getSessionBean("ManagedLiberacionLotes");
                                out.println("<table class='tablaDatosProducto' cellpading='0' cellspacing='0'>");
                                    out.println("<thead>");
                                        out.println("<tr><td class='headerClassACliente tdCenter' colspan='2'>DATOS DE LIBERACIÓN</td></tr>");
                                    out.println("</thead>");
                                    out.println("<tbody>");
                                        out.println("<tr><td class='outputTextBold'>Lote :: </td><td class='outputText2'>"+managed.getLiberacionLoteBean().getIngresosDetalleVentasList().get(0).getCodLoteProduccion()+"</td></tr>");
                                        out.println("<tr><td class='outputTextBold'>Presentación :: </td><td class='outputText2'>"+managed.getLiberacionLoteBean().getIngresosDetalleVentasList().get(0).getPresentacionesProducto().getNombreProductoPresentacion()+"</td></tr>");
                                        out.println("<tr><td class='outputTextBold'>Cantidad :: </td><td class='outputText2'>"+managed.getLiberacionLoteBean().getIngresosDetalleVentasList().get(0).getCantidad()+"</td></tr>");
                                        out.println("<tr><td class='outputTextBold'>Cantidad Unitaria:: </td><td class='outputText2'>"+managed.getLiberacionLoteBean().getIngresosDetalleVentasList().get(0).getCantidadUnitaria()+"</td></tr>");
                                        out.println("<tr><td class='outputTextBold'>Certificado de C.C. :: </td><td class='outputText2'>");
                                            StringBuilder consulta=new StringBuilder("select ra.COD_LOTE,cpv.COD_PROD,era.NOMBRE_ESTADO_RESULTADO_ANALISIS,p.nombre_prod");
                                                                            consulta.append(",ra.NRO_ANALISIS_MICROBIOLOGICO,ra.NRO_ANALISIS,cpv.COD_FORMA");
                                                                    consulta.append(" from RESULTADO_ANALISIS ra ");
                                                                   consulta.append(" inner join PROGRAMA_PRODUCCION pp on pp.COD_COMPPROD = ra.COD_COMPROD");
                                                                   consulta.append(" and pp.COD_LOTE_PRODUCCION=ra.COD_LOTE");
                                                                   consulta.append(" inner join COMPONENTES_PROD_VERSION cpv on cpv.COD_VERSION=pp.COD_COMPPROD_VERSION");
                                                                           consulta.append(" and cpv.COD_COMPPROD=pp.COD_COMPPROD");
                                                                   consulta.append(" inner join PRODUCTOS p on p.cod_prod=cpv.COD_PROD   ");
                                                                   consulta.append(" inner join ESTADOS_RESULTADO_ANALISIS era on era.COD_ESTADO_RESULTADO_ANALISIS=ra.COD_ESTADO_RESULTADO_ANALISIS");
                                                                   consulta.append(" where ra.COD_LOTE='").append(managed.getLiberacionLoteBean().getIngresosDetalleVentasList().get(0).getCodLoteProduccion()).append("'");
                                        System.out.println(consulta.toString());
                                        Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                        ResultSet res=st.executeQuery(consulta.toString());
                                        out.println("<table class='tablaDatosProducto' cellpading='0' cellspacing='0'>");
                                            out.println("<thead><tr class='headerClassACliente tdCenter'><td>Producto</td><td>Estado</td><td>Nro Analisis Fisico Quimico</td><td>Nro Analisis Microbiologico</td><td>Certificado</td></tr></thead>");
                                            out.println("<tbody>");
                                            while(res.next())
                                            {   
                                                out.println("<tr>");
                                                    out.println("<td class='outputText2'>"+res.getString("nombre_prod")+"</td>");
                                                    out.println("<td class='outputText2'>"+res.getString("NOMBRE_ESTADO_RESULTADO_ANALISIS")+"</td>");
                                                    out.println("<td class='outputText2'>"+res.getString("NRO_ANALISIS")+"</td>");
                                                    out.println("<td class='outputText2'>"+res.getString("NRO_ANALISIS_MICROBIOLOGICO")+"</td>");
                                                    out.println("<td><a href='#' onclick=\"verCertificado('"+res.getString("COD_LOTE")+"',"+res.getInt("COD_FORMA")+","+res.getInt("COD_PROD")+")\"><img src='../img/pdf.jpg'/></a></td>");
                                                out.println("</tr>");
                                            }
                                            res.last();
                                            if(res.getRow()==0)
                                                out.println("<tr><td class='outputTextBold tdCenter' colspan='5'>SIN CERTIFICADO DE CONTROL DE CALIDAD REGISTRADO</td></tr>");
                                            out.println("</tbody>");
                                        out.println("</table>");
                                        out.println("</td></tr>");
                                        out.println("<tr><td class='outputTextBold'>O.O.S. :: </td><td class='outputText2'>");
                                            consulta=new StringBuilder("select ro.CORRELATIVO_OOS,ro.FECHA_DETECCION,ro.FECHA_ENVIO_ASC,ro.COD_REGISTRO_OOS,");
                                                                consulta.append(" p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL as personalDetecta");
                                                        consulta.append(" from REGISTRO_OOS ro");
                                                        consulta.append(" inner join PROGRAMA_PRODUCCION pp on pp.COD_PROGRAMA_PROD=ro.COD_PROGRAMA_PROD");
                                                                consulta.append(" and ro.COD_LOTE=pp.COD_LOTE_PRODUCCION");
                                                        consulta.append(" inner join personal p on p.COD_PERSONAL=ro.COD_PERSONAL_DETECTA");
                                                        consulta.append(" where ro.COD_LOTE='").append(managed.getLiberacionLoteBean().getIngresosDetalleVentasList().get(0).getCodLoteProduccion()).append("'");
                                                        consulta.append(" and pp.COD_ESTADO_PROGRAMA in (2,6,7)");
                                        System.out.println("consulta oos "+consulta.toString());
                                        res=st.executeQuery(consulta.toString());
                                        out.println("<table class='tablaDatosProducto' cellpading='0' cellspacing='0'>");
                                            out.println("<thead><tr class='headerClassACliente tdCenter'><td>Correlativo</td><td>Fecha Detección</td><td>Fecha Envio Aseguramiento</td><td>Personal que detecta</td><td>Detalle</td></tr></thead>");
                                            out.println("<tbody>");
                                            while(res.next())
                                            {   
                                                out.println("<tr>");
                                                    out.println("<td class='outputText2'>"+res.getString("CORRELATIVO_OOS")+"</td>");
                                                    out.println("<td class='outputText2'>"+sdf.format(res.getTimestamp("FECHA_DETECCION"))+"</td>");
                                                    out.println("<td class='outputText2'>"+sdf.format(res.getTimestamp("FECHA_ENVIO_ASC"))+"</td>");
                                                    out.println("<td class='outputText2'>"+res.getString("personalDetecta")+"</td>");
                                                    out.println("<td><a href='#' onclick=\"verOOS("+res.getInt("COD_REGISTRO_OOS")+")\"><img src='../img/pdf.jpg'/></a></td>");
                                                    
                                                out.println("</tr>");
                                            }
                                            res.last();
                                            if(res.getRow()==0)
                                                out.println("<tr><td class='outputTextBold tdCenter' colspan='5'>SIN REGISTROS DE O.O.S.</td></tr>");
                                            out.println("</tbody>");
                                        out.println("</table>");
                                        out.println("</td></tr>");
                                        out.println("<tr><td class='outputTextBold'>Desviación :: </td><td class='outputText2'>");
                                            consulta=new StringBuilder(" exec PAA_NAVEGADOR_DESVIACION 0,'','").append(managed.getLiberacionLoteBean().getIngresosDetalleVentasList().get(0).getCodLoteProduccion()).append("',0,0,0,0");
                                            System.out.println("consulta cargar desviaciones "+consulta.toString());
                                            res=st.executeQuery(consulta.toString());
                                            out.println("<table class='tablaDatosProducto' cellpading='0' cellspacing='0'>");
                                            out.println("<thead><tr class='headerClassACliente tdCenter'><td>Código</td><td>Fecha Envio A Aseguramiento</td><td>Area Generadora</td><td>Tipo de Reporte</td><td>Estado</td><td>Detalle</td></tr></thead>");
                                                out.println("<tbody>");
                                                    while(res.next())
                                                    {   
                                                        out.println("<tr>");
                                                            out.println("<td class='outputText2'>"+res.getString("CODIGO")+"</td>");
                                                            out.println("<td class='outputText2'>"+(res.getTimestamp("FECHA_ENVIO_ASEGURAMIENTO")!=null?sdf.format(res.getTimestamp("FECHA_ENVIO_ASEGURAMIENTO")):"")+"</td>");
                                                            out.println("<td class='outputText2'>"+res.getString("NOMBRE_AREA_GENERADORA_DESVIACION")+"</td>");
                                                            out.println("<td class='outputText2'>"+res.getString("NOMBRE_TIPO_REPORTE_DESVIACION")+"</td>");
                                                            out.println("<td class='outputText2'>"+res.getString("NOMBRES_ESTADO_DESVIACION")+"</td>");
                                                            out.println("<td><a href='#' onclick=\"verDesviacion("+res.getInt("COD_DESVIACION")+")\"><img src='../img/pdf.jpg'/></a></td>");

                                                        out.println("</tr>");
                                                    }
                                                    res.last();
                                                    if(res.getRow()==0)
                                                        out.println("<tr><td class='outputTextBold tdCenter' colspan='6'>SIN REGISTROS DE DESVIACIÓN</td></tr>");
                                                out.println("</tbody>");
                                            out.println("</table>");
                                        out.println("</td></tr>");
                                        out.println("<tr><td class='outputTextBold'>Tipo Liberación :: </td><td>");
                                        %>
                                            <h:selectOneMenu value="#{ManagedLiberacionLotes.liberacionLoteBean.liberacionLotes.tiposLiberacionLote.codTipoLiberacionLote}" styleClass="inputText">
                                                <f:selectItems value="#{ManagedLiberacionLotes.tiposLiberacionSelectList}"/>
                                            </h:selectOneMenu>
                                        <%  
                                            out.println("</td></tr>");
                                    out.println("</tbody>");
                                out.println("</table>");
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
                        
                        <a4j:commandButton action="#{ManagedLiberacionLotes.guardarLiberarLote_action}"
                                           onclick="if(!confirm('Esta seguro de liberar')){return false;}"
                                           oncomplete="if(#{ManagedLiberacionLotes.mensaje eq '1'}){alert('Se realizo la liberación');redireccionar('navegadorLiberacionLotes.jsf');}else{alert('#{ManagedLiberacionLotes.mensaje}');}"
                                           styleClass="btn" value="Liberar"/>
                        <a4j:commandButton oncomplete="redireccionar('navegadorLiberacionLotes.jsf');"
                                           styleClass="btn" value="Cancelar"/>
                    </rich:panel>
                    
                    <br>
                    
                    
                </div>
                <a4j:status id="statusPeticion"
                            onstart="Richfaces.showModalPanel('ajaxLoadingModalBox',{width:100, top:100})"
                            onstop="Richfaces.hideModalPanel('ajaxLoadingModalBox')">
                </a4j:status>

                <rich:modalPanel id="ajaxLoadingModalBox" minHeight="100"
                                 minWidth="200" height="80" width="400" zindex="100" onshow="window.focus();">

                    <div align="center">
                        <h:graphicImage value="../img/load2.gif" />
                    </div>
                </rich:modalPanel>
            </a4j:form>
           
            
    </html>
    
</f:view>

