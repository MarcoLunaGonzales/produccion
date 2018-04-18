<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<rich:modalPanel id="panelCrearNuevaVersion" minHeight="330"
                 headerClass="headerClassACliente"
                 minWidth="730" height="380" width="730" zindex="100" >
       <f:facet name="header">
           <h:outputText value="<center>Creación de Versión</center>" escape="false"/>
       </f:facet>
       <a4j:form id="formCrearVersion">
           <center>
               <h:panelGroup id="contenidoCrearVersion">
                   <h:outputText value="Esta seguro de crear una nueva versión?" styleClass="outputTextBold"
                                 style="font-size:14px"/>
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
                                            <a4j:commandLink styleClass="btn"  reRender="contenidoCrearVersion"
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
                                            <a4j:commandLink styleClass="btn"  reRender="contenidoCrearVersion"
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
               <br/>
               <a4j:commandButton action="#{ManagedComponentesProdVersion.guardarAgregarNuevaVersionAction()}"
                                  reRender="dataComponentesProdVersion"
                                  oncomplete="mostrarMensajeTransaccionEvento(function(){Richfaces.hideModalPanel('panelCrearNuevaVersion');})"
                                  styleClass="btn" value="Crear Nueva Versión"/>
               <a4j:commandButton value="Cancelar" styleClass="btn" oncomplete="Richfaces.hideModalPanel('panelCrearNuevaVersion')"/>
            </center>

       </a4j:form>

</rich:modalPanel>


