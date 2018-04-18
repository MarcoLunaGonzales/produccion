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
            <script type="text/javascript" src="../../js/general.js" ></script>
            <link rel="STYLESHEET" type="text/css" href="../../css/chosen.css" />
        </head>
        <body >
            <a4j:form id="form1">
                <div align="center">
                    <h:outputText styleClass="outputTextTituloSistema" value="Agregar Paso de Preparado"/>
                    <h:outputText value="#{ManagedProcesosPreparadoProducto.cargarAgregarProcesosPreparadoProducto}"/>
                    <rich:panel headerClass="headerClassACliente" style="width:70%">
                        <f:facet name="header">
                            <h:outputText value="<center>Datos del Paso</center>" escape="false"/>
                        </f:facet>
                        <h:panelGrid columns="3">
                            <h:outputText styleClass="outputTextBold" value="Actividad"/>
                            <h:outputText styleClass="outputTextBold" value="::"/>
                            <h:selectOneMenu value="#{ManagedProcesosPreparadoProducto.procesosPreparadoProductoAgregar.actividadesPreparado.codActividadPreparado}" styleClass="inputText chosen">
                                <f:selectItems value="#{ManagedProcesosPreparadoProducto.actividadesPreparadoSelectList}"/>
                            </h:selectOneMenu>
                            <h:outputText styleClass="outputTextBold" value="Descripción"/>
                            <h:outputText styleClass="outputTextBold" value="::"/>
                            <h:inputTextarea value="#{ManagedProcesosPreparadoProducto.procesosPreparadoProductoAgregar.descripcion}" cols="60" rows="4" styleClass="inputText">
                            </h:inputTextarea>
                            <h:outputText styleClass="outputTextBold" value="Tiempo proceso(min)"/>
                            <h:outputText styleClass="outputTextBold" value="::"/>
                            <h:inputText value="#{ManagedProcesosPreparadoProducto.procesosPreparadoProductoAgregar.tiempoProceso}" styleClass="inputText"/>
                            <h:outputText styleClass="outputTextBold" value="Tolerancia(%)"/>
                            <h:outputText styleClass="outputTextBold" value="::"/>
                            <h:inputText value="#{ManagedProcesosPreparadoProducto.procesosPreparadoProductoAgregar.toleranciaTiempo}" styleClass="inputText"/>
                            <h:outputText styleClass="outputTextBold" value="Operario Tiempo Completo"/>
                            <h:outputText styleClass="outputTextBold" value="::"/>
                            <h:selectBooleanCheckbox value="#{ManagedProcesosPreparadoProducto.procesosPreparadoProductoAgregar.operarioTiempoCompleto}"/>
                            <h:outputText styleClass="outputTextBold" value="Ir al siguiente Paso"/>
                            <h:outputText styleClass="outputTextBold" value="::"/>
                            <h:selectOneRadio styleClass="outputText2" value="#{ManagedProcesosPreparadoProducto.procesosPreparadoProductoAgregar.procesoSecuencial}">
                                <f:selectItem itemValue='true' itemLabel="SI"/>
                                <f:selectItem itemValue='false' itemLabel="NO"/>
                            </h:selectOneRadio>
                            
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
                                            <rich:dataTable value="#{ManagedProcesosPreparadoProducto.procesosPreparadoProductoAgregar.procesosPreparadoProductoMaquinariaList}"
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
                    <a4j:commandButton value="Guardar" action="#{ManagedProcesosPreparadoProducto.guardarAgregarProcesoProducto_action}" styleClass="btn"
                                       oncomplete="if(#{ManagedProcesosPreparadoProducto.mensaje eq 1 }){alert('Se registro satisfactoriamente el paso N°##{ManagedProcesosPreparadoProducto.procesosPreparadoProductoAgregar.nroPaso}');window.location.href='navegadorProcesosPreparadoProducto.jsf?data='+(new Date()).getTime().toString();}
                                       else {alert('#{ManagedProcesosPreparadoProducto.mensaje}')}"/>
                    <a4j:commandButton value="Cancelar" styleClass="btn" onclick="window.location='navegadorProcesosPreparadoProducto.jsf?data='+(new Date()).getTime().toString();" />
                   
                </div>
                    
               
              
            </a4j:form>
            <a4j:include viewId="/panelProgreso.jsp"/>
            <a4j:include viewId="/message.jsp"/>


        </body>
    </html>

</f:view>

