<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>

   <rich:modalPanel id="panelMostrarEspecificacionesEquipo" minHeight="300"  minWidth="850"
                    height="410" width="850"
                    zindex="200"
                    headerClass="headerClassACliente"
                    resizeable="false" >
       <f:facet name="header">
           <h:outputText value="<center>Especificaciones de equipo</center>" escape="false"/>
       </f:facet>
       <a4j:form id="formEditar">
       <h:panelGroup id="contenidoMostrarEspecificacionesEquip">
           <rich:panel headerClass="headerClassACliente">
               <f:facet name="header">
                   <h:outputText value="<center>Datos de la maquina<center>" escape="false"/>
               </f:facet>
               <center>
                   <h:panelGrid columns="6">
                       <h:outputText value="Nro. Paso" styleClass="outputTextBold"/>
                       <h:outputText value="::" styleClass="outputTextBold"/>
                       <h:outputText value="#{ManagedProductosDesarrolloVersion.procesosPreparadoProducto.nroPaso}" styleClass="outputText2"/>
                       <h:outputText value="Nombre Actividad Proceso" styleClass="outputTextBold"/>
                       <h:outputText value="::" styleClass="outputTextBold"/>
                       <h:outputText value="#{ManagedProductosDesarrolloVersion.procesosPreparadoProducto.actividadesPreparado.nombreActividadPreparado}" styleClass="outputText2"/>
                       <h:outputText value="Maquina" styleClass="outputTextBold"/>
                       <h:outputText value="::" styleClass="outputTextBold"/>
                       <h:outputText value="#{ManagedProductosDesarrolloVersion.procesosPreparadoProductoMaquinaria.maquinaria.nombreMaquina}" styleClass="outputText2"/>
                       <h:outputText value="Codigo" styleClass="outputTextBold"/>
                       <h:outputText value="::" styleClass="outputTextBold"/>
                       <h:outputText value="#{ManagedProductosDesarrolloVersion.procesosPreparadoProductoMaquinaria.maquinaria.codigo}" styleClass="outputText2"/>
                   </h:panelGrid>
               </center>
           </rich:panel>
               <center>
                   <table>
                       <tr>
                           <td>
                               <div style="height:220px;width:780px;overflow: auto">

                               <rich:dataTable value="#{ManagedProductosDesarrolloVersion.procesosPreparadoProductoMaquinaria.procesosPreparadoProductoEspecificacionesMaquinariaList}"
                                   var="data" id="dataEspecificacionesMaquinaria"
                                   headerClass="headerClassACliente"
                                   columnClasses="tituloCampo">
                                   <f:facet name="header">
                                       <rich:columnGroup>
                                           <rich:column>
                                               <h:outputText value=" "/>
                                           </rich:column>
                                           <rich:column>
                                               <h:outputText value="Nombre Especificación</br><input class='inputText' onkeyup='buscarCeldaAgregar(this,1)' type='text'" escape="false"/>
                                           </rich:column>
                                           <rich:column>
                                               <h:outputText value="Tipo Descripción "/>
                                           </rich:column>
                                           <rich:column>
                                               <h:outputText value="Descripción "/>
                                           </rich:column>
                                           <rich:column>
                                               <h:outputText value="Unidad Medida"/>
                                           </rich:column>
                                           <rich:column>
                                               <h:outputText value="Resultado<br>Esperado Lote" escape="false"/>
                                           </rich:column>
                                           <rich:column>
                                               <h:outputText value="Porciento<br>Tolerancia" escape="false"/>
                                           </rich:column>
                                       </rich:columnGroup>
                                   </f:facet>
                                       <rich:column>
                                           <h:selectBooleanCheckbox value="#{data.checked}"/>
                                       </rich:column>
                                       <rich:column>
                                           <h:outputText value="#{data.especificacionesProcesos.nombreEspecificacionProceso}" styleClass="outputText2"/>
                                       </rich:column>
                                       <rich:column >
                                           <h:selectOneMenu value="#{data.tiposDescripcion.codTipoDescripcion}" styleClass="inputText">
                                               <f:selectItems value="#{ManagedProductosDesarrolloVersion.tiposDescripcionSelectList}"/>
                                               <a4j:support event="onchange" reRender="dataEspecificacionesMaquinaria"/>
                                           </h:selectOneMenu>
                                       </rich:column>
                                       <rich:column >
                                           <h:inputText value="#{data.valorExacto}" rendered="#{data.tiposDescripcion.codTipoDescripcion>2}" styleClass="inputText" onblur="valorPorDefecto(this)"/>
                                           <h:inputText value="#{data.valorTexto}" rendered="#{data.tiposDescripcion.codTipoDescripcion eq 1}" styleClass="inputText"/>
                                           <h:inputText value="#{data.valorMinimo}" style="width:6em" rendered="#{data.tiposDescripcion.codTipoDescripcion eq 2}" styleClass="inputText" onblur="valorPorDefecto(this)"/>
                                           <h:outputText value="-" rendered="#{data.tiposDescripcion.codTipoDescripcion eq 2}" styleClass="outputText2"/>
                                           <h:inputText value="#{data.valorMaximo}" style="width:6em" rendered="#{data.tiposDescripcion.codTipoDescripcion eq 2}" styleClass="inputText" onblur="valorPorDefecto(this)"/>
                                       </rich:column>
                                       <rich:column>
                                           <h:selectOneMenu value="#{data.unidadesMedida.codUnidadMedida}" styleClass="inputText" style="width:17em">
                                               <f:selectItem itemValue="0" itemLabel="--NINGUNO--"/>
                                               <f:selectItems value="#{ManagedProductosDesarrolloVersion.unidadesMedidaSelectList}"/>
                                           </h:selectOneMenu>
                                       </rich:column>
                                       <rich:column>
                                           <h:selectBooleanCheckbox value="#{data.resultadoEsperadoLote}"/>
                                       </rich:column>
                                       <rich:column>
                                           <h:inputText onblur="valorPorDefecto(this)" value="#{data.porcientoTolerancia}" size="4" styleClass="inputText"/>
                                       </rich:column>
                                   </rich:dataTable>
                               </div>
                           </td>
                       </tr>
                   </table>
               </center>

               <div align="center" style="margin-top:1em">
                   <a4j:commandButton styleClass="btn" value="Guardar"  action="#{ManagedProductosDesarrolloVersion.guardarProcesosPreparadoProductoEspecificacionesMaquinariaAction}"
                                      onclick="if(!validarAgregarModificarEspecificacionesProcesos()){return false;}"
                                      oncomplete="mostrarMensajeTransaccionEvento(function(){Richfaces.hideModalPanel('panelMostrarEspecificacionesEquipo');})"/>
               <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('panelMostrarEspecificacionesEquipo')" class="btn" />
               </div>
       </h:panelGroup>
       </a4j:form>
</rich:modalPanel>