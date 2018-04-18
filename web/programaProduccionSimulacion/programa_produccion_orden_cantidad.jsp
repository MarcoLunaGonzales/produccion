<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
            <script type="text/javascript" src="../js/general.js" ></script>

        </head>
        <body >

            <div  align="center" id="panelCenter">

                <a4j:form id="form"  >

                    
                    <rich:dataTable value="#{ManagedProgramaProduccionOrdenCantidad.produccionOrdenCantidadList}" var="fila" id="Componentes"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente"
                                    binding="#{ManagedProgramaProduccionOrdenCantidad.productosDataTable}"
                                    >
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Seleccionar"  />
                            </f:facet>
                            <h:commandLink action="#{ManagedProgramaProduccionOrdenCantidad.seleccionaComponente}">
                                <h:outputText value="#{fila.linkOperacion}"/>
                            </h:commandLink>
                        </h:column>

                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Producto"  />
                            </f:facet>
                            <h:outputText value="#{fila.nombreProdSemiterminado}"  />
                        </h:column>

                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Estado"  />
                            </f:facet>
                            <h:commandLink>
                                <h:outputText value="#{fila.estadoProduccion}"  />
                            </h:commandLink>
                            
                        </h:column>

                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Observacion"  />
                            </f:facet>
                            <h:outputText value="#{fila.observacion}"  />
                        </h:column>

                    </rich:dataTable>

                </div>

                <div align="center">
                    <h:commandButton  value="Simulacion"   action="#{ManagedProgramaProduccionOrdenCantidad.comenzarSimulacion}" />
                </div>
                <!--cerrando la conexion-->
                <h:outputText value="#{ManagedProgramaProduccionOrdenCantidad.closeConnection}"  />
            </a4j:form>


        </body>
    </html>

</f:view>

