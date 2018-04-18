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
            
        </head>
        <body>
            
            <h:form id="form1"  >                
                <div align="center">                    
                    
                    <h:outputText value="#{ManagedComponentesProdVersion.cargarPresentacionesPrimariasVersion}"   />
                    <h3>Presentaciones Primarias</h3>
                    <rich:panel headerClass="headerClassACliente" style="width:50%">
                        <f:facet name="header">
                            <h:outputText value="Datos Generales"/>
                        </f:facet>
                        <h:panelGrid columns="3">
                            <h:outputText value="Nro Versión" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:outputText value="#{ManagedComponentesProdVersion.componentesProdVersionBean.nroVersion}" styleClass="outputText2"/>
                            <h:outputText value="Nombre Producto" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:outputText value="#{ManagedComponentesProdVersion.componentesProdVersionBean.nombreProdSemiterminado}" styleClass="outputText2"/>
                            <h:outputText value="Nombre Comercial" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:outputText value="#{ManagedComponentesProdVersion.componentesProdVersionBean.producto.nombreProducto}" styleClass="outputText2"/>
                        </h:panelGrid>
                        
                    </rich:panel>
                    <rich:dataTable value="#{ManagedComponentesProdVersion.presentacionesPrimariasList}"
                                    var="data" id="dataPresentacionesPrimariasVersion"
                                    style="margin-top:1em"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#F3F7FD';" 
                                    headerClass="headerClassACliente"
                                    columnClasses="tituloCampo">
                            
                                <f:facet name="header">
                                    <rich:columnGroup>
                                            <rich:column >
                                                <h:outputText value="" escape="false"/>
                                            </rich:column>
                                            <rich:column >
                                                <h:outputText value="Envase<br>Primario" escape="false"/>
                                            </rich:column>
                                            <rich:column >
                                                <h:outputText value="Cantidad" escape="false"/>
                                            </rich:column>
                                            <rich:column >
                                                <h:outputText value="Tipo Programa<br>Produccion" escape="false"/>
                                            </rich:column>
                                            <rich:column >
                                                <h:outputText value="Estado" escape="false"/>
                                            </rich:column>
                                            
                                    </rich:columnGroup>
                                </f:facet>
                                        <rich:column>
                                            <h:selectBooleanCheckbox value="#{data.checked}"/>
                                        </rich:column>
                                        <rich:column>
                                            <h:outputText value="#{data.envasesPrimarios.nombreEnvasePrim}"/>
                                        </rich:column>
                                        <rich:column>
                                            <h:outputText value="#{data.cantidad}"/>
                                        </rich:column>
                                        <rich:column>
                                            <h:outputText value="#{data.tiposProgramaProduccion.nombreTipoProgramaProd}"/>
                                        </rich:column>
                                        <rich:column>
                                            <h:outputText value="#{data.estadoReferencial.nombreEstadoRegistro}"/>
                                        </rich:column>
                    </rich:dataTable>
                    <br>
                        <a4j:commandButton action="#{ManagedComponentesProdVersion.agregarPresentacionPrimaria_action}" oncomplete="window.location.href='agregarPresentacionPrimariaVersion.jsf?data='+(new Date()).getTime().toString();" styleClass="btn" value="Agregar"/>
                        <a4j:commandButton action="#{ManagedComponentesProdVersion.editarPresentacionPrimaria_action}" oncomplete="window.location.href='editarPresentacionPrimariaVersion.jsf?data='+(new Date()).getTime().toString();" styleClass="btn" value="Editar"/>
                        <a4j:commandButton action="#{ManagedComponentesProdVersion.eliminarPresentacionPrimaria_action}" oncomplete="if(#{ManagedComponentesProdVersion.mensaje eq '1'}){alert('Se elimino la presentacion primaria de la version')}else{alert('#{ManagedComponentesProdVersion.mensaje}');}"
                        reRender="dataPresentacionesPrimariasVersion" styleClass="btn" value="Eliminar"/>
                        <a4j:commandButton styleClass="btn" oncomplete="window.location.href='../#{ManagedComponentesProdVersion.componentesProdVersionBean.codCompprod>0?'navegadorComponentesProdVersion':'navegadorNuevosComponentesProd'}.jsf?cancel='+(new Date()).getTime().toString();" value="Cancelar"/>
                    
                </div>
                <!--cerrando la conexion-->
               
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

