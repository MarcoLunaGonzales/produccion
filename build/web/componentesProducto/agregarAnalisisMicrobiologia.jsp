package componentesProducto;



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
                <h:form id="form1"  >
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
                    <rich:dataTable value="#{ManagedComponentesProducto.listaEspecificacionesMicrobiologia}" var="data" id="dataEspecificacionesFisicas"
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
                                <h:outputText value="Analisis Mirobiologico"  />
                            </f:facet>
                            <h:outputText value="#{data.especificacionMicrobiologiaCc.nombreEspecificacion}"  />
                        </rich:column >
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Especificaciones"  />
                            </f:facet>
                            <h:inputText value="#{data.descripcion}" rendered="#{data.especificacionMicrobiologiaCc.tipoResultadoAnalisis.codTipoResultadoAnalisis eq '1'}" />
                            <h:panelGrid columns="3" rendered="#{data.especificacionMicrobiologiaCc.tipoResultadoAnalisis.codTipoResultadoAnalisis eq '2'}">
                                <h:inputText value="#{data.limiteInferior}" size="5" onkeypress="valNum()" />
                            <h:outputText value="-" />
                            <h:inputText value="#{data.limiteSuperior}" size="5" onkeypress="valNum()"/>
                            </h:panelGrid>
                            <h:panelGrid columns="2" rendered="#{data.especificacionMicrobiologiaCc.tipoResultadoAnalisis.codTipoResultadoAnalisis eq '3'}">

                            <h:outputText value="=" />
                            <h:inputText value="#{data.valorExacto}" size="5" onkeypress="valNum()"/>
                            </h:panelGrid>
                        </rich:column >
                         <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Referencia"  />
                            </f:facet>

                             <h:selectOneMenu value="#{data.especificacionMicrobiologiaCc.tiposReferenciaCc.codReferenciaCc}">
                                                <f:selectItems value="#{ManagedComponentesProducto.listaTiposReferenciaCc}"/>
                             </h:selectOneMenu>
                        </rich:column >
                         <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Estado"  />
                            </f:facet>

                             <h:selectOneMenu value="#{data.estado.codEstadoRegistro}">
                                 <f:selectItem itemValue="1" itemLabel="Activo"/>
                                 <f:selectItem itemValue="2" itemLabel="No Activo"/>
                             </h:selectOneMenu>
                        </rich:column >


                   </rich:dataTable>

                        <h:commandButton value="Guardar" styleClass="commandButton" action="#{ManagedComponentesProducto.guardarAnalisisMicrobiologico_Action}"  />
                        <h:commandButton value="Cancelar"  styleClass="commandButton" action="#{ManagedComponentesProducto.cancelar}"/>
                    </div>            
                </h:form>
            </div>    
        </body>
    </html>
    
</f:view>

