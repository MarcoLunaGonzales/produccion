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
                    <br><br>
                    <h:outputText value="Tipos de Maquinaria" styleClass="tituloCabezera1" />                    
                    <br><br>
                    <h:outputText value="Estado ::" styleClass="tituloCabezera"    />                  
                    <h:selectOneMenu value="#{ManagedTiposEquipo.tiposEquipobean.estadoReferencial.codEstadoRegistro}" styleClass="inputText" 
                                     valueChangeListener="#{ManagedTiposEquipo.changeEvent}">
                        <f:selectItems value="#{ManagedEstadosReferenciales.estadosReferenciales}"  />
                        <a4j:support event="onchange"  reRender="dataTipoMercaderia"  />
                    </h:selectOneMenu>  
                    <br>
                    <br>
                    <rich:dataTable value="#{ManagedTiposEquipo.tiposEquipoList}" var="data" id="dataTipoMercaderia" 
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
                                <h:outputText value="Tipo de Maquinaria"  />
                            </f:facet>
                            <h:outputText value="#{data.nombreTipoEquipo}"  />
                        </rich:column>
                 
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value="Estado"  />
                            </f:facet>
                            <h:outputText value="#{data.estadoReferencial.nombreEstadoRegistro}"  />
                        </rich:column>                    
                    </rich:dataTable>
              
                    <br>
                    
                    <h:commandButton value="Registrar" styleClass="commandButton"  action="#{ManagedTiposEquipo.actionSaveTipoEquipo}"/>
                    <h:commandButton value="Editar"  styleClass="commandButton"  action="#{ManagedTiposEquipo.actionEditTiposEquiposMaquinaria}" onclick="return editarItem('form1:ddataTipoMercaderia');"/>
                    <h:commandButton value="Eliminar"  styleClass="commandButton"  action="#{ManagedTiposEquipo.actionDeleteTipoEquipo}"  onclick="return eliminarItem('form1:dataTipoMercaderia');"/>
                    
                </div>
                
                <!--cerrando la conexion-->
                
            </h:form>
            
            
        </body>
    </html>
    
</f:view>

