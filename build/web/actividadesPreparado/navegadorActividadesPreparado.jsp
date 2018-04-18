
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
            <script type="text/javascript">
                function validarRegistroNuevaActividad()
                {
                    return (validarRegistroNoVacio(document.getElementById('formRegistrar:nombreEspecificacion')));
                }
                function validarEdicionActividad()
                {
                    return (validarRegistroNoVacio(document.getElementById('formEditar:nombreEspecificacion')));
                }
            </script>
            <style>
                
            </style>
        </head>
        <body >
        <span class='hint'>registro </span>
            <a4j:form id="form1">
                <div align="center">
                    <h:outputText value="#{ManagedActividadesPreparado.cargarActividadesPreparado}"/>
                    <h:outputText value="Actividades de Preparado" styleClass="outputTextTituloSistema" style="font-size:15px;font-weight:bold"/>
                    
                    <rich:dataTable value="#{ManagedActividadesPreparado.actividadesPreparadoList}"
                                    var="data"
                                    id="dataActividadesPreparado"
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
                                <h:outputText value="Actividad Preparado"  />
                            </f:facet>
                            <h:outputText  value="#{data.nombreActividadPreparado}"  />
                        </h:column>
                        
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Descripción"  />
                            </f:facet>
                            <h:outputText value="#{data.descripcion}"  />
                        </h:column>
                        
                    </rich:dataTable>
                   
                    <br>
                        <a4j:commandButton value="Registrar" styleClass="btn" action="#{ManagedActividadesPreparado.agregarActividadPreparado_action}" oncomplete="Richfaces.showModalPanel('panelRegistrarActividadPreparado')" reRender="contenidoRegistrarActividadPreparado" />
                        <a4j:commandButton value="Editar" styleClass="btn" onclick="if(editarItem('form1:dataActividadesPreparado')==false){return false;}" action="#{ManagedActividadesPreparado.editarActividadPreparado_action}" oncomplete="Richfaces.showModalPanel('PanelEditarActividadesPreparado')"
                        reRender="contenidoEditarActividadesPreparado"/>
                        <a4j:commandButton value="Eliminar" styleClass="btn" onclick="if(editarItem('form1:dataActividadesPreparado')==false){return false;}" action="#{ManagedActividadesPreparado.eliminarActividadPreparado_action}"
                                           oncomplete="if(#{ManagedActividadesPreparado.mensaje eq '1'}){alert('Se elimino la actividad');}else{alert('#{ManagedActividadesPreparado.mensaje}');}"
                        reRender="dataActividadesPreparado"/>
                        

                   
                </div>

               
              
            </a4j:form>

             <rich:modalPanel id="panelRegistrarActividadPreparado" minHeight="150"  minWidth="550"
                                     height="150" width="550"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" >
                        <f:facet name="header">
                            <h:outputText value="<center>Registro de Actividades de Preparado</center>" escape="false"/>
                        </f:facet>
                        <a4j:form id="formRegistrar">
                        <div align="center">
                            <h:panelGroup id="contenidoRegistrarActividadPreparado">
                                <h:panelGrid columns="3">
                                        <h:outputText value="Nombre Actividad" styleClass="outputTextBold" />
                                        <h:outputText value="::" styleClass="outputTextBold" />
                                        <h:inputText value="#{ManagedActividadesPreparado.actividadesPreparadoAgregar.nombreActividadPreparado}" styleClass="inputText" id="nombreEspecificacion" size="40" />
                                        <h:outputText value="Descripción" styleClass="outputTextBold" />
                                        <h:outputText value="::" styleClass="outputTextBold" />
                                        <h:inputText value="#{ManagedActividadesPreparado.actividadesPreparadoAgregar.descripcion}" styleClass="inputText" id="descripcion"  style="width:100%" size="40" />

                                </h:panelGrid>
                            </h:panelGroup>
                            <br>
                                
                                    <a4j:commandButton styleClass="btn" value="Registrar"  action="#{ManagedActividadesPreparado.guardarAgregarActividadPreparado_action}"
                                                       onclick="if(!validarRegistroNuevaActividad()){return false;}"
                                                       reRender="dataActividadesPreparado" oncomplete="if(#{ManagedActividadesPreparado.mensaje eq '1'}){alert('Se guardo la actividad');javascript:Richfaces.hideModalPanel('panelRegistrarActividadPreparado');}else{alert('#{ManagedActividadesPreparado.mensaje}');}"/>
                                    <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('panelRegistrarActividadPreparado')" class="btn" />
                        </div>
                        </a4j:form>
            </rich:modalPanel>

           <rich:modalPanel id="PanelEditarActividadesPreparado" minHeight="160"  minWidth="500"
                                     height="160" width="500"
                                     zindex="200"
                                     headerClass="headerClassACliente" >
                        <f:facet name="header">
                            <h:outputText value="Modificación de Actividades Preparado"/>
                        </f:facet>
                        <a4j:form id="formEditar">
                        <h:panelGroup id="contenidoEditarActividadesPreparado">
                             <h:panelGrid columns="3">
                                <h:outputText value="Nombre Especificacion" styleClass="outputTextBold" />
                                <h:outputText value="::" styleClass="outputTextBold" />
                                <h:outputText value="#{ManagedActividadesPreparado.actividadesPreparadoEditar.nombreActividadPreparado}" styleClass="outputText2" rendered="#{ManagedActividadesPreparado.actividadesPreparadoEditar.cantidadVersiones>0}" />
                                <h:inputText value="#{ManagedActividadesPreparado.actividadesPreparadoEditar.nombreActividadPreparado}" styleClass="inputText" id="nombreEspecificacion"  size="50"  rendered="#{ManagedActividadesPreparado.actividadesPreparadoEditar.cantidadVersiones eq '0'}"/>
                                <h:outputText value="Descripción" styleClass="outputTextBold" />
                                <h:outputText value="::" styleClass="outputTextBold" />
                                <h:inputText value="#{ManagedActividadesPreparado.actividadesPreparadoEditar.descripcion}" styleClass="inputText" id="descripcion"  size="40"/>
                            </h:panelGrid>
                                
                        </h:panelGroup>
                        <div align="center">
                            <a4j:commandButton styleClass="btn" value="Guardar"  action="#{ManagedActividadesPreparado.guardarEdicionActividadPreparado_action}"
                                               onclick="if(!validarEdicionActividad()){return false;}"
                                               reRender="dataActividadesPreparado" oncomplete="if(#{ManagedActividadesPreparado.mensaje eq '1'}){alert('se registro la actividad');javascript:Richfaces.hideModalPanel('PanelEditarActividadesPreparado');}else{alert('#{ManagedActividadesPreparado.mensaje}');}"/>
                            <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('PanelEditarActividadesPreparado')" class="btn" />
                        </div>
                        </a4j:form>
            </rich:modalPanel>

        </body>
    </html>

</f:view>

