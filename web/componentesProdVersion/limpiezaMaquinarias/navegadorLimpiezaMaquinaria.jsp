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
        <body >
            <a4j:form id="form1">
                <div align="center">
                    <h:outputText value="#{ManagedComponentesProdVersion.cargarComponentesProdVersionLimpiezaMaquinaria}"/>
                    <h:outputText styleClass="outputTextTituloSistema"   value="Maquinarias para Limpieza" />
                    <h:panelGroup id="contenido">
                        <rich:panel headerClass="headerClassACliente" style="width:50%">
                            <f:facet name="header">
                                <h:outputText value="Datos del Producto"/>

                            </f:facet>
                            <h:panelGrid columns="3" headerClass="headerClassACliente">
                               <h:outputText value="Producto" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value=":" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value="#{ManagedComponentesProdVersion.componentesProdVersionBean.nombreProdSemiterminado} " styleClass="outputText2"/>
                               <h:outputText value="Nro Versión" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value=":" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value="#{ManagedComponentesProdVersion.componentesProdVersionBean.nroVersion} " styleClass="outputText2"/>
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
                    
                        <rich:dataTable value="#{ManagedComponentesProdVersion.componentesProdVersionLimpiezaMaquinariaList}"
                                                var="data" id="dataMaquinariasLimpieza"
                                                onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                                onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                                headerClass="headerClassACliente"  style="margin-top:1em !important">
                            <f:facet name="header">
                                <rich:columnGroup>
                                    <rich:column>
                                        <h:outputText escape="false" value="Maquinaria"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Codigo" escape="false"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Tipo Equipo" escape="false"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Eliminar"/>
                                    </rich:column>
                                </rich:columnGroup>
                            </f:facet>
                                <rich:column>
                                    <h:outputText value="#{data.maquinaria.nombreMaquina}"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="#{data.maquinaria.codigo}"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="#{data.maquinaria.tiposEquiposMaquinaria.nombreTipoEquipo}"/>
                                </rich:column>
                                <rich:column>
                                    <a4j:commandButton value="Eliminar" styleClass="btn" 
                                               action="#{ManagedComponentesProdVersion.eliminarComponentesProdVersionLimpiezaMaquinariaAction(data.codComponentesProdVersionLimpiezaMaquinaria)}"
                                               oncomplete="mostrarMensajeTransaccion()"
                                               reRender="dataMaquinariasLimpieza"/>
                            
                                </rich:column>
                        </rich:dataTable>
                        </h:panelGroup>
                        <div style='margin-top:1em'>
                            <a4j:commandButton value="Agregar" styleClass="btn" oncomplete="window.location.href='agregarLimpiezaMaquinaria.jsf?dataA='+(new Date()).getTime().toString();"/>
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
                                    <a4j:commandButton oncomplete="retornarNavegadorFm(#{ManagedProcesosPreparadoProducto.componentesProdVersionBean.codCompprod})" styleClass="btn"  value="Volver" rendered="#{ManagedProcesosPreparadoProducto.procesosOrdenManufacturaBean.codProcesoOrdenManufactura eq 0}"/>
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
            <a4j:include viewId="/message.jsp"/>
        </body>
    </html>

</f:view>

