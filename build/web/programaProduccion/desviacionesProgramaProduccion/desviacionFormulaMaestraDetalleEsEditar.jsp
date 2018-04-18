<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>

<rich:modalPanel id="panelEditarDesviacionFormulaMaestraDetalleEs"
                minHeight="310" minWidth="500"
                height="310" width="500" zindex="200"
                headerClass="headerClassACliente"
                resizeable="false">
    <f:facet name="header">
        <h:outputText value="<center>Edición de Material de Empaque Secundario</center>" escape="false" />
    </f:facet>
    <a4j:form id="formEditarEs">
        <center>
        <h:panelGroup id="contenidoEditarDesviacionFormulaMaestraDetalleEs">
            <rich:panel headerClass="headerClassACliente">
                <f:facet name="header">
                    <h:outputText value="Presentación"/>
                </f:facet>
                <h:panelGrid columns="3">
                    <h:outputText value="Tipo Producción" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:outputText value="#{ManagedProgramaProduccionDesviacion.componentesPresProdBean.tiposProgramaProduccion.nombreTipoProgramaProd}" styleClass="outputText2"/>
                    <h:outputText value="Producto" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:outputText value="#{ManagedProgramaProduccionDesviacion.componentesPresProdBean.presentacionesProducto.nombreProductoPresentacion}" styleClass="outputText2"/>
                </h:panelGrid>
            </rich:panel>
            <rich:panel headerClass="headerClassACliente">
                <f:facet name="header">
                    <h:outputText value="Datos del material"/>
                </f:facet>
                <h:panelGrid columns="3">
                    <h:outputText value="Material" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:outputText value="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleEsEditar.materiales.nombreMaterial}" styleClass="outputText2"/>
                    <h:outputText value="Unidad de Medida" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:outputText value="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleEsEditar.unidadesMedida.nombreUnidadMedida}" styleClass="outputText2"/>
                    <h:outputText value="Cantidad" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:inputText value="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleEsEditar.cantidad}" styleClass="inputText" onkeypress="valNum(event);" onblur="valorPorDefecto(this)"
                                 id="cantidadMaterial"/>
                </h:panelGrid>
             </rich:panel>
        </h:panelGroup>
        <div align="center" style="margin-top:1em">
            <a4j:commandButton value="Guardar" reRender="dataMaterialesES" oncomplete="javascript:Richfaces.hideModalPanel('panelEditarDesviacionFormulaMaestraDetalleEs');" styleClass="btn"
                               onclick="if(!validarEditarFormulaMaestraDetalleEs()){return false;}"/>
            <a4j:commandButton value="Cancelar" oncomplete="javascript:Richfaces.hideModalPanel('panelEditarDesviacionFormulaMaestraDetalleEs');" styleClass="btn"/>
        </div>
        </center>
    </a4j:form>
</rich:modalPanel>