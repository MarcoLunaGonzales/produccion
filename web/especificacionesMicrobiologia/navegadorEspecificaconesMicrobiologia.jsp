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
                    <h:outputText value="#{ManagedEspecificacionesControlCalidad.cargarEspecificacionesMicrobiologiaCc}"/>
                    <h:outputText styleClass="outputTextTitulo"  value="Especificaciones Microbiologia" />
                    <br><br>
                    
                    <rich:dataTable value="#{ManagedEspecificacionesControlCalidad.especificacionesMicrobiologiaCcList}"
                                    var="data"
                                    id="dataEspecificacionesMicrobiologiaCc"
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
                                <h:outputText value="Especificacion"  />
                            </f:facet>
                            <h:outputText  value="#{data.nombreEspecificacion}"  />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Tipo Resultado"  />
                            </f:facet>
                            <h:outputText value="#{data.tipoResultadoAnalisis.nombreTipoResultadoAnalisis}"  />
                        </h:column>
                         <h:column>
                            <f:facet name="header">
                                <h:outputText value="Coeficiente"  />
                            </f:facet>
                            <h:outputText  value="#{data.coeficiente}"  />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Unidad"  />
                            </f:facet>
                            <h:outputText  value="#{data.unidad}"  />
                        </h:column>
                    </rich:dataTable>
                                        <br>
                        <a4j:commandButton value="Registrar" styleClass="btn" action="#{ManagedEspecificacionesControlCalidad.agregarEspecificacionesMicrobiologia_action}" oncomplete="Richfaces.showModalPanel('PanelRegistrarEspecificacionesMicrobiologiaCc')" reRender="contenidoRegistrarEspecificacionesMicrobiologiaCc" />
                        <a4j:commandButton value="Modificar" styleClass="btn" onclick="if(editarItem('form1:dataEspecificacionesMicrobiologiaCc')==false){return false;}" action="#{ManagedEspecificacionesControlCalidad.editarEspecificacionesMicrobiologia_action}" oncomplete="Richfaces.showModalPanel('PanelEditarEspecificacionesMicrobiologiaCc')" reRender="contenidoEditarEspecificacionesMicrobiologiaCc"/>
                        <a4j:commandButton value="Eliminar" styleClass="btn" onclick="if(confirm('Esta seguro de eliminar la equivalencia?')){if(editarItem('form1:dataEspecificacionesMicrobiologiaCc')==false){return false;}}else{return false;}"  action="#{ManagedEspecificacionesControlCalidad.eliminarEspecificacionesMicrobiologia_action}"
                        oncomplete="if(#{ManagedEspecificacionesControlCalidad.mensaje eq '1'}){alert('Se elimino la especificación');}else{alert('#{ManagedEspecificacionesControlCalidad.mensaje}');}"
                        reRender="dataEspecificacionesMicrobiologiaCc,controles"/>

                   
                </div>

               
              
            </a4j:form>

             <rich:modalPanel id="PanelRegistrarEspecificacionesMicrobiologiaCc" minHeight="200"  minWidth="550"
                                     height="200" width="550"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Registro de Analisis Microbiologico"/>
                        </f:facet>
                        <a4j:form id="formRegistrar">
                        <h:panelGroup id="contenidoRegistrarEspecificacionesMicrobiologiaCc">
                            <h:panelGrid columns="4">
                                <h:outputText value="Nombre Especificacion :" styleClass="outputText1" />
                                <h:inputText value="#{ManagedEspecificacionesControlCalidad.especificacionesMicrobiologiaCc.nombreEspecificacion}" styleClass="inputText" id="nombreUnidad"  />
                                <%--h:outputText value="Referencia:" styleClass="outputText1" />
                                <h:selectOneMenu value="#{ManagedEspecificacionesControlCalidad.especificacionesMicrobiologiaCc.tiposReferenciaCc.codReferenciaCc}" styleClass="inputText" id="codReferencia">
                                    <f:selectItems value="#{ManagedEspecificacionesControlCalidad.tiposReferenciaCcList}"/>
                               </h:selectOneMenu--%>
                               <h:outputText value="Tipo Resultado:" styleClass="outputText1" />
                               <h:selectOneMenu value="#{ManagedEspecificacionesControlCalidad.especificacionesMicrobiologiaCc.tipoResultadoAnalisis.codTipoResultadoAnalisis}" styleClass="inputText" id="descriptivo">
                                   <f:selectItems value="#{ManagedEspecificacionesControlCalidad.tiposResultadoAnalisisList}"/>
                               </h:selectOneMenu>
                                <h:outputText value="Coeficiente :" styleClass="outputText1" />
                                <h:inputText value="#{ManagedEspecificacionesControlCalidad.especificacionesMicrobiologiaCc.coeficiente}" styleClass="inputText" size="10"/>
                                <h:outputText value="Unidad :" styleClass="outputText1" />
                                <h:inputText value="#{ManagedEspecificacionesControlCalidad.especificacionesMicrobiologiaCc.unidad}" styleClass="inputText" size="10"/>
                            </h:panelGrid>
                                <div align="center">
                                    <a4j:commandButton styleClass="btn" value="Registrar"  action="#{ManagedEspecificacionesControlCalidad.guardarEspecificacionesMicrobiologia_action}"
                                    oncomplete="if(#{ManagedEspecificacionesControlCalidad.mensaje eq '1'}){alert('Se registro la especificación');javascript:Richfaces.hideModalPanel('PanelRegistrarEspecificacionesMicrobiologiaCc')}
                                    else{alert('#{ManagedEspecificacionesControlCalidad.mensaje}');}"
                                    reRender="dataEspecificacionesMicrobiologiaCc"/>
                                <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('PanelRegistrarEspecificacionesMicrobiologiaCc')" class="btn" />
                                </div>
                        </h:panelGroup>
                        </a4j:form>
            </rich:modalPanel>

           <rich:modalPanel id="PanelEditarEspecificacionesMicrobiologiaCc" minHeight="160"  minWidth="500"
                                     height="160" width="500"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Modificación de Analisis Microbiologico"/>
                        </f:facet>
                        <a4j:form id="formEditar">
                        <h:panelGroup id="contenidoEditarEspecificacionesMicrobiologiaCc">
                            <h:panelGrid columns="4">
                                <h:outputText value="Nombre Especificacion :" styleClass="outputText1" />
                                <h:inputText value="#{ManagedEspecificacionesControlCalidad.especificacionesMicrobiologiaCc.nombreEspecificacion}" styleClass="inputText" id="nombreUnidad"  />
                                <%--h:outputText value="Referencia:" styleClass="outputText1" />
                                <h:selectOneMenu value="#{ManagedEspecificacionesControlCalidad.especificacionesMicrobiologiaCc.tiposReferenciaCc.codReferenciaCc}" styleClass="inputText" id="codReferencia">
                                    <f:selectItems value="#{ManagedEspecificacionesControlCalidad.tiposReferenciaCcList}"/>
                               </h:selectOneMenu--%>
                               <%--h:outputText value="Analisis Microbiologico:" styleClass="outputText1" />
                               <h:selectOneMenu value="#{ManagedEspecificacionesControlCalidad.especificacionesMicrobiologiaCc.descriptivo}" styleClass="inputText" id="descriptivo">
                                   <f:selectItem itemValue="1" itemLabel="DESCRIPTIVO" />
                                   <f:selectItem itemValue="0" itemLabel="NO DESCRIPTIVO" />
                               </h:selectOneMenu--%>
                               <h:outputText value="Tipo Resultado:" styleClass="outputText1" />
                               <h:selectOneMenu value="#{ManagedEspecificacionesControlCalidad.especificacionesMicrobiologiaCc.tipoResultadoAnalisis.codTipoResultadoAnalisis}" styleClass="inputText" id="descriptivo">
                                   <f:selectItems value="#{ManagedEspecificacionesControlCalidad.tiposResultadoAnalisisList}"/>
                               </h:selectOneMenu>
                               <h:outputText value="Coeficiente :" styleClass="outputText1" />
                               <h:inputText value="#{ManagedEspecificacionesControlCalidad.especificacionesMicrobiologiaCc.coeficiente}" styleClass="inputText" size="10"/>
                               <h:outputText value="Unidad :" styleClass="outputText1" />
                               <h:inputText value="#{ManagedEspecificacionesControlCalidad.especificacionesMicrobiologiaCc.unidad}" styleClass="inputText" size="10"/>
                            </h:panelGrid>
                                <div align="center">
                                <a4j:commandButton styleClass="btn" value="Guardar" onclick="if(confirm('Esta seguro de editar la especificacion?')==false){return false;}"
                                action="#{ManagedEspecificacionesControlCalidad.guardarEditarEspecificacionesMicrobiologia_action}" 
                                oncomplete="if(#{ManagedEspecificacionesControlCalidad.mensaje eq '1'}){alert('Se edito la especificación');javascript:Richfaces.hideModalPanel('PanelEditarEspecificacionesMicrobiologiaCc')}
                                    else{alert('#{ManagedEspecificacionesControlCalidad.mensaje}');}"
                                reRender="dataEspecificacionesMicrobiologiaCc" />
                                <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('PanelEditarEspecificacionesMicrobiologiaCc')" class="btn" />
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

