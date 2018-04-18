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
                    <h:outputText value="#{ManagedComponentesProducto.cargarViasAdministracioProducto}"/>
                    <h3>Vias Administracion Producto</h3>
                    
                    
                    <rich:dataTable value="#{ManagedComponentesProducto.viasAdministracionProductoList}"
                                    var="data"
                                    id="dataViaAdministracion"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente" style="margin-top:12px;">
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value=""  />
                            </f:facet>
                            <h:selectBooleanCheckbox  value="#{data.checked}"  />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Nombre Via Administracion"  />
                            </f:facet>
                            <h:outputText value="#{data.nombreViaAdministracionProducto}"  />
                        </h:column>
                         <h:column>
                            <f:facet name="header">
                                <h:outputText value="Estado Registro"  />
                            </f:facet>
                            <h:outputText value="#{data.estadoRegistro.nombreEstadoRegistro}"  />
                        </h:column>
                       
                    </rich:dataTable>
                   
                    <br>
                        <a4j:commandButton value="Registrar" styleClass="btn" action="#{ManagedComponentesProducto.agregarViasAdministracionProducto_action}"
                        oncomplete="Richfaces.showModalPanel('panelRegistrarViaAdministracion')" reRender="contenidoRegistrarViaAdministracion" />
                        <a4j:commandButton onclick="if(editarItem('form1:dataViaAdministracion')==false){return false;}" value="Editar" styleClass="btn" action="#{ManagedComponentesProducto.editarViasAdministracionProducto_action}"
                        oncomplete="Richfaces.showModalPanel('panelEditarViaAdministracion')" reRender="contenidoEditarViaAdminsitracion" />
                        <a4j:commandButton value="Eliminar" styleClass="btn" onclick="if(confirm('Esta seguro de eliminar via de administración?')){if(editarItem('form1:dataViaAdministracion')==false){return false;}}else{return false;}"
                        action="#{ManagedComponentesProducto.eliminarViaAdministracionProducto_action}"
                        oncomplete="if(#{ManagedComponentesProducto.mensaje eq '1'}){alert('Se elimino la via de administración');}else{alert('#{ManagedComponentesProducto.mensaje}');}" reRender="dataViaAdministracion"/>

                   
                </div>

               
              
            </a4j:form>
            <rich:modalPanel id="panelEditarViaAdministracion" minHeight="150"  minWidth="450"
                                     height="150" width="450"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Edicion de Tipos de Documento Biblioteca"/>
                        </f:facet>
                        <a4j:form id="formEditar">
                            <center>
                        <h:panelGroup id="contenidoEditarViaAdminsitracion">
                            <h:panelGrid columns="3">
                                <h:outputText value="Nombre Via Administracion" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                <h:inputText styleClass="inputText" value="#{ManagedComponentesProducto.viasAdministracionProductoBean.nombreViaAdministracionProducto}"/>
                                <h:outputText value="Estado" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                <h:selectOneMenu value="#{ManagedComponentesProducto.viasAdministracionProductoBean.estadoRegistro.codEstadoRegistro}" styleClass="inputText">
                                    <f:selectItem itemValue="1" itemLabel="Activo"/>
                                    <f:selectItem itemValue="2" itemLabel="No Activo"/>
                                </h:selectOneMenu>
                                
                            </h:panelGrid>
                                <div align="center" style="margin-top:6px">
                                    <a4j:commandButton styleClass="btn" value="Guardar"  action="#{ManagedComponentesProducto.guardarEdicionViaAdministracionProducto_action}"
                                    reRender="dataViaAdministracion"
                                    oncomplete="if(#{ManagedComponentesProducto.mensaje eq '1'}){alert('Se edito la via de administración');javascript:Richfaces.hideModalPanel('panelEditarViaAdministracion');}
                                    else{alert('#{ManagedComponentesProducto.mensaje}');}"/>
                                <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('panelEditarViaAdministracion')" class="btn" />
                                </div>
                        </h:panelGroup>
                        </center>
                        </a4j:form>
            </rich:modalPanel>

             <rich:modalPanel id="panelRegistrarViaAdministracion" minHeight="140"  minWidth="450"
                                     height="140" width="45"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Registro de Vias de Administracion Producto"/>
                        </f:facet>
                        <a4j:form id="formRegistrar">
                            <center>
                        <h:panelGroup id="contenidoRegistrarViaAdministracion">
                            <h:panelGrid columns="3">
                                <h:outputText value="Nombre Via Administracion" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                <h:inputText styleClass="inputText" value="#{ManagedComponentesProducto.viasAdministracionProductoBean.nombreViaAdministracionProducto}"/>
                                <h:outputText value="Estado" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="Activo" styleClass="outputText2" style="font-weight:bold"/>
                            </h:panelGrid>
                                <div align="center" style="margin-top:8px">
                                    <a4j:commandButton styleClass="btn" value="Registrar"  action="#{ManagedComponentesProducto.guardarNuevaViaAdministracionProducto_action}"
                                    reRender="dataViaAdministracion"
                                    oncomplete="if(#{ManagedComponentesProducto.mensaje eq '1'}){alert('Se registro la vida de administración');javascript:Richfaces.hideModalPanel('panelRegistrarViaAdministracion');}
                                    else{alert('#{ManagedComponentesProducto.mensaje}');}"/>
                                <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('panelRegistrarViaAdministracion')" class="btn" />
                                </div>
                        </h:panelGroup>
                        </center>
                        </a4j:form>
            </rich:modalPanel>

        </body>
    </html>

</f:view>

