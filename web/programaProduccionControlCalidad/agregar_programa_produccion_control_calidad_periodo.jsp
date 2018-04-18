<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>
    
    <html>
        <head>
            <title></title>
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" /> 
            <script type="text/javascript" src="../js/general.js" ></script> 
            
        </head>
        <body>
            
        <div align="center">
            <h:form id="form1">
                <h:outputText value="#{ManagedProgramaProduccionControlCalidad.cargarNuevoRegistroProgramaPeriodo}"/>
             <rich:panel headerClass="headerClassACliente" style="width:50%;align:center">
                <f:facet name="header">
                        <h:outputText value="Agregar Programa Produccion Control de Calidad"/>
                </f:facet>
                <h:panelGrid columns="2">
                    <h:outputText value="Programa Produccion" styleClass="outputText2" />
                    <h:inputText value="#{ManagedProgramaProduccionControlCalidad.programaProduccionPeriodo.nombreProgramaProduccion}" styleClass="inputText" size="50" />
                    <h:outputText value="observaciones" styleClass="outputText2" />
                    <h:inputTextarea value="#{ManagedProgramaProduccionControlCalidad.programaProduccionPeriodo.obsProgramaProduccion}" styleClass="inputText" cols="50" />
                </h:panelGrid>
                <div align="center">
                    <h:commandButton action="#{ManagedProgramaProduccionControlCalidad.guardarProgramaProduccionPeriodo_action}" value="Agregar" styleClass="btn" />
                    <a4j:commandButton onclick="window.location.href='navegador_programa_periodo_control_calidad.jsf'" styleClass="btn" value="cancelar" />
                </div>
             </rich:panel>
             </h:form>
         </div>
            
        </body>
        <script type="text/javascript" language="JavaScript"  src="../js/dlcalendar.js"></script>
        
    </html>
    
</f:view>

