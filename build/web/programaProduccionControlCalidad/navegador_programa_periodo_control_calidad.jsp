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
            <style  type="text/css">
                .a{
                background-color : #F2F5A9;
                }
                .b{
                background-color : #ffffff;
                }
                .columns{
                border:0px solid red;
                }
                .simpleTogglePanel{
                text-align:center;
                }
                .ventasdetalle{
                font-size: 13px;
                font-family: Verdana;
                }
                .preciosaprobados{
                background-color:#33CCFF;
                }
                .enviado{
                background-color:#FFFFCC;
                }
                .pasados{
                background-color:#ADD797;
                }
                .pendiente{
                background-color : #ADD797;
                }
                .leyendaColorAnulado{
                background-color: #FF6666;
                }                
            </style>
           
        </head>
      
        <body>
            <a4j:form id="form1" onreset="alert('hola')"  oncomplete="Richfaces.showModalPanel('panelTipoSalidaAlmacenProduccion');" >
                <rich:panel id="panelEstadoCuentas" styleClass="panelBuscar" style="top:50px;left:50px;width:700px;">
                    <f:facet name="header">
                        <h:outputText value="<div   onmouseover=\"this.style.cursor='move'\" onmousedown=\"comienzoMovimiento(event, 'form1:panelEstadoCuentas');\"  >Buscar<div   style=\"margin-left:550px;\"   onclick=\"document.getElementById('form1:panelEstadoCuentas').style.visibility='hidden';document.getElementById('panelsuper').style.visibility='hidden';\" onmouseover=\"this.style.cursor='hand'\"   >Cerrar</div> </div> "
                              escape="false" />
                    </f:facet>
                </rich:panel>
                
                <div align="center">
                        <h:outputText value="#{ManagedProgramaProduccionControlCalidad.cargarContenidoProgramaProduccionPeriodo}"  />
                        <h:outputText styleClass="outputText2"  value="Programas de Estabilidad" style="font-weight:bold;font-size:14px;" />
                        <h:panelGroup id="contenidoProgramaProduccion" style="margin-top:12px;">
                            <rich:dataTable value="#{ManagedProgramaProduccionControlCalidad.programaProduccionPeriodoList}" var="data"  id="dataProgramaProduccion"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente" binding="#{ManagedProgramaProduccionControlCalidad.programaProduccionPeriodoDataTable}"
                                    style="width=70%;margin-top:12px;"
                                    >
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value=""  />
                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.checked}"   />
                        </rich:column>
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Programa Estabilidad"  />
                            </f:facet>
                            <a4j:commandLink action="#{ManagedProgramaProduccionControlCalidad.ingresarProgramaProduccion_action}"
                            oncomplete="window.location='navegador_programa_produccion_control_calidad.jsf'">
                                <h:outputText styleClass="outputText2" value="#{data.nombreProgramaProduccion}" />
                            </a4j:commandLink>
                        </rich:column>
                        <rich:column  >
                            <f:facet name="header">
                                <h:outputText value="Fecha Inicio"  />
                            </f:facet>
                            <h:outputText value="#{data.fechaInicio}"  >
                                <f:convertDateTime pattern="dd/MM/yyyy" />
                            </h:outputText>
                        </rich:column>
                        <rich:column  >
                            <f:facet name="header">
                                <h:outputText value="Observacion"  />
                            </f:facet>
                            <h:outputText value="#{data.obsProgramaProduccion}"  />
                        </rich:column>
                        <rich:column  >
                            <f:facet name="header">
                                <h:outputText value="Estado"  />
                            </f:facet>
                            <h:outputText value="#{data.estadoProgramaProduccion.nombreEstadoProgramaProd}"  />
                        </rich:column>
                                                

                    </rich:dataTable>
                    </h:panelGroup>
                    
                    <br/>
                    <a4j:commandButton value="Agregar" styleClass="btn" onclick="location='agregar_programa_produccion_control_calidad_periodo.jsf'" />
                    <a4j:commandButton value="Editar" styleClass="btn" action="#{ManagedProgramaProduccionControlCalidad.editarProgramaPeriodoControlCalidad_action}"
                    oncomplete="window.location.href='editar_programa_produccion_control_calidad_periodo.jsf'"/>
                    <a4j:commandButton value="Eliminar" styleClass="btn" onclick="if(confirm('Esta seguro de eliminar el programa de produccion?')==false){return false;}"
                    reRender="dataProgramaProduccion" action="#{ManagedProgramaProduccionControlCalidad.eliminarProgramaProduccionPeriodo_action}"
                    oncomplete="alert('Se elimino el programa de produccion ')"/>
                </div>
                 

            </a4j:form>
            
            
            <rich:modalPanel id="panelBuscarLoteProduccion"  minHeight="120"  minWidth="300"
                                     height="120" width="300"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value=" Buscar Lote de Produccion "/>
                        </f:facet>
                        <a4j:form>
                        <h:panelGroup id="contenidoBuscarLoteProduccion">
                            <div align="center">
                            <h:panelGrid columns="2">
                                <h:outputText value="Lote :" styleClass="outputText1" />
                                <h:inputText value="#{ManagedProgramaProduccion.programaProduccionBuscar.codLoteProduccion}" styleClass="inputText2" />

                            </h:panelGrid>
                                

                                 <a4j:commandButton value="Aceptar" onclick = "location ='navegador_seguimiento_programa_produccion.jsf'" styleClass="btn"/>
                                 <input value="Cancelar" onclick="Richfaces.hideModalPanel('panelBuscarLoteProduccion')" class="btn" type="button" />


                                </div>
                        </h:panelGroup>
                        </a4j:form>
            </rich:modalPanel>

        </body>
    </html>
    
</f:view>

