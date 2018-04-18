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
                    <h:outputText value="#{ManagedEspecificacionesControlCalidad.cargarEspecificacionesFisicasCc}"/>
                    <h:outputText styleClass="outputTextTitulo"  value="Especificaciones Fisicas" />
                    <br><br>
                    
                    <rich:dataTable value="#{ManagedEspecificacionesControlCalidad.especificacionesFisicasCcList}"
                                    var="data"
                                    id="dataEspecificacionesQuimicasCc"
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
                                <h:outputText value="Especificacion "  />
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
                    


                   <%--h:panelGrid columns="2"  width="50" id="controles">
                         <h:commandLink  action="#{ManagedUnidadesMedida.atras_action}"   rendered="#{ManagedUnidadesMedida.begin!='1'}"  >
                                <h:graphicImage url="../img/previous.gif"  style="border:0px solid red"   alt="PAGINA ANTERIOR"  />
                            </h:commandLink>
                            <h:commandLink  action="#{ManagedUnidadesMedida.siguiente_action}"  rendered="#{ManagedUnidadesMedida.cantidadfilas>'9'}">
                                <h:graphicImage url="../img/next.gif"  style="border:0px solid red"  alt="PAGINA SIGUIENTE" />
                            </h:commandLink>
                    </h:panelGrid--%>
                    

                   
                    <br>
                        <a4j:commandButton value="Registrar" styleClass="btn" action="#{ManagedEspecificacionesControlCalidad.agregarEspecificacionesFisicas_action}" oncomplete="Richfaces.showModalPanel('PanelRegistrarEspecificacionesQuimicasCc')" reRender="contenidoRegistrarEspecificacionesQuimicasCc" />
                        <a4j:commandButton value="Modificar" styleClass="btn" onclick="if(editarItem('form1:dataEspecificacionesQuimicasCc')==false){return false;}" action="#{ManagedEspecificacionesControlCalidad.editarEspecificacionesFisicas_action}" oncomplete="Richfaces.showModalPanel('PanelEditarEspecificacionesFisicasCc')" reRender="contenidoEditarEspecificacionesFisicasCc"/>
                        <a4j:commandButton value="Eliminar" styleClass="btn" onclick="if(confirm('Esta seguro de eliminar la especificación?')){if(editarItem('form1:dataEspecificacionesQuimicasCc')==false){return false;}}else{return false;}"  action="#{ManagedEspecificacionesControlCalidad.eliminarEspecificacionesFisicas_action}"
                        oncomplete="if(#{ManagedEspecificacionesControlCalidad.mensaje eq '1'}){alert('Se elimino la especificacion')}else{alert('#{ManagedEspecificacionesControlCalidad.mensaje}');}" reRender="dataEspecificacionesQuimicasCc,controles"/>

                   
                </div>

               
              
            </a4j:form>

             <rich:modalPanel id="PanelRegistrarEspecificacionesQuimicasCc" minHeight="200"  minWidth="550"
                                     height="200" width="550"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Registro de Especificaciones Fisicas"/>
                        </f:facet>
                        <a4j:form id="formRegistrar">
                        <h:panelGroup id="contenidoRegistrarEspecificacionesQuimicasCc">
                            <h:panelGrid columns="4">
                                <h:outputText value="Nombre Especificacion :" styleClass="outputText1" />
                                <h:inputText value="#{ManagedEspecificacionesControlCalidad.especificacionesFisicasCc.nombreEspecificacion}" styleClass="inputText" id="nombreUnidad"  />

                                
                               <h:outputText value="Tipo Resultado:" styleClass="outputText1" />
                               <h:selectOneMenu value="#{ManagedEspecificacionesControlCalidad.especificacionesFisicasCc.tipoResultadoAnalisis.codTipoResultadoAnalisis}" styleClass="inputText" id="descriptivo">
                                   <f:selectItems value="#{ManagedEspecificacionesControlCalidad.tiposResultadoAnalisisList}"/>
                               </h:selectOneMenu>
                               <h:outputText value="Coeficiente:" styleClass="outputText1" />
                               <h:inputText value="#{ManagedEspecificacionesControlCalidad.especificacionesFisicasCc.coeficiente}" size="10" styleClass="inputText" id="coeficiente"  />
                               <h:outputText value="Unidad:" styleClass="outputText1" />
                               <h:inputText value="#{ManagedEspecificacionesControlCalidad.especificacionesFisicasCc.unidad}" size="10" styleClass="inputText" id="unidad"  />
                            </h:panelGrid>
                                <div align="center">
                                    <a4j:commandButton styleClass="btn" value="Registrar"  action="#{ManagedEspecificacionesControlCalidad.guardarEspecificacionesFisicas_action}"
                                    oncomplete="if(#{ManagedEspecificacionesControlCalidad.mensaje eq '1'}){alert('Se registro la especificacion');javascript:Richfaces.hideModalPanel('PanelRegistrarEspecificacionesQuimicasCc');}else{alert('#{ManagedEspecificacionesControlCalidad.mensaje}');}"
                                    reRender="dataEspecificacionesQuimicasCc"/>
                                <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('PanelRegistrarEspecificacionesQuimicasCc')" class="btn" />
                                </div>
                        </h:panelGroup>
                        </a4j:form>
            </rich:modalPanel>

           <rich:modalPanel id="PanelEditarEspecificacionesFisicasCc" minHeight="160"  minWidth="500"
                                     height="160" width="500"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Modificación de Especificaciones Fisicas"/>
                        </f:facet>
                        <a4j:form id="formEditar">
                        <h:panelGroup id="contenidoEditarEspecificacionesFisicasCc">
                            <h:panelGrid columns="4">
                                <h:outputText value="Nombre Especificacion :" styleClass="outputText1" />
                                <h:inputText value="#{ManagedEspecificacionesControlCalidad.especificacionesFisicasCc.nombreEspecificacion}" styleClass="inputText" id="nombreUnidad"  />
                               <h:outputText value="Tipo Resultado:" styleClass="outputText1" />
                              
                               <h:selectOneMenu value="#{ManagedEspecificacionesControlCalidad.especificacionesFisicasCc.tipoResultadoAnalisis.codTipoResultadoAnalisis}" styleClass="inputText" id="descriptivo">
                                   <f:selectItems value="#{ManagedEspecificacionesControlCalidad.tiposResultadoAnalisisList}"/>
                               </h:selectOneMenu>
                               <h:outputText value="Coeficiente :" styleClass="outputText1" />
                               <h:inputText value="#{ManagedEspecificacionesControlCalidad.especificacionesFisicasCc.coeficiente}" size="10" styleClass="inputText" id="coeficiente"  />
                               <h:outputText value="Unidad :" styleClass="outputText1" />
                               <h:inputText value="#{ManagedEspecificacionesControlCalidad.especificacionesFisicasCc.unidad}" size="10" styleClass="inputText" id="unidad1"  />
                               </h:panelGrid>
                                <div align="center">
                                <a4j:commandButton styleClass="btn" value="Guardar" onclick="if(confirm('Esta seguro de editar la especificacion?')==false){return false;}"
                                action="#{ManagedEspecificacionesControlCalidad.guardarEditarEspecificacionesFisicas_action}" 
                                oncomplete="if(#{ManagedEspecificacionesControlCalidad.mensaje eq '1'}){alert('Se edito la especificacion');javascript:Richfaces.hideModalPanel('PanelEditarEspecificacionesFisicasCc');}else{alert('#{ManagedEspecificacionesControlCalidad.mensaje}');}"
                                reRender="dataEspecificacionesQuimicasCc" />
                                <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('PanelEditarEspecificacionesFisicasCc')" class="btn" />
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

