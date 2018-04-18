<%@taglib prefix="h" uri="http://java.sun.com/jsf/html" %>
<%@taglib prefix="f" uri="http://java.sun.com/jsf/core" %>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j" %>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>

    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
            <script type="text/javascript" src="../../js/general.js" ></script>
        </head>
            <a4j:form id="form1">
                <div align="center">
                    <h:outputText value="#{ManagedMaquinariaRecetaEspecificacion.cargarAgregarMaquinariaRecetaEspecificacionProceso}"/>
                    <h:outputText styleClass="outputTextTituloSistema"   value="Especificaciones por proceso y Maquinaria" />
                    <br/>
                        <rich:panel headerClass="headerClassACliente" style="width:50%">
                            <f:facet name="header">
                                <h:outputText value="Datos de la Maquina"/>
                            </f:facet>
                            <h:panelGrid columns="3" headerClass="headerClassACliente">
                                <h:outputText value="Maquinaria" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value=":" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="#{ManagedMaquinariaRecetaEspecificacion.maquinariaBean.nombreMaquina} " styleClass="outputText2"/>
                                <h:outputText value="Código" styleClass="outputTextBold"/>
                                <h:outputText value=":" styleClass="outputTextBold"/>
                                <h:outputText value="#{ManagedMaquinariaRecetaEspecificacion.maquinariaBean.codigo}" styleClass="outputText2"/>
                                <h:outputText value="Código" styleClass="outputTextBold"/>
                                <h:outputText value=":" styleClass="outputTextBold"/>
                                <h:outputText value="#{ManagedMaquinariaRecetaEspecificacion.maquinariaBean.codigo}" styleClass="outputText2"/>
                            </h:panelGrid>
                        </rich:panel>
                    
                    <rich:dataTable value="#{ManagedMaquinariaRecetaEspecificacion.maquinariaRecetaDetalleEspecificacionProcesosAgregarList}"
                                            var="data" id="dataEspecificaciones" 
                                            headerClass="headerClassACliente"  style="margin-top:1em !important">
                        <f:facet name="header">
                            <rich:columnGroup>
                                <rich:column>
                                    <h:outputText value=""/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText escape="false" value="Nombre Especificación<br><input type='text' onkeyup='buscarCeldaAgregar(this,1)' class='inputText'>"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Tipo Descripción"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Unidad Medida"/>
                                </rich:column>
                            </rich:columnGroup>
                        </f:facet>
                            <rich:columnGroup>
                                <rich:column>
                                    <h:selectBooleanCheckbox value="#{data.checked}" onclick="seleccionarRegistro(this)"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="#{data.especificacionProceso.nombreEspecificacionProceso}"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="#{data.especificacionProceso.tiposDescripcion.nombreTipoDescripcion}"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="#{data.especificacionProceso.unidadMedida.nombreUnidadMedida}"/>
                                </rich:column>
                            </rich:columnGroup>
                        </rich:dataTable>
                    <div id="bottonesAcccion" class="barraBotones">
                        <a4j:commandButton value="Guardar" styleClass="btn" action="#{ManagedMaquinariaRecetaEspecificacion.guardarAgregarMaquinariaRecetaEspecificacionProceso_action}"
                                               onclick="if(!alMenosUno('form1:dataEspecificaciones')){return false;}"
                                               oncomplete="if(#{ManagedMaquinariaRecetaEspecificacion.mensaje eq '1'}){alert('La información se guardo de forma correcta');window.location.href='navegadorMaquinariaRecetaEspecificacion.jsf?save='+(new Date()).getTime().toString();}
                                               else{alert('#{ManagedMaquinariaRecetaEspecificacion.mensaje}');}"/>
                            <a4j:commandButton value="Cancelar"  styleClass="btn" oncomplete="window.location.href='navegadorMaquinariaRecetaEspecificacion.jsf?save='+(new Date()).getTime().toString()"/>
                         </div>   
                         
                </div>

               
              
            </a4j:form>

             
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
    </html>

</f:view>

