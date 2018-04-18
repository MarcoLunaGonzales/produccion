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
        <body>
            <a4j:form id="form1">
                <div align="center">
                    <h:outputText value="#{ManagedEspecificacionesControlCalidad.cargarMateriales}"/>
                    <h:outputText styleClass="outputTextTitulo"  value="Nombres de Mariales de Control de Calidad" />
                    <br><br>
                        <h:panelGrid columns="4">
                            <h:outputText value="Capitulo:" styleClass="outputText2"/>
                             <h:selectOneMenu value="#{ManagedEspecificacionesControlCalidad.materialBean.grupo.capitulo.codCapitulo}" styleClass="inputText">
                                 <f:selectItems value="#{ManagedEspecificacionesControlCalidad.capitulosList}"/>
                                 <a4j:support event="onchange" action="#{ManagedEspecificacionesControlCalidad.capitulos_change}"reRender="dataMateriales,capitulos,controles"/>
                            </h:selectOneMenu>
                    
                            <h:outputText value="Grupo:" styleClass="outputText2"/>
                            <h:selectOneMenu value="#{ManagedEspecificacionesControlCalidad.materialBean.grupo.codGrupo}" styleClass="inputText" id="capitulos">
                                <f:selectItems value="#{ManagedEspecificacionesControlCalidad.gruposList}"/>
                                <%--a4j:support event="onchange" action="#{ManagedEspecificacionesControlCalidad.grupos_change}" reRender="dataMateriales,controles"/--%>
                            </h:selectOneMenu>
                    
                            <h:outputText value="Nombre Material Baco:" styleClass="outputText2"/>
                            <h:inputText value="#{ManagedEspecificacionesControlCalidad.materialBean.nombreMaterial}" size="35" styleClass="inputText"/>
                    
                            <h:outputText value="Nombre Material CC:" styleClass="outputText2"/>
                            <h:inputText value="#{ManagedEspecificacionesControlCalidad.materialBean.nombreCCC}" size="35" styleClass="inputText"/>
                            
                        </h:panelGrid>
                        <center><a4j:commandButton action="#{ManagedEspecificacionesControlCalidad.buscarMaterial_action}" value="BUSCAR" reRender="dataMateriales,controles" styleClass="btn"/></center>
                        <br>
                    <rich:dataTable value="#{ManagedEspecificacionesControlCalidad.materialesList}"
                                    var="data"
                                    id="dataMateriales"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente" >
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value=""  />
                            </f:facet>
                            <h:selectBooleanCheckbox  value="#{data.checked}"  />
                        </rich:column>
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Nombre Material Baco"  />
                            </f:facet>
                            <h:outputText  value="#{data.nombreMaterial}"  />
                        </rich:column>
                        
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Nombre Material Comercial"  />
                            </f:facet>
                            <h:outputText value="#{data.nombreComercialMaterial}"  />
                        </rich:column>
                        <rich:column style="background-color:#90EE90;">
                            <f:facet name="header">
                                <h:outputText value="Nombre Material Control de calidad"  />
                            </f:facet>
                            <h:outputText value="#{data.nombreCCC}"  />
                        </rich:column>
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value="Grupo"  />
                            </f:facet>
                            <h:outputText value="#{data.grupo.nombreGrupo}"  />
                        </rich:column>
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value="Capítulo"  />
                            </f:facet>
                            <h:outputText value="#{data.grupo.capitulo.nombreCapitulo}"  />
                        </rich:column>
                      
                    </rich:dataTable>
                    <br>
                        <h:panelGrid columns="2"  width="50" id="controles">
                            <a4j:commandLink  action="#{ManagedEspecificacionesControlCalidad.atras_action}"   rendered="#{ManagedEspecificacionesControlCalidad.begin>0}" reRender="controles,dataMateriales">
                                <h:graphicImage url="../img/previous.gif"  style="border:0px solid red"   alt="PAGINA ANTERIOR"  />
                            </a4j:commandLink>
                            <a4j:commandLink  action="#{ManagedEspecificacionesControlCalidad.siguiente_action}"  rendered="#{ManagedEspecificacionesControlCalidad.cantidadFilas>=15}" reRender="controles,dataMateriales">
                                <h:graphicImage url="../img/next.gif"  style="border:0px solid red"  alt="PAGINA SIGUIENTE" />
                            </a4j:commandLink>
                        </h:panelGrid>
                        <a4j:commandButton value="Cambiar Nombre CC" onclick="if(editarItem('form1:dataMateriales')==false){return false;}" styleClass="btn" action="#{ManagedEspecificacionesControlCalidad.editarNombreMaterialCC}" oncomplete="Richfaces.showModalPanel('PanelEditarNombreCC')" reRender="contenidoEditarNombreCC" />
                   
                </div>
            </a4j:form>

             <rich:modalPanel id="PanelEditarNombreCC" minHeight="200"  minWidth="750"
                                     height="200" width="750"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Editar Nombre Material Control de Calidads"/>
                        </f:facet>
                        <a4j:form id="formRegistrar">
                        <h:panelGroup id="contenidoEditarNombreCC">
                            <h:panelGrid columns="4">
                                <h:outputText value="Nombre Material Baco:" styleClass="outputText2" />
                                <h:outputText value="#{ManagedEspecificacionesControlCalidad.materialEditar.nombreMaterial}" styleClass="outputText2" />
                                <h:outputText value="Nombre Material Comercial:" styleClass="outputText2" />
                                <h:outputText value="#{ManagedEspecificacionesControlCalidad.materialEditar.nombreComercialMaterial}" styleClass="outputText2" />
                                <h:outputText value="Nombre Material Control de Calidad:" styleClass="outputText2" />
                                <h:inputText value="#{ManagedEspecificacionesControlCalidad.materialEditar.nombreCCC}" styleClass="inputText" id="nombreMaterialCC" size="35" />
                            </h:panelGrid>
                                <div align="center">
                                    <a4j:commandButton styleClass="btn" value="Guargar"  action="#{ManagedEspecificacionesControlCalidad.guardarEdicionNombreMaterialCC_action}" reRender="dataMateriales,controles"
                                    oncomplete="javascript:Richfaces.hideModalPanel('PanelEditarNombreCC')"/>
                                <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('PanelEditarNombreCC')" class="btn" />
                                </div>
                        </h:panelGroup>
                        </a4j:form>
            </rich:modalPanel>

           
        </body>
    </html>

</f:view>

