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
            <script>
                function validarRegistrarNuevaEspecificacion()
                {
                    return validarRegistroNoVacio(document.getElementById("formRegistrar:nombreEspecificacion"));
                }
                function validarEditarEspecificacion()
                {
                    return validarRegistroNoVacio(document.getElementById("formEditar:nombreEspecificacion"));
                }
            </script>
          
        </head>
        <body >
            <a4j:form id="form1">
                <div align="center">
                    <h:outputText value="Especificaciones Procesos" styleClass="outputTextTituloSistema"/>
                    <h:outputText value="#{ManagedEspecificacionesProcesos.cargarEspecificacionesProcesos}"/>
                    <rich:panel headerClass="headerClassACliente" style="width:60%">
                            <f:facet name="header">
                                <h:outputText value="Especificaciones Procesos"/>

                            </f:facet>
                            <h:panelGrid columns="3" headerClass="headerClassACliente">
                               <h:outputText value="Tipo Especificación" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value=":" styleClass="outputText2" style="font-weight:bold"/>
                               <h:selectOneMenu value="#{ManagedEspecificacionesProcesos.especificacionesProcesoBuscar.tiposEspecificacionesProcesos.codTipoEspecificaciónProceso}" styleClass="inputText">
                                   <f:selectItems value="#{ManagedEspecificacionesProcesos.tiposEspecificacionesProcesosSelectList}"/>
                                   <a4j:support event="onchange" action="#{ManagedEspecificacionesProcesos.filtroCabecera_change}" reRender="dataEspecificacionesProceso"/>
                               </h:selectOneMenu>
                            </h:panelGrid>
                            
                          
                        </rich:panel>
                    <br>
                    
                    <rich:dataTable value="#{ManagedEspecificacionesProcesos.especificacionesProcesosList}"
                                    var="data" id="dataEspecificacionesProceso"
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
                                <h:outputText value="Orden"  />
                            </f:facet>
                            <h:outputText  value="#{data.orden}"  />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Nombre Especificación"  />
                            </f:facet>
                            <h:outputText  value="#{data.nombreEspecificacionProceso}"  />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Tipo de Descripción"  />
                            </f:facet>
                            <h:outputText  value="#{data.tiposDescripcion.nombreTipoDescripcion}"/>
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Especificación"  />
                            </f:facet>
                            
                            <h:outputText  value="#{data.tiposDescripcion.especificacion}"  rendered="#{data.tiposDescripcion.codTipoDescripcion>2}"/>
                            <h:outputText  value="#{data.valorExacto}"  rendered="#{data.tiposDescripcion.codTipoDescripcion>2}"/>
                            <h:outputText  value="#{data.valorMinimo}"  rendered="#{data.tiposDescripcion.codTipoDescripcion eq 2}"/>
                            <h:outputText  value="-"  rendered="#{data.tiposDescripcion.codTipoDescripcion eq 2}"/>
                            <h:outputText  value="#{data.valorMaximo}"  rendered="#{data.tiposDescripcion.codTipoDescripcion eq 2}"/>
                            <h:outputText  value="#{data.valorTexto}"  rendered="#{data.tiposDescripcion.codTipoDescripcion eq 1}"/>
                        </h:column>
                        
                        <h:column rendered="#{ManagedEspecificacionesProcesos.especificacionesProcesoBuscar.procesosOrdenManufactura.codProcesoOrdenManufactura eq '2'}">
                            <f:facet name="header">
                                <h:outputText value="Tipo Especificación"  />
                            </f:facet>
                            <h:outputText  value="#{data.tiposEspecificacionesProcesos.nombreTipoEspecificacionProceso}"/>
                            
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Unidad Medida"  />
                            </f:facet>
                            <h:outputText value="#{data.unidadMedida.nombreUnidadMedida}"  />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Porciento Tolerancia"  />
                            </f:facet>
                            <h:outputText value="#{data.porcientoTolerancia}%" rendered="#{data.porcientoTolerancia>0}"  />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Resultado Lote"  />
                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.resultadoEsperadoLote}" disabled="true"/>
                        </h:column>
                       
                    </rich:dataTable>
                    
                    <br>
                    <a4j:commandButton value="Registrar" styleClass="btn" action="#{ManagedEspecificacionesProcesos.agregarEspecificacionesProcesos_action}" oncomplete="Richfaces.showModalPanel('PanelRegistrarEspecificacionesProceso')" reRender="contenidoRegistrarEspecificacionesProceso" />
                    <a4j:commandButton value="Modificar" styleClass="btn" onclick="if(editarItem('form1:dataEspecificacionesProceso')==false){return false;}" action="#{ManagedEspecificacionesProcesos.editarEspecificacionesProcesos_action}" oncomplete="Richfaces.showModalPanel('PanelEditarEspecificacionesProceso')" reRender="contenidoEditarEspecificacionesProceso"/>
                    <a4j:commandButton value="Eliminar" styleClass="btn" onclick="if(confirm('Esta seguro de eliminar la especificacion?')){if(editarItem('form1:dataEspecificacionesProceso')==false){return false;}}else{return false;}"  action="#{ManagedEspecificacionesProcesos.eliminarEspecificacionProceso_action}"
                                       oncomplete="if(#{ManagedEspecificacionesProcesos.mensaje eq '1'}){alert('Se elimino la especificación');}else{alert('#{ManagedEspecificacionesProcesos.mensaje}');}" reRender="dataEspecificacionesProceso"/>

                   
                </div>

               
              
            </a4j:form>

             <rich:modalPanel id="PanelRegistrarEspecificacionesProceso" minHeight="240"  minWidth="550"
                                     height="240" width="550"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false"  >
                        <f:facet name="header">
                            <h:outputText value="<center>Registro de Especificaciones de Proceso</center>" escape="false"/>
                        </f:facet>
                        <a4j:form id="formRegistrar">
                        <h:panelGroup id="contenidoRegistrarEspecificacionesProceso">
                            <center>
                            <h:panelGrid columns="3">
                                <h:outputText value="Nombre Especificacion" styleClass="outputTextBold"  />
                                <h:outputText value="::" styleClass="outputTextBold" />
                                <h:inputText value="#{ManagedEspecificacionesProcesos.especificacionesProcesoAgregar.nombreEspecificacionProceso}" styleClass="inputText" id="nombreEspecificacion" style="width:100%" />
                                <h:outputText value="Unidad de Medida" styleClass="outputTextBold"  />
                                <h:outputText value="::" styleClass="outputTextBold" />
                                <h:selectOneMenu value="#{ManagedEspecificacionesProcesos.especificacionesProcesoAgregar.unidadMedida.codUnidadMedida}" styleClass="inputText">
                                    <f:selectItem itemValue="0" itemLabel="--NINGUNO--"/>
                                    <f:selectItems value="#{ManagedEspecificacionesProcesos.unidadesMedidaSelectList}"/>
                                </h:selectOneMenu>
                                <h:outputText value="Tipo de Descripción" styleClass="outputTextBold"  />
                                <h:outputText value="::" styleClass="outputTextBold" />
                                <h:selectOneMenu value="#{ManagedEspecificacionesProcesos.especificacionesProcesoAgregar.tiposDescripcion.codTipoDescripcion}" styleClass="inputText">
                                    <f:selectItems value="#{ManagedEspecificacionesProcesos.tiposDescripcionSelectList}"/>
                                    <a4j:support event="onchange" reRender="resultados"/>
                                </h:selectOneMenu>
                                <h:outputText value="Valor " styleClass="outputTextBold"  />
                                <h:outputText value="::" styleClass="outputTextBold" />
                                <h:panelGroup id="resultados">
                                    <h:inputText value="#{ManagedEspecificacionesProcesos.especificacionesProcesoAgregar.valorExacto}" onkeypress="valNum()" onblur="valorPorDefecto(this)" styleClass="inputText" rendered="#{ManagedEspecificacionesProcesos.especificacionesProcesoAgregar.tiposDescripcion.codTipoDescripcion > 2}"/>
                                    <h:inputText value="#{ManagedEspecificacionesProcesos.especificacionesProcesoAgregar.valorTexto}"styleClass="inputText" rendered="#{ManagedEspecificacionesProcesos.especificacionesProcesoAgregar.tiposDescripcion.codTipoDescripcion eq 1}"/>
                                    <h:inputText value="#{ManagedEspecificacionesProcesos.especificacionesProcesoAgregar.valorMinimo}" onkeypress="valNum()" onblur="valorPorDefecto(this)" styleClass="inputText" rendered="#{ManagedEspecificacionesProcesos.especificacionesProcesoAgregar.tiposDescripcion.codTipoDescripcion eq 2}"/>
                                    <h:outputText value="-" styleClass="outputTextBold" rendered="#{ManagedEspecificacionesProcesos.especificacionesProcesoAgregar.tiposDescripcion.codTipoDescripcion eq 2}"/>
                                    <h:inputText value="#{ManagedEspecificacionesProcesos.especificacionesProcesoAgregar.valorMaximo}" onkeypress="valNum()" onblur="valorPorDefecto(this)" styleClass="inputText" rendered="#{ManagedEspecificacionesProcesos.especificacionesProcesoAgregar.tiposDescripcion.codTipoDescripcion eq 2}"/>
                                </h:panelGroup>
                                <h:outputText  value="Tolerancia(%)" styleClass="outputTextBold" />
                                <h:outputText  value="::" styleClass="outputTextBold"  />
                                <h:inputText  onkeypress="valNum()" onblur="valorPorDefecto(this)" value="#{ManagedEspecificacionesProcesos.especificacionesProcesoAgregar.porcientoTolerancia}" styleClass="inputText"    />
                                <h:outputText value="Resultado Esperado Lote" styleClass="outputTextBold"  />
                                <h:outputText value="::" styleClass="outputTextBold" />
                                <h:selectBooleanCheckbox validatorMessage="#{ManagedEspecificacionesProcesos.especificacionesProcesoAgregar.resultadoEsperadoLote}"/>
                            </h:panelGrid>
                                
                                <a4j:commandButton styleClass="btn" value="Guardar"  action="#{ManagedEspecificacionesProcesos.guardarAgregarEspecificacionProceso_action}"
                                       onclick="if(!validarRegistrarNuevaEspecificacion()){return false;}"
                                    oncomplete="if(#{ManagedEspecificacionesProcesos.mensaje eq '1'}){alert('Se registro la Especificacion');javascript:Richfaces.hideModalPanel('PanelRegistrarEspecificacionesProceso')}
                                    else{alert('#{ManagedEspecificacionesProcesos.mensaje}')}"
                                    reRender="dataEspecificacionesProceso"/>
                                <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('PanelRegistrarEspecificacionesProceso')" class="btn" />
                                </center>
                        </h:panelGroup>
                        </a4j:form>
            </rich:modalPanel>

           <rich:modalPanel id="PanelEditarEspecificacionesProceso" minHeight="280"  minWidth="570"
                                     height="280" width="570"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Modificación de Especificaciones Despirogenizado"/>
                        </f:facet>
                        <a4j:form id="formEditar">
                        <h:panelGroup id="contenidoEditarEspecificacionesProceso">
                            <center>
                            <h:panelGrid columns="3">
                                <h:outputText value="Nombre Especificacion" styleClass="outputTextBold"  />
                                <h:outputText value="::" styleClass="outputTextBold" />
                                <h:inputText value="#{ManagedEspecificacionesProcesos.especificacionesProcesoEditar.nombreEspecificacionProceso}" styleClass="inputText" id="nombreEspecificacion" style="width:100%" rendered="#{ManagedEspecificacionesProcesos.especificacionesProcesoEditar.cantidadVersiones==0}" />
                                <h:outputText value="#{ManagedEspecificacionesProcesos.especificacionesProcesoEditar.nombreEspecificacionProceso}" styleClass="outputText2"  rendered="#{ManagedEspecificacionesProcesos.especificacionesProcesoEditar.cantidadVersiones>0}" />
                                <h:outputText value="Unidad de Medida" styleClass="outputTextBold"  />
                                <h:outputText value="::" styleClass="outputTextBold" />
                                <h:selectOneMenu value="#{ManagedEspecificacionesProcesos.especificacionesProcesoEditar.unidadMedida.codUnidadMedida}" styleClass="inputText">
                                    <f:selectItem itemValue="0" itemLabel="--NINGUNO--"/>
                                    <f:selectItems value="#{ManagedEspecificacionesProcesos.unidadesMedidaSelectList}"/>
                                </h:selectOneMenu>
                                <h:outputText value="Tipo de Descripción" styleClass="outputTextBold"  />
                                <h:outputText value="::" styleClass="outputTextBold" />
                                <h:selectOneMenu value="#{ManagedEspecificacionesProcesos.especificacionesProcesoEditar.tiposDescripcion.codTipoDescripcion}" styleClass="inputText">
                                    <f:selectItems value="#{ManagedEspecificacionesProcesos.tiposDescripcionSelectList}"/>
                                    <a4j:support event="onchange" reRender="resultados"/>
                                </h:selectOneMenu>
                                <h:outputText value="Valor " styleClass="outputTextBold"  />
                                <h:outputText value="::" styleClass="outputTextBold" />
                                <h:panelGroup id="resultados">
                                    <h:inputText value="#{ManagedEspecificacionesProcesos.especificacionesProcesoEditar.valorExacto}" onkeypress="valNum()" onblur="valorPorDefecto(this)" styleClass="inputText" rendered="#{ManagedEspecificacionesProcesos.especificacionesProcesoEditar.tiposDescripcion.codTipoDescripcion > 2}"/>
                                    <h:inputText value="#{ManagedEspecificacionesProcesos.especificacionesProcesoEditar.valorTexto}"styleClass="inputText" rendered="#{ManagedEspecificacionesProcesos.especificacionesProcesoEditar.tiposDescripcion.codTipoDescripcion eq 1}"/>
                                    <h:inputText value="#{ManagedEspecificacionesProcesos.especificacionesProcesoEditar.valorMinimo}" onkeypress="valNum()" onblur="valorPorDefecto(this)" styleClass="inputText" rendered="#{ManagedEspecificacionesProcesos.especificacionesProcesoEditar.tiposDescripcion.codTipoDescripcion eq 2}"/>
                                    <h:outputText value="-" styleClass="outputTextBold" rendered="#{ManagedEspecificacionesProcesos.especificacionesProcesoEditar.tiposDescripcion.codTipoDescripcion eq 2}"/>
                                    <h:inputText value="#{ManagedEspecificacionesProcesos.especificacionesProcesoEditar.valorMaximo}" onkeypress="valNum()" onblur="valorPorDefecto(this)" styleClass="inputText" rendered="#{ManagedEspecificacionesProcesos.especificacionesProcesoEditar.tiposDescripcion.codTipoDescripcion eq 2}"/>
                                </h:panelGroup>
                                <h:outputText  value="Tolerancia(%)" styleClass="outputTextBold" />
                                <h:outputText  value="::" styleClass="outputTextBold"  />
                                <h:inputText  onkeypress="valNum()" onblur="valorPorDefecto(this)" value="#{ManagedEspecificacionesProcesos.especificacionesProcesoEditar.porcientoTolerancia}" styleClass="inputText"    />
                                <h:outputText value="Resultado Esperado Lote" styleClass="outputTextBold"  />
                                <h:outputText value="::" styleClass="outputTextBold" />
                                <h:selectBooleanCheckbox value="#{ManagedEspecificacionesProcesos.especificacionesProcesoEditar.resultadoEsperadoLote}"/>
                            </h:panelGrid>
                                
                                <a4j:commandButton styleClass="btn" value="Guardar"  action="#{ManagedEspecificacionesProcesos.guardarEdicionEspecificacionProceso_action}"
                                                   onclick="if(!validarEditarEspecificacion()){return false;}"
                                                   oncomplete="if(#{ManagedEspecificacionesProcesos.mensaje eq '1'}){alert('Se registró la edición de la especificación');javascript:Richfaces.hideModalPanel('PanelEditarEspecificacionesProceso')}else{alert('#{ManagedEspecificacionesProcesos.mensaje}')}"
                                                   reRender="dataEspecificacionesProceso"/>
                                <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('PanelEditarEspecificacionesProceso')" class="btn" />
                                </center>
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
                            <h:graphicImage value="../img/load2.gif" />
                        </div>
                    </rich:modalPanel>
        </body>
    </html>

</f:view>

