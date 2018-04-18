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
            <script type="text/javascript" src='../js/general.js' ></script>
            <script type="text/javascript" src='../js/treeComponet.js' ></script> 
            <style type="text/css">
                .codcompuestoprod{
                background-color:#ADD797;
                }.nocodcompuestoprod{
                background-color:#FFFFFF;
                }
                
            </style>
        </head>
        <body>
            
            <h:form id="form1"  >                
                <div align="center">                    
                    
                    <h:outputText value="#{ManagedComponentesProducto.cargarFormatoMaquinarias}"   />
                    <h3>formato de Maquinaria de Producto Semiterminado</h3>
                    Formato:
                    <h:selectOneMenu value="#{ManagedComponentesProducto.codTipoCompProdFormato}" id="codTipoCompProdFormato">
                        <f:selectItems value="#{ManagedComponentesProducto.tiposComponentesProdFormatoList}" />
                        <a4j:support action="#{ManagedComponentesProducto.tiposCompProdFormato_change}" reRender="dataCompProd" event ="onchange" />
                    </h:selectOneMenu>
                    <br/>Area Empresa:
                    <h:selectOneMenu value="#{ManagedComponentesProducto.codAreaEmpresa}" id="codAreaEmpresa">
                        <f:selectItems value="#{ManagedComponentesProducto.areasEmpresaList}" />
                        <a4j:support action="#{ManagedComponentesProducto.tiposCompProdFormato_change}" reRender="dataCompProd" event ="onchange" />
                    </h:selectOneMenu>
                    <br/><br/>

                    <rich:dataTable value="#{ManagedComponentesProducto.componentesProdFormatosList}"
                                    var="data" id="dataCompProd"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#F3F7FD';" 
                                    headerClass="headerClassACliente"
                                    columnClasses="tituloCampo"
                                    >
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value=""  />
                                
                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.checked}"  />
                        </rich:column >
                       
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value="Nombre Producto Semiterminado"  />
                            </f:facet>
                            <h:outputText value="#{data.actividadesFormulaMaestra.formulaMaestra.componentesProd.nombreProdSemiterminado}"  />
                        </rich:column >
                        
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value="Actividad"  />
                            </f:facet>
                            <h:outputText value="#{data.actividadesFormulaMaestra.actividadesProduccion.nombreActividad}"  />
                        </rich:column >
                        
                        
                          <rich:column >
                            <f:facet name="header">
                                <h:outputText value="Maquinaria"  />
                            </f:facet>
                            <h:outputText value="#{data.maquinaria.nombreMaquina}"/>
                        </rich:column >
                        
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value="Horas Hombre"  />
                            </f:facet>
                            <h:outputText value="#{data.horasHombre}"  />
                        </rich:column >
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value="Horas Maquina"  />
                            </f:facet>
                            <h:outputText value="#{data.horasMaquina}"  />
                        </rich:column >
                        
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value="Formato Maquina"  />
                            </f:facet>
                            <h:outputText value="#{data.formatoMaquina}"  >
                            </h:outputText>
                        </rich:column >
                    </rich:dataTable>
                    <br>
                        <a4j:commandButton  onclick="Richfaces.showModalPanel('PanelTipoCompProdFormato')" styleClass="btn"  value="Cambio Producto Formato"/>
                    
                </div>
                
               
            </h:form>


<rich:modalPanel id="PanelTipoCompProdFormato" minHeight="120"  minWidth="300"
                                     height="120" width="300"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Formato de Tableteado"/>
                        </f:facet>
                        <a4j:form id="formRegistrar">
                        <h:panelGroup id="contenidoTipoCompProdFormato">
                            <h:panelGrid columns="2">
                                <h:outputText value="Formato" />
                                <h:selectOneMenu value="#{ManagedComponentesProducto.codTipoCompProdFormato}">
                                    <f:selectItems value="#{ManagedComponentesProducto.tiposComponentesProdFormatoList}" />
                                </h:selectOneMenu>
                            </h:panelGrid>
                        </h:panelGroup>
                            <div align="center">
                                <a4j:commandButton action="#{ManagedComponentesProducto.actualizarFormatoMaquinaria_action}"
                                value="Guardar" styleClass="btn"
                                reRender="dataCompProd,codTipoCompProdFormato" oncomplete="Richfaces.hideModalPanel('PanelTipoCompProdFormato')" />
                                <a4j:commandButton value="Cancelar" styleClass="btn"
                                onclick="Richfaces.hideModalPanel('PanelTipoCompProdFormato')" />

                            </div>
                        </a4j:form>
      </rich:modalPanel>
            
            
        </body>
    </html>
    
</f:view>

