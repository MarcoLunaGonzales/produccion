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

            <script>
                function componentes(obj){
                    var codpresentacion=obj.getElementsByTagName('td')[0].lastChild.value;
                    var url='presentacionescomponentes.jsf?codpresentacion='+codpresentacion;
                    window.open(url,'DETALLE','width=700,height=400,scrollbars=1,resizable=1');
                }
            </script>
        </head>
        <body >
            <h:form >
                <div align="center">
                    <h:outputText value="#{ManagedPresentacionesProducto.cargarProductosPresentaciones}"  />
                    <rich:panel headerClass="headerClassACliente">
                        <f:facet name="header">
                            <h:outputText value="Presentaciones Producto"/>
                        </f:facet>
                        <h:panelGrid columns="6">
                            <h:outputText value="Presentación" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:inputText value="#{ManagedPresentacionesProducto.presentacionesProductoBuscar.nombreProductoPresentacion}" styleClass="inputText" style="width:200px"/>
                            <h:outputText value="Código" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:inputText value="#{ManagedPresentacionesProducto.presentacionesProductoBuscar.codAnterior}" styleClass="inputText" style="width:200px"/>
                            <h:outputText value="Cantidad Presentación" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:inputText value="#{ManagedPresentacionesProducto.presentacionesProductoBuscar.cantidadPresentacion}" styleClass="inputText" style="width:200px"/>
                            <h:outputText value="Nombre Comercial" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectOneMenu value="#{ManagedPresentacionesProducto.presentacionesProductoBuscar.producto.codProducto}" styleClass="inputText">
                                <f:selectItem itemLabel="--TODOS--" itemValue="0"/>
                                <f:selectItems value="#{ManagedPresentacionesProducto.productosSelectList}"/>
                            </h:selectOneMenu>
                            <h:outputText value="Tipo Mercaderia" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectOneMenu value="#{ManagedPresentacionesProducto.presentacionesProductoBuscar.tiposMercaderia.codTipoMercaderia}" styleClass="inputText">
                                <f:selectItem itemLabel="--TODOS--" itemValue="0"/>
                                <f:selectItems value="#{ManagedPresentacionesProducto.tiposMercaderiaSelectList}"/>
                            </h:selectOneMenu>
                            <h:outputText value="Linea" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectOneMenu value="#{ManagedPresentacionesProducto.presentacionesProductoBuscar.lineaMKT.codLineaMKT}" styleClass="inputText">
                                <f:selectItem itemLabel="--TODOS--" itemValue="0"/>
                                <f:selectItems value="#{ManagedPresentacionesProducto.lineasMKTSelectList}"/>
                            </h:selectOneMenu>
                            <h:outputText value="Tipo Programa Producción" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectOneMenu value="#{ManagedPresentacionesProducto.presentacionesProductoBuscar.tiposProgramaProduccion.codTipoProgramaProd}" styleClass="inputText">
                                <f:selectItem itemLabel="--TODOS--" itemValue="0"/>
                                <f:selectItems value="#{ManagedPresentacionesProducto.tiposProgramaProduccionSelectList}"/>
                            </h:selectOneMenu>
                            <h:outputText value="Estado" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectOneMenu value="#{ManagedPresentacionesProducto.presentacionesProductoBuscar.estadoReferencial.codEstadoRegistro}" styleClass="inputText">
                                <f:selectItem itemLabel="--TODOS--" itemValue="0"/>
                                <f:selectItems value="#{ManagedPresentacionesProducto.estadosPresentacionesProductoSelectList}"/>
                            </h:selectOneMenu>
                        </h:panelGrid>
                        <a4j:commandButton value="BUSCAR" styleClass="btn" action="#{ManagedPresentacionesProducto.buscarPresentacionesProducto_action}"
                        reRender="dataPresentacionProducto,controles"/>
                    </rich:panel>
                    <rich:dataTable value="#{ManagedPresentacionesProducto.presentacionesProductoList}" var="data"
                                    id="dataPresentacionProducto" style="margin-top:1em;"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#CCDFFA';" 
                                    headerClass="headerClassACliente"
                                    columnClasses="tituloCampo"  
                                  >
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value=""  />
                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.checked}"  />
                            
                        </rich:column>
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Presentación"  />
                            </f:facet>
                            <h:outputText value="#{data.nombreProductoPresentacion}"  id="nombreProductoPresentacion" />
                        </rich:column>
 
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Nombre Comercial"  />
                            </f:facet>
                            <h:outputText value="#{data.producto.nombreProducto}"  />
                        </rich:column>
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Tipo de Mercaderia"  />
                            </f:facet>
                            <h:outputText value="#{data.tiposMercaderia.nombreTipoMercaderia}"  />
                        </rich:column>
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Cantidad<br>Presentación" escape="false"  />
                            </f:facet>
                            <h:outputText value="#{data.cantidadPresentacion}"  />
                        </rich:column>
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Línea"  />
                            </f:facet>
                            <h:outputText value="#{data.lineaMKT.nombreLineaMKT}"  />
                        </rich:column>
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Categoria"  />
                            </f:facet>
                            <h:outputText value="#{data.categoriasProducto.nombreCategoria}"  />
                        </rich:column>  
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Código Alfanumérico"  />
                            </f:facet>
                            <h:outputText value="#{data.codAnterior}"  />
                        </rich:column>
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value="Estado"  />
                            </f:facet>
                            <h:outputText value="#{data.estadoReferencial.nombreEstadoRegistro}"  />
                        </rich:column>
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value="Tipo Programa Produccion"  />
                            </f:facet>
                            <h:outputText value="#{data.tiposProgramaProduccion.nombreTipoProgramaProd}"  />
                        </rich:column>
                    </rich:dataTable>
                    <h:panelGrid columns="2"  width="50" id="controles">
                        <a4j:commandLink  action="#{ManagedPresentacionesProducto.anteriorPaginaAction}"  reRender="dataPresentacionProducto,controles"
                        rendered="#{ManagedPresentacionesProducto.begin>1}">
                                <h:graphicImage url="../img/previous.gif"  style="border:0px solid red"   alt="PAGINA ANTERIOR"  />
                                <h:outputText value="Anterior"/>
                        </a4j:commandLink>
                        <a4j:commandLink value="Siguiente" action="#{ManagedPresentacionesProducto.siguientePaginaAction}" reRender="dataPresentacionProducto,controles"
                        rendered="#{ManagedPresentacionesProducto.cantidadfilas>19}">
                                <h:graphicImage url="../img/next.gif"  style="border:0px solid red"  alt="PAGINA SIGUIENTE" />
                        </a4j:commandLink>
                    </h:panelGrid>
                    <div style="margin-top:1em">
                        <a4j:commandButton value="Agregar" styleClass="btn" oncomplete="window.location.href='agregarPresentacionesProducto.jsf?data='+(new Date()).getTime().toString()"/>
                        <a4j:commandButton value="Cambiar Estado" styleClass="btn" action="#{ManagedPresentacionesProducto.seleccionarPresentacionCambioEstado_action}"
                        oncomplete="Richfaces.showModalPanel('activarInactivarPresentacion');" reRender="contenidoActivarInactivar"/>
                    </div>
                </div>                               
                
                
            </h:form>
            <rich:modalPanel headerClass="headerClassACliente" id="activarInactivarPresentacion"
            width="450" height="200">
                    <f:facet name="header">
                        <h:outputText value="<center>Activar/Inactivar Presentaciones</center>"  escape="false" />
                    </f:facet>
                <h:panelGroup id="contenidoActivarInactivar">
                    <a4j:form>
                        <center>
                        <h:panelGrid columns="3">
                            <h:outputText value="Presentación" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:outputText value="#{ManagedPresentacionesProducto.presentacionesProductoEditar.nombreProductoPresentacion}" styleClass="outputText2"/>
                            <h:outputText value="Estado" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectOneMenu value="#{ManagedPresentacionesProducto.presentacionesProductoEditar.estadoReferencial.codEstadoRegistro}" styleClass="inputText">
                                <f:selectItems value="#{ManagedPresentacionesProducto.estadosPresentacionesProductoSelectList}"/>                   
                            </h:selectOneMenu>
                        </h:panelGrid>
                        <div style="margin-top:1em;">
                            <a4j:commandButton value="Guardar" action="#{ManagedPresentacionesProducto.guardarActivarInactivarPresentacion_action}" styleClass="btn"
                            oncomplete="if(#{ManagedPresentacionesProducto.mensaje eq '1'}){alert('Se guardo el cambio de estado');Richfaces.hideModalPanel('activarInactivarPresentacion')}else{alert('#{ManagedPresentacionesProducto.mensaje}')}"
                            reRender="dataPresentacionProducto"/>
                            <a4j:commandButton value="Cancelar" oncomplete="Richfaces.hideModalPanel('activarInactivarPresentacion');" styleClass="btn"/>
                        </div>
                        </center>
                    </a4j:form>
                    </h:panelGroup>
                    </rich:modalPanel>
                
            <a4j:status id="statusPeticion"
                                onstart="Richfaces.showModalPanel('ajaxLoadingModalBox',{width:100, top:100})"
                                onstop="Richfaces.hideModalPanel('ajaxLoadingModalBox')">
            </a4j:status>
            <rich:modalPanel id="ajaxLoadingModalBox" minHeight="100"
                                     minWidth="200" height="80" width="400" zindex="200" onshow="window.focus();">

                        <div align="center">
                            <h:graphicImage value="../img/load2.gif" />
                        </div>
           </rich:modalPanel>
            
        </body>
    </html>
    
</f:view>

