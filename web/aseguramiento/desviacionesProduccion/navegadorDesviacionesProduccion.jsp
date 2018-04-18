<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>
<f:view>

    <html>
        <head>
            <title>Desviaciones</title>
            <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
            <script type="text/javascript" src="../../js/general.js" ></script>
       
          
        </head>
        <body >
            <a4j:form id="form1">
                <div align="center">
                    <h:outputText value="#{ManagedDesviacionProduccion.cargarDesviacionProduccionList}"/>
                    <h:outputText styleClass="outputTextTituloSistema"  value="Desviaciones Generadas" />
                    <rich:dataTable value="#{ManagedDesviacionProduccion.desviacionProduccionList}"
                                    var="data" style="margin-top:8px"
                                    id="dataDesviacionProduccionList"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente">
                        <f:facet name="header">
                            <rich:columnGroup>
                                <rich:column>
                                    <h:outputText value="Fecha Detección"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Fecha Informe"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Area donde se detecta la desviación"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Tipo de desviación"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Proviene de "/>
                                </rich:column>
                            </rich:columnGroup>
                        </f:facet>
                        <rich:column>
                            <h:outputText value="#{data.fechaDeteccion}">
                                <f:convertDateTime pattern="dd/MM/yyyy HH:mm"/>
                            </h:outputText>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.fechaInforme}">
                                <f:convertDateTime pattern="dd/MM/yyyy HH:mm"/>
                            </h:outputText>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.areasEmpresa.nombreAreaEmpresa}"/>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.tiposDesviacionProduccion.nombreTipoDesviacionProduccion}"/>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.fuentesDesviacionProduccion.nombreFuenteDesviacionProduccion}"/>
                        </rich:column>
                    </rich:dataTable>
                    <br>
                        <a4j:commandButton value="Agregar" styleClass="btn"
                                           oncomplete="redireccionar('agregarDesviacionProduccion.jsf');"/>
                        
                </div>

               
              
            </a4j:form>
            
            
             <a4j:status id="statusPeticion"
                        onstart="Richfaces.showModalPanel('ajaxLoadingModalBox',{width:100, top:100})"
                        onstop="Richfaces.hideModalPanel('ajaxLoadingModalBox')">
            </a4j:status>

            <rich:modalPanel id="ajaxLoadingModalBox" minHeight="100"
                             minWidth="200" height="80" width="400" zindex="500" onshow="window.focus();">

                <div align="center">
                    <h:graphicImage value="../../img/load2.gif" />
                </div>
            </rich:modalPanel>
        </body>
    </html>

</f:view>

