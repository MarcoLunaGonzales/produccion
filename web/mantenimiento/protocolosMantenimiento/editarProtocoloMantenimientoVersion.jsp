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
            <script type="text/javascript">
                function validarEditarProtocoloVersion()
                {
                    return (validarMayorACero(document.getElementById("form1:cantidadUnidadTiempo")));
                }
            </script>
        </head>
        <body >
            <a4j:form id="form1">
                
                <div align="center">
                    <h:outputText value="Edición Protocolo de Mantenimiento" styleClass="outputTextTituloSistema"/>
                    <h:outputText value="#{ManagedProtocoloMantenimiento.cargareditarProtocoloMantenimientoVersion}"/>
                    <rich:panel style="width:70%" headerClass="headerClassACliente">
                        <f:facet name="header">
                            <h:outputText value="Edición de Protocolo de Mantenimiento"/>
                        </f:facet>
                        <h:panelGrid columns="3" id="contenidoEditar">
                            <h:outputText value="Nro. Versión" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:outputText value="#{ManagedProtocoloMantenimiento.protocoloMantenimientoVersionEditar.nroVersion}" styleClass="outputText2"/>
                            <h:outputText value="Maquinaria" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:outputText value="#{ManagedProtocoloMantenimiento.protocoloMantenimientoBean.protocoloMantenimiento.maquinaria.nombreMaquina}" styleClass="outputText2"/>
                            
                            <h:outputText value="Parte Maquinaria" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:outputText value="#{ManagedProtocoloMantenimiento.protocoloMantenimientoBean.protocoloMantenimiento.partesMaquinaria.nombreParteMaquina}" styleClass="outputText2"/>
                            
                            <h:outputText value="Tipo de Mantenimiento" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectOneMenu value="#{ManagedProtocoloMantenimiento.protocoloMantenimientoVersionEditar.tiposMantenimientoMaquinaria.codTipoMantenimientoMaquinaria}" styleClass="inputText" id="codTipoMantenimiento">
                                <f:selectItems value="#{ManagedProtocoloMantenimiento.tiposMantenimientoMaquinariaSelectList}"/>
                            </h:selectOneMenu>
                            <h:outputText value="Frecuencia Mantenimiento" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectOneMenu value="#{ManagedProtocoloMantenimiento.protocoloMantenimientoVersionEditar.tiposFrecuenciaMantenimiento.codTipoFrecuenciaMantenimiento}" styleClass="inputText" id="codTipoFrecuenciaMantenimiento">
                                <f:selectItems value="#{ManagedProtocoloMantenimiento.tiposFrecuenciaMantenimientoSelectList}"/>
                                <a4j:support event="onchange" action="#{ManagedProtocoloMantenimiento.codTipoFrecuenciaMantenimientoEditar_change}" reRender="contenidoEditar"/>
                            </h:selectOneMenu>
                            <h:outputText value="Nro Semana" styleClass="outputTextBold"  rendered="#{ManagedProtocoloMantenimiento.protocoloMantenimientoVersionEditar.tiposFrecuenciaMantenimiento.aplicaAsignarNroSemana}" />
                            <h:outputText value="::" styleClass="outputTextBold" rendered="#{ManagedProtocoloMantenimiento.protocoloMantenimientoVersionEditar.tiposFrecuenciaMantenimiento.aplicaAsignarNroSemana}" />
                            <h:selectOneMenu value="#{ManagedProtocoloMantenimiento.protocoloMantenimientoVersionEditar.nroSemana}" styleClass="inputText" rendered="#{ManagedProtocoloMantenimiento.protocoloMantenimientoVersionEditar.tiposFrecuenciaMantenimiento.aplicaAsignarNroSemana}">
                                <f:selectItem itemValue='1' itemLabel="1er Semana"/>
                                <f:selectItem itemValue='2' itemLabel="2da Semana"/>
                                <f:selectItem itemValue='3' itemLabel="3er Semana"/>
                                <f:selectItem itemValue='4' itemLabel="4ta Semana"/>
                                
                            </h:selectOneMenu>
                            <h:outputText value="Día Semana" styleClass="outputTextBold"   />
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectOneRadio value="#{ManagedProtocoloMantenimiento.protocoloMantenimientoVersionEditar.diaSemana.codDiaSemana}" styleClass="outputTextBold">
                                <f:selectItems value="#{ManagedProtocoloMantenimiento.diasSemanaSelectList}"/>
                            </h:selectOneRadio>
                            <h:outputText value="POE" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectOneMenu style="width:50em" value="#{ManagedProtocoloMantenimiento.protocoloMantenimientoVersionEditar.documentacion.codDocumento}" styleClass="inputText" id="codDOcumentacionAgregar">
                                <f:selectItem itemValue='0' itemLabel="--No Aplica--"/>
                                <f:selectItems value="#{ManagedProtocoloMantenimiento.documentacionSelectList}"/>
                            </h:selectOneMenu>
                            <h:outputText value="Tiempo" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:inputText value="#{ManagedProtocoloMantenimiento.protocoloMantenimientoVersionEditar.cantidadTiempo}" styleClass="inputText" id="cantidadUnidadTiempo" onblur="valorPorDefecto(this)"/>
                            <h:outputText value="Unidad Tiempo" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectOneMenu value="#{ManagedProtocoloMantenimiento.protocoloMantenimientoVersionEditar.unidadMedidaTiempo.codUnidadMedida}" styleClass="inputText" id="codUnidadMEdidaTiempo">
                                <f:selectItems value="#{ManagedProtocoloMantenimiento.unidadesMedidaTiempoSelectList}"/>
                            </h:selectOneMenu>
                            <h:outputText value="Mantenimiento COFAR" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectBooleanCheckbox value="#{ManagedProtocoloMantenimiento.protocoloMantenimientoVersionEditar.mantenimientoCofar}"/>
                            <h:outputText value="Mantenimiento EXTERNO" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectBooleanCheckbox value="#{ManagedProtocoloMantenimiento.protocoloMantenimientoVersionEditar.mantenimientoExterno}"/>
                            <h:outputText value="Descripción" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:inputTextarea style="width:40em" rows="3" styleClass="inputText" value="#{ManagedProtocoloMantenimiento.protocoloMantenimientoVersionEditar.descripcionProtocoloMantenimientoVersion}">
                            </h:inputTextarea>
                            <h:outputText value="Estado" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectOneMenu value="#{ManagedProtocoloMantenimiento.protocoloMantenimientoVersionEditar.estadoRegistro.codEstadoRegistro}" styleClass="inputText" >
                                <f:selectItem itemValue="1" itemLabel="Activo"/>
                                <f:selectItem itemValue="2" itemLabel="No Activo"/>
                            </h:selectOneMenu>
                            
                        </h:panelGrid>
                            <a4j:commandButton value="Guardar" styleClass="btn" action="#{ManagedProtocoloMantenimiento.guardarEdicionProtocoloMantenimientoVersion_action}"
                                                onclick="if(!validarEditarProtocoloVersion()){return false;}"
                                                oncomplete="if(#{ManagedProtocoloMantenimiento.mensaje eq '1'}){alert('Se guardo la edición del protocolo de mantenimiento');redireccionar('navegadorProtocolosMantenimientoVersion.jsf');}
                                                else{alert('#{ManagedProtocoloMantenimiento.mensaje}');}" />
                        <a4j:commandButton value="Cancelar" oncomplete="redireccionar('navegadorProtocolosMantenimientoVersion.jsf');" styleClass="btn"/>
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

