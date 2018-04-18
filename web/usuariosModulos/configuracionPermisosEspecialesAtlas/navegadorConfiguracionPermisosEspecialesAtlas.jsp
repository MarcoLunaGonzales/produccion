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
            
          
        </head>
        <body >
            <a4j:form id="form1">
                <div align="center">
                    <h:outputText value="#{ManagedAdministracionAccesosSistema.cargarConfiguracionPermisosEspecialesAtlas}"/>
                    <h:outputText styleClass="outputTextTituloSistema"  value="Configuración Permisos Atlas" />
                    <rich:panel headerClass="headerClassACliente"  style="width:70%">
                        <f:facet name="header">
                            <h:outputText value="Tipo Permiso"/>
                        </f:facet>
                        <h:panelGrid columns="3">
                            <h:outputText value="Tipo Permiso" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectOneMenu value="#{ManagedAdministracionAccesosSistema.configuracionPermisosEspecialesAtlasBuscar.tiposPermisosEspecialesAtlas.codTipoPermisoEspecialAtlas}" styleClass="inputText">
                                <f:selectItem itemLabel="--TODOS--" itemValue='0'/>
                                <f:selectItems value="#{ManagedAdministracionAccesosSistema.tiposPermisosEspecialesAtlasSelect}"/>
                            </h:selectOneMenu>
                        </h:panelGrid>
                        <a4j:commandButton value="BUSCAR" styleClass="btn" action="#{ManagedAdministracionAccesosSistema.buscarConfiguracionPermisosEspecialesAtlas_action}"
                                           reRender="dataPermisosAtlas"/>
                    </rich:panel>
                    <br>
                    <rich:dataTable value="#{ManagedAdministracionAccesosSistema.configuracionPermisosEspecialesAtlasList}"
                                    var="data"
                                    id="dataPermisosAtlas"
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
                                    <h:outputText value="Tipo Permiso"/>
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
                            <h:outputText value="#{data.tiposPermisosEspecialesAtlas.nombreTipoPermisoEspecialAtlas}"/>
                        </rich:column>
                    </rich:dataTable>
                  
                    <br>
                    <a4j:commandButton value="Agregar" styleClass="btn" 
                                       oncomplete="window.location.href='agregarConfiguracionPermisoEspecialAtlas.jsf?data='+(new Date()).getTime().toString();"/>
                    <a4j:commandButton value="Eliminar" styleClass="btn" onclick="if(confirm('Esta seguro de eliminar la configuracion?')){if(alMenosUno('form1:dataPermisosAtlas')==false){return false;}}else{return false;}"  action="#{ManagedAdministracionAccesosSistema.eliminarConfiguracionPermisosEspecialesAtlas}"
                                       oncomplete="if(#{ManagedAdministracionAccesosSistema.mensaje eq '1'}){alert('Se elimino la configuracion')}else{alert('#{ManagedAdministracionAccesosSistema.mensaje}');}" reRender="dataPermisosAtlas"/>

                   
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

