<%@taglib prefix="h" uri="http://java.sun.com/jsf/html" %>
<%@taglib prefix="f" uri="http://java.sun.com/jsf/core" %>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j" %>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>

    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
            <script type="text/javascript" src="../js/general.js" ></script>
            <script type="text/javascript">
                function verificarProcesoOm()
                {
                    if(document.getElementById("form1:nombreForma").innerHTML.length == 0)
                        javascript:Richfaces.showModalPanel('panelSeleccionarFormaFarmaceutica');
                }
                function verificarDuplicarActividades()
                {
                    if(!editarItem("form1:dataIndicacionesFormaFar"))
                    {
                        return false;
                    }
                    else
                    {
                        return confirm('Esta seguro de realizar la duplicación de la indicación en las versiones de producto activos en estado de versionamiento:registrado,activo,enviado a aprobación,parcialmente enviado a aprobación');
                    }
                    return true;
                }
            </script>
        </head>
        <body onload="verificarProcesoOm();">
            <a4j:form id="form1">
                <div align="center">
                    <h:outputText value="#{ManagedFormasFarmaceuticasIndicaciones.cargarFormasFarmaceuticasIndicaciones}"/>
                    <h:outputText styleClass="outputTextTituloSistema"   value="Indicaciones por Forma Farmaceutica" />
                    
                    <h:panelGroup id="contenido">
                        <rich:panel headerClass="headerClassACliente" style="width:50%">
                            <f:facet name="header">
                                <h:outputText value="Indicaciones por Forma Farmaceutica"/>
                            </f:facet>
                            <h:panelGrid columns="3" headerClass="headerClassACliente">
                               <h:outputText value="Forma Farmaceutica" styleClass="outputTextBold" />
                               <h:outputText value=":" styleClass="outputTextBold" />
                               <a4j:commandLink oncomplete="javascript:Richfaces.showModalPanel('panelSeleccionarFormaFarmaceutica');">
                                   <h:outputText id="nombreForma" value="#{ManagedFormasFarmaceuticasIndicaciones.formasFarmaceuticaBean.nombreForma}" styleClass="outputText2"/>
                                   <h:graphicImage url="../img/actualizar2.png" alt="Cambiar Proceso"/>
                               </a4j:commandLink>
                               <h:outputText value="Proceso Orden Manufactura" styleClass="outputTextBold" />
                               <h:outputText value=":" styleClass="outputTextBold" />
                               <h:selectOneMenu value="#{ManagedFormasFarmaceuticasIndicaciones.codProcesoOrdenManufactura}" styleClass="inputText">
                                   <f:selectItem itemLabel="--TODOS--" itemValue='0'/>
                                   <f:selectItems value="#{ManagedFormasFarmaceuticasIndicaciones.procesosOrdenManufacturaSelectList}"/>
                                   <a4j:support event="onchange" reRender="dataIndicacionesFormaFar" action="#{ManagedFormasFarmaceuticasIndicaciones.codProcesoOrdenManufactura_change}"/>
                               </h:selectOneMenu>
                            </h:panelGrid>
                        </rich:panel>
                    
                        <rich:dataTable value="#{ManagedFormasFarmaceuticasIndicaciones.formasFarmaceuticasIndicacionesList}"
                                                var="data" id="dataIndicacionesFormaFar"
                                                onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                                onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                                headerClass="headerClassACliente"  style="margin-top:1em !important">
                            <f:facet name="header">
                                <rich:columnGroup>
                                    <rich:column>
                                        <h:selectBooleanCheckbox onclick="seleccionarTodosCheckBox(this)"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Proceso<br>Orden<br>Manufactura" escape="false"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Tipo Indicación"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Indicación Forma"/>
                                    </rich:column>
                                </rich:columnGroup>
                            </f:facet>
                                <rich:column>
                                    <h:selectBooleanCheckbox value="#{data.checked}"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="#{data.procesosOrdenManufactura.nombreProcesoOrdenManufactura}"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="#{data.tiposIndicacionProceso.nombreTipoIndicacionProceso}"/>
                                </rich:column>
                                <rich:column>
                                    <h:inputTextarea value="#{data.indicacionesForma}" styleClass="inputText" rows="4" style='width:40em' onkeypress="return false;"/>
                                </rich:column>
                        </rich:dataTable>
                        </h:panelGroup>
                        <div style='margin-top:1em'>
                            <a4j:commandButton value="Editar" styleClass="btn" action="#{ManagedFormasFarmaceuticasIndicaciones.editarFormaFarmaceuticaIndicacion_action}"
                                               onclick="if(!editarItem('form1:dataIndicacionesFormaFar')){return false;}"
                                               reRender="contenidoEditarFormaFarmaceuticaIndicacion"
                                               oncomplete="javascript:Richfaces.showModalPanel('panelEditarFormaFarmaceuticaIndicacion')"/>
                            <a4j:commandButton value="Duplicar Indicación en Productos" styleClass="btn" 
                                               action="#{ManagedFormasFarmaceuticasIndicaciones.duplicarIndicacionEnProductosActivosProceso_action}"
                                               oncomplete="if(#{ManagedFormasFarmaceuticasIndicaciones.mensaje eq '1'}){alert('Se registro la duplicación');}
                                               else {alert('#{ManagedFormasFarmaceuticasIndicaciones.mensaje}');}"/>
                         </div>   
                         
                </div>

               
              
            </a4j:form>
            <rich:modalPanel id="panelSeleccionarFormaFarmaceutica" height="450" width="450"
                                     zindex="90"
                                     headerClass="headerClassACliente"
                                     resizeable="false" >
                        <f:facet name="header">
                            <h:outputText value="<center>Seleccionar Forma Farmaceútica</center>" escape="false"/>
                        </f:facet>
                        <a4j:form id="formContenidoFormaFar">
                        <h:panelGroup id="contenidoSeleccionarFormaFarmaceutica">
                            <center>
                                <table>
                                    <tr>
                                        <td>
                                            <div style="height:350;overflow-y: auto;overflow-x: hidden">
                                    <rich:dataTable value="#{ManagedFormasFarmaceuticasIndicaciones.formasFarmaceuticasList}"
                                        var="data" id="dataFormasFarmaceuticas"
                                        onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                        onRowMouseOver="this.style.backgroundColor='#F3F7FD';"
                                        headerClass="headerClassACliente"
                                        binding="#{ManagedFormasFarmaceuticasIndicaciones.formasFarmaceuticasDataTable}"
                                        columnClasses="tituloCampo">
                                        <f:facet name="header">
                                            <rich:columnGroup>
                                                <rich:column>
                                                    <h:outputText value="Forma Farmaceútica<br><input type='text' onkeyup='buscarCeldaAgregar(this,0)' class='inputText'>" escape="false"/>
                                                </rich:column>
                                                <rich:column>
                                                    <h:outputText value="Abreviatura"/>
                                                </rich:column>
                                            </rich:columnGroup>
                                        </f:facet>
                                        <rich:column>
                                            <a4j:commandLink action="#{ManagedFormasFarmaceuticasIndicaciones.seleccionarFormaFarmaceutica_action}"
                                                             oncomplete="javascript:Richfaces.hideModalPanel('panelSeleccionarFormaFarmaceutica')" reRender="form1:contenido">
                                                <h:outputText value="#{data.nombreForma}"/>
                                            </a4j:commandLink>
                                        </rich:column>
                                        <rich:column>
                                                <h:outputText value="#{data.abreviaturaForma}"/>
                                        </rich:column>
                                    </rich:dataTable>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </center>
                                <br>
                                <div align="center">
                                    <a4j:commandButton  value="Cancelar"oncomplete="javascript:Richfaces.hideModalPanel('panelSeleccionarFormaFarmaceutica')" styleClass="btn" />
                                </div>
                        </h:panelGroup>
                        </a4j:form>
            </rich:modalPanel>
            <rich:modalPanel id="panelEditarFormaFarmaceuticaIndicacion" width="470" height="250"
                                     zindex="90"
                                     headerClass="headerClassACliente"
                                     resizeable="false" >
                        <f:facet name="header">
                            <h:outputText value="<center>Edición de Indicación por Forma Farmaceutica</center>" escape="false"/>
                        </f:facet>
                        <a4j:form id="formEditarFormaFarmaceuticaIndicacion">
                        <h:panelGroup id="contenidoEditarFormaFarmaceuticaIndicacion">
                            <center>
                                <h:panelGrid columns="3">
                                    <h:outputText value="Forma Farmaceutica" styleClass="outputTextBold"/>
                                    <h:outputText value="::" styleClass="outputTextBold"/>
                                    <h:outputText value="#{ManagedFormasFarmaceuticasIndicaciones.formasFarmaceuticaBean.nombreForma}" styleClass="outputText2"/>
                                    <h:outputText value="Proceso Orden Manufactura" styleClass="outputTextBold"/>
                                    <h:outputText value="::" styleClass="outputTextBold"/>
                                    <h:outputText value="#{ManagedFormasFarmaceuticasIndicaciones.formasFarmaceuticasIndicacionEditar.procesosOrdenManufactura.nombreProcesoOrdenManufactura}" styleClass="outputText2"/>
                                    <h:outputText value="Tipo Indicación" styleClass="outputTextBold"/>
                                    <h:outputText value="::" styleClass="outputTextBold"/>
                                    <h:outputText value="#{ManagedFormasFarmaceuticasIndicaciones.formasFarmaceuticasIndicacionEditar.tiposIndicacionProceso.nombreTipoIndicacionProceso}" styleClass="outputText2"/>
                                    <h:outputText value="Indicación" styleClass="outputTextBold"/>
                                    <h:outputText value="::" styleClass="outputTextBold"/>
                                    <h:outputText value="" styleClass="outputTextBold"/>
                                    
                                </h:panelGrid>
                                <h:inputTextarea value="#{ManagedFormasFarmaceuticasIndicaciones.formasFarmaceuticasIndicacionEditar.indicacionesForma}" styleClass="inputText" style="width:40em" rows="5"/>
                            </center>
                                <br>
                                <div align="center">
                                    <a4j:commandButton value="Guardar" action="#{ManagedFormasFarmaceuticasIndicaciones.guardarEditarFormaFarmaceuticaIndicacion_action}" styleClass="btn" 
                                                       reRender="dataIndicacionesFormaFar"
                                                       oncomplete="if(#{ManagedFormasFarmaceuticasIndicaciones.mensaje eq 1}){alert('Se guardo la modificación de la indicación');Richfaces.hideModalPanel('panelEditarFormaFarmaceuticaIndicacion');}
                                                       else{alert('#{ManagedFormasFarmaceuticasIndicaciones.mensaje}')}"/>
                                    <a4j:commandButton  value="Cancelar"oncomplete="javascript:Richfaces.hideModalPanel('panelEditarFormaFarmaceuticaIndicacion')" styleClass="btn" />
                                </div>
                        </h:panelGroup>
                        </a4j:form>
            </rich:modalPanel>
             
             <a4j:status id="statusPeticion"
                        onstart="Richfaces.showModalPanel('ajaxLoadingModalBox',{width:100, top:100})"
                        onstop="Richfaces.hideModalPanel('ajaxLoadingModalBox')">
            </a4j:status>

            <rich:modalPanel id="ajaxLoadingModalBox" minHeight="250"
                             minWidth="200" height="80" width="400" zindex="250" onshow="window.focus();">

                <div align="center">
                    <h:graphicImage value="../img/load2.gif" />
                </div>
            </rich:modalPanel>
        </body>
    </html>

</f:view>

