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
              function verificar(nametable){

                   var count=0;

                   var elements=document.getElementById(nametable);
                   var rowsElement=elements.rows;
                   for(var i=1;i<rowsElement.length;i++){
                    var cellsElement=rowsElement[i].cells;
                    var cel=cellsElement[0];
                    if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                          if(cel.getElementsByTagName('input')[0].checked){
                           count++;
                         }

                     }

                   }

                    if(count==0){
                       alert('No escogio ningun registro');
                       return false;
                     }
                     if(count>1)
                     {
                        alert('No puede seleccionar mas de un registro');
                        return false;

                     }
                    return true;
                }
                function openPopup(url){
                    window.open(url,'DETALLE','top=50,left=200,width=800,height=500,scrollbars=1,resizable=1');
                }
              </script>
           
        </head>
        <body onload="Richfaces.showModalPanel('panelAsignarAreaNuevoPersonal');asociarEventosInicio();">
            <a4j:form id="form1">
                <center>
                <h:outputText value="#{ManagedPersonalAreasProduccion.cargarPersonalAreaProduccion}"  />
                <rich:panel headerClass="headerClassACliente" style="width:50%">
                    <f:facet name="header">
                        <h:outputText value="Buscador"/>
                    </f:facet>
                    <h:panelGrid columns="6">
                        <h:outputText value="Apellido Paterno" styleClass="outputTextBold"/>
                        <h:outputText value="::" styleClass="outputTextBold" />
                        <h:inputText value="#{ManagedPersonalAreasProduccion.personalAreaProduccionBuscar.personal.apPaternoPersonal}" styleClass="inputText"/>
                        <h:outputText value="Apellido Materno" styleClass="outputTextBold"/>
                        <h:outputText value="::" styleClass="outputTextBold" />
                        <h:inputText value="#{ManagedPersonalAreasProduccion.personalAreaProduccionBuscar.personal.apMaternoPersonal}" styleClass="inputText"/>
                        <h:outputText value="Nombre" styleClass="outputTextBold"/>
                        <h:outputText value="::" styleClass="outputTextBold" />
                        <h:inputText value="#{ManagedPersonalAreasProduccion.personalAreaProduccionBuscar.personal.nombrePersonal}" styleClass="inputText"/>
                        <h:outputText value="Area Empresa" styleClass="outputText2" style="font-weight:bold"/>
                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                        <h:selectOneMenu value="#{ManagedPersonalAreasProduccion.personalAreaProduccionBuscar.areasEmpresa.codAreaEmpresa}" styleClass="inputext">
                            <f:selectItem itemValue="0" itemLabel="--TODOS--"/>
                            <f:selectItems value="#{ManagedPersonalAreasProduccion.areasEmpresaSelectList}"/>
                        </h:selectOneMenu>
                        <h:outputText value="Estado Personal" styleClass="outputText2" style="font-weight:bold"/>
                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                        <h:selectOneMenu value="#{ManagedPersonalAreasProduccion.personalAreaProduccionBuscar.estadosPersonalAreaProduccion.codEstadoPersonalAreaProduccion}" styleClass="inputext">
                            <f:selectItem itemValue='0' itemLabel="--TODOS--"/>
                            <f:selectItems value="#{ManagedPersonalAreasProduccion.estadosPersonalAreaSelectList}"/>
                        </h:selectOneMenu>
                    </h:panelGrid>
                    <a4j:commandButton value="BUSCAR" action="#{ManagedPersonalAreasProduccion.buscarPersonalAreaProduccion_action}" reRender="dataPersonalArea" styleClass="btn"/>
                </rich:panel>
                        
                        

                        <rich:dataTable value="#{ManagedPersonalAreasProduccion.personalAreaProduccionList}" var="data" id="dataPersonalArea"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente" style="margin-top:1em">
                        <f:facet name="header">
                            <rich:columnGroup>
                                <rich:column>
                                    <h:outputText value="" id="headerCheck" />
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Personal"  />
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="<center>Tipo<br>Personal</center>" escape="false" />
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="<center>Estado<br>Registro</center>" escape="false"  />
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Area"  />
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Fecha Inicio"  />
                                </rich:column>
                                <rich:column rendered="#{ManagedPersonalAreasProduccion.permisoRegitroUsuariosModulosTouch}">
                                    <h:outputText value="Usuario"/>
                                </rich:column>
                                <rich:column >
                                    <h:outputText value="Acciones"/>
                                </rich:column>
                                
                            </rich:columnGroup>
                        </f:facet>
                            <rich:subTable value="#{data.personalAreaProduccionList}" var="subData" rowKeyVar="key">
                                <rich:column rendered="#{key eq 0}" rowspan="#{data.personalAreaProduccionListSize}">
                                    <h:selectBooleanCheckbox value="#{data.checked}" />
                                </rich:column>
                                <rich:column rendered="#{key eq 0}" rowspan="#{data.personalAreaProduccionListSize}">
                                    <h:outputText value="#{data.nombreCompletoPersonal}"  />
                                </rich:column>
                                <rich:column rendered="#{key eq 0}" rowspan="#{data.personalAreaProduccionListSize}">
                                    <h:outputText value="PLANTA"  rendered="#{data.codPersonal>0}" />
                                    <h:outputText value="TEMPORAL"  rendered="#{data.codPersonal<0}" />
                                </rich:column>
                                <rich:column >
                                    <h:outputText value="#{subData.estadosPersonalAreaProduccion.nombreEstadoPersonalAreaProduccion}"  />
                                </rich:column>
                                <rich:column >
                                    <h:outputText value="#{subData.areasEmpresa.nombreAreaEmpresa}"  />
                                </rich:column>
                                <rich:column >
                                    <h:outputText value="#{subData.fechaInicio}"  >
                                        <f:convertDateTime pattern="dd/MM/yyyy HH:mm"/>
                                    </h:outputText>
                                </rich:column>
                                <rich:column rendered="#{key eq 0 && ManagedPersonalAreasProduccion.permisoRegitroUsuariosModulosTouch}" rowspan="#{data.personalAreaProduccionListSize}">
                                    <h:outputText value="#{data.usuariosModulos.nombreUsuario}"/>
                                </rich:column>
                                <rich:column>
                                    <rich:dropDownMenu >
                                        <f:facet name="label">
                                            <h:panelGroup>
                                                <h:outputText value="Acciones"/>
                                                <h:outputText styleClass="icon-menu3"/>
                                            </h:panelGroup>
                                        </f:facet>
                                        <rich:menuItem  submitMode="none" iconClass="icon-minus" value="Editar Areas" >
                                            <a4j:support event="onclick" oncomplete="Richfaces.showModalPanel('panelEditarArea')"
                                                         action="#{ManagedPersonalAreasProduccion.seleccionarPersonalEditarAreas_action}"
                                                         reRender="contenidoEditarArea">
                                                <f:setPropertyActionListener target="#{ManagedPersonalAreasProduccion.personalEditarAreas}"
                                                                             value="#{data}"/>
                                            </a4j:support>
                                        </rich:menuItem>
                                        <rich:menuItem  submitMode="none" iconClass="icon-minus" value="Asignar Usuario" 
                                                        rendered="#{ManagedPersonalAreasProduccion.permisoRegitroUsuariosModulosTouch
                                                                        and data.usuariosModulos.nombreUsuario eq ''}">
                                            <a4j:support event="onclick" oncomplete="Richfaces.showModalPanel('panelAsignarUsuario')"
                                                         action="#{ManagedPersonalAreasProduccion.seleccionarPersonalRegistrarUsuarioModulo()}"
                                                         reRender="contenidoAsignarUsuario">
                                                <f:setPropertyActionListener target="#{ManagedPersonalAreasProduccion.personalRegistrarUsuario}"
                                                                             value="#{data}"/>
                                            </a4j:support>
                                        </rich:menuItem>
                                    </rich:dropDownMenu>
                                    <h:outputText value="#{data.usuariosModulos.nombreUsuario eq ''}"/>
                                    <h:outputText value="#{data.usuariosModulos.nombreUsuario}"/>
                                    
                                </rich:column>
                            </rich:subTable>
                            
                        </rich:dataTable>
                        <div id='bottonesAcccion' class='barraBotones'>
                            <a4j:commandButton value="Agregar Personal" action="#{ManagedPersonalAreasProduccion.cargarPersonalNuevo_action}"
                                               oncomplete="Richfaces.showModalPanel('panelAsignarAreaNuevoPersonal')" reRender="contenidoAsignarAreaNuevoPersonal"
                                               styleClass="btn"/>
                            
                        </div>
                    </center>
                    </a4j:form>
                    <rich:modalPanel id="panelAsignarUsuario" minHeight="250"  minWidth="500"
                                        height="250" width="500"  zindex="200"  headerClass="headerClassACliente"
                                        resizeable="false"  >
                           <f:facet name="header">
                               <h:outputText value="<center><b>Areas habilitadas personal</b></center>" escape="false"/>
                           </f:facet>
                           <a4j:form id="formAsignarUsuario">
                                <h:panelGroup id="contenidoAsignarUsuario">
                                    <center>
                                    <h:panelGrid columns="3">
                                            <h:outputText value="Nombre Personal" styleClass="outputText2" style="font-weight:bold" />
                                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold" />
                                            <h:outputText value="#{ManagedPersonalAreasProduccion.personalRegistrarUsuario.nombrePersonal}" styleClass="outputText2"  />
                                            <h:outputText value="Tipo Personal" styleClass="outputText2" style="font-weight:bold" />
                                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold" />
                                            <h:outputText value="PLANTA" styleClass="outputText2"  rendered="#{ManagedPersonalAreasProduccion.personalRegistrarUsuario.codPersonal>0}" />
                                            <h:outputText value="TEMPORAL" styleClass="outputText2"  rendered="#{ManagedPersonalAreasProduccion.personalRegistrarUsuario.codPersonal<0}" />
                                            <h:outputText value="Usuario" styleClass="outputText2" style="font-weight:bold" />
                                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold" />
                                            <h:outputText value="#{ManagedPersonalAreasProduccion.personalRegistrarUsuario.usuariosModulos.nombreUsuario}" styleClass="outputText2"/>
                                            <h:outputText value="Contraseña" styleClass="outputText2" style="font-weight:bold" />
                                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold" />
                                            <h:inputText value="#{ManagedPersonalAreasProduccion.personalRegistrarUsuario.usuariosModulos.contraseniaUsuario}" 
                                                         rendered="#{! ManagedPersonalAreasProduccion.usuarioExistente}"
                                                         styleClass="inputText"/>
                                            <h:outputText  styleClass="outputText2"
                                                           rendered="#{ManagedPersonalAreasProduccion.usuarioExistente}"
                                                           value="La misma que en los sistemas: <b>#{ManagedPersonalAreasProduccion.personalRegistrarUsuario.usuariosModulos.contraseniaUsuario}</b>" escape="false" />
                                    </h:panelGrid>
                                    
                                        <a4j:commandButton styleClass="btn" value="Guardar" 
                                                           action="#{ManagedPersonalAreasProduccion.guardarRegistrarPersonalUsuarioModulo}"
                                                      reRender="dataPersonalArea"
                                                      oncomplete="mostrarMensajeTransaccionEvento(function(){Richfaces.hideModalPanel('panelAsignarUsuario');})" />
                                   <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('panelAsignarUsuario')" class="btn" />
                                   </center>
                               </h:panelGroup>
                           </a4j:form>
                   </rich:modalPanel>     
                    <rich:modalPanel id="panelEditarArea" minHeight="450"  minWidth="600"
                                        height="450" width="600"  zindex="200"  headerClass="headerClassACliente"
                                        resizeable="false"  >
                           <f:facet name="header">
                               <h:outputText value="<center><b>Areas habilitadas personal</b></center>" escape="false"/>
                           </f:facet>
                           <a4j:form id="formEditarArea">
                            <h:panelGroup id="contenidoEditarArea">
                                <center>
                                <h:panelGrid columns="3">
                                       <h:outputText value="Nombre Personal" styleClass="outputText2" style="font-weight:bold" />
                                       <h:outputText value="::" styleClass="outputText2" style="font-weight:bold" />
                                       <h:outputText value="#{ManagedPersonalAreasProduccion.personalEditarAreas.nombrePersonal}" styleClass="outputText2"  />
                                       <h:outputText value="Tipo Personal" styleClass="outputText2" style="font-weight:bold" />
                                       <h:outputText value="::" styleClass="outputText2" style="font-weight:bold" />
                                       <h:outputText value="PLANTA" styleClass="outputText2"  rendered="#{ManagedPersonalAreasProduccion.personalEditarAreas.codPersonal>0}" />
                                       <h:outputText value="TEMPORAL" styleClass="outputText2"  rendered="#{ManagedPersonalAreasProduccion.personalEditarAreas.codPersonal<0}" />
                                       
                                </h:panelGrid>
                                <div style="overflow-y:auto;height:300px">
                                    <rich:dataTable value="#{ManagedPersonalAreasProduccion.personalEditarAreas.personalAreaProduccionList}"
                                                     var="data" headerClass="headerClassACliente" id="dataAreaPersonal">
                                         <f:facet name="header">
                                             <rich:columnGroup>
                                                 <rich:column>
                                                     <h:outputText value="Area Empresa"/>
                                                 </rich:column>
                                                 <rich:column>
                                                     <h:outputText value="Estado Registro"/>
                                                 </rich:column>

                                             </rich:columnGroup>
                                         </f:facet>
                                            <rich:column>
                                                <h:outputText value="#{data.areasEmpresa.nombreAreaEmpresa}"/>
                                            </rich:column>
                                             <rich:column>
                                                 <h:selectOneMenu value="#{data.estadosPersonalAreaProduccion.codEstadoPersonalAreaProduccion}" styleClass="inputText">
                                                     <f:selectItems value="#{ManagedPersonalAreasProduccion.estadosPersonalAreaSelectList}"/>
                                                 </h:selectOneMenu>
                                             </rich:column>
                                     </rich:dataTable>
                                </div>
                                    <a4j:commandButton styleClass="btn" value="Guardar" 
                                                       action="#{ManagedPersonalAreasProduccion.guardarEditarPersonalAreaProduccion_action}"
                                                  reRender="dataPersonalArea"
                                                  oncomplete="if(#{ManagedPersonalAreasProduccion.mensaje eq '1'}){alert('Se registro la asignación de areas');javascript:Richfaces.hideModalPanel('panelEditarArea');}
                                                  else{alert('#{ManagedPersonalAreasProduccion.mensaje}')}" />
                                    <a4j:commandButton value="Cancelar" styleClass="btn" oncomplete="Richfaces.hideModalPanel('panelEditarArea')"
                                                       action="#{ManagedPersonalAreasProduccion.buscarPersonalAreaProduccion_action}" reRender="dataPersonalArea"/>
                               </center>
                           </h:panelGroup>
                           </a4j:form>
                   </rich:modalPanel>     
                    <rich:modalPanel id="panelCambioArea" minHeight="290"  minWidth="600"
                                     height="290" width="600"  zindex="200"  headerClass="headerClassACliente"
                                     resizeable="false"  >
                        <f:facet name="header">
                            <h:outputText value="<center><b>Registro Personal Temporal</b></center>" escape="false"/>
                        </f:facet>
                        <a4j:form id="form2">
                         <h:panelGroup id="contenidoCambioArea">
                             <center>
                             <h:panelGrid columns="3">
                                    <h:outputText value="Nombre Personal" styleClass="outputText2" style="font-weight:bold" />
                                    <h:outputText value="::" styleClass="outputText2" style="font-weight:bold" />
                                    <h:outputText value="#{ManagedPersonalAreasProduccion.personalAreaProduccionBean.personal.nombreCompletoPersonal}" styleClass="outputText2"  />
                                    <h:outputText value="Tipo Personal" styleClass="outputText2" style="font-weight:bold" />
                                    <h:outputText value="::" styleClass="outputText2" style="font-weight:bold" />
                                    <h:outputText value="PLANTA" styleClass="outputText2"  rendered="#{ManagedPersonalAreasProduccion.personalAreaProduccionBean.personal.codPersonal>0}" />
                                    <h:outputText value="TEMPORAL" styleClass="outputText2"  rendered="#{ManagedPersonalAreasProduccion.personalAreaProduccionBean.personal.codPersonal<0}" />
                                    <h:outputText value="Area Empresa Actual" styleClass="outputText2" style="font-weight:bold" />
                                    <h:outputText value="::" styleClass="outputText2" style="font-weight:bold" />
                                    <h:outputText value="#{ManagedPersonalAreasProduccion.personalAreaProduccionBean.areasEmpresa.nombreAreaEmpresa}" styleClass="outputText2"  />
                                    <h:outputText value="Fecha Inicio" styleClass="outputText2" style="font-weight:bold" />
                                    <h:outputText value="::" styleClass="outputText2" style="font-weight:bold" />
                                    <h:outputText value="#{ManagedPersonalAreasProduccion.personalAreaProduccionBean.fechaInicio}" styleClass="outputText2">
                                        <f:convertDateTime pattern="dd/MM/yyyy HH:mm"/>
                                    </h:outputText>
                                    <h:outputText value="Area Empresa Destino" styleClass="outputText2" style="font-weight:bold" />
                                    <h:outputText value="::" styleClass="outputText2" style="font-weight:bold" />
                                    <h:selectOneMenu value="#{ManagedPersonalAreasProduccion.personalAreaProduccionBean.areasEmpresa.codAreaEmpresa}" styleClass="inputText">
                                        <f:selectItems value="#{ManagedPersonalAreasProduccion.areasEmpresaSelectList}"/>
                                    </h:selectOneMenu>
                                    <h:outputText value="Estado Persona" styleClass="outputText2" style="font-weight:bold" />
                                    <h:outputText value="::" styleClass="outputText2" style="font-weight:bold" />
                                    <h:selectOneMenu value="#{ManagedPersonalAreasProduccion.personalAreaProduccionBean.estadosPersonalAreaProduccion.codEstadoPersonalAreaProduccion}" styleClass="inputText">
                                        <f:selectItems value="#{ManagedPersonalAreasProduccion.estadosPersonalAreaSelectList}"/>
                                    </h:selectOneMenu>
                                    <h:outputText value="Operario Generico" styleClass="outputText2" style="font-weight:bold" />
                                    <h:outputText value="::" styleClass="outputText2" style="font-weight:bold" />
                                    <h:selectBooleanCheckbox value="#{ManagedPersonalAreasProduccion.personalAreaProduccionBean.operarioGenerico}"/>
                                    <h:outputText value="Comentario Cambio" styleClass="outputText2" style="font-weight:bold" />
                                    <h:outputText value="::" styleClass="outputText2" style="font-weight:bold" />
                                    <h:inputTextarea value="#{ManagedPersonalAreasProduccion.comentarioCambio}" styleClass="inputText" cols="60" rows="4"/>
                             </h:panelGrid>

                                 <a4j:commandButton styleClass="btn" value="Guardar" 
                                               action="#{ManagedPersonalAreasProduccion.guardarCambioAreaEstadoPersonal_action}"
                                               reRender="dataPersonalArea"
                                               oncomplete="if(#{ManagedPersonalAreasProduccion.mensaje eq '1'}){alert('Se registro la asignación de areas');javascript:Richfaces.hideModalPanel('panelCambioArea');}
                                               else{alert('#{ManagedPersonalAreasProduccion.mensaje}')}" />
                            <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('panelCambioArea')" class="btn" />
                            </center>
                        </h:panelGroup>
                        </a4j:form>
                </rich:modalPanel>
                <rich:modalPanel id="panelAsignarAreaNuevoPersonal" minHeight="350"  minWidth="600" 
                                     height="350" width="600"  zindex="200"  headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="<center><b>Personal sin Area</b></center>" escape="false"/>
                        </f:facet>
                        <a4j:form id="form3">
                         <h:panelGroup id="contenidoAsignarAreaNuevoPersonal">
                             <center>
                            <div style='height:250px;overflow-y: auto'>
                                 <rich:dataTable value="#{ManagedPersonalAreasProduccion.personalAreaProduccionAgregarList}"
                                                 var="data" headerClass="headerClassACliente" id="dataPersonalNuevo">
                                     <f:facet name="header">
                                         <rich:columnGroup>
                                             <rich:column>
                                                 <h:outputText value=""/>
                                             </rich:column>
                                             <rich:column>
                                                 <h:outputText value="Nombre Persona"/>
                                             </rich:column>
                                             <rich:column>
                                                 <h:outputText value="Area Empresa"/>
                                             </rich:column>
                                         </rich:columnGroup>
                                     </f:facet>
                                     <rich:column>
                                         <h:selectBooleanCheckbox value="#{data.checked}"/>
                                     </rich:column>
                                     <rich:column>
                                         <h:outputText value="#{data.personal.nombrePersonal}"/>
                                     </rich:column>
                                     <rich:column>
                                         <h:selectOneMenu value="#{data.areasEmpresa.codAreaEmpresa}">
                                             <f:selectItems value="#{ManagedPersonalAreasProduccion.areasEmpresaSelectList}"/>
                                         </h:selectOneMenu>
                                     </rich:column>
                                 </rich:dataTable>
                            </div>
                            <a4j:commandButton styleClass="btn" value="Guardar" onclick="if(!editarVariosItems('form3:dataPersonalNuevo')){return false;}"
                                               action="#{ManagedPersonalAreasProduccion.guardarNuevoPersonalAreaProduccion_action}"
                                               reRender="dataPersonalArea"
                                               oncomplete="if(#{ManagedPersonalAreasProduccion.mensaje eq '1'}){alert('Se registraron las areas correspondientes a los usuarios');javascript:Richfaces.hideModalPanel('panelAsignarAreaNuevoPersonal');}
                                               else{'#{ManagedPersonalAreasProduccion.mensaje}'}" />
                            <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('panelAsignarAreaNuevoPersonal')" class="btn" />
                            </center>
                        </h:panelGroup>
                        </a4j:form>
                </rich:modalPanel>
        <a4j:include viewId="/panelProgreso.jsp"/>
        <a4j:include viewId="/message.jsp"/>
            
        </body>
    </html>
    
</f:view>

