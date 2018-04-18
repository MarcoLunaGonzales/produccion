<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>

<rich:modalPanel id="panelAgregarActividadFormulaMaestraGeneral"
                minHeight="380"  minWidth="700" onshow="cargarChosen();"
                height="380" width="700" zindex="200"
                headerClass="headerClassACliente"
                resizeable="false">
    <f:facet name="header">
        <h:outputText value="<center>Agregar Actividad General</center>" escape="false" />
    </f:facet>
    <a4j:form id="formAgregarActividadFormulaMaestraGeneral">
        <center>
            <h:panelGroup id="contenidoAgregarActividadFormulaMaestraGeneral" >
                <h:panelGrid columns="1" id="panelRegistroActividad">
                    <rich:panel headerClass="headerClassACliente">
                        <f:facet name="header">
                            <h:outputText value="<center>Datos de los productos afectados</center>" escape="false"/>
                        </f:facet>
                        <h:panelGrid columns="3">
                            <h:outputText value="Forma Farmaceútica" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectOneMenu value="#{ManagedActividadesFormulaMaestra.actividadesFMAdicionarGeneral.formulaMaestra.componentesProd.forma.codForma}"
                            styleClass="inputText chosen">
                                <f:selectItem itemValue="0" itemLabel="--TODOS--"/>
                                <f:selectItems value="#{ManagedActividadesFormulaMaestra.formasFarmaceuticasSelectList}"/>
                            </h:selectOneMenu>
                        </h:panelGrid>
                    </rich:panel>
                    <rich:panel headerClass="headerClassACliente">
                        <f:facet name="header">
                            <h:outputText value="<center>Datos de la actividad</center>" escape="false"/>
                        </f:facet>
                        <h:panelGrid columns="3">
                            <h:outputText value="Area Actividad" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectOneMenu value="#{ManagedActividadesFormulaMaestra.codAreaEmpresa}" styleClass="inputText chosen">
                                <f:selectItems value="#{ManagedActividadesFormulaMaestra.areasEmpresaActividadSelectList}"/>
                                <a4j:support event="onchange" immediate="true" oncomplete="cargarChosen()" reRender="contenidoAgregarActividadFormulaMaestraGeneral">
                                    <a4j:actionparam name="type2" value="this.value" 
                                        assignTo="#{ManagedActividadesFormulaMaestra.codAreaEmpresa}" 
                                        noEscape="true"/>
                                </a4j:support>
                            </h:selectOneMenu>
                            <h:outputText value="Tipo Programa Producción" styleClass="outputTextBold" rendered="#{ManagedActividadesFormulaMaestra.codAreaEmpresa eq '96'}"/>
                            <h:outputText value=":" styleClass="outputTextBold" rendered="#{ManagedActividadesFormulaMaestra.codAreaEmpresa eq '96'}"/>
                            <h:selectOneMenu value="#{ManagedActividadesFormulaMaestra.actividadesFMAdicionarGeneral.tiposProgramaProduccion.codTipoProgramaProd}"
                                             styleClass="inputText"
                                             rendered="#{ManagedActividadesFormulaMaestra.codAreaEmpresa eq '96'}">
                                <f:selectItem itemValue="0" itemLabel="--Genérico--"/>
                                <f:selectItems value="#{ManagedActividadesFormulaMaestra.tiposProgramaProduccionSelectList}" />
                            </h:selectOneMenu>
                            
                            <h:outputText value="Actividad Producción" styleClass="outputTextBold" />
                            <h:outputText value=":" styleClass="outputTextBold" />
                            <h:panelGroup>
                                <h:selectOneMenu  id="codActividadProduccion" required="true" 
                                                 validatorMessage="Debe Seleccionar una opción"
                                                 converterMessage="Valor no valido"
                                                 requiredMessage="Debe Seleccionar una opción" value="#{ManagedActividadesFormulaMaestra.actividadesFMAdicionarGeneral.actividadesProduccion.codActividad}"
                                                 styleClass="inputText chosen">
                                    <f:selectItem itemValue='0' itemDisabled="true" itemLabel="--Seleccione una opción--"/>
                                    <f:selectItems value="#{ManagedActividadesFormulaMaestra.actividadesProduccionSelectList}"/>
                                    <f:validateLongRange minimum="1" />
                                </h:selectOneMenu>
                                <h:message for="codActividadProduccion" styleClass="mensajeValidacion"/>
                            </h:panelGroup>
                        </h:panelGrid>
                    </rich:panel>
                
                
                
                     
            </h:panelGrid>
                <br/>
                <a4j:commandLink id="buttonGuardar" styleClass="btn" reRender="contenidoAgregarActividadFormulaMaestraGeneral"
                                action="#{ManagedActividadesFormulaMaestra.guardarActividadFormulaMaestraGeneral_action}"
                                oncomplete="if('#{facesContext.maximumSeverity}'.length==0){mostrarMensajeTransaccionEvento(function(){Richfaces.hideModalPanel('panelAgregarActividadFormulaMaestraGeneral');})}else{cargarChosen();}"
                                >
                         <h:outputText styleClass="icon-floppy-disk"/>
                         <h:outputText value="Guardar"/>
                 </a4j:commandLink>
            <a4j:commandLink  id="buttonCancelar" styleClass="btn"
                               oncomplete="Richfaces.hideModalPanel('panelAgregarActividadFormulaMaestraGeneral')">
                <h:outputText styleClass="icon-cross"/>
                <h:outputText value="Cancelar"/>
            </a4j:commandLink>



        </h:panelGroup>
        
        </center>
    </a4j:form>
    
</rich:modalPanel>
