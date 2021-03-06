<%@taglib prefix="h" uri="http://java.sun.com/jsf/html" %>
<%@taglib prefix="f" uri="http://java.sun.com/jsf/core" %>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j" %>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>

    <html>
        <head>
            <meta http-equiv="Expires" content="0">
            <meta http-equiv="Last-Modified" content="0">
            <meta http-equiv="Cache-Control" content="no-cache, mustrevalidate">
            <meta http-equiv="Pragma" content="no-cache">
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
            <link rel="STYLESHEET" type="text/css" href="../../css/icons.css" />
            <script type="text/javascript" src="../../js/general.js" ></script>
            <script type="text/javascript">
                function verificarProcesoOm()
                {
                    if(document.getElementById("form1:nombreProceso").innerHTML.length == 0)
                        javascript:Richfaces.showModalPanel('panelSeleccionProcesoOm');
                }
                function retornarNavegador(codVersionCp)
                {
                    window.location.href=(codVersionCp>0?'../navegadorComponentesProdVersion.jsf':'../navegadorNuevosComponentesProd.jsf')+"?data="+(new Date()).getTime().toString();
                }
            </script>
        </head>
        <body onload="verificarProcesoOm();">
            <a4j:form id="form1">
                <div align="center">
                    <h:outputText value="#{ManagedComponentesProdVersion.cargarComponentesProdVersionMaquinariaProceso}"/>
                    <h:outputText styleClass="outputTextTituloSistema"   value="Maquinarias Por Proceso" />
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
                               <a4j:commandLink oncomplete="javascript:Richfaces.showModalPanel('panelSeleccionProcesoOm');">
                                   <h:outputText id="nombreProceso" value="#{ManagedComponentesProdVersion.componentesProdProcesoOrdenManufacturaBean.formasFarmaceuticasProcesoOrdenManufactura.procesosOrdenManufactura.nombreProcesoOrdenManufactura}" styleClass="outputText2"/>
                                   <h:graphicImage url="../../img/actualizar2.png" alt="Cambiar Proceso"/>
                               </a4j:commandLink>
                               <h:outputText value="Forma farmace�tica" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value=":" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value="#{ManagedComponentesProdVersion.componentesProdVersionBean.forma.nombreForma} " styleClass="outputText2"/>
                               <h:outputText value="Area de Fabricaci�n" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value=":" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value="#{ManagedComponentesProdVersion.componentesProdVersionBean.areasEmpresa.nombreAreaEmpresa} " styleClass="outputText2"/>
                               <h:outputText value="Estado" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value=":" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value="#{ManagedComponentesProdVersion.componentesProdVersionBean.estadoCompProd.nombreEstadoCompProd} " styleClass="outputText2"/>
                            </h:panelGrid>
                        </rich:panel>
                    
                        <rich:dataTable value="#{ManagedComponentesProdVersion.componentesProdVersionMaquinariaProcesoList}"
                                                var="data" id="dataMaquinariasProcesos"
                                                onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                                onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                                headerClass="headerClassACliente"  style="margin-top:1em !important">
                            <f:facet name="header">
                                <rich:columnGroup>
                                    <rich:column styleClass="headerClassACliente" rowspan="2">
                                        <h:outputText value="Maquina"/>
                                    </rich:column>
                                    <rich:column styleClass="headerClassACliente" colspan="7">
                                        <h:outputText value="<center>Especificaciones</center>" escape="false"/>
                                    </rich:column>
                                    <rich:column rowspan="2">
                                        <h:outputText value="Acciones"/>
                                    </rich:column>
                                    <rich:column styleClass="headerClassACliente" breakBefore="true">
                                        <h:outputText value="Nombre"/>
                                    </rich:column>
                                    <rich:column styleClass="headerClassACliente">
                                        <h:outputText value="Tipo Descripci�n"/>
                                    </rich:column>
                                    <rich:column styleClass="headerClassACliente">
                                        <h:outputText value="Descripci�n"/>
                                    </rich:column>
                                    <rich:column styleClass="headerClassACliente">
                                        <h:outputText value="U.M."/>
                                    </rich:column>
                                    <rich:column styleClass="headerClassACliente">
                                        <h:outputText value="Tolerancia<br>(%)" escape="false"/>
                                    </rich:column>
                                    <rich:column styleClass="headerClassACliente">
                                        <h:outputText value="Resultado<br>Esperado<br>Lote" escape="false"/>
                                    </rich:column>
                                    <rich:column styleClass="headerClassACliente">
                                        <h:outputText value="Tipo<br>Especificaci�n" escape="false"/>
                                    </rich:column>
                                    
                                </rich:columnGroup>
                            </f:facet>
                                    
                                <rich:subTable value="#{data.especificacionesProcesosProductoMaquinariaList}" var="dataEsp" rowKeyVar="rowKeyEsp"> 
                                    <rich:column rendered="#{rowKeyEsp eq 0}" rowspan="#{data.especificacionesProcesosProductoMaquinariaListSize}">
                                        <h:outputText value="#{data.maquinaria.nombreMaquina}"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="#{dataEsp.especificacionesProcesos.nombreEspecificacionProceso}"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="#{dataEsp.tiposDescripcion.nombreTipoDescripcion}"/>
                                    </rich:column>
                                   <rich:column>
                                        <h:outputText value="#{dataEsp.valorExacto}" rendered="#{dataEsp.tiposDescripcion.codTipoDescripcion>2}" />
                                        <h:outputText value="#{dataEsp.valorTexto}" rendered="#{dataEsp.tiposDescripcion.codTipoDescripcion eq 1}" />
                                        <h:outputText value="#{dataEsp.valorMinimo}"  rendered="#{dataEsp.tiposDescripcion.codTipoDescripcion eq 2}" />
                                        <h:outputText value="-" rendered="#{dataEsp.tiposDescripcion.codTipoDescripcion eq 2}" />
                                        <h:outputText value="#{dataEsp.valorMaximo}"  rendered="#{dataEsp.tiposDescripcion.codTipoDescripcion eq 2}" />
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="#{dataEsp.especificacionesProcesos.unidadMedida.nombreUnidadMedida}"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="#{dataEsp.especificacionesProcesos.porcientoTolerancia} %"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:selectBooleanCheckbox value="#{dataEsp.resultadoEsperadoLote}" disabled="true"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="#{dataEsp.tiposEspecificacionesProcesosProductoMaquinaria.nombreTipoEspecificacionProcesoProductoMaquinaria}"/>
                                    </rich:column>
                                    <rich:column rendered="#{rowKeyEsp eq 0}"
                                                 rowspan="#{data.especificacionesProcesosProductoMaquinariaListSize}">
                                        <rich:dropDownMenu>
                                            <f:facet name="label">
                                                <h:panelGroup>
                                                    <h:outputText value="Acciones"/>
                                                    <h:outputText styleClass="icon-menu3"/>
                                                </h:panelGroup>
                                            </f:facet>
                                            <rich:menuItem  submitMode="none" value="Editar">
                                                <a4j:support event="onclick" oncomplete="redireccionar('editarMaquinariaProcesoEspecificaciones.jsf')">
                                                    <f:setPropertyActionListener value="#{data}" target="#{ManagedComponentesProdVersion.componentesProdVersionMaquinariaProcesoEditar}"/>
                                                </a4j:support>
                                            </rich:menuItem>
                                            <rich:menuItem  submitMode="none" value="Eliminar">
                                                <a4j:support event="onclick" reRender="dataMaquinariasProcesos" oncomplete="mostrarMensajeTransaccion();"
                                                             action="#{ManagedComponentesProdVersion.eliminarComponentesProdVersionMaquinariaProcesoAction(data.codCompprodVesionMaquinariaProceso)}"
                                                             >
                                                </a4j:support>
                                            </rich:menuItem>
                                            
                                            
                                        </rich:dropDownMenu>
                                    </rich:column>
                                    <rich:column breakBefore="true" colspan="9" style="background-color:#cccccc" rendered="#{rowKeyEsp+1 eq data.especificacionesProcesosProductoMaquinariaListSize}">
                                        <h:outputText value="_" style="font-size:2px;"/>
                                    </rich:column>
                                </rich:subTable>
                            </rich:dataTable>
                        </h:panelGroup>
                        <div style='margin-top:1em'>
                            <a4j:commandButton value="Agregar" styleClass="btn" oncomplete="window.location.href='agregarMaquinariaProcesoEspecificaciones.jsf?dataA='+(new Date()).getTime().toString();"/>
                            <a4j:commandButton value="Volver"  styleClass="btn" oncomplete="retornarNavegador(#{ManagedComponentesProdVersion.componentesProdVersionBean.codCompprod});"/>
                        </div>   
                         
                </div>

               
              
            </a4j:form>
            <rich:modalPanel id="panelSeleccionProcesoOm" autosized="true"
                                     zindex="90"
                                     headerClass="headerClassACliente"
                                     resizeable="false" >
                        <f:facet name="header">
                            <h:outputText value="Seleccionar Proceso de Preparado"/>
                        </f:facet>
                        <a4j:form id="formContenidoRecalcular">
                        <h:panelGroup id="contenidoSeleccionProcesoOm">
                            <center>
                                <rich:dataTable value="#{ManagedComponentesProdVersion.componentesProdProcesoOrdenManufacturaSeleccionList}"
                                    var="data" id="dataProcesosProducto"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#F3F7FD';"
                                    headerClass="headerClassACliente"
                                    binding="#{ManagedComponentesProdVersion.componentesProdProcesoDataTable}"
                                    columnClasses="tituloCampo">
                                    <f:facet name="header">
                                        <rich:columnGroup>
                                            <rich:column>
                                                <h:outputText value="Orden"/>
                                            </rich:column>
                                            <rich:column>
                                                <h:outputText value="Proceso Orden  Manufactura"/>
                                            </rich:column>
                                        </rich:columnGroup>
                                    </f:facet>
                                    <rich:column>
                                        <h:outputText value="#{data.orden}"/>
                                    </rich:column>
                                    <rich:column>
                                        <a4j:commandLink action="#{ManagedComponentesProdVersion.seleccionarComponentesProdProcesoOrdenManufactura}"
                                                         oncomplete="javascript:Richfaces.hideModalPanel('panelSeleccionProcesoOm')" reRender="form1:contenido">
                                            <h:outputText value="#{data.formasFarmaceuticasProcesoOrdenManufactura.procesosOrdenManufactura.nombreProcesoOrdenManufactura}"/>
                                        </a4j:commandLink>
                                    </rich:column>
                                </rich:dataTable>
                            </center>
                                <br>
                                <div align="center">
                                    <a4j:commandButton  value="Cancelar"oncomplete="javascript:Richfaces.hideModalPanel('panelSeleccionProcesoOm')" styleClass="btn" rendered="#{ManagedProcesosPreparadoProducto.procesosOrdenManufacturaBean.codProcesoOrdenManufactura>0}"/>
                                    <a4j:commandButton oncomplete="retornarNavegador(#{ManagedComponentesProdVersion.componentesProdVersionBean.codCompprod});" styleClass="btn"  value="Volver" rendered="#{ManagedProcesosPreparadoProducto.procesosOrdenManufacturaBean.codProcesoOrdenManufactura eq 0}"/>
                                </div>
                        </h:panelGroup>
                        </a4j:form>
            </rich:modalPanel>
             
        <a4j:include viewId="/panelProgreso.jsp"/>
        <a4j:include viewId="/message.jsp"/>
        </body>
    </html>

</f:view>

