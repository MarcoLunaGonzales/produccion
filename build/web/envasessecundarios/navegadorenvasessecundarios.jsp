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
        </head>
        <body >            
            <h:form id="form1"  >                
                <div align="center">  
                    <br>
                    <h:outputText value="Envases Secundarios" styleClass="tituloCabezera1" />                    
                    <br><br>
                     <h:outputText value="Estado ::" styleClass="tituloCabezera"    />
                    <h:selectOneMenu value="#{ManagedEnvasessecundarios.envasesSecundarios.estadoReferencial.codEstadoRegistro}" styleClass="inputText" 
                                     valueChangeListener="#{ManagedEnvasessecundarios.changeEvent}">
                        <f:selectItems value="#{ManagedEstadosReferenciales.estadosReferenciales}"  />
                        <a4j:support event="onchange"  reRender="dataCliente"  />
                    </h:selectOneMenu>   
                    <br><br>
                    <rich:dataTable value="#{ManagedEnvasessecundarios.envasesSecundariosList}" var="data" id="dataCliente" 
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#CCDFFA';" 
                                    headerClass="headerClassACliente"  columnClasses="tituloCampo">                                        
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value=""  />
                                
                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.checked}"  />
                        </rich:column>                        
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Envase Secundario"  />
                            </f:facet>
                            <h:outputText value="#{data.nombreEnvaseSec}"  />
                        </rich:column>
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Descripción"  />
                            </f:facet>
                            <h:outputText value="#{data.obsEnvaseSec}"  />
                        </rich:column>                   
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value="Estado"  />
                            </f:facet>
                            <h:outputText value="#{data.estadoReferencial.nombreEstadoRegistro}"  />
                        </rich:column>                    
                    </rich:dataTable>
                
                    <br> 
                  
                    <h:commandButton value="Registrar" styleClass="commandButton"  action="#{ManagedEnvasessecundarios.actionSaveEnvasesSecundarios}"/>
                    <h:commandButton value="Editar"  styleClass="commandButton"  action="#{ManagedEnvasessecundarios.actionEditEnvasesSecundarios}" onclick="return editarItem('form1:dataCliente');"/>
                    <h:commandButton value="Eliminar"  styleClass="commandButton"  action="#{ManagedEnvasessecundarios.actionDeleteEnvasesSecundarios}"  onclick="return eliminarItem('form1:dataCliente');"/>
                </div>                                
                <!--cerrando la conexion-->
                <h:outputText value="#{ManagedEnvasessecundarios.closeConnection}"  />
            </h:form>
            
            
        </body>
    </html>
    
</f:view>

