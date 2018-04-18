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
<%@page import="java.text.DecimalFormatSymbols" %>
<%@ page import = "java.text.NumberFormat"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<f:view>


    <html>
       <head>
            <meta http-equiv="Expires" content="0">
            <meta http-equiv="Last-Modified" content="0">
            <meta http-equiv="Cache-Control" content="no-cache, mustrevalidate">
            <meta http-equiv="Pragma" content="no-cache">
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
            <script type="text/javascript" src="../../js/general.js"></script>
            <style>
                .eliminado
                {
                    background-color:#FFB6C1;
                }
                .modificado
                {
                    background-color:#F0E68C;
                }
                .especificacion
                {
                    font-weight:bold;
                    background-color:white;
                }
                .nuevo
                {
                    background-color:#b6f5b6;
                }
                .celdaQuimica
                {
                    background-color:white;
                    font-weight:bold;
                }
                .tablaComparacion
                {
                    font-family:Verdana, Arial, Helvetica, sans-serif;
                    font-size:11px;
                    margin-top:1em;
                    border-top:1px solid #aaaaaa;
                    border-left:1px solid #aaaaaa;
                }
                .tablaComparacion tr td
                {
                    padding:0.4em;
                    border-bottom:1px solid #aaaaaa;
                    border-right:1px solid #aaaaaa;
                }
                .tablaComparacion thead tr td
                {
                    font-weight:bold;
                    background-color:#ebeaeb;
                    color:black;
                    text-align:center;
                }
            </style>
        </head>
        <body>
            
            <a4j:form >
                <div align="center">                    
                    <h:outputText value="Revisión de versión de producto" styleClass="outputTextBold" style="font-size:14px"/>
                    <rich:panel headerClass="headerClassACliente" style="width:60%">
                        <f:facet name="header">
                            <h:outputText value="Datos de Producto"/>
                        </f:facet>
                        <h:panelGrid columns="3">
                            <h:outputText value="Producto" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="#{ManagedComponentesProdVersion.componentesProdVersionRevisar.nombreProdSemiterminado}" styleClass="outputText2" />
                            <h:outputText value="Fecha Creacion" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="#{ManagedComponentesProdVersion.componentesProdVersionRevisar.fechaModificacion}" styleClass="outputText2">
                                <f:convertDateTime pattern="dd/MM/yyyy HH:mm"/>
                            </h:outputText>
                            <h:outputText value="Personal Colaboración" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <rich:dataTable value="#{ManagedComponentesProdVersion.componentesProdVersionRevisar.componentesProdVersionModificacionList}"
                            var="data">
                                <rich:column>
                                    <h:outputText value="#{data.personal.nombrePersonal}"/>
                                </rich:column>
                            </rich:dataTable>
                            <h:outputText value="Nro Version" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="#{ManagedComponentesProdVersion.componentesProdVersionRevisar.nroVersion}" styleClass="outputText2" />
                            
                        </h:panelGrid>
                    </rich:panel>
                        <h:outputText  value="<iframe frameborder='yes' framespacing='0' border='0' name='reporteComparacion' id='reporteComparacion' src=\"../../componentesProdVersion/reporteComparacionVersionesJasper.jsf?codVersion=#{ManagedComponentesProdVersion.componentesProdVersionRevisar.codVersion}&codCompProd=#{ManagedComponentesProdVersion.componentesProdVersionRevisar.codCompprod}\" width=\"80%\" height=\"1400px\"></iframe><br>" escape="false"/>
                    <%
                    Connection con=null;
                    try
                    {
                        con=Util.openConnection(con);
                        ManagedComponentesProdVersion managed=(ManagedComponentesProdVersion)Util.getSessionBean("ManagedComponentesProdVersion");
                        String consulta="select f.COD_FORMULA_MAESTRA_ES_VERSION"+
                                   " from FORMULA_MAESTRA_ES_VERSION f "+
                                   " where f.COD_VERSION="+managed.getComponentesProdVersionRevisar().getCodVersion();
                        Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                        ResultSet res=st.executeQuery(consulta);
                        if(res.next())
                        {
                           out.println("<br><iframe src=\"../../formullaMaestraVersiones/formulaMaestraDetalleES/empaqueSecundarioJasper/reporteComparacionVersionesEmpaqueSecundario.jsf?codFormulaMaestraEsVersion="+res.getInt("COD_FORMULA_MAESTRA_ES_VERSION")+"\" width=\"80%\" height=\"1000px\"></iframe><br>"); 
                        }
                             
                            
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
                    
                    <a4j:commandButton styleClass="btn"  action="#{ManagedComponentesProdVersion.guardarAprobacionVersionComponentesProd_action}" value="Revisión Correcta"
                    oncomplete="mostrarMensajeTransaccionEvento(function(){redireccionar('navegadorComponentesProdAprobacion.jsf')})"/>
                    <a4j:commandButton styleClass="btn"  value="Cancelar" oncomplete="redireccionar('navegadorComponentesProdAprobacion.jsf')"/>
                    
                </div>
            </a4j:form>
            
            <a4j:include viewId="/panelProgreso.jsp"/>
            <a4j:include viewId="/message.jsp"/>
        </body>
    </html>
    
</f:view>

