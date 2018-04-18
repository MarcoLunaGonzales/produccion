
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
           <script>
               function openPopup(url1){

                    izquierda = (screen.width) ? (screen.width-300)/2 : 100
                    arriba = (screen.height) ? (screen.height-400)/2 : 200
                    var url=url1+'codP='+Math.random();
                     opciones='toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,width=700,height=400,left='+izquierda+ ',top=' + arriba + ''
                    window.open(url, 'popUp',opciones)

                }
           </script>
        </head>
        <body >
            <a4j:form id="form1">
                <div align="center">
                    <h:outputText value="#{ManagedDocumentosBiblioteca.cargarDocumentacionBiblioteca}"/>
                     <table align="center" width="70%" class='outputText0'>
                    <tr>
                        <td width="10%">
                            <img src="../../img/cofar.png">
                        </td>
                         <td align="center" >
                            <h3 >Documentos Biblioteca</h3>
                        </td>
                     </table>
                     
                    <rich:dataTable value="#{ManagedDocumentosBiblioteca.documentacionList}"
                                    var="data"
                                    id="dataDocumentacion" binding="#{ManagedDocumentosBiblioteca.documentacionPreguntasDataTable}"
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
                                <h:outputText value="Nombre Documento"  />
                            </f:facet>
                            <h:outputText value="#{data.nombreDocumento}"  />
                        </h:column>
                         <h:column>
                            <f:facet name="header">
                                <h:outputText value="Codigo"  />
                            </f:facet>
                            <h:outputText value="#{data.codigoDocumento}"  />
                        </h:column>
                         <h:column>
                            <f:facet name="header">
                                <h:outputText value="Tipo Documento"  />
                            </f:facet>
                            <h:outputText value="#{data.tiposDocumentoBiblioteca.nombreTipoDocumentoBiblioteca}"  />
                        </h:column>
                         <h:column>
                            <f:facet name="header">
                                <h:outputText value="Tipo Documento Bpm-Iso"  />
                            </f:facet>
                            <h:outputText value="#{data.tiposDocumentoBpmIso.nombreTipoDocumentoBpmIso}"/>
                        </h:column>
                         <h:column>
                            <f:facet name="header">
                                <h:outputText value="Nivel Documento"  />
                            </f:facet>
                            <h:outputText value="#{data.areasEmpresa.nombreAreaEmpresa}"  />
                        </h:column>
                         <h:column>
                            <f:facet name="header">
                                <h:outputText value="Preguntas"  />
                            </f:facet>
                            <h:outputText value="#{data.nroPreguntasCuestionario}"  />
                        </h:column>
                         <%--h:column>
                            <f:facet name="header">
                                <h:outputText value="Codigo"  />
                            </f:facet>
                            <h:outputText value="#{data.codigoDocumento}"  />
                        </h:column--%>
                        <%--h:column>
                            <f:facet name="header">
                                <h:outputText value="Ver documento"  />
                            </f:facet>
                        <a4j:commandLink  oncomplete="openPopup('documentosBiblioteca/#{data.urlDocumento}?')" title="Ver Documento" rendered="#{data.urlDocumento !=''}">
                                <h:graphicImage url="../../img/pdf.jpg"/>
                            </a4j:commandLink>
                        </h:column --%>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value=""  />
                            </f:facet>
                            
                            <a4j:commandLink action="#{ManagedDocumentosBiblioteca.verPreguntasDocumentacion_action}" oncomplete=" var a=Math.random();window.location.href='navegadorPreguntasDocumentacions.jsf?a='+a;" title="Ver preguntas de documentacion" >
                                <h:graphicImage url="../../img/folder_32.png"/>
                                
                            </a4j:commandLink>
                            
                            
                        </h:column >
                       
                    </rich:dataTable>
                   
                    <br>
                       <button onclick="var a=Math.random();window.location.href='agregarDocumentacionBiblioteca.jsf?cod='+a" class="btn">Registrar</button>
                       <button onclick="var a=Math.random();window.location.href='agregarDocumentacionBiblioteca.jsf?cod='+a" class="btn">Editar</button>
                       <button onclick="var a=Math.random();window.location.href='agregarDocumentacionBiblioteca.jsf?cod='+a" class="btn">Eliminar</button>
                        

                   
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
                                    reRender="dataTiposDocumento"
                                    oncomplete="if(#{ManagedDocumentosBiblioteca.mensaje eq '1'}){alert('Se edito el tipo de documento');javascript:Richfaces.hideModalPanel('panelEditarTipoDocumentoBiblioteca');}
                                    else{alert('#{ManagedDocumentosBiblioteca.mensaje}');}"/>
                                <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('panelEditarTipoDocumentoBiblioteca')" class="btn" />
                                </div>
                        </h:panelGroup>
                        </center>
                        </a4j:form>
            </rich:modalPanel>

             <rich:modalPanel id="panelRegistrarTipoDocumentoBiblioteca" minHeight="140"  minWidth="450"
                                     height="140" width="45"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Registro de Tipos de Documento Biblioteca"/>
                        </f:facet>
                        <a4j:form id="formRegistrar">
                            <center>
                        <h:panelGroup id="contenidoRegistrarTipoDocumentoBiblioteca">
                            <h:panelGrid columns="3">
                                <h:outputText value="Nombre Tipo Documento" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                <h:inputText styleClass="inputText" value="#{ManagedDocumentosBiblioteca.tipoDocumentoBibliotecaAgregar.nombreTipoDocumentoBiblioteca}"/>
                            </h:panelGrid>
                                <div align="center">
                                    <a4j:commandButton styleClass="btn" value="Registrar"  action="#{ManagedDocumentosBiblioteca.guardarNuevoTipoDocumentoBiblioteca_action}"
                                    reRender="dataTiposDocumento"
                                    oncomplete="if(#{ManagedDocumentosBiblioteca.mensaje eq '1'}){alert('Se registro el tipo de documento');javascript:Richfaces.hideModalPanel('panelRegistrarTipoDocumentoBiblioteca');}
                                    else{alert('#{ManagedDocumentosBiblioteca.mensaje}');}"/>
                                <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('panelRegistrarTipoDocumentoBiblioteca')" class="btn" />
                                </div>
                        </h:panelGroup>
                        </center>
                        </a4j:form>
            </rich:modalPanel>

        </body>
    </html>

</f:view>

