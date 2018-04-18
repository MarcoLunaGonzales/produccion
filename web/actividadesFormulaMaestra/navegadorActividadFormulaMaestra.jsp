<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>


<f:view>

<html>
<head>
    <title>SISTEMA</title>
    <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
    <link rel="STYLESHEET" type="text/css" href="../css/icons.css" />
    <link rel="STYLESHEET" type="text/css" href="../css/chosen.css" /> 
    <script type="text/javascript" src='../js/general.js' ></script>
</head>
<body>
<a4j:form id="form1"  >     
    <h:outputText value="#{ManagedActividadesFormulaMaestra.cargarActividadFormulaMaestra}"/>
    <div align="center">      
        <rich:panel headerClass="headerClassACliente" style="width:80%">
            <f:facet name="header">
                <h:outputText value="Datos de la formula maestra"/>
            </f:facet>
            <h:panelGrid columns="6">
                <h:outputText value="Producto" styleClass="outputTextBold"/>
                <h:outputText value="::" styleClass="outputTextBold"/>
                <h:outputText value="#{ManagedActividadesFormulaMaestra.formulaMaestraBean.componentesProd.nombreProdSemiterminado}" styleClass="outputText2"/>
                <h:outputText value="Estado" styleClass="outputTextBold"/>
                <h:outputText value="::" styleClass="outputTextBold"/>
                <h:outputText value="#{ManagedActividadesFormulaMaestra.formulaMaestraBean.componentesProd.estadoCompProd.nombreEstadoCompProd}" styleClass="outputText2"/>
                <h:outputText value="Tipo Producción" styleClass="outputTextBold"/>
                <h:outputText value="::" styleClass="outputTextBold"/>
                <h:outputText value="#{ManagedActividadesFormulaMaestra.formulaMaestraBean.componentesProd.tipoProduccion.nombreTipoProduccion}" styleClass="outputText2"/>
                <h:outputText value="Area Producción" styleClass="outputTextBold"/>
                <h:outputText value="::" styleClass="outputTextBold"/>
                <h:outputText value="#{ManagedActividadesFormulaMaestra.formulaMaestraBean.componentesProd.areasEmpresa.nombreAreaEmpresa}" styleClass="outputText2"/>
            </h:panelGrid>

        </rich:panel>
        <br/>
        <rich:panel headerClass="headerClassACliente" style="width:80%">
            <f:facet name="header">
                <h:outputText value="BUSCADOR"/>
            </f:facet>
            <h:panelGrid columns="6" id="panelDatosFiltro">
                <h:outputText value="Nombre Actividad" styleClass="outputTextBold"/>
                <h:outputText value="::" styleClass="outputTextBold"/>
                <h:inputText style="width:25em" value="#{ManagedActividadesFormulaMaestra.actividadesFormulaMaestraBuscar.actividadesProduccion.nombreActividad}" styleClass="inputText"/>
                <h:outputText value="Estado" styleClass="outputTextBold"/>
                <h:outputText value="::" styleClass="outputTextBold"/>
                <h:selectOneMenu value="#{ManagedActividadesFormulaMaestra.actividadesFormulaMaestraBuscar.estadoReferencial.codEstadoRegistro}" styleClass="inputText">
                    <f:selectItem itemLabel="Activo" itemValue="1"/>
                    <f:selectItem itemLabel="No Activo" itemValue="2"/>
                </h:selectOneMenu>
                <h:outputText value="Area Actividad" styleClass="outputTextBold"/>
                <h:outputText value="::" styleClass="outputTextBold"/>
                <h:selectOneMenu id="codAreaEmpresaActividad" value="#{ManagedActividadesFormulaMaestra.actividadesFormulaMaestraBuscar.areasEmpresa.codAreaEmpresa}" styleClass="inputText">
                    <f:selectItems value="#{ManagedActividadesFormulaMaestra.areasEmpresaActividadSelectList}"/>
                    <a4j:support event="onchange" reRender="panelDatosFiltro" action="#{ManagedActividadesFormulaMaestra.codAreaEmpresaActividadFormulaBuscar_change}"/>
                </h:selectOneMenu>
                
                <h:outputText value="Tipo Programa Producción" styleClass="outputTextBold" rendered="#{ManagedActividadesFormulaMaestra.actividadesFormulaMaestraBuscar.areasEmpresa.codAreaEmpresa eq '96'}"/>
                <h:outputText value="::" styleClass="outputTextBold" rendered="#{ManagedActividadesFormulaMaestra.actividadesFormulaMaestraBuscar.areasEmpresa.codAreaEmpresa eq '96'}"/>
                <h:selectOneMenu id="codTipoProgramaProduccion" value="#{ManagedActividadesFormulaMaestra.actividadesFormulaMaestraBuscar.tiposProgramaProduccion.codTipoProgramaProd}" styleClass="inputText" rendered="#{ManagedActividadesFormulaMaestra.actividadesFormulaMaestraBuscar.areasEmpresa.codAreaEmpresa eq '96'}">
                    <f:selectItem itemLabel="--Genérico--" itemValue="0"/>
                    <f:selectItems value="#{ManagedActividadesFormulaMaestra.tiposProgramaProduccionSelectList}"/>
                </h:selectOneMenu>
                <h:outputText value="Presentación" styleClass="outputTextBold" rendered="#{ManagedActividadesFormulaMaestra.actividadesFormulaMaestraBuscar.areasEmpresa.codAreaEmpresa eq '84'}"/>
                <h:outputText value="::" styleClass="outputTextBold" rendered="#{ManagedActividadesFormulaMaestra.actividadesFormulaMaestraBuscar.areasEmpresa.codAreaEmpresa eq '84'}"/>
                <h:selectOneMenu id="codPresentacionActividad" value="#{ManagedActividadesFormulaMaestra.actividadesFormulaMaestraBuscar.presentacionesProducto.codPresentacion}" styleClass="inputText" rendered="#{ManagedActividadesFormulaMaestra.actividadesFormulaMaestraBuscar.areasEmpresa.codAreaEmpresa eq '84'}">
                    <f:selectItems value="#{ManagedActividadesFormulaMaestra.presentacionesProductoSelectList}"/>
                </h:selectOneMenu>
            </h:panelGrid>
            <a4j:commandLink action="#{ManagedActividadesFormulaMaestra.buscarActividadesFormulaMaestra_action}" styleClass="btn"
                               reRender="dataActividadesFormulaMaestra">
                <h:outputText styleClass="icon-search"/>
                <h:outputText value="BUSCAR" />
            </a4j:commandLink>
        </rich:panel>
        <rich:dataTable value="#{ManagedActividadesFormulaMaestra.actividadFormulaMaestraBloqueList}"
                        var="bloqueActividad" id="dataActividadesFormulaMaestra"
                        onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                        onRowMouseOver="this.style.backgroundColor='#CCDFFA';" 
                        headerClass="headerClassACliente"
                        style="margin-top:1em"
                        columnClasses="tituloCampo">
            <f:facet name="header">
                <rich:columnGroup>
                    <rich:column rowspan="2">
                        <h:outputText value="Bloque<br/>Actividad" escape="false"/>
                    </rich:column>
                    <rich:column rowspan="2">
                        <h:outputText value="Horas<br/>Hombre<br/>Estandar" escape="false"/>
                    </rich:column>
                    <rich:column rowspan="2">
                        <h:outputText value="Acciones<br/>Bloque" escape="false"/>
                    </rich:column>
                    <rich:column rowspan="2">
                        <h:outputText value=""/>
                    </rich:column>
                    <rich:column rowspan="2">
                        <h:outputText value="Orden"/>
                    </rich:column>
                    <rich:column rowspan="2">
                        <h:outputText value="Actividad Producción"/>
                    </rich:column>
                    <rich:column rowspan="2">
                        <h:outputText value="Area Actividad"/>
                    </rich:column>
                    <rich:column rowspan="2">
                        <h:outputText value="Presentacion"/>
                    </rich:column>
                    <rich:column rowspan="2">
                        <h:outputText value="Tipo<br/>Programa Producción" escape="false"/>
                    </rich:column>
                    <rich:column rowspan="2">
                        <h:outputText value="Estado"/>
                    </rich:column>
                    <rich:column rowspan="2">
                        <h:outputText value="Proceso<br/>Orden<br/>Manufactura" escape="false"/>
                    </rich:column>
                    <rich:column colspan="3">
                        <h:outputText value="Maquinarias"/>
                    </rich:column>
                    <rich:column rowspan="2">
                        <h:outputText value="Acciones<br/>actividad" escape="false"/>
                    </rich:column>
                    <rich:column breakBefore="true">
                        <h:outputText value="Maquinaria"/>
                    </rich:column>
                    <rich:column>
                        <h:outputText value="Codigo"/>
                    </rich:column>
                    <rich:column>
                        <h:outputText value="Horas Maquina<br/>Estandar" escape="false"/>
                    </rich:column>
                </rich:columnGroup>
            </f:facet>
            <rich:subTable value="#{bloqueActividad.actividadesFormulaMaestraList}"
                           var="actividad" rowKeyVar="index">
                <rich:subTable value="#{actividad.actividadesFormulaMaestraHorasEstandarMaquinariaList}"
                               var="detalle" rowKeyVar="indexDetalle">
                    <rich:column rendered="#{index eq 0 && indexDetalle eq 0}" rowspan="#{bloqueActividad.actividadesFormulaMaestraListTotalSize}">
                        <h:outputText value="#{bloqueActividad.descripcion}"/>
                    </rich:column>
                    <rich:column rendered="#{index eq 0 && indexDetalle eq 0}" rowspan="#{bloqueActividad.actividadesFormulaMaestraListTotalSize}">
                        <h:outputText value="#{bloqueActividad.horasHombreEstandar}"/>
                    </rich:column>
                    <rich:column rendered="#{index eq 0 && indexDetalle eq 0}" rowspan="#{bloqueActividad.actividadesFormulaMaestraListTotalSize}">
                        <rich:dropDownMenu rendered="#{bloqueActividad.codActividadFormulaMaestraBloque>0}">
                            <f:facet name="label">
                                <h:panelGroup>
                                    <h:outputText value="Acciones"/>
                                    <h:outputText styleClass="icon-menu3"/>
                                </h:panelGroup>
                            </f:facet>
                            <rich:menuItem  submitMode="none" iconClass="icon-pencil" value="Editar">
                                <a4j:support event="onclick" reRender="contenidoEditarActividadFormulaMaestraBloque"
                                             action="#{ManagedActividadesFormulaMaestra.seleccionarEditarActividadFormulaMaestraBloque_action}"
                                             oncomplete="Richfaces.showModalPanel('panelEditarActividadFormulaMaestraBloque')">
                                    <f:setPropertyActionListener value="#{bloqueActividad}" target="#{ManagedActividadesFormulaMaestra.actividadFormulaMaestraBloqueGestionar}"/>
                                </a4j:support>
                            </rich:menuItem>
                            <rich:menuItem  submitMode="none" iconClass="icon-bin" value="Eliminar">
                                <a4j:support event="onclick" reRender="dataActividadesFormulaMaestra"
                                             action="#{ManagedActividadesFormulaMaestra.eliminarActividadFormulaMaestraBloque_action(bloqueActividad.codActividadFormulaMaestraBloque)}"
                                             oncomplete="mostrarMensajeTransaccion()">
                                </a4j:support>
                            </rich:menuItem>
                        </rich:dropDownMenu>
                    </rich:column>
                    <rich:column rowspan="#{actividad.actividadesFormulaMaestraHorasEstandarMaquinariaListSize}" rendered="#{indexDetalle eq 0}">
                        <h:selectBooleanCheckbox value="#{actividad.checked}"  />
                    </rich:column>
                    <rich:column rowspan="#{actividad.actividadesFormulaMaestraHorasEstandarMaquinariaListSize}" rendered="#{indexDetalle eq 0}">
                        <h:outputText value="#{actividad.ordenActividad}"  />
                    </rich:column>
                    <rich:column rowspan="#{actividad.actividadesFormulaMaestraHorasEstandarMaquinariaListSize}" rendered="#{indexDetalle eq 0}">
                        <h:outputText value="#{actividad.actividadesProduccion.nombreActividad}"  />
                    </rich:column>
                    <rich:column rowspan="#{actividad.actividadesFormulaMaestraHorasEstandarMaquinariaListSize}" rendered="#{indexDetalle eq 0}">
                        <h:outputText value="#{actividad.areasEmpresa.nombreAreaEmpresa}"  />
                    </rich:column>
                    <rich:column rowspan="#{actividad.actividadesFormulaMaestraHorasEstandarMaquinariaListSize}" rendered="#{indexDetalle eq 0}">
                        <h:outputText value="#{actividad.presentacionesProducto.nombreProductoPresentacion}"  />
                    </rich:column>
                    <rich:column rowspan="#{actividad.actividadesFormulaMaestraHorasEstandarMaquinariaListSize}" rendered="#{indexDetalle eq 0}">
                        <h:outputText value="#{actividad.tiposProgramaProduccion.nombreTipoProgramaProd}"  />
                    </rich:column>
                    <rich:column rowspan="#{actividad.actividadesFormulaMaestraHorasEstandarMaquinariaListSize}" rendered="#{indexDetalle eq 0}">
                        <h:outputText value="#{actividad.estadoReferencial.nombreEstadoRegistro}"  />
                    </rich:column>
                    <rich:column rowspan="#{actividad.actividadesFormulaMaestraHorasEstandarMaquinariaListSize}" rendered="#{indexDetalle eq 0}">
                        <h:outputText value="#{actividad.actividadesProduccion.procesosOrdenManufactura.nombreProcesoOrdenManufactura}"  />
                    </rich:column>
                    <rich:column>
                        <h:outputText value="#{detalle.maquinaria.nombreMaquina}"  />
                    </rich:column>
                    <rich:column>
                        <h:outputText value="#{detalle.maquinaria.codigo}"/>
                    </rich:column>
                    <rich:column>
                        <h:outputText value="#{detalle.horasMaquinaEstandar}"/>
                    </rich:column>
                    <rich:column rowspan="#{actividad.actividadesFormulaMaestraHorasEstandarMaquinariaListSize}" rendered="#{indexDetalle eq 0}">
                        <rich:dropDownMenu >
                            <f:facet name="label">
                                <h:panelGroup>
                                    <h:outputText value="Acciones"/>
                                    <h:outputText styleClass="icon-menu3"/>
                                </h:panelGroup>
                            </f:facet>
                            <rich:menuItem  submitMode="none" iconClass="icon-pencil" value="Editar Actividad">
                                <a4j:support event="onclick" reRender="contenidoEditarActividadFormulaMaestra"
                                             action="#{ManagedActividadesFormulaMaestra.seleccionarEditarActividadFormulaMaestra_action}"
                                             oncomplete="Richfaces.showModalPanel('panelEditarActividadFormulaMaestra')">
                                    <f:setPropertyActionListener value="#{actividad}" target="#{ManagedActividadesFormulaMaestra.actividadesFormulaMaestraGestionar}"/>
                                </a4j:support>
                            </rich:menuItem>
                            <rich:menuItem  submitMode="none" iconClass="icon-bin" value="Eliminar Actividad">
                                <a4j:support event="onclick" reRender="dataActividadesFormulaMaestra"
                                             action="#{ManagedActividadesFormulaMaestra.eliminarActividadFormulaMaestra_action(data.codActividadFormula)}"
                                             oncomplete="mostrarMensajeTransaccion()">
                                </a4j:support>
                            </rich:menuItem>

                        </rich:dropDownMenu>
                    </rich:column>
                </rich:subTable>
            </rich:subTable>
        </rich:dataTable>

        <br>
        <a4j:commandLink oncomplete="Richfaces.showModalPanel('panelAgregarActividadFormulaMaestra')"
                           action="#{ManagedActividadesFormulaMaestra.agregarActividadFormulaMaestra_action}"
                           reRender="contenidoAgregarActividadFormulaMaestra" styleClass="btn">
            <h:outputText styleClass="icon-plus"/>
            <h:outputText value="Agregar"/>
        </a4j:commandLink>
        <a4j:commandLink action="#{ManagedActividadesFormulaMaestra.inactivarActividadesFormulaMaestra_action}"
                           reRender="dataActividadesFormulaMaestra" styleClass="btn"
                           oncomplete="mostrarMensajeTransaccion()">
            <h:outputText styleClass="icon-minus"/>
            <h:outputText value="Inactivar actividades seleccionadas"/>
        </a4j:commandLink>
        <a4j:commandLink oncomplete="Richfaces.showModalPanel('panelAgregarActividadFormulaMaestraBloque')"
                         action="#{ManagedActividadesFormulaMaestra.agregarActividadFormulaMaestraBloque_action}"
                           reRender="contenidoAgregarActividadFormulaMaestraBloque" styleClass="btn">
            <h:outputText styleClass="icon-plus"/>
            <h:outputText value="Agrupar actividades"/>
        </a4j:commandLink>
        <a4j:commandLink oncomplete="redireccionar('navegadorFormulaMaestraActividad.jsf');" styleClass="btn">
            <h:outputText styleClass="icon-undo2"/>
            <h:outputText value="Volver"/>
        </a4j:commandLink>
        
        
    </div>
</a4j:form>
    <a4j:include id="agregarActividadFormula" viewId="agregarActividadFormulaMaestra.jsp"/>
    <a4j:include id="agregarActividadFormulaMaestraBloque" viewId="agregarActividadFormulaMaestraBloque.jsp"/>
    <a4j:include id="editarActividadFormulaMaestraBloque" viewId="editarActividadFormulaMaestraBloque.jsp"/>
    <a4j:include id="editarActividadFormula" viewId="editarActividadFormulaMaestra.jsp"/>
    <a4j:include viewId="../message.jsp" />
    <a4j:loadScript src="../js/chosen.js" />
    <a4j:status id="statusPeticion"
                onstart="Richfaces.showModalPanel('ajaxLoadingModalBox',{width:100, top:100})"
                onstop="Richfaces.hideModalPanel('ajaxLoadingModalBox');">
     </a4j:status>

    <rich:modalPanel id="ajaxLoadingModalBox" minHeight="100"
                     minWidth="200" height="80" width="400" zindex="500" onshow="window.focus();">

        <div align="center">
            <h:graphicImage value="../img/load2.gif" />
        </div>
    </rich:modalPanel>
</body>
</html>

</f:view>

