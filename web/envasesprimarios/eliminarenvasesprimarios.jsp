<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>


<f:view>
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
            <script type="text/javascript" src='../js/general.js' ></script> 
        </head>
        <body>
            <h:form id="form1"  >                
                <div align="center">
                    <br>
                    <h:outputText value="Eliminar Envases Primarios" styleClass="tituloCabezera1"  />
                    <br>
                          
                    <h:panelGrid rendered="#{ManagedEnvasesPrimarios.swElimina1}" columns="3" styleClass="" headerClass="">
                        <f:facet name="header" >
                            <h:outputText value="Estos datos pueden ser Eliminados " styleClass="outputText2"    />
                        </f:facet>   
                        
                        <rich:dataTable value="#{ManagedEnvasesPrimarios.envasePrimarioEli}" var="data" id="dataEnvasesPrimarios" 
                                        onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                        onRowMouseOver="this.style.backgroundColor='#CCDFFA';" 
                                        columnClasses="tituloCampo"
                                        headerClass="headerClassACliente"  >
                            
                            <rich:column>
                                <f:facet name="header">
                                    <h:outputText value="Nombre"  />
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
                    </h:panelGrid>
                    <br>
                    <h:panelGrid rendered="#{ManagedEnvasesPrimarios.swElimina2}" columns="3" styleClass="" headerClass="">
                        <f:facet name="header" >
                            <h:outputText value="Estos datos no pueden ser Eliminados " styleClass="outputText2"   />
                        </f:facet>  
                        
                        <rich:dataTable value="#{ManagedEnvasesPrimarios.envasePrimarioEli2}" var="data2" id="dataEnvasesPrimarios1" 
                                        onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                        onRowMouseOver="this.style.backgroundColor='#CCDFFA';" 
                                        columnClasses="tituloCampo"
                                        headerClass="headerClassACliente"  >
                            
                            <rich:column>
                                <f:facet name="header">
                                    <h:outputText value="Nombre"  />
                                </f:facet>
                                <h:outputText value="#{data2.nombreEnvasePrim}"  />
                            </rich:column>
                            
                            <rich:column >
                                <f:facet name="header">
                                    <h:outputText value="Observaciones"  />
                                </f:facet>
                                <h:outputText value="#{data2.obsEnvasePrim}"  />
                            </rich:column>
                            
                            <rich:column >
                                <f:facet name="header">
                                    <h:outputText value="Estado Registro"  />
                                </f:facet>
                                <h:outputText value="#{data2.estadoReferencial.nombreEstadoRegistro}"  />
                            </rich:column>
                            
                            
                        </rich:dataTable>
                    </h:panelGrid>
                    <br>
                    
                    <h:commandButton value="Eliminar" styleClass="commandButton"  action="#{ManagedEnvasesPrimarios.deleteEnvasesPrimarios}"/>
                    <h:commandButton value="Cancelar"  styleClass="commandButton"  action="navegadorenvasesprimarios" />                                
                </div>
            </h:form>
            
            
        </body>
    </html>
    
</f:view>

