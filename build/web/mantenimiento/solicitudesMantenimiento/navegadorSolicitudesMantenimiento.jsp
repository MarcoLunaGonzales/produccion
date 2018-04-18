<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>
    
    <html>
        <head>
            <title>Solicitudes Mantenimiento</title>
            <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
            <script type="text/javascript" src="../../js/general.js" ></script>
        </head>
        <body >
            <a4j:form id="form1">
                <div align="center">
                    <span class="outputTextTituloSistema">Solicitudes de Mantenimiento</span>
                    <h:outputText value="#{ManagedSolicitudMantenimiento.cargarSolicitudesMantenimiento}"  />
                    <rich:panel headerClass="headerClassACliente" style="width:80%">
                        <f:facet name="header">
                            <h:outputText value="Buscador"/>
                        </f:facet>
                        <h:panelGrid columns="6">
                            <h:outputText value="Nro. de Solicitud" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:inputText value="#{ManagedSolicitudMantenimiento.solicitudMantenimientoBuscar.codSolicitudMantenimiento}" styleClass="inputText" onblur="valorPorDefecto(this);"/>
                            <h:outputText value="Nro. de O.T." styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:inputText value="#{ManagedSolicitudMantenimiento.solicitudMantenimientoBuscar.nroOrdenTrabajo}" styleClass="inputText" onblur="valorPorDefecto(this);"/>
                            <h:outputText value="Area Empresa" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectOneMenu value="#{ManagedSolicitudMantenimiento.solicitudMantenimientoBuscar.areasEmpresa.codAreaEmpresa}" styleClass="inputText">
                                <f:selectItem itemValue="0" itemLabel="--TODOS--"/>
                                <f:selectItems value="#{ManagedSolicitudMantenimiento.areasEmpresaSelectList}"/>
                            </h:selectOneMenu>
                            <h:outputText value="Prioridad" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectOneMenu value="#{ManagedSolicitudMantenimiento.solicitudMantenimientoBuscar.tiposNivelSolicitudMantenimiento.codTipoNivelSolicitudMantenimiento}" styleClass="inputText">
                                <f:selectItem itemValue='0' itemLabel="--TODOS--"/>
                                <f:selectItems value="#{ManagedSolicitudMantenimiento.tiposNivelSolicitudMantenimientoSelectList}"/>
                            </h:selectOneMenu>
                            <h:outputText value="Tipo Solicitud" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectOneMenu value="#{ManagedSolicitudMantenimiento.solicitudMantenimientoBuscar.tiposSolicitudMantenimiento.codTipoSolicitud}" styleClass="inputText">
                                <f:selectItem itemValue='0' itemLabel="--TODOS--"/>
                                <f:selectItems value="#{ManagedSolicitudMantenimiento.tiposSolicitudMantenimientoSelectList}"/>
                            </h:selectOneMenu>
                            <h:outputText value="Estado Solicitud" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectOneMenu value="#{ManagedSolicitudMantenimiento.solicitudMantenimientoBuscar.estadoSolicitudMantenimiento.codEstadoSolicitudMantenimiento}" styleClass="inputText">
                                <f:selectItem itemValue='0' itemLabel="--TODOS--"/>
                                <f:selectItems value="#{ManagedSolicitudMantenimiento.estadosSolicitudMantenimientoSelectList}"/>
                            </h:selectOneMenu>
                            <h:outputText value="Cantidad Registros" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectOneMenu value="#{ManagedSolicitudMantenimiento.numrows}" styleClass="inputText">
                                <f:selectItem itemValue='10' itemLabel="10"/>
                                <f:selectItem itemValue='20' itemLabel="20"/>
                                <f:selectItem itemValue='30' itemLabel="30"/>
                                <f:selectItem itemValue='40' itemLabel="40"/>
                                <f:selectItem itemValue='50' itemLabel="50"/>
                            </h:selectOneMenu>
                        </h:panelGrid>
                        <a4j:commandButton value="BUSCAR" styleClass="btn" reRender="dataSolicitudMantenimiento,controles"
                                           action="#{ManagedSolicitudMantenimiento.buscarSolicitudMantenimiento_action}"/>
                    </rich:panel>
                    <br>
                        <rich:dataTable value="#{ManagedSolicitudMantenimiento.solicitudMantenimientoList}"
                                        var="data" id="dataSolicitudMantenimiento"
                                        onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                        onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                        headerClass="headerClassACliente">
                            <f:facet name="header">
                                <rich:columnGroup>
                                    <rich:column>
                                        <h:outputText value=""/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Nro Solicitud"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Nro O.T."/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Fecha Emisión"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Area Empresa"/>
                                    </rich:column>

                                    <rich:column>
                                        <h:outputText value="Maquinaria"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Instalación"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Afecta Producción"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Descripción"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Estado Solicitud"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Tipo Solicitud"/>
                                    </rich:column>
                                </rich:columnGroup>
                            </f:facet>
                            <rich:column  >
                                <h:selectBooleanCheckbox value="#{data.checked}" rendered="#{data.estadoSolicitudMantenimiento.codEstadoSolicitudMantenimiento=='1' ||data.estadoSolicitudMantenimiento.codEstadoSolicitudMantenimiento=='4'}"  />
                            </rich:column >
                            <rich:column  >
                                <h:outputText value="#{data.codSolicitudMantenimiento}"  />
                            </rich:column >
                            <rich:column  >
                                <h:outputText value="#{data.nroOrdenTrabajo}" rendered="#{data.nroOrdenTrabajo>'0'}" />
                                <h:outputText  rendered="#{data.solicitudProyecto eq '1' && data.nroOrdenTrabajo>'0'}" value="-PROY"  />
                                <h:outputText  rendered="#{data.solicitudProduccion eq '1' && data.nroOrdenTrabajo>'0'}" value="-PROD"  />
                            </rich:column >
                            <rich:column  >
                                <h:outputText value="#{data.fechaSolicitudMantenimiento}"  >
                                    <f:convertDateTime pattern="dd/MM/yyyy HH:mm:ss" />
                                </h:outputText>
                            </rich:column >
                            <rich:column >
                                <h:outputText value="#{data.areasEmpresa.nombreAreaEmpresa}" />
                            </rich:column >

                            <rich:column  >
                                <h:outputText value="#{data.maquinaria.nombreMaquina}"  />
                            </rich:column >
                            <rich:column>
                                <h:outputText value="#{data.areasInstalaciones.nombreAreaInstalacion}"/>
                            </rich:column>

                            <rich:column style ="#{data.afectaraProduccion==1?'background-color:#F5A9A9':''}" >
                                <h:outputText value="SI" rendered="#{data.afectaraProduccion==1}"   />
                                <h:outputText value="NO" rendered="#{data.afectaraProduccion==0}" />
                            </rich:column >
                            <rich:column >
                                <h:outputText value="#{data.obsSolicitudMantenimiento}" />
                            </rich:column >
                            <rich:column style="background-color : #F2F5A9"  >
                                <h:outputText value="#{data.estadoSolicitudMantenimiento.nombreEstadoSolicitudMantenimiento}"  />
                            </rich:column >
                            <rich:column>
                                <h:outputText value="#{data.tiposSolicitudMantenimiento.nombreTipoSolicitud}"  />
                            </rich:column >

                        </rich:dataTable>
                        <h:panelGrid columns="2"  width="50" id="controles">
                            <a4j:commandLink  action="#{ManagedSolicitudMantenimiento.atrasSolicitudesMantenimientoList_action}" reRender="dataSolicitudMantenimiento,controles"  rendered="#{ManagedSolicitudMantenimiento.begin>'1'}" >
                                <h:graphicImage url="../../img/previous.gif"  style="border:0px solid red"   alt="PAGINA ANTERIOR"  />
                            </a4j:commandLink>
                            <a4j:commandLink  action="#{ManagedSolicitudMantenimiento.siguienteSolicitudesMantenimientoList_action}" reRender="dataSolicitudMantenimiento,controles" rendered="#{ManagedSolicitudMantenimiento.cantidadfilas>=ManagedSolicitudMantenimiento.numrows}">
                                <h:graphicImage url="../../img/next.gif"  style="border:0px solid red"  alt="PAGINA SIGUIENTE" />
                            </a4j:commandLink>
                        </h:panelGrid>
                        <br>
                        <a4j:commandButton value="Agregar" styleClass="btn" 
                                               oncomplete="window.location.href='agregarSolicitudMantenimiento.jsf?data='+(new Date()).getTime().toString()"/>
                        <a4j:commandButton value="Editar" styleClass="btn"
                                           onclick="if(!editarItem('form1:dataSolicitudMantenimiento')){return false;}"
                                           action="#{ManagedSolicitudMantenimiento.editarSolicitudMantenimiento_action}"
                                           oncomplete="window.location.href='editarSolicitudMantenimiento.jsf?edit='+(new Date()).getTime().toString();"/>
                        <a4j:commandButton value="Cancelar solicitud" styleClass="btn"
                                           action="#{ManagedSolicitudMantenimiento.cancelarSolicitudMantenimiento_action}" reRender="dataSolicitudMantenimiento"
                                           oncomplete="if(#{ManagedSolicitudMantenimiento.mensaje eq '1'}){alert('Se cancelo la solicitud de mantenimiento');}else{alert('#{ManagedSolicitudMantenimiento.mensaje}')}"/>
                        <%--a4j:commandButton value="Cerrar" styleClass="btn" action="#{ManagedSolicitudMantenimiento.cerrarSolicitudMantenimiento_action}" onclick="if(confirm('esta seguro de cerrar la Solicitud de Mantenimiento?')==false){return false;}"
                        rendered="#{ManagedAccesoSistema.codAreaEmpresaGlobal eq '86'}" reRender="dataSolicitudMantenimiento" />
                        <a4j:commandButton value="Correo" styleClass="btn" action="#{ManagedSolicitudMantenimiento.enviarCorreoPrueba_action}"
                        reRender="dataSolicitudMantenimiento" /--%>

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

