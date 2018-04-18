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
        <h:outputText value="Eliminar Sabores Producto" styleClass="tituloCabezera1"    />
        <br>  
        <h:panelGrid rendered="#{ManagedSaboresProducto.swEliminaSi}" columns="3" styleClass="" headerClass="">
            <f:facet name="header" >
                <h:outputText value="Estos datos pueden ser Eliminados " styleClass="outputText2"   />
            </f:facet>   
            <div align="center">
            <br>
            <rich:dataTable value="#{ManagedSaboresProducto.saboresProductoEliminar}" var="data" 
                            id="dataCliente"  onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                            onRowMouseOver="this.style.backgroundColor='#CCDFFA';" 
                            headerClass="headerClassACliente"
                            columnClasses="tituloCampo">                                
                
                
                
                <h:column>
                    <f:facet name="header">
                        <h:outputText value="Nombre Sabor"  />
                    </f:facet>
                    <h:outputText value="#{data.nombreSabor}"  />
                </h:column>
                
                <h:column>
                    <f:facet name="header">
                        <h:outputText value="Descripción"  />
                    </f:facet>
                    <h:outputText value="#{data.obsSabor}"  />
                </h:column>
                <h:column>
                    <f:facet name="header">
                        <h:outputText value="Estado"  />
                    </f:facet>
                    <h:outputText value="#{data.estadoReferencial.nombreEstadoRegistro}" styleClass="tituloCampo" />
                </h:column>         
            </rich:dataTable>
        </h:panelGrid> 
    </div>
    <br>
    <h:panelGrid rendered="#{ManagedSaboresProducto.swEliminaNo}" columns="3" styleClass="" headerClass="">
        <f:facet name="header" >
            <h:outputText value="Estos datos no pueden ser Eliminados " styleClass="outputText2"    />
        </f:facet>  
        <div align="center">
        <rich:dataTable value="#{ManagedSaboresProducto.saboresProductoNoEliminar}" var="data" 
                        id="dataCliente1"  onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                        onRowMouseOver="this.style.backgroundColor='#CCDFFA';" 
                        headerClass="headerClassACliente"
                        columnClasses="tituloCampo">
            
            
            
            
            <h:column>
                <f:facet name="header">
                    <h:outputText value="Nombre Sabor"  />
                </f:facet>
                <h:outputText value="#{data.nombreSabor}"  />
            </h:column>
            
            <h:column>
                <f:facet name="header">
                    <h:outputText value="Descripción"  />
                </f:facet>
                <h:outputText value="#{data.obsSabor}"  />
            </h:column>
            <h:column>
                <f:facet name="header">
                    <h:outputText value="Estado"  />
                </f:facet>
                <h:outputText value="#{data.estadoReferencial.nombreEstadoRegistro}" styleClass="tituloCampo" />
            </h:column>                      
        </rich:dataTable>
    </h:panelGrid> 
    
    <h:commandButton value="Eliminar"  styleClass="commandButton"  action="#{ManagedSaboresProducto.eliminarSaboresProducto}"  onclick="return eliminarItem('form1:dataCliente');"/>
    <h:commandButton value="Cancelar"  styleClass="commandButton" action="#{ManagedSaboresProducto.Cancelar}"/>    
    </div>                                
    <!--cerrando la conexion-->    
</h:form>


</body>
</html>

</f:view>






