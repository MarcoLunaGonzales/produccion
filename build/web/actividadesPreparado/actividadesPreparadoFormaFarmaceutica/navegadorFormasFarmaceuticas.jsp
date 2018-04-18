<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>


<f:view>
    
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
            <script type="text/javascript" src='../../js/general.js' ></script>
            <script type="text/javascript" src='../../js/treeComponet.js' ></script>
            <style type="text/css">
                .codcompuestoprod{
                background-color:#ADD797;
                }.nocodcompuestoprod{
                background-color:#FFFFFF;
                }
                
            </style>
            <script>
                function redireccionar(codComprod)
                {
                    var aleatorio=Math.floor(Math.random() * (5000 - 1 + 1)+ 5000);
                    window.location='navegadorProcesosComponentesProd.jsf?codCompProd='+codComprod+'&cod='+aleatorio;
                }
            </script>
        </head>
        <body>
            
            <a4j:form id="form1"  >                
                <div align="center">                    
                    <h:outputText value="Procesos Por Forma Farmaceútica" styleClass="outputTextTituloSistema"/>
                    <br>
                    <h:outputText value="#{ManagedFormasFarmaceuticasActividadesPreparado.cargarFormasFarmaceuticas}"   />
                  
                    <rich:dataTable value="#{ManagedFormasFarmaceuticasActividadesPreparado.formasFarmaceuticasList}" var="data" id="dataCadenaCliente"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#F3F7FD';" 
                                    headerClass="headerClassACliente"
                                    binding="#{ManagedFormasFarmaceuticasActividadesPreparado.formasFarmaceuticasDataTable}"
                                    columnClasses="tituloCampo">
                        <f:facet name="header">
                            <rich:columnGroup>
                                <rich:column>
                                    <h:outputText value="Nombre"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Abreviatura"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Unidad de Medidad"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Observación"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value=""/>
                                </rich:column>
                            </rich:columnGroup>
                        </f:facet>
                        <rich:column>
                            <h:outputText value="#{data.nombreForma}"  />
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.abreviaturaForma}"  />
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.unidadMedida.nombreUnidadMedida}"  />
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.obsForma}"  />
                        </rich:column>
                        <rich:column>
                            <a4j:commandLink action="#{ManagedFormasFarmaceuticasActividadesPreparado.seleccionFormasFarmaceutica_action}"
                                             oncomplete="javascript:Richfaces.showModalPanel('panelSeleccionProceso')" reRender="dataSeleccionProceso">
                                <h:graphicImage url="../../img/flujoPreparado.jpg" alt="Seleccionar Forma Farmaceutica"/>
                            </a4j:commandLink>
                        </rich:column>
            
                    </rich:dataTable>
                    <br>
                </div>
            </a4j:form>
            <rich:modalPanel id="panelSeleccionProceso" minHeight="150"  minWidth="550"
                                     height="150" width="550"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" >
                        <f:facet name="header">
                            <h:outputText value="<center>Seleccione el proceso de preparado</center>"escape="false"/>
                        </f:facet>
                        <a4j:form id="formRegistrar">
                        <div align="center">
                            <h:panelGroup id="dataSeleccionProceso">
                                <rich:dataTable value="#{ManagedFormasFarmaceuticasActividadesPreparado.procesosOrdenManufacturaList}"
                                                binding="#{ManagedFormasFarmaceuticasActividadesPreparado.procesosOrdenManufacturaDataTable}"
                                                onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                                onRowMouseOver="this.style.backgroundColor='#F3F7FD';" 
                                                headerClass="headerClassACliente" var="data">
                                    <f:facet name="header">
                                        <rich:columnGroup>
                                            <rich:column>
                                                <h:outputText value="Proceso"/>
                                            </rich:column>
                                        </rich:columnGroup>
                                    </f:facet>
                                    <rich:column>
                                        <a4j:commandLink action="#{ManagedFormasFarmaceuticasActividadesPreparado.seleccionarProcesoOrdenManufactura_action}"
                                                         oncomplete="window.location.href='navegadorProcesosFormaFar.jsf?redirect='+(new Date()).getTime().toString()">
                                            <h:outputText value="#{data.nombreProcesoOrdenManufactura}"/>
                                        </a4j:commandLink>
                                    </rich:column>
                                </rich:dataTable>
                                
                            </h:panelGroup>
                            <br>
                                
                        <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('panelSeleccionProceso')" class="btn" />
                        </div>
                        </a4j:form>
            </rich:modalPanel>
            
            
        </body>
    </html>
    
</f:view>

