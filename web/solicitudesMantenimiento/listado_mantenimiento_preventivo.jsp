<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>
    <html>
        <head>
            <title>LISTADO DE MANTENIMIENTO PREVENTIVO</title>
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
            <script type="text/javascript" src="../js/general.js" ></script>

        </head>
        <body >

            <div  align="center" id="panelCenter">

                <h:outputText value="#{ManagedRegistroMantenimientoPreventivo.initListadoMantenimientoPreventivo}" />
                MANTENIMIENTO PREVENTIVO - CALENDARIO
                <br />

                <a4j:form id="form">

                    <h:selectOneMenu  styleClass="inputText" value="#{ManagedRegistroMantenimientoPreventivo.anoMantenimiento}"
                                      valueChangeListener="#{ManagedRegistroMantenimientoPreventivo.ano_changeEvent}" immediate="true">
                        <f:selectItem itemValue="2008" itemLabel="2008" />
                        <f:selectItem itemValue="2009" itemLabel="2009" />
                        <f:selectItem itemValue="2010" itemLabel="2010" />
                        <f:selectItem itemValue="2011" itemLabel="2011" />
                        <f:selectItem itemValue="2012" itemLabel="2012" />
                        <f:selectItem itemValue="2013" itemLabel="2013" />
                        <f:selectItem itemValue="2014" itemLabel="2014" />
                        <f:selectItem itemValue="2015" itemLabel="2015" />
                        <a4j:support event="onchange"  reRender="calendario"/>
                    </h:selectOneMenu>


                    <rich:dataTable value="#{ManagedRegistroMantenimientoPreventivo.calendarioManteniminientoList}" var="fila" id="calendario"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente">

                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Maquina"  />
                            </f:facet>
                            <h:outputText value="#{fila.maquina}"  />
                        </h:column>

                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Enero"/>
                            </f:facet>
                            <h:outputText value="#{fila.enero}"  />
                        </h:column>

                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Febrero"  />
                            </f:facet>
                            <h:outputText value="#{fila.febrero}"  />
                        </h:column>

                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Marzo"  />
                            </f:facet>
                            <h:outputText value="#{fila.marzo}"  />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Abril"  />
                            </f:facet>
                            <h:outputText value="#{fila.abril}"  />
                        </h:column>

                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Mayo"  />
                            </f:facet>
                            <h:outputText value="#{fila.mayo}"  />
                        </h:column>

                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Junio"  />
                            </f:facet>
                            <h:outputText value="#{fila.junio}"  />
                        </h:column>

                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Julio"  />
                            </f:facet>
                            <h:outputText value="#{fila.julio}"  />
                        </h:column>

                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Agosto"  />
                            </f:facet>
                            <h:outputText value="#{fila.agosto}"  />
                        </h:column>

                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Septiembre"  />
                            </f:facet>
                            <h:outputText value="#{fila.septiembre}"  />
                        </h:column>

                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Octubre"  />
                            </f:facet>
                            <h:outputText value="#{fila.octubre}"  />
                        </h:column>

                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Noviembre"  />
                            </f:facet>
                            <h:outputText value="#{fila.noviembre}"  />
                        </h:column>

                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Diciembre"  />
                            </f:facet>
                            <h:outputText value="#{fila.diciembre}"  />
                        </h:column>

                    </rich:dataTable>
                    <br />
                    MANTENIMIENTO PREVENTIVO - LISTADO
                    <br />
                    <rich:dataTable value="#{ManagedRegistroMantenimientoPreventivo.mantenimientoPreventivoList}" var="fila" id="Trabajos"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente"
                                    binding="#{ManagedRegistroMantenimientoPreventivo.mantenimientoPreventivoDataTable}">

                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Editar" />
                            </f:facet>
                            <h:commandLink action="#{ManagedRegistroMantenimientoPreventivo.editar_action}">
                                <h:outputText value="Editar"/>
                            </h:commandLink>
                        </h:column>

                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Borrar"  />
                            </f:facet>
                            <h:commandLink action="#{ManagedRegistroMantenimientoPreventivo.borrar_action}">
                                <h:outputText value="Borrar"/>
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
                                <h:outputText value="Maquina"  />
                            </f:facet>
                            <h:outputText value="#{fila.nombreMaquina}"  />
                        </h:column>

                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Fecha de Mantenimiento"  />
                            </f:facet>
                            <h:outputText value="#{fila.fechaMantenimiento}"  />
                        </h:column>

                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Tiempo Estimado"  />
                            </f:facet>
                            <h:outputText value="#{fila.tiempoEstimado}"  />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Tipo de Mantenimiento Preventivo"  />
                            </f:facet>
                            <h:outputText value="#{fila.nombretipoMantenimientoPreventivo}"  />
                        </h:column>



                    </rich:dataTable>

                </div>

                <div align="center">
                    <h:commandButton  value="Adicionar"   action="#{ManagedRegistroMantenimientoPreventivo.adicionarMantenimientoPreventivo_action}" />
                    <h:commandButton  value="Retornar"   action="#{ManagedRegistroMantenimientoPreventivo.adicionarMantenimientoPreventivo_action}" />
                </div>

            </a4j:form>


        </body>
    </html>

</f:view>

