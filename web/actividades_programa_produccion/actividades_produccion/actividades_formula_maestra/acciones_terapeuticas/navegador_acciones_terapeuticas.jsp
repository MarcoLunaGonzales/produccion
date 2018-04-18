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
                    <h:outputText value="Acciones Terapeúticas" styleClass="tituloCabezera1"    />
                    <br>  <br>  
                    <h:outputText value="Estado ::" styleClass="tituloCabezera"    />
                    <h:selectOneMenu value="#{ManagedAccionesTerapeuticas.accionesTerapeuticasbean.estadoReferencial.codEstadoRegistro}" styleClass="inputText" 
                                     valueChangeListener="#{ManagedAccionesTerapeuticas.changeEvent}">
                        <f:selectItems value="#{ManagedEstadosReferenciales.estadosReferenciales}"  />
                        <a4j:support event="onchange"  reRender="dataCadenaCliente"  />
                    </h:selectOneMenu>   
                    <br>
                    <br>  
                    
                    <rich:dataTable value="#{ManagedAccionesTerapeuticas.accionesTerapeuticas}" var="data"
                    id="dataCadenaCliente" columnClasses="tituloCampo" headerClass="headerClassACliente" > 
                        <f:facet name="header">
                            <rich:columnGroup>                                                                
                                
                                <rich:column >
                                    <h:outputText value=""  />
                                </rich:column>    
                                <rich:column >
                                    <h:outputText value="Acción Terapeútica"  />
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Descripción"  />
                                </rich:column>    
                                <rich:column>
                                    <h:outputText value="Estado Registro"  />
                                </rich:column>                                                                    
                            </rich:columnGroup>
                        </f:facet>                                                  
                        <h:column>                            
                            <h:selectBooleanCheckbox value="#{data.checked}"  />
                        </h:column>   
                        <h:column>                            
                            <h:outputText value="#{data.nombreAccionTerapeutica}"  />
                        </h:column>
                        <h:column>                            
                            <h:outputText value="#{data.obsAccionTerapeutica}"  />
                        </h:column>
                        <h:column>                            
                            <h:outputText value="#{data.estadoReferencial.nombreEstadoRegistro}" styleClass="" />
                        </h:column>                        
                    </rich:dataTable> 
                    
                    
                    
                    <%--rich:dataTable value="#{ManagedAccionesTerapeuticas.accionesTerapeuticas}" var="data" id="dataCadenaCliente" 
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#CCDFFA';" 

                                    columnClasses="tituloCampo"
                                    rows="10"

                    >
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value=""  />
                                
                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.checked}"  />
                        </h:column>
                        
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Acción Terapeútica"  />
                            </f:facet>
                            <h:outputText value="#{data.nombreAccionTerapeutica}"  />
                        </h:column>
                        
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Descripción"  />
                            </f:facet>
                            <h:outputText value="#{data.obsAccionTerapeutica}"  />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Estado"  />
                            </f:facet>
                            <h:outputText value="#{data.estadoReferencial.nombreEstadoRegistro}" styleClass="" />
                        </h:column>
                    </rich:dataTable--%>
                    
                    <br>
                    <h:commandButton value="Registrar" styleClass="commandButton"  action="#{ManagedAccionesTerapeuticas.Guardar}"/>
                    <h:commandButton value="Editar"  styleClass="commandButton"  action="#{ManagedAccionesTerapeuticas.actionEditar}" onclick="return editarItem('form1:dataCadenaCliente');"/>
                    <h:commandButton value="Eliminar"  styleClass="commandButton"  action="#{ManagedAccionesTerapeuticas.actionEliminar}"  onclick="return eliminarItem('form1:dataCadenaCliente');"/>
                    
                </div>
                <!--cerrando la conexion-->
                <h:outputText value="#{ManagedAccionesTerapeuticas.closeConnection}"  />
            </h:form>
            
            
        </body>
    </html>
    
</f:view>

