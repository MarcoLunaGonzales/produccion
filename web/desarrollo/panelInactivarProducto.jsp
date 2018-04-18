<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>

<rich:modalPanel id="panelInactivarComponentesProd" minHeight="160" headerClass="headerClassACliente"
                minWidth="550" height="160" width="700" zindex="100" >
    <f:facet name="header">
        <h:outputText value="<center>Inactivar producto</center>" escape="false"/>
    </f:facet>
    <a4j:form id="formInactivarComponentesProd">
        <center>
            <h:outputText  value="Esta seguro de inactivar el siguiente producto?" styleClass="outputTextBold"/>
            <br/>
            <h:panelGroup id="contenidoInactivarComponentesProd">
                <h:panelGrid columns="3">
                    <h:outputText value="Producto" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:outputText value="#{ManagedProductosDesarrolloVersion.componentesProdSeleccionado.nombreProdSemiterminado}"styleClass="outputText2"/>
                    <h:outputText value="N° Versión" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:outputText value="#{ManagedProductosDesarrolloVersion.componentesProdSeleccionado.nroUltimaVersion}" styleClass="outputText2"/>
                    <h:outputText value="Tamaño Lote Original" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:outputText value="#{ManagedProductosDesarrolloVersion.componentesProdSeleccionado.tamanioLoteProduccion}" styleClass="outputText2"/>
                </h:panelGrid>
            </h:panelGroup>
            <br/>
            <a4j:commandButton action="#{ManagedProductosDesarrolloVersion.cambiarEstadoProductoAction(2)}" 
                               oncomplete="mostrarMensajeTransaccionEvento(function(){Richfaces.hideModalPanel('panelInactivarComponentesProd');})"
                               reRender="dataComponentesProd"
                               styleClass="btn" value="Inactivar Producto"/>
            <a4j:commandButton value="Cancelar" styleClass="btn" oncomplete="Richfaces.hideModalPanel('panelInactivarComponentesProd')"/>
        </center>

    </a4j:form>

</rich:modalPanel>


