
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
                    <span class="outputTextTituloSistema">Simulaciones de Programa de Producción con Solicitud de O.C.</span>
                    <h:outputText value="#{ManagedProgramaProduccionSolicitudCompra.cargarProgramaProduccionPeriodoList}"  />
                    <rich:dataTable value="#{ManagedProgramaProduccionSolicitudCompra.programaProduccionPeriodoList}" var="data" id="dataProgramaPeriodo"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    style="margin-top:1em"
                                    headerClass="headerClassACliente" binding="#{ManagedProgramaProduccionSolicitudCompra.programaProduccionPeriodoDataTable}">
                        <f:facet name="header">
                            <rich:columnGroup>
                                <rich:column>
                                    <h:outputText value="Programa Producción"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Observación"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Cantidad Solicitudes Generadas"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Detalle Solicitudes"/>
                                </rich:column>
                            </rich:columnGroup>
                        </f:facet>
                            <rich:column>
                                <h:outputText value="#{data.nombreProgramaProduccion}"/>
                            </rich:column>
                            <rich:column>
                                <h:outputText value="#{data.obsProgramaProduccion}"/>
                            </rich:column>
                            <rich:column>
                                <h:outputText value="#{data.cantProgramaProduccionPeriodoSolicitudCompra}"/>
                            </rich:column>
                            <rich:column>
                                <a4j:commandLink action="#{ManagedProgramaProduccionSolicitudCompra.seleccionarProgramaProduccionPeriodo_action}"
                                                 oncomplete="window.location.href='navegadorProgramaProduccionSolicitudesCompras.jsf?data='+(new Date()).getTime().toString()">
                                        <h:graphicImage url="/img/documentacionAplicada.jpg"/>
                                </a4j:commandLink>
                            </rich:column>
                        

                    </rich:dataTable>
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

