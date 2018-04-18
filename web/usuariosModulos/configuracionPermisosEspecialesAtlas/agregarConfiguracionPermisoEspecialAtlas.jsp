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
            </script>
          
        </head>
        <body >
            <a4j:form id="form1">
                <div align="center">
                    <h:outputText value="#{ManagedAdministracionAccesosSistema.cargarAgregarConfiguracionPermisosEspecialesAtlas}"/>
                    <h:outputText styleClass="outputTextTituloSistema"  value="Agregar Configuración Permisos Atlas" />
                    <rich:panel headerClass="headerClassACliente"  style="width:70%">
                        <f:facet name="header">
                            <h:outputText value="Tipo Permiso"/>
                        </f:facet>
                        <h:panelGrid columns="3">
                            <h:outputText value="Tipo Permiso" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectOneMenu value="#{ManagedAdministracionAccesosSistema.configuracionPermisosEspecialesAtlasAgregar.tiposPermisosEspecialesAtlas.codTipoPermisoEspecialAtlas}" styleClass="inputText">
                                <f:selectItems value="#{ManagedAdministracionAccesosSistema.tiposPermisosEspecialesAtlasSelect}"/>
                            </h:selectOneMenu>
                        </h:panelGrid>
                    </rich:panel>
                    <br>
                    
                    <rich:dataTable value="#{ManagedAdministracionAccesosSistema.configuracionPermisosEspecialesAtlasAgregarList}"
                                    var="data"
                                    id="dataPermisosAtlas"
                                    headerClass="headerClassACliente" >
                        <f:facet name="header">
                            <rich:columnGroup>
                                <rich:column>
                                    <h:outputText value=""/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Personal<br><input onkeyup='buscarCeldaAgregar(this,1)' class='inputText'>" escape="false"/>
                                </rich:column>
                            </rich:columnGroup>
                        </f:facet>
                        <rich:column>
                            <h:selectBooleanCheckbox  value="#{data.checked}" onclick="seleccionarRegistro(this)" />
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.personal.nombrePersonal}"/>
                        </rich:column>
                    </rich:dataTable>
                  
                    <br>
                    <div id="bottonesAcccion" class="barraBotones">
                        <a4j:commandButton value="Guardar" styleClass="btn" action="#{ManagedAdministracionAccesosSistema.guardarAgregarConfiguracionPermisosEspecialesAtlas}" 
                                           onclick="if(!alMenosUno('form1:dataPermisosAtlas')){return false}"
                                           oncomplete="if(#{ManagedAdministracionAccesosSistema.mensaje eq '1'}){alert('Se registro la configuracion');window.location.href='navegadorConfiguracionPermisosEspecialesAtlas.jsf?data='+(new Date()).getTime().toString();}else{alert('#{ManagedAdministracionAccesosSistema.mensaje}');}" />
                        <a4j:commandButton value="Cancelar" styleClass="btn" oncomplete="window.location.href='navegadorConfiguracionPermisosEspecialesAtlas.jsf?cancel='+(new Date()).getTime().toString();" />
                    </div>
                   
                </div>

               
              
            </a4j:form>

             
             <a4j:status id="statusPeticion"
                                onstart="Richfaces.showModalPanel('ajaxLoadingModalBox',{width:100, top:100})"
                                onstop="Richfaces.hideModalPanel('ajaxLoadingModalBox')">
                    </a4j:status>

                    <rich:modalPanel id="ajaxLoadingModalBox" minHeight="100"
                                     minWidth="200" height="80" width="400" zindex="500" onshow="window.focus();">

                        <div align="center">
                            <h:graphicImage value="../img/load2.gif" />
                        </div>
                    </rich:modalPanel>
        </body>
    </html>

</f:view>

