
<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>
<f:view>
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
            <script type="text/javascript" src="../../js/general.js" ></script>
            <script type="text/javascript">
                function validarRegistroNuevoMaterialGenerico()
                {
                    return (validarRegistroNoVacio(document.getElementById('formRegistrar:nombreMaterialGenerico')));
                }
                function validarEdicionMaterialGenerico()
                {
                    return (validarRegistroNoVacio(document.getElementById('formEditar:nombreMaterialGenerico')));
                }
            </script>
        </head>
        <body >
            <a4j:form id="form1">
                <div align="center">
                    <h:outputText value="#{ManagedMaterialesGenericos.cargarMaterialesGenericos}"/>
                    <h:outputText value="Materiales Genéricos" styleClass="outputTextTituloSistema" style="font-size:15px;font-weight:bold"/>
                    
                    <rich:dataTable value="#{ManagedMaterialesGenericos.materialesGenericosList}"
                                    var="data"
                                    id="dataMaterialesGenericos"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente" >
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value=""  />
                            </f:facet>
                            <h:selectBooleanCheckbox  value="#{data.checked}"  />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Material Genérico"  />
                            </f:facet>
                            <h:outputText  value="#{data.nombreMaterialGenerico}"  />
                        </h:column>
                        
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Estado"  />
                            </f:facet>
                            <h:outputText value="#{data.estadoRegistro.nombreEstadoRegistro}"  />
                        </h:column>
                        
                    </rich:dataTable>
                   
                    <br>
                    <a4j:commandButton value="Registrar" styleClass="btn" action="#{ManagedMaterialesGenericos.agregarMaterialGenerico_action}"
                                       oncomplete="Richfaces.showModalPanel('panelRegistrarMaterialGenerico')" reRender="contenidoRegistrarMaterialGenerico" />
                    <a4j:commandButton value="Editar" styleClass="btn" onclick="if(editarItem('form1:dataMaterialesGenericos')==false){return false;}"
                                       action="#{ManagedMaterialesGenericos.editarMaterialGenerico_action}"
                                       oncomplete="Richfaces.showModalPanel('PanelEditarMaterialGenerico')"
                                       reRender="contenidoEditarMaterialGenerico"/>
                    <a4j:commandButton value="Eliminar" styleClass="btn" onclick="if(editarItem('form1:dataMaterialesGenericos')==false){return false;}"
                                       action="#{ManagedMaterialesGenericos.eliminarMaterialGenerico_action}"
                                       oncomplete="if(#{ManagedMaterialesGenericos.mensaje eq '1'}){alert('Se elimino el material genérico');}else{alert('#{ManagedMaterialesGenericos.mensaje}');}"
                                       reRender="dataMaterialesGenericos"/>
                        

                   
                </div>

               
              
            </a4j:form>

             <rich:modalPanel id="panelRegistrarMaterialGenerico" minHeight="150"  minWidth="550"
                                     height="150" width="550"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" >
                        <f:facet name="header">
                            <h:outputText value="<center>Registro de Material Genérico</center>" escape="false"/>
                        </f:facet>
                        <a4j:form id="formRegistrar">
                        <div align="center">
                            <h:panelGroup id="contenidoRegistrarMaterialGenerico">
                                <h:panelGrid columns="3">
                                        <h:outputText value="Nombre Material Genéricos" styleClass="outputTextBold" />
                                        <h:outputText value="::" styleClass="outputTextBold" />
                                        <h:inputText value="#{ManagedMaterialesGenericos.materialesGenericosRegistrar.nombreMaterialGenerico}" styleClass="inputText" id="nombreMaterialGenerico" size="40"/>
                                        <h:outputText value="Estado" styleClass="outputTextBold" />
                                        <h:outputText value="::" styleClass="outputTextBold" />
                                        <h:outputText value="Activo" styleClass="outputText2" />
                                </h:panelGrid>
                            </h:panelGroup>
                            <br>
                                
                                    <a4j:commandButton styleClass="btn" value="Guardar"  action="#{ManagedMaterialesGenericos.guardarAgregarMaterialGenerico_action}"
                                                       onclick="if(!validarRegistroNuevoMaterialGenerico()){return false;}"
                                                       oncomplete="if(#{ManagedMaterialesGenericos.mensaje eq '1'}){alert('Se registro el material genérico');javascript:Richfaces.hideModalPanel('panelRegistrarMaterialGenerico');}else{alert('#{ManagedMaterialesGenericos.mensaje}');}"
                                                       reRender="dataMaterialesGenericos" />
                                    <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('panelRegistrarMaterialGenerico')" class="btn" />
                        </div>
                        </a4j:form>
            </rich:modalPanel>

           <rich:modalPanel id="PanelEditarMaterialGenerico" minHeight="160"  minWidth="500"
                                     height="160" width="500"
                                     zindex="200"
                                     headerClass="headerClassACliente" >
                        <f:facet name="header">
                            <h:outputText value="<center>Modificación de Material Genérico</center>" escape="false"/>
                        </f:facet>
                        <a4j:form id="formEditar">
                        <h:panelGroup id="contenidoEditarMaterialGenerico">
                             <h:panelGrid columns="3">
                                <h:outputText value="Nombre Material Genérico" styleClass="outputTextBold" />
                                <h:outputText value="::" styleClass="outputTextBold" />
                                <h:outputText value="#{ManagedMaterialesGenericos.materialesGenericosEditar.nombreMaterialGenerico}" styleClass="outputText2" rendered="#{ManagedMaterialesGenericos.materialesGenericosEditar.cantidadVersiones>0}" />
                                <h:inputText value="#{ManagedMaterialesGenericos.materialesGenericosEditar.nombreMaterialGenerico}" styleClass="inputText" id="nombreMaterialGenerico"  size="40"  rendered="#{ManagedMaterialesGenericos.materialesGenericosEditar.cantidadVersiones eq '0'}"/>
                                <h:outputText value="Estado" styleClass="outputTextBold" />
                                <h:outputText value="::" styleClass="outputTextBold" />
                                <h:selectOneMenu value="#{ManagedMaterialesGenericos.materialesGenericosEditar.estadoRegistro.codEstadoRegistro}" styleClass="inputText">
                                    <f:selectItem itemLabel="Activo" itemValue="1"/>
                                    <f:selectItem itemLabel="No Activo" itemValue="2"/>
                                </h:selectOneMenu>
                            </h:panelGrid>
                                
                        </h:panelGroup>
                        <br>
                        <div align="center">
                            <a4j:commandButton styleClass="btn" value="Guardar"  action="#{ManagedMaterialesGenericos.guardarEdicionMaterialGenerico_action}"
                                               onclick="if(!validarEdicionMaterialGenerico()){return false;}"
                                               oncomplete="if(#{ManagedMaterialesGenericos.mensaje eq '1'}){alert('se guardo la edición del material');javascript:Richfaces.hideModalPanel('PanelEditarMaterialGenerico');}else{alert('#{ManagedMaterialesGenericos.mensaje}');}"
                                               reRender="dataMaterialesGenericos" />
                            <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('PanelEditarMaterialGenerico')" class="btn" />
                        </div>
                        </a4j:form>
            </rich:modalPanel>

        </body>
    </html>

</f:view>

