<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>
<f:view>

    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
            <script type="text/javascript" src="../../js/general.js" ></script>
           
        </head>
        <body >
            <a4j:form id="form1">
                <div align="center">
                    
                    <h:outputText value="#{ManagedFormasFarmaceuticasActividadesPreparado.cargarEditarSubProcesoFormaFarActividad}"/>
                    <rich:panel headerClass="headerClassACliente">
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
                    <rich:panel headerClass="headerClassACliente">
                        <f:facet name="header">
                            <h:outputText value="Registro de Proceso"/>
                        </f:facet>
                        <h:panelGrid columns="3">
                            <h:outputText value="Nro Paso" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:inputText value="#{ManagedFormasFarmaceuticasActividadesPreparado.subProcesoFormasFarmaceuticasActividadesPreparadoEditar.nroPaso}" styleClass="inputText"/>
                            <h:outputText value="Actividad de Preparado" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectOneMenu value="#{ManagedFormasFarmaceuticasActividadesPreparado.subProcesoFormasFarmaceuticasActividadesPreparadoEditar.actividadesPreparado.codActividadPreparado}" styleClass="inputText">
                                <f:selectItems value="#{ManagedFormasFarmaceuticasActividadesPreparado.actividadesPreparadoSelectList}"/>
                            </h:selectOneMenu>
                            <h:outputText value="Necesita Materiales" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectBooleanCheckbox value="#{ManagedFormasFarmaceuticasActividadesPreparado.subProcesoFormasFarmaceuticasActividadesPreparadoEditar.necesitaMateriales}"/>
                            <h:outputText value="Descripción" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:inputTextarea value="#{ManagedFormasFarmaceuticasActividadesPreparado.subProcesoFormasFarmaceuticasActividadesPreparadoEditar.descripcion}" styleClass="inputText" style="width:300px"/>
                        </h:panelGrid>
                        
                    </rich:panel>
                    <br>
                    <rich:panel headerClass="headerClassACliente">
                        <f:facet name="header">
                            <h:outputText value="Maquinarias del Proceso"/>
                        </f:facet>
                        <div align="center"  style="width:80%;height:250px; overflow:auto;text-align:center">
                            <rich:dataTable value="#{ManagedFormasFarmaceuticasActividadesPreparado.subProcesoFormasFarmaceuticasActividadesPreparadoEditar.maquinariasList}"
                                    var="data"
                                    id="dataMaquinaria"
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
                                                    <h:outputText value="Maquina"  />
                                                </f:facet>
                                                <h:outputText  value="#{data.nombreMaquina}"  />
                                            </h:column>
                                            <h:column>
                                                <f:facet name="header">
                                                    <h:outputText value="Codigo Máquina"  />
                                                </f:facet>
                                                <h:outputText  value="#{data.codigo}"  />
                                            </h:column>
                                            <h:column>
                                                <f:facet name="header">
                                                    <h:outputText value="Observación"  />
                                                </f:facet>
                                                <h:outputText  value="#{data.obsMaquina}"  />
                                            </h:column>
                                            
                             </rich:dataTable>
                             </div>
                          </rich:panel>
                          <br>

                     <rich:panel headerClass="headerClassACliente">
                        <f:facet name="header">
                            <h:outputText value="Especificaciones de las Maquinarias del Proceso"/>
                        </f:facet>
                         <rich:dataTable value="#{ManagedFormasFarmaceuticasActividadesPreparado.subProcesoFormasFarmaceuticasActividadesPreparadoEditar.especificacionesProcesosList}"
                                    var="data"
                                    id="dataEspecificacionesEquipo"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente" >
                             <f:facet name="header">
                                 <rich:columnGroup>
                                     <rich:column>
                                         <h:outputText value=""/>
                                     </rich:column>
                                     <rich:column>
                                         <h:outputText value="Nombre Espeficación"/>
                                     </rich:column>
                                     <rich:column>
                                         <h:outputText value="Tipo Descripción"/>
                                     </rich:column>
                                     <rich:column>
                                         <h:outputText value="Unidad de Medida"/>
                                     </rich:column>
                                 </rich:columnGroup>
                             </f:facet>
                                 <rich:column>
                                     <h:selectBooleanCheckbox  value="#{data.checked}"  />
                                 </rich:column>
                                 <rich:column>
                                     <h:outputText  value="#{data.nombreEspecificacionProceso}"  />
                                 </rich:column>
                                 <rich:column>
                                     <h:outputText value="#{data.tiposDescripcion.nombreTipoDescripcion}"/>
                                 </rich:column>
                                 <rich:column>
                                     <h:outputText value="#{data.unidadMedida.nombreUnidadMedida}"/>
                                 </rich:column>
                         </rich:dataTable>
                         </rich:panel>

                   
                    <br>
                    <a4j:commandButton value="Guardar" action="#{ManagedFormasFarmaceuticasActividadesPreparado.guardarEditarSubProcesoFormaFarActividad_action}" styleClass="btn"
                                       oncomplete="if(#{ManagedFormasFarmaceuticasActividadesPreparado.mensaje eq 1}){alert('se registro la edición de la actividad');window.location.href='navegadorSubProcesosFormaFar.jsf?edit='+(new Date()).getTime().toString();}else{alert('#{ManagedFormasFarmaceuticasActividadesPreparado.mensaje}')}"/>
                    <a4j:commandButton value="Cancelar" styleClass="btn" oncomplete="window.location.href='navegadorSubProcesosFormaFar.jsf?edit='+(new Date()).getTime().toString();" />
                   
                </div>
                    
               
              
            </a4j:form>
            <rich:modalPanel id="ajaxLoadingModalBox" minHeight="100"
                                     minWidth="200" height="80" width="400" zindex="100" onshow="window.focus();">

                        <div align="center">
                            <h:graphicImage value="../../img/load2.gif" />
                        </div>
                    </rich:modalPanel>

        </body>
    </html>

</f:view>

