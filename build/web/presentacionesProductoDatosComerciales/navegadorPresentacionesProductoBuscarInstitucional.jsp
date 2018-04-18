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
            <script>
                function getCodigo(codigo){
                   //alert(codigo);
                   location='../presentacionesProductoDatosComerciales/navegadorDetalleDatosComerciales.jsf?codigo='+codigo;
                }
            
                
            </script>
        </head>
        <body >
            <h:form id="form1"  >                
                <div align="center">
                    <h3>Precios Institucionales</h3>                    
                    <h:outputText value="#{ManagedPresentacionesProductoDatosComerciales.cogerCodigoLineaMKT}"  />
                    
                    <rich:dataTable value="#{ManagedPresentacionesProductoDatosComerciales.datamodel}" var="data" id="dataPresentacionProducto" 
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#CCDFFA';"                                     
                 headerClass="headerClassACliente"   >
                        
                        <f:facet name="header">
                            <rich:columnGroup>
                                <rich:column>
                                    <h:outputText value="Producto" styleClass="outputText2" />                                                                        
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Precio Institucional" styleClass="outputText2" />
                                </rich:column>                                
                                <rich:column>
                                    <h:outputText value="Precio Instucional 2" styleClass="outputText2" />
                                </rich:column>
                            </rich:columnGroup>
                        </f:facet>
                        
                        <rich:column>
                            <h:commandLink  action="#{ManagedPresentacionesProductoDatosComerciales.escogerProductoInstitucional}">
                                <%--<h:outputText value="#{data[1]} #{data[5]} #{data[3]} #{data[6]} x #{data[7]} #{data[9]}" styleClass="outputTextNormal" />--%>
                                <h:outputText value="#{data[1]}" styleClass="outputTextNormal" />
                            </h:commandLink>                            
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data[6]}" styleClass="outputTextNormal" style="text-align:right" />
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data[7]}" styleClass="outputTextNormal" style="text-align:right" />
                        </rich:column>                        
                    </rich:dataTable>         
                    <h:panelGrid columns="4">
                        <h:commandButton value="Calcular"  styleClass="commandButton"    action="#{ManagedPresentacionesProductoDatosComerciales.calcularPrecioInstitucional2}"     />
                        
                        <h:inputText    value="#{ManagedPresentacionesProductoDatosComerciales.precioPorcentaje}"     styleClass="inputText" size="10" id="productobuscar" />
                        <h:outputText value="%" styleClass="outputTextNormal" style="font-weight:bold" />
                        <h:selectOneMenu styleClass="inputText"  value="#{ManagedPresentacionesProductoDatosComerciales.codprecio}">
                            <f:selectItem itemLabel="Precio Institucional" itemValue="precio_institucional2"  />                            
                        </h:selectOneMenu>
                        
                        
                    </h:panelGrid>
                    
                </div>                               
                <!--cerrando la conexion-->
                <h:outputText value="#{ManagedPresentacionesProductoDatosComerciales.closeConnection}"  />
            </h:form>
            
            <div align="center">
                <a href="javascript:history.go(-1)">Volver Atrás</a>
            </div>
        </body>
    </html>
    
</f:view>

