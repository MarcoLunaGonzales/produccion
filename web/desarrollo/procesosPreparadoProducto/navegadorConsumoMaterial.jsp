<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>

    <link rel="STYLESHEET" type="text/css" href="../../css/icons.css" />
    <style type="text/css">
        .noValido{
            border:1px solid #ffcfb1;
            background-color:#fbe0cf;
            border-collapse: collapse;
        }
        .materialTransitorio
        {
            background-color: #fbf8c9;
            border:1px solid #ffcfb1;
        }
    </style>
    <rich:modalPanel id="panelMostrarConsumoMaterial" minHeight="320"  minWidth="720"
                            height="430" width="720"
                            zindex="50"
                            headerClass="headerClassACliente"
                            resizeable="false">
               <f:facet name="header">
                   <h:outputText value="<center>Consumo de material por proceso</center>" escape="false"/>
               </f:facet>
               <a4j:form id="formContenidoEspMat">
               <h:panelGroup id="contenidoMostrarConsumoMaterial">
                   <rich:panel headerClass="headerClassACliente">
                       <f:facet name="header">
                           <h:outputText value="<center>Datos del Proceso</center>" escape="false"/>
                       </f:facet>
                       <center>
                           <h:panelGrid columns="6">
                               <h:outputText styleClass="outputTextBold" value="Nro. Paso"/>
                               <h:outputText styleClass="outputTextBold" value="::"/>
                               <h:outputText styleClass="outputText2" value="#{ManagedProductosDesarrolloVersion.procesosPreparadoProducto.procesosPreparadoProductoPadre.nroPaso}.#{ManagedProductosDesarrolloVersion.procesosPreparadoProducto.nroPaso}"/>
                               <h:outputText styleClass="outputTextBold" value="Actividad"/>
                               <h:outputText styleClass="outputTextBold" value="::"/>
                               <h:outputText styleClass="outputText2" value="#{ManagedProductosDesarrolloVersion.procesosPreparadoProducto.actividadesPreparado.nombreActividadPreparado}"/>
                               <h:outputText styleClass="outputTextBold" value="Combinación Resultante" rendered="#{ManagedProductosDesarrolloVersion.sustanciaResultanteHabilitada}"/>
                               <h:outputText styleClass="outputTextBold" value="::" rendered="#{ManagedProductosDesarrolloVersion.sustanciaResultanteHabilitada}"/>
                               <h:inputText styleClass="inputText" value="#{ManagedProductosDesarrolloVersion.procesosPreparadoProducto.sustanciaResultante}" rendered="#{ManagedProductosDesarrolloVersion.sustanciaResultanteHabilitada}"/>
                           </h:panelGrid>
                       </center>
                   </rich:panel>

                   <center>
                       
                       <table width="100%">
                           <tr>
                               <td>
                                    <span class="outputTextBold">No Disponible Para Consumo</span>
                               </td>
                               <td class="noValido" style='width:4rem;'>
                                    &nbsp;
                               </td>
                               <td style='width:5%'></td>
                               <td>
                                   <span class="outputTextBold">Material Transitorio</span>
                               </td>
                                <td class="materialTransitorio" style='width:4rem;'>&nbsp;</td>
                                <td style='width:5%'></td>
                           </tr>
                           <tr>
                                <td colspan="3" style="width:50%">
                                    <div style="height:200px;overflow-y:auto;width:auto">
                                        <rich:dataTable value="#{ManagedProductosDesarrolloVersion.procesosPreparadoProductoConsumoDisponibleList}"
                                            var="data" id="dataProcesosProducto" style="top:0px"
                                            headerClass="headerClassACliente"
                                            columnClasses="tituloCampo">
                                            <f:facet name="header">
                                                <rich:columnGroup>
                                                    <rich:column colspan="4">
                                                        <h:outputText value="Material No Utilizado en el Proceso"/>
                                                    </rich:column>
                                                    <rich:column breakBefore="true">
                                                        <h:outputText value="Material<br>Consumible" escape="false"/>
                                                    </rich:column>
                                                    <rich:column>
                                                        <h:outputText value="Material"/>
                                                    </rich:column>
                                                    <rich:column>
                                                        <h:outputText value="Cantidad (g)"/>
                                                    </rich:column>
                                                    <rich:column>
                                                        <h:outputText value="Material<br>Transitorio" escape="false"/>
                                                    </rich:column>
                                                </rich:columnGroup>
                                            </f:facet>
                                            <rich:columnGroup styleClass="#{data.procesosPreparadoProducto.nroPaso eq 0?'':'noValido'}">
                                                <rich:column style="text-align:center">
                                                    <a4j:commandLink styleClass="btn"  reRender="contenidoMostrarConsumoMaterial"
                                                                     rendered="#{data.procesosPreparadoProducto.nroPaso eq 0}"
                                                                     action="#{ManagedProductosDesarrolloVersion.agregarProcesoPreparadoProductoConsumoMaterialSeleccionado(data,false)}">
                                                        <h:outputText styleClass="icon-checkmark"/>
                                                    </a4j:commandLink>
                                                    <h:outputText value="#{data.procesosPreparadoProducto.procesosPreparadoProductoPadre.nroPaso}." rendered="#{data.procesosPreparadoProducto.procesosPreparadoProductoPadre.nroPaso>0}"/>
                                                    <h:outputText value="#{data.procesosPreparadoProducto.nroPaso}" rendered="#{data.procesosPreparadoProducto.nroPaso>0}"/>
                                                    <h:outputText value="<br>(#{data.procesosPreparadoProducto.actividadesPreparado.nombreActividadPreparado})" rendered="#{data.procesosPreparadoProducto.nroPaso>0}"
                                                                  escape="false"/>
                                                </rich:column>
                                                <rich:column>
                                                    <h:outputText value="#{data.procesosPreparadoConsumoMaterialFm.formulaMaestraDetalleMPfracciones.materiales.nombreMaterial}"/>
                                                    <h:outputText value="<br/>(#{data.procesosPreparadoConsumoMaterialFm.formulaMaestraDetalleMPfracciones.tiposMaterialProduccion.nombreTipoMaterialProduccion})" styleClass="fondoVerde" escape="false"
                                                                      rendered="#{data.procesosPreparadoConsumoMaterialFm.formulaMaestraDetalleMPfracciones.tiposMaterialProduccion.codTipoMaterialProduccion>1}"/>
                                                    <h:outputText value="#{data.procesosPreparadoProductoConsumoProceso.procesosPreparadoProducto.sustanciaResultante}"/>
                                                </rich:column>
                                                <rich:column>
                                                    <h:outputText value="#{data.procesosPreparadoConsumoMaterialFm.formulaMaestraDetalleMPfracciones.cantidad}">
                                                        <f:convertNumber pattern="##0.00" locale="en"/>
                                                    </h:outputText>
                                                </rich:column>
                                                <rich:column>
                                                    <a4j:commandLink styleClass="btn" reRender="contenidoMostrarConsumoMaterial"
                                                                     rendered="#{data.checked}"
                                                                     action="#{ManagedProductosDesarrolloVersion.agregarProcesoPreparadoProductoConsumoMaterialSeleccionado(data,true)}">
                                                        <h:outputText styleClass="icon-checkmark"/>
                                                    </a4j:commandLink>
                                                </rich:column>
                                            </rich:columnGroup>
                                        </rich:dataTable>
                                    </div>
                                </td>
                                <td colspan="3" style="width:50%">
                                    <div style="height:200px;overflow-y:auto;width:auto">
                                        <rich:dataTable value="#{ManagedProductosDesarrolloVersion.procesosPreparadoProducto.procesosPreparadoProductoConsumoList}"
                                                         var="data" id="dataProcesosProductoSelecccionado" style="top:0px" rowKeyVar="index"
                                                     headerClass="headerClassACliente"
                                                     columnClasses="tituloCampo">
                                                 <f:facet name="header">
                                                     <rich:columnGroup>
                                                         <rich:column colspan="5">
                                                             <h:outputText value="Materiales del proceso"/>
                                                         </rich:column>
                                                         <rich:column breakBefore="true">
                                                             <h:outputText value="Material" escape="false"/>
                                                             
                                                         </rich:column>
                                                         <rich:column>
                                                             <h:outputText value="Cantidad(g)"/>
                                                         </rich:column>
                                                         <rich:column>
                                                             <h:outputText value="M.T." title="Material Transitorio"/>
                                                         </rich:column>
                                                         <rich:column>
                                                             <h:outputText value="Cambiar<br/>Orden" escape="false"/>
                                                         </rich:column>
                                                         <rich:column>
                                                             <h:outputText value="Eliminar"/>
                                                         </rich:column>
                                                     </rich:columnGroup>
                                                 </f:facet>
                                                <rich:columnGroup styleClass="#{data.materialTransitorio?'materialTransitorio':''}">
                                                   <rich:column>
                                                        <h:outputText value="#{data.procesosPreparadoConsumoMaterialFm.formulaMaestraDetalleMPfracciones.materiales.nombreMaterial}"
                                                                      rendered="#{data.procesosPreparadoConsumoMaterialFm!=null}"/>
                                                        <h:outputText value="<br/>(#{data.procesosPreparadoConsumoMaterialFm.formulaMaestraDetalleMPfracciones.tiposMaterialProduccion.nombreTipoMaterialProduccion})" styleClass="fondoVerde" escape="false"
                                                                      rendered="#{data.procesosPreparadoConsumoMaterialFm.formulaMaestraDetalleMPfracciones.tiposMaterialProduccion.codTipoMaterialProduccion>1}"/>
                                                        <h:outputText value="#{data.procesosPreparadoProductoConsumoProceso.procesosPreparadoProducto.sustanciaResultante}"/>
                                                        
                                                   </rich:column>
                                                    <rich:column>
                                                        <h:outputText value="#{data.procesosPreparadoConsumoMaterialFm.formulaMaestraDetalleMPfracciones.cantidad}">
                                                            <f:convertNumber pattern="##0.00" locale="en"/>
                                                        </h:outputText>
                                                    </rich:column>
                                                   <rich:column>
                                                       <h:outputText value="#{data.materialTransitorio?'SI':'NO'}"/>
                                                   </rich:column>
                                                   <rich:column>
                                                       <a4j:commandLink styleClass="btn" reRender="dataProcesosProductoSelecccionado" rendered="#{index>0}"
                                                                        action="#{ManagedProductosDesarrolloVersion.adicionarOrdenConsumoMaterialSeleccionado(index, -1)}">
                                                           <h:outputText styleClass="icon-arrow-up"/>
                                                       </a4j:commandLink>
                                                       <a4j:commandLink styleClass="btn" reRender="dataProcesosProductoSelecccionado" rendered="#{(index+1) ne ManagedProductosDesarrolloVersion.procesosPreparadoProducto.procesosPreparadoProductoConsumoList.size()}"
                                                                         action="#{ManagedProductosDesarrolloVersion.adicionarOrdenConsumoMaterialSeleccionado(index,1)}">
                                                           <h:outputText styleClass="icon-arrow-down"/>
                                                       </a4j:commandLink>
                                                   </rich:column>
                                                    <rich:column>
                                                        <a4j:commandLink styleClass="btn" reRender="contenidoMostrarConsumoMaterial"
                                                                         action="#{ManagedProductosDesarrolloVersion.eliminarProcesoPreparadoProductoConsumoMaterialSeleccionado(data)}">
                                                            <h:outputText styleClass="icon-cross"/>
                                                        </a4j:commandLink>
                                                    </rich:column>
                                                </rich:columnGroup>
                                            </rich:dataTable>
                                   </div>
                                </td>
                            </tr>
                       </table>
                    </center>
                    <br/>
                    <div align="center">
                        <a4j:commandLink styleClass="btn"  action="#{ManagedProductosDesarrolloVersion.guardarProcesoPreparadoProductoConsumoAction}"
                                         reRender="form1"
                                         oncomplete="mostrarMensajeTransaccionEvento(function(){Richfaces.hideModalPanel('panelMostrarConsumoMaterial');})">
                             <h:outputText styleClass="icon-floppy-disk"/>
                             <h:outputText value="Guardar"/>
                        </a4j:commandLink>
                         <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('panelMostrarConsumoMaterial')" class="btn" />
                    </div>
               </h:panelGroup>
               </a4j:form>
    </rich:modalPanel>


