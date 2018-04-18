<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<rich:modalPanel id="panelAnularEnvioAcond" minHeight="220"  minWidth="500"
                     height="220" width="350"
                     zindex="200"
                     headerClass="headerClassACliente"
                     resizeable="false" style="overflow :auto"  >
    <f:facet name="header">
        <h:outputText value="<center>Cancelar Envio de Producto</center>" escape="false"/>
    </f:facet>
    <a4j:form>
        <h:outputText value="Esta seguro de anular el siguiente envio de producto?" styleClass="outputText2"/>
        <center>
            <h:panelGrid columns="3" id="dataAnularEnvioAcond" styleClass="margin-top:1rem">
                <f:facet name="header">
                    <h:outputText value="Datos del Envio"/>
                </f:facet>
                <h:outputText value="Nro. Ingreso" styleClass="outputTextBold"/>
                <h:outputText value="::" styleClass="outputTextBold"/>
                <h:outputText value="#{ManagedProgramaProduccion.ingresosAcond.nroIngresoAcond}" 
                              styleClass="outputText2"/>
                <h:outputText value="Almacen Destino" styleClass="outputTextBold"/>
                <h:outputText value="::" styleClass="outputTextBold"/>
                <h:outputText value="#{ManagedProgramaProduccion.ingresosAcond.almacenAcond.nombreAlmacenAcond}" 
                              styleClass="outputText2"/>
                <h:outputText value="Fecha de envio" styleClass="outputTextBold"/>
                <h:outputText value="::" styleClass="outputTextBold"/>
                <h:outputText value="#{ManagedProgramaProduccion.ingresosAcond.fechaIngresoAcond}" styleClass="outputText2">
                    <f:convertDateTime pattern="dd/MM/yyyy" locale="en"/>
                </h:outputText>
                <h:outputText value="Cantidad" styleClass="outputTextBold"/>
                <h:outputText value="::" styleClass="outputTextBold"/>
                <h:outputText value="#{ManagedProgramaProduccion.ingresosAcond.ingresosDetalleAcondList.get(0).cantIngresoProduccion}" styleClass="outputText2">
                    <f:convertNumber pattern="##,###" locale="en"/>
                </h:outputText>
            </h:panelGrid>
        </center>
        <div class="footerPanel">
            <a4j:commandButton value="Anular Envio" styleClass="btn" reRender="contenidoEnviosRealizados"
                               action="#{ManagedProgramaProduccion.anularIngresoAcondAction()}"
                               oncomplete="mostrarMensajeTransaccionEvento(function(){Richfaces.hideModalPanel('panelAnularEnvioAcond');})"/>
            <a4j:commandButton value="Cancelar" styleClass="btn"
                               oncomplete="Richfaces.hideModalPanel('panelAnularEnvioAcond');"/>
        </div>

    </a4j:form>
</rich:modalPanel>