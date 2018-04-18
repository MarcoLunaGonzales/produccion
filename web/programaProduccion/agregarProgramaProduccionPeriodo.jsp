<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>
    
    <html>
        <head>
            <meta http-equiv="X-UA-Compatible" content="IE = 7" />
            <Meta  http-equiv = "X-UA-Compatible"  contenido = "IE = EmulateIE8"  />
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" /> 
            <script type="text/javascript" src="../js/general.js" ></script> 
        </head>
        <body>
            <a4j:form id="form1"  >
                <h:outputText value="#{ManagedProgramaProduccion.cargarAgregarProgramaProduccionPeriodo}"/>
                <center>
                <rich:panel headerClass="headerClassACliente" style="width:80%">
                    <f:facet name="header">
                        <h:outputText value="Agregar Programa Produccion Periodo"/>
                    </f:facet>
                    <h:panelGrid columns="3">
                        <h:outputText value="Nombre" styleClass="outputTextBold"/>
                        <h:outputText value="::" styleClass="outputTextBold"/>
                        <h:panelGroup>
                            <h:inputText required="true" validatorMessage="Debe registrar el nombre del programa de produccion" id="nombreProgramaProduccion"
                                         requiredMessage="Debe registrar el nombre del programa de produccion"
                                         value="#{ManagedProgramaProduccion.programaProduccionPeriodoAgregar.nombreProgramaProduccion}" styleClass="inputText" style="width:30em">
                                <f:validateLength minimum="4"/>
                            </h:inputText>
                            <h:message for="nombreProgramaProduccion" styleClass="mensajeValidacion"/>
                        </h:panelGroup>
                        <h:outputText value="Observación" styleClass="outputTextBold"/>
                        <h:outputText value="::" styleClass="outputTextBold"/>
                        <h:inputTextarea value="#{ManagedProgramaProduccion.programaProduccionPeriodoAgregar.obsProgramaProduccion}" styleClass="inputText" style="width:30em"
                        rows="4"/>
                        <h:outputText value="Estado" styleClass="outputTextBold"/>
                        <h:outputText value="::" styleClass="outputTextBold"/>
                        <h:outputText value="REGISTRADO" styleClass="outputText2"/>
                        <h:outputText value="Fecha Inicio" styleClass="outputTextBold"/>
                        <h:outputText value="::" styleClass="outputTextBold"/>
                        <h:panelGroup>
                            <h:inputText value="#{ManagedProgramaProduccion.programaProduccionPeriodoAgregar.fechaInicio}" styleClass="inputText" id="fechaInicio">
                                <f:convertDateTime pattern="dd/MM/yyyy"/>
                            </h:inputText>
                            <h:graphicImage url="../img/fecha.bmp" id="imagenFecha1"/>
                            <DLCALENDAR tool_tip="Seleccione la Fecha" input_element_id="form1:fechaInicio" click_element_id="form1:imagenFecha1"/>
                        </h:panelGroup>
                        
                        <h:outputText value="Fecha Final" styleClass="outputTextBold"/>
                        <h:outputText value="::" styleClass="outputTextBold"/>
                        <h:panelGroup>
                            <h:inputText value="#{ManagedProgramaProduccion.programaProduccionPeriodoAgregar.fechaFinal}" styleClass="inputText" id="fechaFinal">
                                <f:convertDateTime pattern="dd/MM/yyyy"/>
                            </h:inputText>
                            <h:graphicImage url="../img/fecha.bmp" id="imagenFechaFinal"/>
                            <DLCALENDAR tool_tip="Seleccione la Fecha" input_element_id="form1:fechaFinal" click_element_id="form1:imagenFechaFinal"/>
                        </h:panelGroup>
                        
                    </h:panelGrid>
                    <div style="margin-top:1em;">
                        <a4j:commandButton status="statusGuardad" reRender="form1" value="Guardar" action="#{ManagedProgramaProduccion.guardarNuevoProgramaProduccionPeriodo_action}" styleClass="btn"
                                           oncomplete="if('#{facesContext.maximumSeverity}'.length==0){mostrarMensajeTransaccionEvento(function(){redireccionar('navegadorProgramaPeriodo.jsf')})}"
                                            />
                        <a4j:commandButton status="statusGuardad" value="Cancelar" oncomplete="window.location.href='navegadorProgramaPeriodo.jsf?data'+(new Date()).getTime().toString();" styleClass="btn"/>
                    </div>
                </rich:panel>
                    
                </center>
                
            </a4j:form>
            <a4j:include viewId="../message.jsp" />
            <a4j:status id="statusGuardad"
                        onstart="Richfaces.showModalPanel('ajaxLoadingModalBox');"
                        onstop="Richfaces.hideModalPanel('ajaxLoadingModalBox');">
            </a4j:status>

            <rich:modalPanel id="ajaxLoadingModalBox" minHeight="100"
                             minWidth="200" height="80" width="400" zindex="100" onshow="window.focus();">
                <div align="center">
                    <h:graphicImage value="../img/load2.gif" />
                </div>
            </rich:modalPanel>


        </body>
        <script type="text/javascript" language="javaScript"  src="../js/dlcalendar.js">
        </script>
        
    </html>
    
</f:view>

