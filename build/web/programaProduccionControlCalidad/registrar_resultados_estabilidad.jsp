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
           <script>
               function verDetalleMaterialesAnalisis(codControl,codAnalisis)
               {
                   var url="reporteDetalleMaterialesAnalisis.jsf?cod="+Math.random()+"&codCC="+codControl+"&codAnalisis="+codAnalisis;
                   window.open(url,'detalle','top=50,left=200,width=800,height=500,scrollbars=1,resizable=1');

               }
               function verDetalleMaterialesProgramaLote(codControl)
               {
                   var url="reporteDetalleMaterialesProgramaEstabilidad.jsf?cod="+Math.random()+"&codCC="+codControl;
                   window.open(url,'detalle','top=50,left=200,width=800,height=500,scrollbars=1,resizable=1');

               }
          </script>
            <style>
               
                .subCabecera
                {
                    background-color:#9d5a9e;
                    color:white;
                    font-weight:bold;
                }
                .headerLocal{
                    background-image:none;
                    background-color:#9d5f9f;
                    font-weight:bold;
                }
                .celdaVersion{
                    background-color:#eeeeee;
                }
            </style>
        </head>
            <a4j:form id="form1">
                <div align="center">
                    
                    <%--h:outputText value="#{ManagedProgramaProduccionControlCalidad.cargarProgramaProduccionControlCalidad}"  /--%>
                     <rich:panel headerClass="headerClassACliente" style="width:50%;align:center">
                            <f:facet name="header">
                                    <h:outputText value="Programa de Estabilidad"/>
                            </f:facet>
                            <h:panelGrid columns="3">
                                <h:outputText value="Producto" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="#{ManagedProgramaProduccionControlCalidad.produccionControlCalidadAnalisisEditar.programaProduccionControlCalidad.componentesProd.nombreProdSemiterminado}" styleClass="outputText2" style=""/>
                                <h:outputText value="Lote" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="#{ManagedProgramaProduccionControlCalidad.produccionControlCalidadAnalisisEditar.programaProduccionControlCalidad.codLoteProduccion}" styleClass="outputText2" style=""/>
                                <h:outputText value="Almacen Muestra" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="#{ManagedProgramaProduccionControlCalidad.produccionControlCalidadAnalisisEditar.programaProduccionControlCalidad.almacenesMuestra.nombreAlmacenMuestra}" styleClass="outputText2" style=""/>
                                <h:outputText value="Tipo de Estudio" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="#{ManagedProgramaProduccionControlCalidad.produccionControlCalidadAnalisisEditar.programaProduccionControlCalidad.tiposEstudioEstabilidad.nombreTipoEstudioEstabilidad}" styleClass="outputText2" style=""/>
                                <h:outputText value="Tipo de Programa Produccion" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="#{ManagedProgramaProduccionControlCalidad.produccionControlCalidadAnalisisEditar.programaProduccionControlCalidad.tiposProgramaProduccion.nombreTipoProgramaProd}" styleClass="outputText2" style=""/>
                                <h:outputText value="Programa Produccion" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="#{ManagedProgramaProduccionControlCalidad.produccionControlCalidadAnalisisEditar.programaProduccionControlCalidad.programaProduccionPeriodo.nombreProgramaProduccion}" styleClass="outputText2" style=""/>
                            </h:panelGrid>
                    </rich:panel>
                     <br>
                </div>




                    <h:panelGroup id="contenidoResultados">

                     <center>
                    <%--div style="height:320px;overflow:auto; margin-top:6px;"  id="container" ><%--onscroll="onScroll('form11:dataProgProd','container')"--%>
                    <rich:panel headerClass="headerClassACliente" style="width:80%">
                    <f:facet name="header">
                        <h:outputText value="Analisis Fisico"/>
                    </f:facet>

                          <rich:dataTable value="#{ManagedProgramaProduccionControlCalidad.resultadoFisicoEstabilidad}"
                                              var="data" id="dataProgProd" headerClass="headerClassACliente"
                                              onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                              onRowMouseOver="this.style.backgroundColor='#F3F7FD';"  >
                                <rich:column>
                                    <f:facet name="header">
                                        <h:outputText value=""/>
                                    </f:facet>
                                    <%--/h:selectBooleanCheckbox value="#{data.checked}" /--%>
                                    <h:outputText value="#{data.especificacionesFisicasProducto.especificacionFisicaCC.nombreEspecificacion}" styleClass="outputText2"/>

                                </rich:column >
                                <rich:column  >
                                    <f:facet name="header">
                                        <h:outputText value="Especificacion"/>
                                    </f:facet>
                                    <h:panelGroup rendered="#{data.especificacionesFisicasProducto.limiteInferior!=0 && data.especificacionesFisicasProducto.limiteSuperior!=0}">
                                    <h:outputText value="#{data.especificacionesFisicasProducto.limiteInferior}" styleClass="outputText2"/>-
                                    <h:outputText value="#{data.especificacionesFisicasProducto.limiteSuperior}" styleClass="outputText2"/>
                                    </h:panelGroup>
                                    <h:outputText value="#{data.especificacionesFisicasProducto.descripcion}" styleClass="outputText2"  rendered="#{data.especificacionesFisicasProducto.limiteInferior eq 0 && data.especificacionesFisicasProducto.limiteSuperior  eq 0}" />
                                </rich:column >
                                <rich:column  >
                                    <f:facet name="header">
                                        <h:outputText value="Resultado"/>
                                    </f:facet>
                                    <h:panelGroup rendered="#{data.especificacionesFisicasProducto.limiteInferior!=0 && data.especificacionesFisicasProducto.limiteSuperior!=0}">
                                    <h:inputText value="#{data.resultadoNumerico}" styleClass="inputText1"/>
                                    </h:panelGroup>
                                    <br/>
                                    <h:selectOneMenu value="#{data.codTipoResultadoDescriptivo}"><%-- rendered="#{data.especificacionesFisicasProducto.limiteInferior eq 0 && data.especificacionesFisicasProducto.limiteSuperior  eq 0}" --%>
                                        <f:selectItem itemValue="0"  itemLabel="-Ninguno-" />
                                        <f:selectItem itemValue="1"  itemLabel="Conforme" />
                                        <f:selectItem itemValue="2"  itemLabel="No Conforme" />
                                    </h:selectOneMenu>
                                    <%--h:outputText value="#{data.especificacionesFisicasProducto.descripcion}" styleClass="outputText2"  rendered="#{data.especificacionesFisicasProducto.limiteInferior eq 0 && data.especificacionesFisicasProducto.limiteSuperior  eq 0}" /--%>
                                </rich:column >


                                <%--rich:column  >
                                    <f:facet name="header">
                                        <h:outputText value="Cant."/>
                                    </f:facet>
                                    <h:inputText value="#{data.cantidad}" styleClass="outputText2" size = "8" />
                                </rich:column --%>

                        </rich:dataTable>
                    <%--/div--%>
                    </rich:panel>
                  </h:panelGroup>
                  <h:panelGroup id="contenidoResultados1">

                     <center>
                    <%--div style="height:320px;overflow:auto; margin-top:6px;"  id="container" ><%--onscroll="onScroll('form11:dataProgProd','container')"--%>
                    <rich:panel headerClass="headerClassACliente" style="width:80%">
                    <f:facet name="header">
                        <h:outputText value="Analisis Quimico"/>
                    </f:facet>

                          <rich:dataTable value="#{ManagedProgramaProduccionControlCalidad.resultadoQuimicoEstabilidad}"
                                              var="data" id="dataProgProd2" headerClass="headerClassACliente" onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#F3F7FD';"  >
                                <rich:column>
                                    <f:facet name="header">
                                        <h:outputText value="Material"/>
                                    </f:facet>
                                    <%--/h:selectBooleanCheckbox value="#{data.checked}" /--%>
                                    <h:outputText value="#{data.materiales.nombreMaterial}" styleClass="outputText2"/>

                                </rich:column >
                                <rich:column>
                                    <f:facet name="header">
                                        <h:outputText value=""/>
                                    </f:facet>
                                    <%--/h:selectBooleanCheckbox value="#{data.checked}" /--%>
                                    <h:outputText value="#{data.especificacionesQuimicasProducto.especificacionQuimica.nombreEspecificacion}" styleClass="outputText2"/>

                                </rich:column >
                                <rich:column  >
                                    <f:facet name="header">
                                        <h:outputText value="Especificacion"/>
                                    </f:facet>
                                    <h:panelGroup rendered="#{data.especificacionesQuimicasProducto.limiteInferior!=0 && data.especificacionesQuimicasProducto.limiteSuperior!=0}">
                                    <h:outputText value="#{data.especificacionesQuimicasProducto.limiteInferior}" styleClass="outputText2"/>-
                                    <h:outputText value="#{data.especificacionesQuimicasProducto.limiteSuperior}" styleClass="outputText2"/>
                                    </h:panelGroup>
                                    <h:outputText value="#{data.especificacionesQuimicasProducto.descripcion}" styleClass="outputText2"  rendered="#{data.especificacionesQuimicasProducto.limiteInferior eq 0 && data.especificacionesQuimicasProducto.limiteSuperior  eq 0}" />
                                </rich:column >
                                <rich:column  >
                                    <f:facet name="header">
                                        <h:outputText value="Resultado"/>
                                    </f:facet>
                                    <h:panelGroup rendered="#{data.especificacionesQuimicasProducto.limiteInferior!=0 && data.especificacionesQuimicasProducto.limiteSuperior!=0}">
                                    <h:inputText value="#{data.resultadoNumerico}" styleClass="inputText1"/>
                                    </h:panelGroup>
                                    <br/>
                                    <h:selectOneMenu value="#{data.codTipoResultadoDescriptivo}"><%-- rendered="#{data.especificacionesQuimicasProducto.limiteInferior eq 0 && data.especificacionesQuimicasProducto.limiteSuperior  eq 0}" --%>
                                        <f:selectItem itemValue="0"  itemLabel="-Ninguno-" />
                                        <f:selectItem itemValue="1"  itemLabel="Conforme" />
                                        <f:selectItem itemValue="2"  itemLabel="No Conforme" />
                                    </h:selectOneMenu>
                                    <%--h:outputText value="#{data.especificacionesQuimicasProducto.descripcion}" styleClass="outputText2"  rendered="#{data.especificacionesQuimicasProducto.limiteInferior eq 0 && data.especificacionesQuimicasProducto.limiteSuperior  eq 0}" /--%>
                                </rich:column >


                                <%--rich:column  >
                                    <f:facet name="header">
                                        <h:outputText value="Cant."/>
                                    </f:facet>
                                    <h:inputText value="#{data.cantidad}" styleClass="outputText2" size = "8" />
                                </rich:column --%>

                        </rich:dataTable>
                    <%--/div--%>
                    </rich:panel>
                  </h:panelGroup>
                  <a4j:commandButton timeout="10000" value="Guardar" action="#{ManagedProgramaProduccionControlCalidad.guardarResultadosFisicosEstabilidad}"  styleClass="btn" oncomplete="location='navegador_programa_produccion_control_calidad.jsf'" />
                  <a4j:commandButton timeout="10000" value="Cancelar"  styleClass="btn" onclick="location='navegador_programa_produccion_control_calidad.jsf'" />
                  
                </center>

                    <a4j:status id="statusPeticion"
                                onstart="Richfaces.showModalPanel('ajaxLoadingModalBox',{width:100, top:100})"
                                onstop="Richfaces.hideModalPanel('ajaxLoadingModalBox')">
                    </a4j:status>

                    <rich:modalPanel id="ajaxLoadingModalBox" minHeight="100"
                                     minWidth="200" height="80" width="400" zindex="100" onshow="window.focus();">

                        <div align="center">
                            <h:graphicImage value="../img/load2.gif" />
                        </div>
                    </rich:modalPanel>

                


            </a4j:form>
            
                            
                                 
                        
        </body>
    </html>
    
</f:view>

