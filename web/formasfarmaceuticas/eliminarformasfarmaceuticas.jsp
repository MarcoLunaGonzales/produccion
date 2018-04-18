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
                    <h:outputText value="Eliminar Formas Farmaceúticas" styleClass="tituloCabezera1"  />
                    <br>
                    <br>    
                    <h:panelGrid rendered="#{ManagedFormasFarmaceuticas.swElimina1}" columns="3" styleClass="" headerClass="">
                        <f:facet name="header" >
                            <h:outputText value="Estos datos pueden ser Eliminados " styleClass="outputText2"    />
                        </f:facet>   
                        <rich:dataTable value="#{ManagedFormasFarmaceuticas.formaFarmaceuticaEli}" var="data" id="dataFormasFarmaceuticas" 
                                        onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                        onRowMouseOver="this.style.backgroundColor='#CCDFFA';" 
                                        columnClasses="tituloCampo"
                                        headerClass="headerClassACliente"  >
                            <rich:column>
                                <f:facet name="header">
                                    <h:outputText value="Forma Farmaceútica"  />
                                </f:facet>
                                <h:outputText value="#{data.nombreForma}"  />
                            </rich:column>
                            
                            <rich:column >
                                <f:facet name="header">
                                    <h:outputText value="Abreviatura"  />
                                </f:facet>
                                <h:outputText value="#{data.abreviaturaForma}"  />
                            </rich:column>
                            <rich:column >
                                <f:facet name="header">
                                    <h:outputText value="Unidad de Medida"  />
                                </f:facet>
                                <h:outputText value="#{data.unidadMedida.nombreUnidadMedida}"  />
                            </rich:column>
                            <rich:column >
                                <f:facet name="header">
                                    <h:outputText value="Descripión"  />
                                </f:facet>
                                <h:outputText value="#{data.obsForma}"  />
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
                    <h:panelGrid rendered="#{ManagedFormasFarmaceuticas.swElimina2}" columns="3" styleClass="" headerClass="">
                        <f:facet name="header" >
                            <h:outputText value="Estos datos no pueden ser Eliminados " styleClass="tituloCabezera"    />
                        </f:facet>  
                        
                        <rich:dataTable value="#{ManagedFormasFarmaceuticas.formaFarmaceuticaEli2}" var="data2" id="dataFormasFarmaceuticas1" 
                                        onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                        onRowMouseOver="this.style.backgroundColor='#CCDFFA';" 

                                        headerClass="headerClassACliente"  >
                            
                            <rich:column>
                                <f:facet name="header">
                                    <h:outputText value="Forma Farmaceútica"  />
                                </f:facet>
                                <h:outputText value="#{data2.nombreForma}"  />
                            </rich:column>
                            
                            <rich:column >
                                <f:facet name="header">
                                    <h:outputText value="Abreviatura"  />
                                </f:facet>
                                <h:outputText value="#{data2.abreviaturaForma}"  />
                            </rich:column>
                            <rich:column >
                                <f:facet name="header">
                                    <h:outputText value="Unidad de Medida"  />
                                </f:facet>
                                <h:outputText value="#{data2.unidadMedida.nombreUnidadMedida}"  />
                            </rich:column>
                            <rich:column >
                                <f:facet name="header">
                                    <h:outputText value="Descripión"  />
                                </f:facet>
                                <h:outputText value="#{data2.obsForma}"  />
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
                    <h:commandButton value="Eliminar" styleClass="commandButton"  action="#{ManagedFormasFarmaceuticas.deleteFormasFarmaceuticas}"/>
                    <h:commandButton value="Cancelar"  styleClass="commandButton"  action="navegadorformasfarmaceuticas" />                
                </div>                
            </h:form>            
        </body>
    </html>
    
</f:view>

