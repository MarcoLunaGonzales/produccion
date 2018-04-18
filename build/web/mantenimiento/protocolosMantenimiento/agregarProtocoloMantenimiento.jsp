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
                function validarAgregarProtocolo()
                {
                    return (validarMayorACero(document.getElementById("form1:cantidadUnidadTiempo")));
                }
            </script>
        </head>
        <body >
            <a4j:form id="form1">
                
                <div align="center">
                    <h:outputText value="Registrar Nuevo Protocolo de Mantenimiento" styleClass="outputTextTituloSistema"/>
                    <h:outputText value="#{ManagedProtocoloMantenimiento.cargarAgregarProtocoloMantenimiento}"/>
                    <rich:panel style="width:70%" headerClass="headerClassACliente">
                        <f:facet name="header">
                            <h:outputText value="Registro de Protocolo de Mantenimiento"/>
                        </f:facet>
                        <h:panelGrid columns="3" id="panelRegistroSolicitud">
                            <h:outputText value="Maquinaria" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectOneMenu value="#{ManagedProtocoloMantenimiento.protocoloMantenimientoVersionAgregar.protocoloMantenimiento.maquinaria.codMaquina}" styleClass="inputText" id="codMaquinaria">
                                <f:selectItems value="#{ManagedProtocoloMantenimiento.maquinariasSelectList}"/>
                                <a4j:support event="onchange" action="#{ManagedProtocoloMantenimiento.codMaquinariaProtocoloMantenimientoAgregar_change}" reRender="codParteMaquinaria"/>
                            </h:selectOneMenu>
                            <h:outputText value="Parte Maquinaria" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectOneMenu value="#{ManagedProtocoloMantenimiento.protocoloMantenimientoVersionAgregar.protocoloMantenimiento.partesMaquinaria.codParteMaquina}" styleClass="inputText" id="codParteMaquinaria">
                                <f:selectItem itemValue='0' itemLabel='--TODA LA MAQUINA--'/>
                                <f:selectItems value="#{ManagedProtocoloMantenimiento.partesMaquinariaSelectList}"/>
                            </h:selectOneMenu>
                            <h:outputText value="Tipo de Mantenimiento" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectOneMenu value="#{ManagedProtocoloMantenimiento.protocoloMantenimientoVersionAgregar.tiposMantenimientoMaquinaria.codTipoMantenimientoMaquinaria}" styleClass="inputText" id="codTipoMantenimiento">
                                <f:selectItems value="#{ManagedProtocoloMantenimiento.tiposMantenimientoMaquinariaSelectList}"/>
                                
                            </h:selectOneMenu>
                            <h:outputText value="Frecuencia Mantenimiento" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectOneMenu value="#{ManagedProtocoloMantenimiento.protocoloMantenimientoVersionAgregar.tiposFrecuenciaMantenimiento.codTipoFrecuenciaMantenimiento}" styleClass="inputText" id="codTipoFrecuenciaMantenimiento">
                                <f:selectItems value="#{ManagedProtocoloMantenimiento.tiposFrecuenciaMantenimientoSelectList}"/>
                                <a4j:support event="onchange" action="#{ManagedProtocoloMantenimiento.codTipoFrecuenciaMantenimientoAgregar_change}" reRender="panelRegistroSolicitud"/>
                            </h:selectOneMenu>
                            <h:outputText value="Nro Semana" styleClass="outputTextBold"  rendered="#{ManagedProtocoloMantenimiento.protocoloMantenimientoVersionAgregar.tiposFrecuenciaMantenimiento.aplicaAsignarNroSemana}" />
                            <h:outputText value="::" styleClass="outputTextBold" rendered="#{ManagedProtocoloMantenimiento.protocoloMantenimientoVersionAgregar.tiposFrecuenciaMantenimiento.aplicaAsignarNroSemana}" />
                            <h:selectOneMenu value="#{ManagedProtocoloMantenimiento.protocoloMantenimientoVersionAgregar.nroSemana}" styleClass="inputText" rendered="#{ManagedProtocoloMantenimiento.protocoloMantenimientoVersionAgregar.tiposFrecuenciaMantenimiento.aplicaAsignarNroSemana}">
                                <f:selectItem itemValue='1' itemLabel="1er Semana"/>
                                <f:selectItem itemValue='2' itemLabel="2da Semana"/>
                                <f:selectItem itemValue='3' itemLabel="3er Semana"/>
                                <f:selectItem itemValue='4' itemLabel="4ta Semana"/>
                                
                            </h:selectOneMenu>
                            <h:outputText value="Día Semana" styleClass="outputTextBold"   />
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectOneRadio value="#{ManagedProtocoloMantenimiento.protocoloMantenimientoVersionAgregar.diaSemana.codDiaSemana}" styleClass="outputTextBold">
                                <f:selectItems value="#{ManagedProtocoloMantenimiento.diasSemanaSelectList}"/>
                            </h:selectOneRadio>
                            <h:outputText value="POE" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectOneMenu value="#{ManagedProtocoloMantenimiento.protocoloMantenimientoVersionAgregar.documentacion.codDocumento}" styleClass="inputText" id="codDOcumentacionAgregar" style="width:40em">
                                <f:selectItem itemValue='0' itemLabel="--No Aplica--"/>
                                <f:selectItems value="#{ManagedProtocoloMantenimiento.documentacionSelectList}"/>
                            </h:selectOneMenu>
                            <h:outputText value="Tiempo" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:inputText value="#{ManagedProtocoloMantenimiento.protocoloMantenimientoVersionAgregar.cantidadTiempo}" styleClass="inputText" id="cantidadUnidadTiempo" onblur="valorPorDefecto(this)"/>
                            <h:outputText value="Unidad Tiempo" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectOneMenu value="#{ManagedProtocoloMantenimiento.protocoloMantenimientoVersionAgregar.unidadMedidaTiempo.codUnidadMedida}" styleClass="inputText" id="codUnidadMEdidaTiempo">
                                <f:selectItems value="#{ManagedProtocoloMantenimiento.unidadesMedidaTiempoSelectList}"/>
                            </h:selectOneMenu>
                            <h:outputText value="Mantenimiento Cofar" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectBooleanCheckbox value="#{ManagedProtocoloMantenimiento.protocoloMantenimientoVersionAgregar.mantenimientoCofar}"/>
                            <h:outputText value="Mantenimiento Externo" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectBooleanCheckbox value="#{ManagedProtocoloMantenimiento.protocoloMantenimientoVersionAgregar.mantenimientoExterno}"/>
                            <h:outputText value="Descripción" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:inputTextarea value="#{ManagedProtocoloMantenimiento.protocoloMantenimientoVersionAgregar.descripcionProtocoloMantenimientoVersion}" styleClass="inputText" rows="4" style="width:30em">
                            </h:inputTextarea>
                            
                            <h:outputText value="Estado" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:outputText value="Activo" styleClass="outputText2"/>
                            
                        </h:panelGrid>
                        <a4j:commandButton value="Guardar" styleClass="btn" action="#{ManagedProtocoloMantenimiento.guardarAgregarProtocoloMantenimiento_action}"
                                           onclick="if(!validarAgregarProtocolo()){return false;}"
                                           oncomplete="if(#{ManagedProtocoloMantenimiento.mensaje eq '1'}){alert('Se registro el protocolo de mantenimiento');redireccionar('navegadorProtocolosMantenimiento.jsf');}
                                           else{alert('#{ManagedProtocoloMantenimiento.mensaje}');}" />
                        <a4j:commandButton value="Cancelar" oncomplete="redireccionar('navegadorProtocolosMantenimiento.jsf');" styleClass="btn"/>
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
                    <h:graphicImage value="../img/load2.gif" />
                </div>
            </rich:modalPanel>
        </body>
        
    </html>
    
</f:view>

