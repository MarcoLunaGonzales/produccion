<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>
<f:view>
    
    <html>
        <head>
            <title>Protocolos Mantenimiento</title>
            <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
            <script type="text/javascript" src="../../js/general.js" ></script>
        </head>
        <body >
        <a4j:form id="form1">
            <div align="center">
                <h:outputText value="Protocolos Mantenimiento" styleClass="outputTextTituloSistema"/>
                <h:outputText value="#{ManagedProtocoloMantenimiento.cargarProtocolosMantenimientoList}"  />
                <rich:panel headerClass="headerClassACliente" style="width:80%">
                    <f:facet name="header">
                        <h:outputText value="Buscador"/>
                    </f:facet>
                    <h:panelGrid columns="6">
                        <h:outputText value="Maquinaria" styleClass="outputTextBold"/>
                        <h:outputText value="::" styleClass="outputTextBold"/>
                        <h:selectOneMenu value="#{ManagedProtocoloMantenimiento.protocoloMantenimientoVersionBuscar.protocoloMantenimiento.maquinaria.codMaquina}" styleClass="inputText">
                            <f:selectItem itemValue="0" itemLabel="--TODOS--"/>
                            <f:selectItems value="#{ManagedProtocoloMantenimiento.maquinariasSelectList}"/>
                        </h:selectOneMenu>
                        <h:outputText value="Descripción" styleClass="outputTextBold"/>
                        <h:outputText value="::" styleClass="outputTextBold"/>
                        <h:inputText value="#{ManagedProtocoloMantenimiento.protocoloMantenimientoVersionBuscar.descripcionProtocoloMantenimientoVersion}" styleClass="inputText"/>
                        <h:outputText value="Tipo Mantenimiento" styleClass="outputTextBold"/>
                        <h:outputText value="::" styleClass="outputTextBold"/>
                        <h:selectOneMenu value="#{ManagedProtocoloMantenimiento.protocoloMantenimientoVersionBuscar.tiposMantenimientoMaquinaria.codTipoMantenimientoMaquinaria}" styleClass="inputText">
                            <f:selectItem itemValue='0' itemLabel="--TODOS--"/>
                            <f:selectItems value="#{ManagedProtocoloMantenimiento.tiposMantenimientoMaquinariaSelectList}"/>
                        </h:selectOneMenu>
                        <h:outputText value="Frecuencia Mantenimiento" styleClass="outputTextBold"/>
                        <h:outputText value="::" styleClass="outputTextBold"/>
                        <h:selectOneMenu value="#{ManagedProtocoloMantenimiento.protocoloMantenimientoVersionBuscar.tiposFrecuenciaMantenimiento.codTipoFrecuenciaMantenimiento}" styleClass="inputText">
                            <f:selectItem itemValue='0' itemLabel="--TODOS--"/>
                            <f:selectItems value="#{ManagedProtocoloMantenimiento.tiposFrecuenciaMantenimientoSelectList}"/>
                        </h:selectOneMenu>
                    </h:panelGrid>
                    <a4j:commandButton value="BUSCAR" styleClass="btn" reRender="dataProtocolosMantenimiento,controles"
                                       action="#{ManagedProtocoloMantenimiento.buscarProtocoloMantenimientoList_action}"/>
                </rich:panel>
                <br>
                <rich:dataTable value="#{ManagedProtocoloMantenimiento.protocoloMantenimientoList}"
                                    var="data" id="dataProtocolosMantenimiento"
                                    binding="#{ManagedProtocoloMantenimiento.protocoloMantenimientoDataTable}"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente">
                        <f:facet name="header">
                            <rich:columnGroup>
                                <rich:column colspan="2">
                                    <h:outputText value="Maquinaria"/>
                                </rich:column>
                                <rich:column colspan="2">
                                    <h:outputText value="Parte Maquinaria"/>
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Descripción"/>
                                </rich:column>
                                <rich:column colspan="2">
                                    <h:outputText value="Realizado por:"/>
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Tipo Mantenimiento"/>
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Frecuencia de Mantenimiento"/>
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Nro Semana"/>
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Dia Semana"/>
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Poe"/>
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Tiempo"/>
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Estado Versión"/>
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Eliminar"/>
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Versiones"/>
                                </rich:column>
                                <rich:column breakBefore="true">
                                    <h:outputText value="Nombre"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Código"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Nombre"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Código"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="MAN.<br> Cofar" escape="false"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="MAN.<br> Externo" escape="false"/>
                                </rich:column>
                            </rich:columnGroup>
                        </f:facet>
                        <rich:column>
                            <h:outputText value="#{data.protocoloMantenimiento.maquinaria.nombreMaquina}"  />
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.protocoloMantenimiento.maquinaria.codigo}"  />
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.protocoloMantenimiento.partesMaquinaria.nombreParteMaquina}"  />
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.protocoloMantenimiento.partesMaquinaria.codigo}"  />
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.descripcionProtocoloMantenimientoVersion}"  />
                        </rich:column>
                        <rich:column>
                            <h:selectBooleanCheckbox value="#{data.mantenimientoCofar}" disabled="true"/>
                        </rich:column>
                        <rich:column>
                            <h:selectBooleanCheckbox value="#{data.mantenimientoExterno}" disabled="true"/>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.tiposMantenimientoMaquinaria.nombreTipoMantenimientoMaquinaria}"  />
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.tiposFrecuenciaMantenimiento.nombreTipoFrecuenciaMantenimiento}"  />
                        </rich:column>
                        
                        <rich:column>
                            <h:outputText value="#{data.nroSemana}"  rendered="#{data.nroSemana>0}" />
                            <h:outputText value="TODAS LAS SEMANAS"  rendered="#{data.nroSemana eq 0}" />
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.diaSemana.nombreDiaSemana}"  />
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.documentacion.codigoDocumento}"  />
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.cantidadTiempo} #{data.unidadMedidaTiempo.nombreUnidadMedida}"  />
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.estadosProtocoloMantenimientoVersion.nombreEstadoProtocoloMantenimientoVersion}"/>
                        </rich:column>
                        <rich:column styleClass="tdCenter">
                            <a4j:commandLink action="#{ManagedProtocoloMantenimiento.eliminarProtocoloMantenimiento_action}"
                                             reRender="dataProtocolosMantenimiento" rendered="#{data.estadosProtocoloMantenimientoVersion.codEstadoProtocoloMantenimientoVersion!=2}"
                                             oncomplete="if(#{ManagedProtocoloMantenimiento.mensaje eq '1'}){alert('Se elimino el protocolo de mantenimiento');}else{alert('#{ManagedProtocoloMantenimiento.mensaje}');}">
                                <h:graphicImage url="../../img/eliminar.jpg" alt="Eliminar"/>
                            </a4j:commandLink>
                        </rich:column>
                        <rich:column styleClass="tdCenter">
                            <a4j:commandLink action="#{ManagedProtocoloMantenimiento.seleccionarProtocoloMantenimiento_action}"
                                    oncomplete="redireccionar('navegadorProtocolosMantenimientoVersion.jsf')">
                                <h:graphicImage url="../../img/version.png" alt="Versiones"/>
                            </a4j:commandLink>
                        </rich:column>

                    </rich:dataTable>
                    <h:panelGrid columns="2"  width="50" id="controles">
                        <a4j:commandLink  action="#{ManagedSolicitudMantenimiento.atrasSolicitudesMantenimientoList_action}" reRender="dataProtocolosMantenimiento,controles"  rendered="#{ManagedSolicitudMantenimiento.begin>'1'}" >
                            <h:graphicImage url="../../img/previous.gif"  style="border:0px solid red"   alt="PAGINA ANTERIOR"  />
                        </a4j:commandLink>
                        <a4j:commandLink  action="#{ManagedSolicitudMantenimiento.siguienteSolicitudesMantenimientoList_action}" reRender="dataProtocolosMantenimiento,controles" rendered="#{ManagedSolicitudMantenimiento.cantidadfilas>=ManagedSolicitudMantenimiento.numrows}">
                            <h:graphicImage url="../../img/next.gif"  style="border:0px solid red"  alt="PAGINA SIGUIENTE" />
                        </a4j:commandLink>
                    </h:panelGrid>
                    <br>
                    <a4j:commandButton value="Agregar Protocolo Mantenimiento" styleClass="btn" 
                                           oncomplete="window.location.href='agregarProtocoloMantenimiento.jsf?data='+(new Date()).getTime().toString()"/>
                </div>
            </a4j:form>
            <a4j:status id="statusPeticion"
                        onstart="Richfaces.showModalPanel('ajaxLoadingModalBox',{width:100, top:100})"
                        onstop="Richfaces.hideModalPanel('ajaxLoadingModalBox')">
            </a4j:status>

            <rich:modalPanel id="ajaxLoadingModalBox" minHeight="100"
                             minWidth="200" height="80" width="400" zindex="100" onshow="window.focus();">

                <div align="center">
                    <h:graphicImage value="../../img/load2.gif" />
                </div>
            </rich:modalPanel>
            
        </body>
    </html>
    
</f:view>

