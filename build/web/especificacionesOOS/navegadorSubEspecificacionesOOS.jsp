<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>
<f:view>

    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
            <script type="text/javascript" src="../js/general.js" ></script>
        </head>
        <body >
            <a4j:form id="form1">
                <div align="center">
                    <h:outputText value="#{ManagedControlCalidadOS.cargarSubEspecificacionesOOSPagina}"/>
                    <h:outputText styleClass="outputTextTitulo"  value="Especificaciones Oos" />
                    
                        <rich:panel headerClass="headerClassACliente" style="width:80%;margin-top:8px">
                        <f:facet name="header">
                            <h:outputText  value="Especificacion"/>
                        </f:facet>
                        <h:panelGrid columns="3">
                            <h:outputText value="Nombre Especificacion OOS" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="#{ManagedControlCalidadOS.especificacionesOosRegistrar.nombreEspecificacionOos}" styleClass="outputText2" />
                            <h:outputText value="Tipo Especificacion" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="#{ManagedControlCalidadOS.especificacionesOosRegistrar.tiposEspecificacionesOos.nombreTipoEspecificacionOos}" styleClass="outputText2" />
                            <h:outputText value="Estado" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="#{ManagedControlCalidadOS.especificacionesOosRegistrar.estadoRegistro.nombreEstadoRegistro}" styleClass="outputText2" />
                        </h:panelGrid>
                    </rich:panel>
                    <rich:dataTable value="#{ManagedControlCalidadOS.subEspecificacionesOOSList}"
                                    var="data" style="margin-top:8px"
                                    id="dataSubEspecificacionesOOS"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente">
                    <f:facet name="header">
                    <rich:columnGroup>
                        
                            <rich:column >
                                <h:outputText value=""/>
                            </rich:column>
                            
                            <rich:column>
                                <h:outputText value="Orden"/>
                            </rich:column>
                            <rich:column >
                                <h:outputText value="Nombre Sub Especificacion"/>
                            </rich:column>
                            <rich:column >
                                <h:outputText value="Estado"/>
                            </rich:column>
                    </rich:columnGroup>
                    </f:facet>
                        <rich:column>
                            <h:selectBooleanCheckbox  value="#{data.checked}"  />
                        </rich:column>
                         <rich:column >
                            <h:outputText  value="#{data.nroOrden}"  />
                        </rich:column>
                         <rich:column >
                            <h:outputText  value="#{data.nombreSubEspecificacionesOOS}"  />
                        </rich:column>
                         <rich:column >
                            <h:outputText  value="#{data.estadoRegistro.nombreEstadoRegistro}"  />
                        </rich:column>
                    </rich:dataTable>
                    <br>
                        <a4j:commandButton value="Registrar" styleClass="btn" action="#{ManagedControlCalidadOS.cargarAgregarSubEspecificacionOOS_action}"
                        oncomplete="Richfaces.showModalPanel('PanelRegistrarSubEspecificacionesOOS')" reRender="contenidoRegistrarSubEspecificacionesOOS" />
                        <a4j:commandButton value="Modificar" styleClass="btn" onclick="if(editarItem('form1:dataSubEspecificacionesOOS')==false){return false;}" action="#{ManagedControlCalidadOS.editarSubEspecificacionesOOS_action}"
                        oncomplete="Richfaces.showModalPanel('PanelEditarSubEspecificacionesOos')" reRender="contenidoEditarSubEspecificacionesOos"/>
                        <a4j:commandButton value="Eliminar" styleClass="btn" onclick="if(confirm('Esta seguro de eliminar la sub especificación?')){if(editarItem('form1:dataSubEspecificacionesOOS')==false){return false;}}else{return false;}"  action="#{ManagedControlCalidadOS.eliminarSubEspecificacionOOS_action}"
                        oncomplete="if(#{ManagedControlCalidadOS.mensaje eq '1'}){alert('Se elimino la sub especificacion')}else{alert('#{ManagedControlCalidadOS.mensaje}');}" reRender="dataSubEspecificacionesOOS"/>
                        <a4j:commandButton value="Volver" oncomplete="var a=Math.random();window.location.href='navegadorEspecificacionesOOs.jsf?a='+a;" styleClass="btn"/>
                   
                </div>

               
              
            </a4j:form>
            
            
             <rich:modalPanel id="PanelRegistrarSubEspecificacionesOOS" minHeight="150"  minWidth="450"
                                     height="150" width="450"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Registro de Sub Especificaciones OOS"/>
                        </f:facet>
                        <a4j:form id="formRegistrar">
                        <h:panelGroup id="contenidoRegistrarSubEspecificacionesOOS">
                            <center>
                            <h:panelGrid columns="3">
                                <h:outputText value="Nro Orden" styleClass="outputText2" style="font-weight:bold" />
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold" />
                                <h:inputText style="width:4em" value="#{ManagedControlCalidadOS.subEspecificacionesOOSRegistrar.nroOrden}" styleClass="inputText" id="nro"  />
                                <h:outputText value="Nombre" styleClass="outputText2" style="font-weight:bold" />
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold" />
                                <h:inputText style="width:30em" value="#{ManagedControlCalidadOS.subEspecificacionesOOSRegistrar.nombreSubEspecificacionesOOS}" styleClass="inputText" id="nombreSubEspecificacion"  />
                                <h:outputText value="Estado" styleClass="outputText2" style="font-weight:bold" />
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold" />
                                <h:outputText value="Activo" styleClass="outputText2" />
                               
                            </h:panelGrid>
                            </center>
                                <div align="center">
                                    <a4j:commandButton styleClass="btn" value="Registrar"  action="#{ManagedControlCalidadOS.guardarNuevaSubEspecificacionOOS_action}"
                                    oncomplete="if(#{ManagedControlCalidadOS.mensaje eq '1'}){alert('Se registro la sub especificacion');javascript:Richfaces.hideModalPanel('PanelRegistrarSubEspecificacionesOOS');}else{alert('#{ManagedEspecificacionesControlCalidad.mensaje}');}"
                                    reRender="dataSubEspecificacionesOOS"/>
                                <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('PanelRegistrarSubEspecificacionesOOS')" class="btn" />
                                </div>
                        </h:panelGroup>
                        </a4j:form>
            </rich:modalPanel>

           <rich:modalPanel id="PanelEditarSubEspecificacionesOos" minHeight="180"  minWidth="450"
                                     height="180" width="450"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Modificación de Especificaciones OOS"/>
                        </f:facet>
                        <a4j:form id="formEditar">
                        <h:panelGroup id="contenidoEditarSubEspecificacionesOos">
                            <center>
                            <h:panelGrid columns="3">
                                <h:outputText value="Nro Orden" styleClass="outputText2" style="font-weight:bold" />
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold" />
                                <h:inputText style="width:4em" value="#{ManagedControlCalidadOS.subEspecificacionesOOSRegistrar.nroOrden}" styleClass="inputText" />
                                <h:outputText value="Nombre" styleClass="outputText2" style="font-weight:bold" />
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold" />
                                <h:inputText style="width:30em" value="#{ManagedControlCalidadOS.subEspecificacionesOOSRegistrar.nombreSubEspecificacionesOOS}" styleClass="inputText" id="nombreUnidad"  />
                               <h:outputText value="Estado" styleClass="outputText2" style="font-weight:bold" />
                               <h:outputText value="::" styleClass="outputText2" style="font-weight:bold" />
                               <h:selectOneMenu value="#{ManagedControlCalidadOS.subEspecificacionesOOSRegistrar.estadoRegistro.codEstadoRegistro}" styleClass="inputText" >
                                   <f:selectItem itemValue="1" itemLabel="Activo"/>
                                   <f:selectItem itemValue="2" itemLabel="No Activo"/>
                               </h:selectOneMenu>
                               </h:panelGrid>
                           </center>
                                <div align="center">
                                <a4j:commandButton styleClass="btn" value="Guardar" onclick="if(confirm('Esta seguro de editar la sub especificacion?')==false){return false;}"
                                action="#{ManagedControlCalidadOS.guardarEdicionSubEspecificaciones_action}"
                                oncomplete="if(#{ManagedControlCalidadOS.mensaje eq '1'}){alert('Se edito la sub especificacion');javascript:Richfaces.hideModalPanel('PanelEditarSubEspecificacionesOos');}else{alert('#{ManagedControlCalidadOS.mensaje}');}"
                                reRender="dataSubEspecificacionesOOS" />
                                <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('PanelEditarSubEspecificacionesOos')" class="btn" />
                                </div>
                        </h:panelGroup>
                        </a4j:form>
            </rich:modalPanel>
             <a4j:status id="statusPeticion"
                                onstart="Richfaces.showModalPanel('ajaxLoadingModalBox',{width:100, top:100})"
                                onstop="Richfaces.hideModalPanel('ajaxLoadingModalBox')">
                    </a4j:status>

                    <rich:modalPanel id="ajaxLoadingModalBox" minHeight="100"
                                     minWidth="200" height="80" width="400" zindex="500" onshow="window.focus();">

                        <div align="center">
                            <h:graphicImage value="../img/load2.gif" />
                        </div>
                    </rich:modalPanel>
        </body>
    </html>

</f:view>

