<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>
<f:view>
    
    <html>
        <head>
            <title>Protocolos Mantenimiento</title>
            <link rel="STYLESHEET" type="text/css" href="../../../css/ventas.css" />
            <script type="text/javascript" src="../../../js/general.js" ></script>
            <script type="text/javascript">
                function validarEditarMaterial()
                {
                    return (validarMayorACero(document.getElementById("formEditarTarea:nroPasoAgregar"))&&validarRegistroNoVacio(document.getElementById("formEditarTarea:descripcionTarea")));
                }
                function validarAgregarTarea()
                {
                    return (validarMayorACero(document.getElementById("formAgregarTarea:nroPasoAgregar"))&&validarRegistroNoVacio(document.getElementById("formAgregarTarea:descripcionTarea")));
                }
            </script>
        </head>
        <body >
        <a4j:form id="form1">
            <div align="center">
                <h:outputText value="Protocolo Mantenimiento Detalle Tareas" styleClass="outputTextTituloSistema"/>
                <h:outputText value="#{ManagedProtocoloMantenimiento.cargarProtocoloMantenimientoVersionDetalleTareaList}"  />
                <rich:panel headerClass="headerClassACliente" style="width:70%">
                    <f:facet name="header">
                        <h:outputText value="Protocolo Mantenimiento"/>
                    </f:facet>
                    <h:panelGrid columns="6">
                        
                        <h:outputText value="Maquinaria" styleClass="outputTextBold"/>
                        <h:outputText value="::" styleClass="outputTextBold"/>
                        <h:outputText value="#{ManagedProtocoloMantenimiento.protocoloMantenimientoBean.protocoloMantenimiento.maquinaria.nombreMaquina}" styleClass="outputText2"/>
                        <h:outputText value="Parte Maquinaria" styleClass="outputTextBold"/>
                        <h:outputText value="::" styleClass="outputTextBold"/>
                        <h:outputText value="#{ManagedProtocoloMantenimiento.protocoloMantenimientoBean.protocoloMantenimiento.partesMaquinaria.nombreParteMaquina}" styleClass="outputText2"/>
                        <h:outputText value="Descripción" styleClass="outputTextBold"/>
                        <h:outputText value="::" styleClass="outputTextBold"/>
                        <h:outputText value="#{ManagedProtocoloMantenimiento.protocoloMantenimientoVersionBean.descripcionProtocoloMantenimientoVersion}" styleClass="outputText2"/>
                        <h:outputText value="Tipo Mantenimiento" styleClass="outputTextBold"/>
                        <h:outputText value="::" styleClass="outputTextBold"/>
                        <h:outputText value="#{ManagedProtocoloMantenimiento.protocoloMantenimientoVersionBean.tiposMantenimientoMaquinaria.nombreTipoMantenimientoMaquinaria}" styleClass="outputText2"/>
                        <h:outputText value="Estado Protocolo" styleClass="outputTextBold"/>
                        <h:outputText value="::" styleClass="outputTextBold"/>
                        <h:outputText value="#{ManagedProtocoloMantenimiento.protocoloMantenimientoVersionBean.estadoRegistro.nombreEstadoRegistro}" styleClass="outputText2"/>
                        <h:outputText value="Nro Versión" styleClass="outputTextBold"/>
                        <h:outputText value="::" styleClass="outputTextBold"/>
                        <h:outputText value="#{ManagedProtocoloMantenimiento.protocoloMantenimientoVersionBean.nroVersion}" styleClass="outputText2"/>
                    </h:panelGrid>
                </rich:panel>
                <br>
                <rich:dataTable value="#{ManagedProtocoloMantenimiento.protocoloMantenimientoVersionDetalleTareaList}"
                                    var="data" id="dataProtocoloMantenimientoDetalleTarea"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente">
                        <f:facet name="header">
                            <rich:columnGroup>
                                <rich:column >
                                    <h:outputText value=""/>
                                </rich:column>
                                <rich:column >
                                    <h:outputText value="Nro. Tarea"/>
                                </rich:column>
                                <rich:column >
                                    <h:outputText value="Tipo Tarea"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Descripción"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Horas Hombre"/>
                                </rich:column>
                            </rich:columnGroup>
                        </f:facet>
                        <rich:column>
                            <h:selectBooleanCheckbox value="#{data.checked}"/>
                        </rich:column>
                        
                        <rich:column>
                            <h:outputText value="#{data.nroTarea}"  />
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.tiposTarea.nombreTipoTarea}"  />
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.descripcionTarea}"  />
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.horasStandar}" />
                        </rich:column>
                        
                    </rich:dataTable>
                    
                    <br>
                    <div class="barraBotones" id="bottonesAcccion">
                        <a4j:commandButton value="Agregar" styleClass="btn" 
                                           action="#{ManagedProtocoloMantenimiento.agregarProtocoloMantenimientoVersionDetalleTarea_action}"
                                                   reRender="contenidoAgregarTarea"
                                                   oncomplete="Richfaces.showModalPanel('panelAgregarTarea');"/>
                        <a4j:commandButton value="Editar" styleClass="btn" action="#{ManagedProtocoloMantenimiento.editarProtocoloMantenimientoVersionDetalleTarea_action}"
                                            reRender="contenidoEditarTarea"
                                            onclick="if(!editarItem('form1:dataProtocoloMantenimientoDetalleTarea')){return false}"
                                            oncomplete="Richfaces.showModalPanel('panelEditarProtocoloTarea');"/>
                        <a4j:commandButton value="Eliminar" styleClass="btn" action="#{ManagedProtocoloMantenimiento.eliminarProtocoloMantenimientoVersionDetalleTareas_action}"
                                           onclick="if(!editarItem('form1:dataProtocoloMantenimientoDetalleTarea')){return false}"
                                           oncomplete="if(#{ManagedProtocoloMantenimiento.mensaje eq '1'}){alert('Se elimino el material');}else{alert('#{ManagedProtocoloMantenimiento.mensaje}')}"
                                           reRender="dataProtocoloMantenimientoDetalleTarea"/>
                        <a4j:commandButton value="Cancelar" styleClass="btn" 
                                               oncomplete="redireccionar('../navegadorProtocolosMantenimientoVersion.jsf');"/>
                    </div>
                </div>
            </a4j:form>
            <rich:modalPanel id="panelAgregarTarea" 
                            minHeight="250"  minWidth="630" height="250" width="630"
                            zindex="100" headerClass="headerClassACliente"
                            resizeable="false" style="overflow :auto" >
                <f:facet name="header">
                    <h:outputText value="<center>Agregar Tarea</center>" escape="false"/>
                </f:facet>
                <a4j:form id="formAgregarTarea">
                    <h:panelGroup id="contenidoAgregarTarea">
                        <div align="center">
                            <h:panelGrid columns="3">
                                <h:outputText value="Nro. Tarea" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:inputText value="#{ManagedProtocoloMantenimiento.protocoloMantenimientoVersionDetalleTareaAgregar.nroTarea}" styleClass="inputText" id="nroPasoAgregar" onblur="valorPorDefecto(this)"/>
                                <h:outputText value="Tipo Tarea" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:selectOneMenu value="#{ManagedProtocoloMantenimiento.protocoloMantenimientoVersionDetalleTareaAgregar.tiposTarea.codTipoTarea}" styleClass="inputText">
                                    <f:selectItems value="#{ManagedProtocoloMantenimiento.tiposTareaSelectList}"/>
                                </h:selectOneMenu>
                                <h:outputText value="Descripción" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:inputTextarea value="#{ManagedProtocoloMantenimiento.protocoloMantenimientoVersionDetalleTareaAgregar.descripcionTarea}" styleClass="inputText" id="descripcionTarea" style="width:25em">
                                </h:inputTextarea>
                                <h:outputText value="Horas Hombre" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:inputText value="#{ManagedProtocoloMantenimiento.protocoloMantenimientoVersionDetalleTareaAgregar.horasStandar}" styleClass="inputText" onblur="valorPorDefecto(this)"/>
                            </h:panelGrid>
                            
                            <br>
                            <a4j:commandButton value="Guardar" styleClass="btn" reRender="dataProtocoloMantenimientoDetalleTarea"
                                               onclick="if(!validarAgregarTarea()){return false;}"
                                               action="#{ManagedProtocoloMantenimiento.guardarAgregarProtocoloMantenimientoVersionDetalleTarea_action}"
                                               oncomplete="if(#{ManagedProtocoloMantenimiento.mensaje eq '1'}){alert('Se agrego la tarea');Richfaces.hideModalPanel('panelAgregarTarea')}
                                               else{alert('#{ManagedProtocoloMantenimiento.mensaje}');}"/>
                            <a4j:commandButton value="Cancelar" styleClass="btn"
                                               oncomplete="Richfaces.hideModalPanel('panelAgregarTarea')"/>
                            
                        </div>
                    </h:panelGroup>
                </a4j:form>
            </rich:modalPanel>
            <rich:modalPanel id="panelEditarProtocoloTarea" 
                            minHeight="250"  minWidth="500" height="250" width="500"
                            zindex="200" headerClass="headerClassACliente"
                            resizeable="false" style="overflow :auto" >
                <f:facet name="header">
                    <h:outputText value="<center>Edición de Tarea</center>" escape="false"/>
                </f:facet>
                <a4j:form id="formEditarTarea">
                    <h:panelGroup id="contenidoEditarTarea">
                        <div align="center">
                            <h:panelGrid columns="3">
                                <h:panelGrid columns="3">
                                <h:outputText value="Nro. Tarea" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:inputText value="#{ManagedProtocoloMantenimiento.protocoloMantenimientoVersionDetalleTareaEditar.nroTarea}" styleClass="inputText" id="nroPasoAgregar" onblur="valorPorDefecto(this)"/>
                                <h:outputText value="Tipo Tarea" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:selectOneMenu value="#{ManagedProtocoloMantenimiento.protocoloMantenimientoVersionDetalleTareaEditar.tiposTarea.codTipoTarea}" styleClass="inputText">
                                    <f:selectItems value="#{ManagedProtocoloMantenimiento.tiposTareaSelectList}"/>
                                </h:selectOneMenu>
                                <h:outputText value="Descripción" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:inputTextarea value="#{ManagedProtocoloMantenimiento.protocoloMantenimientoVersionDetalleTareaEditar.descripcionTarea}" styleClass="inputText" style="width:25em" id="descripcionTarea">
                                </h:inputTextarea>
                                <h:outputText value="Horas Hombre" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:inputText value="#{ManagedProtocoloMantenimiento.protocoloMantenimientoVersionDetalleTareaEditar.horasStandar}" styleClass="inputText" onblur="valorPorDefecto(this)"/>
                            </h:panelGrid>
                            </h:panelGrid>
                            <br>
                            <a4j:commandButton value="Guardar" styleClass="btn" action="#{ManagedProtocoloMantenimiento.guardarEditarProtocoloMantenimentoVersionDetalleTarea_action}"
                                               onclick="if(!validarEditarMaterial()){return false}"
                                               oncomplete="if(#{ManagedProtocoloMantenimiento.mensaje eq '1'}){alert('Se guardo la edición');Richfaces.hideModalPanel('panelEditarProtocoloTarea');}
                                               else{alert('#{ManagedProtocoloMantenimiento.mensaje}');}" reRender="dataProtocoloMantenimientoDetalleTarea"/>
                            <a4j:commandButton value="Cancelar" styleClass="btn"
                                               oncomplete="Richfaces.hideModalPanel('panelEditarProtocoloTarea')"/>
                            
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
                    <h:graphicImage value="../../../img/load2.gif" />
                </div>
            </rich:modalPanel>
            
        </body>
    </html>
    
</f:view>

