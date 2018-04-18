<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>

<rich:modalPanel id="panelEditarActividadFormulaMaestraBloque"
                minHeight="350"  minWidth="500" 
                height="350" width="500" zindex="200"
                headerClass="headerClassACliente"
                resizeable="false">
    <f:facet name="header">
        <h:outputText value="<center>Editar Bloque</center>" escape="false" />
    </f:facet>
    <a4j:form id="formEditarActividadFormulaMaestraBloque">
        <center>
        <h:panelGroup id="contenidoEditarActividadFormulaMaestraBloque">
                <h:panelGrid columns="3" id="panelRegistroActividad">
                    <h:outputText value="Descripción" styleClass="outputTextBold"/>
                    <h:outputText value=":" styleClass="outputTextBold"/>
                    <h:panelGroup>
                        <h:inputText size="35" required="true" validatorMessage="Debe registrar una descripción con mas de 4 caracteres" requiredMessage="Debe registrar la descripción" id="descripcionEditar" value="#{ManagedActividadesFormulaMaestra.actividadFormulaMaestraBloqueGestionar.descripcion}" styleClass="inputText">
                            <f:validateLength minimum="4"/>
                        </h:inputText>
                        <h:message for="descripcionEditar" styleClass="mensajeValidacion"/>
                    </h:panelGroup>
                    <h:outputText value="Horas Hombre Estandar" styleClass="outputTextBold" />
                    <h:outputText value=":" styleClass="outputTextBold" />
                    <h:panelGroup>
                        <h:inputText  id="horasHombreEditar" required="true" converterMessage="Debe ingresar un dato numerico" validatorMessage="Debe ingresar un valor mayor a 0" requiredMessage="Debe Registrar las horas hombre" value="#{ManagedActividadesFormulaMaestra.actividadFormulaMaestraBloqueGestionar.horasHombreEstandar}" styleClass="inputText">
                            <f:validateDoubleRange minimum="0.02" maximum="700"/>
                        </h:inputText>
                        <h:message for="horasHombreEditar" styleClass="mensajeValidacion"/>
                    </h:panelGroup>
                </h:panelGrid>
                <br/>
                
                <div style="overflow-y: auto;height:170px;width:90%">
                    <rich:dataTable headerClass="headerClassACliente" value="#{ManagedActividadesFormulaMaestra.actividadFormulaMaestraBloqueGestionar.actividadesFormulaMaestraList}"
                                    var="actividad" id="dataMaquinaria" style="width:100%">
                        <f:facet name="header">
                            <rich:columnGroup>
                                <rich:column colspan="3">
                                    <h:outputText value="Actividades Asociadas"/>
                                </rich:column>
                                <rich:column breakBefore="true">
                                    <h:outputText value=""/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Orden"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Actividad" escape="false"/>
                                </rich:column>
                            </rich:columnGroup>
                        </f:facet>
                        <rich:column>
                            <h:selectBooleanCheckbox value="#{actividad.checked}"/>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{actividad.ordenActividad}"/>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{actividad.actividadesProduccion.nombreActividad}"/>
                        </rich:column>
                    </rich:dataTable>
                </div>
                <br/>
                
            <a4j:commandLink  styleClass="btn" reRender="formEditarActividadFormulaMaestraBloque,dataActividadesFormulaMaestra"
                              action="#{ManagedActividadesFormulaMaestra.modificarActividadFormulaMaestraBloque_action}"
                              oncomplete="if('#{facesContext.maximumSeverity}'.length==0)mostrarMensajeTransaccionEvento(function(){Richfaces.hideModalPanel('panelEditarActividadFormulaMaestraBloque');})"
                              >
                 <h:outputText styleClass="icon-floppy-disk"/>
                    <h:outputText value="Guardar"/>
            </a4j:commandLink>
            <a4j:commandLink styleClass="btn" oncomplete="Richfaces.hideModalPanel('panelEditarActividadFormulaMaestraBloque')">
                <h:outputText styleClass="icon-cross"/>
                <h:outputText value="Cancelar"/>
            </a4j:commandLink>



        </h:panelGroup>
        
        </center>
    </a4j:form>
</rich:modalPanel>