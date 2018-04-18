<%@taglib prefix="h" uri="http://java.sun.com/jsf/html" %>
<%@taglib prefix="f" uri="http://java.sun.com/jsf/core" %>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j" %>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>

    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
            <script type="text/javascript" src="../../js/general.js" ></script>
            <script type="text/javascript">
                function verificarSeleccionMaquinaria()
                {
                    if(document.getElementById("form1:nombreMaquinaria").innerHTML.length == 0)
                        javascript:Richfaces.showModalPanel('panelSeleccionarMaquinaria');
                }
            </script>
        </head>
        <body onload="verificarSeleccionMaquinaria()">
            <a4j:form id="form1">
                <div align="center">
                    <h:outputText value="#{ManagedMaquinariaRecetaEspecificacion.cargarMaquinariaRecetaEspecificacion}"/>
                    <h:outputText styleClass="outputTextTituloSistema" value="Especificaciones por Maquinaria" />
                    <h:panelGroup id="contenido">
                        <rich:panel headerClass="headerClassACliente" style="width:50%">
                            <f:facet name="header">
                                <h:outputText value="Datos del Producto"/>
                            </f:facet>
                            <h:panelGrid columns="3" headerClass="headerClassACliente">
                                <h:outputText value="Maquinaria" styleClass="outputTextBold" />
                                <h:outputText value=":" styleClass="outputTextBold" />
                                <a4j:commandLink reRender="contenidoSeleccionMaquinaria" oncomplete="javascript:Richfaces.showModalPanel('panelSeleccionarMaquinaria');">
                                    <h:outputText id="nombreMaquinaria" value="#{ManagedMaquinariaRecetaEspecificacion.maquinariaBean.nombreMaquina}" styleClass="outputText2"/>
                                    <h:graphicImage url="../../img/actualizar2.png" alt="Cambiar Proceso"/>
                                </a4j:commandLink>
                                <h:outputText value="Código" styleClass="outputTextBold"/>
                                <h:outputText value=":" styleClass="outputTextBold"/>
                                <h:outputText value="#{ManagedMaquinariaRecetaEspecificacion.maquinariaBean.codigo}" styleClass="outputText2"/>
                                <h:outputText value="Código" styleClass="outputTextBold"/>
                                <h:outputText value=":" styleClass="outputTextBold"/>
                                <h:outputText value="#{ManagedMaquinariaRecetaEspecificacion.maquinariaBean.codigo}" styleClass="outputText2"/>
                            </h:panelGrid>
                        </rich:panel>
                    
                        <rich:dataTable value="#{ManagedMaquinariaRecetaEspecificacion.maquinariaRecetaDetalleEspecificacionProcesoList}"
                                            var="data" id="dataRecetaEspecificacion"
                                            onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                            onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                            headerClass="headerClassACliente"  style="margin-top:1em !important">
                            <f:facet name="header">
                                <rich:columnGroup>
                                    <rich:column>
                                        <h:outputText value=""/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Nombre Especificación"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Tipo Descripción"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Unidad de Medida"/>
                                    </rich:column>
                                </rich:columnGroup>
                            </f:facet>
                            <rich:column >
                                <h:selectBooleanCheckbox value="#{data.checked}"  />
                            </rich:column>
                            <rich:column >
                                <h:outputText value="#{data.especificacionProceso.nombreEspecificacionProceso}"  />
                            </rich:column>
                            <rich:column>
                                <h:outputText value="#{data.especificacionProceso.tiposDescripcion.nombreTipoDescripcion}"/>
                            </rich:column>
                            <rich:column>
                                <h:outputText value="#{data.especificacionProceso.unidadMedida.nombreUnidadMedida}"/>
                            </rich:column>
                        </rich:dataTable>
                    </h:panelGroup>
                        <div style='margin-top:1em'>
                            <a4j:commandButton value="Agregar" styleClass="btn" oncomplete="window.location.href='agregarMaquinariaRecetaEspecificacion.jsf?data='+(new Date()).getTime().toString()"/>
                            <a4j:commandButton value="Eliminar" styleClass="btn" action="#{ManagedMaquinariaRecetaEspecificacion.eliminarMaquinariaRecetaEspecificacionProceso_action}"
                                               onclick="if(!editarItem('form1:dataRecetaEspecificacion')){return false;}"
                                               oncomplete="if(#{ManagedMaquinariaRecetaEspecificacion.mensaje eq '1'}){alert('Se elimino la especificación seleccionada');}else{alert('#{ManagedMaquinariaRecetaEspecificacion.mensaje}');}"
                                               reRender="dataRecetaEspecificacion"/>
                         </div>   
                </div>

               
              
            </a4j:form>
            <rich:modalPanel id="panelSeleccionarMaquinaria" width="380" autosized="true"
                                     zindex="90"
                                     headerClass="headerClassACliente"
                                     resizeable="false" >
                        <f:facet name="header">
                            <h:outputText value="<center>Seleccionar Maquinaria</center>" escape="false"/>
                        </f:facet>
                        <a4j:form id="formContenidoSeleccionMaquinaria">
                        <h:panelGroup id="contenidoSeleccionMaquinaria">
                            <center>
                                <table>
                                    <tr>
                                        <td>
                                            <div style="height:300;overflow-y: auto;overflow-x: hidden">
                                                <rich:dataTable value="#{ManagedMaquinariaRecetaEspecificacion.maquinariaList}"
                                                        var="data" id="dataMaquinarias"
                                                        onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                                        onRowMouseOver="this.style.backgroundColor='#F3F7FD';"
                                                        headerClass="headerClassACliente"
                                                        binding="#{ManagedMaquinariaRecetaEspecificacion.maquinariaDataTable}"
                                                        columnClasses="tituloCampo">
                                                        <f:facet name="header">
                                                            <rich:columnGroup>
                                                                <rich:column>
                                                                    <h:outputText value="Maquinaria" />
                                                                </rich:column>
                                                                <rich:column>
                                                                    <h:outputText value="Código"/>
                                                                </rich:column>
                                                                <rich:column>
                                                                    <h:outputText value="Area Empresa"/>
                                                                </rich:column>
                                                            </rich:columnGroup>
                                                        </f:facet>
                                                        <rich:column>
                                                            <a4j:commandLink action="#{ManagedMaquinariaRecetaEspecificacion.seleccionarMaquinariaAreaEmpresa_action}"
                                                                             oncomplete="javascript:Richfaces.hideModalPanel('panelSeleccionarMaquinaria')" reRender="form1:contenido">
                                                                <h:outputText value="#{data.nombreMaquina}"/>
                                                            </a4j:commandLink>
                                                        </rich:column>
                                                        <rich:column>
                                                            <h:outputText value="#{data.codigo}"/>
                                                        </rich:column>
                                                        <rich:column>
                                                            <h:outputText value="#{data.areasEmpresa.nombreAreaEmpresa}"/>
                                                        </rich:column>
                                            </rich:dataTable>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </center>
                                <br>
                                <div align="center">
                                    <a4j:commandButton  value="Cancelar"oncomplete="javascript:Richfaces.hideModalPanel('panelSeleccionarMaquinaria')" styleClass="btn" rendered="#{ManagedComponentesProdVersion.componentesProdProcesoOrdenManufacturaBean.formasFarmaceuticasProcesoOrdenManufactura.procesosOrdenManufactura.codProcesoOrdenManufactura>0}"/>
                                </div>
                        </h:panelGroup>
                        </a4j:form>
            </rich:modalPanel>
             <a4j:status id="statusPeticion"
                        onstart="Richfaces.showModalPanel('ajaxLoadingModalBox',{width:100, top:100})"
                        onstop="Richfaces.hideModalPanel('ajaxLoadingModalBox')">
            </a4j:status>

            <rich:modalPanel id="ajaxLoadingModalBox" minHeight="100"
                             minWidth="200" height="80" width="400" zindex="100" onshow="window.focus();">

                <div align="center">
                    <h:graphicImage value="../../img/load2.gif" />
                </div>
            </rich:modalPanel>
        </body>
    </html>

</f:view>

