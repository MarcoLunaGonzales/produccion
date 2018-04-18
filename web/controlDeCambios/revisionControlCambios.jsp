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
            </style>
        </head>
        <body >
            <a4j:form id="form1">
                <div align="center">
                    <h:outputText value="#{ManagedRegistroControlDeCambios.cargarRevisionRegistroControlCambios}"/>
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
                            <h:outputText value="#{ManagedRegistroControlDeCambios.componentesProdSeleccionado.nombreProdSemiterminado}" styleClass="outputText2" />
                            <h:outputText value="Forma Farmaceútica" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="#{ManagedRegistroControlDeCambios.componentesProdSeleccionado.forma.nombreForma}" styleClass="outputText2" />
                            
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
                            <h:outputText value="#{ManagedRegistroControlDeCambios.registroControlCambiosSeleccionado.coorelativo}" styleClass="outputText2" />
                            
                        </h:panelGrid>
                        <h:panelGrid columns="3" style="width:75%">
                           
                            <h:outputText value="Cambio Propuesto" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <h:inputTextarea value="#{ManagedRegistroControlDeCambios.registroControlCambiosSeleccionado.cambioPropuesto}" styleClass="inputText" style="width:60em" rows="3"/>
                            <h:outputText value="Proposito del cambio" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <h:inputTextarea value="#{ManagedRegistroControlDeCambios.registroControlCambiosSeleccionado.propositoCambio}" styleClass="inputText" style="width:60em" rows="2"/>
                        </h:panelGrid>
                    </rich:panel>
                    <rich:panel style="width:70%;margin-top:12px; " headerClass="headerClassACliente">
                        <f:facet name="header">
                            <h:outputText value="2. Información diligenciada por Comité Técnico"/>
                        </f:facet>
                        <h:panelGrid columns="3" style="width:75%">
                            <h:outputText value="Clasificación del cambio" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <h:selectOneRadio value="#{ManagedRegistroControlDeCambios.registroControlCambiosSeleccionado.clasificacionCambio}" styleClass="outputText2">
                                <f:selectItem itemValue="M" itemLabel="M"/>
                                <f:selectItem itemValue="m" itemLabel="m"/>
                            </h:selectOneRadio>
                            <h:outputText value="Amerita el cambio" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <h:selectOneRadio value="#{ManagedRegistroControlDeCambios.registroControlCambiosSeleccionado.ameritaCambio}" styleClass="outputText2">
                                <f:selectItem itemValue="true" itemLabel="SI"/>
                                <f:selectItem itemValue="false" itemLabel="NO"/>
                            </h:selectOneRadio>
                            <h:outputText value="Tipo de Cambio" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <h:selectOneRadio value="#{ManagedRegistroControlDeCambios.registroControlCambiosSeleccionado.cambioDefinitivo}" styleClass="outputText2">
                                <f:selectItem itemValue="false" itemLabel="Cambio Provisional"/>
                                <f:selectItem itemValue="true" itemLabel="Cambio Definitivo"/>
                            </h:selectOneRadio>
                        </h:panelGrid>
                    </rich:panel>
                    <rich:dataTable value="#{ManagedRegistroControlDeCambios.registroControlCambiosDetalleRevisarList}"
                                        var="data" style="width:70%;margin-top:12px;"
                                        id="dataOOSInvestigacion"
                                        onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                        onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                        headerClass="headerClassACliente" >
                            <f:facet name="header">
                                <rich:columnGroup>
                                    <rich:column >
                                        <h:outputText value="Requerimiento"  />
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Aplica"  />
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Actividad"  />
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Responsable"  />
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Fecha<br>Limite" escape="false"  />
                                    </rich:column>
                                </rich:columnGroup>
                            </f:facet>
                            <rich:column>
                                <h:outputText  value="#{data.especificacionesControlCambios.nombreEspecificacionControlCambios}"  />
                            </rich:column>
                            <rich:column style="aling:center">
                                 <center>
                                 <h:selectBooleanCheckbox value="#{data.aplica}"/>
                                 </center>
                            </rich:column>
                            <rich:column>
                                <h:inputTextarea value="#{data.actividad}" style="width:23em" styleClass="inputText"/>
                            </rich:column>
                             <rich:column>
                                 <h:selectOneMenu value="#{data.personalResponsable.codPersonal}" style="width:20em !important" styleClass="inputText">
                                     <f:selectItems value="#{ManagedRegistroControlDeCambios.personalRegistroSelect}"/>
                                 </h:selectOneMenu>
                             </rich:column>
                             <rich:column >
                                 <rich:calendar value="#{data.fechaLimite}" inputClass="inputFecha" datePattern="dd/MM/yyyy"/>
                             </rich:column>

                        </rich:dataTable>
                    


                    <br>
                        <a4j:commandButton value="Guardar" styleClass="btn" action="#{ManagedRegistroControlDeCambios.guardarRevisionControlCambios_action}"
                        oncomplete="if(#{ManagedRegistroControlDeCambios.mensaje eq '1'}){alert('Se guardo la revision del Control de Cambios');var a=Math.random();window.location.href='navagadorControlesCambio.jsf?a='+a;}
                        else{alert('#{ManagedRegistroControlDeCambios.mensaje}');}" timeout="7200"

                        />
                        <a4j:commandButton value="Cancelar" styleClass="btn" oncomplete="var a=Math.random();window.location.href='navagadorControlesCambio.jsf?a='+a;"/>
                        
                   
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

