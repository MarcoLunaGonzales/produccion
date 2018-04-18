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
                    <h:outputText value="#{ManagedFormulaMaestraEsVersion.cargarComponentesPresProdFormulaMaestraDetalleEs}"   />
                    <rich:panel headerClass="headerClassACliente" style="width:50%;margin-top:0.3em">
                        <f:facet name="header">
                            <h:outputText value="Datos Del Producto"/>
                        </f:facet>
                        <h:panelGrid columns="3" style="width:auto">
                            <h:outputText value="Producto" styleClass="outputTextBold" />
                            <h:outputText value="::" styleClass="outputTextBold" />
                            <h:outputText value="#{ManagedFormulaMaestraEsVersion.componentesProdVersionBean.nombreProdSemiterminado}" styleClass="outputText2" />
                            <h:outputText value="Tamaño Lote" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold" />
                            <h:outputText value="#{ManagedFormulaMaestraEsVersion.componentesProdVersionBean.tamanioLoteProduccion}" styleClass="outputText2" />
                        </h:panelGrid>
                    </rich:panel>
                        <rich:dataTable value="#{ManagedFormulaMaestraEsVersion.componentesPresProdVersionList}" var="data" 
                                    id="dataPresentaciones" style="margin-top:0.5em"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#CCDFFA';" 
                                    headerClass="headerClassACliente">
                        <f:facet name="header">
                            <rich:columnGroup>
                                <rich:column rowspan="2">
                                    <h:outputText value=""  />
                                </rich:column>
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
                                <rich:column breakBefore="true">
                                    <h:outputText value="Material"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Cantidad"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Unidad Medida"/>
                                </rich:column>
                                <rich:column rendered="#{ManagedFormulaMaestraEsVersion.defineLoteEs}">
                                    <h:outputText value="DEFINE NRO DE LOTE"/>
                                </rich:column>
                            </rich:columnGroup>
                        </f:facet>
                        <rich:subTable value="#{data.formulaMaestraDetalleESList}" var="subData" rowKeyVar="key">
                            <rich:column rendered="#{key eq 0}" rowspan="#{data.formulaMaestraDetalleESListSize}">
                                <h:selectBooleanCheckbox value="#{data.checked}"/>
                            </rich:column>
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
                            <rich:column>
                                <h:outputText value="#{subData.cantidad}"/>
                            </rich:column>
                            <rich:column>
                                <h:outputText value="#{subData.unidadesMedida.nombreUnidadMedida}"/>
                            </rich:column>
                            <rich:column rendered="#{ManagedFormulaMaestraEsVersion.defineLoteEs}" 
                                         styleClass="#{subData.defineNumeroLote ? 'fondoVerde' : ''}">
                                <h:outputText value="#{subData.defineNumeroLote ? 'SI' : 'NO'}"/>
                            </rich:column>
                        </rich:subTable>
                        <rich:column colspan="9" styleClass="separador">
                        </rich:column>
                    </rich:dataTable>
                    
                    <br>
                    <a4j:commandButton value="Agregar" styleClass="btn" oncomplete="window.location.href='agregarFormulaMaestraDetalleEsVersion.jsf?data='+(new Date()).getTime().toString()"/>
                    <a4j:commandButton value="Editar" styleClass="btn" oncomplete="window.location.href='editarFormulaMaestraDetalleEsVersion.jsf?data='+(new Date()).getTime().toString()"
                                       action="#{ManagedFormulaMaestraEsVersion.editarComponentesPresProdVersion_action}"
                                       onclick="if(!editarItem('form1:dataPresentaciones')){return false;}"/>
                    <a4j:commandButton value="Eliminar" styleClass="btn" action="#{ManagedFormulaMaestraEsVersion.eliminarComponentesPresProdVersion_action}"
                                       onclick="if(!editarItem('form1:dataPresentaciones')){return false;}"
                                       oncomplete="if(#{ManagedFormulaMaestraEsVersion.mensaje eq '1'}){alert('Se elimino la presentación y materiales de empaque secundario para el producto');}
                                       else{alert('#{ManagedFormulaMaestraEsVersion.mensaje}');}" reRender="dataPresentaciones"/>
                    <a4j:commandButton  value="Volver" styleClass="btn" oncomplete="window.location.href='navegadorFormulaMaestraEsVersion.jsf?cancel='+(new Date()).getTime().toString();"/>
                    
                    
                </div>
                
                
            </h:form>
            <a4j:status id="statusPeticion"
                        onstart="Richfaces.showModalPanel('ajaxLoadingModalBox',{width:100, top:100})"
                        onstop="Richfaces.hideModalPanel('ajaxLoadingModalBox')">
            </a4j:status>

            <rich:modalPanel id="ajaxLoadingModalBox" minHeight="100"
                             minWidth="200" height="80" width="400" zindex="100" onshow="window.focus();">

                <div align="center">
                    <h:graphicImage value="../../img/load2.gif" />
                </div>
            </rich:modalPanel>
        </body>
    </html>
    
</f:view>

