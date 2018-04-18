<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>
<f:view>

    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../../../css/ventas.css" />
            <script type="text/javascript" src="../../../js/general.js" ></script>
           
        </head>
        <body >
            <a4j:form id="form1">
                <div align="center">
                    <h:outputText value="#{ManagedDocumentosBiblioteca.cargarRestriccionPaginas}"/>
                    <h3>Restricciones Documento</h3>
                    
                    
                    <rich:dataTable value="#{ManagedDocumentosBiblioteca.documentacionRestriccionPaginasList}"
                                    var="data"
                                    id="dataRestricciones"
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
                                <h:outputText value="Cargo"  />
                            </f:facet>
                            <h:outputText value="#{data.cargos.descripcionCargo}"  />
                        </h:column>
                         <h:column>
                            <f:facet name="header">
                                <h:outputText value="Pagina Inicio"  />
                            </f:facet>
                            <h:outputText value="#{data.paginaInicio}"  />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Pagina Final"  />
                            </f:facet>
                            <h:outputText value="#{data.paginaFinal}"  />
                        </h:column>
                       
                    </rich:dataTable>
                   
                    <br>
                        <a4j:commandButton value="Registrar" styleClass="btn" action="#{ManagedDocumentosBiblioteca.agregarRestriccionPagina_action}"
                        oncomplete="Richfaces.showModalPanel('panelRegistrarRestriccion')" reRender="contenidoRegistrarTransaccion" />
                        <%--a4j:commandButton onclick="if(editarItem('form1:dataRestricciones')==false){return false;}" value="Editar" styleClass="btn" action="#{ManagedDocumentosBiblioteca.editarTipoDocumentoBiblioteca}"
                        oncomplete="Richfaces.showModalPanel('panelEditarTipoDocumentoBiblioteca')" reRender="contenidoEditarTipoDocumentoBiblioteca" />
                        <a4j:commandButton value="Eliminar" styleClass="btn" onclick="if(confirm('Esta seguro de eliminar el tipo de documento?')){if(editarItem('form1:dataRestricciones')==false){return false;}}else{return false;}"
                        action="#{ManagedDocumentosBiblioteca.eliminarTiposDocumentoBiblioteca_action}"
                        oncomplete="if(#{ManagedDocumentosBiblioteca.mensaje eq '1'}){alert('Se elimino el tipo de documento');}else{alert('#{ManagedDocumentosBiblioteca.mensaje}');}" reRender="dataRestricciones"/--%>

                   
                </div>

               
              
            </a4j:form>
            <rich:modalPanel id="panelEditarTipoDocumentoBiblioteca" minHeight="150"  minWidth="450"
                                     height="150" width="450"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Edicion de Tipos de Documento Biblioteca"/>
                        </f:facet>
                        <a4j:form id="formEditar">
                            <center>
                        <h:panelGroup id="contenidoEditarTipoDocumentoBiblioteca">
                            <h:panelGrid columns="3">
                                <h:outputText value="Nombre Tipo Documento" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                <h:inputText styleClass="inputText" value="#{ManagedDocumentosBiblioteca.tiposDocumentoBibliotecaEditar.nombreTipoDocumentoBiblioteca}"/>
                                <h:outputText value="Estado" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                <h:selectOneMenu value="#{ManagedDocumentosBiblioteca.tiposDocumentoBibliotecaEditar.estadoRegistro.codEstadoRegistro}" styleClass="inputText">
                                    <f:selectItem itemValue="1" itemLabel="Activo"/>
                                    <f:selectItem itemValue="2" itemLabel="No Activo"/>
                                </h:selectOneMenu>
                                
                            </h:panelGrid>
                                <div align="center">
                                    <a4j:commandButton styleClass="btn" value="Registrar"  action="#{ManagedDocumentosBiblioteca.guardarEdicionTiposDocumentosBiblioteca_action}"
                                    reRender="dataRestricciones"
                                    oncomplete="if(#{ManagedDocumentosBiblioteca.mensaje eq '1'}){alert('Se edito el tipo de documento');javascript:Richfaces.hideModalPanel('panelEditarTipoDocumentoBiblioteca');}
                                    else{alert('#{ManagedDocumentosBiblioteca.mensaje}');}"/>
                                <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('panelEditarTipoDocumentoBiblioteca')" class="btn" />
                                </div>
                        </h:panelGroup>
                        </center>
                        </a4j:form>
            </rich:modalPanel>

             <rich:modalPanel id="panelRegistrarRestriccion" minHeight="140"  minWidth="450"
                                     height="140" width="45"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Registro de Tipos de Documento Biblioteca"/>
                        </f:facet>
                        <a4j:form id="formRegistrar">
                            <center>
                        <h:panelGroup id="contenidoRegistrarTransaccion">
                            <h:panelGrid columns="3">
                                <h:outputText value="Pagina Inicio" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                <h:selectOneMenu value="#{ManagedDocumentosBiblioteca.documentacionRestriccionPaginasRegistrar.cargos.codigoCargo}" styleClass="inputText">
                                    <f:selectItems value="#{ManagedDocumentosBiblioteca.cargosList}"/>
                                </h:selectOneMenu>
                                <h:outputText value="Pagina Inicio" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                <h:inputText styleClass="inputText" value="#{ManagedDocumentosBiblioteca.documentacionRestriccionPaginasRegistrar.paginaInicio}"/>
                                <h:outputText value="Pagina Final" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                <h:inputText styleClass="inputText" value="#{ManagedDocumentosBiblioteca.documentacionRestriccionPaginasRegistrar.paginaFinal}"/>
                            </h:panelGrid>
                                <div align="center">
                                    <a4j:commandButton styleClass="btn" value="Registrar"  action="#{ManagedDocumentosBiblioteca.guardarDocumentacionRestriccionPagina_action}"
                                    reRender="dataRestricciones"
                                    oncomplete="if(#{ManagedDocumentosBiblioteca.mensaje eq '1'}){alert('Se registro la restriccion');javascript:Richfaces.hideModalPanel('panelRegistrarRestriccion');}
                                    else{alert('#{ManagedDocumentosBiblioteca.mensaje}');}"/>
                                <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('panelRegistrarRestriccion')" class="btn" />
                                </div>
                        </h:panelGroup>
                        </center>
                        </a4j:form>
            </rich:modalPanel>

        </body>
    </html>

</f:view>

