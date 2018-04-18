<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
            <script src="../../js/general.js"></script>
            <script>
                function validar(){
                   var nombreareaempresa=document.getElementById('form1:nombreareaempresa');
                   var obsareaempresa=document.getElementById('form1:obsareaempresa');
                   if(nombreareaempresa.value==''){
                     alert('Por favor instroduzca Nombre Area Empresa');
                     nombreareaempresa.focus();
                     return false;
                   }
                   /*if(obsareaempresa.value==''){
                     alert('Por favor instroduzca datos');
                     obsareaempresa.focus();
                     return false;
                   } */                  
                   return true;
                }
            </script>
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
                            <h:outputText value="#{ManagedVersionesFormulaMaestra.formulaMaestraVersionaBean.componentesProd.nombreProdSemiterminado}" styleClass="outputText2" />
                            <h:outputText value="Nro Versión" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="#{ManagedVersionesFormulaMaestra.formulaMaestraVersionaBean.componentesProd.nroVersion}" styleClass="outputText2" />
                            <h:outputText value="Tamaño Lote" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="#{ManagedVersionesFormulaMaestra.formulaMaestraVersionaBean.cantidadLote}" styleClass="outputText2" />
                            
                        </h:panelGrid>
                    </rich:panel>
                    <rich:dataTable value="#{ManagedVersionesFormulaMaestra.formulaMaestraDetalleMREditarList}"
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
                        <%--h:column >
                            <f:facet name="header">
                                <h:outputText value="Fracciones"  />
                            </f:facet>
                            <h:inputText value="#{data.nroPreparaciones}" onkeypress="valNum();" styleClass="inputText"/>
                        </h:column--%>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Tipo de Material Reactivo"  />
                            </f:facet>
                            <h:selectOneMenu value="#{data.tiposMaterialReactivo.codTipoMaterialReactivo}" styleClass="inputText" >
                                <f:selectItems value="#{ManagedVersionesFormulaMaestra.tiposMaterialReactivoSelectList}" />
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
                    <a4j:commandButton value="Guardar"   styleClass="btn"  action="#{ManagedVersionesFormulaMaestra.guardarEdicionFormulaMaestraDetalleMrVersion_action}"
                    oncomplete="if(#{ManagedVersionesFormulaMaestra.mensaje eq '1'}){alert('Se guardo la edicion de los materiales');var a=Math.random();window.location.href='navegadorFormulaMaestraDetalleMRVersion.jsf?edMR='+a;}
                    else{alert('#{ManagedVersionesFormulaMaestra.mensaje}');}"/>
                    <a4j:commandButton value="Cancelar"    styleClass="btn"  oncomplete="var a=Math.random();window.location.href='navegadorFormulaMaestraDetalleMRVersion.jsf?edMR='+a"/>
                    
                    
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

