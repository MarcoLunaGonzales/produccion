
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
            <script type="text/javascript" src="../../js/general.js" ></script>
            <script type="text/javascript">
                function validarModificarMesStock()
                {
                    return (validarMayorACero(document.getElementById("formRegistrar:nivelMinimoStock"))&&
                            validarMayorACero(document.getElementById("formRegistrar:nivelMaximoStock"))&&
                            validarMayorACero(document.getElementById("formRegistrar:nroMesesStockMinimo"))&&
                            validarMayorACero(document.getElementById("formRegistrar:nroMesesStockReposicion"))&&
                            validarMayorACero(document.getElementById("formRegistrar:nroCiclos"))
                            );
                }
            </script>
        </head>
            <a4j:form id="form1" >
                <center>
                    <span class="outputTextTituloSistema">Configuración Calculo Stock</span>
                    <h:outputText value="#{ManagedProgramaProduccionSolicitudCompra.cargarMesesStockGrupoList}"/>
                    <rich:simpleTogglePanel headerClass="headerClassACliente tdCenter"  switchType="client">
                        <center>
                            <f:facet name="header">
                                <h:outputText value="BUSCADOR"/>
                            </f:facet>
                            <h:panelGrid columns="3">
                                <h:outputText value="Grupo" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:selectManyMenu style="height:10em" value="#{ManagedProgramaProduccionSolicitudCompra.codGrupoSelectBuscarList}" styleClass="inputText">
                                    <f:selectItems value="#{ManagedProgramaProduccionSolicitudCompra.gruposCapitulosSelectList}"/>
                                </h:selectManyMenu>
                                <h:outputText value="Tipo Transporte" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:selectOneMenu value="#{ManagedProgramaProduccionSolicitudCompra.mesesStockGrupoBuscar.tiposTransporte.codTipoTransporte}" styleClass="inputText">
                                    <f:selectItem itemValue='0' itemLabel="--TODOS--"/>
                                    <f:selectItems value="#{ManagedProgramaProduccionSolicitudCompra.tiposTransporteSelectList}"/>
                                </h:selectOneMenu>
                                <h:outputText value="Tipo Compra" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:selectOneMenu value="#{ManagedProgramaProduccionSolicitudCompra.mesesStockGrupoBuscar.tiposCompra.codTipoCompra}" styleClass="inputText">
                                    <f:selectItem itemValue='0' itemLabel="--TODOS--"/>
                                    <f:selectItems value="#{ManagedProgramaProduccionSolicitudCompra.tiposCompraSelectList}"/>
                                </h:selectOneMenu>
                            </h:panelGrid>
                            <a4j:commandButton value="BUSCAR" action="#{ManagedProgramaProduccionSolicitudCompra.buscarMesesStockGrupoList_action}"
                                               reRender="dataMesesStockgrupo" styleClass="btn"/>
                        </center>
                    </rich:simpleTogglePanel>
                    <rich:dataTable value="#{ManagedProgramaProduccionSolicitudCompra.mesesStockGrupoList}" 
                                    var="data" id="dataMesesStockgrupo"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    style="margin-top:1em"
                                    headerClass="headerClassACliente">
                        <f:facet name="header">
                            <rich:columnGroup>
                                <rich:column>
                                    <h:outputText value=""/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Capitulo"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Grupo"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Tipo Compra"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Tipo Transporte"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Nivel Minimo Stock"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Nivel Maximo Stock"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Tiempo SS"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Tiempo PP"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Nro de Ciclos"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Varificar Cantidad Lote"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Verificar Stock Hermes"/>
                                </rich:column>
                            </rich:columnGroup>
                        </f:facet>
                            <rich:column>
                                <h:selectBooleanCheckbox value="#{data.checked}"/>  
                            </rich:column>
                            <rich:column>
                                <h:outputText value="#{data.grupos.capitulo.nombreCapitulo}"/>
                            </rich:column>
                            <rich:column>
                                <h:outputText value="#{data.grupos.nombreGrupo}"/>
                            </rich:column>
                            <rich:column>
                                <h:outputText value="#{data.tiposCompra.nombreTipoCompra}"/>
                            </rich:column>
                            <rich:column>
                                <h:outputText value="#{data.tiposTransporte.nombreTipoTransporte}"/>
                            </rich:column>
                            <rich:column>
                                <h:outputText value="#{data.nivelMinimoStock}"/>
                            </rich:column>
                            <rich:column>
                                <h:outputText value="#{data.nivelMaximoStock}"/>
                            </rich:column>
                            <rich:column>
                                <h:outputText value="#{data.nroMesesStockMinimo}"/>
                            </rich:column>
                            <rich:column>
                                <h:outputText value="#{data.nroMesesStockReposicion}"/>
                            </rich:column>
                            <rich:column>
                                <h:outputText value="#{data.nroCiclos}"/>
                            </rich:column>
                            <rich:column>
                                <h:outputText value="#{data.verificarCantidadLote?'SI':'NO'}"/>
                            </rich:column>
                            <rich:column>
                                <h:outputText value="#{data.verificarStockHermes?'SI':'NO'}"/>
                            </rich:column>

                    </rich:dataTable>
                    
                    <div id="bottonesAcccion" class="barraBotones">
                        <a4j:commandButton value="Modificar" styleClass="btn" onclick="if(!editarItem('form1:dataMesesStockgrupo')){return false;}"
                                           action="#{ManagedProgramaProduccionSolicitudCompra.editarMesesStockGrupo_action}"
                                           oncomplete="Richfaces.showModalPanel('panelModificarMesesStock')" reRender="contenidoModificarStock"/>
                    </div>
                    </center>
            </a4j:form>
            <rich:modalPanel id="panelModificarMesesStock" minHeight="290"  minWidth="600"
                                     height="290" width="600"
                                     zindex="40"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="<center>Modificar Datos Meses Calculo Stock</center>" escape="false"/>
                        </f:facet>
                        <a4j:form id="formRegistrar">
                        <h:panelGroup id="contenidoModificarStock">
                            <div align="center">
                            <h:panelGrid columns="3">
                                <h:outputText value="Capitulo" styleClass="outputTextBold" />
                                <h:outputText value="::" styleClass="outputTextBold" />
                                <h:outputText value="#{ManagedProgramaProduccionSolicitudCompra.mesesStockGrupoEditar.grupos.capitulo.nombreCapitulo}" styleClass="outputText2" />
                                <h:outputText value="Grupo" styleClass="outputTextBold" />
                                <h:outputText value="::" styleClass="outputTextBold" />
                                <h:outputText value="#{ManagedProgramaProduccionSolicitudCompra.mesesStockGrupoEditar.grupos.nombreGrupo}" styleClass="outputText2" />
                                <h:outputText value="Tipo Compra" styleClass="outputTextBold" />
                                <h:outputText value="::" styleClass="outputTextBold" />
                                <h:outputText value="#{ManagedProgramaProduccionSolicitudCompra.mesesStockGrupoEditar.tiposCompra.nombreTipoCompra}" styleClass="outputText2" />
                                <h:outputText value="Tipo Transporte" styleClass="outputTextBold" />
                                <h:outputText value="::" styleClass="outputTextBold" />
                                <h:outputText value="#{ManagedProgramaProduccionSolicitudCompra.mesesStockGrupoEditar.tiposTransporte.nombreTipoTransporte}" styleClass="outputText2" />
                                <h:outputText value="Nivel Minimo Stock" styleClass="outputTextBold" />
                                <h:outputText value="::" styleClass="outputTextBold" />
                                <h:inputText value="#{ManagedProgramaProduccionSolicitudCompra.mesesStockGrupoEditar.nivelMinimoStock}" id="nivelMinimoStock" styleClass="inputText" onblur="valorPorDefecto(this)"/>
                                <h:outputText value="Nivel Maximo Stock" styleClass="outputTextBold" />
                                <h:outputText value="::" styleClass="outputTextBold" />
                                <h:inputText value="#{ManagedProgramaProduccionSolicitudCompra.mesesStockGrupoEditar.nivelMaximoStock}" id="nivelMaximoStock" styleClass="inputText" onblur="valorPorDefecto(this)"/>
                                <h:outputText value="Tiempo SS" styleClass="outputTextBold" />
                                <h:outputText value="::" styleClass="outputTextBold" />
                                <h:inputText value="#{ManagedProgramaProduccionSolicitudCompra.mesesStockGrupoEditar.nroMesesStockMinimo}" id="nroMesesStockMinimo" styleClass="inputText" onblur="valorPorDefecto(this)"/>
                                <h:outputText value="Tiempo PP" styleClass="outputTextBold" />
                                <h:outputText value="::" styleClass="outputTextBold" />
                                <h:inputText value="#{ManagedProgramaProduccionSolicitudCompra.mesesStockGrupoEditar.nroMesesStockReposicion}" id="nroMesesStockReposicion" styleClass="inputText" onblur="valorPorDefecto(this)"/>
                                <h:outputText value="Numero de Ciclos" styleClass="outputTextBold" />
                                <h:outputText value="::" styleClass="outputTextBold" />
                                <h:inputText value="#{ManagedProgramaProduccionSolicitudCompra.mesesStockGrupoEditar.nroCiclos}" id="nroCiclos" styleClass="inputText" onblur="valorPorDefecto(this)"/>
                                <h:outputText value="Verificar Cantidad Lote" styleClass="outputTextBold" />
                                <h:outputText value="::" styleClass="outputTextBold" />
                                <h:selectOneRadio value="#{ManagedProgramaProduccionSolicitudCompra.mesesStockGrupoEditar.verificarCantidadLote}" styleClass="outputText2">
                                    <f:selectItem itemValue='true' itemLabel="SI"/>
                                    <f:selectItem itemValue='false' itemLabel="NO"/>
                                </h:selectOneRadio>
                            </h:panelGrid>
                                
                                <a4j:commandButton styleClass="btn" action="#{ManagedProgramaProduccionSolicitudCompra.guardarEditarMesesStockGrupo_action}" value="Guardar"
                                                   onclick="if(!validarModificarMesStock()){return false;}"
                                                       oncomplete="if(#{ManagedProgramaProduccionSolicitudCompra.mensaje eq '1'}){alert('Se registro la modificacion de los datos');Richfaces.hideModalPanel('panelModificarMesesStock');}else{alert('#{ManagedProgramaProduccionSolicitudCompra.mensaje}')}"
                                                       reRender="dataMesesStockgrupo"/>
                                    <input type="button" value="Cancelar" onclick="Richfaces.hideModalPanel('panelModificarMesesStock')" class="btn" />
                                </div>
                        </h:panelGroup>
                        </a4j:form>
            </rich:modalPanel>
         <a4j:status id="statusPeticion"
                        onstart="Richfaces.showModalPanel('ajaxLoadingModalBox',{width:100, top:100})"
                        onstop="Richfaces.hideModalPanel('ajaxLoadingModalBox')">
            </a4j:status>

            <rich:modalPanel id="ajaxLoadingModalBox" minHeight="100"
                             minWidth="200" height="80" width="400" zindex="100" onshow="window.focus();">

                <div align="center">
                    <h:graphicImage value="../img/load2.gif" />
                </div>
            </rich:modalPanel>

        </body>
    </html>

</f:view>

