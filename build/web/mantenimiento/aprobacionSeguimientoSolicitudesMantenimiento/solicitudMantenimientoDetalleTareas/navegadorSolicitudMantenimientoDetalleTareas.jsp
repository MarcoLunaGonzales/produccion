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
       </script>
        </head>
        <body >
            <a4j:form id="form1">
                <div align="center">
                    <span class="outputTextTituloSistema">Listado de Tareas Asignado a personal</span>
                    <h:outputText value="#{ManagedAprobacionSolicitudMantenimiento.cargarSolicitudMantemientoDetalleTareas}"/>
                    
                        <rich:panel headerClass="headerClassACliente" style="width:80%">
                            <f:facet name="header">
                                    <h:outputText value="Datos Solicitud Mantenimiento"/>
                            </f:facet>
                            <h:panelGrid columns="6">
                                <h:outputText value="Nro. O.T." styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:outputText value="#{ManagedAprobacionSolicitudMantenimiento.solicitudMantenimientoTarea.nroOrdenTrabajo}" styleClass="outputText2"/>
                                <h:outputText value="Area Empresa" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:outputText value="#{ManagedAprobacionSolicitudMantenimiento.solicitudMantenimientoTarea.areasEmpresa.nombreAreaEmpresa}" styleClass="outputText2"/>
                                <h:outputText value="Maquinaria" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:outputText value="#{ManagedAprobacionSolicitudMantenimiento.solicitudMantenimientoTarea.maquinaria.nombreMaquina}" styleClass="outputText2"/>
                                <h:outputText value="Instalación" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:outputText value="#{ManagedAprobacionSolicitudMantenimiento.solicitudMantenimientoTarea.areasInstalaciones.nombreAreaInstalacion}" styleClass="outputText2"/>
                                <h:outputText value="Solicitante" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:outputText value="#{ManagedAprobacionSolicitudMantenimiento.solicitudMantenimientoTarea.personal_usuario.nombrePersonal}" styleClass="outputText2"/>
                                <h:outputText value="Tipo Solicitud Mantenimiento" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:outputText value="#{ManagedAprobacionSolicitudMantenimiento.solicitudMantenimientoTarea.tiposSolicitudMantenimiento.nombreTipoSolicitud}" styleClass="outputText2"/>
                                <h:outputText value="Fecha Solicitud" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:outputText value="#{ManagedAprobacionSolicitudMantenimiento.solicitudMantenimientoTarea.fechaSolicitudMantenimiento}" styleClass="outputText2">
                                    <f:convertDateTime pattern="dd/MM/yyyy"/>
                                </h:outputText>
                                <h:outputText value="Fecha Aprobación" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:outputText value="#{ManagedAprobacionSolicitudMantenimiento.solicitudMantenimientoTarea.fechaAprobacion}" styleClass="outputText2">
                                    <f:convertDateTime pattern="dd/MM/yyyy"/>
                                </h:outputText>
                                <h:outputText value="Estado Solicitud" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:outputText value="#{ManagedAprobacionSolicitudMantenimiento.solicitudMantenimientoTarea.estadoSolicitudMantenimiento.nombreEstadoSolicitudMantenimiento}" styleClass="outputText2"/>
                            </h:panelGrid>
                        </rich:panel>
                    <br>
                    <rich:dataTable value="#{ManagedAprobacionSolicitudMantenimiento.solicitudMantenimientoDetalleTareasList}" var="data"
                                    id="dataSolicitudMantenimientoDetalleTareas"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente" binding="#{ManagedAprobacionSolicitudMantenimiento.solicitudMantenimientoDetalleTareasDataTable}" >
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value=""  />
                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.checked}"  />
                        </h:column>
                        
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Tipo Tarea"  />
                            </f:facet>
                            <h:outputText value="#{data.tiposTarea.nombreTipoTarea}" />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Personal "  />
                            </f:facet>
                            <h:outputText value="#{data.personal.nombrePersonal}" />
                            <h:outputText value=" " />
                            <h:outputText value="#{data.personal.apPaternoPersonal}" />
                            <h:outputText value=" " />
                            <h:outputText value="#{data.personal.apMaternoPersonal}" />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Proveedor"  />
                            </f:facet>
                            <h:outputText value="#{data.proveedores.nombreProveedor}" />
                        </h:column>

                    </rich:dataTable>
                    <br>
                    <a4j:commandButton value="Agregar" styleClass="btn" action="#{ManagedAprobacionSolicitudMantenimiento.agregarSolicitudMantenimientoDetalleTarea_action}"
                                       oncomplete="Richfaces.showModalPanel('panelAgregarSolicitudMantenimientoDetalleTareas')"
                                       reRender="contenidoAgregarSolicitudMantenimientoDetalleTareas"/>
                    <a4j:commandButton value="Eliminar"  styleClass="btn"
                                       onclick="if(!editarItem('form1:dataSolicitudMantenimientoDetalleTareas')){return false;}else{if(!confirm('Esta Seguro de eliminar la asignacion de tareas?')){return false;}}"
                                       action="#{ManagedAprobacionSolicitudMantenimiento.eliminarSolicitudMantenimientoDetalleTarea_action}"
                                       reRender="dataSolicitudMantenimientoDetalleTareas"
                                       oncomplete="if(#{ManagedAprobacionSolicitudMantenimiento.mensaje eq '1'}){alert('Se elimino la tarea');}else{alert('#{ManagedAprobacionSolicitudMantenimiento.mensaje}')}"
                                        />
                    <a4j:commandButton value="Volver" styleClass="btn" oncomplete="window.location.href='../navegadorAprobacionSolicitudesMantenimiento.jsf?cancel='+(new Date()).getTime().toString()"/>

                </div>
            </a4j:form>



             <rich:modalPanel id="panelAgregarSolicitudMantenimientoDetalleTareas" minHeight="250"  minWidth="800"
                                     height="250" width="800"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="<center>Agregar Tarea</center>" escape="false"/>
                        </f:facet>
                        <a4j:form id="form2">
                            <h:panelGroup id="contenidoAgregarSolicitudMantenimientoDetalleTareas">
                                <a4j:jsFunction reRender="panelAgregarPersonal" name="cambioTipoAsignacion"/>
                                <div align="center">
                                    <h:panelGrid columns="3" styleClass="navegadorTabla" >

                                        <h:outputText  value="Tipo de Trabajo" styleClass="outputTextBold"  />
                                        <h:outputText styleClass="outputTextBold" value="::"  />
                                        <h:selectOneMenu  styleClass="inputText" value="#{ManagedAprobacionSolicitudMantenimiento.solicitudMantenimientoDetalleTareaAgregar.tiposTarea.codTipoTarea}">
                                            <f:selectItems value="#{ManagedAprobacionSolicitudMantenimiento.tiposTareaSelectList}"/>
                                        </h:selectOneMenu>

                                        <h:outputText  value="" styleClass="outputText2"  />
                                        <h:outputText value="" styleClass="outputText2"   />
                                        <h:selectOneRadio value="#{ManagedAprobacionSolicitudMantenimiento.solicitudMantenimientoDetalleTareaAgregar.tareaPersonalExterno}" id="asignado" styleClass="outputText2" onclick="cambioTipoAsignacion();" >
                                            <f:selectItem id='false' itemLabel="Personal Asignado" itemValue='false'/>
                                            <f:selectItem id='true' itemLabel="Proovedor Asignado" itemValue='true' />
                                        </h:selectOneRadio>

                                        <h:outputText  value="Personal Asignado" styleClass="outputTextBold"  />
                                        <h:outputText styleClass="outputTextBold" value="::"  />
                                        <h:panelGrid id="panelAgregarPersonal">

                                            <h:selectManyListbox id="selectPersonal" style="height:6em" styleClass="inputText" value="#{ManagedAprobacionSolicitudMantenimiento.codPersonalAgregarAsignar}"
                                                                 rendered="#{!ManagedAprobacionSolicitudMantenimiento.solicitudMantenimientoDetalleTareaAgregar.tareaPersonalExterno}">
                                                <f:selectItems value="#{ManagedAprobacionSolicitudMantenimiento.personalSelectList}"/>
                                            </h:selectManyListbox>

                                            <h:selectOneMenu id="selectProovedor" styleClass="inputText" value="#{ManagedAprobacionSolicitudMantenimiento.solicitudMantenimientoDetalleTareaAgregar.proveedores.codProveedor}"
                                                             rendered="#{ManagedAprobacionSolicitudMantenimiento.solicitudMantenimientoDetalleTareaAgregar.tareaPersonalExterno}">
                                                <f:selectItems value="#{ManagedAprobacionSolicitudMantenimiento.proveedoresSelectList}"/>
                                            </h:selectOneMenu>
                                        </h:panelGrid>



                                    </h:panelGrid>
                                    
                                    <a4j:commandButton value="Guardar" styleClass="btn" action="#{ManagedAprobacionSolicitudMantenimiento.guardarAgregarSolicitudMantenimientoDetalleTarea_action}"
                                                       reRender="dataSolicitudMantenimientoDetalleTareas"
                                                       oncomplete="if(#{ManagedAprobacionSolicitudMantenimiento.mensaje eq '1'}){alert('Se registraron las tareas');Richfaces.hideModalPanel('panelAgregarSolicitudMantenimientoDetalleTareas');}
                                                       else{alert('#{ManagedAprobacionSolicitudMantenimiento.mensaje}')}"/>
                                    <a4j:commandButton value="Cancelar"  styleClass="btn" oncomplete="Richfaces.hideModalPanel('panelAgregarSolicitudMantenimientoDetalleTareas')"/>
                                </div>

                            </h:panelGroup>
                        </a4j:form>
            </rich:modalPanel>

            <rich:modalPanel id="panelEditarSolicitudMantenimientoDetalleTareas"  minHeight="250"  minWidth="800"
                                     height="250" width="800"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Editar Fase Formula Maestra"/>
                        </f:facet>
                        <a4j:form id="form3">
                        <h:panelGroup id="contenidoEditarSolicitudMantenimientoDetalleTareas">

                                <h:panelGrid columns="3" styleClass="navegadorTabla" >

                                    <h:outputText  value="Tipo de Trabajo" styleClass="outputText2"  />
                                    <h:outputText styleClass="outputText2" value="::"  />

                                    <h:selectOneMenu  styleClass="inputText" value="#{ManagedAprobacionSolicitudMantenimiento.solicitudMantenimientoDetalleTareas.tiposTarea.codTipoTarea}">
                                        <f:selectItems value="#{ManagedAprobacionSolicitudMantenimiento.tiposTareasList}"/>
                                    </h:selectOneMenu>


                                    <h:outputText value="Descripción" styleClass="outputText2"   />
                                    <h:outputText styleClass="outputText2" value="::"  />
                                    <h:inputTextarea styleClass="inputText" rows="2" cols="38"  value="#{ManagedAprobacionSolicitudMantenimiento.solicitudMantenimientoDetalleTareas.descripcion}"/>

                                    <h:outputText  value="" styleClass="outputText2"  />
                                    <h:outputText value="" styleClass="outputText2"   />
                                    <h:selectOneRadio value="#{ManagedAprobacionSolicitudMantenimiento.enteAsignado}" id="asignado" styleClass="outputText2" onclick="javascript:seleccionarAsignado3();" >
                                        <f:selectItem id="item1" itemLabel="Personal Asignado" itemValue="interno"/>
                                        <f:selectItem id="item2" itemLabel="Proovedor Asignado" itemValue="externo" />
                                    </h:selectOneRadio>

                                    <h:outputText  value="Personal Asignado" styleClass="outputText2"  />
                                    <h:outputText styleClass="outputText2" value="::"  />
                                    <h:panelGrid>
                                        <h:selectOneMenu id="selectPersonal" styleClass="inputText" value="#{ManagedAprobacionSolicitudMantenimiento.solicitudMantenimientoDetalleTareas.personal.codPersonal}">
                                            <f:selectItems value="#{ManagedAprobacionSolicitudMantenimiento.personalList}"/>
                                        </h:selectOneMenu>
                                        <h:selectOneMenu id="selectProovedor" styleClass="inputText" value="#{ManagedAprobacionSolicitudMantenimiento.solicitudMantenimientoDetalleTareas.proveedores.codProveedor}">
                                            <f:selectItems value="#{ManagedAprobacionSolicitudMantenimiento.proovedorList}"/>
                                        </h:selectOneMenu>
                                    </h:panelGrid>

                                    <h:outputText  value="Fecha Inicial" styleClass="outputText2"  />
                                    <h:outputText styleClass="outputText2" value="::"  />
                                    <h:inputText value="#{ManagedAprobacionSolicitudMantenimiento.solicitudMantenimientoDetalleTareas.fechaInicial}" styleClass="inputText" onblur="validaFecha(this)" >
                                        <f:convertDateTime pattern="dd/MM/yyyy hh:mm" />
                                    </h:inputText>


                                 
                                    
                                </h:panelGrid>
                                <div align="center">

                                <a4j:commandButton value="Guardar" styleClass="btn"  action="#{ManagedAprobacionSolicitudMantenimiento.guardarEdicionSolicitudMantenimientoDetalleTareas_action}"
                                oncomplete="javascript:Richfaces.hideModalPanel('panelEditarSolicitudMantenimientoDetalleTareas')"
                                reRender="dataSolicitudMantenimientoDetalleTareas" />
                                <a4j:commandButton value="Cancelar"  styleClass="btn" onclick="javascript:Richfaces.hideModalPanel('panelEditarSolicitudMantenimientoDetalleTareas')" />
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

