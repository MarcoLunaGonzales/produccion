<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>

<html>
    <head>
        <title>SISTEMA</title>
        <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
        <script type="text/javascript" src="../js/general.js"></script>

    </head>
    <body>
        <f:view>
            <a4j:form id="form1">                
                <div align="center">                    
                    <h:outputText value="#{ManagedLiberacionLotes.cargarLiberacionLotesList}"   />
                    <h:outputText value="Liberación de Lotes" styleClass="outputTextTituloSistema"/>
                    <rich:panel headerClass="headerClassACliente" style="width:80%">
                        <f:facet name="header">
                            <h:outputText value="BUSCADOR"/>
                        </f:facet>
                        <h:panelGrid columns="6">
                            <h:outputText value="Almacen Cuarentena" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectOneMenu value="#{ManagedLiberacionLotes.ingresosVentasBuscar.almacenesVentas.codAlmacenVenta}" styleClass="inputText">
                                <f:selectItem itemValue='0' itemLabel="--TODOS--"/>
                                <f:selectItems value="#{ManagedLiberacionLotes.almacenesVentasCuarentenaSelectList}"/>
                            </h:selectOneMenu>
                            <h:outputText value="Estado Liberación" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectOneMenu value="#{ManagedLiberacionLotes.ingresosVentasBuscar.estadosIngresoVentas.codEstadoIngresoVentas}" styleClass="inputText">
                                <f:selectItem itemValue='0' itemLabel="--TODOS--"/>
                                <f:selectItem itemValue='1' itemLabel="EN CUARENTENA"/>
                                <f:selectItem itemValue='4' itemLabel="LIBERADO"/>
                            </h:selectOneMenu>
                            <h:outputText value="Desde fecha de Ingreso" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <rich:calendar enableManualInput="true" value="#{ManagedLiberacionLotes.fechaIngresoInicio}"  styleClass="inputText" datePattern="dd/MM/yyyy">
                            </rich:calendar>
                            <h:outputText value="A fecha de Ingreso" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <rich:calendar enableManualInput="true"  value="#{ManagedLiberacionLotes.fechaIngresoFinal}"  styleClass="inputText" datePattern="dd/MM/yyyy"/>
                            <h:outputText value="Tipos Ingreso" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectOneMenu value="#{ManagedLiberacionLotes.ingresosVentasBuscar.tiposIngresoVentas.codTipoIngresoVentas}" styleClass="inputText">
                                <f:selectItem itemValue='0' itemLabel="--TODOS--"/>
                                <f:selectItems value="#{ManagedLiberacionLotes.tiposIngresosVentasSelectList}"/>
                            </h:selectOneMenu>
                            <h:outputText value="Nro Ingreso" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:inputText value="#{ManagedLiberacionLotes.ingresosVentasBuscar.nroIngresoVentas}" styleClass="inputText" onblur="valorPorDefecto(this);" id="nroIngreso"/>
                            
                            <h:outputText value="Presentación" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectOneMenu style="width:35em" value="#{ManagedLiberacionLotes.codPresentacionBuscar}" styleClass="chosen">
                                <f:selectItem itemValue='0' itemLabel="--TODOS--"/>
                                <f:selectItems value="#{ManagedLiberacionLotes.presentacionesProductoSelectList}"/>
                            </h:selectOneMenu>
                            <h:outputText value="Lote" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:inputText value="#{ManagedLiberacionLotes.ingresosVentasBuscar.liberacionLotes.codLoteProduccion}" styleClass="inputText" id="nroLote"/>
                        </h:panelGrid>
                        <a4j:commandButton value="BUSCAR" styleClass="btn" action="#{ManagedLiberacionLotes.buscarLiberacionLote_action}"
                                           reRender="dataLiberacionLotes,controles"/>
                    </rich:panel>
                    <table>
                        <tr><td class="outputTextBold">Lotes con certificado de C.C. aprobado</td><td class="fondoVerde" style="width:5em">&nbsp;</td></tr>
                    </table>
                    <rich:dataTable value="#{ManagedLiberacionLotes.liberacionLotesList}"
                                    var="data" id="dataLiberacionLotes"
                                    binding="#{ManagedLiberacionLotes.liberacionLotesDataTable}"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#F3F7FD';" 
                                    headerClass="headerClassACliente"
                                    columnClasses="tituloCampo">
                            
                                <f:facet name="header">
                                    <rich:columnGroup>
                                        <rich:column>
                                            <h:outputText value="Nro Ingreso"/>
                                        </rich:column>
                                        <rich:column>
                                            <h:outputText value="Fecha Ingreso"/>
                                        </rich:column>
                                        <rich:column>
                                            <h:outputText value="Tipo Ingreso"/>
                                        </rich:column>
                                        <rich:column>
                                            <h:outputText value="Almacén"/>
                                        </rich:column>
                                        <rich:column>
                                            <h:outputText value="Cliente"/>
                                        </rich:column>
                                        <rich:column>
                                            <h:outputText value="Estado"/>
                                        </rich:column>
                                        <rich:column>
                                            <h:outputText value="Presentación"/>
                                        </rich:column>
                                        <rich:column>
                                            <h:outputText value="Lote"/>
                                        </rich:column>
                                        <rich:column>
                                            <h:outputText value="Fecha Vencimiento"/>
                                        </rich:column>
                                        <rich:column>
                                            <h:outputText value="Cantidad"/>
                                        </rich:column>
                                        <rich:column>
                                            <h:outputText value="Cantidad Unitaria"/>
                                        </rich:column>
                                        <rich:column>
                                            <h:outputText value="Liberar"/>
                                        </rich:column>
                                    </rich:columnGroup>
                                </f:facet>
                            <rich:subTable var="subData" value="#{data.ingresosDetalleVentasList}" rowKeyVar="rowkey">
                                <rich:columnGroup styleClass="#{data.checked?'fondoVerde':''}">
                                    <rich:column rendered="#{rowkey eq 0}" rowspan="#{data.ingresosDetalleVentasListSize}">
                                        <h:outputText value="#{data.nroIngresoVentas}"/>
                                    </rich:column> 
                                    <rich:column rendered="#{rowkey eq 0}" rowspan="#{data.ingresosDetalleVentasListSize}">
                                        <h:outputText value="#{data.fechaIngresoVentas}">
                                            <f:convertDateTime pattern="dd/MM/yyyy HH:mm"/>
                                        </h:outputText>
                                    </rich:column> 
                                    <rich:column rendered="#{rowkey eq 0}" rowspan="#{data.ingresosDetalleVentasListSize}">
                                        <h:outputText value="#{data.tiposIngresoVentas.nombreTipoIngresoVentas}"/>
                                    </rich:column> 
                                    <rich:column rendered="#{rowkey eq 0}" rowspan="#{data.ingresosDetalleVentasListSize}">
                                        <h:outputText value="#{data.almacenesVentas.nombreAlmacenVenta}"/>
                                    </rich:column> 
                                    <rich:column rendered="#{rowkey eq 0}" rowspan="#{data.ingresosDetalleVentasListSize}">
                                        <h:outputText value="#{data.clientes.nombreCliente}"/>
                                    </rich:column> 
                                    <rich:column rendered="#{rowkey eq 0}" rowspan="#{data.ingresosDetalleVentasListSize}">
                                        <h:outputText value="#{data.estadosIngresoVentas.nombreEstadoIngresoVentasCuarentena}"/>
                                    </rich:column> 
                                    <rich:column>
                                        <h:outputText value="#{subData.presentacionesProducto.nombreProductoPresentacion}"/>
                                    </rich:column>
                                    <rich:column styleClass="tdRight">
                                        <h:outputText value="#{subData.codLoteProduccion}"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="#{subData.fechaVencimiento}">
                                            <f:convertDateTime pattern="dd/MM/yyyy"/>
                                        </h:outputText>
                                    </rich:column>
                                    <rich:column styleClass="tdRight">
                                        <h:outputText value="#{subData.cantidad}"/>
                                    </rich:column>
                                    <rich:column styleClass="tdRight">
                                        <h:outputText value="#{subData.cantidadUnitaria}"/>
                                    </rich:column>
                                    <rich:column>
                                        <a4j:commandLink oncomplete="redireccionar('liberacionLote.jsf')" rendered="#{data.estadosIngresoVentas.codEstadoIngresoVentas!=4}"  action="#{ManagedLiberacionLotes.seleccionarLiberacionLote_action}">
                                            <h:graphicImage url="../img/liberar.jpg"/>
                                        </a4j:commandLink>
                                    </rich:column>
                                </rich:columnGroup>
                            </rich:subTable>
                    </rich:dataTable>
                    <br/>
                    <h:panelGrid columns="2"  width="50" id="controles">
                        <a4j:commandLink  action="#{ManagedLiberacionLotes.atrasLiberacionLotesList_action}" reRender="dataLiberacionLotes,controles"  rendered="#{ManagedLiberacionLotes.begin>'1'}" >
                            <h:graphicImage url="../img/previous.gif"  style="border:0px solid red"   alt="PAGINA ANTERIOR"  />
                        </a4j:commandLink>
                        <a4j:commandLink  action="#{ManagedLiberacionLotes.siguienteLiberacionLotesList_action}" reRender="dataLiberacionLotes,controles" rendered="#{ManagedLiberacionLotes.cantidadfilas>=ManagedLiberacionLotes.numrows}">
                            <h:graphicImage url="../img/next.gif"  style="border:0px solid red"  alt="PAGINA SIGUIENTE" />
                        </a4j:commandLink>
                    </h:panelGrid>
                    
                </div>
                
            </a4j:form>
            <a4j:include  viewId="/panelProgreso.jsp"/>
        </f:view>
        
    </body>
</html>
   
