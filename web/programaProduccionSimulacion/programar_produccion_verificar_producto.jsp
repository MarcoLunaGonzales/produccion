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

        <body>

            <div  align="center" id="panelCenter">
                PRODUCTOS PARA PRODUCCION
                <a4j:form id="form"  >


                    <rich:dataTable value="#{ManagedProgramaProduccionVerificarProducto.componentesList}" var="fila" id="componentes"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente"
                                    binding="#{ManagedProgramaProduccionVerificarProducto.componentesDataTable}"
                                    rows="40"
                                    >

                        <h:column id="col1">
                            <f:facet name="header">
                                <h:outputText value="Seleccionar"  />
                            </f:facet>
                            <h:commandLink action="#{ManagedProgramaProduccionVerificarProducto.seleccionaComponente}">
                                <h:outputText value="#{fila.linkOperacion}"/>
                            </h:commandLink>
                        </h:column>

                        <rich:column id="col2">
                            <f:facet name="header">
                                <h:outputText value="Producto"  />
                            </f:facet>
                            <h:outputText value="#{fila.nombreCompProd}"  />
                        </rich:column>

                        <rich:column id="col3">
                            <f:facet name="header">
                                <h:outputText value="Lote"  />
                            </f:facet>
                            <h:outputText value="#{fila.cantLoteProduccion}"  />
                        </rich:column>
                        
                        <rich:column id="col4">
                            <f:facet name="header">
                                <h:outputText value="Tipo Mercaderia"  />
                            </f:facet>
                            <h:outputText value="#{fila.nombreTipoProgramaProd}"  />
                        </rich:column>

                        <rich:column id="col5">
                            <f:facet name="header">
                                <h:outputText value="Prioridad"  />
                            </f:facet>
                            <h:outputText value="#{fila.categoria}"  />
                        </rich:column>

                        <rich:column id="col6">
                            <f:facet name="header">
                                <h:outputText value="Estado Simulacion"  />
                            </f:facet>
                            <h:graphicImage url="#{fila.iconoEstadoSimulacion}" rendered="#{fila.tieneIconoEstadoSimulacion }" />
                        </rich:column>

                        <rich:column style="#{fila.estiloEstado}" id="col7">
                            <f:facet name="header">
                                <h:outputText value="Material"  />
                            </f:facet>
                            <h:outputText value="#{fila.nombreMaterial}"  />
                        </rich:column>

                        <rich:column style="#{fila.estiloEstado}" id="col8">
                            <f:facet name="header">
                                <h:outputText value="A Utilizar"  />
                            </f:facet>
                            <h:outputText value="#{fila.cantidadAUtilizar}"  />
                        </rich:column>

                        <rich:column style="#{fila.estiloEstado}" id="col9">
                            <f:facet name="header">
                                <h:outputText value="Disponible"  />
                            </f:facet>
                            <h:outputText value="#{fila.cantidadDisponible}"  />
                        </rich:column>

                        <rich:column style="#{fila.estiloEstado}" id="col10">
                            <f:facet name="header">
                                <h:outputText value="En Transito"  />
                            </f:facet>
                            <h:outputText value="#{fila.cantidadEnTransito}"  />
                        </rich:column>

                        <rich:column style="#{fila.estiloEstado}" id="col11">
                            <f:facet name="header">
                                <h:outputText value="Stock Minimo"  />
                            </f:facet>
                            <h:outputText value="#{fila.stockMinimoMaterial}"  />
                        </rich:column>




                    </rich:dataTable>

                    <rich:datascroller align="center" for="componentes" maxPages="20" id="sc2" />                    
                    <h:commandButton value="Aceptar" action="#{ManagedProgramaProduccionVerificarProducto.verificarParaAprobarProgramaProduccion}" />
                    <h:commandButton value="Cancelar" action="#{ManagedProgramaProduccionVerificarProducto.cancelarProgramarProduccion_action}" />
                </div>

                <h:inputHidden id="mensaje"  binding="#{ManagedProgramaProduccionVerificarProducto.alert}" />
                

            </a4j:form>


        </body>
    </html>

</f:view>

