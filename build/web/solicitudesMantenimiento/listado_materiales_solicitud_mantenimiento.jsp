<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="jc" uri="http://jsf-components" %>

<f:view>
    <html>
        <head>
            <title>LISTADO DE MATERIALES DE SOLICITUD DE MANTENIMIENTO</title>
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
            <script type="text/javascript" src="../js/general.js" ></script>

        </head>
        <body >

            <div  align="center" id="panelCenter">
                LISTADO DE MATERIALES DE SOLICITUD DE MANTENIMIENTO
                <h:outputText value="#{ManagedRegistroSolicitudMateriales.init}"/>

                <a4j:form id="form">

                    <rich:dataTable value="#{ManagedRegistroSolicitudMateriales.materialesSolMantList}" var="fila" id="Materiales"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente"
                                    binding="#{ManagedRegistroSolicitudMateriales.materialesDataTable}">

                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Editar"  />
                            </f:facet>
                            <h:commandLink action="#{ManagedRegistroSolicitudMateriales.editar_action}">
                                <h:outputText value="Editar"/>
                            </h:commandLink>
                        </rich:column>

                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Borrar"  />
                            </f:facet>
                            <h:commandLink action="#{ManagedRegistroSolicitudMateriales.borrar_action}">
                                <h:outputText value="Borrar"/>
                            </h:commandLink>
                        </rich:column>

                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Descripcion"  />
                            </f:facet>
                            <h:outputText value="#{fila.descripcion}"/>
                        </rich:column>

                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Nombre Material"  />
                            </f:facet>
                            <h:outputText value="#{fila.nombreMaterial}"  />
                        </rich:column>

                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Unidad Medida"  />
                            </f:facet>
                            <h:outputText value="#{fila.nombreUnidadMedida}"  />
                        </rich:column>

                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Cantidad"  />
                            </f:facet>
                            <h:outputText value="#{fila.cantidad}"  />
                        </rich:column>

                        <rich:column footerClass="">
                            <f:facet name="header">
                                <h:outputText value="Disponible"  />
                            </f:facet>
                            <h:outputText value="#{fila.disponible}" />
                        </rich:column>

                    </rich:dataTable>

                </div>

                <div align="center">
                    <h:commandButton  value="Adicionar"   action="#{ManagedRegistroSolicitudMateriales.adicionar_action}" />
                    <h:commandButton value="Solicitud Almacen" action="#{ManagedRegistroSolicitudMateriales.solicitudAlmacen_action}" />
                    <h:commandButton value="Orden de Compra" action="#{ManagedRegistroSolicitudMateriales.ordenDeCompra_action}" />
                    <h:commandButton  value="Retornar"   action="#{ManagedRegistroSolicitudMateriales.retornar_action}" />
                </div>
                <h:inputHidden id="mensaje"  binding="#{ManagedRegistroSolicitudMateriales.alert}" />
                <jc:AlertMessage/>

            </a4j:form>



        </body>
    </html>

</f:view>

