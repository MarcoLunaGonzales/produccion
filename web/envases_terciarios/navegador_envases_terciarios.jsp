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
                    <h:outputText value="Envases Terciarios" styleClass="tituloCabezera1" />                    
                    <br><br>
                     <h:outputText value="Estado ::" styleClass="tituloCabezera"    />
                    <h:selectOneMenu value="#{ManagedEnvasesTerciarios.envasesTerciariosbean.estadoReferencial.codEstadoRegistro}" styleClass="inputText" 
                                     valueChangeListener="#{ManagedEnvasesTerciarios.changeEvent}">
                        <f:selectItems value="#{ManagedEstadosReferenciales.estadosReferenciales}"  />
                        <a4j:support event="onchange"  reRender="dataCliente"  />
                    </h:selectOneMenu>   
                    <br><br>
                    <rich:dataTable value="#{ManagedEnvasesTerciarios.envasesTerciariosList}" var="data" id="dataCliente" 
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
                                <h:outputText value="Envase Terciario"  />
                            </f:facet>
                            <h:outputText value="#{data.nombreEnvaseTerciario}"  />
                        </rich:column>
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Descripción"  />
                            </f:facet>
                            <h:outputText value="#{data.obsEnvaseTerciario}"  />
                        </rich:column>                   
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value="Estado"  />
                            </f:facet>
                            <h:outputText value="#{data.estadoReferencial.nombreEstadoRegistro}"  />
                        </rich:column>                    
                    </rich:dataTable>
                   
                    <br> 
                  
                    <h:commandButton value="Registrar" styleClass="commandButton"  action="#{ManagedEnvasesTerciarios.actionSaveEnvasesTerciarios}"/>
                    <h:commandButton value="Editar"  styleClass="commandButton"  action="#{ManagedEnvasesTerciarios.actionEditEnvasesTerciarios}" onclick="return editarItem('form1:dataCliente');"/>
                    <h:commandButton value="Eliminar"  styleClass="commandButton"  action="#{ManagedEnvasesTerciarios.actionDeleteEnvasesTerciarios}"  onclick="return eliminarItem('form1:dataCliente');"/>
                </div>                                
                <!--cerrando la conexion-->
                <h:outputText value="#{ManagedEnvasesTerciarios.closeConnection}"  />
            </h:form>
            
            
        </body>
    </html>
    
</f:view>

