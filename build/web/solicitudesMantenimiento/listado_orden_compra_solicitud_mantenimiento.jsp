<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="jc" uri="http://jsf-components" %>

<f:view>
    <html>
        <head>
            <title>LISTADO DE ORDEN DE COMPRA</title>
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
            <script type="text/javascript" src="../js/general.js" ></script>

        </head>
        <body >

            <div  align="center" id="panelCenter">
                LISTADO DE ORDEN DE COMPRA
                <h:outputText value="#{ManagedRegistroSolicitudMateriales.initEsperaMaterialesOrdenDeCompra}"/><br />
                ESTADO DE ORDEN DE COMPRA :
                <h:outputText value="#{ManagedRegistroSolicitudMateriales.nombreEstadoSolicitudOrdenDeCompraMateriales}"/><br />
                <a4j:form id="form">

                    <rich:dataTable value="#{ManagedRegistroSolicitudMateriales.materialesEnEsperaOrdenDeCompra}" var="fila" id="ordenCompraMateriales"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente"
                                    binding="#{ManagedRegistroSolicitudMateriales.materialesEnEsperaOrdenDeCompraDataTable}">

                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Nombre Material"  />
                            </f:facet>
                            <h:outputText value="#{fila.nombreMaterial}"  />
                        </h:column>

                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Unidad Medida"  />
                            </f:facet>
                            <h:outputText value="#{fila.nombreUnidadMedida}"  />
                        </h:column>

                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Cantidad Solicitada"  />
                            </f:facet>
                            <h:outputText value="#{fila.cantidadSugerida}"  />
                        </h:column>

                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Cantidad Disponible"  />
                            </f:facet>
                            <h:outputText value="#{fila.disponible}"  />
                        </h:column>

                    </rich:dataTable>
                </div>

                <div align="center">
                    <h:commandButton  value="Solicitud de Almacen"  action="#{ManagedRegistroSolicitudMateriales.solicitarAlmacen_action}" />
                    <h:commandButton  value="Retornar"   action="#{ManagedRegistroSolicitudMateriales.retornar_action}" />
                </div>
                
                <h:inputHidden id="mensaje"  binding="#{ManagedRegistroSolicitudMateriales.alert}" />
                <jc:AlertMessage/>
                
            </a4j:form>



        </body>
    </html>

</f:view>

