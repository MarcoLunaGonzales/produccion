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
        <%--
        <h:outputText styleClass="tituloCabezera1"  value="Solicitud de Orden de Compra" />             
        --%>
         <h5>Solicitud de Orden de Compra</h5>   
        
        <%--
            <h:outputText styleClass="outputTextTitulo"  value="Fecha ::" />
            <h:inputText styleClass="inputText" size="20" value="#{data.fecha}" /> 
        --%>
        <br><br>
        
        <rich:dataTable value="#{ManagedSolMantenimiento.pedidoMaterialesAuxList}"  var="data" id="datamateriales" 
                        onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                        onRowMouseOver="this.style.backgroundColor='#DDE3E4';" 
                        headerClass="headerClassACliente" >

            <h:column>
                <f:facet name="header">
                    <h:outputText value="Nro"  />
                </f:facet>   
                <h:outputText styleClass="outputText2" value="#{data.nroOrden}" />
            </h:column>

            <h:column>
                <f:facet name="header">
                    <h:outputText value="Material"  />
                </f:facet>                            
                <h:outputText styleClass="outputText2" value="#{data.materialesBean.nombreMaterial}"/>
            </h:column>

            <h:column>
                <f:facet name="header">
                    <h:outputText value="Cantidad Faltante"  />
                </f:facet>                            
                <h:outputText styleClass="outputText" value="#{data.diferencia}" />
            </h:column>
            
            <h:column>
                <f:facet name="header">
                    <h:outputText value="Fecha" />
                </f:facet>
                <h:outputText styleClass="outputText" value="#{data.fechaPedidoSolicitud}" />
            </h:column>
            
        </rich:dataTable>
        <br><br>
        <%--
        <h:commandButton value="Guardar"   styleClass="btn"  action="#{ManagedSolMantenimiento.ordenCompraMantenimiento}"/>
        <h:commandButton value="Cancelar" styleClass="btn"   action="#{ManagedSolMantenimiento.CancelarM}"/>
        --%>
    </div>
</h:form>
</body>
</html>

</f:view>

