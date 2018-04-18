<%@taglib prefix="h" uri="http://java.sun.com/jsf/html" %>
<%@taglib prefix="f" uri="http://java.sun.com/jsf/core" %>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j" %>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
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
                    <h:outputText value="#{ManagedFormasFarmaceuticasDocumentacionAplicada.cargarAgregarFormasFarmaceuticasAsignacionDocumentacionList}"/>
                    <h:outputText styleClass="outputTextTituloSistema"   value="Agregar Documentacion aplicada" />
                    
                    <h:panelGroup id="contenido">
                        <rich:panel headerClass="headerClassACliente" style="width:50%">
                            <f:facet name="header">
                                <h:outputText value="Forma Farmaceútica"/>
                            </f:facet>
                            <h:panelGrid columns="3" headerClass="headerClassACliente">
                               <h:outputText value="Forma Farmaceutica" styleClass="outputTextBold" />
                               <h:outputText value=":" styleClass="outputTextBold" />
                               <h:outputText id="nombreForma" value="#{ManagedFormasFarmaceuticasDocumentacionAplicada.formasFarmaceuticasDocumentacionAplicadaBean.formasFarmaceuticas.nombreForma}" styleClass="outputText2"/>
                               <h:outputText value="Tipo Asignación Documento" styleClass="outputTextBold" />
                               <h:outputText value=":" styleClass="outputTextBold" />
                               <h:selectOneMenu value="#{ManagedFormasFarmaceuticasDocumentacionAplicada.formasFarmaceuticasDocumentacionAplicadaAgregar.tiposAsignacionDocumentoOm.codTipoAsignacionDocumentacionOm}" styleClass="inputText">
                                   <f:selectItems value="#{ManagedFormasFarmaceuticasDocumentacionAplicada.tiposAsignacionDocumentoOmSelectList}"/>
                                   <a4j:support event="onchange" action="#{ManagedFormasFarmaceuticasDocumentacionAplicada.codTipoAsignacionDocumentacion_change}" reRender="dataDocumentacionAgregar"/>
                               </h:selectOneMenu>
                            </h:panelGrid>
                        </rich:panel>
                    
                        <rich:dataTable value="#{ManagedFormasFarmaceuticasDocumentacionAplicada.documentacionAgregarList}"
                                                var="data" id="dataDocumentacionAgregar"
                                                onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                                onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                                headerClass="headerClassACliente"  style="margin-top:1em !important">
                            <f:facet name="header">
                                <rich:columnGroup>
                                    <rich:column>
                                        <h:outputText value=""/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Documento<br><input onkeyup='buscarCeldaAgregar(this,1)' class='inputText' type='text'>" escape="false"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Código Documento"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Código Nuevo"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Tipo Documento"/>
                                    </rich:column>
                                </rich:columnGroup>
                            </f:facet>
                                <rich:column>
                                    <h:selectBooleanCheckbox value="#{data.checked}"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="#{data.nombreDocumento}"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="#{data.codigoDocumento}"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="#{data.codigoNuevo}"/>
                                </rich:column>
                            
                                <rich:column>
                                    <h:outputText value="#{data.tiposDocumentoBiblioteca.nombreTipoDocumentoBiblioteca}"/>
                                </rich:column>
                                
                        </rich:dataTable>
                        </h:panelGroup>
                        <br>
                        <div  class="barraBotones" id="bottonesAcccion">
                            <a4j:commandButton value="Guardar" styleClass="btn" action="#{ManagedFormasFarmaceuticasDocumentacionAplicada.guardarAgregarFormasFarmaceuticasDocumentacionAplicada_action}"
                                               onclick="if(!alMenosUno('form1:dataDocumentacionAgregar')){return false;}"
                                               oncomplete="if(#{ManagedFormasFarmaceuticasDocumentacionAplicada.mensaje eq '1'}){alert('Se registro la documentacion');window.location.href='navegadorFormasFarmaceuticasDocumentacionAplicada.jsf?add='+(new Date()).getTime().toString()}else{alert('#{ManagedFormasFarmaceuticasDocumentacionAplicada.mensaje}')}"/>
                            <a4j:commandButton value="Cancelar" styleClass="btn" 
                                               oncomplete="window.location.href='navegadorFormasFarmaceuticasDocumentacionAplicada.jsf?cancel='+(new Date()).getTime().toString();"/>
                         </div>   
                         
                </div>

               
              
            </a4j:form>
            
            
             
             <a4j:status id="statusPeticion"
                        onstart="Richfaces.showModalPanel('ajaxLoadingModalBox',{width:100, top:100})"
                        onstop="Richfaces.hideModalPanel('ajaxLoadingModalBox')">
            </a4j:status>

            <rich:modalPanel id="ajaxLoadingModalBox" minHeight="250"
                             minWidth="200" height="80" width="400" zindex="250" onshow="window.focus();">

                <div align="center">
                    <h:graphicImage value="../img/load2.gif" />
                </div>
            </rich:modalPanel>
        </body>
    </html>

</f:view>

