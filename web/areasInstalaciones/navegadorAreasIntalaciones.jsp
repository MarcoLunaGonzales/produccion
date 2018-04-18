<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>

<f:view>
    
    <html>
        <head>
            <title>Instalaciones COFAR</title>
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
            <script type="text/javascript" src='../js/general.js' ></script> 
           
        </head>
        <body >
            <a4j:form id="form1"  >                
                <div align="center">
                    <span class="outputTextTituloSistema">Instalaciones COFAR</span>
                    <h:outputText value="#{ManagedAreasInstalaciones.cargarAreasInstalaciones}"/>
                    <rich:dataTable value="#{ManagedAreasInstalaciones.areasInstalacionesList}"
                                    var="data" id="dataAreasInstalaciones" 
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#CCDFFA';" 
                                    headerClass="headerClassACliente" 
                                    binding="#{ManagedAreasInstalaciones.areasInstalacionesDataTable}">
                        <f:facet name="header">
                            <rich:columnGroup>
                                <rich:column rowspan="2">
                                    <h:outputText value=""/>
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Código"/>
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Area"/>
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Nombre"/>
                                </rich:column>
                                <rich:column colspan="2">
                                    <h:outputText value="Detalle Modulos"/>
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Módulos"/>
                                </rich:column>
                                <rich:column breakBefore="true">
                                    <h:outputText value="Código"/>
                                </rich:column>
                                <rich:column >
                                    <h:outputText value="Módulo"/>
                                </rich:column>
                            </rich:columnGroup>
                        </f:facet>
                        <rich:subTable value="#{data.areasInstalacionesModuloList}" var="subData" rowKeyVar="key">
                            <rich:column rendered="#{key eq 0}" rowspan="#{data.areasInstalacionesModuloListSize}">
                                <h:selectBooleanCheckbox value="#{data.checked}"  />
                            </rich:column>
                            <rich:column rendered="#{key eq 0}" rowspan="#{data.areasInstalacionesModuloListSize}">
                                <h:outputText value="#{data.codigo}"  />
                            </rich:column>
                            <rich:column rendered="#{key eq 0}" rowspan="#{data.areasInstalacionesModuloListSize}">
                                <h:outputText value="#{data.areasEmpresa.nombreAreaEmpresa}"  />
                            </rich:column>
                            <rich:column rendered="#{key eq 0}" rowspan="#{data.areasInstalacionesModuloListSize}">
                                <h:outputText value="#{data.nombreAreaInstalacion}"  />
                            </rich:column>
                            <rich:column>
                                <h:outputText value="#{subData.codigo}"/>
                            </rich:column>
                            <rich:column>
                                <h:outputText value="#{subData.modulosInstalaciones.nombreModuloInstalacion}"/>
                            </rich:column>
                            <rich:column rendered="#{key eq 0}" rowspan="#{data.areasInstalacionesModuloListSize}">
                                <a4j:commandLink action="#{ManagedAreasInstalaciones.seleccionarAreaInstalacion_action}"
                                                 oncomplete="window.location.href='areasInstalacionesModulos/navegadorAreasInstalacionesModulos.jsf?data='+(new Date()).getTime().toString()">
                                    <h:graphicImage url="../img/modulos.jpg" alt="Modulos"/>
                                </a4j:commandLink>
                            </rich:column>
                            </rich:subTable>
                    </rich:dataTable>
                    
                    <br>
                    <a4j:commandButton value="Agregar" styleClass="btn" oncomplete="window.location.href='agregarAreasInstalaciones.jsf?data='+(new Date()).getTime().toString();"/>
                    <a4j:commandButton value="Editar" styleClass="btn" onclick="if(!editarItem('form1:dataAreasInstalaciones')){return false;}"
                                       action="#{ManagedAreasInstalaciones.editarAreaInstalacion_action}"
                                       oncomplete="wind/ow.location.href='editarAreasInstalaciones.jsf?date='+(new Date()).getTime().toString();"/>
                    <a4j:commandButton value="Eliminar" styleClass="btn" action="#{ManagedAreasInstalaciones.eliminarAreaInstalacion_action}" 
                                       oncomplete="if(#{ManagedAreasInstalaciones.mensaje eq '1'}){alert('Se elimino el area instalación');}else{alert('#{ManagedAreasInstalaciones.mensaje}')}"
                                       onclick="if(!editarItem('form1:dataAreasInstalaciones')){return false;}" reRender="dataAreasInstalaciones"/>
                    
                </div>
                
                
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

