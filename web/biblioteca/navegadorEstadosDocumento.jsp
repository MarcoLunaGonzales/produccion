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
           
        </head>
        <body >
            <a4j:form id="form1">
                <div align="center">
                    <h:outputText value="#{ManagedDocumentosBiblioteca.cargarEstadosDocumento}"/>
                    <h3>Estados Documento</h3>
                    
                    
                    <rich:dataTable value="#{ManagedDocumentosBiblioteca.estadosDocumentosList}"
                                    var="data"
                                    id="dataEstadosDocumento"
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
                                <h:outputText value="Nombre Estado Documento"  />
                            </f:facet>
                            <h:outputText value="#{data.nombreEstadoDocumento}"  />
                        </h:column>
                         <h:column>
                            <f:facet name="header">
                                <h:outputText value="Estado Registro"  />
                            </f:facet>
                            <h:outputText value="#{data.estadoRegistro.nombreEstadoRegistro}"  />
                        </h:column>
                       
                    </rich:dataTable>
                   
                    <br>
                        <a4j:commandButton value="Registrar" styleClass="btn" action="#{ManagedDocumentosBiblioteca.agregarEstadosDocumento_action}"
                        oncomplete="Richfaces.showModalPanel('panelRegistrarEstadosDocumento')" reRender="contenidoRegistrarEstadosDocumento" />
                        <a4j:commandButton onclick="if(editarItem('form1:dataEstadosDocumento')==false){return false;}" value="Editar" styleClass="btn" action="#{ManagedDocumentosBiblioteca.editarEstadosDocumento_action}"
                        oncomplete="Richfaces.showModalPanel('panelEditarEstadosDocumento')" reRender="contenidoEditarEstadosDocumento" />
                        <a4j:commandButton value="Eliminar" styleClass="btn" onclick="if(confirm('Esta seguro de eliminar el estado documento?')){if(editarItem('form1:dataEstadosDocumento')==false){return false;}}else{return false;}"
                        action="#{ManagedDocumentosBiblioteca.eliminarEstadosDocumento_action}"
                        oncomplete="if(#{ManagedDocumentosBiblioteca.mensaje eq '1'}){alert('Se elimino el estado documento');}else{alert('#{ManagedDocumentosBiblioteca.mensaje}');}" reRender="dataEstadosDocumento"/>

                   
                </div>

               
              
            </a4j:form>
            <rich:modalPanel id="panelEditarEstadosDocumento" minHeight="150"  minWidth="450"
                                     height="150" width="450"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Edicion de Estados Documento"/>
                        </f:facet>
                        <a4j:form id="formEditar">
                            <center>
                        <h:panelGroup id="contenidoEditarEstadosDocumento">
                            <h:panelGrid columns="3">
                                <h:outputText value="Nombre estado documento" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                <h:inputText styleClass="inputText" value="#{ManagedDocumentosBiblioteca.estadosDocumentoEditar.nombreEstadoDocumento}"/>
                                <h:outputText value="Estado" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                <h:selectOneMenu value="#{ManagedDocumentosBiblioteca.estadosDocumentoEditar.estadoRegistro.codEstadoRegistro}" styleClass="inputText">
                                    <f:selectItem itemValue="1" itemLabel="Activo"/>
                                    <f:selectItem itemValue="2" itemLabel="No Activo"/>
                                </h:selectOneMenu>
                                
                            </h:panelGrid>
                                <div align="center">
                                    <a4j:commandButton styleClass="btn" value="Guardar"  action="#{ManagedDocumentosBiblioteca.guardarEdicionEstadosDocumento_action}"
                                    reRender="dataEstadosDocumento"
                                    oncomplete="if(#{ManagedDocumentosBiblioteca.mensaje eq '1'}){alert('Se guardo la edicion del estado documento');javascript:Richfaces.hideModalPanel('panelEditarEstadosDocumento');}
                                    else{alert('#{ManagedDocumentosBiblioteca.mensaje}');}"/>
                                <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('panelEditarEstadosDocumento')" class="btn" />
                                </div>
                        </h:panelGroup>
                        </center>
                        </a4j:form>
            </rich:modalPanel>

             <rich:modalPanel id="panelRegistrarEstadosDocumento" minHeight="140"  minWidth="450"
                                     height="140" width="45"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Registro de Estados Documento"/>
                        </f:facet>
                        <a4j:form id="formRegistrar">
                            <center>
                        <h:panelGroup id="contenidoRegistrarEstadosDocumento">
                            <h:panelGrid columns="3">
                                <h:outputText value="Nombre estado documento" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                <h:inputText styleClass="inputText" value="#{ManagedDocumentosBiblioteca.estadosDocumentoAgregar.nombreEstadoDocumento}"/>
                            </h:panelGrid>
                                <div align="center">
                                    <a4j:commandButton styleClass="btn" value="Guardar"  action="#{ManagedDocumentosBiblioteca.guardarNuevoRegistroEstadosDocumento_action}"
                                    reRender="dataEstadosDocumento"
                                    oncomplete="if(#{ManagedDocumentosBiblioteca.mensaje eq '1'}){alert('Se registro el estado documento');javascript:Richfaces.hideModalPanel('panelRegistrarEstadosDocumento');}
                                    else{alert('#{ManagedDocumentosBiblioteca.mensaje}');}"/>
                                <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('panelRegistrarEstadosDocumento')" class="btn" />
                                </div>
                        </h:panelGroup>
                        </center>
                        </a4j:form>
            </rich:modalPanel>

        </body>
    </html>

</f:view>

