<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>

<rich:modalPanel id="panelEnviosRealizados"
                    minHeight="380"  minWidth="900"
                    height="380" width="900" zindex="50"
                    headerClass="headerClassACliente"
                    resizeable="false">
       <f:facet name="header">
           <h:outputText value="<center>Envios de producto a acondicionamiento</center>" escape="false"/>
       </f:facet>
       <div align="center">
       <a4j:form id="form2">
       <h:panelGroup id="contenidoEnviosRealizados">
           <rich:panel headerClass="headerClassACliente">
               <f:facet name="header">
                   <h:outputText value="<center>Datos del producto</center>" escape="false"/>
               </f:facet>
               <h:panelGrid columns="6" style="width:100%">
                   <h:outputText value="Producto" styleClass="outputTextBold"/>
                   <h:outputText value="::" styleClass="outputTextBold"/>
                   <h:outputText value="#{ManagedProgramaProduccion.programaProduccionIngresoAcond.formulaMaestra.componentesProd.nombreProdSemiterminado}" styleClass="outputText2"/>
                   <h:outputText value="Lote" styleClass="outputTextBold"/>
                   <h:outputText value="::" styleClass="outputTextBold"/>
                   <h:outputText value="#{ManagedProgramaProduccion.programaProduccionIngresoAcond.codLoteProduccion}" styleClass="outputText2"/>   
                   <h:outputText value="Tipo Producción" styleClass="outputTextBold"/>
                   <h:outputText value="::" styleClass="outputTextBold"/>
                   <h:outputText value="#{ManagedProgramaProduccion.programaProduccionIngresoAcond.tiposProgramaProduccion.nombreTipoProgramaProd}" styleClass="outputText2"/>   
                   <h:outputText value="Tamaño Lote:" styleClass="outputTextBold"/>
                   <h:outputText value="::" styleClass="outputTextBold"/>
                   <h:outputText value="#{ManagedProgramaProduccion.programaProduccionIngresoAcond.cantidadLote}" styleClass="outputText2">   
                       <f:convertNumber pattern="###,###" locale="en"/>
                   </h:outputText>
               </h:panelGrid>
               
           </rich:panel>
           <div style='height:220px;overflow:auto;'>
                <rich:dataTable value="#{ManagedProgramaProduccion.ingresosDetalleAcondRegistradosList}"
                                var="data" style="width:100%"
                             headerClass="headerClassACliente"
                             onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                             onRowMouseOver="this.style.backgroundColor='#DDE3E4';">
                         <f:facet name="header">
                            <rich:columnGroup>
                                <rich:column>
                                    <h:outputText value="Nro Ingreso" />
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Almacen Destino"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Estado"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Fecha Envio" />
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Fecha recepción"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Cantidad" />
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Modificar" />
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Anular" />
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Histórico" />
                                </rich:column>
                            </rich:columnGroup>
                        </f:facet>
                        <rich:column>
                            <h:outputText value="#{data.nroIngresoAcond}"/>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.almacenAcond.nombreAlmacenAcond}"/>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.estadosIngresoAcond.nombreEstadoIngresoAcond}"/>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.fechaIngresoAcond}">
                                <f:convertDateTime pattern="dd/MM/yyyy HH:mm"/>
                            </h:outputText>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.fechaIngresoAcondConfirmado}">
                                <f:convertDateTime pattern="dd/MM/yyyy HH:mm"/>
                            </h:outputText>
                        </rich:column>
                        <rich:column styleClass="tdRight">
                            <h:outputText value="#{data.ingresosDetalleAcondList.get(0).cantIngresoProduccion}">
                                <f:convertNumber pattern="##,###" locale="en"/>
                            </h:outputText>
                        </rich:column>
                        <rich:column>
                            <a4j:commandButton value = "Modificar" styleClass = "btn"
                                               rendered="#{ManagedProgramaProduccion.permisoEditarEnvioAcondicionamiento 
                                                           and data.estadosIngresoAcond.codEstadoIngresoAcond eq 1}"
                                               reRender = "contenidoModificarEnvioAcond"
                                               oncomplete = "Richfaces.showModalPanel('panelModificarEnvioAcond')">
                                <f:setPropertyActionListener value="#{data}" 
                                                             target="#{ManagedProgramaProduccion.ingresosAcond}"/>
                            </a4j:commandButton>
                            <h:outputText value="No cuenta con permiso para realizar modificar de envios" styleClass="outputTextBold"
                                          rendered="#{!ManagedProgramaProduccion.permisoEditarEnvioAcondicionamiento}"
                                          style="color:red"/>
                            <h:outputText value="EL INGRESO YA CUENTA CON MOVIMIENTO EN ACONDICIONAMIENTO" styleClass="outputTextBold"
                                          rendered="#{data.estadosIngresoAcond.codEstadoIngresoAcond ne 1}"
                                          style="color:red"/>
                        </rich:column>
                          <rich:column>
                            <a4j:commandButton value = "Anular" styleClass = "btn"
                                               rendered="#{ManagedProgramaProduccion.permisoAnularEnvioAcondicionamiento 
                                                           and data.estadosIngresoAcond.codEstadoIngresoAcond eq 1}"
                                               reRender = "dataAnularEnvioAcond"
                                               oncomplete = "Richfaces.showModalPanel('panelAnularEnvioAcond')">
                                <f:setPropertyActionListener value="#{data}" 
                                                             target="#{ManagedProgramaProduccion.ingresosAcond}"/>
                            </a4j:commandButton>
                            <h:outputText value="No cuenta con permiso para realizar anulación de envios" styleClass="outputTextBold"
                                          rendered="#{!ManagedProgramaProduccion.permisoAnularEnvioAcondicionamiento}"
                                          style="color:red"/>
                            <h:outputText value="EL INGRESO YA CUENTA CON MOVIMIENTO EN ACONDICIONAMIENTO" styleClass="outputTextBold"
                                          rendered="#{data.estadosIngresoAcond.codEstadoIngresoAcond ne 1}"
                                          style="color:red"/>
                        </rich:column>
                        <rich:column>
                            <a4j:commandButton value="Historico" styleClass="btn"
                                               onclick="abrirVentana('reporteIngresosAcondLog.jsf?codIngresoAcond=#{data.codIngresoAcond}')"/>
                        </rich:column>
                         
                    <f:facet name="footer">
                        <rich:columnGroup>
                            <rich:column colspan="5" styleClass="tdRight">
                                <h:outputText value="Total" styleClass="outputTextBold"/>
                            </rich:column>
                            <rich:column styleClass="tdRight"> 
                                <h:outputText value="#{ManagedProgramaProduccion.ingresosDetalleAcondRegistradosListSumaTotal}"
                                              styleClass="outputTextBold">
                                    <f:convertNumber pattern="##,###" locale="en"/>
                                </h:outputText>
                            </rich:column>
                            <rich:column colspan="3">
                                <h:outputText value=""/>
                            </rich:column>
                        </rich:columnGroup>
                    </f:facet>
                </rich:dataTable>
            </div>
           

        </h:panelGroup>
        <a4j:commandButton value="Cancelar" styleClass="btn" oncomplete="Richfaces.hideModalPanel('panelEnviosRealizados')"/>
   </a4j:form>
</rich:modalPanel>