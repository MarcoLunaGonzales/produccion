
<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>
<f:view>

    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
            <script type="text/javascript" src="../../js/general.js" ></script>
            
        </head>
            <a4j:form id="form1" >
                <center>
                    <h:outputText value="Proveedores Compra Material" styleClass="outputTextTituloSistema"/>
                    <h:outputText value="#{ManagedProgramaProduccionSolicitudCompra.cargarMaterialesCompraProveedorList}"  />
                    <rich:panel headerClass="headerClassACliente" style="width:80%">
                        <f:facet name="header">
                            <h:outputText value="Busqueda"/>
                        </f:facet>
                        <h:panelGrid columns="3">
                            <h:outputText value="Capitulo" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectOneMenu value="#{ManagedProgramaProduccionSolicitudCompra.materialesCompraProveedorBuscar.materiales.grupo.capitulo.codCapitulo}" styleClass="inputText">
                                <f:selectItem itemValue='0' itemLabel="--TODOS--"/>
                                <f:selectItems value="#{ManagedProgramaProduccionSolicitudCompra.capitulosSelectList}"/>
                                <a4j:support event="onchange" action="#{ManagedProgramaProduccionSolicitudCompra.codCapituloMaterialComraProveedor_change}" reRender="codGrupo"/>
                            </h:selectOneMenu>
                            <h:outputText value="Grupo" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectOneMenu id="codGrupo" value="#{ManagedProgramaProduccionSolicitudCompra.materialesCompraProveedorBuscar.materiales.grupo.codGrupo}" styleClass="inputText">
                                <f:selectItem itemValue='0' itemLabel="--TODOS--"/>
                                <f:selectItems value="#{ManagedProgramaProduccionSolicitudCompra.gruposSelectList}"/>
                            </h:selectOneMenu>
                        </h:panelGrid>
                        <a4j:commandButton value="BUSCAR" action="#{ManagedProgramaProduccionSolicitudCompra.buscarMaterialesCompraProveedorList_action}" styleClass="btn" reRender="dataMaterialesCompraProveedor"/>
                    </rich:panel>
                    <rich:dataTable value="#{ManagedProgramaProduccionSolicitudCompra.materialesCompraProveedorList}"
                                    var="data" id="dataMaterialesCompraProveedor"
                                    style="margin-top:1em"
                                    headerClass="headerClassACliente" >
                        <f:facet name="header">
                            <rich:columnGroup>
                                <rich:column>
                                    <h:selectBooleanCheckbox value='false' onclick="seleccionarTodosCheckBox(this)"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Material"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Grupo"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Capitulo"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Proveedor"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Fecha Habilitación"/>
                                </rich:column>
                            </rich:columnGroup>
                        </f:facet>
                            <rich:column>
                                <h:selectBooleanCheckbox value="#{data.checked}" onclick="seleccionarRegistro(this)"/>
                            </rich:column>
                            <rich:column>
                                <h:outputText value="#{data.materiales.nombreMaterial}"/>
                            </rich:column>
                            <rich:column>
                                <h:outputText value="#{data.materiales.grupo.nombreGrupo}"/>
                            </rich:column>
                            <rich:column>
                                <h:outputText value="#{data.materiales.grupo.capitulo.nombreCapitulo}"/>
                            </rich:column>
                            <rich:column>
                                <h:outputText value="#{data.proveedores.nombreProveedor}"/>
                            </rich:column>
                            <rich:column>
                                <h:outputText value="#{data.fechaHabilitacion}">
                                    <f:convertDateTime pattern="dd/MM/yyyy HH:mm"/>
                                </h:outputText>
                            </rich:column>
                    </rich:dataTable>
                    <div id="bottonesAcccion" class="barraBotones">
                        <a4j:commandButton value="Asignar Proveedor" reRender="contenidoAsociarProveedor" oncomplete="Richfaces.showModalPanel('panelAsociarProveedor')" action="#{ManagedProgramaProduccionSolicitudCompra.agregarMaterialesCompraProveedorSelectList}" styleClass="btn"/>
                    </div>
                    </center>
            </a4j:form>
            <rich:modalPanel id="panelAsociarProveedor" minHeight="140"  minWidth="600"
                                     height="140" width="600"
                                     zindex="4"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="<center>Asociar Proveedor</center>" escape="false"/>
                        </f:facet>
                        <a4j:form id="formRegistrar">
                        <h:panelGroup id="contenidoAsociarProveedor">
                            <div align="center">
                            <h:panelGrid columns="3">
                                <h:outputText value="Proveedor" styleClass="outputText2" style="font-weight:bold" />
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold" />
                                <h:selectOneMenu value="#{ManagedProgramaProduccionSolicitudCompra.materialesCompraProveedorAgregar.proveedores.codProveedor}" styleClass="inputText"
                                                 style="width:40em">
                                    <f:selectItems value="#{ManagedProgramaProduccionSolicitudCompra.proveedoresSelectList}"/>
                                </h:selectOneMenu>
                                

                            </h:panelGrid>
                                
                                <a4j:commandButton styleClass="btn" action="#{ManagedProgramaProduccionSolicitudCompra.guardarCambioProveedorMaterialCompra_action}" value="Guardar"
                                                       oncomplete="if(#{ManagedProgramaProduccionSolicitudCompra.mensaje eq '1'}){alert('Se registro la asociación del proveedor');Richfaces.hideModalPanel('panelAsociarProveedor');}else{alert('#{ManagedProgramaProduccionSolicitudCompra.mensaje}')}"
                                                       reRender="dataMaterialesCompraProveedor"/>
                                    <input type="button" value="Cancelar" onclick="Richfaces.hideModalPanel('panelAsociarProveedor')" class="btn" />
                                </div>
                        </h:panelGroup>
                        </a4j:form>
            </rich:modalPanel>
            <a4j:status id="statusPeticion"
                        onstart="Richfaces.showModalPanel('ajaxLoadingModalBox',{width:100, top:100})"
                        onstop="Richfaces.hideModalPanel('ajaxLoadingModalBox')">
            </a4j:status>

            <rich:modalPanel id="ajaxLoadingModalBox" minHeight="100"
                             minWidth="200" height="80" width="400" zindex="100" onshow="window.focus();">

                <div align="center">
                    <h:graphicImage value="../../img/load2.gif" />
                </div>
            </rich:modalPanel>

        </body>
    </html>

</f:view>

