
<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
            <script type="text/javascript" src="../../js/general.js"></script>
            <script>
                function valNumero()
                {
                    if ((event.keyCode < 48 || event.keyCode > 57)&& event.keyCode!=46)
                     {
                        alert('Introduzca sólo Números');
                        event.returnValue = false;
                     }

                }

            </script>
        </head>
        <body >    
            <div style="text-align:center">                            
                <a4j:form id="form1"  >
                    <h:outputText value="#{ManagedEspecificacionesControlCalidad.cargarEditarVersionConcentracionProd}"/>
                     <rich:panel headerClass="headerClassACliente" style="width:80%">
                    <f:facet name="header">
                        <h:outputText value="datos del producto"/>

                    </f:facet>
                    <h:panelGrid columns="3" headerClass="headerClassACliente">
                        <h:outputText value="Producto" styleClass="outputText2" style="font-weight:bold"/>
                       <h:outputText value=" : " styleClass="outputText2" style="font-weight:bold"/>
                       <h:outputText value="#{ManagedEspecificacionesControlCalidad.componentesProd.nombreProdSemiterminado}   " styleClass="outputText2"/>
                        <h:outputText value="Forma Farmaceútica" styleClass="outputText2" style="font-weight:bold"/>
                       <h:outputText value=" : " styleClass="outputText2" style="font-weight:bold"/>
                        <h:outputText value="#{ManagedEspecificacionesControlCalidad.componentesProd.forma.nombreForma}" styleClass="outputText2"/>
                        <h:outputText value="Area de Fabricación" styleClass="outputText2" style="font-weight:bold"/>
                       <h:outputText value=" : " styleClass="outputText2" style="font-weight:bold"/>
                       <h:outputText value="#{ManagedEspecificacionesControlCalidad.componentesProd.areasEmpresa.nombreAreaEmpresa}" styleClass="outputText2"/>
                       <h:outputText value="Estado" styleClass="outputText2" style="font-weight:bold"/>
                       <h:outputText value=" : " styleClass="outputText2" style="font-weight:bold"/>
                       <h:outputText value="#{ManagedEspecificacionesControlCalidad.componentesProd.estadoCompProd.nombreEstadoCompProd}" styleClass="outputText2"/>

                    </h:panelGrid>
                    <rich:panel headerClass="headerClassACliente" style="width:80%">
                            <f:facet name="header">
                                <h:outputText value="Version Activa"/>
                            </f:facet>
                            <h:panelGrid columns="3">
                                <h:outputText value="Nro Version" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value=" : " styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value="#{ManagedEspecificacionesControlCalidad.versionConcentracionProducto.nroVersionEspecificacionProducto}" styleClass="outputText2"/>
                               <h:outputText value="Observacion" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value=" : " styleClass="outputText2" style="font-weight:bold"/>
                               <h:inputTextarea cols="60" value="#{ManagedEspecificacionesControlCalidad.versionConcentracionProducto.observacion}" styleClass="inputText"/>
                               <h:outputText value="Concentracion para" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value=":" styleClass="outputText2" style="font-weight:bold"/>
                                <h:inputText value="#{ManagedEspecificacionesControlCalidad.unidadesProducto}" styleClass="inputText"/>
                            </h:panelGrid>
                   </rich:panel>
               </rich:panel>
                   <br>
                       
                       <rich:dataTable value="#{ManagedEspecificacionesControlCalidad.componentesProdConcentracionList}" var="data" id="dataConcetracion"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#F3F7FD';"
                                    headerClass="headerClassACliente"
                                    columnClasses="tituloCampo">
                        
                                    <rich:column>
                                         <f:facet name="header">
                                            <h:outputText value="Material"  />
                                            </f:facet>
                                            <h:outputText value="#{data.materiales.nombreCCC}" styleClass="outputText2" />
                                     </rich:column >
                                     <rich:column>
                                         <f:facet name="header">
                                            <h:outputText value="Cantidad"  />
                                            </f:facet>
                                            <h:inputText value="#{data.cantidad}" size="8" onkeypress="valNumero();" styleClass="inputText" />
                                     </rich:column >
                                     <rich:column>
                                         <f:facet name="header">
                                            <h:outputText value="Unidad Medida"  />
                                            </f:facet>
                                            <h:selectOneMenu value="#{data.unidadesMedida.codUnidadMedida}" styleClass="inputText">
                                                <f:selectItems value="#{ManagedEspecificacionesControlCalidad.unidadesMedidaList}"/>
                                            </h:selectOneMenu>
                                     </rich:column >
                                     <rich:column>
                                         <f:facet name="header">
                                            <h:outputText value="Nombre Equivalencia"  />
                                            </f:facet>
                                            <h:inputText value="#{data.nombreMaterialEquivalencia}" styleClass="inputText" />
                                     </rich:column >
                                     <rich:column>
                                         <f:facet name="header">
                                            <h:outputText value="Cantidad Equivalencia"  />
                                            </f:facet>
                                            <h:inputText value="#{data.cantidadEquivalencia}" size="8" onkeypress="valNumero();" styleClass="inputText" />
                                     </rich:column >
                                     <rich:column>
                                         <f:facet name="header">
                                            <h:outputText value="Unidad Medida"  />
                                            </f:facet>
                                            <h:selectOneMenu value="#{data.unidadMedidaEquivalencia.codUnidadMedida}" styleClass="inputText">
                                                <f:selectItem itemValue="0" itemLabel="Ninguno"/>
                                                <f:selectItems value="#{ManagedEspecificacionesControlCalidad.unidadesMedidaList}"/>
                                            </h:selectOneMenu>
                                     </rich:column >
                                     <rich:column>
                                         <f:facet name="header">
                                            <h:outputText value="Estado"  />
                                            </f:facet>
                                            <h:selectOneMenu value="#{data.estadoRegistro.codEstadoRegistro}" styleClass="inputText">
                                                <f:selectItem itemValue="2" itemLabel="No Activo"/>
                                                <f:selectItem itemValue="1" itemLabel="Activo"/>
                                            </h:selectOneMenu>
                                     </rich:column >
                   </rich:dataTable>
                    
                    <a4j:commandButton value="Guardar" styleClass="btn" action="#{ManagedEspecificacionesControlCalidad.guardarEditarVersionConcentracion_action}"
                    oncomplete="if(#{ManagedEspecificacionesControlCalidad.mensaje eq '1'}){alert('Se guardo la edicion de la version ');var a =Math.random();window.location.href='navegador_componentesProducto.jsf?ad='+a;}
                    else{alert('#{ManagedEspecificacionesControlCalidad.mensaje}');}"/>
                    <a4j:commandButton value="Cancelar"  styleClass="btn" onclick="window.location='navegador_componentesProducto.jsf'"/>
                    </div>            
                </a4j:form>
               
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
            </div>    
        </body>
    </html>
    
</f:view>

