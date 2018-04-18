<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
            <script type="text/javascript" src="../../js/general.js"></script>
        </head>
        <body>    
            <div style="text-align:center">
                <h:form id="form1"  >
                    <h:outputText value="#{ManagedFormasFarmaceuticasActividadesPreparado.cargarSubProcesosFormaFarmaceuticaActividad}"/>
                    <h:outputText styleClass="outputTextTitulo"  value="Procesos de Preparado por Forma Farmaceutica" />
                    <br>
                    <rich:panel headerClass="headerClassACliente" style="width:70%">
                        <f:facet name="header">
                            <h:outputText value="DATOS GENERALES"/>
                        </f:facet>
                        <h:panelGrid columns="3">
                            <h:outputText value="Forma Farmaceútica" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:outputText value="#{ManagedFormasFarmaceuticasActividadesPreparado.formasFarmaceuticaBean.nombreForma}" styleClass="outputText2"/>
                            <h:outputText value="Proceso" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:outputText value="#{ManagedFormasFarmaceuticasActividadesPreparado.procesosOrdenManufacturaBean.nombreProcesoOrdenManufactura}" styleClass="outputText2"/>
                         </h:panelGrid>
                        <rich:panel headerClass="headerClassACliente" style="width:90%">
                            <f:facet name="header">
                                <h:outputText value="Datos Proceso Principal"/>
                            </f:facet>
                            <h:panelGrid columns="3">
                                <h:outputText value="Nro. Paso" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:outputText value="#{ManagedFormasFarmaceuticasActividadesPreparado.formasFarmaceuticasActividadesPreparadoBean.nroPaso}" styleClass="outputText2"/>
                                <h:outputText value="Actividad" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:outputText value="#{ManagedFormasFarmaceuticasActividadesPreparado.formasFarmaceuticasActividadesPreparadoBean.actividadesPreparado.nombreActividadPreparado}" styleClass="outputText2"/>
                                <h:outputText value="Descripción" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:outputText value="#{ManagedFormasFarmaceuticasActividadesPreparado.formasFarmaceuticasActividadesPreparadoBean.descripcion}" styleClass="outputText2"/>
                            </h:panelGrid>
                        </rich:panel>
                    </rich:panel>
                    
                    
                
                <br>
                
                <rich:dataTable value="#{ManagedFormasFarmaceuticasActividadesPreparado.subProcesoformasFarmaceuticasActividadesPreparadoList}"
                                    var="data" id="dataProcesosProducto"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#F3F7FD';"
                                    headerClass="headerClassACliente"
                                    columnClasses="tituloCampo">
                        <f:facet name="header">
                            <rich:columnGroup>
                                <rich:column rowspan="2">
                                    <h:outputText value=""  />
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Nro. Paso"  />
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Actividad Preparado"  />
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Descripción"  />
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Necesita Materiales"  />
                                </rich:column>
                                <rich:column colspan="2">
                                    <h:outputText value="Maquinarias"/>
                                </rich:column>
                                <rich:column breakBefore="true">
                                    <h:outputText value="CODIGO"/>
                                </rich:column>
                                <rich:column >
                                    <h:outputText value="NOMBRE"/>
                                </rich:column>
                            </rich:columnGroup>
                        </f:facet>
                        <rich:subTable value="#{data.maquinariasList}" var="subData" rowKeyVar="key">
                            <rich:column rendered="#{key eq 0}" rowspan="#{data.maquinariasListSize}">
                                <h:selectBooleanCheckbox value="#{data.checked}"/>
                            </rich:column >
                            <rich:column rendered="#{key eq 0}" rowspan="#{data.maquinariasListSize}">
                                <h:outputText value="#{data.nroPaso}" styleClass="outputText2" />
                            </rich:column >
                            <rich:column rendered="#{key eq 0}" rowspan="#{data.maquinariasListSize}">
                                <h:outputText value="#{data.actividadesPreparado.nombreActividadPreparado}" styleClass="outputText2" />
                            </rich:column >

                            <rich:column rendered="#{key eq 0}" rowspan="#{data.maquinariasListSize}">
                                <h:outputText value="#{data.descripcion}" styleClass="outputText2" />
                            </rich:column >
                            <rich:column rendered="#{key eq 0}" rowspan="#{data.maquinariasListSize}">
                                <h:selectBooleanCheckbox value="#{data.necesitaMateriales}" disabled="true"/>
                            </rich:column >
                            <rich:column>
                                <h:outputText value="#{subData.codigo}"/>
                            </rich:column>
                            <rich:column>
                                <h:outputText value="#{subData.nombreMaquina}"/>
                            </rich:column>
                        </rich:subTable>
                   </rich:dataTable>
                    <br>
                    <a4j:commandButton value="Agregar" styleClass="btn" onclick="window.location.href='agregarSubProcesoFormaFar.jsf?date='+(new Date()).getTime().toString();" />
                    <a4j:commandButton value="Editar" styleClass="btn" action="#{ManagedFormasFarmaceuticasActividadesPreparado.editarSubProcesoFormaFarActividad_action}" oncomplete="window.location.href='editarSubProcesosFormaFar.jsf?date='+(new Date()).getTime().toString();" />
                    <a4j:commandButton value="Eliminar" styleClass="btn" action="#{ManagedFormasFarmaceuticasActividadesPreparado.eliminarSubProcesoFormaFar_action}" reRender="dataProcesosProducto"
                                       onclick="if(!confirm('Esta seguro de eliminar la actividad?')){return false;}" oncomplete="if(#{ManagedFormasFarmaceuticasActividadesPreparado.mensaje eq 1}){alert('Se eliminó la actividad');}else{alert('#{ManagedFormasFarmaceuticasActividadesPreparado.mensaje}')}"/>
                    <a4j:commandButton value="Volver" styleClass="btn" oncomplete="window.location.href='navegadorProcesosFormaFar.jsf?date='+(new Date()).getTime().toString()"/>
                                       
                    <%--a4j:commandButton value="Cambiar Nro Paso" styleClass="btn" action="#{ManagedProcesosPreparadoAreaProducto.editarNroPasoProceso}" oncomplete="Richfaces.showModalPanel('panelCambioNroPaso')"
                    onclick="if(editarItem('form1:dataProcesosProducto')==false){return false;}" reRender="contenidoCambioNroPaso"/>
                        
                        <a4j:commandButton value="Editar" styleClass="btn" action="#{ManagedProcesosPreparadoAreaProducto.editarProcesoAreaProducto_action}"  oncomplete="window.location='editarProcesosFormaFar.jsf';" />
                        <a4j:commandButton value="Eliminar" styleClass="btn" action="#{ManagedProcesosPreparadoAreaProducto.eliminarProcesosFormaFar_action}"
                        onclick="if(editarItem('form1:dataProcesosProducto')==false){return false;}"
                        oncomplete="if(#{ManagedProcesosPreparadoAreaProducto.mensaje eq '' }){alert('Se elimino el proceso');}else{alert('#{ManagedProcesosPreparadoAreaProducto.mensaje}')}"
                        reRender="dataProcesosProducto" /--%>
                        
                    </div>            
                </h:form>
                
                 <rich:modalPanel id="panelCambioNroPaso" minHeight="200"  minWidth="750"
                                     height="200" width="750"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Cambiar Nro Paso"/>
                        </f:facet>
                        <a4j:form id="formEditar">
                        <h:panelGroup id="contenidoCambioNroPaso">
                            <center>
                                <h:panelGrid columns="3">
                                    <h:outputText styleClass="outputText2" value="Actividad Preparado" />
                                <h:outputText styleClass="outputText2" value=":" />
                                <h:outputText styleClass="outputText2" value="#{ManagedProcesosPreparadoAreaProducto.procesosFormaFarEditar.actividadesPreparado.nombreActividadPreparado}"/>
                                <h:outputText styleClass="outputText2" value="Nro Paso Actual" />
                                <h:outputText styleClass="outputText2" value=":" />
                                <h:outputText styleClass="outputText2" value="#{ManagedProcesosPreparadoAreaProducto.procesosFormaFarEditar.nroPaso}" />
                                <h:outputText styleClass="outputText2" value="Nro Paso Cambio" />
                                <h:outputText styleClass="outputText2" value=":" />
                                <h:inputText styleClass="inputText" value="#{ManagedProcesosPreparadoAreaProducto.nroPasoNuevo}" />
                                <h:outputText styleClass="outputText2" value="Desplazar demas registros" />
                                <h:outputText styleClass="outputText2" value=":" />
                                <h:selectOneRadio value="#{ManagedProcesosPreparadoAreaProducto.recorrerArriba}" styleClass="outputText2">
                                    <f:selectItem itemValue='true' itemLabel="Arriba"/>
                                    <f:selectItem itemValue='false' itemLabel="Abajo"/>
                                    </h:selectOneRadio>
                                </h:panelGrid>
                            </center>

                                <div align="center">
                                    <a4j:commandButton styleClass="btn" value="Guardar"  action="#{ManagedProcesosPreparadoAreaProducto.guardarEdicionNroPasoProcesoFormaFar_action}"
                                    reRender="dataProcesosProducto" oncomplete="javascript:Richfaces.hideModalPanel('panelCambioNroPaso')"/>
                                <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('panelCambioNroPaso')" class="btn" />
                                </div>
                        </h:panelGroup>
                        </a4j:form>
            </rich:modalPanel>
              <rich:modalPanel id="PanelAgregarProcesosManufactura" minHeight="350"  minWidth="950"
                                     height="350" width="950"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Registro de Analisis Quimico"/>
                        </f:facet>
                        <a4j:form id="formRegistrar">
                        <h:panelGroup id="ContenidoAgregarProcesosManufactura">
                            <center>
                            
                            </center>

                                <div align="center">
                                    <a4j:commandButton styleClass="btn" value="Guardar"  action="#{ManagedOrdenManufactura.guardarDatosProcesosComp_action}"
                                    reRender="dataProcesosProducto" oncomplete="javascript:Richfaces.hideModalPanel('PanelAgregarProcesosManufactura')"/>
                                <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('PanelAgregarProcesosManufactura')" class="btn" />
                                </div>
                        </h:panelGroup>
                        </a4j:form>
            </rich:modalPanel>
            <rich:modalPanel id="PanelAgregarMaterialesProcesoMateriales" minHeight="200"  minWidth="750"
                                     height="350" width="750"
                                     zindex="350"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Registro de materiales para el proceso"/>
                        </f:facet>
                        <a4j:form id="formRegistrarMateriales">
                        <h:panelGroup id="contenidoAgregarMaterialesProcesoMateriales">
                            <center>
                           
                                 </center>

                                <div align="center">
                                    <br>
                                    <a4j:commandButton styleClass="btn" value="Registrar"  action="#{ManagedOrdenManufactura.guardarMaterialesProcesoComponentesProd}"
                                    reRender="dataProcesosProducto" oncomplete="javascript:Richfaces.hideModalPanel('PanelAgregarMaterialesProcesoMateriales')"/>
                                <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('PanelAgregarMaterialesProcesoMateriales')" class="btn" />
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

            </div>    
        </body>
    </html>
    
</f:view>

