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
            <style  type="text/css">
                .a{
                background-color : #F2F5A9;
                }
                .b{
                background-color : #ffffff;
                }
                .columns{
                border:0px solid red;
                }
                .simpleTogglePanel{
                text-align:center;
                }
                .ventasdetalle{
                font-size: 13px;
                font-family: Verdana;
                }
                .preciosaprobados{
                background-color:#33CCFF;
                }
                .enviado{
                background-color:#FFFFCC;
                }
                .pasados{
                background-color:#ADD797;
                }
                .pendiente{
                background-color : #ADD797;
                }
                .leyendaColorAnulado{
                background-color: #FF6666;
                }                
            </style>
              <script>
                function openPopup(url){
                    //alert(url);
                    window.open(url,'DETALLE','top=50,left=200,width=800,height=500,scrollbars=1,resizable=1');
                }
            </script>
        </head>
        
            
            
            <a4j:form id="form1">
                <div align="center">
                    
                    <h:outputText value="#{ManagedSeguimientoProcesosPorLote.cargarProgProdTableta}"  />
                    <rich:panel headerClass="headerClassACliente">
                        <f:facet name="header">
                            <h:outputText value="Buscador Lote Programa Produccion"/>
                        </f:facet>
                        <h:panelGrid columns="6">
                            <h:outputText value="Programa Produccion" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <h:selectOneMenu value="#{ManagedSeguimientoProcesosPorLote.programaProduccionTableta.codProgramaProduccion}" styleClass="inputText">
                                <f:selectItems value="#{ManagedSeguimientoProcesosPorLote.programasPeriodoListSelect}"/>
                            </h:selectOneMenu>
                            <h:outputText value="Producto" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <h:selectOneMenu value="#{ManagedSeguimientoProcesosPorLote.programaProduccionTableta.formulaMaestra.componentesProd.codCompprod}" styleClass="inputText">
                                <f:selectItems value="#{ManagedSeguimientoProcesosPorLote.componentesProdListSelect}"/>
                            </h:selectOneMenu>
                            <h:outputText value="Area Empresa" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <h:selectOneMenu value="#{ManagedSeguimientoProcesosPorLote.programaProduccionTableta.formulaMaestra.componentesProd.areasEmpresa.codAreaEmpresa}" styleClass="inputText">
                                <f:selectItems value="#{ManagedSeguimientoProcesosPorLote.areasEmpresaListSelect}"/>
                            </h:selectOneMenu>
                            <h:outputText value="Estado Programa" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <h:selectOneMenu value="#{ManagedSeguimientoProcesosPorLote.programaProduccionTableta.estadoProgramaProduccion.codEstadoProgramaProd}" styleClass="inputText">
                                <f:selectItems value="#{ManagedSeguimientoProcesosPorLote.estadosProgProdListSelect}"/>
                            </h:selectOneMenu>
                            <h:outputText value="Lote" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <h:inputText  value="#{ManagedSeguimientoProcesosPorLote.programaProduccionTableta.codLoteProduccion}" styleClass="inputText"/>
                            <a4j:commandButton action="#{ManagedSeguimientoProcesosPorLote.buscarLotesProgramaProd_action}" value="Buscar" styleClass="btn"
                            reRender="dataProgramaproduccionList"/>
                        </h:panelGrid>

                    </rich:panel>
                    <h:outputText styleClass="outputTextTitulo"  value="Programas de Producción" />
                    <br><br>
                  
                        <h:panelGroup id="contenidoProgramaProduccion">


                        <rich:dataTable value="#{ManagedSeguimientoProcesosPorLote.programaProduccionDataModel}" var="data" id="dataProgramaproduccionList"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente"
                                    >
                       
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value="Producto"  />
                            </f:facet>
                            <h:outputText value="#{data.formulaMaestra.componentesProd.nombreProdSemiterminado}"  />
                        </rich:column>
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value="Lote"  />
                            </f:facet>
                            <h:outputText value="#{data.cantidadLote}"  />
                        </rich:column>
                       
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value="Nro de Lote"  />
                            </f:facet>
                            <h:outputText value="#{data.codLoteProduccion}"  />
                        </rich:column >
                        
                        
                        <rich:column >
                            <f:facet name="header" >
                                <h:outputText value="Area"  />
                            </f:facet>
                            <h:outputText value="#{data.formulaMaestra.componentesProd.areasEmpresa.nombreAreaEmpresa}"/>
                        </rich:column>

                        <rich:column  styleClass="#{data.styleClass}" >
                            <f:facet name="header">
                                <h:outputText value="Observaciones"  />
                            </f:facet>
                            <h:outputText value="#{data.observacion}" />
                        </rich:column >
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value="Estado"  />
                            </f:facet>
                            <h:outputText value="#{data.estadoProgramaProduccion.nombreEstadoProgramaProd}" />
                        </rich:column >
                       <rich:column  >
                            <f:facet name="header">
                                <h:outputText value="Proceso Preparados"  />
                            </f:facet>
                            
                            <a4j:commandLink styleClass="outputText2"
                            onclick="openPopup('navegadorSeguimientoProcesos.jsf?codComprod=#{data.formulaMaestra.componentesProd.codCompprod}&codLote=#{data.codLoteProduccion}&codAreaEmpresa=#{data.formulaMaestra.componentesProd.areasEmpresa.codAreaEmpresa}')">
                                 <h:graphicImage url="../../img/detalle.jpg" title="Reporte de procesos"/>
                             </a4j:commandLink>
                        </rich:column>
                        <rich:column  >
                            <f:facet name="header">
                                <h:outputText value="Registro Seguimiento"  />
                            </f:facet>

                            <a4j:commandLink styleClass="outputText2"
                            onclick="openPopup('navegadorSeguimientoProcesos(registro pantalla touch).jsf?codComprod=#{data.formulaMaestra.componentesProd.codCompprod}&codLote=#{data.codLoteProduccion}&codAreaEmpresa=#{data.formulaMaestra.componentesProd.areasEmpresa.codAreaEmpresa}')">
                                 <h:graphicImage url="../../img/detalle.jpg" title="Registro de Seguimiento"/>
                             </a4j:commandLink>
                        </rich:column>
                        <rich:column  >
                            <f:facet name="header">
                                <h:outputText value="Proceso Despirogenizados"  />
                            </f:facet>

                            <a4j:commandLink styleClass="outputText2"
                            onclick="openPopup('seguimientoProcesosEspecificaciones/navegadorDespirogenizado.jsf?codComprod=#{data.formulaMaestra.componentesProd.codCompprod}&codLote=#{data.codLoteProduccion}&codAreaEmpresa=#{data.formulaMaestra.componentesProd.areasEmpresa.codAreaEmpresa}')">
                                 <h:graphicImage url="../../img/detalle.jpg" title="Proceso Despirogenizado"/>
                             </a4j:commandLink>
                        </rich:column>

                    </rich:dataTable>
                    
                    <br>
                    </h:panelGroup>
                    </div>
                    </a4j:form>
                   <a4j:status id="statusPeticion"
                                onstart="Richfaces.showModalPanel('ajaxLoadingModalBox',{width:100, top:100})"
                                onstop="Richfaces.hideModalPanel('ajaxLoadingModalBox')">
                    </a4j:status>

                    <rich:modalPanel id="ajaxLoadingModalBox" minHeight="100"
                                     minWidth="200" height="80" width="400" zindex="100" onshow="window.focus();">

                        <div align="center">
                            <h:graphicImage value="../../../img/load2.gif" />
                        </div>
                    </rich:modalPanel>
                    

            
        </body>
    </html>
    
</f:view>

