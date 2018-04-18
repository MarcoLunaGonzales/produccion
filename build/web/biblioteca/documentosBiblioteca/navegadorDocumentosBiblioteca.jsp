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
           <style>
                .subCabecera
                {
                    background-color:#9d5a9e;
                    color:white;
                    font-weight:bold;
                }
                .headerLocal{
                    background-image:none;
                    background-color:#9d5f9f;
                    font-weight:bold;
                }
                .celdaVersion{
                    background-color:#eeeeee;
                }
            </style>
        </head>
        <body >
            <a4j:form id="form1">
                <div align="center">
                    <h:outputText value="#{ManagedDocumentosBiblioteca.cargarDocumentacionBiblioteca}"/>
                     <table align="center" width="70%" class='outputText0'>
                    <tr>
                        
                         <td align="center" >
                            <h3 >Documentos Biblioteca</h3>
                        </td>
                     </table>
                    
                    
                    <rich:dataTable value="#{ManagedDocumentosBiblioteca.documentacionList}"
                                    var="data"
                                    id="dataDocumentacion" binding="#{ManagedDocumentosBiblioteca.documentacionDataTable}"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente headerLocal" style="margin-top:12px;">
                         <f:facet name="header">
                             <rich:columnGroup>
                                 <rich:column rowspan="2">
                                     <h:outputText value=""  />
                                 </rich:column>
                                 <rich:column rowspan="2">
                                     <h:outputText value="Nombre Documento"  />
                                 </rich:column>
                                 <rich:column rowspan="2">
                                     <h:outputText value="Codigo"  />
                                 </rich:column>
                                 <rich:column rowspan="2" >
                                     <h:outputText value="Tipo Documento" />
                                 </rich:column>
                                 <rich:column rowspan="2">
                                     <h:outputText value="Nivel Documento"  />
                                 </rich:column>
                                 <rich:column rowspan="2" >
                                     <h:outputText value="Maquinari"  />
                                 </rich:column>

                                 <rich:column rowspan="2">
                                     <h:outputText value="Producto"  />
                                 </rich:column>
                                 <rich:column rowspan="2">
                                     <h:outputText value="Nro Preguntas"  />
                                 </rich:column>
                                 <rich:column colspan="8">
                                     <h:outputText value="Versiones"  />
                                 </rich:column>
                                 <rich:column rowspan="2" >
                                     <h:outputText value="Asignar Permisos"  />
                                 </rich:column>
                                 <rich:column rowspan="2" >
                                     <h:outputText value="Preguntas"  />
                                 </rich:column>
                                 <rich:column rowspan="2" >
                                     <h:outputText value="Restricciones"  />
                                 </rich:column>
                                 <rich:column breakBefore="true" styleClass="subHeaderTableClass">
                                     <h:outputText value="Nro. Versión"  />
                                 </rich:column>
                                 <rich:column  styleClass="subHeaderTableClass">
                                     <h:outputText value="Fecha Cargado"  />
                                 </rich:column>
                                 <rich:column  styleClass="subHeaderTableClass">
                                     <h:outputText value="Fecha Elaboración"  />
                                 </rich:column>
                                 <rich:column  styleClass="subHeaderTableClass">
                                     <h:outputText value="Fecha Ingreso Vigencia"  />
                                 </rich:column>
                                 <rich:column  styleClass="subHeaderTableClass">
                                     <h:outputText value="Fecha Proxima Revisión"  />
                                 </rich:column>
                                 <rich:column  styleClass="subHeaderTableClass">
                                     <h:outputText value="Elaborado Por:"  />
                                 </rich:column>
                                 <rich:column  styleClass="subHeaderTableClass">
                                     <h:outputText value="Estado Doc."  />
                                 </rich:column>
                                  <rich:column styleClass="subHeaderTableClass">
                                     <h:outputText value="Ver Documento"  />
                                 </rich:column>
                                 
                             </rich:columnGroup>



                         </f:facet>
                     <rich:subTable var="subData" value="#{data.versionDocumentacionList}" rowKeyVar="rowkey">
                         <rich:column rowspan="#{data.tamLista}"  rendered="#{rowkey eq 0}">
                                    <h:selectBooleanCheckbox value="#{data.checked}" />
                         </rich:column>
                         <rich:column rowspan="#{data.tamLista}"  rendered="#{rowkey eq 0}">
                                    <h:outputText value="#{data.nombreDocumento}"  />
                         </rich:column>
                         <rich:column rowspan="#{data.tamLista}"  rendered="#{rowkey eq 0}">
                                    <h:outputText value="#{data.codigoDocumento}"  />
                         </rich:column>
                         <rich:column rowspan="#{data.tamLista}"  rendered="#{rowkey eq 0}">
                                    <h:outputText value="#{data.tiposDocumentoBiblioteca.nombreTipoDocumentoBiblioteca}"  />
                         </rich:column>
                         <rich:column rowspan="#{data.tamLista}"  rendered="#{rowkey eq 0}">
                                    <h:outputText value="#{data.areasEmpresa.nombreAreaEmpresa}"  />
                         </rich:column>
                         <rich:column rowspan="#{data.tamLista}"  rendered="#{rowkey eq 0}">
                                    <h:outputText value="#{data.maquinaria.nombreAreaMaquina}(#{data.maquinaria.codigo})"  rendered="#{data.maquinaria.nombreAreaMaquina!=''}"/>
                         </rich:column>
                         <rich:column rowspan="#{data.tamLista}"  rendered="#{rowkey eq 0}">
                                    <h:outputText value="#{data.componentesProd.nombreProdSemiterminado}"  />
                         </rich:column>
                         <rich:column rowspan="#{data.tamLista}"  rendered="#{rowkey eq 0}">
                                    <h:outputText value="#{data.nroPreguntasCuestionario}"/>
                         </rich:column>
                         <rich:column styleClass="celdaVersion" >
                                   <h:outputText value="#{subData.nroVersion}"/>
                          </rich:column>
                          <rich:column styleClass="celdaVersion" >
                              <h:outputText value="#{subData.fechaCargado}">
                                <f:convertDateTime pattern="dd/MM/yyyy"/>
                              </h:outputText>
                          </rich:column>
                          <rich:column  styleClass="celdaVersion">
                                <h:outputText value="#{subData.fechaElaboracion}">
                                        <f:convertDateTime pattern="dd/MM/yyyy"/>
                                </h:outputText>
                          </rich:column>
                          <rich:column styleClass="celdaVersion" >
                                <h:outputText value="#{subData.fechaIngresoVigencia}">
                                     <f:convertDateTime pattern="dd/MM/yyyy"/>
                                </h:outputText>
                          </rich:column>
                          <rich:column styleClass="celdaVersion">
                               <h:outputText value="#{subData.fechaProximaRevision}">
                                    <f:convertDateTime pattern="dd/MM/yyyy"/>
                               </h:outputText>
                          </rich:column>
                          <rich:column styleClass="celdaVersion">
                               <h:outputText value="#{subData.personalElabora.nombrePersonal}"/>
                          </rich:column>
                          <rich:column styleClass="celdaVersion">
                                <h:outputText value="#{subData.estadosDocumento.nombreEstadoDocumento}"/>
                          </rich:column >
                          <rich:column styleClass="celdaVersion">
                                 <a4j:commandLink  oncomplete="openPopup('documentosBiblioteca/#{subData.urlDocumento}?')" title="Ver Documento" rendered="#{subData.urlDocumento !=''}">
                                           <h:graphicImage url="../../img/pdf.jpg"/>
                                 </a4j:commandLink>
                          </rich:column>
                          <rich:column rowspan="#{data.tamLista}"  rendered="#{rowkey eq 0}">
                                     <a4j:commandLink action="#{ManagedDocumentosBiblioteca.seleccionarDocumentacion_action}" oncomplete=" var a=Math.random();window.location.href='permisosUsuarioDocumentos.jsf?a='+a;" title="Asignar Permisos Usuario" >
                                        <h:graphicImage url="../../img/pdfUsuario.jpg"/>
                                    </a4j:commandLink>
                         </rich:column>
                         <rich:column rowspan="#{data.tamLista}"  rendered="#{rowkey eq 0}">
                                    <a4j:commandLink action="#{ManagedDocumentosBiblioteca.verPreguntasDocumentacion_action}" oncomplete=" var a=Math.random();window.location.href='../documentosBancoPreguntas/navegadorPreguntasDocumentacions.jsf?a='+a;" title="Ver preguntas de documentacion" >
                                        <h:graphicImage url="../../img/folder_32.png"/>
                                    </a4j:commandLink>
                                  
                         </rich:column>
                          <rich:column rowspan="#{data.tamLista}"  rendered="#{rowkey eq 0}">
                                     <a4j:commandLink action="#{ManagedDocumentosBiblioteca.seleccionarDocumentacion_action}" oncomplete=" var a=Math.random();window.location.href='restriccionesDocumentos/navegadorRestriccionesDocumentos.jsf?a='+a;" title="Asignar Restricciones" >
                                        <h:graphicImage url="../../img/pdfUsuario.jpg"/>
                                    </a4j:commandLink>
                         </rich:column>
                           <rich:column style="height:12px;background-color:#cccccc" breakBefore="true" styleClass="subHeaderTableClass" colspan="20"  rendered="#{rowkey eq (data.tamLista-1)}">
                           </rich:column>
                     </rich:subTable>
                       
                       
                    </rich:dataTable>
                   
                    <br>
                       <button onclick="var a=Math.random();window.location.href='agregarDocumentacionBiblioteca.jsf?cod='+a" class="btn">Registrar</button>
                       <button onclick="var a=Math.random();window.location.href='agregarDocumentacionBiblioteca.jsf?cod='+a" class="btn">Editar</button>
                       <a4j:commandButton action="#{ManagedDocumentosBiblioteca.eliminarDocumentacionBiblioteca_action}" onclick="if(editarItem('form1:dataDocumentacion')==false){return false;}" oncomplete="if(#{ManagedDocumentosBiblioteca.mensaje eq '1'}){alert('Se elimino el documento y sus versiones');}else{alert('#{ManagedDocumentosBiblioteca.mensaje}');}"
                       styleClass="btn" value="Eliminar Documento" reRender="dataDocumentacion"/>
                       <a4j:commandButton action="#{ManagedDocumentosBiblioteca.crearNuevaVersionDocumentacion_action}" onclick="if(editarItem('form1:dataDocumentacion')==false){return false;}" oncomplete="var ab=Math.random();window.location.href='agregarVersionDocumentoBiblioteca.jsf?ac='+ab;"
                       styleClass="btn" value="Registrar Nueva version"/>
                       <a4j:commandButton action="#{ManagedDocumentosBiblioteca.enviarCorreo_action}"
                       styleClass="btn" value="Correo"/>


                   
                </div>
                <table>
                    <tr><td style="font-size:5px"></td><td></td></tr>
                </table>

               
              
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

