<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>

<html>
    <head>
        <title>SISTEMA</title>
        <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
        <link rel="STYLESHEET" type="text/css" href="../css/icons.css" />
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
    <body>
            <f:view>
            <a4j:form id="form1"  >       
               
                <div align="center">                    
                    
                    <h:outputText value="Productos" styleClass="outputTextTituloSistema"/>
                    <h:outputText value="#{ManagedComponentesProdVersion.cargarComponentesProd}"   />
                    <rich:panel headerClass="headerClassACliente">
                        <f:facet name="header">
                            <h:outputText value="Buscador"/>
                        </f:facet>
                        <h:panelGrid columns="6">
                            <h:outputText value="Nombre Producto" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:inputText style="width:20em" value="#{ManagedComponentesProdVersion.componentesProdBuscar.nombreProdSemiterminado}" styleClass="inputText"/>
                            
                            <h:outputText value="Nombre Comercial" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectOneMenu value="#{ManagedComponentesProdVersion.componentesProdBuscar.producto.codProducto}" styleClass="inputText">
                                <f:selectItem itemValue="0" itemLabel="--Todos--"/>
                                <f:selectItems value="#{ManagedComponentesProdVersion.productosSelectList}"/>
                            </h:selectOneMenu>
                            <h:outputText value="Nombre Generico" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:inputText style="width:20em" value="#{ManagedComponentesProdVersion.componentesProdBuscar.nombreGenerico}" styleClass="inputText"/>
                            <h:outputText value="Area Empresa" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectOneMenu value="#{ManagedComponentesProdVersion.componentesProdBuscar.areasEmpresa.codAreaEmpresa}" styleClass="inputText">
                                <f:selectItem itemValue="0" itemLabel="--Todos--"/>
                                <f:selectItems value="#{ManagedComponentesProdVersion.areasEmpresaSelectList}"/>
                            </h:selectOneMenu>
                            <h:outputText value="Forma Farmaceútica" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectOneMenu value="#{ManagedComponentesProdVersion.componentesProdBuscar.forma.codForma}" styleClass="inputText">
                                <f:selectItem itemValue="0" itemLabel="--Todos--"/>
                                <f:selectItems value="#{ManagedComponentesProdVersion.formasFarmaceuticasSelectList}"/>
                            </h:selectOneMenu>
                            <h:outputText value="Color Presentación Primaria" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectOneMenu value="#{ManagedComponentesProdVersion.componentesProdBuscar.coloresPresentacion.codColor}" styleClass="inputText">
                                <f:selectItem itemValue="0" itemLabel="--Todos--"/>
                                <f:selectItems value="#{ManagedComponentesProdVersion.coloresPresPrimSelectList}"/>
                            </h:selectOneMenu>
                            <h:outputText value="Tamaño Capsula" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectOneMenu value="#{ManagedComponentesProdVersion.componentesProdBuscar.tamaniosCapsulasProduccion.codTamanioCapsulaProduccion}" styleClass="inputText">
                                <f:selectItem itemValue='0' itemLabel="--Todos--"/>
                                <f:selectItems value="#{ManagedComponentesProdVersion.tamaniosCapsulasSelectList}"/>
                            </h:selectOneMenu>
                            <h:outputText value="Via Administración" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectOneMenu value="#{ManagedComponentesProdVersion.componentesProdBuscar.viasAdministracionProducto.codViaAdministracionProducto}" styleClass="inputText">
                                <f:selectItem itemValue='0' itemLabel="--Todos--"/>
                                <f:selectItems value="#{ManagedComponentesProdVersion.viasAdministracionSelectList}"/>
                            </h:selectOneMenu>
                            <h:outputText value="Estado" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectOneMenu value="#{ManagedComponentesProdVersion.componentesProdBuscar.estadoCompProd.codEstadoCompProd}" styleClass="inputText">
                                 <f:selectItem itemValue="0" itemLabel="--Todos--"/>
                                 <f:selectItems value="#{ManagedComponentesProdVersion.estadosCompProdSelectList}"/>
                            </h:selectOneMenu>
                            
                        </h:panelGrid>
                        <a4j:commandButton value="BUSCAR" styleClass="btn" action="#{ManagedComponentesProdVersion.buscarComponentesProd_action}" reRender="dataComponentesProd"/>
                    </rich:panel>
                    <table cellpadding="0" cellspacing="0" style="margin-top:1em">
                        <tr>
                            <td><span class="outputTextBold">En Proceso</span></td><td style="width:5em" class="enProceso">&nbsp;</td>
                            <td><span class="outputTextBold">En Aprobación</span></td><td style="width:5em" class="enviadoAprobacion">&nbsp;</td>
                        </tr>
                    </table>
                     
                    <rich:dataTable value="#{ManagedComponentesProdVersion.componentesProdList}"
                                    var="data" id="dataComponentesProd"
                                    headerClass="headerClassACliente"
                                    footerClass="footerDataTable"
                                    columnClasses="tituloCampo"
                                    style="margin-top:1em;"
                                    binding="#{ManagedComponentesProdVersion.componentesProdDataTable}"
                                    >
                            
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
                                                <h:outputText value="Color<br>Presentacion<br>Primaria" escape="false"/>
                                            </rich:column>
                                            <rich:column rowspan="2">
                                                <h:outputText value="Via<br>Administración" escape="false"/>
                                            </rich:column>
                                            <rich:column rowspan="2">
                                                <h:outputText value="Volumen<br>Envase<br>Primario" escape="false"/>
                                            </rich:column>
                                            <rich:column rowspan="2">
                                                <h:outputText value="Peso<br>Teórico" escape="false"/>
                                            </rich:column>
                                            <rich:column rowspan="2">
                                                <h:outputText value="Tolerancia<br>Volumen<br>Fabricar(%)" escape="false"/>
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
                                                <h:outputText value="Nro.<br> Versión" escape="false"/>
                                            </rich:column>
                                            <rich:column rowspan="2">
                                                <h:outputText value="Versiones" escape="false"/>
                                            </rich:column>
                                            <rich:column rowspan="2" rendered="#{ManagedComponentesProdVersion.controlPresentacionPrimaria or ManagedComponentesProdVersion.controlActivacionInactivacionproducto}">
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
                                <rich:columnGroup styleClass="#{(data.colorFila eq 1||data.colorFila eq 5?'enProceso':(data.colorFila eq 3?'enviadoAprobacion':''))}">
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
                                            <h:outputText value="#{data.nombreComercial}" />
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
                                            <h:outputText value="#{data.coloresPresentacion.nombreColor}" />
                                        </rich:column>
                                        <rich:column>
                                            <h:outputText value="#{data.viasAdministracionProducto.nombreViaAdministracionProducto}" />
                                        </rich:column>
                                        <rich:column>
                                            <h:outputText value="#{data.cantidadVolumen} #{data.unidadMedidaVolumen.abreviatura}" />
                                        </rich:column>
                                        <rich:column>
                                            <h:outputText value="#{data.pesoEnvasePrimario}" />
                                        </rich:column>
                                        <rich:column>
                                            <h:outputText value="#{data.toleranciaVolumenfabricar}" />
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
                                            <a4j:commandLink action="#{ManagedComponentesProdVersion.seleccionarComponenteProd_action}"
                                            oncomplete="window.location.href='navegadorComponentesProdVersion.jsf?data='+(new Date()).getTime().toString();">
                                                <h:graphicImage url="../img/version.png" alt="Versiones"/>
                                            </a4j:commandLink>
                                        </rich:column>
                                        <rich:column rendered="#{ManagedComponentesProdVersion.controlPresentacionPrimaria or ManagedComponentesProdVersion.controlActivacionInactivacionproducto}">
                                            <rich:dropDownMenu >
                                                <f:facet name="label">
                                                    <h:panelGroup>
                                                        <h:outputText value="Acciones"/>
                                                        <h:outputText styleClass="icon-menu3"/>
                                                    </h:panelGroup>
                                                </f:facet>
                                                <rich:menuItem  submitMode="none" iconClass="icon-minus" value="Inactivar Producto" rendered="#{data.estadoCompProd.codEstadoCompProd eq '1' and ManagedComponentesProdVersion.controlActivacionInactivacionproducto }">
                                                    <a4j:support event="onclick" reRender="contenidoInactivarComponentesProd"
                                                                 oncomplete="Richfaces.showModalPanel('panelInactivarComponentesProd')" >
                                                        <f:setPropertyActionListener target="#{ManagedComponentesProdVersion.componentesProdActivarInactivar}" value="#{data}"/>
                                                    </a4j:support>
                                                </rich:menuItem>
                                                <rich:menuItem  submitMode="none" iconClass="icon-minus" value="Activar Producto" 
                                                                rendered="#{data.estadoCompProd.codEstadoCompProd eq '2' and ManagedComponentesProdVersion.controlActivacionInactivacionproducto }">
                                                    <a4j:support event="onclick" reRender="contenidoActivarComponentesProd"
                                                                 oncomplete="Richfaces.showModalPanel('panelActivarComponentesProd')" >
                                                        <f:setPropertyActionListener target="#{ManagedComponentesProdVersion.componentesProdActivarInactivar}" value="#{data}"/>
                                                    </a4j:support>
                                                </rich:menuItem>
                                                <rich:menuItem  submitMode="none" rendered="#{ManagedComponentesProdVersion.controlPresentacionPrimaria}" iconClass="icon-folder-plus" value="Crear Nuevo Tamaño de Lote" 
                                                                    >
                                                        <a4j:support event="onclick" reRender="contenidoRegistroNuevotamanioLote"
                                                                     action="#{ManagedComponentesProdVersion.seleccionarCrearNuevoTamanioLote}"
                                                                     oncomplete="Richfaces.showModalPanel('panelCrearNuevoTamanioLote')" >
                                                            <f:setPropertyActionListener target="#{ManagedComponentesProdVersion.componentesProdBean}"
                                                                                                        value="#{data}"/>
                                                        </a4j:support>
                                                </rich:menuItem>
                                                <rich:menuItem  submitMode="none" iconClass="icon-minus" value="Enviar a Estandarización" 
                                                                rendered="#{data.estadoCompProd.codEstadoCompProd eq 1 and ManagedComponentesProdVersion.permisoEnviarProductoEstandarizacion}">
                                                    <a4j:support event="onclick" reRender="contenidoEnviarProductoEstandarizacion"
                                                                 action="#{ManagedComponentesProdVersion.seleccionarEnviarProductoEstandarizacionAction()}"
                                                                 oncomplete="Richfaces.showModalPanel('panelEnviarProductoEstandarizacion')" >
                                                        <f:setPropertyActionListener target="#{ManagedComponentesProdVersion.componentesProdActivarInactivar}" value="#{data}"/>
                                                    </a4j:support>
                                                </rich:menuItem>
                                            </rich:dropDownMenu>
                                            
                                        </rich:column>
                                </rich:columnGroup>
                        <f:facet name="footer">
                            <rich:columnGroup>
                                <rich:column colspan="21" >
                                        <a4j:commandLink  action="#{ManagedComponentesProdVersion.anteriorPagina_action}"  reRender="dataComponentesProd"
                                                rendered="#{ManagedComponentesProdVersion.begin>1}">
                                                <h:outputText value="Anterior" styleClass="outputTextBold"/>
                                                <h:outputText value="" styleClass="ui-icon ui-icon-seek-start"/>
                                        </a4j:commandLink>
                                        <a4j:commandLink  action="#{ManagedComponentesProdVersion.siguientePagina_action}" reRender="dataComponentesProd"
                                                           rendered="#{ManagedComponentesProdVersion.cantidadfilas>19}">
                                                <h:outputText value="" styleClass="ui-icon ui-icon-seek-end"/>
                                                <h:outputText value="Siguiente" styleClass="outputTextBold"/>
                                        </a4j:commandLink>
                                </rich:column>
                            </rich:columnGroup>
                        </f:facet>
                    </rich:dataTable>
                    
               
            </a4j:form>
            
            <rich:modalPanel id="panelEnviarProductoEstandarizacion" minHeight="230" headerClass="headerClassACliente"
                            minWidth="550" height="230" width="700" zindex="100" >
                <f:facet name="header">
                    <h:outputText value="<center>Enviar Producto a Estandarización</center>" escape="false"/>
                </f:facet>
                <a4j:form id="formEnviarProductoEstandarizacion">
                    <center>
                        <br/>
                        <h:panelGroup id="contenidoEnviarProductoEstandarizacion">
                            <h:panelGrid columns="3">
                                <h:outputText value="Producto" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:outputText value="#{ManagedComponentesProdVersion.componentesProdActivarInactivar.nombreProdSemiterminado}"styleClass="outputText2"/>
                                <h:outputText value="N° Versión" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:outputText value="#{ManagedComponentesProdVersion.componentesProdActivarInactivar.nroUltimaVersion}" styleClass="outputText2"/>
                                <h:outputText value="Tamaño Lote" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:outputText value="#{ManagedComponentesProdVersion.componentesProdActivarInactivar.tamanioLoteProduccion}" styleClass="outputText2"/>
                                <h:outputText value="Personal Asignado" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:selectOneMenu value="#{ManagedComponentesProdVersion.codPersonalAsignadoEstandarizacion}" 
                                                 styleClass="inputText chosen">
                                    <f:selectItems value="#{ManagedComponentesProdVersion.personalSelectList}"/>
                                </h:selectOneMenu>
                            </h:panelGrid>
                        </h:panelGroup>
                        <br/>
                        <a4j:commandButton action="#{ManagedComponentesProdVersion.enviarProductoEstandarizacionAction()}" 
                                           oncomplete="mostrarMensajeTransaccionEvento(function(){Richfaces.hideModalPanel('panelEnviarProductoEstandarizacion');})"
                                           reRender="dataComponentesProd"
                                           styleClass="btn" value="Enviar a Estandarización"/>
                        <a4j:commandButton value="Cancelar" styleClass="btn" oncomplete="Richfaces.hideModalPanel('panelEnviarProductoEstandarizacion')"/>
                    </center>
                </a4j:form>
            </rich:modalPanel>
            <rich:modalPanel id="panelActivarComponentesProd" 
                                minHeight="160" headerClass="headerClassACliente"
                                minWidth="550" height="160" 
                                width="700" zindex="100" >
                <f:facet name="header">
                    <h:outputText value="<center>Activar producto</center>" escape="false"/>
                </f:facet>
                <a4j:form id="formActivarComponentesProd">
                    <center>
                        <h:outputText  value="Esta seguro de activar el siguiente producto?" styleClass="outputTextBold"/>
                        <br/>
                        <h:panelGroup id="contenidoActivarComponentesProd">
                            <h:panelGrid columns="3">
                                <h:outputText value="Producto" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:outputText value="#{ManagedComponentesProdVersion.componentesProdActivarInactivar.nombreProdSemiterminado}"styleClass="outputText2"/>
                                <h:outputText value="N° Versión" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:outputText value="#{ManagedComponentesProdVersion.componentesProdActivarInactivar.nroUltimaVersion}" styleClass="outputText2"/>
                                <h:outputText value="Tamaño Lote Original" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:outputText value="#{ManagedComponentesProdVersion.componentesProdActivarInactivar.tamanioLoteProduccion}" styleClass="outputText2"/>
                            </h:panelGrid>
                        </h:panelGroup>
                        <br/>
                        <a4j:commandButton action="#{ManagedComponentesProdVersion.cambiarEstadoComponentesProdVersion_action(1)}" 
                                           oncomplete="mostrarMensajeTransaccionEvento(function(){Richfaces.hideModalPanel('panelActivarComponentesProd');})"
                                           reRender="dataComponentesProd"
                                           styleClass="btn" value="Activar Producto"/>
                        <a4j:commandButton value="Cancelar" styleClass="btn" oncomplete="Richfaces.hideModalPanel('panelActivarComponentesProd')"/>
                    </center>
                </a4j:form>
            </rich:modalPanel>
            <rich:modalPanel id="panelInactivarComponentesProd" minHeight="160" headerClass="headerClassACliente"
                            minWidth="550" height="160" width="700" zindex="100" >
                <f:facet name="header">
                    <h:outputText value="<center>Inactivar producto</center>" escape="false"/>
                </f:facet>
                <a4j:form id="formInactivarComponentesProd">
                    <center>
                        <h:outputText  value="Esta seguro de inactivar el siguiente producto?" styleClass="outputTextBold"/>
                        <br/>
                        <h:panelGroup id="contenidoInactivarComponentesProd">
                            <h:panelGrid columns="3">
                                <h:outputText value="Producto" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:outputText value="#{ManagedComponentesProdVersion.componentesProdActivarInactivar.nombreProdSemiterminado}"styleClass="outputText2"/>
                                <h:outputText value="N° Versión" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:outputText value="#{ManagedComponentesProdVersion.componentesProdActivarInactivar.nroUltimaVersion}" styleClass="outputText2"/>
                                <h:outputText value="Tamaño Lote Original" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:outputText value="#{ManagedComponentesProdVersion.componentesProdActivarInactivar.tamanioLoteProduccion}" styleClass="outputText2"/>
                            </h:panelGrid>
                        </h:panelGroup>
                        <br/>
                        <a4j:commandButton action="#{ManagedComponentesProdVersion.cambiarEstadoComponentesProdVersion_action(2)}" 
                                           oncomplete="mostrarMensajeTransaccionEvento(function(){Richfaces.hideModalPanel('panelInactivarComponentesProd');})"
                                           reRender="dataComponentesProd"
                                           styleClass="btn" value="Inactivar Producto"/>
                        <a4j:commandButton value="Cancelar" styleClass="btn" oncomplete="Richfaces.hideModalPanel('panelInactivarComponentesProd')"/>
                    </center>
                                           
                </a4j:form>
                
            </rich:modalPanel>
            
            <a4j:include viewId="/message.jsp" />
            <a4j:include viewId="/panelProgreso.jsp"/>
            <a4j:include viewId="panelCrearNuevoTamanioLote.jsp" id="crearNuevoTamanioLote" />
        </f:view>
        </body>
        
    </html>
    


