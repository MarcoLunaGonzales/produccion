<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>
<f:view>
    
    <html>
        <head>
            <title>Solicitudes Mantenimiento</title>
            <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
            <script type="text/javascript" src="../../js/general.js" ></script>
            <script type="text/javascript">
                function verReporteSolicitudMantenimiento(codSolicitudMantenimiento)
                {
                       window.open('../reporteSolicitudMantenimientoOT.jsf?codSolicitudMantenimiento='+codSolicitudMantenimiento+
                                    '&data='+(new Date()).getTime().toString()
                                    ,'solicitud'+(new Date()).getTime().toString(),
                                    'top=50,left=200,width=800,height=600,scrollbars=1,resizable=1');
                }
                
            </script>
        </head>
        <a4j:form id="form1">
            <div align="center">
                <span class="outputTextTituloSistema">Solicitudes de Mantenimiento</span>
                <h:outputText value="#{ManagedAprobacionSolicitudMantenimiento.cargarSolicitudMantenimientoAprobacionList}"  />
                <rich:panel headerClass="headerClassACliente" style="width:80%">
                    <f:facet name="header">
                        <h:outputText value="Buscador"/>
                    </f:facet>
                    <h:panelGrid columns="6">
                        <h:outputText value="Nro. de Solicitud" styleClass="outputTextBold"/>
                        <h:outputText value="::" styleClass="outputTextBold"/>
                        <h:inputText value="#{ManagedAprobacionSolicitudMantenimiento.solicitudMantenimientoBuscar.codSolicitudMantenimiento}" styleClass="inputText" onblur="valorPorDefecto(this);"/>
                        <h:outputText value="Nro. de O.T." styleClass="outputTextBold"/>
                        <h:outputText value="::" styleClass="outputTextBold"/>
                        <h:inputText value="#{ManagedAprobacionSolicitudMantenimiento.solicitudMantenimientoBuscar.nroOrdenTrabajo}" styleClass="inputText" onblur="valorPorDefecto(this);"/>
                        <h:outputText value="Area Empresa" styleClass="outputTextBold"/>
                        <h:outputText value="::" styleClass="outputTextBold"/>
                        <h:selectOneMenu value="#{ManagedAprobacionSolicitudMantenimiento.solicitudMantenimientoBuscar.areasEmpresa.codAreaEmpresa}" styleClass="inputText">
                            <f:selectItem itemValue="0" itemLabel="--TODOS--"/>
                            <f:selectItems value="#{ManagedAprobacionSolicitudMantenimiento.areasEmpresaSelectList}"/>
                            <a4j:support event="onchange" action="#{ManagedAprobacionSolicitudMantenimiento.codAreaEmpresaBuscar_change}" reRender="codMaquinariaBuscar"/>
                        </h:selectOneMenu>
                        <h:outputText value="Maquinaria" styleClass="outputTextBold"/>
                        <h:outputText value="::" styleClass="outputTextBold"/>
                        <h:selectOneMenu value="#{ManagedAprobacionSolicitudMantenimiento.solicitudMantenimientoBuscar.maquinaria.codMaquina}" styleClass="inputText" id="codMaquinariaBuscar">
                            <f:selectItem itemValue="0" itemLabel="--TODOS--"/>
                            <f:selectItems value="#{ManagedAprobacionSolicitudMantenimiento.maquinariaSelectList}"/>
                        </h:selectOneMenu>
                        <h:outputText value="Prioridad" styleClass="outputTextBold"/>
                        <h:outputText value="::" styleClass="outputTextBold"/>
                        <h:selectOneMenu value="#{ManagedAprobacionSolicitudMantenimiento.solicitudMantenimientoBuscar.tiposNivelSolicitudMantenimiento.codTipoNivelSolicitudMantenimiento}" styleClass="inputText">
                            <f:selectItem itemValue='0' itemLabel="--TODOS--"/>
                            <f:selectItems value="#{ManagedAprobacionSolicitudMantenimiento.tiposNivelSolicitudMantenimientoSelectList}"/>
                        </h:selectOneMenu>
                        <h:outputText value="Tipo Solicitud" styleClass="outputTextBold"/>
                        <h:outputText value="::" styleClass="outputTextBold"/>
                        <h:selectOneMenu value="#{ManagedAprobacionSolicitudMantenimiento.solicitudMantenimientoBuscar.tiposSolicitudMantenimiento.codTipoSolicitud}" styleClass="inputText">
                            <f:selectItem itemValue='0' itemLabel="--TODOS--"/>
                            <f:selectItems value="#{ManagedAprobacionSolicitudMantenimiento.tiposSolicitudMantenimientoSelectList}"/>
                        </h:selectOneMenu>
                        <h:outputText value="Estado Solicitud" styleClass="outputTextBold"/>
                        <h:outputText value="::" styleClass="outputTextBold"/>
                        <h:selectOneMenu value="#{ManagedAprobacionSolicitudMantenimiento.solicitudMantenimientoBuscar.estadoSolicitudMantenimiento.codEstadoSolicitudMantenimiento}" styleClass="inputText">
                            <f:selectItem itemValue='0' itemLabel="--TODOS--"/>
                            <f:selectItems value="#{ManagedAprobacionSolicitudMantenimiento.estadosSolicitudMantenimientoSelectList}"/>
                        </h:selectOneMenu>
                        <h:outputText value="Personal Solicitante" styleClass="outputTextBold"/>
                        <h:outputText value="::" styleClass="outputTextBold"/>
                        <h:selectOneMenu value="#{ManagedAprobacionSolicitudMantenimiento.solicitudMantenimientoBuscar.personal_usuario.codPersonal}" styleClass="inputText">
                            <f:selectItem itemValue="0" itemLabel="--TODOS--"/>
                            <f:selectItems value="#{ManagedAprobacionSolicitudMantenimiento.personalSolicitudMantenimientoSelectList}"/>
                        </h:selectOneMenu>
                    </h:panelGrid>
                    <a4j:commandButton value="BUSCAR" styleClass="btn" reRender="dataSolicitudMantenimiento,controles"
                                       action="#{ManagedAprobacionSolicitudMantenimiento.buscarSolicitudMantenimientoAprobacion_action}"/>
                </rich:panel>
                <br>
                <rich:dataTable value="#{ManagedAprobacionSolicitudMantenimiento.solicitudMantenimientoAprobacionList}"
                                    var="data" id="dataSolicitudMantenimiento"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    binding="#{ManagedAprobacionSolicitudMantenimiento.solicitudMantenimientoAprobacionDataTable}"
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
                                    <h:outputText value="Solicitante"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Fecha Emisión"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Fecha Aprobación<br>Solicitud" escape="false"/>
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
                                    <h:outputText value="Descripción Estado"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Estado Solicitud"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Tipo Solicitud"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Describir<br>Estado" escape="false"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Cerrar<br>OT" escape="false"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Tareas"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Materiales"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Detalle"/>
                                </rich:column>
                            </rich:columnGroup>
                        </f:facet>
                        <rich:column  >
                            <h:selectBooleanCheckbox value="#{data.checked}" rendered="#{data.estadoSolicitudMantenimiento.codEstadoSolicitudMantenimiento=='1'}"  />
                        </rich:column >
                        <rich:column  >
                            <h:outputText value="#{data.codSolicitudMantenimiento}"  />
                        </rich:column >
                        <rich:column  >
                            <h:outputText value="#{data.nroOrdenTrabajo}" rendered="#{data.nroOrdenTrabajo>'0'}" />
                            <h:outputText  rendered="#{data.solicitudProyecto eq '1' && data.nroOrdenTrabajo>'0'}" value="-PROY"  />
                            <h:outputText  rendered="#{data.solicitudProduccion eq '1' && data.nroOrdenTrabajo>'0'}" value="-PROD"  />
                        </rich:column >
                        <rich:column>
                            <h:outputText value="#{data.personal_usuario.nombrePersonal}"/>
                        </rich:column>
                        <rich:column  >
                            <h:outputText value="#{data.fechaSolicitudMantenimiento}"  >
                                <f:convertDateTime pattern="dd/MM/yyyy HH:mm:ss" />
                            </h:outputText>
                        </rich:column >
                        <rich:column  >
                            <h:outputText value="#{data.fechaAprobacion}"  >
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
                        <rich:column>
                            <h:outputText value="#{data.descripcionEstado}"/>
                        </rich:column>
                        <rich:column style="background-color : #F2F5A9"  >
                            <h:outputText value="#{data.estadoSolicitudMantenimiento.nombreEstadoSolicitudMantenimiento}"  />
                        </rich:column >
                        <rich:column>
                            <h:outputText value="#{data.tiposSolicitudMantenimiento.nombreTipoSolicitud}"  />
                        </rich:column >
                        <rich:column styleClass="tdCenter">
                            <a4j:commandLink  rendered="#{data.estadoSolicitudMantenimiento.codEstadoSolicitudMantenimiento!='4'}" action="#{ManagedAprobacionSolicitudMantenimiento.seleccionarSolicitudMantenimientoDescribirEstado_action}"
                                             oncomplete="Richfaces.showModalPanel('panelDescribirEstado');"
                                             reRender="contenidoDescribirEstado">
                                <h:graphicImage url="../../img/describir.jpg" alt="Describir estado"/>
                            </a4j:commandLink>
                        </rich:column>
                        <rich:column styleClass="tdCenter">
                            <a4j:commandLink rendered="#{data.nroOrdenTrabajo>0&&data.estadoSolicitudMantenimiento.codEstadoSolicitudMantenimiento!='4'}" action="#{ManagedAprobacionSolicitudMantenimiento.cerrarSolicitudMantenimiento_action}"
                                             onclick="if(!confirm('Esta seguro de cerrar la OT?')){return false;}"
                                             reRender="dataSolicitudMantenimiento"
                                             oncomplete="if(#{ManagedAprobacionSolicitudMantenimiento.mensaje eq '1'}){alert('Se cerro la Orden de Trabajo');}else{alert('#{ManagedAprobacionSolicitudMantenimiento.mensaje}');}">
                                <h:graphicImage url="../../img/cerrarOt.jpg" alt="Cerrar Orden de Trabajo"/>
                            </a4j:commandLink>
                        </rich:column>
                        <rich:column styleClass="tdCenter">
                            <a4j:commandLink rendered="#{data.nroOrdenTrabajo>0&&data.estadoSolicitudMantenimiento.codEstadoSolicitudMantenimiento!='4'}" action="#{ManagedAprobacionSolicitudMantenimiento.seleccionarSolicitudMantenimientoTarea_action}"
                                             oncomplete="window.location.href='solicitudMantenimientoDetalleTareas/navegadorSolicitudMantenimientoDetalleTareas.jsf?add='+(new Date()).getTime().toString();">
                                <h:graphicImage url="../../img/user.png" alt="Tareas"/>
                            </a4j:commandLink>
                        </rich:column>
                        <rich:column styleClass="tdCenter">
                            <a4j:commandLink rendered="#{data.nroOrdenTrabajo>0&&data.estadoSolicitudMantenimiento.codEstadoSolicitudMantenimiento!='4'}" action="#{ManagedAprobacionSolicitudMantenimiento.seleccionarSolicitudMantenimientoSolicitudSalidaAlmacen_action}"
                                             oncomplete="window.location.href='solicitudMantenimientoSolicitudSalidaAlmacen/navegadorSolicitudMantenimientoSolicitudSalidaAlmacen.jsf?add='+(new Date()).getTime().toString();">
                                <h:graphicImage url="../../img/materialMantenimiento.jpg" alt="Materiales"/>
                            </a4j:commandLink>
                        </rich:column>
                        <rich:column styleClass="tdCenter">
                            <a4j:commandLink oncomplete="verReporteSolicitudMantenimiento(#{data.codSolicitudMantenimiento})">
                                <h:graphicImage url="../../img/pdf.jpg" alt="Detalle"/>
                            </a4j:commandLink>
                        </rich:column>

                    </rich:dataTable>
                    <h:panelGrid columns="2"  width="50" id="controles">
                        <a4j:commandLink  action="#{ManagedAprobacionSolicitudMantenimiento.atrasSolicitudesMantenimientoList_action}" reRender="dataSolicitudMantenimiento,controles"  rendered="#{ManagedAprobacionSolicitudMantenimiento.begin>'1'}" >
                            <h:graphicImage url="../../img/previous.gif"  style="border:0px solid red"   alt="PAGINA ANTERIOR"  />
                        </a4j:commandLink>
                        <a4j:commandLink  action="#{ManagedAprobacionSolicitudMantenimiento.siguienteSolicitudesMantenimientoList_action}" reRender="dataSolicitudMantenimiento,controles" rendered="#{ManagedAprobacionSolicitudMantenimiento.cantidadfilas>=ManagedAprobacionSolicitudMantenimiento.numrows}">
                            <h:graphicImage url="../../img/next.gif"  style="border:0px solid red"  alt="PAGINA SIGUIENTE" />
                        </a4j:commandLink>
                    </h:panelGrid>
                    <br>
                    <a4j:commandButton value="Aprobar Solicitud" styleClass="btn" 
                                       onclick="if(!editarItem('form1:dataSolicitudMantenimiento')){return false;}"
                                       action="#{ManagedAprobacionSolicitudMantenimiento.seleccionarAprobarSolicitudMantenimiento_action}"
                                       reRender="contenidoAprobarSolicitudMantenimiento"
                                       oncomplete="Richfaces.showModalPanel('panelAprobarSolicitudMantenimiento');"/>
                    <a4j:commandButton value="Anular" styleClass="btn" 
                                       onclick="if(!editarItem('form1:dataSolicitudMantenimiento')){return false;}"
                                       action="#{ManagedAprobacionSolicitudMantenimiento.anularSolicitudMantenimiento_action}"
                                       reRender="contenidoAnularSolicitudMantenimiento"
                                       oncomplete="Richfaces.showModalPanel('panelAnularSolicitudMantenimiento');"/>
                    

                </div>
            </a4j:form>
            <rich:modalPanel id="panelAprobarSolicitudMantenimiento"
                             minHeight="250"  minWidth="600" height="250" width="600"
                             zindex="200" headerClass="headerClassACliente"
                            resizeable="false" style="overflow :auto" >
                <f:facet name="header">
                    <h:outputText value="<center>Aprobación de Solicitud de Mantenimiento</center>" escape="false"/>
                </f:facet>
                <a4j:form id="formAprobarSolicitud">
                    <h:panelGroup id="contenidoAprobarSolicitudMantenimiento">
                        <div align="center">
                            <h:panelGrid columns="3">
                                <h:outputText value="Nro. Solicitud" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:outputText value="#{ManagedAprobacionSolicitudMantenimiento.solicitudMantenimientoAprobar.codSolicitudMantenimiento}" styleClass="outputText2"/>
                                <h:outputText value="Solicitante" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:outputText value="#{ManagedAprobacionSolicitudMantenimiento.solicitudMantenimientoAprobar.personal_usuario.nombrePersonal}" styleClass="outputText2"/>
                                <h:outputText value="Area Empresa" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:outputText value="#{ManagedAprobacionSolicitudMantenimiento.solicitudMantenimientoAprobar.areasEmpresa.nombreAreaEmpresa}" styleClass="outputText2"/>
                                <h:outputText value="Fecha Registro Solicitud" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:outputText  value="#{ManagedAprobacionSolicitudMantenimiento.solicitudMantenimientoAprobar.fechaSolicitudMantenimiento}" id="fechaSolicitud" styleClass="outputText2">
                                    <f:convertDateTime pattern="dd/MM/yyyy HH:mm:ss" />
                                </h:outputText>
                                <h:outputText value="Fecha Aprobación" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <rich:calendar id="fechaAprobacion"value="#{ManagedAprobacionSolicitudMantenimiento.solicitudMantenimientoAprobar.fechaAprobacion}" styleClass="inputText" datePattern="dd/MM/yyyy" oncollapse="fechasChange();return true;">
                                </rich:calendar>
                            </h:panelGrid>
                            <a4j:commandButton value="Guardar" styleClass="btn" 
                                               action="#{ManagedAprobacionSolicitudMantenimiento.aprobarSolicitudMantenimiento_action}"
                                               reRender="dataSolicitudMantenimiento,controles"
                                               oncomplete="if(#{ManagedAprobacionSolicitudMantenimiento.mensaje eq '1'}){ alert('Se aprobó la solicitud de mantenimiento');Richfaces.hideModalPanel('panelAprobarSolicitudMantenimiento');}
                                               else{alert('#{ManagedAprobacionSolicitudMantenimiento.mensaje}');}"/>
                            <a4j:commandButton value="Cancelar" styleClass="btn"
                                               oncomplete="Richfaces.hideModalPanel('panelAprobarSolicitudMantenimiento')"/>
                            
                        </div>
                    </h:panelGroup>
                </a4j:form>
            </rich:modalPanel>
                                       
            <rich:modalPanel id="panelAnularSolicitudMantenimiento"
                             minHeight="250"  minWidth="600" height="250" width="600"
                             zindex="200" headerClass="headerClassACliente"
                            resizeable="false" style="overflow :auto" >
                <f:facet name="header">
                    <h:outputText value="<center>Anulación de Solicitud de Mantenimiento</center>" escape="false"/>
                </f:facet>
                <a4j:form id="formAnular">
                    <h:panelGroup id="contenidoAnularSolicitudMantenimiento">
                        <div align="center">
                            <h:panelGrid columns="3">
                                <h:outputText value="Nro. Solicitud" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:outputText value="#{ManagedAprobacionSolicitudMantenimiento.solicitudMantenimientoAnular.codSolicitudMantenimiento}" styleClass="outputText2"/>
                                <h:outputText value="Solicitante" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:outputText value="#{ManagedAprobacionSolicitudMantenimiento.solicitudMantenimientoAnular.personal_usuario.nombrePersonal}" styleClass="outputText2"/>
                                <h:outputText value="Area Empresa" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:outputText value="#{ManagedAprobacionSolicitudMantenimiento.solicitudMantenimientoAnular.areasEmpresa.nombreAreaEmpresa}" styleClass="outputText2"/>
                                <h:outputText value="Comentario/Razón" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:inputTextarea value="#{ManagedAprobacionSolicitudMantenimiento.solicitudMantenimientoAnular.descripcionEstado}" styleClass="inputText" style="width:35em" rows="5" />
                            </h:panelGrid>
                            <a4j:commandButton value="Guardar" styleClass="btn" 
                                               action="#{ManagedAprobacionSolicitudMantenimiento.guardarAnularSolicitudMantenimientao_action}"
                                               reRender="dataSolicitudMantenimiento,controles"
                                               oncomplete="if(#{ManagedAprobacionSolicitudMantenimiento.mensaje eq '1'}){ alert('Se registro la anulación de la solicitud de mantenimiento');Richfaces.hideModalPanel('panelAnularSolicitudMantenimiento');}
                                               else{alert('#{ManagedAprobacionSolicitudMantenimiento.mensaje}');}"/>
                            <a4j:commandButton value="Cancelar" styleClass="btn"
                                               oncomplete="Richfaces.hideModalPanel('panelAnularSolicitudMantenimiento')"/>
                            
                        </div>
                    </h:panelGroup>
                </a4j:form>
            </rich:modalPanel>
            <rich:modalPanel id="panelDescribirEstado"
                             minHeight="250"  minWidth="600" height="250" width="600"
                             zindex="200" headerClass="headerClassACliente"
                            resizeable="false" style="overflow :auto" >
                <f:facet name="header">
                    <h:outputText value="<center>Descripción de Estado de Solicitud de Mantenimiento</center>" escape="false"/>
                </f:facet>
                <a4j:form id="formDescribirEstado">
                    <h:panelGroup id="contenidoDescribirEstado">
                        <div align="center">
                            <h:panelGrid columns="3">
                                <h:outputText value="Nro. Solicitud" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:outputText value="#{ManagedAprobacionSolicitudMantenimiento.solicitudMantenimientoDescribirEstado.codSolicitudMantenimiento}" styleClass="outputText2"/>
                                <h:outputText value="Solicitante" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:outputText value="#{ManagedAprobacionSolicitudMantenimiento.solicitudMantenimientoDescribirEstado.personal_usuario.nombrePersonal}" styleClass="outputText2"/>
                                <h:outputText value="Area Empresa" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:outputText value="#{ManagedAprobacionSolicitudMantenimiento.solicitudMantenimientoDescribirEstado.areasEmpresa.nombreAreaEmpresa}" styleClass="outputText2"/>
                                <h:outputText value="Descripción" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:inputTextarea value="#{ManagedAprobacionSolicitudMantenimiento.solicitudMantenimientoDescribirEstado.descripcionEstado}" styleClass="inputText" style="width:35em" rows="5" />
                            </h:panelGrid>
                            <a4j:commandButton value="Guardar" styleClass="btn" 
                                               action="#{ManagedAprobacionSolicitudMantenimiento.guardarSolicitudMantenimientoDescribirEstado_action}"
                                               reRender="dataSolicitudMantenimiento,controles"
                                               oncomplete="if(#{ManagedAprobacionSolicitudMantenimiento.mensaje eq '1'}){ alert('Se guardo la descripción del estado de la solicitud');Richfaces.hideModalPanel('panelDescribirEstado');}
                                               else{alert('#{ManagedAprobacionSolicitudMantenimiento.mensaje}');}"/>
                            <a4j:commandButton value="Cancelar" styleClass="btn"
                                               oncomplete="Richfaces.hideModalPanel('panelDescribirEstado')"/>
                            
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
                    <h:graphicImage value="../../img/load2.gif" />
                </div>
            </rich:modalPanel>
            
    </html>
    
</f:view>

