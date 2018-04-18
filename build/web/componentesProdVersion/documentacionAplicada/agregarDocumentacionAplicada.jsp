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
            </script>
        </head>
        <body >
            <a4j:form id="form1">
                <div align="center">
                    <h:outputText value="#{ManagedComponentesProdVersion.cargarAgregarComponentesProdVersionDocumentacionAplicada}"/>
                    <h:outputText styleClass="outputTextTituloSistema"   value="Agregar Documentación Aplicada" />
                    <br/>
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
                               <h:outputText id="nombreTipoAsignacionDocumentacion" value="#{ManagedComponentesProdVersion.tiposAsignacionDocumentoOmBean.nombreTipoAsignacionDocumentacionOm}" styleClass="outputText2"/>
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
                    
                    <rich:dataTable value="#{ManagedComponentesProdVersion.componentesProdVersionDocumentacionAplicadaAgregarList}"
                                            var="data" id="dataAgregarDocumentacionAplicada" 
                                            headerClass="headerClassACliente"  style="margin-top:1em !important">
                        <f:facet name="header">
                            <rich:columnGroup>
                                <rich:column>
                                        <h:outputText value=""/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Documento<br><input type='text' onkeyup='buscarCeldaAgregar(this,1)' class='inputText'>" escape="false"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Codigo Documento" escape="false"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Codigo Nuevo" escape="false"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Tipo Documento" escape="false"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Area Empresa" escape="false"/>
                                    </rich:column>
                            </rich:columnGroup>
                        </f:facet>
                               <rich:column>
                                    <h:selectBooleanCheckbox value="#{data.checked}" onclick="seleccionarRegistro(this)"/>
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
                                <rich:column>
                                    <h:outputText value="#{data.documentacion.areasEmpresa.nombreAreaEmpresa}"/>
                                </rich:column>
                        </rich:dataTable>
                        <div id="bottonesAcccion" class="barraBotones">
                            <a4j:commandButton value="Guardar" styleClass="btn" action="#{ManagedComponentesProdVersion.guardarAgregarComponentesProdVersionDocumentacionAplicada}"
                                               onclick="if(!editarItems('form1:dataAgregarDocumentacionAplicada')){return false;}"
                                               oncomplete="if(#{ManagedComponentesProdVersion.mensaje eq '1'}){alert('La información se guardo de forma correcta');window.location.href='navegadorDocumentacionAplicada.jsf?save='+(new Date()).getTime().toString();}
                                               else{alert('#{ManagedComponentesProdVersion.mensaje}');}"/>
                            <a4j:commandButton value="Cancelar"  styleClass="btn" oncomplete="window.location.href='navegadorDocumentacionAplicada.jsf?dontsave='+(new Date()).getTime().toString()"/>
                        </div>   
                         
                </div>

               
              
            </a4j:form>

             
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

