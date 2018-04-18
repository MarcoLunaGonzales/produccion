<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<rich:modalPanel id="panelCrearNuevoTamanioLote" minHeight="410" headerClass="headerClassACliente"
                    minWidth="550" height="410" width="700" zindex="100" >
    <f:facet name="header">
       <h:outputText value="<center>Creación de Nuevo Tamanio de Lote de Producción</center>" escape="false"/>
    </f:facet>
    <a4j:form id="form5">
        <center>
            <h:panelGroup id="contenidoRegistroNuevotamanioLote">
                <h:panelGrid columns="6">
                    <h:outputText value="Producto" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:outputText value="#{ManagedComponentesProdVersion.componentesProdBean.nombreProdSemiterminado}" styleClass="outputText2"/>
                    <h:outputText value="N° Versión" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:outputText value="#{ManagedComponentesProdVersion.componentesProdBean.nroUltimaVersion}" styleClass="outputText2"/>
                    <h:outputText value="Tamaño Lote Original" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:outputText value="#{ManagedComponentesProdVersion.componentesProdBean.tamanioLoteProduccion}" styleClass="outputText2"/>
                    <h:outputText value="Nuevo tamanio Lote Produccion" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:inputText value="#{ManagedComponentesProdVersion.nuevoTamanioLoteProduccion}" styleClass="inputText" id="nuevoTamanioLote" onblur="valorPorDefecto(this)"/>
                </h:panelGrid>
            
            <rich:panel headerClass="headerClassACliente">
                    <f:facet name="header">
                        <h:outputText value="Personal Asignado a Versión"/>
                    </f:facet>
                <table width="100%">
                    <tr>
                        <td colspan="3" style="width:50%">
                            <div style="height:210px;overflow-y:auto;width:auto">
                               <rich:dataTable value="#{ManagedComponentesProdVersion.componentesProdVersionModificacionAgregarList}"
                                   var="data" id="dataProcesosDisponible"
                                   onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                   onRowMouseOver="this.style.backgroundColor='#F3F7FD';" 
                                   headerClass="headerClassACliente">
                                   <f:facet name="header">
                                       <rich:columnGroup>
                                           <rich:column>
                                               <h:outputText value="Agregar"/>
                                           </rich:column>
                                           <rich:column>
                                               <h:outputText value="Proceso</br><input class='inputText' onkeyup='buscarCeldaAgregar(this,1)'/>" escape="false"/>
                                           </rich:column>
                                           <rich:column>
                                               <h:outputText value="Tarea Configurada" escape="false"/>
                                           </rich:column>
                                       </rich:columnGroup>
                                   </f:facet>
                                    <rich:column>
                                        <a4j:commandLink styleClass="btn"  reRender="contenidoRegistroNuevotamanioLote"
                                                         title="Agregar"
                                                        action="#{ManagedComponentesProdVersion.agregarAsignacionPersonalAction(data)}">
                                           <h:outputText styleClass="icon-checkmark"/>
                                       </a4j:commandLink>
                                    </rich:column>
                                    <rich:column>
                                       <h:outputText value="#{data.personal.nombreCompletoPersonal}" />
                                    </rich:column>
                                    <rich:column>
                                       <h:outputText value="#{data.tiposPermisosEspecialesAtlas.nombreTipoPermisoEspecialAtlas}" />
                                    </rich:column>
                                </rich:dataTable>
                               </div>
                           <td>
                        <td colspan="3" style="width:55%">
                            <div style="height:210px;overflow-y:auto;width:auto">
                               <rich:dataTable value="#{ManagedComponentesProdVersion.componentesProdVersionModificacionList}"
                                               var="data" id="dataProcesosOm" rowKeyVar="index"
                                                onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                                onRowMouseOver="this.style.backgroundColor='#F3F7FD';" 
                                                headerClass="headerClassACliente">
                                   <f:facet name="header">
                                       <rich:columnGroup>
                                            <rich:column>
                                               <h:outputText value="Eliminar"/>
                                            </rich:column>
                                            <rich:column>
                                               <h:outputText value="Proceso"/>
                                            </rich:column>
                                            <rich:column>
                                               <h:outputText value="Tarea Configurada" escape="false"/>
                                            </rich:column>
                                       </rich:columnGroup>
                                   </f:facet>
                                   <rich:column>
                                        <a4j:commandLink styleClass="btn"  reRender="contenidoRegistroNuevotamanioLote"
                                                        title="Quitar" action="#{ManagedComponentesProdVersion.eliminarAsignacionPersonalAction(data)}">
                                           <h:outputText styleClass="icon-cross"/>
                                        </a4j:commandLink>
                                   </rich:column>
                                   <rich:column>
                                        <h:outputText value="#{data.personal.nombreCompletoPersonal}" />
                                   </rich:column> 
                                   <rich:column>
                                        <h:outputText value="#{data.tiposPermisosEspecialesAtlas.nombreTipoPermisoEspecialAtlas}" />
                                    </rich:column>
                                </rich:dataTable>
                               </div>
                           <td>
                       </tr>
                   </table>
            </rich:panel>
            </h:panelGroup>
            <a4j:commandButton action="#{ManagedComponentesProdVersion.crearNuevoTamanioLoteProduccion}" 
                               onclick="if(!validarMayorACero(document.getElementById('crearNuevoTamanioLote:form5:nuevoTamanioLote'))){return false;}"
                               oncomplete="mostrarMensajeTransaccionEvento(function(){redireccionar('navegadorNuevosTamaniosLote.jsf');})"
                               styleClass="btn" value="Crear Nuevo Tamaño de Lote"/>
            <a4j:commandButton value="Cancelar" styleClass="btn" oncomplete="Richfaces.hideModalPanel('panelCrearNuevoTamanioLote')"/>
        </center>

    </a4j:form>

</rich:modalPanel>
