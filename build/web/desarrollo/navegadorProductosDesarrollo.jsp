<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>
<f:view>
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
            <link rel="STYLESHEET" type="text/css" href="../css/chosen.css" />
            <script type="text/javascript" src="../js/general.js"></script>
            <style>
                .enProceso
                {
                    background-color:#c9fdc9;
                }
                .enviadoAprobacion
                {
                    background-color:#fac5af;
                }
            </style>
        </head>
        
            <a4j:form id="form1"  >                
                <div align="center">                    
                    
                    <h:outputText value="#{ManagedProductosDesarrolloVersion.cargarComponentesProdList}"   />
                    <h:outputText value="Productos En Estandarización" styleClass="outputTextTituloSistema"/>
                    <rich:panel headerClass="headerClassACliente">
                        <f:facet name="header">
                            <h:outputText value="Buscador"/>
                        </f:facet>
                        <h:panelGrid columns="6">
                            <h:outputText value="Nombre Producto" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:inputText style="width:20em" value="#{ManagedProductosDesarrolloVersion.componentesProdBuscar.nombreProdSemiterminado}" styleClass="inputText"/>
                            
                            <h:outputText value="Nombre Comercial" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectOneMenu value="#{ManagedProductosDesarrolloVersion.componentesProdBuscar.producto.codProducto}" styleClass="inputText chosen">
                                <f:selectItem itemValue="0" itemLabel="--Todos--"/>
                                <f:selectItems value="#{ManagedProductosDesarrolloVersion.productosSelectList}"/>
                            </h:selectOneMenu>
                            <h:outputText value="Nombre Generico" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:inputText style="width:20em" value="#{ManagedProductosDesarrolloVersion.componentesProdBuscar.nombreGenerico}" styleClass="inputText"/>
                            <h:outputText value="Area Empresa" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectOneMenu value="#{ManagedProductosDesarrolloVersion.componentesProdBuscar.areasEmpresa.codAreaEmpresa}" styleClass="inputText">
                                <f:selectItem itemValue="0" itemLabel="--Todos--"/>
                                <f:selectItems value="#{ManagedProductosDesarrolloVersion.areasFabricacionProductoSelectList}"/>
                            </h:selectOneMenu>
                            <h:outputText value="Forma Farmaceútica" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectOneMenu value="#{ManagedProductosDesarrolloVersion.componentesProdBuscar.forma.codForma}" styleClass="inputText chosen">
                                <f:selectItem itemValue="0" itemLabel="--Todos--"/>
                                <f:selectItems value="#{ManagedProductosDesarrolloVersion.formasFarmaceuticasSelectList}"/>
                            </h:selectOneMenu>
                            <h:outputText value="Estado" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectOneMenu value="#{ManagedProductosDesarrolloVersion.componentesProdBuscar.estadoCompProd.codEstadoCompProd}" styleClass="inputText">
                                 <f:selectItem itemValue="0" itemLabel="--Todos--"/>
                                 <f:selectItem itemValue="1" itemLabel="Activo"/>
                                 <f:selectItem itemValue="2" itemLabel="Discontinuado"/>
                            </h:selectOneMenu>
                            <h:outputText value="Tipo Produccion" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectOneMenu value="#{ManagedProductosDesarrolloVersion.componentesProdBuscar.tiposProduccion.codTipoProduccion}"
                                             styleClass="inputText">
                                <f:selectItems value="#{ManagedProductosDesarrolloVersion.tiposProduccionSelectList}"/>
                            </h:selectOneMenu>
                        </h:panelGrid>
                        <a4j:commandButton value="BUSCAR" styleClass="btn" action="#{ManagedProductosDesarrolloVersion.buscarComponentesProdDesarrolloList()}" reRender="dataComponentesProd"/>
                    </rich:panel>
                    <rich:dataTable value="#{ManagedProductosDesarrolloVersion.componentesProdList}"
                                    var="data" id="dataComponentesProd"
                                    headerClass="headerClassACliente"
                                    columnClasses="tituloCampo"
                                    style="margin-top:1em;">
                                <f:facet name="header">
                                    <rich:columnGroup>
                                            <rich:column rowspan="2">
                                                <h:outputText value="Nombre<br>Producto" escape="false"/>
                                            </rich:column>
                                            <rich:column rowspan="2">
                                                <h:outputText value="Tamaño<br>Lote<br>Producción" escape="false"/>
                                            </rich:column>
                                            <rich:column rowspan="2">
                                                <h:outputText value="Producto<br>Semi-elaborado" escape="false"/>
                                            </rich:column>
                                            <rich:column rowspan="2">
                                                <h:outputText value="Area<br>Fabricación" escape="false"/>
                                            </rich:column>
                                            <rich:column rowspan="2">
                                                <h:outputText value="Nombre<br>Comercial" escape="false"/>
                                            </rich:column>
                                            <rich:column colspan="3" >
                                                <h:outputText value="Datos Registro Sanitario" escape="false"/>
                                            </rich:column>

                                            <rich:column rowspan="2">
                                                <h:outputText value="Forma<br>Farmaceútica" escape="false"/>
                                            </rich:column>
                                            <rich:column rowspan="2">
                                                <h:outputText value="Volumen<br>Envase<br>Primario" escape="false"/>
                                            </rich:column>
                                            <rich:column rowspan="2">
                                                <h:outputText value="Peso<br>Teórico" escape="false"/>
                                            </rich:column>
                                            <rich:column rowspan="2">
                                                <h:outputText value="Sabor" escape="false"/>
                                            </rich:column>
                                            <rich:column rowspan="2">
                                                <h:outputText value="Nombre Genérico/<br>Concentración" escape="false"/>
                                            </rich:column>
                                            <rich:column rowspan="2">
                                                <h:outputText value="Estado" escape="false"/>
                                            </rich:column>
                                            <rich:column rowspan="2">
                                                <h:outputText value="Nro.<br>Versión" escape="false"/>
                                            </rich:column>
                                            <rich:column rowspan="2">
                                                <h:outputText value="Versiones" escape="false"/>
                                            </rich:column>
                                            <rich:column rowspan="2" rendered="#{ManagedProductosDesarrolloVersion.permisoInactivarProductoEstandarizacion}">
                                                <h:outputText value="Acciones" escape="false"/>
                                            </rich:column>
                                            <rich:column breakBefore="true">
                                                <h:outputText value="Registro<br>Sanitario" escape="false"/>
                                            </rich:column>
                                            <rich:column >
                                                <h:outputText value="Vida<br>Util" escape="false"/>
                                            </rich:column>
                                            <rich:column >
                                                <h:outputText value="Fecha Venc.<br> R.S." escape="false"/>
                                            </rich:column>
                                    </rich:columnGroup>
                                </f:facet>
                                <rich:columnGroup >
                                        <rich:column>
                                            <h:outputText value="#{data.nombreProdSemiterminado}" />
                                        </rich:column>
                                        <rich:column>
                                            <h:outputText value="#{data.tamanioLoteProduccion}" />
                                        </rich:column>
                                        <rich:column>
                                            <h:outputText value="#{data.productoSemiterminado?'SI':'NO'}" />
                                        </rich:column>
                                        <rich:column>
                                            <h:outputText value="#{data.areasEmpresa.nombreAreaEmpresa}" />
                                        </rich:column>
                                        <rich:column>
                                            <h:outputText value="#{data.producto.nombreProducto}" />
                                        </rich:column>
                                        <rich:column>
                                            <h:outputText value="#{data.regSanitario}" />
                                        </rich:column>
                                        <rich:column>
                                            <h:outputText value="#{data.vidaUtil}" />
                                        </rich:column>
                                        <rich:column>
                                            <h:outputText value="#{data.fechaVencimientoRS}">
                                                <f:convertDateTime pattern="dd/MM/yyyy"/>
                                            </h:outputText>
                                        </rich:column>
                                        <rich:column>
                                            <h:outputText value="#{data.forma.nombreForma}" />
                                        </rich:column>
                                        <rich:column>
                                            <h:outputText value="#{data.cantidadVolumen} #{data.unidadMedidaVolumen.abreviatura}" />
                                        </rich:column>
                                        <rich:column>
                                            <h:outputText value="#{data.pesoEnvasePrimario}" />
                                        </rich:column>
                                        <rich:column>
                                            <h:outputText value="#{data.saboresProductos.nombreSabor}" />
                                        </rich:column>
                                        <rich:column>
                                            <h:outputText value="#{data.concentracionEnvasePrimario}" />
                                        </rich:column>
                                        <rich:column>
                                            <h:outputText value="#{data.estadoCompProd.nombreEstadoCompProd}" />
                                        </rich:column>
                                        <rich:column>
                                            <h:outputText value="#{data.nroUltimaVersion}" />
                                        </rich:column>
                                        <rich:column>
                                            <a4j:commandLink oncomplete="redireccionar('navegadorProductosDesarrolloEnsayos.jsf')">
                                                <h:graphicImage url="../img/version.png" alt="Ensayos"/>
                                                <f:setPropertyActionListener value="#{data}" target="#{ManagedProductosDesarrolloVersion.componentesProdSeleccionado}"/>
                                            </a4j:commandLink>
                                        </rich:column>
                                        <rich:column rendered="#{ManagedProductosDesarrolloVersion.permisoInactivarProductoEstandarizacion}">
                                            <rich:dropDownMenu >
                                                <f:facet name="label">
                                                    <h:panelGroup>
                                                        <h:outputText value="Acciones"/>
                                                        <h:outputText styleClass="icon-menu3"/>
                                                    </h:panelGroup>
                                                </f:facet>
                                                <rich:menuItem  submitMode="none" iconClass="icon-minus" value="Inactivar Producto" 
                                                                rendered="#{data.estadoCompProd.codEstadoCompProd eq '1' 
                                                                            and ManagedProductosDesarrolloVersion.permisoInactivarProductoEstandarizacion}">
                                                    <a4j:support event="onclick" reRender="contenidoInactivarComponentesProd"
                                                                 oncomplete="Richfaces.showModalPanel('panelInactivarComponentesProd')" >
                                                        <f:setPropertyActionListener target="#{ManagedProductosDesarrolloVersion.componentesProdSeleccionado}" value="#{data}"/>
                                                    </a4j:support>
                                                </rich:menuItem>
                                            </rich:dropDownMenu>
                                        </rich:column>
                                </rich:columnGroup>
                            <f:facet name="footer">
                                <rich:columnGroup>
                                    <rich:column colspan="21" styleClass="tdCenter">
                                            <a4j:commandLink  action="#{ManagedProductosDesarrolloVersion.anteriorPagina_action}"  reRender="dataComponentesProd"
                                                    rendered="#{ManagedProductosDesarrolloVersion.begin>1}">
                                                    <h:outputText value="Anterior" styleClass="outputTextBold"/>
                                                    <h:outputText value="" styleClass="ui-icon ui-icon-seek-start"/>
                                            </a4j:commandLink>
                                            <a4j:commandLink  action="#{ManagedProductosDesarrolloVersion.siguientePagina_action}" reRender="dataComponentesProd"
                                                               rendered="#{ManagedProductosDesarrolloVersion.componentesProdListSize>19}">
                                                    <h:outputText value="" styleClass="ui-icon ui-icon-seek-end"/>
                                                    <h:outputText value="Siguiente" styleClass="outputTextBold"/>
                                            </a4j:commandLink>
                                    </rich:column>
                                </rich:columnGroup>
                            </f:facet>
                    </rich:dataTable>
                    <br>
                        <a4j:commandButton value="Agregar producto Desarrollo"
                                           action="#{ManagedProductosDesarrolloVersion.agregarProductoDesarrollo_action}"
                                           oncomplete="redireccionar('agregarProductoDesarrollo.jsf')" styleClass="btn"/>
                </div>
                    
               
            </a4j:form>
        <a4j:include viewId="/panelProgreso.jsp"/>
        <a4j:include viewId="/message.jsp" />
        <a4j:include viewId="panelInactivarProducto.jsp"/>
            
    </html>
    
</f:view>

