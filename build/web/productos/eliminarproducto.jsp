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
                      <br>
                    <br>
                    <h3> <h:outputText value="Eliminar Nombre(s) Comercial(es)" styleClass="tituloCabezera1" /></h3>
                    <br>
                    <br>
                    <div  >
                    <rich:dataTable value="#{productos.productoEli}"  var="data" id="dataCliente"  
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#CCDFFA';" 
                                    headerClass="headerClassACliente" width="35%"
                    >
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Nombre Comercial"  />
                            </f:facet>
                            <h:outputText value="#{data.nombreProducto}"  />
                        </h:column>              
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Descripción"  />
                            </f:facet>
                            <h:outputText value="#{data.obsProd}"  />
                        </h:column>      
                        
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Estado"  />
                            </f:facet>
                            <h:outputText value="#{data.estadoProducto.nombreEstadoProducto}"  />
                        </h:column>                  
                    </rich:dataTable>
                    </div>
                    <br><br>
                    <h:commandButton value="Eliminar"  styleClass="btn" action="#{productos.eliminarProducto}"  />
                    <h:commandButton value="Cancelar"  styleClass="btn" action="cancelarProducto"/>                        
                </div>                
                <!--cerrando la conexion-->
                <h:outputText value="#{productos.closeConnection}"  />
            </h:form>
            
        </body>
    </html>
    
</f:view>

