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
            <script type="tex/javascript">
                 A4J.AJAX.onError = function(req,status,message){
                window.alert("Ocurrio un error: "+message);
                }
                A4J.AJAX.onExpired = function(loc,expiredMsg){
                if(window.confirm("Ocurrio un error al momento realizar la transaccion: "+expiredMsg+" location: "+loc)){
                return loc;
                } else {
                return false;
                }
                }
            </script>
            <style>
                .inputFecha{
                    width:6em !important;
                    
                }
                .tipoEspecificacion
                {
                    background-color:#eec2ef
                }
            </style>
        </head>
        <body >
            <a4j:form id="form1">
                <div align="center">
                    <h:outputText value="#{ManagedRegistroControlDeCambios.cargarAgregarRegistroControlCambios}"/>
                    <rich:panel style="width:70%;margin-top:12px; " headerClass="headerClassACliente">
                        <f:facet name="header">
                            <h:outputText value="Datos del Producto"/>
                        </f:facet>
                                <table cellpadding="0" cellspacing="0">
                                <tr>
                                    <td rowspan="3">
                                        <h:graphicImage url="../img/cofar.png"/>
                                    </td>
                                    <td align="center"><h:outputText value="ASEGURAMIENTO DE CALIDAD" styleClass="outputText2" style="font-weight:bold"/></td>
                                    <td><h:outputText value="Pagina 12 de 15" styleClass="outputText2" /></td>
                               </tr>
                               <tr>
                                   <td align="center"><h:outputText value="ASC-PO-003/R01" styleClass="outputText2" style="font-weight:bold"/></td>
                                    <td><h:outputText value="Vigencia:01/06/09" styleClass="outputText2" /></td>
                               </tr>
                               <tr>
                                   <td style="padding-left:4em;padding-right:4em"><h:outputText value="REGISTRO DE CONTROL DE CAMBIOS" styleClass="outputText2" style="font-weight:bold"/></td>
                                   <td><h:outputText value="Revisión N° 04" styleClass="outputText2" /></td>

                               </tr>
                              </table>
                            
                    </rich:panel>

                  <rich:panel style="width:70%;margin-top:12px; " headerClass="headerClassACliente">
                      <f:facet name="header">
                            <h:outputText value="1.Información diligenciada por Funcionario"/>
                        </f:facet>
                        <h:panelGrid columns="6">
                            <h:outputText value="Producto" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="#{ManagedRegistroControlDeCambios.registroControlCambios.componentesProd.nombreProdSemiterminado}" styleClass="outputText2" />
                            <h:outputText value="Forma Farmaceútica" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="#{ManagedRegistroControlDeCambios.registroControlCambios.componentesProd.forma.nombreForma}" styleClass="outputText2" />
                            
                            <h:outputText value="Funcionario" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="#{ManagedRegistroControlDeCambios.registroControlCambios.personalRegistra.nombrePersonal}" styleClass="outputText2" />
                            <h:outputText value="Area" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="#{ManagedRegistroControlDeCambios.registroControlCambios.areasEmpresa.nombreAreaEmpresa}" styleClass="outputText2" />
                            <h:outputText value="Fecha" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="#{ManagedRegistroControlDeCambios.registroControlCambios.fechaRegistro}" styleClass="outputText2">
                                <f:convertDateTime pattern="dd/MM/yyyy"/>
                            </h:outputText>
                            <h:outputText value="Coorelativo" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="#{ManagedRegistroControlDeCambios.registroControlCambios.coorelativo}" styleClass="outputText2" />
                            
                        </h:panelGrid>
                        <h:panelGrid columns="3" style="width:75%" >
                           
                            <h:outputText value="Cambio Propuesto" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="Proposito del cambio" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <rich:dataTable style="width:27em" value="#{ManagedRegistroControlDeCambios.registroControlCambios.registroControlCambiosPropositoList}" var="data">
                                <rich:columnGroup rendered="#{!data.checked}">
                                    <rich:column>
                                        <h:outputText value="#{data.personal.nombrePersonal}"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="#{data.propositoCambio}"/>
                                    </rich:column>
                                </rich:columnGroup>
                                <rich:column rendered="#{data.checked}" colspan="2">
                                    <h:inputTextarea style="width:100%" rows="3" styleClass="inputText" value="#{data.propositoCambio}">
                                    </h:inputTextarea>
                                </rich:column>
                                
                            </rich:dataTable>
                            
                        </h:panelGrid>
                    </rich:panel>
                    <rich:dataTable value="#{ManagedRegistroControlDeCambios.tiposEspecificacionesControlCambiosList}"
                                        var="data" style="width:70%;margin-top:12px;"
                                        id="dataControlDeCambios"
                                        onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                        onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                        headerClass="headerClassACliente" >
                            <f:facet name="header">
                                <rich:columnGroup>
                                    <rich:column>
                                        <h:outputText value="Requerimiento"/>
                                    </rich:column>
                                    <rich:column colspan="2">
                                        <h:outputText value="Actividad recomendada"/>
                                    </rich:column>
                                </rich:columnGroup>
                            </f:facet>
                            
                            
                        
                            <rich:subTable value="#{data.especificacionesControlCambiosList}" rowKeyVar="var1"
                                var="subData">
                                <rich:columnGroup styleClass="headerClassACliente tipoEspecificacion" rendered="#{var1 eq 0}">
                                    <rich:column colspan="5" styleClass="textBold"  >
                                        <h:outputText value="<center>#{data.nombreTipoEspecificacionControlCambios}</center>" escape="false"/>
                                    </rich:column>
                                </rich:columnGroup>
                                        <rich:subTable value="#{subData.registroControlCambiosActividadPropuestList}" rowKeyVar="var2"
                                            var="posData">
                                        
                                        <rich:column rowspan="#{subData.registroControlCambiosActividadPropuestListSize}" rendered="#{var2 eq 0}">
                                            <h:outputText value="#{subData.nombreEspecificacionControlCambios}"/>
                                        </rich:column>
                                        <rich:column rendered="#{!posData.checked}">
                                            <h:outputText value="#{posData.personal.nombrePersonal}"/>
                                        </rich:column>
                                        <rich:column rendered="#{!posData.checked}">
                                            <h:outputText value="#{posData.actividadSugerida}"/>
                                        </rich:column>
                                        <rich:column rendered="#{posData.checked}" colspan="2" >
                                            <h:inputTextarea style="width:100%" rows="2" styleClass="inputText" value="#{posData.actividadSugerida}"></h:inputTextarea>
                                        </rich:column>
                                    </rich:subTable>
                            </rich:subTable>
                            
                        </rich:dataTable>
                    


                    <br>
                        <a4j:commandButton value="Guardar" styleClass="btn" action="#{ManagedRegistroControlDeCambios.guardarRegistroControlCambios_action}"
                        oncomplete="if(#{ManagedRegistroControlDeCambios.mensaje eq '1'}){alert('Se registro el Control de Cambios');window.close();}
                        else{alert('#{ManagedRegistroControlDeCambios.mensaje}');}" timeout="70000"/>
                </div>
             </a4j:form>
         

             <a4j:status id="statusPeticion"
                                onstart="Richfaces.showModalPanel('ajaxLoadingModalBox',{width:100, top:100})"
                                onstop="Richfaces.hideModalPanel('ajaxLoadingModalBox')">
                    </a4j:status>

                    <rich:modalPanel id="ajaxLoadingModalBox" minHeight="100"
                                     minWidth="200" height="80" width="400" zindex="500" onshow="window.focus();">

                        <div align="center">
                            <h:graphicImage value="../img/load2.gif" />
                        </div>
                    </rich:modalPanel>
        </body>
        
    </html>

</f:view>

