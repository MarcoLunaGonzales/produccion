
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
                 function getCodigo(codigo,codigo1,nombre,cantidad){
                        //alert(codigo);
                        location='../formulaMaestraDetalleEP/navegador_formula_maestra_detalleEP.jsf?codigo='+codigo+'&codigo1='+codigo1+'&nombre='+nombre+'&cantidad='+cantidad;
                 }
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
                        case 4:
                        {
                            url="navegadorNuevosComponentesProd";
                            break;
                        }
                    }
                    redireccionar("../../componentesProdVersion/"+url+".jsf?");
                }
            </script>
            
        </head>
        <body>
            <h:form id="form1">
                
                <div align="center">
                    <h:outputText value="#{ManagedVersionesFormulaMaestra.cargarFormulaMaestraEPVersion}"   />
                <rich:panel headerClass="headerClassACliente" style="width:50%;margin-top:0.3em">
                        <f:facet name="header">
                            <h:outputText value="Datos De La Formula"/>
                        </f:facet>
                        <h:panelGrid columns="3" style="width:auto">
                            <h:outputText value="Producto" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="#{ManagedVersionesFormulaMaestra.formulaMaestraVersionaBean.componentesProd.nombreProdSemiterminado}" styleClass="outputText2" />
                            <h:outputText value="Nro Versión" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="#{ManagedVersionesFormulaMaestra.formulaMaestraVersionaBean.componentesProd.nroVersion}" styleClass="outputText2" />
                            <h:outputText value="Tamaño Lote" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="#{ManagedVersionesFormulaMaestra.formulaMaestraVersionaBean.componentesProd.tamanioLoteProduccion}" styleClass="outputText2" id="cantidadLote" />
                            <h:outputText value="Area Empresa" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="#{ManagedVersionesFormulaMaestra.formulaMaestraVersionaBean.componentesProd.areasEmpresa.nombreAreaEmpresa}" styleClass="outputText2" />

                        </h:panelGrid>
                    </rich:panel>
                        <rich:dataTable value="#{ManagedVersionesFormulaMaestra.formulaMaestraEPList}"
                                    var="data" id="dataDetalleFormula" style="margin-top:0.5em"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#CCDFFA';" 
                                    headerClass="headerClassACliente">
                            <f:facet name="header">
                                <rich:columnGroup>
                                    <rich:column rowspan="2">
                                        <h:outputText value=""/>
                                    </rich:column>
                                    <rich:column rowspan="2">
                                        <h:outputText value="Envase primario"/>
                                    </rich:column>
                                    <rich:column rowspan="2">
                                        <h:outputText value="Cantidad<br>por<br>Presentación" escape="false"/>
                                    </rich:column>
                                    <rich:column rowspan="2">
                                        <h:outputText value="Tipo<br>Producción" escape="false"/>
                                    </rich:column>
                                    <rich:column colspan="6">
                                        <h:outputText value="Empaque Primario"/>
                                    </rich:column>
                                    <rich:column breakBefore="true">
                                        <h:outputText value="Material"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Cantidad Unitaria"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Exceso (%)"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Cantidad Lote"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Unidad Medida"/>
                                    </rich:column>
                                </rich:columnGroup>
                            </f:facet>
                            <rich:subTable value="#{data.formulaMaestraDetalleEPList}" var="subData" rowKeyVar="row">
                                <rich:column rendered="#{row eq '0'}" rowspan="#{data.formulaMaestraDetalleEPListSize}">
                                    <h:selectBooleanCheckbox value="#{data.checked}"/>
                                </rich:column>
                                <rich:column rendered="#{row eq '0'}" rowspan="#{data.formulaMaestraDetalleEPListSize}">
                                    <h:outputText value="#{data.envasesPrimarios.nombreEnvasePrim}"/>
                                </rich:column>
                                <rich:column rendered="#{row eq '0'}" rowspan="#{data.formulaMaestraDetalleEPListSize}">
                                    <h:outputText value="#{data.cantidad}"/>
                                </rich:column>
                                <rich:column rendered="#{row eq '0'}" rowspan="#{data.formulaMaestraDetalleEPListSize}">
                                    <h:outputText value="#{data.tiposProgramaProduccion.nombreTipoProgramaProd}"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="#{subData.materiales.nombreMaterial}" />
                                </rich:column>
                                <rich:column >
                                    <h:outputText value="#{subData.cantidadUnitaria}">
                                        <f:convertNumber pattern="##0.00#####"/>
                                    </h:outputText>
                                </rich:column>
                                <rich:column >
                                    <h:outputText value="#{subData.porcientoExceso}">
                                        <f:convertNumber pattern="##0.00#####"/>
                                    </h:outputText>
                                </rich:column>
                                        
                                <rich:column >
                                    <h:outputText value="#{subData.cantidad}">
                                        <f:convertNumber pattern="##0.00#####"/>
                                    </h:outputText>
                                </rich:column>
                                <rich:column >
                                    <h:outputText value="#{subData.unidadesMedida.nombreUnidadMedida}"/>
                                        
                                </rich:column>
                            </rich:subTable>
                            <rich:column colspan="9" styleClass="separador">
                            </rich:column>
                    </rich:dataTable>
                    
                    <div id="bottonesAcccion" class="barraBotones" >
                        <h:panelGroup rendered="#{ManagedVersionesFormulaMaestra.formulaMaestraVersionaBean.estadoVersionFormulaMaestra.codEstadoVersionFormulaMaestra!='2'}">
                            <a4j:commandButton styleClass="btn" value="Agregar" 
                                            oncomplete="redireccionar('agregarFormulaMaestraDetalleEpVersion.jsf')"/>
                            <a4j:commandButton value="Editar "    styleClass="btn"  action="#{ManagedVersionesFormulaMaestra.editarFormulasMaestradDetalleEpVersion_action}"
                                            onclick="if(!editarItem('form1:dataDetalleFormula')){return false;}"
                                            oncomplete="var a=Math.random();window.location.href='editarFormulaMaestraDetalleEpVersion.jsf?a='+a;"/>

                            <a4j:commandButton value="Eliminar"  styleClass="btn"  action="#{ManagedVersionesFormulaMaestra.eliminarPresentacionPrimaria_action}"
                                            onclick="if(!editarItem('form1:dataDetalleFormula')){return false;}else{if(!confirm('Esta seguro de eliminar la presentación primaria')){return false;}} " reRender="dataDetalleFormula"
                                            oncomplete="if(#{ManagedVersionesFormulaMaestra.mensaje eq '1'}){alert('Se elimino la presentación primaria y los materiales');}else{alert('#{ManagedVersionesFormulaMaestra.mensaje}');}"/>
                            <a4j:commandButton value="Cancelar"   styleClass="btn"  oncomplete="retornarNavegadorFm(#{ManagedVersionesFormulaMaestra.formulaMaestraVersionaBean.componentesProd.tiposModificacionProducto.codTipoModificacionProducto});"/>
                        </h:panelGroup>
                    </div>
                    
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

