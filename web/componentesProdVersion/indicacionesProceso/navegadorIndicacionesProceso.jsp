<%@taglib prefix="h" uri="http://java.sun.com/jsf/html" %>
<%@taglib prefix="f" uri="http://java.sun.com/jsf/core" %>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j" %>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>

    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
            <link rel="STYLESHEET" type="text/css" href="../../css/icons.css" />
            <script type="text/javascript" src="../../js/general.js" ></script>
            <script type="text/javascript">
                function retornarNavegador(codVersionCp)
                {
                    window.location.href=(codVersionCp>0?'../navegadorComponentesProdVersion.jsf':'../navegadorNuevosComponentesProd.jsf')+"?data="+(new Date()).getTime().toString();
                }
                function verificarProcesoOm()
                {
                    if(document.getElementById("form1:nombreProceso").innerHTML.length == 0)
                        javascript:Richfaces.showModalPanel('panelSeleccionProcesoOm');
                }
            </script>
        </head>
        <body onload="verificarProcesoOm()">
            <a4j:form id="form1">
                <div align="center">
                    <h:outputText value="#{ManagedComponentesProdVersion.cargarIndicacionProceso}"/>
                    <h:outputText styleClass="outputTextTituloSistema" value="Indicaciones por Proceso" />
                    <br/>
                    <h:panelGroup id="contenido">
                        <rich:panel headerClass="headerClassACliente" style="width:50%">
                            <f:facet name="header">
                                <h:outputText value="Datos del Producto"/>

                            </f:facet>
                            <h:panelGrid columns="3" headerClass="headerClassACliente">
                                <h:outputText value="Producto" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value=":" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value="#{ManagedComponentesProdVersion.componentesProdVersionBean.nombreProdSemiterminado} " styleClass="outputText2"/>
                               <h:outputText value="Proceso Orden Manufactura" styleClass="outputTextBold" />
                               <h:outputText value=":" styleClass="outputTextBold" />
                               <a4j:commandLink reRender="contenidoSeleccionProcesoOm" oncomplete="javascript:Richfaces.showModalPanel('panelSeleccionProcesoOm');">
                                   <h:outputText id="nombreProceso" value="#{ManagedComponentesProdVersion.componentesProdProcesoOrdenManufacturaBean.formasFarmaceuticasProcesoOrdenManufactura.procesosOrdenManufactura.nombreProcesoOrdenManufactura}" styleClass="outputText2"/>
                                   <h:graphicImage url="../../img/actualizar2.png" alt="Cambiar Proceso"/>
                                   
                               </a4j:commandLink>
                               <h:outputText value="Forma farmaceútica" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value=":" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value="#{ManagedComponentesProdVersion.componentesProdVersionBean.forma.nombreForma} " styleClass="outputText2"/>
                               <h:outputText value="Area de Fabricación" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value=":" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value="#{ManagedComponentesProdVersion.componentesProdVersionBean.areasEmpresa.nombreAreaEmpresa} " styleClass="outputText2"/>
                               <h:outputText value="Estado" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value=":" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value="#{ManagedComponentesProdVersion.componentesProdVersionBean.estadoCompProd.nombreEstadoCompProd} " styleClass="outputText2"/>
                            </h:panelGrid>
                        </rich:panel>
                    
                    <rich:dataTable value="#{ManagedComponentesProdVersion.indicacionesProcesoList}"
                                            var="data" id="dataIndicacionesProceso"
                                            onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                            onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                            headerClass="headerClassACliente"  style="margin-top:1em !important">
                            <f:facet name="header">
                                <rich:columnGroup>
                                    <rich:column>
                                        <h:outputText value="Tipos Indicación"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Indicación Proceso"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Acciones"/>
                                    </rich:column>
                                </rich:columnGroup>
                            </f:facet>
                                <rich:column>
                                    <h:outputText value="#{data.tiposIndicacionProceso.nombreTipoIndicacionProceso}"/>
                                </rich:column>
                                <rich:column>
                                    <h:inputTextarea value="#{data.indicacionProceso}" styleClass="inputText" onkeypress="return false;" style="width:45em;border:none" rows="5"/>
                                </rich:column>
                            <rich:column>
                                <rich:dropDownMenu >
                                    <f:facet name="label">
                                        <h:panelGroup>
                                            <h:outputText value="Acciones"/>
                                            <h:outputText styleClass="icon-menu3"/>
                                        </h:panelGroup>
                                    </f:facet>
                                    <rich:menuItem  submitMode="none"  value="Editar" >
                                        <a4j:support event="onclick"  
                                                     reRender="contenidoRegistrarModificarIndicacion" oncomplete="Richfaces.showModalPanel('panelRegistrarModificarIndicacion');">
                                            <f:setPropertyActionListener target="#{ManagedComponentesProdVersion.indicacionProcesoBean}" value="#{data}"/>
                                        </a4j:support>
                                    </rich:menuItem>
                                    <rich:menuSeparator />
                                    <rich:menuItem  submitMode="none"  value="Eliminar">
                                        <a4j:support event="onclick" reRender="dataIndicacionesProceso"
                                                     action="#{ManagedComponentesProdVersion.eliminarIndicacionProcesoAction(data.codIndicacionProceso)}"
                                                     oncomplete="mostrarMensajeTransaccion()" >
                                        </a4j:support>
                                    </rich:menuItem>
                                </rich:dropDownMenu>
                            </rich:column>
                        </rich:dataTable>
                    </h:panelGroup>
                        <div style='margin-top:1em'>
                            <a4j:commandButton value="Agregar" styleClass="btn" action="#{ManagedComponentesProdVersion.agregarIndicacionProceso_action}"
                                               reRender="contenidoRegistrarModificarIndicacion" oncomplete="Richfaces.showModalPanel('panelRegistrarModificarIndicacion');"/>
                            
                            
                            <a4j:commandButton value="Volver"  styleClass="btn" oncomplete="retornarNavegador(#{ManagedComponentesProdVersion.componentesProdVersionBean.codCompprod});"/>
                         </div>   
                </div>

               
              
            </a4j:form>
            <rich:modalPanel id="panelRegistrarModificarIndicacion"  minHeight="250"  minWidth="700"
                                     height="250" width="700"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="<center>Indicación de proceso</center>" escape="false"/>
                        </f:facet>
                        <a4j:form id="form2">
                        <h:panelGroup id="contenidoRegistrarModificarIndicacion">
                            <h:panelGrid columns="3">
                                <h:outputText styleClass="outputTextBold" value="Tipo Indicación"/>
                                <h:outputText styleClass="outputTextBold" value="::"/>
                                <h:panelGroup>
                                    <h:selectOneMenu value="#{ManagedComponentesProdVersion.indicacionProcesoBean.tiposIndicacionProceso.codTipoIndicacionProceso}" styleClass="inputText" rendered="#{ManagedComponentesProdVersion.indicacionProcesoBean.codIndicacionProceso eq '0'}">
                                        <f:selectItems value="#{ManagedComponentesProdVersion.tiposIndicacionProcesoSelectList}"/>
                                    </h:selectOneMenu>   
                                    <h:outputText value="#{ManagedComponentesProdVersion.indicacionProcesoBean.tiposIndicacionProceso.nombreTipoIndicacionProceso}" styleClass="outputText2"  rendered="#{ManagedComponentesProdVersion.indicacionProcesoBean.codIndicacionProceso >0}"/>
                                    <a4j:commandButton styleClass="btn" value="Asignar texto por Defecto" reRender="contenidoRegistrarModificarIndicacion" action="#{ManagedComponentesProdVersion.asignarTextoPorDefectoIndicacion_action}"/>
                                </h:panelGroup>
                                <h:outputText styleClass="outputTextBold" value="Indicación"/>
                                <h:outputText styleClass="outputTextBold" value="::"/>
                                <h:inputTextarea style="width:50em" value="#{ManagedComponentesProdVersion.indicacionProcesoBean.indicacionProceso}" styleClass="inputText" rows="5">
                                </h:inputTextarea>
                            </h:panelGrid>
                        </h:panelGroup>
                        <div align="center" style='margin-top:1em'>
                        <a4j:commandButton reRender="dataIndicacionesProceso" value="Registrar" action="#{ManagedComponentesProdVersion.guardarIndicacionProceso_action}"
                            oncomplete="mostrarMensajeTransaccionEvento(function(){Richfaces.hideModalPanel('panelRegistrarModificarIndicacion')})" styleClass="btn" />
                        <a4j:commandButton value="Cancelar"  oncomplete="Richfaces.hideModalPanel('panelRegistrarModificarIndicacion');" styleClass="btn" />
                        </div>
                        </a4j:form>
            </rich:modalPanel>
            <rich:modalPanel id="panelSeleccionProcesoOm" width="280" autosized="true"
                                     zindex="90"
                                     headerClass="headerClassACliente"
                                     resizeable="false" >
                        <f:facet name="header">
                            <h:outputText value="Seleccionar Proceso"/>
                        </f:facet>
                        <a4j:form id="formContenidoSeleccionProcesoOm">
                        <h:panelGroup id="contenidoSeleccionProcesoOm">
                            <center>
                                <table>
                                    <tr>
                                        <td>
                                            <div style="height:300;overflow-y: auto;overflow-x: hidden">
                                <rich:dataTable value="#{ManagedComponentesProdVersion.procesosOrdenManufacturaList}"
                                    var="data" id="dataProcesosProducto"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#F3F7FD';"
                                    headerClass="headerClassACliente"
                                    columnClasses="tituloCampo">
                                    <f:facet name="header">
                                        <rich:columnGroup>
                                            <rich:column>
                                                <h:outputText value="Proceso Orden  Manufactura"/>
                                            </rich:column>
                                        </rich:columnGroup>
                                    </f:facet>
                                    <rich:column>
                                        <a4j:commandLink action="#{ManagedComponentesProdVersion.seleccionarComponentesProdProcesoOrdenManufacturaIndicacion_action}"
                                                         oncomplete="Richfaces.hideModalPanel('panelSeleccionProcesoOm')" reRender="form1:contenido">
                                            <h:outputText value="#{data.nombreProcesoOrdenManufactura}"/>
                                            <f:setPropertyActionListener value="#{data}" target="#{ManagedComponentesProdVersion.componentesProdProcesoOrdenManufacturaBean.formasFarmaceuticasProcesoOrdenManufactura.procesosOrdenManufactura}"/>
                                        </a4j:commandLink>
                                    </rich:column>
                                </rich:dataTable>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </center>
                                <br>
                                <div align="center">
                                    <a4j:commandButton  value="Cancelar"oncomplete="javascript:Richfaces.hideModalPanel('panelSeleccionProcesoOm')" styleClass="btn" rendered="#{ManagedComponentesProdVersion.componentesProdProcesoOrdenManufacturaBean.formasFarmaceuticasProcesoOrdenManufactura.procesosOrdenManufactura.codProcesoOrdenManufactura>0}"/>
                                    <a4j:commandButton oncomplete="retornarNavegador(#{ManagedComponentesProdVersion.componentesProdVersionBean.codCompprod});" rendered="#{ManagedComponentesProdVersion.componentesProdProcesoOrdenManufacturaBean.formasFarmaceuticasProcesoOrdenManufactura.procesosOrdenManufactura.codProcesoOrdenManufactura eq '0'}" value="Volver" styleClass="btn"/>
                                </div>
                        </h:panelGroup>
                        </a4j:form>
            </rich:modalPanel>
            <a4j:include viewId="/panelProgreso.jsp"/>
            <a4j:include viewId="/message.jsp"/>
        </body>
    </html>

</f:view>

