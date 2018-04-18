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
            <script type="text/javascript" src='../js/general.js' ></script>
            <script type="text/javascript" src='../js/treeComponet.js' ></script> 
        </head>
        <body>
            <a4j:form id="form1"  >                
                <div align="center">                    
                    <h:outputText value="#{ManagedActividadesProduccion.cargarActividadesProduccion}"/>
                    <rich:panel headerClass="headerClassACliente" style="width:60%">
                        <f:facet name="header">
                            <h:outputText value="Actividades de Producción"/>
                        </f:facet>
                        <h:panelGrid columns="6">
                            <h:outputText value="Nombre Actividad" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:inputText value="#{ManagedActividadesProduccion.actividadesProduccionBuscar.nombreActividad}" styleClass="inputText" style="width:100%"/>
                            <h:outputText value="Estado" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectOneMenu value="#{ManagedActividadesProduccion.actividadesProduccionBuscar.estadoReferencial.codEstadoRegistro}" styleClass="inputText">
                                <f:selectItem itemValue="0" itemLabel="--TODOS--"/>
                                <f:selectItem itemValue="1" itemLabel="Activo"/>
                                <f:selectItem itemValue="2" itemLabel="No Activo"/>
                            </h:selectOneMenu>
                            <h:outputText value="Tipo Actividad Area" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectOneMenu value="#{ManagedActividadesProduccion.actividadesProduccionBuscar.tiposActividadProduccion.codTipoActividadProduccion}" styleClass="inputText">
                                <f:selectItem itemValue='0' itemLabel="--TODOS--"/>
                                <f:selectItems value="#{ManagedActividadesProduccion.tiposActividadProducionSelectList}"/>
                            </h:selectOneMenu>
                            <h:outputText value="Tipo Actividad" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectOneMenu value="#{ManagedActividadesProduccion.actividadesProduccionBuscar.tipoActividad.codTipoActividad}" styleClass="inputText">
                                <f:selectItem itemValue='0' itemLabel="--TODOS--"/>
                                <f:selectItems value="#{ManagedActividadesProduccion.tiposActividadSelectList}"/>
                            </h:selectOneMenu>
                        </h:panelGrid>
                        <a4j:commandButton value="BUSCAR" action="#{ManagedActividadesProduccion.buscarActividadesProduccion_action}" styleClass="btn" reRender="dataActividadProduccion"/>
                    </rich:panel>
                    <br>                          
                    <rich:dataTable value="#{ManagedActividadesProduccion.actividadesProduccionList}"
                                    var="data" id="dataActividadProduccion" 
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#CCDFFA';" 
                                    headerClass="headerClassACliente"
                                    columnClasses="tituloCampo">
                        <f:facet name="header">
                            <rich:columnGroup>
                                <rich:column>
                                    <h:outputText value=""/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Actividad Producción"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Descripción"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Unidad Medida"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Estado"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Tipo Actividad"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Tipo Actividad Area"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Proceso OM"/>
                                </rich:column>
                            </rich:columnGroup>
                        </f:facet>
                        <rich:column>
                            <h:selectBooleanCheckbox value="#{data.checked}"  />
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.nombreActividad}"  />
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.obsActividad}"  />
                        </rich:column>
                        <rich:column >
                            <h:outputText value="#{data.unidadesMedida.nombreUnidadMedida}"  />
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.estadoReferencial.nombreEstadoRegistro}"  />
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.tipoActividad.nombreTipoActividad}" />
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.tiposActividadProduccion.nombreTipoActividadProduccion}" />
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.procesosOrdenManufactura.nombreProcesoOrdenManufactura}" />
                        </rich:column>
                    </rich:dataTable>
                        
                    <br>
                    <a4j:commandButton value="Agregar" oncomplete="window.location.href='agregarActividadProduccion.jsf?data'+(new Date()).getTime().toString()" styleClass="btn"/>
                    <a4j:commandButton value="Editar" onclick="if(!editarItem('form1:dataActividadProduccion')){return false;}"
                                       action="#{ManagedActividadesProduccion.editarActividadProduccion_action}"
                                       oncomplete="window.location.href='editarActividadProduccion.jsf?data'+(new Date()).getTime().toString()" styleClass="btn"/>
                    <a4j:commandButton value="Eliminar" onclick="if(!editarItem('form1:dataActividadProduccion')){return false;}" styleClass="btn"
                                   action="#{ManagedActividadesProduccion.eliminarActividadProduccion_action}" reRender="dataActividadProduccion"
                                   oncomplete="if(#{ManagedActividadesProduccion.mensaje eq '1'}){alert('Se elimino la actividad');}else{alert('#{ManagedActividadesProduccion.mensaje}');}"/>
                </center>    
                
            </a4j:form>
            <a4j:status id="statusPeticion"
                        onstart="Richfaces.showModalPanel('ajaxLoadingModalBox',{width:100, top:100})"
                        onstop="Richfaces.hideModalPanel('ajaxLoadingModalBox')">
            </a4j:status>

            <rich:modalPanel id="ajaxLoadingModalBox" minHeight="100"
                             minWidth="200" height="80" width="400" zindex="300" onshow="window.focus();">

                <div align="center">
                    <h:graphicImage value="../img/load2.gif" />
                </div>
            </rich:modalPanel>    
                
            
        </body>
    </html>
    
</f:view>

