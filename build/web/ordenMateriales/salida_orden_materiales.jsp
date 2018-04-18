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
    <script type="text/javascript" src="../js/general.js" ></script> 
    <script>
    </script>
</head>
<body >
<h:form id="form1">               
<div align="center">
        <h:outputText value="#{ManagedSolMantenimiento.SolMantenimient}"   />
        <h:outputText styleClass="outputTextTitulo"  value="Orden de Trabajo" />                    
        <br><br>


        <h:outputText styleClass="outputTextTitulo"  value="Fecha de Salida de Materiales::" />
        <h:inputText styleClass="inputText" size="20" value="#{data.fecha}" /> 
        <br><br>

    <rich:dataTable value="#{ManagedSolMantenimiento.SolMantenimient}" var="data" id="dataCliente" 
                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                    onRowMouseOver="this.style.backgroundColor='#CCDFFA';" 
                    headerClass="headerClassACliente">
        
        <rich:column> 
            <f:facet name="header">
                <h:outputText value="Nro." />
            </f:facet> 
            <h:outputText styleClass="outputText2" value="#{data.cantENro}" /> 
        </rich:column> 
        
        <rich:column>
            <f:facet name="header">
                <h:outputText value="Material" />
            </f:facet>    
            <h:outputText styleClass="outputText2" value="#{data.cantEMaterial}" />
        </rich:column>    
        
        <rich:column>
            <f:facet name = "header">
                <h:outputText value= "Cantidad " />
            </f:facet>  
            <h:outputText styleClass="outputText2" value="#{data.cantECantCompra}" />
        </rich:column> 
        
    </rich:dataTable>
    <br><br>       
    <h:commandButton value="Guardar" styleClass="btn" action="#{ManagedSolMantenimiento.actionagregar}"/>
    <h:commandButton value="Cancelar" styleClass="btn"   action="#{ManagedSolMantenimiento.cancelar}"/>  
</div>
</h:form>
</body>
</html>
</f:view>

