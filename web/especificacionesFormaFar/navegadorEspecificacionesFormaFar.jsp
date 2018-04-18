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
        </head>
        <body >
            <a4j:form id="form1">
                <div align="center">
                    <h:outputText value="#{ManagedEspecificacionesControlCalidad.cargarAnalisisControlCalidad}"/>
                    <rich:panel headerClass="headerClassACliente" style="width:40%">
                        <f:facet name="header">
                            <h:outputText value="Datos de la Forma Farmaceútica" />
                        </f:facet>
                        <h:panelGrid columns="3">
                            <h:outputText styleClass="outputText2" value="Forma Farmaceútica" style="font-weight:bold"/>
                            <h:outputText styleClass="outputText2" value=" : " style="font-weight:bold"/>
                            <h:outputText  value="#{ManagedEspecificacionesControlCalidad.formasFarmaceuticasSeleccionado.nombreForma}" styleClass="outputText2" />
                            <h:outputText styleClass="outputText2" value="Abreviatura" style="font-weight:bold"/>
                            <h:outputText styleClass="outputText2" value=" : " style="font-weight:bold"/>
                            <h:outputText  value="#{ManagedEspecificacionesControlCalidad.formasFarmaceuticasSeleccionado.abreviaturaForma}" styleClass="outputText2" />
                            <h:outputText styleClass="outputText2" value="Unidad Medida" style="font-weight:bold"/>
                            <h:outputText styleClass="outputText2" value=" : " style="font-weight:bold"/>
                            <h:outputText  value="#{ManagedEspecificacionesControlCalidad.formasFarmaceuticasSeleccionado.unidadMedida.nombreUnidadMedida}" styleClass="outputText2" />
                            <h:outputText styleClass="outputText2" value="Especificaciones" style="font-weight:bold"/>
                            <h:outputText styleClass="outputText2" value=" : " style="font-weight:bold"/>
                            <h:selectOneMenu value="#{ManagedEspecificacionesControlCalidad.codTipoAnalisisCc}" styleClass="inputText" id="descriptivo">
                                <f:selectItems value="#{ManagedEspecificacionesControlCalidad.tiposAnalisisCcList}" />
                                <a4j:support action="#{ManagedEspecificacionesControlCalidad.tiposAnalisisControlCalidad_change}" event="onchange" reRender="dataEspecificacionesQuimicasCc" />
                            </h:selectOneMenu>
                         </h:panelGrid>
                    </rich:panel>
                    <br><br>
                    
                    <rich:dataTable value="#{ManagedEspecificacionesControlCalidad.especificacionesCcList}"
                                    var="data"
                                    id="dataEspecificacionesQuimicasCc"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente" >
                        <f:facet name="header">
                            <rich:columnGroup>
                                <rich:column>
                                    <h:outputText value=""/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Especificación"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Tipo Resultado"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Coeficiente"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Unidad"/>
                                </rich:column>
                                <rich:column rendered="#{ManagedEspecificacionesControlCalidad.codTipoAnalisisCc eq 1}">
                                    <h:outputText value="Estado"/>
                                </rich:column>
                            </rich:columnGroup>
                        </f:facet>
                        <rich:column>
                            <h:selectBooleanCheckbox  value="#{data.checked}"  />
                        </rich:column>
                        <rich:column>
                            <h:outputText  value="#{data.nombreEspecificacion}"  />
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.tipoResultadoAnalisis.nombreTipoResultadoAnalisis}"  />
                        </rich:column>
                         <rich:column>
                            <h:outputText value="#{data.coeficiente}">
                            </h:outputText>
                        </rich:column>
                         <rich:column>
                            <h:outputText value="#{data.unidad}">
                            </h:outputText>
                        </rich:column>
                        <rich:column rendered="#{ManagedEspecificacionesControlCalidad.codTipoAnalisisCc eq 1}">
                            <h:outputText value="#{data.tiposEspecificacionesFisicas.nombreTipoEspecificacionFisica}"  />
                            
                        </rich:column>
                    </rich:dataTable>
                    <br>
                        <a4j:commandButton value="Registrar" styleClass="btn" action="#{ManagedEspecificacionesControlCalidad.agregarEspecificacionesQuimicas_action}" oncomplete="Richfaces.showModalPanel('PanelRegistrarEspecificacionesQuimicasCc')" reRender="contenidoRegistrarEspecificacionesQuimicasCc" />
                        <%--a4j:commandButton value="Modificar" styleClass="btn" onclick="if(editarItem('form1:dataEspecificacionesQuimicasCc')==false){return false;}" action="#{ManagedEspecificacionesControlCalidad.editarEspecificacionesQuimicas_action}" oncomplete="Richfaces.showModalPanel('PanelEditarEspecificacionesQuimicasCc')" reRender="contenidoEditarEspecificacionesQuimicasCc"/--%>
                        <a4j:commandButton value="Eliminar" styleClass="btn" onclick="if(confirm('Esta seguro de eliminar?')){if(editarItem('form1:dataEspecificacionesQuimicasCc')==false){return false;}}else{return false;}"  action="#{ManagedEspecificacionesControlCalidad.eliminarEspecificaciones_action}"
                        oncomplete="if(#{ManagedEspecificacionesControlCalidad.mensaje!=''}){alert('#{ManagedEspecificacionesControlCalidad.mensaje}');}else{alert('se elimino la especificacion');}" reRender="dataEspecificacionesQuimicasCc,controles"/>
                        <a4j:commandButton value="Cancelar" styleClass="btn" onclick="window.location='navegadorFormasFarmaceuticas.jsf'" />
                </div>
            </a4j:form>

             <rich:modalPanel id="PanelRegistrarEspecificacionesQuimicasCc" minHeight="400"  minWidth="600"
                                     height="400" width="600"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Registro de Analisis"/>
                        </f:facet>
                        <a4j:form id="formRegistrar">
                        <h:panelGroup id="contenidoRegistrarEspecificacionesQuimicasCc">
                            <div align="center" style="overflow:auto;height:300px">
                            <rich:dataTable value="#{ManagedEspecificacionesControlCalidad.listaEspecificaciones}" var="data2"
                            id="dataNuevasEspecificaciones"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente" >
                                        <rich:column>
                                            <f:facet name="header">
                                                <h:outputText value=""/>
                                            </f:facet>
                                            <h:selectBooleanCheckbox value="#{data2.checked}"/>
                                        </rich:column>
                                        <rich:column>
                                            <f:facet name="header">
                                                <h:outputText value="Nombre Especificación"/>
                                            </f:facet>
                                            <h:outputText value="#{data2.nombreEspecificacion}" styleClass="outputText2"/>
                                        </rich:column>
                                        <rich:column>
                                            <f:facet name="header">
                                                <h:outputText value="Coeficiente"/>
                                            </f:facet>
                                            <h:outputText value="#{data2.coeficiente}" styleClass="outputText2"/>
                                        </rich:column>
                                        <rich:column>
                                            <f:facet name="header">
                                                <h:outputText value="Unidad"/>
                                            </f:facet>
                                            <h:outputText value="#{data2.unidad}" styleClass="outputText2"/>
                                        </rich:column>
                                        <rich:column rendered="#{ManagedEspecificacionesControlCalidad.codTipoAnalisisCc eq 1}">
                                            <f:facet name="header">
                                                <h:outputText value="Estado"/>
                                            </f:facet>
                                            <h:selectOneMenu value="#{data2.tiposEspecificacionesFisicas.codTipoEspecificacionFisica}" styleClass="inputText">
                                                <f:selectItems value="#{ManagedEspecificacionesControlCalidad.tiposEspecificacionesFisicasSelect}"/>
                                            </h:selectOneMenu>
                                        </rich:column>
                           </rich:dataTable>
                            

                                
                                </div>
                                <center>
                                    <a4j:commandButton styleClass="btn" value="Registrar"  action="#{ManagedEspecificacionesControlCalidad.guardarEspecificaciones_action}"
                                    oncomplete="if(#{ManagedEspecificacionesControlCalidad.mensaje!=''}){alert('#{ManagedEspecificacionesControlCalidad.mensaje}');}else{javascript:Richfaces.hideModalPanel('PanelRegistrarEspecificacionesQuimicasCc');}"
                                    reRender="dataEspecificacionesQuimicasCc"/>
                                <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('PanelRegistrarEspecificacionesQuimicasCc')" class="btn" />
                                </center>
                        </h:panelGroup>
                        </a4j:form>
            </rich:modalPanel>
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

        </body>
    </html>

</f:view>

