package configuracionSolicitudesMateriales;

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
           
            <script type="text/javascript" src="../js/general.js" ></script>
           
          
        </head>
        <body >
          <a4j:form id="form1">
                <div align="center">
                    <h:outputText value="#{ManagedConfiguracionSolicitudesMateriales.cargarConfiguracionSolicitudesMateriales}"/>
                    <h:outputText styleClass="outputTextTitulo"  value="Procesos de Solicitud Automática de Empaque Segundario" />
                    <br>
                    </br>
                   

                       <rich:dataTable value="#{ManagedConfiguracionSolicitudesMateriales.configuracionSolicitudesMaterialesList}"
                                    var="data"
                                    id="dataConfSolMat"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente" >
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value=""  />
                            </f:facet>
                            <h:selectBooleanCheckbox  value="#{data.checked}"  />
                        </rich:column>
                       <rich:column >
                            <f:facet name="header">
                                <h:outputText value="Area Empresa Producto"  />
                            </f:facet>
                            <h:outputText value="#{data.areaEmpresaProducto.nombreAreaEmpresa}" />
                        </rich:column>
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value="Proceso"  />
                            </f:facet>
                            <h:outputText value="#{data.areaEmpresaActividad.nombreAreaEmpresa}" />
                        </rich:column>
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value="Actividad"  />
                            </f:facet>
                            <h:outputText value="#{data.actividadProduccion.nombreActividad}" />
                        </rich:column>
                        
                    </rich:dataTable>
                    <br>
                        <a4j:commandButton value="Cambiar" styleClass="btn" action="#{ManagedConfiguracionSolicitudesMateriales.editarConfiguracion_Action}" oncomplete="Richfaces.showModalPanel('PanelModificarConfSol')" reRender="contenidoModificarConfSolMat" />
                       
                        
                      

                </div>



            </a4j:form>
             <rich:modalPanel id="PanelModificarConfSol" minHeight="150"  minWidth="610"
                                     height="150" width="610"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Modificar proceso-actividad Solicitud Automática Empaque Secundario"/>
                        </f:facet>
                        <a4j:form id="form4">
                            <center>
                        <h:panelGroup id="contenidoModificarConfSolMat">
                            <center>
                            <b><h:outputText value="Area producto:" styleClass="outputText1" /></b>
                                <h:outputText value="#{ManagedConfiguracionSolicitudesMateriales.configuracionSolicitudesMaterialesEditar.areaEmpresaProducto.nombreAreaEmpresa}" styleClass="outputText1" />
                                </center>
                                <br>
                            <h:panelGrid columns="2">

                                
                                <h:outputText value="Proceso Actividad :" styleClass="outputText1" />
                                <h:selectOneMenu value="#{ManagedConfiguracionSolicitudesMateriales.configuracionSolicitudesMaterialesEditar.areaEmpresaActividad.codAreaEmpresa}"
                                 styleClass="inputText">
                                    <f:selectItems value="#{ManagedConfiguracionSolicitudesMateriales.areasEmpresaActividadList}"/>
                                </h:selectOneMenu>
                                <h:outputText value="Actividad :" styleClass="outputText1" />
                                <h:selectOneMenu value="#{ManagedConfiguracionSolicitudesMateriales.configuracionSolicitudesMaterialesEditar.actividadProduccion.codActividad}"
                                style="width:250px" styleClass="inputText">
                                    <f:selectItems value="#{ManagedConfiguracionSolicitudesMateriales.actividadesProduccionList}"/>
                                </h:selectOneMenu>
                                
                                
                            </h:panelGrid>
                         
                                
                        </h:panelGroup>
                        <br>
                       <a4j:commandButton styleClass="btn" value="Guardar"
                       action="#{ManagedConfiguracionSolicitudesMateriales.guardarEdicionConfiguracionSolicitudesMateriales_Action}" oncomplete="javascript:Richfaces.hideModalPanel('PanelModificarConfSol');" reRender="dataConfSolMat" />
                                <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('PanelModificarConfSol')" class="btn" />
                               </center>
                        </a4j:form>
                         
            </rich:modalPanel>

           <rich:modalPanel id="PanelAsigarPorArea" minHeight="200"  minWidth="505"
                                     height="200" width="505"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Editar Lugar Acondicionamiento"/>
                        </f:facet>
                        <a4j:form id="formEditar">
                        <h:panelGroup id="contenidoAsignarPorArea">
                            <h:panelGrid columns="4">

                                <h:outputText value="Area :" styleClass="outputText1" />
                                <h:selectOneMenu value="#{ManagedConfSolicitudesAutomaticasEs.componentesProdEditar.areasEmpresa.codAreaEmpresa}" styleClass="inputText">
                                    <f:selectItems value="#{ManagedConfSolicitudesAutomaticasEs.areasEmpresaList}"/>
                                </h:selectOneMenu>

                                <h:outputText value="Lugar Acondicionamiento:" styleClass="outputText1" />
                                <h:selectOneMenu value="#{ManagedConfSolicitudesAutomaticasEs.componentesProdEditar.lugarAcond.codLugarAcond}" styleClass="inputText">
                                    <f:selectItems value="#{ManagedConfSolicitudesAutomaticasEs.lugaresAcondList}"/>
                                </h:selectOneMenu>

                                
                            </h:panelGrid>

                            </h:panelGroup>
                        
                                <div align="center">
                                <a4j:commandButton styleClass="btn" value="Guardar"
                                action="#{ManagedConfSolicitudesAutomaticasEs.guardarCambioAreaGeneral}" oncomplete="javascript:Richfaces.hideModalPanel('PanelAsigarPorArea');" reRender="dataConfSolMat" />
                                <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('PanelAsigarPorArea')" class="btn" />

                                </div>
                        </a4j:form>
            </rich:modalPanel>

             
                 
        </body>
    </html>

</f:view>

