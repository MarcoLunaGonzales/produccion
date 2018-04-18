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
                    <h:outputText value="Eliminar Envases Primarios" styleClass="tituloCabezera1"    />
                    
                    <br><br>
                    <h:panelGrid rendered="#{ManagedEnvasessecundarios.swElimina1}" columns="3" styleClass="" headerClass="">
                        <f:facet name="header" >
                            <h:outputText value="Estos datos pueden ser Eliminados " styleClass="outputText2"   />
                        </f:facet>                    
                        <rich:dataTable value="#{ManagedEnvasessecundarios.envasesSecundariosEli}" var="data" id="dataCliente" 
                                        onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                        onRowMouseOver="this.style.backgroundColor='#CCDFFA';"
                                        headerClass="headerClassACliente" columnClasses="tituloCampo"
                        >
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
                            <rich:column>
                                <f:facet name="header">
                                    <h:outputText value="Estado Registro"  />
                                </f:facet>
                                <h:outputText value="#{data.estadoReferencial.nombreEstadoRegistro}"  />
                            </rich:column>
                        </rich:dataTable>
                    </h:panelGrid>
                    <br>
                    <h:panelGrid rendered="#{ManagedEnvasessecundarios.swElimina2}" columns="3" styleClass="" headerClass="">
                        <f:facet name="header" >
                            <h:outputText value="Estos datos no pueden ser Eliminados " styleClass="outputText2"    />
                        </f:facet>    
                        <rich:dataTable value="#{ManagedEnvasessecundarios.envasesSecundariosEli2}" var="data2" id="dataCliente2" 
                                        onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                        onRowMouseOver="this.style.backgroundColor='#CCDFFA';" 
                                        headerClass="headerClassACliente" columnClasses="tituloCampo"
                        >
                            <rich:column>
                                <f:facet name="header">
                                    <h:outputText value="Envase Secundario"  />
                                </f:facet>
                                <h:outputText value="#{data2.nombreEnvaseSec}"  />
                            </rich:column>
                            <rich:column>
                                <f:facet name="header">
                                    <h:outputText value="Descripción"  />
                                </f:facet>
                                <h:outputText value="#{data2.obsEnvaseSec}"  />
                            </rich:column>
                            <rich:column>
                                <f:facet name="header">
                                    <h:outputText value="Estado Registro"  />
                                </f:facet>
                                <h:outputText value="#{data2.estadoReferencial.nombreEstadoRegistro}"  />
                            </rich:column>
                        </rich:dataTable>
                    </h:panelGrid>
                    <br>
                    <h:commandButton value="Eliminar" styleClass="commandButton"  action="#{ManagedEnvasessecundarios.deleteEnvasesSecundarios}"/>
                    <h:commandButton value="Cancelar"  styleClass="commandButton"  action="navegadorenvasessecundarios" />                                
                </div>                                
                <!--cerrando la conexion-->
                <%--<h:outputText value="#{tipociente.closeConnection}"  />--%>
            </h:form>
            
            
        </body>
    </html>
    
</f:view>

