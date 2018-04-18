<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<rich:modalPanel id="panelAperturaLoteProduccion" minHeight="280"  minWidth="480"
                        height="280" width="480" zindex="200"
                        headerClass="headerClassACliente"
                        resizeable="false">
   <f:facet name="header">
       <h:outputText value="<center>Apertura de lote de Producción</center>" escape="false" />
   </f:facet>

   <a4j:form id="formAperturaLoteProduccion">
       <center>
           <h:panelGroup id="contenidoAperturaLoteProduccion">
               <rich:panel headerClass="headerClassACliente">
                   <f:facet name="header">
                       <h:outputText value="Datos del Lote"/>
                   </f:facet>
                   <h:panelGrid columns="3">
                       <h:outputText value="Programa" styleClass="outputTextBold"/>
                       <h:outputText value="::" styleClass="outputTextBold"/>
                       <h:outputText value="#{ManagedProgramaProduccion.programaProduccionApertura.programaProduccionPeriodo.nombreProgramaProduccion}" styleClass="outputText2"/>
                       <h:outputText value="Lote" styleClass="outputTextBold"/>
                       <h:outputText value="::" styleClass="outputTextBold"/>
                       <h:outputText value="#{ManagedProgramaProduccion.programaProduccionApertura.codLoteProduccion}" styleClass="outputText2"/>
                       <h:outputText value="Tipo Producción" styleClass="outputTextBold"/>
                       <h:outputText value="::" styleClass="outputTextBold"/>
                       <h:outputText value="#{ManagedProgramaProduccion.programaProduccionApertura.tiposProgramaProduccion.nombreTipoProgramaProd}" styleClass="outputText2"/>
                       <h:outputText value="Producto" styleClass="outputTextBold"/>
                       <h:outputText value="::" styleClass="outputTextBold"/>
                       <h:outputText value="#{ManagedProgramaProduccion.programaProduccionApertura.formulaMaestra.componentesProd.nombreProdSemiterminado}" styleClass="outputText2"/>
                       <h:outputText value="Observación" styleClass="outputTextBold"/>
                       <h:outputText value="::" styleClass="outputTextBold"/>
                       <h:inputTextarea value="#{ManagedProgramaProduccion.programaProduccionApertura.observacion}" styleClass="inputText" style="inputText" rows="3"/>
                   </h:panelGrid>
                   <a4j:commandButton action="#{ManagedProgramaProduccion.guardarAperturaLoteProgramaProduccion_action}"
                                  reRender="dataProgramaProduccion" styleClass="btn" value="Aperturar"
                                  oncomplete="mostrarMensajeTransaccionEvento(function(){Richfaces.hideModalPanel('panelAperturaLoteProduccion');})"/>
               <a4j:commandButton value="Cancelar" oncomplete="Richfaces.hideModalPanel('panelAperturaLoteProduccion')" styleClass="btn"/>
               </rich:panel>


           </h:panelGroup>    
       </center>
   </a4j:form>    
</rich:modalPanel>