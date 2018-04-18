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
                function validarEdicion()
                {
                    if(parseInt(document.getElementById("formEditar:cantidadEditar").innerHTML)>0)
                    {
                        return confirm("Esta seguro de editar, existen"+document.getElementById("formEditar:cantidadEditar").innerHTML+" versiones de producto que utilizan el dato");

                    }
                    return true;
                }
            </script>
          
        </head>
        <body >
            <a4j:form id="form1">
                <div align="center">
                    <h:outputText value="#{ManagedTamaniosCapsulasProduccion.cargarTamaniosCapsulasProduccion}"/>
                    <h:outputText value="Tamaños Capsulas Produccion" styleClass="outputTextBold" style="font-size:14px;" />
                    <rich:dataTable value="#{ManagedTamaniosCapsulasProduccion.tamaniosCapsulasProduccionList}"
                                    var="data" style="margin-top:1em"
                                    id="dataTamaniosCapsula"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente" >
                        <f:facet name="header">
                            <rich:columnGroup>
                                <rich:column>
                                    <h:outputText value=""/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Nombre Tamanio<br>Capsula" escape="false"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Descripción" escape="false"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Cantidad Productos" escape="false"/>
                                </rich:column>
                            </rich:columnGroup>
                        </f:facet>
                        <rich:column>
                            <h:selectBooleanCheckbox  value="#{data.checked}"  />
                        </rich:column>
                        <rich:column>
                            <h:outputText  value="#{data.nombreTamanioCapsulaProduccion}"  />
                        </rich:column>
                        <rich:column>
                            <h:outputText  value="#{data.descripcionTamanioCapsulaProduccion}"  />
                        </rich:column>
                        <rich:column>
                            <h:outputText  value="#{data.cantidadProductos}"  />
                        </rich:column>
                    </rich:dataTable>


                    <br>
                        <a4j:commandButton value="Registrar" styleClass="btn" action="#{ManagedTamaniosCapsulasProduccion.agregarTamanioCapsulaProduccion_action}"
                        oncomplete="Richfaces.showModalPanel('PanelRegistroTamanioCapsula')" reRender="contenidoRegistrarTamanioCapsula" />
                        <a4j:commandButton value="Modificar" styleClass="btn" onclick="if(editarItem('form1:dataTamaniosCapsula')==false){return false;}" action="#{ManagedTamaniosCapsulasProduccion.editarTamanioCapsulaProduccion_action}"
                        oncomplete="Richfaces.showModalPanel('PanelEditarTamanioCapsula')" reRender="contenidoEditarTamanioCapsula"/>
                        <a4j:commandButton value="Eliminar" styleClass="btn" onclick="if(confirm('Esta seguro de eliminar el tamaño de capsula?')){if(editarItem('form1:dataTamaniosCapsula')==false){return false;}}else{return false;}"  action="#{ManagedTamaniosCapsulasProduccion.eliminarTamanioCapsulaProduccion_action}"
                        oncomplete="if(#{ManagedTamaniosCapsulasProduccion.mensaje eq '1'}){alert('Se elimino el tamaño de capsula')}else{alert('#{ManagedTamaniosCapsulasProduccion.mensaje}');}" reRender="dataTamaniosCapsula"/>

                   
                </div>

               
              
            </a4j:form>

             <rich:modalPanel id="PanelRegistroTamanioCapsula" minHeight="180"  minWidth="600"
                                     height="180" width="600"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="<center>Registro de Tamaño de Capsula</center>" escape="false"/>
                        </f:facet>
                        <a4j:form id="formRegistrar">
                        <h:panelGroup id="contenidoRegistrarTamanioCapsula">
                            <h:panelGrid columns="3">
                                <h:outputText value="Nombre tamaño capsula" styleClass="outputTextBold" />
                                <h:outputText value="::" styleClass="outputTextBold" />
                                <h:inputText value="#{ManagedTamaniosCapsulasProduccion.tamaniosCapsulasProduccionAgregar.nombreTamanioCapsulaProduccion}" styleClass="inputText" id="nombreTamanio" style="width:25em"  />
                                <h:outputText value="Descripción" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold" />
                                <h:inputTextarea value="#{ManagedTamaniosCapsulasProduccion.tamaniosCapsulasProduccionAgregar.descripcionTamanioCapsulaProduccion}" styleClass="inputText" id="descripcion"  style="width:25em"  />
                                 
                            </h:panelGrid>
                                <div align="center" style="margin-top:1em;">
                                    <a4j:commandButton styleClass="btn" value="Registrar"  action="#{ManagedTamaniosCapsulasProduccion.guardarAgregarTamanioCapsulaProduccion_action}"
                                    oncomplete="if(#{ManagedTamaniosCapsulasProduccion.mensaje eq '1'}){alert('Se registro el tamaño de capsula');javascript:Richfaces.hideModalPanel('PanelRegistroTamanioCapsula');}else{alert('#{ManagedTamaniosCapsulasProduccion.mensaje}');}"
                                    reRender="dataTamaniosCapsula"/>
                                    <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('PanelRegistroTamanioCapsula')" class="btn" />
                                </div>
                        </h:panelGroup>
                        </a4j:form>
            </rich:modalPanel>

           <rich:modalPanel id="PanelEditarTamanioCapsula" minHeight="180"  minWidth="600"
                                     height="180" width="600"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :hidden" >
                        <f:facet name="header">
                            <h:outputText value="Modificación de Tamaño de Capsula"/>
                        </f:facet>
                        <a4j:form id="formEditar">
                        <h:panelGroup id="contenidoEditarTamanioCapsula">
                             <h:panelGrid columns="3">
                                <h:outputText value="Nombre tamaño capsula" styleClass="outputTextBold" />
                                <h:outputText value="::" styleClass="outputTextBold" />
                                <h:inputText value="#{ManagedTamaniosCapsulasProduccion.tamaniosCapsulasProduccionEditar.nombreTamanioCapsulaProduccion}" styleClass="inputText" id="nombreTamanioEditar" style="width:25em"  />
                                <h:outputText value="Descripción" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold" />
                                <h:inputTextarea value="#{ManagedTamaniosCapsulasProduccion.tamaniosCapsulasProduccionEditar.descripcionTamanioCapsulaProduccion}" styleClass="inputText" id="descripcionEditar"  style="width:25em"  />
                                <h:outputText value="Cantidad de Productos que utilizan el tamaño de capsula" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold" />
                                <h:outputText value="#{ManagedTamaniosCapsulasProduccion.tamaniosCapsulasProduccionEditar.cantidadProductos}" styleClass="outputText2" id="cantidadEditar"/>
                            </h:panelGrid>
                                <div align="center" style="margin-top:1em">
                                    <a4j:commandButton styleClass="btn" onclick="if(!validarEdicion()){return false;}"
                                    value="Guardar" action="#{ManagedTamaniosCapsulasProduccion.guardarEdicionTamanioCapsulaProduccion_action}"
                                    oncomplete="if(#{ManagedTamaniosCapsulasProduccion.mensaje eq '1'}){alert('Se edito el tamaño de capsula');javascript:Richfaces.hideModalPanel('PanelEditarTamanioCapsula');}else{alert('#{ManagedTamaniosCapsulasProduccion.mensaje}');}"
                                    reRender="dataTamaniosCapsula" />
                                    <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('PanelEditarTamanioCapsula')" class="btn" />
                                </div>
                        </h:panelGroup>
                        </a4j:form>
            </rich:modalPanel>
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
        </body>
    </html>

</f:view>

