<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>
    
    <html>

        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
            <script type="text/javascript" src="../../js/general.js" ></script>
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
                    window.location.href="../../componentesProdVersion/"+url+".jsf?fm="+(new Date()).getTime().toString();
                }
            </script>
        </head>
        <body >
            <h:form id="form1">
                <center>
                <h:outputText value="#{ManagedVersionesFormulaMaestra.cargarFormulaMaestraDetalleMR_action}"/>
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
                            <h:outputText value="#{ManagedVersionesFormulaMaestra.formulaMaestraVersionaBean.cantidadLote}" styleClass="outputText2" />
                            
                            <h:outputText value="Tipo Material Reactivo" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <h:selectOneMenu value="#{ManagedVersionesFormulaMaestra.codTipoMaterialReactivo}" styleClass="inputText">
                                <f:selectItems value="#{ManagedVersionesFormulaMaestra.tiposMaterialReactivoSelectList}"/>
                                <a4j:support event="onchange" action="#{ManagedVersionesFormulaMaestra.codTipoMaterialReactivo_change}" reRender="dataMaterialReactivo"/>
                            </h:selectOneMenu>
                        </h:panelGrid>
                    </rich:panel>
                    
                        
                    
                    
                    <rich:dataTable value="#{ManagedVersionesFormulaMaestra.formulaMaestraDetalleMRList}"
                                    var="data"
                                    id="dataMaterialReactivo"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente" style="margin-top:12px;"
                                    >
                                       <f:facet name="header">
                                            <rich:columnGroup>
                                                <rich:column>
                                                    <h:outputText value=""  />
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
                                                <h:selectBooleanCheckbox value="#{subData.checked}" disabled="true"/>
                                            </rich:column>
                                            <rich:column>
                                                 <h:outputText value="#{subData.nombreTiposAnalisisMaterialReactivo}">
                                                 </h:outputText>
                                            </rich:column>
                                        </rich:subTable>




                    </rich:dataTable>
                    <h:panelGroup rendered="#{ManagedVersionesFormulaMaestra.formulaMaestraVersionaBean.estadoVersionFormulaMaestra.codEstadoVersionFormulaMaestra!='2'}">
                    <div style="margin-top:0.5em">
                        <a4j:commandButton value="Agregar" styleClass="btn" oncomplete="var a=Math.random();window.location.href='agregarFormulaMaestraDetalleMRVersion.jsf?a='+a"/>
                        <a4j:commandButton value="Editar" styleClass="btn" action="#{ManagedVersionesFormulaMaestra.editarFormulaMaestraDetalleMRVersion_action}"
                        onclick="if(!eliminarMaterial('form1:dataMaterialReactivo',false)){return false;}"
                        oncomplete="var a=Math.random();window.location.href='editarFormulaMaestraDetalleMRVersion.jsf?e='+a;"/>
                        <a4j:commandButton value="Eliminar" styleClass="btn" action="#{ManagedVersionesFormulaMaestra.eliminarFormulaMaestraDetalleMRVersion_action}"
                        onclick="if(eliminarMaterial('form1:dataMaterialReactivo',true)){if(!confirm('Esta seguro de eliminar el material?')){return false;}}else{return false;}"
                        oncomplete="if(#{ManagedVersionesFormulaMaestra.mensaje eq '1'}){alert('Se elimino el material');}else{alert('#{ManagedVersionesFormulaMaestra.mensaje}');}"
                        reRender="dataMaterialReactivo"/>
                        <a4j:commandButton value="Volver"   styleClass="btn"  oncomplete="retornarNavegadorFm(#{ManagedVersionesFormulaMaestra.formulaMaestraVersionaBean.componentesProd.tiposModificacionProducto.codTipoModificacionProducto});"/>
                    </div>
                    </h:panelGroup>
                    
                    
                </center>
                
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

