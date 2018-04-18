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
                    <h:outputText value="#{ManagedEspecificacionesTecnicasProducto.cargarTiposEspecificacionesTecnicas}"/>
                    <h:outputText styleClass="outputTextTitulo"  value="Tipos Especificaciones Tecnicas" />
                    <br><br>
                    
                    <rich:dataTable value="#{ManagedEspecificacionesTecnicasProducto.tiposEspecificacionesTecnicasList}"
                                    var="data"
                                    id="dataEspecificacionesTecnicas"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente" >
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value=""  />
                            </f:facet>
                            <h:selectBooleanCheckbox  value="#{data.checked}"  />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Especificacion "  />
                            </f:facet>
                            <h:outputText  value="#{data.nombreTipoEspecificacionTecnica}"  />
                        </h:column>
                        
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Estado Registro"  />
                            </f:facet>
                            <h:outputText value="#{data.estadoRegistro.nombreEstadoRegistro}"  />
                        </h:column>
                        
                    </rich:dataTable>
                    <br>
                        <a4j:commandButton value="Registrar" styleClass="btn" action="#{ManagedEspecificacionesTecnicasProducto.agregarTipoEspecificacionTecnica_action}" oncomplete="Richfaces.showModalPanel('panelRegistrarEspecificacionesTecnicas')" reRender="contenidoRegistrarEspecificacionesTecnicas" />
                        <a4j:commandButton value="Modificar" styleClass="btn" onclick="if(editarItem('form1:dataEspecificacionesTecnicas')==false){return false;}" action="#{ManagedEspecificacionesTecnicasProducto.editarTiposEspecificacionesTecnicas_action}" oncomplete="Richfaces.showModalPanel('panelEditarEspecificacionesTecnicas')" reRender="contenidoEditarEspecificacionesTecnicas"/>
                        <a4j:commandButton value="Eliminar" styleClass="btn" onclick="if(confirm('Esta seguro de eliminar la especificación?')){if(editarItem('form1:dataEspecificacionesTecnicas')==false){return false;}}else{return false;}"  action="#{ManagedEspecificacionesTecnicasProducto.eliminarTiposEspecificacionesTecnicas_action}"
                        oncomplete="if(#{ManagedEspecificacionesTecnicasProducto.mensaje eq '1'}){alert('Se elimino la especificacion')}else{alert('#{ManagedEspecificacionesTecnicasProducto.mensaje}');}" reRender="dataEspecificacionesTecnicas"/>

                   
                </div>

               
              
            </a4j:form>

             <rich:modalPanel id="panelRegistrarEspecificacionesTecnicas" minHeight="150"  minWidth="550"
                                     height="150" width="550"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Registro de Tipo Especificacion Técnica"/>
                        </f:facet>
                        <a4j:form id="formRegistrar">
                        <h:panelGroup id="contenidoRegistrarEspecificacionesTecnicas">
                            <div align="center">
                            <h:panelGrid columns="3">
                                <h:outputText value="Nombre Especificacion " styleClass="outputText1" style="font-weight:bold"/>
                                <h:outputText value="::" styleClass="outputText1" style="font-weight:bold"/>
                                <h:inputText value="#{ManagedEspecificacionesTecnicasProducto.tiposEspecificacionesTecnicasAgregar.nombreTipoEspecificacionTecnica}" size="45" styleClass="inputText" id="nombreUnidad"  />
                                <h:outputText value="Estado " styleClass="outputText1" style="font-weight:bold"/>
                                <h:outputText value="::" styleClass="outputText1" style="font-weight:bold"/>
                                <h:outputText value="Activo" styleClass="outputText1" />

                            </h:panelGrid>
                                <div style="margin-top:8px;">
                                    <a4j:commandButton styleClass="btn" value="Registrar"  action="#{ManagedEspecificacionesTecnicasProducto.guardarNuevoTipoEspecificacionTecnica_action}"
                                    oncomplete="if(#{ManagedEspecificacionesTecnicasProducto.mensaje eq '1'}){alert('Se registro la especificacion');javascript:Richfaces.hideModalPanel('panelRegistrarEspecificacionesTecnicas');}else{alert('#{ManagedEspecificacionesTecnicasProducto.mensaje}');}"
                                    reRender="dataEspecificacionesTecnicas"/>
                                    <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('panelRegistrarEspecificacionesTecnicas')" class="btn" />
                                </div>
                                </div>
                        </h:panelGroup>
                        </a4j:form>
            </rich:modalPanel>

           <rich:modalPanel id="panelEditarEspecificacionesTecnicas" minHeight="150"  minWidth="500"
                                     height="150" width="500"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Modificación de Tipo Especificacion Tecnica"/>
                        </f:facet>
                        <a4j:form id="formEditar">
                        <h:panelGroup id="contenidoEditarEspecificacionesTecnicas">
                            <div align="center">
                            <h:panelGrid columns="3">
                                <h:outputText value="Nombre Especificacion" styleClass="outputText1" style="font-weight:bold;" />
                                <h:outputText value="::" styleClass="outputText1" style="font-weight:bold;" />
                                <h:inputText size="45" value="#{ManagedEspecificacionesTecnicasProducto.tiposEspecificacionesTecnicasEditar.nombreTipoEspecificacionTecnica}" styleClass="inputText" />
                               <h:outputText value="Estado" styleClass="outputText1" style="font-weight:bold;" />
                                <h:outputText value="::" styleClass="outputText1" style="font-weight:bold;" />
                                <h:selectOneMenu value="#{ManagedEspecificacionesTecnicasProducto.tiposEspecificacionesTecnicasEditar.estadoRegistro.codEstadoRegistro}" styleClass="inputText" >
                                    <f:selectItem itemValue="1" itemLabel="Activo"/>
                                    <f:selectItem itemValue="2" itemLabel="No Activo"/>
                               </h:selectOneMenu>
                              
                               </h:panelGrid>
                                        <div style="margin-top:8px">
                                        <a4j:commandButton styleClass="btn" value="Guardar" onclick="if(confirm('Esta seguro de editar la especificacion?')==false){return false;}"
                                        action="#{ManagedEspecificacionesTecnicasProducto.guardarEdicionTiposEspecificacionesTecnicas_action}"
                                        oncomplete="if(#{ManagedEspecificacionesTecnicasProducto.mensaje eq '1'}){alert('Se edito la especificacion');javascript:Richfaces.hideModalPanel('panelEditarEspecificacionesTecnicas');}else{alert('#{ManagedEspecificacionesTecnicasProducto.mensaje}');}"
                                        reRender="dataEspecificacionesTecnicas" />
                                        <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('panelEditarEspecificacionesTecnicas')" class="btn" />
                                        </div>
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

