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
                    <h:outputText value="Sabores Producto" styleClass="tituloCabezera1"    />
                    <br>  <br>  
                   <h:outputText value="Estado ::" styleClass="tituloCabezera"    />
                    <h:selectOneMenu value="#{ManagedSaboresProducto.saboresProductobean.estadoReferencial.codEstadoRegistro}" styleClass="inputText" 
                                     valueChangeListener="#{ManagedSaboresProducto.changeEvent}">
                        <f:selectItems value="#{ManagedEstadosReferenciales.estadosReferenciales}"  />
                        <a4j:support event="onchange"  reRender="dataSabores"  />
                    </h:selectOneMenu>   
                    <br>
                    <br>                          
                    <rich:dataTable value="#{ManagedSaboresProducto.saboresProducto}" var="data" id="dataSabores" 
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
                                <h:outputText value=" Sabor Producto"  />
                            </f:facet>
                            <h:outputText value="#{data.nombreSabor}"  />
                        </h:column>
                       
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Descripción"  />
                            </f:facet>
                            <h:outputText value="#{data.obsSabor}"  />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Estado"  />
                            </f:facet>
                            <h:outputText value="#{data.estadoReferencial.nombreEstadoRegistro}" styleClass="" />
                        </h:column>
                    </rich:dataTable>
              
                    <br>
                    <h:commandButton value="Registrar" styleClass="commandButton"  action="#{ManagedSaboresProducto.Guardar}"/>
                    <h:commandButton value="Editar"  styleClass="commandButton"  action="#{ManagedSaboresProducto.actionEditar}" onclick="return editarItem('form1:dataSabores');"/>
                    <h:commandButton value="Eliminar"  styleClass="commandButton"  action="#{ManagedSaboresProducto.actionEliminar}"  onclick="return eliminarItem('form1:dataSabores');"/>
                    
                </div>
                <!--cerrando la conexion-->
                <h:outputText value="#{ManagedSaboresProducto.closeConnection}"  />
            </h:form>
            
            
        </body>
    </html>
    
</f:view>

