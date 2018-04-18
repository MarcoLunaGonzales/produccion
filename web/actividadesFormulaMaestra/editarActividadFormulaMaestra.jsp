<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>

<rich:modalPanel id="panelEditarActividadFormulaMaestra"
                minHeight="380"  minWidth="700"
                height="380" width="700" zindex="200"
                headerClass="headerClassACliente"
                resizeable="false">
    <f:facet name="header">
        <h:outputText value="<center>Editar Actividad Formula Maestra</center>" escape="false" />
    </f:facet>
    <a4j:form id="formEditarActividadFormulaMaestra">
        <center>
        <h:panelGroup id="contenidoEditarActividadFormulaMaestra">
                <h:panelGrid columns="3" id="panelRegistroActividad">
                    <h:outputText value="Area Actividad" styleClass="outputTextBold"/>
                    <h:outputText value=":" styleClass="outputTextBold"/>
                    <h:outputText value="#{ManagedActividadesFormulaMaestra.actividadesFormulaMaestraGestionar.areasEmpresa.nombreAreaEmpresa}" styleClass="outputText2"/>
                    
                    <h:outputText value="Tipo Programa Producción" styleClass="outputTextBold" rendered="#{ManagedActividadesFormulaMaestra.actividadesFormulaMaestraGestionar.areasEmpresa.codAreaEmpresa eq '96'}"/>
                    <h:outputText value=":" styleClass="outputTextBold" rendered="#{ManagedActividadesFormulaMaestra.actividadesFormulaMaestraGestionar.areasEmpresa.codAreaEmpresa eq '96'}"/>
                    <h:outputText value="#{ManagedActividadesFormulaMaestra.actividadesFormulaMaestraGestionar.tiposProgramaProduccion.nombreTipoProgramaProd}" styleClass="outputText2" rendered="#{ManagedActividadesFormulaMaestra.actividadesFormulaMaestraGestionar.areasEmpresa.codAreaEmpresa eq '96'}"/>
                    
                    <h:outputText value="Presentación" styleClass="outputTextBold" rendered="#{ManagedActividadesFormulaMaestra.actividadesFormulaMaestraGestionar.areasEmpresa.codAreaEmpresa eq '84'}"/>
                    <h:outputText value=":" styleClass="outputTextBold" rendered="#{ManagedActividadesFormulaMaestra.actividadesFormulaMaestraGestionar.areasEmpresa.codAreaEmpresa eq '84'}"/>
                    <h:outputText value="#{ManagedActividadesFormulaMaestra.actividadesFormulaMaestraGestionar.presentacionesProducto.nombreProductoPresentacion}" styleClass="outputText2" rendered="#{ManagedActividadesFormulaMaestra.actividadesFormulaMaestraGestionar.areasEmpresa.codAreaEmpresa eq '84'}"/>
                    
                    <h:outputText value="Actividad" styleClass="outputTextBold"/>
                    <h:outputText value=":" styleClass="outputTextBold"/>
                    <h:outputText value="#{ManagedActividadesFormulaMaestra.actividadesFormulaMaestraGestionar.actividadesProduccion.nombreActividad}" styleClass="outputText2"/>
                    
                    <h:outputText value="Estado" styleClass="outputTextBold"/>
                    <h:outputText value=":" styleClass="outputTextBold"/>
                    <h:selectOneMenu value="#{ManagedActividadesFormulaMaestra.actividadesFormulaMaestraGestionar.estadoReferencial.codEstadoRegistro}" styleClass="inputText">
                        <f:selectItem itemValue="1" itemLabel="Activo"/>
                        <f:selectItem itemValue="2" itemLabel="No Activo"/>
                    </h:selectOneMenu>
                </h:panelGrid>
                <br/>
                <a4j:commandLink styleClass="btn" reRender="dataMaquinaria"
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
                            <h:selectOneMenu value="#{maquinaria.maquinaria.codMaquina}" styleClass="inputText" style="width:300px">
                                <f:selectItems value="#{ManagedActividadesFormulaMaestra.maquinariasSelectList}"/>
                            </h:selectOneMenu>
                        </rich:column>
                        <rich:column>
                            <h:inputText value="#{maquinaria.horasMaquinaEstandar}" styleClass="inputText" size="7">
                                <f:convertNumber pattern="###0.00" locale="en"/>
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
            <a4j:commandButton value="Guardar" styleClass="btn" reRender="dataActividadesFormulaMaestra"
                               action="#{ManagedActividadesFormulaMaestra.modificarActividadFormulaMaestra_action}"
                               oncomplete="mostrarMensajeTransaccionEvento(function(){Richfaces.hideModalPanel('panelEditarActividadFormulaMaestra');})"/>
            <a4j:commandButton value="Cancelar" styleClass="btn"
                               oncomplete="Richfaces.hideModalPanel('panelEditarActividadFormulaMaestra')"/>



        </h:panelGroup>
        
        </center>
    </a4j:form>
</rich:modalPanel>