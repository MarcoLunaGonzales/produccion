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
    
    <br/> 
    <div align="center">
        <br>
        <h:outputText value="Eliminar Acciones Terapeúticas" styleClass="tituloCabezera1"    />
        <br>  
        <h:panelGrid rendered="#{ManagedAccionesTerapeuticas.swEliminaSi}" columns="3" styleClass="" headerClass="">
            <f:facet name="header" >
                <h:outputText value="Estos datos pueden ser Eliminados " styleClass="outputText2"   />
            </f:facet>   
            <div align="center">
            <br>
            <rich:dataTable value="#{ManagedAccionesTerapeuticas.accionesTerapeuticasEliminar}" var="data" 
                            id="dataCliente"  onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                            onRowMouseOver="this.style.backgroundColor='#CCDFFA';" 
                            headerClass="headerClassACliente"
                            columnClasses="tituloCampo">                                
                
                
                <h:column>
                    <f:facet name="header">
                        <h:outputText value="Acción Terapeútica"  />
                    </f:facet>
                    <h:outputText value="#{data.nombreAccionTerapeutica}"  />
                </h:column>
                
                <h:column>
                    <f:facet name="header">
                        <h:outputText value="Descripción"  />
                    </f:facet>
                    <h:outputText value="#{data.obsAccionTerapeutica}"  />
                </h:column>
                <h:column>
                    <f:facet name="header">
                        <h:outputText value="Estado"  />
                    </f:facet>
                    <h:outputText value="#{data.estadoReferencial.nombreEstadoRegistro}" styleClass="" />
                </h:column >           
            </rich:dataTable>
        </h:panelGrid> 
    </div>
    <br>
    <h:panelGrid rendered="#{ManagedAccionesTerapeuticas.swEliminaNo}" columns="3" styleClass="" headerClass="">
        <f:facet name="header" >
            <h:outputText value="Estos datos no pueden ser Eliminados " styleClass="outputText2"    />
        </f:facet>  
        <div align="center">
        <rich:dataTable value="#{ManagedAccionesTerapeuticas.accionesTerapeuticasNoEliminar}" var="data" 
                        id="dataCliente1"  onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                        onRowMouseOver="this.style.backgroundColor='#CCDFFA';" 
                        headerClass="headerClassACliente"
                        columnClasses="tituloCampo">
            
            
            <h:column>
                <f:facet name="header">
                    <h:outputText value="Acción Terapeútica"  />
                </f:facet>
                <h:outputText value="#{data.nombreAccionTerapeutica}"  />
            </h:column>
            
            <h:column>
                <f:facet name="header">
                    <h:outputText value="Descripción"  />
                </f:facet>
                <h:outputText value="#{data.obsAccionTerapeutica}"  />
            </h:column>
            <h:column>
                <f:facet name="header">
                    <h:outputText value="Estado"  />
                </f:facet>
                <h:outputText value="#{data.estadoReferencial.nombreEstadoRegistro}" styleClass="tituloCampo" />
            </h:column>                        
        </rich:dataTable>
    </h:panelGrid> 
    
    <h:commandButton value="Eliminar"  styleClass="commandButton"  action="#{ManagedAccionesTerapeuticas.eliminarPrincipiosActivos}"  onclick="return eliminarItem('form1:dataCliente');"/>
    <h:commandButton value="Cancelar"  styleClass="commandButton" action="#{ManagedAccionesTerapeuticas.Cancelar}"/>    
    </div>                                
    <!--cerrando la conexion-->    
</h:form>


</body>
</html>

</f:view>






