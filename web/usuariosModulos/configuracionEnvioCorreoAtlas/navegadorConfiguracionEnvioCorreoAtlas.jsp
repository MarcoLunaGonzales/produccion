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
            <link rel="STYLESHEET" type="text/css" href="../../css/chosen.css" />
            <script type="text/javascript" src="../../js/general.js" ></script>
            
          
        </head>
        <body >
            <a4j:form id="form1">
                <div align="center">
                    <h:outputText value="#{ManagedAdministracionAccesosSistema.cargarConfiguracionMotivoEnvioCorreoAtlas}"/>
                    <h:outputText styleClass="outputTextTituloSistema"  value="Configuración envio correo atlas" />
                    <rich:panel headerClass="headerClassACliente"  style="width:70%">
                        <f:facet name="header">
                            <h:outputText value="Motivo Envio Correo"/>
                        </f:facet>
                        <h:panelGrid columns="3">
                            <h:outputText value="Motivo Envio Correo" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectOneMenu value="#{ManagedAdministracionAccesosSistema.configuracionEnvioCorreoAtlasBuscar.motivoEnvioCorreoAtlas.codMotivoEnvioCorreoAtlas}" styleClass="inputText chosen">
                                <f:selectItem itemLabel="--TODOS--" itemValue='0'/>
                                <f:selectItems value="#{ManagedAdministracionAccesosSistema.motivosEnvioCorreoAtlasSelect}"/>
                            </h:selectOneMenu>
                        </h:panelGrid>
                        <a4j:commandButton value="BUSCAR" styleClass="btn" action="#{ManagedAdministracionAccesosSistema.buscarConfiguracionEnvioCorreoAtlas_action}"
                                           reRender="dataConfiguracionCorreo"/>
                    </rich:panel>
                    <br>
                    <rich:dataTable value="#{ManagedAdministracionAccesosSistema.configuracionEnvioCorreoAtlasList}"
                                    var="data"
                                    id="dataConfiguracionCorreo"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente" >
                        <f:facet name="header">
                            <rich:columnGroup>
                                <rich:column>
                                    <h:outputText value=""/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Personal"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Correo"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Motivo envio correo"/>
                                </rich:column>
                            </rich:columnGroup>
                        </f:facet>
                        <rich:column>
                            <h:selectBooleanCheckbox  value="#{data.checked}"  />
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.personal.nombrePersonal}"/>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.personal.nombreCorreoPersonal}"/>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.motivoEnvioCorreoAtlas.nombreMotivoEnvioCorreoAtlas}"/>
                        </rich:column>
                    </rich:dataTable>
                  
                    <br>
                    <a4j:commandButton value="Agregar" styleClass="btn" 
                                       oncomplete="window.location.href='agregarConfiguracionEnvioCorreoAtlas.jsf?data='+(new Date()).getTime().toString();"/>
                    <a4j:commandButton value="Eliminar" styleClass="btn" onclick="if(confirm('Esta seguro de eliminar la configuracion?')){if(alMenosUno('form1:dataConfiguracionCorreo')==false){return false;}}else{return false;}"  action="#{ManagedAdministracionAccesosSistema.eliminarConfiguracionEnvioCorreoAtlas}"
                                       oncomplete="if(#{ManagedAdministracionAccesosSistema.mensaje eq '1'}){alert('Se elimino la configuracion')}else{alert('#{ManagedAdministracionAccesosSistema.mensaje}');}" reRender="dataConfiguracionCorreo"/>

                   
                </div>

               
              
            </a4j:form>
            <a4j:include viewId="/panelProgreso.jsp"/>
            
        </body>
    </html>

</f:view>

