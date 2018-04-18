
<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>
<f:view>

    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
            <script type="text/javascript" src="../js/general.js" ></script>
            
        </head>
            <a4j:form id="form1" >
                <center>

                    <h:outputText value="#{ManagedProgramaProduccionSolicitudCompra.cargarProgramaProduccionPeriodoSolicitudCompraList}"  />
                    <rich:panel headerClass="headerClassACliente" style="width:80%">
                        <f:facet name="header">
                            <h:outputText value="Datos Solicitud Compra"/>
                        </f:facet>
                        <h:panelGrid columns="3">
                            <h:outputText value="Programa Producción Simulación" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:outputText value="#{ManagedProgramaProduccionSolicitudCompra.programaProduccionPeriodoBean.nombreProgramaProduccion}" styleClass="outputText2"/>
                            <h:outputText value="Observación" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:outputText value="#{ManagedProgramaProduccionSolicitudCompra.programaProduccionPeriodoBean.obsProgramaProduccion}" styleClass="outputText2"/>
                            
                        </h:panelGrid>
                    </rich:panel>
                        <rich:dataTable value="#{ManagedProgramaProduccionSolicitudCompra.programaProduccionPeriodoSolicitudCompraList}"
                                    var="data" id="dataProgramaSolicitudCompra"
                                    binding="#{ManagedProgramaProduccionSolicitudCompra.programaProduccionPeriodoSolicitudCompraDataTable}"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    style="margin-top:1em" rowKeyVar="row"
                                    headerClass="headerClassACliente" >
                        <f:facet name="header">
                            <rich:columnGroup>
                                <rich:column rowspan="2">
                                    <h:outputText value="Número Solicitud"/>
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Proveedor"/>
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Fecha Solicitud"/>
                                </rich:column>
                                <rich:column colspan="8">
                                    <h:outputText value="Cantidad Items Por Solicitud y Por Estado"/>
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Detalle"/>
                                </rich:column>
                                <rich:column breakBefore="true">
                                    <h:outputText value="Sin Estado"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Descartado"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="En<br>Cotización" escape="false"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="O.C.<br>GENERADA<br>PARCIALMENTE" escape="false"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="O.C.<br>GENERADA<br> TOTALMENTE" escape="false"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Con O.C." escape="false"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Comite" escape="false"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Rechazado<br>G.I" escape="false"/>
                                </rich:column>
                            </rich:columnGroup>
                        </f:facet>
                            <rich:column>
                                <h:outputText value="#{data.numeroSolicitud}"/>
                            </rich:column>
                            <rich:column>
                                <h:outputText value="#{data.proveedores.nombreProveedor}"/>
                            </rich:column>
                            <rich:column>
                                <h:outputText value="#{data.fechaRegistro}">
                                    <f:convertDateTime pattern="dd/MM/yyyy"/>
                                </h:outputText>
                            </rich:column>
                            <rich:column>
                                <h:outputText value="#{data.cantSinEstado}"/>
                            </rich:column>
                            <rich:column>
                                <h:outputText value="#{data.cantDescartado}"/>
                            </rich:column>
                            <rich:column>
                                <h:outputText value="#{data.cantCotizacion}"/>
                            </rich:column>
                            <rich:column>
                                <h:outputText value="#{data.cantParcial}"/>
                            </rich:column>
                            <rich:column>
                                <h:outputText value="#{data.cantTotal}"/>
                            </rich:column>
                            <rich:column>
                                <h:outputText value="#{data.cantConOc}"/>
                            </rich:column>
                            <rich:column>
                                <h:outputText value="#{data.cantComite}"/>
                            </rich:column>
                            <rich:column>
                                <h:outputText value="#{data.cantRechazadoGI}"/>
                            </rich:column>
                            <rich:column>
                                <a4j:commandLink  action="#{ManagedProgramaProduccionSolicitudCompra.seleccionarProgramaProduccionPeriodoSolicitudCompra_action}"
                                                  oncomplete="window.location.href='navegadorProgramaProduccionPeriodoSolicitudCompraDetalle.jsf?data='+(new Date()).getTime().toString();">
                                        <h:graphicImage url="/img/documentacionAplicada.jpg"/>
                                </a4j:commandLink>
                            </rich:column>
                    </rich:dataTable>
                    <div id="bottonesAcccion" class="barraBotones">
                        <a4j:commandButton value="Cancelar" oncomplete="window.location.href='navegadorProgramaProduccionPeriodo.jsf'" styleClass="btn"/>
                    </div>
                    </center>
            </a4j:form>
            
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

