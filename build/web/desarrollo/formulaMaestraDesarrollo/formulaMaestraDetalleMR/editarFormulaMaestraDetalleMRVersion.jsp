<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../../../css/ventas.css" />
            <script src="../../../js/general.js"></script>
            
        </head>
        <body>
            <h:form id="form1"  >
                
                <br>
                
                <div align="center">
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
                            
                        </h:panelGrid>
                    </rich:panel>
                    <rich:dataTable value="#{ManagedProductosDesarrolloVersion.formulaMaestraDetalleMREditarList}"
                                    var="data" id="dataMaterialesMR"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#CCDFFA';" 
                                    headerClass="headerClassACliente" style="margin-top:0.5em">
                        
                        <h:column >
                            <f:facet name="header">
                                <h:outputText value="Materia Prima"  />
                            </f:facet>
                            <h:outputText value="#{data.materiales.nombreMaterial}" />
                        </h:column>
                        <h:column >
                            <f:facet name="header">
                                <h:outputText value="Cantidad"  />
                            </f:facet>
                            <h:inputText value="#{data.cantidad}" onblur="valorPorDefecto(this);validarMayorIgualACero(this);" onkeypress="valNum();" styleClass="inputText" />
                        </h:column>
                        <h:column >
                            <f:facet name="header">
                                <h:outputText value="Unidad Medida"  />
                            </f:facet>
                            <h:outputText value="#{data.unidadesMedida.nombreUnidadMedida}" />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Tipo de Material Reactivo"  />
                            </f:facet>
                            <h:selectOneMenu value="#{data.tiposMaterialReactivo.codTipoMaterialReactivo}" styleClass="inputText" >
                                <f:selectItems value="#{ManagedProductosDesarrolloVersion.tiposMaterialReactivoSelectList}" />
                            </h:selectOneMenu>
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Disolucion"  />
                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.tiposAnalisisMaterialReactivoList1[0].checked}"/>
                        </h:column>
                         <h:column>
                            <f:facet name="header">
                                <h:outputText value="Valoracion"  />
                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.tiposAnalisisMaterialReactivoList1[1].checked}"/>
                        </h:column>
                    </rich:dataTable>
                    <br>
                    <div id="bottonesAcccion" class="barraBotones">
                        <a4j:commandButton value="Guardar"   styleClass="btn"  
                                           action="#{ManagedProductosDesarrolloVersion.editarFormulaMaestraDetalleMrVersionAction()}"
                                            oncomplete="if(#{ManagedProductosDesarrolloVersion.mensaje eq '1'}){alert('Se guardo la edicion de los materiales');redireccionar('navegadorFormulaMaestraDetalleMRVersion.jsf');}
                                                        else{alert('#{ManagedProductosDesarrolloVersion.mensaje}');}"/>
                        <a4j:commandButton value="Cancelar"    styleClass="btn"  oncomplete="redireccionar('navegadorFormulaMaestraDetalleMRVersion.jsf')"/>
                    </div>
                    
                </div>
                
            </h:form>
            <a4j:include viewId="/panelProgreso.jsp"/>
        </body>
    </html>
    
</f:view>

