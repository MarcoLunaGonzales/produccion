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
                    <h:outputText value="#{ManagedDocumentosBiblioteca.cargarTiposDocumentacionPreguntas}"/>
                    <h3>Tipos Preguntas Documentación</h3>
                    
                    
                    <rich:dataTable value="#{ManagedDocumentosBiblioteca.tiposDocumentacionPreguntasList}"
                                    var="data"
                                    id="dataTiposPreguntas"
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
                                <h:outputText value="Nombre Tipo Pregunta"  />
                            </f:facet>
                            <h:outputText value="#{data.nombreTipoDocumentacionPregunta}"  />
                        </h:column>
                         <h:column>
                            <f:facet name="header">
                                <h:outputText value="Estado Registro"  />
                            </f:facet>
                            <h:outputText value="#{data.estadoRegistro.nombreEstadoRegistro}"  />
                        </h:column>
                       
                    </rich:dataTable>
                   
                    <br>
                        <a4j:commandButton value="Registrar" styleClass="btn" action="#{ManagedDocumentosBiblioteca.agregarTiposDocumentacionPreguntas_action}"
                        oncomplete="Richfaces.showModalPanel('panelRegistrarTipoPregunta')" reRender="contenidoRegistrarTipoPregunta" />
                        <a4j:commandButton onclick="if(editarItem('form1:dataTiposPreguntas')==false){return false;}" value="Editar" styleClass="btn" action="#{ManagedDocumentosBiblioteca.editarTiposDocumentacionPreguntas_action}"
                        oncomplete="Richfaces.showModalPanel('panelEditarTiposPreguntas')" reRender="contenidoEditarTiposPreguntas" />
                        <a4j:commandButton value="Eliminar" styleClass="btn" onclick="if(confirm('Esta seguro de eliminar el tipo de Pregunta?')){if(editarItem('form1:dataTiposPreguntas')==false){return false;}}else{return false;}"
                        action="#{ManagedDocumentosBiblioteca.eliminarTiposDocumentacionPreguntas_action}"
                        oncomplete="if(#{ManagedDocumentosBiblioteca.mensaje eq '1'}){alert('Se elimino el tipo de pregunta');}else{alert('#{ManagedDocumentosBiblioteca.mensaje}');}" reRender="dataTiposPreguntas"/>

                   
                </div>

               
              
            </a4j:form>
            <rich:modalPanel id="panelEditarTiposPreguntas" minHeight="150"  minWidth="450"
                                     height="150" width="450"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Edicion de Tipos de Pregunta"/>
                        </f:facet>
                        <a4j:form id="formEditar">
                            <center>
                        <h:panelGroup id="contenidoEditarTiposPreguntas">
                            <h:panelGrid columns="3">
                                <h:outputText value="Nombre Tipo Pregunta " styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                <h:inputText styleClass="inputText" value="#{ManagedDocumentosBiblioteca.tiposDocumentacionPreguntasBean.nombreTipoDocumentacionPregunta}" size="35"/>
                                <h:outputText value="Estado" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                <h:selectOneMenu value="#{ManagedDocumentosBiblioteca.tiposDocumentacionPreguntasBean.estadoRegistro.codEstadoRegistro}" styleClass="inputText">
                                    <f:selectItem itemValue="1" itemLabel="Activo"/>
                                    <f:selectItem itemValue="2" itemLabel="No Activo"/>
                                </h:selectOneMenu>
                                
                            </h:panelGrid>
                                <div align="center">
                                    <a4j:commandButton styleClass="btn" value="Guardar"  action="#{ManagedDocumentosBiblioteca.guardarEdicionTiposDocumentosPreguntas_action}"
                                    reRender="dataTiposPreguntas"
                                    oncomplete="if(#{ManagedDocumentosBiblioteca.mensaje eq '1'}){alert('Se edito el tipo de pregunta');javascript:Richfaces.hideModalPanel('panelEditarTiposPreguntas');}
                                    else{alert('#{ManagedDocumentosBiblioteca.mensaje}');}"/>
                                <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('panelEditarTiposPreguntas')" class="btn" />
                                </div>
                        </h:panelGroup>
                        </center>
                        </a4j:form>
            </rich:modalPanel>

             <rich:modalPanel id="panelRegistrarTipoPregunta" minHeight="140"  minWidth="450"
                                     height="140" width="45"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Registro de Tipos de Pregunta"/>
                        </f:facet>
                        <a4j:form id="formRegistrar">
                            <center>
                        <h:panelGroup id="contenidoRegistrarTipoPregunta">
                            <h:panelGrid columns="3">
                                <h:outputText value="Nombre Tipo Pregunta" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                <h:inputText styleClass="inputText" value="#{ManagedDocumentosBiblioteca.tiposDocumentacionPreguntasBean.nombreTipoDocumentacionPregunta}" size="35" />
                                <h:outputText value="Estado" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="Activo" styleClass="outputText2" />
                            </h:panelGrid>
                                <div align="center">
                                    <a4j:commandButton styleClass="btn" value="Guardar"  action="#{ManagedDocumentosBiblioteca.guardarNuevoTipoDocumentacionPregunta_action}"
                                    reRender="dataTiposPreguntas"
                                    oncomplete="if(#{ManagedDocumentosBiblioteca.mensaje eq '1'}){alert('Se registro el tipo de pregunta');javascript:Richfaces.hideModalPanel('panelRegistrarTipoPregunta');}
                                    else{alert('#{ManagedDocumentosBiblioteca.mensaje}');}"/>
                                <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('panelRegistrarTipoPregunta')" class="btn" />
                                </div>
                        </h:panelGroup>
                        </center>
                        </a4j:form>
            </rich:modalPanel>

        </body>
    </html>

</f:view>

