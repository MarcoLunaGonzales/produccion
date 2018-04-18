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
                    <span class="outputTextTituloSistema">Aprobación de Cambios de Empaque Secundario</span>
                    <rich:panel headerClass="headerClassACliente">
                        <f:facet name="header">
                            <h:outputText value="Datos de la versión"/>
                        </f:facet>
                        <h:panelGrid columns="3">
                            <h:outputText styleClass="outputTextBold" value="Producto" />
                            <h:outputText styleClass="outputTextBold" value="::" />
                            <h:outputText styleClass="outputText2" value="#{ManagedFormulaMaestraEsVersion.formulaMaestraEsVersionRevision.componentesProdVersion.nombreProdSemiterminado}" />
                            <h:outputText styleClass="outputTextBold" value="Tamaño Lote Producción" />
                            <h:outputText styleClass="outputTextBold" value="::" />
                            <h:outputText styleClass="outputText2" value="#{ManagedFormulaMaestraEsVersion.formulaMaestraEsVersionRevision.componentesProdVersion.tamanioLoteProduccion}" />
                                
                        </h:panelGrid>
                        <h:outputText value="<iframe src=\"../empaqueSecundarioJasper/reporteComparacionVersionesEmpaqueSecundario.jsf?codFormulaMaestraEsVersion=#{ManagedFormulaMaestraEsVersion.formulaMaestraEsVersionRevision.codFormulaMaestraEsVersion}\" width=\"100%\" height=\"400px\"></iframe><br>" escape="false"/>
                        <center>
                            <a4j:commandButton value="Aprobar" styleClass="btn" action="#{ManagedFormulaMaestraEsVersion.aprobarFormulaMaestraEsVersion_action}"
                                               oncomplete="if(#{ManagedFormulaMaestraEsVersion.mensaje eq '1'}){alert('Se aprobaron los cambios de presentación y empaque secundario');window.location.href='navegadorAprobacionFormulaMaestraEsVersion.jsf?aprobar='+(new Date()).getTime().toString();}
                                               else{alert('#{ManagedFormulaMaestraEsVersion.mensaje}');}"/>
                            <a4j:commandButton value="Cancelar" styleClass="btn" oncomplete="window.location.href='navegadorAprobacionFormulaMaestraEsVersion.jsf?cancel='+(new Date()).getTime().toString();"/>  
                        </center>
                    </rich:panel>
                    
                    
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

