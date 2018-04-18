<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>


<rich:modalPanel id="panelAgregarDesviacionFormulaMaestraDetalleMp"
                minHeight="340"  minWidth="700"
                height="340" width="700" zindex="200"
                headerClass="headerClassACliente"
                resizeable="false">
    <f:facet name="header">
        <h:outputText value="<center>Agregar Materia Prima</center>" escape="false" />
    </f:facet>
    <a4j:form id="formAgregar">
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
                    <h:selectOneMenu value="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleMpAgregar.tiposMaterialProduccion.codTipoMaterialProduccion}"
                                     styleClass="inputText chosen" >
                        <f:selectItems value="#{ManagedProgramaProduccionDesviacion.tiposMaterialProduccionSelectList}"/>
                        <a4j:support event="onchange" action="#{ManagedProgramaProduccionDesviacion.codTipoMaterialDesviacionFormulaMaestraDetalleMpAgregar_change}"
                                     reRender="codMaterialFmMpAgregar"/>
                    </h:selectOneMenu>
                    <h:outputText value="Material" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:selectOneMenu id="codMaterialFmMpAgregar" style="width:400px" value="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleMpAgregar.materiales.codMaterial}" styleClass="inputText chosen">
                        <f:selectItem itemValue="0" itemLabel="--Seleccione una opción--"/>
                        <f:selectItems value="#{ManagedProgramaProduccionDesviacion.materialesDesviacionSelectList}"/>
                        <a4j:support event="onchange" action="#{ManagedProgramaProduccionDesviacion.codMaterialDesviacionFormulaMaestraDetalleMpAgregar_change}"
                                     reRender="contenedorDensidad,botonesAgregarMp"/>
                    </h:selectOneMenu>

                    <h:outputText value="Cantidad Unitaria(g)" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:inputText value="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleMpAgregar.cantidadUnitariaGramos}" styleClass="outputText2" id="cantidadUnitariAgregar" onkeypress="valNum(event)" onblur="valorPorDefecto(this)"/>
                    <h:outputText value="Densidad(g/ml)" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:panelGroup id="contenedorDensidad">
                        <h:inputText id="valorConversionDensidad" value="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleMpAgregar.densidadMaterial}" rendered="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleMpAgregar.unidadesMedida.tipoMedida.codTipoMedida!=2}" size="10" onblur="valorPorDefecto(this);" styleClass="inputText"  onkeypress="valNum(event);">
                            <f:convertNumber pattern="###0.0######" locale="en"/>
                        </h:inputText>
                        <h:outputText value="N.A." styleClass="outputText2" rendered="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleMpAgregar.unidadesMedida.tipoMedida.codTipoMedida eq 2}"/>
                    </h:panelGroup>
                    <h:outputText value="Cantidad Por Fracción(g)" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:panelGroup id="contenedorCantidad">
                        <h:selectBooleanCheckbox value="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleMpAgregar.aplicaCantidadMaximaPorFraccion}">
                            <a4j:support event="onclick" reRender="contenedorCantidad"/>
                        </h:selectBooleanCheckbox>
                        <h:inputText id="cantidadMaximaFraccion" value="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleMpAgregar.cantidadMaximaMaterialPorFraccion}" onkeyup="valNum(this)" onblur="valorPorDefecto(this)"
                                     rendered="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleMpAgregar.aplicaCantidadMaximaPorFraccion}"
                            size="10"/>
                    </h:panelGroup>
                </h:panelGrid>
                <br/>
                <h:panelGroup id="botonesAgregarMp">
                    <h:outputText value="El material no se puede registrar porque que no cuenta con conversión a gramos o mililitros" rendered="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleMpAgregar.equivalenciaAGramos eq 0 && ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleMpAgregar.equivalenciaAMiliLitros eq 0}"
                                  styleClass="textoAlerta"/>
                    <a4j:commandButton action="#{ManagedProgramaProduccionDesviacion.completarAdicionFormulaMaestraAgregarMp_action}" value="Guardar" reRender="panelMp" oncomplete="Richfaces.hideModalPanel('panelAgregarDesviacionFormulaMaestraDetalleMp');recalcularTablas();" styleClass="btn"
                                       onclick="if(!validarAgregarFormulaMaestraDetalleMp()){return false;}"
                                       rendered="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleMpAgregar.equivalenciaAGramos>0 || ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleMpAgregar.equivalenciaAMiliLitros>0}"/>
                    <a4j:commandButton value="Cancelar" oncomplete="javascript:Richfaces.hideModalPanel('panelAgregarDesviacionFormulaMaestraDetalleMp');" styleClass="btn"/>
                </h:panelGroup>
             </rich:panel>

        </h:panelGroup>

        </center>
    </a4j:form>
</rich:modalPanel>


