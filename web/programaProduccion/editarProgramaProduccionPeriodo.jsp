<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>
    
    <html>
        <head>
            <meta http-equiv="X-UA-Compatible" content="IE=7" />
            <title></title>
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" /> 
            <script type="text/javascript" src="../js/general.js" ></script> 
        </head>
        <body>
            <a4j:form id="form1"  >
                <center>
                <rich:panel headerClass="headerClassACliente" style="width:80%">
                    <f:facet name="header">
                        <h:outputText value="Editar Programa Produccion Periodo"/>
                    </f:facet>
                    <h:panelGrid columns="3">
                        <h:outputText value="Nombre" styleClass="outputTextBold"/>
                        <h:outputText value="::" styleClass="outputTextBold"/>
                        <h:inputText value="#{ManagedProgramaProduccion.programaProduccionPeriodoEditar.nombreProgramaProduccion}" styleClass="inputText" style="width:30em"/>
                        <h:outputText value="Observación" styleClass="outputTextBold"/>
                        <h:outputText value="::" styleClass="outputTextBold"/>
                        <h:inputTextarea value="#{ManagedProgramaProduccion.programaProduccionPeriodoEditar.obsProgramaProduccion}" styleClass="inputText" style="width:30em"
                        rows="4"/>
                    </h:panelGrid>
                    <div style="margin-top:1em;">
                        <a4j:commandButton value="Guardar" status="statusGuardar" action="#{ManagedProgramaProduccion.guardarEdicionProgramaProduccionPeriodo_action}" styleClass="btn"
                        oncomplete="if(#{ManagedProgramaProduccion.mensaje eq '1'}){alert('Se guardo la edicion del programa produccion periodo');window.location.href='navegadorProgramaPeriodo.jsf?data'+(new Date()).getTime().toString();}
                        else{alert('#{ManagedProgramaProduccion.mensaje}');}"/>
                        <a4j:commandButton status="statusGuardar" value="Cancelar" oncomplete="window.location.href='navegadorProgramaPeriodo.jsf?cancel'+(new Date()).getTime().toString();" styleClass="btn"/>
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
                    <h:graphicImage value="../img/load2.gif" />
                </div>
            </rich:modalPanel>


        </body>
        <script type="text/javascript" language="JavaScript"  src="../js/dlcalendar.js"></script>
        
    </html>
    
</f:view>

