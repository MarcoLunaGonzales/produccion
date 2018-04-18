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
        </head>
        <body >
            <h:form id="form1">
                <div align="center">
                    <h:outputText value="#{ManagedControlCalidadOS.cargarRegistroOOSLote}"/>
                    <rich:panel style="width:70%;margin-top:12px; " headerClass="headerClassACliente">
                        <f:facet name="header">
                            <h:outputText value="Datos del Lote"/>
                        </f:facet>
                            <h:panelGrid columns="6">
                                <h:outputText value="Programa produccion" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value=":" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="#{ManagedControlCalidadOS.programaProduccionSeleccionado.programaProduccionPeriodo.nombreProgramaProduccion}" styleClass="outputText2" />
                                <h:outputText value="Lote" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value=":" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="#{ManagedControlCalidadOS.programaProduccionSeleccionado.codLoteProduccion}" styleClass="outputText2" />
                                <h:outputText value="Producto" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value=":" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="#{ManagedControlCalidadOS.programaProduccionSeleccionado.formulaMaestra.componentesProd.nombreProdSemiterminado}" styleClass="outputText2" />
                                <h:outputText value="Cant. Lote" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value=":" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="#{ManagedControlCalidadOS.programaProduccionSeleccionado.cantidadLote}" styleClass="outputText2" />
                                <h:outputText value="Tipo Programa Prod" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value=":" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="#{ManagedControlCalidadOS.programaProduccionSeleccionado.tiposProgramaProduccion.nombreProgramaProd}" styleClass="outputText2" />
                                <h:outputText value="Area" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value=":" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="#{ManagedControlCalidadOS.programaProduccionSeleccionado.formulaMaestra.componentesProd.areasEmpresa.nombreAreaEmpresa}" styleClass="outputText2" />
                                <h:outputText value="Estado" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value=":" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="#{ManagedControlCalidadOS.programaProduccionSeleccionado.estadoProgramaProduccion.nombreEstadoProgramaProd}" styleClass="outputText2" />
                                <h:outputText value="Correlativo OOS" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value=":" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="#{ManagedControlCalidadOS.programaProduccionSeleccionado.registroOOS.correlativoOOS}" styleClass="outputText2" />
                                <h:outputText value="Persona Detecta OOS" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value=":" styleClass="outputText2" style="font-weight:bold"/>
                                <h:selectOneMenu value="#{ManagedControlCalidadOS.programaProduccionSeleccionado.registroOOS.personalDetectaOOS.codPersonal}" styleClass="inputText">
                                    <f:selectItems value="#{ManagedControlCalidadOS.personalRegistroSelectList}"/>
                                </h:selectOneMenu>
                                <h:outputText value="Proveedor" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value=":" styleClass="outputText2" style="font-weight:bold"/>
                                <h:inputText value="#{ManagedControlCalidadOS.programaProduccionSeleccionado.registroOOS.proveedor}" styleClass="inputText" />
                                <h:outputText value="Fecha Deteccion OOS" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value=":" styleClass="outputText2" style="font-weight:bold"/>
                                <rich:calendar value="#{ManagedControlCalidadOS.programaProduccionSeleccionado.registroOOS.fechaDeteccion}" datePattern="dd/MM/yyyy" styleClass="inputText"/>
                                <h:outputText value="Fecha Envio Asc" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value=":" styleClass="outputText2" style="font-weight:bold"/>
                                <rich:calendar value="#{ManagedControlCalidadOS.programaProduccionSeleccionado.registroOOS.fechaEnvioAsc}" datePattern="dd/MM/yyyy" styleClass="inputText"/>
                            </h:panelGrid>
                    </rich:panel>

                  <rich:panel style="width:70%;margin-top:12px; " headerClass="headerClassACliente">
                      <f:facet name="header">
                            <h:outputText value="INVESTIGACION DEL RESULTADO FUERA DE LA ESPECIFICACION (OOS)"/>
                        </f:facet>
                        <rich:dataTable value="#{ManagedControlCalidadOS.especificacionesOosInvestigacion}"
                                        var="data" style="width:95%"
                                        id="dataOOSInvestigacion"
                                        onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                        onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                        headerClass="headerClassACliente" >
                            <f:facet name="header">
                                <rich:columnGroup>
                                    <rich:column>
                                        <h:outputText value="Especificacion"  />
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Resultado"  />
                                    </rich:column>
                                </rich:columnGroup>
                            </f:facet>
                            <rich:column>
                                <h:outputText  value="#{data.nombreEspecificacionOos}"  />
                            </rich:column>
                            <rich:column style="width:65%">
                                <h:inputTextarea styleClass="inputText" rendered="#{data.subEspecificacionesOOSList == null}" value="#{data.descripcionEspecificacion}" style="width:100%" ></h:inputTextarea>
                            </rich:column>
                             <rich:subTable value="#{data.subEspecificacionesOOSList}" rendered="#{data.subEspecificacionesOOSList != null}" var="subData">
                                        <rich:column>
                                            <h:outputText  style="margin-left:1em;" value="#{subData.nombreSubEspecificacionesOOS}"  />
                                        </rich:column>
                                        <rich:column style='width:65%'>
                                            <h:inputTextarea styleClass="inputText" value="#{subData.descripcionEspecificaciones}"  style="width:100%"></h:inputTextarea>
                                        </rich:column>
                            </rich:subTable>

                        </rich:dataTable>
                    </rich:panel>
                    <rich:panel style="width:70%;margin-top:12px; " headerClass="headerClassACliente">
                      <f:facet name="header">
                            <h:outputText value="EVALUACION PRELIMINAR"/>
                        </f:facet>
                            <rich:dataTable value="#{ManagedControlCalidadOS.especificacionesOosEvaluacion}"
                                            var="data" style='width:95%'
                                            id="dataOOSEvaluacion"
                                            onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                            onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                            headerClass="headerClassACliente" >
                                <f:facet name="header">
                                    <rich:columnGroup>
                                        <rich:column>
                                            <h:outputText value="Especificacion"  />
                                        </rich:column>
                                        <rich:column colspan="2">
                                            <h:outputText value="Resultado"  />
                                        </rich:column>
                                    </rich:columnGroup>
                                </f:facet>
                                <rich:column>
                                    <h:outputText  value="#{data.nombreEspecificacionOos}"  />
                                </rich:column>
                                <rich:column style='width:65%' colspan="2" rendered="#{!data.fechaCumplimiento}">
                                    <h:inputTextarea styleClass="inputText" value="#{data.descripcionEspecificacion}" rendered="#{data.subEspecificacionesOOSList == null}" style="width:100%"></h:inputTextarea>
                                </rich:column>
                                <rich:column style='width:45%'  rendered="#{data.fechaCumplimiento}">
                                    <h:inputTextarea styleClass="inputText" value="#{data.descripcionEspecificacion}" rendered="#{data.subEspecificacionesOOSList == null}" style="width:100%"></h:inputTextarea>
                                </rich:column>
                                <rich:column  rendered="#{data.fechaCumplimiento}" style="padding:0px !important">
                                    <table cellpadding="0" cellspacing="0"  style="width:100%">
                                        <tr><td style="border:1px solid #cccccc" class="headerClassACliente" align="center"><h:outputText styleClass="outputText2" value="Fecha Cumplimiento"/></td>
                                    </tr>
                                    <tr><td><rich:calendar value="#{data.fechaCumplimientoOos}" datePattern="dd/MM/yyyy"/></td>
                                    </tr>
                                    
                                    </table>
                                </rich:column>
                                <rich:subTable value="#{data.subEspecificacionesOOSList}" rendered="#{data.subEspecificacionesOOSList != null}" var="subData">
                                        <rich:column>
                                            <h:outputText  style="margin-left:1em;" value="#{subData.nombreSubEspecificacionesOOS}"  />
                                        </rich:column>
                                        <rich:column style='width:65%'colspan="2">
                                            <h:inputTextarea styleClass="inputText" value="#{subData.descripcionEspecificaciones}"  style="width:100%"></h:inputTextarea>
                                        </rich:column>
                                </rich:subTable>


                            </rich:dataTable>
                    </rich:panel>
                     <rich:panel style="width:70%;margin-top:12px; " headerClass="headerClassACliente">
                          <f:facet name="header">
                                <h:outputText value="ERROR DE FASE I : ERROR RELACIONADO CON LABORATORIO"/>
                          </f:facet>
                        <rich:dataTable value="#{ManagedControlCalidadOS.especificacionesOosLaboratorio}"
                                        var="data" style="width:95%"
                                        id="dataOOSLaboratorio"
                                        onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                        onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                        headerClass="headerClassACliente" >
                            <f:facet name="header">
                                <rich:columnGroup>
                                    <rich:column>
                                        <h:outputText value="Especificacion"  />
                                    </rich:column>
                                    <rich:column colspan="2">
                                        <h:outputText value="Resultado"  />
                                    </rich:column>
                                </rich:columnGroup>
                            </f:facet>
                            <rich:column>
                                <h:outputText  value="#{data.nombreEspecificacionOos}"  />
                            </rich:column>
                            <rich:column style="width:65%" colspan="2" rendered="#{!data.fechaCumplimiento}">
                                <h:inputTextarea styleClass="inputText" value="#{data.descripcionEspecificacion}" rendered="#{data.subEspecificacionesOOSList == null}" style="width:100%"></h:inputTextarea>
                            </rich:column>
                            <rich:column style='width:45%'  rendered="#{data.fechaCumplimiento}">
                                    <h:inputTextarea styleClass="inputText" value="#{data.descripcionEspecificacion}" rendered="#{data.subEspecificacionesOOSList == null}" style="width:100%"></h:inputTextarea>
                                </rich:column>
                                <rich:column  rendered="#{data.fechaCumplimiento}" style="padding:0px !important">
                                    <table cellpadding="0" cellspacing="0"  style="width:100%">
                                        <tr><td style="border:1px solid #cccccc" class="headerClassACliente" align="center"><h:outputText styleClass="outputText2" value="Fecha Cumplimiento"/></td>
                                    </tr>
                                    <tr><td><rich:calendar value="#{data.fechaCumplimientoOos}" datePattern="dd/MM/yyyy"/></td>
                                    </tr>

                                    </table>
                                </rich:column>
                             <rich:subTable value="#{data.subEspecificacionesOOSList}" rendered="#{data.subEspecificacionesOOSList != null}" var="subData">
                                        <rich:column>
                                            <h:outputText  style="margin-left:1em;" value="#{subData.nombreSubEspecificacionesOOS}"  />
                                        </rich:column>
                                        <rich:column style='width:65%' colspan="2">
                                            <h:inputTextarea styleClass="inputText" value="#{subData.descripcionEspecificaciones}"  style="width:100%"></h:inputTextarea>
                                        </rich:column>
                            </rich:subTable>

                        </rich:dataTable>
                      </rich:panel>
                      

                      <rich:panel style="width:70%;margin-top:12px; " headerClass="headerClassACliente" rendered="#{ManagedControlCalidadOS.codPermisoOOs>1}">
                          <f:facet name="header">
                                <h:outputText value="ERROR DE FASE II: ERROR RELACIONADO CON PROCESOS DE PRODUCCION"/>
                          </f:facet>
                          <rich:dataTable value="#{ManagedControlCalidadOS.especificacionesOosProduccion}"
                                        var="data" style="width:95%"
                                        id="dataOOSProduccion"
                                        onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                        onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                        headerClass="headerClassACliente" >
                            <f:facet name="header">
                                <rich:columnGroup>
                                    <rich:column>
                                        <h:outputText value="Especificacion"  />
                                    </rich:column>
                                    <rich:column colspan="2">
                                        <h:outputText value="Resultado"  />
                                    </rich:column>
                                </rich:columnGroup>
                            </f:facet>
                            <rich:column>
                                <h:outputText  value="#{data.nombreEspecificacionOos}"  />
                            </rich:column>
                            <rich:column style="width:65%" colspan="2" rendered="#{!data.fechaCumplimiento}">
                                <h:inputTextarea styleClass="inputText" value="#{data.descripcionEspecificacion}" rendered="#{data.subEspecificacionesOOSList == null}" style="width:100%"></h:inputTextarea>
                            </rich:column>
                            <rich:column style='width:45%'  rendered="#{data.fechaCumplimiento}">
                                <h:inputTextarea styleClass="inputText" value="#{data.descripcionEspecificacion}" rendered="#{data.subEspecificacionesOOSList == null}" style="width:100%"></h:inputTextarea>
                            </rich:column>
                                <rich:column  rendered="#{data.fechaCumplimiento}" style="padding:0px !important">
                                    <table cellpadding="0" cellspacing="0"  style="width:100%">
                                        <tr><td style="border:1px solid #cccccc" class="headerClassACliente" align="center"><h:outputText styleClass="outputText2" value="Fecha Cumplimiento"/></td>
                                    </tr>
                                    <tr><td><rich:calendar value="#{data.fechaCumplimientoOos}" datePattern="dd/MM/yyyy"/></td>
                                    </tr>

                                    </table>
                                </rich:column>
                             <rich:subTable value="#{data.subEspecificacionesOOSList}" rendered="#{data.subEspecificacionesOOSList != null}" var="subData">
                                        <rich:column>
                                            <h:outputText  style="margin-left:1em;" value="#{subData.nombreSubEspecificacionesOOS}"  />
                                        </rich:column>
                                        <rich:column style='width:65%' colspan="2">
                                            <h:inputTextarea styleClass="inputText" value="#{subData.descripcionEspecificaciones}"  style="width:100%"></h:inputTextarea>
                                        </rich:column>
                            </rich:subTable>

                        </rich:dataTable>
                      </rich:panel>

                    
                    <br>
                        <a4j:commandButton value="Guardar" rendered="#{ManagedControlCalidadOS.codPermisoOOs>0}" styleClass="btn" action="#{ManagedControlCalidadOS.guardarRegistroOOS_action}"
                        oncomplete="if(#{ManagedControlCalidadOS.mensaje eq '1'}){alert('Se registro satisfactoriamente el OOS');window.location.href='navegadorProgramaProduccionOS.jsf?date='+(new Date()).getTime().toString()}
                        else{alert('#{ManagedControlCalidadOS.mensaje}');}" timeout="7200"/>
                        <a4j:commandButton value="Cancelar" styleClass="btn" onclick="var a=Math.random();window.location.href='navegadorProgramaProduccionOS.jsf?a='+a;"/>
                        
                   
                </div>
             </h:form>
         

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

