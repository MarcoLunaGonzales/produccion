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
                    <h:outputText value="Eliminar Envases Terciarios" styleClass="tituloCabezera1"    />
                    
                    <br><br>
                    <h:panelGrid rendered="#{ManagedEnvasesTerciarios.swEliminaSi}" columns="3" styleClass="" headerClass="">
                        <f:facet name="header" >
                            <h:outputText value="Estos datos pueden ser Eliminados " styleClass="outputText2"   />
                        </f:facet>                    
                        <rich:dataTable value="#{ManagedEnvasesTerciarios.envasesTerciariosEliminar}" var="data" id="dataCliente" 
                                        onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                        onRowMouseOver="this.style.backgroundColor='#CCDFFA';"
                                        headerClass="headerClassACliente" columnClasses="tituloCampo"
                        >
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
                    </h:panelGrid>
                   
                    <h:panelGrid rendered="#{ManagedEnvasesTerciarios.swEliminaNo}" columns="3" styleClass="" headerClass="">
                        <f:facet name="header" >
                            <h:outputText value="Estos datos no pueden ser Eliminados " styleClass="outputText2"    />
                        </f:facet>    
                        <rich:dataTable value="#{ManagedEnvasesTerciarios.envasesTerciariosNoEliminar}" var="data2" id="dataCliente2" 
                                        onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                        onRowMouseOver="this.style.backgroundColor='#CCDFFA';" 
                                        headerClass="headerClassACliente" columnClasses="tituloCampo"
                        >
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
                    </h:panelGrid>
                    <br>
                    <h:commandButton value="Eliminar" styleClass="commandButton"  action="#{ManagedEnvasesTerciarios.deleteEnvasesTerciarios}"/>
                    <h:commandButton value="Cancelar"  styleClass="commandButton"  action="#{ManagedEnvasesTerciarios.Cancelar}" />                                
                </div>                                
                <!--cerrando la conexion-->
                <%--<h:outputText value="#{tipociente.closeConnection}"  />--%>
            </h:form>
            
            
        </body>
    </html>
    
</f:view>

