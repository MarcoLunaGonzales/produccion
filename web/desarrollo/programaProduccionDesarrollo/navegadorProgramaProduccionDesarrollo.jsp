
<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css"/>
            <script type="text/javascript" src="../../js/general.js" ></script>
            
        </head>
           <a4j:form id="form1">
                <div align="center">
                    
                    <h:outputText value="#{ManagedProgramaProduccionDesarrolloVersion.cargarProgramaProduccionDesarrolloList}"  />
                    <h:outputText styleClass="outputTextTituloSistema" value="Programas de Desarrollo" />
                        <rich:panel headerClass="headerClassACliente" >
                            <f:facet name="header">
                                <h:outputText value="Datos Programa de Desarrollo"/>
                            </f:facet>
                            <h:panelGrid columns="6">
                                <h:outputText styleClass="outputTextBold" value="Nombre Programa"/>
                                <h:outputText styleClass="outputTextBold" value="::"/>
                                <h:outputText styleClass="outputText2" value="#{ManagedProgramaProduccionDesarrolloVersion.programaProduccionPeriodoDesarrolloBean.nombreProgramaProduccion}"/>
                                <h:outputText styleClass="outputTextBold" value="Observación"/>
                                <h:outputText styleClass="outputTextBold" value="::"/>
                                <h:outputText styleClass="outputText2" value="#{ManagedProgramaProduccionDesarrolloVersion.programaProduccionPeriodoDesarrolloBean.obsProgramaProduccion}"/>
                                <h:outputText styleClass="outputTextBold" value="Fecha Inicio"/>
                                <h:outputText styleClass="outputTextBold" value="::"/>
                                <h:outputText styleClass="outputText2" value="#{ManagedProgramaProduccionDesarrolloVersion.programaProduccionPeriodoDesarrolloBean.fechaInicio}">
                                    <f:convertDateTime pattern="dd/MM/yyyy"/>
                                </h:outputText>
                                <h:outputText styleClass="outputTextBold" value="Fecha Final"/>
                                <h:outputText styleClass="outputTextBold" value="::"/>
                                <h:outputText styleClass="outputText2" value="#{ManagedProgramaProduccionDesarrolloVersion.programaProduccionPeriodoDesarrolloBean.fechaFinal}">
                                    <f:convertDateTime pattern="dd/MM/yyyy"/>
                                </h:outputText>
                            </h:panelGrid>

                        </rich:panel>
                    <h:panelGroup id="contenidoProgramaProduccion">
                        <br>

                        <rich:dataTable value="#{ManagedProgramaProduccionDesarrolloVersion.programaProduccionDesarrolloList}"
                                    var="data" id="dataProgramaProduccion"
                                    headerClass="headerClassACliente">
                                        <f:facet name="header">
                                    <rich:columnGroup>
                                        
                                            <rich:column rowspan="2">
                                                <h:outputText value=""/>
                                            </rich:column>
                                            <rich:column rowspan="2">
                                                <h:outputText value="Producto"/>
                                            </rich:column>
                                            <rich:column rowspan="2">
                                                <h:outputText value="Cantidad.<br> Lote" escape="false"/>
                                            </rich:column>
                                            <rich:column rowspan="2">
                                                <h:outputText value="Nro. Lote"/>
                                            </rich:column>
                                            <rich:column rowspan="2">
                                                <h:outputText value="Fecha Registro"/>
                                            </rich:column>
                                            <rich:column rowspan="2">
                                                <h:outputText value="Tipo Programa Producción"/>
                                            </rich:column>
                                            <rich:column rowspan="2">
                                                <h:outputText value="Nro Ensayo"/>
                                            </rich:column>                                            
                                            <rich:column rowspan="2">
                                                <h:outputText value="Area"/>
                                            </rich:column>
                                            <rich:column rowspan="2">
                                                <h:outputText value="Observaciones"/>
                                            </rich:column>
                                            <rich:column rowspan="2">
                                                <h:outputText value="Estado"/>
                                            </rich:column>
                                            
                                    </rich:columnGroup>
                                    </f:facet>
                                    <rich:columnGroup >
                                        <rich:column >
                                            <h:selectBooleanCheckbox value="#{data.checked}" rendered="#{data.estadoProgramaProduccion.codEstadoProgramaProd!='6'}"  />
                                        </rich:column>
                                        <rich:column>
                                            <h:outputText  styleClass="outputText2" style="display:block;" value="#{data.formulaMaestra.componentesProd.nombreProdSemiterminado}"  />
                                        </rich:column>
                                        <rich:column>
                                            <h:outputText value="#{data.cantidadLote}"  />
                                        </rich:column>
                                        <rich:column>
                                            <h:outputText value="#{data.codLoteProduccion}"  />
                                        </rich:column >
                                        <rich:column>
                                            <h:outputText value="#{data.fechaRegistro}">
                                                <f:convertDateTime pattern="dd/MM/yyyy HH:mm"/>
                                            </h:outputText>
                                        </rich:column >
                                        <rich:column >
                                            <h:outputText value="#{data.tiposProgramaProduccion.nombreProgramaProd}" />
                                        </rich:column >
                                        <rich:column>
                                            <h:outputText value="#{data.componentesProdVersion.nroVersion}"  />
                                        </rich:column >
                                        <rich:column  >
                                            <h:outputText value="#{data.formulaMaestra.componentesProd.areasEmpresa.nombreAreaEmpresa}"/>
                                        </rich:column>
                                        <rich:column   >
                                            <h:outputText value="#{data.observacion}" />
                                        </rich:column >
                                        <rich:column   >
                                            <h:outputText value="#{data.estadoProgramaProduccion.nombreEstadoProgramaProd}" />
                                        </rich:column >
                                        
                                    </rich:columnGroup>
                    </rich:dataTable>
                    
                    <br>
                    <a4j:commandButton value="Agregar" action="#{ManagedProgramaProduccionDesarrolloVersion.agregarProgramaProduccionDesarrollo_action}"
                                               oncomplete="Richfaces.showModalPanel('panelAgregarLoteDesarrollo')"
                                               reRender="contenidoAgregarLoteDesarrollo"
                                               styleClass="btn"/>
                    <a4j:commandButton value="Eliminar" action="#{ManagedProgramaProduccionDesarrolloVersion.eliminarLoteDesarrollo_action}"
                                       oncomplete="if(#{ManagedProgramaProduccionDesarrolloVersion.mensaje eq '1'}){alert('Se elimino el programa de desarrollo?');}else{alert('#{ManagedProgramaProduccionDesarrolloVersion.mensaje}')}"
                                       styleClass="btn" reRender="dataProgramaProduccion"/>
                            <a4j:commandButton value="Volver" oncomplete="redireccionar('navegadorProgramaPeriodoDesarrollo.jsf')" styleClass="btn"/>
                    
                    </h:panelGroup>
                   
                    

                   
                    
                    <%--a4j:commandButton value="Explosión"  styleClass="btn"  action="#{ManagedProgramaProduccion.actionEliminar}"  oncomplete="enviar('#{ManagedProgramaProduccion.codigos}','#{ManagedProgramaProduccion.fecha_inicio}','#{ManagedProgramaProduccion.fecha_final}')" /--%>
                </div>

                <a4j:status id="statusPeticion"
                                onstart="Richfaces.showModalPanel('ajaxLoadingModalBox',{width:100, top:100})"
                                onstop="Richfaces.hideModalPanel('ajaxLoadingModalBox')">
                    </a4j:status>

                    <rich:modalPanel id="ajaxLoadingModalBox" minHeight="100"
                                     minWidth="200" height="80" width="400" zindex="500" onshow="window.focus();">

                        <div align="center">
                            <h:graphicImage value="../img/load2.gif" />
                        </div>
                    </rich:modalPanel>

            </a4j:form>
            
             <rich:modalPanel id="panelAgregarLoteDesarrollo"
                                     minHeight="340"  minWidth="700"
                                     height="340" width="700" zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false">
                        <f:facet name="header">
                            <h:outputText value="<center>Productos Desarrollo</center>" escape="false" />
                        </f:facet>
                        <a4j:form id="form2">
                            <center>
                            <h:panelGroup id="contenidoAgregarLoteDesarrollo">
                                <span class="outputTextBold">Producto:</span><input id="productoBuscar" class="inputText" onkeyup="buscarTexto();">
                                <table><tr><td>
                                <div style='height:240px;overflow:auto;width:100%'>
                                    <rich:dataTable value="#{ManagedProgramaProduccionDesarrolloVersion.componentesProdVersionDesarrolloAgregarList}"
                                             var="data" id="detalle"
                                             headerClass="headerClassACliente"
                                             onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                             onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                             binding="#{ManagedProgramaProduccionDesarrolloVersion.componentesProdVersionDesarrolloAgregarDataTable}">
                                      <f:facet name="header">
                                          <rich:columnGroup>
                                              <rich:column >
                                                  <h:outputText value="Producto"/>
                                              </rich:column>
                                              <rich:column >
                                                  <h:outputText value="Tamanio Lote"/>
                                              </rich:column>
                                              <rich:column >
                                                  <h:outputText value="Nro ensayo"/>
                                              </rich:column>
                                              
                                          </rich:columnGroup>
                                      </f:facet>
                                      
                                          <rich:column >
                                              <a4j:commandLink reRender="dataProgramaProduccion" action="#{ManagedProgramaProduccionDesarrolloVersion.seleccionarCrearLoteDesarrollo_action}"
                                                               oncomplete="if(#{ManagedProgramaProduccionDesarrolloVersion.mensaje eq '1'}){alert('Se registro el lote');Richfaces.hideModalPanel('panelAgregarLoteDesarrollo');}else{alert('#{ManagedProgramaProduccionDesarrolloVersion.mensaje}');}">
                                                  <h:outputText value="#{data.nombreProdSemiterminado}"/>
                                              </a4j:commandLink>
                                          </rich:column>
                                          <rich:column >
                                              <h:outputText value="#{data.tamanioLoteProduccion}"/>
                                          </rich:column>
                                          <rich:column >
                                              <h:outputText value="#{data.nroVersion}"/>
                                          </rich:column>
                                          
                                      
                                </rich:dataTable>
                                </div>
                                </td></tr></table>
                            </h:panelGroup>
                            <a4j:commandButton value="Cancelar" oncomplete="Richfaces.hideModalPanel('panelAgregarLoteDesarrollo');" styleClass="btn"/>
                            </center>
                        </a4j:form>
                    </rich:modalPanel>
        </body>
    </html>
    
</f:view>

