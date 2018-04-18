<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>

<rich:modalPanel id="panelModificacionFraccionesFormulaMaestraDetalleMp"
                minHeight="380"  minWidth="700"
                height="380" width="700" zindex="30"
                headerClass="headerClassACliente"
                resizeable="false">
    <f:facet name="header">
       <h:outputText value="<center>Modificar Fracciones Materia Prima</center>" escape="false" />
    </f:facet>
    <a4j:form id="formEditarFracciones">
       <center>
        <h:panelGroup id="contenidoModificacionFraccionesFormulaMaestraDetalleMp">
            <rich:panel headerClass="headerClassACliente">
                <h:panelGrid columns="3">
                   <h:outputText value="Material" styleClass="outputTextBold"/>
                   <h:outputText value="::" styleClass="outputTextBold"/>
                   <h:outputText value="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleMpEditarFraccion.materiales.nombreMaterial}" styleClass="outputText2"/>
                   <h:outputText value="Cantidad Total(g)" styleClass="outputTextBold"/>
                   <h:outputText value="::" styleClass="outputTextBold"/>
                   <h:outputText id="cantidadTotal" value="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleMpEditarFraccion.cantidadTotalGramos}" styleClass="outputText2">
                       <f:convertNumber pattern="###0.00" locale="en"/>
                   </h:outputText>
                   
                </h:panelGrid>
            </rich:panel>
           <div style="margin-top:1em;height:160px; overflow-y:auto; overflow-x: hidden">
               <rich:dataTable value="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleMpEditarFraccion.formulaMaestraDetalleMPfraccionesList}"
                                var="data" id="dataMPfraccion" rowKeyVar="var"
                                headerClass="headerClassACliente"
                                onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                onRowMouseOver="this.style.backgroundColor='#DDE3E4';">
                        <f:facet name="header">
                            <rich:columnGroup>
                                
                                <rich:column >
                                    <h:outputText value="Nro<Br/> Fracción" escape="false"/>
                                </rich:column>
                                <rich:column >
                                    <h:outputText value="Cantidad<Br/>Material<br>fracción" escape="false"/>
                                </rich:column>
                                <rich:column >
                                    <h:outputText value="Eliminar<BR/>Fracción" escape="false"/>
                                </rich:column>
                            </rich:columnGroup>
                        </f:facet>
                            <rich:column >
                                <h:outputText value="#{var+1}"/>
                            </rich:column>
                            <rich:column >    
                                <h:inputText value="#{data.cantidad}" onkeypress="valNum(event);" onblur="valorPorDefecto(this)" styleClass="inputText">
                                    <f:convertNumber pattern="####0.00" locale="en"/>
                                </h:inputText>
                            </rich:column>
                            <rich:column>
                                <a4j:commandLink action="#{ManagedProgramaProduccionDesviacion.eliminarFraccionDesviacionFormulaMaestraDetalleMp_action}"
                                        reRender="dataMPfraccion" >
                                    <h:graphicImage url="../../img/menos.png"/>
                                    <f:setPropertyActionListener target="#{ManagedProgramaProduccionDesviacion.desviacionFormulaMaestraDetalleMpFraccionesEliminar}"
                                                                                                 value="#{data}"/>
                                </a4j:commandLink>
                            </rich:column>
                    </rich:dataTable>
                </div>
                <center>
                    <a4j:commandLink action="#{ManagedProgramaProduccionDesviacion.agregarFraccionDesviacionFormulaMaestraDetalleMp_action}" reRender="contenidoModificacionFraccionesFormulaMaestraDetalleMp" >
                        <h:graphicImage url="../../img/mas.png"/>
                    </a4j:commandLink>
                </center>
       </h:panelGroup>
       <a4j:commandButton value="Aceptar" action="#{ManagedProgramaProduccionDesviacion.completarEditarFraccionesFormulaMaestraDetalleMp_action}" 
                          onclick="if(!validarCantidadesFraccion()){return false;}"
                          oncomplete="Richfaces.hideModalPanel('panelModificacionFraccionesFormulaMaestraDetalleMp');" styleClass="btn" reRender="panelMp"/>
       </center>
   </a4j:form>
</rich:modalPanel>


