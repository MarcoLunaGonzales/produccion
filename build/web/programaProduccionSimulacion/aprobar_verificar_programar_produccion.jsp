
<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>

<f:view>
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
            <script type="text/javascript" src="../js/general.js" ></script>
            <script type="text/javascript">
                function recargar(url) {
                    window.location = url;
                }
            </script>
        </head>
        <body >

            <div  align="center" id="panelCenter">
                PRODUCTOS QUE SI SE PUEDEN PRODUCIR
                <a4j:form id="form"  >

                    <rich:dataTable value="#{ManagedProgramaProduccionVerificarProducto.componentesSiSePuedenProducirList}" var="fila" id="componentesSiSePuedenProducir"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente"
                                    binding="#{ManagedProgramaProduccionVerificarProducto.componentesSiSePuedenProducirDataTable}"
                                    rows="40"
                                    >

                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Producto"  />
                            </f:facet>
                            <h:outputText value="#{fila.nombreCompProd}"  />
                        </rich:column>

                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Lote"  />
                            </f:facet>
                            <h:outputText value="#{fila.cantLoteProduccion}"  />
                        </rich:column>

                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Tipo Mercaderia"  />
                            </f:facet>
                            <h:outputText value="#{fila.nombreTipoProgramaProd}"  />
                        </rich:column>

                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Prioridad"  />
                            </f:facet>
                            <h:outputText value="#{fila.categoria}"  />
                        </rich:column>
                        
                         <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Tipo Aprobacion" />
                            </f:facet>
                            <h:outputText value="#{fila.nombreTipoAprobacionProgramaProduccion}"  />
                        </rich:column>

                    </rich:dataTable>

                    <rich:datascroller align="center" for="componentesSiSePuedenProducir" maxPages="20" id="sc2"  />

                    PRODUCTOS QUE NO SE PUEDEN PRODUCIR

                    <rich:dataTable value="#{ManagedProgramaProduccionVerificarProducto.componentesNoSePuedenProducirList }" var="fila" id="componentesNoSePuedenProducir"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente"
                                    binding="#{ManagedProgramaProduccionVerificarProducto.componentesNoSePuedenProducirDataTable}"
                                    rows="40"
                                    >

                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Producto"  />
                            </f:facet>
                            <h:outputText value="#{fila.nombreCompProd}"  />
                        </rich:column>

                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Lote"  />
                            </f:facet>
                            <h:outputText value="#{fila.cantLoteProduccion}"  />
                        </rich:column>

                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Tipo Mercaderia"  />
                            </f:facet>
                            <h:outputText value="#{fila.nombreTipoProgramaProd}"  />
                        </rich:column>

                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Prioridad"  />
                            </f:facet>
                            <h:outputText value="#{fila.categoria}"  />
                        </rich:column>

                    </rich:dataTable>
                    
                    <rich:datascroller align="center" for="componentesNoSePuedenProducir" maxPages="20" id="sc3"  />
                    <br />
                    <h:panelGrid columns="2" styleClass="outputText2">
                    <h:outputText value="fecha de Lote::" />
                    <rich:calendar  id="fechaLote" datePattern="dd/MM/yyyy" value="#{ManagedProgramaProduccionVerificarProducto.fechaLote}"  enableManualInput="false"/>
                    </h:panelGrid>
                    <h:commandButton value="Aceptar" action="#{ManagedProgramaProduccionVerificarProducto.aceptarAprobacion_action}" />
                    <h:commandButton value="Cancelar" action="#{ManagedProgramaProduccionVerificarProducto.cancelarProgramarProduccion_action}" />
                    
                    <%--<h:commandButton value="Cancelar" action="#{ManagedProgramaProduccionVerificarProducto.cancelarAprobacion_action}" />--%>
                </div>

                <h:inputHidden id="mensaje"  binding="#{ManagedProgramaProduccionVerificarProducto.alert}" />
                

            </a4j:form>


        </body>
    </html>

</f:view>

