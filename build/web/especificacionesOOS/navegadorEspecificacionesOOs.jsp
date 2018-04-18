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
                    <h:outputText value="#{ManagedControlCalidadOS.cargarEspecificacionesOos}"/>
                    <h:outputText styleClass="outputTextTitulo"  value="Especificaciones Oos" />
                    
                        <rich:panel headerClass="headerClassACliente" style="width:80%;margin-top:8px">
                        <f:facet name="header">
                            <h:outputText  value="FiltroEspecificaciones"/>
                        </f:facet>
                        <h:panelGrid columns="3">
                            <h:outputText value="Tipo de especificacion OOS" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <h:selectOneMenu value="#{ManagedControlCalidadOS.codTipoEspecificacionOosFiltro}" styleClass="inputText">
                                <f:selectItem itemValue='0' itemLabel="--Todos--"/>
                                <f:selectItems value="#{ManagedControlCalidadOS.tiposEspecificacionesOosSelectList}"/>
                                <a4j:support event="onchange" action="#{ManagedControlCalidadOS.codTipoEspecificacion_change}" reRender="dataEspecificacionesOos"/>
                            </h:selectOneMenu>
                        </h:panelGrid>
                    </rich:panel>
                    <rich:dataTable value="#{ManagedControlCalidadOS.especificacionesOosList}"
                                    var="data" style="margin-top:8px"
                                    id="dataEspecificacionesOos"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente"
                                    binding="#{ManagedControlCalidadOS.especificacionesOOSDataTable}" >
                    <f:facet name="header">
                    <rich:columnGroup>
                        
                            <rich:column rowspan="2">
                                <h:outputText value=""/>
                            </rich:column>
                            <rich:column rowspan="2">
                                <h:outputText value="Nro Orden"/>
                            </rich:column>
                            <rich:column rowspan="2">
                                <h:outputText value="Especificacion"/>
                            </rich:column>
                            <rich:column rowspan="2">
                                <h:outputText value="Tipo Especificacion"/>
                            </rich:column>
                            <rich:column rowspan="2">
                                <h:outputText value="Estado"/>
                            </rich:column>
                            <rich:column rowspan="2">
                                <h:outputText value="Fecha Cumplimiento"/>
                            </rich:column>
                            <rich:column colspan="3">
                                <h:outputText value="Sub Especificaciones"/>
                            </rich:column>
                            <rich:column rowspan="2">
                                <h:outputText value=""/>
                            </rich:column>
                            <rich:column breakBefore="true">
                                <h:outputText value="Orden"/>
                            </rich:column>
                            <rich:column >
                                <h:outputText value="Nombre Sub Especificacion"/>
                            </rich:column>
                            <rich:column >
                                <h:outputText value="Estado"/>
                            </rich:column>
                    </rich:columnGroup>
                    </f:facet>
                    <rich:subTable value="#{data.subEspecificacionesOOSList}" var="subData" rowKeyVar="rowkey">
                        <rich:column rowspan="#{data.subEspecificacionesListSize}" rendered="#{rowkey eq 0}">
                            <h:selectBooleanCheckbox  value="#{data.checked}"  />
                        </rich:column>
                        <rich:column rowspan="#{data.subEspecificacionesListSize}" rendered="#{rowkey eq 0}">
                            <h:outputText  value="#{data.nroOrden}"  />
                        </rich:column>
                        <rich:column rowspan="#{data.subEspecificacionesListSize}" rendered="#{rowkey eq 0}">
                            <h:outputText  value="#{data.nombreEspecificacionOos}"  />
                        </rich:column>
                        
                        <rich:column rowspan="#{data.subEspecificacionesListSize}" rendered="#{rowkey eq 0}">
                            <h:outputText value="#{data.tiposEspecificacionesOos.nombreTipoEspecificacionOos}"  />
                        </rich:column>
                        <rich:column rowspan="#{data.subEspecificacionesListSize}" rendered="#{rowkey eq 0}">
                            <h:outputText  value="#{data.estadoRegistro.nombreEstadoRegistro}"  />
                        </rich:column>
                         <rich:column rowspan="#{data.subEspecificacionesListSize}" rendered="#{rowkey eq 0}">
                            <h:outputText  value="#{data.fechaCumplimiento?'SI':'NO'}"  />
                        </rich:column>
                         <rich:column >
                            <h:outputText  value="#{subData.nroOrden>0?subData.nroOrden:''}"  />
                        </rich:column>
                         <rich:column >
                            <h:outputText  value="#{subData.nroOrden>0?subData.nombreSubEspecificacionesOOS:''}"  />
                        </rich:column>
                         <rich:column >
                            <h:outputText  value="#{subData.nroOrden>0?subData.estadoRegistro.nombreEstadoRegistro:''}"  />
                        </rich:column>
                         <rich:column  rowspan="#{data.subEspecificacionesListSize}" rendered="#{rowkey eq 0}">
                            <a4j:commandLink action="#{ManagedControlCalidadOS.cargarSubEspecificacionesOOS_action}"
                            oncomplete="var a =Math.random();window.location.href='navegadorSubEspecificacionesOOS.jsf?a='+a;" >
                                <h:graphicImage url="../img/organigrama3.jpg" alt="Sub Especificaciones OOS" />
                            </a4j:commandLink>
                        </rich:column>
                    </rich:subTable>
                    </rich:dataTable>
                    <br>
                        <a4j:commandButton value="Registrar" styleClass="btn" action="#{ManagedControlCalidadOS.cargarAgregarEspecificacionOos_action}" 
                        oncomplete="Richfaces.showModalPanel('PanelRegistrarEspecificacionesOos')" reRender="contenidoRegistrarEspecificacionesOos" />
                        <a4j:commandButton value="Modificar" styleClass="btn" onclick="if(editarItem('form1:dataEspecificacionesOos')==false){return false;}" action="#{ManagedControlCalidadOS.editarEspecificacionesOos_action}"
                        oncomplete="Richfaces.showModalPanel('PanelEditarEspecificacionesOos')" reRender="contenidoEditarEspecificacionesOos"/>
                        <a4j:commandButton value="Eliminar" styleClass="btn" onclick="if(confirm('Esta seguro de eliminar la especificación?')){if(editarItem('form1:dataEspecificacionesOos')==false){return false;}}else{return false;}"  action="#{ManagedControlCalidadOS.eliminarEspecifiacionOos_action}"
                        oncomplete="if(#{ManagedControlCalidadOS.mensaje eq '1'}){alert('Se elimino la especificacion')}else{alert('#{ManagedControlCalidadOS.mensaje}');}" reRender="dataEspecificacionesOos"/>

                   
                </div>

               
              
            </a4j:form>
            
            <rich:modalPanel id="PanelSubEspecificacionesOOS" minHeight="300"  minWidth="650"
                                     height="300" width="650"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Registro de Sub Especificaciones OOS"/>
                        </f:facet>
                        <a4j:form id="formSubEspecificaciones">
                        <h:panelGroup id="contenidoSubEspecificacionesOOS">
                            <center>
                                <rich:dataTable value="#{ManagedControlCalidadOS.subEspecificacionesOOSList}"
                                    var="data"
                                    id="dataSubEspecificacionesOOS"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente" >
                                    <h:column>
                                        <f:facet name="header">
                                            <h:outputText value=""  />
                                        </f:facet>
                                        <h:selectBooleanCheckbox  value="#{data.checked}"  />
                                    </h:column>
                                    <h:column>
                                        <f:facet name="header">
                                            <h:outputText value="Orden"  />
                                        </f:facet>
                                        <h:inputText value="#{data.nroOrden}" style="width:4em" styleClass="inputText" />
                                    </h:column>
                                    <h:column>
                                        <f:facet name="header">
                                            <h:outputText value="Sub Especificacion "  />
                                        </f:facet>
                                        <h:inputText  value="#{data.nombreSubEspecificacionesOOS}" style="width:25em" styleClass="inputText"/>
                                    </h:column>

                                    <h:column>
                                        <f:facet name="header">
                                            <h:outputText value="Estado"  />
                                        </f:facet>
                                        <h:selectOneMenu value="#{data.estadoRegistro.codEstadoRegistro}" styleClass="inputText">
                                            <f:selectItem itemValue="1" itemLabel="Activo"/>
                                            <f:selectItem itemValue="2" itemLabel="No Activo"/>
                                        </h:selectOneMenu>
                                    </h:column>
                                </rich:dataTable>
                                <div style="margin-top:8px">
                                    <a4j:commandLink action="#{ManagedControlCalidadOS.masSubEspecificaciones_action}" reRender="dataSubEspecificacionesOOS"  timeout="7200"  >
                                        <h:graphicImage url="../img/mas.png"/>
                                    </a4j:commandLink>
                                    <a4j:commandLink action="#{ManagedControlCalidadOS.menosSubEspecificaciones_action}" reRender="dataSubEspecificacionesOOS"  timeout="7200">
                                        <h:graphicImage url="../img/menos.png"/>
                                    </a4j:commandLink>
                                </div>
                                </center>
                                <div align="center">
                                    <a4j:commandButton styleClass="btn" value="Registrar"  action="#{ManagedControlCalidadOS.guardarSubEspecificacionesOOs_action}"
                                    oncomplete="if(#{ManagedControlCalidadOS.mensaje eq '1'}){alert('Se registraron las subespecificaciones');javascript:Richfaces.hideModalPanel('PanelSubEspecificacionesOOS');}else{alert('#{ManagedEspecificacionesControlCalidad.mensaje}');}"
                                    reRender="dataEspecificacionesOos"/>
                                <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('PanelSubEspecificacionesOOS')" class="btn" />
                                </div>
                        </h:panelGroup>
                        </a4j:form>
            </rich:modalPanel>


             <rich:modalPanel id="PanelRegistrarEspecificacionesOos" minHeight="200"  minWidth="650"
                                     height="200" width="650"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Registro de Especificaciones Fisicas"/>
                        </f:facet>
                        <a4j:form id="formRegistrar">
                        <h:panelGroup id="contenidoRegistrarEspecificacionesOos">
                            <h:panelGrid columns="3">
                                <h:outputText value="Nombre Especificacion" styleClass="outputText2" style="font-weight:bold" />
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold" />
                                <h:inputText style="width:100%" value="#{ManagedControlCalidadOS.especificacionesOosRegistrar.nombreEspecificacionOos}" styleClass="inputText" id="nombreEspecificacion"  />
                                <h:outputText value="Tipo Especificacion" styleClass="outputText2" style="font-weight:bold" />
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold" />
                                <h:selectOneMenu value="#{ManagedControlCalidadOS.especificacionesOosRegistrar.tiposEspecificacionesOos.codTipoEspecificacionOos}" styleClass="inputText" >
                                    <f:selectItems value="#{ManagedControlCalidadOS.tiposEspecificacionesOosSelectList}"/>
                                </h:selectOneMenu>
                                <h:outputText value="Nro Orden" styleClass="outputText2" style="font-weight:bold" />
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold" />
                                <h:inputText value="#{ManagedControlCalidadOS.especificacionesOosRegistrar.nroOrden}" styleClass="inputText"/>
                                <h:outputText value="Requiere fecha Cumplimiento" styleClass="outputText2" style="font-weight:bold" />
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold" />
                                <h:selectBooleanCheckbox value="#{ManagedControlCalidadOS.especificacionesOosRegistrar.fechaCumplimiento}"/>
                                <h:outputText value="Estado" styleClass="outputText2" style="font-weight:bold" />
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold" />
                                <h:outputText value="Activo" styleClass="outputText2" />
                               
                            </h:panelGrid>
                                <div align="center">
                                    <a4j:commandButton styleClass="btn" value="Registrar"  action="#{ManagedControlCalidadOS.guardarNuevaEspecificacionOos_action}"
                                    oncomplete="if(#{ManagedControlCalidadOS.mensaje eq '1'}){alert('Se registro la especificacion');javascript:Richfaces.hideModalPanel('PanelRegistrarEspecificacionesOos');}else{alert('#{ManagedEspecificacionesControlCalidad.mensaje}');}"
                                    reRender="dataEspecificacionesOos"/>
                                <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('PanelRegistrarEspecificacionesOos')" class="btn" />
                                </div>
                        </h:panelGroup>
                        </a4j:form>
            </rich:modalPanel>

           <rich:modalPanel id="PanelEditarEspecificacionesOos" minHeight="250"  minWidth="650"
                                     height="250" width="650"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Modificación de Especificaciones OOS"/>
                        </f:facet>
                        <a4j:form id="formEditar">
                        <h:panelGroup id="contenidoEditarEspecificacionesOos">
                            <h:panelGrid columns="3">
                                <h:outputText value="Nombre Especificacion" styleClass="outputText2" style="font-weight:bold" />
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold" />
                                <h:inputText style="width:100%" value="#{ManagedControlCalidadOS.especificacionesOosRegistrar.nombreEspecificacionOos}" styleClass="inputText" id="nombreUnidad"  />
                               <h:outputText value="Tipo Especificacion" styleClass="outputText2" style="font-weight:bold" />
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold" />
                                <h:selectOneMenu value="#{ManagedControlCalidadOS.especificacionesOosRegistrar.tiposEspecificacionesOos.codTipoEspecificacionOos}" styleClass="inputText" id="descriptivo">
                                    <f:selectItems value="#{ManagedControlCalidadOS.tiposEspecificacionesOosSelectList}"/>
                               </h:selectOneMenu>
                               <h:outputText value="Nro Orden" styleClass="outputText2" style="font-weight:bold" />
                               <h:outputText value="::" styleClass="outputText2" style="font-weight:bold" />
                               <h:inputText value="#{ManagedControlCalidadOS.especificacionesOosRegistrar.nroOrden}" styleClass="inputText"/>
                               <h:outputText value="Requiere Fecha Cumplimiento" styleClass="outputText2" style="font-weight:bold" />
                               <h:outputText value="::" styleClass="outputText2" style="font-weight:bold" />
                               <h:selectBooleanCheckbox value="#{ManagedControlCalidadOS.especificacionesOosRegistrar.fechaCumplimiento}"/>
                               <h:outputText value="Estado" styleClass="outputText2" style="font-weight:bold" />
                               <h:outputText value="::" styleClass="outputText2" style="font-weight:bold" />
                               <h:selectOneMenu value="#{ManagedControlCalidadOS.especificacionesOosRegistrar.estadoRegistro.codEstadoRegistro}" styleClass="inputText" >
                                   <f:selectItem itemValue="1" itemLabel="Activo"/>
                                   <f:selectItem itemValue="2" itemLabel="No Activo"/>
                               </h:selectOneMenu>
                               </h:panelGrid>
                                <div align="center">
                                <a4j:commandButton styleClass="btn" value="Guardar" onclick="if(confirm('Esta seguro de editar la especificacion?')==false){return false;}"
                                action="#{ManagedControlCalidadOS.guardarEditarEspecificacionOos_action}"
                                oncomplete="if(#{ManagedControlCalidadOS.mensaje eq '1'}){alert('Se edito la especificacion');javascript:Richfaces.hideModalPanel('PanelEditarEspecificacionesOos');}else{alert('#{ManagedControlCalidadOS.mensaje}');}"
                                reRender="dataEspecificacionesOos" />
                                <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('PanelEditarEspecificacionesOos')" class="btn" />
                                </div>
                        </h:panelGroup>
                        </a4j:form>
            </rich:modalPanel>
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

