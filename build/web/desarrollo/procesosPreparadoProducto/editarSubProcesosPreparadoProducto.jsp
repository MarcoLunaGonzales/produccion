<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>
<f:view>

    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
            <link rel="STYLESHEET" type="text/css" href="../../css/chosen.css" />
            <script type="text/javascript" src="../../js/general.js" ></script>
        </head>
        <body >
            <a4j:form id="form1">
                <div align="center">
                    <h:outputText styleClass="outputTextTituloSistema" value="Edición de Paso de Preparado"/>
                    <h:outputText value="#{ManagedProductosDesarrolloVersion.cargarEdicionSubProcesosPreparadoProducto}"/>
                    <rich:panel headerClass="headerClassACliente" style="width:70%">
                        <f:facet name="header">
                            <h:outputText value="<center>Datos del Paso</center>" escape="false"/>
                        </f:facet>
                        <h:panelGrid columns="3" id="contenidoEditarSubProceso">
                            <h:outputText styleClass="outputTextBold" value="N° Paso"/>
                            <h:outputText styleClass="outputTextBold" value="::"/>
                            <h:panelGroup>
                                <h:outputText styleClass="outputText2" value="#{ManagedProductosDesarrolloVersion.procesosPreparadoProductoBeanSubProceso.nroPaso}."/>
                                <h:inputText value="#{ManagedProductosDesarrolloVersion.procesosPreparadoProducto.nroPaso}" style="width:7em" styleClass="inputText" onblur="valorPorDefecto(this)"/>
                            </h:panelGroup>
                            <h:outputText styleClass="outputTextBold" value="Actividad"/>
                            <h:outputText styleClass="outputTextBold" value="::"/>
                            <h:selectOneMenu value="#{ManagedProductosDesarrolloVersion.procesosPreparadoProducto.actividadesPreparado.codActividadPreparado}" styleClass="inputText chosen">
                                <f:selectItems value="#{ManagedProductosDesarrolloVersion.actividadesPreparadoSelectList}"/>
                            </h:selectOneMenu>
                            <h:outputText styleClass="outputTextBold" value="Descripción"/>
                            <h:outputText styleClass="outputTextBold" value="::"/>
                            <h:inputTextarea value="#{ManagedProductosDesarrolloVersion.procesosPreparadoProducto.descripcion}" cols="60" rows="4" styleClass="inputText">
                            </h:inputTextarea>
                            <h:outputText styleClass="outputTextBold" value="Tiempo proceso(min)"/>
                            <h:outputText styleClass="outputTextBold" value="::"/>
                            <h:inputText value="#{ManagedProductosDesarrolloVersion.procesosPreparadoProducto.tiempoProceso}" styleClass="inputText"/>
                            <h:outputText styleClass="outputTextBold" value="Tolerancia(%)"/>
                            <h:outputText styleClass="outputTextBold" value="::"/>
                            <h:inputText value="#{ManagedProductosDesarrolloVersion.procesosPreparadoProducto.toleranciaTiempo}" styleClass="inputText"/>
                            <h:outputText styleClass="outputTextBold" value="Operario Tiempo Completo"/>
                            <h:outputText styleClass="outputTextBold" value="::"/>
                            <h:selectBooleanCheckbox value="#{ManagedProductosDesarrolloVersion.procesosPreparadoProducto.operarioTiempoCompleto}"/>
                            <h:outputText styleClass="outputTextBold" value="Proceso Destino"/>
                            <h:outputText styleClass="outputTextBold" value="::"/>
                            <h:selectOneMenu value="#{ManagedProductosDesarrolloVersion.procesosPreparadoProducto.procesosPreparadoProductoDestino.codProcesoPreparadoProducto}" styleClass="inputText">
                                <f:selectItem itemValue='0' itemLabel="Por Defecto"/>
                                <f:selectItems value="#{ManagedProductosDesarrolloVersion.procesosPreparadoDestinoSelectList}"/>
                            </h:selectOneMenu>
                            
                        </h:panelGrid>
                        
                    </rich:panel>
                   <rich:panel headerClass="headerClassACliente" style="width:70%">
                            <f:facet name="header">
                                <h:outputText value="Maquinarias del Proceso"/>
                            </f:facet>
                            <table>
                                <tr>
                                    <td>
                                        <div style="overflow-x:hidden;overflow-y:auto;height:200px;">
                                            <rich:dataTable value="#{ManagedProductosDesarrolloVersion.procesosPreparadoProducto.procesosPreparadoProductoMaquinariaList}"
                                                    var="data" id="dataProcesosProducto"
                                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                                    onRowMouseOver="this.style.backgroundColor='#F3F7FD';"
                                                    headerClass="headerClassACliente"
                                                    columnClasses="tituloCampo">
                                                <f:facet name="header">
                                                    <rich:columnGroup>
                                                        <rich:column>
                                                            <h:outputText value=""/>
                                                        </rich:column>
                                                        <rich:column>
                                                            <h:outputText value="Maquinaria<br><input type='text' onkeyup='buscarCeldaAgregar(this,1)' class='inputText'>" escape="false"/>
                                                        </rich:column>
                                                        <rich:column>
                                                            <h:outputText value="Codigo"/>
                                                        </rich:column>
                                                        <rich:column>
                                                            <h:outputText value="Tipo<br>Equipo" escape="false"/>
                                                        </rich:column>
                                                    </rich:columnGroup>
                                                </f:facet>
                                                    <rich:column>
                                                        <h:selectBooleanCheckbox value="#{data.checked}"/>
                                                    </rich:column>
                                                    <rich:column>
                                                        <h:outputText value="#{data.maquinaria.nombreMaquina}"/>
                                                    </rich:column>
                                                    <rich:column>
                                                        <h:outputText value="#{data.maquinaria.codigo}"/>
                                                    </rich:column>
                                                    <rich:column>
                                                        <h:outputText value="#{data.maquinaria.tiposEquiposMaquinaria.nombreTipoEquipo}"/>
                                                    </rich:column>

                                            </rich:dataTable>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                    </rich:panel>
                    <br>
                    <a4j:commandButton value="Guardar" action="#{ManagedProductosDesarrolloVersion.editarSubProcesosPreparadoProductoAction}" styleClass="btn"
                                       oncomplete="mostrarMensajeTransaccionEvento(function(){redireccionar('navegadorSubProcesosPreparadoProducto.jsf')})"/>
                    <a4j:commandButton value="Cancelar" styleClass="btn" onclick="window.location='navegadorSubProcesosPreparadoProducto.jsf?cancel='+(new Date()).getTime().toString();" />
                   
                </div>
                    
               
              
            </a4j:form>
            <a4j:include viewId="/panelProgreso.jsp"/>
            <a4j:include viewId="/message.jsp"/>


        </body>
    </html>

</f:view>

