<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>

<rich:modalPanel id="panelPersonalVersion" minHeight="330"
                 headerClass="headerClassACliente"
                 minWidth="730" height="380" width="780" zindex="100" >
       <f:facet name="header">
           <h:outputText value="<center>Personal Habilitado Versión</center>" escape="false"/>
       </f:facet>
       <a4j:form id="formPersonalVersion">
           <center>
               <h:panelGroup id="contenidoPersonalVersion">
                   <rich:panel headerClass="headerClassACliente">
                       <f:facet name="header">
                           <h:outputText value="Datos de la Versión"/>
                       </f:facet>
                   </rich:panel>
                   <table width="100%">
                        <tr>
                            <td colspan="3" style="width:45%">
                                <div style="height:240px;overflow-y:auto;width:auto">
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
                                            <a4j:commandLink styleClass="btn"  reRender="contenidoPersonalVersion"
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
                                <div style="height:240px;overflow-y:auto;width:auto">
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
                                                <rich:column>
                                                    <h:outputText value="Fecha Inicio Trabajo"/>
                                                </rich:column>
                                                <rich:column>
                                                    <h:outputText value="Devolver Versión"/>
                                                </rich:column>
                                           </rich:columnGroup>
                                       </f:facet>
                                       <rich:column>
                                            <a4j:commandLink styleClass="btn"  reRender="contenidoPersonalVersion"
                                                             rendered="#{data.fechaInclusionVersion eq null}"
                                                            title="Quitar" action="#{ManagedComponentesProdVersion.eliminarAsignacionPersonalAction(data)}">
                                               <h:outputText styleClass="icon-cross"/>
                                            </a4j:commandLink>
                                           <h:outputText value="No se puede eliminar al personal por que ya inicio su trabajo"
                                                         rendered="#{data.fechaInclusionVersion ne null}"
                                                         styleClass="outputText2" style="color:red"/>
                                       </rich:column>
                                       <rich:column>
                                            <h:outputText value="#{data.personal.nombreCompletoPersonal}" />
                                       </rich:column> 
                                       <rich:column>
                                            <h:outputText value="#{data.tiposPermisosEspecialesAtlas.nombreTipoPermisoEspecialAtlas}" />
                                        </rich:column>
                                       <rich:column>
                                            <h:outputText value="#{data.fechaInclusionVersion}">
                                                <f:convertDateTime pattern="dd/MM/yyyy HH:mm"/>
                                            </h:outputText>
                                        </rich:column>
                                        <rich:column>
                                            <a4j:commandButton value="Devolver" action="#{ManagedComponentesProdVersion.devolverVersionPersonalAction(data)}"
                                                               rendered="#{data.estadosVersionComponentesProd.codEstadoVersionComponenteProd eq 3}"
                                                               styleClass="btn"
                                                               reRender="contenidoPersonalVersion">
                                            </a4j:commandButton>
                                        </rich:column>
                                    </rich:dataTable>
                                   </div>
                               <td>
                           </tr>
                       </table>
               </h:panelGroup>

               <a4j:commandButton action="#{ManagedComponentesProdVersion.guardarAsignacionPersonalModificacionAction}"
                                  reRender="dataComponentesProdVersion"
                                  oncomplete="mostrarMensajeTransaccionEvento(function(){Richfaces.hideModalPanel('panelPersonalVersion');})"
                                  styleClass="btn" value="Guardar"/>
               <a4j:commandButton value="Cancelar" styleClass="btn" oncomplete="Richfaces.hideModalPanel('panelPersonalVersion')"/>
       </center>

       </a4j:form>

</rich:modalPanel>


