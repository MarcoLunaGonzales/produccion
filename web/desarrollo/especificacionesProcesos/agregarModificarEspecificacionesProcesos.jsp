<%@taglib prefix="h" uri="http://java.sun.com/jsf/html" %>
<%@taglib prefix="f" uri="http://java.sun.com/jsf/core" %>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j" %>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>

    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
            <link rel="STYLESHEET" type="text/css" href="../../css/icons.css" />
            <script type="text/javascript" src="../../js/general.js" ></script>
            <script type="text/javascript">
                function retornarNavegador(codVersionCp)
                {
                    window.location.href=(codVersionCp>0?'../navegadorComponentesProdVersion.jsf':'../navegadorNuevosComponentesProd.jsf')+"?data="+(new Date()).getTime().toString();
                }
            </script>
        </head>
        <body >
            <a4j:form id="form1">
                <div align="center">
                    <h:outputText value="#{ManagedProductosDesarrolloVersion.cargarAgregarModificarProcesoOmEspecificacion}"/>
                    <h:outputText styleClass="outputText2" style="font-size:13;font-weight:bold"  value="Especificaciones por proceso y Maquinaria" />
                    <br/>
                        <rich:panel headerClass="headerClassACliente" style="width:50%">
                            <f:facet name="header">
                                <h:outputText value="Datos del Producto"/>

                            </f:facet>
                            <h:panelGrid columns="3" headerClass="headerClassACliente" >
                                <h:outputText value="Producto" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value=":" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="#{ManagedProductosDesarrolloVersion.componentesProdVersionSeleccionado.nombreProdSemiterminado} " styleClass="outputText2"/>
                                <h:outputText value="Forma farmaceútica" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value=":" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="#{ManagedProductosDesarrolloVersion.componentesProdVersionSeleccionado.forma.nombreForma} " styleClass="outputText2"/>
                                <h:outputText value="Proceso" styleClass="outputTextBold"  />
                                <h:outputText value="::" styleClass="outputTextBold" />
                                <h:outputText value="#{ManagedProductosDesarrolloVersion.componentesProdVersionEspecificacionProceso.procesosOrdenManufactura.nombreProcesoOrdenManufactura}"
                                              rendered="#{ManagedProductosDesarrolloVersion.componentesProdVersionEspecificacionProceso.procesosOrdenManufactura.nombreProcesoOrdenManufactura ne ''}"
                                              styleClass="outputText2" />
                                <h:panelGroup rendered="#{ManagedProductosDesarrolloVersion.componentesProdVersionEspecificacionProceso.procesosOrdenManufactura.nombreProcesoOrdenManufactura eq ''}">
                                    <h:selectOneMenu required="#{(not empty param['form1:btnGuardar'])}" id="codProcesosOrdenManufactura" requiredMessage="Debe Seleccionar una opción" validatorMessage="Debe Seleccionar una opción"
                                            value="#{ManagedProductosDesarrolloVersion.componentesProdVersionEspecificacionProceso.procesosOrdenManufactura.codProcesoOrdenManufactura}" >
                                            <f:selectItem itemLabel="--Seleccione una opción--" itemValue='null' itemDisabled="true"/>
                                            <f:selectItems value="#{ManagedProductosDesarrolloVersion.procesosOrdenManufacturaSelectList}"/>
                                    </h:selectOneMenu>
                                    <h:message for="codProcesosOrdenManufactura" styleClass="message"/>
                                </h:panelGroup>
                            </h:panelGrid>
                        </rich:panel>
                    
                    <rich:dataTable value="#{ManagedProductosDesarrolloVersion.componentesProdVersionEspecificacionProceso.procesosOrdenManufactura.componentesProdVersionEspecificacionProcesoList}"
                                            var="data" id="dataEspecificaciones" 
                                            onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                            onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                            headerClass="headerClassACliente"  style="margin-top:1em !important">
                        <f:facet name="header">
                            <rich:columnGroup>
                                <rich:column>
                                    <h:outputText value=""/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Nombre Especificación<br><input type='text' onkeyup='buscarCeldaAgregar(this,1)' class='inputText'>" escape="false"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Tipo Descripción"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Descripción"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Unidad Medida"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Tolerancia<br>(%)" escape="false"/>
                                </rich:column>
                            </rich:columnGroup>
                        </f:facet>
                                <rich:column>
                                    <h:selectBooleanCheckbox value="#{data.checked}">
                                    </h:selectBooleanCheckbox>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="#{data.especificacionesProcesos.nombreEspecificacionProceso}"/>
                                </rich:column>
                                <rich:column >
                                    <h:selectOneMenu value="#{data.tiposDescripcion.codTipoDescripcion}" styleClass="inputText">
                                            <f:selectItems value="#{ManagedProductosDesarrolloVersion.tiposDescripcionSelectList}"/>
                                            <a4j:support event="onchange" reRender="dataEspecificaciones">
                                            </a4j:support>
                                    </h:selectOneMenu>
                                </rich:column>
                                <rich:column >
                                        <h:inputText id="valorExacto" converterMessage="Debe ingresar un numero" validatorMessage="Debe registrar un numero mayor a 0" value="#{data.valorExacto}" rendered="#{data.tiposDescripcion.codTipoDescripcion>2}" styleClass="inputText">
                                            
                                        </h:inputText>
                                        <h:inputText id="valorTexto" required="true" requiredMessage="Debe registrar un valor" validatorMessage="Debe registrar un valor"
                                                     value="#{data.valorTexto}" rendered="#{data.tiposDescripcion.codTipoDescripcion eq 1}" styleClass="inputText">
                                            
                                        </h:inputText>
                                        <h:inputText value="#{data.valorMinimo}" style="width:6em" rendered="#{data.tiposDescripcion.codTipoDescripcion eq 2}" styleClass="inputText"/>
                                        <h:outputText value="-" rendered="#{data.tiposDescripcion.codTipoDescripcion eq 2}" styleClass="outputText2"/>
                                        <h:inputText value="#{data.valorMaximo}" style="width:6em" rendered="#{data.tiposDescripcion.codTipoDescripcion eq 2}" styleClass="inputText"/>
                                        <h:message styleClass="message" for="valorExacto"/>
                                    
                                </rich:column>
                                <rich:column>
                                    <h:selectOneMenu  value="#{data.unidadesMedida.codUnidadMedida}" styleClass="inputText">
                                        <f:selectItems value="#{ManagedProductosDesarrolloVersion.unidadesMedidaSelectList}"/>
                                    </h:selectOneMenu>
                                    
                                </rich:column>
                                <rich:column>
                                    <h:inputText value="#{data.porcientoTolerancia}" styleClass="inputText"/>
                                </rich:column>
                        </rich:dataTable>
                        <div style='margin-top:1em'>
                            <a4j:commandButton reRender="form1" value="Guardar" id="btnGuardar" styleClass="btn" action="#{ManagedProductosDesarrolloVersion.guardarModificarEspecificacionesProcesosAction}"
                                               oncomplete="if('#{facesContext.maximumSeverity}'.length==0)mostrarMensajeTransaccionEvento(function(){redireccionar('navegadorEspecificacionesProcesos.jsf')})"
                                               />
                            <a4j:commandButton value="Cancelar"  styleClass="btn" oncomplete="window.location.href='navegadorEspecificacionesProcesos.jsf?save='+(new Date()).getTime().toString()"/>
                         </div>   
                         
                </div>

               
              
            </a4j:form>

             
             <a4j:include viewId="/panelProgreso.jsp"/>
            <a4j:include viewId="/message.jsp"/>
        </body>
    </html>

</f:view>

