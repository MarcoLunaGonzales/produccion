
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
            <script type="text/javascript">
                function validarRegistroNuevoMedioFiltracion()
                {
                    return(validarRegistroNoVacio(document.getElementById("formRegistrar:cantidadFiltro"))&&
                           validarRegistroNoVacio(document.getElementById("formRegistrar:presionAprobacion"))&&
                           validarMayorACero(document.getElementById("formRegistrar:codigoFiltro")));
                    
                }
                function validarEdicionRegistroFiltro()
                {
                    return (validarRegistroNoVacio(document.getElementById('formEditar:cantidadFiltro')));
                }
            </script>
            <style>
                
            </style>
        </head>
        <body >
            <a4j:form id="form1">
                <div align="center">
                    <h:outputText value="#{ManagedFiltrosProduccion.cargarFiltrosProduccion}"/>
                    <h:outputText value="Filtros de Producción" styleClass="outputTextTituloSistema" style="font-size:15px;font-weight:bold"/>
                    
                    <rich:dataTable value="#{ManagedFiltrosProduccion.filtrosProduccionList}"
                                    var="data"
                                    id="dataFiltrosProduccion"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente" >
                        <f:facet name="header">
                            <rich:columnGroup>
                                <rich:column>
                                    <h:outputText value=""/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Cantidad<br>del<br>filtro" escape="false"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Unidad de<br>Medida<br>(Filtro)" escape="false"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Codigo<br>del filtro" escape="false"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Presión<br>de aprobación" escape="false"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Unidad de<br>Medida<br>(Presión)" escape="false"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Medio de<br>Filtración" escape="false"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Estado" escape="false"/>
                                </rich:column>
                            </rich:columnGroup>
                        </f:facet>
                        <rich:column>
                            <h:selectBooleanCheckbox value="#{data.checked}"/>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.cantidadFiltro}"/>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.unidadesMedida.nombreUnidadMedida}"/>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.codigoFiltroProduccion}"/>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.presionAprobación}"/>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.unidadesMedidaPresion.nombreUnidadMedida}"/>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.mediosFiltracion.nombreMedioFiltracion}"/>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.estadoRegistro.nombreEstadoRegistro}"/>
                        </rich:column>
                        
                    </rich:dataTable>
                   
                    <br>
                        <a4j:commandButton value="Registrar" styleClass="btn" action="#{ManagedFiltrosProduccion.agregarFiltroProduccion_action}" oncomplete="Richfaces.showModalPanel('panelRegistrarFiltroProduccion')" reRender="contenidoRegistrarFiltroProduccion" />
                        <a4j:commandButton value="Editar" styleClass="btn" onclick="if(editarItem('form1:dataFiltrosProduccion')==false){return false;}" action="#{ManagedFiltrosProduccion.editarFiltroProduccion_action}" oncomplete="Richfaces.showModalPanel('PanelEditarFiltroProduccion')"
                        reRender="contenidoEditarFiltroProduccion"/>
                        <a4j:commandButton value="Eliminar" styleClass="btn" onclick="if(editarItem('form1:dataFiltrosProduccion')==false){return false;}" action="#{ManagedFiltrosProduccion.eliminarFiltroProduccion_action}"
                                           oncomplete="if(#{ManagedFiltrosProduccion.mensaje eq '1'}){alert('Se elimino el filtro de producción');}else{alert('#{ManagedFiltrosProduccion.mensaje}');}"
                        reRender="dataFiltrosProduccion"/>
                        

                   
                </div>

               
              
            </a4j:form>

             <rich:modalPanel id="panelRegistrarFiltroProduccion" minHeight="250"  minWidth="550"
                                     height="250" width="550"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" >
                        <f:facet name="header">
                            <h:outputText value="<center>Registro de Filtro de Producción</center>" escape="false"/>
                        </f:facet>
                        <a4j:form id="formRegistrar">
                        <div align="center">
                            <h:panelGroup id="contenidoRegistrarFiltroProduccion">
                                <h:panelGrid columns="3">
                                        <h:outputText value="Cantidad(filtro)" styleClass="outputTextBold" />
                                        <h:outputText value="::" styleClass="outputTextBold" />
                                        <h:inputText value="#{ManagedFiltrosProduccion.filtrosProduccionAgregar.cantidadFiltro}" styleClass="inputText" id="cantidadFiltro" size="40" />
                                        <h:outputText value="Unidad de Medida(filtro)" styleClass="outputTextBold" />
                                        <h:outputText value="::" styleClass="outputTextBold" />
                                        <h:selectOneMenu value="#{ManagedFiltrosProduccion.filtrosProduccionAgregar.unidadesMedida.codUnidadMedida}" styleClass="inputText">
                                            <f:selectItems value="#{ManagedFiltrosProduccion.unidadesMedidaSelectList}"/>
                                        </h:selectOneMenu>
                                        <h:outputText value="Codigo del Filtro" styleClass="outputTextBold" />
                                        <h:outputText value="::" styleClass="outputTextBold" />
                                        <h:inputText value="#{ManagedFiltrosProduccion.filtrosProduccionAgregar.codigoFiltroProduccion}" styleClass="inputText" id="codigoFiltro"  style="width:100%" onblur="valorPorDefecto(this)" />
                                        <h:outputText value="Presión de aprobación" styleClass="outputTextBold" />
                                        <h:outputText value="::" styleClass="outputTextBold" />
                                        <h:inputText value="#{ManagedFiltrosProduccion.filtrosProduccionAgregar.presionAprobación}" styleClass="inputText" id="presionAprobacion"  style="width:100%" size="40" />
                                        <h:outputText value="Unidad de Medida(presión)" styleClass="outputTextBold" />
                                        <h:outputText value="::" styleClass="outputTextBold" />
                                        <h:selectOneMenu value="#{ManagedFiltrosProduccion.filtrosProduccionAgregar.unidadesMedidaPresion.codUnidadMedida}" styleClass="inputText">
                                            <f:selectItems value="#{ManagedFiltrosProduccion.unidadesMedidaSelectList}"/>
                                        </h:selectOneMenu>
                                        <h:outputText value="Medio de Filtración" styleClass="outputTextBold" />
                                        <h:outputText value="::" styleClass="outputTextBold" />
                                        <h:selectOneMenu value="#{ManagedFiltrosProduccion.filtrosProduccionAgregar.mediosFiltracion.codMedioFiltracion}" styleClass="inputText">
                                            <f:selectItems value="#{ManagedFiltrosProduccion.mediosFiltracionSelectList}"/>
                                        </h:selectOneMenu>

                                </h:panelGrid>
                            </h:panelGroup>
                            <br>
                                
                                    <a4j:commandButton styleClass="btn" value="Registrar"  action="#{ManagedFiltrosProduccion.guardarAgregarFiltroProduccion_action}"
                                                       onclick="if(!validarRegistroNuevoMedioFiltracion()){return false;}"
                                                       reRender="dataFiltrosProduccion" oncomplete="if(#{ManagedFiltrosProduccion.mensaje eq '1'}){alert('Se guardo el filtro de produccion');Richfaces.hideModalPanel('panelRegistrarFiltroProduccion');}else{alert('#{ManagedFiltrosProduccion.mensaje}');}"/>
                                    <a4j:commandButton value="Cancelar" oncomplete="javascript:Richfaces.hideModalPanel('panelRegistrarFiltroProduccion')" styleClass="btn"/>
                        </div>
                        </a4j:form>
            </rich:modalPanel>

           <rich:modalPanel id="PanelEditarFiltroProduccion" minHeight="250"  minWidth="500"
                                     height="250" width="500"
                                     zindex="200"
                                     headerClass="headerClassACliente" >
                        <f:facet name="header">
                            <h:outputText value="Modificación de Actividades Preparado"/>
                        </f:facet>
                        <a4j:form id="formEditar">
                        <h:panelGroup id="contenidoEditarFiltroProduccion">
                             <h:panelGrid columns="3">
                                <h:outputText value="Cantidad(filtro)" styleClass="outputTextBold" />
                                <h:outputText value="::" styleClass="outputTextBold" />
                                <h:inputText value="#{ManagedFiltrosProduccion.filtrosProduccionEditar.cantidadFiltro}" styleClass="inputText" id="cantidadFiltro" size="40" rendered="#{ManagedFiltrosProduccion.filtrosProduccionEditar.cantidadVersiones==0}"/>
                                <h:outputText value="#{ManagedFiltrosProduccion.filtrosProduccionEditar.cantidadFiltro}" styleClass="outputText2" rendered="#{ManagedFiltrosProduccion.filtrosProduccionEditar.cantidadVersiones>0}"/>
                                <h:outputText value="Unidad de Medida(filtro)" styleClass="outputTextBold" />
                                <h:outputText value="::" styleClass="outputTextBold" />
                                <h:selectOneMenu value="#{ManagedFiltrosProduccion.filtrosProduccionEditar.unidadesMedida.codUnidadMedida}" styleClass="inputText" rendered="#{ManagedFiltrosProduccion.filtrosProduccionEditar.cantidadVersiones==0}">
                                    <f:selectItems value="#{ManagedFiltrosProduccion.unidadesMedidaSelectList}"/>
                                </h:selectOneMenu>
                                <h:outputText value="#{ManagedFiltrosProduccion.filtrosProduccionEditar.unidadesMedida.nombreUnidadMedida}" styleClass="outputText2" rendered="#{ManagedFiltrosProduccion.filtrosProduccionEditar.cantidadVersiones>0}"/>
                                <h:outputText value="Codigo del Filtro" styleClass="outputTextBold" />
                                <h:outputText value="::" styleClass="outputTextBold" />
                                <h:inputText value="#{ManagedFiltrosProduccion.filtrosProduccionEditar.codigoFiltroProduccion}" styleClass="inputText" id="codigoFiltro"  style="width:100%" onblur="valorPorDefecto(this)" rendered="#{ManagedFiltrosProduccion.filtrosProduccionEditar.cantidadVersiones==0}"/>
                                <h:outputText value="#{ManagedFiltrosProduccion.filtrosProduccionEditar.codigoFiltroProduccion}" styleClass="outputText2" rendered="#{ManagedFiltrosProduccion.filtrosProduccionEditar.cantidadVersiones>0}"/>
                                <h:outputText value="Presión de aprobación" styleClass="outputTextBold" />
                                <h:outputText value="::" styleClass="outputTextBold" />
                                <h:inputText value="#{ManagedFiltrosProduccion.filtrosProduccionEditar.presionAprobación}" styleClass="inputText" id="presionAprobacion"  style="width:100%" size="40" rendered="#{ManagedFiltrosProduccion.filtrosProduccionEditar.cantidadVersiones==0}" />
                                <h:outputText value="#{ManagedFiltrosProduccion.filtrosProduccionEditar.presionAprobación}" styleClass="outputText2"   rendered="#{ManagedFiltrosProduccion.filtrosProduccionEditar.cantidadVersiones>0}" />
                                <h:outputText value="Unidad de Medida(presión)" styleClass="outputTextBold" />
                                <h:outputText value="::" styleClass="outputTextBold" />
                                <h:selectOneMenu value="#{ManagedFiltrosProduccion.filtrosProduccionEditar.unidadesMedidaPresion.codUnidadMedida}" styleClass="inputText" rendered="#{ManagedFiltrosProduccion.filtrosProduccionEditar.cantidadVersiones==0}">
                                    <f:selectItems value="#{ManagedFiltrosProduccion.unidadesMedidaSelectList}"/>
                                </h:selectOneMenu>
                                <h:outputText value="#{ManagedFiltrosProduccion.filtrosProduccionEditar.unidadesMedidaPresion.nombreUnidadMedida}" styleClass="outputText2" rendered="#{ManagedFiltrosProduccion.filtrosProduccionEditar.cantidadVersiones>0}"/>
                                <h:outputText value="Medio de Filtración" styleClass="outputTextBold" />
                                <h:outputText value="::" styleClass="outputTextBold" />
                                <h:selectOneMenu value="#{ManagedFiltrosProduccion.filtrosProduccionEditar.mediosFiltracion.codMedioFiltracion}" styleClass="inputText" rendered="#{ManagedFiltrosProduccion.filtrosProduccionEditar.cantidadVersiones==0}">
                                    <f:selectItems value="#{ManagedFiltrosProduccion.mediosFiltracionSelectList}"/>
                                </h:selectOneMenu>
                                <h:outputText value="#{ManagedFiltrosProduccion.filtrosProduccionEditar.mediosFiltracion.nombreMedioFiltracion}" styleClass="outputText2" rendered="#{ManagedFiltrosProduccion.filtrosProduccionEditar.cantidadVersiones>0}"/>
                                <h:outputText value="Estado" styleClass="outputTextBold" />
                                <h:outputText value="::" styleClass="outputTextBold" />
                                <h:selectOneMenu value="#{ManagedFiltrosProduccion.filtrosProduccionEditar.estadoRegistro.codEstadoRegistro}" styleClass="inputText">
                                    <f:selectItem itemValue="1" itemLabel="Activo"/>
                                    <f:selectItem itemValue="2" itemLabel="No Activo"/>
                                </h:selectOneMenu>
                            </h:panelGrid>
                                
                        </h:panelGroup>
                        <div align="center">
                            <a4j:commandButton styleClass="btn" value="Guardar"  action="#{ManagedFiltrosProduccion.guardarEdicionFiltroProduccion_action}"
                                               onclick="if(!validarEdicionRegistroFiltro()){return false;}"
                                               reRender="dataFiltrosProduccion" oncomplete="if(#{ManagedFiltrosProduccion.mensaje eq '1'}){alert('Se registro la edición del filtro de producción');Richfaces.hideModalPanel('PanelEditarFiltroProduccion');}else{alert('#{ManagedFiltrosProduccion.mensaje}');}"/>
                            <a4j:commandButton value="Cancelar" oncomplete="Richfaces.hideModalPanel('PanelEditarFiltroProduccion')" styleClass="btn"/>
                            
                        </div>
                        </a4j:form>
            </rich:modalPanel>

        </body>
    </html>

</f:view>

