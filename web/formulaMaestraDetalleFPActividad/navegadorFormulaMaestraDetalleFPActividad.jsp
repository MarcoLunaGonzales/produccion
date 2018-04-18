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
                function getCodigo(cod_maquina,codigo){
                 //  alert(codigo);
                   location='../partes_maquinaria/navegador_partes_maquinaria.jsf?cod_maquina='+cod_maquina+'&codigo='+codigo;
                }
                
                function editarItem(nametable){
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
                   if(count==1){
                      return true;
                   } else if(count==0){
                       alert('No escogio ningun registro');
                       return false;
                   }
                   else if(count>1){
                       alert('Solo puede escoger un registro');
                       return false;
                   }                                      
                }


                function asignar(nametable){

                   var count=0;
                   var elements=document.getElementById(nametable);
                   var rowsElement=elements.rows;
                   for(var i=1;i<rowsElement.length;i++){
                    var cellsElement=rowsElement[i].cells;
                    var cel=cellsElement[0];
                    alert('hola');
                    if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                          if(cel.getElementsByTagName('input')[0].checked){
                           count++;
                         }                         
                     }                      
                   }
                    if(count==0){
                       alert('No selecciono ningun Registro');
                       return false;
                   }else{
                       if(confirm('Desea Asignar como Area Raiz')){
                            if(confirm('Esta seguro de Asignar como Area Raiz')){
                                 return true;
                        }else{
                            return false;
                        }
                    }else{
                        return false;
                    }
                   
                   }
                   
                }          
            function eliminar(nametable){
               var count1=0;
               var elements1=document.getElementById(nametable);
               var rowsElement1=elements1.rows;
               //alert(rowsElement1.length);            
               for(var i=1;i<rowsElement1.length;i++){
                    var cellsElement1=rowsElement1[i].cells;
                    var cel1=cellsElement1[0];
                    if(cel1.getElementsByTagName('input').length>0){
                        if(cel1.getElementsByTagName('input')[0].type=='checkbox'){
                          if(cel1.getElementsByTagName('input')[0].checked){
                               count1++;
                           }
                        }
                    }
                    
               }
               //alert(count1);
               if(count1==0){
                    alert('No escogio ningun registro');
                    return false;
               }else{
                
                            var count=0;
                            var elements=document.getElementById(nametable);
                            var rowsElement=elements.rows;
                            
                            for(var i=0;i<rowsElement.length;i++){
                                var cellsElement=rowsElement[i].cells;
                                var cel=cellsElement[0];
                                if(cel.getElementsByTagName('input').length>0){
                                    if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                                        if(cel.getElementsByTagName('input')[0].checked){
                                            count++;
                                        }
                                    }
                                }

                            }
                            if(count==0){
                            //alert('No escogio ningun registro');
                            return false;
                            }
                            //var cantidadeliminar=document.getElementById('form1:cantidadeliminar');
                            //cantidadeliminar.value=count;
                            return true;
                    
                }
           }                

           function validarSeleccion(nametable){
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
                   if(count==1){
                      return true;
                   } else if(count==0){
                       alert('No escogio ningun registro');
                       return false;
                   }
                   else if(count>1){
                       alert('Solo puede escoger un registro');
                       return false;
                   }
                }
        function verManteminiento(cod_maquina,codigo){                 
                   location='../partes_maquinaria/navegador_partes_maquinaria.jsf?cod_maquina='+cod_maquina+'&codigo='+codigo;
        }
       </script>
        </head>
        <body >
            <a4j:form id="form1">
                <div align="center">
                    <h:outputText value="#{ManagedFormulaMaestraDetalleFPActividad.cargarContenidoFormulaMaestraDetalleFPActividad}"/>
                    <h:outputText styleClass="outputTextTitulo"  value="Listado de Actividades de Formula Maestra" />
                    <br><br>

                    <rich:dataTable value="#{ManagedFormulaMaestraDetalleFPActividad.formulaMaestraDetalleFPActividadList}" var="data"
                                    id="dataFormulaMaestraFPActividad"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';" 
                                    headerClass="headerClassACliente" binding="#{ManagedFormulaMaestraDetalleFPActividad.formulaMaestrasDetalleFPActividadDataTable}" >
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value=""  />                                
                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.checked}"  />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Actividad"  />
                            </f:facet>
                            <h:outputText value="#{data.descripcionActividad}" />
                        </h:column>                        
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Duracion (min)"  />
                            </f:facet>
                            <h:outputText value="#{data.tiempoActividad}" />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Nro Repeticiones"  />
                            </f:facet>
                            <h:outputText value="#{data.nroRepeticiones}" />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Observacion"  />
                            </f:facet>
                            <h:outputText value="#{data.observacion}" />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="1ra Temperatura"  />
                            </f:facet>
                            <h:outputText value="#{data.temperaturaFinal1}" />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="2da Temperatura"  />
                            </f:facet>
                            <h:outputText value="#{data.temperaturaFinal2}" />
                        </h:column>

                        <h:column>
                            <f:facet name="header">
                                <h:outputText value=" Materiales de Actividad "  />
                            </f:facet>
                            <a4j:commandLink action="#{ManagedFormulaMaestraDetalleFPActividad.verFormulaMaestraDetalleFPActividadMaterial_action}" >
                                <h:graphicImage value="../img/organigrama3.jpg" />
                            </a4j:commandLink>                            
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value=" Maquinarias de Actividad "  />
                            </f:facet>
                            <a4j:commandLink action="#{ManagedFormulaMaestraDetalleFPActividad.verFormulaMaestraDetalleFPActividadMaquinaria_action}" >
                                <h:graphicImage value="../img/organigrama3.jpg" />
                            </a4j:commandLink>
                        </h:column>
                    </rich:dataTable>
                    <%-- <ws:datascroller fordatatable="dataAreasEmpresa"  />--%>
                    <br>                    
                    <a4j:commandButton value="Agregar" styleClass="btn" onclick="javascript:Richfaces.showModalPanel('panelAgregarFormulaMaestraDetalleFPActividad')"
                    action="#{ManagedFormulaMaestraDetalleFPActividad.agregarFormulaMaestraDetalleFPActividad_action}"
                    reRender="contenidoAgregarFormulaMaestraDetalleFPActividad" />
                    <a4j:commandButton value="Editar"  styleClass="btn" onclick="javascript:if(validarSeleccion('form1:dataFormulaMaestraFPActividad')==false){return false;}else{Richfaces.showModalPanel('panelEditarFormulaMaestraDetalleFPActividad')}"
                    action="#{ManagedFormulaMaestraDetalleFPActividad.editarFormulaMaestraDetalleFPActividad_action}"
                    reRender="contenidoEditarFormulaMaestraDetalleFPActividad" />
                    <a4j:commandButton value="Eliminar"  styleClass="btn" onclick="javascript:if(confirm('Esta Seguro de Eliminar??')==false || validarSeleccion('form1:dataFormulaMaestraFPActividad')==false){return false;}"
                    action="#{ManagedFormulaMaestraDetalleFPActividad.eliminarFormulaMaestraDetalleFPActividad_action}"
                    reRender="dataFormulaMaestraFPActividad"/>
                    <a4j:commandButton styleClass="btn" value="Cancelar" onclick="location='../formulaMaestraDetalleFP/navegadorFormulaMaestraDetalleFP.jsf'" />

                </div>
                <!--cerrando la conexion-->
                <h:outputText value="#{ManagedFrecuenciaMantenimientoMaquinaria.closeConnection}"  />
                
            </a4j:form>



             <rich:modalPanel id="panelAgregarFormulaMaestraDetalleFPActividad" minHeight="150"  minWidth="400"
                                     height="280" width="500"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Actividad Formula Maestra"/>
                        </f:facet>
                        <a4j:form>
                        <h:panelGroup id="contenidoAgregarFormulaMaestraDetalleFPActividad">
                            <h:panelGrid columns="3">
                                <h:outputText value="Descripcion" styleClass="outputText1" />
                                <h:outputText value="::" styleClass="outputText1" />
                                <h:inputTextarea value="#{ManagedFormulaMaestraDetalleFPActividad.formulaMaestraDetalleFPActividad.descripcionActividad}" styleClass="inputText" rows="4" cols="50" />

                                <h:outputText value="Tiempo Actividad" styleClass="outputText1" />
                                <h:outputText value="::" styleClass="outputText1" />
                                <h:inputText value="#{ManagedFormulaMaestraDetalleFPActividad.formulaMaestraDetalleFPActividad.tiempoActividad}" styleClass="inputText"/>

                                <h:outputText value="Nro Repeticiones" styleClass="outputText1" />
                                <h:outputText value="::" styleClass="outputText1" />
                                <h:inputText value="#{ManagedFormulaMaestraDetalleFPActividad.formulaMaestraDetalleFPActividad.nroRepeticiones}" styleClass="inputText"/>

                                <h:outputText value="Observacion" styleClass="outputText1" />
                                <h:outputText value="::" styleClass="outputText1" />
                                <h:inputTextarea value="#{ManagedFormulaMaestraDetalleFPActividad.formulaMaestraDetalleFPActividad.observacion}" styleClass="inputText" rows="4" cols="50" />
                                

                                <h:outputText value="1ra Temeperatura" styleClass="outputText1" />
                                <h:outputText value="::" styleClass="outputText1" />
                                <h:inputText value="#{ManagedFormulaMaestraDetalleFPActividad.formulaMaestraDetalleFPActividad.temperaturaFinal1}" styleClass="inputText"/>
                                
                                <h:outputText value="2da Temeperatura" styleClass="outputText1" />
                                <h:outputText value="::" styleClass="outputText1" />
                                <h:inputText value="#{ManagedFormulaMaestraDetalleFPActividad.formulaMaestraDetalleFPActividad.temperaturaFinal2}" styleClass="inputText"/>
                                
                            </h:panelGrid>
                                <div align="center">
                                <a4j:commandButton styleClass="btn" value="Registrar" onclick="javascript:Richfaces.hideModalPanel('panelAgregarformulaMaestraDetalleFPActividad');"
                                action="#{ManagedFormulaMaestraDetalleFPActividad.registrarFormulaMaestraDetalleFPActividad_action}" reRender="dataFormulaMaestraFPActividad"
                                                    />                                
                                <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('panelAgregarformulaMaestraDetalleFPActividad')" class="btn" />
                                </div>
                        </h:panelGroup>
                        </a4j:form>
            </rich:modalPanel>

            <rich:modalPanel id="panelEditarFormulaMaestraDetalleFPActividad" minHeight="150"  minWidth="400"
                                     height="280" width="500"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Editar Fase Formula Maestra"/>
                        </f:facet>
                        <a4j:form>
                        <h:panelGroup id="contenidoEditarFormulaMaestraDetalleFPActividad">
                            <h:panelGrid columns="3">
                                <h:outputText value="Descripcion" styleClass="outputText1" />
                                <h:outputText value="::" styleClass="outputText1" />
                                <h:inputTextarea value="#{ManagedFormulaMaestraDetalleFPActividad.formulaMaestraDetalleFPActividad.descripcionActividad}" styleClass="inputText" rows="4" cols="50" />

                                <h:outputText value="Tiempo Actividad" styleClass="outputText1" />
                                <h:outputText value="::" styleClass="outputText1" />
                                <h:inputText value="#{ManagedFormulaMaestraDetalleFPActividad.formulaMaestraDetalleFPActividad.tiempoActividad}" styleClass="inputText"/>

                                <h:outputText value="Nro Repeticiones" styleClass="outputText1" />
                                <h:outputText value="::" styleClass="outputText1" />
                                <h:inputText value="#{ManagedFormulaMaestraDetalleFPActividad.formulaMaestraDetalleFPActividad.nroRepeticiones}" styleClass="inputText"/>

                                <h:outputText value="Observacion" styleClass="outputText1" />
                                <h:outputText value="::" styleClass="outputText1" />
                                <h:inputTextarea value="#{ManagedFormulaMaestraDetalleFPActividad.formulaMaestraDetalleFPActividad.observacion}" styleClass="inputText" rows="4" cols="50" />


                                <h:outputText value="1ra Temeperatura" styleClass="outputText1" />
                                <h:outputText value="::" styleClass="outputText1" />
                                <h:inputText value="#{ManagedFormulaMaestraDetalleFPActividad.formulaMaestraDetalleFPActividad.temperaturaFinal1}" styleClass="inputText"/>

                                <h:outputText value="2da Temeperatura" styleClass="outputText1" />
                                <h:outputText value="::" styleClass="outputText1" />
                                <h:inputText value="#{ManagedFormulaMaestraDetalleFPActividad.formulaMaestraDetalleFPActividad.temperaturaFinal2}" styleClass="inputText"/>

                            </h:panelGrid>
                                <div align="center">
                                <a4j:commandButton styleClass="btn" value="Guardar" onclick="javascript:Richfaces.hideModalPanel('panelEditarformulaMaestraDetalleFPActividad');"
                                action="#{ManagedFormulaMaestraDetalleFPActividad.guardarEdicionFormulaMaestraFPActividad_action}" reRender="dataFormulaMaestraFPActividad"
                                                    />
                                <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('panelEditarformulaMaestraDetalleFPActividad')" class="btn" />
                                </div>
                        </h:panelGroup>
                        </a4j:form>
            </rich:modalPanel>

        </body>
    </html>
    
</f:view>

