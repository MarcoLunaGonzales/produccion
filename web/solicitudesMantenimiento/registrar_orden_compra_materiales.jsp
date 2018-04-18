package solicitudesMantenimiento;

<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="jc" uri="http://jsf-components" %>

<f:view>
    <html>
        <head>
            <title>REGISTRO DE ORDENES DE COMPRA</title>
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
            <script type="text/javascript" src="../js/general.js" ></script>

        </head>
        <body >

            <div  align="center" id="panelCenter">
                REGISTRO DE ORDEN DE COMPRA
                <h:outputText value="#{ManagedRegistroSolicitudMateriales.init}"/>

                <a4j:form id="form">

                    <rich:dataTable value="#{ManagedRegistroSolicitudMateriales.ordenCompraMaterialesList}" var="fila" id="ordenCompraMateriales"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente"
                                    binding="#{ManagedRegistroSolicitudMateriales.ordenCompraMaterialesDataTable}">

                        

                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Descripcion"  />
                            </f:facet>
                            <h:outputText value="#{fila.descripcion}"  />
                        </h:column>

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
                                <h:outputText value="Cantidad"  />
                            </f:facet>
                            <h:outputText value="#{fila.cantidad}"  />
                        </h:column>

                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Disponible"  />
                            </f:facet>
                            <h:outputText value="#{fila.disponible}"  />
                        </h:column>

                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Cantidad a Solicitar"  />
                            </f:facet>
                            <h:inputText value="#{fila.cantidadSugerida}"  />
                        </h:column>
                        
                    </rich:dataTable>
                </div>

                <div align="center">
                    <h:commandButton  value="Solicitar Orden de Compra"   action="#{ManagedRegistroSolicitudMateriales.solicitarOrdenDeCompra_action}" />
                    <h:commandButton  value="Retornar"   action="#{ManagedRegistroSolicitudMateriales.retornarListadoMateriales_action}" />
                </div>
                
                <h:inputHidden id="mensaje"  binding="#{ManagedRegistroSolicitudMateriales.alert}" />
                <jc:AlertMessage/>
                
            </a4j:form>



        </body>
    </html>

</f:view>

