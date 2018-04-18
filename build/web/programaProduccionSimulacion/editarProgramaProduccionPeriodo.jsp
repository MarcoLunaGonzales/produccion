<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>
<f:view>
    
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" /> 
            <script type="text/javascript" src="../js/general.js" ></script> 

            <script  type="text/javascript">
                function validarRegistro()
                {
                    return validarRegistroNoVacio(document.getElementById("form1:nombreProgramaProduccion"));
                }
            </script>

        </head>
            <a4j:form id="form1"   >
                <div align="center" >
                    <h:outputText value="Editar Programa de Producción de Simulación" styleClass="outputTextTituloSistema"/>
                    <rich:panel headerClass="headerClassACliente" style="width:80%">
                        <f:facet name="header">
                            <h:outputText value="Datos del programa produccion de simulación"/>
                        </f:facet>
                        <h:panelGrid columns="3">
                            <h:outputText styleClass="outputTextBold" value="Programa Simulación"/>
                            <h:outputText styleClass="outputTextBold" value="::"/>
                            <h:inputText style="width:30em" id="nombreProgramaProduccion" value="#{ManagedProgramaProduccionSimulacion.programaProduccionPeriodoEditar.nombreProgramaProduccion}"  styleClass="inputText"/>
                            <h:outputText styleClass="outputTextBold" value="Cantidad Lote"/>
                            <h:outputText styleClass="outputTextBold" value="::"/>
                            <h:inputTextarea style="width:100%" value="#{ManagedProgramaProduccionSimulacion.programaProduccionPeriodoEditar.obsProgramaProduccion}" styleClass="inputText">
                                
                            </h:inputTextarea>
                            <h:outputText styleClass="outputTextBold" value="Estado"/>
                            <h:outputText styleClass="outputTextBold" value="::"/>
                            <h:outputText value="Simulación" styleClass="outputText2"/>
                        </h:panelGrid>
                        
                        <a4j:commandButton value="Guardar" action="#{ManagedProgramaProduccionSimulacion.guardarEditarProgramaProduccionPeriodo_action}" onclick="if(!validarRegistro()){return false;}"
                                        oncomplete="if(#{ManagedProgramaProduccionSimulacion.mensaje eq '1'}){alert('Se edito el programa de produccion periodo');
                                        window.location.href='navegadorProgramaProduccionPeriodoSimulacion.jsf?data='+(new Date()).getTime().toString();}else{alert('#{ManagedProgramaProduccionSimulacion.mensaje}');}" styleClass="btn"/>
                        <a4j:commandButton styleClass="btn" 
                                           oncomplete="window.location.href='navegadorProgramaProduccionPeriodoSimulacion.jsf?cancel='+(new Date()).getTime().toString();" 
                                           value="Cancelar" />
                    </rich:panel>
                    
            </a4j:form>
                    <a4j:status id="statusPeticion"
                                onstart="Richfaces.showModalPanel('ajaxLoadingModalBox',{width:100, top:100})"
                                onstop="Richfaces.hideModalPanel('ajaxLoadingModalBox')">
                     </a4j:status>
                    <rich:modalPanel id="ajaxLoadingModalBox" minHeight="100"
                                     minWidth="200" height="80" width="400" zindex="100" onshow="window.focus();">
                        <div align="center">
                            <h:graphicImage value="../img/load2.gif" />
                        </div>
                    </rich:modalPanel>
        
            </div>
            
        <script type="text/javascript" language="JavaScript"  src="../js/dlcalendar.js"></script>
        </body>
    </html>
    
</f:view>

