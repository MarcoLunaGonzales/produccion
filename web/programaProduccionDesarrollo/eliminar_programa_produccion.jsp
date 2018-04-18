package programaProduccion_1;

<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>

<html>
<head>
    <title></title>
    <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
    <script type="text/javascript" src='../js/general.js' ></script> 
</head>
<body>
<h:form id="form1"  >
    
    <div align="center">
        Eliminar Formula Maestra
        <br>
        <h:panelGrid columns="3" styleClass="" headerClass="">
            <f:facet name="header" >
                <h:outputText value="Estos datos serán Eliminados " styleClass="outputText2"   />
            </f:facet>   
            <div align="center">
            <br>
            <rich:dataTable value="#{ManagedFormulaMaestra.formulaMaestraEliminar}" var="data" 
                            id="dataCliente"  onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                            onRowMouseOver="this.style.backgroundColor='#CCDFFA';" 
                            headerClass="headerClassACliente">
                
                <h:column>
                    <f:facet name="header">
                        <h:outputText value="Producto"  />
                    </f:facet>
                    <h:outputText value="#{data.componentesProd.nombreProdSemiterminado}"  />
                </h:column>
                <h:column>
                    <f:facet name="header">
                        <h:outputText value="Cantidad del Lote"  />
                    </f:facet>
                    <h:outputText value="#{data.cantidadLote}"  />
                </h:column>                        
                <h:column >
                    <f:facet name="header">
                        <h:outputText value="Estado de Registro"  />
                    </f:facet>
                    <h:outputText value="#{data.estadoRegistro.nombreEstadoRegistro}" />
                </h:column>
                
            </rich:dataTable>
        </h:panelGrid> 
    </div>    
    <br> 
    <h:commandButton value="Eliminar" styleClass="btn" action="#{ManagedFormulaMaestra.eliminarFormulaMaestra}" />
    <h:commandButton value="Cancelar" styleClass="btn"   action="#{ManagedFormulaMaestra.Cancelar}"/>
    </div>
    
</h:form>

</body>
</html>

</f:view>

