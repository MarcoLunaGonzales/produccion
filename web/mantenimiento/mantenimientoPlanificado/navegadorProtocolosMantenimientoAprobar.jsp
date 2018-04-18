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
                <h:outputText value="Versiones en Aprobación" styleClass="outputTextTituloSistema"/>
                <h:outputText value="#{ManagedMantenimientoPlanificado.cargarProtocoloMantenimientoVersionAprobacionList}"/>
                
                <br>
                <rich:dataTable value="#{ManagedMantenimientoPlanificado.protocoloMantenimientoVersionAprobarList}"
                                    var="data" id="dataProtocolosMantenimientoVersionAprobar"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente">
                        <f:facet name="header">
                            <rich:columnGroup>
                                <rich:column rowspan="2">
                                    <h:outputText value=""/>
                                </rich:column>
                                <rich:column colspan="2">
                                    <h:outputText value="Maquinaria"/>
                                </rich:column>
                                <rich:column colspan="2">
                                    <h:outputText value="Parte Maquinaria"/>
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Descripción"/>
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
                            </rich:columnGroup>
                        </f:facet>
                        <rich:column>
                            <h:selectBooleanCheckbox value="#{data.checked}"/>
                        </rich:column>
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
                    </rich:dataTable>
                    
                    <br>
                    <a4j:commandButton value="Aprobar" styleClass="btn"
                                       action="#{ManagedMantenimientoPlanificado.aprobarProtocoloMantenimientoVersion_action}"
                                       reRender="dataProtocolosMantenimientoVersionAprobar"
                                       oncomplete="if(#{ManagedMantenimientoPlanificado.mensaje eq '1'}){alert('Se aprobo la versión');}else{alert('#{ManagedMantenimientoPlanificado.mensaje}')}"
                                       />
                    
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

