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
            <link rel="STYLESHEET" type="text/css" href="../../../css/ventas.css" />
            <script type="text/javascript" src="../../../js/general.js" ></script>
        </head>
        <body >
            <a4j:form id="form1">
                <div align="center">
                    <h:outputText value="#{ManagedProductosDesarrolloVersion.cargarAgregarLimpiezaPesaje}"/>
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
                               <h:outputText value="Sección de Limpieza" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value=":" styleClass="outputText2" style="font-weight:bold"/>
                               <h:selectOneMenu value="#{ManagedProductosDesarrolloVersion.componentesProdVersionLimpiezaPesaje.seccionesOrdenManufactura.codSeccionOrdenManufactura}" styleClass="inputText">
                                   <f:selectItems value="#{ManagedProductosDesarrolloVersion.seccionesOrdenManufacturaSelectList}"/>
                               </h:selectOneMenu>
                            </h:panelGrid>
                        </rich:panel>
                    
                    <rich:dataTable value="#{ManagedProductosDesarrolloVersion.componentesProdVersionLimpiezaPesaje.componentesProdVersionLimpiezaMaquinariaList}"
                                            var="data" id="dataAgregarSeccionesOrdenManufactura" 
                                            headerClass="headerClassACliente"  style="margin-top:1em !important;width:80%">
                        <f:facet name="header">
                            <rich:columnGroup>
                                <rich:column>
                                    <h:outputText value=""/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Maquinaria<br><input type='text' onkeyup='buscarCeldaAgregar(this,1)' class='inputText'>" escape="false"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText escape="false" value="Código"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText escape="false" value="Tipo<Br>Equipo"/>
                                </rich:column>
                                <rich:column style="width:50%">
                                    <h:outputText escape="false" value="Descripción"/>
                                </rich:column>
                            </rich:columnGroup>
                        </f:facet>
                               <rich:column>
                                   <h:selectBooleanCheckbox value="#{data.checked}" onclick="seleccionarRegistro(this)"/>
                                </rich:column>
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
                                    <h:outputText value="#{data.maquinaria.obsMaquina}"/>
                                </rich:column>
                        </rich:dataTable>
                        <div id="bottonesAcccion" class="barraBotones">
                            <a4j:commandButton value="Guardar" styleClass="btn" action="#{ManagedProductosDesarrolloVersion.guardarLimpiezaPesajeAction()}"
                                               onclick="if(!editarItems('form1:dataAgregarSeccionesOrdenManufactura')){return false;}"
                                               oncomplete="mostrarMensajeTransaccionEvento(function(){redireccionar('navegadorLimpiezaPesaje.jsf?')})"/>
                            <a4j:commandButton value="Cancelar"  styleClass="btn" oncomplete="redireccionar('navegadorLimpiezaPesaje.jsf')"/>
                         </div>   
                         
                </div>

               
              
            </a4j:form>

             
            <a4j:include viewId="/panelProgreso.jsp"/>
            <a4j:include viewId="/message.jsp"/>
        </body>
    </html>

</f:view>

