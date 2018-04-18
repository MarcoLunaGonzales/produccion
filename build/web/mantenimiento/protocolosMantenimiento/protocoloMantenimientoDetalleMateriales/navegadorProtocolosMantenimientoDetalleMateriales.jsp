<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>
<f:view>
    
    <html>
        <head>
            <title>Protocolos Mantenimiento</title>
            <link rel="STYLESHEET" type="text/css" href="../../../css/ventas.css" />
            <script type="text/javascript" src="../../../js/general.js" ></script>
            <script type="text/javascript">
                function validarEditarMaterial()
                {
                    return validarMayorACero(document.getElementById("formEditarMaterialSolicitud:cantidadMaterial"));
                }
                function validarAgregarMaterial()
                {
                    if(alMenosUno("formAgregarMaterialSolicitud:dataMaterialesAgregar"))
                    {
                        var dataDetalle=document.getElementById("formAgregarMaterialSolicitud:dataMaterialesAgregar").getElementsByTagName("tbody")[0];
                        for(var i=0;i<dataDetalle.rows.length;i++)
                        {
                            if(dataDetalle.rows[i].cells[0].getElementsByTagName("input")[0].checked)
                            {
                                if(!validarMayorACero(dataDetalle.rows[i].cells[4].getElementsByTagName("input")[0]))
                                {
                                    return false;
                                }
                            }
                        }
                        return true;
                    }
                    else
                        return false;
                }
            </script>
        </head>
        <body >
        <a4j:form id="form1">
            <div align="center">
                <h:outputText value="Protocolo Mantenimiento Detalle Tareas" styleClass="outputTextTituloSistema"/>
                <h:outputText value="#{ManagedProtocoloMantenimiento.cargarProtocoloMantenimientoVersionDetalleManterialesList}"  />
                <rich:panel headerClass="headerClassACliente" style="width:70%">
                    <f:facet name="header">
                        <h:outputText value="Protocolo Mantenimiento"/>
                    </f:facet>
                    <h:panelGrid columns="6">
                        
                        <h:outputText value="Maquinaria" styleClass="outputTextBold"/>
                        <h:outputText value="::" styleClass="outputTextBold"/>
                        <h:outputText value="#{ManagedProtocoloMantenimiento.protocoloMantenimientoBean.protocoloMantenimiento.maquinaria.nombreMaquina}" styleClass="outputText2"/>
                        <h:outputText value="Parte Maquinaria" styleClass="outputTextBold"/>
                        <h:outputText value="::" styleClass="outputTextBold"/>
                        <h:outputText value="#{ManagedProtocoloMantenimiento.protocoloMantenimientoBean.protocoloMantenimiento.partesMaquinaria.nombreParteMaquina}" styleClass="outputText2"/>
                        <h:outputText value="Descripción" styleClass="outputTextBold"/>
                        <h:outputText value="::" styleClass="outputTextBold"/>
                        <h:outputText value="#{ManagedProtocoloMantenimiento.protocoloMantenimientoVersionBean.descripcionProtocoloMantenimientoVersion}" styleClass="outputText2"/>
                        <h:outputText value="Tipo Mantenimiento" styleClass="outputTextBold"/>
                        <h:outputText value="::" styleClass="outputTextBold"/>
                        <h:outputText value="#{ManagedProtocoloMantenimiento.protocoloMantenimientoVersionBean.tiposMantenimientoMaquinaria.nombreTipoMantenimientoMaquinaria}" styleClass="outputText2"/>
                        <h:outputText value="Estado Protocolo" styleClass="outputTextBold"/>
                        <h:outputText value="::" styleClass="outputTextBold"/>
                        <h:outputText value="#{ManagedProtocoloMantenimiento.protocoloMantenimientoVersionBean.estadoRegistro.nombreEstadoRegistro}" styleClass="outputText2"/>
                        <h:outputText value="Nro Versión" styleClass="outputTextBold"/>
                        <h:outputText value="::" styleClass="outputTextBold"/>
                        <h:outputText value="#{ManagedProtocoloMantenimiento.protocoloMantenimientoVersionBean.nroVersion}" styleClass="outputText2"/>
                    </h:panelGrid>
                </rich:panel>
                <br>
                <rich:dataTable value="#{ManagedProtocoloMantenimiento.protocoloMantenimientoVersionDetalleMaterialList}"
                                    var="data" id="dataProtocoloMantenimientoDetalleMateriales"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente">
                        <f:facet name="header">
                            <rich:columnGroup>
                                <rich:column >
                                    <h:outputText value=""/>
                                </rich:column>
                                <rich:column >
                                    <h:outputText value="Capitulo"/>
                                </rich:column>
                                <rich:column >
                                    <h:outputText value="Grupo"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Material"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Cantidad"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Unidad de Medida"/>
                                </rich:column>
                                
                            </rich:columnGroup>
                        </f:facet>
                        <rich:column>
                            <h:selectBooleanCheckbox value="#{data.checked}"/>
                        </rich:column>
                        
                        <rich:column>
                            <h:outputText value="#{data.materiales.grupo.capitulo.nombreCapitulo}"  />
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.materiales.grupo.nombreGrupo}"  />
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.materiales.nombreMaterial}"  />
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.cantidadMaterial}" />
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.unidadesMedida.nombreUnidadMedida}"/>
                        </rich:column>
                        
                    </rich:dataTable>
                    
                    <br>
                    <div class="barraBotones" id="bottonesAcccion">
                        <a4j:commandButton value="Agregar" styleClass="btn" 
                                           action="#{ManagedProtocoloMantenimiento.agregarMaterialProtocoloMantenimientoVersionDetalleMaterial_action}"
                                                   reRender="contenidoAgregarMaterialSolicitud"
                                                   oncomplete="Richfaces.showModalPanel('panelAgregarMaterialSolicitud');"/>
                        <a4j:commandButton value="Editar" styleClass="btn" action="#{ManagedProtocoloMantenimiento.editarProtocoloMantenimientoDetalleMaterial_action}"
                                            reRender="contenidoEditarProtocoloMaterial"
                                            onclick="if(!editarItem('form1:dataProtocoloMantenimientoDetalleMateriales')){return false}"
                                            oncomplete="Richfaces.showModalPanel('panelEditarProtocoloMaterial');"/>
                        <a4j:commandButton value="Eliminar" styleClass="btn" action="#{ManagedProtocoloMantenimiento.eliminarProtocoloMantenimientoDetalleMateriales_action}"
                                           onclick="if(!editarItem('form1:dataProtocoloMantenimientoDetalleMateriales')){return false}"
                                           oncomplete="if(#{ManagedProtocoloMantenimiento.mensaje eq '1'}){alert('Se elimino el material');}else{alert('#{ManagedProtocoloMantenimiento.mensaje}')}"
                                           reRender="dataProtocoloMantenimientoDetalleMateriales"/>
                        <a4j:commandButton value="Cancelar" styleClass="btn" 
                                               oncomplete="redireccionar('../navegadorProtocolosMantenimientoVersion.jsf');"/>
                    </div>
                </div>
            </a4j:form>
            <rich:modalPanel id="panelAgregarMaterialSolicitud" 
                            minHeight="350"  minWidth="630" height="350" width="630"
                            zindex="100" headerClass="headerClassACliente"
                            resizeable="false" style="overflow :auto" >
                <f:facet name="header">
                    <h:outputText value="<center>Agregar Materiales</center>" escape="false"/>
                </f:facet>
                <a4j:form id="formAgregarMaterialSolicitud">
                    <h:panelGroup id="contenidoAgregarMaterialSolicitud">
                        <div align="center">
                            <h:panelGrid columns="4">
                                <h:outputText value="Material" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:inputText value="#{ManagedProtocoloMantenimiento.protocoloMantenimientoVersionDetalleMaterialAgregar.materiales.nombreMaterial}" styleClass="inputText" id="inputmaterialAgregar"/>
                                <a4j:commandButton value="BUSCAR" styleClass="btn" action="#{ManagedProtocoloMantenimiento.buscarMaterialesAgregarList_action}"
                                                   reRender="dataMaterialesAgregar" />
                            </h:panelGrid>
                            <div style="height:240px;overflow-y: auto">
                                <rich:dataTable value="#{ManagedProtocoloMantenimiento.protocoloMantenimientoVersionDetalleMaterialesAgregarList}"
                                                var="data" 
                                                id="dataMaterialesAgregar"
                                                headerClass="headerClassACliente">
                                    <f:facet name="header">
                                        <rich:columnGroup>
                                            <rich:column>
                                                <h:outputText value=""/>
                                            </rich:column>
                                            <rich:column>
                                                <h:outputText value="Capítulo"/>
                                            </rich:column>
                                            <rich:column>
                                                <h:outputText value="Grupo"/>
                                            </rich:column>
                                            <rich:column>
                                                <h:outputText value="Material"/>
                                            </rich:column>
                                            <rich:column>
                                                <h:outputText value="Cantidad"/>
                                            </rich:column>
                                            <rich:column>
                                                <h:outputText value="U.M"/>
                                            </rich:column>
                                        </rich:columnGroup>
                                    </f:facet>
                                    <rich:column>
                                        <h:selectBooleanCheckbox value="#{data.checked}" onclick="seleccionarRegistro(this)"/>
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
                                        <h:inputText styleClass="inputText" value="#{data.cantidadMaterial}" onblur="valorPorDefecto(this)" style="width:4em"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="#{data.unidadesMedida.nombreUnidadMedida}"/>
                                    </rich:column>
                                </rich:dataTable>
                            </div>
                            <br>
                            <a4j:commandButton value="Guardar" styleClass="btn" 
                                               reRender="dataProtocoloMantenimientoDetalleMateriales"
                                               onclick="if(!validarAgregarMaterial()){return false;}"
                                               action="#{ManagedProtocoloMantenimiento.guardarAgregarProtocoloMantenimientoDetalleMateriales_action}"
                                               oncomplete="if(#{ManagedProtocoloMantenimiento.mensaje eq '1'}){alert('Se agregaron los materiales al protocolo');Richfaces.hideModalPanel('panelAgregarMaterialSolicitud')}
                                               else{alert('#{ManagedProtocoloMantenimiento.mensaje}');}"/>
                            <a4j:commandButton value="Cancelar" styleClass="btn"
                                               oncomplete="Richfaces.hideModalPanel('panelAgregarMaterialSolicitud')"/>
                            
                        </div>
                    </h:panelGroup>
                </a4j:form>
            </rich:modalPanel>
            <rich:modalPanel id="panelEditarProtocoloMaterial" 
                            minHeight="220"  minWidth="500" height="220" width="500"
                            zindex="200" headerClass="headerClassACliente"
                            resizeable="false" style="overflow :auto" >
                <f:facet name="header">
                    <h:outputText value="<center>Edición de Material</center>" escape="false"/>
                </f:facet>
                <a4j:form id="formEditarMaterialSolicitud">
                    <h:panelGroup id="contenidoEditarProtocoloMaterial">
                        <div align="center">
                            <h:panelGrid columns="3">
                                <h:outputText value="Capitulo" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:outputText value="#{ManagedProtocoloMantenimiento.protocoloMantenimientoVersionDetalleMaterialEditar.materiales.grupo.capitulo.nombreCapitulo}" styleClass="outputText2"/>
                                <h:outputText value="Grupo" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:outputText value="#{ManagedProtocoloMantenimiento.protocoloMantenimientoVersionDetalleMaterialEditar.materiales.grupo.nombreGrupo}" styleClass="outputText2"/>
                                <h:outputText value="Material" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:outputText value="#{ManagedProtocoloMantenimiento.protocoloMantenimientoVersionDetalleMaterialEditar.materiales.nombreMaterial}" styleClass="outputText2"/>
                                <h:outputText value="Cantidad" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:inputText value="#{ManagedProtocoloMantenimiento.protocoloMantenimientoVersionDetalleMaterialEditar.cantidadMaterial}" styleClass="inputText" id="cantidadMaterial" onblur="valorPorDefecto(this)"/>
                                <h:outputText value="Unidad de Medida" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:outputText value="#{ManagedProtocoloMantenimiento.protocoloMantenimientoVersionDetalleMaterialEditar.unidadesMedida.nombreUnidadMedida}" styleClass="outputText2"/>
                            </h:panelGrid>
                            <br>
                            <a4j:commandButton value="Guardar" styleClass="btn" action="#{ManagedProtocoloMantenimiento.guardarEditarProtocoloMantenimientoDetalleMaterial_action}"
                                               onclick="if(!validarEditarMaterial()){return false}"
                                               oncomplete="if(#{ManagedProtocoloMantenimiento.mensaje eq '1'}){alert('Se guardo la edición');Richfaces.hideModalPanel('panelEditarProtocoloMaterial');}
                                               else{alert('#{ManagedProtocoloMantenimiento.mensaje}');}" reRender="dataProtocoloMantenimientoDetalleMateriales"/>
                            <a4j:commandButton value="Cancelar" styleClass="btn"
                                               oncomplete="Richfaces.hideModalPanel('panelEditarProtocoloMaterial')"/>
                            
                        </div>
                    </h:panelGroup>
                </a4j:form>
            </rich:modalPanel>
            
            
            
            <a4j:status id="statusPeticion"
                        onstart="Richfaces.showModalPanel('ajaxLoadingModalBox',{width:100, top:100})"
                        onstop="Richfaces.hideModalPanel('ajaxLoadingModalBox')">
            </a4j:status>

            <rich:modalPanel id="ajaxLoadingModalBox" minHeight="100"
                             minWidth="200" height="80" width="400" zindex="100" onshow="window.focus();">

                <div align="center">
                    <h:graphicImage value="../../../img/load2.gif" />
                </div>
            </rich:modalPanel>
            
        </body>
    </html>
    
</f:view>

