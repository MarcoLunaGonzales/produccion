<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" /> 
            <script type="text/javascript" src="../js/general.js"></script>
            <script type="text/javascript">
                function validarRegistroActividadProduccion()
                {
                    return (validarRegistroNoVacio(document.getElementById('form1:nombreActividad')));
                }
            </script>
        </head>
        <body>              
                <div align="center">
                    <a4j:form id="form1"  >
                        <div align="center">
                            <rich:panel headerClass="headerClassACliente" style="width:80%">
                                <f:facet name="header">
                                    <h:outputText value="Editar Actividad Producción"/>
                                </f:facet>
                                <h:panelGrid columns="3">
                                    <h:outputText styleClass="outputTextBold" value="Nombre actividad" />
                                    <h:outputText styleClass="outputTextBold" value="::"/>
                                    <h:inputText id="nombreActividad" value="#{ManagedActividadesProduccion.actividadesProduccionEditar.nombreActividad}" styleClass="inputText"style="width:30em" rendered="#{ManagedActividadesProduccion.actividadesProduccionEditar.cantidadDatosRelacionados==0}"/>
                                    <h:outputText value="#{ManagedActividadesProduccion.actividadesProduccionEditar.nombreActividad}" styleClass="outputText2" rendered="#{ManagedActividadesProduccion.actividadesProduccionEditar.cantidadDatosRelacionados>0}"/>
                                    <h:outputText styleClass="outputTextBold" value="Descripción"/>
                                    <h:outputText styleClass="outputTextBold" value="::"/>
                                    <h:inputTextarea value="#{ManagedActividadesProduccion.actividadesProduccionEditar.obsActividad}" styleClass="inputText" style="width:100%" rows="4">
                                    </h:inputTextarea>
                                    <h:outputText styleClass="outputTextBold" value="Unidad Medida"/>
                                    <h:outputText styleClass="outputTextBold" value="::"/>
                                    <h:selectOneMenu value="#{ManagedActividadesProduccion.actividadesProduccionEditar.unidadesMedida.codUnidadMedida}" styleClass="inputText">
                                        <f:selectItem itemLabel="--Ninguno--" itemValue="0"/>
                                        <f:selectItems value="#{ManagedActividadesProduccion.unidadesMedidaSelectList}"/>
                                    </h:selectOneMenu>
                                    <h:outputText styleClass="outputTextBold" value="Tipo Actividad Area"/>
                                    <h:outputText styleClass="outputTextBold" value="::"/>
                                    <h:selectOneMenu value="#{ManagedActividadesProduccion.actividadesProduccionEditar.tiposActividadProduccion.codTipoActividadProduccion}" styleClass="inputText">
                                        <f:selectItems value="#{ManagedActividadesProduccion.tiposActividadProducionSelectList}"/>
                                    </h:selectOneMenu>
                                    <h:outputText styleClass="outputTextBold" value="Tipo Actividad"/>
                                    <h:outputText styleClass="outputTextBold" value="::"/>
                                    <h:selectOneMenu value="#{ManagedActividadesProduccion.actividadesProduccionEditar.tipoActividad.codTipoActividad}" styleClass="inputText" rendered="#{ManagedActividadesProduccion.actividadesProduccionEditar.cantidadDatosRelacionados==0}">
                                        <f:selectItems value="#{ManagedActividadesProduccion.tiposActividadSelectList}"/>
                                    </h:selectOneMenu>
                                    <h:outputText value="#{ManagedActividadesProduccion.actividadesProduccionEditar.tipoActividad.nombreTipoActividad}" styleClass="outputText2" rendered="#{ManagedActividadesProduccion.actividadesProduccionEditar.cantidadDatosRelacionados>0}"/>
                                    <h:outputText styleClass="outputTextBold" value="Proceso Om"/>
                                    <h:outputText styleClass="outputTextBold" value="::"/>
                                    <h:outputText value="#{ManagedActividadesProduccion.actividadesProduccionEditar.procesosOrdenManufactura.nombreProcesoOrdenManufactura}" styleClass="outputText2" />
                                    <h:outputText styleClass="outputTextBold" value="Estado"/>
                                    <h:outputText styleClass="outputTextBold" value="::"/>
                                    <h:selectOneMenu value="#{ManagedActividadesProduccion.actividadesProduccionEditar.estadoReferencial.codEstadoRegistro}" styleClass="inputText" >
                                        <f:selectItem itemValue="1" itemLabel="Activo"/>
                                        <f:selectItem itemValue="2" itemLabel="No Activo"/>
                                    </h:selectOneMenu>
                                </h:panelGrid>

                            </rich:panel>
                            <br>
                            <a4j:commandButton value="Guardar" onclick="if(!validarRegistroActividadProduccion()){return false}"
                                               action="#{ManagedActividadesProduccion.guardarEdicionActividadProduccion_action}"
                                               oncomplete="if(#{ManagedActividadesProduccion.mensaje eq '1'}){alert('Se guardo la edicion de la actividad de produccion');window.location.href='navegadorActividadesProduccion.jsf?g='+(new Date()).getTime().toString();}else {alert('#{ManagedActividadesProduccion.mensaje}');}" styleClass="btn"/>
                            <a4j:commandButton value="Cancelar" oncomplete="window.location.href='navegadorActividadesProduccion.jsf?cancel='+(new Date()).getTime().toString()" styleClass="btn"/>
                        </div>

                    </a4j:form>
                    <a4j:status id="statusPeticion"
                                onstart="Richfaces.showModalPanel('ajaxLoadingModalBox',{width:100, top:100})"
                                onstop="Richfaces.hideModalPanel('ajaxLoadingModalBox')">
                    </a4j:status>

                    <rich:modalPanel id="ajaxLoadingModalBox" minHeight="100"
                                     minWidth="200" height="80" width="400" zindex="300" onshow="window.focus();">

                        <div align="center">
                            <h:graphicImage value="../img/load2.gif" />
                        </div>
                    </rich:modalPanel>
                    
                </div>        
        </body>
    </html>
    
</f:view>

