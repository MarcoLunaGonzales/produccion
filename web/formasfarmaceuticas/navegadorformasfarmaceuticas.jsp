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
                    <h:outputText value="Formas Farmaceúticas" styleClass="tituloCabezera1"    />
                   
                    <br>  <br>  
                   <h:outputText value="Estado ::" styleClass="tituloCabezera"    />
                    <h:selectOneMenu value="#{ManagedFormasFarmaceuticas.formaFarmaceutica.estadoReferencial.codEstadoRegistro}" styleClass="inputText" 
                                     valueChangeListener="#{ManagedFormasFarmaceuticas.changeEvent}">
                        <f:selectItems value="#{ManagedEstadosReferenciales.estadosReferenciales}"  />
                        <a4j:support event="onchange"  reRender="dataFormasFarmaceuticas"  />
                    </h:selectOneMenu>   
                    <br><br>
                    <rich:dataTable value="#{ManagedFormasFarmaceuticas.formasFarmaceuticasList}" var="data" id="dataFormasFarmaceuticas" 
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#CCDFFA';" 
                                    headerClass="headerClassACliente" columnClasses="tituloCampo"
                                    
                                    >
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value=""  />
                                
                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.checked}"  />
                        </rich:column>        
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
                                <h:outputText value="Descripción"  />
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
                     
                    <br>
                    <h:commandButton value="Registrar" styleClass="commandButton"  action="#{ManagedFormasFarmaceuticas.actionSaveFormasFarmaceuticas}"/>
                    <h:commandButton value="Editar"  styleClass="commandButton"  action="#{ManagedFormasFarmaceuticas.actionEditFormasFarmaceuticas}" onclick="return editarItem('form1:dataFormasFarmaceuticas');" />
                    <h:commandButton value="Eliminar"  styleClass="commandButton"  action="#{ManagedFormasFarmaceuticas.actionDeleteFormasFarmaceuticas}"onclick="return eliminarItem('form1:dataFormasFarmaceuticas');" />
                </div>
            </h:form>
        </body>
    </html>
    
</f:view>

