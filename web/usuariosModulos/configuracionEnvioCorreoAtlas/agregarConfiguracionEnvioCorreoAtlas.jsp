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
            <script>
            </script>
          
        </head>
        <body >
            <a4j:form id="form1">
                <div align="center">
                    <h:outputText value="#{ManagedAdministracionAccesosSistema.cargarAgregarConfiguracionEnvioCorreoAtlas}"/>
                    <h:outputText styleClass="outputTextTituloSistema"  value="Agregar Configuración Envio Correo Atlas" />
                    <rich:panel headerClass="headerClassACliente"  style="width:70%">
                        <f:facet name="header">
                            <h:outputText value="Motivo Envio Correo"/>
                        </f:facet>
                        <h:panelGrid columns="3">
                            <h:outputText value="Motivo Envio Correo" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectOneMenu value="#{ManagedAdministracionAccesosSistema.configuracionEnvioCorreoAtlasAgregar.motivoEnvioCorreoAtlas.codMotivoEnvioCorreoAtlas}" styleClass="inputText chosen">
                                <f:selectItems value="#{ManagedAdministracionAccesosSistema.motivosEnvioCorreoAtlasSelect}"/>
                            </h:selectOneMenu>
                        </h:panelGrid>
                    </rich:panel>
                    <br>
                    
                    <rich:dataTable value="#{ManagedAdministracionAccesosSistema.configuracionEnvioCorreoAtlasAgregarList}"
                                    var="data"
                                    id="dataConfiguracionCorreo"
                                    headerClass="headerClassACliente" >
                        <f:facet name="header">
                            <rich:columnGroup>
                                <rich:column>
                                    <h:outputText value=""/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Personal<br><input onkeyup='buscarCeldaAgregar(this,1)' class='inputText'>" escape="false"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Correo"/>
                                </rich:column>
                            </rich:columnGroup>
                        </f:facet>
                        <rich:column>
                            <h:selectBooleanCheckbox  value="#{data.checked}" onclick="seleccionarRegistro(this)" />
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.personal.nombrePersonal}"/>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.personal.nombreCorreoPersonal}"/>
                        </rich:column>
                    </rich:dataTable>
                  
                    <br>
                    <div id="bottonesAcccion" class="barraBotones">
                        <a4j:commandButton value="Guardar" styleClass="btn" action="#{ManagedAdministracionAccesosSistema.guardarAgregarConfiguracionEnvioCorreoAtlas}" 
                                           onclick="if(!alMenosUno('form1:dataConfiguracionCorreo')){return false}"
                                           oncomplete="if(#{ManagedAdministracionAccesosSistema.mensaje eq '1'}){alert('Se registro la configuracion');window.location.href='navegadorConfiguracionEnvioCorreoAtlas.jsf?data='+(new Date()).getTime().toString();}else{alert('#{ManagedAdministracionAccesosSistema.mensaje}');}" />
                        <a4j:commandButton value="Cancelar" styleClass="btn" oncomplete="window.location.href='navegadorConfiguracionEnvioCorreoAtlas.jsf?cancel='+(new Date()).getTime().toString();" />
                    </div>
                   
                </div>

               
              
            </a4j:form>

             
            <a4j:include viewId="/panelProgreso.jsp"/>
        </body>
    </html>

</f:view>

