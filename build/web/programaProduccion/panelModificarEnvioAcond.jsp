<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>

<rich:modalPanel id="panelModificarEnvioAcond"
                    minHeight="300"  minWidth="900"
                    height="300" width="900" zindex="200"
                    headerClass="headerClassACliente"
                    resizeable="false">
        <f:facet name="header">
            <h:outputText value="<center>Modificar Envio Acondicionamiento</center>" escape="false"/>
        </f:facet>
        <div align="center">
        <a4j:form id="form2">
        <h:panelGroup id="contenidoModificarEnvioAcond">
            <h:panelGrid columns="4">
                <h:outputText styleClass="outputTextBold"   value="Almacen Destino:"  />
                <h:outputText value="#{ManagedProgramaProduccion.ingresosAcond.almacenAcond.nombreAlmacenAcond}" styleClass="outputText2"/>
           <h:outputText value="Estado:" styleClass="outputTextBold"  />
           <h:outputText value="#{ManagedProgramaProduccion.ingresosAcond.estadosIngresoAcond.nombreEstadoIngresoAcond}" styleClass="outputText2"  />
           <h:outputText value="Observaciones:" styleClass="outputTextBold" />
           <h:inputTextarea styleClass="inputText"  cols="50" 
                            value="#{ManagedProgramaProduccion.ingresosAcond.obsIngresoAcond}"/>
           </h:panelGrid>
           <h:panelGrid  cellpadding="0" cellspacing="0" columns="8" rowClasses="headerClassACliente linea,classDetalle">
                   <h:outputText value="Producto"/>
                    <h:outputText value="Lote"  />
                    <h:outputText value="Fecha Vencimiento" />
                    <h:outputText value="Cant. de Ingreso" />
                    <h:outputText value="Peso [Kg.]" />
                    <h:outputText value="Cant. de Envase" />
                    <h:outputText value="Tipo de Envase" />
                    <h:outputText value="Lotes" />
                   <h:outputText value="#{ManagedProgramaProduccion.ingresosAcond.ingresosDetalleAcondList.get(0).componentesProd.nombreProdSemiterminado}" styleClass="outputText2"/>
                   <h:outputText value="#{ManagedProgramaProduccion.ingresosAcond.ingresosDetalleAcondList.get(0).codLoteProduccion}" styleClass="outputText2"/>
                   <h:outputText value="#{ManagedProgramaProduccion.ingresosAcond.ingresosDetalleAcondList.get(0).fechaPesaje}" styleClass="outputText2"
                   rendered="#{ManagedProgramaProduccion.ingresosAcond.ingresosDetalleAcondList.get(0).componentesProd.forma.codForma !='2'&&
                              ManagedProgramaProduccion.ingresosAcond.ingresosDetalleAcondList.get(0).fechaPesaje!=null}">
                       <f:convertDateTime pattern="dd/MM/yyyy"/>
                   </h:outputText>
                   <h:panelGroup>
                        <h:inputText value="#{ManagedProgramaProduccion.ingresosAcond.ingresosDetalleAcondList.get(0).cantIngresoProduccion}" 
                                     required="true" requiredMessage="Debe registrar un numero" 
                                     converterMessage="Debe registra un nuevo entero"
                                     styleClass="inputText" onkeypress="valNum();" id="cantidadIngreso" size="7">
                            <f:validator validatorId="validatorDoubleRange"/>
                            <f:attribute name="minimum" value="1"/>
                        </h:inputText>
                       <h:message for="cantidadIngreso" styleClass="message"/>
                    </h:panelGroup>
                    <h:panelGroup>
                        <h:inputText value="#{ManagedProgramaProduccion.ingresosAcond.ingresosDetalleAcondList.get(0).pesoProduccion}" 
                                     styleClass="inputText" onkeypress="valNum(event);"
                                     required="true" requiredMessage="Debe registrar un numero" 
                                     converterMessage="Debe registra un nuevo entero"
                                     size="4" id="pesoIngreso">
                            <f:validator validatorId="validatorDoubleRange"/>
                            <f:attribute name="minimum" value="0.1"/>
                        </h:inputText>
                        <h:message for="pesoIngreso" styleClass="message"/>
                    </h:panelGroup>
                    <h:selectOneMenu value="#{ManagedProgramaProduccion.ingresosAcond.ingresosDetalleAcondList.get(0).cantidadEnvase}" styleClass="inputText" id="cantEnvase">
                       <f:selectItems value="#{ManagedProgramaProduccion.cantidadEnvaseSelectList}"/>
                    </h:selectOneMenu>
                    <h:selectOneMenu value="#{ManagedProgramaProduccion.ingresosAcond.ingresosDetalleAcondList.get(0).tiposEnvase.codTipoEnvase}" styleClass="inputText" id="codTipoEnvase">
                       <f:selectItems value="#{ManagedProgramaProduccion.tiposEnvaseSelectList}"/>
                    </h:selectOneMenu>
                    <a4j:commandLink onclick="javascript:Richfaces.showModalPanel('panelesCantidadesBolsas')" action="#{ManagedProgramaProduccion.cargarDetalleEnvasesAcondicionamiento_action}" reRender="contenidoCantidadesBolsas,contenidoIngresoAcondicionamiento"  >
                       <h:graphicImage url="../img/lotes.png" style="border:none;" alt="Lotes" />
                    </a4j:commandLink>
           </h:panelGrid>

       </h:panelGroup>
       <br/>

            <a4j:commandButton  value="Guardar" styleClass="btn" reRender="contenidoModificarEnvioAcond,contenidoEnviosRealizados" id="guardar"   action="#{ManagedProgramaProduccion.modificarIngresoAcondAction()}"
                            oncomplete="if('#{facesContext.maximumSeverity}'.length == 0){mostrarMensajeTransaccionEvento(function(){Richfaces.hideModalPanel('panelModificarEnvioAcond');})}"
                            timeout="7200" />

            <input type="button" value="Cancelar" class="btn" onclick="Richfaces.hideModalPanel('panelModificarEnvioAcond')" />
       </a4j:form>
   </rich:modalPanel>