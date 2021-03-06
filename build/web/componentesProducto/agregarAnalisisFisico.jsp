<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
            <script type="text/javascript" src="../js/general.js"></script>    
        </head>
        <body >    
            <div style="text-align:center">
                <rich:panel headerClass="headerClassACliente" style="width:80%">
                    <f:facet name="header">
                        <h:outputText value="datos del producto"/>

                    </f:facet>
                    <h:panelGrid columns="3" headerClass="headerClassACliente">
                        <h:outputText value="producto " styleClass="outputText2"/>
                       <h:outputText value=":" styleClass="outputText2"/>
                        <h:outputText value="#{ManagedComponentesProducto.componentesProd.nombreProdSemiterminado}   " styleClass="outputText2"/>
                        <h:outputText value="formula farmaceutica " styleClass="outputText2"/>
                        <h:outputText value=":" styleClass="outputText2"/>
                        <h:outputText value="#{ManagedComponentesProducto.componentesProd.forma.nombreForma}" styleClass="outputText2"/>
                    </h:panelGrid>
                </rich:panel>
                <br>
                <h:form id="form1"  >
                    <rich:dataTable value="#{ManagedComponentesProducto.listaEspecificacionesFisicasProducto}" var="data" id="dataEspecificacionesFisicas"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#F3F7FD';"
                                    headerClass="headerClassACliente"
                                    columnClasses="tituloCampo">
                         <rich:column>
                            <f:facet name="header">
                                <h:outputText value=""  />

                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.checked}"  />

                        </rich:column >
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Analisis F�sico"  />
                            </f:facet>
                            <h:outputText value="#{data.especificacionFisicaCC.nombreEspecificacion}" styleClass="outputText2" />
                        </rich:column >
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Especificaciones"  />
                            </f:facet>
                            <center><h:inputText value="#{data.descripcion}" rendered="#{data.especificacionFisicaCC.tipoResultadoAnalisis.codTipoResultadoAnalisis eq '1'}" styleClass="inputText"/></center>
                            <h:panelGrid columns="3" rendered="#{data.especificacionFisicaCC.tipoResultadoAnalisis.codTipoResultadoAnalisis eq '2'}" >
                                <h:inputText value="#{data.limiteInferior}" size="5" onkeypress="valNum()" styleClass="inputText"/>
                            <h:outputText value="-" styleClass="outputText2"/>
                            <h:inputText value="#{data.limiteSuperior}" size="5" onkeypress="valNum()" styleClass="inputText"/>
                            </h:panelGrid>
                            <h:panelGrid columns="2" rendered="#{data.especificacionFisicaCC.tipoResultadoAnalisis.codTipoResultadoAnalisis eq '3'}">
                            <h:outputText value="=" styleClass="outputText2" />
                            <h:inputText value="#{data.valorExacto}"  onkeypress="valNum()" size="5" styleClass="inputText"/>
                            </h:panelGrid>
                        </rich:column >
                         <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Referencia"  />
                            </f:facet>
                            
                             <h:selectOneMenu value="#{data.especificacionFisicaCC.tiposReferenciaCc.codReferenciaCc}" styleClass="inputText">
                                                <f:selectItems value="#{ManagedComponentesProducto.listaTiposReferenciaCc}"/>
                             </h:selectOneMenu>
                        </rich:column >
                         <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Estado"  />
                            </f:facet>

                             <h:selectOneMenu value="#{data.estado.codEstadoRegistro}" styleClass="inputText">
                                 <f:selectItem itemValue="1" itemLabel="Activo"/>
                                 <f:selectItem itemValue="2" itemLabel="No Activo"/>
                             </h:selectOneMenu>
                        </rich:column >


                   </rich:dataTable>

                        <a4j:commandButton value="Guardar" styleClass="commandButton" action="#{ManagedComponentesProducto.guardarAnalisisFisico_Action}"  />
                        <a4j:commandButton value="Cancelar"  styleClass="commandButton" action="#{ManagedComponentesProducto.cancelar}"/>
                    </div>            
                </h:form>
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

            </div>    
        </body>
    </html>
    
</f:view>

