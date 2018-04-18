<%@taglib prefix="h" uri="http://java.sun.com/jsf/html" %>
<%@taglib prefix="f" uri="http://java.sun.com/jsf/core" %>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j" %>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>

    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../../../css/ventas.css" />
            <script type="text/javascript" src="../../../js/general.js" ></script>
        </head>
        <body>
            <a4j:form id="form1">
                <div align="center">
                    <h:outputText value="#{ManagedProductosDesarrolloVersion.cargarLimpiezaPesaje}"/>
                    <h:panelGroup id="contenido">
                        <h:outputText styleClass="outputTextTituloSistema"   value="Limpieza de Pesaje" />
                        <rich:panel headerClass="headerClassACliente" style="width:50%">
                            <f:facet name="header">
                                <h:outputText value="Datos del Producto"/>
                            </f:facet>
                            <h:panelGrid columns="3" headerClass="headerClassACliente">
                               <h:outputText value="Producto" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value=":" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value="#{ManagedProductosDesarrolloVersion.componentesProdVersionSeleccionado.nombreProdSemiterminado} " styleClass="outputText2"/>
                               <h:outputText value="Nro Versión" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value=":" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value="#{ManagedProductosDesarrolloVersion.componentesProdVersionSeleccionado.nroVersion} " styleClass="outputText2"/>
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
                    
                        <rich:dataTable value="#{ManagedProductosDesarrolloVersion.componentesProdVersionLimpiezaSeccionList}"
                                                var="data" id="dataLimpiezaSecciones"
                                                onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                                onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                                headerClass="headerClassACliente"  style="margin-top:1em !important">
                            <f:facet name="header">
                                <rich:columnGroup>
                                    <rich:column>
                                        <h:outputText value="Sección"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Maquinaria"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Código"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Tipo Equipo"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Eliminar"/>
                                    </rich:column>
                                </rich:columnGroup>
                            </f:facet>
                            <rich:subTable value="#{data.componentesProdVersionLimpiezaMaquinariaList}" var="subData" rowKeyVar="key">
                                
                                <rich:column rendered="#{key eq 0}" rowspan="#{data.componentesProdVersionLimpiezaMaquinariaListSize}">
                                    <h:outputText value="#{data.seccionesOrdenManufactura.nombreSeccionOrdenManufactura}"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="#{subData.maquinaria.nombreMaquina}"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="#{subData.maquinaria.codigo}"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="#{subData.maquinaria.tiposEquiposMaquinaria.nombreTipoEquipo}"/>
                                </rich:column>
                                <rich:column rendered="#{key eq 0}" rowspan="#{data.componentesProdVersionLimpiezaMaquinariaListSize}">
                                    <a4j:commandButton value="Eliminar" styleClass="btn"
                                               action="#{ManagedProductosDesarrolloVersion.eliminarLimpiezaSeccionPesajeAction(data.codComponentesProdVersionLimpiezaSeccion)}"
                                               oncomplete="mostrarMensajeTransaccion()"
                                               reRender="dataLimpiezaSecciones"/>
                                </rich:column>
                            </rich:subTable>
                        </rich:dataTable>
                        </h:panelGroup>
                        <div style='margin-top:1em'>
                            <a4j:commandButton value="Agregar" styleClass="btn" oncomplete="redireccionar('agregarEditarLimpiezaSeccionPesaje.jsf?')"/>
                            <a4j:commandButton value="Volver"  styleClass="btn" oncomplete="redireccionar('../../navegadorProductosDesarrolloEnsayos.jsf');"/>
                         </div>   
                         
                </div>

               
              
            </a4j:form>
             
            <a4j:include viewId="/panelProgreso.jsp"/>
            <a4j:include viewId="/message.jsp"/>
        </body>
    </html>

</f:view>

