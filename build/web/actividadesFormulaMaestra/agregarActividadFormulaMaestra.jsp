<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>

<rich:modalPanel id="panelAgregarActividadFormulaMaestra"
                minHeight="380"  minWidth="700" onshow="cargarChosen();"
                height="380" width="700" zindex="200"
                headerClass="headerClassACliente"
                resizeable="false">
    <f:facet name="header">
        <h:outputText value="<center>Agregar Actividad Formula Maestra</center>" escape="false" />
    </f:facet>
    <a4j:form id="formAgregarActividadFormulaMaestra">
        <center>
        <h:panelGroup id="contenidoAgregarActividadFormulaMaestra">
                <h:panelGrid columns="3" id="panelRegistroActividad">
                    <h:outputText value="Area Actividad" styleClass="outputTextBold"/>
                    <h:outputText value=":" styleClass="outputTextBold"/>
                    <h:selectOneMenu value="#{ManagedActividadesFormulaMaestra.actividadesFormulaMaestraGestionar.areasEmpresa.codAreaEmpresa}"
                                     styleClass="inputText">
                        <f:selectItems value="#{ManagedActividadesFormulaMaestra.areasEmpresaActividadSelectList}"/>
                        <a4j:support event="onchange" oncomplete="cargarChosen()" action="#{ManagedActividadesFormulaMaestra.actividadFormulaMaestraGestionar_change()}"
                                     reRender="panelRegistroActividad">
                            <f:setPropertyActionListener target="#{ManagedActividadesFormulaMaestra.actividadesFormulaMaestraGestionar.tiposProgramaProduccion.codTipoProgramaProd}" value="0"/>
                            <f:setPropertyActionListener target="#{ManagedActividadesFormulaMaestra.actividadesFormulaMaestraGestionar.presentacionesProducto.codPresentacion}" value="0"/>
                        </a4j:support>
                    </h:selectOneMenu>
                    <h:outputText value="Tipo Programa Producción" styleClass="outputTextBold" rendered="#{ManagedActividadesFormulaMaestra.actividadesFormulaMaestraGestionar.areasEmpresa.codAreaEmpresa eq '96'}"/>
                    <h:outputText value=":" styleClass="outputTextBold" rendered="#{ManagedActividadesFormulaMaestra.actividadesFormulaMaestraGestionar.areasEmpresa.codAreaEmpresa eq '96'}"/>
                    <h:selectOneMenu value="#{ManagedActividadesFormulaMaestra.actividadesFormulaMaestraGestionar.tiposProgramaProduccion.codTipoProgramaProd}"
                                     styleClass="inputText"
                                     rendered="#{ManagedActividadesFormulaMaestra.actividadesFormulaMaestraGestionar.areasEmpresa.codAreaEmpresa eq '96'}">
                        <f:selectItem itemValue="0" itemLabel="--Genérico--"/>
                        <f:selectItems value="#{ManagedActividadesFormulaMaestra.tiposProgramaProduccionSelectList}"/>
                        <a4j:support event="onchange" oncomplete="cargarChosen()" action="#{ManagedActividadesFormulaMaestra.actividadFormulaMaestraGestionar_change()}"
                                     reRender="panelRegistroActividad"/>
                    </h:selectOneMenu>
                    <h:outputText value="Presentación" styleClass="outputTextBold" rendered="#{ManagedActividadesFormulaMaestra.actividadesFormulaMaestraGestionar.areasEmpresa.codAreaEmpresa eq '84'}"/>
                    <h:outputText value=":" styleClass="outputTextBold" rendered="#{ManagedActividadesFormulaMaestra.actividadesFormulaMaestraGestionar.areasEmpresa.codAreaEmpresa eq '84'}"/>
                    <h:selectOneMenu value="#{ManagedActividadesFormulaMaestra.actividadesFormulaMaestraGestionar.presentacionesProducto.codPresentacion}"
                                     styleClass="inputText"
                                     rendered="#{ManagedActividadesFormulaMaestra.actividadesFormulaMaestraGestionar.areasEmpresa.codAreaEmpresa eq '84'}">
                        <f:selectItems value="#{ManagedActividadesFormulaMaestra.presentacionesProductoSelectList}"/>
                        <a4j:support event="onchange" oncomplete="cargarChosen()" action="#{ManagedActividadesFormulaMaestra.actividadFormulaMaestraGestionar_change()}"
                                     reRender="panelRegistroActividad"/>
                    </h:selectOneMenu>
                    <h:outputText value="Actividad" styleClass="outputTextBold"/>
                    <h:outputText value=":" styleClass="outputTextBold"/>
                    <h:selectOneMenu value="#{ManagedActividadesFormulaMaestra.actividadesFormulaMaestraGestionar.actividadesProduccion.codActividad}"
                                     styleClass="inputText chosen">
                        <f:selectItems value="#{ManagedActividadesFormulaMaestra.actividadesProduccionGestionarSelectList}"/>
                    </h:selectOneMenu>
                    
                    
                </h:panelGrid>
                <br/>
                <a4j:commandLink styleClass="btn" reRender="dataMaquinaria" oncomplete="cargarChosen()"
                                 action="#{ManagedActividadesFormulaMaestra.agregarActividadFormulaMaestraGestionarHorasEstandar_action}">
                    <h:outputText value="" styleClass="icon-plus"/>
                    <h:outputText value="Agregar Maquinaria"/>
                    
                </a4j:commandLink>
                <div style="overflow-y: auto;height:170px;width:90%">
                    <rich:dataTable headerClass="headerClassACliente" value="#{ManagedActividadesFormulaMaestra.actividadesFormulaMaestraGestionar.actividadesFormulaMaestraHorasEstandarMaquinariaList}"
                                    var="maquinaria" id="dataMaquinaria" style="width:100%">
                        <f:facet name="header">
                            <rich:columnGroup>
                                <rich:column>
                                    <h:outputText value="Maquinaria"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Horas Maquina<br/>Estandar" escape="false"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Acciones"/>
                                </rich:column>
                            </rich:columnGroup>
                        </f:facet>
                        <rich:column>
                            <h:selectOneMenu value="#{maquinaria.maquinaria.codMaquina}" styleClass="inputText chosen" style="width:300px">
                                <f:selectItems value="#{ManagedActividadesFormulaMaestra.maquinariasSelectList}"/>
                            </h:selectOneMenu>
                        </rich:column>
                        <rich:column>
                            <h:inputText value="#{maquinaria.horasMaquinaEstandar}" styleClass="inputText" size="7">
                                <f:convertNumber pattern="###0.0" locale="en"/>
                            </h:inputText>
                        </rich:column>
                        <rich:column>
                            <a4j:commandLink styleClass="btn" action="#{ManagedActividadesFormulaMaestra.eliminarActividadFormulaMaestraGestionarHorasEstandar_action(maquinaria)}"
                                                reRender="dataMaquinaria">
                                 <h:outputText styleClass="icon-bin"/>
                                 <h:outputText value="Eliminar"/>
                             </a4j:commandLink>
                        </rich:column>
                    </rich:dataTable>
                </div>
                <br/>
            <a4j:commandLink styleClass="btn" reRender="dataActividadesFormulaMaestra"
                               action="#{ManagedActividadesFormulaMaestra.guardarActividadFormulaMaestra_action}"
                               oncomplete="mostrarMensajeTransaccionEvento(function(){Richfaces.hideModalPanel('panelAgregarActividadFormulaMaestra');})">
                 <h:outputText styleClass="icon-floppy-disk"/>
                    <h:outputText value="Guardar"/>
            </a4j:commandLink>
            <a4j:commandLink styleClass="btn" oncomplete="Richfaces.hideModalPanel('panelAgregarActividadFormulaMaestra')">
                <h:outputText styleClass="icon-cross"/>
                <h:outputText value="Cancelar"/>
            </a4j:commandLink>



        </h:panelGroup>
        
        </center>
    </a4j:form>
</rich:modalPanel>