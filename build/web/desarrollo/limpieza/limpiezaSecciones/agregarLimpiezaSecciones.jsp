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
        <body >
            <a4j:form id="form1">
                <div align="center">
                    <h:outputText value="#{ManagedProductosDesarrolloVersion.cargarAgregarLimpiezaSeccion}"/>
                    <h:outputText styleClass="outputTextTituloSistema"   value="Agregar Limpieza de Secciones" />
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
                               <h:outputText value="Nro Versión" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value=":" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value="#{ManagedProductosDesarrolloVersion.componentesProdVersionSeleccionado.nroVersion} " styleClass="outputText2"/>
                               
                            </h:panelGrid>
                        </rich:panel>
                    
                    <rich:dataTable value="#{ManagedProductosDesarrolloVersion.componentesProdVersionLimpiezaSeccionAgregarList}"
                                            var="data" id="dataAgregarSeccionesOrdenManufactura" 
                                            onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                            onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                            headerClass="headerClassACliente"  style="margin-top:1em !important">
                        <f:facet name="header">
                            <rich:columnGroup>
                                <rich:column>
                                    <h:outputText value=""/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText escape="false" value="Secciones"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText escape="false" value="Descripción Sección"/>
                                </rich:column>
                            </rich:columnGroup>
                        </f:facet>
                               <rich:column>
                                    <h:selectBooleanCheckbox value="#{data.checked}" id="checkLimpiezaSeccion"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputLabel value="#{data.seccionesOrdenManufactura.nombreSeccionOrdenManufactura}" for="checkLimpiezaSeccion"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="#{data.seccionesOrdenManufactura.descripcionSeccionOrdenManufactura}"/>
                                </rich:column>
                        </rich:dataTable>
                        <div id="bottonesAcccion" class="barraBotones">
                            <a4j:commandButton value="Guardar" styleClass="btn" action="#{ManagedProductosDesarrolloVersion.guardarLimpiezaSeccionAction()}"
                                               onclick="if(!editarItems('form1:dataAgregarSeccionesOrdenManufactura')){return false;}"
                                               oncomplete="mostrarMensajeTransaccionEvento(function(){redireccionar('navegadorLimpiezaSecciones.jsf')})"/>
                            <a4j:commandButton value="Cancelar"  styleClass="btn" oncomplete="window.location.href='navegadorLimpiezaSecciones.jsf?dontsave='+(new Date()).getTime().toString()"/>
                         </div>   
                         
                </div>

               
              
            </a4j:form>
            <a4j:include viewId="/panelProgreso.jsp"/>
            <a4j:include viewId="/message.jsp"/>
        </body>
    </html>

</f:view>

