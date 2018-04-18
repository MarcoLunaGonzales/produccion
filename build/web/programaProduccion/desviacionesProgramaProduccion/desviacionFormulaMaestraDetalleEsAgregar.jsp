<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>

<rich:modalPanel id="panelAgregarDesviacionFormulaMaestraDetalleEs"
                             minHeight="310"  minWidth="700"
                             height="310" width="700" zindex="200"
                             headerClass="headerClassACliente"
                             resizeable="false">
    <f:facet name="header">
        <h:outputText value="<center>Agregar Material de Empaque Secundario</center>" escape="false" />
    </f:facet>
    <a4j:form id="formAgregarEs">
        <center>
        <h:panelGroup id="contenidoAgregarDesviacionFormulaMaestraDetalleEs">
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
                    <h:selectOneMenu id="codMaterialAgregarPresentacion" value="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleEsAgregar.materiales.codMaterial}" styleClass="inputText chosen">
                        <f:selectItems value="#{ManagedProgramaProduccionDesviacion.materialesDesviacionSelectList}"/>
                    </h:selectOneMenu>
                    <h:outputText value="Cantidad" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:inputText value="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleEsAgregar.cantidad}" styleClass="inputText" onkeypress="valNum(event)" onblur="valorPorDefecto(this)" id="cantidadMaterial"/>

                </h:panelGrid>
                <a4j:commandButton action="#{ManagedProgramaProduccionDesviacion.completarAgregarDesviacionFormulaMaestraDetalleEs_action}" value="Guardar" reRender="dataMaterialesES" oncomplete="javascript:Richfaces.hideModalPanel('panelAgregarDesviacionFormulaMaestraDetalleEs');" 
                                   onclick="if(!validarAgregarFormulaMaestraDetalleEs()){return false;}" styleClass="btn"/>
                <a4j:commandButton value="Cancelar" oncomplete="javascript:Richfaces.hideModalPanel('panelAgregarDesviacionFormulaMaestraDetalleEs');" styleClass="btn"/>
             </rich:panel>

            

        </h:panelGroup>
        
        </center>
    </a4j:form>
</rich:modalPanel>