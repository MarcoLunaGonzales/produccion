<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>
<f:view>
    
    <html>
        <head>
            <title>Partes Maquinarias</title>
            <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
            <script type="text/javascript" src="../../js/general.js" ></script> 
        </head>
        <body >
            <h:form id="form1">               
                <div align="center">
                    <h:outputText value="#{ManagedMaquinaria.cargarPartesMaquinariaList}"/>
                    <h:outputText styleClass="outputTextTituloSistema"  value="Listado de Parte de Maquinaria" />                    
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
                        </h:panelGrid>    
                    </rich:panel>
                    <br>
                    <rich:dataTable value="#{ManagedMaquinaria.partesMaquinariaList}"
                                    var="data" id="dataPartesMaquinaria" 
                                    style="margin-top:1em;top:1em"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';" 
                                    headerClass="headerClassACliente" >
                        <f:facet name="header">
                            <rich:columnGroup>
                                <rich:column>
                                    <h:outputText value=""/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="CODIGO"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="NOMBRE"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="TIPO DE MAQUINARIA"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="DESCRIPCIÓN"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="MATERIAL ASOCIADO"/>
                                </rich:column>
                            </rich:columnGroup>
                        </f:facet>
                        <rich:column>
                            <h:selectBooleanCheckbox value="#{data.checked}"/>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.codigo}"/>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.nombreParteMaquina}"/>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.tiposEquiposMaquinaria.nombreTipoEquipo}"/>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.obsParteMaquina}" escape="false"/>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.materiales.nombreMaterial}" escape="false"/>
                        </rich:column>
                    </rich:dataTable>
                    </br>
                    <a4j:commandButton value="Agregar" onclick="window.location.href='agregarParteMaquinaria.jsf?data='+(new Date()).getTime().toString()"
                                       styleClass="btn"/>
                    <a4j:commandButton value="Editar" onclick="if(!editarItem('form1:dataPartesMaquinaria')){return false;}"
                                       action="#{ManagedMaquinaria.editarPartesMaquinaria_action}"
                                       oncomplete="window.location.href='editarParteMaquinaria.jsf?data='+(new Date()).getTime().toString()"
                                       styleClass="btn"/>
                    <a4j:commandButton value="Eliminar" onclick="if(!editarItem('form1:dataPartesMaquinaria')){return false;}"
                                       action="#{ManagedMaquinaria.eliminarPartesMaquinaria_action}"
                                       oncomplete="if(#{ManagedMaquinaria.mensaje eq '1'}){alert('Se elimino la parte maquinaria');}else{alert('#{ManagedMaquinaria.mensaje}');}"
                                       reRender="dataPartesMaquinaria" styleClass="btn"/>
                    <a4j:commandButton value="Cancelar" oncomplete="window.location.href='../navegadorMaquinarias.jsf?cancel='+(new Date()).getTime().toString();" styleClass="btn"/>
                    </div>
                    <br>
                </div>
                
            </h:form>
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

