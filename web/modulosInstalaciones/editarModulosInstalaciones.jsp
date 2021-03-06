<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>
    <html>
        <head>
            <title>Editar Modulo Instalación</title>
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" /> 
            <script type="text/javascript" src='../js/general.js' ></script> 
            <script>
                 function validarRegistroNuevoModulo()
                 {
                     return (validarRegistroNoVacio(document.getElementById("form1:nombreModulo")));
                 }
            </script>
        </head>
        <body>
            <a4j:form id="form1"  >                
                <div align="center">
                    <span class="outputTextTituloSistema">Editar Módulo Instalación</span>
                    <rich:panel headerClass="headerClassACliente" style="width:70%">
                        <f:facet name="header">
                            <h:outputText value="Edición de Módulo Instalación"/>
                        </f:facet>
                        <h:panelGrid columns="3">
                            <h:outputText value="Módulo Instalación" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:inputText value="#{ManagedModulosInstalaciones.modulosInstalacionesEditar.nombreModuloInstalacion}" styleClass="inputText" id="nombreModulo" style="width:30 em"/>
                            <h:outputText value="Observación" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:inputTextarea value="#{ManagedModulosInstalaciones.modulosInstalacionesEditar.obsModuloInstalacion}" styleClass="inputText" rows="3" style="width:100%">
                            </h:inputTextarea>
                            <h:outputText value="Estado" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectOneMenu value="#{ManagedModulosInstalaciones.modulosInstalacionesEditar.estadoReferencial.codEstadoRegistro}" styleClass="inputText">
                                <f:selectItem itemLabel="Activo" itemValue="1"/>
                                <f:selectItem itemLabel="No Activo" itemValue="2"/>
                            </h:selectOneMenu>
                        </h:panelGrid>
                        <br>
                        <a4j:commandButton value="Guardar" styleClass="btn" action="#{ManagedModulosInstalaciones.guardarEdicionModulosInstalaciones_action}"
                                           onclick="if(!validarRegistroNuevoModulo()){return false;}"
                                           oncomplete="if(#{ManagedModulosInstalaciones.mensaje eq '1'}){alert('Se registro la edición');window.location.href='navegadorModulosInstalaciones.jsf?add='+(new Date()).getTime().toString();}else{alert('#{ManagedModulosInstalaciones.mensaje}')}"/>
                        <a4j:commandButton value="Cancelar" styleClass="btn" oncomplete="window.location.href='navegadorModulosInstalaciones.jsf?cancel='+(new Date()).getTime().toString()"/>
                    </rich:panel>
                    <br> 
                    
                </div>
                
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
        </body>
    </html>
    
</f:view>

