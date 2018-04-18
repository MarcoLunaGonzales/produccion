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
                <a4j:form id="form1"  >
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
                       <a4j:commandButton styleClass="btn" value="Materiales Principio Activo"
                        oncomplete="javascript:Richfaces.showModalPanel('panelMaterialesHabilitados')" reRender="dataMaterialesPrincipioActivo" />
                    <rich:dataTable value="#{ManagedComponentesProducto.listaEspecificacionesQuimicasCc}" var="data" id="dataEspecificacionesQuimicas"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#F3F7FD';"
                                    headerClass="headerClassACliente"
                                    columnClasses="tituloCampo">
                         <rich:column>
                            <f:facet name="header">
                                <h:outputText value=""  />

                            </f:facet>
                            <rich:panel headerClass="headerClassACliente">
                                <f:facet name="header">
                                    <h:outputText value="#{data.nombreEspecificacion}"/>
                                </f:facet>
                              <center>  <rich:dataTable value="#{data.listaEspecificacionesQuimicasProducto}" var="data1" id="dataEspecificacionesProducto"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#F3F7FD';"
                                    headerClass="headerClassACliente"
                                    columnClasses="tituloCampo">
                                        <%--rich:column rendered="#{data1.estado.codEstadoRegistro eq '1'}"--%>
                                        <rich:column>
                                         <f:facet name="header">
                                            <h:outputText value="Material"  />
                                            </f:facet>
                                            <h:outputText value="#{data1.material.nombreMaterial}"  />
                                     </rich:column >
                                     <rich:column >
                                        <f:facet name="header">
                                          <h:outputText value="Especificaciones"  />
                                         </f:facet>
                                        <h:inputText value="#{data1.descripcion}" rendered="#{data.tipoResultadoAnalisis.codTipoResultadoAnalisis eq '1'}" />
                                        <h:panelGrid columns="3" rendered="#{data.tipoResultadoAnalisis.codTipoResultadoAnalisis eq '2'}">
                                            <h:inputText value="#{data1.limiteInferior}" size="5" onkeypress="valNum()"/>
                                         <h:outputText value="-" />
                                         <h:inputText value="#{data1.limiteSuperior}" size="5" onkeypress="valNum()"/>
                                        </h:panelGrid>
                                        <h:panelGrid columns="2" rendered="#{data.tipoResultadoAnalisis.codTipoResultadoAnalisis eq '3'}">
                                         <h:outputText value="=" />
                                         <h:inputText value="#{data1.valorExacto}" size="5" onkeypress="valNum()"/>
                                        </h:panelGrid>
                                    </rich:column >
                                     <rich:column >
                                         <f:facet name="header">
                                            <h:outputText value="referencia"  />
                                            </f:facet>
                                            <h:selectOneMenu value="#{data1.tiposReferenciaCc.codReferenciaCc}">
                                                <f:selectItems value="#{ManagedComponentesProducto.listaTiposReferenciaCc}"/>
                                            </h:selectOneMenu>
                                     </rich:column >
                                     
                                     <rich:column >
                                         <f:facet name="header">
                                            <h:outputText value="Estado"  />
                                            </f:facet>
                                            <h:selectOneMenu value="#{data1.estado.codEstadoRegistro}">
                                                <f:selectItem itemValue="1" itemLabel="Activo"/>
                                                <f:selectItem itemValue="2" itemLabel="No Activo"/>
                                            </h:selectOneMenu>
                                     </rich:column>
                                   
                                </rich:dataTable>
                                </center>
                            </rich:panel>

                        </rich:column >
                       
                        


                   </rich:dataTable>
                    
                        <h:commandButton value="Guardar" styleClass="btn" action="#{ManagedComponentesProducto.guardarAnalisisQuimico_Action}"  />
                        <h:commandButton value="Cancelar"  styleClass="btn" action="#{ManagedComponentesProducto.cancelar}"/>
                    </div>            
                </a4j:form>
                 <rich:modalPanel id="panelMaterialesHabilitados" minHeight="250"  minWidth="250"
                                     height="250" width="250"  zindex="200"  headerClass="headerClassACliente"
                                     resizeable="false" style="overflow:auto" >
                        <f:facet name="header">
                            <h:outputText value="Materiales Activos del Producto"/>
                        </f:facet>
                        <center>
                        <a4j:form id="form2">
                            <rich:dataTable value="#{ManagedComponentesProducto.listaMaterialesPrincipioActivo}" var="datam" id="dataMaterialesPrincipioActivo"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#F3F7FD';"
                                    headerClass="headerClassACliente"
                                    columnClasses="tituloCampo">
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Material"  />
                            </f:facet>
                            <h:outputText value="#{datam.nombreMaterial}"  />
                        </rich:column >
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Estado"  />
                            </f:facet>
                            <h:selectOneMenu value="#{datam.estadoRegistro.codEstadoRegistro}">
                                <f:selectItem itemValue="1" itemLabel="Activo"/>
                                <f:selectItem itemValue="2" itemLabel="No Activo"/>
                                <f:selectItem itemValue="3" itemLabel="Variado"/>
                            </h:selectOneMenu>
                       </rich:column>
                      </rich:dataTable>
                       <a4j:commandButton styleClass="btn" value="Aceptar"
                       oncomplete="javascript:Richfaces.hideModalPanel('panelMaterialesHabilitados')" action="#{ManagedComponentesProducto.habilitarMaterialesPrincipioActivo}"
                                           reRender="dataEspecificacionesProducto" />
                        </a4j:form>
                        </center>
                </rich:modalPanel>
            </div>    
        </body>
    </html>
    
</f:view>

