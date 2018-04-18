<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>

<rich:modalPanel id="panelImpresionOm" minHeight="450"  minWidth="480"
                height="450" width="480" zindex="200"
                headerClass="headerClassACliente"
                resizeable="false">
    <f:facet name="header">
        <h:outputText value="<center>Emisión de Ordenes de Manufactura</center>" escape="false" />
    </f:facet>
    <a4j:form id="formImpresionOm">
        <h:panelGroup id="contenidoImpresionOm">
            <rich:panel headerClass="headerClassACliente">
                <f:facet name="header">
                    <h:outputText value="Datos del Lote"/>
                </f:facet>
                <center>
                    <h:panelGrid columns="3">
                        <h:outputText value="Programa" styleClass="outputTextBold"/>
                        <h:outputText value="::" styleClass="outputTextBold"/>
                        <h:outputText value="#{ManagedProgramaProduccion.programaProduccionImpresionOm.programaProduccionPeriodo.nombreProgramaProduccion}" styleClass="outputText2"/>
                        <h:outputText value="Lote" styleClass="outputTextBold"/>
                        <h:outputText value="::" styleClass="outputTextBold"/>
                        <h:outputText value="#{ManagedProgramaProduccion.programaProduccionImpresionOm.codLoteProduccion}" styleClass="outputText2"/>
                    </h:panelGrid>
                </center>
            </rich:panel>
            <div style='height:250px;overflow-x:hidden;overflow-y: auto'>
                <rich:dataTable value="#{ManagedProgramaProduccion.programaProduccionImpresionOmList}"
                             var="data" style="width:100%;margin-top:1em" id="dataProgramaProduccionImpresionOm"
                             headerClass="headerClassACliente"
                             onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                             onRowMouseOver="this.style.backgroundColor='#DDE3E4';">
                    <f:facet name="header">
                        <rich:columnGroup>
                            <rich:column>
                                <h:outputText value="Fecha Emisión"/>
                            </rich:column>
                            <rich:column>
                                <h:outputText value="Fecha Entrega"/>
                            </rich:column>
                            <rich:column>
                                <h:outputText value="Estado Impresión"/>
                            </rich:column>
                            <rich:column>
                                <h:outputText value="Ver O.M."/>
                            </rich:column>
                            <rich:column>
                                <h:outputText value="Ver Anexos"/>
                            </rich:column>
                            <rich:column>
                                <h:outputText value="Entregar O.M"/>
                            </rich:column>
                        </rich:columnGroup>
                    </f:facet>
                        <rich:column>
                            <h:outputText value="#{data.fechaEmision}">
                                <f:convertDateTime pattern="dd/MM/yyyy HH:mm"/>
                            </h:outputText>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.fechaEntrega}">
                                <f:convertDateTime pattern="dd/MM/yyyy HH:mm"/>
                            </h:outputText>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.estadosProgramaProduccionImpresionOm.nombreEstadoProgramaProduccionImpresionOm}"/>
                        </rich:column>
                        <rich:column >
                            <a4j:commandLink oncomplete="openPopup('impresionOrdenManufactura.jsf?codLote=#{ManagedProgramaProduccion.programaProduccionImpresionOm.codLoteProduccion}&codProgramaProd=#{ManagedProgramaProduccion.programaProduccionImpresionOm.codProgramaProduccion}&data='+(new Date()).getTime().toString());" rendered="#{data.estadosProgramaProduccionImpresionOm.codEstadoProgramaProduccionImpresionOm eq '3'}">
                                <h:graphicImage url="../img/OM.jpg"  alt="Orden de Manufactura" />
                            </a4j:commandLink>
                        </rich:column>
                        <rich:column >
                            <a4j:commandLink oncomplete="openPopup('impresionAnexosOrdenManufactura.jsf?codLote=#{ManagedProgramaProduccion.programaProduccionImpresionOm.codLoteProduccion}&codProgramaProd=#{ManagedProgramaProduccion.programaProduccionImpresionOm.codProgramaProduccion}&data='+(new Date()).getTime().toString());" rendered="#{data.estadosProgramaProduccionImpresionOm.codEstadoProgramaProduccionImpresionOm eq '3'}">
                                <h:graphicImage url="../img/anexos.jpg"  alt="Orden de Manufactura" />
                            </a4j:commandLink>
                        </rich:column>
                        <rich:column>
                            <a4j:commandButton action="#{ManagedProgramaProduccion.entregarProgramaProduccionImpresionOmAction(data.codProgramaProduccionImpresionOm)}" reRender="dataProgramaProduccion" styleClass="btn" value="Entregar O.M."
                                               rendered="#{data.estadosProgramaProduccionImpresionOm.codEstadoProgramaProduccionImpresionOm eq 3}"
                                                oncomplete="if(#{ManagedProgramaProduccion.mensaje eq '1'})
                                                {alert('Se registro la entrega de la Orden de Manufactura');Richfaces.hideModalPanel('panelImpresionOm');}else{alert('#{ManagedProgramaProduccion.mensaje}')}"/>
                        </rich:column>
                </rich:dataTable>
            </div>
            <center style="margin-top:1em">
            
            <a4j:commandButton action="#{ManagedProgramaProduccion.generarNuevoProgramaProduccionImpresionOm}"
                               reRender="dataProgramaProduccionImpresionOm,dataProgramaProduccion"
                               oncomplete="if(#{ManagedProgramaProduccion.mensaje eq '1'})
                               {alert('Se genero la nueva impresión de Om')}
                               else{alert('#{ManagedProgramaProduccion.mensaje}');}" value="Generar Nueva Om" styleClass="btn"/>
            <a4j:commandButton value="Cancelar" oncomplete="Richfaces.hideModalPanel('panelImpresionOm')" styleClass="btn"/>
            </center>
        </h:panelGroup>    
    </a4j:form>    
</rich:modalPanel>