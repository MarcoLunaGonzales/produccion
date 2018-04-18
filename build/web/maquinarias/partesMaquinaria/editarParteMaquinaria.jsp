<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>
<f:view>
    
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
            <script type="text/javascript" src="../../js/general.js" ></script> 
            <script>
                function validarRegistro()
                {
                    return(validarRegistroNoVacio(document.getElementById("form1:codigoParteMaquinaria"))&&validarRegistroNoVacio(document.getElementById("form1:nombreParteMaquinaria")));
                }
            </script>
        </head>
        <body >
            <a4j:form id="form1">               
                <div align="center">
                    <h:outputText styleClass="outputTextTituloSistema"  value="Edición Parte Maquinaria" /> 
                    <rich:panel headerClass="headerClassACliente" style="width:80%">
                        <f:facet name="header">
                            <h:outputText value="DATOS DE MAQUINARIA"/>
                        </f:facet>
                        <h:panelGrid columns="6">
                            <h:outputText value="Maquinaria" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:outputText value="#{ManagedMaquinaria.maquinariaBean.nombreMaquina}" styleClass="outputText2"/>
                            <h:outputText value="Código" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:outputText value="#{ManagedMaquinaria.maquinariaBean.codigo}" styleClass="outputText2"/>
                            <h:outputText value="Tipo de Maquinaria" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:outputText value="#{ManagedMaquinaria.maquinariaBean.tiposEquiposMaquinaria.nombreTipoEquipo}" styleClass="outputText2"/>
                            <h:outputText value="Area Empresa" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:outputText value="#{ManagedMaquinaria.maquinariaBean.areasEmpresa.nombreAreaEmpresa}" styleClass="outputText2"/>
                            <h:outputText value="Estado" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:outputText value="#{ManagedMaquinaria.maquinariaBean.estadoReferencial.nombreEstadoRegistro}" styleClass="outputText2"/>
                            <h:outputText value="Observación" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:outputText value="#{ManagedMaquinaria.maquinariaBean.obsMaquina}" styleClass="outputText2"/>
                            <h:outputText value="Material Asociado Almacen" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            
                        </h:panelGrid>    
                    </rich:panel>
                    <br>
                    <rich:panel headerClass="headerClassACliente" style="width:80%">
                        <f:facet name="header">
                            <h:outputText value="Editar Parte Maquinaria"/>
                        </f:facet>
                        <h:panelGrid columns="3">
                            <h:outputText value="Código" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:inputText value="#{ManagedMaquinaria.partesMaquinariaEditar.codigo}" id="codigoParteMaquinaria" style="width:30em" styleClass="inputText"/>
                            <h:outputText value="Nombre" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:inputText value="#{ManagedMaquinaria.partesMaquinariaEditar.nombreParteMaquina}" id="nombreParteMaquinaria" style="width:100%" styleClass="inputText"/>
                            <h:outputText value="Tipo De Maquinaria" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectOneMenu value="#{ManagedMaquinaria.partesMaquinariaEditar.tiposEquiposMaquinaria.codTipoEquipo}" styleClass="inputText">
                                <f:selectItems value="#{ManagedMaquinaria.tiposEquipoSelectList}"/>
                            </h:selectOneMenu>
                            <h:outputText value="Descripción" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:inputTextarea value="#{ManagedMaquinaria.partesMaquinariaEditar.obsParteMaquina}" styleClass="inputText" rows="4" style="width:100%">
                            </h:inputTextarea>
                            <h:outputText value="Material Asociado Almacen" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectOneMenu value="#{ManagedMaquinaria.partesMaquinariaEditar.materiales.codMaterial}" styleClass="inputText">
                                <f:selectItem itemValue='0' itemLabel="--No Aplica--"/>
                                <f:selectItems value="#{ManagedMaquinaria.materialesSelectList}"/>
                            </h:selectOneMenu>
                        </h:panelGrid>
                        <a4j:commandButton value="Guardar" onclick="if(!validarRegistro()){return false;}" styleClass="btn" action="#{ManagedMaquinaria.guardarEdicionParteMaquinaria_action}"
                                           oncomplete="if(#{ManagedMaquinaria.mensaje eq '1'}){alert('Se registro la nueva parte maquinaria');window.location.href='navegadorPartesMaquinaria.jsf?data='+(new Date()).getTime().toString();}
                                           else{alert('#{ManagedMaquinaria.mensaje}');}"/>
                        <a4j:commandButton value="Cancelar" styleClass="btn" oncomplete="window.location.href='navegadorPartesMaquinaria.jsf?'+(new Date()).getTime().toString()"
                                           reRender="dataMaquinarias"/>
                    </rich:panel>
                    
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
                    <h:graphicImage value="../img/load2.gif" />
                </div>
            </rich:modalPanel>
        </body>
    </html>
    
</f:view>

