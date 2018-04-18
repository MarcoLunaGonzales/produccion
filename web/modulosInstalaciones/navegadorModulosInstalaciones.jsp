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
            <script type="text/javascript" src='../js/general.js' ></script> 
            <script>
                
            </script>
        </head>
        <body >
            <a4j:form id="form1"  >                
                <div align="center">  
                    <h:outputText value="#{ManagedModulosInstalaciones.cargarModulosInstalaciones}"/>
                    <span class="outputTextTituloSistema">Módulos Instalaciones</span>
                    <br>
                    <rich:dataTable value="#{ManagedModulosInstalaciones.modulosInstalacionesList}"
                                    var="data" id="dataModulosInstalaciones" 
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#CCDFFA';" 
                                    headerClass="headerClassACliente"
                                    >
                        <f:facet name="header">
                            <rich:columnGroup>
                                <rich:column>
                                    <h:outputText value=""/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Nombre Módulos Instalación"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Observacion"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Estado"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Partes Módulo"/>
                                </rich:column>
                            </rich:columnGroup>
                        </f:facet>
                        <rich:column >
                            <h:selectBooleanCheckbox value="#{data.checked}"  />
                        </rich:column>
                        
                        <rich:column>
                            <h:outputText value="#{data.nombreModuloInstalacion}"  />
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.obsModuloInstalacion}"  />
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.estadoReferencial.nombreEstadoRegistro}"  />
                        </rich:column>  
                        <rich:column>
                            <h:outputText value="<a  onclick=\"getCodigo('#{data.codModuloInstalacion}');\" style='cursor:hand;text-decoration:underline' ><img src='../img/organigrama3.jpg' alt='Partes Módulo '></a>  "  escape="false"  />
                        </rich:column> 
                    </rich:dataTable>
                    
                    <br>
                    <a4j:commandButton value="Agregar" oncomplete="window.location.href='agregarModulosInstalaciones.jsf?add='+(new Date()).getTime().toString();" styleClass="btn"/>
                    <a4j:commandButton value="Editar" oncomplete="window.location.href='editarModulosInstalaciones.jsf?edit='+(new Date()).getTime().toString();" styleClass="btn"
                                       action="#{ManagedModulosInstalaciones.editarModulosInstalaciones_action}"
                                       onclick="if(!editarItem('form1:dataModulosInstalaciones')){return false;}"/>
                    <a4j:commandButton value="Eliminar" oncomplete="if(#{ManagedModulosInstalaciones.mensaje eq '1'}){alert('Se elimino el modulo instalación');}else{alert('#{ManagedModulosInstalaciones.mensaje}')}" styleClass="btn"
                                       action="#{ManagedModulosInstalaciones.eliminarModulosInstalaciones_action}" reRender="dataModulosInstalaciones"
                                       onclick="if(!editarItem('form1:dataModulosInstalaciones')){return false;}"/>
                    
                    
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

