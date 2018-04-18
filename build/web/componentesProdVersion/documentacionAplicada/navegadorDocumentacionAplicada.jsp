<%@taglib prefix="h" uri="http://java.sun.com/jsf/html" %>
<%@taglib prefix="f" uri="http://java.sun.com/jsf/core" %>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j" %>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>

    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
            <script type="text/javascript" src="../../js/general.js" ></script>
            <script type="text/javascript">
                function retornarNavegador(codVersionCp)
                {
                    window.location.href=(codVersionCp>0?'../navegadorComponentesProdVersion.jsf':'../navegadorNuevosComponentesProd.jsf')+"?data="+(new Date()).getTime().toString();
                }
                function verificarTipoDocumentacionAplicada()
                {
                    if(document.getElementById("form1:nombreTipoAsignacionDocumentacion").innerHTML.length == 0)
                        javascript:Richfaces.showModalPanel('panelSeleccionTipoAsignacionDocumento');
                }
                
            </script>
        </head>
        <body onload="verificarTipoDocumentacionAplicada()">
            <a4j:form id="form1">
                <div align="center">
                    <h:outputText value="#{ManagedComponentesProdVersion.cargarComponentesProdVersionDocumentacionAplicada}"/>
                    <h:outputText styleClass="outputTextTituloSistema" value="Documentación Aplicada" />
                    <h:panelGroup id="contenido">
                        <rich:panel headerClass="headerClassACliente" style="width:50%">
                            <f:facet name="header">
                                <h:outputText value="Datos del Producto"/>

                            </f:facet>
                            <h:panelGrid columns="3" headerClass="headerClassACliente">
                                <h:outputText value="Producto" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value=":" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value="#{ManagedComponentesProdVersion.componentesProdVersionBean.nombreProdSemiterminado} " styleClass="outputText2"/>
                               <h:outputText value="Tipo Asignación Documentación" styleClass="outputTextBold" />
                               <h:outputText value=":" styleClass="outputTextBold" />
                               <a4j:commandLink reRender="contenidoSeleccionTipoAsignacionDocumento" oncomplete="javascript:Richfaces.showModalPanel('panelSeleccionTipoAsignacionDocumento');">
                                   <h:outputText id="nombreTipoAsignacionDocumentacion" value="#{ManagedComponentesProdVersion.tiposAsignacionDocumentoOmBean.nombreTipoAsignacionDocumentacionOm}" styleClass="outputText2"/>
                                   <h:graphicImage url="../../img/actualizar2.png" alt="Cambiar Proceso"/>
                               </a4j:commandLink>
                               <h:outputText value="Forma farmaceútica" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value=":" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value="#{ManagedComponentesProdVersion.componentesProdVersionBean.forma.nombreForma} " styleClass="outputText2"/>
                               <h:outputText value="Area de Fabricación" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value=":" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value="#{ManagedComponentesProdVersion.componentesProdVersionBean.areasEmpresa.nombreAreaEmpresa} " styleClass="outputText2"/>
                               <h:outputText value="Estado" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value=":" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value="#{ManagedComponentesProdVersion.componentesProdVersionBean.estadoCompProd.nombreEstadoCompProd} " styleClass="outputText2"/>
                            </h:panelGrid>
                        </rich:panel>
                    
                        <rich:dataTable value="#{ManagedComponentesProdVersion.componentesProdVersionDocumentacionAplicadaList}"
                                            var="data" id="dataDocumentacionAplicada"
                                            onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                            onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                            headerClass="headerClassACliente"  style="margin-top:1em !important">
                            <f:facet name="header">
                                <rich:columnGroup>
                                    <rich:column>
                                        <h:outputText value=""/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Documento"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Codigo Documento"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Codigo Nuevo"/>
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
                                    <h:outputText value="#{data.documentacion.nombreDocumento}"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="#{data.documentacion.codigoDocumento}"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="#{data.documentacion.codigoNuevo}"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="#{data.documentacion.tiposDocumentoBiblioteca.nombreTipoDocumentoBiblioteca}"/>
                                </rich:column>
                                
                        </rich:dataTable>
                    </h:panelGroup>
                    <br>
                        <div>
                            <a4j:commandButton value="Agregar" styleClass="btn" 
                                               oncomplete="window.location.href='agregarDocumentacionAplicada.jsf?data='+(new Date()).getTime().toString();"/>
                            <a4j:commandButton value="Eliminar" styleClass="btn" action="#{ManagedComponentesProdVersion.eliminarComponentesProdVersionDocumentacionAplicada}"
                                               onclick="if(!editarItem('form1:dataDocumentacionAplicada')){return false}"
                                               oncomplete="if(#{ManagedComponentesProdVersion.mensaje eq '1'}){alert('Se elimino la asignación del documento');}else{alert('#{ManagedComponentesProdVersion.mensaje}');}"
                                               reRender="dataDocumentacionAplicada"/>
                            <a4j:commandButton value="Volver"  styleClass="btn" oncomplete="retornarNavegador(#{ManagedComponentesProdVersion.componentesProdVersionBean.codCompprod});"/>
                         </div>   
                </div>

               
              
            </a4j:form>
           
            <rich:modalPanel id="panelSeleccionTipoAsignacionDocumento" width="280" autosized="true"
                                     zindex="90"
                                     headerClass="headerClassACliente"
                                     resizeable="false" >
                        <f:facet name="header">
                            <h:outputText value="Seleccionar Proceso"/>
                        </f:facet>
                        <a4j:form id="formContenidoSeleccionTipoAsignacionDocumento">
                        <h:panelGroup id="contenidoSeleccionTipoAsignacionDocumento">
                            <center>
                                <table>
                                    <tr>
                                        <td>
                                            <div style="height:300;overflow-y: auto;overflow-x: hidden">
                                                <rich:dataTable value="#{ManagedComponentesProdVersion.tiposAsignacionDocumentoOmList}"
                                                    var="data" id="dataDocumentacionAplicada"
                                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                                    onRowMouseOver="this.style.backgroundColor='#F3F7FD';"
                                                    headerClass="headerClassACliente"
                                                    binding="#{ManagedComponentesProdVersion.tiposAsignacionDocumentoOmDataTable}"
                                                    columnClasses="tituloCampo">
                                                    <f:facet name="header">
                                                        <rich:columnGroup>
                                                            <rich:column>
                                                                <h:outputText value="Tipo Asignación de Documentación"/>
                                                            </rich:column>
                                                        </rich:columnGroup>
                                                    </f:facet>
                                                    <rich:column>
                                                        <a4j:commandLink action="#{ManagedComponentesProdVersion.seleccionarTipoAsignacionDocumentoOm}"
                                                                         oncomplete="javascript:Richfaces.hideModalPanel('panelSeleccionTipoAsignacionDocumento')" reRender="form1:contenido">
                                                            <h:outputText value="#{data.nombreTipoAsignacionDocumentacionOm}"/>
                                                        </a4j:commandLink>
                                                    </rich:column>
                                                </rich:dataTable>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </center>
                                <br>
                                <div align="center">
                                    <a4j:commandButton  value="Cancelar"oncomplete="javascript:Richfaces.hideModalPanel('panelSeleccionTipoAsignacionDocumento')" styleClass="btn" rendered="#{ManagedComponentesProdVersion.tiposAsignacionDocumentoOmBean.codTipoAsignacionDocumentacionOm>0}"/>
                                    <a4j:commandButton oncomplete="retornarNavegador(#{ManagedComponentesProdVersion.componentesProdVersionBean.codCompprod});" rendered="#{ManagedComponentesProdVersion.tiposAsignacionDocumentoOmBean.codTipoAsignacionDocumentacionOm eq '0'}" value="Volver" styleClass="btn"/>
                                </div>
                        </h:panelGroup>
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

