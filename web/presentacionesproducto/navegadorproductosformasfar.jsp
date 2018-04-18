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
        </head>
        <body >
            <h:form id="form1"  >                
                <div align="center">
                    Productos Forma Farmaceutica                    
                    <br>
                    <br>
                    <h:outputText value="#{ManagedFormaFar.obtenerCodigo}"   />
                    <rich:dataTable value="#{ManagedPresentacionesProducto.formasFarList}" var="data" id="dataFormaFar" 
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#CCDFFA';" 
                                    headerClass="headerClassACliente"
                                     >
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value=""  />
                                
                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.checked}"  />
                        </rich:column>
                                                
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Producto"  />
                            </f:facet>
                            <h:outputText value="#{data.producto.nombreProducto}"  />
                        </rich:column>    
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Forma Farmaceutica"  />
                            </f:facet>
                            <h:outputText value="#{data.formaFarmaceutica.nombreForma}"  />
                        </rich:column>                                               
                    </rich:dataTable>
                    <ws:datascroller fordatatable="dataFormaFar"  />
                    <br><br>                
                    <h:commandButton value="Agregar" styleClass="commandButton"  action="#{ManagedFormaFar.actionSavePresentacionesProducto}"/>
                    <h:commandButton value="Editar"  styleClass="commandButton"  action="#{ManagedFormaFar.actionEditPresentacionesProducto}" onclick="return editarItem('form1:dataFormaFar');"/>
                    <h:commandButton value="Salir"  styleClass="commandButton"  action="#{ManagedFormaFar.actionCancelar}" />
                </div>                               
                <!--cerrando la conexion-->
                <h:outputText value="#{ManagedFormaFar.closeConnection}"  />
            </h:form>
            
            
        </body>
    </html>
    
</f:view>

