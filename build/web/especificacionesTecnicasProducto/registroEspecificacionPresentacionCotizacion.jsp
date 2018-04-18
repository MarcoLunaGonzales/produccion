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
            <style>
                .headerLocal{
                    background-image:none;
                    background-color:#9d5f9f;
                    font-weight:bold;
                    width:50%;
                    color:white;
                    font-size:12px;
                }
                textarea
                {
                    width:100%;
                }
            </style>
        </head>
        <body >
            <a4j:form id="form1">
                <div align="center">
                    <h:outputText value="#{ManagedEspecificacionesTecnicasProducto.cargarEspecificacionesTecnicasPresentacion}"/>
                    <h:outputText styleClass="outputText2" style="font-size:14px;font-weight:bold"  value="Registro Especificaciones Tecnicas por Presentacion-Cotizacion" />
                    <rich:panel headerClass="headerClassACliente" style="width:50%;margin-top:12px;">
                        <f:facet name="header">
                            <h:outputText value="Datos de Presentacion-Cotizacion"/>
                        </f:facet>
                        <h:panelGrid columns="3">
                                <h:outputText value="Presentacion" styleClass="outputText2" style="font-weight:bold;" />
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold;" />
                                <h:outputText value="#{ManagedEspecificacionesTecnicasProducto.presentacionesProductoRegistrarFicha.nombreProductoPresentacion}" styleClass="outputText2" />
                                <h:outputText value="Tipo Cotizacion" styleClass="outputText2" style="font-weight:bold;" />
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold;" />
                                <h:outputText value="ANPE" styleClass="outputText2" rendered="#{ManagedEspecificacionesTecnicasProducto.codTipoCotizacion eq '3'}" />
                                <h:outputText value="Licitacion" styleClass="outputText2" rendered="#{ManagedEspecificacionesTecnicasProducto.codTipoCotizacion eq '2'}" />

                           
                        </h:panelGrid>
                    </rich:panel>
                    
                    <rich:dataTable style="margin-top:12px;width:95%" value="#{ManagedEspecificacionesTecnicasProducto.especificacionesTecnicasPresentacionList}"
                                    var="data"
                                    id="dataEspecificaciones"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente headerLocal" >
                        <f:facet name="header">
                             <rich:columnGroup>
                                 <rich:column  style="">
                                     <h:outputText style="font-weight:bold" value="A llenar por la entidad Convocante"  />
                                 </rich:column>
                                 <rich:column >
                                     <h:outputText style="font-weight:bold" value="Para ser llenado por el proponente al momento de elaborar su propuesta"  />
                                 </rich:column>
                                 <rich:column breakBefore="true">
                                     <h:outputText style="font-weight:bold" value="Caracteritica Solicitada"  />
                                 </rich:column>
                                 <rich:column >
                                     <h:outputText  style="font-weight:bold"value="Caracteristica propuesta"  />
                                 </rich:column>
                             </rich:columnGroup>
                             </f:facet>
                             <rich:column  styleClass="headerLocal"  >
                                 <h:outputText value="#{data.nombreTipoEspecificacionTecnica}"/>
                             </rich:column>
                             <rich:column  styleClass="headerLocal"  >
                                 <h:outputText value=""/>
                             </rich:column>
                             <rich:subTable var="subData" value="#{data.especificacionesTecnicasPresentacionesList}" rowKeyVar="rowkey">
                                     <rich:column >
                                         <h:outputText value="#{subData.especificacionesTecnicas.nombreEspecificacionTecnica}"/>
                                     </rich:column>
                                     <rich:column >
                                         <h:inputTextarea rows="3" value="#{subData.detalleEspecificacionTecnica}" styleClass="inputText"/>
                                     </rich:column>
                                   
                             </rich:subTable>

                        
                        
                    </rich:dataTable>
                    <br>
                        <a4j:commandButton value="Guardar" styleClass="btn" action="#{ManagedEspecificacionesTecnicasProducto.guardarEspecificacionesTecnicasPresentaciones_action}"
                        oncomplete="if(#{ManagedEspecificacionesTecnicasProducto.mensaje eq '1'}){alert('Se registraron las especificaciones');window.location.href='navegadorEspecificacionesTecnicasPresentacion.jsf';}
                        else{alert('#{ManagedEspecificacionesTecnicasProducto.mensaje}');}" />
                        <%--a4j:commandButton value="Modificar" styleClass="btn" onclick="if(editarItem('form1:dataEspecificaciones')==false){return false;}" action="#{ManagedEspecificacionesTecnicasProducto.editarEspecificacionTecnica_action}" oncomplete="Richfaces.showModalPanel('panelEditarEspecificacionesTecnicas')" reRender="contenidoEditarEspecificacionesTecnicas"/--%>
                        <a4j:commandButton value="Cancelar" styleClass="btn" oncomplete="window.location.href='navegadorEspecificacionesTecnicasPresentacion.jsf';" />

                   
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

