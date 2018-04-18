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
            <script>
             function valBuscador()
            {
                if(document.getElementById("form11:codProgramprod").value==0 && document.getElementById("form11:loteProduccion").value=='')
                    {
                        alert("Para buscar en todos los programas de produccion debe introducir un indicio del lote");
                        return false;
                    }
                    return true;
            }

            </script>
        </head>
        
        <body >
            <a4j:form id="form1">
                <div align="center">
                    <h:outputText value="#{ManagedProgramaProduccionControlCalidad.cargarEdicionLoteProgramaProduccion}"/>
                    
                    <rich:panel headerClass="headerClassACliente" style="width:50%;align:center">
                            <f:facet name="header">
                                    <h:outputText value="Programa Produccion"/>
                            </f:facet>
                            <h:panelGrid columns="3">
                                <h:outputText value="Nombre Programa" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="#{ManagedProgramaProduccionControlCalidad.programaProduccionPeriodoSeleccionado.nombreProgramaProduccion}"
                                styleClass="outputText2" style=""/>
                                <h:outputText value="Observacion Programa" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="#{ManagedProgramaProduccionControlCalidad.programaProduccionPeriodoSeleccionado.obsProgramaProduccion}"
                                styleClass="outputText2" />
                            </h:panelGrid>
                    </rich:panel>

                    <rich:dataTable value="#{ManagedProgramaProduccionControlCalidad.programaProduccionEditarList}" var="data" id="dataLotes"
                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" style="margin-top:12px;"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';" 
                                    headerClass="headerClassACliente" >
                                        <rich:column>
                                            <f:facet name="header">
                                                <h:outputText value="Nombre Producto"/>
                                            </f:facet>
                                            <h:outputText value="#{data.componentesProd.nombreProdSemiterminado}" styleClass="outputText2"/>

                                        </rich:column >
                                         <rich:column  >
                                            <f:facet name="header">
                                                <h:outputText value="Tiempo de Estudio(meses)"/>
                                            </f:facet>
                                            <h:inputText value="#{data.tiempoEstudio}" styleClass="inputText" >
                                                <f:convertNumber pattern="##" locale="en"/>
                                            </h:inputText>

                                        </rich:column >
                                          <rich:column  >
                                            <f:facet name="header">
                                                <h:outputText value="Producto"/>
                                            </f:facet>
                                            <h:inputText value="#{data.producto}" styleClass="inputText"/>

                                        </rich:column >
                                          <rich:column  >
                                            <f:facet name="header">
                                                <h:outputText value="Cantidad de Muestras"/>
                                            </f:facet>
                                            <h:inputText value="#{data.cantidadMuestras}" styleClass="inputText" >
                                                <f:convertNumber pattern="##" locale="en"/>
                                                </h:inputText>

                                        </rich:column >
                                          <rich:column  >
                                            <f:facet name="header">
                                                <h:outputText value="Tipo Programa"/>
                                            </f:facet>
                                            <h:selectOneMenu value="#{data.tiposProgramaProduccion.codTipoProgramaProd}" styleClass="inputText" disabled="true" >
                                                <f:selectItems value="#{ManagedProgramaProduccionControlCalidad.tiposProgramaProdList}"/>
                                            </h:selectOneMenu>

                                        </rich:column >
                                        <rich:column  >
                                            <f:facet name="header">
                                                <h:outputText value="Tipo Material Reactivo"/>
                                            </f:facet>
                                            <h:selectOneMenu value="#{data.tiposMaterialReactivo.codTipoMaterialReactivo}" styleClass="inputText" >
                                                <f:selectItems value="#{ManagedProgramaProduccionControlCalidad.tiposMaterialReactivoList}"/>
                                            </h:selectOneMenu>

                                        </rich:column >

                                        <rich:column  >
                                            <f:facet name="header">
                                                <h:outputText value="Test Disolucion"/>
                                            </f:facet>
                                            <h:selectBooleanCheckbox value="#{data.disolucion}"/>

                                        </rich:column >
                                        <rich:column  >
                                            <f:facet name="header">
                                                <h:outputText value="Test Valoración"/>
                                            </f:facet>
                                            <h:selectBooleanCheckbox value="#{data.valoracion}"/>

                                        </rich:column >
                                        <rich:column  >
                                            <f:facet name="header">
                                                <h:outputText value="Observación"/>
                                            </f:facet>
                                            <h:inputText value="#{data.observacion}" styleClass="inputText"/>

                                        </rich:column >
                                        <rich:column  >
                                            <f:facet name="header">
                                                <h:outputText value="Editar Materiales" style="font-weight:bold"/>
                                            </f:facet>
                                            <a4j:commandLink  action="#{ManagedProgramaProduccionControlCalidad.cargarMateriales_action}" reRender="contenidoMateriales" oncomplete="Richfaces.showModalPanel('panelMateriales')" >
                                                <h:graphicImage url="../img/organigrama3.jpg"  />
                                            </a4j:commandLink>
                                        </rich:column >
                 
                    </rich:dataTable>
                    <center>
                        <%--a4j:commandLink action="#{ManagedProgramaProduccion.mas_Action}" reRender="dataProgramaProduccionEditar" >
                            <h:graphicImage url="../img/mas.png"/>
                        </a4j:commandLink>
                        <a4j:commandLink action="#{ManagedProgramaProduccion.menos_Action}" reRender="dataProgramaProduccionEditar" >
                            <h:graphicImage url="../img/menos.png"/>
                        </a4j:commandLink--%>
                        </center>
                    <br>
                        <a4j:commandButton value="Guardar"   styleClass="btn"  action="#{ManagedProgramaProduccionControlCalidad.guardarEdicionLotesProgramaProduccionCC_action}" 
                        oncomplete="if(#{ManagedProgramaProduccionControlCalidad.mensaje eq '1'}){alert('Se guardo la edicion de programa de producción');window.location='navegador_programa_produccion_control_calidad.jsf';}
                        else {alert('#{ManagedProgramaProduccionControlCalidad.mensaje}');}"/>
                    
                    <a4j:commandButton value="Cancelar"    styleClass="btn"  onclick="window.location='navegador_programa_produccion_control_calidad.jsf'" />
               
               
                </div>
               
                
            </a4j:form>

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

