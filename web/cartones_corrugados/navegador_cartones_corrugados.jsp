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
                    <h:outputText value="Cartones Corrugados" styleClass="tituloCabezera1"    />
                    <br>  <br>  
                   <h:outputText value="Estado ::" styleClass="tituloCabezera"    />
                    <h:selectOneMenu value="#{ManagedCartonesCorrugados.cartonesCorrugadosbean.estadoReferencial.codEstadoRegistro}" styleClass="inputText" 
                                     valueChangeListener="#{ManagedCartonesCorrugados.changeEvent}">
                        <f:selectItems value="#{ManagedEstadosReferenciales.estadosReferenciales}"  />
                        <a4j:support event="onchange"  reRender="dataCadenaCliente"  />
                    </h:selectOneMenu>   
                    <br>
                    <br>                          
                    <rich:dataTable value="#{ManagedCartonesCorrugados.cartonesCorrugados}" var="data" id="dataCadenaCliente" 
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
                                <h:outputText value="Cartón Corrugado"  />
                            </f:facet>
                            <h:outputText value="#{data.nombreCarton}"  />
                        </h:column>
                       
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Dimensión Largo"  />
                            </f:facet>
                            <h:outputText value="#{data.dimLargo}"  />
                        </h:column>
                          <h:column>
                            <f:facet name="header">
                                <h:outputText value="Dimensión Alto"  />
                            </f:facet>
                            <h:outputText value="#{data.dimAlto}"  />
                        </h:column>
                          <h:column>
                            <f:facet name="header">
                                <h:outputText value="Dimensión Ancho"  />
                            </f:facet>
                            <h:outputText value="#{data.dimAncho}"  />
                        </h:column>
                          <h:column>
                            <f:facet name="header">
                                <h:outputText value="Peso Gramos"  />
                            </f:facet>
                            <h:outputText value="#{data.pesoGramos}"  />
                        </h:column>
                          <h:column>
                            <f:facet name="header">
                                <h:outputText value="Descripción"  />
                            </f:facet>
                            <h:outputText value="#{data.obsCarton}"  />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Estado"  />
                            </f:facet>
                            <h:outputText value="#{data.estadoReferencial.nombreEstadoRegistro}" styleClass="" />
                        </h:column>
                    </rich:dataTable>
                    
                    <br>
                    <h:commandButton value="Registrar" styleClass="commandButton"  action="#{ManagedCartonesCorrugados.Guardar}"/>
                    <h:commandButton value="Editar"  styleClass="commandButton"  action="#{ManagedCartonesCorrugados.actionEditar}" onclick="return editarItem('form1:dataCadenaCliente');"/>
                    <h:commandButton value="Eliminar"  styleClass="commandButton"  action="#{ManagedCartonesCorrugados.actionEliminar}"  onclick="return eliminarItem('form1:dataCadenaCliente');"/>
                    
                </div>
                <!--cerrando la conexion-->
                <h:outputText value="#{ManagedCartonesCorrugados.closeConnection}"  />
            </h:form>
            
            
        </body>
    </html>
    
</f:view>

