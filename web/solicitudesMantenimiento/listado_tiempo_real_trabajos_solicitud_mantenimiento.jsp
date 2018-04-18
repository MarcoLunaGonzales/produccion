<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>
    <html>
        <head>
            <title>LISTADO DE TRABAJOS DE SOLICITUD DE MANTENIMIENTO</title>
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
            <script type="text/javascript" src="../js/general.js" ></script>

        </head>
        <body >

            <div  align="center" id="panelCenter">
                
                <h:outputText value="#{ManagedRegistroSolicitudTrabajos.initializeTrabajosTiemposReales}" />
                
                <a4j:form id="form"  >


                    <rich:dataTable value="#{ManagedRegistroSolicitudTrabajos.trabajosSolMantList}" var="fila" id="Trabajos"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente"
                                    binding="#{ManagedRegistroSolicitudTrabajos.trabajosDataTable}">

                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Asignar"  />
                            </f:facet>
                            <h:commandLink action="#{ManagedRegistroSolicitudTrabajos.asignarTiempoReal_action}">
                                <h:outputText value="Asignar Tiempo Real"/>
                            </h:commandLink>
                        </h:column>                        
                      
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Descripcion"  />
                            </f:facet>
                            <h:outputText value="#{fila.descripcion}"  />
                        </h:column>

                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Tipo de Trabajo"  />
                            </f:facet>
                            <h:outputText value="#{fila.nombreTipoTrabajo}"  />
                        </h:column>

                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Personal Asignado"  />
                            </f:facet>
                            <h:outputText value="#{fila.nombrePersonal}"  />
                        </h:column>

                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Proovedor Asignado"  />
                            </f:facet>
                            <h:outputText value="#{fila.nombreProovedor}"  />
                        </h:column>

                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Horas Trabajo (Estimado)"  />
                            </f:facet>
                            <h:outputText value="#{fila.horasTrabajo}"  />
                        </h:column>

                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Fecha Inicio (Estimado)"  />
                            </f:facet>
                            <h:outputText value="#{fila.fechaInicio}"  />
                        </h:column>

                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="fecha Final (Estimado)"  />
                            </f:facet>
                            <h:outputText value="#{fila.fechaFin}"  />
                        </h:column>

                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Horas Trabajo (Real)"  />
                            </f:facet>
                            <h:outputText value="#{fila.horasTrabajoReal}"  />
                        </h:column>

                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Fecha Inicio (Real)"  />
                            </f:facet>
                            <h:outputText value="#{fila.fechaInicioReal}"  />
                        </h:column>

                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="fecha Final (Real)"  />
                            </f:facet>
                            <h:outputText value="#{fila.fechaFinReal}"  />
                        </h:column>
                        

                    </rich:dataTable>

                </div>

                <div align="center">
                    <h:commandButton  value="Adicionar"   action="#{ManagedRegistroSolicitudTrabajos.adicionar_action}" />
                    <h:commandButton  value="Retornar"   action="#{ManagedRegistroSolicitudTrabajos.retornar_action}" />
                    <h:commandButton  value="Aceptar y Continuar"   action="#{ManagedRegistroSolicitudTrabajos.aceptarAsignacionTiempoRealTrabajos_action}" />
                </div>
                
            </a4j:form>


        </body>
    </html>

</f:view>

