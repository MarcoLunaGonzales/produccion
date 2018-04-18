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
            <h:form id="form1"  >                
                <div align="center">                    
                    <br>
                    <h:outputText value="Actividades Producción" styleClass="tituloCabezera1"    />
                    <h:outputText value="#{ManagedActividadesProduccion.iniciarCargado}"/>
                    <br>  <br>
                    <h:panelGrid columns="2">
                    <h:outputText value="Estado ::" styleClass="tituloCabezera"    />
                    <h:selectOneMenu value="#{ManagedActividadesProduccion.actividadesProduccionbean.estadoReferencial.codEstadoRegistro}" styleClass="inputText" 
                                     valueChangeListener="#{ManagedActividadesProduccion.changeEvent}">
                        <f:selectItems value="#{ManagedEstadosReferenciales.estadosReferenciales}"  />
                        <a4j:support event="onchange"  reRender="dataCadenaCliente"  />
                    </h:selectOneMenu>

                    <h:outputText value="Estado ::" styleClass="tituloCabezera"    />
                    <h:selectOneMenu value="#{ManagedActividadesProduccion.actividadesProduccionbean.tiposActividadProduccion.codTipoActividadProduccion}" styleClass="inputText"
                                     valueChangeListener="#{ManagedActividadesProduccion.tipoActividadProduccion_changeEvent}">
                                      <f:selectItems value="#{ManagedActividadesProduccion.tiposActividadProduccionList}"  />
                                      <a4j:support event="onchange"  reRender="dataCadenaCliente"  />
                    </h:selectOneMenu>
                    <%--inicio alejandro---%>
                     <h:outputText value="Tipo de Actividad ::" styleClass="tituloCabezera"    />
                     <h:selectOneMenu value="#{ManagedActividadesProduccion.actividadesProduccionbean.tipoActividad.codTipoActividad}" styleClass="inputText"
                     valueChangeListener="#{ManagedActividadesProduccion.tipoActividad_changeEvent}">
                                   <f:selectItems value="#{ManagedActividadesProduccion.tiposActividad}"  />
                                      <a4j:support event="onchange"  reRender="dataCadenaCliente"  />
                    </h:selectOneMenu>
                    <%--final alejandro--%>
                    </h:panelGrid>
                    <br>
                    <br>                          
                    <rich:dataTable value="#{ManagedActividadesProduccion.actividadesProduccionList}" var="data" id="dataCadenaCliente" 
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#CCDFFA';" 
                                    headerClass="headerClassACliente"
                                    columnClasses="tituloCampo"
                                    

                    >
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value=""  />
                                
                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.checked}"  />
                        </h:column>
                        
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Actividades Producción"  />
                            </f:facet>
                            <h:outputText value="#{data.nombreActividad}"  />
                        </h:column>
                        
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Descripción"  />
                            </f:facet>
                            <h:outputText value="#{data.obsActividad}"  />
                        </h:column>
                        <%--inicio ale unidad medida--%>
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value="Unidad Medida" />
                            </f:facet>
                            <h:outputText value="#{data.unidadesMedida.nombreUnidadMedida}"  />
                        </rich:column>
                        <%--final ale unidad medida--%>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Estado"  />
                            </f:facet>
                            <h:outputText value="#{data.estadoReferencial.nombreEstadoRegistro}" styleClass="" />
                        </h:column>
                    </rich:dataTable>
                    
                    <br>
                    <h:commandButton value="Registrar" styleClass="commandButton"  action="#{ManagedActividadesProduccion.Guardar}"/>
                    <h:commandButton value="Editar"  styleClass="commandButton"  action="#{ManagedActividadesProduccion.actionEditar}" onclick="return editarItem('form1:dataCadenaCliente');"/>
                    <h:commandButton value="Eliminar"  styleClass="commandButton"  action="#{ManagedActividadesProduccion.actionEliminar}"  onclick="return eliminarItem('form1:dataCadenaCliente');"/>
                    
                </div>
                <!--cerrando la conexion-->
                <h:outputText value="#{ManagedActividadesProduccion.closeConnection}"  />
            </h:form>
            
            
        </body>
    </html>
    
</f:view>

