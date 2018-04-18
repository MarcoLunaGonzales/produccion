
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
            <script type="text/javascript" src="../js/general.js" ></script>
            <script type="text/javascript">
                function validarGuardarSolicitudCompra()
                {
                    var tabla=document.getElementById("form1:dataSolicitudCompraDetalle").getElementsByTagName("tbody")[0];
                    var incremento=0;
                    var codEstadoSolicitud=0;
                    var selectAnterior=null;
                    var inputPrecioUnitario=null;
                    var contOc=0;
                    for(var i=0;i<tabla.rows.length;i++)
                    {
                        if(tabla.rows[i].cells.length===14)
                        {
                            inputPrecioUnitario=null;
                            /*if(selectAnterior!=null&&codEstadoSolicitud!=-1)
                            {
                                if(!validarSeleccionMayorACero(selectAnterior))
                                    return false;
                            }*/
                            incremento=8;
                            if(tabla.rows[i].cells[13].getElementsByTagName("select").length>0)
                            {
                                codEstadoSolicitud=tabla.rows[i].cells[13].getElementsByTagName("select")[0].value;
                                selectAnterior=tabla.rows[i].cells[13].getElementsByTagName("select")[0];
                                inputPrecioUnitario=tabla.rows[i].cells[5].getElementsByTagName("input")[0];
                            }
                            else
                                codEstadoSolicitud=-1;
                        }
                        else
                        {
                            incremento=0;
                        }
                        if(!validarMayorIgualACero(inputPrecioUnitario)) 
                        {
                            return false;
                        }
                        contOc+=((tabla.rows[i].cells[incremento].getElementsByTagName("input").length>0&&tabla.rows[i].cells[incremento].getElementsByTagName("input")[0].checked)?1:0);
                        if(tabla.rows[i].cells[incremento].getElementsByTagName("input").length>0&&tabla.rows[i].cells[incremento].getElementsByTagName("input")[0].checked)
                        {
                            codEstadoSolicitud=-1;
                            if(inputPrecioUnitario!=null)
                                if(!validarMayorACero(inputPrecioUnitario))
                                    return false;
                            if(!validarMayorACero(tabla.rows[i].cells[incremento+1].getElementsByTagName("input")[0]))
                                return false;
                        }
                    }
                    if(contOc>0)
                    {
                        return confirm('Al guardar se generaran ordenes de compra para '+contOc+" item(s), esta seguro de continuar?");
                    }
                    
                    return true;
                }
            </script>
        </head>
            <a4j:form id="form1" >
                <center>
                    <h:outputText value="#{ManagedProgramaProduccionSolicitudCompra.cargarProgramaProduccionPeriodoSolicitudCompraDetalleList}"  />
                    <rich:panel headerClass="headerClassACliente" style="width:80%">
                        <f:facet name="header">
                            <h:outputText value="Datos Solicitud Compra"/>
                        </f:facet>
                        <h:panelGrid columns="3">
                            <h:outputText value="Programa Producción Simulación" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:outputText value="#{ManagedProgramaProduccionSolicitudCompra.programaProduccionPeriodoBean.nombreProgramaProduccion}" styleClass="outputText2"/>
                            <h:outputText value="Proveedor" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:outputText value="#{ManagedProgramaProduccionSolicitudCompra.programaProduccionPeriodoSolicitudCompraBean.proveedores.nombreProveedor}" styleClass="outputText2"/>
                        </h:panelGrid>
                    </rich:panel>
                    
                    <rich:dataTable value="#{ManagedProgramaProduccionSolicitudCompra.programaProduccionPeriodoSolicitudCompraDetalleList}"
                                    var="data" id="dataSolicitudCompraDetalle"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    style="margin-top:1em"
                                    binding="#{ManagedProgramaProduccionSolicitudCompra.programaProduccionPeriodoSolicitudCompraDetalleDataTable}"
                                    headerClass="headerClassACliente" >
                        <f:facet name="header">
                            <rich:columnGroup>
                                <rich:column rowspan="2">
                                    <h:outputText value="Material"/>
                                </rich:column>
                                <%--rich:column colspan="2">
                                    <h:outputText value="Detalle Solicitud Producción"/>
                                </rich:column--%>
                                <rich:column colspan="3">
                                    <h:outputText value="Datos Ultima Compra"/>
                                </rich:column>
                                <rich:column rowspan="2" styleClass="tdRigtht">
                                    <h:outputText value="Cantidad Transito"/>
                                </rich:column>
                                <%--rich:column colspan="2">
                                    <h:outputText value="Datos Penultima Compra"/>
                                </rich:column--%>
                                <rich:column rowspan="2">
                                    <h:outputText value="Precio Unitario<br>(Bs/USD)" escape="false"/>
                                </rich:column>
                                <rich:column colspan="2">
                                    <h:outputText value="Detalle Solicitud Compra"/>
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Generar<br>O.C." escape="false"/>
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Cantidad a Comprar"/>
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Transporte"/>
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Observación"/>
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Acciones"/>
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Estado"/>
                                </rich:column>
                                <%--rich:column breakBefore="true">
                                    <h:outputText value="Cantidad"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Unidad Medida"/>
                                </rich:column--%>
                                <rich:column breakBefore="true">
                                    <h:outputText value="Cantidad" />
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Precio Unitario (Bs/USD)"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Transporte"/>
                                </rich:column>
                                <%--rich:column>
                                    <h:outputText value="Cantidad"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Precio Unitario (Bs.)"/>
                                </rich:column--%>
                                <rich:column >
                                    <h:outputText value="Cantidad"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Unidad Medida"/>
                                </rich:column>
                            </rich:columnGroup>
                        </f:facet>
                                <rich:subTable value="#{data.programaProduccionPeriodoSolicitudCompraDetalleFraccionList}" var="subData" rowKeyVar="key">
                                    
                                        <rich:column rendered="#{key eq 0}" rowspan="#{data.programaProduccionPeriodoSolicitudCompraDetalleFraccionListSize}">
                                            <h:outputText value="#{data.materiales.nombreMaterial}"/>
                                        </rich:column>
                                        <%--rich:column rendered="#{key eq 0}" rowspan="#{data.programaProduccionPeriodoSolicitudCompraDetalleFraccionListSize}" styleClass="tdRight">
                                            <h:outputText value="#{data.cantidadSolicitudProduccion}"/>
                                        </rich:column>
                                        <rich:column rendered="#{key eq 0}" rowspan="#{data.programaProduccionPeriodoSolicitudCompraDetalleFraccionListSize}">
                                            <h:outputText value="#{data.unidadMedidaProduccion.nombreUnidadMedida}"/>
                                        </rich:column--%>

                                        <rich:column rendered="#{key eq 0}" rowspan="#{data.programaProduccionPeriodoSolicitudCompraDetalleFraccionListSize}" styleClass="tdRight">
                                            <h:outputText value="#{data.ultimaOrdenCompra.cantidadNeta}">
                                                <f:convertNumber pattern="#####0.00" locale="en"/>
                                            </h:outputText>
                                        </rich:column>
                                        <rich:column rendered="#{key eq 0}" rowspan="#{data.programaProduccionPeriodoSolicitudCompraDetalleFraccionListSize}" styleClass="tdRight">
                                            <h:outputText value="#{data.ultimaOrdenCompra.precioUnitario}">
                                                <f:convertNumber pattern="#####0.00" locale="en"/>
                                            </h:outputText>
                                        </rich:column>
                                        <rich:column>
                                            <h:outputText value="#{data.ultimaOrdenCompra.ordenesCompra.tiposTransporte.nombreTipoTransporte}"/>
                                        </rich:column>
                                        <rich:column styleClass="tdRight">
                                            <h:outputText value="#{data.cantidadTransito}" />
                                        </rich:column>
                                        <%--rich:column rendered="#{key eq 0}" rowspan="#{data.programaProduccionPeriodoSolicitudCompraDetalleFraccionListSize}" styleClass="tdRight">
                                            <h:outputText value="#{data.penultimaOrdenCompra.cantidadNeta}">
                                                <f:convertNumber pattern="#####0.00" locale="en"/>
                                            </h:outputText>
                                        </rich:column>
                                        <rich:column rendered="#{key eq 0}" rowspan="#{data.programaProduccionPeriodoSolicitudCompraDetalleFraccionListSize}" styleClass="tdRight">
                                            <h:outputText value="#{data.penultimaOrdenCompra.precioUnitario}">
                                                <f:convertNumber pattern="#####0.00" locale="en"/>
                                            </h:outputText>
                                        </rich:column--%>
                                        <rich:column rendered="#{key eq 0}" rowspan="#{data.programaProduccionPeriodoSolicitudCompraDetalleFraccionListSize}" styleClass="tdCenter">
                                            <h:inputText value="#{data.precioUnitario}" styleClass="inputText" style="width:4em" onblur="valorPorDefecto(this);"
                                                         rendered="#{data.estadosProgramaProduccionPeriodoSolicitudCompraDetalle.codEstadoProgramaProduccionPeriodoSolicitudCompraDetalle!=3&&data.estadosProgramaProduccionPeriodoSolicitudCompraDetalle.codEstadoProgramaProduccionPeriodoSolicitudCompraDetalle!=4}"/>
                                            <h:outputText value="#{data.precioUnitario}" 
                                                         rendered="#{data.estadosProgramaProduccionPeriodoSolicitudCompraDetalle.codEstadoProgramaProduccionPeriodoSolicitudCompraDetalle eq 3|| data.estadosProgramaProduccionPeriodoSolicitudCompraDetalle.codEstadoProgramaProduccionPeriodoSolicitudCompraDetalle eq 4}"/>
                                        </rich:column>
                                        <rich:column rendered="#{key eq 0}" rowspan="#{data.programaProduccionPeriodoSolicitudCompraDetalleFraccionListSize}">
                                            <h:outputText value="#{data.cantidadSolicitudCompra}" styleClass="outputText2" />
                                        </rich:column>
                                        <rich:column rendered="#{key eq 0}" rowspan="#{data.programaProduccionPeriodoSolicitudCompraDetalleFraccionListSize}">
                                            <h:outputText value="#{data.unidadMedidaCompra.nombreUnidadMedida}"/>
                                        </rich:column>
                                        <rich:column styleClass="tdCenter">
                                            <h:selectBooleanCheckbox value="#{subData.checked}" rendered="#{subData.ordenesCompraDetalle.ordenesCompra.codOrdenCompra eq '0'}"/>
                                            <h:outputText value="O.C:<br>#{subData.ordenesCompraDetalle.ordenesCompra.nroOrdenCompra}" styleClass="outputText2" rendered="#{subData.ordenesCompraDetalle.ordenesCompra.codOrdenCompra >0}" escape="false"/>
                                        </rich:column>
                                        <rich:column>
                                            <h:inputText value="#{subData.cantidadFraccion}" style="width:7em" styleClass="inputText" rendered="#{subData.ordenesCompraDetalle.ordenesCompra.codOrdenCompra eq '0'}" onblur="valorPorDefecto(this);"/>
                                            <h:outputText value="#{subData.cantidadFraccion}" styleClass="outputText2" rendered="#{subData.ordenesCompraDetalle.ordenesCompra.codOrdenCompra >0}"/>
                                        </rich:column>
                                        <rich:column>
                                            <h:selectOneMenu value="#{subData.tiposTransporte.codTipoTransporte}" styleClass="inputText" rendered="#{subData.ordenesCompraDetalle.ordenesCompra.codOrdenCompra eq '0'}" style="width:12em">
                                                <f:selectItems value="#{ManagedProgramaProduccionSolicitudCompra.tiposTransporteSelectList}"/>
                                            </h:selectOneMenu>
                                            <h:outputText value="#{subData.tiposTransporte.nombreTipoTransporte}" styleClass="outputText2" rendered="#{subData.ordenesCompraDetalle.ordenesCompra.codOrdenCompra >0}"/>
                                        </rich:column>
                                        <rich:column>
                                            <h:inputTextarea value="#{subData.observacion}" styleClass="inputText" rendered="#{subData.ordenesCompraDetalle.ordenesCompra.codOrdenCompra eq 0}" style="width:12em">
                                            </h:inputTextarea>
                                            <h:outputText value="#{subData.observacion}" styleClass="outputText2" rendered="#{subData.ordenesCompraDetalle.ordenesCompra.codOrdenCompra >0}"/>
                                        </rich:column>
                                        <rich:column rendered="#{key eq 0}" rowspan="#{data.programaProduccionPeriodoSolicitudCompraDetalleFraccionListSize}" styleClass="tdCenter"> 
                                            <a4j:commandLink  reRender="dataSolicitudCompraDetalle" action="#{ManagedProgramaProduccionSolicitudCompra.agregarProgramaProduccionPeriodoSolicitudCompraDetalleFraccion_action}"
                                                              rendered="#{data.estadosProgramaProduccionPeriodoSolicitudCompraDetalle.codEstadoProgramaProduccionPeriodoSolicitudCompraDetalle!=4}">
                                                <h:graphicImage title="Adicionar Detalle"  url="../img/masDocumento.jpg"/>
                                                
                                            </a4j:commandLink>
                                            <a4j:commandLink  reRender="contenidoCambiarProveedor"  action="#{ManagedProgramaProduccionSolicitudCompra.seleccionarProgramaProduccionPeriodoSolicitudCompraDetalleCambioProveedor_action}"
                                                              rendered="#{data.estadosProgramaProduccionPeriodoSolicitudCompraDetalle.codEstadoProgramaProduccionPeriodoSolicitudCompraDetalle!=3&&data.estadosProgramaProduccionPeriodoSolicitudCompraDetalle.codEstadoProgramaProduccionPeriodoSolicitudCompraDetalle!=4}"
                                                              oncomplete="Richfaces.showModalPanel('panelCambiarProveedor')">
                                                <h:graphicImage title="Cambio Proveedor"  url="../img/cambioProveedor.jpg"/>
                                            </a4j:commandLink>
                                        </rich:column>
                                        <rich:column rendered="#{key eq 0}" rowspan="#{data.programaProduccionPeriodoSolicitudCompraDetalleFraccionListSize}">
                                            <h:selectOneMenu value="#{data.estadosProgramaProduccionPeriodoSolicitudCompraDetalle.codEstadoProgramaProduccionPeriodoSolicitudCompraDetalle}" 
                                                             rendered="#{data.estadosProgramaProduccionPeriodoSolicitudCompraDetalle.codEstadoProgramaProduccionPeriodoSolicitudCompraDetalle!=3&&data.estadosProgramaProduccionPeriodoSolicitudCompraDetalle.codEstadoProgramaProduccionPeriodoSolicitudCompraDetalle!=4}"
                                                             styleClass="inputText">
                                                <f:selectItem itemLabel="--Sin Asignar--" itemValue='0'/>
                                                <f:selectItems value="#{ManagedProgramaProduccionSolicitudCompra.estadosProgramaProduccionPeriodoSolicitudCompraDetalleSelectList}"/>
                                            </h:selectOneMenu>
                                            <h:outputText value="#{data.estadosProgramaProduccionPeriodoSolicitudCompraDetalle.nombreEstadoProgramaProduccionPeriodoSolicitudCompraDetalle}"
                                                          rendered="#{data.estadosProgramaProduccionPeriodoSolicitudCompraDetalle.codEstadoProgramaProduccionPeriodoSolicitudCompraDetalle eq 3 || data.estadosProgramaProduccionPeriodoSolicitudCompraDetalle.codEstadoProgramaProduccionPeriodoSolicitudCompraDetalle eq 4}"/>
                                        </rich:column>
                                </rich:subTable>
                            

                    </rich:dataTable>
                    <div id="bottonesAcccion" class="barraBotones">
                            <a4j:commandButton value="Guardar" styleClass="btn" action="#{ManagedProgramaProduccionSolicitudCompra.guardarProgramaProduccionPeriodoSolicitudCompraDetalle_action}"
                                               onclick="if(!validarGuardarSolicitudCompra()){return false;}"
                                               oncomplete="if(#{ManagedProgramaProduccionSolicitudCompra.mensaje eq '1'}){alert('Se registro el detalle');window.location.href='navegadorProgramaProduccionSolicitudesCompras.jsf?save'+(new Date()).getTime().toString();}
                                               else{alert('#{ManagedProgramaProduccionSolicitudCompra.mensaje}');}"/>
                            <%--a4j:commandButton value="Agregar Material" styleClass="btn" oncomplete="Richfaces.showModalPanel('panelAgregarMaterial')" 
                                               action="#{ManagedProgramaProduccionSolicitudCompra.agregarMaterialCompraProveedor_action}"
                                               reRender="contenidoAgregarMaterial"/--%>
                            <a4j:commandButton value="Cancelar" styleClass="btn" 
                                               oncomplete="window.location.href='navegadorProgramaProduccionSolicitudesCompras.jsf?cancel='+(new Date()).getTime().toString();"
                                               />
                    </div>
                    </center>
            </a4j:form>
            <rich:modalPanel id="panelAgregarMaterial" minHeight="140"  minWidth="600"
                            height="380" width="600"
                            zindex="4"
                            headerClass="headerClassACliente"
                            resizeable="false" style="overflow :auto" >
                <f:facet name="header">
                    <h:outputText value="<center>Agregar Material</center>" escape="false"/>
                </f:facet>
                <a4j:form id="formAgregarMaterial">
                    <h:panelGroup id="contenidoAgregarMaterial">
                        <div align="center">
                        <h:panelGrid columns="3">
                            <%--h:outputText value="Capitulo" styleClass="outputTextBold" />
                            <h:outputText value="::" styleClass="outputTextBold" />
                            <h:selectOneMenu value="#{ManagedProgramaProduccionSolicitudCompra.materialesBuscarAgregar.grupo.capitulo.codCapitulo}" styleClass="inputText"
                                             style="width:30em">
                                <f:selectItems value="#{ManagedProgramaProduccionSolicitudCompra.capitulosSelectList}"/>
                                <a4j:support event="onchange" reRender="codGrupoAgregar" action="#{ManagedProgramaProduccionSolicitudCompra.codCapituloMaterialBuscarAgregar_change}"/>
                            </h:selectOneMenu>
                            <h:outputText value="Grupo" styleClass="outputTextBold" />
                            <h:outputText value="::" styleClass="outputTextBold" />
                            <h:selectOneMenu id="codGrupoAgregar" value="#{ManagedProgramaProduccionSolicitudCompra.materialesBuscarAgregar.grupo.codGrupo}" styleClass="inputText"
                                             style="width:30em">
                                <f:selectItems value="#{ManagedProgramaProduccionSolicitudCompra.gruposSelectList}"/>
                            </h:selectOneMenu>
                            <h:outputText value="Material" styleClass="outputTextBold" />
                            <h:outputText value="::" styleClass="outputTextBold" />
                            <h:inputText value="#{ManagedProgramaProduccionSolicitudCompra.materialesBuscarAgregar.nombreMaterial}" styleClass="inputText"/--%>
                        </h:panelGrid>
                        <a4j:commandButton styleClass="btn" value="BUSCAR" reRender="dataMateriales"
                                               action="#{ManagedProgramaProduccionSolicitudCompra.buscarMaterialAgregar_action}"/>
                            <div style="height:200px;overflow-y:auto">
                                <rich:dataTable value="#{ManagedProgramaProduccionSolicitudCompra.materialesList}"
                                                var="material" id="dataMateriales" headerClass="headerClassACliente" binding="#{ManagedProgramaProduccionSolicitudCompra.materialesDataTable}">
                                    <f:facet name="header">
                                        <rich:columnGroup>
                                            <rich:column>
                                                <h:outputText value="Material"/>
                                            </rich:column>
                                            <rich:column>
                                                <h:outputText value="Grupo"/>
                                            </rich:column>
                                            <rich:column>
                                                <h:outputText value="Capitulo"/>
                                            </rich:column>
                                        </rich:columnGroup>
                                    </f:facet>
                                    <rich:column>
                                        <a4j:commandLink action="#{ManagedProgramaProduccionSolicitudCompra.seleccionarAgregarMaterialSolicitudOrdenCompra_action}" value="#{material.nombreMaterial}"
                                                         oncomplete="Richfaces.hideModalPanel('panelAgregarMaterial')" reRender="dataSolicitudCompraDetalle">
                                        </a4j:commandLink>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="#{material.grupo.nombreGrupo}"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="#{material.grupo.capitulo.nombreCapitulo}"/>
                                    </rich:column>
                                </rich:dataTable>
                            </div>        
                                <input type="button" value="Cancelar" onclick="Richfaces.hideModalPanel('panelAgregarMaterial')" class="btn" />
                            </div>
                    </h:panelGroup>
                </a4j:form>
            </rich:modalPanel>
            <rich:modalPanel id="panelCambiarProveedor" minHeight="140"  minWidth="600"
                                     height="140" width="600"
                                     zindex="4"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="<center>Asociar Proveedor</center>" escape="false"/>
                        </f:facet>
                        <a4j:form id="formRegistrar">
                        <h:panelGroup id="contenidoCambiarProveedor">
                            <div align="center">
                            <h:panelGrid columns="3">
                                <h:outputText value="Nuevo Proveedor" styleClass="outputTextBold" />
                                <h:outputText value="::" styleClass="outputTextBold" />
                                <h:selectOneMenu value="#{ManagedProgramaProduccionSolicitudCompra.programaProduccionPeriodoSolicitudCompraCambioProveedor.proveedores.codProveedor}" styleClass="inputText"
                                                 style="width:30em">
                                    <f:selectItems value="#{ManagedProgramaProduccionSolicitudCompra.proveedoresSelectList}"/>
                                </h:selectOneMenu>
                                <h:outputText value="Material" styleClass="outputTextBold" />
                                <h:outputText value="::" styleClass="outputTextBold" />
                                <h:outputText value="#{ManagedProgramaProduccionSolicitudCompra.programaProduccionPeriodoSolicitudCompraDetalleCambioProveedor.materiales.nombreMaterial}" styleClass="outputText2"/>
                                

                            </h:panelGrid>
                                
                                    <a4j:commandButton styleClass="btn" action="#{ManagedProgramaProduccionSolicitudCompra.guardarProgramaProduccionPeriodoSolicitudCompraDetalleCambioProveedor_action}" value="Guardar"
                                                       oncomplete="if(#{ManagedProgramaProduccionSolicitudCompra.mensaje eq '1'}){alert('Se registro la asociación del proveedor');Richfaces.hideModalPanel('panelCambiarProveedor');}else{alert('#{ManagedProgramaProduccionSolicitudCompra.mensaje}')}"
                                                       reRender="dataSolicitudCompraDetalle"/>
                                    <input type="button" value="Cancelar" onclick="Richfaces.hideModalPanel('panelCambiarProveedor')" class="btn" />
                                </div>
                        </h:panelGroup>
                        </a4j:form>
            </rich:modalPanel>
            
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

