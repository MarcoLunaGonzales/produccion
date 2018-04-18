<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>
    <html>
        <head>
            <title>Programa Periodo</title>
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
            <script type="text/javascript" src="../js/general.js" ></script>
        </head>
        <body>
            <a4j:form id="form1" >
                <center>
                <div align="center">
                    <h:outputText value="#{ManagedProgramaProduccion.cargarProgramaProduccionPeriodo}"  />
                    <h:outputText value="Programa Produccion Periodo" styleClass="outputTextBold" style="font-size:14px;"/>
                    <br/>
                    <a4j:commandButton  oncomplete="Richfaces.showModalPanel('PanelBuscarCertificado')" image="../img/buscar.png" alt="Buscar Certificado"/>

                    <rich:dataTable value="#{ManagedProgramaProduccion.programaProduccionPeriodoList}" var="data" id="dataProgramaPeriodo"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    style="margin-top:1em"
                                    headerClass="headerClassACliente">
                        <f:facet name="header">
                            <rich:columnGroup>
                                <rich:column rendered="#{ManagedProgramaProduccion.permisoGeneracionLotes}">
                                    <h:outputText value=""/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Programa Produccion"  />
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Observaciones"  />
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Estado"  />
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Fecha Inicio"  />
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Fecha Final"  />
                                </rich:column>
                                
                            </rich:columnGroup>
                        </f:facet>
                        <rich:column rendered="#{ManagedProgramaProduccion.permisoGeneracionLotes}">
                            <h:selectBooleanCheckbox value="#{data.checked}"/>
                        </rich:column>
                        <rich:column>
                            <a4j:commandLink action="#{ManagedProgramaProduccion.seleccionarProgramaProducccionPeriodo_action}"
                            oncomplete="window.location.href='navegadorProgramaProduccion.jsf?per='+(new Date()).getTime().toString();">
                                <h:graphicImage url="../img/h2bg.gif" style="margin-top:3px;"/>
                                <f:setPropertyActionListener value="#{data}" target="#{ManagedProgramaProduccion.programaProduccionPeriodoBean}"/>
                                <h:outputText value="#{data.nombreProgramaProduccion}" style="margin-left:0.5em" />
                            </a4j:commandLink>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.obsProgramaProduccion}"  />
                        </rich:column>
                        <rich:column >
                            <h:outputText value="#{data.estadoProgramaProduccion.nombreEstadoProgramaProd}"  />
                        </rich:column >
                        <rich:column >
                            <h:outputText value="#{data.fechaInicio}">
                                <f:convertDateTime pattern="dd/MM/yyyy"/>
                            </h:outputText>
                        </rich:column >
                        <rich:column >
                            <h:outputText value="#{data.fechaFinal}">
                                <f:convertDateTime pattern="dd/MM/yyyy"/>
                            </h:outputText>
                        </rich:column >

                    </rich:dataTable>
                    <br/>
                        <rich:panel rendered="#{ManagedProgramaProduccion.permisoGeneracionLotes}">
                            <a4j:commandButton value="Agregar"  oncomplete="window.location.href='agregarProgramaProduccionPeriodo.jsf?data='+(new Date()).getTime().toString();"  styleClass="btn"/>
                            <a4j:commandButton value="Modificar"  oncomplete="window.location.href='editarProgramaProduccionPeriodo.jsf?data='+(new Date()).getTime().toString();"  styleClass="btn"
                            onclick="if(!editarItem('form1:dataProgramaPeriodo')){return false;}"
                            action="#{ManagedProgramaProduccion.editarProgramaProduccionPeriodo_action}"/>
                            <a4j:commandButton value="Eliminar" styleClass="btn" action="#{ManagedProgramaProduccion.eliminarProgramaProduccionPeriodo_action}" reRender="dataProgramaPeriodo"
                            oncomplete="if(#{ManagedProgramaProduccion.mensaje eq '1'}){alert('Se elimino el programa producción periodo');}else{alert('#{ManagedProgramaProduccion.mensaje}')}"/>
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
