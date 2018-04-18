<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>

<rich:modalPanel id="panelDuplicarInformacionProducto"
                    minHeight="320"  minWidth="700"
                    height="320" width="700" zindex="200"
                    headerClass="headerClassACliente"
                    resizeable="false">
    <f:facet name="header">
        <h:outputText value="<center>Replicar Información</center>" escape="false" />
    </f:facet>
    <a4j:form id="formDuplicarInformacion">
        <center>
        <h:panelGroup id="contenidoDuplicarInformacionProducto">
            <rich:panel headerClass="headerClassACliente">
                <f:facet name="header">
                    <h:outputText value="Producto"/>
                </f:facet>
                <h:panelGrid columns="3">
                    <h:outputText value="Nombre del producto" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:outputText value="#{ManagedComponentesProdVersion.componentesProdVersionDestinoInformacion.nombreProdSemiterminado}" styleClass="outputText2"/>
                    <h:outputText value="Número de Versión" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:outputText value="#{ManagedComponentesProdVersion.componentesProdVersionDestinoInformacion.nroVersion}" styleClass="outputText2"/>
                </h:panelGrid>
            </rich:panel>
                <h:panelGrid columns="3">
                    <h:outputText value="Producto Fuente de la información" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:selectOneMenu value="#{ManagedComponentesProdVersion.componentesProdVersionFuenteInformacion.codVersion}" styleClass="chosen">
                        <f:selectItems value="#{ManagedComponentesProdVersion.componentesProdVersionFuenteList}"/>
                    </h:selectOneMenu>
                </h:panelGrid>
            <rich:panel headerClass="headerClassACliente">
                <f:facet name="header">
                    <h:outputText value="Información a duplicar"/>
                </f:facet>
                <h:panelGrid columns="6">     
                    <h:outputText value="Procesos habilitados" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:selectBooleanCheckbox value="#{ManagedComponentesProdVersion.duplicarProcesosHabilitados}"/>
                    <h:outputText value="Datos Limpieza" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:selectBooleanCheckbox value="#{ManagedComponentesProdVersion.duplicarDatosLimpieza}"/>
                    <h:outputText value="Indicaciones Proceso" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:selectBooleanCheckbox value="#{ManagedComponentesProdVersion.duplicarIndicacionesProceso}"/>
                    <h:outputText value="Documentación Aplicada" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:selectBooleanCheckbox value="#{ManagedComponentesProdVersion.duplicarDocumentacionProceso}"/>
                    <h:outputText value="Especificaciones Maquinaria" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:selectBooleanCheckbox value="#{ManagedComponentesProdVersion.duplicarEspecificacionesMaquinaria}"/>
                    <h:outputText value="Flujo Preparado" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:selectBooleanCheckbox value="#{ManagedComponentesProdVersion.duplicarFlujoPreparado}"/>
                </h:panelGrid>
            </rich:panel>
            <a4j:commandButton value="Guardar" styleClass="btn" action="#{ManagedComponentesProdVersion.guardarDuplicarInformacionProducto_action}"
                               oncomplete="mostrarMensajeTransaccionEvento(function(){Richfaces.hideModalPanel('panelDuplicarInformacionProducto')})"/>
            <a4j:commandButton value="Cancelar" oncomplete="Richfaces.hideModalPanel('panelDuplicarInformacionProducto')" styleClass="btn"/>
            
        </h:panelGroup>
        </center>
    </a4j:form>
</rich:modalPanel>