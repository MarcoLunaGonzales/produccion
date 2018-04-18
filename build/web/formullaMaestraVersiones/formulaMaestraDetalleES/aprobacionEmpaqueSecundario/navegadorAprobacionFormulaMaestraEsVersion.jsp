<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>
<f:view>
    
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../../../css/ventas.css" />
            <script type="text/javascript" src="../../../js/general.js" ></script> 
            
        </head>
        <body>
            <h:form id="form1">
                
                <div align="center">
                    <h:outputText value="#{ManagedFormulaMaestraEsVersion.cargarFormulaMaestraEsVersionAprobacionList}"/>
                    <span class="outputTextTituloSistema">Revisión de Cambios de EmpaqueSecundario</span>
                    <rich:dataTable value="#{ManagedFormulaMaestraEsVersion.formulaMaestraEsVersionAprobacionList}" var="data" 
                                    id="dataFormulaMaestraEsVersion" style="margin-top:0.5em"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#CCDFFA';" 
                                    headerClass="headerClassACliente">
                        <f:facet name="header">
                            <rich:columnGroup>
                                <rich:column>
                                    <h:outputText value=""/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Producto"  />
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Tamaño Lote Producción"  />
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Personal Creación"  />
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Fecha Creación"  />
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Fecha Inicio Vigencia"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Observación"/>
                                </rich:column>
                            </rich:columnGroup>
                        </f:facet>
                        <rich:column>
                            <h:selectBooleanCheckbox value="#{data.checked}"/>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.componentesProdVersion.nombreProdSemiterminado}"/>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.componentesProdVersion.tamanioLoteProduccion}"/>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.personal.nombrePersonal}" />
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.fechaCreacion}">
                                <f:convertDateTime pattern="dd/MM/yyyy HH:mm"/>
                            </h:outputText>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.fechaAprobacion}">
                                <f:convertDateTime pattern="dd/MM/yyyy HH:mm"/>
                            </h:outputText>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.observacion}"/>
                        </rich:column>
                        
                    </rich:dataTable>
                    
                    <br>
                    <a4j:commandButton value="Revisar" styleClass="btn" action="#{ManagedFormulaMaestraEsVersion.seleccionarRevisionFormulaMaestraEsVersionAprobacion_action}"
                                       onclick="if(!editarItem('form1:dataFormulaMaestraEsVersion')){return false;}"
                                       oncomplete="window.location.href='revisionFormulaMaestraEsVersion.jsf?data='+(new Date()).getTime().toString();"/>
                    <a4j:commandButton value="Devolver" styleClass="btn" action="#{ManagedFormulaMaestraEsVersion.devolverVersionFormulaMaestraEsVersion_action}"
                                       onclick="if(!editarItem('form1:dataFormulaMaestraEsVersion')){return false;}"
                                       reRender="dataFormulaMaestraEsVersion"
                                       oncomplete="if(#{ManagedFormulaMaestraEsVersion.mensaje eq '1'}){alert('Se devolvió la versión de empaque secundario');}else{alert('#{ManagedFormulaMaestraEsVersion.mensaje}');}"/>
                </div>
                
                
            </h:form>
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

