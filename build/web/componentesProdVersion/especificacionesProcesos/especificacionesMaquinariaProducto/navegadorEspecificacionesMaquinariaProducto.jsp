<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>
<f:view>

    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../../../css/ventas.css" />
            <script type="text/javascript" src="../../../js/general.js" ></script>
            <script>

             function vaciar()
             {
                 var var1=document.getElementById('formRegistrar:nombreUnidad');
                 var1.value='';
                 var var2=document.getElementById('formRegistrar:nombreAbrev');
                 var2.value='';
                 var var3=document.getElementById('formRegistrar:obserNuevo');
                 var3.value='';
                 var var4=document.getElementById('formRegistrar:obserNuevo');
                 var4.value='';
                 var var5=document.getElementById('formRegistrar:claveUnidad1');
                 var5.value='0';
                 var var6=document.getElementById('formRegistrar:unidad1');
                 var6.value='4';

             }
            </script>
          
        </head>
        <body >
            <a4j:form id="form1">
                <div align="center">
                    <h:outputText value="#{ManagedEspecificacionesProcesosMaquinariaProducto.cargarEspecificacionesProcesosMaquinariaProducto}"/>
                    <h:outputText styleClass="outputText2" style="font-size:13;font-weight:bold"  value="Especificaciones de Granulado Por Producto" />
                    <br/>
                        <rich:panel headerClass="headerClassACliente" style="width:80%">
                            <f:facet name="header">
                                <h:outputText value="Datos del Producto"/>

                            </f:facet>
                            <h:panelGrid columns="3" headerClass="headerClassACliente">
                                <h:outputText value="Producto" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value=":" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value="#{ManagedComponentesProdVersion.componentesProdVersionBean.nombreProdSemiterminado} " styleClass="outputText2"/>
                               <h:outputText value="Forma farmaceútica" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value=":" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value="#{ManagedComponentesProdVersion.componentesProdVersionBean.forma.nombreForma} " styleClass="outputText2"/>
                               <h:outputText value="Area de Fabricación" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value=":" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value="#{ManagedComponentesProdVersion.componentesProdVersionBean.areasEmpresa.nombreAreaEmpresa} " styleClass="outputText2"/>
                               <h:outputText value="Estado" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value=":" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value="#{ManagedComponentesProdVersion.componentesProdVersionBean.estadoCompProd.nombreEstadoCompProd} " styleClass="outputText2"/>
                            </h:panelGrid>
                        </rich:panel>

                    <rich:panel headerClass="headerClassACliente" style="width:80%;margin-top:1em !important">
                            <f:facet name="header">
                                <h:outputText value="Especificaciones"/>

                            </f:facet>
                            <rich:dataTable value="#{managedEspecificacionesProcesosMaquinariaProducto.maquinariasEspecificacionesList}"
                                            var="data" id="data"
                                            onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                            onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                            headerClass="headerClassACliente"  style="top:1em !important">
                             <f:facet name="header">
                                    <rich:columnGroup>
                                        <rich:column>
                                            <h:outputText value=""  />
                                        </rich:column>
                                        <rich:column>
                                            <h:outputText value="Maquina"  />
                                        </rich:column>
                                        <rich:column>
                                            <h:outputText value="Codigo"  />
                                        </rich:column>
                                        <rich:column>
                                            <h:outputText value="Especificacion"  />
                                        </rich:column>
                                        <rich:column>
                                            <h:outputText value="Valor"  />
                                        </rich:column>
                                        <rich:column>
                                            <h:outputText value="Tipo de Valor"  />
                                        </rich:column>
                                        <rich:column>
                                            <h:outputText value="Unidad de Medida"  />
                                        </rich:column>
                                        <rich:column>
                                            <h:outputText value="Tolerancia"  />
                                        </rich:column>

                                    </rich:columnGroup>
                                </f:facet>
                                
                                <rich:subTable rowKeyVar="rowkey" value="#{data.especificacionesProcesosProductoMaquinariaList}" var="subData" >
                                    <rich:column rowspan="#{data.especificacionesProcesosProductoMaquinariaListSize}" rendered="#{rowkey eq 0}">
                                        <h:selectBooleanCheckbox value="#{data.checked}"/>
                                    </rich:column>
                                    <rich:column rowspan="#{data.especificacionesProcesosProductoMaquinariaListSize}" rendered="#{rowkey eq 0}">
                                        <h:outputText  value="#{data.nombreMaquina}"  />
                                    </rich:column>
                                    <rich:column rowspan="#{data.especificacionesProcesosProductoMaquinariaListSize}" rendered="#{rowkey eq 0}">
                                        <h:outputText  value="#{data.codigo}"  />
                                    </rich:column>
                                    <rich:column  rendered="#{data.especificacionesProcesosProductoMaquinariaListSize>0}">
                                        <h:outputText  value="#{subData.especificacionesProcesos.nombreEspecificacionProceso}"  />
                                    </rich:column>
                                    <rich:column rendered="#{data.especificacionesProcesosProductoMaquinariaListSize>0}">
                                        <h:outputText  value="#{subData.valorExacto}"   rendered="#{subData.especificacionesProcesos.resultadoNumerico}"/>
                                        <h:outputText  value="#{subData.valorTexto}"  rendered="#{!subData.especificacionesProcesos.resultadoNumerico}"/>
                                    </rich:column>
                                    <rich:column  rendered="#{data.especificacionesProcesosProductoMaquinariaListSize>0}">
                                        <h:outputText  value="Numerico"  rendered="#{subData.especificacionesProcesos.resultadoNumerico}"/>
                                        <h:outputText  value="Texto"  rendered="#{!subData.especificacionesProcesos.resultadoNumerico}"/>
                                    </rich:column>
                                    <rich:column rendered="#{data.especificacionesProcesosProductoMaquinariaListSize>0}">
                                        <h:outputText value="#{subData.especificacionesProcesos.unidadMedida.nombreUnidadMedida}"/>
                                    </rich:column>
                                    <rich:column rendered="#{data.especificacionesProcesosProductoMaquinariaListSize>0}">
                                        <h:outputText value="#{subData.especificacionesProcesos.porcientoTolerancia}%" rendered="#{subData.especificacionesProcesos.porcientoTolerancia>0}"/>
                                    </rich:column>
                                    <rich:column colspan="5"  rendered="#{data.especificacionesProcesosProductoMaquinariaListSize==1}">
                                        <h:outputText  value="No Registrado"  />
                                    </rich:column>
                                    <rich:column style="height:12px;background-color:#cccccc" breakBefore="true" styleClass="subHeaderTableClass" colspan="8"  rendered="#{rowkey eq (data.especificacionesProcesosProductoMaquinariaListSize-1)}">
                                    </rich:column>
                                    </rich:subTable>
                                
                                

                            </rich:dataTable>
                            </rich:panel>
                           
                             <div style="margin-top:12px">
                                 <%--a4j:commandButton value="Editar" styleClass="btn" action="#{ManagedEspecificacionesDespirogenizado.editarEspecificacionesGranulado_action}"
                                 oncomplete="window.location.href='agregarEspecificacionesGranulado.jsf?cod='+(new Date()).getTime().toString();"/>
                                 <a4j:commandButton value="Cancelar" styleClass="btn" onclick="var a=Math.random();window.location.href='../navegador_componentesProducto.jsf?cod='+a;"/--%>
                            </div>
                      
                     

                   
                </div>

               
              
            </a4j:form>

             <%--rich:modalPanel id="PanelAsignarEspecificacionesProducto" minHeight="200"  minWidth="550"
                                     height="200" width="550"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Registro de Especificaciones Despirogenizado"/>
                        </f:facet>
                        <a4j:form id="formRegistrar">
                        <h:panelGroup id="contenidoAsignarEspecificacionesProducto">
                            <center>
                            <h:panelGrid columns="3">
                                <h:outputText value="Nombre Especificacion" styleClass="outputText2"  />
                                <h:outputText value="::" styleClass="outputText2" />
                                <h:outputText value="#{ManagedEspecificacionesDespirogenizado.especificacionesProcesosProdBean.especificacionProceso.nombreEspecificacionProceso}" styleClass="outputText2"/>
                                <h:outputText value="Unidad de Medida" styleClass="outputText2"  />
                                <h:outputText value="::" styleClass="outputText2" />
                                <h:outputText value="#{ManagedEspecificacionesDespirogenizado.especificacionesProcesosProdBean.especificacionProceso.unidadMedida.nombreUnidadMedida}" styleClass="outputText2"/>
                                <h:outputText value="Tipo Valor" styleClass="outputText2"  />
                                <h:outputText value="::" styleClass="outputText2" />
                                <h:outputText value="Numerico" styleClass="outputText2" rendered="#{ManagedEspecificacionesDespirogenizado.especificacionesProcesosProdBean.especificacionProceso.resultadoNumerico}"/>
                                <h:outputText value="Texto" styleClass="outputText2" rendered="#{!ManagedEspecificacionesDespirogenizado.especificacionesProcesosProdBean.especificacionProceso.resultadoNumerico}"/>
                                <h:outputText value="Tolerancia(%)s" styleClass="outputText2"  />
                                <h:outputText value="::" styleClass="outputText2" />
                                <h:outputText value="#{ManagedEspecificacionesDespirogenizado.especificacionesProcesosProdBean.especificacionProceso.porcientoTolerancia}" styleClass="outputText2"/>
                                <h:outputText value="Valor " styleClass="outputText2"  />
                                <h:outputText value="::" styleClass="outputText1" />
                                <h:inputText value="#{ManagedEspecificacionesDespirogenizado.especificacionesProcesosProdBean.valorExacto}"styleClass="inputText" rendered="#{ManagedEspecificacionesDespirogenizado.especificacionesProcesosProdBean.especificacionProceso.resultadoNumerico}"/>
                                <h:inputText value="#{ManagedEspecificacionesDespirogenizado.especificacionesProcesosProdBean.valorTexto}"styleClass="inputText" rendered="#{!ManagedEspecificacionesDespirogenizado.especificacionesProcesosProdBean.especificacionProceso.resultadoNumerico}"/>
                                
                             
                            </h:panelGrid>
                                
                                <a4j:commandButton styleClass="btn" value="Guardar"  action="#{ManagedEspecificacionesDespirogenizado.guardarEspecificacionProcesosProducto_action}"
                                    oncomplete="if(#{ManagedEspecificacionesDespirogenizado.mensaje eq '1'}){alert('Se asigno el valor');javascript:Richfaces.hideModalPanel('PanelAsignarEspecificacionesProducto')}
                                    else{alert('#{ManagedEspecificacionesDespirogenizado.mensaje}')}"
                                    reRender="dataEspecificacionesProceso"/>
                                <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('PanelAsignarEspecificacionesProducto')" class="btn" />
                                </center>
                        </h:panelGroup>
                        </a4j:form>
            </rich:modalPanel--%>

        </body>
    </html>

</f:view>

