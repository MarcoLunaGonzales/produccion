<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<rich:modalPanel id="panelTerminarLoteManual" minHeight="230"  minWidth="350"
                     height="230" width="350"
                     zindex="200"
                     headerClass="headerClassACliente"
                     resizeable="false" style="overflow :auto"  >
    <f:facet name="header">
        <h:outputText value="<center>Terminar Lote de Producción</center>" escape="false"/>
    </f:facet>
    <a4j:form>
        <h:outputText value="Esta seguro de cambiar el estado a TERMINADO/ ENVIADO manualmente?" styleClass="outputText2"/>
        <center>
            <h:panelGrid columns="3" id="dataTerminarLoteManual" styleClass="margin-top:1rem">
                <f:facet name="header">
                    <h:outputText value="Datos del lote"/>
                </f:facet>
                <h:outputText value="Lote" styleClass="outputTextBold"/>
                <h:outputText value="::" styleClass="outputTextBold"/>
                <h:outputText value="#{ManagedProgramaProduccion.programaProduccionCabeceraEditar.codLoteProduccion}" 
                              styleClass="outputText2"/>
                <h:outputText value="Producto" styleClass="outputTextBold"/>
                <h:outputText value="::" styleClass="outputTextBold"/>
                <h:outputText value="#{ManagedProgramaProduccion.programaProduccionCabeceraEditar.formulaMaestra.componentesProd.nombreProdSemiterminado}"
                              styleClass="outputText2"/>
                <h:outputText value="Area" styleClass="outputTextBold"/>
                <h:outputText value="::" styleClass="outputTextBold"/>
                <h:outputText value="#{ManagedProgramaProduccion.programaProduccionCabeceraEditar.formulaMaestra.componentesProd.areasEmpresa.nombreAreaEmpresa}"
                              styleClass="outputText2"/>
            </h:panelGrid>
        </center>
        <div class="footerPanel">
            <a4j:commandButton value="Terminar Lote" styleClass="btn" reRender="dataProgramaProduccion"
                               action="#{ManagedProgramaProduccion.terminarProductoManualmente_action()}"
                               oncomplete="mostrarMensajeTransaccionEvento(function(){Richfaces.hideModalPanel('panelTerminarLoteManual');})"/>
            <a4j:commandButton value="Cancelar" styleClass="btn"
                               oncomplete="Richfaces.hideModalPanel('panelTerminarLoteManual');"/>
        </div>

    </a4j:form>
</rich:modalPanel>