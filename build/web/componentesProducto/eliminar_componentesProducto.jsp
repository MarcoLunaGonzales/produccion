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
        <h:outputText value="Eliminar Producto(s) Semiterminado(s) " styleClass="tituloCabezera1"    />
        <br>  
        <h:panelGrid rendered="#{ManagedComponentesProducto.swEliminaSi}" columns="3" styleClass="" headerClass="" width="80%">
            <div align="center">
            <br>
            <rich:dataTable align="center" value="#{ManagedComponentesProducto.componentesProductoEliminar}" var="data" 
                            id="dataCliente"  onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                            onRowMouseOver="this.style.backgroundColor='#CCDFFA';" 
                            headerClass="headerClassACliente"
                            columnClasses="tituloCampo">                                
                <h:column >
                    <f:facet name="header">
                        <h:outputText value="Nombre Producto Semiterminado"  />
                    </f:facet>
                    <h:outputText value="#{data.nombreProdSemiterminado}"  />
                </h:column >  
                
                <h:column>
                    <f:facet name="header">
                        <h:outputText value="Forma Farmacéutica"  />
                    </f:facet>
                    <h:outputText value="#{data.forma.nombreForma}"  />
                </h:column>
                <h:column>
                    <f:facet name="header">
                        <h:outputText value="Envase Primario"  />
                    </f:facet>
                    <h:outputText value="#{data.envasesPrimarios.nombreEnvasePrim}"  />
                </h:column>
                <h:column>
                    <f:facet name="header">
                        <h:outputText value="Color Presentación Primaria"  />
                    </f:facet>
                    <h:outputText value="#{data.coloresPresentacion.nombreColor}"  />
                </h:column> 
                <h:column>
                    <f:facet name="header">
                        <h:outputText value="Sabor"  />
                    </f:facet>
                    <h:outputText value="#{data.saboresProductos.nombreSabor}"  />
                </h:column>
                <h:column>
                    <f:facet name="header">
                        <h:outputText value="Volúmen/Concentración"  />
                    </f:facet>
                    <h:outputText value="#{data.volumenPesoEnvasePrim}"  />
                </h:column>
                <h:column>
                    <f:facet name="header">
                        <h:outputText value="Área de Fabricación"  />
                    </f:facet>
                    <h:outputText value="#{data.areasEmpresa.nombreAreaEmpresa}"  />
                </h:column>
                <h:column>
                    <f:facet name="header">
                        <h:outputText value="Tipo Producción"  />
                    </f:facet>
                    <h:outputText value="#{data.tipoProduccion.nombreTipoProduccion}"  />
                </h:column>
            </rich:dataTable>
        </h:panelGrid> 
    </div>
    <br>
    <h:panelGrid rendered="#{ManagedComponentesProducto.swEliminaNo}" columns="3" styleClass="" headerClass="">
        <f:facet name="header" >
            <h:outputText value="Estos datos no pueden ser Eliminados " styleClass="outputText2"    />
        </f:facet>  
        <div align="center">
        <rich:dataTable value="#{ManagedComponentesProducto.componentesProductoNoEliminar}" var="data" 
                        id="dataCliente1"  onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                        onRowMouseOver="this.style.backgroundColor='#CCDFFA';" 
                        headerClass="headerClassACliente"
                        columnClasses="tituloCampo">
           <h:column >
                    <f:facet name="header">
                        <h:outputText value="Nombre Producto Semiterminado"  />
                    </f:facet>
                    <h:outputText value="#{data.nombreProdSemiterminado}"  />
                </h:column >  
                
                <h:column>
                    <f:facet name="header">
                        <h:outputText value="Forma Farmacéutica"  />
                    </f:facet>
                    <h:outputText value="#{data.forma.nombreForma}"  />
                </h:column>
                <h:column>
                    <f:facet name="header">
                        <h:outputText value="Envase Primario"  />
                    </f:facet>
                    <h:outputText value="#{data.envasesPrimarios.nombreEnvasePrim}"  />
                </h:column>
                <h:column>
                    <f:facet name="header">
                        <h:outputText value="Color Presentación Primaria"  />
                    </f:facet>
                    <h:outputText value="#{data.coloresPresentacion.nombreColor}"  />
                </h:column> 
                <h:column>
                    <f:facet name="header">
                        <h:outputText value="Sabor"  />
                    </f:facet>
                    <h:outputText value="#{data.saboresProductos.nombreSabor}"  />
                </h:column>
                <h:column>
                    <f:facet name="header">
                        <h:outputText value="Volúmen/Concentración"  />
                    </f:facet>
                    <h:outputText value="#{data.volumenPesoEnvasePrim}"  />
                </h:column>
                <h:column>
                    <f:facet name="header">
                        <h:outputText value="Área de Fabricación"  />
                    </f:facet>
                    <h:outputText value="#{data.areasEmpresa.nombreAreaEmpresa}"  />
                </h:column>
                <h:column>
                    <f:facet name="header">
                        <h:outputText value="Tipo Producción"  />
                    </f:facet>
                    <h:outputText value="#{data.tipoProduccion.nombreTipoProduccion}"  />
                </h:column>
        </rich:dataTable>
    </h:panelGrid> 
    
    <h:commandButton value="Eliminar"  styleClass="commandButton"  action="#{ManagedComponentesProducto.eliminarComponentesProd}"  onclick="return eliminarItem('form1:dataCliente');"/>
    <h:commandButton value="Cancelar"  styleClass="commandButton" action="#{ManagedComponentesProducto.Cancelar}"/>    
    </div>                                
    <!--cerrando la conexion-->    
</h:form>


</body>
</html>

</f:view>






