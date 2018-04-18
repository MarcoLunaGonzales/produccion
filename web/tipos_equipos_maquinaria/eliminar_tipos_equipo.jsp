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
                    <br><br>
                    <h:outputText value="Eliminar Tipos de Maquinaria" styleClass="tituloCabezera1" />
                    <br>
                    <br>
                    <h:panelGrid rendered="#{ManagedTiposEquipo.swElimina1}" columns="3" styleClass="" headerClass="">
                        <f:facet name="header" >
                            <h:outputText value="Estos datos pueden ser Eliminados " styleClass="outputText2"   />
                        </f:facet>                    
                        <rich:dataTable value="#{ManagedTiposEquipo.tiposEquipoEliminarList}" var="data" id="dataCliente" 
                                        onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                        onRowMouseOver="this.style.backgroundColor='#CCDFFA';" 
                                        headerClass="headerClassACliente" columnClasses="tituloCampo"
                        >
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
                    </h:panelGrid>
                    
                    <br>
                    <h:commandButton value="Eliminar" styleClass="commandButton"  action="#{ManagedTiposEquipo.deleteTipoEquipo}"/>
                    <h:commandButton value="Cancelar"  styleClass="commandButton"  action="navegadorTiposEquipo" />
                    
                    
                </div>
                
                <!--cerrando la conexion-->
                <%--<h:outputText value="#{tipociente.closeConnection}"  />--%>
            </h:form>
            
            
        </body>
    </html>
    
</f:view>

