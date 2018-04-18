<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>
    
    <html>
        <head>
            <title></title>
            <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" /> 
            <script type="text/javascript" src="../../js/general.js" ></script> 
            <script>
                
</script>
        </head>
        <body >
            <a4j:form id="form1">
                
                <div align="center">
                    <span class="outputTextTituloSistema">Editar Solicitud de Mantenimiento</span>
                    <a4j:jsFunction reRender="panelRegistroSolicitud" name="actualizarRegistro"/>
                    <rich:panel style="width:70%" headerClass="headerClassACliente">
                        <f:facet name="header">
                            <h:outputText value="Registro de Solicitud de Mantenimiento"/>
                        </f:facet>
                        <h:panelGrid columns="3" id="panelRegistroSolicitud">
                            <h:outputText value="Area Empresa" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectOneMenu value="#{ManagedSolicitudMantenimiento.solicitudMantenimientoEditar.areasEmpresa.codAreaEmpresa}" styleClass="inputText" id="codAreaEmpresa">
                                <f:selectItems value="#{ManagedSolicitudMantenimiento.areasEmpresaSelectList}"/>
                                <a4j:support event="onchange" action="#{ManagedSolicitudMantenimiento.codAreaEmpresaSolicitudMantenimientoEditar_change}" reRender="panelRegistroSolicitud"/>
                            </h:selectOneMenu>
                            <h:outputText value="Tipo de Mantenimiento" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectOneRadio value="#{ManagedSolicitudMantenimiento.solicitudMantenimientoEditar.solicitudMantenimientoMaquinaria}" styleClass="outputText2" onclick="actualizarRegistro()">
                                <f:selectItem itemValue='false' itemLabel="Instalación"/>
                                <f:selectItem itemValue='true' itemLabel="Maquinaria"/>
                            </h:selectOneRadio>
                            <h:outputText value="Maquinaria" styleClass="outputTextBold" rendered="#{ManagedSolicitudMantenimiento.solicitudMantenimientoEditar.solicitudMantenimientoMaquinaria}"/>
                            <h:outputText value="::" styleClass="outputTextBold" rendered="#{ManagedSolicitudMantenimiento.solicitudMantenimientoEditar.solicitudMantenimientoMaquinaria}"/>
                            <h:selectOneMenu value="#{ManagedSolicitudMantenimiento.solicitudMantenimientoEditar.maquinaria.codMaquina}" styleClass="inputText" rendered="#{ManagedSolicitudMantenimiento.solicitudMantenimientoEditar.solicitudMantenimientoMaquinaria}">
                                <f:selectItems value="#{ManagedSolicitudMantenimiento.maquinariaSelectList}"/>
                            </h:selectOneMenu>
                            <h:outputText value="Instalación" styleClass="outputTextBold" rendered="#{!ManagedSolicitudMantenimiento.solicitudMantenimientoEditar.solicitudMantenimientoMaquinaria}"/>
                            <h:outputText value="::" styleClass="outputTextBold" rendered="#{!ManagedSolicitudMantenimiento.solicitudMantenimientoEditar.solicitudMantenimientoMaquinaria}"/>
                            <h:selectOneMenu value="#{ManagedSolicitudMantenimiento.solicitudMantenimientoEditar.areasInstalaciones.codAreaInstalacion}" styleClass="inputText" rendered="#{!ManagedSolicitudMantenimiento.solicitudMantenimientoEditar.solicitudMantenimientoMaquinaria}">
                                <f:selectItems value="#{ManagedSolicitudMantenimiento.areasInstalacionSelectList}"/>
                            </h:selectOneMenu>
                            <h:outputText value="Afecta Producción" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold" />
                            <h:selectOneRadio value="#{ManagedSolicitudMantenimiento.solicitudMantenimientoEditar.afectaraProduccion}" styleClass="outputText2" >
                                <f:selectItem itemValue='1' itemLabel="SI"/>
                                <f:selectItem itemValue='0' itemLabel="NO"/>
                            </h:selectOneRadio>
                            <h:outputText value="Prioridad" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold" />
                            <h:selectOneMenu value="#{ManagedSolicitudMantenimiento.solicitudMantenimientoEditar.tiposNivelSolicitudMantenimiento.codTipoNivelSolicitudMantenimiento}" styleClass="inputText">
                                <f:selectItems value="#{ManagedSolicitudMantenimiento.tiposNivelSolicitudMantenimientoSelectList}"/>
                            </h:selectOneMenu>
                            <h:outputText value="Tipo de Mantenimiento" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold" />
                            <h:selectOneMenu value="#{ManagedSolicitudMantenimiento.solicitudMantenimientoEditar.tiposSolicitudMantenimiento.codTipoSolicitud}" styleClass="inputText">
                                <f:selectItems value="#{ManagedSolicitudMantenimiento.tiposSolicitudMantenimientoSelectList}"/>
                            </h:selectOneMenu>
                            <h:outputText value="Fecha" styleClass="outputTextBold" rendered="#{ManagedSolicitudMantenimiento.permisoRegistroFechaSolicitud}"/>
                            <h:outputText value="::" styleClass="outputTextBold" rendered="#{ManagedSolicitudMantenimiento.permisoRegistroFechaSolicitud}"/>
                            <rich:calendar value="#{ManagedSolicitudMantenimiento.solicitudMantenimientoEditar.fechaSolicitudMantenimiento}" styleClass="inputText"  datePattern="dd/MM/yyyy" rendered="#{ManagedSolicitudMantenimiento.permisoRegistroFechaSolicitud}">
                            </rich:calendar>
                            <h:outputText value="Descripción" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold" />
                            <h:inputTextarea value="#{ManagedSolicitudMantenimiento.solicitudMantenimientoEditar.obsSolicitudMantenimiento}" styleClass="inputText" rows="5" style="width:100%">
                            </h:inputTextarea>
                            
                        </h:panelGrid>
                        <a4j:commandButton value="Guardar" styleClass="btn" action="#{ManagedSolicitudMantenimiento.guardarEdicionSolicitudMantenimiento_action}"
                                           oncomplete="if(#{ManagedSolicitudMantenimiento.mensaje eq '1'}){alert('Se registro satisfactoriamente la edición de la solicitud');window.location.href='navegadorSolicitudesMantenimiento.jsf?add='+(new Date()).getTime().toString();}
                                           else{alert('#{ManagedSolicitudMantenimiento.mensaje}');}" />
                        <a4j:commandButton value="Cancelar" oncomplete="window.location.href='navegadorSolicitudesMantenimiento.jsf?cancel='+(new Date()).getTime().toString()" styleClass="btn"/>
                    </rich:panel>
                    
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

