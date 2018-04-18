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
        </head>
        <body>
            
            <h:form id="form1"  >                
                <div align="center">                    
                    
                    <h:outputText value="#{ManagedEspecificacionesControlCalidad.cargarComponenteProducto}"   />
                    <h3>Información de Producto Semiterminado</h3>   
                   
                    <div align="center">
                        <rich:panel headerClass="headerClassACliente" style="width:60%">
                            <f:facet name="header">
                                <h:outputText style="font-weight:bold" value="BUSCADOR"/>
                            </f:facet>
                            <h:panelGrid columns="6">
                                        <h:outputText value="Nombre Comercial" styleClass="outputText2" style="font-weight:bold" />
                                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold" />
                                        <h:selectOneMenu styleClass="inputText" value="#{ManagedEspecificacionesControlCalidad.componentesProdbean.producto.codProducto}" id="producto"   ><%--onchange="submit();" valueChangeListener="#{ManagedEspecificacionesControlCalidad.filtrarProductos}"--%>
                                            <f:selectItems value="#{ManagedEspecificacionesControlCalidad.productosList}"  />
                                        </h:selectOneMenu>

                                        <h:outputText value="Estado" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:selectOneMenu styleClass="inputText" value="#{ManagedEspecificacionesControlCalidad.componentesProdbean.estadoCompProd.codEstadoCompProd}" id="estados_compprod"  ><%--onchange="submit();" valueChangeListener="#{ManagedEspecificacionesControlCalidad.filtrarEstadosCompProd}"  --%>
                                            <f:selectItems value="#{ManagedEspecificacionesControlCalidad.estadosCompProdList}"  />
                                        </h:selectOneMenu>
                                        <h:outputText value="Tipo Produccion" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:selectOneMenu styleClass="inputText" value="#{ManagedEspecificacionesControlCalidad.componentesProdbean.tipoProduccion.codTipoProduccion}" id="codtipoProd"  ><%--onchange="submit();" valueChangeListener="#{ManagedEspecificacionesControlCalidad.filtrarEstadosCompProd}"  --%>
                                        <f:selectItems value="#{ManagedEspecificacionesControlCalidad.tiposProduccionSelectList}"  />
                                        </h:selectOneMenu>
                                </h:panelGrid>
                                <a4j:commandButton value="Buscar" action="#{ManagedEspecificacionesControlCalidad.buscarComponenteProd_action}" styleClass="btn" reRender="dataCadenaCliente"/>
                       </rich:panel>
                        <h:panelGrid columns="3"   cellpadding="0"  cellspacing="2" >
                            <h:outputText value="Producto Compuesto"  styleClass="outputText2" style="font-weight:bold"   />
                            <h:outputText value=""  styleClass="codcompuestoprod"  style="width:100px;border:1px solid #000000;" />
                        </h:panelGrid>
                    <rich:dataTable value="#{ManagedEspecificacionesControlCalidad.componentesProductoList}" var="data" id="dataCadenaCliente"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#F3F7FD';" 
                                    headerClass="headerClassACliente"
                                    columnClasses="tituloCampo"
                                    binding = "#{ManagedEspecificacionesControlCalidad.componentesProdDataTable}">
                        
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Nombre Producto Semiterminado" style="font-weight:bold" />
                            </f:facet>
                            <h:outputText value="#{data.nombreProdSemiterminado}"  />
                        </rich:column >  
                        
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Forma Farmacéutica" style="font-weight:bold" />
                            </f:facet>
                            <h:outputText value="#{data.forma.nombreForma}"  />
                        </rich:column >
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Concentración" style="font-weight:bold" />
                            </f:facet>
                            <h:outputText value="#{data.concentracionEnvasePrimario}"  />
                        </rich:column >
                        
                        <%--rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Volúmen/Concentración "  />
                            </f:facet>
                            <h:outputText value="#{data.volumenPesoEnvasePrim}"  />
                        </rich:column >
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Color Presentación Primaria"  />
                            </f:facet>
                            <h:outputText value="#{data.coloresPresentacion.nombreColor}"  />
                        </rich:column >
                        
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Sabor"  />
                            </f:facet>
                            <h:outputText value="#{data.saboresProductos.nombreSabor}"  />
                        </rich:column --%>
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Área de Fabricación" style="font-weight:bold" />
                            </f:facet>
                            <h:outputText value="#{data.areasEmpresa.nombreAreaEmpresa}"  />
                        </rich:column >
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Nombre Generico" style="font-weight:bold" />
                            </f:facet>
                            <h:outputText value="#{data.nombreGenerico}"  />
                        </rich:column >
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Tipo Produccion"  style="font-weight:bold"/>
                            </f:facet>
                            <h:outputText value="#{data.tipoProduccion.nombreTipoProduccion}"  />
                        </rich:column >
                        <%--rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Reg. Sanitario"  />
                            </f:facet>
                            <h:outputText value="#{data.regSanitario}"  />
                        </rich:column >
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Fecha Emisión R.S."  />
                            </f:facet>
                            <h:outputText value="#{data.fechaVencimientoRS}"  >
                                
                            </h:outputText>
                        </rich:column >
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Vida Util"  />
                            </f:facet>
                            <h:outputText value="#{data.vidaUtil}"  />
                        </rich:column --%>
                        
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Estado"  style="font-weight:bold"/>
                            </f:facet>
                            <h:outputText value="#{data.estadoCompProd.nombreEstadoCompProd}"  />
                        </rich:column >
                        <rich:column rendered="#{ManagedAccesoSistema.usuarioModuloBean.codUsuarioGlobal eq '303'}" styleClass="#{data.columnStyle}" >
                            <f:facet name="header">
                                <h:outputText value="Analisis Fisico"  style="font-weight:bold"/>
                            </f:facet>
                            <h:commandLink styleClass="outputText2" action="#{ManagedEspecificacionesControlCalidad.agregarAnalisisFisico_action}"
                             >
                                 <h:graphicImage url="../../img/fisico.jpg" title="analisis físico"/>
                                 </h:commandLink>

                        </rich:column>

                          <rich:column rendered="#{ManagedAccesoSistema.usuarioModuloBean.codUsuarioGlobal eq '303'}" styleClass="#{data.columnStyle}" >
                            <f:facet name="header">
                                <h:outputText value="Analisis Químico" style="font-weight:bold"/>
                            </f:facet>
                            <center>
                            <h:commandLink styleClass="outputText2" action="#{ManagedEspecificacionesControlCalidad.agregarAnalisisQuimico_Action}"
                            >
                                <h:graphicImage url="../../img/preparado.jpg" title="analisis químico"/>
                            </h:commandLink>
                            </center>

                        </rich:column>
                         <rich:column rendered="#{ManagedAccesoSistema.usuarioModuloBean.codUsuarioGlobal eq '303'}" styleClass="#{data.columnStyle}" >
                            <f:facet name="header">
                                <h:outputText value="Analisis Microbiologico"  style="font-weight:bold"/>
                            </f:facet>
                          <center>  <h:commandLink styleClass="outputText2" action="#{ManagedEspecificacionesControlCalidad.agregarAnalisisMicrobiologia_Action}"
                             >
                                 <h:graphicImage url="../../img/micro.jpg" title="analisis microbiologico"/>
                                 </h:commandLink>
                                 </center>

                        </rich:column>
                        <rich:column rendered="#{ManagedAccesoSistema.usuarioModuloBean.codUsuarioGlobal eq '1195'}" styleClass="#{data.columnStyle}" >
                            <f:facet name="header">
                                <h:outputText value="Concentración"  style="font-weight:bold"/>
                            </f:facet>
                            <h:commandLink styleClass="outputText2" action="#{ManagedEspecificacionesControlCalidad.agregarConcentracion_Action}"
                             >
                                 <h:graphicImage url="../../img/detalle.jpg" title="concentracion Producto"/>
                                 </h:commandLink>

                        </rich:column>
                        
                    </rich:dataTable>
                    <br>
                    
                    
                </div>
                
               
            </h:form>
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
            
        </body>
    </html>
    
</f:view>

