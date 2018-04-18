<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>


<rich:modalPanel id="panelEditarDesviacionFormulaMaestraDetalleMp"
                minHeight="340"  minWidth="700"
                height="340" width="700" zindex="200"
                headerClass="headerClassACliente"
                resizeable="false">
    <f:facet name="header">
        <h:outputText value="<center>Editar Materia Prima</center>" escape="false" />
    </f:facet>
    <a4j:form id="formEditarDesviacionFormulaMaestraDetalleMp">
        <center>
        <h:panelGroup id="contenidoAgregarDesviacionFormulaMaestraDetalleMp">
            <rich:panel headerClass="headerClassACliente">
                <h:panelGrid columns="3">
                    <h:outputText value="Producto" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:outputText value="#{ManagedProgramaProduccionDesviacion.componentesProdBean.nombreProdSemiterminado}" styleClass="outputText2"/>
                </h:panelGrid>
            </rich:panel>
            <rich:panel headerClass="headerClassACliente">
                <f:facet name="header">
                    <h:outputText value="Datos del material"/>
                </f:facet>
                <h:panelGrid columns="3">
                    <h:outputText value="Tipo Material" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:outputText value="#{ManagedProgramaProduccionDesviacion.tiposMaterialProduccionBean.nombreTipoMaterialProduccion}" styleClass="outputText2"/>
                    <h:outputText value="Material" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:outputText value="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleMpEditar.materiales.nombreMaterial}" styleClass="outputText2"/>
                    <h:outputText value="Cantidad Unitaria(g)" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:inputText value="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleMpEditar.cantidadUnitariaGramos}" styleClass="outputText2" id="cantidadUnitariAgregar" onkeyup="valNum(this)" onblur="valorPorDefecto(this)">
                        <f:convertNumber pattern="##0.00#####" locale="en"/>
                    </h:inputText>
                    <h:outputText value="Densidad(g/ml)" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:panelGroup id="contenedorDensidad">
                        <h:inputText id="valorConversionDensidad" value="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleMpEditar.densidadMaterial}" rendered="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleMpEditar.unidadesMedida.tipoMedida.codTipoMedida!=2}" size="10" onblur="valorPorDefecto(this);validarMayorIgualACero(this);" styleClass="inputText" onkeyup="calcularTotalLote(this);"  onkeypress="valNum(event);">
                            <f:convertNumber pattern="###0.0######" locale="en"/>
                        </h:inputText>
                        <h:outputText value="N.A." styleClass="outputText2" rendered="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleMpEditar.unidadesMedida.tipoMedida.codTipoMedida eq 2}"/>
                    </h:panelGroup>
                    <h:outputText value="Cantidad Por Fracción(g)" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:panelGroup id="contenedorCantidad">
                        <h:selectBooleanCheckbox value="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleMpEditar.aplicaCantidadMaximaPorFraccion}">
                            <a4j:support event="onclick" reRender="contenedorCantidad"/>
                        </h:selectBooleanCheckbox>
                        <h:inputText id="cantidadMaximaFraccion" value="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleMpEditar.cantidadMaximaMaterialPorFraccion}" onkeyup="valNum(this)" onblur="valorPorDefecto(this)"
                                     rendered="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleMpEditar.aplicaCantidadMaximaPorFraccion}"
                            size="10"/>
                    </h:panelGroup>
                </h:panelGrid>
                <br/>
                <a4j:commandButton action="#{ManagedProgramaProduccionDesviacion.completarEditarFormulaMaestraAgregarMp_action}" value="Guardar" reRender="panelMp" oncomplete="Richfaces.hideModalPanel('panelEditarDesviacionFormulaMaestraDetalleMp');" styleClass="btn"
                                   onclick="if(!validarEditarFormulaMaestraDetalleMp()){return false;}"/>
                <a4j:commandButton value="Cancelar" oncomplete="javascript:Richfaces.hideModalPanel('panelEditarDesviacionFormulaMaestraDetalleMp');" styleClass="btn"/>
             </rich:panel>

        </h:panelGroup>

        </center>
    </a4j:form>
</rich:modalPanel>


