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
                function tiposMaterialReactivo_change(){
                    //document.getElementById("form1:codTipoMaterialReactivo").selectedIndex=0;
                    document.getElementById("form1:nombreTipoMaterialReactivo").value =  document.getElementById('form1:codTipoMaterialReactivo')[document.getElementById('form1:codTipoMaterialReactivo').selectedIndex].innerHTML;
                    
                }
                function bodyLoad(){
                    tiposMaterialReactivo_change();
                }
            </script>
        </head>
        <body onload="bodyLoad()" >
            <h:form id="form1">
                
                <div align="center">
                    <h:outputText value="#{ManagedFormulaMaestraDetalleMP.obtenerCodigoReactivo}"   />
                    
                </div>
                <div align="center">
                    
                    Material Reactivo de: <h:outputText value="#{ManagedFormulaMaestraDetalleMP.nombreComProd}"  /><br/><br/>
                    Tipo Material Reactivo:
                    <h:selectOneMenu  value = "#{ManagedFormulaMaestraDetalleMP.formulaMaestraDetalleMP.tiposMaterialReactivo.codTipoMaterialReactivo}" styleClass="inputText" id="codTipoMaterialReactivo"
                                         >
                        <f:selectItems value = "#{ManagedFormulaMaestraDetalleMP.tiposMaterialReactivoList}" />
                        <a4j:support action="#{ManagedFormulaMaestraDetalleMP.tiposMaterial_change}" reRender="dataAreasDependientes" event="onchange" oncomplete="tiposMaterialReactivo_change()" />
                    </h:selectOneMenu>
                    
                   &nbsp; por: &nbsp;
                    <h:selectOneMenu  value = "#{ManagedFormulaMaestraDetalleMP.formulaMaestraDetalleMP.tiposAnalisisMaterialReactivo.codTiposAnalisisMaterialReactivo}" styleClass="inputText"
                                         >
                        <f:selectItems value = "#{ManagedFormulaMaestraDetalleMP.tiposAnalisisMaterialReactivo}" />
                        <a4j:support action="#{ManagedFormulaMaestraDetalleMP.tiposMaterial_change}" reRender="dataAreasDependientes" event="onchange" oncomplete="tiposMaterialReactivo_change()" />
                    </h:selectOneMenu>
                    
                    <%--h:outputText value="#{areasdependientes.nombreAreaEmpresa}"   /--%>
                    <br><br>

                    <h:inputHidden value="#{ManagedFormulaMaestraDetalleMP.formulaMaestraDetalleMP.tiposMaterialReactivo.nombreTipoMaterialReactivo}"
                    id="nombreTipoMaterialReactivo"   />

                    <%--rich:dataTable value="#{ManagedFormulaMaestraDetalleMP.formulaMaestraDetalleMReactivoList}" var="data" id="dataAreasDependientes"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#CCDFFA';" 

                                    headerClass="headerClassACliente">
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value=""  />
                                
                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.checked}"  />
                        </rich:column>
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value="Materia Prima"  />
                            </f:facet>
                            <h:outputText  value="#{data.materiales.nombreMaterial}" />
                        </rich:column>
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value="Cantidad"  />
                            </f:facet>
                            <h:outputText value="#{data.cantidad}" />
                        </rich:column>
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value="Unidad Medida"  />
                            </f:facet>
                            <h:outputText value="#{data.unidadesMedida.nombreUnidadMedida}" />
                        </rich:column>
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value="Estado Material"  />
                            </f:facet>
                            <h:outputText value="#{data.materiales.estadoRegistro.nombreEstadoRegistro}" />
                        </rich:column>
                        
                         <rich:subTable value="#{data.tiposAnalisisMaterialReactivoList1}" var="subData" rowKeyVar="row">
                            <rich:column colspan="2" >
                                <h:outputText value="#{subData.nombreTiposAnalisisMaterialReactivo}" />
                                <%--h:selectBooleanCheckbox value="#{subData.checked}" disabled="true"/>
                            </rich:column>
                         </rich:subTable>
                        
                        <h:column >
                            <f:facet name="header">
                                <h:outputText value="Fracciones"  />
                            </f:facet>
                            <h:outputText value="#{data.nroPreparaciones}" />
                        </h:column>
                        
                    </rich:dataTable--%>



                    <rich:dataTable value="#{ManagedFormulaMaestraDetalleMP.formulaMaestraDetalleMReactivoList}"
                                    var="data"
                                    id="dataPreguntas"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente" style="margin-top:12px;"
                                    width="80%"
                                    >
                                       <f:facet name="header">
                                            <rich:columnGroup>
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
                                                <h:outputText  value="#{data.materiales.estadoRegistro.nombreEstadoRegistro}" />
                                            </rich:column>
                                            <rich:column>
                                                <h:selectBooleanCheckbox value="#{subData.checked}"/>
                                            </rich:column>
                                            <rich:column>
                                                 <h:outputText value="#{subData.nombreTiposAnalisisMaterialReactivo}">
                                                 </h:outputText>
                                            </rich:column>
                                        </rich:subTable>




                    </rich:dataTable>
                    
                    <br>
                    <h:commandButton value="Agregar"   styleClass="btn"  action="#{ManagedFormulaMaestraDetalleMP.actionAgregarReactivo}"/>
                    <h:commandButton value="Editar "    styleClass="btn"  action="#{ManagedFormulaMaestraDetalleMP.actionEditarReactivos}" onclick="return editarItem('form1:dataAreasDependientes'); "/>
                    <h:commandButton value="Eliminar"  styleClass="btn"  action="#{ManagedFormulaMaestraDetalleMP.actionEliminarReactivos}"  onclick="return eliminarItem('form1:dataAreasDependientes'); "/>
                    <a4j:commandButton value="Guardar"  styleClass="btn"  action="#{ManagedFormulaMaestraDetalleMP.guardarFormulaMaestraReactivos_action}" oncomplete="location='../formula_maestra/navegador_formula_maestra.jsf'" />
                    <h:commandButton value="Cancelar"   styleClass="btn"  action="navegadorFormulaMaestra"/>
                    
                    
                </div>
                
                <!--cerrando la conexion-->
                <h:outputText value="#{ManagedFormulaMaestraDetalleMP.closeConnection}"  />
                
            </h:form>
            
        </body>
    </html>
    
</f:view>

