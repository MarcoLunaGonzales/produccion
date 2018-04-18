
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
                A4J.AJAX.onError = function(req,status,message){
            window.alert("Ocurrio un error "+message+" continue con su transaccion ");
            }
            A4J.AJAX.onExpired = function(loc,expiredMsg){
            if(window.confirm("Ocurrio un error al momento realizar la transaccion: "+expiredMsg+" location: "+loc)){
            return loc;
            } else {
            return false;
            }
            }
            function verRegistro(codDocumentacion)
                {
                    document.getElementById('frameSubir').src="subirArchivoPdf.jsf?codDocumentacion="+codDocumentacion+"&a="+Math.random();
                }
                function ocultaRegistro1()
                {
                    Richfaces.hideModalPanel('modalPanelSubirArchivo');
                }
           function guardarPregunta()
           {
               if(document.getElementById("form2:preguntaCerrada").checked)
               {
                    var tabla=document.getElementById("form2:dataRes");
                    if(tabla.rows.length<3)
                        {
                            alert('Debe registrar al menos dos respuestas alternativas');
                            return false;
                        }
               }
               return true;
           }
           </script>
           <style>
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
            <a4j:form id="form">
                <div align="center">
                    <h:outputText value="#{ManagedDocumentosBiblioteca.cargarPreguntasDocumentacion}"/>
                     <table align="center" width="70%" class='outputText0'>
                    <tr>
                         <td align="center" >
                            <h3 >Preguntas Documento Biblioteca </h3>
                        </td>
                     </table>
                     <rich:panel headerClass="headerClassACliente" style="width:50%">
                             <f:facet name="header">
                                 <h:outputText value="Datos Documentos Biblioteca"/>
                             </f:facet>
                             <h:panelGrid columns="6">
                                 <h:outputText styleClass="outputText2" value="Nombre Documento" style="font-weight:bold"/>
                                 <h:outputText styleClass="outputText2" value="::" style="font-weight:bold"/>
                                 <h:outputText styleClass="outputText2" value="#{ManagedDocumentosBiblioteca.documentacionBean.nombreDocumento}"/>
                                 <h:outputText styleClass="outputText2" value="Codigo" style="font-weight:bold"/>
                                 <h:outputText styleClass="outputText2" value="::" style="font-weight:bold"/>
                                 <h:outputText styleClass="outputText2" value="#{ManagedDocumentosBiblioteca.documentacionBean.codigoDocumento}"/>
                                 <h:outputText styleClass="outputText2" value="Tipo Documento" style="font-weight:bold"/>
                                 <h:outputText styleClass="outputText2" value="::" style="font-weight:bold"/>
                                 <h:outputText styleClass="outputText2" value="#{ManagedDocumentosBiblioteca.documentacionBean.tiposDocumentoBiblioteca.nombreTipoDocumentoBiblioteca}"/>
                                 <h:outputText styleClass="outputText2" value="Tipo Documento Bmp-Iso" style="font-weight:bold"/>
                                 <h:outputText styleClass="outputText2" value="::" style="font-weight:bold"/>
                                 <h:outputText styleClass="outputText2" value="#{ManagedDocumentosBiblioteca.documentacionBean.tiposDocumentoBpmIso.nombreTipoDocumentoBpmIso}"/>
                                 <h:outputText styleClass="outputText2" value="Institución" style="font-weight:bold"/>
                                 <h:outputText styleClass="outputText2" value="::" style="font-weight:bold"/>
                                 <h:outputText styleClass="outputText2" value="#{ManagedDocumentosBiblioteca.documentacionBean.areasEmpresa.nombreAreaEmpresa}"/>
                                 <h:outputText styleClass="outputText2" value="Maquinaria" style="font-weight:bold"/>
                                 <h:outputText styleClass="outputText2" value="::" style="font-weight:bold"/>
                                 <h:outputText styleClass="outputText2" value="#{ManagedDocumentosBiblioteca.documentacionBean.maquinaria.nombreMaquina}"/>
                             </h:panelGrid>
                     </rich:panel>
                    
                    
                    <rich:dataTable value="#{ManagedDocumentosBiblioteca.documentacionPreguntasList}"
                                    var="data"
                                    id="dataPreguntas" binding="#{ManagedDocumentosBiblioteca.documentacionPreguntaDataTable}"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerLocal" style="margin-top:12px;">
                           <f:facet name="header">
                             <rich:columnGroup>
                                 <rich:column rowspan="2">
                                     <h:outputText value=""  />
                                 </rich:column>
                                 <rich:column rowspan="2">
                                     <h:outputText value="Descripción Pregunta"  />
                                 </rich:column>
                                 <rich:column rowspan="2">
                                     <h:outputText value="Tipo Pregunta"  />
                                 </rich:column>
                                 <rich:column rowspan="2" >
                                     <h:outputText value="Pregunta" />
                                 </rich:column>
                                 <rich:column rowspan="2">
                                     <h:outputText value="Estado"  />
                                 </rich:column>
                                 <rich:column colspan="3">
                                     <h:outputText value="Respuestas"  />
                                 </rich:column>
                                 <rich:column rowspan="2" >
                                     <h:outputText value="Administrar Respuestas"  />
                                 </rich:column>
                                 <rich:column breakBefore="true" styleClass="subHeaderTableClass">
                                     <h:outputText value="Descripción"  />
                                 </rich:column>
                                 <rich:column  styleClass="subHeaderTableClass">
                                     <h:outputText value="Estado"  />
                                 </rich:column>
                                 <rich:column  styleClass="subHeaderTableClass">
                                     <h:outputText value="Respuesta Correcta"  />
                                 </rich:column>
                                    </rich:columnGroup>
                         </f:facet>
                     <rich:subTable var="subData" value="#{data.documentacionRespuestasList}" rowKeyVar="rowkey">
                         <rich:column rowspan="#{data.cantidadRespuestas}"  rendered="#{rowkey eq 0}">
                            <h:selectBooleanCheckbox  value="#{data.checked}"  />
                        </rich:column>
                       <rich:column rowspan="#{data.cantidadRespuestas}"  rendered="#{rowkey eq 0}">
                            <h:outputText value="#{data.descripcionPregunta}"  />
                        </rich:column>
                         <rich:column rowspan="#{data.cantidadRespuestas}"  rendered="#{rowkey eq 0}">
                            <h:outputText value="#{data.tiposDocumentacionPreguntas.nombreTipoDocumentacionPregunta}"  />
                          </rich:column>

                         <rich:column rowspan="#{data.cantidadRespuestas}"  rendered="#{rowkey eq 0}">
                            <h:outputText value="Abierta" rendered="#{!data.preguntaCerrada}"  />
                            <h:outputText value="Cerrada" rendered="#{data.preguntaCerrada}"  />
                        </rich:column>
                         <rich:column rowspan="#{data.cantidadRespuestas}"  rendered="#{rowkey eq 0}">
                            <h:outputText value="#{data.estadoReferencial.nombreEstadoRegistro}"  />
                        </rich:column>
                         
                         <rich:column styleClass="celdaVersion" >
                             <h:outputText value="#{subData.descripcionRespuesta}"/>
                        </rich:column>
                        <rich:column styleClass="celdaVersion">
                             <h:outputText value="#{subData.estadoRegistro.nombreEstadoRegistro}"/>
                        </rich:column>
                        <rich:column styleClass="celdaVersion">
                            <h:outputText value="SI" rendered="#{subData.respuesta && subData.estadoRegistro.nombreEstadoRegistro!=''}"/>
                            <h:outputText value="NO" rendered="#{!subData.respuesta && subData.estadoRegistro.nombreEstadoRegistro!=''}"/>
                        </rich:column>

                        <rich:column rowspan="#{data.cantidadRespuestas}"  rendered="#{rowkey eq 0}">
                            <a4j:commandLink rendered="#{data.preguntaCerrada}"  action="#{ManagedDocumentosBiblioteca.seleccionarPregunta_action}" oncomplete=" var a=Math.random();window.location.href='navegadorRespuestasDocumentacion.jsf?a='+a;" title="Ver respuestas de documentacion" >
                                <h:graphicImage url="../../img/folder_32.png"/>
                            </a4j:commandLink>
                        </rich:column>
                         <rich:column style="height:12px;background-color:#cccccc" breakBefore="true" styleClass="subHeaderTableClass" colspan="20"  rendered="#{rowkey eq (data.cantidadRespuestas-1)}">
                           </rich:column>
                       </rich:subTable>
                    </rich:dataTable>
                   
                    <br>
                        <a4j:commandButton oncomplete="Richfaces.showModalPanel('panelRegistroPreguntas')" action="#{ManagedDocumentosBiblioteca.agregarDocumentacionPreguntas_action}" styleClass="btn" value="Agregar" reRender="contenidoRegistroPregunta"/>
                        <a4j:commandButton onclick="if(editarItem('form:dataPreguntas')==false){return false;}" oncomplete="Richfaces.showModalPanel('panelEditarPreguntas')" styleClass="btn" value="Editar"  action="#{ManagedDocumentosBiblioteca.editarDocumentacionPregunta_action}" reRender="contenidoEditarPregunta" />
                        <a4j:commandButton onclick="if(editarItem('form:dataPreguntas')==false){return false;}else{if(confirm('Esta seguro de eliminar la pregunta?\nSe eliminaran tambien las respuestas')==false){return false;}}"  styleClass="btn" value="Eliminar"  action="#{ManagedDocumentosBiblioteca.eliminarDocumentacionPregunta_action}" reRender="dataPreguntas"
                        oncomplete="if(#{ManagedDocumentosBiblioteca.mensaje eq '1'}){ alert('Se elimino la pregunta');}else{alert('#{ManagedDocumentosBiblioteca.mensaje}')}"/>
                        <a4j:commandButton oncomplete="window.location.href='../documentosBiblioteca/navegadorDocumentosBiblioteca.jsf'" styleClass="btn" value="Volver al listado"  />
                        <a4j:commandButton onclick="verRegistro(#{ManagedDocumentosBiblioteca.documentacionBean.codDocumento});Richfaces.showModalPanel('modalPanelSubirArchivo');" styleClass="btn" value="Subir Preguntas"  />
                        

                   
                </div>

               
              
            </a4j:form>
            <rich:modalPanel id="modalPanelSubirArchivo" minHeight="350" headerClass="headerClassACliente"
                             minWidth="450" height="350" width="650" zindex="100" >
                <f:facet name="header">
                    <h:outputText value="Subir Datos"/>
                </f:facet>
                <div align="center"  >
                    <iframe src="" id="frameSubir" width="100%" height="100%" align="center"></iframe>
                </div>

            </rich:modalPanel>

            <rich:modalPanel id="panelRegistroPreguntas"
            minHeight="200"  minWidth="530"
                                     height="420" width="530" zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow:auto;">
                        <f:facet name="header">
                            <h:outputText value="Registro de Pregunta" />
                        </f:facet>
                        <div align="center">
                        <a4j:form id="form2">
                        <h:panelGroup id="contenidoRegistroPregunta">

                            <h:panelGrid columns="3">
                            
                            <h:outputText styleClass="outputTextTitulo"   value="Descripcion" style="font-weight:bold;" />
                            <h:outputText styleClass="outputTextTitulo"   value="::" style="font-weight:bold;" />
                            <h:inputTextarea rows="5" cols="60" styleClass="inputText" value="#{ManagedDocumentosBiblioteca.documentacionPreguntas.descripcionPregunta}" />
                            <h:outputText styleClass="outputTextTitulo"   value="Tipo Pregunta" style="font-weight:bold;" />
                            <h:outputText styleClass="outputTextTitulo"   value="::" style="font-weight:bold;" />
                            <h:selectOneMenu value="#{ManagedDocumentosBiblioteca.documentacionPreguntas.tiposDocumentacionPreguntas.codTipoDocumentacionPregunta}" styleClass="inputText">
                                <f:selectItems value="#{ManagedDocumentosBiblioteca.tiposDocumentacionPregutasSelectList}"/>
                            </h:selectOneMenu>
                            <h:outputText styleClass="outputTextTitulo"   value="Pregunta cerrada" style="font-weight:bold;" />
                            <h:outputText styleClass="outputTextTitulo"   value="::" style="font-weight:bold;" />
                            <h:selectBooleanCheckbox  value="#{ManagedDocumentosBiblioteca.documentacionPreguntas.preguntaCerrada}"  id="preguntaCerrada">
                                <a4j:support event="onclick" reRender="groupTable" />
                           </h:selectBooleanCheckbox>

                            
                                
                            </h:panelGrid>
                            <h:panelGroup id="groupTable" >
                                <rich:dataTable value="#{ManagedDocumentosBiblioteca.documentacionRespuestasList}"
                                var="data" rendered="#{ManagedDocumentosBiblioteca.documentacionPreguntas.preguntaCerrada}"
                                        id="dataRes"
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
                                                <h:outputText value="Descripcion"  />
                                            </f:facet>
                                            <h:inputText value="#{data.descripcionRespuesta}"  styleClass="inputText" size="50" />
                                        </h:column>
                                         <h:column>
                                            <f:facet name="header">
                                                <h:outputText value="Estado"  />
                                            </f:facet>
                                            <h:selectOneMenu value = "#{data.estadoRegistro.codEstadoRegistro}" styleClass="inputText" >
                                                <f:selectItem itemValue="1" itemLabel="Activo"/>
                                                <f:selectItem itemValue="2" itemLabel="No Activo"/>
                                            </h:selectOneMenu>
                                        </h:column>
                                         <h:column>
                                            <f:facet name="header">
                                                <h:outputText value="Respuesta Correcta"  />
                                            </f:facet>
                                            <h:selectBooleanCheckbox value="#{data.respuesta}"/>
                                        </h:column>
                                </rich:dataTable>
                       
                                <a4j:commandLink accesskey="q" rendered="#{ManagedDocumentosBiblioteca.documentacionPreguntas.preguntaCerrada}" action="#{ManagedDocumentosBiblioteca.mas_action}" id="masAction" reRender="dataRes" timeout="10000" >
                                        <h:graphicImage url="../../img/mas.png" alt="mas"/>
                                </a4j:commandLink>
                                <a4j:commandLink accesskey="w"  rendered="#{ManagedDocumentosBiblioteca.documentacionPreguntas.preguntaCerrada}" action="#{ManagedDocumentosBiblioteca.menos_action}" reRender="dataRes" timeout="10000">
                                        <h:graphicImage url="../../img/menos.png" alt="menos"/>
                                </a4j:commandLink>
                            </h:panelGroup>
                                </h:panelGroup>
                        
                        <br/>

                        <a4j:commandButton  value="Guardar" styleClass="btn" onclick="if(guardarPregunta()==false){return false;}"
                        action="#{ManagedDocumentosBiblioteca.guardarDocumentacionPregunta_action}" reRender="dataPreguntas"
                        oncomplete="if(#{ManagedDocumentosBiblioteca.mensaje!=''}){alert('#{ManagedDocumentosBiblioteca.mensaje}')};javascript:Richfaces.hideModalPanel('panelRegistroPreguntas')" />


                        <input type="button" value="Cancelar" class="btn" onclick="javascript:Richfaces.hideModalPanel('panelRegistroPreguntas')" />

                        </div>
                        </a4j:form>
                    </rich:modalPanel>


                    <rich:modalPanel id="panelEditarPreguntas"
                                     minHeight="260"  minWidth="500"
                                     height="260" width="500" zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false">
                        <f:facet name="header">
                            <h:outputText value="Editar Pregunta" />
                        </f:facet>
                        <div align="center">
                        <a4j:form id="form1">
                        <h:panelGroup id="contenidoEditarPregunta">

                             <h:panelGrid columns="3">

                                    <h:outputText styleClass="outputTextTitulo"   value="Descripcion" style="font-weight:bold;" />
                                    <h:outputText styleClass="outputTextTitulo"   value="::" style="font-weight:bold;" />
                                    <h:inputTextarea rows="5" cols="60" styleClass="inputText" value="#{ManagedDocumentosBiblioteca.documentacionPreguntas.descripcionPregunta}" />
                                    <h:outputText styleClass="outputTextTitulo"   value="Tipo Pregunta" style="font-weight:bold;" />
                                    <h:outputText styleClass="outputTextTitulo"   value="::" style="font-weight:bold;" />
                                    <h:selectOneMenu value="#{ManagedDocumentosBiblioteca.documentacionPreguntas.tiposDocumentacionPreguntas.codTipoDocumentacionPregunta}" styleClass="inputText">
                                        <f:selectItems value="#{ManagedDocumentosBiblioteca.tiposDocumentacionPregutasSelectList}"/>
                                    </h:selectOneMenu>
                                    <h:outputText styleClass="outputTextTitulo"   value="Pregunta cerrada" style="font-weight:bold;" />
                                    <h:outputText styleClass="outputTextTitulo"   value="::" style="font-weight:bold;" />
                                    <h:selectBooleanCheckbox value="#{ManagedDocumentosBiblioteca.documentacionPreguntas.preguntaCerrada}"/>
                                    <h:outputText styleClass="outputTextTitulo"   value="Estado" style="font-weight:bold;" />
                                    <h:outputText styleClass="outputTextTitulo"   value="::" style="font-weight:bold;" />
                                    <h:selectOneMenu value="#{ManagedDocumentosBiblioteca.documentacionPreguntas.estadoReferencial.codEstadoRegistro}" styleClass="inputText">
                                        <f:selectItem itemLabel="Activo" itemValue="1"/>
                                        <f:selectItem itemLabel="No Activo" itemValue="2"/>
                                    </h:selectOneMenu>
                            </h:panelGrid>
                        </h:panelGroup>
                        <br/>

                        <a4j:commandButton  value="Guardar" styleClass="btn"
                        action="#{ManagedDocumentosBiblioteca.guardarEditarDocumentacionPregunta_action}" reRender="dataPreguntas"
                        oncomplete="if(#{ManagedDocumentosBiblioteca.mensaje!=''}){alert('#{ManagedDocumentosBiblioteca.mensaje}')};javascript:Richfaces.hideModalPanel('panelEditarPreguntas')" />


                        <input type="button" value="Cancelar" class="btn" onclick="javascript:Richfaces.hideModalPanel('panelEditarPreguntas')" />

                        </div>
                        </a4j:form>
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
                    
            

        </body>
    </html>

</f:view>

