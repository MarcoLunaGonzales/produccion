<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>
<f:view>
    
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../../../css/ventas.css" />
            <script type="text/javascript" src="../../../js/general.js" ></script> 
            <script>
                function retornarNavegadorFm(codTipoModificacionProducto)
                {
                    var url="";
                    switch(codTipoModificacionProducto)
                    {
                        case 1:
                        {
                            url="navegadorNuevosComponentesProd";
                            break;
                        }
                        case 2:
                        {
                            url="navegadorNuevosTamaniosLote";
                            break;
                        }
                        case 3:
                        {
                            url="navegadorComponentesProdVersion";
                            break;
                        }
                    }
                    window.location.href="../../componentesProdVersion/"+url+".jsf?fm="+(new Date()).getTime().toString();
                }
            </script>
            
        </head>
        <body>
            <h:form id="form1">
                
                <div align="center">
                    <span class="outputTextTituloSistema">Presentaciones y Materiales de Empaque Secundario</span>
                    <h:outputText value="#{ManagedProductosDesarrolloVersion.cargarComponentesPresProdFormulaMaestraDetaleEs}"   />
                    <rich:panel headerClass="headerClassACliente" style="width:50%;margin-top:0.3em">
                        <f:facet name="header">
                            <h:outputText value="Datos Del Producto"/>
                        </f:facet>
                        <h:panelGrid columns="3" style="width:auto">
                            <h:outputText value="Producto" styleClass="outputTextBold" />
                            <h:outputText value="::" styleClass="outputTextBold" />
                            <h:outputText value="#{ManagedProductosDesarrolloVersion.formulaMaestraEsVersionSeleccionado.componentesProdVersion.nombreProdSemiterminado}" styleClass="outputText2" />
                            <h:outputText value="Tamaño Lote" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold" />
                            <h:outputText value="#{ManagedProductosDesarrolloVersion.formulaMaestraEsVersionSeleccionado.componentesProdVersion.tamanioLoteProduccion}" styleClass="outputText2" />
                        </h:panelGrid>
                    </rich:panel>
                    <rich:dataTable value="#{ManagedProductosDesarrolloVersion.componentesPresProdList}" var="data" 
                                    id="dataPresentaciones" style="margin-top:0.5em"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#CCDFFA';" 
                                    headerClass="headerClassACliente">
                        <f:facet name="header">
                            <rich:columnGroup>
                                <rich:column rowspan="2">
                                    <h:outputText value="Presentacion Producto"  />
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Tipo Programa Producción"  />
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Estado"/>
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Cantidad"/>
                                </rich:column>
                                <rich:column colspan="4">
                                    <h:outputText value="Empaque Secundario"/>
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Acciones"/>
                                </rich:column>
                                <rich:column breakBefore="true">
                                    <h:outputText value="Material"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Cantidad"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Unidad Medida"/>
                                </rich:column>
                                <rich:column rendered="#{ManagedProductosDesarrolloVersion.defineLoteEs}">
                                    <h:outputText value="DEFINE NRO DE LOTE"/>
                                </rich:column>
                            </rich:columnGroup>
                        </f:facet>
                            <rich:subTable value="#{data.formulaMaestraDetalleESList}" var="subData" rowKeyVar="key">
                                <rich:column rendered="#{key eq 0}" rowspan="#{data.formulaMaestraDetalleESListSize}">
                                    <h:outputText value="#{data.presentacionesProducto.nombreProductoPresentacion}" />
                                </rich:column>
                                <rich:column rendered="#{key eq 0}" rowspan="#{data.formulaMaestraDetalleESListSize}">
                                    <h:outputText value="#{data.tiposProgramaProduccion.nombreTipoProgramaProd}" />
                                </rich:column>
                                <rich:column rendered="#{key eq 0}" rowspan="#{data.formulaMaestraDetalleESListSize}">
                                    <h:outputText value="#{data.estadoReferencial.nombreEstadoRegistro}" />
                                </rich:column>
                                <rich:column rendered="#{key eq 0}" rowspan="#{data.formulaMaestraDetalleESListSize}">
                                    <h:outputText value="#{data.cantCompProd}" />
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="#{subData.materiales.nombreMaterial}"/>
                                </rich:column>
                                <rich:column styleClass="tdRight">
                                    <h:outputText value="#{subData.cantidad}">
                                        <f:convertNumber locale="en" pattern="#,##0.00"/>
                                    </h:outputText>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="#{subData.unidadesMedida.nombreUnidadMedida}"/>
                                </rich:column>
                                <rich:column rendered="#{ManagedProductosDesarrolloVersion.defineLoteEs}" 
                                            styleClass="#{subData.defineNumeroLote ? 'fondoVerde' : ''}">
                                   <h:outputText value="#{subData.defineNumeroLote ? 'SI' : 'NO'}"/>
                               </rich:column>
                                <rich:column rendered="#{key eq 0}" rowspan="#{data.formulaMaestraDetalleESListSize}">
                                    <rich:dropDownMenu >
                                        <f:facet name="label">
                                            <h:panelGroup>
                                                <h:outputText value="Acciones"/>
                                                <h:outputText styleClass="icon-menu3"/>
                                            </h:panelGroup>
                                        </f:facet>
                                        <rich:menuItem  submitMode="none" iconClass="icon-minus" value="Editar">
                                            <a4j:support event="onclick" 
                                                         oncomplete="redireccionar('editarFormulaMaestraDetalleEsVersion.jsf')" >
                                                <f:setPropertyActionListener target="#{ManagedProductosDesarrolloVersion.componentesPresProdVersion}" value="#{data}"/>
                                            </a4j:support>
                                        </rich:menuItem>
                                        <rich:menuItem  submitMode="none" iconClass="icon-minus" value="Eliminar">
                                            <a4j:support event="onclick" 
                                                         reRender="dataPresentaciones"
                                                         action="#{ManagedProductosDesarrolloVersion.eliminarComponentesPresProdVersionAction()}"
                                                         oncomplete="if(#{ManagedProductosDesarrolloVersion.mensaje eq '1'}){alert('Se elimino la presentación primaria');}else{alert('#{ManagedProductosDesarrolloVersion.mensaje}');}" >
                                                <f:setPropertyActionListener target="#{ManagedProductosDesarrolloVersion.componentesPresProdVersion}" value="#{data}"/>
                                            </a4j:support>
                                        </rich:menuItem>
                                    </rich:dropDownMenu>
                                </rich:column>
                            </rich:subTable>
                        <rich:column colspan="10" styleClass="separador">
                        </rich:column>
                    </rich:dataTable>
                    
                    <div id="bottonesAcccion" class="barraBotones" >
                        <a4j:commandButton value="Agregar" styleClass="btn" oncomplete="redireccionar('agregarFormulaMaestraDetalleEsVersion.jsf')"/>
                        <a4j:commandButton value="Volver" styleClass="btn" oncomplete="redireccionar('../../navegadorProductosDesarrolloEnsayos.jsf')"/>
                    </div>
                    
                </div>
                
                
            </h:form>
            <a4j:include viewId="/panelProgreso.jsp" />
        </body>
    </html>
    
</f:view>

