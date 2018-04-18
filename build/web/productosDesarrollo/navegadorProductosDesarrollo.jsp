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
            <script type="text/javascript" src='../js/general.js' ></script>
            <script type="text/javascript" src='../js/treeComponet.js' ></script> 
            <style type="text/css">
                .codcompuestoprod{
                background-color:#ADD797;
                }.nocodcompuestoprod{
                background-color:#FFFFFF;
                }
                
            </style>
        </head>
        <body>
            
            <h:form id="form1"  >                
                <div align="center">                    
                    
                    <h:outputText value="#{ManagedProductosDesarrollo.cargarComponentesProdDesarrollo}"   />
                    <h3>Información de Producto Semiterminado</h3>
                    <rich:panel headerClass="headerClassACliente" style="width:80%">
                        <f:facet name="header">
                            <h:outputText value="BUSCADOR"/>
                        </f:facet>
                    <h:panelGrid columns="6">
                        <h:outputText value="Nombre Producto" styleClass="outputText2" style="font-weight:bold"/>
                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                        <h:inputText value="#{ManagedProductosDesarrollo.componentesProdBuscar.nombreProdSemiterminado}" styleClass="inputText"/>
                        <h:outputText value="Nombre Generico" styleClass="outputText2" style="font-weight:bold"/>
                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                        <h:inputText value="#{ManagedProductosDesarrollo.componentesProdBuscar.nombreGenerico}" styleClass="inputText"/>
                        <h:outputText value="Nombre Comercial" styleClass="outputText2" style="font-weight:bold"/>
                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                    <h:selectOneMenu value="#{ManagedProductosDesarrollo.componentesProdBuscar.producto.codProducto}" styleClass="inputText">
                        <f:selectItem itemValue="0" itemLabel="--TODOS--"/>
                        <f:selectItems value="#{ManagedProductosDesarrollo.productosSelectList}"/>
                    </h:selectOneMenu>
                    <h:outputText value="Color" styleClass="outputText2" style="font-weight:bold"/>
                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                        <h:selectOneMenu value="#{ManagedProductosDesarrollo.componentesProdBuscar.coloresPresentacion.codColor}" styleClass="inputText">
                            <f:selectItem itemValue="0" itemLabel="--TODOS--"/>
                            <f:selectItems value="#{ManagedProductosDesarrollo.coloresPresPrimList}"/>
                    </h:selectOneMenu>
                        <h:outputText value="Sabor" styleClass="outputText2" style="font-weight:bold"/>
                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                        <h:selectOneMenu value="#{ManagedProductosDesarrollo.componentesProdBuscar.saboresProductos.codSabor}" styleClass="inputText">
                            <f:selectItem itemValue="0" itemLabel="--TODOS--"/>
                            <f:selectItems value="#{ManagedProductosDesarrollo.saboresSelectList}"/>
                        </h:selectOneMenu>
                         <h:outputText value="Area Fabricación" styleClass="outputText2" style="font-weight:bold"/>
                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                        <h:selectOneMenu value="#{ManagedProductosDesarrollo.componentesProdBuscar.areasEmpresa.codAreaEmpresa}" styleClass="inputText">
                            <f:selectItem itemValue="0" itemLabel="--TODOS--"/>
                            <f:selectItems value="#{ManagedProductosDesarrollo.areasEmpresaSelectList}"/>
                        </h:selectOneMenu>
                        <h:outputText value="Via Administración" styleClass="outputText2" style="font-weight:bold"/>
                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                        <h:selectOneMenu value="#{ManagedProductosDesarrollo.componentesProdBuscar.viasAdministracionProducto.codViaAdministracionProducto}" styleClass="inputText">
                            <f:selectItem itemValue='0' itemLabel="--TODOS--"/>
                            <f:selectItems value="#{ManagedProductosDesarrollo.viasAdministracionSelectList}"/>
                        </h:selectOneMenu>
                        <h:outputText value="Forma Farmaceutica" styleClass="outputText2" style="font-weight:bold"/>
                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                        <h:selectOneMenu value="#{ManagedProductosDesarrollo.componentesProdBuscar.forma.codForma}" styleClass="inputText">
                            <f:selectItem itemValue="0" itemLabel="--TODOS--"/>
                            <f:selectItems value="#{ManagedProductosDesarrollo.formasFarmaceuticasSelectList}"/>
                        </h:selectOneMenu>
                        <h:outputText value="Estado" styleClass="outputText2" style="font-weight:bold"/>
                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                        <h:selectOneMenu value="#{ManagedProductosDesarrollo.componentesProdBuscar.estadoCompProd.codEstadoCompProd}" styleClass="inputText">
                            <f:selectItem itemValue="0" itemLabel="--TODOS--"/>
                            <f:selectItem itemValue="1" itemLabel="Activo"/>
                            <f:selectItem itemValue="2" itemLabel="Discontinuado"/>
                        </h:selectOneMenu>
                        
                    </h:panelGrid>
                    <a4j:commandButton value="BUSCAR" reRender="dataProductosDesarrollo" styleClass="btn" action="#{ManagedProductosDesarrollo.buscarComponentesProdDesarollo_action}"/>
                    </rich:panel>
                    <rich:dataTable value="#{ManagedProductosDesarrollo.componentesProdDesarrolloList}" var="data" id="dataProductosDesarrollo"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#F3F7FD';" 
                                    headerClass="headerClassACliente"
                                    columnClasses="tituloCampo" style="margin-top:1em"
                                    binding = "#{ManagedProductosDesarrollo.htmlDataTableProductos}">
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value=""  />
                                
                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.checked}"  />
                            
                        </rich:column >
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value="Nombre Producto Semiterminado"  />
                            </f:facet>
                            <h:outputText value="#{data.nombreProdSemiterminado}"  />
                        </rich:column >
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value="Nombre Generico"  />
                            </f:facet>
                            <h:outputText value="#{data.nombreGenerico}"  />
                        </rich:column >
                         <rich:column >
                            <f:facet name="header">
                                <h:outputText value="Nombre Comercial"  />
                            </f:facet>
                            <h:outputText value="#{data.producto.nombreProducto}"  />
                        </rich:column >
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value="Forma Farmacéutica"  />
                            </f:facet>
                            <h:outputText value="#{data.forma.nombreForma}"  />
                        </rich:column >
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value="Concentración"  />
                            </f:facet>
                            <h:outputText value="#{data.concentracionEnvasePrimario}"  />
                        </rich:column >
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value="Via Administración"  />
                            </f:facet>
                            <h:outputText value="#{data.viasAdministracionProducto.nombreViaAdministracionProducto}"  />
                        </rich:column >
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value="Volúmen Envase Primario "  />
                            </f:facet>
                            <h:outputText value="#{data.cantidadVolumen}" rendered="#{data.cantidadVolumen>0}">
                                <f:convertNumber pattern="###.##" locale="EN" />
                            </h:outputText>
                            <h:outputText value=" #{data.unidadMedidaVolumen.abreviatura}" rendered="#{data.cantidadVolumen>0}"/>
                        </rich:column >
                       
                        
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value="Peso Envase Primario "  />
                            </f:facet>
                            <h:outputText value="#{data.pesoEnvasePrimario}"  />
                        </rich:column >
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value="Color Presentación Primaria"  />
                            </f:facet>
                            <h:outputText value="#{data.coloresPresentacion.nombreColor}"  />
                        </rich:column >
                        
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value="Sabor"  />
                            </f:facet>
                            <h:outputText value="#{data.saboresProductos.nombreSabor}"  />
                        </rich:column >
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value="Área de Fabricación"  />
                            </f:facet>
                            <h:outputText value="#{data.areasEmpresa.nombreAreaEmpresa}"  />
                        </rich:column >
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value="Producto Semiterminado"  />
                            </f:facet>
                            <h:outputText value="SI" rendered="#{data.productoSemiterminado}"  />
                            <h:outputText value="NO" rendered="#{!data.productoSemiterminado}"  />
                        </rich:column >
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Estado"  />
                            </f:facet>
                            <h:outputText value="#{data.estadoCompProd.nombreEstadoCompProd}" />
                        </rich:column>
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Presentaciones<br>Primarias" escape="false"  />
                            </f:facet>
                            <a4j:commandLink action="#{ManagedProductosDesarrollo.seleccionProducionPresentacionPrimaria_action}" oncomplete="window.location.href='presentacionesPrimarias/navegadorPresentacionesPrimarias.jsf?data='+(new Date()).getTime().toString();">
                                <h:outputText value="Presentaciones<br>Primarias" escape="false" />
                            </a4j:commandLink>
                            
                        </rich:column>
                        

                    </rich:dataTable>
                    <br>
                        <a4j:commandButton value="Agregar" oncomplete="window.location.href='agregarProductoDesarrollo.jsf?date='+(new Date()).getTime().toString();" styleClass="btn" />
                        <a4j:commandButton value="Editar" onclick="if(!editarItem('form1:dataProductosDesarrollo')){return false;}" action="#{ManagedProductosDesarrollo.editarProductoDesarrollo_action}" oncomplete="window.location.href='editarProductoDesarrollo.jsf?date='+(new Date()).getTime().toString();" styleClass="btn" />
                    <%--h:commandButton rendered="#{ManagedComponentesProducto.editarRs}" value="Editar R.S."  styleClass="btn"  action="#{ManagedComponentesProducto.editarRegistroSanitario_action}" onclick="return editarItem('form1:dataProductosDesarrollo');"/>
                    <h:commandButton rendered="#{ManagedComponentesProducto.editarTipoProd}" value="Editar Produccion"  styleClass="btn" style="width='150px'" action="#{ManagedComponentesProducto.editarTipoProduccion_action}" onclick="return editarItem('form1:dataProductosDesarrollo');"/>
                    <h:commandButton rendered="#{ManagedComponentesProducto.agregarEdicionProd}" value="Eliminar"  styleClass="btn"  action="#{ManagedComponentesProducto.actionEliminar}"  onclick="return eliminarItem('form1:dataProductosDesarrollo');"/--%>
                    
                </div>
                <!--cerrando la conexion-->
               
            </h:form>
            <a4j:status id="statusPeticion"
                                onstart="Richfaces.showModalPanel('ajaxLoadingModalBox',{width:100, top:100})"
                                onstop="Richfaces.hideModalPanel('ajaxLoadingModalBox')">
                    </a4j:status>

                    <rich:modalPanel id="ajaxLoadingModalBox" minHeight="100"
                                     minWidth="200" height="80" width="400" zindex="100" onshow="window.focus();">

                        <div align="center">
                            <h:graphicImage value="../img/load2.gif" />
                        </div>
                    </rich:modalPanel>
            
            
        </body>
    </html>
    
</f:view>

