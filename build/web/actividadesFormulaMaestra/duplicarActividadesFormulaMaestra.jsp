<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>
<html>
    <head>
        <title>SISTEMA</title>
        <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
        <link rel="STYLESHEET" type="text/css" href="../css/icons.css" />
        <link rel="STYLESHEET" type="text/css" href="../css/chosen.css" /> 
        <script type="text/javascript" src='../js/general.js' ></script>

    </head>
    <body>

        <a4j:form id="form1"  >   

        <div align="center">
            <br>
            <h:outputText value="#{ManagedActividadesFormulaMaestra.cargarDuplicarActividades}"/>
            <rich:panel headerClass="headerClassACliente" id="panelFiltro" style="align:center;text-align:center;width:60%;margin-top:10px;">
                    <f:facet name="header">
                        <h:outputText value="Datos del Producto de referencia"/>
                    </f:facet>
                    <rich:panel headerClass="headerClassACliente" style="align:center;text-align:center;margin-top:10px;">
                        <f:facet name="header">
                            <h:outputText value="Duplicar desde:"/>
                        </f:facet>
                        <h:panelGrid columns="3" id="datosProductoOrigen">
                            <h:outputText value="Producto" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <h:panelGroup>
                                <h:selectOneMenu value="#{ManagedActividadesFormulaMaestra.actividadesFormulaMaestraDuplicar.formulaMaestra.codFormulaMaestra}" styleClass="chosen" 
                                                 required="true" validatorMessage="Debe Seleccionar una opción"
                                                 id="codProductoOrigen">
                                    <f:validateLongRange minimum="1"/>
                                    <f:selectItem itemValue="0" itemLabel="--Seleccione una opcion--"/>
                                    <f:selectItems value="#{ManagedActividadesFormulaMaestra.formulaMaestraSelectList}"/>
                                    <a4j:support action="#{ManagedActividadesFormulaMaestra.codFormulaMaestra_change}" 
                                                 reRender="datosProductoOrigen,dataActividades" event="onchange" immediate="true">
                                        <a4j:actionparam name="type" value="this.value" 
                                                        assignTo="#{ManagedActividadesFormulaMaestra.actividadesFormulaMaestraDuplicar.formulaMaestra.codFormulaMaestra}" 
                                                        noEscape="true"/>
                                    </a4j:support>
                                </h:selectOneMenu>
                                <h:message for="codProductoOrigen" styleClass="mensajeValidacion"/>
                            </h:panelGroup>
                            <h:outputText value="Area Actividad" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <h:panelGroup>
                                <h:selectOneMenu required="true" id="codAreaActividad"  validatorMessage="Debe seleccionar una opcion" 
                                                 value="#{ManagedActividadesFormulaMaestra.actividadesFormulaMaestraDuplicar.areasEmpresa.codAreaEmpresa}" styleClass="inputText chosen">
                                    <f:selectItem itemValue="0" itemLabel="--Seleccione una opción--"/>
                                    <f:selectItems value="#{ManagedActividadesFormulaMaestra.areasEmpresaActividadSelectList}"/>
                                    <a4j:support  reRender="datosProductoOrigen,datosProductoDestino,dataActividades" event="onchange" immediate="true"
                                                  action="#{ManagedActividadesFormulaMaestra.codAreaEmpresaActividad_change}">
                                        <a4j:actionparam name="type" value="this.value" 
                                                    assignTo="#{ManagedActividadesFormulaMaestra.actividadesFormulaMaestraDuplicar.areasEmpresa.codAreaEmpresa}" 
                                                    noEscape="true"/>
                                    </a4j:support>
                                    <f:validateLongRange minimum="1" />
                                </h:selectOneMenu>
                                <h:message for="codAreaActividad" styleClass="mensajeValidacion"/>
                            </h:panelGroup>
                            <h:outputText value="Presentacion" styleClass="outputTextBold" rendered="#{ManagedActividadesFormulaMaestra.actividadesFormulaMaestraDuplicar.areasEmpresa.codAreaEmpresa eq '84'}"/>
                            <h:outputText value="::" styleClass="outputTextBold" rendered="#{ManagedActividadesFormulaMaestra.actividadesFormulaMaestraDuplicar.areasEmpresa.codAreaEmpresa eq '84'}"/>
                            <h:panelGroup rendered="#{ManagedActividadesFormulaMaestra.actividadesFormulaMaestraDuplicar.areasEmpresa.codAreaEmpresa eq '84'}">
                                <h:selectOneMenu  id="codPresentacionOrigen" required="true"  
                                                  validatorMessage="Debe Seleccionar una opción"
                                                  value="#{ManagedActividadesFormulaMaestra.actividadesFormulaMaestraDuplicar.presentacionesProducto.codPresentacion}" >
                                    <f:selectItem itemLabel="--Seleccione una opcion--" itemValue="0"/>
                                    <f:selectItems value="#{ManagedActividadesFormulaMaestra.presentacionesSelectList}"/>
                                    <a4j:support event="onchange" reRender="dataActividades" action="#{ManagedActividadesFormulaMaestra.vaciarActividadFormulaMaestraDuplicarList_action}"/>
                                    <f:validateLongRange minimum="1"/>
                                </h:selectOneMenu>
                                <h:message for="codPresentacionOrigen" styleClass="mensajeValidacion"/>
                            </h:panelGroup>
                            <h:outputText value="Tipo Programa Produccion" styleClass="outputTextBold" rendered="#{ManagedActividadesFormulaMaestra.actividadesFormulaMaestraDuplicar.areasEmpresa.codAreaEmpresa eq '96'}"/>
                            <h:outputText value="::" styleClass="outputTextBold" rendered="#{ManagedActividadesFormulaMaestra.actividadesFormulaMaestraDuplicar.areasEmpresa.codAreaEmpresa eq '96'}"/>
                            <h:selectOneMenu value="#{ManagedActividadesFormulaMaestra.actividadesFormulaMaestraDuplicar.tiposProgramaProduccion.codTipoProgramaProd}" rendered="#{ManagedActividadesFormulaMaestra.actividadesFormulaMaestraDuplicar.areasEmpresa.codAreaEmpresa eq '96'}">
                                <a4j:support event="onchange" reRender="dataActividades" action="#{ManagedActividadesFormulaMaestra.vaciarActividadFormulaMaestraDuplicarList_action}"/>
                                <f:selectItem itemValue="0" itemLabel="--Generico--"/>
                                <f:selectItems value="#{ManagedActividadesFormulaMaestra.tiposProgramaProduccionSelectList}"/>
                            </h:selectOneMenu>
                                
                        </h:panelGrid>
                    </rich:panel>
                    <rich:panel headerClass="headerClassACliente" style="align:center;text-align:center;margin-top:10px;">
                            <f:facet name="header">
                                <h:outputText value="A Producto:"/>
                            </f:facet>
                            <h:panelGrid columns="3" id="datosProductoDestino">
                                <h:outputText value="Duplicar Datos en " styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                <h:panelGroup>
                                    <h:selectOneMenu  id="codFormulaMaestraDestino" required="true" validatorMessage="Debe seleccionar una opción"
                                                    value="#{ManagedActividadesFormulaMaestra.actividadesFormulaMaestraDestino.formulaMaestra.codFormulaMaestra}" styleClass="inputText chosen">
                                        <f:selectItem itemValue="0" itemLabel="--Seleccione una opción--"/>
                                        <f:selectItems value="#{ManagedActividadesFormulaMaestra.formulaMaestraSelectList}"/>
                                        <a4j:support  reRender="datosProductoDestino" event="onchange" immediate="true" action="#{ManagedActividadesFormulaMaestra.codFormulaMaestraDestino_change}">
                                            <a4j:actionparam name="type" value="this.value" 
                                                        assignTo="#{ManagedActividadesFormulaMaestra.actividadesFormulaMaestraDestino.formulaMaestra.codFormulaMaestra}" 
                                                        noEscape="true"/>
                                        </a4j:support>
                                        <f:validateLongRange minimum="1" />
                                    </h:selectOneMenu>
                                    <h:message for="codFormulaMaestraDestino" styleClass="mensajeValidacion"/>
                                </h:panelGroup>
                                <h:outputText value="Presentacion" styleClass="outputTextBold"
                                                rendered="#{ManagedActividadesFormulaMaestra.actividadesFormulaMaestraDuplicar.areasEmpresa.codAreaEmpresa eq '84'}"/>
                                <h:outputText value="::" styleClass="outputTextBold"
                                              rendered="#{ManagedActividadesFormulaMaestra.actividadesFormulaMaestraDuplicar.areasEmpresa.codAreaEmpresa eq '84'}"/>
                                <h:panelGroup>
                                    <h:selectOneMenu id="codPresentacionDestino" value="#{ManagedActividadesFormulaMaestra.actividadesFormulaMaestraDestino.presentacionesProducto.codPresentacion}"
                                                     required="true" validatorMessage="Debe seleccionar una opción"
                                                     rendered="#{ManagedActividadesFormulaMaestra.actividadesFormulaMaestraDuplicar.areasEmpresa.codAreaEmpresa eq '84'}">
                                        <f:selectItem itemLabel="--Seleccione una opción--" itemValue="0"/>
                                        <f:selectItems value="#{ManagedActividadesFormulaMaestra.presentacionesDestinoSelectList}"/>
                                        <f:validateLongRange minimum="1" />
                                    </h:selectOneMenu>
                                    <h:message for="codPresentacionDestino" styleClass="mensajeValidacion"/>
                                </h:panelGroup>
                            </h:panelGrid>
                    </rich:panel>
                    <a4j:commandButton value="BUSCAR" action="#{ManagedActividadesFormulaMaestra.buscarActidadesDatosFiltro_action}" styleClass="btn" reRender="panelFiltro,dataActividades"/>
                <center>
                    <rich:dataTable value="#{ManagedActividadesFormulaMaestra.actividadesFormulaMaestraDuplicarList}"
                                var="data" id="dataActividades"
                                onRowMouseOut="this.style.backgroundColor='#FFFFFF';" style="margin-top:12px;"
                                onRowMouseOver="this.style.backgroundColor='#CCDFFA';" 
                                headerClass="headerClassACliente"
                                columnClasses="tituloCampo">
                        <f:facet name="header">
                                <rich:columnGroup>
                                    <rich:column rowspan="2">
                                        <h:selectBooleanCheckbox onclick="seleccionarTodosCheckBox(this)"/>
                                    </rich:column >
                                    <rich:column rowspan="2">
                                        <h:outputText value="Orden" style="font-weight:bold" />
                                    </rich:column>
                                    <rich:column rowspan="2">
                                        <h:outputText value="Actividad Producción"  style="font-weight:bold"/>
                                    </rich:column>
                                </rich:columnGroup>
                        </f:facet>
                        <rich:column>
                            <h:selectBooleanCheckbox value="#{data.checked}"/>
                        </rich:column>
                        <rich:column>
                            <h:inputText value="#{data.ordenActividad}" styleClass="inputText" size="4"/>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.actividadesProduccion.nombreActividad}"/>
                        </rich:column>
                    </rich:dataTable>
                </center>
            <br>
                <a4j:commandLink  styleClass="btn" reRender="form1"
                                action="#{ManagedActividadesFormulaMaestra.replicarDatosActividadesFormula}"
                                oncomplete="if('#{facesContext.maximumSeverity}'.length==0){mostrarMensajeTransaccionEvento(function(){redireccionar('navegadorFormulaMaestraActividad.jsf')})}"
                                >
                         <h:outputText styleClass="icon-floppy-disk"/>
                         <h:outputText value="Guardar"/>
                 </a4j:commandLink>
                 <input type="button" value="Cancelar" id="buttonCancelar"  class="btn" onclick="redireccionar('navegadorFormulaMaestraActividad.jsf')" />
            </rich:panel>
              
            </div>
            
            
        </a4j:form>
        <a4j:include viewId="../message.jsp" />
        <a4j:status id="statusPeticion"
                    onstart="Richfaces.showModalPanel('ajaxLoadingModalBox',{width:100, top:100})"
                    onstop="Richfaces.hideModalPanel('ajaxLoadingModalBox');cargarChosen();">
        </a4j:status>

        <rich:modalPanel id="ajaxLoadingModalBox" minHeight="100"
                         minWidth="200" height="80" width="400" zindex="100" onshow="window.focus();">

            <div align="center">
                <h:graphicImage value="../img/load2.gif" />
            </div>
        </rich:modalPanel>
        <a4j:loadScript src="../js/chosen.js" />
        <script type="text/javascript">
                cargarChosen();
        </script>
    </body>
    </html>

</f:view>

