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
                    <h:outputText value="Envases Primarios" styleClass="tituloCabezera1"  />
                    <br><br>
                    <h:outputText value="Estado ::" styleClass="tituloCabezera"  />
                    
                    <h:selectOneMenu value="#{ManagedEnvasesPrimarios.envasePrimario.estadoReferencial.codEstadoRegistro}" styleClass="inputText" 
                                     valueChangeListener="#{ManagedEnvasesPrimarios.changeEvent}">
                        <f:selectItems value="#{ManagedEstadosReferenciales.estadosReferenciales}"  />
                        <a4j:support event="onchange"  reRender="dataEnvasesPrimarios"  />
                    </h:selectOneMenu> 
                    <br> <br>                               
                    <rich:dataTable value="#{ManagedEnvasesPrimarios.envasesPrimariosList}" var="data" id="dataEnvasesPrimarios" 
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#CCDFFA';" 
                                    columnClasses="tituloCampo"
                                    headerClass="headerClassACliente"  >
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value=""  />
                                
                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.checked}"  />
                        </rich:column>        
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Envase Primario"  />
                            </f:facet>
                            <h:outputText value="#{data.nombreEnvasePrim}"  />
                        </rich:column>
                        
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value="Observaciones"  />
                            </f:facet>
                            <h:outputText value="#{data.obsEnvasePrim}"  />
                        </rich:column>
                        
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value="Estado Registro"  />
                            </f:facet>
                            <h:outputText value="#{data.estadoReferencial.nombreEstadoRegistro}"  />
                        </rich:column>
                        
                        
                    </rich:dataTable>
                   
                    <br>
                    <h:commandButton value="Agregar" styleClass="commandButton"  action="#{ManagedEnvasesPrimarios.actionSaveEnvasesPrimarios}"/>
                    <h:commandButton value="Editar"  styleClass="commandButton"  action="#{ManagedEnvasesPrimarios.actionEditEnvasesPrimarios}" onclick="return editarItem('form1:dataEnvasesPrimarios');"/>
                    <h:commandButton value="Eliminar"  styleClass="commandButton"  action="#{ManagedEnvasesPrimarios.actionDeleteEnvasesPrimarios}"  onclick="return eliminarItem('form1:dataEnvasesPrimarios');"/>                    
                </div>                
            </h:form>
            
            
        </body>
    </html>
    
</f:view>

