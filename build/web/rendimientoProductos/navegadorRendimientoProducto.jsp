package rendimientoProductos;

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
                    <h:outputText value="#{ManagedRendimientoProducto.cargarRendimientosProductosSemiterminados}"/>
                    <h:outputText styleClass="outputTextTitulo"  value="Rendimiento de Productos Semiterminados" />
                    <br>
                    </br>
                   

                       <rich:dataTable value="#{ManagedRendimientoProducto.componentesProdList}"
                                    var="data"
                                    id="dataRendimientoProductos"
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
                                <h:outputText value="Producto"  />
                            </f:facet>
                            <h:outputText value="#{data.nombreProdSemiterminado}" />
                        </rich:column>
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value="Area"  />
                            </f:facet>
                            <h:outputText value="#{data.areasEmpresa.nombreAreaEmpresa}" />
                        </rich:column>
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value="Rendimiento"  />
                            </f:facet>
                            <h:outputText value="#{data.rendimientoProducto}" />
                        </rich:column>
                        
                    </rich:dataTable>
                    <br>
                        <a4j:commandButton value="Cambiar" onclick="if(editarItem('form1:dataRendimientoProductos')==false){return false;}" styleClass="btn" action="#{ManagedRendimientoProducto.editarRendimientoComponenteProd_action}"
                        oncomplete="Richfaces.showModalPanel('PanelModificarRendimientoProducto')" reRender="contenidoModificarRendimientoProducto" />
                       
                        
                      

                </div>



            </a4j:form>
             <rich:modalPanel id="PanelModificarRendimientoProducto" minHeight="150"  minWidth="610"
                                     height="150" width="610"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Modificar Rendimiento de Producto"/>
                        </f:facet>
                        <a4j:form id="form4">
                            <center>
                        <h:panelGroup id="contenidoModificarRendimientoProducto">
                            
                           
                            <h:panelGrid columns="2">
                                <h:outputText value="Producto:" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="#{ManagedRendimientoProducto.componentesProdEditar.nombreProdSemiterminado}" styleClass="outputText2"/>
                                <%--h:outputText value=" " styleClass="outputText2"/--%>
                                <h:outputText value="Area:" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="#{ManagedRendimientoProducto.componentesProdEditar.areasEmpresa.nombreAreaEmpresa}" styleClass="outputText2"/>
                                <h:outputText value="Rendimiento % :" styleClass="outputText2" style="font-weight:bold"/>
                                <h:inputText value="#{ManagedRendimientoProducto.componentesProdEditar.rendimientoProducto}" styleClass="inputText"/>
                           </h:panelGrid>
                         
                                
                        </h:panelGroup>
                        <br>
                       <a4j:commandButton styleClass="btn" value="Guardar"
                       action="#{ManagedRendimientoProducto.guardarEdicionRendimientoComponenteProd_action}" oncomplete="javascript:Richfaces.hideModalPanel('PanelModificarRendimientoProducto');" reRender="dataRendimientoProductos" />
                                <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('PanelModificarRendimientoProducto')" class="btn" />
                               </center>
                        </a4j:form>
                         
            </rich:modalPanel>
            
                 
        </body>
    </html>

</f:view>

