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
            </script>
        </head>
        <body >
            <a4j:form id="form1">
                <div align="center">
                    <h:outputText value="#{ManagedProductosDesarrolloVersion.cargarComponentesProdVersionEspecificacionesProceso}"/>
                    <h:outputText styleClass="outputText2" style="font-size:13;font-weight:bold"  value="Maquinarias Por Proceso" />
                    <br/>
                        <rich:panel headerClass="headerClassACliente" style="width:50%">
                            <f:facet name="header">
                                <h:outputText value="Datos del Producto"/>

                            </f:facet>
                            <h:panelGrid columns="3" headerClass="headerClassACliente">
                                <h:outputText value="Producto" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value=":" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value="#{ManagedProductosDesarrolloVersion.componentesProdVersionSeleccionado.nombreProdSemiterminado} " styleClass="outputText2"/>
                               <h:outputText value="Forma farmaceútica" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value=":" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value="#{ManagedProductosDesarrolloVersion.componentesProdVersionSeleccionado.forma.nombreForma} " styleClass="outputText2"/>
                               <h:outputText value="Area de Fabricación" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value=":" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value="#{ManagedProductosDesarrolloVersion.componentesProdVersionSeleccionado.areasEmpresa.nombreAreaEmpresa} " styleClass="outputText2"/>
                               <h:outputText value="Estado" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value=":" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value="#{ManagedProductosDesarrolloVersion.componentesProdVersionSeleccionado.estadoCompProd.nombreEstadoCompProd} " styleClass="outputText2"/>
                            </h:panelGrid>
                        </rich:panel>
                    
                    <rich:dataTable value="#{ManagedProductosDesarrolloVersion.componentesProdVersionEspecificacionProcesoList}"
                                            var="data" id="dataEspecificacionesProcesos"
                                            onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                            onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                            headerClass="headerClassACliente"  style="margin-top:1em !important">
                            <f:facet name="header">
                                <rich:columnGroup>
                                    <rich:column styleClass="headerClassACliente" colspan="8" >
                                        <h:outputText value="<center>Especificaciones</center>" escape="false"/>
                                    </rich:column>
                                    <rich:column styleClass="headerClassACliente"  breakBefore="true">
                                        <h:outputText value="Proceso"/>
                                    </rich:column>
                                    <rich:column styleClass="headerClassACliente"  >
                                        <h:outputText value="Nombre"/>
                                    </rich:column>
                                    <rich:column styleClass="headerClassACliente"  >
                                        <h:outputText value="Tipo Descripción"/>
                                    </rich:column>
                                    <rich:column styleClass="headerClassACliente"  >
                                        <h:outputText value="Descripción"/>
                                    </rich:column>
                                    <rich:column styleClass="headerClassACliente"  >
                                        <h:outputText value="U.M."/>
                                    </rich:column>
                                    <rich:column styleClass="headerClassACliente"  >
                                        <h:outputText value="Tolerancia"/>
                                    </rich:column>
                                    <rich:column styleClass="headerClassACliente"  >
                                        <h:outputText value="Acciones"/>
                                    </rich:column>
                                </rich:columnGroup>
                            </f:facet>
                        <rich:subTable value="#{data.componentesProdVersionEspecificacionProcesoList}" var="subData" rowKeyVar="rowKey">
                                <rich:column rowspan="#{data.componentesProdVersionEspecificacionProcesoListSize}" rendered="#{rowKey eq 0}" >
                                    <h:outputText value="#{data.nombreProcesoOrdenManufactura}" escape="false"/>
                                </rich:column>

                                <rich:column>
                                    <h:outputText value="#{subData.especificacionesProcesos.nombreEspecificacionProceso}"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="#{subData.tiposDescripcion.nombreTipoDescripcion}"/>
                                </rich:column>
                               <rich:column>
                                    <h:outputText value="#{subData.valorExacto}" rendered="#{subData.tiposDescripcion.codTipoDescripcion>2}" />
                                    <h:outputText value="#{subData.valorTexto}" rendered="#{subData.tiposDescripcion.codTipoDescripcion eq 1}" />
                                    <h:outputText value="#{subData.valorMinimo}"  rendered="#{subData.tiposDescripcion.codTipoDescripcion eq 2}" />
                                    <h:outputText value="-" rendered="#{subData.tiposDescripcion.codTipoDescripcion eq 2}" />
                                    <h:outputText value="#{subData.valorMaximo}"  rendered="#{subData.tiposDescripcion.codTipoDescripcion eq 2}" />
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="#{subData.especificacionesProcesos.unidadMedida.nombreUnidadMedida}"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="#{subData.especificacionesProcesos.porcientoTolerancia} %"/>
                                </rich:column>

                                <rich:column rowspan="#{data.componentesProdVersionEspecificacionProcesoListSize}" rendered="#{rowKey eq 0}">
                                     <rich:dropDownMenu >
                                        <f:facet name="label">
                                            <h:panelGroup>
                                                <h:outputText value="Acciones"/>
                                                <h:outputText styleClass="icon-menu3"/>
                                            </h:panelGroup>
                                        </f:facet>
                                        <rich:menuItem  submitMode="none" iconClass="icon-pencil2" value="Editar" >
                                            <a4j:support event="onclick" oncomplete="redireccionar('agregarModificarEspecificacionesProcesos.jsf')" >
                                                <f:setPropertyActionListener target="#{ManagedProductosDesarrolloVersion.componentesProdVersionEspecificacionProceso.procesosOrdenManufactura}"
                                                                             value="#{data}"/>
                                            </a4j:support>
                                        </rich:menuItem>
                                        <rich:menuItem  submitMode="none" iconClass="icon-cross" value="Eliminar" >
                                            <a4j:support event="onclick" reRender="dataEspecificacionesProcesos"
                                                         oncomplete="mostrarMensajeTransaccion()"
                                                         action="#{ManagedProductosDesarrolloVersion.eliminarComponentesProdVersionEspecificacionProcesoAction(data.codProcesoOrdenManufactura)}" >
                                            </a4j:support>
                                        </rich:menuItem>
                                    </rich:dropDownMenu>
                                </rich:column>
                                <rich:column breakBefore="true" colspan="8" style="background-color:#cccccc" rendered="#{rowKey+1 eq data.componentesProdVersionEspecificacionProcesoListSize}">
                                    <h:outputText value="_" style="font-size:2px;"/>
                                </rich:column>
                            </rich:subTable>
                        </rich:dataTable>
                        <div style='margin-top:1em'>
                            <a4j:commandButton value="Agregar" styleClass="btn" action="#{ManagedProductosDesarrolloVersion.agregarComponentesProdVersionEspecificacionesProcesoAction()}"
                                               oncomplete="window.location.href='agregarModificarEspecificacionesProcesos.jsf?dataA='+(new Date()).getTime().toString();"/>
                            <a4j:commandButton value="Volver"  styleClass="btn" oncomplete="redireccionar('../navegadorProductosDesarrolloEnsayos.jsf')"/>
                         </div>   
                         
                </div>

               
              
            </a4j:form>

            <a4j:include viewId="/panelProgreso.jsp"/>
            <a4j:include viewId="/message.jsp"/>
        </body>
    </html>

</f:view>

