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
                    <h:outputText value="#{ManagedEspecificacionesControlCalidad.cargarAnalisisControlCalidad}"/>
                    
                    Analisis:<h:outputText  value="#{ManagedEspecificacionesControlCalidad.formasFarmaceuticasSeleccionado.nombreForma}" /><br/><br/>
                    <h:outputText styleClass="outputTextTitulo"  value="Especificaciones" />
                    <h:selectOneMenu value="#{ManagedEspecificacionesControlCalidad.codTipoAnalisisCc}" styleClass="inputText" id="descriptivo">
                        <f:selectItems value="#{ManagedEspecificacionesControlCalidad.tiposAnalisisCcList}" />
                        <a4j:support action="#{ManagedEspecificacionesControlCalidad.tiposAnalisisControlCalidad_change}" event="onchange" reRender="dataEspecificacionesQuimicasCc" />
                    </h:selectOneMenu>
                    <br><br>
                    
                    <rich:dataTable value="#{ManagedEspecificacionesControlCalidad.especificacionesCcList}"
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
                                <h:outputText value="Especificacion"  />
                            </f:facet>
                            <h:outputText  value="#{data.nombreEspecificacion}"  />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Referencia"  />
                            </f:facet>
                            <h:outputText value="#{data.tiposReferenciaCc.nombreReferenciaCc}">
                            </h:outputText>
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Analisis Fisico"  />
                            </f:facet>
                            <h:outputText value="#{data.descriptivo=='0'?'DESCRIPTIVO':'NO DESCRIPTIVO'}"  />
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
                        <a4j:commandButton value="Registrar" styleClass="btn" action="#{ManagedEspecificacionesControlCalidad.agregarEspecificacionesQuimicas_action}" oncomplete="Richfaces.showModalPanel('PanelRegistrarEspecificacionesQuimicasCc')" reRender="contenidoRegistrarEspecificacionesQuimicasCc" />
                        <%--a4j:commandButton value="Modificar" styleClass="btn" onclick="if(editarItem('form1:dataEspecificacionesQuimicasCc')==false){return false;}" action="#{ManagedEspecificacionesControlCalidad.editarEspecificacionesQuimicas_action}" oncomplete="Richfaces.showModalPanel('PanelEditarEspecificacionesQuimicasCc')" reRender="contenidoEditarEspecificacionesQuimicasCc"/--%>
                        <a4j:commandButton value="Eliminar" styleClass="btn" onclick="if(confirm('Esta seguro de eliminar?')){if(editarItem('form1:dataEspecificacionesQuimicasCc')==false){return false;}}else{return false;}"  action="#{ManagedEspecificacionesControlCalidad.eliminarEspecificaciones_action}"
                        oncomplete="if(#{ManagedEspecificacionesControlCalidad.mensaje!=''}){alert('#{ManagedEspecificacionesControlCalidad.mensaje}');}else{alert('se elimino la especificacion');}" reRender="dataEspecificacionesQuimicasCc,controles"/>

                   
                </div>

               
              
            </a4j:form>

             <rich:modalPanel id="PanelRegistrarEspecificacionesQuimicasCc" minHeight="200"  minWidth="550"
                                     height="200" width="550"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Registro de Analisis"/>
                        </f:facet>
                        <a4j:form id="formRegistrar">
                        <h:panelGroup id="contenidoRegistrarEspecificacionesQuimicasCc">
                            <h:panelGrid columns="4">
                                
                               <h:outputText value="Nombre Analisis:" styleClass="outputText1" />
                               <h:selectOneMenu value="#{ManagedEspecificacionesControlCalidad.especificacionesFisicasCcAgregar.codEspecificacion}" styleClass="inputText" id="descriptivo">
                                   <f:selectItems value="#{ManagedEspecificacionesControlCalidad.especificacionesAgregarList}" />
                               </h:selectOneMenu>
                            </h:panelGrid>

                                <div align="center">
                                    <a4j:commandButton styleClass="btn" value="Registrar"  action="#{ManagedEspecificacionesControlCalidad.guardarEspecificaciones_action}"
                                    oncomplete="if(#{ManagedEspecificacionesControlCalidad.mensaje!=''}){alert('#{ManagedEspecificacionesControlCalidad.mensaje}');}else{alert('Se registro la especificacion');javascript:Richfaces.hideModalPanel('PanelRegistrarEspecificacionesQuimicasCc');}"
                                    reRender="dataEspecificacionesQuimicasCc,controles"/>
                                <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('PanelRegistrarEspecificacionesQuimicasCc')" class="btn" />
                                </div>
                        </h:panelGroup>
                        </a4j:form>
            </rich:modalPanel>

           <rich:modalPanel id="PanelEditarEspecificacionesQuimicasCc" minHeight="160"  minWidth="500"
                                     height="160" width="500"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Modificación de Analisis Quimico"/>
                        </f:facet>
                        <a4j:form id="formEditar">
                        <h:panelGroup id="contenidoEditarEspecificacionesQuimicasCc">
                            <h:panelGrid columns="4">
                                <h:outputText value="Nombre Especificacion :" styleClass="outputText1" />
                                <h:inputText value="#{ManagedEspecificacionesControlCalidad.especificacionesQuimicasCc.nombreEspecificacion}" styleClass="inputText" id="nombreUnidad"  />

                               <h:outputText value="Analisis Quimico:" styleClass="outputText1" />
                               <h:selectOneMenu value="#{ManagedEspecificacionesControlCalidad.especificacionesQuimicasCc.descriptivo}" styleClass="inputText" id="descriptivo">
                                   <f:selectItem itemValue="1" itemLabel="DESCRIPTIVO" />
                                   <f:selectItem itemValue="0" itemLabel="NO DESCRIPTIVO" />
                               </h:selectOneMenu>
                            </h:panelGrid>
                                <div align="center">
                                <a4j:commandButton styleClass="btn" value="Guardar" onclick="if(confirm('Esta seguro de editar la especificacion?')==false){return false;}"
                                action="#{ManagedEspecificacionesControlCalidad.guardarEditarEspecificacionesQuimicas_action}" oncomplete="if(#{ManagedEspecificacionesControlCalidad.mensaje!=''}){alert('#{ManagedEspecificacionesControlCalidad.mensaje}');}else{javascript:Richfaces.hideModalPanel('PanelEditarEspecificacionesQuimicasCc');}" reRender="dataEspecificacionesQuimicasCc,controles" />
                                <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('PanelEditarEspecificacionesQuimicasCc')" class="btn" />
                                </div>
                        </h:panelGroup>
                        </a4j:form>
            </rich:modalPanel>

        </body>
    </html>

</f:view>

