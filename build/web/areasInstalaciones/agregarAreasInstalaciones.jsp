<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>
    <html>
        <head>
            <title>Agregar Areas Instalaciones</title>
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" /> 
            <script type="text/javascript" src='../js/general.js' ></script> 
            <script type="text/javascript">
                function validarGuardarRegistro()
                {
                    return (validarRegistroNoVacio(document.getElementById("form1:nombreInstalacion"))&&validarRegistroNoVacio(document.getElementById("form1:codigo")));
                }
            </script>
        </head>
        <body>
            <a4j:form id="form1"  >                
                <div align="center">
                    <span class="outputTextTituloSistema">Registro Instalación COFAR</span>
                    <h:outputText value="#{ManagedAreasInstalaciones.cargarAgregarAreaInstalacion}"/>
                    <rich:panel headerClass="headerClassACliente" style="width:70%">
                        <f:facet name="header">
                            <h:outputText value="Registro de Instalación COFAR"/>
                        </f:facet>
                        <h:panelGrid columns="3">
                            <h:outputText value="Nombre" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:inputText value="#{ManagedAreasInstalaciones.areaInstalacionAgregar.nombreAreaInstalacion}" styleClass="inputText" id="nombreInstalacion" style="width:25 em"/>
                            <h:outputText value="Código" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:inputText value="#{ManagedAreasInstalaciones.areaInstalacionAgregar.codigo}" styleClass="inputText" id="codigo" style="width:25 em"/>
                            <h:outputText value="Area Empresa" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectOneMenu value="#{ManagedAreasInstalaciones.areaInstalacionAgregar.areasEmpresa.codAreaEmpresa}" styleClass="inputText" id="codAreaEmpresa">
                                <f:selectItems value="#{ManagedAreasInstalaciones.areasEmpresaSelectList}"/>
                            </h:selectOneMenu>
                        </h:panelGrid>
                        <a4j:commandButton value="Guardar" styleClass="btn" action="#{ManagedAreasInstalaciones.guardarAgregarAreaInstalacion_action}"
                                           oncomplete="if(#{ManagedAreasInstalaciones.mensaje eq '1'}){alert('Se registro el area Instalación');window.location.href='navegadorAreasIntalaciones.jsf?data='+(new Date()).getTime().toString();}else{alert('#{ManagedAreasInstalaciones.mensaje}')}"
                                           onclick="if(!validarGuardarRegistro()){return false;}"/>
                        <a4j:commandButton value="Cancelar" styleClass="btn" oncomplete="window.location.href='navegadorAreasIntalaciones.jsf?data='+(new Date()).getTime().toString()"/>
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

