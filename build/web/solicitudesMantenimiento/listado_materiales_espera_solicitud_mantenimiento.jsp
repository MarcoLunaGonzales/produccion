package solicitudesMantenimiento;

<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="jc" uri="http://jsf-components" %>

<f:view>
    <html>
        <head>
            <title>LISTADO DE MATERIALES EN ESPERA - SOLICITUD DE MANTENIMIENTO</title>
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
            <script type="text/javascript" src="../js/general.js" ></script>

        </head>
        <body >

            <div  align="center" id="panelCenter">
                LISTADO DE MATERIALES EN ESPERA - SOLICITUD DE MANTENIMIENTO<br/>
                <h:outputText value="#{ManagedRegistroSolicitudMateriales.initEsperaMateriales}"/><br/>
                ESTADO DE SOLICITUD DE ALMACENES :
                <h:outputText value="#{ManagedRegistroSolicitudMateriales.nombreEstadoSolicitudMateriales }" />
                <a4j:form id="form">


                    <rich:dataTable value="#{ManagedRegistroSolicitudMateriales.materialesEnEspera}" var="fila" id="Materiales"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente"
                                    binding="#{ManagedRegistroSolicitudMateriales.materialesEnEsperaDataTable}">

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


                    </rich:dataTable>

                </div>
                <div align="center">
                    <h:commandButton  value="Aceptar Entrega"   action="#{ManagedRegistroSolicitudMateriales.aceptarEntregaMateriales_action}" />
                    <h:commandButton  value="Retornar"   action="#{ManagedRegistroSolicitudMateriales.retornar_action}" />
                </div>

                <h:inputHidden id="mensaje"  binding="#{ManagedRegistroSolicitudMateriales.alert}" />
                <jc:AlertMessage/>

            </a4j:form>



        </body>
    </html>

</f:view>

