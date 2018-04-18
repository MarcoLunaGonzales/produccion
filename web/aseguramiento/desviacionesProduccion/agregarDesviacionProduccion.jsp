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
                    <h:outputText value="#{ManagedDesviacionProduccion.cargarAgregarDesviacionProduccion}"/>
                    <h:outputText styleClass="outputTextTituloSistema"  value="Desviaciones Generadas" />
                    <rich:panel headerClass="">
                        <h:panelGrid columns="3">
                            <h:outputText value="Producto/Forma Farmaceutica/ N° Lote" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <a4j:commandLink action="#{ManagedDesviacionProduccion.cargarSeleccionarProgramaProduccion_action}">
                                <h:outputText value="#{ManagedDesviacionProduccion.desviacionProduccionAgregar.programaProduccion.componentesProdVersion.forma.nombreForma}"/>
                            </a4j:commandLink>
                            <h:outputText value="Area" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectOneMenu value="#{ManagedDesviacionProduccion.desviacionProduccionAgregar.areasEmpresa.codAreaEmpresa}">
                                <f:selectItems value="#{ManagedDesviacionProduccion.areasEmpresaSelectList}"/>
                            </h:selectOneMenu>
                            <h:outputText value="Tipo Desviación" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectOneRadio value="#{ManagedDesviacionProduccion.desviacionProduccionAgregar.tiposDesviacionProduccion.codTipoDesviacionProduccion}" styleClass="outputText2">
                                <f:selectItems value="#{ManagedDesviacionProduccion.tiposDesviacionSelectList}"/>
                            </h:selectOneRadio>
                            <h:outputText value="Proviente de" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectOneRadio value="#{ManagedDesviacionProduccion.desviacionProduccionAgregar.fuentesDesviacionProduccion.codFuenteDesviacionProduccion}" styleClass="outputText2">
                                <f:selectItems value="#{ManagedDesviacionProduccion.fuentesDesviacionSelectList}"/>
                            </h:selectOneRadio>
                            <h:outputText value="Fecha detección" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <rich:calendar value="#{ManagedDesviacionProduccion.desviacionProduccionAgregar.fechaDeteccion}" datePattern="dd/MM/yyyy">
                            </rich:calendar>
                            <h:outputText value="Fecha Informe" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:outputText value="#{ManagedDesviacionProduccion.desviacionProduccionAgregar.fechaInforme}" styleClass="outputText2">
                                <f:convertDateTime pattern="dd/MM/yyyy HH:mm"/>
                            </h:outputText>
                        </h:panelGrid>
                    </rich:panel>
                    <br>
                    <a4j:commandButton value="Guardar"
                                       action="#{ManagedDesviacionProduccion.guardarAgregarDesviacionProduccion_action}"
                                       oncomplete="if(#{ManagedDesviacionProduccion.mensaje eq '1'}){alert('Se registro la desviación');redireccionar('navegadorDesviacionesProduccion.jsf');}
                                       else{alert('#{ManagedDesviacionProduccion.mensaje}');}" styleClass="btn"/>
                    <a4j:commandButton value="Cancelar" styleClass="btn"
                                       oncomplete="redireccionar('navegadorDesviacionesProduccion.jsf');"/>
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

