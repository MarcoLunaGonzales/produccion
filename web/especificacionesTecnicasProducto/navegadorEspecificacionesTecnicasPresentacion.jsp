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
                    <h:outputText value="#{ManagedEspecificacionesTecnicasProducto.cargarPresentacionesProducto}"/>
                    <h:outputText styleClass="outputText2" style="font-weight:bold;font-size:12px;"  value="Especificaciones Tecnicas Presentación" />
                    <rich:panel headerClass="headerClassACliente" style="width:50%;margin-top:12px;">
                        <f:facet name="header">
                            <h:outputText value="Buscar Presentación"/>
                        </f:facet>
                        <h:panelGrid columns="6">
                             <h:outputText value="Tipo Programa produccion" styleClass="outputText2" style="font-weight:bold;" />
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold;" />
                                <h:selectOneMenu value="#{ManagedEspecificacionesTecnicasProducto.presentacionesProductoBean.tiposProgramaProduccion.codTipoProgramaProd}" styleClass="inputText" >
                                    <f:selectItem itemValue="0" itemLabel="-TODOS-"/>
                                    <f:selectItems value="#{ManagedEspecificacionesTecnicasProducto.tiposProgramaProdSelectList}"/>
                               </h:selectOneMenu>
                               <h:outputText value="Estado" styleClass="outputText2" style="font-weight:bold;" />
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold;" />
                                <h:selectOneMenu value="#{ManagedEspecificacionesTecnicasProducto.presentacionesProductoBean.estadoReferencial.codEstadoRegistro}" styleClass="inputText" >
                                    <f:selectItem itemValue="0" itemLabel="-TODOS-"/>
                                    <f:selectItem itemValue="1" itemLabel="Activo"/>
                                    <f:selectItem itemValue="2" itemLabel="No Activo"/>
                               </h:selectOneMenu>
                        </h:panelGrid>
                        <a4j:commandButton value="BUSCAR" action="#{ManagedEspecificacionesTecnicasProducto.buscarPresentacionProducto_action}"
                        reRender="dataPresentacionesProd" styleClass="btn"/>
                    </rich:panel>
                    
                    <rich:dataTable style="margin-top:12px;" value="#{ManagedEspecificacionesTecnicasProducto.presentacionesProductoList}"
                                    var="data"
                                    id="dataPresentacionesProd"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente"
                                    binding="#{ManagedEspecificacionesTecnicasProducto.presentacionesDataTable}"
                                    >
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Presentacion Producto "  />
                            </f:facet>
                            <h:outputText  value="#{data.nombreProductoPresentacion}"  />
                        </h:column>
                         <h:column>
                            <f:facet name="header">
                                <h:outputText value="Tipo Programa Produccion "  />
                            </f:facet>
                            <h:outputText  value="#{data.tiposProgramaProduccion.nombreTipoProgramaProd}"  />
                        </h:column>
                        
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Estado Registro"  />
                            </f:facet>
                            <h:outputText value="#{data.estadoReferencial.nombreEstadoRegistro}"  />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Ficha Técnica Anpe"  />
                            </f:facet>
                            <a4j:commandLink action="#{ManagedEspecificacionesTecnicasProducto.seleccionPresentacionFichaTecnica}"
                            oncomplete=" var a=Math.random();window.location.href='registroEspecificacionPresentacionCotizacion.jsf?codTipoCotizacion=3&a='+a">
                                <h:graphicImage url="../img/organigrama3.jpg" alt="proceso de produccion" />
                            </a4j:commandLink>
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Estado Licitacion"  />
                            </f:facet>
                            <a4j:commandLink action="#{ManagedEspecificacionesTecnicasProducto.seleccionPresentacionFichaTecnica}"
                            oncomplete=" var a=Math.random();window.location.href='registroEspecificacionPresentacionCotizacion.jsf?codTipoCotizacion=2&a='+a">
                                <h:graphicImage url="../img/organigrama3.jpg" alt="proceso de produccion" />
                            </a4j:commandLink>
                        </h:column>
                        
                    </rich:dataTable>
                    <br>
                        <%--a4j:commandButton value="Registrar" styleClass="btn" action="#{ManagedEspecificacionesTecnicasProducto.agregarEspecificacionTecnica_action}" oncomplete="Richfaces.showModalPanel('panelRegistrarEspecificacionesTecnicas')" reRender="contenidoRegistrarEspecificacionesTecnicas" />
                        <a4j:commandButton value="Modificar" styleClass="btn" onclick="if(editarItem('form1:dataEspecificaciones')==false){return false;}" action="#{ManagedEspecificacionesTecnicasProducto.editarEspecificacionTecnica_action}" oncomplete="Richfaces.showModalPanel('panelEditarEspecificacionesTecnicas')" reRender="contenidoEditarEspecificacionesTecnicas"/>
                        <a4j:commandButton value="Eliminar" styleClass="btn" onclick="if(confirm('Esta seguro de eliminar la especificación?')){if(editarItem('form1:dataEspecificaciones')==false){return false;}}else{return false;}"  action="#{ManagedEspecificacionesTecnicasProducto.eliminarEspecificacionesTecnicas_action}"
                        oncomplete="if(#{ManagedEspecificacionesTecnicasProducto.mensaje eq '1'}){alert('Se elimino la especificacion')}else{alert('#{ManagedEspecificacionesTecnicasProducto.mensaje}');}" reRender="dataEspecificaciones"/--%>

                   
                </div>

               
              
            </a4j:form>

         
             <a4j:status id="statusPeticion"
                                onstart="Richfaces.showModalPanel('ajaxLoadingModalBox',{width:100, top:100})"
                                onstop="Richfaces.hideModalPanel('ajaxLoadingModalBox')">
                    </a4j:status>

                    <rich:modalPanel id="ajaxLoadingModalBox" minHeight="100"
                                     minWidth="200" height="80" width="400" zindex="500" onshow="window.focus();">

                        <div align="center">
                            <h:graphicImage value="../img/load2.gif" />
                        </div>
                    </rich:modalPanel>
        </body>
    </html>

</f:view>

