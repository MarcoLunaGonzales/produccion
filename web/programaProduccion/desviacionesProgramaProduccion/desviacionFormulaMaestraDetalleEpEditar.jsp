<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>

<rich:modalPanel id="panelEditarDesviacionFormulaMaestraDetalleEp"
                minHeight="310"  minWidth="700"
                height="310" width="700" zindex="200"
                headerClass="headerClassACliente"
                resizeable="false">
    <f:facet name="header">
        <h:outputText value="<center>Edición de Material de Empaque Primario</center>" escape="false" />
    </f:facet>
    <a4j:form id="formEditarEp">
        <center>
        <h:panelGroup id="contenidoEditarDesviacionFormulaMaestraDetalleEp">
            <rich:panel headerClass="headerClassACliente">
                <f:facet name="header">
                    <h:outputText value="Presentación Primaria"/>
                </f:facet>
                <h:panelGrid columns="6">
                    <h:outputText value="Tipo Producción" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:outputText value="#{ManagedProgramaProduccionDesviacion.presentacionesPrimariasBean.tiposProgramaProduccion.nombreTipoProgramaProd}" styleClass="outputText2"/>
                    <h:outputText value="Envase" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:outputText value="#{ManagedProgramaProduccionDesviacion.presentacionesPrimariasBean.envasesPrimarios.nombreEnvasePrim}" styleClass="outputText2"/>
                    <h:outputText value="Cantidad Por Envase" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:outputText value="#{ManagedProgramaProduccionDesviacion.presentacionesPrimariasBean.cantidad}" styleClass="outputText2"/>
                    <h:outputText value="Cantidad Presentaciones Primarias" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:outputText value="#{ManagedProgramaProduccionDesviacion.presentacionesPrimariasBean.cantidadPresentacionesPrimarias}" styleClass="outputText2"/>
                    
                </h:panelGrid>
            </rich:panel>
            <rich:panel headerClass="headerClassACliente">
                <f:facet name="header">
                    <h:outputText value="Datos del material"/>
                </f:facet>
                <h:panelGrid columns="6">
                    <h:outputText value="Material" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:outputText value="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleEpEditar.materiales.nombreMaterial}" styleClass="outputText2"/>
                    <h:outputText value="Unidad de Medida" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:outputText value="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleEpEditar.unidadesMedida.nombreUnidadMedida}" styleClass="outputText2"/>
                    <h:outputText value="Cantidad Unitaria" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:inputText value="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleEpEditar.cantidadUnitaria}" styleClass="inputText" onkeypress="valNum(event);" onblur="valorPorDefecto(this)"
                                 id="cantidadUnitariaEp"/>
                </h:panelGrid>
             </rich:panel>
        </h:panelGroup>
        <div align="center" style="margin-top:1em">
            <a4j:commandButton value="Guardar" reRender="dataMaterialesEP" action="#{ManagedProgramaProduccionDesviacion.completarEditarDesviacionFormulaMaestraDetalleEp_action}"
                               onclick="if(!validarEditarFormulaMaestraDetalleEp()){return false;}"
                               oncomplete="Richfaces.hideModalPanel('panelEditarDesviacionFormulaMaestraDetalleEp');" styleClass="btn"/>
            <a4j:commandButton value="Cancelar" oncomplete="javascript:Richfaces.hideModalPanel('panelEditarDesviacionFormulaMaestraDetalleEp');" styleClass="btn"/>
        </div>
        </center>
    </a4j:form>
</rich:modalPanel>