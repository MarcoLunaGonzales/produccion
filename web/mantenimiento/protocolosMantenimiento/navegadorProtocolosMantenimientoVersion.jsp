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
                <h:outputText value="Versiones de Protocolo Mantenimiento" styleClass="outputTextTituloSistema"/>
                <h:outputText value="#{ManagedProtocoloMantenimiento.cargarProtocoloMantenimientoVersionList}"  />
                <rich:panel headerClass="headerClassACliente" style="width:70%">
                    <f:facet name="header">
                        <h:outputText value="Protocolo Mantenimiento"/>
                    </f:facet>
                    <h:panelGrid columns="3">
                        
                        <h:outputText value="Maquinaria" styleClass="outputTextBold"/>
                        <h:outputText value="::" styleClass="outputTextBold"/>
                        <h:outputText value="#{ManagedProtocoloMantenimiento.protocoloMantenimientoBean.protocoloMantenimiento.maquinaria.nombreMaquina}" styleClass="outputText2"/>
                        <h:outputText value="Parte Maquinaria" styleClass="outputTextBold"/>
                        <h:outputText value="::" styleClass="outputTextBold"/>
                        <h:outputText value="#{ManagedProtocoloMantenimiento.protocoloMantenimientoBean.protocoloMantenimiento.partesMaquinaria.nombreParteMaquina}" styleClass="outputText2"/>
                        
                    </h:panelGrid>
                </rich:panel>
                <br>
                <rich:dataTable value="#{ManagedProtocoloMantenimiento.protocoloMantenimientoVersionList}"
                                    var="data" id="dataProtocolosMantenimientoVersion"
                                    binding="#{ManagedProtocoloMantenimiento.protocoloMantenimientoVersionDataTable}"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente">
                        <f:facet name="header">
                            <rich:columnGroup>
                                
                                <rich:column  rowspan="2">
                                    <h:outputText value="Descripción"/>
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Tipo Mantenimiento"/>
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Frecuencia de Mantenimiento"/>
                                </rich:column>
                                <rich:column colspan="2">
                                    <h:outputText value="Realizado por:"/>
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
                                    <h:outputText value="Estado Protocolo"/>
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Nro Versión"/>
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Estado Versión"/>
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Envia Aprobación" escape="false"/>
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Editar<br>Información" escape="false"/>
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Eliminar" escape="false"/>
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Materiales" escape="false"/>
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Tareas" escape="false"/>
                                </rich:column>
                                <rich:column breakBefore="true">
                                    <h:outputText value="MAN.<br>Cofar" escape="false"/>
                                </rich:column>
                                <rich:column >
                                    <h:outputText value="MAN.<br>Externo" escape="false"/>
                                </rich:column>
                            </rich:columnGroup>
                        </f:facet>
                        
                        <rich:column>
                            <h:outputText value="#{data.descripcionProtocoloMantenimientoVersion}"  />
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.tiposMantenimientoMaquinaria.nombreTipoMantenimientoMaquinaria}"  />
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.tiposFrecuenciaMantenimiento.nombreTipoFrecuenciaMantenimiento}"  />
                        </rich:column>
                        <rich:column>
                            <h:selectBooleanCheckbox value="#{data.mantenimientoCofar}" disabled="true"/>
                        </rich:column>
                        <rich:column>
                            <h:selectBooleanCheckbox value="#{data.mantenimientoExterno}" disabled="true"/>
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
                            <h:outputText value="#{data.estadoRegistro.nombreEstadoRegistro}"/>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.nroVersion}"/>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.estadosProtocoloMantenimientoVersion.nombreEstadoProtocoloMantenimientoVersion}"/>
                        </rich:column>
                        <rich:column styleClass="tdCenter">
                            <a4j:commandLink action="#{ManagedProtocoloMantenimiento.enviarAprobacionProtocoloMantenimientoVersion_action}"
                                    reRender="dataProtocolosMantenimientoVersion" rendered="#{data.estadosProtocoloMantenimientoVersion.codEstadoProtocoloMantenimientoVersion eq '1' || data.estadosProtocoloMantenimientoVersion.codEstadoProtocoloMantenimientoVersion eq '3'}"
                                             oncomplete="if(#{ManagedProtocoloMantenimiento.mensaje eq '1'}){alert('Se envio la versión a aprobacion');}else{alert('#{ManagedProtocoloMantenimiento.mensaje}');}">
                                <h:graphicImage url="../../img/go_up.png" style="width:32px;height:32px" alt="editar"/>
                            </a4j:commandLink>
                        </rich:column>
                        <rich:column styleClass="tdCenter">
                            <a4j:commandLink action="#{ManagedProtocoloMantenimiento.seleccionarProtocoloMantenimientoEditar_action}"
                                             reRender="dataProtocolosMantenimientoVersion" rendered="#{data.estadosProtocoloMantenimientoVersion.codEstadoProtocoloMantenimientoVersion eq '1' || data.estadosProtocoloMantenimientoVersion.codEstadoProtocoloMantenimientoVersion eq '3'}"
                                    oncomplete="redireccionar('editarProtocoloMantenimientoVersion.jsf')">
                                <h:graphicImage url="../../img/describir.jpg" alt="editar"/>
                            </a4j:commandLink>
                        </rich:column>
                        <rich:column styleClass="tdCenter">
                            <a4j:commandLink action="#{ManagedProtocoloMantenimiento.eliminarProtocoloMantenimientoVersion_action}"
                                             reRender="dataProtocolosMantenimientoVersion" rendered="#{data.estadosProtocoloMantenimientoVersion.codEstadoProtocoloMantenimientoVersion eq '1' || data.estadosProtocoloMantenimientoVersion.codEstadoProtocoloMantenimientoVersion eq '3'}"
                                             oncomplete="if(#{ManagedProtocoloMantenimiento.mensaje eq '1'}){alert('Se elimino la versión');}else{alert('#{ManagedProtocoloMantenimiento.mensaje}');}">
                                <h:graphicImage url="../../img/eliminar.jpg" alt="Eliminar"/>
                            </a4j:commandLink>
                        </rich:column>
                        <rich:column styleClass="tdCenter">
                            <a4j:commandLink action="#{ManagedProtocoloMantenimiento.seleccionarProtocoloMantenimientoVersionBean_action}"
                                             reRender="dataProtocolosMantenimientoVersion" rendered="#{data.estadosProtocoloMantenimientoVersion.codEstadoProtocoloMantenimientoVersion eq '1' || data.estadosProtocoloMantenimientoVersion.codEstadoProtocoloMantenimientoVersion eq '3'}"
                                    oncomplete="redireccionar('protocoloMantenimientoDetalleMateriales/navegadorProtocolosMantenimientoDetalleMateriales.jsf')">
                                    <h:graphicImage url="../../img/materialMantenimiento.jpg"/>
                            </a4j:commandLink>
                        </rich:column>
                        <rich:column styleClass="tdCenter">
                            <a4j:commandLink action="#{ManagedProtocoloMantenimiento.seleccionarProtocoloMantenimientoVersionBean_action}"
                                             reRender="dataProtocolosMantenimientoVersion" rendered="#{data.estadosProtocoloMantenimientoVersion.codEstadoProtocoloMantenimientoVersion eq '1' || data.estadosProtocoloMantenimientoVersion.codEstadoProtocoloMantenimientoVersion eq '3'}"
                                    oncomplete="redireccionar('protocoloMantenimientoDetalleTareas/navegadorProtocolosMantenimientoDetalleTareas.jsf')">
                                <h:graphicImage url="../../img/tareasMantenimiento.jpg"/>
                            </a4j:commandLink>
                        </rich:column>
                    </rich:dataTable>
                    
                    <br>
                    <a4j:commandButton value="Agregar Nueva Versión" styleClass="btn" action="#{ManagedProtocoloMantenimiento.crearProtocoloMantenimientoVersion_action}" 
                                       oncomplete="if(#{ManagedProtocoloMantenimiento.mensaje eq '1'}){alert('Se registro la nueva versión');}else{alert('#{ManagedProtocoloMantenimiento.mensaje}');}"
                                       reRender="dataProtocolosMantenimientoVersion"/>
                    <a4j:commandButton value="Cancelar" styleClass="btn" 
                                           oncomplete="redireccionar('navegadorProtocolosMantenimiento.jsf');"/>
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

