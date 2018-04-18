<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>

<rich:modalPanel id="panelAgregarDesviacionFormulaMaestraDetalleEp"
                minHeight="300"  minWidth="700"
                height="300" width="700" zindex="200"
                headerClass="headerClassACliente"
                resizeable="false">
    <f:facet name="header">
        <h:outputText value="<center>Agregar Material de Empaque Primario</center>" escape="false" />
    </f:facet>
    <a4j:form id="formAgregarEp">
        <center>
        <h:panelGroup id="contenidoAgregarDesviacionFormulaMaestraDetalleEp">
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
                <h:panelGrid columns="3">
                    <h:outputText value="Material" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:selectOneMenu id="codMaterialAgregarPresentacionPrimaria" style="width:400px" value="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleEpAgregar.materiales.codMaterial}" styleClass="inputText chosen">
                        <f:selectItems value="#{ManagedProgramaProduccionDesviacion.materialesDesviacionSelectList}"/>
                    </h:selectOneMenu>
                    <h:outputText value="Cantidad Unitaria" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:inputText onkeypress="valNum(event)" styleClass="inputText" id="cantidadUnitariaEp"  onblur="valorPorDefecto(this)" value="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleEpAgregar.cantidadUnitaria}"/>
                    
                </h:panelGrid>
                <br/>
                <a4j:commandButton action="#{ManagedProgramaProduccionDesviacion.completarAgregarDesviacionFormulaMaestraDetalleEp_action}" value="Guardar" reRender="dataMaterialesEP" oncomplete="javascript:Richfaces.hideModalPanel('panelAgregarDesviacionFormulaMaestraDetalleEp');recalcularTablasEp();" styleClass="btn"
                                   onclick="if(!validarAgregarFormulaMaestraDetalleEp()){return false;}"/>
                <a class="btn" onclick="Richfaces.hideModalPanel('panelAgregarDesviacionFormulaMaestraDetalleEp');">Cancelar</a>
             </rich:panel>



        </h:panelGroup>
        
        </center>
    </a4j:form>
</rich:modalPanel>