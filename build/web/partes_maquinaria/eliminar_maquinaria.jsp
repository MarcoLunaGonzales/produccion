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
        <h:outputText value="Eliminar Maquinarias" styleClass="tituloCabezera1"    />
        <br>  
        <h:panelGrid rendered="#{ManagedMaquinaria.swEliminaSi}" columns="3" styleClass="" headerClass="">
            <f:facet name="header" >
                <h:outputText value="Estos datos pueden ser Eliminados " styleClass="outputText2"   />
            </f:facet>   
            <div align="center">
            <br>
            <rich:dataTable value="#{ManagedMaquinaria.maquinariaEliminarList}" var="data" 
                            id="dataCliente"  onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                            onRowMouseOver="this.style.backgroundColor='#CCDFFA';" 
                            headerClass="headerClassACliente"
                            columnClasses="tituloCampo">                                
                
                <h:column>
                    <f:facet name="header">
                        <h:outputText value="Código - Area"  />
                    </f:facet>
                    <h:outputText value="#{data.codigo}"  title="Código" />
                </h:column>
                <h:column>
                    <f:facet name="header">
                        <h:outputText value="Maquina"  />
                    </f:facet>
                    <h:outputText value="#{data.nombreMaquina}"  title="Maquina" />
                </h:column>
                <h:column>
                    <f:facet name="header">
                        <h:outputText value="Fecha de Compra"  />
                    </f:facet>
                    <h:outputText value="#{data.fechaCompra}" title="Fecha de Compra" />
                </h:column> 
                <h:column>
                    <f:facet name="header">
                        <h:outputText value="Observación"  />
                    </f:facet>
                    <h:outputText value="#{data.obsMaquina}"  title="Observacion" />
                </h:column>
                <h:column >
                    <f:facet name="header">
                        <h:outputText value="Estado de Registro"  />
                    </f:facet>
                    <h:outputText value="#{data.estadoReferencial.nombreEstadoRegistro}" />
                </h:column>
            </rich:dataTable>
        </h:panelGrid> 
    </div>
    <br>
    <h:panelGrid rendered="#{ManagedMaquinaria.swEliminaNo}" columns="3" styleClass="" headerClass="">
        <f:facet name="header" >
            <h:outputText value="Estos datos no pueden ser Eliminados " styleClass="outputText2"    />
        </f:facet>  
        <div align="center">
        <rich:dataTable value="#{ManagedMaquinaria.maquinariaNoEliminarList}" var="data" 
                        id="dataCliente1"  onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                        onRowMouseOver="this.style.backgroundColor='#CCDFFA';" 
                        headerClass="headerClassACliente"
                        columnClasses="tituloCampo">
            
            <h:column>
                <f:facet name="header">
                    <h:outputText value="Código - Area"  />
                </f:facet>
                <h:outputText value="#{data.codigo}"  title="Código" />
            </h:column>
            <h:column>
                <f:facet name="header">
                    <h:outputText value="Maquina"  />
                </f:facet>
                <h:outputText value="#{data.nombreMaquina}"  title="Maquina" />
            </h:column>
            <h:column>
                <f:facet name="header">
                    <h:outputText value="Fecha de Compra"  />
                </f:facet>
                <h:outputText value="#{data.fechaCompra}" title="Fecha de Compra" />
            </h:column> 
            <h:column>
                <f:facet name="header">
                    <h:outputText value="Observación"  />
                </f:facet>
                <h:outputText value="#{data.obsMaquina}"  title="Observacion" />
            </h:column>
            <h:column >
                <f:facet name="header">
                    <h:outputText value="Estado de Registro"  />
                </f:facet>
                <h:outputText value="#{data.estadoReferencial.nombreEstadoRegistro}" />
            </h:column>          
        </rich:dataTable>
    </h:panelGrid> 
    
    <h:commandButton value="Eliminar"  styleClass="btn"  action="#{ManagedMaquinaria.eliminarMaquinaria}"  onclick="return eliminarItem('form1:dataCliente');"/>
    <h:commandButton value="Cancelar"  styleClass="btn" action="#{ManagedMaquinaria.Cancelar}"/>    
    </div>                                
    <!--cerrando la conexion-->    
</h:form>


</body>
</html>

</f:view>






