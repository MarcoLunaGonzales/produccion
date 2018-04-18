<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<rich:modalPanel id="modalDefinirProcesos" minHeight="330" headerClass="headerClassACliente"
                        minWidth="730" height="330" width="730" zindex="100" >
       <f:facet name="header">
           <h:outputText value="<center>Habilitación de procesos de Orden de manufactura</center>" escape="false"/>
       </f:facet>
       <a4j:form id="formProcesos">
           <center>
               <h:panelGroup id="contenidoDefinirProcesos">
                   <table width="100%">
                        <tr>
                            <td colspan="3" style="width:45%">
                                <div style="height:240px;overflow-y:auto;width:auto">
                                   <rich:dataTable value="#{ManagedProductosDesarrolloVersion.componentesProdProcesoOrdenManufacturaDisponibleList}"
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
                                                   <h:outputText value="Registros<br>Habilitados" escape="false"/>
                                               </rich:column>
                                           </rich:columnGroup>
                                       </f:facet>
                                        <rich:column>
                                            <a4j:commandLink styleClass="btn"  reRender="contenidoDefinirProcesos"
                                                             title="Agregar"
                                                            action="#{ManagedProductosDesarrolloVersion.agregarProcesoOrdenManufacturaAction(data)}">
                                               <h:outputText styleClass="icon-checkmark"/>
                                           </a4j:commandLink>
                                        </rich:column>
                                        <rich:column>
                                           <h:outputText value="#{data.formasFarmaceuticasProcesoOrdenManufactura.procesosOrdenManufactura.nombreProcesoOrdenManufactura}" />
                                        </rich:column>
                                        <rich:column style="font-size:9px !important">
                                            <h:outputText value="*Especificaciones de Maquinaria</br>" escape="false"
                                                          rendered="#{data.formasFarmaceuticasProcesoOrdenManufactura.aplicaEspecificacionesMaquinaria}"/>
                                            <h:outputText value="*Especificaciones de Proceso</br>" escape="false"
                                                          rendered="#{data.formasFarmaceuticasProcesoOrdenManufactura.aplicaEspecificacionesProceso}"/>
                                            <h:outputText value="*Flujograma</br>" escape="false"
                                                          rendered="#{data.formasFarmaceuticasProcesoOrdenManufactura.aplicaFlujograma}"/>
                                        </rich:column>
                                    </rich:dataTable>
                                   </div>
                               <td>
                            <td colspan="3" style="width:55%">
                                <div style="height:240px;overflow-y:auto;width:auto">
                                   <rich:dataTable value="#{ManagedProductosDesarrolloVersion.componentesProdProcesoOrdenManufacturaList}"
                                                   var="data" id="dataProcesosOm" rowKeyVar="index"
                                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                                    onRowMouseOver="this.style.backgroundColor='#F3F7FD';" 
                                                    headerClass="headerClassACliente">
                                       <f:facet name="header">
                                           <rich:columnGroup>
                                                <rich:column>
                                                   <h:outputText value="Nro. Paso"/>
                                                </rich:column>
                                                <rich:column>
                                                   <h:outputText value="Proceso"/>
                                                </rich:column>
                                                <rich:column>
                                                   <h:outputText value="Registros<br>Habilitados" escape="false"/>
                                                </rich:column>
                                                <rich:column>
                                                    <h:outputText value="Ordenar"/>
                                                </rich:column>
                                                <rich:column>
                                                    <h:outputText value="Eliminar"/>
                                                </rich:column>
                                           </rich:columnGroup>
                                       </f:facet>
                                       <rich:column>
                                           <h:outputText value="#{index+1}"/>
                                       </rich:column>
                                       <rich:column>
                                           <h:outputText value="#{data.formasFarmaceuticasProcesoOrdenManufactura.procesosOrdenManufactura.nombreProcesoOrdenManufactura}" />
                                       </rich:column> 
                                       <rich:column style="font-size:9px !important">
                                            <h:outputText value="*Especificaciones de Maquinaria</br>" escape="false"
                                                          rendered="#{data.formasFarmaceuticasProcesoOrdenManufactura.aplicaEspecificacionesMaquinaria}"/>
                                            <h:outputText value="*Especificaciones de Proceso</br>" escape="false"
                                                          rendered="#{data.formasFarmaceuticasProcesoOrdenManufactura.aplicaEspecificacionesProceso}"/>
                                            <h:outputText value="*Flujograma</br>" escape="false"
                                                          rendered="#{data.formasFarmaceuticasProcesoOrdenManufactura.aplicaFlujograma}"/>
                                        </rich:column>
                                        <rich:column>
                                            <a4j:commandLink styleClass="btn" reRender="contenidoDefinirProcesos" rendered="#{index>0}"
                                                            action="#{ManagedProductosDesarrolloVersion.adicionarOrdenProcesoOrdenManufacturaAction(index,-1)}">
                                               <h:outputText styleClass="icon-arrow-up"/>
                                           </a4j:commandLink>
                                           <a4j:commandLink styleClass="btn" reRender="contenidoDefinirProcesos" rendered="#{(index+1) ne ManagedProductosDesarrolloVersion.componentesProdProcesoOrdenManufacturaList.size()}"
                                                             action="#{ManagedProductosDesarrolloVersion.adicionarOrdenProcesoOrdenManufacturaAction(index,1)}">
                                               <h:outputText styleClass="icon-arrow-down"/>
                                           </a4j:commandLink>
                                        </rich:column>
                                        <rich:column>
                                            <a4j:commandLink styleClass="btn"  reRender="contenidoDefinirProcesos"
                                                            title="Quitar" action="#{ManagedProductosDesarrolloVersion.eliminarProcesoOrdenManufacturaAction(data)}">
                                               <h:outputText styleClass="icon-cross"/>
                                            </a4j:commandLink>
                                        </rich:column>
                                    </rich:dataTable>
                                   </div>
                               <td>
                           </tr>
                       </table>
               </h:panelGroup>

               <a4j:commandButton action="#{ManagedProductosDesarrolloVersion.guardarComponentesProdProceosOrdenManufacturaAction}" 
                                  oncomplete="mostrarMensajeTransaccionEvento(function(){Richfaces.hideModalPanel('modalDefinirProcesos');})"
                                  styleClass="btn" value="Guardar"/>
               <a4j:commandButton value="Cancelar" styleClass="btn" oncomplete="Richfaces.hideModalPanel('modalDefinirProcesos')"/>
       </center>

       </a4j:form>

</rich:modalPanel>


