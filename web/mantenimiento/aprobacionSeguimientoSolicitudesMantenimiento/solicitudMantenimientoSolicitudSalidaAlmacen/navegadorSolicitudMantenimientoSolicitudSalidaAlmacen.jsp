<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>
<f:view>

    <html>
        <head>
            <title>Seguimiento Tareas Solicitud Mantenimiento</title>
            <link rel="STYLESHEET" type="text/css" href="../../../css/ventas.css" />
            <script type="text/javascript" src="../../../js/general.js" ></script>
            <script>
                function verDetalleSolicitudMantenimiento(codFormSalida,codAlmacen)
                {
                    
                    window.open('reporteDetalleSolicitudSalidasAlmacenMantenimiento.jsf?codFormSalida='+codFormSalida+
                                        '&codAlmacen='+codAlmacen+
                                        '&data='+(new Date()).getTime().toString()
                                        ,'solicitud'+(new Date()).getTime().toString(),
                                        'top=50,left=200,width=800,height=600,scrollbars=1,resizable=1');
                }
            </script>
        </head>
        <body >
            <a4j:form id="form1">
                <div align="center">
                    <span class="outputTextTituloSistema">Listado de Solicitud de Materiales</span>
                    <h:outputText value="#{ManagedAprobacionSolicitudMantenimiento.cargarSolicitudMantenimientoSolicitudSalidaAlmacen}"/>
                    
                        <rich:panel headerClass="headerClassACliente" style="width:80%">
                            <f:facet name="header">
                                    <h:outputText value="Datos Solicitud Mantenimiento"/>
                            </f:facet>
                            <h:panelGrid columns="6">
                                <h:outputText value="Nro. O.T." styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:outputText value="#{ManagedAprobacionSolicitudMantenimiento.solicitudMantenimientoSolicitudSalidaAlmacen.nroOrdenTrabajo}" styleClass="outputText2"/>
                                <h:outputText value="Area Empresa" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:outputText value="#{ManagedAprobacionSolicitudMantenimiento.solicitudMantenimientoSolicitudSalidaAlmacen.areasEmpresa.nombreAreaEmpresa}" styleClass="outputText2"/>
                                <h:outputText value="Maquinaria" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:outputText value="#{ManagedAprobacionSolicitudMantenimiento.solicitudMantenimientoSolicitudSalidaAlmacen.maquinaria.nombreMaquina}" styleClass="outputText2"/>
                                <h:outputText value="Instalación" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:outputText value="#{ManagedAprobacionSolicitudMantenimiento.solicitudMantenimientoSolicitudSalidaAlmacen.areasInstalaciones.nombreAreaInstalacion}" styleClass="outputText2"/>
                                <h:outputText value="Solicitante" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:outputText value="#{ManagedAprobacionSolicitudMantenimiento.solicitudMantenimientoSolicitudSalidaAlmacen.personal_usuario.nombrePersonal}" styleClass="outputText2"/>
                                <h:outputText value="Tipo Solicitud Mantenimiento" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:outputText value="#{ManagedAprobacionSolicitudMantenimiento.solicitudMantenimientoSolicitudSalidaAlmacen.tiposSolicitudMantenimiento.nombreTipoSolicitud}" styleClass="outputText2"/>
                                <h:outputText value="Fecha Solicitud" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:outputText value="#{ManagedAprobacionSolicitudMantenimiento.solicitudMantenimientoSolicitudSalidaAlmacen.fechaSolicitudMantenimiento}" styleClass="outputText2">
                                    <f:convertDateTime pattern="dd/MM/yyyy"/>
                                </h:outputText>
                                <h:outputText value="Fecha Aprobación" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:outputText value="#{ManagedAprobacionSolicitudMantenimiento.solicitudMantenimientoSolicitudSalidaAlmacen.fechaAprobacion}" styleClass="outputText2">
                                    <f:convertDateTime pattern="dd/MM/yyyy"/>
                                </h:outputText>
                                <h:outputText value="Estado Solicitud" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:outputText value="#{ManagedAprobacionSolicitudMantenimiento.solicitudMantenimientoSolicitudSalidaAlmacen.estadoSolicitudMantenimiento.nombreEstadoSolicitudMantenimiento}" styleClass="outputText2"/>
                            </h:panelGrid>
                        </rich:panel>
                    <br>
                    <rich:dataTable value="#{ManagedAprobacionSolicitudMantenimiento.solicitudMantenimientoSolicitudSalidaAlmacenList}" var="data"
                                    id="dataSolicitudMantenimientoSolicitudSalida"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente">
                        <f:facet name="header">
                            <rich:columnGroup>
                                <rich:column rowspan="2">
                                    <h:outputText value=""/>
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Solicitud<br> Mantenimiento" escape="false"/>
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Fecha Registro"/>
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Descripción"/>
                                </rich:column> 
                                <rich:column colspan="4">
                                    <h:outputText value="Detalle Materiales"/>
                                </rich:column>
                                <rich:column breakBefore="true">
                                    <h:outputText value="Material"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Cantidad"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Unidad de Medida"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Cantidad Disponible Almacenes"/>
                                </rich:column>
                            </rich:columnGroup>
                        </f:facet>
                        <rich:subTable value="#{data.solicitudMantenimientoDetalleMaterialesList}" var="subData" rowKeyVar="key">
                            <rich:column rowspan="#{data.solicitudMantenimientoDetalleMaterialesListSize}" rendered="#{key eq 0}" >
                                <h:selectBooleanCheckbox value="#{data.checked}" rendered="#{data.solicitudesSalida.codFormSalida eq 0}"/>
                                <h:outputText value="Solicitud Nro:#{data.solicitudesSalida.codFormSalida}<br>Almacen:#{data.solicitudesSalida.almacenes.nombreAlmacen}" escape="false" rendered="#{data.solicitudesSalida.codFormSalida> 0}"/>
                            </rich:column>
                            <rich:column rowspan="#{data.solicitudMantenimientoDetalleMaterialesListSize}" rendered="#{key eq 0}">
                                <a4j:commandLink oncomplete="verDetalleSolicitudMantenimiento(#{data.solicitudesSalida.codFormSalida},#{data.solicitudesSalida.almacenes.codAlmacen})" rendered="#{data.solicitudesSalida.codFormSalida> 0}">
                                    <h:graphicImage url="../../../img/pdf.jpg" alt="Impresion solicitud Mantenimiento"/>
                                </a4j:commandLink>
                            </rich:column>
                            <rich:column rowspan="#{data.solicitudMantenimientoDetalleMaterialesListSize}" rendered="#{key eq 0}">
                                <h:outputText value="#{data.fechaRegistro}">
                                    <f:convertDateTime pattern="dd/MM/yyyy HH:mm"/>
                                </h:outputText>
                            </rich:column>
                            <rich:column rowspan="#{data.solicitudMantenimientoDetalleMaterialesListSize}" rendered="#{key eq 0}">
                                <h:outputText value="#{data.descripcion}"/>
                            </rich:column>
                            <rich:column>
                                <h:outputText value="#{subData.materiales.nombreMaterial}"/>
                            </rich:column>
                            <rich:column>
                                <h:outputText value="#{subData.cantidad}"/>
                            </rich:column>
                            <rich:column>
                                <h:outputText value="#{subData.unidadesMedida.nombreUnidadMedida}"/>
                            </rich:column>
                            <rich:column>
                                <h:outputText value="#{subData.cantidadDisponibleOtrosAlmacenes}" escape="false" />
                            </rich:column>
                        </rich:subTable>
                        
                        

                    </rich:dataTable>
                    <br>
                    <a4j:commandButton value="Agregar" styleClass="btn" 
                                       oncomplete="window.location.href='agregarSolicitudMantenimientoSolicitudSalidaAlmacen.jsf?add='+(new Date()).getTime().toString();"/>
                    <a4j:commandButton value="Eliminar"  styleClass="btn"
                                       onclick="if(!editarItem('form1:dataSolicitudMantenimientoSolicitudSalida')){return false;}else{if(!confirm('Esta Seguro de eliminar la asignacion de tareas?')){return false;}}"
                                       action="#{ManagedAprobacionSolicitudMantenimiento.eliminarSolicitudMantenimientoSolicitudSalidaAlmacen_action}"
                                       reRender="dataSolicitudMantenimientoSolicitudSalida"
                                       oncomplete="if(#{ManagedAprobacionSolicitudMantenimiento.mensaje eq '1'}){alert('Se elimino la solicitud de materiales');}else{alert('#{ManagedAprobacionSolicitudMantenimiento.mensaje}')}"
                                        />
                    <a4j:commandButton value="Generar Solicitud" styleClass="btn" 
                                       action="#{ManagedAprobacionSolicitudMantenimiento.seleccionarSolicitudMantenimientoSolicitudSalidaGenerar_action}"
                                               reRender="contenidoGenerarSolicitudSalidaAlmacen"
                                               oncomplete="Richfaces.showModalPanel('panelGenerarSolicitudSalidaAlmacen');"/>
                    <a4j:commandButton value="Volver" styleClass="btn" oncomplete="window.location.href='../navegadorAprobacionSolicitudesMantenimiento.jsf?cancel='+(new Date()).getTime().toString()"/>

                </div>
            </a4j:form>
            <rich:modalPanel id="panelGenerarSolicitudSalidaAlmacen" 
                            minHeight="390"  minWidth="630" height="390" width="630"
                            zindex="200" headerClass="headerClassACliente"
                            resizeable="false" style="overflow :auto" >
                <f:facet name="header">
                    <h:outputText value="<center>Generación de Solicitud a Almacen</center>" escape="false"/>
                </f:facet>
                <a4j:form id="formGenerarSolicitudSalidaAlmacen">
                    <h:panelGroup id="contenidoGenerarSolicitudSalidaAlmacen">
                        <div align="center">
                            <h:panelGrid columns="3">
                                <h:outputText value="Almacen" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:selectOneMenu value="#{ManagedAprobacionSolicitudMantenimiento.solicitudMantenimientoSolicitudSalidaAlmacenGenerarSalida.solicitudesSalida.almacenes.codAlmacen}" styleClass="inputText">
                                    <f:selectItem itemValue='4' itemLabel="ALMACEN MANTENIMIENTO"/>
                                    <f:selectItem itemValue='14' itemLabel="ALMACEN MANTENIMIENTO 2" />
                                    <f:selectItems value="#{ManagedAprobacionSolicitudMantenimiento.almacenesSelectList}" />
                                    <a4j:support event="onchange" action="#{ManagedAprobacionSolicitudMantenimiento.codAlmacenDestinoSolicitud_change}" reRender="dataMaterialesSolicitud"/>
                                </h:selectOneMenu>
                                <h:outputText value="Descripción" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:inputTextarea value="#{ManagedAprobacionSolicitudMantenimiento.solicitudMantenimientoSolicitudSalidaAlmacenGenerarSalida.solicitudesSalida.obsSolicitud}" styleClass="inputText" cols="4" style="width:30rem;">
                                </h:inputTextarea>
                            </h:panelGrid>
                            <div style="height:220px;overflow-y: auto">
                                <rich:dataTable value="#{ManagedAprobacionSolicitudMantenimiento.solicitudMantenimientoSolicitudSalidaAlmacenGenerarSalida.solicitudMantenimientoDetalleMaterialesList}"
                                                var="data" 
                                                id="dataMaterialesSolicitud"
                                                headerClass="headerClassACliente">
                                    <f:facet name="header">
                                        <rich:columnGroup>
                                            <rich:column >
                                                <h:outputText value="Material"/>
                                            </rich:column>
                                            <rich:column >
                                                <h:outputText value="Cantidad Solicitada"/>
                                            </rich:column>
                                            <rich:column >
                                                <h:outputText value="Cantidad Disponible Almacen "/>
                                            </rich:column>
                                            <rich:column >
                                                <h:outputText value="Unidad de Medida"/>
                                            </rich:column>
                                            
                                        </rich:columnGroup>
                                    </f:facet>
                                    <rich:column>
                                        <a4j:commandLink action="#{ManagedAprobacionSolicitudMantenimiento.seleccionarAgregarSolicitudMantenimientoSalida_action}"
                                                         oncomplete="Richfaces.hideModalPanel('panelAgregarMaterialSolicitud')" reRender="dataSolicitudMantenimientoSolicitudMateriales">
                                            <h:outputText value="#{data.materiales.nombreMaterial}"/>
                                        </a4j:commandLink>
                                    </rich:column>
                                    <<rich:column>
                                        <h:outputText value="#{data.cantidad}"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="#{data.cantidadDisponibleAlmacen}">
                                            <f:convertNumber pattern="##0.00" locale="en"/>
                                        </h:outputText>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="#{data.unidadesMedida.nombreUnidadMedida}"/>
                                    </rich:column>
                                </rich:dataTable>
                            </div>
                            <br>
                            <a4j:commandButton value="Guardar" styleClass="btn" action="#{ManagedAprobacionSolicitudMantenimiento.generarSolicitudSalidaAlmacen_action}"
                                               oncomplete="if(#{ManagedAprobacionSolicitudMantenimiento.mensaje eq '1'}){alert('Se registro la solicitud de salida');Richfaces.hideModalPanel('panelGenerarSolicitudSalidaAlmacen');}else{alert('#{ManagedAprobacionSolicitudMantenimiento.mensaje}')}"
                                               reRender="dataSolicitudMantenimientoSolicitudSalida"/>
                            <a4j:commandButton value="Cancelar" styleClass="btn"
                                               oncomplete="Richfaces.hideModalPanel('panelGenerarSolicitudSalidaAlmacen')"/>
                            
                        </div>
                    </h:panelGroup>
                </a4j:form>
            </rich:modalPanel>


             
            <a4j:status id="statusPeticion"
                        onstart="Richfaces.showModalPanel('ajaxLoadingModalBox',{width:100, top:100})"
                        onstop="Richfaces.hideModalPanel('ajaxLoadingModalBox')">
            </a4j:status>

            <rich:modalPanel id="ajaxLoadingModalBox" minHeight="100"
                             minWidth="200" height="80" width="400" zindex="400" onshow="window.focus();">

                <div align="center">
                    <h:graphicImage value="../../../img/load2.gif" />
                </div>
            </rich:modalPanel>
         <h:panelGroup   id="panelsuper"  styleClass="panelSuper" style="visibility:hidden"  >
         </h:panelGroup>

        </body>
    </html>

</f:view>

