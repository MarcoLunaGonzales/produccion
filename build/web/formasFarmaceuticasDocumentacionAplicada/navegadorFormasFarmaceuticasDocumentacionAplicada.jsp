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
            <script type="text/javascript">
                function verificarProcesoOm()
                {
                    if(document.getElementById("form1:nombreForma").innerHTML.length == 0)
                        javascript:Richfaces.showModalPanel('panelSeleccionarFormaFarmaceutica');
                }
                function verificarDuplicarActividades()
                {
                    if(!editarItem("form1:dataDocumentacionAplicada"))
                    {
                        return false;
                    }
                    else
                    {
                        return confirm('Esta seguro de realizar la duplicación de la indicación en las versiones de producto activos en estado de versionamiento:registrado,activo,enviado a aprobación,parcialmente enviado a aprobación');
                    }
                    return true;
                }
            </script>
        </head>
        <body onload="verificarProcesoOm();">
            <a4j:form id="form1">
                <div align="center">
                    <h:outputText value="#{ManagedFormasFarmaceuticasDocumentacionAplicada.cargarFormasFarmaceuticasDocumentacionAplicadaList}"/>
                    <h:outputText styleClass="outputTextTituloSistema"   value="Documentación Aplicada por Forma Farmaceútica" />
                    
                    <h:panelGroup id="contenido">
                        <rich:panel headerClass="headerClassACliente" style="width:50%">
                            <f:facet name="header">
                                <h:outputText value="Documentación Aplicada por Forma Farmaceútica"/>
                            </f:facet>
                            <h:panelGrid columns="3" headerClass="headerClassACliente">
                               <h:outputText value="Forma Farmaceutica" styleClass="outputTextBold" />
                               <h:outputText value=":" styleClass="outputTextBold" />
                               <a4j:commandLink oncomplete="javascript:Richfaces.showModalPanel('panelSeleccionarFormaFarmaceutica');">
                                   <h:outputText id="nombreForma" value="#{ManagedFormasFarmaceuticasDocumentacionAplicada.formasFarmaceuticasDocumentacionAplicadaBean.formasFarmaceuticas.nombreForma}" styleClass="outputText2"/>
                                   <h:graphicImage url="../img/actualizar2.png" alt="Cambiar Proceso"/>
                               </a4j:commandLink>
                               <h:outputText value="Tipo Asignación Documento O.M." styleClass="outputTextBold" />
                               <h:outputText value=":" styleClass="outputTextBold" />
                               <h:selectOneMenu value="#{ManagedFormasFarmaceuticasDocumentacionAplicada.formasFarmaceuticasDocumentacionAplicadaBean.tiposAsignacionDocumentoOm.codTipoAsignacionDocumentacionOm}" styleClass="inputText">
                                   <f:selectItem itemValue='0' itemLabel="--TODOS--"/>
                                   <f:selectItems value="#{ManagedFormasFarmaceuticasDocumentacionAplicada.tiposAsignacionDocumentoOmSelectList}"/>
                                   <a4j:support event="onchange" action="#{ManagedFormasFarmaceuticasDocumentacionAplicada.codTipoAsignacionDocumentacionOmBean_change}"
                                                reRender="dataDocumentacionAplicada"/>
                               </h:selectOneMenu>
                              
                            </h:panelGrid>
                        </rich:panel>
                    
                        <rich:dataTable value="#{ManagedFormasFarmaceuticasDocumentacionAplicada.formasFarmaceuticasDocumentacionAplicadaList}"
                                                var="data" id="dataDocumentacionAplicada"
                                                onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                                onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                                headerClass="headerClassACliente"  style="margin-top:1em !important">
                            <f:facet name="header">
                                <rich:columnGroup>
                                    <rich:column>
                                        <h:selectBooleanCheckbox onclick="seleccionarTodosCheckBox(this)"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Tipo Asignación Documento"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Documento" escape="false"/>
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
                                    <h:outputText value="#{data.tiposAsignacionDocumentoOm.nombreTipoAsignacionDocumentacionOm}"/>
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
                        <div style='margin-top:1em'>
                           
                            <a4j:commandButton value="Agregar" styleClass="btn" 
                                               oncomplete="window.location.href='agregarFormasFarmaceuticasDocumentacionAplicada.jsf?data='+(new Date()).getTime().toString()"/>
                            <a4j:commandButton value="Eliminar" styleClass="btn" action="#{ManagedFormasFarmaceuticasDocumentacionAplicada.eliminarFormasFarmaceuticasDocumentacionAplicadaList}"
                                               onclick="if(!alMenosUno('form1:dataDocumentacionAplicada')){return false}"
                                               oncomplete="if(#{ManagedFormasFarmaceuticasDocumentacionAplicada.mensaje eq '1'}){alert('Se elimino la documentación');}else{alert('#{ManagedFormasFarmaceuticasDocumentacionAplicada.mensaje}')}"
                                               reRender="dataDocumentacionAplicada"/>
                            <a4j:commandButton value="Duplicar Documentación" styleClass="btn"
                                               action="#{ManagedFormasFarmaceuticasDocumentacionAplicada.duplicarDocumentacionVersionesProducto}"
                                               onclick="if(confirm('Esta seguro de realizar la duplicacion?')){if(!alMenosUno('form1:dataDocumentacionAplicada')){return false}}else{return false}"
                                               oncomplete="if(#{ManagedFormasFarmaceuticasDocumentacionAplicada.mensaje eq '1'}){alert('Se duplico la documentación');}else{alert('#{ManagedFormasFarmaceuticasDocumentacionAplicada.mensaje}')}"
                                               />
                                               
                         </div>   
                         
                </div>

               
              
            </a4j:form>
            <rich:modalPanel id="panelSeleccionarFormaFarmaceutica" height="450" width="450"
                                     zindex="90"
                                     headerClass="headerClassACliente"
                                     resizeable="false" >
                        <f:facet name="header">
                            <h:outputText value="<center>Seleccionar Forma Farmaceútica</center>" escape="false"/>
                        </f:facet>
                        <a4j:form id="formContenidoFormaFar">
                        <h:panelGroup id="contenidoSeleccionarFormaFarmaceutica">
                            <center>
                                <table>
                                    <tr>
                                        <td>
                                            <div style="height:350;overflow-y: auto;overflow-x: hidden">
                                        <rich:dataTable value="#{ManagedFormasFarmaceuticasDocumentacionAplicada.formasFarmaceuticasList}"
                                        var="data" id="dataFormasFarmaceuticas"
                                        onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                        onRowMouseOver="this.style.backgroundColor='#F3F7FD';"
                                        headerClass="headerClassACliente"
                                        binding="#{ManagedFormasFarmaceuticasDocumentacionAplicada.formasFarmaceuticasDataTable}"
                                        columnClasses="tituloCampo">
                                        <f:facet name="header">
                                            <rich:columnGroup>
                                                <rich:column>
                                                    <h:outputText value="Forma Farmaceutica"/>
                                                </rich:column>
                                                <rich:column>
                                                    <h:outputText value="Abreviatura"/>
                                                </rich:column>
                                            </rich:columnGroup>
                                        </f:facet>
                                        <rich:column>
                                            <a4j:commandLink action="#{ManagedFormasFarmaceuticasDocumentacionAplicada.seleccionarFormaFarmaceutica_action}"
                                                             oncomplete="javascript:Richfaces.hideModalPanel('panelSeleccionarFormaFarmaceutica')" reRender="form1:contenido">
                                                <h:outputText value="#{data.nombreForma}"/>
                                            </a4j:commandLink>
                                        </rich:column>
                                        <rich:column>
                                                <h:outputText value="#{data.abreviaturaForma}"/>
                                        </rich:column>
                                    </rich:dataTable>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </center>
                                <br>
                                <div align="center">
                                    <a4j:commandButton  value="Cancelar"oncomplete="javascript:Richfaces.hideModalPanel('panelSeleccionarFormaFarmaceutica')" styleClass="btn" />
                                </div>
                        </h:panelGroup>
                        </a4j:form>
            </rich:modalPanel>
            
             
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

