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
            
            <script  type="text/javascript">
                A4J.AJAX.onError = function(req,status,message){
                window.alert("Ocurrio un error "+message+" continue con su transaccion ");
                }
                A4J.AJAX.onExpired = function(loc,expiredMsg){
                if(window.confirm("Ocurrio un error al momento realizar la transaccion: "+expiredMsg+" location: "+loc)){
                return loc;
                } else {
                return false;
                }
                }
                function cambiarNombreCampania(celda)
                {
                    if(document.getElementById("form1:nombreCampania").value=='')
                        {
                            document.getElementById("form1:nombreCampania").value=celda.options[celda.selectedIndex].innerHTML;
                        }
                }
         </script>
        </head>
             <a4j:form id="form1">
                <div align="center">
                    
                    <h:outputText styleClass="outputText2"  value="Programas de Producción" />
                    <rich:panel headerClass="headerClassACliente" style="width:60%">
                        <f:facet name="header">
                            <h:outputText value="Datos Campaña"/>
                        </f:facet>
                        <h:panelGrid columns="3">
                            <h:outputText value="Programa Produccion" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="#{ManagedCampanasProgramaProduccion.programaProduccionPeriodoBean.nombreProgramaProduccion}" styleClass="outputText2"/>
                            <h:outputText value="Nombre Campaña" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <h:inputText value="#{ManagedCampanasProgramaProduccion.campaniaProgramaProduccionBean.nombreCampaniaProgramaProduccion}" styleClass="inputText"
                            id="nombreCampania" style="width:30em"/>
                            <h:outputText value="Tipo Campaña" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <h:selectOneMenu value="#{ManagedCampanasProgramaProduccion.campaniaProgramaProduccionBean.tiposCampaniaProgramaProduccion.codTipoCampaniaProgramaProduccion}" styleClass="inputText">
                                <f:selectItems value="#{ManagedCampanasProgramaProduccion.tiposCampaniaProgramaProduccionSelectList}"/>
                                <a4j:support event="onchange" reRender="buscarProducto,dataLotesProduccion" action="#{ManagedCampanasProgramaProduccion.tipoCampania_change}"/>
                            </h:selectOneMenu>
                        </h:panelGrid>
                        <h:panelGroup id="buscarProducto">
                        <rich:panel headerClass="headerClassACliente" rendered="#{ManagedCampanasProgramaProduccion.campaniaProgramaProduccionBean.tiposCampaniaProgramaProduccion.codTipoCampaniaProgramaProduccion eq '1'}">
                            <f:facet name="header">
                                <h:outputText value="Producto de la campaña"/>
                            </f:facet>
                            <h:panelGrid columns="3">
                                    <h:outputText value="Producto" styleClass="outputText2" style="font-weight:bold"/>
                                    <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                    <h:selectOneMenu onchange="cambiarNombreCampania(this)" value="#{ManagedCampanasProgramaProduccion.campaniaProgramaProduccionBean.componentesProd.codCompprod}" styleClass="inputText">
                                        <f:selectItems value="#{ManagedCampanasProgramaProduccion.componentesProdSelectList}"/>
                                    </h:selectOneMenu>
                            </h:panelGrid>
                            <center>
                                <a4j:commandButton value="BUSCAR LOTES" styleClass="btn" action="#{ManagedCampanasProgramaProduccion.buscarLotesProgramaProduccionProducto_action}"
                                reRender="dataLotesProduccion"/>
                            </center>
                        </rich:panel>
                        </h:panelGroup>
                    </rich:panel>
                    
                        
                        <rich:dataTable value="#{ManagedCampanasProgramaProduccion.campaniaProgramaProduccionDetalleList}"
                                    style="margin-top:12px;" var="data" id="dataLotesProduccion"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente" >
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value=""  />
                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.checked}"/>
                        </rich:column>

                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Producto"  />
                            </f:facet>
                            <h:outputText value="#{data.programaProduccion.componentesProdVersion.nombreProdSemiterminado}"  />
                        </rich:column>
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Lote"  />
                            </f:facet>
                            <h:outputText value="#{data.programaProduccion.codLoteProduccion}"  />
                        </rich:column>
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Cantidad Lote"  />
                            </f:facet>
                            <h:outputText value="#{data.programaProduccion.cantidadLote}"  />
                        </rich:column>
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Tipo Producción"  />
                            </f:facet>
                            <h:outputText value="#{data.programaProduccion.tiposProgramaProduccion.nombreTipoProgramaProd}"  />
                        </rich:column>
                        
                        
                    </rich:dataTable>
                    <a4j:commandButton value="Guardar" action="#{ManagedCampanasProgramaProduccion.guardarEdicionCampaniaProgramaProduccion_action}" styleClass="btn"
                    oncomplete="if(#{ManagedCampanasProgramaProduccion.mensaje eq '1'}){alert('Se guardo la edicion campaña');window.location.href='navegadorLotesCampaniaProgramaProduccion.jsf?data='+(new Date()).getTime().toString();}
                    else{alert('#{ManagedCampanasProgramaProduccion.mensaje}')}"/>
                    <a4j:commandButton value="Cancelar"  styleClass="btn" oncomplete="window.location.href='navegadorLotesCampaniaProgramaProduccion.jsf?cancel='+(new Date()).getTime().toString();"/>
                    
                    
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

