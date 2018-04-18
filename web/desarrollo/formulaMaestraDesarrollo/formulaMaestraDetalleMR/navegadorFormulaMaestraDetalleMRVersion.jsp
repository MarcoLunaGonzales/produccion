<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>

<f:view>
    
    <html>

        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../../../css/ventas.css" />
            <script type="text/javascript" src="../../../js/general.js" ></script>
            <script>
                function eliminarMaterial(nombreTabla,soloUno)
                {
                    var tabla=document.getElementById(nombreTabla);
                    var contSelect=0;
                    for(var i=1;i<tabla.rows.length;i++)
                    {
                        if(tabla.rows[i].cells.length>2&&tabla.rows[i].cells[0].getElementsByTagName('input')[0].checked)
                        {
                            contSelect++;
                        }
                    }
                    if(contSelect==0)
                    {
                        alert('Debe seleccionar al menos un registro');
                        return false;
                    }
                    if(contSelect>1&&soloUno)
                    {
                        alert('Solo puede seleccionar un registro');
                        return false;
                    }
                    return true;
                }
            </script>
        </head>
        <body >
            <h:form id="form1">
                <center>
                <h:outputText value="#{ManagedProductosDesarrolloVersion.cargarFormulaMaestraDetalleMrList}"/>
                    <rich:panel headerClass="headerClassACliente" style="width:50%;margin-top:0.3em">
                        <f:facet name="header">
                            <h:outputText value="Datos De La Formula"/>
                        </f:facet>
                        <h:panelGrid columns="3" style="width:auto">
                            <h:outputText value="Producto" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="#{ManagedProductosDesarrolloVersion.formulaMaestraVersionSeleccionado.componentesProd.nombreProdSemiterminado}" styleClass="outputText2" />
                            <h:outputText value="Nro Versión" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="#{ManagedProductosDesarrolloVersion.formulaMaestraVersionSeleccionado.componentesProd.nroVersion}" styleClass="outputText2" />
                            <h:outputText value="Tamaño Lote" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="#{ManagedProductosDesarrolloVersion.formulaMaestraVersionSeleccionado.componentesProd.tamanioLoteProduccion}" styleClass="outputText2" />
                            
                            <h:outputText value="Tipo Material Reactivo" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <h:selectOneMenu value="#{ManagedProductosDesarrolloVersion.codTipoMaterialReactivo}" styleClass="inputText">
                                <f:selectItems value="#{ManagedProductosDesarrolloVersion.tiposMaterialReactivoSelectList}"/>
                                <a4j:support event="onchange" action="#{ManagedProductosDesarrolloVersion.codTipoMaterialReactivoChange()}" reRender="dataMaterialReactivo"/>
                            </h:selectOneMenu>
                        </h:panelGrid>
                    </rich:panel>
                    
                        
                    
                    
                    <rich:dataTable value="#{ManagedProductosDesarrolloVersion.formulaMaestraDetalleMRList}"
                                    var="data"
                                    id="dataMaterialReactivo"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente" style="margin-top:12px;"
                                    >
                                <f:facet name="header">
                                     <rich:columnGroup>
                                         <rich:column>
                                             <h:selectBooleanCheckbox onclick="seleccionarTodosCheckBox(this)"/>
                                         </rich:column>
                                         <rich:column>
                                             <h:outputText value="Material"  />
                                         </rich:column>
                                         <rich:column>
                                             <h:outputText value="Cantidad"  />
                                         </rich:column>
                                         <rich:column>
                                             <h:outputText value="Unidad Medida"  />
                                         </rich:column>
                                         <rich:column colspan="1">
                                             <h:outputText value="Estado Material"  />
                                         </rich:column>
                                         <rich:column colspan="2">
                                             <h:outputText value=""  />
                                         </rich:column>
                                     </rich:columnGroup>
                                 </f:facet>

                                <rich:subTable value="#{data.tiposAnalisisMaterialReactivoList1}" var="subData" rowKeyVar="row">
                                    <rich:column rowspan="#{data.cantidadDetalle}" rendered="#{row eq 0}">
                                            <h:selectBooleanCheckbox value="#{data.checked}"></h:selectBooleanCheckbox>
                                    </rich:column>
                                    <rich:column rowspan="#{data.cantidadDetalle}" rendered="#{row eq 0}">
                                        <h:outputText value="#{data.materiales.nombreMaterial}" />
                                    </rich:column>
                                     <rich:column rowspan="#{data.cantidadDetalle}" rendered="#{row eq 0}">
                                        <h:outputText  value="#{data.cantidad}" />
                                    </rich:column>
                                    <rich:column rowspan="#{data.cantidadDetalle}" rendered="#{row eq 0}">
                                        <h:outputText value="#{data.unidadesMedida.abreviatura}" />
                                    </rich:column>

                                    <rich:column rowspan="#{data.cantidadDetalle}" rendered="#{row eq 0}">
                                        <h:outputText  value="#{data.materiales.estadoRegistro.nombreEstadoRegistro}" />
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="#{subData.checked ? 'SI':'NO'}" />
                                    </rich:column>
                                    <rich:column>
                                         <h:outputText value="#{subData.nombreTiposAnalisisMaterialReactivo}">
                                         </h:outputText>
                                    </rich:column>
                                </rich:subTable>
                    </rich:dataTable>
                    <div id="bottonesAcccion" class="barraBotones">
                        <a4j:commandButton value="Agregar" styleClass="btn" oncomplete="redireccionar('agregarFormulaMaestraDetalleMRVersion.jsf')"/>
                        <a4j:commandButton value="Editar" styleClass="btn" 
                                           onclick="if(!editarVariosItems('form1:dataMaterialReactivo')){return false;}"
                                           action="#{ManagedProductosDesarrolloVersion.seleccionarEditarFormulaMaestraDetalleMrAction()}"
                                           oncomplete="redireccionar('editarFormulaMaestraDetalleMRVersion.jsf')"/>
                        <a4j:commandButton value="Eliminar" styleClass="btn" 
                                           action="#{ManagedProductosDesarrolloVersion.eliminarFormulaMaestraDetalleMRVersionAction()}"
                                           onclick="if(!editarVariosItems('form1:dataMaterialReactivo')){return false;}"
                                           reRender="dataMaterialReactivo"
                                           oncomplete="if(#{ManagedProductosDesarrolloVersion.mensaje eq '1'}){alert('Se eliminaron los items seleccionados')}else{alert('#{ManagedProductosDesarrolloVersion.mensaje}')}"/>
                        <a4j:commandButton value="Volver"  styleClass="btn"  oncomplete="redireccionar('../../navegadorProductosDesarrolloEnsayos.jsf')"/>
                    </div>
                </center>
            </h:form>
            <a4j:include viewId="/panelProgreso.jsp"/>
        </body>
    </html>
    
</f:view>

