<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<rich:modalPanel id="panelIngresoAcondicionamiento"
                    minHeight="470"  minWidth="900"
                    height="470" width="900" zindex="200"
                    headerClass="headerClassACliente"
                    resizeable="false">
       <f:facet name="header">
           <h:outputText value="Ingreso Acondicionamiento" />
       </f:facet>
       <div align="center">
       <a4j:form id="form2">
       <h:panelGroup id="contenidoIngresoAcondicionamiento">
           <div style='width:50%;height:10em;overflow:auto;'>
                <rich:dataTable value="#{ManagedProgramaProduccion.ingresosDetalleAcondRegistradosList}"
                                var="data" style="width:100%"
                             headerClass="headerClassACliente"
                             onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                             onRowMouseOver="this.style.backgroundColor='#DDE3E4';">
                         <f:facet name="header">
                            <rich:columnGroup>
                                <rich:column colspan="3">
                                    <h:outputText value="Envios Anteriores" />
                                </rich:column>
                                <rich:column breakBefore="true">
                                    <h:outputText value="Nro Ingreso" />
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Fecha Envio" />
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Cantidad" />
                                </rich:column>
                            </rich:columnGroup>
                        </f:facet>
                        <rich:column>
                            <h:outputText value="#{data.nroIngresoAcond}"/>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.fechaIngresoAcond}">
                                <f:convertDateTime pattern="dd/MM/yyyy HH:mm"/>
                            </h:outputText>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.ingresosDetalleAcondList.get(0).cantIngresoProduccion}"/>
                        </rich:column>
                 </rich:dataTable>
            </div>
           <h:panelGrid columns="4">

           <h:outputText styleClass="outputTextBold"   value="Almacen:"  />
           <h:selectOneMenu styleClass="inputText"  value="#{ManagedProgramaProduccion.ingresosAcond.almacenAcond.codAlmacenAcond}"   id="codAlmacenAcondicionamiento" >
               <f:selectItems value="#{ManagedProgramaProduccion.almacenAcondicionamientoList}"  />
           </h:selectOneMenu>



           <h:outputText value="Estado:" styleClass="outputTextBold"  />
           <h:outputText value="A CONFIRMAR"  styleClass="tituloCampo"/>
           <h:outputText value="Entrega Total:" styleClass="outputTextBold"  />
           <h:selectOneRadio value="#{ManagedProgramaProduccion.ingresosAcond.programaProduccionIngresoAcond.tiposEntregaAcond.codTipoEntregaAcond}" id="entregaTotal" styleClass="outputText2">
               <f:selectItem itemLabel="SI" itemValue='2'/>
               <f:selectItem itemLabel="NO" itemValue='1'/>
           </h:selectOneRadio>
           <h:outputText value="Tipo de Ingreso:" styleClass="outputTextBold" />
           <h:outputText styleClass="tituloCampo" value="#{ManagedProgramaProduccion.ingresosAcond.tipoIngresoAcond.nombreTipoIngresoAcond}"  />
           <h:outputText value="Observaciones:" styleClass="outputTextBold" />
           <h:inputTextarea styleClass="inputText"  cols="50" value="#{ManagedProgramaProduccion.ingresosAcond.obsIngresoAcond}"   />

           </h:panelGrid>
           <h:panelGrid  cellpadding="0" cellspacing="0" columns="11" rowClasses="headerClassACliente linea,classDetalle">
                   <h:outputText value="Producto"/>
                    <h:outputText value="Lote"  />
                    <h:outputText value="Fecha Pesaje." />
                    <h:outputText value="Vida Util" />
                    <h:outputText value="Fecha Vencimiento" />
                    <h:outputText value="Cant. de Ingreso" />
                    <h:outputText value="Peso [Kg.]" />
                    <h:outputText value="Cant. Referencial" />
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
                   <h:outputText value="Sin Fecha" styleClass="outputText2" style="color:red;font-size:14px"
                   rendered="#{ManagedProgramaProduccion.ingresosAcond.ingresosDetalleAcondList.get(0).componentesProd.forma.codForma !='2'&&
                              ManagedProgramaProduccion.ingresosAcond.ingresosDetalleAcondList.get(0).fechaPesaje==null}"/>
                  <h:outputText value="No necesario" styleClass="outputText2"
                   rendered="#{ManagedProgramaProduccion.ingresosAcond.ingresosDetalleAcondList.get(0).componentesProd.forma.codForma eq '2'}"/>
                   <h:outputText value="#{ManagedProgramaProduccion.ingresosAcond.ingresosDetalleAcondList.get(0).componentesProd.vidaUtil}" styleClass="outputText2"/>
                   <h:outputText value="#{ManagedProgramaProduccion.ingresosAcond.ingresosDetalleAcondList.get(0).fechaVencimiento}" styleClass="outputText2">
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
                   <h:outputText value="#{ManagedProgramaProduccion.ingresosAcond.ingresosDetalleAcondList.get(0).cantidadAproximado}" styleClass="outputText2" />
                   <h:selectOneMenu value="#{ManagedProgramaProduccion.ingresosAcond.ingresosDetalleAcondList.get(0).cantidadEnvase}" styleClass="inputText" id="cantEnvase">
                       <f:selectItems value="#{ManagedProgramaProduccion.cantidadEnvaseSelectList}"/>
                   </h:selectOneMenu>
                   <h:selectOneMenu value="#{ManagedProgramaProduccion.ingresosAcond.ingresosDetalleAcondList.get(0).tiposEnvase.codTipoEnvase}" styleClass="inputText" id="codTipoEnvase">
                       <f:selectItems value="#{ManagedProgramaProduccion.tiposEnvaseSelectList}"/>
                   </h:selectOneMenu>
                   <a4j:commandLink oncomplete="if('#{facesContext.maximumSeverity}'.length == 0){Richfaces.showModalPanel('panelesCantidadesBolsas')}" 
                                    action="#{ManagedProgramaProduccion.cargarDetalleEnvasesAcondicionamiento_action}" 
                                    reRender="contenidoCantidadesBolsas,contenidoIngresoAcondicionamiento"  >
                       <h:graphicImage url="../img/lotes.png" style="border:none;" alt="Lotes" />
                   </a4j:commandLink>
           </h:panelGrid>

       </h:panelGroup>
       <br/>

       <a4j:jsFunction name="agregarDevolucion" action="#{ManagedProgramaProduccion.cargarRegistroDevolucionesAction}" oncomplete="javascript:Richfaces.showModalPanel('panelRegistroDevoluciones')" reRender="contenidoRegistroDevoluciones"/>
       <a4j:jsFunction name="reRenderPrograma" reRender="contenidoProgramaProduccion"/>
       <%--final ale unidades medida--%>
       <h:panelGrid columns="3" id="buttonEnvio">
        <a4j:commandButton  value="Guardar" styleClass="btn" reRender="contenidoIngresoAcondicionamiento" id="guardar"   action="#{ManagedProgramaProduccion.guardarIngresoAcond_action()}"
                            oncomplete="if('#{facesContext.maximumSeverity}'.length == 0){mostrarMensajeTransaccionEvento(function(){reRenderPrograma();Richfaces.hideModalPanel('panelIngresoAcondicionamiento:panelIngresoAcondicionamiento');})}" timeout="7200" />

       <input type="button" value="Cancelar" class="btn" onclick="Richfaces.hideModalPanel('panelIngresoAcondicionamiento:panelIngresoAcondicionamiento')" />
       </h:panelGrid>
       <div style="display:none" id="progress">
           <img src="../img/load.gif"/>
       </div>
       </div>
       </a4j:form>
   </rich:modalPanel>