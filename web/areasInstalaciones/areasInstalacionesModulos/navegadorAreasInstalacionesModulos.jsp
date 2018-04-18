<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>
<f:view>
    
    <html>
        <head>
            <title>Navegador Modulos</title>
            <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
            <script type="text/javascript" src="../../js/general.js" ></script> 
            <script>
            </script>
        </head>
        <body>
            <a4j:form id="form1">
               <h:outputText value="#{ManagedAreasInstalaciones.cargarAreasInstalacionesModulos}"   />
                <div align="center">
                    <span class="outputTextTituloSistema">Modulos del Area Empresa</span>
                    <rich:panel headerClass="headerClassACliente" style="width:70%">
                        <f:facet name="header">
                            <h:outputText value="Modulos del Area Empresa"/>
                        </f:facet>
                        <h:panelGrid columns="3">
                            <h:outputText value="Código Instalación" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:outputText value="#{ManagedAreasInstalaciones.areasInstalacionesBean.codigo}" styleClass="outputText2"/>
                            <h:outputText value="Area" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:outputText value="#{ManagedAreasInstalaciones.areasInstalacionesBean.areasEmpresa.nombreAreaEmpresa}" styleClass="outputText2"/>
                            <h:outputText value="Nombre" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:outputText value="#{ManagedAreasInstalaciones.areasInstalacionesBean.nombreAreaInstalacion}" styleClass="outputText2"/>
                        </h:panelGrid>
                    </rich:panel>
                    <br>
                    <rich:dataTable value="#{ManagedAreasInstalaciones.areasInstalacionesModuloList}"
                                    var="data" id="dataAreasInstalacionesModulos" 
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#CCDFFA';" 
                                    headerClass="headerClassACliente">
                        <f:facet name="header">
                            <rich:columnGroup>
                                <rich:column>
                                    <h:outputText value=""/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Código"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Módulo"/>
                                </rich:column>
                            </rich:columnGroup>
                        </f:facet>
                        <rich:column>
                            <h:selectBooleanCheckbox value="#{data.checked}"  />
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.codigo}"/>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.modulosInstalaciones.nombreModuloInstalacion}"/>
                        </rich:column>
                    </rich:dataTable>
                    <br>
                    <a4j:commandButton value="Agregar" styleClass="btn" oncomplete="window.location.href='agregarAreasInstalacionesModulos.jsf?nav='+(new Date()).getTime().toString();"/>
                    <a4j:commandButton value="Eliminar" styleClass="btn" action="#{ManagedAreasInstalaciones.eliminarAreasInstalacionesModulos_action}"
                                       onclick="if(!editarItem('form1:dataAreasInstalacionesModulos')){return false;}"
                                       oncomplete="if(#{ManagedAreasInstalaciones.mensaje eq '1'}){alert('Se elimino el modulo');}else{alert('#{ManagedAreasInstalaciones.mensaje}');}"
                                       reRender="dataAreasInstalacionesModulos"/>
                    <a4j:commandButton value="Cancelar" styleClass="btn" oncomplete="window.location.href='../navegadorAreasIntalaciones.jsf?cancel='+(new Date()).getTime().toString();"/>
                    
                </div>
                
            </a4j:form>
            
        </body>
    </html>
    
</f:view>

