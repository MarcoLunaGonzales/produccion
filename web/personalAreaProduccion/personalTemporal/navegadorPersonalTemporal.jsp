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
        <%--<body onLoad="window.defaultStatus='Hola, yo soy la barra de estado.';">--%>
            
            <body>
            <a4j:form id="form1">
                
                <center>
                    <h:outputText value="Personal Temporal"  styleClass="outputText2" style="font-weight:bold;font-size:1.5em"/>
                    <br><br>
                        <h:outputText value="#{ManagedPersonalTemporal.cargarPersonalTemporal}"  />
                        <rich:panel headerClass="headerClassACliente" style="width:60%">
                            <f:facet name="header">
                                <h:outputText value="Personal Temporal"/>
                            </f:facet>
                            <h:panelGrid columns="6">
                                <h:outputText value="Ap. Paterno" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                <h:inputText value="#{ManagedPersonalTemporal.personalTemporalBuscar.apellidoPaterno}" styleClass="inputText"/>
                                <h:outputText value="Ap. Materno" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                <h:inputText value="#{ManagedPersonalTemporal.personalTemporalBuscar.apellidoMaterno}" styleClass="inputText"/>
                                <h:outputText value="Nombre" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                <h:inputText value="#{ManagedPersonalTemporal.personalTemporalBuscar.nombrePersonal}" styleClass="inputText"/>
                                <h:outputText value="Segundo Nombre" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                <h:inputText value="#{ManagedPersonalTemporal.personalTemporalBuscar.nombre2personal}" styleClass="inputText"/>
                                <h:outputText value="Area Inicial" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                <h:selectOneMenu value="#{ManagedPersonalTemporal.personalTemporalBuscar.areasEmpresa.codAreaEmpresa}" styleClass="inputText">
                                    <f:selectItem  itemValue="0" itemLabel="--TODOS--"/>
                                    <f:selectItems value="#{ManagedPersonalTemporal.areasEmpresaSelectList}"/>
                                </h:selectOneMenu>
                            </h:panelGrid>
                            <a4j:commandButton value="BUSCAR" action="#{ManagedPersonalTemporal.buscarPersonalTemporal_action}" reRender="dataPersonalTemporal" styleClass="btn"/>
                        </rich:panel>
                        
                        <rich:dataTable value="#{ManagedPersonalTemporal.personalTemporalList}" var="data" id="dataPersonalTemporal"
                        onRowMouseOut="this.style.backgroundColor='#FFFFFF';" style="margin-top:1em"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente">
                           <rich:column>
                            <f:facet name="header">
                                <h:outputText value="" id="headerCheck" />
                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.checked}" />
                        </rich:column>
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value="Apellido<br>Paterno" escape="false"  />
                            </f:facet>
                            <h:outputText value="#{data.apellidoPaterno}"  />
                        </rich:column>
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value="Apellido<br>Materno" escape="false"  />
                            </f:facet>
                            <h:outputText value="#{data.apellidoMaterno}"  />
                        </rich:column>
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value="Nombre" escape="false"  />
                            </f:facet>
                            <h:outputText value="#{data.nombrePersonal}"  />
                        </rich:column>
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value="Segundo<br>Nombre" escape="false"  />
                            </f:facet>
                            <h:outputText value="#{data.nombre2personal}"  />
                        </rich:column>
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value="Area<br>Empresa<br>Inicial" escape="false"  />
                            </f:facet>
                            <h:outputText value="#{data.areasEmpresa.nombreAreaEmpresa}"  />
                        </rich:column>
                        
                         </rich:dataTable>
                         <div style="margin-top:1em;">
                             <a4j:commandButton value="Agregar" styleClass="btn" oncomplete="Richfaces.showModalPanel('panelAgregarPersonal')"
                             action="#{ManagedPersonalTemporal.agregarPersonalTemporal_action}" reRender="contenidoAgregarPersonal,codAreaEmpresaTemporal"/>
                             <a4j:commandButton value="Editar" styleClass="btn" oncomplete="Richfaces.showModalPanel('panelEditarPersonal')" action="#{ManagedPersonalTemporal.editarPersonalTemporal_action}"
                             reRender="contenidoEditarPersonal" onclick="if(!editarItem('form1:dataPersonalTemporal')){return false;}" />
                             <a4j:commandButton value="Eliminar" styleClass="btn" action="#{ManagedPersonalTemporal.eliminarPersonalTemporal_action}"
                             oncomplete="if(#{ManagedPersonalTemporal.mensaje eq '1'}){alert('Se Elimino el personal temporal');}else{alert('#{ManagedPersonalTemporal.mensaje}');}"
                             reRender="dataPersonalTemporal"  onclick="if(!editarItem('form1:dataPersonalTemporal')){return false;}"/>
                         </div>
                    </center>
                         </a4j:form>
                    <rich:modalPanel id="panelAgregarPersonal" minHeight="220"  minWidth="600"
                                     height="220" width="600"  zindex="200"  headerClass="headerClassACliente"
                                     resizeable="false" >
                        <f:facet name="header">
                            <h:outputText value="<center><b>Registro Personal Temporal</b></center>" escape="false"/>
                        </f:facet>
                        <a4j:form id="form2">
                         <h:panelGroup id="contenidoAgregarPersonal">
                             <center>
                             <h:panelGrid columns="3">
                                    <h:outputText value="Apellido Paterno" styleClass="outputText2" style="font-weight:bold" />
                                    <h:outputText value="::" styleClass="outputText2" style="font-weight:bold" />
                                    <h:inputText onkeypress="valMAY();" value="#{ManagedPersonalTemporal.personalTemporalNuevo.apellidoPaterno}"  styleClass="inputText"  id="apPaternoTemporal"/>
                                    <h:outputText value="Apellido Materno" styleClass="outputText2" style="font-weight:bold" />
                                    <h:outputText value="::" styleClass="outputText2" style="font-weight:bold" />
                                    <h:inputText onkeypress="valMAY();" value="#{ManagedPersonalTemporal.personalTemporalNuevo.apellidoMaterno}" styleClass="inputText" id="apMaternoTemporal"  />
                                    <h:outputText value="Nombre" styleClass="outputText2" style="font-weight:bold" />
                                    <h:outputText value="::" styleClass="outputText2" style="font-weight:bold" />
                                    <h:inputText onkeypress="valMAY();" value="#{ManagedPersonalTemporal.personalTemporalNuevo.nombrePersonal}" styleClass="inputText" id="nombrePersonalTemporal" />
                                    <h:outputText value="Segundo Nombre" styleClass="outputText2" style="font-weight:bold" />
                                    <h:outputText value="::" styleClass="outputText2" style="font-weight:bold" />
                                    <h:inputText onkeypress="valMAY();" value="#{ManagedPersonalTemporal.personalTemporalNuevo.nombre2personal}" styleClass="inputText" id="segundoNOmbre" />
                                    <h:outputText value="Area" styleClass="outputText2" style="font-weight:bold" />
                                    <h:outputText value="::" styleClass="outputText2" style="font-weight:bold" />
                                    <h:selectOneMenu value="#{ManagedPersonalTemporal.personalTemporalNuevo.areasEmpresa.codAreaEmpresa}" styleClass="inputText" id="codAreaEmpresaTemporal" >
                                        <f:selectItems value="#{ManagedPersonalTemporal.areasEmpresaSelectList}"/>
                                    </h:selectOneMenu>
                             </h:panelGrid>

                            <a4j:commandButton styleClass="btn" value="Guardar" 
                                               action="#{ManagedPersonalTemporal.guardarNuevoPersonalTemporal_action}"
                                               reRender="dataPersonalTemporal" 
                                               oncomplete="if(#{ManagedPersonalTemporal.mensaje eq '1'}){alert('Se registro el personal temporal');javascript:Richfaces.hideModalPanel('panelAgregarPersonal');}
                                               else{alert('#{ManagedPersonalTemporal.mensaje}');}" />
                            <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('panelAgregarPersonal')" class="btn" />
                            </center>
                        </h:panelGroup>
                        </a4j:form>
                </rich:modalPanel>
                <rich:modalPanel id="panelEditarPersonal" minHeight="180"  minWidth="400"
                                     height="180" width="400"  zindex="200"  headerClass="headerClassACliente"
                                     resizeable="false" >
                        <f:facet name="header">
                            <h:outputText value="<center><b>Edicion de Personal Temporal</b></center>" escape="false"/>
                        </f:facet>
                        <a4j:form id="form3">
                         <h:panelGroup id="contenidoEditarPersonal">
                             <center>
                             <h:panelGrid columns="3">
                                    <h:outputText value="Apellido Paterno" styleClass="outputText2" style="font-weight:bold" />
                                    <h:outputText value="::" styleClass="outputText2" style="font-weight:bold" />
                                    <h:inputText value="#{ManagedPersonalTemporal.personalTemporalEditar.apellidoPaterno}"  styleClass="inputText"  id="eapPaternoTemporal"/>
                                    <h:outputText value="Apellido Materno" styleClass="outputText2" style="font-weight:bold" />
                                    <h:outputText value="::" styleClass="outputText2" style="font-weight:bold" />
                                    <h:inputText value="#{ManagedPersonalTemporal.personalTemporalEditar.apellidoMaterno}" styleClass="inputText" id="eapMaternoTemporal"  />
                                    <h:outputText value="Nombre" styleClass="outputText2" style="font-weight:bold" />
                                    <h:outputText value="::" styleClass="outputText2" style="font-weight:bold" />
                                    <h:inputText value="#{ManagedPersonalTemporal.personalTemporalEditar.nombrePersonal}" styleClass="inputText" id="enombrePersonalTemporal" />
                                    <h:outputText value="Segundo Nombre" styleClass="outputText2" style="font-weight:bold" />
                                    <h:outputText value="::" styleClass="outputText2" style="font-weight:bold" />
                                    <h:inputText value="#{ManagedPersonalTemporal.personalTemporalEditar.nombre2personal}" styleClass="inputText" id="esegundoNOmbre" />
                             </h:panelGrid>

                            <a4j:commandButton styleClass="btn" value="Guardar"  
                                               action="#{ManagedPersonalTemporal.guardarEdicionPersonalTemporal_action}"
                                               reRender="dataPersonalTemporal" oncomplete="if(#{ManagedPersonalTemporal.mensaje eq '1'}){alert('Se guardo la edicion');javascript:Richfaces.hideModalPanel('panelEditarPersonal');}
                                               else{alert('#{ManagedPersonalTemporal.mensaje}');}" />
                            <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('panelEditarPersonal')" class="btn" />
                            </center>
                        </h:panelGroup>
                        </a4j:form>
                </rich:modalPanel>
                <a4j:status id="statusPeticion"
                                onstart="Richfaces.showModalPanel('ajaxLoadingModalBox',{width:100, top:100})"
                                onstop="Richfaces.hideModalPanel('ajaxLoadingModalBox')">
         </a4j:status>

                    <rich:modalPanel id="ajaxLoadingModalBox" minHeight="100"
                                     minWidth="200" height="80" width="400" zindex="400" onshow="window.focus();">

                        <div align="center">
                            <h:graphicImage value="../../img/load2.gif" />
                        </div>
                    </rich:modalPanel>
        </body>
    </html>
    
</f:view>

