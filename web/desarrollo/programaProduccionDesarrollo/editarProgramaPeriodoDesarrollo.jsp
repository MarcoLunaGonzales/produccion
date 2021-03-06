<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>
    
    <html>
        <head>
            <meta http-equiv="X-UA-Compatible" content="IE=7" />
            <title></title>
            <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" /> 
            <script type="text/javascript" src="../../js/general.js" ></script> 
        </head>
        <body>
            <a4j:form id="form1"  >
                <center>
                <rich:panel headerClass="headerClassACliente" style="width:80%">
                    <f:facet name="header">
                        <h:outputText value="Editar Programa De Desarrollo"/>
                    </f:facet>
                    <h:panelGrid columns="3">
                        <h:outputText value="Nombre" styleClass="outputTextBold"/>
                        <h:outputText value="::" styleClass="outputTextBold"/>
                        <h:inputText value="#{ManagedProgramaProduccionDesarrolloVersion.programaPeriodoDesarroloEditar.nombreProgramaProduccion}" styleClass="inputText" style="width:30em"/>
                        <h:outputText value="Observación" styleClass="outputTextBold"/>
                        <h:outputText value="::" styleClass="outputTextBold"/>
                        <h:inputTextarea value="#{ManagedProgramaProduccionDesarrolloVersion.programaPeriodoDesarroloEditar.obsProgramaProduccion}" styleClass="inputText" style="width:30em"
                        rows="4"/>
                        <h:outputText value="Fecha Inicio" styleClass="outputTextBold"/>
                        <h:outputText value="::" styleClass="outputTextBold"/>
                        <h:panelGroup>
                            <h:inputText value="#{ManagedProgramaProduccionDesarrolloVersion.programaPeriodoDesarroloEditar.fechaInicio}" styleClass="inputText" id="fechaInicio">
                                <f:convertDateTime pattern="dd/MM/yyyy"/>
                            </h:inputText>
                            <h:graphicImage url="../../img/fecha.bmp" id="imagenFecha1"/>
                            <DLCALENDAR tool_tip="Seleccione la Fecha" input_element_id="form1:fechaInicio" click_element_id="form1:imagenFecha1"/>
                        </h:panelGroup>
                        <h:outputText value="Fecha Final" styleClass="outputTextBold"/>
                        <h:outputText value="::" styleClass="outputTextBold"/>
                        <h:panelGroup>
                            <h:inputText value="#{ManagedProgramaProduccionDesarrolloVersion.programaPeriodoDesarroloEditar.fechaFinal}" styleClass="inputText" id="fechaFinal">
                                <f:convertDateTime pattern="dd/MM/yyyy"/>
                            </h:inputText>
                            <h:graphicImage url="../../img/fecha.bmp" id="imagenFechaFinal"/>
                            <DLCALENDAR tool_tip="Seleccione la Fecha" input_element_id="form1:fechaFinal" click_element_id="form1:imagenFechaFinal"/>
                        </h:panelGroup>
                    </h:panelGrid>
                    <div style="margin-top:1em;">
                        <a4j:commandButton value="Guardar" status="statusGuardar" action="#{ManagedProgramaProduccionDesarrolloVersion.guardarEdicionProgramaPeriodoDesarrollo_action}" styleClass="btn"
                        oncomplete="if(#{ManagedProgramaProduccionDesarrolloVersion.mensaje eq '1'}){alert('Se guardo la edicion del programa produccion periodo');redireccionar('navegadorProgramaPeriodoDesarrollo.jsf')}
                        else{alert('#{ManagedProgramaProduccionDesarrolloVersion.mensaje}');}"/>
                        <a4j:commandButton status="statusGuardar" value="Cancelar" oncomplete="redireccionar('navegadorProgramaPeriodoDesarrollo.jsf')" styleClass="btn"/>
                    </div>
                </rich:panel>
                
                </center>
                
            </a4j:form>
            <a4j:status id="statusGuardar"
                        onstart="Richfaces.showModalPanel('ajaxLoadingModalBox')"
                        onstop="Richfaces.hideModalPanel('ajaxLoadingModalBox')">
            </a4j:status>

            <rich:modalPanel id="ajaxLoadingModalBox" minHeight="100"
                             minWidth="200" height="80" width="400" zindex="100" onshow="window.focus();">

                <div align="center">
                    <h:graphicImage value="../../img/load2.gif" />
                </div>
            </rich:modalPanel>


        </body>
        <script type="text/javascript" language="JavaScript"  src="../js/dlcalendar.js"></script>
        
    </html>
    
</f:view>

