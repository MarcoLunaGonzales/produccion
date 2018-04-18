
<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>
<f:view>

    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
            <script type="text/javascript" src="../../js/general.js" ></script>
        </head>
            <a4j:form id="form1" >
                <center>

                    <h:outputText value="#{ManagedProgramaProduccionDesarrolloVersion.cargarProgramaProduccionPeriodoDesarrollo}"  />
                    <h:outputText value="Programa Desarrollo" styleClass="outputTextTituloSistema" />
                    
                    <rich:dataTable value="#{ManagedProgramaProduccionDesarrolloVersion.programaProduccionPeriodoDesarrolloList}" var="data" id="dataProgramaPeriodo"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    style="margin-top:1em"
                                    headerClass="headerClassACliente" binding="#{ManagedProgramaProduccionDesarrolloVersion.programaProduccionPeriodoDesarrolloDataTable}">
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value=""  />
                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.checked}"/>
                        </rich:column >

                        <rich:column  >
                            <f:facet name="header">
                                <h:outputText value="Programa Desarrollo"  />
                            </f:facet>
                            <a4j:commandLink action="#{ManagedProgramaProduccionDesarrolloVersion.seleccionarProgramaProducccionPeriodoDesarrollo_action}"
                            oncomplete="redireccionar('navegadorProgramaProduccionDesarrollo.jsf');">
                                <h:graphicImage url="../../img/h2bg.gif" style="margin-top:3px;"/>
                                <h:outputText value="#{data.nombreProgramaProduccion}" style="margin-left:0.5em" />
                            </a4j:commandLink>
                            
                        </rich:column>
                        <rich:column  >
                            <f:facet name="header">
                                <h:outputText value="Observaciones"  />
                            </f:facet>
                            <h:outputText value="#{data.obsProgramaProduccion}"  />
                        </rich:column>
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value="Estado"  />
                            </f:facet>
                            <h:outputText value="#{data.estadoProgramaProduccion.nombreEstadoProgramaProd}"  />
                        </rich:column >
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value="Fecha Inicio"  />
                            </f:facet>
                            <h:outputText value="#{data.fechaInicio}">
                                <f:convertDateTime pattern="dd/MM/yyyy"/>
                            </h:outputText>
                        </rich:column >
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value="Fecha Final"  />
                            </f:facet>
                            <h:outputText value="#{data.fechaFinal}">
                                <f:convertDateTime pattern="dd/MM/yyyy"/>
                            </h:outputText>
                        </rich:column >

                    </rich:dataTable>
                    <div style="margin-top:1em">
                        <rich:panel>
                            <a4j:commandButton value="Agregar"  oncomplete="redireccionar('agregarProgramaPeriodoDesarrollo.jsf')"  styleClass="btn"/>
                            <a4j:commandButton value="Modificar"  oncomplete="redireccionar('editarProgramaPeriodoDesarrollo.jsf')"  styleClass="btn"
                            onclick="if(!editarItem('form1:dataProgramaPeriodo')){return false;}"
                            action="#{ManagedProgramaProduccionDesarrolloVersion.editarProgramaPeriodoDesarrollo_action}"/>
                            <a4j:commandButton value="Eliminar" styleClass="btn" action="#{ManagedProgramaProduccionDesarrolloVersion.eliminarProgramaPeriodoDesarrollo_action}" reRender="dataProgramaPeriodo"
                                               oncomplete="if(#{ManagedProgramaProduccionDesarrolloVersion.mensaje eq '1'}){alert('Se elimino el programa producción periodo');}else{alert('#{ManagedProgramaProduccionDesarrolloVersion.mensaje}')}"/>
                        </rich:panel>
                    </div>
                    </center>
            </a4j:form>
            <rich:modalPanel id="PanelBuscarCertificado" minHeight="140"  minWidth="300"
                                     height="140" width="300"
                                     zindex="4"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Buscar Lote"/>
                        </f:facet>
                        <a4j:form id="formRegistrar">
                        <h:panelGroup id="contenidoBuscarCertificado">
                            <div align="center">
                            <h:panelGrid columns="3">
                                <h:outputText value="Lote" styleClass="outputText2" style="font-weight:bold" />
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold" />
                                <h:inputText value="#{ManagedProgramaProduccion.programaProduccionFiltro.codLoteProduccion}" styleClass="inputText"  />
                                

                            </h:panelGrid>
                                
                                    <a4j:commandButton styleClass="btn" action="#{ManagedProgramaProduccion.buscarLoteProgramaProduccion_action}" value="Buscar" oncomplete="window.location.href='navegadorProgramaProduccion.jsf?per='+(new Date()).getTime().toString();"/>
                                <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('PanelBuscarCertificado')" class="btn" />
                                </div>
                        </h:panelGroup>
                        </a4j:form>
            </rich:modalPanel>
         <a4j:status id="statusPeticion"
                        onstart="Richfaces.showModalPanel('ajaxLoadingModalBox',{width:100, top:100})"
                        onstop="Richfaces.hideModalPanel('ajaxLoadingModalBox')">
            </a4j:status>

            <rich:modalPanel id="ajaxLoadingModalBox" minHeight="100"
                             minWidth="200" height="80" width="400" zindex="100" onshow="window.focus();">

                <div align="center">
                    <h:graphicImage value="../img/load2.gif" />
                </div>
            </rich:modalPanel>

        </body>
    </html>

</f:view>

