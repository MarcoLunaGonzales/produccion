<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>
<f:view>
    
    <html>
        <head>
            <title>Protocolos Mantenimiento</title>
            <script type="text/javascript" src="../../js/general.js" ></script>
            <script type="text/javascript" src="../../js/dataPickerMantenimiento.js" ></script>
            <a4j:loadStyle src="../../css/ventas.css"/>
            <a4j:loadStyle src="../../css/mantenimientoPlanificado.css"/>
        </head>
        <body >
        <a4j:form id="form1">
            <div align="center">
                <h:outputText value="#{ManagedMantenimientoPlanificado.cargarMantenimientoPlanificadoList}"  />
                <rich:dataTable value="#{ManagedMantenimientoPlanificado.mantenimientoPlanificadoList}"
                                    var="data" id="dataMantenimientoPlanificado" style="display:none"
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
                            </rich:columnGroup>
                            
                        </f:facet>
                            <rich:column>
                                <h:selectBooleanCheckbox value="#{data.checked}"/>
                            </rich:column>
                            <rich:column>
                                <h:inputText value="#{data.fechaMantenimiento}">
                                    <f:convertDateTime pattern="dd/MM/yyyy"/>
                                </h:inputText>
                                <h:outputText value="#{data.protocoloMantenimientoVersion.protocoloMantenimiento.maquinaria.nombreMaquina}" styleClass="outputText2"/>
                            </rich:column>
                            <rich:column>
                                <h:outputText value="#{data.protocoloMantenimientoVersion.protocoloMantenimiento.maquinaria.codigo}"/>
                            </rich:column>
                            <rich:column>
                                <h:outputText value="#{data.protocoloMantenimientoVersion.protocoloMantenimiento.partesMaquinaria.nombreParteMaquina}" styleClass="outputText2"/>
                            </rich:column>
                            <rich:column>
                                <h:outputText value="#{data.protocoloMantenimientoVersion.protocoloMantenimiento.partesMaquinaria.codigo}"/>
                            </rich:column>
                            <rich:column>
                                <h:outputText value="#{data.protocoloMantenimientoVersion.tiposFrecuenciaMantenimiento.abreviatura}" styleClass="outputText2"/>
                            </rich:column>
                            <rich:column>
                                <h:outputText value="#{data.protocoloMantenimientoVersion.tiposMantenimientoMaquinaria.nombreTipoMantenimientoMaquinaria}" styleClass="outputText2"/>
                            </rich:column>
                            <rich:column>
                                <h:outputText value="#{data.fechaMantenimiento}">
                                    <f:convertDateTime pattern="dd/MM/yyyy"/>
                                </h:outputText>
                            </rich:column>
                        

                    </rich:dataTable>
                        <rich:panel id="divCalendar">
                            <h:outputText value="registro de prueba"/>
                        </rich:panel>
                        <rich:dataTable value="#{ManagedMantenimientoPlanificado.maquinariaMantenimientoPlanificadoList}"
                                        var="data" id="dataMaquinariaMantenimiento" 
                                        rowKeyVar="rowkey" style="display:none"
                                        onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                        onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                        headerClass="headerClassACliente">
                        <f:facet name="header">
                            <rich:columnGroup>
                                <rich:column rowspan="2">
                                    <h:outputText value="Item"/>
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Maquinaria"/>
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="P.O.E."/>
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Marca"/>
                                </rich:column>
                                <rich:column colspan="2">
                                    <h:outputText value="Realizado por:"/>
                                </rich:column>
                                <rich:column colspan="3">
                                    <h:outputText value="Mantenimiento Preventivo"/>
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Observaciones"/>
                                </rich:column>
                                <rich:column breakBefore="true">
                                    <h:outputText value="MAN<BR>Cofar" escape="false"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="MAN<BR>Externo" escape="false"/>
                                </rich:column>
                                <rich:column >
                                    <h:outputText value="Tipo"/>
                                </rich:column>
                                <rich:column >
                                    <h:outputText value="Dias"/>
                                </rich:column>
                                <rich:column >
                                    <h:outputText value="Tiempo Mantenimiento"/>
                                </rich:column>
                                
                            </rich:columnGroup>
                        </f:facet>
                        <rich:subTable var="subData" value="#{data.protocoloMantenimientoVersionList}" rowKeyVar="rowkey1">
                            <rich:subTable var="preData" value="#{subData.mantenimientoPlanificadoList}" rowKeyVar="rowkey2">
                                <rich:column rowspan="#{data.protocoloMantenimientoVersionMantenimientoPreventivoListSize}"  rendered="#{rowkey1 eq 0 && rowkey2 eq 0}">
                                    <h:outputText value="#{rowkey+1}"/>
                                </rich:column>
                                <rich:column rowspan="#{data.protocoloMantenimientoVersionMantenimientoPreventivoListSize}"  rendered="#{rowkey1 eq 0 && rowkey2 eq 0}">
                                    <h:outputText value="#{data.nombreMaquina}"/>
                                </rich:column>
                                <rich:column rowspan="#{subData.mantenimientoPlanificadoListSize}"  rendered="#{rowkey2 eq 0}">
                                    <h:outputText value="#{subData.documentacion.codigoDocumento}"/>
                                </rich:column>
                                <rich:column rowspan="#{data.protocoloMantenimientoVersionMantenimientoPreventivoListSize}"  rendered="#{rowkey1 eq 0 && rowkey2 eq 0}">
                                    <h:outputText value="#{data.marcaMaquinaria.nombreMarcaMaquinaria}"/>
                                </rich:column>
                                <rich:column rowspan="#{data.protocoloMantenimientoVersionMantenimientoPreventivoListSize}" styleClass="tdCenter"  rendered="#{rowkey1 eq 0 && rowkey2 eq 0}">
                                    <h:outputText value="X" rendered="#{subData.mantenimientoCofar}"/>
                                </rich:column>
                                <rich:column rowspan="#{data.protocoloMantenimientoVersionMantenimientoPreventivoListSize}" styleClass="tdCenter" rendered="#{rowkey1 eq 0 && rowkey2 eq 0}">
                                    <h:outputText value="X" rendered="#{subData.mantenimientoExterno}"/>
                                </rich:column>
                                <rich:column rowspan="#{subData.mantenimientoPlanificadoListSize}"  rendered="#{rowkey2 eq 0}" styleClass="#{subData.tiposFrecuenciaMantenimiento.abreviatura}">
                                    <h:outputText value="#{subData.tiposFrecuenciaMantenimiento.abreviatura}"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="#{preData.fechaMantenimiento}">
                                        <f:convertDateTime pattern="dd"/>
                                    </h:outputText>
                                </rich:column>
                                <rich:column rowspan="#{subData.mantenimientoPlanificadoListSize}"  rendered="#{rowkey2 eq 0}">
                                    <h:outputText value="#{subData.cantidadTiempo} #{subData.unidadMedidaTiempo.nombreUnidadMedida}"/>
                                </rich:column>
                                <rich:column rowspan="#{subData.mantenimientoPlanificadoListSize}"  rendered="#{rowkey2 eq 0}">
                                    <h:outputText value="#{subData.descripcionProtocoloMantenimientoVersion}"/>
                                </rich:column>
                                
                            </rich:subTable>
                        </rich:subTable>
                        

                    </rich:dataTable>
                    
                
                
                
                    
                    
                    <br>
                    <h:inputHidden value="#{ManagedMantenimientoPlanificado.fechaRegistroMantenimientoPlanificado}"id="fechaRegistroMantenimiento">
                        <f:convertDateTime pattern="dd/MM/yyyy"/>
                    </h:inputHidden>
                    <h:inputHidden value="#{ManagedMantenimientoPlanificado.fechaFiltro}"id="fechaFiltro">
                        <f:convertDateTime pattern="dd/MM/yyyy"/>
                    </h:inputHidden>
                    <a4j:jsFunction action="#{ManagedMantenimientoPlanificado.agregarMantenimientoPlanificado_action}" name="agregarMantenimiento"
                                    reRender="contenidoAgregarMantenimientoPlanificado,dataMaquinariaMantenimiento" oncomplete="Richfaces.showModalPanel('panelAgregarMantenimientoPlanificado');"/>
                    <a4j:jsFunction action="#{ManagedMantenimientoPlanificado.mesMantenimientoPlanificado_change}" name="cambioMes"
                                    reRender="dataMantenimientoPlanificado,dataMaquinariaMantenimiento" oncomplete="cronograma.updatePadSeleccion();"/>
                    <%--a4j:commandButton value="Generar Solicitudes de Mantenimiento" styleClass="btn"
                                       oncomplete="Richfaces.showModalPanel('panelGenerarOrdenesTrabajo');"/--%>
                </div>
                
                
                    
            </a4j:form>
            <rich:modalPanel id="panelGenerarOrdenesTrabajo" 
                            minHeight="220"  minWidth="350" height="220" width="350"
                            zindex="100" headerClass="headerClassACliente"
                            resizeable="false" style="overflow :auto" >
                <f:facet name="header">
                    <h:outputText value="<center>Generación de Ordenes de Trabajo</center>" escape="false"/>
                </f:facet>
                <a4j:form id="formGenerarOrdenesTrabajo">
                    <div style="text-align: center">
                        <h:panelGrid columns="3">
                            <h:outputText value="Fecha Inicio" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <rich:calendar value="#{ManagedMantenimientoPlanificado.fechaInicioGeneracionOrdenesTrabajo}"
                                           datePattern="dd/MM/yyyy"/>
                            <h:outputText value="Fecha Final" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <rich:calendar value="#{ManagedMantenimientoPlanificado.fechaFinalGeneracionOrdenesTrabajo}"
                                           datePattern="dd/MM/yyyy"/>
                        </h:panelGrid>
                    
                        <a4j:commandButton value="Generar Ordenes de Trabajo" styleClass="btn"
                                           action="#{ManagedMantenimientoPlanificado.registrarOrdenesTrabajoMantenimientoPreventivo_action}"
                                           oncomplete="if(#{ManagedMantenimientoPlanificado.mensaje eq '1'}){Richfaces.hideModalPanel('panelGenerarOrdenesTrabajo');alert('Se registraron las ordenes de trabajo');}else{alert('#{ManagedMantenimientoPlanificado.mensaje}')}"/>
                        <a4j:commandButton value="Cancelar" styleClass="btn" oncomplete="Richfaces.hideModalPanel('panelGenerarOrdenesTrabajo');"/>
                    </div>
                    
                </a4j:form>
            </rich:modalPanel>
            <rich:modalPanel id="panelAgregarMantenimientoPlanificado" 
                            minHeight="250"  minWidth="630" height="250" width="630"
                            zindex="100" headerClass="headerClassACliente"
                            resizeable="false" style="overflow :auto" >
                <f:facet name="header">
                    <h:outputText value="<center>Agregar Mantenimiento Planificado</center>" escape="false"/>
                </f:facet>
                <a4j:form id="formAgregarMaterialSolicitud">
                    <h:panelGroup id="contenidoAgregarMantenimientoPlanificado">
                        <div align="center">
                            <h:panelGrid columns="3" id="dataformAgregarMantenimiento">
                                <h:outputText value="Fecha" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:outputText value="#{ManagedMantenimientoPlanificado.fechaRegistroMantenimientoPlanificado}" styleClass="outputTextBold">
                                    <f:convertDateTime pattern="dd/MM/yyyy"/>
                                </h:outputText>
                                <h:outputText value="Protocolo Mantenimiento" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:selectOneMenu value="#{ManagedMantenimientoPlanificado.mantenimientoPlanificadoAgregar.protocoloMantenimientoVersion.codProtocoloMantenimientoVersion}" styleClass="inputText">
                                    <f:selectItems value="#{ManagedMantenimientoPlanificado.protocoloMantenimientoVersionSelectList}"/>
                                    <a4j:support event="onchange" action="#{ManagedMantenimientoPlanificado.codProtocoloMantenimientoVersionAgregar_change}" reRender="dataformAgregarMantenimiento"/>
                                </h:selectOneMenu>
                                <h:outputText value="Maquinaria" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:outputText value="#{ManagedMantenimientoPlanificado.mantenimientoPlanificadoAgregar.protocoloMantenimientoVersion.protocoloMantenimiento.maquinaria.nombreMaquina}" styleClass="outputText2"/>
                                <h:outputText value="Parte Maquinaria" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:outputText value="#{ManagedMantenimientoPlanificado.mantenimientoPlanificadoAgregar.protocoloMantenimientoVersion.protocoloMantenimiento.partesMaquinaria.nombreParteMaquina}" styleClass="outputText2"/>
                                <h:outputText value="Tipo Mantenimiento" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:outputText value="#{ManagedMantenimientoPlanificado.mantenimientoPlanificadoAgregar.protocoloMantenimientoVersion.tiposMantenimientoMaquinaria.nombreTipoMantenimientoMaquinaria}" styleClass="outputText2"/>
                                <h:outputText value="Frecuencia Mantenimiento" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:outputText value="#{ManagedMantenimientoPlanificado.mantenimientoPlanificadoAgregar.protocoloMantenimientoVersion.tiposFrecuenciaMantenimiento.nombreTipoFrecuenciaMantenimiento}" styleClass="outputText2"/>
                            </h:panelGrid>
                            
                            <br>
                            <a4j:commandButton value="Guardar" styleClass="btn" 
                                               reRender="dataMantenimientoPlanificado"
                                               action="#{ManagedMantenimientoPlanificado.guardarAgregarMantenimientoPlanificado_action}"
                                               oncomplete="if(#{ManagedMantenimientoPlanificado.mensaje eq '1'}){alert('Se agregaron los materiales al protocolo');Richfaces.hideModalPanel('panelAgregarMantenimientoPlanificado');cronograma.asignarCoorDenadas('form1:dataMantenimientoPlanificado');}
                                               else{alert('#{ManagedMantenimientoPlanificado.mensaje}');}"/>
                            <a4j:commandButton value="Cancelar" styleClass="btn"
                                               oncomplete="Richfaces.hideModalPanel('panelAgregarMantenimientoPlanificado')"/>
                            
                        </div>
                    </h:panelGroup>
                </a4j:form>
            </rich:modalPanel>
            <a4j:status id="statusPeticion"
                        onstart="Richfaces.showModalPanel('ajaxLoadingModalBox',{width:100, top:100})"
                        onstop="Richfaces.hideModalPanel('ajaxLoadingModalBox');">
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

