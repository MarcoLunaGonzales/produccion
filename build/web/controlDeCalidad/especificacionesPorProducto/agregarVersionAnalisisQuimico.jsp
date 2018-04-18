
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
                   A4J.AJAX.onError = function(req,status,message){
            window.alert("Ocurrio un error: "+message);
            }
            A4J.AJAX.onExpired = function(loc,expiredMsg){
            if(window.confirm("Ocurrio un error al momento realizar la transaccion: "+expiredMsg+" location: "+loc)){
            return loc;
            } else {
            return false;
            }
            }
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
                    <h:outputText value="#{ManagedEspecificacionesControlCalidad.cargarAgregarVersionAnalisisQuimico}"/>
                  <rich:panel headerClass="headerClassACliente" style="width:60%">
                    <f:facet name="header">
                        <h:outputText value="DATOS DEL PRODUCTO"/>

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
                               <h:outputText value="#{ManagedEspecificacionesControlCalidad.versionEspecificacionesProductoQuimica.nroVersionEspecificacionProducto}" styleClass="outputText2"/>
                               <h:outputText value="Observacion" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value=" : " styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value="#{ManagedEspecificacionesControlCalidad.versionEspecificacionesProductoQuimica.observacion}" styleClass="outputText2"/>
                            </h:panelGrid>
                    </rich:panel>
                    <rich:panel headerClass="headerClassACliente" style="width:80%">
                            <f:facet name="header">
                                <h:outputText value="Datos Nueva Version"/>
                            </f:facet>
                            <h:panelGrid columns="3">
                               <h:outputText value="Observacion" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value=" : " styleClass="outputText2" style="font-weight:bold"/>
                               <h:inputTextarea cols="60" value="#{ManagedEspecificacionesControlCalidad.versionEspecificacionRegistrar.observacion}" styleClass="inputText"/>

                            </h:panelGrid>
                    </rich:panel>
                </rich:panel>
                   <br>
                       <a4j:commandButton styleClass="btn" value="Materiales Principio Activo"
                        oncomplete="javascript:Richfaces.showModalPanel('panelMaterialesHabilitados')" reRender="dataMaterialesPrincipioActivo" />
                        <rich:dataTable value="#{ManagedEspecificacionesControlCalidad.listaEspecificacionesQuimicasCc}" var="data" id="dataEspecificacionesQuimicas"
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
                                            <h:outputText value="Nombre Material CC"  />
                                            </f:facet>
                                            <h:outputText value="#{data1.material.nombreCCC}" rendered="#{data1.materialesCompuestosCc.codMaterialCompuestoCc eq '0'}"  />
                                            <h:outputText value="#{data1.materialesCompuestosCc.nombreMaterialCompuestoCc}" rendered="#{data1.materialesCompuestosCc.codMaterialCompuestoCc>0}"  />

                                     </rich:column >
                                      <rich:column>
                                         <f:facet name="header">
                                            <h:outputText value="Nombre Baco"  />
                                            </f:facet>
                                            <h:outputText value="#{data1.material.nombreMaterial}" rendered="#{data1.materialesCompuestosCc.codMaterialCompuestoCc eq '0'}"  />
                                     </rich:column >
                                     <rich:column >
                                        <f:facet name="header">
                                          <h:outputText value="Especificaciones"  />
                                         </f:facet>
                                        <h:inputText value="#{data1.descripcion}" rendered="#{data.tipoResultadoAnalisis.codTipoResultadoAnalisis eq '1'}" styleClass="inputText"/>
                                        <h:panelGrid columns="3" rendered="#{data.tipoResultadoAnalisis.codTipoResultadoAnalisis eq '2'}">
                                            <h:inputText value="#{data1.limiteInferior}" size="5" onkeypress="valNumero()" styleClass="inputText"/>
                                         <h:outputText value="-" />
                                         <h:inputText value="#{data1.limiteSuperior}" size="5" onkeypress="valNumero()" styleClass="inputText"/>
                                        </h:panelGrid>
                                        <h:panelGrid columns="2" rendered="#{(data.tipoResultadoAnalisis.codTipoResultadoAnalisis != '2') &&(data.tipoResultadoAnalisis.codTipoResultadoAnalisis != '1')}">
                                            <h:outputText value="#{data.coeficiente} #{data.tipoResultadoAnalisis.simbolo}" styleClass="outputText2" />
                                         <h:inputText value="#{data1.valorExacto}" size="5" onkeypress="valNumero()" styleClass="inputText"/>
                                        </h:panelGrid>
                                    </rich:column >
                                     <rich:column >
                                         <f:facet name="header">
                                            <h:outputText value="referencia"  />
                                            </f:facet>
                                            <h:selectOneMenu value="#{data1.tiposReferenciaCc.codReferenciaCc}" styleClass="inputText">
                                                <f:selectItems value="#{ManagedEspecificacionesControlCalidad.listaTiposReferenciaCc}"/>
                                            </h:selectOneMenu>
                                     </rich:column >
                                     
                                     <rich:column >
                                         <f:facet name="header">
                                            <h:outputText value="Estado"  />
                                            </f:facet>
                                            <h:selectOneMenu value="#{data1.estado.codEstadoRegistro}" styleClass="inputText">
                                                <f:selectItem itemValue="1" itemLabel="Activo"/>
                                                <f:selectItem itemValue="2" itemLabel="No Activo"/>
                                            </h:selectOneMenu>
                                     </rich:column>
                                   
                                </rich:dataTable>
                                </center>
                            </rich:panel>

                        </rich:column >
                       
                        


                   </rich:dataTable>
                    
                        <a4j:commandButton value="Guardar" styleClass="btn" action="#{ManagedEspecificacionesControlCalidad.guardarAnalisisQuimico_Action}"
                        oncomplete="if(#{ManagedEspecificacionesControlCalidad.mensaje eq '1'}){Richfaces.showModalPanel('ajaxLoadingModalBox',{width:100, top:100}); var a=Math.random();window.location.href='navegadorVersionesAnalisisQuimico.jsf?a='+a;alert('Se registraron las especificaciones quimicas para el producto');}
                        else{alert('#{ManagedEspecificacionesControlCalidad.mensaje}')}" timeout="10000"/>
                        <a4j:commandButton value="Cancelar"  styleClass="btn" oncomplete="window.location.href='navegadorVersionesAnalisisQuimico.jsf'"/>
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
                            <rich:dataTable value="#{ManagedEspecificacionesControlCalidad.listaMaterialesPrincipioActivo}" var="datam" id="dataMaterialesPrincipioActivo"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#F3F7FD';"
                                    headerClass="headerClassACliente"
                                    columnClasses="tituloCampo">
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Material"  />
                            </f:facet>
                            <h:outputText value="#{datam.nombreMaterial}" />
                        </rich:column >
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Estado"  />
                            </f:facet>
                            <h:selectOneMenu value="#{datam.estadoRegistro.codEstadoRegistro}" styleClass="inputText">
                                <f:selectItem itemValue="1" itemLabel="Activo"/>
                                <f:selectItem itemValue="2" itemLabel="No Activo"/>
                                <f:selectItem itemValue="3" itemLabel="Variado"/>
                            </h:selectOneMenu>
                       </rich:column>
                      </rich:dataTable>
                       <a4j:commandButton styleClass="btn" value="Aceptar"
                       oncomplete="javascript:Richfaces.hideModalPanel('panelMaterialesHabilitados')" action="#{ManagedEspecificacionesControlCalidad.habilitarMaterialesPrincipioActivo}"
                                           reRender="dataEspecificacionesProducto" />
                      <a4j:commandButton styleClass="btn" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('panelMaterialesHabilitados')"  />
                        </a4j:form>
                        </center>
                </rich:modalPanel>
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

