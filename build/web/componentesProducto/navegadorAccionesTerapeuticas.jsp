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
            <script type="text/javascript" src='../js/treeComponet.js' ></script> 
            <style type="text/css">
                .codcompuestoprod{
                background-color:#ADD797;
                }.nocodcompuestoprod{
                background-color:#FFFFFF;
                }
                
            </style>
        </head>
        <body>
           
            <h:form id="form1"  >
                <div align="center">                    
                                        
                    <h:outputText value="#{ManagedComponentesProducto.obtenerCodigoAccionesTerapeuticas}"   />
                    <h3>Acciones Terapeúticas</h3>                                        
                    <h:outputText value="#{ManagedComponentesProducto.nombreComProd}" styleClass="outputText2" />
                    <br>  <br>
                    <rich:dataTable value="#{ManagedComponentesProducto.accionesTerapeuticasList}" var="data" id="dataPresenacionesPrimarias" 
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#F3F7FD';" 
                                    headerClass="headerClassACliente"
                                    columnClasses="tituloCampo">
                        
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value=""  />                                
                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.checked}"  />                            
                        </rich:column >                        
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value="Acción Terapeútica"  />
                            </f:facet>
                            <h:outputText value="#{data.nombreAccionTerapeutica}"  />
                        </rich:column >                        
                     
                    </rich:dataTable>                    
                     
            </h:form>
        </body>
    </html>
    
</f:view>

