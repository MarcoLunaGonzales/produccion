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
            <script type="text/javascript" src="../../js/general.js" ></script>
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
                    <h:outputText value="#{ManagedEspecificacionesControlCalidad.cargarTiposReferenciaAbmCc}"/>
                    <span style="font-weight:bold;font-size:14px;" class="outputText2">Tipos de Referencia CC</span>
                    <br><br>
                    
                    <rich:dataTable value="#{ManagedEspecificacionesControlCalidad.tiposReferenciaCcABMList}"
                                    var="data"
                                    id="dataReferenciasCc"
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
                                <h:outputText value="Tipos Referencia"  />
                            </f:facet>
                            <h:outputText  value="#{data.nombreReferenciaCc}"  />
                        </h:column>
                          <h:column>
                            <f:facet name="header">
                                <h:outputText value="Observación"/>
                            </f:facet>
                            <h:outputText  value="#{data.observacion}"  />
                        </h:column>
                    </rich:dataTable>


                    <br>
                        <a4j:commandButton value="Registrar" styleClass="btn" action="#{ManagedEspecificacionesControlCalidad.agregarTipoReferenciaCC_action}" oncomplete="Richfaces.showModalPanel('PanelRegistrarTiposReferenciaCC')" reRender="contenidoRegistrarTiposReferenciaCC" />
                        <a4j:commandButton value="Modificar" styleClass="btn" onclick="if(editarItem('form1:dataReferenciasCc')==false){return false;}" action="#{ManagedEspecificacionesControlCalidad.editarTiposReferenciaCc_action}" oncomplete="Richfaces.showModalPanel('PanelEditarTiposReferenciaCC')" reRender="contenidoEditarTiposReferenciaCC"/>
                        <a4j:commandButton value="Eliminar" styleClass="btn" onclick="if(confirm('Esta seguro de eliminar el tipo de referencia?')){if(editarItem('form1:dataReferenciasCc')==false){return false;}}else{return false;}"  action="#{ManagedEspecificacionesControlCalidad.eliminarTiposReferenciaCc}"
                        oncomplete="if(#{ManagedEspecificacionesControlCalidad.mensaje eq '1'}){alert('Se elimino el tipo de referencia')}else{alert('#{ManagedEspecificacionesControlCalidad.mensaje}');}" reRender="dataReferenciasCc"/>

                   
                </div>

               
              
            </a4j:form>

             <rich:modalPanel id="PanelRegistrarTiposReferenciaCC" minHeight="120"  minWidth="600"
                                     height="120" width="600"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Registro de Tipos Referencia CC"/>
                        </f:facet>
                        <a4j:form id="formRegistrar">
                        <h:panelGroup id="contenidoRegistrarTiposReferenciaCC">
                            <h:panelGrid columns="6">
                                <h:outputText value="Nombre Referencia:" styleClass="outputText2" style="font-weight:bold" />
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold" />
                                <h:inputText value="#{ManagedEspecificacionesControlCalidad.tiposReferenciaCcAgregar.nombreReferenciaCc}" styleClass="inputText" id="nombreUnidad"  />
                                 <h:outputText value="Observacion:" styleClass="outputText2" style="font-weight:bold" />
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold" />
                                <h:inputText value="#{ManagedEspecificacionesControlCalidad.tiposReferenciaCcAgregar.observacion}" styleClass="inputText" id="observacion"  />
                            </h:panelGrid>
                                <div align="center">
                                    <a4j:commandButton styleClass="btn" value="Registrar"  action="#{ManagedEspecificacionesControlCalidad.guardarAgregarTiposReferenciaCC_action}"
                                    oncomplete="if(#{ManagedEspecificacionesControlCalidad.mensaje eq '1'}){alert('Se registro el tipo de referencia');javascript:Richfaces.hideModalPanel('PanelRegistrarTiposReferenciaCC');}else{alert('#{ManagedEspecificacionesControlCalidad.mensaje}');}"
                                    reRender="dataReferenciasCc"/>
                                <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('PanelRegistrarTiposReferenciaCC')" class="btn" />
                                </div>
                        </h:panelGroup>
                        </a4j:form>
            </rich:modalPanel>

           <rich:modalPanel id="PanelEditarTiposReferenciaCC" minHeight="120"  minWidth="600"
                                     height="120" width="600"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Modificación de Tipo de Refencia CC"/>
                        </f:facet>
                        <a4j:form id="formEditar">
                        <h:panelGroup id="contenidoEditarTiposReferenciaCC">
                             <h:panelGrid columns="6">
                                <h:outputText value="Nombre Referencia:" styleClass="outputText2" style="font-weight:bold" />
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold" />
                                <h:inputText value="#{ManagedEspecificacionesControlCalidad.tiposReferenciaCcAgregar.nombreReferenciaCc}" styleClass="inputText" id="nombreUnidad"  />
                                 <h:outputText value="Observacion:" styleClass="outputText2" style="font-weight:bold" />
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold" />
                                <h:inputText value="#{ManagedEspecificacionesControlCalidad.tiposReferenciaCcAgregar.observacion}" styleClass="inputText" id="observacion"  />
                            </h:panelGrid>
                                <div align="center">
                                <a4j:commandButton styleClass="btn" value="Guardar" action="#{ManagedEspecificacionesControlCalidad.guardarEditarEspecificacionesFisicas_action}" 
                                oncomplete="if(#{ManagedEspecificacionesControlCalidad.mensaje eq '1'}){alert('Se edito el tipo de referencia');javascript:Richfaces.hideModalPanel('PanelEditarTiposReferenciaCC');}else{alert('#{ManagedEspecificacionesControlCalidad.mensaje}');}"
                                reRender="dataReferenciasCc" />
                                <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('PanelEditarTiposReferenciaCC')" class="btn" />
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
                            <h:graphicImage value="../../img/load2.gif" />
                        </div>
                    </rich:modalPanel>
        </body>
    </html>

</f:view>

