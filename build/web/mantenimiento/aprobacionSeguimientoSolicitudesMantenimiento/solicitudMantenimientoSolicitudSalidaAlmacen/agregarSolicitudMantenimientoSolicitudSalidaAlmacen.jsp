<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>
    
    <html>
        <head>
            <title></title>
            <link rel="STYLESHEET" type="text/css" href="../../../css/ventas.css" /> 
            <script type="text/javascript" src="../../../js/general.js" ></script> 
            <style type="text/css">
                a
                {
                    color: #5b61d5;
                    font-weight: bold;
                }
            </style>
            <script type="text/javascript">
                function validarBuscar()
                {
                    if(document.getElementById("formAgregarMaterialSolicitud:inputmaterialAgregar").value.length<=3)
                    {
                        alert('Debe introducir un texto mayor a 3 caracteres');
                        return false;
                    }
                    return true;
                }
            </script>
        </head>
        <body >
            <a4j:form id="form1">
                
                <div align="center">
                    <span class="outputTextTituloSistema">Agregar Solicitud Material Mantenimiento</span>
                    <h:outputText value="#{ManagedAprobacionSolicitudMantenimiento.cargarAgregarSolicitudMantenimientoSolicitudSalidaAlmacen}"/>
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
                            <h:outputText value="Descripción Solicitud" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:inputTextarea value="#{ManagedAprobacionSolicitudMantenimiento.solicitudMantenimientoSolicitudSalidaAlmacenAgregar.descripcion}" styleClass="inputText" cols="4" style="width:100%">
                                
                            </h:inputTextarea>
                        </h:panelGrid>
                    </rich:panel>
                    <br>
                    <rich:dataTable value="#{ManagedAprobacionSolicitudMantenimiento.solicitudMantenimientoSolicitudSalidaAlmacenAgregar.solicitudMantenimientoDetalleMaterialesList}"
                                    var="data"
                                    id="dataSolicitudMantenimientoSolicitudMateriales"
                                    headerClass="headerClassACliente">
                        <f:facet name="header">
                            <rich:columnGroup>
                                <rich:column >
                                    <h:outputText value=""/>
                                </rich:column>
                                <rich:column >
                                    <h:outputText value="Capítulo"/>
                                </rich:column>
                                <rich:column >
                                    <h:outputText value="Grupo"/>
                                </rich:column>
                                <rich:column >
                                    <h:outputText value="Material"/>
                                </rich:column>
                                <rich:column >
                                    <h:outputText value="Cantidad Disponible Almacen Mantenimiento"/>
                                </rich:column>
                                <rich:column >
                                    <h:outputText value="Cantidad Disponible Almacen Mantenimiento 2"/>
                                </rich:column>
                                <rich:column >
                                    <h:outputText value="Cantidad Disponible Otros Almacenes"/>
                                </rich:column>
                                <rich:column >
                                    <h:outputText value="Cantidad Solicitar"/>
                                </rich:column>
                                <rich:column >
                                    <h:outputText value="Unidad de Medida"/>
                                </rich:column>
                                
                            </rich:columnGroup>
                        </f:facet>
                        <rich:column>
                            <h:selectBooleanCheckbox value="#{data.checked}"/>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.materiales.grupo.capitulo.nombreCapitulo}"/>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.materiales.grupo.nombreGrupo}"/>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.materiales.nombreMaterial}"/>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.cantidadDisponibleAlmacen}">
                                <f:convertNumber pattern="##0.00" locale="en"/>
                            </h:outputText>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.cantidadDisponibleAlmacenMantenimiento2}">
                                <f:convertNumber pattern="##0.00" locale="en"/>
                            </h:outputText>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.cantidadDisponibleOtrosAlmacenes}" escape="false"/>
                        </rich:column>
                        <rich:column>
                            <h:inputText value="#{data.cantidad}" styleClass="inputText" onblur="valorPorDefecto(this)"/>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.unidadesMedida.nombreUnidadMedida}"/>
                        </rich:column>

                    </rich:dataTable>
                    <br>
                    <a4j:commandButton value="Agregar Material" styleClass="btn" 
                                       action="#{ManagedAprobacionSolicitudMantenimiento.agregarMaterialSolicitudSalidaAlmacen_action}"
                                               reRender="contenidoAgregarMaterialSolicitud"
                                               oncomplete="Richfaces.showModalPanel('panelAgregarMaterialSolicitud');"/>
                    <a4j:commandButton value="Eliminar Material" styleClass="btn" 
                                       action="#{ManagedAprobacionSolicitudMantenimiento.eliminarMaterialSolicitudSalidaAlmacen_action}"
                                               reRender="dataSolicitudMantenimientoSolicitudMateriales"/>
                    <a4j:commandButton value="Guardar Solicitud Materiales" styleClass="btn" 
                                       action="#{ManagedAprobacionSolicitudMantenimiento.guardarAgregarSolicitudMantenimientoSolicitudSalidaAlmacen}"
                                       oncomplete="if(#{ManagedAprobacionSolicitudMantenimiento.mensaje eq '1'})
                                       {alert('Se registro la solicitud');window.location.href='navegadorSolicitudMantenimientoSolicitudSalidaAlmacen.jsf?cancel='+(new Date()).getTime().toString();}
                                       else{alert('#{ManagedAprobacionSolicitudMantenimiento.mensaje}');}"/>
                    <a4j:commandButton value="Cancelar" styleClass="btn"
                                       oncomplete="window.location.href='navegadorSolicitudMantenimientoSolicitudSalidaAlmacen.jsf?cancel='+(new Date()).getTime().toString();"/>
                </div>
                
            </a4j:form>
            <rich:modalPanel id="panelAgregarMaterialSolicitud" 
                            minHeight="350"  minWidth="630" height="370" width="660"
                            zindex="200" headerClass="headerClassACliente"
                            resizeable="false" style="overflow :auto" >
                <f:facet name="header">
                    <h:outputText value="<center>Buscar Material para Agregar a la Solicitud</center>" escape="false"/>
                </f:facet>
                <a4j:form id="formAgregarMaterialSolicitud">
                    <h:panelGroup id="contenidoAgregarMaterialSolicitud">
                        <div align="center">
                            <h:panelGrid columns="4">
                                <h:outputText value="Material" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:panelGroup>
                                    <h:inputText required="true" requiredMessage="Debe ingresar un parametro de busquedad" validatorMessage="Debe ingresar 3 caracteres como minimo" value="#{ManagedAprobacionSolicitudMantenimiento.solicitudMantenimientoDetalleMaterialBuscar.materiales.nombreMaterial}" styleClass="inputText" id="inputmaterialAgregar">
                                        <f:validateLength minimum="3"/>
                                    </h:inputText>
                                    <br/>
                                    <h:message for="inputmaterialAgregar" styleClass="mensajeValidacion"/>
                                </h:panelGroup>
                                <a4j:commandButton value="BUSCAR" styleClass="btn" action="#{ManagedAprobacionSolicitudMantenimiento.buscarMaterialAgregarSolicitudSalidaAlmacen_action}"
                                                   reRender="contenidoAgregarMaterialSolicitud" />
                            </h:panelGrid>
                            <div style="height:240px;overflow-y: auto">
                                <rich:dataTable value="#{ManagedAprobacionSolicitudMantenimiento.solicitudMantenimientoDetalleMaterialesList}"
                                                var="data" binding="#{ManagedAprobacionSolicitudMantenimiento.solicitudMantenimientoDetalleMaterialesDataTable}"
                                                id="dataMaterialesAgregar"
                                                headerClass="headerClassACliente">
                                    <f:facet name="header">
                                        <rich:columnGroup>
                                            <rich:column  rowspan="2">
                                                <h:outputText value="Capítulo"/>
                                            </rich:column>
                                            <rich:column  rowspan="2">
                                                <h:outputText value="Grupo"/>
                                            </rich:column>
                                            <rich:column  rowspan="2">
                                                <h:outputText value="Material"/>
                                            </rich:column>
                                            <rich:column  colspan="3">
                                                <h:outputText value="Cantidad Disponible "/>
                                            </rich:column>
                                            <rich:column  rowspan="2">
                                                <h:outputText value="Unidad de Medida"/>
                                            </rich:column>
                                            <rich:column breakBefore="true">
                                                <h:outputText value="Almacen Mantenimiento"/>
                                            </rich:column>
                                            <rich:column >
                                                <h:outputText value="Almacen Mantenimiento 2"/>
                                            </rich:column>
                                            <rich:column >
                                                <h:outputText value="Otros Almacenes"/>
                                            </rich:column>
                                        </rich:columnGroup>
                                    </f:facet>
                                    <rich:column>
                                        <h:outputText value="#{data.materiales.grupo.capitulo.nombreCapitulo}"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="#{data.materiales.grupo.nombreGrupo}"/>
                                    </rich:column>
                                    <rich:column>
                                        <a4j:commandLink action="#{ManagedAprobacionSolicitudMantenimiento.seleccionarAgregarSolicitudMantenimientoSalida_action}"
                                                         oncomplete="Richfaces.hideModalPanel('panelAgregarMaterialSolicitud')" reRender="dataSolicitudMantenimientoSolicitudMateriales">
                                            <h:outputText value="#{data.materiales.nombreMaterial}"/>
                                        </a4j:commandLink>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="#{data.cantidadDisponibleAlmacen}">
                                            <f:convertNumber pattern="##0.00" locale="en"/>
                                        </h:outputText>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="#{data.cantidadDisponibleAlmacenMantenimiento2}">
                                            <f:convertNumber pattern="##0.00" locale="en"/>
                                        </h:outputText>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="#{data.cantidadDisponibleOtrosAlmacenes}" escape="false"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="#{data.unidadesMedida.nombreUnidadMedida}"/>
                                    </rich:column>
                                </rich:dataTable>
                            </div>
                            <br>
                            <a4j:commandButton value="Cancelar" styleClass="btn"
                                               oncomplete="Richfaces.hideModalPanel('panelAgregarMaterialSolicitud')"/>
                            
                        </div>
                    </h:panelGroup>
                </a4j:form>
            </rich:modalPanel>
            <a4j:status id="statusPeticion"
                        onstart="Richfaces.showModalPanel('ajaxLoadingModalBox',{width:100, top:100})"
                        onstop="Richfaces.hideModalPanel('ajaxLoadingModalBox')">
            </a4j:status>

            <rich:modalPanel id="ajaxLoadingModalBox" minHeight="100"
                             minWidth="200" height="80" width="400" zindex="300" onshow="window.focus();">

                <div align="center">
                    <h:graphicImage value="../../img/load2.gif" />
                </div>
            </rich:modalPanel>
        </body>
        
    </html>
    
</f:view>

