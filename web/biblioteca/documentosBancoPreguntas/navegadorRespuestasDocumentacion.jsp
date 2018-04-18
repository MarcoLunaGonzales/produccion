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
           </script>
        </head>
        <body >
            <a4j:form id="form">
                <div align="center">
                    <h:outputText value="#{ManagedDocumentosBiblioteca.cargarRespuestasDocumentacion}"/>
                     <table align="center" width="70%" class='outputText0'>
                    <tr>
                       
                         <td align="center" >
                            <h3 >Respuestas Pregunta Biblioteca</h3>
                        </td>
                     </table>
                      <rich:panel headerClass="headerClassACliente" style="width:50%">
                             <f:facet name="header">
                                 <h:outputText value="Datos Documento Biblioteca"/>
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
                      <rich:panel headerClass="headerClassACliente" style="width:100%">
                             <f:facet name="header">
                                 <h:outputText value="Datos Pregunta Documento"/>
                             </f:facet>
                           <h:panelGrid columns="3">
                                 <h:outputText styleClass="outputText2" value="Descripción" style="font-weight:bold"/>
                                 <h:outputText styleClass="outputText2" value="::" style="font-weight:bold"/>
                                 <h:outputText styleClass="outputText2" value="#{ManagedDocumentosBiblioteca.documentacionPreguntasSeleccionada.descripcionPregunta}"/>
                                 <h:outputText styleClass="outputText2" value="Tipo Pregunta" style="font-weight:bold"/>
                                 <h:outputText styleClass="outputText2" value="::" style="font-weight:bold"/>
                                 <h:outputText styleClass="outputText2" value="#{ManagedDocumentosBiblioteca.documentacionPreguntasSeleccionada.tiposDocumentacionPreguntas.nombreTipoDocumentacionPregunta}"/>
                                 <h:outputText styleClass="outputText2" value="Tipo Documento" style="font-weight:bold"/>
                                 <h:outputText styleClass="outputText2" value="::" style="font-weight:bold"/>
                                 <h:outputText styleClass="outputText2" value="#{ManagedDocumentosBiblioteca.documentacionPreguntasSeleccionada.estadoReferencial.nombreEstadoRegistro}"/>
                             </h:panelGrid>
                     </rich:panel>
                     </rich:panel>
                    
                    
                    
                    <rich:dataTable value="#{ManagedDocumentosBiblioteca.documentacionRespuestasList}"
                                    var="data"
                                    id="dataDocumentacion"
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
                                <h:inputText value="#{data.descripcionRespuesta}"  styleClass="inputText2" size="50" />
                            </h:column>
                             <h:column>
                                <f:facet name="header">
                                    <h:outputText value="Estado"  />
                                </f:facet>
                                <h:selectOneMenu value = "#{data.estadoRegistro.codEstadoRegistro}" >
                                    <f:selectItems value="#{ManagedDocumentosBiblioteca.estadosReferencialesList}" />
                                </h:selectOneMenu>
                            </h:column>
                             <h:column>
                                <f:facet name="header">
                                    <h:outputText value="Respuesta Correcta"  />
                                </f:facet>
                                <h:selectBooleanCheckbox value="#{data.respuesta}"/>
                            </h:column>
                    </rich:dataTable>
                    <a4j:commandLink accesskey="q" action="#{ManagedDocumentosBiblioteca.mas_action}" id="masAction" reRender="dataDocumentacion" timeout="10000" >
                            <h:graphicImage url="../../img/mas.png" alt="mas"/>
                    </a4j:commandLink>
                    <a4j:commandLink accesskey="w" action="#{ManagedDocumentosBiblioteca.menos_action}" reRender="dataDocumentacion" timeout="10000">
                            <h:graphicImage url="../../img/menos.png" alt="menos"/>
                    </a4j:commandLink>
                   
                    <br>
                        <a4j:commandButton action="#{ManagedDocumentosBiblioteca.guardarRespuesta_action}" styleClass="btn" value="Guardar" 
                        oncomplete = "if(#{ManagedDocumentosBiblioteca.mensaje eq '1'}){location='navegadorPreguntasDocumentacions.jsf';alert('Se registraron las respuestas');}else{alert('#{ManagedDocumentosBiblioteca.mensaje}');}" />
                        <a4j:commandButton onclick="location='navegadorPreguntasDocumentacions.jsf'" styleClass="btn" value="Aceptar"    />

                   
                </div>

               
              
            </a4j:form>

            

        </body>
    </html>

</f:view>

